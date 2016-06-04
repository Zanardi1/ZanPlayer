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
    cbGenre2: TComboBox;
    lblGenre2: TLabel;
    cbTagActivate: TCheckBox;
    cbTagActivate2: TCheckBox;
    gbTagInformation2: TGroupBox;
    gbTagAttributes: TGroupBox;
    lblVersion: TLabel;
    cbUnsynced: TCheckBox;
    cbExtendedHeader: TCheckBox;
    cbExperimental: TCheckBox;
    cbCRCPresent: TCheckBox;
    gbComment: TGroupBox;
    memComment: TMemo;
    leLanguageID: TLabeledEdit;
    leDescription: TLabeledEdit;
    gbLyrics: TGroupBox;
    memLyrics: TMemo;
    leLyricsLanguage: TLabeledEdit;
    leLyricsDescription: TLabeledEdit;
    leURL: TLabeledEdit;
    gbTagInformation: TGroupBox;
    constructor Create(SourceWindow: integer);
    procedure Startup(Sender: TObject);
    procedure SaveTags(Sender: TObject);
    procedure Bye(Sender: TObject);
    procedure ToggleFieldEnabledStates(Sender: TObject);
    procedure ToggleFieldEnabledStates2(Sender: TObject);
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

var
  LanguageID: TLanguageID;
  Description: string;

{$R *.dfm}

constructor TfrmID3.Create(SourceWindow: integer);
begin
  inherited Create(Application);
  Source := SourceWindow;
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
  y := Tag2.LoadFromFile(FileName);
  if (y <> 0) then
    begin
      ShowMessage(ID3v2TagErrorCode2String(y));
      exit;
    end;
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
  cbTagActivate2.Checked := HaveTags;
  // (De)bifeaza checkbox-ul, dupa cum e necesar
  ToggleFieldEnabledStates2(Application);
  // Activeaza/dezactiveaza celelalte campuri
  cbUnsynced.Checked := Tag2.Unsynchronised;
  // Citeste daca e sau nu sincronizat
  Tag2.RemoveUnsynchronisationOnAllFrames; // Elimina sincronizarea (DE CE??)
  leTitle2.Text := Tag2.GetUnicodeText('TIT2'); // Citeste titlul piesei
  leArtist2.Text := Tag2.GetUnicodeText('TPE1'); // Citeste artistul
  leAlbum2.Text := Tag2.GetUnicodeText('TALB'); // Citeste albumul
  leYear2.Text := Tag2.GetUnicodeText('TYER'); // Citeste anul
  memComment.Text := Tag2.GetUnicodeComment('COMM', LanguageID, Description);
  // Citeste comentariile
  cbGenre2.Text := Tag2.GetUnicodeText('TCON'); // Citeste genul piesei
  leTrack2.Text := Tag2.GetUnicodeText('TRCK'); // Citeste numarul melodiei
  lblVersion.Caption := 'Versiunea: ' + InttoStr(Tag2.MajorVersion) + '.' +
    InttoStr(Tag2.MinorVersion); // Citeste versiunea etichetei
  cbExtendedHeader.Checked := Tag2.ExtendedHeader;
  // Citeste daca are antet extins
  cbExperimental.Checked := Tag2.Experimental;
  // Citeste daca e experimental (ce inseamna asta??)
  cbCRCPresent.Checked := Tag2.ExtendedHeader3.CRCPresent;
  // Citeste daca e prezent CRC
  leLanguageID.Text := LanguageIDtoString(LanguageID);
  // Citeste identificatorul de limba
  leDescription.Text := Description; // Citeste descrierea
  memLyrics.Text := Tag2.GetUnicodeLyrics('USLT', LanguageID, Description);
  // Citeste versurile
  leLyricsLanguage.Text := LanguageIDtoString(LanguageID);
  // Citeste limba versurilor
  leLyricsDescription.Text := Description;
  // Citeste textul versurilor
  leURL.Text := Tag2.GetUnicodeUserDefinedURLLink('WXXX', Description);
  // Citeste URL
end;

procedure TfrmID3.SaveID3V1Tags;
// Procedura se ocupa de salvarea etichetelor ID3V1
var
  y: integer;
begin
  if cbTagActivate.Checked then
    // Daca am ales sa pastrez tagurile, atunci incepe sa le salveze in fisier
    begin
      Tag1.Title := leTitle.Text; // Incarca titlul melodiei
      Tag1.Artist := leArtist.Text; // Incarca artistul
      Tag1.Album := leAlbum.Text; // Incarca albumul
      Tag1.Year := leYear.Text; // Incarca anul
      Tag1.Comment := leComment.Text; // Incarca comentariile
      Tag1.Genre := cbGenre.Text; // Incarca genul piesei
      Tag1.Track := StrToIntDef(leTrack.Text, 0); // Incarca numarul piesei
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
var
  y: integer;
