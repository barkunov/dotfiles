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
