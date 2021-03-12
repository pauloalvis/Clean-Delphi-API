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

    function MakeSutWithValidEmail: ITypeSut;
    function MakeSutWithInvalidEmail: ITypeSut;
    function MakeSutWithEmailValidatorThrows: ITypeSut;

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
    procedure PasswordConfirmationFails;
    // [Test]
    procedure InvalidParamErrorEmail;
    // [Test]
    procedure ShouldCallEmailValidatorWithCorrectEmail;
    // [Test]
    procedure ShouldReturnError500IfEmailValidatorThrows;
    [Test]
    procedure ShouldCallAddAccountWithCorrectValues;
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
begin
  result := TTypeSut.New;
end;

function TSignupTest.MakeSutWithEmailValidatorThrows: ITypeSut;
begin
  result := MakeSut;
  result.EmailValidator.Setup.WillRaise('isValid', EMockException);
end;

function TSignupTest.MakeSutWithInvalidEmail: ITypeSut;
begin
  result := MakeSut;
  result.EmailValidator.Setup.WillReturnDefault('isValid', false);
end;

function TSignupTest.MakeSutWithValidEmail: ITypeSut;
begin
  result := MakeSut;
  result.EmailValidator.Setup.WillReturnDefault('isValid', true);
  result.AddAccount.Setup.WillReturnDefault('add', true);
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
begin
  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  MakeSutWithInvalidEmail.EmailValidator.Setup.Expect.Once.When.isValid('any_email.com');

  MakeSutWithInvalidEmail.MockSut.handle(FHTTPRequest);

  MakeSutWithInvalidEmail.EmailValidator.Verify('Should Call ''isValid'' with correct email');
end;

procedure TSignupTest.ShouldCallAddAccountWithCorrectValues;
var
  FAddAccountModel: IAddAccountModel;
begin
  FAddAccountModel := TAddAccountModel.New //
    .name('any_name') //
    .email('any_email.com') //
    .password('any_password');

  FHTTPRequest := THttpRequest.New //
    .body(TJsonObject.Create //
    .AddPair('name', 'any_name') //
    .AddPair('email', 'any_email.com') //
    .AddPair('password', 'any_password') //
    .AddPair('passwordConfirmation', 'any_password'));

  MakeSutWithInvalidEmail.AddAccount.Setup.Expect.Once.When.add(FAddAccountModel);

  MakeSutWithValidEmail.MockSut.handle(FHTTPRequest);

  MakeSutWithValidEmail.AddAccount.Verify('Should Call ''AddAccount.add'' with corrects params');
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
