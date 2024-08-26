import glob
import os
import tqdm
import shutil
from acdh_tei_pyutils.tei import TeiReader

NS = [
    'xmlns="http://www.tei-c.org/ns/1.0"',
    '{http://www.w3.org/XML/1998/namespace}'
]
NSMAP = {
    "tei": "http://www.tei-c.org/ns/1.0",
    "xml": "http://www.w3.org/XML/1998/namespace"
}
INPUT_DIR = 'output'
INPUT_PROJECT_DIR = 'Gesamt_modified'
OUTPUT_DIR = os.path.join('data', 'editions', 'tmp')

files = os.path.join(INPUT_DIR, INPUT_PROJECT_DIR, '*.xml')
files_glob = glob.glob(files)


def file_parser(file):
    with open(file, 'r') as f:
        text = f.read()
    return text


def replace_namespace(text):
    for ns in NS:
        if ns == '{http://www.w3.org/XML/1998/namespace}':
            text = text.replace(ns, 'xml:')
        else:
            text = text.replace(ns, '')
    return text


def add_root_namesapce(text):
    text = text.replace(
        '<TEI continued="true">',
        '<TEI xmlns="http://www.tei-c.org/ns/1.0" continued="true">')
    return text


def verify_first_lb(file):
    doc = TeiReader(file)
    try:
        p_lb = doc.any_xpath('//tei:body//tei:p[@rendition]/tei:lb[1]')
        for lb in p_lb:
            lb.attrib['type'] = 'first'
    except IndexError:
        print(f'No lb found in p for {file}')
    try:
        seg_lb = doc.any_xpath('//tei:body//tei:seg[@rendition or @type="relocation"]/tei:lb[1]')
        for lb in seg_lb:
            lb.attrib['type'] = 'first'
    except IndexError:
        print(f'No lb found in seg for {file}')
    try:
        seg_lb_f890 = doc.any_xpath('//tei:body//tei:seg[parent::tei:p[@rendition]][@type="F890"]')
        for seg in seg_lb_f890:
            lb = seg.xpath('.//tei:lb', namespaces=NSMAP)
            print(len(lb), file)
            if len(lb) > 1:
                lb[0].attrib['type'] = 'first'
    except IndexError:
        print(f'No lb found in seg for {file}')
    doc.tree_to_file(file)


if __name__ == '__main__':
    debug = False
    for file in tqdm.tqdm(files_glob, total=len(files_glob)):
        text = file_parser(file)
        text = replace_namespace(text)
        text = add_root_namesapce(text)
        os.makedirs(OUTPUT_DIR, exist_ok=True)
        output_path = os.path.join(OUTPUT_DIR, os.path.basename(file))
        with open(output_path, 'w') as f:
            f.write(text)
        verify_first_lb(output_path)
    if not debug:
        shutil.rmtree(INPUT_DIR)
