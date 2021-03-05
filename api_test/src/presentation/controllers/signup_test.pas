unit signup_test;

interface

uses
  System.JSON,
  DUnitX.TestFramework,

  http,
  signup,
  controller,
  email_validator;

type
  TEmailValidatorStub = class(TInterfacedObject, IEmailValidator)
    function isValid(const email: String): Boolean;
  end;

  [TestFixture]
  TSignupTest = class(TObject)
  private
    FMockSut: IController;
    FHTTPRequest: IHttpRequest;
    FHTTPResponse: IHttpResponse;

    procedure AssertResponseMissinParam(const AParamName: String);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure MissingParamName;
    [Test]
    procedure MissingParamEmail;
    [Test]
    procedure MissingParamPassword;
    [Test]
    procedure MissingParamPasswordConfirmation;
    [Test]
    procedure InvalidParamErrorEmail;
  end;

implementation

uses
  vcl.dialogs,

  System.SysUtils,

  missing_param_error,
  invalid_param_error;

procedure TSignupTest.MissingParamEmail;
begin
  FHTTPRequest := THttpRequest.new //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := FMockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''email''');
  AssertResponseMissinParam('email');
end;

procedure TSignupTest.MissingParamName;
begin
  FHTTPRequest := THttpRequest.new //
    .body(TJsonObject.Create //
    .AddPair('email', 'any_email2hotmail.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := FMockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''name''');
  AssertResponseMissinParam('name');
end;

procedure TSignupTest.MissingParamPassword;
begin
  FHTTPRequest := THttpRequest.new //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation'));

  FHTTPResponse := FMockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''password''');
  AssertResponseMissinParam('password');
end;

procedure TSignupTest.MissingParamPasswordConfirmation;
begin
  FHTTPRequest := THttpRequest.new //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('password', 'any_password'));

  FHTTPResponse := FMockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''passwordConfirmation''');
  AssertResponseMissinParam('passwordConfirmation');
end;

procedure TSignupTest.Setup;
begin
  FMockSut := TSignupController.Create(TEmailValidatorStub.Create);
end;

procedure TSignupTest.TearDown;
begin
  //
end;

procedure TSignupTest.InvalidParamErrorEmail;
begin
  FHTTPRequest := THttpRequest.new //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'invalid_email@email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation'));

  FHTTPResponse := FMockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 se o email informado for inválido');
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals('{"error":"Invalid param: email"}'), format('Deve retornar %s, valor retornado %s', [FHTTPResponse.body.ToJSON, '{"error":"Invalid param: email"}']));
end;

function TEmailValidatorStub.isValid(const email: String): Boolean;
begin
  result := false;
end;

procedure TSignupTest.AssertResponseMissinParam(const AParamName: String);
var
  lResponseJson: String;
begin
  lResponseJson := format('{"error":"Missing param: %s"}', [AParamName]);
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals(lResponseJson), format('Deve retornar %s, valor retornado %s', [FHTTPResponse.body.ToJSON, lResponseJson]));
end;

initialization

end.
