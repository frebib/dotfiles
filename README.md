# frebib/dotfiles

## Usage
To get started, clone this repo and link the relevant files/directories

```shell
git clone https://github.com/frebib/dotfiles.git ~/.config
ln -sfv .config/zsh/.zshenv ~
# if it is not already "enabled", make sure the systemd-environment.d generator is active
sudo ln -sfv /lib/systemd/user-environment-generators/30-systemd-environment-d-generator /lib/systemd/user-generators/
```
