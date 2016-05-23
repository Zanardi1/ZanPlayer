unit DeleteSong;

{ Acest unit se ocupa de stergerea din playlist a melodiilor selectate din fereastra
  de playlist. Motivul pentru care am ales sa fac asa ceva intr-un thread separat este
  ca dureaza destul de mult stergerea, daca am un playlist mare, fapt ce duce la incetinirea
  programului, daca as face acest lucru in acelasi thread ca si threadul playerului.
  Facand stergerea intr-un thread separat, incetinirea dispare }

interface

uses
  System.Classes, Vcl.Dialogs;

type
  SongDelete = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation

uses Main, Playlist1;

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

  Synchronize(UpdateCaption);

  and UpdateCaption could look like,

  procedure SongDelete.UpdateCaption;
  begin
  Form1.Caption := 'Updated in a thread';
  end;

  or

  Synchronize(
  procedure
  begin
  Form1.Caption := 'Updated in thread via an anonymous method'
  end
  )
  );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ SongDelete }

procedure SongDelete.Execute;
// Procedura se ocupa cu stergerea din playlist a melodiilor selectate din
// fereastra de playlist
var
  i: integer; // variabila de ciclare
begin
  { Place thread code here }
  ShowMessage('Aici sterg melodii din playlist');
  for i := 0 to Playlist1.frmPlaylist1.lbPlaylist.Items.Count - 1 do
    // Cauta piesele selectate din tot playlistul
    begin
      if Playlist1.frmPlaylist1.lbPlaylist.Selected[i] then
        // Daca a gasit o piesa selectata...
        begin

        end;
    end;
end;

end.
