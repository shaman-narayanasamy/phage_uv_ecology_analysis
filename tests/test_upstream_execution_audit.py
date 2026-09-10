"""Check the archived execution evidence used by the current Methods payload."""
import json
from pathlib import Path
import shlex
import sys

audit = json.loads(Path(sys.argv[1]).read_text())
assert all(audit['checks'].values()) and not audit['missing']
expected_records = 260 if '12_concoct_1000base_splits' in audit['checks'] else 236
assert len(audit['records']) == expected_records and len(audit['fastp_reports']) == 35
assert len({x['path'] for x in audit['records']}) == expected_records
assert all(not x['metadata']['incomplete'] for x in audit['records'])
for row in audit['records']:
    metadata = row['metadata']
    command = metadata.get('shellcmd', '')
    rule = metadata['rule']
    if rule == 'bedtools_gene_coverage':
        tokens = shlex.split(command)
        start = tokens.index('bedtools')
        args = tokens[start+1:tokens.index('>', start)]
        assert len(args) == 5 and args[0] == 'coverage'
        assert args[1] == '-a' and args[2].endswith('/mags_votu.genes.bed')
        assert args[3] == '-b' and args[4].endswith('.reads.sorted.bam')
    elif rule == 'bwa_mapping_catalogue':
        assert 'bwa mem -v 1 -t 24 -M' in command
        assert 'samtools view --threads 24 -bS -' in command
        assert ' -q ' not in command and ' -F ' not in command
    elif rule.startswith('sortmerna_rrna'):
        assert 'smr_v4.3_default_db.fasta' in command
    elif rule == 'magscot_contig_to_bin':
        inputs = metadata['input']
        for tool in ['concoct', 'maxbin2', 'metabat2', 'semibin', 'vamb']:
            assert any(f'/{tool}/' in p for p in inputs)
        assert any(p.startswith('semibin_multi_sample/') for p in inputs)
    elif rule == 'concoct_cut_contigs':
        assert '-c 1000 -o 0 --merge_last' in command
    elif rule == 'concoct':
        assert ' -l 1500 ' in command
print(f'PASS: {expected_records} complete execution records, 35 fastp reports, exact count/mapping commands and six-source refinement')
