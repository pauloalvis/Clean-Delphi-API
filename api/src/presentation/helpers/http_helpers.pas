unit http_helpers;

interface

uses
  System.JSON,

  http;

function badRequest(const AError: TJSONObject): IHttpResponse;
function ok: IHttpResponse;

implementation

function badRequest(const AError: TJSONObject): IHttpResponse;
begin
  result := THttpResponse.New //
    .statusCode(400) //
    .body(AError);
end;

function ok: IHttpResponse;
begin
  result := THttpResponse.New //
    .statusCode(200);
end;

end.
