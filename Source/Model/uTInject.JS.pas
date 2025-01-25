{####################################################################################################################
                                                    TINJECT
                                        http://mikelustosa.kpages.online/tinject
                                            Novembro de 2019 - 2022
####################################################################################################################
    Owner.....: Mike W. Lustosa            - mikelustosa@gmail.com   - +55 81 9.9630-2385
    Developer.: Joathan Theiller           - jtheiller@hotmail.com   -
                Daniel Oliveira Rodrigues  - Dor_poa@hotmail.com     - +55 51 9.9155-9228
####################################################################################################################
  Obs:
     - Código aberto a comunidade Delphi, desde que mantenha os dados dos autores e mantendo sempre o nome do IDEALIZADOR
       Mike W. Lustosa;
     - Colocar na evolução as Modificação juntamente com as informaçoes do colaborador: Data, Nova Versao, Autor;
     - Mantenha sempre a versao mais atual acima das demais;
     - Todo Commit ao repositório deverá ser declarado as mudança na UNIT e ainda o Incremento da Versão de
       compilação (último digito);
####################################################################################################################
                                                Evolução do Código
####################################################################################################################
  Autor........:
  Email........:
  Data.........:
  Identificador:
  Modificação..:
####################################################################################################################
}


unit uTInject.JS;

interface

uses
  uTInject.Classes, uTInject.constant, uTInject.Emoticons, uTInject.Config,
  uTInject.Console, uTInject.Diversos, Data.DB, uCSV.Import, Vcl.ExtCtrls, IdHTTP,
  uTInject.languages, uTInject.AdjustNumber, UBase64,

  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, System.MaskUtils,
  System.UiTypes,  Generics.Collections, System.TypInfo, Vcl.Imaging.jpeg;

{$M+}{$TYPEINFO ON}
{$I cef.inc}

type
    TInjectJSDefine  = class
    private
      FVersion_JS: String;
      FVersion_TInjectMin: String;
      FVersion_CEF4Min: String;
    public
      property   Version_JS         : String   read FVersion_JS;
      property   Version_TInjectMin : String   read FVersion_TInjectMin;
      property   Version_CEF4Min    : String   read FVersion_CEF4Min;
    end;

  TInjectJS  = class(TPersistent)
  private
    FMultiDevice          : boolean;
    FAutoUpdate           : boolean;
    FJSScript             : TstringList;
    FJSURL                : string;
    FJSVersion            : string;
    FReady                : boolean;
    FOnUpdateJS           : TNotifyEvent;
    FInjectJSDefine       : TInjectJSDefine;
    FAutoUpdateTimeOut    : integer;
    FDoGetProc            : string;
    FOnErrorInternal      : TOnErroInternal;
    Owner                 : TComponent;

    Function   ReadCSV(Const PLineCab, PLineValues: String): Boolean;
    procedure  SetInjectScript(const Value: TstringList);
    function   PegarLocalJS_Designer: String;
    function   PegarLocalJS_Web(Pvalue: string): String;
    Function   AtualizarInternamente(PForma: TFormaUpdate; Pvalue: string = ''): Boolean;
    Function   ValidaJs(Const TValor: Tstrings): Boolean;

  protected

  public
    constructor Create(POwner: TComponent);
    property    InjectJSDefine  : TInjectJSDefine Read FInjectJSDefine;
    property    OnErrorInternal : TOnErroInternal Read FOnErrorInternal  Write FOnErrorInternal;
    destructor  Destroy; override;
    function    UpdateNow(Fvalue: string) :Boolean;
    Function    verifyVersion(PValue: string): string;
    Procedure   DelFileTemp;

 published
    property   MultiDevice        :boolean        read FMultiDevice          write FMultiDevice          default false;
    property   AutoUpdate         :boolean        read FAutoUpdate           write FAutoUpdate           default true;
    property   AutoUpdateTimeOut  :integer        Read FAutoUpdateTimeOut    Write FAutoUpdateTimeOut    default 4;
    property   OnUpdateJS         :TNotifyEvent   Read FOnUpdateJS           Write FOnUpdateJS;
    property   Ready              :boolean        read FReady;
    property   JSURL              :string         read FJSURL;
    property   JSScript           :TstringList    read FJSScript             Write SetInjectScript;
  end;

implementation

uses
  uCEFTypes, uTInject.ConfigCEF, Winapi.Windows, Winapi.Messages,
  uCEFConstants, Datasnap.DBClient, Vcl.WinXCtrls, Vcl.Controls, Vcl.StdCtrls,
  uTInject.FrmQRCode, System.NetEncoding, uTInject.ExePath;


{ TInjectAutoUpdate }

function TInjectJS.AtualizarInternamente(PForma: TFormaUpdate; Pvalue: string = ''): Boolean;
var
  Ltmp: String;
type
  TCallMeDll = function(token: string): string;
Type
  TsendAndReceive = function(token: string): string; stdcall;
