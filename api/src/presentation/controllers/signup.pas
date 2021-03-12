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
  system.SysUtils;

constructor TSignupController.Create(AEmailValidator: IEmailValidator; AAddAccount: IAddAccount);
begin
  FEmailValidator := AEmailValidator;
  FAddAccount := AAddAccount;
end;

function TSignupController.handle(const httpRequest: IHttpRequest): IHttpResponse;
var
  FAddAccountModel: IAddAccountModel;
  lField: String;
  isEmailValid: Boolean;
  lBody: TJSONObject;
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

    if not(lBody.GetValue('password').Value.Equals(lBody.GetValue('passwordConfirmation').Value)) then
    begin
      result := badRequest(TInvalidParamError.New('passwordConfirmation').body);
      exit;
    end;

    isEmailValid := self.FEmailValidator.isValid(lBody.GetValue('email').Value);
    if not(isEmailValid) then
    begin
      result := badRequest(TInvalidParamError.New('email').body);
      exit;
    end;

    FAddAccountModel := TAddAccountModel.New //
      .name(lBody.GetValue('name').Value) //
      .email(lBody.GetValue('email').Value) //
      .password(lBody.GetValue('password').Value);

    // FAddAccount.add(FAddAccountModel);

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
