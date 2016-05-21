unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Bass,
  Playlist1, Playlist2, Vcl.ExtCtrls, Optiuni, Math, GestionareOptiuni;

type
  TfrmPlayer = class(TForm)
    lblTimer: TLabel;
    pbProgressBar: TProgressBar;
    bitbtnPlay: TBitBtn;
    bitbtnPause: TBitBtn;
    bitbtnStop: TBitBtn;
    bitbtnNext: TBitBtn;
    bitbtnMute: TBitBtn;
    bitbtnPrevious: TBitBtn;
    tbVolume: TTrackBar;
    bitbtnRandom: TBitBtn;
    bitbtnShuffle: TBitBtn;
    lblSongName: TLabel;
    bitbtnPlaylist1: TBitBtn;
    bitbtnPlaylist2: TBitBtn;
    shRepLED: TShape;
    shShfLED: TShape;
    bitbtnOptions: TBitBtn;
    Timer1: TTimer;
    ttiMinimizeTo: TTrayIcon;
    procedure Startup(Sender: TObject);
    procedure ToggleFirstPlaylist(Sender: TObject);
    procedure ToggleSecondPlaylist(Sender: TObject);
    procedure ToggleRepStatus(Sender: TObject);
    procedure ToggleShuffleStatus(Sender: TObject);
    procedure ShowOptionsWindow(Sender: TObject);
    procedure PlaySong(Sender: TObject);
    procedure ChangeSongVolume(Sender: TObject);
    procedure PauseSong(Sender: TObject);
    procedure StopSong(Sender: TObject);
    procedure MuteOrSoundSong(Sender: TObject);
    procedure ProcessEvents(Sender: TObject);
    procedure MoveSongToPosition(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Bye(Sender: TObject);
    procedure PlayNextSong(Sender: TObject);
    procedure PlayPreviousSong(Sender: TObject);
  private
    { Private declarations }
    TempVolume: Integer;
    // retine volumul dinainte de a face click pe butonul Mute
    Paused: boolean;
    // Retine daca melodia care este redata este in pauza sau nu

    procedure SkipToNextSong;
    procedure SkipToPreviousSong;
    procedure UnselectUnplayedSongs(SongNo: Integer);
  public
    { Public declarations }
  end;

  PlaylistInfo = record
    FileName: TStrings;
    ShownFileName: TStrings;
    ID: array of HSTREAM;
  end;

  // Structura PlaylistInfo retine anumite lucruri despre playlisturi, lucruri
  // importante pentru player si din punct de vedere al interfetei:
  // 1. FileName retine fisierele, cu caile lor, incarcate in playlist. E util
  // pentru player, sa stie ce melodii sa redea;
  // 2. ShownFileName retine numele fisierelor retinute in FileName. E util
  // din motive de prezentare, caci aceste denumiri vor fi aratate in fereastra
  // de playlist;
  // 3. ID retine valorile intoarse de catre functia BASS_StreamCreateFile, functie
  // care trebuie apelata, avand ca parametru fiecare dintre fisierele incarcate.
  // ID e util in cazul redarii fisierelor de catre player

var
  frmPlayer: TfrmPlayer;
  FirstPlaylist: PlaylistInfo;
  OptiuniPlayer: TOptiuni; // instanta pentru clasa TOptiuni;

implementation

{$R *.dfm}

function AddLeadingZeroes(const aNumber, Length: Integer): string;
// Functia adauga zerouri in fata unui numar si intoarce sirul rezultat.
// aNumber retine numarul in fata caruia trebuie adaugate zerourile;
// Length retine lungimea finala pe care trebuie sa o aiba numarul.
// Din aceste doua variabile reiese ca functia va adauga
// (Length-numarul de cifre al lui aNumber) zerouri
begin
  result := Format('%.*d', [Length, aNumber]);
end;

procedure TfrmPlayer.UnselectUnplayedSongs(SongNo: Integer);
// Procedura deselecteaza din playlist toate melodiile care nu sunt redate. Melodia
// SongNo este cea redata si pe ea o selecteaza
var
  i: Integer;
begin
  for i := 0 to SongNo - 1 do
    Playlist1.frmPlaylist1.lbPlaylist.Selected[i] := false;
  // Deselecteaza melodiile dinaintea melodiei selectate

  for i := SongNo + 1 to FirstPlaylist.FileName.Count - 1 do
    // Deselecteaza melodiile de dupa cea selectata
    Playlist1.frmPlaylist1.lbPlaylist.Selected[i] := false;

  Playlist1.frmPlaylist1.lbPlaylist.Selected[SongNo] := true;
  // Selecteaza melodia care trebuie
end;

procedure TfrmPlayer.PlayPreviousSong(Sender: TObject);
// Aceasta procedura se ocupa de tot ce trebuie facut pentru a trece la melodia
// precedenta, din butonul destinat acestui lucru
begin
  SkipToPreviousSong;
end;

procedure TfrmPlayer.SkipToNextSong;
// Procedura de ocupa de ce trebuie facut pentru a trece la melodia urmatoare
// din playlist
var
  PreviousSong: Integer;
  { Retine numarul de ordine al melodiei care a fost cantata ultima data.
    Utilitatea acestei variabile este acea in care melodia care a fost cantata
    inainte este oprita si apoi este cantata noua melodie }
begin
  if FirstPlaylist.FileName.Count = 0 then
    // Daca playlistul este gol, atunci...
    exit; // ...iese din procedura
  PreviousSong := SongSelected;
  inc(SongSelected);
  // Creste numarul melodiei selectate cu 1 (<=> trece la melodia urmatoare)
  if FirstPlaylist.FileName.Count = 1 then
    { Din motive pe care nu le descopar, pentru ca aceasta procedura sa functioneze
      corect, trebuie luate separat cazurile in care playlistul are o singura melodie
      si cazul in care playlistul are 2+ melodii, desi algoritmul de functionare este,
      in ambele cazuri, acelasi. }
    begin
      if OptiuniPlayer.GetOptionBoolean(8) then
        // Daca e activata repetarea, atunci o ia de la capatul playlistului
        begin
          SongSelected := 0;
          UnselectUnplayedSongs(0);
          Bass.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
          Bass.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
            BASS_POS_BYTE);
          PlaySong(Application);
        end
      else if OptiuniPlayer.GetOptionBoolean(9) then
        // Daca e activata redarea amestecata atunci reda singura melodie din playlist
        begin
          Randomize;
          SongSelected := random(1);
          Bass.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
          Bass.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
            BASS_POS_BYTE);
          PlaySong(Application);
        end
      else // "Cazul normal"
        begin
          Timer1.Enabled := false;
          BASS_ChannelStop(FirstPlaylist.ID[0]);
          BASS_ChannelSetPosition(FirstPlaylist.ID[0], 0, BASS_POS_BYTE);
        end;
    end
  else if SongSelected > FirstPlaylist.FileName.Count - 1 then
    // Daca playlistul are 2+ melodii si a ajuns la capatul playlistului...
    begin
      if OptiuniPlayer.GetOptionBoolean(8) then
        // Daca e activata repetarea, atunci o ia de la capatul playlistului
        begin
          SongSelected := 0;
          UnselectUnplayedSongs(SongSelected);
          // Selecteaza melodia care se reda
          Bass.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
          Bass.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
            BASS_POS_BYTE);
          PlaySong(Application); // Reda melodia selectata
        end
      else
        begin
          Timer1.Enabled := false;
          BASS_ChannelStop(FirstPlaylist.ID[SongSelected - 1]);
          // Opreste ultima melodie redata
          BASS_ChannelSetPosition(FirstPlaylist.ID[SongSelected - 1], 0,
            BASS_POS_BYTE); // Aduce la 0 ultima melodie redata
        end;
    end
  else // Daca nu a ajuns la capat...
    begin
      if OptiuniPlayer.GetOptionBoolean(9) then
        // Daca e activata redarea amestecata
        begin
          Randomize;
          SongSelected := random(FirstPlaylist.FileName.Count + 1);
          // alege un numar aleatoriu
          Bass.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
          Bass.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
            BASS_POS_BYTE);
          UnselectUnplayedSongs(SongSelected);
          // Selecteaza melodia care se reda
          PlaySong(Application); // Reda melodia selectata
        end
      else // Daca e dezactivata redarea amestecata (cazul "normal")
        begin
          Bass.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
          Bass.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
            BASS_POS_BYTE);
          UnselectUnplayedSongs(SongSelected);
          // Selecteaza melodia care se reda
          PlaySong(Application); // Reda melodia selectata
        end;
    end;
