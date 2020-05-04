codeunit 55507 "DeleteBCCloudEnv_EM"
{
    procedure RemoveBCCloudEnvironmentConfirm(EnvironmentName: text[50])
    var
        DoYouReallyWantToDeleteLbl: Label 'Do you really want to delete %1 environment?', Comment = '%1 Env name';
        AreYouSureLbl: Label 'Are you sure?';
        CanYouConfirmLbl: Label 'Can you please confirm again?';
    begin
        if not Confirm(strsubstno(DoYouReallyWantToDeleteLbl, EnvironmentName), false) then
            exit;
        if not Confirm(AreYouSureLbl, false) then
            exit;
        if Confirm(CanYouConfirmLbl, false) then begin
            Message('Sorry, you have to go to sleep');
            exit;
        end;
        Message('Oook, Let''s do it');
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