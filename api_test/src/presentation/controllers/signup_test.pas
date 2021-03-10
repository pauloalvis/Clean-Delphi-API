unit signup_test;

interface

uses
  System.JSON,
  DUnitX.TestFramework,

  http,
  signup,
  server_error,
  controller,
  delphi.mocks,
  email_validator;

type

  TEmailValidatorStub = class(TInterfacedObject, IEmailValidator)
    function isValid(const email: String): Boolean;
  end;

  ITypeSut = interface
    ['{6B289352-E5CA-4F63-845F-523EC2A99E86}']
    function MockSut: IController;
    function EmailValidator: TMock<IEmailValidator>;
  end;

  TTypeSut = class(TInterfacedObject, ITypeSut)
  private
    FMockSut: TSignupController;
    FEmailValidator: TMock<IEmailValidator>;

    function MockSut: IController;
    function EmailValidator: TMock<IEmailValidator>;

    constructor Create;
  private
    class function New: ITypeSut;
  end;

  [TestFixture]
  TSignupTest = class(TObject)
  private
    FHTTPRequest: IHttpRequest;
    FHTTPResponse: IHttpResponse;

    procedure AssertResponseMissinParam(const AParamName: String);
  public
    // [Test]
    procedure MissingParamName;
    // [Test]
    procedure MissingParamEmail;
    // [Test]
    procedure MissingParamPassword;
    // [Test]
    procedure MissingParamPasswordConfirmation;
    // [Test]
    procedure InvalidParamErrorEmail;
    // [Test]
    procedure ShouldAllEmailValidatorWithCorrectEmail;
    [Test]
    procedure ShouldReturnError500IfEmailValidatorThrows;
  end;

implementation

uses
  vcl.dialogs,

  System.SysUtils,

  missing_param_error,
  invalid_param_error,
  System.Rtti;

procedure TSignupTest.MissingParamEmail;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := TTypeSut.New.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''email''');
  AssertResponseMissinParam('email');
end;

procedure TSignupTest.MissingParamName;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('email', 'any_email2hotmail.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := TTypeSut.New.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''name''');
  AssertResponseMissinParam('name');
end;

procedure TSignupTest.MissingParamPassword;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation'));

  FHTTPResponse := TTypeSut.New.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''password''');
  AssertResponseMissinParam('password');
end;

procedure TSignupTest.MissingParamPasswordConfirmation;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('password', 'any_password'));

  FHTTPResponse := TTypeSut.New.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''passwordConfirmation''');
  AssertResponseMissinParam('passwordConfirmation');
end;

procedure TSignupTest.ShouldAllEmailValidatorWithCorrectEmail;
var
  lTypeSut: ITypeSut;
begin
  lTypeSut := TTypeSut.New;
  lTypeSut.EmailValidator.Setup.WillReturnDefault('isValid', false);

  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation'));

  lTypeSut.EmailValidator.Setup.Expect.Once.When.isValid('any_email.com');

  lTypeSut.MockSut.handle(FHTTPRequest);

  lTypeSut.EmailValidator.Verify('Deve chamar isValid com o parâmetro email: any_email.com');
end;

procedure TSignupTest.ShouldReturnError500IfEmailValidatorThrows;
var
  lTypeSut: ITypeSut;
begin
  lTypeSut := TTypeSut.New;
  lTypeSut.EmailValidator.Setup.WillRaise(TServerError, 'ytututyu').When.isValid('any_email.com');

  // lTypeSut.EmailValidator.Setup.WillRaise('isValid', false);

  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation'));

 FHTTPResponse := lTypeSut.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('500'), 'Deve retornar o StatusCode 400 ao verificar ausência do paramêtro ''passwordConfirmation''');
  AssertResponseMissinParam('passwordConfirmation');
end;

procedure TSignupTest.InvalidParamErrorEmail;
var
  lTypeSut: ITypeSut;
begin
  lTypeSut := TTypeSut.New;
  lTypeSut.EmailValidator.Setup.WillReturnDefault('isValid', false);

  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'invalid_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation'));

  FHTTPResponse := lTypeSut.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Deve retornar o StatusCode 400 se o email informado for inválido');
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals('{"error":"Invalid param: email"}'), format('Deve retornar %s, valor retornado %s', [FHTTPResponse.body.ToJSON, '{"error":"Invalid param: email"}']));
end;

function TEmailValidatorStub.isValid(const email: String): Boolean;
begin
  result := true;
end;

procedure TSignupTest.AssertResponseMissinParam(const AParamName: String);
var
  lResponseJson: String;
begin
  lResponseJson := format('{"error":"Missing param: %s"}', [AParamName]);
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals(lResponseJson), format('Deve retornar %s, valor retornado %s', [FHTTPResponse.body.ToJSON, lResponseJson]));
end;

constructor TTypeSut.Create;
begin
  FEmailValidator := TMock<IEmailValidator>.Create;
  FMockSut := TSignupController.Create(FEmailValidator);
end;

function TTypeSut.EmailValidator: TMock<IEmailValidator>;
begin
  result := FEmailValidator;
end;

function TTypeSut.MockSut: IController;
begin
  result := FMockSut;
end;

class function TTypeSut.New: ITypeSut;
begin
  result := TTypeSut.Create;
end;

initialization

end.
