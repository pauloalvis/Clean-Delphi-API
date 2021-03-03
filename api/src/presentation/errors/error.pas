unit error;

interface

type
  IError<T> = interface
    ['{9A54F64D-D034-4C9C-95C2-7F974E5893B3}']
    function Instance: T;
  end;

  TError<T> = class(TInterfacedObject, IError<T>)
  private
    FValue: T;
  public
    class function Instance: T;
  end;

implementation

class function TError<T>.Instance: T;
begin
  // result := FValue;
end;

end.
