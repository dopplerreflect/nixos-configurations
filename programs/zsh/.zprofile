#!/usr/bin/env sh
if [[ $(tty) =~ ^\/dev\/tty ]]; then
  source /etc/vconsole.conf
  echo Setting font to $FONT
  setfont $FONT
fi
