object frmPlaylist1: TfrmPlaylist1
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Playlist 1'
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
    TabStop = False
    ItemHeight = 13
    MultiSelect = True
    PopupMenu = pmDoAll
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
    OnClick = MoveUpOnePos
  end
  object bitbtnDown: TBitBtn
    Left = 336
    Top = 128
    Width = 50
    Height = 25
    Caption = 'Down'
    TabOrder = 2
    TabStop = False
    OnClick = MoveDownOnePos
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
    OnClick = SaveToPlaylist
  end
  object pmAddToPlaylist: TPopupMenu
    TrackButton = tbLeftButton
    Left = 64
    Top = 104
    object miAddSongs: TMenuItem
      Caption = 'Adauga melodii'
      OnClick = AddSongsToPlaylist
    end
    object miAddPlaylist: TMenuItem
      Caption = 'Adauga playlist'
      OnClick = AddAnotherPlaylist
    end
  end
  object odAddSongsToPlaylist: TOpenDialog
    Filter = 'Fisiere mp3|*.mp3'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist]
    Title = 'Alege melodia sau melodiile dorite'
    Left = 56
    Top = 32
  end
  object pmDeleteFromPlaylist: TPopupMenu
    Left = 168
    Top = 32
    object miDeleteSongs: TMenuItem
      Caption = 'Sterge melodii'
      OnClick = DeleteSongs
    end
    object miDeletePlaylist: TMenuItem
      Caption = 'Sterge playlist'
      OnClick = DeletePlaylist
    end
  end
  object sdSaveToPlaylist: TSaveDialog
    DefaultExt = 'pls'
    Filter = 'Playlisturi PLS|*.pls|Playlisturi M3U|*.m3u'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Salvare playlist'
    Left = 168
    Top = 96
  end
  object odAddAPlaylist: TOpenDialog
    Filter = 'Playlisturi PLS|*.pls|Playlisturi M3U|*.m3u'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Incarca un playlist'
    Left = 264
    Top = 32
  end
  object pmDoAll: TPopupMenu
    Left = 272
    Top = 104
    object miAddSongs2: TMenuItem
      Caption = 'Adauga melodii'
      OnClick = AddSongsToPlaylist
    end
    object miAddPlaylist2: TMenuItem
      Caption = 'Adauga playlist'
      OnClick = AddAnotherPlaylist
    end
    object miDeleteSongs2: TMenuItem
      Caption = 'Sterge melodii'
      OnClick = DeleteSongs
    end
    object miDeletePlaylist2: TMenuItem
      Caption = 'Sterge playlist'
      OnClick = DeletePlaylist
    end
    object miSaveToPlaylist: TMenuItem
      Caption = 'Salveaza ca playlist'
      OnClick = SaveToPlaylist
    end
    object miShowID3Tags: TMenuItem
      Caption = 'Afiseaza etichete ID3'
      OnClick = ShowID3Tags
    end
  end
end
