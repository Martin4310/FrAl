page 50026 "POI Creditcontract Account"
{
    Caption = 'Creditcontract Account';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Ins. Cred. lim. Buffer";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Rating; Rating)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Date of Request"; "Date of Request")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("NZM Reference"; "NZM Reference")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Request Amount"; "Request Amount")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Request Currency"; "Request Currency")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Decision Date"; "Decision Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Decision Type"; "Decision Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Key Field1"; "Key Field1")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Key Field2"; "Key Field2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Key Field3"; "Key Field3")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Comment Credit Auditor"; "Comment Credit Auditor")
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
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Currency Decision Amount"; "Currency Decision Amount")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Easy No."; "Easy No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("International Account Name"; "International Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Address; Address)
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
                field(Country; Country)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Coface No."; "Coface No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ID Name 1"; "ID Name 1")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ID No 1"; "ID No 1")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ID Name 2"; "ID Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ID No. 2"; "ID No. 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ID Name 3"; "ID Name 3")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ID No. 3"; "ID No. 3")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Contract No."; "Contract No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Contract Type"; "Contract Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Company Name"; "Company Name")
                {
                    Caption = 'Mandant';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Credit Goal"; "Credit Goal")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("insured share"; "insured share")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(DRA; DRA)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Account Reference"; "Account Reference")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Outstanding balance"; "Outstanding balance")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(IntCreditlimit; IntCreditlimit)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }



                field("Credit Insurance No."; "Credit Insurance No.")
                {
                    Caption = 'Versicherungsnr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }



                field("Error Text"; "Error Text")
                {
                    Caption = 'Fehler';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Handelsregisternr."; "Handelsregisternr.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Insurance Company Code"; "Insurance Company Code")
                {
                    Caption = 'Kundennr. beim Versicherer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }


                field(Product; Product)
                {
                    Caption = 'Vetragsprodukt';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }



            }
        }
    }
}