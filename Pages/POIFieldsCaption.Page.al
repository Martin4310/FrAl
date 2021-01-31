page 50032 "POI FieldsCaption"
{
    Caption = 'Fields';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = field;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Field Caption"; "Field Caption")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(FieldName; FieldName)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(TableName; TableName)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(TableNo; TableNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}