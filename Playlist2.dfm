object frmPlaylist2: TfrmPlaylist2
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Playlist 2'
  ClientHeight = 214
  ClientWidth = 419
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
  object lbPlaylist: TListBox
    Left = 16
    Top = 16
    Width = 305
    Height = 153
    ItemHeight = 13
    TabOrder = 0
  end
  object bitbtnDown: TBitBtn
    Left = 336
    Top = 128
    Width = 50
    Height = 25
    Caption = 'Down'
    TabOrder = 1
  end
  object bitbtnUp: TBitBtn
    Left = 336
    Top = 32
    Width = 50
    Height = 25
    Caption = 'Up'
    TabOrder = 2
  end
  object bitbtnAddSongs: TBitBtn
    Left = 16
    Top = 175
    Width = 25
    Height = 25
    Caption = '+'
    TabOrder = 3
  end
  object bitbtnDeleteSongs: TBitBtn
    Left = 47
    Top = 175
    Width = 25
    Height = 25
    Caption = '-'
    TabOrder = 4
  end
  object bitbtnSaveToPlaylist: TBitBtn
    Left = 78
    Top = 175
    Width = 25
    Height = 25
    Caption = 'S'
    TabOrder = 5
  end
end
