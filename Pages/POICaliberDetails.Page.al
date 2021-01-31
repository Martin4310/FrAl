page 5110434 "POI Caliber Details"
{
    Caption = 'Caliber Details';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Caliber Detail";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Caliber Code"; "Caliber Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Caliber Code Detail"; "Caliber Code Detail")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}