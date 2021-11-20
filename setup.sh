#!/bin/bash
clear
loadkeys es

# Setup
read -p "Introduce el tamaño de la partición EFI: " EFI
read -p "Introduce el tamaño de la partición SWAP: " SWAP
clear

# Create partitions
echo -e "g\nn\n\n\n$EFI\nt\n1\n1\nnn\n\n\n$SWAP\nt\n1\n1\nw\n" | fdisk /dev/sda
clear

# Base linux setup and chroot
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# Get base install script
curl -O https://raw.githubusercontent.com/GiovanniMarte/arch/main/arch-base.sh
chmod +x arch-base.sh
