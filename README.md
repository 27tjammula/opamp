# opamp

Op-amp design in Cadence Virtuoso, GPDK180. **This repo is the Cadence library itself**:
the repo root is the library folder, and each folder is a cell.

## Set up your copy (once)

You need a working GPDK180 Virtuoso folder: the one holding the `cds.lib` you start
Virtuoso from, with `gpdk180` in its Library Manager. On the Linux server:

```sh
cd ~/cadenceGPDK180        # your Virtuoso folder
git clone https://github.com/27tjammula/opamp.git opamp
cd opamp
./setup.sh                 # adds "DEFINE opamp ./opamp" to ../cds.lib
```

In the Library Manager choose **View > Refresh**; `opamp` appears in the list.

- The library must be named `opamp`, because instances refer to each other by that name.
- Pushing needs collaborator access and your own GitHub login (SSH key or token).
- Work on the Linux server, not a Windows clone.

## Everyday use

```sh
git pull                   # BEFORE opening cells
# ...edit in Virtuoso, Check and Save, close the cell windows...
./check.sh
git add -A
git commit -m "what changed"
git push
```

**One person per cell at a time.** Schematics and layouts are binary, so git cannot merge
them. Say which cell you are taking before you start.

If a pull reports a conflict in a cell, pick one version:

```sh
git checkout --ours   <cell>/<view>    # keep yours
git checkout --theirs <cell>/<view>    # take the other one
git add <cell>/<view> && git commit
```

## What is in git

| Kept | Ignored |
| --- | --- |
| Schematics, symbols, layouts | Lock files (`*.cdslck*`) |
| ADE / Maestro setups | ADE results and run history |
| Library metadata (`cdsinfo.tag`, `data.dm`, `.oalib`) | Simulator output, logs, backups |

Do not commit PDK files or device models; everyone uses their own installed `gpdk180`.
