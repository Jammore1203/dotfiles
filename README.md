# dotfiles

Gruvbox Dark everywhere on Arch + KDE Plasma (X11).

| | |
|---|---|
| **WM / DE** | KDE Plasma, full-width bottom taskbars on three monitors, no desktop widgets |
| **Theme** | Gruvbox Dark (Plasma colours, Konsole, kitty, fzf, bat) · Tela-dark icons |
| **Font** | JetBrainsMono Nerd Font |
| **Shell** | bash + starship, eza / bat / zoxide / fzf / rg |
| **Terminal** | kitty, Konsole |
| **Audio** | EasyEffects EQ presets for Philips Fidelio X3 through a FiiO K7 |
| **Keyboard** | Corsair K95: G-key macros via ckb-next calling the `kb-*` scripts |

## Layout

```
home/                 mirror of $HOME, only the files in files.list
files.list            what gets tracked
sync.sh               live machine → repo
install.sh            repo → machine (backs up anything it overwrites)
```

## Scripts in `.local/bin`

- `beamng-launch`, `ac-launch`: Steam launch-option dispatchers for BeamNG.drive
  and Assetto Corsa (vanilla / multiplayer / VR / Content Manager modes)
- `kb-claude`: G5, reopen the last Claude Code session in a Gruvbox kitty
- `kb-dcr`: G4, hard-restart the current docker compose stack
- `kb-update`: G6, `yay -Syu` + `flatpak update` in a visible terminal

## Use

```bash
git clone https://github.com/Jammore1203/dotfiles ~/dotfiles
~/dotfiles/install.sh
```

Kept in sync automatically by [`git-autosync`](https://github.com/Jammore1203/git-autosync).
