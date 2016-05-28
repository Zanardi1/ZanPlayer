unit ID3ManagementUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ID3v1Library, ID3v2Library,
  Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmID3 = class(TForm)
    pcID3Tags: TPageControl;
    tsID3V1: TTabSheet;
    tsID3V2: TTabSheet;
    leTitle: TLabeledEdit;
    leArtist: TLabeledEdit;
    leAlbum: TLabeledEdit;
    leYear: TLabeledEdit;
    leComment: TLabeledEdit;
    lblGenre: TLabel;
    cbGenre: TComboBox;
    leTrack: TLabeledEdit;
    bkOK: TBitBtn;
    bkCancel: TBitBtn;
    leTitle2: TLabeledEdit;
    leArtist2: TLabeledEdit;
    leAlbum2: TLabeledEdit;
    leYear2: TLabeledEdit;
    leTrack2: TLabeledEdit;
    LabeledEdit1: TLabeledEdit;
    cbGenre2: TComboBox;
    lblGenre2: TLabel;
    cbTagActivate: TCheckBox;
    constructor Create (SourceWindow:integer);
    procedure Startup(Sender: TObject);
    procedure SaveTags(Sender: TObject);
    procedure Bye(Sender: TObject);
    procedure ToggleFieldEnabledStates(Sender: TObject);
  private
    { Private declarations }
    Tag1: TID3v1Tag;
    Tag2: TID3v2Tag;
    FileName: string; // retine fisierul cu care se va lucra
    procedure LoadGenres;
    procedure LoadSelectedFile(FileName: string);
    procedure SaveID3V1Tags;
    procedure SaveID3V2Tags;
    procedure LoadID3V1Tags(HaveTags: boolean);
    procedure LoadID3V2Tags(HaveTags: boolean);
  public
    { Public declarations }
    Source: integer;
    { retine cine apeleaza rutina:
      source=0, daca rutina e apelata de catre player
      source=1, daca rutina e apelata de catre playlist1 }
  end;

var
  frmID3: TfrmID3;

implementation

uses Main, Playlist1;

{$R *.dfm}

constructor TfrmID3.Create(SourceWindow: Integer);
begin
  inherited Create(Application);
  Source:=SourceWindow;
end;

procedure TfrmID3.LoadSelectedFile(FileName: string);
var
  y: integer;
begin
  y := Tag1.LoadFromFile(FileName);
  // Incarca fisierul selectat
  if (y <> 0) and (y <> 65535) then
    // Daca a aparut o eroare la incarcarea fisierului...
    begin
      ShowMessage(ID3v1TagErrorCode2String(y)); // ... o anunta...
      exit; // ... si iese din procedura.
    end;
  // Daca a ajuns aici, atunci incarcarea a decurs bine
  LoadID3V1Tags(y <> 65535); // Incarca cele doua tipuri de tag-uri
  LoadID3V2Tags(y <> 65535);
end;

procedure TfrmID3.LoadID3V1Tags(HaveTags: boolean);
// Se ocupa de incarcarea tag-ului ID3V1. Parametrul HaveTags retine daca
// fisierul are sau nu tag-uri. Acest parametru e util pentru a bifa sau debifa
// checkbox-ul.
begin
  cbTagActivate.Checked := HaveTags;
  // (De)bifeaza checkbox-ul, dupa cum e necesar
  ToggleFieldEnabledStates(Application);
  // Activeaza/dezactiveaza celelalte campuri
  leTitle.Text := Tag1.Title; // Incarca titlul piesei din tag
  leArtist.Text := Tag1.Artist; // Incarca artistul
  leAlbum.Text := Tag1.Album; // Incarca albumul
  leYear.Text := Tag1.Year; // Incarca anul
  leComment.Text := Tag1.Comment; // Incarca comentariile
  cbGenre.Text := Tag1.Genre; // Incarca genul melodiei
  leTrack.Text := InttoStr(Tag1.Track); // Incarca numarul piesei.
end;

procedure TfrmID3.LoadID3V2Tags(HaveTags: boolean);
begin

end;

