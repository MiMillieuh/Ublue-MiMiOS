#!/bin/bash

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

mkdir -p /usr/lib/modules/${KERNEL}/extra/acpi_call/

wget https://github.com/MiMillieuh/Ublue-MiMiOS/raw/live/modules/acpi_call.ko

mv acpi_call.ko /usr/lib/modules/${KERNEL}/extra/acpi_call/

depmod ${KERNEL}
