unit server_error;

interface

uses
  System.Json,

  System.SysUtils,
  error;

type

  TServerError = class(TInterfacedObject, IError)
  private
    FBody: TJSONObject;

    constructor Create;
    function Body: TJSONObject;

  public
    class function New: IError;
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

class function TServerError.New: IError;
begin
  result := self.Create;
end;

end.
