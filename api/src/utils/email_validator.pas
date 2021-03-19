unit email_validator;

interface

uses
  email_validator_intf;

type
  TEmailValidatorAdapter = class(TInterfacedObject, IEmailValidator)
    function isValid(const email: String): Boolean;

  public
    class function New: IEmailValidator;
  end;

implementation

function TEmailValidatorAdapter.isValid(const email: String): Boolean;
begin
  result := true;
end;

class function TEmailValidatorAdapter.New: IEmailValidator;
begin
  result := Self.Create;
end;

end.
