# SAD — Software Architecture and Design

```
docs/sad/
  diagrams/        <- place Graphviz (.dot) diagram source files here
  markdown/        <- edit these Markdown files. One shared set, everyone contributes.
    images/        <- auto-generated rendered images (.png) referenced by Markdown live here
  build.sh         <- local Bash build script (needs pandoc + LaTeX + Graphviz)
  build.ps1        <- local PowerShell build script (needs pandoc + MiKTeX + Graphviz)
  SAD.pdf          <- generated PDF output. Don't hand-edit; gets overwritten on merge to main.
README.md          <- this file
```

## Getting started
1. Edit and complete sections in `markdown/*.md`. Section order matches the required template (`01-revision-history.md` through `06-appendices.md`).
2. Architecture covers 3-tier decomposition, component descriptions, STRIDE threat models, sequence flows, REST API specs, and error handling.
3. Update `01-revision-history.md` and `markdown/metadata.yaml` (authors, dates, document status) as changes occur.

## Working with Diagrams & Images

### 1. Adding or Editing Graphviz Diagrams
1. Place or edit Graphviz source files (`.dot`) inside `docs/sad/diagrams/`.
2. The local build scripts (`build.sh` / `build.ps1`) and GitHub Actions workflow automatically compile all `.dot` files from `docs/sad/diagrams/` into high-resolution 300 DPI PNG images in `docs/sad/markdown/images/` before building the PDF.

### 2. Referencing Images in Markdown
Reference images using relative paths to `images/` with explicit width scaling attributes:

```markdown
![Component Diagram](images/component-diagram.png){width=85%}
```

Use `\clearpage` prior to section headers if a diagram needs its own dedicated page.

---

## Building the PDF locally

### Prerequisites

**Mac**
```bash
brew install pandoc basictex graphviz
sudo tlmgr install lmodern
bash docs/sad/build.sh
```

**Linux**
```bash
sudo apt update
sudo apt install pandoc texlive-xetex texlive-latex-recommended lmodern graphviz
bash docs/sad/build.sh
```

**Windows — native (PowerShell)**
```powershell
winget install --id JohnMacFarlane.Pandoc
winget install --id MiKTeX.MiKTeX
winget install --id Graphviz.Graphviz
# Open a new terminal so PATH picks up tools, then:
powershell -ExecutionPolicy Bypass -File docs\sad\build.ps1
```

---

## Automatic build on merge
`.github/workflows/build-sad-pdf.yml` runs automatically whenever changes are pushed to `main` that touch `docs/sad/markdown/**` or `docs/sad/diagrams/**`. It compiles all Graphviz diagrams, rebuilds `docs/sad/SAD.pdf`, and commits the updated PDF back to the repository automatically.
