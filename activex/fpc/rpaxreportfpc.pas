{*******************************************************}
{                                                       }
{       Report Manager                                  }
{                                                       }
{       rpaxreportfpc                                   }
{                                                       }
{       Automation objects of Reportman.ocx built       }
{       with Lazarus                                    }
{                                                       }
{       This file is under the MPL license              }
{       If you enhace this file you must provide        }
{       source code                                     }
{                                                       }
{*******************************************************}

{ The Delphi Reportman.ocx is an ActiveX control (TActiveXControl over the
  invisible TRpActiveXReport, activex\rpaxreportimp.pas). FPC has no ActiveX
  control framework, so this server publishes the same coclasses as plain
  automation objects (TAutoObject): same CLSIDs, same type library, so
  CreateObject("reportman.ReportManX") from VBScript / JScript and late
  bound clients keep working. The report runs through TLCLReport, the LCL
  counterpart of TVCLReport.

  Differences with the Delphi control:
  - it cannot be placed on a form (no OLE control interfaces); the
    PreviewControl coclass (TActiveForm) is not available;
  - the control properties (Visible, Enabled, Cursor, DoubleBuffered,
    HelpType...) are kept as plain values and do nothing;
  - SaveToExcel / SaveToExcel2 raise "not supported" (as the LCL report);
  - SetRecordSet raises "not supported" (ADO recordsets need the VCL ADO
    driver);
  - DebugMode shows the exceptions in a message box instead of raising
    them (no JCL stack trace). }

unit rpaxreportfpc;

{$mode delphi}{$H+}

interface

uses
  Windows, ActiveX, ComObj, SysUtils, Classes, Variants, Forms, Dialogs,
  Printers, reportman_tlb_fpc, rpreport, rpparams, rptypes, rpmdconsts,
  rpcolumnar, rplclreport, rplcldriver, rphtmldriver;

