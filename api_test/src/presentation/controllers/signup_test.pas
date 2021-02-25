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
  System.SysUtils;

procedure TSignupTest.handle;
var
  lBody, lHTTPResponse, lHTTPRequest: TJSONObject;
begin
  lHTTPRequest := TJSONObject.Create;
  try
    lBody := TJSONObject.Create;
    lBody.AddPair('email', 'any_email2hotmail.com');
    lBody.AddPair('password', 'any_password');
    lBody.AddPair('passwordConfirmation', 'any_password');

    lHTTPRequest.AddPair('body', lBody);

    lHTTPResponse := FSUT.handle(lHTTPRequest);
    Assert.IsTrue(lHTTPResponse.GetValue('statusCode').ToString.Equals('400'),
      'Shoud return 400 if no name is provided');

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

TDUnitX.RegisterTestFixture(TSignupTest);

end.

