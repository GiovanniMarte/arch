#!/bin/bash

clear

echo -e "\e[1;32m----- Bienvenido al script de automatización de instalación de Arch Linux! -----\033[0m"

while true; do
    read -p "Deseas comenzar el proceso de instalación? (y/n) " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Por favor introduce sí (y) o no (n)";;
    esac
done

clear

# Basic configuration
ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc
sed -i "s/#es_ES.UTF-8/es_ES.UTF-8/" /etc/locale.gen
locale-gen
echo "LANG=es_ES.UTF-8" > /etc/locale.conf
echo "KEYMAP=es" > /etc/vconsole.conf
echo "arch" > /etc/hostname
echo "127.0.0.1	localhost" >>  /etc/hosts
echo "::1	localhost" >>  /etc/hosts
echo "127.0.1.1	arch.localdomain	arch" >>  /etc/hosts

clear

# Set root password
printf "Introduce la contraseña de administrador: "
read -s ROOTPASS
echo "root:$ROOTPASS" | chpasswd

clear

# Create new user
read -p "Introduce tu nombre de usuario: " NAME
printf "Introduce tu contraseña: "
read -s PASS
useradd -m "$NAME"
echo "$NAME:$PASS" | chpasswd
echo "$NAME ALL=(ALL) ALL" > /etc/sudoers.d/"$NAME"

clear

# Basic packages installation
pacman -S base-devel nano grub efibootmgr networkmanager xorg i3 lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings lxappearance dmenu alacritty firefox picom nitrogen thunar wget neofetch htop unzip alsa-utils noto-fonts-emoji

# Grub installation
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Enable services
systemctl enable NetworkManager
systemctl enable lightdm

clear

echo -e "\e[1;32mTerminado! Escribe exit, umount -R /mnt y reboot\033[0m"
