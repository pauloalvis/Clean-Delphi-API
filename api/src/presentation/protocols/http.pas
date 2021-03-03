unit http;

interface

uses
  System.JSON;

type
  HttpResponse = interface
    ['{0D13866C-0872-4F1D-BAEF-3C552828F92A}']
    function statusCode: integer; overload;
    function statusCode(const AValue: integer): HttpResponse; overload;

    function body: TJsonObject; overload;
    function body(const AValue: TJsonObject): HttpResponse; overload;
  end;

  HttpRequest = interface
    ['{0D13866C-0872-4F1D-BAEF-3C552828F92A}']
    function body: TJsonObject; overload;
    function body(const AValue: TJsonObject): HttpRequest; overload;
  end;

  THttpResponse = class(TInterfacedObject, HttpResponse)
  private
    FStatusCode: integer;
    FBody: TJsonObject;

    function statusCode: integer; overload;
    function statusCode(const AValue: integer): HttpResponse; overload;

    function body: TJsonObject; overload;
    function body(const AValue: TJsonObject): HttpResponse; overload;
  public
    class function New: HttpResponse;
  end;

  THttpRequest = class(TInterfacedObject, HttpRequest)
  private
    FBody: TJsonObject;

    function body: TJsonObject; overload;
    function body(const AValue: TJsonObject): HttpRequest; overload;
  public
    class function New: HttpRequest;
  end;

implementation

function THttpResponse.body(const AValue: TJsonObject): HttpResponse;
begin
  FBody := AValue;
  result := self;
end;

function THttpResponse.body: TJsonObject;
begin
  result := FBody;
end;

class function THttpResponse.New: HttpResponse;
begin
  result := self.Create;
end;

function THttpResponse.statusCode(const AValue: integer): HttpResponse;
begin
  FStatusCode := AValue;
  result := self;
end;

function THttpResponse.statusCode: integer;
begin
  result := FStatusCode;
end;

function THttpRequest.body: TJsonObject;
begin
  result := FBody;
end;

function THttpRequest.body(const AValue: TJsonObject): HttpRequest;
begin
  FBody := AValue;
  result := self;
end;

class function THttpRequest.New: HttpRequest;
begin
  result := self.Create;
end;

end.
