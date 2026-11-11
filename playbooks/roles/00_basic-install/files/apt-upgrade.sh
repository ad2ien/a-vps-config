#!/bin/sh
set -eu
export DEBIAN_FRONTEND=noninteractive

log=/var/log/apt-upgrade.log
: >"$log"

apt-get update -qq >>"$log" 2>&1 || true

rc=0
apt-get -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" \
  dist-upgrade >>"$log" 2>&1 || rc=$?

upgraded=$(grep -c '^Setting up ' "$log" || true)
[ -z "$upgraded" ] && upgraded=0

if [ "$rc" -eq 0 ] && [ "$upgraded" -eq 0 ]; then
  exit 0
fi

reboot=no
if [ -f /var/run/reboot-required ]; then
  reboot=yes
fi

if [ "$rc" -ne 0 ]; then
  echo "apt-upgrade: status=failed upgraded=${upgraded} rc=${rc}" >>"$log"
else
  echo "apt-upgrade: status=ok upgraded=${upgraded} reboot=${reboot}" >>"$log"
fi
