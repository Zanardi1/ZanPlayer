program ZanPlayer;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmPlayer},
  bass in 'bass.pas',
  Playlist1 in 'Playlist1.pas' {frmPlaylist1},
  Playlist2 in 'Playlist2.pas' {frmPlaylist2},
  Optiuni in 'Optiuni.pas' {frmOptiuni},
  GestionareOptiuni in 'GestionareOptiuni.pas',
  DeleteSong in 'DeleteSong.pas',
  ID3v1Library in 'ID3v1Library.pas',
  ID3v2Library in 'ID3v2Library.pas',
  ID3ManagementUnit in 'ID3ManagementUnit.pas' {frmID3},
  Egalizator in 'Egalizator.pas' {frmEqualizer},
  About in 'About.pas' {frmAbout};

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
