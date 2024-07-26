{...}: {
  programs.autofirma.enable = true;
  programs.autofirma.fixJavaCerts = true;
  programs.autofirma.firefoxIntegration.enable = true; # Para que Firefox utilice AutoFirma
  programs.configuradorfnmt.enable = true;
  programs.configuradorfnmt.firefoxIntegration.enable = true; # Para que Firefox utilice el Configurador FNMT
}
