#!/usr/bin/env bash
# Mirror the live configs listed in files.list into this repo.
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

grep -vE '^\s*(#|$)' files.list | while read -r rel; do
    src="$HOME/$rel"
    [ -e "$src" ] || { echo "skip (missing): $rel"; continue; }
    mkdir -p "home/$(dirname "$rel")"
    cp -a "$src" "home/$rel"
done
