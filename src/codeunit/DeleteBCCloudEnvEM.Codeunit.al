codeunit 55507 "DeleteBCCloudEnv_EM"
{
    procedure RemoveBCCloudEnvironmentConfirm(EnvironmentName: text[50])
    var
        DoYouReallyWantToDeleteLbl: Label 'Do you want to delete %1 environment?', Comment = '%1 Env name';
    begin
        if not Confirm(strsubstno(DoYouReallyWantToDeleteLbl, EnvironmentName), false) then
            exit;

        Message('Deleting..');
        RemoveBCCloudEnvironment(EnvironmentName);
    end;

    procedure RemoveBCCloudEnvironment(EnvironmentName: text[50])
    var
        ConnectionSetup: Record "Environments Setup_EM";
        APIRequest: Text;
        Client: HttpClient;
        Response: HttpResponseMessage;
        url: text;
    begin
        APIRequest := StrSubstNo('/admin/v2.0/applications/BusinessCentral/environments/%1', EnvironmentName);
        url := StrSubstNo('%1%2', ConnectionSetup.GetBaseURL(), APIRequest);

        Client.DefaultRequestHeaders.Add('Authorization', StrSubstNo('Bearer %1', ConnectionSetup.GetAuthToken()));

        Client.Delete(url, Response);
    end;
}