codeunit 50006 "POI Account Synchronisation"
{
    var
        POICompany: Record "POI Company";
        Contact2Company: Record Contact;
        Customer: Record Customer;
        Vendor: Record Vendor;
        CustomerComp: Record Customer;
        VendorComp: Record Vendor;
        Contact: Record Contact;
        ContactComp: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        Comment: Record "Comment Line";
        AccountNos2: Record "POI Account No. Special";
        VendorCompany: Record Vendor;
        ContactCompany: Record Contact;
        ContBusRelCompany: Record "Contact Business Relation";
        MarketingSetup: Record "Marketing Setup";
        SalesPerson: Record "Salesperson/Purchaser";
        SalespersonComp: Record "Salesperson/Purchaser";
        MyRecRef: RecordRef;
        VendorExists: Boolean;

    procedure SynchContactBatch(ContactNo: Code[20])
    //batch for synchronize Contacts for all Synch Companies
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.findset() then
            repeat
                SynchContact(ContactNo, POICompany.Mandant);
            until POICompany.Next() = 0;
    end;

    procedure SynchContact(ContactNo: Code[20]; NewCompany: Code[50])
    //Function to synchronize Contact Data
    var
        AccountCompanySetting: Record "POI Account Company Setting";
    begin
        Contact.Get(ContactNo);
        Contact2Company.ChangeCompany(NewCompany);
        Contact2Company := Contact;
        IF Contact2Company.Get(ContactNo) then
            Contact2Company.Modify()
        else begin
            Contact2Company.Insert();
            IF not AccountCompanySetting.Get(0, ContactNo, NewCompany) then begin
                AccountCompanySetting."Account No." := ContactNo;
                AccountCompanySetting."Account Type" := AccountCompanySetting."Account Type"::Contact;
                AccountCompanySetting."Company Name" := NewCompany;
                if POICompany.Get(NewCompany) then
                    AccountCompanySetting.Visible := POICompany.Visible;
                AccountCompanySetting.Insert();
            end;
        end;
    end;

    procedure SynchAccText(CustVend: enum "POI VendorCustomer"; NewText: Text[100]; AccNo: code[20]; FieldNo: Integer)
    //Function to synchronize Customer and vendor for Text Fields
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata");
        POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        IF POICompany.FindSet() then
            repeat
                case CustVend of
                    Custvend::Customer:
                        begin
                            Customer.ChangeCompany(POICompany.Mandant);
                            Customer.Get(AccNo);
                            case FieldNo of
                                2:
                                    Customer.Name := CopyStr(NewText, 1, 50);
                                4:
                                    Customer."Name 2" := CopyStr(NewText, 1, 50);
                                5:
                                    Customer.Address := CopyStr(NewText, 1, 50);
                                6:
                                    Customer."Address 2" := CopyStr(NewText, 1, 50);
                                7:
                                    Customer.City := CopyStr(NewText, 1, 30);
                                9:
                                    Customer."Phone No." := CopyStr(NewText, 1, 30);
                                102:
                                    Customer."E-Mail" := CopyStr(NewText, 1, 80);
                                86:
                                    Customer."VAT Registration No." := CopyStr(NewText, 1, 20);
                            end;
                            Customer.Modify();
                        end;
                    CustVend::Vendor:
                        begin
                            case FieldNo of
                                2:
                                    Vendor.Name := CopyStr(NewText, 1, 50);
                                4:
                                    Vendor."Name 2" := CopyStr(NewText, 1, 50);
                                5:
                                    Vendor.Address := CopyStr(NewText, 1, 50);
                                6:
                                    Vendor."Address 2" := CopyStr(NewText, 1, 50);
                                7:
                                    Vendor.City := CopyStr(NewText, 1, 30);
                                9:
                                    Vendor."Phone No." := CopyStr(NewText, 1, 30);
                                102:
                                    Vendor."E-Mail" := CopyStr(NewText, 1, 80);
                                86:
                                    Vendor."VAT Registration No." := CopyStr(NewText, 1, 20);
                            end;
                            Vendor.Modify();
                        end;
                end;
            until POICompany.Next() = 0;
    end;

    procedure SynchAccCode(CustVend: Enum "POI VendorCustomer"; NewCode: Code[50]; AccNo: code[20]; FieldNo: Integer)
    //Function to synchronize Customer and vendor for Code Fields
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata");
        POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        IF POICompany.FindSet() then
            repeat
                CASE CustVend of
                    CustVend::Customer:
                        begin
                            Customer.ChangeCompany(POICompany.Mandant);
                            Customer.Get(AccNo);
                            case FieldNo of
                                24:
                                    Customer."Language Code" := CopyStr(NewCode, 1, 10);
                                35:
                                    Customer."Country/Region Code" := CopyStr(NewCode, 1, 10);
                                91:
                                    Customer."Post Code" := CopyStr(NewCode, 1, 20);
                            end;
                            Customer.Modify();
                        end;
                    CustVend::Vendor:
                        Begin
                            Vendor.ChangeCompany(POICompany.Mandant);
                            Vendor.Get(AccNo);
                            case FieldNo of
                                24:
                                    Vendor."Language Code" := CopyStr(NewCode, 1, 10);
                                35:
                                    Vendor."Country/Region Code" := CopyStr(NewCode, 1, 10);
                                91:
                                    Vendor."Post Code" := CopyStr(NewCode, 1, 20);
                            end;
                            Vendor.Modify();
                        End;
                end;
            until POICompany.Next() = 0;
    end;

    procedure SynchAccount(AccountNo: Code[20]; AccountType: enum "POI VendorCustomer"; CompanyName: code[50])
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        POICompany.SetRange("Basic Company", false);
        case AccountType of
            accountType::Customer:
                begin
                    Customer.ChangeCompany(CompanyName);
                    if Customer.Get(AccountNo) then
                        if POICompany.FindSet() then
                            repeat
                                CustomerComp.ChangeCompany(POICompany.Mandant);
                                if CustomerComp.Get(AccountNo) then begin
                                    CustomerComp.Name := Customer.Name;
                                    CustomerComp."Name 2" := Customer."Name 2";
                                    CustomerComp.Modify();
                                end else begin
                                    CustomerComp := Customer;
                                    CustomerComp.Insert()
                                end;
                            until POICompany.Next() = 0;
                end;
            accountType::Vendor:
                begin
                    Vendor.ChangeCompany(CompanyName);
                    if Vendor.Get(AccountNo) then
                        if POICompany.FindSet() then
                            repeat
                                VendorComp.ChangeCompany(POICompany.Mandant);
                                if VendorComp.Get(AccountNo) then begin
                                    VendorComp.Name := Vendor.Name;
                                    VendorComp."Name 2" := Vendor."Name 2";
                                    VendorComp.Modify();
                                end else begin
                                    VendorComp := Vendor;
                                    VendorComp.Insert()
                                end;
                            until POICompany.Next() = 0;
                end;
            accountType::Contact:
                begin
                    Contact.ChangeCompany(CompanyName);
                    if Contact.Get(AccountNo) then
                        if POICompany.FindSet() then
                            repeat
                                ContactComp.ChangeCompany(POICompany.Mandant);
                                if ContactComp.Get(AccountNo) then begin
                                    ContactComp.Name := Contact.Name;
                                    ContactComp."Name 2" := Contact."Name 2";
                                    ContactComp.Modify();
                                end else begin
                                    ContactComp := Contact;
                                    ContactComp.Insert()
                                end;
                            until POICompany.Next() = 0;
                end;
            AccountType::Salesperson:
                begin
                    SalesPerson.ChangeCompany(CompanyName);
                    POICompany.SetRange("Basic Company");
                    if SalesPerson.Get(AccountNo) then
                        if POICompany.FindSet() then
                            repeat
                                SalespersonComp.ChangeCompany(POICompany.Mandant);
                                if SalespersonComp.Get(AccountNo) then begin
                                    SalespersonComp := SalesPerson;
                                    SalespersonComp.Modify();
                                end else begin
                                    SalespersonComp := SalesPerson;
                                    SalespersonComp.Insert();
                                end;
                            until POICompany.Next() = 0;
                end;
        end;
    end;

    procedure GetCompanyContactFromAccount(AccountNo: code[20]; AccountType: option Customer,Vendor): Code[20]
    var

    begin
        ContBusRel.Reset();
        ContBusRel.setrange("No.", AccountNo);
        case AccountType of
            accountType::Customer:
                ContBusRel.setrange("Link to Table", 18);
            AccountType::Vendor:
                ContBusRel.setrange("Link to Table", 23);
        end;
        if ContBusRel.FindSet() then
            repeat
                if Contact.Get(ContBusRel."Contact No.") and (Contact.Type = Contact.Type::Company) then
                    exit(Contact."No.");
            until ContBusRel.Next() = 0;
        exit('');
    end;

    procedure SynchTableField(MyTableID: Integer; MyFieldID: Integer; AccountNo: code[20]; NewValue: Variant; OwnCompany: Boolean; AllCompanies: Boolean)
    //Synchronisieren von einzelnen feldern in den Konten (Debitor, Kreditor, Kontakt)
    var
        MyFieldRef: FieldRef;
        MyFieldRef2: FieldRef;
    begin
        Clear(MyRecRef);
        MyRecRef.Open(MyTableID);
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if not AllCompanies then
            POICompany.SetRange(Mandant, CompanyName())
        else
            if not OwnCompany then
                POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        if POICompany.FindSet() then
            repeat
                MyRecRef.ChangeCompany(POICompany.Mandant);
                MyFieldRef := MyRecRef.Field(1);
                MyFieldRef2 := MyRecRef.Field(MyFieldID);
                MyFieldRef.Value := AccountNo;
                if MyRecRef.Find('=') then begin
                    MyFieldRef2.Value := NewValue;
                    MyRecRef.Modify();
                end;
            until POICompany.Next() = 0;
    end;

    procedure SynchContactTableFieldFromAccount(MyTableID: Integer; MyFieldID: Integer; AccountNo: code[20]; NewValue: Variant; OwnCompany: Boolean; Allcompanies: Boolean)
    //Synchronisieren von einzelnen Feldern für den Kontakt von Debitor, Kreditor
    begin
        ContBusRel.Reset();
        ContBusRel.SetRange("No.", AccountNo);
        case MyTableID of
            18:
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
            23:
                ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
        end;
        if ContBusRel.FindFirst() then
            SynchTableField(5050, MyFieldID, ContBusRel."Contact No.", NewValue, OwnCompany, Allcompanies);
    end;

    procedure SynchAccountAndContact(MyTableID: Integer; MyFieldID: Integer; AccountNo: code[20]; NewValue: Variant; OwnCompany: Boolean; Allcompanies: Boolean)
    begin
        SynchTableField(MyTableID, MyFieldID, AccountNo, NewValue, OwnCompany, Allcompanies);
        Commit();
        SynchContactTableFieldFromAccount(MyTableID, MyFieldID, AccountNo, NewValue, OwnCompany, Allcompanies);
    end;

    procedure SynchContactAndAccount(MyFieldID: Integer; AccountNo: Code[20]; NewValue: Variant; Type: Option Company,Person; Allcompanies: Boolean)
    begin
        case Type of
            Type::Company:
                begin
                    ContBusRel.Reset();
                    ContBusRel.setrange("No.", AccountNo);
                    ContBusRel.SetFilter("Business Relation Code", '%1|%2', 'DEB', 'KRE');
                    ContBusRel.SetFilter("Link to Table", '%1|%2', 18, 23);
                    if ContBusRel.FindSet() then
                        repeat
                            //prüfen ob es einen IsVendorCustomer gibt
                            case ContBusRel."Link to Table" of
                                Contbusrel."Link to Table"::Customer:
                                    begin
                                        Customer.Get(ContBusRel."No.");
                                        IF Customer."POI Is Vendor" <> '' then
                                            SynchTableField(18, MyFieldID, ContBusRel."No.", NewValue, false, Allcompanies);
                                    end;
                                Contbusrel."Link to Table"::Vendor:
                                    begin
                                        Vendor.Get(ContBusRel."No.");
                                        IF Vendor."POI Is Customer" <> '' then
                                            SynchTableField(23, MyFieldID, ContBusRel."No.", NewValue, false, Allcompanies);
                                    end;
                            end;
                            SynchTableField(5050, MyFieldID, ContBusRel."Contact No.", NewValue, false, Allcompanies);
                        until ContBusRel.next() = 0;
                end;
            Type::Person:
                SynchTableField(5050, MyFieldID, AccountNo, NewValue, false, Allcompanies);
        end;
    end;

    procedure SynchIsCustomerVendor(MyTableID: integer; MyFieldID: Integer; AccountNo: code[20]; NewValue: Variant)
    var
        MyFieldRef: FieldRef;
        MyFieldRef2: FieldRef;
    begin
        MyRecRef.Open(MyTableID);
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                MyRecRef.ChangeCompany(POICompany.Mandant);
                MyFieldRef := MyRecRef.Field(1);
                MyFieldRef2 := MyRecRef.Field(MyFieldID);
                MyFieldRef.Value := AccountNo;
                if MyRecRef.Find('=') then begin
                    MyFieldRef2.Value := NewValue;
                    MyRecRef.Modify();
                end;
            until POICompany.Next() = 0;
    end;

    procedure SynchCustVendGroupCust(FieldNo: Integer; AccountNo: Code[20]; AccountNo2: Code[20]; AccountNo3: Code[20]; NewValue: Variant; OwnCompany: Boolean; GroupCust: Boolean; CustVend: Boolean; SynchAccAndContact: Boolean; SynchAccount: Boolean; Allcompanies: Boolean)
    begin
        //Synchronisation der Debiitorendaten in die bestehenden Mandanten
        //Debitorendaten und Kontaktdaten
        if SynchAccAndContact then
            SynchAccountAndContact(18, FieldNo, AccountNo, NewValue, false, Allcompanies);
        //nur Debitorendaten
        if SynchAccount then
            SynchTableField(18, FieldNo, AccountNo, NewValue, false, Allcompanies);
        //Synchronisation der Daten des zugehörigen Debitoren
        //Debitorendaten und Kontakt
        if (AccountNo2 <> '') and CustVend and SynchAccAndContact then
            SynchAccountAndContact(23, FieldNo, AccountNo2, NewValue, true, Allcompanies);
        //nur Debitorendaten
        if (AccountNo2 <> '') and CustVend and SynchAccount then
            SynchTableField(23, FieldNo, AccountNo2, NewValue, true, Allcompanies);
        //Synchronisation der Debitorendaten des GruppenDebitors
        //Debitorendaten und Kontaktdaten   
        if (AccountNo3 <> '') and GroupCust and SynchAccAndContact then
            SynchAccountAndContact(18, FieldNo, AccountNo3, NewValue, true, Allcompanies);
        //nur Debitorendaten
        if (AccountNo3 <> '') and GroupCust and SynchAccount then
            SynchTableField(18, FieldNo, AccountNo3, NewValue, true, Allcompanies);

        //Fals der Debitor als Gruppendebitor hinterlegt ist
        //Debitorendaten und Kontaktdaten 
        if CheckGroupAccount(AccountNo, 0) and SynchAccAndContact then
            SynchCustFromGroupCustomer(18, FieldNo, AccountNo, NewValue, true, true, Allcompanies);
        //nur Debitorendaten
        if CheckGroupAccount(AccountNo, 0) and SynchAccount then
            SynchCustFromGroupCustomer(18, FieldNo, AccountNo, NewValue, true, false, Allcompanies);
    end;

    procedure SynchVendCustGroupVendor(FieldNo: Integer; AccountNo: Code[20]; AccountNo2: Code[20]; AccountNo3: Code[20]; NewValue: Variant; OwnCompany: Boolean; GroupCust: Boolean; CustVend: Boolean; SynchAccAndContact: Boolean; SynchAccount: Boolean; Allcompanies: Boolean)
    begin
        //Synchronisation der Kreditorendaten in die bestehenden Mandanten
        //Kreditorendaten und Kontaktdaten
        if SynchAccAndContact then
            SynchAccountAndContact(23, FieldNo, AccountNo, NewValue, false, Allcompanies);
        //nur Kreditorendaten
        if SynchAccount then
            SynchTableField(23, FieldNo, AccountNo, NewValue, false, Allcompanies);

        //Synchronisation der Daten des zugehörigen Debitoren
        //Debitorendaten und Kontakt
        if (AccountNo2 <> '') and CustVend and SynchAccAndContact then
            SynchAccountAndContact(18, FieldNo, AccountNo2, NewValue, true, Allcompanies);
        //nur Debitorendaten
        if (AccountNo2 <> '') and CustVend and SynchAccount then
            SynchTableField(18, FieldNo, AccountNo2, NewValue, true, Allcompanies);

        //Synchronisation der Kreditorendaten des Gruppenkreditors
        //Kreditorendaten und Kontaktdaten
        if (AccountNo3 <> '') and GroupCust and SynchAccAndContact then
            SynchAccountAndContact(23, FieldNo, AccountNo3, NewValue, true, Allcompanies);
        //nur Kreditorendaten
        if (AccountNo3 <> '') and GroupCust and SynchAccount then
            SynchTableField(23, FieldNo, AccountNo3, NewValue, true, Allcompanies);

        //Fals der Kreditor als Gruppenkreditor hinterlegt ist
        //Kreditorendaten und Kontaktdaten
        if CheckGroupAccount(AccountNo, 1) and SynchAccAndContact then
            SynchVendFromGroupVendor(23, FieldNo, AccountNo, NewValue, true, true, Allcompanies);
        //nur Kreditorendaten
        if CheckGroupAccount(AccountNo, 1) and SynchAccount then
            SynchVendFromGroupVendor(23, FieldNo, AccountNo, NewValue, true, false, Allcompanies);
    end;

    procedure SynchfieldVendorCustomer(FieldNo: Integer; AccountNo: Code[20]; AccountType: Option Customer,Vendor; NewValue: Variant; OwnCompany: Boolean; SynchAccAndContact: Boolean; SynchAccount: Boolean; Allcompanies: Boolean)
    begin
        if AccountNo = '' then exit;
        case AccountType of
            AccountType::Vendor:
                begin
                    //Synch Kreditordaten des zugehörigen Kreditors zum Debitor
                    if SynchAccAndContact then
                        SynchAccountAndContact(23, FieldNo, AccountNo, NewValue, OwnCompany, Allcompanies);
                    if SynchAccount then
                        SynchTableField(23, FieldNo, AccountNo, NewValue, OwnCompany, Allcompanies);
                end;
            AccountType::Customer:
                begin
                    //Synch Debitordaten des zugehörigen Debitors zum Kreditor
                    if SynchAccAndContact then
                        SynchAccountAndContact(18, FieldNo, AccountNo, NewValue, OwnCompany, Allcompanies);
                    if SynchAccount then
                        SynchTableField(18, FieldNo, AccountNo, NewValue, OwnCompany, Allcompanies);
                end;
        end; //case
    end;

    // procedure SynchComment(AccountNo: Code[20]; Type: Option Customer,Vendor)
    // var
    //     POICompany: Record "POI Company";
    //     Comment: Record "Comment Line";
    //     Comment2: Record "Comment Line";
    // begin
    //     case Type of
    //         type::Customer:
    //             Comment.SetRange("Table Name", Comment."Table Name"::Customer);
    //         Type::Vendor:
    //             Comment.SetRange("Table Name", Comment."Table Name"::Vendor);
    //     end;
    //     Comment.SetRange("No.", AccountNo);
    //     POICompany.Reset();
    //     POICompany.SetRange("Synch Masterdata", true);
    //     POICompany.SetFilter(Mandant, '<>%1', CompanyName());
    //     if POICompany.FindSet() then
    //         repeat
    //             Comment2.ChangeCompany(POICompany.Mandant);
    //             if Type = Type::Customer then
    //                 Comment2.SetRange("Table Name", Comment2."Table Name"::Customer)
    //             else
    //                 Comment2.SetRange("Table Name", Comment2."Table Name"::Vendor);
    //             Comment2.SetRange("No.", AccountNo);
    //             Comment2.DeleteAll();
    //             if Comment.FindSet() then
    //                 repeat
    //                     Comment2 := Comment;
    //                     Comment2.Insert();
    //                 until Comment.Next() = 0;
    //         until POICompany.Next() = 0;
    // end;

    procedure SynchCommentFromAccountToAccont(FromAccountNo: Code[20]; FromType: Option Customer,Vendor; ToAccountNo: code[20]; ToType: Option Customer,Vendor; ownCompany: Boolean)
    var
        Comment2: Record "Comment Line";
    begin
        case FromType of
            Fromtype::Customer:
                Comment.SetRange("Table Name", Comment."Table Name"::Customer);
            FromType::Vendor:
                Comment.SetRange("Table Name", Comment."Table Name"::Vendor);
        end;
        Comment.Reset();
        Comment.SetRange("No.", FromAccountNo);
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if not OwnCompany then
            POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        if POICompany.FindSet() then
            repeat
                Comment2.ChangeCompany(POICompany.Mandant);
                if ToType = ToType::Customer then
                    Comment2.SetRange("Table Name", Comment2."Table Name"::Customer)
                else
                    Comment2.SetRange("Table Name", Comment2."Table Name"::Vendor);
                Comment2.SetRange("No.", ToAccountNo);
                Comment2.DeleteAll();
                if Comment.FindSet() then
                    repeat
                        Comment2 := Comment;
                        if ToType = ToType::Customer then
                            Comment2."Table Name" := Comment2."Table Name"::Customer
                        else
                            Comment2."Table Name" := Comment2."Table Name"::Vendor;
                        Comment2."No." := ToAccountNo;
                        Comment2.Insert();
                    until Comment.Next() = 0;
            until POICompany.Next() = 0;
    end;

    procedure SynchSpecialIDLineAfterValidate(var AccountNos: Record "POI Account No. Special")
    var
        ToAccountNo: Code[20];
    begin
        AccountNos2.Reset();
        case AccountNos.AccountType of
            AccountNos.AccountType::Customer:
                begin
                    Customer.Get(AccountNos."Account No.");
                    ToAccountNo := Customer."POI Is Vendor";
                    AccountNos2.SetRange(AccountType, AccountNos.AccountType::Vendor);
                end;
            AccountNos.AccountType::Vendor:
                begin
                    Vendor.Get(AccountNos."Account No.");
                    ToAccountNo := Vendor."POI Is Customer";
                    AccountNos2.SetRange(AccountType, AccountNos.AccountType::Customer);
                end;
        end;
        AccountNos2.Reset();
        AccountNos2.SetRange("Account No.", ToAccountNo);
        if AccountNos2.FindSet() then
            repeat
                AccountNos2."Special No. Type" := AccountNos."Special No. Type";
                AccountNos2."Special No. Code" := AccountNos."Special No. Code";
                AccountNos2.Modify();
            until AccountNos2.Next() = 0;
    end;

    procedure SynchSpecialID(var AccountNos: Record "POI Account No. Special") //AccountNo: Code[20]; Type: Option Contact,Customer,Vendor)
    var
        AccountNos1: Record "POI Account No. Special";
        ToAccountNo: Code[20];
    begin
        case AccountNos.AccountType of
            AccountNos.AccountType::Customer:
                begin
                    Customer.Get(AccountNos."Account No.");
                    ToAccountNo := Customer."POI Is Vendor";
                end;
            AccountNos.AccountType::Vendor:
                begin
                    Vendor.Get(AccountNos."Account No.");
                    ToAccountNo := Vendor."POI Is Customer";
                end;
        end;
        AccountNos2.Reset();
        AccountNos2.SetRange("Account No.", ToAccountNo);
        case AccountNos.AccountType of
            AccountNos.AccountType::Customer:
                AccountNos2.SetRange(AccountType, AccountNos.AccountType::Vendor);
            AccountNos.AccountType::Vendor:
                AccountNos2.SetRange(AccountType, AccountNos.AccountType::Customer);
        end;
        AccountNos2.DeleteAll();
        AccountNos1.Reset();
        AccountNos1.SetRange("Account No.", AccountNos."Account No.");
        case AccountNos.AccountType of
            AccountNos.AccountType::Customer:
                AccountNos1.SetRange(AccountType, AccountNos1.AccountType::Customer);
            AccountNos.AccountType::Vendor:
                AccountNos1.SetRange(AccountType, AccountNos1.AccountType::Vendor);
        end;
        if AccountNos.FindSet() then
            repeat
                AccountNos2 := AccountNos;
                case AccountNos.AccountType of
                    AccountNos.AccountType::Vendor:
                        AccountNos2.AccountType := AccountNos2.AccountType::Customer;
                    AccountNos.AccountType::Customer:
                        AccountNos2.AccountType := AccountNos2.AccountType::Vendor;
                end;
                AccountNos2."Account No." := ToAccountNo;
                AccountNos2.Insert();
            until AccountNos.Next() = 0;
    end;

    procedure CheckGroupAccount(AccountNo: Code[20]; AccountType: Option Customer,Vendor): Boolean
    begin
        case AccountType of
            AccountType::Customer:
                begin
                    Customer.Reset();
                    Customer.setrange("POI Group Customer", AccountNo);
                    exit(Customer.Count() > 0);
                end;
            AccountType::Vendor:
                begin
                    Vendor.Reset();
                    Vendor.setrange("POI Vendor Group Code");
                    exit(Vendor.Count() > 0)
                end;
        end;
        exit(false);
    end;

    procedure SynchCustFromGroupCustomer(TableID: integer; FieldNo: integer; CustNo: Code[20]; NewValue: Variant; OwnCompany: Boolean; AccountAndContact: Boolean; Allcompanies: Boolean)
    begin
        if CustNo = '' then exit;
        Customer.Reset();
        Customer.SetRange("POI Group Customer", CustNo);
        if Customer.FindSet() then
            repeat
                if AccountAndContact then
                    SynchAccountAndContact(18, FieldNo, Customer."No.", NewValue, true, Allcompanies)
                else
                    SynchTableField(18, FieldNo, Customer."No.", NewValue, true, Allcompanies);
            until Customer.Next() = 0;
    end;

    procedure SynchVendFromGroupVendor(TableID: integer; FieldNo: integer; VendNo: Code[20]; NewValue: Variant; OwnCompany: Boolean; AccountAndContact: Boolean; Allcompanies: Boolean)
    begin
        if VendNo = '' then exit;
        Vendor.Reset();
        Vendor.SetRange("POI Vendor Group Code", VendNo);
        if Vendor.FindSet() then
            repeat
                if AccountAndContact then
                    SynchAccountAndContact(TableID, FieldNo, Vendor."No.", NewValue, true, Allcompanies)
                else
                    SynchTableField(TableID, FieldNo, Vendor."No.", NewValue, true, Allcompanies);
            until Vendor.Next() = 0;
    end;

    procedure SynchVendortypeForvendor(var Vendor: Record Vendor; GroupVendor: Boolean)
    var

    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if not GroupVendor then
            POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        if POICompany.FindSet() then
            repeat
                VendorExists := false;
                VendorCompany.ChangeCompany(POICompany.Mandant);
                if GroupVendor then begin
                    VendorCompany.Get(Vendor."POI Vendor Group Code");
                    VendorExists := true;
                end else begin
                    VendorCompany.Get(Vendor."No.");
                    VendorExists := true;
                end;
                if VendorExists then begin
                    VendorCompany."POI Supplier of Goods" := Vendor."POI Supplier of Goods";
                    VendorCompany."POI Carrier" := Vendor."POI Carrier";
                    VendorCompany."POI Warehouse Keeper" := Vendor."POI Warehouse Keeper";
                    VendorCompany."POI Small Vendor" := Vendor."POI Small Vendor";
                    VendorCompany."POI Diverse Vendor" := Vendor."POI Diverse Vendor";
                    VendorCompany."POI Customs Agent" := Vendor."POI Customs Agent";
                    VendorCompany."POI Shipping Company" := Vendor."POI Shipping Company";
                    VendorCompany."POI Tax Representative" := Vendor."POI Tax Representative";
                    VendorCompany.modify();
                end;
            until POICompany.Next() = 0;
        POICompany.Setrange(Mandant);
        if POICompany.FindSet() then
            repeat
                VendorExists := false;
                VendorCompany.ChangeCompany(POICompany.Mandant);
                if GroupVendor then begin
                    VendorCompany.Get(Vendor."POI Vendor Group Code");
                    VendorExists := true;
                end else begin
                    VendorCompany.Get(Vendor."No.");
                    VendorExists := true;
                end;
                if VendorExists then begin
                    ContBusRelCompany.ChangeCompany(POICompany.Mandant);
                    MarketingSetup.ChangeCompany(POICompany.Mandant);
                    MarketingSetup.Get();
                    ContBusRelCompany.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Vendors");
                    ContBusRelCompany.SetRange("Link to Table", ContBusRelCompany."Link to Table"::Vendor);
                    if GroupVendor then
                        ContBusRelCompany.SetRange("No.", Vendor."POI Vendor Group Code")
                    else
                        ContBusRelCompany.SetRange("No.", Vendor."No.");
                    if ContBusRelCompany.FindFirst() then begin
                        ContactCompany.ChangeCompany(POICompany.Mandant);
                        if ContactCompany.Get(ContBusRelCompany."Contact No.") then begin
                            ContactCompany."POI Supplier of Goods" := Vendor."POI Supplier of Goods";
                            ContactCompany."POI Carrier" := Vendor."POI Carrier";
                            ContactCompany."POI Warehouse Keeper" := Vendor."POI Warehouse Keeper";
                            ContactCompany."POI Small Vendor" := Vendor."POI Small Vendor";
                            ContactCompany."POI Diverse Vendor" := Vendor."POI Diverse Vendor";
                            ContactCompany."POI Customs Agent" := Vendor."POI Customs Agent";
                            ContactCompany."POI Shipping Company" := Vendor."POI Shipping Company";
                            //ContactCompany."POI Tax Representative" := Vendor."POI Tax Representative";
                            ContactCompany.modify();
                        end;
                    end;
                end;
            until POICompany.Next() = 0;
    end;

    procedure SynchVendortypeForVendorAndGroupVendor(var Vendor: Record Vendor)
    var
        Vendor2: Record Vendor;
    begin
        if Vendor."POI Vendor Group Code" <> '' then
            SynchVendortypeForvendor(Vendor, true);
        SynchVendortypeForvendor(Vendor, false);
        //Synchronisieren der Gruppenmitglieder
        Vendor2.SetRange("POI Vendor Group Code", Vendor."No.");
        if Vendor2.FindSet() then
            repeat
                SynchVendortypeForvendorGroupMembers(Vendor, Vendor2);
            until Vendor2.Next() = 0;
    end;

    procedure SynchVendortypeForvendorGroupMembers(var Vendor: Record Vendor; var Vendor2: Record Vendor);
    begin
        MarketingSetup.Get();
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        //POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        if POICompany.FindSet() then
            repeat
                VendorCompany.ChangeCompany(POICompany.Mandant);
                VendorCompany.Get(Vendor2."No.");
                VendorCompany."POI Warehouse Keeper" := Vendor."POI Warehouse Keeper";
                VendorCompany."POI Supplier of Goods" := Vendor."POI Supplier of Goods";
                VendorCompany."POI Carrier" := Vendor."POI Carrier";
                VendorCompany."POI Small Vendor" := Vendor."POI Small Vendor";
                VendorCompany."POI Diverse Vendor" := Vendor."POI Diverse Vendor";
                VendorCompany."POI Customs Agent" := Vendor."POI Customs Agent";
                VendorCompany."POI Shipping Company" := Vendor."POI Shipping Company";
                VendorCompany."POI Tax Representative" := Vendor."POI Tax Representative";
                VendorCompany.Modify();
                Contact.ChangeCompany(POICompany.Mandant);
                ContBusrel.ChangeCompany(POICompany.Mandant);
                ContBusrel.Reset();
                ContBusrel.SetRange("Link to Table", ContBusrel."Link to Table"::Vendor);
                ContBusrel.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Vendors");
                ContBusrel.Setrange("No.", VendorCompany."No.");
                if ContBusrel.FindFirst() then
                    if Contact.Get(ContBusrel."Contact No.") then begin
                        Contact."POI Warehouse Keeper" := Vendor."POI Warehouse Keeper";
                        Contact."POI Supplier of Goods" := Vendor."POI Supplier of Goods";
                        Contact."POI Carrier" := Vendor."POI Carrier";
                        Contact."POI Small Vendor" := Vendor."POI Small Vendor";
                        Contact."POI Diverse Vendor" := Vendor."POI Diverse Vendor";
                        Contact."POI Customs Agent" := Vendor."POI Customs Agent";
                        Contact."POI Shipping Company" := Vendor."POI Shipping Company";
                        Contact."POI Tax Representative" := Vendor."POI Tax Representative";
                        Contact.Modify();
                    end;
            until POICompany.Next() = 0;
    end;

    procedure GetGroupAccountContactNo(AccountNo: Code[20]; Type: option Customer,Vendor; NewValue: Variant): Code[20]
    begin
        MarketingSetup.Get();
        case Type of
            Type::Vendor:
                begin
                    Vendor.Get(AccountNo);
                    ContBusRel.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Vendors");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Vendor);
                    ContBusRel.SetRange("No.", NewValue);
                end;
            Type::Customer:
                begin
                    Customer.Get(AccountNo);
                    ContBusRel.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                    ContBusRel.SetRange("No.", NewValue);
                end;
        end;
        if ContBusRel.FindFirst() then
            exit(ContBusRel."Contact No.")
        else
            exit('');
    end;

    procedure SynchSalesperson(SalespersonCode: Code[20]; OwnCompany: Boolean)
    begin
        SalesPerson.Get(SalespersonCode);
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if not OwnCompany then
            POICompany.SetFilter(Mandant, '<>%1', CompanyName());
        if POICompany.FindSet() then
            repeat
                SalespersonComp.ChangeCompany(POICompany.Mandant);
                if SalespersonComp.Get(SalespersonCode) then begin
                    SalespersonComp.Name := SalesPerson.Name;
                    SalespersonComp.modify();
                end else begin
                    SalespersonComp := SalesPerson;
                    SalespersonComp.Insert();
                end;
            until POICompany.Next() = 0;
    end;

}