type
  TReportParam = class(TAutoObject, IReportParam)
  protected
    function Get_Name: WideString; safecall;
    procedure Set_Name(const Value: WideString); safecall;
    function Get_description: WideString; safecall;
    procedure Set_description(const Value: WideString); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(const Value: WordBool); safecall;
    function Get_ParamType: TxParamType; safecall;
    procedure Set_ParamType(const Value: TxParamType); safecall;
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(const Value: OleVariant); safecall;
  public
    FParam: TRpParam;
  end;

  TReportParameters = class(TAutoObject, IReportParameters)
  protected
    function Get_Count: Integer; safecall;
    function Get_Items(Index: Integer): ReportParam; safecall;
    function ParamExists(paramname: WideString): WordBool; safecall;
  public
    FReport: TRpReport;
  end;

  TReportReport = class(TAutoObject, IReportReport)
  private
    FReportParameters: IReportParameters;
    FColumnar: TRpColumnar;
    FAutoResizeColumns: Boolean;
  protected
    function Get_Params: ReportParameters; safecall;
    function Get_VCLReport: PWideChar; safecall;
    procedure AddColumn(Width: Integer; Expression: WideString;
      ExpFormat: WideString; Caption: WideString; CaptionFormat: WideString;
      SumaryExpression: WideString; SumaryFormat: WideString); safecall;
    function Get_AutoResizeColumns: WordBool; safecall;
    procedure Set_AutoResizeColumns(const Value: WordBool); safecall;
    procedure SaveToFile(filename: WideString); safecall;
  public
    FReport: TRpReport;
    destructor Destroy; override;
  end;

  TReportManX = class(TAutoObject, IReportManX)
  private
    FReport: TLCLReport;
    FReportReport: IReportReport;
    FDebugMode: Boolean;
    FVisible, FEnabled, FDoubleBuffered: Boolean;
    FCursor: Smallint;
    FHelpType: TxHelpType;
    FHelpKeyword: WideString;
    procedure ShowError(E: Exception);
  protected
    procedure SetDatasetSQL(datasetname: WideString; sqlsentence: WideString); safecall;
    procedure SetDatabaseConnectionString(databasename: WideString; connectionstring: WideString); safecall;
    function GetDatasetSQL(datasetname: WideString): WideString; safecall;
    function GetDatabaseConnectionString(databasename: WideString): WideString; safecall;
    procedure SetParamValue(paramname: WideString; paramvalue: OleVariant); safecall;
    function GetParamValue(paramname: WideString): OleVariant; safecall;
    function Execute: WordBool; safecall;
    procedure PrinterSetup; safecall;
    function ShowParams: WordBool; safecall;
    procedure SaveToPDF(filename: WideString; compressed: WordBool); safecall;
    function PrintRange(frompage: Integer; topage: Integer; copies: Integer; collate: WordBool): WordBool; safecall;
    function Get_filename: WideString; safecall;
    procedure Set_filename(const Value: WideString); safecall;
    function Get_Preview: WordBool; safecall;
    procedure Set_Preview(const Value: WordBool); safecall;
    function Get_ShowProgress: WordBool; safecall;
    procedure Set_ShowProgress(const Value: WordBool); safecall;
    function Get_ShowPrintDialog: WordBool; safecall;
    procedure Set_ShowPrintDialog(const Value: WordBool); safecall;
    function Get_Title: WideString; safecall;
    procedure Set_Title(const Value: WideString); safecall;
    function Get_Language: Integer; safecall;
    procedure Set_Language(const Value: Integer); safecall;
    function Get_DoubleBuffered: WordBool; safecall;
    procedure Set_DoubleBuffered(const Value: WordBool); safecall;
    function Get_AlignDisabled: WordBool; safecall;
    function Get_VisibleDockClientCount: Integer; safecall;
    function DrawTextBiDiModeFlagsReadingOnly: Integer; safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(const Value: WordBool); safecall;
    procedure InitiateAction; safecall;
    function IsRightToLeft: WordBool; safecall;
    function UseRightToLeftReading: WordBool; safecall;
    function UseRightToLeftScrollBar: WordBool; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(const Value: WordBool); safecall;
    function Get_Cursor: Smallint; safecall;
    procedure Set_Cursor(const Value: Smallint); safecall;
    function Get_HelpType: TxHelpType; safecall;
    procedure Set_HelpType(const Value: TxHelpType); safecall;
    function Get_HelpKeyword: WideString; safecall;
    procedure Set_HelpKeyword(const Value: WideString); safecall;
    procedure SetSubComponent(IsSubComponent: WordBool); safecall;
    procedure AboutBox; safecall;
    procedure ExecuteRemote(hostname: WideString; port: Integer; user: WideString;
      password: WideString; aliasname: WideString; reportname: WideString); safecall;
    procedure CalcReport(ShowProgress: WordBool); safecall;
    procedure Compose(Report: ReportReport; Execute: WordBool); safecall;
    procedure SaveToText(filename: WideString; textdriver: WideString); safecall;
    function Get_Report: ReportReport; safecall;
    procedure SaveToExcel(filename: WideString); safecall;
    procedure SaveToHTML(filename: WideString); safecall;
    procedure SetRecordSet(datasetname: WideString; Value: IDispatch); safecall;
    procedure SaveToCustomText(filename: WideString); safecall;
    procedure SaveToCSV(filename: WideString); safecall;
    procedure SaveToSVG(filename: WideString); safecall;
    procedure SaveToMetafile(filename: WideString); safecall;
    procedure SaveToExcel2(filename: WideString); safecall;
    function Get_DefaultPrinter: WideString; safecall;
    procedure Set_DefaultPrinter(const Value: WideString); safecall;
    function Get_PrintersAvailable: WideString; safecall;
    procedure GetRemoteParams(hostname: WideString; port: Integer; user: WideString;
      password: WideString; aliasname: WideString; reportname: WideString); safecall;
    procedure SaveToCSV2(filename: WideString; separator: WideString); safecall;
    function Get_AsyncExecution: WordBool; safecall;
    procedure Set_AsyncExecution(const Value: WordBool); safecall;
    procedure SaveToHTMLSingle(filename: WideString); safecall;
    procedure SaveToFile(filename: WideString); safecall;
    procedure AddEmbeddedFile(filename: WideString; mimeType: WideString;
      base64Stream: WideString; description: WideString;
      AFRelationShip: TxAFRelationShip; ISOCreationDate: WideString;
      ISOModificationDate: WideString); safecall;
    procedure AddMetadata(Title: WideString; author: WideString; subject: WideString;
      creator: WideString; producer: WideString; keywords: WideString;
      creationDate: WideString; modificationDate: WideString); safecall;
    procedure AddXMPMetadata(XMPContent: WideString); safecall;
    procedure SetPDFConformance(PDFConformance: TxPDFConformanceType); safecall;
    function Get_DebugMode: WordBool; safecall;
    procedure Set_DebugMode(const Value: WordBool); safecall;
    procedure ShowVersion; safecall;
  public
    procedure Initialize; override;
    destructor Destroy; override;
  end;

