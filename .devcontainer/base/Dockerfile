FROM mcr.microsoft.com/devcontainers/base:ubuntu
# Copy the mise binary from the jdxcode/mise image to the devcontainer image
COPY --from=jdxcode/mise /usr/local/bin/mise /usr/local/bin/

RUN apt-get update && apt-get install -y --no-install-recommends \
  stow \
  neovim \
  jq \
  rclone \
  fzf \
  btop \
  tmuxinator \

