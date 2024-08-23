import lxml.etree as ET
from datetime import datetime
import calendar
import re
import json

ns = {'tei': 'http://www.tei-c.org/ns/1.0',
      'xml': 'http://www.w3.org/XML/1998/namespace'}

tree = ET.parse('./data/indices/Events.xml',)
root = tree.getroot()
events = []
timeline_data = {
    "rangeData": [],
    "momentData": []
}


def create_valid_iso_date(date_string, first_day):
    iso_date = None
    try:
        iso_date = date_string
    except:
        matches = re.match(r"(\d{4})\-*(\d{2})*", date_string)

        date_parts = list(
            int(date_part) if date_part is not None else 1 for date_part in matches.groups())

        month_range = calendar.monthrange(date_parts[0], date_parts[1])
        if first_day:
            date_parts.append('1')
            iso_date = datetime(*map(int, date_parts)).strftime('%Y-%m-%d')
        else:
            date_parts.append(str(month_range[1]))
            iso_date = datetime(*map(int, date_parts)).strftime('%Y-%m-%d')
    return iso_date


for event_elem in root.xpath('//tei:event[@corresp][@when or (@before and @after) or (@notBefore and @notAfter)]', namespaces=ns):
    event = {}
    event["id"] = event_elem.attrib[f"{{{ns['xml']}}}id"]
    event["desc"] = event_elem.find("tei:desc", ns).text.strip()
    event_categories = event_elem.attrib['corresp'].split(" ")
    event_cat_desc_path = [
        f'//tei:desc[@xml:id=\'{category.replace("#","")}\']/text()' for category in event_categories]
    event["categories"] = [root.xpath(path, namespaces=ns)[
        0] for path in event_cat_desc_path]
    event_start = event_elem.xpath('@when | @from | @notBefore')[0]
    event_end = event_elem.xpath('@when | @to | @notAfter')[0]

    if event_start != event_end:
        event["start"] = create_valid_iso_date(event_start, True)
        event["end"] = create_valid_iso_date(event_end, False)
        event["name"] = event_elem.find("tei:label", ns).text
        timeline_data["rangeData"].append(event)
    else:
        event["x"] = create_valid_iso_date(event_start, True)
        event["y"] = event_elem.find("tei:label", ns).text
        timeline_data["momentData"].append(event)
        


with open("./wpn-utils/data/timeline_data.json", "w", encoding='utf-8') as fp:
    json.dump(timeline_data, fp, ensure_ascii=False, indent=4)
