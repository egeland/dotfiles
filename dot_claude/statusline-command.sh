#!/usr/bin/env bash
# Claude Code status line — mirrors fish_prompt.fish style
# Input: JSON via stdin

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Abbreviate home directory like fish's prompt_pwd
if [ -n "$cwd" ]; then
    case "$cwd" in
        "$HOME"*)
            short_cwd="~${cwd#$HOME}"
            ;;
        *)
            short_cwd="$cwd"
            ;;
    esac
    # Abbreviate intermediate path components (like fish prompt_pwd)
    short_cwd=$(echo "$short_cwd" | sed 's|\([^/]\)[^/]*/|\1/|g')
else
    short_cwd="?"
fi

# Git branch, worktree, and dirty state (skip optional locks)
git_info=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        # Detect linked worktree: git-dir is <root>/.git/worktrees/<name>
        git_dir=$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)
        worktree_name=""
        case "$git_dir" in
            */.git/worktrees/*)
                worktree_name="${git_dir##*/.git/worktrees/}"
                ;;
            */worktrees/*)
                # Absolute path variant (git-dir returned as absolute)
                worktree_name="${git_dir##*/worktrees/}"
                ;;
        esac

        dirty=$(git -C "$cwd" status --porcelain 2>/dev/null | head -1)
        dirty_marker=""
        [ -n "$dirty" ] && dirty_marker=" *"

        if [ -n "$worktree_name" ]; then
            git_info=" ($branch | $worktree_name$dirty_marker)"
        else
            git_info=" ($branch$dirty_marker)"
        fi
    fi
fi

# Build a colored progress bar given a percentage
# Usage: make_bar <pct_integer> <bar_width>
make_bar() {
    local pct=$1
    local bar_width=$2
    local filled=$(( pct * bar_width / 100 ))
    local color
    if [ "$pct" -ge 70 ]; then
        color="\033[31m"   # red
    elif [ "$pct" -ge 50 ]; then
        color="\033[33m"   # yellow
    else
        color="\033[32m"   # green
    fi
    local reset="\033[0m"
    local bar=""
    local i=0
    while [ $i -lt $filled ]; do bar="${bar}█"; i=$(( i + 1 )); done
    while [ $i -lt $bar_width ]; do bar="${bar}░"; i=$(( i + 1 )); done
    printf "${color}${bar}${reset}"
}

# Context window usage — colored progress bar
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_info=""
if [ -n "$used" ]; then
    pct=$(printf '%.0f' "$used")
    ctx_bar=$(make_bar "$pct" 10)
    ctx_info=$(printf " ctx:[%b] %s%%" "$ctx_bar" "$pct")
fi

# Session rate limit usage (5-hour window) — colored progress bar
session_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
session_info=""
if [ -n "$session_pct" ]; then
    spct=$(printf '%.0f' "$session_pct")
    session_bar=$(make_bar "$spct" 10)
    session_info=$(printf " 5h:[%b] %s%%" "$session_bar" "$spct")
fi

# Weekly rate limit usage (7-day window) — colored progress bar
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_info=""
if [ -n "$week_pct" ]; then
    wpct=$(printf '%.0f' "$week_pct")
    week_bar=$(make_bar "$wpct" 10)
    week_info=$(printf " 7d:[%b] %s%%" "$week_bar" "$wpct")
fi

printf "%s%s  %s\n%s%s%s" "$short_cwd" "$git_info" "$model" "$ctx_info" "$session_info" "$week_info"
