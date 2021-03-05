program api;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  signup in 'src\presentation\controllers\signup.pas',
  missing_param_error in 'src\presentation\errors\missing_param_error.pas',
  error in 'src\presentation\errors\error.pas',
  http in 'src\presentation\protocols\http.pas',
  http_helpers in 'src\presentation\helpers\http_helpers.pas',
  controller in 'src\presentation\protocols\controller.pas',
  email_validator in 'src\presentation\protocols\email_validator.pas',
  invalid_param_error in 'src\presentation\errors\invalid_param_error.pas';

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
