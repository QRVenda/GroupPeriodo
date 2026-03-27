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

unit FPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.DBCtrls,  Vcl.ComCtrls, DateUtils, GroupPeriodo;

type
  TForm5 = class(TForm)
    GroupPeriodo1: TGroupPeriodo;
    Button1: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GroupPeriodo1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
begin
  GroupPeriodo1.Datas.RedefinirTodoPeriodo(IncYear(Today, -1), IncYear(Today, 1));
end;

procedure TForm5.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    Close;
end;

procedure TForm5.GroupPeriodo1Change(Sender: TObject);
begin
  ShowMessage('teste');
end;

end.
