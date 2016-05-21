if [[ $EUID -eq 0 ]]; then
    echo "You cannot run makepkg as root."
    echo "Please run this script again as a non-elevated user"
    exit 1
fi

# Install dependencies
sudo pacman -S --asdeps git curl yajl gnupg

mkdir cower && cd cower

# Get PGP keys so it builds
gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53

# Fetch, build and install cower
curl https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower > PKGBUILD 
makepkg -sri

# Fetch, build and install pacaur
cd .. && mkdir pacaur && cd pacaur
curl https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur > PKGBUILD 
makepkg -sri

cd ..
rm -rf cower pacaur
