unit http_helpers;

interface

uses
  System.JSON,

  http_intf;

function badRequest(const AError: TJSONObject): IHttpResponse;
function serverError: IHttpResponse;
function OK(const Value: TJSONObject): IHttpResponse;

implementation

function badRequest(const AError: TJSONObject): IHttpResponse;
begin
  result := THttpResponse.New.statusCode(400).body(AError);
end;

function serverError: IHttpResponse;
begin
  result := THttpResponse.New.statusCode(500) //
    .body(TJSONObject.Create.AddPair('error', 'Internal Server Error'));
end;

function OK(const Value: TJSONObject): IHttpResponse;
begin
  result := THttpResponse.New.statusCode(200).body(Value);
end;

end.