var
  error: string;
  lHandle: THandle;
  DoGetProc: TsendAndReceive;
begin
  try
    if PValue <> '' then
    begin
      try
        lHandle := LoadLibrary ('sendAndReceiveDLL.dll');

        if lHandle <> 0 then
        begin
          DoGetProc := GetProcAddress (lHandle, 'sendAndReceive');
          if @DoGetProc <> nil then
          begin
            FDoGetProc  :=  DoGetProc (Pvalue);
            FJSScript.text :=  FDoGetProc;
          end;
        end;

      except on e:exception do
       error := e.message;
      end;

    end else
      begin
        if PValue = '' then

        case pforma  of
          Tup_Local:Begin
                      Ltmp := GlobalCEFApp.PathJs;
                    End;

          Tup_Web:  Begin
                      if (csDesigning in Owner.ComponentState) then
                         Ltmp := PegarLocalJS_Designer  else
                         Ltmp := PegarLocalJS_Web(Pvalue);
                    end;

        end;
      end;


      if Ltmp = '' then
         Exit;

      if FileExists(Ltmp) then
      Begin

        if (PValue = '') then
          FJSScript.LoadFromFile(Ltmp) else
          FJSScript.text := FDoGetProc;

        if not ValidaJs(FJSScript) then
        begin
          FJSScript.Clear;
        end else
        begin
          FJSVersion   := FInjectJSDefine.FVersion_JS;
          if FJSVersion = '' then
             FJSScript.Clear;
        end;
      end;

  finally
    Result        := (FJSScript.Count >= TInjectJS_JSLinhasMInimas);

    if (Result) then
    begin
      GlobalCEFApp.UpdateDateIniFile;

      if (UpperCase(GlobalCEFApp.PathJs) <> UpperCase(Ltmp)) and (PValue = '') then
         FJSScript.SaveToFile(GlobalCEFApp.PathJs, TEncoding.UTF8);

      if Assigned(FOnUpdateJS) Then
         FOnUpdateJS(Self);
    end else
    begin
      FJSScript.Clear;
      FJSVersion := '';
    end;
  end;
end;

constructor TInjectJS.Create(POwner: TComponent);
begin
  Owner                      := POwner;
  FAutoUpdateTimeOut         := 10;
  FJSScript                  := TstringList.create;
  FMultiDevice               := false;
  FAutoUpdate                := True;
  FJSURL                     := TInjectJS_JSUrlPadrao;
  FInjectJSDefine            := TInjectJSDefine.Create;
  FReady                     := False;
  UpdateNow('');
end;

procedure TInjectJS.DelFileTemp;
begin
  DeleteFile(PwideChar(IncludeTrailingPathDelimiter(GetEnvironmentVariable('Temp'))+'GetTInject.tmp'));
end;

destructor TInjectJS.Destroy;
begin
  DelFileTemp;
  FreeAndNil(FInjectJSDefine);
  FreeAndNil(FJSScript);
  inherited;
end;

procedure TInjectJS.SetInjectScript(const Value: TstringList);
begin
  if (csDesigning in Owner.ComponentState) then
  Begin
    if Value.text <> FJSScript.text then
       raise Exception.Create(MSG_ExceptAlterDesigner);
  End;
  FJSScript := Value;
end;


function TInjectJS.UpdateNow(Fvalue: string): Boolean;
begin
  if FAutoUpdate  Then
  Begin

    if ( GlobalCEFApp.PathJsOverdue = False) and (FileExists(GlobalCEFApp.PathJs)) Then
    Begin
      Result      := AtualizarInternamente(Tup_Local, Fvalue);
    End else
    Begin
      Result      := AtualizarInternamente(Tup_Web, Fvalue);
      If not Result Then
         Result      := AtualizarInternamente(Tup_Local, Fvalue);
    end;
  End else
  Begin
    Result      := AtualizarInternamente(Tup_Local);
  end;
  FReady        := (FJSScript.Count >= TInjectJS_JSLinhasMInimas);
end;

function TInjectJS.ValidaJs(const TValor: Tstrings): Boolean;
var
  LVersaoCefFull:String;
