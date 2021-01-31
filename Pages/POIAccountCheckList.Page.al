page 50067 "POI Account Check List"
{
    Caption = 'Geschäftspartner prüfen Liste';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Quality Management";
    DataCaptionFields = "Source Type", "No.";
    CardPageId = "POI Account Check";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Purchaser; Purchaser)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}