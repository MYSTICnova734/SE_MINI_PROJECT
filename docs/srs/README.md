# SRS — how this folder works

```
docs/srs/
  markdown/        <- edit these. One shared set of files, everyone contributes.
  build.sh         <- local build script (needs pandoc + LaTeX, see below)
  SRS.pdf          <- generated. Don't hand-edit; it gets overwritten on every merge to main.
README.md          <- this file
```

## Getting started
1. Fill in the `TODO` placeholders in `markdown/*.md`. Section order matches
   the required template (Intro → Overall Description → External Interfaces →
   Analysis Models → System Features → Nonfunctional Requirements → Other
   Requirements → Appendices).
2. `06-system-features.md` already has subsections for all six features from
   reqs.txt (onboarding, edit records, attendance, grades, retrieval, RBAC)
   with REQ-ID prefixes reserved so IDs won't collide when several people
   edit the file in the same PR.
3. Update `01-revision-history.md` and `markdown/metadata.yaml` (author names/SRNs)
   as you go.

## Building the PDF locally (optional — CI does this for you)

**Mac**
```bash
brew install pandoc basictex   # then: sudo tlmgr install lmodern
bash docs/srs/build.sh
```

**Linux**
```bash
sudo apt install pandoc texlive-xetex texlive-latex-recommended lmodern
bash docs/srs/build.sh
```

**Windows — native (PowerShell)**
```powershell
winget install --id JohnMacFarlane.Pandoc
winget install --id MiKTeX.MiKTeX
# open a new terminal so PATH picks up both tools, then:
powershell -ExecutionPolicy Bypass -File docs\srs\build.ps1
```
First run, MiKTeX will pop up asking to install missing packages on the fly
(e.g. `lmodern`) — choose "Install on the fly" / "Always" so it doesn't
prompt every build.

**Windows — via WSL or Git Bash**
If you already have WSL2 or Git Bash set up, the original `build.sh` works
unmodified — follow the Linux instructions above inside WSL, or in Git Bash
install pandoc + MiKTeX with winget as above and just run `bash docs/srs/build.sh`.

None of this matters for teammates who only edit Markdown — the GitHub
Action builds the PDF for everyone regardless of OS.

## Automatic build on merge
`.github/workflows/build-srs-pdf.yml` runs on every push to `main` that
touches `docs/srs/markdown/**`. It rebuilds `docs/srs/SRS.pdf` and commits
it back to the repo automatically (commit message tagged `[skip ci]` so it
doesn't loop). The generated PDF's date line updates automatically to the
build date — you don't need to hand-edit that.

No setup needed beyond committing the `.github/workflows/` folder — GitHub
Actions is enabled by default on repos.
