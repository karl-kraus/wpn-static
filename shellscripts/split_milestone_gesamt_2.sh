#!/bin/bash

# remove TEI namespace from root element before splitting
python py/remove_namespace_2.py
# split files
python py/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id data/editions2/KK1933_Abs64_Ts_modified.xml
# cleanup to remove namespaces for id elements and save if data/editions
python py/cleanup_2.py
# add original teiHeader to each file
ant add-header-pb-2
# add attributes
./shellscripts/add-attributes-2.sh