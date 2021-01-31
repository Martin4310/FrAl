page 50038 "POI Account Setup Admin"
{
    Caption = 'PageName';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Account Company Setting";

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
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Block Status"; "Block Status")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Company Name"; "Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Released; Released)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Visible; Visible)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("special approval"; "special approval")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}