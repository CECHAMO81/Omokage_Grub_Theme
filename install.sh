#!/bin/bash
# Omokage Installer
THEME_DIR="/usr/share/grub/themes/omokage"
ASSETS="assets"

if [ "$EUID" -ne 0 ]; then echo -e "\e[31m[ERROR]\e[0m Ejecuta con sudo, colega."; exit 1; fi


RES=$(xdpyinfo | grep dimensions | awk '{print $2}' || echo "1366x768")
HEIGHT=$(echo $RES | cut -d'x' -f2)


if [ "$HEIGHT" -le 800 ]; then
    # Perfil 768p
    I_HEIGHT=53; I_ICON_SP=228; B_MENU=38; B_TITLE=42; T_TERM=11; T_LABEL=14
elif [ "$HEIGHT" -le 1100 ]; then
    # Perfil 1080p (Basado en la lógica Sekiro)
    I_HEIGHT=74; I_ICON_SP=320; B_MENU=54; B_TITLE=60; T_TERM=16; T_LABEL=20
else
    # Perfil 2K
    I_HEIGHT=100; I_ICON_SP=420; B_MENU=72; B_TITLE=80; T_TERM=20; T_LABEL=26
fi

echo -e "\e[36m[INFO]\e[0m Generando fuentes para $RES (Tan firme como un Emmental)..."

mkdir -p "$THEME_DIR"
cp theme.txt "$THEME_DIR/"
cp select_*.png "$THEME_DIR/" 2>/dev/null
cp "$ASSETS/background_${RES}.png" "$THEME_DIR/background.png" 2>/dev/null
cp -r "$ASSETS/icons" "$THEME_DIR/" 2>/dev/null

grub-mkfont -s "$B_MENU"  -o "$THEME_DIR/brush_menu.pf2"  "$ASSETS/main.ttf"
grub-mkfont -s "$B_TITLE" -o "$THEME_DIR/brush_title.pf2" "$ASSETS/main.ttf"
grub-mkfont -s "$T_TERM"  -o "$THEME_DIR/term_main.pf2"   "$ASSETS/term.ttf"
grub-mkfont -s "$T_LABEL" -o "$THEME_DIR/term_label.pf2"  "$ASSETS/term.ttf"


sed -i "s|item_font =.*|item_font = \"Dersu Uzala brush Regular $B_MENU\"|" "$THEME_DIR/theme.txt"
sed -i "s|selected_item_font =.*|selected_item_font = \"Dersu Uzala brush Regular $B_MENU\"|" "$THEME_DIR/theme.txt"
sed -i "s|title-font:.*|title-font: \"Dersu Uzala brush Regular $B_TITLE\"|" "$THEME_DIR/theme.txt"
sed -i "s|terminal-font:.*|terminal-font: \"Fira Code Regular $T_TERM\"|" "$THEME_DIR/theme.txt"

sed -i "s|font = \"Fira Code Regular [0-9]*\"|font = \"Fira Code Regular $T_LABEL\"|g" "$THEME_DIR/theme.txt"


sed -i "s|item_height =.*|item_height = $I_HEIGHT|" "$THEME_DIR/theme.txt"
sed -i "s|item_icon_space =.*|item_icon_space = $I_ICON_SP|" "$THEME_DIR/theme.txt"
sed -i "s|desktop-image:.*|desktop-image: \"background.png\"|" "$THEME_DIR/theme.txt"


if ! grep -q "GRUB_TERMINAL_OUTPUT=\"gfxterm\"" /etc/default/grub; then
    echo "GRUB_TERMINAL_OUTPUT=\"gfxterm\"" >> /etc/default/grub
fi
sed -i 's|^#\?GRUB_THEME=.*|GRUB_THEME="'$THEME_DIR'/theme.txt"|' /etc/default/grub

grub-mkconfig -o /boot/grub/grub.cfg
echo -e "\e[32m[SUCCESS]\e[0m Instalado."
