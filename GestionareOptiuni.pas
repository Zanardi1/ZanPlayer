unit GestionareOptiuni;
{ Acest unit creaza o clasa care se ocupa de gestionarea optiunilor programului.
  Clasa are urmatoarele proprietati:
  1. XPositionPlayer = distanta fata de partea din stanga a ecranului a ferestrei de redare;
  2. YPositionPlayer = distanta fata de partea de sus a ecranului a ferestrei de redare;
  3. XPositionPlaylist1 = distanta fata de partea din stanga a ecranului a primei ferestre de playlist;
  4. YPositionPlaylist1 = distanta fata de partea de sus a ecranului a primei ferestre de playlist;
  5. XPositionPlaylist2 = distanta fata de partea din stanga a ecranului a celei de-a doua ferestre de playlist;
  6. YPositionPlaylist2 = distanta fata de partea de sus a ecranului a celei de-a doua ferestre de playlist;
  7. PlayerVolume = retine volumul playerului la inchiderea acestuia;
  8. RepeatSwitch = retine daca este selectata sau nu repetarea playlistului;
  9. ShuffleSwitch = retine daca este selectata sau nu amestecarea melodiilor playlistului;
  10. Muted = retine daca, la inchiderea programului, optiunea de mut era activa sau nu;
  11. MinimizeToTaskbar = retine daca programul va fi minimizat pe taskbar (variabila ia valoarea true) sau in systray (false).
  12. PlaylistToShowAtStartup = retine care ferestre sa fie afisate la pornirea programului. Aceasta variabila ia urmatoarele valori: 0 = ambele ferestre; 1 = prima fereastra; 2 = a doua fereastra; 3 = nicio fereastra
  13. MinimizeNotification = retine daca programul anunta utilizatorul ca este minimizat pe systray. Aceasta valoare este true, daca utilizatorul este anuntat si false daca nu e anuntat
  14. PlaylistSongNumber = retine daca piesele din fereastra de playlist vor fi numerotate (true) sau nu (false).
  15. ShowTimeElapsed = retine daca cronometrul ferestrei de player va afisa timpul scurs de la inceputul melodiei (true) sau timpul ramas pana la finalul acesteia (false)

  Proprietatile sunt marcate ca fiind private, accesul la ele fiind facut prin functia GetOptionXX. Acest lucru e facut pentru a putea face diferite teste inainte de a returna valoarea dorita

  Clasa are urmatoarele metode:
  - Constructor;
  - Citirea din fisierul de optiuni
  - Verificarea fisierului de optiuni (va fi apelata intern de catre procedura de citire)
  - Modificarea unei optiuni
  - Testarea validitatii optiunii (probabil)
  - Scrierea in fisierul de optiuni
  - Destructorul }

interface

type
  TBounds = record
    LowerBound, UpperBound: integer;
  end;

  Bounds = array [1 .. 15] of TBounds;

  // Tipul de date TBounds retine limita inferioara si cea superioara pentru o
  // anumita optiune.
  // Tipul Bounds retine limitele inferioara si superioara pentru toate optiunile
  // citite. Indicele vectorului bounds este numarul de ordine al proprietatii
  // respective, numar de ordine care se afla sus
  TOptiuni = class

    constructor Create;
    procedure ReadFromFile;
    function SetOptionInteger(OptionNo, Value: integer): boolean;
    function SetOptionBoolean(OptionNo: integer; Value: boolean): boolean;
    function GetOptionInteger(OptionNo: integer): integer;
    function GetOptionBoolean(OptionNo: integer): boolean;
    procedure WriteToFile;
    destructor Free;

  private

    B: Bounds; // Retine limitele pentru fiecare optiune

    XPositionPlayer: integer;
    YPositionPlayer: integer;
    XPositionPlaylist1: integer;
    YPositionPlaylist1: integer;
    XPositionPlaylist2: integer;
    YPositionPlaylist2: integer;
    PlayerVolume: integer;
    RepeatSwitch: boolean;
    ShuffleSwitch: boolean;
    Muted: boolean;
    MinimizeToTaskBar: boolean;
    PlaylistToShowAtStartup: integer;
    MinimizeNotification: boolean;
    PlaylistSongNumber: boolean;
    ShowTimeElapsed: boolean;
    function TestOptionsFile: boolean;
    function Between(TestValue, LowerBound, UpperBound: integer): boolean;

  public

  end;

