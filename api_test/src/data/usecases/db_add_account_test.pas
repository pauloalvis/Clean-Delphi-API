unit db_add_account_test;

interface

uses

  delphi.mocks,
  db_add_account,
  DUnitX.TestFramework;

type

  [TestFixture]
  TDBADDAccountTest = class[Test]
    procedure ShouldCallEncrypterWithCorrectPassword;
  end;

implementation

uses
  encrypter,
  add_account;

procedure TDBADDAccountTest.ShouldCallEncrypterWithCorrectPassword;
var
  accountData: IAddAccountModel;
  sut: IADDAccount;
  encryperStub: TMock<IEncrypter>;
begin
  encryperStub := TMock<IEncrypter>.Create;

  sut := TDBADDAccount.New(encryperStub);

  accountData := TAddAccountModel.New //
    .name('valid_name') //
    .email('valid_email') //
    .password('valid_password');

  encryperStub.Setup.Expect.AtLeastOnce.When.encrypt('valid_password');

  sut.add(accountData);

  encryperStub.Verify;
end;

initialization

TDUnitX.RegisterTestFixture(TDBADDAccountTest);

end.
