; Report Manager Designer, Lazarus build: the LCL designer, printrepxp and
; Reportman.ocx (32 and 64 bit). Build the binaries first:
; install\build-lazarus.ps1 (it also compiles this script with -Setup).

#include "lcl_common.iss"

[Setup]
AppId=ReportManagerDesignerLCL
AppName=Report Manager Designer
AppVersion={#AppVer} {#Edition}
AppPublisher=Toni Martir
AppPublisherURL=https://reportman.es
VersionInfoProductName=Report Manager
VersionInfoProductVersion={#AppVer}
DefaultDirName={#AppDir}
DefaultGroupName=Report Manager
UninstallDisplayIcon={app}\repmandesigner_lcl.exe
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
Compression=lzma2
SolidCompression=yes
OutputDir=Output
OutputBaseFilename=reportman_designer_lcl_{#AppVerU}_{#Edition}
SetupIconFile=..\repman\lcl_designer\repmandesigner_lcl.ico
ChangesAssociations=yes
UninstallLogMode=overwrite

#include "lcl_files.iss"

[Files]
Source: "{#Root}\repman\repmandesigner_lcl.exe"; DestDir: "{app}"; Flags: ignoreversion
; The LCL texts (dialog buttons...) in the language of the user; the texts of
; Report Manager are in the executable
Source: "{#LazarusDir}\lcl\languages\lclstrconsts.pl.po"; DestDir: "{app}\languages"
; The sample reports and their SQLite database: the welcome window of the
; designer lists them and opens a copy in Documents\Report Manager\Samples
Source: "{#Root}\samples\*"; DestDir: "{app}\samples"; Flags: recursesubdirs createallsubdirs
#if FileExists(SQLiteDll)
Source: "{#SQLiteDll}"; DestDir: "{app}"; Flags: ignoreversion
#else
  #pragma warning "install\deps\x64\sqlite3.dll not found: the sample reports will not open"
#endif
#if FileExists(OpenSSLDir + "\libssl-3-x64.dll") && FileExists(OpenSSLDir + "\libcrypto-3-x64.dll")
Source: "{#OpenSSLDir}\libssl-3-x64.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#OpenSSLDir}\libcrypto-3-x64.dll"; DestDir: "{app}"; Flags: ignoreversion
#else
  #pragma warning "OpenSSL 3 x64 not found in repman\: no HTTPS (AI, Hub) in the designer"
#endif
; The connections are the user's: installed only when there are none, and
; never removed, like the drivers file they refer to
Source: "{#Root}\repman\dbxdrivers.ini"; DestDir: "{%PUBLIC}"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "{#Root}\repman\dbxconnections.ini"; DestDir: "{%PUBLIC}"; Flags: onlyifdoesntexist uninsneveruninstall

[Icons]
Name: "{group}\Report Manager Designer"; Filename: "{app}\repmandesigner_lcl.exe"
Name: "{group}\{cm:UninstallProgram,Report Manager Designer}"; Filename: "{uninstallexe}"

[Registry]
Root: HKCR; Subkey: ".rep"; ValueType: string; ValueData: "Report Manager Template"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "Report Manager Template"; ValueType: string; ValueData: "Report Manager Designer Template File"; Flags: uninsdeletekey
Root: HKCR; Subkey: "Report Manager Template\DefaultIcon"; ValueType: string; ValueData: "{app}\repmandesigner_lcl.exe,0"
Root: HKCR; Subkey: "Report Manager Template\Shell\Open\Command"; ValueType: string; ValueData: """{app}\repmandesigner_lcl.exe"" ""%1"""

[Run]
; Controlled Folder Access: see lcl_files.iss
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -NonInteractive -ExecutionPolicy Bypass -Command ""Add-MpPreference -ControlledFolderAccessAllowedApplications '{app}\repmandesigner_lcl.exe' -ErrorAction SilentlyContinue"""; Flags: runhidden
Filename: "{app}\repmandesigner_lcl.exe"; Description: "{cm:LaunchProgram,Report Manager Designer}"; Flags: postinstall nowait skipifsilent runasoriginaluser

[UninstallRun]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -NonInteractive -ExecutionPolicy Bypass -Command ""Remove-MpPreference -ControlledFolderAccessAllowedApplications '{app}\repmandesigner_lcl.exe' -ErrorAction SilentlyContinue"""; Flags: runhidden; RunOnceId: "CFADesigner"
