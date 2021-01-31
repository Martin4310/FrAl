page 50070 "POI Account Check Detail GL"
{
    Caption = 'QS Details';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Quality Mgt Detail";
    //InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Mandant; Mandant)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Credit Limit"; "Credit Limit")
                {
                    Caption = 'unversichertes Vorkasselimit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Credit Limit Valid To"; "Credit Limit Valid To")
                {
                    Caption = 'Befristet bis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field("Credit Limit Approved"; "Credit Limit Approved")
                {
                    Caption = 'Vorkasselimit und Befristung genehmigt';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = "Credit Limit" <> 0;
                }
                field(Refund; Refund)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Refund Approved"; "Refund Approved")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = (Refund <> 0) and StammblattExists;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if QS.Get("No.", QS."Source Type"::Vendor) and QS."Prüfung ext. Stammblatt" then
            StammblattExists := true
        else
            StammblattExists := false;
    end;

    var
        QS: Record "POI Quality Management";
        StammblattExists: Boolean;
}