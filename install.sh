# Partition Disk
cfdisk /dev/nvme0n1 # Select Label Type = gpt
# Partition Size = 512M # Type = EFI filesystem
# Partition Size = Rest Of The Avaliable Storage # Type = Linux filesystem

# Format Partitions
mkfs.fat -F32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2

# Mount Partitions
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# Install Base System & Kernel
pacstrap /mnt base base-devel linux-zen linux-firmware linux-zen-headers neovim amd-ucode sudo grub efibootmgr dhcpcd ufw git reflector
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into New System
arch-chroot /mnt

# Timezone & Locale
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
hwclock --systohc
nvim /etc/locale.gen # Uncomment en_US.UTF-8 UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname & Network
echo Arch > /etc/hostname
nvim /etc/hosts
# 127.0.0.1 localhost
# ::1       localhost
# 127.0.1.1 Arch.localdomain Arch

# Root & User Setup
passwd # Example: 321
useradd -m -G wheel -s /bin/bash # Example: x
passwd x # Example: 123
EDITOR=nvim visudo # Uncomment %wheel ALL=(ALL:ALL) ALL

# Bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Exit & Reboot
exit
umount -R /mnt
reboot
