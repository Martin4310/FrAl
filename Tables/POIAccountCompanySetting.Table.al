table 50005 "POI Account Company Setting"
{
    DataPerCompany = false;
    DrillDownPageId = "POI Account Company Setting";
    LookupPageId = "POI Account Company Setting";

    fields
    {
        field(1; "Account Type"; Enum "POI VendorCustomer")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;

        }
        field(2; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Account Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor."No.";
        }
        field(3; "Company Name"; Text[50])
        {
            Caption = 'Mandant';
            DataClassification = CustomerContent;
            TableRelation = "POI Company".Mandant where(Visible = const(true));
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50005, 3, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(4; "Released"; Boolean)
        {
            caption = 'Released';
            DataClassification = CustomerContent;
        }
        field(5; "special approval"; Option)
        {
            Caption = 'special approval';
            DataClassification = CustomerContent;
            OptionMembers = ,rejected,approved;
            OptionCaption = ' ,rejected,approved';
        }
        field(6; Visible; Boolean)
        {
            Caption = 'Visible';
            DataClassification = CustomerContent;
        }
        field(7; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(8; "Block Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = " ",Payment,All;
            OptionCaption = ',Payment,All';
            DataClassification = CustomerContent;
        }
        field(20; "Credit Limit"; Decimal)
        {
            Caption = 'Kreditlimit';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50005, 20, 2) then
                    ERROR(ERR_NoPermissionTxt);
                if "Credit Limit" > 0 then
                    "Creditlimit requested" := true
                else
                    "Creditlimit requested" := false;
            end;
        }
        field(21; "Creditlimit requested"; Boolean)
        {
            Caption = 'Kreditlimit gewünscht';
            DataClassification = CustomerContent;
        }
        field(22; Refund; Decimal)
        {
            Caption = 'Rückvergütung';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 30;
            trigger OnValidate()
            begin
                if not POIFunction.CheckPermission(50005, 22, 2) then
                    ERROR(ERR_NoPermissionTxt);
            end;
        }
    }

    keys
    {
        key(Key1; "Account Type", "Account No.", "Company Name") { }
    }

    procedure OperationCompExists(AccountNo: Code[20]; AccountType: enum "POI VendorCustomer"): Boolean
    begin
        SetRange("Account No.", AccountNo);
        SetRange("Account Type", AccountType);
        SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
        exit(not IsEmpty());
    end;

    procedure BasicCompExists(AccountNo: Code[20]; AccountType: enum "POI VendorCustomer"): Boolean
    begin
        Reset();
        SetRange("Account No.", AccountNo);
        SetRange("Account Type", AccountType);
        SetFilter("Company Name", '%1', POICompany.GetBasicCompany());
        exit(not IsEmpty());
    end;

    procedure SetAccCompSetting(AccNo: Code[20]; AccountType: enum "POI VendorCustomer")
    var
        OptionEnum: enum "POI VendorCustomer";
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        IF POICompany.FindSet() then
            repeat
                ContBusRel.ChangeCompany(POICompany.Mandant);
                ContBusRel.Reset();
                case AccountType of
                    AccountType::Contact:
                        begin
                            Contact.ChangeCompany(POICompany.Mandant);
                            if Contact.Get(AccNo) then begin
                                Contact."POI Company System Filter" := POIFunction.SetAccCompSettingNames(AccNo, AccountType);
                                Contact.Modify();
                                //prüfen ob Cust oder Vendor und diesen auch noch ändern
                                ContBusRel.SetRange("Contact No.", AccNo);
                                if ContBusRel.FindSet() then
                                    repeat
                                        case ContBusRel."Link to Table" of
                                            ContBusRel."Link to Table"::Customer:
                                                if ContBusRel."Business Relation Code" = 'DEB' then begin
                                                    Customer.Get(ContBusRel."No.");
                                                    Customer."POI Company System Filter" := POIFunction.SetAccCompSettingNames(ContBusRel."No.", OptionEnum::Customer);
                                                    //löschen der Einträge für den Kunden
                                                    CompareAndCreateDeleteAccCompSetting(AccNo, AccountType, Customer."No.", OptionEnum::Customer);
                                                end;
                                            ContBusRel."Link to Table"::Vendor:
                                                if ContBusRel."Business Relation Code" = 'KRE' then begin
                                                    Vendor.Get(ContBusRel."No.");
                                                    Vendor."POI Company System Filter" := POIFunction.SetAccCompSettingNames(ContBusRel."No.", OptionEnum::Vendor);
                                                    //löschen der Einträge für den Kreditor
                                                    CompareAndCreateDeleteAccCompSetting(AccNo, AccountType, Vendor."No.", OptionEnum::Vendor);
                                                end;
                                        end;
                                    until ContBusRel.Next() = 0;
                            end;
                        end;
                    AccountType::Customer:
                        begin
                            Customer.ChangeCompany(POICompany.Mandant);
                            if Customer.Get(AccNo) then begin
                                Customer."POI Company System Filter" := POIFunction.SetAccCompSettingNames(AccNo, AccountType);
                                Customer.Modify();
                                //Contact auch ändern
                                ContBusRel.SetRange("No.", AccNo);
                                ContBusRel.SetRange("Business Relation Code", 'DEB');
                                if ContBusRel.FindSet() then begin
                                    Contact.Get(ContBusRel."Contact No.");
                                    Contact."POI Company System Filter" := POIFunction.SetAccCompSettingNames(ContBusRel."Contact No.", OptionEnum::Contact);
                                end;
                                //löschen der Einträge für den Kontakt - holen aus Customer
                                CompareAndCreateDeleteAccCompSetting(AccNo, AccountType, Contact."No.", OptionEnum::Contact);
                            end;
                        end;
                    AccountType::Vendor:
                        begin
                            Vendor.ChangeCompany(POICompany.Mandant);
                            if Vendor.Get(AccNo) then begin
                                Vendor."POI Company System Filter" := POIFunction.SetAccCompSettingNames(AccNo, AccountType);
                                Vendor.Modify();
                            end;
                            //Contact auch ändern
                            ContBusRel.SetRange("No.", AccNo);
                            ContBusRel.SetRange("Business Relation Code", 'KRE');
                            if ContBusRel.FindSet() then
                                if Contact.Get(ContBusRel."Contact No.") then
                                    Contact."POI Company System Filter" := POIFunction.SetAccCompSettingNames(ContBusRel."Contact No.", OptionEnum::Contact);
                            //löschen der Einträge für den Kontakt - holen aus Vendor
                            CompareAndCreateDeleteAccCompSetting(AccNo, AccountType, Contact."No.", OptionEnum::Contact);
                        end;
                end;
            until POICompany.Next() = 0;
    end;

    procedure CompareAndCreateDeleteAccCompSetting(FromAccNo: Code[20]; FromAccType: enum "POI VendorCustomer"; ToAccNo: Code[20]; ToAccType: enum "POI VendorCustomer")
    var

        ToAccCompSetting: Record "POI Account Company Setting";
    begin
        //delete old records
        ToAccCompSetting.SetRange("Account No.", ToAccNo);
        ToAccCompSetting.SetRange("Account Type", ToAccType);
        ToAccCompSetting.DeleteAll();
        //Search for Record of Source
        FromAccCompSetting.SetRange("Account No.", FromAccNo);
        FromAccCompSetting.SetRange("Account Type", FromAccType);
        if FromAccCompSetting.FindSet() then
            repeat
                //Copy of records from new to old
                ToAccCompSetting := FromAccCompSetting;
                ToAccCompSetting."Account Type" := ToAccType;
                ToAccCompSetting."Account No." := ToAccNo;
                ToAccCompSetting.Insert();
            until FromAccCompSetting.Next() = 0;
    end;

    procedure SetReleasedForAccount(AccNo: code[20]; AccountType: Option Contact,Customer,Vendor,Create)
    begin
        AccCompSetting.Reset();
        AccCompSetting.SetRange("Account No.", AccNo);
        AccCompSetting.SetRange("Account Type", AccountType);
        AccCompSetting.SetRange(Released, false);
        IF AccCompSetting.FindSet() then
            repeat
                AccCompSetting.Released := true;
                AccCompSetting.Modify();
            until AccCompSetting.Next() = 0;
    end;

    procedure GetCompanyNames(AccountType: enum "POI VendorCustomer"; AccountNo: Code[20]): Text[250]
    var
        Outtext: Text[250];
    begin
        Clear(Outtext);
        AccCompSetting.Reset();
        AccCompSetting.SetRange("Account Type", AccountType);
        AccCompSetting.SetRange("Account No.", AccountNo);
        if AccCompSetting.FindSet() then
            repeat
                if Outtext <> '' then
                    Outtext += '|';
                Outtext += AccCompSetting."Company Name";
            until AccCompSetting.Next() = 0;
        exit(Outtext);
    end;

    var
        Customer: Record Customer;
        Contact: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        Vendor: Record Vendor;
        POICompany: Record "POI Company";
        FromAccCompSetting: Record "POI Account Company Setting";
        AccCompSetting: Record "POI Account Company Setting";
        POIFunction: Codeunit POIFunction;
        ERR_NoPermissionTxt: label 'Keine Berechtigungen für Änderungen';
}