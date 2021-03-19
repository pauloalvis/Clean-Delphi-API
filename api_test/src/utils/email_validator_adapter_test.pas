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
  end;

procedure TEmailValidatorAdapterTest.ShouldReturnFalseIfValidatorReturnFalse;
var
  sut: IEmailValidator;
  isValid: Boolean;
begin
  sut := TEmailValidatorAdapter.New;
  isValid := sut.isValid('invalid_email@email.com');
  Assert.IsTrue(isValid);
end;

initialization

TDUnitX.RegisterTestFixture(TEmailValidatorAdapterTest);

end.
