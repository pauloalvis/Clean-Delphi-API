unit server_error;

interface

uses
  System.Json,

  System.SysUtils;

type

  TServerError = class(Exception)
  private
    FBody: TJSONObject;

    constructor Create;

  public

    function Body: TJSONObject;
    class function New: TServerError;
  end;

implementation

constructor TServerError.Create;
begin
  FBody := TJSONObject.Create.AddPair('error', 'Internal Server Error');
end;

function TServerError.Body: TJSONObject;
begin
  result := FBody;
end;

class function TServerError.New: TServerError;
begin
  result := self.Create;
end;

end.
