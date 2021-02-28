unit missing_param_error;

interface

type
  MissingParamError = interface
    ['{9A5E1982-F3CB-4DD5-9639-8E73D5016070}']
    function ToString: String;
  end;

  TMissingParamError = class(TInterfacedObject, MissingParamError)
  private
    FParamName: String;

    constructor Create(Const AParamName: String);
  public
    function ToString: String; override;
    class function New(Const AParamName: String): MissingParamError;
  end;

implementation

uses
  System.SysUtils;

constructor TMissingParamError.Create(const AParamName: String);
begin
  FParamName := AParamName;
end;

class function TMissingParamError.New(Const AParamName: String)
  : MissingParamError;
begin
  result := self.Create(AParamName);
end;

function TMissingParamError.ToString: String;
begin
  result := format('Missing param: %s', [FParamName]);
end;

end.