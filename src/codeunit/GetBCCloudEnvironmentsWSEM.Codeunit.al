codeunit 55503 "GetBCCloudEnvironments WS_EM"
{
    procedure GetBCCloudEnvironments()
    var
        Arguments: Record "WebService Argument_EM";
        Environment: Record "Environment_EM";
        APIRequest: Text;
    begin
        APIRequest := '/admin/v2.0/applications/BusinessCentral/environments';

        InitArguments(Arguments, APIRequest);

        IF not CallWebService(Arguments) then
            EXIT;

        SaveResultInEnvironmentsTable(Arguments, Environment);
    end;

    local procedure InitArguments(var Arguments: Record "WebService Argument_EM" temporary; APIRequest: Text);
    var
        ConnectionSetup: Record "Environments Setup_EM";
    begin
        WITH Arguments DO begin
            URL := CopyStr(STRSUBSTNO('%1%2', ConnectionSetup.GetBaseURL(), APIRequest), 0, MaxStrLen(URL));
            RestMethod := RestMethod::get;
            Bearer := CopyStr(ConnectionSetup.GetAuthToken(), 0, MaxStrLen(Bearer));
        end;
    end;

    local procedure CallWebService(var Arguments: Record "WebService Argument_EM" temporary) Success: Boolean
    var
        WebService: codeunit "WebService Call Functions_EM";
    begin
        Success := WebService.CallWebService(Arguments);
    end;

    local procedure SaveResultInEnvironmentsTable(var Arguments: Record "WebService Argument_EM" temporary; var Environment: Record "Environment_EM")
    var
        WebService: Codeunit "WebService Call Functions_EM";
        JsonArray: JsonArray;
        JsonToken: JsonToken;
        JsonObject: JsonObject;
        i: Integer;
        ResponseInTextFormat: Text;
    begin
        ResponseInTextFormat := Arguments.GetResponseContentAsText();
        HandleResponseForJsonArrayFormat(ResponseInTextFormat);
        Environment.DeleteAll();
        If not JsonArray.ReadFrom(ResponseInTextFormat) then
            error('Invalid response, expected an JSON array as root object');
        For i := 0 to JsonArray.Count - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonObject := JsonToken.AsObject();
            WITH Environment do begin
                Init();
                id := i + 1;
                Type := CopyStr(WebService.SelectJsonValueAsText(JsonObject, 'type'), 0, MaxStrLen(Type));
                Name := CopyStr(WebService.SelectJsonValueAsText(JsonObject, 'name'), 0, MaxStrLen(Name));
                Country := CopyStr(WebService.SelectJsonValueAsText(JsonObject, 'countryCode'), 0, MaxStrLen(Country));
                Version := CopyStr(WebService.SelectJsonValueAsText(JsonObject, 'applicationVersion'), 0, MaxStrLen(Version));
                Status := CopyStr(WebService.SelectJsonValueAsText(JsonObject, 'status'), 0, MaxStrLen(Status));
                webClientLoginUrl := CopyStr(WebService.SelectJsonValueAsText(JsonObject, 'webClientLoginUrl'), 0, MaxStrLen(webClientLoginUrl));
                Insert(true);
            end;
        end;
    end;

    local procedure HandleResponseForJsonArrayFormat(var Response: Text);
    var
        WebService: Codeunit "WebService Call Functions_EM";
        Jobj: JsonObject;
        Jtoken: JsonToken;
    begin
        Jobj.ReadFrom(Response);
        Jtoken := WebService.SelectJsonToken(Jobj, 'value');
        Jtoken.WriteTo(Response);
    end;

}