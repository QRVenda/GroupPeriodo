{==============================================================================]
[ Unit           : GroupPeriodo.pas                                            ]
[ Componente     : "TGroupPeriodo"                                             ]
[ Herança        : "TPanel" (nativo do Delphi)                                 ]
[ Escopo         : Componente para configurar grupos de datas.                 ]
[                  Útil para filtrar dados em tela e para relatórios.          ]
[ Criado em      : julho/2024                                                  ]
[ Última mod.    : março/2026                                                  ]
[------------------------------------------------------------------------------]
[ Licença        : Apache License 2.0                                          ]
[ Documentação   : https://www.apache.org/licenses                             ]
[                  Consulte o arquivo LICENSE para mais detalhes               ]
[------------------------------------------------------------------------------]
[ Autor          : Adriano Zanini                                              ]
[ Formação       : Engenharia de Software                                      ]
[ Competências   : Arquitetura de Software / C# / Delphi / PHP / Java          ]
[==============================================================================}

unit GroupPeriodo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.DateUtils, System.StrUtils, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, System.MaskUtils, System.Math;

type

  TGroupPeriodo = class;
  TPosicao      = (tpHorizontal, tpVertical);

//  TIntervalo    = (tpHoje,
//                   tpTodoPeriodo,
//                   tpUltimo30dias,
//                   tpInicioSemana,
//                   tpInicioMes,
//                   tpInicioAno
//                   );

  TIntervalo    = (tpHoje,
                   tpTodoPeriodo,
                   tpProximo30dias,
                   tpUltimo30dias,
                   tpInicioSemana,
                   tpInicioMes,
                   tpInicioAno
                   );

  TDatas = class(TPersistent)
  private
    { Private declarations }
    FOwner              : TGroupPeriodo;
    FLabelCombo         : TLabel;
    FLabelinicial       : TLabel;
    FLabelFinal         : TLabel;
    FPosicao            : TPosicao;
    FComboPeriodo       : TComboBox;
    FEditDataInicial    : TMaskEdit;
    FEditDataFinal      : TMaskEdit;
    FValidarDataFinal   : Boolean;
    FEditMask           : TEditMask;
    FDataInicial        : TDateTime;
    FDataFinal          : TDateTime;

    PeriodoInicial      : TDateTime;
    PeriodoFinal        : TDateTime;

    FTopoInicio         : Integer;

    FTituloPeriodo     : String;
    FTituloInicial     : String;
    FTituloFinal       : String;

    procedure SetAjustarPosicao;
    procedure SetPosicao(const Value: TPosicao);
    procedure SetIntervalo(const Value: TIntervalo);
    procedure SetOwner(const Value: TGroupPeriodo);
    procedure SetTopoInicio(const Value: Integer);
    procedure SetTituloFinal(const Value: String);
    procedure SetTituloInicial(const Value: String);
    procedure SetTituloPeriodo(const Value: String);
  protected
    { Protected declarations }
    FGroupPeriodo : TGroupPeriodo;
    FIntervalo    : TIntervalo;
    function GetOwner: TPersistent; override;
    procedure TrocaTipoPeriodo(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TGroupPeriodo);
    destructor Destroy;
    procedure Assign(Source: TPersistent); override;
    procedure RedefinirTodoPeriodo(aDataInicial: TDateTime = 0; aDataFinal: TDateTime = 0);
    procedure ReiniciaPeriodo();

    property Owner              : TGroupPeriodo    read FOwner             write SetOwner;
  published
    { Published declarations }
    property Posicao            : TPosicao         read FPosicao           write SetPosicao default tpHorizontal;
    property Intervalo          : TIntervalo       read FIntervalo         write SetIntervalo;
    property ValidarDataFinal   : Boolean          read FValidarDataFinal  write FValidarDataFinal;
    property Mascara            : TEditMask        read FEditMask          write FEditMask;
    property TopoInicio         : Integer          read FTopoInicio        write SetTopoInicio;

    property Titulo01_Periodo   : String           read FTituloPeriodo     write SetTituloPeriodo;
    property Titulo02_Inicial   : String           read FTituloInicial     write SetTituloInicial;
    property Titulo03_Final     : String           read FTituloFinal       write SetTituloFinal;

  End;

  //TGroupPeriodo = class(TGroupBox)
  TGroupPeriodo = class(TPanel)
  private
    { Private declarations }
    FDatas       : TDatas;
    FOnChange    : TNotifyEvent;
    procedure SetDatas(const Value: TDatas);
    procedure CriarObjetos;
    procedure PopularComboBox;
    function CompararDataFinal: boolean;
    procedure SetarDatas;
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure LimparCaption;
  protected
    { Protected declarations }
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure DoOnChange;
    procedure FormatarSaida(Sender: TObject);
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;

  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction;  override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    function GetDataInicial: TDateTime;
    function GetDataFinal:   TDateTime;

  published
    { Published declarations }
    Property Datas       : TDatas           read FDatas             write SetDatas;
    property OnChange    : TNotifyEvent     read FOnChange          write SetOnChange;
  end;
  procedure Atencao(const aMensagem: String; aDica: String = '');

Const
  //_LARGURA_AREA_450          = 450;
  _LARGURA_AREA_190          = 190;
  _LARGURA_AREA_360          = 360;
  _LARGURA_COMBO_155         = 155;
  _LARGURA_EDIT_082          = 82;
  _ESPACAMENTO_VERTICAL_3    = 3;
  _LABEL_RECUO_16            = 16;
  _MARGEM_TOPO_35            = 35;
  _MARGEM_ESQUERDA_10        = 10;
  _ESPACAMENTO_HOR_10        = 10;
  _ESPACAMENTO_VER_40        = 40;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TGroupPeriodo]);
