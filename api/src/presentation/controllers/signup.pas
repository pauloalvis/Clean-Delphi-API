unit signup;

interface

uses
  system.json,

  http,
  http_helpers,
  missing_param_error;

type
  TSignupController = class
    function handle(const httpRequest: TJSONObject): IHttpResponse;
  end;

implementation

function TSignupController.handle(const httpRequest: TJSONObject): IHttpResponse;
begin
  if not(Assigned(httpRequest.FindValue('name'))) then
    result := badRequest(TMissingParamError.New('name').GetBody)
  else if not(Assigned(httpRequest.FindValue('email'))) then
    result := badRequest(TMissingParamError.New('email').GetBody);
end;

end.
