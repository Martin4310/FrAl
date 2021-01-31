codeunit 50001 POIFunction
{
    procedure CheckMandantoryFields(lContact: Record Contact): Text[500]
    //Check mandantory fields with Error Message
    var
        txt_VendCust: Text[30];
        txt_Anrede: Text[30];
        txt_Name: Text[30];
        txt_Adresse: Text[30];
        txt_Land: Text[30];
        txt_Sprache: Text[30];
        txt_Tel: Text[30];
        txt_Kreditortyp: Text[30];
        txt_City: Text[30];
        txt_PostCode: Text[30];
        txt_Salesperson: Text[30];
        ERR_TestfieldComp: Text[500];

    begin
        Clear(ERR_TestfieldComp);
        with lcontact do
            IF (COMPANYNAME() = 'StammdatenPort') AND (Type = Type::Company) then begin
                IF ("POI VendororCustomer" <> "POI VendororCustomer"::Customer) and ("POI VendororCustomer" <> "POI VendororCustomer"::Vendor) then
                    txt_VendCust := 'Kreditor oder Debitor /';
                IF "Salutation Code" = '' then
                    txt_Anrede := 'Anrede /';
                IF Name = '' then
                    txt_Name := 'Name /';
                IF Address = '' then
                    txt_Adresse := 'Adresse /';
                if City = '' then
                    txt_City := 'Ort /';
                if "Post Code" = '' then
                    txt_PostCode := 'PLZ /';
                if "Salesperson Code" = '' then
                    txt_Salesperson := 'Einkäfer/Verkäufer /';
                IF "Country/Region Code" = '' then
                    txt_Land := 'Land /';
                IF "Language Code" = '' then
                    txt_Sprache := 'Sprache /';
                IF "Phone No." = '' then
                    txt_Tel := 'Telefonnr. /';
                IF NOT ("POI Supplier of Goods") AND NOT ("POI Carrier") AND NOT ("POI Warehouse Keeper") AND NOT ("POI Customs Agent") AND NOT ("POI Tax Representative") AND NOT ("POI Diverse Vendor")
                 AND NOT ("POI Small Vendor") AND NOT ("POI Shipping Company") AND ("POI VendororCustomer" = "POI VendororCustomer"::Vendor) then
                    txt_Kreditortyp := 'Kreditorentyp';
                IF (txt_VendCust <> '') OR (txt_Anrede <> '') OR (txt_Name <> '') OR (txt_Adresse <> '') OR (txt_Land <> '') OR (txt_Sprache <> '') OR (txt_Tel <> '') OR (txt_Kreditortyp <> '') then
                    ERR_TestfieldComp := txt_VendCust + txt_Anrede + txt_Name + txt_Adresse + txt_Land + txt_Sprache + txt_Tel + txt_Kreditortyp + txt_City + txt_PostCode + txt_Salesperson;
            end;
        exit(ERR_TestfieldComp);
    end;

    //Doppelte Funktion
    // procedure SynchVendorCustomer(AccountNo: code[20]; AccountType: enum VendorCustomer)
    // //Function to synchronize Customer or vendor to all synch Companies
    // var
    //     lCustomer: Record Customer;
    //     lVendor: Record Vendor;

    // begin
    //     case AccountType of
    //         AccountType::Vendor:
    //             begin
    //                 lVendor.Get(AccountNo);
    //                 IF (lVendor."Is Customer" <> lVendor."No.") AND (lVendor."Is Customer" <> '') then begin
    //                     lCustomer.Get(lVendor."Is Customer");
    //                     lCustomer.Name := lVendor.Name;
    //                     lCustomer."Name 2" := lVendor."Name 2";
    //                     lCustomer.Address := lVendor.Address;
    //                     lCustomer."Address 2" := lVendor."Address 2";
    //                     lCustomer.City := lVendor.City;
    //                     lCustomer."Post Code" := lVendor."Post Code";
    //                     lCustomer."E-Mail" := lVendor."E-Mail";
    //                     lCustomer."Phone No." := lVendor."Phone No.";
    //                     lCustomer."VAT Registration No." := lVendor."VAT Registration No.";
    //                     lCustomer."Language Code" := lVendor."Language Code";
    //                     lCustomer."Country/Region Code" := lVendor."Country/Region Code";
    //                     lCustomer.Modify();
    //                 end;
    //             end;
    //         AccountType::Customer:
    //             begin
    //                 lCustomer.Get(AccountNo);
    //                 IF (lCustomer."Is Vendor" <> lCustomer."No.") AND (lCustomer."Is Vendor" <> '') then begin
    //                     lVendor.Get(lCustomer."Is Vendor");
    //                     lVendor.Name := lCustomer.Name;
    //                     lVendor."Name 2" := lCustomer."Name 2";
    //                     lVendor.Address := lCustomer.Address;
    //                     lVendor."Address 2" := lCustomer."Address 2";
    //                     lVendor.City := lCustomer.City;
    //                     lVendor."Post Code" := lCustomer."Post Code";
    //                     lVendor."E-Mail" := lCustomer."E-Mail";
    //                     lVendor."Phone No." := lCustomer."Phone No.";
    //                     lVendor."VAT Registration No." := lCustomer."VAT Registration No.";
    //                     lVendor."Language Code" := lCustomer."Language Code";
    //                     lVendor."Country/Region Code" := lCustomer."Country/Region Code";
    //                     lVendor.Modify();
    //                 end;
    //             end;
    //     end;
    // end;

    procedure SynchVendorToAllCompany(VendorNo: Code[20])
    //Transfer Vendor to all Synch Companies
    var
        LocalVendor: Record Vendor;

    begin
        LocalVendor.Get(VendorNo);
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                Vendor.ChangeCompany(POICompany.Mandant);
                IF Vendor.Get(VendorNo) then begin
                    Vendor.TransferFields(LocalVendor);
                    Vendor.Modify();
                end;
            until POICompany.Next() = 0;
    end;

    procedure SynchCustomerToAllCompany(CustomerNo: Code[20])
    //Transfer Customer to all Synch Companies
    var
        LocalCustomer: Record Customer;

    begin
        LocalCustomer.Get(CustomerNo);
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                Customer.ChangeCompany(POICompany.Mandant);
                IF Customer.Get(CustomerNo) then begin
                    Customer.TransferFields(LocalCustomer);
                    Customer.Modify();
                end;
            until POICompany.Next() = 0;
    end;

    procedure CheckEMailForContacts(EMail: Text[100]): Boolean
    //Check if E-Mail filled for Contact
    begin
        Contact.Reset();
        Contact.SetCurrentKey("E-Mail");
        Contact.SetRange("E-Mail", EMail);
        exit(not Contact.IsEmpty());
    end;

    procedure CheckEMailForVendor(EMail: Text[100]): Boolean
    //Check if is E-Mail filled for Vendor
    begin
        Vendor.Reset();
        Vendor.SetCurrentKey("E-Mail");
        Vendor.SetRange("E-Mail", EMail);
        exit(not Vendor.IsEmpty());
    end;

    procedure CheckEMailForCustomer(EMail: Text[100]): Boolean
    //Check if is E-Mail filled for Customer
    begin
        Customer.Reset();
        Customer.SetCurrentKey("E-Mail");
        Customer.SetRange("E-Mail", EMail);
        exit(NOT Customer.IsEmpty());
    end;

    procedure CheckUserInRole(Role: code[250]; ReturnType: Option Error,Message): Boolean
    var
        //UserRole: Record "User Group";
        NoPermissionTxt: Label 'You do not have authorisation to execute the change.';

    begin
        if UserInWindowsRole(Role) then
            exit(true);

        // UserRole.INIT();
        // if UserRole.GET(Role) then;

        case ReturnType of
            ReturnType::Error:
                ERROR(NoPermissionTxt);
            ReturnType::Message:
                MESSAGE(NoPermissionTxt);
        end;
        exit(false);
    end;

    procedure UserInWindowsRole(RoleFilter: Code[250]): Boolean
    //check if user is in this Role
    var
        User: Record User;
        UserGroupMember: Record "User Group Member";

    begin
        if not User.Get(UserSecurityId()) or (User.State = User.State::Disabled) then
            EXIT(false);

        UserGroupMember.RESET();
        UserGroupMember.SetFilter("User Group Code", RoleFilter);
        UserGroupMember.SetFilter("Company Name", '%1 | %2', COMPANYNAME(), '');
        UserGroupMember.SetRange("User Security ID", User."User Security ID");
        exit(not UserGroupMember.IsEmpty());
    end;

    procedure CompanyInAccSetDivForContact(ContactNo: Code[20]): Boolean
    //Check if diverse is set to Contact
    begin
        POICompany.SetRange(Diverse, true);
        IF POICompany.FindFirst() then begin
            AccountCompanySetting.SetRange("Account No.", ContactNo);
            AccountCompanySetting.SetRange("Account Type", AccountCompanySetting."Account Type"::Contact);
            AccountCompanySetting.SetRange("Company Name", POICompany.Mandant);
            AccountCompanySetting.SetRange(Released, true);
            exit(not AccountCompanySetting.IsEmpty());
        end;
    end;

    procedure CheckPermission(PermTableID: Integer; PermFieldID: Integer; PermissionType: Option Read,Write): Boolean
    //Check of Field Permissions (Table, Field, Permission Type)
    var
        UserGroupMember: Record "User Group Member";
        User: Record User;
        PermFound: Boolean;
    begin
        if not (User.Get(UserSecurityId()) and (User.State = User.State::Enabled)) then
            EXIT(false);
        if CheckPermissionSuper() then
            exit(true);
        PermFound := false;
        FieldSecurity.Reset();
        FieldSecurity.SetRange(TableID, PermTableID);
        FieldSecurity.SetRange(FieldID, PermFieldID);
        FieldSecurity.SetRange(Accesstype, PermissionType);
        IF FieldSecurity.FindSet() then
            repeat
                UserGroupMember.setrange("User Security ID", UserSecurityId());
                UserGroupMember.SetRange("User Group Code", FieldSecurity."User Group");
                IF not UserGroupMember.IsEmpty() then
                    PermFound := true;
            until (FieldSecurity.Next() = 0) OR PermFound;
        exit(PermFound);
    end;

    procedure GetBasicCompany(): Code[50]
    //Ermitteln welches die Stammdaten Company ist
    begin
        POICompany.SetRange("Basic Company", true);
        if POICompany.FindFirst() then
            exit(POICompany.Mandant);
    end;

    procedure SynchIsCustIsVendor(AccountType: enum "POI VendorCustomer"; VendAccountNo: Code[20]; CustAccountNo: Code[20])
    //Synchronisieren eines Debitoren mit einem Kreditoren
    begin
        Customer.Get(CustAccountNo);
        Vendor.Get(VendAccountNo);
        case AccountType of
            AccountType::Customer:
                begin
                    Vendor.Name := Customer.Name;
                    Vendor."Name 2" := Customer."Name 2";
                    Vendor.Address := Customer.Address;
                    Vendor."Address 2" := Customer."Address 2";
                    Vendor.City := Customer.City;
                    Vendor."Phone No." := Customer."Phone No.";
                    Vendor."Country/Region Code" := Customer."Country/Region Code";
                    Vendor."E-Mail" := Customer."E-Mail";
                    Vendor."Post Code" := Customer."Post Code";
                    Vendor."VAT Registration No." := Customer."VAT Registration No.";
                    Vendor."Language Code" := Customer."Language Code";
                    Vendor."Currency Code" := Customer."Currency Code";
                    Vendor.Modify()
                end;
            AccountType::Vendor:
                begin
                    Customer.Name := Vendor.Name;
                    Customer."Name 2" := Vendor."Name 2";
                    Customer.Address := Vendor.Address;
                    Customer."Address 2" := Vendor."Address 2";
                    Customer.City := Vendor.City;
                    Customer."Phone No." := Vendor."Phone No.";
                    Customer."Country/Region Code" := Vendor."Country/Region Code";
                    Customer."E-Mail" := Vendor."E-Mail";
                    Customer."Post Code" := Vendor."Post Code";
                    Customer."VAT Registration No." := Vendor."VAT Registration No.";
                    Customer."Language Code" := Vendor."Language Code";
                    Customer."Currency Code" := Vendor."Currency Code";
                    Customer.Modify();
                end;
        end;
    end;

    procedure SetAccountCompanySettingForCompany()
    //Testfunktion zum setzen aller Debitoren und Kreditoren auf die aktuelle Company
    var

        Factor: Decimal;
        Counter: Decimal;
        Text000Txt: Label 'Accounts werden geprüft. Bitte warten!\\#1######### #2######## #3######', Comment = '#1 #2 #3 ';
        Text002: Text[20];
        FactorValue: Decimal;
        AccNo: Code[20];

    begin
        Text002 := 'Customer';
        POIDialog.Open(Text000Txt, Text002, AccNo, FactorValue);
        POIDialog.UPDATE();
        IF Customer.COUNT() > 0 THEN Factor := 100 / Customer.COUNT();
        Counter := 0;
        if Customer.FindFirst() then
            repeat
                Counter += 1;
                AccNo := Customer."No.";
                FactorValue := (Counter * Factor) DIV 1;
                POIDialog.Update();
                if not AccountCompanySetting.get(AccountCompanySetting."Account Type"::Customer, Customer."No.", CopyStr(CompanyName(), 1, 50)) then begin
                    AccountCompanySetting.Init();
                    AccountCompanySetting."Account Type" := AccountCompanySetting."Account Type"::Customer;
                    AccountCompanySetting."Account No." := Customer."No.";
                    AccountCompanySetting."Company Name" := CopyStr(CompanyName(), 1, 50);
                    AccountCompanySetting.Insert();
                end;
            until Customer.Next() = 0;
        IF Vendor.COUNT() > 0 THEN Factor := 100 / Vendor.COUNT();
        Counter := 0;
        Text002 := 'Vendor';
        if Vendor.FindFirst() then
            repeat
                Counter += 1;
                AccNo := Vendor."No.";
                FactorValue := (Counter * Factor) DIV 1;
                POIDialog.UPDATE();
                if not AccountCompanySetting.Get(AccountCompanySetting."Account Type"::Vendor, Vendor."No.", CopyStr(CompanyName(), 1, 50)) then begin
                    AccountCompanySetting."Account Type" := AccountCompanySetting."Account Type"::Vendor;
                    AccountCompanySetting."Account No." := Vendor."No.";
                    AccountCompanySetting."Company Name" := CopyStr(CompanyName(), 1, 50);
                    AccountCompanySetting.Insert();
                end;
            until Vendor.Next() = 0;
        POIDialog.Close();
    end;

    procedure SetAccCompSettingFilter()
    //Setzen aller Companyfilter für alle Debitoren, Krediotoren und Kontakte
    var
        FilterText: Text[50];

    begin
        if Customer.FindFirst() then
            repeat
                clear(FilterText);
                AccCompSetting.SetRange("Account No.", Customer."No.");
                AccCompSetting.SetRange("Account Type", AccCompSetting."Account Type"::Customer);
                if AccCompSetting.FindSet() then
                    repeat
                        if POICompany.Get(AccCompSetting."Company Name") then begin
                            if FilterText <> '' then FilterText += '|';
                            FilterText += POICompany."Company System ID";
                        end;
                    until AccCompSetting.Next() = 0;
                Customer."POI Company System Filter" := FilterText;
                Customer.Modify();
            until Customer.Next() = 0;
        if Vendor.FindFirst() then
            repeat
                clear(FilterText);
                AccCompSetting.SetRange("Account No.", Vendor."No.");
                AccCompSetting.SetRange("Account Type", AccCompSetting."Account Type"::Vendor);
                if AccCompSetting.FindSet() then
                    repeat
                        if POICompany.Get(AccCompSetting."Company Name") then begin
                            if FilterText <> '' then FilterText += '|';
                            FilterText += POICompany."Company System ID";
                        end;
                    until AccCompSetting.Next() = 0;
                Vendor."POI Company System Filter" := FilterText;
                Vendor.Modify();
            until Vendor.Next() = 0;
        if Contact.FindFirst() then
            repeat
                clear(FilterText);
                AccCompSetting.SetRange("Account No.", Contact."No.");
                AccCompSetting.SetRange("Account Type", AccCompSetting."Account Type"::Contact);
                if AccCompSetting.FindSet() then
                    repeat
                        if POICompany.Get(AccCompSetting."Company Name") then begin
                            if FilterText <> '' then FilterText += '|';
                            FilterText += POICompany."Company System ID";
                        end;
                    until AccCompSetting.Next() = 0;
                Contact."POI Company System Filter" := FilterText;
                Contact.Modify();
            until Contact.Next() = 0;
    end;

    procedure SetAccCompSettingNames(AccNo: Code[20]; AccType: enum "POI VendorCustomer"): Text[50]
    //Rückgabe des Accountsetting Filters für ein Konto (Debitor, Kreditor, Kontakt)
    var
        FilterText: Text[50];
    begin
        AccCompSetting.Reset();
        AccCompSetting.SetRange("Account Type", AccType);
        AccCompSetting.SetRange("Account No.", AccNo);
        //AccCompSetting.SetRange(Visible, true);
        //AccCompSetting.SetRange(Released, true);
        if AccCompSetting.FindSet() then
            repeat
                if POICompany.Get(AccCompSetting."Company Name") then begin
                    if FilterText <> '' then FilterText += '|';
                    FilterText += POICompany."Company System ID";
                end;
            until AccCompSetting.Next() = 0;
        exit(FilterText);
    end;

    procedure CreateAccSettingFromBasicCompanyOld()
    //Setzen der AccountCompanySettings aus der AccountSettingHelper Zwischentabelle
    var
        AccountSettinghelper: Record "POI Account setting Helper";
    begin
        AccountCompanySetting.Reset();
        AccountCompanySetting.SetRange("Account Type", AccountCompanySetting."Account Type"::Vendor);
        AccountSettinghelper.Reset();
        if AccountSettinghelper.FindFirst() then
            repeat
                AccountCompanySetting.SetRange("Account No.", AccountSettinghelper.AccountNo);
                //AccountCompanySetting.SetRange("Account Type", AccountSettinghelper."Account Type");
                if AccountSettinghelper."PI Bananas" AND POICompany.Get('PI BANANAS GMBH') then begin
                    AccountCompanySetting.SetRange("Company Name", 'PI BANANAS GMBH');
                    if not AccountCompanySetting.FindFirst() then
                        SetAccountCompanySetting(AccountSettinghelper.AccountNo, 'PI BANANAS GMBH', AccountSettinghelper."Account Type");
                end;
                if AccountSettinghelper."PI Dutch Growers" AND POICompany.Get('PI Dutch Growers GmbH') then begin
                    AccountCompanySetting.SetRange("Company Name", 'PI Dutch Growers GmbH');
                    if not AccountCompanySetting.FindFirst() then
                        SetAccountCompanySetting(AccountSettinghelper.AccountNo, 'PI Dutch Growers GmbH', AccountSettinghelper."Account Type");
                end;
                if AccountSettinghelper."PI European Sourcing" AND POICompany.Get('PI EUROPEAN SOURCING GMBH') then begin
                    AccountCompanySetting.SetRange("Company Name", 'PI EUROPEAN SOURCING GMBH');
                    if not AccountCompanySetting.FindFirst() then
                        SetAccountCompanySetting(AccountSettinghelper.AccountNo, 'PI EUROPEAN SOURCING GMBH', AccountSettinghelper."Account Type");
                end;
                if AccountSettinghelper."PI Fruit" AND POICompany.Get('PI FRUIT GMBH') then begin
                    AccountCompanySetting.SetRange("Company Name", 'PI FRUIT GMBH');
                    if not AccountCompanySetting.FindFirst() then
                        SetAccountCompanySetting(AccountSettinghelper.AccountNo, 'PI FRUIT GMBH', AccountSettinghelper."Account Type");
                end;
                if AccountSettinghelper."PI Organics" AND POICompany.Get('PI ORGANICS GMBH') then begin
                    AccountCompanySetting.SetRange("Company Name", 'PI ORGANICS GMBH');
                    if not AccountCompanySetting.FindFirst() then
                        SetAccountCompanySetting(AccountSettinghelper.AccountNo, 'PI ORGANICS GMBH', AccountSettinghelper."Account Type");
                end;
                if AccountSettinghelper."PI GmbH" AND POICompany.Get('PORT INTERNATIONAL GMBH') then begin
                    AccountCompanySetting.SetRange("Company Name", 'PORT INTERNATIONAL GMBH');
                    if not AccountCompanySetting.FindFirst() then
                        SetAccountCompanySetting(AccountSettinghelper.AccountNo, 'PORT INTERNATIONAL GMBH', AccountSettinghelper."Account Type");
                end;
                //Immer der Stammmandant
                if not AccountCompanySetting.Get(AccountSettinghelper."Account Type", AccountSettinghelper.AccountNo, 'STAMMDATENPORT') then
                    SetAccountCompanySetting(AccountSettinghelper.AccountNo, 'STAMMDATENPORT', AccountCompanySetting."Account Type"::Vendor);
            until AccountSettinghelper.Next() = 0;
    end;

    procedure SetAccountCompanySetting(AccNo: Code[20]; CompName: Text[50]; AccTyp: Enum "POI VendorCustomer")
    //Setzen einer Einrichtung für einen Account für eine bestimmte Company
    begin
        if not AccountCompanySetting.Get(AccTyp, AccNo, CompName) then
            if POICompany.Get(Uppercase(CompName)) then begin
                AccountCompanySetting."Company Name" := CompName;
                AccountCompanySetting."Account Type" := AccountCompanySetting."Account Type"::Vendor;
                AccountCompanySetting."Account No." := AccNo;
                AccountCompanySetting.Released := true;
                AccountCompanySetting.Visible := POICompany.Visible;
                AccountCompanySetting.Insert();
            end;
    end;

    procedure GetDocumentNameFromAttachmentSetup(GroupCode: Code[20]; DocType: code[10]; DocNo: Code[20]; LanguageCode: Code[10]): Text[250]
    //Holen eines dateinamens bzw. Pfades aus der Tabelle Attachment Setup
    var
        AttachmentSetup: Record "POI Attachement Setup";
    begin
        Case TRUE of
            LanguageCode = '':
                LanguageCode := 'DEU';
            not (LanguageCode IN ['DEU', 'ENU', 'ESP']):
                LanguageCode := 'ENU';
        end;
        IF AttachmentSetup.Get(GroupCode, DocType, DocNo, LanguageCode) then
            IF NOT EXISTS(AttachmentSetup.Path) THEN
                ERROR(DocumentNotFoundTxt, AttachmentSetup.Path)
            else
                exit(AttachmentSetup.Path)
        else
            ERROR(SettingNoExistTxt);
        exit('');
    end;

    procedure GetTranslation(TableNo: Integer; DocCode: Code[20]; DocCode2: Code[20]; language: Code[10]): Text[250]
    //Holen einer Übersetzung aus der translationtabelle
    var
        POITranslation: Record "POI Translations";
    begin
        case true of
            language = '':
                language := 'DEU';
            not (language in ['DEU', 'ENU', 'ESP', 'PTG']):
                language := 'ENU';
        end;
        IF POITranslation.Get(TableNo, DocCode, DocCode2, language) then
            exit(CopyStr(POITranslation.Description, 1, 250))
        else
            exit('');
    end;

    procedure CheckCompForAccount(AccNo: Code[20]; AccountType: Option Vendor,Customer,Contact; CompName: Code[50]): Boolean
    //Prüfen ob es für den Kunden die Zulassung für dien Mandanten gibt
    begin
        IF AccountCompanySetting.Get(AccountType, AccNo, CompName) AND AccountCompanySetting.Released then
            exit(true)
        else
            exit(false);
    end;


    procedure GetFilename(FileName: text[250]): Text[250]
    begin
        while STRPOS(FileName, '\') > 0 do
            FileName := COPYSTR(FileName, STRPOS(FileName, '\') + 1, 250);
        exit(FileName);
    end;

    procedure GetFilePath(FileName: text[250]): Text[250]
    var
        Filepath: Text[250];
    begin
        while STRPOS(FileName, '\') > 0 do begin
            Filepath := Filepath + CopyStr(FileName, 1, StrPos(FileName, '\'));
            FileName := COPYSTR(FileName, STRPOS(FileName, '\') + 1, 250);
        end;
        exit(Filepath);
    end;

    procedure CopyIsCustomerVendor(AccountNo: code[20]; AccountType: Option Customer,Vendor; Newtype: Integer): Code[20];
    var
        CustomerComp: Record Customer;
        ContactComp: Record Contact;
        VendorComp: Record Vendor;
        NoSerMgmt: Codeunit NoSeriesManagement;
        MailSender: Text[100];
        MailReceiver: list of [Text];
        MailSubject: Text;
        MailBody: Text;
        CompanynamePOI: Text[50];
        NewContactNo: Code[20];
        ResultCode: Code[20];
        NoContactTxt: label 'Keinen Unternehmenskontakt gefunden.';
    begin
        ContactBusRel.SetRange("No.", AccountNo);
        //Contact No. holen
        CompanynamePOI := POICompany.GetBasicCompany();
        //Mandant wechseln für Nummernserie
        NoSeriesLine.ChangeCompany(CompanynamePOI);
        MarketingSetup.ChangeCompany(CompanynamePOI);
        MarketingSetup.Get();
        NoSeriesLine.Reset();
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
        NewContactNo := NoSeriesLine."Last No. Used";
        Contact.ChangeCompany(CompanynamePOI);
        case AccountType of
            Accounttype::Customer:
                begin
                    Vendor.Get(AccountNo);
                    //Customer create
                    SalesSetup.ChangeCompany(CompanynamePOI);
                    SalesSetup.Get();
                    Customer.ChangeCompany(CompanynamePOI);
                    NoSeriesLine.ChangeCompany(CompanynamePOI);
                    NoSeriesLine.Reset();
                    NoSeriesLine.SetRange("Series Code", SalesSetup."Customer Nos.");
                    if NoSeriesLine.FindFirst() then begin
                        IF NoSeriesLine."Last No. Used" = '' then
                            NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No."
                        else
                            IF NoSeriesLine."Increment-by No." <= 1 THEN
                                NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
                            ELSE
                                NoSerMgmt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
                        NoSeriesLine.Modify();
                        Customer.Init();
                        case Newtype of
                            1:
                                Customer."POI Goods Customer" := true;
                            2:
                                Customer."POI Service Customer" := true;
                        end;
                        Customer."No." := NoSeriesLine."Last No. Used";
                        Customer.Name := Vendor.Name;
                        Customer."Name 2" := Vendor."Name 2";
                        Customer.Address := Vendor.Address;
                        Customer."Address 2" := Vendor."Address 2";
                        Customer.City := Vendor.City;
                        Customer."Post Code" := Vendor."Post Code";
                        Customer."Country/Region Code" := Vendor."Country/Region Code";
                        Customer."POI Registration No." := Vendor."Registration No.";
                        Customer."POI Amtsgericht" := Vendor."POI Amtsgericht";
                        Customer."POI County Court" := Vendor."POI County Court";
                        Customer."POI Commercial Register No." := Vendor."POI Commercial Register No.";
                        Customer."E-Mail" := Vendor."E-Mail";
                        Customer."POI Is Vendor" := Vendor."No.";
                        Customer."Phone No." := Vendor."Phone No.";
                        Customer."Fax No." := Vendor."Fax No.";
                        Customer."Home Page" := Vendor."Home Page";
                        Customer."Language Code" := Vendor."Language Code";
                        Customer."VAT Bus. Posting Group" := Vendor."VAT Bus. Posting Group";
                        Customer."Gen. Bus. Posting Group" := Vendor."Gen. Bus. Posting Group";
                        Customer."Customer Posting Group" := Vendor."Vendor Posting Group";
                        Customer."Tax Area Code" := Vendor."Tax Area Code";
                        Customer."Preferred Bank Account Code" := Vendor."Preferred Bank Account Code";
                        Customer."POI No Insurance" := Vendor."POI No Insurance";
                        Customer."Credit Limit (LCY)" := Vendor."POI Credit Limit (LCY)";
                        Customer."POI Credit Insurance No." := Vendor."POI Credit Insurance No.";
                        Customer."POI Easy No." := Vendor."POI Easy No.";
                        Customer."POI DRA" := Vendor."POI DRA";
                        Customer."POI Credit Ins. Credit Limit" := Vendor."POI Insurance credit limit";
                        Customer."POI Cred. Ins. Limit val. till" := Vendor."POI Ins. Cred. lim. val. until";
                        Customer."POI Extra Limit" := Vendor."POI Extra Limit";
                        Customer."POI Extra Limit valid to" := Vendor."POI Extra Limit valid to";
                        Customer."POI Ins. No. Extra Limit" := Vendor."POI Ins. No. Extra";
                        Customer."POI Termin. Date Extra limit" := Vendor."POI Termin. Date Extra limit";
                        Customer."POI Internal Credit Limit" := Vendor."POI Internal credit limit";
                        Customer."POI Int. Cred. Limit val. till" := Vendor."POI Cred. limit int. val.until";
                        Customer."POI Company System Filter" := Contact.CreateCompanySystemID(Customer."No.", 1);
                        //Gruppendebitor suchen
                        if Vendor."POI Vendor Group Code" <> '' then begin
                            Vendor2.get(Vendor."POI Vendor Group Code");
                            Customer."POI Group Customer" := Vendor2."POI Is Customer";
                        end;
                        Customer.Insert();
                        POICompany.Reset();
                        POICompany.SetRange("Synch Masterdata", true);
                        POICompany.SetFilter(Mandant, '<>%1', CompanynamePOI);
                        if POICompany.FindSet() then
                            repeat
                                CustomerComp.ChangeCompany(POICompany.Mandant);
                                CustomerComp := Customer;
                                CustomerComp.Insert();
                            until POICompany.Next() = 0;
                        ResultCode := Customer."No.";
                        ContactBusRel.SetRange("Link to Table", ContactBusRel."Link to Table"::Vendor);
                        ContactBusRel.SetRange("Business Relation Code", 'KRE');
                        IF ContactBusRel.FindFirst() then begin
                            Contact.get(ContactBusRel."Contact No.");
                            ContactAccount := Contact;
                            ContactAccount."No." := NewContactNo;
                            ContactAccount.Insert();
                            ContactBusRelAccount := ContactBusRel;
                            ContactBusRelAccount."No." := Customer."No.";
                            ContactBusRelAccount."Business Relation Code" := 'DEB';
                            ContactBusRelAccount."Link to Table" := ContactBusRelAccount."Link to Table"::Customer;
                            ContactBusRelAccount."Contact No." := ContactAccount."No.";
                            ContactBusRelAccount.Insert();
                            POICompany.Reset();
                            POICompany.SetRange("Synch Masterdata", true);
                            POICompany.SetFilter(Mandant, '<>%1', CompanyName());
                            if POICompany.FindSet() then
                                repeat
                                    ContactComp.ChangeCompany(POICompany.Mandant);
                                    ContactComp := ContactAccount;
                                    ContactComp.Insert();
                                until POICompany.Next() = 0;
                        end else
                            Message(NoContactTxt);
                        //Übernahme der Mandantenzuordnung
                        Contact.CopyAccountSettings(Vendor."No.", Customer."No.", POIVendorOrCustomer::Vendor, POIVendorOrCustomer::Customer);
                        Contact.CopyAccountSettings(Vendor."No.", ContactAccount."No.", POIVendorOrCustomer::Vendor, POIVendorOrCustomer::Contact);
                    end;
                end;
            AccountType::Vendor:
                begin
                    Customer.Get(AccountNo);
                    //Vendor create
                    PurchaseSetup.ChangeCompany(CompanynamePOI);
                    PurchaseSetup.Get();
                    Vendor.ChangeCompany(CompanynamePOI);
                    NoSeriesLine.ChangeCompany(CompanynamePOI);
                    NoSeriesLine.Reset();
                    NoSeriesLine.SetRange("Series Code", PurchaseSetup."Vendor Nos.");
                    if NoSeriesLine.FindFirst() then begin
                        IF NoSeriesLine."Last No. Used" = '' then
                            NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No."
                        else
                            IF NoSeriesLine."Increment-by No." <= 1 THEN
                                NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
                            ELSE
                                NoSerMgmt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
                        NoSeriesLine.Modify();
                        Vendor.Init();
                        case Newtype of
                            1:
                                Vendor."POI Supplier of Goods" := true;
                            2:
                                Vendor."POI Tax Representative" := true;
                            3:
                                Vendor."POI Shipping Company" := true;
                            4:
                                Vendor."POI Warehouse Keeper" := true;
                            5:
                                Vendor."POI Small Vendor" := true;
                            6:
                                Vendor."POI Diverse Vendor" := true;
                            7:
                                Vendor."POI Carrier" := true;
                            8:
                                Vendor."POI Customs Agent" := true;
                            9:
                                Vendor."POI Supplier of Goods" := true;
                            10:
                                Vendor."POI Air freight" := true;
                        end;
                        Vendor."No." := NoSeriesLine."Last No. Used";
                        Vendor.Name := Customer.Name;
                        Vendor."Name 2" := Customer."Name 2";
                        Vendor."E-Mail" := Customer."E-Mail";
                        Vendor.Address := Customer.Address;
                        Vendor."Language Code" := Customer."Language Code";
                        Vendor."Country/Region Code" := Customer."Country/Region Code";
                        Vendor.Address := Customer.Address;
                        Vendor."Address 2" := Customer."Address 2";
                        Vendor.City := Vendor.City;
                        Vendor."Post Code" := Vendor."Post Code";
                        Vendor."Country/Region Code" := Vendor."Country/Region Code";
                        Vendor."Registration No." := Customer."POI Registration No.";
                        Vendor."POI Amtsgericht" := Customer."POI Amtsgericht";
                        Vendor."POI County Court" := Customer."POI County Court";
                        Vendor."POI Commercial Register No." := Customer."POI Commercial Register No.";
                        Vendor."E-Mail" := Vendor."E-Mail";
                        Vendor."Phone No." := Customer."Phone No.";
                        Vendor."Fax No." := Customer."Fax No.";
                        Vendor."Home Page" := Customer."Home Page";
                        Vendor."Language Code" := Customer."Language Code";
                        Vendor."VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group";
                        Vendor."Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
                        Vendor."Vendor Posting Group" := Customer."Customer Posting Group";
                        Vendor."Tax Area Code" := Customer."Tax Area Code";
                        Vendor."Preferred Bank Account Code" := Vendor."Preferred Bank Account Code";
                        Vendor."POI No Insurance" := Customer."POI No Insurance";
                        Vendor."POI Credit Limit (LCY)" := Customer."Credit Limit (LCY)";
                        Vendor."POI Credit Insurance No." := Customer."POI Credit Insurance No.";
                        Vendor."POI Easy No." := Customer."POI Easy No.";
                        Vendor."POI DRA" := Customer."POI DRA";
                        Vendor."POI Insurance credit limit" := Customer."POI Credit Ins. Credit Limit";
                        Vendor."POI Ins. Cred. lim. val. until" := Customer."POI Cred. Ins. Limit val. till";
                        Vendor."POI Extra Limit" := Customer."POI Extra Limit";
                        Vendor."POI Extra Limit valid to" := Customer."POI Extra Limit valid to";
                        Vendor."POI Ins. No. Extra" := Customer."POI Ins. No. Extra Limit";
                        Vendor."POI Termin. Date Extra limit" := Customer."POI Termin. Date Extra limit";
                        Vendor."POI Internal Credit Limit" := Customer."POI Internal credit limit";
                        Vendor."POI Cred. limit int. val.until" := Customer."POI Int. Cred. Limit val. till";
                        Vendor."POI Is Customer" := Customer."No.";
                        Vendor."POI Company System Filter" := Contact.CreateCompanySystemID(Customer."No.", 2);
                        //Gruppendebitor suchen
                        if Customer."POI Group Customer" <> '' then begin
                            Customer2.get(Customer."POI Group Customer");
                            Vendor."POI Vendor Group Code" := Customer2."POI Is Vendor";
                        end;
                        Vendor.Insert();
                        POICompany.Reset();
                        POICompany.SetRange("Synch Masterdata", true);
                        POICompany.SetFilter(Mandant, '<>%1', CompanynamePOI);
                        if POICompany.FindSet() then
                            repeat
                                VendorComp.ChangeCompany(POICompany.Mandant);
                                VendorComp := Vendor;
                                VendorComp.Insert();
                            until POICompany.Next() = 0;
                        ResultCode := Vendor."No.";
                        ContactBusRel.SetRange("Link to Table", 18);
                        ContactBusRel.SetRange("Business Relation Code", 'DEB');
                        IF ContactBusRel.FindSet() then begin
                            Contact.get(ContactBusRel."Contact No.");
                            ContactAccount := Contact;
                            ContactAccount."No." := NewContactNo;
                            ContactAccount.Insert();
                            ContactBusRelAccount := ContactBusRel;
                            ContactBusRelAccount."No." := Customer."No.";
                            ContactBusRelAccount."Business Relation Code" := 'KRE';
                            ContactBusRelAccount."Contact No." := ContactAccount."No.";
                            ContactBusRelAccount.Insert();
                        end else
                            Message(NoContactTxt);
                        //Übernahme der Mandantenzuordnung
                        Contact.CopyAccountSettings(Customer."No.", Vendor."No.", POIVendorOrCustomer::Customer, POIVendorOrCustomer::Vendor);
                        Contact.CopyAccountSettings(Customer."No.", ContactAccount."No.", POIVendorOrCustomer::Customer, POIVendorOrCustomer::Contact);
                        //Mail an den Kunden wegen notwendiger Daten. Vom Benutzer.
                        if Vendor."POI Carrier" or Vendor."POI Warehouse Keeper" or vendor."POI Air freight" or Vendor."POI Supplier of Goods" or Vendor."POI Shipping Company" then begin
                            //MailReceiver.Add(Vendor."E-Mail");
                            MailSubject := Translation.GetTranslationDescription(0, 'QS', 'SUBCOPYVENDCUST', Vendor."Language Code", 1);
                            MailBody := Translation.GetTranslationDescription(0, 'QS', 'ANREDE', Vendor."Language Code", 1);
                            MailBody += Translation.GetTranslationDescription(0, 'QS', 'BODYCOPYVENDCUST', Vendor."Language Code", 1);
                            // MailBody += Translation.GetTranslationDescription(0, 'QS', 'BODYCOPYVENDCUST1', Vendor."Language Code", 1, 20000);
                            // MailBody += Translation.GetTranslationDescription(0, 'QS', 'BODYCOPYVENDCUST2', Vendor."Language Code", 1, 30000);
                            //Anhänge
                            //Datenschutzinformation, Einkaufsbedingungen, Lieferantenstammblatt (mit Vorsatzblatt) sowie Lieferantenfragebogen:
                            Attachment.Init();
                            Attachment."No." += 1;
                            case true of
                                Vendor."POI Carrier":
                                    Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTLOG', Vendor."Language Code");
                                Vendor."POI Warehouse Keeper":
                                    Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTWL', Vendor."Language Code");
                                Vendor."POI Air freight":
                                    Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTWL', Vendor."Language Code");
                                Vendor."POI Supplier of Goods":
                                    Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTWL', Vendor."Language Code");
                                Vendor."POI Shipping Company":
                                    Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTLOG', Vendor."Language Code");
                            end;
                            Attachment.INSERT();
                            Attachment."No." += 1;
                            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'DSGVO', Vendor."Language Code");
                            Attachment.INSERT();
                            Attachment."No." += 1;
                            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'LIFFRAGEBOGEN', Vendor."Language Code");
                            Attachment.INSERT();
                            Attachment."No." += 1;
                            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'ALLGEMEKBEDINGUNGEN', Vendor."Language Code");
                            Attachment.INSERT();
                            Attachment.Reset();
                            if Attachment.FindSet() then
                                repeat
                                    SMTPMail.AddAttachment(Attachment."File Extension", POIFunction.GetFilename(Attachment."File Extension"));
                                until Attachment.Next() = 0;
                            if Usersetup.Get(UserId()) and (Usersetup."E-Mail" <> '') then
                                MailSender := Usersetup."E-Mail";
                            MailReceiver.Add(MailSender);
                            if (MailSender <> '') and (MailReceiver.Count > 0) then begin
                                SMTPMail.CreateMessage('Vervollständigung Ihrer Angaben', MailSender, MailReceiver, MailSubject, MailBody);
                                SMTPMail.Send();
                            end;
                        end;
                    end;
                end;
        end;
        exit(ResultCode);
    end;

    procedure CofaceExcelFileRead(PathName: Text; ExcelTableName: Text[100]; InsNo: code[20])
    var
        //Accounttmp: Record Vendor temporary;
        //AccCode: Code[20];
        //AccCodetmp: Code[20];
        Parameter: Record "POI Parameter";
        CountRows: Integer;
        Idx: Integer;
    //AccountType: enum "POI VendorCustomer";

    begin
        // Accounttmp.DeleteAll();
        // if Customer.findset() then
        //     repeat
        //         Accounttmp."No." := Customer."No.";
        //         Accounttmp."Partner Type" := 0;
        //         Accounttmp.Insert();
        //     until Customer.Next() = 0;
        // if Vendor.findset() then
        //     repeat
        //         Accounttmp."No." := Vendor."No.";
        //         Accounttmp."Partner Type" := 1;
        //         Accounttmp.Insert();
        //     until Vendor.Next() = 0;
        //File.Open(PathName);
        //File.CreateInStream(ExcelInstream);
        //ExcelBuffer.OpenBookStream(ExcelInstream, ExcelTableName);
        ExcelBuffer.OpenBook(PathName, ExcelTableName);
        ExcelBuffer.ReadSheet();

        IF ExcelBuffer.FIND('+') THEN
            CountRows := ExcelBuffer."Row No.";

        FOR Idx := 2 TO CountRows DO BEGIN
            InsuranceBuffer.INIT();
            InsuranceBuffer."Error Text" := '';
            if Parameter.get('LIMITIMP', Parameter."Source Type"::Vendor, InsNo, '1', '', '') then
                if ExcelBuffer.GET(Idx, Parameter.ValueInteger) THEN
                    InsuranceBuffer."Account Name" := copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if Parameter.get('LIMITIMP', Parameter."Source Type"::Vendor, InsNo, '2', '', '') then
                if ExcelBuffer.GET(Idx, Parameter.ValueInteger) THEN
                    InsuranceBuffer."International Account Name" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."International Account Name"));
            if Parameter.get('LIMITIMP', Parameter."Source Type"::Vendor, InsNo, '3', '', '') then
                if ExcelBuffer.GET(Idx, Parameter.ValueInteger) THEN
                    InsuranceBuffer."Easy No." := copystr(ExcelBuffer."Cell Value as Text", 1, 20);
            if Parameter.get('LIMITIMP', Parameter."Source Type"::Vendor, InsNo, '4', '', '') then
                if ExcelBuffer.GET(Idx, Parameter.ValueInteger) THEN
                    InsuranceBuffer.Address := copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if Parameter.get('LIMITIMP', Parameter."Source Type"::Vendor, InsNo, '5', '', '') then
                if ExcelBuffer.GET(Idx, Parameter.ValueInteger) THEN
                    InsuranceBuffer.City := copystr(ExcelBuffer."Cell Value as Text", 1, 30);
            if ExcelBuffer.GET(Idx, 7) THEN
                InsuranceBuffer."Post Code" := copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if ExcelBuffer.GET(Idx, 9) THEN
                InsuranceBuffer.Country := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer.Country));
            if ExcelBuffer.GET(Idx, 10) THEN
                InsuranceBuffer."Country Code" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Country Code"));
            if ExcelBuffer.GET(Idx, 11) THEN //begin
                InsuranceBuffer."Credit Insurance No." := copystr(ExcelBuffer."Cell Value as Text", 1, 20);
            // Vendor.SetRange("POI Credit Insurance No.", InsuranceBuffer."Credit Insurance No.");
            // if Vendor.FindFirst() then
            //     InsuranceBuffer."Account No." := Vendor."No."
            // else begin
            //     Customer.SetRange("POI Credit Insurance No.", InsuranceBuffer."Credit Insurance No.");
            //     if Customer.FindSet() then
            //         InsuranceBuffer."Account No." := Customer."No.";
            // end;
            //end;
            if ExcelBuffer.GET(Idx, 12) then
                InsuranceBuffer."ID Name 1" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."ID Name 1"));
            if ExcelBuffer.GET(Idx, 13) then
                InsuranceBuffer."ID No 1" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."ID No 1"));
            if ExcelBuffer.GET(Idx, 14) then
                InsuranceBuffer."ID Name 2" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."ID Name 2"));
            if ExcelBuffer.GET(Idx, 15) then
                InsuranceBuffer."ID No. 2" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."ID No. 2"));
            if ExcelBuffer.GET(Idx, 16) then
                InsuranceBuffer."ID Name 3" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."ID Name 3"));
            if ExcelBuffer.GET(Idx, 17) then
                InsuranceBuffer."ID No. 3" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."ID No. 3"));
            if ExcelBuffer.GET(Idx, 18) then
                InsuranceBuffer.Product := copystr(ExcelBuffer."Cell Value as Text", 1, 20);
            if ExcelBuffer.GET(Idx, 19) then
                InsuranceBuffer."User ID" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."User ID"));
            if ExcelBuffer.GET(Idx, 20) then
                InsuranceBuffer."Contract No." := copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if ExcelBuffer.GET(Idx, 21) then
                InsuranceBuffer."Contract Type" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Contract Type"));
            if ExcelBuffer.GET(Idx, 22) then
                InsuranceBuffer."Company Name" := copystr(ExcelBuffer."Cell Value as Text", 1, 100);
            if ExcelBuffer.GET(Idx, 23) then
                InsuranceBuffer.Rating := copystr(ExcelBuffer."Cell Value as Text", 1, 10);
            if ExcelBuffer.GET(Idx, 24) then
                Evaluate(InsuranceBuffer."date of Request", ExcelBuffer."Cell Value as Text");
            if ExcelBuffer.GET(Idx, 25) then
                InsuranceBuffer."NZM Reference" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."NZM Reference"));
            if ExcelBuffer.GET(Idx, 26) then
                Evaluate(InsuranceBuffer."Request Amount", ExcelBuffer."Cell Value as Text");
            if ExcelBuffer.GET(Idx, 27) then
                InsuranceBuffer."Request Currency" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Request Currency"));
            if ExcelBuffer.GET(Idx, 30) then
                InsuranceBuffer."Credit Goal" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Credit Goal"));
            if ExcelBuffer.GET(Idx, 31) then
                Evaluate(InsuranceBuffer."Decision Date", ExcelBuffer."Cell Value as Text");
            if ExcelBuffer.GET(Idx, 32) then
                InsuranceBuffer.Status := copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if ExcelBuffer.GET(Idx, 33) then
                InsuranceBuffer."Decision Type" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Decision Type"));
            if ExcelBuffer.GET(Idx, 34) then
                InsuranceBuffer."Key Field1" := Copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if ExcelBuffer.GET(Idx, 35) then
                InsuranceBuffer."Key Field2" := Copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if ExcelBuffer.GET(Idx, 36) then
                InsuranceBuffer."Key Field3" := Copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if ExcelBuffer.GET(Idx, 37) then
                Evaluate(InsuranceBuffer."valid from", ExcelBuffer."Cell Value as Text");
            if ExcelBuffer.GET(Idx, 38) then
                Evaluate(InsuranceBuffer."valid to", ExcelBuffer."Cell Value as Text");
            if ExcelBuffer.GET(Idx, 39) then
                Evaluate(InsuranceBuffer.Amount, ExcelBuffer."Cell Value as Text");
            if ExcelBuffer.GET(Idx, 40) then
                InsuranceBuffer."Currency Decision Amount" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Currency Decision Amount"));
            if ExcelBuffer.GET(Idx, 47) then
                InsuranceBuffer."Comment Credit Auditor" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Comment Credit Auditor"));
            if ExcelBuffer.GET(Idx, 48) then
                InsuranceBuffer."insured share" := copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."insured share"));
            if ExcelBuffer.GET(Idx, 49) then
                InsuranceBuffer.DRA := Copystr(ExcelBuffer."Cell Value as Text", 1, 50);
            if ExcelBuffer.GET(Idx, 52) then //begin
                InsuranceBuffer."Account Reference" := Copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Account Reference"));
            //AccCode := delchr(InsuranceBuffer."Account No.", '=', '-/+_ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜabcdefghijklmnopqrstuvwäöü');
            // AccCodetmp := AccCode;
            // while strlen(AccCodetmp) > 4 do begin
            //     AccCode := copystr(AccCodetmp, 1, 5);
            //     if StrLen(AccCodetmp) > 5 then
            //         AccCodetmp := copystr(AccCodetmp, 6, StrLen(AccCodetmp))
            //     else
            //         AccCodetmp := '';
            //     if Accounttmp.Get(AccCode) then
            //         case Accounttmp."Partner Type" of
            //             0:
            //                 if InsuranceBuffer."Account No. Customer" = '' then
            //                     InsuranceBuffer."Account No. Customer" := Accounttmp."No.";
            //             1:
            //                 if InsuranceBuffer."Account No. Vendor" = '' then
            //                     InsuranceBuffer."Account No. Vendor" := Accounttmp."No.";
            //         end;
            // end;
            //end;
            // InsuranceBuffer."Account No. Vendor" := GetAccountNoFromEasy(InsuranceBuffer."Easy No.", AccountType::Vendor);
            // InsuranceBuffer."Account No. Customer" := GetAccountNoFromEasy(InsuranceBuffer."Easy No.", AccountType::Customer);
            if ExcelBuffer.GET(Idx, 53) then
                InsuranceBuffer."Outstanding balance" := Copystr(ExcelBuffer."Cell Value as Text", 1, StrLen(InsuranceBuffer."Outstanding balance"));
            if ExcelBuffer.GET(Idx, 54) then
                Evaluate(InsuranceBuffer.IntCreditlimit, ExcelBuffer."Cell Value as Text");
            InsuranceBuffer."Insurance Company Code" := '70001';
            with InsuranceBuffer do
                if InsuranceBuffer2.Get("Easy No.", "Contract No.", Product, "Company Name", "valid from", "date of Request", Status) then
                    InsuranceBuffer.Modify()
                else
                    InsuranceBuffer.INSERT();
        end;
        InsertCreditLimitFromBuffer();
    end;

    procedure GetAccountNoFromEasy(EasyNo: Code[20]; AccountType: enum "POI VendorCustomer"): Code[20]
    var
        OutNo: Code[20];
    begin
        Clear(OutNo);
        case AccountType of
            AccountType::Vendor:
                begin
                    Vendor.Reset();
                    Vendor.SetRange("POI Easy No.", EasyNo);
                    if Vendor.FindFirst() then
                        OutNo := Vendor."No.";
                end;
            AccountType::Customer:
                begin
                    Customer.SetRange("POI Easy No.", EasyNo);
                    if Customer.FindFirst() then
                        OutNo := Customer."No.";
                end;
        end;
        exit(OutNo);
    end;

    procedure InsertCreditLimitFromBuffer()
    begin
        Vendor.Reset();
        Customer.Reset();
        CreditLimitBuffer.Reset();
        if CreditLimitBuffer.FindSet() then
            repeat
                CreditLimitBuffer2.Copy(CreditLimitBuffer);
            until CreditLimitBuffer.Next() = 0;
        CreditLimitBuffer.Reset();
        CreditLimitBuffer.setfilter(Product, '%1|%2|%3', 'KREDITLIMIT', 'EXPRESS-PAUSCHALDECKUNG', '@RATING LIMIT');
        CreditLimitBuffer.SetRange(Status, 'GÜLTIG');
        CreditLimitBuffer.SetFilter("valid from", '<=%1', Today());
        CreditLimitBuffer.SetFilter("valid to", '>=%1|%2', Today(), 0D);
        if CreditLimitBuffer.FindSet() then
            repeat
                Vendor.SetRange("POI Easy No.", CreditLimitBuffer."Easy No.");
                if Vendor.FindFirst() then begin
                    Vendor.Validate("POI insurance credit limit", CreditLimitBuffer.Amount);
                    Vendor."POI Rating" := CreditLimitBuffer.Rating;
                    Vendor."POI Ins. Cred. lim. val. until" := CreditLimitBuffer."valid to";
                    Vendor."POI DRA" := CreditLimitBuffer.DRA;
                    Vendor."POI Credit Insurance No." := CreditlimitBuffer."Insurance Company Code";
                    CreditLimitBuffer2.Reset();
                    CreditLimitBuffer2.SetRange("Account No. Vendor", CreditLimitBuffer."Account No. Vendor");
                    CreditLimitBuffer2.SetRange(Product, 'TOPLINER LIMIT');
                    CreditLimitBuffer2.SetRange(Status, 'GÜLTIG');
                    CreditLimitBuffer2.SetFilter("valid from", '<=%1', Today());
                    CreditLimitBuffer2.SetFilter("valid to", '>=%1|%2', Today(), 0D);
                    if CreditLimitBuffer2.FindLast() then begin
                        Vendor."POI Extra Limit" := CreditLimitBuffer2.Amount;
                        Vendor."POI Extra Limit valid to" := CreditLimitBuffer2."valid to";
                        Vendor."POI Ins. No. Extra" := '70059';
                    end;
                    Vendor.Modify();
                end;
                Customer.SetRange("POI Easy No.", CreditLimitBuffer."Easy No.");
                if Customer.FindFirst() then begin
                    Customer."POI Cred. Ins. Limit val. from" := CreditLimitBuffer."valid from";
                    Customer.Validate("POI Credit Ins. Credit Limit", CreditLimitBuffer.Amount);
                    Customer."POI Cred. Ins. Limit val. till" := CreditLimitBuffer."valid to";
                    Customer."POI Credit Ins. Status" := CreditLimitBuffer.Status;
                    Customer."POI DRA" := CreditLimitBuffer.DRA;
                    Customer."POI Rating" := CreditLimitBuffer.Rating;
                    Customer."POI Credit Ins. Last Request" := CreditLimitBuffer."Decision Date";
                    CreditLimitBuffer2.Reset();
                    CreditLimitBuffer2.SetRange("Account No. Customer", CreditLimitBuffer."Account No. Customer");
                    CreditLimitBuffer2.SetRange(Product, 'TOPLINER LIMIT');
                    CreditLimitBuffer2.SetRange(Status, 'GÜLTIG');
                    CreditLimitBuffer2.SetFilter("valid from", '<=%1', Today());
                    CreditLimitBuffer2.SetFilter("valid to", '>=%1|%2', Today(), 0D);
                    if CreditLimitBuffer2.Findlast() then begin
                        Customer."POI Extra Limit" := CreditLimitBuffer2.Amount;
                        Customer."POI Extra Limit valid to" := CreditLimitBuffer2."valid to";
                    end;
                    Customer.Modify();
                end;
            until CreditLimitBuffer.Next() = 0;
    end;

    procedure findvalidCreditLimit()
    begin
        CreditlimitBuffer.Reset();
        CreditLimitBuffer.SetRange(Status, 'GÜLTIG');
        CreditlimitBuffer.SetFilter("valid from", '<%1|%2', Today(), 0D);
        CreditlimitBuffer.SetFilter("valid to", '>=%1|%2', Today(), 0D);
        Customer.setrange("POI No Insurance", false);
        if Customer.findset() then
            repeat
                findvalidCreditLimitForCustomer(Customer."No.");
            until Customer.Next() = 0;
        Vendor.SetRange("POI No Insurance", false);
        if Vendor.FindSet() then
            repeat
                findvalidCreditLimitForVendor(Vendor."No.");
            until Vendor.Next() = 0;
    end;

    procedure findvalidCreditLimitForCustomer(CustNo: Code[20])
    var
        MaxRange: Decimal;
    begin
        Customer.Get(CustNo);
        CreditlimitBuffer.Reset();
        CreditLimitBuffer.SetRange(Status, 'GÜLTIG');
        CreditlimitBuffer.SetFilter("valid from", '<%1|%2', Today(), 0D);
        CreditlimitBuffer.SetFilter("valid to", '>=%1|%2', Today(), 0D);
        CreditlimitBuffer.SetRange("Additional Insurance", false);
        CreditLimitBuffer.setfilter(Product, '%1|%2', 'KREDITLIMIT', 'EXPRESS-PAUSCHALDECKUNG');
        CreditlimitBuffer.SetRange("Easy No.", Customer."POI Easy No.");
        if CreditlimitBuffer.FindLast() then begin
            Customer."Credit Limit (LCY)" := CreditlimitBuffer.Amount;
            MaxRange := CreditlimitBuffer.Amount;
        end;
        CreditLimitBuffer.SetRange(Product, 'TOPLINER LIMIT');
        if CreditlimitBuffer.FindLast() then
            Customer."Credit Limit (LCY)" += CreditlimitBuffer.Amount;
        CreditlimitBuffer.SetRange("Additional Insurance", true);
        CreditLimitBuffer.SetRange(Product, 'TOPUP LIMIT');
        if CreditlimitBuffer.FindLast() then begin
            Customer."Credit Limit (LCY)" += CreditlimitBuffer.Amount;
            if Customer."Credit Limit (LCY)" > MaxRange then
                Customer."Credit Limit (LCY)" := MaxRange;
        end;
        Customer.Modify();
    end;

    procedure findvalidCreditLimitForVendor(VendorNo: Code[20])
    begin
        Vendor.Get(VendorNo);
        CreditlimitBuffer.Reset();
        CreditLimitBuffer.SetRange(Status, 'GÜLTIG');
        CreditlimitBuffer.SetFilter("valid from", '<%1|%2', Today(), 0D);
        CreditlimitBuffer.SetFilter("valid to", '>=%1|%2', Today(), 0D);
        CreditLimitBuffer.setfilter(Product, '%1|%2', 'KREDITLIMIT', 'EXPRESS-PAUSCHALDECKUNG');
        CreditlimitBuffer.SetRange("Easy No.", Vendor."POI Easy No.");
        if CreditlimitBuffer.FindLast() then
            Vendor."POI Credit Limit" := CreditlimitBuffer.Amount;
        CreditLimitBuffer.SetRange(Product, 'TOPLINER LIMIT');
        if CreditlimitBuffer.FindLast() then
            Vendor."POI Credit Limit" += CreditlimitBuffer.Amount;
        Vendor."POI credit limit" += Vendor."POI Internal credit limit";
        Vendor.Modify();
    end;

    procedure GetGroupLimit(EasyNo: Code[50]; Type: Option Insurance,Total): Decimal
    var
        InsuranceGroupCreditLimit: Decimal;
        TotalGroupCreditLimit: Decimal;
        GroupAmount: Decimal;
    begin
        POICompany.SetRange("Synch Masterdata", true);
        POICompany.SetRange("Basic Company", false);
        if POICompany.FindSet() then
            repeat
                Customer.ChangeCompany(POICompany.Mandant);
                Customer.SetRange("POI Easy No.", EasyNo);
                if Customer.FindFirst() then
                    repeat
                        InsuranceGroupCreditLimit += (Customer."POI Credit Ins. Credit Limit" + Customer."POI Extra Limit");
                        TotalGroupCreditLimit += (Customer."POI Credit Ins. Credit Limit" + Customer."POI Extra Limit" + Customer."POI Internal Credit Limit");
                    until Customer.Next() = 0;
                Vendor.ChangeCompany(POICompany.Mandant);
                Vendor.SetRange("POI Easy No.", EasyNo);
                if Vendor.FindFirst() then
                    repeat
                        InsuranceGroupCreditLimit += (Vendor."POI credit limit" + Vendor."POI Extra Limit");
                        TotalGroupCreditLimit += (Vendor."POI credit limit" + Vendor."POI Extra Limit" + Vendor."POI Extra Limit");
                    until Vendor.Next() = 0;
            until POICompany.Next() = 0;
        case Type of
            Type::Insurance:
                GroupAmount := InsuranceGroupCreditLimit;
            Type::Total:
                GroupAmount := TotalGroupCreditLimit;
        end;
        exit(GroupAmount);
    end;

    procedure SetGroupLimitForAll()
    begin
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                Customer.ChangeCompany(POICompany.Mandant);
                Customer.SetFilter("POI Easy No.", '<>%1', '');
                if Customer.FindSet() then
                    repeat
                        Customer."POI Group Creditlimit" := GetGroupLimit(Customer."POI Easy No.", 1);
                        Customer."POI Ins. Group Creditlimit" := GetGroupLimit(Customer."POI Easy No.", 0);
                    until Customer.Next() = 0;
                Vendor.ChangeCompany(POICompany.Mandant);
                Vendor.SetFilter("POI Easy No.", '<>%1', '');
                if Vendor.FindSet() then
                    repeat
                        Vendor."POI Group Credit Limit" := GetGroupLimit(Vendor."POI Easy No.", 1);
                        Vendor."POI ins. Group Credit Limit" := GetGroupLimit(Vendor."POI Easy No.", 0);
                    until Vendor.Next() = 0;
            until POICompany.Next() = 0;
    end;

    procedure ComparePurchaseOrderVersions(PONo: Code[20]): Boolean //TODO:Versionsvergleich Bestellungen
    var
        PrintDocument: Boolean;
    begin
        POLine.SetRange("Document No.", PONo);
        POLine.SetRange("Document Type", POLine."Document Type"::Order);
        if POLine.FindSet() then
            repeat
                POLineArchiv.SetRange("Document No.", PONo);
                POLineArchiv.SetRange("Document Type", POLineArchiv."Document Type"::Order);
                POLineArchiv.SetRange("Line No.", POLine."Line No.");
                if POLineArchiv.FindLast() then
                    if (POLine.Quantity <> POLineArchiv.Quantity)
                    or (POLine."Unit Cost (LCY)" <> POLineArchiv."Unit Cost (LCY)")
                    or (POLine."Quantity (Base)" <> POLineArchiv."Quantity (Base)") then begin
                        Message('Print Document No %1', PONo);
                        PrintDocument := true;
                    end;
            until (POLine.Next() = 0) or PrintDocument;
    end;

    procedure CalcFreightChargesPerLine(OrderNo: Code[20]; OrderLine: Integer; OrderType: Option Sales,Purchase): Decimal
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        FreihgtChargesAmount: Decimal;
        Additon: Decimal;
        DieselAddition: Decimal;
        BaseCost: Decimal;
        PalletFactor: Decimal;
    begin
        case OrderType of
            OrderType::Purchase:
                begin
                    PurchaseHeader.Get(1, OrderNo);
                    PurchaseLine.Get(1, OrderNo, OrderLine);
                    FreightCharges.SetCurrentKey("Shipping Agent Code", "Freight Unit of Measure Code", "Arrival Region Code", "Departure Region Code", "Valid From", "Valid until", "Country/Region Code", "Freight Cost Tarif Base", "From Quantity", "Until Quantity");
                    FreightCharges.setrange("Shipping Agent Code", PurchaseHeader."POI Shipping Agent Code");
                    FreightCharges.SetRange("Freight Unit of Measure Code", PurchaseLine."Unit of Measure Code");
                    FreightCharges.setfilter("Valid From", '>=%1|%2', Today(), 0D);
                    FreightCharges.SetFilter("Valid until", '<=%1|%2', Today(), 0D);
                    FreightCharges.SetRange("Country/Region Code", PurchaseHeader."Buy-from Country/Region Code");
                    FreightCharges.SetRange("Freight Cost Tarif Base", FreightCharges."Freight Cost Tarif Base"::Pallet);
                    FreightCharges.SetFilter("From Quantity", '>=%1|%2', PurchaseLine."POI Pallet number");
                    FreightCharges.SetFilter("Until Quantity", '<=%1|%2', PurchaseLine."POI Pallet number");
                    FreightCharges.SetRange("Departure Region Code", PurchaseHeader."POI Departure Region Code");
                    FreightCharges.SetRange("Arrival Region Code", PurchaseHeader."POI Arrival Region Code");
                    if FreightCharges.FindFirst() then
                        if FreightCharges.Pauschal then begin
                            PalletFactor := PurchaseLine."POI Pallet number" / PurchaseLine."POI Pallet number";
                            BaseCost := FreightCharges."Base Freight Rate" * PalletFactor;
                            exit(BaseCost);
                        end else begin
                            FreihgtChargesAmount := FreightCharges."Freight Rate per Unit" * PurchaseLine."POI Pallet number";//TODO:Frachtkostenberechnung Verkauf
                            Additon := FreightCharges.Addition;
                            DieselAddition := FreightCharges."Diesel Surcharge";
                            PalletFactor := PurchaseLine."POI Pallet number" / PurchaseLine."POI Pallet number";
                            BaseCost := FreightCharges."Base Freight Rate" * PalletFactor;
                            exit(FreihgtChargesAmount + Additon + DieselAddition + BaseCost);
                        end;
                    exit(0);
                end;
            OrderType::Sales:
                begin
                    SalesHeader.Get(1, OrderNo);
                    SalesLine.Get(1, OrderNo, OrderLine);
                end;
        end;
    end;

    procedure CalcFreightChargesPerOrder(OrderNo: Code[20]; OrderType: Option Sales,Purchase): Decimal
    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        //FreightCharges: Record "POI Ship.-Agent Freightcost";
        FreihgtChargesAmount: Decimal;
    begin
        case OrderType of
            OrderType::Purchase:
                begin
                    PurchaseHeader.Get(1, OrderNo);
                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    PurchaseLine.SetRange("Document Type", 1);
                    if PurchaseLine.FindSet() then
                        repeat
                            FreihgtChargesAmount += CalcFreightChargesPerLine(PurchaseLine."Document No.", PurchaseLine."Line No.", 1);
                        until PurchaseLine.Next() = 0;
                end;
            OrderType::Sales:
                begin
                    SalesHeader.Get(1, OrderNo);
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    SalesLine.SetRange("Document Type", 1);
                    if SalesLine.FindSet() then
                        repeat
                            FreihgtChargesAmount += CalcFreightChargesPerLine(SalesLine."Document No.", SalesLine."Line No.", 0);
                        until SalesLine.Next() = 0;
                end;
        end;
        exit(FreihgtChargesAmount);
    end;

    procedure CheckPermissionSuper(): Boolean
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.setrange("User Security ID", UserSecurityId());
        AccessControl.SetRange("Role ID", 'SUPER');
        AccessControl.SetFilter("Company Name", '%1|%2', CompanyName(), '');
        if AccessControl.Count() > 0 then exit(true);
    end;

    procedure getCalendarWeek(InpDate: Date): Integer
    begin
        if InpDate <> 0D then
            exit(Date2DWY(InpDate, 2))
        else
            exit(0)
    end;

    procedure CountUnitPerPalet(PaletCode: Code[20]; UnitCode: Code[20]; Paletheight: Decimal): Decimal
    var
        UnitOfMeasure: Record "Unit of Measure";
        LengtPalet: Decimal;
        WidePalet: Decimal;
        LengtUnit: Decimal;
        WideUnit: Decimal;
        HeightUnit: Decimal;
        Number1: Decimal;
        Number2: Decimal;
        TotalNumberonLine: Decimal;
        Precision: Decimal;
        Direction: Text;

    begin
        Direction := '<';
        Precision := 1;
        UnitOfMeasure.Get(PaletCode);
        LengtPalet := UnitOfMeasure."POI Lenght";
        WidePalet := UnitOfMeasure."POI Wide";
        UnitOfMeasure.Get(UnitCode);
        LengtUnit := UnitOfMeasure."POI Lenght";
        WideUnit := UnitOfMeasure."POI Wide";
        HeightUnit := UnitOfMeasure."POI Height";

        if (LengtUnit = 0) or (WideUnit = 0) or (HeightUnit = 0) then
            exit(1);

        Number1 := Round((LengtPalet / LengtUnit), Precision, Direction) * Round((WidePalet / WideUnit), Precision, Direction);
        Number2 := Round((LengtPalet / WideUnit), Precision, Direction) * Round((WidePalet / LengtUnit), Precision, Direction);
        if Number2 > Number1 then
            TotalNumberOnLine := Number2
        else
            TotalNumberOnLine := Number1;
        exit(Round(Paletheight / HeightUnit * TotalNumberonLine, Precision, Direction));
    end;

    procedure UserInRoleForCompany(RoleFilter: Code[250]; Company: code[50]): Boolean
    //check if user is in this Role
    var
        User: Record User;
        UserGroupMember: Record "User Group Member";

    begin
        if not User.Get(UserSecurityId()) or (User.State = User.State::Disabled) then
            EXIT(false);

        UserGroupMember.RESET();
        UserGroupMember.SetFilter("User Group Code", RoleFilter);
        UserGroupMember.SetFilter("Company Name", '%1 | %2', Company, '');
        UserGroupMember.SetRange("User Security ID", User."User Security ID");
        exit(not UserGroupMember.IsEmpty());
    end;


    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Contact: Record Contact;
        ContactAccount: Record Contact;
        ContactBusRel: Record "Contact Business Relation";
        ContactBusRelAccount: Record "Contact Business Relation";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchaseSetup: Record "Purchases & Payables Setup";
        MarketingSetup: Record "Marketing Setup";
        NoSeriesLine: Record "No. Series Line";
        ExcelBuffer: Record "Excel Buffer" temporary;
        POICompany: Record "POI Company";
        AccountCompanySetting: Record "POI Account Company Setting";
        FieldSecurity: Record "POI Field Security";
        AccCompSetting: Record "POI Account Company Setting";
        CreditlimitBuffer: Record "POI Ins. Cred. lim. Buffer";
        POLine: Record "Purchase Line";
        POLineArchiv: Record "Purchase Line Archive";
        FreightCharges: Record "POI Ship.-Agent Freightcost";
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        CreditLimitBuffer2: Record "POI Ins. Cred. lim. Buffer" temporary;
        InsuranceBuffer: Record "POI Ins. Cred. lim. Buffer";
        InsuranceBuffer2: Record "POI Ins. Cred. lim. Buffer";
        Usersetup: Record "User Setup";
        Customer2: Record Customer;
        Vendor2: Record Vendor;
        Translation: Record "POI Translations";
        Attachment: Record Attachment temporary;
        POIFunction: Codeunit POIFunction;
        SMTPMail: Codeunit "SMTP Mail";
        POIDialog: Dialog;
        DocumentNotFoundTxt: Label 'Das Dokument: %1 konnte nicht gefunden werden.', Comment = '%1';
        SettingNoExistTxt: Label 'Einrichtung konnte nicht gefunden werden.';
        POIVendorOrCustomer: Enum "POI VendorCustomer";

}

dotnet
{
    assembly(VATValidation)
    {
        type(VATValidation.VATValidationService.checkVatService; "POI MyValidation")
        { }
        var
            VatValidation: DotNet MyValidation;
    // VATTrue: Boolean;
    // CountryCode: Text[10];
    // CountryCode := 'DE';
    // VatValidation.checkVat(CountryCode,Customer."VAT Registration No.",VATTrue,Customer.Name,Customer.Address);
}
}
