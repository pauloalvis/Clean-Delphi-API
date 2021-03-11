unit signup;

interface

uses
  system.json,

  http,
  controller,
  server_error,
  http_helpers,
  email_validator,
  missing_param_error;

type
  TSignupController = class(TInterfacedObject, IController)
    FEmailValidator: IEmailValidator;
    function handle(const httpRequest: IHttpRequest): IHttpResponse;
    constructor Create(AEmailValidator: IEmailValidator);
  end;

implementation

uses
  invalid_param_error,
  system.SysUtils;

constructor TSignupController.Create(AEmailValidator: IEmailValidator);
begin
  FEmailValidator := AEmailValidator;
end;

function TSignupController.handle(const httpRequest: IHttpRequest): IHttpResponse;
var
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
      result := badRequest(TInvalidParamError.New('email').body);

  except
    result := THttpResponse.New //
      .statusCode(500) //
      .body(TServerError.New.body);
  end;
end;

end.
