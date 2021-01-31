page 5087910 "POI WD Journal Template"
{
    Caption = 'WD Journal Template';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI W.D. Journ. Template";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Disposal of Waste Company"; "Disposal of Waste Company")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Formular ID"; "Formular ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Name Test Report"; "Name Test Report")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Page Name"; "Page Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Test Report ID"; "Test Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}