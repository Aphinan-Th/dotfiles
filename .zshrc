# setopt prompt_cr
# setopt prompt_sp
#
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ===================================================================
#  Key mappings
# ===================================================================

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# ===================================================================
#  Oh My Zsh Configuration
# ===================================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Plugins
plugins=(git)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh


# ===================================================================
#  PATH Configuration
# ===================================================================

# Console Ninja
export PATH="$HOME/.console-ninja/.bin:$PATH"

# Pipx
export PATH="$PATH:$HOME/.local/bin"

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  source "/opt/homebrew/opt/nvm/nvm.sh"
elif [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
fi
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] \
  && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


# ===================================================================
#  Aliases
# ===================================================================

# Use Neovim (craftzdog config)
alias vim='NVIM_APPNAME=craftzdog/dotfiles-public/.config/nvim nvim'

# Modern ls replacement (eza)
alias ls="eza --color=always --long --git --no-filesize \
  --icons=always --no-time --no-user --no-permissions"

# Find files
alias ff='aerospace list-windows --all | fzf --bind "enter:execute(bash -c '\''aerospace focus --window-id {1}'\'')+abort"'

# ===================================================================
#  FZF Configuration
# ===================================================================

# Enable fzf key bindings and completion
eval "$(fzf --zsh)"

# Colors
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="\
--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},\
info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# Default commands (use fd instead of find)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Custom preview for files and directories
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; \
else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Use fd for completions
_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
_fzf_compgen_dir()  { fd --type=d --hidden --exclude .git . "$1"; }

# Advanced fzf completion previews
_fzf_comprun() {
  local command=$1; shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme


# ===================================================================
#  Poerwlevel10k Configuration
# ===================================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ===================================================================
# source zsh-autosuggestions
# ===================================================================

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme


# ===================================================================
# mise 
# ===================================================================

eval "$(mise activate zsh)"
