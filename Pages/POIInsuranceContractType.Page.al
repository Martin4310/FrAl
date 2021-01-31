page 50025 "POI Insurance Contract Type"
{
    Caption = 'Insurance Contract Type';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Insurance Contract Type";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract Type Code"; "Contract Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Insurance No."; "Insurance No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}