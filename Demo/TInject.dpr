program TInject;

uses
  Vcl.Forms,
  midasLib,
  Windows,
  uTInject.ConfigCEF,
  u_principal in 'u_principal.pas' {frmPrincipal};

{$R *.res}

begin
  {##########################################################################################
  Colocar arquivos CEFLib junto a pasta binária da aplicação (Nao definir ou passar vazio)
  Caso deseja informar.. segue exemplo abaixo
  ##########################################################################################}

//  GlobalCEFApp.PathLogFile          := '';
//  GlobalCEFApp.PathFrameworkDirPath := 'C:\Componentes\WhatsApp\Comp\BIN';
//  GlobalCEFApp.PathResourcesDirPath := 'C:\Componentes\WhatsApp\Comp\BIN';
//  GlobalCEFApp.PathLocalesDirPath   := 'C:\Componentes\WhatsApp\Comp\BIN\locales';
//  GlobalCEFApp.Pathcache            := 'C:\Componentes\WhatsApp\Comp\BIN\Cache';
//  GlobalCEFApp.PathUserDataPath     := 'C:\Componentes\WhatsApp\Comp\BIN\User Data';

  //Forma 1 GlobalCEFApp.Pathxx       := '';                      //Irá procura procurar o Arquivo PADRAO no mesmo local do EXE
  //Forma 2 GlobalCEFApp.Pathxx       := 'C:\Componentes\demo\bin'; //<-  NOME do ARQUIVO INFORMADO
  //Forma 3 GlobalCEFApp.Pathxx       := 'BIN';                     //<-  NOME do ARQUIVO INFORMADO
  //Forma 4 GlobalCEFApp.Pathx         := '..\Source\;              //<-  NOME do ARQUIVO INFORMADO
  //Exemplo se aplica para todos os PATH

  GlobalCEFApp.DisableComponentUpdate := true; //Se você desativar a atualização do componente, ainda poderá distribuir os binários Widevine mais recentes com o instalador do aplicativo para reproduzir parte do conteúdo protegido. Widevine é usado para reproduzir conteúdo de mídia protegido com DRM.

  If not GlobalCEFApp.StartMainProcess then
     Exit;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;

end.
