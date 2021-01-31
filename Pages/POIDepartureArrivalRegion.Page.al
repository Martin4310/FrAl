page 50033 "POI Departure/Arrival Region"
{
    Caption = 'Departure/Arrival Region';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Departure Region";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(RegionType; RegionType)
                {
                    Caption = 'regionstyp';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Code; Code)
                {
                    Caption = 'Regionscode';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}