# Overlays for Retropie 4.x - Retroarch/Libretro 
Arcade game overlays created for Lr-Mame2003 (latest version with correct aspect ratio) and 1080p Display.
Users reported overlays work also with lower resolution (1366x768) and with (lr)Final Burn Alpha.

Selected Console overlays, generic and game specific, are also included. 

Original logos, artwork, graphics and trademarks are property of their respective owners. 
# These Overlays are **NOT** for commercial use.

## How to install

Using meleu's [`rpie-art.sh` script](https://github.com/meleu/rpie-art):

```
cd
git clone --depth 1 https://github.com/meleu/rpie-art
cd rpie-art
./rpie-art.sh
```

After launching `rpie-art.sh` you just have to follow the instructions in the dialog boxes.


## How to install manually

Each overlay folder contains specific instruction; generally setup OVERLAY in this way:

The `.cfg` files assume retroarch overlay folder is: `/opt/retropie/emulators/retroarch/overlays/arcade-bezels/`

If using a different folder, edit `.cfg` files accordingly.

If folder does not exist on your RetroPie, create `arcade-bezels` folder with the mentioned path.

Summarizing the steps:
- ssh or ftp into Pi
- copy romname.zip.cfg into your `mame-libretro` (lr-mame2003) ROMS folder
- copy png file and `romname.cfg` into overlay folder

## Launching Images
Game specific launching images are named `RomName-lanching.png` (or `.jpg`).
To install copy the image to the `RetroPie/roms/[SYSTEM]/images/` folder on your RetroPie and, if needed, rename the file to match the exact name of the ROM plus the trailing `-launching.png` (or `.jpg`).

Have fun !

**NOT FOR COMMERCIAL USE**
