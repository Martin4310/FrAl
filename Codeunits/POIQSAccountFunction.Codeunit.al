codeunit 50012 "POI QS Account Function"
{
    procedure CheckQSAccount(AccountNo: Code[20])
    var
        lr_contact: Record Contact;
        OperatingCompanyExists: Boolean;
        TXT_NewVendTxt: Label 'Kreditoren Prüfung zur Neuanlage gilt nicht für Port International GmbH.';
    begin
        Clear(newAccountGL);
        Clear(newAccountGeneral);
        Vendor.Get(AccountNo);
        IF Vendor."POI Small Vendor" THEN
            ERROR(ERR_NotSmallVendTxt);
        OperatingCompanyExists := AccCompSetting.OperationCompExists(Vendor."No.", AccCompSetting."Account Type"::Vendor);
        lr_ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        lr_ContBusRel.SETRANGE("Link to Table", lr_ContBusRel."Link to Table"::Vendor);
        lr_ContBusRel.SETRANGE("No.", AccountNo);
        IF lr_ContBusRel.FIND('-') THEN
            IF lr_Contact.GET(lr_ContBusRel."Contact No.") THEN;
        if OperatingCompanyExists then BEGIN
            //Kreditor Pflichfelder
            //IF (Uppercase(COMPANYNAME()) = POICompany.GetBasicCompany()) THEN BEGIN
            lr_Qualitaetssicherung.RESET();
            lr_Qualitaetssicherung.SETRANGE("No.", AccountNo);
            lr_Qualitaetssicherung.SETRANGE("Source Type", lr_Qualitaetssicherung."Source Type"::Vendor);
            lr_Qualitaetssicherung.SETFILTER("Vend-Cust-LFB created", '<>%1', 0DT);
            IF lr_Qualitaetssicherung.FIND('-') THEN BEGIN
                FieldsPart();
                QSFieldsPart2();
                CreateRelPrintDoc(Vendor."No.");
                KredDebAnf(false, Vendor."No.", 0);
                if POIFunction.UserInWindowsRole('GL') then begin
                    newAccountGL.SetTableView(lr_Qualitaetssicherung);
                    newAccountGL.Run();
                end else begin
                    newAccountGeneral.SetTableView(lr_Qualitaetssicherung);
                    newAccountGeneral.RUN();
                end;
            END ELSE BEGIN
                //alte Kreditoren mit eingetragenen Mandanten, die wieder freigeschaltet werden sollen:
                IF NOT lr_Qualitaetssicherung.GET(Vendor."No.", lr_Qualitaetssicherung."Source Type"::Vendor) THEN begin
                    QSLine();
                    WFMgt.TaskCreateAccount(lr_Qualitaetssicherung.RecordId, '', 'VENDORQS', lr_Qualitaetssicherung."No.", '');
                    KredDebAnf(true, Vendor."No.", 0);
                end;
                Fieldspart();
                QSFieldsPart1();
                CreateRelPrintDoc(Vendor."No.");
                SetQSFilter();
                if POIFunction.UserInWindowsRole('GL') then begin
                    newAccountGL.SetTableView(lr_Qualitaetssicherung);
                    newAccountGL.Run();
                end else begin
                    newAccountGeneral.SetTableView(lr_Qualitaetssicherung);
                    newAccountGeneral.RUN();
                end;
            end;
            //END;
        END ELSE
            if AccCompSetting.BasicCompExists(lr_contact."No.", AccCompSetting."Account Type"::Contact) and not OperatingCompanyExists then
                //wenn nur PI GmbH keine Prüfung:
                MESSAGE(TXT_NewVendTxt)
            //alte Kreditoren ohne eingetragene Mandanten, die wieder freigeschaltet werden sollen:
            ELSE
                if not OperatingCompanyExists then begin
                    //Kreditor Pflichfelder
                    //IF (COMPANYNAME() = POICompany.GetBasicCompany()) THEN BEGIN
                    lr_Qualitaetssicherung.RESET();
                    lr_Qualitaetssicherung.SETRANGE("No.", Vendor."No.");
                    lr_Qualitaetssicherung.SETRANGE("Source Type", lr_Qualitaetssicherung."Source Type"::Vendor);
                    lr_Qualitaetssicherung.SETFILTER("Vend-Cust-LFB created", '=%1', 0DT);
                    lr_Qualitaetssicherung.SETRANGE("Reactivate Old Vendor", TRUE);
                    IF NOT lr_Qualitaetssicherung.FIND('-') THEN BEGIN
                        QSLine();
                        //Anlegen Workflow für QS 
                        WFMgt.TaskCreateAccount(lr_Qualitaetssicherung.RecordId, '', 'VENDORQS', lr_Qualitaetssicherung."No.", '');
                        KredDebAnf(true, Vendor."No.", 0);
                    END;
                    Fieldspart();
                    QSFieldsPart1();
                    CreateRelPrintDoc(Vendor."No.");
                    SetQSFilter();
                    if POIFunction.UserInWindowsRole('GL') then begin
                        newAccountGL.SetTableView(lr_Qualitaetssicherung);
                        newAccountGL.Run();
                    end else begin
                        newAccountGeneral.SetTableView(lr_Qualitaetssicherung);
                        newAccountGeneral.RUN();
                    end;
                END;
    end;

    procedure FieldsPart()
    begin

        IF Vendor.Address = '' THEN
            l_Adresse := 'Adresse /';
        IF Vendor."Post Code" = '' THEN
            l_PLZ := 'PLZ /';
        IF Vendor.City = '' THEN
            l_Ort := 'Ort /';
        IF Vendor."Country/Region Code" = '' THEN
            l_Land := 'Land /';
        IF Vendor."POI Amtsgericht" = Vendor."POI Amtsgericht"::registered THEN BEGIN
            IF Vendor."POI Commercial Register No." = '' THEN
                l_Handelsregnr := 'Handelsregisternr. /';
            IF Vendor."POI County Court" = '' THEN
                l_Eintragungsort := 'Eintragungsort /';
        END;
        IF Vendor."Payment Terms Code" = '' THEN
            l_ZlgBedcode := 'Zahlungsziel /';
        IF NOT (Vendor."POI Customs Agent") AND NOT (Vendor."POI Carrier") AND
          NOT (Vendor."POI Warehouse Keeper") AND NOT (Vendor."POI Supplier of Goods") AND
          NOT (Vendor."POI Tax Representative") AND NOT (Vendor."POI Diverse Vendor") AND NOT (Vendor."POI Shipping Company")
        THEN
            l_Kreditortyp := 'Kreditorentyp';
        IF Vendor."POI Amtsgericht" = Vendor."POI Amtsgericht"::registered THEN BEGIN
            IF (l_Name <> '') OR (l_Adresse <> '') OR (l_PLZ <> '') OR (l_Ort <> '') OR (l_Land <> '') OR (l_Handelsregnr <> '') OR (l_Eintragungsort <> '') OR
              (l_ZlgBedcode <> '') OR (l_Kreditortyp <> '')
            THEN
                ERROR(ERR_TestfieldTxt, l_Name, l_Adresse, l_PLZ, l_Ort, l_Land, l_Handelsregnr, l_Eintragungsort, l_ZlgBedcode, l_Kreditortyp);
        END ELSE
            IF (l_Name <> '') OR (l_Adresse <> '') OR (l_PLZ <> '') OR (l_Ort <> '') OR (l_Land <> '') OR (l_ZlgBedcode <> '') OR (l_Kreditortyp <> '') THEN
                ERROR(ERR_TestfieldTxt, l_name, l_Adresse, l_PLZ, l_Ort, l_Land, '', '', l_ZlgBedcode, l_Kreditortyp);

        IF lr_CountryRegion.GET(Vendor."Country/Region Code") THEN
            IF (Vendor."Country/Region Code" = lr_CountryRegion."EU Country/Region Code") THEN BEGIN
                IF Vendor.POIVATRegistrationNos = '' THEN
                    l_UstID := 'USt-IdNr. /';
            end ELSE
                IF lr_CountryRegion."EU Country/Region Code" = '' THEN
                    IF Vendor."Registration No." = '' THEN
                        l_RegNo := 'Steuernummer /';

        IF Vendor."Vendor Posting Group" = '' THEN
            l_VendPostGroup := 'Kreditorenbuchungsgruppe /';
        IF Vendor."Gen. Bus. Posting Group" = '' THEN
            l_GenBusPostGroup := 'Geschäftsbuchungsgruppe /';
        IF Vendor."VAT Bus. Posting Group" = '' THEN
            l_VATPostGroup := 'MwSt.-Geschäftsbuchungsgruppe /';
        IF (Vendor."POI Vorkasse erwünscht Status" < Vendor."POI Vorkasse erwünscht Status"::abgelehnt) AND
          (Vendor."POI Vorkasse erwünscht Status" <> Vendor."POI Vorkasse erwünscht Status"::" ") AND
          (Vendor."POI Kreditlimit" = 0)
        THEN
            l_Kreditlimit := 'Kreditversicherungslimit in € /';
        IF ((Vendor."POI Vorkasse erwünscht Status" > Vendor."POI Vorkasse erwünscht Status"::" ") AND
          (Vendor."POI Vorkasse erwünscht Status" < Vendor."POI Vorkasse erwünscht Status"::abgelehnt)) AND
          (Vendor."POI Credit Insurance No." = '')
        THEN
            l_CofaceEasyNr := 'Coface-Easy-Nr.';
        IF (Vendor."Country/Region Code" = lr_CountryRegion."EU Country/Region Code") THEN BEGIN
            IF (l_UstID <> '') OR (l_VendPostGroup <> '') OR (l_GenBusPostGroup <> '') OR (l_VATPostGroup <> '') OR
              (l_Kreditlimit <> '') OR (l_CofaceEasyNr <> '')
            THEN
                ERROR(ERR_Testfield1Txt, l_UstID, l_VendPostGroup, l_GenBusPostGroup, l_VATPostGroup, l_Kreditlimit, l_CofaceEasyNr);
            IF (Vendor."POI Vorkasse erwünscht Status" = Vendor."POI Vorkasse erwünscht Status"::teilgenehmigt) AND
              (Vendor."POI Kreditlimit" >= Vendor."POI Vorkasse Teilgen. Betrag")
            THEN
                ERROR(ERR_VorkasseTeilTxt, Vendor."POI Vorkasse Teilgen. Betrag");
        END ELSE
            IF (lr_CountryRegion."EU Country/Region Code" = '') THEN BEGIN
                IF (l_RegNo <> '') OR (l_VendPostGroup <> '') OR (l_GenBusPostGroup <> '') OR (l_VATPostGroup <> '') OR
                  (l_Kreditlimit <> '') OR (l_CofaceEasyNr <> '')
                THEN
                    ERROR(ERR_Testfield1Txt, l_RegNo, l_VendPostGroup, l_GenBusPostGroup, l_VATPostGroup, l_Kreditlimit, l_CofaceEasyNr);
                IF (Vendor."POI Vorkasse erwünscht Status" = Vendor."POI Vorkasse erwünscht Status"::teilgenehmigt) AND
                  (Vendor."POI Kreditlimit" >= Vendor."POI Vorkasse Teilgen. Betrag")
                THEN
                    ERROR(ERR_VorkasseTeilTxt, Vendor."POI Vorkasse Teilgen. Betrag");
            END;
    end;

    procedure FieldsPartCust()
    begin
        ErrorTxt := 'Folgende Felder sind Pflichtfelder: /';
        if Customer.Name = '' then
            Error1Txt += 'Name /';
        if Customer."Phone No." = '' then
            Error1Txt += 'Telefonnr. /';
        IF Customer.Address = '' THEN
            Error1Txt += 'Adresse /';
        IF Customer."Post Code" = '' THEN
            Error1Txt += 'PLZ /';
        IF Customer.City = '' THEN
            Error1Txt += 'Ort /';
        IF Customer."Country/Region Code" = '' THEN
            Error1Txt += 'Land /';
        if Customer."Salesperson Code" = '' then
            Error1Txt += 'Verkäufer /';
        if Customer."Document Sending Profile" = '' then
            Error1Txt += 'Belegsendeprofil /';
        IF Customer."POI Amtsgericht" = Customer."POI Amtsgericht"::registered THEN BEGIN
            IF Customer."POI Commercial Register No." = '' THEN
                Error1Txt += 'Handelsregisternr. /';
            IF Customer."POI County Court" = '' THEN
                Error1Txt += 'Eintragungsort /';
        END;
        IF Customer."Payment Terms Code" = '' THEN
            Error1Txt += 'Zahlungsziel /';
        if Customer."Shipment Method Code" = '' then
            Error1Txt += 'Lieferbedingungscode /';
        IF NOT (Customer."POI Goods Customer") AND NOT (Customer."POI Service Customer") THEN
            Error1Txt += 'Debitorentyp /';
        if Error1Txt <> '' then begin
            Errorlbl := ErrorTxt + Error1Txt;
            Error(Errorlbl);
        end;


        IF CountryRegion.GET(Customer."Country/Region Code") THEN
            IF (Customer."Country/Region Code" = CountryRegion."EU Country/Region Code") THEN BEGIN
                IF Customer.POIVATRegistrationNos = '' THEN
                    Error1Txt += 'USt-IdNr. /';
            end ELSE
                IF CountryRegion."EU Country/Region Code" = '' THEN
                    IF Customer."POI Registration No." = '' THEN
                        Error1Txt += 'Steuernummer /';
        IF Customer."Customer Posting Group" = '' THEN
            Error1Txt += 'Kreditorenbuchungsgruppe /';
        IF Customer."Gen. Bus. Posting Group" = '' THEN
            Error1Txt += 'Geschäftsbuchungsgruppe /';
        IF Customer."VAT Bus. Posting Group" = '' THEN
            Error1Txt += 'MwSt.-Geschäftsbuchungsgruppe /';
        IF not Customer."POI No Insurance" and (Customer."POI Credit Ins. Credit Limit" = 0) THEN
            Error1Txt += 'Kreditversicherungslimit in € /';
        if Customer."Tax Area Code" = '' then
            Error1Txt += 'Steuergebietscode';
        //Kreditversicherung
        IF not Customer."POI No Insurance" then begin
            Error1Txt += 'Coface-Easy-Nr.';
            if Customer."POI Credit Insurance No." = '' then
                Error1Txt += 'Kreditornr. Erstversicherer /';
            if Customer."POI Cred. Ins. Limit val. till" = 0D then
                Error1Txt += 'Erstlimit gültig bis: /';
            if (Customer."POI Ins. No. Extra Limit" <> '') then begin
                if (Customer."POI Extra Limit valid to" = 0D) and (Customer."POI Extra Limit" <> 0) then
                    Error1Txt += 'Zusatzlimt gültig bis:';
                if Customer."POI Cred. Ins. Limit val. till" = 0D then
                    Error1Txt += 'Erstlimit gültig bis: /';
            end;
        end;
        if (Customer."POI Internal Credit Limit" <> 0) and (Customer."POI Int. Cred. Limit val. till" = 0D) then
            Error1Txt += 'Kreditlimit intern gültig bis:';
        if Error1Txt <> '' then begin
            Errorlbl := ErrorTxt + Error1Txt;
            Error(Errorlbl);
        end;
    end;


    procedure QSFieldsPart1()
    begin
        IF lr_Qualitaetssicherung.GET(Vendor."No.", lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
            newAccountGeneral.GetNo(Vendor."No.", lr_Qualitaetssicherung."Source Type"::Vendor);
            IF lr_Qualitaetssicherung.Ausnahmegenehmigung = lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt THEN
                IF WORKDATE() > lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf" THEN BEGIN
                    lr_Qualitaetssicherung.Ausnahmegenehmigung := lr_Qualitaetssicherung.Ausnahmegenehmigung::" ";
                    lr_Qualitaetssicherung."Kein Lieferantenfragebogen" := FALSE;
                    lr_Qualitaetssicherung."Stammblatt nicht unterzeichnet" := FALSE;
                    lr_Qualitaetssicherung."Kein gültiger GGAP-Zertifikat" := FALSE;
                    lr_Qualitaetssicherung."Internal credit limit" := FALSE;
                    lr_Qualitaetssicherung."Ausnahmeg. erteilt durch" := '';
                    lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am" := 0D;
                    lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung" := 0D;
                    lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf" := 0D;
                    lr_Qualitaetssicherung."Freigabe für Kreditor" := FALSE;
                    lr_Qualitaetssicherung.MODIFY();
                END;
            IF WORKDATE() > lr_Qualitaetssicherung."Stammblatt gültig bis" THEN BEGIN
                lr_Qualitaetssicherung."Stammblatt nicht unterzeichnet" := FALSE;
                lr_Qualitaetssicherung."Stammblatt gültig bis" := 0D;
            END;
            IF WORKDATE() > lr_Qualitaetssicherung."GGAP-Zertifikat gültig bis" THEN BEGIN
                lr_Qualitaetssicherung."Kein gültiger GGAP-Zertifikat" := FALSE;
                lr_Qualitaetssicherung."GGAP-Zertifikat gültig bis" := 0D;
            END;
            IF WORKDATE() > lr_Qualitaetssicherung."Credit limit int. valid until" THEN BEGIN
                lr_Qualitaetssicherung."Internal credit limit" := FALSE;
                lr_Qualitaetssicherung."Credit limit int. valid until" := 0D;
            END;
        end;
    end;

    procedure QSFieldsPart1Cust()
    begin
        IF Qualitaetssicherung.GET(Customer."No.", Qualitaetssicherung."Source Type"::Customer) THEN BEGIN
            newAccountGeneral.GetNo(Customer."No.", Qualitaetssicherung."Source Type"::Customer);
            IF Qualitaetssicherung.Ausnahmegenehmigung = Qualitaetssicherung.Ausnahmegenehmigung::genehmigt THEN
                IF WORKDATE() > Qualitaetssicherung."Ausnahmegenehmigung Ablauf" THEN BEGIN
                    Qualitaetssicherung.Ausnahmegenehmigung := Qualitaetssicherung.Ausnahmegenehmigung::" ";
                    Qualitaetssicherung."Kein Lieferantenfragebogen" := FALSE;
                    Qualitaetssicherung."Stammblatt nicht unterzeichnet" := FALSE;
                    Qualitaetssicherung."Kein gültiger GGAP-Zertifikat" := FALSE;
                    Qualitaetssicherung."Internal credit limit" := FALSE;
                    Qualitaetssicherung."Ausnahmeg. erteilt durch" := '';
                    Qualitaetssicherung."Ausnahmegenehmigung erteilt am" := 0D;
                    Qualitaetssicherung."Ausnahmegenehmigung Erinnerung" := 0D;
                    Qualitaetssicherung."Ausnahmegenehmigung Ablauf" := 0D;
                    Qualitaetssicherung."Freigabe für Debitor" := FALSE;
                    Qualitaetssicherung.MODIFY();
                END;
            IF WORKDATE() > Qualitaetssicherung."Stammblatt gültig bis" THEN BEGIN
                Qualitaetssicherung."Stammblatt nicht unterzeichnet" := FALSE;
                Qualitaetssicherung."Stammblatt gültig bis" := 0D;
            END;
            IF WORKDATE() > Qualitaetssicherung."GGAP-Zertifikat gültig bis" THEN BEGIN
                Qualitaetssicherung."Kein gültiger GGAP-Zertifikat" := FALSE;
                Qualitaetssicherung."GGAP-Zertifikat gültig bis" := 0D;
            END;
            IF WORKDATE() > Qualitaetssicherung."Credit limit int. valid until" THEN BEGIN
                Qualitaetssicherung."Internal credit limit" := FALSE;
                Qualitaetssicherung."Credit limit int. valid until" := 0D;
            END;
        end;
    end;

    procedure QSFieldsPart2()
    begin
        IF lr_Qualitaetssicherung.GET(Vendor."No.", lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
            newAccountGeneral.GetNo(Vendor."No.", lr_Qualitaetssicherung."Source Type"::Vendor);
            IF WORKDATE() > lr_Qualitaetssicherung."Stammblatt gültig bis" THEN BEGIN
                lr_Qualitaetssicherung."Stammblatt nicht unterzeichnet" := FALSE;
                lr_Qualitaetssicherung."Stammblatt gültig bis" := 0D;
            END;
            IF WORKDATE() > lr_Qualitaetssicherung."GGAP-Zertifikat gültig bis" THEN BEGIN
                lr_Qualitaetssicherung."Kein gültiger GGAP-Zertifikat" := FALSE;
                lr_Qualitaetssicherung."GGAP-Zertifikat gültig bis" := 0D;
            END;
            IF WORKDATE() > lr_Qualitaetssicherung."Credit limit int. valid until" THEN BEGIN
                lr_Qualitaetssicherung."Internal credit limit" := FALSE;
                lr_Qualitaetssicherung."Credit limit int. valid until" := 0D;
            END;
        END;
    end;

    procedure QSFieldsPart2Cust()
    begin
        IF Qualitaetssicherung.GET(Customer."No.", Qualitaetssicherung."Source Type"::Customer) THEN BEGIN
            newAccountGeneral.GetNo(Customer."No.", Qualitaetssicherung."Source Type"::Customer);
            IF WORKDATE() > Qualitaetssicherung."Stammblatt gültig bis" THEN BEGIN
                Qualitaetssicherung."Stammblatt nicht unterzeichnet" := FALSE;
                Qualitaetssicherung."Stammblatt gültig bis" := 0D;
            END;
            IF WORKDATE() > Qualitaetssicherung."GGAP-Zertifikat gültig bis" THEN BEGIN
                Qualitaetssicherung."Kein gültiger GGAP-Zertifikat" := FALSE;
                Qualitaetssicherung."GGAP-Zertifikat gültig bis" := 0D;
            END;
            IF WORKDATE() > Qualitaetssicherung."Credit limit int. valid until" THEN BEGIN
                Qualitaetssicherung."Internal credit limit" := FALSE;
                Qualitaetssicherung."Credit limit int. valid until" := 0D;
            END;
        END;
    end;

    procedure QSLine()
    var
        NextNo: Integer;
    begin
        lr_Qualitaetssicherung.INIT();
        lr_Qualitaetssicherung."No." := Vendor."No.";
        lr_Qualitaetssicherung."Source Type" := lr_Qualitaetssicherung."Source Type"::Vendor;
        lr_Qualitaetssicherung."Reactivate Old Vendor" := TRUE;
        lr_Qualitaetssicherung."Verifikation Adresse" := lr_Qualitaetssicherung."Verifikation Adresse"::Reaktivierung;
        lr_Qualitaetssicherung.VerifikationGeschäftstätigkeit := lr_Qualitaetssicherung.VerifikationGeschäftstätigkeit::Reaktivierung;
        lr_Qualitaetssicherung.Verifikationsanruf := lr_Qualitaetssicherung.Verifikationsanruf::Reaktivierung;
        lr_Qualitaetssicherung."User ID" := CopyStr(USERID(), 1, 50);
        IF (Vendor."POI Customs Agent" OR Vendor."POI Tax Representative" OR Vendor."POI Diverse Vendor" OR Vendor."POI Shipping Company") AND
          ((NOT Vendor."POI Supplier of Goods") OR (NOT Vendor."POI Warehouse Keeper") OR (Vendor."POI Carrier"))
        THEN
            lr_Qualitaetssicherung.QS := TRUE;
        lr_Qualitaetssicherung.INSERT();
        //QSDetails definieren

        AccCompSetting.Reset();
        AccCompSetting.SetRange("Account No.", Vendor."No.");
        AccCompSetting.SetRange("Account Type", AccCompSetting."Account Type"::Vendor);
        AccCompSetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
        NextNo := 10000;
        if AccCompSetting.FindSet() then
            repeat
                NextNo += 10000;
                QsDetails.Init();
                QsDetails."No." := AccCompSetting."Account No.";
                QsDetails."Source Type" := QsDetails."Source Type"::Vendor;
                QsDetails."Line No." := 10000;
                QsDetails.Mandant := AccCompSetting."Company Name";
                QsDetails.Refund := AccCompSetting.Refund;
                QsDetails."Credit Limit" := AccCompSetting."Credit Limit";
                QsDetails.Insert();
            until AccCompSetting.Next() = 0;
    end;

    procedure QSLineCust()
    var
        NextNo: Integer;
    begin
        Qualitaetssicherung.INIT();
        Qualitaetssicherung."No." := Customer."No.";
        Qualitaetssicherung."Source Type" := Qualitaetssicherung."Source Type"::Customer;
        Qualitaetssicherung."Reactivate Old Vendor" := TRUE;
        Qualitaetssicherung."Verifikation Adresse" := Qualitaetssicherung."Verifikation Adresse"::Reaktivierung;
        Qualitaetssicherung.VerifikationGeschäftstätigkeit := Qualitaetssicherung.VerifikationGeschäftstätigkeit::Reaktivierung;
        Qualitaetssicherung.Verifikationsanruf := Qualitaetssicherung.Verifikationsanruf::Reaktivierung;
        Qualitaetssicherung."User ID" := CopyStr(USERID(), 1, 50);
        Qualitaetssicherung.INSERT();

        AccCompSetting.Reset();
        AccCompSetting.SetRange("Account No.", Customer."No.");
        AccCompSetting.SetRange("Account Type", AccCompSetting."Account Type"::Customer);
        AccCompSetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
        NextNo := 10000;
        if AccCompSetting.FindSet() then
            repeat
                NextNo += 10000;
                QsDetails.Init();
                QsDetails."No." := AccCompSetting."Account No.";
                QsDetails."Source Type" := QsDetails."Source Type"::Customer;
                QsDetails."Line No." := 10000;
                QsDetails.Mandant := AccCompSetting."Company Name";
                QsDetails.Refund := AccCompSetting.Refund;
                QsDetails."Credit Limit" := AccCompSetting."Credit Limit";
                Customer2.ChangeCompany(AccCompSetting."Company Name");
                if Customer2.Get(Customer."No.") then begin
                    QsDetails."Sales Person" := Customer2."Salesperson Code";
                    QsDetails."Person in Charge" := Customer2."POI Person in Charge";
                end;
                QsDetails.Insert();
            until AccCompSetting.Next() = 0;
    end;

    procedure KredDebAnf(Oldvendor: Boolean; AccountNo: code[20]; Accounttyp: Option Vendor,"Vendor Group",Customer,"Customer Group")
    begin
        IF NOT KredDebAnforderungen.GET(Accounttyp, AccountNo) THEN BEGIN
            KredDebAnforderungen.INIT();
            KredDebAnforderungen."Source Type" := Accounttyp;
            KredDebAnforderungen."Source No." := AccountNo;
            KredDebAnforderungen."Reactivate Old Vendor" := Oldvendor;
            KredDebAnforderungen.INSERT();
        END;
    end;

    procedure CreateRelPrintDoc(AccountNo: Code[20])
    begin
        ContBusRel.RESET();
        ContBusRel.SETRANGE("No.", AccountNo);
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        IF ContBusRel.FINDFIRST() THEN BEGIN
            lr_RelPrintDoc.RESET();
            lr_RelPrintDoc.SETRANGE(Source, lr_RelPrintDoc.Source::Purchase);
            lr_RelPrintDoc.SETRANGE("Print Document Code", 'KONTAKT NEUANLAGE');
            lr_RelPrintDoc.SETRANGE(Release, TRUE);
            lr_RelPrintDoc.SETRANGE("Kind of Release", lr_RelPrintDoc."Kind of Release"::Mail);
            lr_RelPrintDoc.SETRANGE("Consignee No.", ContBusRel."Contact No.");
            lr_RelPrintDoc.SETRANGE("Released as Mail", TRUE);
            lr_RelPrintDoc.SETFILTER("Print Description 1", '<>%1', '');
            IF lr_RelPrintDoc.FINDLAST() THEN BEGIN
                Qualitaetssicherung.VALIDATE("LFB Version", lr_RelPrintDoc."Print Description 1" + ' ' + LTXT_MailDate +
                  ' ' + FORMAT(lr_RelPrintDoc."Last Date of Mail") + ' ' + LTXT_User + ' ' + lr_RelPrintDoc."USER ID");
                Qualitaetssicherung.MODIFY();
            END;
        END;
    end;

    procedure SetQsFilter()
    begin
        lr_Qualitaetssicherung.Reset();
        lr_Qualitaetssicherung.SetRange("No.", Vendor."No.");
        lr_Qualitaetssicherung.SetRange("Source Type", lr_Qualitaetssicherung."Source Type"::Vendor);
    end;

    procedure SetQsFilterCust()
    begin
        Qualitaetssicherung.Reset();
        Qualitaetssicherung.SetRange("No.", Customer."No.");
        Qualitaetssicherung.SetRange("Source Type", Qualitaetssicherung."Source Type"::Customer);
    end;

    procedure CheckQSAccountCust(AccountNo: Code[20])
    var
        Contact: Record Contact;
        OperatingCompanyExists: Boolean;
        TXT_NewCustTxt: Label 'Debitorenprüfung zur Neuanlage gilt nicht für %1', comment = '%1 Basiscompany';
    begin
        Clear(newAccountGLCust);
        Clear(newAccountGeneralCust);
        Customer.Get(AccountNo);
        OperatingCompanyExists := AccCompSetting.OperationCompExists(Customer."No.", AccCompSetting."Account Type"::Customer);
        ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.SETRANGE("No.", AccountNo);
        IF ContBusRel.FIND('-') THEN
            IF Contact.GET(ContBusRel."Contact No.") THEN;
        if OperatingCompanyExists then BEGIN
            Qualitaetssicherung.RESET();
            Qualitaetssicherung.SETRANGE("No.", AccountNo);
            Qualitaetssicherung.SETRANGE("Source Type", Qualitaetssicherung."Source Type"::Customer);
            Qualitaetssicherung.SETFILTER("Vend-Cust-LFB created", '<>%1', 0DT);
            IF Qualitaetssicherung.FIND('-') THEN BEGIN
                FieldsPartCust();
                QSFieldsPart2Cust();
                CreateRelPrintDoc(Customer."No.");
                KredDebAnf(false, Customer."No.", 2);
                if POIFunction.UserInWindowsRole('GL') then begin
                    newAccountGLCust.SetTableView(Qualitaetssicherung);
                    newAccountGLCust.Run();
                end else begin
                    newAccountGeneralCust.SetTableView(Qualitaetssicherung);
                    newAccountGeneralCust.RUN();
                end;
            end else begin
                //alte Debitoren mit eingetragenen Mandanten, die wieder freigeschaltet werden sollen:
                IF NOT Qualitaetssicherung.GET(Customer."No.", lr_Qualitaetssicherung."Source Type"::Customer) THEN begin
                    QSLineCust();
                    WFMgt.TaskCreateAccount(Qualitaetssicherung.RecordId, '', 'CUSTOMERQS', Qualitaetssicherung."No.", '');
                    KredDebAnf(true, Customer."No.", 2);
                end;
                FieldspartCust();
                QSFieldsPart1Cust();
                CreateRelPrintDoc(Customer."No.");
                SetQSFilterCust();
                if POIFunction.UserInWindowsRole('GL') then begin
                    newAccountGLCust.SetTableView(Qualitaetssicherung);
                    newAccountGLCust.Run();
                end else begin
                    newAccountGeneralCust.SetTableView(Qualitaetssicherung);
                    newAccountGeneralCust.RUN();
                end;
            end;
        END ELSE
            if AccCompSetting.BasicCompExists(Contact."No.", AccCompSetting."Account Type"::Contact) and not OperatingCompanyExists then
                //wenn nur Basis keine Prüfung
                MESSAGE(TXT_NewCustTxt, POICompany.GetBasicCompany())
            //alte Debitoren ohne eingetragene Mandanten, die wieder freigeschaltet werden sollen:
            ELSE
                if not OperatingCompanyExists then begin
                    //Debitor Pflichfelder
                    //IF (COMPANYNAME() = POICompany.GetBasicCompany()) THEN BEGIN
                    Qualitaetssicherung.RESET();
                    Qualitaetssicherung.SETRANGE("No.", Vendor."No.");
                    Qualitaetssicherung.SETRANGE("Source Type", Qualitaetssicherung."Source Type"::Customer);
                    Qualitaetssicherung.SETFILTER("Vend-Cust-LFB created", '=%1', 0DT);
                    //Qualitaetssicherung.SETRANGE("Reactivate Old Vendor", TRUE);
                    IF NOT Qualitaetssicherung.FIND('-') THEN BEGIN
                        QSLineCust();
                        //Anlegen Workflow für QS 
                        WFMgt.TaskCreateAccount(Qualitaetssicherung.RecordId, '', 'CUSTOMERQS', Qualitaetssicherung."No.", '');
                        KredDebAnf(true, Customer."No.", 2);
                    END;
                    FieldspartCust();
                    QSFieldsPart1Cust();
                    CreateRelPrintDoc(Customer."No.");
                    SetQSFilterCust();
                    if POIFunction.UserInWindowsRole('GL') then begin
                        newAccountGLCust.SetTableView(Qualitaetssicherung);
                        newAccountGLCust.Run();
                    end else begin
                        newAccountGeneralCust.SetTableView(Qualitaetssicherung);
                        newAccountGeneralCust.RUN();
                    end;
                end;
    end;

    var
        lr_Qualitaetssicherung: Record "POI Quality Management";
        Qualitaetssicherung: Record "POI Quality Management";
        lr_RelPrintDoc: Record "POI Released Print Documents";
        lr_ContBusRel: Record "Contact Business Relation";
        ContBusRel: Record "Contact Business Relation";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Customer2: Record Customer;
        lr_CountryRegion: Record "Country/Region";
        CountryRegion: Record "Country/Region";
        KredDebAnforderungen: Record "POI Account Requirements";
        AccCompSetting: Record "POI Account Company Setting";
        QsDetails: Record "POI Quality Mgt Detail";
        POICompany: Record "POI Company";
        POIFunction: Codeunit POIFunction;
        WFMgt: Codeunit "POI Workflow Management";
        newAccountGeneral: Page "POI Account Check";
        newAccountGL: Page "POI Account Check GL";
        newAccountGeneralCust: Page "POI Acc Check Cust";
        newAccountGLCust: Page "POI Acc Check GL Cust";
        l_Name: Text[50];
        l_PLZ: Text[50];
        l_Adresse: Text[50];
        l_Ort: Text[50];
        l_Land: Text[50];
        l_Handelsregnr: Text[50];
        l_Eintragungsort: Text[50];
        l_ZlgBedcode: Text[50];
        l_Kreditortyp: Text[50];
        l_UstID: Text[50];
        l_RegNo: Text[50];
        l_VendPostGroup: Text[50];
        l_GenBusPostGroup: Text[50];
        l_VATPostGroup: Text[50];
        l_Kreditlimit: Text[50];
        l_CofaceEasyNr: Text[50];
        LTXT_MailDate: Text[50];
        LTXT_User: Text[50];
        ErrorTxt: Text[100];
        Error1Txt: Text;
        Errorlbl: Text;
        ERR_NotSmallVendTxt: label 'Kleinlieferant Sachkosten (max. 1000 EUR) bedarf keiner weiteren Prüfung.', Comment = '';
        ERR_TestfieldTxt: Label 'Sie müssen noch \%1 %2 %3 %4 %5 %6 %7 %8 %9\ausfüllen.', Comment = ' %1 %2 %3 %4 %5 %6 %7 %8 %9';
        ERR_Testfield1Txt: Label 'Sie müssen noch \%1 %2 %3 %4 %5 %6\ausfüllen', Comment = ' %1 %2 %3 %4 %5 %6';
        ERR_VorkasseTeilTxt: label 'Sie haben Kreditversicherung Status auf\teilgenehmigt geändert. \Kreditversicherungslimit in € muss kleiner als der ursprüngliche betrag von %1 € sein.', Comment = ' %1';

}