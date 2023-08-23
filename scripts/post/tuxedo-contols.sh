#!/bin/bash

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

git clone https://github.com/tuxedocomputers/tuxedo-keyboard.git

cd tuxedo-keyboard

git checkout release

sed -i "s/\$(shell uname -r)/${KERNEL}/g" Makefile
sed -i "s/\${kernelver}/${KERNEL}/g" dkms.conf
#sed -i "s/dkms install -m \$(MODULE_NAME) -v \$(VER)/& --kernelsourcedir=\/usr\/src\/kernels\/${KERNEL}/" Makefile
sed -i "s/dkms install -m \$(MODULE_NAME) -v \$(VER)/& -k ${KERNEL}/" Makefile


make clean && make

make clean

sudo make dkmsinstall KDIR=/lib/modules/${KERNEL}/build

cd ..
rm -rf tuxedo-keyboard

mkdir -p /lib/modules/${KERNEL}/extra/tuxedo_keyboard

mv /lib/modules/${KERNEL}/extra/uniwill_wmi.ko.xz /lib/modules/${KERNEL}/extra/tuxedo_keyboard
mv /lib/modules/${KERNEL}/extra/clevo_acpi.ko.xz /lib/modules/${KERNEL}/extra/tuxedo_keyboard
mv /lib/modules/${KERNEL}/extra/tuxedo_io.ko.xz /lib/modules/${KERNEL}/extra/tuxedo_keyboard
mv /lib/modules/${KERNEL}/extra/clevo_wmi.ko.xz /lib/modules/${KERNEL}/extra/tuxedo_keyboard
mv /lib/modules/${KERNEL}/extra/tuxedo_keyboard.ko.xz /lib/modules/${KERNEL}/extra/tuxedo_keyboard
