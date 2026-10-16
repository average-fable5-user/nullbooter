#!/usr/bin/env sh
# NULL installer
#
#   curl -fsSL https://raw.githubusercontent.com/average-fable5-user/nullbooter/main/install.sh | sh
#
# installs NULL into ~/.local/bin by default. override with INSTALL_DIR=/usr/local/bin.

set -eu

URL="https://github.com/average-fable5-user/nullbooter/raw/refs/heads/main/NULL"
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
BIN="$INSTALL_DIR/NULL"

echo "NULL installer"
echo "  src:  $URL"
echo "  dest: $BIN"
echo

mkdir -p "$INSTALL_DIR"
tmp=$(mktemp 2>/dev/null || echo "/tmp/null.$$")
trap 'rm -f "$tmp"' EXIT

if command -v curl >/dev/null 2>&1; then
    curl -fL --progress-bar -o "$tmp" "$URL"
elif command -v wget >/dev/null 2>&1; then
    wget -q --show-progress -O "$tmp" "$URL"
else
    echo "need curl or wget" >&2
    exit 1
fi

chmod +x "$tmp"
mv "$tmp" "$BIN"

echo
echo "installed: $BIN"
case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *)
        echo
        echo "note: $INSTALL_DIR not on PATH. add to your shell rc:"
        echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
        ;;
esac
echo "run: NULL --help"
