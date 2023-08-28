#!/bin/bash

# Récupération des variables cibles
ARCH=$(rpm -E '%_arch')
KERNEL=$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')
RELEASE=$(rpm -E '%fedora')

# Décompressez le fichier acpi_call-master.zip
wget https://github.com/nix-community/acpi_call/archive/refs/heads/master.zip

unzip acpi_call-master.zip -d /tmp

# Aller dans le répertoire décompressé
cd acpi_call-master

# Compiler le module pour le noyau cible
make -C /usr/src/kernels/${KERNEL} M=$(pwd) modules

# Vérifier si la compilation a réussi
if [ $? -ne 0 ]; then
    echo "Erreur lors de la compilation du module acpi_call."
    exit 1
fi

# Déplacer le module au bon emplacement
mkdir -p /usr/lib/modules/${KERNEL}/extra/acpi_call/
mv acpi_call.ko /usr/lib/modules/${KERNEL}/extra/acpi_call/

# Afficher un message de confirmation
echo "Le module acpi_call a été compilé et déplacé avec succès pour le noyau ${KERNEL}."

