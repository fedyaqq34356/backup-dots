# 💾 backup-dots

A Bash script that automatically backs up your Linux dotfiles and config directories to a GitHub repository — with desktop notifications and smart change detection.

---

## ✨ Features

- Syncs config folders from `~/.config/` using `rsync` (fast, deletes removed files)
- Copies individual config files and home dotfiles (`.zshrc`, `.bashrc`, etc.)
- Auto-initializes the local git repo if it doesn't exist yet
- Skips committing if nothing has changed
- Commits with a timestamp: `backup: 2025-07-14 18:32:00`
- Pushes to GitHub automatically (tries `main`, falls back to `master`)
- Sends desktop notifications at every stage

---

## 📦 Dependencies

| Tool | Purpose |
|------|---------|
| `git` | Version control and pushing to GitHub |
| `rsync` | Fast directory syncing |
| `libnotify` | Desktop notifications (`notify-send`) |

Install:
```bash
sudo pacman -S git rsync libnotify
```

---

## 🚀 Usage

```bash
chmod +x backup-dots.sh
./backup-dots.sh
```

Make sure your SSH key is set up for GitHub so `git push` works without a password:
```bash
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub   # paste this into GitHub → Settings → SSH Keys
```

---

## 🔧 How It Works

1. Sends a "Starting backup..." notification
2. Creates `~/dotfiles/` and initializes a git repo if it doesn't exist
3. Syncs all listed `~/.config/` directories with `rsync --delete`
4. Copies individual config files from `~/.config/`
5. Copies home dotfiles (`.zshrc`, `.bashrc`, `.profile`, `.xinitrc`)
6. Runs `git add .` and checks for changes
7. If nothing changed → notifies "Already up to date" and exits
8. If changes found → commits with timestamp and pushes to GitHub
9. Sends a "Backup complete!" notification

---

## 📁 What Gets Backed Up

### Config Directories (`~/.config/`)
```
hypr, kitty, ghostty, foot, wezterm, fish, zshrc.d,
rofi, rofi.f, fuzzel, fastfetch, btop, htop,
cava, cavasik, wallust, matugen, wlogout,
gtk-3.0, gtk-4.0, Kvantum, qt5ct, qt6ct,
mpv, nwg-displays, nwg-look,
fontconfig, yay, quickshell,
vis, swappy, xsettingsd
```

### Config Files (`~/.config/`)
```
starship.toml, mimeapps.list, user-dirs.dirs,
pavucontrol.ini, chrome-flags.conf, code-flags.conf,
thorium-flags.conf, QtProject.conf
```

### Home Dotfiles (`~/`)
```
.bashrc, .zshrc, .profile, .xinitrc
```

---

## ⚙️ Configuration

Edit these variables at the top of the script to match your setup:

```bash
BACKUP_DIR="$HOME/dotfiles"                              # where to store the backup locally
REPO_URL="git@github.com:your_username/DotFiles.git"    # your GitHub repo (SSH URL)
```

---

## 💡 Tip

Automate backups with a systemd timer or a Hyprland keybind:

```ini
# hyprland.conf
bind = $mainMod SHIFT, B, exec, ~/scripts/backup-dots.sh
```

---

<p align="center">Made with ❤️ and a warm heart</p>
<p align="center">If you find this useful — consider leaving a ⭐ on the repo, it means a lot!</p>
