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
begin
  result := TJSONObject.Create //
    .AddPair('statusCode', TJSONNumber.Create(400)) //
    .AddPair('error', 'Missing param: name');
end;

end.
