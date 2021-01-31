page 50023 "POI Documenttype Attachments"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "POI Documenttype Attachments";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document type Code"; "Document type Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Description"; "Description")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}