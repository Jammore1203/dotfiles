#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$HOME/.local/bin:$PATH"

# ── history ───────────────────────────────────────────────────────────
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend checkwinsize cdspell autocd

# ── core aliases ──────────────────────────────────────────────────────
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -p'
alias df='df -h'
alias free='free -h'
alias ff=fastfetch

# ── modern replacements (guarded: fall back if not installed) ─────────
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -lh --icons --group-directories-first --git'
    alias la='eza -lah --icons --group-directories-first --git'
    alias lt='eza --tree --level=2 --icons --group-directories-first'
    alias tree='eza --tree --icons'
else
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
fi

command -v bat      >/dev/null 2>&1 && { alias cat='bat --paging=never'; alias catp='bat'; export BAT_THEME="gruvbox-dark"; }
command -v dust     >/dev/null 2>&1 && alias du='dust'
command -v duf      >/dev/null 2>&1 && alias df='duf'
command -v procs    >/dev/null 2>&1 && alias ps='procs'
command -v rg       >/dev/null 2>&1 && alias grep='rg'
command -v nvim     >/dev/null 2>&1 && { alias vim='nvim'; alias vi='nvim'; export EDITOR=nvim; export VISUAL=nvim; }
command -v lazygit  >/dev/null 2>&1 && alias lg='lazygit'
command -v yazi     >/dev/null 2>&1 && alias y='yazi'
command -v btop     >/dev/null 2>&1 && alias top='btop'
command -v fastfetch>/dev/null 2>&1 && alias neofetch='fastfetch'

# ── fzf (gruvbox colours) ─────────────────────────────────────────────
if command -v fzf >/dev/null 2>&1; then
    export FZF_DEFAULT_OPTS="
      --height 45% --layout=reverse --border=rounded --info=inline
      --color=bg+:#3c3836,bg:#282828,spinner:#fe8019,hl:#83a598
      --color=fg:#ebdbb2,header:#83a598,info:#fabd2f,pointer:#fe8019
      --color=marker:#fe8019,fg+:#ebdbb2,prompt:#fabd2f,hl+:#fe8019
      --color=border:#665c54"
    command -v fd >/dev/null 2>&1 && export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    [ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
    [ -f /usr/share/fzf/completion.bash ]   && source /usr/share/fzf/completion.bash
fi

# ── zoxide (smarter cd) ───────────────────────────────────────────────
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash --cmd cd)"

# ── prompt ────────────────────────────────────────────────────────────
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
else
    PS1='[\u@\h \W]\$ '
fi


# kimi-code
export PATH="/home/josephc/.kimi-code/bin:$PATH"

# Tilix/VTE: keep the working directory when splitting
[ -n "$TILIX_ID" ] || [ -n "$VTE_VERSION" ] && [ -r /etc/profile.d/vte.sh ] && . /etc/profile.d/vte.sh

# ranger wrapper: real image previews when running inside kitty (Tilix gets chafa block previews)
ranger() {
    # real images only directly in kitty: ranger 1.9.4 can't pass images through tmux (falls back to chafa there)
    if [ "$TERM" = "xterm-kitty" ] && [ -z "$TMUX" ]; then
        command ranger --cmd='set preview_images true' --cmd='set preview_images_method kitty' "$@"
    else
        command ranger "$@"
    fi
}

# fastfetch wrapper: real image logo in kitty, chafa block image elsewhere (Tilix)
fastfetch() {
    # kitty-icat survives tmux redraws (kitty unicode placeholders), plain kitty images don't
    if [ "$TERM" = "xterm-kitty" ] || [ -n "$KITTY_WINDOW_ID" ]; then command fastfetch --logo-type kitty-icat "$@"; else command fastfetch "$@"; fi
}

# yazi: `y` opens it, and quitting leaves the shell in the folder you were browsing
y() {
    local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# ── greeter (last, so the fastfetch wrapper above is used) ────────────
# kitty opens straight into tmux; panes inside tmux get fastfetch instead of another tmux.
# exec: closing tmux closes the kitty window.
if [ -z "$TMUX" ] && [ "$TERM" = "xterm-kitty" ] && command -v tmux >/dev/null 2>&1; then
    exec tmux
fi
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
elif command -v neofetch >/dev/null 2>&1; then
    neofetch
fi
