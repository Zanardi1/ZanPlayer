object frmID3: TfrmID3
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Tag-uri ID3'
  ClientHeight = 524
  ClientWidth = 884
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = Startup
  OnDestroy = Bye
  PixelsPerInch = 96
  TextHeight = 13
  object pcID3Tags: TPageControl
    Left = 16
    Top = 16
    Width = 745
    Height = 489
    ActivePage = tsID3V1
    TabOrder = 0
    object tsID3V1: TTabSheet
      Caption = 'ID3V1'
      object lblGenre: TLabel
        Left = 11
        Top = 230
        Width = 60
        Height = 13
        Caption = 'Gen muzical:'
      end
      object leTitle: TLabeledEdit
        Left = 77
        Top = 55
        Width = 121
        Height = 21
        EditLabel.Width = 24
        EditLabel.Height = 13
        EditLabel.Caption = 'Titlu:'
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object leArtist: TLabeledEdit
        Left = 77
        Top = 85
        Width = 121
        Height = 21
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Artist:'
        LabelPosition = lpLeft
        TabOrder = 1
      end
      object leAlbum: TLabeledEdit
        Left = 77
        Top = 118
        Width = 121
        Height = 21
        EditLabel.Width = 33
        EditLabel.Height = 13
        EditLabel.Caption = 'Album:'
        LabelPosition = lpLeft
        TabOrder = 2
      end
      object leYear: TLabeledEdit
        Left = 77
        Top = 154
        Width = 121
        Height = 21
        EditLabel.Width = 17
        EditLabel.Height = 13
        EditLabel.Caption = 'An:'
        LabelPosition = lpLeft
        TabOrder = 3
      end
      object leComment: TLabeledEdit
        Left = 77
        Top = 192
        Width = 121
        Height = 21
        EditLabel.Width = 59
        EditLabel.Height = 13
        EditLabel.Caption = 'Comentariu:'
        LabelPosition = lpLeft
        TabOrder = 4
      end
      object cbGenre: TComboBox
        Left = 77
        Top = 227
        Width = 121
        Height = 21
        TabOrder = 5
      end
      object leTrack: TLabeledEdit
        Left = 77
        Top = 263
        Width = 121
        Height = 21
        EditLabel.Width = 63
        EditLabel.Height = 13
        EditLabel.Caption = 'Numar piesa:'
        LabelPosition = lpLeft
        TabOrder = 6
      end
      object cbTagActivate: TCheckBox
        Left = 11
        Top = 19
        Width = 187
        Height = 17
        Caption = 'Activare tag ID3V1'
        TabOrder = 7
        OnClick = ToggleFieldEnabledStates
      end
    end
    object tsID3V2: TTabSheet
      Caption = 'ID3V2'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblGenre2: TLabel
        Left = 13
        Top = 235
        Width = 60
        Height = 13
        Caption = 'Gen muzical:'
      end
      object leTitle2: TLabeledEdit
        Left = 77
        Top = 24
        Width = 121
        Height = 21
        EditLabel.Width = 24
        EditLabel.Height = 13
        EditLabel.Caption = 'Titlu:'
        LabelPosition = lpLeft
        TabOrder = 0
      end
      object leArtist2: TLabeledEdit
        Left = 77
        Top = 72
        Width = 121
        Height = 21
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Artist:'
        LabelPosition = lpLeft
        TabOrder = 1
      end
      object leAlbum2: TLabeledEdit
        Left = 77
        Top = 114
        Width = 121
        Height = 21
        EditLabel.Width = 33
        EditLabel.Height = 13
        EditLabel.Caption = 'Album:'
        LabelPosition = lpLeft
        TabOrder = 2
      end
      object leYear2: TLabeledEdit
        Left = 77
        Top = 152
        Width = 121
        Height = 21
        EditLabel.Width = 17
        EditLabel.Height = 13
        EditLabel.Caption = 'An:'
        LabelPosition = lpLeft
        TabOrder = 3
      end
      object leTrack2: TLabeledEdit
        Left = 77
        Top = 272
        Width = 121
        Height = 21
        EditLabel.Width = 63
        EditLabel.Height = 13
        EditLabel.Caption = 'Numar piesa:'
        LabelPosition = lpLeft
        TabOrder = 4
      end
      object LabeledEdit1: TLabeledEdit
        Left = 77
        Top = 192
        Width = 121
        Height = 21
        EditLabel.Width = 59
        EditLabel.Height = 13
        EditLabel.Caption = 'Comentariu:'
        LabelPosition = lpLeft
        TabOrder = 5
      end
      object cbGenre2: TComboBox
        Left = 77
        Top = 232
        Width = 121
        Height = 21
        TabOrder = 6
      end
    end
  end
  object bkOK: TBitBtn
    Left = 776
    Top = 88
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
    OnClick = SaveTags
  end
  object bkCancel: TBitBtn
    Left = 776
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Anulare'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
