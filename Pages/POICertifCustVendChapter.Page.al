page 50043 "POI Certif. Cust/Vend Chapter"
{
    Caption = 'Zertifikatszeilen';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI certif. Cust/Vend Chapter";

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
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Dokument Link"; "Dokument Link")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Link Document")
            {
                Caption = 'Dokument importieren';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    Message('Dokument hochladen - später');
                end;
            }
        }
    }
}