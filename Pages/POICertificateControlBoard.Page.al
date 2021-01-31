page 50017 "POI Certificate Control Board"
{
    Caption = 'Certificate Control Board';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Certificate Control Board";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Kontrollstellennr."; "Kontrollstellennr.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Name 2"; "Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}