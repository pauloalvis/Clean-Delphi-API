unit signup;

interface

uses
  system.json,

  http,
  http_helpers,
  missing_param_error,
  controller;

type
  TSignupController = class(TInterfacedObject, IController)
    function handle(const httpRequest: TJSONObject): IHttpResponse;
  end;

implementation

function TSignupController.handle(const httpRequest: TJSONObject): IHttpResponse;
const
  requiredFields: TArray<String> = ['name', 'email', 'password', 'passwordConfirmation'];
var
  lField: String;
begin
  for lField in requiredFields do
  begin
    if not(Assigned(httpRequest.GetValue(lField))) then
    begin
      result := badRequest(TMissingParamError.New(lField).Body);
      exit;
    end;
  end;

  result := ok;
end;

end.
