table 55501 "Environment_EM"
{

    fields
    {
        field(1; id; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }

        field(2; Name; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; Country; Text[2])
        {
            DataClassification = CustomerContent;
        }
        field(4; Version; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; Status; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; Type; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(10; webClientLoginUrl; text[250])
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "id")
        {
            Clustered = true;
        }
    }

    procedure GetBCCloudEnvironments();
    var
        EnvironmentMgt: Codeunit "Environments Mgt._EM";
    begin
        EnvironmentMgt.GetBCCloudEnvironments();
    end;

    procedure RunCreateNewEnvironmentWizard();
    var
        EnvironmentMgt: Codeunit "Environments Mgt._EM";
    begin
        EnvironmentMgt.RunCreateNewEnvironmentWizard();
    end;

    procedure NewBCCloudEnvironment(EnvironmentName: text[30]; EnvironmentCountry: code[2]; EnvironmentVersion: code[20]; EnvironmentType: Text);
    var
        EnvironmentMgt: Codeunit "Environments Mgt._EM";
    begin
        EnvironmentMgt.NewBCCloudEnvironment(EnvironmentName, EnvironmentCountry, EnvironmentVersion, EnvironmentType);
    end;

    procedure RemoveBCCloudEnvironment()
    var
        EnvironmentMgt: Codeunit "Environments Mgt._EM";
    begin
        EnvironmentMgt.RemoveBCCloudEnvironment(Name);
    end;


}