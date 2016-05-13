object frmPlaylist1: TfrmPlaylist1
  Left = 0
  Top = 0
  Caption = 'Playlist 1'
  ClientHeight = 204
  ClientWidth = 409
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
    TabStop = False
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = PlaySelectedSong
  end
  object bitbtnUp: TBitBtn
    Left = 336
    Top = 32
    Width = 50
    Height = 25
    Caption = 'Up'
    TabOrder = 1
    TabStop = False
  end
  object bitbtnDown: TBitBtn
    Left = 336
    Top = 128
    Width = 50
    Height = 25
    Caption = 'Down'
    TabOrder = 2
    TabStop = False
  end
  object bitbtnAddSongs: TBitBtn
    Left = 16
    Top = 175
    Width = 25
    Height = 25
    Caption = '+'
    TabOrder = 3
    TabStop = False
    OnClick = ShowPlaylistMenu
  end
  object bitbtnDeleteSongs: TBitBtn
    Left = 47
    Top = 175
    Width = 25
    Height = 25
    Caption = '-'
    TabOrder = 4
    TabStop = False
    OnClick = ShowDeletePlaylistMenu
  end
  object bitbtnSaveToPlaylist: TBitBtn
    Left = 78
    Top = 175
    Width = 25
    Height = 25
    Caption = 'S'
    TabOrder = 5
    TabStop = False
  end
  object pmAddToPlaylist: TPopupMenu
    TrackButton = tbLeftButton
    Left = 184
    Top = 64
    object miAddSongs: TMenuItem
      Caption = 'Adauga melodii'
      OnClick = AddSongsToPlaylist
    end
    object miAddPlaylist: TMenuItem
      Caption = 'Adauga playlist'
    end
  end
  object odAddSongsToPlaylist: TOpenDialog
    Filter = 'fisiere mp3|*.mp3'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist]
    Title = 'Alege melodia sau melodiile dorite'
    Left = 80
    Top = 64
  end
  object pmDeleteFromPlaylist: TPopupMenu
    Left = 256
    Top = 64
    object miDeleteSongs: TMenuItem
      Caption = 'Sterge melodiile'
    end
    object miDeletePlaylist: TMenuItem
      Caption = 'Sterge playlistul'
      OnClick = DeletePlaylist
    end
  end
end
