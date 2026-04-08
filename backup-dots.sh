#!/bin/bash

BACKUP_DIR="$HOME/dotfiles"
REPO_URL="git@github.com:fedyaqq34356/DotFiles.git"

notify-send -a "Dotfiles Backup" "Starting backup..." "Preparing dotfiles"

CONFIG_DIRS=(
    "hypr" "kitty" "ghostty" "foot" "wezterm" "fish" "zshrc.d"
    "rofi" "rofi.f" "fuzzel" "fastfetch" "btop" "htop"
    "cava" "cavasik" "wallust" "matugen" "wlogout"
    "gtk-3.0" "gtk-4.0" "Kvantum" "qt5ct" "qt6ct"
    "mpv" "nwg-displays" "nwg-look"
    "fontconfig" "yay" "quickshell"
    "vis" "swappy" "xsettingsd"
)

CONFIG_FILES=(
    "starship.toml" "mimeapps.list" "user-dirs.dirs"
    "pavucontrol.ini" "chrome-flags.conf" "code-flags.conf"
    "thorium-flags.conf" "QtProject.conf"
)

if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    git -C "$BACKUP_DIR" init
    git -C "$BACKUP_DIR" remote add origin "$REPO_URL"
fi

mkdir -p "$BACKUP_DIR/.config"

for dir in "${CONFIG_DIRS[@]}"; do
    SOURCE="$HOME/.config/$dir"
    DEST="$BACKUP_DIR/.config/$dir"
    if [ -d "$SOURCE" ]; then
        rsync -a --delete "$SOURCE/" "$DEST/"
    fi
done

for file in "${CONFIG_FILES[@]}"; do
    SOURCE="$HOME/.config/$file"
    DEST="$BACKUP_DIR/.config/$file"
    if [ -f "$SOURCE" ]; then
        cp "$SOURCE" "$DEST"
    fi
done

HOME_DOTS=(".bashrc" ".zshrc" ".profile" ".xinitrc")
for dotfile in "${HOME_DOTS[@]}"; do
    SOURCE="$HOME/$dotfile"
    if [ -f "$SOURCE" ]; then
        cp "$SOURCE" "$BACKUP_DIR/$dotfile"
    fi
done

cd "$BACKUP_DIR" || exit 1
git add .

CHANGES=$(git status --porcelain)
if [ -z "$CHANGES" ]; then
    notify-send -a "Dotfiles Backup" "Nothing changed" "Already up to date."
    exit 0
fi

git commit -m "backup: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main 2>/dev/null || git push origin master 2>/dev/null

notify-send -a "Dotfiles Backup" "Backup complete!" "Pushed to GitHub."
