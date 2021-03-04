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

function TSignupController.handle(const httpRequest: TJSONObject)
  : IHttpResponse;
const
  requiredFields: TArray<String> = ['name', 'email'];

var
  lField: String;
begin
  for lField in requiredFields do
  begin
    if not(Assigned(httpRequest.FindValue(lField))) then
    begin
      result := badRequest(TMissingParamError.New(lField).GetBody);

      Break;
    end;
  end;
end;

end.
