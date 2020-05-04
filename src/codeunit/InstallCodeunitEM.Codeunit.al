codeunit 55502 "Install Codeunit_EM"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Setup: Record "Environments Setup_EM";
    begin
        Setup.InsertIfNotExists();
        Setup.Get();
        Setup."App Id" := 'a1881e69-9580-4d64-8126-a0aa85db1f63';
        Setup."Resource url" := 'https://api.businesscentral.dynamics.com';
        Setup."Tenant Domain" := 'cmtn.onmicrosoft.com';
        Setup."User Name" := 'admin@cmtn.onmicrosoft.com';
        Setup.Modify();
    end;

}