table 50906 "POI Quality Management"
{
    DrillDownPageId = "POI Account Check List";
    LookupPageId = "POI Account Check List";
    DataPerCompany = false;

    Caption = 'Quality Management';
    DataCaptionFields = "No.", "Source Type";
    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Nr.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "No." <> '' then
                    case "Source Type" of
                        "Source Type"::Vendor:
                            begin
                                Vendor.Get("No.");
                                Name := Vendor.Name;
                            end;
                        "Source Type"::Customer:
                            begin
                                Customer.Get("No.");
                                Name := Customer.Name;
                            end;
                    end;
            end;
        }
        field(2; "Source Type"; enum "POI Source Type")
        {
            Caption = 'Herkunft Typ';
            DataClassification = CustomerContent;
        }
        field(3; "Vend-Cust-LFB created"; DateTime)
        {
            Caption = 'Neu Kreditor-Debitor-LFB Erstelldatum';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(10; "Authentizität bekannt"; Boolean)
        {
            Caption = 'Authentizität Vend-Cust bekannt';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 10, 1) then
                    ERROR(ERR_NoPermissionTxt);

                IF ("Authentizität bekannt" = FALSE) THEN BEGIN
                    "Verifikation Adresse" := "Verifikation Adresse"::"nicht erfolgt";
                    VerifikationGeschäftstätigkeit := VerifikationGeschäftstätigkeit::"nicht erfolgt";
                    Verifikationsanruf := Verifikationsanruf::"nicht erfolgt";
                END ELSE BEGIN
                    IF "Verifikation Adresse" = "Verifikation Adresse"::"nicht erfolgt" THEN
                        "Verifikation Adresse" := "Verifikation Adresse"::verzichtet;
                    IF VerifikationGeschäftstätigkeit = VerifikationGeschäftstätigkeit::"nicht erfolgt" THEN
                        VerifikationGeschäftstätigkeit := VerifikationGeschäftstätigkeit::verzichtet;
                    IF Verifikationsanruf = Verifikationsanruf::"nicht erfolgt" THEN
                        Verifikationsanruf := Verifikationsanruf::verzichtet;
                END;
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Authentizität bekannt"), "Authentizität bekannt", true);
            end;
        }
        field(11; "Verifikation Adresse"; Option)
        {
            Caption = 'Verifikation der Adresse (inkl. Ausdruck)';
            OptionCaption = 'nicht erfolgt,erfolgt,verzichtet,Reaktivierung';
            OptionMembers = "nicht erfolgt",erfolgt,verzichtet,Reaktivierung;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 11, 2) then
                    ERROR(ERR_NoPermissionTxt);
                //CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Verifikation Adresse"), "Verifikation Adresse", true);
            end;
        }
        field(12; "VerifikationGeschäftstätigkeit"; Option)
        {
            Caption = 'Verifikation der Geschäftstätigkeit (inkl. Ausdruck)';
            OptionCaption = 'nicht erfolgt,erfolgt,verzichtet,Reaktivierung';
            OptionMembers = "nicht erfolgt",erfolgt,verzichtet,Reaktivierung;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 12, 2) then
                    ERROR(ERR_NoPermissionTxt);
                //CheckLFB();
                CheckWorkflowTask(50906, FieldNo("VerifikationGeschäftstätigkeit"), "VerifikationGeschäftstätigkeit", true);
            end;
        }
        field(13; Verifikationsanruf; Option)
        {
            Caption = 'Verifikationsanruf beim Lieferanten';
            OptionCaption = 'nicht erfolgt,erfolgt,verzichtet,Reaktivierung';
            OptionMembers = "nicht erfolgt",erfolgt,verzichtet,Reaktivierung;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 13, 2) then
                    ERROR(ERR_NoPermissionTxt);
                //CheckLFB();
                CheckWorkflowTask(50906, FieldNo(Verifikationsanruf), Verifikationsanruf, true);
            end;
        }
        field(14; "Vorkasse erwünscht"; Boolean)
        {
            Caption = 'Vorkasse erwünscht / Rückforderungsansprüche  erwartet?';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //POIFunc.CheckPermission(50906,14,1);
                IF NOT POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('ABW_CUSTVERIFIKAT_W', 0) THEN
                        IF NOT POIFunc.CheckUserInRole('HA_VENDVERIFIKAT_W', 0) THEN
                            IF NOT POIFunc.CheckUserInRole('HA_CUSTVERIFIKAT_W', 0) THEN
                                IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                                    IF NOT POIFunc.CheckUserInRole('FB_CUSTVERIFIKAT_W', 0) THEN
                                        ERROR(ERR_NoPermissionTxt);
                IF NOT "Vorkasse erwünscht" THEN BEGIN
                    Kreditversicherungslimit := FALSE;
                    "Gewünschtes Kreditlimit" := 0;
                    IF lr_Vendor.GET("No.") THEN BEGIN
                        lr_Vendor."POI credit limit" := "Gewünschtes Kreditlimit";
                        lr_Vendor.MODIFY();
                    END;
                END ELSE
                    Kreditversicherungslimit := TRUE;
            end;
        }
        field(16; "Gewünschtes Kreditlimit"; Decimal)
        {
            Caption = 'Gewünschtes Kreditlimit';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //POIFunc.CheckPermission(50906, 16, 1);
                IF NOT POIFunc.UserInWindowsRole('ABW_VENDVERIFIKAT_W ' + '|' + ' ABW_CUSTVERIFIKAT_W ' + '|' + ' FB_VENDVERIFIKAT_W ' + '|' + ' FB_CUSTVERIFIKAT_W '
                  + '|' + ' HA_VENDVERIFIKAT_W ' + '|' + ' HA_CUSTVERIFIKAT_W ') THEN
                    ERROR(ERR_NoPermissionTxt);
                IF lr_Vendor.GET("No.") THEN BEGIN
                    lr_Vendor."POI Prepaymt requested Status" := lr_Vendor."POI Prepaymt requested Status"::"applied for";
                    lr_Vendor."POI credit limit" := "Gewünschtes Kreditlimit";
                    lr_Vendor.MODIFY();
                END;
                if "Gewünschtes Kreditlimit" > 0 then begin
                    "Vorkasse erwünscht" := true;
                    CheckWorkflowTask(50906, FieldNo("Gewünschtes Kreditlimit"), "Gewünschtes Kreditlimit", true);
                end;
            end;
        }
        field(17; "Prepayment requested Status"; Option)
        {
            Caption = 'Vorkasse erwünscht Status';
            OptionCaption = ' ,beantragt,genehmigt,teilgenehmigt,abgelehnt,internes Limit';
            OptionMembers = " ",beantragt,genehmigt,teilgenehmigt,abgelehnt,"internes Limit";
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //POIFunc.CheckPermission(50906,17,1);
                IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W' + '|' + 'FB_CUSTVERIFIKAT_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);
                IF ("Prepayment requested Status" = "Prepayment requested Status"::" ")
                THEN
                    "Gewünschtes Kreditlimit" := 0;

                IF lr_Vendor.GET("No.") THEN BEGIN
                    lr_Vendor."POI Prepaymt requested Status" := "Prepayment requested Status";
                    lr_Vendor."POI credit limit" := "Gewünschtes Kreditlimit";
                    lr_Vendor.MODIFY();
                END;

                IF "Prepayment requested Status" = "Prepayment requested Status"::abgelehnt THEN
                    IF "Internes Kreditlimit" <> 0 THEN BEGIN
                        IF GUIALLOWED() THEN
                            IF CONFIRM(CON_InternTxt, FALSE) THEN BEGIN
                                "Gewünschtes Kreditlimit" := "Internes Kreditlimit";
                                lr_Vendor."POI credit limit" := 0;
                                lr_Vendor.MODIFY();
                            END ELSE BEGIN
                                "Gewünschtes Kreditlimit" := 0;
                                "Internes Kreditlimit" := 0;
                                lr_Vendor."POI credit limit" := 0;
                                lr_Vendor."POI Internal credit limit" := 0;
                                lr_Vendor.MODIFY();
                            END;
                    END ELSE BEGIN
                        "Gewünschtes Kreditlimit" := 0;
                        "Internes Kreditlimit" := 0;
                        lr_Vendor."POI credit limit" := 0;
                        lr_Vendor."POI Internal credit limit" := 0;
                        lr_Vendor.MODIFY();
                    END;
                "Kreditversich.Limit UserID" := copystr(USERID(), 1, 50);
            end;
        }
        field(18; "Internes Kreditlimit"; Decimal)
        {
            Caption = 'Internes Kreditlimit';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                //POIFunc.CheckPermission(50906,18,1);
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);

                IF ("Internes Kreditlimit" < 1000) THEN
                    ERROR(ERR_InternKreditTxt)
                ELSE
                    IF ("Internes Kreditlimit" >= 10000) THEN
                        "Credit limit int. valid until" := CALCDATE('< +2M >', WORKDATE());

                IF lr_Vendor.GET("No.") THEN BEGIN
                    lr_Vendor."POI Internal credit limit" := "Internes Kreditlimit";
                    lr_Vendor."POI Cred. limit int. val.until" := CALCDATE('< +2M >', WORKDATE());
                    IF "Internes Kreditlimit" > 50000 THEN
                        IF GUIALLOWED() THEN
                            IF NOT CONFIRM(CON_KreditInternTxt, FALSE) THEN BEGIN
                                "Internes Kreditlimit" := xRec."Internes Kreditlimit";
                                lr_Vendor."POI Internal credit limit" := "Internes Kreditlimit";
                                lr_Vendor.MODIFY();
                            END;
                end;
            end;
        }
        field(20; "Vorliegen von CMR"; Boolean)
        {
            Caption = 'Spediteur - Vorliegen CMR-Versicherungspolice liegt vor';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 20, 2) then
                    ERROR(ERR_NoPermissionTxt);
                CheckWorkflowTask(50906, FieldNo("Vorliegen von CMR"), "Vorliegen von CMR", true);
            end;
        }
        field(50; "Freigabe für Kreditor"; Boolean)
        {
            Caption = 'Freigabe für Kreditor';
            DataClassification = CustomerContent;
        }
        field(52; "LFB Version"; Text[250])
        {
            Caption = 'LFB Version';
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                IF "Source Type" = "Source Type"::Vendor THEN BEGIN
                    lr_ContBusRel.RESET();
                    lr_ContBusRel.SETRANGE("No.", "No.");
                    IF lr_ContBusRel.FINDFIRST() THEN BEGIN
                        lr_RelPrintDoc.RESET();
                        lr_RelPrintDoc.FILTERGROUP(2);
                        lr_RelPrintDoc.SETRANGE(Source, lr_RelPrintDoc.Source::Purchase);
                        lr_RelPrintDoc.SETRANGE("Print Document Code", 'KONTAKT NEUANLAGE');
                        lr_RelPrintDoc.SETRANGE(Release, TRUE);
                        lr_RelPrintDoc.SETRANGE("Kind of Release", lr_RelPrintDoc."Kind of Release"::Mail);
                        lr_RelPrintDoc.SETRANGE("Consignee No.", lr_ContBusRel."Contact No.");
                        lr_RelPrintDoc.SETRANGE("Released as Mail", TRUE);
                        lr_RelPrintDoc.SETFILTER("Print Description 1", '<>%1', '');
                        lr_RelPrintDoc.FILTERGROUP(0);
                        IF lr_RelPrintDoc.FINDSET() THEN
                            Page.RUN(Page::"POI Released Print Documents", lr_RelPrintDoc);
                    END;
                END ELSE
                    IF "Source Type" = "Source Type"::Customer THEN BEGIN
                        lr_ContBusRel.RESET();
                        lr_ContBusRel.SETRANGE("No.", "No.");
                        IF not lr_ContBusRel.IsEmpty() THEN BEGIN
                            lr_RelPrintDoc.RESET();
                            lr_RelPrintDoc.FILTERGROUP(2);
                            lr_RelPrintDoc.SETRANGE(Source, lr_RelPrintDoc.Source::Sales);
                            lr_RelPrintDoc.SETRANGE("Print Document Code", 'KONTAKT NEUANLAGE');
                            lr_RelPrintDoc.SETRANGE(Release, TRUE);
                            lr_RelPrintDoc.SETRANGE("Kind of Release", lr_RelPrintDoc."Kind of Release"::Mail);
                            lr_RelPrintDoc.SETRANGE("Consignee No.", lr_ContBusRel."Contact No.");
                            lr_RelPrintDoc.SETRANGE("Released as Mail", TRUE);
                            lr_RelPrintDoc.SETFILTER("Print Description 1", '<>%1', '');
                            lr_RelPrintDoc.FILTERGROUP(0);
                            IF lr_RelPrintDoc.FINDSET() THEN
                                Page.RUN(Page::"poi Released Print Documents", lr_RelPrintDoc);
                        END;
                    END;
            end;
        }
        field(59; Ausnahmegenehmigung; Option)
        {
            Caption = 'Ausnahmegenehmigung';
            OptionCaption = ' ,genehmigt,abgelehnt,beantragt';
            OptionMembers = " ",genehmigt,abgelehnt,beantragt;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                NoCommentTxt: Label 'Freigabe ohne Begründungstext nicht möglich. Bitte das Bemerkungsfeld füllen.';
            begin
                POIFunc.CheckPermission(50906, 59, 1);
                // IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                //     IF NOT POIFunc.CheckUserInRole('GL_VENDINDIRECT_W', 0) THEN
                //         ERROR(ERR_NoPermissionTxt);
                case Ausnahmegenehmigung of
                    Ausnahmegenehmigung::genehmigt:
                        begin
                            if Comment = '' then
                                Error(NoCommentTxt);
                            SetCreditlimitForVendor();
                            "Authentizität bekannt" := TRUE;
                            "Prüfung Kundenunterschrift" := TRUE;
                            "Kundenunterschrift UserID" := copystr(USERID(), 1, 50);
                            "Ausnahmeg. erteilt durch" := copystr(USERID(), 1, 50);
                            "Ausnahmegenehmigung erteilt am" := WORKDATE();
                            "Ausnahmegenehmigung Erinnerung" := CALCDATE('< +3W >', WORKDATE());
                            "Ausnahmegenehmigung Ablauf" := CALCDATE('< +2M >', WORKDATE());
                            Verifikationsanruf := Verifikationsanruf::verzichtet;
                            "VerifikationGeschäftstätigkeit" := "VerifikationGeschäftstätigkeit"::verzichtet;
                            VALIDATE("Freigabe für Kreditor", TRUE);
                            SetRefundForAccount("Source Type", "No.");
                        end;
                    Ausnahmegenehmigung::abgelehnt:
                        begin
                            "Ausnahmeg. erteilt durch" := copystr(USERID(), 1, 50);
                            "Ausnahmegenehmigung erteilt am" := WORKDATE();
                            "Ausnahmegenehmigung Erinnerung" := 0D;
                            "Ausnahmegenehmigung Ablauf" := 0D;
                            VALIDATE("Freigabe für Kreditor", FALSE);
                        end;
                    Ausnahmegenehmigung::beantragt:
                        begin
                            "Anforderung an GL" := true;
                            "Anforderung an GL User ID" := copystr(Userid(), 1, MaxStrLen("Anforderung an GL User ID"));
                            "Anforderung an GL Datum" := Today();
                        end;
                    else begin
                            "Ausnahmegenehmigung Erinnerung" := 0D;
                            "Ausnahmegenehmigung Ablauf" := 0D;
                            "GL Comment Fail" := FALSE;
                            CheckLFB();
                        end;
                end;
                MODIFY();
                CheckWorkflowTask(50906, FieldNo(Ausnahmegenehmigung), Ausnahmegenehmigung, true);
            end;
        }
        field(60; "Ausnahmeg. erteilt durch"; Text[50])
        {
            Caption = 'Ausnahmegenehmigung erteilt durch';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(61; "Ausnahmegenehmigung erteilt am"; Date)
        {
            Caption = 'Ausnahmegenehmigung erteilt am';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(1450; "Ausnahmegenehmigung Erinnerung"; Date)
        {
            Caption = 'Ausnahmegenehmigung Ablauf Erinnerung';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(1451; "Ausnahmegenehmigung Ablauf"; Date)
        {
            Caption = 'Ausnahmegenehmigung Ablauf';
            DataClassification = CustomerContent;
            ;
        }
        field(599; "Freigabe für Debitor"; Boolean)
        {
            Caption = 'Freigabe für Debitor';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(600; "Cust Checkliste vollständig"; Boolean)
        {
            Caption = 'Checkliste neuer Kunde Vollständig';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF "Cust Checkliste vollständig" THEN BEGIN
                    "Cust Checkliste geprüft von" := copystr(USERID(), 1, 50);
                    "Cust Checkliste geprüft am" := WORKDATE();
                    "Cust Checkliste Ablauf" := CALCDATE('< +1J >', WORKDATE());
                END ELSE BEGIN
                    "Cust Checkliste geprüft von" := '';
                    "Cust Checkliste geprüft am" := 0D;
                    "Cust Checkliste Ablauf" := 0D;
                END;
            end;
        }
        field(601; "Cust Checkliste geprüft von"; Text[50])
        {
            Caption = 'Checkliste geprüft von';
            DataClassification = CustomerContent;
        }
        field(602; "Cust Checkliste geprüft am"; Date)
        {
            Caption = 'Checkliste geprüft am';
            DataClassification = CustomerContent;
        }
        field(603; "Cust LE erhalten"; Boolean)
        {
            Caption = 'Lieferantenerklärung erhalten';
            DataClassification = CustomerContent;
        }
        field(604; "Cust LE Unterschrieben am"; Date)
        {
            Caption = 'Unterschrieben am';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF "Cust LE Unterschrieben am" = 0D THEN
                    "Cust LE erhalten" := FALSE
                ELSE
                    IF ("Cust LE Unterschrieben am" <> xRec."Cust LE Unterschrieben am") AND ("Cust LE Unterschrieben am" <> 0D) THEN
                        "Cust LE erhalten" := TRUE;
                IF "Cust LE Unterschrieben am" > xRec."Cust LE Unterschrieben am" THEN
                    "Cust LFB Version" := 'LFB_Version';
            end;
        }
        field(605; "Cust Vorgabe GTIN-Code"; Boolean)
        {
            Caption = 'Vorgabe GTIN-Code';
            DataClassification = CustomerContent;
        }
        field(606; "Cust LFB Version"; Code[50])
        {
            Caption = 'Anforderung enthalten in Version LFB';
            DataClassification = CustomerContent;
        }
        field(607; "Cust Rahmenvertrag"; Boolean)
        {
            Caption = 'Rahmenvertrag';
            DataClassification = CustomerContent;
        }
        field(608; "Cust AGBs versandt"; Boolean)
        {
            Caption = 'AGBs versandt';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CheckLFB();
            end;
        }
        field(609; "Cust Erzeugersperren"; Boolean)
        {
            Caption = 'Erzeugersperren';
            DataClassification = CustomerContent;
        }
        field(610; "Cust Ausnahmegenehmigung"; Boolean)
        {
            Caption = 'Ausnahmegenehmigung';
            DataClassification = CustomerContent;
        }
        field(611; "Cust Ausnahmeg. erteilt durch"; Text[50])
        {
            Caption = 'Ausnahmegenehmigung erteilt durch';
            DataClassification = CustomerContent;
        }
        field(612; "Cust Ausnahmeg. erteilt am"; Date)
        {
            Caption = 'Ausnahmegenehmigung erteilt am';
            DataClassification = CustomerContent;
        }
        field(613; "Cust Verifizierung"; Boolean)
        {
            Caption = 'Checkliste Verifikation Kunde';
            DataClassification = CustomerContent;
        }
        field(614; "DSB intern und extern"; Boolean)
        {
            Caption = 'DSB intern und extern';
            DataClassification = CustomerContent;
        }
        field(630; "Cust Gesetzl. Anforderungen"; Boolean)
        {
            Caption = 'Gesetzl. Anforderungen';
            DataClassification = CustomerContent;
        }
        field(700; "Cust Checkliste Ablauf"; Date)
        {
            Caption = 'Checkliste Ablauf';
            DataClassification = CustomerContent;
        }
        field(701; "Cust Ausnahmegeneh. Erinnerung"; Date)
        {
            Caption = 'Ausnahmegenehmigung Ablauf Erinnerung';
            DataClassification = CustomerContent;
        }
        field(702; "Cust Ausnahmegeneh. Ablauf"; Date)
        {
            Caption = 'Ausnahmegenehmigung Ablauf';
            DataClassification = CustomerContent;
        }
        field(1000; "Reactivate Old Vendor"; Boolean)
        {
            Caption = 'Alten Kreditor reaktivieren';
            DataClassification = CustomerContent;
        }
        field(101; Blankobriefkopf; Boolean)
        {
            Caption = 'Blankobriefkopf';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 101, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF Blankobriefkopf THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Blankobriefkopf UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo(Blankobriefkopf), Blankobriefkopf, true);
            end;
        }
        field(102; "Blankobriefkopf UserID"; Code[50])
        {
            Caption = 'Blankobriefkopf UserID';
            DataClassification = CustomerContent;
        }
        field(103; Handelsregisterauszug; Boolean)
        {
            Caption = 'Handelsregisterauszug (nicht älter als 6 Monate)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 103, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF Handelsregisterauszug THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Handelsregisterauszug UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo(Handelsregisterauszug), Handelsregisterauszug, true);
            end;
        }
        field(104; "Handelsregisterauszug UserID"; Code[50])
        {
            Caption = 'Handelsregisterauszug (nicht älter als 6 Monate) UserID';
            DataClassification = CustomerContent;
        }
        field(105; "Steuernummer vom FA"; Boolean)
        {
            Caption = 'Bestätigung der Steuernummer vom FA (nur bei Handelspartnern aus Drittländern)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 105, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF "Steuernummer vom FA" THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Steuernummer vom FA UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Steuernummer vom FA"), "Steuernummer vom FA", true);
            end;
        }
        field(106; "Steuernummer vom FA UserID"; Code[50])
        {
            Caption = 'Bestätigung der Steuernummer vom FA (nur bei Handelspartnern aus Drittländern) UserID';
            DataClassification = CustomerContent;
        }
        field(200; "Externes Stammblatt"; Boolean)
        {
            Caption = 'Externes Stammblatt liegt inkl. aller Angaben vollständig vor';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 200, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF "Externes Stammblatt" THEN BEGIN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Externes Stammblatt UserID" := gr_UserSetup."User ID";
                    "Stammblatt nicht unterzeichnet" := FALSE;
                    VALIDATE("Stammblatt gültig bis", 0D);
                END ELSE BEGIN
                    "Stammblatt nicht unterzeichnet" := TRUE;
                    "Stammblatt gültig bis" := CALCDATE('< +2W >', WORKDATE());
                END;
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Externes Stammblatt"), "Externes Stammblatt", true);
            end;
        }
        field(201; "Externes Stammblatt UserID"; Code[50])
        {
            Caption = 'Externes Stammblatt liegt inkl. aller Angaben vollständig vor UserID';
            DataClassification = CustomerContent;
        }
        field(202; "Prüfung Kundenunterschrift"; Boolean)
        {
            Caption = 'Unterschrift auf externem Stammblatt stimmt mit Handelsregisterauszug, Auskunfteiangabe überein';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 202, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF "Prüfung Kundenunterschrift" THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Kundenunterschrift UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Prüfung Kundenunterschrift"), "Prüfung Kundenunterschrift", true);
            end;
        }
        field(203; "Kundenunterschrift UserID"; Text[50])
        {
            Caption = 'Unterschrift auf externem Stammblatt stimmt mit Handelsregisterauszug, Auskunfteiangabe überein UserID';
            DataClassification = CustomerContent;
        }
        field(204; "Prüfung ext. Stammblatt"; Boolean)
        {
            Caption = 'Angaben auf externem Stammblatt stimmen mit Angaben auf eingereichten Dokumenten überein';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 204, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF "Prüfung ext. Stammblatt" THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Prüfung ext. Stammblatt UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Prüfung ext. Stammblatt"), "Prüfung ext. Stammblatt", true);
            end;
        }
        field(205; "Prüfung ext. Stammblatt UserID"; Code[50])
        {
            Caption = 'Angaben auf externem Stammblatt stimmen mit Angaben auf eingereichten Dokumenten überein UserID';
            DataClassification = CustomerContent;
        }
        field(206; "Verifikation USt-ID"; Boolean)
        {
            Caption = 'Verifikation der USt-ID (inkl. Ausdruck)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 206, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF "Verifikation USt-ID" THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Verifikation USt-ID UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Verifikation USt-ID"), "Verifikation USt-ID", true);
            end;
        }
        field(207; "Verifikation USt-ID UserID"; Code[50])
        {
            Caption = 'Verifikation der USt-ID (inkl. Ausdruck) UserID';
            DataClassification = CustomerContent;
        }
        field(208; "Stammblatt Ablage"; Boolean)
        {
            Caption = 'Ablage der Ausdrucke extern in PDF in der Kreditorenkarte und im Orginal in der Kreditorenakte in der Fibu';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 208, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF "Stammblatt Ablage" THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Stammblatt Ablage UserID" := gr_UserSetup."User ID";
                CheckWorkflowTask(50906, FieldNo("Stammblatt Ablage"), "Stammblatt Ablage", true);
            end;
        }
        field(209; "Stammblatt Ablage UserID"; Code[50])
        {
            Caption = 'Ablage der Ausdrucke extern in PDF in der Kreditorenkarte und im Orginal in der Kreditorenakte in der Fibu UserID';
            DataClassification = CustomerContent;
        }
        field(210; "Allg Angaben aus Stammblatt"; Boolean)
        {
            Caption = 'Allgemeine Angaben aus ext. Stammdatenblatt';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 210, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF "Allg Angaben aus Stammblatt" THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Allg Angaben Stammblatt UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Allg Angaben aus Stammblatt"), "Allg Angaben aus Stammblatt", true);
            end;
        }
        field(211; "Allg Angaben Stammblatt UserID"; Code[50])
        {
            Caption = 'Allg Angaben Stammblatt UserID';
            DataClassification = CustomerContent;
        }
        field(250; Kreditversicherungslimit; Boolean)
        {
            Caption = 'Beantragung, Erfassung und Genehmigung Kreditversicherungslimit';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('FB_CUSTVERIFIKAT_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
                IF Kreditversicherungslimit THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Kreditversich.Limit UserID" := gr_UserSetup."User ID";
                CheckWorkflowTask(50906, FieldNo(Kreditversicherungslimit), Kreditversicherungslimit, true);
            end;
        }
        field(251; "Kreditversich.Limit UserID"; Text[50])
        {
            Caption = 'Beantragung, Erfassung und Genehmigung Kreditversicherungslimit UserID';
            DataClassification = CustomerContent;
        }
        field(300; "Kein Lieferantenfragebogen"; Boolean)
        {
            Caption = 'Nichtvorliegen eines gültigen Lieferantenfragebogens';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.UserInWindowsRole('GL_VENDVERIFIKAT_W') THEN
                    IF NOT POIFunc.UserInWindowsRole('QS_GL_VENDVERIFIKATW') THEN
                        ERROR(ERR_NoPermissionTxt);
                IF "Kein Lieferantenfragebogen" THEN
                    "Kein LFB gültig bis" := CALCDATE('< +2W >', WORKDATE());
                IF NOT "Kein Lieferantenfragebogen" THEN
                    VALIDATE("Kein LFB gültig bis", 0D);
                CheckWorkflowTask(50906, FieldNo("Kein Lieferantenfragebogen"), "Kein Lieferantenfragebogen", true);
            end;
        }
        field(301; "Stammblatt nicht unterzeichnet"; Boolean)
        {
            Caption = 'Lieferanten-/Kundenstammblatt ist noch nicht unterzeichnet zurück';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);
                IF "Stammblatt nicht unterzeichnet" THEN
                    "Stammblatt gültig bis" := CALCDATE('< +2W >', WORKDATE());
                IF NOT "Stammblatt nicht unterzeichnet" THEN
                    VALIDATE("Stammblatt gültig bis", 0D);
                CheckWorkflowTask(50906, FieldNo("Stammblatt nicht unterzeichnet"), "Stammblatt nicht unterzeichnet", true);
            end;
        }
        field(302; "Kein Konformer Laborbericht"; Boolean)
        {
            Caption = 'Nichtvorliegen eines konformen Laborberichts';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('QS_GL_VENDVERIFIKATW', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
                IF "Kein Konformer Laborbericht" THEN
                    "Laborbericht gültig bis" := CALCDATE('< +2W >', WORKDATE());
                IF NOT "Kein Konformer Laborbericht" THEN
                    VALIDATE("Laborbericht gültig bis", 0D);
                CheckWorkflowTask(50906, FieldNo("Kein Konformer Laborbericht"), "Kein Konformer Laborbericht", true);
            end;
        }
        field(303; "Kein gültiger GGAP-Zertifikat"; Boolean)
        {
            Caption = 'Nichtvorliegen eines gültigen GlobalGAP-Zertifikats';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('QS_GL_VENDVERIFIKATW', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
                IF "Kein gültiger GGAP-Zertifikat" THEN
                    "GGAP-Zertifikat gültig bis" := CALCDATE('< +2W >', WORKDATE());
                IF NOT "Kein gültiger GGAP-Zertifikat" THEN
                    VALIDATE("GGAP-Zertifikat gültig bis", 0D);
                CheckWorkflowTask(50906, FieldNo("Kein gültiger GGAP-Zertifikat"), "Kein gültiger GGAP-Zertifikat", true);
            end;
        }
        field(304; "Internal credit limit"; Boolean)
        {
            Caption = 'Inanspruchnahme des internes Kreditlimits';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);
                IF NOT "Internal credit limit" THEN BEGIN
                    VALIDATE("Credit limit int. valid until", 0D);
                    IF lr_Vendor.GET("No.") THEN BEGIN
                        lr_Vendor."POI Prepaymt requested Status" := lr_Vendor."POI Prepaymt requested Status"::" ";
                        lr_Vendor."POI Internal credit limit" := 0;
                        lr_Vendor.MODIFY();
                    END;
                END;
                CheckWorkflowTask(50906, FieldNo("Internal credit limit"), "Internal credit limit", true);
            end;
        }
        field(306; "Verzicht auf Verifikation"; Boolean)
        {
            Caption = 'Verzicht auf Verifikation';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);
                CheckWorkflowTask(50906, FieldNo("Verzicht auf Verifikation"), "Verzicht auf Verifikation", true);
            end;
        }
        field(307; "Kein Blankobriefkopf"; Boolean)
        {
            Caption = 'Kein Blankobriefkopf';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('ABW_CUSTVERIFIKAT_W', 0) THEN
                        IF NOT POIFunc.CheckUserInRole('HA_VENDVERIFIKAT_W', 0) THEN
                            IF NOT POIFunc.CheckUserInRole('HA_CUSTVERIFIKAT_W', 0) THEN
                                IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                                    IF NOT POIFunc.CheckUserInRole('FB_CUSTVERIFIKAT_W', 0) THEN
                                        ERROR(ERR_NoPermissionTxt);
                IF Blankobriefkopf THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Blankobriefkopf UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Kein Blankobriefkopf"), "Kein Blankobriefkopf", true);
            end;
        }
        field(308; "Kein Handelsregisterauszug"; Boolean)
        {
            Caption = 'Kein Handelsregisterauszug';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('ABW_CUSTVERIFIKAT_W', 0) THEN
                        IF NOT POIFunc.CheckUserInRole('HA_VENDVERIFIKAT_W', 0) THEN
                            IF NOT POIFunc.CheckUserInRole('HA_CUSTVERIFIKAT_W', 0) THEN
                                IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                                    IF NOT POIFunc.CheckUserInRole('FB_CUSTVERIFIKAT_W', 0) THEN
                                        ERROR(ERR_NoPermissionTxt);
                IF Handelsregisterauszug THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Handelsregisterauszug UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Kein Handelsregisterauszug"), "Kein Handelsregisterauszug", true);
            end;
        }
        field(309; "Unterschrift Übereinstimmung"; Boolean)
        {
            Caption = 'Unterschrift Übereinstimmung';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('FB_CUSTVERIFIKAT_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
                IF "Prüfung Kundenunterschrift" THEN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Kundenunterschrift UserID" := gr_UserSetup."User ID";
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Unterschrift Übereinstimmung"), "Unterschrift Übereinstimmung", true);
            end;
        }
        field(310; "Kein LFB gültig bis"; Date)
        {
            Caption = 'Kein LFB gültig bis';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('QS_GL_VENDVERIFIKATW', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
                IF NOT "Kein Lieferantenfragebogen" THEN
                    "Kein LFB gültig bis" := 0D;
            end;
        }
        field(311; "Stammblatt gültig bis"; Date)
        {
            Caption = 'Stammblatt gültig bis';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('ABW_CUSTVERIFIKAT_W', 0) THEN
                        IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                            IF NOT POIFunc.CheckUserInRole('FB_CUSTVERIFIKAT_W', 0) THEN
                                IF NOT POIFunc.CheckUserInRole('HA_VENDVERIFIKAT_W', 0) THEN
                                    IF NOT POIFunc.CheckUserInRole('HA_CUSTVERIFIKAT_W', 0) THEN
                                        IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                                            IF NOT POIFunc.CheckUserInRole('HA_GL_VENDVERIFIKATW', 0) THEN
                                                ERROR(ERR_NoPermissionTxt);
                IF NOT "Stammblatt nicht unterzeichnet" THEN
                    "Stammblatt gültig bis" := 0D;
            end;
        }
        field(312; "Laborbericht gültig bis"; Date)
        {
            Caption = 'Konformer Laborbericht gültig bis';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('QS_GL_VENDVERIFIKATW', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
                IF NOT "Kein Konformer Laborbericht" THEN
                    "Laborbericht gültig bis" := 0D;
            end;
        }
        field(313; "GGAP-Zertifikat gültig bis"; Date)
        {
            Caption = 'GGAP-Zertifikat gültig bis';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('QS_GL_VENDVERIFIKATW', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
                IF NOT "Kein gültiger GGAP-Zertifikat" THEN
                    "GGAP-Zertifikat gültig bis" := 0D;
            end;
        }
        field(314; "Credit limit int. valid until"; Date)
        {
            Caption = 'Kreditlimit int. gültig bis';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);
                IF NOT "Internal credit limit" THEN
                    "Credit limit int. valid until" := 0D
                ELSE
                    IF lr_Vendor.GET("No.") THEN BEGIN
                        lr_Vendor."POI Cred. limit int. val.until" := "Credit limit int. valid until";
                        lr_Vendor.MODIFY();
                    END;
            end;
        }
        field(400; "Verifikationsanruf Name"; Text[50])
        {
            Caption = 'Verifikationsanruf Name';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 400, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF ("Verifikationsanruf Name" <> '') AND ("Verifikationsanruf Tel. Nr." <> '') AND
                  ("Verifikationsanruf Quelle Tel." <> '')
                THEN
                    IF gr_UserSetup.GET(USERID()) THEN BEGIN
                        VerifikationsanrufDatumUhrzeit := CURRENTDATETIME();
                        "Verifikationsanruf User" := gr_UserSetup."User ID";
                    END;
                IF ("Verifikationsanruf Name" = '') AND ("Verifikationsanruf Tel. Nr." = '') AND
                  ("Verifikationsanruf Quelle Tel." = '')
                THEN BEGIN
                    VerifikationsanrufDatumUhrzeit := 0DT;
                    "Verifikationsanruf User" := '';
                END;
                IF ("Verifikationsanruf Name" <> '') AND ("Verifikationsanruf Tel. Nr." <> '') AND
                  ("Verifikationsanruf Quelle Tel." <> '')
                THEN
                    Verifikationsanruf := Verifikationsanruf::erfolgt
                ELSE
                    Verifikationsanruf := Verifikationsanruf::"nicht erfolgt";
                CheckWorkflowTask(50906, FieldNo("Verifikationsanruf Name"), "Verifikationsanruf Name", true);
            end;
        }
        field(401; "Verifikationsanruf Tel. Nr."; Text[30])
        {
            Caption = 'Verifikationsanruf Tel. Nr.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 401, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF ("Verifikationsanruf Name" <> '') AND ("Verifikationsanruf Tel. Nr." <> '') AND
                  ("Verifikationsanruf Quelle Tel." <> '')
                THEN
                    IF gr_UserSetup.GET(USERID()) THEN BEGIN
                        VerifikationsanrufDatumUhrzeit := CURRENTDATETIME();
                        "Verifikationsanruf User" := gr_UserSetup."User ID";
                    END;
                IF ("Verifikationsanruf Name" = '') AND ("Verifikationsanruf Tel. Nr." = '') AND
                  ("Verifikationsanruf Quelle Tel." = '')
                THEN BEGIN
                    VerifikationsanrufDatumUhrzeit := 0DT;
                    "Verifikationsanruf User" := '';
                END;
                IF ("Verifikationsanruf Name" <> '') AND ("Verifikationsanruf Tel. Nr." <> '') AND ("Verifikationsanruf Quelle Tel." <> '')
                THEN
                    Verifikationsanruf := Verifikationsanruf::erfolgt
                ELSE
                    Verifikationsanruf := Verifikationsanruf::"nicht erfolgt";
                CheckWorkflowTask(50906, FieldNo("Verifikationsanruf Tel. Nr."), "Verifikationsanruf Tel. Nr.", true);
            end;
        }
        field(402; "Verifikationsanruf Quelle Tel."; Text[30])
        {
            Caption = 'Verifikationsanruf Quelle Tel. Nr.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 402, 2) then
                    ERROR(ERR_NoPermissionTxt);

                IF ("Verifikationsanruf Name" <> '') AND ("Verifikationsanruf Tel. Nr." <> '') AND
                  ("Verifikationsanruf Quelle Tel." <> '')
                THEN
                    IF gr_UserSetup.GET(USERID()) THEN BEGIN
                        VerifikationsanrufDatumUhrzeit := CURRENTDATETIME();
                        "Verifikationsanruf User" := gr_UserSetup."User ID";
                    END;

                IF ("Verifikationsanruf Name" = '') AND ("Verifikationsanruf Tel. Nr." = '') AND
                  ("Verifikationsanruf Quelle Tel." = '')
                THEN BEGIN
                    VerifikationsanrufDatumUhrzeit := 0DT;
                    "Verifikationsanruf User" := '';
                END;
                IF ("Verifikationsanruf Name" <> '') AND ("Verifikationsanruf Tel. Nr." <> '') AND
                  ("Verifikationsanruf Quelle Tel." <> '')
                THEN
                    Verifikationsanruf := Verifikationsanruf::erfolgt
                ELSE
                    Verifikationsanruf := Verifikationsanruf::"nicht erfolgt";
                CheckWorkflowTask(50906, FieldNo("Verifikationsanruf Quelle Tel."), "Verifikationsanruf Quelle Tel.", true);
            end;
        }
        field(403; VerifikationsanrufDatumUhrzeit; DateTime)
        {
            Caption = 'Verifikationsanruf Datum Uhrzeit';
            DataClassification = CustomerContent;
        }
        field(404; "Verifikationsanruf User"; Code[50])
        {
            Caption = 'Verifikationsanruf User';
            DataClassification = CustomerContent;
        }
        field(405; "Kontaktdaten hinterlegt"; Boolean)
        {
            Caption = 'Kontaktdaten aus ext. Stammdatenblatt hinterlegt';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 405, 2) then
                    ERROR(ERR_NoPermissionTxt);
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo("Kontaktdaten hinterlegt"), "Kontaktdaten hinterlegt", true);
            end;
        }
        field(406; Zahlungskonditionen; Boolean)
        {
            Caption = 'Zahlungskonditionen';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 406, 2) then
                    ERROR(ERR_NoPermissionTxt);

                CheckLFB();
                CheckWorkflowTask(50906, FieldNo(Zahlungskonditionen), Zahlungskonditionen, true);
            end;
        }
        field(440; "Anforderung an GL"; Boolean)
        {
            Caption = 'Anforderung an GL';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('ABW_CUSTVERIFIKAT_W', 0) THEN
                        IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                            IF NOT POIFunc.CheckUserInRole('FB_CUSTVERIFIKAT_W', 0) THEN
                                IF NOT POIFunc.CheckUserInRole('HA_VENDVERIFIKAT_W', 0) THEN
                                    IF NOT POIFunc.CheckUserInRole('HA_CUSTVERIFIKAT_W', 0) THEN
                                        ERROR(ERR_NoPermissionTxt);
                IF "Anforderung an GL" THEN BEGIN
                    IF gr_UserSetup.GET(USERID()) THEN
                        "Anforderung an GL User ID" := gr_UserSetup."User ID";
                    "Anforderung an GL Datum" := WORKDATE();
                END ELSE BEGIN
                    "Anforderung an GL User ID" := '';
                    "Anforderung an GL Datum" := 0D;
                END;
                //Hier muss der WF GL in Gang gesetzt werden
            end;
        }
        field(441; "Anforderung an GL User ID"; Code[50])
        {
            Caption = 'Anforderung an GL User ID';
            DataClassification = CustomerContent;
        }
        field(442; "Anforderung an GL Datum"; Date)
        {
            Caption = 'Anforderung an GL Datum';
            DataClassification = CustomerContent;
        }
        field(450; "GL Comment Fail"; Boolean)
        {
            Caption = 'GL Comment Fail';
            DataClassification = CustomerContent;
        }
        field(451; QS; Boolean)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 451, 2) then
                    ERROR(ERR_NoPermissionTxt);
                CheckLFB();
                CheckWorkflowTask(50906, FieldNo(QS), QS, true);
            end;
        }
        field(460; Synchronized; Boolean)
        {
            Caption = 'Synchronisiert';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
            end;
        }
        field(461; Purchaser; Text[50])
        {
            Caption = 'Purchaser Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser"; //WHERE(inactive "NAV User"=FILTER(No));

            trigger OnLookup()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                IF NOT POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN
                    ERROR(ERR_NoPermissionTxt);

                lr_SalesPurch.FILTERGROUP(2);
                lr_SalesPurch.SETRANGE("POI Is Purchaser", TRUE);
                //     lr_SalesPurch.SETRANGE("inactive NAV User",TRUE);
                lr_SalesPurch.FILTERGROUP(0);
                IF Page.RUNMODAL(0, lr_SalesPurch) = ACTION::LookupOK THEN
                    Purchaser := lr_SalesPurch.Name;
            end;

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN
                    IF NOT POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                        ERROR(ERR_NoPermissionTxt);
                CheckWorkflowTask(50906, FieldNo(Purchaser), Purchaser, true);
            end;
        }
        field(500; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
        }
        field(50000; Comment; Text[250])
        {
            Caption = 'Bemerkung';
            DataClassification = CustomerContent;
        }
        field(50001; "Document Sending Date"; Date)
        {
            Caption = 'Versanddatum der Dokumente';
            DataClassification = CustomerContent;
        }
        field(50002; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        Field(50003; PurchSalespersonOK; Boolean)
        {
            Caption = 'Einkäufer und Sachbearbeiter hinterlegt';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if not POIFunc.CheckPermission(50906, 50003, 2) then
                    ERROR(ERR_NoPermissionTxt);

                CheckWorkflowTask(50906, FieldNo(PurchSalespersonOK), PurchSalespersonOK, true);
            end;
        }
        field(50004; "Shipment Address exists"; Boolean)
        {
            Caption = 'Lieferanschriften hinterlegt';
            DataClassification = CustomerContent;
        }
        field(50005; "Customer Requirements"; Boolean)
        {
            Caption = 'Kundenanforderungen';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Customer Requirements" then
                    "No Customer Requirements" := false;
            end;
        }
        field(50006; "No Customer Requirements"; Boolean)
        {
            Caption = 'Debitor hat keine Anforderungen übermittelt ';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "No customer Requirements" then
                    "Customer Requirements" := false;
            end;
        }
        field(50007; "Check Internal Cred. Limit"; Boolean)
        {
            Caption = 'Debitor wurde bei Vergabe eines internen Kreditlimits auf Negativmerkmale überprüft.';
            DataClassification = CustomerContent;
        }
        field(50550; "Cust CreditLimit Date Check"; date)
        {
            Caption = 'Letzte Kreditlimit Prüfung';
            DataClassification = CustomerContent;
        }
        field(50551; "Cust Credit Date Check Execute"; Boolean)
        {
            Caption = 'Kreditlimitprüfung';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.", "Source Type")
        {
        }
    }

    trigger OnInsert()
    begin
        "No customer Requirements" := true;
    end;

    procedure CheckLFB()
    var
        //Customer: Record Customer;
        lr_CountryRegion: Record "Country/Region";
        Cont: Record Contact;
        //AccCompSetting: Record "POI Account Company Setting";
        l_KreditorFreigabe: Boolean;
    begin
        //Prüfung ob Vendor freigegeben werden kann
        IF "Source Type" = "Source Type"::Vendor THEN BEGIN
            IF lr_Vendor.GET("No.") THEN;
            ContBusRel.RESET();
            ContBusRel.SETRANGE("No.", lr_Vendor."No.");
            ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
            IF ContBusRel.FINDFIRST() THEN BEGIN
                Cont.GET(ContBusRel."Contact No.");
                IF ((NOT Cont."POI Diverse Vendor") AND (NOT POIFunc.CompanyInAccSetDivForContact(Cont."No.")) AND (NOT Cont."POI Small Vendor"))
                THEN BEGIN
                    IF lr_CountryRegion.GET(lr_Vendor."Country/Region Code") THEN;
                    IF lr_CountryRegion."EU Country/Region Code" = '' THEN BEGIN
                        IF NOT "Authentizität bekannt" THEN BEGIN
                            IF (("Verifikation Adresse" <> "Verifikation Adresse"::"nicht erfolgt") AND
                              (VerifikationGeschäftstätigkeit <> VerifikationGeschäftstätigkeit::"nicht erfolgt") AND
                              (Blankobriefkopf) AND ("Steuernummer vom FA") AND ("Externes Stammblatt") AND
                              (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt") AND (QS))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                            IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                IF (("Verifikation Adresse" <> "Verifikation Adresse"::"nicht erfolgt") AND (VerifikationGeschäftstätigkeit <> VerifikationGeschäftstätigkeit::"nicht erfolgt") AND
                                  (Blankobriefkopf) AND ("Steuernummer vom FA") AND ("Externes Stammblatt") AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt") AND (QS))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE;
                        END ELSE BEGIN
                            IF ((Blankobriefkopf) AND ("Steuernummer vom FA") AND ("Externes Stammblatt") AND
                              (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt") AND (QS))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                            IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                IF ((Blankobriefkopf) AND ("Steuernummer vom FA") AND ("Externes Stammblatt") AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt") AND (QS))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE
                        END;
                    END ELSE
                        IF NOT "Authentizität bekannt" THEN BEGIN
                            IF (("Verifikation Adresse" <> "Verifikation Adresse"::"nicht erfolgt") AND
                              (VerifikationGeschäftstätigkeit <> VerifikationGeschäftstätigkeit::"nicht erfolgt") AND
                              (Blankobriefkopf) AND ("Externes Stammblatt") AND
                              (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                              ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt") AND (QS))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                            IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                IF (("Verifikation Adresse" <> "Verifikation Adresse"::"nicht erfolgt") AND
                                  (VerifikationGeschäftstätigkeit <> VerifikationGeschäftstätigkeit::"nicht erfolgt") AND
                                  (Blankobriefkopf) AND ("Externes Stammblatt") AND
                                  ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                                  ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt") AND (QS))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE;

                        END ELSE BEGIN
                            IF ((Blankobriefkopf) AND ("Externes Stammblatt") AND
                              (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                              ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt") AND (QS))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                            IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                IF ((Blankobriefkopf) AND ("Externes Stammblatt") AND
                                  ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                                  ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt") AND (QS))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE;

                            IF Cont."POI Shipping Company" THEN BEGIN
                                IF ((Blankobriefkopf) AND ("Externes Stammblatt") AND
                                  (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                                  ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE;
                                IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                    IF ((Blankobriefkopf) AND ("Externes Stammblatt") AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                      ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                                    THEN
                                        l_KreditorFreigabe := TRUE
                                    ELSE
                                        IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                            l_KreditorFreigabe := FALSE;
                            END;
                        END;
                END ELSE BEGIN
                    IF lr_CountryRegion.GET(lr_Vendor."Country/Region Code") THEN;
                    IF lr_CountryRegion."EU Country/Region Code" = '' THEN BEGIN
                        IF (("Steuernummer vom FA") AND ("Externes Stammblatt") AND
                          (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                          ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt"))
                        THEN
                            l_KreditorFreigabe := TRUE
                        ELSE
                            IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                l_KreditorFreigabe := FALSE;
                        IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                            IF (("Steuernummer vom FA") AND ("Externes Stammblatt") AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt"))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                    END ELSE BEGIN
                        IF (("Externes Stammblatt") AND
                          (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                          ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                          ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                        THEN
                            l_KreditorFreigabe := TRUE
                        ELSE
                            IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                l_KreditorFreigabe := FALSE;
                        IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                            IF (("Externes Stammblatt") AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                    END;
                END;

                IF (Cont."POI Diverse Vendor") AND (NOT Cont."POI Supplier of Goods") AND (NOT Cont."POI Carrier")
                  AND (NOT Cont."POI Warehouse Keeper") AND (NOT Cont."POI Customs Agent") AND (NOT Cont."POI Tax Representative")
                  AND (NOT Cont."POI Small Vendor") AND (NOT Cont."POI Shipping Company")
                THEN BEGIN
                    IF lr_CountryRegion.GET(lr_Vendor."Country/Region Code") THEN;
                    IF lr_CountryRegion."EU Country/Region Code" = '' THEN BEGIN
                        IF NOT "Authentizität bekannt" THEN BEGIN
                            IF (("Verifikation Adresse" <> "Verifikation Adresse"::"nicht erfolgt") AND
                              (VerifikationGeschäftstätigkeit <> VerifikationGeschäftstätigkeit::"nicht erfolgt") AND
                              ("Steuernummer vom FA") AND ("Externes Stammblatt") AND
                              (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt")) //AND (QS))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                            IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                IF (("Verifikation Adresse" <> "Verifikation Adresse"::"nicht erfolgt") AND
                                  (VerifikationGeschäftstätigkeit <> VerifikationGeschäftstätigkeit::"nicht erfolgt") AND ("Steuernummer vom FA") AND ("Externes Stammblatt") AND
                                  ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt") AND (QS))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE;
                        END ELSE BEGIN
                            IF (("Steuernummer vom FA") AND ("Externes Stammblatt") AND
                              (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt") AND (QS))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                            IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                IF (("Steuernummer vom FA") AND ("Externes Stammblatt") AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND ("Allg Angaben aus Stammblatt") AND (QS))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE
                        END;
                    END ELSE
                        IF NOT "Authentizität bekannt" THEN BEGIN
                            IF (("Verifikation Adresse" <> "Verifikation Adresse"::"nicht erfolgt") AND
                              (VerifikationGeschäftstätigkeit <> VerifikationGeschäftstätigkeit::"nicht erfolgt") AND
                              ("Externes Stammblatt") AND
                              (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                              ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                            IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                IF (("Verifikation Adresse" <> "Verifikation Adresse"::"nicht erfolgt") AND
                                  (VerifikationGeschäftstätigkeit <> VerifikationGeschäftstätigkeit::"nicht erfolgt") AND
                                  ("Externes Stammblatt") AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                                  ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE;

                        END ELSE BEGIN
                            IF (("Externes Stammblatt") AND
                              (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                              ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                              ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                            THEN
                                l_KreditorFreigabe := TRUE
                            ELSE
                                IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                    l_KreditorFreigabe := FALSE;
                            IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                IF (("Externes Stammblatt") AND
                                  ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                                  ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE;

                            IF Cont."POI Shipping Company" THEN BEGIN
                                IF ((Blankobriefkopf) AND ("Externes Stammblatt") AND
                                  (Handelsregisterauszug) AND ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                  ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                                  ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                                THEN
                                    l_KreditorFreigabe := TRUE
                                ELSE
                                    IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                        l_KreditorFreigabe := FALSE;
                                IF lr_Vendor."POI Amtsgericht" = lr_Vendor."POI Amtsgericht"::"not registered" THEN
                                    IF ((Blankobriefkopf) AND ("Externes Stammblatt") AND
                                      ("Kontaktdaten hinterlegt") AND (Zahlungskonditionen) AND
                                      ("Prüfung Kundenunterschrift") AND ("Prüfung ext. Stammblatt") AND
                                      ("Verifikation USt-ID") AND ("Allg Angaben aus Stammblatt"))
                                    THEN
                                        l_KreditorFreigabe := TRUE
                                    ELSE
                                        IF Ausnahmegenehmigung <> Ausnahmegenehmigung::genehmigt THEN
                                            l_KreditorFreigabe := FALSE;
                            END;
                        END;
                END;

                IF l_KreditorFreigabe THEN BEGIN
                    "Freigabe für Kreditor" := TRUE;
                    IF Ausnahmegenehmigung > Ausnahmegenehmigung::" " THEN BEGIN
                        Ausnahmegenehmigung := Ausnahmegenehmigung::" ";
                        "Ausnahmegenehmigung Erinnerung" := 0D;
                        "Ausnahmegenehmigung Ablauf" := 0D;
                    END;
                    // IF GUIALLOWED() THEN
                    //     MESSAGE(MSG_VendUnblockedTxt);
                    // //-hf001
                    // //automatische Freigabe des Kreditoren
                    // case "Source Type" of
                    //     "Source Type"::Vendor:
                    //         begin
                    //             lr_Vendor.Get("No.");
                    //             lr_Vendor.Blocked := lr_Vendor.Blocked::" ";
                    //             lr_Vendor.Modify();
                    //             AccCompSetting.SetReleasedForAccount(lr_Vendor."No.", 2);
                    //         end;
                    //     "Source Type"::Customer:
                    //         Begin
                    //             Customer.Get("No.");
                    //             Customer.Blocked := lr_Vendor.Blocked::" ";
                    //             Customer.Modify();
                    //             AccCompSetting.SetReleasedForAccount(Customer."No.", 1);
                    //         end;
                    // end;
                    //+hf001
                END ELSE BEGIN
                    "Freigabe für Kreditor" := FALSE;
                    MODIFY();
                END;
            END;
        END;
    end;


    procedure CheckException()
    begin
        case Ausnahmegenehmigung of
            Ausnahmegenehmigung::abgelehnt:
                IF "Source Type" = "Source Type"::Vendor THEN BEGIN
                    VALIDATE("Freigabe für Kreditor", FALSE);
                    "Ausnahmegenehmigung Erinnerung" := 0D;
                    "Ausnahmegenehmigung Ablauf" := 0D;
                END ELSE
                    IF "Source Type" = "Source Type"::Customer THEN BEGIN
                        VALIDATE("Freigabe für Debitor", FALSE);
                        "Cust Ausnahmegeneh. Erinnerung" := 0D;
                        "Cust Ausnahmegeneh. Ablauf" := 0D;
                    END;

            Ausnahmegenehmigung::genehmigt:
                IF "Source Type" = "Source Type"::Vendor THEN BEGIN
                    VALIDATE("Freigabe für Kreditor", TRUE);
                    "Ausnahmeg. erteilt durch" := copystr(USERID(), 1, 50);
                    "Ausnahmegenehmigung erteilt am" := WORKDATE();
                    "Ausnahmegenehmigung Erinnerung" := CALCDATE('< +3W >', WORKDATE());
                    "Ausnahmegenehmigung Ablauf" := CALCDATE('< +1M >', WORKDATE());
                END ELSE
                    IF "Source Type" = "Source Type"::Customer THEN BEGIN
                        VALIDATE("Freigabe für Debitor", TRUE);
                        "Cust Ausnahmeg. erteilt durch" := copystr(USERID(), 1, 50);
                        "Cust Ausnahmeg. erteilt am" := WORKDATE();
                        "Cust Ausnahmegeneh. Erinnerung" := CALCDATE('< +3W >', WORKDATE());
                        "Cust Ausnahmegeneh. Ablauf" := CALCDATE('< +1M >', WORKDATE());
                    END;

            Ausnahmegenehmigung::" ":
                IF "Source Type" = "Source Type"::Vendor THEN
                    CheckLFB()
                ELSE
                    IF "Source Type" = "Source Type"::Customer THEN
                        VALIDATE("Freigabe für Debitor", FALSE);
        end;
    end;

    procedure CheckWorkflowTask(TableID: Integer; FieldNo: Integer; NewValue: Variant; New: Boolean)
    begin
        WFTaskLine.SetRange("Account Code", "No.");
        WFTaskLine.SetRange("Table ID", TableID);
        WFTaskLine.SetRange("Field No.", FieldNo);
        WFTaskLine.SetRange(Closed, false);
        if WFTaskLine.FindSet() then
            repeat
                WFMgt.CheckTaskLine(WFTaskLine, NewValue, New);
                WFTask.Get(WFTaskLine."Entry No.");
                WFMgt.CheckTaskStatus(WFTask);
            until WFTaskLine.Next() = 0;
    end;

    procedure SetCreditlimitForVendor()
    begin
        QMDetails.Reset();
        QMDetails.SetRange("No.", "No.");
        QMDetails.SetRange("Source Type", QMDetails."Source Type"::Vendor);
        if QMDetails.FindSet() then
            repeat
                lr_Vendor.ChangeCompany(AccountCompSetting."Company Name");
                if AccountCompSetting.Get(AccountCompSetting."Account Type"::Vendor, "No.", QMDetails.Mandant) then begin
                    if QMDetails."Refund Approved" then begin
                        AccountCompSetting.Refund := QMDetails.Refund;
                        lr_Vendor."POI A.S. Refund Percentage" := QMDetails.Refund;
                    end else begin
                        AccountCompSetting.Refund := 0;
                        lr_Vendor."POI A.S. Refund Percentage" := 0;
                    end;
                    if QMDetails."Credit Limit Approved" then begin
                        AccountCompSetting."Credit Limit" := QMDetails."Credit Limit";
                        lr_Vendor.validate("POI Internal credit limit", QMDetails."Credit Limit");
                    end else begin
                        AccountCompSetting."Credit Limit" := 0;
                        lr_Vendor.Validate("POI Internal credit limit", 0);
                    end;
                    AccountCompSetting.Modify();
                end;
                lr_Vendor.ChangeCompany(AccountCompSetting."Company Name");
            until QMDetails.Next() = 0;
    end;

    procedure SetRefundForAccount(AccountType: Enum "POI Source Type"; AccountNo: Code[20])
    begin
        QMDetails.Reset();
        QMDetails.SetRange("No.", AccountNo);
        QMDetails.SetRange("Source Type", AccountType);
        QMDetails.SetRange("Refund Approved", true);
        if QMDetails.FindSet() then
            repeat
                VendInvDisc.ChangeCompany(QMDetails.Mandant);
                if not VendInvDisc.Get(AccountNo, '', 0) then begin
                    VendInvDisc.Init();
                    VendInvDisc.code := AccountNo;
                    VendInvDisc."Currency Code" := '';
                    VendInvDisc."Minimum Amount" := 0;
                    VendInvDisc."Discount %" := QMDetails.Refund;
                    VendInvDisc.Insert();
                end else begin
                    VendInvDisc."Discount %" := QMDetails.Refund;
                    VendInvDisc.Modify();
                end;
            until QMDetails.Next() = 0;
    end;

    procedure CheckAusnahme()
    var
        UrlTxt: Text;
        TaskGroup: Integer;
        Groups: list of [Text];
        Group: Code[20];
        AccType: Text;
    begin
        Reset();
        SetFilter("Ausnahmegenehmigung Ablauf", '<%1', today());
        SetRange(Ausnahmegenehmigung, Ausnahmegenehmigung::genehmigt);
        if FindSet() then
            repeat
                POICompany.Reset();
                POICompany.SetRange("Synch Masterdata", true);
                if POICompany.FindSet() then
                    repeat
                        "Ausnahmegenehmigung erteilt am" := 0D;
                        "Ausnahmegenehmigung erteilt am" := 0D;
                        WFTask.Reset();
                        case "Source Type" of
                            "Source Type"::Customer:
                                begin
                                    Customer.ChangeCompany(POICompany.Mandant);
                                    Customer.Validate(Blocked, Customer.Blocked::All);
                                    Customer.Modify();
                                    UrlTxt := TeamsMgt.CreateTeamsUrlVendCust(Customer.RecordId, POICompany.Mandant);
                                    WFTask.SetRange(ID, Customer.RecordId);
                                    AccType := 'Kunde';
                                end;
                            "Source Type"::Vendor:
                                begin
                                    Vendor.ChangeCompany(POICompany.Mandant);
                                    Vendor.Validate(Blocked, Vendor.Blocked::All);
                                    Vendor.Modify();
                                    UrlTxt := TeamsMgt.CreateTeamsUrlVendCust(Vendor.RecordId, POICompany.Mandant);
                                    WFTask.SetRange(ID, Vendor.RecordId);
                                    AccType := 'Lieferant';
                                end;
                        end;
                        //Workflow suchen
                        if WFTask.FindLast() then begin
                            WFMgt.CheckTask(WFTask);
                            Commit();
                            Clear(Groups);
                            TaskGroup := WFTask."WF Group No";
                            WFTaskLine.SetRange("WF Group No", WFTask."WF Group No");
                            WFTaskLine.SetRange("Entry No.", WFTask."Entry No.");
                            WFTaskLine.SetRange(Closed, false);
                            if WFTaskLine.findset() then
                                repeat
                                    if not Groups.Contains(WFTaskLine."Task No.") then
                                        Groups.Add(WFTaskLine."Task No.");
                                until WFTaskLine.Next() = 0;
                            if Groups.Count > 0 then
                                foreach Group in Groups do begin
                                    case "Source Type" of
                                        "Source Type"::Customer:
                                            UrlTxt := TeamsMgt.CreateTeamsUrlVendCust(Customer.RecordId, POICompany.Mandant);
                                        "Source Type"::Vendor:
                                            UrlTxt := TeamsMgt.CreateTeamsUrlVendCust(Vendor.RecordId, POICompany.Mandant);
                                    end;
                                    TeamsMgt.SendMessageToTeams(UrlTxt, Group);
                                end;
                        end;
                    until POICompany.Next() = 0;
            until Next() = 0;
    end;

    var
        gr_UserSetup: Record "User Setup";
        lr_Vendor: Record Vendor;
        Vendor: Record Vendor;
        Customer: Record Customer;
        POICompany: Record "POI Company";
        lr_ContBusRel: Record "Contact Business Relation";
        lr_RelPrintDoc: Record "POI Released Print Documents";
        ContBusRel: Record "Contact Business Relation";
        WFTaskLine: Record "POI Workflow Task Line";
        WFTask: Record "POI Workflow Task";
        AccountCompSetting: Record "POI Account Company Setting";
        QMDetails: Record "POI Quality Mgt Detail";
        VendInvDisc: Record "Vendor Invoice Disc.";
        TeamsMgt: Codeunit "POI Teams Management";
        POIFunc: Codeunit POIFunction;
        WFMgt: Codeunit "POI Workflow Management";
        ERR_NoPermissionTxt: Label 'Sie haben keine Berechtigung zum Ändern der Angaben.\Bitte an IT wenden.';
        CON_InternTxt: Label 'Soll das Interne Kreditlimit bestehen bleiben?';
        CON_KreditInternTxt: Label 'Sind Sie sicher, dass Kreditlimit intern größer\    50.000 €\korrekt ist?';
        ERR_InternKreditTxt: Label 'Internes Kreditlimit soll mindestens 1000 € betragen.';
    //MSG_VendUnblockedTxtMSG_VendUnblockedTxt: label 'Kreditor wurde entsperrt.';
}