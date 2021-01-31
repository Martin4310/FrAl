page 50075 "POI Account Check Det Cust"
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
                    Caption = 'Kreditlimit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Credit Limit Valid To"; "Credit Limit Valid To")
                {
                    Caption = 'Befristet bis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                // field("Credit Limit Approved"; "Credit Limit Approved")
                // {
                //     Caption = 'Vorkasselimit und Befristung genehmigt';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                // }
                field(Refund; Refund)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                // field("Refund Approved"; "Refund Approved")
                // {
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Editable = StammblattExists;
                // }
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
                field("Person in Charge"; "Person in Charge")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Sales Person"; "Sales Person")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Payment Terms"; "Payment Terms")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
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