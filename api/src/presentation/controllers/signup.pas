unit signup;

interface

uses
  system.json;

type
  TSignup = class
    function handle(const httpRequest: TJSONObject): TJSONObject;
  end;

implementation

function TSignup.handle(const httpRequest: TJSONObject): TJSONObject;
var
  lBody: TJSONValue;
begin
   lBody := httpRequest.FindValue('body');

  result := TJSONObject.Create //
    .AddPair('statusCode', TJSONNumber.Create(400));

  if not(Assigned(lBody.FindValue('name'))) then
  begin
    result.AddPair('error', 'Missing param: name');
  end
  else if not(Assigned(lBody.FindValue('email'))) then
    result.AddPair('error', 'Missing param: email');
end;

end.