begin
  if cbTagActivate2.Checked then
    // Daca utilziatorul a ales sa pastreze tagurile...
    begin
      Tag2.SetUnicodeText('TIT2', leTitle2.Text); // Incarca titlul piesei
      Tag2.SetUnicodeText('TPE1', leArtist2.Text); // Incarca artistul
      Tag2.SetUnicodeText('TALB', leAlbum2.Text);
      // Incarca albumul pe care a aparut
      Tag2.SetUnicodeText('TYER', leYear2.Text); // Incarca anul melodiei
      if memComment.Text <> '' then
        begin
          StringToLanguageID(leLanguageID.Text, LanguageID);
          Tag2.SetUnicodeComment('COMM', memComment.Text, LanguageID,
            leDescription.Text);
        end;
      Tag2.SetUnicodeText('TCON', cbGenre2.Text); // Incarca genul piesei
      Tag2.SetUnicodeText('TRCK', leTrack2.Text); // Incarca numarul piesei
      if cbUnsynced.Checked then
        Tag2.ApplyUnsynchronisationOnAllFrames;
      cbExtendedHeader.Checked := Tag2.ExtendedHeader; //Incarca daca are antet extins
      cbExperimental.Checked := Tag2.Experimental; //Incarca daca e experimental
      cbCRCPresent.Checked := Tag2.ExtendedHeader3.CRCPresent; //Incarca daca are CRC
      StringToLanguageID(leLyricsLanguage.Text, LanguageID); //Incarca ID-ul limbii
      Tag2.SetUnicodeLyrics('USLT', memLyrics.Text, LanguageID,
        leLyricsDescription.Text); //Incarca versurile
      Tag2.SetUnicodeUserDefinedURLLink('WXXX', leURL.Text, 'Description'); //Incarca URL
      y := Tag2.SaveToFile(FileName); // Salveaza modificarile in fisier
      if y <> ID3V2LIBRARY_SUCCESS then // Daca salvarea nu a avut succes...
        begin
          ShowMessage(ID3v2TagErrorCode2String(y));
          // Afiseaza un mesaj de eroare
          exit; // Iese din procedura
        end;
    end
  else // Daca a ales sa elimine tagurile
    begin
      y := RemoveID3v2TagFromFile(FileName); // le elimina din fisier
      if (y <> 0) then // Daca eliminarea nu a avut succes...
        begin
          ShowMessage(ID3v2TagErrorCode2String(y));
          // ...Afiseaza un mesaj de eroare
          exit; // Iese din procedura
        end;
    end;
end;

procedure TfrmID3.Bye(Sender: TObject);
begin
  Tag1.Free; // Distrug obiectele corespunzatoare celor 2 tag-uri
  Tag2.Free;
  EnableMenuItem(GetSystemMenu(handle, False), SC_CLOSE, MF_BYCOMMAND or
    MF_ENABLED); // Activez butonul de inchidere
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
  EnableMenuItem(GetSystemMenu(handle, False), SC_CLOSE, MF_BYCOMMAND or
    MF_GRAYED); // Dezactivez butonul de inchidere
  LoadGenres; // Incarca genurile muzicale existente
  if Source = 0 then //Daca am apelat aceasta fereastra din fereastra playerului (prin dublu click)...
    index := Playlist1.SongSelected //... alege indexul ca fiind melodia selectata
  else //Daca am apelat-o din fereastra de playlist...
    begin
      i := 0; //... atunci de aici...
      selected := False;
      while (i <= Playlist1.frmPlaylist1.lbPlaylist.Count - 1) and
        not selected do
        begin
          if Playlist1.frmPlaylist1.lbPlaylist.selected[i] then
            break;
          inc(i);
        end;
      index := i; //.. si pana aici caut prima melodie selectata din playlist
    end;
  FileName := Main.FirstPlaylist.FileName[index]; //Selectez numarul de ordine al fisierului care urmeaza sa fie ales
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

procedure TfrmID3.ToggleFieldEnabledStates2(Sender: TObject);
// Procedura activeaza/dezactiveaza campurile pentru etichetele ID3V2, in functie
// de dorinta utilizatorului
begin
  gbTagInformation2.Enabled := cbTagActivate2.Checked;
  gbTagAttributes.Enabled := cbTagActivate2.Checked;
  gbComment.Enabled := cbTagActivate2.Checked;
  gbLyrics.Enabled := cbTagActivate2.Checked;
end;

end.
