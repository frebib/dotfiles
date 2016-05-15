These are the configs I use on my Arch Linux installation at home. They can be use and changed as much or as little as you please

## Usage
To quickly get started, clone this repo and run the setup scripts.

    git clone https://github.com/frebib/dotfiles.git ~/.config/dotfiles --recursive
    cd ~/.config/dotfiles

You can put the `dotfiles` directory anywhere, just be sure to update the `$DOTFILES` envvar in `.profile`

To link all the configuration files, run the init-dotfiles script:

**Be warned that this will destroy your current configs without warning**

    scripts/init-dotfiles.sh

To install all of my packages & programs, check out my other repo <https://github.com/frebib/arch-install/> and the [`userinstall`](https://github.com/frebib/arch-install/blob/master/userinstall) script
