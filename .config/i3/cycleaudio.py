#!/usr/bin/env python3

import subprocess as sp
import re

# This script cycles pulseaudio sinks and changes the defaults.
# Audio playback is also moved to the new default sink. The script
# is intended to bind to some keyboard shortcut to cycle through 
# outputs on the fly. 
#
# Requirements: pacmd, python3

dev_out, _ = sp.Popen('pacmd list-sinks', shell=True, stdout=sp.PIPE).communicate()
inp_out, _ = sp.Popen('pacmd list-sink-inputs', shell=True, stdout=sp.PIPE).communicate()

devices = re.findall(r"(\*?) index: (\d+)", str(dev_out))
inputs  = re.findall(r"index: (\d+)",       str(inp_out))

# find the next default device, i.e., the one after the current default
found = False
next_device = devices[0][1]
for d in devices:
    if found:
        next_device = d[1]
        break
    found = (d[0] == "*")

# set default device and move inputs
sp.call(["pacmd", "set-default-sink", next_device])
for i in inputs:
    sp.call(["pacmd", "move-sink-input", i, next_device])
