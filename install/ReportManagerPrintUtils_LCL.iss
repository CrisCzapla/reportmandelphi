; Report Manager print utilities, Lazarus build: printrepxp and Reportman.ocx
; (32 and 64 bit), for the computers that print but do not design. Build the
; binaries first: install\build-lazarus.ps1 (it also compiles this script
; with -Setup).

#include "lcl_common.iss"

[Setup]
AppId=ReportManagerPrintUtilsLCL
AppName=Report Manager Print Utils
AppVersion={#AppVer} {#Edition}
AppPublisher=Toni Martir
AppPublisherURL=https://reportman.es
VersionInfoProductName=Report Manager
VersionInfoProductVersion={#AppVer}
DefaultDirName={#AppDir}
DefaultGroupName=Report Manager
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\printrepxp.exe
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
Compression=lzma2
SolidCompression=yes
OutputDir=Output
OutputBaseFilename=reportman_printutils_lcl_{#AppVerU}_{#Edition}
SetupIconFile=..\repman\utils\printrep\printrepxp_Icon.ico
ChangesAssociations=yes
UninstallLogMode=overwrite

#include "lcl_files.iss"

[Files]
Source: "{#Root}\repman\dbxdrivers.ini"; DestDir: "{%PUBLIC}"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "{#Root}\repman\dbxconnections.ini"; DestDir: "{%PUBLIC}"; Flags: onlyifdoesntexist uninsneveruninstall

[Registry]
; Without the designer a report opens in the preview of printrepxp. The
; designer installer sets the association to itself; it is not changed here
; when it is installed.
Root: HKCR; Subkey: ".rep"; ValueType: string; ValueData: "Report Manager Template"; Flags: uninsdeletevalue; Check: not DesignerInstalled
Root: HKCR; Subkey: "Report Manager Template"; ValueType: string; ValueData: "Report Manager Template File"; Flags: uninsdeletekey; Check: not DesignerInstalled
Root: HKCR; Subkey: "Report Manager Template\DefaultIcon"; ValueType: string; ValueData: "{app}\printrepxp.exe,0"; Check: not DesignerInstalled
Root: HKCR; Subkey: "Report Manager Template\Shell\Open\Command"; ValueType: string; ValueData: """{app}\printrepxp.exe"" -preview ""%1"""; Check: not DesignerInstalled

[Code]
function DesignerInstalled: Boolean;
begin
  Result := FileExists(ExpandConstant('{app}\repmandesigner_lcl.exe'));
end;
