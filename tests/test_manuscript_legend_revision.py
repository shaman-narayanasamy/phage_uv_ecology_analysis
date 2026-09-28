"""Verify exact live caption revisions against their immediate read-only baseline.

Usage: python tests/test_manuscript_legend_revision.py SNAPSHOT_DIRECTORY
"""
import json
from pathlib import Path
import sys

repo = Path(__file__).resolve().parents[1]
payload = json.loads((repo / "manuscript/revisions/2026-09-09-legend-clarifications.json").read_text())
current = Path(sys.argv[1]).resolve(strict=True)
baseline = current.parent / payload["baseline"]
old_text = (baseline / "accepted_preview.txt").read_text()
new_text = (current / "accepted_preview.txt").read_text()
expected = old_text
for edit in payload["edits"]:
    assert old_text.count(edit["before"]) == 2, edit["label"]
    expected = expected.replace(edit["before"], edit["after"])
    assert new_text.count(edit["after"]) == 2, (edit["label"], "new caption count", new_text.count(edit["after"]))
    assert edit["before"] not in new_text, (edit["label"], "old caption remains")
assert new_text == expected, "Text differs outside the authorised caption replacements"

def tabs(path, view):
    document = json.loads((path / view).read_text())
    return [t["documentTab"] for t in document["tabs"]]

before_tabs = tabs(baseline, "document_accepted_preview.json")
after_tabs = tabs(current, "document_accepted_preview.json")
assert len(before_tabs) == len(after_tabs)
for before, after in zip(before_tabs, after_tabs):
    def stable_objects(tab):
        objects = json.loads(json.dumps(tab.get("inlineObjects", {})))
        # Docs refreshes signed download URLs between reads. Preserve every
        # other property, including source URI, size and crop.
        for obj in objects.values():
            obj.get("inlineObjectProperties", {}).get("embeddedObject", {}).get("imageProperties", {}).pop("contentUri", None)
        return objects
    assert stable_objects(before) == stable_objects(after), "Stable image properties changed"
    def images(tab):
        return [e["inlineObjectElement"]["inlineObjectId"]
                for item in tab["body"]["content"] if "paragraph" in item
                for e in item["paragraph"]["elements"] if "inlineObjectElement" in e]
    assert images(before) == images(after) and len(images(after)) == 15
    for edit in payload["edits"]:
        matched = []
        for item in after["body"]["content"]:
            paragraph = item.get("paragraph", {})
            text = "".join(e.get("textRun", {}).get("content", "") for e in paragraph.get("elements", []))
            if text.strip() == edit["after"]:
                matched.append(paragraph)
        assert len(matched) == 2, (edit["label"], "caption paragraph boundaries")
        assert all(p.get("paragraphStyle", {}).get("namedStyleType") == "NORMAL_TEXT" for p in matched), edit["label"]
        if edit["label"] == "Figure 2":
            for paragraph in matched:
                offset = 0
                body_start = edit["after"].index("(A)")
                for element in paragraph["elements"]:
                    run = element.get("textRun", {})
                    content = run.get("content", "")
                    if offset + len(content.rstrip()) > body_start:
                        assert run.get("textStyle", {}).get("bold") is not True, "Figure 2 body remains bold"
                    offset += len(content)
        if edit["label"] == "Figure 5":
            assert any("Propionicimonas" in e.get("textRun", {}).get("content", "") and
                       e.get("textRun", {}).get("textStyle", {}).get("italic") is True
                       for e in matched[0]["elements"]), "Original Figure 5 genus italics were lost"

def zotero(path):
    return sorted(k for tab in tabs(path, "document_inline.json") for k in tab.get("namedRanges", {}) if k.startswith("Z_"))
assert zotero(baseline) == zotero(current) and len(zotero(current)) == 10
print(f"PASS: {len(payload['edits'])} caption pairs exactly replaced; all other accepted-preview text, 15 images/order and ten Zotero metadata names preserved; captions remain separate Normal paragraphs. This does not prove live citation integration or journal readiness.")
