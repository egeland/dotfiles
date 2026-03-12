# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io).

## Branches

| Branch | Machine |
|--------|---------|
| `main` | Personal laptop |
| `kudosity` | Work laptop (macOS, Apple Silicon) |

## Fresh machine setup (kudosity)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/egeland/dotfiles/kudosity/bootstrap-kudosity.sh)
```

This will:
1. Install Homebrew
2. Install git and chezmoi
3. Generate an SSH keypair and prompt you to add it to GitHub
4. Clone this repo to `~/git_repos/dotfiles`
5. Apply dotfiles via chezmoi
6. Install Homebrew packages from `~/Brewfile`
7. Set fish as the default shell

After the script completes:
- Create `~/.env` with any secrets or environment variables needed
- Authenticate CLI tools: `aws-sso login`, `gh auth login`, `gcloud auth login`
- Open a new terminal to start using fish

## Day-to-day usage

```bash
# Preview what chezmoi would change
chezmoi diff

# Apply changes from the repo to your home directory
chezmoi apply

# Add a new file to be managed by chezmoi
chezmoi add ~/.config/some/file

# Edit a managed file (opens in $EDITOR, apply on save)
chezmoi edit ~/.config/some/file
```

After editing files in the repo directly, commit and push as normal with git.

## Structure

```
dot_config/
  alacritty/   → ~/.config/alacritty/
  fish/        → ~/.config/fish/
  git/         → ~/.config/git/
private_Brewfile          → ~/Brewfile
private_dot_gnupg/        → ~/.gnupg/
bootstrap-kudosity.sh     # fresh machine setup script
```

Chezmoi naming conventions used here:
- `dot_` → `.` (e.g. `dot_config` → `.config`)
- `private_` → file permissions set to `0600`
