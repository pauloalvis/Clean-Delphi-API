unit http_helpers;

interface

uses
  System.JSON,

  http, missing_param_error;

function badRequest(const error: error): HttpResponse;

implementation

function badRequest(const error: error): HttpResponse;
begin
  result := THttpResponse.New //
    .statusCode(400) //
    .body(error);
end;

end.
