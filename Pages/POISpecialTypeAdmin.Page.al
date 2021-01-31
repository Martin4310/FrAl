page 50030 "POI Special Type Admin"
{
    Caption = 'POI Special Type Admin';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Special Nos Type";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Special Code"; "Special Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Special Type"; "Special Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}