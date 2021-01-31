page 5110378 "POI Price Base"
{
    Caption = 'Price Base';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Price Base";

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
                field("Purch./Sales Price Calc."; "Purch./Sales Price Calc.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Price Unit Weighting"; "Price Unit Weighting")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Internal Calc. Code"; "Internal Calc. Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Internal Calc. Type"; "Internal Calc. Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Weight; Weight)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}