
{ config, pkgs, ... }:
{
  programs.chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "mclkkofklkfljcocdinagocijmpgbhab"; } # Google input tools 
        { id = "edibdbjcniadpccecjdfdjjppcpchdlm"; } # I dont care about cookies
        { id = "oldceeleldhonbafppcapldpdifcinji"; } # Grammar
        { id = "aapbdbdomjkkjkaonfhkkikfgjllcleb"; } # Google translate
        { id = "gebbhagfogifgggkldgodflihgfeippi"; } # Youtube return dislikes
      ];
    };
}
