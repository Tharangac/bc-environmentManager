page 55502 "Env. Creation Wizard_EM"
{
    Caption = 'Create New Business Central Cloud Environment';
    PageType = NavigatePage;
    SourceTable = "Environment_EM";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(StandardBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and not FinishActionEnabled;
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'MediaResourcesStandard';
                }
            }
            group(FinishedBanner)
            {
                Caption = '';
                Editable = false;
                Visible = TopBannerVisible and FinishActionEnabled;
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'MediaResourcesDone';
                }
            }

            group(Step1)
            {
                Visible = Step1Visible;
                group("Welcome to PageName")
                {
                    Caption = 'Welcome to assisted setup for creating a environment';
                    Visible = Step1Visible;
                    group(Group18)
                    {
                        Caption = '';
                        InstructionalText = 'This guide will help you create a new environment.';
                    }
                }
                group("Let's go!")
                {
                    Caption = 'Let''s go!';
                }
            }

            group(Step2)
            {
                Visible = Step2Visible;
                group("Specify some basic information")
                {
                    Caption = 'Specify some basic information';
                    Visible = Step2Visible;
                    group(Control20)
                    {
                        InstructionalText = 'Enter a name for the environment.';
                        ShowCaption = false;
                        field(EnvironmentName; NewEnvironmentName)
                        {
                            ApplicationArea = Basic, Suite;
                            ShowCaption = false;
                            ShowMandatory = true;
                            ToolTip = 'Environment Name';
                            Caption = 'Environment Name';

                            trigger OnValidate()
                            var
                                Environment: Record "Environment_EM";
                            begin
                                NewEnvironmentName := DelChr(NewEnvironmentName, '<>');
                                Environment.SetFilter(Name, '%1', '@' + NewEnvironmentName);
                                if not Environment.IsEmpty() then
                                    Error(EnvironmentAlreadyExistsErr);
                            end;
                        }
                    }
                    group("Select configuration of the new environment.")
                    {
                        Caption = 'Select configuration of the new environment.';
                        group(Control26)
                        {
                            ShowCaption = false;
                            field(EnvironmentType; NewEnvironmentType)
                            {
                                Caption = 'Type';
                                ApplicationArea = Basic, Suite;
                                OptionCaption = 'Production,Sandbox';
                                ToolTip = 'Environment Type';
                                trigger OnValidate()
                                begin
                                    SetDefaultNewEnvironmentName();
                                end;
                            }
                            field(Localization; NewEnvironmentLocalization)
                            {
                                Caption = 'Country';
                                ApplicationArea = Basic, Suite;
                                ToolTip = 'Country';
                            }
                            field(Version; NewEnvironmentVersion)
                            {
                                Caption = 'Version';
                                ApplicationArea = Basic, Suite;
                                Visible = false;
                                ToolTip = 'Version';
                            }

                        }
                    }
                }
            }
            group(Step3)
            {
                Visible = Step3Visible;
                group(Control19)
                {
                    InstructionalText = 'Choose Finish to create the environment. This can take a few minutes to complete.';
                    ShowCaption = false;
                }
                group(Control22)
                {
                    InstructionalText = 'The environment is created and included in the environments list, but before you use it we need time to set up it for you.';
                    ShowCaption = false;
                    Visible = false;
                }
            }

        }
    }
    actions
    {
        area(processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                ToolTip = 'Back';
                trigger OnAction();
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                ToolTip = 'Next';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;
                trigger OnAction();
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                ToolTip = 'Finish';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;
                trigger OnAction();
                begin
                    FinishAction();
                end;
            }
        }
    }
    trigger OnInit();
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage();
    begin
        NewEnvironmentType := NewEnvironmentType::Sandbox;
        NewEnvironmentLocalization := NewEnvironmentLocalization::US;

        Step := Step::Start;
        EnableControls();
    end;

    var
        MediaRepositoryDone: Record "Media Repository";
        MediaRepositoryStandard: Record "Media Repository";
        MediaResourcesDone: Record "Media Resources";
        MediaResourcesStandard: Record "Media Resources";
        Step: Option Start,Step2,Finish;
        BackActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
        Step3Visible: Boolean;
        TopBannerVisible: Boolean;
        NewEnvironmentType: Option Production,Sandbox;
        NewEnvironmentLocalization: Enum "Localization_EM";
        NewEnvironmentVersion: Code[20];
        NewEnvironmentName: text[30];
        EnvironmentAlreadyExistsErr: Label 'An environment with that name already exists. Try a different name.';


    local procedure EnableControls();
    begin
        ResetControls();

        case Step of
            Step::Start:
                ShowStep1();
            Step::Step2:
                ShowStep2();
            Step::Finish:
                ShowStep3();
        end;
    end;

    local procedure FinishAction();
    begin
        CreateNewEnvironment();
        CurrPage.Close();
    end;

    local procedure NextStep(Backwards: Boolean);
    begin
        if Backwards then
            Step := Step - 1
        ELSE
            Step := Step + 1;

        EnableControls();
    end;

    local procedure ShowStep1();
    begin
        Step1Visible := true;

        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure ShowStep2();
    begin
        Step2Visible := true;
    end;

    local procedure ShowStep3();
    begin
        Step3Visible := true;

        NextActionEnabled := false;
        FinishActionEnabled := true;
    end;

    local procedure ResetControls();
    begin
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        Step1Visible := false;
        Step2Visible := false;
        Step3Visible := false;
    end;

    local procedure LoadTopBanners();
    begin
        if MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png', FORMAT(CurrentClientType())) AND
           MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png', FORMAT(CurrentClientType()))
        then
            if MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
               MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
            then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;

    local procedure SetDefaultNewEnvironmentName()
    begin
        NewEnvironmentName := format(NewEnvironmentType);
    end;

    local procedure CreateNewEnvironment()
    var
        Environment: Record "Environment_EM";
    begin
        Environment.NewBCCloudEnvironment(NewEnvironmentName, format(NewEnvironmentLocalization), NewEnvironmentVersion, format(NewEnvironmentType));
    end;
}