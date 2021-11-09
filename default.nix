let
    ihp = builtins.fetchGit {
        url = "https://github.com/digitallyinduced/ihp.git";
        rev = "8bfd4208ac3714d74d184de41f9f0843826f0014";
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
