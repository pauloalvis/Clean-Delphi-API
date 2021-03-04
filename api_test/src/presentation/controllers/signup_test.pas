unit signup_test;

interface

uses
  System.JSON,
  DUnitX.TestFramework,

  http,
  signup,
  controller;

type

  [TestFixture]
  TSignupTest = class(TObject)
  private
    FBody: TJSONObject;
    FMockSut: IController;
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
    procedure WithoutMissingParameter;

  end;

implementation

uses
  System.SysUtils,

  missing_param_error;

procedure TSignupTest.MissingParamEmail;
begin
  FBody := TJSONObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password');

  FHTTPResponse := FMockSut.handle(THTTPRequest.New.body(FBody).body);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar aus�ncia do param�tro ''email''');

  FBody := TMissingParamError.New('email').body;
  try
    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value), 'Deve retornar o error ''Missing param: email'' ao verificar aus�ncia do param�tro ''email''');
  finally
    FBody.DisposeOf;
  end;
end;

procedure TSignupTest.MissingParamName;
begin
  FBody := TJSONObject.Create //
    .AddPair('email', 'any_email2hotmail.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password');

  FHTTPResponse := FMockSut.handle(THTTPRequest.New.body(FBody).body);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar aus�ncia do param�tro ''name''');

  FBody := TMissingParamError.New('name').body;
  try
    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value), 'Deve retornar o error ''Missing param: name'' ao verificar aus�ncia do param�tro ''name''');
  finally
    FBody.DisposeOf;
  end;
end;

procedure TSignupTest.MissingParamPassword;
begin
  FBody := TJSONObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation');

  FHTTPResponse := FMockSut.handle(THTTPRequest.New.body(FBody).body);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar aus�ncia do param�tro ''password''');

  FBody := TMissingParamError.New('password').body;
  try
    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value), 'Deve retornar o error ''Missing param: password'' ao verificar aus�ncia do param�tro ''password''');
  finally
    FBody.DisposeOf;
  end;
end;

procedure TSignupTest.MissingParamPasswordConfirmation;
begin
  FBody := TJSONObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('password', 'any_password');

  FHTTPResponse := FMockSut.handle(THTTPRequest.New.body(FBody).body);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar aus�ncia do param�tro ''passwordConfirmation''');

  FBody := TMissingParamError.New('passwordConfirmatin').body;
  try
    Assert.IsTrue(FHTTPResponse.body.Value.Equals(FBody.Value), 'Deve retornar o error ''Missing param: passwordConfirmatin'' ao verificar aus�ncia do param�tro ''passwordConfirmatin''');
  finally
    FBody.DisposeOf;
  end;
end;

procedure TSignupTest.Setup;
begin
  FMockSut := TSignupController.Create;
end;

procedure TSignupTest.TearDown;
begin
  //
end;

procedure TSignupTest.WithoutMissingParameter;
begin
  FBody := TJSONObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation');;

  FHTTPResponse := FMockSut.handle(THTTPRequest.New.body(FBody).body);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('200'), 'Deve retornar o StatusCode 200 ao verificar que todos os param�tros est�o informados');
end;

initialization

end.
