#!/usr/bin/env bash
# Builds docs/sad/SAD.pdf from the Markdown files in docs/sad/markdown/,
# compiling Graphviz diagrams in docs/sad/diagrams/ to 300 DPI PNGs first.
set -euo pipefail
cd "$(dirname "$0")"

BUILD_DATE=$(date -u +"%Y-%m-%d")

# Compile Graphviz diagrams from diagrams/ to markdown/images/ at 300 DPI
mkdir -p markdown/images
if [ -d "diagrams" ]; then
  for dotfile in diagrams/*.dot; do
    if [ -f "$dotfile" ]; then
      filename=$(basename "$dotfile" .dot)
      echo "Rendering $dotfile -> markdown/images/$filename.png (300 DPI)"
      dot -Tpng -Gdpi=300 "$dotfile" -o "markdown/images/$filename.png"
    fi
  done
fi

pandoc \
  markdown/metadata.yaml \
  markdown/01-revision-history.md \
  markdown/02-introduction.md \
  markdown/03-document-overview.md \
  markdown/04-architecture.md \
  markdown/05-design.md \
  markdown/06-appendices.md \
  -o SAD.pdf \
  --pdf-engine=xelatex \
  --resource-path=markdown \
  -V date="Generated ${BUILD_DATE}"

echo "Built docs/sad/SAD.pdf successfully."