end;

{ TDatas }
procedure TDatas.Assign(Source: TPersistent);
var
  DestSearchDialog : TDatas;
begin
  if Source is TDatas then
  begin
    FPosicao           := TDatas(Source).FPosicao;
    FEditDataInicial   := TDatas(Source).FEditDataInicial;
    FEditDataFinal     := TDatas(Source).FEditDataFinal;
    FLabelinicial      := TDatas(Source).FLabelinicial;
    FLabelFinal        := TDatas(Source).FLabelFinal;
  end
  else
    inherited Assign(Source);
end;

constructor TDatas.Create(AOwner: TGroupPeriodo);
begin
  inherited Create;
  FPosicao            := tpHorizontal;
  FValidarDataFinal   := True;
  FEditMask           := '99/99/9999;1; ';
  FTopoInicio         := 3;
  FTituloPeriodo     := 'Período';
  FTituloInicial     := 'De';
  FTituloFinal       := 'Até';
  RedefinirTodoPeriodo(0, 0);
end;

destructor TDatas.Destroy;
begin
  Self := Nil;
  inherited;
end;

function TDatas.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TDatas.RedefinirTodoPeriodo(aDataInicial, aDataFinal: TDateTime);
begin
  PeriodoInicial := ifthen(aDataInicial > 0, aDataInicial, IncYear(Today, -5));
  PeriodoFinal   := ifthen(aDataFinal > 0,   aDataFinal,   IncYear(Today, 5));

  if (FEditDataInicial <> nil) and (FEditDataFinal <> nil) then
  begin
    FEditDataInicial.Text := DateToStr(PeriodoInicial);
    FEditDataFinal.Text   := DateToStr(PeriodoFinal);
  end;

end;

procedure TDatas.ReiniciaPeriodo();
var
  dDataInicial  : TDateTime;
  dDataFinal    : TDateTime;
begin
  if not Assigned(FComboPeriodo) then
    Exit;

  FComboPeriodo.ItemIndex := Ord(FIntervalo);

  dDataInicial  := Today;
  dDataFinal    := Today;
  case FIntervalo of
    tpHoje:            begin
                         dDataInicial  := Today;
                         dDataFinal    := Today;
                       end;
    tpUltimo30dias:    begin
                         dDataInicial  := IncMonth(Today, -1);
                         dDataFinal    := Today;
                       end;
    tpProximo30dias:    begin
                         dDataInicial  := Today;
                         dDataFinal    := IncMonth(Today, 1);
                       end;
    tpInicioSemana:    begin
                         dDataInicial  := StartOfTheWeek(Today);
                       end;
    tpInicioMes:       begin
                         dDataInicial  := StartOfTheMonth(Today);
                       end;
    tpInicioAno:       begin
                         dDataInicial  := StartOfTheYear(Today);
                       end;
    tpTodoPeriodo:     begin
                         dDataInicial  := PeriodoInicial;   // Periodo longo
                         dDataFinal    := PeriodoFinal;     // Periodo longo
                       end;

  end;
  FEditDataInicial.Text := FormatDateTime('c', dDataInicial);
  FEditDataFinal.Text   := FormatDateTime('c', dDataFinal);

end;

