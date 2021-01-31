page 5110423 "POI Grade of Goods"
{
    Caption = 'Klasse';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Grade of Goods";

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

            }
        }
    }
}