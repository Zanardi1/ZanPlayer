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
    sdSaveToPlaylist: TSaveDialog;
    procedure Startup(Sender: TObject);
    procedure ShowPlaylistMenu(Sender: TObject);
    procedure AddSongsToPlaylist(Sender: TObject);
    procedure PlaySelectedSong(Sender: TObject);
    procedure DeletePlaylist(Sender: TObject);
    procedure ShowDeletePlaylistMenu(Sender: TObject);
    procedure SaveToPlaylist(Sender: TObject);
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
  if odAddSongsToPlaylist.Execute(Application.Handle) then
  begin
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
  i, PreviousSong: integer;
  { i e variabila de ciclare
    PreviousSong retine numarul de ordine al melodiei care a fost cantata ultima data.
    Utilitatea acestei variabile este acea in care melodia care a fost cantata
    inainte este oprita si apoi este cantata noua melodie }
begin
  i := 0;
  PreviousSong := SongSelected;
  SongSelected := -1;
  // SongSelected=-1 inseamna ca nicio melodie nu a fost aleasa
  while (i <= lbPlaylist.Items.Count - 1) or (SongSelected = -1) do
  begin
    if lbPlaylist.Selected[i] then
      SongSelected := i;
    inc(i);
  end;
  // In structura while..do, programul cauta prima melodie selectata, apoi iese
  BASS.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
  BASS.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
    BASS_POS_BYTE);
  Main.frmPlayer.PlaySong(nil);
end;

procedure TfrmPlaylist1.SaveToPlaylist(Sender: TObject);
// Procedura se ocupa de salvarea playlistului intr-un fisier cu extensia *.pls
// Sintaxa unui fisier PLS se afla la:
// http://forums.winamp.com/showthread.php?threadid=65772
var
  f: TextFile; // retine fisierul in care va fi salvat playlistul
  i: integer; // variabila de ciclare
begin
  if sdSaveToPlaylist.Execute then
  // Daca utilizatorul alege un nume pentru playlist, atunci...
  begin
    AssignFile(f, sdSaveToPlaylist.FileName);
    // ... incepe salvarea propriu-zisa
    Rewrite(f);
    if UpperCase(ExtractFileExt(sdSaveToPlaylist.FileName)) = '.PLS' then
    // Daca playlistul a fost salvat cu extensia PLS...
    begin
      writeln(f, '[playlist]');
      for i := 0 to FirstPlaylist.FileName.Count - 1 do
      // Scrie informatiile despre fiecare melodie
      begin
        writeln(f, 'File' + IntToStr(i + 1) + '=' + FirstPlaylist.FileName[i]);
        writeln(f, 'Title' + IntToStr(i + 1) + '=' +
          FirstPlaylist.ShownFileName[i]);
        writeln(f, 'Length' + IntToStr(i + 1) + '=' +
          IntToStr(Trunc(BASS_ChannelBytes2Seconds(FirstPlaylist.ID[i],
          BASS.BASS_ChannelGetLength(FirstPlaylist.ID[i], BASS_POS_BYTE)))));
      end;
      writeln(f, 'NumberOfEntries=' + IntToStr(FirstPlaylist.FileName.Count));
      writeln(f, 'Version=2');
      CloseFile(f);
      MessageBox(Application.Handle, 'Salvare efectuata!', 'Succes!',
        MB_OK or MB_ICONASTERISK);
      exit;
    end;
    if UpperCase(ExtractFileExt(sdSaveToPlaylist.FileName)) = '.M3U' then
    // Daca playlistul a fost salvat cu extensia M3U...
    begin
      writeln(f, '#EXTM3U');
      for i := 0 to FirstPlaylist.FileName.Count - 1 do
      begin
        writeln(f, '#EXTINF:' +
          IntToStr(Trunc(BASS_ChannelBytes2Seconds(FirstPlaylist.ID[i],
          BASS.BASS_ChannelGetLength(FirstPlaylist.ID[i], BASS_POS_BYTE)))) +
          ',' + FirstPlaylist.ShownFileName[i]);
        writeln(f, FirstPlaylist.FileName[i])
      end;
      CloseFile(f);
      MessageBox(Application.Handle, 'Salvare efectuata!', 'Succes!',
        MB_OK or MB_ICONASTERISK);
      exit;
    end;
  end;
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
