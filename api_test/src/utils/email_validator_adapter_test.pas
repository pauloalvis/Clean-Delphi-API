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
    procedure ShouldReturnFalseIfValidatorReturnFalse;
    [Test]
    procedure ShouldReturnTrueIfValidatorReturnTrue;
  end;

procedure TEmailValidatorAdapterTest.ShouldReturnFalseIfValidatorReturnFalse;
var
  sut: TMock<IEmailValidator>;
  isValid: Boolean;
begin
  sut := TMock<IEmailValidator>.Create;
  sut.Setup.WillReturn('isValid', false);
  isValid := sut.isValid('invalid_email@email.com');
  Assert.IsFalse(isValid);
end;

procedure TEmailValidatorAdapterTest.ShouldReturnTrueIfValidatorReturnTrue;
var
  sut: IEmailValidator;
  isValid: Boolean;
begin
  sut := TEmailValidatorAdapter.New;
  isValid := sut.isValid('valid_email@gmail.com');
  Assert.IsTrue(isValid);
end;

initialization

TDUnitX.RegisterTestFixture(TEmailValidatorAdapterTest);

end.
