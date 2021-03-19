unit email_validator_adapter_test;

interface

uses
  delphi.mocks,
  DUnitX.TestFramework;

implementation

uses
  email_validator,
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
  sut: IEmailValidator;
begin
  sut := TEmailValidatorAdapter.New;
  isValid := sut.isValid('invalid_email');
  Assert.IsFalse(isValid);
end;

procedure TEmailValidatorAdapterTest.ShouldReturnTrueIfEmailValid;
var
  isValid: Boolean;
  sut: IEmailValidator;
begin
  sut := TEmailValidatorAdapter.New;
  isValid := sut.isValid('valid_email@gmail.com');
  Assert.IsTrue(isValid);
end;

initialization

TDUnitX.RegisterTestFixture(TEmailValidatorAdapterTest);

end.
