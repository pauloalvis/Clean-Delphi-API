unit signup_test;

interface

uses
  System.JSON,
  DUnitX.TestFramework,

  signup,
  controller;

type

  [TestFixture]
  TSignupTest = class(TObject)
  private
    FMockSut: IController;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure handle;
  end;

implementation

uses
  System.SysUtils,

  http, missing_param_error;

procedure TSignupTest.handle;
var
  lBody: TJSONObject;
  lHTTPResponse: IHttpResponse;
begin
  lBody := TJSONObject.Create //
    .AddPair('email', 'any_email2hotmail.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password');

  lHTTPResponse := FMockSut.handle(THTTPRequest.New.body(lBody).body);

  Assert.IsTrue(lHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 ao verificar aus�ncia do param�tro ''name''');
  Assert.IsTrue(lHTTPResponse.body.GetValue('error')
    .Value.Equals('Missing param: name'),
    'Deve retornar o error ''Missing param: name'' ao verificar aus�ncia do param�tro ''name''');

  lBody := TJSONObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password');

  lHTTPResponse := FMockSut.handle(THTTPRequest.New.body(lBody).body);

  Assert.IsTrue(lHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 ao verificar aus�ncia do param�tro ''email''');
  Assert.IsTrue(lHTTPResponse.body.GetValue('error')
    .Value.Equals('Missing param: email'),
    'Deve retornar o error ''Missing param: email'' ao verificar aus�ncia do param�tro ''email''');

  lBody := TJSONObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('passwordConfirmation', 'any_password');

  lHTTPResponse := FMockSut.handle(THTTPRequest.New.body(lBody).body);

  Assert.IsTrue(lHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 ao verificar aus�ncia do param�tro ''password''');
  Assert.IsTrue(lHTTPResponse.body.GetValue('error')
    .Value.Equals('Missing param: password'),
    'Deve retornar o error ''Missing param: password'' ao verificar aus�ncia do param�tro ''password''');

  lBody := TJSONObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('password', 'any_password');

  lHTTPResponse := FMockSut.handle(THTTPRequest.New.body(lBody).body);

  Assert.IsTrue(lHTTPResponse.statusCode.ToString.Equals('400'),
    'Deve retornar o StatusCode 400 ao verificar aus�ncia do param�tro ''passwordConfirmation''');

  Assert.IsTrue(lHTTPResponse.body.Value.Equals
    (TMissingParamError.New('passwordConfirmatin').GetBody.Value),
    'Deve retornar o error ''Missing param: password'' ao verificar aus�ncia do param�tro ''passwordConfirmation''');

  // lBody := TJSONObject.Create //
  // .AddPair('name', 'any_name') //
  // .AddPair('email', 'ivalid_email@email.com') //
  // .AddPair('password', 'any_password') //
  // .AddPair('passwordConfirmation', 'any_password');
  //
  // lHTTPResponse := FMockSut.handle(THTTPRequest.New.body(lBody).body);
  //
  // Assert.IsTrue(lHTTPResponse.statusCode.ToString.Equals('400'),
  // 'Deve retornar o StatusCode 400 se o email passado for inv�lido');
  //
  // Assert.IsTrue(lHTTPResponse.body.GetValue('error')
  // .Value.Equals('Missing param: passwordConfirmation'),
  // 'Deve retornar o error ''Missing param: password'' ao verificar aus�ncia do param�tro ''passwordConfirmation''');
end;

procedure TSignupTest.Setup;
begin
  FMockSut := TSignupController.Create;
end;

procedure TSignupTest.TearDown;
begin
  //
end;

initialization

end.
