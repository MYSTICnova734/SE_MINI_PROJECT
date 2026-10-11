# Builds docs/srs/SRS.pdf from the Markdown files in docs/srs/markdown/,
# in filename order according to the updated SRS template.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$BuildDate = Get-Date -Format "yyyy-MM-dd"

pandoc `
  markdown/metadata.yaml `
  markdown/01-revision-history.md `
  markdown/02-introduction.md `
  markdown/03-overall-description.md `
  markdown/04-external-interface-requirements.md `
  markdown/05-system-features.md `
  markdown/06-nonfunctional-requirements.md `
  markdown/07-quality-attributes-and-acceptance.md `
  markdown/08-system-models-and-diagrams.md `
  markdown/09-requirements-traceability-matrix.md `
  -o SRS.pdf `
  --pdf-engine=xelatex `
  --resource-path=markdown `
  -V "date=Generated $BuildDate"

Write-Host "Built docs/srs/SRS.pdf"
