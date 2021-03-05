unit invalid_param_error;

interface

uses
  System.Json,

  error;

type

  TInvalidParamError = class(TInterfacedObject, IError)
  private
    FBody: TJSONObject;

    function Body: TJSONObject;
    constructor Create(Const AParamName: String);

  public
    class function New(Const AParamName: String): IError;
  end;

implementation

uses
  System.SysUtils;

constructor TInvalidParamError.Create(const AParamName: String);
begin
  FBody := TJSONObject.Create.AddPair('error', format('Invalid param: %s',
    [AParamName]));
end;

function TInvalidParamError.Body: TJSONObject;
begin
  result := FBody;
end;

class function TInvalidParamError.New(Const AParamName: String): IError;
begin
  result := self.Create(AParamName);
end;

end.
