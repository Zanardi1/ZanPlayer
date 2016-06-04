object frmAbout: TfrmAbout
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Despre program'
  ClientHeight = 359
  ClientWidth = 572
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
  object pcSpecifications: TPageControl
    Left = 24
    Top = 24
    Width = 521
    Height = 321
    ActivePage = tsAbout
    TabOrder = 0
    object tsAbout: TTabSheet
      Caption = 'Despre program'
      object lblZanPlayer: TLabel
        Left = 48
        Top = 40
        Width = 51
        Height = 13
        Caption = 'Zan Player'
      end
      object lblVersion: TLabel
        Left = 48
        Top = 72
        Width = 66
        Height = 13
        Caption = 'Versiunea 1.0'
      end
      object lblAuthor: TLabel
        Left = 48
        Top = 104
        Width = 164
        Height = 13
        Caption = 'Scris si conceput de Bogdan Doicin'
      end
      object lblBASSVersion: TLabel
        Left = 48
        Top = 128
        Width = 132
        Height = 13
        Caption = 'Acest program foloseste... '
      end
    end
  end
end
