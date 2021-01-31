tableextension 50023 "POI VendorTableExt" extends Vendor
{

    fields
    {
        field(50000; "POI Port Bank Account"; Code[20])
        {
            Caption = 'Port Lastschriftkonto';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account"."No.";
        }
        field(50001; "POI RefundSet"; Text[250])
        {
            Caption = 'Rückvergütungen';
            DataClassification = CustomerContent;
        }
        field(50002; "POI Prepaymt requested Status"; Option)
        {
            Caption = 'Prepayment requested Status';
            DataClassification = CustomerContent;
            OptionMembers = " ","applied for",approved,"partially authorized","not permitted";
            OptionCaption = ' ,applied for,approved,partially authorized,not permitted';
        }
        field(50003; "POI Group Vendor"; Boolean)
        {
            Caption = 'Gruppenkreditor';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50003, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(5004; "POI Reic assigned to factoring"; Boolean)
        {
            Caption = 'Forderung an Factoring abgetreten';
            DataClassification = CustomerContent;
        }
        field(50005; "POI Business Type"; Option)
        {
            Caption = 'Business Type';
            DataClassification = CustomerContent;
            OptionMembers = Fixprice,Commission;
            OptionCaption = 'Fixed price,Commission';
        }
        field(50006; "POI Last User ID Modified"; Code[50])
        {
            Caption = '"Last User ID Modified"';
            DataClassification = CustomerContent;
        }
        field(50007; "No. 2"; code[20])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }
        field(50008; "POI Factoring Company"; code[20])
        {
            Caption = 'Kreditornr. Factoringgesellschaft';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(50015; "POI Commercial Register No."; Code[30])
        {
            Caption = 'Commercial Register No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50015, 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Commercial Register No."), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Commercial Register No.", true, false, true, false, true, true);
            end;
        }
        field(50017; "POI Termin. Date Extra limit"; Date)
        {
            Caption = 'Künmdigungstermin';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Termin. Date Extra limit"), "POI Is Customer", 0, "POI Termin. Date Extra limit", true, false, true, false);
            end;
        }
        field(50021; POIVATRegistrationNos; Text[100])
        {
            Caption = 'Ust-Ids';
            DataClassification = CustomerContent;
        }
        field(50114; "POI County Court"; Text[50])
        {
            Caption = 'County Court';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50114, 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI County Court"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI County Court", true, false, true, false, true, true);
            end;
        }

        field(50124; "POI Insurance credit limit"; Decimal)
        {
            Caption = 'Insurance credit limit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                SumCreditlimit();
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Insurance credit limit"), "POI Is Customer", 0, "POI Insurance credit limit", true, false, true, false);
            end;
        }
        field(50040; "POI credit limit"; Decimal)
        {
            Caption = 'Credit limit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                SumCreditlimit();
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI credit limit"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI credit limit", true, false, true, false, true, false);
            end;
        }
        field(50105; "POI Internal credit limit"; Decimal)
        {
            Caption = 'Internal credit limit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                SumCreditlimit();
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Internal credit limit"), "POI Is Customer", 0, "POI Internal credit limit", true, false, true, false);
            end;
        }

        field(50112; "POI Group Credit Limit"; Decimal)
        {
            Caption = 'Group Credit Limit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Group Credit Limit"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Group Credit Limit", true, false, true, false, true, true);
            end;
        }
        field(50214; "POI ins. Group Credit Limit"; Decimal)
        {
            Caption = 'Insurance Group Credit Limit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI ins. Group Credit Limit"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI ins. Group Credit Limit", true, false, true, false, true, true);
            end;
        }
        field(50009; "POI Prepayment Total payed"; Decimal)
        {
            Caption = 'geleistete Vorkassen/Anzahlungen';
            DataClassification = CustomerContent;
        }
        field(50010; "POI Gegenforderungen"; Decimal)
        {
            Caption = 'Gegenforderungen';
            DataClassification = CustomerContent;
        }
        field(50011; "POI Flo-ID"; Code[10])
        {
            caption = 'Flo-ID';
            DataClassification = CustomerContent;
        }
        field(50013; "POI Group Use"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Group Use"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Group Use", true, false, false, false, true, true);
            end;
        }
        field(50014; "POI Credit Limit (LCY)"; Decimal)
        {
            Caption = 'Kreditlimit';
            //Editable = false;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(20, "POI Is Customer", 0, "POI Credit Limit (LCY)", true, false, true, false);
            end;
        }
        field(50020; "POI Fiscal Agent"; Code[20])
        {
            Caption = 'Fiskalvertreter';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No." where("POI Tax Representative" = const(true));
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50020, 2) then
                    Error(ERR_NoPermissionTxt);
            end;
        }
        field(50025; "POI Kreditlimit"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50104; "POI Kreditlimit intern"; Decimal)
        {
            Caption = 'Kreditlimit intern';
            DataClassification = CustomerContent;
            InitValue = 0;
            trigger OnValidate()
            begin
                SumCreditlimit();
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Kreditlimit intern"), "POI Is Customer", 0, "POI Kreditlimit intern", true, false, true, false);
            end;
        }
        field(50027; "POI Valutaangabe"; Boolean)
        {
            Caption = 'Valutaangabe';
            DataClassification = CustomerContent;
        }
        field(50028; "POI Special Vendor Nos."; Text[100])
        {
            caption = 'Special Vendor Nos.';
            DataClassification = CustomerContent;
            Editable = false;
            trigger OnValidate()
            begin
                POISynchFunction.SynchAccountAndContact(23, FieldNo("POI Special Vendor Nos."), "No.", "POI Special Vendor Nos.", false, true);
            end;
        }
        field(50029; "POI Credit note procedure"; Boolean)
        {
            Caption = 'Gutschriftsverfahren';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin

                if not POIFunction.CheckPermission(23, 50029, 2) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Credit note procedure"), "POI Vendor Group Code", 1, "POI Credit note procedure", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI Credit note procedure"), "No.", "POI Credit note procedure", false, false, false);
            end;
        }
        field(50042; "POI Vorkasse erwünscht Status"; Option)
        {
            Caption = 'Vorkasse erwünscht Status';
            DataClassification = CustomerContent;
            OptionCaption = ' ,beantragt,genehmigt,teilgenehmigt,abgelehnt';
            OptionMembers = " ",beantragt,genehmigt,teilgenehmigt,abgelehnt;
        }
        field(50043; "POI Vorkasse Status Teilgen."; Date)
        {
            Caption = 'Vorkasse Status Teilgenehmigt';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);
            end;
        }
        field(50044; "POI Vorkasse Teilgen. Betrag"; Decimal)
        {
            Caption = 'Vorkasse Teilgenehmigt Betrag';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);
            end;
        }

        field(50070; "POI Supplier of Goods"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Supplier of Goods';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50070, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Supplier of Goods" then
                    if not ChangeAusnahmegenehmigung(1) then Error('Änderung abgebrochen.');
                if "POI Supplier of Goods" then
                    CheckCreditorType(FieldNo("POI Supplier of Goods"));
                //POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Supplier of Goods"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Supplier of Goods", true, true, false, true, false);
                POISynchFunction.SynchVendortypeForVendorAndGroupVendor(Rec);
            end;
        }
        field(50071; "POI Carrier"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Carrier';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50071, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Carrier" then
                    if not ChangeAusnahmegenehmigung(3) then Error('Änderung abgebrochen.');
                if "POI Carrier" then
                    CheckCreditorType(FieldNo("POI Carrier"));
                //POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Carrier"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Carrier", true, true, false, true, false);
                POISynchFunction.SynchVendortypeForVendorAndGroupVendor(Rec);
            end;
        }
        field(50072; "POI Warehouse Keeper"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Warehouse Keeper';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50072, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Warehouse Keeper" then
                    if ChangeAusnahmegenehmigung(2) then Error('Änderung abgebrochen.');
                if "POI Warehouse Keeper" then
                    CheckCreditorType(FieldNo("POI Warehouse Keeper"));
                //POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Warehouse Keeper"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Warehouse Keeper", true, true, false, true, false);
                POISynchFunction.SynchVendortypeForVendorAndGroupVendor(Rec);
            end;
        }
        field(50073; "POI Customs Agent"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Customs Agent';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50073, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Customs Agent" then
                    if ChangeAusnahmegenehmigung(4) then Error('Änderung abgebrochen.');
                if "POI Customs Agent" then
                    CheckCreditorType(FieldNo("POI Customs Agent"));
                //POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Customs Agent"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Customs Agent", true, true, false, true, false);
                POISynchFunction.SynchVendortypeForVendorAndGroupVendor(Rec);
            end;
        }
        field(50074; "POI Tax Representative"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Tax Representative';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50074, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Tax Representative" then
                    if ChangeAusnahmegenehmigung(4) then Error('Änderung abgebrochen.');
                if "POI Tax Representative" then
                    CheckCreditorType(FieldNo("POI Tax Representative"));
            end;
        }
        field(50075; "POI Diverse Vendor"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Diverse Vendor';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50075, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Diverse Vendor" then
                    if not ChangeAusnahmegenehmigung(4) then Error('Änderung abgebrochen.');
                if "POI Diverse Vendor" then
                    CheckCreditorType(FieldNo("POI Diverse Vendor"));
                //POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Diverse Vendor"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Diverse Vendor", true, true, false, true, false);
                POISynchFunction.SynchVendortypeForVendorAndGroupVendor(Rec);
            end;
        }
        field(50076; "POI Small Vendor"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Small Vendor';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50076, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Small Vendor" then
                    if not ChangeAusnahmegenehmigung(4) then Error('Änderung abgebrochen.');
                IF "POI Small Vendor" then
                    CheckCreditorType(FieldNo("POI Small Vendor"));
                //POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Small Vendor"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Small Vendor", true, true, false, true, false);
                POISynchFunction.SynchVendortypeForVendorAndGroupVendor(Rec);
            end;
        }
        field(50077; "POI Shipping Company"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Shipping Company';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50077, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Shipping Company" then
                    if not ChangeAusnahmegenehmigung(3) then Error('Änderung abgebrochen.');
                if "POI Shipping Company" then
                    CheckCreditorType(FieldNo("POI Shipping Company"));
                POISynchFunction.SynchVendortypeForVendorAndGroupVendor(Rec);
            end;
        }
        field(50058; "POI Company System Filter"; Code[50])
        {
            Caption = 'Company System Filter';
            DataClassification = CustomerContent;
        }
        field(50057; "POI Is Customer"; Code[20])
        {
            Caption = 'Is Customer';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                VATIDCustVend2: Record "POI VAT Registr. No. Vend/Cust";
            begin
                if not POIFunction.CheckPermission(23, 50057, 1) then
                    Error(ERR_NoPermissionTxt);
                if ("POI Is Customer" <> '') and ("POI Is Customer" <> xRec."POI Is Customer") then begin
                    VATIDCustVend.Reset();
                    VATIDCustVend.SetRange(Type, 1);
                    VATIDCustVend.SetRange("Vendor/Customer", "No.");
                    IF VATIDCustVend.FindSet() then
                        repeat
                            if not VATIDCustVend2.Get(VATIDCustVend.Type, VATIDCustVend."Vendor/Customer", VATIDCustVend."VAT Registration No.") then begin
                                VATIDCustVend2 := VATIDCustVend;
                                VATIDCustVend2."Vendor/Customer" := "POI Is Customer";
                                VATIDCustVend2.Type := VATIDCustVend2.Type::Customer;
                                VATIDCustVend2.Insert();
                            end;
                        until VATIDCustVend.Next() = 0;
                end;
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Is Customer"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Is Customer", true, false, false, false, true, true);
            end;
        }
        field(50059; "POI Air freight"; Boolean)
        {
            Caption = 'Air freight';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50059, 2) then
                    Error(ERR_NoPermissionTxt);
                if "POI Air freight" then
                    if not ChangeAusnahmegenehmigung(3) then Error('Änderung abgebrochen.');
            end;
        }
        field(50100; "POI Sales Agent Code"; Code[10])
        {
            Caption = 'Handelsvertreter';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Sales Agent Person" = CONST(true));

            trigger OnLookup()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                lr_SalesPurch.FILTERGROUP(2);
                lr_SalesPurch.SETRANGE("POI Is Sales Agent Person", TRUE);
                lr_SalesPurch.SETRANGE("POI Is Purchaser", FALSE);
                lr_SalesPurch.SETRANGE("POI Is Salesperson", FALSE);
                lr_SalesPurch.FILTERGROUP(0);
                IF Page.RUNMODAL(0, lr_SalesPurch) = ACTION::LookupOK THEN
                    VALIDATE("POI Sales Agent Code", lr_SalesPurch.Code);
            end;

            trigger OnValidate()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                IF lr_SalesPurch.GET("POI Sales Agent Code") THEN;
            end;
        }
        field(50200; "POI Old Vendor No."; Code[20])
        {
            Caption = 'Alte Kreditor Nr.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50200, 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Old Vendor No."), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Old Vendor No.", true, false, true, false, true, true);
            end;
        }
        field(50210; "POI Amtsgericht"; Option)
        {
            Caption = 'Amtsgericht Eintrag';
            DataClassification = CustomerContent;
            OptionMembers = registered,"not registered";
            OptionCaption = 'registered,"not registered"';
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(23, 50210, 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Amtsgericht"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Amtsgericht", true, false, true, false, true, true);
            end;
        }
        field(50256; "POI Credit Insurance No."; Code[20])
        {
            Description = 'Credit Insurance No.';
            Caption = 'Kreditversicherungs Nr.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                // IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                //     ERROR(ERR_NoBasicCompanyTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Credit Insurance No."), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Credit Insurance No.", true, false, true, false, true, true);
            end;
        }
        field(50257; "POI DRA"; Text[50])
        {
            Caption = 'Debtor Risk Assessment';
            Description = 'Debtor Risk Assessment';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI DRA"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI DRA", true, false, true, false, true, true);
            end;
        }
        field(50258; "POI Rating"; Code[10])
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
                SumCreditlimit();
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Extra Limit"), "POI Is Customer", 0, "POI Extra Limit", true, false, true, false);
            end;
        }
        field(50260; "POI Extra Limit valid to"; Date)
        {
            Caption = 'Extra Limit valid to';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Extra Limit valid to"), "POI Is Customer", 0, "POI Extra Limit valid to", true, false, true, false);
            end;
        }
        field(50261; "POI Cred. Ins. Type"; option)
        {
            OptionMembers = ,Erstversicherer,Zusatzversicherung;
            OptionCaption = ',Erstversicherer,Zusatzversicherer';
        }
        field(50262; "POI Adv. Payment Receiver No."; Code[20])
        {
            Caption = 'Vorauszahlungsempfänger Nr.';
            TableRelation = Vendor."No.";
        }
        field(50263; "POI Adv. Payment Receiver Name"; Text[50])
        {
            Caption = 'Vorauszahlungsempfänger Name';
            FieldClass = FlowField;
            CalcFormula = lookup (Vendor.Name where("No." = field("POI Adv. Payment Receiver No.")));
            Editable = false;
        }
        field(50037; "POI No Insurance"; Boolean)
        {
            Caption = 'No Insurance';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI No Insurance"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI No Insurance", true, false, true, false, true, true);
            end;
        }
        field(50038; "POI Easy No."; Code[50])
        {
            Caption = 'Easy No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not CheckEasy() then
                    Error(EasyErrorTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Easy No."), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Easy No.", true, false, true, false, true, true);
            end;
        }
        field(50139; "POI Ins. No. Extra"; Code[20])
        {
            Caption = 'Ins. No. Extra';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Ins. No. Extra"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Ins. No. Extra", true, false, true, false, true, true);
            end;
        }
        field(50313; "POI Ins. Cred. lim. val. until"; Date)
        {
            Caption = 'Ins. Cred. lim. val. until';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Ins. Cred. lim. val. until"), "POI Is Customer", 0, "POI Ins. Cred. lim. val. until", true, false, true, false);
            end;
        }
        field(50314; "POI Cred. limit int. val.until"; Date)
        {
            Caption = 'Kreditlimit int. gültig bis';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);

                IF NOT POIFunction.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);

                IF lr_Qualitaetssicherung.GET("No.", lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
                    lr_Qualitaetssicherung."Credit limit int. valid until" := "POI Cred. limit int. val.until";
                    lr_Qualitaetssicherung.MODIFY();
                END;
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI Cred. limit int. val.until"), "POI Is Customer", 0, "POI Cred. limit int. val.until", true, false, true, false);
            end;
        }
        field(50501; "POI No. Entries for Avis"; Integer)
        {
            Caption = 'No. Entries for Avis';
            DataClassification = CustomerContent;
        }
        field(50505; "POI Direction Code"; Code[10])
        {
            Caption = 'Direction Code';
            DataClassification = CustomerContent;
            //TableRelation = "Direction Code";

            trigger OnValidate()
            begin
                IF (xRec."POI Direction Code" <> '') OR (Blocked = Blocked::" ") THEN
                    IF NOT POIFunction.CheckUserInRole('FB_KREDITOR_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(50502; "POI Payment Type"; Code[10])
        {
            Caption = 'Payment Type';
            DataClassification = CustomerContent;
            //TableRelation = "Payment Type".Code WHERE (Check=FILTER(No));

            trigger OnValidate()
            begin
                IF (xRec."POI Payment Type" <> '') OR (Blocked = Blocked::" ") THEN
                    IF NOT POIFunction.CheckUserInRole('FB_KREDITOR_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);

            end;
        }
        field(50503; "POI Person in Charge Code"; Code[10])
        {
            Caption = 'Person in Charge Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";

            trigger OnLookup()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);

                lr_SalesPurch.FILTERGROUP(2);
                lr_SalesPurch.SETRANGE("POI Is Person in Charge", TRUE);
                lr_SalesPurch.FILTERGROUP(0);
                IF Page.RUNMODAL(0, lr_SalesPurch) = ACTION::LookupOK THEN
                    VALIDATE("POI Person in Charge Code", lr_SalesPurch.Code);
            end;

            trigger OnValidate()
            begin

                if not POIFunction.CheckPermission(23, 50503, 2) then
                    ERROR(ERR_NoPermissionTxt);
                CheckPurchaser("No.");
            end;
        }
        field(50504; "POI ILN"; Code[20])
        {
            Caption = 'ILN';
            DataClassification = CustomerContent;
            Description = 'EDI';
        }
        field(50506; "POI Appendix Shipment Method"; Text[30])
        {
            Caption = 'Additional Info Ship. Method';
            DataClassification = CustomerContent;
        }
        field(50507; "POI Vendor Main Group Code"; Code[10])
        {
            Caption = 'Vendor Main Group Code';
            DataClassification = CustomerContent;
            //TableRelation = "Vendor Main Group";

            trigger OnValidate()
            begin
                lrc_DefaultDimension.SETRANGE("Table ID", 23);
                lrc_DefaultDimension.SETRANGE("No.", "No.");
                lrc_DefaultDimension.SETRANGE("Dimension Code", 'KREDITORENHAUPTGR');
                IF lrc_DefaultDimension.FINDSET() THEN BEGIN
                    lrc_DefaultDimension."Dimension Value Code" := "POI Vendor Main Group Code";
                    lrc_DefaultDimension.MODIFY();
                END ELSE BEGIN
                    lrc_DefaultDimension.INIT();
                    lrc_DefaultDimension."Table ID" := 23;
                    lrc_DefaultDimension."No." := "No.";
                    lrc_DefaultDimension."Dimension Code" := 'KREDITORENHAUPTGR';
                    lrc_DefaultDimension."Dimension Value Code" := "POI Vendor Main Group Code";
                    lrc_DefaultDimension.INSERT();
                END;
            end;
        }
        field(50508; "POI Vendor Group Code"; Code[20])
        {
            Caption = 'Vendor Group Code';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                lrc_VendorGroup: Record Vendor;

            begin
                if not POIFunction.CheckPermission(23, 50508, 1) then
                    Error(ERR_NoPermissionTxt);
                IF "POI Vendor Group Code" <> '' THEN BEGIN
                    lrc_VendorGroup.GET("POI Vendor Group Code");
                    "POI Vendor Main Group Code" := lrc_VendorGroup."POI Vendor Main Group Code";
                END ELSE
                    "POI Vendor Main Group Code" := '';

                lrc_DefaultDimension.SETRANGE("Table ID", 23);
                lrc_DefaultDimension.SETRANGE("No.", "No.");
                lrc_DefaultDimension.SETRANGE("Dimension Code", 'KREDITORENGRUPPE');
                IF lrc_DefaultDimension.FINDSET() THEN BEGIN
                    lrc_DefaultDimension."Dimension Value Code" := "POI Vendor Group Code";
                    lrc_DefaultDimension.MODIFY();
                END ELSE BEGIN
                    lrc_DefaultDimension.INIT();
                    lrc_DefaultDimension."Table ID" := 23;
                    lrc_DefaultDimension."No." := "No.";
                    lrc_DefaultDimension."Dimension Code" := 'KREDITORENGRUPPE';
                    lrc_DefaultDimension."Dimension Value Code" := "POI Vendor Group Code";
                    lrc_DefaultDimension.INSERT();
                END;
                if "POI Vendor Group Code" <> xRec."POI Vendor Group Code" then begin
                    POISynchFunction.SynchTableField(23, FieldNo("POI Vendor Group Code"), "No.", "POI Vendor Group Code", false, true);
                    POISynchFunction.SynchContactTableFieldFromAccount(23, FieldNo("POI Vendor Group Code"), "No.", POISynchFunction.GetGroupAccountContactNo("No.", 1, "POI Vendor Group Code"), true, true);
                end;
            end;
        }
        field(50509; "POI Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(50510; "POI Member of Prod.Companionsh"; Code[20])
        {
            Caption = 'Member of Prod. Companionship';
            DataClassification = CustomerContent;
            //TableRelation = Vendor WHERE ("Is Producer Association"=CONST(Yes));
        }
        field(50512; "POI A.S. Kind of Settlement"; Option)
        {
            Caption = 'Kind of Settlement';
            DataClassification = CustomerContent;
            OptionCaption = 'Fix Price(Invoice),Commission,Fix Price(Credit Memo)';
            OptionMembers = "Fix Price(Invoice)",Commission,"Fix Price(Credit Memo)";
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI A.S. Mode of Calculation"), "POI Vendor Group Code", 1, "POI A.S. Mode of Calculation", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI A.S. Kind of Settlement"), "No.", "POI A.S. Kind of Settlement", false, false, false);
            end;

        }
        field(50513; "POI A.S. Mode of Calculation"; Option)
        {
            Caption = 'A.S. Mode of Calculation';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Netto FOT/FCA,Netto geliefert ab Hafen,Netto ab Lager,Netto geliefert Kunde,Brutto geliefert Kunde,,Netto FOT without Duty';
            OptionMembers = " ","Netto FOT/FCA","Netto geliefert ab Hafen","Netto ab Lager","Netto geliefert Kunde","Brutto geliefert Kunde",,"Netto FOT without Duty";

            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI A.S. Mode of Calculation"), "POI Vendor Group Code", 1, "POI A.S. Mode of Calculation", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI A.S. Mode of Calculation"), "No.", "POI A.S. Mode of Calculation", false, false, false);
            end;
        }
        field(50514; "POI A.S. Commission Fee %"; Decimal)
        {
            Caption = 'Commission Fee %';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI A.S. Commission Fee %"), "POI Vendor Group Code", 1, "POI A.S. Commission Fee %", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI A.S. Commission Fee %"), "No.", "POI A.S. Commission Fee %", false, false, false);
            end;
        }
        field(50515; "POI A.S. Commission Fee % 2"; Decimal)
        {
            Caption = 'Commission Fee % 2';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);
            end;
        }
        field(50516; "POI A.S. Kind of Sales Statemt"; Option)
        {
            Caption = 'A.S. Kind of Sales Statement';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Additiv,Kumuliert';
            OptionMembers = " ",Additiv,Kumuliert;
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI A.S. Kind of Sales Statemt"), "POI Vendor Group Code", 1, "POI A.S. Kind of Sales Statemt", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI A.S. Kind of Sales Statemt"), "No.", "POI A.S. Kind of Sales Statemt", false, false, false);
            end;
        }
        field(50517; "POI A.S. Cost Schema Name Code"; Code[20])
        {
            Caption = 'A.S. Cost Schema Name Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Schema Name";

            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI A.S. Cost Schema Name Code"), "POI Vendor Group Code", 1, "POI A.S. Cost Schema Name Code", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI A.S. Cost Schema Name Code"), "No.", "POI A.S. Cost Schema Name Code", false, false, false);
            end;
        }
        field(50518; "POI A.S. Turnover Reduc. Cost"; Option)
        {
            Caption = 'A.S. Turnover Reducing Cost';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Plan Cost,Posted Cost,Higher Cost';
            OptionMembers = " ","Soll-Kosten","Geb. Kosten","Höhere Kosten";
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI A.S. Turnover Reduc. Cost"), "POI Vendor Group Code", 1, "POI A.S. Turnover Reduc. Cost", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI A.S. Turnover Reduc. Cost"), "No.", "POI A.S. Turnover Reduc. Cost", false, false, false);
            end;
        }
        field(50519; "POI A.S. Cost Splitting"; Option)
        {
            Caption = 'A.S. Cost Splitting';
            DataClassification = CustomerContent;
            Description = ' ,Batch,,,Product Group';
            OptionCaption = ' ,Batch,,,Product Group';
            OptionMembers = " ",Batch,,,"Product Group";

            trigger OnValidate()
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);
            end;
        }
        field(50520; "POI A.S. Refund to Vendor No."; Code[20])
        {
            Caption = 'A.S. Refund to Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);
            end;
        }
        field(50521; "POI A.S. Refund Percentage"; Decimal)
        {
            Caption = 'A.S. Refund Percentage';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);
            end;
        }
        field(50522; "POI Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            DataClassification = CustomerContent;
            Description = '94113';
            TableRelation = "POI Departure Region";
        }
        field(50523; "POI A.S. Commission Fee % 3"; Decimal)
        {
            Caption = 'Commission Fee % 3';
            DataClassification = CustomerContent;
        }
        field(50524; "POI A.S. Commission Base"; Option)
        {
            Caption = 'Commission Base';
            DataClassification = CustomerContent;
            OptionCaption = 'Net Sales Revenue,Gross Sales Revenue';
            OptionMembers = "Net Sales Revenue","Gross Sales Revenue";
            trigger OnValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("POI A.S. Commission Base"), "POI Vendor Group Code", 1, "POI A.S. Commission Base", false, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI A.S. Commission Base"), "No.", "POI A.S. Commission Base", false, false, false);
            end;
        }
        field(50525; "POI Create Balance Confirm."; Boolean)
        {
            Caption = 'Create Balance Confirmation';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);
            end;
        }
        field(50526; "POI Adv. Pay. Currency Code"; Code[10])
        {
            Caption = 'Currency Code Advanced Payment';
            DataClassification = CustomerContent;
            TableRelation = Currency;

            trigger OnLookup()
            var
                lr_Currency: Record Currency;
            begin
                lr_Currency.SETRANGE(Code, 'USD');
                IF Page.RUNMODAL(0, lr_Currency) = ACTION::LookupOK THEN
                    VALIDATE("POI Adv. Pay. Currency Code", lr_Currency.Code);
            end;

            trigger OnValidate()
            begin
                IF (xRec."POI Adv. Pay. Currency Code" <> '') OR (Blocked = Blocked::" ") THEN
                    IF NOT POIFunction.CheckUserInRole('FB_KREDITOR_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(50527; "POI Adv. Pay. Curr from Purch."; Boolean)
        {
            Caption = 'Adv. Pay. Currency from Purch.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF (xRec."POI Adv. Pay. Curr from Purch.") OR (Blocked = Blocked::" ") THEN
                    IF NOT POIFunction.CheckUserInRole('FB_KREDITOR_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(50528; "POI Adv. Payment Receiver"; Option)
        {
            Caption = 'Adv. Payment Receiver';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Vendor,Producer';
            OptionMembers = " ",Kreditor,Produzent;

            trigger OnValidate()
            begin
                IF (xRec."POI Adv. Payment Receiver" <> xRec."POI Adv. Payment Receiver"::" ") OR (Blocked = Blocked::" ") THEN
                    IF NOT POIFunction.CheckUserInRole('FB_KREDITOR_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(50529; "POI Waste Disposal Duty"; Option)
        {
            Caption = 'Waste Disposal Duty';
            DataClassification = CustomerContent;
            Description = 'GP';
            OptionCaption = ' ,DSD Pflichtig,,,ARA Pflichtig';
            OptionMembers = " ","DSD Pflichtig",,,"ARA Pflichtig";
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Waste Disposal Duty"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Waste Disposal Duty", true, true, false, false, true, true);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI Waste Disposal Duty"), "No.", "POI Waste Disposal Duty", false, false, true);
            end;
        }
        field(50530; "POI Waste Disposal Paymt Thru"; Option)
        {
            Caption = 'Waste Disposal Payment Thru';
            DataClassification = CustomerContent;
            Description = 'GP';
            OptionCaption = ',Uns,Lieferant';
            OptionMembers = " ",Uns,Lieferant;
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Waste Disposal Paymt Thru"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Waste Disposal Paymt Thru", true, true, false, false, true, true);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI Waste Disposal Paymt Thru"), "No.", "POI Waste Disposal Paymt Thru", false, false, true);
            end;
        }
        field(50533; "POI Adv. Pay. Rem.Amount (LCY)"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum ("POI Adv. Pay. Vendor"."Remaining Amount (LCY)" WHERE("Vendor No." = FIELD("No.")));
            Caption = 'Adv. Pay. Rem. Amount (LCY)';
            Description = 'VFI';
            Editable = false;
        }
        field(50534; "POI Quality Control Vendor No."; Code[20])
        {
            Caption = 'Quality Control Vendor No.';
            DataClassification = CustomerContent;
            //TableRelation = Vendor WHERE ("Is Quality Controller"=CONST(Yes));
        }
        field(50535; "POI Certif. Control Board Code"; Code[20])
        {
            Caption = 'Certificate Control Board Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Certificate Control Board";
        }
        field(50536; "POI Certificate No."; Code[20])
        {
            Caption = 'Certificate No.';
            DataClassification = CustomerContent;
        }
        field(50537; "POI Subtract W.D. fr Turnover"; Boolean)
        {
            Caption = 'Subtract W.D. from Turnover';
            DataClassification = CustomerContent;
        }
        field(50538; "POI Admitted Vendor"; Boolean)
        {
            Caption = 'Admitted Vendor';
            DataClassification = CustomerContent;
        }
        field(50539; "POI No. 2"; Code[20])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }
        field(5110320; "POI Entry via Transf Loc. Code"; Code[10])
        {
            Caption = 'Entry via Transfer Loc. Code';
            TableRelation = Location;
        }
        field(5110321; "POI Sh-Ag Code to Transf. Loc"; Code[20])
        {
            Caption = 'Ship-Agent Code to Transf. Loc';
            TableRelation = "Shipping Agent";
        }
        field(5110329; "POI Chain Name"; Code[10])
        {
            Caption = 'Chain Name';
            Description = 'FV Tabelle Chain hinterlegt';
            TableRelation = "POI Company Chain";

            trigger OnValidate()
            begin
                IF "POI Chain Name" <> xRec."POI Chain Name" THEN
                    IF "POI Chain Name" <> '' THEN
                        "POI Active Empties Definition" := "POI Active Empties Definition"::"Company Chain"
                    ELSE
                        "POI Active Empties Definition" := "POI Active Empties Definition"::Vendor;
            end;
        }
        field(5110337; "POI Is Shipping Agent"; Boolean)
        {
            Caption = 'Is Shipping Agent';
            Editable = false;

            trigger OnValidate()
            var

            begin
                IF "POI Is Shipping Agent" THEN BEGIN
                    // "POI Is Common Vendor" := FALSE;
                    "POI Small Vendor" := FALSE;
                    "POI Shipping Company" := FALSE;
                END;

                lr_ContBusRel.RESET();
                lr_ContBusRel.SETRANGE("No.", "No.");
                lr_ContBusRel.SETRANGE("Link to Table", lr_ContBusRel."Link to Table"::Vendor);
                IF lr_ContBusRel.FINDFIRST() THEN BEGIN
                    lr_Contact.GET(lr_ContBusRel."Contact No.");

                    //   IF lr_Contact."PI GmbH" THEN ((TODO: basismandant))
                    //     ERROR(ERR_CommonVendor);

                    lr_Contact."POI Carrier" := "POI Is Shipping Agent";
                    // lr_Contact."POI Diverse Vendor" := "POI Is Common Vendor";
                    lr_Contact."POI Small Vendor" := "POI Small Vendor";
                    lr_Contact."POI Shipping Company" := "POI Shipping Company";
                    lr_Contact.MODIFY();

                    lr_Contact.RESET();
                    lr_Contact.SETRANGE("Company No.", lr_ContBusRel."Contact No.");
                    lr_Contact.SETRANGE(Type, lr_Contact.Type::Person);
                    IF lr_Contact.FINDSET() THEN
                        REPEAT
                            // lr_Contact."POI Supplier of Goods" := "POI is Vendor of Trade Items";
                            lr_Contact."POI Carrier" := "POI Is Shipping Agent";
                            //   lr_Contact."POI Warehouse Keeper" := "POI Is Warehouse";
                            //   lr_Contact."POI Customs Agent" := "POI Is Custom Clearing Company";
                            //   lr_Contact."POI Tax Representative" := "POI Is Fiscal Agent";
                            //   lr_Contact."POI Diverse Vendor" := "POI Is Common Vendor";
                            lr_Contact."POI Small Vendor" := "POI Small Vendor";
                            lr_Contact."POI Shipping Company" := "POI Shipping Company";
                            lr_Contact.MODIFY();
                        UNTIL lr_Contact.NEXT() = 0;
                END;
            end;
        }
        field(5110340; "POI Is Manufacturer"; Boolean)
        {
            Caption = 'Is Manufacturer';
            Editable = false;

            trigger OnValidate()
            begin
                IF "POI Is Manufacturer" = FALSE THEN
                    "POI Manufacturer Code" := '';
            end;
        }
        field(5110341; "POI Is Quality Controller"; Boolean)
        {
            Caption = 'Is Quality Controller';
            Editable = false;
        }
        field(5110349; "POI Member State Companionship"; Option)
        {
            Caption = 'Member State Companionship';
            OptionCaption = ' ,Ohne,,,Mitglied,Nicht Mitglied,,,Sonstiges';
            OptionMembers = " ",Ohne,,,Mitglied,"Nicht Mitglied",,,Sonstiges;
        }
        field(5110378; "POI Cultivation Associat. Code"; Code[10])
        {
            Caption = 'Cultivation Association Code';
            TableRelation = "POI Cultivation Association";
        }
        field(5110383; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transition,Organic';
            OptionMembers = " ",Transition,Organic;
        }
        field(5110385; "POI Manufacturer Code"; Code[10])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;

            trigger OnValidate()
            begin
                IF "POI Is Manufacturer" = FALSE THEN
                    "POI Manufacturer Code" := '';
            end;
        }
        field(5110420; "POI Empties Allocation"; Option)
        {
            Caption = 'Empties Allocation';
            Description = 'Without Stock-Keeping Without Invoice,With Stock-Keeping Without Invoice,With Stock-Keeping With Invoice';
            OptionCaption = 'Without Stock-Keeping Without Invoice,With Stock-Keeping Without Invoice,With Stock-Keeping With Invoice';
            OptionMembers = "Without Stock-Keeping Without Invoice","With Stock-Keeping Without Invoice","With Stock-Keeping With Invoice";
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Empties Allocation"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Empties Allocation", true, true, false, false, true, true);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI Empties Allocation"), "No.", "POI Empties Allocation", false, false, true);
            end;
        }
        field(5110421; "POI Empties Calculation"; Option)
        {
            Caption = 'Empties Calculation';
            Description = ' ,Same Document,Separat Document,Combine Document';
            //OptionCaption = ' ,Same Document,Separat Document,Combine Document';
            OptionCaption = ' ,gleiches Dokument,separates Dokument,Sammelbeleg';
            OptionMembers = " ","Same Document","Separat Document","Combine Document";
            trigger OnValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("POI Empties Calculation"), "No.", "POI Is Customer", "POI Vendor Group Code", "POI Empties Calculation", true, true, false, false, true, true);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("POI Empties Calculation"), "No.", "POI Empties Calculation", false, false, true);
            end;
        }
        field(5110422; "POI Empties Price Group"; Code[20])
        {
            Caption = 'Empties Price Group';
            Description = 'LVW';
            TableRelation = "POI Empties Price Groups".Code;
        }
        field(5110424; "POI Active Empties Definition"; Option)
        {
            Caption = 'Active Empties Definition';
            Description = 'LVW';
            OptionCaption = 'Vendor,Company Chain';
            OptionMembers = Vendor,"Company Chain";

            trigger OnValidate()
            begin
                IF "POI Active Empties Definition" = "POI Active Empties Definition"::"Company Chain" THEN
                    TESTFIELD("POI Chain Name");
            end;
        }
        field(5110426; "POI Empties Fld VAT Prod. Grp."; Code[10])
        {
            Caption = 'Empties Filled VAT Prod. Grp.';
            TableRelation = "VAT Product Posting Group";
        }
        field(5110427; "POI Empt Empty VAT Prod. Grp."; Code[10])
        {
            Caption = 'Empties Empty VAT Prod. Grp.';
            TableRelation = "VAT Product Posting Group";
        }
        field(5110450; "POI B/L Shipper"; Code[20])
        {
            Caption = 'B/L Shipper';
            TableRelation = Vendor."No.";
        }
        field(5110515; "POI Is Shipping Company"; Boolean)
        {
            Caption = 'Is Shipping Company';
            Editable = false;
        }

        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo(Name), "No.", "POI Is Customer", "POI Vendor Group Code", Name, true, false, true, true, false, true);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Search Name"), "No.", "POI Is Customer", "POI Vendor Group Code", "Search Name", true, false, true, true, false, true);
            end;
        }
        modify("Name 2")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Name 2"), "No.", "POI Is Customer", "POI Vendor Group Code", "Name 2", false, false, true, true, false, true);
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo(Address), "No.", "POI Is Customer", "POI Vendor Group Code", Address, true, false, true, true, false, true);
            end;
        }
        modify("Address 2")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Address 2"), "No.", "POI Is Customer", "POI Vendor Group Code", "Address 2", true, false, true, true, false, true);
            end;
        }
        modify(City)
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo(City), "No.", "POI Is Customer", "POI Vendor Group Code", City, true, false, true, true, false, true);
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Post Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Post Code", true, false, true, true, false, true);
            end;
        }

        modify("Language Code")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Language Code"), 2) then
                    Error(ERR_NoPermissionTxt);
            end;

            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Language Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Language Code", true, true, true, true, false, true);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("Language Code"), "No.", "Language Code", false, false, true);
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
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Country/Region Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Country/Region Code", true, false, true, true, false, true);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Language Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Language Code", true, false, true, true, false, true);
                CheckRegistrationNo();
            end;
        }
        modify(Blocked)
        {
            trigger OnAfterValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo(Blocked), 1) then
                    Error(ERR_NoPermissionTxt);
                if Blocked <> xRec.Blocked then
                    if AccountCompanySetting.Get(AccountCompanySetting."Account Type"::Vendor, "No.", CompanyName()) then begin
                        AccountCompanySetting."Block Status" := Blocked;
                        AccountCompanySetting.Modify();
                    end;
            end;
        }
        modify("VAT Registration No.")
        {
            trigger OnAfterValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Country/Region Code"), 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("VAT Registration No."), "No.", "POI Is Customer", "POI Vendor Group Code", "VAT Registration No.", true, false, true, false, true, true);
            end;
        }
        modify("Registration No.")
        {
            trigger OnAfterValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Country/Region Code"), 1) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Registration No."), "No.", "POI Is Customer", "POI Vendor Group Code", "Registration No.", true, false, false, false, true, true);
                POISynchFunction.SynchfieldVendorCustomer(50006, "POI Is Customer", 0, "Registration No.", true, false, true, true);
                if "Registration No." = '' then
                    CheckRegistrationNo();
            end;
        }
        modify("Pay-to Vendor No.")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Pay-to Vendor No."), 2) then
                    Error(ERR_NoPermissionTxt);
            end;
        }
        modify("Home Page")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Home Page"), 2) then
                    Error(ERR_NoPermissionTxt);
            end;

            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Home Page"), "No.", "POI Is Customer", "POI Vendor Group Code", "Home Page", true, true, true, true, false, true);
            end;
        }
        modify("Document Sending Profile")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Document Sending Profile"), 2) then
                    Error(ERR_NoPermissionTxt);
            end;

            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Document Sending Profile"), "No.", "POI Is Customer", "POI Vendor Group Code", "Document Sending Profile", true, true, false, false, true, true);
                POISynchFunction.SynchfieldVendorCustomer(11, "POI Is Customer", 0, "Document Sending Profile", true, false, true, true);
            end;
        }
        modify("Invoice Disc. Code")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Invoice Disc. Code"), 2) then
                    Error(ERR_NoPermissionTxt);
            end;

            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Invoice Disc. Code"), "POI Vendor Group Code", 1, "Invoice Disc. Code", true, false, true, false);
            end;
        }
        modify("Tax Liable")
        {
            trigger OnAfterValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Tax Liable"), 2) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Tax Liable"), "No.", "POI Is Customer", "POI Vendor Group Code", "Tax Liable", true, false, true, false, true, true);
            end;
        }
        modify("Tax Area Code")
        {
            trigger OnAfterValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Tax Area Code"), 2) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Tax Area Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Tax Area Code", true, false, true, false, true, true);
            end;
        }
        modify("Gen. Bus. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Gen. Bus. Posting Group"), 2) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Gen. Bus. Posting Group"), "No.", "POI Is Customer", "POI Vendor Group Code", "Gen. Bus. Posting Group", true, false, true, false, true, true);
            end;
        }
        modify("VAT Bus. Posting Group")
        {
            trigger OnAfterValidate()
            begin

                if not POIFunction.CheckPermission(23, FieldNo("VAT Bus. Posting Group"), 2) then
                    Error(ERR_NoPermissionTxt);

                POISynchFunction.SynchVendCustGroupVendor(FieldNo("VAT Bus. Posting Group"), "No.", "POI Is Customer", "POI Vendor Group Code", "VAT Bus. Posting Group", true, false, true, false, true, true);
            end;
        }
        modify("Vendor Posting Group")
        {
            trigger OnAfterValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Vendor Posting Group"), 2) then
                    Error(ERR_NoPermissionTxt);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Vendor Posting Group"), "No.", "POI Is Customer", "POI Vendor Group Code", "Vendor Posting Group", true, false, true, false, true, true);
            end;
        }
        modify("Block Payment Tolerance")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Block Payment Tolerance"), "No.", "POI Is Customer", "POI Vendor Group Code", "Block Payment Tolerance", true, true, false, false, true, true);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("Block Payment Tolerance"), "No.", "Block Payment Tolerance", false, false, true);
            end;
        }
        modify("Delivery Reminder Terms")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Delivery Reminder Terms"), "No.", "POI Is Customer", "POI Vendor Group Code", "Delivery Reminder Terms", true, true, false, false, true, true);
            end;
        }
        modify("Prices Including VAT")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Prices Including VAT"), 2) then
                    Error(ERR_NoPermissionTxt);
            end;

            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Prices Including VAT"), "POI Vendor Group Code", 1, "Prices Including VAT", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("Prices Including VAT"), "No.", "Prices Including VAT", false, false, false);
            end;
        }
        modify("Payment Terms Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Payment Terms Code"), "POI Vendor Group Code", 1, "Payment Terms Code", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("Payment Terms Code"), "No.", "Payment Terms Code", false, false, false);
            end;
        }
        modify("Shipment Method Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Shipment Method Code"), "POI Vendor Group Code", 1, "Shipment Method Code", true, false, true, false);
                POISynchFunction.SynchVendFromGroupVendor(23, FieldNo("Shipment Method Code"), "No.", "Shipment Method Code", false, false, false);
            end;
        }
        modify("Credit Amount (LCY)")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchfieldVendorCustomer(FieldNo("Credit Amount (LCY)"), "POI Is Customer", 0, "Credit Amount (LCY)", true, false, true, false);
            end;
        }
        modify("Purchaser Code")
        {
            trigger OnAfterValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Purchaser Code"), 2) then
                    ERROR(ERR_NoPermissionTxt);
                CheckPurchaser("No.");
            end;
        }
        modify("Our Account No.")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Our Account No."), 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        modify("Phone No.")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Phone No."), 2) then
                    Error(ERR_NoPermissionTxt);
            end;
        }
        modify("E-Mail")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("E-Mail"), 2) then
                    Error(ERR_NoPermissionTxt);
            end;
        }
        modify("Fax No.")
        {
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo("Fax No."), 2) then
                    Error(ERR_NoPermissionTxt);
            end;
        }
    }

    trigger OnInsert()
    begin
        "Invoice Disc. Code" := "No.";
    end;

    trigger OnAfterInsert()
    begin
        SetdefaultPOIWorkflow(Rec, xRec);
    end;

    procedure CheckCreditorType(FieldNo: Integer)
    var
        CompanyErrTxt: Label 'Kleinlieferant Sachkosten kann nur für PORT International definiert werden.';
    begin
        case FieldNo of
            50070:
                begin //Supplier of Goods
                    "POI Customs Agent" := false;
                    "POI Diverse Vendor" := false;
                    "POI Tax Representative" := false;
                    "POI Small Vendor" := false;
                    "POI Shipping Company" := false;
                end;
            50071, 50072:
                begin //Carrier,//Warehouse Keeper
                    "POI Diverse Vendor" := false;
                    "POI Small Vendor" := false;
                    "POI Shipping Company" := false;
                end;
            50073, 50074:
                begin  //Customs Agent,//Tax Representative
                    "POI Supplier of Goods" := false;
                    "POI Diverse Vendor" := false;
                    "POI Small Vendor" := false;
                    "POI Shipping Company" := false;
                end;
            50075:
                begin //Diverse Vendor
                    "POI Customs Agent" := false;
                    "POI Carrier" := false;
                    "POI Tax Representative" := false;
                    "POI Small Vendor" := false;
                    "POI Shipping Company" := false;
                    "POI Customs Agent" := false;
                    "POI Supplier of Goods" := false;
                    "POI Warehouse Keeper" := false;
                    //Company
                    POICompany.SetRange(Diverse, true);
                    IF POICompany.FindFirst() then
                        IF NOT AccountCompanySetting.Get(2, "No.", POICompany.Mandant) then begin
                            AccountCompanySetting.Init();
                            AccountCompanySetting."Account No." := "No.";
                            AccountCompanySetting."Account Type" := AccountCompanySetting."Account Type"::Vendor;
                            AccountCompanySetting."Company Name" := POICompany.Mandant;
                            AccountCompanySetting.Insert();
                        end;
                end;
            50076:
                begin //Small Vendor
                    "POI Customs Agent" := false;
                    "POI Carrier" := false;
                    "POI Tax Representative" := false;
                    "POI Diverse Vendor" := false;
                    "POI Shipping Company" := false;
                    "POI Customs Agent" := false;
                    "POI Supplier of Goods" := false;
                    "POI Warehouse Keeper" := false;
                    //Company
                    POICompany.SetRange("Small Vendor", true);
                    POICompany.SetRange("Synch Masterdata");
                    POICompany.FindFirst();
                    AccountCompanySetting.SetRange("Account Type", 2);
                    AccountCompanySetting.SetRange("Account No.", "No.");
                    AccountCompanySetting.SetFilter("Company Name", '%1 <>', POICompany.Mandant);
                    IF AccountCompanySetting.FindSet() then
                        Message(CompanyErrtxt);
                end;
            50077:
                begin //Shipping Company
                    "POI Customs Agent" := false;
                    "POI Diverse Vendor" := false;
                    "POI Tax Representative" := false;
                    "POI Diverse Vendor" := false;
                    "POI Small Vendor" := false;
                    "POI Customs Agent" := false;
                    "POI Supplier of Goods" := false;
                    "POI Warehouse Keeper" := false;
                end;
        end;
    end;

    procedure CheckMandatoryFields()
    begin
        if "POI Credit Insurance No." <> '' then begin
            if "POI Easy No." = '' then
                Error(err_FieldErrorTxt, FieldCaption("POI Easy No."));
            if "POI Insurance credit limit" = 0 then
                Error(err_FieldErrorTxt, FieldCaption("POI Insurance credit limit"));
        end;
        if "POI Ins. No. Extra" <> '' then begin
            if "POI Extra Limit" = 0 then
                Error(err_FieldErrorTxt, FieldCaption("POI Extra Limit"));
            if "POI Extra Limit valid to" = 0D then
                Error(err_FieldErrorTxt, FieldCaption("POI Extra Limit valid to"));
        end;
        if "POI Internal credit limit" <> 0 then
            if "POI Cred. limit int. val.until" = 0D then
                Error(err_FieldErrorTxt, FieldCaption("POI Cred. limit int. val.until"));
        if "POI A.S. Kind of Settlement" = "POI A.S. Kind of Settlement"::Commission then begin
            if "POI A.S. Refund Percentage" = 0 then
                Error(err_FieldErrorTxt, FieldCaption("POI A.S. Refund Percentage"));
            if "POI A.S. Kind of Sales Statemt" = "POI A.S. Kind of Sales Statemt"::" " then
                Error(err_FieldErrorTxt, FieldCaption("POI A.S. Kind of Sales Statemt")); //TODO:Pflichtfelder
            if "POI A.S. Commission Base" = 0 then
                Error(err_FieldErrorTxt, FieldCaption("POI A.S. Commission Base"));
            if "POI A.S. Commission Fee %" = 0 then
                Error(err_FieldErrorTxt, FieldCaption("POI A.S. Commission Fee %"));
        end;
        if "POI Waste Disposal Duty" <> "POI Waste Disposal Duty"::" " then
            if "POI Waste Disposal Paymt Thru" = "POI Waste Disposal Paymt Thru"::" " then
                Error(err_FieldErrorTxt, FieldCaption("POI Waste Disposal Paymt Thru"));
        if "VAT Bus. Posting Group" = '' then
            Error(err_FieldErrorTxt, FieldCaption("VAT Bus. Posting Group"));
        if "Vendor Posting Group" = '' then
            Error(err_FieldErrorTxt, FieldCaption("Vendor Posting Group"));
        if "Gen. Bus. Posting Group" = '' then
            Error(err_FieldErrorTxt, FieldCaption("Gen. Bus. Posting Group"));
        if "Tax Area Code" = '' then
            Error(err_FieldErrorTxt, FieldCaption("Tax Area Code"));
    end;

    procedure CheckRegistrationNo()
    begin
        Country.Get("Country/Region Code");
        if (Country."EU Country/Region Code" = '') and ("Registration No." = '') then
            Message('Steuernummer muss bei Drittländern agegeben werden.');
    end;

    procedure CheckPurchaser(VendorNo: Code[20])
    PurchaserExist: Boolean;
    begin
        PurchaserExist := true;
        AccountCompanySetting.Reset();
        AccountCompanySetting.SetRange("Account Type", AccountCompanySetting."Account Type"::Vendor);
        AccountCompanySetting.SetRange("Account No.", VendorNo);
        AccountCompanySetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
        if AccountCompanySetting.FindSet() then
            repeat
                Vendor.ChangeCompany(AccountCompanySetting."Company Name");
                if (Vendor."POI Person in Charge Code" = '') or (Vendor."Purchaser Code" = '') then
                    PurchaserExist := false;
            until (AccountCompanySetting.Next() = 0) or not PurchaserExist
        else
            PurchaserExist := false;
        if lr_Qualitaetssicherung.Get(VendorNo, lr_Qualitaetssicherung."Source Type"::Vendor) then
            if not lr_Qualitaetssicherung.PurchSalespersonOK then begin
                lr_Qualitaetssicherung.Validate(PurchSalespersonOK, PurchaserExist);
                lr_Qualitaetssicherung.Modify();
            end;
    end;

    procedure CheckVATIDValidation(Vendor: Record Vendor): Text[20]
    var
        Color: text[20];
    begin
        if Country.Get("Country/Region Code") and (Country."EU Country/Region Code" <> '') then begin
            VatRegLog.SetRange("Account Type", VatRegLog."Account Type"::Vendor);
            VatRegLog.SetRange("Account No.", Vendor."No.");
            VatRegLog.SetRange("Country/Region Code", Vendor."Country/Region Code");
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


    procedure SumCreditlimit()
    begin
        "POI Credit Limit (LCY)" := 0;
        CreditlimitData.Reset();
        CreditlimitData.SetRange("Company Name", CompanyName());
        CreditlimitData.SetRange("Easy No.", "POI Easy No.");
        CreditlimitData.setfilter(Product, '%1|%2', 'KREDITLIMIT', 'EXPRESS-PAUSCHALDECKUNG');
        CreditlimitData.SetRange(Status, 'GÜLTIG');
        CreditlimitData.SetFilter("valid from", '<=%1', Today());
        CreditlimitData.SetFilter("valid to", '>=%1|%2', Today(), 0D);
        if CreditlimitData.FindLast() then
            "POI Credit Limit (LCY)" += CreditlimitData.Amount;
        Parameter.Reset();
        Parameter.SetRange("Source Type", Parameter."Source Type"::Vendor);
        Parameter.SetRange("Source No.", "POI Ins. No. Extra");
        Parameter.SetRange(Department, 'ZUSATZVERS');
        if not Parameter.IsEmpty then begin
            CreditlimitData.SetRange(Product, 'TOPLINER');
            if CreditlimitData.FindLast() then
                "POI Credit Limit (LCY)" += "POI Extra Limit";
        end else
            "POI Credit Limit (LCY)" += "POI Extra Limit";
        "POI Credit Limit (LCY)" += "POI Internal credit limit";
    end;

    procedure CheckEasy(): Boolean
    var
        i: integer;
    begin
        if not (StrLen("POI Easy No.") = 14) then
            exit(false);
        For i := 1 to StrLen("POI Easy No.") do
            if not ("POI Easy No."[i] IN ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']) then
                exit(false);

        exit(true);
    end;

    procedure ChangeAusnahmegenehmigung(Newlevel: Integer): Boolean
    var
        level: Integer;
        Handled: Boolean;
        AusnahmeverfallTxt: label 'Diese Änderung des Lieferantentyps führt zum Verfall der bestehenden Ausnahmegenehmigung und der Lieferant wird gesperrt.';
    begin
        Clear(Handled);
        if xRec."POI Supplier of Goods" then
            level := 1
        else
            if xRec."POI Warehouse Keeper" then
                level := 2
            else
                if xRec."POI Shipping Company" or xRec."POI Air freight" or xRec."POI Carrier"
           then
                    level := 3
                else
                    if xRec."POI Diverse Vendor" or xRec."POI Small Vendor" or xRec."POI Tax Representative" or xRec."POI Customs Agent" then level := 4;
        if Newlevel < level then begin
            if Confirm(AusnahmeverfallTxt, false) then begin
                Handled := true;
                if QM.Get(QM."Source Type"::Vendor, "No.") then
                    if QM.Ausnahmegenehmigung = QM.Ausnahmegenehmigung::genehmigt then begin
                        QM."Ausnahmegenehmigung Ablauf" := 0D;
                        QM.Ausnahmegenehmigung := QM.Ausnahmegenehmigung::beantragt;
                        QM."Freigabe für Kreditor" := false;
                        QM.Modify();
                    end;
                Validate(Blocked, Blocked::All);
            end;
        end else
            Handled := true;
        exit(Handled);
    end;

    // [IntegrationEvent(false, false)]
    // local procedure OnAfterCreateVendor(var Vendor: Record Vendor; var xVendor: Record Vendor)
    // begin
    // end;
    [IntegrationEvent(false, false)]
    procedure SetdefaultPOIWorkflow(var Vendor: Record Vendor; var xVendor: Record Vendor)
    begin
    end;

    var
        lrc_DefaultDimension: Record "Default Dimension";
        lr_ContBusRel: Record "Contact Business Relation";
        lr_Contact: Record Contact;
        AccountCompanySetting: Record "POI Account Company Setting";
        POICompany: Record "POI Company";
        VATIDCustVend: Record "POI VAT Registr. No. Vend/Cust";
        lr_Qualitaetssicherung: Record "POI Quality Management";
        Country: Record "Country/Region";
        VatRegLog: Record "VAT Registration Log";
        Vendor: Record Vendor;
        CreditlimitData: Record "POI Ins. Cred. lim. Buffer";
        Parameter: Record "POI Parameter";
        QM: Record "POI Quality Management";
        POIFunction: Codeunit POIFunction;
        POISynchFunction: Codeunit "POI Account Synchronisation";
        ERR_NoPermissionTxt: Label 'Keine Berechtigung zum Ändern dieses Feldes.';
        ERR_NoBasicCompanyTxt: label 'Bitte im operativen Mandanten ausführen.';
        err_FieldErrorTxt: Label 'Das Feld %1 muss gefüllt sein.', Comment = '%1';
        EasyErrorTxt: label 'Easy Nr. darf nur Zahlen enthalten und muss 19 Zeichen lang sein.';
}