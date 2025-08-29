# Propagates environment variables to make apps that use direct rendering work
# on non-NixOS systems. This is needed by kitty and Neovide
{ pkgs, ... }:
with pkgs; (
  let
    enable32bits = true;
    mesa-drivers = [ mesa ];
    # ++ lib.optional enable32bits pkgsi686Linux.mesa;
    intel-driver = [ intel-media-driver vaapiIntel ];
    # Note: intel-media-driver is disabled for i686 until https://github.com/NixOS/nixpkgs/issues/140471 is fixed
    # ++ lib.optionals enable32bits [ /* pkgsi686Linux.intel-media-driver */ driversi686Linux.vaapiIntel ];
    libvdpau = [ libvdpau-va-gl ];
    # ++ lib.optional enable32bits pkgsi686Linux.libvdpau-va-gl;
    glxindirect = runCommand "mesa_glxindirect" { } ''
      mkdir -p $out/lib
      ln -s ${mesa}/lib/libGLX_mesa.so.0 $out/lib/libGLX_indirect.so.0
    '';
    # generate a file with the listing of all the icd files
    icd = runCommand "mesa_icd" { } (
      # 64 bits icd
      ''
        ls ${mesa}/share/vulkan/icd.d/*.json > f
      ''
      #  32 bits ones
      # + lib.optionalString enable32bits ''
      #   ls ${pkgsi686Linux.mesa}/share/vulkan/icd.d/*.json >> f
      # ''
      # concat everything as a one line string with ":" as seperator
      + ''cat f | xargs | sed "s/ /:/g" > $out''
    );
  in
  {
    home.sessionVariables = with pkgs; {
      LIBGL_DRIVERS_PATH = lib.makeSearchPathOutput "lib" "lib/dri" mesa-drivers;
      /*
        LIBVA_DRIVERS_PATH = lib.makeSearchPathOutput "out" "lib/dri" intel-driver;
      */
      LIBVA_DRIVERS_PATH = lib.makeSearchPathOutput "out" "lib/dri" mesa-drivers;
      LD_LIBRARY_PATH = ''${lib.makeLibraryPath mesa-drivers}:${lib.makeSearchPathOutput "lib"
        "lib/vdpau"
        libvdpau}:${lib.makeLibraryPath [glxindirect libglvnd vulkan-loader xorg.libICE]}'';
      VK_LAYER_PATH = ''${vulkan-validation-layers}/share/vulkan/explicit_layer.d'';
      VK_ICD_FILENAMES = "$(cat ${icd})";
      OCL_ICD_VENDORS = "${mesa.opencl}/etc/OpenCL/vendors/";
      __EGL_VENDOR_LIBRARY_DIRS = "${mesa}/share/glvnd/egl_vendor.d/";
    };
  }
)
