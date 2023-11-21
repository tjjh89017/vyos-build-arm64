#!/bin/bash

# should be in vyos-build-arm64/
CWD=$(pwd)

echo "$VYOS_BUILD"
cd "$VYOS_BUILD"/packages/frr/

rm -rf *.deb
rm -rf frr*

git clone https://github.com/FRRouting/frr.git -b 'stable/9.0'
sudo mk-build-deps --install --tool "apt-get --yes --no-install-recommends"
./build-frr.sh

# remove dbg
rm -rf *dbg*.deb
rm -rf ../*dbg*.deb

cp *.deb ../