end;

procedure TfrmPlayer.SkipToPreviousSong;
// Procedura de ocupa de ce trebuie facut pentru a trece la melodia precedenta
// din playlist
var
  PreviousSong: Integer;
  { Retine numarul de ordine al melodiei care a fost cantata ultima data.
    Utilitatea acestei variabile este acea in care melodia care a fost cantata
    inainte este oprita si apoi este cantata noua melodie }
begin
  if FirstPlaylist.FileName.Count = 0 then
    exit; // Daca playlistul este gol, atunci iese din procedura
  PreviousSong := SongSelected; // Retine melodia recent redata
  dec(SongSelected);
  if SongSelected < 0 then
    // Daca a ajuns la capatul de inceput al playlistului si playlistul nu este
    // gol, atunci opreste melodia care se reda si iese din procedura, caci nu
    // mai are ce face.
    begin
      Bass.BASS_ChannelStop(FirstPlaylist.ID[0]); // Opreste prima melodie
      SongSelected := 0;
      // Alege ca melodie care se reda prima piesa din playlist
      Timer1.Enabled := false;
      exit;
    end;
  // Scade numarul melodiei selectate cu 1 (<=> trece la melodia precedenta)
  if FirstPlaylist.FileName.Count = 1 then
    { Din motive pe care nu le descopar, pentru ca aceasta procedura sa functioneze
      corect, trebuie luate separat cazurile in care playlistul are o singura melodie
      si cazul in care playlistul are 2+ melodii, desi algoritmul de functionare este,
      in ambele cazuri, acelasi. }
    begin
      if OptiuniPlayer.GetOptionBoolean(8) then
        // Daca e activata repetarea, atunci nu face nimic (mai jos e scris de ce)
        begin
          // Nu face nimic. Melodiile se canta, in mod normal, de la prima spre ultima, nu invers
        end
      else if OptiuniPlayer.GetOptionBoolean(9) then
        // Daca e activata redarea amestecata, atunci canta singura melodie din playlist
        begin
          Randomize;
          SongSelected := random(1);
          Bass.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
          Bass.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
            BASS_POS_BYTE);
          PlaySong(Application);
        end
      else // "Cazul normal"
        begin
          BASS_ChannelStop(FirstPlaylist.ID[0]);
          BASS_ChannelSetPosition(FirstPlaylist.ID[0], 0, BASS_POS_BYTE);
        end;
    end
  else if SongSelected > FirstPlaylist.FileName.Count - 1 then
    // Daca playlistul are 2+ melodii si a ajuns la capatul playlistului...
    begin
      if OptiuniPlayer.GetOptionBoolean(8) then
        // Daca e activata repetarea, atunci nu face nimic (mai jos e scris de ce)
        begin
          // Nu face nimic. Melodiile se canta, in mod normal, de la prima spre ultima, nu invers
        end
      else
        begin
          BASS_ChannelStop(FirstPlaylist.ID[SongSelected - 1]);
          // Opreste ultima melodie redata
          BASS_ChannelSetPosition(FirstPlaylist.ID[SongSelected - 1], 0,
            BASS_POS_BYTE); // Aduce la 0 ultima melodie redata
        end;
    end
  else // Daca nu a ajuns la capat...
    begin
      if OptiuniPlayer.GetOptionBoolean(9) then
        // Daca e activata redarea amestecata
        begin
          Randomize;
          SongSelected := random(FirstPlaylist.FileName.Count + 1);
          // alege un numar aleatoriu
          Bass.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
          Bass.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
            BASS_POS_BYTE);
          UnselectUnplayedSongs(SongSelected);
          // Selecteaza melodia care se reda
          PlaySong(Application); // Reda melodia selectata
        end
      else // Daca e dezactivata redarea amestecata (cazul "normal")
        begin
          Bass.BASS_ChannelStop(FirstPlaylist.ID[PreviousSong]);
          Bass.BASS_ChannelSetPosition(FirstPlaylist.ID[PreviousSong], 0,
            BASS_POS_BYTE);
          UnselectUnplayedSongs(SongSelected);
          // Selecteaza melodia care se reda
          PlaySong(Application); // Reda melodia selectata
        end;
    end;
