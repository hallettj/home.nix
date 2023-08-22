{
  nix = {
    settings = {
      substituters = [
        "https://hasura-mongo-agent.cachix.org"
      ];
      trusted-public-keys = [
        "hasura-mongo-agent.cachix.org-1:9IICKkCff/lzNPpgl9YEha/EANFSIMMqYQ8hos1uSi0="
      ];
    };
  };
}
