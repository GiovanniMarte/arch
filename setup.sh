#!/bin/bash
clear

echo -e "\e[1;32m----- Bienvenido al script de instalación de Arch Linux! -----\033[0m"

while true; do
    read -p "Deseas comenzar el proceso de configuración? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Por favor introduce sí (y) o no (n)";;
    esac
done

# Format partitions
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 -F 32 /dev/sda3

# Mount partitions
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi
swapon /mnt/sda2
mount /dev/sda3 /mnt

# Base linux setup and chroot
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# Get base install script
curl -O https://raw.githubusercontent.com/GiovanniMarte/arch/main/arch-base.sh
chmod +x arch-base.sh
