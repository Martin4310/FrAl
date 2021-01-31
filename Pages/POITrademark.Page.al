page 5110422 "POI Trademark"
{
    Caption = 'Sorten';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Trademark";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Search Description"; "Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field("Belongs to Customer No."; "Belongs to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Belongs to Producer No."; "Belongs to Producer No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Belongs to Vendor No."; "Belongs to Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field("Filter Vendor No."; "Filter Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Trademark Charge Perc."; "Trademark Charge Perc.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Trademark from Vendor"; "Trademark from Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Waste Company"; "Waste Company")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Waste Disposal Duty"; "Waste Disposal Duty")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("BNN Trademark"; "BNN Trademark")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}