page 50046 "POI VAT Registr. No. Vend/Cust"
{
    Caption = 'VAT Registr. No. Vend/Cust';
    PageType = List;
    ApplicationArea = Basic, Suite;
    UsageCategory = Lists;
    SourceTable = "POI VAT Registr. No. Vend/Cust";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Vendor/Customer"; "Vendor/Customer")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Country Code"; "Country Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Name"; Name)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Name 2"; "Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(City; City)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(primary; primary)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("VAT Detection"; "VAT Detection")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Date created"; "Date created")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field("Time created"; "Time created")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field("Reg. No. valid"; "Reg. No. valid")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Name valid"; "Name valid")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("City valid"; "City valid")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Status Text"; "Status Text")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Post Code valid"; "Post Code valid")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Address valid"; "Address valid")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
        area(Factboxes)
        {

        }
    }
    actions
    {
        area(Processing)
        {
            action(CheckVat)
            {
                Caption = 'Ust-ID Prüfdaten';
                ApplicationArea = All;
                ToolTip = ' ';
                Image = Check;
                RunObject = page "VAT Registration Log";
                RunPageLink = "Account No." = field("Vendor/Customer"), "VAT Registration No." = field("VAT Registration No.");
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        GetAllVatIdsToText(ActAccountNo, AccType);
    end;


    procedure setItemNo(AccountNo: Code[20]; Type: Enum "POI VendorCustomer")
    begin
        ActAccountNo := AccountNo;
        AccType := Type;
    end;

    var
        ActAccountNo: Code[20];
        AccType: enum "POI VendorCustomer";
}