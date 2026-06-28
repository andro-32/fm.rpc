#!/bin/bash

set -e

if [ "$(dirname "$(realpath "$0")")" != "$(realpath "$PWD")" ]; then
  echo "Please run from the folder install.sh is in."
  exit 1
fi

if [[ $(pidof fm_rpc) ]]; then
  echo "Waiting for fm.rpc to finish running"
  tail --pid="$(pidof fm_rpc)" -f /dev/null
fi

if [[ $* == *--all-users* ]]; then
	PREFIX=/usr/local
else
  PREFIX=~/.local
fi

rm -rf "$PREFIX"/share/fm_rpc "$PREFIX"/bin/fm_rpc
mkdir -p "$PREFIX"/share/fm_rpc
cp -av --no-preserve=owner,context -- * "$PREFIX"/share/fm_rpc/
mkdir -p "$PREFIX"/bin
ln -sf "$PREFIX"/share/fm_rpc/fm_rpc "$PREFIX"/bin/fm_rpc
mkdir -p "$PREFIX"/share/icons/hicolor/scalable/apps
mkdir -p "$PREFIX"/share/applications
cd "$PREFIX"/share/fm_rpc && (\
mv -Z fm_rpc.svg "$PREFIX"/share/icons/hicolor/scalable/apps/;\
mv -Z fm_rpc.desktop "$PREFIX"/share/applications/)

rm install.sh
chmod +x uninstall.sh

if [[ $* == *--self-start* ]]; then
  echo "Install complete. Running fm.rpc"
  "$PREFIX"/bin/fm_rpc &
else
  echo "Install complete. Type 'fm_rpc' to run."
fi
