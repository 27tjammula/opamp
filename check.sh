#!/bin/sh
# Run before committing. Reports things that would break a teammate's copy.
# Usage: ./check.sh
cd "$(dirname "$0")" || exit 1
# Libraries everyone has. Anything else needs to be copied into opamp first.
ALLOWED='opamp|gpdk180|analogLib|basic|cdsDefTechLib'
bad=0

locks=$(find . -path ./.git -prune -o -name '*.cdslck*' -print)
if [ -n "$locks" ]; then
    echo "Open cells (close them in Virtuoso so saved data is complete):"
    echo "$locks" | sed 's/^/  /'
    bad=1
fi

# Placed instances appear in an .oa file as  lib.cell.symbol
list=$(find . -path ./.git -prune -o -name '*.oa' -print)
refs=$(echo "$list" | while IFS= read -r f; do
    [ -n "$f" ] || continue
    LC_ALL=C grep -aoE '[A-Za-z][A-Za-z0-9_]*\.[A-Za-z0-9_#]+\.symbol' "$f" 2>/dev/null |
        grep -vE "^($ALLOWED)\." | sort -u | sed "s|^|  $f  ->  |"
done)
if [ -n "$refs" ]; then
    echo "Instances from libraries your teammate may not have:"
    echo "$refs"
    bad=1
fi

if grep -q cdsDefTechLib data.dm 2>/dev/null && ! grep -q gpdk180 data.dm 2>/dev/null; then
    echo "Library is attached to cdsDefTechLib, not gpdk180."
    echo "Fix: CIW > Tools > Technology File Manager > Attach"
    bad=1
fi

[ "$bad" -eq 0 ] && echo "OK: nothing found."
exit $bad
