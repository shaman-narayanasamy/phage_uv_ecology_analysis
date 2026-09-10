"""Require exactly the two audited population revisions in a live readback."""
import json
from pathlib import Path
import sys

repo=Path(__file__).resolve().parents[1]
payload=json.loads((repo/"manuscript/revisions/2026-09-09-population-methods-clarification.json").read_text())
current=Path(sys.argv[1]).resolve(strict=True)
baseline=current.parent/payload["baseline"]
expected=(baseline/"accepted_preview.txt").read_text()
for edit in payload["edits"]:
    assert expected.count(edit["before"])==1, edit["label"]
    expected=expected.replace(edit["before"],edit["after"])
assert (current/"accepted_preview.txt").read_text()==expected,"Unexpected text changes outside the two authorised revisions"
def tabs(root,filename):
    return [t["documentTab"] for t in json.loads((root/filename).read_text())["tabs"]]
def stable_images(tabs):
    objects={k:v for t in tabs for k,v in t.get("inlineObjects",{}).items()}
    objects=json.loads(json.dumps(objects))
    for value in objects.values():
        value.get("inlineObjectProperties",{}).get("embeddedObject",{}).get("imageProperties",{}).pop("contentUri",None)
    order=[e["inlineObjectElement"]["inlineObjectId"] for t in tabs for p in t["body"]["content"] if "paragraph" in p for e in p["paragraph"]["elements"] if "inlineObjectElement" in e]
    return objects,order
old=tabs(baseline,"document_accepted_preview.json")
new=tabs(current,"document_accepted_preview.json")
assert stable_images(old)==stable_images(new) and len(stable_images(new)[1])==15
for edit in payload["edits"]:
    matches=[p["paragraph"] for t in new for p in t["body"]["content"] if "paragraph" in p and "".join(e.get("textRun",{}).get("content","") for e in p["paragraph"]["elements"]).strip()==edit["after"]]
    assert len(matches)==1 and matches[0].get("paragraphStyle",{}).get("namedStyleType")=="NORMAL_TEXT",edit["label"]
old_inline=tabs(baseline,"document_inline.json")
new_inline=tabs(current,"document_inline.json")
def zotero(tabs):
    return sorted(k for t in tabs for k in t.get("namedRanges",{}) if k.startswith("Z_"))
assert zotero(old_inline)==zotero(new_inline) and len(zotero(new_inline))==10
def suggestion_ids(tabs):
    return {i for t in tabs for p in t["body"]["content"] if "paragraph" in p for e in p["paragraph"]["elements"] for key in ("suggestedInsertionIds","suggestedDeletionIds") for i in e.get("textRun",{}).get(key,[])}
assert suggestion_ids(old_inline)<=suggestion_ids(new_inline),"Existing text suggestion IDs disappeared"
assert suggestion_ids(new_inline)-suggestion_ids(old_inline),"No new native suggestion IDs"
print("PASS: exact Results-unit and Methods revisions; all other text, 15 images/order, original suggestions and ten Zotero metadata names preserved; both paragraphs Normal style.")
