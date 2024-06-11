
{ config, pkgs, ... }:
{
# Home Manager can also manage your environment variables through
# 'home.sessionVariables'. If you don't want to manage your shell through Home
# Manager then you have to manually source 'hm-session-vars.sh' located at
# either
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/nazarov/etc/profile.d/hm-session-vars.sh
#
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = "nvim";
      BROWSER= "brave";
      NIXPKGS_ALLOW_UNFREE="1";
    };

}
