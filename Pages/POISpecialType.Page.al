page 50029 "POI Special Type"
{
    Caption = 'POI Special Type';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Special Nos Type";
    Editable = false;

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
                    Visible = false;
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