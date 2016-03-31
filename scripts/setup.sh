./install-pacaur.sh

pacaur -S ../packages

systemctl enable lightdm.service
systemctl enable bluetooth.service --now
systemctl enable NetworkManager.service --now
