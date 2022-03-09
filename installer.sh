fdisk /dev/sda << FDISK_CMDS
g
n
1

+512MiB
n
2


t
1
83
t
2
83
w
FDISK_CMDS
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
sed -i '/ParallelDownloads = 5/s/^#//g' /etc/pacman.conf
basestrap /mnt base base-devel openrc elogind-openrc
basestrap /mnt linux linux-firmware
fstabgen -U /mnt >> /mnt/etc/fstab
artix-chroot /mnt
# in new system
sed -i '/ParallelDownloads = 5/s/^#//g' /etc/pacman.conf
ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc
sed -i '/en_US/s/^#//g' /etc/locale.gen
locale-gen
pacman -S grub os-prober efibootmgr dhclient
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg
echo "kz-vm" > /etc/hostname
echo "127.0.0.1        localhost" > /etc/hosts
echo "::1              localhost" >> /etc/hosts
echo "127.0.1.1        kz-vm.localdomain kz-vm" >> /etc/hosts
useradd -m kz -G sudo
cat >> /etc/pacman.conf << EOF
[universe]
Server = https://universe.artixlinux.org/$arch
Server = https://mirror1.artixlinux.org/universe/$arch
Server = https://mirror.pascalpuffke.de/artix-universe/$arch
Server = https://artixlinux.qontinuum.space:4443/artixlinux/universe/os/$arch
Server = https://mirror1.cl.netactuate.com/artix/universe/$arch
EOF

exit 
umount -R /mnt
reboot
