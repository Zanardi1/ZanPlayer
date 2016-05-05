unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons, Bass,
  Playlist1, Playlist2, Vcl.ExtCtrls, Optiuni, Math;

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
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
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
  private
    { Private declarations }
    RepeatSongs, ShuffleSongs:boolean;
//RepeatSongs retine daca playerul reincepe cu piesa 1 dupa ce termina de cantat ultima piesa din playlist;
//Shuffle retine daca playerul canta piesele in mod aleatoriu
    Mute:boolean;
//Mute e true daca sunetul este oprit cu ajutorul butonului de Mute; fals altfel;
    MusicVolume:single;
//Retine volumul melodiei
  public
    { Public declarations }
  end;

var
  frmPlayer: TfrmPlayer;

implementation

{$R *.dfm}

procedure TfrmPlayer.ChangeSongVolume(Sender: TObject);
//Schimba volumul melodiei. Pentru ca trackbar-ul are scala intre 1 si 100 si
//functia seteaza volumul ca un numar intre 0 si 1, atunci trebuie efectuata
//o impartire la 100
begin
  BASS_SetVolume(tbVolume.Position/100); //Stabilesc volumul melodiei
end;

procedure TfrmPlayer.MuteOrSoundSong(Sender: TObject);
//Procedura opreste sunetul sau il reda inapoi
begin
  if Mute then //Daca se vrea redarea inapoi a sunetului
    begin
      tbVolume.Position:=Trunc(MusicVolume*100); //Stabilesc si pozitia trackbar-ului.
//Modificarea pozitiei trackbar-ului duce si la modificarea volumului sunetului datorita
//handler-ului ChangeSongVolume
      Mute:=false; //Setez variabila la fals
    end
  else //Daca se vrea luarea lui
    begin
      MusicVolume:=BASS_GetVolume; //Retin volumul actual stabilit;
      tbVolume.Position:=0; //Stabilesc si pozitia trackbar-ului.
//Modificarea pozitiei trackbar-ului duce si la modificarea volumului sunetului datorita
//handler-ului ChangeSongVolume
      Mute:=true; //Setez variabila la true;
    end;
end;

procedure TfrmPlayer.PauseSong(Sender: TObject);
//Ce trebuie efectuat pentru a pune melodia pe pauza;
begin
  BASS_Pause;
end;

procedure TfrmPlayer.PlaySong(Sender: TObject);
//Ce trebuie facut pentru a reda melodia aleasa
var a:HSTREAM;
    f:PChar;
begin
  OpenDialog1.Execute(Application.Handle);
  f:=PChar(OpenDialog1.FileName);
  a:=BASS_StreamCreateFile(false,f,0,0,BASS_UNICODE);
  pbProgressBar.Max:=Trunc(BASS_ChannelBytes2Seconds(a,BASS_ChannelGetLength(a,BASS_POS_BYTE)));
  BASS_ChannelPlay(a,false);
  Timer1.Enabled:=true;
  lblTimer.Caption:=FloatToStr(RoundTo(BASS_ChannelBytes2Seconds(a,BASS_ChannelGetLength(a,BASS_POS_BYTE)),-2)); //Calculeaza lungimea melodiei, in secunde
end;

procedure TfrmPlayer.ProcessEvents(Sender: TObject);
begin
 pbProgressBar.Position:=pbProgressBar.Position+1;
end;

procedure TfrmPlayer.ShowOptionsWindow(Sender: TObject);
var Optiuni:TfrmOptiuni;
begin
  Optiuni:=TfrmOptiuni.Create(Application);
  Optiuni.ShowModal;
end;

procedure TfrmPlayer.Startup(Sender: TObject);
begin
 BASS_Init(-1,44100,0,Handle,nil); //Initializarea si incarcarea dll-ului

 if RepeatSongs then //Daca playerul repeta playlistul, atunci...
   begin
     shRepLED.Brush.Color:=clRed; //LED-ul e rosu.
   end
 else //Daca nu, atunci...
  begin
    shRepLED.Brush.Color:=clYellow; //...e galben.
  end;

  if ShuffleSongs then //Daca playerul reda piesele aleatoriu, atunci...
    begin
      shShfLED.Brush.Color:=clRed; //LED-ul e rosu.
    end
  else //Daca nu, atunci...
    begin
      shShfLED.Brush.Color:=clYellow; //... e galben.
    end;

  BASS_SetVolume(tbVolume.Position); //Se da volumul melodiei la valoarea stabilita de trackbar
end;

procedure TfrmPlayer.StopSong(Sender: TObject);
//Ce trebuie facut pentru a opri melodia
begin
  BASS_Stop;
end;

procedure TfrmPlayer.ToggleFirstPlaylist(Sender: TObject);
//Procedura afiseaza sau ascunde playlistul 1;
begin
 Playlist1.frmPlaylist1.Visible:=not Playlist1.frmPlaylist1.Visible;
end;

procedure TfrmPlayer.ToggleRepStatus(Sender: TObject);
//Procedura face prelucrarile necesare in cazul in care e sau nu e nevoie
//de repetarea playlistului
begin
 RepeatSongs:=not(RepeatSongs); //Se schimba valoarea variabilei;
 if RepeatSongs then //Daca playerul repeta playlistul...
   begin
     shRepLED.Brush.Color:=clRed; //...led-ul e rosu.
   end
 else //Altfel...
   begin
     shRepLED.Brush.Color:=clYellow; //...e galben
   end;
end;

procedure TfrmPlayer.ToggleSecondPlaylist(Sender: TObject);
//Procedura afiseaza sau ascunde playlistul 2;
begin
 Playlist2.frmPlaylist2.Visible:=not Playlist2.frmPlaylist2.Visible
end;

procedure TfrmPlayer.ToggleShuffleStatus(Sender: TObject);
//Procedura face prelucrarile necesare in cazul in care e sau nu e nevoie
//de redarea aleatorie a melodiilor din playlist
begin
 ShuffleSongs:=not ShuffleSongs; //Se schimba valoarea variabilei;
 if ShuffleSongs then //Daca playerul trebuie sa redea melodiile in ordine aleatorie...
   begin
     shShfLED.Brush.Color:=clRed; //...led-ul e rosu.
   end
 else //Altfel...
   begin
     shShfLED.Brush.Color:=clYellow; //...led-ul e galben.
   end;
end;

end.
