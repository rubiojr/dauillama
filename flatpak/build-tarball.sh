#!/bin/sh
#
# Use Ubuntu 22.04 as a build host
#
# toolbox create --distro ubuntu --release 22.04
# toolbox enter ubuntu-toolbox-22.04
#
# Then install build deps:
#
# sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa build-essential cmake clang ninja-build pkg-config libgtk-3-dev vim
#
# Install the Flutter SDK:
#
# curl -s https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.1-stable.tar.xz | tar -C ~/ -xJf -
#
set -e

BUNDLE=build/linux/x64/release/bundle
TARBALL=dauillama-linux-x64.tgz
export PATH="$HOME/flutter/bin:$PATH"

OLLAMA_BASE_URL=${OLLAMA_BASE_URL:-http://127.0.0.1:11434/api}
echo "OLLAMA_BASE_URL=$OLLAMA_BASE_URL"
flutter build linux --dart-define="OLLAMA_BASE_URL=$OLLAMA_BASE_URL" --release
cp flatpak/bz.rxla.dauillama.desktop "$BUNDLE"
cp flatpak/bz.rxla.dauillama.png "$BUNDLE/icon.png"
tar -C "$BUNDLE" --transform 's,^,dauillama/,' -czf "$TARBALL" .

sha256sum "$TARBALL"
