./install-pacaur.sh

pacaur -S ../packages

sudo ln -s /usr/bin/vim /usr/bin/vi

systemctl enable lightdm.service
systemctl enable bluetooth.service --now
systemctl enable NetworkManager.service --now
