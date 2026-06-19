FROM mcr.microsoft.com/devcontainers/base:ubuntu
# Copy the mise binary from the jdxcode/mise image to the devcontainer image
COPY --from=jdxcode/mise /usr/local/bin/mise /usr/local/bin/

RUN apt-get update && apt-get install -y --no-install-recommends \
  stow
# Add mise to path
RUN echo 'eval "$(mise activate bash)"' >> /home/vscode/.bashrc \
 && echo 'eval "$(mise activate zsh)"'  >> /home/vscode/.zshrc
