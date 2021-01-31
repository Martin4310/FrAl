page 50056 "POI Wizzard Status"
{
    Caption = 'Wizzard Status';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Wizzard Status";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Step; Step)
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