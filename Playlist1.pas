unit Playlist1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus, BASS;

type
  TfrmPlaylist1 = class(TForm)
    lbPlaylist: TListBox;
    bitbtnUp: TBitBtn;
    bitbtnDown: TBitBtn;
    bitbtnAddSongs: TBitBtn;
    bitbtnDeleteSongs: TBitBtn;
    bitbtnSaveToPlaylist: TBitBtn;
    pmAddToPlaylist: TPopupMenu;
    miAddSongs: TMenuItem;
    miAddPlaylist: TMenuItem;
    odAddSongsToPlaylist: TOpenDialog;
    pmDeleteFromPlaylist: TPopupMenu;
    miDeleteSongs: TMenuItem;
    miDeletePlaylist: TMenuItem;
    procedure Startup(Sender: TObject);
    procedure ShowPlaylistMenu(Sender: TObject);
    procedure AddSongsToPlaylist(Sender: TObject);
    procedure PlaySelectedSong(Sender: TObject);
    procedure DeletePlaylist(Sender: TObject);
    procedure ShowDeletePlaylistMenu(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPlaylist1: TfrmPlaylist1;
  SongSelected: integer;
  // SongSelected retine pozitia melodiei selectate in playlist;

implementation

uses Main;

{$R *.dfm}

procedure TfrmPlaylist1.AddSongsToPlaylist(Sender: TObject);
// Instructiunile necesare adaugarii uneia sau mai multor melodii la playlist
var
  i: integer;
begin
  odAddSongsToPlaylist.Execute(Application.Handle);
  // Deschide fereastra de selectie a melodiilor
  Main.FirstPlaylist.FileName.AddStrings(odAddSongsToPlaylist.Files);
  // Adauga denumirile fisierelor (+caile catre ele) in structura
  Main.FirstPlaylist.ShownFileName.Clear;
  // Pentru a preveni retinerea aceluiasi fisier de 2+ ori, se sterge toata lista
  for i := 0 to Main.FirstPlaylist.FileName.Count - 1 do
    Main.FirstPlaylist.ShownFileName.Add
      (ExtractFileName(Main.FirstPlaylist.FileName.Strings[i]));
  // Adauga numai denumirile fisierelor, fara cai, in structura
  lbPlaylist.Items.Clear;
  // Pentru a preveni afisarea de 2+ ori a aceluiasi fisier, se sterge lista
  lbPlaylist.Items.AddStrings(Main.FirstPlaylist.ShownFileName);
  // Adauga melodiile selectate in playlist
  SetLength(Main.FirstPlaylist.ID, Main.FirstPlaylist.FileName.Count);
  // Stabileste lungimea colectiei de ID-uri;
  for i := 0 to Length(Main.FirstPlaylist.ID) - 1 do
    Main.FirstPlaylist.ID[i] := BASS.BASS_StreamCreateFile(false,
      PChar(Main.FirstPlaylist.FileName[i]), 0, 0, BASS_UNICODE);
  // Incarca ID-urile
end;

procedure TfrmPlaylist1.DeletePlaylist(Sender: TObject);
// Procedura sterge intreg playlistul incarcat
begin
  lbPlaylist.Clear;
  Main.FirstPlaylist.FileName.Clear;
  Main.FirstPlaylist.ShownFileName.Clear;
  SetLength(Main.FirstPlaylist.ID, 0);
end;

procedure TfrmPlaylist1.PlaySelectedSong(Sender: TObject);
// Procedura se ocupa cu redarea melodiei selectate, daca s-a facut dublu click pe ea
var
  i: integer;
  // i e variabila de ciclare
begin
  i := 0;
  SongSelected := -1;
  // SongSelected=-1 inseamna ca nicio melodie nu a fost aleasa
  while (i <= lbPlaylist.Items.Count - 1) or (SongSelected = -1) do
  begin
    if lbPlaylist.Selected[i] then
      SongSelected := i;
    inc(i);
  end;
  // In structura while..do, programul cauta prima melodie selectata, apoi iese
  Main.frmPlayer.PlaySong(nil);
end;

procedure TfrmPlaylist1.ShowDeletePlaylistMenu(Sender: TObject);
// Atunci cand utilizatorul face click pe buton, apare meniul de stergere a melodiilor
// din playlist
begin
  pmDeleteFromPlaylist.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmPlaylist1.ShowPlaylistMenu(Sender: TObject);
// Atunci cand utilizatorul face click pe buton, apare meniul de adaugare a melodiilor
// in playlist
begin
  pmAddToPlaylist.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmPlaylist1.Startup(Sender: TObject);
// Questii de facut la crearea ferestrei
begin
  Left := Main.OptiuniPlayer.GetOptionInteger(3);
  // Citeste coordonatele ferestrei
  Top := Main.OptiuniPlayer.GetOptionInteger(4);
end;

end.
