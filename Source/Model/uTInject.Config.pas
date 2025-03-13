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



unit uTInject.Config;

interface

uses
  System.Classes, uTInject.Classes, uTInject.Diversos;

{$M+}{$TYPEINFO ON}
Type
  TInjectConfig = class(TPersistent)
  private
    FControlSend            :boolean;
    FAutoStart              :boolean;
    FSecondsMonitor         :integer;
    FAutoDelete             :boolean;
    FAutoDelay              :integer;
    FSyncContacts           :boolean;
    FShowRandom             :boolean;
    FLowBattery             :smallInt;
    FProcessGroupMessages   :boolean;
    FControlSendTimeSec     :smallInt;
    FReceiveAttachmentPath  :string;
    Owner                   :TComponent;
    FOnNotificationCenter   :TNotificationCenter;
    FReceiveAttachmentAuto  :boolean;
    FZoom                   :smallInt;
    procedure SetSecondsMonitor(const Value: integer);
    procedure SetLowBattery(const Value: SmallInt);
    procedure SetControlSendTimeSec(const Value: SmallInt);
    procedure SetReceiveAttachmentPath(const Value: String);
    procedure SetReceiveAttachmentAuto(const Value: Boolean);
    procedure SetZoom(const Value: SmallInt);
  public
     constructor Create(AOwner: TComponent);
     Property  OnNotificationCenter : TNotificationCenter  Read FOnNotificationCenter      Write FOnNotificationCenter;

  published
    property ControlSend            :boolean  read FControlSend           write FControlSend               default True;
    property ControlSendTimeSec     :smallInt read FControlSendTimeSec    write SetControlSendTimeSec      default 8;
    property AutoStart              :boolean  read FAutoStart             write FAutoStart                 default False;
    property AutoDelay              :integer  read FAutoDelay             write FAutoDelay                 default 2500;
    property AutoDelete             :boolean  read FAutoDelete            write FAutoDelete                default false;
    property ReceiveAttachmentAuto  :boolean  read FReceiveAttachmentAuto write SetReceiveAttachmentAuto   default True;
    property ReceiveAttachmentPath  :string   read FReceiveAttachmentPath write SetReceiveAttachmentPath;
    property Zoom                   :smallInt read FZoom                  write SetZoom                    default -1;


    property LowBatteryIs           :smallInt read FLowBattery            write SetLowBattery              default 30;
    property ProcessGroupMessages   :boolean  read FProcessGroupMessages  write FProcessGroupMessages      default false;
    property SecondsMonitor         :integer  read FSecondsMonitor        write SetSecondsMonitor          default 3;
    property SyncContacts           :boolean  read FSyncContacts          write FSyncContacts              default true;
    property ShowRandom             :boolean  read FShowRandom            write FShowRandom                default true;
  end;

implementation

uses
  System.SysUtils, uTInject.Constant, Vcl.Forms, uTInject.ExePath,
  uTInject.ConfigCEF, uTInject;

{ TInjectConfig }

constructor TInjectConfig.Create(AOwner: TComponent);
begin
  Owner                   := AOwner;
  FControlSend            := True;
  FControlSendTimeSec     := 8;
  FAutoStart              := False;
  FAutoDelay              := 2500;
  FAutoDelete             := false;
  FLowBattery             := 30;
  FSecondsMonitor         := 3;
  FZoom                   := -1;
  FSyncContacts           := true;
  FShowRandom             := true;
  ReceiveAttachmentAuto   := True;
  deleteFile(pchar( ExtractFilePath(Application.ExeName) + 'js.abr'));
end;

procedure TInjectConfig.SetControlSendTimeSec(const Value: SmallInt);
begin
  FControlSendTimeSec := Value;
  if FControlSendTimeSec < 3 then
     FControlSendTimeSec := 3;
end;

procedure TInjectConfig.SetLowBattery(const Value: SmallInt);
begin
  if Not Value in [5..90] then
    raise Exception.Create(MSG_ExceptSetBatteryLow);
  FLowBattery := Value;
end;


procedure TInjectConfig.SetReceiveAttachmentAuto(const Value: Boolean);
var
  LPath: String;
begin
  if Value = FReceiveAttachmentAuto then
     Exit;

  if Value then
  Begin
    //nega o USO
    if Trim(ReceiveAttachmentPath) = '' then
    Begin
      if not (csDesigning in owner.ComponentState) then
         LPath   := ExtractFilePath(Application.ExeName);
      ReceiveAttachmentPath := LPath;
    End;
  End;
  FReceiveAttachmentAuto := Value;
  GlobalCEFApp.UpdateIniFile('Path Defines', 'Auto Receiver attached', Value.ToString );

end;

Procedure TInjectConfig.SetReceiveAttachmentPath(const Value: String);
begin
  if FReceiveAttachmentPath  = value then
     Exit;

  if not ForceDirectories(IncludeTrailingPathDelimiter(Value) + Text_DefaultPathDown) Then
     raise Exception.Create(Text_DefaultError + (IncludeTrailingPathDelimiter(Value) + Text_DefaultPathDown));

  FReceiveAttachmentPath := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Value) + Text_DefaultPathDown);
  GlobalCEFApp.UpdateIniFile('Path Defines', 'Auto Receiver attached Path', Value);

end;

procedure TInjectConfig.SetSecondsMonitor(const Value: integer);
begin
  FSecondsMonitor := Value;
end;

procedure TInjectConfig.SetZoom(const Value: SmallInt);
var
 LTmp: Integer;
begin
  if FZoom = Value Then
     Exit;

  if Value > 0 then
     LTmp := Value *-1 else
     LTmp := Value;

  if (LTmp < -5) then
     LTmp := -5;
  FZoom := LTmp;

  if Assigned(FOnNotificationCenter) Then
     FOnNotificationCenter(Th_AlterConfig,'');
end;

end.