implementation

uses Forms, SysUtils, Winapi.Windows;

constructor TOptiuni.Create;
// Constructorul clasei. Initializeaza proprietatile acesteia
begin
  XPositionPlayer := 0;
  YPositionPlayer := 0;
  XPositionPlaylist1 := 0;
  YPositionPlaylist1 := 0;
  XPositionPlaylist2 := 0;
  YPositionPlaylist2 := 0;
  PlayerVolume := 0;
  RepeatSwitch := true;
  ShuffleSwitch := true;
  Muted := true;
  MinimizeToTaskBar := true;
  PlaylistToShowAtStartup := 0;
  MinimizeNotification := true;
  PlaylistSongNumber := true;
  ShowTimeElapsed := true;

  B[1].LowerBound := 0;
  B[1].UpperBound := Screen.Width;
  B[2].LowerBound := 0;
  B[2].UpperBound := Screen.Height;
  B[3].LowerBound := 0;
  B[3].UpperBound := Screen.Width;
  B[4].LowerBound := 0;
  B[4].UpperBound := Screen.Height;
  B[5].LowerBound := 0;
  B[5].UpperBound := Screen.Width;
  B[6].LowerBound := 0;
  B[6].UpperBound := Screen.Height;
  B[7].LowerBound := 0;
  B[7].UpperBound := 100;
  B[8].LowerBound := 0;
  B[8].UpperBound := 1;
  B[9].LowerBound := 0;
  B[9].UpperBound := 1;
  B[10].LowerBound := 0;
  B[10].UpperBound := 1;
  B[11].LowerBound := 0;
  B[11].UpperBound := 1;
  B[12].LowerBound := 0;
  B[12].UpperBound := 3;
  B[13].LowerBound := 0;
  B[13].UpperBound := 1;
  B[14].LowerBound := 0;
  B[14].UpperBound := 1;
  B[15].LowerBound := 0;
  B[15].UpperBound := 1;
end;

procedure TOptiuni.ReadFromFile;
// Procedura citeste optiunile din fisierul de optiuni
var
  TestCorrect: boolean; // retine daca testul fisierului nu a gasit erori
  f: TextFile;
  buffer: integer;
  // E folosit la citirea variabilelor booleene. Daca buffer e 1, atunci
  // variabila citita e true. Daca buffer e 0, atunci variabila citita e false
begin
  TestCorrect := TestOptionsFile;
  if TestCorrect then
    begin
      AssignFile(f, 'Options.txt');
      Reset(f);
      Readln(f, XPositionPlayer);
      Readln(f, YPositionPlayer);
      Readln(f, XPositionPlaylist1);
      Readln(f, YPositionPlaylist1);
      Readln(f, XPositionPlaylist2);
      Readln(f, YPositionPlaylist2);
      Readln(f, PlayerVolume);
      Readln(f, buffer);
      case buffer of
        0:
          RepeatSwitch := false;
        1:
          RepeatSwitch := true
      end;
      Readln(f, buffer);
      case buffer of
        0:
          ShuffleSwitch := false;
        1:
          ShuffleSwitch := true;
      end;
      Readln(f, buffer);
      case buffer of
        0:
          Muted := false;
        1:
          Muted := true;
      end;
      Readln(f, buffer);
      case buffer of
        0:
          MinimizeToTaskBar := false;
        1:
          MinimizeToTaskBar := true;
      end;
      Readln(f, PlaylistToShowAtStartup);
      Readln(f, buffer);
      case buffer of
        0:
          MinimizeNotification := false;
        1:
          MinimizeNotification := true;
      end;
      Readln(f, buffer);
      case buffer of
        0:
          PlaylistSongNumber := false;
        1:
          PlaylistSongNumber := true;
      end;
      Readln(f, buffer);
      case buffer of
        0:
          ShowTimeElapsed := false;
        1:
          ShowTimeElapsed := true;
      end;
      CloseFile(f);
    end
  else
    Application.MessageBox('Eroare la citirea fisierului de optiuni!',
      'Eroare!', MB_ICONSTOP or MB_OK);
