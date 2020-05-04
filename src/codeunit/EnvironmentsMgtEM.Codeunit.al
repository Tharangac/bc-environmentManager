codeunit 55501 "Environments Mgt._EM"
{

    procedure CheckConnection(URL: Text; Username: Text; Password: Text; TenantDomain: Text; AppId: Guid; ClientSecret: Text[50]; ShowErrorMsg: Boolean; var ErrorMsg: Text): Boolean
    begin
        exit(SendTestRequest(URL, Username, Password, TenantDomain, AppId, ClientSecret, ShowErrorMsg, ErrorMsg));
    end;

    local procedure SendTestRequest(URL: Text; Username: Text; Password: Text; TenantDomain: Text; AppId: Guid; ClientSecret: Text[50]; ShowErrorMsg: Boolean; var ErrorMsg: Text) isSuccess: Boolean
    begin
        exit(GetAuthHeader(url, Username, Password, TenantDomain, AppId, ClientSecret) <> '');
    end;

    procedure GetAuthHeader(URL: Text; Username: Text; Password: Text; TenantDomain: Text; AppId: Guid; ClientSecret: Text[50]): Text
    var
        GetAuthHeaderWS: Codeunit "GetAuthHeaderWS_EM";
    begin
        exit(GetAuthHeaderWS.GetToken(URL, Username, Password, TenantDomain, AppId, ClientSecret));
    end;

    procedure GetBCCloudEnvironments();
    var
        GetBCCloudEnvironments: Codeunit "GetBCCloudEnvironments WS_EM";
    begin
        GetBCCloudEnvironments.GetBCCloudEnvironments();
    end;

    procedure RunCreateNewEnvironmentWizard()
    begin
        page.RunModal(page::"Env. Creation Wizard_EM");
    end;

    procedure NewBCCloudEnvironment(EnvironmentName: text[30]; EnvironmentCountry: code[2]; EnvironmentVersion: code[20]; EnvironmentType: Text);
    var
        NewBCCloudEnvironment: Codeunit "CreateBCCloudEnv_EM";
    begin
        NewBCCloudEnvironment.NewBCCloudEnvironment(EnvironmentName, EnvironmentCountry, EnvironmentVersion, EnvironmentType);
    end;

    procedure RemoveBCCloudEnvironment(EnvironmentName: text[30]);
    var
        RemoveBCCloudEnvironment: Codeunit "DeleteBCCloudEnv_EM";
    begin
        RemoveBCCloudEnvironment.RemoveBCCloudEnvironmentConfirm(EnvironmentName);
    end;

    local procedure DemoSaaSCompany(): Boolean
    var
        EnvironmentInfo: Codeunit "Environment Information";
        CompanyInformationMgt: Codeunit "Company Information Mgt.";
    begin
        EXIT(EnvironmentInfo.IsSaaS() AND CompanyInformationMgt.IsDemoCompany);
    end;



}