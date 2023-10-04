{ lib
, stdenvNoCC
, fetchFromGitHub
, gtk3
}:

stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-plus-icon-pack";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo = pname;
    rev = "ccbd23ef50d027790c019165bf19145c66823d7d";
    sha256 = "sha256-KefCHHFtuh2wAGBq6hZr9DpuJ0W99ueh8i1K3tohgG8=";
  };

  nativeBuildInputs = [ gtk3 ];

  dontDropIconThemeCache = true;
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/GruvboxPlus
    cp -rv * $out/share/icons/GruvboxPlus
    runHook postInstall
  '';


  meta = with lib; {
    description = "Gruvbox Plus icons for GTK based desktop environments";
    homepage = "https://github.com/SylEleuth/gruvbox-plus-icon-pack";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.Spatenheinz ];
  };
}