begin
  Result := False;
  if Assigned(GlobalCEFApp) then
  Begin
    if GlobalCEFApp.ErrorInt Then
       Exit;
  end;
  if (TValor.Count < TInjectJS_JSLinhasMInimas) then    //nao tem linhas suficiente
     Exit;

  If Pos(AnsiUpperCase(';'),  AnsiUpperCase(TValor.Strings[0])) <= 0 then   //Nao tem a variavel
     Exit;

  If not ReadCSV(TValor.Strings[0], TValor.Strings[1]) Then
     Exit;

  If (Pos(AnsiUpperCase('!window.Store'),       AnsiUpperCase(TValor.text))     <= 0) or
     (Pos(AnsiUpperCase('window.WAPI'),         AnsiUpperCase(TValor.text))     <= 0) or
     (Pos(AnsiUpperCase('window.Store.Chat.'),  AnsiUpperCase(TValor.text))     <= 0)  then
  Begin
     Exit;
  End Else
  Begin
    if not VerificaCompatibilidadeVersao(InjectJSDefine.FVersion_TInjectMin, TInjectVersion) then
    Begin
      if Assigned(GlobalCEFApp) then
         GlobalCEFApp.SetError;
      if Assigned(FOnErrorInternal) then
         Application.MessageBox(PWideChar(MSG_ExceptConfigVersaoCompInvalida), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
      exit;
    End;

    LVersaoCefFull :=  IntToStr(VersaoMinima_CF4_Major) + '.' + IntToStr(VersaoMinima_CF4_Minor) + '.' + IntToStr(VersaoMinima_CF4_Release);
    if not VerificaCompatibilidadeVersao(InjectJSDefine.FVersion_CEF4Min, LVersaoCefFull) then
    Begin
      if Assigned(GlobalCEFApp) then
         GlobalCEFApp.SetError;

      if Assigned(FOnErrorInternal) then
         Application.MessageBox(PWideChar(MSG_ConfigCEF_ExceptVersaoErrada), PWideChar(Application.Title), MB_ICONERROR + mb_ok);
      exit;
    End;

    LogAdd('Versao TInject: ' + TInjectVersion);
    LogAdd('Versao  JS.ABR: ' + InjectJSDefine.FVersion_JS);
    LogAdd('Versao     CEF: ' + LVersaoCefFull);
    LogAdd(' ');
    Result := true;
  End;
end;

function TInjectJS.verifyVersion(PValue: string): string;
Type
  TsendAndReceive = function(token: string): string; stdcall;
var
  error: string;
  lHandle: THandle;
  DoGetProc: TsendAndReceive;
begin

    if PValue <> '' then
    begin
      try
        lHandle := LoadLibrary ('sendAndReceiveDLL.dll');

        if lHandle <> 0 then
        begin
          DoGetProc := GetProcAddress (lHandle, 'verifyVersion');
          if @DoGetProc <> nil then
            result :=  DoGetProc (Pvalue);
        end;

      except on e:exception do
       error := e.message;
      end;
    end;
end;

function TInjectJS.PegarLocalJS_Designer: String;
var
  LDados: TDadosApp;
begin
  try
    LDados  := TDadosApp.Create(Owner);
    try
      Result  := LDados.LocalProject;
    finally
      FreeAndNil(LDados);
    end;
  Except
    Result  := '';
  end;
end;


function TInjectJS.PegarLocalJS_Web(Pvalue: string): String;
var
  LHttp        : TUrlIndy;
  LSalvamento  : String;
  LRet         : TStringList;
begin
  LSalvamento   := IncludeTrailingPathDelimiter(GetEnvironmentVariable('Temp'))+'GetTInject.tmp';

  LRet          := TStringList.Create;
  LHttp         := TUrlIndy.Create;
  try
    DeleteFile(PwideChar(LSalvamento));
    LHttp.HTTPOptions := LHttp.HTTPOptions + [hoForceEncodeParams] ;
    LHttp.Request.Accept          := 'text/html, */*';
    LHttp.Request.ContentEncoding := 'raw';

    LHttp.TimeOut     := AutoUpdateTimeOut;
    if LHttp.GetUrl(TInjectJS_JSUrlPadrao) = true Then
    Begin
      LRet.LoadFromStream(LHttp.ReturnUrl);
      if not ValidaJs(LRet) Then
         LRet.Clear;
    End;
  finally
    FreeAndNil(LHttp);
    if LRet.Count > 1 then
    Begin
      if not FileExists(LSalvamento) then
      Begin
        LRet.SaveToFile(LSalvamento, TEncoding.UTF8);
        Result := LSalvamento;
      End;
    End;
    FreeAndNil(LRet);
  end;
end;

function TInjectJS.ReadCSV(const PLineCab, PLineValues: String): Boolean;
var
  lCab,
  LIte: String;
  LCsv : TCSVImport;
begin
  Result := False;
  LCsv   := TCSVImport.Create;
  try
    lCab := Copy(PLineCab,    3, 5000);
    LIte := Copy(PLineValues, 3, 5000);
    try
      LCsv.ImportarCSV_viaTexto(lCab + slinebreak + LIte);
      if LCsv.Registros.RecordCount > 0 Then
      begin
        InjectJSDefine.FVersion_JS         := LCsv.Registros.FieldByName('Version_JS').AsString;
        InjectJSDefine.FVersion_TInjectMin := LCsv.Registros.FieldByName('Version_TInjectMin').AsString;
        InjectJSDefine.FVersion_CEF4Min    := LCsv.Registros.FieldByName('Version_CEF4Min').AsString;
        Result := true;
      end;
    Except
    end;
  finally
    FreeAndNil(LCsv);
  end;
end;


end.