procedure TDatas.SetPosicao(const Value: TPosicao);
begin
  FPosicao := Value;
  SetAjustarPosicao;
end;

procedure TDatas.SetTopoInicio(const Value: Integer);
begin
  FTopoInicio := Value;
  if Value < 0  then
  begin
    FTopoInicio := 3;
  end;

  SetAjustarPosicao;
end;

procedure TDatas.TrocaTipoPeriodo(Sender: TObject);
begin
  if not Assigned(FComboPeriodo) then
    Exit;
  SetIntervalo( TIntervalo(Ord(FComboPeriodo.ItemIndex)) );
end;

procedure TDatas.SetAjustarPosicao;
begin
  // Label Inicial
  FLabelCombo.Top     := FTopoInicio; //_LABEL_TOPO_21;
  FLabelCombo.Left    := _MARGEM_ESQUERDA_10;

  // Combobox
  FComboPeriodo.Top   := FLabelCombo.Top + FLabelCombo.Height + _ESPACAMENTO_VERTICAL_3;
  FComboPeriodo.Left  := FLabelCombo.Left;


  // Ajuste de Largura
  FComboPeriodo.Width     :=  _LARGURA_COMBO_155;
  FEditDataInicial.Width  :=  _LARGURA_EDIT_082;
  FEditDataFinal.Width    :=  _LARGURA_EDIT_082;

  if FLabelCombo.Width > FComboPeriodo.Width then
  begin
    FComboPeriodo.Width :=  FLabelCombo.Width + _ESPACAMENTO_VERTICAL_3;
  end;

  if FLabelinicial.Width > FEditDataInicial.Width then
  begin
    FEditDataInicial.Width :=  FLabelinicial.Width + _ESPACAMENTO_VERTICAL_3;
  end;

  if FLabelFinal.Width > FEditDataFinal.Width then
  begin
    FEditDataFinal.Width :=  FLabelFinal.Width + _ESPACAMENTO_VERTICAL_3;
  end;

  case FPosicao of
    tpHorizontal : begin
                     // Label Inicial
                     FLabelinicial.Left := FComboPeriodo.Left + FComboPeriodo.Width + _ESPACAMENTO_HOR_10;
                     FLabelinicial.Top  := FLabelCombo.Top;

                     // Edit Inicial
                     FEditDataInicial.Left := FLabelinicial.Left;
                     FEditDataInicial.Top  := FLabelinicial.Top + FLabelinicial.Height + _ESPACAMENTO_VERTICAL_3;

                     // Label Final
                     FLabelFinal.Left  := FEditDataInicial.Left + FEditDataInicial.Width + _ESPACAMENTO_HOR_10;
                     FLabelFinal.Top   := FLabelCombo.Top;

                     // Edit Final
                     FEditDataFinal.Left    := FLabelFinal.Left;
                     FEditDataFinal.Top     := FLabelFinal.Top + FLabelFinal.Height + _ESPACAMENTO_VERTICAL_3;
                   end;

    tpVertical   : begin
                     // Label Inicial
                     FLabelinicial.Left := FLabelCombo.Left;
                     FLabelinicial.Top  := FComboPeriodo.Top + FComboPeriodo.Height + _ESPACAMENTO_VERTICAL_3;

                     // Edit Inicial
                     FEditDataInicial.Left := FLabelCombo.Left;
                     FEditDataInicial.Top  := FLabelinicial.Top + FLabelinicial.Height + _ESPACAMENTO_VERTICAL_3;

                     // Label Final
                     FLabelFinal.Left  := FLabelCombo.Left;
                     FLabelFinal.Top   := FEditDataInicial.Top + FEditDataInicial.Height + _ESPACAMENTO_VERTICAL_3;

                     // Edit Final
                     FEditDataFinal.Left    := FLabelCombo.Left;
                     FEditDataFinal.Top     := FLabelFinal.Top + FLabelFinal.Height + _ESPACAMENTO_VERTICAL_3;
                   end;
  end;

end;

procedure TDatas.SetTituloPeriodo(const Value: String);
begin
  FTituloPeriodo := Trim(Value);
  FLabelCombo.Caption := FTituloPeriodo;
end;

procedure TDatas.SetTituloInicial(const Value: String);
begin
  FTituloInicial := Trim(Value);
  FLabelinicial.Caption := FTituloInicial;
end;

procedure TDatas.SetTituloFinal(const Value: String);
begin
  FTituloFinal := Trim(Value);
  FLabelFinal.Caption := FTituloFinal;
end;

