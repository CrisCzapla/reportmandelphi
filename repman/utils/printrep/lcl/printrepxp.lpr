{*******************************************************}
{                                                       }
{       Report Manager                                  }
{                                                       }
{       printrepxp - LCL                                }
{                                                       }
{       Process and Prints a report                     }
{       you can select the pages to print               }
{                                                       }
{       Copyright (c) 1994-2026 Toni Martir             }
{       toni@reportman.es                               }
{                                                       }
{       This file is under the MPL license              }
{       If you enhace this file you must provide        }
{       source code                                     }
{                                                       }
{                                                       }
{*******************************************************}

{ Lazarus port of repman\utils\printrep\printrepxp.dpr: the same command line,
  with the LCL driver, preview and parameters form (rplcldriver,
  rplclpreview, rprflclparams) instead of the VCL ones. Fax sending (APRO) is
  not available.

  Uses only the reportman_rtl / reportman_lcl packages; the project lives in
  its own folder so that FPC does not find the Delphi files of printrep\. }

program printrepxp;

{$APPTYPE CONSOLE}

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}
  cthreads, cwstring,
  {$ENDIF}
  SysUtils, Classes,
  {$IFDEF MSWINDOWS}
  Windows, ActiveX,
  {$ENDIF}
  Interfaces, Forms, Graphics, Printers,
  rpreport, rpparams, rpmdconsts, rptypes, rpmetafile,
  rppreviewcontrol, rplclpreview, rplcldriver, rprflclparams;

{$R *.res}

var
 report:TRpReport;
 indexparam:integer;
 showprogress:boolean;
 filename:string;
 allpages:boolean;
 frompage:integer;
 topage:integer;
 copies,acopies:integer;
 collate:boolean;
 preview:boolean;
 pdialog:boolean;
 compress,doprint:boolean;

procedure PrintHelp;
begin
 Writeln(SRpPrintRep1+' XP '+RM_VERSION);
 Writeln(SRpPrintRep2);
 Writeln(SRpPrintRep3);
 Writeln(SRpPrintRep4);
 Writeln(SRpPrintRep5);
 Writeln(SRpPrintRep6);
 Writeln(SRpPrintRep7);
 Writeln(SRpPrintRep8);
 Writeln(SRpPrintRep9);
 Writeln(SRpPrintRep10);
 Writeln(SRpPrintRep12);
 Writeln(SRpPrintPDFRep8);
 Writeln(SRpPrintPDFRep9);
 Writeln(SRpPrintRep14);
 Writeln(SRpPrintRep18);
 Writeln(SRpPrintRep19);
 Writeln(SRpPrintRep20);
 Writeln(SRpPrintRep24);
 Writeln(SRpPrintRep25);
 Writeln(SRpPrintRep29);
 Writeln(SRpParseParamsH);
 Writeln(SRpCommandLineStdIN);
end;

var
 isstdin:Boolean;
 memstream:TMemoryStream;
 topdf,tobmp,monobmp,tometafile,showparams:Boolean;
 bmpresx,bmpresy:integer;
 meta:TrpMetafileReport;
 abitmap:TBitmap;
 outputfilename:String;
 aprintername:string;
 aindex:integer;
 amessage:String;
 async:boolean;
 prcontrol:TRpPreviewControl;
