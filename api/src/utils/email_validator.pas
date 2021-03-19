unit email_validator;

interface

uses
  RegularExpressions,
  email_validator_intf;

type
  TEmailValidatorAdapter = class(TInterfacedObject, IEmailValidator)
    function isValid(const email: String): Boolean;

  public
    class function New: IEmailValidator;
  end;

implementation

function TEmailValidatorAdapter.isValid(const email: String): Boolean;
var
  RegEx: TRegEx;
begin
  RegEx := TRegEx.Create('^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]*[a-zA-Z0-9]+$');

  Result := RegEx.Match(email).Success;
end;

class function TEmailValidatorAdapter.New: IEmailValidator;
begin
  Result := Self.Create;
end;

end.