end;

procedure TfrmPlayer.Bye(Sender: TObject);
// Lucrurile efectuate la oprirea programului
begin
  OptiuniPlayer.SetOptionInteger(1, Left);
  // Salveaza coordonatele ferestrei de player
  OptiuniPlayer.SetOptionInteger(2, Top);

  OptiuniPlayer.SetOptionInteger(3, Playlist1.frmPlaylist1.Left);
  // Salveaza coordonatele primei ferestre de playlist
  OptiuniPlayer.SetOptionInteger(4, Playlist1.frmPlaylist1.Top);

  OptiuniPlayer.SetOptionInteger(5, Playlist2.frmPlaylist2.Left);
  // Salveaza coordonatele celei de-a doua ferestre de playlist
  OptiuniPlayer.SetOptionInteger(6, Playlist2.frmPlaylist2.Top);

  OptiuniPlayer.SetOptionInteger(7, tbVolume.Position); // Salveaza volumul

  OptiuniPlayer.WriteToFile; // Scrie optiunile in fisier
  OptiuniPlayer.Free; // Distruge obiectul
  BASS_Stop;
  BASS_SetVolume(1);
end;

procedure TfrmPlayer.ChangeSongVolume(Sender: TObject);
// Schimba volumul melodiei. Pentru ca trackbar-ul are scala intre 1 si 100 si
// functia seteaza volumul ca un numar intre 0 si 1, atunci trebuie efectuata
// o impartire la 100
begin
  OptiuniPlayer.SetOptionBoolean(10, false);
  // Daca volumul e dat pe mute si utilizatorul schimba volumul melodiei
  BASS_SetVolume(tbVolume.Position / 100); // Stabilesc volumul melodiei
