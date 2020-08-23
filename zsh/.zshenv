# Assume environment is already loaded if ZDOTDIR is set.
# This speeds up starting zsh if it's not required. Attempt
# to load the environment if it's absent, though, in case
# ZDOTDIR is overriden and .zshrc is not in ~
if [ -z "$ZDOTDIR" ]; then
    set -o allexport
    for f in "$HOME"/.config/environment.d/*.conf; do . "$f"; done
    set +o allexport
fi

# vim: ft=sh
