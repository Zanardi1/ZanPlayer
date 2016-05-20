unit Optiuni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TfrmOptiuni = class(TForm)
    bitbtnOK: TBitBtn;
    bitbtnCancel: TBitBtn;
    pcOptions: TPageControl;
    tsMisc: TTabSheet;
    tsStartup: TTabSheet;
    tsPlaylist1: TTabSheet;
    rgPlaylistStartup: TRadioGroup;
    rgMinimizeTo: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptiuni: TfrmOptiuni;

implementation

{$R *.dfm}

end.
