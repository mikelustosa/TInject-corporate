﻿{####################################################################################################################
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


unit uTInject.AdjustNumber;

interface

uses
  System.Classes, uTInject.Classes, System.MaskUtils, uTInject.Diversos;


{$M+}{$TYPEINFO ON}
type
  TInjectAdjusteNumber  = class(TPersistent)
  private
    FLastAdjustDt: TDateTime;
    FLastAdjuste: String;
    FLastDDI: String;
    FLastDDD: String;
    FLastNumber: String;

    FAutoAdjust: Boolean;
    FDDIDefault: Integer;
    FLengthDDI: integer;
    FLengthDDD: Integer;
    FLengthPhone: Integer;
    FLastNumberFormat: String;
    FLastType: TTypeNumber;
    FAllowOneDigit: Boolean;
    Owner: TComponent;
    Procedure SetPhone(Const Pnumero:String);
  public
    constructor Create(AOwner: TComponent);

    Function  FormatIn(PNum:String): String;
    Function  FormatOut(PNum:String): String;

    property  LastType    : TTypeNumber     Read FLastType;
    property  LastAdjuste : String          Read FLastAdjuste;
    property  LastDDI     : String          Read FLastDDI;
    property  LastDDD     : String          Read FLastDDD;
    property  LastNumber  : String          Read FLastNumber;
    property  LastNumberFormat: String      Read FLastNumberFormat;
    property  LastAdjustDt: TDateTime       Read FLastAdjustDt;
  published
    property AutoAdjust : Boolean           read FAutoAdjust    write FAutoAdjust    default True;
    property LengthDDI  : Integer           read FLengthDDI     write FLengthDDI     default 2;
    property LengthDDD  : Integer           read FLengthDDD     write FLengthDDD     default 2;
    property LengthPhone: Integer           read FLengthPhone   write FLengthPhone   default 9;
    property AllowOneDigitMore: Boolean         read FAllowOneDigit write FAllowOneDigit default True;

    property DDIDefault : Integer           read FDDIDefault   write FDDIDefault  Default 2;
    end;


implementation

uses
  System.SysUtils, uTInject.Constant;

{ TAdjustNumber }


function TInjectAdjusteNumber.FormatIn(PNum: String): String;
var
  LClearNum: String;
  LInc:Integer;
begin
  if FAllowOneDigit then
     LInc := 1 else
     LInc := 0;
  Result := Pnum;
  try
    if not AutoAdjust then
       Exit;

    //Garante valores LIMPOS (sem mascaras, letras, etc) apenas NUMEROS
    Result := PNum;
    LClearNum := TrazApenasNumeros(pnum);

    if Length(LClearNum) < (LengthDDD + LengthPhone + LInc) then
    Begin
      if Length(LClearNum) < (LengthDDD + LengthPhone) then
      Begin
        Result := '';
        Exit;
      End;
    End;

    //Testa se é um grupo ou Lista Transmissao
    if Length(LClearNum) <=  (LengthDDI + LengthDDD + LengthPhone + 1 + LInc) Then //14 then
    begin
      if (Length(LClearNum) <= (LengthDDD + LengthPhone+ LInc)) or (Length(PNum) <= (LengthDDD + LengthPhone+ LInc)) then
      begin
        if Copy(LClearNum, 0, LengthDDI) <> DDIDefault.ToString then
           LClearNum := DDIDefault.ToString + LClearNum;
        Result := LClearNum +  CardContact;
      end;
    end;
  finally
    if Result = '' then
       raise Exception.Create(MSG_ExceptPhoneNumberError);
    SetPhone(Result);
  end;
end;


function TInjectAdjusteNumber.FormatOut(PNum: String): String;
var
  LDDi, LDDD, Lresto, LMask : String;
begin
 LDDi   := Copy(PNum, 0, FLengthDDI);
 LDDD   := Copy(PNum, FLengthDDI + 1, FLengthDDD);
 Lresto := Copy(PNum, FLengthDDI + FLengthDDD + 1); // + 1, LengthPhone);
 if Length(Lresto) <= 8 then
    LMask := '0000\-0000;0;' else
    LMask := '0\.0000\-0000;0;';

 Result :=  '+' + LDDi + ' (' + LDDD + ') ' + FormatMaskText(LMask, Lresto );
end;

procedure TInjectAdjusteNumber.SetPhone(const Pnumero: String);
begin
  FLastType         := TypUndefined;
  FLastDDI          := '';
  FLastDDD          := '';
  FLastNumber       := '';
  FLastNumberFormat := '';
  FLastAdjustDt     := Now;
  FLastAdjuste      := Pnumero;
  FLastNumberFormat := Pnumero;
  if pos(CardGroup, Pnumero) > 0 then
  begin
    FLastType := TypGroup;
  end else
  Begin
    if Length(Pnumero) = (LengthDDI + LengthDDD + LengthPhone + Length(CardContact)) then
    Begin
      FLastType := TypContact;
    end;
  end;

  if FLastType = TypContact then
  Begin
    FLastDDI          := Copy(Pnumero, 0,           LengthDDI);
    FLastDDD          := Copy(Pnumero, LengthDDI+1, LengthDDD);
    FLastNumber       := Copy(Pnumero, LengthDDI+LengthDDD+1, LengthPhone);
    FLastNumberFormat := FormatOut(FLastNumber);
  End;
end;

constructor TInjectAdjusteNumber.Create(AOwner: TComponent);
begin
  Owner          := Aowner;
  FLastAdjuste   := '';
  FLastDDI       := '';
  FLastDDD       := '';
  FLastNumber    := '';
  FAllowOneDigit := true;
  FAutoAdjust    := True;
  FDDIDefault    := 55;
  FLengthDDI     := 2;
  FLengthDDD     := 2;
  FLengthPhone   := 8;
end;

end.
