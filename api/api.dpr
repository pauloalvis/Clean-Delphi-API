program api;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  signup in 'src\presentation\controllers\signup.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
