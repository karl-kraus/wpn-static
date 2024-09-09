import glob
import os

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_tei_pyutils.tei import TeiReader
from tqdm import tqdm


schema_name = "walpurgisnacht"

files = glob.glob("./data/merged/*.html")


try:
    client.collections[schema_name].delete()
except ObjectNotFound:
    pass

current_schema = {
    "name": schema_name,
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string"},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {
            "name": "year",
            "type": "int32",
            "optional": True,
            "facet": True,
        },
        {"name": "persons", "type": "string[]", "facet": True, "optional": True},
        {"name": "quotes", "type": "string[]", "facet": True, "optional": True},
        {'name': 'order', 'type': 'int32', 'facet': False},
    ],
    "default_sorting_field": "order"
}

client.collections.create(current_schema)


def get_entities(ent_type, ent_node, ent_name):
    entities = []
    e_path = f'.//span[contains(@class,"{ent_type}")]/@id'
    for p in body:
        ent = p.xpath(e_path)
        ref = [ref.replace("#", "")
               for e in ent if len(ent) > 0 for ref in e.split()]
        for r in ref:
            p_path = f'.//tei:{ent_node}[@xml:id="{r}"]//tei:{ent_name}[1]'
            en = doc.any_xpath(p_path)
            if en:
                entity = " ".join(" ".join(en[0].xpath(".//text()")).split())
                if len(entity) != 0:
                    entities.append(entity)
                else:
                    with open("log-entities.txt", "a") as f:
                        f.write(f"{r} in {record['id']}\n")
    return [ent for ent in sorted(set(entities))]


records = []
cfts_records = []
for x in tqdm(files, total=len(files)):
    doc = TeiReader(x)
    pages = 0
    pages += 1
    body = doc.any_xpath(".//body")
    cfts_record = {
        "project": "WPN Static-Site",
    }
    record = {}
    record["id"] = os.path.split(x)[-1]
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = {record['id']}
    record["rec_id"] = os.path.split(x)[-1]
    cfts_record["rec_id"] = record["rec_id"]
    r_title = " ".join(
        " ".join(
            doc.any_xpath('.//@data-label')
        ).split()
    )
    print(r_title)
    record["title"] = f"{r_title}"
    cfts_record["title"] = record["title"]
    # get unique persons per page
    '''ent_type = "persons"
    ent_name = "persName"
    ent_node = "span"
    record["persons"] = get_entities(
        ent_type=ent_type, ent_node=ent_node, ent_name=ent_name
    )'''
    record["order"] = 0 if "motti" in r_title else int(
        r_title.replace('Absatz ', ''))
    # cfts_record["persons"] = record["persons"]
    record["full_text"] = "\n".join(
        " ".join("".join(p.itertext()).split()) for p in body
    )
    if len(record["full_text"]) > 0:
        records.append(record)
        cfts_record["full_text"] = record["full_text"]
        cfts_records.append(cfts_record)

make_index = client.collections[
    schema_name
].documents.import_(records, {"action": "upsert"})
print(make_index)
print(f"done with indexing {schema_name}")
