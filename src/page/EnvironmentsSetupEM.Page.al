page 55500 "Environments Setup_EM"
{

    PageType = Card;
    SourceTable = "Environments Setup_EM";
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Environments Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Base API URL"; "Resource url")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                    ToolTip = 'Base API URL';
                }
                field("Tenant Domain"; "Tenant Domain")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tenant Domain';
                }
                field("APP ID"; "App Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'APP ID';
                }
                field("Client Secret"; "Client Secret")
                {
                    ApplicationArea = All;
                    ToolTip = 'Client Secret';
                }
                field("User Name"; "User Name")
                {
                    ApplicationArea = All;
                    ToolTip = '"User Name';
                }
                field("User Password"; "User Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'User Password';
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
                ApplicationArea = All;
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

    trigger OnOpenPage()
    begin
        InsertIfNotExists();
    end;

}
