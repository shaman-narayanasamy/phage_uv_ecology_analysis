"""Run explicit Python chunks from a trusted project Quarto notebook.

This is the Python counterpart to run_qmd.sh; no Jupyter installation is needed.
Only plain Python fenced chunks are supported. Notebook rendering stays disabled
unless the operator explicitly invokes this runner.
"""
from pathlib import Path
import re
import sys

if len(sys.argv) < 2:
    raise SystemExit("Usage: python scripts/run_python_qmd.py notebook.qmd [arguments...]")
notebook = Path(sys.argv[1]).resolve(strict=True)
if notebook.suffix != ".qmd":
    raise SystemExit("Expected a .qmd source")
blocks = re.findall(r"^```\{python[^}]*\}\n(.*?)^```\s*$", notebook.read_text(), re.M | re.S)
if not blocks:
    raise SystemExit("No Python chunks found")
sys.argv = [str(notebook), *sys.argv[2:]]
namespace = {"__name__": "__main__", "__file__": str(notebook)}
for block in blocks:
    exec(compile(block, str(notebook), "exec"), namespace)
