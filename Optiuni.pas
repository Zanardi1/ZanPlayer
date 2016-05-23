unit Optiuni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls, Playlist1;

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
    cbNotification: TCheckBox;
    cbPlaylistSongNumbering: TCheckBox;
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
var
  i: integer; // variabila de ciclare
begin
  if rgMinimizeTo.ItemIndex = 0 then
    // Salveaza preferinta de minimizare: pe taskbar sau in systray
    Main.OptiuniPlayer.SetOptionBoolean(11, true)
  else
    Main.OptiuniPlayer.SetOptionBoolean(11, false);

  if cbNotification.Checked then
    // Salveaza preferinta de a afisa mesajul de la minimizarea pe systray
    Main.OptiuniPlayer.SetOptionBoolean(13, true)
  else
    Main.OptiuniPlayer.SetOptionBoolean(13, false);

  case rgPlaylistStartup.ItemIndex of
    // Salveaza preferinta de a afisa ferestrele de playlist odata cu pornirea playerului
    0:
      Main.OptiuniPlayer.SetOptionInteger(12, 0);
    1:
      Main.OptiuniPlayer.SetOptionInteger(12, 1);
    2:
      Main.OptiuniPlayer.SetOptionInteger(12, 2);
    3:
      Main.OptiuniPlayer.SetOptionInteger(12, 3);
  end;

  if cbPlaylistSongNumbering.Checked then
    // Daca am activat numerotarea melodiilor in playlist...
    begin
      Main.OptiuniPlayer.SetOptionBoolean(14, true); // ...salveaza optiunea
      Main.FirstPlaylist.ShownFileName.Clear;
      Playlist1.frmPlaylist1.lbPlaylist.Clear;
      for i := 0 to Main.FirstPlaylist.FileName.Count - 1 do
        Main.FirstPlaylist.ShownFileName.Add(IntToStr(i + 1) + '. ' +
          ChangeFileExt(ExtractFileName(Main.FirstPlaylist.FileName.Strings
          [i]), ''));
      Playlist1.frmPlaylist1.lbPlaylist.Items.AddStrings
        (Main.FirstPlaylist.ShownFileName);
    end
  else
    begin
      Main.OptiuniPlayer.SetOptionBoolean(14, false);
      Main.FirstPlaylist.ShownFileName.Clear;
      Playlist1.frmPlaylist1.lbPlaylist.Clear;
      for i := 0 to Main.FirstPlaylist.FileName.Count - 1 do
        Main.FirstPlaylist.ShownFileName.Add
          (ChangeFileExt(ExtractFileName(Main.FirstPlaylist.FileName.Strings
          [i]), ''));
      Playlist1.frmPlaylist1.lbPlaylist.Items.AddStrings
        (Main.FirstPlaylist.ShownFileName);
    end;
end;

procedure TfrmOptiuni.Startup(Sender: TObject);
// Procedura se ocupa de ceea ce trebuie sa faca aceasta fereastra la pornirea ei
begin
  if Main.OptiuniPlayer.GetOptionBoolean(11) then
    // Incarca optiunea de minimizare: pe taskbar sau in systray
    // Daca aleg sa minimizez pe taskbar...
    rgMinimizeTo.ItemIndex := 0
  else // Daca minimizez pe systray...
    rgMinimizeTo.ItemIndex := 1;

  if Main.OptiuniPlayer.GetOptionBoolean(13) then
    // Incarca optiunea de anunt la minimizarea pe systray
    cbNotification.Checked := true
  else
    cbNotification.Checked := false;

  case Main.OptiuniPlayer.GetOptionInteger(12) of
    { Incarca optiunea asupra ferestrei/ferestrelor de playlist care sa fie
      incarcate odata cu playerul, la pornirea acestuia }
    0:
      rgPlaylistStartup.ItemIndex := 0;
    1:
      rgPlaylistStartup.ItemIndex := 1;
    2:
      rgPlaylistStartup.ItemIndex := 2;
    3:
      rgPlaylistStartup.ItemIndex := 3;
  end;

  if Main.OptiuniPlayer.GetOptionBoolean(14) then
    // Incarca numerotarea melodiilor din playlist
    cbPlaylistSongNumbering.Checked := true
  else
    cbPlaylistSongNumbering.Checked := false;
end;

end.
