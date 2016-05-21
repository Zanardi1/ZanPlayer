unit Optiuni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TfrmOptiuni = class(TForm)
    bitbtnOK: TBitBtn;
    bitbtnCancel: TBitBtn;
    pcOptions: TPageControl;
    tsMisc: TTabSheet;
    tsStartup: TTabSheet;
    tsPlaylist1: TTabSheet;
    rgPlaylistStartup: TRadioGroup;
    rgMinimizeTo: TRadioGroup;
    procedure Startup(Sender: TObject);
    procedure SaveChanges(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptiuni: TfrmOptiuni;

implementation

uses Main;

{$R *.dfm}

procedure TfrmOptiuni.SaveChanges(Sender: TObject);
// Procedura salveaza modificarile
begin
  if rgMinimizeTo.ItemIndex=0 then
    Main.OptiuniPlayer.SetOptionBoolean(11, true)
  else
    Main.OptiuniPlayer.SetOptionBoolean(11, false);
end;

procedure TfrmOptiuni.Startup(Sender: TObject);
// Procedura se ocupa de ceea ce trebuie sa faca aceasta fereastra la pornirea ei
begin
  if Main.OptiuniPlayer.GetOptionBoolean(11) then
    rgMinimizeTo.ItemIndex:=0
  else
    rgMinimizeTo.ItemIndex:=1;
end;

end.
