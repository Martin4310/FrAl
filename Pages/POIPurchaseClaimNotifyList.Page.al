page 5110464 "POI Purchase Claim Notify List"
{
    Caption = 'Purchase Claim Notify List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Purch. Claim Notify Header";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}