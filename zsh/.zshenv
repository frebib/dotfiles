# Assume environment is already loaded if ZDOTDIR is set.
# This speeds up starting zsh if it's not required. Attempt
# to load the environment if it's absent, though, in case
# ZDOTDIR is overriden and .zshrc is not in ~
if [ -z "$ZDOTDIR" ]; then
    set -o allexport
    . ~/.config/environment.d/*.conf
    set +o allexport
fi

# vim: ft=sh
