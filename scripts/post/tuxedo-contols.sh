#!/bin/bash

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

git clone https://github.com/tuxedocomputers/tuxedo-keyboard.git

cd tuxedo-keyboard

git checkout release

sed -i 's|MAKE\[0\]="make KDIR=/lib/modules/${kernelver}/build"|MAKE[0]="make KDIR=/lib/modules/${KERNEL}/build"|' dkms.conf
sed -i 's|dkms install -m \$(MODULE_NAME) -v \$(VER)|dkms install -m --kernelsourcedir=/lib/modules/${KERNEL}/source \$(MODULE_NAME) -v \$(VER)|' Makefile

make clean && make

make clean

sudo make dkmsinstall KDIR=/lib/modules/${KERNEL}/build

cd .. rm -rf tuxedo-keyboard
