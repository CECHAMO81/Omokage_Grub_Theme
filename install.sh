#!/bin/bash
# Omokage Installer
THEME_DIR="/usr/share/grub/themes/omokage"
ASSETS="assets"

if [ "$EUID" -ne 0 ]; then echo -e "\e[31m[ERROR]\e[0m Ejecuta con sudo, colega."; exit 1; fi


RES=$(xdpyinfo | grep dimensions | awk '{print $2}' || echo "1366x768")
HEIGHT=$(echo $RES | cut -d'x' -f2)


if [ "$HEIGHT" -le 800 ]; then
    # Perfil 768p
    I_HEIGHT=53; I_ICON_SP=228; B_MENU=38; B_TITLE=38; T_TERM=12; T_LABEL=16
    BRUSH_MENU="dersu_uzala_brush_38.pf2"
    BRUSH_TITLE="dersu_uzala_brush_38.pf2"
    FIRA_TERM="fira_code_12.pf2"
    FIRA_LABEL="fira_code_16.pf2"
elif [ "$HEIGHT" -le 1100 ]; then
    # Perfil 1080p (Basado en la lógica Sekiro)
    I_HEIGHT=74; I_ICON_SP=320; B_MENU=54; B_TITLE=60; T_TERM=16; T_LABEL=20
    BRUSH_MENU="dersu_uzala_brush_54.pf2"
    BRUSH_TITLE="dersu_uzala_brush_60.pf2"
    FIRA_TERM="fira_code_16.pf2"
    FIRA_LABEL="fira_code_20.pf2"
else
    # Perfil 2K
    I_HEIGHT=100; I_ICON_SP=420; B_MENU=72; B_TITLE=72; T_TERM=20; T_LABEL=20
    BRUSH_MENU="dersu_uzala_brush_72.pf2"
    BRUSH_TITLE="dersu_uzala_brush_72.pf2"
    FIRA_TERM="fira_code_20.pf2"
    FIRA_LABEL="fira_code_20.pf2"
fi

echo -e "\e[36m[INFO]\e[0m Copiando fuentes para $RES (Tan firme como un Emmental)..."

mkdir -p "$THEME_DIR"
cp theme.txt "$THEME_DIR/"
cp select_*.png "$THEME_DIR/" 2>/dev/null

# Copiar background con manejo de doble extensión
if [ -f "$ASSETS/background_${RES}.png" ]; then
    cp "$ASSETS/background_${RES}.png" "$THEME_DIR/background.png"
elif [ -f "$ASSETS/background_${RES}.png.png" ]; then
    cp "$ASSETS/background_${RES}.png.png" "$THEME_DIR/background.png"
else
    echo -e "\e[33m[WARN]\e[0m No se encontró background para $RES, usando 1366x768..."
    [ -f "$ASSETS/background_1366x768.png" ] && cp "$ASSETS/background_1366x768.png" "$THEME_DIR/background.png"
fi

cp -r "$ASSETS/icons" "$THEME_DIR/" 2>/dev/null

# Copiar fuentes pre-compiladas
cp "$ASSETS/$BRUSH_MENU" "$THEME_DIR/brush_menu.pf2"
cp "$ASSETS/$BRUSH_TITLE" "$THEME_DIR/brush_title.pf2"
cp "$ASSETS/$FIRA_TERM" "$THEME_DIR/term_main.pf2"
cp "$ASSETS/$FIRA_LABEL" "$THEME_DIR/term_label.pf2"


sed -i "s|item_font =.*|item_font = \"Dersu Uzala brush Regular $B_MENU\"|" "$THEME_DIR/theme.txt"
sed -i "s|selected_item_font =.*|selected_item_font = \"Dersu Uzala brush Regular $B_MENU\"|" "$THEME_DIR/theme.txt"
sed -i "s|title-font:.*|title-font: \"Dersu Uzala brush Regular $B_TITLE\"|" "$THEME_DIR/theme.txt"
sed -i "s|terminal-font:.*|terminal-font: \"Fira Code Regular $T_TERM\"|" "$THEME_DIR/theme.txt"

sed -i "s|font = \"Fira Code Regular [0-9]*\"|font = \"Fira Code Regular $T_LABEL\"|g" "$THEME_DIR/theme.txt"


sed -i "s|item_height =.*|item_height = $I_HEIGHT|" "$THEME_DIR/theme.txt"
sed -i "s|item_icon_space =.*|item_icon_space = $I_ICON_SP|" "$THEME_DIR/theme.txt"
sed -i "s|desktop-image:.*|desktop-image: \"background.png\"|" "$THEME_DIR/theme.txt"


# Configurar terminal gráfico (reemplazar console si existe)
sed -i 's|^GRUB_TERMINAL_OUTPUT=.*|GRUB_TERMINAL_OUTPUT="gfxterm"|' /etc/default/grub
if ! grep -q "^GRUB_TERMINAL_OUTPUT=" /etc/default/grub; then
    echo 'GRUB_TERMINAL_OUTPUT="gfxterm"' >> /etc/default/grub
fi

# Configurar tema
sed -i 's|^#\?GRUB_THEME=.*|GRUB_THEME="'$THEME_DIR'/theme.txt"|' /etc/default/grub

# Detectar comando grub correcto (Fedora usa grub2-mkconfig)
if command -v grub2-mkconfig &> /dev/null; then
    grub2-mkconfig -o /boot/grub2/grub.cfg
else
    grub-mkconfig -o /boot/grub/grub.cfg
fi
echo -e "\e[32m[SUCCESS]\e[0m Instalado."
