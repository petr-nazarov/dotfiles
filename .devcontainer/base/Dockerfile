FROM mcr.microsoft.com/devcontainers/base:ubuntu
# Copy the mise binary from the jdxcode/mise image to the devcontainer image
COPY --from=jdxcode/mise /usr/local/bin/mise /usr/local/bin/

# The package list is shared with scripts/refresh.sh, which installs anything
# added here later into already-running containers.
COPY .devcontainer/base/packages.txt /tmp/packages.txt
RUN apt-get update && xargs -a /tmp/packages.txt apt-get install -y --no-install-recommends
