unit encrypter;

interface

type
{$M+}
  IEncrypter = interface
    ['{8A6AA867-31E4-4C82-9E4E-4220FEFE9878}']
    function encrypt(const AValue: String): String;
  end;
{$M-}

implementation

end.