implementation

uses ComServ;

var
  AppInitialized: Boolean = False;

// The LCL application object of the library: initialized by the first object
// created, not while the DLL is loaded (DllMain)
procedure InitApplication;
begin
  if AppInitialized then
    Exit;
  AppInitialized := True;
  Application.Initialize;
end;

{ TReportParam }

function TReportParam.Get_Name: WideString;
begin
  Result := WideString(FParam.Name);
end;

procedure TReportParam.Set_Name(const Value: WideString);
begin
  FParam.Name := String(Value);
end;

function TReportParam.Get_description: WideString;
begin
  Result := WideString(FParam.Description);
end;

procedure TReportParam.Set_description(const Value: WideString);
begin
  FParam.Description := Value;
end;

function TReportParam.Get_Visible: WordBool;
begin
  Result := FParam.Visible;
end;

procedure TReportParam.Set_Visible(const Value: WordBool);
begin
  FParam.Visible := Value;
end;

function TReportParam.Get_ParamType: TxParamType;
begin
  Result := TxParamType(Ord(FParam.ParamType));
end;

procedure TReportParam.Set_ParamType(const Value: TxParamType);
begin
  FParam.ParamType := TRpParamType(Value);
end;

function TReportParam.Get_Value: OleVariant;
begin
  Result := FParam.Value;
end;

procedure TReportParam.Set_Value(const Value: OleVariant);
begin
  FParam.Value := Value;
end;

{ TReportParameters }

function TReportParameters.Get_Count: Integer;
begin
  Result := FReport.Params.Count;
end;

function TReportParameters.Get_Items(Index: Integer): ReportParam;
var
  aparam: TReportParam;
begin
  aparam := TReportParam.Create;
  aparam.FParam := FReport.Params.Items[Index];
  Result := aparam;
end;

function TReportParameters.ParamExists(paramname: WideString): WordBool;
begin
  Result := FReport.Params.FindParam(String(paramname)) <> nil;
end;

{ TReportReport }

destructor TReportReport.Destroy;
begin
  FColumnar.Free;
  inherited Destroy;
end;

function TReportReport.Get_Params: ReportParameters;
var
  aparams: TReportParameters;
begin
  if not Assigned(FReportParameters) then
  begin
    aparams := TReportParameters.Create;
    aparams.FReport := FReport;
    FReportParameters := aparams;
  end;
  Result := FReportParameters;
end;

// The TRpReport itself, for ReportManX.Compose (same process)
function TReportReport.Get_VCLReport: PWideChar;
begin
  Result := PWideChar(FReport);
end;

procedure TReportReport.AddColumn(Width: Integer; Expression: WideString;
  ExpFormat: WideString; Caption: WideString; CaptionFormat: WideString;
  SumaryExpression: WideString; SumaryFormat: WideString);
begin
  if Assigned(FColumnar) and (FColumnar.Report <> FReport) then
    FreeAndNil(FColumnar);
  if not Assigned(FColumnar) then
  begin
    FColumnar := TRpColumnar.Create;
    FColumnar.Report := FReport;
  end;
  FColumnar.CutColumns := not FAutoResizeColumns;
  FColumnar.AddColumn(Width, Expression, ExpFormat, Caption, CaptionFormat,
    SumaryExpression, SumaryFormat);
end;

function TReportReport.Get_AutoResizeColumns: WordBool;
begin
  Result := FAutoResizeColumns;
end;

procedure TReportReport.Set_AutoResizeColumns(const Value: WordBool);
begin
  FAutoResizeColumns := Value;
end;

// Empty in the Delphi control too
procedure TReportReport.SaveToFile(filename: WideString);
begin
end;

{ TReportManX }

procedure TReportManX.Initialize;
begin
  inherited Initialize;
  InitApplication;
  FReport := TLCLReport.Create(nil);
  FReport.Preview := True;
  FVisible := True;
  FEnabled := True;
end;

destructor TReportManX.Destroy;
begin
  FReportReport := nil;
  FReport.Free;
  inherited Destroy;
end;

procedure TReportManX.ShowError(E: Exception);
begin
  MessageDlg(SRpError, E.ClassName + ': ' + E.Message, mtError, [mbOK], 0);
end;

procedure TReportManX.SetDatasetSQL(datasetname: WideString; sqlsentence: WideString);
var
  index: Integer;
