sudo nixos-rebuild switch --flake .#$HOSTNAME
home-manager switch --flake .#nazarov-$HOSTNAME --impure
