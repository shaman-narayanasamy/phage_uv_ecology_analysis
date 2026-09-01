#!/usr/bin/env python3
"""Apply the Google Docs-native review style to a Pandoc DOCX.

This is a deterministic OOXML transform and requires only lxml. It keeps the
first manuscript title as a plain paragraph, rather than Word's Title style.
"""

from __future__ import annotations

import argparse
import shutil
import tempfile
import zipfile
from pathlib import Path

from lxml import etree


W = "http://schemas.openxmlformats.org/wordprocessingml/2006/main"
NS = {"w": W}


def qn(name: str) -> str:
    return f"{{{W}}}{name}"


def child(parent: etree._Element, name: str) -> etree._Element:
    node = parent.find(f"w:{name}", NS)
    if node is None:
        node = etree.SubElement(parent, qn(name))
    return node


def set_val(parent: etree._Element, name: str, value: str) -> etree._Element:
    node = child(parent, name)
    node.set(qn("val"), value)
    return node


def set_run(rpr: etree._Element, size_half_points: int, color: str = "000000") -> None:
    fonts = child(rpr, "rFonts")
    for attr in ("ascii", "hAnsi", "eastAsia", "cs"):
        fonts.set(qn(attr), "Arial")
    set_val(rpr, "sz", str(size_half_points))
    set_val(rpr, "szCs", str(size_half_points))
    set_val(rpr, "color", color)


def set_spacing(ppr: etree._Element, before: int, after: int, line: int | None = None) -> None:
    spacing = child(ppr, "spacing")
    spacing.set(qn("before"), str(before))
    spacing.set(qn("after"), str(after))
    if line is not None:
        spacing.set(qn("line"), str(line))
        spacing.set(qn("lineRule"), "auto")


def patch_styles(root: etree._Element) -> None:
    defaults = child(root, "docDefaults")
    rpr_default = child(child(defaults, "rPrDefault"), "rPr")
    set_run(rpr_default, 22)
    ppr_default = child(child(defaults, "pPrDefault"), "pPr")
    set_spacing(ppr_default, 0, 160, 276)

    tokens = {
        "Normal": (22, "000000", 0, 160, 276),
        "BodyText": (22, "000000", 0, 160, 276),
        "Heading1": (40, "000000", 400, 120, None),
        "Heading2": (32, "000000", 360, 120, None),
        "Heading3": (28, "434343", 320, 80, None),
    }
    for style in root.xpath(".//w:style[@w:type='paragraph']", namespaces=NS):
        style_id = style.get(qn("styleId"), "")
        if style_id not in tokens:
            continue
        size, color, before, after, line = tokens[style_id]
        set_run(child(style, "rPr"), size, color)
        ppr = child(style, "pPr")
        set_spacing(ppr, before, after, line)
        for border in list(ppr.findall("w:pBdr", NS)):
            ppr.remove(border)


def patch_document(root: etree._Element) -> None:
    paragraphs = root.xpath(".//w:body/w:p", namespaces=NS)
    title = next((p for p in paragraphs if "".join(p.xpath(".//w:t/text()", namespaces=NS)).strip()), None)
    if title is not None:
        ppr = child(title, "pPr")
        set_val(ppr, "pStyle", "Normal")
        set_spacing(ppr, 0, 60, 240)
        for border in list(ppr.findall("w:pBdr", NS)):
            ppr.remove(border)
        for run in title.findall("w:r", NS):
            rpr = child(run, "rPr")
            set_run(rpr, 52)
            for tag in ("b", "bCs", "u"):
                for node in list(rpr.findall(f"w:{tag}", NS)):
                    rpr.remove(node)

    for sect in root.xpath(".//w:sectPr", namespaces=NS):
        pg_sz = child(sect, "pgSz")
        pg_sz.set(qn("w"), "12240")
        pg_sz.set(qn("h"), "15840")
        margins = child(sect, "pgMar")
        for attr in ("top", "right", "bottom", "left"):
            margins.set(qn(attr), "1440")


def transform(source: Path, target: Path) -> None:
    replacements: dict[str, bytes] = {}
    with zipfile.ZipFile(source, "r") as zin:
        styles = etree.fromstring(zin.read("word/styles.xml"))
        patch_styles(styles)
        replacements["word/styles.xml"] = etree.tostring(
            styles, xml_declaration=True, encoding="UTF-8", standalone="yes"
        )
        document = etree.fromstring(zin.read("word/document.xml"))
        patch_document(document)
        replacements["word/document.xml"] = etree.tostring(
            document, xml_declaration=True, encoding="UTF-8", standalone="yes"
        )
        target.parent.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(target, "w", zipfile.ZIP_DEFLATED) as zout:
            for item in zin.infolist():
                zout.writestr(item, replacements.get(item.filename, zin.read(item.filename)))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    if args.input.resolve() == args.output.resolve():
        with tempfile.TemporaryDirectory(prefix="google-docs-style-") as tmp:
            staged = Path(tmp) / "styled.docx"
            transform(args.input, staged)
            shutil.copy2(staged, args.output)
    else:
        transform(args.input, args.output)


if __name__ == "__main__":
    main()
