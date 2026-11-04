{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # DuckStation
    (appimageTools.wrapType2 rec {
      pname = "duckstation";
      version = "latest";
      src = fetchurl {
        url = "https://github.com/stenzek/duckstation/releases/download/latest/DuckStation-x64.AppImage";
        hash = "sha256-TVw9z9mTfcnne4/NX4ebjsDGlVHV7RNGJZIHNghUL8o=";
      };
      extraPkgs = pkgs: [pkgs.libgpg-error];
      extraInstallCommands = let
        appimageContents = appimageTools.extract {inherit pname version src;};
      in ''
        install -Dm644 ${appimageContents}/org.duckstation.DuckStation.desktop \
          $out/share/applications/org.duckstation.DuckStation.desktop
        substituteInPlace $out/share/applications/org.duckstation.DuckStation.desktop \
          --replace-fail 'duckstation-qt' "$out/bin/duckstation"
        install -Dm644 ${appimageContents}/org.duckstation.DuckStation.png \
          $out/share/pixmaps/org.duckstation.DuckStation.png
      '';
      meta.mainProgram = "duckstation";
    })

    # ES-DE
    (appimageTools.wrapType2 rec {
      pname = "es-de";
      version = "3.5.0";
      src = fetchurl {
        url = "https://packages.es-de.org/release/3.5.0/ES-DE_x64.AppImage";
        hash = "sha256-q8KZmhI4X4V3W9P5hvqJHHa2nfN5H3wS5MeDzzw2MPU=";
      };
      extraPkgs = pkgs: [pkgs.libgpg-error];
      extraInstallCommands = let
        appimageContents = appimageTools.extract {inherit pname version src;};
      in ''
        install -Dm644 ${appimageContents}/org.es_de.frontend.desktop \
          $out/share/applications/org.es_de.frontend.desktop
        substituteInPlace $out/share/applications/org.es_de.frontend.desktop \
          --replace-fail 'Exec=es-de' "Exec=$out/bin/es-de"
        install -Dm644 ${appimageContents}/org.es_de.frontend.svg \
          $out/share/pixmaps/org.es_de.frontend.svg
      '';
      meta.mainProgram = "es-de";
    })
  ];
}
