unit http;

interface

uses
  System.JSON;

type
  IHttpResponse = interface
    ['{0D13866C-0872-4F1D-BAEF-3C552828F92A}']
    function statusCode: integer; overload;
    function statusCode(const AValue: integer): IHttpResponse; overload;

    function body: TJsonObject; overload;
    function body(const AValue: TJsonObject): IHttpResponse; overload;
  end;

  IHttpRequest = interface
    ['{0D13866C-0872-4F1D-BAEF-3C552828F92A}']
    function body: TJsonObject; overload;
    function body(const AValue: TJsonObject): IHttpRequest; overload;
  end;

  THttpResponse = class(TInterfacedObject, IHttpResponse)
  private
    FStatusCode: integer;
    FBody: TJsonObject;

    function statusCode: integer; overload;
    function statusCode(const AValue: integer): IHttpResponse; overload;

    function body: TJsonObject; overload;
    function body(const AValue: TJsonObject): IHttpResponse; overload;
  public
    destructor Destroy; override;

    class function New: IHttpResponse;
  end;

  THttpRequest = class(TInterfacedObject, IHttpRequest)
  private
    FBody: TJsonObject;

    function body: TJsonObject; overload;
    function body(const AValue: TJsonObject): IHttpRequest; overload;
  public
    destructor Destroy; override;

    class function New: IHttpRequest;
  end;

implementation

function THttpResponse.body(const AValue: TJsonObject): IHttpResponse;
begin
  FBody := AValue;
  result := self;
end;

destructor THttpResponse.Destroy;
begin
  FBody.DisposeOf;

  inherited;
end;

function THttpResponse.body: TJsonObject;
begin
  result := FBody;
end;

class function THttpResponse.New: IHttpResponse;
begin
  result := self.Create;
end;

function THttpResponse.statusCode(const AValue: integer): IHttpResponse;
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

function THttpRequest.body(const AValue: TJsonObject): IHttpRequest;
begin
  FBody := AValue;
  result := self;
end;

destructor THttpRequest.Destroy;
begin
  FBody.DisposeOf;

  inherited;
 end;

class function THttpRequest.New: IHttpRequest;
begin
  result := self.Create;
end;

end.
