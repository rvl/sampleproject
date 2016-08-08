# put this default.nix into a clone of https://github.com/pypa/sampleproject
{ sampleproject ? { outPath = ./.; name = "sampleproject"; }
, pkgs ? import <nixpkgs> {}
, pythonPackages ? null
}:

let
  packages = if pythonPackages == null
    then pkgs.python35Packages
    else pythonPackages;
  pkg = with packages;
    buildPythonPackage rec {
      name = "sampleproject-${version}";
      version = "1.2.0";
      src = [ sampleproject ];
      propagatedBuildInputs = [ peppercorn ];
    };

in
  pkg