procedure TDatas.SetIntervalo(const Value: TIntervalo);
begin
  FIntervalo := Value;
  ReiniciaPeriodo;
  Owner.DoOnChange; // Aqui dispara evento OnChange
end;

procedure TDatas.SetOwner(const Value: TGroupPeriodo);
begin
  FOwner := Value;
end;

{ TGroupPeriodo }
procedure TGroupPeriodo.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;

end;

procedure TGroupPeriodo.FormatarSaida(Sender: TObject);
var
  mData : TDate;
begin
  mData := StrToDateDef(TMaskEdit(Sender).Text, Date);
  TMaskEdit(Sender).Text := DateToStr(mData);
  SetarDatas;
end;

function TGroupPeriodo.GetDataInicial: TDateTime;
begin
  SetarDatas;
  Result := FDatas.FDataInicial;
end;

function TGroupPeriodo.GetDataFinal: TDateTime;
begin
  SetarDatas;
  Result := FDatas.FDataFinal;
end;

procedure TGroupPeriodo.CriarObjetos;
begin
  FDatas                := TDatas.Create(Self);
  FDatas.FOwner         := Self;
  FDatas.FIntervalo     := tpProximo30dias;

  // Esse objeto "FLabelCombo" deve ser criado primeiro para servir de referencia aos demais abaixo dele.
  if not Assigned(FDatas.FLabelCombo) then
  begin
    FDatas.FLabelCombo         := TLabel.Create(Self);
    FDatas.FLabelCombo.Name    := '_FLabelCombo1';
    FDatas.FLabelCombo.Parent  := Self;
    FDatas.FLabelCombo.Top     := FDatas.FTopoInicio; //_LABEL_TOPO_21;
    FDatas.FLabelCombo.Left    := _MARGEM_ESQUERDA_10;
    FDatas.FLabelCombo.Caption := FDatas.FTituloPeriodo; //_LABEL_DATA_INTERVALO;
  end;

  if not Assigned(FDatas.FComboPeriodo) then
  begin
    FDatas.FComboPeriodo         := TComboBox.Create(Self);
    FDatas.FComboPeriodo.Parent  := Self;
    FDatas.FComboPeriodo.Style   := csDropDownList;
    FDatas.FComboPeriodo.Width   := _LARGURA_COMBO_155;
    FDatas.FComboPeriodo.TabStop := True;
  end;

  if not Assigned(FDatas.FLabelinicial) then
  begin
    FDatas.FLabelinicial         := TLabel.Create(Self);
    FDatas.FLabelinicial.Name    := '_LabelInicial1';
    FDatas.FLabelinicial.Parent  := Self;
    FDatas.FLabelinicial.Caption := FDatas.FTituloInicial; //_LABEL_DATA_INICIAL;
  end;

  if not Assigned(FDatas.FLabelFinal) then
  begin
    FDatas.FLabelFinal         := TLabel.Create(Self);
    FDatas.FLabelFinal.Name    := '_LabelFinal1';
    FDatas.FLabelFinal.Parent  := Self;
    FDatas.FLabelFinal.Caption := FDatas.FTituloFinal; //_LABEL_DATA_FINAL;
  end;

  if not Assigned(FDatas.FEditDataInicial) then
  begin
    FDatas.FEditDataInicial          := TMaskEdit.Create(Self);
    FDatas.FEditDataInicial.Name     := '_DataInicial1';
    FDatas.FEditDataInicial.SetSubComponent(True);
    FDatas.FEditDataInicial.Parent   := Self;
    FDatas.FEditDataInicial.EditMask := FDatas.FEditMask;
    FDatas.FEditDataInicial.Width    := _LARGURA_EDIT_082;
    FDatas.FEditDataInicial.Text     := FormatDateTime('c', Today);
    FDatas.FEditDataInicial.TabStop  := True;
  end;

  if not Assigned(FDatas.FEditDataFinal) then
  begin
    FDatas.FEditDataFinal            := TMaskEdit.Create(Self);
    FDatas.FEditDataFinal.Name       := '_DataFinal1';
    FDatas.FEditDataFinal.SetSubComponent(True);
    FDatas.FEditDataFinal.Parent     := Self;
    FDatas.FEditDataFinal.EditMask   := FDatas.FEditMask;
    FDatas.FEditDataFinal.Width      := _LARGURA_EDIT_082;
    FDatas.FEditDataFinal.Text       := FormatDateTime('c', Today);
    FDatas.FEditDataFinal.TabStop    := True;
  end;
  FDatas.SetAjustarPosicao;

  FDatas.FEditDataInicial.OnExit := FormatarSaida;
  FDatas.FEditDataFinal.OnExit   := FormatarSaida;

