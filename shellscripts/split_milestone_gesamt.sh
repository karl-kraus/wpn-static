#!/bin/bash

## Witness 1 - KK1933_DfeH_supplemented.xml

# remove TEI namespace from root element before splitting
python py/remove_namespace.py -f KK1933_DfeH_supplemented.xml -p data/editions -c "#DWkonJer" -i "iiif/images/wpn/"
# split files
python py/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id data/editions/KK1933_DfeH_supplemented_modified.xml
# cleanup to remove namespaces for id elements and save if data/editions
python py/cleanup.py -f KK1933_DfeH_supplemented.xml -p data/editions --debug
# add original teiHeader to each file
ant -f build-preprocessing.xml witness-1
# add attributes
./shellscripts/add-attributes.sh
echo "add attributes"
add-attributes -g "./data/editions/wit-*.xml" -b "https://id.acdh.oeaw.ac.at"

## Witness 2 - KK1933_TFragment2.xml

# remove TEI namespace from root element before splitting
python py/remove_namespace.py -f KK1933_TFragment2.xml -p data/editions2 -i "iiif/images/wpn2/" -x "ZPH-2007_1_1_6_"
# split files
python py/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id data/editions2/KK1933_TFragment2_modified.xml
# cleanup to remove namespaces for id elements and save if data/editions2
python py/cleanup.py -f KK1933_TFragment2.xml -p data/editions2 --debug
# add original teiHeader to each file
ant -f build-preprocessing.xml witness-2
# add attributes
echo "add attributes"
add-attributes -g "./data/editions2/wit-*.xml" -b "https://id.acdh.oeaw.ac.at"

## Witness 3 - KK1933_HMotti.xml

# remove TEI namespace from root element before splitting
python py/remove_namespace.py -f KK1933_HMotto.xml -p data/editions3
# split files
python py/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id data/editions3/KK1933_HMotto_modified.xml
# cleanup to remove namespaces for id elements and save if data/editions3
python py/cleanup.py -f KK1933_HMotto.xml -p data/editions3 --debug
# add original teiHeader to each file
ant -f build-preprocessing.xml witness-3
# add attributes
echo "add attributes"
add-attributes -g "./data/editions3/wit-*.xml" -b "https://id.acdh.oeaw.ac.at"

## Witness 4 - KK1933_DfMotti.xml

# remove TEI namespace from root element before splitting
python py/remove_namespace.py -f KK1933_DfMotto.xml -p data/editions4
# split files
python py/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id data/editions4/KK1933_DfMotto_modified.xml
# cleanup to remove namespaces for id elements and save if data/editions4
python py/cleanup.py -f KK1933_DfMotto.xml -p data/editions4 --debug
# add original teiHeader to each file
ant -f build-preprocessing.xml witness-4
# add attributes
echo "add attributes"
add-attributes -g "./data/editions4/wit-*.xml" -b "https://id.acdh.oeaw.ac.at"

## Witness 5 - KK1933_TParalipomenon.xml

# remove TEI namespace from root element before splitting
python py/remove_namespace.py -f KK1933_TParalipomenon.xml -p data/editions5
# split files
python py/milestone.py -t pb -n {http://www.w3.org/XML/1998/namespace}id data/editions5/KK1933_TParalipomenon_modified.xml
# cleanup to remove namespaces for id elements and save if data/editions5
python py/cleanup.py -f KK1933_TParalipomenon.xml -p data/editions5 --debug
# add original teiHeader to each file
ant -f build-preprocessing.xml witness-5
# add attributes
echo "add attributes"
add-attributes -g "./data/editions5/wit-*.xml" -b "https://id.acdh.oeaw.ac.at"