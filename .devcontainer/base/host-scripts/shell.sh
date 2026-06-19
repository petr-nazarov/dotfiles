#!/bin/zsh
set -e
./.devcontainer/base/host-scripts/base.sh

devcontainer exec --workspace-folder . zsh


