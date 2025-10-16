{ config, lib, specialArgs, ... }: let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkOptionDefault;
  inherit (lib.trivial) isFunction;
  inherit (lib.lists) toList optionals;
  inherit (lib) types;
  cfg = config.special;
  submoduleType = args: let
    shorthand = (! builtins.isAttrs args) || isFunction args;
    modules' = if shorthand
      then toList args
      else toList args.modules or [];
    modules = modules' ++ optionals cfg."inherit".enable cfg."inherit".include;
    specialArgs' = config.special.specialArgs // optionalAttrs (!shorthand) args.specialArgs or {};
    args' = optionalAttrs (!shorthand) args // {
      inherit modules;
      specialArgs = specialArgs';
      shorthandOnlyDefinesConfig = shorthand || args.shorthandOnlyDefinesConfig or true;
    };
  in types.submoduleWith args';
in {
  options = {
    special = {
      "inherit" = {
        enable = mkEnableOption "inherit specialArgs" // {
          default = true;
        };
        includeArgs = mkOption {
          type = types.deferredModule;
          default = { ... }: {
            #config.__module.args.specialArgs = cfg.specialArgs;
            #config.special.args = mapAttrs (_: mkOptionDefault cfg.specialArgs)
          };
        };
        include = mkOption {
          type = types.listOf types.deferredModule;
          default = [ ./specialargs.nix cfg."inherit".includeArgs ];
        };
      };
      args = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        default = {};
      };
      specialArgs = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        readOnly = true;
      };
      submoduleType = mkOption {
        type = types.unspecified;
        default = submoduleType;
      };
    };
  };
  config = {
    special = {
      specialArgs = mkOptionDefault (specialArgs // cfg.args);
    };
  };
}
