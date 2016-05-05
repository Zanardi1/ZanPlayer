unit Playlist1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus;

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
    procedure Startup(Sender: TObject);
    procedure ShowPlaylistMenu(Sender: TObject);
    procedure AddSongsToPlaylist(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPlaylist1: TfrmPlaylist1;

implementation
uses Main;

{$R *.dfm}

procedure TfrmPlaylist1.AddSongsToPlaylist(Sender: TObject);
//Instructiunile necesare adaugarii uneia sau mai multor melodii la playlist
begin
 odAddSongsToPlaylist.Execute(Application.Handle); //Deschide fereastra de selectie a melodiilor
 lbPlaylist.Items.AddStrings(odAddSongsToPlaylist.Files); //Adauga melodiile selectate in playlist
end;

procedure TfrmPlaylist1.ShowPlaylistMenu(Sender: TObject);
//Atunci cand utilizatorul face click pe buton, apare meniul de adaugare a melodiilor
//in playlist
begin
 pmAddToPlaylist.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmPlaylist1.Startup(Sender: TObject);
//Questii de facut la crearea ferestrei
begin
 Top:=Main.frmPlayer.Top+Main.frmPlayer.Height;
 Left:=Main.frmPlayer.Left;
end;

end.
