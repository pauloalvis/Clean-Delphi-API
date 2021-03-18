unit email_validator_adapter_test;

interface

uses
  DUnitX.TestFramework;

implementation

type

  [TestFixture]
  TSignupTest = class(TObject)
  public
    [Test]
    procedure ShouldReturnFalseIfValidatorReturnFalse;
  end;

procedure TSignupTest.ShouldReturnFalseIfValidatorReturnFalse;
var
  isValid: Boolean;
  // sut: IEmailValidatorAdapter;
begin

  // isValid :=

end;

end.
