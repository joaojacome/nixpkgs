{ lib, stdenv, fetchurl, meson, ninja, wrapGAppsHook, pkg-config
, appstream-glib, desktop-file-utils, python3
, gtk, girara, gettext, libxml2, check
, sqlite, glib, texlive, libintl, libseccomp
, file, librsvg
, gtk-mac-integration
}:

with lib;

stdenv.mkDerivation rec {
  pname = "zathura";
  version = "0.5.2";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    sha256 = "15314m9chmh5jkrd9vk2h2gwcwkcffv2kjcxkd4v3wmckz5sfjy6";
  };

  outputs = [ "bin" "man" "dev" "out" ];

  # Flag list:
  # https://github.com/pwmt/zathura/blob/master/meson_options.txt
  mesonFlags = [
    "-Dsqlite=enabled"
    "-Dmanpages=enabled"
    "-Dconvert-icon=enabled"
    "-Dsynctex=enabled"
    # Make sure tests are enabled for doCheck
    "-Dtests=enabled"
  ] ++ optional (!stdenv.isLinux) "-Dseccomp=disabled";

  nativeBuildInputs = [
    meson ninja pkg-config desktop-file-utils python3.pkgs.sphinx
    gettext wrapGAppsHook libxml2 check appstream-glib
  ];

  buildInputs = [
    gtk girara libintl sqlite glib file librsvg
    texlive.bin.core
  ] ++ optional stdenv.isLinux libseccomp
    ++ optional stdenv.isDarwin gtk-mac-integration;

  doCheck = !stdenv.isDarwin;

  meta = {
    homepage = "https://git.pwmt.org/pwmt/zathura";
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
}
