unit Playlist1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus, BASS, System.AnsiStrings, DeleteSong;

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
var
  f: TextFile; // se ocupa de playlistul incarcat
  OldNumberOfSongs, i: integer;
  { OldNumberOfSongs retine numarul de melodii dinaintea incarcarii playlistului.
    Aceasta variabila este utila deoarece prelucrarile care sunt facute dupa
    incarcarea playlistului se fac numai asupra melodiilor noi, adica asupra celor
    cu un numar de ordine mai mare decat OldNumberOfSongs;
    i e variabila de ciclare }
  buffer: string; // retine ce anume se citeste din fisierul text
begin
  if odAddAPlaylist.Execute then
    begin
      OldNumberOfSongs := Main.FirstPlaylist.FileName.Count;
      // retine numarul vechi de melodii
      Assignfile(f, odAddAPlaylist.FileName);
      Reset(f); // Deschide fisierul selectat
      if UpperCase(ExtractFileExt(odAddAPlaylist.FileName)) = '.PLS' then
        // Daca se incarca un playlist PLS, atunci...
        begin
          { Algoritmul de incarcare al unui PLS este urmatorul:
            1. Citesc primul rand din fisier. Daca acela este '[playlist]', atunci
            continui. Daca nu, atunci ies din procedura.
            2. Atata timp cat nu am ajuns la capatul fisierului, execut:
            2.1. Citesc urmatorul rand din fisier. Pentru a vedea care la dintre
            inregistrarile din fisier am ajuns, ma uit la primul cuvant. Acesta este
            unul dintre cuvintele 'File', 'Title', 'Length', 'NumberOfEntries' sau
            'Version'. Pe mine ma intereseaza primele 3, deci tratez numai aceste
            cazuri. Pe viitor, poate voi trata si urmatoarele doua.
            2.2. Extrag primul cuvant.
            2.2.1. Daca acel cuvant este 'File', atunci sterg inceputul randului pana
            dau de '=' (sterg inclusiv acest semn). Ce ramane este fisierul de redat,
            inclusiv calea si se duce la lista cu astfel de fisiere.
            2.2.2. Daca acel cuvant este 'Title', atunci sterg inceputul randului,
            pana dau de '=' (sterg inclusiv acest semn). Ce ramane este doar denumirea
            fisierului, care se va duce la lista cu astfel de fisiere si in playlistul
            ferestrei de playlist.
            2.2.3. Daca acel cuvant este 'Length', atunci voi trata acest caz mai tarziu
            3. Creez handle-urile pentru fisierele nou adaugate. }
          readln(f, buffer);
          { primul rand din fisier ar trebui sa contina textul '[playlist]'.
            Programul verifica acest lucru. Daca primul rand nu contine acest text,
            atunci este posibil ca fisierul sa nu aiba sintaxa necesara, motiv pentru
            care il inchide si iese din procedura. }
          if CompareStr(buffer, '[playlist]') <> 0 then
            // daca nu citeste '[playlist]', atunci iese din procedura
            begin
              MessageBox(Application.Handle,
                'Fisierul incarcat nu are formatul necesar. E posibil sa fie corupt. Incarcarea lui nu va continua',
                'Eroare la incarcarea playlistului', MB_OK or MB_ICONHAND);
              // Afiseaza mesajul de eroare
              CloseFile(f); // Inchide fisierul
              exit; // Iese din procedura
            end
          else // Daca citeste '[playlist]' din fisier, atunci continua prelucrarea
            begin
              while not eof(f) do
                // Citesc din fisier atata timp cat nu am ajuns la finalul acestuia
                begin
                  readln(f, buffer); // Citesc un rand din fisier
                  if AnsiStartsStr('File', buffer) then
                    // Daca citeste o inregistrare de tip 'File#=...', atunci...
                    begin
                      delete(buffer, 1, 6);
                      // Sterge inceputul sirului, inclusiv '=';
                      Main.FirstPlaylist.FileName.Add(buffer);
                      // Adauga ce a ramas in playlistul din memorie
                    end;
                  if AnsiStartsStr('Title', buffer) then
                    // Daca citeste o inregistrare de tip 'Title#=...', atunci...
                    begin
                      delete(buffer, 1, 7);
                      // Sterge inceputul sirului, inclusiv '='
                      if Main.OptiuniPlayer.GetOptionBoolean(14) then
                        // Daca am ales numerotarea playlistului...
                        buffer := IntToStr
                          (Main.FirstPlaylist.ShownFileName.Count + 1) + '. ' +
                          ChangeFileExt(buffer, '')
                      else // Daca am dezactivat numerotarea playlistului...
                        buffer := ChangeFileExt(buffer, '');
                      Main.FirstPlaylist.ShownFileName.Add(buffer);
                      lbPlaylist.Items.Add(buffer);
                      // Adauga melodiile si in fereastra de playlist
                    end;
                  if AnsiStartsStr('Length', buffer) then
                    // Daca citeste o inregistrare de tip 'Length#=...', atunci...
                    begin
                      { Momentan nu face nimic. Aici va fi cod, in versiunile viitoare. In principiu,
                        programul ar trebui sa citeasca lungimea piesei si sa o puna automat in playlistul
                        afisat in fereastra de playlist. Dar asta va fi mai incolo }
                    end;
                end;
            end;
          SetLength(Main.FirstPlaylist.ID, Main.FirstPlaylist.FileName.Count);
          for i := OldNumberOfSongs to Main.FirstPlaylist.FileName.Count - 1 do
            Main.FirstPlaylist.ID[i] := BASS.BASS_StreamCreateFile(false,
              PChar(Main.FirstPlaylist.FileName[i]), 0, 0, BASS_UNICODE);
          // Adauga si handle-urile melodiilor citite
        end;
      if UpperCase(ExtractFileExt(odAddAPlaylist.FileName)) = '.M3U' then
        // Daca se incarca un playlist M3U, atunci...
        begin
          { Algoritmul de citire al unui M3U este urmatorul:
            1. Citesc primul rand din fisier. Daca acesta este 'M3U', atunci merg mai
            departe. Daca nu este, atunci afisez un mesaj de eroare si ies din procedura
            2. Atata timp cat nu am ajuns la capatul fisierului execut:
            2.1. Citesc urmatorul rand;
            2.2. Daca acel rand contine textul '#EXTINF:', atunci:
            2.2.1. Sterg textul de mai sus.
            2.2.2. Sterg textul ramas, pana ajung la ',' (sterg si acest caracter).
            Ce am sters acum reprezinta durata melodiei. In viitor voi reveni si voi
            citi si acest parametru, pe care il voi pune in playlistul ferestrei de
            playlist, langa melodia incarcata.
            2.2.3. Ce a ramas reprezinta denumirea fisierului. O pun in colectia ei
            si in playlistul ferestrei de playlist
            2.3. Daca randul citit nu contine textul '#EXTINF:' atunci el contine
            denumirea fisierului, inclusiv calea catre el. Aceasta denumire o pun
            in colectia ei.
            3. Creez handle-urile pentru fisierele nou adaugate. }
          readln(f, buffer);
          { Pe primul rand, fisierul ar trebui sa contina textul '#EXTM3U'. Programul
            verifica acest lucru. Daca acest text nu e gasit pe primul rand, incarcarea se
            opreste }
          if CompareStr(buffer, '#EXTM3U') <> 0 then
            { Daca nu gaseste textul '#EXTM3U', atunci afiseaza un mesaj de eroare si iese
              din procedura }
            begin
              MessageBox(Application.Handle,
                'Fisierul incarcat nu are formatul necesar. E posibil sa fie corupt. Incarcarea lui nu va continua',
                'Eroare la incarcarea playlistului', MB_OK or MB_ICONHAND);
              // Afiseaza mesajul de eroare
              CloseFile(f); // Inchide fisierul
              exit; // Iese din procedura
            end
          else // Daca a gasit pe primul rand ceea ce se astepta sa gaseasca, prelucreaza restul fisierului.
            begin
              while not eof(f) do
                begin
                  readln(f, buffer); // Citeste urmatorul rand din sir
                  if AnsiStartsStr('#EXTINF:', buffer) then
                    // Daca dau de un rand care incepe cu '#EXTINF'...
                    begin
                      delete(buffer, 1, 9); // Sterg textul '#EXTINF:'
                      { Aici vine partea in care citesc lungimea melodiei si o scriu in playlistul
                        ferestrei de playlist. Pentru ca inca nu ma ocup de asa ceva, momentan o sa sterg
                        si aceasta parte. Mai incolo o sa revin si o sa rescriu codul, astfel incat sa
                        tratez si citirea lungimii melodiei }
                      delete(buffer, 1, AnsiPos(',', buffer));
                      // Sterg si lungimea melodiei
                      buffer := IntToStr(Main.FirstPlaylist.ShownFileName.Count
                        + 1) + '. ' + ChangeFileExt(buffer, '');
                      Main.FirstPlaylist.ShownFileName.Add(buffer);
                      lbPlaylist.Items.Add(buffer);
                    end
                  else
                    { Daca a ajuns pe ramura aceasta, inseamna ca e pe randul in care citeste caile
                      catre fisiere }
                    Main.FirstPlaylist.FileName.Add(buffer);
                  SetLength(Main.FirstPlaylist.ID,
                    Main.FirstPlaylist.FileName.Count);
                  for i := OldNumberOfSongs to Main.FirstPlaylist.FileName.
                    Count - 1 do
                    Main.FirstPlaylist.ID[i] :=
                      BASS.BASS_StreamCreateFile(false,
                      PChar(Main.FirstPlaylist.FileName[i]), 0, 0,
                      BASS_UNICODE);
                  // Adauga si handle-urile melodiilor citite
                end;
            end;
        end;
      CloseFile(f);
    end;
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
{Procedura se ocupa cu stergerea melodiilor din playlist}
var SD:SongDelete;
begin
  SD:=DeleteSong.SongDelete.Create;
  SD.FreeOnTerminate:=true;
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
var
  f: TextFile; // retine fisierul in care va fi salvat playlistul
  i: integer; // variabila de ciclare
