unit email_validator_adapter_test;

interface

uses
  delphi.mocks,
  DUnitX.TestFramework;

implementation

uses
  email_validator_adapter,
  email_validator_intf;

type

  [TestFixture]
  TEmailValidatorAdapterTest = class(TObject)
  public
    [Test]
    procedure ShouldReturnFalseIfEmailNotValid;
    [Test]
    procedure ShouldReturnTrueIfEmailValid;
  end;

procedure TEmailValidatorAdapterTest.ShouldReturnFalseIfEmailNotValid;
var
  isValid: Boolean;
begin
  isValid := TEmailValidatorAdapter.New //
    .isValid('invalid_email');

  Assert.IsFalse(isValid);
end;

procedure TEmailValidatorAdapterTest.ShouldReturnTrueIfEmailValid;
var
  isValid: Boolean;
begin
  isValid := TEmailValidatorAdapter.New //
    .isValid('valid_email@gmail.com');

  Assert.IsTrue(isValid);
end;

initialization

TDUnitX.RegisterTestFixture(TEmailValidatorAdapterTest);

end.
