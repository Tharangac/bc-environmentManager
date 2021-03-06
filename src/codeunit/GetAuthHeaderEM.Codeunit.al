codeunit 55504 "GetAuthHeader_EM"
{
    procedure GetToken(URL: Text; Username: Text; Password: Text; TenantDomain: Text; AppId: Guid; ClientSecret: Text[50]; ShowErrorMsg: Boolean; var ErrorMsg: Text) Token: Text
    var
        HttpClient: HttpClient;
        ContentHeaders: HttpHeaders;
        Content: HttpContent;
        Response: HttpResponseMessage;
        AuthURLLbl: Label 'https://login.windows.net/%1/oauth2/token?resource=https://api.businesscentral.dynamics.com', Comment = '%1 domain name';
        body: Text;
        ResponseText: Text;
        JsonObject: JsonObject;
        JsonToken: JsonToken;
    begin
        body := StrSubstNo('grant_type=password&username=%1&password=%2&client_id=%3&resource=%4&client_secret=%5',
                                                Username,
                                                Password,
                                                AppId,
                                                URL,
                                                ClientSecret);

        Content.WriteFrom(body);
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpClient.Post(StrSubstNo(AuthURLLbl, TenantDomain), Content, Response);

        Response.Content.ReadAs(ResponseText);
        JsonObject.ReadFrom(ResponseText);
        JsonObject.SelectToken('access_token', JsonToken);


        Token := JsonToken.AsValue().AsText();
    end;
}