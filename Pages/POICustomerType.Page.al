page 50014 "POI Customer Type"
{
    Caption = 'Debitorentyp';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Customer Type";

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
            }
        }
    }
}