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
