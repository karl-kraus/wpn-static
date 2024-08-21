import glob
import os
import tqdm
import shutil

NS = [
    'xmlns="http://www.tei-c.org/ns/1.0"',
    '{http://www.w3.org/XML/1998/namespace}'
]
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
    if not debug:
        shutil.rmtree(INPUT_DIR)