procedure TfrmID3.SaveID3V1Tags;
// Procedura se ocupa de salvarea etichetelor ID3V1
var
  y: integer;
begin
  if cbTagActivate.Checked then
    // Daca am ales sa pastrez tagurile, atunci incepe sa le salveze in fisier
    begin
      Tag1.Title := leTitle.Text; // Citeste titlul melodiei
      Tag1.Artist := leArtist.Text; // Citeste artistul
      Tag1.Album := leAlbum.Text; // Citeste albumul
      Tag1.Year := leYear.Text; // Citeste anul
      Tag1.Comment := leComment.Text; // Citeste comentariile
      Tag1.Genre := cbGenre.Text; // Citeste genul piesei
      Tag1.Track := StrToIntDef(leTrack.Text, 0); // Citeste numarul piesei
      y := Tag1.SaveToFile(FileName); // Salveaza modificarile
      if y <> 0 then // Daca salvarea nu a avut succes, atunci
        begin
          ShowMessage(ID3v1TagErrorCode2String(y));
          // Afiseaza un mesaj de eroare
          exit; // Iese din procedura
        end;
    end
  else // Daca vreau sa elimin tagurile, atunci...
    begin
      y := RemoveID3v1TagFromFile(FileName); // ...elimina tagurile
      if y <> 0 then
        // Verifica daca eliminarea a avut succes. Daca nu a avut succes,
        begin
          ShowMessage(ID3v1TagErrorCode2String(y));
          // Afiseaza un mesaj de eroare
          exit; // Iese din procedura
        end;
    end;
end;

procedure TfrmID3.SaveID3V2Tags;
// Procedura se ocupa de salvarea etichetelor ID3V2
begin

end;

procedure TfrmID3.Bye(Sender: TObject);
begin
  Tag1.Free;
  Tag2.Free;
end;

procedure TfrmID3.LoadGenres;
// Incarca genurile muzicale in combobox
var
  i: integer; // variabila de ciclare
begin
  for i := 0 to 147 do
    cbGenre.Items.Add(ID3GenreDataToString(i));
end;

procedure TfrmID3.SaveTags(Sender: TObject);
// Procedura se ocupa de salvarea etichetelor din fereastra
begin
  SaveID3V1Tags; // Salvez etichetele ID3V1
  SaveID3V2Tags; // Salvez etichetele ID3V2
end;

procedure TfrmID3.Startup(Sender: TObject);
// Questii de facut la pornirea programului
var
  index, i: integer;
  selected: boolean;
  // index retine pozitia din sirul FileName, care contine melodia cautata
  // i este variabila de ciclare
  // selected retine daca e vreo piesa selectata in playlist
begin
  Tag1 := TID3v1Tag.Create;
  Tag2 := TID3v2Tag.Create;
  LoadGenres; // Incarca genurile muzicale existente
  if Source = 0 then
    index := Playlist1.SongSelected
  else
    begin
      i := 0;
      selected := false;
      while (i <= Playlist1.frmPlaylist1.lbPlaylist.Count - 1) and
        not selected do
        begin
          if Playlist1.frmPlaylist1.lbPlaylist.selected[i] then
            break;
          inc(i);
        end;
      index:=i;
    end;
  FileName := Main.FirstPlaylist.FileName[index];
  LoadSelectedFile(FileName); // Incarca fisierul selectat
end;

procedure TfrmID3.ToggleFieldEnabledStates(Sender: TObject);
// Procedura activeaza/dezactiveaza campurile pentru etichetele ID3V1, in functie
// de dorinta utilizatorului
begin
  leTitle.Enabled := cbTagActivate.Checked;
  leArtist.Enabled := cbTagActivate.Checked;
  leAlbum.Enabled := cbTagActivate.Checked;
  leYear.Enabled := cbTagActivate.Checked;
  leComment.Enabled := cbTagActivate.Checked;
  cbGenre.Enabled := cbTagActivate.Checked;
  lblGenre.Enabled := cbTagActivate.Checked;
  leTrack.Enabled := cbTagActivate.Checked;
end;

end.
