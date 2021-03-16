unit signup;

interface

uses
  system.json,

  http,
  controller,
  server_error,
  http_helpers,
  email_validator,
  missing_param_error,

  vcl.dialogs,
  add_account;

type
  TSignupController = class(TInterfacedObject, IController)
    FEmailValidator: IEmailValidator;
    FAddAccount: IAddAccount;

    function handle(const httpRequest: IHttpRequest): IHttpResponse;
    constructor Create(AEmailValidator: IEmailValidator; AAddAccount: IAddAccount);
  end;

implementation

uses
  invalid_param_error,
  system.SysUtils,
  account;

constructor TSignupController.Create(AEmailValidator: IEmailValidator; AAddAccount: IAddAccount);
begin
  FEmailValidator := AEmailValidator;
  FAddAccount := AAddAccount;
end;

function TSignupController.handle(const httpRequest: IHttpRequest): IHttpResponse;
var
  lAccountModel: IAccountModel;
  lAddAccountModel: IAddAccountModel;
  lField: String;
  isEmailValid: Boolean;
  lBody: TJSONObject;

  lName, lEmail, lPassword, lPasswordConfirmation: String;
const
  requiredFields: TArray<String> = ['name', 'email', 'password', 'passwordConfirmation'];
begin
  lBody := httpRequest.body;
  try

    for lField in requiredFields do
    begin
      if not(Assigned(lBody.GetValue(lField))) then
      begin
        result := badRequest(TMissingParamError.New(lField).body);
        exit;
      end;
    end;

    lName := lBody.GetValue('name').Value;
    lEmail := lBody.GetValue('email').Value;
    lPassword := lBody.GetValue('password').Value;
    lPasswordConfirmation := lBody.GetValue('passwordConfirmation').Value;

    if not(lPassword.Equals(lPasswordConfirmation)) then
    begin
      result := badRequest(TInvalidParamError.New('passwordConfirmation').body);
      exit;
    end;

    isEmailValid := self.FEmailValidator.isValid(lEmail);
    if not(isEmailValid) then
    begin
      result := badRequest(TInvalidParamError.New('email').body);
      exit;
    end;

    lAddAccountModel := TAddAccountModel.New //
      .name(lName) //
      .email(lEmail) //
      .password(lPassword);

    lAccountModel := FAddAccount.add(lAddAccountModel);

    result := THttpResponse.New //
      .statusCode(200) //
      .body(TJSONObject.Create //
      .AddPair('name', lName) //
      .AddPair('email', lEmail) //
      .AddPair('password', lPassword));

    // except

  except

    on E: Exception do
    begin
      showmessage(E.ToString);

      result := THttpResponse.New //
        .statusCode(500) //
        .body(TServerError.New.body);
    end;

  end;
end;

end.
