unit Optiuni;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls;

type
  TfrmOptiuni = class(TForm)
    bitbtnOK: TBitBtn;
    bitbtnCancel: TBitBtn;
    TabControl1: TTabControl;
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
