object frmOptiuni: TfrmOptiuni
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'Optiuni'
  ClientHeight = 327
  ClientWidth = 613
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = Startup
  PixelsPerInch = 96
  TextHeight = 13
  object bitbtnOK: TBitBtn
    Left = 530
    Top = 56
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 0
    OnClick = SaveChanges
  end
  object bitbtnCancel: TBitBtn
    Left = 530
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Anulare'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 1
  end
  object pcOptions: TPageControl
    Left = 8
    Top = 16
    Width = 505
    Height = 305
    ActivePage = tsMisc
    TabOrder = 2
    object tsMisc: TTabSheet
      Caption = 'Diverse'
      object rgMinimizeTo: TRadioGroup
        Left = 8
        Top = 8
        Width = 185
        Height = 105
        Caption = 'Minimizare pe:'
        Items.Strings = (
          'Taskbar'
          'Systray')
        TabOrder = 0
      end
    end
    object tsStartup: TTabSheet
      Caption = 'Pornire'
      ImageIndex = 1
      object rgPlaylistStartup: TRadioGroup
        Left = 16
        Top = 16
        Width = 209
        Height = 161
        Caption = 'Ferestre de playlist afisate la pornire'
        Items.Strings = (
          'Ambele ferestre'
          'Prima fereastra'
          'A doua fereastra'
          'Niciuna')
        TabOrder = 0
      end
    end
    object tsPlaylist1: TTabSheet
      Caption = 'Playlist 1'
      ImageIndex = 2
    end
  end
end
