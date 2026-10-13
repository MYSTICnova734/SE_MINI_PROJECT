# STP — Software Test Plan

```
docs/stp/
  diagrams/        <- place Graphviz (.dot) diagram source files here
  markdown/        <- edit these Markdown files. One shared set, everyone contributes.
    images/        <- auto-generated rendered images (.png) referenced by Markdown live here
  build.sh         <- local Bash build script (needs pandoc + LaTeX + Graphviz)
  build.ps1        <- local PowerShell build script (needs pandoc + MiKTeX + Graphviz)
  STP.pdf          <- generated PDF output. Don't hand-edit; gets overwritten on merge to main.
README.md          <- this file
```

## Getting started
1. Edit and complete sections in `markdown/*.md`. Section order strictly matches the 15 required sections of the standard STP template (`01-introduction.md` through `15-approvals.md`).
2. Testing covers unit, integration, system, and acceptance levels, 2-sprint Agile schedule, test data setup, and security/performance validation.
3. Update `markdown/metadata.yaml` (authors, dates, document status) as updates occur.

## Working with Diagrams & Images

### 1. Adding or Editing Graphviz Diagrams
1. Place or edit Graphviz source files (`.dot`) inside `docs/stp/diagrams/`.
2. The local build scripts (`build.sh` / `build.ps1`) and GitHub Actions workflow automatically compile all `.dot` files from `docs/stp/diagrams/` into high-resolution 300 DPI PNG images in `docs/stp/markdown/images/` before building the PDF.

### 2. Referencing Images in Markdown
Reference images using relative paths to `images/` with explicit width scaling attributes:

```markdown
![Testing Levels Hierarchy](images/testing-levels.png){width=85%}
![Agile Test Schedule Timeline](images/test-schedule.png){width=85%}
```

Use `\clearpage` prior to section headers if a diagram needs its own dedicated page.

---

## Building the PDF locally

### Prerequisites

**Mac**
```bash
brew install pandoc basictex graphviz
sudo tlmgr install lmodern
bash docs/stp/build.sh
```

**Linux**
```bash
sudo apt update
sudo apt install pandoc texlive-xetex texlive-latex-recommended lmodern graphviz
bash docs/stp/build.sh
```

**Windows — native (PowerShell)**
```powershell
winget install --id JohnMacFarlane.Pandoc
winget install --id MiKTeX.MiKTeX
winget install --id Graphviz.Graphviz
# Open a new terminal so PATH picks up tools, then:
powershell -ExecutionPolicy Bypass -File docs\stp\build.ps1
```

---

## Automatic build on merge
`.github/workflows/build-stp-pdf.yml` runs automatically whenever changes are pushed to `main` that touch `docs/stp/markdown/**` or `docs/stp/diagrams/**`. It compiles all Graphviz diagrams, rebuilds `docs/stp/STP.pdf`, and commits the updated PDF back to the repository automatically.
