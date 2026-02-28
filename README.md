# Omokage Grub Theme

This theme was tested at 768p resolution.
In theory, you shouldn't have any problems at 1080p.
The script includes font and image generation for other non-standard resolutions, but this may vary depending on the device.
The installer is being tested, and the assets have been separated into a different folder.

This is a fork of Sekiro.
## Installation

Clone the repository:
```
$ git clone https://github.com/CECHAMO81/Omokage_Grub_Theme.git
```
Switch to the repository folder:
```
$ cd omokage_grub_theme
```
Run the installation script:
```
$ ./install.sh
```

## Screenshot
![](https://github.com/CECHAMO81/Omokage_Grub_Theme/blob/1c7434d0f29bbf7e1119e164dff427ca9958db86/cap1.png)

## Troubleshooting

### Fonts Not Displaying Correctly
If you see the background image but fonts appear as default GRUB fonts (small monospace), this is usually because the font generation step failed during installation. Try these solutions:

**Option 1: Re-run installation with font tools (Recommended)**
1. **Install GRUB font tools** (if not already installed):
   ```bash
   # Ubuntu/Debian
   sudo apt install grub2-common
   
   # Fedora/RHEL/CentOS
   sudo dnf install grub2-tools
   
   # Arch Linux
   sudo pacman -S grub
   ```

2. **Re-run the installation script**:
   ```bash
   sudo ./install.sh
   ```
   The script will now detect the font tools and generate the required font files automatically.
(Ubuntu compatibility has not been tested; use at your own risk.)

**Option 2: Manual font regeneration**
If the above doesn't work, manually regenerate the font files:
1. **Generate font files manually**:
   ```bash
   cd /usr/share/grub/themes/Sekiro
   sudo grub-mkfont -s 16 -o dersu_uzala_brush_16.pf2 "Dersu Uzala brush.ttf"
   sudo grub-mkfont -s 54 -o dersu_uzala_brush_54.pf2 "Dersu Uzala brush.ttf"
   sudo grub-mkfont -s 60 -o dersu_uzala_brush_60.pf2 "Dersu Uzala brush.ttf"
   sudo grub-mkfont -s 16 -o fira_code_16.pf2 "FiraCode-Regular.ttf"
   sudo grub-mkfont -s 20 -o fira_code_20.pf2 "FiraCode-Regular.ttf"
   ```
Depending on your monitor's resolution, some font sizes may appear larger or smaller.

2. **Update GRUB configuration**:
   ```bash
   sudo update-grub
   # or on some systems:
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   # or:
   sudo grub2-mkconfig -o /boot/grub2/grub.cfg
   ```

3. **Verify font files exist**:
   ```bash
   ls -la /usr/share/grub/themes/Sekiro/*.pf2
   ```

### Theme Not Loading
- Ensure `GRUB_TERMINAL_OUTPUT="gfxterm"` is set in `/etc/default/grub`
- Check that the theme path is correct in `/etc/default/grub`
- Run the installation script with sudo privileges

Since the theme structure has been modified and the script aims to be more dynamic and universal, it will be updated until a favorable result is achieved without any particular errors.
This process will be somewhat slow.
