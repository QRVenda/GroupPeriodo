object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 424
  ClientWidth = 1059
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  TextHeight = 20
  object GroupPeriodo1: TGroupPeriodo
    Left = 88
    Top = 112
    Width = 384
    Height = 73
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = ' '
    Constraints.MinWidth = 360
    TabOrder = 0
    Datas.Intervalo = tpTodoPeriodo
    Datas.ValidarDataFinal = True
    Datas.Mascara = '99/99/9999;1; '
    Datas.TopoInicio = 3
    Datas.Titulo01_Periodo = 'Per'#237'odo'
    Datas.Titulo02_Inicial = 'De'
    Datas.Titulo03_Final = 'At'#233
  end
  object Button1: TButton
    Left = 88
    Top = 81
    Width = 75
    Height = 25
    Caption = 'Reiniciar'
    TabOrder = 1
    OnClick = Button1Click
  end
end
