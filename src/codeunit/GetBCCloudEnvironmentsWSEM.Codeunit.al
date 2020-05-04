codeunit 55503 "GetBCCloudEnvironments WS_EM"
{
    procedure GetBCCloudEnvironments()
    var
        Arguments: Record "WebService Argument_EM";
        APIRequest: Text;
        Environment: Record "Environment_EM";
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
            URL := STRSUBSTNO('%1%2', ConnectionSetup.GetBaseURL(), APIRequest);
            RestMethod := RestMethod::get;
            Bearer := ConnectionSetup.GetAuthToken();
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
        ResponseInTextFormat := Arguments.GetResponseContentAsText;
        HandleResponseForJsonArrayFormat(ResponseInTextFormat);
        Environment.DeleteAll;
        If not JsonArray.ReadFrom(ResponseInTextFormat) then
            error('Invalid response, expected an JSON array as root object');
        For i := 0 to JsonArray.Count - 1 do begin
            JsonArray.Get(i, JsonToken);
            JsonObject := JsonToken.AsObject;
            WITH Environment do begin
                Init();
                id := i + 1;
                Type := WebService.SelectJsonValueAsText(JsonObject, 'type');
                Name := WebService.SelectJsonValueAsText(JsonObject, 'name');
                Country := WebService.SelectJsonValueAsText(JsonObject, 'countryCode');
                Version := WebService.SelectJsonValueAsText(JsonObject, 'applicationVersion');
                Status := WebService.SelectJsonValueAsText(JsonObject, 'status');
                webClientLoginUrl := WebService.SelectJsonValueAsText(JsonObject, 'webClientLoginUrl');
                Insert(true);
            end;
        end;
    end;

    local procedure HandleResponseForJsonArrayFormat(var Response: Text);
    var
        Jobj: JsonObject;
        Jtoken: JsonToken;
        WebService: Codeunit "WebService Call Functions_EM";
    begin
        Jobj.ReadFrom(Response);
        Jtoken := WebService.SelectJsonToken(Jobj, 'value');
        Jtoken.WriteTo(Response);
    end;

}