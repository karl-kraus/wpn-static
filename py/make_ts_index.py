import glob
import json
import os

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext
from tqdm import tqdm


# schema_name = "walpurgisnacht"
## during development
schema_name = "walpurgisnacht_umschrift"

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
        {'name': 'witness', 'type': 'string', 'facet': True, 'optional': True},
    ],
    "default_sorting_field": "order"
}


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
count = 1
files = glob.glob("./data/merged/*.html")
for x in tqdm(sorted(files, key=lambda x: os.path.basename(x).split("_")[-1].split(".")[0].zfill(4)), total=len(files)):
    doc = TeiReader(x)
    body = doc.any_xpath(".//body")
    cfts_record = {
        "project": "WPN Static-Site",
    }
    record = {}
    record["witness"] = "Karl Kraus 1933 – Dritte Walpurgisnacht"
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
    print(f"{r_title}, Karl Kraus 1933 – Dritte Walpurgisnacht")
    record["title"] = f"{r_title}, Karl Kraus 1933 – Dritte Walpurgisnacht"
    cfts_record["title"] = record["title"]
    # get unique persons per page
    '''ent_type = "persons"
    ent_name = "persName"
    ent_node = "span"
    record["persons"] = get_entities(
        ent_type=ent_type, ent_node=ent_node, ent_name=ent_name
    )'''
    record["order"] = 0 if "motti" in r_title else int(count)
    # cfts_record["persons"] = record["persons"]
    record["full_text"] = "\n".join(
        " ".join("".join(p.itertext()).split()) for p in body
    )
    if len(record["full_text"]) > 0:
        records.append(record)
        cfts_record["full_text"] = record["full_text"]
        cfts_records.append(cfts_record)
        if "motti" not in r_title:
            count += 1

files = glob.glob("./data/edition*/wit-*.xml")
for x in tqdm(sorted(files, key=lambda x: os.path.basename(x)), total=len(files)):
    if os.path.basename(x) == "wit-DffH-0266_a.xml":
        continue
    doc = TeiReader(x)
    pb = doc.any_xpath(".//tei:pb")[0]
    body = doc.any_xpath(".//tei:body")
    facsimile = doc.any_xpath('.//tei:facsimile')[0].attrib["corresp"].replace("#", "")
    witness_title = " ".join(doc.any_xpath(f'.//tei:sourceDesc[@xml:id="{facsimile}"]//tei:msItem/tei:title//text()'))
    cfts_record = {
        "project": "WPN Static-Site Umschrift",
    }
    record = {}
    record["witness"] = witness_title
    rec_id = os.path.basename(x).split(".")[0]
    record["id"] = f"{rec_id}.html"
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = {record['id']}
    record["rec_id"] = record["id"]
    cfts_record["rec_id"] = record["rec_id"]
    # regex to remove non-digit characters
    page_no = int("".join(filter(str.isdigit, rec_id.split("-")[-1])))
    page_str = str("".join(filter(str.isalpha, rec_id.split("-")[-1])))
    r_title = f"Seite {page_no}{page_str}, {witness_title}"
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
    record["order"] = int(count)
    # cfts_record["persons"] = record["persons"]
    record["full_text"] = extract_fulltext(body[0])
    if len(record["full_text"]) > 0:
        records.append(record)
        cfts_record["full_text"] = record["full_text"]
        cfts_records.append(cfts_record)
        count += 1


with open(f"./data/{schema_name}.json", "w") as f:
    json.dump(records, f, ensure_ascii=False, indent=2)


try:
    client.collections[schema_name].delete()
except ObjectNotFound:
    pass

client.collections.create(current_schema)

make_index = client.collections[
    schema_name
].documents.import_(records, {"action": "upsert"})
print(make_index)
print(f"done with indexing {schema_name}")
