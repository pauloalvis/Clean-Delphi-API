unit signup;

interface

uses
  system.json,

  http,
  http_helpers,
  missing_param_error;

type
  TSignup = class
    function handle(const httpRequest: TJSONObject): IHttpResponse;
  end;

implementation

function TSignup.handle(const httpRequest: TJSONObject): IHttpResponse;
begin
  result := badRequest(TMissingParamError.New('name').GetBody);
  result := badRequest(TMissingParamError.New('email').GetBody);
end;

end.
