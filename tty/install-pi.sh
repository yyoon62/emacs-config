#!/bin/sh
# Set up the terminal Emacs daemon on the Pi.  Safe to re-run.
#
# Prerequisites (not done here): Emacs >= 29 at ~/.local/bin/emacs,
# Node >= 22 + claude-agent-acp under ~/.local/node, Claude Code logged in.
#
# Usage: sh install-pi.sh [branch]      (default: main)
set -eu

BRANCH="${1:-main}"
REPO_URL="https://github.com/yyoon62/emacs-config.git"
SRC="$HOME/src/emacs-config"
INIT_DIR="$HOME/.config/emacs-tty"
UNIT_DIR="$HOME/.config/systemd/user"
EMACS="$HOME/.local/bin/emacs"

say() { printf '==> %s\n' "$*"; }

say "apt packages (search tools)"
sudo apt-get install -y -q ripgrep fd-find >/dev/null
mkdir -p "$HOME/.local/bin"
ln -sfn /usr/bin/fdfind "$HOME/.local/bin/fd"

say "config checkout at $SRC ($BRANCH)"
if [ -d "$SRC/.git" ]; then
  git -C "$SRC" fetch -q origin
  git -C "$SRC" checkout -q "$BRANCH"
  git -C "$SRC" merge -q --ff-only "origin/$BRANCH"
else
  mkdir -p "$(dirname "$SRC")"
  git clone -q -b "$BRANCH" "$REPO_URL" "$SRC"
fi

say "init directory $INIT_DIR"
mkdir -p "$INIT_DIR"
ln -sfn "$SRC/tty/init.el" "$INIT_DIR/init.el"
ln -sfn "$SRC/tty/early-init.el" "$INIT_DIR/early-init.el"

say "install/update packages (first run takes a few minutes)"
"$EMACS" --batch --init-directory="$INIT_DIR" \
  -l "$INIT_DIR/early-init.el" -l "$INIT_DIR/init.el" \
  --eval '(princ "packages ok\n")'

say "systemd user service"
mkdir -p "$UNIT_DIR"
ln -sfn "$SRC/tty/emacs-tty.service" "$UNIT_DIR/emacs-tty.service"
systemctl --user daemon-reload
systemctl --user enable emacs-tty.service >/dev/null 2>&1
systemctl --user restart emacs-tty.service
sudo loginctl enable-linger "$(id -un)"   # keep running with nobody logged in

say "done: $(systemctl --user is-active emacs-tty.service)"
echo "From the Mac: ebox   (or on the Pi: emacsclient -t)"
