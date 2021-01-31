page 50018 "POI Certificate Typs"
{
    Caption = 'Zertifikatstypen und Definitionen';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "POI Certificate Types";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Comment; Comment)
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