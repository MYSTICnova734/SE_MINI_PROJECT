#!/usr/bin/env bash
# Builds docs/srs/SRS.pdf from the Markdown files in docs/srs/markdown/,
# in filename order (hence the numeric prefixes on each file).
# Requires: pandoc + a LaTeX engine (xelatex). Run locally with:
#   brew install pandoc basictex      (mac)
#   sudo apt install pandoc texlive-xetex texlive-latex-recommended lmodern   (linux)
set -euo pipefail
cd "$(dirname "$0")"

BUILD_DATE=$(date -u +"%Y-%m-%d")

pandoc \
  markdown/metadata.yaml \
  markdown/01-revision-history.md \
  markdown/02-introduction.md \
  markdown/03-overall-description.md \
  markdown/04-external-interfaces.md \
  markdown/05-analysis-models.md \
  markdown/06-system-features.md \
  markdown/07-nonfunctional-requirements.md \
  markdown/08-other-requirements.md \
  markdown/appendix-a-glossary.md \
  markdown/appendix-b-field-layouts.md \
  markdown/appendix-c-traceability.md \
  markdown/appendix-d-stakeholder-log.md \
  -o SRS.pdf \
  --pdf-engine=xelatex \
  -V date="Generated ${BUILD_DATE}"

echo "Built docs/srs/SRS.pdf"
