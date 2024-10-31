import glob
import os
import tqdm
from acdh_tei_pyutils.tei import TeiReader


SOURCE_DIR = 'data/editions'
SOURCE_FILE = 'Gesamt.xml'
source = os.path.join(SOURCE_DIR, SOURCE_FILE)
source_glob = glob.glob(source)

NS = [
    ' xmlns="http://www.tei-c.org/ns/1.0"'
]

NSMAP = {
    "tei": "http://www.tei-c.org/ns/1.0",
    "xml": "http://www.w3.org/XML/1998/namespace",
}


def file_parser(file):
    with open(file, 'r') as f:
        text = f.read()
    return text


def replace_namespace(text):
    for ns in NS:
        text = text.replace(ns, '')
    return text


def handle_pb_with_lb_break(file):
    doc = TeiReader(file, xsl="./xslt/partials/typo-find-pb-lb-break.xsl")
    file = file.replace('.xml', '_pb_lb.xml')
    doc.tree_to_file(file)
    doc = TeiReader(file, xsl="./xslt/partials/typo-add-lb-break.xsl")
    doc.tree_to_file(file)
    return file


def add_graphic_url(file):
    doc = TeiReader(file)
    surface = doc.any_xpath('//tei:facsimile//tei:surface')
    count = 0
    for i, s in enumerate(surface):
        id = s.get('{http://www.w3.org/XML/1998/namespace}id')
        if id is not None and '_' in id:
            if "F" in id or "-" in id or "266_a" in id:
                continue
            count += 1
        idInteger = id.replace('idfacs', '').split('_')[0]
        if idInteger is not None:
            new_id = int(idInteger) + count
            url = f'iiif/images/wpn/{new_id:04d}'
            graphic = s.find('tei:graphic', namespaces=NSMAP)
            if graphic is not None:
                graphic.set('url', url)
            else:
                print(f'No graphic found for surface {i}')
        else:
            print(f'No id found for surface {i}')
    doc.tree_to_file(file)


if __name__ == '__main__':
    for file in tqdm.tqdm(source_glob, total=len(source_glob)):
        add_graphic_url(file)
        file = handle_pb_with_lb_break(file)
        text = file_parser(file)
        text = replace_namespace(text)
        output_path = os.path.join(
            SOURCE_DIR,
            os.path.basename(file).replace('_pb_lb.xml', '_modified.xml'))
        with open(output_path, 'w') as f:
            f.write(text)
