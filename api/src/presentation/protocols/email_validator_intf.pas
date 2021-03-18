unit email_validator_intf;

interface

type

{$M+}
  IEmailValidator = interface
    ['{03749047-F1FE-4139-AA6D-FD244907E47A}']
    function isValid(const email: String): Boolean;
  end;
{$M-}

implementation

end.
