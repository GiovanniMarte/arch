#!/bin/bash
clear

# Format partitions
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3

# Mount partitions
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi
swapon /dev/sda2
mount /dev/sda3 /mnt

# Base linux setup and generate fstab
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Get base install script
cd /mnt
curl -O https://raw.githubusercontent.com/GiovanniMarte/arch/main/arch-base.sh
chmod +x arch-base.sh

echo "Para comenzar la instalación ejecuta ./arch-base.sh"

arch-chroot /mnt
