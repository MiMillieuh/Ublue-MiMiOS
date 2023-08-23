#!/bin/bash

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

git clone https://github.com/tuxedocomputers/tuxedo-keyboard.git

cd tuxedo-keyboard

git checkout release

sed -i 's/\$(shell uname -r)/${KERNEL}/g' path_to_Makefile
sed -i 's/\${kernelver}/${KERNEL}/g' path_to_dkms.conf

make clean && make

make clean

sudo make dkmsinstall KDIR=/lib/modules/${KERNEL}/build

cd .. rm -rf tuxedo-keyboard
