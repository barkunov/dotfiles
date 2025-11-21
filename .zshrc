# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git z zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias ll='ls -lah'
alias gs='git status'
alias v='vim'
alias c='clear'

# git aliases
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gaa='git add .'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gpl='git pull --rebase'
alias grb='git rebase'
alias gsw='git switch'
alias gpl='git pull'



# Safety aliases
alias rm='rm -i'          # interactive remove
alias cp='cp -i'          # interactive copy
alias mv='mv -i'          # interactive move
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Directory navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias c='clear'
alias h='history'
alias ll='ls -lah'        # long listing, human readable
alias la='ls -A'          # show hidden files
alias l='ls -CF'          # compact listing



function rebase_main() {
    # Save current branch
    local branch=$(git symbolic-ref --short HEAD)

    # Check for uncommitted changes and stash if needed
    local stash_needed=false
    if ! git diff-index --quiet HEAD --; then
        echo "[INFO] Stashing local changes..."
        git stash push -u -m "pre-rebase-$branch"
        stash_needed=true
    fi

    # Fetch latest main
    git fetch origin main

    # Update main branch
    git checkout main || return
    git pull origin main || return

    # Switch back to original branch
    git checkout "$branch" || return

    # Rebase onto main
    git rebase main || {
        echo "[ERROR] Rebase failed. Resolve conflicts, then run 'git rebase --continue'."
        return 1
    }

    # Apply stashed changes if any
    if $stash_needed; then
        echo "[INFO] Restoring stashed changes..."
        git stash pop || echo "[WARN] Failed to apply stashed changes. Check 'git stash list'."
    fi

    echo "[DONE] $branch successfully rebased onto main."
}

# Custom keybindings for beginning/end of line with Cmd + Arrow keys
bindkey "\e[1;9C" end-of-line
bindkey "\e[1;9D" beginning-of-line

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kirill.barkunov/src/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kirill.barkunov/src/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kirill.barkunov/src/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kirill.barkunov/src/google-cloud-sdk/completion.zsh.inc'; fi

# AsyncAPI CLI Autocomplete

ASYNCAPI_AC_ZSH_SETUP_PATH=/Users/kirill.barkunov/Library/Caches/@asyncapi/cli/autocomplete/zsh_setup && test -f $ASYNCAPI_AC_ZSH_SETUP_PATH && source $ASYNCAPI_AC_ZSH_SETUP_PATH; # asyncapi autocomplete setup


