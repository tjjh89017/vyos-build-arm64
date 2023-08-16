#!/bin/bash

# should be in vyos-build-arm64/
CWD=$(pwd)

echo "$VYOS_BUILD"
cd "$VYOS_BUILD"

sudo ./build-vyos-image --debian-mirror http://deb.debian.org/debian/ --build-type release --architecture arm64 --version "$VYOS_ISO_VERSION" iso