end;

function TOptiuni.SetOptionInteger(OptionNo, Value: integer): boolean;
// Functia seteaza valoarea unei optiuni de tip intreg (al carei variabile este
// de tip integer). Aceasta functie intoarce true daca setarea a avut succes si
// false daca nu a avut succes. Ca parametru primeste OptionNo, adica numarul
// curent al optiunii al carei valoare se doreste a fi setata. Acest numar se ia
// de sus, din lista de proprietati a clasei. Valoarea setata este retinuta in
// parametrul Value
begin
  case OptionNo of
    1:
      begin
        XPositionPlayer := Value;
        Result := true;
      end;
    2:
      begin
        YPositionPlayer := Value;
        Result := true;
      end;
    3:
      begin
        XPositionPlaylist1 := Value;
        Result := true;
      end;
    4:
      begin
        YPositionPlaylist1 := Value;
        Result := true;
      end;
    5:
      begin
        XPositionPlaylist2 := Value;
        Result := true;
      end;
    6:
      begin
        YPositionPlaylist2 := Value;
        Result := true;
      end;
    7:
      begin
        PlayerVolume := Value;
        Result := true;
      end;
    12:
      begin
        PlaylistToShowAtStartup := Value;
        Result := true;
      end;
  end;
end;

function TOptiuni.SetOptionBoolean(OptionNo: integer; Value: boolean): boolean;
// Functia seteaza valoarea unei optiuni de tip boolean (al carei variabile este
// de tip boolean). Aceasta functie intoarce true daca setarea a avut succes si
// false daca nu a avut succes. Ca parametru primeste OptionNo, adica numarul
// curent al optiunii al carei valoare se doreste a fi setata. Acest numar se ia
// de sus, din lista de proprietati a clasei. Valoarea setata este retinuta in
// parametrul Value
begin
  case OptionNo of
    8:
      begin
        RepeatSwitch := Value;
        Result := true;
      end;
    9:
      begin
        ShuffleSwitch := Value;
        Result := true;
      end;
    10:
      begin
        Muted := Value;
        Result := true;
      end;
    11:
      begin
        MinimizeToTaskBar := Value;
        Result := true;
      end;
    13:
      begin
        MinimizeNotification := Value;
        Result := true;
      end;
    14:
      begin
        PlaylistSongNumber := Value;
        Result := true;
      end;
    15:
      begin
        ShowTimeElapsed := Value;
        Result := true;
      end;
  end;

end;

function TOptiuni.GetOptionInteger(OptionNo: integer): integer;
// Functia intoarce valoarea optiunii cu numarul de ordine OptionNo, optiune de
// tip intreg (care este retinuta intr-o variabila de tip integer). Numarul de
// ordine este luat din lista de proprietati a clasei, de la inceputul acestui
// unit. Functia intoarce, evident, valoarea optiunii.
begin
  case OptionNo of
    1:
      begin
        Result := XPositionPlayer;
      end;
    2:
      begin
        Result := YPositionPlayer;
      end;
    3:
      begin
        Result := XPositionPlaylist1;
      end;
    4:
      begin
        Result := YPositionPlaylist1;
      end;
    5:
      begin
        Result := XPositionPlaylist2;
      end;
    6:
      begin
        Result := YPositionPlaylist2;
      end;
    7:
      begin
        Result := PlayerVolume;
      end;
    12:
      begin
        Result := PlaylistToShowAtStartup;
      end;
  end;
end;

