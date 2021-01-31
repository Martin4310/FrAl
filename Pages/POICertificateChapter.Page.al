page 50042 "POI Certificate Chapter"
{
    Caption = 'Certificate Chapter';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Certification Chapter";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Certificate Chapter No."; "Certificate Chapter No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Chapter Description"; "Chapter Description")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Activ; Activ)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}