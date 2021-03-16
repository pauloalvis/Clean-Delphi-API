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

  TAccountModel = class(TInterfacedObject, IAccountModel)
  private
    FID: String;
    FName: String;
    FEmail: String;
    FPassword: String;

    function id: String; overload;
    function id(const AValue: String): IAccountModel; overload;

    function name: String; overload;
    function name(const AValue: String): IAccountModel; overload;

    function email: String; overload;
    function email(const AValue: String): IAccountModel; overload;

    function password: String; overload;
    function password(const AValue: String): IAccountModel; overload;
  public
    class function New: IAccountModel;
  end;

implementation

function TAccountModel.email: String;
begin
  result := FEmail;
end;

function TAccountModel.email(const AValue: String): IAccountModel;
begin
  FEmail := AValue;
  result := Self;
end;

function TAccountModel.id(const AValue: String): IAccountModel;
begin
  FID := AValue;
  result := Self;
end;

function TAccountModel.id: String;
begin
  result := FID;
end;

function TAccountModel.name(const AValue: String): IAccountModel;
begin
  FName := AValue;
  result := Self;
end;

function TAccountModel.name: String;
begin
  result := FName;
end;

class function TAccountModel.New: IAccountModel;
begin
  result := Self.Create;
end;

function TAccountModel.password: String;
begin
  result := FPassword;
end;

function TAccountModel.password(const AValue: String): IAccountModel;
begin
  FPassword := AValue;
  result := Self;
end;

end.