function TOptiuni.GetOptionBoolean(OptionNo: integer): boolean;
// Functia intoarce valoarea optiunii cu numarul de ordine OptionNo, optiune de
// tip boolean (care este retinuta intr-o variabila de tip boolean). Numarul de
// ordine este luat din lista de proprietati a clasei, de la inceputul acestui
// unit. Functia intoarce, evident, valoarea optiunii.
begin
  case OptionNo of
    8:
      begin
        Result := RepeatSwitch
      end;
    9:
      begin
        Result := ShuffleSwitch;
      end;
    10:
      begin
        Result := Muted;
      end;
    11:
      begin
        Result := MinimizeToTaskBar;
      end;
    13:
      begin
        Result := MinimizeNotification;
      end;
    14:
      begin
        Result := PlaylistSongNumber;
      end;
    15:
      begin
        Result := ShowTimeElapsed;
      end;
  end;
end;

procedure TOptiuni.WriteToFile;
// Procedura scrie optiunile in fisierul de optiuni
var
  f: TextFile;
begin
  AssignFile(f, 'Options.txt');
  rewrite(f);
  writeln(f, XPositionPlayer);
  writeln(f, YPositionPlayer);
  writeln(f, XPositionPlaylist1);
  writeln(f, YPositionPlaylist1);
  writeln(f, XPositionPlaylist2);
  writeln(f, YPositionPlaylist2);
  writeln(f, PlayerVolume);
  case RepeatSwitch of
    true:
      writeln(f, 1);
    false:
      writeln(f, 0);
  end;
  case ShuffleSwitch of
    true:
      writeln(f, 1);
    false:
      writeln(f, 0);
  end;
  case Muted of
    true:
      writeln(f, 1);
    false:
      writeln(f, 0);
  end;
  case MinimizeToTaskBar of
    true:
      writeln(f, 1);
    false:
      writeln(f, 0);
  end;
  writeln(f, PlaylistToShowAtStartup);
  case MinimizeNotification of
    true:
      writeln(f, 1);
    false:
      writeln(f, 0);
  end;
  case PlaylistSongNumber of
    true:
      writeln(f, 1);
    false:
      writeln(f, 0);
  end;
  case ShowTimeElapsed of
    true:
      writeln(f, 1);
    false:
      writeln(f, 0);
  end;
  CloseFile(f);
end;

destructor TOptiuni.Free;
begin

end;

function TOptiuni.TestOptionsFile: boolean;
// Procedura cauta eventualele erori care ar putea aparea in fisier. Erorile
// cautate sunt, in aceasta ordine, pentru fiecare optiune citita:
// 1. Daca apar sau nu litere in fisier la acea optiune
// 2. Erori de interval (daca optiunea citita e in intervalul in care ar trebui
// sa fie. Caz particular: in cazul variabilelor booleene, valorile citite
// trebuie sa fie 1 sau 0)

var
  buffer: string;
  // variabila buffer este folosita la citrea un rand din fisier;
  i, BufferInt: integer;
  // i = variabila de ciclare; BufferInt retine valoarea numerica a lui Buffer;
  f: TextFile;
  // f = fisierul cu care se lucreaza
  TempResult: boolean;
  // retine daca testul unui singur parametru a esuat sau nu. Aceasta variabila este true daca parametrul a trecut de toate testele si false altfel
begin
  TempResult := true;
  i := 1;
  AssignFile(f, 'options.txt');
  Reset(f);
  while (i <= 13) and TempResult do // secventa de test propriu-zisa
    begin
      Readln(f, buffer); // citeste un rand din fisier;
      buffer := Trim(buffer);
      if TryStrToInt(buffer, BufferInt) then
        // daca sirul citit nu are litere...
        begin
          if Between(BufferInt, B[i].LowerBound, B[i].UpperBound) then
            TempResult := true
          else
            TempResult := false;
        end
      else
        TempResult := false;
      inc(i);
    end;
  CloseFile(f);
  Result := TempResult;
end;

function TOptiuni.Between(TestValue: integer; LowerBound: integer;
  UpperBound: integer): boolean;
begin
  if LowerBound < UpperBound then
    Result := (TestValue >= LowerBound) and (TestValue <= UpperBound);
end;

end.