begin
 async:=false;
 bmpresx:=100;
 bmpresy:=100;
 tobmp:=false;
 monobmp:=true;
 topdf:=false;
 tometafile:=false;
 outputfilename:='';
{$IFDEF MSWINDOWS}
 // ADO connections (Zeos OleDB) need COM in this thread
 CoInitialize(nil);
 // The help and the messages are translated: write them in UTF-8, the
 // console code page (852 in Poland) does not match the ANSI one
 if SetConsoleOutputCP(CP_UTF8) then
 begin
  SetTextCodePage(Output,CP_UTF8);
  SetTextCodePage(ErrOutput,CP_UTF8);
 end;
{$ENDIF}
 Application.Initialize;
  isstdin:=false;
  showparams:=false;
  try
   preview:=false;
   compress:=true;
   pdialog:=false;
   showprogress:=true;
   collate:=false;
   allpages:=true;
   frompage:=1;
   acopies:=0;
   topage:=999999999;
   indexparam:=1;
   filename:='';
   // Get the options
   while indexparam<ParamCount+1 do
   begin
    if ParamStr(indexparam)='-q' then
     showprogress:=false
    else
    if ParamStr(indexparam)='-preview' then
     preview:=true
    else
    if ParamStr(indexparam)='-showparams' then
     showparams:=true
    else
    if ParamStr(indexparam)='-u' then
     compress:=false
    else
    if ParamStr(indexparam)='-async' then
     async:=true
    else
    if ParamStr(indexparam)='-pdialog' then
     pdialog:=true
    else
    if ParamStr(indexparam)='-stdin' then
     isstdin:=true
    else
    // The window of the calling application: the preview opens on its
    // monitor
    if ParamStr(indexparam)='-owner' then
    begin
     inc(indexparam);
     if indexparam>=Paramcount+1 then
      Raise Exception.Create(SRpNumberexpected);
     RpPreviewOwnerWindow:=THandle(StrToInt64(ParamStr(indexparam)));
    end
    else
    if ParamStr(indexparam)='-from' then
    begin
     inc(indexparam);
     if indexparam>=Paramcount+1 then
      Raise Exception.Create(SRpNumberexpected);
     frompage:=StrToInt(ParamStr(indexparam));
     allpages:=false;
    end
    else
    if ParamStr(indexparam)='-pdf' then
    begin
     topdf:=true;
    end
    else
    if ParamStr(indexparam)='-bmp' then
    begin
     tobmp:=true;
    end
    else
    if ParamStr(indexparam)='-bmpcolor' then
    begin
     monobmp:=false;
    end
    else
    if ParamStr(indexparam)='-m' then
    begin
     tometafile:=true;
    end
    else
     if ParamStr(indexparam)='-to' then
     begin
      inc(indexparam);
      if indexparam>=Paramcount+1 then
       Raise Exception.Create(SRpNumberexpected);
      topage:=StrToInt(ParamStr(indexparam));
      allpages:=false;
     end
     else
     if ParamStr(indexparam)='-copies' then
     begin
      inc(indexparam);
      if indexparam>=Paramcount+1 then
       Raise Exception.Create(SRpNumberexpected);
      acopies:=StrToInt(ParamStr(indexparam));
      if acopies<=0 then
       acopies:=1;
     end
     else
     if ParamStr(indexparam)='-printer' then
     begin
      inc(indexparam);
      if indexparam>=Paramcount+1 then
       Raise Exception.Create(SRpIdentifierexpected);
      aprintername:=ParamStr(indexparam);
      aindex:=printer.printers.IndexOf(aprintername);
      if aindex<0 then
      begin
       amessage:=SRpErrorOpenImp+':'+aprintername+#10;
       for aindex:=0 to printer.Printers.Count-1 do
       begin
        amessage:=amessage+printer.printers.Strings[aindex]+#10;
       end;
       Raise Exception.Create(amessage);
      end;
      printer.printerindex:=aindex;
     end
     else
     if ParamStr(indexparam)='-bmpresx' then
     begin
      inc(indexparam);
      if indexparam>=Paramcount+1 then
       Raise Exception.Create(SRpNumberexpected);
      bmpresx:=StrToInt(ParamStr(indexparam));
      if bmpresx<=0 then
       bmpresx:=200;
     end
     else
     if ParamStr(indexparam)='-bmpresy' then
     begin
      inc(indexparam);
      if indexparam>=Paramcount+1 then
       Raise Exception.Create(SRpNumberexpected);
      bmpresy:=StrToInt(ParamStr(indexparam));
      if bmpresy<=0 then
       bmpresy:=200;
     end
     else
     if ParamStr(indexparam)='-collate' then
     begin
      collate:=true;
     end
     else
     if Pos('-param',ParamStr(indexparam))<>1 then
     begin
      if (isstdin or (Length(filename)>0)) then
      begin
       outputfilename:=ParamStr(indexparam);
       inc(indexparam);
       break;
      end
      else
      begin
       filename:=ParamStr(indexparam);
       if ((not topdf) and (not tometafile) and (not tobmp)) then
       begin
        inc(indexparam);
        break;
       end;
      end;
     end;
    inc(indexparam);
   end;
   if indexparam<ParamCount+1 then
   begin
    PrintHelp;
    Raise Exception.Create(SRpTooManyParams)
   end;
   memstream:=ExeResourceToStream(100);
   if ((Length(filename)<1) and (not isstdin) and (Not Assigned(memstream))) then
   begin
    PrintHelp;
   end
   else
   begin
    report:=TRpReport.Create(nil);
    try
     if not preview then
      async:=false;
     report.AsyncExecution:=async;
     report.ProgressToStdOut:=true;
     if assigned(memstream) then
     begin
      try
       report.LoadFromStream(memstream);
      finally
       memstream.free;
      end;
      // Preview flag
      memstream:=ExeResourceToStream(101);
      if Assigned(memstream) then
      begin
       preview:=true;
       memstream.free;
      end;
      // Showparams flag
      memstream:=ExeResourceToStream(102);
      if Assigned(memstream) then
      begin
       showparams:=true;
       memstream.free;
      end;
     end
     else
     if isstdin then
     begin
      memstream:=ReadFromStdInputStream;
      try
       memstream.Seek(0,soFromBeginning);
       report.LoadFromStream(memstream);
      finally
       memstream.free;
      end;
     end
     else
      report.LoadFromFile(filename);
     if acopies=0 then
      copies:=report.Copies
     else
      copies:=acopies;
     ParseCommandLineParams(report.Params);
     doprint:=true;
     if showparams then
      doprint:=ShowUserParams(report.params);
     if not preview then
      if pdialog then
       doprint:=rplcldriver.DoShowPrintDialog(allpages,frompage,topage,copies,collate);
     if doprint then
     begin
      if topdf or tometafile then
      begin
       memstream:=TMemoryStream.Create;
       try
        rplcldriver.ExportReportToPDFMetaStream(report,filename,showprogress,
         allpages,frompage,topage,copies,pdialog,memstream,compress,collate,tometafile);
        memstream.Seek(0,soFromBeginning);
        if Length(outputfilename)>0 then
         memstream.SaveToFile(outputfilename)
        else
         WriteStreamToStdOutput(memstream);
       finally
        memstream.Free;
       end;
      end
      else
      if tobmp then
      begin
       memstream:=TMemoryStream.Create;
       try
        rplcldriver.ExportReportToPDFMetaStream(report,filename,showprogress,
         allpages,frompage,topage,copies,pdialog,memstream,compress,collate,true);
        memstream.Seek(0,soFromBeginning);
        meta:=TRpMetafileReport.Create(nil);
        try
         meta.LoadFromStream(memstream);
         abitmap:=rplcldriver.MetafileToBitmap(meta,showprogress,monobmp,bmpresx,bmpresy);
         try
          memstream.SetSize(0);
          abitmap.SaveToStream(memstream);
          memstream.Seek(0,soFromBeginning);
          if Length(outputfilename)>0 then
           memstream.SaveToFile(outputfilename)
          else
           WriteStreamToStdOutput(memstream);
         finally
          abitmap.free;
         end;
        finally
         meta.free;
        end;
       finally
        memstream.Free;
       end;
      end
      else
      if preview then
      begin
       prcontrol:=TRpPreviewControl.Create(nil);
       try
        prcontrol.Report:=report;
        ShowPreview(prcontrol,filename);
       finally
        prcontrol.free;
       end;
      end
      else
      begin
       PrintReport(report,filename,showprogress,allpages,
        frompage,topage,copies,collate);
      end;
     end;
    finally
     report.free;
    end;
   end;
 except
  On E:Exception do
  begin
   WriteToStdError(E.Message+LINE_FEED);
   ExitCode:=1;
  end;
 end;
end.
