program api;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  signup in 'src\presentation\controllers\signup.pas';

type
  TCliente = class
    nome: String;
  end;

begin
  ReportMemoryLeaksOnShutdown := true;

  try
    Writeln('Iniciol');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
