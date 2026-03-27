{---------------------------------------------------------------------------+
|                                                                           |
|  Unit.........: GroupPeriodo.pas                                          |
|  Componente...: "TGroupPeriodo"                                           |
|  Herança......: "TPanel" (nativo do Delphi)                               |
|  Descrição....: Componente para configurar grupos de datas.               |
|                 Útil filtrar dados em tela e para para relatorios.        |
|                                                                           |
|  Data.........: 15/07/2024 - 22:03h                                       |
|  Autoria......: Adriano Zanini                                            |
|                                                                           |
+---------------------------------------------------------------------------}

program Testar;

uses
  Vcl.Forms,
  FPrincipal in 'FPrincipal.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
