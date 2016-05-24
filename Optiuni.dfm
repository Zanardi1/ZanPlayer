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
  ShowHint = True
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
        Width = 161
        Height = 105
        Caption = 'Minimizare pe:'
        Items.Strings = (
          'Taskbar'
          'Systray')
        TabOrder = 0
      end
      object cbNotification: TCheckBox
        Left = 8
        Top = 119
        Width = 161
        Height = 17
        Hint = 
          'Daca e bifata optiunea, este afisat un mesaj la minimizarea prog' +
          'ramului pe systray.'
        Caption = 'Anunt minimizare pe systray'
        TabOrder = 1
      end
      object cbPlaylistSongNumbering: TCheckBox
        Left = 8
        Top = 144
        Width = 177
        Height = 17
        Hint = 
          'Daca e bifat, melodiile din fereastra de playlist sunt numerotat' +
          'e'
        Caption = 'Numerotarea melodiilor in playlist'
        TabOrder = 2
      end
      object cbShowTimeElapsed: TCheckBox
        Left = 8
        Top = 167
        Width = 161
        Height = 17
        Hint = 
          'Daca e bifata, afiseaza timpul scurs de la inceperea melodiei. A' +
          'ltfel este afisat timpul ramas pana la finalul melodiei'
        Caption = 'Arata timpul scurs din melodie'
        TabOrder = 3
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
