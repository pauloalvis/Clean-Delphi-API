unit signup;

interface

uses
  system.json,

  http_intf,
  controller_intf,
  http_helpers,
  add_account,
  email_validator_intf,
  missing_param_error;

type
  TSignupController = class(TInterfacedObject, IController)
    FEmailValidator: IEmailValidator;
    FAddAccount: IAddAccount;

    function handle(const httpRequest: IHttpRequest): IHttpResponse;
    constructor Create(AEmailValidator: IEmailValidator; AAddAccount: IAddAccount);
  end;

implementation

uses
  system.SysUtils,

  account,
  invalid_param_error;

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

    isEmailValid := FEmailValidator.isValid(lEmail);
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

    result := ok(TJSONObject.Create //
      .AddPair('id', lAccountModel.id) //
      .AddPair('name', lAccountModel.name) //
      .AddPair('email', lAccountModel.email) //
      .AddPair('password', lAccountModel.password));

  except
    result := serverError;
  end;
end;

end.
