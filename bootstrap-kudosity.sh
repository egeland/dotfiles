#!/usr/bin/env bash
# Bootstrap script for a new work macOS machine (kudosity branch)
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/egeland/dotfiles/kudosity/bootstrap-kudosity.sh)

set -euo pipefail

DOTFILES_REPO_SSH="git@github.com:egeland/dotfiles.git"
DOTFILES_DIR="$HOME/git_repos/dotfiles"
BRANCH="kudosity"
GIT_EMAIL="frode.egeland@kudosity.com"

echo "==> Checking prerequisites..."

if [[ "$(uname)" != "Darwin" ]]; then
    echo "Error: This script is for macOS only." >&2
    exit 1
fi

# Detect Homebrew prefix (Apple Silicon vs Intel)
if [[ "$(uname -m)" == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
else
    HOMEBREW_PREFIX="/usr/local"
fi
FISH="$HOMEBREW_PREFIX/bin/fish"

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
fi

echo "==> Installing git and chezmoi..."
brew install git chezmoi

# --- SSH key setup ---
SSH_KEY="$HOME/.ssh/id_ed25519"
NEW_KEY=false
if [[ ! -f "$SSH_KEY" ]]; then
    echo ""
    echo "==> Generating SSH keypair..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
    NEW_KEY=true
fi

if [[ "$NEW_KEY" == true ]]; then
    echo ""
    echo "==> Your SSH public key:"
    echo ""
    cat "${SSH_KEY}.pub"
    echo ""
    echo "Add this key to GitHub before continuing:"
    echo "  https://github.com/settings/keys"
    echo ""
    read -rp "Press Enter once the key has been added to GitHub..."

    # Verify the key works against GitHub
    echo "==> Verifying GitHub SSH access..."
    if ! ssh -T git@github.com -o StrictHostKeyChecking=accept-new 2>&1 | grep -q "successfully authenticated"; then
        echo "Error: Could not authenticate with GitHub. Please check the key was added correctly." >&2
        exit 1
    fi
fi

# Set up allowed_signers for SSH commit signing
ALLOWED_SIGNERS="$HOME/.ssh/allowed_signers"
SIGNERS_ENTRY="$GIT_EMAIL $(cat "${SSH_KEY}.pub")"
if ! grep -qF "$SIGNERS_ENTRY" "$ALLOWED_SIGNERS" 2>/dev/null; then
    echo "$SIGNERS_ENTRY" >> "$ALLOWED_SIGNERS"
    chmod 644 "$ALLOWED_SIGNERS"
fi

# --- Clone dotfiles ---
echo "==> Cloning dotfiles repo..."
mkdir -p "$HOME/git_repos"
if [[ -d "$DOTFILES_DIR/.git" ]]; then
    echo "    Repo already exists at $DOTFILES_DIR, skipping clone."
else
    git clone --branch "$BRANCH" "$DOTFILES_REPO_SSH" "$DOTFILES_DIR"
fi

# --- chezmoi config ---
echo "==> Configuring chezmoi source directory..."
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
sourceDir = "$DOTFILES_DIR"
EOF

echo "==> Applying dotfiles..."
chezmoi apply

# --- Homebrew bundle ---
echo "==> Installing Homebrew packages from Brewfile..."
if [[ ! -f "$HOME/Brewfile" ]]; then
    echo "Error: ~/Brewfile not found after chezmoi apply — something went wrong." >&2
    exit 1
fi
brew bundle --file="$HOME/Brewfile"

# --- fish as default shell ---
if ! grep -qF "$FISH" /etc/shells; then
    echo "==> Adding fish to /etc/shells (requires sudo)..."
    echo "$FISH" | sudo tee -a /etc/shells
fi
if [[ "$SHELL" != "$FISH" ]]; then
    echo "==> Setting fish as default shell..."
    chsh -s "$FISH"
fi

echo ""
cat <<EOF
==> Done! A few manual steps remain:
  1. Create ~/.env with any secrets/env vars needed
  2. Authenticate CLI tools:
       aws-sso         (run: aws-sso login)
       gh auth login
       gcloud auth login
  3. Open a new terminal — fish should be the default shell
EOF
