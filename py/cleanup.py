import glob
import os
import tqdm
import shutil
from lxml import etree as ET
from acdh_tei_pyutils.tei import TeiReader

NS = [
    'xmlns="http://www.tei-c.org/ns/1.0"',
    '{http://www.w3.org/XML/1998/namespace}'
]
NSMAP = {
    "tei": "http://www.tei-c.org/ns/1.0",
    "xml": "http://www.w3.org/XML/1998/namespace"
}

# Remove the original file
# After the split it is not required anymore
SOURCE_FILE = 'Gesamt_modified.xml'
SOURE_PATH = os.path.join('data', 'editions', SOURCE_FILE)
os.remove(SOURE_PATH)

INPUT_DIR = 'output'
INPUT_PROJECT_DIR = 'Gesamt_modified'
OUTPUT_DIR = os.path.join('data', 'editions', 'tmp')

files = os.path.join(INPUT_DIR, INPUT_PROJECT_DIR, '*.xml')
files_glob = glob.glob(files)


def file_parser(file) -> str:
    with open(file, 'r') as f:
        text = f.read()
    return text


def replace_namespace(text) -> str:
    for ns in NS:
        if ns == '{http://www.w3.org/XML/1998/namespace}':
            text = text.replace(ns, 'xml:')
        else:
            text = text.replace(ns, '')
    return text


def add_root_namesapce(text) -> str:
    text = text.replace(
        '<TEI continued="true">',
        '<TEI xmlns="http://www.tei-c.org/ns/1.0">')
    return text


# def verify_first_lb(file) -> None:
#     doc = TeiReader(file)
#     try:
#         p_lb = doc.any_xpath('//tei:body//tei:p[@rendition]/tei:lb[1][not(preceding-sibling::tei:seg[@type="F890"])]')
#         for lb in p_lb:
#             lb.attrib['n'] = 'first'
#     except IndexError:
#         print(f'No lb found in p for {file}')
#     try:
#         seg_lb = doc.any_xpath('//tei:body//tei:seg[@rendition or @type="relocation"]/tei:lb[1]')
#         for lb in seg_lb:
#             lb.attrib['n'] = 'first'
#     except IndexError:
#         print(f'No lb found in seg for {file}')
#     try:
#         seg_lb_f890 = doc.any_xpath('//tei:body//tei:seg[parent::tei:p[@rendition]][@type="F890"]')
#         for seg in seg_lb_f890:
#             lb = seg.xpath('.//tei:lb', namespaces=NSMAP)
#             print(len(lb), file)
#             if len(lb) > 1:
#                 lb[0].attrib['n'] = 'first'
#     except IndexError:
#         print(f'No lb found in seg for {file}')
#     try:
#         prev_sib_quote = doc.any_xpath('//tei:body//tei:lb[preceding-sibling::*[1][self::tei:quote[tei:p]]]')
#         for lb in prev_sib_quote:
#             lb.attrib['n'] = 'first'
#     except IndexError:
#         print(f'No lb found in seg for {file}')
#     doc.tree_to_file(file)


def verify_last_lb(file) -> None:
    doc = TeiReader(file)
    try:
        p_lb = doc.any_xpath('//tei:body//tei:p[not(contains(@rendition, "longQuote"))]/tei:lb[last()]')
        for lb in p_lb:
            lb.attrib['n'] = 'last'
    except IndexError:
        print(f'No lb found in p for {file}')
    try:
        seg_lb = doc.any_xpath('//tei:body//tei:seg[@rendition or @type="relocation"]/tei:lb[last()][not(following-sibling::tei:seg[@type="F890"])]')
        for lb in seg_lb:
            lb.attrib['n'] = 'last'
    except IndexError:
        print(f'No lb found in seg for {file}')
    # try:
    #     seg_lb_f890 = doc.any_xpath('//tei:body//tei:seg[parent::tei:p[@rendition]][@type="F890"]')
    #     for seg in seg_lb_f890:
    #         lb = seg.xpath('./tei:lb', namespaces=NSMAP)
    #         print(len(lb), file)
    #         if len(lb) > 1:
    #             lb[-1].attrib['type'] = 'last'
    # except IndexError:
    #     print(f'No lb found in seg for {file}')
    doc.tree_to_file(file)


EXCLUDE_TAGS = [
    "{http://www.tei-c.org/ns/1.0}lg",
    "{http://www.tei-c.org/ns/1.0}note",
    "{http://www.tei-c.org/ns/1.0}p",
    "{http://www.tei-c.org/ns/1.0}lb",
]


def has_tail(el) -> str:
    if el.tail is not None:
        tail = el.tail
        el.tail = ""
        return tail
    return ""


def append_el(el, s) -> None:
    el.getparent().remove(el)
    tail = has_tail(el)
    s.append(el)
    el.tail = tail
    return s