begin
  index := FReport.Report.DataInfo.IndexOf(String(datasetname));
  if index < 0 then
    raise Exception.Create(SRpDatasetNotExists + ':' + String(datasetname));
  FReport.Report.DataInfo.Items[index].SQL := sqlsentence;
end;

procedure TReportManX.SetDatabaseConnectionString(databasename: WideString;
  connectionstring: WideString);
var
  index: Integer;
begin
  index := FReport.Report.DatabaseInfo.IndexOf(String(databasename));
  if index < 0 then
    raise Exception.Create(SRpDatabaseNotExists + ':' + String(databasename));
  FReport.Report.DatabaseInfo.Items[index].ADOConnectionString := connectionstring;
end;

function TReportManX.GetDatasetSQL(datasetname: WideString): WideString;
var
  index: Integer;
begin
  index := FReport.Report.DataInfo.IndexOf(String(datasetname));
  if index < 0 then
    raise Exception.Create(SRpDatasetNotExists + ':' + String(datasetname));
  Result := FReport.Report.DataInfo.Items[index].SQL;
end;

function TReportManX.GetDatabaseConnectionString(databasename: WideString): WideString;
var
  index: Integer;
begin
  index := FReport.Report.DatabaseInfo.IndexOf(String(databasename));
  if index < 0 then
    raise Exception.Create(SRpDatabaseNotExists + ':' + String(databasename));
  Result := FReport.Report.DatabaseInfo.Items[index].ADOConnectionString;
end;

procedure TReportManX.SetParamValue(paramname: WideString; paramvalue: OleVariant);
begin
  FReport.Report.Params.ParamByName(String(paramname)).Value := paramvalue;
end;

function TReportManX.GetParamValue(paramname: WideString): OleVariant;
begin
  Result := FReport.Report.Params.ParamByName(String(paramname)).Value;
end;

function TReportManX.Execute: WordBool;
begin
  try
    Result := FReport.Execute;
  except
    on E: Exception do
    begin
      if not FDebugMode then
        raise;
      ShowError(E);
      Result := False;
    end;
  end;
end;

procedure TReportManX.PrinterSetup;
begin
  FReport.PrinterSetup;
end;

function TReportManX.ShowParams: WordBool;
begin
  Result := FReport.ShowParams;
end;

procedure TReportManX.SaveToPDF(filename: WideString; compressed: WordBool);
begin
  FReport.SaveToPDF(String(filename), compressed);
end;

function TReportManX.PrintRange(frompage: Integer; topage: Integer;
  copies: Integer; collate: WordBool): WordBool;
begin
  Result := FReport.PrintRange(frompage, topage, copies, collate);
end;

function TReportManX.Get_filename: WideString;
begin
  Result := WideString(FReport.Filename);
end;

procedure TReportManX.Set_filename(const Value: WideString);
begin
  FReport.Filename := String(Value);
end;

function TReportManX.Get_Preview: WordBool;
begin
  Result := FReport.Preview;
end;

procedure TReportManX.Set_Preview(const Value: WordBool);
begin
  FReport.Preview := Value;
end;

function TReportManX.Get_ShowProgress: WordBool;
begin
  Result := FReport.ShowProgress;
end;

procedure TReportManX.Set_ShowProgress(const Value: WordBool);
begin
  FReport.ShowProgress := Value;
end;

function TReportManX.Get_ShowPrintDialog: WordBool;
begin
  Result := FReport.ShowPrintDialog;
end;

procedure TReportManX.Set_ShowPrintDialog(const Value: WordBool);
begin
  FReport.ShowPrintDialog := Value;
end;

function TReportManX.Get_Title: WideString;
begin
  Result := FReport.Title;
end;

procedure TReportManX.Set_Title(const Value: WideString);
begin
  FReport.Title := Value;
end;

function TReportManX.Get_Language: Integer;
begin
  Result := FReport.Language;
end;

procedure TReportManX.Set_Language(const Value: Integer);
begin
  FReport.Language := Value;
end;

function TReportManX.Get_DoubleBuffered: WordBool;
begin
  Result := FDoubleBuffered;
end;

procedure TReportManX.Set_DoubleBuffered(const Value: WordBool);
begin
  FDoubleBuffered := Value;
end;

function TReportManX.Get_AlignDisabled: WordBool;
begin
  Result := False;
end;

