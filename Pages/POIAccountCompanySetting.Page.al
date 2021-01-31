page 50005 "POI Account Company Setting"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Account Company Setting";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field(Company; "Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Released; Released)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("special approval"; "special approval")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("Block Status"; "Block Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = ' ';
                }
                // field("Creditlimit requested"; "Creditlimit requested")
                // {
                //     Caption = 'Vorauskasse Kreditlimit gewünscht';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                // }
                field("Credit Limit"; "Credit Limit")
                {
                    Caption = 'Vorauskasse Kreditlimit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = "Creditlimit requested";
                }
                field(Refund; Refund)
                {
                    Caption = 'Rechnungsrabatt';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Block)
            {
                Caption = 'Gesamtsperre';
                Image = Reject;
                ToolTip = ' ';
                Visible = BlockVisible;
                trigger OnAction()
                begin
                    if POIFunction.UserInWindowsRole('POIFIBU') then
                        SetBlock(2);
                end;
            }
            action("Block Payment")
            {
                Caption = 'Zahlungssperre';
                Image = VoidCheck;
                ToolTip = ' ';
                Visible = BlockVisible;
                trigger OnAction()
                begin
                    if POIFunction.UserInWindowsRole('POIFIBU') then
                        SetBlock(1);
                end;
            }
            action(Release)
            {
                Caption = 'Geschäftspartner freigeben';
                Image = VoidCheck;
                ToolTip = ' ';
                Visible = BlockVisible;
                trigger OnAction()
                begin
                    if POIFunction.UserInWindowsRole('POIFIBU') then
                        SetBlock(0);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        BlockVisible := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if ("Account Type" = "Account Type"::Contact) or ("Account Type" = "Account Type"::create) or ("Account Type" = "Account Type"::Salesperson) then
            BlockVisible := False
        else
            BlockVisible := true;
    end;

    procedure SetBlock(BlockType: Option " ",Payment,All)
    var
        BlockTxt: Label 'Geschäftspartner hat keine QS-Freigabe';
    begin
        CurrPage.SetSelectionFilter(AccountCompanySetting);
        AccountCompanySetting.MarkedOnly(true);
        if AccountCompanySetting.FindSet() then
            repeat
                case "Account Type" of
                    "Account Type"::Vendor:
                        if QualityManagement.Get("Account No.", QualityManagement."Source Type"::Vendor) and QualityManagement."Freigabe für Kreditor" then begin
                            Vendor.ChangeCompany(AccountCompanySetting."Company Name");
                            Vendor.Get("Account No.");
                            Vendor.Blocked := BlockType;
                            Vendor.Modify();
                        end else
                            Error(BlockTxt);
                    "Account Type"::Customer:
                        begin
                            QualityManagement.ChangeCompany(AccountCompanySetting."Company Name");
                            if QualityManagement.Get("Account No.", QualityManagement."Source Type"::Customer) and QualityManagement."Freigabe für Debitor" then begin
                                Customer.ChangeCompany(AccountCompanySetting."Company Name");
                                Customer.Get("Account No.");
                                Customer.Blocked := BlockType;
                                Customer.Modify();
                            end else
                                Error(BlockTxt);
                        end;
                end;
                AccountCompanySetting."Block Status" := BlockType;
                AccountCompanySetting.Modify();
            until AccountCompanySetting.Next() = 0;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        POIFunction.CheckUserInRole('POISUPER', 1);
    end;

    var
        AccountCompanySetting: Record "POI Account Company Setting";
        Vendor: Record Vendor;
        Customer: Record Customer;
        QualityManagement: Record "POI Quality Management";
        POIFunction: Codeunit POIFunction;
        BlockVisible: Boolean;

}