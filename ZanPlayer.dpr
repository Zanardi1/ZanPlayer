program ZanPlayer;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmPlayer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'ZanPlayer';
  Application.CreateForm(TfrmPlayer, frmPlayer);
  Application.Run;
end.
