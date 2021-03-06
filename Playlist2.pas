unit Playlist2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TfrmPlaylist2 = class(TForm)
    lbPlaylist: TListBox;
    bitbtnDown: TBitBtn;
    bitbtnUp: TBitBtn;
    bitbtnAddSongs: TBitBtn;
    bitbtnDeleteSongs: TBitBtn;
    bitbtnSaveToPlaylist: TBitBtn;
    procedure Startup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPlaylist2: TfrmPlaylist2;

implementation

uses Main;

{$R *.dfm}

procedure TfrmPlaylist2.Startup(Sender: TObject);
// Questii de facut la crearea ferestrei
begin
  Left := Main.OptiuniPlayer.GetOptionInteger(5);
  // Citeste coordonatele ferestrei
  Top := Main.OptiuniPlayer.GetOptionInteger(6);

  if (Main.OptiuniPlayer.GetOptionInteger(12) = 0) or
    (Main.OptiuniPlayer.GetOptionInteger(12) = 2) then
    { Daca din optiuni e setata afisarea acestei ferestre, o afiseaza. Altfel, o ascunde }
    Show
  else
    Hide;

  EnableMenuItem(GetSystemMenu(handle, False), SC_CLOSE, MF_BYCOMMAND or
    MF_GRAYED); // Dezactivez butonul de inchidere a ferestrei
end;

end.
