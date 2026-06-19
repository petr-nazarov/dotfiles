#!/bin/zsh
echo "Cloning base devcontainer.json into project specific devcontainer.json"

cp -p .devcontainer/base/devcontainer.json ./.devcontainer/devcontainer.json

echo "Making shure devcontainer is part of the project"
if [ -f mise.toml ]; then
  mise use devcontainer-cli
else
  npm i -g @devcontainers/cli
fi

