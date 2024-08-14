#!/bin/bash

# remove TEI namespace from root element before splitting
python py/remove_namespace.py
# split files
python py/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id data/editions/Gesamt_modified.xml
# cleanup to remove namespaces for id elements and save if data/editions
python py/cleanup.py