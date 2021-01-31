codeunit 50007 "POI QS Functions"
{
    procedure QSLFBMailContact(p_TableID: Integer; p_CustVendNo: Code[20]; p_EMail: Text[80]; p_LanguageCode: Code[10]; pr_Contact: Record Contact; EMail: Text[100])
    var
        lr_Customer: Record Customer;
        lr_Attachment: Record Attachment temporary;
        SMTPMailSetup: Record "SMTP Mail Setup";
        AccCompSetting: Record "POI Account Company Setting";
        lc_Mail: Codeunit Mail;
        POISMTPMail: Codeunit "SMTP Mail";
        Receipients: list of [Text];
        BccReceipients: list of [Text];
        l_BodyLine: Text[1024];
        TXT_1Stammdatenblatt: Text[250];
        TXT_2Stammdatenblatt: Text[250];
        TXT_3Stammdatenblatt: Text[250];
        TXT_Attachment: Text[250];
        TXT_2Attachment: Text[250];
        TXT_3Attachment: Text[250];
        TXT_4Attachment: Text[250];
        TXT_6Attachment: Text[250];
        l_AttachText1: Text[250];
        l_AttachText2: Text[250];
        l_AttachText3: Text[250];
        l_AttachText4: Text[250];
        l_AttachText5: Text[250];
        l_AttachText6: Text[250];
        l_AttachText7: Text[250];
        l_AttachText8: Text[250];
        l_AttachText9: Text[250];
        l_AttachText10: Text[250];
        l_AttachText11: Text[250];
        l_AttachText12: Text[250];
        l_AttachText13: Text[250];
        l_AttachText14: Text[250];
        l_EntryID: Integer;
        l_Subject: Text[250];
        LocationTxt: Label ' wurde angelegt. Bitte prüfen ob ein Lagerort angelegt werden soll.';
        NewCreditorTxt: Label 'Neuer Kreditor ';
        LocationSetupTxt: Label 'Lager-Einrichtung: Neuer Kreditor ';
        DocumentNotFoundTxt: label 'Das Dokument:\ %1 \\konnte nicht gefunden werden.', Comment = '%1';
        DocToNewContactTxt: label 'Dokumente an neuen Kontakt';
        CreateContactTxt: Label 'Kontakt Neuanlage';
        DocToNewVendorTxt: label 'Dokumente an neuen Lieferanten';
        NewVendorTxt: label 'Kreditor Neuanlage';
        DocToNewCustomerTxt: label 'Dokumente an neuen Kunden';
        NewCustomerTxt: label 'Kunde Neuanlage';

    begin
        case p_TableID of
            DATABASE::Contact:
                begin
                    lr_ContBusRel.RESET();
                    lr_ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                    lr_ContBusRel.SETRANGE("Link to Table", lr_ContBusRel."Link to Table"::Vendor);
                    lr_ContBusRel.SETRANGE("Contact No.", p_CustVendNo);
                    IF lr_ContBusRel.FIND('-') THEN
                        lr_Vendor.GET(lr_ContBusRel."No.");
                    CLEAR(lc_Mail);
                end;
            DATABASE::Vendor:
                begin
                    lr_Vendor.ChangeCompany('StammdatenPort');
                    IF lr_Vendor.GET(p_CustVendNo) THEN
                        CLEAR(lc_Mail);
                end;
            DATABASE::Customer:
                IF lr_Customer.GET(p_CustVendNo) THEN
                    CLEAR(lc_Mail);
        end;

        //Umsetzen mit Translation
        TXT_AnredeTxt := POITranslation.GetTranslationDescription(0, 'QS', 'ANREDE', p_LanguageCode, 1, 10000);
        TXT_MailTextTxt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT', p_LanguageCode, 1, 10000);
        TXT_MailText1Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT1', p_LanguageCode, 1, 20000);
        TXT_MailText2Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT2', p_LanguageCode, 1, 30000);
        TXT_MailText3Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT3', p_LanguageCode, 1, 40000);
        TXT_MailText4Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT4', p_LanguageCode, 1, 50000);
        TXT_MailText5Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT5', p_LanguageCode, 1, 60000);
        l_BodyLine := CopyStr(TXT_AnredeTxt + '<br>' + '<br>' + TXT_MailTextTxt + '<br>' + TXT_MailText1Txt + '<br>' +
               '<br>' + TXT_MailText2Txt + '<br>' + '<br>' + TXT_MailText3Txt + '<br>' + '<br>' + TXT_MailText4Txt +
               '<br>' + '<br>' + TXT_MailText5Txt, 1, 1024);

        lr_Attachment.DELETEALL();
        lr_Attachment.INIT();
        lr_Attachment."No." += 1;

        IF (p_TableID = DATABASE::Contact) OR (p_TableID = DATABASE::Customer) OR (p_TableID = DATABASE::Vendor) THEN BEGIN
            //Anlage: Kreditorenstammblatt
            IF ((pr_Contact."POI Supplier of Goods") OR (pr_Contact."POI Warehouse Keeper")) THEN BEGIN
                TXT_1Stammdatenblatt := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTWL', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_1Stammdatenblatt;

                IF NOT EXISTS(TXT_1Stammdatenblatt) THEN
                    ERROR(DocumentNotFoundTxt, TXT_1Stammdatenblatt);


                lr_Attachment.INSERT();
                l_AttachText1 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText1, '\') > 0 do
                    l_AttachText1 := COPYSTR(l_AttachText1, STRPOS(l_AttachText1, '\') + 1, 250);

            END ELSE
                IF (pr_Contact."POI Carrier") AND NOT (pr_Contact."POI Warehouse Keeper") THEN BEGIN
                    TXT_2Stammdatenblatt := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTLOG', p_LanguageCode);
                    lr_Attachment."File Extension" := TXT_2Stammdatenblatt;

                    IF NOT EXISTS(TXT_2Stammdatenblatt) THEN
                        ERROR(DocumentNotFoundTxt, TXT_2Stammdatenblatt);


                    lr_Attachment."No." += 1;
                    lr_Attachment.INSERT();
                    l_AttachText2 := lr_Attachment."File Extension";
                    while STRPOS(l_AttachText2, '\') > 0 do
                        l_AttachText2 := COPYSTR(l_AttachText2, STRPOS(l_AttachText2, '\') + 1, 250);
                END;

            IF ((pr_Contact."POI Customs Agent") OR (pr_Contact."POI Tax Representative") OR
              (pr_Contact."POI Diverse Vendor") OR (pr_Contact."POI Shipping Company")) AND
              (NOT (pr_Contact."POI Carrier") AND NOT (pr_Contact."POI Warehouse Keeper"))
            THEN BEGIN
                TXT_3Stammdatenblatt := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTDIV', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_3Stammdatenblatt;

                IF NOT EXISTS(TXT_3Stammdatenblatt) THEN
                    ERROR(DocumentNotFoundTxt, TXT_3Stammdatenblatt);

                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText3 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText3, '\') > 0 do
                    l_AttachText3 := COPYSTR(l_AttachText3, STRPOS(l_AttachText3, '\') + 1, 250);
            END;

            IF pr_Contact."POI Supplier of Goods" THEN BEGIN
                TXT_Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'LIEFFRAGEBOGEN', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_Attachment;
                IF NOT EXISTS(TXT_Attachment) THEN
                    ERROR(DocumentNotFoundTxt, TXT_Attachment);

                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText4 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText4, '\') > 0 do
                    l_AttachText4 := COPYSTR(l_AttachText4, STRPOS(l_AttachText4, '\') + 1, 250);
            END;

            IF pr_Contact."POI Carrier" THEN BEGIN
                TXT_2Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'ERKLAERUNGLOGISTIK', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_2Attachment;

                IF NOT EXISTS(TXT_2Attachment) THEN
                    ERROR(DocumentNotFoundTxt, TXT_2Attachment);

                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText5 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText5, '\') > 0 do
                    l_AttachText5 := COPYSTR(l_AttachText5, STRPOS(l_AttachText5, '\') + 1, 250);
            END;

            IF pr_Contact."POI Warehouse Keeper" THEN BEGIN
                TXT_3Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'ERKLAERUNGLAGER', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_3Attachment;

                IF NOT EXISTS(TXT_3Attachment) THEN
                    ERROR(DocumentNotFoundTxt, TXT_3Attachment);

                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText6 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText6, '\') > 0 do
                    l_AttachText6 := COPYSTR(l_AttachText6, STRPOS(l_AttachText6, '\') + 1, 250);
            END;

            IF NOT pr_Contact."POI Small Vendor" THEN BEGIN
                TXT_4Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'ALLGEMEKBEDINGUNGEN', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_4Attachment;

                IF NOT EXISTS(TXT_4Attachment) THEN
                    ERROR(DocumentNotFoundTxt, TXT_4Attachment);

                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText7 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText7, '\') > 0 do
                    l_AttachText7 := COPYSTR(l_AttachText7, STRPOS(l_AttachText7, '\') + 1, 250);
            END;

            TXT_6Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'DSGVO', p_LanguageCode);
            lr_Attachment."File Extension" := TXT_6Attachment;

            IF NOT EXISTS(TXT_6Attachment) THEN
                ERROR(DocumentNotFoundTxt, TXT_6Attachment);

            lr_Attachment."No." += 1;
            lr_Attachment.INSERT();
            l_AttachText9 := lr_Attachment."File Extension";
            while STRPOS(l_AttachText9, '\') > 0 do
                l_AttachText9 := COPYSTR(l_AttachText9, STRPOS(l_AttachText9, '\') + 1, 250);

            IF AccCompSetting.Get(0, lr_Vendor."No.", 'PI EUROPEAN SOURCING') THEN BEGIN
                lr_Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIES', p_LanguageCode);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText8 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText8, '\') > 0 do
                    l_AttachText8 := COPYSTR(l_AttachText8, STRPOS(l_AttachText8, '\') + 1, 250);
            END;

            IF AccCompSetting.Get(0, lr_Vendor."No.", 'PI GMBH') THEN begin
                lr_Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPI', p_LanguageCode);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText10 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText10, '\') > 0 do
                    l_AttachText10 := COPYSTR(l_AttachText10, STRPOS(l_AttachText10, '\') + 1, 250);
            end;

            IF AccCompSetting.Get(0, lr_Vendor."No.", 'PI BANANAS GMBH') THEN BEGIN
                lr_Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIB', p_LanguageCode);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText11 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText11, '\') > 0 do
                    l_AttachText11 := COPYSTR(l_AttachText11, STRPOS(l_AttachText11, '\') + 1, 250);
            END;

            IF AccCompSetting.Get(0, lr_Vendor."No.", 'PI DUTCH GROWERS GMBH') THEN BEGIN
                lr_Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIDG', p_LanguageCode);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText12 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText12, '\') > 0 do
                    l_AttachText12 := COPYSTR(l_AttachText12, STRPOS(l_AttachText12, '\') + 1, 250);
            END;

            IF AccCompSetting.Get(0, lr_Vendor."No.", 'PI FRUIT GMBH') THEN BEGIN
                lr_Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIF', p_LanguageCode);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText13 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText13, '\') > 0 do
                    l_AttachText13 := COPYSTR(l_AttachText13, STRPOS(l_AttachText13, '\') + 1, 250);
            END;

            IF AccCompSetting.Get(0, lr_Vendor."No.", 'PI ORGANICS GMBH') THEN BEGIN
                lr_Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIO', p_LanguageCode);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText14 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText14, '\') > 0 do
                    l_AttachText14 := COPYSTR(l_AttachText14, STRPOS(l_AttachText14, '\') + 1, 250);
            END;
        END;


        //weiter noch Kunde

        SMTPMailSetup.Get();
        SMTPMailSetup.TestField("SMTP Server");
        if SMTPMailSetup.Authentication <> SMTPMailSetup.Authentication::Anonymous then
            SMTPMailSetup.TestField("User ID");
        Receipients.Add(p_EMail);

        TXT_Subject := POITranslation.GetTranslationDescription(0, 'QS', 'MAILSUB', p_LanguageCode, 1, 10000);

        case p_TableID of
            DATABASE::Contact:
                begin
                    SubjectTxt := StrSubstNo(TXT_Subject, pr_Contact."No.");
                    POISMTPMail.CreateMessage('Hans', 'hans-ulrich@port-international.com', Receipients, SubjectTxt, l_BodyLine);
                end;
            DATABASE::Vendor:
                BEGIN
                    SubjectTxt := StrSubstNo(TXT_Subject, lr_Vendor."No.");
                    POISMTPMail.CreateMessage('Hans', 'hans-ulrich@port-international.com', Receipients, SubjectTxt, l_BodyLine);
                    //BccReceipients.Add(EMail);
                    BccReceipients.Add('hans-ulrich@port-international.com' /*'qm-operations@port-international.com'*/);
                    POISMTPMail.AddBCC(BccReceipients);
                END;
            DATABASE::Customer:
                BEGIN
                    POISMTPMail.CreateMessage('Hans', 'hans-ulrich@port-international.com', Receipients, StrSubstNo(TXT_Subject, lr_Customer."No."), l_BodyLine);
                    //BccReceipients.Add(EMail);
                    BccReceipients.Add('hans-ulrich@port-international.com' /*'qm-operations@port-international.com'*/);
                    POISMTPMail.AddBCC(BccReceipients);
                END;
        END;
        //Attachments
        if lr_Attachment.FindSet() then
            repeat
                POISMTPMail.AddAttachment(lr_Attachment."File Extension", POIFunction.GetFilename(lr_Attachment."File Extension"));
            until lr_Attachment.Next() = 0;
        //Mail sending
        POISMTPMail.send();

        IF lr_ReleasedPrintDoc.FIND('+') THEN
            l_EntryID := lr_ReleasedPrintDoc."Entry ID" + 1
        ELSE
            l_EntryID := 1;
        lr_ReleasedPrintDoc.RESET();
        lr_ReleasedPrintDoc.INIT();
        lr_ReleasedPrintDoc."Entry ID" := l_EntryID;
        lr_ReleasedPrintDoc."Document Type" := lr_ReleasedPrintDoc."Document Type"::Quote;

        case p_TableID of
            DATABASE::Contact:
                BEGIN
                    lr_ReleasedPrintDoc.Source := lr_ReleasedPrintDoc.Source::Purchase;
                    lr_ReleasedPrintDoc."Document No." := pr_Contact."No.";
                    lr_ReleasedPrintDoc."Detail Code" := COPYSTR(pr_Contact.City, 1, 20);
                    lr_ReleasedPrintDoc."Language Code" := p_LanguageCode;
                    lr_ReleasedPrintDoc."Consignee No." := pr_Contact."No.";
                    lr_ReleasedPrintDoc."Consignee Name" := pr_Contact.Name;
                    lr_ReleasedPrintDoc."E-Mail" := p_EMail;
                    lr_ReleasedPrintDoc.Subject := COPYSTR(POIFunction.GetTranslation(0, 'QS', 'MAILSUB', p_LanguageCode), 1, 150);
                    lr_ReleasedPrintDoc."Source Type" := lr_ReleasedPrintDoc."Source Type"::Contact;
                    lr_ReleasedPrintDoc."Source No." := pr_Contact."No.";
                    lr_ReleasedPrintDoc."Print Document Description" := DocToNewContactTxt;
                    lr_ReleasedPrintDocHelp.SETRANGE("Consignee No.", pr_Contact."No.");
                    IF lr_ReleasedPrintDocHelp.FIND('+') THEN
                        lr_ReleasedPrintDoc."Nos. Released as Mail" := lr_ReleasedPrintDocHelp."Nos. Released as Mail" + 1;
                    lr_ReleasedPrintDoc."Print Document Code" := CreateContactTxt;
                END;
            DATABASE::Vendor:
                BEGIN
                    lr_ReleasedPrintDoc.Source := lr_ReleasedPrintDoc.Source::Purchase;
                    lr_ReleasedPrintDoc."Document No." := lr_Vendor."No.";
                    lr_ReleasedPrintDoc."Detail Code" := COPYSTR(lr_Vendor.City, 1, 20);
                    lr_ReleasedPrintDoc."Language Code" := p_LanguageCode;
                    lr_ReleasedPrintDoc."Consignee No." := lr_Vendor."No.";
                    lr_ReleasedPrintDoc."Consignee Name" := lr_Vendor.Name;
                    lr_ReleasedPrintDoc."E-Mail" := p_EMail;
                    lr_ReleasedPrintDoc.Subject := COPYSTR(POIFunction.GetTranslation(0, 'QS', 'MAILSUB', p_LanguageCode), 1, 150);
                    lr_ReleasedPrintDoc."Source Type" := lr_ReleasedPrintDoc."Source Type"::Vendor;
                    lr_ReleasedPrintDoc."Source No." := lr_Vendor."No.";
                    lr_ReleasedPrintDoc."Print Document Description" := DocToNewVendorTxt;
                    lr_ReleasedPrintDocHelp.SETRANGE("Consignee No.", lr_Vendor."No.");
                    IF lr_ReleasedPrintDocHelp.FIND('+') THEN
                        lr_ReleasedPrintDoc."Nos. Released as Mail" := lr_ReleasedPrintDocHelp."Nos. Released as Mail" + 1;
                    lr_ReleasedPrintDoc."Print Document Code" := NewVendorTxt;
                END;
            DATABASE::Customer:
                BEGIN
                    lr_ReleasedPrintDoc.Source := lr_ReleasedPrintDoc.Source::Sales;
                    lr_ReleasedPrintDoc."Document No." := lr_Customer."No.";
                    lr_ReleasedPrintDoc."Detail Code" := COPYSTR(lr_Customer.City, 1, 20);
                    lr_ReleasedPrintDoc."Language Code" := p_LanguageCode;
                    lr_ReleasedPrintDoc."Consignee No." := lr_Customer."No.";
                    lr_ReleasedPrintDoc."Consignee Name" := lr_Customer.Name;
                    lr_ReleasedPrintDoc."E-Mail" := p_EMail;
                    lr_ReleasedPrintDoc.Subject := COPYSTR(POIFunction.GetTranslation(0, 'QS', 'MAILSUB', p_LanguageCode), 1, 150);
                    lr_ReleasedPrintDoc."Source Type" := lr_ReleasedPrintDoc."Source Type"::Customer;
                    lr_ReleasedPrintDoc."Source No." := lr_Customer."No.";
                    lr_ReleasedPrintDoc."Print Document Description" := DocToNewCustomerTxt;
                    lr_ReleasedPrintDocHelp.SETRANGE("Consignee No.", lr_Customer."No.");
                    IF lr_ReleasedPrintDocHelp.FIND('+') THEN
                        lr_ReleasedPrintDoc."Nos. Released as Mail" := lr_ReleasedPrintDocHelp."Nos. Released as Mail" + 1;
                    lr_ReleasedPrintDoc."Print Document Code" := NewCustomerTxt;
                END;
        end;

        lr_ReleasedPrintDoc.Release := TRUE;
        lr_ReleasedPrintDoc."Kind of Release" := lr_ReleasedPrintDoc."Kind of Release"::Mail;
        lr_ReleasedPrintDoc.Consignee := lr_ReleasedPrintDoc.Consignee::" ";
        lr_ReleasedPrintDoc."Released as Mail" := TRUE;
        lr_ReleasedPrintDoc."Last Date of Mail" := CURRENTDATETIME();

        lr_ReleasedPrintDoc."Print Description 1" := l_AttachText1;
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText2);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText3);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText4);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText5);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText6);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText7);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText8);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText9);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText10);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText11);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText12);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText13);
        CombineText(lr_ReleasedPrintDoc."Print Description 1", l_AttachText14);

        lr_ReleasedPrintDoc."Print Description 2" := '';
        lr_ReleasedPrintDoc."Released Date" := WORKDATE();
        lr_ReleasedPrintDoc."Released Time" := TIME();
        lr_ReleasedPrintDoc."USER ID" := CopyStr(USERID(), 1, 20);
        IF lr_ReleasedPrintDoc."Transaction ID" = 0 THEN BEGIN
            lr_ReleasedPrintDocHelp.INIT();
            lr_ReleasedPrintDocHelp.RESET();
            lr_ReleasedPrintDocHelp.SETCURRENTKEY("Transaction ID");
            IF lr_ReleasedPrintDocHelp.FIND('+') THEN;
            lr_ReleasedPrintDoc."Transaction ID" := lr_ReleasedPrintDocHelp."Transaction ID" + 1;
        END;
        lr_ReleasedPrintDocHelp.RESET();
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN
            lr_ReleasedPrintDoc.INSERT();

        //Lagerort Einrichtung

        IF (lr_Vendor."POI Supplier of Goods") OR (lr_Vendor."POI Warehouse Keeper") THEN BEGIN
            clear(POISMTPMail);
            l_Subject := LocationSetupTxt + lr_Vendor."No.";
            l_BodyLine := NewCreditorTxt + lr_Vendor."No." + LocationTxt;
            clear(Receipients);
            //Receipients.Add(EMail);
            Receipients.Add('hans-ulrich@port-international.com' /*'qm-operations@port-international.com'*/);
            POISMTPMail.CreateMessage('Hans', 'hans-ulrich@port-international.com', Receipients, StrSubstNo(TXT_Subject, lr_Vendor."No."), l_BodyLine);
            //Mail sending
            POISMTPMail.send();
        END;
        IF lr_Vendor."POI Carrier" THEN BEGIN
            l_Subject := 'Zustellercode-Einrichtung: Neuer Kreditor ' + lr_Vendor."No.";
            l_BodyLine := 'Neuer Kreditor ' + lr_Vendor."No." + ' wurde angelegt. Bitte prüfen ob ein Zustellercode angelegt werden soll.';
            clear(Receipients);
            //Receipients.Add(EMail);
            Receipients.Add('hans-ulrich@port-international.com' /*'qm-operations@port-international.com'*/);
            POISMTPMail.CreateMessage('Hans Lager', 'hans-ulrich@port-international.com', Receipients, l_Subject, l_BodyLine);
        END;

    end;

    procedure QSLFBMailContactCust(p_TableID: Integer; p_CustVendNo: Code[20]; p_EMail: Text[80]; p_LanguageCode: Code[10]; pr_Contact: Record Contact)
    var
        Attachment: Record Attachment temporary;
        AccCompSetting: Record "POI Account Company Setting";
        lc_Mail: Codeunit "SMTP Mail";
        Receipients: list of [Text];
        l_BodyLine: Text[1024];
        l_Attachment: Text[250];
        l_AttachText1: Text[250];
        l_AttachText2: Text[250];
        l_AttachText3: Text[250];
        l_AttachText4: Text[250];
        l_AttachText5: Text[250];
        l_AttachText6: Text[250];
        l_AttachText7: Text[250];
        l_AttachText8: Text[250];
        l_AttachText9: Text[250];
        l_AttachText10: Text[250];
        TXT_SubjectCust: Text[400];
        TXT_StammdatenblattCust: Text[250];
        DocumentNotFoundTxt: label 'Das Dokument:\ %1 \\konnte nicht gefunden werden.', Comment = '%1';
        l_EntryID: Integer;
    begin
        case p_TableID of
            DATABASE::Contact:
                BEGIN
                    lr_ContBusRel.Reset();
                    lr_ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                    lr_ContBusRel.SETRANGE("Link to Table", lr_ContBusRel."Link to Table"::Customer);
                    lr_ContBusRel.SETRANGE("Contact No.", p_CustVendNo);
                    IF lr_ContBusRel.FIND('-') THEN
                        IF Cust.GET(lr_ContBusRel."No.") THEN
                            CLEAR(lc_Mail);
                end;
            DATABASE::Customer:
                IF Cust.GET(p_CustVendNo) THEN
                    CLEAR(lc_Mail);
        END;

        //Umsetzen mit Translation
        TXT_AnredeTxt := POITranslation.GetTranslationDescription(0, 'QS', 'ANREDE', p_LanguageCode, 1);
        TXT_MailTextTxt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXTCUST', p_LanguageCode, 1);
        // TXT_MailText1Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT1CUST', p_LanguageCode, 1, 20000);
        // TXT_MailText2Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT3', p_LanguageCode, 1, 40000);
        // TXT_MailText3Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT4', p_LanguageCode, 1, 50000);
        // TXT_MailText4Txt := POITranslation.GetTranslationDescription(0, 'QS', 'MAILTEXT5', p_LanguageCode, 1, 60000);
        l_BodyLine := CopyStr(TXT_AnredeTxt + '<br>' + '<br>' + TXT_MailTextTxt + '<br>', 1, 1024);
        //Ende Umsetzen mit Translation

        //Allgemeinen VK Bedingungen
        Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'ALLGVKBEDCUST', p_LanguageCode);
        Attachment."No." += 1;
        Attachment.Insert();
        l_Attachment := Attachment."File Extension";
        while STRPOS(l_AttachText2, '\') > 0 do
            l_AttachText2 := COPYSTR(l_AttachText2, STRPOS(l_AttachText2, '\') + 1, 250);

        //DSGVO Info
        Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'DSGVO', p_LanguageCode);
        Attachment."No." += 1;
        Attachment.Insert();
        l_Attachment := Attachment."File Extension";
        while STRPOS(l_AttachText3, '\') > 0 do
            l_AttachText3 := COPYSTR(l_AttachText3, STRPOS(l_AttachText3, '\') + 1, 250);

        //Firmendaten //TODO: Mandantendokumente
        // AccountCompanySetting.SetRange("Account Type", AccCompSetting."Account Type"::Customer);
        // AccountCompanySetting.SetRange("Account No.", Cust."No.");
        // AccountCompanySetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
        // if AccountCompanySetting.FindSet() then
        //     repeat
        //         Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIES', p_LanguageCode);
        //         Attachment."No." += 1;
        //         Attachment.INSERT();
        //         l_AttachText4 := Attachment."File Extension";
        //         while STRPOS(l_AttachText4, '\') > 0 do
        //             l_AttachText4 := COPYSTR(l_AttachText4, STRPOS(l_AttachText4, '\') + 1, 250);
        //     until AccountCompanySetting.Next() = 0;


        IF AccCompSetting.Get(1, Cust."No.", 'PI EUROPEAN SOURCING') THEN BEGIN
            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIES', p_LanguageCode);
            Attachment."No." += 1;
            Attachment.INSERT();
            l_AttachText4 := Attachment."File Extension";
            while STRPOS(l_AttachText4, '\') > 0 do
                l_AttachText4 := COPYSTR(l_AttachText4, STRPOS(l_AttachText4, '\') + 1, 250);
        END;

        IF AccCompSetting.Get(1, Cust."No.", 'PI GMBH') THEN BEGIN
            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPI', p_LanguageCode);
            Attachment."No." += 1;
            Attachment.INSERT();
            l_AttachText5 := Attachment."File Extension";
            while STRPOS(l_AttachText5, '\') > 0 do
                l_AttachText5 := COPYSTR(l_AttachText5, STRPOS(l_AttachText5, '\') + 1, 250);
        END;

        IF AccCompSetting.Get(1, Cust."No.", 'PI BANANAS GMBH') THEN BEGIN
            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIB', p_LanguageCode);
            Attachment."No." += 1;
            Attachment.INSERT();
            l_AttachText6 := Attachment."File Extension";
            while STRPOS(l_AttachText6, '\') > 0 do
                l_AttachText6 := COPYSTR(l_AttachText6, STRPOS(l_AttachText6, '\') + 1, 250);
        END;

        IF AccCompSetting.Get(1, Cust."No.", 'PI DUTCH GROWERS GMBH') THEN BEGIN
            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIDG', p_LanguageCode);
            Attachment."No." += 1;
            Attachment.INSERT();
            l_AttachText7 := Attachment."File Extension";
            while STRPOS(l_AttachText7, '\') > 0 do
                l_AttachText7 := COPYSTR(l_AttachText7, STRPOS(l_AttachText7, '\') + 1, 250);
        END;

        IF AccCompSetting.Get(1, Cust."No.", 'PI FRUIT GMBH') THEN BEGIN
            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIF', p_LanguageCode);
            Attachment."No." += 1;
            Attachment.INSERT();
            l_AttachText8 := Attachment."File Extension";
            while STRPOS(l_AttachText8, '\') > 0 do
                l_AttachText8 := COPYSTR(l_AttachText8, STRPOS(l_AttachText8, '\') + 1, 250);
        END;

        IF AccCompSetting.Get(1, Cust."No.", 'PI ORGANICS GMBH') THEN BEGIN
            Attachment."File Extension" := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'FIRMENDATENPIO', p_LanguageCode);
            Attachment."No." += 1;
            Attachment.INSERT();
            l_AttachText9 := Attachment."File Extension";
            while STRPOS(l_AttachText9, '\') > 0 do
                l_AttachText9 := COPYSTR(l_AttachText9, STRPOS(l_AttachText9, '\') + 1, 250);
        END;

        TXT_StammdatenblattCust := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMBLATTCUST', p_LanguageCode);
        Attachment."File Extension" := TXT_StammdatenblattCust;
        IF NOT EXISTS(TXT_StammdatenblattCust) THEN
            ERROR(DocumentNotFoundTxt, TXT_StammdatenblattCust);

        Attachment."No." += 1;
        Attachment.INSERT();
        l_AttachText3 := Attachment."File Extension";
        while STRPOS(l_AttachText3, '\') > 0 do
            l_AttachText3 := COPYSTR(l_AttachText3, STRPOS(l_AttachText3, '\') + 1, 250);

        TXT_SubjectCust := POITranslation.GetTranslationDescription(0, 'QS', 'MAILSUBCUST', p_LanguageCode, 1, 10000);

        IF p_TableID = DATABASE::Customer THEN begin
            clear(Receipients);
            Receipients.Add('hans-ulrich@port-international.com' /*'qm-operations@port-international.com'*/);
            lc_Mail.CreateMessage('Hans', 'hans-ulrich@port-international.com', Receipients, STRSUBSTNO(TXT_SubjectCust, Cust."No."), l_BodyLine);
            //Attachments
            if Attachment.FindSet() then
                repeat
                    lc_Mail.AddAttachment(Attachment."File Extension", POIFunction.GetFilename(Attachment."File Extension"));
                until Attachment.Next() = 0;
            //Mail sending
            lc_Mail.send();
        end;

        IF lr_ReleasedPrintDoc.FIND('+') THEN
            l_EntryID := lr_ReleasedPrintDoc."Entry ID" + 1
        ELSE
            l_EntryID := 1;
        lr_ReleasedPrintDoc.Reset();
        lr_ReleasedPrintDoc.Init();
        lr_ReleasedPrintDoc."Entry ID" := l_EntryID;
        lr_ReleasedPrintDoc."Document Type" := lr_ReleasedPrintDoc."Document Type"::Quote;

        IF p_TableID = DATABASE::Customer THEN BEGIN
            lr_ReleasedPrintDoc.Source := lr_ReleasedPrintDoc.Source::Sales;
            lr_ReleasedPrintDoc."Document No." := Cust."No.";
            lr_ReleasedPrintDoc."Detail Code" := COPYSTR(pr_Contact.City, 1, 20);
            lr_ReleasedPrintDoc."Language Code" := p_LanguageCode;
            lr_ReleasedPrintDoc."Consignee No." := Cust."No.";
            lr_ReleasedPrintDoc."Consignee Name" := Cust.Name;
            lr_ReleasedPrintDoc."E-Mail" := p_EMail;
            lr_ReleasedPrintDoc.Subject := STRSUBSTNO(TXT_SubjectCust, Cust."No.");
            lr_ReleasedPrintDoc."Source Type" := lr_ReleasedPrintDoc."Source Type"::Customer;
            lr_ReleasedPrintDoc."Source No." := Cust."No.";
            lr_ReleasedPrintDoc."Print Document Description" := 'Dokumente an neuen Debitor';
            lr_ReleasedPrintDocHelp.SETRANGE("Consignee No.", Cust."No.");
            IF lr_ReleasedPrintDocHelp.FIND('+') THEN
                lr_ReleasedPrintDoc."Nos. Released as Mail" := lr_ReleasedPrintDocHelp."Nos. Released as Mail" + 1;
            lr_ReleasedPrintDoc."Print Document Code" := 'Debitor Neuanlage';
        END;

        lr_ReleasedPrintDoc.Release := TRUE;
        lr_ReleasedPrintDoc."Kind of Release" := lr_ReleasedPrintDoc."Kind of Release"::Mail;
        lr_ReleasedPrintDoc.Consignee := lr_ReleasedPrintDoc.Consignee::" ";
        lr_ReleasedPrintDoc."Released as Mail" := TRUE;
        lr_ReleasedPrintDoc."Last Date of Mail" := CURRENTDATETIME;

        lr_ReleasedPrintDoc."Print Description 1" := l_AttachText1;
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText2 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText2;
        END ELSE
            IF l_AttachText2 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText2;

        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText3 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText3;
        END ELSE
            IF l_AttachText3 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText3;

        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText4 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText4
        END ELSE
            IF l_AttachText4 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText4;
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText5 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText5
        END ELSE
            IF l_AttachText5 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText5;
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText6 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText6
        END ELSE
            IF l_AttachText6 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText6;
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText7 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText7
        END ELSE
            IF l_AttachText7 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText7;
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText8 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText8
        END ELSE
            IF l_AttachText8 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText8;
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText9 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText9
        END ELSE
            IF l_AttachText9 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText9;
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
            IF l_AttachText10 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText10
        END ELSE
            IF l_AttachText10 <> '' THEN
                lr_ReleasedPrintDoc."Print Description 1" := l_AttachText10;

        lr_ReleasedPrintDoc."Print Description 2" := '';
        lr_ReleasedPrintDoc."Released Date" := WORKDATE();
        lr_ReleasedPrintDoc."Released Time" := TIME;
        lr_ReleasedPrintDoc."USER ID" := copystr(USERID(), 1, 50);
        IF lr_ReleasedPrintDoc."Transaction ID" = 0 THEN BEGIN
            lr_ReleasedPrintDocHelp.Init();
            lr_ReleasedPrintDocHelp.Reset();
            lr_ReleasedPrintDocHelp.SETCURRENTKEY("Transaction ID");
            IF lr_ReleasedPrintDocHelp.FIND('+') THEN;
            lr_ReleasedPrintDoc."Transaction ID" := lr_ReleasedPrintDocHelp."Transaction ID" + 1;
        END;
        lr_ReleasedPrintDocHelp.Reset();
        IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN
            lr_ReleasedPrintDoc.Insert();

    end;

    // procedure QSLFBMailVendor(p_TableID: Integer;p_CustVendNo: Code[20];p_EMail: Text[250];p_LanguageCode: Code[10];var pr_Vendor: Record Vendor)
    // var
    //     lr_Vendor: Record Vendor;
    //     lr_Contact: Record Contact;
    //     lr_Customer: Record Customer;
    //     lr_ReleasedPrintDoc: Record "Released Print Documents";
    //     lr_ReleasedPrintDocHelp: Record "Released Print Documents";
    //     lr_Attachment: Record Attachment temporary;
    //     lr_Session: Record Session;
    //     lc_Mail: Codeunit Mail;
    //     l_BodyLine: Text[1024];
    //     l_CRLF: Text[2];
    //     l_Attachment: Text[250];
    //     l_AttachText1: Text[250];
    //     l_AttachText2: Text[250];
    //     l_AttachText3: Text[250];
    //     l_AttachText4: Text[250];
    //     l_AttachText5: Text[250];
    //     l_AttachText6: Text[250];
    //     File: File;
    //     ///lc_SingleInstance: Codeunit "60020";
    //     l_ContactNewCompany: Boolean;
    //     l_EntryID: Integer;
    // begin
    //     ///lc_SingleInstance.get_ContactNewCompany(l_ContactNewCompany);
    //     IF l_ContactNewCompany THEN BEGIN
    //       lr_Vendor.CHANGECOMPANY('StammdatenPort');
    //       lr_Customer.CHANGECOMPANY('StammdatenPort');
    //       lr_ReleasedPrintDoc.CHANGECOMPANY('StammdatenPort');
    //       lr_ReleasedPrintDocHelp.CHANGECOMPANY('StammdatenPort');
    //     END;

    //     IF p_TableID = DATABASE::Contact THEN BEGIN
    //       IF lr_Contact.GET(p_CustVendNo) THEN
    //         CLEAR(lc_Mail);
    //     END ELSE IF p_TableID = DATABASE::Vendor THEN BEGIN
    //       IF lr_Vendor.GET(p_CustVendNo) THEN
    //         CLEAR(lc_Mail);
    //     END;

    //     l_CRLF[1] := 13;
    //     l_CRLF[2] := 10;

    //     CASE p_LanguageCode OF
    //       'DEU':
    //         l_BodyLine := /*l_CRLF +*/ TXT_AnredeDE + l_CRLF + l_CRLF + TXT_MailTextDE + l_CRLF + TXT_MailTextDE1 + l_CRLF +
    //           l_CRLF + TXT_MailTextDE2 + l_CRLF + l_CRLF + TXT_MailTextDE3 + l_CRLF + TXT_MailTextDE4 +
    //           l_CRLF + l_CRLF + TXT_MailTextDE5;
    //       'ENU':
    //         l_BodyLine := /*l_CRLF +*/ TXT_AnredeEN + l_CRLF + l_CRLF + TXT_MailTextEN + l_CRLF + TXT_MailTextEN1 + l_CRLF +
    //           l_CRLF + TXT_MailTextEN2 + l_CRLF + l_CRLF + TXT_MailTextEN3 + l_CRLF + l_CRLF + TXT_MailTextEN4 +
    //           l_CRLF + l_CRLF + TXT_MailTextEN5;
    //       'ESP':
    //         l_BodyLine := /*l_CRLF +*/ TXT_AnredeSP + l_CRLF + l_CRLF + TXT_MailTextSP + l_CRLF + TXT_MailTextSP1 + l_CRLF +
    //           l_CRLF + TXT_MailTextSP2 + l_CRLF + l_CRLF + TXT_MailTextSP3 + l_CRLF + l_CRLF + TXT_MailTextSP4
    //           + l_CRLF + l_CRLF + TXT_MailTextSP5;
    //       '':
    //         l_BodyLine := /*l_CRLF +*/ TXT_AnredeDE + l_CRLF + l_CRLF + TXT_MailTextDE + l_CRLF + TXT_MailTextDE1 + l_CRLF +
    //           l_CRLF + TXT_MailTextDE2 + l_CRLF + l_CRLF + TXT_MailTextDE3 + l_CRLF + TXT_MailTextDE4 +
    //           l_CRLF + l_CRLF + TXT_MailTextDE5;
    //       ELSE
    //         l_BodyLine := /*l_CRLF +*/ TXT_AnredeEN + l_CRLF + l_CRLF + TXT_MailTextEN + l_CRLF + TXT_MailTextEN1 + l_CRLF +
    //           l_CRLF + TXT_MailTextEN2 + l_CRLF + l_CRLF + TXT_MailTextEN3 + l_CRLF + l_CRLF + TXT_MailTextEN4 +
    //           l_CRLF + l_CRLF + TXT_MailTextEN5;
    //     END;

    //     lr_Attachment.DELETEALL();
    //     lr_Attachment.INIT();
    //     lr_Attachment."No." +=1;

    //     IF p_TableID = DATABASE::Contact THEN BEGIN

    //       //Anlage: Kreditorenstammblatt
    //       //IF (pr_Vendor."Is Vendor of Trade Items") OR (pr_Vendor."Is Warehouse")
    //       IF (pr_Vendor."Supplier of Goods") OR (pr_Vendor."Warehouse Keeper")
    //       THEN BEGIN
    //     /*
    //         CASE p_LanguageCode OF
    //           'DEU': lr_Attachment."File Extension" := TXT_1StammdatenblattDETxt;
    //           'ENU': lr_Attachment."File Extension" := TXT_1StammdatenblattENTxt;
    //           'ESP': lr_Attachment."File Extension" := TXT_1StammdatenblattSPTxt;
    //           ''   : lr_Attachment."File Extension" := TXT_1StammdatenblattDETxt;
    //           ELSE lr_Attachment."File Extension" := TXT_1StammdatenblattENTxt;
    //         END;

    //         IF NOT EXISTS(TXT_1StammdatenblattDETxt) THEN
    //           ERROR('Das Dokument:\' + TXT_1StammdatenblattDETxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_1StammdatenblattENTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_1StammdatenblattENTxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_1StammdatenblattSPTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_1StammdatenblattSPTxt + '\\konnte nicht gefunden werden.');

    //         lr_Attachment.insert();
    //         l_Attachment := lr_Attachment."File Extension";
    //         IF STRPOS(l_Attachment,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_Attachment,STRPOS(l_Attachment,'\') + 1);
    //         IF STRPOS(l_AttachText1,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_AttachText1,STRPOS(l_AttachText1,'\') + 1);
    //         IF STRPOS(l_AttachText1,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_AttachText1,STRPOS(l_AttachText1,'\') + 1);
    //         IF STRPOS(l_AttachText1,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_AttachText1,STRPOS(l_AttachText1,'\') + 1);
    //         IF STRPOS(l_AttachText1,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_AttachText1,STRPOS(l_AttachText1,'\') + 1);
    //         IF STRPOS(l_AttachText1,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_AttachText1,STRPOS(l_AttachText1,'\') + 1);
    //         IF STRPOS(l_AttachText1,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_AttachText1,STRPOS(l_AttachText1,'\') + 1);
    //         IF STRPOS(l_AttachText1,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_AttachText1,STRPOS(l_AttachText1,'\') + 1);
    //         IF STRPOS(l_AttachText1,'\') > 0 THEN
    //           l_AttachText1 := COPYSTR(l_AttachText1,STRPOS(l_AttachText1,'\') + 1);
    //     */
    //       //END ELSE IF pr_Vendor."Is Shipping Agent" THEN BEGIN
    //       END;
    //       IF pr_Vendor.Carrier THEN BEGIN
    //         CASE p_LanguageCode OF
    //           'DEU': lr_Attachment."File Extension" := TXT_2StammdatenblattDETxt;
    //           'ENU': lr_Attachment."File Extension" := TXT_2StammdatenblattENTxt;
    //           'ESP': lr_Attachment."File Extension" := TXT_2StammdatenblattSPTxt;
    //           ''   : lr_Attachment."File Extension" := TXT_2StammdatenblattDETxt;
    //           ELSE lr_Attachment."File Extension" := TXT_2StammdatenblattENTxt;
    //         END;

    //         IF NOT EXISTS(TXT_2StammdatenblattDETxt) THEN
    //           ERROR('Das Dokument:\' + TXT_2StammdatenblattDETxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_2StammdatenblattENTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_2StammdatenblattENTxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_2StammdatenblattSPTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_2StammdatenblattSPTxt + '\\konnte nicht gefunden werden.');

    //         lr_Attachment.insert();
    //         l_Attachment := lr_Attachment."File Extension";
    //         IF STRPOS(l_Attachment,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_Attachment,STRPOS(l_Attachment,'\') + 1);
    //         IF STRPOS(l_AttachText2,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_AttachText2,STRPOS(l_AttachText2,'\') + 1);
    //         IF STRPOS(l_AttachText2,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_AttachText2,STRPOS(l_AttachText2,'\') + 1);
    //         IF STRPOS(l_AttachText2,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_AttachText2,STRPOS(l_AttachText2,'\') + 1);
    //         IF STRPOS(l_AttachText2,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_AttachText2,STRPOS(l_AttachText2,'\') + 1);
    //         IF STRPOS(l_AttachText2,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_AttachText2,STRPOS(l_AttachText2,'\') + 1);
    //         IF STRPOS(l_AttachText2,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_AttachText2,STRPOS(l_AttachText2,'\') + 1);
    //         IF STRPOS(l_AttachText2,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_AttachText2,STRPOS(l_AttachText2,'\') + 1);
    //         IF STRPOS(l_AttachText2,'\') > 0 THEN
    //           l_AttachText2 := COPYSTR(l_AttachText2,STRPOS(l_AttachText2,'\') + 1);

    //       END;

    //       IF ((pr_Vendor."Customs Agent") OR (pr_Vendor."Tax Representative") OR
    //         (pr_Vendor."Diverse Vendor") OR (pr_Vendor."Shipping Company")) AND
    //        (NOT (pr_Vendor.Carrier) AND NOT (pr_Vendor."Warehouse Keeper"))
    //       THEN BEGIN
    //         CASE p_LanguageCode OF
    //           'DEU': lr_Attachment."File Extension" := TXT_3StammdatenblattDETxt;
    //           'ENU': lr_Attachment."File Extension" := TXT_3StammdatenblattENTxt;
    //           'ESP': lr_Attachment."File Extension" := TXT_3StammdatenblattSPTxt;
    //           ''   : lr_Attachment."File Extension" := TXT_3StammdatenblattDETxt;
    //           ELSE lr_Attachment."File Extension" := TXT_3StammdatenblattENTxt;
    //         END;

    //         IF NOT EXISTS(TXT_3StammdatenblattDETxt) THEN
    //           ERROR('Das Dokument:\' + TXT_3StammdatenblattDETxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_3StammdatenblattENTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_3StammdatenblattENTxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_3StammdatenblattSPTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_3StammdatenblattSPTxt + '\\konnte nicht gefunden werden.');

    //         lr_Attachment."No." +=1;
    //         lr_Attachment.insert();
    //         l_Attachment := lr_Attachment."File Extension";
    //         IF STRPOS(l_Attachment,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_Attachment,STRPOS(l_Attachment,'\') + 1);
    //         IF STRPOS(l_AttachText3,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_AttachText3,STRPOS(l_AttachText3,'\') + 1);
    //         IF STRPOS(l_AttachText3,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_AttachText3,STRPOS(l_AttachText3,'\') + 1);
    //         IF STRPOS(l_AttachText3,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_AttachText3,STRPOS(l_AttachText3,'\') + 1);
    //         IF STRPOS(l_AttachText3,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_AttachText3,STRPOS(l_AttachText3,'\') + 1);
    //         IF STRPOS(l_AttachText3,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_AttachText3,STRPOS(l_AttachText3,'\') + 1);
    //         IF STRPOS(l_AttachText3,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_AttachText3,STRPOS(l_AttachText3,'\') + 1);
    //         IF STRPOS(l_AttachText3,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_AttachText3,STRPOS(l_AttachText3,'\') + 1);
    //         IF STRPOS(l_AttachText3,'\') > 0 THEN
    //           l_AttachText3 := COPYSTR(l_AttachText3,STRPOS(l_AttachText3,'\') + 1);
    //       END;

    //       IF pr_Vendor."Supplier of Goods" THEN BEGIN
    //         CASE p_LanguageCode OF
    //           'DEU': lr_Attachment."File Extension" := TXT_AttachmentDETxt;
    //           'ENU': lr_Attachment."File Extension" := TXT_AttachmentENTxt;
    //           'ESP': lr_Attachment."File Extension" := TXT_AttachmentSPTxt;
    //           ''   : lr_Attachment."File Extension" := TXT_AttachmentDETxt;
    //           ELSE lr_Attachment."File Extension" := TXT_AttachmentENTxt;
    //         END;

    //         IF NOT EXISTS(TXT_AttachmentDETxt) THEN
    //           ERROR('Das Dokument:\' + TXT_AttachmentDETxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_AttachmentENTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_AttachmentENTxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_AttachmentSPTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_AttachmentSPTxt + '\\konnte nicht gefunden werden.');

    //         lr_Attachment."No." +=1;
    //         lr_Attachment.insert();
    //         l_Attachment := lr_Attachment."File Extension";
    //         IF STRPOS(l_Attachment,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_Attachment,STRPOS(l_Attachment,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //         IF STRPOS(l_AttachText4,'\') > 0 THEN
    //           l_AttachText4 := COPYSTR(l_AttachText4,STRPOS(l_AttachText4,'\') + 1);
    //       END;

    //       IF pr_Vendor.Carrier THEN BEGIN
    //         CASE p_LanguageCode OF
    //           'DEU': lr_Attachment."File Extension" := TXT_2AttachmentDETxt;
    //           'ENU': lr_Attachment."File Extension" := TXT_2AttachmentENTxt;
    //           'ESP': lr_Attachment."File Extension" := TXT_2AttachmentSPTxt;
    //           ''   : lr_Attachment."File Extension" := TXT_2AttachmentDETxt;
    //           ELSE lr_Attachment."File Extension" := TXT_2AttachmentENTxt;
    //         END;

    //         IF NOT EXISTS(TXT_2AttachmentDETxt) THEN
    //           ERROR('Das Dokument:\' + TXT_2AttachmentDETxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_2AttachmentENTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_2AttachmentENTxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_2AttachmentSPTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_2AttachmentSPTxt + '\\konnte nicht gefunden werden.');

    //         lr_Attachment."No." +=1;
    //         lr_Attachment.insert();
    //         l_Attachment := lr_Attachment."File Extension";
    //         IF STRPOS(l_Attachment,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_Attachment,STRPOS(l_Attachment,'\') + 1);
    //         IF STRPOS(l_AttachText5,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_AttachText5,STRPOS(l_AttachText5,'\') + 1);
    //         IF STRPOS(l_AttachText5,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_AttachText5,STRPOS(l_AttachText5,'\') + 1);
    //         IF STRPOS(l_AttachText5,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_AttachText5,STRPOS(l_AttachText5,'\') + 1);
    //         IF STRPOS(l_AttachText5,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_AttachText5,STRPOS(l_AttachText5,'\') + 1);
    //         IF STRPOS(l_AttachText5,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_AttachText5,STRPOS(l_AttachText5,'\') + 1);
    //         IF STRPOS(l_AttachText5,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_AttachText5,STRPOS(l_AttachText5,'\') + 1);
    //         IF STRPOS(l_AttachText5,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_AttachText5,STRPOS(l_AttachText5,'\') + 1);
    //         IF STRPOS(l_AttachText5,'\') > 0 THEN
    //           l_AttachText5 := COPYSTR(l_AttachText5,STRPOS(l_AttachText5,'\') + 1);
    //       END;

    //       //IF pr_Vendor."Is Warehouse" THEN BEGIN
    //       IF pr_Vendor."Warehouse Keeper" THEN BEGIN
    //         CASE p_LanguageCode OF
    //           'DEU': lr_Attachment."File Extension" := TXT_3AttachmentDETxt;
    //           'ENU': lr_Attachment."File Extension" := TXT_3AttachmentENTxt;
    //           'ESP': lr_Attachment."File Extension" := TXT_3AttachmentSPTxt;
    //           ''   : lr_Attachment."File Extension" := TXT_3AttachmentDETxt;
    //           ELSE lr_Attachment."File Extension" := TXT_3AttachmentENTxt;
    //         END;

    //         IF NOT EXISTS(TXT_3AttachmentDETxt) THEN
    //           ERROR('Das Dokument:\' + TXT_3AttachmentDETxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_AttachmentENTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_3AttachmentENTxt + '\\konnte nicht gefunden werden.');
    //         IF NOT EXISTS(TXT_3AttachmentSPTxt) THEN
    //           ERROR('Das Dokument:\' + TXT_3AttachmentSPTxt + '\\konnte nicht gefunden werden.');

    //         lr_Attachment."No." +=1;
    //         lr_Attachment.insert();
    //         l_Attachment := lr_Attachment."File Extension";
    //         IF STRPOS(l_Attachment,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_Attachment,STRPOS(l_Attachment,'\') + 1);
    //         IF STRPOS(l_AttachText6,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_AttachText6,STRPOS(l_AttachText6,'\') + 1);
    //         IF STRPOS(l_AttachText6,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_AttachText6,STRPOS(l_AttachText6,'\') + 1);
    //         IF STRPOS(l_AttachText6,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_AttachText6,STRPOS(l_AttachText6,'\') + 1);
    //         IF STRPOS(l_AttachText6,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_AttachText6,STRPOS(l_AttachText6,'\') + 1);
    //         IF STRPOS(l_AttachText6,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_AttachText6,STRPOS(l_AttachText6,'\') + 1);
    //         IF STRPOS(l_AttachText6,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_AttachText6,STRPOS(l_AttachText6,'\') + 1);
    //         IF STRPOS(l_AttachText6,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_AttachText6,STRPOS(l_AttachText6,'\') + 1);
    //         IF STRPOS(l_AttachText6,'\') > 0 THEN
    //           l_AttachText6 := COPYSTR(l_AttachText6,STRPOS(l_AttachText6,'\') + 1);
    //       END;
    //     END;

    //     ///???lc_Mail.Attachments(lr_Attachment);

    //     lr_Session.Reset();
    //     lr_Session.SETRANGE("My Session",TRUE);
    //     lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //     lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //     IF lr_Session.FINDFIRST() THEN BEGIN
    //       IF p_TableID = DATABASE::Contact THEN BEGIN
    //         CASE p_LanguageCode OF
    //           'DEU': lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectDETxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           'ENU': lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectENTxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           'ESP': lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectSPTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectSPTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectSPTxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           'PTG': lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectENTxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           ''   : lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectDETxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           ELSE
    //             lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectENTxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //       END ELSE IF p_TableID = DATABASE::Vendor THEN BEGIN
    //         CASE p_LanguageCode OF
    //           'DEU': lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},TRUE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectDETxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           'ENU': lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},TRUE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectENTxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           'ESP': lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectSPTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectSPTxt,l_BodyLine,'' {l_Attachment},TRUE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectSPTxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           'PTG': lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},TRUE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectENTxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           ''   : lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},TRUE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectDETxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           ELSE
    //             lc_Mail.NewMessage(p_EMail /*An*/, /*'qm-operations@port-international.com'*/ '' /*CC*/,'',
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    //TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},TRUE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //                    STRSUBSTNO(TXT_SubjectENTxt,pr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
    //                    FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //       END ELSE IF p_TableID = DATABASE::Customer THEN BEGIN
    //       /*weiter noch Kunde
    //         CASE p_LanguageCode OF
    //           'DEU':lc_Mail.NewMessage(p_EMail {An}, {'qm-operations@port-international.com'} '' {CC},
    //                   TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //           'ENU':lc_Mail.NewMessage(p_EMail {An}, {'qm-operations@port-international.com'} '' {CC},
    //                   TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //           'ESP':lc_Mail.NewMessage(p_EMail {An}, {'qm-operations@port-international.com'} '' {CC},
    //                   TXT_SubjectSPTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //           'PTG':lc_Mail.NewMessage(p_EMail {An}, {'qm-operations@port-international.com'} '' {CC},
    //                   TXT_SubjectENTxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //           ''   :lc_Mail.NewMessage(p_EMail {An}, {'qm-operations@port-international.com'} '' {CC},
    //                   TXT_SubjectDETxt,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //         END;
    //       */
    //       END;
    //     END;

    //     IF lr_ReleasedPrintDoc.FIND('+') THEN
    //       l_EntryID := lr_ReleasedPrintDoc."Entry ID" + 1
    //     ELSE
    //       l_EntryID := 1;
    //     lr_ReleasedPrintDoc.Reset();
    //     lr_ReleasedPrintDoc.INIT();
    //     lr_ReleasedPrintDoc."Entry ID" := l_EntryID;
    //     lr_ReleasedPrintDoc."Document Type" := lr_ReleasedPrintDoc."Document Type"::Quote;
    //     lr_ReleasedPrintDoc.Source := lr_ReleasedPrintDoc.Source::Purchase;
    //     lr_ReleasedPrintDoc."Document No." := lr_Contact."No.";
    //     lr_ReleasedPrintDoc."Detail Code" := COPYSTR(lr_Contact.City,1,20);
    //     lr_ReleasedPrintDoc."Language Code" := p_LanguageCode;
    //     lr_ReleasedPrintDoc."Consignee No." := lr_Contact."No.";
    //     lr_ReleasedPrintDoc."Consignee Name" := lr_Contact.Name;
    //     lr_ReleasedPrintDoc."E-Mail" := p_EMail;
    //     CASE p_LanguageCode OF
    //       'DEU': lr_ReleasedPrintDoc.Subject := TXT_SubjectDEType;
    //       'ENU': lr_ReleasedPrintDoc.Subject := TXT_SubjectENType;
    //       'ESP': lr_ReleasedPrintDoc.Subject := TXT_SubjectSPType;
    //       ''   : lr_ReleasedPrintDoc.Subject := TXT_SubjectDEType;
    //       ELSE lr_ReleasedPrintDoc.Subject := TXT_SubjectENType;
    //     END;
    //     lr_ReleasedPrintDoc."Source Type" := lr_ReleasedPrintDoc."Source Type"::Contact;
    //     lr_ReleasedPrintDoc."Source No." := lr_Contact."No.";
    //     lr_ReleasedPrintDoc."Print Document Description" := 'Kreditorentyp NEU';
    //     lr_ReleasedPrintDocHelp.SETRANGE("Consignee No.",lr_Contact."No.");
    //     IF lr_ReleasedPrintDocHelp.FIND('+') THEN BEGIN
    //       lr_ReleasedPrintDoc."Nos. Released as Mail" := lr_ReleasedPrintDocHelp."Nos. Released as Mail" + 1;
    //     END;
    //     lr_ReleasedPrintDoc."Print Document Code" := 'Kontakt Neuanlage';
    //     lr_ReleasedPrintDoc.Release := TRUE;
    //     lr_ReleasedPrintDoc."Kind of Release" := lr_ReleasedPrintDoc."Kind of Release"::Mail;
    //     lr_ReleasedPrintDoc.Consignee := lr_ReleasedPrintDoc.Consignee::" ";
    //     lr_ReleasedPrintDoc."Released as Mail" := TRUE;
    //     lr_ReleasedPrintDoc."Last Date of Mail" := CURRENTDATETIME;

    //     lr_ReleasedPrintDoc."Print Description 1" := l_AttachText1;
    //     IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
    //       IF l_AttachText2 <> '' THEN
    //         lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText2;
    //     END ELSE IF l_AttachText2 <> '' THEN
    //         lr_ReleasedPrintDoc."Print Description 1" := l_AttachText2;
    //     IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
    //       IF l_AttachText3 <> '' THEN
    //         lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText3;
    //     END ELSE IF l_AttachText3 <> '' THEN
    //         lr_ReleasedPrintDoc."Print Description 1" := l_AttachText3;
    //     IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
    //       IF l_AttachText4 <> '' THEN
    //         lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText4
    //     END ELSE IF l_AttachText4 <> '' THEN
    //       lr_ReleasedPrintDoc."Print Description 1" := l_AttachText4;
    //     IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
    //       IF l_AttachText5 <> '' THEN
    //         lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText5
    //     END ELSE IF l_AttachText5 <> '' THEN
    //       lr_ReleasedPrintDoc."Print Description 1" := l_AttachText5;
    //     IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
    //       IF l_AttachText6 <> '' THEN
    //         lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText6
    //     END ELSE IF l_AttachText6 <> '' THEN
    //       lr_ReleasedPrintDoc."Print Description 1" := l_AttachText6;

    //     lr_ReleasedPrintDoc."Print Description 2":= '';
    //     lr_ReleasedPrintDoc."Released Date" := WORKDATE;
    //     lr_ReleasedPrintDoc."Released Time" := TIME;
    //     lr_ReleasedPrintDoc."USER ID" := USERID;
    //     //JW noch lr_ReleasedPrintDoc.MailID := gc_NoSeriesMgt.GetNextNo('EDOCPRINT',WORKDATE,TRUE);
    //     IF lr_ReleasedPrintDoc."Transaction ID" = 0 THEN BEGIN
    //       lr_ReleasedPrintDocHelp.INIT();
    //       lr_ReleasedPrintDocHelp.Reset();
    //       lr_ReleasedPrintDocHelp.SETCURRENTKEY("Transaction ID");
    //       IF lr_ReleasedPrintDocHelp.FIND('+') THEN;
    //       lr_ReleasedPrintDoc."Transaction ID" := lr_ReleasedPrintDocHelp."Transaction ID" + 1;
    //     END;
    //     lr_ReleasedPrintDocHelp.Reset();
    //     lr_ReleasedPrintDoc.insert();
    //     //+POI-JW 10.01.18

    // end;

    // procedure CustVendFolder(p_VenCustNo: Code[20])
    // var
    //     lr_Customer: Record "Customer";
    //     lr_Vendor: Record Vendor;
    //     l_Filename: Text[250];
    //     l_File: File;
    //     LTXT_File: Label '\\port-nav-01\NavClient\MakeDir';
    // begin
    //     //-POI-JW 14.12.17
    //     IF NOT CustVendFolderExist(p_VenCustNo) THEN BEGIN
    //       IF lr_Customer.GET(p_VenCustNo) THEN
    //         ERROR(ERR_CustFolderFail,p_VenCustNo);
    //       IF lr_Vendor.GET(p_VenCustNo) THEN
    //         ERROR(ERR_VendFolderFail,p_VenCustNo);
    //     END;

    //     //lr_PortSetupII.GET();   //???? wo 2017 ???

    //     //l_Filename:='c:\temp\makeDir.bat';
    //     //l_Filename := '\\port-nav-01\navclient\MakeDir\makeDir' + USERID + '.bat';
    //     l_Filename := LTXT_File + USERID + '.bat';

    //     IF NOT l_File.CREATE(l_Filename) THEN
    //       ERROR(ERR_CreateFile,l_Filename);
    //     IF lr_Vendor.GET(p_VenCustNo) THEN
    //       //l_File.WRITE('explorer \\port-data-01\lwp\Stammdaten\Kreditoren\' + p_VenCustNo);
    //       l_File.WRITE(STRSUBSTNO('%1\%2',TXT_ExplorerVend,p_VenCustNo));
    //     IF lr_Customer.GET(p_VenCustNo) THEN
    //       //l_File.WRITE('explorer \\port-data-01\lwp\Stammdaten\Debitoren\' + p_VenCustNo);
    //       l_File.WRITE(STRSUBSTNO('%1\%2',TXT_ExplorerCust,p_VenCustNo));

    //     l_File.CLOSE;
    //     SHELL(l_Filename);
    // end;

    // procedure CustVendFolderExist(p_VenCustNo: Code[20]): Boolean
    // var
    //     lr_Customer: Record "Customer";
    //     lr_Vendor: Record Vendor;
    //     lr_File: Record File;
    //     l_currpath: Text[250];
    // begin
    //     IF lr_Vendor.GET(p_VenCustNo) THEN
    //       l_currpath := TXT_VendFolder;
    //     IF lr_Customer.GET(p_VenCustNo) THEN
    //       l_currpath := TXT_CustFolder;

    //     lr_File.Reset();
    //     lr_File.SETFILTER(Path,l_currpath);
    //     lr_File.SETRANGE(Name,p_VenCustNo);
    //     IF lr_File.FINDFIRST() THEN
    //       BEGIN
    //         lr_File.SETFILTER(Path,STRSUBSTNO('%1%2',l_currpath,p_VenCustNo));
    //         lr_File.SETRANGE("Is a file",FALSE);
    //         lr_File.SETRANGE(Name);
    //         IF lr_File.FIND('-') THEN
    //           EXIT(TRUE);
    //       END;
    //     EXIT(FALSE);
    // end;

    // procedure CustVendFolderDocExist(p_VenCustNo: Code[20]): Boolean
    // var
    //     lr_Customer: Record "Customer";
    //     lr_Vendor: Record Vendor;
    //     lr_File: Record File;
    //     l_currpath: Text[250];
    // begin
    //     //-POI-JW 19.02.18
    //     IF lr_Vendor.GET(p_VenCustNo) THEN
    //       l_currpath := TXT_VendFolder;
    //     IF lr_Customer.GET(p_VenCustNo) THEN
    //       l_currpath := TXT_CustFolder;

    //     lr_File.Reset();
    //     lr_File.SETFILTER(Path,l_currpath);
    //     lr_File.SETRANGE(Name,p_VenCustNo);
    //     IF lr_File.FINDFIRST() THEN
    //       BEGIN
    //         lr_File.SETFILTER(Path,STRSUBSTNO('%1%2',l_currpath,p_VenCustNo));
    //         lr_File.SETRANGE("Is a file",TRUE);
    //         lr_File.SETRANGE(Name);
    //         lr_File.SETFILTER(Name,'*.*');
    //         IF lr_File.FIND('-') THEN
    //           EXIT(TRUE);
    //       END;
    //     EXIT(FALSE);
    // end;

    // procedure MailPapersFail(p_CustVendNo: Code[20];p_SourceType: Option Vendor,"Vendor Group",Customer,"Customer Group";p_ForCompany: Text[110];p_PapersFail: Text[1024])
    // var
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_Vendor: Record Vendor;
    //     lr_Customer: Record "Customer";
    //     lr_UserSetup: Record "User Setup";
    //     lr_SalesPurch: Record "Salesperson/Purchaser";
    //     lr_CommentLine: Record "Comment Line";
    //     lr_Session: Record Session;
    //     lc_Mail: Codeunit Mail;
    //     l_Subject: Text[250];
    //     l_BodyLine: Text[1024];
    //     LTXT_SubjectMail: Label '%1: neuer Kreditor %2 %3 mit fehlenden Unterlagen';
    //     LTXT_MailToJa: Label 'Der neue Kreditor %1 %2 für %3 wurde %4';
    //     LTXT_MailToNein: Label 'Die Ausnahmegenehmigung für den neuen Kreditor %1 %2 für %3 wurde %4';
    //     l_Company: Text[30];
    //     l_Requester: Text[80];
    //     l_Purchaser: Text[80];
    //     l_Comment: Text[1024];
    // begin
    //     l_Subject := '';
    //     l_BodyLine := '';

    //     IF lr_Vendor.GET(p_CustVendNo) THEN BEGIN
    //       CLEAR(lc_Mail);

    //       IF STRPOS(p_ForCompany,'International GmbH') <> 0 THEN
    //         l_Company := 'Port International GmbH';
    //       IF STRPOS(p_ForCompany,'Dutch') <> 0 THEN
    //         l_Company := 'P I Dutch Growers';
    //       IF STRPOS(p_ForCompany,'Organics') <> 0 THEN
    //         l_Company := 'P I Organics GmbH';
    //       IF STRPOS(p_ForCompany,'Bananas') <> 0 THEN
    //         l_Company := 'PI Bananas GmbH';
    //       IF STRPOS(p_ForCompany,'Sourcing') <> 0 THEN
    //         l_Company := 'PI European Sourcing';
    //       IF STRPOS(p_ForCompany,'Fruit') <> 0 THEN
    //         l_Company := 'PI Fruit GmbH';

    //       IF lr_Qualitaetssicherung.GET(p_CustVendNo,lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
    //         IF lr_Qualitaetssicherung.Ausnahmegenehmigung = lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt THEN
    //           l_Subject := STRSUBSTNO(LTXT_SubjectMail,'freigegeben',p_CustVendNo,lr_Vendor.Name)
    //         ELSE IF lr_Qualitaetssicherung.Ausnahmegenehmigung = lr_Qualitaetssicherung.Ausnahmegenehmigung::abgelehnt THEN
    //           l_Subject := STRSUBSTNO(LTXT_SubjectMail,'abgelehnt',p_CustVendNo,lr_Vendor.Name);

    //         IF lr_SalesPurch.GET(lr_Vendor."Purchaser Code") THEN
    //           l_Purchaser := lr_SalesPurch."E-Mail";
    //         IF lr_Qualitaetssicherung."Anforderung an GL User ID" <> '' THEN BEGIN
    //           lr_SalesPurch.Reset();
    //           lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Anforderung an GL User ID");
    //           lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //           IF lr_SalesPurch.FINDFIRST() THEN
    //             l_Requester := lr_SalesPurch."E-Mail";
    //         END ELSE
    //           l_Requester := '';
    //       END;

    //       lr_CommentLine.Reset();
    //       lr_CommentLine.SETRANGE("Table Name",lr_CommentLine."Table Name"::Qualitaetssicherung);
    //       lr_CommentLine.SETRANGE("No.",p_CustVendNo);
    //       lr_CommentLine.SETRANGE(Code,'GL');
    //       IF lr_CommentLine.FINDSET() THEN BEGIN
    //         REPEAT
    //           l_Comment := l_Comment + COPYSTR(lr_CommentLine.Comment,1,MAXSTRLEN(l_Comment));
    //           l_Comment := l_Comment + ' ';
    //         UNTIL (lr_CommentLine.NEXT() = 0) OR (STRLEN(l_Comment) = MAXSTRLEN(l_Comment));
    //       END;

    //       lr_Session.Reset();
    //       lr_Session.SETRANGE("My Session",TRUE);
    //       lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //       lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //       IF lr_Session.FINDFIRST() THEN BEGIN
    //         IF l_Purchaser <> l_Requester THEN BEGIN
    //           //an Anforderer und Einkäufer
    //           IF lr_Qualitaetssicherung.Ausnahmegenehmigung = lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt THEN
    //             l_BodyLine := STRSUBSTNO(LTXT_MailToJa,p_CustVendNo,lr_Vendor.Name,p_ForCompany,p_PapersFail/*,UPPERCASE(Userid())*/) +
    //               'Begründung der Ausnahmegenehmigung: ' + l_Comment
    //           ELSE IF lr_Qualitaetssicherung.Ausnahmegenehmigung = lr_Qualitaetssicherung.Ausnahmegenehmigung::abgelehnt THEN
    //             l_BodyLine := STRSUBSTNO(LTXT_MailToNein,p_CustVendNo,lr_Vendor.Name,p_ForCompany,p_PapersFail/*,UPPERCASE(Userid())*/) +
    //               'Begründung der Ablehnung der Ausnahmegenehmigung: ' + l_Comment;

    //           IF l_Company = 'PI European Sourcing' THEN
    //             lc_Mail.NewMessage(l_Purchaser +
    //               ';GL-PIES@port-international.com;qm-operations@port-international.com;accounting@port-international.com' /*An*/,
    //               l_Requester +';pies-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE IF l_Company = 'PI Fruit GmbH' THEN
    //             lc_Mail.NewMessage(l_Purchaser +
    //               ';GL-PIES@port-international.com;qm-operations@port-international.com;accounting@port-international.com' /*An*/,
    //               l_Requester +';pif-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE IF l_Company = 'P I Dutch Growers' THEN
    //             lc_Mail.NewMessage(l_Purchaser +
    //               ';GL-PIES@port-international.com;qm-operations@port-international.com;accounting@port-international.com' /*An*/,
    //               l_Requester +';pidg-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE IF l_Company = 'Port International GmbH' THEN
    //             lc_Mail.NewMessage(l_Purchaser + ';GL-PIES@port-international.com;accounting@port-international.com ' /*An*/,
    //               l_Requester +';julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE
    //             lc_Mail.NewMessage(l_Purchaser +
    //               ';GL-PIES@port-international.com;qm-operations@port-international.com;accounting@port-international.com' /*An*/,
    //               l_Requester +';julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END ELSE BEGIN
    //           //an Anforderer
    //           IF lr_Qualitaetssicherung.Ausnahmegenehmigung = lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt THEN
    //             l_BodyLine := STRSUBSTNO(LTXT_MailToJa,p_CustVendNo,lr_Vendor.Name,p_ForCompany,p_PapersFail/*,UPPERCASE(Userid())*/) +
    //               'Begründung der Ausnahmegenehmigung: ' + l_Comment
    //           ELSE IF lr_Qualitaetssicherung.Ausnahmegenehmigung = lr_Qualitaetssicherung.Ausnahmegenehmigung::abgelehnt THEN
    //             l_BodyLine := STRSUBSTNO(LTXT_MailToNein,p_CustVendNo,lr_Vendor.Name,p_ForCompany,p_PapersFail/*,UPPERCASE(Userid())*/) +
    //               'Begründung der Ablehnung der Ausnahmegenehmigung: ' + l_Comment;

    //           IF l_Company = 'PI European Sourcing' THEN
    //             lc_Mail.NewMessage(l_Requester + ';GL-PIES@port-international.com;accounting@port-international.com ' /*An*/,
    //               'qm-operations@port-international.com;pies-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE IF l_Company = 'PI Fruit GmbH' THEN
    //             lc_Mail.NewMessage(l_Requester + ';GL-PIES@port-international.com;accounting@port-international.com ' /*An*/,
    //               'qm-operations@port-international.com;pif-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE IF l_Company = 'P I Dutch Growers' THEN
    //             lc_Mail.NewMessage(l_Requester + ';GL-PIES@port-international.com;accounting@port-international.com ' /*An*/,
    //               'qm-operations@port-international.com;pidg-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE IF l_Company = 'Port International GmbH' THEN
    //             lc_Mail.NewMessage(l_Requester + ';GL-PIES@port-international.com;accounting@port-international.com ' /*An*/,
    //               'julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE
    //             lc_Mail.NewMessage(l_Requester + ';GL-PIES@port-international.com;accounting@port-international.com ' /*An*/,
    //               'julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //       END;
    //     END;

    //     //Kunde-noch
    //     IF lr_Customer.GET(p_CustVendNo) THEN BEGIN
    //       CLEAR(lc_Mail);
    //     END;

    // end;

    // procedure RequesterMail(p_CustVendNo: Code[20];p_SourceType: Option Vendor,"Vendor Group",Customer,"Customer Group";p_ForCompany: Text[110];p_GLAnforderung: Text[1024])
    // var
    //     lr_Vendor: Record Vendor;
    //     lr_Session: Record Session;
    //     lc_Mail: Codeunit Mail;
    //     l_Subject: Text[140];
    //     l_BodyLine: Text[1024];
    //     LTXT_SubjectMail: Label '%1: neuer Kreditor %2 %3 mit fehlenden Unterlagen';
    //     LTXT_MailToJa: Label 'Der neue Kreditor %1 %2 für %3 wurde %4';
    //     LTXT_MailToNein: Label 'Die Ausnahmegenehmigung für den neuen Kreditor %1 %2 für %3 wurde %4';
    //     l_Company: Text[30];
    //     l_Requester: Text[80];
    //     l_Purchaser: Text[80];
    // begin
    //     l_Subject := '';
    //     l_BodyLine := '';

    //     IF lr_Vendor.GET(p_CustVendNo) THEN BEGIN
    //       CLEAR(lc_Mail);

    //       l_Subject := 'Anfrage Ausnahmegenehmigung: Neuer Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' - ' + p_ForCompany;
    //       l_BodyLine := p_GLAnforderung;

    //       lr_Session.Reset();
    //       lr_Session.SETRANGE("My Session",TRUE);
    //       lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //       lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //       IF lr_Session.FINDFIRST() THEN BEGIN
    //         IF STRPOS(p_ForCompany,'Dutch') <> 0 THEN BEGIN
    //           l_Company := 'P I Dutch Growers';
    //           //lc_Mail.NewMessage('Andre@port-international.com;Philippe@port-international.com;Ruben@port-international.com' {An},
    //           lc_Mail.NewMessage('GL-PIDG@port-international.com;pidg-operations@port-international.com' /*An*/,
    //             'qm-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //             l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //         IF STRPOS(p_ForCompany,'Organics') <> 0 THEN BEGIN
    //           l_Company := 'P I Organics GmbH';
    //           //lc_Mail.NewMessage('Mike@port-international.com;Ruben@port-international.com' {An},
    //           lc_Mail.NewMessage('GL-PIO@port-international.com' /*An*/,
    //             'qm-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //             l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //         IF STRPOS(p_ForCompany,'Bananas') <> 0 THEN BEGIN
    //           l_Company := 'PI Bananas GmbH';
    //           //lc_Mail.NewMessage('Mike@port-international.com;Ruben@port-international.com' {An},
    //           lc_Mail.NewMessage('GL-PIB@port-international.com' /*An*/,
    //             'qm-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //             l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //         IF STRPOS(p_ForCompany,'Sourcing') <> 0 THEN BEGIN
    //           l_Company := 'PI European Sourcing';
    //           //lc_Mail.NewMessage('Andre@port-international.com;Philippe@port-international.com;Ruben@port-international.com' {An},
    //           lc_Mail.NewMessage('GL-PIES@port-international.com;pies-operations@port-international.com' /*An*/,
    //             'qm-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //             l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //         IF STRPOS(p_ForCompany,'Fruit') <> 0 THEN BEGIN
    //           l_Company := 'PI Fruit GmbH';
    //           //lc_Mail.NewMessage('Andre@port-international.com;Philippe@port-international.com;Ruben@port-international.com' {An},
    //           lc_Mail.NewMessage('GL-PIF@port-international.com;pif-operations@port-international.com' /*An*/,
    //             'qm-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //             l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //         IF STRPOS(p_ForCompany,'International') <> 0 THEN BEGIN
    //           l_Company := 'Port International GmbH';
    //           //lc_Mail.NewMessage('Ruben@port-international.com' {An},
    //           lc_Mail.NewMessage('GL-PI@port-international.com' /*An*/,
    //             'julita@port-international.com' /*CC*/,'',
    //             l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //       END;
    //     END;
    // end;

    // procedure VendBlockedOnValidate(p_Vend: Record Vendor;p_xRecVend: Record Vendor)
    // var
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_ContBusRel: Record "Contact Business Relation";
    //     Cont: Record Contact;
    //     ChangeLogEntry: Record "Change Log Entry";
    //     ChangeLogEntryHELP: Record "Change Log Entry";
    //     AccCompSetting: Record "Account Company Setting";
    //     ///lc_SingleInstance: Codeunit "60020";
    //     POIFunction: Codeunit POIFunction;
    //     l_StammBlocked: Boolean;
    //     Found: Boolean;
    //     LERR_LFBNewVend: Label 'Sie können den Kreditor %1 nicht freischalten,\da das Feld "Freigabe für Kreditor" in\"Krditoren Prüfung zur Neuanlage"\des Kreditors nicht markiert ist.\Bitte an Handel oder Abwicklung oder FIBU wenden.';
    //     LMSG_LFB: Label 'Sie sollten den Kreditor %1 nicht freischalten,\da das Feld "Freigabe für Kreditor" in \"Krditoren Prüfung zur Neuanlage"\des Kreditors nicht markiert ist.\Bitte an Handel oder Abwicklung oder FIBU wenden.';
    //     l_Company: Text[100];
    // begin

    //     IF COMPANYNAME <> 'StammdatenPort' THEN BEGIN
    //         IF p_xRecVend.Blocked <> p_xRecVend.Blocked::" " THEN
    //           IF NOT POIFunction.CheckUserInRole('FB KREDITOR W',0) THEN
    //               ERROR(ERR_NoPermission);

    //        if p_Vend.GET(lr_Qualitaetssicherung."No.") then
    //           l_Company := POIFunction.SetAccCompSettingNames(p_Vend."No.",0);

    //       //zuerst Prüfung ob ein alter Vend, der schon freigegeben war:
    //       ChangeLogEntry.Reset();
    //       ChangeLogEntry.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
    //       ChangeLogEntry.SETRANGE("Table No.",DATABASE::Vendor);
    //       ChangeLogEntry.SETRANGE("Primary Key Field 1 Value",p_Vend."No.");
    //       ChangeLogEntry.SETRANGE("Field No.",p_Vend.FIELDNO(p_Vend.Blocked));
    //       ChangeLogEntry.SETRANGE("Old Value",'');
    //       ChangeLogEntry.SETRANGE("Type of Change",ChangeLogEntry."Type of Change"::Modification);
    //       IF ChangeLogEntry.FINDLAST THEN BEGIN
    //         ChangeLogEntryHELP.Reset();
    //         ChangeLogEntryHELP.SETCURRENTKEY("Table No.","Primary Key Field 1 Value");
    //         ChangeLogEntryHELP.SETRANGE("Table No.",DATABASE::Vendor);
    //         ChangeLogEntryHELP.SETRANGE("Primary Key Field 1 Value",p_Vend."No.");
    //         ChangeLogEntryHELP.SETRANGE("Field No.",p_Vend.FIELDNO(p_Vend.Blocked));
    //         ChangeLogEntryHELP.SETRANGE("Type of Change",ChangeLogEntryHELP."Type of Change"::Modification);
    //         IF ChangeLogEntryHELP.FINDLAST THEN BEGIN
    //           IF ChangeLogEntryHELP."New Value" = 'Zahlung' THEN
    //              VendMailFromBlocked(p_Vend."No.",p_Vend.Blocked,l_Company);
    //         END;
    //       END ELSE BEGIN
    //         IF p_Vend.Blocked = p_Vend.Blocked::" " THEN BEGIN
    //           IF COMPANYNAME <> 'StammdatenPort' THEN BEGIN
    //             lr_Qualitaetssicherung.CHANGECOMPANY('StammdatenPort');
    //             IF (lr_Qualitaetssicherung.GET(p_Vend."No.",lr_Qualitaetssicherung."Source Type"::Vendor))
    //             THEN BEGIN
    //               IF lr_Qualitaetssicherung."Freigabe für Kreditor" = TRUE THEN
    //                 l_StammBlocked := TRUE;
    //             END;
    //           END;

    //           IF (lr_Qualitaetssicherung.GET(p_Vend."No.",lr_Qualitaetssicherung."Source Type"::Vendor))
    //           THEN
    //             IF l_StammBlocked THEN BEGIN
    //               lr_Qualitaetssicherung."Freigabe für Kreditor" := TRUE;
    //               lr_Qualitaetssicherung.Modify();
    //             END;
    //           if POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI FRUITS GMBH') OR POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI ORGANICS GMBH') 
    //             OR POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI BANANAS GMBH') OR POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI EUROPEAN SOURCING GMBH')
    //           THEN BEGIN
    //             IF (lr_Qualitaetssicherung.GET(p_Vend."No.",lr_Qualitaetssicherung."Source Type"::Vendor))
    //             THEN BEGIN
    //               IF lr_Qualitaetssicherung."Freigabe für Kreditor" = FALSE THEN
    //                 IF  (p_xRecVend.Blocked <> p_Vend.Blocked) THEN
    //                   ERROR(LERR_LFBNewVend,p_Vend."No.");
    //             END ELSE IF (lr_Qualitaetssicherung.GET(p_Vend."No.",lr_Qualitaetssicherung."Source Type"::Vendor))
    //             THEN BEGIN
    //               IF lr_Qualitaetssicherung."Freigabe für Kreditor" = FALSE THEN
    //                 IF  (p_xRecVend.Blocked <> p_Vend.Blocked) AND (p_Vend.Blocked = p_Vend.Blocked::" ") THEN
    //                   MESSAGE(LMSG_LFB,p_Vend."No.");
    //             END;
    //           END;
    //         END ELSE BEGIN
    //           if POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI FRUITS GMBH') OR POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI ORGANICS GMBH') 
    //             OR POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI BANANAS GMBH') OR POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI DUTCH GROWERS GMBH') 
    //             OR POIFunction.CheckCompForAccount(p_Vend."No.",0,'PI EUROPEAN SOURCING GMBH')
    //           THEN BEGIN
    //             IF (lr_Qualitaetssicherung.GET(p_Vend."No.",lr_Qualitaetssicherung."Source Type"::Vendor))
    //             THEN BEGIN
    //               IF lr_Qualitaetssicherung."Freigabe für Kreditor" = FALSE THEN
    //                 IF  (p_xRecVend.Blocked <> p_Vend.Blocked) AND (p_Vend.Blocked = p_Vend.Blocked::" ") THEN
    //                   MESSAGE(LMSG_LFB,p_Vend."No.");
    //             END;
    //           END;
    //         END;
    //         VendMailFromBlocked(p_Vend."No.",p_Vend.Blocked,l_Company);
    //       END;
    //     END;
    // end;

    // procedure VendMailFromBlocked(p_CustVendNo: Code[20];p_Blocked: Option " ",Payment,All;p_Company: Text[100])
    // var
    //     lr_Vendor: Record Vendor;
    //     lr_SalesPurch: Record "Salesperson/Purchaser";
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_Session: Record Session;
    //     lc_Mail: Codeunit Mail;
    //     l_Subject: Text[100];
    //     l_BodyLine: Text[1024];
    //     l_CRLF: Text[2];
    //     l_VendUser: Text[80];
    //     l_Requester: Text[80];
    //     l_Purchaser: Text[80];
    // begin
    //     l_Subject := '';
    //     l_BodyLine := '';
    //     l_CRLF[1] := 13;
    //     l_CRLF[2] := 10;
    //     l_VendUser := '';
    //     l_Requester := '';
    //     l_Purchaser := '';

    //     IF lr_Vendor.GET(p_CustVendNo) THEN BEGIN
    //       CLEAR(lc_Mail);
    //       IF p_Blocked = p_Blocked::" " THEN BEGIN
    //         l_Subject := 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' freigegeben';
    //         l_BodyLine := l_CRLF + l_CRLF + 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' wurde von FIBU für Mandant ' +
    //           COMPANYNAME + ' freigegeben.'
    //       END ELSE IF p_Blocked = p_Blocked::Payment THEN BEGIN
    //         l_Subject := 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' für Zahlung gesperrt';
    //         l_BodyLine := l_CRLF + l_CRLF + 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name +
    //           ' wurde von FIBU für Zahlung für Mandant ' + COMPANYNAME + ' gesperrt.'
    //       END ELSE IF p_Blocked = p_Blocked::All THEN BEGIN
    //         l_Subject := 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' gesperrt';
    //         l_BodyLine := l_CRLF + l_CRLF + 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' wurde von FIBU für Mandant ' +
    //           COMPANYNAME + ' gesperrt.';
    //       END;
    //       IF lr_Vendor."Last User ID Modified" <> '' THEN BEGIN
    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Vendor."Last User ID Modified");
    //         lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //         IF lr_SalesPurch.FINDFIRST() THEN
    //           l_VendUser := lr_SalesPurch."E-Mail";
    //       END;
    //       IF lr_SalesPurch.GET(lr_Vendor."Purchaser Code") THEN
    //         l_Purchaser := lr_SalesPurch."E-Mail";
    //       IF lr_Qualitaetssicherung.GET(p_CustVendNo,lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
    //         IF lr_Qualitaetssicherung."Anforderung an GL User ID" <> '' THEN BEGIN
    //           lr_SalesPurch.Reset();
    //           lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Anforderung an GL User ID");
    //           lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //           IF lr_SalesPurch.FINDFIRST() THEN
    //             l_Requester := lr_SalesPurch."E-Mail";
    //         END;
    //       END;

    //       IF lr_Vendor."Last User ID Modified" <> '' THEN BEGIN
    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Vendor."Last User ID Modified");
    //         lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //         IF lr_SalesPurch.FINDFIRST() THEN
    //           l_VendUser := lr_SalesPurch."E-Mail";
    //       END;
    //       IF lr_SalesPurch.GET(lr_Vendor."Purchaser Code") THEN
    //         l_Purchaser := lr_SalesPurch."E-Mail";
    //       IF lr_Qualitaetssicherung.GET(p_CustVendNo,lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
    //         IF lr_Qualitaetssicherung."Anforderung an GL User ID" <> '' THEN BEGIN
    //           lr_SalesPurch.Reset();
    //           lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Anforderung an GL User ID");
    //           lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //           IF lr_SalesPurch.FINDFIRST() THEN
    //             l_Requester := lr_SalesPurch."E-Mail";
    //         END;
    //       END;

    //       lr_Session.Reset();
    //       lr_Session.SETRANGE("My Session",TRUE);
    //       lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //       lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //       IF lr_Session.FINDFIRST() THEN BEGIN
    //         IF (l_VendUser <> '') OR (l_Purchaser <> '') THEN BEGIN
    //           IF l_VendUser = l_Purchaser THEN
    //             lc_Mail.NewMessage(l_VendUser /*An*/,'qm-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE
    //             lc_Mail.NewMessage((l_VendUser + ';' + l_Purchaser) /*An*/,
    //               'qm-operations@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //         END;
    //       END;
    //     END;

    // end;

    // procedure AnforderungAnGL(p_CustVendNo: Code[20];p_SourceType: Option Vendor,"Vendor Group",Customer,"Customer Group";pr_Qualitaetssicherung: Record "Quality Management")
    // var
    //     lr_VendCustAnforderungen: Record "Account Requirements";
    //     lr_ContBusRel: Record "Contact Business Relation";
    //     lr_Contact: Record Contact;
    //     lr_Vendor: Record Vendor;
    //     lr_Session: Record Session;
    //     POIFunction: Codeunit POIFunction;
    //     lc_POIQSFunc: Codeunit "POI QS Functions";
    //     l_Company: Text[110];
    //     l_CRLF: Text[2];
    //     l_GLAnforderung: Text[1024];
    // begin
    //     IF pr_Qualitaetssicherung."Anforderung an GL" THEN BEGIN

    //       l_Company := POIFunction.SetAccCompSettingNames(p_CustVendNo,0);

    //       l_CRLF[1] := 13;
    //       l_CRLF[2] := 10;

    //       IF lr_Vendor.GET(p_CustVendNo) THEN;
    //         l_GLAnforderung := l_CRLF + 'Für den oben genannten Kreditor wurde von ' + UPPERCASE(Userid()) +
    //           ' eine Ausnahmegenehmigung angefragt, weil folgende Unterlagen fehlen und der Handel sofort beginnen soll:';

    //       if POIFunction.CheckCompForAccount(lr_Vendor."No.",0,'PI GMBH') OR (lr_Vendor."Customs Agent" OR lr_Vendor."Tax Representative" OR
    //         lr_Vendor."Diverse Vendor" OR lr_Vendor."Shipping Company")
    //       THEN BEGIN
    //         lr_VendCustAnforderungen.Reset();
    //         lr_VendCustAnforderungen.SETRANGE("Source Type",lr_VendCustAnforderungen."Source Type"::Vendor);
    //         lr_VendCustAnforderungen.SETRANGE("Source No.",p_CustVendNo);
    //         IF lr_VendCustAnforderungen.FIND('-') THEN BEGIN
    //           IF NOT pr_Qualitaetssicherung.Blankobriefkopf THEN BEGIN
    //             l_GLAnforderung += l_CRLF ;
    //             l_GLAnforderung += '- Blankobriefkopf / Beispielbriefkopf fehlt';
    //           END;
    //           IF NOT pr_Qualitaetssicherung."Externes Stammblatt" THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN BEGIN
    //               l_GLAnforderung += l_CRLF + '- Lieferantenstammblatt ist noch nicht unterzeichnet zurück';
    //             END ELSE
    //               l_GLAnforderung += l_CRLF + l_CRLF + '- Lieferantenstammblatt ist noch nicht unterzeichnet zurück';
    //           END;
    //           IF (NOT pr_Qualitaetssicherung."Authentizität bekannt") AND
    //             (pr_Qualitaetssicherung."Verifikation Adresse" = pr_Qualitaetssicherung."Verifikation Adresse"::"nicht erfolgt") AND
    //             (pr_Qualitaetssicherung.VerifikationGeschäftstätigkeit =
    //               pr_Qualitaetssicherung.VerifikationGeschäftstätigkeit::"nicht erfolgt")
    //             AND (pr_Qualitaetssicherung.Verifikationsanruf = pr_Qualitaetssicherung.Verifikationsanruf::"nicht erfolgt")
    //           THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN
    //               l_GLAnforderung += l_CRLF + '- Verzicht auf Verifikation Geschäftstätigkeit und/oder Adresse'''
    //           END;
    //           IF NOT pr_Qualitaetssicherung.Handelsregisterauszug THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN BEGIN
    //               l_GLAnforderung += l_CRLF + '- Handelsregisterauszug fehlt';
    //             END ELSE
    //               l_GLAnforderung += l_CRLF + l_CRLF + '- Handelsregisterauszug fehlt';
    //           END;

    //           IF NOT pr_Qualitaetssicherung."Prüfung Kundenunterschrift" THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN BEGIN
    //               l_GLAnforderung += l_CRLF + '- Unterschrift auf Kreditorenstammblatt stimmt nicht mit HR-Auszug/Auskunftei überein';
    //             END ELSE
    //               l_GLAnforderung += l_CRLF + l_CRLF +
    //                 '- Unterschrift auf Kreditorenstammblatt stimmt nicht mit HR-Auszug/Auskunftei überein';
    //           END;
    //         END;
    //       END ELSE BEGIN
    //         lr_VendCustAnforderungen.Reset();
    //         lr_VendCustAnforderungen.SETRANGE("Source Type",lr_VendCustAnforderungen."Source Type"::Vendor);
    //         lr_VendCustAnforderungen.SETRANGE("Source No.",p_CustVendNo);
    //         IF lr_VendCustAnforderungen.FIND('-') THEN BEGIN
    //           IF NOT pr_Qualitaetssicherung.Blankobriefkopf THEN BEGIN
    //             l_GLAnforderung += l_CRLF ;
    //             l_GLAnforderung += '- Blankobriefkopf / Beispielbriefkopf fehlt';
    //           END;
    //           IF NOT pr_Qualitaetssicherung."Externes Stammblatt" THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN BEGIN
    //               l_GLAnforderung += l_CRLF + '- Lieferantenstammblatt ist noch nicht unterzeichnet zurück';
    //             END ELSE
    //               l_GLAnforderung += l_CRLF + l_CRLF + '- Lieferantenstammblatt ist noch nicht unterzeichnet zurück';
    //           END;
    //           IF NOT lr_VendCustAnforderungen."QS Vorliegen LFB" THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN BEGIN
    //               l_GLAnforderung += l_CRLF + '- Nichtvorliegen eines gültigen Lieferantenfragebogens';
    //             END ELSE
    //               l_GLAnforderung += l_CRLF + l_CRLF + '- Nichtvorliegen eines gültigen Lieferantenfragebogens';
    //           END;
    //           IF NOT lr_VendCustAnforderungen."QS Gültige Zertifikate" THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN BEGIN
    //               l_GLAnforderung += l_CRLF + '- Nichtvorliegen der gültigen Zertifikate [Qualität- und Sozialstandard]';
    //             END ELSE
    //               l_GLAnforderung += l_CRLF + l_CRLF + '- Nichtvorliegen der gültigen Zertifikate [Qualität- und Sozialstandard]';
    //           END;

    //           IF NOT POIFunction.CheckCompForAccount(lr_Contact."No.",0,'PI GMBH') AND (lr_Contact."Supplier of Goods")
    //           THEN BEGIN
    //             IF NOT lr_VendCustAnforderungen."QS Laborbericht Konform" THEN BEGIN
    //               IF l_GLAnforderung <> '' THEN BEGIN
    //                 l_GLAnforderung += l_CRLF + '- Nichtvorliegen eines konformen Laborberichts';
    //               END ELSE
    //                 l_GLAnforderung += l_CRLF + l_CRLF + '- Nichtvorliegen eines konformen Laborberichts';
    //             END;
    //           END;
    //           IF (NOT pr_Qualitaetssicherung."Authentizität bekannt") AND
    //             (pr_Qualitaetssicherung."Verifikation Adresse" = pr_Qualitaetssicherung."Verifikation Adresse"::"nicht erfolgt") AND
    //             (pr_Qualitaetssicherung.VerifikationGeschäftstätigkeit =
    //               pr_Qualitaetssicherung.VerifikationGeschäftstätigkeit::"nicht erfolgt")
    //             AND (pr_Qualitaetssicherung.Verifikationsanruf = pr_Qualitaetssicherung.Verifikationsanruf::"nicht erfolgt")
    //           THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN
    //               l_GLAnforderung += l_CRLF + '- Verzicht auf Verifikation Geschäftstätigkeit und/oder Adresse';
    //           END;
    //           IF NOT pr_Qualitaetssicherung.Handelsregisterauszug THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN BEGIN
    //               l_GLAnforderung += l_CRLF + '- Handelsregisterauszug fehlt';
    //             END ELSE
    //               l_GLAnforderung += l_CRLF + l_CRLF + '- Handelsregisterauszug fehlt';
    //           END;
    //           IF NOT pr_Qualitaetssicherung."Prüfung Kundenunterschrift" THEN BEGIN
    //             IF l_GLAnforderung <> '' THEN BEGIN
    //               l_GLAnforderung += l_CRLF + '- Unterschrift auf Kreditorenstammblatt stimmt nicht mit HR-Auszug/Auskunftei überein';
    //             END ELSE
    //               l_GLAnforderung += l_CRLF + l_CRLF +
    //                 '- Unterschrift auf Kreditorenstammblatt stimmt nicht mit HR-Auszug/Auskunftei überein';
    //           END;
    //         END;
    //       END;

    //       l_GLAnforderung += l_CRLF + l_CRLF + 'Bitte Ausnahmegenehmigung genehmigen oder ablehnen in Navision ' +
    //         'unter der Funktion "Kreditoren Prüfung zur Neuanlage", aufrufbar über die Kreditorenkarte.';

    //       lr_Session.Reset();
    //       lr_Session.SETRANGE("My Session",TRUE);
    //       lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //       lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //       IF lr_Session.FINDFIRST() THEN BEGIN
    //         IF l_GLAnforderung <> '' THEN
    //           RequesterMail(p_CustVendNo,p_SourceType,l_Company,l_GLAnforderung);
    //       END;
    //     END;
    // end;

    // procedure MailKreditlimitTeil(p_CustVendNo: Code[20];p_SourceType: Option Vendor,"Vendor Group",Customer,"Customer Group";p_VorkasseStatus: Option " ",beantragt,genehmigt,teilgenehmigt,abgelehnt;p_LimitBeantragt: Decimal;p_LimitTeil: Integer)
    // var
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_Vendor: Record Vendor;
    //     lr_SalesPurch: Record "Salesperson/Purchaser";
    //     lr_Session: Record Session;
    //     lc_POIQSFunc: Codeunit "POI QS Functions";
    //     lc_Mail: Codeunit Mail;
    //     l_CRLF: Text[2];
    //     l_AnfordererMail: Text[80];
    //     l_KreditlimitTeil: Text[1024];
    //     l_Subject: Text[100];
    //     l_BodyLine: Text[1024];
    // begin
    //     //-POI-JW 29.05.18
    //     IF lr_Qualitaetssicherung.GET(p_CustVendNo,lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
    //       IF lr_Qualitaetssicherung."Anforderung an GL" THEN BEGIN

    //         /*
    //         lr_ContBusRel.Reset();
    //         lr_ContBusRel.SETCURRENTKEY("Link to Table","No.");
    //         lr_ContBusRel.SETRANGE("Link to Table",lr_ContBusRel."Link to Table"::Vendor);
    //         lr_ContBusRel.SETRANGE("No.",p_CustVendNo);
    //         IF lr_ContBusRel.FIND('-') THEN BEGIN
    //           lr_Contact.GET(lr_ContBusRel."Contact No.");
    //           IF lr_Contact."PI European Sourcing" THEN
    //             l_Company := 'PI European Sourcing';
    //           IF lr_Contact."PI Fruit" THEN
    //             IF l_Company <> '' THEN BEGIN
    //               l_Company += '|';
    //               l_Company += 'PI Fruit';
    //           END ELSE
    //             l_Company += 'PI Fruit';
    //           IF lr_Contact."PI Organics" THEN
    //             IF l_Company <> '' THEN BEGIN
    //               l_Company += '|';
    //               l_Company += 'PI Organics';
    //           END ELSE
    //             l_Company += 'PI Organics';
    //           IF lr_Contact."PI Bananas" THEN
    //             IF l_Company <> '' THEN BEGIN
    //               l_Company += '|';
    //               l_Company += 'PI Bananas';
    //           END ELSE
    //             l_Company += 'PI Bananas';
    //           IF lr_Contact."PI Dutch Growers" THEN
    //             IF l_Company <> '' THEN BEGIN
    //               l_Company += '|';
    //               l_Company += 'PI Dutch Growers';
    //           END ELSE
    //             l_Company += 'PI Dutch Growers';
    //           IF lr_Contact."PI GmbH" THEN
    //             IF l_Company <> '' THEN BEGIN
    //               l_Company += '|';
    //               l_Company += 'Port International GmbH';
    //           END ELSE
    //             l_Company += 'Port International GmbH';
    //         END;
    //         */

    //         l_CRLF[1] := 13;
    //         l_CRLF[2] := 10;

    //         l_Subject := '';
    //         l_BodyLine := '';

    //         IF lr_Vendor.GET(p_CustVendNo) THEN BEGIN
    //           CLEAR(lc_Mail);

    //           lr_Session.Reset();
    //           lr_Session.SETRANGE("My Session",TRUE);
    //           lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //           lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //           IF lr_Session.FINDFIRST() THEN BEGIN
    //             IF p_VorkasseStatus = p_VorkasseStatus::teilgenehmigt THEN BEGIN
    //               l_Subject := 'Teilkreditlimit genehmigt: Neuer Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name;

    //               lr_SalesPurch.Reset();
    //               lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Anforderung an GL User ID");
    //               IF lr_SalesPurch.FINDFIRST() THEN
    //                 l_AnfordererMail := lr_SalesPurch."E-Mail";

    //               l_KreditlimitTeil := l_CRLF + 'Für den Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' ' +
    //                 'wurde nur ein Teil des beantragten Kreditlimits genehmigt: von ' + FORMAT(p_LimitBeantragt) +
    //                 ' ' + 'EUR nur ' + FORMAT(p_LimitTeil) + ' EUR';

    //               l_BodyLine := l_KreditlimitTeil;

    //               lc_Mail.NewMessage(l_AnfordererMail /*An*/,'julita@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );

    //             END ELSE IF p_VorkasseStatus = p_VorkasseStatus::abgelehnt THEN BEGIN
    //               l_Subject := 'Kreditlimit abgelehnt: Neuer Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name;

    //               lr_SalesPurch.Reset();
    //               lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Anforderung an GL User ID");
    //               IF lr_SalesPurch.FINDFIRST() THEN
    //                 l_AnfordererMail := lr_SalesPurch."E-Mail";

    //               l_KreditlimitTeil := l_CRLF + 'Für den Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' ' +
    //                 'wurde das Kreditlimit abgelehnt';

    //               l_BodyLine := l_KreditlimitTeil;

    //               lc_Mail.NewMessage(l_AnfordererMail /*An*/,'julita@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //           END;
    //         END;
    //       END;
    //     END;
    //     //+POI-JW 29.05.18

    // end;

    // procedure MailAfterCreateVendFromContact(p_CustVendNo: Code[20];pr_Contact: Record Contact)
    // var
    //     lr_Vendor: Record Vendor;
    //     lr_Customer: Record "Customer";
    //     lr_Session: Record Session;
    //     lr_ContBusRel: Record "Contact Business Relation";
    //     lr_Contact: Record Contact;
    //     lr_SalesPurch: Record "Salesperson/Purchaser";
    //     lc_Mail: Codeunit Mail;
    //     POIFunction: Codeunit POIFunction;
    //     ///???lc_SingleInstance: Codeunit "60020";
    //     l_CRLF: Text[2];
    //     l_Subject: Text[100];
    //     l_BodyLine: Text[1024];
    //     l_VendorTyp: Text[100];
    //     l_ContactNewCompany: Boolean;
    //     l_LFBForCompany: Text[100];
    // begin
    //     //Mail nur aus Vendor

    //     ///???lc_SingleInstance.get_ContactNewCompany(l_ContactNewCompany);
    //     IF l_ContactNewCompany THEN BEGIN
    //       lr_Vendor.CHANGECOMPANY('StammdatenPort');
    //       lr_Customer.CHANGECOMPANY('StammdatenPort');
    //     END;

    //     lr_Session.Reset();
    //     lr_Session.SETRANGE("My Session",TRUE);
    //     lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //     lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //     IF lr_Session.FINDFIRST() THEN BEGIN
    //       IF lr_Vendor.GET(p_CustVendNo) THEN
    //         CLEAR(lc_Mail);
    //       IF lr_Customer.GET(p_CustVendNo) THEN
    //         CLEAR(lc_Mail);

    //       l_CRLF[1] := 13;
    //       l_CRLF[2] := 10;

    //       l_Subject := STRSUBSTNO(TXT_SubjectMailAfterCreateVend,p_CustVendNo,lr_Vendor.Name);

    //       IF pr_Contact."Supplier of Goods" THEN
    //         l_VendorTyp := 'Warenlieferant';
    //       IF pr_Contact.Carrier THEN
    //         IF l_VendorTyp <> '' THEN BEGIN
    //           l_VendorTyp += '|';
    //           l_VendorTyp += 'Transporteur';
    //       END ELSE
    //         l_VendorTyp += 'Transporteur';
    //       IF pr_Contact."Warehouse Keeper" THEN
    //         IF l_VendorTyp <> '' THEN BEGIN
    //           l_VendorTyp += '|';
    //           l_VendorTyp += 'Lager / Packer / Reifer';
    //       END ELSE
    //         l_VendorTyp += 'Lager / Packer / Reifer';
    //       IF pr_Contact."Customs Agent" THEN
    //         IF l_VendorTyp <> '' THEN BEGIN
    //           l_VendorTyp += '|';
    //           l_VendorTyp += 'Zollagent';
    //       END ELSE
    //         l_VendorTyp += 'Zollagent';
    //       IF pr_Contact."Tax Representative" THEN
    //         IF l_VendorTyp <> '' THEN BEGIN
    //           l_VendorTyp += '|';
    //           l_VendorTyp += 'Fiskalvertreter';
    //       END ELSE
    //         l_VendorTyp += 'Fiskalvertreter';
    //       IF pr_Contact."Diverse Vendor" THEN
    //         IF l_VendorTyp <> '' THEN BEGIN
    //           l_VendorTyp += '|';
    //           l_VendorTyp += 'Sonstiger Kreditor';
    //       END ELSE
    //         l_VendorTyp += 'Sonstiger Kreditor';
    //       IF pr_Contact."Shipping Company" THEN
    //         IF l_VendorTyp <> '' THEN BEGIN
    //           l_VendorTyp += '|';
    //           l_VendorTyp += 'Reederei und Flugtransport';
    //       END ELSE
    //           l_VendorTyp += 'Reederei und Flugtransport';
    //       IF pr_Contact."Small Vendor" THEN
    //         IF l_VendorTyp <> '' THEN BEGIN
    //           l_VendorTyp += '|';
    //           l_VendorTyp += 'Kleinlieferant Sachkosten-nur PI (max. 1000 EUR)';
    //       END ELSE
    //         l_VendorTyp += 'Kleinlieferant Sachkosten-nur PI (max. 1000 EUR)';

    //       l_LFBForCompany := POIFunction.SetAccCompSettingNames(p_CustVendNo,0);

    //       l_BodyLine := STRSUBSTNO(TXT_MailAfterCreateVend,p_CustVendNo,lr_Vendor.Name,l_VendorTyp,
    //         UPPERCASE(Userid()),l_LFBForCompany);

    //       lc_Mail.NewMessage('accounting@port-international.com;qm-operations@port-international.com' /*An*/,
    //         'julita@port-international.com' /*CC*/,'',
    //         l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //     END;
    // end;

    // procedure MailAfterCreateVend(p_CustVendNo: Code[20])
    // var
    //     lr_Vendor: Record Vendor;
    //     lr_Customer: Record "Customer";
    //     lr_Session: Record Session;
    //     lc_Mail: Codeunit Mail;
    //     l_Subject: Text[100];
    //     l_BodyLine: Text[1024];
    //     LTXT_SubjectAfterCreateVend: Label 'Neuer Kreditor %1 %2 wurde erstellt';
    //     LTXT_MailAfterCreateVend: Label 'Liebe FIBU und QS - Kreditor %1 %2 wurde soeben von %3 erstellt.';
    // begin
    //     //-POI-JW 31.01.18
    //     IF lr_Vendor.GET(p_CustVendNo) THEN
    //       CLEAR(lc_Mail);
    //     IF lr_Customer.GET(p_CustVendNo) THEN
    //       CLEAR(lc_Mail);

    //     lr_Session.Reset();
    //     lr_Session.SETRANGE("My Session",TRUE);
    //     lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //     lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //     IF lr_Session.FINDFIRST() THEN BEGIN
    //       l_Subject := STRSUBSTNO(LTXT_SubjectAfterCreateVend,p_CustVendNo,lr_Vendor.Name);
    //       l_BodyLine := STRSUBSTNO(LTXT_MailAfterCreateVend,p_CustVendNo,lr_Vendor.Name,UPPERCASE(Userid()));
    //       lc_Mail.NewMessage('accounting@port-international.com;qm-operations@port-international.com' /*An*/,
    //         'julita@port-international.com' /*CC*/,'',
    //         l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //     END;
    //     //+POI-JW 31.01.18

    // end;

    // procedure MailKreditlimitIntern(p_CustVendNo: Code[20];p_KreditlimitIntern: Decimal)
    // var
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_Vendor: Record Vendor;
    //     lr_ContBusRel: Record "Contact Business Relation";
    //     lr_Contact: Record Contact;
    //     lr_Session: Record Session;
    //     l_Company: Text[30];
    //     "---": Integer;
    //     lr_SalesPurch: Record "Salesperson/Purchaser";
    //     lc_POIQSFunc: Codeunit "POI QS Functions";
    //     lc_Mail: Codeunit Mail;
    //     POIFunction: Codeunit POIFunction;
    //     l_CRLF: Text[2];
    //     l_AnfordererMail: Text[80];
    //     l_KreditlimitIntern: Text[1024];
    //     l_Subject: Text[100];
    //     l_BodyLine: Text[1024];
    // begin
    //     //-POI-JW 27.07.18
    //     IF lr_Qualitaetssicherung.GET(p_CustVendNo,lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
    //       IF lr_Qualitaetssicherung.Ausnahmegenehmigung = lr_Qualitaetssicherung.Ausnahmegenehmigung::" " THEN BEGIN
    //         lr_Vendor.GET(p_CustVendNo);

    //         l_Company := POIFunction.SetAccCompSettingNames(p_CustVendNo,0);

    //         l_CRLF[1] := 13;
    //         l_CRLF[2] := 10;

    //         l_Subject := '';
    //         l_BodyLine := '';

    //         CLEAR(lc_Mail);

    //         l_Subject := 'Anfrage erhöhtes Kreditlimit intern: Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name;

    //         l_KreditlimitIntern := l_CRLF + 'Für den Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' ' +
    //           'wurde Kreditlimit intern auf ' + FORMAT(p_KreditlimitIntern) + ' EUR erhöht.' + l_CRLF +
    //           'Der Kreditversicherungslimit beträgt ' + FORMAT(lr_Vendor.Kreditlimit) + ' EUR.' + l_CRLF + l_CRLF +
    //           'Bitte Kreditlimit intern genehmigen in Navision ' +
    //           'unter der Funktion "Kreditoren Prüfung zur Neuanlage", aufrufbar über die Kreditorenkarte.';

    //         l_BodyLine := l_KreditlimitIntern;

    //         lr_Session.Reset();
    //         lr_Session.SETRANGE("My Session",TRUE);
    //         lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //         lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //         IF lr_Session.FINDFIRST() THEN BEGIN
    //           IF l_Company = 'P I Dutch Growers' THEN BEGIN
    //             //lc_Mail.NewMessage('Andre@port-international.com;Philippe@port-international.com;Ruben@port-international.com' {An},
    //             lc_Mail.NewMessage('GL-PIDG@port-international.com' /*An*/,
    //               'accounting@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           END;
    //           IF l_Company = 'P I Organics GmbH' THEN BEGIN
    //             //lc_Mail.NewMessage('Mike@port-international.com;Ruben@port-international.com' {An},
    //             lc_Mail.NewMessage('GL-PIO@port-international.com' /*An*/,
    //               'accounting@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           END;
    //           IF l_Company = 'PI Bananas GmbH' THEN BEGIN
    //             //lc_Mail.NewMessage('Mike@port-international.com;Ruben@port-international.com' {An},
    //             lc_Mail.NewMessage('GL-PIB@port-international.com' /*An*/,
    //               'accounting@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           END;
    //           IF l_Company = 'PI European Sourcing' THEN BEGIN
    //             //lc_Mail.NewMessage('Andre@port-international.com;Philippe@port-international.com;Ruben@port-international.com' {An},
    //             lc_Mail.NewMessage('GL-PIES@port-international.com' /*An*/,
    //               'accounting@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           END;
    //           IF l_Company = 'PI Fruit GmbH' THEN BEGIN
    //             //lc_Mail.NewMessage('Andre@port-international.com;Philippe@port-international.com;Ruben@port-international.com' {An},
    //             lc_Mail.NewMessage('GL-PIF@port-international.com' /*An*/,
    //               'accounting@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           END;
    //           IF l_Company = 'Port International GmbH' THEN BEGIN
    //             //lc_Mail.NewMessage('Ruben@port-international.com' {An},
    //             lc_Mail.NewMessage('GL-PI@port-international.com' /*An*/,
    //               'accounting@port-international.com;julita@port-international.com' /*CC*/,'',
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //           END;
    //         END;
    //       END;
    //     END;
    //     //+POI-JW 27.07.18

    // end;

    // procedure CheckVendCustTypeALT(p_TableID: Integer;p_CustVendNo: Code[20])
    // var
    //     Cont: Record Contact;
    //     Vend: Record Vendor;
    //     Cust: Record "Customer";
    // begin
    //     //-POI-JW 28.03.19
    //     IF p_TableID = DATABASE::Contact THEN BEGIN
    //       IF Cont.GET(p_CustVendNo) THEN BEGIN
    //         IF (NOT Cont."Supplier of Goods") AND (NOT Cont.Carrier) AND (NOT Cont."Warehouse Keeper") AND
    //           (NOT Cont."Customs Agent") AND (NOT Cont."Tax Representative") AND
    //           (NOT Cont."Diverse Vendor") AND (NOT Cont."Small Vendor") AND (NOT Cont."Shipping Company")
    //         THEN
    //           ERROR('Lieferantentyp darf nicht leer sein!\Bitte im Kontakt: ' + p_CustVendNo +
    //             'den Lieferatentyp eintragen.');
    //       END;
    //     END ELSE IF p_TableID = DATABASE::Vendor THEN BEGIN
    //       IF Vend.GET(p_CustVendNo) THEN BEGIN
    //         IF (NOT Vend."Supplier of Goods") AND (NOT Vend.Carrier) AND (NOT Vend."Warehouse Keeper") AND
    //           (NOT Vend."Customs Agent") AND (NOT Vend."Tax Representative") AND
    //           (NOT Vend."Diverse Vendor") AND (NOT Vend."Small Vendor") AND (NOT Vend."Shipping Company")
    //         THEN
    //           ERROR('Kreditorentyp darf nicht leer sein!\Bitte im Kreditor: ' + p_CustVendNo +
    //             'den Kreditorentyp eintragen.');
    //       END;
    //     END ELSE IF p_TableID = DATABASE::Customer THEN BEGIN
    //       IF Cust.GET(p_CustVendNo) THEN BEGIN

    //       END;
    //     END;
    //     //+POI-JW 28.03.19
    // end;

    // procedure CheckVendCustType(p_TableID: Integer;p_CustVendNo: Code[20];p_VendCust: Option " ",Kreditor,Debitor;p_Type: Option Company,Person)
    // var
    //     Cont: Record Contact;
    //     Vend: Record Vendor;
    //     Cust: Record "Customer";
    // begin
    //     //-POI-JW 28.03.19
    //     IF p_TableID = DATABASE::Contact THEN BEGIN
    //       IF (p_VendCust = p_VendCust::Kreditor) AND (p_Type = p_Type::Company) THEN BEGIN
    //         IF Cont.GET(p_CustVendNo) THEN BEGIN
    //           IF (NOT Cont."Supplier of Goods") AND (NOT Cont.Carrier) AND (NOT Cont."Warehouse Keeper") AND
    //             (NOT Cont."Customs Agent") AND (NOT Cont."Tax Representative") AND
    //             (NOT Cont."Diverse Vendor") AND (NOT Cont."Small Vendor") AND (NOT Cont."Shipping Company")
    //           THEN
    //             ERROR('Lieferantentyp darf nicht leer sein!\Bitte im Kontakt: ' + p_CustVendNo +
    //               'den Lieferatentyp eintragen.');
    //         END;
    //       END ELSE IF (p_VendCust = p_VendCust::Debitor) AND (p_Type = p_Type::Company) THEN BEGIN
    //         IF Cont.GET(p_CustVendNo) THEN BEGIN
    //      /*noch
    //           IF (NOT Cont."Waren Kunde") AND (NOT Cont.Services) AND (NOT Cont."Diverse Cust") THEN
    //             ERROR('Debitorentyp darf nicht leer sein!\Bitte im Kontakt: ' + p_CustVendNo +
    //               'den Debitorentyp eintragen.');
    //       */
    //         END;
    //       END;
    //     END;


    //     /*ALT:
    //     END ELSE IF p_TableID = DATABASE::Vendor THEN BEGIN
    //       IF Vend.GET(p_CustVendNo) THEN BEGIN
    //         IF (NOT Vend."Supplier of Goods") AND (NOT Vend.Carrier) AND (NOT Vend."Warehouse Keeper") AND
    //           (NOT Vend."Customs Agent") AND (NOT Vend."Tax Representative") AND
    //           (NOT Vend."Diverse Vendor") AND (NOT Vend."Small Vendor") AND (NOT Vend."Shipping Company")
    //         THEN
    //           ERROR('Kreditorentyp darf nicht leer sein!\Bitte im Kreditor: ' + p_CustVendNo +
    //             'den Kreditorentyp eintragen.');
    //       END;
    //     END ELSE IF p_TableID = DATABASE::Customer THEN BEGIN
    //       IF Cust.GET(p_CustVendNo) THEN BEGIN
    //         IF (NOT Cust."Waren Kunde") AND (NOT Cust.Services) AND (NOT Cust."Diverse Cust")
    //         THEN
    //           ERROR('Debitorentyp darf nicht leer sein!\Bitte im Debitor: ' + p_CustVendNo +
    //             'den Debitorentyp eintragen.');
    //       END;
    //     END;
    //     */
    //     //+POI-JW 28.03.19

    // end;

    // procedure MailFromVendorVendTypeChange(p_TableID: Integer;p_CustVendNo: Code[20])
    // var
    //     Vend: Record Vendor;
    //     Cust: Record "Customer";
    //     QualityMgt: Record "Quality Management";
    //     RelPrintDoc: Record "Released Print Documents";
    //     ContBusRel: Record "Contact Business Relation";
    //     Cont: Record Contact;
    //     POIQSFunc: Codeunit "POI QS Functions";
    //     POIFunction: Codeunit POIFunction;
    //     l_Kreditortyp: Text[20];
    //     LERR_Testfield: Label 'Sie müssen noch\\%1 \\ausfüllen.';
    //     l_Debitorentyp: Text[20];
    //     l_Send: Boolean;
    //     LMSG_VendCustTypeMail: Label 'Sobald der Kreditorentyp geändert wird, werden alle notwendigen Unterlagen automatisch versendet.\Folgende Dokumente:\%1 \sind am %2\per Mail an %3\versandt.';
    // begin
    //     //-POI-JW 08.05.18
    //     //wenn Vendortyp Felder geändert wurden -> E-Mail mit neuen Dokumenten
    //     IF (COMPANYNAME = 'StammdatenPort') THEN BEGIN
    //       IF p_TableID = DATABASE::Vendor THEN BEGIN
    //         Vend.GET(p_CustVendNo);
    //         IF (QualityMgt.GET(Vend."No.",QualityMgt."Source Type"::Vendor))
    //           /*AND (QualityMgt."Vend-Cust-LFB created" <> 0DT)
    //         */
    //         THEN BEGIN
    //           IF NOT (Vend."Supplier of Goods") AND NOT (Vend.Carrier) AND NOT (Vend."Warehouse Keeper")
    //             AND NOT (Vend."Customs Agent") AND NOT (Vend."Tax Representative") AND NOT (Vend."Diverse Vendor")
    //             AND NOT (Vend."Shipping Company")
    //           THEN
    //             l_Kreditortyp := 'Kreditorentyp';
    //           IF (l_Kreditortyp <> '') THEN
    //             ERROR(LERR_Testfield,l_Kreditortyp);

    //           ContBusRel.Reset();
    //           ContBusRel.SETCURRENTKEY("Link to Table","No.");
    //           ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
    //           ContBusRel.SETRANGE("No.",Vend."No.");
    //           IF ContBusRel.FIND('-') THEN BEGIN
    //             Cont.Reset();
    //             Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
    //             Cont.SETRANGE(Type,Cont.Type::Company);
    //             IF Cont.FINDFIRST() THEN;
    //           END;

    //           //keine Belege wenn PI StammdatenPort und Sonstiger Kreditor
    //           if not POIFunction.CheckCompForAccount(Cont."No.",0,'PI EUROPEAN SOURCING GMBH') and not POIFunction.CheckCompForAccount(Cont."No.",0,'PI FRUIT GMBH')
    //             and not POIFunction.CheckCompForAccount(Cont."No.",0,'PI BANANAS GMBH') and not POIFunction.CheckCompForAccount(Cont."No.",0,'PI ORGANICS GMBH')
    //             and not POIFunction.CheckCompForAccount(Cont."No.",0,'PI DUTCH GROWERS BV') and not POIFunction.CheckCompForAccount(Cont."No.",0,'PI GMBH') 
    //             and POIFunction.CheckCompForAccount(Cont."No.",0,'PI STAMMDATENPORT') and (Cont."Diverse Vendor" or Cont."Shipping Company")
    //           THEN BEGIN
    //           END ELSE BEGIN
    //             QSLFBMailVendor(DATABASE::Contact,Cont."No.",Vend."E-Mail",Vend."Language Code",Vend);

    //             RelPrintDoc.Reset();
    //             RelPrintDoc.SETRANGE(Source,RelPrintDoc.Source::Purchase);
    //             RelPrintDoc.SETFILTER("Print Document Code",'%1|%2|%3','Kontakt Neuanlage','Kreditor Neuanlage','Kunde Neuanlage');
    //             RelPrintDoc.SETRANGE(Release,TRUE);
    //             RelPrintDoc.SETRANGE("Kind of Release",RelPrintDoc."Kind of Release"::Mail);
    //             RelPrintDoc.SETRANGE("Source Type",RelPrintDoc."Source Type"::Contact);
    //             RelPrintDoc.SETRANGE("Source No.",Cont."No.");
    //             RelPrintDoc.SETRANGE("Released as Mail",TRUE);
    //             RelPrintDoc.SETFILTER("Print Description 1",'<>%1','');
    //             IF RelPrintDoc.FINDLAST THEN BEGIN
    //               MESSAGE(LMSG_VendCustTypeMail,RelPrintDoc."Print Description 1",RelPrintDoc."Last Date of Mail",
    //                 RelPrintDoc."E-Mail")
    //             END;
    //           END;
    //         END;
    //       END ELSE IF p_TableID = DATABASE::Customer THEN BEGIN
    //         Cust.GET(p_CustVendNo);
    //     /*weiter
    //         IF (QualityMgt.GET(Vend."No.",QualityMgt."Source Type"::c))
    //         {AND (QualityMgt."Vend-Cust-LFB created" <> 0DT)
    //         }
    //         THEN BEGIN
    //           IF (NOT Cust."Waren Kunde") AND (NOT Cust.Services) AND (NOT Cust."Diverse Cust")
    //           THEN
    //             l_Debitorentyp := 'Debitorentyp';
    //           IF (l_Debitorentyp <> '') THEN
    //             ERROR(LERR_Testfield,l_Debitorentyp);

    //           ContBusRel.Reset();
    //           ContBusRel.SETCURRENTKEY("Link to Table","No.");
    //           ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::c);
    //           ContBusRel.SETRANGE("No.",Vend."No.");
    //           IF ContBusRel.FIND('-') THEN BEGIN
    //             Cont.Reset();
    //             Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
    //             Cont.SETRANGE(Type,Cont.Type::Company);
    //             IF Cont.FINDFIRST() THEN;
    //           END;

    //           //keine Belege wenn PI StammdatenPort und Sonstiger Kreditor
    //           IF (NOT Cont."PI European Sourcing") AND (NOT Cont."PI Fruit") AND (NOT Cont."PI Organics") AND
    //             (NOT Cont."PI Bananas") AND (NOT Cont."PI Dutch Growers") AND (NOT Cont."PI GmbH") AND
    //             Cont."PI StammdatenPort" AND ((Cont."Diverse Vendor") OR (Cont."Shipping Company"))
    //           THEN BEGIN
    //           END ELSE BEGIN
    //             //weiter QSLFBMailVendor(DATABASE::Contact,Cont."No.",Vend."E-Mail",Vend."Language Code",Vend);

    //             RelPrintDoc.Reset();
    //             RelPrintDoc.SETRANGE(Source,RelPrintDoc.Source::sa);
    //             RelPrintDoc.SETFILTER("Print Document Code",'%1|%2|%3','Kontakt Neuanlage','Debitor Neuanlage','Kunde Neuanlage');
    //             RelPrintDoc.SETRANGE(Release,TRUE);
    //             RelPrintDoc.SETRANGE("Kind of Release",RelPrintDoc."Kind of Release"::Mail);
    //             RelPrintDoc.SETRANGE("Source Type",RelPrintDoc."Source Type"::Contact);
    //             RelPrintDoc.SETRANGE("Source No.",Cont."No.");
    //             RelPrintDoc.SETRANGE("Released as Mail",TRUE);
    //             RelPrintDoc.SETFILTER("Print Description 1",'<>%1','');
    //             IF RelPrintDoc.FINDLAST THEN BEGIN
    //               MESSAGE(LMSG_VendCustTypeMail,RelPrintDoc."Print Description 1",RelPrintDoc."Last Date of Mail",
    //                 RelPrintDoc."E-Mail")
    //             END;
    //           END;
    //         END;
    //     */
    //       END;
    //     END;
    //     //+POI-JW 08.05.18

    // end;

    // procedure "--- Company"()
    // begin
    // end;

    // procedure InitSeriesCompany(p_DefaultNoSeriesCode: Code[10];p_OldNoSeriesCode: Code[10];p_NewDate: Date;var p_NewNo: Code[20];var p_NewNoSeriesCode: Code[10])
    // var
    //     LTXT_NoSeries: Label 'Es ist nicht möglich, Nummern automatisch zuzuweisen';
    // begin
    //     //-POI-JW 21.06.18
    //     IF p_NewNo = '' THEN BEGIN
    //       gr_NoSeriesCompany.CHANGECOMPANY('StammdatenPort');
    //       gr_NoSeriesCompany.GET(p_DefaultNoSeriesCode);
    //       IF NOT gr_NoSeriesCompany."Default Nos." THEN
    //         ERROR(LTXT_NoSeries);

    //       IF p_OldNoSeriesCode <> '' THEN BEGIN
    //         g_NoSeriesCode := p_DefaultNoSeriesCode;
    //         FilterSeriesCompany;
    //         gr_NoSeriesCompany.Code := p_OldNoSeriesCode;
    //         IF NOT gr_NoSeriesCompany.FIND THEN
    //           gr_NoSeriesCompany.GET(p_DefaultNoSeriesCode);
    //       END;
    //       p_NewNo := GetNextNoCompany(gr_NoSeriesCompany.Code,p_NewDate,TRUE);
    //       p_NewNoSeriesCode := gr_NoSeriesCompany.Code;
    //     END;
    //     //+POI-JW 21.06.18
    // end;

    // procedure FilterSeriesCompany()
    // var
    //     lr_NoSeriesRelShipCompany: Record "No. Series Relationship";
    // begin
    //     //-POI-JW 21.06.18
    //     gr_NoSeriesCompany.Reset();
    //     lr_NoSeriesRelShipCompany.CHANGECOMPANY('StammdatenPort');
    //     lr_NoSeriesRelShipCompany.SETRANGE(Code,g_NoSeriesCode);
    //     IF lr_NoSeriesRelShipCompany.FINDSET() THEN
    //       REPEAT
    //         gr_NoSeriesCompany.Code := lr_NoSeriesRelShipCompany."Series Code";
    //         gr_NoSeriesCompany.MARK := TRUE;
    //       UNTIL lr_NoSeriesRelShipCompany.NEXT() = 0;
    //     gr_NoSeriesCompany.GET(g_NoSeriesCode);
    //     gr_NoSeriesCompany.MARK := TRUE;
    //     gr_NoSeriesCompany.MARKEDONLY := TRUE;
    //     //+POI-JW 21.06.18
    // end;

    // procedure GetNextNoCompany(NoSeriesCode: Code[10];SeriesDate: Date;ModifySeries: Boolean): Code[20]
    // var
    //     lr_NoSeriesLineCompany: Record "No. Series Line";
    //     LTXT_CannotAssignDate: Label 'Sie können keine neuen Nummern aus der Nummernserie zuweisen';
    //     LTXT_CannotAssign: Label 'Sie können keine neuen Nummern aus der Nummernserie zuweisen.';
    //     LTXT_CannotAssignDateBefore: Label 'Sie können keine neuen Nummern aus der Nummernserie %1 an einem Datum vor %2 zuweisen.';
    //     LTXT_CannotAssignNumberGreater: Label 'Sie können keine Nummern größer als %1 aus der Nummernserie %2 zuweisen.';
    // begin
    //     //-POI-JW 21.06.18
    //     gr_LastNoSeriesLineCompany.CHANGECOMPANY('StammdatenPort');
    //     lr_NoSeriesLineCompany.CHANGECOMPANY('StammdatenPort');

    //     IF SeriesDate = 0D THEN
    //       SeriesDate := WORKDATE;

    //     IF ModifySeries OR (gr_LastNoSeriesLineCompany."Series Code" = '') THEN BEGIN
    //       IF ModifySeries THEN
    //         lr_NoSeriesLineCompany.LOCKTABLE;
    //       gr_NoSeriesCompany.GET(NoSeriesCode);
    //       SetNoSeriesLineFilterCompany(lr_NoSeriesLineCompany,NoSeriesCode,SeriesDate);
    //       IF NOT lr_NoSeriesLineCompany.FINDFIRST() THEN BEGIN
    //         lr_NoSeriesLineCompany.SETRANGE("Starting Date");
    //         IF NOT lr_NoSeriesLineCompany.isempty()THEN
    //           ERROR(LTXT_CannotAssignDate);
    //         ERROR(LTXT_CannotAssign);
    //       END;
    //     END ELSE
    //       lr_NoSeriesLineCompany := gr_LastNoSeriesLineCompany;
    //     IF gr_NoSeriesCompany."Date Order" AND (SeriesDate < lr_NoSeriesLineCompany."Last Date Used") THEN
    //       ERROR(LTXT_CannotAssignDateBefore,gr_NoSeriesCompany.Code,lr_NoSeriesLineCompany."Last Date Used");
    //     lr_NoSeriesLineCompany."Last Date Used" := SeriesDate;
    //     IF lr_NoSeriesLineCompany."Last No. Used" = '' THEN BEGIN
    //       lr_NoSeriesLineCompany.TESTFIELD("Starting No.");
    //       lr_NoSeriesLineCompany."Last No. Used" := lr_NoSeriesLineCompany."Starting No.";
    //     END ELSE
    //       IF lr_NoSeriesLineCompany."Increment-by No." <= 1 THEN
    //         lr_NoSeriesLineCompany."Last No. Used" := INCSTR(lr_NoSeriesLineCompany."Last No. Used")
    //       ELSE
    //         IncrementNoTextCompany(lr_NoSeriesLineCompany."Last No. Used",lr_NoSeriesLineCompany."Increment-by No.");
    //     IF (lr_NoSeriesLineCompany."Ending No." <> '') AND
    //        (lr_NoSeriesLineCompany."Last No. Used" > lr_NoSeriesLineCompany."Ending No.")
    //     THEN
    //       ERROR(LTXT_CannotAssignNumberGreater,lr_NoSeriesLineCompany."Ending No.",NoSeriesCode);
    //     IF (lr_NoSeriesLineCompany."Ending No." <> '') AND
    //        (lr_NoSeriesLineCompany."Warning No." <> '') AND
    //        (lr_NoSeriesLineCompany."Last No. Used" >= lr_NoSeriesLineCompany."Warning No.") AND
    //        (NoSeriesCode <> g_WarningNoSeriesCode) AND
    //        (g_TryNoSeriesCode = '')
    //     THEN BEGIN
    //       g_WarningNoSeriesCode := NoSeriesCode;
    //       MESSAGE(LTXT_CannotAssignNumberGreater,lr_NoSeriesLineCompany."Ending No.",NoSeriesCode);
    //     END;
    //     lr_NoSeriesLineCompany.VALIDATE(Open);

    //     IF ModifySeries THEN
    //       lr_NoSeriesLineCompany.MODIFY
    //     ELSE
    //       gr_LastNoSeriesLineCompany := lr_NoSeriesLineCompany;
    //     EXIT(lr_NoSeriesLineCompany."Last No. Used");
    //     //+POI-JW 21.06.18
    // end;

    // procedure SetNoSeriesLineFilterCompany(var NoSeriesLine: Record "No. Series Line";NoSeriesCode: Code[10];StartDate: Date)
    // begin
    //     //-POI-JW 21.06.18
    //     IF StartDate = 0D THEN
    //        StartDate := WORKDATE;
    //     NoSeriesLine.Reset();
    //     NoSeriesLine.SETCURRENTKEY("Series Code","Starting Date");
    //     NoSeriesLine.SETRANGE("Series Code",NoSeriesCode);
    //     NoSeriesLine.SETRANGE("Starting Date",0D,StartDate);
    //     IF NoSeriesLine.FINDLAST THEN BEGIN
    //       NoSeriesLine.SETRANGE("Starting Date",NoSeriesLine."Starting Date");
    //       NoSeriesLine.SETRANGE(Open,TRUE);
    //      END;
    //     //+POI-JW 21.06.18
    // end;

    // procedure IncrementNoTextCompany(var No: Code[20];IncrementByNo: Decimal)
    // var
    //     DecimalNo: Decimal;
    //     StartPos: Integer;
    //     EndPos: Integer;
    //     NewNo: Text[30];
    // begin
    //     //-POI-JW 21.06.18
    //     GetIntegerPosCompany(No,StartPos,EndPos);
    //     EVALUATE(DecimalNo,COPYSTR(No,StartPos,EndPos - StartPos + 1));
    //     NewNo := FORMAT(DecimalNo + IncrementByNo,0,1);
    //     ReplaceNoTextCompany(No,NewNo,0,StartPos,EndPos);
    //     //+POI-JW 21.06.18
    // end;

    // procedure GetIntegerPosCompany(No: Code[20];var StartPos: Integer;var EndPos: Integer)
    // var
    //     IsDigit: Boolean;
    //     i: Integer;
    // begin
    //     //-POI-JW 21.06.18
    //     StartPos := 0;
    //     EndPos := 0;
    //     IF No <> '' THEN BEGIN
    //       i := STRLEN(No);
    //       REPEAT
    //         IsDigit := No[i] IN ['0'..'9'];
    //         IF IsDigit THEN BEGIN
    //           IF EndPos = 0 THEN
    //             EndPos := i;
    //           StartPos := i;
    //         END;
    //         i := i - 1;
    //       UNTIL (i = 0) OR (StartPos <> 0) AND NOT IsDigit;
    //     END;
    //     //+POI-JW 21.06.18
    // end;

    // procedure ReplaceNoTextCompany(var No: Code[20];NewNo: Code[20];FixedLength: Integer;StartPos: Integer;EndPos: Integer)
    // var
    //     StartNo: Code[20];
    //     EndNo: Code[20];
    //     ZeroNo: Code[20];
    //     NewLength: Integer;
    //     OldLength: Integer;
    //     LTXT_MoreCharacters: Label 'Die Nummer %1 kann nicht mehr als 20 Zeichen umfassen.';
    // begin
    //     //-POI-JW 21.06.18
    //     IF StartPos > 1 THEN
    //       StartNo := COPYSTR(No,1,StartPos - 1);
    //     IF EndPos < STRLEN(No) THEN
    //       EndNo := COPYSTR(No,EndPos + 1);
    //     NewLength := STRLEN(NewNo);
    //     OldLength := EndPos - StartPos + 1;
    //     IF FixedLength > OldLength THEN
    //       OldLength := FixedLength;
    //     IF OldLength > NewLength THEN
    //       ZeroNo := PADSTR('',OldLength - NewLength,'0');
    //     IF STRLEN(StartNo) + STRLEN(ZeroNo) + STRLEN(NewNo) + STRLEN(EndNo)  > 20 THEN
    //       ERROR(LTXT_MoreCharacters,No);
    //     No := StartNo + ZeroNo + NewNo + EndNo;
    //     //+POI-JW 21.06.18
    // end;

    // procedure InsertVendStammCompany(var pr_Vend: Record Vendor;Cont: Record Contact;p_InsertFromContact: Boolean)
    // var
    //     lr_PurchSetup: Record "Purchases & Payables Setup";
    //     lr_GLSetup: Record "General Ledger Setup";
    //     lr_DefaultDim: Record "Default Dimension";
    //     lr_FruitVisionSetup: Record "5110302";
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_DimValue: Record "Dimension Value";
    //     l_HasGotGLSetup: Boolean;
    //     l_GLSetupShortcutDimCode: array [8] of Code[20];
    // begin
    //     //-POI-JW 22.06.18
    //     pr_Vend.CHANGECOMPANY('StammdatenPort');
    //     lr_PurchSetup.CHANGECOMPANY('StammdatenPort');
    //     lr_GLSetup.CHANGECOMPANY('StammdatenPort');
    //     lr_DefaultDim.CHANGECOMPANY('StammdatenPort');
    //     lr_FruitVisionSetup.CHANGECOMPANY('StammdatenPort');
    //     lr_DimValue.CHANGECOMPANY('StammdatenPort');
    //     lr_Qualitaetssicherung.CHANGECOMPANY('StammdatenPort');

    //     IF pr_Vend."No." = '' THEN BEGIN
    //       lr_PurchSetup.GET();
    //       lr_PurchSetup.TESTFIELD("Vendor Nos.");
    //       InitSeriesCompany(lr_PurchSetup."Vendor Nos.",'',WORKDATE,pr_Vend."No.",pr_Vend."No. Series");
    //       pr_Vend.insert();
    //     END;
    //     IF pr_Vend."Invoice Disc. Code" = '' THEN
    //       pr_Vend."Invoice Disc. Code" := pr_Vend."No.";

    //     /*eigentlich unnötig:   noch ######################################
    //     IF COMPANYNAME = 'StammdatenPort' THEN
    //       IF NOT p_InsertFromContact THEN
    //         UpdateContFromVend.OnInsert(Rec);
    //     */

    //     /*
    //     DimMgt.UpdateDefaultDim(
    //       DATABASE::Vendor,"No.",
    //       "Global Dimension 1 Code","Global Dimension 2 Code");
    //     GetGLSetup;
    //     */
    //     IF NOT l_HasGotGLSetup THEN BEGIN
    //       lr_GLSetup.GET();
    //       l_GLSetupShortcutDimCode[1] := lr_GLSetup."Shortcut Dimension 1 Code";
    //       l_GLSetupShortcutDimCode[2] := lr_GLSetup."Shortcut Dimension 2 Code";
    //       l_GLSetupShortcutDimCode[3] := lr_GLSetup."Shortcut Dimension 3 Code";
    //       l_GLSetupShortcutDimCode[4] := lr_GLSetup."Shortcut Dimension 4 Code";
    //       l_GLSetupShortcutDimCode[5] := lr_GLSetup."Shortcut Dimension 5 Code";
    //       l_GLSetupShortcutDimCode[6] := lr_GLSetup."Shortcut Dimension 6 Code";
    //       l_GLSetupShortcutDimCode[7] := lr_GLSetup."Shortcut Dimension 7 Code";
    //       l_GLSetupShortcutDimCode[8] := lr_GLSetup."Shortcut Dimension 8 Code";
    //       l_HasGotGLSetup := TRUE;
    //     END;

    //     IF lr_DefaultDim.GET(DATABASE::Vendor,pr_Vend."No.",l_GLSetupShortcutDimCode[1]) THEN
    //       pr_Vend."Global Dimension 1 Code" := lr_DefaultDim."Dimension Value Code"
    //     ELSE
    //       pr_Vend."Global Dimension 1 Code" := '';
    //     IF lr_DefaultDim.GET(DATABASE::Vendor,pr_Vend."No.",l_GLSetupShortcutDimCode[2]) THEN
    //       pr_Vend."Global Dimension 2 Code" := lr_DefaultDim."Dimension Value Code"
    //     ELSE
    //       pr_Vend."Global Dimension 2 Code" := '';

    //     //ADF_RecOnInsert();
    //     pr_Vend."Empties Allocation" := pr_Vend."Empties Allocation"::"With Stock-Keeping With Invoice";
    //     pr_Vend."Empties Calculation" := pr_Vend."Empties Calculation"::"Same Document";
    //     pr_Vend."Active Empties Definition" := pr_Vend."Active Empties Definition"::Vendor;
    //     pr_Vend."A.S. Commission Base" := pr_Vend."A.S. Commission Base"::"Gross Sales Revenue";

    //     IF pr_Vend.Blocked = pr_Vend.Blocked::" " THEN BEGIN
    //       lr_FruitVisionSetup.GET();
    //       pr_Vend.Blocked := lr_FruitVisionSetup."Vendor Blocked On Insert";
    //       pr_Vend.Modify();
    //     END;

    //     IF NOT lr_Qualitaetssicherung.GET(pr_Vend."No.",lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
    //       lr_Qualitaetssicherung.INIT();
    //       lr_Qualitaetssicherung."No." := pr_Vend."No.";
    //       lr_Qualitaetssicherung."Source Type" := lr_Qualitaetssicherung."Source Type"::Vendor;
    //       lr_Qualitaetssicherung."Vend-Cust-LFB created" := CREATEDATETIME(WORKDATE,TIME);
    //       IF ((Cont."Customs Agent") OR (Cont."Tax Representative") OR
    //         (Cont."Diverse Vendor") OR (Cont."Shipping Company")) AND
    //         ((NOT Cont."Supplier of Goods") OR (NOT Cont."Warehouse Keeper") OR (NOT Cont.Carrier))
    //       THEN
    //         lr_Qualitaetssicherung.QS := TRUE;
    //       lr_Qualitaetssicherung.insert();
    //     END;

    //     lr_DimValue.INIT();
    //     lr_DimValue."Dimension Code" := 'KREDITOR';
    //     lr_DimValue.Code := pr_Vend."No.";
    //     lr_DimValue.Name := pr_Vend.Name;
    //     lr_DimValue.insert();

    //     lr_DefaultDim.INIT();
    //     lr_DefaultDim."Table ID" := 23;
    //     lr_DefaultDim."No." := pr_Vend."No.";
    //     lr_DefaultDim."Dimension Code" := 'KREDITOR';
    //     lr_DefaultDim."Dimension Value Code" := pr_Vend."No.";
    //     lr_DefaultDim.insert();

    //     lr_DimValue.INIT();
    //     lr_DimValue."Dimension Code" := 'EK von Kreditor';
    //     lr_DimValue.Code := pr_Vend."No.";
    //     lr_DimValue.Name := pr_Vend.Name;
    //     lr_DimValue.insert();
    //     //+POI-JW 22.06.18

    // end;

    // procedure TypeChangeCompany(var pr_Contact: Record Contact)
    // var
    //     lr_RMSetup: Record "Marketing Setup";
    //     lr_InteractLogEntry: Record "Interaction Log Entry";
    //     lr_Opp: Record Opportunity;
    //     lr_Todo: Record "To-do";
    //     lr_Cont: Record Contact;
    //     CampaignTargetGrMgt: Codeunit "Campaign Target Group Mgt";
    //     LTXT_003: Label '%1 cannot be changed because one or more interaction log entries are linked to the contact.';
    //     LTXT_005: Label '%1 cannot be changed because one or more to-dos are linked to the contact.';
    //     LTXT_006: Label '%1 cannot be changed because one or more opportunities are linked to the contact.';
    // begin
    //     //-POI-JW 22.06.18
    //     pr_Contact.CHANGECOMPANY('StammdatenPort');
    //     lr_RMSetup.CHANGECOMPANY('StammdatenPort');
    //     lr_InteractLogEntry.CHANGECOMPANY('StammdatenPort');
    //     lr_Todo.CHANGECOMPANY('StammdatenPort');
    //     lr_Opp.CHANGECOMPANY('StammdatenPort');

    //     lr_RMSetup.GET();

    //     lr_InteractLogEntry.LOCKTABLE;
    //     lr_Todo.LOCKTABLE;
    //     lr_Opp.LOCKTABLE;
    //     lr_Cont.LOCKTABLE;
    //     lr_InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
    //     lr_InteractLogEntry.SETRANGE("Contact Company No.",pr_Contact."Company No.");
    //     lr_InteractLogEntry.SETRANGE("Contact No.",pr_Contact."No.");
    //     IF lr_InteractLogEntry.FIND('-') THEN
    //       ERROR(LTXT_003,pr_Contact.FIELDCAPTION(Type));
    //     lr_Todo.SETCURRENTKEY("Contact Company No.","Contact No.");
    //     lr_Todo.SETRANGE("Contact Company No.",pr_Contact."Company No.");
    //     lr_Todo.SETRANGE("Contact No.",pr_Contact."No.");
    //     IF lr_Todo.FIND('-') THEN
    //       ERROR(LTXT_005,pr_Contact.FIELDCAPTION(Type));
    //     lr_Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
    //     lr_Opp.SETRANGE("Contact Company No.",pr_Contact."Company No.");
    //     lr_Opp.SETRANGE("Contact No.",pr_Contact."No.");
    //     IF lr_Opp.FIND('-') THEN
    //       ERROR(LTXT_006,pr_Contact.FIELDCAPTION(Type));

    //     CASE pr_Contact.Type OF
    //       pr_Contact.Type::Company:
    //         BEGIN
    //           pr_Contact.TESTFIELD("Organizational Level Code",'');
    //           pr_Contact.TESTFIELD("No. of Job Responsibilities",0);
    //           pr_Contact."First Name" := '';
    //           pr_Contact."Middle Name" := '';
    //           pr_Contact.Surname := '';
    //           pr_Contact."Job Title" := '';
    //           pr_Contact."Company No." := pr_Contact."No.";
    //           pr_Contact."Company Name" := pr_Contact.Name;

    //     /*noch: ????????????? ###################################
    //           SearchManagement.ParseField(pr_Contact."No.",pr_Contact."No.",pr_Contact."Company Name",
    //             SearchWordDetail."Table Name"::Contact,pr_Contact.FIELDNO("Company Name"));
    //     */

    //           pr_Contact."Salutation Code" := lr_RMSetup."Def. Company Salutation Code";
    //         END;
    //     END;
    //     //pr_Contact.VALIDATE("Lookup Contact No.");
    //     IF pr_Contact.Type = pr_Contact.Type::Company THEN
    //       pr_Contact."Lookup Contact No." := ''
    //     ELSE
    //       pr_Contact."Lookup Contact No." := pr_Contact."No.";

    //     /*noch:  ???????????????? ###############################
    //     IF lr_Cont.GET(pr_Contact."No.") THEN BEGIN
    //       IF pr_Contact.Type = pr_Contact.Type::Company THEN
    //         CheckDupl
    //       ELSE
    //         DuplMgt.RemoveContIndex(pr_Contact,FALSE);
    //     END;
    //     */
    //     //+POI-JW 22.06.18

    // end;

    // procedure InsertNewContactPerson(p_TableID: Integer;p_CustVendNo: Code[20];LocalCall: Boolean)
    // var
    //     RMSetup: Record "Marketing Setup";
    //     ContComp: Record Contact;
    //     Cont: Record Contact;
    //     ContBusRel: Record "Contact Business Relation";
    //     Vend: Record Vendor;
    //     Cust: Record "Customer";
    // begin
    //     //-POI-JW 02.04.19
    //     IF NOT LocalCall THEN BEGIN
    //       RMSetup.GET();
    //       RMSetup.TESTFIELD("Bus. Rel. Code for Vendors");
    //     END;

    //     IF p_TableID = DATABASE::Vendor THEN BEGIN
    //       Vend.GET(p_CustVendNo);
    //       ContBusRel.SETCURRENTKEY("Link to Table","No.");
    //       ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Vendor);
    //       ContBusRel.SETRANGE("No.",p_CustVendNo);
    //       IF ContBusRel.FIND('-') THEN BEGIN
    //         IF ContComp.GET(ContBusRel."Contact No.") THEN BEGIN
    //           WITH Cont DO BEGIN
    //             INIT();
    //             "No." := '';
    //             INSERT(TRUE);
    //             Cont.VendororCustomer:= Cont.Cont.VendororCustomer::Kreditor;
    //             "Company No." := ContComp."No.";
    //             Type := Type::Person;
    //             VALIDATE(Name,ContComp.Name);
    //             "Company Name" := ContComp."Company Name";
    //             "Salesperson Code" := ContComp."Salesperson Code";
    //             "Country/Region Code" := ContComp."Country/Region Code";
    //             "Language Code" := ContComp."Language Code";
    //             Address := ContComp.Address;
    //             "Address 2" := Vend."Address 2";
    //             "Post Code" := ContComp."Post Code";
    //             City := ContComp.City;
    //             County := ContComp.County;
    //             //"Phone No." := ContComp."Phone No.";
    //             "Telex No." := ContComp."Telex No.";
    //             "Fax No." := ContComp."Fax No.";
    //             //VALIDATE("E-Mail",ContComp."E-Mail");
    //             "Home Page" := ContComp."Home Page";
    //             //"Mobile Phone No." := ContComp."Mobile Phone No.";
    //             "Correspondence Type" := Cont."Correspondence Type"::"E-Mail";
    //             MODIFY(TRUE);
    //           END
    //         END;
    //         //???InheritCompanyToPersonData(Cont);
    //         Cont.Modify();
    //       END;
    //     END ELSE IF p_TableID = DATABASE::Customer THEN BEGIN
    //       Cust.GET(p_CustVendNo);
    //       Vend.GET(p_CustVendNo);
    //       ContBusRel.SETCURRENTKEY("Link to Table","No.");
    //       ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
    //       ContBusRel.SETRANGE("No.",p_CustVendNo);
    //       IF ContBusRel.FIND('-') THEN BEGIN
    //         IF ContComp.GET(ContBusRel."Contact No.") THEN BEGIN
    //           WITH Cont DO BEGIN
    //             INIT();
    //             "No." := '';
    //             INSERT(TRUE);
    //             Cont.VendororCustomer := Cont.VendororCustomer::Vendor;
    //             "Company No." := ContComp."No.";
    //             Type := Type::Person;
    //             VALIDATE(Name,ContComp.Name);
    //             "Company Name" := ContComp."Company Name";
    //             "Salesperson Code" := ContComp."Salesperson Code";
    //             "Country/Region Code" := ContComp."Country/Region Code";
    //             "Language Code" := ContComp."Language Code";
    //             Address := ContComp.Address;
    //             "Address 2" := Cust."Address 2";
    //             "Post Code" := ContComp."Post Code";
    //             City := ContComp.City;
    //             County := ContComp.County;
    //             "Telex No." := ContComp."Telex No.";
    //             "Fax No." := ContComp."Fax No.";
    //             "Home Page" := ContComp."Home Page";
    //             "Correspondence Type" := Cont."Correspondence Type"::"E-Mail";
    //             MODIFY(TRUE);
    //           END
    //         END;
    //         //???InheritCompanyToPersonData(Cont);
    //         Cont.Modify();
    //       END;
    //     END;
    //     Page.RUN(Page::"Contact Card",Cont);
    // end;

    // procedure LFBVendCustCheckDate()
    // var
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_ContBusRel: Record "Contact Business Relation";
    //     lr_Contact: Record Contact;
    //     ltr_LFBBuffer: Record "50910" temporary;
    //     ltr_ExcelBuffer: Record "Excel Buffer" temporary;
    //     lr_Vend: Record Vendor;
    //     lr_SalesPurch: Record "Salesperson/Purchaser";
    //     lr_Session: Record Session;
    //     lc_PortSystem: Codeunit "5110798";
    //     lc_Mail: Codeunit Mail;
    //     POIFunction: Codeunit POIFunction;
    //     l_RowNo: Integer;
    //     l_LfdNo: Integer;
    //     l_Company: Text[110];
    //     FileName: Text[250];
    //     l_CRLF: Text[2];
    //     l_Subject: Text[250];
    //     l_BodyLine: Text[1024];
    //     l_VendorTyp: Text[100];
    //     l_Comment: Text[1024];
    //     LTXT_MailAusnahme: Label 'Für den Kreditor';
    //     LTXT_MailAusnahme1: Label 'wird die Ausnahmegenehmigung am';
    //     LTXT_MailAusnahme2: Label 'ablaufen. Beim Ablauf wird der Kreditor von FIBU gesperrt. ';
    //     LTXT_MailAusnahme3: Label 'Bitte bis dahin die fehlenden Punkte erledigen bzw. in Ausnahmefällen befristete Verlängerung beantragen!';
    //     l_GLMail: Text[80];
    //     LTXT_MailAusnahmeEnd1: Label 'ist die Ausnahmegenehmigung am %1';
    //     LTXT_MailAusnahmeEnd2: Label 'abgelaufen. Der Kreditor sollte von FIBU gesperrt werden.';
    //     "-- del": Integer;
    //     cu_mail: Codeunit "SMTP Mail";
    // begin
    //     //ist noch offen - soll regelmäßig ausgeführt werden
    //     /*
    //     //NAS Test
    //      CLEAR(cu_mail);
    //      cu_mail.CreateMessage('','julita@port-international.com','','NAS - SMTP - Test','',TRUE);
    //      cu_mail.AppendBody('Mail aus C60013');
    //      cu_mail.Send;
    //     */

    //     //-POI-JW 31.11.16
    //     IF COMPANYNAME <> 'StammdatenPort' THEN BEGIN
    //       lr_Qualitaetssicherung.CHANGECOMPANY('StammdatenPort');
    //       lr_Vend.CHANGECOMPANY('StammdatenPort');
    //       lr_SalesPurch.CHANGECOMPANY('StammdatenPort');

    //       //ltr_ExcelBuffer.CHANGECOMPANY('StammdatenPort');
    //     END;

    //     //neu Erinnerung 4.12.18;
    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Freigabe für Kreditor",TRUE);
    //     lr_Qualitaetssicherung.SETRANGE(Ausnahmegenehmigung,lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt);
    //     IF GUIALLOWED THEN
    //       lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'=%1',CALCDATE('+10T',WORKDATE))
    //     ELSE
    //       lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'=%1',CALCDATE('+10D',WORKDATE));
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         l_Company := '';
    //         IF lr_Vend.GET(lr_Qualitaetssicherung."No.") THEN;

    //         l_Company := POIFunction.SetAccCompSettingNames(lr_Vend."No.",0);

    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Ausnahmeg. erteilt durch");
    //         IF lr_SalesPurch.FIND('-') THEN
    //           l_GLMail := lr_SalesPurch."E-Mail";
    //         IF lr_SalesPurch.GET(lr_Vend."Purchaser Code") THEN;

    //         l_CRLF[1] := 13;
    //         l_CRLF[2] := 10;
    //         CLEAR(lc_Mail);

    //         l_Subject := 'Ablauf der Ausnahmegenehmigung - ' + 'Kreditor ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name +
    //           ' Mandant: ' + l_Company;
    //         l_BodyLine := LTXT_MailAusnahme + ' ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name + ' ' +
    //           LTXT_MailAusnahme1 + ' ' + FORMAT(lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf") + ' ' +
    //           LTXT_MailAusnahme2 + LTXT_MailAusnahme3;

    //         IF NOT lr_Contact."Diverse Vendor" THEN BEGIN
    //           lr_Session.Reset();
    //           lr_Session.SETRANGE("My Session",TRUE);
    //           lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //           lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //           IF lr_Session.FINDFIRST() THEN BEGIN
    //             IF STRPOS(l_Company,'Sourcing') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIES-Operations@port-international.com;accounting@port-international.com' /*An*/,'',
    //                 'qm-operations@port-international.com' /*CC*/,
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Fruit') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIF-Operations@port-international.com;accounting@port-international.com' /*An*/,'',
    //                 'qm-operations@port-international.com' /*CC*/,
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Dutch') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIDG-Operations@port-international.com;accounting@port-international.com' /*An*/,'',
    //                 'qm-operations@port-international.com' /*CC*/,
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Organics') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage('VL_Abwicklung_Banane@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Bananas') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage('VL_Abwicklung_Banane@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //           END;
    //         END;
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;

    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Freigabe für Kreditor",TRUE);
    //     lr_Qualitaetssicherung.SETRANGE(Ausnahmegenehmigung,lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt);
    //     IF GUIALLOWED THEN
    //       lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'=%1',CALCDATE('+3T',WORKDATE))
    //     ELSE
    //       lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'=%1',CALCDATE('+3D',WORKDATE));
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         l_Company := '';
    //         IF lr_Vend.GET(lr_Qualitaetssicherung."No.") THEN;

    //         l_Company := POIFunction.SetAccCompSettingNames(lr_Vend."No.",0);

    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Ausnahmeg. erteilt durch");
    //         IF lr_SalesPurch.FIND('-') THEN
    //           l_GLMail := lr_SalesPurch."E-Mail";
    //         IF lr_SalesPurch.GET(lr_Vend."Purchaser Code") THEN;

    //         l_CRLF[1] := 13;
    //         l_CRLF[2] := 10;
    //         CLEAR(lc_Mail);

    //         l_Subject := 'Ablauf der Ausnahmegenehmigung - ' + 'Kreditor ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name +
    //           ' Mandant: ' + l_Company;
    //         l_BodyLine := LTXT_MailAusnahme + ' ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name + ' ' +
    //           LTXT_MailAusnahme1 + ' ' + FORMAT(lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf") + ' ' +
    //           LTXT_MailAusnahme2 + LTXT_MailAusnahme3;

    //         IF NOT lr_Contact."Diverse Vendor" THEN BEGIN
    //           lr_Session.Reset();
    //           lr_Session.SETRANGE("My Session",TRUE);
    //           lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //           lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //           IF lr_Session.FINDFIRST() THEN BEGIN
    //             IF STRPOS(l_Company,'Sourcing') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIES-Operations@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Fruit') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIF-Operations@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Dutch') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIDG-Operations@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Organics') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage('VL_Abwicklung_Banane@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Bananas') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage('VL_Abwicklung_Banane@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //           END;
    //         END;
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;

    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Freigabe für Kreditor",TRUE);
    //     lr_Qualitaetssicherung.SETRANGE(Ausnahmegenehmigung,lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt);
    //     lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'<=%1',WORKDATE);
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         l_Company := '';
    //         IF lr_Vend.GET(lr_Qualitaetssicherung."No.") THEN;
    //         l_Company := POIFunction.SetAccCompSettingNames(lr_Vend."No.",0);

    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Ausnahmeg. erteilt durch");
    //         IF lr_SalesPurch.FIND('-') THEN
    //           l_GLMail := lr_SalesPurch."E-Mail";
    //         IF lr_SalesPurch.GET(lr_Vend."Purchaser Code") THEN;

    //         l_CRLF[1] := 13;
    //         l_CRLF[2] := 10;
    //         CLEAR(lc_Mail);

    //         l_Subject := 'Ablauf der Ausnahmegenehmigung - ' + 'Kreditor ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name +
    //           ' Mandant: ' + l_Company;
    //         l_BodyLine := l_CRLF + LTXT_MailAusnahme + ' ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name + ' ' +
    //           STRSUBSTNO(LTXT_MailAusnahmeEnd1,lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf") + ' ' + LTXT_MailAusnahmeEnd2;

    //         IF NOT lr_Contact."Diverse Vendor" THEN BEGIN
    //           lr_Session.Reset();
    //           lr_Session.SETRANGE("My Session",TRUE);
    //           lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //           lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //           IF lr_Session.FINDFIRST() THEN BEGIN
    //             IF STRPOS(l_Company,'Sourcing') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIES-Operations@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com;' +
    //                 'Andre@port-international.com;Philippe@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Fruit') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIF-Operations@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com;' +
    //                 'Andre@port-international.com;Philippe@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Dutch') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage(lr_SalesPurch."E-Mail" +
    //                 ';PIDG-Operations@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com;' +
    //                 'Andre@port-international.com;Philippe@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Organics') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage('VL_Abwicklung_Banane@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //             IF STRPOS(l_Company,'Bananas') <> 0 THEN BEGIN
    //               lc_Mail.NewMessage('VL_Abwicklung_Banane@port-international.com;accounting@port-international.com' /*An*/,
    //                 'qm-operations@port-international.com' /*CC*/,'',
    //                 l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //             END;
    //           END;
    //         END;

    //         lr_Qualitaetssicherung.Ausnahmegenehmigung := lr_Qualitaetssicherung.Ausnahmegenehmigung::" ";
    //         lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung" := 0D;
    //         lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf" := 0D;
    //         lr_Qualitaetssicherung."Anforderung an GL" := FALSE;
    //         lr_Qualitaetssicherung.Modify();
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;

    //     ltr_LFBBuffer.DELETEALL();

    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Source Type",lr_Qualitaetssicherung."Source Type"::Vendor);
    //     lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Erinnerung",'<=%1|<>%2',WORKDATE,0D);
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         ltr_LFBBuffer.Reset();
    //         ltr_LFBBuffer.SETRANGE(ltr_LFBBuffer.code1,lr_Qualitaetssicherung."No.");
    //         IF ltr_LFBBuffer.FIND('-') THEN BEGIN
    //           ltr_LFBBuffer.date3 := lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am";
    //           ltr_LFBBuffer.date4 := lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung";
    //           IF lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf" <= WORKDATE THEN
    //             ltr_LFBBuffer.date5 := lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf";
    //           ltr_LFBBuffer.Modify();
    //         END ELSE BEGIN
    //           ltr_LFBBuffer.INIT();
    //           ltr_LFBBuffer.LineNo := l_LfdNo;
    //           ltr_LFBBuffer.code1 := lr_Qualitaetssicherung."No.";
    //           ltr_LFBBuffer.text1 := 'Vendor';
    //           ltr_LFBBuffer.date3 := lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am";
    //           ltr_LFBBuffer.date4 := lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung";
    //           IF lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf" <= WORKDATE THEN
    //             ltr_LFBBuffer.date5 := lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf";
    //           ltr_LFBBuffer."User-ID" := USERID;
    //           ltr_LFBBuffer.insert();
    //         END;
    //         l_LfdNo += 1;
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;

    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Source Type",lr_Qualitaetssicherung."Source Type"::Vendor);
    //     lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'<=%1|<>%2',WORKDATE,0D);
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         ltr_LFBBuffer.Reset();
    //         ltr_LFBBuffer.SETRANGE(ltr_LFBBuffer.code1,lr_Qualitaetssicherung."No.");
    //         IF ltr_LFBBuffer.FIND('-') THEN BEGIN
    //           ltr_LFBBuffer.date3 := lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am";
    //           ltr_LFBBuffer.date5 := lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf";
    //           IF lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung" <= WORKDATE THEN
    //             ltr_LFBBuffer.date4 := lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung";
    //           ltr_LFBBuffer.Modify();
    //         END ELSE BEGIN
    //           ltr_LFBBuffer.INIT();
    //           ltr_LFBBuffer.LineNo := l_LfdNo;
    //           ltr_LFBBuffer.code1 := lr_Qualitaetssicherung."No.";
    //           ltr_LFBBuffer.text1 := 'Vendor';
    //           ltr_LFBBuffer.date3 := lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am";
    //           ltr_LFBBuffer.date5 := lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf";
    //           IF lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung" <= WORKDATE THEN
    //             ltr_LFBBuffer.date4 := lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung";
    //           ltr_LFBBuffer."User-ID" := USERID;
    //           ltr_LFBBuffer.insert();
    //         END;
    //         l_LfdNo += 1;
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;

    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Source Type",lr_Qualitaetssicherung."Source Type"::Customer);
    //     lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Erinnerung",'<=%1|<>%2',WORKDATE,0D);
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         ltr_LFBBuffer.Reset();
    //         ltr_LFBBuffer.SETRANGE(ltr_LFBBuffer.code1,lr_Qualitaetssicherung."No.");
    //         IF ltr_LFBBuffer.FIND('-') THEN BEGIN
    //           ltr_LFBBuffer.date3 := lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am";
    //           ltr_LFBBuffer.date4 := lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung";
    //           IF lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf" <= WORKDATE THEN
    //             ltr_LFBBuffer.date5 := lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf";
    //           ltr_LFBBuffer.Modify();
    //         END ELSE BEGIN
    //           ltr_LFBBuffer.INIT();
    //           ltr_LFBBuffer.LineNo := l_LfdNo;
    //           ltr_LFBBuffer.code1 := lr_Qualitaetssicherung."No.";
    //           ltr_LFBBuffer.text1 := 'Customer';
    //           ltr_LFBBuffer.date3 := lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am";
    //           ltr_LFBBuffer.date4 := lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung";
    //           IF lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf" <= WORKDATE THEN
    //             ltr_LFBBuffer.date5 := lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf";
    //           ltr_LFBBuffer."User-ID" := USERID;
    //           ltr_LFBBuffer.insert();
    //         END;
    //         l_LfdNo += 1;
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;

    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Source Type",lr_Qualitaetssicherung."Source Type"::Customer);
    //     lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'<=%1|<>%2',WORKDATE,0D);
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         ltr_LFBBuffer.Reset();
    //         ltr_LFBBuffer.SETRANGE(ltr_LFBBuffer.code1,lr_Qualitaetssicherung."No.");
    //         IF ltr_LFBBuffer.FIND('-') THEN BEGIN
    //           ltr_LFBBuffer.date3 := lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am";
    //           ltr_LFBBuffer.date5 := lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf";
    //           IF lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung" <= WORKDATE THEN
    //             ltr_LFBBuffer.date4 := lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung";
    //           ltr_LFBBuffer.Modify();
    //         END ELSE BEGIN
    //           ltr_LFBBuffer.INIT();
    //           ltr_LFBBuffer.LineNo := l_LfdNo;
    //           ltr_LFBBuffer.code1 := lr_Qualitaetssicherung."No.";
    //           ltr_LFBBuffer.text1 := 'Customer';
    //           ltr_LFBBuffer.date3 := lr_Qualitaetssicherung."Ausnahmegenehmigung erteilt am";
    //           ltr_LFBBuffer.date5 := lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf";
    //           IF lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung" <= WORKDATE THEN
    //             ltr_LFBBuffer.date4 := lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung";
    //           ltr_LFBBuffer."User-ID" := USERID;
    //           ltr_LFBBuffer.insert();
    //         END;
    //         l_LfdNo += 1;
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;


    //     //{JW NAS Test 11.01.2019

    //     ltr_LFBBuffer.Reset();
    //     ltr_LFBBuffer.SETFILTER(date4,'<>%1',0D);
    //     ltr_LFBBuffer.SETFILTER(date5,'<>%1',0D);
    //     IF ltr_LFBBuffer.FINDSET() THEN BEGIN
    //       FileName := '\\port-data-01\lwp\0_Kreditoren\1_Ablauf Ausnahmegenehmigung\Kreditoren_Neuanlage_Ablaufdaten_'
    //         + FORMAT(WORKDATE) + '.xlsx';

    //     //prüfen wie:
    //     //FileName := '\\PORT-APP-XTRACT\src\Master_VATText.csv';



    //       l_RowNo := 1;
    //       ltr_ExcelBuffer.DELETEALL();
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,1,COMPANYNAME,'',TRUE,FALSE,FALSE);
    //       l_RowNo += 1;
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,1,'','',FALSE,FALSE,FALSE);
    //       l_RowNo += 1;
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,1,'Herkunft','',TRUE,FALSE,FALSE);
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,2,'Kreditoren/Debitoren-Nr.','',TRUE,FALSE,FALSE);
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,3,'Name','',TRUE,FALSE,FALSE);
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,4,'Kreditorentyp','',TRUE,FALSE,FALSE);
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,5,'Einkäufer','',TRUE,FALSE,FALSE);
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,6,'Ausnahmegenehmigung erteilt am','',TRUE,FALSE,FALSE);
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,7,'Ausnahmegenehmigung Ablaufdatum Erinnerung','',TRUE,FALSE,FALSE);
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,8,'Ausnahmegenehmigung Ablaufdatum','',TRUE,FALSE,FALSE);
    //       lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,9,'USER','',TRUE,FALSE,FALSE);
    //       l_RowNo += 1;

    //       REPEAT
    //         l_VendorTyp := '';
    //         IF lr_Vend.GET(ltr_LFBBuffer.code1) THEN;
    //         IF lr_SalesPurch.GET(lr_Vend."Purchaser Code") THEN;
    //         //IF lr_Vend."Is Vendor of Trade Items" THEN
    //         IF lr_Vend."Supplier of Goods" THEN
    //           l_VendorTyp := 'Warenlieferant';
    //         //IF lr_Vend."Is Shipping Agent" THEN
    //         IF lr_Vend.Carrier THEN
    //           IF l_VendorTyp <> '' THEN BEGIN
    //             l_VendorTyp += '|';
    //             l_VendorTyp += 'Transporteur';
    //         END ELSE
    //           l_VendorTyp += 'Transporteur';
    //         //IF lr_Vend."Is Warehouse" THEN
    //         IF lr_Vend."Warehouse Keeper" THEN
    //           IF l_VendorTyp <> '' THEN BEGIN
    //             l_VendorTyp += '|';
    //             l_VendorTyp += 'Lager / Packer / Reifer';
    //         END ELSE
    //           l_VendorTyp += 'Lager / Packer / Reifer';
    //         //IF lr_Vend."Is Custom Clearing Copmany" THEN
    //         IF lr_Vend."Customs Agent" THEN
    //           IF l_VendorTyp <> '' THEN BEGIN
    //             l_VendorTyp += '|';
    //             l_VendorTyp += 'Zollagent';
    //         END ELSE
    //           l_VendorTyp += 'Zollagent';
    //         //IF lr_Vend."Is Fiscal Agent" THEN
    //         IF lr_Vend."Tax Representative" THEN
    //           IF l_VendorTyp <> '' THEN BEGIN
    //             l_VendorTyp += '|';
    //             l_VendorTyp += 'Fiskalvertreter';
    //         END ELSE
    //           l_VendorTyp += 'Fiskalvertreter';
    //         //IF lr_Vend."Is Common Vendor" THEN
    //         IF lr_Vend."Diverse Vendor" THEN
    //           IF l_VendorTyp <> '' THEN BEGIN
    //             l_VendorTyp += '|';
    //             l_VendorTyp += 'Sonstiger Kreditor';
    //         END ELSE
    //           l_VendorTyp += 'Sonstiger Kreditor';
    //         IF lr_Vend."Shipping Company" THEN
    //           IF l_VendorTyp <> '' THEN BEGIN
    //             l_VendorTyp += '|';
    //             l_VendorTyp += 'Reederei und Flugtransport';
    //         END ELSE
    //             l_VendorTyp += 'Reederei und Flugtransport';

    //         l_RowNo += 1;
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,1,ltr_LFBBuffer.text1,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,2,ltr_LFBBuffer.code1,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,3,lr_Vend.Name,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,4,l_VendorTyp,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,5,lr_SalesPurch.Name,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,6,FORMAT(ltr_LFBBuffer.date3),'',FALSE,FALSE,FALSE);
    //         IF ltr_LFBBuffer.date4 <> 0D THEN
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,7,FORMAT(ltr_LFBBuffer.date4),'',TRUE,TRUE,FALSE);
    //         IF ltr_LFBBuffer.date5 <> 0D THEN
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,8,FORMAT(ltr_LFBBuffer.date5),'',TRUE,TRUE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,9,ltr_LFBBuffer."User-ID",'',FALSE,FALSE,FALSE);
    //       UNTIL ltr_LFBBuffer.NEXT() = 0;

    //       ltr_ExcelBuffer.CreateBook;
    //       ltr_ExcelBuffer.CreateSheet('LFB Ablaufdaten','',COMPANYNAME,UserID());
    //       IF EXISTS(FileName) THEN ERASE(FileName);
    //       ltr_ExcelBuffer.SaveBook(FileName);
    //       //wenn angezeigt werden soll
    //       //ltr_ExcelBuffer.GiveUserControl;
    //       //wenn nicht sofort angezeigt werden soll:
    //       ltr_ExcelBuffer.ClearApp;
    //     END ELSE
    //       IF GUIALLOWED THEN
    //         MESSAGE(MSG_KeineAblaufdaten);

    // end;

    procedure CheckVendBeforePurchOrder(pr_PurchHeader: Record "Purchase Header")
    var
        lr_Contact: Record Contact;
        LERR_PurchOrderNotPossibleTxt: Label 'Kreditor %1 wurde für Port International GmbH und als Diver Kreditor definiert.\Sie können für diesen Kreditor keine Bestellungen erzeugen.', Comment = '%1';
    begin
        IF lr_Vendor.GET(pr_PurchHeader."Buy-from Vendor No.") THEN BEGIN
            lr_ConBusRel.RESET();
            lr_ConBusRel.SETRANGE("Link to Table", lr_ConBusRel."Link to Table"::Vendor);
            lr_ConBusRel.SETRANGE("No.", pr_PurchHeader."Buy-from Vendor No.");
            IF lr_ConBusRel.FINDFIRST() THEN
                IF lr_Contact.GET(lr_ConBusRel."Contact No.") THEN
                    if POIFunction.CheckCompForAccount(pr_PurchHeader."Buy-from Vendor No.", 0, 'PI GMBH') //TODO: Company
                      and not POIFunction.CheckCompForAccount(pr_PurchHeader."Buy-from Vendor No.", 0, 'PI EUROPEAN SOURCING GMBH')
                      and not POIFunction.CheckCompForAccount(pr_PurchHeader."Buy-from Vendor No.", 0, 'PI ORGANICS GMBH')
                      and not POIFunction.CheckCompForAccount(pr_PurchHeader."Buy-from Vendor No.", 0, 'PI BANANAS GMBH')
                      and not POIFunction.CheckCompForAccount(pr_PurchHeader."Buy-from Vendor No.", 0, 'PI FRUIT GMBH')
                      and not POIFunction.CheckCompForAccount(pr_PurchHeader."Buy-from Vendor No.", 0, 'PI DUTCH GROWERS BV')
                      and (lr_Vendor."POI Diverse Vendor" or lr_Vendor."POI Shipping Company")
                      THEN
                        ERROR(LERR_PurchOrderNotPossibleTxt, pr_PurchHeader."Buy-from Vendor No.");
        END;
    end;

    // procedure ExistName(p_TableID: Integer;p_Name: Text[100])
    // var
    //     Vend: Record Vendor;
    //     VendTemp: Record Vendor temporary;
    //     ShipAgent: Record "Shipping Agent";
    //     ShipAgentTemp: Record "Shipping Agent" temporary;
    //     l_Name: Code[50];
    //     LTXT_VendNameExist: Label 'Kreditoren mit ähnlichen Namen existieren schon.\Bitte überprüfen Sie die Angaben um mehrfache Eingaben zu verhindern.';
    //     LTXT_ShipAgentNameExist: Label 'Zusteller mit ähnlichen Namen existieren schon.\Bitte überprüfen Sie die Angaben um mehrfache Eingaben zu verhindern.';
    // begin
    //     //-POI-JW 15.02.18
    //     IF p_TableID = DATABASE::Vendor THEN BEGIN
    //       Vend.Reset();
    //       IF Vend.FINDSET() THEN BEGIN
    //         REPEAT
    //           IF STRPOS(p_Name,' ') <> 0 THEN BEGIN
    //             IF STRPOS(UPPERCASE(Vend.Name),COPYSTR(UPPERCASE(p_Name),1,STRPOS(p_Name,' ') - 1)) <> 0 THEN BEGIN
    //               VendTemp.TRANSFERFIELDS(Vend);
    //               IF VendTemp.INSERT THEN;
    //             END;
    //           END;
    //           IF STRPOS(UPPERCASE(Vend.Name),UPPERCASE(p_Name)) <> 0 THEN BEGIN
    //             VendTemp.TRANSFERFIELDS(Vend);
    //             IF VendTemp.INSERT THEN;
    //           END;
    //         UNTIL Vend.NEXT() = 0;
    //       END;
    //       VendTemp.Reset();
    //       IF VendTemp.FINDSET() THEN BEGIN
    //         MESSAGE(LTXT_VendNameExist);
    //         ///???FORM.RUN(FORM::"ADF Vendor List",VendTemp);
    //       END;
    //     END ELSE IF p_TableID = DATABASE::"Shipping Agent" THEN BEGIN
    //       ShipAgent.Reset();
    //       IF ShipAgent.FINDSET() THEN BEGIN
    //         REPEAT
    //           IF STRPOS(p_Name,' ') <> 0 THEN BEGIN
    //             IF STRPOS(UPPERCASE(ShipAgent.Name),COPYSTR(UPPERCASE(p_Name),1,STRPOS(p_Name,' ') - 1)) <> 0 THEN BEGIN
    //               ShipAgentTemp.TRANSFERFIELDS(ShipAgent);
    //               IF ShipAgentTemp.INSERT THEN;
    //             END;
    //           END;
    //           IF STRPOS(UPPERCASE(ShipAgent.Name),UPPERCASE(p_Name)) <> 0 THEN BEGIN
    //             ShipAgentTemp.TRANSFERFIELDS(ShipAgent);
    //             IF ShipAgentTemp.INSERT THEN;
    //           END;
    //         UNTIL ShipAgent.NEXT() = 0;
    //       END;
    //       ShipAgentTemp.Reset();
    //       IF ShipAgentTemp.FINDSET() THEN BEGIN
    //         MESSAGE(LTXT_ShipAgentNameExist);
    //         Page.RUN(Page::"Shipping Agents",ShipAgentTemp);
    //       END;
    //     END;
    // end;

    // procedure CheckLFBBeforeInsertLines(var pr_BatchVariant: Record "Phys. Inventory NL";p_TableID: Integer;pv_Rec: Variant)
    // var
    //     lr_SalesHeader: Record "Sales Header";
    //     lr_PackOHeader: Record "5110712";
    //     lr_Vendor: Record Vendor;
    //     lr_Customer: Record "Customer";
    //     lr_LFBVendor: Record "Quality Management";
    //     lr_LFBCustomer: Record "Quality Management";
    // begin
    //     //aus C5110316
    //     //-POI-JW 17.10.16
    //     /*es sollte gehen

    //     CASE p_TableID OF
    //       DATABASE::"Sales Header": //,DATABASE::"Pack. Order Header":
    //         BEGIN
    //           lr_SalesHeader := pv_Rec;
    //         END;
    //       DATABASE::"Pack. Order Header":
    //         BEGIN
    //           lr_PackOHeader := pv_Rec;
    //         END;
    //     END;

    //     CASE pr_BatchVariant.Source OF
    //       pr_BatchVariant.Source::"Purch. Order":
    //         BEGIN
    //           //Prüfung:
    //           lr_LFBVendor.Reset();
    //           lr_LFBVendor.SETRANGE("No.",pr_BatchVariant."Vendor No.");
    //           lr_LFBVendor.SETFILTER("Vend-Cust-LFB created",'<>%1',0DT);
    //           IF lr_LFBVendor.FIND('-') THEN BEGIN
    //             IF lr_Customer.GET(lr_SalesHeader."Sell-to Customer No.") THEN BEGIN
    //               IF lr_LFBVendor.GET(lr_Vendor."No.") THEN BEGIN
    //                 IF lr_LFBCustomer.GET(lr_Customer."No.") THEN BEGIN
    //                   IF lr_LFBVendor."LEH-Spezifikation" <> lr_LFBCustomer."LEH-Spezifikation" THEN
    //                     ERROR(ERR_LEH,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor.Bio <> lr_LFBCustomer.Bio THEN
    //                     ERROR(ERR_Bio,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor."Fair Trade" <> lr_LFBCustomer."Fair Trade" THEN
    //                     ERROR(ERR_FairTrade,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor.GRASP <> lr_LFBCustomer.GRASP THEN
    //                     ERROR(ERR_GRASP,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor."SA 8000" <> lr_LFBCustomer."SA 8000" THEN
    //                     ERROR(ERR_SA8000,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor.BSCI <> lr_LFBCustomer.BSCI THEN
    //                     ERROR(ERR_BSCI,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor.RFA <> lr_LFBCustomer.RFA THEN
    //                     ERROR(ERR_RFA,lr_Vendor."No.",lr_Customer."No.");
    //                 END ELSE ERROR(ERR_LFBDebitor,lr_Customer."No.");
    //               END ELSE
    //                 ERROR(ERR_LFBKreditor,lr_Vendor."No.");
    //             END ELSE MESSAGE(ERR_DebitorNotExist);
    //           END;
    //     //schon vorhandene Kreditoren: soll keine Meldung kommen: //ELSE MESSAGE(ERR_KreditorNotExist);
    //         END;

    //       pr_BatchVariant.Source::"Packing Order":
    //         BEGIN
    //           //Prüfung:
    //     //ERROR('Producer No %1',pr_BatchVariant."Producer No.");
    //           lr_LFBVendor.Reset();
    //           lr_LFBVendor.SETRANGE("No.",pr_BatchVariant."Producer No.");
    //           lr_LFBVendor.SETFILTER("Vend-Cust-LFB created",'<>%1',0DT);
    //           IF lr_LFBVendor.FIND('-') THEN BEGIN
    //             IF lr_Customer.GET(pr_BatchVariant."Producer No.") THEN BEGIN
    //               IF lr_LFBVendor.GET(lr_Vendor."No.") THEN BEGIN
    //                 IF lr_LFBCustomer.GET(lr_Customer."No.") THEN BEGIN
    //                   IF lr_LFBVendor."LEH-Spezifikation" <> lr_LFBCustomer."LEH-Spezifikation" THEN
    //                     ERROR(ERR_LEH,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor.Bio <> lr_LFBCustomer.Bio THEN
    //                     ERROR(ERR_Bio,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor."Fair Trade" <> lr_LFBCustomer."Fair Trade" THEN
    //                     ERROR(ERR_FairTrade,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor.GRASP <> lr_LFBCustomer.GRASP THEN
    //                     ERROR(ERR_GRASP,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor."SA 8000" <> lr_LFBCustomer."SA 8000" THEN
    //                     ERROR(ERR_SA8000,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor.BSCI <> lr_LFBCustomer.BSCI THEN
    //                     ERROR(ERR_BSCI,lr_Vendor."No.",lr_Customer."No.");
    //                   IF lr_LFBVendor.RFA <> lr_LFBCustomer.RFA THEN
    //                     ERROR(ERR_RFA,lr_Vendor."No.",lr_Customer."No.");
    //                 END ELSE ERROR(ERR_LFBDebitor,lr_Customer."No.");
    //               END ELSE
    //                 ERROR(ERR_LFBKreditor,lr_Vendor."No.");
    //             END ELSE MESSAGE(ERR_DebitorNotExist);
    //           END;
    //     //schon vorhandene Kreditoren: soll keine Meldung kommen: //ELSE MESSAGE(ERR_KreditorNotExist);
    //         END;
    //     END;
    //     */
    //     //+POI-JW 17.10.16

    // end;

    // procedure MailAfterCreateSalesClaim(pr_SalesClaimHeader: Record "5110455")
    // var
    //     lr_Attachment: Record Attachment temporary;
    //     lr_CompInfo: Record "Company Information";
    //     lr_Session: Record Session;
    //     lc_Mail: Codeunit Mail;
    //     l_Subject: Text[100];
    //     l_BodyLine: Text[1024];
    //     l_CRLF: Text[2];
    //     l_Attachment: Text[250];
    //     LTXT_Subject: Label 'Verkaufs - Reklamation %1 wurde erstellt - Reklamationsdatum: %2 3';
    //     LTXT_Mail: Label 'Eine Verkaufsreklamation %1 wurde erstellt - Reklamationsdatum: %2';
    // begin
    //     //-POI-JW 16.03.18
    //     l_CRLF[1] := 13;
    //     l_CRLF[2] := 10;
    //     CLEAR(lc_Mail);
    //     l_Subject := pr_SalesClaimHeader."Sell-to Customer No." + ' ' + pr_SalesClaimHeader."Sell-to Customer Name" + ' ' +
    //       'Warenausgangsdatum: ' + FORMAT(pr_SalesClaimHeader."Shipment Date") + '  -  ' + pr_SalesClaimHeader."No.";
    //     l_BodyLine := l_CRLF + l_CRLF + STRSUBSTNO(LTXT_Mail,pr_SalesClaimHeader."No.",pr_SalesClaimHeader."Claim Date") +
    //       l_CRLF + l_CRLF + l_CRLF +
    //       'Warenausgangsdatum: ' + FORMAT(pr_SalesClaimHeader."Shipment Date") + l_CRLF + l_CRLF +
    //       'Verkaufsauftragsnummer: ' + pr_SalesClaimHeader."Sales Order No." + l_CRLF + l_CRLF +
    //       'Verkaufslieferungsnummer: ' + pr_SalesClaimHeader."Sales Shipment No." + l_CRLF + l_CRLF +
    //       'Verkaufsrechnungsnummer: ' + pr_SalesClaimHeader."Sales Invoice No." +
    //       l_CRLF + l_CRLF + l_CRLF + 'Mit freundlichen Grüßen'
    //       + l_CRLF;

    //     //wenn möglich VK-Reklamationbestätigung als Anhang
    //     /*
    //     lr_Attachment."File Extension" := LTXT_Bestand + 'Bestand Venlo_' + UPPERCASE(Userid()) + '.xlsx';
    //     IF NOT EXISTS(TXT_1StammdatenblattDETxt) THEN
    //       ERROR('Das Dokument:\' + TXT_1StammdatenblattDETxt + '\\konnte nicht gefunden werden.');
    //     lr_Attachment.insert();
    //     l_Attachment := lr_Attachment."File Extension";
    //     lc_Mail.Attachments(lr_Attachment);
    //     */

    //     lr_CompInfo.GET();
    //     lr_Session.Reset();
    //     lr_Session.SETRANGE("My Session",TRUE);
    //     lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //     lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //     IF lr_Session.FINDFIRST() THEN BEGIN

    //       /*30.10.2018 Andre Wunsch - ausschalten:
    //       IF STRPOS(lr_CompInfo.Name,'Sourcing') <> 0 THEN BEGIN
    //         lc_Mail.NewMessage('VL_Handel_PIES' {An}, '' {'julita@port-international.com'} {CC},
    //           l_Subject,l_BodyLine,'' {l_Attachment},FALSE {TRUE -> soll Outlook vor dem Senden gestartert werden} );
    //       End;
    //       */
    //       IF STRPOS(lr_CompInfo.Name,'Fruit') <> 0 THEN BEGIN
    //         lc_Mail.NewMessage('Fruit Import' /*An*/ , '' /*'julita@port-international.com'*/ /*CC*/,'',
    //           l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //       END;
    //       IF STRPOS(lr_CompInfo.Name,'Bananas') <> 0 THEN BEGIN
    //         lc_Mail.NewMessage('Bananenteam' /*An*/, '' /*'julita@port-international.com'*/ /*CC*/,'',
    //           l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //       END;
    //     END;
    //     //+POI-JW 16.03.18

    // end;

    // procedure QSSollIstBestand()
    // var
    //     ltr_ExcelBuffer: Record "Excel Buffer" temporary;
    //     lr_PhysBestand: Record "Phys. Inventory NL";
    //     ltr_PhysBestand: Record "Phys. Inventory NL" temporary;
    //     lr_PurchLine: Record "Purchase Line";
    //     lr_PurchLineHELP: Record "Purchase Line";
    //     lr_PurchHeader: Record "Purchase Header";
    //     lr_PurchCrMemoLine: Record "Purch. Cr. Memo Line";
    //     lr_SalesLine: Record "Purchase Line";
    //     lr_SalesLineHELP: Record "Purchase Line";
    //     lr_SalesCrMemoLine: Record "Sales Cr.Memo Line";
    //     lr_SalesShipLine: Record "Sales Shipment Line";
    //     lr_POOutputItems: Record "5110713";
    //     lr_POInputItems: Record "5110714";
    //     lr_BatchQS: Record "50100";
    //     lr_TransHeader: Record "Transfer Header";
    //     lr_TransLine: Record "Transfer Line";
    //     lr_Vend: Record Vendor;
    //     PackOHeader: Record "5110712";
    //     lc_PortSystem: Codeunit "5110798";
    //     l_MengeAusVK: Decimal;
    //     l_MengeAusEK: Decimal;
    //     l_MengeAusOItems: Decimal;
    //     l_Date: Date;
    //     LTXT_Filename: Label '\\port-data-01\lwp\EDV\Navision\Vorlagen\Excel\Vorlage Bestand Venlo.xlsx';
    //     File: Text[250];
    //     l_RowNo: Integer;
    //     l_LfdNr: Integer;
    //     i: Integer;
    //     Dialog: Dialog;
    //     l_DateTime: Text[30];
    //     CurrYear: Integer;
    //     CurrMonth: Integer;
    //     CurrYearMonth: Integer;
    // begin
    //     l_RowNo := 2;
    //     WITH lr_PhysBestand DO BEGIN
    //       Reset();
    //       IF FINDSET THEN BEGIN
    //         REPEAT
    //           "Menge in Bestellung" :=0;
    //           "Menge im Verkauf" := 0;
    //           "Menge im Packauftrag" := 0;
    //           "Menge in Umlagerung" := 0;
    //           "Soll Bestand nach Ausgang" := 0;
    //           "Soll und Ist ungleich" := FALSE;
    //           Modify();
    //         UNTIL NEXT = 0;
    //       END;

    //       IF EVALUATE(CurrYear,COPYSTR(FORMAT(DATE2DWY(Today(),3)),3,2)) THEN
    //         IF EVALUATE(CurrMonth,COPYSTR(FORMAT(DATE2DMY(Today(),2)),1,2)) THEN
    //           IF EVALUATE(CurrYearMonth,FORMAT(CurrYear) + FORMAT(CurrMonth)) THEN
    //             l_LfdNr := CurrYearMonth * 10000;

    //       lr_PhysBestand.Reset();
    //       IF lr_PhysBestand.FINDLAST THEN
    //         l_LfdNr := lr_PhysBestand."Lfd. Nr." + 1
    //       ELSE
    //         l_LfdNr := CurrYearMonth * 10000;

    //       lr_PurchLine.Reset();
    //       lr_PurchLine.SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");
    //       lr_PurchLine.SETRANGE("Document Type",lr_PurchLine."Document Type"::Order);
    //       lr_PurchLine.SETRANGE(Type,lr_PurchLine.Type::Item);
    //       lr_PurchLine.SETFILTER("Item Category Code",'<%1','6000');
    //       lr_PurchLine.SETFILTER("Expected Receipt Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       lr_PurchLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //       IF lr_PurchLine.FINDSET() THEN BEGIN

    //         Dialog.OPEN('Einkaufszeile #1#### von #2####');
    //         Dialog.UPDATE(2,lr_PurchLine.COUNT);
    //         i := 0;

    //         REPEAT
    //           Dialog.UPDATE(1,i);

    //           l_MengeAusEK := 0;
    //           IF lr_PurchHeader.GET(lr_PurchHeader."Document Type"::Order,lr_PurchLine."Master Batch No.") THEN;
    //           Reset();
    //           SETRANGE("Artikel Nr.",lr_PurchLine."No.");
    //           SETRANGE(Position,lr_PurchLine."Batch Variant No.");

    //           lr_BatchQS.Reset();
    //           lr_BatchQS.SETRANGE("Document Type",lr_PurchLine."Document Type");
    //           lr_BatchQS.SETRANGE("Document No.",lr_PurchLine."Document No.");
    //           lr_BatchQS.SETRANGE("Line No.",lr_PurchLine."Line No.");
    //           IF lr_BatchQS.FIND('-') THEN;

    //           IF NOT FIND('-') THEN BEGIN
    //             INIT();
    //             "Lfd. Nr." := l_LfdNr;
    //             "Erwartetes Wareneingangsdatum" := lr_PurchHeader."Expected Receipt Date";
    //             Position := lr_PurchLine."Batch Variant No.";
    //             Beleg := lr_PurchLine."Document No.";
    //             "Artikel Nr." := lr_PurchLine."No.";
    //             Beschreibung := lr_PurchLine.Description;
    //             "Beschreibung erweitert" := lr_PurchLine.Description + ' ' + lr_PurchLine."Unit of Measure Code" + ' ' +
    //               lr_PurchLine."Country of Origin Code";
    //             Einheit := lr_PurchLine."Unit of Measure Code";
    //             Verpackungscode := lr_PurchLine."Item Attribute 6";
    //             "Lieferanten Nr." := lr_PurchHeader."Buy-from Vendor No.";
    //             Lieferantenname := lr_PurchHeader."Buy-from Vendor Name";
    //             "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //             "Los. Nr." := lr_PurchLine."Info 3";
    //             lr_BatchQS.Reset();
    //             lr_BatchQS.SETRANGE("Document Type",lr_PurchLine."Document Type");
    //             lr_BatchQS.SETRANGE("Document No.",lr_PurchLine."Document No.");
    //             lr_BatchQS.SETRANGE("Line No.",lr_PurchLine."Line No.");
    //             IF lr_BatchQS.FIND('-') THEN BEGIN
    //               IF lr_BatchQS."QS Kontrolle Status" > lr_BatchQS."QS Kontrolle Status"::" " THEN
    //                 Status := FORMAT(lr_BatchQS."QS Kontrolle Status") //Status::erwartet
    //               ELSE
    //                 Status := '';
    //             END ELSE
    //               Status := '';
    //             "Menge in Bestellung" := lr_PurchLine.Quantity;
    //             "Beschriftung Ordner" := Position + '_' + "Beschreibung erweitert" + '_' + Lieferantenname + '_' +
    //               FORMAT("Menge in Bestellung") + '_' + FORMAT("Status neu");
    //             "Location Code" := lr_PurchLine."Location Code";
    //             Insert();
    //             l_LfdNr += 1;
    //           END ELSE BEGIN
    //             "Erwartetes Wareneingangsdatum" := lr_PurchHeader."Expected Receipt Date";
    //             Einheit := lr_PurchLine."Unit of Measure Code";
    //             Verpackungscode := lr_PurchLine."Item Attribute 6";
    //             "Lieferanten Nr." := lr_PurchHeader."Buy-from Vendor No.";
    //             Lieferantenname := lr_PurchHeader."Buy-from Vendor Name";
    //             "Los. Nr." := lr_PurchLine."Info 3";
    //             "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //             Beschreibung := lr_PurchLine.Description;
    //             "Beschreibung erweitert" := lr_PurchLine.Description + ' ' + lr_PurchLine."Unit of Measure Code" + ' ' +
    //               lr_PurchLine."Country of Origin Code";
    //             lr_BatchQS.Reset();
    //             lr_BatchQS.SETRANGE("Document Type",lr_PurchLine."Document Type");
    //             lr_BatchQS.SETRANGE("Document No.",lr_PurchLine."Document No.");
    //             lr_BatchQS.SETRANGE("Line No.",lr_PurchLine."Line No.");
    //             IF lr_BatchQS.FIND('-') THEN BEGIN
    //               IF lr_BatchQS."QS Kontrolle Status" > lr_BatchQS."QS Kontrolle Status"::" " THEN
    //                 Status := FORMAT(lr_BatchQS."QS Kontrolle Status") //Status::erwartet
    //               ELSE
    //                 Status := '';
    //             END ELSE
    //               Status := '';
    //             "Menge in Bestellung" := lr_PurchLine.Quantity;
    //             "Beschriftung Ordner" := Position + '_' + "Beschreibung erweitert" + '_' + Lieferantenname + '_' +
    //               FORMAT("Menge in Bestellung") + '_' + FORMAT("Status neu");
    //             "Location Code" := lr_PurchLine."Location Code";
    //             Modify();

    //      //klären wozu ?????? 11.10.l8
    //      /*
    //             lr_PurchLineHELP.SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code",
    //               "Expected Receipt Date");
    //             lr_PurchLineHELP.SETRANGE(Type,lr_PurchLineHELP.Type::Item);
    //             lr_PurchLineHELP.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_PurchLineHELP.SETFILTER("Expected Receipt Date",'>=%1',CALCDATE('-1M',TODAY));
    //             lr_PurchLineHELP.SETRANGE("Batch Variant No.",lr_PurchLine."Batch Variant No.");
    //             lr_PurchLineHELP.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_PurchLineHELP.FINDSET() THEN BEGIN
    //               REPEAT
    //                 l_MengeAusVK += lr_PurchLineHELP.Quantity;
    //               UNTIL lr_PurchLineHELP.NEXT() = 0;
    //               "Erwartetes Wareneingangsdatum" := lr_PurchHeader."Expected Receipt Date";
    //               Beschreibung := lr_PurchLine.Description;
    //               "Beschreibung erweitert" := lr_PurchLine.Description + ' ' + lr_PurchLine."Unit of Measure Code" + ' ' +
    //                 lr_PurchLine."Country of Origin Code";
    //               Einheit := lr_PurchLine."Unit of Measure Code";
    //               Verpackungscode := lr_PurchLine."Item Attribute 6";
    //               "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //               "Los. Nr." := lr_PurchLine."Info 3";
    //               Status := FORMAT(lr_BatchQS."QS Kontrolle Status"); //Status::erwartet;
    //               "Menge in Bestellung" := l_MengeAusVK;
    //               Modify();
    //             END;
    //     */
    //           END;

    //           //EK-Gutschrift dazu
    //           lr_PurchLineHELP.Reset();
    //           lr_PurchLineHELP.SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code",
    //             "Expected Receipt Date");
    //           lr_PurchLineHELP.SETRANGE("Document Type",lr_PurchLineHELP."Document Type"::"Credit Memo");
    //           lr_PurchLineHELP.SETRANGE(Type,lr_PurchLineHELP.Type::Item);
    //           lr_PurchLineHELP.SETRANGE("No.","Artikel Nr.");
    //           lr_PurchLineHELP.SETFILTER("Expected Receipt Date",'>=%1|%2',CALCDATE('-1M',TODAY),0D);
    //           lr_PurchLineHELP.SETRANGE("Batch Variant No.",Position);
    //           lr_PurchLineHELP.SETFILTER("Item Category Code",'<%1','6000');
    //           lr_PurchLineHELP.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //           IF lr_PurchLineHELP.FINDSET() THEN BEGIN
    //             REPEAT
    //               IF lr_PurchLineHELP."Expected Receipt Date" <> 0D THEN BEGIN
    //                 "Menge in Bestellung" += lr_PurchLineHELP.Quantity;
    //               END ELSE IF lr_PurchLineHELP."Expected Receipt Date" = 0D THEN BEGIN
    //                 IF lr_PurchHeader.GET(lr_PurchLineHELP."Document Type",lr_PurchLineHELP."Document No.") THEN BEGIN
    //                   IF lr_PurchHeader."Posting Date" > (CALCDATE('-4M',TODAY)) THEN
    //                     "Menge in Bestellung" := lr_PurchLineHELP.Quantity;
    //                 END;
    //               END;
    //             UNTIL lr_PurchLineHELP.NEXT() = 0;
    //             Modify();
    //           END;

    //           /*Geb. EK-Gutschrift wird gleich im EK-vermerkt -> wird hier nicht benötigt
    //           //EK-Geb. Reklamation dazu
    //           lr_PurchCrMemoLine.Reset();
    //           lr_PurchCrMemoLine.SETRANGE(Type,lr_PurchCrMemoLine.Type::Item);
    //           lr_PurchCrMemoLine.SETRANGE("No.",lr_PurchLine."No.");
    //           lr_PurchCrMemoLine.SETFILTER("Posting Date",'>=%1',CALCDATE('-1M',TODAY));     //1. Tag aktueller Monat
    //           lr_PurchCrMemoLine.SETRANGE("Batch Variant No.",lr_PurchLine."Batch Variant No.");
    //           lr_PurchCrMemoLine.SETFILTER("Item Category Code",'<%1','6000');
    //           lr_PurchLineHELP.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //           IF lr_PurchCrMemoLine.FINDSET() THEN BEGIN
    //             REPEAT
    //               "Menge in Bestellung" +=  lr_PurchCrMemoLine.Quantity;
    //             UNTIL lr_PurchCrMemoLine.NEXT() = 0;
    //             Modify();
    //           END;
    //           */

    //           i += 1;
    //         UNTIL lr_PurchLine.NEXT() = 0;
    //       END;

    //       //Packerei Output
    //       lr_PhysBestand.Reset();
    //       IF lr_PhysBestand.FINDLAST THEN
    //         l_LfdNr := lr_PhysBestand."Lfd. Nr." + 1
    //       ELSE
    //         l_LfdNr := 1;
    //       lr_POOutputItems.Reset();
    //       lr_POOutputItems.SETFILTER("Item Category Code",'<%1','6000');
    //       lr_POOutputItems.SETFILTER("Expected Receipt Date",'>=%1',CALCDATE('-1M',TODAY));
    //       lr_POOutputItems.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //       IF lr_POOutputItems.FINDSET() THEN BEGIN
    //         REPEAT
    //           Reset();
    //           SETRANGE("Artikel Nr.",lr_POOutputItems."Item No.");
    //           SETRANGE(Position,lr_POOutputItems."Batch Variant No.");
    //           SETRANGE(Beleg,lr_POOutputItems."Doc. No.");
    //           IF NOT FIND('-') THEN BEGIN
    //             INIT();
    //             "Lfd. Nr." := l_LfdNr;
    //             "Erwartetes Wareneingangsdatum" := lr_POOutputItems."Expected Receipt Date";
    //             Position := lr_POOutputItems."Batch Variant No.";
    //             Beleg := lr_POOutputItems."Doc. No.";
    //             "Artikel Nr." := lr_POOutputItems."Item No.";
    //             Beschreibung := lr_POOutputItems."Item Description";
    //             "Beschreibung erweitert" := lr_POOutputItems."Item Description" + ' ' + lr_POOutputItems."Unit of Measure Code" + ' ' +
    //               lr_POOutputItems."Country of Origin Code";
    //             Einheit := lr_POOutputItems."Unit of Measure Code";
    //             Verpackungscode := lr_POOutputItems."Item Attribute 6";
    //             IF PackOHeader.GET(lr_POOutputItems."Doc. No.") THEN BEGIN
    //               "Lieferanten Nr." := PackOHeader."Pack.-by Vendor No.";
    //               Lieferantenname := PackOHeader."Pack.-by Name";
    //             END;
    //             "Erzeugerland Code" := lr_POOutputItems."Country of Origin Code";
    //             "Los. Nr." := lr_POOutputItems."Info 3";
    //             Status := FORMAT(lr_POOutputItems.Status); //Status::erwartet;
    //             "Menge in Bestellung" := lr_POOutputItems.Quantity;
    //             "Beschriftung Ordner" := Position + '_' + "Beschreibung erweitert" + '_' + Lieferantenname + '_' +
    //               FORMAT("Menge in Bestellung") + '_' + FORMAT("Status neu");
    //             "Location Code" := lr_POOutputItems."Location Code";
    //             Insert();
    //             l_LfdNr += 1;
    //           END ELSE BEGIN
    //             "Menge in Bestellung" := lr_POOutputItems.Quantity;
    //           "Erwartetes Wareneingangsdatum" := lr_POOutputItems."Expected Receipt Date";
    //             Beschreibung := lr_POOutputItems."Item Description";
    //             "Beschreibung erweitert" := lr_POOutputItems."Item Description" + ' ' + lr_POOutputItems."Unit of Measure Code" + ' ' +
    //               lr_POOutputItems."Country of Origin Code";
    //             IF PackOHeader.GET(lr_POOutputItems."Doc. No.") THEN BEGIN
    //               "Lieferanten Nr." := PackOHeader."Pack.-by Vendor No.";
    //               Lieferantenname := PackOHeader."Pack.-by Name";
    //             END;
    //             Einheit := lr_POOutputItems."Unit of Measure Code";
    //             Verpackungscode := lr_POOutputItems."Item Attribute 6";
    //             "Erzeugerland Code" := lr_POOutputItems."Country of Origin Code";
    //             "Los. Nr." := lr_POOutputItems."Info 3";
    //             Status := FORMAT(lr_POOutputItems.Status); //Status::erwartet;
    //             "Beschriftung Ordner" := Position + '_' + "Beschreibung erweitert" + '_' + Lieferantenname + '_' +
    //               FORMAT("Menge in Bestellung") + '_' + FORMAT("Status neu");
    //             "Location Code" := lr_POOutputItems."Location Code";
    //             Modify();
    //           END;
    //         UNTIL lr_POOutputItems.NEXT() = 0;
    //       END;

    //       //Umlagerungen
    //       lr_PhysBestand.Reset();
    //       IF lr_PhysBestand.FINDLAST THEN
    //         l_LfdNr := lr_PhysBestand."Lfd. Nr." + 1
    //       ELSE
    //         l_LfdNr := CurrYearMonth * 10000;

    //       lr_TransHeader.Reset();
    //       //lr_TransHeader.SETFILTER("Posting Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       lr_TransHeader.SETFILTER("Receipt Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       IF lr_TransHeader.FINDSET() THEN BEGIN
    //         REPEAT
    //           lr_TransLine.Reset();
    //           lr_TransLine.SETRANGE("Document No.",lr_TransHeader."No.");
    //           lr_TransLine.SETFILTER(lr_TransLine."Item No.",'<>%1','');
    //           lr_TransLine.SETFILTER("Item Category Code",'<%1','6000');
    //           IF lr_TransLine.FINDSET() THEN BEGIN
    //             REPEAT
    //               Reset();
    //               SETRANGE("Artikel Nr.",lr_TransLine."Item No.");
    //               SETRANGE(Position,lr_TransLine."Batch Variant No.");
    //               SETRANGE(Beleg,lr_TransHeader."No.");
    //               IF NOT FIND('-') THEN BEGIN
    //                 INIT();
    //                 "Lfd. Nr." := l_LfdNr;
    //                 Position := lr_TransLine."Batch Variant No.";
    //                 Beleg := lr_TransHeader."No.";
    //                 "Artikel Nr." := lr_TransLine."Item No.";
    //                 Beschreibung := lr_TransLine.Description;
    //                 Einheit := lr_TransLine."Unit of Measure Code";
    //                 Verpackungscode := lr_TransLine."Item Attribute 6";
    //                 "Lieferanten Nr." := '';
    //                 Lieferantenname := '';
    //                 "Erzeugerland Code" := '';
    //                 PackOHeader.Reset();
    //                 PackOHeader.SETRANGE(PackOHeader."Master Batch No.",lr_TransLine."Master Batch No.");
    //                 IF PackOHeader.FINDFIRST() THEN BEGIN
    //                   "Lieferanten Nr." := PackOHeader."Pack.-by Vendor No.";
    //                   Lieferantenname := PackOHeader."Pack.-by Name";
    //                 END;
    //                 lr_PurchLine.Reset();
    //                 lr_PurchLine.SETRANGE("Document No.",lr_TransLine."Master Batch No.");
    //                 IF lr_PurchLine.FIND('-') THEN BEGIN
    //                   "Lieferanten Nr." := lr_PurchLine."Buy-from Vendor No.";
    //                   IF lr_Vend.GET(lr_PurchLine."Buy-from Vendor No.") THEN
    //                     Lieferantenname := lr_Vend.Name;
    //                   "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //                 END;
    //                 "Beschreibung erweitert" := lr_TransLine.Description + ' ' + lr_TransLine."Unit of Measure Code" + ' ' +
    //                   "Erzeugerland Code";
    //                 "Los. Nr." := lr_TransLine."Info 3";
    //                 Status := FORMAT(lr_TransHeader.Status); //Status::erwartet;
    //                 "Menge in Bestellung" := lr_TransLine.Quantity;
    //                 "Menge im Verkauf" := 0;
    //                 "Soll Bestand nach Ausgang" := 0;
    //                 "Soll und Ist ungleich" := TRUE;
    //                 "Erwartetes Wareneingangsdatum" := lr_TransHeader."Receipt Date";
    //                 "Beschriftung Ordner" := Position + '_' + "Beschreibung erweitert" + '_' + Lieferantenname + '_' +
    //                   FORMAT("Menge in Bestellung") + '_' + FORMAT("Status neu");

    //                 IF ((lr_TransHeader."Transfer-from Code" <> 'KOOPS VENL') AND (lr_TransHeader."Transfer-from Code" <> 'ALDI VENLO') AND
    //                   (lr_TransHeader."Transfer-from Code" <> 'NORMA VENL')) AND
    //                   ((lr_TransHeader."Transfer-to Code" = 'KOOPS VENL') OR (lr_TransHeader."Transfer-to Code" = 'ALDI VENLO') OR
    //                   (lr_TransHeader."Transfer-to Code" = 'NORMA VENL'))
    //                 THEN BEGIN
    //                   "Location Code" := lr_TransHeader."Transfer-to Code";
    //                 IF INSERT THEN
    //                   l_LfdNr += 1;
    //                 END;
    //               END ELSE BEGIN
    //                 Verpackungscode := lr_TransLine."Item Attribute 6";
    //                 "Los. Nr." := lr_TransLine."Info 3";
    //                 "Erzeugerland Code" := '';
    //                 Beschreibung := lr_TransLine.Description;
    //                 "Beschreibung erweitert" := lr_TransLine.Description + ' ' + lr_TransLine."Unit of Measure Code" + ' ';
    //                 PackOHeader.Reset();
    //                 PackOHeader.SETRANGE(PackOHeader."Master Batch No.",lr_TransLine."Master Batch No.");
    //                 IF PackOHeader.FINDFIRST() THEN BEGIN
    //                   "Lieferanten Nr." := PackOHeader."Pack.-by Vendor No.";
    //                   Lieferantenname := PackOHeader."Pack.-by Name";
    //                 END;
    //                 lr_PurchLine.Reset();
    //                 lr_PurchLine.SETRANGE("Document No.",lr_TransLine."Master Batch No.");
    //                 IF lr_PurchLine.FIND('-') THEN BEGIN
    //                   "Lieferanten Nr." := lr_PurchLine."Buy-from Vendor No.";
    //                   IF lr_Vend.GET(lr_PurchLine."Buy-from Vendor No.") THEN
    //                     Lieferantenname := lr_Vend.Name;
    //                   "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //                 END;
    //                 "Beschreibung erweitert" := lr_TransLine.Description + ' ' + lr_TransLine."Unit of Measure Code" + ' ' +
    //                   "Erzeugerland Code";
    //                 Status := FORMAT(lr_TransHeader.Status); //Status::erwartet;
    //                 "Menge in Bestellung" += lr_TransLine.Quantity;
    //                 "Erwartetes Wareneingangsdatum" := lr_TransHeader."Receipt Date";
    //                 "Beschriftung Ordner" := Position + '_' + "Beschreibung erweitert" + '_' + Lieferantenname + '_' +
    //                   FORMAT("Menge in Bestellung") + '_' + FORMAT("Status neu");
    //                 "Location Code" := lr_TransHeader."Transfer-to Code";
    //                 Modify();
    //               END;
    //             UNTIL lr_TransLine.NEXT() = 0;
    //           END;
    //         UNTIL lr_TransHeader.NEXT() = 0;
    //       END;
    //       //Umlagerungen END

    //       //NEU 11.10.
    //       lr_TransHeader.Reset();
    //       //lr_TransHeader.SETFILTER("Posting Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       lr_TransHeader.SETFILTER("Receipt Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       IF lr_TransHeader.FINDSET() THEN BEGIN
    //         REPEAT
    //           lr_TransLine.Reset();
    //           lr_TransLine.SETRANGE("Document No.",lr_TransHeader."No.");
    //           lr_TransLine.SETFILTER("Item No.",'<>%1','');
    //           lr_TransLine.SETFILTER("Item Category Code",'<%1','6000');
    //           IF lr_TransLine.FINDSET() THEN BEGIN
    //             REPEAT
    //               Reset();
    //               SETRANGE("Artikel Nr.",lr_TransLine."Item No.");
    //               SETRANGE(Position,lr_TransLine."Batch Variant No.");
    //               IF FIND('-') THEN BEGIN
    //                 IF ((lr_TransHeader."Transfer-from Code" = 'KOOPS VENL') OR (lr_TransHeader."Transfer-from Code" = 'ALDI VENLO') OR
    //                   (lr_TransHeader."Transfer-from Code" = 'NORMA VENL')) AND
    //                   ((lr_TransHeader."Transfer-to Code" <> 'KOOPS VENL') AND (lr_TransHeader."Transfer-to Code" <> 'ALDI VENLO') AND
    //                   (lr_TransHeader."Transfer-to Code" <> 'NORMA VENL'))
    //                 THEN BEGIN
    //                   "Location Code" := lr_TransHeader."Transfer-from Code";
    //                   "Menge in Umlagerung" += lr_TransLine.Quantity;
    //                   Modify();
    //                 END;
    //               END;
    //             UNTIL lr_TransLine.NEXT() = 0;
    //           END;
    //         UNTIL lr_TransHeader.NEXT() = 0;
    //       END;

    //       //Packerei Input mit Partie selbst verrechnen
    //       lr_POInputItems.Reset();
    //       lr_POInputItems.SETFILTER("Item Category Code",'<%1','6000');
    //       lr_POInputItems.SETFILTER("Expected Receipt Date",'>=%1',CALCDATE('-2M',TODAY));  //2M belassen
    //       lr_POInputItems.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //       IF lr_POInputItems.FINDSET() THEN BEGIN
    //         REPEAT
    //           Reset();
    //           SETRANGE("Artikel Nr.",lr_POInputItems."Item No.");
    //           SETRANGE(Position,lr_POInputItems."Batch Variant No.");
    //           IF FIND('-') THEN BEGIN
    //             "Menge im Packauftrag" += lr_POInputItems.Quantity;
    //             "Batch Variant No.Input Items" := lr_POInputItems."Batch Variant No.";
    //             Modify();
    //           END;
    //         UNTIL lr_POInputItems.NEXT() = 0;
    //       END;

    //       Reset();
    //       IF FINDSET THEN BEGIN
    //         REPEAT
    //           IF (COPYSTR("Lieferanten Nr.",1,1) <> 'U') THEN BEGIN
    //             l_MengeAusVK := 0;
    //             lr_SalesLine.Reset();
    //             lr_SalesLine.SETRANGE("Document Type",lr_SalesLine."Document Type"::Order);
    //             lr_SalesLine.SETRANGE(Type,lr_SalesLine.Type::Item);
    //             lr_SalesLine.SETRANGE("No.","Artikel Nr.");
    //             lr_SalesLine.SETRANGE("Batch Variant No.",Position);
    //             lr_SalesLine.SETFILTER("Qty. to Ship",'<>%1',0);

    //       //      lr_SalesLine.SETRANGE("Batch Variant No.",'19-70065-024');

    //             lr_SalesLine.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_SalesLine.SETFILTER("Shipment Date",'>=%1&<=%2',CALCDATE('-1M',TODAY),/*CALCDATE('-1T',*/TODAY/*)*/);
    //             lr_SalesLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_SalesLine.FINDSET() THEN BEGIN
    //               REPEAT
    //                 lr_SalesShipLine.Reset();
    //                 lr_SalesShipLine.SETRANGE(Type,lr_SalesShipLine.Type::Item);
    //                 lr_SalesShipLine.SETRANGE("No.",lr_SalesLine."No.");
    //                 lr_SalesShipLine.SETFILTER("Posting Date",'<=%1',CALCDATE('-1T',TODAY));
    //                 lr_SalesShipLine.SETRANGE("Batch Variant No.",lr_SalesLine."Batch Variant No.");
    //                 lr_SalesShipLine.SETRANGE("Order No.",lr_SalesLine."Document No.");
    //                 lr_SalesShipLine.SETRANGE("Order Line No.",lr_SalesLine."Line No.");
    //                 IF NOT lr_SalesShipLine.FIND('-') THEN BEGIN
    //                   "Menge im Verkauf" += lr_SalesLine.Quantity;
    //                   Modify();
    //                 END;
    //               UNTIL  lr_SalesLine.NEXT() = 0;
    //             END;

    //             //VK-Geb. Lieferungen dazu
    //             lr_SalesShipLine.Reset();
    //             lr_SalesShipLine.SETRANGE(Type,lr_SalesShipLine.Type::Item);
    //             lr_SalesShipLine.SETRANGE("No.","Artikel Nr.");
    //             lr_SalesShipLine.SETFILTER("Posting Date",'<=%1',/*CALCDATE('-1T',*/TODAY/*)*/);
    //             lr_SalesShipLine.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_SalesShipLine.SETRANGE("Batch Variant No.",Position);

    //        //     lr_SalesShipLine.SETRANGE("Batch Variant No.",'19-70065-024');

    //             lr_SalesShipLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_SalesShipLine.FINDSET() THEN BEGIN
    //               REPEAT
    //               /*
    //                 IF (lr_SalesShipLine."Order No." = lr_SalesLine."Document No.") AND
    //                   (lr_SalesShipLine."Order Line No." = lr_SalesLine."Line No.")
    //                 THEN BEGIN
    //                   IF (lr_SalesLine.Quantity <> lr_SalesShipLine.Quantity) THEN
    //                     "Menge im Verkauf" -= (lr_SalesLine.Quantity - lr_SalesShipLine.Quantity);
    //                 END;
    //               UNTIL lr_SalesShipLine.NEXT() = 0;
    //               Modify();
    //               */
    //                 "Menge im Verkauf" +=  lr_SalesShipLine.Quantity;
    //               UNTIL lr_SalesShipLine.NEXT() = 0;
    //               Modify();
    //             END;

    //             //VK-Gutschrift abziehen
    //             lr_SalesLineHELP.Reset();
    //             lr_SalesLineHELP.SETRANGE("Document Type",lr_SalesLineHELP."Document Type"::"Credit Memo");
    //             lr_SalesLineHELP.SETRANGE(Type,lr_SalesLineHELP.Type::Item);
    //             lr_SalesLineHELP.SETRANGE("No.","Artikel Nr.");
    //             lr_SalesLineHELP.SETFILTER("Shipment Date",'<=%1',/*CALCDATE('-1T',*/TODAY/*)*/);
    //             lr_SalesLineHELP.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_SalesLineHELP.SETRANGE("Batch Variant No.",Position);
    //             lr_SalesLineHELP.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_SalesLineHELP.FINDSET() THEN BEGIN
    //               REPEAT
    //                 "Menge im Verkauf" -= lr_SalesLineHELP.Quantity;
    //               UNTIL lr_SalesLineHELP.NEXT() = 0;
    //               Modify();
    //             END;

    //             //VK-Geb. Gutschrift abziehen
    //             lr_SalesCrMemoLine.Reset();
    //             lr_SalesCrMemoLine.SETRANGE(Type,lr_SalesCrMemoLine.Type::Item);
    //             lr_SalesCrMemoLine.SETRANGE("No.","Artikel Nr.");
    //             lr_SalesLineHELP.SETFILTER("Shipment Date",'<=%1',/*CALCDATE('-1T',*/TODAY/*)*/);
    //             lr_SalesCrMemoLine.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_SalesCrMemoLine.SETRANGE("Batch Variant No.",Position);
    //             lr_SalesCrMemoLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_SalesCrMemoLine.FINDSET() THEN BEGIN
    //               REPEAT
    //                 "Menge im Verkauf" -=  lr_SalesCrMemoLine.Quantity;
    //               UNTIL lr_SalesCrMemoLine.NEXT() = 0;
    //               Modify();
    //             END;
    //             "Soll Bestand nach Ausgang" := "Menge in Bestellung" - "Menge im Verkauf" - "Menge im Packauftrag" - "Menge in Umlagerung";
    //             //2.7.19 C. Heise
    //             IF "Soll Bestand nach Ausgang" < 0 THEN
    //               "Soll Bestand nach Ausgang" := 0;

    //             IF ("Menge im Verkauf" + "Soll Bestand nach Ausgang") = 0 THEN BEGIN
    //               "Menge im Verkauf" := 0;
    //               "Soll Bestand nach Ausgang" := 0;
    //             END;
    //             IF "Soll Bestand nach Ausgang" <> 0 THEN
    //               "Soll und Ist ungleich" := TRUE;
    //             IF "Ist Bestand" <> 0 THEN
    //               "Soll und Ist ungleich" := TRUE;

    //             IF ("Soll Bestand nach Ausgang" < 0) AND ("Ist Bestand" = 0) THEN
    //               "Soll und Ist ungleich" := FALSE;
    //             Modify();
    //           END;
    //         UNTIL NEXT = 0;
    //       END;

    //       //Summen
    //       Reset();
    //       SETRANGE(Position,'Summe');
    //       IF FINDSET THEN
    //         DELETEALL;

    //       lr_PhysBestand.Reset();
    //       IF lr_PhysBestand.FINDLAST THEN
    //         l_LfdNr := lr_PhysBestand."Lfd. Nr." + 1
    //       ELSE
    //         l_LfdNr := CurrYearMonth * 10000;

    //       Reset();
    //       SETFILTER("Artikel Nr.",'<>%1','');
    //       //SETFILTER("Status neu",'>%1',"Status neu"::erwartet);
    //       IF FINDSET THEN BEGIN
    //         REPEAT
    //           ltr_PhysBestand.Reset();
    //           ltr_PhysBestand.SETRANGE("Artikel Nr.","Artikel Nr.");
    //           ltr_PhysBestand.SETRANGE(Einheit,Einheit);
    //           IF NOT ltr_PhysBestand.FIND('-') THEN BEGIN
    //             ltr_PhysBestand.INIT();
    //             ltr_PhysBestand := lr_PhysBestand;
    //             ltr_PhysBestand."Lfd. Nr." := l_LfdNr;
    //             ltr_PhysBestand."Artikel Nr." := "Artikel Nr.";
    //             ltr_PhysBestand.Position := 'Summe';
    //             ltr_PhysBestand.Beleg := '';
    //             ltr_PhysBestand."Beschreibung erweitert" := ltr_PhysBestand.Beschreibung + ' ' + ltr_PhysBestand.Einheit + '_';
    //             ltr_PhysBestand.Verpackungscode := '';
    //             ltr_PhysBestand."Erzeugerland Code" := '';
    //             ltr_PhysBestand."Los. Nr." := '';
    //             ltr_PhysBestand."Lieferanten Nr." := '';
    //             ltr_PhysBestand.Lieferantenname := '';
    //             ltr_PhysBestand."Erwartetes Wareneingangsdatum" := 0D;
    //             ltr_PhysBestand.Status := '';
    //             ltr_PhysBestand."Menge in Bestellung" := 0;
    //             ltr_PhysBestand."Menge im Packauftrag" := 0;
    //             ltr_PhysBestand."Menge in Umlagerung" := 0;
    //             ltr_PhysBestand."Menge im Verkauf" := 0;
    //             IF ("Status neu" > "Status neu"::erwartet) THEN BEGIN
    //               ltr_PhysBestand."Soll Bestand nach Ausgang" := "Soll Bestand nach Ausgang";
    //               ltr_PhysBestand."Ist Bestand" := "Ist Bestand";
    //             END ELSE BEGIN
    //               ltr_PhysBestand."Soll Bestand nach Ausgang" := 0;
    //               ltr_PhysBestand."Ist Bestand" := 0;
    //             END;
    //             ltr_PhysBestand."Erzeugerland Code neu" := '';
    //             ltr_PhysBestand."Status neu" := ltr_PhysBestand."Status neu"::" ";
    //             ltr_PhysBestand."Batch Variant No.Input Items" := '';
    //             ltr_PhysBestand.Bemerkungen := '';
    //             ltr_PhysBestand."Beschriftung Ordner" := '';
    //             ltr_PhysBestand.insert();
    //             l_LfdNr += 1;
    //           END ELSE BEGIN
    //             IF ("Status neu" > "Status neu"::erwartet) THEN BEGIN
    //               ltr_PhysBestand."Soll Bestand nach Ausgang" := ltr_PhysBestand."Soll Bestand nach Ausgang" + "Soll Bestand nach Ausgang";
    //               ltr_PhysBestand."Ist Bestand" := ltr_PhysBestand."Ist Bestand" + "Ist Bestand";
    //               ltr_PhysBestand.Modify();
    //             END;
    //           END;
    //         UNTIL NEXT = 0;
    //       END;

    //       ltr_PhysBestand.Reset();
    //       IF ltr_PhysBestand.FINDSET() THEN BEGIN
    //         REPEAT
    //           INIT();
    //           lr_PhysBestand := ltr_PhysBestand;
    //           IF (ltr_PhysBestand."Soll Bestand nach Ausgang" <> 0) OR (ltr_PhysBestand."Ist Bestand" <> 0) THEN
    //             "Soll und Ist ungleich" := TRUE;
    //       //    ELSE IF (ltr_PhysBestand."Soll Bestand nach Ausgang" = 0) AND (ltr_PhysBestand."Ist Bestand" = 0) THEN
    //       //      "Soll und Ist ungleich" := FALSE;
    //           IF (ltr_PhysBestand."Soll Bestand nach Ausgang" < 0) AND (ltr_PhysBestand."Ist Bestand" = 0) THEN
    //             "Soll und Ist ungleich" := FALSE;
    //           Insert();
    //         UNTIL ltr_PhysBestand.NEXT() = 0;
    //       END;
    //       //Summen END
    //     END;

    //     lr_PhysBestand.Reset();
    //     //lr_PhysBestand.SETCURRENTKEY("Beschreibung erweitert","Artikel Nr.");
    //     lr_PhysBestand.SETCURRENTKEY("Beschreibung erweitert",Einheit);
    //     lr_PhysBestand.SETRANGE("Soll und Ist ungleich",TRUE);
    //     IF lr_PhysBestand.FINDSET() THEN BEGIN
    //       REPEAT
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,1,FORMAT(lr_PhysBestand."Erwartetes Wareneingangsdatum"),'',
    //             FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,2,lr_PhysBestand.Position,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,3,lr_PhysBestand.Beleg,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,4,lr_PhysBestand."Beschreibung erweitert",'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,5,lr_PhysBestand.Einheit,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,5,lr_PhysBestand.Verpackungscode,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,6,lr_PhysBestand.Lieferantenname,'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,8,lr_PhysBestand."Erzeugerland Code",'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,7,lr_PhysBestand."Los. Nr.",'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,8,lr_PhysBestand.Status,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,9,FORMAT(lr_PhysBestand."Status neu"),'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,10,FORMAT(lr_PhysBestand."Menge in Bestellung"),'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,13,FORMAT(lr_PhysBestand."Menge im Packauftrag"),'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,14,FORMAT(lr_PhysBestand."Menge in Umlagerung"),'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,15,FORMAT(lr_PhysBestand."Menge im Verkauf"),'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,11,FORMAT(lr_PhysBestand."Soll Bestand nach Ausgang"),'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,12,FORMAT(lr_PhysBestand."Ist Bestand"),'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,13,lr_PhysBestand.Bemerkungen,'',FALSE,FALSE,FALSE);
    //           l_RowNo += 1;
    //       UNTIL lr_PhysBestand.NEXT() = 0;
    //     END;

    //     l_DateTime := FORMAT(CURRENTDATETime(),0,'<Day,2>-<Month,2>-<Year4,4> Uhr <Hours24>-<Minutes,2>');
    //     ltr_ExcelBuffer.OpenBook(LTXT_Filename,'NAV Bestand');
    //     ltr_ExcelBuffer.CreateSheet('NAV Bestand','NAV Bestand',COMPANYNAME,UserID());  //Fehler ???
    //     File := '\\port-data-01\lwp\QS-Venlo\1_BestandVenloArchiv\Bestand Venlo_' + FORMAT(WORKDATE) + ' ' +
    //       COMPANYNAME + ' ' + UPPERCASE(Userid()) + '.xlsx';
    //       //l_DateTime + '.xlsx';
    //     //FORMAT(CURRENTDATETime(),0,'<Day,2>-<Month,2>-<Year> <Hours24>.<Minutes,2>') + '.xlsx';
    //     IF EXISTS(File) THEN ERASE(File);
    //     ltr_ExcelBuffer.SaveBook(File);
    //     ltr_ExcelBuffer.GiveUserControl_3();
    //     //+POI-JW 18.01.18

    // end;

    // procedure MailAfterVenloBestand()
    // var
    //     lr_Attachment: Record Attachment temporary;
    //     lc_Mail: Codeunit Mail;
    //     l_Subject: Text[100];
    //     l_BodyLine: Text[1024];
    //     LTXT_Bestand: Label '\\port-data-01\lwp\QS-Venlo\1_BestandVenloArchiv\';
    //     LTXT_Subject: Label 'Bestand Lager Venlo - Stand %1';
    //     LTXT_Mail: Label 'Der aktuelle Lagerbestand ist abrufbar unter:';
    //     l_DateTime: Text[30];
    //     l_CRLF: Text[2];
    //     l_Attachment: Text[250];
    // begin
    //     //-POI-JW 16.03.18
    //     l_CRLF[1] := 13;
    //     l_CRLF[2] := 10;
    //     CLEAR(lc_Mail);
    //     l_DateTime := FORMAT(CURRENTDATETime(),0,'<Day,2>-<Month,2>-<Year4,4> <Hours24>-<Minutes,2>');
    //     l_Subject := STRSUBSTNO(LTXT_Subject,l_DateTime);
    //     l_BodyLine := l_CRLF + l_CRLF + LTXT_Mail + l_CRLF + l_CRLF
    //       + '\\port-data-01\lwp\QS-Venlo\1_BestandVenloArchiv'
    //       + l_CRLF + l_CRLF + l_CRLF + 'Mit freundlichen Grüßen'
    //       + l_CRLF + 'Kind regards';

    //     lr_Attachment."File Extension" := LTXT_Bestand + 'Bestand Venlo_' + FORMAT(WORKDATE) + ' ' +
    //       COMPANYNAME + ' ' + UPPERCASE(Userid()) + '.xlsx';
    //     // + '.xlsx';
    //     //IF NOT EXISTS(TXT_1StammdatenblattDETxt) THEN
    //     //  ERROR('Das Dokument:\' + TXT_1StammdatenblattDETxt + '\\konnte nicht gefunden werden.');
    //     lr_Attachment.insert();
    //     l_Attachment := lr_Attachment."File Extension";
    //     ///???lc_Mail.Attachments(lr_Attachment);
    //     IF COMPANYNAME = 'PI Fruit GmbH' THEN
    //       lc_Mail.NewMessage(/*' '*/ 'Fruit-Import;qs_venlo;' /*An*/,'' /*CC*/,'',
    //         l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //     ELSE IF COMPANYNAME = 'P I Dutch Growers' THEN
    //       lc_Mail.NewMessage(/*' '*/ 'Anne;wim;antonia;qs_venlo;' /*An*/,
    //         '' /*CC*/,'',l_Subject,l_BodyLine,'' /*l_Attachment*/,
    //         FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //     ELSE IF USERID = 'WESSEL' THEN
    //       lc_Mail.NewMessage(/*' '*/ 'julita@port-international.com' /*An*/,/*'julita@port-international.com'*/'' /*CC*/,'',
    //         l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //     ELSE
    //       lc_Mail.NewMessage(/*' '*/ 'VL_Handel_PIES;regina;antonia;qs_venlo' /*An*/,'julita@port-international.com' /*CC*/,'',
    //         l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //     //+POI-JW 16.03.18

    // end;

    // procedure QSSollIstBestandVenlo()
    // var
    //     ltr_ExcelBuffer: Record "Excel Buffer" temporary;
    //     lr_PhysBestand: Record "Phys. Inventory NL";
    //     ltr_PhysBestand: Record "Phys. Inventory NL" temporary;
    //     lr_PurchLine: Record "Purchase Line";
    //     lr_PurchLineHELP: Record "Purchase Line";
    //     lr_PurchHeader: Record "Purchase Header";
    //     lr_PurchCrMemoLine: Record "Purch. Cr. Memo Line";
    //     lr_SalesLine: Record "Purchase Line";
    //     lr_SalesLineHELP: Record "Purchase Line";
    //     lr_SalesCrMemoLine: Record "Sales Cr.Memo Line";
    //     lr_SalesShipLine: Record "Sales Shipment Line";
    //     lr_POOutputItems: Record "5110713";
    //     lr_POInputItems: Record "5110714";
    //     lr_BatchQS: Record "50100";
    //     lr_TransHeader: Record "Transfer Header";
    //     lr_TransLine: Record "Transfer Line";
    //     lr_Vend: Record Vendor;
    //     PackOHeader: Record "5110712";
    //     lc_PortSystem: Codeunit "5110798";
    //     l_MengeAusVK: Decimal;
    //     l_MengeAusEK: Decimal;
    //     l_MengeAusOItems: Decimal;
    //     l_Date: Date;
    //     LTXT_Filename: Label '\\port-data-01\lwp\EDV\Navision\Vorlagen\Excel\Vorlage Bestand Venlo Liste.xlsx';
    //     l_RowNo: Integer;
    //     l_LfdNr: Integer;
    //     i: Integer;
    //     Dialog: Dialog;
    //     l_DateTime: Text[30];
    //     CurrYear: Integer;
    //     CurrMonth: Integer;
    //     CurrYearMonth: Integer;
    // begin
    //     //-POI-JW 17.01.18
    //     //Zählliste für Venlo

    //     //aus P60030
    //     l_RowNo := 2;
    //     WITH lr_PhysBestand DO BEGIN
    //       Reset();
    //       IF FINDSET THEN BEGIN
    //         REPEAT
    //           "Menge in Bestellung" :=0;
    //           "Menge im Verkauf" := 0;
    //           "Menge im Packauftrag" := 0;
    //           "Menge in Umlagerung" := 0;
    //           "Soll Bestand nach Ausgang" := 0;
    //           "Soll und Ist ungleich" := FALSE;
    //           Modify();
    //         UNTIL NEXT = 0;
    //       END;

    //       IF EVALUATE(CurrYear,COPYSTR(FORMAT(DATE2DWY(Today(),3)),3,2)) THEN
    //         IF EVALUATE(CurrMonth,COPYSTR(FORMAT(DATE2DMY(Today(),2)),1,2)) THEN
    //           IF EVALUATE(CurrYearMonth,FORMAT(CurrYear) + FORMAT(CurrMonth)) THEN
    //             l_LfdNr := CurrYearMonth * 10000;

    //       lr_PhysBestand.Reset();
    //       IF lr_PhysBestand.FINDLAST THEN
    //         l_LfdNr := lr_PhysBestand."Lfd. Nr." + 1
    //       ELSE
    //         l_LfdNr := CurrYearMonth * 10000;

    //       lr_PurchLine.Reset();
    //       lr_PurchLine.SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");
    //       lr_PurchLine.SETRANGE("Document Type",lr_PurchLine."Document Type"::Order);
    //       lr_PurchLine.SETRANGE(Type,lr_PurchLine.Type::Item);
    //       lr_PurchLine.SETFILTER("Item Category Code",'<%1','6000');
    //       lr_PurchLine.SETFILTER("Expected Receipt Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       lr_PurchLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');

    //         Dialog.OPEN('Einkaufszeile #1#### von #2####');
    //         Dialog.UPDATE(2,lr_PurchLine.COUNT);
    //         i := 0;

    //         REPEAT
    //           Dialog.UPDATE(1,i);

    //           l_MengeAusEK := 0;
    //           IF lr_PurchHeader.GET(lr_PurchHeader."Document Type"::Order,lr_PurchLine."Master Batch No.") THEN;
    //           Reset();
    //           SETRANGE("Artikel Nr.",lr_PurchLine."No.");
    //           SETRANGE(Position,lr_PurchLine."Batch Variant No.");

    //           lr_BatchQS.Reset();
    //           lr_BatchQS.SETRANGE("Document Type",lr_PurchLine."Document Type");
    //           lr_BatchQS.SETRANGE("Document No.",lr_PurchLine."Document No.");
    //           lr_BatchQS.SETRANGE("Line No.",lr_PurchLine."Line No.");
    //           IF lr_BatchQS.FIND('-') THEN;

    //           IF NOT FIND('-') THEN BEGIN
    //             INIT();
    //             "Lfd. Nr." := l_LfdNr;
    //             "Erwartetes Wareneingangsdatum" := lr_PurchHeader."Expected Receipt Date";
    //             Position := lr_PurchLine."Batch Variant No.";
    //             Beleg := lr_PurchLine."Document No.";
    //             "Artikel Nr." := lr_PurchLine."No.";
    //             Beschreibung := lr_PurchLine.Description;
    //             "Beschreibung erweitert" := lr_PurchLine.Description + ' ' + lr_PurchLine."Unit of Measure Code" + ' ' +
    //               lr_PurchLine."Country of Origin Code";
    //             Einheit := lr_PurchLine."Unit of Measure Code";
    //             Verpackungscode := lr_PurchLine."Item Attribute 6";
    //             "Lieferanten Nr." := lr_PurchHeader."Buy-from Vendor No.";
    //             Lieferantenname := lr_PurchHeader."Buy-from Vendor Name";
    //             "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //             "Los. Nr." := lr_PurchLine."Info 3";
    //             Status := FORMAT(lr_BatchQS."QS Kontrolle Status"); //Status::erwartet;
    //             "Menge in Bestellung" := lr_PurchLine.Quantity;
    //             "Beschriftung Ordner" := Position + '_' + "Beschreibung erweitert" + '_' + Lieferantenname + '_' +
    //               FORMAT("Menge in Bestellung") + '_' + FORMAT("Status neu");
    //             "Location Code" := lr_PurchLine."Location Code";
    //             Insert();
    //             l_LfdNr += 1;
    //           END ELSE BEGIN
    //             "Erwartetes Wareneingangsdatum" := lr_PurchHeader."Expected Receipt Date";
    //             Einheit := lr_PurchLine."Unit of Measure Code";
    //             Verpackungscode := lr_PurchLine."Item Attribute 6";
    //             "Lieferanten Nr." := lr_PurchHeader."Buy-from Vendor No.";
    //             Lieferantenname := lr_PurchHeader."Buy-from Vendor Name";
    //             "Los. Nr." := lr_PurchLine."Info 3";
    //             "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //             Beschreibung := lr_PurchLine.Description;
    //             "Beschreibung erweitert" := lr_PurchLine.Description + ' ' + lr_PurchLine."Unit of Measure Code" + ' ' +
    //               lr_PurchLine."Country of Origin Code";
    //             Status := FORMAT(lr_BatchQS."QS Kontrolle Status"); //Status::erwartet;
    //             "Menge in Bestellung" := lr_PurchLine.Quantity;
    //             "Beschriftung Ordner" := Position + '_' + "Beschreibung erweitert" + '_' + Lieferantenname + '_' +
    //               FORMAT("Menge in Bestellung") + '_' + FORMAT("Status neu");
    //             "Location Code" := lr_PurchLine."Location Code";
    //             Modify();
    //           END;

    //           //EK-Gutschrift dazu
    //           lr_PurchLineHELP.Reset();
    //           lr_PurchLineHELP.SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code",
    //             "Expected Receipt Date");
    //           lr_PurchLineHELP.SETRANGE("Document Type",lr_PurchLineHELP."Document Type"::"Credit Memo");
    //           lr_PurchLineHELP.SETRANGE(Type,lr_PurchLineHELP.Type::Item);
    //           lr_PurchLineHELP.SETRANGE("No.","Artikel Nr.");
    //           lr_PurchLineHELP.SETFILTER("Expected Receipt Date",'>=%1|%2',CALCDATE('-1M',TODAY),0D);
    //           lr_PurchLineHELP.SETRANGE("Batch Variant No.",Position);
    //           lr_PurchLineHELP.SETFILTER("Item Category Code",'<%1','6000');
    //           lr_PurchLineHELP.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //           IF lr_PurchLineHELP.FINDSET() THEN BEGIN
    //             REPEAT
    //               IF lr_PurchLineHELP."Expected Receipt Date" <> 0D THEN BEGIN
    //                 "Menge in Bestellung" += lr_PurchLineHELP.Quantity;
    //               END ELSE IF lr_PurchLineHELP."Expected Receipt Date" = 0D THEN BEGIN
    //                 IF lr_PurchHeader.GET(lr_PurchLineHELP."Document Type",lr_PurchLineHELP."Document No.") THEN BEGIN
    //                   IF lr_PurchHeader."Posting Date" > (CALCDATE('-4M',TODAY)) THEN
    //                     "Menge in Bestellung" := lr_PurchLineHELP.Quantity;
    //                 END;
    //               END;
    //             UNTIL lr_PurchLineHELP.NEXT() = 0;
    //             Modify();
    //           END;

    //           /*Geb. EK-Gutschrift wird gleich im EK-vermerkt -> wird hier nicht benötigt
    //           //EK-Geb. Reklamation dazu
    //           lr_PurchCrMemoLine.Reset();
    //           lr_PurchCrMemoLine.SETRANGE(Type,lr_PurchCrMemoLine.Type::Item);
    //           lr_PurchCrMemoLine.SETRANGE("No.",lr_PurchLine."No.");
    //           lr_PurchCrMemoLine.SETFILTER("Posting Date",'>=%1',CALCDATE('-1M',TODAY));     //1. Tag aktueller Monat
    //           lr_PurchCrMemoLine.SETRANGE("Batch Variant No.",lr_PurchLine."Batch Variant No.");
    //           lr_PurchCrMemoLine.SETFILTER("Item Category Code",'<%1','6000');
    //           lr_PurchCrMemoLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //           IF lr_PurchCrMemoLine.FINDSET() THEN BEGIN
    //             REPEAT
    //               "Menge in Bestellung" +=  lr_PurchCrMemoLine.Quantity;
    //             UNTIL lr_PurchCrMemoLine.NEXT() = 0;
    //             Modify();
    //           END;
    //           */

    //           i += 1;
    //         UNTIL lr_PurchLine.NEXT() = 0;
    //     //  END;

    //       //Packerei Output
    //       lr_PhysBestand.Reset();
    //       IF lr_PhysBestand.FINDLAST THEN
    //         l_LfdNr := lr_PhysBestand."Lfd. Nr." + 1
    //       ELSE
    //         l_LfdNr := CurrYearMonth * 10000;

    //       lr_POOutputItems.Reset();
    //       lr_POOutputItems.SETFILTER("Item Category Code",'<%1','6000');
    //       lr_POOutputItems.SETFILTER("Expected Receipt Date",'>=%1',CALCDATE('-1M',TODAY));
    //       lr_POOutputItems.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //       IF lr_POOutputItems.FINDSET() THEN BEGIN
    //         REPEAT
    //           Reset();
    //           SETRANGE("Artikel Nr.",lr_POOutputItems."Item No.");
    //           SETRANGE(Position,lr_POOutputItems."Batch Variant No.");
    //           SETRANGE(Beleg,lr_POOutputItems."Doc. No.");
    //           IF NOT FIND('-') THEN BEGIN
    //             INIT();
    //             "Lfd. Nr." := l_LfdNr;
    //             "Erwartetes Wareneingangsdatum" := lr_POOutputItems."Expected Receipt Date";
    //             Position := lr_POOutputItems."Batch Variant No.";
    //             Beleg := lr_POOutputItems."Doc. No.";
    //             "Artikel Nr." := lr_POOutputItems."Item No.";
    //             Beschreibung := lr_POOutputItems."Item Description";
    //             "Beschreibung erweitert" := lr_POOutputItems."Item Description" + ' ' + lr_POOutputItems."Unit of Measure Code" + ' ' +
    //               lr_POOutputItems."Country of Origin Code";
    //             Einheit := lr_POOutputItems."Unit of Measure Code";
    //             Verpackungscode := lr_POOutputItems."Item Attribute 6";
    //             IF PackOHeader.GET(lr_POOutputItems."Doc. No.") THEN BEGIN
    //               "Lieferanten Nr." := PackOHeader."Pack.-by Vendor No.";
    //               Lieferantenname := PackOHeader."Pack.-by Name";
    //             END;
    //             "Erzeugerland Code" := lr_POOutputItems."Country of Origin Code";
    //             "Los. Nr." := lr_POOutputItems."Info 3";
    //             Status := FORMAT(lr_POOutputItems.Status); //Status::erwartet;
    //             "Menge in Bestellung" := lr_POOutputItems.Quantity;
    //             "Location Code" := lr_POOutputItems."Location Code";
    //             Insert();
    //             l_LfdNr += 1;
    //           END ELSE BEGIN
    //             "Menge in Bestellung" := lr_POOutputItems.Quantity;
    //             "Erwartetes Wareneingangsdatum" := lr_PurchHeader."Expected Receipt Date";
    //             Beschreibung := lr_POOutputItems."Item Description";
    //             "Beschreibung erweitert" := lr_POOutputItems."Item Description" + ' ' + lr_POOutputItems."Unit of Measure Code" + ' ' +
    //               lr_POOutputItems."Country of Origin Code";
    //             IF PackOHeader.GET(lr_POOutputItems."Doc. No.") THEN BEGIN
    //               "Lieferanten Nr." := PackOHeader."Pack.-by Vendor No.";
    //               Lieferantenname := PackOHeader."Pack.-by Name";
    //             END;
    //             Einheit := lr_POOutputItems."Unit of Measure Code";
    //             Verpackungscode := lr_POOutputItems."Item Attribute 6";
    //             "Erzeugerland Code" := lr_POOutputItems."Country of Origin Code";
    //             "Los. Nr." := lr_POOutputItems."Info 3";
    //             Status := FORMAT(lr_POOutputItems.Status); //Status::erwartet;
    //             "Location Code" := lr_POOutputItems."Location Code";
    //             Modify();
    //           END;
    //         UNTIL lr_POOutputItems.NEXT() = 0;
    //       END;

    //       //Umlagerungen
    //       lr_PhysBestand.Reset();
    //       IF lr_PhysBestand.FINDLAST THEN
    //         l_LfdNr := lr_PhysBestand."Lfd. Nr." + 1
    //       ELSE
    //         l_LfdNr := CurrYearMonth * 10000;

    //       lr_TransHeader.Reset();
    //       //lr_TransHeader.SETFILTER("Posting Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       lr_TransHeader.SETFILTER("Receipt Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       IF lr_TransHeader.FINDSET() THEN BEGIN
    //         REPEAT
    //           lr_TransLine.Reset();
    //           lr_TransLine.SETRANGE("Document No.",lr_TransHeader."No.");
    //           lr_TransLine.SETFILTER(lr_TransLine."Item No.",'<>%1','');
    //           lr_TransLine.SETFILTER("Item Category Code",'<%1','6000');
    //           IF lr_TransLine.FINDSET() THEN BEGIN
    //             REPEAT
    //               Reset();
    //               SETRANGE("Artikel Nr.",lr_TransLine."Item No.");
    //               SETRANGE(Position,lr_TransLine."Batch Variant No.");
    //               SETRANGE(Beleg,lr_TransHeader."No.");
    //               IF NOT FIND('-') THEN BEGIN
    //                 INIT();
    //                 "Lfd. Nr." := l_LfdNr;
    //                 Position := lr_TransLine."Batch Variant No.";
    //                 Beleg := lr_TransHeader."No.";
    //                 "Artikel Nr." := lr_TransLine."Item No.";
    //                 Beschreibung := lr_TransLine.Description;
    //                 Einheit := lr_TransLine."Unit of Measure Code";
    //                 Verpackungscode := lr_TransLine."Item Attribute 6";
    //                 "Lieferanten Nr." := '';
    //                 Lieferantenname := '';
    //                 "Erzeugerland Code" := '';
    //                 PackOHeader.Reset();
    //                 PackOHeader.SETRANGE(PackOHeader."Master Batch No.",lr_TransLine."Master Batch No.");
    //                 IF PackOHeader.FINDFIRST() THEN BEGIN
    //                   "Lieferanten Nr." := PackOHeader."Pack.-by Vendor No.";
    //                   Lieferantenname := PackOHeader."Pack.-by Name";
    //                 END;
    //                 lr_PurchLine.Reset();
    //                 lr_PurchLine.SETRANGE("Document No.",lr_TransLine."Master Batch No.");
    //                 IF lr_PurchLine.FIND('-') THEN BEGIN
    //                   "Lieferanten Nr." := lr_PurchLine."Buy-from Vendor No.";
    //                   IF lr_Vend.GET(lr_PurchLine."Buy-from Vendor No.") THEN
    //                     Lieferantenname := lr_Vend.Name;
    //                   "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //                 END;
    //                 "Beschreibung erweitert" := lr_TransLine.Description + ' ' + lr_TransLine."Unit of Measure Code" + ' ' +
    //                   "Erzeugerland Code";
    //                 "Los. Nr." := lr_TransLine."Info 3";
    //                 Status := FORMAT(lr_TransHeader.Status); //Status::erwartet;
    //                 "Menge in Bestellung" := lr_TransLine.Quantity;
    //                 "Menge im Verkauf" := 0;
    //                 "Soll Bestand nach Ausgang" := 0;
    //                 "Soll und Ist ungleich" := TRUE;
    //                 "Erwartetes Wareneingangsdatum" := lr_TransHeader."Receipt Date";

    //                 IF ((lr_TransHeader."Transfer-from Code" <> 'KOOPS VENL') AND (lr_TransHeader."Transfer-from Code" <> 'ALDI VENLO') AND
    //                   (lr_TransHeader."Transfer-from Code" <> 'NORMA VENL')) AND
    //                   ((lr_TransHeader."Transfer-to Code" = 'KOOPS VENL') OR (lr_TransHeader."Transfer-to Code" = 'ALDI VENLO') OR
    //                   (lr_TransHeader."Transfer-to Code" = 'NORMA VENL'))
    //                 THEN BEGIN
    //                   "Location Code" := lr_TransHeader."Transfer-to Code";
    //                 IF INSERT THEN
    //                   l_LfdNr += 1;
    //                 END;
    //               END ELSE BEGIN
    //                 Verpackungscode := lr_TransLine."Item Attribute 6";
    //                 "Los. Nr." := lr_TransLine."Info 3";
    //                 "Erzeugerland Code" := '';
    //                 Beschreibung := lr_TransLine.Description;
    //                 PackOHeader.Reset();
    //                 PackOHeader.SETRANGE(PackOHeader."Master Batch No.",lr_TransLine."Master Batch No.");
    //                 IF PackOHeader.FINDFIRST() THEN BEGIN
    //                   "Lieferanten Nr." := PackOHeader."Pack.-by Vendor No.";
    //                   Lieferantenname := PackOHeader."Pack.-by Name";
    //                 END;
    //                 lr_PurchLine.Reset();
    //                 lr_PurchLine.SETRANGE("Document No.",lr_TransLine."Master Batch No.");
    //                 IF lr_PurchLine.FIND('-') THEN BEGIN
    //                   "Lieferanten Nr." := lr_PurchLine."Buy-from Vendor No.";
    //                   IF lr_Vend.GET(lr_PurchLine."Buy-from Vendor No.") THEN
    //                     Lieferantenname := lr_Vend.Name;
    //                   "Erzeugerland Code" := lr_PurchLine."Country of Origin Code";
    //                 END;
    //                 "Beschreibung erweitert" := lr_TransLine.Description + ' ' + lr_TransLine."Unit of Measure Code" + ' ' +
    //                   "Erzeugerland Code";
    //                 Status := FORMAT(lr_TransHeader.Status); //Status::erwartet;
    //                 "Menge in Bestellung" += lr_TransLine.Quantity;
    //                 "Erwartetes Wareneingangsdatum" := lr_TransHeader."Receipt Date";
    //                 "Location Code" := lr_TransHeader."Transfer-to Code";
    //                 Modify();
    //               END;
    //               l_LfdNr += 1;
    //             UNTIL lr_TransLine.NEXT() = 0;
    //           END;
    //         UNTIL lr_TransHeader.NEXT() = 0;
    //       END;
    //       //Umlagerungen END

    //       //NEU 11.10.
    //       lr_TransHeader.Reset();
    //       //lr_TransHeader.SETFILTER("Posting Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       lr_TransHeader.SETFILTER("Receipt Date",'>=%1',CALCDATE('-1M',TODAY));   //1. Tag aktueller Monat
    //       IF lr_TransHeader.FINDSET() THEN BEGIN
    //         REPEAT
    //           lr_TransLine.Reset();
    //           lr_TransLine.SETRANGE("Document No.",lr_TransHeader."No.");
    //           lr_TransLine.SETFILTER("Item No.",'<>%1','');
    //           lr_TransLine.SETFILTER("Item Category Code",'<%1','6000');
    //           IF lr_TransLine.FINDSET() THEN BEGIN
    //             REPEAT
    //               Reset();
    //               SETRANGE("Artikel Nr.",lr_TransLine."Item No.");
    //               SETRANGE(Position,lr_TransLine."Batch Variant No.");
    //               IF FIND('-') THEN BEGIN
    //                 IF ((lr_TransHeader."Transfer-from Code" = 'KOOPS VENL') OR (lr_TransHeader."Transfer-from Code" = 'ALDI VENLO') OR
    //                   (lr_TransHeader."Transfer-from Code" = 'NORMA VENL')) AND
    //                   ((lr_TransHeader."Transfer-to Code" <> 'KOOPS VENL') AND (lr_TransHeader."Transfer-to Code" <> 'ALDI VENLO') AND
    //                   (lr_TransHeader."Transfer-to Code" <> 'NORMA VENL'))
    //                 THEN BEGIN
    //                   "Location Code" := lr_TransHeader."Transfer-from Code";
    //                   "Menge in Umlagerung" += lr_TransLine.Quantity;
    //                   Modify();
    //                 END;
    //               END;
    //             UNTIL lr_TransLine.NEXT() = 0;
    //           END;
    //         UNTIL lr_TransHeader.NEXT() = 0;
    //       END;

    //       //Packerei Input mit Partie selbst verrechnen
    //       lr_POInputItems.Reset();
    //       lr_POInputItems.SETFILTER("Item Category Code",'<%1','6000');
    //       lr_POInputItems.SETFILTER("Expected Receipt Date",'>=%1',CALCDATE('-2M',TODAY));  //2M belassen
    //       lr_POInputItems.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //       IF lr_POInputItems.FINDSET() THEN BEGIN
    //         REPEAT
    //           Reset();
    //           SETRANGE("Artikel Nr.",lr_POInputItems."Item No.");
    //           SETRANGE(Position,lr_POInputItems."Batch Variant No.");
    //           IF FIND('-') THEN BEGIN
    //             "Menge im Packauftrag" += lr_POInputItems.Quantity;
    //             "Batch Variant No.Input Items" := lr_POInputItems."Batch Variant No.";
    //             Modify();
    //           END;
    //         UNTIL lr_POInputItems.NEXT() = 0;
    //       END;

    //       Reset();
    //       IF FINDSET THEN BEGIN
    //         REPEAT
    //           IF (COPYSTR("Lieferanten Nr.",1,1) <> 'U') THEN BEGIN
    //             l_MengeAusVK := 0;
    //             lr_SalesLine.Reset();
    //             lr_SalesLine.SETRANGE("Document Type",lr_SalesLine."Document Type"::Order);
    //             lr_SalesLine.SETRANGE(Type,lr_SalesLine.Type::Item);
    //             lr_SalesLine.SETRANGE("No.","Artikel Nr.");
    //             lr_SalesLine.SETRANGE("Batch Variant No.",Position);
    //             lr_SalesLine.SETFILTER("Qty. to Ship",'<>%1',0);

    //       //      lr_SalesLine.SETRANGE("Batch Variant No.",'19-70065-024');

    //             lr_SalesLine.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_SalesLine.SETFILTER("Shipment Date",'>=%1&<=%2',CALCDATE('-1M',TODAY),/*CALCDATE('-1T',*/TODAY/*)*/);
    //             lr_SalesLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_SalesLine.FINDSET() THEN BEGIN
    //               REPEAT
    //                 /*23.10.
    //                   lr_SalesShipLine.Reset();
    //                   lr_SalesShipLine.SETRANGE(Type,lr_SalesShipLine.Type::Item);
    //                   lr_SalesShipLine.SETRANGE("No.",lr_SalesLine."No.");
    //                   lr_SalesShipLine.SETFILTER("Posting Date",'<=%1',CALCDATE('-1T',TODAY));
    //                   lr_SalesShipLine.SETRANGE("Batch Variant No.",lr_SalesLine."Batch Variant No.");
    //                   lr_SalesShipLine.SETRANGE("Order No.",lr_SalesLine."Document No.");
    //                   lr_SalesShipLine.SETRANGE("Order Line No.",lr_SalesLine."Line No.");
    //                   IF NOT lr_SalesShipLine.FIND('-') THEN BEGIN
    //                   */
    //                   "Menge im Verkauf" += lr_SalesLine.Quantity;
    //                   Modify();
    //                 //23.10.END;
    //               UNTIL  lr_SalesLine.NEXT() = 0;
    //             END;

    //             //VK-Geb. Lieferungen dazu
    //             lr_SalesShipLine.Reset();
    //             lr_SalesShipLine.SETRANGE(Type,lr_SalesShipLine.Type::Item);
    //             lr_SalesShipLine.SETRANGE("No.","Artikel Nr.");
    //             lr_SalesShipLine.SETFILTER("Posting Date",'<=%1',/*CALCDATE('-1T',*/TODAY/*)*/);
    //             lr_SalesShipLine.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_SalesShipLine.SETRANGE("Batch Variant No.",Position);

    //        //     lr_SalesShipLine.SETRANGE("Batch Variant No.",'19-70065-024');

    //             lr_SalesShipLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_SalesShipLine.FINDSET() THEN BEGIN
    //               REPEAT
    //               /*
    //                 IF (lr_SalesShipLine."Order No." = lr_SalesLine."Document No.") AND
    //                   (lr_SalesShipLine."Order Line No." = lr_SalesLine."Line No.")
    //                 THEN BEGIN
    //                   IF (lr_SalesLine.Quantity <> lr_SalesShipLine.Quantity) THEN
    //                     "Menge im Verkauf" -= (lr_SalesLine.Quantity - lr_SalesShipLine.Quantity);
    //                 END;
    //               UNTIL lr_SalesShipLine.NEXT() = 0;
    //               Modify();
    //               */
    //                 "Menge im Verkauf" +=  lr_SalesShipLine.Quantity;
    //               UNTIL lr_SalesShipLine.NEXT() = 0;
    //               Modify();
    //             END;

    //             //VK-Gutschrift abziehen
    //             lr_SalesLineHELP.Reset();
    //             lr_SalesLineHELP.SETRANGE("Document Type",lr_SalesLineHELP."Document Type"::"Credit Memo");
    //             lr_SalesLineHELP.SETRANGE(Type,lr_SalesLineHELP.Type::Item);
    //             lr_SalesLineHELP.SETRANGE("No.","Artikel Nr.");
    //             lr_SalesLineHELP.SETFILTER("Shipment Date",'<=%1',/*CALCDATE('-1T',*/TODAY/*)*/);
    //             lr_SalesLineHELP.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_SalesLineHELP.SETRANGE("Batch Variant No.",Position);
    //             lr_SalesLineHELP.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_SalesLineHELP.FINDSET() THEN BEGIN
    //               REPEAT
    //                 "Menge im Verkauf" -= lr_SalesLineHELP.Quantity;
    //               UNTIL lr_SalesLineHELP.NEXT() = 0;
    //               Modify();
    //             END;

    //             //VK-Geb. Gutschrift abziehen
    //             lr_SalesCrMemoLine.Reset();
    //             lr_SalesCrMemoLine.SETRANGE(Type,lr_SalesCrMemoLine.Type::Item);
    //             lr_SalesCrMemoLine.SETRANGE("No.","Artikel Nr.");
    //             lr_SalesCrMemoLine.SETFILTER("Posting Date",'<=%1',/*CALCDATE('-1T',*/TODAY/*)*/);
    //             lr_SalesCrMemoLine.SETFILTER("Posting Date",'<=%1',CALCDATE('-1T',TODAY));
    //             lr_SalesCrMemoLine.SETFILTER("Item Category Code",'<%1','6000');
    //             lr_SalesCrMemoLine.SETRANGE("Batch Variant No.",Position);
    //             lr_SalesCrMemoLine.SETFILTER("Location Code",'%1|%2|%3','ALDI VENLO','KOOPS VENL','NORMA VENL');
    //             IF lr_SalesCrMemoLine.FINDSET() THEN BEGIN
    //               REPEAT
    //                 "Menge im Verkauf" -=  lr_SalesCrMemoLine.Quantity;
    //               UNTIL lr_SalesCrMemoLine.NEXT() = 0;
    //               Modify();
    //             END;
    //             "Soll Bestand nach Ausgang" := "Menge in Bestellung" - "Menge im Verkauf" - "Menge im Packauftrag" - "Menge in Umlagerung";
    //             //2.7.19 C. Heise
    //             IF "Soll Bestand nach Ausgang" < 0 THEN
    //             "Soll Bestand nach Ausgang" := 0;

    //             IF ("Menge im Verkauf" + "Soll Bestand nach Ausgang") = 0 THEN BEGIN
    //               "Menge im Verkauf" := 0;
    //               "Soll Bestand nach Ausgang" := 0;
    //             END;
    //             IF "Soll Bestand nach Ausgang" <> 0 THEN
    //               "Soll und Ist ungleich" := TRUE;
    //             IF "Ist Bestand" <> 0 THEN
    //               "Soll und Ist ungleich" := TRUE;

    //             IF ("Soll Bestand nach Ausgang" < 0) AND ("Ist Bestand" = 0) THEN
    //               "Soll und Ist ungleich" := FALSE;
    //             Modify();
    //           END;
    //         UNTIL NEXT = 0;
    //       END;

    //       //Summen
    //       Reset();
    //       SETRANGE(Position,'Summe');
    //       IF FINDSET THEN
    //         DELETEALL;

    //       lr_PhysBestand.Reset();
    //       IF lr_PhysBestand.FINDLAST THEN
    //         l_LfdNr := lr_PhysBestand."Lfd. Nr." + 1
    //       ELSE
    //         l_LfdNr := CurrYearMonth * 10000;

    //       Reset();
    //       SETFILTER("Artikel Nr.",'<>%1','');
    //       //SETFILTER("Status neu",'>%1',"Status neu"::erwartet);
    //       IF FINDSET THEN BEGIN
    //         REPEAT
    //           ltr_PhysBestand.Reset();
    //           ltr_PhysBestand.SETRANGE("Artikel Nr.","Artikel Nr.");
    //           ltr_PhysBestand.SETRANGE(Einheit,Einheit);
    //           IF NOT ltr_PhysBestand.FIND('-') THEN BEGIN
    //             ltr_PhysBestand.INIT();
    //             ltr_PhysBestand := lr_PhysBestand;
    //             ltr_PhysBestand."Lfd. Nr." := l_LfdNr;
    //             ltr_PhysBestand."Artikel Nr." := "Artikel Nr.";
    //             ltr_PhysBestand.Position := 'Summe';
    //             ltr_PhysBestand.Beleg := '';
    //             ltr_PhysBestand."Beschreibung erweitert" := ltr_PhysBestand.Beschreibung + ' ' + ltr_PhysBestand.Einheit + '_';
    //             ltr_PhysBestand.Verpackungscode := '';
    //             ltr_PhysBestand."Erzeugerland Code" := '';
    //             ltr_PhysBestand."Los. Nr." := '';
    //             ltr_PhysBestand."Lieferanten Nr." := '';
    //             ltr_PhysBestand.Lieferantenname := '';
    //             ltr_PhysBestand."Erwartetes Wareneingangsdatum" := 0D;
    //             ltr_PhysBestand.Status := '';
    //             ltr_PhysBestand."Menge in Bestellung" := 0;
    //             ltr_PhysBestand."Menge im Packauftrag" := 0;
    //             ltr_PhysBestand."Menge in Umlagerung" := 0;
    //             ltr_PhysBestand."Menge im Verkauf" := 0;
    //             IF ("Status neu" > "Status neu"::erwartet) THEN BEGIN
    //               ltr_PhysBestand."Soll Bestand nach Ausgang" := "Soll Bestand nach Ausgang";
    //               ltr_PhysBestand."Ist Bestand" := "Ist Bestand";
    //             END ELSE BEGIN
    //               ltr_PhysBestand."Soll Bestand nach Ausgang" := 0;
    //               ltr_PhysBestand."Ist Bestand" := 0;
    //             END;
    //             ltr_PhysBestand."Erzeugerland Code neu" := '';
    //             ltr_PhysBestand."Status neu" := ltr_PhysBestand."Status neu"::" ";
    //             ltr_PhysBestand."Batch Variant No.Input Items" := '';
    //             ltr_PhysBestand.Bemerkungen := '';
    //             ltr_PhysBestand."Beschriftung Ordner" := '';
    //             ltr_PhysBestand.insert();
    //             l_LfdNr += 1;
    //           END ELSE BEGIN
    //             IF ("Status neu" > "Status neu"::erwartet) THEN BEGIN
    //               ltr_PhysBestand."Soll Bestand nach Ausgang" := ltr_PhysBestand."Soll Bestand nach Ausgang" + "Soll Bestand nach Ausgang";
    //               ltr_PhysBestand."Ist Bestand" := ltr_PhysBestand."Ist Bestand" + "Ist Bestand";
    //               ltr_PhysBestand.Modify();
    //             END;
    //           END;
    //         UNTIL NEXT = 0;
    //       END;

    //       ltr_PhysBestand.Reset();
    //       IF ltr_PhysBestand.FINDSET() THEN BEGIN
    //         REPEAT
    //           INIT();
    //           lr_PhysBestand := ltr_PhysBestand;
    //           IF (ltr_PhysBestand."Soll Bestand nach Ausgang" <> 0) OR (ltr_PhysBestand."Ist Bestand" <> 0) THEN
    //             "Soll und Ist ungleich" := TRUE;
    //       //    ELSE IF (ltr_PhysBestand."Soll Bestand nach Ausgang" = 0) AND (ltr_PhysBestand."Ist Bestand" = 0) THEN
    //       //      "Soll und Ist ungleich" := FALSE;
    //           IF (ltr_PhysBestand."Soll Bestand nach Ausgang" < 0) AND (ltr_PhysBestand."Ist Bestand" = 0) THEN
    //             "Soll und Ist ungleich" := FALSE;
    //           Insert();
    //         UNTIL ltr_PhysBestand.NEXT() = 0;
    //       END;
    //     END;

    //     ltr_ExcelBuffer.DELETEALL();

    //     lr_PhysBestand.Reset();
    //     //lr_PhysBestand.SETCURRENTKEY("Beschreibung erweitert","Artikel Nr.");
    //     lr_PhysBestand.SETCURRENTKEY("Beschreibung erweitert",Einheit);
    //     lr_PhysBestand.SETRANGE("Soll und Ist ungleich",TRUE);
    //     IF lr_PhysBestand.FINDSET() THEN BEGIN
    //       REPEAT
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,1,FORMAT(lr_PhysBestand."Erwartetes Wareneingangsdatum"),'',
    //             FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,2,lr_PhysBestand.Position,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,3,lr_PhysBestand.Beleg,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,4,lr_PhysBestand."Beschreibung erweitert",'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,5,lr_PhysBestand.Einheit,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,5,lr_PhysBestand.Verpackungscode,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,6,lr_PhysBestand.Lieferantenname,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,7,lr_PhysBestand."Erzeugerland Code",'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,8,lr_PhysBestand."Los. Nr.",'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,10,lr_PhysBestand.Status,'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,9,FORMAT(lr_PhysBestand."Status neu"),'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,10,FORMAT(lr_PhysBestand."Menge in Bestellung"),'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,13,FORMAT(lr_PhysBestand."Menge im Packauftrag"),'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,14,FORMAT(lr_PhysBestand."Menge in Umlagerung"),'',FALSE,FALSE,FALSE);
    //           //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,15,FORMAT(lr_PhysBestand."Menge im Verkauf"),'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,11,FORMAT(lr_PhysBestand."Soll Bestand nach Ausgang"),'',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,12,'','',FALSE,FALSE,FALSE);
    //           lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,13,lr_PhysBestand.Bemerkungen,'',FALSE,FALSE,FALSE);
    //           l_RowNo += 1;
    //       UNTIL lr_PhysBestand.NEXT() = 0;
    //     END;

    //     l_DateTime := FORMAT(CURRENTDATETime(),0,'<Day,2>-<Month,2>-<Year4,4> Uhr <Hours24>-<Minutes,2>');
    //     ltr_ExcelBuffer.OpenBook(LTXT_Filename,'NAV Bestand');
    //     ltr_ExcelBuffer.CreateSheet('NAV Bestand','NAV Bestand',COMPANYNAME,UserID());  //Fehler ???
    //     ltr_ExcelBuffer.GiveUserControl;
    //     //+POI-JW 18.01.18

    // end;

    // procedure BestandVENLODeleteCompany()
    // var
    //     NASHandler: Codeunit "89353";
    // begin
    //     NASHandler.SetSessionChangeNotAllowed(TRUE);
    //     BestandVENLODelete('P I Dutch Growers');
    //     BestandVENLODelete('P I Organics GmbH');
    //     BestandVENLODelete('PI Bananas GmbH');
    //     BestandVENLODelete('PI European Sourcing');
    //     BestandVENLODelete('PI Fruit GmbH');
    //     NASHandler.SetSessionChangeNotAllowed(FALSE);
    // end;

    // procedure BestandVENLODelete(Company: Text[30])
    // var
    //     BestandVENLO: Record "Phys. Inventory NL";
    // begin
    //     BestandVENLO.CHANGECOMPANY(Company);
    //     BestandVENLO.Reset();
    //     BestandVENLO.SETFILTER("Erwartetes Wareneingangsdatum",'<=%1',CALCDATE('-2M',TODAY));
    //     IF BestandVENLO.FINDSET() THEN
    //       BestandVENLO.DELETEALL();
    // end;

    // procedure "------manuell"()
    // begin
    // end;

    // procedure EKVK()
    // var
    //     lr_PurchHeader: Record "Purchase Header";
    //     lr_Vendor: Record Vendor;
    //     ltr_Buffer: Record "50910" temporary;
    //     l_LfdNo: Integer;
    //     l_RowNo: Integer;
    //     ltr_ExcelBuffer: Record "Excel Buffer" temporary;
    //     lc_PortSystem: Codeunit "5110798";
    //     FileName: Text[250];
    // begin
    //     lr_PurchHeader.Reset();
    //     lr_PurchHeader.SETFILTER("Order Date",'>=%1',20161001D);
    //     IF lr_PurchHeader.FINDSET() THEN BEGIN
    //       l_LfdNo := 1;
    //       REPEAT
    //         IF lr_Vendor.GET(lr_PurchHeader."Buy-from Vendor No.") THEN BEGIN
    //           IF (lr_Vendor.Blocked <> lr_Vendor.Blocked::All) THEN BEGIN
    //             ltr_Buffer.Reset();
    //             ltr_Buffer.SETRANGE(code1,lr_PurchHeader."Buy-from Vendor No.");
    //             IF NOT ltr_Buffer.FIND('-') THEN BEGIN
    //               ltr_Buffer.INIT();
    //               ltr_Buffer.LineNo := l_LfdNo;
    //               ltr_Buffer.code1 := lr_PurchHeader."Buy-from Vendor No.";
    //               ltr_Buffer.text1 := lr_Vendor.Name;
    //               ltr_Buffer.text2 := lr_Vendor.Address;
    //               ltr_Buffer.code2 := lr_Vendor."Country/Region Code";
    //               ltr_Buffer.code3 := lr_Vendor."Post Code";
    //               ltr_Buffer.text3 := lr_Vendor.City;
    //               ltr_Buffer.code4 := lr_Vendor."Purchaser Code";
    //               ltr_Buffer."User-ID" := USERID;
    //               ltr_Buffer.insert();
    //             END;
    //             l_LfdNo += 1;
    //           END;
    //         END;
    //       UNTIL lr_PurchHeader.NEXT() = 0;
    //     END;

    //     l_RowNo := 1;
    //     lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,1,'Nr.','',TRUE,FALSE,FALSE);
    //     lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,2,'Name','',TRUE,FALSE,FALSE);
    //     lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,3,'Adresse','',TRUE,FALSE,FALSE);
    //     lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,4,'Land','',TRUE,FALSE,FALSE);
    //     lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,5,'PLZ-Code','',TRUE,FALSE,FALSE);
    //     lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,6,'Ort','',TRUE,FALSE,FALSE);
    //     lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,7,'Einkäufercode','',TRUE,FALSE,FALSE);
    //     //lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,8,'USER','',TRUE,FALSE,FALSE);

    //     ltr_Buffer.Reset();
    //     IF ltr_Buffer.FINDSET() THEN BEGIN
    //     //MESSAGE('Count %1',ltr_Buffer.COUNT);
    //       REPEAT
    //         l_RowNo += 1;
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,1,ltr_Buffer.code1,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,2,ltr_Buffer.text1,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,3,ltr_Buffer.text2,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,4,ltr_Buffer.code2,'',TRUE,TRUE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,5,ltr_Buffer.code3,'',FALSE,FALSE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,6,ltr_Buffer.text3,'',TRUE,TRUE,FALSE);
    //         lc_PortSystem.EnterCell(ltr_ExcelBuffer,l_RowNo,7,ltr_Buffer.code4,'',TRUE,TRUE,FALSE);
    //       UNTIL ltr_Buffer.NEXT() = 0;
    //     END;

    //     FileName:= '\\PORT-DATA-01\lwp\Benutzer\Wessel\Fruit Kreditoren.xlsx';
    //     ltr_ExcelBuffer.OpenBook(FileName,'Fruit Kreditoren');
    //     ltr_ExcelBuffer.CreateSheet('Fruit Kreditoren','',COMPANYNAME,UserID());
    //     ltr_ExcelBuffer.SaveBook('\\PORT-DATA-01\lwp\Benutzer\Wessel\Fruit Kreditoren.xlsx');
    //     ltr_ExcelBuffer.GiveUserControl;
    // end;

    // procedure LinkFunctions()
    // begin
    //     /*noch

    //         PROCEDURE ShowCodeLink@50030(p_Description@50000 : Text[250];p_Company@50001 : Text[30];p_Result@50002 : 'Nothing,Error if Error
    //         VAR
    //           lri_Record@50005 : RecordID;
    //           lrr_Setup@50004 : RecordRef;
    //           l_Link@50003 : Text[1024];
    //         BEGIN
    //           lrr_Setup.OPEN(315);
    //           lrr_Setup.FINDFIRST;
    //           lri_Record := lrr_Setup.RECORDID();
    //           lrr_Setup.CLOSE;

    //           l_Link := GetLink(lri_Record,p_Description,0,'','',p_Company);
    //           IF l_Link <> '' THEN
    //             HYPERLINK(l_Link);
    //         END;

    //         PROCEDURE GetCodeLink@50041(p_Description@50000 : Text[250];p_Company@50001 : Text[30];p_Result@50002 : 'Nothing,Error if Error,
    //         VAR
    //           lri_Record@50005 : RecordID;
    //           lrr_Setup@50004 : RecordRef;
    //         BEGIN
    //           lrr_Setup.OPEN(315);
    //           lrr_Setup.FINDFIRST;
    //           lri_Record := lrr_Setup.RECORDID();
    //           lrr_Setup.CLOSE;

    //           EXIT(GetLink(lri_Record,p_Description,0,'','',p_Company));
    //         END;

    //         PROCEDURE GetLink@50029(pri_Record@50010 : RecordID;p_DescriptionFilter@50005 : Text[250];p_Type@50007 : 'Link,Note';p_DateFilte
    //         VAR
    //           lrr_Link@50003 : RecordRef;
    //           lfr@50002 : FieldRef;
    //           l_Link@50006 : Text[1024];
    //         BEGIN
    //           lrr_Link.OPEN(DATABASE::"Record Link");
    //           lrr_Link.CURRENTKEYINDEX(2);

    //           lfr := lrr_Link.FIELD(2);
    //           lfr.SETRANGE(pri_Record);

    //           IF p_CompanyFilter = '' THEN
    //             p_CompanyFilter := COMPANYNAME;
    //           lfr := lrr_Link.FIELD(12);
    //           lfr.SETFILTER(p_CompanyFilter);

    //           IF p_DescriptionFilter <> '' THEN BEGIN
    //             lfr := lrr_Link.FIELD(7);
    //             lfr.SETFILTER(p_DescriptionFilter);
    //           END;

    //           IF p_Type > 0 THEN BEGIN
    //             lfr := lrr_Link.FIELD(8);
    //             lfr.SETRANGE(p_Type);
    //           END;

    //           IF p_DateFilter <> '' THEN BEGIN
    //             lfr := lrr_Link.FIELD(10);
    //             lfr.SETFILTER(p_DateFilter);
    //           END;

    //           IF p_UserFilter <> '' THEN BEGIN
    //             lfr := lrr_Link.FIELD(11);
    //             lfr.SETFILTER(p_UserFilter);
    //           END;

    //           IF lrr_Link.FINDSET() THEN BEGIN
    //             REPEAT
    //               l_Link := FORMAT(lrr_Link.FIELD(3).VALUE) + FORMAT(lrr_Link.FIELD(4).VALUE) +
    //                 FORMAT(lrr_Link.FIELD(5).VALUE) + FORMAT(lrr_Link.FIELD(6).VALUE);
    //               lrr_Link.CLOSE;
    //               EXIT(l_Link);
    //             UNTIL lrr_Link.NEXT() = 0;
    //           END;
    //           lrr_Link.CLOSE;
    //           EXIT('');
    //         END;

    //         PROCEDURE GetRecordLink@50000(VAR ptr_Link@50000 : TEMPORARY Record 2000000068;pri_Record@50001 : RecordID;p_CodeFilter@50005 :
    //         VAR
    //           lrr_Link@50003 : RecordRef;
    //           lfr@50002 : FieldRef;
    //           lr_Link@50004 : Record 2000000068;
    //         BEGIN
    //           lrr_Link.OPEN(DATABASE::"Record Link");
    //           lrr_Link.CURRENTKEYINDEX(2);
    //           lfr := lrr_Link.FIELD(2);
    //           lfr.SETRANGE(pri_Record);
    //           IF p_CodeFilter <> '' THEN BEGIN
    //             lfr := lrr_Link.FIELD(50000);
    //             lfr.SETFILTER(p_CodeFilter);
    //           END;
    //           IF p_LanguageFilter <> '' THEN BEGIN
    //             lfr := lrr_Link.FIELD(50001);
    //             lfr.SETFILTER(p_LanguageFilter);
    //           END;
    //           IF lrr_Link.FINDSET() THEN BEGIN
    //             REPEAT
    //               lr_Link.GET(lrr_Link.FIELD(1).VALUE);
    //               ptr_Link.INIT();
    //               ptr_Link := lr_Link;
    //               ptr_Link.insert();
    //             UNTIL lrr_Link.NEXT() = 0;
    //             lrr_Link.CLOSE;
    //             EXIT(TRUE);
    //           END;
    //           lrr_Link.CLOSE;
    //           EXIT(FALSE);
    //         END;

    //         PROCEDURE GetRecordLinkCount@50010(p_TableNo@50003 : Integer;p_Position@50004 : Text[500]) : Integer;
    //         VAR
    //           lrr_Link@50002 : RecordRef;
    //           lrr_Source@50000 : RecordRef;
    //           lfr@50001 : FieldRef;
    //         BEGIN
    //           lrr_Source.OPEN(p_TableNo);
    //           lrr_Source.SETPOSITION(p_Position);
    //           IF NOT lrr_Source.FIND THEN
    //             EXIT(0);

    //           lrr_Link.OPEN(DATABASE::"Record Link");
    //           lrr_Link.CURRENTKEYINDEX(2);
    //           lfr := lrr_Link.FIELD(2);
    //           lfr.SETRANGE(lrr_Source.RECORDID());
    //           lfr := lrr_Link.FIELD(12);
    //           lfr.SETRANGE(COMPANYNAME);
    //           EXIT(lrr_Link.COUNT);
    //         END;

    //         PROCEDURE GetRecordLinkUrl@50001(pri_Record@50002 : RecordID;p_CodeFilter@50001 : Code[200];p_LanguageFilter@50000 : Code[200])
    //         VAR
    //           ltr_Link@50005 : TEMPORARY Record 2000000068;
    //         BEGIN
    //           IF NOT GetRecordLink(ltr_Link,pri_Record,p_CodeFilter,p_LanguageFilter) THEN
    //             EXIT('');
    //           EXIT(ltr_Link.URL1 + ltr_Link.URL2 + ltr_Link.URL3 + ltr_Link.URL4);
    //         END;
    //     */

    // end;

    procedure MailToOldVendor(pr_Vend: Record Vendor)
    var
        lr_Qualitaetssicherung: Record "POI Quality Management";
        lr_Cont: Record Contact;
        l_OldVend: Boolean;
        l_PLZ: Text[10];
        l_Ort: Text[10];
        l_Land: Text[10];
        l_Email: Text[10];
        l_Kreditortyp: Text[20];
        l_Mandant: Text[20];
        l_Send: Boolean;
        LERR_TestfieldCompTxt: Label 'Sie müssen noch\\%1 %2 %3 %4 %5 %6\\ausfüllen.', Comment = '%1 %2 %3 %4 %5 %6';
        LCON_VendDocTxt: Label 'Dokumente:\%1 \wurden schon am %2 per Mail an %3 versandt.\Sollen die Dokumente trotzdem nochmal versandt werden?', Comment = '%1 %2 %3 ';
        LMSG_OldVendDocMailTxt: Label 'Folgende Dokumente:\%1 \sind am %2\per Mail an %3\versandt.', Comment = '%1 %2 %3';
        LCON_OldVendTypeTxt: Label 'Bitte vor Versand in der Kreditorenkarte überprüfen, ob die E-Mailadresse, Kreditorentyp (jeweils im Reiter "Kommunikation" im Unternehmensmandant) korrekt und der richtige Mandant (Kontrolle über Karte "Allgemein", Feld "Erstellt für Mandanten"; Veränderung der Auswahl über "Kreditor" / "Kontakt") ausgewählt sind. ';
    begin
        if GuiAllowed() then
            MESSAGE(LCON_OldVendTypeTxt);

        lr_Qualitaetssicherung.RESET();
        lr_Qualitaetssicherung.SETRANGE("Source Type", lr_Qualitaetssicherung."Source Type"::Vendor);
        lr_Qualitaetssicherung.SETRANGE("Vend-Cust-LFB created", 0DT);
        lr_Qualitaetssicherung.SETRANGE("Reactivate Old Vendor", TRUE);
        IF lr_Qualitaetssicherung.ISEMPTY() THEN
            l_OldVend := TRUE
        ELSE
            l_OldVend := TRUE;

        IF l_OldVend THEN BEGIN

            IF pr_Vend."Post Code" = '' THEN
                l_PLZ := 'PLZ /';
            IF pr_Vend.City = '' THEN
                l_Ort := 'Ort /';
            IF pr_Vend."Country/Region Code" = '' THEN
                l_Land := 'Land /';
            IF pr_Vend."E-Mail" = '' THEN
                l_Email := 'E-Mail /';
            IF NOT (pr_Vend."POI Supplier of Goods") AND NOT (pr_Vend."POI Carrier") AND NOT (pr_Vend."POI Warehouse Keeper")
              AND NOT (pr_Vend."POI Customs Agent") AND NOT (pr_Vend."POI Tax Representative") AND NOT (pr_Vend."POI Diverse Vendor")
              AND NOT (pr_Vend."POI Small Vendor") AND NOT (pr_Vend."POI Shipping Company")
            THEN
                l_Kreditortyp := 'Kreditorentyp /';

            lr_ContBusRel.RESET();
            lr_ContBusRel.SETCURRENTKEY("Link to Table", "Contact No.");
            lr_ContBusRel.SETRANGE("Link to Table", lr_ContBusRel."Link to Table"::Vendor);
            lr_ContBusRel.SETRANGE("No.", pr_Vend."No.");
            IF lr_ContBusRel.FIND('-') THEN
                IF lr_Cont.GET(lr_ContBusRel."Contact No.") THEN
                    if not AccountCompanySetting.OperationCompExists(lr_Cont."No.", AccountCompanySetting."Account Type"::Contact) THEN
                        l_Mandant := 'Mandanten';

            IF (l_PLZ <> '') OR (l_Ort <> '') OR (l_Land <> '') OR (l_Email <> '') OR (l_Kreditortyp <> '') OR (l_Mandant <> '') THEN
                ERROR(LERR_TestfieldCompTxt, l_PLZ, l_Ort, l_Land, l_Email, l_Kreditortyp, l_Mandant);

            //keine Belege wenn PI StammdatenPort und Sonstiger Kreditor
            if AccountCompanySetting.OperationCompExists(lr_Cont."No.", AccountCompanySetting."Account Type"::Contact) then begin
                lr_RelPrintDoc.RESET();
                lr_RelPrintDoc.SETRANGE(Source, lr_RelPrintDoc.Source::Purchase);
                lr_RelPrintDoc.SETFILTER("Print Document Code", '%1|%2|%3', 'Kontakt Neuanlage', 'Kreditor Neuanlage', 'Kunde Neuanlage');
                lr_RelPrintDoc.SETRANGE(Release, TRUE);
                lr_RelPrintDoc.SETRANGE("Kind of Release", lr_RelPrintDoc."Kind of Release"::Mail);
                lr_RelPrintDoc.SETRANGE("Source Type", lr_RelPrintDoc."Source Type"::Contact);
                lr_RelPrintDoc.SETRANGE("Source No.", lr_ContBusRel."Contact No.");
                lr_RelPrintDoc.SETRANGE("Released as Mail", TRUE);
                lr_RelPrintDoc.SETFILTER("Print Description 1", '<>%1', '');
                IF lr_RelPrintDoc.FINDLAST() THEN BEGIN
                    IF lr_RelPrintDoc."E-Mail" = pr_Vend."E-Mail" THEN BEGIN
                        IF GUIALLOWED() THEN
                            IF CONFIRM(LCON_VendDocTxt, FALSE, lr_RelPrintDoc."Print Description 1", lr_RelPrintDoc."Last Date of Mail", lr_RelPrintDoc."E-Mail") THEN BEGIN
                                QSLFBMailOldVendor(DATABASE::Vendor, pr_Vend."No.", pr_Vend."E-Mail", pr_Vend."Language Code", lr_Cont);
                                l_Send := TRUE;
                            END;
                    END ELSE
                        IF GUIALLOWED() THEN
                            IF CONFIRM(LCON_VendDocTxt, FALSE, lr_RelPrintDoc."Print Description 1", lr_RelPrintDoc."Last Date of Mail", lr_RelPrintDoc."E-Mail", pr_Vend."E-Mail") THEN BEGIN
                                QSLFBMailOldVendor(DATABASE::Vendor, pr_Vend."No.", pr_Vend."E-Mail", pr_Vend."Location Code", lr_Cont);
                                l_Send := TRUE;
                            END
                END ELSE BEGIN
                    QSLFBMailOldVendor(DATABASE::Vendor, pr_Vend."No.", pr_Vend."E-Mail", pr_Vend."Language Code", lr_Cont);
                    l_Send := TRUE;
                END;

                IF (l_Send) AND (NOT lr_Cont."POI Small Vendor") THEN BEGIN
                    lr_RelPrintDoc.RESET();
                    lr_RelPrintDoc.SETRANGE(Source, lr_RelPrintDoc.Source::Purchase);
                    lr_RelPrintDoc.SETFILTER("Print Document Code", '%1|%2|%3', 'Kontakt Neuanlage', 'Kreditor Neuanlage', 'Kunde Neuanlage');
                    lr_RelPrintDoc.SETRANGE(Release, TRUE);
                    lr_RelPrintDoc.SETRANGE("Kind of Release", lr_RelPrintDoc."Kind of Release"::Mail);
                    lr_RelPrintDoc.SETRANGE("Source Type", lr_RelPrintDoc."Source Type"::Contact);
                    lr_RelPrintDoc.SETRANGE("Source No.", lr_ContBusRel."Contact No.");
                    lr_RelPrintDoc.SETRANGE("Released as Mail", TRUE);
                    lr_RelPrintDoc.SETFILTER("Print Description 1", '<>%1', '');
                    IF lr_RelPrintDoc.FINDLAST() THEN
                        IF lr_RelPrintDoc."E-Mail" = pr_Vend."E-Mail" THEN
                            IF GUIALLOWED() THEN
                                MESSAGE(LMSG_OldVendDocMailTxt, lr_RelPrintDoc."Print Description 1", lr_RelPrintDoc."Last Date of Mail", lr_RelPrintDoc."E-Mail");
                END;
            END;
        END;

    end;

    procedure QSLFBMailOldVendor(p_TableID: Integer; p_VendCustNo: Code[20]; p_EMail: Text[250]; p_LanguageCode: Code[10]; var pr_Cont: Record Contact)
    var
        lr_Attachment: Record Attachment temporary;
        lr_Cont: Record Contact;
        lr_SalesPurch: Record "Salesperson/Purchaser";
        POICompany: Record "POI Company";
        lc_Mail: Codeunit "SMTP Mail";
        AccsetOpt: enum "POI VendorCustomer";
        Receipients: list of [Text];
        l_BodyLine: Text[1024];
        TXT_Attachment: Text[250];
        TXT_2Attachment: Text[250];
        TXT_3Attachment: Text[250];
        TXT_4Attachment: Text[250];
        l_AttachText1: Text[250];
        l_AttachText2: Text[250];
        l_AttachText3: Text[250];
        l_AttachText4: Text[250];
        l_AttachText5: Text[250];
        l_AttachText6: Text[250];
        l_AttachText7: Text[250];
        l_EntryID: Integer;
        l_Company: Text[250];
        LTXT_SubjectAfterReactiVendTxt: Label 'Altkreditor %1 %2 wurde für %3 zur Aktualisierung der Unterlagen aufgefordert', Comment = '%1 %2 %3';
        LTXT_MailAfterReactivateVendTxt: Label 'Kreditor %1 %2 (für %3) wurde soeben von %4 zur Aktualisierung der Unterlagen aufgefordert. Einkäufer: %5 - Mandant: %6.', Comment = ' %1 %2 %3 %4 %5 %6';
        DocumentNotFoundTxt: label 'Das Dokument:\ %1 \\konnte nicht gefunden werden.', Comment = '%1';
        NoReceiverSenderTxt: label 'Es müssen Sender und Empfänger für Mandatnt %1 angegeben werden.', Comment = '%1 = Mandantenname';
        l_Subject: Text[250];
        l_VendorTyp: Text[100];
        TXT_1Stammdatenblatt: Text[250];
        TXT_2Stammdatenblatt: Text[250];
        TXT_3Stammdatenblatt: Text[250];
        MailSender: Text[100];
        OlVend_Subject: Text[400];

    begin
        IF p_TableID = DATABASE::Vendor THEN BEGIN
            IF lr_Vendor.GET(p_VendCustNo) THEN
                CLEAR(lc_Mail);
            l_Company := AccountCompanySetting.GetCompanyNames(AccsetOpt::Vendor, lr_Vendor."No.");
        END;
        IF lr_SalesPurch.GET(lr_Vendor."Purchaser Code") THEN;

        IF (NOT lr_Cont."POI Small Vendor") THEN BEGIN
            l_Subject := STRSUBSTNO(LTXT_SubjectAfterReactiVendTxt, p_VendCustNo, lr_Vendor.Name, l_Company);
            l_BodyLine := STRSUBSTNO(LTXT_MailAfterReactivateVendTxt, p_VendCustNo, lr_Vendor.Name, l_VendorTyp, UPPERCASE(Userid()), lr_SalesPurch.Name, l_Company);
            // QS Code OLDVENDMAIL

            MailSenderReceiver.SetRange(Type, MailSenderReceiver.Type::Receipient);
            AccountCompanySetting.Reset();
            AccountCompanySetting.SetRange("Account Type", AccsetOpt::Vendor);
            AccountCompanySetting.SetRange("Account No.", lr_Vendor."No.");
            AccountCompanySetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
            if AccountCompanySetting.FindSet() then
                repeat
                    MailSenderReceiver.GetMailSenderReceiver('QS', 'OLDVENDMAILQS', MailSender, Receipients, AccountCompanySetting."Company Name");
                    if (MailSender = '') or (Receipients.Count() = 0) then
                        Error(NoReceiverSenderTxt, AccountCompanySetting."Company Name");
                    lc_mail.CreateMessage('QS', MailSender, Receipients, l_Subject, l_BodyLine);
                    lc_Mail.Send();
                until AccountCompanySetting.Next() = 0;
            //       IF lr_Cont."PI European Sourcing" THEN
            //         lc_Mail.NewMessage('accounting@port-international.com;PIES-Operations;qm-operations@port-international.com' /*An*/,
            //           'julita@port-international.com' /*CC*/,
            //           l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
            //       IF lr_Cont."PI Fruit" THEN
            //         lc_Mail.NewMessage('accounting@port-international.com;PIF-Operations;qm-operations@port-international.com' /*An*/,
            //           'julita@port-international.com' /*CC*/,
            //           l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
            //       IF lr_Cont."PI Dutch Growers" THEN
            //         lc_Mail.NewMessage('accounting@port-international.com;PIDG-Operations;qm-operations@port-international.com' /*An*/,
            //           'julita@port-international.com' /*CC*/,
            //           l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
            //       IF (lr_Cont."PI Organics") OR (lr_Cont."PI Bananas") THEN
            //         lc_Mail.NewMessage('accounting@port-international.com' +
            //           ';VL_Abwicklung_Banane@port-international.com;qm-operations@port-international.com' /*An*/,
            //           'julita@port-international.com' /*CC*/,
            //           l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
        END;

        TXT_AnredeTxt := POITranslation.GetTranslationDescription(0, 'QS', 'ANREDE', p_LanguageCode, 1, 10000);
        TXT_MailtextTxt := POITranslation.GetTranslationDescription(0, 'QS', 'OLDVENDTEXT', p_LanguageCode, 1, 10000);
        TXT_Mailtext1Txt := POITranslation.GetTranslationDescription(0, 'QS', 'OLDVENDTEXT1', p_LanguageCode, 1, 20000);
        TXT_Mailtext2Txt := POITranslation.GetTranslationDescription(0, 'QS', 'OLDVENDTEXT2', p_LanguageCode, 1, 30000);
        TXT_Mailtext3Txt := POITranslation.GetTranslationDescription(0, 'QS', 'OLDVENDTEXT3', p_LanguageCode, 1, 40000);
        TXT_Mailtext4Txt := POITranslation.GetTranslationDescription(0, 'QS', 'OLDVENDTEXT4', p_LanguageCode, 1, 50000);
        TXT_Mailtext5Txt := POITranslation.GetTranslationDescription(0, 'QS', 'OLDVENDTEXT5', p_LanguageCode, 1, 60000);

        l_BodyLine := copystr(TXT_AnredeTxt + '<br>' + TXT_MailtextTxt + '<br>' + TXT_Mailtext1Txt + '<br>' + TXT_Mailtext2Txt + '<br>' + TXT_Mailtext3Txt
            + '<br>' + TXT_Mailtext4Txt + '<br>' + TXT_Mailtext5Txt, 1, 1024);

        lr_Attachment.DELETEALL();
        lr_Attachment.INIT();
        lr_Attachment."No." += 1;

        IF p_TableID = DATABASE::Vendor THEN BEGIN
            //       //Anlage: Kreditorenstammblatt
            IF ((lr_Vendor."POI Supplier of Goods") OR (lr_Vendor."POI Warehouse Keeper")) THEN BEGIN
                TXT_1Stammdatenblatt := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTWL', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_1Stammdatenblatt;
                IF NOT EXISTS(TXT_1Stammdatenblatt) THEN
                    ERROR(DocumentNotFoundTxt, TXT_1Stammdatenblatt);
                lr_Attachment.INSERT();
                l_AttachText1 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText1, '\') > 0 do
                    l_AttachText1 := COPYSTR(l_AttachText1, STRPOS(l_AttachText1, '\') + 1, 250);
            END ELSE
                IF (lr_Vendor."POI Carrier") AND NOT (lr_Vendor."POI Warehouse Keeper") THEN BEGIN
                    TXT_2Stammdatenblatt := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTLOG', p_LanguageCode);
                    lr_Attachment."File Extension" := TXT_2Stammdatenblatt;
                    IF NOT EXISTS(TXT_2Stammdatenblatt) THEN
                        ERROR(DocumentNotFoundTxt, TXT_2Stammdatenblatt);
                    lr_Attachment."No." += 1;
                    lr_Attachment.INSERT();
                    l_AttachText2 := lr_Attachment."File Extension";
                    while STRPOS(l_AttachText2, '\') > 0 do
                        l_AttachText2 := COPYSTR(l_AttachText2, STRPOS(l_AttachText2, '\') + 1, 250);
                END;
            IF ((lr_Vendor."POI Customs Agent") OR (lr_Vendor."POI Tax Representative") OR
              (lr_Vendor."POI Diverse Vendor") OR (lr_Vendor."POI Shipping Company")) AND
              (NOT (lr_Vendor."POI Carrier") AND NOT (lr_Vendor."POI Warehouse Keeper"))
            THEN BEGIN
                TXT_3Stammdatenblatt := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'STAMMDATENBLATTDIV', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_3Stammdatenblatt;
                IF NOT EXISTS(TXT_3Stammdatenblatt) THEN
                    ERROR(DocumentNotFoundTxt, TXT_3Stammdatenblatt);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText3 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText3, '\') > 0 do
                    l_AttachText3 := COPYSTR(l_AttachText3, STRPOS(l_AttachText3, '\') + 1, 250);
            END;
            IF lr_Vendor."POI Supplier of Goods" THEN BEGIN
                TXT_Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'LIEFFRAGEBOGEN', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_Attachment;
                IF NOT EXISTS(TXT_Attachment) THEN
                    ERROR(DocumentNotFoundTxt, TXT_Attachment);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText4 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText4, '\') > 0 do
                    l_AttachText4 := COPYSTR(l_AttachText4, STRPOS(l_AttachText4, '\') + 1, 250);
            END;
            IF lr_Vendor."POI Carrier" THEN BEGIN
                TXT_2Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'ERKLAERUNGLOGISTIK', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_2Attachment;
                IF NOT EXISTS(TXT_2Attachment) THEN
                    ERROR(DocumentNotFoundTxt, TXT_2Attachment);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText5 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText5, '\') > 0 do
                    l_AttachText5 := COPYSTR(l_AttachText5, STRPOS(l_AttachText5, '\') + 1, 250);
            END;
            IF lr_Vendor."POI Warehouse Keeper" THEN BEGIN
                TXT_3Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'ERKLAERUNGLAGER', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_3Attachment;
                IF NOT EXISTS(TXT_3Attachment) THEN
                    ERROR(DocumentNotFoundTxt, TXT_3Attachment);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText6 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText6, '\') > 0 do
                    l_AttachText6 := COPYSTR(l_AttachText6, STRPOS(l_AttachText6, '\') + 1, 250);
            END;
            IF NOT lr_Vendor."POI Small Vendor" THEN BEGIN
                TXT_4Attachment := POIFunction.GetDocumentNameFromAttachmentSetup('100', 'QS', 'ALLGEMEKBEDINGUNGEN', p_LanguageCode);
                lr_Attachment."File Extension" := TXT_4Attachment;
                IF NOT EXISTS(TXT_4Attachment) THEN
                    ERROR(DocumentNotFoundTxt, TXT_4Attachment);
                lr_Attachment."No." += 1;
                lr_Attachment.INSERT();
                l_AttachText7 := lr_Attachment."File Extension";
                while STRPOS(l_AttachText7, '\') > 0 do
                    l_AttachText7 := COPYSTR(l_AttachText7, STRPOS(l_AttachText7, '\') + 1, 250);
            END;

            //Attachments
            if lr_Attachment.FindSet() then
                repeat
                    lc_Mail.AddAttachment(lr_Attachment."File Extension", POIFunction.GetFilename(lr_Attachment."File Extension"));
                until lr_Attachment.Next() = 0;

            IF NOT lr_Vendor."POI Small Vendor" THEN
                IF p_TableID = DATABASE::Vendor THEN BEGIN
                    MailSenderReceiver.GetMailSenderReceiver('QS', 'OLDVENDMAILQSVEND', MailSender, Receipients, AccountCompanySetting."Company Name"); //Interne Empfänger und Sender
                    Receipients.Add(p_EMail); //Lieferanten E-Mail
                    OlVend_Subject := POITranslation.GetTranslationDescription(0, 'QS', 'OLDVENDMAILQSVEND', p_LanguageCode, 1, 10000);
                    OlVend_Subject := StrSubstNo(OlVend_Subject, lr_Vendor."No.");
                    lc_Mail.CreateMessage('QS', MailSender, Receipients, OlVend_Subject, l_BodyLine);
                    lc_Mail.Send();
                    //           CASE p_LanguageCode OF
                    //             'DEU': lc_Mail.NewMessage(p_EMail + ';accounting@port-international.com' /*An*/,
                    //                     'qm-operations@port-international.com' /*CC*/,
                    //                      STRSUBSTNO(LTXT_SubjectDETxt,lr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
                    //                      FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
                    //             'ENU': lc_Mail.NewMessage(p_EMail + ';accounting@port-international.com' /*An*/,
                    //                      'qm-operations@port-international.com' /*CC*/,
                    //                      STRSUBSTNO(LTXT_SubjectEN,lr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
                    //                      FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
                    //             'ESP': lc_Mail.NewMessage(p_EMail + ';accounting@port-international.com' /*An*/,
                    //                      'qm-operations@port-international.com' /*CC*/,
                    //                      STRSUBSTNO(LTXT_SubjectSPTxt,lr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
                    //                      FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
                    //             'PTG': lc_Mail.NewMessage(p_EMail + ';accounting@port-international.com' /*An*/,
                    //                     'qm-operations@port-international.com' /*CC*/,
                    //                      STRSUBSTNO(LTXT_SubjectEN,lr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
                    //                      FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
                    //             '': lc_Mail.NewMessage(p_EMail + ';accounting@port-international.com' /*An*/,
                    //                      'qm-operations@port-international.com' /*CC*/,
                    //                      STRSUBSTNO(LTXT_SubjectDETxt,lr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
                    //                      FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
                    //             ELSE
                    //               lc_Mail.NewMessage(p_EMail + ';accounting@port-international.com' /*An*/,
                    //                      'qm-operations@port-international.com' /*CC*/,
                    //                      STRSUBSTNO(LTXT_SubjectEN,lr_Vendor."No."),l_BodyLine,'' /*l_Attachment*/,
                    //                      FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
                END;

            IF lr_ReleasedPrintDoc.FIND('+') THEN
                l_EntryID := lr_ReleasedPrintDoc."Entry ID" + 1
            ELSE
                l_EntryID := 1;
            lr_ReleasedPrintDoc.Reset();
            lr_ReleasedPrintDoc.INIT();
            lr_ReleasedPrintDoc."Entry ID" := l_EntryID;
            lr_ReleasedPrintDoc."Document Type" := lr_ReleasedPrintDoc."Document Type"::Quote;

            IF p_TableID = DATABASE::Vendor THEN BEGIN
                lr_ReleasedPrintDoc.Source := lr_ReleasedPrintDoc.Source::Purchase;
                lr_ReleasedPrintDoc."Document No." := lr_Cont."No.";
                lr_ReleasedPrintDoc."Detail Code" := COPYSTR(lr_Cont.City, 1, 20);
                lr_ReleasedPrintDoc."Language Code" := p_LanguageCode;
                lr_ReleasedPrintDoc."Consignee No." := lr_Cont."No.";
                lr_ReleasedPrintDoc."Consignee Name" := lr_Cont.Name;
                lr_ReleasedPrintDoc."E-Mail" := p_EMail;
                lr_ReleasedPrintDoc.Subject := copystr(OlVend_Subject, 1, MaxStrLen(lr_ReleasedPrintDoc.Subject));
                // CASE p_LanguageCode OF
                //   'DEU': lr_ReleasedPrintDoc.Subject := STRSUBSTNO(TXT_SubjectDETxt,lr_Vendor."No.");
                //   'ENU': lr_ReleasedPrintDoc.Subject := STRSUBSTNO(TXT_SubjectEN,lr_Vendor."No.");
                //   'ESP': lr_ReleasedPrintDoc.Subject := STRSUBSTNO(TXT_SubjectSPTxt,lr_Vendor."No.");
                //   ''   : lr_ReleasedPrintDoc.Subject := STRSUBSTNO(TXT_SubjectDETxt,lr_Vendor."No.");
                //   ELSE lr_ReleasedPrintDoc.Subject := STRSUBSTNO(TXT_SubjectEN,lr_Vendor."No.");
                // END;

                lr_ReleasedPrintDoc."Source Type" := lr_ReleasedPrintDoc."Source Type"::Contact;
                lr_ReleasedPrintDoc."Source No." := lr_Cont."No.";
                lr_ReleasedPrintDoc."Print Document Description" := 'Dokumente an alt Kreditor';
                lr_ReleasedPrintDocHelp.SETRANGE("Consignee No.", lr_Cont."No.");
                IF lr_ReleasedPrintDocHelp.FIND('+') THEN
                    lr_ReleasedPrintDoc."Nos. Released as Mail" := lr_ReleasedPrintDocHelp."Nos. Released as Mail" + 1;
                lr_ReleasedPrintDoc."Print Document Code" := 'Kontakt Neuanlage';
            END;

            lr_ReleasedPrintDoc.Release := TRUE;
            lr_ReleasedPrintDoc."Kind of Release" := lr_ReleasedPrintDoc."Kind of Release"::Mail;
            lr_ReleasedPrintDoc.Consignee := lr_ReleasedPrintDoc.Consignee::" ";
            lr_ReleasedPrintDoc."Released as Mail" := TRUE;
            lr_ReleasedPrintDoc."Last Date of Mail" := CURRENTDATETIME;

            lr_ReleasedPrintDoc."Print Description 1" := l_AttachText1;
            IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
                IF l_AttachText2 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText2;
            END ELSE
                IF l_AttachText2 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" := l_AttachText2;
            IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
                IF l_AttachText3 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText3;
            END ELSE
                IF l_AttachText3 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" := l_AttachText3;
            IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
                IF l_AttachText4 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText4
            END ELSE
                IF l_AttachText4 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" := l_AttachText4;
            IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
                IF l_AttachText5 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText5
            END ELSE
                IF l_AttachText5 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" := l_AttachText5;
            IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
                IF l_AttachText6 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText6
            END ELSE
                IF l_AttachText6 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" := l_AttachText6;
            IF lr_ReleasedPrintDoc."Print Description 1" <> '' THEN BEGIN
                IF l_AttachText7 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" += '+' + l_AttachText7
            END ELSE
                IF l_AttachText7 <> '' THEN
                    lr_ReleasedPrintDoc."Print Description 1" := l_AttachText7;

            lr_ReleasedPrintDoc."Print Description 2" := '';
            lr_ReleasedPrintDoc."Released Date" := WORKDATE();
            lr_ReleasedPrintDoc."Released Time" := TIME;
            lr_ReleasedPrintDoc."USER ID" := copystr(USERID(), 1, 50);
            IF lr_ReleasedPrintDoc."Transaction ID" = 0 THEN BEGIN
                lr_ReleasedPrintDocHelp.INIT();
                lr_ReleasedPrintDocHelp.Reset();
                lr_ReleasedPrintDocHelp.SETCURRENTKEY("Transaction ID");
                IF lr_ReleasedPrintDocHelp.FIND('+') THEN;
                lr_ReleasedPrintDoc."Transaction ID" := lr_ReleasedPrintDocHelp."Transaction ID" + 1;
            END;
            lr_ReleasedPrintDocHelp.Reset();
            lr_ReleasedPrintDoc.insert();

        END;

    end;

    // procedure JulitaLFBVendCustCheckDate()
    // var
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_ContBusRel: Record "Contact Business Relation";
    //     lr_Contact: Record Contact;
    //     ltr_LFBBuffer: Record "50910" temporary;
    //     ltr_ExcelBuffer: Record "Excel Buffer" temporary;
    //     lr_Vend: Record Vendor;
    //     lr_SalesPurch: Record "Salesperson/Purchaser";
    //     lr_Session: Record Session;
    //     POIFunction: Codeunit POIFunction;
    //     lc_PortSystem: Codeunit "5110798";
    //     lc_Mail: Codeunit Mail;
    //     l_RowNo: Integer;
    //     l_LfdNo: Integer;
    //     l_Company: Text[110];
    //     FileName: Text[250];
    //     l_CRLF: Text[2];
    //     l_Subject: Text[250];
    //     l_BodyLine: Text[1024];
    //     l_VendorTyp: Text[100];
    //     l_Comment: Text[1024];
    //     LTXT_MailAusnahme: Label 'Für den Kreditor';
    //     LTXT_MailAusnahme1: Label 'wird die Ausnahmegenehmigung am';
    //     LTXT_MailAusnahme2: Label 'ablaufen. Beim Ablauf wird der Kreditor von FIBU gesperrt. ';
    //     LTXT_MailAusnahme3: Label 'Bitte bis dahin die fehlenden Punkte erledigen bzw. in Ausnahmefällen befristete Verlängerung beantragen!';
    //     l_GLMail: Text[80];
    //     LTXT_MailAusnahmeEnd1: Label 'ist die Ausnahmegenehmigung am %1';
    //     LTXT_MailAusnahmeEnd2: Label 'abgelaufen. Der Kreditor sollte von FIBU gesperrt werden.';
    //     "-- del": Integer;
    //     cu_mail: Codeunit Mail;
    // begin
    //     //{nur für JW zum testn
    //     /*
    //     //NAS Test
    //      CLEAR(cu_mail);
    //      cu_mail.CreateMessage('','julita@port-international.com','','NAS - SMTP - Test','',TRUE);
    //      cu_mail.AppendBody('Mail aus C60013');
    //      cu_mail.Send;
    //     */

    //     //-POI-JW 31.11.16
    //     IF COMPANYNAME <> 'StammdatenPort' THEN BEGIN
    //       lr_Qualitaetssicherung.CHANGECOMPANY('StammdatenPort');
    //       lr_Vend.CHANGECOMPANY('StammdatenPort');
    //       lr_SalesPurch.CHANGECOMPANY('StammdatenPort');
    //     END;

    //     l_Company := '';
    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Freigabe für Kreditor",TRUE);
    //     lr_Qualitaetssicherung.SETRANGE(Ausnahmegenehmigung,lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt);
    //     IF GUIALLOWED THEN
    //       lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'=%1',CALCDATE('+10T',WORKDATE))
    //     ELSE
    //       lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'=%1',CALCDATE('+10D',WORKDATE));
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         if lr_Vend.GET(lr_Qualitaetssicherung."No.") then
    //           l_Company := POIFunction.SetAccCompSettingNames(lr_Vend."No.",0);

    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Ausnahmeg. erteilt durch");
    //         IF lr_SalesPurch.FIND('-') THEN
    //           l_GLMail := lr_SalesPurch."E-Mail";
    //         IF lr_SalesPurch.GET(lr_Vend."Purchaser Code") THEN;
    //         l_CRLF[1] := 13;
    //         l_CRLF[2] := 10;
    //         CLEAR(lc_Mail);
    //         l_Subject := 'Ablauf der Ausnahmegenehmigung - ' + 'Kreditor ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name +
    //           ' Mandant: ' + l_Company;
    //         l_BodyLine := LTXT_MailAusnahme + ' ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name + ' ' +
    //           LTXT_MailAusnahme1 + ' ' + FORMAT(lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf") + ' ' +
    //           LTXT_MailAusnahme2 + LTXT_MailAusnahme3;

    //         lr_Session.Reset();
    //         lr_Session.SETRANGE("My Session",TRUE);
    //         lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //         lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //         IF lr_Session.FINDFIRST() THEN BEGIN
    //             lc_Mail.NewMessage('julita@port-international.com' /*An*/,'' /*CC*/,
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;

    //     l_Company := '';
    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Freigabe für Kreditor",TRUE);
    //     lr_Qualitaetssicherung.SETRANGE(Ausnahmegenehmigung,lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt);
    //     IF GUIALLOWED THEN
    //       lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'=%1',CALCDATE('+3T',WORKDATE))
    //     ELSE
    //       lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'=%1',CALCDATE('+3D',WORKDATE));
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         if lr_Vend.GET(lr_Qualitaetssicherung."No.") then
    //           l_Company := POIFunction.SetAccCompSettingNames(lr_Vend."No.",0);

    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Ausnahmeg. erteilt durch");
    //         IF lr_SalesPurch.FIND('-') THEN
    //           l_GLMail := lr_SalesPurch."E-Mail";
    //         IF lr_SalesPurch.GET(lr_Vend."Purchaser Code") THEN;
    //         l_CRLF[1] := 13;
    //         l_CRLF[2] := 10;
    //         CLEAR(lc_Mail);
    //         l_Subject := 'Ablauf der Ausnahmegenehmigung - ' + 'Kreditor ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name +
    //           ' Mandant: ' + l_Company;
    //         l_BodyLine := LTXT_MailAusnahme + ' ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name + ' ' +
    //           LTXT_MailAusnahme1 + ' ' + FORMAT(lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf") + ' ' +
    //           LTXT_MailAusnahme2 + LTXT_MailAusnahme3;

    //         lr_Session.Reset();
    //         lr_Session.SETRANGE("My Session",TRUE);
    //         lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //         lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //         IF lr_Session.FINDFIRST() THEN BEGIN
    //             lc_Mail.NewMessage('julita@port-international.com' /*An*/,'' /*CC*/,
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;

    //     l_Company := '';
    //     lr_Qualitaetssicherung.Reset();
    //     lr_Qualitaetssicherung.SETRANGE("Freigabe für Kreditor",TRUE);
    //     lr_Qualitaetssicherung.SETRANGE(Ausnahmegenehmigung,lr_Qualitaetssicherung.Ausnahmegenehmigung::genehmigt);
    //     lr_Qualitaetssicherung.SETFILTER("Ausnahmegenehmigung Ablauf",'<=%1',WORKDATE);
    //     IF lr_Qualitaetssicherung.FINDSET() THEN BEGIN
    //       REPEAT
    //         if lr_Vend.GET(lr_Qualitaetssicherung."No.") then
    //           l_Company := POIFunction.SetAccCompSettingNames(lr_Vend."No.",0);

    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Ausnahmeg. erteilt durch");
    //         IF lr_SalesPurch.FIND('-') THEN
    //           l_GLMail := lr_SalesPurch."E-Mail";
    //         IF lr_SalesPurch.GET(lr_Vend."Purchaser Code") THEN;
    //         l_CRLF[1] := 13;
    //         l_CRLF[2] := 10;
    //         CLEAR(lc_Mail);
    //         l_Subject := 'Ablauf der Ausnahmegenehmigung - ' + 'Kreditor ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name +
    //           ' Mandant: ' + l_Company;
    //         l_BodyLine := l_CRLF + LTXT_MailAusnahme + ' ' + lr_Qualitaetssicherung."No." + ' ' + lr_Vend.Name + ' ' +
    //           STRSUBSTNO(LTXT_MailAusnahmeEnd1,lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf") + ' ' + LTXT_MailAusnahmeEnd2;

    //         lr_Session.Reset();
    //         lr_Session.SETRANGE("My Session",TRUE);
    //         lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //         lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //         IF lr_Session.FINDFIRST() THEN BEGIN
    //             lc_Mail.NewMessage('julita@port-international.com' /*An*/,
    //               '' /*CC*/,
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,TRUE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ );
    //         END;
    //         lr_Qualitaetssicherung.Ausnahmegenehmigung := lr_Qualitaetssicherung.Ausnahmegenehmigung::" ";
    //         lr_Qualitaetssicherung."Ausnahmegenehmigung Erinnerung" := 0D;
    //         lr_Qualitaetssicherung."Ausnahmegenehmigung Ablauf" := 0D;
    //         lr_Qualitaetssicherung.Modify();
    //       UNTIL lr_Qualitaetssicherung.NEXT() = 0;
    //     END;
    //     //}

    // end;

    // procedure JulitaOutlookUebergabeFehler(Company: Text[30])
    // var
    //     lrc_ReleasedPrintDoc: Record "Released Print Documents";
    //     lrc_User: Record "Salesperson/Purchaser";
    //     ltx_MailAddr: Text[80];
    //     ltx_MailAddr2: Text[30];
    //     tab79: Record "Company Information";
    //     cu_mail: Codeunit "SMTP Mail";
    // begin
    //     tab79.CHANGECOMPANY(Company);
    //     tab79.GET();
    //     lrc_ReleasedPrintDoc.CHANGECOMPANY(Company);
    //     lrc_ReleasedPrintDoc.SETFILTER(MailID,'<>%1','');
    //     lrc_ReleasedPrintDoc.SETRANGE("Mailübergabe Outlook bestätigt",FALSE);
    //     lrc_ReleasedPrintDoc.SETRANGE("Kind of Release",lrc_ReleasedPrintDoc."Kind of Release"::Mail);
    //     lrc_ReleasedPrintDoc.SETRANGE(Release,TRUE);
    //     lrc_ReleasedPrintDoc.SETRANGE(EMailBenachrichtigung,FALSE);
    //     IF GUIALLOWED THEN
    //       lrc_ReleasedPrintDoc.SETRANGE("Released Date",CALCDATE('-1T',TODAY),TODAY)
    //     ELSE
    //       lrc_ReleasedPrintDoc.SETRANGE("Released Date",CALCDATE('-1D',TODAY),TODAY);
    //     lrc_ReleasedPrintDoc.SETFILTER("Released Time",'..%1',TIME - 900000);
    //     IF lrc_ReleasedPrintDoc.FINDSET() THEN BEGIN
    //       REPEAT
    //         lrc_User.SETRANGE("Navision User ID Code",lrc_ReleasedPrintDoc."USER ID");
    //         IF lrc_User.FINDFIRST() THEN
    //           ltx_MailAddr := lrc_User."E-Mail";
    //         CLEAR(cu_mail);
    //         IF tab79."Industrial Classification" <> '' THEN
    //           ltx_MailAddr2 := tab79."Industrial Classification"
    //         ELSE
    //           ltx_MailAddr2 := 'XXX';

    //           cu_mail.CreateMessage('','NAVISION-Service@PIES','julita@port-international.com',
    //             'Mailversand-Fehler ' + lrc_ReleasedPrintDoc."Document No." + ' ' +
    //              lrc_ReleasedPrintDoc."Print Document Description" + ' - ' +
    //              tab79."Industrial Classification",'',TRUE);

    //         cu_mail.AppendBody('Die Mail ist in Outlook nicht angekommen, bitte prüfen: <BR><BR>'  +
    //           'Mandant: ' + Company + '<BR>' +
    //           lrc_ReleasedPrintDoc."Print Document Description" + ' ' +
    //           lrc_ReleasedPrintDoc."Document No." + ' ');
    //         cu_mail.AppendBody('Ausgabedatum/Zeit: ' + FORMAT(lrc_ReleasedPrintDoc."Last Date of Mail") + '<BR>');
    //         cu_mail.AppendBody('Betreff: ' + lrc_ReleasedPrintDoc.Subject + '<BR>');
    //         cu_mail.AppendBody('Empfänger: ' + lrc_ReleasedPrintDoc."Consignee Name" + '<BR>');
    //         cu_mail.AppendBody('E-Mail: ' + lrc_ReleasedPrintDoc."E-Mail");
    //         cu_mail.AppendBody('<BR>');
    //         cu_mail.AppendBody('Mail ID: ' + lrc_ReleasedPrintDoc.MailID + '<BR>');
    //         cu_mail.AppendBody(lrc_ReleasedPrintDoc."USER ID");
    //         cu_mail.Send;
    //         lrc_ReleasedPrintDoc.EMailBenachrichtigung := TRUE;
    //         lrc_ReleasedPrintDoc.Modify();
    //       UNTIL lrc_ReleasedPrintDoc.NEXT() = 0;
    //     END;
    // end;

    // procedure "--"()
    // begin
    // end;

    // // procedure ImportGGNCompany()
    // // var
    // //     NASHandler: Codeunit "89353";
    // // begin
    // //     NASHandler.SetSessionChangeNotAllowed(TRUE);
    // //     ImportGGN('PI European Sourcing');
    // //     NASHandler.SetSessionChangeNotAllowed(FALSE);
    // // end;

    // procedure ImportGGN(Company: Text[30])
    // var
    //     GGNBatch: Record "50019";
    //     Batch: Record "5110365";
    //     ExcelBuffer: Record "Excel Buffer" temporary;
    //     CompInfo: Record "Company Information";
    //     ExcelBufferHELP: Record "Excel Buffer" temporary;
    //     Buffer: Record "50910" temporary;
    //     BufferHELP: Record "50910" temporary;
    //     Vend: Record Vendor;
    //     PortSetup: Record "50005";
    //     PurchLine: Record "Purchase Line";
    //     PurchHeader: Record "Purchase Header";
    //     FileSystem: Automation ;
    //     FileRec: Record File;
    //     File: File;
    //     Currpath: Text[1024];
    //     Archivpath: Text[1024];
    //     FileFrom: Text[1024];
    //     FileTo: Text[1024];
    //     Filename: Text[1024];
    //     FileCount: Integer;
    //     FileFail: Integer;
    //     Plausibel: Boolean;
    //     FileRead: Boolean;
    //     Sign: Integer;
    //     NextCol: Integer;
    //     NextRow: Integer;
    //     lfdnr: Integer;
    //     l_Decimal: Decimal;
    //     l_Date: Date;
    //     l_Name: Text[50];
    //     l_BufferGGN: Text[20];
    // begin
    //     CompInfo.CHANGECOMPANY(Company);
    //     GGNBatch.CHANGECOMPANY(Company);
    //     Batch.CHANGECOMPANY(Company);
    //     Vend.CHANGECOMPANY(Company);
    //     PortSetup.CHANGECOMPANY(Company);
    //     ExcelBuffer.CHANGECOMPANY(Company);
    //     ExcelBufferHELP.CHANGECOMPANY(Company);
    //     Buffer.CHANGECOMPANY(Company);
    //     BufferHELP.CHANGECOMPANY(Company);
    //     PurchLine.CHANGECOMPANY(Company);
    //     PurchHeader.CHANGECOMPANY(Company);

    //     CLEARALL;
    //     ExcelBuffer.Reset();
    //     ExcelBuffer.DELETEALL();
    //     Buffer.SETRANGE("User-ID",UserID());
    //     Buffer.DELETEALL();
    //     lfdnr := 1;

    //     PortSetup.GET();
    //     CompInfo.GET();

    //     Currpath := PortSetup."GGN Import Folder" + CompInfo."Industrial Classification" + '\Import';
    //     Archivpath := PortSetup."GGN Import Folder" + CompInfo."Industrial Classification" + '\Archiv';

    //     //TEST jw OK
    //     /*
    //     Currpath := PortSetup."GGN Import Folder" + CompInfo."Industrial Classification" + '\Import';
    //     Archivpath := PortSetup."GGN Import Folder" + CompInfo."Industrial Classification" + '\Archiv';
    //     */
    //     //TEST

    //     CLEAR(FileRec);
    //     FileRec.Reset();
    //     FileRec.SETFILTER(Path,Currpath);
    //     IF FileRec.FIND('-') THEN;
    //     FileRec.SETFILTER(Path,Archivpath);
    //     IF FileRec.FIND('-') THEN;
    //     FileRec.SETFILTER(Path,Currpath);
    //     FileRec.SETRANGE("Is a file",TRUE);
    //     FileRec.SETFILTER(Name,'*@GGN-Request*');
    //     IF FileRec.FIND('-') THEN;
    //     FileCount := FileRec.COUNT;
    //     FileFail := 0;
    //     IF FileRec.FINDSET() THEN BEGIN
    //       REPEAT
    //         //IMPORT
    //         FileRead := FALSE;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.DELETEALL();
    //         CLEAR(ExcelBuffer);
    //         ExcelBufferHELP.Reset();
    //         ExcelBufferHELP.DELETEALL();
    //         CLEAR(ExcelBufferHELP);

    //         Filename := FileRec.Path + '\' + FileRec.Name;
    //         ExcelBuffer.OpenBook(Filename,'GGN Request');
    //         ExcelBuffer.ReadSheet;

    //     //ERROR('File %1',Filename);

    //         ExcelBufferHELP.OpenBook(Filename,'GGN Request');
    //         ExcelBufferHELP.ReadSheet;

    //         //Plausibilitäten
    //         Plausibel := TRUE;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'1');
    //         ExcelBuffer.SETFILTER("Column No.",'9');
    //         IF NOT ExcelBuffer.FIND('-') OR (ExcelBuffer.FIND('-') AND (ExcelBuffer."Cell Value as Text" <> 'GGN')) THEN
    //           Plausibel := FALSE;

    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2|9');
    //         IF NOT ExcelBuffer.FINDSET() THEN
    //           Plausibel := FALSE
    //         ELSE BEGIN
    //           Sign := 1;
    //           NextCol := 2;
    //           NextRow := 2;
    //           REPEAT
    //             //Zuordnung existiert
    //             IF ExcelBuffer."Column No." <> NextCol THEN
    //               Plausibel := FALSE;
    //             NextCol := NextCol + (Sign * 7);
    //             Sign := Sign * (-1);

    //             //Partienr. und GGN in gleicher zeile / Row
    //             IF (ExcelBuffer."Column No." = 9) AND (ExcelBuffer."Row No." <> NextRow) THEN
    //               Plausibel := FALSE;
    //             IF (ExcelBuffer."Column No." = 2) THEN
    //               NextRow := ExcelBuffer."Row No.";

    //             //Werte existieren
    //             IF (ExcelBuffer."Column No." = 1) AND ( NOT Batch.GET(ExcelBuffer."Cell Value as Text")) THEN
    //                 Plausibel := FALSE;
    //             IF (ExcelBuffer."Column No." = 9) AND ( ExcelBuffer."Cell Value as Text" = '') THEN
    //                 Plausibel := FALSE;
    //           UNTIL ExcelBuffer.NEXT() = 0;

    //           IF NextCol = 9 THEN
    //             Plausibel := FALSE;
    //         END;

    //         //Position und GGN eintragen
    //         IF Plausibel THEN BEGIN
    //           ExcelBuffer.Reset();
    //           ExcelBuffer.SETFILTER("Row No.",'>1');
    //           ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //           IF ExcelBuffer.FINDSET() THEN BEGIN
    //             REPEAT
    //               IF ExcelBuffer."Column No." = 2 THEN BEGIN
    //                 GGNBatch.INIT();
    //                 GGNBatch."Batch No." := ExcelBuffer."Cell Value as Text";
    //                 IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) AND (ExcelBuffer."Cell Value as Text" <> '') THEN BEGIN
    //                   GGNBatch.GGN := DELCHR(ExcelBuffer."Cell Value as Text",'=','.');
    //                   GGNBatch.Filename := FileRec.Name;
    //                   IF GGNBatch.INSERT THEN
    //                     FileRead := TRUE;
    //                 END;
    //               END;
    //             UNTIL ExcelBuffer.NEXT() = 0;
    //           END;
    //         END;

    //         IF NOT FileRead THEN
    //          FileFail += 1;

    //         //Buffer mit Werten
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //         IF ExcelBuffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             Buffer.INIT();
    //             Buffer.LineNo := lfdnr;
    //             Buffer."User-ID" := USERID;
    //             Buffer.code30 := 'GGN';
    //             Buffer.code1 := ExcelBuffer."Cell Value as Text"; //Position
    //             IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) AND (ExcelBuffer."Cell Value as Text" <> '') THEN
    //               Buffer.code2 := DELCHR(ExcelBuffer."Cell Value as Text",'=','.'); //GGN
    //             IF Buffer.INSERT THEN
    //               lfdnr += 1;
    //           UNTIL ExcelBuffer.NEXT() = 0;
    //         END;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //         IF ExcelBuffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             ExcelBufferHELP.Reset();
    //             ExcelBufferHELP.SETRANGE("Row No.",ExcelBuffer."Row No.");
    //             ExcelBufferHELP.SETFILTER("Column No.",'1'); //Name
    //             IF ExcelBufferHELP.FINDFIRST() THEN BEGIN
    //               Buffer.Reset();
    //               Buffer.SETRANGE("User-ID",UserID());
    //               Buffer.SETRANGE(code30,'GGN');
    //               Buffer.SETRANGE(code1,ExcelBuffer."Cell Value as Text");
    //               IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) THEN
    //                 l_BufferGGN := DELCHR(ExcelBuffer."Cell Value as Text",'=','.');
    //               Buffer.SETRANGE(code2,l_BufferGGN);
    //               IF Buffer.FINDFIRST() THEN BEGIN
    //                 Buffer.text1 := ExcelBufferHELP."Cell Value as Text"; //Name
    //                 Buffer.Modify();
    //               END;
    //             END;
    //           UNTIL ExcelBuffer.NEXT() = 0;
    //         END;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //         IF ExcelBuffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             ExcelBufferHELP.Reset();
    //             ExcelBufferHELP.SETRANGE("Row No.",ExcelBuffer."Row No.");
    //             ExcelBufferHELP.SETFILTER("Column No.",'3'); //Produkt
    //             IF ExcelBufferHELP.FINDFIRST() THEN BEGIN
    //               Buffer.Reset();
    //               Buffer.SETRANGE("User-ID",UserID());
    //               Buffer.SETRANGE(code30,'GGN');
    //               Buffer.SETRANGE(code1,ExcelBuffer."Cell Value as Text");
    //               IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) THEN
    //                 l_BufferGGN := DELCHR(ExcelBuffer."Cell Value as Text",'=','.');
    //               Buffer.SETRANGE(code2,l_BufferGGN);
    //               IF Buffer.FINDFIRST() THEN BEGIN
    //                 Buffer.text2 := ExcelBufferHELP."Cell Value as Text"; //Produkt
    //                 Buffer.Modify();
    //               END;
    //             END;
    //           UNTIL ExcelBuffer.NEXT() = 0;
    //         END;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //         IF ExcelBuffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             ExcelBufferHELP.Reset();
    //             ExcelBufferHELP.SETRANGE("Row No.",ExcelBuffer."Row No.");
    //             ExcelBufferHELP.SETFILTER("Column No.",'4'); //Einheit
    //             IF ExcelBufferHELP.FINDFIRST() THEN BEGIN
    //               Buffer.Reset();
    //               Buffer.SETRANGE("User-ID",UserID());
    //               Buffer.SETRANGE(code30,'GGN');
    //               Buffer.SETRANGE(code1,ExcelBuffer."Cell Value as Text");
    //               IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) THEN
    //                 l_BufferGGN := DELCHR(ExcelBuffer."Cell Value as Text",'=','.');
    //               Buffer.SETRANGE(code2,l_BufferGGN);
    //               IF Buffer.FINDFIRST() THEN BEGIN
    //                 Buffer.code3 := ExcelBufferHELP."Cell Value as Text"; //Einheit
    //                 Buffer.Modify();
    //               END;
    //             END;
    //           UNTIL ExcelBuffer.NEXT() = 0;
    //         END;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //         IF ExcelBuffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             ExcelBufferHELP.Reset();
    //             ExcelBufferHELP.SETRANGE("Row No.",ExcelBuffer."Row No.");
    //             ExcelBufferHELP.SETFILTER("Column No.",'5'); //Menge
    //             IF ExcelBufferHELP.FINDFIRST() THEN BEGIN
    //               Buffer.Reset();
    //               Buffer.SETRANGE("User-ID",UserID());
    //               Buffer.SETRANGE(code30,'GGN');
    //               Buffer.SETRANGE(code1,ExcelBuffer."Cell Value as Text");
    //               IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) THEN
    //                 l_BufferGGN := DELCHR(ExcelBuffer."Cell Value as Text",'=','.');
    //               Buffer.SETRANGE(code2,l_BufferGGN);
    //               IF Buffer.FINDFIRST() THEN BEGIN
    //                 IF EVALUATE(l_Decimal,ExcelBufferHELP."Cell Value as Text") THEN BEGIN
    //                   Buffer.decimal1 := l_Decimal; //Menge
    //                   Buffer.Modify();
    //                 END;
    //               END;
    //             END;
    //           UNTIL ExcelBuffer.NEXT() = 0;
    //         END;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //         IF ExcelBuffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             ExcelBufferHELP.Reset();
    //             ExcelBufferHELP.SETRANGE("Row No.",ExcelBuffer."Row No.");
    //             ExcelBufferHELP.SETFILTER("Column No.",'6'); //Abgangsdatum
    //             IF ExcelBufferHELP.FINDFIRST() THEN BEGIN
    //               Buffer.Reset();
    //               Buffer.SETRANGE("User-ID",UserID());
    //               Buffer.SETRANGE(code30,'GGN');
    //               Buffer.SETRANGE(code1,ExcelBuffer."Cell Value as Text");
    //               IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) THEN
    //                 l_BufferGGN := DELCHR(ExcelBuffer."Cell Value as Text",'=','.');
    //               Buffer.SETRANGE(code2,l_BufferGGN);
    //               IF Buffer.FINDFIRST() THEN BEGIN
    //                 IF EVALUATE(l_Date,ExcelBufferHELP."Cell Value as Text") THEN BEGIN
    //                   Buffer.date1 := l_Date; //Abgangsdatum
    //                   Buffer.Modify();
    //                 END;
    //               END;
    //             END;
    //           UNTIL ExcelBuffer.NEXT() = 0;
    //         END;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //         IF ExcelBuffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             ExcelBufferHELP.Reset();
    //             ExcelBufferHELP.SETRANGE("Row No.",ExcelBuffer."Row No.");
    //             ExcelBufferHELP.SETFILTER("Column No.",'7'); //Ihre Referenz
    //             IF ExcelBufferHELP.FINDFIRST() THEN BEGIN
    //               Buffer.Reset();
    //               Buffer.SETRANGE("User-ID",UserID());
    //               Buffer.SETRANGE(code30,'GGN');
    //               Buffer.SETRANGE(code1,ExcelBuffer."Cell Value as Text");
    //               IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) THEN
    //                 l_BufferGGN := DELCHR(ExcelBuffer."Cell Value as Text",'=','.');
    //               Buffer.SETRANGE(code2,l_BufferGGN);
    //               IF Buffer.FINDFIRST() THEN BEGIN
    //                 Buffer.text3 := ExcelBufferHELP."Cell Value as Text"; //Ihre Referenz
    //                 Buffer.Modify();
    //               END;
    //             END;
    //           UNTIL ExcelBuffer.NEXT() = 0;
    //         END;
    //         ExcelBuffer.Reset();
    //         ExcelBuffer.SETFILTER("Row No.",'>1');
    //         ExcelBuffer.SETFILTER("Column No.",'2');  //Position
    //         IF ExcelBuffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             ExcelBufferHELP.Reset();
    //             ExcelBufferHELP.SETRANGE("Row No.",ExcelBuffer."Row No.");
    //             ExcelBufferHELP.SETFILTER("Column No.",'8'); //Lot-nr.
    //             IF ExcelBufferHELP.FINDFIRST() THEN BEGIN
    //               Buffer.Reset();
    //               Buffer.SETRANGE("User-ID",UserID());
    //               Buffer.SETRANGE(code30,'GGN');
    //               Buffer.SETRANGE(code1,ExcelBuffer."Cell Value as Text");
    //               IF ExcelBuffer.GET(ExcelBuffer."Row No.",9) THEN
    //                 l_BufferGGN := DELCHR(ExcelBuffer."Cell Value as Text",'=','.');
    //               Buffer.SETRANGE(code2,l_BufferGGN);
    //               IF Buffer.FINDFIRST() THEN BEGIN
    //                 Buffer.code4 := ExcelBufferHELP."Cell Value as Text"; //Lot-nr.
    //                 Buffer.Modify();
    //               END;
    //             END;
    //           UNTIL ExcelBuffer.NEXT() = 0;
    //         END;

    //         lfdnr := 1;
    //         BufferHELP.SETRANGE("User-ID",UserID());
    //         BufferHELP.DELETEALL();
    //         Vend.Reset();
    //         IF Vend.FINDSET() THEN BEGIN
    //           REPEAT
    //             BufferHELP.INIT();
    //             BufferHELP.LineNo := lfdnr;
    //             BufferHELP."User-ID" := USERID;
    //             BufferHELP.code30 := 'GGN';
    //             BufferHELP.code1 := Vend."No.";
    //             BufferHELP.text1 := UPPERCASE(Vend.Name);
    //             IF BufferHELP.INSERT THEN
    //               lfdnr += 1;
    //           UNTIL Vend.NEXT() = 0;
    //         END;

    //         Buffer.Reset();
    //         Buffer.SETRANGE("User-ID",UserID());
    //         Buffer.SETRANGE(code30,'GGN');
    //         IF Buffer.FINDSET() THEN BEGIN
    //           REPEAT
    //             GGNBatch.Reset();
    //             GGNBatch.SETRANGE("Batch No.",Buffer.code1);
    //             GGNBatch.SETRANGE(GGN,Buffer.code2);
    //             IF GGNBatch.FINDFIRST() THEN BEGIN
    //               GGNBatch."Created Date Time" := CURRENTDATETIME;
    //               GGNBatch."Created By User" := USERID;
    //               GGNBatch."Vendor Name" := Buffer.text1;

    //               BufferHELP.Reset();
    //               BufferHELP.SETRANGE(text1,Buffer.text1);
    //               IF BufferHELP.FINDFIRST() THEN
    //                 GGNBatch."Vendor No." := BufferHELP.code1
    //               ELSE
    //                 GGNBatch."Vendor No." := '';
    //               GGNBatch."Item Description" := Buffer.text2;
    //               GGNBatch.Quantity := Buffer.decimal1;
    //               GGNBatch."Unit Of Measure Code" := Buffer.code3;
    //               GGNBatch."Departure Date" := Buffer.date1;
    //               GGNBatch."Your Reference" := Buffer.text3;
    //               GGNBatch."Lot No." := Buffer.code4;
    //               GGNBatch."Lot No." := Buffer.code4;
    //               PurchLine.Reset();
    //               PurchLine.SETRANGE("Batch Variant No.",GGNBatch."Batch No.");
    //               IF PurchLine.FINDFIRST() THEN BEGIN
    //                 GGNBatch."Location Code" := PurchLine."Location Code";
    //                 IF PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.") THEN
    //                   GGNBatch."Departure Location Code" := PurchHeader."Departure Location Code";
    //               END;
    //               GGNBatch.Modify();
    //             END;
    //           UNTIL Buffer.NEXT() = 0;
    //         END;

    //         //verschieben
    //         IF FileRead THEN BEGIN
    //           CLEAR(FileSystem);
    //           CREATE(FileSystem);
    //           FileFrom := Currpath + '\' + FileRec.Name;
    //           FileTo   := Archivpath + '\' + FileRec.Name;
    //           FileSystem.MoveFile(FileFrom,FileTo);
    //         END;

    //       UNTIL FileRec.NEXT() = 0;
    //     END;
    //     /*
    //     IF GUIALLOWED THEN
    //       MESSAGE('%1 von %2 Dateien importiert.',FileCount - FileFail,FileCount);
    //     */

    // end;

    // procedure MailFromBlockedALT(p_CustVendNo: Code[20];p_Blocked: Option " ",Payment,All)
    // var
    //     lr_Vendor: Record Vendor;
    //     lr_SalesPurch: Record "Salesperson/Purchaser";
    //     lr_Qualitaetssicherung: Record "Quality Management";
    //     lr_Session: Record Session;
    //     lc_Mail: Codeunit Mail;
    //     l_Subject: Text[100];
    //     l_BodyLine: Text[1024];
    //     l_CRLF: Text[2];
    //     l_VendUser: Text[80];
    //     l_Requester: Text[80];
    //     l_Purchaser: Text[80];
    // begin
    //     //POI-JW 06.03.18
    //     l_Subject := '';
    //     l_BodyLine := '';
    //     l_CRLF[1] := 13;
    //     l_CRLF[2] := 10;
    //     l_VendUser := '';
    //     l_Requester := '';
    //     l_Purchaser := '';

    //     IF lr_Vendor.GET(p_CustVendNo) THEN BEGIN
    //       CLEAR(lc_Mail);
    //       IF p_Blocked = p_Blocked::" " THEN BEGIN
    //         l_Subject := 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' freigegeben';
    //         l_BodyLine := l_CRLF + l_CRLF + 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' wurde von FIBU freigegeben.'
    //       END ELSE IF p_Blocked = p_Blocked::Payment THEN BEGIN
    //         l_Subject := 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' für Zahlung gesperrt';
    //         l_BodyLine := l_CRLF + l_CRLF + 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name +
    //           ' wurde von FIBU für Zahlung gesperrt.'
    //       END ELSE IF p_Blocked = p_Blocked::All THEN BEGIN
    //         l_Subject := 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' gesperrt';
    //         l_BodyLine := l_CRLF + l_CRLF + 'Kreditor ' + lr_Vendor."No." + ' ' + lr_Vendor.Name + ' wurde von FIBU gesperrt.';
    //       END;
    //       IF lr_Vendor."Last User ID Modified" <> '' THEN BEGIN
    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Vendor."Last User ID Modified");
    //         lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //         IF lr_SalesPurch.FINDFIRST() THEN
    //           l_VendUser := lr_SalesPurch."E-Mail";
    //       END;
    //       IF lr_SalesPurch.GET(lr_Vendor."Purchaser Code") THEN
    //         l_Purchaser := lr_SalesPurch."E-Mail";
    //       IF lr_Qualitaetssicherung.GET(p_CustVendNo,lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
    //         IF lr_Qualitaetssicherung."Anforderung an GL User ID" <> '' THEN BEGIN
    //           lr_SalesPurch.Reset();
    //           lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Anforderung an GL User ID");
    //           lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //           IF lr_SalesPurch.FINDFIRST() THEN
    //             l_Requester := lr_SalesPurch."E-Mail";
    //         END;
    //       END;

    //       IF lr_Vendor."Last User ID Modified" <> '' THEN BEGIN
    //         lr_SalesPurch.Reset();
    //         lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Vendor."Last User ID Modified");
    //         lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //         IF lr_SalesPurch.FINDFIRST() THEN
    //           l_VendUser := lr_SalesPurch."E-Mail";
    //       END;
    //       IF lr_SalesPurch.GET(lr_Vendor."Purchaser Code") THEN
    //         l_Purchaser := lr_SalesPurch."E-Mail";
    //       IF lr_Qualitaetssicherung.GET(p_CustVendNo,lr_Qualitaetssicherung."Source Type"::Vendor) THEN BEGIN
    //         IF lr_Qualitaetssicherung."Anforderung an GL User ID" <> '' THEN BEGIN
    //           lr_SalesPurch.Reset();
    //           lr_SalesPurch.SETRANGE("Navision User ID Code",lr_Qualitaetssicherung."Anforderung an GL User ID");
    //           lr_SalesPurch.SETFILTER("E-Mail",'<>%1','');
    //           IF lr_SalesPurch.FINDFIRST() THEN
    //             l_Requester := lr_SalesPurch."E-Mail";
    //         END;
    //       END;

    //       lr_Session.Reset();
    //       lr_Session.SETRANGE("My Session",TRUE);
    //       lr_Session.SETFILTER("Database Name",'=%1','NAVISION');
    //       lr_Session.SETRANGE("Application Name",'Microsoft Dynamics NAV Classic client');
    //       IF lr_Session.FINDFIRST() THEN BEGIN
    //         IF (l_VendUser <> '') OR (l_Purchaser <> '') THEN BEGIN
    //           IF l_VendUser = l_Purchaser THEN
    //             lc_Mail.NewMessage(l_VendUser /*An*/,'qm-operations@port-international.com;julita@port-international.com' /*CC*/,
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //           ELSE
    //             lc_Mail.NewMessage((l_VendUser + ';' + l_Purchaser) /*An*/,
    //               'qm-operations@port-international.com;julita@port-international.com' /*CC*/,
    //               l_Subject,l_BodyLine,'' /*l_Attachment*/,FALSE /*TRUE -> soll Outlook vor dem Senden gestartert werden*/ )
    //         END;
    //       END;
    //     END;


    // end;

    procedure CombineText(var ActualText: Text[250]; InText: Text[250])
    begin
        if ActualText <> '' then begin
            if InText <> '' then
                if (250 - StrLen(ActualText)) >= StrLen('+' + InText) then
                    ActualText += '+' + InText
        end else
            if InText <> '' then
                ActualText := InText;
    end;

    procedure GetKreditorTypeNames(): Text[250]
    var
        l_vendorType: Text[250];
    begin
        IF lr_Vendor."POI Supplier of Goods" THEN
            AddVendorDeli(l_VendorType, 'Warenlieferant');
        IF lr_Vendor."POI Carrier" THEN
            AddVendorDeli(l_VendorType, 'Transporteur');
        IF lr_Vendor."POI Warehouse Keeper" THEN
            AddVendorDeli(l_VendorType, 'Lager / Packer / Reifer');
        IF lr_Vendor."POI Customs Agent" THEN
            AddVendorDeli(l_VendorType, 'Zollagent');
        IF lr_Vendor."POI Tax Representative" THEN
            AddVendorDeli(l_VendorType, 'Fiskalvertreter');
        IF lr_Vendor."POI Diverse Vendor" THEN
            AddVendorDeli(l_VendorType, 'Sonstiger Kreditor');
        IF lr_Vendor."POI Shipping Company" THEN
            AddVendorDeli(l_VendorType, 'Reederei');
        if lr_Vendor."POI Air freight" then
            AddVendorDeli(l_VendorType, 'Luftfracht');
        IF lr_Vendor."POI Small Vendor" THEN
            AddVendorDeli(l_VendorType, 'Kleinlieferant Sachkosten-nur PI (max. 1000 EUR)');
    end;

    procedure AddVendorDeli(var VendorType: Text[250]; NewText: Text[50])
    begin
        if VendorType <> '' then
            VendorType += '|';
        VendorType += NewText;
    end;

    var
        POITranslation: Record "POI Translations";
        lr_Vendor: Record Vendor;
        lr_ReleasedPrintDocHelp: Record "POI Released Print Documents";
        lr_ContBusRel: Record "Contact Business Relation";
        lr_ConBusRel: Record "Contact Business Relation";
        lr_RelPrintDoc: Record "POI Released Print Documents";
        Cust: Record Customer;
        lr_ReleasedPrintDoc: Record "POI Released Print Documents";
        MailSenderReceiver: Record "POI Mail Setup";
        AccountCompanySetting: Record "POI Account Company Setting";
        // gr_NoSeriesCompany: Record "No. Series";
        // gr_LastNoSeriesLineCompany: Record "No. Series Line";
        // gc_NoSeriesMgt: Codeunit NoSeriesManagement;
        POIFunction: Codeunit POIFunction;
        TXT_Subject: Text[400];
        SubjectTxt: text[400];
        // ERR_LEHTxt: Label 'LEH-Spezifikation ist im Lieferant %1 und Kunde %2 unterschiedlich.\Die Verkaufszeile kann nicht estellt werden.';
        // ERR_BioTxt: Label 'Bio Anforderung ist im Lieferant %1 und Kunde %2 unterschiedlich.\Die Verkaufszeile kann nicht estellt werden.';
        // ERR_FairTradeTxt: Label 'Fair Trade Anforderung ist im Lieferant %1 und Kunde %2 unterschiedlich.\Die Verkaufszeile kann nicht estellt werden.';
        // ERR_GRASPTxt: Label 'GRASP Anforderung ist im Lieferant %1 und Kunde %2 unterschiedlich.\Die Verkaufszeile kann nicht estellt werden.';
        // ERR_SA8000Txt: Label 'SA 8000 Anforderung ist im Lieferant %1 und Kunde %2 unterschiedlich.\Die Verkaufszeile kann nicht estellt werden.';
        // ERR_BSCITxt: Label 'BSCI Anforderung ist im Lieferant %1 und Kunde %2 unterschiedlich.\Die Verkaufszeile kann nicht estellt werden.';
        // ERR_RFATxt: Label 'RFA Anforderung ist im Lieferant %1 und Kunde %2 unterschiedlich.\Die Verkaufszeile kann nicht estellt werden.';
        // ERR_LFBDebitorTxt: Label 'Kundenanforderungen für den Debitor %1 ist noch nicht angelegt.';
        // ERR_LFBKreditorTxt: Label 'Lieferantenanforderungen für den Kreditor %1 ist noch nicht angelegt.';
        // ERR_DebitorNotExistTxt: Label 'LFB - Debitor nicht vorhanden.\Bitte an QS wenden.';
        // ERR_KreditorNotExistTxt: Label 'Lieferantenanforderungen - Kreditor nicht vorhanden.\Bitte an QS wenden.';
        // MSG_KeineAblaufdatenTxt: Label 'Aktuell gibt es zur Qualitätssicherung Lieferant keine Ablaufdaten.';
        // TXT_SubjectMailAfterCreateVendTxt: Label 'Neuer Kreditor %1 %2 wurde erstellt';
        // TXT_MailAfterCreateVendTxt: Label 'Kreditor %1 %2 (für %3) wurde soeben von %4 erstellt. Mandant: %5';
        // ERR_CustFolderFailTxt: Label 'Der Ordner für Debitor %1 wurde noch nicht erstellt.';
        // ERR_VendFolderFailTxt: Label 'Der Ordner für Kreditor %1 wurde noch nicht erstellt.';
        // ERR_CreateFileTxt: Label 'Datei %1 konnte nicht erstellt werden.';
        // TXT_ExplorerVendTxt: Label 'explorer \\port-data-01\lwp\0_Kreditoren';
        // TXT_ExplorerCustTxt: Label 'explorer \\port-data-01\lwp\1_Debitoren';
        // TXT_VendFolderTxt: Label '\\port-data-01\lwp\0_Kreditoren\';
        // g_NoSeriesCode: Code[10];
        // g_WarningNoSeriesCode: Code[10];
        // g_TryNoSeriesCode: Code[10];
        TXT_AnredeTxt: Text;
        TXT_MailTextTxt: Text;
        TXT_MailText1Txt: Text[400];
        TXT_MailText2Txt: Text[400];
        TXT_MailText3Txt: Text[400];
        TXT_MailText4Txt: Text[400];
        TXT_MailText5Txt: Text[400];

}

