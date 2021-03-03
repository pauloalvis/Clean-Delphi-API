unit error;

interface

uses
  System.JSON;

type
  IError = interface
    ['{7FC49DE8-86FE-42F4-9991-2B665660F8D0}']
    function GetBody: TJSONObject;
  end;

implementation

end.
