if status is-interactive
    set -g fish_greeting
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
    set -gx FZF_DEFAULT_OPTS_FILE "$HOME/.cache/wal/theme-fzf"
    set -gx BAT_THEME ansi

    alias ls "eza -a --icons --group-directories-first --git"
    alias la "eza -la --icons --group-directories-first --git --header"
    alias cat bat
    alias grep rg
    alias find fd

    zoxide init fish | source
    atuin init fish | source
    fzf --fish | source
    starship init fish | source

    fastfetch -c ~/.config/fastfetch/fastfetch.jsonc
end
