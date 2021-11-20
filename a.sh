#!/bin/bash
clear

# Setup
read -p "Introduce el tamaño de la partición EFI: " EFI
read -p "Introduce el tamaño de la partición SWAP: " SWAP
clear

# Create partitions
echo -e "g\nn\n\n\n$EFI\nt\n1\n1\nn\n\n\n$SWAP\nt\n1\n19\nn\n\n\n\nw\n" | fdisk /dev/sda
