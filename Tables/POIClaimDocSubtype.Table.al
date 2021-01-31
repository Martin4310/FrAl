table 5087971 "POI Claim Doc. Subtype"
{
    Caption = 'Claim Doc. Subtype';
    // DrillDownFormID = Form5110415;
    // LookupFormID = Form5110415;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Purchase Claim,Sales Claim';
            OptionMembers = "Purchase Claim","Sales Claim";
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;

            trigger OnValidate()
            begin
                InitClaimDocSubtype();
            end;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "In Selection"; Boolean)
        {
            Caption = 'In Selection';
        }
        field(12; "Document No. Series"; Code[10])
        {
            Caption = 'Document No. Series';
            TableRelation = "No. Series";
        }
        field(20; "Form ID List"; Integer)
        {
            Caption = 'Form ID List';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(21; "Form ID Card"; Integer)
        {
            Caption = 'Form ID Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(30; "Allow Scrolling in Card"; Boolean)
        {
            Caption = 'Allow Scrolling in Card';
        }
        field(50; "Claim Possibility"; Option)
        {
            Caption = 'Claim Possibility';
            OptionCaption = 'Price Claim/Retoure,Claim Only,Retoure Only';
            OptionMembers = "Price Claim/Retoure","Claim Only","Retoure Only";
        }
        field(70; "Action On Registry"; Option)
        {
            BlankNumbers = BlankZero;
            OptionCaption = ' ,Abfrage zum Öffnen der Gutschrift,Direktes Öffnen der Gutschrift';
            OptionMembers = " ","Question to Open Credit Memo","Direkt Open Credit Memo";
        }
    }

    keys
    {
        key(Key1; "Document Type", "Code")
        {
        }
    }

    procedure InitClaimDocSubtype()
    var
        lrc_ClaimDocSubtype: Record "POI Claim Doc. Subtype";

        ldg_Window: Dialog;
        lin_TotalRecNo: Integer;
        lin_RecNo: Integer;
        AGILESText001Txt: Label 'Init all Purch. Claims with the value %1?', Comment = '%1';
        AGILESText002Txt: Label 'Updating Purch. Claims for Document Subtyes:';
        AGILESText003Txt: Label 'Init all Sales Claims with the value %1?', Comment = '%1';
        AGILESText004Txt: Label 'Updating Sales Claims for Document Subtyes:';
        AGILESText005Txt: Label 'Cancellation by User.';
    begin
        IF Code <> '' THEN
            CASE "Document Type" OF

                "Document Type"::"Purchase Claim":
                    BEGIN

                        lrc_PurchClaimHeader.RESET();
                        IF lrc_PurchClaimHeader.ISEMPTY() THEN
                            EXIT;

                        lrc_ClaimDocSubtype.RESET();
                        lrc_ClaimDocSubtype.SETRANGE("Document Type", lrc_ClaimDocSubtype."Document Type"::"Purchase Claim");
                        IF lrc_ClaimDocSubtype.ISEMPTY() THEN BEGIN
                            lrc_PurchClaimHeader.RESET();
                            lrc_PurchClaimHeader.SETCURRENTKEY("Claim Doc. Subtype Code");
                            lrc_PurchClaimHeader.SETFILTER("Claim Doc. Subtype Code", '<>%1', '');
                            IF lrc_PurchClaimHeader.ISEMPTY() THEN
                                // Rekl. Belegunterarten initialisieren
                                IF CONFIRM(AGILESText001Txt, TRUE, Code) THEN BEGIN
                                    ldg_Window.OPEN(AGILESText002Txt + '@1@@@@@@@@@@@@@@@@@@@@@\');
                                    ldg_Window.UPDATE(1, 0);
                                    lin_TotalRecNo := 0;
                                    lin_RecNo := 0;

                                    // registrierte und unregistrierte Belege aktualisieren (KOPF)
                                    lrc_PurchClaimHeader.RESET();
                                    IF lrc_PurchClaimHeader.FIND('-') THEN BEGIN
                                        lin_TotalRecNo := lrc_PurchClaimHeader.COUNTAPPROX();
                                        REPEAT
                                            lrc_PurchClaimHeader."Claim Doc. Subtype Code" := Code;
                                            lrc_PurchClaimHeader.MODIFY();
                                            lin_RecNo := lin_RecNo + 1;
                                            ldg_Window.UPDATE(1, ROUND(lin_RecNo / lin_TotalRecNo * 10000, 1));
                                        UNTIL lrc_PurchClaimHeader.NEXT() = 0;
                                    END;

                                    // registrierte und unregistrierte Belege aktualisieren (Zeilen)
                                    lrc_PurchClaimLine.RESET();
                                    IF lrc_PurchClaimLine.FIND('-') THEN BEGIN
                                        lin_TotalRecNo := lrc_PurchClaimLine.COUNTAPPROX();
                                        REPEAT
                                            lrc_PurchClaimLine."Claim Doc. Subtype Code" := Code;
                                            lrc_PurchClaimLine.MODIFY();
                                            lin_RecNo := lin_RecNo + 1;
                                            ldg_Window.UPDATE(1, ROUND(lin_RecNo / lin_TotalRecNo * 10000, 1));
                                        UNTIL lrc_PurchClaimLine.NEXT() = 0;
                                    END;

                                    ldg_Window.CLOSE();

                                END ELSE
                                    ERROR(AGILESText005Txt);
                        END;

                    END;
                "Document Type"::"Sales Claim":
                    BEGIN
                        lrc_SalesClaimHeader.RESET();
                        IF lrc_SalesClaimHeader.ISEMPTY() THEN
                            EXIT;

                        lrc_ClaimDocSubtype.RESET();
                        lrc_ClaimDocSubtype.SETRANGE("Document Type", lrc_ClaimDocSubtype."Document Type"::"Sales Claim");
                        IF lrc_ClaimDocSubtype.ISEMPTY() THEN BEGIN
                            lrc_SalesClaimHeader.RESET();
                            lrc_SalesClaimHeader.SETCURRENTKEY("Claim Doc. Subtype Code");
                            lrc_SalesClaimHeader.SETFILTER("Claim Doc. Subtype Code", '<>%1', '');
                            IF lrc_SalesClaimHeader.ISEMPTY() THEN
                                // Rekl. Belegunterarten initialisieren
                                IF CONFIRM(AGILESText003Txt, TRUE, Code) THEN BEGIN
                                    ldg_Window.OPEN(AGILESText004Txt + '@1@@@@@@@@@@@@@@@@@@@@@\');
                                    ldg_Window.UPDATE(1, 0);
                                    lin_TotalRecNo := 0;
                                    lin_RecNo := 0;

                                    // registrierte und unregistrierte Belege aktualisieren (KOPF)
                                    lrc_SalesClaimHeader.RESET();
                                    IF lrc_SalesClaimHeader.FIND('-') THEN BEGIN
                                        lin_TotalRecNo := lrc_SalesClaimHeader.COUNTAPPROX();
                                        REPEAT
                                            lrc_SalesClaimHeader."Claim Doc. Subtype Code" := Code;
                                            lrc_SalesClaimHeader.MODIFY();
                                            lin_RecNo := lin_RecNo + 1;
                                            ldg_Window.UPDATE(1, ROUND(lin_RecNo / lin_TotalRecNo * 10000, 1));
                                        UNTIL lrc_SalesClaimHeader.NEXT() = 0;
                                    END;

                                    // registrierte und unregistrierte Belege aktualisieren (Zeilen)
                                    lrc_SalesClaimLine.RESET();
                                    IF lrc_SalesClaimLine.FIND('-') THEN BEGIN
                                        lin_TotalRecNo := lrc_SalesClaimLine.COUNTAPPROX();
                                        REPEAT
                                            lrc_SalesClaimLine."Claim Doc. Subtype Code" := Code;
                                            lrc_SalesClaimLine.MODIFY();
                                            lin_RecNo := lin_RecNo + 1;
                                            ldg_Window.UPDATE(1, ROUND(lin_RecNo / lin_TotalRecNo * 10000, 1));
                                        UNTIL lrc_SalesClaimLine.NEXT() = 0;
                                    END;

                                    ldg_Window.CLOSE();

                                END ELSE
                                    ERROR(AGILESText005Txt);

                        END;
                    END;
            END;
    end;

    procedure SelectClaimDocSubtype(vin_DocumentType: Integer): Code[10]
    var
        lrc_ClaimDocSubtypeFilter: Record "POI Claim Doc. Subtype Filter";
        lrc_ClaimDocSubtype: Record "POI Claim Doc. Subtype";
        lrc_UserSetup: Record "User Setup";
        //lfm_ClaimDocSubtypeList: Form "5110415";
        lco_ClaimDocTypeFilter: Code[1024];
        lbn_UserFilterClaimDocSubtype: Boolean;
    begin
        // Initialisierung
        lbn_UserFilterClaimDocSubtype := FALSE;
        lco_ClaimDocTypeFilter := '';

        // Filterung vorbereiten
        lrc_ClaimDocSubtype.RESET();
        lrc_ClaimDocSubtype.FILTERGROUP(2);
        lrc_ClaimDocSubtype.SETRANGE("Document Type", vin_DocumentType);
        lrc_ClaimDocSubtype.SETRANGE("In Selection", TRUE);

        // Benutzereinrichtung auf gesetzte Eingrenzungen überprüfen - Filter ggf. aufbauen
        IF lrc_UserSetup.GET(USERID()) THEN
            //xx  IF lrc_UserSetup."Sales Doc. Subtype Filter" <> '' THEN BEGIN
            //xx    lrc_ClaimDocSubtype.SETFILTER(Code,lrc_UserSetup."Sales Claim Doc. Sub. Filter");
            //xx  END ELSE BEGIN
            lbn_UserFilterClaimDocSubtype := TRUE
        //xx  END;
        ELSE
            lbn_UserFilterClaimDocSubtype := TRUE;


        IF lbn_UserFilterClaimDocSubtype = TRUE THEN BEGIN
            lrc_ClaimDocSubtypeFilter.RESET();
            lrc_ClaimDocSubtypeFilter.SETRANGE("Document Type", vin_DocumentType);
            lrc_ClaimDocSubtypeFilter.SETRANGE(Source, lrc_ClaimDocSubtypeFilter.Source::UserID);
            lrc_ClaimDocSubtypeFilter.SETRANGE("Source No.", USERID());
            lrc_ClaimDocSubtypeFilter.SETRANGE("Not Allowed", FALSE);
            IF lrc_ClaimDocSubtypeFilter.FIND('-') THEN BEGIN

                // definierte Belegunterarten für diesen User
                REPEAT
                    IF lco_ClaimDocTypeFilter = '' THEN
                        lco_ClaimDocTypeFilter := lrc_ClaimDocSubtypeFilter."Claim Doc. Subtype Code"
                    ELSE
                        lco_ClaimDocTypeFilter := copystr(lco_ClaimDocTypeFilter + '|' + lrc_ClaimDocSubtypeFilter."Claim Doc. Subtype Code", 1, 1024);

                UNTIL lrc_ClaimDocSubtypeFilter.NEXT() = 0;

                // Filter anwenden
                IF lco_ClaimDocTypeFilter <> '' THEN
                    lrc_ClaimDocSubtype.SETFILTER(Code, lco_ClaimDocTypeFilter);

            END ELSE BEGIN

                // keine definierte Belegunterarten für diesen User. Gibt es welche für die
                // der User ausgeschlossen ist, dann nur auf zulässige Belegunterarten filtern
                lrc_ClaimDocSubtypeFilter.RESET();
                lrc_ClaimDocSubtypeFilter.SETRANGE("Document Type", vin_DocumentType);
                lrc_ClaimDocSubtypeFilter.SETRANGE(Source, lrc_ClaimDocSubtypeFilter.Source::UserID);
                lrc_ClaimDocSubtypeFilter.SETRANGE("Source No.", USERID());
                lrc_ClaimDocSubtypeFilter.SETRANGE("Not Allowed", TRUE);
                IF lrc_ClaimDocSubtypeFilter.FIND('-') THEN BEGIN

                    lrc_ClaimDocSubtype2.RESET();
                    lrc_ClaimDocSubtype2.SETRANGE("Document Type", lrc_ClaimDocSubtypeFilter."Document Type");
                    lrc_ClaimDocSubtype2.SETRANGE("In Selection", TRUE);
                    IF lrc_ClaimDocSubtype2.FIND('-') THEN
                        REPEAT
                            lrc_ClaimDocSubtypeFilter.RESET();
                            lrc_ClaimDocSubtypeFilter.SETRANGE("Document Type", lrc_ClaimDocSubtype2."Document Type");
                            lrc_ClaimDocSubtypeFilter.SETRANGE("Claim Doc. Subtype Code", lrc_ClaimDocSubtype2.Code);
                            lrc_ClaimDocSubtypeFilter.SETRANGE(Source, lrc_ClaimDocSubtypeFilter.Source::UserID);
                            lrc_ClaimDocSubtypeFilter.SETRANGE("Source No.", USERID());
                            lrc_ClaimDocSubtypeFilter.SETRANGE("Not Allowed", TRUE);
                            IF lrc_ClaimDocSubtypeFilter.ISEMPTY() THEN
                                IF lco_ClaimDocTypeFilter = '' THEN
                                    lco_ClaimDocTypeFilter := lrc_ClaimDocSubtype2.Code
                                ELSE
                                    lco_ClaimDocTypeFilter := copystr(lco_ClaimDocTypeFilter + '|' + lrc_ClaimDocSubtype2.Code, 1, 1024);
                        UNTIL lrc_ClaimDocSubtype2.NEXT() = 0;

                    // Filter anwenden
                    IF lco_ClaimDocTypeFilter <> '' THEN
                        lrc_ClaimDocSubtype.SETFILTER(Code, lco_ClaimDocTypeFilter);

                END;
            END;
        END;

        // ggf. Auswahlform öffnen
        lrc_ClaimDocSubtype.FILTERGROUP(0);
        // IF lrc_ClaimDocSubtype.COUNT() > 1 THEN BEGIN //TODO: page

        //     CLEAR(lfm_ClaimDocSubtypeList);
        //     lfm_ClaimDocSubtypeList.LOOKUPMODE := TRUE;
        //     lfm_ClaimDocSubtypeList.SETTABLEVIEW(lrc_ClaimDocSubtype);
        //     IF lfm_ClaimDocSubtypeList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        //         lrc_ClaimDocSubtype.RESET();
        //         lfm_ClaimDocSubtypeList.GETRECORD(lrc_ClaimDocSubtype);
        //     END ELSE
        //         EXIT('');

        // END ELSE
        //     lrc_ClaimDocSubtype.FIND('-');

        EXIT(lrc_ClaimDocSubtype.Code)
    end;

    var
        lrc_PurchClaimHeader: Record "POI Purch. Claim Notify Header";
        lrc_PurchClaimLine: Record "POI Purch. Claim Notify Line";
        lrc_SalesClaimHeader: Record "POI Sales Claim Notify Header";
        lrc_SalesClaimLine: Record "POI Sales Claim Notify Line";
        lrc_ClaimDocSubtype2: Record "POI Claim Doc. Subtype";
}

