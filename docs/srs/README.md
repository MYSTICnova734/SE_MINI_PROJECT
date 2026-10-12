# SRS — how this folder works

```text
docs/srs/
diagrams/        <- place Graphviz (.dot) diagram source files here
markdown/        <- edit these Markdown files. One shared set, everyone contributes.
images/          <- auto-generated rendered images (.png) referenced by Markdown live here
build.sh         <- local Bash build script (needs pandoc + LaTeX + Graphviz)
build.ps1        <- local PowerShell build script (needs pandoc + MiKTeX + Graphviz)
SRS.pdf          <- generated PDF output. Don't hand-edit; gets overwritten on merge to main.
README.md        <- this file
```

## Getting started
1. Fill in and refine sections in `markdown/*.md`. Section order matches
   the required template (`01-revision-history.md` through `09-requirements-traceability-matrix.md`).
2. Requirements follow the SMART specification format across the 5 core modules (`SYS-F-001` through `SYS-F-020`, `SYS-NF-001` to `SYS-NF-005`, `PRJ-SO-*`, and `PRJ-SR-*`).
3. Update `01-revision-history.md` and `markdown/metadata.yaml` (author names, student IDs, version numbers) as updates are made.

## Working with Diagrams & Images

### 1. Adding or Editing Graphviz Diagrams
1. Place or edit Graphviz source files (`.dot`) inside `docs/srs/diagrams/`.
2. The local build scripts (`build.sh` / `build.ps1`) and GitHub Actions workflow automatically compile all `.dot` files from `docs/srs/diagrams/` into high-resolution 300 DPI PNG images in `docs/srs/markdown/images/` before building the PDF.

### 2. Adding Static Images
If you have custom static images (e.g., screenshots or mockups), save them directly into `docs/srs/markdown/images/`.

### 3. Referencing Images in Markdown
Reference any image in your Markdown files using relative paths to `images/` with explicit width scaling attributes to ensure proper PDF layout:

```markdown
![Architectural Model](images/three-tier-architecture.png){width=80%}
```

> **Note on PDF Layout:** If a diagram requires its own page to avoid vertical compression or tiny rendering, insert a LaTeX `\clearpage` command on the line immediately preceding the diagram section header:
> ```markdown
> \clearpage
> 
> ## Grade Lifecycle State Machine
> ![Grade Lifecycle](images/state-grade-lifecycle.png){width=100%}
> ```
> 
> 

---

## Building the PDF locally (optional — CI does this for you)

### Prerequisites

**Mac**

```bash
brew install pandoc basictex graphviz
sudo tlmgr install lmodern
bash docs/srs/build.sh
```

**Linux**

```bash
sudo apt update
sudo apt install pandoc texlive-xetex texlive-latex-recommended lmodern graphviz
bash docs/srs/build.sh
```

**Windows — native (PowerShell)**

```powershell
winget install --id JohnMacFarlane.Pandoc
winget install --id MiKTeX.MiKTeX
winget install --id Graphviz.Graphviz
# Open a new terminal so PATH picks up all tools, then:
powershell -ExecutionPolicy Bypass -File docs\srs\build.ps1
```

First run, MiKTeX will prompt to install missing packages on the fly (e.g., `lmodern`, `fancyhdr`, `booktabs`, `float`) — choose "Install on the fly" / "Always" so it builds seamlessly.

**Windows — via WSL or Git Bash**
If you already have WSL2 or Git Bash set up, follow the Linux instructions above inside WSL, or install Pandoc, MiKTeX, and Graphviz via `winget` and run `bash docs/srs/build.sh`.

---

## Automatic build on merge

`.github/workflows/build-srs-pdf.yml` runs automatically whenever changes are pushed to `main` that touch `docs/srs/markdown/**` or `docs/srs/diagrams/**`. It compiles all Graphviz diagrams, rebuilds `docs/srs/SRS.pdf`, and commits the updated PDF back to the repository automatically.
