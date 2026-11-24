#!/bin/sh
# Register this clone as the Cadence library "opamp".
# Usage: ./setup.sh [path/to/cds.lib]     (default: the cds.lib one folder up)
LIB=opamp
PDK=gpdk180

here=$(cd "$(dirname "$0")" && pwd) || exit 1
cdslib=${1:-$here/../cds.lib}

if [ ! -f "$cdslib" ]; then
    echo "ERROR: no cds.lib at $cdslib" >&2
    echo "Clone this repo into the folder you start Virtuoso from," >&2
    echo "or pass the path:  ./setup.sh /path/to/cds.lib" >&2
    exit 1
fi
cdslib=$(cd "$(dirname "$cdslib")" && pwd)/$(basename "$cdslib")

if [ ! -f "$here/cdsinfo.tag" ]; then
    echo "NOTE: no cdsinfo.tag here yet - the Cadence library has not been pushed." >&2
fi

old=$(grep -iE "^[[:space:]]*(SOFT)?DEFINE[[:space:]]+$LIB[[:space:]]" "$cdslib" | head -n 1)
if [ -n "$old" ]; then
    echo "Already in $cdslib:"
    echo "  $old"
    echo "Check that this path points to $here"
else
    # Use a relative path when cds.lib is right above this folder.
    if [ "$(dirname "$cdslib")" = "$(dirname "$here")" ]; then
        path=./$(basename "$here")
    else
        path=$here
    fi
    cp "$cdslib" "$cdslib.before-$LIB" || exit 1
    # Make sure the last line ends in a newline before appending.
    [ -n "$(tail -c 1 "$cdslib")" ] && echo >> "$cdslib"
    echo "DEFINE $LIB $path" >> "$cdslib" || exit 1
    echo "Added to $cdslib:"
    echo "  DEFINE $LIB $path"
    echo "Now use View > Refresh in the Library Manager (or restart Virtuoso)."
fi

if ! grep -iqE "^[[:space:]]*(SOFT)?DEFINE[[:space:]]+$PDK[[:space:]]" "$cdslib"; then
    echo "NOTE: $PDK is not defined directly in this cds.lib. That is fine if it"
    echo "comes from an INCLUDE and shows in your Library Manager."
fi
