#!/bin/bash

set -e

if [ "$(dirname "$(realpath "$0")")" != "$(realpath "$PWD")" ]; then
  echo "Please run from the folder uninstall.sh is in."
  exit 1
fi

if [[ $(pidof fm_rpc) ]]; then
  echo "Waiting for fm.rpc to finish running"
  tail --pid="$PID" -f /dev/null
fi

if [[ $* == *--all-users* ]]; then
	PREFIX=/usr/local
else
  PREFIX=~/.local
fi

rm -rf "$PREFIX"/share/fm_rpc
rm -f "$PREFIX"/bin/fm_rpc
rm -f "$PREFIX"/share/applications/fm_rpc.desktop
rm -f "$PREFIX"/share/icons/hicolor/scalable/apps/fm_rpc.svg

echo "Uninstall complete."
