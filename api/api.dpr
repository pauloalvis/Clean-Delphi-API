program api;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  signup in 'src\presentation\controllers\signup.pas',
  missing_param_error in 'src\presentation\errors\missing_param_error.pas',
  error in 'src\presentation\errors\error.pas',
  http in 'src\presentation\protocols\http.pas',
  http_helpers in 'src\presentation\helpers\http_helpers.pas';

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