function TReportManX.Get_VisibleDockClientCount: Integer;
begin
  Result := 0;
end;

function TReportManX.DrawTextBiDiModeFlagsReadingOnly: Integer;
begin
  Result := 0;
end;

function TReportManX.Get_Enabled: WordBool;
begin
  Result := FEnabled;
end;

procedure TReportManX.Set_Enabled(const Value: WordBool);
begin
  FEnabled := Value;
end;

procedure TReportManX.InitiateAction;
begin
end;

function TReportManX.IsRightToLeft: WordBool;
begin
  Result := False;
end;

function TReportManX.UseRightToLeftReading: WordBool;
begin
  Result := False;
end;

function TReportManX.UseRightToLeftScrollBar: WordBool;
begin
  Result := False;
end;

function TReportManX.Get_Visible: WordBool;
begin
  Result := FVisible;
end;

procedure TReportManX.Set_Visible(const Value: WordBool);
begin
  FVisible := Value;
end;

function TReportManX.Get_Cursor: Smallint;
begin
  Result := FCursor;
end;

procedure TReportManX.Set_Cursor(const Value: Smallint);
begin
  FCursor := Value;
end;

function TReportManX.Get_HelpType: TxHelpType;
begin
  Result := FHelpType;
end;

procedure TReportManX.Set_HelpType(const Value: TxHelpType);
begin
  FHelpType := Value;
end;

function TReportManX.Get_HelpKeyword: WideString;
begin
  Result := FHelpKeyword;
end;

procedure TReportManX.Set_HelpKeyword(const Value: WideString);
begin
  FHelpKeyword := Value;
end;

procedure TReportManX.SetSubComponent(IsSubComponent: WordBool);
begin
end;

procedure TReportManX.AboutBox;
begin
  ShowMessage('Report Manager ActiveX (Lazarus) ' + RM_VERSION);
end;

procedure TReportManX.ExecuteRemote(hostname: WideString; port: Integer;
  user: WideString; password: WideString; aliasname: WideString;
  reportname: WideString);
begin
  FReport.ExecuteRemote(hostname, port, user, password, aliasname, reportname);
end;

procedure TReportManX.CalcReport(ShowProgress: WordBool);
var
  adriver: TRpGDIDriver;
begin
  if ShowProgress then
    CalcReportWidthProgress(FReport.Report)
  else
  begin
    adriver := TRpGDIDriver.Create;
    try
      FReport.Report.PrintAll(adriver);
    finally
      adriver.Free;
    end;
  end;
end;

procedure TReportManX.Compose(Report: ReportReport; Execute: WordBool);
var
  adriver: TRpGDIDriver;
begin
  adriver := TRpGDIDriver.Create;
  try
    FReport.Report.Compose(TRpReport(Report.VCLReport), False, adriver);
    if Execute then
      FReport.Execute;
  finally
    adriver.Free;
  end;
end;

procedure TReportManX.SaveToText(filename: WideString; textdriver: WideString);
begin
  FReport.SaveToText(String(filename), String(textdriver));
end;

function TReportManX.Get_Report: ReportReport;
var
  areport: TReportReport;
begin
  if not Assigned(FReportReport) then
  begin
    areport := TReportReport.Create;
    areport.FReport := FReport.Report;
    FReportReport := areport;
  end;
  Result := FReportReport;
end;

procedure TReportManX.SaveToExcel(filename: WideString);
begin
  FReport.SaveToExcel(String(filename), False);
end;

procedure TReportManX.SaveToHTML(filename: WideString);
begin
  ExportReportToHtml(FReport.Report, String(filename), FReport.ShowProgress);
end;

procedure TReportManX.SetRecordSet(datasetname: WideString; Value: IDispatch);
begin
  raise Exception.Create('SetRecordSet is not supported by the Lazarus build of Reportman.ocx');
end;

procedure TReportManX.SaveToCustomText(filename: WideString);
begin
  FReport.SaveToCustomText(String(filename));
end;

procedure TReportManX.SaveToCSV(filename: WideString);
begin
  FReport.SaveToCSV(String(filename));
end;

procedure TReportManX.SaveToSVG(filename: WideString);
begin
  FReport.SaveToSVG(String(filename));
end;

procedure TReportManX.SaveToMetafile(filename: WideString);
begin
  FReport.SaveToMetafile(String(filename));
end;

procedure TReportManX.SaveToExcel2(filename: WideString);
begin
  FReport.SaveToExcel(String(filename), True);
