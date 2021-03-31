unit db_add_account_test;

interface

uses
  DUnitX.TestFramework,

  encrypter,
  add_account,
  delphi.mocks,
  db_add_account;

type
  ISutType = interface
    ['{6B289352-E5CA-4F63-845F-523EC2A99E86}']
    function Sut: IAddAccount;
    function EncrypterStub: TMock<IEncrypter>;
  end;

  TSutType = class(TInterfacedObject, ISutType)
  private
    FSutType: IAddAccount;
    FEncrypterStub: TMock<IEncrypter>;

    function Sut: IAddAccount;
    function EncrypterStub: TMock<IEncrypter>;

    constructor Create;
  private
    class function New: ISutType;
  end;

  [TestFixture]
  TDBADDAccountTest = class
    function MakeSut: ISutType;

  public
    [Test]
    procedure ShouldCallEncrypterWithCorrectPassword;
  end;

implementation

function TDBADDAccountTest.MakeSut: ISutType;
begin
  result := TSutType.New;
  result.EncrypterStub.Setup.WillReturnDefault('encrypt', 'default_password');
end;

procedure TDBADDAccountTest.ShouldCallEncrypterWithCorrectPassword;
var
  lSutType: ISutType;
  accountDataStub: IAddAccountModel;
begin
  lSutType := MakeSut;

  lSutType.EncrypterStub.Setup.Expect.AtLeastOnce.When.encrypt('valid_password');

  accountDataStub := TAddAccountModel.New //
    .name('valid_name') //
    .email('valid_email') //
    .password('valid_password');

  lSutType.Sut.add(accountDataStub);

  lSutType.EncrypterStub.Verify;
end;

constructor TSutType.Create;
begin
  FEncrypterStub := TMock<IEncrypter>.Create;
  FSutType := TDBADDAccount.New(FEncrypterStub);
end;

function TSutType.EncrypterStub: TMock<IEncrypter>;
begin
  result := FEncrypterStub;
end;

function TSutType.Sut: IAddAccount;
begin
  result := FSutType;
end;

class function TSutType.New: ISutType;
begin
  result := TSutType.Create;
end;

initialization

TDUnitX.RegisterTestFixture(TDBADDAccountTest);

end.
