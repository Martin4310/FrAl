codeunit 50022 "POI VAT Functions"
{
    local procedure LogUnloggedVATRegistrationNumbers()
    begin
        VendCustVATIDs.Reset();
        VendCustVATIDs.SetFilter("VAT Registration No.", '<>%1', '');
        if VendCustVATIDs.FindSet() then
            repeat
                VATRegistrationLog.SetRange("VAT Registration No.", VendCustVATIDs."VAT Registration No.");
                if VATRegistrationLog.IsEmpty then
                    LogVendCust(VendCustVATIDs."Vendor/Customer", VendCustVATIDs.Type, VendCustVATIDs."Country Code");
            until VendCustVATIDs.Next() = 0;

        // Customer.SetFilter("VAT Registration No.", '<>%1', '');
        // if Customer.FindSet() then
        //     repeat
        //         VATRegistrationLog.SetRange("VAT Registration No.", Customer."VAT Registration No.");
        //         if VATRegistrationLog.IsEmpty then
        //             LogCustomer(Customer);
        //     until Customer.Next() = 0;

        // Vendor.SetFilter("VAT Registration No.", '<>%1', '');
        // if Vendor.FindSet() then
        //     repeat
        //         VATRegistrationLog.SetRange("VAT Registration No.", Vendor."VAT Registration No.");
        //         if VATRegistrationLog.IsEmpty then
        //             LogVendor(Vendor);
        //     until Vendor.Next() = 0;

        // Contact.SetFilter("VAT Registration No.", '<>%1', '');
        // if Contact.FindSet() then
        //     repeat
        //         VATRegistrationLog.SetRange("VAT Registration No.", Contact."VAT Registration No.");
        //         if VATRegistrationLog.IsEmpty then
        //             LogContact(Contact);
        //     until Contact.Next() = 0;

        Commit();
    end;

    procedure LogCustomer(Customer: Record Customer)
    var
        CountryCode: Code[10];
    begin
        CountryCode := GetCountryCode(Customer."Country/Region Code");
        if not IsEUCountry(CountryCode) then
            exit;

        AssistEditCustomerVATReg(Customer);
    end;

    procedure LogVendor(Vendor: Record Vendor)
    var
        CountryCode: Code[10];
    begin
        CountryCode := GetCountryCode(Vendor."Country/Region Code");
        if not IsEUCountry(CountryCode) then
            exit;

        InsertVATRegistrationLog(
          Vendor."VAT Registration No.", CountryCode, VATRegistrationLog."Account Type"::Vendor, Vendor."No.");
    end;

    procedure LogContact(Contact: Record Contact)
    var
        CountryCode: Code[10];
    begin
        CountryCode := GetCountryCode(Contact."Country/Region Code");
        if not IsEUCountry(CountryCode) then
            exit;

        InsertVATRegistrationLog(
          Contact."VAT Registration No.", CountryCode, VATRegistrationLog."Account Type"::Contact, Contact."No.");
    end;

    procedure LogVendCust(AccountNo: code[20]; AccountType: Option; CountryCode: Code[10])
    begin
        CountryCode := GetCountryCode(CountryCode);
        if not IsEUCountry(CountryCode) then
            exit;
        case AccountType of
            1:
                begin
                    Customer.get(AccountNo);
                    AssistEditCustomerVATReg(Customer);
                end;
            2:
                begin
                    Vendor.Get(AccountNo);
                    InsertVATRegistrationLog(Vendor."VAT Registration No.", CountryCode, AccountType, Vendor."No.");
                end;
        end;
    end;

    local procedure InsertVATRegistrationLog(VATRegNo: Text[20]; CountryCode: Code[10]; AccountType: Option; AccountNo: Code[20])
    begin
        with VATRegistrationLog do begin
            Init();
            "VAT Registration No." := VATRegNo;
            "Country/Region Code" := CountryCode;
            "Account Type" := AccountType;
            "Account No." := AccountNo;
            "User ID" := copystr(UserId, 1, 50);
            Insert(true);
        end;
    end;

    local procedure IsEUCountry(CountryCode: Code[10]): Boolean
    var
        CountryRegion: Record "Country/Region";
        CompanyInformation: Record "Company Information";
    begin
        if (CountryCode = '') and CompanyInformation.Get() then
            CountryCode := CompanyInformation."Country/Region Code";

        if CountryCode <> '' then
            if CountryRegion.Get(CountryCode) then
                exit(CountryRegion."EU Country/Region Code" <> '');

        exit(false);
    end;

    local procedure GetCountryCode(CountryCode: Code[10]): Code[10]
    var
        CompanyInformation: Record "Company Information";
    begin
        if CountryCode <> '' then
            exit(CountryCode);

        CompanyInformation.Get();
        exit(CompanyInformation."Country/Region Code");
    end;


    procedure AssistEditCustomerVATReg(Customer: Record Customer)
    begin
        with VATRegistrationLog do begin
            SetRange("Account Type", "Account Type"::Customer);
            SetRange("Account No.", Customer."No.");
            if IsEmpty then
                LogUnloggedVATRegistrationNumbers();
            PAGE.RunModal(PAGE::"VAT Registration Log", VATRegistrationLog);
        end;
    end;

    procedure AssistEditVendorVATReg(Vendor: Record Vendor)
    begin
        with VATRegistrationLog do begin
            SetRange("Account Type", "Account Type"::Vendor);
            SetRange("Account No.", Vendor."No.");
            if IsEmpty then
                LogUnloggedVATRegistrationNumbers();
            PAGE.RunModal(PAGE::"VAT Registration Log", VATRegistrationLog);
        end;
    end;

    procedure ValidateVATRegNoWithVIES(var RecordRef: RecordRef; RecordVariant: Variant; EntryNo: Code[20]; AccountType: Option; CountryCode: Code[10])
    begin
        CheckVIESForVATNo(RecordRef, VATRegistrationLog, RecordVariant, EntryNo, CountryCode, AccountType);

        if VATRegistrationLog.Find() then // Only update if the log was created
            UpdateRecordFromVATRegLog(RecordRef, RecordVariant, VATRegistrationLog);
    end;

    procedure CheckVIESForVATNo(var RecordRef: RecordRef; var VATRegistrationLog: Record "VAT Registration Log"; RecordVariant: Variant; EntryNo: Code[20]; CountryCode: Code[10]; AccountType: Option)
    var
        VATRegNoSrvConfig: Record "VAT Reg. No. Srv Config";
        CountryRegion: Record "Country/Region";
        VatRegNoFieldRef: FieldRef;
        VATRegNo: Text[20];
    begin
        RecordRef.GetTable(RecordVariant);
        if not CountryRegion.IsEUCountry(CountryCode) then
            exit; // VAT Reg. check Srv. is only available for EU countries.

        if VATRegNoSrvConfig.VATRegNoSrvIsEnabled() then begin
            DataTypeManagement.GetRecordRef(RecordVariant, RecordRef);
            if not DataTypeManagement.FindFieldByName(RecordRef, VatRegNoFieldRef, Customer.FieldName("VAT Registration No.")) then
                exit;
            VATRegNo := VatRegNoFieldRef.Value;

            VATRegistrationLog.InitVATRegLog(VATRegistrationLog, CountryCode, AccountType, EntryNo, VATRegNo);
            CODEUNIT.Run(CODEUNIT::"VAT Lookup Ext. Data Hndl", VATRegistrationLog);
        end;
    end;

    procedure UpdateRecordFromVATRegLog(var RecordRef: RecordRef; RecordVariant: Variant; VATRegistrationLog: Record "VAT Registration Log")
    var
        ConfirmQst: Text;
    begin
        RecordRef.GetTable(RecordVariant);
        case VATRegistrationLog.Status of
            VATRegistrationLog.Status::Valid:
                begin
                    if HasAddress(VATRegistrationLog) then
                        ConfirmQst := ValidVATNoQst
                    else
                        ConfirmQst := ValidVATNoNoAddressQst;

                    if Confirm(ConfirmQst) then
                        PopulateFieldsFromVATRegLog(RecordRef, RecordVariant, VATRegistrationLog);
                end;
            VATRegistrationLog.Status::Invalid:
                Message(InvalidVatRegNoMsg);
            else
                Message(NotVerifiedVATRegMsg);
        end;
    end;

    local procedure HasAddress(VATRegistrationLog: Record "VAT Registration Log"): Boolean
    begin
        if (VATRegistrationLog."Verified Postcode" = '') and
           (VATRegistrationLog."Verified Street" = '') and
           (VATRegistrationLog."Verified City" = '')
        then
            exit(false);

        exit(true);
    end;

    local procedure PopulateFieldsFromVATRegLog(var RecordRef: RecordRef; RecordVariant: Variant; VATRegistrationLog: Record "VAT Registration Log")
    var
        FieldRef: FieldRef;
    begin
        DataTypeManagement.GetRecordRef(RecordVariant, RecordRef);

        if DataTypeManagement.FindFieldByName(RecordRef, FieldRef, Customer.FieldName(Name)) then
            FieldRef.Value(CopyStr(VATRegistrationLog."Verified Name", 1, FieldRef.Length));

        if VATRegistrationLog."Verified Postcode" <> '' then
            if DataTypeManagement.FindFieldByName(RecordRef, FieldRef, Customer.FieldName("Post Code")) then
                FieldRef.Value(CopyStr(VATRegistrationLog."Verified Postcode", 1, FieldRef.Length));

        if VATRegistrationLog."Verified Street" <> '' then
            if DataTypeManagement.FindFieldByName(RecordRef, FieldRef, Customer.FieldName(Address)) then
                FieldRef.Value(CopyStr(VATRegistrationLog."Verified Street", 1, FieldRef.Length));

        if VATRegistrationLog."Verified City" <> '' then
            if DataTypeManagement.FindFieldByName(RecordRef, FieldRef, Customer.FieldName(City)) then
                FieldRef.Value(CopyStr(VATRegistrationLog."Verified City", 1, FieldRef.Length));
    end;

    var

        Customer: Record Customer;
        Vendor: Record Vendor;
        //Contact: Record Contact;
        VendCustVATIDs: Record "POI VAT Registr. No. Vend/Cust";
        VATRegistrationLog: Record "VAT Registration Log";
        DataTypeManagement: Codeunit "Data Type Management";
        ValidVATNoQst: Label 'Die Umsatzsteuer-Identifikationsnummer ist gültig. Möchten Sie, dass wir den Namen und die Adresse aktualisieren?';
        ValidVATNoNoAddressQst: Label 'Die Umsatzsteuer-Identifikationsnummer ist gültig. Möchten Sie, dass wir den Namen aktualisieren?';
        InvalidVatRegNoMsg: Label 'Für diese Ust.-ID haben wir keine Übereinstimmung gefunden. Überprüfen Sie, ob Sie die richtige Ust.-ID eingegeben haben.';
        NotVerifiedVATRegMsg: Label 'Wir konnten die Umsatzsteuer-Identifikationsnummer nicht überprüfen. Versuchen Sie es später noch einmal.';
}