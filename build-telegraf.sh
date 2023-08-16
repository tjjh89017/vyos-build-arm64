#!/bin/bash

# should be in vyos-build-arm64/
CWD=$(pwd)

echo "$VYOS_BUILD"
cd "$VYOS_BUILD"/packages/telegraf/

rm -rf *.deb
rm -rf telegraf/

git clone https://github.com/influxdata/telegraf.git -b v1.23.1 --depth=1
./build.sh

cp -a telegraf/build/dist/*.deb ../
