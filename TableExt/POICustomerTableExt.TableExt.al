tableextension 50018 "POI CustomerTableExt" extends Customer
{
    fields
    {
        field(50000; "POI Group Customer"; Code[20])
        {
            Caption = 'Gruppendebitor';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(50001; "POI Factoring Customer"; Code[20])
        {
            Caption = 'Factoring Company';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(50002; "POI Is Vendor"; Code[20])
        {
            Caption = '= Kreditor';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Is Vendor"), "No.", "POI Is Vendor", "POI Group Customer", "POI Is Vendor", true, false, false, false, true, true);
            end;
        }
        field(50003; "POI Factoring Company"; Boolean)
        {
            Caption = 'Factoring Company';
            DataClassification = CustomerContent;
        }
        field(50004; "POI Company System Filter"; Code[50])
        {
            Caption = 'Company System Filter';
            DataClassification = CustomerContent;
        }
        field(50005; "POI Finance Service Debitor"; Code[20])
        {
            Caption = 'Finance Service Debitor';
            DataClassification = CustomerContent;
            TableRelation = Customer."No." where("POI Factoring Company" = const(true));
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Finance Service Debitor"), "No.", "POI Is Vendor", "POI Group Customer", "POI Finance Service Debitor", true, true, false, false, true, true);
            end;
        }
        field(50006; "POI Registration No."; Text[20])
        {
            Caption = 'Registration No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Registration No."), "No.", "POI Is Vendor", "POI Group Customer", "POI Registration No.", true, false, false, false, true, true);
                POISynchFunction.SynchfieldVendorCustomer(11000, "POI Is Vendor", 1, "POI Registration No.", true, false, true, true);
            end;
        }
        field(50007; "POI No. 2"; code[20])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }

        field(50009; "POI Person in Charge"; Code[10])
        {
            Caption = 'Person in Charge';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser".Code where("POI Is Person in Charge" = const(true));
        }
        field(50010; "POI Print Waste Disp. on Doc."; Boolean)
        {
            Caption = 'Drucke Entsorgung auf Beleg';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Print Waste Disp. on Doc."), "POI Group Customer", 0, "POI Print Waste Disp. on Doc.", true, false, true, false);
            end;
        }
        field(50011; "POI Waste Disposal System"; Option)
        {
            Caption = 'Entsorgungssystem';
            DataClassification = CustomerContent;
            OptionMembers = " ",DSD,ARA;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Waste Disposal System"), "POI Group Customer", 0, "POI Waste Disposal System", true, false, true, false);
            end;
        }
        field(50012; "POI Acc. No. Waste Disp. Comp."; Code[20])
        {
            Caption = 'Nr. beim Entsorgungssystem';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Acc. No. Waste Disp. Comp."), "POI Group Customer", 0, "POI Acc. No. Waste Disp. Comp.", true, false, true, false);
            end;
        }
        field(50013; "POI Customer type"; Code[10])
        {
            Caption = 'Customer Type';
            DataClassification = CustomerContent;
            TableRelation = "POI Customer Type".Code;
        }
        field(50014; "POI Waste Disposal Company"; Code[20])
        {
            Caption = 'Entsorgungsunternehmen';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(50114; "POI County Court"; Text[50])
        {
            Caption = 'County Court';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(18, 50001, 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI County Court"), "No.", "POI Is Vendor", "POI Group Customer", "POI County Court", true, false, true, false, true, true);
            end;
        }
        field(50015; "POI Commercial Register No."; Code[30])
        {
            Caption = 'Commercial Register No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(18, 50000, 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Commercial Register No."), "No.", "POI Is Vendor", "POI Group Customer", "POI Commercial Register No.", true, false, true, false, true, true);
            end;
        }
        field(50016; "POI Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
            DataClassification = CustomerContent;
        }
        field(50017; "POI Termin. Date Extra limit"; Date)
        {
            Caption = 'Künmdigungstermin';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Termin. Date Extra limit"), "POI Is Vendor", 1, "POI Termin. Date Extra limit", true, false, true, false);
            end;
        }
        field(50018; "POI Leergutberechnung an Deb"; Code[20])
        {
            TableRelation = Customer;
        }
        field(50019; "POI Number of GroupCustomers"; Integer)
        {
            Caption = 'Number of Group Customers';
            FieldClass = FlowField;
            CalcFormula = count (Customer where("POI Group Customer" = field("No.")));
        }
        field(50020; "POI Credit Product"; Option)
        {
            OptionMembers = "","Credit Limit",TopLiner,"Express-Pauschaldeckung","Rating Limit";
            OptionCaption = ',Credit Limit,TopLiner,Express-Pauschaldeckung,Rating Limit';
            Caption = 'Kreditprodukt';
            DataClassification = CustomerContent;
        }
        field(50021; POIVATRegistrationNos; Text[100])
        {
            Caption = 'Ust-Ids';
            DataClassification = CustomerContent;
        }

        field(50112; "POI Group Creditlimit"; Decimal)
        {
            Caption = 'Gruppenlimit Gesamt';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Group Creditlimit"), "No.", "POI Is Vendor", "POI Group Customer", "POI Group Creditlimit", true, false, true, false, true, true);
            end;
        }
        field(50124; "POI Credit Ins. Credit Limit"; Decimal)
        {
            Caption = 'Kreditlit Versicherung';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Credit Ins. Credit Limit"), "POI Is Vendor", 1, "POI Credit Ins. Credit Limit", true, false, true, true);
                if "POI Credit Ins. Credit Limit" <> 0 then
                    DeleteCreditlimitForAccSetting();
            end;
        }
        field(50139; "POI Ins. No. Extra Limit"; Code[20])
        {
            Caption = 'Kreditornr. Zusatzversicherung';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Ins. No. Extra Limit"), "No.", "POI Is Vendor", "POI Group Customer", "POI Ins. No. Extra Limit", true, false, true, false, true, true);
            end;
        }
        field(50026; "POI Credit Ins. Account No."; Code[20])
        {
            Caption = 'Kdnr. beim Kreditversicherer';
            DataClassification = CustomerContent;
        }
        field(50027; "POI Credit Ins. Last Request"; Date)
        {
            Caption = 'Letzte Anforderung beim Kreditversicherer';
            DataClassification = CustomerContent;
        }
        field(50028; "POI Special Cust. Nos."; Text[100])
        {
            caption = 'Special Cust. Nos.';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                POISynchFunction.SynchAccountAndContact(18, FieldNo("POI Special Cust. Nos."), "No.", "POI Special Cust. Nos.", false, true);
            end;
        }

        field(50314; "POI Int. Cred. Limit val. till"; Date)
        {
            Caption = 'Kreditlimit int. gültig bis';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Int. Cred. Limit val. till"), "POI Is Vendor", 1, "POI Int. Cred. Limit val. till", true, false, true, false);
            end;
        }
        field(50078; "POI Goods Customer"; Boolean)
        {
            Caption = 'Goods Customer';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "POI Goods Customer" THEN
                    "POI divers Customer" := FALSE;
                SetContactData();
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Goods Customer"), "No.", "POI Is Vendor", "POI Group Customer", "POI Goods Customer", true, true, false, false, true, true);
            end;
        }
        field(50079; "POI Service Customer"; Boolean)
        {
            Caption = 'Service Customer';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "POI divers Customer" THEN
                    "POI Goods Customer" := FALSE;
                SetContactData();
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Service Customer"), "No.", "POI Is Vendor", "POI Group Customer", "POI Service Customer", true, true, false, false, true, true);
            end;
        }
        field(50080; "POI divers Customer"; Boolean)
        {
            Caption = 'divers Customer';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "POI divers Customer" THEN
                    "POI Goods Customer" := FALSE;
                SetContactData();
            end;
        }
        field(50214; "POI Ins. Group Creditlimit"; Decimal)
        {
            Caption = 'Gruppenlimit versichert';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Ins. Group Creditlimit"), "No.", "POI Is Vendor", "POI Group Customer", "POI Ins. Group Creditlimit", true, false, true, false, true, true);
            end;
        }
        field(50039; "POI Credit Ins. Comp. Note"; Code[10])
        {
            Caption = 'Bemerkung Kreditversicherer';
            DataClassification = CustomerContent;
        }
        field(50029; "POI Credit Ins. Status"; Code[50])
        {
            Caption = 'Status Kreditversicherung';
            DataClassification = CustomerContent;
            // OptionMembers = ,,,"Intern abgelehnt",,,Unbenannt,,,Benannt,,,Teilversichert,,,Abgelehnt,Gültig,Abgelaufen,Gestrichen;
            // OptionCaption = ',,,Intern abgelehnt,,,Unbenannt,,,Benannt,,,Teilversichert,,,Abgelehnt,Gültig,Abgelaufen,Gestrichen';
        }
        field(50030; "POI Action Cred. Limit Overdue"; Option)
        {
            Caption = 'Aktion bei Limitüberschreitung';
            DataClassification = CustomerContent;
            OptionMembers = Warning,,,Block,"First Warning Limit + Block Credit Limit",,"Cheque & Cash",Cash;
            OptionCaption = 'Warning,,,Block,First Warning Limit + Block Credit Limit,,Cheque & Cash,Cash';
        }
        field(50031; "POI Cred. Ins. Limit val. from"; Date)
        {
            Caption = 'Kreditlimit gültig ab';
            DataClassification = CustomerContent;
        }
        field(50313; "POI Cred. Ins. Limit val. till"; Date)
        {
            Caption = 'Kreditlimit gültig bis';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Cred. Ins. Limit val. till"), "POI Is Vendor", 1, "POI Cred. Ins. Limit val. till", true, false, true, false);
            end;
        }
        field(50360; "POI Licence Code"; Code[20])
        {
            Caption = 'Lizenz Code';
            DataClassification = CustomerContent;
        }
        field(50256; "POI Credit Insurance No."; Code[20])
        {
            Caption = 'Kreditornr. Versicherung';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No." where("POI Tax Representative" = const(true));
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Credit Insurance No."), "No.", "POI Is Vendor", "POI Group Customer", "POI Credit Insurance No.", true, false, true, false, true, true);
            end;
        }
        field(50257; "POI DRA"; Text[50])
        {
            Caption = 'Debtor Risk Assessment';
            Description = 'Debtor Risk Assessment';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI DRA"), "No.", "POI Is Vendor", "POI Group Customer", "POI DRA", true, false, true, false, true, true);
            end;
        }
        field(50034; "POI Rating"; Code[10])
        {
            Caption = 'Rating';
            DataClassification = CustomerContent;
        }
        field(50259; "POI Extra Limit"; Decimal)
        {
            Caption = 'Extra Limit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Extra Limit"), "POI Is Vendor", 1, "POI Extra Limit", true, false, true, false);
            end;
        }
        field(50260; "POI Extra Limit valid to"; Date)
        {
            Caption = 'Extra Limit gültig bis';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Extra Limit valid to"), "POI Is Vendor", 1, "POI Extra Limit valid to", true, false, true, false);
            end;
        }
        field(50037; "POI No Insurance"; Boolean)
        {
            Caption = 'Kreditversicherung Ausschluss';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI No Insurance"), "No.", "POI Is Vendor", "POI Group Customer", "POI No Insurance", true, false, true, false, true, true);
            end;
        }
        field(50038; "POI Easy No."; Code[50])
        {
            Caption = 'Easy No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Easy No."), "No.", "POI Is Vendor", "POI Group Customer", "POI Easy No.", true, false, true, false, true, true);
            end;
        }
        field(50041; "POI Sales Agent"; Code[20])
        {
            Caption = 'Handelsvertreter';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser".Code where("POI Is Sales Agent Person" = const(true));
        }
        field(50042; "POI Customer Main Group Code"; Code[10])
        {
            Caption = 'Customer Main Group';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                SetDefDimension('DEBITORENHAUPTGRUPPE');
            end;
        }
        field(50043; "POI Customer Group Code"; Code[10])
        {
            Caption = 'Customer Group';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                SetDefDimension('DEBITORENGRUPPE');
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Customer Group Code"), "No.", "POI Is Vendor", "POI Group Customer", "POI Customer Group Code", true, false, true, false, true, true);
            end;
        }
        field(50104; "POI Internal Credit Limit"; Decimal)
        {
            Caption = 'Internes Kreditlimit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Internal Credit Limit"), "POI Is Vendor", 1, "POI Internal Credit Limit", true, false, true, false);
                if "POI Internal Credit Limit" <> 0 then
                    DeleteCreditlimitForAccSetting();
            end;
        }
        field(50200; "POI Old Customer No."; Code[20])
        {
            Caption = 'Alte Debitor Nr.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(18, 50200, 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Old Customer No."), "No.", "POI Is Vendor", "POI Group Customer", "POI Old Customer No.", true, false, true, false, true, true);
            end;
        }
        field(50210; "POI Amtsgericht"; Option)
        {
            Caption = 'Amtsgericht Eintrag';
            DataClassification = CustomerContent;
            OptionMembers = registered,"not registered";
            //OptionCaption = 'registered,not registered';
            OptionCaption = 'registriert,nicht registriert';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(18, 50210, 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchCustVendGroupCust(FieldNo("POI Amtsgericht"), "No.", "POI Is Vendor", "POI Group Customer", "POI Amtsgericht", true, false, true, false, true, true);
            end;
        }
        field(50500; "POI Customer Risk Assessment"; Code[10])
        {
            Caption = 'Customer Risk Assessment';
            DataClassification = CustomerContent;
        }
        field(5110330; "POI Appendix Shipment Method"; Text[30])
        {
            Caption = 'Additional Info Ship. Method';
        }
        field(5110385; "POI Action Credit Lim Overdue"; Option)
        {
            Caption = 'Action Credit Limit Overdue';
            OptionCaption = 'Warning,,,Block,First Warning Limit + Block Credit Limit,,Cheque & Cash,Cash';
            OptionMembers = Warning,,,Block,"First Warning Limit + Block Credit Limit",,"Cheque & Cash",Cash;
            //ValuesAllowed = Warning;Block;
        }
        field(5110420; "POI Empties Allocation"; Option)
        {
            Caption = 'Empties Allocation';
            Description = 'LVW';
            OptionCaption = 'Without Stock-Keeping Without Invoice,With Stock-Keeping Without Invoice,With Stock-Keeping With Invoice';
            OptionMembers = "Without Stock-Keeping Without Invoice","With Stock-Keeping Without Invoice","With Stock-Keeping With Invoice";
        }
        field(5110421; "POI Empties Calculation"; Option)
        {
            Caption = 'Empties Calculation';
            Description = 'LVW';
            OptionCaption = ' ,Same Document,Separat Document,Combine Document';
            OptionMembers = " ","Same Document","Separat Document","Combine Document";

            trigger OnValidate()
            begin
                IF ("POI Empties Calculation" = "POI Empties Calculation"::"Combine Document") THEN
                    ERROR(AGILES_TEXT006Txt);
            end;
        }
        field(5110422; "POI Empties Price Group"; Code[20])
        {
            Caption = 'Empties Price Group';
            Description = 'LVW';
            TableRelation = "POI Empties Price Groups".Code;
        }
        field(5110423; "POI Obser Reduced Refund Costs"; Boolean)
        {
            Caption = 'Observe Reduced Refund Costs';
            Description = 'LVW';
        }
        field(5110430; "POI Steco Customer No."; Code[10])
        {
            Caption = 'Steco Customer No.';
        }

        modify("Telex No.")
        {
            trigger OnBeforeValidate()
            begin
                IF NOT POIFunction.CheckPermission(18, FieldNo("Telex No."), 2) then
                    Error(NoChangesPermittedTxt);
            end;
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo(Name), "No.", "POI Is Vendor", "POI Group Customer", Name, true, false, true, true, false, true);
            end;
        }
        modify("Name 2")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Name 2"), "No.", "POI Is Vendor", "POI Group Customer", "Name 2", true, false, true, true, false, true);
            end;
        }
        modify("Language Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Language Code"), "No.", "POI Is Vendor", "POI Group Customer", "Language Code", true, true, true, true, false, true);
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo(Address), "No.", "POI Is Vendor", "POI Group Customer", Address, true, false, true, true, false, true);
            end;
        }
        modify("Address 2")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Address 2"), "No.", "POI Is Vendor", "POI Group Customer", "Address 2", true, false, true, true, false, true);
            end;
        }
        modify("Country/Region Code")
        {
            trigger OnAfterValidate()
            var
                CountryRegion: Record "Country/Region";
            begin
                if ("Country/Region Code" <> '') and ("Language Code" = '') then begin
                    CountryRegion.Get("Country/Region Code");
                    "Language Code" := CountryRegion."POI Language";
                end;
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Country/Region Code"), "No.", "POI Is Vendor", "POI Group Customer", "Country/Region Code", true, false, true, true, false, true);
            end;
        }
        modify(City)
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo(City), "No.", "POI Is Vendor", "POI Group Customer", City, true, false, true, true, false, true);
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Post Code"), "No.", "POI Is Vendor", "POI Group Customer", "Post Code", true, false, true, true, false, true);
            end;
        }
        modify(Contact)
        {
            trigger OnAfterValidate()
            begin
                SetDefaultWorkflow(rec);
            end;
        }
        modify("VAT Registration No.")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("VAT Registration No."), "No.", "POI Is Vendor", "POI Group Customer", "VAT Registration No.", true, false, true, false, true, true);
            end;
        }
        modify("Home Page")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Home Page"), "No.", "POI Is Vendor", "POI Group Customer", "Home Page", true, true, true, true, false, true);
            end;
        }
        modify("Document Sending Profile")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Document Sending Profile"), "No.", "POI Is Vendor", "POI Group Customer", "Document Sending Profile", true, true, false, false, true, true);
                POISynchFunction.SynchfieldVendorCustomer(7601, "POI Is Vendor", 1, "Document Sending Profile", true, false, true, true);
            end;
        }
        modify("Tax Liable")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Tax Liable"), "No.", "POI Is Vendor", "POI Group Customer", "Tax Liable", true, false, false, false, true, true);
            end;
        }
        modify("Tax Area Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Tax Area Code"), "No.", "POI Is Vendor", "POI Group Customer", "Tax Area Code", true, false, false, false, true, true);
            end;
        }
        modify("Gen. Bus. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Gen. Bus. Posting Group"), "No.", "POI Is Vendor", "POI Group Customer", "Gen. Bus. Posting Group", true, false, false, false, true, true);
            end;
        }
        modify("VAT Bus. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("VAT Bus. Posting Group"), "No.", "POI Is Vendor", "POI Group Customer", "VAT Bus. Posting Group", true, false, false, false, true, true);
            end;
        }
        modify("Customer Posting Group")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Customer Posting Group"), "No.", "POI Is Vendor", "POI Group Customer", "Customer Posting Group", true, false, false, false, true, true);
            end;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Currency Code"), "POI Group Customer", 0, "Currency Code", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Currency Code"), "No.", "Currency Code", false, false, false);
            end;
        }
        modify("Customer Price Group")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Customer Price Group"), "POI Group Customer", 0, "Customer Price Group", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Customer Price Group"), "No.", "Customer Price Group", false, false, false);
            end;
        }
        modify("Customer Disc. Group")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Customer Disc. Group"), "POI Group Customer", 0, "Customer Disc. Group", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Customer Disc. Group"), "No.", "Customer Disc. Group", false, false, false);
            end;
        }
        modify("Allow Line Disc.")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Allow Line Disc."), "POI Group Customer", 0, "Allow Line Disc.", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Allow Line Disc."), "No.", "Allow Line Disc.", false, false, false);
            end;
        }
        modify("Invoice Disc. Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Invoice Disc. Code"), "POI Group Customer", 0, "Invoice Disc. Code", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Invoice Disc. Code"), "No.", "Invoice Disc. Code", false, false, false);
            end;
        }
        modify("Prices Including VAT")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Prices Including VAT"), "POI Group Customer", 0, "Prices Including VAT", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Prices Including VAT"), "No.", "Prices Including VAT", false, false, false);
            end;
        }
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Payment Method Code"), "POI Group Customer", 0, "Payment Method Code", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Payment Method Code"), "No.", "Payment Method Code", false, false, false);
            end;
        }
        modify("Payment Terms Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Payment Terms Code"), "POI Group Customer", 0, "Payment Terms Code", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Payment Terms Code"), "No.", "Payment Terms Code", false, false, false);
            end;
        }
        modify("Application Method")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Application Method"), "No.", "POI Is Vendor", "POI Group Customer", "Application Method", true, true, false, false, true, true);
            end;
        }
        modify("Reminder Terms Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Reminder Terms Code"), "No.", "POI Is Vendor", "POI Group Customer", "Reminder Terms Code", true, true, false, false, true, true);
            end;
        }
        modify("Block Payment Tolerance")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Block Payment Tolerance"), "No.", "POI Is Vendor", "POI Group Customer", "Block Payment Tolerance", true, true, false, false, true, true);
            end;
        }
        modify("Fin. Charge Terms Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchCustVendGroupCust(FieldNo("Fin. Charge Terms Code"), "No.", "POI Is Vendor", "POI Group Customer", "Fin. Charge Terms Code", true, true, false, false, true, true);
            end;
        }
        modify("Combine Shipments")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Combine Shipments"), "POI Group Customer", 0, "Combine Shipments", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Combine Shipments"), "No.", "Combine Shipments", false, false, false);
            end;
        }
        modify(Reserve)
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo(Reserve), "POI Group Customer", 0, Reserve, true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo(Reserve), "No.", Reserve, false, false, false);
            end;
        }
        modify("Shipping Advice")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Shipping Advice"), "POI Group Customer", 0, "Shipping Advice", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Shipping Advice"), "No.", "Shipping Advice", false, false, false);
            end;
        }
        modify("Shipment Method Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Shipment Method Code"), "POI Group Customer", 0, "Shipment Method Code", true, false, true, false);
                POISynchFunction.SynchCustFromGroupCustomer(18, FieldNo("Shipment Method Code"), "No.", "Shipment Method Code", false, false, false);
            end;
        }
        modify("Credit Limit (LCY)")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(50014, "POI Is Vendor", 1, "Credit Limit (LCY)", true, false, true, false);
            end;
        }
    }

    procedure SetContactData()
    begin
        ContBusRel.RESET();
        ContBusRel.SETRANGE("No.", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
        IF ContBusRel.FINDFIRST() THEN BEGIN
            Cont.GET(ContBusRel."Contact No.");
            Cont."POI Goods Customer" := "POI Goods Customer";
            Cont."POI Service Customer" := "POI Service Customer";
            Cont.MODIFY();

            Cont.RESET();
            Cont.SETRANGE("Company No.", ContBusRel."Contact No.");
            Cont.SETRANGE(Type, Cont.Type::Person);
            IF Cont.FINDSET() THEN
                REPEAT
                    Cont."POI Goods Customer" := "POI Goods Customer";
                    Cont."POI Service Customer" := "POI Service Customer";
                    Cont.MODIFY();
                UNTIL Cont.NEXT() = 0;
        END;
    end;

    procedure SetDefDimension(DimensionCode: Code[20])
    begin
        DefDimension.SETRANGE("Table ID", 18);
        DefDimension.SETRANGE("No.", "No.");
        DefDimension.SETRANGE("Dimension Code", DimensionCode);
        IF DefDimension.FINDSET() THEN BEGIN
            DefDimension."Dimension Value Code" := "POI Customer Main Group Code";
            DefDimension.MODIFY();
        END ELSE BEGIN
            DefDimension.INIT();
            DefDimension."Table ID" := 18;
            DefDimension."No." := "No.";
            DefDimension."Dimension Code" := DimensionCode;
            DefDimension."Dimension Value Code" := "POI Customer Main Group Code";
            DefDimension.INSERT();
        END;
    end;

    procedure CheckVATIDValidation(Customer: Record Customer): Text[20]
    var
        Color: text[20];
    begin
        if Country.Get("Country/Region Code") and (Country."EU Country/Region Code" <> '') then begin
            VatRegLog.SetRange("Account Type", VatRegLog."Account Type"::Customer);
            VatRegLog.SetRange("Account No.", Customer."No.");
            VatRegLog.SetRange("Country/Region Code", Customer."Country/Region Code");
            if VatRegLog.FindLast() then
                if VatRegLog.Status = VatRegLog.Status::Valid then
                    color := 'Standard'
                else
                    color := 'Attention'
            else
                color := 'Attention';
        end else
            color := 'Standard';
        exit(Color);
    end;

    procedure DeleteCreditlimitForAccSetting()
    begin
        if AccCompSett.Get(AccCompSett."Account Type"::Customer, "No.", CompanyName()) then begin
            AccCompSett."Credit Limit" := 0;
            AccCompSett.Modify();
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure SetDefaultWorkflow(Cust: Record Customer)
    begin
    end;

    var
        Cont: Record Contact;
        Country: Record "Country/Region";
        VatRegLog: Record "VAT Registration Log";
        ContBusRel: Record "Contact Business Relation";
        DefDimension: Record "Default Dimension";
        AccCompSett: Record "POI Account Company Setting";
        POIFunction: Codeunit POIFunction;
        POISynchFunction: Codeunit "POI Account Synchronisation";
        NoChangesPermittedTxt: Label 'Keine Änderung erlaubt';
        ERR_NoPermissionTxt: Label 'No Permissions to change this Data.';
        AGILES_TEXT006Txt: Label 'The selection combine document ist not possible !';
}