import glob
import os
import tqdm
import sys
import argparse
from pathlib import Path
from acdh_tei_pyutils.tei import TeiReader
from lxml import etree as ET


# define argument parser to get the name of the source file
parser = argparse.ArgumentParser(description='Cleanup TEI files after splitting')
parser.add_argument('-f', '--file', type=str, help='Name of the source file without extension')
parser.add_argument('-p', '--path', type=str, help='Name of the directory where the source file is located')
parser.add_argument('--debug', action='store_true', help='Debug mode to keep the output directory')
parser.add_argument('-c', '--corresp', type=str, help='Value of the @corresp attribute to filter surfaces for adding graphic url')
parser.add_argument('-i', '--facspath', type=str, help='IIIF image filepath to be used in the url attribute of the graphic element, e.g. "iiif/images/wpn/"')
parser.add_argument('-x', '--facs', type=str, help='IIIF image filename prefix to be used in the url attribute of the graphic element, e.g. "ZPH-2007_1_1_6_"')
args = parser.parse_args()

if not args.file:
    print("""Please provide the name of the source file with .xml extension.""")
    sys.exit(1)

if not args.path:
    print("""Please provide the name of the directory where the source file is located.""")
    sys.exit(1)

if ".xml" not in args.file:
    print("""Please provide the name of the source file with .xml extension.""")
    sys.exit(1)

SOURCE_DIR = Path(args.path)
SOURCE_FILE = args.file
source = SOURCE_DIR / SOURCE_FILE
source_glob = glob.glob(str(source))

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
    corresp_value = args.corresp if args.corresp else None
    if corresp_value:
        xpath_expr = f'//tei:facsimile[@corresp="{corresp_value}"]/tei:surface'
    else:
        xpath_expr = '//tei:facsimile/tei:surface'
    surface = doc.any_xpath(xpath_expr)
    count = 0
    for i, s in enumerate(surface):
        id = s.get('{http://www.w3.org/XML/1998/namespace}id')
        if id is not None and '_' in id:
            if "F" in id or "-" in id or "266_a" in id:
                continue
            # count is only required for special cases when sequence needs to be adjusted
            count += 1
        idInteger = id.replace('idfacs', '').split('_')[0]
        if idInteger is not None:
            s.attrib["n"] = str(i + 1)
            new_id = int(idInteger) + count
            facs_value = args.facs if args.facs else ""
            facs_path = args.facspath if args.facspath[-1] == '/' else f"{args.facspath}/"
            url = f'{facs_path}{facs_value}{new_id:04d}'
            graphic = s.find('tei:graphic', namespaces=NSMAP)
            if graphic is not None:
                graphic.set('url', url)
            else:
                print(f'No graphic found for surface {i}. Creating one.')
                graphic = ET.Element('graphic', attrib={'url': url})
                s.append(graphic)
        else:
            print(f'No id found for surface {i}')
        
    doc.tree_to_file(file)


if __name__ == '__main__':
    for file in tqdm.tqdm(source_glob, total=len(source_glob)):
        if args.facspath:
            add_graphic_url(file)
        file = handle_pb_with_lb_break(file)
        text = file_parser(file)
        text = replace_namespace(text)
        output_path = os.path.join(
            SOURCE_DIR,
            os.path.basename(file).replace('_pb_lb.xml', '_modified.xml'))
        with open(output_path, 'w') as f:
            f.write(text)
        os.remove(file)