end;

procedure TGroupPeriodo.AfterConstruction;
begin
  inherited;
  LimparCaption();
end;

constructor TGroupPeriodo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Parent := TWinControl(AOwner);

  //Caption := 'Período';
  CriarObjetos();
  FDatas.SetAjustarPosicao;
  PopularComboBox;

  BevelInner := bvNone;
  BevelKind  := bkTile;
  BevelOuter := bvNone;

  if Assigned(FDatas) then
  begin
    case FDatas.Posicao of
      tpHorizontal : Constraints.MinWidth := _LARGURA_AREA_360;
      tpVertical   : Constraints.MinWidth := _LARGURA_AREA_190;
    end;
  end;
  LimparCaption();
end;

destructor TGroupPeriodo.Destroy;
begin
  if Assigned(FDatas) then
    FDatas.Free;
  inherited;
end;

procedure TGroupPeriodo.DoEnter;
begin
  inherited DOEnter;

end;

procedure TGroupPeriodo.DoExit;
begin
  if FDatas.FValidarDataFinal  then
  begin
    if CompararDataFinal() = False then
    begin
      Atencao('Datas invalidas', 'Informe o período corretamente.');

      FDatas.FEditDataFinal.SetFocus;
      Exit;
    end;
  end;
  SetarDatas;
  DoOnChange; // Aqui dispara evento OnChange
  inherited DoExit;
end;

procedure TGroupPeriodo.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TGroupPeriodo.CompararDataFinal: boolean;
begin
  Result := ( StrToDateDef(FDatas.FEditDataInicial.Text,  0) > 0) and
            ( StrToDateDef(FDatas.FEditDataFinal.Text,    0) > 0) and
            ( StrToDateDef(FDatas.FEditDataInicial.Text,  0) <= StrToDateDef(FDatas.FEditDataFinal.Text, 0));
end;

procedure TGroupPeriodo.PopularComboBox;
begin

  FDatas.FComboPeriodo.Clear;
  FDatas.FComboPeriodo.Sorted := False;
  FDatas.FComboPeriodo.OnClick := FDatas.TrocaTipoPeriodo;

  FDatas.FComboPeriodo.Items.AddObject('Hoje',                   TObject(tpHoje));
  FDatas.FComboPeriodo.Items.AddObject('Período Longo',          TObject(tpTodoPeriodo));
  FDatas.FComboPeriodo.Items.AddObject('Próximos 30 dias',       TObject(tpProximo30dias));
  FDatas.FComboPeriodo.Items.AddObject('Últimos 30 dias',        TObject(tpUltimo30dias));
  FDatas.FComboPeriodo.Items.AddObject('Início da semana',       TObject(tpInicioSemana));
  FDatas.FComboPeriodo.Items.AddObject('Início do mês',          TObject(tpInicioMes));
  FDatas.FComboPeriodo.Items.AddObject('Início do ano',          TObject(tpInicioAno));
  FDatas.FComboPeriodo.ItemIndex := FDatas.FComboPeriodo.Items.IndexOfObject(TObject(FDatas.FIntervalo));

end;

procedure TGroupPeriodo.SetarDatas;
begin
  FDatas.FDataInicial := StrToDateTime(FDatas.FEditDataInicial.Text);
  FDatas.FDataFinal   := StrToDateTime(FDatas.FEditDataFinal.Text);
end;

procedure TGroupPeriodo.SetDatas(const Value: TDatas);
begin
  FDatas.Assign(Value);
end;

procedure TGroupPeriodo.LimparCaption;
begin
  Self.Caption := ' ';
end;

procedure TGroupPeriodo.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TGroupPeriodo.WMWindowPosChanged(var Message: TWMWindowPosChanged);
begin
  inherited;

end;

procedure Aviso(const aMensagem: String);
begin
  Application.MessageBox(pwidechar(aMensagem), 'Atenção', MB_ICONWARNING);
end;


procedure Atencao(const aMensagem: String; aDica: String = '');
begin
  with TTaskDialog.Create(nil) do
  begin
    try
      Caption       := 'Atenção';
      Title         := aMensagem;
      Text          := aDica;
      MainIcon      := tdiWarning;
      CommonButtons := [tcbOk];
      Execute;
    finally
      Free;
    end;
  end;
end;

end.
