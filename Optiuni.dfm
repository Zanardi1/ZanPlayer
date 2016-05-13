object frmOptiuni: TfrmOptiuni
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'Optiuni'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object bitbtnOK: TBitBtn
    Left = 352
    Top = 16
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 0
  end
  object bitbtnCancel: TBitBtn
    Left = 352
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Anulare'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
  end
  object TabControl1: TTabControl
    Left = 16
    Top = 16
    Width = 313
    Height = 169
    MultiLine = True
    TabOrder = 2
    Tabs.Strings = (
      'Pornire'
      'Playlist 1'
      'Diverse')
    TabIndex = 0
    TabStop = False
  end
end
