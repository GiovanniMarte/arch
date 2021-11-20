#!/bin/bash
clear

# Setup
read -p "Introduce el tamaño de la partición EFI: " EFI
read -p "Introduce el tamaño de la partición SWAP: " SWAP
clear

# Create partitions
echo -e "g\nn\n\n\n$EFI\nt\n1\n1\nnn\n\n\n$SWAP\nt\n1\n1\nw\n" | fdisk /dev/sda
