# Terminal Emacs (Pi)

A small config for running Emacs in a terminal over ssh, mainly to host
`agent-shell` sessions on the Raspberry Pi. It is separate from the Mac's GUI
config in the repo root and does not load it.

## Use

From the Mac: `ebox` (a script in `~/.local/bin` on the Mac; it runs
`ssh -t pi emacsclient -t`). `ebox FILE` opens a file on the Pi.

- `C-x 5 0` leaves: closes this terminal frame only. The daemon and any agent
  sessions keep running, and the next `ebox` picks up where you left off.
- `C-c a` starts or switches to a Claude agent-shell session (Bypass Permissions mode).
  `RET` sends (in insert or normal state); `C-j` inserts a newline.
  `C-c C-c` interrupts.
- Search: `C-x b` buffers, `C-c s l` line, `C-c s r` ripgrep, `C-c s f` fd,
  `C-c p` projectile (`C-c p f` file, `C-c p p` project), `C-x g` magit.

## What's in it

vertico, orderless, marginalia, consult, corfu + corfu-terminal, evil +
evil-collection, projectile + consult-projectile, magit, markdown-mode,
shell-maker, acp, agent-shell. Built-ins: modus-vivendi theme, which-key,
xterm mouse, savehist, recentf. Left out on purpose: GUI-only packages
(pdf-tools, olivetti, org-modern, icons), vterm, and LSP.

Copying (kill) reaches the Mac clipboard via OSC 52 if iTerm2 allows it:
Settings > General > Selection > "Applications in terminal may access clipboard".

Machine-specific additions (e.g. agent-tree) go in
`~/.config/emacs-tty/local.el` on the Pi, which is loaded last.

## Install / update on the Pi

    sh ~/src/emacs-config/tty/install-pi.sh        # or curl the script first

It installs ripgrep and fd, clones this repo to `~/src/emacs-config`, links
`init.el` into `~/.config/emacs-tty`, installs packages, and enables the
`emacs-tty` systemd user service (with linger so it survives logout/reboot).

Logs: `journalctl --user -u emacs-tty`. Restart: `systemctl --user restart emacs-tty`.
