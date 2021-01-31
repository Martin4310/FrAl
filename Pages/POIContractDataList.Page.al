page 50028 "POI Contract Data List"
{
    Caption = 'Vertragsdaten';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Contract Data";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Contract No."; "Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Contract Line"; "Contract Line")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("valid from"; "valid from")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("valid to"; "valid to")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Period; Period)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}