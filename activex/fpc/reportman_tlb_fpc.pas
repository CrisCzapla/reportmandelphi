unit reportman_tlb_fpc;

{ Free Pascal declarations of the Report Manager type library
  (activex\reportman.tlb, library "reportman" 2.1), for the Lazarus build of
  Reportman.ocx.

  Generated with "importtl -n reportman.tlb" (FPC 3.2.2) and reduced to the
  interfaces the Lazarus server implements: ReportManX, ReportReport,
  ReportParameters and ReportParam. The method order of each interface is the
  vtable of the type library: do not reorder. Regenerate it if reportman.ridl
  changes. }

{$mode delphi}{$H+}

interface

uses
  Windows, ActiveX, Variants;

Const
  reportmanMajorVersion = 2;
  reportmanMinorVersion = 1;
  reportmanLCID = 0;
  LIBID_reportman : TGUID = '{D4D26F6B-6564-44F4-A913-03C91CE37740}';

  IID_IReportManX : TGUID = '{B3AE1470-158D-4855-83DB-BC3A2746C26E}';
  IID_IReportManXEvents : TGUID = '{50909EA4-8F4F-4865-877D-287FC7072177}';
  CLASS_ReportManX : TGUID = '{DC30E149-4129-450F-BDFE-BD9E6F31147E}';
  IID_IReportReport : TGUID = '{2FCB34BE-8DD4-4567-A771-9965C2FD3A04}';
  CLASS_ReportReport : TGUID = '{E30FD4FC-F47A-4932-A3E6-6694550588F3}';
  IID_IReportParameters : TGUID = '{A5F6E90E-DFE7-49DA-AA38-C1A41C995B6B}';
  CLASS_ReportParameters : TGUID = '{F79CF82C-C2AD-46CC-ABEA-084016CFE58A}';
  IID_IReportParam : TGUID = '{F1634F9E-DE5A-411E-9A9E-3A46707A7ABB}';
  CLASS_ReportParam : TGUID = '{E96B253E-143E-40E8-BFDA-366C5F112DAE}';
  IID_IReportmanXAServer : TGUID = '{F3A6B88C-D629-402E-BC62-BAB0E2EE39AF}';
  CLASS_ReportmanXAServer : TGUID = '{FD3BE5E5-CBE4-4C29-A733-8CB842999075}';
  IID_IPreviewControl : TGUID = '{3D8043B8-E2F6-4F5D-B055-571924F5B0DC}';
  IID_IPreviewControlEvents : TGUID = '{7364E2EA-8EEC-4673-9059-3B078C388717}';
  CLASS_PreviewControl : TGUID = '{45978803-4B15-4E0E-98CE-AED9B1E1B701}';

//Enums

Type
  TxHelpType =LongWord;
Const
  htKeyword = $0000000000000000;
  htContext = $0000000000000001;
Type
  TxParamType =LongWord;
Const
  rpParamString = $0000000000000000;
  rpParamInteger = $0000000000000001;
  rpParamDouble = $0000000000000002;
  rpParamDate = $0000000000000003;
  rpParamTime = $0000000000000004;
  rpParamDateTime = $0000000000000005;
  rpParamCurrency = $0000000000000006;
  rpParamBool = $0000000000000007;
  rpParamExpreB = $0000000000000008;
  rpParamExpreA = $0000000000000009;
  rpParamSubst = $000000000000000A;
  rpParamList = $000000000000000B;
  rpParamUnknown = $000000000000000C;
Type
  TxAutoScaleType =LongWord;
Const
  AScaleReal = $0000000000000000;
  AScaleWide = $0000000000000001;
  AScaleHeight = $0000000000000002;
  AScaleEntirePage = $0000000000000003;
  AScaleCustom = $0000000000000004;
Type
  TxBorderStyle =LongWord;
Const
  bsNone = $0000000000000000;
  bsSingle = $0000000000000001;
Type
  TxDragMode =LongWord;
Const
  dmManual = $0000000000000000;
  dmAutomatic = $0000000000000001;
Type
  TxMouseButton =LongWord;
Const
  mbLeft = $0000000000000000;
  mbRight = $0000000000000001;
  mbMiddle = $0000000000000002;
