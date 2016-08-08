{ nixpkgsSrc ? <nixpkgs>
, supportedSystems ? [ "x86_64-linux" "i686-linux" "x86_64-darwin" ]
}:

let

  # import current system nixpkgs's
  pkgs' = import nixpkgsSrc {};

  # Make an attribute set for each compiler, the builder is then be specialized
  # to use the selected compiler.
  forEachInterpreter = interpreters: builder:
    pkgs'.lib.genAttrs interpreters (interpreter:
      builder {
        pkgs = pkgs';
        pythonPackages = builtins.getAttr (interpreter + "Packages") pkgs';
      });

  build = name: { systems ? supportedSystems, interpreters ? pythonInterpreters }:
    forEachInterpreter interpreters (import ./default.nix);

  pythonInterpreters = [
    "python26"
    "python27"
    "python33"
    "python34"
    "python35"
    "python36"
    "pypy"
  ];

  jobs = {

    # For each interpreter, build the project:
    #
    #   $ nix-build release.nix -A sampleproject.python27 -o sampleproject-py27
    #   $ nix-build release.nix -A sampleproject.python35 -o sampleproject-py35
    #
    sampleproject = build "sampleproject" { interpreters = pythonInterpreters; };
  };

in jobs
