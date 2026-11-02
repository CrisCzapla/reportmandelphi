; The files and settings both Lazarus installers share: printrepxp and the two
; Reportman.ocx. "sharedfile" counts the installers that use them, so
; uninstalling one of them keeps them for the other.

[Files]
Source: "{#Bin64}\printrepxp.exe"; DestDir: "{app}"; Flags: ignoreversion sharedfile
; The ActiveX server for each bitness, registered with the regsvr32 of that
; bitness (same CLSIDs as the Delphi Reportman.ocx: it replaces its
; registration). An OCX in use by the ERP is replaced after a restart.
Source: "{#Bin32}\Reportman.ocx"; DestDir: "{app}\ocx32"; Flags: ignoreversion sharedfile regserver 32bit restartreplace uninsrestartdelete
Source: "{#Bin64}\Reportman.ocx"; DestDir: "{app}\ocx64"; Flags: ignoreversion sharedfile regserver 64bit restartreplace uninsrestartdelete

[Run]
; Controlled Folder Access (Windows Defender) allows writing to protected
; folders (Documents, folders added by the user) per executable path, and a
; blocked write shows only "Stream write error". Ignored without Defender.
; A computer gets one of the two installers, so uninstalling removes it.
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -NonInteractive -ExecutionPolicy Bypass -Command ""Add-MpPreference -ControlledFolderAccessAllowedApplications '{app}\printrepxp.exe' -ErrorAction SilentlyContinue"""; Flags: runhidden

[UninstallRun]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -NonInteractive -ExecutionPolicy Bypass -Command ""Remove-MpPreference -ControlledFolderAccessAllowedApplications '{app}\printrepxp.exe' -ErrorAction SilentlyContinue"""; Flags: runhidden; RunOnceId: "CFAPrintrep"

[Languages]
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