Type
  TxActiveFormBorderStyle =LongWord;
Const
  afbNone = $0000000000000000;
  afbSingle = $0000000000000001;
  afbSunken = $0000000000000002;
  afbRaised = $0000000000000003;
Type
  TxPrintScale =LongWord;
Const
  poNone = $0000000000000000;
  poProportional = $0000000000000001;
  poPrintToFit = $0000000000000002;
Type
  TxPDFConformanceType =LongWord;
Const
  PDF_1_4 = $0000000000000001;
  PDF_A_3 = $0000000000000002;
  PDF_Default = $0000000000000000;
Type
  TxAFRelationShip =LongWord;
Const
  AFUnspecified = $0000000000000000;
  AFAlternative = $0000000000000001;
  AFData = $0000000000000002;
  AFSource = $0000000000000003;
  AFSupplement = $0000000000000004;
//Forward declarations

Type
 IReportManX = interface;
 IReportReport = interface;
 IReportParameters = interface;
 IReportParam = interface;
 ReportManX = IReportManX;
 ReportReport = IReportReport;
 ReportParameters = IReportParameters;
 ReportParam = IReportParam;

 IReportManX = interface(IDispatch)
   ['{B3AE1470-158D-4855-83DB-BC3A2746C26E}']
    // SetDatasetSQL :  
   procedure SetDatasetSQL(datasetname:WideString;sqlsentence:WideString);safecall;
    // SetDatabaseConnectionString :  
   procedure SetDatabaseConnectionString(databasename:WideString;connectionstring:WideString);safecall;
    // GetDatasetSQL :  
   function GetDatasetSQL(datasetname:WideString):WideString;safecall;
    // GetDatabaseConnectionString :  
   function GetDatabaseConnectionString(databasename:WideString):WideString;safecall;
    // SetParamValue :  
   procedure SetParamValue(paramname:WideString;paramvalue:OleVariant);safecall;
    // GetParamValue :  
   function GetParamValue(paramname:WideString):OleVariant;safecall;
    // Execute :  
   function Execute:WordBool;safecall;
    // PrinterSetup :  
   procedure PrinterSetup;safecall;
    // ShowParams :  
   function ShowParams:WordBool;safecall;
    // SaveToPDF :  
   procedure SaveToPDF(filename:WideString;compressed:WordBool);safecall;
    // PrintRange :  
   function PrintRange(frompage:Integer;topage:Integer;copies:Integer;collate:WordBool):WordBool;safecall;
   function Get_filename : WideString; safecall;
   procedure Set_filename(const Value:WideString); safecall;
   function Get_Preview : WordBool; safecall;
   procedure Set_Preview(const Value:WordBool); safecall;
   function Get_ShowProgress : WordBool; safecall;
   procedure Set_ShowProgress(const Value:WordBool); safecall;
   function Get_ShowPrintDialog : WordBool; safecall;
   procedure Set_ShowPrintDialog(const Value:WordBool); safecall;
   function Get_Title : WideString; safecall;
   procedure Set_Title(const Value:WideString); safecall;
   function Get_Language : Integer; safecall;
   procedure Set_Language(const Value:Integer); safecall;
   function Get_DoubleBuffered : WordBool; safecall;
   procedure Set_DoubleBuffered(const Value:WordBool); safecall;
   function Get_AlignDisabled : WordBool; safecall;
   function Get_VisibleDockClientCount : Integer; safecall;
    // DrawTextBiDiModeFlagsReadingOnly :  
   function DrawTextBiDiModeFlagsReadingOnly:Integer;safecall;
   function Get_Enabled : WordBool; safecall;
   procedure Set_Enabled(const Value:WordBool); safecall;
    // InitiateAction :  
   procedure InitiateAction;safecall;
    // IsRightToLeft :  
   function IsRightToLeft:WordBool;safecall;
    // UseRightToLeftReading :  
   function UseRightToLeftReading:WordBool;safecall;
    // UseRightToLeftScrollBar :  
   function UseRightToLeftScrollBar:WordBool;safecall;
   function Get_Visible : WordBool; safecall;
   procedure Set_Visible(const Value:WordBool); safecall;
   function Get_Cursor : Smallint; safecall;
   procedure Set_Cursor(const Value:Smallint); safecall;
   function Get_HelpType : TxHelpType; safecall;
   procedure Set_HelpType(const Value:TxHelpType); safecall;
   function Get_HelpKeyword : WideString; safecall;
   procedure Set_HelpKeyword(const Value:WideString); safecall;
    // SetSubComponent :  
   procedure SetSubComponent(IsSubComponent:WordBool);safecall;
    // AboutBox :  
   procedure AboutBox;safecall;
    // ExecuteRemote :  
   procedure ExecuteRemote(hostname:WideString;port:Integer;user:WideString;password:WideString;aliasname:WideString;reportname:WideString);safecall;
    // CalcReport :  
   procedure CalcReport(ShowProgress:WordBool);safecall;
    // Compose :  
   procedure Compose(Report:ReportReport;Execute:WordBool);safecall;
    // SaveToText :  
   procedure SaveToText(filename:WideString;textdriver:WideString);safecall;
   function Get_Report : ReportReport; safecall;
    // SaveToExcel :  
   procedure SaveToExcel(filename:WideString);safecall;
    // SaveToHTML :  
   procedure SaveToHTML(filename:WideString);safecall;
    // SetRecordSet :  
   procedure SetRecordSet(datasetname:WideString;Value:IDispatch);safecall;
    // SaveToCustomText :  
   procedure SaveToCustomText(filename:WideString);safecall;
    // SaveToCSV :  
   procedure SaveToCSV(filename:WideString);safecall;
    // SaveToSVG :  
   procedure SaveToSVG(filename:WideString);safecall;
    // SaveToMetafile :  
   procedure SaveToMetafile(filename:WideString);safecall;
    // SaveToExcel2 :  
   procedure SaveToExcel2(filename:WideString);safecall;
   function Get_DefaultPrinter : WideString; safecall;
   procedure Set_DefaultPrinter(const Value:WideString); safecall;
   function Get_PrintersAvailable : WideString; safecall;
    // GetRemoteParams :  
   procedure GetRemoteParams(hostname:WideString;port:Integer;user:WideString;password:WideString;aliasname:WideString;reportname:WideString);safecall;
    // SaveToCSV2 :  
   procedure SaveToCSV2(filename:WideString;separator:WideString);safecall;
   function Get_AsyncExecution : WordBool; safecall;
   procedure Set_AsyncExecution(const Value:WordBool); safecall;
    // SaveToHTMLSingle :  
   procedure SaveToHTMLSingle(filename:WideString);safecall;
    // SaveToFile :  
   procedure SaveToFile(filename:WideString);safecall;
    // AddEmbeddedFile :  
   procedure AddEmbeddedFile(filename:WideString;mimeType:WideString;base64Stream:WideString;description:WideString;AFRelationShip:TxAFRelationShip;ISOCreationDate:WideString;ISOModificationDate:WideString);safecall;
    // AddMetadata :  
   procedure AddMetadata(Title:WideString;author:WideString;subject:WideString;creator:WideString;producer:WideString;keywords:WideString;creationDate:WideString;modificationDate:WideString);safecall;
    // AddXMPMetadata :  
   procedure AddXMPMetadata(XMPContent:WideString);safecall;
    // SetPDFConformance :  
   procedure SetPDFConformance(PDFConformance:TxPDFConformanceType);safecall;
   function Get_DebugMode : WordBool; safecall;
   procedure Set_DebugMode(const Value:WordBool); safecall;
    // ShowVersion :  
   procedure ShowVersion;safecall;
    // filename :  
   property filename:WideString read Get_filename write Set_filename;
    // Preview :  
   property Preview:WordBool read Get_Preview write Set_Preview;
    // ShowProgress :  
   property ShowProgress:WordBool read Get_ShowProgress write Set_ShowProgress;
    // ShowPrintDialog :  
   property ShowPrintDialog:WordBool read Get_ShowPrintDialog write Set_ShowPrintDialog;
    // Title :  
   property Title:WideString read Get_Title write Set_Title;
    // Language :  
   property Language:Integer read Get_Language write Set_Language;
    // DoubleBuffered :  
   property DoubleBuffered:WordBool read Get_DoubleBuffered write Set_DoubleBuffered;
    // AlignDisabled :  
   property AlignDisabled:WordBool read Get_AlignDisabled;
    // VisibleDockClientCount :  
   property VisibleDockClientCount:Integer read Get_VisibleDockClientCount;
    // Enabled :  
   property Enabled:WordBool read Get_Enabled write Set_Enabled;
    // Visible :  
   property Visible:WordBool read Get_Visible write Set_Visible;
    // Cursor :  
   property Cursor:Smallint read Get_Cursor write Set_Cursor;
    // HelpType :  
   property HelpType:TxHelpType read Get_HelpType write Set_HelpType;
    // HelpKeyword :  
   property HelpKeyword:WideString read Get_HelpKeyword write Set_HelpKeyword;
    // Report :  
   property Report:ReportReport read Get_Report;
    // DefaultPrinter :  
   property DefaultPrinter:WideString read Get_DefaultPrinter write Set_DefaultPrinter;
    // PrintersAvailable :  
   property PrintersAvailable:WideString read Get_PrintersAvailable;
    // AsyncExecution :  
   property AsyncExecution:WordBool read Get_AsyncExecution write Set_AsyncExecution;
    // DebugMode :  
   property DebugMode:WordBool read Get_DebugMode write Set_DebugMode;
  end;

 IReportReport = interface(IDispatch)
   ['{2FCB34BE-8DD4-4567-A771-9965C2FD3A04}']
   function Get_Params : ReportParameters; safecall;
   function Get_VCLReport : PWideChar; safecall;
    // AddColumn :  
   procedure AddColumn(Width:Integer;Expression:WideString;ExpFormat:WideString;Caption:WideString;CaptionFormat:WideString;SumaryExpression:WideString;SumaryFormat:WideString);safecall;
   function Get_AutoResizeColumns : WordBool; safecall;
   procedure Set_AutoResizeColumns(const Value:WordBool); safecall;
    // SaveToFile :  
   procedure SaveToFile(filename:WideString);safecall;
    // Params :  
   property Params:ReportParameters read Get_Params;
    // VCLReport :  
   property VCLReport:PWideChar read Get_VCLReport;
    // AutoResizeColumns :  
   property AutoResizeColumns:WordBool read Get_AutoResizeColumns write Set_AutoResizeColumns;
  end;

 IReportParameters = interface(IDispatch)
   ['{A5F6E90E-DFE7-49DA-AA38-C1A41C995B6B}']
   function Get_Count : Integer; safecall;
   function Get_Items(Index:Integer) : ReportParam; safecall;
    // ParamExists :  
   function ParamExists(paramname:WideString):WordBool;safecall;
    // Count :  
   property Count:Integer read Get_Count;
    // Items :  
   property Items[Index:Integer]:ReportParam read Get_Items;
  end;

 IReportParam = interface(IDispatch)
   ['{F1634F9E-DE5A-411E-9A9E-3A46707A7ABB}']
   function Get_Name : WideString; safecall;
   procedure Set_Name(const Value:WideString); safecall;
   function Get_description : WideString; safecall;
   procedure Set_description(const Value:WideString); safecall;
   function Get_Visible : WordBool; safecall;
   procedure Set_Visible(const Value:WordBool); safecall;
   function Get_ParamType : TxParamType; safecall;
   procedure Set_ParamType(const Value:TxParamType); safecall;
   function Get_Value : OleVariant; safecall;
   procedure Set_Value(const Value:OleVariant); safecall;
    // Name : Parameter name 
   property Name:WideString read Get_Name write Set_Name;
    // description : Parameter description 
   property description:WideString read Get_description write Set_description;
    // Visible : Visible to the end user 
   property Visible:WordBool read Get_Visible write Set_Visible;
    // ParamType : Parameter type 
   property ParamType:TxParamType read Get_ParamType write Set_ParamType;
    // Value : Parameter value 
   property Value:OleVariant read Get_Value write Set_Value;
  end;

implementation

end.
