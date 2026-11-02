<#
.SYNOPSIS
  Builds the Lazarus binaries the Windows installers take and, with -Setup,
  the installers themselves.

.DESCRIPTION
  1. reportman_rtl from scratch (-B) for x86_64 and i386: FPC does not notice
     a changed {$R} file, so an incremental build can keep an old
     REPORTMANRES.RES (translations) in the package.
  2. The LCL designer (x64)            -> repman\repmandesigner_lcl.exe
  3. printrepxp (x64)                  -> install\bin\x86_64-win64
  4. Reportman.ocx (x64 and i386)      -> install\bin\<cpu>-<os>
  5. With -Setup: ReportManagerDesigner_LCL.iss and
     ReportManagerPrintUtils_LCL.iss   -> install\Output

  The i386 build needs the i386-win32 cross compiler of the Lazarus
  installer (ppc386.exe next to ppcx64.exe).

.EXAMPLE
  install\build-lazarus.ps1 -Setup
  install\build-lazarus.ps1 -LazarusDir D:\lazarus
#>
param(
  [string]$LazarusDir = 'C:\lazarus',
  [switch]$Setup
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$lazbuild = Join-Path $LazarusDir 'lazbuild.exe'
if (-not (Test-Path $lazbuild)) { throw "lazbuild not found: $lazbuild" }

function Invoke-Lazbuild([string[]]$arguments) {
  Write-Host "lazbuild $($arguments -join ' ')"
  & $lazbuild @arguments | Select-String -Pattern 'Error:|Fatal:|Linking' | ForEach-Object { Write-Host "  $_" }
  if ($LASTEXITCODE -ne 0) { throw "lazbuild failed ($LASTEXITCODE): $($arguments -join ' ')" }
}

$targets = @(
  @{ Cpu = 'x86_64'; Os = 'win64' },
  @{ Cpu = 'i386';   Os = 'win32' }
)

foreach ($t in $targets) {
  $cpu = @("--cpu=$($t.Cpu)", "--os=$($t.Os)")
  Invoke-Lazbuild (@('-B', '--no-write-project') + $cpu + "$root\packages\fpc\reportman_rtl.lpk")
  Invoke-Lazbuild (@('--ws=win32', '--bm=Release') + $cpu + "$root\activex\fpc\reportman.lpi")
}

$x64 = @('--ws=win32', '--bm=Release', '--cpu=x86_64', '--os=win64')
Invoke-Lazbuild ($x64 + "$root\repman\utils\printrep\lcl\printrepxp.lpi")
Invoke-Lazbuild ($x64 + "$root\repman\lcl_designer\repmandesigner_lcl.lpi")

if ($Setup) {
  $iscc = @(
    "${env:ProgramFiles(x86)}\Inno Setup 7\ISCC.exe",
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "$env:ProgramFiles\Inno Setup 7\ISCC.exe",
    "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
  ) | Where-Object { Test-Path $_ } | Select-Object -First 1
  if (-not $iscc) { throw 'ISCC.exe (Inno Setup 6 or 7) not found' }
  foreach ($script in 'ReportManagerDesigner_LCL.iss', 'ReportManagerPrintUtils_LCL.iss') {
    Write-Host "ISCC $script"
    & $iscc /Q "/DLazarusDir=$LazarusDir" (Join-Path $PSScriptRoot $script)
    if ($LASTEXITCODE -ne 0) { throw "ISCC failed ($LASTEXITCODE): $script" }
  }
  Get-ChildItem (Join-Path $PSScriptRoot 'Output') -Filter '*_lcl_*.exe' |
    ForEach-Object { Write-Host "  $($_.FullName)" }
}
