# Builds docs/sad/SAD.pdf from the Markdown files in docs/sad/markdown/,
# compiling Graphviz diagrams in docs/sad/diagrams/ to 300 DPI PNGs first.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$BuildDate = Get-Date -Format "yyyy-MM-dd"

# Ensure output image directory exists
New-Item -ItemType Directory -Force -Path "markdown/images" | Out-Null

# Compile Graphviz diagrams from diagrams/ to markdown/images/ at 300 DPI
if (Test-Path "diagrams") {
    Get-ChildItem "diagrams/*.dot" -ErrorAction SilentlyContinue | ForEach-Object {
        $outPng = "markdown/images/" + $_.BaseName + ".png"
        Write-Host "Rendering $($_.Name) -> $outPng (300 DPI)"
        dot -Tpng -Gdpi=300 $_.FullName -o $outPng
    }
}

pandoc `
  markdown/metadata.yaml `
  markdown/01-revision-history.md `
  markdown/02-introduction.md `
  markdown/03-document-overview.md `
  markdown/04-architecture.md `
  markdown/05-design.md `
  markdown/06-appendices.md `
  -o SAD.pdf `
  --pdf-engine=xelatex `
  --resource-path=markdown `
  -V "date=Generated $BuildDate"

Write-Host "Built docs/sad/SAD.pdf successfully."
