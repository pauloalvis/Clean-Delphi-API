program api;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  signup in 'src\presentation\controllers\signup.pas',
  missing_param_error in 'src\presentation\errors\missing_param_error.pas',
  error in 'src\presentation\errors\error.pas',
  http_helpers in 'src\presentation\helpers\http_helpers.pas',
  invalid_param_error in 'src\presentation\errors\invalid_param_error.pas',
  add_account in 'src\domain\usecases\add_account.pas',
  account in 'src\domain\models\account.pas',
  controller_intf in 'src\presentation\protocols\controller_intf.pas',
  email_validator_intf in 'src\presentation\protocols\email_validator_intf.pas',
  http_intf in 'src\presentation\protocols\http_intf.pas',
  email_validator_adapter in 'src\utils\email_validator_adapter.pas',
  db_add_account in 'src\data\usecases\db_add_account.pas',
  encrypter in 'src\data\protocols\encrypter.pas';

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
