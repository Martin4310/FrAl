tableextension 50100 "POI Contact Ext" extends Contact
{

    fields
    {
        Field(50300; "POI Air freight"; Boolean)
        {
            Caption = 'Luftfracht';
            DataClassification = CustomerContent;
        }
        field(50508; "POI Group Contact"; code[20])
        {
            Caption = 'Group Contact';
            DataClassification = CustomerContent;
            trigger OnValidate()
            // var
            //     AccountSynch: Codeunit "POI Account Synchronisation";
            begin
                // if Type = Type::Company then
                //     Error(NoPersonContactTxt)
                // else
                //     if "POI Group Contact" <> '' then
                //         AccountSynch.SynchContactBatch("No.");
            end;
        }

        // Add changes to table fields here
        field(50512; "POI VendororCustomer"; enum "POI VendorCustomer")
        {
            DataClassification = CustomerContent;
            // OptionMembers = " ",Customer,Vendor;
            // OptionCaption = ' ,Customer,Vendor';
            Caption = 'Vendor or Customer';
        }
        field(50113; "POI Company System Filter"; Code[50])
        {
            Caption = 'Company System Filter';
            DataClassification = CustomerContent;
        }
        field(50028; "POI Special Contact Nos."; Text[100])
        {
            caption = 'Special Contact Nos.';
            DataClassification = CustomerContent;
        }
        field(50060; "POI Department"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",Handel,Geschäftsleitung,Buchhaltung,Qualitätssicherung,QMB,Abwicklung,Logistik,Lager,Notfall,Sonatiges,Zahlungsavis,Rechnung,Reklamation;
            OptionCaption = ' ,Handel,Geschäftsleitung,Buchhaltung,Qualitätssicherung,QMB,Abwicklung,Logistik,Lager,Notfall,Sonatiges,Zahlungsavis,Rechnung,Reklamation';
            Caption = 'Department';
        }
        field(50070; "POI Supplier of Goods"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Supplier of Goods';
            trigger OnValidate()
            begin
                if "POI Supplier of Goods" then
                    CheckCreditorType(FieldNo("POI Supplier of Goods"));
            end;
        }
        field(50071; "POI Carrier"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Carrier';
            trigger OnValidate()
            begin
                if "POI Carrier" then
                    CheckCreditorType(FieldNo("POI Carrier"));
            end;
        }
        field(50072; "POI Warehouse Keeper"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Warehouse Keeper';
            trigger OnValidate()
            begin
                if "POI Warehouse Keeper" then
                    CheckCreditorType(FieldNo("POI Warehouse Keeper"));
            end;
        }
        field(50073; "POI Customs Agent"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Customs Agent';
            trigger OnValidate()
            begin
                if "POI Customs Agent" then
                    CheckCreditorType(FieldNo("POI Customs Agent"));
            end;
        }
        field(50074; "POI Tax Representative"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Tax Representative';
            trigger OnValidate()
            begin
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
                if "POI Diverse Vendor" then
                    CheckCreditorType(FieldNo("POI Diverse Vendor"));
            end;
        }
        field(50076; "POI Small Vendor"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Small Vendor';
            trigger OnValidate()
            begin
                IF "POI Small Vendor" then
                    CheckCreditorType(FieldNo("POI Small Vendor"));
            end;
        }
        field(50077; "POI Shipping Company"; Boolean)
        {
            DataClassification = CustomerContent;
            caption = 'Shipping Company';
            trigger OnValidate()
            begin
                if "POI Shipping Company" then
                    CheckCreditorType(FieldNo("POI Shipping Company"));
            end;
        }
        field(50078; "POI Goods Customer"; Boolean)
        {
            Caption = 'Goods Customer';
            DataClassification = CustomerContent;
        }
        field(50079; "POI Service Customer"; Boolean)
        {
            Caption = 'Service Customer';
            DataClassification = CustomerContent;
        }
        field(50080; "POI divers Customer"; Boolean)
        {
            Caption = 'divers Customer';
            DataClassification = CustomerContent;
        }
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                //POISynchFunction.SynchTableField(5050, FieldNo(Name), "No.", Name);
                IF (Type = Type::Company) or ((Type = Type::Person) and ("POI Group Contact" <> '')) then
                    POISynchFunction.SynchContactAndAccount(FieldNo(Name), "No.", Name, Type, true);
            end;
        }
        modify("Name 2")
        {
            trigger OnAfterValidate()
            begin
                //OnAfterCreateContact(Rec, xRec);
                POISynchFunction.SynchTableField(5050, FieldNo("Name 2"), "No.", "Name 2", false, true);
            end;
        }
        modify("Language Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchTableField(5050, FieldNo("Language Code"), "No.", "Language Code", false, true);
            end;
        }
        modify("Country/Region Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchTableField(5050, FieldNo("Country/Region Code"), "No.", "Country/Region Code", false, true);
            end;
        }
        modify(Address)
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchTableField(5050, FieldNo(Address), "No.", Address, false, true);
            end;
        }
        modify("Address 2")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchTableField(5050, FieldNo("Address 2"), "No.", "Address 2", false, true);
            end;
        }
        modify("Phone No.")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchTableField(5050, FieldNo("Phone No."), "No.", "Phone No.", false, true);
            end;
        }
        modify("Salutation Code")
        {
            trigger OnAfterValidate()
            begin
                POISynchFunction.SynchTableField(5050, FieldNo("Salutation Code"), "No.", "Salutation Code", false, true);
            end;
        }
    }


    procedure CheckCreditorType(FieldNo: Integer)
    var
        CompanyErrTxt: Label 'Kleinlieferant Sachkosten kann nur für PORT International definiert werden.';
        CompanyErrNoCompanyTxt: Label 'Kein Mandant für Small Vendor vorgesehen.';
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
                    IF POICompany.FindFirst() then Begin
                        AccountCompanySetting.SetRange("Account Type", 0);
                        AccountCompanySetting.SetRange("Account No.", "No.");
                        AccountCompanySetting.SetFilter("Company Name", '%1 <>', POICompany.Mandant);
                        IF AccountCompanySetting.FindSet() then
                            Message(CompanyErrtxt);
                    end else
                        Message(CompanyErrNoCompanyTxt);
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

    procedure CreateCompanySystemID(AccountNo: Code[20]; AccountType: Option Contact,Customer,Vendor): Code[50]
    var
        OutPut: Code[50];
    begin
        Clear(OutPut);
        AccountCompanySetting.Reset();
        AccountCompanySetting.SetRange("Account No.", AccountNo);
        AccountCompanySetting.SetRange("Account Type", AccountType);
        //AccountCompanySetting.SetRange(Released, true);
        IF AccountCompanySetting.FindSet() then
            repeat
                POICompany.Get(uppercase(AccountCompanySetting."Company Name"));
                if StrLen(OutPut) + StrLen(POICompany."Company System ID") + 1 <= MaxStrLen(OutPut) then
                    if OutPut = '' then
                        OutPut := POICompany."Company System ID"
                    else
                        OutPut := CopyStr(OutPut + '|' + POICompany."Company System ID", 1, 50);
            until AccountCompanySetting.Next() = 0;
        exit(OutPut);
    end;

    procedure CopyAccountSettings(FromAccountNo: Code[20]; ToAccountNo: Code[20]; FromAccountType: enum "POI VendorCustomer"; ToAccountType: enum "POI VendorCustomer")
    var
        AccountCompanySetting2: Record "POI Account Company Setting";
        BasicCompany: Text[50];
    begin
        BasicCompany := POICompany.GetBasicCompany();
        AccountCompanySetting.Reset();
        AccountCompanySetting.SetRange("Account No.", FromAccountNo);
        AccountCompanySetting.SetRange("Account Type", FromAccountType);
        AccountCompanySetting.SetFilter("Company Name", '<>%1', BasicCompany);
        IF AccountCompanySetting.FindSet() then
            repeat
                if not AccountCompanySetting2.Get(ToAccountType, ToAccountNo, AccountCompanySetting."Company Name") then begin
                    AccountCompanySetting2.Init();
                    AccountCompanySetting2 := AccountCompanySetting;
                    AccountCompanySetting2."Account Type" := ToAccountType;
                    AccountCompanySetting2."Account No." := ToAccountNo;
                    AccountCompanySetting2.Visible := true;
                    AccountCompanySetting2.Insert();
                end;
            until AccountCompanySetting.Next() = 0;
        //immer auf die Stammkompanie prüfen und eintragen
        BasicCompany := POICompany.GetBasicCompany();
        IF NOT AccountCompanySetting2.get(ToAccountType, ToAccountNo, BasicCompany) then begin
            AccountCompanySetting2.Init();
            AccountCompanySetting2."Account Type" := ToAccountType;
            AccountCompanySetting2."Account No." := ToAccountNo;
            AccountCompanySetting2."Company Name" := BasicCompany;
            AccountCompanySetting2.Visible := false;
            AccountCompanySetting2.Insert();
        end;

    end;

    procedure DeleteAccountCopanySettings(AccountNo: Code[20]; AccountType: Option Contact,Customer,Vendor,Create)
    begin
        AccountCompanySetting.Reset();
        AccountCompanySetting.SetRange("Account No.", AccountNo);
        AccountCompanySetting.SetRange("Account Type", AccountType);
        AccountCompanySetting.DeleteAll();
    end;

    procedure SetActualCompany()

    begin
        Type := Type::Company;
        IF NOT AccountCompanySetting.Get(AccountCompanySetting."Account Type"::Contact, "No.", CompanyName()) then begin
            AccountCompanySetting."Account Type" := AccountCompanySetting."Account Type"::Contact;
            AccountCompanySetting."Company Name" := (Copystr(Uppercase(CompanyName()), 1, 50));
            AccountCompanySetting."Account No." := "No.";
            AccountCompanySetting.Insert();
        end;
    end;

    var

    trigger OnAfterModify()
    begin
        IF "No." <> 'NEW' then
            SynchFunctions.SynchContactBatch("No.");
    end;

    trigger OnAfterInsert()
    begin
        IF "No." <> 'NEW' then
            SynchFunctions.SynchContactBatch("No.");

    end;

    // [IntegrationEvent(false, false)]
    // local procedure OnAfterCreateContact(var Contact: Record Contact; var xContact: Record Contact)
    // begin
    // end;

    var
        AccountCompanySetting: Record "POI Account Company Setting";
        POICompany: Record "POI Company";
        SynchFunctions: Codeunit "POI Account Synchronisation";
        POISynchFunction: Codeunit "POI Account Synchronisation";
    //NoPersonContactTxt: Label 'Nur Personenkontakte können asl Gruppenkontakte definiert werden';
}