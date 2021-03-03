unit http_helpers;

interface

uses
  System.JSON,

  http, missing_param_error;

function badRequest(const AValue: TJsonObject): HttpResponse;

implementation

function badRequest(const AValue: TJsonObject): HttpResponse;
begin
  result := THttpResponse.New //
    .statusCode(400); //

  result.body(AValue);
end;

end.
