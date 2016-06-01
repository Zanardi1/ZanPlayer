unit Playlist1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus, BASS, System.AnsiStrings, DeleteSong,
  ID3ManagementUnit;

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
    odAddAPlaylist: TOpenDialog;
    pmDoAll: TPopupMenu;
    miAddSongs2: TMenuItem;
    miAddPlaylist2: TMenuItem;
    miDeleteSongs2: TMenuItem;
    miDeletePlaylist2: TMenuItem;
    miSaveToPlaylist: TMenuItem;
    miShowID3Tags: TMenuItem;
    procedure Startup(Sender: TObject);
    procedure ShowPlaylistMenu(Sender: TObject);
    procedure AddSongsToPlaylist(Sender: TObject);
    procedure PlaySelectedSong(Sender: TObject);
    procedure DeletePlaylist(Sender: TObject);
    procedure ShowDeletePlaylistMenu(Sender: TObject);
    procedure SaveToPlaylist(Sender: TObject);
    procedure AddAnotherPlaylist(Sender: TObject);
    procedure MoveUpOnePos(Sender: TObject);
    procedure MoveDownOnePos(Sender: TObject);
    procedure DeleteSongs(Sender: TObject);
    procedure ShowID3Tags(Sender: TObject);
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

procedure TfrmPlaylist1.AddAnotherPlaylist(Sender: TObject);
// Procedura se ocupa de incarcarea unui playlist nou

begin
  if odAddAPlaylist.Execute then
    Main.frmPlayer.PlaylistLoadingEngine(odAddAPlaylist.FileName);
end;

procedure TfrmPlaylist1.AddSongsToPlaylist(Sender: TObject);
// Instructiunile necesare adaugarii uneia sau mai multor melodii la playlist
var
  i: integer; // variabila de ciclare
begin
  if odAddSongsToPlaylist.Execute(Application.Handle) then
    begin
      // Deschide fereastra de selectie a melodiilor
      Main.FirstPlaylist.FileName.AddStrings(odAddSongsToPlaylist.Files);
      // Adauga denumirile fisierelor (+caile catre ele) in structura
      Main.FirstPlaylist.ShownFileName.Clear;
      // Pentru a preveni retinerea aceluiasi fisier de 2+ ori, se sterge toata lista
      for i := 0 to Main.FirstPlaylist.FileName.Count - 1 do
        begin
          if Main.OptiuniPlayer.GetOptionBoolean(14) then
            // Daca am ales activarea numerotarii playlistului...
            Main.FirstPlaylist.ShownFileName.Add(IntToStr(i + 1) + '. ' +
              ChangeFileExt(ExtractFileName(Main.FirstPlaylist.FileName.
              Strings[i]), ''))
          else // Daca am ales dezactivarea numerotarii playlistului...
            Main.FirstPlaylist.ShownFileName.Add
              (ChangeFileExt(ExtractFileName(Main.FirstPlaylist.FileName.Strings
              [i]), ''));
        end;
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

procedure TfrmPlaylist1.DeleteSongs(Sender: TObject);
{ Procedura se ocupa cu stergerea melodiilor din playlist }
var
  SD: SongDelete;
begin
  SD := DeleteSong.SongDelete.Create;
  SD.FreeOnTerminate := true;
end;

procedure TfrmPlaylist1.MoveDownOnePos(Sender: TObject);
{ Procedura muta melodia selectata cu o pozitie in jos. Pentru asta, ea cauta in
  tot playlistul, mai putin ultima melodie, sa vada care melodii sunt selectate.
  Pe acestea le muta cu o pozitie mai jos. Motivul pentru care nu cauta in ultima
  melodie este evident: nu poti schimba aceasta melodie cu una aflata pe o pozitie
  mai joasa, pentru ca nu exista acea pozitie }
var
  i, aux: integer;
  // i = variabila de ciclare
  // aux = variabila care va fi folosita la interschimbarea ID-urilor melodiilor
  // din playlist
begin
  if lbPlaylist.Selected[lbPlaylist.Items.Count - 1] then
    MessageBox(Application.Handle,
      PChar('Nu poti muta cu o pozitie mai jos prima melodie din playlist!'),
      PChar('Eroare!'), MB_OK or MB_ICONHAND);
  for i := lbPlaylist.Items.Count - 2 downto 0 do
    // Se uita prin restul playlistului
    begin
      if lbPlaylist.Selected[i] then // Daca a gasit un element selectat...
        begin
          { Schimba intre ele melodiile din playlist, precum si din reprezentarea
            interna a acestuia }
          lbPlaylist.Items.Exchange(i, i + 1);
          Main.FirstPlaylist.FileName.Exchange(i, i + 1);
          Main.FirstPlaylist.ShownFileName.Exchange(i, i + 1);
          aux := Main.FirstPlaylist.ID[i];
          Main.FirstPlaylist.ID[i] := Main.FirstPlaylist.ID[i + 1];
          Main.FirstPlaylist.ID[i + 1] := aux;
          if OptiuniPlayer.GetOptionBoolean(14) then
            // Numeroteaza melodiile, dupa interschimbare, daca utilizatorul a vrut asta.
            // Aici a vrut numerotare...
            begin
              Main.FirstPlaylist.ShownFileName[i + 1] := IntToStr(i + 2) + '. '
                + ChangeFileExt
                (ExtractFileName(Main.FirstPlaylist.FileName[i + 1]), '');
              Main.FirstPlaylist.ShownFileName[i] := IntToStr(i + 1) + '. ' +
                ChangeFileExt
                (ExtractFileName(Main.FirstPlaylist.FileName[i]), '');
            end
          else // ... aici nu a vrut
            begin
              Main.FirstPlaylist.ShownFileName[i + 1] :=
                ChangeFileExt
                (ExtractFileName(Main.FirstPlaylist.FileName[i + 1]), '');
              Main.FirstPlaylist.ShownFileName[i] :=
                ChangeFileExt
                (ExtractFileName(Main.FirstPlaylist.FileName[i]), '');
            end;

          lbPlaylist.Items[i + 1] := Main.FirstPlaylist.ShownFileName[i + 1];
          lbPlaylist.Items[i] := Main.FirstPlaylist.ShownFileName[i];

          lbPlaylist.Selected[i + 1] := true;
        end;
    end;
