unit controller_intf;

interface

uses
  System.JSON,

  http_intf;

type

  IController = interface
    ['{3A659460-584A-4BEC-AD96-C1E33B0B3AC1}']
    function handle(const httpRequest: IHttpRequest): IHttpResponse;
  end;

implementation

end.