end;

procedure TfrmPlayer.MoveSongToPosition(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
// Procedura se ocupa de tot ce e necesar pentru a muta melodia la pozitia pe care
// utilizatorul face click
begin
  if (Button = mbLeft) and (SongSelected <> -1) then
    begin
      pbProgressBar.Position :=
        (Trunc(BASS_ChannelBytes2Seconds(Main.FirstPlaylist.ID
        [Playlist1.SongSelected], BASS_ChannelGetLength(Main.FirstPlaylist.ID
        [Playlist1.SongSelected], BASS_POS_BYTE))) * X) div pbProgressBar.Width;
      // Calculeaza pozitia barei de progres in functie de lungimea melodiei

      BASS_ChannelSetPosition(FirstPlaylist.ID[SongSelected],
        BASS_ChannelSeconds2Bytes(FirstPlaylist.ID[SongSelected],
        pbProgressBar.Position), BASS_POS_BYTE);
      // Stabileste pozitia melodiei in functie de pozitia barei de progres
    end;
end;

procedure TfrmPlayer.MuteOrSoundSong(Sender: TObject);
// Procedura opreste sunetul sau il reda inapoi
begin
  if OptiuniPlayer.GetOptionBoolean(10) then
    // Daca se vrea redarea inapoi a sunetului (Mute=true)
    begin
      tbVolume.Position := Trunc(TempVolume);
      // Stabilesc si pozitia trackbar-ului.
      // Modificarea pozitiei trackbar-ului duce si la modificarea volumului
      // sunetului datorita
      // handler-ului ChangeSongVolume
      OptiuniPlayer.SetOptionBoolean(10, false); // Setez variabila la fals
    end
  else // Daca se vrea luarea lui (Mute=false)
    begin
      TempVolume := tbVolume.Position;
      // OptiuniPlayer.SetOptionInteger(7, Trunc(BASS_GetVolume));
      // Retin volumul actual stabilit;
      tbVolume.Position := 0; // Stabilesc si pozitia trackbar-ului.
      // Modificarea pozitiei trackbar-ului duce si la modificarea volumului
      // sunetului datorita handler-ului ChangeSongVolume
      OptiuniPlayer.SetOptionBoolean(10, true); // Setez variabila la true;
    end;
end;

procedure TfrmPlayer.PauseSong(Sender: TObject);
// Ce trebuie efectuat pentru a pune melodia pe pauza;
begin
  if FirstPlaylist.FileName.Count = 0 then
    // Daca playlistul este gol, atunci...
    exit; // ... iese din procedura
  Paused := true;
  BASS_ChannelPause(FirstPlaylist.ID[SongSelected]);
  Timer1.Enabled := false;
end;

procedure TfrmPlayer.PlayNextSong(Sender: TObject);
// Aceasta procedura se ocupa de tot ce trebuie facut pentru a trece la melodia
// urmatoare, din butonul destinat acestui lucru
begin
  SkipToNextSong;
end;

procedure TfrmPlayer.PlaySong(Sender: TObject);
// Ce trebuie facut pentru a reda melodia aleasa
var
  hours, mins, secs, i: Integer;
  // hours, mins si secs retin lungimea melodiei care va fi redata, in ore, minute
  // si secunde. Aceste valori sunt atasate titlului melodiei redate, in
  // fereastra de player (orele sunt utile in cazul mix-urilor house, de exemplu
  // i este variabila de ciclare
begin
  if FirstPlaylist.FileName.Count = 0 then // Daca playlistul e gol, atunci...
    begin
      Playlist1.frmPlaylist1.AddSongsToPlaylist(Application);
      // Adaug melodii in playlist
      SongSelected := 0; // Aleg prima melodie ca fiind de redat
    end;
  // ...deschide fereastra de selectie a melodiilor
  i := 0;
  while (i < Playlist1.frmPlaylist1.lbPlaylist.Items.Count) and
    (Playlist1.frmPlaylist1.lbPlaylist.Selected[i] = false) do
    inc(i);
  { Caut primul element selectat din playlist (daca sunt mai multe melodii
    selectate, numai prima va fi luata in considerare }
  if i = Playlist1.frmPlaylist1.lbPlaylist.Items.Count then
    // Daca nu e niciun element selectat in playlist...
    begin
      SongSelected := 0; // ... atunci il aleg pe primul.
      Playlist1.frmPlaylist1.lbPlaylist.Selected[0] := true;
    end
  else // Daca este un element selectat...
    begin
      SongSelected := i; // ...atunci il aleg pe acela.
      Playlist1.frmPlaylist1.lbPlaylist.Selected[i] := true;
    end;
  BASS_ChannelPlay(Main.FirstPlaylist.ID[Playlist1.SongSelected], false);
  // Reda melodia selectata din playlist
  Timer1.Enabled := true; // pornesc cronometrul
  secs := Trunc(Bass.BASS_ChannelBytes2Seconds(Main.FirstPlaylist.ID
    [SongSelected], Bass.BASS_ChannelGetLength(Main.FirstPlaylist.ID
    [Playlist1.SongSelected], BASS_POS_BYTE)));
  // afla lungimea melodiei, in secunde
  if secs >= 3600 then // Daca melodia are o ora sau mai mult...
    begin
      hours := secs div 3600; // Calculeaza orele...
      secs := secs - hours * 3600;
      mins := secs div 60; // ...minutele...
      secs := secs - mins * 60; // ... si secundele
      lblSongName.Caption := Playlist1.frmPlaylist1.lbPlaylist.Items
        [SongSelected] + ' (' + IntTostr(hours) + ':' + AddLeadingZeroes(mins,
        2) + ':' + AddLeadingZeroes(secs, 2) + ')';
    end
  else // Daca melodia are sub o ora...
    begin
      mins := secs div 60; // Calculeaza minutele...
      secs := secs - mins * 60; // ... si secundele
      // Calculeaza numarul de minute si de secunde ale melodiei de cantat
      lblSongName.Caption := Playlist1.frmPlaylist1.lbPlaylist.Items
        [SongSelected] + ' (' + IntTostr(mins) + ':' +
        AddLeadingZeroes(secs, 2) + ')';
    end;
  // Este afisata melodia care este redata
  pbProgressBar.Max :=
    Trunc(BASS_ChannelBytes2Seconds(Main.FirstPlaylist.ID
    [Playlist1.SongSelected], BASS_ChannelGetLength(Main.FirstPlaylist.ID
    [Playlist1.SongSelected], BASS_POS_BYTE)));
  // Stabileste limita superioara a barei de progres la lungimea melodiei (sec)
  if Paused then
    // Daca melodia e in pauza, revine la pozitia initiala a barei de progres.
    pbProgressBar.Position :=
      Trunc(BASS_ChannelBytes2Seconds(FirstPlaylist.ID[SongSelected],
      BASS_ChannelGetPosition(FirstPlaylist.ID[SongSelected], BASS_POS_BYTE)))
  else // Daca melodia nu e in pauza, bara de progres o ia de la capat
    pbProgressBar.Position := 0;
  Paused := false;
end;

procedure TfrmPlayer.ProcessEvents(Sender: TObject);
// Procedura se ocupa de tot ce trebuie sa se intample o data pe secunda, in timp
// ce melodia este redata
var
  MinutesElapsed, SecondsElapsed: Integer;
  // Aceste doua variabile retin cate minute si cate secunde au trecut din melodie
begin
  pbProgressBar.Position := pbProgressBar.Position + 1;
  // Se modifica bara de progres
  if pbProgressBar.Position = pbProgressBar.Max then
    // Daca melodia a ajuns la capat atunci
    Timer1.Enabled := false; // Opreste cronometrul;
  SecondsElapsed :=
    Round(BASS_ChannelBytes2Seconds(FirstPlaylist.ID[Playlist1.SongSelected],
    BASS_ChannelGetPosition(FirstPlaylist.ID[Playlist1.SongSelected],
    BASS_POS_BYTE))); // Afla numarul de secunde ale melodiei
  MinutesElapsed := SecondsElapsed div 60; // Calculeaza numarul de minute...
  SecondsElapsed := SecondsElapsed - (MinutesElapsed * 60);
  // ...si numarul de secunde
  lblTimer.Caption := AddLeadingZeroes(MinutesElapsed, 2) + ':' +
    AddLeadingZeroes(SecondsElapsed, 2); // Afiseaza cat timp a trecut
  if pbProgressBar.Position = pbProgressBar.Max then
    // Daca a ajuns la finalul melodiei...
    SkipToNextSong; // Trece la urmatoarea piesa
end;

procedure TfrmPlayer.ShowOptionsWindow(Sender: TObject);
var
  Optiuni: TfrmOptiuni;
begin
  Optiuni := TfrmOptiuni.Create(Application);
  Optiuni.ShowModal;
end;

procedure TfrmPlayer.Startup(Sender: TObject);
// Lucrurile efectuate la pornirea programului
begin
  OptiuniPlayer := TOptiuni.Create; // Creaza instanta care se ocupa de optiuni
  OptiuniPlayer.ReadFromFile; // Citeste optiunile din fisier

  Left := OptiuniPlayer.GetOptionInteger(1);
  // Citeste coordonatele ferestrei playerului
  Top := OptiuniPlayer.GetOptionInteger(2);

  BASS_Init(-1, 44100, 0, Handle, nil); // Initializarea si incarcarea dll-ului

  if OptiuniPlayer.GetOptionBoolean(8) then
    // Daca playerul repeta playlistul, atunci...
    begin
      shRepLED.Brush.Color := clRed; // LED-ul e rosu.
    end
  else // Daca nu, atunci...
    begin
      shRepLED.Brush.Color := clYellow; // ...e galben.
    end;

  if OptiuniPlayer.GetOptionBoolean(9) then
    // Daca playerul reda piesele aleatoriu, atunci...
    begin
      shShfLED.Brush.Color := clRed; // LED-ul e rosu.
    end
  else // Daca nu, atunci...
    begin
      shShfLED.Brush.Color := clYellow; // ... e galben.
    end;

  BASS_SetVolume(OptiuniPlayer.GetOptionInteger(7));
  // Se da volumul melodiei la valoarea citita din fisier
  tbVolume.Position := OptiuniPlayer.GetOptionInteger(7);
  // Se reflecta volumul citit in fereastra

  FirstPlaylist.FileName := TStringList.Create;
  FirstPlaylist.ShownFileName := TStringList.Create;
  // Apeleaza constructorii celor doua variabile de tip TStrings

  SongSelected := -1;
  // La pornirea programului nu este selectata nicio melodie din playlist
end;

procedure TfrmPlayer.StopSong(Sender: TObject);
// Ce trebuie facut pentru a opri melodia
begin
  if FirstPlaylist.FileName.Count = 0 then
    // Daca playlistul este gol, atunci...
    exit; // ... iese din procedura
  BASS_ChannelStop(FirstPlaylist.ID[SongSelected]); // Opreste melodia
  BASS_ChannelSetPosition(FirstPlaylist.ID[SongSelected], 0, BASS_POS_BYTE);
  // O aduce la inceput (nu stiu de ce nu se face asta automat)
  pbProgressBar.Position := 0; // Aduce la 0 si bara de progres
  lblTimer.Caption := '00:00';
  Timer1.Enabled := false;
  Paused := false;
end;

procedure TfrmPlayer.ToggleFirstPlaylist(Sender: TObject);
// Procedura afiseaza sau ascunde playlistul 1;
begin
  Playlist1.frmPlaylist1.Visible := not Playlist1.frmPlaylist1.Visible;
end;

procedure TfrmPlayer.ToggleRepStatus(Sender: TObject);
// Procedura face prelucrarile necesare in cazul in care e sau nu e nevoie
// de repetarea playlistului
begin
  OptiuniPlayer.SetOptionBoolean(8, not(OptiuniPlayer.GetOptionBoolean(8)));
  // Se schimba valoarea variabilei;
  if OptiuniPlayer.GetOptionBoolean(8) then
    // Daca playerul repeta playlistul...
    begin
      shRepLED.Brush.Color := clRed; // ...led-ul e rosu.
    end
  else // Altfel...
    begin
      shRepLED.Brush.Color := clYellow; // ...e galben
    end;
end;

procedure TfrmPlayer.ToggleSecondPlaylist(Sender: TObject);
// Procedura afiseaza sau ascunde playlistul 2;
begin
  Playlist2.frmPlaylist2.Visible := not Playlist2.frmPlaylist2.Visible
end;

procedure TfrmPlayer.ToggleShuffleStatus(Sender: TObject);
// Procedura face prelucrarile necesare in cazul in care e sau nu e nevoie
// de redarea aleatorie a melodiilor din playlist
begin
  OptiuniPlayer.SetOptionBoolean(9, not OptiuniPlayer.GetOptionBoolean(9));
  // Se schimba valoarea variabilei;
  if OptiuniPlayer.GetOptionBoolean(9) then
    // Daca playerul trebuie sa redea melodiile in ordine aleatorie...
    begin
      shShfLED.Brush.Color := clRed; // ...led-ul e rosu.
    end
  else // Altfel...
    begin
      shShfLED.Brush.Color := clYellow; // ...led-ul e galben.
    end;
end;

end.
