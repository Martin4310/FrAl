page 5110460 "POI Purchase Claim Notify Card"
{
    Caption = 'Purchase Claim Notify';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Purch. Claim Notify Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Purch. Order No."; "Purch. Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Purch. Order Date"; "Purch. Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Master Batch No."; "Master Batch No.")
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
                field("Buy-from Country Code"; "Buy-from Country Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Buy-from Post Code"; "Buy-from Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Buy-from City"; "Buy-from City")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Your Reference"; "Your Reference")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}