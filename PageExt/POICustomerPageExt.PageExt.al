pageextension 50018 "POI CustomerPageExt" extends "Customer Card"

{
    //PromotedActionCategories = ' ';
    PromotedActionCategories = 'Port';

    layout
    {
        modify(Name)
        {
            //Visible = PermVisible;
            //Editable = PermWrite;
            Visible = True;
            ShowMandatory = true;
        }
        modify("Disable Search by Name")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify("Address & Contact")
        {
            CaptionML = DEU = 'Kontakt und Debitorentyp';
        }
        modify(AddressDetails)
        {
            Visible = false;
        }
        modify(ContactName)
        {
            Visible = false;
        }
        modify("Primary Contact No.")
        {
            Visible = false;
        }
        addafter(Name)
        {
            field("POI Name 2"; "Name 2")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Visible = true;
            }
        }
        addlast(Invoicing)
        {
            field("POI Factoring Company"; "POI Factoring Company")
            {
                Caption = 'Rg über Zentralregulierer';
                ApplicationArea = All;
                ToolTip = ' ';
                //Visible = false;
                trigger OnLookup(var Text: Text): Boolean
                begin
                    Page.RunModal(Page::"Vendor List");
                end;
            }
            field("POI Factoring Customer No."; "POI Factoring Customer")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                //Visible = NOT "POI Factoring Company";
                Visible = false;
            }
            field("POI Finance Service Debitor"; "POI Finance Service Debitor")
            {
                Caption = 'Debitornr. Zentralregulierer';
                Description = 'Finanzdienstleister wie z.B. Markant, die zusätzliche Kosten für die Fakturierung verursachen. Die Konditionen sind in den Konditionen (Zeilenrabatten) hinterlegt.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter(General)
        {
            part("POI CompanyAllocation"; "POI Acc Comp Set Cust")
            {
                Caption = 'Mandantenzuordnung';
                Editable = AccSettingEditable;
                ApplicationArea = Basic, Suite;
                SubPageLink = "Account No." = FIELD("No."), "Account Type" = Const(Customer), Visible = const(true);
                UpdatePropagation = Both;
            }
        }
        addafter(Shipping)
        {
            group("POI Credit Limit")
            {
                Caption = 'Kreditversicherung';
                field("POI No Insurance"; "POI No Insurance")
                {
                    Caption = 'Kreditversicherung Ausschluss';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        NotEditableNoInsurance := not "POI No Insurance";
                    end;
                }
                field("POI Credit Insurance No."; "POI Credit Insurance No.")
                {
                    Caption = 'Kreditornr. Erstversicherer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                    ShowMandatory = not "POI No Insurance";
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(Page::"Vendor List");
                    end;
                }
                field("POI Easy No."; "POI Easy No.")
                {
                    Caption = 'Easy Nr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                    ShowMandatory = true;
                }
                field(DRA; "POI DRA")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field("POI Credit Ins. Credit Limit"; "POI Credit Ins. Credit Limit")
                {
                    Caption = 'Kreditlimit Erstversicherer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                    ShowMandatory = "POI Extra Limit" <> 0;
                    trigger OnValidate()
                    var
                        POIFunction: Codeunit POIFunction;
                    begin
                        if not POIFunction.CheckPermission(18, 50024, 0) then
                            Error(NoPermissionTxt);
                    end;
                }
                field("POI Cred. Ins. Limit val. till"; "POI Cred. Ins. Limit val. till")
                {
                    Caption = 'Erstlimit gültig bis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                }
                field("POI Ins. No. Extra Limit"; "POI Ins. No. Extra Limit")
                {
                    caption = 'Kreditornr. Zusatzversicherer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(Page::"Vendor List");
                    end;
                }
                field("POI Extra Limit"; "POI Extra Limit")
                {
                    Caption = 'Zusatzlimit Zusatzversicherer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                }
                field("POI Extra Limit valid to"; "POI Extra Limit valid to")
                {
                    Caption = 'Zusatzlimit gültig bis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                    ShowMandatory = "POI Extra Limit" <> 0;
                }
                field("POI Termin. Date Extra limit"; "POI Termin. Date Extra limit")
                {
                    Caption = 'Kündigungstermin Zusatzlimit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                }
                field("POI Internal Credit Limit"; "POI Internal Credit Limit")
                {
                    Caption = 'Kreditlimit intern';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                }
                field("POI Int. Cred. Limit val. till"; "POI Int. Cred. Limit val. till")
                {
                    Caption = 'Kreditlimit int. gültig bis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = NotEditableNoInsurance;
                    ShowMandatory = "POI Internal Credit Limit" <> 0;
                }
                field("POI Cred.-Limit Grp."; "POI Ins. Group Creditlimit")
                {
                    Caption = 'versichertes Gruppenlimit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field("POI Group Creditlimit"; "POI Group Creditlimit")
                {
                    Caption = 'Gruppenlimit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
            }
            group("Waste Disposal")
            {
                Caption = 'Entsorgung';
                field("POI Waste Disposal System"; "POI Waste Disposal System")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Acc. No. Waste Disp. Comp."; "POI Acc. No. Waste Disp. Comp.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = "POI Waste Disposal System" <> 0;
                }
                field("POI Waste Disposal Company"; "POI Waste Disposal Company")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowMandatory = "POI Waste Disposal System" <> 0;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(Page::"Vendor List");
                    end;
                }
                field("POI Print Waste Disp. on Doc."; "POI Print Waste Disp. on Doc.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
        addlast("Address & Contact")
        {
            field("POI Goods Customer"; "POI Goods Customer")
            {
                Caption = 'Warenkunde';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Service Customer"; "POI Service Customer")
            {
                Caption = 'Dienstleistungskunde';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI divers Customer"; "POI divers Customer")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Name 2"; Address)
        moveafter(Address; "Address 2")
        moveafter("Address 2"; City)
        moveafter(City; "Post Code")
        moveafter("Post Code"; "Country/Region Code")
        moveafter("Country/Region Code"; ShowMap)
        addafter(ShowMap)
        {
            field(POIVATRegistrationNos; POIVATRegistrationNos)
            {
                Caption = 'UST-Id Nr.';
                ToolTip = ' ';
                Editable = false;
                StyleExpr = color;

                trigger OnDrillDown()
                var
                    VendorCustUstID: Record "POI VAT Registr. No. Vend/Cust";
                    VendorCustUstIDpg: Page "POI VAT Registr. No. Vend/Cust";
                    VendorCustType: enum "POI VendorCustomer";
                begin
                    VendorCustUstID.SetRange("Vendor/Customer", "No.");
                    VendorCustUstID.SetRange(Type, VendorCustUstID.Type::Customer);
                    VendorCustUstIDpg.setItemNo("No.", VendorCustType::Customer);
                    VendorCustUstIDpg.SetTableView(VendorCustUstID);
                    VendorCustUstIDpg.Run();
                end;
            }
        }
        modify("VAT Registration No.")
        {
            Visible = false;
        }
        moveafter("POI No Insurance"; "Credit Limit (LCY)")
        modify("Credit Limit (LCY)")
        {
            Editable = false;
        }
        addafter(POIVATRegistrationNos)
        {
            field("POI Registration No."; "POI Registration No.")
            {
                Caption = 'Steuernummer';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Registration No."; "Salesperson Code")
        addafter("Salesperson Code")
        {
            field("POI Person in Charge"; "POI Person in Charge")
            {
                Caption = 'Sachbearbeiter';
                ApplicationArea = All;
                ToolTip = ' ';
                ShowMandatory = true;
            }
            field("POI Amtsgericht"; "POI Amtsgericht")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Commercial Register No."; "POI Commercial Register No.")
            {
                Caption = 'Handelsregister-Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
                ShowMandatory = "POI Amtsgericht" = "POI Amtsgericht"::registered;
            }
            field("POI County Court"; "POI County Court")
            {
                Caption = 'Eintragungsort';
                ApplicationArea = All;
                ToolTip = ' ';
                ShowMandatory = "POI Amtsgericht" = "POI Amtsgericht"::registered;
            }
            field("POI Is Vendor"; "POI Is Vendor")
            {
                Caption = '= Kreditor';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            grid(GroupCustomer)
            {
                GridLayout = Columns;
                field("POI Group Customer"; "POI Group Customer")
                {
                    Caption = 'Zugehörigkeit zu Gruppendebitor';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Number of GroupCustomers"; "POI Number of GroupCustomers")
                {
                    Caption = 'Anzahl Gruppendebitoren';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
        moveafter(GroupCustomer; "Search Name")
        addafter("Search Name")
        {
            field("POI Old Customer No."; "POI Old Customer No.")
            {
                Caption = 'alte Debitornr.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Our Account No."; "POI Our Account No.")
            {
                Caption = 'unsere Lieferanten-Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(Comment; Comment)
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }

        moveafter(Comment; "Last Date Modified")

        addafter("Last Date Modified")
        {
            field("POI Special Cust. Nos."; "POI Special Cust. Nos.")
            {
                Caption = 'Debitor ID Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnDrillDown()
                var
                    AccountSpecialNos: Record "POI Account No. Special";
                    AccspecialNospage: page "POI Account Special No.";
                begin
                    AccountSpecialNos.SetRange(AccountType, AccountSpecialNos.AccountType::Customer);
                    AccountSpecialNos.SetRange("Account No.", "No.");
                    AccspecialNospage.SetTableView(AccountSpecialNos);
                    AccspecialNospage.Run();
                end;
            }
        }
        addafter("POI Registration No.") //("Salesperson Code")
        {
            grid(SalesPerson)
            {
                GridLayout = Columns;
                field(SPCode; "Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'Verkäufer';
                    ToolTip = ' ';
                    ShowMandatory = true;
                    trigger OnValidate()
                    var
                        SalesPerson: Record "Salesperson/Purchaser";
                    begin
                        if SalesPerson.Get("Salesperson Code") then
                            SalesPersonName := SalesPerson.Name;
                    end;
                }
                field("SPName"; SalesPersonName)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    ShowCaption = false;
                    Caption = 'Verkäufername';
                    Editable = false;
                }
            }
        }
        moveafter("POI Special Cust. Nos."; Blocked)
        moveafter("Language Code"; "Document Sending Profile")
        moveafter("Home Page"; "Language Code")

        modify("IC Partner Code")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Service Zone Code")
        {
            Visible = false;
        }
        modify(TotalSales2)
        {
            Visible = false;
        }
        modify("CustSalesLCY - CustProfit - AdjmtCostLCY")
        {
            Visible = false;
        }
        modify(AdjCustProfit)
        {
            Visible = false;
        }
        modify(AdjProfitPct)
        {
            Visible = false;
        }
        modify(ContactDetails)
        {
            CaptionML = DEU = ' ';
        }
        modify(GLN)
        {
            Visible = false;
        }
        modify("Invoice Copies")
        {
            Visible = false;
        }
        modify("Partner Type")
        {
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        {
            Visible = false;
        }
        modify("Print Statements")
        {
            Visible = false;
        }
        modify("Last Statement No.")
        {
            Visible = false;
        }
        modify("Shipping Time")
        {
            Visible = false;
        }
        modify("Base Calendar Code")
        {
            Visible = false;
        }
        modify("Customized Calendar")
        {
            Visible = false;
        }
        modify(Control149)
        {
            Visible = false;
        }
        modify(Control1905532107)
        {
            Visible = false;
        }
        modify("Salesperson Code")
        {
            Visible = false;
            Caption = 'Verkäufer';
            ShowMandatory = true;
            trigger OnAfterValidate()
            var
                SalesPerson: Record "Salesperson/Purchaser";
            begin
                if SalesPerson.Get("Salesperson Code") then
                    SalesPersonName := SalesPerson.Name;
            end;
        }
        modify(City)
        {
            ShowMandatory = true;
            trigger OnLookup(var Text: Text): Boolean
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
                POISynchFunction.SynchCustVendGroupCust(FieldNo(City), "No.", "POI Is Vendor", "POI Customer Group Code", City, true, false, true, true, false, true);
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Post Code"), "No.", "POI Is Vendor", "POI Customer Group Code", "Post Code", true, false, true, true, false, true);
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Country/Region Code"), "No.", "POI Is Vendor", "POI Customer Group Code", "Country/Region Code", true, false, true, true, false, true);
            end;
        }
        modify("Post Code")
        {
            ShowMandatory = true;
            trigger OnLookup(var Text: Text): Boolean
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Post Code"), "No.", "POI Is Vendor", "POI Customer Group Code", "Post Code", true, false, true, true, false, true);
                POISynchFunction.SynchCustVendGroupCust(FieldNo(City), "No.", "POI Is Vendor", "POI Customer Group Code", City, true, false, true, true, false, true);
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Country/Region Code"), "No.", "POI Is Vendor", "POI Customer Group Code", "Country/Region Code", true, false, true, true, false, true);
            end;
        }
        modify("Bill-to Customer No.")
        {
            trigger OnLookup(var Text: Text): Boolean
            begin
                Page.RunModal(Page::"Vendor List");
            end;
        }
        modify(Address)
        {
            ShowMandatory = true;
        }
        modify("Country/Region Code")
        {
            ShowMandatory = true;
        }
        modify("Phone No.")
        {
            ShowMandatory = true;
        }
        modify("E-Mail")
        {
            ShowMandatory = true;
        }
        modify("Language Code")
        {
            ShowMandatory = true;
        }
        modify("Document Sending Profile")
        {
            ShowMandatory = true;
        }
        modify("VAT Bus. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("Shipment Method Code")
        {
            ShowMandatory = true;
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action("Create Customer from Vendor")
            {
                Image = Create;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Kreditor aus Debitor anlegen';
                ToolTip = ' ';
                trigger OnAction()
                var
                    POIFunction: Codeunit POIFunction;
                    newType: Integer;
                begin
                    newType := StrMenu('Fiscalvertreter,Reederei,Lagerhalter,Kleinstkreditor,diverser Kreditor,Spediteur,Zollagent,Warenlieferant,Luftfracht', 8, 'Bitte die Kreditorenart auswählen');
                    if newType > 0 then
                        "POI Is Vendor" := POIFunction.CopyIsCustomerVendor("No.", 1, newType);
                end;

            }
            action("POI CheckVatID")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                Caption = 'CheckVatID';
                trigger OnAction()
                var
                    CheckVAT: Codeunit "POI Test USTID";

                begin
                    CheckVAT.TestID("No.");
                end;
            }
            action(Certificate)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                RunObject = page "POI Certificates Cust./Vend.";
                RunPageLink = Source = const(0), "Source No." = field("No.");
            }
            action("Credit Contract Data")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                RunObject = page "POI Creditcontract Account";
                RunPageLink = "Account No. Customer" = field("No.");
            }
            action("Show Group Credit Limit")
            {
                Caption = 'Anzeige Kreditlimit Total';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    POIFunction: Codeunit POIFunction;
                    CreditLimitTxt: label 'Kreditlimit Versicherung: %1 / Gesamt: %2', Comment = '%1 %2';
                begin
                    Message(CreditLimitTxt, POIFunction.getGroupLimit("POI Easy No.", 0), POIFunction.getGroupLimit("POI Easy No.", 1));
                end;
            }
            action(ShowGroupCustmers)
            {
                Caption = 'Übersicht Gruppenkunden';
                ApplicationArea = All;
                ToolTip = ' ';
                RunObject = page "Customer List";
                RunPageLink = "POI Group Customer" = Field("No.");
            }
            action("Check Customer")
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                Image = Check;
                Caption = 'Debitor prüfen';
                ToolTip = ' ';
                trigger OnAction()
                var
                    POIQSAccFunction: Codeunit "POI QS Account Function";
                begin
                    POIQSAccFunction.CheckQSAccountCust("No.");
                end;
            }
        }
    }


    trigger OnOpenPage()
    var
        POICompany: Record "POI Company";
        filterstring: Text[50];
    begin
        if uppercase(CompanyName()) <> uppercase(POIFunction.GetBasicCompany()) then begin
            POICompany.Get(CompanyName());
            FilterGroup(2);
            filterstring := StrSubstNo('*%1*', POICompany."Company System ID");
            SetFilter("POI Company System Filter", filterstring);
            AccSettingEditable := false;
        end else
            AccSettingEditable := true;
        PermVisible := POIFunction.CheckPermission(18, 10, 1) OR POIFunction.CheckPermission(18, 10, 2);
        PermWrite := POIFunction.CheckPermission(18, 10, 2);
    end;

    trigger OnAfterGetRecord()
    var
        SalespurchasePerson: Record "Salesperson/Purchaser";
        AccCompSetting: Record "POI Account Company Setting";
    begin
        NotEditableNoInsurance := not "POI No Insurance";
        if ("No." <> OldCode) and (OldCode <> '') then begin
            ;//Aktion die Auszuführen ist.
            OldCode := "No.";
        end;
        if SalesPurchasePerson.Get("Salesperson Code") then
            SalesPersonName := SalesPurchasePerson.Name;
        AccCompSetting.SetAccCompSetting("No.", AccCompSetting."Account Type"::Customer);
        Color := CheckVatIDValidation(rec);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        BelowxRec := false;
        //Error('Kreditoren anlegen nur über neue Geschäftspartner');
    end;

    trigger OnClosePage()
    var
        AccCompSetting: Record "POI Account Company Setting";
    begin
        AccCompSetting.SetAccCompSetting("No.", AccCompSetting."Account Type"::Customer);
    end;

    var
        PostCode: Record "Post Code";
        POISynchFunction: Codeunit "POI Account Synchronisation";
        POIFunction: Codeunit POIFunction;
        OldCode: Code[20];
        SalesPersonName: Text[100];
        Color: text[20];
        PermVisible: Boolean;
        PermWrite: Boolean;
        AccSettingEditable: Boolean;
        NotEditableNoInsurance: Boolean;
        NoPermissionTxt: Label 'Änderung nicht erlaubt';

}