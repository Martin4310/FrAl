page 50060 "POI ContactCreate"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = Contact;
    SourceTableTemporary = true;
    Caption = 'Create Customer or Vendor';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Nummer; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }

                field(VendororCustomer; "POI VendororCustomer")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Name 2"; "Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Address; Address)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Address 2"; "Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Company Name"; "Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Post Code"; "Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(City; City)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Department; "POI Department")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Fax No."; "Fax No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Language Code"; "Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = true;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = true;
                }
                field("Salutation Code"; "Salutation Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(Company)
            {
                field("Company System Filter"; "POI Company System Filter")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group("Typ of Vendor")
            {
                Visible = "POI VendororCustomer" = "POI VendororCustomer"::Vendor;
                field("Small Vendor"; "POI Small Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Supplier of Goods"; "POI Supplier of Goods")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Warehouse Keeper"; "POI Warehouse Keeper")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Tax Representative"; "POI Tax Representative")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Shipping Company"; "POI Shipping Company")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Diverse Vendor"; "POI Diverse Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Customs Agent"; "POI Customs Agent")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Carrier; "POI Carrier")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            part(CompanyAllocation; "POI Account Company Setting")
            {
                Caption = 'Company Allocation';
                ApplicationArea = Basic, Suite;
                SubPageLink = "Account No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create Account")
            {
                Caption = 'Create Account';
                ApplicationArea = All;
                ToolTip = ' ';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    Customer: Record Customer;
                    Vendor: Record Vendor;
                    ContactMasterData: Record Contact;
                    NoSerMgmt: Codeunit NoSeriesManagement;
                    POIFunction: Codeunit POIFunction;
                    CompanynamePOI: Text[50];
                    ContactError: Text[500];
                    ContactErrLabelTxt: Label ' sind Pflichtfelder';
                    ErrorLabel: Text;
                    POIVendorOrCustomer: enum "POI VendorCustomer";

                begin
                    ContactError := POIFunction.CheckMandantoryFields(Rec);
                    if ContactError <> '' then begin
                        ErrorLabel := ContactError + ContactErrLabelTxt;
                        Error(ErrorLabel);
                    end;
                    CompanynamePOI := POIFunction.GetBasicCompany();
                    //Mandant wechseln für Nummernserie
                    NoSeriesLine.ChangeCompany(CompanynamePOI);
                    //Create Contact in Masterdata Company
                    MarketingSetup.Get();
                    NoSeriesLine.SetRange("Series Code", MarketingSetup."Contact Nos.");
                    if NoSeriesLine.FindFirst() then
                        IF NoSeriesLine."Last No. Used" = '' then
                            NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No."
                        else
                            IF NoSeriesLine."Increment-by No." <= 1 THEN
                                NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
                            ELSE
                                NoSerMgmt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
                    NoSeriesLine.Modify();
                    ContactMasterData.ChangeCompany(CompanynamePOI);
                    ContactMasterData.TransferFields(Rec);
                    ContactMasterData."No." := NoSeriesLine."Last No. Used";
                    CopyAccountSettings("No.", ContactMasterData."No.", POIVendorOrCustomer::Contact, POIVendorOrCustomer::Contact);
                    ContactMasterData.Type := ContactMasterData.Type::Company;
                    ContactMasterData."POI Company System Filter" := CreateCompanySystemID("No.", 0);
                    ContactMasterData.Insert();
                    //Ende create Contact
                    case "POI VendororCustomer" of
                        "POI VendororCustomer"::Customer:
                            begin
                                SalesSetup.ChangeCompany(CompanynamePOI);
                                SalesSetup.Get();
                                Customer.ChangeCompany(CompanynamePOI);
                                NoSeriesLine.SetRange("Series Code", SalesSetup."Customer Nos.");
                                if NoSeriesLine.FindFirst() then begin
                                    IF NoSeriesLine."Last No. Used" = '' then
                                        NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No."
                                    else
                                        IF NoSeriesLine."Increment-by No." <= 1 THEN
                                            NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
                                        ELSE
                                            NoSerMgmt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
                                    Customer."No." := NoSeriesLine."Last No. Used";
                                    CopyAccountSettings("No.", Customer."No.", POIVendorOrCustomer::Contact, POIVendorOrCustomer::Customer);
                                    NoSeriesLine.Modify();
                                    Customer.Name := Name;
                                    Customer."Name 2" := "Name 2";
                                    Customer."E-Mail" := "E-Mail";
                                    Customer."POI Company System Filter" := CreateCompanySystemID(Customer."No.", 1);
                                    Customer.Insert();
                                    CreateContactBusinessRelation(ContactMasterData."No.", Customer."No.", 0);
                                end;
                            end;
                        "POI VendororCustomer"::Vendor:
                            begin
                                PurchaseSetup.ChangeCompany(CompanynamePOI);
                                PurchaseSetup.Get();
                                Vendor.ChangeCompany(CompanynamePOI);
                                NoSeriesLine.SetRange("Series Code", PurchaseSetup."Vendor Nos.");
                                if NoSeriesLine.FindFirst() then begin
                                    IF NoSeriesLine."Last No. Used" = '' then
                                        NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No."
                                    else
                                        IF NoSeriesLine."Increment-by No." <= 1 THEN
                                            NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
                                        ELSE
                                            NoSerMgmt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
                                    Vendor."No." := NoSeriesLine."Last No. Used";
                                    CopyAccountSettings("No.", Vendor."No.", POIVendorOrCustomer::Contact, POIVendorOrCustomer::Vendor);
                                    Vendor.Name := Name;
                                    Vendor."Name 2" := "Name 2";
                                    Vendor."E-Mail" := "E-Mail";
                                    Vendor."POI Company System Filter" := CreateCompanySystemID(Vendor."No.", 2);
                                    Vendor.Insert();
                                    CreateContactBusinessRelation(ContactMasterData."No.", Vendor."No.", 1);
                                end;
                            end;
                    end;
                    //Event
                    OnAfterCreateContact(Rec);
                    //Event
                    CurrPage.Close();
                end;
            }
            action("Set Company")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    SetActualCompany();
                end;
            }
            action(ShowMyReport)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    myReport.Run();
                end;
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."No." := 'NEW'; //Pseudonummer für temporären Kontakt
    end;

    procedure CreateContactBusinessRelation(ContactNo: Code[20]; AccountNo: Code[20]; AccountType: option Customer,Vendor)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        BusinessRelationCode: Code[10];
    begin
        case AccountType of
            accountType::Customer:
                BusinessRelationCode := 'DEB';
            AccountType::Vendor:
                BusinessRelationCode := 'KRED';
        end;
        if NOT ContactBusinessRelation.Get(ContactNo, BusinessRelationCode) then begin
            ContactBusinessRelation."Contact No." := ContactNo;
            ContactBusinessRelation."Business Relation Code" := BusinessRelationCode;
            ContactBusinessRelation."No." := AccountNo;
            case AccountType of
                accounttype::Customer:
                    ContactBusinessRelation."Link to Table" := ContactBusinessRelation."Link to Table"::Customer;
                accounttype::Vendor:
                    ContactBusinessRelation."Link to Table" := ContactBusinessRelation."Link to Table"::Vendor;
            end;
            ContactBusinessRelation.Insert();
        end;
    end;

    [IntegrationEvent(true, false)]
    procedure OnAfterCreateContact(lContact: Record Contact)
    begin
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        PurchaseSetup: Record "Purchases & Payables Setup";
        MarketingSetup: Record "Marketing Setup";
        NoSeriesLine: Record "No. Series Line";
        myReport: Report "POI Customer List FR";
}
