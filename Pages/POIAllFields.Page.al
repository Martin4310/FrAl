page 50006 "POI AllFields"
{
    Caption = 'All Fields';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Field;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(TableNo; TableNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Field No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Field Name"; FieldName)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }

    }
}