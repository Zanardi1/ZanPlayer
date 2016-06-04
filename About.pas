unit About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Bass;

type
  TfrmAbout = class(TForm)
    pcSpecifications: TPageControl;
    tsAbout: TTabSheet;
    lblZanPlayer: TLabel;
    lblVersion: TLabel;
    lblAuthor: TLabel;
    lblBASSVersion: TLabel;
    procedure Startup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.Startup(Sender: TObject);
// Rutine efectuate la pornirea programului
var
  BASSVersion: dword; // Retine versiunea de BASS
begin
  BASSVersion := Bass.BASS_GetVersion;
  lblBASSVersion.Caption := 'Acest program foloseste versiunea ' +
    IntToStr(HiWord(BASSVersion)) + '.' + IntToStr(LoWord(BASSVersion))+' a bibliotecii BASS';
end;

end.
