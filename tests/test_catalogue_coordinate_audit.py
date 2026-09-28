"""Validate the coordinate audit and its agreement with existing count audits.

This checks preserved evidence, not every source GFF or ambiguous-read effects.
"""
import csv
import hashlib
import json
from pathlib import Path
import sys

audit_path = Path(sys.argv[1]).resolve(strict=True)
audit = json.loads(audit_path.read_text())
assert len(audit['checks']) == 3 and all(audit['checks'].values())
assert len(audit['files']) == 7
assert all(x['bytes'] > 0 and len(x['sha256']) == 64 for x in audit['files'].values())
diagnostics = audit['diagnostics']
assert diagnostics['combined_rows'] == 1734193
assert diagnostics['combined_unique_rows'] == 1734019
assert diagnostics['combined_duplicate_rows'] == 174
assert not diagnostics['combined_is_exact_concatenation']
assert diagnostics['combined_row_differences'] == []
viral = audit['viral']
assert viral['annotation_rows'] == viral['bed_rows'] == 766445
assert viral['chunk_offset_rows'] == 30666
assert viral['exact_duplicate_annotation_rows'] == 174
assert viral['duplicate_gene_keys'] == viral['duplicate_bed_gene_keys'] == 1856
assert viral['unique_gene_keys'] == 764589
assert viral['unmatched_bed_rows'] == viral['missing_annotation_rows'] == viral['unmapped'] == 0
assert len(audit['mag_example']) == 3
assert 'representative three-gene MAG' in audit['boundary']
arguments = audit['drep_arguments']
assert (arguments['completeness'], arguments['contamination']) == (75, 25)
assert (arguments['P_ani'], arguments['S_ani']) == (.90, .95)
assert arguments['run_tertiary_clustering'] is True
notebook = Path(__file__).resolve().parents[1] / 'manuscript/catalogue_coordinate_audit.qmd'
assert hashlib.sha256(notebook.read_bytes()).hexdigest() == audit['notebook_sha256']
run_audit = audit_path.parents[1] / 'full_transcriptome_de/tables/run_file_audit.tsv'
with run_audit.open() as handle:
    runs = list(csv.DictReader(handle, delimiter='\t'))
assert len(runs) == 23
assert all(int(row['raw_rows']) == 1734193 for row in runs)
assert all(int(row['unique_features']) == 1734019 for row in runs)
assert all(int(row['exact_duplicate_records_removed']) == 174 for row in runs)
print('PASS: full viral-coordinate reconciliation; 174 exact duplicates agree with all 23 count-run audits; MAG GFF evidence remains representative only')
