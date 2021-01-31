page 50027 "POI Account Special No."
{
    Caption = 'Account Special No.';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Account No. Special";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
                field(AccountType; AccountType)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
                field("Special No. Type"; "Special No. Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Special No. Code"; "Special No. Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
    trigger OnClosePage()
    begin
        SetAccountSpecialNos();
    end;
}