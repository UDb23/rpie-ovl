#!/usr/bin/env bash
#
# TODO:
# - deal with "options", such as the "Burning Force/Option 1"
# - adapt the script for multiple systems overlays

source /opt/retropie/lib/inifuncs.sh || exit 1

arcade_roms_dir=( $(ls -df1 "/home/$USER/RetroPie/roms"/{mame-libretro,arcade,fba,neogeo}) )

if ! [[ -d "$arcade_roms_dir" ]]; then
    echo "It seems that you put your roms in some unusual directory. Aborting..." >&2
    exit 1
fi


function dialogMsg() {
    dialog --msgbox "$@" 10 60 2>&1 > /dev/tty
}



function show_image() {
    local image="$1"
    local timeout=5

    [[ -f "$image" ]] || return 1

    if [[ -n "$DISPLAY" ]]; then
        feh \
            --cycle-once \
            --hide-pointer \
            --fullscreen \
            --auto-zoom \
            --no-menus \
            --slideshow-delay $timeout \
            --quiet \
            "$image" \
        || return $?
    else
        fbi \
            --once \
            --timeout "$timeout" \
            --noverbose \
            --autozoom \
            "$image" </dev/tty &>/dev/null \
        || return $?
    fi
}



function arcade_dir_menu() {
    local cmd=( dialog --menu "Select the directory where you want to install the overlay(s)." 18 70 60 )
    local options=()
    local opt
    local choice
    local i=1

    for opt in "${arcade_roms_dir[@]}"; do
        options+=( "$i" "$opt" )
        ((i++))
    done

    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty) || return 1
    echo "${options[2*choice-1]}"
}



function games_menu() {
    local cmd=( dialog --ok-label "Continue" --checklist "Check the games you want to install the overlay and then press \"Continue\"." 18 70 60 )
    local options=()
    local choice
    local i=1

    find -maxdepth 1 -type d \
        ! -name . \
        ! -name .git \
        ! -name atari2600 \
        ! -name nes \
        ! -name snes \
        ! -name mastersystem \
        ! -name megadrive \
        ! -name gb \
        ! -name gba \
        ! -name gbc \
    | sed 's|^\./\?||' | sort > "$tmpfile"
    
    while IFS='' read -r game || [[ -n "$game" ]]; do
        options+=( "$i" "$game" off )
        ((i++))
    done < "$tmpfile"
    echo -n > "$tmpfile"

    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty) || return 1
    for i in $choice; do
        echo "${options[3*i-2]}" >> "$tmpfile"
    done
}



function install_overlays() {
    local romdir
    local rom_zip_cfg
    local rom
    local ovl_dir
    local ovl_cfg
    local ovl_img=()
    local choice
    local failed

    iniConfig ' = ' '"'

    while true; do
        romdir=$(arcade_dir_menu) || exit 1
        while true; do
            games_menu || break
            [[ -s "$tmpfile" ]] && break 2
            dialogMsg "You didn't choose any overlay. Please select at least one or cancel."
        done
    done

    while IFS='' read -r game || [[ -n "$game" ]]; do
        dialog --infobox "Installing overlay for \"$game\"..." 4 60

        rom_zip_cfg="$(ls "$game"/*.zip.cfg | head -1)"
        ovl_cfg="${rom_zip_cfg/%zip.cfg/cfg}"
        rom="$(basename "$rom_zip_cfg")"
        rom="${rom%.zip.cfg}"

        if ! [[ -f "$rom_zip_cfg" ]]; then
            failed+="$game\n"
            continue
        fi

        cp "$rom_zip_cfg" "$romdir"

        iniGet input_overlay "$rom_zip_cfg"
        ovl_dir="$(dirname "$ini_value")"
        mkdir -p "$ovl_dir"
        cp "$ovl_cfg" "$ini_value"
        ovl_cfg="$ini_value"
        cp "$game"/*-ovl.png "$ovl_dir"

        ovl_img=( $(ls "$ovl_dir/$rom"*-ovl.png | xargs basename -a ) )

        if [[ ${#ovl_img[@]} -eq 1 ]]; then
            iniSet overlay0_overlay "$ovl_img" "$ovl_cfg"
            continue
        fi

        while true; do
            choice=$(dialog --no-items --menu "You have more than one overlay option for \"$game\".\n\nChoose a file to preview and then you'll have a chance to accept it or not.\n\nIf you Cancel, the overlay won't be installed." 22 76 16 "${ovl_img[@]}" 2>&1 > /dev/tty) \
            || break

            if ! show_image "$ovl_dir/$choice"; then
                dialogMsg "Unable to show the image.\n(Note: there's no way to show image when using SSH.)"
            fi

            dialog --yesno "Do you accept the file \"$choice\" as the overlay for \"$game\"?" 7 60 2>&1 > /dev/tty \
            || continue

            iniSet overlay0_overlay "$choice" "$ovl_cfg"
            break
        done
    done < "$tmpfile"

    [[ -n "$failed" ]] && failed="\nFailed to install overlay for these games:\n$failed"
    dialogMsg "Overlay installation finished!\n$failed"
}



readonly tmpfile=$(mktemp)

install_overlays

rm -f "$tmpfile"
