unit add_account;

interface

uses
  account;

type

  IAddAccountModel = interface
    ['{F54BD6F9-0516-4DB6-A564-2224F5748874}']
    function name: String; overload;
    function name(const AValue: String): IAccountModel; overload;

    function email: String; overload;
    function email(const AValue: String): IAccountModel; overload;

    function password: String; overload;
    function password(const AValue: String): IAccountModel; overload;
  end;

  IAddAccount = interface
    ['{3212DFB8-7B72-4406-895A-290E85CA7001}']
    function add(const account: IAddAccountModel): IAccountModel;
  end;

implementation

end.
