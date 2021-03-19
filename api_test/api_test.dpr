program api_test;

{$WARN DUPLICATE_CTOR_DTOR OFF}
{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  signup_test in 'src\presentation\controllers\signup_test.pas',
  signup in '..\api\src\presentation\controllers\signup.pas',
  missing_param_error in '..\api\src\presentation\errors\missing_param_error.pas',
  error in '..\api\src\presentation\errors\error.pas',
  http_helpers in '..\api\src\presentation\helpers\http_helpers.pas',
  invalid_param_error in '..\api\src\presentation\errors\invalid_param_error.pas',
  account in '..\api\src\domain\models\account.pas',
  add_account in '..\api\src\domain\usecases\add_account.pas',
  email_validator_adapter_test in 'src\utils\email_validator_adapter_test.pas',
  controller_intf in '..\api\src\presentation\protocols\controller_intf.pas',
  email_validator_intf in '..\api\src\presentation\protocols\email_validator_intf.pas',
  http_intf in '..\api\src\presentation\protocols\http_intf.pas',
  email_validator in '..\api\src\utils\email_validator.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  nunitLogger: ITestLogger;

begin
  ReportMemoryLeaksOnShutdown := true;

{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    // Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    // Create the test runner
    runner := TDUnitX.CreateRunner;
    // Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := true;
    // tell the runner how we will log things
    // Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    // Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False;
    // When true, Assertions must be made during tests;

    // Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

{$IFNDEF CI}
    // We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
{$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;

end.
