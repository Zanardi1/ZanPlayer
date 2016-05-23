program ZanPlayer;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmPlayer},
  bass in 'bass.pas',
  Playlist1 in 'Playlist1.pas' {frmPlaylist1},
  Playlist2 in 'Playlist2.pas' {frmPlaylist2},
  Optiuni in 'Optiuni.pas' {frmOptiuni},
  GestionareOptiuni in 'GestionareOptiuni.pas',
  DeleteSong in 'DeleteSong.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ZanPlayer';
  Application.CreateForm(TfrmPlayer, frmPlayer);
  Application.CreateForm(TfrmPlaylist1, frmPlaylist1);
  Application.CreateForm(TfrmPlaylist2, frmPlaylist2);
  Application.Run;
end.
