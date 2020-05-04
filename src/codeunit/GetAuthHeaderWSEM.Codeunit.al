codeunit 55504 "GetAuthHeaderWS_EM"
{
    procedure GetToken(URL: Text; Username: Text; Password: Text; TenantDomain: Text; AppId: Guid; ClientSecret: Text[50]) Token: Text
    var
        HttpClient: HttpClient;
        ContentHeaders: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        Content: HttpContent;
        Response: HttpResponseMessage;
        authUrl: Label 'https://login.windows.net/%1/oauth2/token?resource=https://api.businesscentral.dynamics.com';
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
        HttpClient.Post(StrSubstNo(authUrl, TenantDomain), Content, Response);

        Response.Content.ReadAs(ResponseText);
        JsonObject.ReadFrom(ResponseText);
        JsonObject.SelectToken('access_token', JsonToken);


        Token := JsonToken.AsValue().AsText();
    end;
}