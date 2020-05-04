table 55500 "Environments Setup_EM"
{
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Resource url"; text[250])
        {
            ExtendedDatatype = URL;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckIfValidUrl("Resource url");
            end;
        }
        field(11; "Tenant Domain"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(12; "App Id"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(13; "Client Secret"; Text[50])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
        field(14; "User Name"; Text[250])
        {
            Caption = 'User Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(15; "User Password"; Text[50])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure InsertIfNotExists()
    var
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;

    local procedure CheckIfValidUrl(url: Text)
    var
        WebRequestHelper: Codeunit "Web Request Helper";
    begin
        if url = '' then
            exit;
        WebRequestHelper.IsValidUri(url);
    End;

    procedure HasPassword(): Boolean
    begin
        Get();
        exit("User Password" <> '');
    end;

    procedure GetPassword(): Text
    begin
        Get();
        exit("User Password");
    End;

    procedure isConnectionEstablished(ShowErrorMsg: Boolean; var ErrorMsg: Text): Boolean
    var
        EnvironmentsMgt: Codeunit "Environments Mgt._EM";
    begin
        Exit(EnvironmentsMgt.CheckConnection("Resource url", "User Name", GetPassword(), "Tenant Domain", "App Id", "Client Secret", ShowErrorMsg, ErrorMsg));
    end;

    procedure GetBaseURL(): Text
    begin
        InsertIfNotExists();
        exit("Resource url");
    end;

    procedure GetUserName(): Text
    begin
        InsertIfNotExists();
        exit("User Name");
    end;

    procedure GetAuthToken(): Text
    var
        EnvironmentMgt: Codeunit "Environments Mgt._EM";
    begin
        InsertIfNotExists();
        exit(EnvironmentMgt.GetAuthHeader("Resource url", "User Name", GetPassword(), "Tenant Domain", "App Id", "Client Secret"));
    end;



}