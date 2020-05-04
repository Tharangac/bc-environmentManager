page 55500 "Environments Setup_EM"
{

    PageType = Card;
    SourceTable = "Environments Setup_EM";
    UsageCategory = Administration;
    ApplicationArea = Basic;
    Caption = 'Environments Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Base API url"; "Resource url")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                }
                field("Tenant Domain"; "Tenant Domain")
                {
                    ApplicationArea = All;
                }
                field("App Id"; "App Id")
                {
                    ApplicationArea = All;
                }
                field("Client Secret"; "Client Secret")
                {
                    ApplicationArea = All;
                }
                field("User Name"; "User Name")
                {
                    ApplicationArea = All;
                }
                field("User Password"; "User Password")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("LGS TestConnection")
            {
                Caption = 'Test Connection';
                ToolTip = 'Test Connection with the subsidiary web service';
                Image = LinkWeb;
                ApplicationArea = Basic;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ConnectionIsSuccessfullyEstablishedMsg: Label 'Congratulations! Connection is successfully established.';
                    ErrorMsg: Text;
                begin
                    if not isConnectionEstablished(true, ErrorMsg) then
                        Error(ErrorMsg);
                    Message(ConnectionIsSuccessfullyEstablishedMsg);
                end;

            }
        }
    }

    var
        Password: Text[50];
        CheckedEncryption: Boolean;
        EncryptionIsNotActivatedQst: Label 'Data encryption is not activated. It is recommended that you encrypt data. \Do you want to open the Data Encryption Management window?';


    trigger OnOpenPage()
    begin
        InsertIfNotExists();
    end;

    trigger OnAfterGetRecord()
    begin

        IF HasPassword() THEN
            Password := 'Password Dots';
    end;


    procedure CheckEncryption()
    begin
        IF NOT CheckedEncryption AND NOT ENCRYPTIONENABLED THEN BEGIN
            CheckedEncryption := TRUE;
            IF CONFIRM(EncryptionIsNotActivatedQst) THEN BEGIN
                PAGE.RUN(PAGE::"Data Encryption Management");
                CheckedEncryption := FALSE;
            END;
        END;
    end;

}
