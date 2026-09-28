"""Independently verify the pinned release and denominator-audit artifacts."""
from pathlib import Path
import csv
import hashlib
import json
import math
import sys

release = Path(sys.argv[1]).resolve(strict=True)
denominator = Path(sys.argv[2]).resolve(strict=True)
a = json.loads((release/"audit.json").read_text())
d = json.loads((denominator/"audit.json").read_text())
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
assert a["archive_sha256"] == sha(release/"inStrain-1.10.0.tar.gz") == "f40f1d439914ec85cec83ce4c3f2fbf2ce064132109be9f2d3bfd048899b5a8e"
assert a["release"] == "1.10.0"
assert {k:v["default"] for k,v in a["published_defaults"].items()} == {"--ani_threshold":0.99999,"--coverage_treshold":0.1,"--clusterAlg":"average"}
assert a["explicit_cluster_threshold_overrides"] is False and a["completed_log_marker"] is True
assert a["log_sha256"] == sha(Path(a["log_path"]))
for relative,digest in a["source_sha256"].items():
    assert sha(release/"source"/relative) == digest
assert "table['percent_compared'].append(tcb / b2l[genome])" in (release/"source/inStrain/genomeUtilities.py").read_text()
for source in d["source_hashes"].values():
    assert sha(Path(source["path"])) == source["sha256"]
def read(path, delimiter="\t"):
    with path.open(newline="") as stream:
        return list(csv.DictReader(stream,delimiter=delimiter))
mags=read(denominator/"mag_denominator_audit.tsv")
pairs=read(denominator/"pair_denominator_sensitivity.tsv")
original=read(Path(d["source_hashes"]["comparison"]["path"]))
assert len(mags)==15 and len(pairs)==len(original)==191
catalogue={Path(r["genome"]).stem:int(r["length"]) for r in read(Path(d["source_hashes"]["catalogue"]["path"]),",")}
for result,source in zip(pairs,original):
    mag=result["MAG_ID"]
    assert (mag,result["sample_a"],result["sample_b"]) == (source["genome"],source["name1"],source["name2"])
    assert int(result["compared_bases"])==int(source["compared_bases_count"])
    assert int(result["consensus_differences"])==int(source["consensus_SNPs"])
    assert math.isclose(float(result["full_catalogue_compared_fraction"]),int(source["compared_bases_count"])/catalogue[mag])
selected=[m for m in mags if m["historically_selected"]=="True"]
assert {m["MAG_ID"] for m in selected}=={"CBF2_MAGScoT_cleanbin_000015","CBF3_MAGScoT_cleanbin_000031","TBF2_MAGScoT_cleanbin_000085","TBF3_MAGScoT_cleanbin_000022","TI3_MAGScoT_cleanbin_000001"}
assert sum(int(m["historical_valid_pairs"]) for m in selected)==139
for m in selected:
    assert int(m["full_catalogue_length"])==int(m["reconstructed_instrain_length"])==int(m["sum_unique_compared_scaffold_lengths"])
    assert int(m["missing_length_scaffolds"])==int(m["pairs_lost_with_full_length"])==0
    assert m["full_length_selected"]=="True"
assert d["selected_MAGs_with_changed_eligibility"]==d["selected_pairs_lost_with_full_MAG_length"]==0
print("PASS: pinned inStrain 1.10.0 defaults; 191 archived pairs unchanged; all five selected MAG denominators equal full catalogue length and all 139 qualified pairs retained.")
