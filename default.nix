let
    ihp = builtins.fetchGit {
        url = "https://github.com/digitallyinduced/ihp.git";
        rev = "e0d9c66e0b5d13a156965014d542e62004d7580d";
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
