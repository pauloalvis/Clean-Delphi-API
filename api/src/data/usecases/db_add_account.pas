unit db_add_account;

interface

uses
  add_account,
  account,
  encrypter;

type

  TDBAddAccount = class(TInterfacedObject, IAddAccount)
  private
    FEncrypter: IEncrypter;

    function add(const account: IAddAccountModel): IAccountModel;
    constructor Create(const AValue: IEncrypter);

  public
    class function New(const AValue: IEncrypter): IAddAccount;
  end;

implementation

function TDBAddAccount.add(const account: IAddAccountModel): IAccountModel;
begin
  //
end;

constructor TDBAddAccount.Create(const AValue: IEncrypter);
begin
  FEncrypter := AValue;
end;

class function TDBAddAccount.New(const AValue: IEncrypter): IAddAccount;
begin
  result := Self.Create(AValue);
end;

end.
