#!/bin/bash

# Globals
TERM_EMULATOR=$(command -v terminator || command -v kitty || command -v alacritty)

# Verify terminal emulator
if [ -z "$TERM_EMULATOR" ]; then
    echo "[-] No supported terminal emulator found (terminator, kitty, alacritty). Please install one."
    exit 1
fi

install_nano() {
    sudo apt-get update
    sudo apt-get install -y nano
}

remove_old_desktop_entry() {
    sudo rm -f /usr/share/applications/nano.desktop
}

create_desktop_entry() {
    echo "🔧 Creating desktop launcher for Nano..."
    sudo tee /usr/share/applications/nano.desktop > /dev/null <<EOF
[Desktop Entry]
Encoding=UTF-8
Type=Application
NoDisplay=false
Exec=$TERM_EMULATOR -T 'Nano' -e nano %f
Name=Nano
Comment=Nano terminal text editor
Icon=utilities-terminal
Categories=Utility;TextEditor;Development;
Keywords=editor;texteditor;text;terminal;
MimeType=text/plain;
EOF

    # Ensure desktop database is updated
    if command -v update-desktop-database > /dev/null; then
        sudo update-desktop-database
    fi
}

configure_nanorc() {
    mkdir -p "$HOME/.config/nano"

    if [ -f "/usr/share/doc/nano/examples/sample.nanorc" ]; then
        cp "/usr/share/doc/nano/examples/sample.nanorc" "$HOME/.config/nano/"
    fi

    local rc="$HOME/.config/nano/nanorc"
    if [ ! -f "$rc" ] || ! grep -q "## Custom nano configuration" "$rc"; then
        cat <<EOF >> "$rc"

## Custom nano configuration

set emptyline
set indicator
set linenumbers
set mouse

set titlecolor bold,lightgreen,black
set promptcolor bold,green,black
set statuscolor bold,green,black
set selectedcolor lightyellow,magenta
set stripecolor yellow
set scrollercolor cyan
set numbercolor bold,green
set keycolor lightgreen
set functioncolor lightcyan

include "/usr/share/nano/*.nanorc"
EOF
    fi
}

setup_sxhkd_binding() {
    local sxhkdrc="$HOME/.config/sxhkd/sxhkdrc"
    local bind='super + n'
    local fallback='shift + super + n'
    local cmd="$TERM_EMULATOR -T 'Nano' -e nano"

    if [ -f "$sxhkdrc" ]; then
        if ! grep -q "# nano editor." "$sxhkdrc"; then
            if ! grep -q "$bind" "$sxhkdrc"; then
                echo -e "\n# nano editor.\n$bind\n$cmd" >> "$sxhkdrc"
                notify-send -t 8000 --urgency=low "Use '$bind' to start nano"
            elif ! grep -q "$fallback" "$sxhkdrc"; then
                echo -e "\n# nano editor.\n$fallback\n$cmd" >> "$sxhkdrc"
                notify-send -t 8000 --urgency=low "Use '$fallback' to start nano"
            else
                notify-send -t 8000 --urgency=low "Nano keybinds already used. Add manually if needed."
            fi
            # Send USR1 signal only if sxhkd is running
            pgrep -x sxhkd > /dev/null && pkill -USR1 -x sxhkd
        fi
    else
        echo "sxhkdrc not found at $sxhkdrc. Skipping keybinding setup."
    fi
}

main() {
    check_internet
    remove_old_desktop_entry
    install_nano
    create_desktop_entry
    configure_nanorc
    setup_sxhkd_binding
    echo "✅ Nano installation and configuration complete."
}

main
