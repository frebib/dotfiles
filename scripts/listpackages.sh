#!/bin/bash

set -e

ALL=$(pacman --query --quiet --explicit)
BASE=$(pacman --query --quiet --groups  base)
BASE_DEVEL=$(pacman --query --quiet --groups base-devel)

echo "$ALL
$BASE
$BASE
$BASE_DEVEL
$BASE_DEVEL" | sort | uniq -u