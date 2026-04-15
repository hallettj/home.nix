# Write Nushell modules with build-time checking. Returns **path** to module
# file.
{ lib
, nushell
, writeTextFile
}:

# Takes source, a .nu file containing a Nushell module
source:
let
  baseName = builtins.baseNameOf source;
  derivation =
    writeTextFile {
      name = baseName;

      # Create a directory with a .nu file in it instead of a file-as-store-path
      # because Nushell uses the filename as the module name.
      destination = "/${baseName}";

      text = builtins.readFile source;
      checkPhase = ''
        runHook preCheck
        ${lib.getExe nushell} --commands "nu-check --as-module --debug '$target'"
        runHook postCheck
      '';
    };
in
"${derivation}/${baseName}"
