page 50048 "POI Item Codes"
{
    Caption = 'PageName';
    PageType = Listpart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Item Codes";

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
                field(Value; Value)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}