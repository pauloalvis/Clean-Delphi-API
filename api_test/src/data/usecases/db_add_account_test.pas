unit db_add_account_test;

interface

uses
  DUnitX.TestFramework,

  encrypter,
  add_account,
  delphi.mocks,
  db_add_account;

type
  ITypeSut = interface
    ['{6B289352-E5CA-4F63-845F-523EC2A99E86}']
    function MockSut: IAddAccount;
    function MockEncrypter: TMock<IEncrypter>;
  end;

  TTypeSut = class(TInterfacedObject, ITypeSut)
  private
    FMockSut: IAddAccount;
    FMockEncrypter: TMock<IEncrypter>;

    function MockSut: IAddAccount;
    function MockEncrypter: TMock<IEncrypter>;

    constructor Create;
  private
    class function New: ITypeSut;
  end;

  [TestFixture]
  TDBADDAccountTest = class
    function MakeSut: ITypeSut;

  public
    [Test]
    procedure ShouldCallEncrypterWithCorrectPassword;
  end;

implementation

function TDBADDAccountTest.MakeSut: ITypeSut;
begin
  result := TTypeSut.New;
  result.MockEncrypter.Setup.WillReturnDefault('encrypt', 'valid_password');
end;

procedure TDBADDAccountTest.ShouldCallEncrypterWithCorrectPassword;
var
  lTypeSut: ITypeSut;
  accountDataDummie: IAddAccountModel;
begin
  accountDataDummie := TAddAccountModel.New //
    .name('valid_name') //
    .email('valid_email') //
    .password('valid_password');

  lTypeSut := MakeSut;

  lTypeSut.MockEncrypter.Setup.Expect.AtLeastOnce.When.encrypt('valid_password');

  lTypeSut.MockSut.add(accountDataDummie);

  lTypeSut.MockEncrypter.Verify;
end;

constructor TTypeSut.Create;
begin
  FMockEncrypter := TMock<IEncrypter>.Create;
  FMockSut := TDBADDAccount.New(FMockEncrypter);
end;

function TTypeSut.MockEncrypter: TMock<IEncrypter>;
begin
  result := FMockEncrypter;
end;

function TTypeSut.MockSut: IAddAccount;
begin
  result := FMockSut;
end;

class function TTypeSut.New: ITypeSut;
begin
  result := TTypeSut.Create;
end;

initialization

TDUnitX.RegisterTestFixture(TDBADDAccountTest);

end.
