#!/bin/bash
clear

# Calculate swap size
SWAP=$(grep MemTotal /proc/meminfo | awk '{print $2}')
SWAP=$((${SWAP}/2000))"M"

# Create partitions
echo -e "g\nn\n\n\n+512M\nn\n\n\n+${SWAP}\nn\n\n\n\nw\n" | fdisk /dev/sda

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

# Change root and run base script
arch-chroot /mnt <<- EOF
  # Basic configuration
  ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
  hwclock --systohc
  sed -i "s/#es_ES.UTF-8/es_ES.UTF-8/" /etc/locale.gen
  locale-gen
  echo "LANG=es_ES.UTF-8" > /etc/locale.conf
  echo "KEYMAP=es" > /etc/vconsole.conf
  echo "arch" > /etc/hostname
  echo "127.0.0.1 localhost" >>  /etc/hosts
  echo "::1       localhost" >>  /etc/hosts
  echo "127.0.1.1 arch.localdomain    arch" >>  /etc/hosts
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
EOF

umount -R /mnt

echo "Terminado! Escribe 'reboot' para terminar."
