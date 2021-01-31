page 50000 "POI Company"
{
    Caption = 'POI Company';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Company";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Mandant)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Synch Masterdata"; "Synch Masterdata")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Company System ID"; "Company System ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Small Vendor"; "Small Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Diverse; Diverse)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Basic Company"; "Basic Company")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Visible; Visible)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("DMS aktiv"; "DMS aktiv")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}