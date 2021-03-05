unit email_validator;

interface

type
  IEmailValidator = interface
    ['{03749047-F1FE-4139-AA6D-FD244907E47A}']
    function isValid(const email: String): Boolean;
  end;

implementation

end.
