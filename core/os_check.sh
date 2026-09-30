#!/bin/bash
if [ -f /etc/os-release ]; then
 . /etc/os-release
else
 echo "Unsupported OS"; exit 1
fi
case "$ID" in
 debian|ubuntu) ;;
 *) echo "Only Debian/Ubuntu supported"; exit 1;;
esac
if command -v apt-get >/dev/null; then
 apt-get update -y
fi