begin
  if sdSaveToPlaylist.Execute then
    // Daca utilizatorul alege un nume pentru playlist, atunci...
    begin
      Assignfile(f, sdSaveToPlaylist.FileName);
      // ... incepe salvarea propriu-zisa
      Rewrite(f);
      if UpperCase(ExtractFileExt(sdSaveToPlaylist.FileName)) = '.PLS' then
        // Daca playlistul a fost salvat cu extensia PLS...
        begin
          writeln(f, '[playlist]');
          for i := 0 to FirstPlaylist.FileName.Count - 1 do
            // Scrie informatiile despre fiecare melodie
            begin
              writeln(f, 'File' + IntToStr(i + 1) + '=' +
                FirstPlaylist.FileName[i]);
              writeln(f, 'Title' + IntToStr(i + 1) + '=' +
                FirstPlaylist.ShownFileName[i]);
              writeln(f, 'Length' + IntToStr(i + 1) + '=' +
                IntToStr(Trunc(BASS_ChannelBytes2Seconds(FirstPlaylist.ID[i],
                BASS.BASS_ChannelGetLength(FirstPlaylist.ID[i],
                BASS_POS_BYTE)))));
            end;
          writeln(f, 'NumberOfEntries=' +
            IntToStr(FirstPlaylist.FileName.Count));
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
                BASS.BASS_ChannelGetLength(FirstPlaylist.ID[i], BASS_POS_BYTE)))
                ) + ',' + FirstPlaylist.ShownFileName[i]);
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

  if (Main.OptiuniPlayer.GetOptionInteger(12) = 0) or
    (Main.OptiuniPlayer.GetOptionInteger(12) = 1) then
    { Daca din optiuni e setata afisarea acestei ferestre, o afiseaza. Altfel, o ascunde }
    Show
  else
    Hide;
end;

end.
