page 50057 "POI Mail Setup"
{
    Caption = 'E-Mail Einrichtung';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Mail Setup";

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
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Type Code"; "Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Source; Source)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}