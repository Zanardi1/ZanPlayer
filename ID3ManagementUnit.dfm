object frmID3: TfrmID3
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Tag-uri ID3'
  ClientHeight = 478
  ClientWidth = 780
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
    Height = 401
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
      object gbTagInformation: TGroupBox
        Left = 11
        Top = 42
        Width = 214
        Height = 311
        Caption = 'Informatii despre eticheta'
        TabOrder = 0
        object lblGenre2: TLabel
          Left = 11
          Top = 181
          Width = 60
          Height = 13
          Caption = 'Gen muzical:'
        end
        object leTitle2: TLabeledEdit
          Left = 77
          Top = 23
          Width = 121
          Height = 21
          EditLabel.Width = 24
          EditLabel.Height = 13
          EditLabel.Caption = 'Titlu:'
          LabelPosition = lpLeft
          TabOrder = 0
        end
        object cbGenre2: TComboBox
          Left = 77
          Top = 179
          Width = 121
          Height = 21
          TabOrder = 1
          Items.Strings = (
            'A Cappella'
            'Acid'
            'Acid Jazz'
            'Acid Punk'
            'Acoustic'
            'Alt. Rock'
            'Alternative'
            'Ambient'
            'Anime'
            'Avantgarde'
            'Ballad'
            'Bass'
            'Beat'
            'Bebob'
            'Big Band'
            'Black Metal'
            'Bluegrass'
            'Blues'
            'Booty Bass'
            'BritPop'
            'Cabaret'
            'Celtic'
            'Chamber Music'
            'Chanson'
            'Chorus'
            'Christian Gangsta'
            'Christian Rap'
            'Christian Rock'
            'Classic Rock'
            'Classical'
            'Club'
            'Club-House'
            'Comedy'
            'Contemporary Christian'
            'Country'
            'Crossover'
            'Cult'
            'Dance'
            'Dance Hall'
            'Darkwave'
            'Death Metal'
            'Disco'
            'Dream'
            'Drum & Base'
            'Drum Solo'
            'Duet'
            'Easy Listening'
            'Electronic'
            'Ethnic'
            'Eurodance'
            'Euro-House'
            'Euro-Techno'
            'Fast-Fusion'
            'Folk'
            'Folk/Rock'
            'Folklore'
            'Freestyle'
            'Funk'
            'Fusion'
            'Game'
            'Gangsta Rap'
            'Goa'
            'Gospel'
            'Gothic'
            'Gothic Rock'
            'Grunge'
            'Hard Rock'
            'Hardcore'
            'Heavy Metal'
            'Hip-Hop'
            'House'
            'Humour'
            'Indie'
            'Industrial'
            'Instrumental'
            'Instrumental Pop'
            'Instrumental Rock'
            'Jazz'
            'Jazz+Funk'
            'JPop'
            'Jungle'
            'Latin'
            'Lo-Fi'
            'Meditative'
            'Merengue'
            'Metal'
            'Musical'
            'National Folk'
            'Native American'
            'Negerpunk'
            'New Age'
            'New Wave'
            'Noise'
            'Oldies'
            'Opera'
            'Other'
            'Polka'
            'Polsk Punk'
            'Pop'
            'Pop/Funk'
            'Pop-Folk'
            'Porn Groove'
            'Power Ballad'
            'Pranks'
            'Primus'
            'Progressive Rock'
            'Psychedelic'
            'Psychedelic Rock'
            'Punk'
            'Punk Rock'
            'R&B'
            'Rap'
            'Rave'
            'Reggae'
            'Retro'
            'Revival'
            'Rhythmic Soul'
            'Rock'
            'Rock & Roll'
            'Salsa'
            'Samba'
            'Satire'
            'Showtunes'
            'Ska'
            'Slow Jam'
            'Slow Rock'
            'Sonata'
            'Soul'
            'Sound Clip'
            'Soundtrack'
            'Southern Rock'
            'Space'
            'Speech'
            'Swing'
            'Symphonic Rock'
            'Symphony'
            'Synthpop'
            'Tango'
            'Techno'
            'Techno-Industrial'
            'Terror'
            'Thrash Metal'
            'Top 40'
            'Trailer'
            'Trance'
            'Tribal'
            'Trip-Hop'
            'Vocal')
        end
        object leAlbum2: TLabeledEdit
          Left = 77
          Top = 102
          Width = 121
          Height = 21
          EditLabel.Width = 33
          EditLabel.Height = 13
          EditLabel.Caption = 'Album:'
          LabelPosition = lpLeft
          TabOrder = 2
        end
        object leArtist2: TLabeledEdit
          Left = 77
          Top = 61
          Width = 121
          Height = 21
          EditLabel.Width = 30
          EditLabel.Height = 13
          EditLabel.Caption = 'Artist:'
          LabelPosition = lpLeft
          TabOrder = 3
        end
        object leTrack2: TLabeledEdit
          Left = 77
          Top = 214
          Width = 121
          Height = 21
          EditLabel.Width = 63
          EditLabel.Height = 13
          EditLabel.Caption = 'Numar piesa:'
          LabelPosition = lpLeft
          TabOrder = 4
        end
        object leYear2: TLabeledEdit
          Left = 77
          Top = 138
          Width = 121
          Height = 21
          EditLabel.Width = 17
          EditLabel.Height = 13
          EditLabel.Caption = 'An:'
          LabelPosition = lpLeft
          TabOrder = 5
        end
        object leURL: TLabeledEdit
          Left = 77
          Top = 256
          Width = 121
          Height = 21
          EditLabel.Width = 23
          EditLabel.Height = 13
          EditLabel.Caption = 'URL:'
          LabelPosition = lpLeft
          TabOrder = 6
        end
      end
      object cbTagActivate2: TCheckBox
        Left = 11
        Top = 19
        Width = 124
        Height = 17
        Caption = 'Activare tag ID3V2'
        TabOrder = 1
        OnClick = ToggleFieldEnabledStates2
      end
      object gbTagAttributes: TGroupBox
        Left = 248
        Top = 48
        Width = 233
        Height = 97
        Caption = 'Atributele etichetei'
        TabOrder = 2
        object lblVersion: TLabel
          Left = 16
          Top = 24
          Width = 45
          Height = 13
          Caption = 'Versiune:'
        end
        object cbUnsynced: TCheckBox
          Left = 9
          Top = 47
          Width = 97
          Height = 17
          Caption = 'Nesincronizat'
          TabOrder = 0
        end
        object cbExtendedHeader: TCheckBox
          Left = 9
          Top = 70
          Width = 97
          Height = 17
          Caption = 'Antet extins'
          TabOrder = 1
        end
        object cbExperimental: TCheckBox
          Left = 120
          Top = 47
          Width = 97
          Height = 17
          Caption = 'Experimental'
          TabOrder = 2
        end
        object cbCRCPresent: TCheckBox
          Left = 120
          Top = 70
          Width = 113
          Height = 17
          Caption = 'CRC este prezent'
          TabOrder = 3
        end
      end
      object gbComment: TGroupBox
        Left = 248
        Top = 151
        Width = 233
        Height = 202
        Caption = 'Comentariu'
        TabOrder = 3
        object memComment: TMemo
          Left = 8
          Top = 24
          Width = 209
          Height = 81
          TabOrder = 0
        end
        object leLanguageID: TLabeledEdit
          Left = 56
          Top = 119
          Width = 121
          Height = 21
          EditLabel.Width = 31
          EditLabel.Height = 13
          EditLabel.Caption = 'Limba:'
          LabelPosition = lpLeft
          TabOrder = 1
        end
        object leDescription: TLabeledEdit
          Left = 56
          Top = 160
          Width = 121
          Height = 21
          EditLabel.Width = 49
          EditLabel.Height = 13
          EditLabel.Caption = 'Descriere:'
          LabelPosition = lpLeft
          TabOrder = 2
        end
      end
      object gbLyrics: TGroupBox
        Left = 499
        Top = 48
        Width = 214
        Height = 305
        Caption = 'Versuri'
        TabOrder = 4
        object memLyrics: TMemo
          Left = 16
          Top = 24
          Width = 185
          Height = 170
          TabOrder = 0
        end
        object leLyricsLanguage: TLabeledEdit
          Left = 56
          Top = 226
          Width = 121
          Height = 21
          EditLabel.Width = 27
          EditLabel.Height = 13
          EditLabel.Caption = 'Limba'
          LabelPosition = lpLeft
          TabOrder = 1
        end
        object leLyricsDescription: TLabeledEdit
          Left = 56
          Top = 266
          Width = 121
          Height = 21
          EditLabel.Width = 49
          EditLabel.Height = 13
          EditLabel.Caption = 'Descriere:'
          LabelPosition = lpLeft
          TabOrder = 2
        end
      end
    end
  end
  object bkOK: TBitBtn
    Left = 312
    Top = 440
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
    OnClick = SaveTags
  end
  object bkCancel: TBitBtn
    Left = 410
    Top = 440
    Width = 75
    Height = 25
    Caption = 'Anulare'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
