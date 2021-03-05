unit signup;

interface

uses
  system.json,

  http,
  http_helpers,
  missing_param_error,
  controller, email_validator;

type
  TSignupController = class(TInterfacedObject, IController)
    FEmailValidator: IEmailValidator;
    function handle(const httpRequest: IHttpRequest): IHttpResponse;
    constructor Create(AEmailValidator: IEmailValidator);
  end;

implementation

uses
  invalid_param_error;

constructor TSignupController.Create(AEmailValidator: IEmailValidator);
begin
  FEmailValidator := AEmailValidator;
end;

function TSignupController.handle(const httpRequest: IHttpRequest)
  : IHttpResponse;
const
  requiredFields: TArray<String> = ['name', 'email', 'password',
    'passwordConfirmation'];
var
  lField: String;
  isEmailValid: Boolean;
begin
  for lField in requiredFields do
  begin
    if not(Assigned(httpRequest.body.GetValue(lField))) then
    begin
      result := badRequest(TMissingParamError.New(lField).body);
      exit;
    end;
  end;

  isEmailValid := self.FEmailValidator.isValid
    (httpRequest.body.GetValue('email').Value);

  if not(isEmailValid) then
    result := badRequest(TInvalidParamError.New('email').body);

end;

end.
