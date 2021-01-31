page 5110420 "POI Variety"
{
    Caption = 'Sorte';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Variety";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Cultivation Type"; "Cultivation Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Internal Code in Item No."; "Internal Code in Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Product Group Code"; "Product Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Search Description"; "Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}