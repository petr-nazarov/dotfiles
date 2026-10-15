#!/usr/bin/env bash
# apt commands run inside a devcontainer after it was created: hand installs,
# plus refresh.sh installing packages.txt. The image build's own installs are
# older than the container, so they are left out. Both sides are UTC.
# Usage: manual-installs.sh <container>
set -euo pipefail
c=${1:?usage: manual-installs.sh <container>}

created=$(docker inspect "$c" --format '{{.Created}}' | cut -c1-19 | tr T ' ')
docker exec "$c" sh -c 'cat /var/log/apt/history.log 2>/dev/null' |
awk -v since="$created" '
  /^Start-Date:/ { d = $2 " " $3; gsub(/  +/, " ", d) }
  /^Commandline:/ && d >= since { sub(/^Commandline: /, ""); print d "  " $0 }'
