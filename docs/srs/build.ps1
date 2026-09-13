# Builds docs/srs/SRS.pdf from the Markdown files in docs/srs/markdown/,
# in filename order (hence the numeric prefixes on each file).
# Requires: pandoc + a LaTeX engine (MiKTeX, which provides xelatex).
# Install with (from an admin PowerShell):
#   winget install --id JohnMacFarlane.Pandoc
#   winget install --id MiKTeX.MiKTeX
# then open a *new* terminal so PATH updates take effect. MiKTeX will
# prompt to auto-install missing packages (e.g. lmodern) on first run --
# accept "Install on the fly" / "Always" when asked.
#
# Run from repo root: powershell -ExecutionPolicy Bypass -File docs\srs\build.ps1

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$BuildDate = Get-Date -Format "yyyy-MM-dd"

pandoc `
  markdown/metadata.yaml `
  markdown/01-revision-history.md `
  markdown/02-introduction.md `
  markdown/03-overall-description.md `
  markdown/04-external-interfaces.md `
  markdown/05-analysis-models.md `
  markdown/06-system-features.md `
  markdown/07-nonfunctional-requirements.md `
  markdown/08-other-requirements.md `
  markdown/appendix-a-glossary.md `
  markdown/appendix-b-field-layouts.md `
  markdown/appendix-c-traceability.md `
  -o SRS.pdf `
  --pdf-engine=xelatex `
  -V "date=Generated $BuildDate"

Write-Host "Built docs/srs/SRS.pdf"
