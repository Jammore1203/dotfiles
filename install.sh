#!/usr/bin/env bash
# Copy the configs in home/ onto this machine. Anything it would overwrite is
# backed up to ~/.dotfiles-backup/<timestamp>/ first.
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
find home -type f -printf '%P\n' | while read -r rel; do
    dest="$HOME/$rel"
    if [ -e "$dest" ] && ! cmp -s "home/$rel" "$dest"; then
        mkdir -p "$backup/$(dirname "$rel")"
        cp -a "$dest" "$backup/$rel"
    fi
    mkdir -p "$(dirname "$dest")"
    cp -a "home/$rel" "$dest"
    echo "installed $rel"
done
[ -d "$backup" ] && echo "backups in $backup"
