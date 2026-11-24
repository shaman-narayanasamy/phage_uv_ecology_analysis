"""Execute the accepted supplement QMD's Python build without requiring Quarto."""
import re
import sys
from pathlib import Path

if len(sys.argv) != 2:
    raise SystemExit("Usage: bundled-python scripts/build_accepted_supplement.py NEW_OUTPUT.docx")
source = Path(__file__).resolve().parents[1] / "manuscript/supplementary_information_accepted.qmd"
chunks = re.findall(r"```\{python\}\n(.*?)\n```", source.read_text(), re.S)
if len(chunks) != 1:
    raise SystemExit("Expected exactly one build chunk")
sys.argv = [__file__, str(source), sys.argv[1]]
exec(compile(chunks[0], str(source), "exec"))
