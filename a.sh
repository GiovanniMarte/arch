#!/bin/bash
clear

# Calculate swap size
SWAP=$(grep MemTotal /proc/meminfo | awk '{print $2}')
SWAP=$((${SWAP}/2000))"M"

# Create partitions
echo -e "g\nn\n\n\n+512M\nn\n\n\n+${SWAP}\nn\n\n\n\nw\n" | fdisk /dev/sda

# Format partitions
printf "Formatting partitions..."
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3

# Mount partitions
printf "Mounting partitions..."
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi
swapon /dev/sda2
mount /dev/sda3 /mnt
