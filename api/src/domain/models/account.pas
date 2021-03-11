unit account;

interface

type
  IAccountModel = interface
    ['{3ADB0592-AC32-44C0-B276-46184083B3C2}']

    function id: String; overload;
    function id(const AValue: String): IAccountModel; overload;

    function name: String; overload;
    function name(const AValue: String): IAccountModel; overload;

    function email: String; overload;
    function email(const AValue: String): IAccountModel; overload;

    function password: String; overload;
    function password(const AValue: String): IAccountModel; overload;
  end;

implementation

end.
