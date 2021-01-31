page 5110416 "POI Purch. Doc. Type List"
{
    Caption = 'Purchase Doc Type';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Purch. Doc. Subtype";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
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