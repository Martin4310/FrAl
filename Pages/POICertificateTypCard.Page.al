page 50041 "POI Certificate Typ Card"
{
    Caption = 'Zertifikatstypen';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Certificate Types";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Allgemein';
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
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Activ; Activ)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Check Valid"; "Check Valid")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Validation Action"; "Validation Action")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = "Check Valid";
                }
                field("Certification of Account"; "Certification of Account")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Certification of Packing"; "Certification of Packing")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Certification of Product"; "Certification of Product")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Subject to Licence"; "Subject to Licence")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Certificate Control Board"; "Certificate Control Board")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Certificate Control Board Name"; "Certificate Control Board Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Customer Certificate"; "Customer Certificate")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Vendor Certificate"; "Vendor Certificate")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            part("POI Certificate Chapter"; "POI Certificate Chapter")
            {
                Caption = 'Zertifikatskapitel';
                SubPageLink = "Certification No." = field(Code);
            }
        }
    }
}