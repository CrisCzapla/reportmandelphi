; Shared by the installers of the Lazarus build (ReportManagerDesigner_LCL.iss,
; ReportManagerPrintUtils_LCL.iss).
;
; The binaries come from the Lazarus projects (install\build-lazarus.ps1 builds
; them all):
;   repman\repmandesigner_lcl.exe              LCL designer (x64)
;   install\bin\x86_64-win64\printrepxp.exe    repman\utils\printrep\lcl
;   install\bin\x86_64-win64\Reportman.ocx     activex\fpc (64-bit clients)
;   install\bin\i386-win32\Reportman.ocx       activex\fpc (32-bit clients:
;                                              Comarch ERP XL / Optima scripts)
; Optional files, not in git, taken when present:
;   repman\libssl-3-x64.dll, repman\libcrypto-3-x64.dll   OpenSSL 3 (HTTPS)
;   install\deps\x64\sqlite3.dll                          the sample reports

#include "version.iss"

; The edition of this build, after the version (AppVersion, file names)
#define Edition "DMC"

#define Root AddBackslash(SourcePath) + ".."
#define Bin64 Root + "\install\bin\x86_64-win64"
#define Bin32 Root + "\install\bin\i386-win32"

; The folder of the previous (Delphi, 32-bit) installers: the printouts of the
; ERP call printrepxp.exe there, so the Lazarus build keeps it
#define AppDir "{commonpf32}\Report Manager"

; The Lazarus installation: its lcl\languages has the LCL translations
#ifndef LazarusDir
  #define LazarusDir "C:\lazarus"
#endif

#define OpenSSLDir Root + "\repman"
#define SQLiteDll Root + "\install\deps\x64\sqlite3.dll"

#if !FileExists(Bin64 + "\printrepxp.exe") || !FileExists(Bin64 + "\Reportman.ocx") || !FileExists(Bin32 + "\Reportman.ocx")
  #error printrepxp.exe or Reportman.ocx missing: run install\build-lazarus.ps1
#endif
