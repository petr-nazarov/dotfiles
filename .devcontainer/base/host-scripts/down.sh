#!/bin/zsh
docker ps | fzf | awk '{print $1}' | xargs docker rm -f
