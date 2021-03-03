unit signup_test;

interface

uses
  System.JSON,
  DUnitX.TestFramework,

  signup;

type

  [TestFixture]
  TSignupTest = class(TObject)
  private
    FSUT: TSignup;
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

  http;

procedure TSignupTest.handle;
var
  lBody: TJSONObject;
  lHTTPResponse: IHttpResponse;
begin
  lBody := TJSONObject.Create //
    .AddPair('email', 'any_email2hotmail.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password');

  lHTTPResponse := FSUT.handle(THTTPRequest.New.body(lBody).body);

  Assert.IsTrue(lHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''name''');
  Assert.IsTrue(lHTTPResponse.body.GetValue('error').Value.Equals('Missing param: name'), 'Deve retornar o error ''Missing param: name'' ao verificar ausência do paramêtro ''name''');

  lBody := TJSONObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password');

  lHTTPResponse := FSUT.handle(THTTPRequest.New.body(lBody).body);

  Assert.IsTrue(lHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''email''');
  Assert.IsTrue(lHTTPResponse.body.GetValue('error').Value.Equals('Missing param: email'), 'Deve retornar o error ''Missing param: email'' ao verificar ausência do paramêtro ''email''');
end;

procedure TSignupTest.Setup;
begin
  FSUT := TSignup.Create;
end;

procedure TSignupTest.TearDown;
begin
  FreeAndNil(FSUT);
end;

initialization

end.
