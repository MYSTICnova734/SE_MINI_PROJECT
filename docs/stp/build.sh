#!/usr/bin/env bash
# Builds docs/stp/STP.pdf from the Markdown files in docs/stp/markdown/,
# compiling Graphviz diagrams in docs/stp/diagrams/ to 300 DPI PNGs first.
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
  markdown/01-introduction.md \
  markdown/02-test-items.md \
  markdown/03-features-to-be-tested.md \
  markdown/04-features-not-to-be-tested.md \
  markdown/05-test-approach-strategy.md \
  markdown/06-test-environment.md \
  markdown/07-test-schedule.md \
  markdown/08-test-deliverables.md \
  markdown/09-roles-and-responsibilities.md \
  markdown/10-risks-and-mitigation.md \
  markdown/11-assumptions-and-dependencies.md \
  markdown/12-suspension-and-resumption-criteria.md \
  markdown/13-test-case-management-and-traceability.md \
  markdown/14-test-metrics-and-reporting.md \
  markdown/15-approvals.md \
  -o STP.pdf \
  --pdf-engine=xelatex \
  --resource-path=markdown \
  -V date="Generated ${BUILD_DATE}"

echo "Built docs/stp/STP.pdf successfully."
