"""Validate a built companion without conflating it with publication readiness."""
from pathlib import Path
import csv
import hashlib
import json
import re
import sys
import zipfile
from pypdf import PdfReader
import pdfplumber

root = Path(sys.argv[1]).resolve(strict=True)
audit = json.loads((root/"assembly_verification.json").read_text())
assert audit["figures"] == 10 and audit["source_table_groups"] == 11
assert audit["archive_decompressed_hashes_verified"] is True
pdf = root/audit.get("pdf_file","output/pdf/phage-uv-supplementary-report-v1.pdf")
assert hashlib.sha256(pdf.read_bytes()).hexdigest() == audit["pdf_sha256"]
reader = PdfReader(pdf)
assert len(reader.pages) == audit["pages"]
assert "Exploratory microbial and viral community differences" not in "\n".join(p.extract_text() for p in reader.pages)
with (root/"figure_provenance.tsv").open() as stream:
    figures = list(csv.DictReader(stream, delimiter="\t"))
assert [f["figure"] for f in figures] == [f"S{i}" for i in range(1, 11)]
for f in figures:
    assert float(f["scale"]) == 1.0
    text=re.sub(r"\s+", " ", reader.pages[int(f["report_page"])-1].extract_text())
    assert f"Supplementary Figure {f['figure']}." in text
    assert f"Supplementary Table {f['source_table']}" in text
with (root/"source_data_manifest.tsv").open() as stream:
    sources=list(csv.DictReader(stream, delimiter="\t"))
assert len(sources) == audit["source_files"]
if (root/"source").is_dir():
    for filename,key in [("supplementary_report_sources.json","input_spec_sha256"),
                         ("figure_legends.md","legend_source_sha256"),
                         ("supplementary_report.qmd","builder_sha256")]:
        assert hashlib.sha256((root/"source"/filename).read_bytes()).hexdigest()==audit[key]
    spec=json.loads((root/"source/supplementary_report_sources.json").read_text())
    assert [(f["label"],f["path"]) for f in spec["figures"]]==[(f["figure"],f["source_path"]) for f in figures]
    legend_source=(root/"source/figure_legends.md").read_text()
    captions={"S"+m.group(2):re.sub(r"\s+"," ",(m.group(1)+" "+m.group(3)).replace("*","")).strip()
              for m in re.finditer(r"\*\*(Supplementary Figure S(\d+)\.[\s\S]*?)\*\*([\s\S]*?)(?=\n\n\*\*|\n\n##|$)",legend_source)}
    assert set(captions)=={f"S{i}" for i in range(1,11)}
    with pdfplumber.open(pdf) as rendered:
        for figure in figures:
            page=reader.pages[int(figure["report_page"])-1]
            text=re.sub(r"\s+"," ",page.extract_text())
            caption=captions[figure["figure"]].replace("\u2011","-").replace("\u2013","-").replace("\u2014","-")
            assert text.count(caption)==1,(figure["figure"],"Complete caption missing or duplicated")
            assert not rendered.pages[int(figure["report_page"])-1].images,(figure["figure"],"Rasterised plate")
    if "manuscript_snapshot" in spec:
        assert audit["caption_snapshot_match_verified"] is True
        snapshot=root.parent/spec["manuscript_snapshot"]
        assert hashlib.sha256(snapshot.read_bytes()).hexdigest()==audit["reference_snapshot_sha256"]
        assert all(snapshot.read_text().count(caption)==2 for caption in captions.values())
        references=snapshot.read_text().split("\nReferences\n",1)[1].split("\nMain figure legends\n",1)[0]
        reference_page=re.sub(r"\s+"," ",reader.pages[-1].extract_text())
        for prefix in ["Callahan BJ,","Martin M.","Quast C,","McMurdie PJ,","Dahl EM,","Nayfach S,"]:
            matches=[line for line in references.splitlines() if line.startswith(prefix)]
            assert len(matches)==1,(prefix,"Ambiguous reference")
            expected=re.sub(r"\s+"," ",matches[0]).replace("\u2011","-").replace("\u2013","-").replace("\u2014","-")
            assert expected in reference_page,(prefix,"Reference text drift")
assert len({r["archive_path"] for r in sources}) == len(sources)
assert {r["table"] for r in sources} == {f"S{i}" for i in range(1, 12)}
for row in sources:
    assert int(row["rows"]) > 0 and int(row["bytes"]) > 0
    assert len(row["sha256"]) == 64
    assert "sos_edger" not in row["source_path"]
    assert "uv_activity" not in row["source_path"]
with zipfile.ZipFile(root/"source_data.zip") as archive:
    assert set(archive.namelist()) == {r["archive_path"] for r in sources}|{"source_data_manifest.tsv"}
    for row in sources:
        h=hashlib.sha256()
        with archive.open(row["archive_path"]) as stream:
            for chunk in iter(lambda:stream.read(1024*1024),b""):
                h.update(chunk)
        assert h.hexdigest() == row["sha256"]
print(f"Verified {len(reader.pages)} pages, 10 vector figure plates and {len(sources)} source files. Visual QA and journal finalisation are separate gates.")