def wrap_or_not(el, s, ancestor=False) -> ET.Element:
    """_summary_

    Args:
        el (lxml etree element): first element after milestone element (lb n="last")
        s (lxml etree element): span element to wrap the sentence
        ancestor (bool, optional): if el is wrapped in LB_Elements. Defaults to False.

    Returns:
        ET.Element: span element with the sentence
    """
    while el is not None:
        if el.tag not in EXCLUDE_TAGS:
            next_el = el.getnext()
            if el.tag == "{http://www.tei-c.org/ns/1.0}quote" or el.tag == "{http://www.tei-c.org/ns/1.0}seg":
                breakpoint_els = el.xpath("./tei:p|./tei:lg|./tei:note",
                                          namespaces=NSMAP)
                # quote and seg are inline or block elements but
                # (Breakpoints: p, lg, note)
                # they may have nested block and inline elements
                if breakpoint_els:
                    breakpoint_el = breakpoint_els[0]
                    if ancestor:
                        # if el is wrapped in LB_Elements
                        # next to siblings also siblings of the parent element
                        # should be appended to the span element
                        if el.tail is not None:
                            if len(s) != 0:
                                s[-1].tail += el.tail
                            else:
                                if s.text is not None:
                                    s.text += el.tail
                                else:
                                    s.text = el.tail
                            el.tail = ""
                        for childel in breakpoint_el.xpath("following-sibling::*"):
                            el.remove(childel)
                            s.append(childel)
                    else:
                        # if el is not in wrapped in LB_Elements
                        # check for preceding siblings before
                        # breakpoint element
                        if el.text is not None:
                            if len(s) != 0:
                                s[-1].tail += el.text
                            else:
                                if s.text is not None:
                                    s.text += el.text
                                else:
                                    s.text = el.text
                            el.text = ""
                        for childel in breakpoint_el.xpath("preceding-sibling::*"):
                            el.remove(childel)
                            s.append(childel)
                    next_el = None
                else:
                    s = append_el(el, s)
            else:
                s = append_el(el, s)
        else:
            return s
        # print(type(el))
        el = next_el
    return s


def create_sub_el(parent_or_ancestor, ancestor=False) -> ET._Element:
    s2 = ET.Element('span')
    if parent_or_ancestor.tag == "{http://www.tei-c.org/ns/1.0}subst":
        s2.attrib["n"] = "last"
    s2.text = parent_or_ancestor.tail
    parent_or_ancestor.tail = ""
    s2 = wrap_or_not(parent_or_ancestor.getnext(), s2, ancestor)
    return s2


LB_WRAPPED = [
    "{http://www.tei-c.org/ns/1.0}rs",
    "{http://www.tei-c.org/ns/1.0}hi",
    "{http://www.tei-c.org/ns/1.0}del",
    "{http://www.tei-c.org/ns/1.0}quote",
    "{http://www.tei-c.org/ns/1.0}foreign",
    "{http://www.tei-c.org/ns/1.0}mod",
]


def wrap_last_sentence(file) -> None:
    # with open(file) as text_fp:
    #     text = text_fp.read()
    doc = ET.parse(file)
    lb = doc.xpath('.//tei:lb[@n="last"]', namespaces=NSMAP)
    for x in lb:
        s = ET.Element('span')
        s.attrib["n"] = "last"
        s.text = x.tail
        x.tail = ""
        s = wrap_or_not(x.getnext(), s)
        parent = x.getparent()
        if parent.tag in LB_WRAPPED:
            ancestor = parent.getparent()
            if parent.tag == "{http://www.tei-c.org/ns/1.0}del":
                if ancestor.tag == "{http://www.tei-c.org/ns/1.0}subst":
                    s2 = create_sub_el(ancestor)
                    x.addnext(s)
                    x.getparent().addnext(s2)
            if parent.tag == "{http://www.tei-c.org/ns/1.0}quote":
                s2 = create_sub_el(ancestor, ancestor=True)
                s.append(s2)
                x.addnext(s)
                if ancestor.tag == "{http://www.tei-c.org/ns/1.0}del" or ancestor.tag == "{http://www.tei-c.org/ns/1.0}add":
                    s3 = create_sub_el(ancestor.getparent(), ancestor=True)
                    ancestor.addnext(s3)
            if parent.tag != "{http://www.tei-c.org/ns/1.0}del":
                s2 = create_sub_el(parent)
                s.append(s2)
                x.addnext(s)
        else:
            x.addnext(s)
    with open(file, 'w') as f:
        f.write(ET.tostring(doc, pretty_print=True).decode('utf-8'))


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
        # verify_first_lb(output_path)
        # verify_last_lb(output_path)
        wrap_last_sentence(output_path)
    if not debug:
        shutil.rmtree(INPUT_DIR)
