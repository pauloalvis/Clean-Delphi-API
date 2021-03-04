unit missing_param_error;

interface

uses
  System.Json,

  error;

type

  TMissingParamError = class(TInterfacedObject, IError)
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

constructor TMissingParamError.Create(const AParamName: String);
begin
  FBody := TJSONObject.Create.AddPair('error', format('Missing param: %s', [AParamName]));
end;

function TMissingParamError.Body: TJSONObject;
begin
  result := FBody;
end;

class function TMissingParamError.New(Const AParamName: String): IError;
begin
  result := self.Create(AParamName);
end;

end.
