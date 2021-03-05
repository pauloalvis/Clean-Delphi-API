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
    FBody: TJsonObject;
    FMockSut: IController;
    FHTTPRequest: IHttpRequest;
    FHTTPResponse: IHttpResponse;
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

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''email''');

  FBody := TMissingParamError.new('email').body;
  try
    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value),
      'Deve retornar o error ''Missing param: email'' ao verificar ausência do paramêtro ''email''');
  finally
    FBody.DisposeOf;
  end;
end;

procedure TSignupTest.MissingParamName;
begin
  FHTTPRequest := THttpRequest.new //
    .body(TJsonObject.Create //
    .AddPair('email', 'any_email2hotmail.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := FMockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''name''');

  FBody := TMissingParamError.new('name').body;
  try
    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value),
      'Deve retornar o error ''Missing param: name'' ao verificar ausência do paramêtro ''name''');
  finally
    FBody.DisposeOf;
  end;
end;

procedure TSignupTest.MissingParamPassword;
begin
  FHTTPRequest := THttpRequest.new //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation'));

  FHTTPResponse := FMockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''password''');

  FBody := TMissingParamError.new('password').body;
  try
    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value),
      'Deve retornar o error ''Missing param: password'' ao verificar ausência do paramêtro ''password''');
  finally
    FBody.DisposeOf;
  end;
end;

procedure TSignupTest.MissingParamPasswordConfirmation;
begin
  FHTTPRequest := THttpRequest.new //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('password', 'any_password'));

  FHTTPResponse := FMockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''passwordConfirmation''');

  FBody := TMissingParamError.new('passwordConfirmatin').body;
  try
    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value),
      'Deve retornar o error ''Missing param: passwordConfirmatin'' ao verificar ausência do paramêtro ''passwordConfirmatin''');
  finally
    FBody.DisposeOf;
  end;
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

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 se o email informado é inválido');

  FBody := TInvalidParamError.new('email').body;
  try

    showmessage( FHTTPResponse.body.Value);

    showmessage(FBody.Value);


    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value),
      'Deve retornar o error ''Invalid param: email'' email invalid');
  finally
    FBody.DisposeOf;
  end;

end;

function TEmailValidatorStub.isValid(const email: String): Boolean;
begin
  result := false;
end;

initialization

end.
