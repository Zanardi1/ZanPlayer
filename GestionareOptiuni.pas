unit GestionareOptiuni;
{Acest unit creaza o clasa care se ocupa de gestionarea optiunilor programului.
Clasa urmatoarele proprietati:
- XPositionPlayer = distanta fata de partea din stanga a ecranului a ferestrei de redare;
- YPositionPlayer = distanta fata de partea de sus a ecranului a ferestrei de redare;
- XPositionPlaylist1 = distanta fata de partea din stanga a ecranului a primei ferestre de playlist;
- YPositionPlaylist1 = distanta fata de partea de sus a ecranului a primei ferestre de playlist;
- XPositionPlaylist2 = distanta fata de partea din stanga a ecranului a celei de-a doua ferestre de playlist;
- YPositionPlaylist2 = distanta fata de partea de sus a ecranului a celei de-a doua ferestre de playlist;
- PlayerVolume = retine volumul playerului la inchiderea acestuia;
- RepeatSwitch = retine daca este selectata sau nu repetarea playlistului;
- ShuffleSwitch = retine daca este selectata sau nu amestecarea melodiilor playlistului;
- Muted = retine daca, la inchiderea programului, optiunea de mut era activa sau nu;

Clasa are urmatoarele metode:
- Constructor;
- Citirea din fisierul de optiuni
- Verificarea fisierului de optiuni (va fi apelata intern de catre procedura de citire)
- Modificarea unei optiuni
- Testarea validitatii optiunii (probabil)
- Scrierea in fisierul de optiuni
- Destructorul}

interface

type TOptiuni=class
  XPositionPlayer:integer;
  YPositionPlayer:integer;
  XPositionPlaylist1:integer;
  YPositionPlaylist1:integer;
  XPositionPlaylist2:integer;
  YPositionPlaylist2:integer;
  PlayerVolume:integer;
  RepeatSwitch:boolean;
  ShuffleSwitch:boolean;
  Muted:boolean;
  constructor Create;
  procedure ReadFromFile;
  procedure SetOption;
  function TestOption:boolean;
  procedure WriteToFile;
  destructor Free;

  private
  function TestOptionsFile:boolean;

  public
end;

implementation

constructor TOptiuni.Create;
//Constructorul clasei. Initializeaza proprietatile acesteia
begin
  XPositionPlayer:=0;
  YPositionPlayer:=0;
  XPositionPlaylist1:=0;
  YPositionPlaylist1:=0;
  XPositionPlaylist2:=0;
  YPositionPlaylist2:=0;
  PlayerVolume:=0;
  RepeatSwitch:=true;
  ShuffleSwitch:=true;
  Muted:=true;
end;

procedure TOptiuni.ReadFromFile;
//Procedura citeste optiunile din fisierul de optiuni
var TestCorrect:boolean; //retine daca testul fisierului nu a gasit erori
    f:TextFile;
begin
  AssignFile(f,'Options.txt');
  Reset(f);
  TestCorrect:=TestOptionsFile;
  if TestCorrect then
    begin
      Readln(f,XPositionPlayer);
      Readln(f,YPositionPlayer);
      Readln(f,XPositionPlaylist1);
      Readln(f,YPositionPlaylist1);
      Readln(f,XPositionPlaylist2);
      Readln(f,YPositionPlaylist2);
      Readln(f,PlayerVolume);
      Readln(f,RepeatSwitch);
      Readln(f,ShuffleSwitch);
      Readln(f,Muted);
    end;
  CloseFile(f);
end;

procedure TOptiuni.SetOption;
begin

end;

function TOptiuni.TestOption:boolean;
begin

end;

procedure TOptiuni.WriteToFile;
begin

end;

destructor TOptiuni.Free;
begin

end;

function TOptiuni.TestOptionsFile:boolean;
begin

end;

end.
