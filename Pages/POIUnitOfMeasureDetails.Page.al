page 50051 "POI Unit of Measure Details"
{
    Caption = 'Unit of Measure Details';
    PageType = Listpart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Unit of Measure Details";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
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
                field("Stacking height in mm"; "Stacking height in mm")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Stacking height layers"; "Stacking height layers")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}