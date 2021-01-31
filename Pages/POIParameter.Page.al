page 50058 "POI Parameter"
{
    Caption = 'Parameter';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Parameter";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Department; Department)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Typecode1; Typecode1)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Typecode2; Typecode2)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Typecode3; Typecode3)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(ValueCode; ValueCode)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(ValueText; ValueText)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(ValueInteger; ValueInteger)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Base Item No."; "Base Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}