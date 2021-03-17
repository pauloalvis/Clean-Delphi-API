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
  email_validator,
  add_account,
  account;

type
  ITypeSut = interface
    ['{6B289352-E5CA-4F63-845F-523EC2A99E86}']
    function MockSut: IController;
    function EmailValidator: TMock<IEmailValidator>;
    function AddAccount: TMock<IAddAccount>;
  end;

  TTypeSut = class(TInterfacedObject, ITypeSut)
  private
    FMockSut: TSignupController;
    FEmailValidator: TMock<IEmailValidator>;
    FAddAccount: TMock<IAddAccount>;

    function MockSut: IController;
    function AddAccount: TMock<IAddAccount>;
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

    function MakeSut: ITypeSut;
    function MakeSutWithInvalidEmail: ITypeSut;
    function MakeSutWithEmailValidatorThrows: ITypeSut;
    function MakeSutWithAddAccountThrows: ITypeSut;

    procedure AssertResponseMissinParam(const AParamName: String);
  public
    [Test]
    procedure MissingParamName;
    [Test]
    procedure MissingParamEmail;
    [Test]
    procedure MissingParamPassword;
    [Test]
    procedure MissingParamPasswordConfirmation;
    [Test]
    procedure PasswordConfirmationFails;
    [Test]
    procedure InvalidParamErrorEmail;
    [Test]
    procedure ShouldCallEmailValidatorWithCorrectEmail;
    [Test]
    procedure ShouldReturnError500IfEmailValidatorThrows;
    [Test]
    procedure ShouldReturnError500ifAddAccounthrows;
    [Test]
    procedure ShouldReturn200ifValidDataProvided;
  end;

implementation

uses
  vcl.dialogs,

  System.SysUtils,

  missing_param_error,
  invalid_param_error,
  System.Rtti,
  delphi.mocks.Interfaces,
  delphi.mocks.Behavior;

function TSignupTest.MakeSut: ITypeSut;
var
  lAccountStub: IAccountModel;
begin
  lAccountStub := TAccountModel.New //
    .id('valid_id') //
    .name('valid_name') //
    .email('valid_email') //
    .password('valid_password');

  result := TTypeSut.New;
  result.EmailValidator.Setup.WillReturnDefault('isValid', true);
  result.AddAccount.Setup.WillReturnDefault('add', TValue.From(lAccountStub));
end;

function TSignupTest.MakeSutWithAddAccountThrows: ITypeSut;
begin
  result := TTypeSut.New;
  result.AddAccount.Setup.WillRaise('add', EMockException);
end;

function TSignupTest.MakeSutWithEmailValidatorThrows: ITypeSut;
begin
  result := TTypeSut.New;
  result.EmailValidator.Setup.WillRaise('isValid', EMockException);
end;

function TSignupTest.MakeSutWithInvalidEmail: ITypeSut;
begin
  result := TTypeSut.New;
  result.EmailValidator.Setup.WillReturnDefault('isValid', false);
end;

procedure TSignupTest.MissingParamEmail;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := MakeSut.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Should return: StatusCode 400');
  AssertResponseMissinParam('email');
end;

procedure TSignupTest.MissingParamName;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('email', 'any_email2hotmail.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := MakeSut.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Should return: StatusCode 400');
  AssertResponseMissinParam('name');
end;

procedure TSignupTest.MissingParamPassword;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('passwordConfirmation', 'any_passwordConfirmation'));

  FHTTPResponse := MakeSut.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Should return: StatusCode 400');
  AssertResponseMissinParam('password');
end;

procedure TSignupTest.MissingParamPasswordConfirmation;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('password', 'any_password'));

  FHTTPResponse := MakeSut.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Should return: StatusCode 400');
  AssertResponseMissinParam('passwordConfirmation');
end;

procedure TSignupTest.PasswordConfirmationFails;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'invalid_passwordConfirmation'));

  FHTTPResponse := MakeSut.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Should return: StatusCode 400');
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals('{"error":"Invalid param: passwordConfirmation"}'),
    format('Deve retornar %s, valor retornado %s', [FHTTPResponse.body.ToJSON, '{"error":"Invalid param: passwordConfirmation"}']));
end;

procedure TSignupTest.ShouldCallEmailValidatorWithCorrectEmail;
var
  lTypeSut: ITypeSut;
begin
  lTypeSut := MakeSutWithInvalidEmail;

  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  lTypeSut.EmailValidator.Setup.Expect.Once.When.isValid('any_email.com');

  lTypeSut.MockSut.handle(FHTTPRequest);

  lTypeSut.EmailValidator.Verify('Should Call ''isValid'' with correct email');
end;

procedure TSignupTest.ShouldReturn200ifValidDataProvided;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'valid_name') //
    .AddPair('email', 'valid_email.com') //
    .AddPair('password', 'valid_password') //
    .AddPair('passwordConfirmation', 'valid_password'));

  FHTTPResponse := MakeSut.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('200'), 'Should return: StatusCode 200');
  Assert.IsTrue(FHTTPResponse.body.GetValue('id').Value.Equals('valid_id'), 'Should return: valid_id');
  Assert.IsTrue(FHTTPResponse.body.GetValue('name').Value.Equals('valid_name'), 'Should return: valid_name');
  Assert.IsTrue(FHTTPResponse.body.GetValue('email').Value.Equals('valid_email'), 'Should return: valid_email');
  Assert.IsTrue(FHTTPResponse.body.GetValue('password').Value.Equals('valid_password'), 'Should return: valid_password');
end;

procedure TSignupTest.ShouldReturnError500ifAddAccounthrows;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := MakeSutWithAddAccountThrows.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('500'), 'Shoud return: StatusCode500');
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals('{"error":"Internal Server Error"}'), 'Should return: {"error":"Internal Server Error"}');
end;

procedure TSignupTest.ShouldReturnError500IfEmailValidatorThrows;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := MakeSutWithEmailValidatorThrows.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('500'), 'Shoud return: StatusCode500');
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals('{"error":"Internal Server Error"}'), 'Should return: {"error":"Internal Server Error"}');
end;

procedure TSignupTest.InvalidParamErrorEmail;
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'invalid_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  FHTTPResponse := MakeSutWithInvalidEmail.MockSut.handle(FHTTPRequest);

  Assert.IsTrue(FHTTPResponse.statusCode.ToString.Equals('400'), 'Should return: StatusCode 400');
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals('{"error":"Invalid param: email"}'), format('Should return %s, valor retornado %s', [FHTTPResponse.body.ToJSON, '{"error":"Invalid param: email"}']));
end;

procedure TSignupTest.AssertResponseMissinParam(const AParamName: String);
var
  lResponseJson: String;
begin
  lResponseJson := format('{"error":"Missing param: %s"}', [AParamName]);
  Assert.IsTrue(FHTTPResponse.body.ToJSON.Equals(lResponseJson), format('Should return: %s, value returned %s', [FHTTPResponse.body.ToJSON, lResponseJson]));
end;

function TTypeSut.AddAccount: TMock<IAddAccount>;
begin
  result := FAddAccount;
end;

constructor TTypeSut.Create;
begin
  FEmailValidator := TMock<IEmailValidator>.Create;
  FAddAccount := TMock<IAddAccount>.Create;

  FMockSut := TSignupController.Create(FEmailValidator, FAddAccount);
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
