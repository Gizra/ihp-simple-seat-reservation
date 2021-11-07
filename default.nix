let
    ihp = builtins.fetchGit {
        url = "https://github.com/digitallyinduced/ihp.git";
        rev = "7a29415d5df10d1ade43cd73ce9339d361cd60ce";
    };
    haskellEnv = import "${ihp}/NixSupport/default.nix" {
        ihp = ihp;
        haskellDeps = p: with p; [
            cabal-install
            base
            wai
            text
            hlint
            p.ihp
        ];
        otherDeps = p: with p; [
            # Native dependencies, e.g. imagemagick
            nodejs
            # For testing concurrent requests.
            parallel
        ];
        projectPath = ./.;
    };
in
    haskellEnv
