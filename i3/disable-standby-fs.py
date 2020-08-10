#!/usr/bin/env python3

from argparse import ArgumentParser
from subprocess import call
import i3ipc

i3 = i3ipc.Connection()

parser = ArgumentParser(prog='disable-standby-fs',
        description='''
        Disable standby (dpms) and screensaver when a window becomes fullscreen
        or exits fullscreen-mode. Requires `xorg-xset`.
        ''')

args = parser.parse_args()

def on_fullscreen_mode(i3, e):
    if e.container.props.fullscreen_mode:
        call(['xautolock', '-disable'])
        print("disabling autolock")
    else:
        call(['xautolock', '-enable'])
        print("enabling autolock")

def on_window_close(i3, e):
    if e.container.props.fullscreen_mode:
        call(['xautolock', '-enable'])
        print("enabling autolock")

i3.on('window::fullscreen_mode', on_fullscreen_mode)
i3.on('window::close', on_window_close)

i3.main()