end;

procedure TfrmPlaylist1.MoveUpOnePos(Sender: TObject);
{ Procedura muta melodia selectata cu o pozitie in sus. Pentru asta, ea cauta in
  tot playlistul, mai putin prima melodie, sa vada care melodii sunt selectate.
  Pe acestea le muta cu o pozitie mai sus. Motivul pentru care nu cauta in prima
  melodie este evident: nu poti schimba aceasta melodie cu una aflata pe o pozitie
  mai ridicata, pentru ca nu exista acea pozitie }
var
  i, aux: integer;
  // i = variabila de ciclare
  // aux = variabila care va fi folosita la interschimbarea ID-urilor melodiilor
  // din playlist
begin
  if lbPlaylist.Selected[0] then
    MessageBox(Application.Handle,
      PChar('Nu poti muta cu o pozitie mai sus prima melodie din playlist!'),
      PChar('Eroare!'), MB_OK or MB_ICONHAND);
  for i := 1 to lbPlaylist.Items.Count - 1 do
    // Se uita prin restul playlistului
    begin
      if lbPlaylist.Selected[i] then // Daca a gasit un element selectat...
        begin
          { Schimba intre ele melodiile din playlist, precum si din reprezentarea
            interna a acestuia }
          lbPlaylist.Items.Exchange(i, i - 1);
          Main.FirstPlaylist.FileName.Exchange(i, i - 1);
          Main.FirstPlaylist.ShownFileName.Exchange(i, i - 1);
          aux := Main.FirstPlaylist.ID[i];
          Main.FirstPlaylist.ID[i] := Main.FirstPlaylist.ID[i - 1];
          Main.FirstPlaylist.ID[i - 1] := aux;

          if OptiuniPlayer.GetOptionBoolean(14) then
            // Numeroteaza melodiile, dupa interschimbare, daca utilizatorul a vrut asta.
            // Aici a vrut numerotare...
            begin
              Main.FirstPlaylist.ShownFileName[i - 1] := IntToStr(i) + '. ' +
                ChangeFileExt
                (ExtractFileName(Main.FirstPlaylist.FileName[i - 1]), '');
              Main.FirstPlaylist.ShownFileName[i] := IntToStr(i + 1) + '. ' +
                ChangeFileExt
                (ExtractFileName(Main.FirstPlaylist.FileName[i]), '');
            end
          else // ... aici nu a vrut
            begin
              Main.FirstPlaylist.ShownFileName[i - 1] :=
                ChangeFileExt
                (ExtractFileName(Main.FirstPlaylist.FileName[i - 1]), '');
              Main.FirstPlaylist.ShownFileName[i] :=
                ChangeFileExt
                (ExtractFileName(Main.FirstPlaylist.FileName[i]), '');
            end;

          lbPlaylist.Items[i - 1] := Main.FirstPlaylist.ShownFileName[i - 1];
          lbPlaylist.Items[i] := Main.FirstPlaylist.ShownFileName[i];

          lbPlaylist.Selected[i - 1] := true;
        end;
    end;
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
begin
  if sdSaveToPlaylist.Execute then
    // Daca utilizatorul alege un nume pentru playlist, atunci...
    Main.frmPlayer.PlaylistSavingEngine(sdSaveToPlaylist.FileName);
end;

procedure TfrmPlaylist1.ShowDeletePlaylistMenu(Sender: TObject);
// Atunci cand utilizatorul face click pe buton, apare meniul de stergere a melodiilor
// din playlist
begin
  pmDeleteFromPlaylist.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmPlaylist1.ShowID3Tags(Sender: TObject);
// Procedura afiseaza tag-urile melodiei alese
var
  ID3: TfrmID3;
begin
  ID3 := TfrmID3.Create(1);
  ID3.ShowModal;
  ID3.Free;
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

  if (Main.OptiuniPlayer.GetOptionInteger(12) = 0) or
    (Main.OptiuniPlayer.GetOptionInteger(12) = 1) then
    { Daca din optiuni e setata afisarea acestei ferestre, o afiseaza. Altfel, o ascunde }
    Show
  else
    Hide;

  if FileExists(GetCurrentDir + '\Pl1.pls') then
    // Daca exista fisierul 'Pl1.pls', cel in care s-au salvat melodiile incarcate
    // in momentul inchiderii programului, atunci il incarca
    Main.frmPlayer.PlaylistLoadingEngine('Pl1.pls');

  EnableMenuItem(GetSystemMenu(Handle, false), SC_CLOSE, MF_BYCOMMAND or
    MF_GRAYED); // Dezactivez butonul de inchidere
end;

end.
