{*******************************************************}
{                                                       }
{       Report Manager                                  }
{                                                       }
{       Reportman.ocx - Lazarus                         }
{                                                       }
{       COM automation server of Report Manager         }
{                                                       }
{       This file is under the MPL license              }
{       If you enhace this file you must provide        }
{       source code                                     }
{                                                       }
{*******************************************************}

{ Lazarus build of Reportman.ocx (activex\reportman.dpr): the ReportManX
  automation object with the CLSIDs and the type library of the Delphi
  control, for VBScript / JScript and other late bound clients. See
  rpaxreportfpc.pas for what differs.

  Register:   regsvr32 Reportman.ocx      (32-bit and 64-bit builds; each
  Unregister: regsvr32 /u Reportman.ocx    one serves the clients of its
                                           bitness) }

library reportman;

{$mode delphi}{$H+}

// Reportman.ocx, the name the clients and the installers know
{$EXTENSION 'ocx'}

uses
  Interfaces, ComServ, reportman_tlb_fpc, rpaxreportfpc;

{$R reportman_tlb.rc}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

begin
end.
