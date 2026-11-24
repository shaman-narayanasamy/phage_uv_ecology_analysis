# Native heat-tree runtime

Owner: phage-UV Figure 1 review, 2026-09-13. Reuse the existing macOS ARM64
R 4.5 installation and its installed dependencies. No new Conda environment,
HPC work, or modifications to the global R library.

The active R library did not contain metacoder. A small additive package library
is reserved at `/Users/shaman.narayanasamy/.local/share/R/phage-uv-metacoder-0.3.9`.
Install metacoder 0.3.9 and only missing required dependencies from CRAN macOS
binaries there. Do not upgrade existing globally installed packages. Set
`PHAGE_UV_METACODER_LIB` to that directory when running the native Quarto notebook.
Other machines may set this variable to their own compatible library.

The versioned output records sessionInfo and installed package versions, and
archives the generating notebook. Keep this library while these review figures
remain in use; no automated deletion or duplicate per-agent prefixes.

Reference: https://grunwaldlab.github.io/metacoder_documentation/workshop--05--plotting.html
Use metacoder's native `heat_tree`, including its native edge geometry and
label positioning, with Reingold-Tilford initialisation and Davidson-Harel layout.
