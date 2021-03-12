unit add_account;

interface

uses
  account;

type
{$M+}
  IAddAccountModel = interface
    ['{F54BD6F9-0516-4DB6-A564-2224F5748874}']
    function name: String; overload;
    function name(const AValue: String): IAddAccountModel; overload;

    function email: String; overload;
    function email(const AValue: String): IAddAccountModel; overload;

    function password: String; overload;
    function password(const AValue: String): IAddAccountModel; overload;
  end;

  IAddAccount = interface
    ['{3212DFB8-7B72-4406-895A-290E85CA7001}']
    function add(const account: IAddAccountModel): Boolean;
  end;

  TAddAccountModel = class(TInterfacedObject, IAddAccountModel)
  private
    FName: String;
    FEmail: String;
    FPassword: String;

    function name: String; overload;
    function name(const AValue: String): IAddAccountModel; overload;

    function email: String; overload;
    function email(const AValue: String): IAddAccountModel; overload;

    function password: String; overload;
    function password(const AValue: String): IAddAccountModel; overload;
  public
    class function New: IAddAccountModel;
  end;

{$M-}

implementation

function TAddAccountModel.email: String;
begin
  result := FEmail;
end;

function TAddAccountModel.email(const AValue: String): IAddAccountModel;
begin
  FEmail := AValue;
  result := self;
end;

function TAddAccountModel.name(const AValue: String): IAddAccountModel;
begin
  FName := AValue;
  result := self;
end;

function TAddAccountModel.name: String;
begin
  result := FName;
end;

class function TAddAccountModel.New: IAddAccountModel;
begin
  result := self.Create;
end;

function TAddAccountModel.password: String;
begin
  result := FPassword;
end;

function TAddAccountModel.password(const AValue: String): IAddAccountModel;
begin
  FPassword := AValue;
  result := self;
end;

end.
