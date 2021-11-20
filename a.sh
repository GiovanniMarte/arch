#!/bin/bash
clear

# Format partitions
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3

# Mount partitions
mkdir /mnt/efi
