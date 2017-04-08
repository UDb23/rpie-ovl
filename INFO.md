# `info.txt` file specification

In order to let the `rpie-ovl.sh` script work fine, every overlay directory **must** have a file named `info.txt`, from where the script gets all the information it needs to automate the art installation.

The `info.txt` format is:

```
# comments
key = "value"
```

Here is a hypothetical example with the rules described on the comments:

```
# game_name: REQUIRED
# The script ignores the file if it doesn't have this entry if it's a system
# generic overlay, game_name MUST be "_generic"
game_name = "Game Name"

# system: REQUIRED
# The system that runs the game (e.g.: nes, megadrive, neogeo, fba, etc.).
# Use the same name as the RetroPie uses (those directories at `RetroPie/roms/` and
# `/opt/retropie/configs/` are good examples).
system = "system"

# rom_config: OPTIONAL (REQUIRED for overlays)
# This is the file that stays in the same directory as the ROM.
# If it's an arcade game overlay, it's pretty simple: ROM.zip.cfg
# If it's a system generic overlay use system.cfg. Examples: nes.cfg, gba.cfg, neogeo.cfg.
# If it's a console game overlay, use "GameName.cfg" as a guideline. But since
# there's no rule for console ROM file names, the script will try to find
# the exact ROM name based on the game_name entry and show the options to let
# the user choose.
rom_config = "RomFileName.cfg"

# overlay_config: OPTIONAL (REQUIRED for overlays)
# This is the file that has the overlay configuration.
overlay_config = "RomName.cfg"

# overlay_image: OPTIONAL (REQUIRED for overlays)
# The overlay image itself. If there are more than one image option, separate
# them with semicolon.
overlay_image = "RomName_artist_1-ovl.cfg; RomName_artist_2-ovl.cfg"

# rom_clones: OPTIONAL (used for arcade game overlays only)
# List of clones that can use the same overlay as the parent separeted with a
# semicolon.
rom_clones = "romA; romB; romC"

# rom_config_N: OPTIONAL
# If there's an optional configuration (e.g.: enabling `video_scale_integer`),
# it needs an extra cfg file. You can use the rom_config_N, where N is a number.
rom_config_1 = "RomFileName_opt1.cfg"

# overlay_config_N: OPTIONAL
# Same situation as rom_config_N.
overlay_config_1 = "RomName_opt1.cfg"

# overlay_image_N: OPTIONAL
# Same situation as rom_config_N.
overlay_image_1 = "RomName_artist_opt1-ovl.cfg"

# launching_image: OPTIONAL
# Runcommand launching image. If there are more than one image option, separate
# them with semicolon.
launching_image = "RomName_1-launching.png; RomName_2-launching.png"

# scrape_image: OPTIONAL
# Image to use as emulationstation art. If there are more than one option,
# separate them with semicolon.
scrape_image = "RomName_1-image.png; RomName_2-image.png"
```
