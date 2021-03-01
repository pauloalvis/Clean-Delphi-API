unit signup_test;

interface

uses
  signup,
  System.JSON,
  DUnitX.TestFramework;

type

  [TestFixture]
  TSignupTest = class(TObject)
  private
    FSUT: TSignup;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure handle;
  end;

implementation

uses
  vcl.dialogs,
  System.SysUtils,
  missing_param_error,
  http;

procedure TSignupTest.handle;
var
  lHTTPResponse: HttpResponse;
  lBody, lHTTPRequest: TJSONObject;
begin
  lHTTPRequest := TJSONObject.Create;
  try
    lBody := TJSONObject.Create;
    lBody.AddPair('email', 'any_email2hotmail.com');
    lBody.AddPair('password', 'any_password');
    lBody.AddPair('passwordConfirmation', 'any_password');

    lHTTPRequest.AddPair('body', lBody);

    lHTTPResponse := FSUT.handle(lHTTPRequest);
    try
      Assert.IsTrue(lHTTPResponse.statusCode.ToString.Equals('400'));

      Assert.IsTrue(TMissingParamError(error)
        .ToString.Equals(TMissingParamError.New('name')),
        'Deve retornar o Erro: "Missing param: name" se o name não for informado.');

      // Assert.IsTrue(lHTTPResponse.GetValue('error')
      // .Value.Equals(TMissingParamError.New('name').ToString),
      // '');
    finally
      // lHTTPResponse.DisposeOf;
    end;

  finally
    lHTTPRequest.DisposeOf;
  end;

  lHTTPRequest := TJSONObject.Create;
  try
    lBody := TJSONObject.Create;
    lBody.AddPair('name', 'any_name');
    lBody.AddPair('password', 'any_password');
    lBody.AddPair('passwordConfirmation', 'any_password');

    lHTTPRequest.AddPair('body', lBody);

    lHTTPResponse := FSUT.handle(lHTTPRequest);
    try
      // Assert.IsTrue(lHTTPResponse.GetValue('statusCode').ToString.Equals('400'),
      // 'Deve retornar 400 se o email não for informado.');

      // Assert.IsTrue(lHTTPResponse.GetValue('error')
      // .Value.Equals(TMissingParamError.New('email').ToString),
      // 'Deve retornar o Erro: "Missing param: email" se o email não for informado.');

    finally
      // lHTTPResponse.DisposeOf;
    end;

  finally
    lHTTPRequest.DisposeOf;
  end;
end;

procedure TSignupTest.Setup;
begin
  FSUT := TSignup.Create;
end;

procedure TSignupTest.TearDown;
begin
  FreeAndNil(FSUT);
end;

initialization

end.
