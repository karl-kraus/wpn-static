import glob
import os
import tqdm

SOURCE_DIR = 'data/editions'
SOURCE_FILE = 'Gesamt.xml'
source = os.path.join(SOURCE_DIR, SOURCE_FILE)
source_glob = glob.glob(source)

NS = [
    'xmlns="http://www.tei-c.org/ns/1.0"'
]


def file_parser(file):
    with open(file, 'r') as f:
        text = f.read()
    return text


def replace_namespace(text):
    for ns in NS:
        text = text.replace(ns, '')
    return text


if __name__ == '__main__':
    for file in tqdm.tqdm(source_glob, total=len(source_glob)):
        text = file_parser(file)
        text = replace_namespace(text)
        output_path = os.path.join(SOURCE_DIR, 
                                   f"{os.path.basename(file).replace('.xml', '_modified.xml')}")
        with open(output_path, 'w') as f:
            f.write(text)