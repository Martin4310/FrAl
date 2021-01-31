table 50022 "POI VAT Registr. No. Vend/Cust"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Vendor/Customer"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor/Customer';
            TableRelation = if (Type = const(Customer)) Customer."No."
            else
            if (Type = const(Vendor)) Vendor."No.";
        }
        field(2; "Country Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Country Code';
        }
        field(3; "VAT Registration No."; Text[20])
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Registration No.';
            trigger OnValidate()
            var
                Vendor: Record Vendor;
                Customer: Record Customer;
                VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
                ResultRecordRef: RecordRef;
                ApplicableCountryCode: Code[10];
            begin
                case Type of
                    type::Customer:
                        begin
                            Customer.Get("Vendor/Customer");
                            if not VATRegistrationNoFormat.Test("VAT Registration No.", Customer."Country/Region Code", Customer."No.", DATABASE::Customer) then
                                exit;
                            VATFunctions.LogCustomer(Customer);
                            ApplicableCountryCode := "Country Code";
                            if ApplicableCountryCode = '' then
                                ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
                            if VATRegNoSrvConfig.VATRegNoSrvIsEnabled() then //begin
                                VATFunctions.ValidateVATRegNoWithVIES(ResultRecordRef, Rec, Customer."No.", VATRegistrationLog."Account Type"::Customer, ApplicableCountryCode);
                            //ResultRecordRef.SetTable(Rec);
                            //end;
                        end;
                    type::Vendor:
                        begin
                            Vendor.Get("Vendor/Customer");
                            if not VATRegistrationNoFormat.Test("VAT Registration No.", Vendor."Country/Region Code", Vendor."No.", DATABASE::Vendor) then
                                exit;
                            VATFunctions.LogVendor(Vendor);
                            ApplicableCountryCode := "Country Code";
                            if ApplicableCountryCode = '' then
                                ApplicableCountryCode := VATRegistrationNoFormat."Country/Region Code";
                            if VATRegNoSrvConfig.VATRegNoSrvIsEnabled() then //begin
                                VATFunctions.ValidateVATRegNoWithVIES(ResultRecordRef, Rec, Vendor."No.", VATRegistrationLog."Account Type"::Vendor, ApplicableCountryCode);
                            //ResultRecordRef.SetTable(Rec);
                            //end;
                        end;
                end;
            end;
        }
        field(4; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(5; "Name 2"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name 2';
        }
        field(6; Address; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Address';
        }
        field(7; "Address 2"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Address 2';
        }
        field(8; City; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'City';
        }
        field(9; "Post Code"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Post Code';
        }
        field(10; "primary"; Boolean)
        {
            Caption = 'primary';
            DataClassification = CustomerContent;
        }
        field(11; "Type"; Option)
        {
            OptionMembers = ,Customer,Vendor;
            OptionCaption = ' ,Customer,Vendor';
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(12; "Registration Typ"; Option)
        {
            OptionMembers = no,dircet,fiscal;
            OptionCaption = 'no,direct,fiscal';
            Caption = 'Registration Typ';
            DataClassification = CustomerContent;
        }
        field(13; "VAT Detection"; Boolean)
        {
            Caption = 'VAT Detection';
            DataClassification = CustomerContent;
        }
        field(14; "Request Url"; Text[250])
        {
            Caption = 'Request Url';
            DataClassification = CustomerContent;
        }
        field(15; "User created"; Code[50])
        {
            Caption = 'User created';
            DataClassification = CustomerContent;
        }
        field(16; "Date created"; Date)
        {
            Caption = 'Date created';
            DataClassification = CustomerContent;
        }
        field(17; "Time created"; Time)
        {
            Caption = 'Time created';
            DataClassification = CustomerContent;
        }
        field(18; "Xml Response"; Blob)
        {
            Caption = 'Xml Response';
            DataClassification = CustomerContent;
        }
        field(19; "Reg. No. valid"; Boolean)
        {
            Caption = 'Reg. No. valid';
            DataClassification = CustomerContent;
        }
        field(20; "Name valid"; Boolean)
        {
            Caption = 'Name valid';
            DataClassification = CustomerContent;
        }
        field(21; "City valid"; Boolean)
        {
            Caption = 'City valid';
            DataClassification = CustomerContent;
        }
        field(22; "Status Code"; Code[10])
        {
            Caption = 'Status Code';
            DataClassification = CustomerContent;
        }
        field(23; "Status Text"; Text[250])
        {
            Caption = 'Status Text';
            DataClassification = CustomerContent;
        }
        field(24; "Service Error"; Boolean)
        {
            Caption = 'Service Error';
            DataClassification = CustomerContent;
        }
        field(25; "Post Code valid"; Boolean)
        {
            Caption = 'Post Code valid';
            DataClassification = CustomerContent;
        }
        field(26; "Address valid"; Boolean)
        {
            Caption = 'Address valid';
            DataClassification = CustomerContent;
        }
        field(27; "User Last Change"; Code[50])
        {
            Caption = 'User created';
            DataClassification = CustomerContent;
        }
        field(28; "Date Last Change"; Date)
        {
            Caption = 'Date created';
            DataClassification = CustomerContent;
        }
        field(29; "Time Last Change"; Time)
        {
            Caption = 'Time created';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "Vendor/Customer", Type, "VAT Registration No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
    begin

        case Type of
            type::Customer:
                begin
                    Customer.Get("Vendor/Customer");
                    VATRegistrationLogMgt.AssistEditCustomerVATReg(Customer);
                    Name := Customer.Name;
                    "Name 2" := Customer."Name 2";
                    Address := Customer.Address;
                    "Address 2" := Customer."Address 2";
                    "Country Code" := Customer."Country/Region Code";
                    City := Customer.City;
                    "Post Code" := Customer."Post Code";
                end;
            type::Vendor:
                begin
                    Vendor.Get("Vendor/Customer");
                    VATRegistrationLogMgt.AssistEditVendorVATReg(Vendor);
                    Name := Vendor.Name;
                    "Name 2" := Vendor."Name 2";
                    Address := Vendor.Address;
                    "Address 2" := Vendor."Address 2";
                    "Country Code" := Vendor."Country/Region Code";
                    City := Vendor.City;
                    "Post Code" := Vendor."Post Code";
                    "Country Code" := "Country Code";
                end;
        end;
        if CopyStr("VAT Registration No.", 1, 2) <> 'EL' then
            "Country Code" := CopyStr("VAT Registration No.", 1, 2)
        else
            "Country Code" := 'GR';
        SetChange();
        "Date created" := Today();
        "Time created" := Time();
        "User created" := CopyStr(UserId(), 1, 50);
    end;

    trigger OnModify()
    begin
        SetChange();
    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin
        SetChange();
    end;

    procedure SetChange()
    begin
        "Date Last Change" := Today();
        "Time Last Change" := Time();
        "User Last Change" := Copystr(Userid(), 1, 50);
    end;

    procedure GetAllVatIdsToText(AccountNo: Code[20]; AccountType: enum "POI VendorCustomer")
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        OutText: Text[100];
    begin
        Clear(OutText);
        Reset();
        SetRange(Type, AccountType);
        SetRange("Vendor/Customer", AccountNo);
        if FindSet() then
            repeat
                if OutText <> '' then
                    OutText += ';';
                if StrLen(Outtext + "VAT Registration No.") <= MaxStrLen(OutText) then
                    Outtext += "VAT Registration No.";
            until Next() = 0;
        case AccountType of
            AccountType::Vendor:
                Begin
                    Vendor.get(AccountNo);
                    Vendor.POIVATRegistrationNos := OutText;
                    Vendor.Modify();
                End;
            AccountType::Customer:
                begin
                    Customer.get(AccountNo);
                    Customer.POIVATRegistrationNos := OutText;
                    Customer.Modify();
                end;
        end;

    end;

    var

        VATRegistrationNoFormat: Record "VAT Registration No. Format";
        VATRegistrationLog: Record "VAT Registration Log";

        VATFunctions: Codeunit "POI VAT Functions";
}