end;

function TReportManX.Get_DefaultPrinter: WideString;
begin
  Result := '';
  if Printer.PrinterIndex > 0 then
    Result := WideString(Printer.Printers[Printer.PrinterIndex]);
end;

procedure TReportManX.Set_DefaultPrinter(const Value: WideString);
var
  adevice, printerlist: string;
  i, itemindex: Integer;
begin
  adevice := UpperCase(String(Value));
  itemindex := -1;
  printerlist := '';
  for i := 0 to Printer.Printers.Count - 1 do
  begin
    if UpperCase(Printer.Printers[i]) = adevice then
    begin
      itemindex := i;
      Break;
    end;
    printerlist := printerlist + Printer.Printers[i] + #10;
  end;
  if itemindex < 0 then
    raise Exception.Create(SRpErrorOpenImp + ':' + String(Value) + #10 + printerlist);
  Printer.PrinterIndex := itemindex;
end;

function TReportManX.Get_PrintersAvailable: WideString;
var
  i: Integer;
  alist: string;
begin
  alist := '';
  for i := 0 to Printer.Printers.Count - 1 do
  begin
    if i > 0 then
      alist := alist + #10;
    alist := alist + Printer.Printers[i];
  end;
  Result := WideString(alist);
end;

procedure TReportManX.GetRemoteParams(hostname: WideString; port: Integer;
  user: WideString; password: WideString; aliasname: WideString;
  reportname: WideString);
begin
  FReport.GetRemoteParams(hostname, port, user, password, aliasname, reportname);
end;

procedure TReportManX.SaveToCSV2(filename: WideString; separator: WideString);
begin
  FReport.SaveToCSV(String(filename), String(separator));
end;

function TReportManX.Get_AsyncExecution: WordBool;
begin
  Result := FReport.AsyncExecution;
end;

procedure TReportManX.Set_AsyncExecution(const Value: WordBool);
begin
  FReport.AsyncExecution := Value;
end;

procedure TReportManX.SaveToHTMLSingle(filename: WideString);
begin
  ExportReportToHtmlSingle(FReport.Report, String(filename));
end;

procedure TReportManX.SaveToFile(filename: WideString);
begin
  FReport.Report.SaveToFile(String(filename));
end;

procedure TReportManX.AddEmbeddedFile(filename: WideString; mimeType: WideString;
  base64Stream: WideString; description: WideString;
  AFRelationShip: TxAFRelationShip; ISOCreationDate: WideString;
  ISOModificationDate: WideString);
begin
  FReport.AddEmbeddedFile(String(filename), String(mimeType),
    String(base64Stream), String(description),
    TPDFAFRelationShip(AFRelationShip), String(ISOCreationDate),
    String(ISOModificationDate));
end;

procedure TReportManX.AddMetadata(Title: WideString; author: WideString;
  subject: WideString; creator: WideString; producer: WideString;
  keywords: WideString; creationDate: WideString; modificationDate: WideString);
begin
  FReport.AddMetadata(Title, author, subject, creator, producer, keywords,
    creationDate, modificationDate);
end;

procedure TReportManX.AddXMPMetadata(XMPContent: WideString);
begin
  FReport.AddXMPMetadata(XMPContent);
end;

procedure TReportManX.SetPDFConformance(PDFConformance: TxPDFConformanceType);
begin
  if PDFConformance <> PDF_Default then
    FReport.Report.PDFConformance := TPDFConformanceType(Integer(PDFConformance) - 1);
end;

function TReportManX.Get_DebugMode: WordBool;
begin
  Result := FDebugMode;
end;

procedure TReportManX.Set_DebugMode(const Value: WordBool);
begin
  FDebugMode := Value;
end;

procedure TReportManX.ShowVersion;
begin
  ShowMessage(RM_VERSION + #10 + 'DPI: ' + IntToStr(Screen.PixelsPerInch));
end;

initialization
  TAutoObjectFactory.Create(ComServer, TReportManX, CLASS_ReportManX,
    ciMultiInstance, tmSingle);
  TAutoObjectFactory.Create(ComServer, TReportReport, CLASS_ReportReport,
    ciInternal, tmSingle);
  TAutoObjectFactory.Create(ComServer, TReportParameters, CLASS_ReportParameters,
    ciInternal, tmSingle);
  TAutoObjectFactory.Create(ComServer, TReportParam, CLASS_ReportParam,
    ciInternal, tmSingle);
end.
