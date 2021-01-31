codeunit 5110324 "POI Sales Mgt"
{

    //     Permissions = TableData 32=rm,
    //                   TableData 37=rimd,
    //                   TableData 110=rm,
    //                   TableData 111=rm;

    //     trigger OnRun()
    //     begin
    //     end;

    //     var
    //         gco_FixChangedCustomerNo: Code[20];

    procedure ShowSalesOrder(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vbn_GlobalCard: Boolean; vbn_ShowWhseCard: Boolean)
    var
        lrc_SalesDocType: Record "POI Sales Doc. Subtype";
        lrc_SalesHdr: Record "Sales Header";
        lcu_GlobalVariablesMgt: Codeunit "POI Global Variables Mgt.";
        lcu_ReleaseSalesDocument: Codeunit "Release Sales Document";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum öffnen eines Verkaufauftrages aus der Übersicht
        // -----------------------------------------------------------------------------

        lrc_SalesHdr.GET(vop_DocType, vco_DocNo);
        lrc_SalesDocType.GET(lrc_SalesHdr."Document Type", lrc_SalesHdr."POI Sales Doc. Subtype Code");
        lrc_SalesDocType.TESTFIELD("Form ID Card");

        // Status auf offen setzen
        IF lrc_SalesDocType."Set Status to Open" = TRUE THEN
            IF lrc_SalesHdr.Status = lrc_SalesHdr.Status::Released THEN
                lcu_ReleaseSalesDocument.Reopen(lrc_SalesHdr);

        IF vbn_GlobalCard = TRUE THEN
            lrc_SalesDocType.TESTFIELD("Form ID Global Card");

        IF lrc_SalesDocType."Allow Scrolling in Card" = FALSE THEN BEGIN
            lrc_SalesHdr.FILTERGROUP(2);
            lrc_SalesHdr.SETRANGE("Document Type", lrc_SalesHdr."Document Type");
            lrc_SalesHdr.SETRANGE("No.", lrc_SalesHdr."No.");
            lrc_SalesHdr.SETRANGE("POI Sales Doc. Subtype Code", lrc_SalesHdr."POI Sales Doc. Subtype Code");
            lrc_SalesHdr.FILTERGROUP(0);
        END ELSE BEGIN
            lrc_SalesHdr.FILTERGROUP(2);
            lrc_SalesHdr.SETRANGE("Document Type", lrc_SalesHdr."Document Type");
            lrc_SalesHdr.SETRANGE("POI Sales Doc. Subtype Code", lrc_SalesHdr."POI Sales Doc. Subtype Code");
            lrc_SalesHdr.FILTERGROUP(0);
        END;

        lcu_GlobalVariablesMgt.SetDirectCall(TRUE);

        IF vbn_GlobalCard = TRUE THEN
            Page.RUN(lrc_SalesDocType."Form ID Global Card", lrc_SalesHdr)
        ELSE
            IF vbn_ShowWhseCard = TRUE THEN
                Page.RUN(lrc_SalesDocType."Form ID Card in Whse.", lrc_SalesHdr)
            ELSE
                Page.RUN(lrc_SalesDocType."Form ID Card", lrc_SalesHdr);
    end;

    //     procedure ShowSalesOrderArchive(var rrc_SalesHeaderArchive: Record "5107")
    //     var
    //         lrc_SalesHeaderArchive: Record "5107";
    //         lcu_GlobalVariablesMgt: Codeunit "5110358";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum öffnen eines Verkaufarchives aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         lrc_SalesHeaderArchive.GET(rrc_SalesHeaderArchive."Document Type",
    //                                    rrc_SalesHeaderArchive."No.",
    //                                    rrc_SalesHeaderArchive."Doc. No. Occurrence",
    //                                    rrc_SalesHeaderArchive."Version No.");
    //         lrc_SalesHeaderArchive.FILTERGROUP(2);
    //         lrc_SalesHeaderArchive.SETRANGE("Document Type",lrc_SalesHeaderArchive."Document Type");
    //         lrc_SalesHeaderArchive.SETRANGE("No.",lrc_SalesHeaderArchive."No.");
    //         lrc_SalesHeaderArchive.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHeaderArchive."Sales Doc. Subtype Code");
    //         lrc_SalesHeaderArchive.FILTERGROUP(0);

    //         CASE lrc_SalesHeaderArchive."Document Type" OF
    //           lrc_SalesHeaderArchive."Document Type"::Order:
    //             FORM.RUN(FORM::Form5088127,lrc_SalesHeaderArchive);
    //           lrc_SalesHeaderArchive."Document Type"::Quote:
    //             FORM.RUN(FORM::"Sales Quote Archive",lrc_SalesHeaderArchive);
    //           lrc_SalesHeaderArchive."Document Type"::"Blanket Order":
    //             FORM.RUN(FORM::"Blanket Sales Order Archive",lrc_SalesHeaderArchive);
    //         END;
    //     end;

    //     procedure NewSalesOrder(vco_SalesDocType: Code[10];vco_CustomerNo: Code[20])
    //     var
    //         lrc_SalesHdr: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         lfm_SalesDocSubtype: Form "5110411";
    //         AGILES_TEXT001: Label 'Auftragsanlage nur mit Auftragsunterbelegart zulässig!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Anlegen eines Auftrages aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         // Auswahl einer Belegart über Auswahlfenster
    //         IF vco_SalesDocType = '' THEN BEGIN
    //           lrc_SalesDocType.Reset();
    //           lrc_SalesDocType.FILTERGROUP(2);
    //           lrc_SalesDocType.SETRANGE("Document Type",lrc_SalesDocType."Document Type"::Order);
    //           lrc_SalesDocType.SETRANGE("In Selection",TRUE);
    //           lrc_SalesDocType.FILTERGROUP(0);
    //           IF lrc_SalesDocType.COUNT() = 1 THEN BEGIN
    //             lrc_SalesDocType.FINDFIRST;
    //           END ELSE BEGIN
    //             lfm_SalesDocSubtype.LOOKUPMODE := TRUE;
    //             lfm_SalesDocSubtype.SETTABLEVIEW(lrc_SalesDocType);
    //             IF lfm_SalesDocSubtype.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lfm_SalesDocSubtype.GETRECORD(lrc_SalesDocType);
    //             IF lrc_SalesDocType.Code = '' THEN
    //               EXIT;
    //           END;
    //           vco_SalesDocType := lrc_SalesDocType.Code;
    //         END;

    //         IF vco_SalesDocType = '' THEN
    //           // Auftragsanlage nur mit Auftragsunterbelegart zulässig!
    //           ERROR(AGILES_TEXT001);

    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Order,vco_SalesDocType);

    //         lrc_SalesHdr.Reset();
    //         lrc_SalesHdr.INIT();
    //         lrc_SalesHdr.VALIDATE("Document Type",lrc_SalesHdr."Document Type"::Order);
    //         lrc_SalesHdr."Sales Doc. Subtype Code" := vco_SalesDocType;
    //         IF lrc_SalesDocType."Quality Control Vendor No." <> '' THEN BEGIN
    //           lrc_SalesHdr.VALIDATE("Quality Control Vendor No.", lrc_SalesDocType."Quality Control Vendor No.");
    //         END;
    //         lrc_SalesHdr.INSERT(TRUE);

    //         IF (lrc_SalesDocType."Default Location Code" <> '') OR
    //            (vco_CustomerNo <> '') THEN BEGIN
    //           IF vco_CustomerNo <> '' THEN BEGIN
    //             lrc_SalesHdr.VALIDATE("Sell-to Customer No.",vco_CustomerNo);
    //           END;
    //           IF lrc_SalesDocType."Default Location Code" <> '' THEN BEGIN
    //             lrc_SalesHdr.VALIDATE("Location Code",lrc_SalesDocType."Default Location Code");
    //           END;
    //           lrc_SalesHdr.Modify();
    //         END;

    //         ShowSalesOrder(lrc_SalesHdr."Document Type",lrc_SalesHdr."No.",FALSE,FALSE);
    //     end;

    //     procedure NewSalesOrderWithCust(vco_SalesDocType: Code[10];vco_CustNo: Code[20])
    //     var
    //         lrc_SalesHdr: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         lfm_SalesDocSubtype: Form "5110411";
    //         AGILES_TEXT001: Label 'Auftragsanlage nur mit Auftragsunterbelegart zulässig!';
    //         AGILES_TEXT002: Label 'Debitorennummer nicht übergeben!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Anlegen eines Auftrages aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         IF vco_CustNo = '' THEN
    //           // Debitorennummer nicht übergeben!
    //           ERROR(AGILES_TEXT002);

    //         // Auswahl einer Belegart über Auswahlfenster
    //         IF vco_SalesDocType = '' THEN BEGIN
    //           lrc_SalesDocType.Reset();
    //           lrc_SalesDocType.FILTERGROUP(2);
    //           lrc_SalesDocType.SETRANGE("Document Type",lrc_SalesDocType."Document Type"::Order);
    //           lrc_SalesDocType.SETRANGE("In Selection",TRUE);
    //           lrc_SalesDocType.FILTERGROUP(0);
    //           IF lrc_SalesDocType.COUNT() = 1 THEN BEGIN
    //             lrc_SalesDocType.FINDFIRST;
    //           END ELSE BEGIN
    //             lfm_SalesDocSubtype.LOOKUPMODE := TRUE;
    //             lfm_SalesDocSubtype.SETTABLEVIEW(lrc_SalesDocType);
    //             IF lfm_SalesDocSubtype.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lfm_SalesDocSubtype.GETRECORD(lrc_SalesDocType);
    //             IF lrc_SalesDocType.Code = '' THEN
    //               EXIT;
    //           END;
    //           vco_SalesDocType := lrc_SalesDocType.Code;
    //         END;

    //         IF vco_SalesDocType = '' THEN
    //           // Auftragsanlage nur mit Auftragsunterbelegart zulässig!
    //           ERROR(AGILES_TEXT001);

    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Order,vco_SalesDocType);

    //         lrc_SalesHdr.Reset();
    //         lrc_SalesHdr.INIT();
    //         lrc_SalesHdr.VALIDATE("Document Type",lrc_SalesHdr."Document Type"::Order);
    //         lrc_SalesHdr."Sales Doc. Subtype Code" := vco_SalesDocType;
    //         IF lrc_SalesDocType."Quality Control Vendor No." <> '' THEN BEGIN
    //           lrc_SalesHdr.VALIDATE("Quality Control Vendor No.", lrc_SalesDocType."Quality Control Vendor No.");
    //         END;
    //         lrc_SalesHdr.INSERT(TRUE);

    //         lrc_SalesHdr.VALIDATE("Sell-to Customer No.",vco_CustNo);
    //         lrc_SalesHdr.Modify();

    //         IF lrc_SalesDocType."Default Location Code" <> '' THEN BEGIN
    //           lrc_SalesHdr.VALIDATE("Location Code",lrc_SalesDocType."Default Location Code");
    //           lrc_SalesHdr.Modify();
    //         END;

    //         ShowSalesOrder(lrc_SalesHdr."Document Type",lrc_SalesHdr."No.",FALSE,FALSE);
    //     end;

    //     procedure NewSalesReturn(vco_SalesDocType: Code[10])
    //     var
    //         lrc_SalesHdr: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         lfm_SalesDocSubtype: Form "5110411";
    //         AGILES_TEXT001: Label 'Auftragsanlage nur mit Auftragsbelegart zulässig!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Anlegen eines Auftrages aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         // Auswahl einer Belegart über Auswahlfenster
    //         IF vco_SalesDocType = '' THEN BEGIN
    //           lrc_SalesDocType.Reset();
    //           lrc_SalesDocType.FILTERGROUP(2);
    //           lrc_SalesDocType.SETRANGE("Document Type",lrc_SalesDocType."Document Type"::"Return Order");
    //           lrc_SalesDocType.SETRANGE("In Selection",TRUE);
    //           lrc_SalesDocType.FILTERGROUP(0);
    //           IF lrc_SalesDocType.COUNT() = 1 THEN BEGIN
    //             lrc_SalesDocType.FINDFIRST;
    //           END ELSE BEGIN
    //             lfm_SalesDocSubtype.LOOKUPMODE := TRUE;
    //             lfm_SalesDocSubtype.SETTABLEVIEW(lrc_SalesDocType);
    //             IF lfm_SalesDocSubtype.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lfm_SalesDocSubtype.GETRECORD(lrc_SalesDocType);
    //             IF lrc_SalesDocType.Code = '' THEN
    //               EXIT;
    //           END;
    //           vco_SalesDocType := lrc_SalesDocType.Code;
    //         END;

    //         IF vco_SalesDocType = '' THEN
    //           // Auftragsanlage nur mit Auftragsbelegart zulässig!
    //           ERROR(AGILES_TEXT001);

    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::"Return Order",vco_SalesDocType);

    //         lrc_SalesHdr.Reset();
    //         lrc_SalesHdr.INIT();
    //         lrc_SalesHdr.VALIDATE("Document Type",lrc_SalesHdr."Document Type"::"Return Order");
    //         lrc_SalesHdr."Sales Doc. Subtype Code" := vco_SalesDocType;
    //         IF lrc_SalesDocType."Quality Control Vendor No." <> '' THEN BEGIN
    //           lrc_SalesHdr.VALIDATE("Quality Control Vendor No.", lrc_SalesDocType."Quality Control Vendor No.");
    //         END;
    //         lrc_SalesHdr.INSERT(TRUE);

    //         IF lrc_SalesDocType."Default Location Code" <> '' THEN BEGIN
    //           lrc_SalesHdr.VALIDATE("Location Code",lrc_SalesDocType."Default Location Code");
    //           lrc_SalesHdr.Modify();
    //         END;

    //         ShowSalesOrder(lrc_SalesHdr."Document Type",lrc_SalesHdr."No.",FALSE,FALSE);
    //     end;

    //     procedure NewSalesQuote(vco_SalesDocType: Code[10])
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         lfm_SalesDocSubtype: Form "5110411";
    //         AGILESText001: Label 'Create only with the Subtype allowed.';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Anlegen eines Angebotes aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         // Auswahl einer Belegart über Auswahlfenster
    //         IF vco_SalesDocType = '' THEN BEGIN
    //           lrc_SalesDocType.Reset();
    //           lrc_SalesDocType.FILTERGROUP(2);
    //           lrc_SalesDocType.SETRANGE("Document Type",lrc_SalesDocType."Document Type"::Quote);
    //           lrc_SalesDocType.SETRANGE("In Selection",TRUE);
    //           lrc_SalesDocType.FILTERGROUP(0);
    //           IF lrc_SalesDocType.COUNT() = 1 THEN BEGIN
    //             lrc_SalesDocType.FINDFIRST;
    //           END ELSE BEGIN
    //             lfm_SalesDocSubtype.LOOKUPMODE := TRUE;
    //             lfm_SalesDocSubtype.SETTABLEVIEW(lrc_SalesDocType);
    //             IF lfm_SalesDocSubtype.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lfm_SalesDocSubtype.GETRECORD(lrc_SalesDocType);
    //             IF lrc_SalesDocType.Code = '' THEN
    //               EXIT;
    //           END;
    //           vco_SalesDocType := lrc_SalesDocType.Code;
    //         END;

    //         IF vco_SalesDocType = '' THEN BEGIN
    //           // Angebotsanlage nur mit Angebotsbelegart zulässig
    //           ERROR(AGILESText001);
    //         END;

    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Quote,vco_SalesDocType);

    //         lrc_SalesHeader.INIT();
    //         lrc_SalesHeader.VALIDATE("Document Type",lrc_SalesHeader."Document Type"::Quote);
    //         lrc_SalesHeader."Sales Doc. Subtype Code" := vco_SalesDocType;
    //         IF lrc_SalesDocType."Quality Control Vendor No." <> '' THEN BEGIN
    //           lrc_SalesHeader.VALIDATE("Quality Control Vendor No.", lrc_SalesDocType."Quality Control Vendor No.");
    //         END;
    //         lrc_SalesHeader.INSERT(TRUE);

    //         IF lrc_SalesDocType."Default Location Code" <> '' THEN BEGIN
    //           lrc_SalesHeader.VALIDATE("Location Code",lrc_SalesDocType."Default Location Code");
    //           lrc_SalesHeader.Modify();
    //         END;

    //         ShowSalesOrder(lrc_SalesHeader."Document Type",lrc_SalesHeader."No.",FALSE,FALSE);
    //     end;

    //     procedure ShowSalesLineCard(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20])
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum öffnen
    //         // -----------------------------------------------------------------------------
    //     end;

    //     procedure ShowSalesPickingOrder(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20])
    //     var
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_SalesHdr: Record "36";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum öffnen
    //         // -----------------------------------------------------------------------------

    //         lrc_SalesHdr.GET(vop_DocType,vco_DocNo);
    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::"Picking Order",lrc_SalesHdr."Sales Doc. Subtype Code");
    //         lrc_SalesDocType.TESTFIELD("Form ID Card");

    //         IF lrc_SalesDocType."Allow Scrolling in Card" = FALSE THEN BEGIN
    //           lrc_SalesHdr.FILTERGROUP(2);
    //           lrc_SalesHdr.SETRANGE("Document Type",lrc_SalesHdr."Document Type");
    //           lrc_SalesHdr.SETRANGE("No.",lrc_SalesHdr."No.");
    //           lrc_SalesHdr.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHdr."Sales Doc. Subtype Code");
    //           lrc_SalesHdr.SETFILTER("Document Status",'%1|%2',lrc_SalesHdr."Document Status"::"Freigabe Kommissionierung",
    //                                                    lrc_SalesHdr."Document Status"::Kommissionierung);
    //           lrc_SalesHdr.FILTERGROUP(0);
    //         END ELSE BEGIN
    //           lrc_SalesHdr.FILTERGROUP(2);
    //           lrc_SalesHdr.SETRANGE("Document Type",lrc_SalesHdr."Document Type");
    //           lrc_SalesHdr.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHdr."Sales Doc. Subtype Code");
    //           lrc_SalesHdr.SETFILTER("Document Status",'%1|%2',lrc_SalesHdr."Document Status"::"Freigabe Kommissionierung",
    //                                                    lrc_SalesHdr."Document Status"::Kommissionierung);
    //           lrc_SalesHdr.FILTERGROUP(0);
    //         END;
    //         FORM.RUN(lrc_SalesDocType."Form ID Card",lrc_SalesHdr);
    //     end;

    //     procedure SalesSplitLine(vrc_SalesLine: Record "37")
    //     var
    //         lcu_CheckPostingMgt: Codeunit "5087911";
    //         lcu_SalesPost: Codeunit "80";
    //         lcu_ReleaseSalesDocument: Codeunit "414";
    //         lcu_UndoPostingMgt: Codeunit "5110367";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_FruitVisionTempI: Record "5110360";
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesLine2: Record "37";
    //         lrc_SalesLineAttached: Record "37";
    //         lrc_SalesShipmentLine: Record "111";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesHeaderNew: Record "36";
    //         lrc_SalesLineTemp: Record "37" temporary;
    //         lfm_SalesSplittLine: Form "5110324";
    //         ldc_ShippedQuantity: Decimal;
    //         ldc_ShipQuantitySource: Decimal;
    //         ldc_ShipQuantityTarget: Decimal;
    //         lin_LineNo: Integer;
    //         lin_SourceLineNo: Integer;
    //         lin_TargetLineNo: Integer;
    //         lbn_Ship: Boolean;
    //         AGILES_LT_TEXT001: Label 'Splittung nur für Artikelzeilen möglich!';
    //         AGILES_LT_TEXT002: Label 'Restbestellungsmenge muss größer Null sein!';
    //         AGILES_LT_TEXT003: Label 'Es kann maximal die ungelieferte Menge gesplittet werden!';
    //         AGILES_LT_TEXT004: Label 'Menge für Splittung nicht ausreichend. (Restauftragsmenge + letzter Warenausgang)';
    //         lrc_DocumentDim: Record "357";
    //         lrc_DocumentDim2: Record "357";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zum Splitten einer Verkaufszeile
    //         // --------------------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') THEN
    //           // Splittung nur für Artikelzeilen möglich!
    //           ERROR(AGILES_LT_TEXT001);
    //         IF vrc_SalesLine."Outstanding Quantity" = 0 THEN
    //           // Restbestellungsmenge muss größer Null sein!
    //           ERROR(AGILES_LT_TEXT002);

    //         lrc_FruitVisionTempI.Reset();
    //         lrc_FruitVisionTempI.SETRANGE("User ID",UserID());
    //         lrc_FruitVisionTempI.SETRANGE("Entry Type",lrc_FruitVisionTempI."Entry Type"::EZS);
    //         lrc_FruitVisionTempI.DELETEALL();

    //         lrc_FruitVisionTempI.Reset();
    //         lrc_FruitVisionTempI.INIT();
    //         lrc_FruitVisionTempI."User ID" := USERID;
    //         lrc_FruitVisionTempI."Entry Type" := lrc_FruitVisionTempI."Entry Type"::EZS;
    //         lrc_FruitVisionTempI."Entry No." := 0;
    //         lrc_FruitVisionTempI."EZS Doc. No." := vrc_SalesLine."Document No.";
    //         lrc_FruitVisionTempI."EZS Item No." := vrc_SalesLine."No.";
    //         lrc_FruitVisionTempI."EZS Master Batch No." := vrc_SalesLine."Master Batch No.";
    //         lrc_FruitVisionTempI."EZS Batch No." := vrc_SalesLine."Batch No.";
    //         lrc_FruitVisionTempI."EZS Batch Variant No." := vrc_SalesLine."Batch Variant No.";
    //         lrc_FruitVisionTempI."EZS Location Code" := vrc_SalesLine."Location Code";
    //         lrc_FruitVisionTempI."EZS Unit of Measure Code" := vrc_SalesLine."Unit of Measure Code";
    //         lrc_FruitVisionTempI."EZS Quantity" := vrc_SalesLine.Quantity;
    //         lrc_FruitVisionTempI."EZS Remaining Quantity" := vrc_SalesLine."Outstanding Quantity";
    //         lrc_FruitVisionTempI."EZS Splitt Quantity" := 0;
    //         lrc_FruitVisionTempI."EZS Splitt Location Code" := vrc_SalesLine."Location Code";
    //         lrc_FruitVisionTempI."EZS Info 1" := vrc_SalesLine."Info 1";
    //         lrc_FruitVisionTempI."EZS Info 2" := vrc_SalesLine."Info 2";
    //         lrc_FruitVisionTempI."EZS Info 3" := vrc_SalesLine."Info 3";
    //         lrc_FruitVisionTempI."EZS Info 4" := vrc_SalesLine."Info 4";
    //         lrc_FruitVisionTempI."EZS Price" := vrc_SalesLine."Sales Price (Price Base)";
    //         lrc_FruitVisionTempI.insert();
    //         COMMIT;

    //         lrc_FruitVisionTempI.FILTERGROUP(2);
    //         lrc_FruitVisionTempI.SETRANGE("User ID",lrc_FruitVisionTempI."User ID");
    //         lrc_FruitVisionTempI.SETRANGE("Entry Type",lrc_FruitVisionTempI."Entry Type");
    //         lrc_FruitVisionTempI.SETRANGE("Entry No.",lrc_FruitVisionTempI."Entry No.");
    //         lrc_FruitVisionTempI.FILTERGROUP(0);

    //         lfm_SalesSplittLine.LOOKUPMODE := TRUE;
    //         lfm_SalesSplittLine.SETTABLEVIEW(lrc_FruitVisionTempI);
    //         IF lfm_SalesSplittLine.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_FruitVisionTempI.Reset();
    //         lfm_SalesSplittLine.GETRECORD(lrc_FruitVisionTempI);
    //         IF lrc_FruitVisionTempI."EZS Splitt Quantity" <= 0 THEN
    //           EXIT;

    //         IF lrc_FruitVisionTempI."EZS Splitt Quantity" > vrc_SalesLine."Outstanding Quantity" THEN BEGIN

    //           // KDK 004 00000000.s
    //           lbn_Ship := FALSE;
    //           ldc_ShippedQuantity := 0;
    //           ldc_ShipQuantitySource := 0;
    //           ldc_ShipQuantityTarget := 0;

    //           // Es kann maximal die ungelieferte Menge gesplittet werden
    //           ERROR(AGILES_LT_TEXT003);

    //         END;

    //         // -----------------------------------------------------------------------
    //         // Neue Zeilennummer berechnen
    //         // -----------------------------------------------------------------------
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesLine."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesLine."Document No.");
    //         //RS mit anderer Zeile verbundene Zeilen bei Zeilennummer nicht mit berücksichtigen
    //         lrc_SalesLine.SETRANGE("Attached to Line No.",0);
    //         lrc_SalesLine.SETFILTER("Line No.",'>%1',vrc_SalesLine."Line No.");
    //         IF lrc_SalesLine.FINDFIRST() THEN BEGIN
    //           lin_LineNo := vrc_SalesLine."Line No." +
    //                         ROUND(((lrc_SalesLine."Line No." - vrc_SalesLine."Line No.") / 2),1);
    //         END ELSE
    //           lin_LineNo := vrc_SalesLine."Line No." + 10000;

    //         // -----------------------------------------------------------------------
    //         // Neue Zeile einfügen
    //         // -----------------------------------------------------------------------
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.INIT();
    //         lrc_SalesLine.TRANSFERFIELDS(vrc_SalesLine);

    //         lrc_SalesLine."Document Type" := vrc_SalesLine."Document Type";
    //         lrc_SalesLine."Document No." := vrc_SalesLine."Document No.";
    //         lrc_SalesLine."Line No." := lin_LineNo;
    //         lrc_SalesLine.Quantity := 0;
    //         lrc_SalesLine."Quantity (Base)" := 0;
    //         lrc_SalesLine."Qty. to Invoice" := 0;
    //         lrc_SalesLine."Qty. to Invoice (Base)" := 0;
    //         lrc_SalesLine."Qty. to Ship" := 0;
    //         lrc_SalesLine."Qty. to Ship (Base)" := 0;
    //         lrc_SalesLine."Qty. Shipped Not Invoiced" := 0;
    //         lrc_SalesLine."Qty. Shipped Not Invd. (Base)" := 0;
    //         lrc_SalesLine."Shipped Not Invoiced" := 0;
    //         lrc_SalesLine."Quantity Shipped" := 0;
    //         lrc_SalesLine."Qty. Shipped (Base)" := 0;
    //         lrc_SalesLine."Quantity Invoiced" := 0;
    //         lrc_SalesLine."Qty. Invoiced (Base)" := 0;
    //         lrc_SalesLine."Shipment No." := '';
    //         lrc_SalesLine."Shipment Line No." := 0;
    //         lrc_SalesLine."Shipped Not Invoiced (LCY)" := 0;
    //         lrc_SalesLine."Qty. Shipped Not Invd. (Base)" := 0;
    //         lrc_SalesLine."Qty. Shipped (Base)" := 0;
    //         lrc_SalesLine."Qty. Invoiced (Base)" := 0;
    //         lrc_SalesLine."Outstanding Quantity" := 0;
    //         lrc_SalesLine."Outstanding Qty. (Base)" := 0;
    //         lrc_SalesLine."Quantity (PU)" := 0;
    //         lrc_SalesLine."Quantity (TU)" := 0;
    //         lrc_SalesLine."Total Net Weight" := 0;
    //         lrc_SalesLine."Total Gross Weight" := 0;
    //         lrc_SalesLine."Batch Var. Detail ID" := 0;
    //         lrc_SalesLine."Freight Costs per Ref. Unit" := 0;
    //         lrc_SalesLine."Freight Costs Amount (LCY)" := 0;
    //         lrc_SalesLine."Empties Blanket Order No." := ''; //RS Ergänzung EPS.s
    //         lrc_SalesLine."Empties Blanket Order Line No." := 0;
    //         lrc_SalesLine."Empties Order No. Reference" := '';
    //         lrc_SalesLine."Empties Order Ref. Line No." := 0;
    //         lrc_SalesLine."Empties Qty in Blanket Order" := 0;
    //         lrc_SalesLine."Empties Item No." := '';
    //         lrc_SalesLine."Empties Quantity" := 0; //RS Ergänzung EPS.e
    //         lrc_SalesLine."Empties Line No" := 0;
    //         lrc_SalesLine.insert();

    //         //RS 151214 Dimensionen kopieren
    //         lrc_DocumentDim.SETRANGE("Table ID", 37);
    //         lrc_DocumentDim.SETRANGE("Document Type", vrc_SalesLine."Document Type");
    //         lrc_DocumentDim.SETRANGE("Document No.", vrc_SalesLine."Document No.");
    //         lrc_DocumentDim.SETRANGE("Line No.", vrc_SalesLine."Line No.");
    //         IF lrc_DocumentDim.FINDSET(FALSE, FALSE) THEN BEGIN
    //           REPEAT
    //             IF NOT lrc_DocumentDim2.GET(37,vrc_SalesLine."Document Type", vrc_SalesLine."Document No.", lin_LineNo,
    //                                         lrc_DocumentDim."Dimension Code") THEN BEGIN
    //               lrc_DocumentDim2.INIT();
    //               lrc_DocumentDim2."Table ID" := 37;
    //               lrc_DocumentDim2."Document Type" := vrc_SalesLine."Document Type";
    //               lrc_DocumentDim2."Document No." := vrc_SalesLine."Document No.";
    //               lrc_DocumentDim2."Line No." := lin_LineNo;
    //               lrc_DocumentDim2."Dimension Code" := lrc_DocumentDim."Dimension Code";
    //               lrc_DocumentDim2.insert();
    //               lrc_DocumentDim2.VALIDATE("Dimension Value Code", lrc_DocumentDim."Dimension Value Code");
    //               lrc_DocumentDim2.Modify();
    //             END;
    //           UNTIL lrc_DocumentDim.NEXT() = 0;
    //         END;

    //         // Dimensionen validieren
    //         lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code");
    //         lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code");

    //         // Menge Ursprungszeile ändern
    //         lrc_SalesLine2.Reset();
    //         lrc_SalesLine2.GET(vrc_SalesLine."Document Type",vrc_SalesLine."Document No.",vrc_SalesLine."Line No.");
    //         lrc_SalesLine2.VALIDATE(Quantity,(lrc_SalesLine2.Quantity - lrc_FruitVisionTempI."EZS Splitt Quantity"));
    //         // Transporteinheit berechnen
    //         IF lrc_SalesLine2."Qty. (Unit) per Transp.(TU)" <> 0 THEN BEGIN
    //           lrc_SalesLine2."Quantity (TU)" := lrc_SalesLine2.Quantity / lrc_SalesLine2."Qty. (Unit) per Transp.(TU)"
    //         END ELSE BEGIN
    //           lrc_SalesLine2."Quantity (TU)" := 0;
    //         END;
    //         // Zollwert neu berechnen
    //         lrc_SalesLine2.VALIDATE("Cust. Duty (LCY) per Unit");
    //         lrc_SalesLine2.Modify();
    //         COMMIT;

    //         // Menge in neuer Zeile setzen
    //         lrc_SalesLine2.Reset();
    //         lrc_SalesLine2.GET(lrc_SalesLine."Document Type", lrc_SalesLine."Document No.", lrc_SalesLine."Line No.");
    //         lrc_SalesLine2.VALIDATE("Batch Variant No.",vrc_SalesLine."Batch Variant No.");
    //         lrc_SalesLine2.VALIDATE("Location Code", lrc_FruitVisionTempI."EZS Splitt Location Code");
    //         lrc_SalesLine2.VALIDATE(lrc_SalesLine2."Item Attribute 6"); // wegen EPS Zeile
    //         lrc_SalesLine2.Modify(); //wg. EPS Zeile, Leergutartikelnummer schreiben
    //         lrc_SalesLine2.VALIDATE(Quantity, lrc_FruitVisionTempI."EZS Splitt Quantity");
    //         lrc_SalesLine2.VALIDATE("Info 1", lrc_FruitVisionTempI."EZS Info 1");
    //         lrc_SalesLine2.VALIDATE("Info 2", lrc_FruitVisionTempI."EZS Info 2");
    //         lrc_SalesLine2.VALIDATE("Info 3", lrc_FruitVisionTempI."EZS Info 3");
    //         lrc_SalesLine2.VALIDATE("Info 4", lrc_FruitVisionTempI."EZS Info 4");

    //         // Transporteinheit berechnen
    //         IF lrc_SalesLine2."Qty. (Unit) per Transp.(TU)" <> 0 THEN BEGIN
    //           lrc_SalesLine2."Quantity (TU)" := lrc_SalesLine2.Quantity / lrc_SalesLine2."Qty. (Unit) per Transp.(TU)"
    //         END ELSE BEGIN
    //           lrc_SalesLine2."Quantity (TU)" := 0;
    //         END;
    //         IF lrc_SalesLine2."Sales Price (Price Base)" <> lrc_FruitVisionTempI."EZS Price" THEN BEGIN
    //           lrc_SalesLine2.VALIDATE("Sales Price (Price Base)",lrc_FruitVisionTempI."EZS Price");
    //         END;

    //         // Zollwert neu berechnen
    //         lrc_SalesLine2.VALIDATE("Cust. Duty (LCY) per Unit");
    //         lrc_SalesLine2.MODIFY(TRUE);
    //     end;

    //     procedure FillArrShippingAgent(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];var rco_ArrResult: array [1000] of Code[20])
    //     var
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Füllen eines Array mit allen Shipping Agents
    //         // ---------------------------------------------------------------------------------------

    //         lrc_SalesHeader.GET(vop_DocType,vco_DocNo);

    //         lin_ArrZähler := 0;
    //         lrc_SalesLine.Reset();
    //         //hf001-
    //         lrc_SalesLine.SETCURRENTKEY("Document Type","Document No.","Shipping Agent Code","Shipment No.");
    //         //hf001+
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         lrc_SalesLine.SETFILTER("Shipping Agent Code",'<>%1','');
    //         IF lrc_SalesLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult,10,lrc_SalesLine."Shipping Agent Code") = 0 THEN BEGIN
    //               lin_ArrZähler := lin_ArrZähler + 1;
    //               rco_ArrResult[lin_ArrZähler] := lrc_SalesLine."Shipping Agent Code";
    //             END;
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure FillArrLocationGroup(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];var rco_ArrResult: array [1000] of Code[20])
    //     var
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Füllen eines Array mit allen Lagerortgruppen
    //         // ---------------------------------------------------------------------------------------

    //         lrc_SalesHeader.GET(vop_DocType,vco_DocNo);

    //         lin_ArrZähler := 0;
    //         lrc_SalesLine.Reset();
    //         //hf001-
    //         lrc_SalesLine.SETCURRENTKEY("Document Type","Document No.","Location Code","Location Group Code","Shipping Agent Code");
    //         //hf001+
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         lrc_SalesLine.SETFILTER("Location Group Code",'<>%1','');
    //         IF lrc_SalesLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult,10,lrc_SalesLine."Location Group Code") = 0 THEN BEGIN
    //               lin_ArrZähler := lin_ArrZähler + 1;
    //               rco_ArrResult[lin_ArrZähler] := lrc_SalesLine."Location Group Code";
    //             END;
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure FillArrLocation(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];var rco_ArrResult: array [1000] of Code[20])
    //     var
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Füllen eines Array mit allen Location
    //         // ---------------------------------------------------------------------------------------

    //         lrc_SalesHeader.GET(vop_DocType,vco_DocNo);

    //         lin_ArrZähler := 0;
    //         lrc_SalesLine.Reset();
    //         //hf001-
    //         lrc_SalesLine.SETCURRENTKEY("Document Type","Document No.","Location Code");
    //         //hf001+
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         lrc_SalesLine.SETFILTER("Location Code",'<>%1','');
    //         IF lrc_SalesLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult,10,lrc_SalesLine."Location Code") = 0 THEN BEGIN
    //               lin_ArrZähler := lin_ArrZähler + 1;
    //               rco_ArrResult[lin_ArrZähler] := lrc_SalesLine."Location Code";
    //             END;
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure FillArrDepartureRegion(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];var rco_ArrResult: array [1000] of Code[20])
    //     var
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Füllen eines Array mit allen Departure Region
    //         // ---------------------------------------------------------------------------------------

    //         lrc_SalesHeader.GET(vop_DocType,vco_DocNo);

    //         lin_ArrZähler := 0;
    //         lrc_SalesLine.Reset();
    //         //hf001-
    //         lrc_SalesLine.SETCURRENTKEY("Departure Region Code","Shipping Agent Code",Type,"Freight Unit of Measure (FU)");
    //         //hjf001+
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         lrc_SalesLine.SETFILTER("Departure Region Code",'<>%1','');
    //         IF lrc_SalesLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult,10,lrc_SalesLine."Departure Region Code") = 0 THEN BEGIN
    //               lin_ArrZähler := lin_ArrZähler + 1;
    //               rco_ArrResult[lin_ArrZähler] := lrc_SalesLine."Departure Region Code";
    //             END;
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CalcCreditlimit(vco_CustNo: Code[20];var rdc_CreditLimitLCY: Decimal;var rdc_BalanceLCY: Decimal;var rdc_BalanceDueLCY: Decimal;var rdc_OutstandingOrdersLCY: Decimal;var rdc_ShippedNotInvoicedLCY: Decimal;var rdc_TotalAmountLCY: Decimal;var rdc_AvailCreditLCY: Decimal)
    //     var
    //         lrc_Customer: Record "Customer";
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung des Kreditlimits
    //         // ---------------------------------------------------------------------------------------
    //         IF vco_CustNo = '' THEN
    //           EXIT;

    //         lrc_Customer.GET(vco_CustNo);
    //         lrc_Customer.SETRANGE("Date Filter",0D,WORKDATE);
    //         lrc_Customer.CALCFIELDS("Balance (LCY)","Balance Due (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)");

    //         rdc_CreditLimitLCY := lrc_Customer."Credit Limit (LCY)";
    //         rdc_BalanceLCY := lrc_Customer."Balance (LCY)";
    //         rdc_BalanceDueLCY := lrc_Customer."Balance Due (LCY)";
    //         rdc_OutstandingOrdersLCY := lrc_Customer."Outstanding Orders (LCY)";
    //         rdc_ShippedNotInvoicedLCY := lrc_Customer."Shipped Not Invoiced (LCY)";

    //         rdc_TotalAmountLCY := lrc_Customer."Balance (LCY)" + lrc_Customer."Outstanding Orders (LCY)" +
    //                               lrc_Customer."Shipped Not Invoiced (LCY)";

    //         rdc_AvailCreditLCY := 0;
    //         IF lrc_Customer."Credit Limit (LCY)" <> 0 THEN
    //           rdc_AvailCreditLCY := lrc_Customer."Credit Limit (LCY)" - rdc_TotalAmountLCY;
    //     end;

    procedure SalesLineGetPriceUnit(vrc_SalesLine: Record "Sales Line"): Code[10]
    var
        lrc_PriceCalculation: Record "POI Price Base";
        lrc_UnitofMeasure: Record "Unit of Measure";
        ADF_LT_TEXT001Txt: Label 'Preisbasis nicht zulässig!';
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Ermittlung der Preiseinheit
        // ---------------------------------------------------------------------------------------

        IF (vrc_SalesLine.Type = vrc_SalesLine.Type::"Charge (Item)") THEN BEGIN
            IF (vrc_SalesLine."POI Reference Item No." = '') THEN
                EXIT(vrc_SalesLine."POI Price Unit of Measure");
        END ELSE BEGIN
            IF vrc_SalesLine.Type <> vrc_SalesLine.Type::Item THEN
                EXIT('');
            IF vrc_SalesLine."No." = '' THEN
                EXIT('');
        END;
        IF vrc_SalesLine."POI Price Base (Sales Price)" = '' THEN
            EXIT('');
        IF vrc_SalesLine."Unit of Measure Code" = '' THEN
            EXIT('');

        lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price",
                                 vrc_SalesLine."POI Price Base (Sales Price)");

        CASE lrc_PriceCalculation."Internal Calc. Type" OF
            lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
                BEGIN
                    vrc_SalesLine.TESTFIELD("POI Base Unit of Measure (BU)");
                    EXIT(vrc_SalesLine."POI Base Unit of Measure (BU)");
                END;
            lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
                // Preisbasis nicht zulässig!
                ERROR(ADF_LT_TEXT001Txt);

            lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":

                IF vrc_SalesLine."POI Partial Quantity (PQ)" = TRUE THEN BEGIN
                    lrc_UnitofMeasure.GET(vrc_SalesLine."POI Collo Unit of Measure (PQ)");
                    IF lrc_UnitofMeasure."POI Packing Unit of Meas (PU)" <> '' THEN
                        EXIT(lrc_UnitofMeasure."POI Packing Unit of Meas (PU)")
                    ELSE
                        EXIT('');

                END ELSE BEGIN
                    lrc_UnitofMeasure.GET(vrc_SalesLine."Unit of Measure Code");
                    IF lrc_UnitofMeasure."POI Packing Unit of Meas (PU)" <> '' THEN
                        EXIT(lrc_UnitofMeasure."POI Packing Unit of Meas (PU)")
                    ELSE
                        EXIT('');
                END;


            lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
                IF vrc_SalesLine."POI Partial Quantity (PQ)" = TRUE THEN
                    EXIT(vrc_SalesLine."POI Collo Unit of Measure (PQ)")
                ELSE
                    EXIT(vrc_SalesLine."Unit of Measure Code");
            lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
                BEGIN
                    vrc_SalesLine.TESTFIELD("POI Transp. Unit of Meas (TU)");
                    vrc_SalesLine.TESTFIELD("POI Qty.(Unit) per Transp.(TU)");
                    EXIT(vrc_SalesLine."POI Transp. Unit of Meas (TU)");
                END;

            lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
                EXIT(lrc_PriceCalculation."Price Unit Weighting");

            lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
                EXIT(lrc_PriceCalculation."Price Unit Weighting");
            lrc_PriceCalculation."Internal Calc. Type"::"Total Price":
                EXIT('');
        END;
    end;

    //     procedure CalcSalesUnitPrice("vdc_Sales Line": Record "37";var rdc_PackingUnitPrice: Decimal;var rdc_UnitPrice: Decimal;var rdc_BaseUnitPrice: Decimal)
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Vk-Preise in verschiedenen Einheiten
    //         // ---------------------------------------------------------------------------------------

    //         rdc_UnitPrice := "vdc_Sales Line"."Unit Price";

    //         IF "vdc_Sales Line"."Qty. (PU) per Unit of Measure" <> 0 THEN
    //           rdc_PackingUnitPrice := rdc_UnitPrice / "vdc_Sales Line"."Qty. (PU) per Unit of Measure"
    //         ELSE
    //           rdc_PackingUnitPrice := 0;

    //         IF "vdc_Sales Line"."Qty. per Unit of Measure" <> 0 THEN
    //           rdc_BaseUnitPrice := rdc_UnitPrice / "vdc_Sales Line"."Qty. per Unit of Measure"
    //         ELSE
    //           rdc_BaseUnitPrice := 0;
    //     end;

    procedure SalesLineCalcUnitPrice(vrc_SalesLine: Record "Sales Line"): Decimal
    var
        lrc_PriceBase: Record "POI Price Base";
        //lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_UnitofMeasure: Record "Unit of Measure";
        //ADF_LT_TEXT001Txt: Label 'Bitte geben Sie zuerst die Menge Kolli pro Palette ein!';
        ADF_LT_TEXT002Txt: Label 'Bitte geben Sie zuerst die Menge ein!';
        ldc_Preis: Decimal;
        ADF_LT_TEXT003Txt: Label 'Price Base not available!';
        ADF_LT_TEXT004Txt: Label 'Palettenpreis bei Anbruch nicht zulässig!';
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Preises bezogen auf die Verkaufseinheit
        // ---------------------------------------------------------------------------------------

        // Preis ist identisch falls nicht Artikel
        IF vrc_SalesLine.Type = vrc_SalesLine.Type::"Charge (Item)" THEN BEGIN
            IF (vrc_SalesLine."POI Reference Item No." = '') THEN
                EXIT(vrc_SalesLine."Sales Price (Price Base)");
        END ELSE
            IF vrc_SalesLine.Type <> vrc_SalesLine.Type::Item THEN
                EXIT(vrc_SalesLine."Sales Price (Price Base)");

        IF vrc_SalesLine."Sales Price (Price Base)" = 0 THEN
            EXIT(vrc_SalesLine."Sales Price (Price Base)");
        IF vrc_SalesLine."POI Price Base (Sales Price)" = '' THEN
            EXIT(vrc_SalesLine."Sales Price (Price Base)");

        lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Sales Price",
                                 vrc_SalesLine."POI Price Base (Sales Price)");

        CASE lrc_PriceBase."Internal Calc. Type" OF

            // ---------------------------------------------------------------------------------------------
            // Preiseingabe entspricht dem Preis für einen Kollo --> Umrechnung in Verkaufseinheit
            // KOLLO: Menge (Kollo) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
                BEGIN
                    //xx vrc_SalesLine.TESTFIELD("Price Unit of Measure");
                    lrc_UnitofMeasure.GET(vrc_SalesLine."Unit of Measure Code");
                    ldc_Preis := ROUND(vrc_SalesLine."Sales Price (Price Base)" /
                                       lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" *
                                       vrc_SalesLine."Qty. per Unit of Measure", 0.00001);
                    EXIT(ldc_Preis);
                END;


            // ---------------------------------------------------------------------------------------------
            // VERPACKUNG: Menge (Kollo) * Menge (UE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceBase."Internal Calc. Type"::"Packing Unit":

                IF vrc_SalesLine."POI Partial Quantity (PQ)" = TRUE THEN BEGIN
                    ldc_Preis := vrc_SalesLine."Sales Price (Price Base)";
                    EXIT(ldc_Preis);
                END ELSE BEGIN
                    //vrc_SalesLine.TESTFIELD("Price Unit of Measure");
                    lrc_UnitofMeasure.GET(vrc_SalesLine."Unit of Measure Code");
                    lrc_UnitofMeasure.TESTFIELD("POI Packing Unit of Meas (PU)", vrc_SalesLine."POI Price Unit of Measure");
                    lrc_UnitofMeasure.TESTFIELD("POI Qty. (PU) per Unit of Meas");
                    ldc_Preis := ROUND(vrc_SalesLine."Sales Price (Price Base)" *
                                 lrc_UnitofMeasure."POI Qty. (PU) per Unit of Meas", 0.00001);
                    EXIT(ldc_Preis);
                END;



            // ---------------------------------------------------------------------------------------------
            // INHALT: Menge (Kollo) * Menge (UE) * Menge (IE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceBase."Internal Calc. Type"::"Content Unit":
                // Preisbasis nicht zulässig!
                ERROR(ADF_LT_TEXT003Txt);


            // ---------------------------------------------------------------------------------------------
            // BASIS: Menge (Kollo) * Menge (UE) * Menge (IE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceBase."Internal Calc. Type"::"Base Unit":
                BEGIN
                    vrc_SalesLine.TESTFIELD("POI Base Unit of Measure (BU)");
                    ldc_Preis := ROUND(vrc_SalesLine."Sales Price (Price Base)" * vrc_SalesLine."Qty. per Unit of Measure", 0.00001);
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // PALETTE: Menge (TE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceBase."Internal Calc. Type"::"Transport Unit":

                IF vrc_SalesLine."POI Partial Quantity (PQ)" = TRUE THEN
                    // Palettenpreis bei Anbruch nicht zulässig!
                    ERROR(ADF_LT_TEXT004Txt)
                ELSE BEGIN
                    ldc_Preis := vrc_SalesLine."Sales Price (Price Base)";
                    IF vrc_SalesLine."POI Qty.(Unit) per Transp.(TU)" <> 0 THEN BEGIN
                        ldc_Preis := ROUND(ldc_Preis / vrc_SalesLine."POI Qty.(Unit) per Transp.(TU)", 0.00001);
                        EXIT(ldc_Preis);
                    END ELSE BEGIN
                        ldc_Preis := 0;
                        MESSAGE('Preis Null, da Menge pro Palette nicht vorhanden!');
                        EXIT(ldc_Preis);
                    END;
                END;

            // ---------------------------------------------------------------------------------------------
            // NETTO: Nettogewicht (gesamt) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceBase."Internal Calc. Type"::"Net Weight":
                BEGIN
                    ldc_Preis := ROUND(vrc_SalesLine."Sales Price (Price Base)" * vrc_SalesLine."Net Weight", 0.00001);
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // BRUTTO: Bruttogewicht (gesamt) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
                BEGIN
                    ldc_Preis := ROUND(vrc_SalesLine."Sales Price (Price Base)" * vrc_SalesLine."Gross Weight", 0.00001);
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // GESAMT: Gesamtpreis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceBase."Internal Calc. Type"::"Total Price":

                IF vrc_SalesLine."POI Partial Quantity (PQ)" = TRUE THEN BEGIN
                    IF vrc_SalesLine.Quantity <> 0 THEN BEGIN
                        ldc_Preis := ROUND(vrc_SalesLine."Sales Price (Price Base)" / vrc_SalesLine.Quantity, 0.00001);
                        EXIT(ldc_Preis);
                    END ELSE
                        // Bitte geben Sie zuerst die Menge ein!
                        ERROR(ADF_LT_TEXT002Txt);
                END ELSE
                    IF vrc_SalesLine.Quantity <> 0 THEN BEGIN
                        ldc_Preis := ROUND(vrc_SalesLine."Sales Price (Price Base)" / vrc_SalesLine.Quantity, 0.00001);
                        EXIT(ldc_Preis);
                    END ELSE
                        // Bitte geben Sie zuerst die Menge ein!
                        ERROR(ADF_LT_TEXT002Txt);

            // ---------------------------------------------------------------------------------------------
            // Ausnahmeregelung
            // ---------------------------------------------------------------------------------------------
            ELSE
                EXIT(vrc_SalesLine."Sales Price (Price Base)");

        END;
    end;

    //     procedure CalcOutletUnitPrice(vrc_SalesLine: Record "37"): Decimal
    //     var
    //         lrc_SalesPrice: Record "7002";
    //         lrc_SalesHeader: Record "36";
    //         ldt_RefDate: Date;
    //         "-- Agiles L ASO 001": Integer;
    //         lrc_CustomerPriceGroup: Record "6";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung des Ladenpreises
    //         // ---------------------------------------------------------------------------------------------

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') THEN
    //           EXIT(0);

    //         // Kopfsatz lesen
    //         lrc_SalesHeader.GET(vrc_SalesLine."Document Type",vrc_SalesLine."Document No.");

    //         // Kontrolle ob Ladenpreisgruppe vorhanden ist
    //         IF lrc_SalesHeader."Outlet Price Group Code" = '' THEN
    //           EXIT(vrc_SalesLine."Shop Sales Price");

    //         // Referenzdatum ermitteln
    //         ldt_RefDate := GetRefDateValidCustPriceGrp(lrc_SalesHeader,TRUE);

    //         lrc_SalesPrice.SETRANGE("Item No.",vrc_SalesLine."No.");
    //         //lrc_SalesPrice.SETRANGE("Unit of Measure Code",vrc_SalesLine."Unit of Measure Code");
    //         lrc_SalesPrice.SETRANGE("Variant Code",vrc_SalesLine."Variant Code");
    //         lrc_SalesPrice.SETRANGE("Currency Code",lrc_SalesHeader."Currency Code");
    //         lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::"Customer Price Group");
    //         lrc_SalesPrice.SETRANGE("Sales Code",lrc_SalesHeader."Outlet Price Group Code");
    //         lrc_SalesPrice.SETFILTER("Starting Date",'<=%1',ldt_RefDate);
    //         lrc_SalesPrice.SETFILTER("Ending Date",'>=%1|%2',ldt_RefDate,0D);

    //         lrc_SalesPrice.SETRANGE("Vendor No.", '');
    //         lrc_SalesPrice.SETRANGE("Assort. Version No.", '');
    //         lrc_SalesPrice.SETRANGE("Assort. Version Line No.", 0);
    //         IF lrc_SalesHeader."Outlet Price Group Code" <> '' THEN BEGIN
    //           IF lrc_CustomerPriceGroup.GET(lrc_SalesHeader."Outlet Price Group Code") THEN BEGIN
    //             CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //               lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //               "plus Vendor No":
    //                 BEGIN
    //                   lrc_SalesPrice.SETFILTER("Vendor No.",'%1|%2', vrc_SalesLine."Buy-from Vendor No.", '');
    //                 END;
    //               lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //               "plus Assortment Version and Line No":
    //                 BEGIN
    //                   lrc_SalesPrice.SETFILTER("Assort. Version No.", '%1|%2', vrc_SalesLine."Assortment Version No.", '');
    //                   lrc_SalesPrice.SETFILTER("Assort. Version Line No.", '%1|%2', vrc_SalesLine."Assortment Version Line No.", 0);
    //                 END;
    //             END;
    //           END;
    //         END;

    //         IF lrc_SalesPrice.FINDLAST THEN
    //           EXIT(lrc_SalesPrice."Unit Price")
    //         ELSE
    //           EXIT(0);
    //     end;

    //     procedure CalcGreenPoint(vrc_SalesHeader: Record "36")
    //     var
    //         lcu_DSDFunktion: Codeunit "5087901";
    //         lrc_SalesLine: Record "37";
    //         lrc_BatchVariantDetail: Record "5110487";
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Berechnung der DSD / ARA Werte
    //         // -----------------------------------------------------------------------------

    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //         lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //         lrc_SalesLine.SETFILTER("No.",'<>%1','');
    //         IF lrc_SalesLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //           REPEAT
    //             lrc_SalesLine."Waste Disposal Amount (LCY)" := 0;
    //             IF lrc_SalesLine."Batch Variant No." <> '' THEN BEGIN
    //               lrc_BatchVariant.GET(lrc_SalesLine."Batch Variant No.");
    //               IF lrc_BatchVariant."Waste Disposal Payment By" = lrc_BatchVariant."Waste Disposal Payment By"::Us THEN BEGIN
    //                 CASE lrc_SalesLine."Waste Disposal Duty" OF
    //                 lrc_SalesLine."Waste Disposal Duty"::"Green Point Duty":
    //                   BEGIN
    //                     lrc_SalesLine."Waste Disposal Amount (LCY)" := lrc_SalesLine."Waste Disposal Amount (LCY)" +
    //                     lcu_DSDFunktion.CalcCharge(lrc_SalesLine."Product Group Code",lrc_SalesLine."No.",
    //                                                lrc_SalesLine."Unit of Measure Code",lrc_SalesLine."Qty. (PU) per Unit of Measure") *
    //                                                lrc_SalesLine.Quantity;
    //                   END;
    //                 lrc_SalesLine."Waste Disposal Duty"::"2":
    //                   BEGIN
    //                   END;
    //                 END;
    //               END;

    //             END ELSE BEGIN
    //               IF lrc_SalesLine."Batch Var. Detail ID" <> 0 THEN BEGIN
    //                 lrc_BatchVariantDetail.SETRANGE("Entry No.",lrc_SalesLine."Batch Var. Detail ID");
    //                 lrc_BatchVariantDetail.SETFILTER("Batch Variant No.",'<>%1','');
    //                 lrc_BatchVariantDetail.SETFILTER(Quantity,'<>%1',0);
    //                 IF lrc_BatchVariantDetail.FINDSET(FALSE,FALSE) THEN BEGIN
    //                   REPEAT
    //                     lrc_BatchVariant.GET(lrc_BatchVariantDetail."Batch Variant No.");
    //                     IF lrc_BatchVariant."Waste Disposal Payment By" = lrc_BatchVariant."Waste Disposal Payment By"::Us THEN BEGIN
    //                       CASE lrc_SalesLine."Waste Disposal Duty" OF
    //                       lrc_SalesLine."Waste Disposal Duty"::"Green Point Duty":
    //                         BEGIN
    //                           lrc_SalesLine."Waste Disposal Amount (LCY)" := lrc_SalesLine."Waste Disposal Amount (LCY)" +
    //                           lcu_DSDFunktion.CalcCharge(lrc_SalesLine."Product Group Code",lrc_SalesLine."No.",
    //                                                      lrc_SalesLine."Unit of Measure Code",lrc_SalesLine."Qty. (PU) per Unit of Measure") *
    //                                                      lrc_BatchVariantDetail.Quantity;
    //                         END;
    //                       lrc_SalesLine."Waste Disposal Duty"::"2":
    //                         BEGIN
    //                         END;
    //                       END;
    //                     END;
    //                   UNTIL lrc_BatchVariantDetail.NEXT() = 0;
    //                 END;
    //               END;
    //             END;

    //             lrc_SalesLine.Modify();
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure SalesEditPalletNo(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];vin_DocLineNo: Integer)
    //     var
    //         lrc_SalesPallet: Record "5110502";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion Erfassung Palettennummern
    //         // -----------------------------------------------------------------------------

    //         /*

    //         lrc_SalesPallet.FILTERGROUP(2);
    //         lrc_SalesPallet.SETRANGE("Entry No.",vop_DocType);
    //         // ???????????????????????????????????????????????????????????
    //         //lrc_SalesPallet.SETRANGE("Line No.",vco_DocNo);
    //         lrc_SalesPallet.SETRANGE("Document Line No.",vin_DocLineNo);
    //         lrc_SalesPallet.FILTERGROUP(0);

    //         lfm_SalesPallet.SETTABLEVIEW(lrc_SalesPallet);
    //         lfm_SalesPallet.RUNMODAL;
    //         */

    //     end;

    //     procedure SalesOrderSetDateFields(var rrc_SalesHeader: Record "36")
    //     var
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_Customer: Record "Customer";
    //         ldt_PromDeliveryDate: Date;
    //         ldt_ShipmentDate: Date;
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Setzen der Datumsfelder in Verkaufsaufträge
    //         // -----------------------------------------------------------------------------

    //         IF rrc_SalesHeader."Document Type" <> rrc_SalesHeader."Document Type"::Order THEN
    //           EXIT;

    //         IF rrc_SalesHeader."Order Date" = 0D THEN
    //           rrc_SalesHeader."Order Date" := TODAY;

    //         lrc_SalesDocType.GET(rrc_SalesHeader."Document Type",rrc_SalesHeader."Sales Doc. Subtype Code");

    //         IF lrc_SalesDocType."Cash/Cheque Sales" = TRUE THEN BEGIN

    //           rrc_SalesHeader.VALIDATE("Posting Date",rrc_SalesHeader."Order Date");
    //           rrc_SalesHeader.VALIDATE("Document Date",rrc_SalesHeader."Order Date");
    //           rrc_SalesHeader.VALIDATE("Shipment Date",rrc_SalesHeader."Order Date");
    //           rrc_SalesHeader.VALIDATE("Promised Delivery Date",rrc_SalesHeader."Order Date");

    //         END ELSE BEGIN

    //           lrc_Customer.GET(rrc_SalesHeader."Sell-to Customer No.");
    //           ldt_PromDeliveryDate := CALCDATE(lrc_Customer."Shipping Time",rrc_SalesHeader."Order Date");
    //           // Falls Zugesagtes Lieferdatum Sonntag dann auf Montag ändern
    //           IF DATE2DWY(ldt_PromDeliveryDate,1) = 7 THEN BEGIN
    //             ldt_PromDeliveryDate := ldt_PromDeliveryDate + 1;
    //           END;

    //           rrc_SalesHeader.VALIDATE("Posting Date",ldt_PromDeliveryDate);
    //           rrc_SalesHeader.VALIDATE("Document Date",ldt_PromDeliveryDate);

    //           // Falls Auftragsdatum Samstag dann ist Warenausgangsdatum Sonntag
    //           IF DATE2DWY(rrc_SalesHeader."Order Date",1) = 6 THEN BEGIN
    //             ldt_ShipmentDate := rrc_SalesHeader."Order Date" + 1;
    //           END ELSE BEGIN
    //             ldt_ShipmentDate := rrc_SalesHeader."Order Date";
    //           END;
    //           rrc_SalesHeader.VALIDATE("Shipment Date",ldt_ShipmentDate);

    //           lrc_FruitVisionSetup.GET();
    //           IF lrc_FruitVisionSetup."Internal Customer Code" <> 'GEMÜSEMEYER' THEN BEGIN
    //             rrc_SalesHeader.VALIDATE("Promised Delivery Date",ldt_PromDeliveryDate);
    //           END;

    //         END;
    //     end;

    //     procedure GetRefDateValidCustPriceGrp(vrc_SalesHeader: Record "36";vbn_OutletPriceGroup: Boolean): Date
    //     var
    //         lrc_CustomerPriceGroup: Record "6";
    //         ldt_RefDateValid: Date;
    //         AGILES_LT_TEXT001: Label 'Referenzdatum Ladenpreisgruppe konnte nicht ermittelt werden!';
    //         AGILES_LT_TEXT002: Label 'Referenzdatum Debitorenpreisgruppe konnte nicht ermittelt werden!';
    //     begin
    //         // -------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung des Gültigkeitsbezuges für die Debitorenpreisgruppe
    //         // -------------------------------------------------------------------------------

    //         IF vbn_OutletPriceGroup = TRUE THEN BEGIN
    //           IF vrc_SalesHeader."Outlet Price Group Code" <> '' THEN
    //             lrc_CustomerPriceGroup.GET(vrc_SalesHeader."Outlet Price Group Code")
    //           ELSE
    //             EXIT(vrc_SalesHeader."Order Date");
    //         END ELSE BEGIN
    //           IF NOT lrc_CustomerPriceGroup.GET(vrc_SalesHeader."Customer Price Group") THEN
    //             EXIT(vrc_SalesHeader."Order Date");
    //         END;

    //         ldt_RefDateValid := 0D;
    //         CASE lrc_CustomerPriceGroup."Ref. Date in Sales Order" OF
    //         lrc_CustomerPriceGroup."Ref. Date in Sales Order"::"Order Date":
    //           BEGIN
    //             vrc_SalesHeader.TESTFIELD("Order Date");
    //             ldt_RefDateValid := vrc_SalesHeader."Order Date";
    //           END;
    //         lrc_CustomerPriceGroup."Ref. Date in Sales Order"::"Shipment Date":
    //           BEGIN
    //             vrc_SalesHeader.TESTFIELD("Shipment Date");
    //             ldt_RefDateValid := vrc_SalesHeader."Shipment Date";
    //           END;
    //         lrc_CustomerPriceGroup."Ref. Date in Sales Order"::"Requested Delivery Date":
    //           BEGIN
    //             vrc_SalesHeader.TESTFIELD("Requested Delivery Date");
    //             ldt_RefDateValid := vrc_SalesHeader."Requested Delivery Date";
    //           END;
    //         lrc_CustomerPriceGroup."Ref. Date in Sales Order"::"Promised Delivery Date":
    //           BEGIN
    //             vrc_SalesHeader.TESTFIELD("Promised Delivery Date");
    //             ldt_RefDateValid := vrc_SalesHeader."Promised Delivery Date";
    //           END;
    //         END;

    //         IF ldt_RefDateValid = 0D THEN BEGIN
    //           IF vbn_OutletPriceGroup = TRUE THEN
    //             // Referenzdatum Ladenpreisgruppe konnte nicht ermittelt werden!
    //             ERROR(AGILES_LT_TEXT001)
    //           ELSE
    //             // Referenzdatum Debitorenpreisgruppe konnte nicht ermittelt werden!
    //             ERROR(AGILES_LT_TEXT002);
    //         END;

    //         EXIT(ldt_RefDateValid);
    //     end;

    //     procedure ShowLastShipments(vco_CustNo: Code[20];vco_ItemNo: Code[20])
    //     var
    //         lrc_SalesShipmentLine: Record "111";
    //         lfm_PostedSalesShipLines: Form "525";
    //     begin
    //         // ------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der letzten Lieferungen
    //         // ------------------------------------------------------------------------------

    //         lrc_SalesShipmentLine.SETCURRENTKEY("Sell-to Customer No.","Posting Date",Type,"No.",Quantity);
    //         lrc_SalesShipmentLine.ASCENDING(FALSE);
    //         IF vco_CustNo <> '' THEN
    //           lrc_SalesShipmentLine.SETRANGE("Sell-to Customer No.",vco_CustNo);
    //         IF vco_ItemNo <> '' THEN BEGIN
    //           lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
    //           lrc_SalesShipmentLine.SETRANGE("No.",vco_ItemNo);
    //         END;

    //         lfm_PostedSalesShipLines.SETTABLEVIEW(lrc_SalesShipmentLine);
    //         lfm_PostedSalesShipLines.RUNMODAL;
    //     end;

    //     procedure CheckBatchVarQty(vrc_SalesHeader: Record "36")
    //     var
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_SalesLine: Record "37";
    //         lrc_BatchVariantDetail: Record "5110487";
    //         AGILES_LT_TEXT001: Label 'Es ist mehr als ein Positionsvariantensatz vorhanden!';
    //         AGILES_LT_TEXT002: Label 'Menge zu liefern und Menge zugewiesen Positionsvarianten ist abweichend!';
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Prüfung der zugewiesenen Positionsvarianten
    //         // ---------------------------------------------------------------------------------

    //         IF (vrc_SalesHeader."Document Type" <> vrc_SalesHeader."Document Type"::Order) AND
    //            (vrc_SalesHeader."Document Type" <> vrc_SalesHeader."Document Type"::"Return Order") AND
    //            (vrc_SalesHeader."Document Type" <> vrc_SalesHeader."Document Type"::"Credit Memo") THEN
    //           EXIT;

    //         lrc_BatchSetup.GET();

    //         CASE lrc_BatchSetup."Sales Batch Assignment" OF
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line":
    //           BEGIN

    //             // FV START 090209
    //             //lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHeader."Document Type"::Order);
    //             lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //             // FV END
    //             lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //             lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //             lrc_SalesLine.SETFILTER("No.",'<>%1','');
    //             lrc_SalesLine.SETRANGE("Batch Item",TRUE);
    //             lrc_SalesLine.SETFILTER("Qty. to Ship",'<>%1',0);
    //             IF lrc_SalesLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //               REPEAT

    //                 // Prüfung auf Positionsvariante
    //                 lrc_SalesLine.TESTFIELD("Batch Variant No.");

    //                 IF lrc_SalesLine."Batch Var. Detail ID" = 0 THEN BEGIN
    //                   // Neue ID vergeben
    //                   lrc_SalesLine."Batch Var. Detail ID" := lcu_BatchMgt.GetBatchVarDetailNo();
    //                   lrc_SalesLine.Modify();

    //                   lrc_SalesLine.TESTFIELD("Batch Var. Detail ID");

    //                   lrc_BatchVariantDetail.Reset();
    //                   lrc_BatchVariantDetail.INIT();
    //                   lrc_BatchVariantDetail."Entry No." := lrc_SalesLine."Batch Var. Detail ID";
    //                   lrc_BatchVariantDetail."Line No." := 0;
    //                   lrc_BatchVariantDetail.INSERT(TRUE);

    //                 END ELSE BEGIN
    //                   lrc_BatchVariantDetail.SETRANGE("Entry No.",lrc_SalesLine."Batch Var. Detail ID");
    //                   IF lrc_BatchVariantDetail.COUNT() <> 1 THEN
    //                     // Es ist mehr als ein Positionsvariantensatz vorhanden!
    //                     ERROR(AGILES_LT_TEXT001);
    //                   lrc_BatchVariantDetail.FIND('-');
    //                 END;

    //                 lrc_BatchVariantDetail.Source := lrc_BatchVariantDetail.Source::Sales;
    //                 CASE vrc_SalesHeader."Document Type" OF
    //                 vrc_SalesHeader."Document Type"::Order:
    //                   lrc_BatchVariantDetail."Source Type" := lrc_BatchVariantDetail."Source Type"::Order;
    //                 vrc_SalesHeader."Document Type"::"Credit Memo":
    //                   lrc_BatchVariantDetail."Source Type" := lrc_BatchVariantDetail."Source Type"::"Credit Memo";
    //                 vrc_SalesHeader."Document Type"::"Return Order":
    //                   lrc_BatchVariantDetail."Source Type" := lrc_BatchVariantDetail."Source Type"::"Return Order";
    //                 END;

    //                 lrc_BatchVariantDetail."Source No." := lrc_SalesLine."Document No.";
    //                 lrc_BatchVariantDetail."Source Line No." := lrc_SalesLine."Line No.";
    //                 lrc_BatchVariantDetail."Sales Shipment Date" := lrc_SalesLine."Shipment Date";
    //                 lrc_BatchVariantDetail."Item No." := lrc_SalesLine."No.";
    //                 lrc_BatchVariantDetail."Variant Code" := lrc_SalesLine."Variant Code";
    //                 lrc_BatchVariantDetail."Master Batch No." := lrc_SalesLine."Master Batch No.";
    //                 lrc_BatchVariantDetail."Batch No." := lrc_SalesLine."Batch No.";
    //                 lrc_BatchVariantDetail."Batch Variant No." := lrc_SalesLine."Batch Variant No.";
    //                 lrc_BatchVariantDetail."Location Code" := lrc_SalesLine."Location Code";
    //                 lrc_BatchVariantDetail."Unit of Measure Code" := lrc_SalesLine."Unit of Measure Code";
    //                 lrc_BatchVariantDetail.Quantity := lrc_SalesLine.Quantity;
    //                 lrc_BatchVariantDetail."Qty. to Post" := lrc_SalesLine."Qty. to Ship";
    //                 lrc_BatchVariantDetail."Qty. Posted" := lrc_SalesLine."Quantity Shipped";
    //                 lrc_BatchVariantDetail."Base Unit of Measure" := lrc_SalesLine."Base Unit of Measure (BU)";
    //                 lrc_BatchVariantDetail."Qty. per Unit of Measure" := lrc_SalesLine."Qty. per Unit of Measure";
    //                 lrc_BatchVariantDetail."Qty. (Base)" := lrc_SalesLine."Quantity (Base)";
    //                 lrc_BatchVariantDetail."Qty. to Post (Base)" := lrc_SalesLine."Qty. to Ship (Base)";
    //                 lrc_BatchVariantDetail."Qty. Posted (Base)" := lrc_SalesLine."Qty. Shipped (Base)";
    //                 lrc_BatchVariantDetail."Source from Doc. Line" := TRUE;
    //                 lrc_BatchVariantDetail.Modify();

    //               UNTIL lrc_SalesLine.NEXT() = 0;
    //             END;
    //           END;

    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line":
    //           BEGIN

    //             lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHeader."Document Type"::Order);
    //             lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //             lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //             lrc_SalesLine.SETFILTER("No.",'<>%1','');
    //             lrc_SalesLine.SETRANGE("Batch Item",TRUE);
    //             lrc_SalesLine.SETFILTER("Qty. to Ship",'<>%1',0);
    //             IF lrc_SalesLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //               REPEAT
    //                 lrc_SalesLine.TESTFIELD("Batch Var. Detail ID");
    //                 lrc_BatchVariantDetail.SETRANGE("Entry No.",lrc_SalesLine."Batch Var. Detail ID");
    //                 lrc_BatchVariantDetail.CALCSUMS("Qty. to Post");
    //                 IF lrc_BatchVariantDetail."Qty. to Post" <> lrc_SalesLine."Qty. to Ship" THEN
    //                   // Menge zu liefern und Menge zugewiesen Positionsvarianten ist abweichend!
    //                   ERROR(AGILES_LT_TEXT002);
    //               UNTIL lrc_SalesLine.NEXT() = 0;
    //             END;

    //           END;
    //         END;
    //     end;

    //     procedure CheckChangeDocStatus(vrc_SalesHeader: Record "36")
    //     var
    //         lcu_CheckPostingMgt: Codeunit "5087911";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion für Prüfungen beim Wechsel Status Dokument
    //         // ---------------------------------------------------------------------------------

    //         CASE vrc_SalesHeader."Document Status" OF
    //         vrc_SalesHeader."Document Status"::"Freigabe Fakturierung":
    //           BEGIN
    //             lcu_CheckPostingMgt.SalesCheckBeforePosting(vrc_SalesHeader);
    //           END;
    //         END;
    //     end;

    //     procedure CheckFreightCosts(vrc_SalesHeader: Record "36";vbn_ZeroManualAllowed: Boolean)
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_SalesFreightCosts: Record "5110549";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_SalesDocType: Record "5110411";
    //         AGILES_LT_TEXT001: Label 'Frachtkosten manuell aber Null nicht zulässig!';
    //         AGILES_LT_TEXT002: Label 'Freight Costs are incomplete or missing!';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum Prüfen der Frachtkosten
    //         // ------------------------------------------------------------------------------------

    //         IF vrc_SalesHeader."Document Type" <> vrc_SalesHeader."Document Type"::Order THEN
    //           EXIT;

    //         lrc_FruitVisionSetup.GET();

    //         // Prüfung Frachtkosten
    //         lrc_ShipmentMethod.GET(vrc_SalesHeader."Shipment Method Code");
    //         IF lrc_ShipmentMethod."Incl. Freight to Final Loc." = TRUE THEN BEGIN
    //           IF (lrc_FruitVisionSetup."Check Freight Cost before Post" = TRUE) OR
    //              (lrc_SalesDocType."Enter Freight Costs" = lrc_SalesDocType."Enter Freight Costs"::"Compulsory Entry") THEN BEGIN
    //             vrc_SalesHeader.TESTFIELD("Shipping Agent Code");

    //             lrc_SalesFreightCosts.Reset();
    //             lrc_SalesFreightCosts.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //             lrc_SalesFreightCosts.SETRANGE("Doc. No.",vrc_SalesHeader."No.");
    //             lrc_SalesFreightCosts.SETRANGE(Type,lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //             IF lrc_SalesFreightCosts.FIND('-') THEN BEGIN
    //               REPEAT
    //                 IF (lrc_SalesFreightCosts."Freight Costs Amount (LCY)" = 0) AND
    //                    (lrc_SalesFreightCosts."Freight Cost Manual Entered" = FALSE) THEN BEGIN
    //                   // Frachtkosten nicht vorhanden oder unvollständig!
    //                   ERROR(AGILES_LT_TEXT002);
    //                 END ELSE BEGIN
    //                   IF (lrc_SalesFreightCosts."Freight Costs Amount (LCY)" = 0) AND
    //                      (lrc_SalesFreightCosts."Freight Cost Manual Entered" = TRUE) AND
    //                      (vbn_ZeroManualAllowed = FALSE) THEN BEGIN
    //                     IF NOT CONFIRM('Frachtkosten manuell aber Null! Ist das korrekt?') THEN
    //                       ERROR('');
    //                   END ELSE BEGIN
    //                     IF (lrc_SalesFreightCosts."Freight Costs Amount (LCY)" = 0) AND
    //                        (lrc_SalesFreightCosts."Freight Cost Manual Entered" = TRUE) THEN BEGIN
    //                     END;
    //                   END;
    //                 END;
    //               UNTIL lrc_SalesFreightCosts.NEXT() = 0;
    //             END ELSE BEGIN
    //               // Frachtkosten nicht vorhanden oder unvollständig!
    //               ERROR(AGILES_LT_TEXT002);
    //             END;
    //           END;
    //         END;
    //     end;

    //     procedure SalesLinesSetAllPricesToZero(vrc_SalesHeader: Record "36")
    //     var
    //         lrc_SalesLine: Record "37";
    //         AGILES_LT_TEXT001: Label 'Möchten Sie alle Preise für den Auftrag %1 auf Null setzen?';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der Verkaufspreise auf Null
    //         // -------------------------------------------------------------------------------------

    //         // Möchten Sie alle Preise für den Auftrag %1 auf Null setzen?
    //         IF NOT CONFIRM(AGILES_LT_TEXT001, FALSE, vrc_SalesHeader."No.") THEN
    //           EXIT;

    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_SalesLine.VALIDATE("Sales Price (Price Base)",0);
    //             lrc_SalesLine.Modify();
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CheckOrderCompleteInvoiced(vco_OrderNo: Code[20]): Boolean
    //     var
    //         lrc_SalesLine: Record "37";
    //     begin
    //         // ----------------------------------------------------------------------------------------------------
    //         // Funktion zur Prüfung ob ein Auftrag komplett fakturiert ist
    //         // ----------------------------------------------------------------------------------------------------

    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesLine."Document Type"::Order);
    //         lrc_SalesLine.SETRANGE("Document No.",vco_OrderNo);

    //         lrc_SalesLine.CALCSUMS("Quantity (Base)","Qty. Invoiced (Base)");
    //         IF lrc_SalesLine."Quantity (Base)" = 0 THEN
    //           EXIT(FALSE);
    //         IF lrc_SalesLine."Quantity (Base)" = lrc_SalesLine."Qty. Invoiced (Base)" THEN
    //           EXIT(TRUE)
    //         ELSE
    //           EXIT(FALSE);
    //     end;

    //     procedure GetItemCrossReference(vco_CustomerNo: Code[20];vco_ItemNo: Code[20];vco_UnitofMeasureCode: Code[20];vin_PrintDocument: Integer): Code[20]
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_ItemCrossReference: Record "5717";
    //     begin
    //         // ----------------------------------------------------------------------------------------------------
    //         //
    //         // ----------------------------------------------------------------------------------------------------

    //         // FV4 005 00000000.s
    //         IF vco_ItemNo = '' THEN BEGIN
    //           EXIT('');
    //         END;

    //         IF lrc_Customer.GET(vco_CustomerNo) THEN BEGIN
    //           IF (lrc_Customer."Cross-Reference Print" <> lrc_Customer."Cross-Reference Print"::" ") AND
    //              (lrc_Customer."Cross-Reference Print" IN [vin_PrintDocument, lrc_Customer."Cross-Reference Print"::All]) THEN BEGIN
    //             CASE lrc_Customer."Cross-Reference Type" OF
    //               lrc_Customer."Cross-Reference Type"::"Bar Code":
    //                 BEGIN
    //                   lrc_ItemCrossReference.Reset();
    //                   lrc_ItemCrossReference.SETRANGE("Item No.",vco_ItemNo);
    //                   lrc_ItemCrossReference.SETRANGE("Cross-Reference Type",lrc_ItemCrossReference."Cross-Reference Type"::"Bar Code");
    //                   IF lrc_Customer."Cross-Reference Type No." <> '' THEN BEGIN
    //                     lrc_ItemCrossReference.SETRANGE("Cross-Reference Type No.",lrc_Customer."Cross-Reference Type No.");
    //                   END;
    //                   lrc_ItemCrossReference.SETRANGE("Unit of Measure",vco_UnitofMeasureCode);
    //                   IF lrc_ItemCrossReference.FIND('-') THEN BEGIN
    //                     EXIT(lrc_ItemCrossReference."Cross-Reference No.");
    //                   END;
    //                 END;
    //             END;
    //           END;
    //         END;

    //         EXIT('');
    //         // FV4 005 00000000.e
    //     end;

    //     procedure ChangeCurrency(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20])
    //     var
    //         lrc_FVTempI: Record "5110360";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesShipmentHeader: Record "110";
    //         lrc_SalesShipmentLine: Record "111";
    //         lrc_ValueEntry: Record "5802";
    //         lfm_ChangeCurrency: Form "5110339";
    //         TEXT001: Label 'Währungswechsel nicht möglich, da bereits fakturierte Mengen vorhanden sind!';
    //         TEXT002: Label 'Neue Währung entspricht der bereits aktuelle Währung!';
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // Funktion zum Wechsel der Währung
    //         // ---------------------------------------------------------------------------------------------------------

    //         // SAL 011 KHH50199.s
    //         lrc_SalesHeader.GET(vop_DocType,vco_DocNo);

    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF lrc_SalesLine."Quantity Invoiced" <> 0 THEN
    //               // Währungswechsel nicht möglich, da bereits fakturierte Mengen vorhanden sind!
    //               ERROR(TEXT001);
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;

    //         lrc_FVTempI.Reset();
    //         lrc_FVTempI.SETRANGE("User ID",UserID());
    //         lrc_FVTempI.SETRANGE("Entry Type",lrc_FVTempI."Entry Type"::WW);
    //         IF lrc_FVTempI.FIND('-') THEN
    //           lrc_FVTempI.DELETEALL();

    //         lrc_FVTempI.Reset();
    //         lrc_FVTempI.INIT();
    //         lrc_FVTempI."User ID" := USERID;
    //         lrc_FVTempI."Entry Type" := lrc_FVTempI."Entry Type"::WW;
    //         lrc_FVTempI."WW Aktuelle Währung" := lrc_SalesHeader."Currency Code";
    //         lrc_FVTempI."WW Neue Währung" := lrc_SalesHeader."Currency Code";
    //         lrc_FVTempI.insert();
    //         COMMIT;

    //         lrc_FVTempI.Reset();
    //         lrc_FVTempI.FILTERGROUP(2);
    //         lrc_FVTempI.SETRANGE("User ID",UserID());
    //         lrc_FVTempI.SETRANGE("Entry Type",lrc_FVTempI."Entry Type"::WW);
    //         lrc_FVTempI.FILTERGROUP(0);

    //         CLEAR(lfm_ChangeCurrency);
    //         lfm_ChangeCurrency.LOOKUPMODE := TRUE;
    //         lfm_ChangeCurrency.SETTABLEVIEW(lrc_FVTempI);
    //         IF lfm_ChangeCurrency.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_FVTempI.Reset();
    //         lfm_ChangeCurrency.GETRECORD(lrc_FVTempI);
    //         IF lrc_FVTempI."WW Aktuelle Währung" = lrc_FVTempI."WW Neue Währung" THEN
    //           // Neue Währung entspricht der bereits aktuelle Währung!
    //           ERROR(TEXT002);

    //         // Verkaufskopfsatz ändern
    //         lrc_SalesHeader.VALIDATE("Currency Code",lrc_FVTempI."WW Neue Währung");
    //         lrc_SalesHeader.MODIFY(TRUE);

    //         // Verkaufszeilenzeilen ändern
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_SalesLine.VALIDATE("Currency Code",lrc_FVTempI."WW Neue Währung");
    //             lrc_SalesLine.VALIDATE("Sales Price (Price Base)");
    //             lrc_SalesLine.MODIFY(TRUE);
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //         // SAL 011 KHH50199.e


    //         // Lieferscheine anpassen
    //         IF lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::Order THEN BEGIN
    //           lrc_SalesShipmentHeader.Reset();
    //           lrc_SalesShipmentHeader.SETCURRENTKEY("Order No.");
    //           lrc_SalesShipmentHeader.SETRANGE("Order No.",lrc_SalesHeader."No.");
    //           IF lrc_SalesShipmentHeader.FIND('-') THEN BEGIN
    //             REPEAT
    //               lrc_SalesShipmentHeader."Currency Code" := lrc_SalesHeader."Currency Code";
    //               lrc_SalesShipmentHeader."Currency Factor" := lrc_SalesHeader."Currency Factor";
    //               lrc_SalesShipmentHeader.Modify();

    //               lrc_SalesShipmentLine.SETRANGE("Document No.",lrc_SalesShipmentHeader."No.");
    //               IF lrc_SalesShipmentLine.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   lrc_SalesShipmentLine."Currency Code" := lrc_SalesShipmentHeader."Currency Code";
    //                   lrc_SalesShipmentLine.Modify();
    //                 UNTIL lrc_SalesShipmentLine.NEXT() = 0;
    //               END;
    //             UNTIL lrc_SalesShipmentHeader.NEXT() = 0;
    //           END;
    //         END;
    //     end;

    //     procedure CalcSalesOrder(var rrc_SalesHeader: Record "36")
    //     var
    //         lcu_CalcUnitCostandSalesPrice: Codeunit "5110335";
    //         lcu_DiscountMgt: Codeunit "5110312";
    //         lcu_EmptiesMgt: Codeunit "5110325";
    //         lcu_SalesPurchVATEvaluationMgt: Codeunit "5110360";
    //         lcu_DutyTarifMgt: Codeunit "5110383";
    //         lcu_FreightMgt: Codeunit "5110313";
    //         lcu_InsuranceMgt: Codeunit "5087907";
    //         lcu_StdFreightMgt: Codeunit "5087908";
    //         lrc_CustomerSpecificFunctions: Codeunit "5110348";
    //         lrc_ADFSetup: Record "5110302";
    //     begin
    //         // ---------------------------------------------------------------------------------------------------
    //         // Funktion zur Gesamtkalkulation der Werte eines Verkaufsauftrages
    //         // ---------------------------------------------------------------------------------------------------

    //         lrc_ADFSetup.GET();

    //         // Einstandspreise erneut laden
    //         lcu_CalcUnitCostandSalesPrice.SalesReLoadUnitCost(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.");

    //         // Leergut
    //         CASE lrc_ADFSetup."Empties/Transport Type" OF
    //         lrc_ADFSetup."Empties/Transport Type"::"Systematik 1":
    //           BEGIN
    //             // Leergutzeilen erstellen
    //             lcu_EmptiesMgt.EmptiesItemSalesLines(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.", 0);
    //             // Transportmittelzeilen erstellen
    //         //xx    IF lrc_ADFSetup."Empties/Transport Subtype" = lrc_ADFSetup."Empties/Transport Subtype"::" " THEN
    //         //xx    lcu_EmptiesMgt.SalesInsLineFromSalesEmpties(rrc_SalesHeader);
    //           END;
    //         lrc_ADFSetup."Empties/Transport Type"::"Systematik 2":
    //           BEGIN
    //             IF (rrc_SalesHeader."Sales Doc. Subtype Code" <> '') AND
    //                ((rrc_SalesHeader."Document Type" = rrc_SalesHeader."Document Type"::Invoice) AND
    //                 (rrc_SalesHeader."Sales Doc. Subtype Code" = lrc_ADFSetup."SalesInv Empties Doc. Typ Code")) OR
    //                ((rrc_SalesHeader."Document Type" = rrc_SalesHeader."Document Type"::"Credit Memo") AND
    //                 (rrc_SalesHeader."Sales Doc. Subtype Code" = lrc_ADFSetup."SalesCrM Empties Doc. Typ Code")) THEN BEGIN
    //               // Leergutzeilen erstellen
    //               lcu_EmptiesMgt.EmptiesItemSalesLines(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.", 0);
    //               // Transportmittelzeilen erstellen
    //         //xx      lcu_EmptiesMgt.SalesInsLineFromSalesEmpties(rrc_SalesHeader);
    //             END;
    //           END;
    //         END;

    //         // Berechnung Zoll --> muss vor Rabattberechnung stattfinden, da es Zollabhängige Rabatte geben kann
    //         IF (lrc_ADFSetup."Calc. Type Duty in Sales Line" =
    //             lrc_ADFSetup."Calc. Type Duty in Sales Line"::"Calculation Duty Amount by Tariff") OR
    //            (lrc_ADFSetup."Calc. Type Duty in Sales Line" =
    //            lrc_ADFSetup."Calc. Type Duty in Sales Line"::"Duty Amount manual Entered ") THEN BEGIN
    //           IF rrc_SalesHeader."Document Type" = rrc_SalesHeader."Document Type"::Order THEN BEGIN
    //             lcu_DutyTarifMgt.CalcDutySalesOrder(rrc_SalesHeader);
    //             lcu_DutyTarifMgt.SalesLoadDutyInCostControle(rrc_SalesHeader."No.");
    //           END;
    //         END;

    //         // Berechnung der DSD / ARA Werte
    //         CalcGreenPoint(rrc_SalesHeader);
    //         // Berechnung der Frachtkosten
    //         lcu_FreightMgt.SalesFreightCostsPerOrder(rrc_SalesHeader);
    //         COMMIT;
    //         // Frachtkosten in Kontrolltabelle eintragen
    //         lcu_FreightMgt.FreightCostContrSalesLoad(rrc_SalesHeader);
    //         COMMIT;

    //         // Kontrolle der Frachtkosten
    //         lcu_FreightMgt.SalesFreightCheck(rrc_SalesHeader);
    //         // Berechnung der Standard Frachtkosten
    //         IF lrc_ADFSetup."Sales Std. Freight Cost activ" = TRUE THEN BEGIN
    //           lcu_StdFreightMgt.CalcStandardSalesFreightCost(rrc_SalesHeader."No.");
    //         END;

    //         //-POI-JW 22.05.19
    //         /*die Ermittlung muss nach später erfolgen:
    //         // Berechnung der Rabatte --> zum Schluss falls abhängig von anderen Werten
    //         lcu_DiscountMgt.SalesDiscCalcLines(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.");
    //         */
    //         //+POI-JW 22.05.19

    //         // Berechnung Versicherung
    //         IF lrc_ADFSetup."Sales Std. Insurance activ" = TRUE THEN BEGIN
    //           lcu_InsuranceMgt.CalcSalesOrderInsuranceCost(rrc_SalesHeader);
    //         END;

    //         // Kontrolle Steuerliche Situation
    //         IF lrc_ADFSetup."Sales Find Bus. Posting Group" = TRUE THEN BEGIN
    //           lcu_SalesPurchVATEvaluationMgt.SalesCalcBusPosGrp(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.");
    //         END;

    //         //-POI-JW 22.05.19
    //         // Berechnung der Rabatte --> zum Schluss falls abhängig von anderen Werten
    //         lcu_DiscountMgt.SalesDiscCalcLines(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.");
    //         //+POI-JW 22.05.19

    //         // Prüfung und setzen MwSt für Leergüter
    //         lcu_SalesPurchVATEvaluationMgt.SalesCheckVATForEmptYItem(rrc_SalesHeader);

    //     end;

    //     procedure CalcSalesCreditMemo(var rrc_SalesHeader: Record "36")
    //     var
    //         lcu_EmptiesManagement: Codeunit "5110325";
    //         lcu_DiscountMgt: Codeunit "5110312";
    //         lcu_DutyTarifMgt: Codeunit "5110383";
    //         lcu_FreightMgt: Codeunit "5110313";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lcu_SalesPurchVATEvaluationMgt: Codeunit "5110360";
    //     begin
    //         // ---------------------------------------------------------------------------------------------------
    //         // Funktion zur Gesamtkalkulation der Werte einer Gutschrift
    //         // ---------------------------------------------------------------------------------------------------

    //         IF (rrc_SalesHeader."Document Type" <> rrc_SalesHeader."Document Type"::"Credit Memo") AND
    //            (rrc_SalesHeader."Document Type" <> rrc_SalesHeader."Document Type"::"Return Order") THEN
    //           EXIT;

    //         lrc_FruitVisionSetup.GET();
    //         CASE lrc_FruitVisionSetup."Empties/Transport Type" OF
    //         lrc_FruitVisionSetup."Empties/Transport Type"::"Systematik 1":
    //           BEGIN
    //             // Leergutzeilen erstellen
    //             lcu_EmptiesManagement.EmptiesItemSalesLines(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.", 0);
    //             // Transportmittelzeilen erstellen
    //         //xx    lcu_EmptiesManagement.SalesInsLineFromSalesEmpties(rrc_SalesHeader);
    //           END;
    //         lrc_FruitVisionSetup."Empties/Transport Type"::"Systematik 2":
    //           BEGIN

    //           END;
    //         END;

    //         // Berechnung Zoll --> muss vor Rabattberechnung stattfinden, da es Zollabhängige Rabatte geben kan
    //         IF lrc_FruitVisionSetup."Calc. Type Duty in Sales Line" =
    //            lrc_FruitVisionSetup."Calc. Type Duty in Sales Line"::"Calculation Duty Amount by Tariff" THEN BEGIN
    //           // VEZ 001 IFW40154.s
    //           // lcu_DutyTarifMgt._CalcDutyTarifAmountSalesHeade(vrc_SalesHeader);
    //           lcu_DutyTarifMgt.CalcDutySalesOrder(rrc_SalesHeader);
    //           // VEZ 001 IFW40154.e
    //         END;

    //         // Berechnung der Rabatte
    //         lcu_DiscountMgt.SalesDiscCalcLines(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.");

    //         // Berechnung der Frachtkosten
    //         lcu_FreightMgt.SalesFreightCostsPerOrder(rrc_SalesHeader);
    //         COMMIT;
    //         // Frachtkosten in Kontrolltabelle eintragen
    //         lcu_FreightMgt.FreightCostContrSalesLoad(rrc_SalesHeader);
    //         COMMIT;

    //         // Kontrolle der Frachtkosten
    //         lcu_FreightMgt.SalesFreightCheck(rrc_SalesHeader);

    //         // VAT 001 MFL40119.s
    //         // Kontrolle Steuerliche Situation
    //         IF lrc_FruitVisionSetup."Sales Find Bus. Posting Group" = TRUE THEN BEGIN
    //           lcu_SalesPurchVATEvaluationMgt.SalesCalcBusPosGrp(rrc_SalesHeader."Document Type",rrc_SalesHeader."No.");
    //         END;
    //         // VAT 001 MFL40119.e

    //         // SAL 016 KHH50226.s
    //         // Prüfung und setzen MwSt für Leergüter
    //         lcu_SalesPurchVATEvaluationMgt.SalesCheckVATForEmptYItem(rrc_SalesHeader);
    //         // SAL 016 KHH50226.e
    //     end;

    //     procedure "-- POSTING --"()
    //     begin
    //     end;

    //     procedure SalesOrderPostAndPrint(vrc_SalesHeader: Record "36";vbn_Print: Boolean)
    //     var
    //         lcu_CheckPostingMgt: Codeunit "5087911";
    //         lcu_CashBoxMgt: Codeunit "5110330";
    //         lcu_GlobalVariablesMgt: Codeunit "5110358";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         AgilesText01: Label 'Buchungsdatum %1  Möchten Sie das Buchungsdatum auf das heutige Datum setzen ?';
    //         AgilesText02: Label 'Die Bestellung %1 wurde erstellt !';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum Buchen und Drucken aus dem Verkaufsauftrag
    //         // ------------------------------------------------------------------------------------

    //         //xx lcu_Palletmanagement.SalesCrMemoPostCheckPallet(Rec);

    //         // Rekalulation Auftrag
    //         CalcSalesOrder(vrc_SalesHeader);

    //         // Kopfsatz erneut lesen
    //         lrc_SalesHeader.GET(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.");

    //         // Prüfung vor Buchen
    //         lcu_CheckPostingMgt.SalesCheckBeforePosting(lrc_SalesHeader);

    //         // Kontrolle auf Barzahlung / Scheck
    //         lrc_SalesDocType.GET(lrc_SalesHeader."Document Type",lrc_SalesHeader."Sales Doc. Subtype Code");
    //         IF lrc_SalesDocType."Cash/Cheque Sales" = TRUE THEN BEGIN
    //           // Kopfsatz erneut lesen
    //           lrc_SalesHeader.GET(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.");
    //           lrc_SalesHeader."Bal. Account Type" := lrc_SalesHeader."Bal. Account Type"::"G/L Account";
    //           lrc_SalesHeader."Bal. Account No." := lcu_CashBoxMgt.CloseCashSalesOrderSinglePay(lrc_SalesHeader);
    //           lrc_SalesHeader.Modify();
    //         END;

    //         // Kopfsatz erneut lesen
    //         COMMIT;
    //         lrc_SalesHeader.GET(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.");

    //         // Buchen und drucken
    //         lcu_GlobalVariablesMgt.SetSalesShipInv(FALSE,FALSE);
    //         IF vbn_Print = TRUE THEN BEGIN
    //           CODEUNIT.RUN(CODEUNIT::"Sales-Post + Print",lrc_SalesHeader);
    //         // Buchen
    //         END ELSE BEGIN
    //           CODEUNIT.RUN(CODEUNIT::"Sales-Post (Yes/No)",lrc_SalesHeader);
    //         END;
    //     end;

    //     procedure SalesCrMemoPostAndPrint(vrc_SalesHeader: Record "36";vbn_Print: Boolean)
    //     var
    //         lcu_CheckPostingMgt: Codeunit "5087911";
    //         lcu_CashBoxMgt: Codeunit "5110330";
    //         lcu_GlobalVariablesMgt: Codeunit "5110358";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum Buchen und Drucken aus dem Verkaufsgutschrift
    //         // ------------------------------------------------------------------------------------

    //         // Rekalulation Gutschrift
    //         CalcSalesCreditMemo(vrc_SalesHeader);

    //         // Kopfsatz erneut lesen
    //         COMMIT;
    //         lrc_SalesHeader.GET(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.");

    //         // Buchen und drucken
    //         lcu_GlobalVariablesMgt.SetSalesShipInv(FALSE,FALSE);
    //         IF vbn_Print = TRUE THEN BEGIN
    //           CODEUNIT.RUN(CODEUNIT::"Sales-Post + Print",lrc_SalesHeader);
    //         // Buchen
    //         END ELSE BEGIN
    //           CODEUNIT.RUN(CODEUNIT::"Sales-Post (Yes/No)",lrc_SalesHeader);
    //         END;
    //     end;

    //     procedure "-- BLANKET ORDER --"()
    //     begin
    //     end;

    //     procedure ShowBlanketSalesOrder(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];vbn_GlobalCard: Boolean)
    //     var
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_SalesHdr: Record "36";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Öffnen eines Rahmenauftrages aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         lrc_SalesHdr.GET(vop_DocType,vco_DocNo);
    //         lrc_SalesDocType.GET(lrc_SalesHdr."Document Type",lrc_SalesHdr."Sales Doc. Subtype Code");
    //         lrc_SalesDocType.TESTFIELD("Form ID Card");

    //         IF vbn_GlobalCard = TRUE THEN
    //           lrc_SalesDocType.TESTFIELD("Form ID Global Card");

    //         IF lrc_SalesDocType."Allow Scrolling in Card" = FALSE THEN BEGIN
    //           lrc_SalesHdr.FILTERGROUP(2);
    //           lrc_SalesHdr.SETRANGE("Document Type",lrc_SalesHdr."Document Type");
    //           lrc_SalesHdr.SETRANGE("No.",lrc_SalesHdr."No.");
    //           lrc_SalesHdr.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHdr."Sales Doc. Subtype Code");
    //           lrc_SalesHdr.FILTERGROUP(0);
    //         END ELSE BEGIN
    //           lrc_SalesHdr.FILTERGROUP(2);
    //           lrc_SalesHdr.SETRANGE("Document Type",lrc_SalesHdr."Document Type");
    //           lrc_SalesHdr.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHdr."Sales Doc. Subtype Code");
    //           lrc_SalesHdr.FILTERGROUP(0);
    //         END;

    //         IF vbn_GlobalCard = TRUE THEN
    //           FORM.RUN(lrc_SalesDocType."Form ID Global Card",lrc_SalesHdr)
    //         ELSE
    //           FORM.RUN(lrc_SalesDocType."Form ID Card",lrc_SalesHdr);
    //     end;

    //     procedure NewBlanketSalesOrder(vco_SalesDocType: Code[10])
    //     var
    //         lrc_SalesHdr: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         AGILES_TEXT001: Label 'Neuanlage nur über Belegart zulässig!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Anlegen eines Rahmenauftrages aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         IF vco_SalesDocType = '' THEN
    //            // Neuanlage nur über Belegart zulässig!
    //            ERROR(AGILES_TEXT001);

    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::"Blanket Order",vco_SalesDocType);

    //         lrc_SalesHdr.Reset();
    //         lrc_SalesHdr.INIT();
    //         lrc_SalesHdr.VALIDATE("Document Type",lrc_SalesHdr."Document Type"::"Blanket Order");
    //         lrc_SalesHdr."Sales Doc. Subtype Code" := vco_SalesDocType;
    //         IF lrc_SalesDocType."Quality Control Vendor No." <> '' THEN BEGIN
    //           lrc_SalesHdr.VALIDATE("Quality Control Vendor No.", lrc_SalesDocType."Quality Control Vendor No.");
    //         END;
    //         lrc_SalesHdr.INSERT(TRUE);

    //         IF lrc_SalesDocType."Default Location Code" <> '' THEN BEGIN
    //           lrc_SalesHdr.VALIDATE("Location Code",lrc_SalesDocType."Default Location Code");
    //           lrc_SalesHdr.Modify();
    //         END;

    //         ShowBlanketSalesOrder(lrc_SalesHdr."Document Type",lrc_SalesHdr."No.",FALSE);
    //     end;

    //     procedure "-- DOC TYPE --"()
    //     begin
    //     end;

    //     procedure CheckCustDocTyp(vrc_SalesHeader: Record "36"): Boolean
    //     var
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_SalesDocTypeFilter: Record "5110414";
    //         lrc_Customer: Record "Customer";
    //         "lbn_Zulässig": Boolean;
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Prüfung ob Debitor für Belegart zulässig
    //         // ---------------------------------------------------------------------------------
    //         IF vrc_SalesHeader."Sell-to Customer No." = '' THEN
    //           EXIT(TRUE);

    //         // Belegart muss vorhanden sein
    //         vrc_SalesHeader.TESTFIELD("Sales Doc. Subtype Code");

    //         lrc_SalesDocType.GET(vrc_SalesHeader."Document Type",vrc_SalesHeader."Sales Doc. Subtype Code");
    //         IF (lrc_SalesDocType."Restrict Customers" = FALSE) THEN
    //           EXIT(TRUE);

    //         // Prüfung auf Debitorennummer
    //         lrc_SalesDocTypeFilter.Reset();
    //         lrc_SalesDocTypeFilter.SETRANGE("Document Type",lrc_SalesDocType."Document Type");
    //         lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code",lrc_SalesDocType.Code);
    //         lrc_SalesDocTypeFilter.SETRANGE(Source,lrc_SalesDocTypeFilter.Source::Customer);
    //         lrc_SalesDocTypeFilter.SETRANGE("Source No.",vrc_SalesHeader."Sell-to Customer No.");
    //         IF lrc_SalesDocTypeFilter.FIND('-') THEN BEGIN
    //           IF lrc_SalesDocTypeFilter."Not Allowed" = TRUE THEN
    //             EXIT(FALSE)
    //           ELSE
    //             EXIT(TRUE);

    //         END ELSE BEGIN

    //           // Prüfung auf Unternehmenskette
    //           lrc_Customer.GET(vrc_SalesHeader."Sell-to Customer No.");
    //           IF lrc_Customer."Chain Name" = '' THEN
    //             EXIT(FALSE);

    //           lrc_SalesDocTypeFilter.Reset();
    //           lrc_SalesDocTypeFilter.SETRANGE("Document Type",lrc_SalesDocType."Document Type");
    //           lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code",lrc_SalesDocType.Code);
    //           lrc_SalesDocTypeFilter.SETRANGE(Source,lrc_SalesDocTypeFilter.Source::"Customer Chain");
    //           lrc_SalesDocTypeFilter.SETRANGE("Source No.",lrc_Customer."Chain Name");
    //           IF lrc_SalesDocTypeFilter.FIND('-') THEN BEGIN
    //             IF lrc_SalesDocTypeFilter."Not Allowed" = TRUE THEN
    //               EXIT(FALSE)
    //             ELSE
    //               EXIT(TRUE);
    //           END ELSE
    //             EXIT(FALSE);

    //         END;

    //         // Zur Sicherheit
    //         EXIT(FALSE);
    //     end;

    //     procedure CheckLocationDocTyp(vop_DocTyp: Option "0","1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];vco_DocTypCode: Code[10];vco_LocationCode: Code[10])
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_SalesDocTypeFilter: Record "5110414";
    //         TEXT001: Label 'Lager für Belegart nicht zulässig!';
    //         TEXT002: Label 'Lager ist nicht identisch mit Lager in Verkaufskopf!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Prüfen ob Lagerort für Belegart zulässig
    //         // -----------------------------------------------------------------------------

    //         IF vco_DocTypCode = '' THEN
    //           EXIT;

    //         lrc_SalesDocType.GET(vop_DocTyp,vco_DocTypCode);
    //         CASE lrc_SalesDocType."Restrict Locations" OF
    //         lrc_SalesDocType."Restrict Locations"::Vorgabe:
    //           BEGIN

    //           END;
    //         lrc_SalesDocType."Restrict Locations"::"Feste Eingrenzung":
    //           BEGIN
    //             lrc_SalesDocTypeFilter.Reset();
    //             lrc_SalesDocTypeFilter.SETRANGE("Document Type",vop_DocTyp);
    //             lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code",vco_DocTypCode);
    //             lrc_SalesDocTypeFilter.SETRANGE(Source,lrc_SalesDocTypeFilter.Source::Location);
    //             lrc_SalesDocTypeFilter.SETRANGE("Source No.",vco_LocationCode);
    //             IF NOT lrc_SalesDocTypeFilter.FIND('-') THEN
    //               // Lager für Belegart nicht zulässig!
    //               ERROR(TEXT001);
    //           END;
    //         lrc_SalesDocType."Restrict Locations"::Belegkopf:
    //           BEGIN
    //             IF lrc_SalesHeader.GET(vop_DocTyp,vco_DocNo) THEN BEGIN
    //               IF lrc_SalesHeader."Location Code" <> vco_LocationCode THEN
    //                 // Lager ist nicht identisch mit Lager in Verkaufskopf!
    //                 ERROR(TEXT002);
    //             END;
    //           END;
    //         END;
    //     end;

    //     procedure CheckItemDocTyp(vop_DocTyp: Option "0","1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];vco_DocTypCode: Code[10];vco_ItemNo: Code[20]): Boolean
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_Customer: Record "Customer";
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_SalesDocTypeFilter: Record "5110414";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Prüfen ob Artikel für Belegart zulässig
    //         // -----------------------------------------------------------------------------

    //         IF vco_DocNo = '' THEN
    //           EXIT(TRUE);
    //         IF vco_DocTypCode = '' THEN
    //           EXIT(TRUE);
    //         IF vco_ItemNo = '' THEN
    //           EXIT(TRUE);

    //         lrc_SalesDocType.GET(vop_DocTyp,vco_DocTypCode);
    //         lrc_SalesDocTypeFilter.Reset();
    //         lrc_SalesDocTypeFilter.SETRANGE("Document Type",vop_DocTyp);
    //         lrc_SalesDocTypeFilter.SETRANGE("Sales Doc. Subtype Code",vco_DocTypCode);
    //         lrc_SalesDocTypeFilter.SETRANGE(Source,lrc_SalesDocTypeFilter.Source::"Item Chain");
    //         lrc_SalesDocTypeFilter.SETRANGE("Source No.",'');
    //         IF lrc_SalesDocTypeFilter.FIND('-') THEN BEGIN
    //           lrc_SalesHeader.GET(vop_DocTyp,vco_DocNo);
    //           lrc_Customer.GET(lrc_SalesHeader."Sell-to Customer No.");
    //           REPEAT


    //           UNTIL lrc_SalesDocTypeFilter.NEXT() = 0;
    //         END;
    //     end;

    //     procedure "---"()
    //     begin
    //     end;

    //     procedure ShowBatchVarSalesShipped(vco_ItemNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_SalesShipmentLine: Record "111";
    //         AGILES_LT_TEXT001: Label 'Nur für Positionsvarianten!';
    //         AGILES_LT_TEXT002: Label 'Keine Anzeige für Mehrfacheinträge pro Zeile!';
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Verkaufslieferzeilen
    //         // ----------------------------------------------------------------------------------------

    //         IF vco_BatchVariantNo = '' THEN
    //           // Nur für Positionsvarianten!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_BatchSetup.GET();
    //         CASE lrc_BatchSetup."Sales Batch Assignment" OF
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line" :
    //           BEGIN
    //             lrc_SalesShipmentLine.Reset();
    //             lrc_SalesShipmentLine.SETCURRENTKEY("Batch Variant No.");
    //             lrc_SalesShipmentLine.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //             lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
    //             lrc_SalesShipmentLine.SETRANGE("No.",vco_ItemNo);
    //             lrc_SalesShipmentLine.SETFILTER(Quantity,'<>%1',0);
    //             FORM.RUNMODAL(525,lrc_SalesShipmentLine);
    //           END;
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line" :
    //           BEGIN
    //             // Keine Anzeige für Mehrfacheinträge pro Zeile!
    //             ERROR(AGILES_LT_TEXT002)
    //           END;
    //         ELSE
    //           // Keine Anzeige für Mehrfacheinträge pro Zeile!
    //           ERROR(AGILES_LT_TEXT002)

    //         END;
    //     end;

    //     procedure ShowBatchVarSalesInvoiced(vco_ItemNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_SalesInvoiceLine: Record "113";
    //         AGILES_LT_TEXT001: Label 'Nur für Positionsvarianten!';
    //         AGILES_LT_TEXT002: Label 'Keine Anzeige für Mehrfacheinträge pro Zeile!';
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Verkaufsrechnungszeilen
    //         // ----------------------------------------------------------------------------------------

    //         IF vco_BatchVariantNo = '' THEN
    //           // Nur für Positionsvarianten!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_BatchSetup.GET();
    //         CASE lrc_BatchSetup."Sales Batch Assignment" OF
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line" :
    //           BEGIN
    //             lrc_SalesInvoiceLine.Reset();
    //             lrc_SalesInvoiceLine.SETCURRENTKEY(Type,"No.","Batch Variant No.");
    //             lrc_SalesInvoiceLine.SETRANGE(Type,lrc_SalesInvoiceLine.Type::Item);
    //             lrc_SalesInvoiceLine.SETRANGE("No.",vco_ItemNo);
    //             lrc_SalesInvoiceLine.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //             FORM.RUNMODAL(526,lrc_SalesInvoiceLine);
    //           END;
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line" :
    //           BEGIN
    //             // Keine Anzeige für Mehrfacheinträge pro Zeile!
    //             ERROR(AGILES_LT_TEXT002)
    //           END;
    //         END;
    //     end;

    //     procedure ShowBatchVarSalesCreditMemo(vco_ItemNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_SalesCrMemoLine: Record "115";
    //         AGILES_LT_TEXT001: Label 'Nur für Positionsvarianten!';
    //         AGILES_LT_TEXT002: Label 'Keine Anzeige für Mehrfacheinträge pro Zeile!';
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Verkaufsgutschriftszeilen
    //         // ----------------------------------------------------------------------------------------

    //         IF vco_BatchVariantNo = '' THEN
    //           // Nur für Positionsvarianten!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_BatchSetup.GET();
    //         CASE lrc_BatchSetup."Sales Batch Assignment" OF
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line" :
    //           BEGIN
    //             lrc_SalesCrMemoLine.Reset();
    //             lrc_SalesCrMemoLine.SETCURRENTKEY(Type,"No.","Batch Variant No.");
    //             lrc_SalesCrMemoLine.SETRANGE(Type,lrc_SalesCrMemoLine.Type::Item);
    //             lrc_SalesCrMemoLine.SETRANGE("No.",vco_ItemNo);
    //             lrc_SalesCrMemoLine.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //             FORM.RUNMODAL(527,lrc_SalesCrMemoLine);
    //           END;
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line" :
    //           BEGIN
    //             // Keine Anzeige für Mehrfacheinträge pro Zeile!
    //             ERROR(AGILES_LT_TEXT002)
    //           END;
    //         END;
    //     end;

    //     procedure ShowBatchVarSalesReturnReceipt(vco_ItemNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_ReturnReceiptLine: Record "6661";
    //         AGILES_LT_TEXT001: Label 'Nur für Positionsvarianten!';
    //         AGILES_LT_TEXT002: Label 'Keine Anzeige für Mehrfacheinträge pro Zeile!';
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Rücksendungszeilen
    //         // ----------------------------------------------------------------------------------------

    //         IF vco_BatchVariantNo = '' THEN
    //           // Nur für Positionsvarianten!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_BatchSetup.GET();
    //         CASE lrc_BatchSetup."Sales Batch Assignment" OF
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line" :
    //           BEGIN
    //             lrc_ReturnReceiptLine.Reset();
    //             lrc_ReturnReceiptLine.SETCURRENTKEY(Type,"No.","Batch Variant No.");
    //             lrc_ReturnReceiptLine.SETRANGE(Type,lrc_ReturnReceiptLine.Type::Item);
    //             lrc_ReturnReceiptLine.SETRANGE("No.",vco_ItemNo);
    //             lrc_ReturnReceiptLine.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //             lrc_ReturnReceiptLine.SETFILTER(Quantity,'<>%1',0);
    //             FORM.RUNMODAL(6663,lrc_ReturnReceiptLine);
    //           END;
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line" :
    //           BEGIN
    //             // Keine Anzeige für Mehrfacheinträge pro Zeile!
    //             ERROR(AGILES_LT_TEXT002)
    //           END;
    //         END;
    //     end;

    //     procedure ShowBatchVarSalesOrderLines(vco_ItemNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_SalesLine: Record "37";
    //         AGILES_TEXT001: Label 'Anzeige nur für Positionsvarianten möglich!';
    //         lrc_BatchVariantDetail: Record "5110487";
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Anzeigen der Verkaufszeilen zu einer Batch Variantennr.
    //         // ---------------------------------------------------------------------------------------

    //         IF vco_BatchVariantNo = '' THEN
    //           // Anzeige nur für Positionsvarianten möglich!
    //           ERROR(AGILES_TEXT001);

    //         lrc_BatchSetup.GET();
    //         CASE lrc_BatchSetup."Sales Batch Assignment" OF
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line" :
    //           BEGIN
    //             lrc_SalesLine.Reset();
    //             lrc_SalesLine.SETCURRENTKEY("Batch Variant No.");
    //             lrc_SalesLine.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //             lrc_SalesLine.SETRANGE("Document Type",lrc_SalesLine."Document Type"::Order);
    //             lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //             lrc_SalesLine.SETFILTER("Outstanding Quantity",'<>%1',0);
    //             FORM.RUNMODAL(516,lrc_SalesLine);
    //           END;
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line" :
    //           BEGIN
    //             lrc_BatchVariantDetail.Reset();
    //             lrc_BatchVariantDetail.SETRANGE(Source,lrc_BatchVariantDetail.Source::Sales);
    //             lrc_BatchVariantDetail.SETRANGE("Source Type",lrc_BatchVariantDetail."Source Type"::Order);
    //             lrc_BatchVariantDetail.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //             lrc_BatchVariantDetail.SETFILTER("Qty. Outstanding",'<>%1',0);
    //             FORM.RUNMODAL(5110619,lrc_BatchVariantDetail);
    //           END;
    //         END;
    //     end;

    //     procedure ShowBatchVarPackingInputLines(vco_ItemNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_PackOrderInputItems: Record "5110714";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Packerei Inputzeilen
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackOrderInputItems.Reset();
    //         //lrc_PackOrderInputItems.SETCURRENTKEY("Item No.","Variant Code","Batch Variant No.","Location Code");
    //         lrc_PackOrderInputItems.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_PackOrderInputItems.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //         lrc_PackOrderInputItems.SETFILTER(Quantity,'<>%1',0);
    //         FORM.RUNMODAL(5110735,lrc_PackOrderInputItems);
    //     end;

    //     procedure ShowBatchVarPPackingInputLines(vco_ItemNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Packerei Inputzeilen
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackOrderInputPackItems.Reset();
    //         lrc_PackOrderInputPackItems.SETCURRENTKEY("Item No.","Variant Code","Batch Variant No.","Location Code");
    //         lrc_PackOrderInputPackItems.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_PackOrderInputPackItems.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //         lrc_PackOrderInputPackItems.SETFILTER(Quantity,'<>%1',0);
    //         FORM.RUNMODAL(5088112,lrc_PackOrderInputPackItems);
    //     end;

    //     procedure CreateItemChargeSalesDoc(vrc_SalesHeader: Record "36";vco_SalesOrderNo: Code[20];vco_ItemChargeNo: Code[20])
    //     var
    //         lrc_SalesShipmentHeader: Record "110";
    //         SSPText001: Label 'There are no sales shipments for sales order %1 !';
    //         lrc_SalesShipmentLine: Record "111";
    //         lrc_SalesLine: Record "37";
    //         "lrc_ItemChargeAssign(Sales)": Record "5809";
    //         lin_LineNo: Integer;
    //         SSPText002: Label 'Sales Shipment';
    //         lrc_SalesShipmentLine2: Record "111";
    //         ldc_Quantity: Decimal;
    //         lbn_GenerateLine: Boolean;
    //     begin
    //         // ---------------------------------------------------------------------------------------------------
    //         // Zu- und Abschlagsbeleg auf Basis einer Lieferung erstellen
    //         // ---------------------------------------------------------------------------------------------------

    //         // SAL 002 00000000.e
    //         lrc_SalesShipmentHeader.Reset();
    //         lrc_SalesShipmentHeader.SETCURRENTKEY("Order No.");
    //         lrc_SalesShipmentHeader.SETRANGE("Order No.", vco_SalesOrderNo);
    //         IF lrc_SalesShipmentHeader.FIND('-') THEN BEGIN

    //           lrc_SalesLine.Reset();
    //           lrc_SalesLine.INIT();
    //           lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //           lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //           IF lrc_SalesLine.FIND('+') THEN BEGIN
    //             lin_LineNo := lrc_SalesLine."Line No.";
    //           END ELSE BEGIN
    //             lin_LineNo := 0;
    //           END;

    //           REPEAT

    //             lrc_SalesShipmentLine.Reset();
    //             lrc_SalesShipmentLine.SETRANGE("Document No.", lrc_SalesShipmentHeader."No.");
    //             lrc_SalesShipmentLine.SETRANGE(Type, lrc_SalesShipmentLine.Type::Item);
    //             lrc_SalesShipmentLine.SETFILTER("No.", '<>%1', '');
    //             lrc_SalesShipmentLine.SETRANGE(Correction, FALSE);
    //             lrc_SalesShipmentLine.SETFILTER(Quantity, '<>%1', 0);
    //             IF lrc_SalesShipmentLine.FIND('-') THEN BEGIN

    //                   lin_LineNo := lin_LineNo + 10000;
    //                   lrc_SalesLine.Reset();
    //                   lrc_SalesLine.INIT();
    //                   lrc_SalesLine.VALIDATE("Document Type", vrc_SalesHeader."Document Type");
    //                   lrc_SalesLine.VALIDATE("Document No.", vrc_SalesHeader."No.");
    //                   lrc_SalesLine.VALIDATE("Line No.", lin_LineNo);
    //                   lrc_SalesLine.VALIDATE(lrc_SalesLine."Sell-to Customer No.", vrc_SalesHeader."Sell-to Customer No.");
    //                   lrc_SalesLine.VALIDATE(Type, lrc_SalesLine.Type::" ");
    //                   lrc_SalesLine.VALIDATE(Description, SSPText002 + ' ' + lrc_SalesShipmentHeader."No.");
    //                   lrc_SalesLine.INSERT(TRUE);

    //                   REPEAT

    //                     lbn_GenerateLine := TRUE;
    //                     IF (lrc_SalesShipmentLine2."Order No." <> '') AND
    //                        (lrc_SalesShipmentLine2."Order Line No." <> 0) THEN BEGIN
    //                       lrc_SalesShipmentLine2.Reset();
    //                       lrc_SalesShipmentLine2.SETCURRENTKEY("Order No.", "Order Line No.", "Posting Date");
    //                       lrc_SalesShipmentLine2.SETRANGE("Document No.", lrc_SalesShipmentLine."Document No.");
    //                       lrc_SalesShipmentLine2.SETRANGE("Order No.", lrc_SalesShipmentLine."Order No.");
    //                       lrc_SalesShipmentLine2.SETRANGE("Order Line No.", lrc_SalesShipmentLine."Order Line No.");
    //                       ldc_Quantity := 0;
    //                       IF lrc_SalesShipmentLine2.FIND('-') THEN BEGIN
    //                         REPEAT
    //                           ldc_Quantity := ldc_Quantity + lrc_SalesShipmentLine2.Quantity;
    //                         UNTIL lrc_SalesShipmentLine2.NEXT() = 0;
    //                         IF ldc_Quantity <= 0 THEN BEGIN
    //                           lbn_GenerateLine := FALSE;
    //                         END;
    //                       END;
    //                     END;
    //                     IF lbn_GenerateLine = TRUE THEN BEGIN

    //                         lin_LineNo := lin_LineNo + 10000;
    //                         lrc_SalesLine.Reset();
    //                         lrc_SalesLine.INIT();
    //                         lrc_SalesLine.VALIDATE("Document Type", vrc_SalesHeader."Document Type");
    //                         lrc_SalesLine.VALIDATE("Document No.", vrc_SalesHeader."No.");
    //                         lrc_SalesLine.VALIDATE("Line No.", lin_LineNo);

    //                         lrc_SalesLine.INSERT(TRUE);

    //                         lrc_SalesLine.VALIDATE("Sell-to Customer No.", vrc_SalesHeader."Sell-to Customer No.");
    //                         lrc_SalesLine.VALIDATE(Type, lrc_SalesLine.Type::"Charge (Item)");
    //                         lrc_SalesLine.VALIDATE("No.", vco_ItemChargeNo);

    //                         lrc_SalesLine.VALIDATE(Quantity, 1);
    //                         lrc_SalesLine.VALIDATE(Description, lrc_SalesShipmentLine.Description);
    //                         lrc_SalesLine.VALIDATE("Description 2", lrc_SalesShipmentLine."Description 2");

    //                         IF lrc_SalesShipmentLine."Shortcut Dimension 1 Code" <> '' THEN BEGIN
    //                            lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", lrc_SalesShipmentLine."Shortcut Dimension 1 Code");
    //                         END;
    //                         IF lrc_SalesShipmentLine."Shortcut Dimension 2 Code" <> '' THEN BEGIN
    //                            lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", lrc_SalesShipmentLine."Shortcut Dimension 2 Code");
    //                         END;
    //                         IF lrc_SalesShipmentLine."Shortcut Dimension 3 Code" <> '' THEN BEGIN
    //                            lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", lrc_SalesShipmentLine."Shortcut Dimension 3 Code");
    //                         END;
    //                         IF lrc_SalesShipmentLine."Shortcut Dimension 4 Code" <> '' THEN BEGIN
    //                            lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", lrc_SalesShipmentLine."Shortcut Dimension 4 Code");
    //                         END;

    //                         IF lrc_SalesShipmentLine."Master Batch No." <> '' THEN BEGIN
    //                           lrc_SalesLine.VALIDATE("Master Batch No.", lrc_SalesShipmentLine."Master Batch No.");
    //                         END;
    //                         IF lrc_SalesShipmentLine."Batch No." <> '' THEN BEGIN
    //                           // Kein VALIDATE
    //                           lrc_SalesLine."Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                         END;

    //                         lrc_SalesLine.MODIFY(TRUE);

    //                         "lrc_ItemChargeAssign(Sales)".INIT();
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Document Type", lrc_SalesLine."Document Type");
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Document No.", lrc_SalesLine."Document No.");
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Document Line No.", lrc_SalesLine."Line No.");
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Line No.", 10000);
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Item Charge No.", vco_ItemChargeNo);
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Item No.", lrc_SalesShipmentLine."No.");
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE( Description, lrc_SalesShipmentLine.Description);

    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Applies-to Doc. Type",
    //                                                                     "lrc_ItemChargeAssign(Sales)"."Applies-to Doc. Type"::Shipment);
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Applies-to Doc. No.", lrc_SalesShipmentLine."Document No.");
    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Applies-to Doc. Line No.", lrc_SalesShipmentLine."Line No.");

    //                         "lrc_ItemChargeAssign(Sales)".VALIDATE("Qty. to Assign", 1);

    //                         "lrc_ItemChargeAssign(Sales)".INSERT(TRUE);
    //                      END;

    //                   UNTIL lrc_SalesShipmentLine.NEXT() = 0;
    //             END;

    //           UNTIL lrc_SalesShipmentHeader.NEXT() = 0;
    //         END ELSE BEGIN
    //           ERROR(SSPText001, vco_SalesOrderNo);
    //         END;
    //         // SAL 002 00000000.e
    //     end;

    //     procedure ChooseItemChargeSalesDoc(vrc_SalesHeader: Record "36")
    //     var
    //         lfm_CreateSalesItemCharge: Form "5110576";
    //         lco_SalesOrderNo: Code[20];
    //         lco_ItemChargeNo: Code[20];
    //     begin
    //         // ---------------------------------------------------------------------------------------------------
    //         //
    //         // ---------------------------------------------------------------------------------------------------

    //         // SAL 002 00000000.s
    //         CASE vrc_SalesHeader."Document Type" OF
    //           vrc_SalesHeader."Document Type"::"Credit Memo":
    //              BEGIN
    //                CLEAR(lfm_CreateSalesItemCharge);
    //                lfm_CreateSalesItemCharge.SetCreateDocumentType(vrc_SalesHeader."Document Type"::"Credit Memo",
    //                                                                vrc_SalesHeader."Sell-to Customer No.");
    //                IF lfm_CreateSalesItemCharge.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                  lco_SalesOrderNo := lfm_CreateSalesItemCharge.RetValue_DocumentOrderNo;
    //                  lco_ItemChargeNo := lfm_CreateSalesItemCharge.RetValue_ItemChargeNo;
    //                  IF (lco_SalesOrderNo <> '') AND
    //                     (lco_ItemChargeNo <> '') THEN BEGIN
    //                    CreateItemChargeSalesDoc(vrc_SalesHeader, lco_SalesOrderNo, lco_ItemChargeNo);
    //                  END;
    //                END;
    //              END;
    //            vrc_SalesHeader."Document Type"::Invoice:
    //              BEGIN
    //                CLEAR(lfm_CreateSalesItemCharge);
    //                lfm_CreateSalesItemCharge.SetCreateDocumentType(vrc_SalesHeader."Document Type"::Invoice,
    //                                                                vrc_SalesHeader."Sell-to Customer No.");
    //                IF lfm_CreateSalesItemCharge.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                   lco_SalesOrderNo := lfm_CreateSalesItemCharge.RetValue_DocumentOrderNo;
    //                   lco_ItemChargeNo := lfm_CreateSalesItemCharge.RetValue_ItemChargeNo;
    //                   IF (lco_SalesOrderNo <> '') AND
    //                      (lco_ItemChargeNo <> '') THEN BEGIN
    //                      CreateItemChargeSalesDoc(vrc_SalesHeader, lco_SalesOrderNo, lco_ItemChargeNo);
    //                   END;
    //                END;
    //              END;
    //         END;
    //         // SAL 002 00000000.e
    //     end;

    //     procedure SalesShowCrMemo(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20])
    //     var
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_SalesHdr: Record "36";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum öffnen einer Gutschrift aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         lrc_SalesHdr.GET(vop_DocType,vco_DocNo);

    //         lrc_SalesDocType.GET(lrc_SalesHdr."Document Type",lrc_SalesHdr."Sales Doc. Subtype Code");
    //         lrc_SalesDocType.TESTFIELD("Form ID Card");

    //         IF lrc_SalesDocType."Allow Scrolling in Card" = FALSE THEN BEGIN
    //           lrc_SalesHdr.FILTERGROUP(2);
    //           lrc_SalesHdr.SETRANGE("Document Type",lrc_SalesHdr."Document Type");
    //           lrc_SalesHdr.SETRANGE("No.",lrc_SalesHdr."No.");
    //           lrc_SalesHdr.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHdr."Sales Doc. Subtype Code");
    //           lrc_SalesHdr.FILTERGROUP(0);
    //         END ELSE BEGIN
    //           lrc_SalesHdr.FILTERGROUP(2);
    //           lrc_SalesHdr.SETRANGE("Document Type",lrc_SalesHdr."Document Type");
    //           lrc_SalesHdr.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHdr."Sales Doc. Subtype Code");
    //           lrc_SalesHdr.FILTERGROUP(0);
    //         END;
    //         FORM.RUN(lrc_SalesDocType."Form ID Card",lrc_SalesHdr);
    //     end;

    //     procedure SalesNewCrMemo(vco_SalesDocType: Code[10])
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_SalesHdr: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         AGILES_TEXT001: Label 'Neuanlage nur über Belegart zulässig!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Anlegen einer Gutschrift aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();

    //         IF vco_SalesDocType = '' THEN
    //           // Neuanlage nur über Belegart zulässig!
    //           ERROR(AGILES_TEXT001);
    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::"Credit Memo", vco_SalesDocType);

    //         lrc_SalesHdr.Reset();
    //         lrc_SalesHdr.INIT();
    //         lrc_SalesHdr.VALIDATE("Document Type",lrc_SalesHdr."Document Type"::"Credit Memo");
    //         lrc_SalesHdr."No." := '';
    //         lrc_SalesHdr."Sales Doc. Subtype Code" := vco_SalesDocType;
    //         lrc_SalesHdr.INSERT(TRUE);

    //         SalesShowCrMemo(lrc_SalesHdr."Document Type",lrc_SalesHdr."No.");
    //     end;

    //     procedure SalesShowInvoice(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20])
    //     var
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_SalesHdr: Record "36";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum öffnen einer Rechnung aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         lrc_SalesHdr.GET(vop_DocType,vco_DocNo);

    //         lrc_SalesDocType.GET(lrc_SalesHdr."Document Type",lrc_SalesHdr."Sales Doc. Subtype Code");
    //         lrc_SalesDocType.TESTFIELD("Form ID Card");

    //         IF lrc_SalesDocType."Allow Scrolling in Card" = FALSE THEN BEGIN
    //           lrc_SalesHdr.FILTERGROUP(2);
    //           lrc_SalesHdr.SETRANGE("Document Type",lrc_SalesHdr."Document Type");
    //           lrc_SalesHdr.SETRANGE("No.",lrc_SalesHdr."No.");
    //           lrc_SalesHdr.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHdr."Sales Doc. Subtype Code");
    //           lrc_SalesHdr.FILTERGROUP(0);
    //         END ELSE BEGIN
    //           lrc_SalesHdr.FILTERGROUP(2);
    //           lrc_SalesHdr.SETRANGE("Document Type",lrc_SalesHdr."Document Type");
    //           lrc_SalesHdr.SETRANGE("Sales Doc. Subtype Code",lrc_SalesHdr."Sales Doc. Subtype Code");
    //           lrc_SalesHdr.FILTERGROUP(0);
    //         END;
    //         FORM.RUN(lrc_SalesDocType."Form ID Card",lrc_SalesHdr);
    //     end;

    //     procedure SalesNewInvoice(vco_SalesDocType: Code[10])
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_SalesHdr: Record "36";
    //         lrc_SalesDocType: Record "5110411";
    //         AGILES_TEXT001: Label 'Neuanlage nur über Belegart zulässig!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Anlegen einer Rechnung aus der Übersicht
    //         // -----------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();

    //         IF vco_SalesDocType = '' THEN
    //           // Neuanlage nur über Belegart zulässig!
    //           ERROR(AGILES_TEXT001);
    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Invoice, vco_SalesDocType);

    //         lrc_SalesHdr.Reset();
    //         lrc_SalesHdr.INIT();
    //         lrc_SalesHdr.VALIDATE("Document Type",lrc_SalesHdr."Document Type"::Invoice);
    //         lrc_SalesHdr."No." := '';
    //         lrc_SalesHdr."Sales Doc. Subtype Code" := vco_SalesDocType;
    //         lrc_SalesHdr.INSERT(TRUE);

    //         SalesShowInvoice(lrc_SalesHdr."Document Type",lrc_SalesHdr."No.");
    //     end;

    //     procedure "--"()
    //     begin
    //     end;

    //     procedure CrMemoLine(var rrc_SalesLine: Record "37")
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Erstellung einer Gutschriftszeile über Auswahl der Lieferung
    //         // -----------------------------------------------------------------------------

    //         rrc_SalesLine.TESTFIELD("Line No.");

    //         CASE rrc_SalesLine.Type OF
    //         rrc_SalesLine.Type::Item:
    //           BEGIN
    //             CrMemoItem(rrc_SalesLine);
    //           END;
    //         rrc_SalesLine.Type::"Charge (Item)":
    //           BEGIN
    //             rrc_SalesLine.TESTFIELD("No.");
    //             CrMemoChargeItem(rrc_SalesLine);
    //           END;
    //         ELSE
    //           ERROR('Für Satzart ' + FORMAT(rrc_SalesLine.Type) + ' nicht zulässig!');
    //         END;
    //     end;

    //     procedure CrMemoChargeItem(var rrc_SalesLine: Record "37")
    //     var
    //         lcu_ItemChargeAssgntSales: Codeunit "5807";
    //         lrc_SalesHeader: Record "36";
    //         lrc_ItemChargeAssignSales: Record "5809";
    //         lrc_SalesShipLine: Record "111";
    //         Currency: Record "4";
    //         lfm_SalesShipLines: Form "5824";
    //         ldc_UnitCost: Decimal;
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Auswahl Lieferung und Erstellung Zu-/Abschlagszeile
    //         // -----------------------------------------------------------------------------

    //         rrc_SalesLine.TESTFIELD(Type,rrc_SalesLine.Type::"Charge (Item)");
    //         rrc_SalesLine.TESTFIELD("No.");
    //         rrc_SalesLine.TESTFIELD(Quantity);

    //         lrc_SalesHeader.GET(rrc_SalesLine."Document Type",rrc_SalesLine."Document No.");

    //         lrc_ItemChargeAssignSales.Reset();
    //         lrc_ItemChargeAssignSales.SETRANGE("Document Type",rrc_SalesLine."Document Type");
    //         lrc_ItemChargeAssignSales.SETRANGE("Document No.",rrc_SalesLine."Document No.");
    //         lrc_ItemChargeAssignSales.SETRANGE("Document Line No.",rrc_SalesLine."Line No.");
    //         IF NOT lrc_ItemChargeAssignSales.FINDFIRST() THEN BEGIN

    //           lrc_ItemChargeAssignSales.Reset();
    //           lrc_ItemChargeAssignSales.INIT();
    //           lrc_ItemChargeAssignSales."Document Type" := rrc_SalesLine."Document Type";
    //           lrc_ItemChargeAssignSales."Document No." := rrc_SalesLine."Document No.";
    //           lrc_ItemChargeAssignSales."Document Line No." := rrc_SalesLine."Line No.";
    //           lrc_ItemChargeAssignSales."Item Charge No." := rrc_SalesLine."No.";

    //           lrc_ItemChargeAssignSales.SETRANGE("Document Type",rrc_SalesLine."Document Type");
    //           lrc_ItemChargeAssignSales.SETRANGE("Document No.",rrc_SalesLine."Document No.");
    //           lrc_ItemChargeAssignSales.SETRANGE("Document Line No.",rrc_SalesLine."Line No.");

    //           lrc_SalesShipLine.Reset();
    //           lrc_SalesShipLine.SETCURRENTKEY("Sell-to Customer No.");
    //           lrc_SalesShipLine.FILTERGROUP(2);
    //           lrc_SalesShipLine.SETRANGE("Sell-to Customer No.",lrc_SalesHeader."Sell-to Customer No.");
    //           lrc_SalesShipLine.FILTERGROUP(0);

    //           lfm_SalesShipLines.SETTABLEVIEW(lrc_SalesShipLine);
    //           lfm_SalesShipLines.InitializeSales(lrc_ItemChargeAssignSales,lrc_SalesHeader."Sell-to Customer No.",ldc_UnitCost);
    //         //  lfm_SalesShipLines.InitializeShipmentDate(lrc_SalesHeader."Cr. Memo Ship. Date");
    //           lfm_SalesShipLines.LOOKUPMODE(TRUE);
    //           IF lfm_SalesShipLines.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT;

    //           lrc_ItemChargeAssignSales.Reset();
    //           lrc_ItemChargeAssignSales.SETRANGE("Document Type",rrc_SalesLine."Document Type");
    //           lrc_ItemChargeAssignSales.SETRANGE("Document No.",rrc_SalesLine."Document No.");
    //           lrc_ItemChargeAssignSales.SETRANGE("Document Line No.",rrc_SalesLine."Line No.");
    //           IF lrc_ItemChargeAssignSales.FINDFIRST() THEN BEGIN

    //             IF lrc_ItemChargeAssignSales."Applies-to Doc. Type" =
    //                lrc_ItemChargeAssignSales."Applies-to Doc. Type"::Shipment THEN BEGIN

    //               lrc_SalesShipLine.Reset();
    //               lrc_SalesShipLine.GET(lrc_ItemChargeAssignSales."Applies-to Doc. No.",
    //                                     lrc_ItemChargeAssignSales."Applies-to Doc. Line No.");

    //               // Verkaufszeile aktualisieren
    //               rrc_SalesLine."Reference Doc. No." := lrc_SalesShipLine."Document No.";
    //               rrc_SalesLine."Reference Doc. Line No." := lrc_SalesShipLine."Line No.";
    //               rrc_SalesLine."Reference Item No." := lrc_SalesShipLine."No.";

    //               rrc_SalesLine."Location Code" := lrc_SalesShipLine."Location Code";
    //               rrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_SalesShipLine."Unit of Measure Code");
    //               rrc_SalesLine.VALIDATE(Quantity,lrc_SalesShipLine.Quantity);
    //               rrc_SalesLine.VALIDATE("Unit Price",lrc_SalesShipLine."Unit Price");

    //               rrc_SalesLine."Base Unit of Measure (BU)" := lrc_SalesShipLine."Base Unit of Measure (BU)";
    //               rrc_SalesLine."Collo Unit of Measure (PQ)" := lrc_SalesShipLine."Collo Unit of Measure (PQ)";
    //               rrc_SalesLine."Packing Unit of Measure (PU)" := lrc_SalesShipLine."Packing Unit of Measure (PU)";
    //               rrc_SalesLine."Content Unit of Measure (COU)" := lrc_SalesShipLine."Content Unit of Measure (COU)";
    //               rrc_SalesLine."Transport Unit of Measure (TU)" := lrc_SalesShipLine."Transport Unit of Measure (TU)";

    //               rrc_SalesLine."Qty. per Unit of Measure" := lrc_SalesShipLine."Qty. per Unit of Measure";
    //               rrc_SalesLine."Qty. (Unit) per Transp.(TU)" := lrc_SalesShipLine."Qty. (Unit) per Transp. Unit";
    //               rrc_SalesLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipLine."Qty. (PU) per Unit of Measure";
    //               rrc_SalesLine."Quantity (PU)" := lrc_SalesShipLine."Quantity (PU)";
    //               rrc_SalesLine."Qty. (Unit) per Transp.(TU)" := lrc_SalesShipLine."Qty. (Unit) per Transp. Unit";
    //               rrc_SalesLine."Quantity (TU)" := lrc_SalesShipLine."Quantity (TU)";
    //               rrc_SalesLine."Qty. (COU) per Pack. Unit (PU)" := lrc_SalesShipLine."Qty. (COU) per Pack. Unit (PU)";

    //               rrc_SalesLine."Market Unit Cost (Base) (LCY)" := lrc_SalesShipLine."Market Unit Cost (Base) (LCY)";

    //               rrc_SalesLine."Price Base (Sales Price)" := lrc_SalesShipLine."Price Base (Sales Price)";
    //               rrc_SalesLine."Sales Price (Price Base)" := lrc_SalesShipLine."Sales Price (Price Base)";
    //               rrc_SalesLine."Shop Sales Price" := lrc_SalesShipLine."Outlet Sales Price";

    //               rrc_SalesLine.Description := lrc_SalesShipLine.Description;
    //               rrc_SalesLine."Description 2" := lrc_SalesShipLine."Description 2";

    //               rrc_SalesLine."Item Category Code" := lrc_SalesShipLine."Item Category Code";
    //               rrc_SalesLine."Product Group Code" := lrc_SalesShipLine."Product Group Code";

    //               rrc_SalesLine."Country of Origin Code" := lrc_SalesShipLine."Country of Origin Code";
    //               rrc_SalesLine."Variety Code" := lrc_SalesShipLine."Variety Code";
    //               rrc_SalesLine."Trademark Code" := lrc_SalesShipLine."Trademark Code";
    //               rrc_SalesLine."Caliber Code" := lrc_SalesShipLine."Caliber Code";
    //               rrc_SalesLine."Vendor Caliber Code" := lrc_SalesShipLine."Vendor Caliber Code";
    //               rrc_SalesLine."Item Attribute 3" := lrc_SalesShipLine."Quality Code";
    //               rrc_SalesLine."Item Attribute 2" := lrc_SalesShipLine."Color Code";
    //               rrc_SalesLine."Grade of Goods Code" := lrc_SalesShipLine."Grade of Goods Code";
    //               rrc_SalesLine."Item Attribute 7" := lrc_SalesShipLine."Conservation Code";
    //               rrc_SalesLine."Item Attribute 4" := lrc_SalesShipLine."Packing Code";
    //               rrc_SalesLine."Coding Code" := lrc_SalesShipLine."Coding Code";
    //               rrc_SalesLine."Item Attribute 5" := lrc_SalesShipLine."Treatment Code";
    //               rrc_SalesLine."Item Attribute 6" := lrc_SalesShipLine."Proper Name Code";

    //               rrc_SalesLine."Master Batch No." := lrc_SalesShipLine."Master Batch No.";
    //               rrc_SalesLine."Batch No." := lrc_SalesShipLine."Batch No.";
    //               rrc_SalesLine."Batch Variant No." := lrc_SalesShipLine."Batch Variant No.";

    //               rrc_SalesLine."Gross Weight" := lrc_SalesShipLine."Gross Weight";
    //               rrc_SalesLine."Net Weight" := lrc_SalesShipLine."Gross Weight";

    //               rrc_SalesLine."Total Gross Weight" := rrc_SalesLine."Gross Weight" * rrc_SalesLine.Quantity;
    //               rrc_SalesLine."Total Net Weight" := rrc_SalesLine."Net Weight" * rrc_SalesLine.Quantity;

    //             END ELSE BEGIN
    //               lrc_ItemChargeAssignSales.VALIDATE("Qty. to Assign",rrc_SalesLine.Quantity);
    //               lrc_ItemChargeAssignSales.Modify();

    //               // Verkaufszeile aktualisieren
    //               rrc_SalesLine.Description := lrc_ItemChargeAssignSales.Description;
    //             END;

    //           END;

    //         END ELSE BEGIN
    //           rrc_SalesLine.ShowItemChargeAssgnt;
    //         END;
    //     end;

    //     procedure UpdateCrMemoChargeItem(vrc_SalesHeader: Record "36")
    //     var
    //         lcu_ItemChargeAssgntSales: Codeunit "5807";
    //         lrc_ItemChargeAssignSales: Record "5809";
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesShipLine: Record "111";
    //         Currency: Record "4";
    //         lfm_SalesShipLines: Form "5824";
    //         ldc_UnitCost: Decimal;
    //         ldc_Quantity: Decimal;
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Rekalkulation Zu-/Abschlagszeile in Gutschrift bei Referenz auf Lieferung
    //         // -----------------------------------------------------------------------------

    //         IF vrc_SalesHeader."Document Type" <> vrc_SalesHeader."Document Type"::"Credit Memo" THEN
    //           EXIT;

    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //         lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::"Charge (Item)");
    //         lrc_SalesLine.SETFILTER("No.",'<>%1','');
    //         IF lrc_SalesLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //           REPEAT

    //             lrc_SalesShipLine.Reset();
    //             lrc_SalesShipLine.GET(lrc_SalesLine."Reference Doc. No.",lrc_SalesLine."Reference Doc. Line No.");

    //             // Bestehende Menge merken
    //             ldc_Quantity := lrc_SalesLine.Quantity;

    //             lrc_SalesLine."Reference Item No." := lrc_SalesShipLine."No.";

    //             lrc_SalesLine."Location Code" := lrc_SalesShipLine."Location Code";
    //             lrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_SalesShipLine."Unit of Measure Code");
    //             lrc_SalesLine.VALIDATE(Quantity,ldc_Quantity);
    //             lrc_SalesLine.VALIDATE("Unit Price",lrc_SalesShipLine."Unit Price");

    //             lrc_SalesLine."Base Unit of Measure (BU)" := lrc_SalesShipLine."Base Unit of Measure (BU)";
    //             lrc_SalesLine."Collo Unit of Measure (PQ)" := lrc_SalesShipLine."Collo Unit of Measure (PQ)";
    //             lrc_SalesLine."Packing Unit of Measure (PU)" := lrc_SalesShipLine."Packing Unit of Measure (PU)";
    //             lrc_SalesLine."Content Unit of Measure (COU)" := lrc_SalesShipLine."Content Unit of Measure (COU)";
    //             lrc_SalesLine."Transport Unit of Measure (TU)" := lrc_SalesShipLine."Transport Unit of Measure (TU)";

    //             lrc_SalesLine."Qty. per Unit of Measure" := lrc_SalesShipLine."Qty. per Unit of Measure";
    //             lrc_SalesLine."Qty. (Unit) per Transp.(TU)" := lrc_SalesShipLine."Qty. (Unit) per Transp. Unit";
    //             lrc_SalesLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipLine."Qty. (PU) per Unit of Measure";
    //             lrc_SalesLine."Quantity (PU)" := lrc_SalesShipLine."Quantity (PU)";
    //             lrc_SalesLine."Qty. (Unit) per Transp.(TU)" := lrc_SalesShipLine."Qty. (Unit) per Transp. Unit";
    //             lrc_SalesLine."Quantity (TU)" := lrc_SalesShipLine."Quantity (TU)";
    //             lrc_SalesLine."Qty. (COU) per Pack. Unit (PU)" := lrc_SalesShipLine."Qty. (COU) per Pack. Unit (PU)";

    //             lrc_SalesLine."Market Unit Cost (Base) (LCY)" := lrc_SalesShipLine."Market Unit Cost (Base) (LCY)";

    //             lrc_SalesLine."Price Base (Sales Price)" := lrc_SalesShipLine."Price Base (Sales Price)";
    //             lrc_SalesLine."Sales Price (Price Base)" := lrc_SalesShipLine."Sales Price (Price Base)";
    //             lrc_SalesLine."Shop Sales Price" := lrc_SalesShipLine."Outlet Sales Price";

    //             lrc_SalesLine.Description := lrc_SalesShipLine.Description;
    //             lrc_SalesLine."Description 2" := lrc_SalesShipLine."Description 2";

    //             lrc_SalesLine."Country of Origin Code" := lrc_SalesShipLine."Country of Origin Code";
    //             lrc_SalesLine."Variety Code" := lrc_SalesShipLine."Variety Code";
    //             lrc_SalesLine."Trademark Code" := lrc_SalesShipLine."Trademark Code";
    //             lrc_SalesLine."Caliber Code" := lrc_SalesShipLine."Caliber Code";
    //             lrc_SalesLine."Vendor Caliber Code" := lrc_SalesShipLine."Vendor Caliber Code";
    //             lrc_SalesLine."Item Attribute 3" := lrc_SalesShipLine."Quality Code";
    //             lrc_SalesLine."Item Attribute 2" := lrc_SalesShipLine."Color Code";
    //             lrc_SalesLine."Grade of Goods Code" := lrc_SalesShipLine."Grade of Goods Code";
    //             lrc_SalesLine."Item Attribute 7" := lrc_SalesShipLine."Conservation Code";
    //             lrc_SalesLine."Item Attribute 4" := lrc_SalesShipLine."Packing Code";
    //             lrc_SalesLine."Coding Code" := lrc_SalesShipLine."Coding Code";
    //             lrc_SalesLine."Item Attribute 5" := lrc_SalesShipLine."Treatment Code";
    //             lrc_SalesLine."Item Attribute 6" := lrc_SalesShipLine."Proper Name Code";
    //             lrc_SalesLine.Modify();

    //             lrc_ItemChargeAssignSales.Reset();
    //             lrc_ItemChargeAssignSales.SETRANGE("Document Type",lrc_SalesLine."Document Type");
    //             lrc_ItemChargeAssignSales.SETRANGE("Document No.",lrc_SalesLine."Document No.");
    //             lrc_ItemChargeAssignSales.SETRANGE("Document Line No.",lrc_SalesLine."Line No.");
    //             IF lrc_ItemChargeAssignSales.FINDFIRST() THEN BEGIN
    //               lrc_ItemChargeAssignSales.VALIDATE("Qty. to Assign",lrc_SalesLine.Quantity);
    //               lrc_ItemChargeAssignSales.Modify();
    //             END;

    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CrMemoItem(var rrc_SalesLine: Record "37")
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesShipLine: Record "111";
    //         lfm_PostedSalesShipLines: Form "525";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Auswahl Lieferung und Erstellung Artikelzeile (Rücknahme)
    //         // -----------------------------------------------------------------------------

    //         IF rrc_SalesLine.Type <> rrc_SalesLine.Type::Item THEN
    //           ERROR('Es sind nur Artikelzeilen zulässig!');

    //         lrc_SalesHeader.GET(rrc_SalesLine."Document Type",rrc_SalesLine."Document No.");

    //         lrc_SalesShipLine.Reset();
    //         //lrc_SalesShipLine.FILTERGROUP(2);
    //         lrc_SalesShipLine.SETCURRENTKEY("Sell-to Customer No.","Posting Date",Type,"No.",Quantity);
    //         lrc_SalesShipLine.SETRANGE("Sell-to Customer No.",lrc_SalesHeader."Sell-to Customer No.");
    //         lrc_SalesShipLine.SETRANGE(Type,lrc_SalesShipLine.Type::Item);
    //         IF rrc_SalesLine."No." <> '' THEN
    //           lrc_SalesShipLine.SETRANGE("No.",rrc_SalesLine."No.");
    //         lrc_SalesShipLine.SETFILTER(Quantity,'<>%1',0);
    //         lrc_SalesShipLine.FILTERGROUP(0);

    //         lfm_PostedSalesShipLines.LOOKUPMODE := TRUE;
    //         lfm_PostedSalesShipLines.SETTABLEVIEW(lrc_SalesShipLine);
    //         IF lfm_PostedSalesShipLines.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_SalesShipLine.Reset();
    //         lfm_PostedSalesShipLines.GETRECORD(lrc_SalesShipLine);

    //         // Werte aus Lieferzeile setzen
    //         rrc_SalesLine.VALIDATE("No.",lrc_SalesShipLine."No.");
    //         rrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_SalesShipLine."Unit of Measure Code");
    //         rrc_SalesLine.VALIDATE(Quantity,lrc_SalesShipLine.Quantity);
    //         rrc_SalesLine.VALIDATE("Unit Price",lrc_SalesShipLine."Unit Price");


    //         rrc_SalesLine."Shop Sales Price" := lrc_SalesShipLine."Outlet Sales Price";
    //         rrc_SalesLine."Reference Doc. No." := lrc_SalesShipLine."Document No.";
    //         rrc_SalesLine."Reference Doc. Line No." := lrc_SalesShipLine."Line No.";
    //     end;

    //     procedure CrMemoZuAbMgeZuw(vrc_SalesLine: Record "37")
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur automatischen Zuweisung der Menge
    //         // -----------------------------------------------------------------------------

    //         IF vrc_SalesLine.Type <> vrc_SalesLine.Type::"Charge (Item)" THEN
    //           EXIT;
    //         IF vrc_SalesLine."Document Type" <> vrc_SalesLine."Document Type"::"Credit Memo" THEN
    //           EXIT;

    //         vrc_SalesLine.CALCFIELDS("Qty. Assigned");
    //         IF vrc_SalesLine.Quantity <> vrc_SalesLine."Qty. Assigned" THEN BEGIN



    //         END;
    //     end;

    //     procedure CrMemoShowZuAb(vrc_SalesLine: Record "37")
    //     var
    //         lrc_ItemChargeAssignSales: Record "5809";
    //         lfm_ItemChargeAssignSales: Form "5814";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         //
    //         // -----------------------------------------------------------------------------

    //         lfm_ItemChargeAssignSales.Initialize(vrc_SalesLine,0);
    //         lfm_ItemChargeAssignSales.RUNMODAL;
    //     end;

    //     procedure "-- FUNCTION IN SALES ORDER --"()
    //     begin
    //     end;

    //     procedure CalcSalesMarge(vrc_SalesLine: Record "37";var rdc_EinstandspreisZeile: Decimal;var rdc_ErtragZeile: Decimal;var rdc_SpanneZeile: Decimal)
    //     var
    //         lcu_PostingMgt: Codeunit "5110303";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_BatchSetup: Record "5110363";
    //         ldc_Umsatz: Decimal;
    //         ldc_Einstandsbetrag: Decimal;
    //         lco_BatchVariantFilter: Code[1024];
    //         lrc_BatchVariantDetail: Record "5110487";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // CalcSalesMarge: Funktion zur Berechnung der Marge im Verkauf
    //         // ---------------------------------------------------------------------------------
    //         // vrc_SalesLine
    //         // rdc_EinstandspreisZeile
    //         // rdc_ErtragZeile
    //         // rdc_SpanneZeile
    //         // ---------------------------------------------------------------------------------

    //         // Werte auf Null setzen
    //         rdc_EinstandspreisZeile := 0;
    //         rdc_ErtragZeile := 0;
    //         rdc_SpanneZeile := 0;


    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') THEN
    //           EXIT;

    //         ldc_Umsatz := ((vrc_SalesLine.Quantity * vrc_SalesLine."Unit Price") -
    //                        (vrc_SalesLine."Inv. Discount Amount" + vrc_SalesLine."Inv. Disc. not Relat. to Goods" +
    //                         vrc_SalesLine."Accruel Inv. Disc. (External)" + vrc_SalesLine."Freight Costs Amount (LCY)"));

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Market Unit Price activ" = TRUE THEN BEGIN
    //           rdc_EinstandspreisZeile := vrc_SalesLine."Market Unit Cost (Base) (LCY)" * vrc_SalesLine."Qty. per Unit of Measure";
    //           ldc_Einstandsbetrag := rdc_EinstandspreisZeile * vrc_SalesLine.Quantity;
    //         END ELSE BEGIN
    //           lrc_BatchSetup.GET();
    //           lco_BatchVariantFilter := '';
    //           IF vrc_SalesLine."Batch Var. Detail ID" <> 0 THEN BEGIN
    //              lrc_BatchVariantDetail.Reset();
    //              lrc_BatchVariantDetail.SETRANGE(lrc_BatchVariantDetail."Entry No.", vrc_SalesLine."Batch Var. Detail ID");
    //              IF lrc_BatchVariantDetail.FIND('-') THEN BEGIN
    //                 REPEAT
    //                    IF lrc_BatchVariantDetail.Quantity <> 0 THEN BEGIN
    //                       IF lrc_BatchVariantDetail."Batch Variant No." <> '' THEN BEGIN
    //                          IF lco_BatchVariantFilter = '' THEN BEGIN
    //                             lco_BatchVariantFilter := lrc_BatchVariantDetail."Batch Variant No.";
    //                          END ELSE BEGIN
    //                             lco_BatchVariantFilter := lco_BatchVariantFilter + '|' + lrc_BatchVariantDetail."Batch Variant No.";
    //                          END;
    //                       END;
    //                    END;
    //                 UNTIL lrc_BatchVariantDetail.NEXT() = 0;
    //              END;
    //           END;

    //           IF lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line" THEN BEGIN
    //              rdc_EinstandspreisZeile := lcu_PostingMgt.GetCostPriceBase(vrc_SalesLine."No.", vrc_SalesLine."Location Code",
    //                                                                         lco_BatchVariantFilter) * vrc_SalesLine.
    //         "Qty. per Unit of Measure";
    //           END ELSE BEGIN
    //              rdc_EinstandspreisZeile := lcu_PostingMgt.GetCostPriceBase(vrc_SalesLine."No.", vrc_SalesLine."Location Code",
    //                                                                         lco_BatchVariantFilter) * vrc_SalesLine.
    //         "Qty. per Unit of Measure";
    //           END;
    //           ldc_Einstandsbetrag := rdc_EinstandspreisZeile * vrc_SalesLine.Quantity;
    //         END;

    //         rdc_ErtragZeile := ldc_Umsatz - ldc_Einstandsbetrag;

    //         IF ldc_Umsatz <> 0 THEN
    //           rdc_SpanneZeile := (rdc_ErtragZeile / ldc_Umsatz * 100)
    //         ELSE
    //           rdc_SpanneZeile := 0;
    //     end;

    //     procedure CalcAllUnitListPrices(vco_ItemNo: Code[20];vco_CustPriceGroup: Code[10];vco_CustomerNo: Code[20];vdt_RefDatePrice: Date;var rco_ArrUnitOfMeasure: array [1000] of Code[10];var rdc_ArrUnitPrice: array [1000] of Decimal;var rdc_ArrQtyPer: array [1000] of Decimal;var rtx_ArrUniType: array [1000] of Text[30];vco_Vendor: Code[20];vco_AssortmentVersionNo: Code[20];vin_AssortmentVersionLineNo: Integer)
    //     var
    //         lrc_Item: Record Item;
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_SalesPrice: Record "7002";
    //         "lin_Zähler": Integer;
    //         "-- Agiles L ASO 001": Integer;
    //         lrc_CustomerPriceGroup: Record "6";
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // CalcAllUnitsPrices: Funktion zur Berechnung der möglichen Einheiten und Verkaufspreise gemäß Preisliste
    //         // ---------------------------------------------------------------------------------------------------------
    //         // vco_ItemNo
    //         // vco_CustPriceGroup
    //         // vdt_RefDatePrice
    //         // rco_ArrUnitOfMeasure
    //         // rdc_ArrUnitPrice
    //         // rdc_ArrQtyPer
    //         // rtx_ArrUniType
    //         // vco_ArrVendor
    //         // vco_ArrAssortmentVersionNo
    //         // vin_ArrAssortmentVersionLineNo
    //         // -------------------------------------------------------------------------------

    //         CLEAR(rco_ArrUnitOfMeasure);
    //         CLEAR(rdc_ArrUnitPrice);
    //         CLEAR(rtx_ArrUniType);
    //         CLEAR(rdc_ArrQtyPer);

    //         IF (vco_ItemNo = '') THEN
    //           EXIT;

    //         IF NOT lrc_Item.GET(vco_ItemNo) THEN
    //           EXIT;

    //         // Alle Einheiten laden
    //         lin_Zähler := 0;
    //         lrc_ItemUnitofMeasure.SETRANGE("Item No.",lrc_Item."No.");
    //         IF lrc_ItemUnitofMeasure.FIND('-') THEN
    //           REPEAT
    //             lin_Zähler := lin_Zähler + 1;
    //             rco_ArrUnitOfMeasure[lin_Zähler] := lrc_ItemUnitofMeasure.Code;
    //             rtx_ArrUniType[lin_Zähler] := FORMAT(lrc_ItemUnitofMeasure."Kind of Unit of Measure");
    //             rdc_ArrQtyPer[lin_Zähler] := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
    //           UNTIL lrc_ItemUnitofMeasure.NEXT() = 0;

    //         // Für alle Einheiten die Preise ermitteln
    //         lin_Zähler := 1;
    //         WHILE rco_ArrUnitOfMeasure[lin_Zähler] <> '' DO BEGIN

    //           // Debitor, Artikel, Einheitencode, Start- / Enddatum
    //           lrc_SalesPrice.Reset();
    //           lrc_SalesPrice.SETCURRENTKEY("Item No.","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code",
    //                                        "Unit of Measure Code","Vendor No.","Assort. Version No.","Assort. Version Line No.",
    //                                        "Batch Variant No.",
    //                                        "Minimum Quantity");
    //           lrc_SalesPrice.SETRANGE("Item No.",vco_ItemNo);
    //           lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::Customer);
    //           lrc_SalesPrice.SETRANGE("Sales Code",vco_CustomerNo);
    //           lrc_SalesPrice.SETFILTER("Starting Date",'<=%1',vdt_RefDatePrice);
    //           lrc_SalesPrice.SETRANGE("Unit of Measure Code",rco_ArrUnitOfMeasure[lin_Zähler]);
    //           lrc_SalesPrice.SETFILTER("Ending Date",'>=%1|%2',vdt_RefDatePrice,0D);
    //           IF lrc_SalesPrice.FIND('+') THEN BEGIN
    //             rdc_ArrUnitPrice[lin_Zähler] := lrc_SalesPrice."Unit Price";
    //           END ELSE BEGIN
    //             // Debitor, Artikel, Start- / Enddatum
    //             lrc_SalesPrice.Reset();
    //             lrc_SalesPrice.SETCURRENTKEY("Item No.","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code",
    //                                          "Unit of Measure Code","Vendor No.","Assort. Version No.","Assort. Version Line No.",
    //                                          "Batch Variant No.",
    //                                          "Minimum Quantity");
    //             lrc_SalesPrice.SETRANGE("Item No.",vco_ItemNo);
    //             lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::Customer);
    //             lrc_SalesPrice.SETRANGE("Sales Code",vco_CustomerNo);
    //             lrc_SalesPrice.SETFILTER("Starting Date",'<=%1',vdt_RefDatePrice);
    //             lrc_SalesPrice.SETFILTER("Ending Date",'>=%1|%2',vdt_RefDatePrice,0D);
    //             IF lrc_SalesPrice.FIND('+') THEN BEGIN
    //               IF lrc_ItemUnitofMeasure.GET(lrc_SalesPrice."Item No.",lrc_SalesPrice."Unit of Measure Code") THEN BEGIN
    //                 rdc_ArrUnitPrice[lin_Zähler] := lrc_SalesPrice."Unit Price" /
    //                                                 lrc_ItemUnitofMeasure."Qty. per Unit of Measure" *
    //                                                 rdc_ArrQtyPer[lin_Zähler];
    //               END;
    //             END ELSE BEGIN
    //               // Debitorenpreisgruppe, Artikel, Einheitencode, Start- / Enddatum
    //               lrc_SalesPrice.Reset();
    //               lrc_SalesPrice.SETCURRENTKEY("Item No.","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code",
    //                                            "Unit of Measure Code","Vendor No.","Assort. Version No.","Assort. Version Line No.",
    //                                            "Batch Variant No.",
    //                                            "Minimum Quantity");
    //               lrc_SalesPrice.SETRANGE("Item No.",vco_ItemNo);
    //               lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::"Customer Price Group");
    //               lrc_SalesPrice.SETRANGE("Sales Code",vco_CustPriceGroup);
    //               lrc_SalesPrice.SETFILTER("Starting Date",'<=%1',vdt_RefDatePrice);
    //               lrc_SalesPrice.SETFILTER("Ending Date",'>=%1|%2',vdt_RefDatePrice,0D);
    //               lrc_SalesPrice.SETRANGE("Unit of Measure Code",rco_ArrUnitOfMeasure[lin_Zähler]);
    //               lrc_SalesPrice.SETRANGE("Vendor No.", '');
    //               lrc_SalesPrice.SETRANGE("Assort. Version No.", '');
    //               lrc_SalesPrice.SETRANGE("Assort. Version Line No.", 0);
    //               IF vco_CustPriceGroup <> '' THEN BEGIN
    //                 IF lrc_CustomerPriceGroup.GET(vco_CustPriceGroup) THEN BEGIN
    //                   CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                     lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                     "plus Vendor No":
    //                     BEGIN
    //                               lrc_SalesPrice.SETFILTER("Vendor No.",'%1|%2', vco_Vendor, '');
    //                     END;
    //                     lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                       "plus Assortment Version and Line No":
    //                     BEGIN
    //                       lrc_SalesPrice.SETFILTER("Assort. Version No.", '%1|%2', vco_AssortmentVersionNo, '');
    //                       lrc_SalesPrice.SETFILTER("Assort. Version Line No.", '%1|%2', vin_AssortmentVersionLineNo, 0);
    //                     END;
    //                   END;
    //                  END;
    //               END;
    //               IF lrc_SalesPrice.FIND('+') THEN BEGIN
    //                 rdc_ArrUnitPrice[lin_Zähler] := lrc_SalesPrice."Unit Price";
    //               END ELSE BEGIN
    //                 // Debitorenpreisgruppe, Artikel, Start- / Enddatum
    //                 lrc_SalesPrice.Reset();
    //                 lrc_SalesPrice.SETCURRENTKEY("Item No.","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code",
    //                                              "Unit of Measure Code","Vendor No.","Assort. Version No.","Assort. Version Line No.",
    //                                              "Batch Variant No.",
    //                                              "Minimum Quantity");
    //                 lrc_SalesPrice.SETRANGE("Item No.",vco_ItemNo);
    //                 lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::"Customer Price Group");
    //                 lrc_SalesPrice.SETRANGE("Sales Code",vco_CustPriceGroup);
    //                 //lrc_SalesPrice.SETRANGE("Unit of Measure Code",gco_ArrUnitOfMeasure[lin_Zähler]);
    //                 lrc_SalesPrice.SETFILTER("Starting Date",'<=%1',vdt_RefDatePrice);
    //                 lrc_SalesPrice.SETFILTER("Ending Date",'>=%1|%2',vdt_RefDatePrice,0D);
    //                 lrc_SalesPrice.SETRANGE("Vendor No.", '');
    //                 lrc_SalesPrice.SETRANGE("Assort. Version No.", '');
    //                 lrc_SalesPrice.SETRANGE("Assort. Version Line No.", 0);
    //                 IF vco_CustPriceGroup <> '' THEN BEGIN
    //                   IF lrc_CustomerPriceGroup.GET(vco_CustPriceGroup) THEN BEGIN
    //                       CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                            lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                              "plus Vendor No":
    //                              BEGIN
    //                                 lrc_SalesPrice.SETFILTER("Vendor No.",'%1|%2', vco_Vendor, '');
    //                              END;
    //                            lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                              "plus Assortment Version and Line No":
    //                              BEGIN
    //                                 lrc_SalesPrice.SETFILTER("Assort. Version No.", '%1|%2', vco_AssortmentVersionNo, '');
    //                                 lrc_SalesPrice.SETFILTER("Assort. Version Line No.", '%1|%2',
    //                                                                              vin_AssortmentVersionLineNo, 0);
    //                              END;
    //                       END;
    //                    END;
    //                 END;
    //                 IF lrc_SalesPrice.FIND('+') THEN BEGIN
    //                   IF lrc_ItemUnitofMeasure.GET(lrc_SalesPrice."Item No.",lrc_SalesPrice."Unit of Measure Code") THEN BEGIN
    //                     rdc_ArrUnitPrice[lin_Zähler] := lrc_SalesPrice."Unit Price" /
    //                                                     lrc_ItemUnitofMeasure."Qty. per Unit of Measure" *
    //                                                     rdc_ArrQtyPer[lin_Zähler];
    //                   END;

    //                 END ELSE BEGIN
    //                   // Alle Debitoren, Artikel, Einheitencode, Start- / Enddatum
    //                   lrc_SalesPrice.Reset();
    //                   lrc_SalesPrice.SETRANGE("Item No.",vco_ItemNo);
    //                   lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::"All Customers");
    //                   lrc_SalesPrice.SETRANGE("Unit of Measure Code",rco_ArrUnitOfMeasure[lin_Zähler]);
    //                   lrc_SalesPrice.SETFILTER("Starting Date",'<=%1',vdt_RefDatePrice);
    //                   lrc_SalesPrice.SETFILTER("Ending Date",'>=%1|%2',vdt_RefDatePrice,0D);
    //                   IF lrc_SalesPrice.FIND('+') THEN BEGIN
    //                     rdc_ArrUnitPrice[lin_Zähler] := lrc_SalesPrice."Unit Price";
    //                   END ELSE BEGIN
    //                     // Alle Debitoren, Artikel, Start- / Enddatum
    //                     lrc_SalesPrice.Reset();
    //                     lrc_SalesPrice.SETRANGE("Item No.",vco_ItemNo);
    //                     lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::"All Customers");
    //                     //lrc_SalesPrice.SETRANGE("Unit of Measure Code",gco_ArrUnitOfMeasure[lin_Zähler]);
    //                     lrc_SalesPrice.SETFILTER("Starting Date",'<=%1',vdt_RefDatePrice);
    //                     lrc_SalesPrice.SETFILTER("Ending Date",'>=%1|%2',vdt_RefDatePrice,0D);
    //                     IF lrc_SalesPrice.FIND('+') THEN BEGIN
    //                       IF lrc_ItemUnitofMeasure.GET(lrc_SalesPrice."Item No.",lrc_SalesPrice."Unit of Measure Code") THEN BEGIN
    //                         rdc_ArrUnitPrice[lin_Zähler] := lrc_SalesPrice."Unit Price" /
    //                                                         lrc_ItemUnitofMeasure."Qty. per Unit of Measure" *
    //                                                         rdc_ArrQtyPer[lin_Zähler];
    //                       END;
    //                     END;
    //                   END;
    //                 END;
    //               END;
    //             END;
    //           END;
    //           // SAL 003 00000000.e

    //           lin_Zähler := lin_Zähler + 1;
    //         END;
    //     end;

    //     procedure CalcAllUnitSalesPrices(vco_UnitOfMeasureCode: Code[10];vdc_UnitPrice: Decimal;vdc_QtyPer: Decimal;var rco_ArrUnitOfMeasure: array [1000] of Code[10];var rdc_ArrUnitSalesPrice: array [1000] of Decimal;var rdc_ArrQtyPer: array [1000] of Decimal;var rtx_ArrUniType: array [1000] of Text[30])
    //     var
    //         "lin_Zähler": Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // CalcAllUnitsPrices: Funktion zur Berechnung der möglichen Einheiten und Verkaufspreise gemäß Verkaufspreis
    //         // ---------------------------------------------------------------------------------------------------------
    //         // vco_UnitOfMeasureCode
    //         // vdc_UnitPrice
    //         // vdc_QtyPer
    //         // rco_ArrUnitOfMeasure
    //         // rdc_ArrUnitSalesPrice
    //         // rdc_ArrQtyPer
    //         // rtx_ArrUniType
    //         // -------------------------------------------------------------------------------

    //         CLEAR(rdc_ArrUnitSalesPrice);

    //         // Für alle Einheiten die Preise ermitteln
    //         lin_Zähler := 1;
    //         WHILE rco_ArrUnitOfMeasure[lin_Zähler] <> '' DO BEGIN
    //           // Kontrolle ob Einheit der VErkaufseinheit entspricht
    //           IF rco_ArrUnitOfMeasure[lin_Zähler] = vco_UnitOfMeasureCode THEN BEGIN
    //             rdc_ArrUnitSalesPrice[lin_Zähler] := vdc_UnitPrice;
    //           END ELSE BEGIN
    //             IF vdc_QtyPer <> 0 THEN
    //               rdc_ArrUnitSalesPrice[lin_Zähler] := vdc_UnitPrice / vdc_QtyPer *
    //                                                    rdc_ArrQtyPer[lin_Zähler]
    //             ELSE
    //               rdc_ArrUnitSalesPrice[lin_Zähler] := 0;
    //           END;
    //           lin_Zähler := lin_Zähler + 1;
    //         END;
    //     end;

    //     procedure CalcLastInvoiceItemLedger(vrc_SalesLine: Record "37";var rdt_InvDateLast: Date;var rdc_InvQtyLast: Decimal;var rco_InvUnitLast: Code[10];var rdc_InvPriceLast: Decimal;var rdc_InvAmountLast: Decimal;var rdc_InvSpanneZeile: Decimal;var rdc_InvErtragZeile: Decimal)
    //     var
    //         lrc_ItemLedgerEntry: Record "32";
    //     begin
    //         // -------------------------------------------------------------------------------
    //         // CalcLastInv: Funktion zur Ermittlung des letzten Rechnungswertes
    //         // -------------------------------------------------------------------------------
    //         // vrc_SalesLine
    //         // rdt_InvDateLast
    //         // rdc_InvQtyLast
    //         // rco_InvUnitLast
    //         // rdc_InvPriceLast
    //         // rdc_InvAmountLast
    //         // rdc_InvSpanneZeile
    //         // rdc_InvErtragZeile
    //         // -------------------------------------------------------------------------------

    //         rdt_InvDateLast := 0D;
    //         rdc_InvQtyLast := 0;
    //         rco_InvUnitLast := '';
    //         rdc_InvAmountLast := 0;
    //         rdc_InvPriceLast := 0;
    //         rdc_InvSpanneZeile := 0;
    //         rdc_InvErtragZeile := 0;

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') THEN
    //           EXIT;

    //         lrc_ItemLedgerEntry.SETCURRENTKEY("Source Type","Source No.","Item No.","Variant Code","Posting Date");
    //         lrc_ItemLedgerEntry.SETRANGE("Source Type",lrc_ItemLedgerEntry."Source Type"::Customer);
    //         lrc_ItemLedgerEntry.SETRANGE("Source No.",vrc_SalesLine."Sell-to Customer No.");
    //         lrc_ItemLedgerEntry.SETRANGE("Item No.",vrc_SalesLine."No.");
    //         lrc_ItemLedgerEntry.SETRANGE("Variant Code",vrc_SalesLine."Variant Code");
    //         lrc_ItemLedgerEntry.SETRANGE("Posting Date",(TODAY-90),TODAY);
    //         lrc_ItemLedgerEntry.SETRANGE("Entry Type",lrc_ItemLedgerEntry."Entry Type"::Sale);
    //         lrc_ItemLedgerEntry.SETRANGE(Positive,FALSE);
    //         lrc_ItemLedgerEntry.SETFILTER("Invoiced Quantity",'<>%1',0);
    //         IF lrc_ItemLedgerEntry.FIND('+') THEN BEGIN

    //           rdt_InvDateLast := lrc_ItemLedgerEntry."Posting Date";
    //           rdc_InvQtyLast := (lrc_ItemLedgerEntry.Quantity / lrc_ItemLedgerEntry."Qty. per Unit of Measure") * -1;
    //           rco_InvUnitLast := lrc_ItemLedgerEntry."Unit of Measure Code";

    //           lrc_ItemLedgerEntry.CALCFIELDS("Sales Amount (Actual)","Sales Amount (Expected)","Inv. Disc. (Actual)");
    //           rdc_InvAmountLast := (lrc_ItemLedgerEntry."Sales Amount (Actual)" + lrc_ItemLedgerEntry."Sales Amount (Expected)") -
    //                                 lrc_ItemLedgerEntry."Inv. Disc. (Actual)";

    //           IF vrc_SalesLine."Price Unit of Measure" = vrc_SalesLine."Base Unit of Measure (BU)" THEN
    //             rdc_InvPriceLast := rdc_InvAmountLast / lrc_ItemLedgerEntry.Quantity
    //           ELSE
    //             rdc_InvPriceLast := rdc_InvAmountLast / rdc_InvQtyLast;

    //           rdc_InvErtragZeile := ((lrc_ItemLedgerEntry."Sales Amount (Actual)" + lrc_ItemLedgerEntry."Sales Amount (Expected)") -
    //                                 (lrc_ItemLedgerEntry."Market Purch. Price" * lrc_ItemLedgerEntry."Invoiced Quantity"));
    //           IF lrc_ItemLedgerEntry."Sales Amount (Actual)" <> 0 THEN
    //             rdc_InvSpanneZeile := rdc_InvErtragZeile * 100 / lrc_ItemLedgerEntry."Sales Amount (Actual)";

    //         END;
    //     end;

    //     procedure CalcLastInvoicePostInvLine(vrc_SalesLine: Record "37";var rdt_InvDateLast: Date;var rdc_InvQtyLast: Decimal;var rco_InvUnitLast: Code[10];var rdc_InvPriceLast: Decimal;var rdc_InvAmountLast: Decimal;var rdc_InvSpanneZeile: Decimal;var rdc_InvErtragZeile: Decimal)
    //     var
    //         lrc_SalesInvLine: Record "113";
    //     begin
    //         // -----------------------------------------------------------------------------------------------
    //         // CalcLastInv: Funktion zur Ermittlung des letzten Rechnungswertes auf Basis der Rechnungszeilen
    //         // -----------------------------------------------------------------------------------------------
    //         // vrc_SalesLine
    //         // rdt_InvDateLast
    //         // rdc_InvQtyLast
    //         // rco_InvUnitLast
    //         // rdc_InvPriceLast
    //         // rdc_InvAmountLast
    //         // rdc_InvSpanneZeile
    //         // rdc_InvErtragZeile
    //         // -------------------------------------------------------------------------------

    //         rdt_InvDateLast := 0D;
    //         rdc_InvQtyLast := 0;
    //         rco_InvUnitLast := '';
    //         rdc_InvAmountLast := 0;
    //         rdc_InvPriceLast := 0;
    //         rdc_InvSpanneZeile := 0;
    //         rdc_InvErtragZeile := 0;

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') THEN
    //           EXIT;

    //         lrc_SalesInvLine.SETCURRENTKEY("Sell-to Customer No.",Type,"No.","Posting Date");
    //         lrc_SalesInvLine.ASCENDING := FALSE;
    //         lrc_SalesInvLine.SETRANGE("Sell-to Customer No.",vrc_SalesLine."Sell-to Customer No.");
    //         lrc_SalesInvLine.SETRANGE(Type,lrc_SalesInvLine.Type::Item);
    //         lrc_SalesInvLine.SETRANGE("No.",vrc_SalesLine."No.");
    //         IF lrc_SalesInvLine.FIND('-') THEN BEGIN

    //           rdt_InvDateLast := lrc_SalesInvLine."Posting Date";
    //           rdc_InvQtyLast :=  lrc_SalesInvLine.Quantity;
    //           rco_InvUnitLast := lrc_SalesInvLine."Unit of Measure Code";

    //           rdc_InvAmountLast := lrc_SalesInvLine.Amount;
    //           rdc_InvPriceLast := lrc_SalesInvLine."Sales Price (Price Base)";

    //         /*
    //           rdc_InvErtragZeile := ((lrc_ItemLedgerEntry."Sales Amount (Actual)" + lrc_ItemLedgerEntry."Sales Amount (Expected)") -
    //                                 (lrc_ItemLedgerEntry."Market Purch. Price" * lrc_ItemLedgerEntry."Invoiced Quantity"));
    //           IF lrc_ItemLedgerEntry."Sales Amount (Actual)" <> 0 THEN
    //             rdc_InvSpanneZeile := rdc_InvErtragZeile * 100 / lrc_ItemLedgerEntry."Sales Amount (Actual)";

    //         */
    //         END;

    //     end;

    //     procedure CallSelectedPurchaseOrder(rrc_SalesLine: Record "37")
    //     var
    //         lrc_PurchaseHeader: Record "38";
    //         lcu_PurchaseMgt: Codeunit "5110323";
    //     begin
    //         rrc_SalesLine.TESTFIELD("Purchase Order No.");
    //         rrc_SalesLine.TESTFIELD("Purch. Order Line No.");

    //         lrc_PurchaseHeader.Reset();
    //         lrc_PurchaseHeader.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type"::Order);
    //         lrc_PurchaseHeader.SETRANGE("No.", rrc_SalesLine."Purchase Order No.");
    //         IF lrc_PurchaseHeader.FIND('-') THEN BEGIN
    //           lcu_PurchaseMgt.PurchShowOrder(lrc_PurchaseHeader."Document Type", lrc_PurchaseHeader."No.",FALSE);
    //         END;
    //     end;

    //     procedure ChangeItemNo(var rrc_PurchLine: Record "39"): Boolean
    //     var
    //         lrc_Item: Record Item;
    //         lfm_ItemList: Form "31";
    //     begin
    //         // ----------------------------------------------------------------------
    //         // Funktion zum Wechseln der Artikelnummer
    //         // ----------------------------------------------------------------------

    //         IF rrc_PurchLine."Document Type" <> rrc_PurchLine."Document Type"::Order THEN
    //           EXIT(FALSE);
    //         IF rrc_PurchLine.Type <> rrc_PurchLine.Type::Item THEN
    //           EXIT(FALSE);
    //         IF rrc_PurchLine."No." = '' THEN
    //           EXIT(FALSE);
    //         IF rrc_PurchLine.Quantity <> 0 THEN
    //           EXIT(FALSE);
    //         IF rrc_PurchLine."Batch Variant No." = '' THEN
    //           EXIT(FALSE);

    //         lrc_Item.FILTERGROUP(2);
    //         lrc_Item.SETRANGE("Item Typ",lrc_Item."Item Typ"::"Trade Item");
    //         lrc_Item.SETRANGE("Batch Item",TRUE);
    //         lrc_Item.FILTERGROUP(0);

    //         lfm_ItemList.LOOKUPMODE := TRUE;
    //         IF lfm_ItemList.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT(FALSE);

    //         lrc_Item.Reset();
    //         lfm_ItemList.GETRECORD(lrc_Item);

    //         rrc_PurchLine."No." := lrc_Item."No.";
    //         rrc_PurchLine.Description := lrc_Item.Description;
    //         rrc_PurchLine."Description 2" := lrc_Item."Description 2";
    //         rrc_PurchLine."Country of Origin Code" := lrc_Item."Country of Origin Code (Fruit)";
    //         rrc_PurchLine."Variety Code" := lrc_Item."Variety Code";
    //         rrc_PurchLine."Trademark Code" := lrc_Item."Trademark Code";
    //         rrc_PurchLine."Caliber Code" := lrc_Item."Caliber Code";
    //         rrc_PurchLine."Item Attribute 3" := lrc_Item."Item Attribute 3";
    //         rrc_PurchLine."Item Attribute 2" := lrc_Item."Item Attribute 2";
    //         rrc_PurchLine."Grade of Goods Code" := lrc_Item."Grade of Goods Code";
    //         rrc_PurchLine."Item Attribute 7" := lrc_Item."Item Attribute 7";
    //         rrc_PurchLine."Item Attribute 4" := lrc_Item."Item Attribute 4";
    //         rrc_PurchLine."Coding Code" := lrc_Item."Coding Code";
    //         rrc_PurchLine."Item Attribute 5" := lrc_Item."Item Attribute 5";
    //         rrc_PurchLine."Item Attribute 6" := lrc_Item."Item Attribute 6";


    //         //rrc_PurchLine.VALIDATE("Item Category Code",lrc_Item."Item Category Code");
    //         //rrc_PurchLine.VALIDATE("Product Group Code",lrc_Item."Product Group Code");
    //         rrc_PurchLine.VALIDATE("Unit of Measure Code",lrc_Item."Base Unit of Measure");
    //         rrc_PurchLine."Variety Code" := lrc_Item."Variety Code";



    //         EXIT(TRUE);
    //     end;

    //     procedure UpdateCustSalesPrice(vrc_SalesLine: Record "37")
    //     var
    //         lrc_SalesPrice: Record "7002";
    //         lrc_ProductGroup: Record "5723";
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Aktualisierung Debitor Verkaufspreis
    //         // ---------------------------------------------------------------------------------------

    //         IF vrc_SalesLine.Type <> vrc_SalesLine.Type::Item THEN
    //           EXIT;
    //         IF vrc_SalesLine."No." = '' THEN
    //           EXIT;
    //         IF vrc_SalesLine."Sales Price (Price Base)" <= 0 THEN
    //           EXIT;
    //         IF vrc_SalesLine."Price Unit of Measure" = '' THEN
    //           EXIT;
    //         IF vrc_SalesLine."Sell-to Customer No." = '' THEN
    //           EXIT;
    //         IF vrc_SalesLine."Document Type" <> vrc_SalesLine."Document Type"::Order THEN
    //           EXIT;

    //         // Rückschreiben nur für bestimmte Produktgruppen
    //         lrc_ProductGroup.SETRANGE(Code,vrc_SalesLine."Product Group Code");
    //         IF lrc_ProductGroup.FIND('-') THEN BEGIN
    //           IF lrc_ProductGroup."Save Cust. Sales Price" = FALSE THEN
    //             EXIT;
    //         END ELSE
    //           EXIT;

    //         lrc_SalesPrice.Reset();
    //         lrc_SalesPrice.SETRANGE("Item No.",vrc_SalesLine."No.");
    //         lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::Customer);
    //         lrc_SalesPrice.SETRANGE("Sales Code",vrc_SalesLine."Sell-to Customer No.");
    //         lrc_SalesPrice.SETRANGE("Minimum Quantity",0);
    //         lrc_SalesPrice.SETRANGE("Starting Date",TODAY);
    //         lrc_SalesPrice.SETRANGE("Unit of Measure Code",vrc_SalesLine."Price Unit of Measure");
    //         lrc_SalesPrice.SETFILTER("Ending Date",'%1|%2',0D,31129999D);
    //         IF NOT lrc_SalesPrice.FIND('+') THEN BEGIN

    //           lrc_SalesPrice.Reset();
    //           lrc_SalesPrice.INIT();
    //           lrc_SalesPrice."Item No." := vrc_SalesLine."No.";
    //           lrc_SalesPrice."Sales Type" := lrc_SalesPrice."Sales Type"::Customer;
    //           lrc_SalesPrice."Sales Code" := vrc_SalesLine."Sell-to Customer No.";
    //           lrc_SalesPrice."Minimum Quantity" := 0;
    //           lrc_SalesPrice."Starting Date" := TODAY;
    //           lrc_SalesPrice."Unit of Measure Code" := vrc_SalesLine."Price Unit of Measure";
    //           lrc_SalesPrice."Unit Price" := vrc_SalesLine."Sales Price (Price Base)";
    //           lrc_SalesPrice."Ending Date" := 31129999D;
    //           lrc_SalesPrice.insert();

    //           // Kontrolle ob es alte Preise gibt, deren Enddatum gesetzt werden muss
    //           lrc_SalesPrice.Reset();
    //           lrc_SalesPrice.SETRANGE("Item No.",vrc_SalesLine."No.");
    //           lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::Customer);
    //           lrc_SalesPrice.SETRANGE("Sales Code",vrc_SalesLine."Sell-to Customer No.");
    //           lrc_SalesPrice.SETRANGE("Minimum Quantity",0);
    //           lrc_SalesPrice.SETFILTER("Starting Date",'<%1',TODAY);
    //           lrc_SalesPrice.SETRANGE("Unit of Measure Code",vrc_SalesLine."Price Unit of Measure");
    //           lrc_SalesPrice.SETFILTER("Ending Date",'%1|%2',0D,31129999D);
    //           IF lrc_SalesPrice.FIND('-') THEN
    //             REPEAT
    //               lrc_SalesPrice."Ending Date" := TODAY - 1;
    //               lrc_SalesPrice.Modify();
    //             UNTIL lrc_SalesPrice.NEXT() = 0;

    //         END ELSE BEGIN
    //           lrc_SalesPrice."Unit Price" := vrc_SalesLine."Sales Price (Price Base)";
    //           lrc_SalesPrice.Modify();
    //         END;
    //     end;

    //     procedure GetWertgutschrift(vco_SalesOrderNo: Code[20])
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesShipLine: Record "111";
    //         lrc_ItemChargeAssignmentSales: Record "5809";
    //         lfm_PostedSalesShipLines: Form "525";
    //         lin_LineNo: Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Erstellung einer Wertgutschriftszeile im Verkauf
    //         // ---------------------------------------------------------------------------------------

    //         lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order,vco_SalesOrderNo);
    //         lrc_SalesHeader.TESTFIELD("Sell-to Customer No.");

    //         lrc_SalesShipLine.Reset();
    //         lrc_SalesShipLine.SETRANGE("Sell-to Customer No.",lrc_SalesHeader."Sell-to Customer No.");
    //         lfm_PostedSalesShipLines.SETTABLEVIEW(lrc_SalesShipLine);
    //         lfm_PostedSalesShipLines.LOOKUPMODE := TRUE;

    //         IF lfm_PostedSalesShipLines.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_SalesShipLine.Reset();
    //         lfm_PostedSalesShipLines.GETRECORD(lrc_SalesShipLine);


    //         // Verkaufszeile erstellen
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         IF lrc_SalesLine.FIND('+') THEN
    //           lin_LineNo := lrc_SalesLine."Line No." + 10000
    //         ELSE
    //           lin_LineNo := 10000;

    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.VALIDATE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
    //         lrc_SalesLine."Line No." := lin_LineNo;
    //         lrc_SalesLine.INSERT(TRUE);
    //         lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::"Charge (Item)");
    //         lrc_SalesLine.VALIDATE("No.",'VK-GUT');
    //         lrc_SalesLine.MODIFY(TRUE);


    //         // Wertgutschriftszeile erstellen
    //         lrc_ItemChargeAssignmentSales."Document Type" := lrc_SalesHeader."Document Type";
    //         lrc_ItemChargeAssignmentSales."Document No." := lrc_SalesHeader."No.";
    //         lrc_ItemChargeAssignmentSales."Document Line No." := lrc_SalesLine."Line No.";

    //         lrc_ItemChargeAssignmentSales."Line No." := 10000;

    //         lrc_ItemChargeAssignmentSales."Item Charge No." := 'VK-GUT';
    //         lrc_ItemChargeAssignmentSales."Item No." := lrc_SalesShipLine."No.";
    //         lrc_ItemChargeAssignmentSales.Description := lrc_SalesShipLine.Description;
    //         lrc_ItemChargeAssignmentSales."Qty. to Assign" := 1;
    //         lrc_ItemChargeAssignmentSales."Qty. Assigned" := 0;
    //         lrc_ItemChargeAssignmentSales."Unit Cost" := 0;
    //         lrc_ItemChargeAssignmentSales."Amount to Assign" := 0;

    //         lrc_ItemChargeAssignmentSales."Applies-to Doc. Type" := lrc_ItemChargeAssignmentSales."Applies-to Doc. Type"::Shipment;
    //         lrc_ItemChargeAssignmentSales."Applies-to Doc. No." := lrc_SalesShipLine."Document No.";
    //         lrc_ItemChargeAssignmentSales."Applies-to Doc. Line No." := lrc_SalesShipLine."Line No.";
    //         lrc_ItemChargeAssignmentSales."Applies-to Doc. Line Amount" := 0;

    //         lrc_ItemChargeAssignmentSales."Master Batch No." := lrc_SalesShipLine."Master Batch No.";
    //         lrc_ItemChargeAssignmentSales."Batch No." := lrc_SalesShipLine."Batch No.";
    //         lrc_ItemChargeAssignmentSales."Batch Variant No." := lrc_SalesShipLine."Batch Variant No.";

    //         lrc_ItemChargeAssignmentSales.insert();
    //     end;

    //     procedure SortSalesLines(vrc_SalesHeader: Record "36")
    //     var
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesLineTEMP: Record "37" temporary;
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Sortieren der Verkaufszeilen
    //         // -----------------------------------------------------------------------------

    //         //
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_SalesLineTEMP := lrc_SalesLine;
    //             lrc_SalesLineTEMP.insert();

    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END ELSE
    //           ERROR('Es sind keine Zeilen zum Sortieren vorhanden!');
    //     end;

    //     procedure TestWertgutschrift(vco_SalesOrderNo: Code[20];vin_SalesLineNo: Integer)
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesShipLine: Record "111";
    //         lrc_ItemChargeAssignmentSales: Record "5809";
    //         lfm_PostedSalesShipLines: Form "525";
    //         lin_LineNo: Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Erstellung einer Wertgutschriftszeile im Verkauf
    //         // TEST TEST TEST TEST TEST TEST
    //         // ---------------------------------------------------------------------------------------

    //         lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order,vco_SalesOrderNo);
    //         lrc_SalesHeader.TESTFIELD("Sell-to Customer No.");

    //         lrc_SalesLine.GET(lrc_SalesHeader."Document Type",lrc_SalesHeader."No.",vin_SalesLineNo);

    //         lrc_SalesShipLine.Reset();
    //         lrc_SalesShipLine.SETCURRENTKEY("Sell-to Customer No.","Posting Date",Type,"No.",Quantity);
    //         lrc_SalesShipLine.SETRANGE("Sell-to Customer No.",lrc_SalesHeader."Sell-to Customer No.");
    //         lrc_SalesShipLine.SETRANGE(Type,lrc_SalesShipLine.Type::Item);
    //         lrc_SalesShipLine.SETRANGE("No.",lrc_SalesLine."No.");
    //         lfm_PostedSalesShipLines.SETTABLEVIEW(lrc_SalesShipLine);
    //         lfm_PostedSalesShipLines.LOOKUPMODE := TRUE;
    //         IF lfm_PostedSalesShipLines.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_SalesShipLine.Reset();
    //         lfm_PostedSalesShipLines.GETRECORD(lrc_SalesShipLine);

    //         // --------------------------------------------------------------------------------
    //         // Verkaufszeile anpassen
    //         // --------------------------------------------------------------------------------
    //         lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::"Charge (Item)");
    //         lrc_SalesLine.VALIDATE("No.",'TEST');

    //         lrc_SalesLine."Reference Doc. No." := lrc_SalesShipLine."Document No.";
    //         lrc_SalesLine."Reference Doc. Line No." := lrc_SalesShipLine."Line No.";
    //         lrc_SalesLine."Reference Item No." := lrc_SalesShipLine."No.";

    //         lrc_SalesLine."Base Unit of Measure (BU)" := lrc_SalesShipLine."Base Unit of Measure (BU)";
    //         lrc_SalesLine."Price Unit of Measure" := lrc_SalesShipLine."Price Unit of Measure";

    //         lrc_SalesLine."Country of Origin Code" := lrc_SalesShipLine."Country of Origin Code";
    //         lrc_SalesLine."Variety Code" := lrc_SalesShipLine."Variety Code";
    //         lrc_SalesLine."Grade of Goods Code" := lrc_SalesShipLine."Grade of Goods Code";

    //         lrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_SalesShipLine."Unit of Measure Code");
    //         lrc_SalesLine."Qty. per Unit of Measure" := lrc_SalesShipLine."Qty. per Unit of Measure";
    //         lrc_SalesLine.VALIDATE(Quantity,(lrc_SalesShipLine.Quantity * -1));

    //         lrc_SalesLine.VALIDATE("Price Base (Sales Price)",lrc_SalesShipLine."Price Base (Sales Price)");
    //         lrc_SalesLine.VALIDATE("Sales Price (Price Base)",lrc_SalesShipLine."Sales Price (Price Base)");
    //         lrc_SalesLine.Description := lrc_SalesShipLine.Description;

    //         lrc_SalesLine.MODIFY(TRUE);
    //         lrc_SalesLine.VALIDATE("Sales Price (Price Base)",lrc_SalesShipLine."Sales Price (Price Base)");
    //         lrc_SalesLine.Modify();

    //         // --------------------------------------------------------------------------------
    //         // Wertgutschriftszeile erstellen
    //         // --------------------------------------------------------------------------------
    //         lrc_ItemChargeAssignmentSales."Document Type" := lrc_SalesHeader."Document Type";
    //         lrc_ItemChargeAssignmentSales."Document No." := lrc_SalesHeader."No.";
    //         lrc_ItemChargeAssignmentSales."Document Line No." := lrc_SalesLine."Line No.";
    //         lrc_ItemChargeAssignmentSales."Line No." := 10000;

    //         lrc_ItemChargeAssignmentSales."Item Charge No." := 'TEST';
    //         lrc_ItemChargeAssignmentSales."Item No." := lrc_SalesShipLine."No.";
    //         lrc_ItemChargeAssignmentSales.Description := lrc_SalesShipLine.Description;
    //         lrc_ItemChargeAssignmentSales."Qty. to Assign" := lrc_SalesLine.Quantity;
    //         lrc_ItemChargeAssignmentSales."Qty. Assigned" := 0;
    //         lrc_ItemChargeAssignmentSales."Unit Cost" := 0;
    //         lrc_ItemChargeAssignmentSales."Amount to Assign" := 0;

    //         lrc_ItemChargeAssignmentSales."Applies-to Doc. Type" := lrc_ItemChargeAssignmentSales."Applies-to Doc. Type"::Shipment;
    //         lrc_ItemChargeAssignmentSales."Applies-to Doc. No." := lrc_SalesShipLine."Document No.";
    //         lrc_ItemChargeAssignmentSales."Applies-to Doc. Line No." := lrc_SalesShipLine."Line No.";
    //         lrc_ItemChargeAssignmentSales."Applies-to Doc. Line Amount" := 0;

    //         lrc_ItemChargeAssignmentSales."Master Batch No." := lrc_SalesShipLine."Master Batch No.";
    //         lrc_ItemChargeAssignmentSales."Batch No." := lrc_SalesShipLine."Batch No.";
    //         lrc_ItemChargeAssignmentSales."Batch Variant No." := lrc_SalesShipLine."Batch Variant No.";

    //         lrc_ItemChargeAssignmentSales.insert();
    //     end;

    //     procedure TestWertgutschrift2(vrc_SalesLine: Record "37")
    //     var
    //         lrc_ItemChargeAssignmentSales: Record "5809";
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Wertgutschriftszeile erstellen
    //         // --------------------------------------------------------------------------------
    //         lrc_ItemChargeAssignmentSales.SETRANGE("Document Type",vrc_SalesLine."Document Type");
    //         lrc_ItemChargeAssignmentSales.SETRANGE("Document No.",vrc_SalesLine."Document No.");
    //         lrc_ItemChargeAssignmentSales.SETRANGE("Document Line No.",vrc_SalesLine."Line No.");
    //         lrc_ItemChargeAssignmentSales.SETRANGE("Line No.",10000);
    //         IF lrc_ItemChargeAssignmentSales.FIND('-') THEN BEGIN
    //           lrc_ItemChargeAssignmentSales.VALIDATE("Qty. to Assign",vrc_SalesLine.Quantity);
    //           lrc_ItemChargeAssignmentSales.Modify();
    //         END;
    //     end;

    //     procedure MoveSalesLinesToDocument(var vrc_SalesHeader: Record "36";var vrc_SalesLineBuffer: Record "7190";var vrc_SalesHeaderTo: Record "36";rbn_DeleteSalesHeaderIfEmpty: Boolean;rbn_UseSameSalesHeader: Boolean;rbn_CreateNewLine: Boolean)
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_SalesHeaderTo: Record "36";
    //         lrc_SalesLineFrom: Record "37";
    //         lrc_SalesLineTo: Record "37";
    //         lrc_SalesCommentLineFrom: Record "44";
    //         lrc_SalesCommentLineTo: Record "44";
    //         lrc_DocumentDimensionFrom: Record "357";
    //         lrc_DocumentDimensionTo: Record "357";
    //         lrc_SalesDiscountFrom: Record "5110344";
    //         lrc_SalesDiscountTo: Record "5110344";
    //         lrc_OutgoingPalletFrom: Record "5110502";
    //         lrc_OutgoingPalletTo: Record "5110502";
    //         lrc_BatchVariantDetail: Record "5110487";
    //         lco_DocumentNo: Code[20];
    //         lrc_SalesCommentFrom: Record "5110427";
    //         lrc_SalesCommentTo: Record "5110427";
    //         lrc_SalesCommentPrintDocFrom: Record "5110428";
    //         lrc_SalesCommentPrintDocTo: Record "5110428";
    //         lin_EntryNo: Integer;
    //         lrc_PalletManagement: Codeunit "5110346";
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lrc_CustomerGroup: Record "5110398";
    //         lrc_ServiceCustomer: Record "Customer";
    //         lrc_SalesHeaderToDocumentNo: Code[20];
    //         lin_SplittLineNo: Integer;
    //         lrc_SalesLineNext: Record "37";
    //         lco_SalesDocSubtypeCode: Code[10];
    //         lcu_ReleaseSalesDocument: Codeunit "414";
    //         lbn_CustomerChange: Boolean;
    //         lrc_IFWSetup: Record "5110303";
    //         lrc_IFWSourceCrossReference: Record "5110303";
    //         AgilesText001: Label 'Please enter a HHLA Ref. No. in Basedata for Customerno. %1.';
    //         lrc_Customer: Record "Customer";
    //         lcu_DiscountMgt: Codeunit "5110312";
    //         lco_NoSeriesOrder: Code[20];
    //         lco_NoSeriesShipment: Code[20];
    //         lco_NoSeriesInvoice: Code[20];
    //         "-- SAL 007 IFW40104 L": Integer;
    //         lrc_SalesLineTo2: Record "37";
    //         "-- SAL 007 IFW40104 T": ;
    //         AGILESText002: Label 'There is no Qty. (TU) for the new Line %1 in Document %2.';
    //         "-- SAL 014 IFW40140 L": Integer;
    //         lrc_Customer1: Record "Customer";
    //         lcu_MOSManagement: Codeunit "5087905";
    //         "-- SAL 019 IFW40188 L": Integer;
    //         lrc_SalesLineTemp: Record "37" temporary;
    //         lcu_UnitMgt: Codeunit "5110703";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_ItemTransportUnitFactor: Record "5087912";
    //         ldc_PalletFactor: Decimal;
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------------------------------

    //         /*
    //         lbn_CustomerChange := TRUE;

    //         IF vrc_SalesLineBuffer.COUNT() = 0 THEN BEGIN
    //           EXIT;
    //         END;

    //         // Status des Beleges ggfls. auf offen setzen
    //         IF vrc_SalesHeader.Status = vrc_SalesHeader.Status::Released THEN BEGIN
    //           lcu_ReleaseSalesDocument.Reopen(vrc_SalesHeader);
    //         END;

    //         // Prüfung ob ein neuer oder der selbe Beleg verwendet werden soll
    //         IF rbn_UseSameSalesHeader = FALSE THEN BEGIN

    //           // Ursprungsbeleg festlegen
    //           IF vrc_SalesHeaderTo."No." <> '' THEN BEGIN

    //             // vorher definierter Beleg
    //             lrc_SalesHeaderTo.GET(vrc_SalesHeaderTo."Document Type",vrc_SalesHeaderTo."No.");
    //             lbn_CustomerChange := FALSE;

    //           END ELSE BEGIN

    //             // Abrüfung auf Lagerort (InterWeichert)
    //             lrc_FruitVisionSetup.GET();
    //             IF lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT' THEN BEGIN
    //               lrc_IFWSetup.GET();
    //               IF vrc_SalesHeader."Location Code" = lrc_IFWSetup."Location Code WEIDNER" THEN BEGIN
    //                 // Referenznr. der HHLA prüfen
    //                 lrc_IFWSourceCrossReference.Reset();
    //                 lrc_IFWSourceCrossReference.SETRANGE("Source Type",lrc_IFWSourceCrossReference."Source Type"::"0");
    //                 lrc_IFWSourceCrossReference.SETRANGE("Source No.",vrc_SalesHeader."Split Sales Order to Cust. No.");
    //                 lrc_IFWSourceCrossReference.SETRANGE("Cross-Reference Type",
    //                                                      lrc_IFWSourceCrossReference."Cross-Reference Type"::"2");
    //                 lrc_IFWSourceCrossReference.SETFILTER("Cross-Reference No.",'<>%1','');
    //                 IF NOT lrc_IFWSourceCrossReference.FIND('-') THEN BEGIN
    //                   lrc_Customer.GET(vrc_SalesHeader."Split Sales Order to Cust. No.");
    //                   ERROR(AgilesText001,vrc_SalesHeader."Split Sales Order to Cust. No." + ' (' + lrc_Customer.Name + ')');
    //                 END;
    //               END;
    //             END;

    //             // Neuen Belegkopf anlegen
    //             lrc_SalesHeaderTo.INIT();
    //             lrc_SalesHeaderTo."Document Type" := vrc_SalesHeader."Document Type";
    //             lrc_SalesHeaderTo."Sales Doc. Subtype Code" := vrc_SalesHeader."Sales Doc. Subtype Code";

    //             // ggfls. wieder in eine andere Belegartunterart wechseln
    //             IF vrc_SalesHeader."Customer Group Code" <> '' THEN BEGIN
    //                IF lrc_CustomerGroup.GET(vrc_SalesHeader."Customer Group Code") THEN BEGIN
    //                  IF lrc_CustomerGroup."Sales Doc. Subtype Code OrdSpl" <> '' THEN BEGIN
    //                    lrc_SalesHeaderTo."Sales Doc. Subtype Code" := lrc_CustomerGroup."Sales Doc. Subtype Code OrdSpl";
    //                  END;
    //                END;
    //             END ELSE BEGIN
    //               vrc_SalesHeader.TESTFIELD("Customer Group Code");
    //             END;

    //             IF vrc_SalesHeader."Document Type" = vrc_SalesHeader."Document Type"::Order THEN BEGIN
    //               lrc_SalesHeaderTo."Pallets Entry No." := lrc_PalletManagement.NewPalletEntryNo;
    //             END;
    //             lrc_SalesHeaderTo.INSERT(TRUE);

    //             // SAL 006 IFW40061.s
    //             lco_NoSeriesOrder := lrc_SalesHeaderTo."No. Series";
    //             lco_NoSeriesShipment := lrc_SalesHeaderTo."Posting No. Series";
    //             lco_NoSeriesInvoice := lrc_SalesHeaderTo."Shipping No. Series";
    //             // SAL 006 IFW40061.e

    //             lco_DocumentNo := lrc_SalesHeaderTo."No.";
    //             lco_SalesDocSubtypeCode := lrc_SalesHeaderTo."Sales Doc. Subtype Code";
    //             lrc_SalesHeaderTo.TRANSFERFIELDS(vrc_SalesHeader);
    //             lrc_SalesHeaderTo.Status := lrc_SalesHeaderTo.Status::Open;
    //             lrc_SalesHeaderTo."No." := lco_DocumentNo;
    //             lrc_SalesHeaderTo."Sales Doc. Subtype Code" := lco_SalesDocSubtypeCode;

    //             // SAL 006 IFW40061.s
    //             lrc_SalesHeaderTo."No. Series" := lco_NoSeriesOrder;
    //             lrc_SalesHeaderTo."Posting No. Series" := lco_NoSeriesShipment;
    //             lrc_SalesHeaderTo."Shipping No. Series" := lco_NoSeriesInvoice;
    //             // SAL 006 IFW40061.e

    //             // SAL 008 IFW40105.s
    //             lrc_SalesHeaderTo."Shipping No." := '';
    //             // SAL 008 IFW40105.e

    //             IF lrc_SalesHeaderTo."Promised Delivery Date" <= TODAY THEN BEGIN
    //                lrc_SalesHeaderTo.VALIDATE("Promised Delivery Date", TODAY);
    //             END;
    //             IF lrc_SalesHeaderTo."Shipment Date" <= TODAY THEN BEGIN
    //                lrc_SalesHeaderTo.VALIDATE("Shipment Date", TODAY);
    //             END;

    //             lrc_SalesHeaderTo.MODIFY (TRUE);

    //             // Kopfdimensionen kopieren
    //             lrc_DocumentDimensionFrom.Reset();
    //             lrc_DocumentDimensionFrom.SETRANGE("Table ID", lrc_DocumentDimensionFrom."Table ID");
    //             lrc_DocumentDimensionFrom.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //             lrc_DocumentDimensionFrom.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //             lrc_DocumentDimensionFrom.SETRANGE("Line No.", 0);
    //             IF lrc_DocumentDimensionFrom.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_DocumentDimensionTo.INIT();
    //                 lrc_DocumentDimensionTo.TRANSFERFIELDS(lrc_DocumentDimensionFrom);
    //                 lrc_DocumentDimensionTo."Document No." := lrc_SalesHeaderTo."No.";
    //                 lrc_DocumentDimensionTo.INSERT(TRUE);
    //               UNTIL lrc_DocumentDimensionFrom.NEXT() = 0;
    //             END;


    //             // Bemerkungen Druckbelege kopieren
    //             lin_EntryNo := 0;
    //             lrc_SalesCommentTo.Reset();
    //             IF lrc_SalesCommentTo.FIND('+') THEN BEGIN
    //               lin_EntryNo := lrc_SalesCommentTo."Entry No.";
    //             END;

    //             lrc_SalesCommentFrom.Reset();
    //             lrc_SalesCommentFrom.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //             lrc_SalesCommentFrom.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //             lrc_SalesCommentFrom.SETRANGE("Document Line No.", 0);
    //             IF lrc_SalesCommentFrom.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_SalesCommentTo.INIT();
    //                 lrc_SalesCommentTo.TRANSFERFIELDS(lrc_SalesCommentFrom);
    //                 IF lrc_SalesCommentFrom."Entry Type" = lrc_SalesCommentFrom."Entry Type"::Header THEN
    //                    lin_EntryNo := lin_EntryNo + 1;
    //                 lrc_SalesCommentTo."Entry No." := lin_EntryNo;
    //                 lrc_SalesCommentTo."Document No." := lrc_SalesHeaderTo."No.";
    //                 lrc_SalesCommentTo.INSERT(TRUE);
    //                 IF lrc_SalesCommentFrom."Entry Type" = lrc_SalesCommentFrom."Entry Type"::Header THEN BEGIN
    //                   lrc_SalesCommentPrintDocFrom.Reset();
    //                   lrc_SalesCommentPrintDocFrom.SETRANGE("Sales Comment Entry No.", lrc_SalesCommentFrom."Entry No.");
    //                   IF lrc_SalesCommentPrintDocFrom.FIND('-') THEN BEGIN
    //                      REPEAT
    //                        lrc_SalesCommentPrintDocTo.INIT();
    //                        lrc_SalesCommentPrintDocTo.TRANSFERFIELDS(lrc_SalesCommentPrintDocFrom);
    //                        lrc_SalesCommentPrintDocTo."Sales Comment Entry No." := lin_EntryNo;
    //                        lrc_SalesCommentPrintDocTo.INSERT(TRUE);
    //                      UNTIL lrc_SalesCommentPrintDocFrom.NEXT() = 0;
    //                   END;
    //                 END;
    //               UNTIL lrc_SalesCommentFrom.NEXT() = 0;
    //             END;

    //             // Interne Bemerkungen Auftrag kopieren
    //             lrc_SalesCommentLineFrom.Reset();
    //             lrc_SalesCommentLineFrom.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //             lrc_SalesCommentLineFrom.SETRANGE("No.", vrc_SalesHeader."No.");
    //             IF lrc_SalesCommentLineFrom.FIND('-') THEN BEGIN
    //               REPEAT
    //                  lrc_SalesCommentLineTo.INIT();
    //                  lrc_SalesCommentLineTo.TRANSFERFIELDS(lrc_SalesCommentLineFrom);
    //                  lrc_SalesCommentLineTo."No." := lrc_SalesHeaderTo."No.";
    //                  lrc_SalesCommentLineTo.INSERT(TRUE);
    //               UNTIL lrc_SalesCommentLineFrom.NEXT() = 0;
    //             END;

    //             // Rechnungsrabatte kopieren, aber ohne Werte
    //             lrc_SalesDiscountFrom.Reset();
    //             lrc_SalesDiscountFrom.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //             lrc_SalesDiscountFrom.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //             IF lrc_SalesDiscountFrom.FIND('-') THEN BEGIN
    //               REPEAT
    //                  lrc_SalesDiscountTo.INIT();
    //                  lrc_SalesDiscountTo.TRANSFERFIELDS(lrc_SalesDiscountFrom);
    //                  lrc_SalesDiscountTo."Document No." := lrc_SalesHeaderTo."No.";
    //                  lrc_SalesDiscountTo.INSERT(TRUE);

    //               UNTIL lrc_SalesDiscountFrom.NEXT() = 0;
    //             END;

    //           END;

    //         END ELSE BEGIN

    //           // gleicher Beleg
    //           lrc_SalesHeaderTo.GET(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.");

    //         END;

    //         // SAL 019 IFW40188.s
    //         lrc_SalesLineTemp.Reset();
    //         lrc_SalesLineTemp.DELETEALL();
    //         // SAL 019 IFW40188.e

    //         // eigentliche Zeilen verschieben
    //         lin_SplittLineNo := 0;
    //         lrc_SalesLineFrom.Reset();
    //         lrc_SalesLineFrom.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //         lrc_SalesLineFrom.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //         IF lrc_SalesLineFrom.FIND('-') THEN BEGIN
    //            REPEAT

    //              IF vrc_SalesLineBuffer.GET(lrc_SalesLineFrom."Document No.", lrc_SalesLineFrom."Line No.", 1) THEN BEGIN

    //                IF rbn_UseSameSalesHeader = FALSE THEN BEGIN

    //                  // entsprechende Zeile kopieren
    //                  lrc_SalesLineTo.INIT();
    //                  lrc_SalesLineTo.TRANSFERFIELDS(lrc_SalesLineFrom);
    //                  lrc_SalesLineTo."Document No." := lrc_SalesHeaderTo."No.";

    //                  IF rbn_CreateNewLine = TRUE THEN BEGIN
    //                    // Zeilennr. ermitteln
    //                    lrc_SalesLineNext.Reset();
    //                    lrc_SalesLineNext.SETRANGE("Document Type",lrc_SalesLineTo."Document Type");
    //                    lrc_SalesLineNext.SETRANGE("Document No.",lrc_SalesLineTo."Document No.");
    //                    IF lrc_SalesLineNext.FIND('+') THEN BEGIN
    //                      lrc_SalesLineTo."Line No." := lrc_SalesLineNext."Line No." + 10000;
    //                    END ELSE BEGIN
    //                      lrc_SalesLineTo."Line No." := 10000;
    //                    END;
    //                  END;

    //                  lrc_SalesLineTo.INSERT(TRUE);
    //                  lrc_SalesLineTo.VALIDATE("_Sales Doc. Subtype Code", lrc_SalesHeaderTo."Sales Doc. Subtype Code");

    //                  // FV4 004 IFW40004.s
    //                  // IF (lrc_SalesLineTo."Source No. Split Line" = '') AND (lrc_SalesLineTo."Source Line No. Split Line" = 0) THEN BEGIN
    //                    lrc_SalesLineTo."Source Type Split Line" := lrc_SalesLineFrom."Document Type";
    //                    lrc_SalesLineTo."Source No. Split Line" := lrc_SalesLineFrom."Document No.";
    //                    lrc_SalesLineTo."Source Line No. Split Line" := lrc_SalesLineFrom."Line No.";
    //                  // END;
    //                  // FV4 004 IFW40004.e

    //                  lrc_SalesLineTo.MODIFY(TRUE);

    //                END ELSE BEGIN

    //                  // Zeilennr. für Splitt ermitteln
    //                  lrc_SalesLineNext.Reset();
    //                  lrc_SalesLineNext.SETRANGE("Document Type",lrc_SalesLineFrom."Document Type");
    //                  lrc_SalesLineNext.SETRANGE("Document No.",lrc_SalesLineFrom."Document No.");
    //                  lrc_SalesLineNext.SETFILTER("Line No.",'>%1',lrc_SalesLineFrom."Line No.");
    //                  IF lrc_SalesLineNext.FIND('-') THEN BEGIN
    //                    lin_SplittLineNo := ROUND((lrc_SalesLineNext."Line No." + lrc_SalesLineFrom."Line No.") / 2,1);
    //                  END ELSE BEGIN
    //                    lin_SplittLineNo := lrc_SalesLineFrom."Line No." + 10000;
    //                  END;

    //                  // entsprechende Zeile anlegen
    //                  lrc_SalesLineTo.INIT();
    //                  lrc_SalesLineTo.TRANSFERFIELDS(lrc_SalesLineFrom);
    //                  lrc_SalesLineTo."Line No." := lin_SplittLineNo;
    //                  lrc_SalesLineTo.INSERT(TRUE);
    //                  lrc_SalesLineTo.VALIDATE("_Sales Doc. Subtype Code", lrc_SalesHeaderTo."Sales Doc. Subtype Code");

    //                  lrc_SalesLineTo.MODIFY(TRUE);

    //                END;


    //                // Zeilendimensionen kopieren
    //                lrc_DocumentDimensionFrom.Reset();
    //                lrc_DocumentDimensionFrom.SETRANGE("Table ID", lrc_DocumentDimensionFrom."Table ID");
    //                lrc_DocumentDimensionFrom.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //                lrc_DocumentDimensionFrom.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //                lrc_DocumentDimensionFrom.SETRANGE("Line No.", lrc_SalesLineFrom."Line No.");
    //                IF lrc_DocumentDimensionFrom.FIND('-') THEN BEGIN
    //                  REPEAT
    //                    // Zeilendimension für neue Zeile anlegen
    //                    lrc_DocumentDimensionTo.INIT();
    //                    lrc_DocumentDimensionTo.TRANSFERFIELDS(lrc_DocumentDimensionFrom);
    //                    lrc_DocumentDimensionTo."Document No." := lrc_SalesHeaderTo."No.";
    //                    lrc_DocumentDimensionTo.INSERT(TRUE);
    //                  UNTIL lrc_DocumentDimensionFrom.NEXT() = 0;
    //                END;

    //                // Bemerkungen Zeilen kopieren
    //                lin_EntryNo := 0;
    //                lrc_SalesCommentTo.Reset();
    //                IF lrc_SalesCommentTo.FIND('+') THEN BEGIN
    //                  lin_EntryNo := lrc_SalesCommentTo."Entry No.";
    //                END;

    //                lrc_SalesCommentFrom.Reset();
    //                lrc_SalesCommentFrom.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //                lrc_SalesCommentFrom.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //                lrc_SalesCommentFrom.SETRANGE("Document Line No.", lrc_SalesLineFrom."Line No.");
    //                IF lrc_SalesCommentFrom.FIND('-') THEN BEGIN
    //                  REPEAT
    //                    lrc_SalesCommentTo.INIT();
    //                    lrc_SalesCommentTo.TRANSFERFIELDS(lrc_SalesCommentFrom);
    //                    IF lrc_SalesCommentFrom."Entry Type" = lrc_SalesCommentFrom."Entry Type"::Header THEN
    //                       lin_EntryNo := lin_EntryNo + 1;
    //                    lrc_SalesCommentTo."Entry No." := lin_EntryNo;
    //                    lrc_SalesCommentTo."Document No." := lrc_SalesHeaderTo."No.";
    //                    lrc_SalesCommentTo."Document Line No." := lrc_SalesLineTo."Line No.";
    //                    lrc_SalesCommentTo.INSERT(TRUE);
    //                    IF lrc_SalesCommentFrom."Entry Type" = lrc_SalesCommentFrom."Entry Type"::Header THEN BEGIN
    //                      lrc_SalesCommentPrintDocFrom.Reset();
    //                      lrc_SalesCommentPrintDocFrom.SETRANGE("Sales Comment Entry No.", lrc_SalesCommentFrom."Entry No.");
    //                      IF lrc_SalesCommentPrintDocFrom.FIND('-') THEN BEGIN
    //                         REPEAT
    //                           lrc_SalesCommentPrintDocTo.INIT();
    //                           lrc_SalesCommentPrintDocTo.TRANSFERFIELDS(lrc_SalesCommentPrintDocFrom);
    //                           lrc_SalesCommentPrintDocTo."Sales Comment Entry No." := lin_EntryNo;
    //                           lrc_SalesCommentPrintDocTo.INSERT(TRUE);
    //                         UNTIL lrc_SalesCommentPrintDocFrom.NEXT() = 0;
    //                      END;
    //                    END;
    //                  UNTIL lrc_SalesCommentFrom.NEXT() = 0;
    //                END;

    //                // Palettenzeilen umschieben
    //                // hier kann es zu Problemen kommen, wenn nicht die komplette Zeile verschoben wird!!!!
    //                // wird aber erst einmal vernachlässigt
    //                // GME verschiebt immer komplette Zeilen und ist einzigster Kunde mit Palettenzeilen
    //                IF (vrc_SalesHeader."Document Type" = vrc_SalesHeader."Document Type"::Order) AND
    //                   (vrc_SalesHeader."Pallets Entry No." <> 0) AND
    //                   (lrc_SalesLineFrom.Quantity = vrc_SalesLineBuffer.Quantity) THEN BEGIN

    //                  lrc_OutgoingPalletFrom.Reset();
    //                  lrc_OutgoingPalletFrom.SETCURRENTKEY("Document Type","Document No.","Document Line No.",Posted);
    //                  lrc_OutgoingPalletFrom.SETRANGE("Document Type", lrc_OutgoingPalletFrom."Document Type"::"Sales Order");
    //                  lrc_OutgoingPalletFrom.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //                  lrc_OutgoingPalletFrom.SETRANGE("Document Line No.", lrc_SalesLineFrom."Line No.");
    //                  lrc_OutgoingPalletFrom.SETRANGE("Entry No.", vrc_SalesHeader."Pallets Entry No.");
    //                  IF lrc_OutgoingPalletFrom.FIND('-') THEN BEGIN
    //                     REPEAT
    //                        lrc_OutgoingPalletTo.INIT();
    //                        lrc_OutgoingPalletTo.TRANSFERFIELDS(lrc_OutgoingPalletFrom);
    //                        lrc_OutgoingPalletTo."Entry No." := lrc_SalesHeaderTo."Pallets Entry No.";
    //                        lrc_OutgoingPalletTo."Line No." := 0;
    //                        lrc_OutgoingPalletTo."Document No." :=  lrc_SalesHeaderTo."No.";
    //                        lrc_OutgoingPalletTo.INSERT(TRUE);
    //                     UNTIL lrc_OutgoingPalletFrom.NEXT() = 0;
    //                     IF lrc_OutgoingPalletFrom.FIND('-') THEN BEGIN
    //                        lrc_OutgoingPalletFrom.DELETEALL(TRUE);
    //                     END;
    //                   END;
    //                END;


    //                // wurde die komplette Auftragszeile verschoben
    //                IF (lrc_SalesLineFrom.Quantity = vrc_SalesLineBuffer.Quantity) THEN BEGIN
    //                  // Positionsvariantendetail umbenennen
    //                  lrc_BatchVariantDetail.Reset();
    //                  lrc_BatchVariantDetail.SETRANGE("Entry No.", lrc_SalesLineTo."Batch Var. Detail ID");
    //                  IF lrc_BatchVariantDetail.FIND('-') THEN BEGIN
    //                    REPEAT
    //                      lrc_BatchVariantDetail."Source No." := lrc_SalesLineTo."Document No.";
    //                      lrc_BatchVariantDetail.Modify();
    //                     UNTIL lrc_BatchVariantDetail.NEXT() = 0;
    //                  END;
    //                  lrc_SalesLineFrom."Batch Var. Detail ID" := 0;
    //                  lrc_SalesLineFrom.VALIDATE( Quantity, 0);

    //                  // Menge Verpackungen aktualisieren
    //                  lrc_SalesLineFrom."Quantity (PU)" := lrc_SalesLineFrom.Quantity * lrc_SalesLineFrom."Qty. (PU) per Unit of Measure";

    //                  // Menge Paletten aktualisieren
    //                  IF lrc_SalesLineFrom."Qty. (Unit) per Transp. Unit" <> 0 THEN BEGIN
    //                    lrc_SalesLineFrom."Quantity (TU)" := lrc_SalesLineFrom.Quantity / lrc_SalesLineFrom."Qty. (Unit) per Transp. Unit"
    //                  END ELSE BEGIN
    //                    lrc_SalesLineFrom."Quantity (TU)" := 0;
    //                  END;

    //                  lrc_SalesLineFrom.Modify();
    //               END ELSE BEGIN
    //                 // Menge der aktuellen Auftragszeile um abgesplittete Menge verringern
    //                 lrc_SalesLineFrom.VALIDATE( Quantity, lrc_SalesLineFrom.Quantity - vrc_SalesLineBuffer.Quantity);

    //                 // Menge Verpackungen aktualisieren
    //                 lrc_SalesLineFrom."Quantity (PU)" := lrc_SalesLineFrom.Quantity * lrc_SalesLineFrom."Qty. (PU) per Unit of Measure";

    //                 // Menge Paletten aktualisieren
    //                 IF lrc_SalesLineFrom."Qty. (Unit) per Transp. Unit" <> 0 THEN BEGIN
    //                   lrc_SalesLineFrom."Quantity (TU)" := lrc_SalesLineFrom.Quantity / lrc_SalesLineFrom."Qty. (Unit) per Transp. Unit"
    //                 END ELSE BEGIN
    //                   lrc_SalesLineFrom."Quantity (TU)" := 0;
    //                 END;

    //                 lrc_SalesLineFrom.Modify();

    //                 // Positionsvariantendetail von aktueller Auftragszeile auf Menge der Auftragszeile setzen
    //                 lrc_BatchVariantDetail.Reset();
    //                 lrc_BatchVariantDetail.SETRANGE("Entry No.", lrc_SalesLineFrom."Batch Var. Detail ID");
    //                 IF lrc_BatchVariantDetail.FIND('-') THEN BEGIN
    //                   REPEAT
    //                     lrc_BatchVariantDetail.VALIDATE(Quantity, lrc_SalesLineFrom.Quantity);
    //                     lrc_BatchVariantDetail.MODIFY(TRUE);
    //                    UNTIL lrc_BatchVariantDetail.NEXT() = 0;
    //                 END;

    //                 // Abgesplittete Menge setzen in der neuen Auftragszeile
    //                 lrc_SalesLineTo."Batch Var. Detail ID" := 0;

    //                 // Mengenfelder auf 0 setzen // Transferfields
    //                 CLEAR(lrc_SalesLineTo."Outstanding Quantity");
    //                 CLEAR(lrc_SalesLineTo."Qty. to Invoice");
    //                 CLEAR(lrc_SalesLineTo."Qty. to Ship");
    //                 CLEAR(lrc_SalesLineTo."Qty. Shipped Not Invoiced");
    //                 CLEAR(lrc_SalesLineTo."Quantity Shipped");
    //                 CLEAR(lrc_SalesLineTo."Quantity Invoiced");
    //                 CLEAR(lrc_SalesLineTo."Quantity (Base)");
    //                 CLEAR(lrc_SalesLineTo."Outstanding Qty. (Base)");
    //                 CLEAR(lrc_SalesLineTo."Qty. to Invoice (Base)");
    //                 CLEAR(lrc_SalesLineTo."Qty. to Ship (Base)");
    //                 CLEAR(lrc_SalesLineTo."Qty. Shipped Not Invd. (Base)");
    //                 CLEAR(lrc_SalesLineTo."Qty. Shipped (Base)");
    //                 CLEAR(lrc_SalesLineTo."Qty. Invoiced (Base)");
    //                 CLEAR(lrc_SalesLineTo."Quantity (PU)");
    //                 CLEAR(lrc_SalesLineTo."Quantity (TU)");

    //                 lrc_SalesLineTo.VALIDATE(Quantity, vrc_SalesLineBuffer.Quantity);

    //                 // Menge Verpackungen aktualisieren
    //                 lrc_SalesLineTo."Quantity (PU)" := lrc_SalesLineTo.Quantity * lrc_SalesLineTo."Qty. (PU) per Unit of Measure";

    //                 // Menge Paletten aktualisieren
    //                 IF lrc_SalesLineTo."Qty. (Unit) per Transp. Unit" <> 0 THEN BEGIN
    //                   lrc_SalesLineTo."Quantity (TU)" := lrc_SalesLineTo.Quantity / lrc_SalesLineTo."Qty. (Unit) per Transp. Unit"
    //                 END ELSE BEGIN
    //                   lrc_SalesLineTo."Quantity (TU)" := 0;
    //                 END;

    //                 lrc_SalesLineTo."Batch Var. Detail ID" := lcu_BatchMgt.SalesBatchVarNosDirect(lrc_SalesLineTo);
    //                 lrc_SalesLineTo.VALIDATE("_Sales Doc. Subtype Code", lrc_SalesHeaderTo."Sales Doc. Subtype Code");
    //                 lrc_SalesLineTo.MODIFY(TRUE);

    //                 // Positionsvariantendetail Kopieren und Menge der neuen Auftragszeile dort eintragen
    //                 // Nicht notwendig wird sowieso in Tabelle 37 gemacht

    //               END;

    //               // SAL 007 IFW40104.s
    //               lrc_SalesLineTo2.GET(lrc_SalesLineTo."Document Type",lrc_SalesLineTo."Document No.",lrc_SalesLineTo."Line No.");
    //               IF lrc_SalesLineTo2."Transport Unit of Measure (TU)" <> '' THEN BEGIN
    //                 IF lrc_SalesLineTo2."Quantity (TU)" = 0 THEN BEGIN
    //                   MESSAGE(AGILESText002,lrc_SalesLineTo2."Line No.",lrc_SalesLineTo2."Document No.");
    //                 END;
    //               END;
    //               // SAL 007 IFW40104.e

    //               // SAL 019 IFW40188.s
    //               lrc_SalesLineTemp := lrc_SalesLineTo;
    //               lrc_SalesLineTemp.insert();
    //               // SAL 019 IFW40188.e

    //              END;
    //            UNTIL lrc_SalesLineFrom.NEXT() = 0;

    //            // alte Verkaufszeile löschen wenn Menge = 0 ist
    //            IF lrc_SalesLineFrom.FIND('-') THEN BEGIN
    //              REPEAT
    //                IF vrc_SalesLineBuffer.GET(lrc_SalesLineFrom."Document No.", lrc_SalesLineFrom."Line No.", 1) THEN BEGIN
    //                  IF lrc_SalesLineFrom.Quantity = 0 THEN BEGIN
    //                    lrc_SalesLineFrom.NotDeletePlanningLines(TRUE);
    //                    lrc_SalesLineFrom.DELETE(TRUE);
    //                  END;
    //                END;
    //              UNTIL lrc_SalesLineFrom.NEXT() = 0;

    //            END;

    //            lrc_SalesHeaderToDocumentNo := lrc_SalesHeaderTo."No.";

    //            IF lbn_CustomerChange = TRUE THEN BEGIN
    //              // SAL 005 00000000.s
    //              // Debitorenwechsel beachten
    //              IF (vrc_SalesHeader."Split Sales Order to Cust. No." <> vrc_SalesHeader."Sell-to Customer No.") AND
    //                 (vrc_SalesHeader."Split Sales Order to Cust. No." <> '') THEN BEGIN

    //                 // keine Maske bringen in der Funktion, die den Debitorwechsel durchführt
    //                 lrc_SalesHeaderTo.MODIFY(TRUE);
    //                 SetFixChangedCustomerNo(vrc_SalesHeader."Split Sales Order to Cust. No.");
    //                 SalesWechselKontierung(lrc_SalesHeaderTo);

    //                 // nach Wechsel den Auftragsdebitor gleich dem aktuellen Debitor setzen
    //                 // wenn der Palettenhafter dem alten Sell.-To Debitor entsprach auch aktualisieren
    //                 // aktuellen Datensatz noch mal laden, weil Änderungen in Funktion SalesWechselkontierungen erfolgt sind

    //                 lrc_SalesHeaderTo.Reset();
    //                 lrc_SalesHeaderTo.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //                 lrc_SalesHeaderTo.SETRANGE("No.", lrc_SalesHeaderToDocumentNo);
    //                 IF lrc_SalesHeaderTo.FIND('-') THEN;
    //                 lrc_SalesHeaderTo.VALIDATE("Split Sales Order to Cust. No.", lrc_SalesHeaderTo."Sell-to Customer No.");
    //                 IF (lrc_SalesHeaderTo."Source Type Liability TU" = lrc_SalesHeaderTo."Source Type Liability TU"::Customer) AND
    //                    (lrc_SalesHeaderTo."Source No. Liability TU" = vrc_SalesHeader."Sell-to Customer No.") THEN BEGIN
    //                    lrc_SalesHeaderTo.VALIDATE("Source No. Liability TU", lrc_SalesHeaderTo."Sell-to Customer No.");
    //                 END;

    //                 // SAL 012 IFW40123.s
    //                 { alter Code
    //                 lrc_SalesHeaderTo."Service Invoice to Cust. No." := lrc_SalesHeaderTo."Sell-to Customer No.";
    //                 IF lrc_ServiceCustomer.GET(lrc_SalesHeaderTo."Sell-to Customer No.") THEN BEGIN
    //                   IF lrc_ServiceCustomer."Service Invoice Customer No." <> '' THEN BEGIN
    //                     lrc_SalesHeaderTo."Service Invoice to Cust. No." := lrc_ServiceCustomer."Service Invoice Customer No.";
    //                   END;
    //                 END;
    //                 }
    //                 // SAL 012 IFW40123.e

    //                 lrc_SalesHeaderTo.MODIFY(TRUE);

    //                 // SAL 019 IFW40188.s
    //                 ldc_PalletFactor := 0;
    //                 lrc_SalesLineTemp.Reset();
    //                 IF lrc_SalesLineTemp.FIND('-') THEN BEGIN
    //                   REPEAT
    //                     lrc_SalesLineTo.GET(lrc_SalesLineTemp."Document Type",lrc_SalesLineTemp."Document No.",lrc_SalesLineTemp."Line No.");
    //                     lrc_SalesLineTo.VALIDATE("Transport Unit of Measure (TU)",lrc_SalesLineTemp."Transport Unit of Measure (TU)");

    //                     IF (lrc_SalesLineTo."Transport Unit of Measure (TU)" <> '') THEN BEGIN

    //                       lcu_UnitMgt.GetItemVendorUnitPalletFactor(lrc_SalesLineTo."No.",
    //                                                                 lrc_ItemTransportUnitFactor."Reference Typ"::Customer,
    //                                                                 lrc_SalesLineTo."Sell-to Customer No.",
    //                                                                 lrc_SalesLineTo."Unit of Measure Code",
    //                                                                 lrc_SalesLineTo."Qty. per Unit of Measure",
    //                                                                 lrc_SalesLineTo."Transport Unit of Measure (TU)",
    //                                                                 ldc_PalletFactor);
    //                       IF ldc_PalletFactor <> 0 THEN BEGIN
    //                         lrc_SalesLineTo."Qty. (Unit) per Transp. Unit" := ldc_PalletFactor;
    //                         // Menge Paletten berechnen
    //                         IF lrc_SalesLineTo."Qty. (Unit) per Transp. Unit" <> 0 THEN BEGIN
    //                           lrc_SalesLineTo."Quantity (TU)" := lrc_SalesLineTo.Quantity / lrc_SalesLineTo."Qty. (Unit) per Transp. Unit"
    //                         END ELSE BEGIN
    //                           lrc_SalesLineTo."Quantity (TU)" := 0;
    //                         END;
    //                       END;
    //                     END;

    //                     lrc_UnitofMeasure.GET(lrc_SalesLineTo."Transport Unit of Measure (TU)");
    //                     lrc_SalesLineTo."Freight Unit of Measure (FU)" := lrc_UnitofMeasure."Freight Unit of Measure (FU)";

    //                     lrc_SalesLineTo.MODIFY(TRUE);
    //                   UNTIL lrc_SalesLineTemp.NEXT() = 0;
    //                 END;
    //                 // SAL 019 IFW40188.e

    //                 // Rabatte neu laden
    //                 lcu_DiscountMgt.SalesDiscLoad(lrc_SalesHeaderTo);

    //              END;
    //              // SAL 005 00000000.e
    //            END;

    //            // SAL 012 IFW40123.s
    //            IF lrc_SalesHeaderTo."Service Invoice to Cust. No." = '' THEN BEGIN
    //              IF lrc_ServiceCustomer.GET(lrc_SalesHeaderTo."Sell-to Customer No.") THEN BEGIN
    //                IF lrc_ServiceCustomer."Service Invoice Customer No." <> '' THEN BEGIN
    //                  lrc_SalesHeaderTo."Service Invoice to Cust. No." := lrc_ServiceCustomer."Service Invoice Customer No.";
    //                END ELSE BEGIN
    //                  lrc_SalesHeaderTo."Service Invoice to Cust. No." := lrc_SalesHeaderTo."Sell-to Customer No.";
    //                END;
    //              END;
    //            END;
    //            // SAL 012 IFW40123.e

    //            vrc_SalesLineBuffer.DELETE(TRUE);

    //            lrc_SalesHeaderTo.MODIFY(TRUE);

    //            // "KW", "Suchfeld Positionsnr." und "Transportmittelcode (Herkunft)" füllen
    //            CalcGlobalInfoFields(lrc_SalesHeaderTo);

    //            // SAL 014 IFW40140.s
    //            lrc_Customer1.GET(lrc_SalesHeaderTo."Sell-to Customer No.");
    //            lcu_MOSManagement.GetType(lrc_Customer1,lrc_SalesHeaderTo);
    //            // SAL 014 IFW40140.e

    //            lrc_SalesHeaderTo.MODIFY(TRUE);

    //            // alten Verkaufskopf löschen, wenn keine Zeilen mehr vorhanden sind
    //            IF rbn_DeleteSalesHeaderIfEmpty = TRUE THEN BEGIN
    //              lrc_SalesLineFrom.Reset();
    //              lrc_SalesLineFrom.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //              lrc_SalesLineFrom.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //              IF NOT lrc_SalesLineFrom.FIND('-') THEN BEGIN
    //                 vrc_SalesHeader.DELETE(TRUE);
    //              END ELSE BEGIN
    //                COMMIT;
    //                // alten Beleg berechnen
    //                CalcSalesOrder(vrc_SalesHeader);
    //              END;
    //            END ELSE BEGIN
    //                COMMIT;
    //                // alten Beleg berechnen
    //                CalcSalesOrder(vrc_SalesHeader);
    //            END;

    //            // neuen Beleg berechnen
    //            CalcSalesOrder(lrc_SalesHeaderTo);

    //            // SAL 007 IFW40104.s
    //            lrc_SalesLineTo2.Reset();
    //            lrc_SalesLineTo2.SETRANGE("Document Type",lrc_SalesHeaderTo."Document Type");
    //            lrc_SalesLineTo2.SETRANGE("Document No.",lrc_SalesHeaderTo."No.");
    //            IF lrc_SalesLineTo2.FIND('-') THEN BEGIN
    //              REPEAT
    //                IF lrc_SalesLineTo2."Transport Unit of Measure (TU)" <> '' THEN BEGIN
    //                  IF lrc_SalesLineTo2."Quantity (TU)" = 0 THEN BEGIN
    //                    MESSAGE(AGILESText002,lrc_SalesLineTo2."Line No.",lrc_SalesLineTo2."Document No.");
    //                  END;
    //                END;
    //              UNTIL lrc_SalesLineTo2.NEXT() = 0;
    //            END;
    //            // SAL 007 IFW40104.e

    //         END;
    //         */

    //     end;

    //     procedure MoveSalesLinesToOldDocument(var vrc_SalesLineFrom: Record "37";pdc_TransferQuantity: Decimal)
    //     var
    //         lrc_SalesHeaderFrom: Record "36";
    //         lrc_SalesHeaderTo: Record "36";
    //         lrc_SalesLineTo: Record "37";
    //         lrc_SalesCommentLineFrom: Record "44";
    //         lrc_SalesCommentLineTo: Record "44";
    //         lrc_DocumentDimensionFrom: Record "357";
    //         lrc_DocumentDimensionTo: Record "357";
    //         lrc_SalesDiscountFrom: Record "5110344";
    //         lrc_SalesDiscountTo: Record "5110344";
    //         lrc_OutgoingPalletFrom: Record "5110502";
    //         lrc_OutgoingPalletTo: Record "5110502";
    //         lrc_BatchVariantDetail: Record "5110487";
    //         lco_DocumentNo: Code[20];
    //         lrc_SalesCommentFrom: Record "5110427";
    //         lrc_SalesCommentTo: Record "5110427";
    //         lrc_SalesCommentPrintDocFrom: Record "5110428";
    //         lrc_SalesCommentPrintDocTo: Record "5110428";
    //         lin_EntryNo: Integer;
    //         lrc_PalletManagement: Codeunit "5110346";
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lrc_ServiceCustomer: Record "Customer";
    //         lrc_SalesHeaderToDocumentNo: Code[20];
    //         lin_SplittLineNo: Integer;
    //         lrc_SalesLineNext: Record "37";
    //         lco_SalesDocSubtypeCode: Code[10];
    //         lcu_ReleaseSalesDocument: Codeunit "414";
    //         lrc_CustomerGroup: Record "5110398";
    //         lcu_SalesMgt: Codeunit "5110324";
    //         AgilesText001: Label 'Warnung! The Quantity %1 will be available in Sales Matrix. Continue?';
    //         AgilesText002: Label 'The update has been interrupted to respect the warning.';
    //         AgilesText003: Label 'You are trying to transfer the quantity %1 back to %2 %3. Continue?';
    //         AgilesText004: Label 'Warnung! Source Order does not exists. The Quantity %1 will be available in Sales Matrix. Continue?';
    //         lrc_SalesShipmentBuffer: Record "7190";
    //         lin_Selection: Integer;
    //         AgilesText005: Label '&Menge zurückführen,Menge &freigeben,&Abbrechen';
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------
    //         // Mengenrückführung von Splittzeilen
    //         // ------------------------------------------------------------------------------------------------------------

    //         IF pdc_TransferQuantity <= 0 THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_SalesHeaderFrom.GET(vrc_SalesLineFrom."Document Type",vrc_SalesLineFrom."Document No.");

    //         IF vrc_SalesLineFrom."Source No. Split Line" <> '' THEN BEGIN
    //           IF lrc_SalesHeaderTo.GET(vrc_SalesLineFrom."Source Type Split Line",vrc_SalesLineFrom."Source No. Split Line") THEN BEGIN

    //             // Rückführung der Menge
    //             // Ursprungszeile holen. Wenn keine Zeile mehr vorhanden ist, muss eine neue gebildet werden
    //             IF lrc_SalesLineTo.GET(vrc_SalesLineFrom."Source Type Split Line",vrc_SalesLineFrom."Source No. Split Line",
    //                                    vrc_SalesLineFrom."Source Line No. Split Line") THEN BEGIN

    //               // Ursprungszeile vorhanden
    //               // Status des Beleges ggfls. auf offen setzen
    //               IF lrc_SalesHeaderTo.Status = lrc_SalesHeaderTo.Status::Released THEN BEGIN
    //                 lcu_ReleaseSalesDocument.Reopen(lrc_SalesHeaderTo);
    //               END;

    //               // Variante prüfen
    //               vrc_SalesLineFrom.TESTFIELD("Batch Variant No.",lrc_SalesLineTo."Batch Variant No.");

    //               // Einheit prüfen
    //               vrc_SalesLineFrom.TESTFIELD("Unit of Measure Code",lrc_SalesLineTo."Unit of Measure Code");

    //               // Menge aktualisieren
    //               vrc_SalesLineFrom.VALIDATE(Quantity,vrc_SalesLineFrom.Quantity - pdc_TransferQuantity);

    //               // Menge Verpackungen aktualisieren
    //               vrc_SalesLineFrom."Quantity (PU)" := vrc_SalesLineFrom.Quantity * vrc_SalesLineFrom."Qty. (PU) per Unit of Measure";

    //               // Menge Paletten aktualisieren
    //               IF vrc_SalesLineFrom."Qty. (Unit) per Transp.(TU)" <> 0 THEN BEGIN
    //                 vrc_SalesLineFrom."Quantity (TU)" := vrc_SalesLineFrom.Quantity / vrc_SalesLineFrom."Qty. (Unit) per Transp.(TU)"
    //               END ELSE BEGIN
    //                 vrc_SalesLineFrom."Quantity (TU)" := 0;
    //               END;

    //               vrc_SalesLineFrom.MODIFY(TRUE);


    //               // Menge zurückübertragen
    //               lrc_SalesLineTo.VALIDATE(Quantity,lrc_SalesLineTo.Quantity + pdc_TransferQuantity);

    //               // Menge Verpackungen aktualisieren
    //               lrc_SalesLineTo."Quantity (PU)" := lrc_SalesLineTo.Quantity * lrc_SalesLineTo."Qty. (PU) per Unit of Measure";

    //               // Menge Paletten aktualisieren
    //               IF lrc_SalesLineTo."Qty. (Unit) per Transp.(TU)" <> 0 THEN BEGIN
    //                 lrc_SalesLineTo."Quantity (TU)" := lrc_SalesLineTo.Quantity / lrc_SalesLineTo."Qty. (Unit) per Transp.(TU)"
    //               END ELSE BEGIN
    //                 lrc_SalesLineTo."Quantity (TU)" := 0;
    //               END;

    //               lrc_SalesLineTo.MODIFY(TRUE);


    //               COMMIT;
    //               // Alten Beleg kalkulieren
    //               CalcSalesOrder(lrc_SalesHeaderFrom);

    //               // Neuen Beleg kalkulieren
    //               CalcSalesOrder(lrc_SalesHeaderTo);

    //             END ELSE BEGIN

    //               // Ursprungszeile NICHT vorhanden (Neue Zeile bilden)
    //               lrc_SalesShipmentBuffer.DELETEALL();
    //               lrc_SalesShipmentBuffer.INIT();
    //               lrc_SalesShipmentBuffer."Document No." := vrc_SalesLineFrom."Document No.";
    //               lrc_SalesShipmentBuffer."Line No." := vrc_SalesLineFrom."Line No.";
    //               lrc_SalesShipmentBuffer."Entry No." := 1;
    //               lrc_SalesShipmentBuffer.Quantity := pdc_TransferQuantity;
    //               lrc_SalesShipmentBuffer.insert();
    //               lrc_SalesHeaderFrom.GET(vrc_SalesLineFrom."Document Type",vrc_SalesLineFrom."Document No.");

    //               MoveSalesLinesToDocument(lrc_SalesHeaderFrom,lrc_SalesShipmentBuffer,lrc_SalesHeaderTo,FALSE,FALSE,TRUE);

    //             END;
    //           END;
    //         END;
    //     end;

    //     procedure MoveSalesLinesToPredefDocument(var vrc_SalesLineFrom: Record "37";var vrc_SalesHeaderTo: Record "36";var vrc_SalesLineTo: Record "37";pdc_TransferQuantity: Decimal)
    //     var
    //         lrc_SalesHeaderFrom: Record "36";
    //         lrc_SalesHeaderTo: Record "36";
    //         lrc_SalesLineTo: Record "37";
    //         lrc_SalesCommentLineFrom: Record "44";
    //         lrc_SalesCommentLineTo: Record "44";
    //         lrc_DocumentDimensionFrom: Record "357";
    //         lrc_DocumentDimensionTo: Record "357";
    //         lrc_SalesDiscountFrom: Record "5110344";
    //         lrc_SalesDiscountTo: Record "5110344";
    //         lrc_OutgoingPalletFrom: Record "5110502";
    //         lrc_OutgoingPalletTo: Record "5110502";
    //         lrc_BatchVariantDetail: Record "5110487";
    //         lco_DocumentNo: Code[20];
    //         lrc_SalesCommentFrom: Record "5110427";
    //         lrc_SalesCommentTo: Record "5110427";
    //         lrc_SalesCommentPrintDocFrom: Record "5110428";
    //         lrc_SalesCommentPrintDocTo: Record "5110428";
    //         lin_EntryNo: Integer;
    //         lrc_PalletManagement: Codeunit "5110346";
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lrc_ServiceCustomer: Record "Customer";
    //         lrc_SalesHeaderToDocumentNo: Code[20];
    //         lin_SplittLineNo: Integer;
    //         lrc_SalesLineNext: Record "37";
    //         lco_SalesDocSubtypeCode: Code[10];
    //         lcu_ReleaseSalesDocument: Codeunit "414";
    //         lrc_CustomerGroup: Record "5110398";
    //         lcu_SalesMgt: Codeunit "5110324";
    //         AgilesText001: Label 'Warnung! The Quantity %1 will be available in Sales Matrix. Continue?';
    //         AgilesText002: Label 'The update has been interrupted to respect the warning.';
    //         AgilesText003: Label 'You are trying to transfer the quantity %1 back to %2 %3. Continue?';
    //         AgilesText004: Label 'Warnung! Source Order does not exists. The Quantity %1 will be available in Sales Matrix. Continue?';
    //         lrc_SalesShipmentBuffer: Record "7190";
    //         lin_Selection: Integer;
    //         AgilesText005: Label '&Menge zurückführen,Menge &freigeben,&Abbrechen';
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------
    //         // Mengen in Aufträge verschieben
    //         // ------------------------------------------------------------------------------------------------------------

    //         IF pdc_TransferQuantity <= 0 THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_SalesHeaderFrom.GET(vrc_SalesLineFrom."Document Type",vrc_SalesLineFrom."Document No.");

    //         IF lrc_SalesHeaderTo.GET(vrc_SalesHeaderTo."Document Type",vrc_SalesHeaderTo."No.") THEN BEGIN

    //           // Umsetzen der Menge
    //           // Zielzeile holen. Wenn keine Zeile mehr vorhanden ist, muss eine neue gebildet werden
    //           IF lrc_SalesLineTo.GET(vrc_SalesLineTo."Document Type",vrc_SalesLineTo."Document No.",
    //                                  vrc_SalesLineTo."Line No.") THEN BEGIN

    //             // Zielzeile vorhanden
    //             // Status des Beleges ggfls. auf offen setzen
    //             IF lrc_SalesHeaderTo.Status = lrc_SalesHeaderTo.Status::Released THEN BEGIN
    //               lcu_ReleaseSalesDocument.Reopen(lrc_SalesHeaderTo);
    //             END;

    //             // Variante prüfen
    //             vrc_SalesLineFrom.TESTFIELD("Batch Variant No.",lrc_SalesLineTo."Batch Variant No.");

    //             // Einheit prüfen
    //             vrc_SalesLineFrom.TESTFIELD("Unit of Measure Code",lrc_SalesLineTo."Unit of Measure Code");

    //             // Menge aktualisieren
    //             vrc_SalesLineFrom.VALIDATE(Quantity,vrc_SalesLineFrom.Quantity - pdc_TransferQuantity);

    //             // Menge Verpackungen aktualisieren
    //             vrc_SalesLineFrom."Quantity (PU)" := vrc_SalesLineFrom.Quantity * vrc_SalesLineFrom."Qty. (PU) per Unit of Measure";

    //             // Menge Paletten aktualisieren
    //             IF vrc_SalesLineFrom."Qty. (Unit) per Transp.(TU)" <> 0 THEN BEGIN
    //               vrc_SalesLineFrom."Quantity (TU)" := vrc_SalesLineFrom.Quantity / vrc_SalesLineFrom."Qty. (Unit) per Transp.(TU)"
    //             END ELSE BEGIN
    //               vrc_SalesLineFrom."Quantity (TU)" := 0;
    //             END;

    //             vrc_SalesLineFrom.MODIFY(TRUE);


    //             // Menge übertragen
    //             lrc_SalesLineTo.VALIDATE(Quantity,lrc_SalesLineTo.Quantity + pdc_TransferQuantity);

    //             // Menge Verpackungen aktualisieren
    //             lrc_SalesLineTo."Quantity (PU)" := lrc_SalesLineTo.Quantity * lrc_SalesLineTo."Qty. (PU) per Unit of Measure";

    //             // Menge Paletten aktualisieren
    //             IF lrc_SalesLineTo."Qty. (Unit) per Transp.(TU)" <> 0 THEN BEGIN
    //               lrc_SalesLineTo."Quantity (TU)" := lrc_SalesLineTo.Quantity / lrc_SalesLineTo."Qty. (Unit) per Transp.(TU)"
    //             END ELSE BEGIN
    //               lrc_SalesLineTo."Quantity (TU)" := 0;
    //             END;

    //             lrc_SalesLineTo.MODIFY(TRUE);


    //             COMMIT;
    //             // Alten Beleg kalkulieren
    //             CalcSalesOrder(lrc_SalesHeaderFrom);

    //             // Neuen Beleg kalkulieren
    //             CalcSalesOrder(lrc_SalesHeaderTo);

    //           END ELSE BEGIN

    //             // Zeilezeile NICHT vorhanden (Neue Zeile bilden)
    //             lrc_SalesShipmentBuffer.DELETEALL();
    //             lrc_SalesShipmentBuffer.INIT();
    //             lrc_SalesShipmentBuffer."Document No." := vrc_SalesLineFrom."Document No.";
    //             lrc_SalesShipmentBuffer."Line No." := vrc_SalesLineFrom."Line No.";
    //             lrc_SalesShipmentBuffer."Entry No." := 1;
    //             lrc_SalesShipmentBuffer.Quantity := pdc_TransferQuantity;
    //             lrc_SalesShipmentBuffer.insert();
    //             lrc_SalesHeaderFrom.GET(vrc_SalesLineFrom."Document Type",vrc_SalesLineFrom."Document No.");

    //             MoveSalesLinesToDocument(lrc_SalesHeaderFrom,lrc_SalesShipmentBuffer,lrc_SalesHeaderTo,FALSE,FALSE,TRUE);

    //           END;
    //         END;
    //     end;

    //     procedure CalcGlobalInfoFields(var rrc_SalesHeader: Record "36")
    //     var
    //         lcu_PositionPlanning: Codeunit "5110345";
    //         lrc_SalesLine: Record "37";
    //         lrc_MasterBatch: Record "5110364";
    //         lco_LastMasterBatchNo: Code[20];
    //         lin_Count: Integer;
    //         lrcSalesDocSubtype: Record "5110411";
    //         ldt_DeliveryDate: Date;
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------------------------------

    //         // Werte entfernen
    //         rrc_SalesHeader."Calendar Week (P.D. Date)" := '';
    //         rrc_SalesHeader."Means of Transport (Source)" := '';
    //         // IFW 004 IFW40125.s
    //         rrc_SalesHeader."CW (Inv. Date of Delivery)" := '';
    //         // IFW 004 IFW40125.e

    //         // KW
    //         // IFW 001 00000000.s
    //         IF rrc_SalesHeader."Disposition For Week" <> '' THEN BEGIN
    //           rrc_SalesHeader."Calendar Week (P.D. Date)" := rrc_SalesHeader."Disposition For Week";
    //         END ELSE BEGIN
    //           IF lrcSalesDocSubtype.GET(rrc_SalesHeader."Document Type", rrc_SalesHeader."Sales Doc. Subtype Code") THEN BEGIN
    //             ldt_DeliveryDate := CALCDATE(lrcSalesDocSubtype."Calendar Week",rrc_SalesHeader."Promised Delivery Date");
    //           END ELSE BEGIN
    //             ldt_DeliveryDate := rrc_SalesHeader."Promised Delivery Date";
    //           END;
    //           rrc_SalesHeader."Calendar Week (P.D. Date)" :=
    //               lcu_PositionPlanning.GeneratePlanningWeek(ldt_DeliveryDate,'');
    //         END;
    //         // IFW 001 00000000.s

    //         // IFW 004 IFW40125.s
    //         rrc_SalesHeader."CW (Inv. Date of Delivery)" := rrc_SalesHeader."Calendar Week (P.D. Date)";
    //         IF rrc_SalesHeader."Invoice Date of Delivery" <> 0D THEN BEGIN
    //           rrc_SalesHeader."CW (Inv. Date of Delivery)" :=
    //              lcu_PositionPlanning.GeneratePlanningWeek(rrc_SalesHeader."Invoice Date of Delivery",'');
    //         END;
    //         // IFW 004 IFW40125.e
    //         // Partienr. und Schiffsname
    //         lco_LastMasterBatchNo := '';
    //         lin_Count := 0;

    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETCURRENTKEY("Master Batch No.","Batch No.");
    //         lrc_SalesLine.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",rrc_SalesHeader."No.");
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN

    //           REPEAT
    //             IF lco_LastMasterBatchNo <> lrc_SalesLine."Master Batch No." THEN BEGIN

    //               lin_Count := lin_Count + 1;
    //               lco_LastMasterBatchNo := lrc_SalesLine."Master Batch No.";
    //               IF lrc_MasterBatch.GET(lco_LastMasterBatchNo) THEN BEGIN
    //               /*
    //                 // Info füllen
    //                 rrc_SalesHeader."Search Field Master Batch No." :=
    //                                 COPYSTR(rrc_SalesHeader."Search Field Master Batch No." + ' ' + lco_LastMasterBatchNo,1,50);
    //                 rrc_SalesHeader."Means of Transport (Source)" :=
    //                                 COPYSTR(rrc_SalesHeader."Means of Transport (Source)" + ' ' +
    //                                         lrc_MasterBatch."Means of Transp. Code (Arriva)",1,50);
    //               */
    //               END;

    //             END;
    //           UNTIL lrc_SalesLine.NEXT() = 0;

    //           // Anfangsleerzeichen entfernen
    //           // rrc_SalesHeader."Search Field Master Batch No." := COPYSTR(rrc_SalesHeader."Search Field Master Batch No.",1);
    //           // rrc_SalesHeader."Means of Transport (Source)" := COPYSTR(rrc_SalesHeader."Means of Transport (Source)",1);

    //         END;

    //     end;

    //     procedure ShowSalesLineResult(vop_SalesDocType: Option "0","1","2","3","4","5","6","7","8","9";vco_SalesDocNo: Code[20];vin_SalesDocLineNo: Integer)
    //     var
    //         lfm_SalesLineResult: Form "5088134";
    //     begin
    //         // -----------------------------------------------------------------------------------------------------------
    //         // Funktion zur Darstellung des Ergebnisses einer Verkaufszeile
    //         // -----------------------------------------------------------------------------------------------------------

    //         //xx lfm_SalesLineResult.Fct_OnAfterGetRec(vop_SalesDocType,vco_SalesDocNo,vin_SalesDocLineNo);
    //         //xx lfm_SalesLineResult.RUNMODAL;
    //     end;

    //     procedure "-- VKR 001 IFW40196 F"()
    //     begin
    //     end;

    //     procedure ItemChargeSingleAssignment(var rrc_SalesLine: Record "37")
    //     var
    //         lrc_ItemChargeAssignmentSales: Record "5809";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_SalesShipmentLine: Record "111";
    //     begin
    //         // VKR 001 IFW40196.s
    //         // -----------------------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der Werte für Zu/Abschläge bei einer Zuweisung
    //         // -----------------------------------------------------------------------------------------------------------

    //         // Nur weitermachen, wenn es ein Zu- und Abschlag ist
    //         IF (rrc_SalesLine.Type <> rrc_SalesLine.Type::"Charge (Item)") THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_ItemChargeAssignmentSales.RESET();

    //         lrc_ItemChargeAssignmentSales.SETRANGE("Document Type", rrc_SalesLine."Document Type");
    //         lrc_ItemChargeAssignmentSales.SETRANGE("Document No.", rrc_SalesLine."Document No.");
    //         lrc_ItemChargeAssignmentSales.SETRANGE("Document Line No.", rrc_SalesLine."Line No.");

    //         IF lrc_ItemChargeAssignmentSales.COUNT() = 1 THEN BEGIN
    //           IF lrc_ItemChargeAssignmentSales.FINDFIRST() THEN BEGIN
    //             IF lrc_BatchVariant.GET(lrc_ItemChargeAssignmentSales."Batch Variant No.") THEN BEGIN
    //               rrc_SalesLine."Item Charge Assignment" := rrc_SalesLine."Item Charge Assignment"::"Eins zu Eins";
    //               rrc_SalesLine."Item Category Code" :=  lrc_BatchVariant."Item Category Code";
    //               rrc_SalesLine."Product Group Code" :=  lrc_BatchVariant."Product Group Code";
    //               rrc_SalesLine."Trademark Code" :=  lrc_BatchVariant."Trademark Code";
    //               rrc_SalesLine."Status Customs Duty" :=  lrc_BatchVariant."Status Customs Duty";
    //             END;
    //             IF lrc_ItemChargeAssignmentSales."Applies-to Doc. Type" =
    //                lrc_ItemChargeAssignmentSales."Applies-to Doc. Type"::Shipment THEN BEGIN
    //               IF lrc_SalesShipmentLine.GET(lrc_ItemChargeAssignmentSales."Applies-to Doc. No.",
    //                                            lrc_ItemChargeAssignmentSales."Applies-to Doc. Line No.") THEN BEGIN
    //                 rrc_SalesLine."Location Code" :=  lrc_SalesShipmentLine."Location Code";
    //               END;
    //             END;
    //           END;
    //         END ELSE BEGIN
    //           rrc_SalesLine."Item Charge Assignment" := rrc_SalesLine."Item Charge Assignment"::" ";
    //         END;
    //         // VKR 001 IFW40196.e
    //     end;
}

