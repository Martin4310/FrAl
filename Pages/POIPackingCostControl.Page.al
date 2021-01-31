page 50035 "POI Packing Cost Control"
{
    Caption = 'Packing Cost Control';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Packing Cost Controle";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Calc. Pack. Cost Amount"; "Calc. Pack. Cost Amount")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Date Invoice Recieved"; "Date Invoice Recieved")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Invoice Recieved"; "Invoice Recieved")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Item Description 2"; "Item Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Pack. Cost Amount"; "Pack. Cost Amount")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Pack. Invoice Date"; "Pack. Invoice Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Pack. Invoice No."; "Pack. Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Pack. Order No."; "Pack. Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Pack.-by Name"; "Pack.-by Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Pack.-by Vendor No."; "Pack.-by Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Packing Date"; "Packing Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}