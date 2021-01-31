codeunit 5110307 "POI BAM Batch Management"
{
    //        Permissions = TableData 32=rm,
    //                   TableData 111=rm,
    //                   TableData 113=rm,
    //                   TableData 115=rm,
    //                   TableData 5802=rm;

    var
        lrc_MasterBatch: Record "POI Master Batch";
        lrc_DimensionValue: Record "Dimension Value";
        lrc_PurchaseLine: Record "Purchase line";
        Batch: Record "POI Batch";
        lrc_Batch: Record "POI Batch";
        lrc_SalesShipmentLine: Record "Sales Shipment Line";
        lrc_BatchTempNew: Record "POI Batch" temporary;
        lrc_CostCategory: Record "POI Cost Category";
        lrc_CostCategoryAccounts: Record "POI Cost Category Accounts";
        lrc_GLEntry: Record "G/L Entry";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_BatchSourceInfo: Record "POI Batch Info Details";
        lrc_PurchLine: Record "Purchase Line";
        lrc_BatchTemp: Record "POI Batch Temp";
        lrc_MasterBatchTemp: Record "POI Batch Temp";
        lrc_ItemTransportUnitFaktor: Record "POI Factor Transport Unit";
        lrc_ItemLedgerEntry: Record "Item Ledger Entry";
        lrc_Item: Record Item;


    procedure MasterBatchNewFromPurchHdr(vrc_PurchaseHeader: Record "Purchase Header"; var rrc_MasterBatchCodeReturn: Code[20])
    var
        lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
        ADF_LT_TEXT001Txt: Label 'Die Vergabe der Partienummer ist fehlgeschlagen!';
        MasterBatchCode: Code[20];
        ErrorLabel: Text;
        //ADF_LT_TEXT002Txt: Label 'Vergabe Positionsnr. fehlgeschlagen!';
        ADF_LT_TEXT003Txt: Label 'Allocation for future use';
        ADF_LT_TEXT004Txt: Label 'Allocation unkown';

    begin
        // ---------------------------------------------------------------
        // Anlage einer neuen Partie über dem Einkaufskopf
        // ---------------------------------------------------------------
        // Parameter:
        // PurchaseHeader
        // MasterBatchCodeReturn (Rückgabewert)
        // BatchCodeReturn (Rückgabewert)
        // ---------------------------------------------------------------

        // Vergabe Partienummer gilt per Definition nur für Bestellungen
        IF (vrc_PurchaseHeader."Document Type" <> vrc_PurchaseHeader."Document Type"::Order) OR
           (vrc_PurchaseHeader."POI Purch. Doc. Subtype Code" = '') THEN
            EXIT;

        // Kontrolle ob eine Partienummer bereits vorhanden ist
        IF vrc_PurchaseHeader."POI Master Batch No." <> '' THEN BEGIN
            rrc_MasterBatchCodeReturn := vrc_PurchaseHeader."POI Master Batch No.";
            EXIT;
        END;

        // Einkaufsbelegart lesen
        lrc_PurchDocSubtype.GET(vrc_PurchaseHeader."Document Type", vrc_PurchaseHeader."POI Purch. Doc. Subtype Code");

        // Kontrolle ob Partiewesen für die Belegart aktiv ist
        IF lrc_PurchDocSubtype."Batchsystem activ" = FALSE THEN BEGIN
            rrc_MasterBatchCodeReturn := '';
            EXIT;
        END;

        // --------------------------------------------------------------------------
        // Vergabe über Einkaufsbelegart
        // --------------------------------------------------------------------------

        // Master Batch Code vergeben
        CASE lrc_PurchDocSubtype."Source Master Batch" OF
            lrc_PurchDocSubtype."Source Master Batch"::"No. Series":
                BEGIN
                    lrc_PurchDocSubtype.TESTFIELD("Master Batch No. Series");
                    MasterBatchCode := lcu_NoSeriesManagement.GetNextNo(lrc_PurchDocSubtype."Master Batch No. Series", WORKDATE(), TRUE);
                END;
            lrc_PurchDocSubtype."Source Master Batch"::"Purchase Order No.":
                BEGIN
                    vrc_PurchaseHeader.TESTFIELD("No.");
                    MasterBatchCode := vrc_PurchaseHeader."No.";
                END;
            lrc_PurchDocSubtype."Source Master Batch"::Manuel:
                BEGIN
                    rrc_MasterBatchCodeReturn := '';
                    EXIT;
                END;
            lrc_PurchDocSubtype."Source Master Batch"::Vendor:
                begin
                    // Zuordnung für zukünftigen Gebrauch
                    ErrorLabel := ADF_LT_TEXT003Txt + ' ' + FORMAT(lrc_PurchDocSubtype."Source Master Batch");
                    ERROR(ErrorLabel);
                end;
            ELSE begin
                    // Zuordnung unbekannt
                    ErrorLabel := ADF_LT_TEXT004Txt + ' ' + FORMAT(lrc_PurchDocSubtype."Source Master Batch");
                    ERROR(ErrorLabel);
                end;
        END;

        IF MasterBatchCode = '' THEN
            // Die Vergabe der Partienummer ist fehlgeschlagen!
            ERROR(ADF_LT_TEXT001Txt);


        // ---------------------------------------------------------------------------
        // Datensatz Master Batch (Partie) anlegen
        // ---------------------------------------------------------------------------
        lrc_MasterBatch.RESET();
        lrc_MasterBatch.INIT();
        lrc_MasterBatch."No." := MasterBatchCode;
        lrc_MasterBatch.VALIDATE("Vendor No.", vrc_PurchaseHeader."Buy-from Vendor No.");
        lrc_MasterBatch."Producer No." := vrc_PurchaseHeader."POI Manufacturer Code";
        lrc_MasterBatch.Source := lrc_MasterBatch.Source::"Purch. Order";
        lrc_MasterBatch."Source No." := vrc_PurchaseHeader."No.";
        lrc_MasterBatch."Purchaser Code" := vrc_PurchaseHeader."Purchaser Code";
        lrc_MasterBatch."Person in Charge Code" := vrc_PurchaseHeader."POI Person in Charge Code";
        lrc_MasterBatch."Currency Code" := vrc_PurchaseHeader."Currency Code";
        lrc_MasterBatch."Currency Factor" := vrc_PurchaseHeader."Currency Factor";
        lrc_MasterBatch."Cost Schema Name Code" := vrc_PurchaseHeader."POI Cost Schema Name Code";
        lrc_MasterBatch."Purch. Doc. Subtype Code" := vrc_PurchaseHeader."POI Purch. Doc. Subtype Code";
        lrc_MasterBatch."Order Type" := vrc_PurchaseHeader."POI Order Type";
        lrc_MasterBatch."Your Reference" := vrc_PurchaseHeader."Your Reference";
        lrc_MasterBatch."Vendor Order No." := vrc_PurchaseHeader."Vendor Order No.";
        lrc_MasterBatch."Receipt Info" := vrc_PurchaseHeader."POI Receipt Info";
        lrc_MasterBatch."Location Code" := vrc_PurchaseHeader."Location Code";
        lrc_MasterBatch."Location Reference No." := vrc_PurchaseHeader."POI Location Reference No.";
        lrc_MasterBatch."Kind of Settlement" := vrc_PurchaseHeader."POI Kind of Settlement";
        lrc_MasterBatch."Waste Disposal Duty" := vrc_PurchaseHeader."POI Waste Disposal Duty";
        lrc_MasterBatch."Waste Disposal Payment Thru" := vrc_PurchaseHeader."POI Waste Disposal Paymt Thru";
        lrc_MasterBatch."Shipment Method Code" := vrc_PurchaseHeader."Shipment Method Code";
        lrc_MasterBatch."Status Customs Duty" := vrc_PurchaseHeader."POI Status Customs Duty";
        lrc_MasterBatch."Fiscal Agent Code" := vrc_PurchaseHeader."POI Fiscal Agent Code";
        lrc_MasterBatch."Shipping Agent Code" := vrc_PurchaseHeader."POI Shipping Agent Code";
        lrc_MasterBatch."Voyage No." := vrc_PurchaseHeader."POI Voyage No.";
        lrc_MasterBatch."Means of Transport Type" := vrc_PurchaseHeader."POI Means of Transport Type";
        lrc_MasterBatch."Means of Transp. Code (Arriva)" := vrc_PurchaseHeader."POI Means of TransCode(Arriva)";
        lrc_MasterBatch."Means of Transp. Code (Depart)" := vrc_PurchaseHeader."POI Means of Transp.Code(Dep.)";
        lrc_MasterBatch."Means of Transport Info" := vrc_PurchaseHeader."POI Means of Transport Info";
        lrc_MasterBatch."Kind of Loading" := vrc_PurchaseHeader."POI Kind of Loading";
        lrc_MasterBatch."Departure Region Code" := vrc_PurchaseHeader."POI Departure Region Code";
        lrc_MasterBatch."Port of Discharge Code (UDE)" := vrc_PurchaseHeader."POI Port of Disch. Code (UDE)";
        lrc_MasterBatch."Date of Discharge" := vrc_PurchaseHeader."POI Expected Discharge Date";
        lrc_MasterBatch."Time of Discharge" := vrc_PurchaseHeader."POI Expected Discharge Time";
        lrc_MasterBatch."Departure Date" := vrc_PurchaseHeader."POI Departure Date";
        lrc_MasterBatch."Expected Receipt Date" := vrc_PurchaseHeader."Expected Receipt Date";
        lrc_MasterBatch."Expected Receipt Time" := vrc_PurchaseHeader."POI Expected Receipt Time";
        lrc_MasterBatch."Container Code" := vrc_PurchaseHeader."POI Container No.";
        lrc_MasterBatch."Quality Control Vendor No." := vrc_PurchaseHeader."POI Quality Control Vendor No.";
        lrc_MasterBatch."Company Season Code" := vrc_PurchaseHeader."POI Company Season Code";
        lrc_MasterBatch."Country of Origin Code" := vrc_PurchaseHeader."POI Country of Origin Code";
        lrc_MasterBatch."Entry Date" := TODAY();
        lrc_MasterBatch."Shortcut Dimension 1 Code" := vrc_PurchaseHeader."Shortcut Dimension 1 Code";
        lrc_MasterBatch."Shortcut Dimension 2 Code" := vrc_PurchaseHeader."Shortcut Dimension 2 Code";
        lrc_MasterBatch."Shortcut Dimension 3 Code" := vrc_PurchaseHeader."POI Shortcut Dimension 3 Code";
        lrc_MasterBatch."Shortcut Dimension 4 Code" := vrc_PurchaseHeader."POI Shortcut Dimension 4 Code";
        lrc_MasterBatch."Departure Location Code" := vrc_PurchaseHeader."POI Departure Location Code";
        lrc_MasterBatch.INSERT();

        //RS Anlage Partie als Dimension
        lrc_DimensionValue.SETRANGE("Dimension Code", 'PARTIE');
        lrc_DimensionValue.SETRANGE(Code, MasterBatchCode);
        IF NOT lrc_DimensionValue.FINDSET(FALSE, FALSE) THEN BEGIN
            lrc_DimensionValue.INIT();
            lrc_DimensionValue."Dimension Code" := 'PARTIE';
            lrc_DimensionValue.Code := MasterBatchCode;
            lrc_DimensionValue.Name := MasterBatchCode;
            lrc_DimensionValue.INSERT();
        END;


        // Rückgabewerte setzen
        rrc_MasterBatchCodeReturn := lrc_MasterBatch."No.";
    end;

    procedure MasterBatchUpdFromPurchHdr(vrc_PurchaseHeader: Record "Purchase Header")
    begin
        // ----------------------------------------------------------------------------
        // Aktualisierung einer vorhandenen Partienr.
        // ----------------------------------------------------------------------------

        // Vergabe Partienummer gilt per Definition nur für Bestellungen
        IF vrc_PurchaseHeader."Document Type" <> vrc_PurchaseHeader."Document Type"::Order THEN
            EXIT;
        // Kontrolle ob eine Partienummer vorhanden ist
        IF vrc_PurchaseHeader."POI Master Batch No." = '' THEN
            EXIT;

        // Master Batch (Partie) lesen
        lrc_MasterBatch.GET(vrc_PurchaseHeader."POI Master Batch No.");

        // Master Batch (Partie) aktualisieren
        lrc_MasterBatch.VALIDATE("Vendor No.", vrc_PurchaseHeader."Buy-from Vendor No.");
        lrc_MasterBatch."Producer No." := vrc_PurchaseHeader."POI Manufacturer Code";
        lrc_MasterBatch.Source := lrc_MasterBatch.Source::"Purch. Order";
        lrc_MasterBatch."Source No." := vrc_PurchaseHeader."No.";
        lrc_MasterBatch."Purchaser Code" := vrc_PurchaseHeader."Purchaser Code";
        lrc_MasterBatch."Person in Charge Code" := vrc_PurchaseHeader."POI Person in Charge Code";
        lrc_MasterBatch."Currency Code" := vrc_PurchaseHeader."Currency Code";
        lrc_MasterBatch."Currency Factor" := vrc_PurchaseHeader."Currency Factor";
        lrc_MasterBatch."Cost Schema Name Code" := vrc_PurchaseHeader."POI Cost Schema Name Code";
        lrc_MasterBatch."Purch. Doc. Subtype Code" := vrc_PurchaseHeader."POI Purch. Doc. Subtype Code";
        lrc_MasterBatch."Order Type" := vrc_PurchaseHeader."POI Order Type";
        lrc_MasterBatch."Your Reference" := vrc_PurchaseHeader."Your Reference";
        lrc_MasterBatch."Vendor Order No." := vrc_PurchaseHeader."Vendor Order No.";
        lrc_MasterBatch."Receipt Info" := vrc_PurchaseHeader."POI Receipt Info";
        lrc_MasterBatch."Location Code" := vrc_PurchaseHeader."Location Code";
        lrc_MasterBatch."Location Reference No." := vrc_PurchaseHeader."POI Location Reference No.";
        lrc_MasterBatch."Kind of Settlement" := vrc_PurchaseHeader."POI Kind of Settlement";
        lrc_MasterBatch."Waste Disposal Duty" := vrc_PurchaseHeader."POI Waste Disposal Duty";
        lrc_MasterBatch."Waste Disposal Payment Thru" := vrc_PurchaseHeader."POI Waste Disposal Paymt Thru";
        lrc_MasterBatch."Shipment Method Code" := vrc_PurchaseHeader."Shipment Method Code";
        lrc_MasterBatch."Status Customs Duty" := vrc_PurchaseHeader."POI Status Customs Duty";
        lrc_MasterBatch."Fiscal Agent Code" := vrc_PurchaseHeader."POI Fiscal Agent Code";
        lrc_MasterBatch."Shipping Agent Code" := vrc_PurchaseHeader."POI Shipping Agent Code";
        lrc_MasterBatch."Voyage No." := vrc_PurchaseHeader."POI Voyage No.";
        lrc_MasterBatch."Means of Transport Type" := vrc_PurchaseHeader."POI Means of Transport Type";
        lrc_MasterBatch."Means of Transp. Code (Arriva)" := vrc_PurchaseHeader."POI Means of TransCode(Arriva)";
        lrc_MasterBatch."Means of Transp. Code (Depart)" := vrc_PurchaseHeader."POI Means of Transp.Code(Dep.)";
        lrc_MasterBatch."Means of Transport Info" := vrc_PurchaseHeader."POI Means of Transport Info";
        lrc_MasterBatch."Kind of Loading" := vrc_PurchaseHeader."POI Kind of Loading";
        lrc_MasterBatch."Departure Region Code" := vrc_PurchaseHeader."POI Departure Region Code";
        lrc_MasterBatch."Port of Discharge Code (UDE)" := vrc_PurchaseHeader."POI Port of Disch. Code (UDE)";
        lrc_MasterBatch."Date of Discharge" := vrc_PurchaseHeader."POI Expected Discharge Date";
        lrc_MasterBatch."Time of Discharge" := vrc_PurchaseHeader."POI Expected Discharge Time";
        lrc_MasterBatch."Departure Date" := vrc_PurchaseHeader."POI Departure Date";
        lrc_MasterBatch."Expected Receipt Date" := vrc_PurchaseHeader."Expected Receipt Date";
        lrc_MasterBatch."Expected Receipt Time" := vrc_PurchaseHeader."POI Expected Receipt Time";
        lrc_MasterBatch."Container Code" := vrc_PurchaseHeader."POI Container No.";
        lrc_MasterBatch."Quality Control Vendor No." := vrc_PurchaseHeader."POI Quality Control Vendor No.";
        lrc_MasterBatch."Company Season Code" := vrc_PurchaseHeader."POI Company Season Code";
        lrc_MasterBatch."Country of Origin Code" := vrc_PurchaseHeader."POI Country of Origin Code";
        lrc_MasterBatch."Shortcut Dimension 1 Code" := vrc_PurchaseHeader."Shortcut Dimension 1 Code";
        lrc_MasterBatch."Shortcut Dimension 2 Code" := vrc_PurchaseHeader."Shortcut Dimension 2 Code";
        lrc_MasterBatch."Shortcut Dimension 3 Code" := vrc_PurchaseHeader."POI Shortcut Dimension 3 Code";
        lrc_MasterBatch."Shortcut Dimension 4 Code" := vrc_PurchaseHeader."POI Shortcut Dimension 4 Code";
        lrc_MasterBatch."Departure Location Code" := vrc_PurchaseHeader."POI Departure Location Code";
        lrc_MasterBatch.MODIFY();
    end;

    //     procedure MasterBatchUpdAllFromPurchHdr()
    //     var
    //         lrc_PurchHeader: Record "38";
    //         ldg_Window: Dialog;
    //         ADF_LT_TEXT001: Label 'Möchten Sie alle Partien mit Herkunft Einkauf auf Basis der Bestellungen aktualisieren?';
    //         ADF_LT_TEXT002: Label 'Purch. Order';
    //     begin
    //         // ----------------------------------------------------------------------------
    //         // Funktion zur Aktualisierung aller Partien über den Einkaufskopf
    //         // ----------------------------------------------------------------------------

    //         // Möchten Sie alle Partien mit Herkunft Einkauf auf Basis der Bestellungen aktualisieren?
    //         IF NOT CONFIRM(ADF_LT_TEXT001) THEN
    //           EXIT;

    //         ldg_Window.OPEN(ADF_LT_TEXT002 + ' #1##################');

    //         lrc_PurchHeader.RESET();
    //         lrc_PurchHeader.SETRANGE("Document Type",lrc_PurchHeader."Document Type"::Order);
    //         IF lrc_PurchHeader.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             ldg_Window.UPDATE(1,lrc_PurchHeader."No.");
    //             MasterBatchUpdFromPurchHdr(lrc_PurchHeader);
    //           UNTIL lrc_PurchHeader.NEXT() = 0;
    //         END;

    //         ldg_Window.CLOSE;
    //     end;

    procedure BatchNewFromPurchHdr(PurchaseHeader: Record "Purchase Header"; vbn_FromHeader: Boolean; var rco_BatchNo: Code[20])
    var

        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_PurchDocType: Record "POI Purch. Doc. Subtype";
        //lrc_MasterBatch: Record "POI Master Batch";
        DimensionValue: Record "Dimension Value";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        //lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        lco_BatchNo: Code[20];
        TEXT002Txt: Label 'Allocation for future use';
        TEXT003Txt: Label 'Allocation unkown';
        TEXT004Txt: Label 'Die Vergabe der Positionsnummer ist fehlgeschlagen!';
    begin
        // ----------------------------------------------------------------------------
        // Anlage einer neuen Position über Einkaufskopf
        // ----------------------------------------------------------------------------

        // Setup Vergabe gilt per Definition nur für Bestellungen !!!
        IF (PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order) OR
           (PurchaseHeader."POI Purch. Doc. Subtype Code" = '') THEN
            EXIT;

        // Positionsnummer bereits vergeben
        IF rco_BatchNo <> '' THEN
            EXIT;

        // Partie Einrichtung lesen
        lrc_BatchSetup.GET();

        // Einkaufsbelegart lesen
        lrc_PurchDocType.GET(PurchaseHeader."Document Type", PurchaseHeader."POI Purch. Doc. Subtype Code");
        IF lrc_PurchDocType."Allocation BatchNo. by Doc.Typ" = FALSE THEN
            EXIT;
        // Kontrolle ob Partiewesen für die Belegart aktiv ist
        IF lrc_PurchDocType."Batchsystem activ" = FALSE THEN
            EXIT;

        // --------------------------------------------------------------------------
        // Vergabe über Einkaufsbelegart
        // --------------------------------------------------------------------------
        IF ((lrc_PurchDocType."Allocation Batch No." = lrc_PurchDocType."Allocation Batch No."::"New Batch No. per Line") OR
           (lrc_PurchDocType."Allocation Batch No." = lrc_PurchDocType."Allocation Batch No."::"Multiple Batch Nos per Order")) AND
           (vbn_FromHeader = TRUE) THEN
            EXIT;

        CASE lrc_PurchDocType."Source Batch No." OF
            lrc_PurchDocType."Source Batch No."::"No. Series":
                BEGIN
                    lrc_PurchDocType.TESTFIELD("Batch Series No.");
                    lco_BatchNo := NoSeriesManagement.GetNextNo(lrc_PurchDocType."Batch Series No.", WORKDATE(), TRUE);
                END;
            lrc_PurchDocType."Source Batch No."::"Purchase Order No.":
                BEGIN
                    PurchaseHeader.TESTFIELD("No.");
                    lco_BatchNo := PurchaseHeader."No.";
                END;
            lrc_PurchDocType."Source Batch No."::"Master Batch No.":
                BEGIN
                    PurchaseHeader.TESTFIELD("POI Master Batch No.");
                    lco_BatchNo := PurchaseHeader."POI Master Batch No.";
                END;
            lrc_PurchDocType."Source Batch No."::Manuel:
                BEGIN
                    // Zuordnung für zukünftigen Gebrauch
                    ErrorText := TEXT002Txt + ' ' + FORMAT(lrc_PurchDocType."Source Batch No.");
                    ERROR(ErrorText);
                    //lco_BatchNo := '';
                    //EXIT;
                END;
            lrc_PurchDocType."Source Batch No."::Vendor:
                begin
                    // Zuordnung für zukünftigen Gebrauch
                    ErrorText := TEXT002Txt + ' ' + FORMAT(lrc_PurchDocType."Source Batch No.");
                    ERROR(ErrorText);
                end;
            lrc_PurchDocType."Source Batch No."::"Master Batch No. + Postfix":
                IF lrc_PurchDocType."Allocation Batch No." = lrc_PurchDocType."Allocation Batch No."::"New Batch No. per Line" THEN BEGIN
                    PurchaseHeader.TESTFIELD("POI Master Batch No.");
                    lco_BatchNo := '';
                    EXIT;
                END ELSE begin
                    // Zuordnung unbekannt
                    ErrorText := TEXT003Txt + ' ' + FORMAT(lrc_PurchDocType."Allocation Batch No.");
                    ERROR(ErrorText);
                end;
            ELSE begin
                    // Zuordnung unbekannt
                    ErrorText := TEXT003Txt + ' ' + FORMAT(lrc_PurchDocType."Source Batch No.");
                    ERROR(ErrorText);
                end;
        END;


        IF lco_BatchNo = '' THEN
            // Die Vergabe der Positionsnummer ist fehlgeschlagen!
            ERROR(TEXT004Txt);

        // Positionsdatensatz anlegen
        Batch.RESET();
        Batch.INIT();
        Batch."No." := lco_BatchNo;
        Batch."Master Batch No." := PurchaseHeader."POI Master Batch No.";
        Batch.VALIDATE("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
        Batch.Source := Batch.Source::"Purch. Order";
        Batch."Source No." := PurchaseHeader."No.";
        Batch."Kind of Settlement" := PurchaseHeader."POI Kind of Settlement";
        Batch."Means of Transport Type" := PurchaseHeader."POI Means of Transport Type";
        Batch."Means of Transp. Code (Depart)" := PurchaseHeader."POI Means of Transp.Code(Dep.)";
        Batch."Means of Transp. Code (Arriva)" := PurchaseHeader."POI Means of TransCode(Arriva)";
        Batch."Means of Transport Info" := PurchaseHeader."POI Means of Transport Info";
        Batch."Purch. Doc. Subtype Code" := PurchaseHeader."POI Purch. Doc. Subtype Code";
        Batch."Shortcut Dimension 1 Code" := PurchaseHeader."Shortcut Dimension 1 Code";
        Batch."Shortcut Dimension 2 Code" := PurchaseHeader."Shortcut Dimension 2 Code";
        Batch."Shortcut Dimension 3 Code" := PurchaseHeader."POI Shortcut Dimension 3 Code";
        Batch."Shortcut Dimension 4 Code" := PurchaseHeader."POI Shortcut Dimension 4 Code";
        Batch."Departure Location Code" := PurchaseHeader."POI Departure Location Code";
        Batch.INSERT();

        // Kontrolle auf Dimensionsanlage und Anlage der Position als Dimension
        IF lrc_BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
            DimensionValue.RESET();
            DimensionValue.INIT();
            DimensionValue."Dimension Code" := lrc_BatchSetup."Dim. Code Batch No.";
            DimensionValue.Code := Batch."No.";
            DimensionValue.Name := lrc_BatchSetup."Dim. Code Batch No.";
            DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
            DimensionValue."Global Dimension No." := lrc_BatchSetup."Dim. No. Batch No.";
            DimensionValue.INSERT();
            //RS Anlage Partie als Dimension
            IF NOT DimensionValue.GET('PARTIE', Batch."Master Batch No.") THEN BEGIN
                DimensionValue.RESET();
                DimensionValue.INIT();
                DimensionValue."Dimension Code" := 'PARTIE';
                DimensionValue.Code := Batch."Master Batch No.";
                DimensionValue.Name := Batch."Master Batch No.";
                DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
                DimensionValue.INSERT();
            END;
        END;

        // Rückgabewert setzen
        rco_BatchNo := Batch."No.";
    end;

    procedure BatchNewMultipleChoicePurchLin(vrc_PurchaseLine: Record "Purchase line"; var rco_BatchCode: Code[20])
    var

        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_PurchDocType: Record "POI Purch. Doc. Subtype";
        lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        //SelectBatchNo: Form "5110489";
        lbn_BatchNoInserted: Boolean;
        lco_BatchNo: Code[20];
        AGILES_LT_TEXT001Txt: Label 'Herkunft in Kombination mit Vergabe nicht zulässig';
        AGILES_LT_TEXT002Txt: Label 'Vergabeart nicht zulässig ';
        AGILES_LT_TEXT003Txt: Label 'Nicht mehr aktiv!';
    begin
        // ------------------------------------------------------------------------------------------------
        // Funktion zur Auswahl / Vergabe der Positionsnummer bei Wechsel innerhalb der Einkaufszeilen
        // ------------------------------------------------------------------------------------------------

        // Setup Vergabe gilt per Definition nur für Bestellungen !!!
        IF vrc_PurchaseLine."Document Type" <> vrc_PurchaseLine."Document Type"::Order THEN
            EXIT;

        // Kontrolle ob Artikel und Artikelnummer
        IF (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR
           (vrc_PurchaseLine."No." = '') THEN
            EXIT;

        // Artikel lesen und Kontrolle ob Artikel Batchgeführt ist
        lrc_Item.GET(vrc_PurchaseLine."No.");
        IF lrc_Item."POI Batch Item" = FALSE THEN
            EXIT;

        // Einrichtung Partiewesen lesen
        lrc_BatchSetup.GET();

        // Kontrolle ob Partiewesen aktiv ist
        IF lrc_BatchSetup."Batchsystem activ" = FALSE THEN
            EXIT;

        // Kontrolle ob Positionsnr. bereits vergeben
        IF vrc_PurchaseLine."POI Batch No." <> '' THEN BEGIN
            rco_BatchCode := vrc_PurchaseLine."POI Batch No.";
            EXIT;
        END;

        // Einkaufskopfsatz lesen
        lrc_PurchaseHeader.GET(vrc_PurchaseLine."Document Type", vrc_PurchaseLine."Document No.");
        lrc_PurchaseHeader.TESTFIELD("POI Master Batch No.");

        // Einkaufsbelegart lesen
        lrc_PurchDocType.GET(lrc_PurchaseHeader."Document Type", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");

        IF lrc_PurchDocType."Allocation BatchNo. by Doc.Typ" = FALSE THEN
            EXIT;

        // --------------------------------------------------------------------------
        // Vergabe über Einkaufsbelegart
        // --------------------------------------------------------------------------

        CASE lrc_PurchDocType."Allocation Batch No." OF
            lrc_PurchDocType."Allocation Batch No."::"One Batch No per Order":
                // Nicht mehr aktiv!
                ERROR(AGILES_LT_TEXT003Txt);

            lrc_PurchDocType."Allocation Batch No."::"Multiple Batch Nos per Order":
                BEGIN

                    // Temporäre Datei löschen
                    lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::SBN);
                    lrc_BatchTemp.SETRANGE("USERID Code", USERID());
                    lrc_BatchTemp.DELETEALL();

                    // Variable setzen
                    lbn_BatchNoInserted := FALSE;

                    // Einkaufszeilen lesen und bestehende Partienr. in Temp. Tabelle speichern
                    lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseLine."Document Type");
                    lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseLine."Document No.");
                    lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
                    lrc_PurchaseLine.SETFILTER("No.", '<>%1', '');
                    lrc_PurchaseLine.SETFILTER("POI Batch No.", '<>%1', '');
                    IF lrc_PurchaseLine.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::SBN);
                            lrc_BatchTemp.SETRANGE("USERID Code", USERID());
                            lrc_BatchTemp.SETRANGE("SBN Batch No.", lrc_PurchaseLine."POI Batch No.");
                            IF lrc_BatchTemp.ISEMPTY() THEN BEGIN
                                lrc_BatchTemp."Entry Type" := lrc_BatchTemp."Entry Type"::SBN;
                                lrc_BatchTemp."USERID Code" := copystr(USERID(), 1, 20);
                                lrc_BatchTemp."Entry No." := 0;
                                lrc_BatchTemp."SBN Batch No." := lrc_PurchaseLine."POI Batch No.";
                                lrc_BatchTemp.INSERT(TRUE);
                                lbn_BatchNoInserted := TRUE;
                            END;
                        UNTIL lrc_PurchaseLine.NEXT() = 0;

                    // Auswahl aus vorhandenen Positionsnummern
                    IF lbn_BatchNoInserted = TRUE THEN BEGIN
                        COMMIT();
                        lrc_BatchTemp.RESET();
                        lrc_BatchTemp.FILTERGROUP(2);
                        lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::SBN);
                        lrc_BatchTemp.SETRANGE("USERID Code", USERID());
                        lrc_BatchTemp.FILTERGROUP(0);

                        // SelectBatchNo.SETTABLEVIEW(lrc_BatchTemp); //TODO: Page
                        // SelectBatchNo.LOOKUPMODE := TRUE;
                        // IF SelectBatchNo.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        //     lrc_BatchTemp.RESET();
                        //     SelectBatchNo.GETRECORD(lrc_BatchTemp);
                        //     lrc_BatchTemp.TESTFIELD("SBN Batch No.");
                        //     rco_BatchCode := lrc_BatchTemp."SBN Batch No.";
                        //     EXIT;
                        // END;
                    END;

                    // Neue Positionsnummer anlegen
                    BatchNewFromPurchHdr(lrc_PurchaseHeader, FALSE, rco_BatchCode);

                END;

            lrc_PurchDocType."Allocation Batch No."::"New Batch No. per Line":
                CASE lrc_PurchDocType."Source Batch No." OF
                    lrc_PurchDocType."Source Batch No."::"No. Series":
                        BEGIN
                            lrc_PurchDocType.TESTFIELD("Batch Series No.");
                            lco_BatchNo := NoSeriesManagement.GetNextNo(lrc_PurchDocType."Batch Series No.", WORKDATE(), TRUE);
                            // Positionsdatensatz anlegen
                            lrc_Batch.RESET();
                            lrc_Batch.INIT();
                            lrc_Batch."No." := lco_BatchNo;
                            lrc_Batch."Master Batch No." := lrc_PurchaseHeader."POI Master Batch No.";
                            lrc_Batch.VALIDATE("Vendor No.", lrc_PurchaseHeader."Buy-from Vendor No.");
                            lrc_Batch.Source := lrc_Batch.Source::"Purch. Order";
                            lrc_Batch."Source No." := lrc_PurchaseHeader."No.";
                            lrc_Batch."Kind of Settlement" := lrc_PurchaseHeader."POI Kind of Settlement";
                            lrc_Batch."Means of Transport Type" := lrc_PurchaseHeader."POI Means of Transport Type";
                            lrc_Batch."Means of Transp. Code (Depart)" := lrc_PurchaseHeader."POI Means of Transp.Code(Dep.)";
                            lrc_Batch."Means of Transp. Code (Arriva)" := lrc_PurchaseHeader."POI Means of TransCode(Arriva)";
                            lrc_Batch."Means of Transport Info" := lrc_PurchaseHeader."POI Means of Transport Info";
                            lrc_Batch."Purch. Doc. Subtype Code" := lrc_PurchaseHeader."POI Purch. Doc. Subtype Code";
                            lrc_Batch."Shortcut Dimension 1 Code" := lrc_PurchaseHeader."Shortcut Dimension 1 Code";
                            lrc_Batch."Shortcut Dimension 2 Code" := lrc_PurchaseHeader."Shortcut Dimension 2 Code";
                            lrc_Batch."Shortcut Dimension 3 Code" := lrc_PurchaseHeader."POI Shortcut Dimension 3 Code";
                            lrc_Batch."Shortcut Dimension 4 Code" := lrc_PurchaseHeader."POI Shortcut Dimension 4 Code";
                            lrc_Batch."Departure Location Code" := lrc_PurchaseHeader."POI Departure Location Code";
                            lrc_Batch.INSERT();

                            // Kontrolle auf Dimensionsanlage und Anlage der Position als Dimension
                            IF lrc_BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
                                lrc_DimensionValue.RESET();
                                lrc_DimensionValue.INIT();
                                lrc_DimensionValue."Dimension Code" := lrc_BatchSetup."Dim. Code Batch No.";
                                lrc_DimensionValue.Code := lrc_Batch."No.";
                                lrc_DimensionValue.Name := 'Position';
                                lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
                                lrc_DimensionValue."Global Dimension No." := lrc_BatchSetup."Dim. No. Batch No.";
                                lrc_DimensionValue.INSERT();
                                //RS Anlage Partie als Dimension
                                IF NOT lrc_DimensionValue.GET('PARTIE', lrc_Batch."Master Batch No.") THEN BEGIN
                                    lrc_DimensionValue.RESET();
                                    lrc_DimensionValue.INIT();
                                    lrc_DimensionValue."Dimension Code" := 'PARTIE';
                                    lrc_DimensionValue.Code := lrc_Batch."Master Batch No.";
                                    lrc_DimensionValue.Name := lrc_Batch."Master Batch No.";
                                    lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
                                    lrc_DimensionValue.INSERT();
                                END;
                            END;
                            COMMIT();

                            rco_BatchCode := lrc_Batch."No.";
                            EXIT;

                        END;

                    lrc_PurchDocType."Source Batch No."::"Master Batch No. + Postfix":
                        BEGIN
                            lrc_PurchaseHeader.TESTFIELD("POI Master Batch No.");
                            // Postfixzähler ermitteln
                            lrc_MasterBatch.GET(lrc_PurchaseHeader."POI Master Batch No.");
                            lrc_MasterBatch.VALIDATE("Vendor No.", lrc_PurchaseHeader."Buy-from Vendor No.");
                            lrc_MasterBatch."Batch Postfix Counter" := lrc_MasterBatch."Batch Postfix Counter" + 1;
                            lrc_MasterBatch."Shortcut Dimension 1 Code" := lrc_PurchaseHeader."Shortcut Dimension 1 Code";
                            lrc_MasterBatch."Shortcut Dimension 2 Code" := lrc_PurchaseHeader."Shortcut Dimension 2 Code";
                            lrc_MasterBatch."Shortcut Dimension 3 Code" := lrc_PurchaseHeader."POI Shortcut Dimension 3 Code";
                            lrc_MasterBatch."Shortcut Dimension 4 Code" := lrc_PurchaseHeader."POI Shortcut Dimension 4 Code";
                            lrc_MasterBatch.MODIFY();
                            lco_BatchNo := copystr(lrc_MasterBatch."No." + lrc_PurchDocType."Batch Separator" +
                                           lcu_GlobalFunctions.FormatIntegerWithBeginningZero(lrc_MasterBatch."Batch Postfix Counter", lrc_PurchDocType."Batch Postfix Places"), 1, 20);
                            // Positionsdatensatz anlegen
                            lrc_Batch.RESET();
                            lrc_Batch.INIT();
                            lrc_Batch."No." := lco_BatchNo;
                            lrc_Batch."Master Batch No." := lrc_PurchaseHeader."POI Master Batch No.";
                            lrc_Batch.VALIDATE("Vendor No.", lrc_PurchaseHeader."Buy-from Vendor No.");
                            lrc_Batch.Source := lrc_Batch.Source::"Purch. Order";
                            lrc_Batch."Source No." := lrc_PurchaseHeader."No.";
                            lrc_Batch."Kind of Settlement" := lrc_PurchaseHeader."POI Kind of Settlement";
                            lrc_Batch."Means of Transport Type" := lrc_PurchaseHeader."POI Means of Transport Type";
                            lrc_Batch."Means of Transp. Code (Depart)" := lrc_PurchaseHeader."POI Means of Transp.Code(Dep.)";
                            lrc_Batch."Means of Transp. Code (Arriva)" := lrc_PurchaseHeader."POI Means of TransCode(Arriva)";
                            lrc_Batch."Means of Transport Info" := lrc_PurchaseHeader."POI Means of Transport Info";
                            lrc_Batch."Purch. Doc. Subtype Code" := lrc_PurchaseHeader."POI Purch. Doc. Subtype Code";
                            lrc_Batch."Shortcut Dimension 1 Code" := lrc_PurchaseHeader."Shortcut Dimension 1 Code";
                            lrc_Batch."Shortcut Dimension 2 Code" := lrc_PurchaseHeader."Shortcut Dimension 2 Code";
                            lrc_Batch."Shortcut Dimension 3 Code" := lrc_PurchaseHeader."POI Shortcut Dimension 3 Code";
                            lrc_Batch."Shortcut Dimension 4 Code" := lrc_PurchaseHeader."POI Shortcut Dimension 4 Code";
                            lrc_Batch."Departure Location Code" := lrc_PurchaseHeader."POI Departure Location Code";
                            lrc_Batch.INSERT();

                            // Kontrolle auf Dimensionsanlage und Anlage der Position als Dimension
                            IF lrc_BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
                                lrc_DimensionValue.RESET();
                                lrc_DimensionValue.INIT();
                                lrc_DimensionValue."Dimension Code" := lrc_BatchSetup."Dim. Code Batch No.";
                                lrc_DimensionValue.Code := lrc_Batch."No.";
                                lrc_DimensionValue.Name := 'Position';
                                lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
                                lrc_DimensionValue."Global Dimension No." := lrc_BatchSetup."Dim. No. Batch No.";
                                lrc_DimensionValue.INSERT();
                                //RS Anlage Partie als Dimension
                                IF NOT lrc_DimensionValue.GET('PARTIE', lrc_Batch."Master Batch No.") THEN BEGIN
                                    lrc_DimensionValue.RESET();
                                    lrc_DimensionValue.INIT();
                                    lrc_DimensionValue."Dimension Code" := 'PARTIE';
                                    lrc_DimensionValue.Code := lrc_Batch."Master Batch No.";
                                    lrc_DimensionValue.Name := lrc_Batch."Master Batch No.";
                                    lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
                                    lrc_DimensionValue.INSERT();
                                END;
                            END;
                            COMMIT();

                            rco_BatchCode := lrc_Batch."No.";
                            EXIT;

                        END;

                    lrc_PurchDocType."Source Batch No."::"Purchase Order No.",
                    lrc_PurchDocType."Source Batch No."::"Master Batch No.",
                    lrc_PurchDocType."Source Batch No."::Manuel,
                    lrc_PurchDocType."Source Batch No."::Vendor:
                        begin
                            // Herkunft in Kombination mit Vergabe nicht zulässig
                            ErrorText := AGILES_LT_TEXT001Txt + ' ' + FORMAT(lrc_PurchDocType."Source Batch No.");
                            ERROR(ErrorText);
                        end;
                end
            ELSE begin
                    // Vergabeart nicht zulässig
                    ErrorText := AGILES_LT_TEXT002Txt + ' ' + FORMAT(lrc_PurchDocType."Allocation Batch No.");
                    ERROR(ErrorText);
                end;
        end;
    end;

    procedure BatchUpdFromPurchHdr(vco_BatchCode: Code[20]; vrc_PurchaseHeader: Record "Purchase Header")
    var
        BatchSetup: Record "POI Master Batch Setup";
        lcu_PositionPlanning: Codeunit "POI Position Planning";
    begin
        // --------------------------------------------------------------------------------------
        // Aktualisierung einer vorhandenen Position
        // --------------------------------------------------------------------------------------

        // Setup Vergabe gilt per Definition nur für Bestellungen !!!
        IF vrc_PurchaseHeader."Document Type" <> vrc_PurchaseHeader."Document Type"::Order THEN
            EXIT;

        IF vrc_PurchaseHeader."POI Master Batch No." = '' THEN
            EXIT;

        // Einrichtung Partiewesen lesen
        BatchSetup.GET();

        // Kontrolle ob Partiewesen aktiv ist
        IF BatchSetup."Batchsystem activ" = FALSE THEN
            EXIT;

        // Positionnr. lesen und aktualisieren
        Batch.SETRANGE("Master Batch No.", vrc_PurchaseHeader."POI Master Batch No.");
        IF vco_BatchCode <> '' THEN
            Batch.SETRANGE("No.", vco_BatchCode);
        IF Batch.FINDSET(TRUE, FALSE) THEN
            REPEAT
                Batch."Master Batch No." := vrc_PurchaseHeader."POI Master Batch No.";
                Batch.VALIDATE("Vendor No.", vrc_PurchaseHeader."Buy-from Vendor No.");
                Batch.Source := Batch.Source::"Purch. Order";
                Batch."Source No." := vrc_PurchaseHeader."No.";
                Batch."Kind of Settlement" := vrc_PurchaseHeader."POI Kind of Settlement";
                Batch."Order Date" := vrc_PurchaseHeader."Order Date";
                Batch."Posting Date" := vrc_PurchaseHeader."Posting Date";
                Batch."Vendor Order No." := vrc_PurchaseHeader."Vendor Order No.";
                Batch."Voyage No." := vrc_PurchaseHeader."POI Voyage No.";
                Batch."Means of Transport Type" := vrc_PurchaseHeader."POI Means of Transport Type";
                Batch."Means of Transp. Code (Depart)" := vrc_PurchaseHeader."POI Means of Transp.Code(Dep.)";
                Batch."Means of Transp. Code (Arriva)" := vrc_PurchaseHeader."POI Means of TransCode(Arriva)";
                Batch."Means of Transport Info" := vrc_PurchaseHeader."POI Means of Transport Info";
                Batch."Departure Region Code" := vrc_PurchaseHeader."POI Departure Region Code";
                Batch."Port of Discharge Code" := vrc_PurchaseHeader."POI Port of Disch. Code (UDE)";
                Batch."Date of Discharge" := vrc_PurchaseHeader."POI Expected Discharge Date";
                Batch."Time of Discharge" := vrc_PurchaseHeader."POI Expected Discharge Time";
                Batch."Receipt Info" := vrc_PurchaseHeader."POI Receipt Info";
                Batch."Location's Reference No." := vrc_PurchaseHeader."POI Location Reference No.";
                Batch."Departure Date" := vrc_PurchaseHeader."POI Departure Date";
                Batch."Expected Receipt Date" := vrc_PurchaseHeader."Expected Receipt Date";
                IF vrc_PurchaseHeader."Promised Receipt Date" = 0D THEN
                    Batch."Promised Receipt Date" := vrc_PurchaseHeader."Expected Receipt Date"
                ELSE
                    Batch."Promised Receipt Date" := vrc_PurchaseHeader."Promised Receipt Date";
                IF Batch."Promised Receipt Date" <> 0D THEN
                    Batch."Disposition Week" := lcu_PositionPlanning.GeneratePlanningWeek(Batch."Promised Receipt Date", Batch."Voyage No.");
                Batch."Purch. Doc. Subtype Code" := vrc_PurchaseHeader."POI Purch. Doc. Subtype Code";
                Batch."Shortcut Dimension 1 Code" := vrc_PurchaseHeader."Shortcut Dimension 1 Code";
                Batch."Shortcut Dimension 2 Code" := vrc_PurchaseHeader."Shortcut Dimension 2 Code";
                Batch."Shortcut Dimension 3 Code" := vrc_PurchaseHeader."POI Shortcut Dimension 3 Code";
                Batch."Shortcut Dimension 4 Code" := vrc_PurchaseHeader."POI Shortcut Dimension 4 Code";
                Batch."Departure Location Code" := vrc_PurchaseHeader."POI Departure Location Code";
                Batch.MODIFY();
            UNTIL Batch.NEXT() = 0;
    end;

    //     procedure BatchUpdFromPurchLine(vrc_PurchaseLine: Record "39")
    //     var
    //         lcu_BDTBaseDataTemplateMgt: Codeunit "5087929";
    //         lrc_PurchHeader: Record "38";
    //         lrc_Batch: Record "5110365";
    //         lrc_UnitofMeasure: Record "204";
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Aktualisierung einer vorhandenen Position
    //         // ------------------------------------------------------------------------------------------

    //         // Prüfen ob Zeile zulässig
    //         IF (vrc_PurchaseLine."Document Type" <> vrc_PurchaseLine."Document Type"::Order) OR
    //            (vrc_PurchaseLine."No." = '') OR
    //            (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR
    //            (vrc_PurchaseLine."Batch No." = '') THEN
    //           EXIT;

    //         // Positionsnr. lesen (ansonsten beenden)
    //         IF NOT lrc_Batch.GET(vrc_PurchaseLine."Batch No.") THEN
    //           EXIT;

    //         // Einkaufskopfsatz lesen
    //         lrc_PurchHeader.GET(vrc_PurchaseLine."Document Type",vrc_PurchaseLine."Document No.");

    //         // Artikelstammsatz lesen
    //         lrc_Item.GET(vrc_PurchaseLine."No.");

    //         lrc_Batch."Item Description" := lrc_Item.Description;
    //         IF lrc_Batch."Item Description" = '' THEN BEGIN
    //           lrc_Batch."Item Description" := vrc_PurchaseLine.Description;
    //         END;
    //         lrc_Batch."Item Search Description" := lcu_BDTBaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);

    //         lrc_Batch."Item No." := vrc_PurchaseLine."No.";
    //         lrc_Batch."Item Variant Code" := vrc_PurchaseLine."Variant Code";

    //         lrc_Batch."Master Batch No." := lrc_PurchHeader."Master Batch No.";

    //         // Hierarchie
    //         lrc_Batch."Item Main Category Code" := lrc_Item."Item Main Category Code";
    //         lrc_Batch."Item Category Code" := lrc_Item."Item Category Code";
    //         lrc_Batch."Product Group Code" := lrc_Item."Product Group Code";

    //         // Merkmale
    //         lrc_Batch."Country of Origin Code" := vrc_PurchaseLine."Country of Origin Code";
    //         lrc_Batch."Variety Code" := vrc_PurchaseLine."Variety Code";
    //         lrc_Batch."Trademark Code" := vrc_PurchaseLine."Trademark Code";
    //         lrc_Batch."Caliber Code" := vrc_PurchaseLine."Caliber Code";
    //         lrc_Batch."Vendor Caliber Code" := vrc_PurchaseLine."Vendor Caliber Code";
    //         lrc_Batch."Item Attribute 3" := vrc_PurchaseLine."Item Attribute 3";
    //         lrc_Batch."Item Attribute 2" := vrc_PurchaseLine."Item Attribute 2";
    //         lrc_Batch."Grade of Goods Code" := vrc_PurchaseLine."Grade of Goods Code";
    //         lrc_Batch."Item Attribute 7" := vrc_PurchaseLine."Item Attribute 7";
    //         lrc_Batch."Item Attribute 5" := vrc_PurchaseLine."Item Attribute 5";
    //         lrc_Batch."Item Attribute 6" := lrc_Item."Item Attribute 6";
    //         lrc_Batch."Item Attribute 4" := vrc_PurchaseLine."Item Attribute 4";
    //         lrc_Batch."Coding Code" := vrc_PurchaseLine."Coding Code";

    //         IF lrc_Batch."Vendor No." <> lrc_PurchHeader."Buy-from Vendor No." THEN BEGIN
    //           lrc_Batch.VALIDATE("Vendor No.", lrc_PurchHeader."Buy-from Vendor No.");
    //         END;
    //         lrc_Batch."Producer No." := vrc_PurchaseLine."Manufacturer Code";

    //         lrc_Batch."Net Weight" := vrc_PurchaseLine."Net Weight";
    //         lrc_Batch."Gross Weight" := vrc_PurchaseLine."Gross Weight";
    //         lrc_Batch."Average Customs Weight" := vrc_PurchaseLine."Customs Weight (Average)";

    //         lrc_Batch."Departure Date" := lrc_PurchHeader."Departure Date";
    //         lrc_Batch."Order Date" := lrc_PurchHeader."Order Date";
    //         lrc_Batch."Date of Delivery" := vrc_PurchaseLine."Expected Receipt Date";

    //         lrc_Batch."Kind of Settlement" := vrc_PurchaseLine."Kind of Settlement";
    //         lrc_Batch.Weight := vrc_PurchaseLine.Weight;
    //         IF vrc_PurchaseLine."Lot No. Producer" <> '' THEN BEGIN
    //           lrc_Batch."Lot No. Producer" := vrc_PurchaseLine."Lot No. Producer";
    //         END;
    //         lrc_Batch."Entry Location Code" := vrc_PurchaseLine."Location Code";
    //         //??lrc_Batch."Location Reference No." := vrc_PurchaseLine."Location's Reference No.";
    //         lrc_Batch."Shelf No." := vrc_PurchaseLine."Shelf No.";
    //         lrc_Batch."Info 1" := vrc_PurchaseLine."Info 1";
    //         lrc_Batch."Info 2" := vrc_PurchaseLine."Info 2";
    //         lrc_Batch."Info 3" := vrc_PurchaseLine."Info 3";
    //         lrc_Batch."Info 4" := vrc_PurchaseLine."Info 4";
    //         lrc_Batch."Date of Expiry" := vrc_PurchaseLine."Date of Expiry";
    //         lrc_Batch."Kind of Loading" := vrc_PurchaseLine."Kind of Loading";
    //         lrc_Batch."Voyage No." := vrc_PurchaseLine."Voyage No.";
    //         lrc_Batch."Container No." := vrc_PurchaseLine."Container No.";
    //         lrc_Batch."Means of Transport Type" := lrc_PurchHeader."Means of Transport Type";
    //         lrc_Batch."Means of Transp. Code (Arriva)" := lrc_PurchHeader."Means of Transp. Code (Arriva)";
    //         lrc_Batch."Means of Transport Info" := lrc_PurchHeader."Means of Transport Info";
    //         lrc_Batch."Port of Discharge Code" := vrc_PurchaseLine."Port of Discharge Code (UDE)";
    //         lrc_Batch."Date of Discharge" := vrc_PurchaseLine."Date of Discharge";
    //         lrc_Batch."Time of Discharge" := vrc_PurchaseLine."Time of Discharge";
    //         lrc_Batch."Waste Disposal Duty" := vrc_PurchaseLine."Waste Disposal Duty";
    //         lrc_Batch."Waste Disposal Payment By" := vrc_PurchaseLine."Waste Disposal Payment Thru";
    //         lrc_Batch."Status Customs Duty" := vrc_PurchaseLine."Status Customs Duty";
    //         lrc_Batch."Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
    //         lrc_Batch."Unit of Measure Code" := vrc_PurchaseLine."Unit of Measure Code";
    //         lrc_Batch."Qty. per Unit of Measure" := vrc_PurchaseLine."Qty. per Unit of Measure";
    //         //xxlrc_Batch."Collo Unit of Measure (CU)" := vrc_PurchaseLine."Unit of Measure Code";
    //         lrc_Batch."Qty. (BU) per Collo (CU)" := vrc_PurchaseLine."Qty. per Unit of Measure";
    //         // Verpackungseinheit und Menge Verpackungen pro Einkaufseinheit
    //         lrc_Batch."Packing Unit of Measure (PU)" := vrc_PurchaseLine."Packing Unit of Measure (PU)";
    //         lrc_Batch."Qty. (PU) per Collo (CU)" := vrc_PurchaseLine."Qty. (PU) per Unit of Measure";
    //         lrc_Batch."Content Unit of Measure (CP)" := vrc_PurchaseLine."Content Unit of Measure (COU)";
    //         // Transporteinheit und Menge Einkaufseinheiten pro Transporteinheit
    //         lrc_Batch."Transport Unit of Measure (TU)" := vrc_PurchaseLine."Transport Unit of Measure (TU)";
    //         lrc_Batch."Qty. (Unit) per Transp. (TU)" := vrc_PurchaseLine."Qty. (Unit) per Transp.(TU)";
    //         lrc_Batch."Price Base (Purch. Price)" := vrc_PurchaseLine."Price Base (Purch. Price)";
    //         lrc_Batch."Purch. Price (Price Base)" := vrc_PurchaseLine."Purch. Price (Price Base)";
    //         lrc_Batch."Price Base (Sales Price)" := vrc_PurchaseLine."Price Base (Sales Price)";
    //         lrc_Batch."Sales Price (Price Base)" := vrc_PurchaseLine."Sales Price (Price Base) (LCY)";
    //         lrc_Batch."Market Unit Cost (Base) (LCY)" := vrc_PurchaseLine."Market Unit Cost (Basis) (LCY)";
    //         lrc_Batch."Empties Item No." := vrc_PurchaseLine."Empties Item No.";
    //         lrc_Batch."Empties Quantity" := vrc_PurchaseLine."Empties Quantity";
    //         // Herkunft Position
    //         lrc_Batch.Source := lrc_Batch.Source::"Purch. Order";
    //         lrc_Batch."Source No." := vrc_PurchaseLine."Document No.";
    //         lrc_Batch."Source Line No." := vrc_PurchaseLine."Line No.";
    //         lrc_Batch."Purch. Doc. Subtype Code" := lrc_PurchHeader."Purch. Doc. Subtype Code";
    //         lrc_Batch."Shortcut Dimension 1 Code" := lrc_PurchHeader."Shortcut Dimension 1 Code";
    //         lrc_Batch."Shortcut Dimension 2 Code" := lrc_PurchHeader."Shortcut Dimension 2 Code";
    //         lrc_Batch."Shortcut Dimension 3 Code" := lrc_PurchHeader."Shortcut Dimension 3 Code";
    //         lrc_Batch."Shortcut Dimension 4 Code" := lrc_PurchHeader."Shortcut Dimension 4 Code";
    //         lrc_Batch."Departure Location Code" := lrc_PurchHeader."Departure Location Code";

    //         //160919 rs
    //         lrc_Batch."Customer Group Code" := vrc_PurchaseLine."Customer Group Code";
    //         lrc_Batch.EAN := vrc_PurchaseLine.ean;
    //         lrc_Batch."PLU-Code" := vrc_PurchaseLine."PLU-Code";
    //         //160919 rs.e

    //         lrc_Batch.MODIFY();
    //     end;

    //     procedure BatchCheckPosting()
    //     begin
    //         // -----------------------------------------------------------------------------------------------------
    //         // Funktion zur Prüfung ob Buchungen auf der Position sind
    //         // -----------------------------------------------------------------------------------------------------
    //     end;

    //     procedure BatchBlockUnblock(vco_MasterBatchNo: Code[20];vco_BatchNo: Code[20];vbn_Block: Boolean)
    //     var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_DimensionValue: Record "349";
    //         lrc_Batch: Record "5110365";
    //     begin
    //         // -----------------------------------------------------------------------------------------------------
    //         // Funktion zum Sperren / entsperren von Positionen in den Dimensionen
    //         // -----------------------------------------------------------------------------------------------------

    //         IF (vco_MasterBatchNo = '') AND
    //            (vco_BatchNo = '') THEN
    //           EXIT;

    //         lrc_BatchSetup.GET();

    //         lrc_Batch.RESET();
    //         IF vco_MasterBatchNo <> '' THEN
    //           lrc_Batch.SETRANGE("Master Batch No.",vco_MasterBatchNo);
    //         IF vco_BatchNo <> '' THEN
    //           lrc_Batch.SETRANGE("No.",vco_BatchNo);
    //         IF lrc_Batch.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             lrc_DimensionValue.RESET();
    //             lrc_DimensionValue.SETRANGE("Dimension Code",lrc_BatchSetup."Dim. Code Batch No.");
    //             lrc_DimensionValue.SETRANGE(Code,lrc_Batch."No.");
    //             IF lrc_DimensionValue.FIND('-') THEN BEGIN
    //               lrc_DimensionValue.Blocked := vbn_Block;
    //               lrc_DimensionValue.MODIFY();
    //             END;
    //           UNTIL lrc_Batch.NEXT() = 0;
    //         END;
    //     end;

    //     procedure BatchGetUnitCost(): Decimal
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung des Einstandspreises
    //         // ---------------------------------------------------------------------------------------------

    //         EXIT(0);
    //     end;

    procedure BatchVarNewFromPurchLine(vrc_PurchaseLine: Record "Purchase Line"; vbn_Splitt: Boolean; var rco_BatchCode: Code[20]; var rco_BatchVariantCode: Code[20])
    var

        lrc_ADFSetup: Record "POI ADF Setup";
        lrc_MasterBatchSetup: Record "POI Master Batch Setup";
        lrc_PurchDocType: Record "POI Purch. Doc. Subtype";
        lrc_PurchHeader: Record "Purchase Header";
        //lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Vendor: Record Vendor;
        BatchManagement: Codeunit "POI BAM Batch Management";
        GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        lcu_BaseDataTemplateMgt: Codeunit "POI BDT Base Data Template Mgt";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        lco_BatchCode: Code[20];
        BatchVariantCode: Code[20];
        TEXT001Txt: Label 'Positionsnummer konnte nicht ermittelt werden!';
        TEXT003Txt: Label 'Die Vergabe der Positionsvariantennummer ist fehlgeschlagen!';
        AGILES_LT_TEXT005Txt: Label 'Keine Zuordnung!';
        AGILES_LT_TEXT006Txt: Label 'Nicht codiert!';
        AGILES_LT_TEXT007Txt: Label 'Keine Zuordnung für %1 die dortige Positionsvariantennr.!', Comment = '%1 =';
    begin
        // ----------------------------------------------------------------------------
        // Anlage einer neuen Positionsvariante und gegebenenfalls eine Positionsnr.
        // ----------------------------------------------------------------------------

        // Setup Vergabe gilt per Definition nur für Bestellungen !!!
        IF vrc_PurchaseLine."Document Type" <> vrc_PurchaseLine."Document Type"::Order THEN
            EXIT;

        // Partie Setup lesen
        lrc_MasterBatchSetup.GET();

        // Kontrolle ob das Partiewesen aktiv ist
        IF lrc_MasterBatchSetup."Batchsystem activ" = FALSE THEN
            EXIT;

        lrc_ADFSetup.GET();

        // Kontrolle ob Artikel und Artikelnummer oder Batchvariante
        IF (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR
           (vrc_PurchaseLine."No." = '') OR
           (vrc_PurchaseLine."POI Batch Variant No." <> '') THEN
            EXIT;

        // Artikel lesen und Kontrolle ob Artikel Batchgeführt ist
        lrc_Item.GET(vrc_PurchaseLine."No.");
        IF lrc_Item."POI Batch Item" = FALSE THEN
            EXIT;

        // Einkaufskopfsatz lesen
        lrc_PurchHeader.GET(vrc_PurchaseLine."Document Type", vrc_PurchaseLine."Document No.");

        // Einkaufsbelegart lesen
        lrc_PurchDocType.GET(lrc_PurchHeader."Document Type", lrc_PurchHeader."POI Purch. Doc. Subtype Code");

        IF lrc_PurchDocType."Allocation BatchNo. by Doc.Typ" = FALSE THEN
            EXIT;

        IF lrc_PurchDocType."Batchsystem activ" = FALSE THEN
            EXIT;

        // --------------------------------------------------------------------------
        // Vergabe Positionsvariante über Einkaufsbelegart
        // --------------------------------------------------------------------------

        // Kontrolle ob Partienummer vergeben wurde
        lrc_PurchHeader.TESTFIELD("POI Master Batch No.");

        CASE lrc_PurchDocType."Allocation Batch No." OF

            // Eine Position per Order (Positionsnr. muss schon im Kopfsatz stehen)
            lrc_PurchDocType."Allocation Batch No."::"One Batch No per Order":
                BEGIN

                    // Positionsnummer ermitteln falls noch keine vorhanden
                    IF vrc_PurchaseLine."POI Batch No." = '' THEN BEGIN
                        BatchNewMultipleChoicePurchLin(vrc_PurchaseLine, lco_BatchCode);
                        IF lco_BatchCode = '' THEN
                            // Positionsnummer konnte nicht ermittelt werden!
                            ERROR(TEXT001Txt);
                    END ELSE
                        lco_BatchCode := vrc_PurchaseLine."POI Batch No.";

                    // Positionsvariantennummer erstellen
                    CASE lrc_PurchDocType."Source Batch Variant" OF
                        lrc_PurchDocType."Source Batch Variant"::"No. Series":
                            BEGIN
                                lrc_PurchDocType.TESTFIELD("Batch Variant No. Series");
                                BatchVariantCode := NoSeriesManagement.GetNextNo(lrc_PurchDocType."Batch Variant No. Series",
                                                                                 WORKDATE(), TRUE);
                            END;

                        lrc_PurchDocType."Source Batch Variant"::"Batch No. + Postfix":
                            BEGIN
                                // Postfixzähler ermitteln
                                lrc_Batch.GET(lco_BatchCode);
                                lrc_Batch.VALIDATE("Vendor No.", vrc_PurchaseLine."Buy-from Vendor No.");
                                lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
                                lrc_Batch."Kind of Settlement" := lrc_PurchHeader."POI Kind of Settlement";
                                lrc_Batch."Shortcut Dimension 1 Code" := lrc_PurchHeader."Shortcut Dimension 1 Code";
                                lrc_Batch."Shortcut Dimension 2 Code" := lrc_PurchHeader."Shortcut Dimension 2 Code";
                                lrc_Batch."Shortcut Dimension 3 Code" := lrc_PurchHeader."POI Shortcut Dimension 3 Code";
                                lrc_Batch."Shortcut Dimension 4 Code" := lrc_PurchHeader."POI Shortcut Dimension 4 Code";
                                lrc_Batch.MODIFY();

                                BatchVariantCode := copystr(lco_BatchCode + lrc_PurchDocType."Batch Variant Separator" +
                                    GlobalFunctions.FormatIntegerWithBeginningZero(lrc_Batch."Batch Variant Postfix Counter", lrc_PurchDocType."Batch Variant Postfix Places"), 1, 20);
                            END;
                    END;


                END;

            // Wahlweise kann der Anwender eine neue Positionsnr. pro Zeile vergeben werden
            lrc_PurchDocType."Allocation Batch No."::"Multiple Batch Nos per Order":
                BEGIN

                    // Positionsnummer ermitteln falls noch keine vorhanden
                    IF vrc_PurchaseLine."POI Batch No." = '' THEN BEGIN
                        BatchManagement.BatchNewMultipleChoicePurchLin(vrc_PurchaseLine, lco_BatchCode);
                        IF lco_BatchCode = '' THEN
                            // Positionsnummer konnte nicht ermittelt werden!
                            ERROR(TEXT001Txt);
                    END ELSE
                        lco_BatchCode := vrc_PurchaseLine."POI Batch No.";

                    // Positionsvariantennummer erstellen
                    CASE lrc_PurchDocType."Source Batch Variant" OF
                        lrc_PurchDocType."Source Batch Variant"::"No. Series":
                            BEGIN
                                lrc_MasterBatchSetup.TESTFIELD("Purch. Batch Variant No Series");
                                BatchVariantCode := NoSeriesManagement.GetNextNo(lrc_MasterBatchSetup."Purch. Batch Variant No Series",
                                                                                 WORKDATE(), TRUE);
                            END;

                        lrc_PurchDocType."Source Batch Variant"::"Batch No. + Postfix":
                            BEGIN
                                // Postfixzähler ermitteln
                                lrc_Batch.GET(lco_BatchCode);
                                lrc_Batch.VALIDATE("Vendor No.", vrc_PurchaseLine."Buy-from Vendor No.");
                                lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
                                lrc_Batch."Kind of Settlement" := lrc_PurchHeader."POI Kind of Settlement";
                                lrc_Batch."Shortcut Dimension 1 Code" := lrc_PurchHeader."Shortcut Dimension 1 Code";
                                lrc_Batch."Shortcut Dimension 2 Code" := lrc_PurchHeader."Shortcut Dimension 2 Code";
                                lrc_Batch."Shortcut Dimension 3 Code" := lrc_PurchHeader."POI Shortcut Dimension 3 Code";
                                lrc_Batch."Shortcut Dimension 4 Code" := lrc_PurchHeader."POI Shortcut Dimension 4 Code";
                                lrc_Batch.MODIFY();

                                BatchVariantCode := copystr(lco_BatchCode + lrc_MasterBatchSetup."Batch Variant Separator" +
                                                      GlobalFunctions.FormatIntegerWithBeginningZero(
                                                        lrc_Batch."Batch Variant Postfix Counter",
                                                        lrc_MasterBatchSetup."Batch Variant Postfix Places"), 1, 20);
                            END;
                        ELSE
                            // Keine Zuordnung!
                            ERROR(AGILES_LT_TEXT005Txt);
                    END;
                END;

            // Es wird für jede Zeile eine neue Positionsnummer vergeben
            lrc_PurchDocType."Allocation Batch No."::"New Batch No. per Line":
                BEGIN

                    IF vbn_Splitt = TRUE THEN
                        vrc_PurchaseLine."POI Batch No." := '';

                    // Positionsnummer ermitteln falls noch keine vorhanden
                    IF vrc_PurchaseLine."POI Batch No." = '' THEN BEGIN
                        BatchManagement.BatchNewMultipleChoicePurchLin(vrc_PurchaseLine, lco_BatchCode);
                        IF lco_BatchCode = '' THEN
                            // Positionsnummer konnte nicht ermittelt werden!
                            ERROR(TEXT001Txt);
                        vrc_PurchaseLine."POI Batch No." := lco_BatchCode;
                    END ELSE
                        lco_BatchCode := vrc_PurchaseLine."POI Batch No.";


                    CASE lrc_PurchDocType."Source Batch Variant" OF
                        lrc_PurchDocType."Source Batch Variant"::"No. Series":
                            // Nicht codiert!
                            ERROR(AGILES_LT_TEXT006Txt);

                        // Positionsvariante besteht aus Positionsnr + Postfix
                        lrc_PurchDocType."Source Batch Variant"::"Batch No. + Postfix":
                            BEGIN
                                // Postfixzähler ermitteln
                                lrc_Batch.GET(lco_BatchCode);
                                lrc_Batch.VALIDATE("Vendor No.", vrc_PurchaseLine."Buy-from Vendor No.");
                                lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
                                lrc_Batch."Kind of Settlement" := lrc_PurchHeader."POI Kind of Settlement";
                                lrc_Batch."Shortcut Dimension 1 Code" := lrc_PurchHeader."Shortcut Dimension 1 Code";
                                lrc_Batch."Shortcut Dimension 2 Code" := lrc_PurchHeader."Shortcut Dimension 2 Code";
                                lrc_Batch."Shortcut Dimension 3 Code" := lrc_PurchHeader."POI Shortcut Dimension 3 Code";
                                lrc_Batch."Shortcut Dimension 4 Code" := lrc_PurchHeader."POI Shortcut Dimension 4 Code";
                                lrc_Batch.MODIFY();

                                BatchVariantCode := copystr(lco_BatchCode + lrc_PurchDocType."Batch Variant Separator" +
                                                    GlobalFunctions.FormatIntegerWithBeginningZero(lrc_Batch."Batch Variant Postfix Counter", lrc_PurchDocType."Batch Variant Postfix Places"), 1, 20);
                            END;

                        // Positionsvariante ist identisch mit der Positionsnr. da für jede Zeile eine neue Positionsnr. vergeben wird
                        lrc_PurchDocType."Source Batch Variant"::"Batch No.":
                            BEGIN
                                vrc_PurchaseLine.TESTFIELD("POI Batch No.");
                                BatchVariantCode := vrc_PurchaseLine."POI Batch No.";
                            END;
                        ELSE
                            ERROR(AGILES_LT_TEXT007Txt, FORMAT(lrc_PurchDocType."Allocation Batch No."));
                    END;

                END;

        END;


        IF BatchVariantCode = '' THEN
            // Die Vergabe der Positionsvariantennummer ist fehlgeschlagen!
            ERROR(TEXT003Txt);

        // Status Position auf offen setzen
        SetBatchStatusOpen(lco_BatchCode);

        // --------------------------------------------------------------------
        // Positionsvariante anlegen
        // --------------------------------------------------------------------
        lrc_BatchVariant.RESET();
        lrc_BatchVariant.INIT();
        lrc_BatchVariant."No." := BatchVariantCode;
        lrc_BatchVariant."Master Batch No." := lrc_PurchHeader."POI Master Batch No.";
        lrc_BatchVariant."Batch No." := lco_BatchCode;

        lrc_BatchVariant."Item No." := vrc_PurchaseLine."No.";
        lrc_BatchVariant."Variant Code" := vrc_PurchaseLine."Variant Code";

        lrc_BatchVariant.Description := vrc_PurchaseLine.Description;
        lrc_BatchVariant."Description 2" := vrc_PurchaseLine."Description 2";

        IF (lrc_BatchVariant.Description = '') AND
           (lrc_BatchVariant."Description 2" = '') THEN BEGIN
            lrc_BatchVariant.Description := lrc_Item.Description;
            lrc_BatchVariant."Description 2" := lrc_Item."Description 2";
        END;

        lrc_BatchVariant."Item Main Category Code" := lrc_Item."POI Item Main Category Code";
        lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
        lrc_BatchVariant."Product Group Code" := lrc_Item."POI Product Group Code";
        lrc_BatchVariant."Base Unit of Measure (BU)" := vrc_PurchaseLine."POI Base Unit of Measure (BU)";
        lrc_BatchVariant."Unit of Measure Code" := vrc_PurchaseLine."Unit of Measure Code";
        lrc_BatchVariant."Qty. per Unit of Measure" := vrc_PurchaseLine."Qty. per Unit of Measure";

        lrc_BatchVariant."Content Unit of Measure (CP)" := vrc_PurchaseLine."POI Content Unit of Meas (COU)";
        lrc_BatchVariant."Packing Unit of Measure (PU)" := vrc_PurchaseLine."POI Packing Unit of Meas (PU)";
        lrc_BatchVariant."Qty. (PU) per Collo (CU)" := vrc_PurchaseLine."POI Qty. (PU) per Unit of Meas";
        lrc_BatchVariant."Transport Unit of Measure (TU)" := vrc_PurchaseLine."POI Transport Unit of Meas(TU)";
        lrc_BatchVariant."Qty. (Unit) per Transp. (TU)" := vrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)";
        lrc_BatchVariant."No. of Layers on TU" := vrc_PurchaseLine."POI No. of Layers on TU";

        lrc_BatchVariant."Vendor No." := vrc_PurchaseLine."Buy-from Vendor No.";
        IF lrc_Vendor.GET(lrc_BatchVariant."Vendor No.") THEN
            lrc_BatchVariant."Vendor Search Name" := lrc_Vendor."Search Name";
        //  "B/L Shipper" := lrc_Vendor."B/L Shipper";

        lrc_BatchVariant."Producer No." := vrc_PurchaseLine."POI Manufacturer Code";

        lrc_BatchVariant."Country of Origin Code" := vrc_PurchaseLine."POI Country of Origin Code";
        lrc_BatchVariant."Variety Code" := vrc_PurchaseLine."POI Variety Code";
        lrc_BatchVariant."Trademark Code" := vrc_PurchaseLine."POI Trademark Code";
        lrc_BatchVariant."Caliber Code" := vrc_PurchaseLine."POI Caliber Code";
        lrc_BatchVariant."Vendor Caliber Code" := vrc_PurchaseLine."POI Vendor Caliber Code";
        lrc_BatchVariant."Item Attribute 3" := vrc_PurchaseLine."POI Item Attribute 3";
        lrc_BatchVariant."Item Attribute 2" := vrc_PurchaseLine."POI Item Attribute 2";
        lrc_BatchVariant."Grade of Goods Code" := vrc_PurchaseLine."POI Grade of Goods Code";
        lrc_BatchVariant."Item Attribute 7" := vrc_PurchaseLine."POI Item Attribute 7";
        lrc_BatchVariant."Item Attribute 5" := vrc_PurchaseLine."POI Item Attribute 5";
        lrc_BatchVariant."Item Attribute 6" := vrc_PurchaseLine."POI Item Attribute 6";
        lrc_BatchVariant."Item Attribute 4" := vrc_PurchaseLine."POI Item Attribute 4";
        lrc_BatchVariant."Coding Code" := vrc_PurchaseLine."POI Coding Code";
        lrc_BatchVariant."Cultivation Association Code" := vrc_PurchaseLine."POI Cultivation Associat. Code";
        lrc_BatchVariant."Item Attribute 1" := vrc_PurchaseLine."POI Item Attribute 1";
        lrc_BatchVariant."Cultivation Type" := vrc_PurchaseLine."POI Cultivation Type";

        lrc_BatchVariant."Net Weight" := vrc_PurchaseLine."Net Weight";
        lrc_BatchVariant."Gross Weight" := vrc_PurchaseLine."Gross Weight";
        lrc_BatchVariant."Average Customs Weight" := vrc_PurchaseLine."POI Customs Weight (Average)";

        lrc_BatchVariant."Original Quantity" := vrc_PurchaseLine."POI Originally Qty (Order)";

        lrc_BatchVariant."Departure Date" := lrc_PurchHeader."POI Departure Date";
        lrc_BatchVariant."Order Date" := vrc_PurchaseLine."Order Date";
        lrc_BatchVariant."Date of Delivery" := lrc_PurchHeader."Expected Receipt Date";
        IF lrc_PurchHeader."Promised Receipt Date" <> 0D THEN
            lrc_BatchVariant."Date of Delivery" := lrc_PurchHeader."Promised Receipt Date";

        lrc_BatchVariant."Date of Expiry" := vrc_PurchaseLine."POI Date of Expiry";

        lrc_BatchVariant."Kind of Settlement" := vrc_PurchaseLine."POI Kind of Settlement";
        lrc_BatchVariant.Weight := vrc_PurchaseLine."POI Weight";
        IF vrc_PurchaseLine."POI Lot No. Producer" <> '' THEN
            lrc_BatchVariant."Lot No. Producer" := vrc_PurchaseLine."POI Lot No. Producer";

        lrc_BatchVariant."Entry via Transfer Loc. Code" := vrc_PurchaseLine."POI Entry via Trans Loc. Code";
        lrc_BatchVariant."Entry Location Code" := vrc_PurchaseLine."Location Code";
        lrc_BatchVariant."Location Reference No." := vrc_PurchaseLine."POI Location Reference No.";
        lrc_BatchVariant."Shelf No." := vrc_PurchaseLine."POI Shelf No.";

        lrc_BatchVariant."Info 1" := vrc_PurchaseLine."POI Info 1";
        lrc_BatchVariant."Info 2" := vrc_PurchaseLine."POI Info 2";
        lrc_BatchVariant."Info 3" := vrc_PurchaseLine."POI Info 3";
        lrc_BatchVariant."Info 4" := vrc_PurchaseLine."POI Info 4";

        lrc_BatchVariant."Kind of Loading" := vrc_PurchaseLine."POI Kind of Loading";
        lrc_BatchVariant."Shipping Agent Code" := vrc_PurchaseLine."POI Shipping Agent Code";
        lrc_BatchVariant."Fiscal Agent Code" := lrc_PurchHeader."POI Fiscal Agent Code";
        lrc_BatchVariant."Departure Location Code" := lrc_PurchHeader."POI Departure Location Code";

        lrc_BatchVariant."Voyage No." := vrc_PurchaseLine."POI Voyage No.";
        lrc_BatchVariant."Container No." := vrc_PurchaseLine."POI Container No.";
        lrc_BatchVariant."Means of Transport Type" := lrc_PurchHeader."POI Means of Transport Type";
        lrc_BatchVariant."Means of Transp. Code (Depart)" := lrc_PurchHeader."POI Means of Transp.Code(Dep.)";
        lrc_BatchVariant."Means of Transp. Code (Arriva)" := lrc_PurchHeader."POI Means of TransCode(Arriva)";
        lrc_BatchVariant."Means of Transport Info" := lrc_PurchHeader."POI Means of Transport Info";
        lrc_BatchVariant."Port of Discharge Code" := vrc_PurchaseLine."POI Port of Disch. Code (UDE)";
        lrc_BatchVariant."Date of Discharge" := vrc_PurchaseLine."POI Date of Discharge";
        lrc_BatchVariant."Time of Discharge" := vrc_PurchaseLine."POI Time of Discharge";
        lrc_BatchVariant."Waste Disposal Duty" := vrc_PurchaseLine."POI Waste Disposal Duty";
        lrc_BatchVariant."Waste Disposal Payment By" := vrc_PurchaseLine."POI Waste Disposal Paymt Thru";
        lrc_BatchVariant."Status Customs Duty" := vrc_PurchaseLine."POI Status Customs Duty";

        lrc_BatchVariant."Empties Item No." := vrc_PurchaseLine."POI Empties Item No.";
        lrc_BatchVariant."Empties Quantity" := vrc_PurchaseLine."POI Empties Quantity";

        lrc_BatchVariant."Company Season Code" := '';

        lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Purch. Order";
        lrc_BatchVariant."Source No." := vrc_PurchaseLine."Document No.";
        lrc_BatchVariant."Source Line No." := vrc_PurchaseLine."Line No.";
        lrc_BatchVariant."Source Company" := copystr(COMPANYNAME(), 1, 30);

        IF lrc_ADFSetup."Create Search No from BatchVar" = TRUE THEN
            lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item, lrc_BatchVariant)
        ELSE
            lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);


        lrc_BatchVariant."B/L Shipper" := vrc_PurchaseLine."POI B/L Shipper";
        lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
        lrc_BatchVariant."Purch. Doc. Subtype Code" := lrc_PurchHeader."POI Purch. Doc. Subtype Code";
        lrc_BatchVariant."Shortcut Dimension 1 Code" := vrc_PurchaseLine."Shortcut Dimension 1 Code";
        lrc_BatchVariant."Shortcut Dimension 2 Code" := vrc_PurchaseLine."Shortcut Dimension 2 Code";
        lrc_BatchVariant."Shortcut Dimension 3 Code" := vrc_PurchaseLine."POI Shortcut Dimension 3 Code";
        lrc_BatchVariant."Shortcut Dimension 4 Code" := vrc_PurchaseLine."POI Shortcut Dimension 4 Code";

        lrc_BatchVariant."Guaranteed Shelf Life" := lrc_Item."POI Guarant. Shelf Life Purch.";

        // Bewertungen
        lrc_BatchVariant."Price Base (Purch. Price)" := vrc_PurchaseLine."POI Price Base (Purch. Price)";
        lrc_BatchVariant."Purch. Price (Price Base)" := vrc_PurchaseLine."POI Purch. Price (Price Base)";
        lrc_BatchVariant."Market Unit Cost (Base) (LCY)" := vrc_PurchaseLine."POI Mark Unit Cost(Basis)(LCY)";
        IF lrc_PurchHeader."Currency Code" = '' THEN BEGIN
            lrc_BatchVariant."Purch. Price (UOM) (LCY)" := vrc_PurchaseLine."Direct Unit Cost";
            lrc_BatchVariant."Purch. Price Net (UOM) (LCY)" := vrc_PurchaseLine."Direct Unit Cost";
        END ELSE BEGIN
            lrc_BatchVariant."Purch. Price (UOM) (LCY)" := vrc_PurchaseLine."Direct Unit Cost" *
                                                           lrc_PurchHeader."Currency Factor";
            lrc_BatchVariant."Purch. Price Net (UOM) (LCY)" := vrc_PurchaseLine."Direct Unit Cost" *
                                                               lrc_PurchHeader."Currency Factor";
        END;
        lrc_BatchVariant."Indirect Cost %" := vrc_PurchaseLine."Indirect Cost %";
        lrc_BatchVariant."Indirect Cost Amount" := vrc_PurchaseLine."POI Indirect Cost Amount (LCY)";
        lrc_BatchVariant."Unit Cost (UOM) (LCY)" := vrc_PurchaseLine."Unit Cost (LCY)";

        lrc_BatchVariant."Price Base (Sales Price)" := vrc_PurchaseLine."POI Price Base (Sales Price)";
        lrc_BatchVariant."Sales Price (Price Base)" := vrc_PurchaseLine."POI Sal Price(Price Base)(LCY)";

        lrc_BatchVariant."Customer Group Code" := vrc_PurchaseLine."POI Customer Group Code";
        lrc_BatchVariant.EAN := vrc_PurchaseLine."POI ean";
        lrc_BatchVariant."PLU-Code" := vrc_PurchaseLine."POI PLU-Code";

        lrc_BatchVariant.INSERT();

        // Rückgabewerte setzen
        rco_BatchCode := lco_BatchCode;
        rco_BatchVariantCode := BatchVariantCode;
    end;

    //     procedure BatchVarUpdFromPurchLine(vrc_PurchaseLine: Record "39")
    //     var
    //         lcu_BaseDataTemplateMgt: Codeunit "5087929";
    //         lrc_ADFSetup: Record "5110302";
    //         lrc_PurchHeader: Record "38";
    //         lrc_PurchaseLine: Record "39";
    //         lrc_PurchDocSubtype: Record "5110410";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_Vendor: Record "Vendor";
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Aktualisierung einer vorhandenen Positionsvariante
    //         // ------------------------------------------------------------------------------------------

    //         // Prüfen ob Zeile zulässig
    //         IF (vrc_PurchaseLine."Document Type" <> vrc_PurchaseLine."Document Type"::Order) OR
    //            (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR
    //            (vrc_PurchaseLine."No." = '') OR
    //            (vrc_PurchaseLine."Batch Variant No." = '') THEN
    //           EXIT;

    //         // Einkaufskopfsatz lesen
    //         lrc_PurchHeader.GET(vrc_PurchaseLine."Document Type",vrc_PurchaseLine."Document No.");
    //         // Belegunterartensatz lesen
    //         lrc_PurchDocSubtype.GET(lrc_PurchHeader."Document Type",lrc_PurchHeader."Purch. Doc. Subtype Code");

    //         IF lrc_PurchDocSubtype."Batchsystem activ" = FALSE THEN
    //           EXIT;

    //         // Positionsvariante lesen (ansonsten beenden)
    //         IF NOT lrc_BatchVariant.GET(vrc_PurchaseLine."Batch Variant No.") THEN
    //           EXIT;

    //         // Artikelstammsatz lesen
    //         lrc_Item.GET(vrc_PurchaseLine."No.");

    //         lrc_BatchVariant.Description := vrc_PurchaseLine.Description;
    //         lrc_BatchVariant."Description 2" := vrc_PurchaseLine."Description 2";
    //         IF (lrc_BatchVariant.Description = '') THEN BEGIN
    //           lrc_BatchVariant.Description := lrc_Item.Description;
    //         END;
    //         IF (lrc_BatchVariant."Description 2" = '') THEN BEGIN
    //           lrc_BatchVariant."Description 2" := lrc_Item."Description 2";
    //         END;

    //         lrc_BatchVariant."Item No." := vrc_PurchaseLine."No.";
    //         lrc_BatchVariant."Variant Code" := vrc_PurchaseLine."Variant Code";

    //         lrc_BatchVariant."Master Batch No." := lrc_PurchHeader."Master Batch No.";
    //         lrc_BatchVariant."Batch No." := vrc_PurchaseLine."Batch No.";

    //         // Hierarchie
    //         lrc_BatchVariant."Item Main Category Code" := lrc_Item."Item Main Category Code";
    //         lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
    //         lrc_BatchVariant."Product Group Code" := lrc_Item."Product Group Code";

    //         // Merkmale
    //         lrc_BatchVariant."Country of Origin Code" := vrc_PurchaseLine."Country of Origin Code";
    //         lrc_BatchVariant."Variety Code" := vrc_PurchaseLine."Variety Code";
    //         lrc_BatchVariant."Trademark Code" := vrc_PurchaseLine."Trademark Code";
    //         lrc_BatchVariant."Caliber Code" := vrc_PurchaseLine."Caliber Code";
    //         lrc_BatchVariant."Vendor Caliber Code" := vrc_PurchaseLine."Vendor Caliber Code";
    //         lrc_BatchVariant."Item Attribute 3" := vrc_PurchaseLine."Item Attribute 3";
    //         lrc_BatchVariant."Item Attribute 2" := vrc_PurchaseLine."Item Attribute 2";
    //         lrc_BatchVariant."Grade of Goods Code" := vrc_PurchaseLine."Grade of Goods Code";
    //         lrc_BatchVariant."Item Attribute 7" := vrc_PurchaseLine."Item Attribute 7";
    //         lrc_BatchVariant."Item Attribute 5" := vrc_PurchaseLine."Item Attribute 5";
    //         lrc_BatchVariant."Item Attribute 6" := vrc_PurchaseLine."Item Attribute 6";
    //         lrc_BatchVariant."Item Attribute 4" := vrc_PurchaseLine."Item Attribute 4";
    //         lrc_BatchVariant."Coding Code" := vrc_PurchaseLine."Coding Code";
    //         lrc_BatchVariant."Cultivation Type" := vrc_PurchaseLine."Cultivation Type";
    //         lrc_BatchVariant."Cultivation Association Code" := vrc_PurchaseLine."Cultivation Association Code";
    //         lrc_BatchVariant."Item Attribute 1" := vrc_PurchaseLine."Item Attribute 1";

    //         IF lrc_BatchVariant."Vendor No." <> lrc_PurchHeader."Buy-from Vendor No." THEN BEGIN
    //           lrc_BatchVariant."Vendor No." := lrc_PurchHeader."Buy-from Vendor No.";
    //           IF lrc_Vendor.GET(lrc_PurchHeader."Buy-from Vendor No.") THEN
    //             lrc_BatchVariant."Vendor Search Name" := lrc_Vendor."Search Name";
    //         //  "B/L Shipper" := lrc_Vendor."B/L Shipper";
    //         END;
    //         lrc_BatchVariant."Producer No." := vrc_PurchaseLine."Manufacturer Code";

    //         lrc_BatchVariant."Net Weight" := vrc_PurchaseLine."Net Weight";
    //         lrc_BatchVariant."Gross Weight" := vrc_PurchaseLine."Gross Weight";
    //         lrc_BatchVariant."Average Customs Weight" := vrc_PurchaseLine."Customs Weight (Average)";

    //         lrc_BatchVariant."Departure Date" := lrc_PurchHeader."Departure Date";
    //         lrc_BatchVariant."Order Date" := lrc_PurchHeader."Order Date";
    //         lrc_BatchVariant."Date of Delivery" := vrc_PurchaseLine."Expected Receipt Date";
    //         IF vrc_PurchaseLine."Promised Receipt Date" <> 0D THEN
    //           lrc_BatchVariant."Date of Delivery" := vrc_PurchaseLine."Promised Receipt Date";

    //         lrc_BatchVariant."Kind of Settlement" := vrc_PurchaseLine."Kind of Settlement";
    //         lrc_BatchVariant.Weight := vrc_PurchaseLine.Weight;
    //         lrc_BatchVariant."Lot No. Producer" := vrc_PurchaseLine."Lot No. Producer";
    //         lrc_BatchVariant."Entry via Transfer Loc. Code" := vrc_PurchaseLine."Entry via Transfer Loc. Code";
    //         lrc_BatchVariant."Entry Location Code" := vrc_PurchaseLine."Location Code";
    //         lrc_BatchVariant."Location Reference No." := vrc_PurchaseLine."Location Reference No.";
    //         lrc_BatchVariant."Shelf No." := vrc_PurchaseLine."Shelf No.";

    //         lrc_BatchVariant."Info 1" := vrc_PurchaseLine."Info 1";
    //         lrc_BatchVariant."Info 2" := vrc_PurchaseLine."Info 2";
    //         lrc_BatchVariant."Info 3" := vrc_PurchaseLine."Info 3";
    //         lrc_BatchVariant."Info 4" := vrc_PurchaseLine."Info 4";

    //         lrc_BatchVariant."Date of Expiry" := vrc_PurchaseLine."Date of Expiry";
    //         lrc_BatchVariant."Kind of Loading" := vrc_PurchaseLine."Kind of Loading";
    //         lrc_BatchVariant."Shipping Agent Code" := vrc_PurchaseLine."Shipping Agent Code";
    //         lrc_BatchVariant."Fiscal Agent Code" := lrc_PurchHeader."Fiscal Agent Code";
    //         lrc_BatchVariant."Voyage No." := vrc_PurchaseLine."Voyage No.";
    //         lrc_BatchVariant."Container No." := vrc_PurchaseLine."Container No.";
    //         lrc_BatchVariant."Means of Transport Type" := lrc_PurchHeader."Means of Transport Type";
    //         lrc_BatchVariant."Means of Transp. Code (Depart)" := lrc_PurchHeader."Means of Transp. Code (Depart)";
    //         lrc_BatchVariant."Means of Transp. Code (Arriva)" := lrc_PurchHeader."Means of Transp. Code (Arriva)";
    //         lrc_BatchVariant."Means of Transport Info" := lrc_PurchHeader."Means of Transport Info";
    //         lrc_BatchVariant."Port of Discharge Code" := vrc_PurchaseLine."Port of Discharge Code (UDE)";
    //         lrc_BatchVariant."Date of Discharge" := vrc_PurchaseLine."Date of Discharge";
    //         lrc_BatchVariant."Time of Discharge" := vrc_PurchaseLine."Time of Discharge";
    //         lrc_BatchVariant."Waste Disposal Duty" := vrc_PurchaseLine."Waste Disposal Duty";
    //         lrc_BatchVariant."Waste Disposal Payment By" := vrc_PurchaseLine."Waste Disposal Payment Thru";
    //         lrc_BatchVariant."Status Customs Duty" := vrc_PurchaseLine."Status Customs Duty";

    //         lrc_BatchVariant."Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
    //         lrc_BatchVariant."Unit of Measure Code" := vrc_PurchaseLine."Unit of Measure Code";
    //         lrc_BatchVariant."Qty. per Unit of Measure" := vrc_PurchaseLine."Qty. per Unit of Measure";

    //         // Verpackungseinheit und Menge Verpackungen pro Einkaufseinheit
    //         lrc_BatchVariant."Packing Unit of Measure (PU)" := vrc_PurchaseLine."Packing Unit of Measure (PU)";
    //         lrc_BatchVariant."Qty. (PU) per Collo (CU)" := vrc_PurchaseLine."Qty. (PU) per Unit of Measure";
    //         lrc_BatchVariant."Content Unit of Measure (CP)" := vrc_PurchaseLine."Content Unit of Measure (COU)";

    //         // Transporteinheit und Menge Einkaufseinheiten pro Transporteinheit
    //         lrc_BatchVariant."Transport Unit of Measure (TU)" := vrc_PurchaseLine."Transport Unit of Measure (TU)";
    //         lrc_BatchVariant."Qty. (Unit) per Transp. (TU)" := vrc_PurchaseLine."Qty. (Unit) per Transp.(TU)";
    //         lrc_BatchVariant."No. of Layers on TU" := vrc_PurchaseLine."No. of Layers on TU";

    //         lrc_BatchVariant."Empties Item No." := vrc_PurchaseLine."Empties Item No.";
    //         lrc_BatchVariant."Empties Quantity" := vrc_PurchaseLine."Empties Quantity";

    //         // Herkunft Positionsvariante
    //         lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Purch. Order";
    //         lrc_BatchVariant."Source No." := vrc_PurchaseLine."Document No.";
    //         lrc_BatchVariant."Source Line No." := vrc_PurchaseLine."Line No.";

    //         lrc_ADFSetup.GET();
    //         IF lrc_ADFSetup."Create Search No from BatchVar" = TRUE THEN BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item,lrc_BatchVariant);
    //         END ELSE BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);
    //         END;

    //         lrc_BatchVariant."B/L Shipper" := vrc_PurchaseLine."B/L Shipper";

    //         lrc_BatchVariant."Original Quantity" := vrc_PurchaseLine."Originally Qty (Order)";
    //         lrc_BatchVariant."Purch. Doc. Subtype Code" := lrc_PurchHeader."Purch. Doc. Subtype Code";

    //         lrc_BatchVariant."Shortcut Dimension 1 Code" := vrc_PurchaseLine."Shortcut Dimension 1 Code";
    //         lrc_BatchVariant."Shortcut Dimension 2 Code" := vrc_PurchaseLine."Shortcut Dimension 2 Code";
    //         lrc_BatchVariant."Shortcut Dimension 3 Code" := vrc_PurchaseLine."Shortcut Dimension 3 Code";
    //         lrc_BatchVariant."Shortcut Dimension 4 Code" := vrc_PurchaseLine."Shortcut Dimension 4 Code";

    //         // Bewertungen
    //         lrc_BatchVariant."Price Base (Purch. Price)" := vrc_PurchaseLine."Price Base (Purch. Price)";
    //         lrc_BatchVariant."Purch. Price (Price Base)" := vrc_PurchaseLine."Purch. Price (Price Base)";
    //         lrc_BatchVariant."Market Unit Cost (Base) (LCY)" := vrc_PurchaseLine."Market Unit Cost (Basis) (LCY)";
    //         IF lrc_PurchHeader."Currency Code" = '' THEN BEGIN
    //           lrc_BatchVariant."Purch. Price (UOM) (LCY)" := vrc_PurchaseLine."Direct Unit Cost";
    //           lrc_BatchVariant."Purch. Price Net (UOM) (LCY)" := vrc_PurchaseLine."Direct Unit Cost";
    //         END ELSE BEGIN
    //           lrc_BatchVariant."Purch. Price (UOM) (LCY)" := vrc_PurchaseLine."Direct Unit Cost" *
    //                                                          lrc_PurchHeader."Currency Factor";
    //           lrc_BatchVariant."Purch. Price Net (UOM) (LCY)" := vrc_PurchaseLine."Direct Unit Cost" *
    //                                                              lrc_PurchHeader."Currency Factor";
    //         END;
    //         lrc_BatchVariant."Indirect Cost %" := vrc_PurchaseLine."Indirect Cost %";
    //         lrc_BatchVariant."Indirect Cost Amount" := vrc_PurchaseLine."Indirect Cost Amount (LCY)";
    //         lrc_BatchVariant."Unit Cost (UOM) (LCY)" := vrc_PurchaseLine."Unit Cost (LCY)";

    //         lrc_BatchVariant."Price Base (Sales Price)" := vrc_PurchaseLine."Price Base (Sales Price)";
    //         lrc_BatchVariant."Sales Price (Price Base)" := vrc_PurchaseLine."Sales Price (Price Base) (LCY)";

    //         lrc_BatchVariant."Departure Location Code" := lrc_PurchHeader."Departure Location Code";

    //         //160919 rs
    //         lrc_BatchVariant."Customer Group Code" := vrc_PurchaseLine."Customer Group Code";
    //         lrc_BatchVariant.EAN := vrc_PurchaseLine.ean;
    //         lrc_BatchVariant."PLU-Code" := vrc_PurchaseLine."PLU-Code";
    //         //160919 rs.e

    //         lrc_BatchVariant.MODIFY();

    //         UpdateBatchFromBatchVariant(lrc_BatchVariant);

    //         IF lrc_BatchVariant."No." <> '' THEN BEGIN
    //           IF NOT lrc_PurchaseLine.GET(vrc_PurchaseLine."Document Type",vrc_PurchaseLine."Document No.",
    //                                       vrc_PurchaseLine."Line No.") THEN
    //             lrc_PurchaseLine.INIT();
    //           BatchVariantRecalc_Ins_Mod(lrc_BatchVariant."Item No.", lrc_BatchVariant."No.",
    //                                      vrc_PurchaseLine."Outstanding Qty. (Base)" - lrc_PurchaseLine."Outstanding Qty. (Base)");
    //         END;

    //         SetBatchStatusOpen(vrc_PurchaseLine."Batch No.");
    //     end;

    //     procedure BatchVarShowCard(vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lfm_BatchVariantCard: Form "5110483";
    //         ADF_LT_TEXT001: Label 'A batch variant no. does not exist !';
    //     begin
    //         // ------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Positionsvariantenkarte
    //         // ------------------------------------------------------------------------------

    //         IF vco_BatchVariantNo = '' THEN
    //           // Es existiert keine Positionsvariantennummer!
    //           ERROR(ADF_LT_TEXT001);

    //         lrc_BatchVariant.FILTERGROUP(2);
    //         lrc_BatchVariant.SETRANGE("No.",vco_BatchVariantNo);
    //         lrc_BatchVariant.FILTERGROUP(0);
    //         lrc_BatchVariant.FINDFIRST();

    //         lfm_BatchVariantCard.SETTABLEVIEW(lrc_BatchVariant);
    //         CASE lrc_BatchVariant.Source OF
    //         lrc_BatchVariant.Source::Dummy:
    //           BEGIN
    //             lfm_BatchVariantCard.EDITABLE := TRUE;
    //           END;
    //         ELSE
    //           lfm_BatchVariantCard.EDITABLE := FALSE;
    //         END;

    //         lfm_BatchVariantCard.RUNMODAL;
    //     end;

    procedure BatchVarUpdFromPurchHeader(var rrc_PurchHeader: Record "Purchase Header")
    var
        lrc_Vendor: Record Vendor;
    begin
        // ----------------------------------------------------------------------------
        // Aktualisierung allen Positionsvarianten von einer vorhandenen Partienr.
        // ----------------------------------------------------------------------------

        // Vergabe Partienummer gilt per Definition nur für Bestellungen
        IF rrc_PurchHeader."Document Type" <> rrc_PurchHeader."Document Type"::Order THEN
            EXIT;

        // Kontrolle ob eine Partienummer vorhanden ist
        IF rrc_PurchHeader."POI Master Batch No." = '' THEN
            EXIT;

        // Master Batch (Partie) lesen
        lrc_MasterBatch.GET(rrc_PurchHeader."POI Master Batch No.");

        // Finden alle Positionsvarianten, die zu Partie gehören, und diese aktualisieren
        lrc_BatchVariant.RESET();
        lrc_BatchVariant.SETCURRENTKEY("Master Batch No.", "Batch No.");
        lrc_BatchVariant.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
        IF lrc_BatchVariant.FINDSET(TRUE, FALSE) THEN
            REPEAT
                lrc_BatchVariant."Master Batch No." := rrc_PurchHeader."POI Master Batch No.";
                IF lrc_BatchVariant."Vendor No." <> rrc_PurchHeader."Buy-from Vendor No." THEN BEGIN
                    lrc_BatchVariant."Vendor No." := rrc_PurchHeader."Buy-from Vendor No.";
                    IF lrc_Vendor.GET(rrc_PurchHeader."Buy-from Vendor No.") THEN
                        lrc_BatchVariant."Vendor Search Name" := lrc_Vendor."Search Name";
                    //  "B/L Shipper" := lrc_Vendor."B/L Shipper";
                END;
                lrc_BatchVariant."Departure Date" := rrc_PurchHeader."POI Departure Date";
                lrc_BatchVariant."Order Date" := rrc_PurchHeader."Order Date";
                lrc_BatchVariant."Means of Transport Type" := rrc_PurchHeader."POI Means of Transport Type";
                lrc_BatchVariant."Means of Transp. Code (Depart)" := rrc_PurchHeader."POI Means of Transp.Code(Dep.)";
                lrc_BatchVariant."Means of Transp. Code (Arriva)" := rrc_PurchHeader."POI Means of TransCode(Arriva)";
                lrc_BatchVariant."Means of Transport Info" := rrc_PurchHeader."POI Means of Transport Info";
                lrc_BatchVariant."Port of Discharge Code" := rrc_PurchHeader."POI Port of Disch. Code (UDE)";
                lrc_BatchVariant."Date of Discharge" := rrc_PurchHeader."POI Expected Discharge Date";
                lrc_BatchVariant."Time of Discharge" := rrc_PurchHeader."POI Expected Discharge Time";
                lrc_BatchVariant."Purch. Doc. Subtype Code" := rrc_PurchHeader."POI Purch. Doc. Subtype Code";
                lrc_BatchVariant."Fiscal Agent Code" := rrc_PurchHeader."POI Fiscal Agent Code";
                lrc_BatchVariant."Departure Location Code" := rrc_PurchHeader."POI Departure Location Code";
                lrc_BatchVariant.MODIFY();
            UNTIL lrc_BatchVariant.NEXT() = 0;
    end;

    //     procedure BatchVarNewBatchVar(vrc_BatchVariant: Record "5110366";vbn_Splitt: Boolean;var rco_BatchCode: Code[20];var rco_BatchVariantCode: Code[20])
    //     var
    //         BatchManagement: Codeunit "5110307";
    //         GlobalFunctions: Codeunit "5110300";
    //         lcu_BaseData: Codeunit "5110301";
    //         NoSeriesManagement: Codeunit "396";
    //         lrc_PurchDocType: Record "5110410";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_PurchaseHdr: Record "38";
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_UnitofMeasure: Record "204";
    //         lco_BatchCode: Code[20];
    //         BatchVariantCode: Code[20];
    //         TEXT001: Label 'Positionsnummer konnte nicht ermittelt werden!';
    //         TEXT003: Label 'Die Vergabe der Positionsvariantennummer ist fehlgeschlagen!';
    //         TEXT004: Label 'Vergabe über Setup Einrichtung nicht mehr aktiv!';
    //         AGILES_LT_TEXT005: Label 'Keine Zuordnung!';
    //         AGILES_LT_TEXT006: Label 'Nicht codiert!';
    //         AGILES_LT_TEXT007: Label 'Keine Zuordnung für %1 die dortige Positionsvariantennr.!';
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Anlage einer neuen Positionsvariante auf Basis einer bestehenden für Reklamation
    //         // ----------------------------------------------------------------------------------

    //         // Partie Setup lesen
    //         lrc_BatchSetup.GET();

    //         // Kontrolle ob das Partiewesen aktiv ist
    //         IF lrc_BatchSetup."Batchsystem activ" = FALSE THEN
    //           EXIT;

    //         // Artikel lesen und Kontrolle ob Artikel Batchgeführt ist
    //         lrc_Item.GET(vrc_BatchVariant."Item No.");
    //         IF lrc_Item."Batch Item" = FALSE THEN
    //           EXIT;

    //         // Einkaufskopfsatz lesen
    //         //?? lrc_PurchaseHdr.GET(vrc_PurchaseLine."Document Type",vrc_PurchaseLine."Document No.");
    //         // Einkaufsbelegart lesen
    //         //?? lrc_PurchDocType.GET(lrc_PurchaseHdr."Document Type",lrc_PurchaseHdr."Purch. Doc. Subtype Code");

    //         // --------------------------------------------------------------------------
    //         // Vergabe Positionsvariante über Einkaufsbelegart
    //         // --------------------------------------------------------------------------
    //         IF lrc_PurchDocType."Allocation BatchNo. by Doc.Typ" = TRUE THEN BEGIN

    //           IF lrc_PurchDocType."Batchsystem activ" = FALSE THEN
    //             EXIT;

    //           // Kontrolle ob Partienummer vergeben wurde
    //           vrc_BatchVariant.TESTFIELD("Master Batch No.");
    //           // Kontrolle ob Positionsnummer vergeben wurde
    //           vrc_BatchVariant.TESTFIELD("Batch No.");
    //           lco_BatchCode := vrc_BatchVariant."Batch No.";

    //           // Positionsvariantennummer erstellen
    //           CASE lrc_PurchDocType."Source Batch Variant" OF
    //           lrc_PurchDocType."Source Batch Variant"::"No. Series" :
    //             BEGIN
    //               lrc_PurchDocType.TESTFIELD("Batch Variant No. Series");
    //               BatchVariantCode := NoSeriesManagement.GetNextNo(lrc_PurchDocType."Batch Variant No. Series",
    //                                                                WORKDATE,TRUE);
    //             END;

    //           lrc_PurchDocType."Source Batch Variant"::"Batch No. + Postfix" :
    //             BEGIN
    //               // Postfixzähler ermitteln
    //               lrc_Batch.GET(lco_BatchCode);
    //               lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
    //               lrc_Batch.MODIFY();

    //               BatchVariantCode := lco_BatchCode + lrc_PurchDocType."Batch Variant Separator" +
    //                                   GlobalFunctions.FormatIntegerWithBeginningZero(
    //                                     lrc_Batch."Batch Variant Postfix Counter",
    //                                     lrc_PurchDocType."Batch Variant Postfix Places");
    //             END;
    //           lrc_PurchDocType."Source Batch Variant"::"Batch No. + Postfix" :
    //             BEGIN
    //               ERROR('Nicht möglich für Splitt Positionsvariante!');
    //               // BatchVariantCode := lrc_BatchVariant."Batch No.";
    //             END;
    //           ELSE
    //             // Keine Zuordnung!
    //             ERROR(AGILES_LT_TEXT005);
    //           END;

    //         // Vergabe Positionsvariante über Setup Einrichtung
    //         END ELSE BEGIN
    //           // Vergabe über Setup Einrichtung nicht mehr aktiv!
    //           ERROR(TEXT004);
    //         END;

    //         IF BatchVariantCode = '' THEN
    //           // Die Vergabe der Positionsvariantennummer ist fehlgeschlagen!
    //           ERROR(TEXT003);

    //         // Status Position auf offen setzen
    //         SetBatchStatusOpen(lco_BatchCode);

    //         // --------------------------------------------------------------------
    //         // Positionsvariante anlegen
    //         // --------------------------------------------------------------------
    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.INIT();
    //         lrc_BatchVariant := vrc_BatchVariant;
    //         lrc_BatchVariant."Batch No." := lco_BatchCode;
    //         lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
    //         lrc_BatchVariant."Guaranteed Shelf Life" := lrc_Item."Guaranteed Shelf Life Purch.";
    //         lrc_BatchVariant.insert();

    //         // Rückgabewerte setzen
    //         rco_BatchCode := lco_BatchCode;
    //         rco_BatchVariantCode := BatchVariantCode;
    //     end;

    //     procedure BatchVarCheckPosting()
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum Prüfen ob Buchungen auf der Positionsvariante sind
    //         // ---------------------------------------------------------------------------------------------
    //     end;

    //     procedure BatchVarCopyToPlanMasterBatch(vco_BatchVarNo: Code[20];vbn_OpenCard: Boolean)
    //     var
    //         lcu_NoSeriesMgt: Codeunit "396";
    //         lrc_MasterBatchSetup: Record "5110363";
    //         lrc_FromBatch: Record "5110365";
    //         lrc_FromBatchVariant: Record "5110366";
    //         lrc_NewBatch: Record "5110365";
    //         lrc_NewBatchVariant: Record "5110366";
    //         lrc_DimensionValue: Record "349";
    //         lfm_BatchVariantCard: Form "5110483";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zum Kopieren einer Positionsnr. in die Eink.-Planungspartie
    //         // ---------------------------------------------------------------------------------------------

    //         lrc_MasterBatchSetup.GET();
    //         lrc_MasterBatchSetup.TESTFIELD("Purch. Plan Master Batch No.");
    //         lrc_MasterBatchSetup.TESTFIELD("Purch. Plan Batch No. Series");

    //         lrc_FromBatchVariant.GET(vco_BatchVarNo);
    //         lrc_FromBatch.GET(lrc_FromBatchVariant."Batch No.");

    //         lrc_NewBatch := lrc_FromBatch;
    //         lrc_NewBatch."No." := lcu_NoSeriesMgt.GetNextNo(lrc_MasterBatchSetup."Purch. Plan Batch No. Series",WORKDATE,TRUE);
    //         lrc_NewBatch."Master Batch No." := lrc_MasterBatchSetup."Purch. Plan Master Batch No.";
    //         lrc_NewBatch.Source := lrc_NewBatch.Source::Dummy;
    //         lrc_NewBatch."Source No." := '';
    //         lrc_NewBatch."Source Line No." := 0;
    //         lrc_NewBatch.INSERT(TRUE);

    //         // Kontrolle auf Dimensionsanlage und Anlage der Position als Dimension
    //         IF lrc_MasterBatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
    //           lrc_DimensionValue.RESET();
    //           lrc_DimensionValue.INIT();
    //           lrc_DimensionValue."Dimension Code" := lrc_MasterBatchSetup."Dim. Code Batch No.";
    //           lrc_DimensionValue.Code := lrc_NewBatch."No.";
    //           lrc_DimensionValue.Name := lrc_MasterBatchSetup."Dim. Code Batch No.";
    //           lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
    //           lrc_DimensionValue."Global Dimension No." := lrc_MasterBatchSetup."Dim. No. Batch No.";
    //           lrc_DimensionValue.insert();
    //           //RS Anlage Partie als Dimension
    //           IF NOT lrc_DimensionValue.GET('PARTIE', lrc_NewBatch."Master Batch No.") THEN BEGIN
    //             lrc_DimensionValue.RESET();
    //             lrc_DimensionValue.INIT();
    //             lrc_DimensionValue."Dimension Code" := 'PARTIE';
    //             lrc_DimensionValue.Code := lrc_NewBatch."Master Batch No.";
    //             lrc_DimensionValue.Name := lrc_NewBatch."Master Batch No.";
    //             lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
    //             lrc_DimensionValue.insert();
    //           END;
    //         END;

    //         lrc_NewBatchVariant := lrc_FromBatchVariant;
    //         lrc_NewBatchVariant."No." := lrc_NewBatch."No." + '1';
    //         lrc_NewBatchVariant."Master Batch No." := lrc_MasterBatchSetup."Purch. Plan Master Batch No.";
    //         lrc_NewBatchVariant."Batch No." := lrc_NewBatch."No.";
    //         lrc_NewBatchVariant.Source := lrc_NewBatch.Source::Dummy;
    //         lrc_NewBatchVariant."Source No." := '';
    //         lrc_NewBatchVariant."Source Line No." := 0;
    //         lrc_NewBatch.State := lrc_NewBatch.State::Open;
    //         lrc_NewBatchVariant.INSERT(TRUE);

    //         // Fenster zur Bearbeitung öffnen
    //         IF vbn_OpenCard = TRUE THEN BEGIN
    //           COMMIT;
    //           lrc_NewBatchVariant.FILTERGROUP(2);
    //           lrc_NewBatchVariant.SETRANGE("No.",lrc_NewBatchVariant."No.");
    //           lrc_NewBatchVariant.FILTERGROUP(0);

    //           lfm_BatchVariantCard.SETTABLEVIEW(lrc_NewBatchVariant);
    //           lfm_BatchVariantCard.RUNMODAL;
    //         END;
    //     end;

    //     procedure BatchVarGetUnitCost(vco_BatchVariantCode: Code[20]): Decimal
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         ldc_UnitCostLCY: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung des Einstandspreises
    //         // ---------------------------------------------------------------------------------------------

    //         lrc_BatchVariant.GET(vco_BatchVariantCode);
    //         CASE lrc_BatchVariant."Kind of Settlement" OF
    //         lrc_BatchVariant."Kind of Settlement"::"Fix Price":
    //           BEGIN
    //             EXIT(lrc_BatchVariant."Unit Cost (UOM) (LCY)");
    //           END;
    //         lrc_BatchVariant."Kind of Settlement"::Commission,
    //         lrc_BatchVariant."Kind of Settlement"::"Account Sale+Commission":
    //           BEGIN
    //             EXIT(lrc_BatchVariant."Unit Cost (UOM) (LCY)");
    //           END;
    //         END;
    //     end;

    procedure BatchVarCheckIfInOpenDoc(vco_ItemNo: Code[20]; vco_BatchVariantNo: Code[20]; vco_DocType: Code[10]): Boolean
    var
        lrc_SalesLine: Record "Sales Line";
        lrc_BatchVariantDetail: Record "POI Batch Variant Detail";
        lrc_PackOrderInputItems: Record "POI Pack. Order Input Items";
        //lrc_ReservationLine: Record "5110449";
        lrc_TransferLine: Record "Transfer Line";
        //lrc_AssortmentVersionLine: Record "5110340";
        tab111: Record "Sales Shipment Line";
        tab113: Record "Sales Invoice Line";
        tab115: Record "Sales Cr.Memo Line";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Prüfung ob Pos.-Var. in offenen Belegen enthalten ist
        // -----------------------------------------------------------------------------

        // Verkaufsauftrag
        lrc_SalesLine.SETCURRENTKEY("POI Batch Variant No.", Type, "No.", "Document Type");
        lrc_SalesLine.SETRANGE("POI Batch Variant No.", vco_BatchVariantNo);
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETFILTER("No.", '<>%1', '');
        IF NOT lrc_SalesLine.ISEMPTY() THEN
            EXIT(TRUE);

        //mly+ 141010
        tab111.SETCURRENTKEY("POI Batch Variant No.", Type, "No.");
        tab111.SETRANGE("POI Batch Variant No.", vco_BatchVariantNo);
        tab111.SETRANGE(Type, lrc_SalesLine.Type::Item);
        tab111.SETFILTER("No.", '<>%1', '');
        IF NOT tab111.ISEMPTY() THEN
            EXIT(TRUE);
        tab113.SETCURRENTKEY("POI Batch Variant No.", Type, "No.");
        tab113.SETRANGE("POI Batch Variant No.", vco_BatchVariantNo);
        tab113.SETRANGE(Type, lrc_SalesLine.Type::Item);
        tab113.SETFILTER("No.", '<>%1', '');
        IF NOT tab113.ISEMPTY() THEN
            EXIT(TRUE);
        tab115.SETCURRENTKEY("POI Batch Variant No.", Type, "No.");
        tab115.SETRANGE("POI Batch Variant No.", vco_BatchVariantNo);
        tab115.SETRANGE(Type, lrc_SalesLine.Type::Item);
        tab115.SETFILTER("No.", '<>%1', '');
        IF NOT tab115.ISEMPTY() THEN
            EXIT(TRUE);
        //mly-

        // Positionsvariantendetail
        lrc_BatchVariantDetail.SETCURRENTKEY("Batch Variant No.");
        lrc_BatchVariantDetail.SETRANGE("Batch Variant No.", vco_BatchVariantNo);
        IF lrc_BatchVariantDetail.FINDSET(TRUE, FALSE) THEn
            REPEAT
                // kann gelöscht werden, wenn nichts zugeordnet ist
                IF lrc_BatchVariantDetail.Quantity = 0 THEN
                    lrc_BatchVariantDetail.DELETE(TRUE)
                ELSE
                    EXIT(TRUE);
            UNTIL lrc_BatchVariantDetail.NEXT() = 0;

        // Packerei Input Artikel
        lrc_PackOrderInputItems.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
        lrc_PackOrderInputItems.SETRANGE("Batch Variant No.", vco_BatchVariantNo);
        IF NOT lrc_PackOrderInputItems.ISEMPTY() THEN
            EXIT(TRUE);

        // // Reservierung
        // lrc_ReservationLine.SETCURRENTKEY("Item No.", "Variant Code", "Batch Variant No.");
        // lrc_ReservationLine.SETRANGE("Batch Variant No.", vco_BatchVariantNo);
        // IF NOT lrc_ReservationLine.isempty()THEN
        //     EXIT(TRUE);

        // Umlagerung
        IF vco_DocType <> 'TRANSFER' THEN BEGIN
            lrc_TransferLine.SETCURRENTKEY("POI Batch Variant No.", "Item No.", "Derived From Line No.");
            lrc_TransferLine.SETRANGE("POI Batch Variant No.", vco_BatchVariantNo);
            IF NOT lrc_TransferLine.ISEMPTY() THEN
                EXIT(TRUE);
        END;

        // // Sortimentszeile
        // lrc_AssortmentVersionLine.SETRANGE("Batch Variant No.", vco_BatchVariantNo);
        // IF NOT lrc_AssortmentVersionLine.isempty()THEN
        //     EXIT(TRUE);

        EXIT(FALSE);
    end;

    //     procedure BatchVarSellToCustNo(vrc_PurchLine: Record "39";vbn_Dialog: Boolean)
    //     var
    //         lrc_BatchVarSelltoCust: Record "5110371";
    //         lfm_BatchVarSelltoCust: Form "5110485";
    //     begin
    //         // --------------------------------------------------------------------------------------------------
    //         // Funktiom zur Erfassung ob eine Pos.-Var. an einen Debitor verkauft oder nicht verkauft werden darf
    //         // --------------------------------------------------------------------------------------------------

    //         IF vrc_PurchLine."Batch Variant No." = '' THEN BEGIN
    //           EXIT;
    //         END;
    //         IF (vrc_PurchLine.Type <> vrc_PurchLine.Type::Item) OR
    //            (vrc_PurchLine."No." = '') THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_BatchVarSelltoCust.FILTERGROUP(2);
    //         lrc_BatchVarSelltoCust.SETRANGE("Vendor No.",vrc_PurchLine."Batch Variant No.");
    //         lrc_BatchVarSelltoCust.FILTERGROUP(0);
    //         lfm_BatchVarSelltoCust.SETTABLEVIEW(lrc_BatchVarSelltoCust);
    //         lfm_BatchVarSelltoCust.RUNMODAL;
    //     end;

    //     procedure "--- DMG 006 DMG50000"()
    //     begin
    //     end;

    //     procedure FirstBVWareneingangsdatum(vco_BatchVariantNo: Code[20];vco_LocationCode: Code[10]) ldt_FirstWEDate: Date
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_BatchVariantEntry: Record "5110368";
    //     begin
    //         // DMG 006 DMG50000.s
    //         ldt_FirstWEDate := 0D;
    //         IF lrc_BatchVariant.GET(vco_BatchVariantNo) THEN BEGIN

    //           // WE - Datum aus der Ursprungsposition ermitteln
    //           IF (lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Packing Order") OR
    //              (lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Sorting Order") THEN BEGIN
    //              lrc_PackOrderInputItems.RESET();
    //              lrc_PackOrderInputItems.SETRANGE("Doc. No.", lrc_BatchVariant."Source No.");
    //              lrc_PackOrderInputItems.SETFILTER("Batch Variant No." , '<>%1', '');
    //              IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //               IF lrc_PackOrderInputItems.COUNT() = 1 THEN BEGIN
    //                 IF lrc_BatchVariant.GET(vco_BatchVariantNo) THEN BEGIN
    //                   IF lrc_Item.GET(lrc_PackOrderInputItems."Item No.") THEN BEGIN
    //                     IF lrc_Item."Transformation Item No In-/Out" <> '' THEN BEGIN
    //                       IF lrc_BatchVariant.GET(lrc_PackOrderInputItems."Batch Variant No.") THEN BEGIN
    //                         vco_BatchVariantNo := lrc_PackOrderInputItems."Batch Variant No.";
    //                       END ELSE BEGIN
    //                         lrc_BatchVariant.GET(vco_BatchVariantNo)
    //                       END;
    //                     END;
    //                   END;
    //                 END;
    //               END;
    //              END;
    //           END;

    //           lrc_BatchVariantEntry.RESET();
    //           lrc_BatchVariantEntry.SETCURRENTKEY("Batch Variant No.","Item Ledger Entry Type",
    //                          "Location Code","Posting Date");
    //           lrc_BatchVariantEntry.SETRANGE("Batch Variant No.", vco_BatchVariantNo);
    //           lrc_BatchVariantEntry.SETFILTER("Item Ledger Entry Type", '%1|%2',
    //                                            lrc_BatchVariantEntry."Item Ledger Entry Type"::Purchase,
    //                                            lrc_BatchVariantEntry."Item Ledger Entry Type"::"Positive Adjmt.");
    //           lrc_BatchVariantEntry.SETRANGE("Location Code", vco_LocationCode);
    //           IF lrc_BatchVariantEntry.FIND('-') THEN BEGIN
    //             REPEAT
    //               IF (ldt_FirstWEDate = 0D) OR
    //                  (lrc_BatchVariantEntry."Posting Date" <= ldt_FirstWEDate) THEN BEGIN
    //                 ldt_FirstWEDate := lrc_BatchVariantEntry."Posting Date";
    //               END;
    //             UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //           END ELSE BEGIN
    //             lrc_BatchVariantEntry.SETFILTER("Item Ledger Entry Type", '%1',
    //                                              lrc_BatchVariantEntry."Item Ledger Entry Type"::Transfer);
    //             lrc_BatchVariantEntry.SETRANGE( Positive, TRUE);
    //             IF lrc_BatchVariantEntry.FIND('-') THEN BEGIN
    //               IF (ldt_FirstWEDate = 0D) OR
    //                  (lrc_BatchVariantEntry."Posting Date" <= ldt_FirstWEDate) THEN BEGIN
    //                 ldt_FirstWEDate := lrc_BatchVariantEntry."Posting Date";
    //               END;
    //             END ELSE BEGIN
    //               ldt_FirstWEDate := lrc_BatchVariant."Date of Discharge";
    //               IF ldt_FirstWEDate = 0D THEN BEGIN
    //                 ldt_FirstWEDate := lrc_BatchVariant."Date of Delivery";
    //               END;
    //             END;
    //           END;
    //         END;
    //         // DMG 006 DMG50000.e
    //     end;

    //     procedure "-- SALES BATCH VAR DETAIL --"()
    //     begin
    //     end;

    //     procedure SalesSelectBatchVar(vrc_SalesLine: Record "37"): Code[20]
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_BatchVariant: Record "5110366";
    //         lfm_BatchVariantSelectList: Form "5110494";
    //         lco_BatchVariant: Code[20];
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Auswahl der Positionsvariante nach Eingabe der Artikelnummer in Verkaufszeile
    //         // ----------------------------------------------------------------------------------------------

    //         IF (vrc_SalesLine.Type = vrc_SalesLine.Type::Item) AND
    //            (vrc_SalesLine."No." <> '') AND (vrc_SalesLine."Batch Item" = TRUE) THEN BEGIN

    //           IF lrc_SalesHeader.GET(vrc_SalesLine."Document Type",vrc_SalesLine."Document No.") THEN BEGIN

    //             lrc_BatchVariant.SETCURRENTKEY(State,"Item No.","Date of Delivery");
    //             lrc_BatchVariant.FILTERGROUP(2);
    //             lrc_BatchVariant.SETRANGE("Item No.",vrc_SalesLine."No.");

    //             lrc_BatchVariant.SETRANGE("Date of Delivery",0D,lrc_SalesHeader."Shipment Date");
    //             //lrc_BatchVariant.SETFILTER("B.V. Inventory",'>%1',0);

    //             lrc_BatchVariant.FILTERGROUP(0);
    //             lrc_BatchVariant.SETRANGE(State,lrc_BatchVariant.State::Open);
    //             IF lrc_BatchVariant.isempty()THEN BEGIN
    //               IF vrc_SalesLine."Batch Variant No." = '' THEN BEGIN
    //                 lrc_BatchSetup.GET();
    //                 IF lrc_BatchSetup."Dummy Batch Variant No." <> '' THEN BEGIN
    //                   //VALIDATE("Batch Variant No.",lrc_BatchSetup."Dummy Batch Variant No.");
    //                   lco_BatchVariant := '';
    //                   EXIT(lco_BatchVariant);
    //                 END;
    //               END;
    //               EXIT;
    //             END;

    //             IF lrc_BatchVariant.COUNT > 1 THEN BEGIN
    //               lfm_BatchVariantSelectList.SetDateFilter(lrc_SalesHeader."Order Date");
    //               lfm_BatchVariantSelectList.SETTABLEVIEW(lrc_BatchVariant);
    //               lfm_BatchVariantSelectList.LOOKUPMODE := TRUE;
    //               IF lfm_BatchVariantSelectList.RUNMODAL <> ACTION::LookupOK THEN BEGIN
    //                 IF vrc_SalesLine."Batch Variant No." = '' THEN BEGIN
    //                   lrc_BatchSetup.GET();
    //                   IF lrc_BatchSetup."Dummy Batch Variant No." <> '' THEN BEGIN
    //                     //VALIDATE("Batch Variant No.",lrc_BatchSetup."Dummy Batch Variant No.");
    //                     lco_BatchVariant := '';
    //                     EXIT(lco_BatchVariant);
    //                   END;
    //                 END;
    //               END ELSE BEGIN
    //                 lrc_BatchVariant.RESET();
    //                 lfm_BatchVariantSelectList.GETRECORD(lrc_BatchVariant);
    //                 lco_BatchVariant := lrc_BatchVariant."No.";
    //                 EXIT(lco_BatchVariant);
    //               END;
    //             END ELSE BEGIN
    //               IF lrc_BatchVariant.FIND('-') THEN BEGIN
    //                 lco_BatchVariant := lrc_BatchVariant."No.";
    //                 EXIT(lco_BatchVariant);
    //               END ELSE BEGIN
    //                 lco_BatchVariant := '';
    //                 EXIT(lco_BatchVariant);
    //               END;
    //             END;
    //           END;

    //         END;
    //     end;

    //     procedure SalesBatchVar(vrc_SalesLine: Record "37"): Integer
    //     var
    //         lin_DetailEntryNo: Integer;
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Steuerung Erfassung Positionsvariantennummer/n zu einer Verkaufszeile
    //         // ----------------------------------------------------------------------------------

    //         EXIT(lin_DetailEntryNo);
    //     end;

    //     procedure SalesBatchVarNosDirect(var vrc_SalesLine: Record "37"): Integer
    //     var
    //         lcu_NoSeriesManagement: Codeunit "396";
    //         lcu_StockManagement: Codeunit "5110339";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchVarDetail: Record "5110487";
    //         lfm_BatchVarDetail: Form "5110491";
    //         lin_DetailEntryNo: Integer;
    //         lin_NoOfLines: Integer;
    //         AGILES_LT_TEXT001: Label 'Änderung Positionsvariante nicht zulässig, da bereits gebucht!';
    //         lcu_ExtendedDimensionMgt: Codeunit "5087916";
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Direkte Eingabe der Positionsvariante in der Verkaufszeile
    //         // ----------------------------------------------------------------------------------

    //         // Es ist keine Positionsvariantennummer in der Verkaufszeile vorhanden
    //         IF vrc_SalesLine."Batch Variant No." = '' THEN BEGIN
    //           IF vrc_SalesLine."Batch Var. Detail ID" <> 0 THEN BEGIN
    //             lrc_BatchVarDetail.RESET();
    //             lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //             lrc_BatchVarDetail.SETFILTER("Qty. Posted",'<>%1',0);
    //             IF lrc_BatchVarDetail.FIND('-') THEN
    //               // Änderung Positionsvariante nicht zulässig, da bereits gebucht!
    //               ERROR(AGILES_LT_TEXT001);
    //             lrc_BatchVarDetail.RESET();
    //             lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //             lrc_BatchVarDetail.DELETEALL(TRUE);
    //           END;
    //           // Nummer bleibt erhalten falls bereits vergeben
    //           EXIT(vrc_SalesLine."Batch Var. Detail ID");
    //         END;

    //         lrc_BatchVariant.GET(vrc_SalesLine."Batch Variant No.");

    //         // ID lesen - generieren
    //         IF vrc_SalesLine."Batch Var. Detail ID" = 0 THEN BEGIN
    //           lin_DetailEntryNo := GetBatchVarDetailNo();
    //           vrc_SalesLine."Batch Var. Detail ID" := lin_DetailEntryNo;
    //         END ELSE
    //           lin_DetailEntryNo := vrc_SalesLine."Batch Var. Detail ID";

    //         lrc_BatchVarDetail.RESET();
    //         lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //         lin_NoOfLines := lrc_BatchVarDetail.COUNT();

    //         IF lrc_BatchVarDetail.FIND('-') THEN BEGIN
    //           IF (lin_NoOfLines > 1) OR
    //              (lrc_BatchVarDetail."Line No." <> 1) THEN BEGIN
    //             IF NOT CONFIRM('Möchten Sie die bestehenden Detailzeilen löschen?') THEN
    //               EXIT;
    //             // Bestehende Detailzeilen löschen
    //             lrc_BatchVarDetail.DELETEALL(TRUE);

    //             // Neuanlage Detailzeile
    //             lrc_BatchVarDetail.RESET();
    //             lrc_BatchVarDetail.INIT();
    //             lrc_BatchVarDetail."Entry No." := lin_DetailEntryNo;

    //             // ACHTUNG muss Zeilennr 1 sein als Identifizierung, dass es sich um eine Direkteingabe handelt
    //             lrc_BatchVarDetail."Line No." := 1;

    //             lrc_BatchVarDetail.Source := lrc_BatchVarDetail.Source::Sales;
    //             lrc_BatchVarDetail."Source Type" := vrc_SalesLine."Document Type";
    //             lrc_BatchVarDetail."Source No." := vrc_SalesLine."Document No.";
    //             lrc_BatchVarDetail."Source Line No." := vrc_SalesLine."Line No.";
    //             lrc_BatchVarDetail.INSERT(TRUE);
    //           END;

    //         END ELSE BEGIN
    //           // Neuanlage Detailzeile
    //           lrc_BatchVarDetail.RESET();
    //           lrc_BatchVarDetail.INIT();
    //           lrc_BatchVarDetail."Entry No." := lin_DetailEntryNo;

    //           // ACHTUNG muss Zeilennr 1 sein als Identifizierung, dass es sich um eine Direkteingabe handelt
    //           lrc_BatchVarDetail."Line No." := 1;

    //           lrc_BatchVarDetail.Source := lrc_BatchVarDetail.Source::Sales;
    //           lrc_BatchVarDetail."Source Type" := vrc_SalesLine."Document Type";
    //           lrc_BatchVarDetail."Source No." := vrc_SalesLine."Document No.";
    //           lrc_BatchVarDetail."Source Line No." := vrc_SalesLine."Line No.";
    //           lrc_BatchVarDetail.INSERT(TRUE);
    //         END;

    //         // Werte auch aktualisieren, insbesondere wegen der Zeilennummer, die u.U. bei der Anlage noch nicht vergeben war
    //         lrc_BatchVarDetail."Source No." := vrc_SalesLine."Document No.";
    //         lrc_BatchVarDetail."Source Line No." := vrc_SalesLine."Line No.";

    //         // Werte aktualisieren
    //         lrc_BatchVarDetail."Sales Shipment Date" := vrc_SalesLine."Shipment Date";
    //         lrc_BatchVarDetail."Item No." := vrc_SalesLine."No.";
    //         lrc_BatchVarDetail."Variant Code" := vrc_SalesLine."Variant Code";
    //         lrc_BatchVarDetail."Master Batch No." := lrc_BatchVariant."Master Batch No.";
    //         lrc_BatchVarDetail."Batch No." := lrc_BatchVariant."Batch No.";
    //         lrc_BatchVarDetail."Batch Variant No." := vrc_SalesLine."Batch Variant No.";
    //         lrc_BatchVarDetail."Location Code" := vrc_SalesLine."Location Code";
    //         lrc_BatchVarDetail."Unit of Measure Code" := vrc_SalesLine."Unit of Measure Code";

    //         lrc_BatchVarDetail.Quantity := vrc_SalesLine.Quantity;

    //         IF vrc_SalesLine."Document Type" = vrc_SalesLine."Document Type"::"Return Order" THEN BEGIN

    //           lrc_BatchVarDetail."Qty. to Post" := vrc_SalesLine."Return Qty. to Receive";
    //           lrc_BatchVarDetail."Qty. Posted" := vrc_SalesLine."Return Qty. Received";
    //           lrc_BatchVarDetail."Qty. Outstanding" := lrc_BatchVarDetail.Quantity - lrc_BatchVarDetail."Qty. Posted";

    //           lrc_BatchVarDetail."Base Unit of Measure" := vrc_SalesLine."Base Unit of Measure (BU)";
    //           lrc_BatchVarDetail."Qty. per Unit of Measure" := vrc_SalesLine."Qty. per Unit of Measure";

    //           // Eventuell Werte neu berechnen falls Kalkulation in Verkaufszeile noch nicht geschehen !!!???
    //           lrc_BatchVarDetail."Qty. (Base)" := vrc_SalesLine."Quantity (Base)";
    //           lrc_BatchVarDetail."Qty. to Post (Base)" := vrc_SalesLine."Return Qty. to Receive (Base)";
    //           lrc_BatchVarDetail."Qty. Posted (Base)" := vrc_SalesLine."Return Qty. Received (Base)";
    //           lrc_BatchVarDetail."Qty. Outstanding (Base)" := lrc_BatchVarDetail."Qty. (Base)" - lrc_BatchVarDetail."Qty. Posted (Base)";

    //         END ELSE BEGIN

    //           lrc_BatchVarDetail."Qty. to Post" := vrc_SalesLine."Qty. to Ship";
    //           lrc_BatchVarDetail."Qty. Posted" := vrc_SalesLine."Quantity Shipped";
    //           lrc_BatchVarDetail."Qty. Outstanding" := lrc_BatchVarDetail.Quantity - lrc_BatchVarDetail."Qty. Posted";

    //           lrc_BatchVarDetail."Base Unit of Measure" := vrc_SalesLine."Base Unit of Measure (BU)";
    //           lrc_BatchVarDetail."Qty. per Unit of Measure" := vrc_SalesLine."Qty. per Unit of Measure";

    //           // Eventuell Werte neu berechnen falls Kalkulation in Verkaufszeile noch nicht geschehen !!!???
    //           lrc_BatchVarDetail."Qty. (Base)" := vrc_SalesLine."Quantity (Base)";
    //           lrc_BatchVarDetail."Qty. to Post (Base)" := vrc_SalesLine."Qty. to Ship (Base)";
    //           lrc_BatchVarDetail."Qty. Posted (Base)" := vrc_SalesLine."Qty. Shipped (Base)";
    //           lrc_BatchVarDetail."Qty. Outstanding (Base)" := lrc_BatchVarDetail."Qty. (Base)" - lrc_BatchVarDetail."Qty. Posted (Base)";

    //         END;

    //         lrc_BatchVarDetail."Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";
    //         lrc_BatchVarDetail."Source from Doc. Line" := TRUE;

    //         // Erweiterte Dimensionszuordnung
    //         lcu_ExtendedDimensionMgt.EDM_BatchVarDetailItem(lrc_BatchVarDetail);

    //         lrc_BatchVarDetail.MODIFY();

    //         IF lrc_BatchVarDetail."Batch Variant No." <> '' THEN
    //           BatchVariantRecalc(lrc_BatchVarDetail."Item No.", lrc_BatchVarDetail."Batch Variant No.");

    //         EXIT(vrc_SalesLine."Batch Var. Detail ID");
    //     end;

    //     procedure SalesBatchVarNosDetail(var vrc_SalesLine: Record "37";lbn_WithForm: Boolean): Integer
    //     var
    //         lcu_NoSeriesManagement: Codeunit "396";
    //         lcu_StockManagement: Codeunit "5110339";
    //         lcu_MarketPriceMgt: Codeunit "5110704";
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lcu_StockMgt: Codeunit "5110339";
    //         lcu_ExtendedDimensionMgt: Codeunit "5087916";
    //         lcu_CustomerSpecificFunctions: Codeunit "5110348";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchVarDetail: Record "5110487";
    //         lfm_BatchVarDetail: Form "5110491";
    //         lco_MasterBatchNo: Code[20];
    //         lco_BatchNo: Code[20];
    //         lco_BatchVariantNo: Code[20];
    //         lin_DetailEntryNo: Integer;
    //         lbn_FirstFillBatchFields: Boolean;
    //         AGILES_LT_TEXT001: Label 'Lagerort muss eingegeben werden!';
    //         AGILES_LT_TEXT002: Label 'Die Eingabe der Positionsvariantennr. ist bereits über die Zeile erfolgt!';
    //         "-- BAB 013 DMG50122 L": Integer;
    //         lrc_SalesHeader: Record "36";
    //         lbn_KeepValues: Boolean;
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Erfassung Positionsvariantennummer/n zu einer Verkaufszeile
    //         // ----------------------------------------------------------------------------------

    //         lbn_KeepValues := FALSE;
    //         lrc_SalesHeader.GET(vrc_SalesLine."Document Type",vrc_SalesLine."Document No.");
    //         IF (lrc_SalesHeader."Scanner User ID" <> '') OR
    //            (lrc_SalesHeader."Document Status" >= lrc_SalesHeader."Document Status"::"Fehlerhafte Kommissionierung") THEN BEGIN
    //           lbn_KeepValues := TRUE;
    //         END;

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') OR
    //            (vrc_SalesLine."Batch Item" = FALSE) THEN BEGIN
    //           IF vrc_SalesLine."Batch Var. Detail ID" <> 0 THEN BEGIN
    //             lrc_BatchVarDetail.RESET();
    //             lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //             //lrc_BatchVarDetail.SETRANGE(Quantity, 0);
    //             lrc_BatchVarDetail.DELETEALL(TRUE);
    //           END;
    //           EXIT(0);
    //         END;

    //         // Kontrolle ob bereits eine Direkteingabe erfolgt ist
    //         IF vrc_SalesLine."Batch Variant No." <> '' THEN
    //           // Die Eingabe der Positionsvariantennr. ist bereits über die Zeile erfolgt!
    //           ERROR(AGILES_LT_TEXT002);

    //         // Kontrolle auf Lagerort
    //         IF vrc_SalesLine."Location Code" = '' THEN
    //           // Lagerort muss eingegeben werden!
    //           ERROR(AGILES_LT_TEXT001);

    //         // ID lesen - generieren
    //         IF vrc_SalesLine."Batch Var. Detail ID" = 0 THEN BEGIN
    //           lin_DetailEntryNo := GetBatchVarDetailNo();
    //           vrc_SalesLine."Batch Var. Detail ID" := lin_DetailEntryNo;
    //         END ELSE
    //           lin_DetailEntryNo := vrc_SalesLine."Batch Var. Detail ID";
    //         COMMIT;

    //         // Alle verfügbaren Positionsvarianten laden
    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.SETCURRENTKEY("Item No.","Variant Code","Unit of Measure Code",State);
    //         lrc_BatchVariant.SETRANGE("Item No.",vrc_SalesLine."No.");
    //         lrc_BatchVariant.SETRANGE("Variant Code",vrc_SalesLine."Variant Code");
    //         lrc_BatchVariant.SETRANGE("Unit of Measure Code",vrc_SalesLine."Unit of Measure Code");
    //         lrc_BatchVariant.SETRANGE(State,lrc_BatchVariant.State::Open);

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //           lcu_CustomerSpecificFunctions.SetFilterBatchVarOnSalesLine(vrc_SalesLine,lrc_BatchVariant);
    //         END;

    //         IF lrc_BatchVariant.FIND('-') THEN BEGIN
    //           REPEAT

    //                 // Kontrolle auf Bestand
    //                 IF lcu_StockManagement.BatchVarStockExpAvail(lrc_BatchVariant."No.",vrc_SalesLine."Location Code") > 0 THEN BEGIN

    //                   lrc_BatchVarDetail.RESET();
    //                   lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //                   lrc_BatchVarDetail.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //                   IF lrc_BatchVarDetail.isempty()THEN BEGIN

    //                     lrc_BatchVarDetail.RESET();
    //                     lrc_BatchVarDetail.INIT();
    //                     lrc_BatchVarDetail."Entry No." := lin_DetailEntryNo;
    //                     lrc_BatchVarDetail."Line No." := 0;
    //                     lrc_BatchVarDetail.Source := lrc_BatchVarDetail.Source::Sales;
    //                     // lrc_BatchVarDetail."Source Type" := lrc_BatchVarDetail."Source Type"::Order;
    //                     lrc_BatchVarDetail."Source Type" := vrc_SalesLine."Document Type";
    //                     lrc_BatchVarDetail."Source No." := vrc_SalesLine."Document No.";
    //                     lrc_BatchVarDetail."Source Line No." := vrc_SalesLine."Line No.";
    //                     lrc_BatchVarDetail."Sales Shipment Date" := vrc_SalesLine."Shipment Date";
    //                     lrc_BatchVarDetail."Item No." := vrc_SalesLine."No.";
    //                     lrc_BatchVarDetail."Variant Code" := vrc_SalesLine."Variant Code";
    //                     lrc_BatchVarDetail."Master Batch No." := lrc_BatchVariant."Master Batch No.";
    //                     lrc_BatchVarDetail."Batch No." := lrc_BatchVariant."Batch No.";
    //                     lrc_BatchVarDetail."Batch Variant No." := lrc_BatchVariant."No.";
    //                     lrc_BatchVarDetail."Location Code" := vrc_SalesLine."Location Code";
    //                     lrc_BatchVarDetail."Unit of Measure Code" := lrc_BatchVariant."Unit of Measure Code";
    //                     lrc_BatchVarDetail."Base Unit of Measure" := vrc_SalesLine."Base Unit of Measure (BU)";
    //                     lrc_BatchVarDetail."Qty. per Unit of Measure" := vrc_SalesLine."Qty. per Unit of Measure";
    //                     lrc_BatchVarDetail."Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";
    //                     lrc_BatchVarDetail."Date of Expiry" := lrc_BatchVariant."Date of Expiry";
    //                     // ## ADF.s ## - 240309 Erweiterte Dimensionszuordnung
    //                     lcu_ExtendedDimensionMgt.EDM_BatchVarDetailItem(lrc_BatchVarDetail);
    //                     // ## ADF.e ##
    //                     lrc_BatchVarDetail.INSERT(TRUE);

    //                   END ELSE BEGIN

    //                     lrc_BatchVarDetail.FINDFIRST();

    //                     lrc_BatchVarDetail.CALCFIELDS("Qty. Batch Var. Entry (Base)");
    //                     lrc_BatchVarDetail."Qty. Posted (Base)" := lrc_BatchVarDetail."Qty. Batch Var. Entry (Base)";
    //                     lrc_BatchVarDetail."Qty. Posted" := lrc_BatchVarDetail."Qty. Posted (Base)" /
    //                                                         lrc_BatchVarDetail."Qty. per Unit of Measure";

    //                     // BAB 013 DMG50122.s
    //                     IF NOT lbn_KeepValues THEN BEGIN
    //                       lrc_BatchVarDetail."Qty. to Post (Base)" := lrc_BatchVarDetail."Qty. (Base)" -
    //                                                                   lrc_BatchVarDetail."Qty. Posted (Base)";
    //                       lrc_BatchVarDetail."Qty. to Post" := lrc_BatchVarDetail.Quantity - lrc_BatchVarDetail."Qty. Posted";
    //                     END;
    //                     // BAB 013 DMG50122.e

    //                     lrc_BatchVarDetail."Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";
    //                     // BAB 007 DMG50029.s
    //                     lrc_BatchVarDetail."Date of Expiry" := lrc_BatchVariant."Date of Expiry";
    //                     // BAB 007 DMG50029.e

    //                     // ## ADF.s ## - 240309 Erweiterte Dimensionszuordnung
    //                     lcu_ExtendedDimensionMgt.EDM_BatchVarDetailItem(lrc_BatchVarDetail);
    //                     // ## ADF.e ##

    //                     lrc_BatchVarDetail.MODIFY();

    //                   END;

    //                   // BAB 004 FV400012.s
    //                   IF lrc_BatchVarDetail."Batch Variant No." <> '' THEN
    //                     BatchVariantRecalc(lrc_BatchVarDetail."Item No.", lrc_BatchVarDetail."Batch Variant No.");
    //                   // BAB 004 FV400012.e

    //                 END ELSE BEGIN

    //                   // Kontrolle ob es einen Eintrag gibt
    //                   lrc_BatchVarDetail.RESET();
    //                   lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //                   lrc_BatchVarDetail.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //                   IF lrc_BatchVarDetail.FINDFIRST() THEN BEGIN

    //                     lrc_BatchVarDetail.CALCFIELDS("Qty. Batch Var. Entry (Base)");
    //                     lrc_BatchVarDetail."Qty. Posted (Base)" := lrc_BatchVarDetail."Qty. Batch Var. Entry (Base)";
    //                     lrc_BatchVarDetail."Qty. Posted" := lrc_BatchVarDetail."Qty. Posted (Base)" /
    //                                                         lrc_BatchVarDetail."Qty. per Unit of Measure";

    //                     // BAB 013 DMG50122.s
    //                     IF NOT lbn_KeepValues THEN BEGIN
    //                       lrc_BatchVarDetail."Qty. to Post (Base)" := lrc_BatchVarDetail."Qty. (Base)" -
    //                                                                   lrc_BatchVarDetail."Qty. Posted (Base)";
    //                       lrc_BatchVarDetail."Qty. to Post" := lrc_BatchVarDetail.Quantity - lrc_BatchVarDetail."Qty. Posted";
    //                     END;
    //                     // BAB 013 DMG50122.e

    //                     lrc_BatchVarDetail."Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";

    //                     // ## ADF.s ## - 240309 Erweiterte Dimensionszuordnung
    //                     lcu_ExtendedDimensionMgt.EDM_BatchVarDetailItem(lrc_BatchVarDetail);
    //                     // ## ADF.e ##

    //                     lrc_BatchVarDetail.MODIFY();

    //                     // BAB 004 FV400012.s
    //                     IF lrc_BatchVarDetail."Batch Variant No." <> '' THEN
    //                       BatchVariantRecalc(lrc_BatchVarDetail."Item No.", lrc_BatchVarDetail."Batch Variant No.");
    //                     // BAB 004 FV400012.e

    //                   END;

    //                 END;

    //           UNTIL lrc_BatchVariant.NEXT() = 0;
    //         END;
    //         COMMIT;

    //         // Dialog zur Erfassung öffnen
    //         IF lbn_WithForm = TRUE THEN BEGIN
    //           lrc_BatchVarDetail.RESET();
    //           lrc_BatchVarDetail.FILTERGROUP(2);
    //           lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //           lrc_BatchVarDetail.FILTERGROUP(0);
    //           lfm_BatchVarDetail.SalesInit(vrc_SalesLine);
    //           lfm_BatchVarDetail.SETTABLEVIEW(lrc_BatchVarDetail);
    //           lfm_BatchVarDetail.RUNMODAL;
    //         END;

    //         // KDK 002 00000000.s
    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'BIOTROPIC' THEN BEGIN
    //           IF (lin_DetailEntryNo <> 0) AND
    //              (vrc_SalesLine."Quantity Shipped" = 0) THEN BEGIN

    //             lco_MasterBatchNo := '';
    //             lco_BatchNo := '';
    //             lco_BatchVariantNo := '';
    //             lbn_FirstFillBatchFields := FALSE;

    //             lrc_BatchVarDetail.RESET();
    //             lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //             IF lrc_BatchVarDetail.FIND('-') THEN BEGIN
    //               REPEAT
    //                 IF (lrc_BatchVarDetail."Qty. to Post" <> 0) OR
    //                    (lrc_BatchVarDetail."Qty. Posted" <> 0) THEN BEGIN

    //                   IF (lbn_FirstFillBatchFields = FALSE) AND
    //                      (lco_MasterBatchNo = '') AND
    //                      (lco_BatchNo = '') AND
    //                      (lco_BatchVariantNo = '') THEN BEGIN
    //                     lco_MasterBatchNo := lrc_BatchVarDetail."Master Batch No.";
    //                     lco_BatchNo := lrc_BatchVarDetail."Batch No.";
    //                     lco_BatchVariantNo := lrc_BatchVarDetail."Batch Variant No.";
    //                     lbn_FirstFillBatchFields := TRUE;
    //                   END ELSE BEGIN
    //                     lco_MasterBatchNo := '';
    //                     lco_BatchNo := '';
    //                     lco_BatchVariantNo := '';
    //                   END;

    //                 END;
    //               UNTIL lrc_BatchVarDetail.NEXT() = 0;
    //             END;

    //             IF (lco_MasterBatchNo <> '') AND
    //                (lco_BatchNo <> '') AND
    //                (lco_BatchVariantNo <> '') THEN BEGIN

    //                lrc_BatchVarDetail.RESET();
    //                lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //                IF lrc_BatchVarDetail.FIND('-') THEN BEGIN
    //                  lrc_BatchVarDetail.DELETEALL( TRUE);
    //                END;

    //                // Verfügbare Menge auf der Positionsvariante prüfen
    //                IF (vrc_SalesLine."Document Type" <> vrc_SalesLine."Document Type"::"Credit Memo") AND
    //                   (vrc_SalesLine."Document Type" <> vrc_SalesLine."Document Type"::"Return Order") THEN BEGIN
    //                  IF (lrc_BatchVariant.Source <> lrc_BatchVariant.Source::"Company Copy") AND
    //                     (vrc_SalesLine.Quantity <> 0) THEN BEGIN
    //                    lcu_StockMgt.BatchVarCheckAvail(lco_BatchVariantNo,vrc_SalesLine."Location Code",0D,
    //                                                    (vrc_SalesLine.Quantity * vrc_SalesLine."Qty. per Unit of Measure"),
    //                                                    0);
    //                  END;
    //                END;

    //                lrc_BatchSetup.GET();

    //                vrc_SalesLine."Master Batch No." := lco_MasterBatchNo;

    //                vrc_SalesLine."Batch No." := lco_BatchNo;
    //                // Gleichlautende Dimension setzen
    //                CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                    vrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code",lco_BatchNo);
    //                lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                    vrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code",lco_BatchNo);
    //                lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                    vrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code",lco_BatchNo);
    //                lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                    vrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code",lco_BatchNo);
    //                END;

    //                vrc_SalesLine."Batch Variant No." := lco_BatchVariantNo;

    //                // Werte in Verkaufszeile setzen
    //                vrc_SalesLine."Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
    //                vrc_SalesLine."Variety Code" := lrc_BatchVariant."Variety Code";
    //                vrc_SalesLine."Trademark Code" := lrc_BatchVariant."Trademark Code";
    //                vrc_SalesLine."Caliber Code" := lrc_BatchVariant."Caliber Code";
    //                vrc_SalesLine."Vendor Caliber Code" := lrc_BatchVariant."Vendor Caliber Code";
    //                vrc_SalesLine."Item Attribute 3" := lrc_BatchVariant."Item Attribute 3";
    //                vrc_SalesLine."Item Attribute 2" := lrc_BatchVariant."Item Attribute 2";
    //                vrc_SalesLine."Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
    //                vrc_SalesLine."Item Attribute 7" := lrc_BatchVariant."Item Attribute 7";
    //                vrc_SalesLine."Item Attribute 4" := lrc_BatchVariant."Item Attribute 4";
    //                vrc_SalesLine."Coding Code" := lrc_BatchVariant."Coding Code";
    //                vrc_SalesLine."Item Attribute 5" := lrc_BatchVariant."Item Attribute 5";
    //                vrc_SalesLine."Item Attribute 6" := lrc_BatchVariant."Item Attribute 6";
    //                vrc_SalesLine."Cultivation Type" := lrc_BatchVariant."Cultivation Type";

    //                // Info Felder setzen
    //                vrc_SalesLine."Info 1" := lrc_BatchVariant."Info 1";
    //                vrc_SalesLine."Info 2" := lrc_BatchVariant."Info 2";
    //                vrc_SalesLine."Info 3" := lrc_BatchVariant."Info 3";
    //                vrc_SalesLine."Info 4" := lrc_BatchVariant."Info 4";

    //                // Markteinkaufspreis Basis Mandantenwährung ermitteln
    //                vrc_SalesLine."Market Unit Cost (Base) (LCY)" := lcu_MarketPriceMgt.GetMarketPriceBase(vrc_SalesLine."No.",
    //                  vrc_SalesLine."Batch Variant No.");
    //                vrc_SalesLine."Market Unit Cost (Base) (LCY)" := lrc_BatchVariant."Market Unit Cost (Base) (LCY)";

    //                // Batch Var Detail Zeile anlegen und ID in Sales Line speichern
    //                vrc_SalesLine."Batch Var. Detail ID" := lcu_BatchMgt.SalesBatchVarNosDirect(vrc_SalesLine);

    //                // Gleichlautende Dimension setzen
    //                CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                  lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                    vrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", vrc_SalesLine."Batch No.");
    //                  lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                    vrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", vrc_SalesLine."Batch No.");
    //                  lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                    vrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", vrc_SalesLine."Batch No.");
    //                  lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                    vrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", vrc_SalesLine."Batch No.");
    //                END;
    //                COMMIT;
    //             END;
    //           END;
    //         END;
    //         // KDK 002 00000000.e

    //         EXIT(lin_DetailEntryNo);
    //     end;

    //     procedure SalesBatchVarRecalcAll(vco_SalesOrderDoc: Code[20];vin_SalesOrderLineNo: Integer)
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_BatchVariantDetail: Record "5110487";
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Funktion zur Rekalkulation aller Batch Var. Detail Einträge
    //         // ----------------------------------------------------------------------------------

    //         // Kopfsatz Verkaufsauftrag lesen
    //         lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order,vco_SalesOrderDoc);

    //         // Zeilen Verkaufsauftrag lesen
    //         lrc_SalesLine.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         IF vin_SalesOrderLineNo <> 0 THEN
    //           lrc_SalesLine.SETRANGE("Line No.",vin_SalesOrderLineNo);
    //         lrc_SalesLine.SETFILTER("Batch Var. Detail ID",'<>%1',0);
    //         IF lrc_SalesLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             lrc_BatchVariantDetail.SETRANGE("Entry No.",lrc_SalesLine."Batch Var. Detail ID");
    //             IF lrc_BatchVariantDetail.FINDSET(TRUE,FALSE) THEN BEGIN
    //               REPEAT
    //                 // Gebuchte Menge kalkulieren
    //                 lrc_BatchVariantDetail.CALCFIELDS("Qty. Batch Var. Entry (Base)");
    //                 lrc_BatchVariantDetail."Qty. Posted (Base)" := lrc_BatchVariantDetail."Qty. Batch Var. Entry (Base)";
    //                 lrc_BatchVariantDetail."Qty. Posted" := ROUND(lrc_BatchVariantDetail."Qty. Batch Var. Entry (Base)" /
    //                                                               lrc_BatchVariantDetail."Qty. per Unit of Measure",0.00001);
    //                 lrc_BatchVariantDetail."Qty. to Post" := lrc_BatchVariantDetail.Quantity - lrc_BatchVariantDetail."Qty. Posted";
    //                 lrc_BatchVariantDetail."Qty. (Base)" := lrc_BatchVariantDetail.Quantity *
    //                                                         lrc_BatchVariantDetail."Qty. per Unit of Measure";
    //                 lrc_BatchVariantDetail."Qty. to Post (Base)" := lrc_BatchVariantDetail."Qty. to Post" *
    //                                                                 lrc_BatchVariantDetail."Qty. per Unit of Measure";
    //                 lrc_BatchVariantDetail."Qty. Posted (Base)" := lrc_BatchVariantDetail."Qty. Posted" *
    //                                                                lrc_BatchVariantDetail."Qty. per Unit of Measure";
    //                 lrc_BatchVariantDetail.MODIFY();
    //               UNTIL lrc_BatchVariantDetail.NEXT() = 0;
    //             END;
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure "--  ITEM LEDGER ENTRY BATCH --"()
    //     begin
    //     end;

    //     procedure ItemLedgEntryBatchVarNosDetail(vrc_ItemLedgerEntry: Record "32")
    //     var
    //         lcu_NoSeriesManagement: Codeunit "396";
    //         lcu_StockManagement: Codeunit "5110339";
    //         lrc_ItemJnlPostLine: Codeunit "22";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchVarDetail: Record "5110487";
    //         lfm_BatchVarDetail: Form "5110491";
    //         lin_DetailEntryNo: Integer;
    //         ldc_QuantyBatchVarEntry: Decimal;
    //         AGILES_LT_TEXT001: Label 'Möchten Sie die erfassten Werte buchen?';
    //         AGILES_LT_TEXT002: Label 'Die Eingabe der Positionsvariantennr. ist bereits über die Zeile erfolgt!';
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Nachträgliche Erfassung Positionsvariantennummer/n zu einem Artikelposten
    //         // ----------------------------------------------------------------------------------------

    //         // Prüfung auf Verkauf und Negativer Posten
    //         IF (vrc_ItemLedgerEntry."Entry Type" <> vrc_ItemLedgerEntry."Entry Type"::Sale) OR
    //            (vrc_ItemLedgerEntry.Positive = TRUE) THEN
    //           EXIT;

    //         // Lagerort muss vorhanden sein
    //         vrc_ItemLedgerEntry.TESTFIELD("Location Code");

    //         // Menge bereits zugeordnet berechnen und kontrollieren ob abweichend
    //         ldc_QuantyBatchVarEntry := CalcBatchVarEntryPerItemLedger(vrc_ItemLedgerEntry);
    //         IF ldc_QuantyBatchVarEntry = vrc_ItemLedgerEntry.Quantity THEN
    //           EXIT;

    //         // Kontrolle ob bereits direkt ein Eintrag erfolgt ist
    //         IF vrc_ItemLedgerEntry."Batch Variant No." <> '' THEN
    //           // Die Eingabe der Positionsvariantennr. ist bereits über die Zeile erfolgt!
    //           ERROR(AGILES_LT_TEXT002);

    //         // Artikel lesen und Kontrolle ob Partieartikel
    //         lrc_Item.GET(vrc_ItemLedgerEntry."Item No.");
    //         IF lrc_Item."Batch Item" = FALSE THEN
    //           EXIT;

    //         // Nächste laufende Detail ID vergeben
    //         lin_DetailEntryNo := GetBatchVarDetailNo();
    //         COMMIT;

    //         // Alle verfügbaren Positionsvarianten laden
    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.SETCURRENTKEY("Item No.","Variant Code","Unit of Measure Code",State);
    //         lrc_BatchVariant.SETRANGE("Item No.",vrc_ItemLedgerEntry."Item No.");
    //         lrc_BatchVariant.SETRANGE("Variant Code",vrc_ItemLedgerEntry."Variant Code");
    //         lrc_BatchVariant.SETRANGE("Unit of Measure Code",vrc_ItemLedgerEntry."Unit of Measure Code");
    //         lrc_BatchVariant.SETRANGE(State,lrc_BatchVariant.State::Open);
    //         IF lrc_BatchVariant.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             // Kontrolle auf Bestand
    //             IF lcu_StockManagement.BatchVarStockExpAvail(lrc_BatchVariant."No.",vrc_ItemLedgerEntry."Location Code") > 0 THEN BEGIN

    //               lrc_BatchVarDetail.RESET();
    //               lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //               lrc_BatchVarDetail.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //               IF NOT lrc_BatchVarDetail.FINDFIRST() THEN BEGIN
    //                 lrc_BatchVarDetail.RESET();
    //                 lrc_BatchVarDetail.INIT();
    //                 lrc_BatchVarDetail."Entry No." := lin_DetailEntryNo;
    //                 lrc_BatchVarDetail."Line No." := 0;
    //                 lrc_BatchVarDetail.Source := lrc_BatchVarDetail.Source::Sales;
    //                 lrc_BatchVarDetail."Source Type" := lrc_BatchVarDetail."Source Type"::Order;
    //                 lrc_BatchVarDetail."Source No." := vrc_ItemLedgerEntry."Source Doc. No.";
    //                 lrc_BatchVarDetail."Source Line No." := vrc_ItemLedgerEntry."Source Doc. Line No.";
    //                 lrc_BatchVarDetail."Sales Shipment Date" := vrc_ItemLedgerEntry."Posting Date";
    //                 lrc_BatchVarDetail."Item No." := vrc_ItemLedgerEntry."Item No.";
    //                 lrc_BatchVarDetail."Variant Code" := vrc_ItemLedgerEntry."Variant Code";
    //                 lrc_BatchVarDetail."Master Batch No." := lrc_BatchVariant."Master Batch No.";
    //                 lrc_BatchVarDetail."Batch No." := lrc_BatchVariant."Batch No.";
    //                 lrc_BatchVarDetail."Batch Variant No." := lrc_BatchVariant."No.";
    //                 lrc_BatchVarDetail."Location Code" := vrc_ItemLedgerEntry."Location Code";
    //                 lrc_BatchVarDetail."Unit of Measure Code" := lrc_BatchVariant."Unit of Measure Code";
    //                 lrc_BatchVarDetail."Base Unit of Measure" := lrc_Item."Base Unit of Measure";
    //                 lrc_BatchVarDetail."Qty. per Unit of Measure" := vrc_ItemLedgerEntry."Qty. per Unit of Measure";
    //                 lrc_BatchVarDetail."Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";
    //                 lrc_BatchVarDetail.INSERT(TRUE);
    //               END ELSE BEGIN
    //                 lrc_BatchVarDetail.CALCFIELDS("Qty. Batch Var. Entry (Base)");
    //                 lrc_BatchVarDetail."Qty. Posted (Base)" := lrc_BatchVarDetail."Qty. Batch Var. Entry (Base)";
    //                 lrc_BatchVarDetail."Qty. to Post (Base)" := lrc_BatchVarDetail."Qty. (Base)" -
    //                                                             lrc_BatchVarDetail."Qty. Posted (Base)";
    //                 lrc_BatchVarDetail."Qty. Posted" := lrc_BatchVarDetail."Qty. Posted (Base)" /
    //                                                     lrc_BatchVarDetail."Qty. per Unit of Measure";
    //                 lrc_BatchVarDetail."Qty. to Post" := lrc_BatchVarDetail.Quantity - lrc_BatchVarDetail."Qty. Posted";
    //                 lrc_BatchVarDetail."Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";
    //                 lrc_BatchVarDetail.MODIFY();
    //               END;

    //               IF lrc_BatchVarDetail."Batch Variant No." <> '' THEN
    //                 BatchVariantRecalc(lrc_BatchVarDetail."Item No.",lrc_BatchVarDetail."Batch Variant No.");

    //             END ELSE BEGIN
    //               // Kontrolle ob es einen Eintrag gibt
    //               lrc_BatchVarDetail.RESET();
    //               lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //               lrc_BatchVarDetail.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //               IF lrc_BatchVarDetail.FINDFIRST() THEN BEGIN
    //                 lrc_BatchVarDetail.CALCFIELDS("Qty. Batch Var. Entry (Base)");
    //                 lrc_BatchVarDetail."Qty. Posted (Base)" := lrc_BatchVarDetail."Qty. Batch Var. Entry (Base)";
    //                 lrc_BatchVarDetail."Qty. to Post (Base)" := lrc_BatchVarDetail."Qty. (Base)" -
    //                                                             lrc_BatchVarDetail."Qty. Posted (Base)";
    //                 lrc_BatchVarDetail."Qty. Posted" := lrc_BatchVarDetail."Qty. Posted (Base)" /
    //                                                     lrc_BatchVarDetail."Qty. per Unit of Measure";
    //                 lrc_BatchVarDetail."Qty. to Post" := lrc_BatchVarDetail.Quantity - lrc_BatchVarDetail."Qty. Posted";
    //                 lrc_BatchVarDetail."Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";
    //                 lrc_BatchVarDetail.MODIFY();
    //                 IF lrc_BatchVarDetail."Batch Variant No." <> '' THEN
    //                   BatchVariantRecalc(lrc_BatchVarDetail."Item No.",lrc_BatchVarDetail."Batch Variant No.");
    //               END;
    //             END;
    //           UNTIL lrc_BatchVariant.NEXT() = 0;
    //         END;
    //         COMMIT;

    //         // Dialog zur Erfassung öffnen
    //         lrc_BatchVarDetail.RESET();
    //         lrc_BatchVarDetail.FILTERGROUP(2);
    //         lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //         lrc_BatchVarDetail.FILTERGROUP(0);
    //         lfm_BatchVarDetail.ItemLedgerEntryInit(vrc_ItemLedgerEntry);
    //         lfm_BatchVarDetail.SETTABLEVIEW(lrc_BatchVarDetail);
    //         lfm_BatchVarDetail.RUNMODAL;

    //         // Möchten Sie die erfassten Werte buchen?
    //         IF CONFIRM(AGILES_LT_TEXT001) THEN BEGIN
    //           ERROR('????????');
    //         // Funktion aus der Codeunit 22 verwenden
    //         // lrc_ItemJnlPostLine.InsertBatchVariantEntry
    //         END;

    //         // Einträge löschen
    //         lrc_BatchVarDetail.RESET();
    //         lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //         lrc_BatchVarDetail.DELETEALL(TRUE);
    //     end;

    //     procedure ShowBatchVarDetailLines(vrc_SalesLine: Record "37")
    //     var
    //         lrc_BatchVarDetail: Record "5110487";
    //         lfm_BatchVarDetail: Form "5110491";
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Batch Variant Detail Zeilen
    //         // ----------------------------------------------------------------------------------

    //         lrc_BatchVarDetail.RESET();
    //         lrc_BatchVarDetail.FILTERGROUP(2);
    //         lrc_BatchVarDetail.SETRANGE("Entry No.",vrc_SalesLine."Batch Var. Detail ID");
    //         lrc_BatchVarDetail.FILTERGROUP(0);

    //         // SFR 25.01.07 Edit muss möglich sein für Teillieferungen
    //         // lfm_BatchVarDetail.EDITABLE := FALSE;
    //         lfm_BatchVarDetail.SalesInit(vrc_SalesLine);
    //         lfm_BatchVarDetail.SETTABLEVIEW(lrc_BatchVarDetail);
    //         lfm_BatchVarDetail.RUNMODAL;
    //     end;

    //     procedure DeleteBatchVarDetailLines(var vrc_SalesLine: Record "37")
    //     var
    //         lrc_BatchVariantDetail: Record "5110487";
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Funktion zum Löschen von Batch Var Detail Lines zu einer Sales Line
    //         // ----------------------------------------------------------------------------------

    //         // Alle über die Batch Var Detail ID zugeordneten Einträge löschen
    //         IF vrc_SalesLine."Batch Var. Detail ID" <> 0 THEN BEGIN
    //           lrc_BatchVariantDetail.RESET();
    //           lrc_BatchVariantDetail.SETRANGE("Entry No.",vrc_SalesLine."Batch Var. Detail ID");
    //           lrc_BatchVariantDetail.DELETEALL(TRUE);
    //         END ELSE BEGIN
    //           // Alle über die Belegnummer und Zeile zugeordneten Einträge löschen
    //           lrc_BatchVariantDetail.RESET();
    //           lrc_BatchVariantDetail.SETCURRENTKEY(Source,"Source Type","Source No.","Source Line No.",
    //                                              "Batch Variant No.","Item No.","Location Code");
    //           lrc_BatchVariantDetail.SETRANGE(Source, lrc_BatchVariantDetail.Source::Sales);
    //           lrc_BatchVariantDetail.SETRANGE("Source Type", vrc_SalesLine."Document Type");
    //           lrc_BatchVariantDetail.SETRANGE("Source No.", vrc_SalesLine."Document No.");
    //           lrc_BatchVariantDetail.SETRANGE("Source Line No.", vrc_SalesLine."Line No.");
    //           lrc_BatchVariantDetail.DELETEALL(TRUE);
    //         END;
    //     end;

    //     procedure GetBatchVarDetailNo(): Integer
    //     var
    //         lcu_NoSeriesManagement: Codeunit "396";
    //         lrc_BatchSetup: Record "5110363";
    //         lin_DetailEntryNo: Integer;
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Batch Var Erfassungs ID generieren
    //         // ----------------------------------------------------------------------------------

    //         lrc_BatchSetup.GET();
    //         lrc_BatchSetup.TESTFIELD("Batch Var. Detail No. Series");
    //         EVALUATE(lin_DetailEntryNo,lcu_NoSeriesManagement.GetNextNo(lrc_BatchSetup."Batch Var. Detail No. Series",Today(),TRUE));

    //         EXIT(lin_DetailEntryNo);
    //     end;

    //     procedure ItemLedgEntryNewMasterBatch(vin_ItemLedgerEntryNo: Integer)
    //     var
    //         lcu_NoSeriesManagement: Codeunit "396";
    //         lcu_BaseDataTemplateMgt: Codeunit "5087929";
    //         lcu_GlobalFunctionsMgt: Codeunit "5110300";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_ItemLedgerEntry: Record "32";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_MasterBatch: Record "5110364";
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchVariantEntry: Record "5110368";
    //         lrc_DimensionValue: Record "349";
    //         lco_MasterBatchNo: Code[20];
    //         AGILES_LT_TEXT001: Label 'Die Vergabe der Partienummer ist fehlgeschlagen!';
    //         AGILES_LT_TEXT002: Label 'Zuordnung unbekannt';
    //         lco_BatchNo: Code[20];
    //         AGILES_LT_TEXT003: Label 'Die Vergabe der Positionsnummer ist fehlgeschlagen!';
    //         lco_BatchVariantNo: Code[20];
    //         AGILES_LT_TEXT004: Label 'Die Vergabe der Pos.-Var.-Nr. ist fehlgeschlagen!';
    //         lrc_DimensionValue2: Record "349";
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Partienr / Positionsnr / Positionsvarnr. für Dummy Eintrag generieren
    //         // ----------------------------------------------------------------------------------

    //         //lrc_ItemLedgerEntry.GET(vin_ItemLedgerEntryNo);

    //         // Posten muss positiv sein
    //         IF lrc_ItemLedgerEntry.Positive = FALSE THEN
    //           EXIT;

    //         // Gilt nur für Einkaufs- oder Zugangsposten
    //         IF ((lrc_ItemLedgerEntry."Entry Type" = lrc_ItemLedgerEntry."Entry Type"::Purchase) AND
    //             (lrc_ItemLedgerEntry.Positive = TRUE)) OR
    //            (lrc_ItemLedgerEntry."Entry Type" = lrc_ItemLedgerEntry."Entry Type"::"Positive Adjmt.") OR
    //            ((lrc_ItemLedgerEntry."Entry Type" = lrc_ItemLedgerEntry."Entry Type"::Sale) AND
    //             (lrc_ItemLedgerEntry.Positive = TRUE) AND
    //             (lrc_ItemLedgerEntry.Correction = FALSE)) THEN BEGIN
    //         END ELSE BEGIN
    //           EXIT;
    //         END;

    //         lrc_BatchSetup.GET();
    //         IF lrc_BatchSetup."Batchsystem activ" = FALSE THEN
    //           EXIT;

    //         IF ((lrc_ItemLedgerEntry."Master Batch No." = '') AND
    //             (lrc_ItemLedgerEntry."Batch Variant No." = '')) OR
    //            (lrc_ItemLedgerEntry."Batch Variant No." = lrc_BatchSetup."Dummy Batch Variant No.") THEN BEGIN
    //         END ELSE BEGIN
    //           EXIT;
    //         END;

    //         lrc_Item.GET(lrc_ItemLedgerEntry."Item No.");
    //         IF lrc_Item."Batch Item" = FALSE THEN
    //           EXIT;


    //         // ---------------------------------------------------------------------------
    //         // Datensatz Master Batch (Partie) anlegen
    //         // ---------------------------------------------------------------------------

    //         // Partienummer vergeben
    //         lrc_BatchSetup.TESTFIELD("IJnlLi Master Batch No. Series");
    //         lco_MasterBatchNo := lcu_NoSeriesManagement.GetNextNo(lrc_BatchSetup."IJnlLi Master Batch No. Series",
    //                                                             lrc_ItemLedgerEntry."Posting Date",TRUE);
    //         IF lco_MasterBatchNo = '' THEN
    //           // Die Vergabe der Partienummer ist fehlgeschlagen!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_MasterBatch.RESET();
    //         lrc_MasterBatch.INIT();
    //         lrc_MasterBatch."No." := lco_MasterBatchNo;

    //         /*
    //         lrc_MasterBatch.VALIDATE("Vendor No.",vrc_PurchaseHeader."Buy-from Vendor No.");
    //         lrc_MasterBatch."Producer No." := vrc_PurchaseHeader."Producer No.";
    //         */

    //         lrc_MasterBatch.Source := lrc_MasterBatch.Source::"Item Journal Line";
    //         lrc_MasterBatch."Source No." := lrc_ItemLedgerEntry."Source Doc. No.";

    //         /*
    //         lrc_MasterBatch."Purchaser Code" := vrc_PurchaseHeader."Purchaser Code";
    //         lrc_MasterBatch."Person in Charge Code" := vrc_PurchaseHeader."Person in Charge Code";
    //         lrc_MasterBatch."Currency Code" := vrc_PurchaseHeader."Currency Code";
    //         lrc_MasterBatch."Currency Factor" := vrc_PurchaseHeader."Currency Factor";
    //         lrc_MasterBatch."Batch Activity Code" := vrc_PurchaseHeader."Batch Activity Code";
    //         lrc_MasterBatch."Cost Schema Name Code" := vrc_PurchaseHeader."Cost Schema Name Code";
    //         lrc_MasterBatch."Purch. Doc. Subtype Code" := vrc_PurchaseHeader."Purch. Doc. Subtype Code";
    //         lrc_MasterBatch."Order Type" := vrc_PurchaseHeader."Order Type";
    //         lrc_MasterBatch."Your Reference" := vrc_PurchaseHeader."Your Reference";
    //         lrc_MasterBatch."Vendor Order No." := vrc_PurchaseHeader."Vendor Order No.";
    //         lrc_MasterBatch."Receipt Info" := vrc_PurchaseHeader."Receipt Info";
    //         */

    //         lrc_MasterBatch."Location Code" := lrc_ItemLedgerEntry."Location Code";

    //         /*
    //         lrc_MasterBatch."Location Reference No." := vrc_PurchaseHeader."Location Reference No.";
    //         lrc_MasterBatch."Kind of Settlement" := vrc_PurchaseHeader."Kind of Settlement";
    //         lrc_MasterBatch."Green Point Duty" := vrc_PurchaseHeader."Green Point Duty";
    //         lrc_MasterBatch."Green Point Payment Thru" := vrc_PurchaseHeader."Green Point Payment Thru";
    //         lrc_MasterBatch."Shipment Method Code" := vrc_PurchaseHeader."Shipment Method Code";
    //         lrc_MasterBatch."Status Customs Duty" := vrc_PurchaseHeader."Status Customs Duty";
    //         lrc_MasterBatch."Clearing by Vendor No." := vrc_PurchaseHeader."Clearing by Vendor No.";
    //         lrc_MasterBatch."Fiscal Agent Code" := vrc_PurchaseHeader."Fiscal Agent Code";
    //         lrc_MasterBatch."Shipping Agent Code" := vrc_PurchaseHeader."Shipping Agent Code";
    //         lrc_MasterBatch."Voyage Code (UNA)" := vrc_PurchaseHeader."Voyage Code (UNA)";
    //         lrc_MasterBatch."Means of Transport Type" := vrc_PurchaseHeader."Means of Transport Type";
    //         lrc_MasterBatch."Means of Transp. Code (Arriva)" := vrc_PurchaseHeader."Means of Transp. Code (Arriva)";
    //         lrc_MasterBatch."Means of Transp. Code (Depart)" := vrc_PurchaseHeader."Means of Transp. Code (Depart)";
    //         lrc_MasterBatch."Means of Transport Info" := vrc_PurchaseHeader."Means of Transport Info";
    //         lrc_MasterBatch."Kind of Loading" := vrc_PurchaseHeader."Kind of Loading";
    //         lrc_MasterBatch."Departure Region Code" := vrc_PurchaseHeader."Departure Region Code";
    //         lrc_MasterBatch."Port of Discharge Code (UDE)" := vrc_PurchaseHeader."Port of Discharge Code (UDE)";
    //         lrc_MasterBatch."Date of Discharge" := vrc_PurchaseHeader."Date of Discharge";
    //         lrc_MasterBatch."Time of Discharge" := vrc_PurchaseHeader."Time of Discharge" ;
    //         lrc_MasterBatch."Departure Date" := vrc_PurchaseHeader."Departure Date";
    //         */

    //         lrc_MasterBatch."Expected Receipt Date" := lrc_ItemLedgerEntry."Posting Date";

    //         /*
    //         lrc_MasterBatch."Expected Receipt Time" := vrc_PurchaseHeader."Expected Receipt Time";
    //         lrc_MasterBatch."Container Code" := vrc_PurchaseHeader."Container Code";
    //         lrc_MasterBatch."Quality Control Vendor No." := vrc_PurchaseHeader."Quality Control Vendor No.";
    //         lrc_MasterBatch."Company Season Code" := vrc_PurchaseHeader."Company Season Code";
    //         lrc_MasterBatch."Country of Origin Code" := vrc_PurchaseHeader."Country of Origin Code";
    //         */

    //         lrc_MasterBatch."Shortcut Dimension 1 Code" := lrc_ItemLedgerEntry."Global Dimension 1 Code";
    //         lrc_MasterBatch."Shortcut Dimension 2 Code" := lrc_ItemLedgerEntry."Global Dimension 2 Code";
    //         lrc_MasterBatch."Shortcut Dimension 3 Code" := lrc_ItemLedgerEntry."Global Dimension 3 Code";
    //         lrc_MasterBatch."Shortcut Dimension 4 Code" := lrc_ItemLedgerEntry."Global Dimension 4 Code";
    //         lrc_MasterBatch."Entry Date" := TODAY;
    //         lrc_MasterBatch.INSERT(TRUE);


    //         //RS Anlage Partie als Dimension
    //         lrc_DimensionValue2.SETRANGE("Dimension Code", 'PARTIE');
    //         lrc_DimensionValue2.SETRANGE(Code, lco_MasterBatchNo);
    //         IF NOT lrc_DimensionValue2.FINDSET(FALSE, FALSE) THEN BEGIN
    //           lrc_DimensionValue2.INIT();
    //           lrc_DimensionValue2."Dimension Code" := 'PARTIE';
    //           lrc_DimensionValue2.Code := lco_MasterBatchNo;
    //           lrc_DimensionValue2.Name := lco_MasterBatchNo;
    //           lrc_DimensionValue2.insert();
    //         END;


    //         // ---------------------------------------------------------------------------
    //         // Datensatz Batch (Position) anlegen
    //         // ---------------------------------------------------------------------------
    //         CASE lrc_BatchSetup."IJnlLi Source Batch No." OF
    //           lrc_BatchSetup."IJnlLi Source Batch No."::"No. Series" :
    //             BEGIN
    //               lrc_BatchSetup.TESTFIELD("IJnlLi Batch No. Series");
    //               lco_BatchNo := lcu_NoSeriesManagement.GetNextNo(lrc_BatchSetup."IJnlLi Batch No. Series",
    //                                                               lrc_ItemLedgerEntry."Posting Date",TRUE);
    //             END;
    //           lrc_BatchSetup."IJnlLi Source Batch No."::"Master Batch No." :
    //             BEGIN
    //               lco_BatchNo := lco_MasterBatchNo;
    //             END;
    //           lrc_BatchSetup."IJnlLi Source Batch No."::"Master Batch No. + Postfix" :
    //             BEGIN
    //               ERROR('xxx');
    //             END;
    //           ELSE
    //             // Zuordnung unbekannt
    //             ERROR(AGILES_LT_TEXT002 + ' ' + FORMAT(lrc_BatchSetup."IJnlLi Source Batch No."));
    //         END;

    //         IF lco_BatchNo = '' THEN
    //           // Die Vergabe der Positionsnummer ist fehlgeschlagen!
    //           ERROR(AGILES_LT_TEXT003);

    //         // Positionsdatensatz anlegen
    //         lrc_Batch.RESET();
    //         lrc_Batch.INIT();
    //         lrc_Batch."No." := lco_BatchNo;
    //         lrc_Batch."Master Batch No." := lco_MasterBatchNo;
    //         /*
    //         lrc_Batch.VALIDATE("Vendor No.", PurchaseHeader."Buy-from Vendor No.");
    //         */

    //         lrc_Batch.Source := lrc_Batch.Source::"Item Journal Line";
    //         lrc_Batch."Source No." := lrc_ItemLedgerEntry."Document No.";

    //         /*
    //         lrc_Batch."Kind of Settlement" := PurchaseHeader."Kind of Settlement";
    //         lrc_Batch."Means of Transport Type" := PurchaseHeader."Means of Transport Type";
    //         lrc_Batch."Means of Transp. Code (Depart)" := PurchaseHeader."Means of Transp. Code (Depart)";
    //         lrc_Batch."Means of Transp. Code (Arriva)" := PurchaseHeader."Means of Transp. Code (Arriva)";
    //         lrc_Batch."Means of Transport Info" := PurchaseHeader."Means of Transport Info";
    //         lrc_Batch."Purch. Doc. Subtype Code" := PurchaseHeader."Purch. Doc. Subtype Code";
    //         */
    //         lrc_Batch.State := lrc_Batch.State::Open;
    //         lrc_Batch."Shortcut Dimension 1 Code" := lrc_ItemLedgerEntry."Global Dimension 1 Code";
    //         lrc_Batch."Shortcut Dimension 2 Code" := lrc_ItemLedgerEntry."Global Dimension 2 Code";
    //         lrc_Batch."Shortcut Dimension 3 Code" := lrc_ItemLedgerEntry."Global Dimension 3 Code";
    //         lrc_Batch."Shortcut Dimension 4 Code" := lrc_ItemLedgerEntry."Global Dimension 4 Code";
    //         lrc_Batch.INSERT(TRUE);

    //         // Kontrolle auf Dimensionsanlage und Anlage der Position als Dimension
    //         IF lrc_BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
    //           lrc_DimensionValue.RESET();
    //           lrc_DimensionValue.INIT();
    //           lrc_DimensionValue."Dimension Code" := lrc_BatchSetup."Dim. Code Batch No.";
    //           lrc_DimensionValue.Code := lrc_Batch."No.";
    //           lrc_DimensionValue.Name := lrc_BatchSetup."Dim. Code Batch No.";
    //           lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
    //           lrc_DimensionValue."Global Dimension No." := lrc_BatchSetup."Dim. No. Batch No.";
    //           lrc_DimensionValue.insert();
    //           //RS Anlage Partie als Dimension
    //           IF NOT lrc_DimensionValue.GET('PARTIE', lrc_Batch."Master Batch No.") THEN BEGIN
    //             lrc_DimensionValue.RESET();
    //             lrc_DimensionValue.INIT();
    //             lrc_DimensionValue."Dimension Code" := 'PARTIE';
    //             lrc_DimensionValue.Code := lrc_Batch."Master Batch No.";
    //             lrc_DimensionValue.Name := lrc_Batch."Master Batch No.";
    //             lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
    //             lrc_DimensionValue.insert();
    //           END;
    //         END;


    //         // ---------------------------------------------------------------------------
    //         // Datensatz Batch Variant (Positionsvariante) anlegen
    //         // ---------------------------------------------------------------------------
    //         CASE lrc_BatchSetup."IJnlLi Source Batch Variant" OF
    //           lrc_BatchSetup."IJnlLi Source Batch Variant"::"No. Series":
    //             BEGIN
    //               lrc_BatchSetup.TESTFIELD("IJnlLi Batch Variant No Series");
    //               lco_BatchVariantNo := lcu_NoSeriesManagement.GetNextNo(lrc_BatchSetup."IJnlLi Batch Variant No Series",
    //                                                                    lrc_ItemLedgerEntry."Posting Date",TRUE);
    //             END;
    //           lrc_BatchSetup."IJnlLi Source Batch Variant"::"Batch No.":
    //             BEGIN
    //               lco_BatchVariantNo := lco_BatchNo;
    //             END;
    //           lrc_BatchSetup."IJnlLi Source Batch Variant"::"Batch No. + Postfix":
    //             BEGIN
    //               // Postfixzähler ermitteln
    //               lrc_Batch.GET(lco_BatchNo);
    //               //lrc_Batch.VALIDATE("Vendor No.", vrc_PurchaseLine."Buy-from Vendor No.");
    //               lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
    //               //lrc_Batch."Kind of Settlement" := lrc_PurchaseHdr."Kind of Settlement";
    //               lrc_Batch.MODIFY();

    //               lco_BatchVariantNo := lco_BatchNo + lrc_BatchSetup."Batch Variant Separator" +
    //               lcu_GlobalFunctionsMgt.StrFillWithZeroLeft(FORMAT(lrc_Batch."Batch Variant Postfix Counter"),
    //               lrc_BatchSetup."Batch Variant Postfix Places");
    //             END;
    //           ELSE
    //             ERROR('Abbruch!')
    //         END;

    //         IF lco_BatchVariantNo = '' THEN
    //           // Die Vergabe der Pos.-Var.-Nr ist fehlgeschlagen!
    //           ERROR(AGILES_LT_TEXT004);


    //         // --------------------------------------------------------------------
    //         // Positionsvariante anlegen
    //         // --------------------------------------------------------------------
    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.INIT();
    //         lrc_BatchVariant."No." := lco_BatchVariantNo;
    //         lrc_BatchVariant."Master Batch No." := lco_MasterBatchNo;
    //         lrc_BatchVariant."Batch No." := lco_BatchNo;

    //         lrc_BatchVariant."Item No." := lrc_ItemLedgerEntry."Item No.";
    //         lrc_BatchVariant."Variant Code" := lrc_ItemLedgerEntry."Variant Code";
    //         lrc_BatchVariant.Description := lrc_Item.Description;
    //         lrc_BatchVariant."Description 2" := lrc_Item."Description 2";

    //         lrc_BatchVariant."Item Main Category Code" := lrc_Item."Item Main Category Code";
    //         lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
    //         lrc_BatchVariant."Product Group Code" := lrc_Item."Product Group Code";

    //         lrc_BatchVariant."Base Unit of Measure (BU)" := lrc_ItemLedgerEntry."Base Unit of Measure";
    //         lrc_BatchVariant."Unit of Measure Code" := lrc_ItemLedgerEntry."Unit of Measure Code";
    //         lrc_BatchVariant."Qty. per Unit of Measure" := lrc_ItemLedgerEntry."Qty. per Unit of Measure";

    //         lrc_UnitofMeasure.GET(lrc_ItemLedgerEntry."Unit of Measure Code");
    //         lrc_BatchVariant."Content Unit of Measure (CP)" := lrc_UnitofMeasure."Content Unit of Measure (CP)";
    //         lrc_BatchVariant."Packing Unit of Measure (PU)" := lrc_UnitofMeasure."Packing Unit of Measure (PU)";
    //         lrc_BatchVariant."Qty. (PU) per Collo (CU)" := lrc_UnitofMeasure."Qty. (PU) per Unit of Measure";
    //         lrc_BatchVariant."Transport Unit of Measure (TU)" := lrc_UnitofMeasure."Transport Unit of Measure (TU)";
    //         lrc_BatchVariant."Qty. (Unit) per Transp. (TU)" := lrc_UnitofMeasure."Qty. per Transport Unit (TU)";
    //         lrc_BatchVariant."Price Base (Purch. Price)" := lrc_Item."Price Base (Purch. Price)";

    //         /*
    //         lrc_BatchVariant."Purch. Price (Price Base)" := vrc_PurchaseLine."Purch. Price (Price Base)";
    //         */

    //         lrc_BatchVariant."Price Base (Sales Price)" := lrc_Item."Price Base (Sales Price)";

    //         /*
    //         lrc_BatchVariant."Sales Price (Price Base)" := vrc_PurchaseLine."Sales Price (Price Base) (LCY)";
    //         lrc_BatchVariant."Market Unit Cost (Base) (LCY)" := vrc_PurchaseLine."Market Unit Cost (Basis) (LCY)";
    //         lrc_BatchVariant."Vendor No." := vrc_PurchaseLine."Buy-from Vendor No.";
    //         lrc_BatchVariant."Producer No." := vrc_PurchaseLine."Producer No.";
    //         */

    //         lrc_BatchVariant."Country of Origin Code" := lrc_Item."Country of Origin Code (Fruit)";
    //         lrc_BatchVariant."Variety Code" := lrc_Item."Variety Code";
    //         lrc_BatchVariant."Trademark Code" := lrc_Item."Trademark Code";
    //         lrc_BatchVariant."Caliber Code" := lrc_Item."Caliber Code";
    //         lrc_BatchVariant."Vendor Caliber Code" := '';
    //         lrc_BatchVariant."Item Attribute 3" := lrc_Item."Item Attribute 3";
    //         lrc_BatchVariant."Item Attribute 2" := lrc_Item."Item Attribute 2";
    //         lrc_BatchVariant."Grade of Goods Code" := lrc_Item."Grade of Goods Code";
    //         lrc_BatchVariant."Item Attribute 7" := lrc_Item."Item Attribute 7";
    //         lrc_BatchVariant."Item Attribute 5" := lrc_Item."Item Attribute 5";
    //         lrc_BatchVariant."Item Attribute 6" := lrc_Item."Item Attribute 6";
    //         lrc_BatchVariant."Item Attribute 4" := lrc_Item."Item Attribute 4";
    //         lrc_BatchVariant."Coding Code" := lrc_Item."Coding Code";

    //         lrc_BatchVariant."Net Weight" := lrc_UnitofMeasure."Net Weight";
    //         lrc_BatchVariant."Gross Weight" := lrc_UnitofMeasure."Gross Weight";

    //         /*
    //         lrc_BatchVariant."Average Customs Weight" := vrc_PurchaseLine."Average Customs Weight";
    //         lrc_BatchVariant."Original Quantity" := vrc_PurchaseLine."Original Quantity";
    //         lrc_BatchVariant."Departure Date" := lrc_PurchaseHdr."Departure Date";
    //         lrc_BatchVariant."Order Date" := vrc_PurchaseLine."Order Date";
    //         */

    //         lrc_BatchVariant."Date of Delivery" := lrc_ItemLedgerEntry."Posting Date";

    //         /*
    //         lrc_BatchVariant."Date of Expiry" := vrc_PurchaseLine."Date of Expiry";
    //         lrc_BatchVariant."Kind of Settlement" := vrc_PurchaseLine."Kind of Settlement";
    //         lrc_BatchVariant.Weight := vrc_PurchaseLine.Weight;
    //         IF vrc_PurchaseLine."Lot No. Producer" <> '' THEN BEGIN
    //            lrc_BatchVariant."Lot No. Producer" := vrc_PurchaseLine."Lot No. Producer";
    //         END;
    //         */

    //         lrc_BatchVariant."Entry Location Code" := lrc_ItemLedgerEntry."Location Code";

    //         /*
    //         lrc_BatchVariant."Location Reference No." := vrc_PurchaseLine."Location Reference No.";
    //         lrc_BatchVariant."Shelf No." := vrc_PurchaseLine."Shelf No.";
    //         lrc_BatchVariant."Info 1" := vrc_PurchaseLine."Info 1";
    //         lrc_BatchVariant."Info 2" := vrc_PurchaseLine."Info 2";
    //         lrc_BatchVariant."Info 3" := vrc_PurchaseLine."Info 3";
    //         lrc_BatchVariant."Info 4" := vrc_PurchaseLine."Info 4";
    //         lrc_BatchVariant."Kind of Loading" := vrc_PurchaseLine."Kind of Loading";
    //         lrc_BatchVariant."Voyage Code" := vrc_PurchaseLine."Voyage Code";
    //         lrc_BatchVariant."Container No." := vrc_PurchaseLine."Container No.";
    //         lrc_BatchVariant."Means of Transport Type" := lrc_PurchaseHdr."Means of Transport Type";
    //         lrc_BatchVariant."Means of Transp. Code (Depart)" := lrc_PurchaseHdr."Means of Transp. Code (Depart)";
    //         lrc_BatchVariant."Means of Transp. Code (Arriva)" := lrc_PurchaseHdr."Means of Transp. Code (Arriva)";
    //         lrc_BatchVariant."Means of Transport Info" := lrc_PurchaseHdr."Means of Transport Info";
    //         lrc_BatchVariant."Port of Discharge Code" := vrc_PurchaseLine."Port of Discharge Code (UDE)";
    //         lrc_BatchVariant."Date of Discharge" := vrc_PurchaseLine."Date of Discharge";
    //         lrc_BatchVariant."Time of Discharge" := vrc_PurchaseLine."Time of Discharge";
    //         lrc_BatchVariant."Green Point Duty" := vrc_PurchaseLine."Green Point Duty";
    //         lrc_BatchVariant."Green Point Payment By" := vrc_PurchaseLine."Green Point Payment Thru";
    //         lrc_BatchVariant."Status Customs Duty" := vrc_PurchaseLine."Status Customs Duty";
    //         */

    //         lrc_BatchVariant."Empties Item No." := lrc_Item."Empties Item No.";
    //         lrc_BatchVariant."Empties Quantity" := lrc_Item."Empties Quantity";
    //         lrc_BatchVariant."Company Season Code" := '';

    //         lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Item Journal Line";
    //         lrc_BatchVariant."Source No." := lrc_ItemLedgerEntry."Document No.";
    //         lrc_BatchVariant."Source Line No." := lrc_ItemLedgerEntry."Source Doc. Line No.";
    //         lrc_BatchVariant."Source Company" := COMPANYNAME;

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Create Search No from BatchVar" = TRUE THEN BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item,lrc_BatchVariant);
    //         END ELSE BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);
    //         END;

    //         /*
    //         lrc_BatchVariant."B/L Shipper" := vrc_PurchaseLine."B/L Shipper";
    //         lrc_BatchVariant."Purch. Doc. Subtype Code" := lrc_PurchaseHdr."Purch. Doc. Subtype Code";
    //         */

    //         lrc_BatchVariant.State := lrc_BatchVariant.State::Open;

    //         lrc_BatchVariant."Guaranteed Shelf Life" := lrc_Item."Guaranteed Shelf Life Purch.";

    //         lrc_BatchVariant."Shortcut Dimension 1 Code" := lrc_ItemLedgerEntry."Global Dimension 1 Code";
    //         lrc_BatchVariant."Shortcut Dimension 2 Code" := lrc_ItemLedgerEntry."Global Dimension 2 Code";
    //         lrc_BatchVariant."Shortcut Dimension 3 Code" := lrc_ItemLedgerEntry."Global Dimension 3 Code";
    //         lrc_BatchVariant."Shortcut Dimension 4 Code" := lrc_ItemLedgerEntry."Global Dimension 4 Code";
    //         lrc_BatchVariant.insert();


    //         // ------------------------------------------------------------------------------------------------------
    //         // Datensatz in Pos.-Var. Posten eintragen
    //         // ------------------------------------------------------------------------------------------------------
    //         lrc_BatchVariantEntry.RESET();
    //         lrc_BatchVariantEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //         lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //         IF lrc_BatchVariantEntry.FINDFIRST() THEN BEGIN
    //           lrc_BatchVariantEntry."Master Batch No." := lco_MasterBatchNo;
    //           lrc_BatchVariantEntry."Batch No." := lco_BatchNo;
    //           lrc_BatchVariantEntry."Batch Variant No." := lco_BatchVariantNo;
    //           lrc_BatchVariantEntry.MODIFY();
    //         END ELSE BEGIN
    //           lrc_BatchVariantEntry.RESET();
    //           lrc_BatchVariantEntry.INIT();
    //           lrc_BatchVariantEntry."Entry No." := 0;
    //           lrc_BatchVariantEntry."Master Batch No." := lco_MasterBatchNo;
    //           lrc_BatchVariantEntry."Batch No." := lco_BatchNo;
    //           lrc_BatchVariantEntry."Batch Variant No." := lco_BatchVariantNo;
    //           lrc_BatchVariantEntry."Document No." := lrc_ItemLedgerEntry."Document No.";
    //           lrc_BatchVariantEntry."Document Line No." := 0;
    //           lrc_BatchVariantEntry."Source Doc. Type" := lrc_ItemLedgerEntry."Source Doc. Type";
    //           lrc_BatchVariantEntry."Source Doc. No." := lrc_ItemLedgerEntry."Source Doc. No.";
    //           lrc_BatchVariantEntry."Source Doc. Line No." := lrc_ItemLedgerEntry."Source Doc. Line No.";
    //           lrc_BatchVariantEntry."Status Customs Duty" := 0;
    //           lrc_BatchVariantEntry."Posting Date" := lrc_ItemLedgerEntry."Posting Date";
    //           lrc_BatchVariantEntry."Item No." := lrc_ItemLedgerEntry."Item No.";
    //           lrc_BatchVariantEntry."Variant Code" := lrc_ItemLedgerEntry."Variant Code";
    //           lrc_BatchVariantEntry."Location Code" := lrc_ItemLedgerEntry."Location Code";
    //           lrc_BatchVariantEntry."Base Unit Of Measure Code" := lrc_ItemLedgerEntry."Base Unit of Measure";
    //           lrc_BatchVariantEntry."Quantity (Base)" := lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Invoiced Quantity" := lrc_ItemLedgerEntry."Invoiced Quantity";
    //           lrc_BatchVariantEntry."Unit of Measure Code" := lrc_ItemLedgerEntry."Unit of Measure Code";
    //           lrc_BatchVariantEntry."Qty. per Unit of Measure" := lrc_ItemLedgerEntry."Qty. per Unit of Measure";
    //           lrc_BatchVariantEntry.Quantity := lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Detail Entry No." := 0;
    //           lrc_BatchVariantEntry."Detail Line No." := 0;
    //           lrc_BatchVariantEntry.Positive := TRUE;
    //           lrc_BatchVariantEntry."Item Ledger Entry No." := lrc_ItemLedgerEntry."Entry No.";
    //           lrc_BatchVariantEntry.Open := lrc_ItemLedgerEntry.Open;
    //           lrc_BatchVariantEntry."Item Ledger Entry Type" := lrc_ItemLedgerEntry."Entry Type";
    //           lrc_BatchVariantEntry."Quality Rating" := lrc_ItemLedgerEntry."Quality Rating";
    //           lrc_BatchVariantEntry."Ship-to Code" := lrc_ItemLedgerEntry."Ship-to/Order Address Code";
    //           lrc_BatchVariantEntry.INSERT(TRUE);
    //         END;


    //         // ------------------------------------------------------------------------------------------------------
    //         // Werte in Artikelposten zurückschreiben
    //         // ------------------------------------------------------------------------------------------------------
    //         lrc_ItemLedgerEntry."Master Batch No." := lco_MasterBatchNo;
    //         lrc_ItemLedgerEntry."Batch No." := lco_BatchNo;
    //         lrc_ItemLedgerEntry."Batch Variant No." := lco_BatchVariantNo;
    //         lrc_ItemLedgerEntry."Batch Var. Entry Generated" := TRUE;
    //         lrc_ItemLedgerEntry."Batch Item" := TRUE;
    //         lrc_ItemLedgerEntry.MODIFY();

    //     end;

    //     procedure "-- SET STATUS BATCH VARIANT --"()
    //     begin
    //     end;

    //     procedure SetBatchStatusClosed(rco_BatchNo: Code[20];rco_CalledFromBatchVariantNo: Code[20])
    //     var
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_DimensionValue: Record "349";
    //         lbn_BlockBatch: Boolean;
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Status Position auf geschlossen setzen
    //         // --------------------------------------------------------------------------------------

    //         IF (rco_BatchNo = '') OR
    //            (rco_CalledFromBatchVariantNo = '') THEN
    //           EXIT;

    //         lbn_BlockBatch := FALSE;

    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.SETCURRENTKEY("Batch No.");
    //         lrc_BatchVariant.SETRANGE("Batch No.", rco_BatchNo);
    //         lrc_BatchVariant.SETFILTER("No.", '<>%1', rco_CalledFromBatchVariantNo);
    //         IF NOT lrc_BatchVariant.FINDFIRST() THEN BEGIN
    //           lbn_BlockBatch := TRUE;
    //         END;

    //         IF lbn_BlockBatch = TRUE THEN BEGIN
    //           IF lrc_Batch.GET(rco_BatchNo) THEN BEGIN
    //             lrc_Batch.State := lrc_Batch.State::Blocked;
    //             lrc_Batch.MODIFY(TRUE);
    //           END;
    //           lrc_BatchSetup.GET();
    //           IF lrc_BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
    //             lrc_DimensionValue.RESET();
    //             lrc_DimensionValue.SETRANGE("Dimension Code", lrc_BatchSetup."Dim. Code Batch No.");
    //             lrc_DimensionValue.SETRANGE( Code, rco_BatchNo);
    //             IF lrc_DimensionValue.FIND('-') THEN BEGIN
    //               lrc_DimensionValue.Blocked := TRUE;
    //               lrc_DimensionValue.MODIFY( TRUE);
    //             END;
    //           END ELSE BEGIN
    //             lrc_DimensionValue.RESET();
    //             lrc_DimensionValue.SETRANGE("Dimension Code", 'POSITION');
    //             lrc_DimensionValue.SETRANGE( Code, rco_BatchNo);
    //             IF lrc_DimensionValue.FIND('-') THEN BEGIN
    //               lrc_DimensionValue.Blocked := TRUE;
    //               lrc_DimensionValue.MODIFY( TRUE);
    //             END;
    //           END;
    //         END;
    //     end;

    procedure SetBatchStatusOpen(rco_BatchNo: Code[20])
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
    begin
        // --------------------------------------------------------------------------------------
        // Status Position auf offen setzen
        // --------------------------------------------------------------------------------------

        IF (rco_BatchNo = '') THEN
            EXIT;

        IF lrc_Batch.GET(rco_BatchNo) THEN BEGIN
            lrc_Batch.State := lrc_Batch.State::Open;
            lrc_Batch.MODIFY(TRUE);
        END;

        lrc_BatchSetup.GET();
        IF lrc_BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
            IF lrc_DimensionValue.GET(lrc_BatchSetup."Dim. Code Batch No.", rco_BatchNo) THEN BEGIN
                lrc_DimensionValue.Blocked := FALSE;
                lrc_DimensionValue.MODIFY(TRUE);
            END;
        END ELSE BEGIN
            lrc_DimensionValue.RESET();
            IF lrc_DimensionValue.GET('POSITION', rco_BatchNo) THEN BEGIN
                lrc_DimensionValue.Blocked := FALSE;
                lrc_DimensionValue.MODIFY(TRUE);
            END;
        END;
    end;

    procedure OpenBatchVarStatusIfZero(vco_BatchVariantNo: Code[20])
    begin
        // ------------------------------------------------------------------------------------------
        // Funktion, die den Status wieder auf offen setzt falls dieser geschlossen ist
        // Wichtig für Mengenreduzierungen etc.
        // ------------------------------------------------------------------------------------------

        IF NOT lrc_BatchVariant.GET(vco_BatchVariantNo) THEN
            EXIT;

        IF lrc_BatchVariant.State = lrc_BatchVariant.State::Closed THEN BEGIN
            lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
            lrc_BatchVariant.MODIFY();
        END;
    end;


    //     procedure BatchSourceInfo(vco_BatchNo: Code[20];vco_BatchVariantNo: Code[20];vop_FieldCaption: Option "Info 1","Info 2","Info 3","Info 4";vop_CommentType: Option " ",Internal,"Sales Information","Quality Information";vbn_Editable: Boolean)
    //     var
    //         lop_BatchSourceType: Option "Master Batch No.","Batch No.","Batch Variant No.";
    //         lco_BatchSourceNo: Code[20];
    //         lrc_BatchSourceInfo: Record "5110354";
    //         lfm_BatchSourceInfo: Form "5110486";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_Batch: Record "5110365";
    //         lrc_PurchaseLine: Record "39";
    //         lrc_SalesLine: Record "37";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lco_Info1: Code[30];
    //         lco_Info2: Code[50];
    //         lco_Info3: Code[20];
    //         lco_Info4: Code[20];
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige / Erfassung der Partienr, Positionsnr, Positionsvariantennr Bemerkung
    //         // -------------------------------------------------------------------------------------------

    //         // BSI 001 FV400015.s
    //         lrc_FruitVisionSetup.GET();
    //         CASE vop_FieldCaption OF
    //           vop_FieldCaption::"Info 1":
    //             BEGIN
    //                   CASE lrc_FruitVisionSetup."FREI 5110310" OF
    //                       lrc_FruitVisionSetup."FREI 5110310"::"Batch No.":
    //                         BEGIN
    //                            lop_BatchSourceType := lop_BatchSourceType::"Batch No.";
    //                            lco_BatchSourceNo := vco_BatchNo;
    //                         END;
    //                       lrc_FruitVisionSetup."FREI 5110310"::"Batch Variant No.":
    //                         BEGIN
    //                            lop_BatchSourceType := lop_BatchSourceType::"Batch Variant No.";
    //                            lco_BatchSourceNo := vco_BatchVariantNo;
    //                         END;
    //                    END;
    //             END;
    //           vop_FieldCaption::"Info 2":
    //             BEGIN
    //                   CASE lrc_FruitVisionSetup."FREI 5110311" OF
    //                       lrc_FruitVisionSetup."FREI 5110311"::"Batch No.":
    //                         BEGIN
    //                            lop_BatchSourceType := lop_BatchSourceType::"Batch No.";
    //                            lco_BatchSourceNo := vco_BatchNo;
    //                         END;
    //                       lrc_FruitVisionSetup."FREI 5110311"::"Batch Variant No.":
    //                         BEGIN
    //                            lop_BatchSourceType := lop_BatchSourceType::"Batch Variant No.";
    //                            lco_BatchSourceNo := vco_BatchVariantNo;
    //                         END;
    //                    END;
    //             END;
    //           vop_FieldCaption::"Info 3":
    //             BEGIN
    //                   CASE lrc_FruitVisionSetup."FREI 5110312" OF
    //                       lrc_FruitVisionSetup."FREI 5110312"::"Batch No.":
    //                         BEGIN
    //                            lop_BatchSourceType := lop_BatchSourceType::"Batch No.";
    //                            lco_BatchSourceNo := vco_BatchNo;
    //                         END;
    //                       lrc_FruitVisionSetup."FREI 5110312"::"Batch Variant No.":
    //                         BEGIN
    //                            lop_BatchSourceType := lop_BatchSourceType::"Batch Variant No.";
    //                            lco_BatchSourceNo := vco_BatchVariantNo;
    //                         END;
    //                    END;
    //             END;
    //           vop_FieldCaption::"Info 4":
    //             BEGIN
    //               CASE lrc_FruitVisionSetup."FREI 5110313" OF
    //                 lrc_FruitVisionSetup."FREI 5110313"::"Batch No.":
    //                         BEGIN
    //                            lop_BatchSourceType := lop_BatchSourceType::"Batch No.";
    //                            lco_BatchSourceNo := vco_BatchNo;
    //                         END;
    //                 lrc_FruitVisionSetup."FREI 5110313"::"Batch Variant No.":
    //                         BEGIN
    //                            lop_BatchSourceType := lop_BatchSourceType::"Batch Variant No.";
    //                            lco_BatchSourceNo := vco_BatchVariantNo;
    //                         END;
    //             END;
    //           END;
    //         END;

    //         // Aufruf von Positionskarte / Positionsübersicht
    //         IF (lop_BatchSourceType = lop_BatchSourceType::"Batch Variant No.") AND
    //            (lco_BatchSourceNo = '') THEN
    //           EXIT;

    //         lrc_BatchSourceInfo.FILTERGROUP(2);
    //         lrc_BatchSourceInfo.SETRANGE("Batch Source Type", lop_BatchSourceType);
    //         lrc_BatchSourceInfo.SETRANGE("Batch Source No.", lco_BatchSourceNo);
    //         lrc_BatchSourceInfo.SETRANGE("Field Caption", vop_FieldCaption);
    //         lrc_BatchSourceInfo.SETRANGE("Comment Type", vop_CommentType);
    //         lrc_BatchSourceInfo.FILTERGROUP(0);

    //         lfm_BatchSourceInfo.EDITABLE(vbn_Editable);
    //         lfm_BatchSourceInfo.SETTABLEVIEW(lrc_BatchSourceInfo);
    //         lfm_BatchSourceInfo.RUNMODAL;

    //         IF (vbn_Editable = TRUE) AND
    //            (vop_CommentType = vop_CommentType::"Sales Information") THEN BEGIN

    //           lrc_BatchSourceInfo.RESET();
    //           lrc_BatchSourceInfo.SETRANGE("Batch Source Type", lop_BatchSourceType);
    //           lrc_BatchSourceInfo.SETRANGE("Batch Source No.", lco_BatchSourceNo);
    //           lrc_BatchSourceInfo.SETRANGE("Field Caption", vop_FieldCaption);
    //           lrc_BatchSourceInfo.SETRANGE("Comment Type", vop_CommentType);
    //           lrc_BatchSourceInfo.SETFILTER( Comment, '<>%1', '');
    //           IF lrc_BatchSourceInfo.FIND('-') THEN BEGIN
    //             CASE vop_FieldCaption OF
    //               vop_FieldCaption::"Info 1": lco_Info1 := COPYSTR(lrc_BatchSourceInfo.Comment,1,30);
    //               vop_FieldCaption::"Info 2": lco_Info2 := COPYSTR(lrc_BatchSourceInfo.Comment,1,20);
    //               vop_FieldCaption::"Info 3": lco_Info3 := COPYSTR(lrc_BatchSourceInfo.Comment,1,20);
    //               vop_FieldCaption::"Info 4": lco_Info4 := COPYSTR(lrc_BatchSourceInfo.Comment,1,20);
    //             END;
    //           END ELSE BEGIN
    //             CASE vop_FieldCaption OF
    //               vop_FieldCaption::"Info 1": lco_Info1 := '';
    //               vop_FieldCaption::"Info 2": lco_Info2 := '';
    //               vop_FieldCaption::"Info 3": lco_Info3 := '';
    //               vop_FieldCaption::"Info 4": lco_Info4 := '';
    //             END;
    //           END;

    //           CASE lop_BatchSourceType OF
    //               lop_BatchSourceType::"Batch No.":
    //                  BEGIN
    //                     CASE vop_FieldCaption OF
    //                       vop_FieldCaption::"Info 1":
    //                         BEGIN
    //                             IF lrc_Batch.GET(lco_BatchSourceNo) THEN BEGIN
    //                                lrc_Batch."Info 1" := lco_Info1;
    //                                lrc_Batch.MODIFY();
    //                             END;
    //                         END;
    //                       vop_FieldCaption::"Info 2":
    //                         BEGIN
    //                            IF lrc_Batch.GET(lco_BatchSourceNo) THEN BEGIN
    //                               lrc_Batch."Info 2" := lco_Info2;
    //                               lrc_Batch.MODIFY();
    //                            END;
    //                         END;
    //                       vop_FieldCaption::"Info 3":
    //                         BEGIN
    //                            IF lrc_Batch.GET(lco_BatchSourceNo) THEN BEGIN
    //                               lrc_Batch."Info 3" := lco_Info3;
    //                               lrc_Batch.MODIFY();
    //                            END;
    //                         END;
    //                       vop_FieldCaption::"Info 4":
    //                         BEGIN
    //                            IF lrc_Batch.GET(lco_BatchSourceNo) THEN BEGIN
    //                               lrc_Batch."Info 4" := lco_Info4;
    //                               lrc_Batch.MODIFY();
    //                            END;
    //                         END;
    //                    END;

    //                    // Einkaufszeilen aktualisieren
    //                    lrc_PurchaseLine.RESET();
    //                    lrc_PurchaseLine.SETCURRENTKEY("Document Type",Type,"Master Batch No.","Batch No.","Batch Variant No.");
    //                    lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
    //                    lrc_PurchaseLine.SETRANGE( Type, lrc_PurchaseLine.Type::Item);
    //                    lrc_PurchaseLine.SETRANGE("Batch No.", lco_BatchSourceNo);
    //                    IF lrc_PurchaseLine.FIND('-') THEN BEGIN
    //                      CASE vop_FieldCaption OF
    //                         vop_FieldCaption::"Info 1": lrc_PurchaseLine.MODIFYALL("Info 1",lco_Info1);
    //                         vop_FieldCaption::"Info 2": lrc_PurchaseLine.MODIFYALL("Info 2",lco_Info2);
    //                         vop_FieldCaption::"Info 3": lrc_PurchaseLine.MODIFYALL("Info 3",lco_Info3);
    //                         vop_FieldCaption::"Info 4": lrc_PurchaseLine.MODIFYALL("Info 4",lco_Info4);
    //                      END;
    //                    END;

    //                    // Verkaufszeilen aktualisieren
    //                    lrc_SalesLine.RESET();
    //                    lrc_PurchaseLine.SETCURRENTKEY("Document Type",Type,"Master Batch No.","Batch No.","Batch Variant No.");
    //                    lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
    //                    lrc_SalesLine.SETRANGE( Type, lrc_SalesLine.Type::Item);
    //                    lrc_SalesLine.SETRANGE("Batch No.", lco_BatchSourceNo);
    //                    IF lrc_SalesLine.FIND('-') THEN BEGIN
    //                      CASE vop_FieldCaption OF
    //                         vop_FieldCaption::"Info 1": lrc_SalesLine.MODIFYALL("Info 1",lco_Info1);
    //                         vop_FieldCaption::"Info 2": lrc_SalesLine.MODIFYALL("Info 2",lco_Info2);
    //                         vop_FieldCaption::"Info 3": lrc_SalesLine.MODIFYALL("Info 3",lco_Info3);
    //                         vop_FieldCaption::"Info 4": lrc_SalesLine.MODIFYALL("Info 4",lco_Info4);
    //                      END;
    //                    END;

    //                    // Variante aktualisieren
    //                    lrc_BatchVariant.RESET();
    //                    lrc_BatchVariant.SETCURRENTKEY("Batch No.");
    //                    lrc_BatchVariant.SETRANGE("Batch No.", lco_BatchSourceNo);
    //                    IF lrc_BatchVariant.FIND('-') THEN BEGIN
    //                      CASE vop_FieldCaption OF
    //                         vop_FieldCaption::"Info 1": lrc_BatchVariant.MODIFYALL("Info 1",lco_Info1);
    //                         vop_FieldCaption::"Info 2": lrc_BatchVariant.MODIFYALL("Info 2",lco_Info2);
    //                         vop_FieldCaption::"Info 3": lrc_BatchVariant.MODIFYALL("Info 3",lco_Info3);
    //                         vop_FieldCaption::"Info 4": lrc_BatchVariant.MODIFYALL("Info 4",lco_Info4);
    //                      END;
    //                    END;

    //                    // Umlagerungszeilen aktualisieren
    //                    // Einkaufsreklamationsmeldungszeilen aktualisieren
    //                    // Verkaufsreklamationsmeldungszeilen aktualisieren
    //                    // Packeraufuatrag Outputzeilen aktualisieren
    //                    // Packeraufuatrag Inputzeilen aktualisieren
    //                  END;
    //               lop_BatchSourceType::"Batch Variant No.":
    //                  BEGIN

    //                    // Batch nicht aktualsieren

    //                    // Einkaufszeilen aktualisieren
    //                    lrc_PurchaseLine.RESET();
    //                    lrc_PurchaseLine.SETCURRENTKEY("Document Type",Type,"Master Batch No.","Batch No.","Batch Variant No.");
    //                    lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
    //                    lrc_PurchaseLine.SETRANGE( Type, lrc_PurchaseLine.Type::Item);
    //                    lrc_PurchaseLine.SETRANGE("Batch Variant No.", lco_BatchSourceNo);
    //                    IF lrc_PurchaseLine.FIND('-') THEN BEGIN
    //                      CASE vop_FieldCaption OF
    //                         vop_FieldCaption::"Info 1": lrc_PurchaseLine.MODIFYALL("Info 1",lco_Info1);
    //                         vop_FieldCaption::"Info 2": lrc_PurchaseLine.MODIFYALL("Info 2",lco_Info2);
    //                         vop_FieldCaption::"Info 3": lrc_PurchaseLine.MODIFYALL("Info 3",lco_Info3);
    //                         vop_FieldCaption::"Info 4": lrc_PurchaseLine.MODIFYALL("Info 4",lco_Info4);
    //                      END;
    //                    END;

    //                    // Verkaufszeilen aktualisieren
    //                    lrc_SalesLine.RESET();
    //                    lrc_PurchaseLine.SETCURRENTKEY("Document Type",Type,"Master Batch No.","Batch No.","Batch Variant No.");
    //                    lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
    //                    lrc_SalesLine.SETRANGE( Type, lrc_SalesLine.Type::Item);
    //                    lrc_SalesLine.SETRANGE("Batch Variant No.", lco_BatchSourceNo);
    //                    IF lrc_SalesLine.FIND('-') THEN BEGIN
    //                      CASE vop_FieldCaption OF
    //                         vop_FieldCaption::"Info 1": lrc_SalesLine.MODIFYALL("Info 1",lco_Info1);
    //                         vop_FieldCaption::"Info 2": lrc_SalesLine.MODIFYALL("Info 2",lco_Info2);
    //                         vop_FieldCaption::"Info 3": lrc_SalesLine.MODIFYALL("Info 3",lco_Info3);
    //                         vop_FieldCaption::"Info 4": lrc_SalesLine.MODIFYALL("Info 4",lco_Info4);
    //                      END;
    //                    END;

    //                    // Variante aktualisieren
    //                    lrc_BatchVariant.RESET();
    //                    lrc_BatchVariant.SETCURRENTKEY("No.");
    //                    lrc_BatchVariant.SETRANGE("No.", lco_BatchSourceNo);
    //                    IF lrc_BatchVariant.FIND('-') THEN BEGIN
    //                      CASE vop_FieldCaption OF
    //                         vop_FieldCaption::"Info 1": lrc_BatchVariant.MODIFYALL("Info 1",lco_Info1);
    //                         vop_FieldCaption::"Info 2": lrc_BatchVariant.MODIFYALL("Info 2",lco_Info2);
    //                         vop_FieldCaption::"Info 3": lrc_BatchVariant.MODIFYALL("Info 3",lco_Info3);
    //                         vop_FieldCaption::"Info 4": lrc_BatchVariant.MODIFYALL("Info 4",lco_Info4);
    //                      END;
    //                    END;

    //                    // Umlagerungszeilen aktualisieren
    //                    // Einkaufsreklamationsmeldungszeilen aktualisieren
    //                    // Verkaufsreklamationsmeldungszeilen aktualisieren
    //                    // Packeraufuatrag Outputzeilen aktualisieren
    //                    // Packeraufuatrag Inputzeilen aktualisieren

    //               END;
    //           END;
    //         END;
    //         // BSI 001 FV400015.e
    //     end;

    procedure UpdBatchSourceInfo(vco_BatchNo: Code[20]; vco_BatchVariantNo: Code[20]; vop_FieldCaption: Option "Info 1","Info 2","Info 3","Info 4"; vop_CommentType: Option " ",Internal,"Sales Information","Quality Information"; vco_Info: Code[50])
    var

        //lrc_PurchaseLine: Record "Purchase Line";
        lrc_SalesLine: Record "Sales Line";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
        lrc_PackOrderInputItems: Record "POI Pack. Order Input Items";
        //lrc_PackOrderInputPackItems: Record "5110715";
        lop_BatchSourceType: Option "Master Batch No.","Batch No.","Batch Variant No.";
        lco_BatchSourceNo: Code[20];
    begin
        // -------------------------------------------------------------------------------------------
        // Funktion zur Anzeige / Erfassung der Partienr, Positionsnr, Positionsvariantennr Bemerkung
        // -------------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();

        CASE vop_FieldCaption OF
            vop_FieldCaption::"Info 1":
                CASE lrc_FruitVisionSetup."FREI 5110310" OF
                    lrc_FruitVisionSetup."FREI 5110310"::"Batch No.":
                        BEGIN
                            lop_BatchSourceType := lop_BatchSourceType::"Batch No.";
                            lco_BatchSourceNo := vco_BatchNo;
                        END;
                    lrc_FruitVisionSetup."FREI 5110310"::"Batch Variant No.":
                        BEGIN
                            lop_BatchSourceType := lop_BatchSourceType::"Batch Variant No.";
                            lco_BatchSourceNo := vco_BatchVariantNo;
                        END;
                END;
            vop_FieldCaption::"Info 2":
                CASE lrc_FruitVisionSetup."FREI 5110311" OF
                    lrc_FruitVisionSetup."FREI 5110311"::"Batch No.":
                        BEGIN
                            lop_BatchSourceType := lop_BatchSourceType::"Batch No.";
                            lco_BatchSourceNo := vco_BatchNo;
                        END;
                    lrc_FruitVisionSetup."FREI 5110311"::"Batch Variant No.":
                        BEGIN
                            lop_BatchSourceType := lop_BatchSourceType::"Batch Variant No.";
                            lco_BatchSourceNo := vco_BatchVariantNo;
                        END;
                END;
            vop_FieldCaption::"Info 3":
                CASE lrc_FruitVisionSetup."FREI 5110312" OF
                    lrc_FruitVisionSetup."FREI 5110312"::"Batch No.":
                        BEGIN
                            lop_BatchSourceType := lop_BatchSourceType::"Batch No.";
                            lco_BatchSourceNo := vco_BatchNo;
                        END;
                    lrc_FruitVisionSetup."FREI 5110312"::"Batch Variant No.":
                        BEGIN
                            lop_BatchSourceType := lop_BatchSourceType::"Batch Variant No.";
                            lco_BatchSourceNo := vco_BatchVariantNo;
                        END;
                END;
            vop_FieldCaption::"Info 4":

                CASE lrc_FruitVisionSetup."FREI 5110313" OF
                    lrc_FruitVisionSetup."FREI 5110313"::"Batch No.":
                        BEGIN
                            lop_BatchSourceType := lop_BatchSourceType::"Batch No.";
                            lco_BatchSourceNo := vco_BatchNo;
                        END;
                    lrc_FruitVisionSetup."FREI 5110313"::"Batch Variant No.":
                        BEGIN
                            lop_BatchSourceType := lop_BatchSourceType::"Batch Variant No.";
                            lco_BatchSourceNo := vco_BatchVariantNo;
                        END;
                END;

        END;

        // Aufruf von Positionskarte / Positionsübersicht
        IF (lop_BatchSourceType = lop_BatchSourceType::"Batch Variant No.") AND
           (lco_BatchSourceNo = '') THEN
            EXIT;

        IF vop_CommentType = vop_CommentType::"Sales Information" THEN BEGIN
            lrc_BatchSourceInfo.RESET();
            lrc_BatchSourceInfo.SETRANGE("Batch Source Type", lop_BatchSourceType);
            lrc_BatchSourceInfo.SETRANGE("Batch Source No.", lco_BatchSourceNo);
            lrc_BatchSourceInfo.SETRANGE("Field Caption", vop_FieldCaption);
            lrc_BatchSourceInfo.SETRANGE("Comment Type", vop_CommentType);
            IF NOT lrc_BatchSourceInfo.FIND('-') THEN BEGIN
                lrc_BatchSourceInfo.INIT();
                lrc_BatchSourceInfo."Batch Source Type" := lop_BatchSourceType;
                lrc_BatchSourceInfo."Batch Source No." := lco_BatchSourceNo;
                lrc_BatchSourceInfo."Field Caption" := vop_FieldCaption;
                lrc_BatchSourceInfo."Comment Type" := vop_CommentType;
                lrc_BatchSourceInfo."Line No." := 10000;
                lrc_BatchSourceInfo.INSERT(TRUE);
            END;

            lrc_BatchSourceInfo.Comment := vco_Info;
            lrc_BatchSourceInfo.MODIFY(TRUE);

            CASE lop_BatchSourceType OF
                lop_BatchSourceType::"Batch No.":
                    BEGIN

                        CASE vop_FieldCaption OF
                            vop_FieldCaption::"Info 1":
                                BEGIN
                                    lrc_Batch.GET(lco_BatchSourceNo);
                                    lrc_Batch."Info 1" := vco_Info;
                                    lrc_Batch.MODIFY();
                                END;
                            vop_FieldCaption::"Info 2":
                                BEGIN
                                    lrc_Batch.GET(lco_BatchSourceNo);
                                    lrc_Batch."Info 2" := vco_Info;
                                    lrc_Batch.MODIFY();
                                END;
                            vop_FieldCaption::"Info 3":
                                BEGIN
                                    lrc_Batch.GET(lco_BatchSourceNo);
                                    lrc_Batch."Info 3" := vco_Info;
                                    lrc_Batch.MODIFY();
                                END;
                            vop_FieldCaption::"Info 4":
                                BEGIN
                                    lrc_Batch.GET(lco_BatchSourceNo);
                                    lrc_Batch."Info 4" := vco_Info;
                                    lrc_Batch.MODIFY();
                                END;
                        END;



                        // Verkaufszeilen aktualisieren
                        lrc_SalesLine.RESET();
                        lrc_SalesLine.SETRANGE("POI Batch No.", lco_BatchSourceNo);
                        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                        lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
                        IF lrc_SalesLine.FIND('-') THEN
                            CASE vop_FieldCaption OF
                                vop_FieldCaption::"Info 1":
                                    lrc_SalesLine.MODIFYALL("POI Info 1", vco_Info);
                                vop_FieldCaption::"Info 2":
                                    lrc_SalesLine.MODIFYALL("POI Info 2", vco_Info);
                                vop_FieldCaption::"Info 3":
                                    lrc_SalesLine.MODIFYALL("POI Info 3", vco_Info);
                                vop_FieldCaption::"Info 4":
                                    lrc_SalesLine.MODIFYALL("POI Info 4", vco_Info);
                            END;

                        // Variante aktualisieren
                        lrc_BatchVariant.RESET();
                        lrc_BatchVariant.SETCURRENTKEY("Batch No.");
                        lrc_BatchVariant.SETRANGE("Batch No.", lco_BatchSourceNo);
                        IF lrc_BatchVariant.FIND('-') THEN
                            CASE vop_FieldCaption OF
                                vop_FieldCaption::"Info 1":
                                    lrc_BatchVariant.MODIFYALL("Info 1", vco_Info);
                                vop_FieldCaption::"Info 2":
                                    lrc_BatchVariant.MODIFYALL("Info 2", vco_Info);
                                vop_FieldCaption::"Info 3":
                                    lrc_BatchVariant.MODIFYALL("Info 3", vco_Info);
                                vop_FieldCaption::"Info 4":
                                    lrc_BatchVariant.MODIFYALL("Info 4", vco_Info);
                            END;

                        // Packerei Output Items
                        lrc_PackOrderOutputItems.RESET();
                        lrc_PackOrderOutputItems.SETCURRENTKEY("Batch No.");
                        lrc_PackOrderOutputItems.SETRANGE("Batch No.", lco_BatchSourceNo);
                        IF lrc_PackOrderOutputItems.FIND('-') THEN
                            CASE vop_FieldCaption OF
                                vop_FieldCaption::"Info 1":
                                    lrc_PackOrderOutputItems.MODIFYALL("Info 1", vco_Info);
                                vop_FieldCaption::"Info 2":
                                    lrc_PackOrderOutputItems.MODIFYALL("Info 2", vco_Info);
                                vop_FieldCaption::"Info 3":
                                    lrc_PackOrderOutputItems.MODIFYALL("Info 3", vco_Info);
                                vop_FieldCaption::"Info 4":
                                    lrc_PackOrderOutputItems.MODIFYALL("Info 4", vco_Info);
                            END;

                        // Packerei Intput Items
                        lrc_PackOrderInputItems.RESET();
                        lrc_PackOrderInputItems.SETCURRENTKEY("Batch No.");
                        lrc_PackOrderInputItems.SETRANGE("Batch No.", lco_BatchSourceNo);
                        IF lrc_PackOrderInputItems.FIND('-') THEN
                            CASE vop_FieldCaption OF
                                vop_FieldCaption::"Info 1":
                                    lrc_PackOrderInputItems.MODIFYALL("Info 1", vco_Info);
                                vop_FieldCaption::"Info 2":
                                    lrc_PackOrderInputItems.MODIFYALL("Info 2", vco_Info);
                                vop_FieldCaption::"Info 3":
                                    lrc_PackOrderInputItems.MODIFYALL("Info 3", vco_Info);
                                vop_FieldCaption::"Info 4":
                                    lrc_PackOrderInputItems.MODIFYALL("Info 4", vco_Info);
                            END;

                        // Packerei Intput Packing Items


                    END;
                lop_BatchSourceType::"Batch Variant No.":
                    BEGIN
                        // Verkaufszeilen aktualisieren
                        lrc_SalesLine.RESET();
                        lrc_SalesLine.SETCURRENTKEY("POI Batch Variant No.", Type, "Document Type");
                        lrc_SalesLine.SETRANGE("POI Batch Variant No.", lco_BatchSourceNo);
                        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                        lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
                        IF lrc_SalesLine.FIND('-') THEN
                            CASE vop_FieldCaption OF
                                vop_FieldCaption::"Info 1":
                                    lrc_SalesLine.MODIFYALL("POI Info 1", vco_Info);
                                vop_FieldCaption::"Info 2":
                                    lrc_SalesLine.MODIFYALL("POI Info 2", vco_Info);
                                vop_FieldCaption::"Info 3":
                                    lrc_SalesLine.MODIFYALL("POI Info 3", vco_Info);
                                vop_FieldCaption::"Info 4":
                                    lrc_SalesLine.MODIFYALL("POI Info 4", vco_Info);
                            END;

                        // Variante aktualisieren
                        lrc_BatchVariant.RESET();
                        lrc_BatchVariant.SETCURRENTKEY("No.");
                        lrc_BatchVariant.SETRANGE("No.", lco_BatchSourceNo);
                        IF lrc_BatchVariant.FIND('-') THEN
                            CASE vop_FieldCaption OF
                                vop_FieldCaption::"Info 1":
                                    lrc_BatchVariant.MODIFYALL("Info 1", vco_Info);
                                vop_FieldCaption::"Info 2":
                                    lrc_BatchVariant.MODIFYALL("Info 2", vco_Info);
                                vop_FieldCaption::"Info 3":
                                    lrc_BatchVariant.MODIFYALL("Info 3", vco_Info);
                                vop_FieldCaption::"Info 4":
                                    lrc_BatchVariant.MODIFYALL("Info 4", vco_Info);
                            END;

                        // Packerei Output Items
                        lrc_PackOrderOutputItems.RESET();
                        lrc_PackOrderOutputItems.SETCURRENTKEY("Batch Variant No.");
                        lrc_PackOrderOutputItems.SETRANGE("Batch Variant No.", lco_BatchSourceNo);
                        IF lrc_PackOrderOutputItems.FIND('-') THEN
                            CASE vop_FieldCaption OF
                                vop_FieldCaption::"Info 1":
                                    lrc_PackOrderOutputItems.MODIFYALL("Info 1", vco_Info);
                                vop_FieldCaption::"Info 2":
                                    lrc_PackOrderOutputItems.MODIFYALL("Info 2", vco_Info);
                                vop_FieldCaption::"Info 3":
                                    lrc_PackOrderOutputItems.MODIFYALL("Info 3", vco_Info);
                                vop_FieldCaption::"Info 4":
                                    lrc_PackOrderOutputItems.MODIFYALL("Info 4", vco_Info);
                            END;

                        // Packerei Intput Items
                        lrc_PackOrderInputItems.RESET();
                        lrc_PackOrderInputItems.SETCURRENTKEY("Batch Variant No.");
                        lrc_PackOrderInputItems.SETRANGE("Batch Variant No.", lco_BatchSourceNo);
                        IF lrc_PackOrderInputItems.FIND('-') THEN
                            CASE vop_FieldCaption OF
                                vop_FieldCaption::"Info 1":
                                    lrc_PackOrderInputItems.MODIFYALL("Info 1", vco_Info);
                                vop_FieldCaption::"Info 2":
                                    lrc_PackOrderInputItems.MODIFYALL("Info 2", vco_Info);
                                vop_FieldCaption::"Info 3":
                                    lrc_PackOrderInputItems.MODIFYALL("Info 3", vco_Info);
                                vop_FieldCaption::"Info 4":
                                    lrc_PackOrderInputItems.MODIFYALL("Info 4", vco_Info);
                            END;
                    END;
            END;
        END;

    end;

    //     procedure IsInfoFieldEditable(rop_CalledFrom: Option "Batch Card","Batch Variant Card";rop_FieldCaption: Option "Info 1","Info 2","Info 3","Info 4"): Boolean
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();
    //         CASE rop_CalledFrom OF
    //              rop_CalledFrom::"Batch Card":

    //                CASE rop_FieldCaption OF
    //                     rop_FieldCaption::"Info 1":
    //                        BEGIN
    //                          CASE lrc_FruitVisionSetup."FREI 5110310" OF
    //                              lrc_FruitVisionSetup."FREI 5110310"::"Batch No.":
    //                                BEGIN
    //                                   EXIT( TRUE);
    //                                END;
    //                              lrc_FruitVisionSetup."FREI 5110310"::"Batch Variant No.":
    //                                BEGIN
    //                                   EXIT( FALSE);
    //                                END;
    //                           END;
    //                       END;
    //                     rop_FieldCaption::"Info 2":
    //                        BEGIN
    //                          CASE lrc_FruitVisionSetup."FREI 5110311" OF
    //                              lrc_FruitVisionSetup."FREI 5110311"::"Batch No.":
    //                                BEGIN
    //                                   EXIT( TRUE);
    //                                END;
    //                              lrc_FruitVisionSetup."FREI 5110311"::"Batch Variant No.":
    //                                BEGIN
    //                                   EXIT( FALSE);
    //                                END;
    //                           END;
    //                       END;
    //                     rop_FieldCaption::"Info 3":
    //                        BEGIN
    //                          CASE lrc_FruitVisionSetup."FREI 5110312" OF
    //                              lrc_FruitVisionSetup."FREI 5110312"::"Batch No.":
    //                                BEGIN
    //                                   EXIT( TRUE);
    //                                END;
    //                              lrc_FruitVisionSetup."FREI 5110312"::"Batch Variant No.":
    //                                BEGIN
    //                                   EXIT( FALSE);
    //                                END;
    //                           END;
    //                       END;
    //                     rop_FieldCaption::"Info 4":
    //                        BEGIN
    //                          CASE lrc_FruitVisionSetup."FREI 5110313" OF
    //                              lrc_FruitVisionSetup."FREI 5110313"::"Batch No.":
    //                                BEGIN
    //                                   EXIT( TRUE);
    //                                END;
    //                              lrc_FruitVisionSetup."FREI 5110313"::"Batch Variant No.":
    //                                BEGIN
    //                                   EXIT( FALSE);
    //                                END;
    //                           END;
    //                       END;
    //                END;
    //              rop_CalledFrom::"Batch Variant Card":

    //                CASE rop_FieldCaption OF
    //                     rop_FieldCaption::"Info 1":
    //                        BEGIN
    //                          CASE lrc_FruitVisionSetup."FREI 5110310" OF
    //                              lrc_FruitVisionSetup."FREI 5110310"::"Batch No.":
    //                                BEGIN
    //                                   EXIT( FALSE);
    //                                END;
    //                              lrc_FruitVisionSetup."FREI 5110310"::"Batch Variant No.":
    //                                BEGIN
    //                                   EXIT( TRUE);
    //                                END;
    //                           END;
    //                       END;
    //                     rop_FieldCaption::"Info 2":
    //                        BEGIN
    //                          CASE lrc_FruitVisionSetup."FREI 5110311" OF
    //                              lrc_FruitVisionSetup."FREI 5110311"::"Batch No.":
    //                                BEGIN
    //                                   EXIT( FALSE);
    //                                END;
    //                              lrc_FruitVisionSetup."FREI 5110311"::"Batch Variant No.":
    //                                BEGIN
    //                                   EXIT( TRUE);
    //                                END;
    //                           END;
    //                       END;
    //                     rop_FieldCaption::"Info 3":
    //                        BEGIN
    //                          CASE lrc_FruitVisionSetup."FREI 5110312" OF
    //                              lrc_FruitVisionSetup."FREI 5110312"::"Batch No.":
    //                                BEGIN
    //                                   EXIT( FALSE);
    //                                END;
    //                              lrc_FruitVisionSetup."FREI 5110312"::"Batch Variant No.":
    //                                BEGIN
    //                                   EXIT( TRUE);
    //                                END;
    //                           END;
    //                       END;
    //                     rop_FieldCaption::"Info 4":
    //                        BEGIN
    //                          CASE lrc_FruitVisionSetup."FREI 5110313" OF
    //                              lrc_FruitVisionSetup."FREI 5110313"::"Batch No.":
    //                                BEGIN
    //                                   EXIT( FALSE);
    //                                END;
    //                              lrc_FruitVisionSetup."FREI 5110313"::"Batch Variant No.":
    //                                BEGIN
    //                                   EXIT( TRUE);
    //                                END;
    //                           END;
    //                       END;
    //                END;
    //         END;

    //         EXIT(FALSE);
    //     end;

    //     procedure "-- PACKING ORDER --"()
    //     begin
    //     end;

    //     procedure PackNewMasterBatch(vrc_PackOrderHeader: Record "5110712";var rrc_MasterBatchCodeReturn: Code[20])
    //     var
    //         NoSeriesManagement: Codeunit "396";
    //         BatchSetup: Record "5110363";
    //         lrc_MasterBatch: Record "5110364";
    //         TEXT000: Label 'Vergabe Partienr. fehlgeschlagen!';
    //         lco_MasterBatchCode: Code[20];
    //         TEXT001: Label 'Vergabe Positionsnr. fehlgeschlagen!';
    //         AGILES_LT_TEXT003: Label 'Zuordnung nicht codiert!';
    //         lrc_DimensionValue: Record "349";
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Anlage einer neuen Partie über dem Packereiauftrag / Sortierauftrag
    //         // ------------------------------------------------------------------------------------------

    //         // Einrichtung lesen
    //         BatchSetup.GET();

    //         // Kontrolle ob Partiewesen aktiv ist
    //         IF BatchSetup."Batchsystem activ" = FALSE THEN BEGIN
    //           rrc_MasterBatchCodeReturn := '';
    //           EXIT;
    //         END;

    //         // Kontrolle ob Partie Code bereits vorhanden
    //         IF vrc_PackOrderHeader."Master Batch No." <> '' THEN BEGIN
    //           rrc_MasterBatchCodeReturn := vrc_PackOrderHeader."Master Batch No.";
    //           EXIT;
    //         END;

    //         // --------------------------------------------------------------------------
    //         // Vergabe über Setup Einrichtung
    //         // --------------------------------------------------------------------------
    //         CASE vrc_PackOrderHeader."Document Type" OF
    //         vrc_PackOrderHeader."Document Type"::"Packing Order":
    //           BEGIN
    //             BatchSetup.TESTFIELD("Pack. Master Batch No. Series");
    //             lco_MasterBatchCode := NoSeriesManagement.GetNextNo(BatchSetup."Pack. Master Batch No. Series",WORKDATE,TRUE);
    //           END;
    //         vrc_PackOrderHeader."Document Type"::"Sorting Order":
    //           BEGIN
    //             BatchSetup.TESTFIELD("Sort. Master Batch No. Series");
    //             lco_MasterBatchCode := NoSeriesManagement.GetNextNo(BatchSetup."Sort. Master Batch No. Series",WORKDATE,TRUE);
    //           END;
    //         vrc_PackOrderHeader."Document Type"::"Substitution Order":
    //           BEGIN
    //             BatchSetup.TESTFIELD("Subst. Master Batch No. Series");
    //             lco_MasterBatchCode := NoSeriesManagement.GetNextNo(BatchSetup."Subst. Master Batch No. Series",WORKDATE,TRUE);
    //           END;
    //         ELSE
    //           // Zuordnung nicht codiert!
    //           ERROR(AGILES_LT_TEXT003);
    //         END;

    //         IF lco_MasterBatchCode = '' THEN
    //           // Vergabe Partienr. fehlgeschlagen!
    //           ERROR(TEXT000);

    //         // ---------------------------------------------------------------------------
    //         // Datensatz Master Batch anlegen
    //         // ---------------------------------------------------------------------------
    //         lrc_MasterBatch.RESET();
    //         lrc_MasterBatch.INIT();
    //         lrc_MasterBatch."No." := lco_MasterBatchCode;
    //         lrc_MasterBatch.VALIDATE("Vendor No.",vrc_PackOrderHeader."Vendor No.");
    //         CASE vrc_PackOrderHeader."Document Type" OF
    //           vrc_PackOrderHeader."Document Type"::"Packing Order": lrc_MasterBatch.Source := lrc_MasterBatch.Source::"Packing Order";
    //           vrc_PackOrderHeader."Document Type"::"Sorting Order": lrc_MasterBatch.Source := lrc_MasterBatch.Source::"Sorting Order";
    //           vrc_PackOrderHeader."Document Type"::"Substitution Order": lrc_MasterBatch.Source := lrc_MasterBatch.Source::"Packing Order";
    //         END;
    //         lrc_MasterBatch."Source No." := vrc_PackOrderHeader."No.";
    //         lrc_MasterBatch."Entry Date" := TODAY;

    //         // FV4 014 00000000.s
    //         /*
    //         lrc_MasterBatch."Shortcut Dimension 1 Code" := vrc_PackOrderHeader."Shortcut Dimension 1 Code";
    //         lrc_MasterBatch."Shortcut Dimension 2 Code" := vrc_PackOrderHeader."Shortcut Dimension 2 Code";
    //         lrc_MasterBatch."Shortcut Dimension 3 Code" := vrc_PackOrderHeader."Shortcut Dimension 3 Code";
    //         lrc_MasterBatch."Shortcut Dimension 4 Code" := vrc_PackOrderHeader."Shortcut Dimension 4 Code";
    //         */
    //         // FV4 014 00000000.e

    //         lrc_MasterBatch.insert();

    //         //RS Kostenschema Packerei vorbelegen
    //         lrc_MasterBatch.VALIDATE("Cost Schema Name Code", 'PACKEREI');
    //         lrc_MasterBatch.MODIFY();

    //         //RS Anlage Partie als Dimension
    //         lrc_DimensionValue.SETRANGE("Dimension Code", 'PARTIE');
    //         lrc_DimensionValue.SETRANGE(Code, lco_MasterBatchCode);
    //         IF NOT lrc_DimensionValue.FINDSET(FALSE, FALSE) THEN BEGIN
    //           lrc_DimensionValue.INIT();
    //           lrc_DimensionValue."Dimension Code" := 'PARTIE';
    //           lrc_DimensionValue.Code := lco_MasterBatchCode;
    //           lrc_DimensionValue.Name := lco_MasterBatchCode;
    //           lrc_DimensionValue.insert();
    //         END;

    //         // Rückgabewerte setzen
    //         rrc_MasterBatchCodeReturn := lrc_MasterBatch."No.";

    //     end;

    //     procedure PackUpdMasterBatch(vco_MasterBatchCode: Code[20];vrc_PackOrderHeader: Record "5110712")
    //     var
    //         lrc_MasterBatch: Record "5110364";
    //     begin
    //         // ----------------------------------------------------------------------
    //         // Aktualisierung einer vorhandenen Partie über Packereikopf
    //         // ----------------------------------------------------------------------

    //         IF vrc_PackOrderHeader."Master Batch No." = '' THEN
    //           EXIT;

    //         // Partie lesen und aktualisieren
    //         lrc_MasterBatch.GET(vco_MasterBatchCode);
    //         lrc_MasterBatch.VALIDATE("Vendor No.", vrc_PackOrderHeader."Vendor No.");
    //         lrc_MasterBatch."Person in Charge Code" := vrc_PackOrderHeader."Person in Charge Code";
    //         lrc_MasterBatch."Your Reference" := vrc_PackOrderHeader.Reference;
    //         lrc_MasterBatch."Expected Receipt Date" := vrc_PackOrderHeader."Expected Receipt Date";

    //         // FV4 014 00000000.s
    //         /*
    //         lrc_MasterBatch."Shortcut Dimension 1 Code" := vrc_PackOrderHeader."Shortcut Dimension 1 Code";
    //         lrc_MasterBatch."Shortcut Dimension 2 Code" := vrc_PackOrderHeader."Shortcut Dimension 2 Code";
    //         lrc_MasterBatch."Shortcut Dimension 3 Code" := vrc_PackOrderHeader."Shortcut Dimension 3 Code";
    //         lrc_MasterBatch."Shortcut Dimension 4 Code" := vrc_PackOrderHeader."Shortcut Dimension 4 Code";
    //         */
    //         // FV4 014 00000000.e

    //         lrc_MasterBatch.MODIFY();

    //     end;

    procedure PackNewBatch(vrc_PackOrderHeader: Record "POI Pack. Order Header"; var rco_BatchNo: Code[20])
    var

        BatchSetup: Record "POI Master Batch Setup";
        DimensionValue: Record "Dimension Value";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        BatchNo: Code[20];
        AGILES_LT_TEXT001Txt: Label 'Zuordnung nicht codiert!';
        AGILES_LT_TEXT002Txt: Label 'Positionsnr. konnte nicht ermittelt werden!';

    begin
        // -----------------------------------------------------------------
        // Anlage einer neuen Position aus der Packerei / Sortierung
        // -----------------------------------------------------------------

        IF rco_BatchNo <> '' THEN
            EXIT;

        BatchSetup.GET();
        IF BatchSetup."Batchsystem activ" = FALSE THEN
            EXIT;

        CASE vrc_PackOrderHeader."Document Type" OF
            vrc_PackOrderHeader."Document Type"::"Packing Order":
                BEGIN
                    //RS Positionsnummer aus MasterBatchNo + Postfix
                    //BatchSetup.TESTFIELD("Pack. Batch No. Series");
                    //BatchNo := NoSeriesManagement.GetNextNo(BatchSetup."Pack. Batch No. Series",WORKDATE,TRUE);
                    lrc_MasterBatch.GET(vrc_PackOrderHeader."Master Batch No.");
                    lrc_MasterBatch."Batch Postfix Counter" := lrc_MasterBatch."Batch Postfix Counter" + 1;
                    lrc_MasterBatch.MODIFY();
                    BatchNo := copystr(PADSTR(FORMAT(lrc_MasterBatch."No." + '-'), 17 - STRLEN(FORMAT(lrc_MasterBatch."Batch Postfix Counter")), '0') +
                               FORMAT(lrc_MasterBatch."Batch Postfix Counter"), 1, 20);
                    lrc_MasterBatch."Batch Postfix Counter" := lrc_MasterBatch."Batch Postfix Counter" + 1;
                    lrc_MasterBatch.MODIFY();
                END;
            vrc_PackOrderHeader."Document Type"::"Sorting Order":
                BEGIN
                    BatchSetup.TESTFIELD("Sort. Batch No. Series");
                    BatchNo := NoSeriesManagement.GetNextNo(BatchSetup."Sort. Batch No. Series", WORKDATE(), TRUE);
                END;
            vrc_PackOrderHeader."Document Type"::"Substitution Order":
                BEGIN
                    BatchSetup.TESTFIELD("Subst. Batch No. Series");
                    BatchNo := NoSeriesManagement.GetNextNo(BatchSetup."Subst. Batch No. Series", WORKDATE(), TRUE);
                END;
            ELSE
                // Zuordnung nicht codiert!
                ERROR(AGILES_LT_TEXT001Txt);
        END;

        IF BatchNo = '' THEN
            // Positionsnr. konnte nicht ermittelt werden!
            ERROR(AGILES_LT_TEXT002Txt);

        // Positionsdatensatz anlegen
        Batch.RESET();
        Batch.INIT();
        Batch."No." := BatchNo;
        Batch."Master Batch No." := vrc_PackOrderHeader."Master Batch No.";
        Batch.VALIDATE("Vendor No.", vrc_PackOrderHeader."Vendor No.");
        CASE vrc_PackOrderHeader."Document Type" OF
            vrc_PackOrderHeader."Document Type"::"Packing Order":
                Batch.Source := Batch.Source::"Packing Order";
            vrc_PackOrderHeader."Document Type"::"Sorting Order":
                Batch.Source := Batch.Source::"Sorting Order";
            vrc_PackOrderHeader."Document Type"::"Substitution Order":
                Batch.Source := Batch.Source::"Packing Order";
        END;
        Batch."Source No." := vrc_PackOrderHeader."No.";
        Batch."Kind of Settlement" := 0;

        Batch.INSERT();

        // Kontrolle auf Dimensionsanlage und Anlage der Partie als Dimension
        IF BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
            DimensionValue.RESET();
            DimensionValue.INIT();
            DimensionValue."Dimension Code" := BatchSetup."Dim. Code Batch No.";
            DimensionValue.Code := Batch."No.";
            DimensionValue.Name := 'Position';
            DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
            DimensionValue."Global Dimension No." := BatchSetup."Dim. No. Batch No.";
            DimensionValue.INSERT();
            //RS Anlage Partie als Dimension
            IF NOT DimensionValue.GET('PARTIE', Batch."Master Batch No.") THEN BEGIN
                DimensionValue.RESET();
                DimensionValue.INIT();
                DimensionValue."Dimension Code" := 'PARTIE';
                DimensionValue.Code := Batch."Master Batch No.";
                DimensionValue.Name := Batch."Master Batch No.";
                DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
                DimensionValue.INSERT();
            END;
        END;

        // Rückgabewert setzen
        rco_BatchNo := Batch."No.";

    end;

    procedure PackUpdBatch(vrc_PackOrderOutputItems: Record "POI Pack. Order Output Items")
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        //lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
        //lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        //lrc_PackDocSubtype: Record "5110725";
        lrc_Vendor: Record Vendor;
    //lcu_BaseDataTemplateMgt: Codeunit "POI BDT Base Data Template Mgt";
    //lcu_CustomerSpecificFunctions: Codeunit "POI Customer Specific Functions";
    begin
        // --------------------------------------------------------------------------------
        // Aktualisierung einer vorhandenen Positionsvariante über Packauftrag Output
        // --------------------------------------------------------------------------------

        // Wenn keine Positionsvaraintennr. vorhanden
        IF vrc_PackOrderOutputItems."Batch Variant No." = '' THEN
            EXIT;
        IF vrc_PackOrderOutputItems."Item No." = '' THEN
            EXIT;
        // Packereikopfsatz lesen
        lrc_PackOrderHeader.GET(vrc_PackOrderOutputItems."Doc. No.");

        // Wenn Positionsvariante vorhanden
        IF lrc_Batch.GET(vrc_PackOrderOutputItems."Batch Variant No.") THEN BEGIN
            // Artikelstammsatz lesen
            lrc_Item.GET(vrc_PackOrderOutputItems."Item No.");


            lrc_Batch."Item No." := vrc_PackOrderOutputItems."Item No.";
            lrc_Batch."Item Variant Code" := vrc_PackOrderOutputItems."Variant Code";

            // lrc_Batch."Item Main Category Code" := lrc_Item."Item Main Category Code";
            // lrc_Batch."Item Category Code" := lrc_Item."Item Category Code";
            // lrc_Batch."Product Group Code" := lrc_Item."Product Group Code";
            // lrc_Batch."Producer No." := '';
            // lrc_Batch."Country of Origin Code" := vrc_PackOrderOutputItems."Country of Origin Code";
            // lrc_Batch."Variety Code" := vrc_PackOrderOutputItems."Variety Code";
            // lrc_Batch."Trademark Code" := vrc_PackOrderOutputItems."Trademark Code";
            // lrc_Batch."Caliber Code" := vrc_PackOrderOutputItems."Caliber Code";
            // lrc_Batch."Vendor Caliber Code" := '';//vrc_PackOrderOutputItems."Vendor Caliber Code";
            // lrc_Batch."Item Attribute 3" := vrc_PackOrderOutputItems."Item Attribute 3";
            // lrc_Batch."Item Attribute 2" := vrc_PackOrderOutputItems."Item Attribute 2";
            // lrc_Batch."Grade of Goods Code" := vrc_PackOrderOutputItems."Grade of Goods Code";
            // lrc_Batch."Item Attribute 7" := vrc_PackOrderOutputItems."Item Attribute 7";
            // lrc_Batch."Item Attribute 4" := vrc_PackOrderOutputItems."Item Attribute 4";
            // lrc_Batch."Coding Code" := vrc_PackOrderOutputItems."Coding Code";
            // lrc_Batch."Item Attribute 5" := vrc_PackOrderOutputItems."Item Attribute 5";
            // lrc_Batch."Item Attribute 6" := vrc_PackOrderOutputItems."Item Attribute 6";
            lrc_Batch."Cultivation Type" := vrc_PackOrderOutputItems."Cultivation Type";
            lrc_Batch."Master Batch No." := lrc_PackOrderHeader."Master Batch No.";

            IF lrc_Batch."Vendor No." <> lrc_PackOrderHeader."Vendor No." THEN BEGIN
                lrc_Batch."Vendor No." := lrc_PackOrderHeader."Vendor No.";
                IF lrc_Vendor.GET(lrc_PackOrderHeader."Vendor No.") THEN
                    lrc_Batch."Vendor Search Name" := lrc_Vendor."Search Name";
            END;
            lrc_Batch."Net Weight" := vrc_PackOrderOutputItems."Net Weight";
            lrc_Batch."Gross Weight" := vrc_PackOrderOutputItems."Gross Weight";
            lrc_Batch."Average Customs Weight" := 0;
            lrc_Batch."Departure Date" := lrc_PackOrderHeader."Order Date";
            lrc_Batch."Order Date" := lrc_PackOrderHeader."Order Date";
            lrc_Batch."Date of Delivery" := vrc_PackOrderOutputItems."Expected Receipt Date";
            IF vrc_PackOrderOutputItems."Promised Receipt Date" <> 0D THEN
                lrc_Batch."Date of Delivery" := vrc_PackOrderOutputItems."Promised Receipt Date";
            lrc_Batch."Kind of Settlement" := 0;
            lrc_Batch.Weight := 0;
            IF lrc_PackOrderHeader."Pack.-by Vendor No." <> '' THEN
                lrc_Batch."Producer No." := lrc_PackOrderHeader."Pack.-by Vendor No."
            ELSE
                lrc_Batch."Producer No." := lrc_PackOrderHeader."Vendor No.";
            IF vrc_PackOrderOutputItems."Lot No." <> '' THEN
                lrc_Batch."Lot No. Producer" := vrc_PackOrderOutputItems."Lot No.";

            lrc_Batch."Entry Location Code" := vrc_PackOrderOutputItems."Location Code";
            lrc_Batch."Info 1" := vrc_PackOrderOutputItems."Info 1";
            lrc_Batch."Info 2" := vrc_PackOrderOutputItems."Info 2";
            lrc_Batch."Info 3" := vrc_PackOrderOutputItems."Info 3";
            lrc_Batch."Info 4" := vrc_PackOrderOutputItems."Info 4";
            lrc_Batch."Date of Expiry" := vrc_PackOrderOutputItems."Expiry Date";
            IF vrc_PackOrderOutputItems."Date of Expiry" <> 0D THEN
                lrc_Batch."Date of Expiry" := vrc_PackOrderOutputItems."Date of Expiry";

            lrc_Batch."Waste Disposal Duty" := vrc_PackOrderOutputItems."Waste Disposal Duty";
            lrc_Batch."Waste Disposal Payment By" := vrc_PackOrderOutputItems."Waste Disposal Payment Thru";
            lrc_Batch."Status Customs Duty" := 0;

            lrc_Batch."Empties Item No." := vrc_PackOrderOutputItems."Empties Item No.";
            lrc_Batch."Empties Quantity" := vrc_PackOrderOutputItems."Empties Quantity";

            lrc_Batch."Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
            lrc_Batch."Unit of Measure Code" := vrc_PackOrderOutputItems."Unit of Measure Code";
            lrc_Batch."Qty. per Unit of Measure" := vrc_PackOrderOutputItems."Qty. per Unit of Measure";

            lrc_Batch."Content Unit of Measure (CP)" := vrc_PackOrderOutputItems."Content Unit of Measure (COU)";
            lrc_Batch."Packing Unit of Measure (PU)" := vrc_PackOrderOutputItems."Packing Unit of Measure (PU)";
            lrc_Batch."Qty. (PU) per Collo (CU)" := vrc_PackOrderOutputItems."Qty. (PU) per Unit of Measure";

            lrc_Batch."Transport Unit of Measure (TU)" := vrc_PackOrderOutputItems."Transport Unit of Measure (TU)";
            lrc_Batch."Qty. (Unit) per Transp. (TU)" := vrc_PackOrderOutputItems."Qty. (Unit) per Transp.(TU)";

            lrc_Batch."Price Base (Purch. Price)" := vrc_PackOrderOutputItems."Price Base (Purch. Price)";

            lrc_Batch."Price Base (Sales Price)" := vrc_PackOrderOutputItems."Price Base (Sales Price)";
            lrc_Batch."Sales Price (Price Base)" := vrc_PackOrderOutputItems."Sales Price (Price Base)";

            lrc_Batch."Market Unit Cost (Base) (LCY)" := vrc_PackOrderOutputItems."Market Unit Cost (Basis) (LCY)";

            lrc_Batch."Source Line No." := vrc_PackOrderOutputItems."Line No.";

            lrc_Batch."Location's Reference No." := vrc_PackOrderOutputItems."Location Reference No.";
            lrc_Batch."No. 2" := vrc_PackOrderOutputItems."Internal Reference No.";

            // Dimension Position Code füllen
            lrc_BatchSetup.GET();
            CASE lrc_BatchSetup."Dim. No. Batch No." OF
                1:
                    lrc_Batch."Shortcut Dimension 1 Code" := lrc_Batch."No.";
                2:
                    lrc_Batch."Shortcut Dimension 2 Code" := lrc_Batch."No.";
                3:
                    lrc_Batch."Shortcut Dimension 3 Code" := lrc_Batch."No.";
                4:
                    lrc_Batch."Shortcut Dimension 4 Code" := lrc_Batch."No.";
            END;

            lrc_Batch."Shortcut Dimension 1 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 1 Code";
            lrc_Batch."Shortcut Dimension 2 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 2 Code";
            lrc_Batch."Shortcut Dimension 3 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 3 Code";
            lrc_Batch."Shortcut Dimension 4 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 4 Code";

            lrc_Batch.MODIFY();
        END;

        SetBatchStatusOpen(vrc_PackOrderOutputItems."Batch No.");
    end;

    procedure PackNewBatchVar(vrc_PackOrderOutputItems: Record "POI Pack. Order Output Items"; var rco_BatchCode: Code[20]; var rco_BatchVariantCode: Code[20])
    var

        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        lrc_Vendor: Record Vendor;
        lcu_BaseDataTemplateMgt: Codeunit "POI BDT Base Data Template Mgt";
        lco_BatchCode: Code[20];
        BatchVariantCode: Code[20];
        //TEXT001Txt: Label 'Positionsnummer konnte nicht ermittelt werden!';
        TEXT003Txt: Label 'Positionsvariantennr. konnte nicht generiert werden!';
        AGILES_LT_TEXT004Txt: Label 'Zuordnung Positionsnr. nicht codiert!';
    begin
        // ----------------------------------------------------------------------
        // Anlage einer neuen Positionsvariante aus Packerei / Sortierung
        // ----------------------------------------------------------------------

        // Kontrolle ob Artikel und Artikelnummer oder Batchvariante
        IF (vrc_PackOrderOutputItems."Item No." = '') OR
           (vrc_PackOrderOutputItems."Batch Variant No." <> '') THEN
            EXIT;

        // Artikel lesen und Kontrolle ob Artikel Batchgeführt ist
        lrc_Item.GET(vrc_PackOrderOutputItems."Item No.");
        IF lrc_Item."POI Batch Item" = FALSE THEN
            EXIT;

        lrc_BatchSetup.GET();

        // Kontrolle ob Partienummer vergeben wurde
        lrc_PackOrderHeader.GET(vrc_PackOrderOutputItems."Doc. No.");
        vrc_PackOrderOutputItems.TESTFIELD("Master Batch No.");

        CASE lrc_PackOrderHeader."Document Type" OF
            lrc_PackOrderHeader."Document Type"::"Packing Order":
                CASE lrc_BatchSetup."Pack. Allocation Batch No." OF
                    lrc_BatchSetup."Pack. Allocation Batch No."::"One Batch No. per Order":
                        BEGIN
                            vrc_PackOrderOutputItems.TESTFIELD("Batch No.");
                            lco_BatchCode := vrc_PackOrderOutputItems."Batch No.";
                        END;
                    lrc_BatchSetup."Pack. Allocation Batch No."::"New Batch No. per Line":
                        BEGIN
                            lco_BatchCode := '';
                            PackNewBatch(lrc_PackOrderHeader, lco_BatchCode);
                        END;
                    ELSE
                        // Zuordnung Positionsnr. nicht codiert!
                        ERROR(AGILES_LT_TEXT004Txt);
                END;
            lrc_PackOrderHeader."Document Type"::"Sorting Order":
                CASE lrc_BatchSetup."Sort. Allocation Batch No." OF
                    lrc_BatchSetup."Sort. Allocation Batch No."::"One Batch No. per Order":
                        BEGIN
                            vrc_PackOrderOutputItems.TESTFIELD("Batch No.");
                            lco_BatchCode := vrc_PackOrderOutputItems."Batch No.";
                        END;
                    lrc_BatchSetup."Sort. Allocation Batch No."::"New Batch No. per Line":
                        BEGIN
                            lco_BatchCode := '';
                            PackNewBatch(lrc_PackOrderHeader, lco_BatchCode);
                        END;
                    ELSE
                        // Zuordnung Positionsnr. nicht codiert!
                        ERROR(AGILES_LT_TEXT004Txt);
                END;

            lrc_PackOrderHeader."Document Type"::"Substitution Order":
                CASE lrc_BatchSetup."Subst. Allocation Batch No." OF
                    lrc_BatchSetup."Subst. Allocation Batch No."::"One Batch No. per Order":
                        BEGIN
                            vrc_PackOrderOutputItems.TESTFIELD("Batch No.");
                            lco_BatchCode := vrc_PackOrderOutputItems."Batch No.";
                        END;
                    lrc_BatchSetup."Subst. Allocation Batch No."::"New Batch No. per Line":
                        BEGIN
                            lco_BatchCode := '';
                            PackNewBatch(lrc_PackOrderHeader, lco_BatchCode);
                        END;
                    ELSE
                        // Zuordnung Positionsnr. nicht codiert!
                        ERROR(AGILES_LT_TEXT004Txt);
                END;
        END;

        // Postfixzähler ermitteln
        lrc_Batch.GET(lco_BatchCode);
        lrc_Batch.VALIDATE("Vendor No.", lrc_PackOrderHeader."Vendor No.");
        lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
        lrc_Batch."Kind of Settlement" := 0;

        lrc_Batch."Shortcut Dimension 1 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 1 Code";
        lrc_Batch."Shortcut Dimension 2 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 2 Code";
        lrc_Batch."Shortcut Dimension 3 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 3 Code";
        lrc_Batch."Shortcut Dimension 4 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 4 Code";


        lrc_Batch.MODIFY();


        lrc_FruitVisionSetup.GET();
        //IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
        IF ((lrc_PackOrderHeader."Document Type" =
              lrc_PackOrderHeader."Document Type"::"Packing Order") AND
             (lrc_BatchSetup."Pack. Allocation Batch No." =
              lrc_BatchSetup."Pack. Allocation Batch No."::"New Batch No. per Line")) OR
           ((lrc_PackOrderHeader."Document Type" =
              lrc_PackOrderHeader."Document Type"::"Sorting Order") AND
             (lrc_BatchSetup."Sort. Allocation Batch No." =
              lrc_BatchSetup."Sort. Allocation Batch No."::"New Batch No. per Line")) OR
           ((lrc_PackOrderHeader."Document Type" =
              lrc_PackOrderHeader."Document Type"::"Substitution Order") AND
             (lrc_BatchSetup."Subst. Allocation Batch No." =
              lrc_BatchSetup."Subst. Allocation Batch No."::"New Batch No. per Line")) THEN
            BatchVariantCode := lco_BatchCode;


        IF BatchVariantCode = '' THEN
            // Positionsvariantennr. konnte nicht generiert werden!
            ERROR(TEXT003Txt);

        SetBatchStatusOpen(lco_BatchCode);

        // --------------------------------------------------------------------
        // Positionsvariante anlegen
        // --------------------------------------------------------------------
        lrc_BatchVariant.RESET();
        lrc_BatchVariant.INIT();
        lrc_BatchVariant."No." := BatchVariantCode;
        lrc_BatchVariant."Master Batch No." := vrc_PackOrderOutputItems."Master Batch No.";
        lrc_BatchVariant."Batch No." := lco_BatchCode;
        lrc_BatchVariant."Item No." := vrc_PackOrderOutputItems."Item No.";
        lrc_BatchVariant."Variant Code" := vrc_PackOrderOutputItems."Variant Code";

        lrc_BatchVariant.Description := lrc_Item.Description;
        lrc_BatchVariant."Description 2" := lrc_Item."Description 2";

        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Create Search No from BatchVar" = TRUE THEN
            lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item, lrc_BatchVariant)
        ELSE
            lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);


        IF (lrc_BatchVariant.Description = '') AND
           (lrc_BatchVariant."Description 2" = '') THEN BEGIN
            lrc_BatchVariant.Description := vrc_PackOrderOutputItems."Item Description";
            lrc_BatchVariant."Description 2" := vrc_PackOrderOutputItems."Item Description 2";
        END;

        lrc_BatchVariant."Type of Packing Product" := vrc_PackOrderOutputItems."Type of Packing Product";

        //lrc_BatchVariant."Item Main Category Code" := lrc_Item."Item Main Category Code";
        lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
        //lrc_BatchVariant."Product Group Code" := lrc_Item."Product Group Code";
        lrc_BatchVariant."Base Unit of Measure (BU)" := vrc_PackOrderOutputItems."Base Unit of Measure (BU)";
        lrc_BatchVariant."Unit of Measure Code" := vrc_PackOrderOutputItems."Unit of Measure Code";
        lrc_BatchVariant."Qty. per Unit of Measure" := vrc_PackOrderOutputItems."Qty. per Unit of Measure";

        lrc_BatchVariant."Content Unit of Measure (CP)" := vrc_PackOrderOutputItems."Content Unit of Measure (COU)";
        lrc_BatchVariant."Packing Unit of Measure (PU)" := vrc_PackOrderOutputItems."Packing Unit of Measure (PU)";
        lrc_BatchVariant."Qty. (PU) per Collo (CU)" := vrc_PackOrderOutputItems."Qty. (PU) per Unit of Measure";
        lrc_BatchVariant."Transport Unit of Measure (TU)" := vrc_PackOrderOutputItems."Transport Unit of Measure (TU)";
        lrc_BatchVariant."Qty. (Unit) per Transp. (TU)" := vrc_PackOrderOutputItems."Qty. (Unit) per Transp.(TU)";

        lrc_BatchVariant."Price Base (Purch. Price)" := vrc_PackOrderOutputItems."Price Base (Purch. Price)";
        lrc_BatchVariant."Purch. Price (Price Base)" := 0;

        lrc_BatchVariant."Price Base (Sales Price)" := vrc_PackOrderOutputItems."Price Base (Sales Price)";
        lrc_BatchVariant."Sales Price (Price Base)" := vrc_PackOrderOutputItems."Sales Price (Price Base)";

        lrc_BatchVariant."Market Unit Cost (Base) (LCY)" := vrc_PackOrderOutputItems."Market Unit Cost (Basis) (LCY)";

        lrc_BatchVariant."Vendor No." := lrc_PackOrderHeader."Vendor No.";
        IF lrc_Vendor.GET(lrc_PackOrderHeader."Vendor No.") THEN
            lrc_BatchVariant."Vendor Search Name" := lrc_Vendor."Search Name";
        lrc_BatchVariant."Producer No." := '';

        lrc_BatchVariant."Country of Origin Code" := vrc_PackOrderOutputItems."Country of Origin Code";
        // lrc_BatchVariant."Variety Code" := vrc_PackOrderOutputItems."Variety Code";
        // lrc_BatchVariant."Trademark Code" := vrc_PackOrderOutputItems."Trademark Code";
        // lrc_BatchVariant."Caliber Code" := vrc_PackOrderOutputItems."Caliber Code";
        // lrc_BatchVariant."Item Attribute 3" := vrc_PackOrderOutputItems."Item Attribute 3";
        // lrc_BatchVariant."Item Attribute 2" := vrc_PackOrderOutputItems."Item Attribute 2";
        // lrc_BatchVariant."Grade of Goods Code" := vrc_PackOrderOutputItems."Grade of Goods Code";
        // lrc_BatchVariant."Item Attribute 7" := vrc_PackOrderOutputItems."Item Attribute 7";
        // lrc_BatchVariant."Item Attribute 4" := vrc_PackOrderOutputItems."Item Attribute 4";
        // lrc_BatchVariant."Coding Code" := vrc_PackOrderOutputItems."Coding Code";
        // lrc_BatchVariant."Item Attribute 5" := vrc_PackOrderOutputItems."Item Attribute 5";
        // lrc_BatchVariant."Item Attribute 6" := vrc_PackOrderOutputItems."Item Attribute 6";

        lrc_BatchVariant."Net Weight" := vrc_PackOrderOutputItems."Net Weight";
        lrc_BatchVariant."Gross Weight" := vrc_PackOrderOutputItems."Gross Weight";
        lrc_BatchVariant."Average Customs Weight" := 0;

        lrc_BatchVariant."Departure Date" := lrc_PackOrderHeader."Order Date";
        lrc_BatchVariant."Order Date" := lrc_PackOrderHeader."Order Date";
        lrc_BatchVariant."Date of Delivery" := lrc_PackOrderHeader."Expected Receipt Date";
        IF lrc_PackOrderHeader."Promised Receipt Date" <> 0D THEN
            lrc_BatchVariant."Date of Delivery" := lrc_PackOrderHeader."Promised Receipt Date";

        lrc_BatchVariant."Kind of Settlement" := 0;
        lrc_BatchVariant.Weight := 0;
        IF lrc_PackOrderHeader."Pack.-by Vendor No." <> '' THEN
            lrc_BatchVariant."Producer No." := lrc_PackOrderHeader."Pack.-by Vendor No."
        ELSE
            lrc_BatchVariant."Producer No." := lrc_PackOrderHeader."Vendor No.";

        IF vrc_PackOrderOutputItems."Lot No." <> '' THEN
            lrc_BatchVariant."Lot No. Producer" := vrc_PackOrderOutputItems."Lot No.";

        lrc_BatchVariant."Entry Location Code" := vrc_PackOrderOutputItems."Location Code";

        lrc_BatchVariant."Info 1" := vrc_PackOrderOutputItems."Info 1";
        lrc_BatchVariant."Info 2" := vrc_PackOrderOutputItems."Info 2";
        lrc_BatchVariant."Info 3" := vrc_PackOrderOutputItems."Info 3";
        lrc_BatchVariant."Info 4" := vrc_PackOrderOutputItems."Info 4";

        lrc_BatchVariant."Date of Expiry" := vrc_PackOrderOutputItems."Expiry Date";
        IF vrc_PackOrderOutputItems."Date of Expiry" <> 0D THEN
            lrc_BatchVariant."Date of Expiry" := vrc_PackOrderOutputItems."Date of Expiry";

        lrc_BatchVariant."Kind of Loading" := 0;
        //lrc_BatchVariant."Voyage No." := '';
        lrc_BatchVariant."Container No." := '';
        lrc_BatchVariant."Means of Transport Type" := 0;
        lrc_BatchVariant."Means of Transp. Code (Depart)" := '';
        lrc_BatchVariant."Means of Transp. Code (Arriva)" := '';
        lrc_BatchVariant."Means of Transport Info" := '';

        lrc_BatchVariant."Waste Disposal Duty" := vrc_PackOrderOutputItems."Waste Disposal Duty";
        lrc_BatchVariant."Waste Disposal Payment By" := vrc_PackOrderOutputItems."Waste Disposal Payment Thru";

        lrc_BatchVariant."Empties Item No." := vrc_PackOrderOutputItems."Empties Item No.";
        lrc_BatchVariant."Empties Quantity" := vrc_PackOrderOutputItems."Empties Quantity";

        CASE lrc_PackOrderHeader."Document Type" OF
            lrc_PackOrderHeader."Document Type"::"Packing Order":
                lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Packing Order";
            lrc_PackOrderHeader."Document Type"::"Sorting Order":
                lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Sorting Order";
            lrc_PackOrderHeader."Document Type"::"Substitution Order":
                lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Packing Order";
        END;
        lrc_BatchVariant."Source No." := vrc_PackOrderOutputItems."Doc. No.";
        lrc_BatchVariant."Source Line No." := vrc_PackOrderOutputItems."Line No.";
        lrc_BatchVariant."Source Company" := copystr(COMPANYNAME(), 1, 30);

        lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
        //lrc_BatchVariant."Guaranteed Shelf Life" := lrc_Item."Guaranteed Shelf Life Purch.";

        lrc_BatchVariant."Shortcut Dimension 1 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 1 Code";
        lrc_BatchVariant."Shortcut Dimension 2 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 2 Code";
        lrc_BatchVariant."Shortcut Dimension 3 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 3 Code";
        lrc_BatchVariant."Shortcut Dimension 4 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 4 Code";

        lrc_BatchVariant.INSERT();

        // Rückgabewerte setzen
        rco_BatchCode := lco_BatchCode;
        rco_BatchVariantCode := BatchVariantCode;

    end;

    procedure PackUpdBatchVar(vrc_PackOrderOutputItems: Record "POI Pack. Order Output Items")
    var

        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        //lrc_PackDocSubtype: Record "5110725";
        lrc_Vendor: Record Vendor;
        lcu_BaseDataTemplateMgt: Codeunit "POI BDT Base Data Template Mgt";
    //lcu_CustomerSpecificFunctions: Codeunit "POI Customer Spec. Functions";
    begin
        // --------------------------------------------------------------------------------
        // Aktualisierung einer vorhandenen Positionsvariante über Packauftrag Output
        // --------------------------------------------------------------------------------

        // Wenn keine Positionsvaraintennr. vorhanden
        IF vrc_PackOrderOutputItems."Batch Variant No." = '' THEN
            EXIT;
        IF vrc_PackOrderOutputItems."Item No." = '' THEN
            EXIT;
        // Packereikopfsatz lesen
        lrc_PackOrderHeader.GET(vrc_PackOrderOutputItems."Doc. No.");

        // Wenn Positionsvariante vorhanden
        IF lrc_BatchVariant.GET(vrc_PackOrderOutputItems."Batch Variant No.") THEN BEGIN
            // Artikelstammsatz lesen
            lrc_Item.GET(vrc_PackOrderOutputItems."Item No.");

            lrc_BatchVariant.Description := lrc_Item.Description;
            lrc_BatchVariant."Description 2" := lrc_Item."Description 2";

            lrc_FruitVisionSetup.GET();
            IF lrc_FruitVisionSetup."Create Search No from BatchVar" = TRUE THEN
                lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item, lrc_BatchVariant)
            ELSE
                lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);


            IF (lrc_BatchVariant.Description = '') AND
               (lrc_BatchVariant."Description 2" = '') THEN BEGIN
                lrc_BatchVariant.Description := vrc_PackOrderOutputItems."Item Description";
                lrc_BatchVariant."Description 2" := vrc_PackOrderOutputItems."Item Description 2";
            END;

            lrc_BatchVariant."Item No." := vrc_PackOrderOutputItems."Item No.";
            lrc_BatchVariant."Variant Code" := vrc_PackOrderOutputItems."Variant Code";

            //   lrc_BatchVariant."Item Main Category Code" := lrc_Item."Item Main Category Code";
            //   lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
            //   lrc_BatchVariant."Product Group Code" := lrc_Item."Product Group Code";

            lrc_BatchVariant."Producer No." := '';
            lrc_BatchVariant."Country of Origin Code" := vrc_PackOrderOutputItems."Country of Origin Code";
            // lrc_BatchVariant."Variety Code" := vrc_PackOrderOutputItems."Variety Code";
            //  lrc_BatchVariant."Trademark Code" := vrc_PackOrderOutputItems."Trademark Code";
            lrc_BatchVariant."Caliber Code" := vrc_PackOrderOutputItems."Caliber Code";
            //   lrc_BatchVariant."Vendor Caliber Code" := '';//vrc_PackOrderOutputItems."Vendor Caliber Code";
            //   lrc_BatchVariant."Item Attribute 3" := vrc_PackOrderOutputItems."Item Attribute 3";
            //   lrc_BatchVariant."Item Attribute 2" := vrc_PackOrderOutputItems."Item Attribute 2";
            //   lrc_BatchVariant."Grade of Goods Code" := vrc_PackOrderOutputItems."Grade of Goods Code";
            //   lrc_BatchVariant."Item Attribute 7" := vrc_PackOrderOutputItems."Item Attribute 7";
            //   lrc_BatchVariant."Item Attribute 4" := vrc_PackOrderOutputItems."Item Attribute 4";
            //   lrc_BatchVariant."Coding Code" := vrc_PackOrderOutputItems."Coding Code";
            //   lrc_BatchVariant."Item Attribute 5" := vrc_PackOrderOutputItems."Item Attribute 5";
            //   lrc_BatchVariant."Item Attribute 6" := vrc_PackOrderOutputItems."Item Attribute 6";
            lrc_BatchVariant."Cultivation Type" := vrc_PackOrderOutputItems."Cultivation Type";

            lrc_BatchVariant."Master Batch No." := lrc_PackOrderHeader."Master Batch No.";
            lrc_BatchVariant."Batch No." := vrc_PackOrderOutputItems."Batch No.";

            IF lrc_BatchVariant."Vendor No." <> lrc_PackOrderHeader."Vendor No." THEN BEGIN
                lrc_BatchVariant."Vendor No." := lrc_PackOrderHeader."Vendor No.";
                IF lrc_Vendor.GET(lrc_PackOrderHeader."Vendor No.") THEN
                    lrc_BatchVariant."Vendor Search Name" := lrc_Vendor."Search Name";
                //  "B/L Shipper" := lrc_Vendor."B/L Shipper";
            END;

            lrc_BatchVariant."Net Weight" := vrc_PackOrderOutputItems."Net Weight";
            lrc_BatchVariant."Gross Weight" := vrc_PackOrderOutputItems."Gross Weight";
            lrc_BatchVariant."Average Customs Weight" := 0;

            lrc_BatchVariant."Departure Date" := lrc_PackOrderHeader."Order Date";
            lrc_BatchVariant."Order Date" := lrc_PackOrderHeader."Order Date";
            lrc_BatchVariant."Date of Delivery" := vrc_PackOrderOutputItems."Expected Receipt Date";
            IF vrc_PackOrderOutputItems."Promised Receipt Date" <> 0D THEN
                lrc_BatchVariant."Date of Delivery" := vrc_PackOrderOutputItems."Promised Receipt Date";

            lrc_BatchVariant."Kind of Settlement" := 0;
            lrc_BatchVariant.Weight := 0;
            IF lrc_PackOrderHeader."Pack.-by Vendor No." <> '' THEn
                lrc_BatchVariant."Producer No." := lrc_PackOrderHeader."Pack.-by Vendor No."
            ELSE
                lrc_BatchVariant."Producer No." := lrc_PackOrderHeader."Vendor No.";

            IF vrc_PackOrderOutputItems."Lot No." <> '' THEN
                lrc_BatchVariant."Lot No. Producer" := vrc_PackOrderOutputItems."Lot No.";

            lrc_BatchVariant."Entry Location Code" := vrc_PackOrderOutputItems."Location Code";
            lrc_BatchVariant."Info 1" := vrc_PackOrderOutputItems."Info 1";
            lrc_BatchVariant."Info 2" := vrc_PackOrderOutputItems."Info 2";
            lrc_BatchVariant."Info 3" := vrc_PackOrderOutputItems."Info 3";
            lrc_BatchVariant."Info 4" := vrc_PackOrderOutputItems."Info 4";
            lrc_BatchVariant."Date of Expiry" := vrc_PackOrderOutputItems."Expiry Date";
            IF vrc_PackOrderOutputItems."Date of Expiry" <> 0D THEN
                lrc_BatchVariant."Date of Expiry" := vrc_PackOrderOutputItems."Date of Expiry";

            lrc_BatchVariant."Waste Disposal Duty" := vrc_PackOrderOutputItems."Waste Disposal Duty";
            lrc_BatchVariant."Waste Disposal Payment By" := vrc_PackOrderOutputItems."Waste Disposal Payment Thru";
            lrc_BatchVariant."Status Customs Duty" := 0;

            lrc_BatchVariant."Empties Item No." := vrc_PackOrderOutputItems."Empties Item No.";
            lrc_BatchVariant."Empties Quantity" := vrc_PackOrderOutputItems."Empties Quantity";

            lrc_BatchVariant."Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
            lrc_BatchVariant."Unit of Measure Code" := vrc_PackOrderOutputItems."Unit of Measure Code";
            lrc_BatchVariant."Qty. per Unit of Measure" := vrc_PackOrderOutputItems."Qty. per Unit of Measure";

            lrc_BatchVariant."Content Unit of Measure (CP)" := vrc_PackOrderOutputItems."Content Unit of Measure (COU)";
            lrc_BatchVariant."Packing Unit of Measure (PU)" := vrc_PackOrderOutputItems."Packing Unit of Measure (PU)";
            lrc_BatchVariant."Qty. (PU) per Collo (CU)" := vrc_PackOrderOutputItems."Qty. (PU) per Unit of Measure";

            lrc_BatchVariant."Transport Unit of Measure (TU)" := vrc_PackOrderOutputItems."Transport Unit of Measure (TU)";
            lrc_BatchVariant."Qty. (Unit) per Transp. (TU)" := vrc_PackOrderOutputItems."Qty. (Unit) per Transp.(TU)";

            lrc_BatchVariant."Price Base (Purch. Price)" := vrc_PackOrderOutputItems."Price Base (Purch. Price)";

            lrc_BatchVariant."Price Base (Sales Price)" := vrc_PackOrderOutputItems."Price Base (Sales Price)";
            lrc_BatchVariant."Sales Price (Price Base)" := vrc_PackOrderOutputItems."Sales Price (Price Base)";

            lrc_BatchVariant."Market Unit Cost (Base) (LCY)" := vrc_PackOrderOutputItems."Market Unit Cost (Basis) (LCY)";

            lrc_BatchVariant."Source Line No." := vrc_PackOrderOutputItems."Line No.";
            lrc_BatchVariant."Location Reference No." := vrc_PackOrderOutputItems."Location Reference No.";
            lrc_BatchVariant."No. 2" := vrc_PackOrderOutputItems."Internal Reference No.";
            // Dimension Position Code füllen
            lrc_BatchSetup.GET();
            CASE lrc_BatchSetup."Dim. No. Batch No." OF
                1:
                    lrc_BatchVariant."Shortcut Dimension 1 Code" := lrc_BatchVariant."Batch No.";
                2:
                    lrc_BatchVariant."Shortcut Dimension 2 Code" := lrc_BatchVariant."Batch No.";
                3:
                    lrc_BatchVariant."Shortcut Dimension 3 Code" := lrc_BatchVariant."Batch No.";
                4:
                    lrc_BatchVariant."Shortcut Dimension 4 Code" := lrc_BatchVariant."Batch No.";
            END;

            lrc_BatchVariant."Shortcut Dimension 1 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 1 Code";
            lrc_BatchVariant."Shortcut Dimension 2 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 2 Code";
            lrc_BatchVariant."Shortcut Dimension 3 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 3 Code";
            lrc_BatchVariant."Shortcut Dimension 4 Code" := vrc_PackOrderOutputItems."Shortcut Dimension 4 Code";

            lrc_BatchVariant.MODIFY();

            IF lrc_BatchVariant."No." <> '' THEN BEGIN
                IF NOT lrc_PackOrderOutputItems.GET(vrc_PackOrderOutputItems."Doc. No.", vrc_PackOrderOutputItems."Line No.") THEN
                    lrc_PackOrderOutputItems.INIT();
                BatchVariantRecalc_Ins_Mod(lrc_BatchVariant."Item No.", lrc_BatchVariant."No.",
                  vrc_PackOrderOutputItems."Remaining Quantity (Base)" - lrc_PackOrderOutputItems."Remaining Quantity (Base)");
            END;

        END;

        //RS Batch aktualisieren
        PackUpdBatch(vrc_PackOrderOutputItems);

        SetBatchStatusOpen(vrc_PackOrderOutputItems."Batch No.");
    end;



    // procedure BatchPackingQuality(vco_BatchNo: Code[20];vco_BatchVariantNo: Code[20])
    // var
    //     lrc_BatchVariantPackingQuality: Record "5110367";
    //     lfm_BatchVarPackQualityCard: Form "5110488";
    // begin
    //     // ------------------------------------------------------------------------------
    //     // Funktion zur Erfassung der Packing Quality je Position / Positionsvariante
    //     // ------------------------------------------------------------------------------

    //     InitBatchPackingQuality(vco_BatchNo, vco_BatchVariantNo);
    //     InitBatchPackingQualityCaliber(vco_BatchNo, vco_BatchVariantNo);

    //     lrc_BatchVariantPackingQuality.FILTERGROUP(2);
    //     lrc_BatchVariantPackingQuality.SETRANGE("Batch No.",vco_BatchNo);
    //     lrc_BatchVariantPackingQuality.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //     lrc_BatchVariantPackingQuality.FILTERGROUP(0);

    //     lfm_BatchVarPackQualityCard.SETTABLEVIEW(lrc_BatchVariantPackingQuality);
    //     lfm_BatchVarPackQualityCard.RUNMODAL;
    // end;

    //     procedure BatchVariantRetraceability(rco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchVariantRetraceability: Record "5110525";
    //         lfm_BatchVariantRetraceability: Form "5110493";
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         // ------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Positionsvarianten Rückverfolgbarkeit
    //         // ------------------------------------------------------------------------------

    //         lrc_BatchVariant.GET( rco_BatchVariantNo);

    //         lrc_BatchVariantRetraceability.RESET();
    //         lrc_BatchVariantRetraceability.SETRANGE("Entries For Batch Variant No.", rco_BatchVariantNo);
    //         IF lrc_BatchVariantRetraceability.FIND('-') THEN;

    //         lfm_BatchVariantRetraceability.SETTABLEVIEW(lrc_BatchVariantRetraceability);
    //         lfm_BatchVariantRetraceability.RUNMODAL;
    //     end;

    //     procedure InitBatchPackingQuality(vco_BatchNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchVariantPackingQuality: Record "5110367";
    //         lrc_FruitvisionSetup: Record "5110302";
    //         lrc_ItemUnitOfMeasure: Record "5404";
    //     begin
    //         // ------------------------------------------------------------------------------
    //         // Funktion zur Initialisierung der Packing Quality je Position / Positionsvariante
    //         // ------------------------------------------------------------------------------

    //         lrc_BatchVariant.GET(vco_BatchVariantNo);

    //         lrc_BatchVariantPackingQuality.RESET();
    //         lrc_BatchVariantPackingQuality.SETRANGE("Batch No.",vco_BatchNo);
    //         lrc_BatchVariantPackingQuality.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //         IF NOT lrc_BatchVariantPackingQuality.FINDFIRST() THEN BEGIN
    //           lrc_BatchVariantPackingQuality.RESET();
    //           lrc_BatchVariantPackingQuality.INIT();
    //           lrc_BatchVariantPackingQuality."Batch No." := vco_BatchNo;
    //           lrc_BatchVariantPackingQuality."Batch Variant No." := vco_BatchVariantNo;
    //           lrc_BatchVariantPackingQuality."Item No." := lrc_BatchVariant."Item No.";

    //           IF lrc_Item.GET(lrc_BatchVariant."Item No.") THEN BEGIN
    //         ////    lrc_BatchVariantPackingQuality."Spectrum Caliber A-Goods" := lrc_Item."Spectrum Caliber A-Goods";
    //           END;

    //           lrc_FruitvisionSetup.GET();
    //           IF lrc_FruitvisionSetup."Internal Customer Code" = 'MEV' THEN BEGIN
    //             lrc_BatchVariantPackingQuality."Unit of Measure Code (Profed)" := lrc_BatchVariant."Base Unit of Measure (BU)";
    //           END ELSE BEGIN
    //             lrc_BatchVariantPackingQuality."Unit of Measure Code (Profed)" := lrc_BatchVariant."Unit of Measure Code";
    //           END;

    //           lrc_BatchVariantPackingQuality."Variant Code" := lrc_BatchVariant."Variant Code";
    //           lrc_BatchVariantPackingQuality."Base Unit of Measure Code" := lrc_BatchVariant."Base Unit of Measure (BU)";
    //           IF lrc_ItemUnitOfMeasure.GET(lrc_BatchVariantPackingQuality."Item No.",
    //                                         lrc_BatchVariantPackingQuality."Unit of Measure Code (Profed)") THEN BEGIN
    //             lrc_BatchVariantPackingQuality."Qty. per Base Unit of Measure" := lrc_ItemUnitOfMeasure."Qty. per Unit of Measure";
    //           END ELSE BEGIN
    //             lrc_BatchVariantPackingQuality."Qty. per Base Unit of Measure" := lrc_BatchVariant."Qty. per Unit of Measure";
    //           END;

    //           IF lrc_BatchVariantPackingQuality."Qty. per Base Unit of Measure" = 0 THEN BEGIN
    //             lrc_BatchVariantPackingQuality."Qty. per Base Unit of Measure" := 1;
    //           END;

    //           lrc_BatchVariantPackingQuality.insert();
    //           COMMIT;
    //         END;
    //     end;

    //     procedure InitBatchPackingQualityCaliber(vco_BatchNo: Code[20];vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchVarPackQualityCaliber: Record "5110486";
    //         lrc_Caliber: Record "5110304";
    //         lrc_ProductGroupCaliber: Record "5110315";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zur Initialisierung der Packing Quality Caliber je Position / Positionsvariante
    //         // -------------------------------------------------------------------------------------------

    //         lrc_BatchVariant.GET(vco_BatchVariantNo);

    //         lrc_BatchVarPackQualityCaliber.RESET();
    //         lrc_BatchVarPackQualityCaliber.SETRANGE("Batch No.",vco_BatchNo);
    //         lrc_BatchVarPackQualityCaliber.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //         IF NOT lrc_BatchVarPackQualityCaliber.FIND('-') THEN BEGIN

    //           lrc_Item.GET(lrc_BatchVariant."Item No.");
    //           IF lrc_Item."Product Group Code" <> '' THEN BEGIN
    //             lrc_ProductGroupCaliber.RESET();
    //             lrc_ProductGroupCaliber.SETRANGE("Product Group Code", lrc_Item."Product Group Code");
    //             IF lrc_ProductGroupCaliber.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_BatchVarPackQualityCaliber.RESET();
    //                 lrc_BatchVarPackQualityCaliber.INIT();
    //                 lrc_BatchVarPackQualityCaliber."Batch No." := vco_BatchNo;
    //                 lrc_BatchVarPackQualityCaliber."Batch Variant No." := vco_BatchVariantNo;
    //                 lrc_BatchVarPackQualityCaliber."Caliber Code" := lrc_ProductGroupCaliber."Caliber Code";
    //                 lrc_BatchVarPackQualityCaliber."Item No." := lrc_BatchVariant."Item No.";
    //                 lrc_BatchVarPackQualityCaliber."Unit of Measure Code (Profed)" := lrc_BatchVariant."Unit of Measure Code";
    //                 lrc_BatchVarPackQualityCaliber."Base Unit of Measure Code" := lrc_BatchVariant."Base Unit of Measure (BU)";
    //                 lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" := lrc_BatchVariant."Qty. per Unit of Measure";
    //                 IF lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" = 0 THEN BEGIN
    //                   lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" := 1;
    //                 END;
    //                 lrc_BatchVarPackQualityCaliber.insert();
    //               UNTIL lrc_ProductGroupCaliber.NEXT() = 0;
    //             END ELSE BEGIN
    //               lrc_Caliber.RESET();
    //               IF lrc_Caliber.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   lrc_BatchVarPackQualityCaliber.RESET();
    //                   lrc_BatchVarPackQualityCaliber.INIT();
    //                   lrc_BatchVarPackQualityCaliber."Batch No." := vco_BatchNo;
    //                   lrc_BatchVarPackQualityCaliber."Batch Variant No." := vco_BatchVariantNo;
    //                   lrc_BatchVarPackQualityCaliber."Caliber Code" := lrc_Caliber.Code;
    //                   lrc_BatchVarPackQualityCaliber."Item No." := lrc_BatchVariant."Item No.";
    //                   lrc_BatchVarPackQualityCaliber."Variant Code" := lrc_BatchVariant."Variant Code";
    //                   lrc_BatchVarPackQualityCaliber."Unit of Measure Code (Profed)" := lrc_BatchVariant."Unit of Measure Code";
    //                   lrc_BatchVarPackQualityCaliber."Base Unit of Measure Code" := lrc_BatchVariant."Base Unit of Measure (BU)";
    //                   lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" := lrc_BatchVariant."Qty. per Unit of Measure";
    //                   IF lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" = 0 THEN BEGIN
    //                     lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" := 1;
    //                   END;
    //                   lrc_BatchVarPackQualityCaliber.insert();
    //                 UNTIL lrc_Caliber.NEXT() = 0;
    //               END;
    //             END;
    //           END ELSE BEGIN
    //             lrc_Caliber.RESET();
    //             IF lrc_Caliber.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_BatchVarPackQualityCaliber.RESET();
    //                 lrc_BatchVarPackQualityCaliber.INIT();
    //                 lrc_BatchVarPackQualityCaliber."Batch No." := vco_BatchNo;
    //                 lrc_BatchVarPackQualityCaliber."Batch Variant No." := vco_BatchVariantNo;
    //                 lrc_BatchVarPackQualityCaliber."Caliber Code" := lrc_Caliber.Code;
    //                 lrc_BatchVarPackQualityCaliber."Item No." := lrc_BatchVariant."Item No.";
    //                 lrc_BatchVarPackQualityCaliber."Variant Code" := lrc_BatchVariant."Variant Code";
    //                 lrc_BatchVarPackQualityCaliber."Unit of Measure Code (Profed)" := lrc_BatchVariant."Unit of Measure Code";
    //                 lrc_BatchVarPackQualityCaliber."Base Unit of Measure Code" := lrc_BatchVariant."Base Unit of Measure (BU)";
    //                 lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" := lrc_BatchVariant."Qty. per Unit of Measure";
    //                 IF lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" = 0 THEN BEGIN
    //                   lrc_BatchVarPackQualityCaliber."Qty. per Base Unit of Measure" := 1;
    //                 END;
    //                 lrc_BatchVarPackQualityCaliber.insert();
    //               UNTIL lrc_Caliber.NEXT() = 0;
    //             END;
    //           END;
    //           COMMIT;
    //         END;
    //     end;

    procedure LoadBatchNoInBuffer(vco_MasterBatchNo: Code[20]; vco_VoyageCode: Code[20]; vco_SalesReferenceNo: Code[20]; vco_PurchOrderNo: Code[20]; vco_CostCategory: Code[20])
    var
        lrc_GeneralLedgerSetup: Record "General Ledger Setup";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_PurchHeader: Record "Purchase Header";
        lrc_Vendor: Record Vendor;
        lrc_UnitofMeasure: Record "Unit of Measure";
        lin_BatchItemLines: Integer;
        ltx_Filter: Text[1024];
        AGILES_LT_TEXT002Txt: Label 'Fehlende Parameter zum Laden der Positionsnr. in Buffer!';
        AGILES_LT_TEXT001Txt: Label 'There are no Batches for Master Batch No. %1 available!', Comment = '%1 = ';
        ldc_PostedCost: Decimal;
        ldc_PostedQty: Decimal;
    begin
        // -------------------------------------------------------------------------------------------
        // Funktion zum Laden aller Positionsnummern einer Reise / Partie in die "Batch Temp" Tabelle
        // -------------------------------------------------------------------------------------------

        // Kontrolle ob Partie oder Reisecode übergeben wurden
        IF (vco_MasterBatchNo = '') AND
           (vco_VoyageCode = '') AND
           (vco_SalesReferenceNo = '') THEN
            // Fehlende Parameter zum Laden der Positionsnr. in Buffer!
            ERROR(AGILES_LT_TEXT002Txt);

        // Temp Tabelle leeren
        lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
        lrc_BatchTemp.SETRANGE("USERID Code", USERID());
        lrc_BatchTemp.DELETEALL();

        lrc_Batch.RESET();
        IF vco_MasterBatchNo <> '' THEN BEGIN
            lrc_Batch.SETCURRENTKEY("Master Batch No.");
            lrc_Batch.SETRANGE("Master Batch No.", vco_MasterBatchNo);
        END ELSE
            IF vco_VoyageCode <> '' THEN BEGIN
                lrc_Batch.SETCURRENTKEY("Voyage No.", "Master Batch No.");
                lrc_Batch.SETRANGE("Voyage No.", vco_VoyageCode);
            END ELSE
                ERROR('Error!');


        IF vco_SalesReferenceNo <> '' THEN BEGIN
            ltx_Filter := '';
            lrc_SalesShipmentLine.RESET();
            lrc_SalesShipmentLine.SETRANGE("Document No.", vco_SalesReferenceNo);
            lrc_SalesShipmentLine.SETFILTER("POI Batch No.", '<>%1', '');
            IF lrc_SalesShipmentLine.FINDSET(FALSE, FALSE) THEN BEGIN
                REPEAT
                    lrc_BatchTempNew.RESET();
                    lrc_BatchTempNew.SETRANGE("No.", lrc_SalesShipmentLine."POI Batch No.");
                    IF NOT lrc_BatchTempNew.FIND('-') THEN BEGIN
                        lrc_BatchTempNew.INIT();
                        lrc_BatchTempNew."No." := lrc_SalesShipmentLine."POI Batch No.";
                        lrc_BatchTempNew.INSERT();
                    END;
                UNTIL lrc_SalesShipmentLine.NEXT() = 0;

                // Filter erzeugen
                lrc_BatchTempNew.RESET();
                IF lrc_BatchTempNew.FINDSET(FALSE, FALSE) THEN BEGIN
                    REPEAT
                        IF ltx_Filter = '' THEN
                            ltx_Filter := lrc_BatchTempNew."No."
                        ELSE
                            ltx_Filter := copystr(ltx_Filter + '|' + lrc_BatchTempNew."No.", 1, 1024);
                    UNTIL lrc_BatchTempNew.NEXT() = 0;
                    // Filter setzen
                    lrc_Batch.SETFILTER("No.", ltx_Filter);
                END;
            END;
        END;

        IF lrc_Batch.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT

                lrc_Item.INIT();
                lrc_BatchVariant.RESET();
                lrc_BatchVariant.SETCURRENTKEY("Batch No.");
                lrc_BatchVariant.SETRANGE("Batch No.", lrc_Batch."No.");
                IF lrc_BatchVariant.FINDLAST() THEN
                    IF lrc_Item.GET(lrc_BatchVariant."Item No.") THEN;

                lrc_BatchTemp.RESET();
                lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
                lrc_BatchTemp.SETRANGE("USERID Code", USERID());
                lrc_BatchTemp.SETRANGE("MCS Batch No.", lrc_Batch."No.");
                lrc_BatchTemp.SETRANGE("MCS Master Batch No.", lrc_Batch."Master Batch No.");
                IF NOT lrc_BatchTemp.FINDFIRST() THEN BEGIN

                    lrc_BatchTemp.RESET();
                    lrc_BatchTemp.INIT();
                    lrc_BatchTemp."Entry Type" := lrc_BatchTemp."Entry Type"::MCS;
                    lrc_BatchTemp."USERID Code" := copystr(USERID(), 1, 50);
                    lrc_BatchTemp."Entry No." := 0;
                    lrc_BatchTemp."MCS Item No." := lrc_Item."No.";
                    lrc_BatchTemp."MCS Item Searchname" := lrc_Item."Search Description";
                    lrc_BatchTemp."MCS Batch No." := lrc_Batch."No.";
                    lrc_BatchTemp."MCS Master Batch No." := lrc_Batch."Master Batch No.";
                    lrc_BatchTemp."MCS Voyage No." := lrc_Batch."Voyage No.";
                    lrc_BatchTemp."MCS Caliber Code" := lrc_BatchVariant."Caliber Code";
                    lrc_BatchTemp."MCS Producer No." := lrc_BatchVariant."Producer No.";
                    lrc_BatchTemp."MCS Producer Search Name" := '';
                    IF lrc_Vendor.GET(lrc_BatchVariant."Producer No.") THEN
                        lrc_BatchTemp."MCS Producer Search Name" := COPYSTR(lrc_Vendor."Search Name", 1, 50);
                    lrc_BatchTemp."MCS Container No." := lrc_BatchVariant."Container No.";
                    lrc_BatchTemp."MCS Unit of Measure Code" := lrc_BatchVariant."Unit of Measure Code";

                    lrc_BatchTemp."MCS Unit of Measure Desc." := '';
                    IF lrc_UnitofMeasure.GET(lrc_BatchVariant."Unit of Measure Code") THEN
                        lrc_BatchTemp."MCS Unit of Measure Desc." := lrc_UnitofMeasure.Description;

                    lrc_BatchTemp."MCS Trademark" := lrc_BatchVariant."Trademark Code";
                    lrc_BatchTemp."MCS Vendor No." := lrc_BatchVariant."Vendor No.";
                    lrc_BatchTemp."MCS Vendor Search Name" := '';
                    IF lrc_Vendor.GET(lrc_BatchVariant."Vendor No.") THEN
                        lrc_BatchTemp."MCS Vendor Search Name" := COPYSTR(lrc_Vendor."Search Name", 1, 50);

                    lrc_BatchTemp."MCS Variety Code" := lrc_BatchVariant."Variety Code";

                    lrc_BatchTemp."MCS Info 1" := lrc_BatchVariant."Info 1";
                    lrc_BatchTemp."MCS Info 2" := lrc_BatchVariant."Info 2";
                    lrc_BatchTemp."MCS Info 3" := lrc_BatchVariant."Info 3";
                    lrc_BatchTemp."MCS Info 4" := lrc_BatchVariant."Info 4";
                    lrc_BatchTemp."MCS Empties Item No." := lrc_BatchVariant."Empties Item No.";

                    lrc_BatchTemp."MCS Total Amount" := 0;
                    lrc_BatchTemp."MCS Quantity Colli" := 0;
                    lrc_BatchTemp."MCS Quantity Pallets" := 0;
                    lrc_BatchTemp."MCS Quantity Packings" := 0;
                    lrc_BatchTemp."MCS Gross Weight" := 0;
                    lrc_BatchTemp."MCS Net Weight" := 0;
                    lrc_BatchTemp."MCS No. of Lines" := 0;
                    lrc_BatchTemp."MCS Qty. Colly Sold Duty paid" := 0;
                    lrc_BatchTemp."MCS Without Allocation" := FALSE;
                    lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::" ";
                    //lrc_BatchTemp."MCS System" := lrc_BatchTemp."MCS System"::"1"; //TODO: prüfen

                    lrc_BatchTemp.INSERT(TRUE);

                    // Summenwerte aus Bestellung ermitteln
                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETCURRENTKEY("POI Batch No.", Type, "No.", "Document Type");
                    lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
                    lrc_PurchLine.SETRANGE("POI Master Batch No.", lrc_Batch."Master Batch No.");
                    lrc_PurchLine.SETRANGE("POI Batch No.", lrc_Batch."No.");
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETFILTER("No.", '<>%1', '');
                    IF lrc_PurchLine.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            //RS PurchLine.Amount durch Line Amount ersetzt
                            //lrc_BatchTemp."MCS Total Amount" := lrc_BatchTemp."MCS Total Amount" + lrc_PurchLine.Amount;
                            lrc_BatchTemp."MCS Total Amount" := lrc_BatchTemp."MCS Total Amount" + lrc_PurchLine."Line Amount";
                            lrc_BatchTemp."MCS Quantity Colli" := lrc_BatchTemp."MCS Quantity Colli" + lrc_PurchLine.Quantity;

                            IF lrc_PurchLine."POI Quantity (TU)" = 0 THEN
                                lrc_ItemTransportUnitFaktor.SETRANGE("Item No.", lrc_PurchLine."No.");
                            lrc_ItemTransportUnitFaktor.SETRANGE("Unit of Measure Code", lrc_PurchLine."Unit of Measure Code");
                            lrc_ItemTransportUnitFaktor.SETRANGE("Transport Unit of Measure (TU)", lrc_PurchLine."POI Transport Unit of Meas(TU)");
                            lrc_ItemTransportUnitFaktor.SETFILTER("Qty. (Unit) per Transp. Unit", '<>%1', 0);
                            IF lrc_ItemTransportUnitFaktor.FINDFIRST() THEN
                                lrc_BatchTemp."MCS Quantity Pallets" := lrc_BatchTemp."MCS Quantity Pallets" +
                                                 ROUND(lrc_PurchLine.Quantity /
                                                       lrc_ItemTransportUnitFaktor."Qty. (Unit) per Transp. Unit", 0.01)
                            ELSE
                                lrc_BatchTemp."MCS Quantity Pallets" := lrc_BatchTemp."MCS Quantity Pallets" + lrc_PurchLine."POI Quantity (TU)";

                            lrc_BatchTemp."MCS Quantity Packings" := lrc_BatchTemp."MCS Quantity Packings" + lrc_PurchLine."POI Quantity (PU)";
                            lrc_BatchTemp."MCS Gross Weight" := lrc_BatchTemp."MCS Gross Weight" + lrc_PurchLine."POI Total Gross Weight";
                            lrc_BatchTemp."MCS Net Weight" := lrc_BatchTemp."MCS Net Weight" + lrc_PurchLine."POI Total Net Weight";
                            lrc_BatchTemp."MCS No. of Lines" := lrc_BatchTemp."MCS No. of Lines" + 1;
                            lrc_BatchTemp.MODIFY();

                        UNTIL lrc_PurchLine.NEXT() = 0;

                    BEGIN

                        // Werte aus Buchungen holen
                        lrc_ItemLedgerEntry.RESET();
                        lrc_ItemLedgerEntry.SETCURRENTKEY("POI Batch No.", "Entry Type", "Location Code", "Posting Date");
                        lrc_ItemLedgerEntry.SETRANGE("Entry Type", lrc_ItemLedgerEntry."Entry Type"::Purchase);
                        lrc_ItemLedgerEntry.SETRANGE("POI Batch No.", lrc_Batch."No.");
                        IF lrc_ItemLedgerEntry.FINDSET(FALSE, FALSE) THEN
                            REPEAT
                                lrc_ItemLedgerEntry.CALCFIELDS("Purchase Amount (Actual)", "Purchase Amount (Expected)");
                                lrc_BatchTemp."MCS Total Amount" := lrc_BatchTemp."MCS Total Amount" +
                                                                    lrc_ItemLedgerEntry."Purchase Amount (Expected)" +
                                                                    lrc_ItemLedgerEntry."Purchase Amount (Actual)";
                                lrc_BatchTemp."MCS Quantity Colli" := lrc_BatchTemp."MCS Quantity Colli" +
                                                                   (lrc_ItemLedgerEntry.Quantity /
                                                                    lrc_ItemLedgerEntry."Qty. per Unit of Measure");
                                lrc_ItemTransportUnitFaktor.SETRANGE("Item No.", lrc_ItemLedgerEntry."Item No.");
                                lrc_ItemTransportUnitFaktor.SETRANGE("Unit of Measure Code", lrc_ItemLedgerEntry."Unit of Measure Code");
                                lrc_ItemTransportUnitFaktor.SETRANGE("Transport Unit of Measure (TU)", '');
                                lrc_ItemTransportUnitFaktor.SETFILTER("Qty. (Unit) per Transp. Unit", '<>%1', 0);
                                IF lrc_ItemTransportUnitFaktor.FIND('-') THEN
                                    lrc_BatchTemp."MCS Quantity Pallets" := lrc_BatchTemp."MCS Quantity Pallets" +
                                       ROUND((lrc_ItemLedgerEntry.Quantity / lrc_ItemLedgerEntry."Qty. per Unit of Measure") /
                                             lrc_ItemTransportUnitFaktor."Qty. (Unit) per Transp. Unit", 0.01);
                                lrc_BatchTemp."MCS Quantity Packings" := lrc_BatchTemp."MCS Quantity Packings" + 0;
                                lrc_BatchTemp."MCS Gross Weight" := lrc_BatchTemp."MCS Gross Weight" + lrc_ItemLedgerEntry."POI Total Gross Weight";
                                lrc_BatchTemp."MCS Net Weight" := lrc_BatchTemp."MCS Net Weight" + lrc_ItemLedgerEntry."POI Total Net Weight";
                                lrc_BatchTemp."MCS No. of Lines" := lrc_BatchTemp."MCS No. of Lines" + 1;
                                lrc_BatchTemp.MODIFY();
                            UNTIL lrc_ItemLedgerEntry.NEXT() = 0;

                    END;


                    // Mengen verkauft und verzollt berechnen
                    lrc_ItemLedgerEntry.RESET();
                    lrc_ItemLedgerEntry.SETCURRENTKEY("POI Batch No.", "Entry Type", "Location Code", "Posting Date");
                    lrc_ItemLedgerEntry.SETRANGE("POI Batch No.", lrc_Batch."No.");
                    lrc_ItemLedgerEntry.SETRANGE("Entry Type", lrc_ItemLedgerEntry."Entry Type"::Sale);
                    IF lrc_ItemLedgerEntry.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            IF lrc_ItemLedgerEntry."POI Status Customs Duty" = lrc_ItemLedgerEntry."POI Status Customs Duty"::Payed THEN
                                lrc_BatchTemp."MCS Qty. Colly Sold Duty paid" := lrc_BatchTemp."MCS Qty. Colly Sold Duty paid" +
                                                                     ((lrc_ItemLedgerEntry.Quantity /
                                                                       lrc_ItemLedgerEntry."Qty. per Unit of Measure") * -1);
                            lrc_BatchTemp.MODIFY();
                        UNTIL lrc_ItemLedgerEntry.NEXT() = 0;


                    // Gebuchte Werte und Mengen berechnen
                    IF vco_CostCategory <> '' THEN BEGIN

                        lrc_GeneralLedgerSetup.GET();
                        lrc_BatchSetup.GET();

                        ldc_PostedCost := 0;
                        ldc_PostedQty := 0;

                        lrc_CostCategory.RESET();
                        lrc_CostCategory.SETRANGE(Code, vco_CostCategory);
                        IF lrc_CostCategory.FINDSET(FALSE, FALSE) THEN
                            REPEAT

                                // Zugeordnete Sachkonten lesen
                                lrc_CostCategoryAccounts.RESET();
                                lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
                                lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
                                lrc_CostCategoryAccounts.SETFILTER("G/L Account No.", '<>%1', '');
                                IF lrc_CostCategoryAccounts.FINDSET(FALSE, FALSE) THEN
                                    REPEAT
                                        lrc_GLEntry.RESET();
                                        lrc_GLEntry.SETCURRENTKEY("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code",
                                                                 "Global Dimension 2 Code", "Close Income Statement Dim. ID", "Posting Date");
                                        lrc_GLEntry.SETRANGE("G/L Account No.", lrc_CostCategoryAccounts."G/L Account No.");
                                        CASE lrc_BatchSetup."Dim. No. Batch No." OF
                                            lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
                                                lrc_GLEntry.SETRANGE("Global Dimension 1 Code", lrc_Batch."No.");
                                            lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
                                                lrc_GLEntry.SETRANGE("Global Dimension 2 Code", lrc_Batch."No.");
                                            lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
                                                lrc_GLEntry.SETRANGE("POI Global Dimension 3 Code", lrc_Batch."No.");
                                            lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
                                                lrc_GLEntry.SETRANGE("POI Global Dimension 4 Code", lrc_Batch."No.");
                                            ELSE
                                                // Dimensionsebene nicht zulässig!
                                                ERROR(AGILES_LT_TEXT002Txt);
                                        END;
                                        // Kontrolle ob es eine weitere Dimensionseingrenzung auf dem Konto gibt
                                        IF (lrc_CostCategoryAccounts."Dimension Code" <> '') AND
                                           (lrc_CostCategoryAccounts."Dimension Value" <> '') THEN
                                            CASE lrc_CostCategoryAccounts."Dimension Code" OF
                                                lrc_GeneralLedgerSetup."Global Dimension 1 Code":
                                                    lrc_GLEntry.SETRANGE("Global Dimension 1 Code", lrc_CostCategoryAccounts."Dimension Value");
                                                lrc_GeneralLedgerSetup."Global Dimension 2 Code":
                                                    lrc_GLEntry.SETRANGE("Global Dimension 2 Code", lrc_CostCategoryAccounts."Dimension Value");
                                                lrc_GeneralLedgerSetup."POI Global Dimension 3 Code":
                                                    lrc_GLEntry.SETRANGE("POI Global Dimension 3 Code", lrc_CostCategoryAccounts."Dimension Value");
                                                lrc_GeneralLedgerSetup."POI Global Dimension 4 Code":
                                                    lrc_GLEntry.SETRANGE("POI Global Dimension 4 Code", lrc_CostCategoryAccounts."Dimension Value");
                                            END;
                                        IF lrc_GLEntry.FINDSET(FALSE, FALSE) THEN
                                            REPEAT
                                                ldc_PostedCost := ldc_PostedCost + lrc_GLEntry.Amount;
                                                ldc_PostedQty := ldc_PostedQty + lrc_GLEntry.Quantity;
                                            UNTIL lrc_GLEntry.NEXT() = 0;
                                    UNTIL lrc_CostCategoryAccounts.NEXT() = 0;
                            UNTIL lrc_CostCategory.NEXT() = 0;
                        lrc_BatchTemp."MCS Posted Qty. (Cost Inv.)" := ldc_PostedQty;
                        lrc_BatchTemp."MCS Posted Amount" := ldc_PostedCost;
                        lrc_BatchTemp.MODIFY();
                    END;
                END;
            UNTIL lrc_Batch.NEXT() = 0;


            // Leersätze löschen
            lrc_BatchTemp.RESET();
            lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
            lrc_BatchTemp.SETRANGE("USERID Code", USERID());
            lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
            IF lrc_BatchTemp.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    IF (lrc_BatchTemp."MCS Total Amount" = 0) AND
                       (lrc_BatchTemp."MCS Quantity Colli" = 0) AND
                       (lrc_BatchTemp."MCS Quantity Pallets" = 0) AND
                       (lrc_BatchTemp."MCS Quantity Packings" = 0) AND
                       (lrc_BatchTemp."MCS Gross Weight" = 0) AND
                       (lrc_BatchTemp."MCS Net Weight" = 0) AND
                       (lrc_BatchTemp."MCS No. of Lines" = 0) AND
                       (lrc_BatchTemp."MCS Qty. Colly Sold Duty paid" = 0) THEN
                        lrc_BatchTemp.DELETE();
                UNTIL lrc_BatchTemp.NEXT() = 0;


            // Summensätze für Reisenummer und Partienummer/n bilden
            lrc_BatchTemp.RESET();
            lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
            lrc_BatchTemp.SETRANGE("USERID Code", USERID());
            lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
            IF lrc_BatchTemp.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    IF lrc_BatchTemp."MCS Voyage No." <> '' THEN BEGIN
                        lrc_MasterBatchTemp.RESET();
                        lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                        lrc_MasterBatchTemp.SETRANGE("USERID Code", USERID());
                        lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", '');
                        lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", lrc_BatchTemp."MCS Voyage No.");
                        lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
                        IF lrc_MasterBatchTemp.ISEMPTY() THEN BEGIN
                            lrc_MasterBatchTemp.RESET();
                            lrc_MasterBatchTemp.INIT();
                            lrc_MasterBatchTemp."Entry Type" := lrc_MasterBatchTemp."Entry Type"::MCS;
                            lrc_MasterBatchTemp."USERID Code" := copystr(USERID(), 1, 50);
                            lrc_MasterBatchTemp."Entry No." := 0;
                            lrc_MasterBatchTemp."MCS Batch No." := '';
                            lrc_MasterBatchTemp."MCS Master Batch No." := '';
                            lrc_MasterBatchTemp."MCS Voyage No." := lrc_BatchTemp."MCS Voyage No.";
                            lrc_MasterBatchTemp."MCS Without Allocation" := FALSE;
                            lrc_MasterBatchTemp."MCS Allocation Key" := lrc_MasterBatchTemp."MCS Allocation Key"::" ";
                            lrc_MasterBatchTemp."MCS System" := lrc_MasterBatchTemp."MCS System";
                            lrc_MasterBatchTemp.INSERT(TRUE);
                        END;
                    END;
                    IF lrc_BatchTemp."MCS Master Batch No." <> '' THEN BEGIN
                        lrc_MasterBatchTemp.RESET();
                        lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                        lrc_MasterBatchTemp.SETRANGE("USERID Code", USERID());
                        lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", lrc_BatchTemp."MCS Master Batch No.");
                        lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", '');
                        lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
                        IF lrc_MasterBatchTemp.ISEMPTY() THEN BEGIN
                            lrc_MasterBatchTemp.RESET();
                            lrc_MasterBatchTemp.INIT();
                            lrc_MasterBatchTemp."Entry Type" := lrc_MasterBatchTemp."Entry Type"::MCS;
                            lrc_MasterBatchTemp."USERID Code" := copystr(USERID(), 1, 50);
                            lrc_MasterBatchTemp."Entry No." := 0;
                            lrc_MasterBatchTemp."MCS Batch No." := '';
                            lrc_MasterBatchTemp."MCS Master Batch No." := lrc_BatchTemp."MCS Master Batch No.";
                            lrc_MasterBatchTemp."MCS Voyage No." := '';
                            lrc_MasterBatchTemp."MCS Without Allocation" := FALSE;
                            lrc_MasterBatchTemp."MCS Allocation Key" := lrc_MasterBatchTemp."MCS Allocation Key"::" ";
                            lrc_MasterBatchTemp."MCS System" := lrc_MasterBatchTemp."MCS System";
                            lrc_MasterBatchTemp.INSERT(TRUE);
                        END;
                    END;
                UNTIL lrc_BatchTemp.NEXT() = 0;


            // Summen berechnen für Reisenummer und Partienummer/n
            lrc_BatchTemp.RESET();
            lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
            lrc_BatchTemp.SETRANGE("USERID Code", USERID());
            lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
            IF lrc_BatchTemp.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    IF lrc_BatchTemp."MCS Voyage No." <> '' THEN BEGIN
                        lrc_MasterBatchTemp.RESET();
                        lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                        lrc_MasterBatchTemp.SETRANGE("USERID Code", USERID());
                        lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", '');
                        lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", lrc_BatchTemp."MCS Voyage No.");
                        lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
                        lrc_MasterBatchTemp.FINDFIRST();
                        lrc_MasterBatchTemp."MCS Total Amount" := lrc_MasterBatchTemp."MCS Total Amount" +
                                                                  lrc_BatchTemp."MCS Total Amount";
                        lrc_MasterBatchTemp."MCS Quantity Colli" := lrc_MasterBatchTemp."MCS Quantity Colli" +
                                                                    lrc_BatchTemp."MCS Quantity Colli";
                        lrc_MasterBatchTemp."MCS Quantity Pallets" := lrc_MasterBatchTemp."MCS Quantity Pallets" +
                                                                      lrc_BatchTemp."MCS Quantity Pallets";
                        lrc_MasterBatchTemp."MCS Quantity Packings" := lrc_MasterBatchTemp."MCS Quantity Packings" +
                                                                       lrc_BatchTemp."MCS Quantity Packings";
                        lrc_MasterBatchTemp."MCS Gross Weight" := lrc_MasterBatchTemp."MCS Gross Weight" +
                                                                  lrc_BatchTemp."MCS Gross Weight";
                        lrc_MasterBatchTemp."MCS Net Weight" := lrc_MasterBatchTemp."MCS Net Weight" +
                                                                lrc_BatchTemp."MCS Net Weight";
                        lrc_MasterBatchTemp."MCS No. of Lines" := lrc_MasterBatchTemp."MCS No. of Lines" +
                                                                  lrc_BatchTemp."MCS No. of Lines";
                        lrc_MasterBatchTemp."MCS Posted Qty. (Cost Inv.)" := lrc_MasterBatchTemp."MCS Posted Qty. (Cost Inv.)" +
                                                                             lrc_BatchTemp."MCS Posted Qty. (Cost Inv.)";
                        lrc_MasterBatchTemp."MCS Posted Amount" := lrc_MasterBatchTemp."MCS Posted Amount" +
                                                                   lrc_BatchTemp."MCS Posted Amount";
                        lrc_MasterBatchTemp."MCS Qty. Colly Sold Duty paid" := lrc_MasterBatchTemp."MCS Qty. Colly Sold Duty paid" +
                                                                               lrc_BatchTemp."MCS Qty. Colly Sold Duty paid";
                        lrc_MasterBatchTemp.MODIFY();
                    END;

                    IF lrc_BatchTemp."MCS Master Batch No." <> '' THEN BEGIN
                        lrc_MasterBatchTemp.RESET();
                        lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                        lrc_MasterBatchTemp.SETRANGE("USERID Code", USERID());
                        lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", lrc_BatchTemp."MCS Master Batch No.");
                        lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", '');
                        lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
                        lrc_MasterBatchTemp.FINDFIRST();
                        lrc_MasterBatchTemp."MCS Total Amount" := lrc_MasterBatchTemp."MCS Total Amount" +
                                                                  lrc_BatchTemp."MCS Total Amount";
                        lrc_MasterBatchTemp."MCS Quantity Colli" := lrc_MasterBatchTemp."MCS Quantity Colli" +
                                                                    lrc_BatchTemp."MCS Quantity Colli";
                        lrc_MasterBatchTemp."MCS Quantity Pallets" := lrc_MasterBatchTemp."MCS Quantity Pallets" +
                                                                      lrc_BatchTemp."MCS Quantity Pallets";
                        lrc_MasterBatchTemp."MCS Quantity Packings" := lrc_MasterBatchTemp."MCS Quantity Packings" +
                                                                       lrc_BatchTemp."MCS Quantity Packings";
                        lrc_MasterBatchTemp."MCS Gross Weight" := lrc_MasterBatchTemp."MCS Gross Weight" +
                                                                  lrc_BatchTemp."MCS Gross Weight";
                        lrc_MasterBatchTemp."MCS Net Weight" := lrc_MasterBatchTemp."MCS Net Weight" +
                                                                lrc_BatchTemp."MCS Net Weight";
                        lrc_MasterBatchTemp."MCS No. of Lines" := lrc_MasterBatchTemp."MCS No. of Lines" +
                                                                  lrc_BatchTemp."MCS No. of Lines";
                        lrc_MasterBatchTemp."MCS Posted Qty. (Cost Inv.)" := lrc_MasterBatchTemp."MCS Posted Qty. (Cost Inv.)" +
                                                                             lrc_BatchTemp."MCS Posted Qty. (Cost Inv.)";
                        lrc_MasterBatchTemp."MCS Posted Amount" := lrc_MasterBatchTemp."MCS Posted Amount" +
                                                                   lrc_BatchTemp."MCS Posted Amount";
                        lrc_MasterBatchTemp.MODIFY();
                    END;
                UNTIL lrc_BatchTemp.NEXT() = 0;
        END ELSE BEGIN
            lin_BatchItemLines := 0;
            IF lrc_PurchHeader.GET(lrc_PurchHeader."Document Type"::Order, vco_PurchOrderNo) THEN BEGIN
                lrc_PurchLine.RESET();
                lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
                lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                lrc_PurchLine.SETFILTER("No.", '<>%1', '');
                IF lrc_PurchLine.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        IF lrc_PurchLine."POI Batch Item" = TRUE THEN
                            lin_BatchItemLines := lin_BatchItemLines + 1;
                    UNTIL lrc_PurchLine.NEXT() = 0;
                IF lin_BatchItemLines > 0 THEN
                    // Es sind keine Positionen zur Partie %1 vorhanden!
                    ERROR(AGILES_LT_TEXT001Txt, vco_MasterBatchNo);
            END;
        END;
    end;

    procedure SetBatchItemInItem(vrc_ProductGroup: Record "POI Product Group")
    begin
        // -------------------------------------------------------------------------------------------
        // Kennzeichen Partiegeführter Artikel im Artikelstamm für alle Artikel der Produktgruppe setzen
        // -------------------------------------------------------------------------------------------

        lrc_Item.SETRANGE("POI Product Group Code", vrc_ProductGroup.Code);
        IF lrc_Item.FINDSET(TRUE, FALSE) THEN
            REPEAT
                lrc_Item."POI Batch Item" := vrc_ProductGroup."Def. Batch Item";
                lrc_Item.MODIFY();
            UNTIL lrc_Item.NEXT() = 0;
    end;

    procedure PurchCheckStockBatchVar(vrc_PurchaseLine: Record "Purchase Line"): Boolean
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lfm_StockCheckBatchVariantNo: Page "POI Stock Check Batch Var. No.";
        ldc_Differenz: Decimal;
        "ldc_ErwVerfügbarerBestand": Decimal;
        ldc_TempValue: array[10] of Decimal;
    begin
        // ---------------------------------------------------------------------------------------------
        // Verfügbaren Bestand prüfen bei Buchung aus Einkaufszeile
        // ---------------------------------------------------------------------------------------------

        IF (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR
           (vrc_PurchaseLine."No." = '') OR
           (vrc_PurchaseLine."Line No." = 0) OR
           (vrc_PurchaseLine."POI Batch Variant No." = '') THEN
            EXIT(TRUE);

        lrc_BatchSetup.GET();
        IF lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Automatic from System" THEN
            EXIT(TRUE);

        CASE vrc_PurchaseLine."Document Type" OF
            vrc_PurchaseLine."Document Type"::Order:
                BEGIN

                    // Eink-Zeile mit alter Menge lesen
                    lrc_PurchaseLine.GET(vrc_PurchaseLine."Document Type", vrc_PurchaseLine."Document No.", vrc_PurchaseLine."Line No.");

                    // Differenz zwischen alter und neuer Menge berechnen
                    ldc_Differenz := (vrc_PurchaseLine.Quantity - lrc_PurchaseLine.Quantity) * vrc_PurchaseLine."Qty. per Unit of Measure";
                    IF ldc_Differenz > 0 THEN
                        EXIT(TRUE);

                    // Bestände kalkulieren
                    CalcStockBatchVar(vrc_PurchaseLine."POI Batch Variant No.",
                                      vrc_PurchaseLine."Location Code",
                                      0.1,
                                      ldc_TempValue[1],
                                      ldc_TempValue[2],
                                      ldc_ErwVerfügbarerBestand,
                                      ldc_TempValue[3],
                                      ldc_TempValue[4],
                                      ldc_TempValue[5],
                                      ldc_TempValue[6],
                                      ldc_TempValue[7],
                                      ldc_TempValue[8],
                                      ldc_TempValue[9],
                                      1);

                    ldc_ErwVerfügbarerBestand := ldc_ErwVerfügbarerBestand + ldc_Differenz;

                    IF ldc_ErwVerfügbarerBestand < 0 THEN BEGIN
                        lrc_BatchVariant.GET(vrc_PurchaseLine."POI Batch Variant No.");
                        lfm_StockCheckBatchVariantNo.SSP_GlobaleSetzen(lrc_BatchVariant."Item No.", lrc_BatchVariant."No.",
                                                                       vrc_PurchaseLine."Location Code", ldc_Differenz);
                        lfm_StockCheckBatchVariantNo.RUNMODAL();
                        EXIT(FALSE);
                    END ELSE
                        EXIT(TRUE);

                END;
        END;

        EXIT(TRUE);
    end;

    procedure CalcStockBatchVar(vco_BatchVariantNo: Code[20]; vco_LocationFilter: Code[1024]; vdc_Rounding: Decimal; var rdc_Bestand: Decimal; var rdc_BestandVerf: Decimal; var rdc_ErwBestandVerf: Decimal; var rdc_MgeInAuftrag: Decimal; var rdc_MgeInBestellung: Decimal; var rdc_MgeReserviertFV: Decimal; var rdc_MgeVerzollungsauftrag: Decimal; var rdc_MgeInVkRechnung: Decimal; var rdc_MgeInVkLieferung: Decimal; var rdc_MgeInEkLieferung: Decimal; vdc_ShowInQtyperUnitofMeasure: Decimal)
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
    begin
        // -----------------------------------------------------------------------------------------
        // Funktion zur Berechnung der Bestände für eine Positionsvariante
        // -----------------------------------------------------------------------------------------
        // Parameter:  vco_BatchVariantNo
        //             vco_LocationFilter
        //             vdc_Rounding
        //             rdc_Bestand
        //             rdc_BestandVerf
        //             rdc_ErwBestandVerf
        //             rdc_MgeInAuftrag
        //             rdc_MgeInBestellung
        //             rdc_MgeReserviertFV
        //             rdc_MgeVerzollungsauftrag
        //             rdc_MgeInRechnung
        //             rdc_MgeInVkLieferung
        //             rdc_MgeInEkLieferung
        //             vdc_ShowInQtyperUnitofMeasure
        // -----------------------------------------------------------------------------------------

        lrc_BatchSetup.GET();

        rdc_Bestand := 0;
        rdc_BestandVerf := 0;
        rdc_ErwBestandVerf := 0;
        rdc_MgeInAuftrag := 0;
        rdc_MgeInBestellung := 0;
        rdc_MgeReserviertFV := 0;

        IF lrc_BatchVariant.GET(vco_BatchVariantNo) THEN BEGIN

            IF vco_LocationFilter <> '' THEN
                lrc_BatchVariant.SETFILTER("Location Filter", vco_LocationFilter);

            lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)",
                                        "B.V. Purch. Order (Qty)", "B.V. Purch. Rec. (Qty)",
                                        "B.V. Sales Order (Qty)", "B.V. Sales Shipped (Qty)",
                                        "B.V. FV Reservation (Qty)",
                                        "B.V. Transfer Rec. (Qty)", "B.V. Transfer Ship (Qty)",
                                        "B.V. Pack. Input (Qty)", "B.V. Pack. Pack.-Input (Qty)",
                                        "B.V. Pack. Output (Qty)");
            lrc_BatchVariant.CALCFIELDS("B.V. Customer Clearance (Qty.)", "B.V. Sales Cr. Memo (Qty)",
                                        "B.V. Purch. Cr. Memo (Qty)", "B.V. Sales Inv. (Qty.)",
                                        "B.V. Transfer in Transit (Qty)");

            rdc_Bestand := lrc_BatchVariant."B.V. Inventory (Qty.)";

            rdc_BestandVerf := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                               lrc_BatchVariant."B.V. Sales Order (Qty)" -
                               lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                               lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                               lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)" -
                               lrc_BatchVariant."B.V. Transfer Ship (Qty)";

            rdc_ErwBestandVerf := lrc_BatchVariant."B.V. Inventory (Qty.)" - lrc_BatchVariant."B.V. Sales Order (Qty)" -
                                  lrc_BatchVariant."B.V. FV Reservation (Qty)" - lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                                  lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)" - lrc_BatchVariant."B.V. Transfer Ship (Qty)" +
                                  lrc_BatchVariant."B.V. Purch. Order (Qty)" + lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                                  lrc_BatchVariant."B.V. Pack. Output (Qty)" + lrc_BatchVariant."B.V. Transfer in Transit (Qty)";

            rdc_MgeInAuftrag := lrc_BatchVariant."B.V. Sales Order (Qty)";
            rdc_MgeInBestellung := lrc_BatchVariant."B.V. Purch. Order (Qty)";
            rdc_MgeReserviertFV := lrc_BatchVariant."B.V. FV Reservation (Qty)";
            rdc_MgeVerzollungsauftrag := lrc_BatchVariant."B.V. Customer Clearance (Qty.)";
            // offen  vdc_MgeInRechnung := ROUND((lrc_BatchVariant."Sales (Qty.)" / vdc_ShowInQtyperUnitofMeasure),
            rdc_MgeInVkLieferung := lrc_BatchVariant."B.V. Sales Shipped (Qty)";
            rdc_MgeInVkRechnung := lrc_BatchVariant."B.V. Sales Inv. (Qty.)";
            rdc_MgeInEkLieferung := lrc_BatchVariant."B.V. Purch. Rec. (Qty)";

            IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
                rdc_BestandVerf := rdc_BestandVerf + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";


            IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
                rdc_ErwBestandVerf := rdc_ErwBestandVerf + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";


            IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
                rdc_BestandVerf := rdc_BestandVerf - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";


            IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
                rdc_ErwBestandVerf := rdc_ErwBestandVerf - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

            IF vdc_ShowInQtyperUnitofMeasure <> 1 THEN
                IF vdc_ShowInQtyperUnitofMeasure <> 0 THEN BEGIN
                    rdc_Bestand := ROUND((rdc_Bestand / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    rdc_BestandVerf := ROUND((rdc_BestandVerf / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    rdc_ErwBestandVerf := ROUND((rdc_ErwBestandVerf / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    rdc_MgeInAuftrag := ROUND((lrc_BatchVariant."B.V. Sales Order (Qty)" / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    rdc_MgeInBestellung := ROUND((lrc_BatchVariant."B.V. Purch. Order (Qty)" / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    rdc_MgeReserviertFV := ROUND((lrc_BatchVariant."B.V. FV Reservation (Qty)" / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    rdc_MgeVerzollungsauftrag := ROUND((lrc_BatchVariant."B.V. Customer Clearance (Qty.)" / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    // offen  vdc_MgeInRechnung         := ROUND((lrc_BatchVariant."Sales (Qty.)" / vdc_ShowInQtyperUnitofMeasure),
                    // offen                                     vdc_Rounding);
                    rdc_MgeInVkLieferung := ROUND((lrc_BatchVariant."B.V. Sales Shipped (Qty)" / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    rdc_MgeInVkRechnung := ROUND((lrc_BatchVariant."B.V. Sales Inv. (Qty.)" / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                    rdc_MgeInEkLieferung := ROUND((lrc_BatchVariant."B.V. Purch. Rec. (Qty)" / vdc_ShowInQtyperUnitofMeasure),
                                                       vdc_Rounding);
                END ELSE BEGIN
                    rdc_Bestand := 0;
                    rdc_BestandVerf := 0;
                    rdc_ErwBestandVerf := 0;
                    rdc_MgeInAuftrag := 0;
                    rdc_MgeInBestellung := 0;
                    rdc_MgeReserviertFV := 0;
                    rdc_MgeVerzollungsauftrag := 0;
                    rdc_MgeInVkRechnung := 0;
                    rdc_MgeInVkLieferung := 0;
                    rdc_MgeInEkLieferung := 0;
                END;
        END;
    end;


    //     procedure ItemJournalLineNewMasterBatch(rrc_ItemJournalLine: Record "83";rco_MasterBatchCode: Code[20];var rco_MasterBatchCodeReturn: Code[20])
    //     var
    //         NoSeriesManagement: Codeunit "396";
    //         BatchSetup: Record "5110363";
    //         MasterBatch: Record "5110364";
    //         TEXT000: Label 'Vergabe Partienr. fehlgeschlagen!';
    //         lco_MasterBatchCode: Code[20];
    //         TEXT001: Label 'Vergabe Positionsnr. fehlgeschlagen!';
    //         lrc_DimensionValue: Record "349";
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Anlage einer neuen Partie über Artikelbuchblattzeile
    //         // ------------------------------------------------------------------------------------------

    //         // Einrichtung lesen
    //         BatchSetup.GET();

    //         // Kontrolle ob Partiewesen aktiv ist
    //         IF BatchSetup."Batchsystem activ" = FALSE THEN BEGIN
    //           rco_MasterBatchCodeReturn := '';
    //           EXIT;
    //         END;


    //         CASE BatchSetup."IJnlLi Allocation Master Batch" OF
    //           BatchSetup."IJnlLi Allocation Master Batch"::"One Master Batch No per Journal Batch Name":
    //             BEGIN
    //               // Kontrolle ob Partie Code bereits vorhanden
    //               IF rco_MasterBatchCode <> '' THEN BEGIN
    //                 rco_MasterBatchCodeReturn := rco_MasterBatchCode;
    //                 EXIT;
    //               END;
    //             END;
    //           BatchSetup."IJnlLi Allocation Master Batch"::"New Master Batch No. per Line":
    //             BEGIN
    //             END;
    //         END;

    //         // --------------------------------------------------------------------------
    //         // Vergabe über Setup Einrichtung
    //         // --------------------------------------------------------------------------
    //         BEGIN
    //           BatchSetup.TESTFIELD("IJnlLi Master Batch No. Series");
    //           lco_MasterBatchCode := NoSeriesManagement.GetNextNo(BatchSetup."IJnlLi Master Batch No. Series",WORKDATE,TRUE);
    //         END;

    //         IF lco_MasterBatchCode = '' THEN
    //           // Vergabe Partienr. fehlgeschlagen!
    //           ERROR(TEXT000);

    //         // ---------------------------------------------------------------------------
    //         // Datensatz Master Batch anlegen
    //         // ---------------------------------------------------------------------------
    //         MasterBatch.RESET();
    //         MasterBatch.INIT();
    //         MasterBatch."No." := lco_MasterBatchCode;
    //         IF rrc_ItemJournalLine."Phys. Inventory" = TRUE THEN BEGIN
    //           MasterBatch.Source := MasterBatch.Source::Assortment;
    //         END ELSE BEGIN
    //           MasterBatch.Source := MasterBatch.Source::"Inventory Journal Line";
    //         END;

    //         MasterBatch.insert();

    //         //RS Anlage Partie als Dimension
    //         lrc_DimensionValue.SETRANGE("Dimension Code", 'PARTIE');
    //         lrc_DimensionValue.SETRANGE(Code, lco_MasterBatchCode);
    //         IF NOT lrc_DimensionValue.FINDSET(FALSE, FALSE) THEN BEGIN
    //           lrc_DimensionValue.INIT();
    //           lrc_DimensionValue."Dimension Code" := 'PARTIE';
    //           lrc_DimensionValue.Code := lco_MasterBatchCode;
    //           lrc_DimensionValue.Name := lco_MasterBatchCode;
    //           lrc_DimensionValue.insert();
    //         END;

    //         // Rückgabewerte setzen
    //         rco_MasterBatchCodeReturn := MasterBatch."No.";
    //     end;

    //     procedure ItemJournalLinekUpdMasterBatch(rco_MasterBatchCode: Code[20];rrc_ItemJournalLine: Record "83")
    //     var
    //         BatchSetup: Record "5110363";
    //         MasterBatch: Record "5110364";
    //     begin
    //         // ----------------------------------------------------------------------
    //         // Aktualisierung einer vorhandenen Partie über Artikelbuchblattzeile
    //         // ----------------------------------------------------------------------

    //         IF rrc_ItemJournalLine."Master Batch No." = '' THEN
    //           EXIT;

    //         // Partie lesen und aktualisieren
    //         MasterBatch.GET(rco_MasterBatchCode);

    //         MasterBatch.MODIFY();
    //     end;

    //     procedure ItemJournalLineNewBatch(rrc_ItemJournalLine: Record "83";rco_BatchNo: Code[20];var rco_BatchNoReturn: Code[20])
    //     var
    //         NoSeriesManagement: Codeunit "396";
    //         lrc_MasterBatch: Record "5110364";
    //         BatchSetup: Record "5110363";
    //         Batch: Record "5110365";
    //         DimensionValue: Record "349";
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Anlage einer neuen Position aus der Artikelbuchblattzeile
    //         // ----------------------------------------------------------------------------------------

    //         IF rco_BatchNoReturn <> '' THEN
    //           EXIT;

    //         BatchSetup.GET();
    //         IF BatchSetup."Batchsystem activ" = FALSE THEN
    //           EXIT;

    //         IF BatchSetup."IJnlLi Allocation Batch No." =
    //            BatchSetup."IJnlLi Allocation Batch No."::"One Batch No per Journal Batch Name" THEN BEGIN
    //           IF rco_BatchNo = '' THEN BEGIN
    //               CASE BatchSetup."IJnlLi Source Batch No." OF
    //                 BatchSetup."IJnlLi Source Batch No."::"No. Series":
    //                    BEGIN
    //                       BatchSetup.TESTFIELD("IJnlLi Batch No. Series");
    //                       rco_BatchNoReturn := NoSeriesManagement.GetNextNo(BatchSetup."IJnlLi Batch No. Series",WORKDATE,TRUE);
    //                    END;
    //                 BatchSetup."IJnlLi Source Batch No."::"Master Batch No.":
    //                    BEGIN
    //                       rrc_ItemJournalLine.TESTFIELD("Master Batch No.");
    //                       rco_BatchNoReturn := rrc_ItemJournalLine."Master Batch No.";
    //                    END;

    //                 BatchSetup."IJnlLi Source Batch No."::"Master Batch No. + Postfix":
    //                     BEGIN

    //                       rrc_ItemJournalLine.TESTFIELD("Master Batch No.");

    //                       // Postfixzähler ermitteln
    //                       lrc_MasterBatch.GET( rrc_ItemJournalLine."Master Batch No.");
    //                       lrc_MasterBatch."Batch Postfix Counter" := lrc_MasterBatch."Batch Postfix Counter" + 1;
    //                       lrc_MasterBatch.MODIFY();

    //                       rco_BatchNoReturn := lrc_MasterBatch."No." +
    //                                            BatchSetup."Batch Separator" +
    //                                            lcu_GlobalFunctions.FormatIntegerWithBeginningZero(
    //                                            lrc_MasterBatch."Batch Postfix Counter",
    //                                            BatchSetup."Batch Postfix Places");

    //                     END;
    //                 END;

    //           END ELSE BEGIN
    //             rco_BatchNoReturn := rco_BatchNo;
    //             EXIT;
    //           END;
    //         END ELSE BEGIN
    //            CASE BatchSetup."IJnlLi Source Batch No." OF
    //              BatchSetup."IJnlLi Source Batch No."::"No. Series":
    //                 BEGIN
    //                    BatchSetup.TESTFIELD("IJnlLi Batch No. Series");
    //                    rco_BatchNoReturn := NoSeriesManagement.GetNextNo(BatchSetup."IJnlLi Batch No. Series",WORKDATE,TRUE);
    //                 END;
    //              BatchSetup."IJnlLi Source Batch No."::"Master Batch No.":
    //                 BEGIN
    //                    rrc_ItemJournalLine.TESTFIELD("Master Batch No.");
    //                    rco_BatchNoReturn := rrc_ItemJournalLine."Master Batch No.";
    //                 END;

    //              BatchSetup."IJnlLi Source Batch No."::"Master Batch No. + Postfix":
    //                 BEGIN
    //                    rrc_ItemJournalLine.TESTFIELD("Master Batch No.");

    //                    // Postfixzähler ermitteln
    //                    lrc_MasterBatch.GET( rrc_ItemJournalLine."Master Batch No.");
    //                    lrc_MasterBatch."Batch Postfix Counter" := lrc_MasterBatch."Batch Postfix Counter" + 1;
    //                    lrc_MasterBatch.MODIFY();

    //                    rco_BatchNoReturn := lrc_MasterBatch."No." +
    //                                         BatchSetup."Batch Separator" +
    //                                         lcu_GlobalFunctions.FormatIntegerWithBeginningZero(
    //                                         lrc_MasterBatch."Batch Postfix Counter",
    //                                         BatchSetup."Batch Postfix Places");

    //                  END;
    //              END;
    //         END;

    //         IF rco_BatchNoReturn = '' THEN
    //           ERROR('Positionsnr. konnte nicht ermittelt werden!');

    //         // Positionsdatensatz anlegen
    //         Batch.RESET();
    //         Batch.INIT();
    //         Batch."No." := rco_BatchNoReturn;
    //         Batch."Master Batch No." := rrc_ItemJournalLine."Master Batch No.";
    //         IF rrc_ItemJournalLine."Phys. Inventory" = TRUE THEN BEGIN
    //           Batch.Source := Batch.Source::Assortment;
    //         END ELSE BEGIN
    //           Batch.Source := Batch.Source::"Inventory Journal Line";
    //         END;
    //         Batch."Kind of Settlement" := 0;

    //         // FV4 014 00000000.s
    //         Batch."Shortcut Dimension 1 Code" := rrc_ItemJournalLine."Shortcut Dimension 1 Code";
    //         Batch."Shortcut Dimension 2 Code" := rrc_ItemJournalLine."Shortcut Dimension 2 Code";
    //         Batch."Shortcut Dimension 3 Code" := rrc_ItemJournalLine."Shortcut Dimension 3 Code";
    //         Batch."Shortcut Dimension 4 Code" := rrc_ItemJournalLine."Shortcut Dimension 4 Code";
    //         // FV4 014 00000000.e

    //         Batch.insert();

    //         // Kontrolle auf Dimensionsanlage und Anlage der Partie als Dimension
    //         IF BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
    //           DimensionValue.RESET();
    //           DimensionValue.INIT();
    //           DimensionValue."Dimension Code" := BatchSetup."Dim. Code Batch No.";
    //           DimensionValue.Code := Batch."No.";
    //           DimensionValue.Name := 'Position';
    //           DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
    //           DimensionValue."Global Dimension No." := BatchSetup."Dim. No. Batch No.";
    //           DimensionValue.insert();
    //           //RS Anlage Partie als Dimension
    //           IF NOT DimensionValue.GET('PARTIE', Batch."Master Batch No.") THEN BEGIN
    //             DimensionValue.RESET();
    //             DimensionValue.INIT();
    //             DimensionValue."Dimension Code" := 'PARTIE';
    //             DimensionValue.Code := Batch."Master Batch No.";
    //             DimensionValue.Name := Batch."Master Batch No.";
    //             DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
    //             DimensionValue.insert();
    //           END;
    //         END;

    //         // Rückgabewert setzen
    //         rco_BatchNoReturn := Batch."No.";
    //     end;

    //     procedure ItemJournalLineNewBatchVar(rrc_ItemJournalLine: Record "83";var rco_BatchCode: Code[20];var rco_BatchVariantCode: Code[20])
    //     var
    //         BatchManagement: Codeunit "5110307";
    //         GlobalFunctions: Codeunit "5110300";
    //         lcu_BaseDataTemplateMgt: Codeunit "5087929";
    //         NoSeriesManagement: Codeunit "396";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_ItemUnitOfMeasure: Record "5404";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_PriceCalculation: Record "5110320";
    //         lco_BatchCode: Code[20];
    //         BatchVariantCode: Code[20];
    //         TEXT001: Label 'Positionsnummer konnte nicht ermittelt werden!';
    //         TEXT003: Label 'Positionsvariantennr. konnte nicht generiert werden!';
    //         lin_MaxWert: Integer;
    //         lco_AktBatchCode: Code[20];
    //         lbn_ChangeBack: Boolean;
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // ----------------------------------------------------------------------
    //         // Anlage einer neuen Positionsvariante aus Artikelbuchblattzeile
    //         // ----------------------------------------------------------------------

    //         // Kontrolle ob Artikel und Artikelnummer oder Batchvariante
    //         IF (rrc_ItemJournalLine."Item No." = '') OR
    //            (rrc_ItemJournalLine."Batch Variant No." <> '') THEN
    //           EXIT;

    //         // Artikel lesen und Kontrolle ob Artikel Batchgeführt ist
    //         lrc_Item.GET(rrc_ItemJournalLine."Item No.");
    //         IF lrc_Item."Batch Item" = FALSE THEN
    //           EXIT;

    //         lrc_BatchSetup.GET();

    //         // Kontrolle ob Partienummer vergeben wurde
    //         rrc_ItemJournalLine.TESTFIELD("Master Batch No.");
    //         rrc_ItemJournalLine.TESTFIELD("Batch No.");

    //         lco_BatchCode := rrc_ItemJournalLine."Batch No.";

    //         CASE
    //            lrc_BatchSetup."IJnlLi Source Batch Variant" OF
    //            lrc_BatchSetup."IJnlLi Source Batch Variant"::"No. Series":
    //              BEGIN
    //                lrc_BatchSetup.TESTFIELD("IJnlLi Batch Variant No Series");
    //                BatchVariantCode:= NoSeriesManagement.GetNextNo(lrc_BatchSetup."IJnlLi Batch Variant No Series",WORKDATE,TRUE);
    //              END;
    //            lrc_BatchSetup."IJnlLi Source Batch Variant"::"Batch No.":
    //              BEGIN
    //                BatchVariantCode := rrc_ItemJournalLine."Batch No.";
    //              END;
    //            lrc_BatchSetup."IJnlLi Source Batch Variant"::"Batch No. + Postfix":
    //              BEGIN
    //                // Postfixzähler ermitteln
    //                lrc_Batch.GET(lco_BatchCode);

    //                CASE
    //                  lrc_BatchSetup."Batch Variant Postfix Places" OF
    //                    1: lin_MaxWert := 8;
    //                    2: lin_MaxWert := 98;
    //                    3: lin_MaxWert := 998;
    //                    4: lin_MaxWert := 9998;
    //                    5: lin_MaxWert := 99998;
    //                END;

    //                IF lrc_Batch."Batch Variant Postfix Counter" <= lin_MaxWert THEN BEGIN
    //                   lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
    //                   lrc_Batch.MODIFY();
    //                END ELSE BEGIN
    //                   // neue Positionsnr vergeben
    //                   lco_AktBatchCode := '';
    //                   lbn_ChangeBack := FALSE;

    //                   IF lrc_BatchSetup."IJnlLi Allocation Batch No." =
    //                      lrc_BatchSetup."IJnlLi Allocation Batch No."::"One Batch No per Journal Batch Name" THEN BEGIN
    //                      lrc_BatchSetup."IJnlLi Allocation Batch No." :=
    //                         lrc_BatchSetup."IJnlLi Allocation Batch No."::"New Batch No. per Line";
    //                      lbn_ChangeBack := TRUE;
    //                      lrc_BatchSetup.MODIFY();
    //                   END;

    //                   ItemJournalLineNewBatch(  rrc_ItemJournalLine, lco_BatchCode, lco_AktBatchCode);
    //                   lco_BatchCode := lco_AktBatchCode;

    //                   IF lbn_ChangeBack = TRUE THEN BEGIN
    //                      lrc_BatchSetup."IJnlLi Allocation Batch No." :=
    //                         lrc_BatchSetup."IJnlLi Allocation Batch No."::"One Batch No per Journal Batch Name";
    //                      lrc_BatchSetup.MODIFY();
    //                   END;
    //                   lrc_Batch.GET(lco_BatchCode);
    //                   lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
    //                   lrc_Batch.MODIFY();
    //                 END;

    //                 BatchVariantCode := lco_BatchCode + lrc_BatchSetup."Batch Variant Separator" +
    //                                     GlobalFunctions.FormatIntegerWithBeginningZero(
    //                                                 lrc_Batch."Batch Variant Postfix Counter",
    //                                                 lrc_BatchSetup."Batch Variant Postfix Places");
    //              END;
    //         END;

    //         IF BatchVariantCode = '' THEN
    //           // Positionsvariantennr. konnte nicht generiert werden!
    //           ERROR(TEXT003);

    //         SetBatchStatusOpen(lco_BatchCode);

    //         // --------------------------------------------------------------------
    //         // Positionsvariante anlegen
    //         // --------------------------------------------------------------------
    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.INIT();
    //         lrc_BatchVariant."No." := BatchVariantCode;
    //         lrc_BatchVariant."Master Batch No." := rrc_ItemJournalLine."Master Batch No.";
    //         lrc_BatchVariant."Batch No." := lco_BatchCode;
    //         lrc_BatchVariant."Item No." := rrc_ItemJournalLine."Item No.";
    //         lrc_BatchVariant."Variant Code" := rrc_ItemJournalLine."Variant Code";

    //         lrc_BatchVariant.Description := lrc_Item.Description;
    //         lrc_BatchVariant."Description 2" := lrc_Item."Description 2";

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Create Search No from BatchVar" = TRUE THEN BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item,lrc_BatchVariant);
    //         END ELSE BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);
    //         END;

    //         IF (lrc_BatchVariant.Description = '') AND
    //            (lrc_BatchVariant."Description 2" = '') THEN BEGIN
    //           lrc_BatchVariant.Description := rrc_ItemJournalLine.Description;
    //         END;

    //         lrc_BatchVariant."Item Main Category Code" := lrc_Item."Item Main Category Code";
    //         lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
    //         lrc_BatchVariant."Product Group Code" := lrc_Item."Product Group Code";
    //         lrc_BatchVariant."Base Unit of Measure (BU)" := rrc_ItemJournalLine."Base Unit of Measure (BU)";
    //         lrc_BatchVariant."Unit of Measure Code" := rrc_ItemJournalLine."Unit of Measure Code";
    //         lrc_BatchVariant."Qty. per Unit of Measure" := rrc_ItemJournalLine."Qty. per Unit of Measure";

    //         lrc_ItemUnitOfMeasure.RESET();
    //         IF lrc_ItemUnitOfMeasure.GET(rrc_ItemJournalLine."Item No.",rrc_ItemJournalLine."Unit of Measure Code") THEN BEGIN
    //           CASE lrc_ItemUnitOfMeasure."Kind of Unit of Measure" OF
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Base Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Base Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;
    //                END;
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Content Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Content Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;
    //                END;
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Packing Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;

    //                END;
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Collo Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;
    //                END;
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Transport Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;
    //                END;
    //              ELSE
    //                lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //           END;
    //         END ELSE BEGIN
    //           lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //         END;
    //         lrc_BatchVariant."Purch. Price (Price Base)" := rrc_ItemJournalLine."Unit Amount";

    //         lrc_BatchVariant."Market Unit Cost (Base) (LCY)" := rrc_ItemJournalLine."Market Unit Cost (Basis) (LCY)";

    //         lrc_BatchVariant."Vendor No." := '';
    //         lrc_BatchVariant."Vendor Search Name" := '';
    //         lrc_BatchVariant."Producer No." := '';

    //         lrc_BatchVariant."Country of Origin Code" := rrc_ItemJournalLine."Country of Origin Code";
    //         lrc_BatchVariant."Variety Code" := rrc_ItemJournalLine."Variety Code";
    //         lrc_BatchVariant."Trademark Code" := rrc_ItemJournalLine."Trademark Code";
    //         lrc_BatchVariant."Caliber Code" := rrc_ItemJournalLine."Caliber Code";
    //         lrc_BatchVariant."Vendor Caliber Code" := rrc_ItemJournalLine."Vendor Caliber Code";
    //         lrc_BatchVariant."Item Attribute 3" := rrc_ItemJournalLine."Item Attribute 3";
    //         lrc_BatchVariant."Item Attribute 2" := rrc_ItemJournalLine."Item Attribute 2";
    //         lrc_BatchVariant."Grade of Goods Code" := rrc_ItemJournalLine."Grade of Goods Code";
    //         lrc_BatchVariant."Item Attribute 7" := rrc_ItemJournalLine."Item Attribute 7";
    //         lrc_BatchVariant."Item Attribute 4" := rrc_ItemJournalLine."Item Attribute 4";
    //         lrc_BatchVariant."Coding Code" := rrc_ItemJournalLine."Coding Code";
    //         lrc_BatchVariant."Item Attribute 5" := rrc_ItemJournalLine."Item Attribute 5";

    //         lrc_BatchVariant."Departure Date" := rrc_ItemJournalLine."Posting Date";
    //         lrc_BatchVariant."Order Date" := rrc_ItemJournalLine."Posting Date";
    //         lrc_BatchVariant."Date of Delivery" := rrc_ItemJournalLine."Posting Date";

    //         lrc_BatchVariant."Kind of Settlement" := 0;
    //         lrc_BatchVariant.Weight := 0;
    //         lrc_BatchVariant."Producer No." := rrc_ItemJournalLine."Producer No.";
    //         IF rrc_ItemJournalLine."Lot No. Producer" <> '' THEN BEGIN
    //            lrc_BatchVariant."Lot No. Producer" := rrc_ItemJournalLine."Lot No. Producer";
    //         END;
    //         lrc_BatchVariant."Entry Location Code" := rrc_ItemJournalLine."Location Code";

    //         lrc_BatchVariant."Date of Expiry" := rrc_ItemJournalLine."Date of Expiry";

    //         lrc_BatchVariant."Kind of Loading" := 0;
    //         lrc_BatchVariant."Voyage No." := '';
    //         lrc_BatchVariant."Container No." := '';
    //         lrc_BatchVariant."Means of Transport Type" := 0;
    //         lrc_BatchVariant."Means of Transp. Code (Depart)" := '';
    //         lrc_BatchVariant."Means of Transp. Code (Arriva)" := '';
    //         lrc_BatchVariant."Means of Transport Info" := '';

    //         IF rrc_ItemJournalLine."Phys. Inventory" = TRUE THEN BEGIN
    //            lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Inventory Journal Line";
    //         END ELSE BEGIN
    //            lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Item Journal Line";
    //         END;

    //         lrc_BatchVariant."Guaranteed Shelf Life" := lrc_Item."Guaranteed Shelf Life Purch.";

    //         lrc_BatchVariant."Shortcut Dimension 1 Code" := rrc_ItemJournalLine."Shortcut Dimension 1 Code";
    //         lrc_BatchVariant."Shortcut Dimension 2 Code" := rrc_ItemJournalLine."Shortcut Dimension 2 Code";
    //         lrc_BatchVariant."Shortcut Dimension 3 Code" := rrc_ItemJournalLine."Shortcut Dimension 3 Code";
    //         lrc_BatchVariant."Shortcut Dimension 4 Code" := rrc_ItemJournalLine."Shortcut Dimension 4 Code";

    //         lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
    //         lrc_BatchVariant.insert();

    //         // Rückgabewerte setzen
    //         rco_BatchCode := lco_BatchCode;
    //         rco_BatchVariantCode := BatchVariantCode;
    //     end;

    //     procedure ItemJournalLineUpdBatchVar(rrc_ItemJournalLine: Record "83")
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_Vendor: Record "Vendor";
    //         lcu_BaseDataTemplateMgt: Codeunit "5087929";
    //         lrc_ItemUnitOfMeasure: Record "5404";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_PriceCalculation: Record "5110320";
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Aktualisierung einer vorhandenen Positionsvariante über Artikelbuchblattzeile
    //         // --------------------------------------------------------------------------------

    //         // Wenn keine Positionsvaraintennr. vorhanden
    //         IF rrc_ItemJournalLine."Batch Variant No." = '' THEN
    //           EXIT;
    //         IF rrc_ItemJournalLine."Item No." = '' THEN
    //           EXIT;

    //         // Wenn Positionsvariante vorhanden
    //         IF lrc_BatchVariant.GET(rrc_ItemJournalLine."Batch Variant No.") THEN BEGIN
    //           // Artikelstammsatz lesen
    //           lrc_Item.GET(rrc_ItemJournalLine."Item No.");

    //           lrc_BatchVariant.Description := lrc_Item.Description;
    //           lrc_BatchVariant."Description 2" := lrc_Item."Description 2";

    //           lrc_FruitVisionSetup.GET();
    //           IF lrc_FruitVisionSetup."Create Search No from BatchVar" = TRUE THEN BEGIN
    //             lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item,lrc_BatchVariant);
    //           END ELSE BEGIN
    //             lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);
    //           END;

    //           IF (lrc_BatchVariant.Description = '') AND
    //              (lrc_BatchVariant."Description 2" = '') THEN BEGIN
    //             lrc_BatchVariant.Description := rrc_ItemJournalLine.Description;
    //           END;

    //           lrc_BatchVariant."Item No." := rrc_ItemJournalLine."Item No.";
    //           lrc_BatchVariant."Variant Code" := rrc_ItemJournalLine."Variant Code";

    //           lrc_BatchVariant."Item Main Category Code" := lrc_Item."Item Main Category Code";
    //           lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
    //           lrc_BatchVariant."Product Group Code" := lrc_Item."Product Group Code";

    //           lrc_BatchVariant."Producer No." := '';
    //           lrc_BatchVariant."Country of Origin Code" := rrc_ItemJournalLine."Country of Origin Code";
    //           lrc_BatchVariant."Variety Code" := rrc_ItemJournalLine."Variety Code";
    //           lrc_BatchVariant."Trademark Code" := rrc_ItemJournalLine."Trademark Code";
    //           lrc_BatchVariant."Caliber Code" := rrc_ItemJournalLine."Caliber Code";
    //           lrc_BatchVariant."Vendor Caliber Code" := rrc_ItemJournalLine."Vendor Caliber Code";
    //           lrc_BatchVariant."Item Attribute 3" := rrc_ItemJournalLine."Item Attribute 3";
    //           lrc_BatchVariant."Item Attribute 2" := rrc_ItemJournalLine."Item Attribute 2";
    //           lrc_BatchVariant."Grade of Goods Code" := rrc_ItemJournalLine."Grade of Goods Code";
    //           lrc_BatchVariant."Item Attribute 7" := rrc_ItemJournalLine."Item Attribute 7";
    //           lrc_BatchVariant."Item Attribute 4" := rrc_ItemJournalLine."Item Attribute 4";
    //           lrc_BatchVariant."Coding Code" := rrc_ItemJournalLine."Coding Code";
    //           lrc_BatchVariant."Item Attribute 5" := rrc_ItemJournalLine."Item Attribute 5";

    //           lrc_BatchVariant."Master Batch No." := rrc_ItemJournalLine."Master Batch No.";
    //           lrc_BatchVariant."Batch No." := rrc_ItemJournalLine."Batch No.";

    //           lrc_BatchVariant."Departure Date" := rrc_ItemJournalLine."Posting Date";
    //           lrc_BatchVariant."Order Date" := rrc_ItemJournalLine."Posting Date";
    //           lrc_BatchVariant."Date of Delivery" := rrc_ItemJournalLine."Posting Date";

    //           lrc_BatchVariant."Kind of Settlement" := 0;
    //           lrc_BatchVariant.Weight := 0;
    //           lrc_BatchVariant."Producer No." := rrc_ItemJournalLine."Producer No.";
    //           IF rrc_ItemJournalLine."Lot No. Producer" <> '' THEN BEGIN
    //             lrc_BatchVariant."Lot No. Producer" := rrc_ItemJournalLine."Lot No. Producer";
    //           END;
    //           lrc_BatchVariant."Entry Location Code" := rrc_ItemJournalLine."Location Code";

    //           lrc_BatchVariant."Date of Expiry" := rrc_ItemJournalLine."Date of Expiry";
    //           lrc_BatchVariant."Kind of Loading" := 0;
    //           lrc_BatchVariant."Voyage No." := '';
    //           lrc_BatchVariant."Container No." := '';
    //           lrc_BatchVariant."Means of Transport Type" := 0;
    //           lrc_BatchVariant."Means of Transp. Code (Depart)" := '';
    //           lrc_BatchVariant."Means of Transp. Code (Arriva)" := '';
    //           lrc_BatchVariant."Means of Transport Info" := '';

    //           lrc_BatchVariant."Status Customs Duty" := 0;

    //           lrc_BatchVariant."Base Unit of Measure (BU)" := rrc_ItemJournalLine."Base Unit of Measure (BU)";
    //           lrc_BatchVariant."Unit of Measure Code" := rrc_ItemJournalLine."Unit of Measure Code";
    //           lrc_BatchVariant."Qty. per Unit of Measure" := rrc_ItemJournalLine."Qty. per Unit of Measure";

    //           lrc_ItemUnitOfMeasure.RESET();
    //           IF lrc_ItemUnitOfMeasure.GET(rrc_ItemJournalLine."Item No.",rrc_ItemJournalLine."Unit of Measure Code") THEN BEGIN
    //             CASE lrc_ItemUnitOfMeasure."Kind of Unit of Measure" OF
    //                lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Base Unit":
    //                  BEGIN
    //                    lrc_PriceCalculation.RESET();
    //                    lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                  lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                    lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                   lrc_PriceCalculation."Internal Calc. Type"::"Base Unit");
    //                    IF (lrc_PriceCalculation.FINDFIRST()) AND
    //                       (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                    END ELSE BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                    END;
    //                  END;
    //                lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Content Unit":
    //                  BEGIN
    //                    lrc_PriceCalculation.RESET();
    //                    lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                  lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                    lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                  lrc_PriceCalculation."Internal Calc. Type"::"Content Unit");
    //                    IF (lrc_PriceCalculation.FINDFIRST()) AND
    //                       (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                    END ELSE BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                    END;
    //                  END;
    //                lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Packing Unit":
    //                  BEGIN
    //                    lrc_PriceCalculation.RESET();
    //                    lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                  lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                    lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                  lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit");
    //                    IF (lrc_PriceCalculation.FINDFIRST()) AND
    //                       (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                    END ELSE BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                    END;

    //                  END;
    //                lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Collo Unit":
    //                  BEGIN
    //                    lrc_PriceCalculation.RESET();
    //                    lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                  lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                    lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                  lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit");
    //                    IF (lrc_PriceCalculation.FINDFIRST()) AND
    //                       (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                    END ELSE BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                    END;
    //                  END;
    //                lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Transport Unit":
    //                  BEGIN
    //                    lrc_PriceCalculation.RESET();
    //                    lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                  lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                    lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                  lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit");
    //                    IF (lrc_PriceCalculation.FINDFIRST()) AND
    //                       (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                    END ELSE BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                    END;
    //                  END;
    //                ELSE
    //                  lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //             END;
    //           END ELSE BEGIN
    //             lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //           END;
    //           lrc_BatchVariant."Purch. Price (Price Base)" := rrc_ItemJournalLine."Unit Amount";

    //           lrc_BatchVariant."Source Line No." := rrc_ItemJournalLine."Line No.";

    //           lrc_BatchVariant."Shortcut Dimension 1 Code" := rrc_ItemJournalLine."Shortcut Dimension 1 Code";
    //           lrc_BatchVariant."Shortcut Dimension 2 Code" := rrc_ItemJournalLine."Shortcut Dimension 2 Code";
    //           lrc_BatchVariant."Shortcut Dimension 3 Code" := rrc_ItemJournalLine."Shortcut Dimension 3 Code";
    //           lrc_BatchVariant."Shortcut Dimension 4 Code" := rrc_ItemJournalLine."Shortcut Dimension 4 Code";

    //           lrc_BatchVariant.MODIFY();
    //         END;

    //         SetBatchStatusOpen(rrc_ItemJournalLine."Batch No.");
    //     end;

    //     procedure ItemJournalLineCreateBatchVar(rco_JournalTemplateName: Code[10];rco_JournalBatchName: Code[10];rin_LineNo: Integer)
    //     var
    //         lrc_ItemJournalLine: Record "83";
    //         lrc_ItemJournalLine2: Record "83";
    //         lco_MasterBatchNo: Code[20];
    //         lco_BatchNo: Code[20];
    //         lin_BatchVariantCounter: Integer;
    //         lin_MaxBatchVariantCounter: Integer;
    //         lrc_BatchSetup: Record "5110363";
    //         lco_AktMasterBatchNo: Code[20];
    //         lco_AktBatchNo: Code[20];
    //         lco_AktBatchVariantNo: Code[20];
    //     begin
    //         // -------------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------------

    //         lrc_ItemJournalLine.RESET();
    //         lrc_ItemJournalLine.SETRANGE("Journal Template Name", rco_JournalTemplateName);
    //         lrc_ItemJournalLine.SETRANGE("Journal Batch Name", rco_JournalBatchName);
    //         IF rin_LineNo <> 0 THEN BEGIN
    //           lrc_ItemJournalLine.SETRANGE("Line No.", rin_LineNo);
    //         END;
    //         IF lrc_ItemJournalLine.FIND('-') THEN BEGIN

    //           lrc_BatchSetup.GET();
    //           lrc_BatchSetup.TESTFIELD("IJnlLi Master Batch No. Series");

    //           lin_BatchVariantCounter := 1;
    //           lin_MaxBatchVariantCounter := 0;

    //           lco_MasterBatchNo := '';
    //           lco_BatchNo := '';

    //           lrc_ItemJournalLine2.RESET();
    //           lrc_ItemJournalLine2.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
    //           lrc_ItemJournalLine2.SETFILTER("Master Batch No.", '<>%1', '');
    //           lrc_ItemJournalLine2.SETRANGE("Journal Template Name", rco_JournalTemplateName);
    //           lrc_ItemJournalLine2.SETRANGE("Journal Batch Name", rco_JournalBatchName);
    //           IF lrc_ItemJournalLine2.FIND('-') THEN BEGIN
    //             IF lrc_ItemJournalLine2.FIND('+') THEN BEGIN
    //               lco_MasterBatchNo := lrc_ItemJournalLine2."Master Batch No.";
    //               lrc_ItemJournalLine2.SETFILTER("Batch No.", '<>%1', '');
    //               IF lrc_ItemJournalLine2.FIND('+') THEN BEGIN
    //                 lco_BatchNo := lrc_ItemJournalLine2."Batch No.";
    //               END;
    //             END;
    //           END;

    //           REPEAT
    //               IF (lrc_ItemJournalLine."Entry Type" = lrc_ItemJournalLine."Entry Type"::"Positive Adjmt.") AND
    //                  (lrc_ItemJournalLine."Created From Inventory Report" = FALSE) THEN BEGIN
    //                  IF lrc_ItemJournalLine."Batch Item" = TRUE THEN BEGIN
    //                     IF (lrc_ItemJournalLine.Quantity <> 0) AND
    //                        (lrc_ItemJournalLine."Master Batch No." = '') AND
    //                        (lrc_ItemJournalLine."Batch No." = '') AND
    //                        (lrc_ItemJournalLine."Batch Variant No." = '') THEN BEGIN

    //                        // Partienummer vergeben
    //                        ItemJournalLineNewMasterBatch(lrc_ItemJournalLine, lco_MasterBatchNo, lco_AktMasterBatchNo);
    //                        lrc_ItemJournalLine."Master Batch No." := lco_AktMasterBatchNo;

    //                        IF lrc_BatchSetup."IJnlLi Allocation Batch No." =
    //                           lrc_BatchSetup."IJnlLi Allocation Batch No."::"New Batch No. per Line" THEN BEGIN
    //                           lco_AktBatchNo := '';
    //                        END;

    //                        // Positionsnr vergeben
    //                        ItemJournalLineNewBatch(lrc_ItemJournalLine, lco_BatchNo, lco_AktBatchNo);
    //                        lrc_ItemJournalLine."Batch No." := lco_AktBatchNo;

    //                        // Positionsvariantennr vergeben
    //                        ItemJournalLineNewBatchVar(lrc_ItemJournalLine, lco_BatchNo, lco_AktBatchVariantNo);
    //                        // Positionsnummer ggfls. geändert durch Erreichen des Postfix - Endes
    //                        lco_AktBatchNo := lco_BatchNo;
    //                        lrc_ItemJournalLine."Batch No." := lco_BatchNo;
    //                        lrc_ItemJournalLine."Batch Variant No." := lco_AktBatchVariantNo;
    //                        lrc_ItemJournalLine."Batch Variant generated" := TRUE;
    //                        lrc_ItemJournalLine.MODIFY( TRUE);

    //                        lco_MasterBatchNo := lrc_ItemJournalLine."Master Batch No.";
    //                        lco_BatchNo := lrc_ItemJournalLine."Batch No.";

    //                    END;
    //                  END;
    //               END;
    //            UNTIL lrc_ItemJournalLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure ItemJournalLineSetPhyInventory(rco_JournalTemplateName: Code[10];rco_JournalBatchName: Code[10])
    //     var
    //         lrc_ItemJournalLine: Record "83";
    //     begin
    //         // -------------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------------

    //         lrc_ItemJournalLine.RESET();
    //         lrc_ItemJournalLine.SETRANGE("Journal Template Name", rco_JournalTemplateName);
    //         lrc_ItemJournalLine.SETRANGE("Journal Batch Name", rco_JournalBatchName);
    //         IF lrc_ItemJournalLine.FIND('-') THEN BEGIN
    //            REPEAT

    //               IF lrc_ItemJournalLine."Phys. Inventory" = FALSE THEN BEGIN
    //                  lrc_ItemJournalLine."Phys. Inventory" := TRUE;
    //                  lrc_ItemJournalLine.MODIFY( TRUE);
    //               END;

    //            UNTIL lrc_ItemJournalLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure ItemJournalBatchVarNo(vrc_ItemJournalLine: Record "83"): Integer
    //     var
    //         lcu_NoSeriesManagement: Codeunit "396";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_BatchVarDetail: Record "5110487";
    //         lfm_BatchVarDetail: Form "5110491";
    //         lin_DetailEntryNo: Integer;
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Erfassung Positionsvariantennr. zu Artikelbuchblattzeile
    //         // ----------------------------------------------------------------------------------

    //         IF (vrc_ItemJournalLine."Item No." = '') OR
    //            (vrc_ItemJournalLine."Batch Item" = FALSE) THEN BEGIN
    //           IF vrc_ItemJournalLine."Batch Var. Detail ID" <> 0 THEN BEGIN
    //           END;
    //           EXIT(vrc_ItemJournalLine."Batch Var. Detail ID");
    //         END;

    //         vrc_ItemJournalLine.TESTFIELD("Location Code");

    //         lrc_BatchSetup.GET();
    //         IF (lrc_BatchSetup."Sales Batch Assignment" <> lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line") AND
    //            (lrc_BatchSetup."Sales Batch Assignment" <> lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line") THEN
    //           EXIT(vrc_ItemJournalLine."Batch Var. Detail ID");

    //         IF vrc_ItemJournalLine."Batch Var. Detail ID" = 0 THEN BEGIN
    //           lin_DetailEntryNo := GetBatchVarDetailNo();
    //           vrc_ItemJournalLine."Batch Var. Detail ID" := lin_DetailEntryNo;
    //         END ELSE
    //           lin_DetailEntryNo := vrc_ItemJournalLine."Batch Var. Detail ID";

    //         CASE lrc_BatchSetup."Sales Batch Assignment" OF
    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line":
    //           BEGIN
    //             lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //             IF NOT lrc_BatchVarDetail.FIND('-') THEN BEGIN
    //               lrc_BatchVarDetail.RESET();
    //               lrc_BatchVarDetail.INIT();
    //               lrc_BatchVarDetail."Entry No." := lin_DetailEntryNo;
    //               lrc_BatchVarDetail."Line No." := 0;
    //               lrc_BatchVarDetail.INSERT(TRUE);
    //             END;
    //             lrc_BatchVarDetail."Item No." := vrc_ItemJournalLine."Item No.";
    //             lrc_BatchVarDetail."Variant Code" := vrc_ItemJournalLine."Variant Code";
    //             lrc_BatchVarDetail."Master Batch No." := vrc_ItemJournalLine."Master Batch No.";
    //             lrc_BatchVarDetail."Batch No." := vrc_ItemJournalLine."Batch No.";
    //             lrc_BatchVarDetail."Batch Variant No." := vrc_ItemJournalLine."Batch Variant No.";
    //             lrc_BatchVarDetail."Location Code" := vrc_ItemJournalLine."Location Code";
    //             lrc_BatchVarDetail."Unit of Measure Code" := vrc_ItemJournalLine."Unit of Measure Code";
    //             lrc_BatchVarDetail.Quantity := vrc_ItemJournalLine.Quantity;
    //             lrc_BatchVarDetail."Qty. to Post" := vrc_ItemJournalLine.Quantity;
    //             lrc_BatchVarDetail."Qty. Posted" := vrc_ItemJournalLine.Quantity;
    //             lrc_BatchVarDetail."Base Unit of Measure" := vrc_ItemJournalLine."Base Unit of Measure (BU)";
    //             lrc_BatchVarDetail."Qty. per Unit of Measure" := vrc_ItemJournalLine."Qty. per Unit of Measure";
    //             lrc_BatchVarDetail."Qty. (Base)" := vrc_ItemJournalLine."Quantity (Base)";
    //             lrc_BatchVarDetail."Qty. to Post (Base)" := vrc_ItemJournalLine."Quantity (Base)";
    //             lrc_BatchVarDetail."Qty. Posted (Base)" := vrc_ItemJournalLine."Quantity (Base)";
    //             lrc_BatchVarDetail.MODIFY();

    //             IF lrc_BatchVarDetail."Batch Variant No." <> '' THEN
    //               BatchVariantRecalc(lrc_BatchVarDetail."Item No.", lrc_BatchVarDetail."Batch Variant No.");

    //           END;

    //         lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line":
    //           BEGIN
    //             COMMIT;
    //             lrc_BatchVarDetail.FILTERGROUP(2);
    //             lrc_BatchVarDetail.SETRANGE("Entry No.",lin_DetailEntryNo);
    //             lrc_BatchVarDetail.FILTERGROUP(0);
    //             lfm_BatchVarDetail.ItemJournalInit(vrc_ItemJournalLine);
    //             lfm_BatchVarDetail.SETTABLEVIEW(lrc_BatchVarDetail);
    //             lfm_BatchVarDetail.RUNMODAL;
    //           END;

    //         END;

    //         EXIT(lin_DetailEntryNo);
    //     end;

    procedure BatchVariantRecalc(rco_ItemNo: Code[20]; rco_BatchVariantNo: Code[20])
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Rekalkulation einer Positionsvariante
        // ---------------------------------------------------------------------------------------

        BatchVariantRecalc_Ins_Mod(rco_ItemNo, rco_BatchVariantNo, 0);
    end;

    procedure BatchVariantRecalc_Ins_Mod(rco_ItemNo: Code[20]; rco_BatchVariantNo: Code[20]; rdc_Quantity: Decimal)
    var
        lrc_MasterBatchSetup: Record "POI Master Batch Setup";
        "ldc_ErwVerfügbarerBestand": Decimal;
        ldc_TempValue: array[10] of Decimal;
    begin
        // ------------------------------------------------------------------------------------------
        // Funktion zur Rekalkulation einer Positionsvariante bei Anlage Datensatz BatchVariantEntry
        // ------------------------------------------------------------------------------------------

        IF NOT lrc_BatchVariant.GET(rco_BatchVariantNo) THEN
            EXIT;

        // Keine Aktion bei Dummy oder Sortiment
        IF (lrc_BatchVariant.Source = lrc_BatchVariant.Source::Dummy) OR
           (lrc_BatchVariant.Source = lrc_BatchVariant.Source::Assortment) THEN
            EXIT;

        lrc_MasterBatchSetup.GET();

        // Parameter:  vco_BatchVariantNo
        //             vco_LocationFilter
        //             vdc_Rounding
        //             rdc_Bestand
        //             rdc_BestandVerf
        //             rdc_ErwBestandVerf
        //             rdc_MgeInAuftrag
        //             rdc_MgeInBestellung
        //             rdc_MgeReserviertFV
        //             rdc_MgeVerzollungsauftrag
        //             rdc_MgeInVkRechnung
        //             rdc_MgeInVkLieferung
        //             rdc_MgeInEkLieferung
        //             vdc_ShowInQtyperUnitofMeasure
        CalcStockBatchVar(rco_BatchVariantNo,
                          '',
                          0.1,
                          ldc_TempValue[1],
                          ldc_TempValue[2],
                          ldc_ErwVerfügbarerBestand,
                          ldc_TempValue[3],
                          ldc_TempValue[4],
                          ldc_TempValue[5],
                          ldc_TempValue[6],
                          ldc_TempValue[7],
                          ldc_TempValue[8],
                          ldc_TempValue[9],
                          1);
        ldc_ErwVerfügbarerBestand := ldc_ErwVerfügbarerBestand + rdc_Quantity;


        IF lrc_BatchVariant.State <> lrc_BatchVariant.State::"Manual Blocked" THEN BEGIN

            CASE lrc_MasterBatchSetup."Set Batch Var. Closed when" OF
                lrc_MasterBatchSetup."Set Batch Var. Closed when"::"Mge erw. verfg. Null":
                    IF ldc_ErwVerfügbarerBestand > 0 THEN
                        lrc_BatchVariant.State := lrc_BatchVariant.State::Open
                    ELSE
                        lrc_BatchVariant.State := lrc_BatchVariant.State::Closed;

                lrc_MasterBatchSetup."Set Batch Var. Closed when"::"Mge erh. und gelief. Null":
                    CASE lrc_BatchVariant.Source OF
                        lrc_BatchVariant.Source::"Purch. Order",
                        lrc_BatchVariant.Source::"Packing Order",
                        lrc_BatchVariant.Source::"Sorting Order":
                            // Erhaltene Menge und gelieferte Menge ungleich Null und gleich groß
                            IF ((ldc_TempValue[8] * -1) <> 0) AND
                               (ldc_TempValue[9] <> 0) AND
                               (ldc_TempValue[9] = (ldc_TempValue[8] * -1)) THEN
                                // Menge in Auftrag
                                IF ldc_TempValue[3] = 0 THEN
                                    lrc_BatchVariant.State := lrc_BatchVariant.State::Closed
                                ELSE
                                    lrc_BatchVariant.State := lrc_BatchVariant.State::Open
                            ELSE
                                lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
                    END;
            END;

            lrc_BatchVariant.MODIFY();
        END;
    end;



    // procedure CalcValueAll()
    // var
    //     lrc_BatchVariantEntry: Record "5110368";
    // begin
    //     // -------------------------------------------------------------------------------------------
    //     // Alle Batch Variant Entry Posten für eine Partie berechnen
    //     // -------------------------------------------------------------------------------------------

    //     IF lrc_BatchVariantEntry.FINDSET(FALSE,FALSE) THEN
    //       REPEAT
    //         CalcValueBatchVarEntry(lrc_BatchVariantEntry."Entry No.");
    //       UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    // end;

    // procedure CalcValueMasterBatch(vco_MasterBatchNo: Code[20])
    // var
    //     lrc_BatchVariantEntry: Record "5110368";
    // begin
    //     // -------------------------------------------------------------------------------------------
    //     // Alle Batch Variant Entry Posten für eine Partie berechnen
    //     // -------------------------------------------------------------------------------------------

    //     lrc_BatchVariantEntry.SETCURRENTKEY("Item No.","Item Ledger Entry Type","Location Code",
    //                           "Master Batch No.","Batch No.","Batch Variant No.","Variant Code");
    //     lrc_BatchVariantEntry.SETRANGE("Master Batch No.",vco_MasterBatchNo);
    //     IF lrc_BatchVariantEntry.FINDSET(FALSE,FALSE) THEN BEGIN
    //       REPEAT
    //         CalcValueBatchVarEntry(lrc_BatchVariantEntry."Entry No.");
    //       UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //     END;
    // end;

    // procedure CalcValueBatch(vco_BatchNo: Code[20])
    // var
    //     lrc_BatchVariantEntry: Record "5110368";
    // begin
    //     // -------------------------------------------------------------------------------------------
    //     // Alle Batch Variant Entry Posten für eine Position berechnen
    //     // -------------------------------------------------------------------------------------------

    //     lrc_BatchVariantEntry.SETCURRENTKEY("Item No.","Item Ledger Entry Type","Location Code",
    //                           "Master Batch No.","Batch No.","Batch Variant No.","Variant Code");
    //     lrc_BatchVariantEntry.SETRANGE("Batch No.",vco_BatchNo);
    //     IF lrc_BatchVariantEntry.FINDSET(FALSE,FALSE) THEN BEGIN
    //       REPEAT
    //         CalcValueBatchVarEntry(lrc_BatchVariantEntry."Entry No.");
    //       UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //     END;
    // end;

    //     procedure CalcValueBatchVar(vco_BatchVarNo: Code[20])
    //     var
    //         lrc_BatchVariantEntry: Record "5110368";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Alle Batch Variant Entry Posten für eine Positionsvariante berechnen
    //         // -------------------------------------------------------------------------------------------

    //         lrc_BatchVariantEntry.SETCURRENTKEY("Item No.","Item Ledger Entry Type","Location Code",
    //                               "Master Batch No.","Batch No.","Batch Variant No.","Variant Code");
    //         lrc_BatchVariantEntry.SETRANGE("Batch Variant No.",vco_BatchVarNo);
    //         IF lrc_BatchVariantEntry.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             CalcValueBatchVarEntry(lrc_BatchVariantEntry."Entry No.");
    //           UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CalcValueBatchVarEntry(vin_BatchVarEntryNo: Integer)
    //     var
    //         lrc_BatchVariantEntry: Record "5110368";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_Batch: Record "5110365";
    //         lrc_ItemLedgerEntry: Record "32";
    //         lrc_ItemLedgerEntryPurch: Record "32";
    //         "-": Integer;
    //         ldc_PurchCostAmtExp: Decimal;
    //         ldc_PurchCostAmtAct: Decimal;
    //         ldc_PurchAmtExp: Decimal;
    //         ldc_PurchAmtAct: Decimal;
    //         ldc_PurchMarket: Decimal;
    //         ldc_Qty: Decimal;
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zum Berechnen der Werte für Batch Var Entry aus den Artikelposten
    //         // -------------------------------------------------------------------------------------------

    //         lrc_BatchVariantEntry.GET(vin_BatchVarEntryNo);
    //         lrc_BatchVariant.GET(lrc_BatchVariantEntry."Batch Variant No.");
    //         lrc_ItemLedgerEntry.GET(lrc_BatchVariantEntry."Item Ledger Entry No.");

    //         CASE lrc_ItemLedgerEntry."Entry Type" OF
    //         lrc_ItemLedgerEntry."Entry Type"::Purchase:
    //           BEGIN
    //             lrc_Batch.GET(lrc_BatchVariant."Batch No.");
    //             lrc_ItemLedgerEntry.CALCFIELDS("Purchase Amount (Expected)",
    //                                            "Purchase Amount (Actual)",
    //                                            "Inv. Disc. (Actual)",
    //                                            "Inv. Disc. not Relat. to Goods",
    //                                            "Accruel Inv. Disc. (External)",
    //                                            "Accruel Inv. Disc. (Internal)",
    //                                            "Green Point Costs",
    //                                            "Freight Costs");
    //           END;
    //         END;


    //         lrc_ItemLedgerEntry.CALCFIELDS("Sales Amount (Actual)",
    //                                        "Sales Amount (Expected)",
    //                                        "Cost Amount (Expected)",
    //                                        "Cost Amount (Actual)",

    //                                        "Purchase Amount (Expected)",
    //                                        "Purchase Amount (Actual)",

    //                                        "Inv. Disc. (Actual)",
    //                                        "Inv. Disc. not Relat. to Goods",
    //                                        "Accruel Inv. Disc. (External)",
    //                                        "Accruel Inv. Disc. (Internal)",
    //                                        "Green Point Costs",
    //                                        "Freight Costs");

    //         /*----
    //         IF lrc_ItemLedgerEntry.Quantity <> 0 THEN BEGIN
    //           lrc_BatchVariantEntry."Sales Amount (Expected)" := lrc_ItemLedgerEntry."Sales Amount (Expected)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Sales Amount (Actual)" := lrc_ItemLedgerEntry."Sales Amount (Actual)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;

    //           lrc_BatchVariantEntry."Purchase Amount (Expected)" := lrc_ItemLedgerEntry."Purchase Amount (Expected)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Purchase Amount (Actual)" := lrc_ItemLedgerEntry."Purchase Amount (Actual)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;

    //           lrc_BatchVariantEntry."Cost Amount (Expected)" := lrc_ItemLedgerEntry."Cost Amount (Expected)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Cost Amount (Actual)" := lrc_ItemLedgerEntry."Cost Amount (Actual)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;

    //           lrc_BatchVariantEntry."Purch. Market Amount" := 0;

    //           lrc_BatchVariantEntry."Inv. Disc. (Actual)" := lrc_ItemLedgerEntry."Inv. Disc. (Actual)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Inv. Disc. not Relat. to Goods" := lrc_ItemLedgerEntry."Inv. Disc. not Relat. to Goods" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Accruel Inv. Disc. (External)" := lrc_ItemLedgerEntry."Accruel Inv. Disc. (External)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Accruel Inv. Disc. (Internal)" := lrc_ItemLedgerEntry."Accruel Inv. Disc. (Internal)" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Green Point Costs (Actual)" := lrc_ItemLedgerEntry."Green Point Costs" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;
    //           lrc_BatchVariantEntry."Freightcosts (Actual)" := lrc_ItemLedgerEntry."Freight Costs" *
    //                                                    lrc_BatchVariantEntry."Quantity (Base)" / lrc_ItemLedgerEntry.Quantity;

    //           lrc_BatchVariantEntry."Invoiced Quantity" := lrc_ItemLedgerEntry."Invoiced Quantity" / lrc_ItemLedgerEntry.Quantity *
    //                                                      lrc_BatchVariantEntry."Quantity (Base)";

    //           lrc_BatchVariantEntry."Completely Invoiced" := lrc_ItemLedgerEntry."Completely Invoiced";

    //         END ELSE BEGIN

    //           lrc_BatchVariantEntry."Sales Amount (Expected)" := 0;
    //           lrc_BatchVariantEntry."Sales Amount (Actual)" := 0;
    //           lrc_BatchVariantEntry."Purchase Amount (Expected)" := 0;
    //           lrc_BatchVariantEntry."Purchase Amount (Actual)" := 0;
    //           lrc_BatchVariantEntry."Cost Amount (Expected)" := 0;
    //           lrc_BatchVariantEntry."Cost Amount (Actual)" := 0;
    //           lrc_BatchVariantEntry."Purch. Market Amount" := 0;
    //           lrc_BatchVariantEntry."Inv. Disc. (Actual)" := 0;
    //           lrc_BatchVariantEntry."Inv. Disc. not Relat. to Goods" := 0;
    //           lrc_BatchVariantEntry."Accruel Inv. Disc. (External)" := 0;
    //           lrc_BatchVariantEntry."Accruel Inv. Disc. (Internal)" := 0;
    //           lrc_BatchVariantEntry."Green Point Costs (Actual)" := 0;
    //           lrc_BatchVariantEntry."Freightcosts (Actual)" := 0;
    //           lrc_BatchVariantEntry."Invoiced Quantity" := 0;
    //           lrc_BatchVariantEntry."Completely Invoiced" := lrc_ItemLedgerEntry."Completely Invoiced";

    //         END;
    //         ----*/

    //         // Einkaufswert ermitteln
    //         CASE lrc_ItemLedgerEntry."Entry Type" OF
    //         lrc_ItemLedgerEntry."Entry Type"::Sale:
    //           BEGIN
    //             lrc_ItemLedgerEntryPurch.RESET();
    //             lrc_ItemLedgerEntryPurch.SETCURRENTKEY("Batch Variant No.",Open,Positive,"Location Code","Posting Date");
    //             lrc_ItemLedgerEntryPurch.SETFILTER("Entry Type",'%1|%2',lrc_ItemLedgerEntryPurch."Entry Type"::Purchase,
    //                                                                     lrc_ItemLedgerEntryPurch."Entry Type"::"Positive Adjmt.");
    //             //lrc_ItemLedgerEntryPurch.SETRANGE("Entry Type",lrc_ItemLedgerEntryPurch."Entry Type"::Purchase);
    //             lrc_ItemLedgerEntryPurch.SETRANGE("Item No.",lrc_ItemLedgerEntry."Item No.");
    //             lrc_ItemLedgerEntryPurch.SETRANGE("Master Batch No.",lrc_ItemLedgerEntry."Master Batch No.");
    //             lrc_ItemLedgerEntryPurch.SETRANGE("Batch No.",lrc_ItemLedgerEntry."Batch No.");
    //             lrc_ItemLedgerEntryPurch.SETRANGE("Batch Variant No.",lrc_ItemLedgerEntry."Batch Variant No.");
    //             IF lrc_ItemLedgerEntryPurch.FIND('-') THEN BEGIN
    //               REPEAT

    //                 lrc_ItemLedgerEntryPurch.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)",
    //                                                     "Purchase Amount (Expected)", "Purchase Amount (Actual)");

    //                 ldc_PurchCostAmtExp := ldc_PurchCostAmtExp + lrc_ItemLedgerEntryPurch."Cost Amount (Expected)";
    //                 ldc_PurchCostAmtAct := ldc_PurchCostAmtAct + lrc_ItemLedgerEntryPurch."Cost Amount (Actual)";
    //                 ldc_PurchAmtExp := ldc_PurchAmtExp + lrc_ItemLedgerEntryPurch."Purchase Amount (Expected)";
    //                 ldc_PurchAmtAct := ldc_PurchAmtAct + lrc_ItemLedgerEntryPurch."Purchase Amount (Actual)";

    //                 ldc_Qty := ldc_Qty + lrc_ItemLedgerEntryPurch.Quantity;

    //               UNTIL lrc_ItemLedgerEntryPurch.NEXT() = 0;

    //               IF ldc_Qty <> 0 THEN BEGIN
    //                 ldc_PurchCostAmtExp := ldc_PurchCostAmtExp / ldc_Qty;
    //                 ldc_PurchCostAmtAct := ldc_PurchCostAmtAct / ldc_Qty;
    //                 ldc_PurchAmtExp := ldc_PurchAmtExp / ldc_Qty;
    //                 ldc_PurchAmtAct := ldc_PurchAmtAct / ldc_Qty;
    //               END;

    //               // Batch Variant Entry aktualisieren
    //         //      lrc_BatchVariantEntry."Purchase Amount (Expected)" := ldc_PurchAmtExp * lrc_BatchVariantEntry."Quantity (Base)";
    //         //      lrc_BatchVariantEntry."Purchase Amount (Actual)" := ldc_PurchAmtAct * lrc_BatchVariantEntry."Quantity (Base)";
    //         //      lrc_BatchVariantEntry."Cost Amount (Expected)" := ldc_PurchCostAmtExp * lrc_BatchVariantEntry."Quantity (Base)";
    //         //      lrc_BatchVariantEntry."Cost Amount (Actual)" := ldc_PurchCostAmtAct * lrc_BatchVariantEntry."Quantity (Base)";
    //         //      lrc_BatchVariantEntry."Purch. Market Amount" := 0;

    //             END;

    //           END;

    //         END;

    //         lrc_BatchVariantEntry.MODIFY();

    //     end;

    //     procedure CalcBatchVarEntryPerItemLedger(vrc_ItemLedgerEntry: Record "32") ldc_Quantity: Decimal
    //     var
    //         lrc_BatchVariantEntry: Record "5110368";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zum Berechnen der Menge in Batch Variant Entry pro Item Ledger Entry
    //         // -------------------------------------------------------------------------------------------

    //         ldc_Quantity := 0;
    //         lrc_BatchVariantEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //         lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry No.",vrc_ItemLedgerEntry."Entry No.");
    //         IF lrc_BatchVariantEntry.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             ldc_Quantity := ldc_Quantity + lrc_BatchVariantEntry."Quantity (Base)";
    //           UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //         END;
    //         EXIT(ldc_Quantity);
    //     end;

    //     procedure ShowBatchVarEntryPerItemLedger(vrc_ItemLedgerEntry: Record "32")
    //     var
    //         lrc_BatchVariantEntry: Record "5110368";
    //         lfm_BatchVariantEntry: Form "5110492";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der zugeordneten Batch Variant Entry pro Item Ledger Entry
    //         // -------------------------------------------------------------------------------------------

    //         lrc_BatchVariantEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //         lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry No.",vrc_ItemLedgerEntry."Entry No.");
    //         lfm_BatchVariantEntry.SETTABLEVIEW(lrc_BatchVariantEntry);
    //         lfm_BatchVariantEntry.RUNMODAL;
    //     end;

    //     procedure SetCostAmountToSalesNegAdj(vco_BatchNo: Code[20])
    //     var
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchVariantEntry: Record "5110368";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der Einkaufskosten in Sales und Neg. Adj. Posten
    //         // -------------------------------------------------------------------------------------------

    //         lrc_Batch.GET(vco_BatchNo);

    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.SETRANGE("Batch No.",lrc_Batch."No.");
    //         IF lrc_BatchVariant.FIND('-') THEN BEGIN

    //           // Kosten aus Batch berechnen
    //           //  lrc_Batch."Amount Calc Cost"
    //           //  lrc_Batch."Amount Cost"

    //           REPEAT

    //             // -------------------------------------------------------------------------------------------------
    //             // Einstandsbetrag ermitteln
    //             // -------------------------------------------------------------------------------------------------

    //             // Einkaufsposten und Zugangsposten lesen zur Berechnung Einkaufspreis und Kosten (=Einstandsbetrag)
    //             lrc_BatchVariantEntry.RESET();
    //             lrc_BatchVariantEntry.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //             lrc_BatchVariantEntry.SETFILTER("Item Ledger Entry Type",'%1|%2',
    //                                             lrc_BatchVariantEntry."Item Ledger Entry Type"::Purchase,
    //                                             lrc_BatchVariantEntry."Item Ledger Entry Type"::"Positive Adjmt.");
    //             IF lrc_BatchVariantEntry.FIND('-') THEN BEGIN
    //               REPEAT

    //               UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //             END;

    //             // Kontrolle auf Offene Einkaufszeile


    //             // Verkaufsposten und Abgangsposten lesen zur Verteilung der Einstandswerte
    //             lrc_BatchVariantEntry.RESET();
    //             lrc_BatchVariantEntry.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //             lrc_BatchVariantEntry.SETFILTER("Item Ledger Entry Type",'%1|%2',
    //                                             lrc_BatchVariantEntry."Item Ledger Entry Type"::Sale,
    //                                             lrc_BatchVariantEntry."Item Ledger Entry Type"::"Negative Adjmt.");

    //           UNTIL lrc_BatchVariant.NEXT() = 0;

    //         END;
    //     end;

    procedure PackCheckStockBatchVar(var rrc_PackOrderOutputItems_Rec: Record "POI Pack. Order Output Items"; var rrc_PackOrderOutputItems_xRec: Record "POI Pack. Order Output Items"): Boolean
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        //lrc_PurchaseLine: Record "Purchase Line";
        //lfm_StockCheckBatchVariantNo: Form "5110490";
        ldc_Differenz: Decimal;
        "ldc_ErwVerfügbarerBestand": Decimal;
        ldc_TempValue: array[10] of Decimal;
    begin
        // ---------------------------------------------------------------------------------------------
        // Verfügbaren Bestand prüfen bei Mengenänderung aus Packereizeile
        // ---------------------------------------------------------------------------------------------

        IF (rrc_PackOrderOutputItems_Rec."Item No." = '') OR
           (rrc_PackOrderOutputItems_Rec."Line No." = 0) OR
           (rrc_PackOrderOutputItems_Rec."Batch Variant No." = '') THEN
            EXIT(TRUE);

        lrc_BatchSetup.GET();
        IF lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Automatic from System" THEN
            EXIT(TRUE);

        // Differenz zwischen alter und neuer Menge berechnen
        ldc_Differenz := (rrc_PackOrderOutputItems_Rec.Quantity - rrc_PackOrderOutputItems_xRec.Quantity) *
                          rrc_PackOrderOutputItems_Rec."Qty. per Unit of Measure";
        IF ldc_Differenz > 0 THEN
            EXIT(TRUE);

        // Bestände kalkulieren
        CalcStockBatchVar(rrc_PackOrderOutputItems_Rec."Batch Variant No.",
                          rrc_PackOrderOutputItems_Rec."Location Code",
                          0.1,
                          ldc_TempValue[1],
                          ldc_TempValue[2],
                          ldc_ErwVerfügbarerBestand,
                          ldc_TempValue[3],
                          ldc_TempValue[4],
                          ldc_TempValue[5],
                          ldc_TempValue[6],
                          ldc_TempValue[7],
                          ldc_TempValue[8],
                          ldc_TempValue[9],
                          1);

        ldc_ErwVerfügbarerBestand := ldc_ErwVerfügbarerBestand + ldc_Differenz;

        IF ldc_ErwVerfügbarerBestand < 0 THEN BEGIN
            lrc_BatchVariant.GET(rrc_PackOrderOutputItems_Rec."Batch Variant No.");
            // lfm_StockCheckBatchVariantNo.SSP_GlobaleSetzen(lrc_BatchVariant."Item No.", lrc_BatchVariant."No.",rrc_PackOrderOutputItems_Rec."Location Code", ldc_Differenz);
            // lfm_StockCheckBatchVariantNo.RUNMODAL();
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;

    //     procedure UpdateBatchFromBatchVariant(var rrc_BatchVariant: Record "5110366")
    //     var
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         lcu_PositionPlanning: Codeunit "5110345";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         //
    //         // ---------------------------------------------------------------------------------------------

    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.SETCURRENTKEY("Batch No.");
    //         lrc_BatchVariant.SETRANGE("Batch No.", rrc_BatchVariant."Batch No.");
    //         IF lrc_BatchVariant.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF (lrc_BatchVariant."Kind of Settlement" <> rrc_BatchVariant."Kind of Settlement") THEN BEGIN
    //               EXIT;
    //             END;
    //           UNTIL (lrc_BatchVariant.NEXT() = 0);
    //         END;

    //         lrc_Batch.GET(rrc_BatchVariant."Batch No.");
    //         lrc_Batch.VALIDATE("Kind of Settlement", rrc_BatchVariant."Kind of Settlement");
    //         lrc_Batch.VALIDATE("Item No.", rrc_BatchVariant."Item No.");
    //         lrc_Batch.VALIDATE("Item Description", rrc_BatchVariant.Description);
    //         lrc_Batch."Item Search Description" := lrc_BatchVariant."Search Description";
    //         IF rrc_BatchVariant."Date of Delivery" <> 0D THEN BEGIN
    //           lrc_Batch."Disposition Week" := lcu_PositionPlanning.GeneratePlanningWeek(rrc_BatchVariant."Date of Delivery",
    //                                                                                     lrc_Batch."Voyage No.");
    //         END;

    //         lrc_Batch."Port of Discharge Code" := rrc_BatchVariant."Port of Discharge Code";
    //         lrc_Batch."Date of Discharge" := rrc_BatchVariant."Date of Discharge";
    //         lrc_Batch."Time of Discharge" := rrc_BatchVariant."Time of Discharge";
    //         lrc_Batch.MODIFY();
    //     end;

    //     procedure CreateBatchVarEntryFromItemApp(vin_ItemLedgerEntryNo: Integer;vbn_Dialog: Boolean)
    //     var
    //         lrc_ItemLedgerEntry: Record "32";
    //         lrc_ItemLedgerEntryApplEntry: Record "32";
    //         lrc_ItemLedgerEntryTransfer: Record "32";
    //         lrc_ItemApplicationEntry: Record "339";
    //         lrc_BatchVariantEntry: Record "5110368";
    //         lrc_Location: Record "14";
    //         lin_NoOfBatchVarEntries: Integer;
    //         AGILES_LT_TEXT001: Label 'Keine Ausgleichsposten bezogene Umlagerung gefunden!';
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Pos.-Var.-Posten aus Artikelausgleichsposten generieren
    //         // ---------------------------------------------------------------------------------------------

    //         lrc_ItemLedgerEntry.GET(vin_ItemLedgerEntryNo);

    //         lrc_Item.GET(lrc_ItemLedgerEntry."Item No.");
    //         IF lrc_Item."Batch Item" = FALSE THEN
    //           EXIT;

    //         CASE lrc_ItemLedgerEntry."Entry Type" OF
    //         lrc_ItemLedgerEntry."Entry Type"::Purchase:
    //           BEGIN

    //             IF (lrc_ItemLedgerEntry.Positive = FALSE) THEN BEGIN



    //             END ELSE BEGIN

    //               // Bestehende Posten lesen
    //               lrc_BatchVariantEntry.RESET();
    //               lrc_BatchVariantEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //               lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //               lin_NoOfBatchVarEntries := lrc_BatchVariantEntry.COUNT();

    //               IF lin_NoOfBatchVarEntries > 1 THEN BEGIN
    //                 ERROR('Einkauf: Es ist mehr als ein Pos.-Var. Posten vorhanden!')
    //               END;

    //               IF lin_NoOfBatchVarEntries = 1 THEN BEGIN
    //                 lrc_BatchVariantEntry.FIND('-');
    //               END ELSE BEGIN
    //                 lrc_BatchVariantEntry.RESET();
    //                 lrc_BatchVariantEntry.INIT();
    //                 lrc_BatchVariantEntry."Entry No." := 0;
    //                 lrc_BatchVariantEntry.INSERT(TRUE);
    //               END;

    //                   lrc_BatchVariantEntry."Master Batch No." := lrc_ItemLedgerEntry."Master Batch No.";
    //                   lrc_BatchVariantEntry."Batch No." := lrc_ItemLedgerEntry."Batch No.";
    //                   lrc_BatchVariantEntry."Batch Variant No." := lrc_ItemLedgerEntry."Batch Variant No.";
    //                   lrc_BatchVariantEntry."Document No." := lrc_ItemLedgerEntry."Document No.";
    //                   //lrc_BatchVariantEntry."Document Line No." := 0;
    //                   lrc_BatchVariantEntry."Source Doc. Type" := lrc_ItemLedgerEntry."Source Doc. Type";
    //                   lrc_BatchVariantEntry."Source Doc. No." := lrc_ItemLedgerEntry."Source Doc. No.";
    //                   lrc_BatchVariantEntry."Source Doc. Line No." := lrc_ItemLedgerEntry."Source Doc. Line No.";
    //                   //lrc_BatchVariantEntry."Status Customs Duty" :=
    //                   lrc_BatchVariantEntry."Posting Date" := lrc_ItemLedgerEntry."Posting Date";
    //                   lrc_BatchVariantEntry."Item No." := lrc_ItemLedgerEntry."Item No.";
    //                   lrc_BatchVariantEntry."Variant Code" := lrc_ItemLedgerEntry."Variant Code";
    //                   lrc_BatchVariantEntry."Location Code" := lrc_ItemLedgerEntry."Location Code";
    //                   lrc_BatchVariantEntry.Positive := lrc_ItemLedgerEntry.Positive;
    //                   lrc_BatchVariantEntry."Base Unit Of Measure Code" := lrc_ItemLedgerEntry."Base Unit of Measure";
    //                   lrc_BatchVariantEntry."Quantity (Base)" := lrc_ItemLedgerEntry.Quantity;
    //                   lrc_BatchVariantEntry."Invoiced Quantity" := 0;
    //                   lrc_BatchVariantEntry."Unit of Measure Code" := lrc_ItemLedgerEntry."Unit of Measure Code";
    //                   lrc_BatchVariantEntry."Qty. per Unit of Measure" := lrc_ItemLedgerEntry."Qty. per Unit of Measure";
    //                   IF lrc_ItemLedgerEntry."Qty. per Unit of Measure" <> 0 THEN
    //                     lrc_BatchVariantEntry.Quantity := lrc_ItemLedgerEntry.Quantity / lrc_ItemLedgerEntry."Qty. per Unit of Measure";

    //                   lrc_BatchVariantEntry."Qty (Base) (Item Ledger Entry)" := lrc_ItemLedgerEntry.Quantity;

    //                   lrc_BatchVariantEntry."Detail Entry No." := 0;
    //                   lrc_BatchVariantEntry."Detail Line No." := 0;

    //                   lrc_BatchVariantEntry."Item Ledger Entry No." := lrc_ItemLedgerEntry."Entry No.";
    //                   lrc_BatchVariantEntry."Item Ledger Entry Type" := lrc_ItemLedgerEntry."Entry Type";

    //                   //lrc_BatchVariantEntry."Applied Item Ledger Entry No." := lrc_ItemLedgerEntryApplEntry."Entry No.";
    //                   //lrc_BatchVariantEntry."Applied Item Ledger Entry Type" := lrc_ItemLedgerEntryApplEntry."Entry Type";

    //                   lrc_BatchVariantEntry.Open := FALSE;

    //                   lrc_BatchVariantEntry."Quality Rating" := lrc_ItemLedgerEntry."Quality Rating";
    //                   lrc_BatchVariantEntry."Ship-to Code" := lrc_ItemLedgerEntry."Ship-to/Order Address Code";

    //                   lrc_BatchVariantEntry.MODIFY();

    //             END;

    //           END;

    //         lrc_ItemLedgerEntry."Entry Type"::Sale:
    //           BEGIN

    //             IF (lrc_ItemLedgerEntry.Positive = FALSE) THEN BEGIN

    //               lrc_ItemLedgerEntry.CALCFIELDS("Quantity (Batch Var. Entry)");
    //               IF lrc_ItemLedgerEntry."Quantity (Batch Var. Entry)" = lrc_ItemLedgerEntry.Quantity THEN BEGIN
    //                 IF vbn_Dialog = TRUE THEN BEGIN
    //                   IF NOT CONFIRM('Menge bereits zugeordnet! Trotzdem?') THEN
    //                     EXIT;
    //                  END;
    //               END;

    //               // Bestehende Posten löschen
    //               lrc_BatchVariantEntry.RESET();
    //               lrc_BatchVariantEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //               lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //               lrc_BatchVariantEntry.DELETEALL();

    //               // Ausgleichsposten lesen
    //               lrc_ItemApplicationEntry.RESET();
    //               lrc_ItemApplicationEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //               lrc_ItemApplicationEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //               IF lrc_ItemApplicationEntry.FIND('-') THEN BEGIN
    //                 REPEAT

    //                   // Posten von dem die Menge abgebucht wurde lesen
    //                   lrc_ItemLedgerEntryApplEntry.GET(lrc_ItemApplicationEntry."Inbound Item Entry No.");

    //                   lrc_BatchVariantEntry.RESET();
    //                   lrc_BatchVariantEntry.INIT();
    //                   lrc_BatchVariantEntry."Entry No." := 0;
    //                   lrc_BatchVariantEntry."Master Batch No." := lrc_ItemLedgerEntryApplEntry."Master Batch No.";
    //                   lrc_BatchVariantEntry."Batch No." := lrc_ItemLedgerEntryApplEntry."Batch No.";
    //                   lrc_BatchVariantEntry."Batch Variant No." := lrc_ItemLedgerEntryApplEntry."Batch Variant No.";
    //                   lrc_BatchVariantEntry."Document No." := lrc_ItemLedgerEntry."Document No.";
    //                   lrc_BatchVariantEntry."Document Line No." := 0;
    //                   lrc_BatchVariantEntry."Source Doc. Type" := lrc_ItemLedgerEntry."Source Doc. Type";
    //                   lrc_BatchVariantEntry."Source Doc. No." := lrc_ItemLedgerEntry."Source Doc. No.";
    //                   lrc_BatchVariantEntry."Source Doc. Line No." := lrc_ItemLedgerEntry."Source Doc. Line No.";
    //                   //lrc_BatchVariantEntry."Status Customs Duty" :=
    //                   lrc_BatchVariantEntry."Posting Date" := lrc_ItemLedgerEntry."Posting Date";
    //                   lrc_BatchVariantEntry."Item No." := lrc_ItemLedgerEntry."Item No.";
    //                   lrc_BatchVariantEntry."Variant Code" := lrc_ItemLedgerEntry."Variant Code";
    //                   lrc_BatchVariantEntry."Location Code" := lrc_ItemLedgerEntry."Location Code";
    //                   lrc_BatchVariantEntry.Positive := lrc_ItemLedgerEntry.Positive;
    //                   lrc_BatchVariantEntry."Base Unit Of Measure Code" := lrc_ItemLedgerEntry."Base Unit of Measure";
    //                   lrc_BatchVariantEntry."Quantity (Base)" := lrc_ItemApplicationEntry.Quantity;
    //                   lrc_BatchVariantEntry."Invoiced Quantity" := 0;
    //                   lrc_BatchVariantEntry."Unit of Measure Code" := lrc_ItemLedgerEntry."Unit of Measure Code";
    //                   lrc_BatchVariantEntry."Qty. per Unit of Measure" := lrc_ItemLedgerEntry."Qty. per Unit of Measure";
    //                   IF lrc_ItemLedgerEntry."Qty. per Unit of Measure" <> 0 THEN
    //                     lrc_BatchVariantEntry.Quantity := lrc_ItemApplicationEntry.Quantity / lrc_ItemLedgerEntry."Qty. per Unit of Measure";

    //                   lrc_BatchVariantEntry."Qty (Base) (Item Ledger Entry)" := lrc_ItemLedgerEntry.Quantity;

    //                   lrc_BatchVariantEntry."Detail Entry No." := 0;
    //                   lrc_BatchVariantEntry."Detail Line No." := 0;

    //                   lrc_BatchVariantEntry."Item Ledger Entry No." := lrc_ItemLedgerEntry."Entry No.";
    //                   lrc_BatchVariantEntry."Item Ledger Entry Type" := lrc_ItemLedgerEntry."Entry Type";

    //                   lrc_BatchVariantEntry."Applied Item Ledger Entry No." := lrc_ItemLedgerEntryApplEntry."Entry No.";
    //                   lrc_BatchVariantEntry."Applied Item Ledger Entry Type" := lrc_ItemLedgerEntryApplEntry."Entry Type";

    //                   lrc_BatchVariantEntry.Open := FALSE;

    //                   lrc_BatchVariantEntry."Quality Rating" := lrc_ItemLedgerEntry."Quality Rating";
    //                   lrc_BatchVariantEntry."Ship-to Code" := lrc_ItemLedgerEntry."Ship-to/Order Address Code";
    //                   lrc_BatchVariantEntry.INSERT(TRUE);

    //                 UNTIL lrc_ItemApplicationEntry.NEXT() = 0;

    //               END ELSE BEGIN
    //                 MESSAGE('Keine Ausgleichsposten für Verkauf vorhanden!');
    //               END;

    //             END;

    //           END;

    //         // -------------------------------------------------------------------------------------------------------
    //         // Umlagerung
    //         // -------------------------------------------------------------------------------------------------------
    //         lrc_ItemLedgerEntry."Entry Type"::Transfer:
    //           BEGIN

    //             lrc_Location.GET(lrc_ItemLedgerEntry."Location Code");
    //             IF lrc_Location."Use As In-Transit" = TRUE THEN
    //               EXIT;


    //             IF (lrc_ItemLedgerEntry.Positive = FALSE) THEN BEGIN

    //               lrc_ItemLedgerEntry.CALCFIELDS("Quantity (Batch Var. Entry)");
    //               IF lrc_ItemLedgerEntry."Quantity (Batch Var. Entry)" = lrc_ItemLedgerEntry.Quantity THEN BEGIN
    //                 IF vbn_Dialog = TRUE THEN BEGIN
    //                   IF NOT CONFIRM('Menge bereits zugeordnet! Trotzdem?') THEN
    //                     EXIT;
    //                  END;
    //               END;

    //               // Bestehende Posten löschen
    //               lrc_BatchVariantEntry.RESET();
    //               lrc_BatchVariantEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //               lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //               lrc_BatchVariantEntry.DELETEALL();

    //               // Ausgleichsposten lesen
    //               lrc_ItemApplicationEntry.RESET();
    //               lrc_ItemApplicationEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //               lrc_ItemApplicationEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //               IF lrc_ItemApplicationEntry.FIND('-') THEN BEGIN
    //                 REPEAT

    //                   // Posten von dem die Menge abgebucht wurde lesen
    //                   lrc_ItemLedgerEntryApplEntry.GET(lrc_ItemApplicationEntry."Inbound Item Entry No.");

    //                   lrc_BatchVariantEntry.RESET();
    //                   lrc_BatchVariantEntry.INIT();
    //                   lrc_BatchVariantEntry."Entry No." := 0;
    //                   lrc_BatchVariantEntry."Master Batch No." := lrc_ItemLedgerEntryApplEntry."Master Batch No.";
    //                   lrc_BatchVariantEntry."Batch No." := lrc_ItemLedgerEntryApplEntry."Batch No.";
    //                   lrc_BatchVariantEntry."Batch Variant No." := lrc_ItemLedgerEntryApplEntry."Batch Variant No.";
    //                   lrc_BatchVariantEntry."Document No." := lrc_ItemLedgerEntry."Document No.";
    //                   lrc_BatchVariantEntry."Document Line No." := 0;
    //                   lrc_BatchVariantEntry."Source Doc. Type" := lrc_ItemLedgerEntry."Source Doc. Type";
    //                   lrc_BatchVariantEntry."Source Doc. No." := lrc_ItemLedgerEntry."Source Doc. No.";
    //                   lrc_BatchVariantEntry."Source Doc. Line No." := lrc_ItemLedgerEntry."Source Doc. Line No.";
    //                   //lrc_BatchVariantEntry."Status Customs Duty" :=
    //                   lrc_BatchVariantEntry."Posting Date" := lrc_ItemLedgerEntry."Posting Date";
    //                   lrc_BatchVariantEntry."Item No." := lrc_ItemLedgerEntry."Item No.";
    //                   lrc_BatchVariantEntry."Variant Code" := lrc_ItemLedgerEntry."Variant Code";
    //                   lrc_BatchVariantEntry."Location Code" := lrc_ItemLedgerEntry."Location Code";
    //                   lrc_BatchVariantEntry.Positive := lrc_ItemLedgerEntry.Positive;
    //                   lrc_BatchVariantEntry."Base Unit Of Measure Code" := lrc_ItemLedgerEntry."Base Unit of Measure";
    //                   lrc_BatchVariantEntry."Quantity (Base)" := lrc_ItemApplicationEntry.Quantity;
    //                   lrc_BatchVariantEntry."Invoiced Quantity" := 0;
    //                   lrc_BatchVariantEntry."Unit of Measure Code" := lrc_ItemLedgerEntry."Unit of Measure Code";
    //                   lrc_BatchVariantEntry."Qty. per Unit of Measure" := lrc_ItemLedgerEntry."Qty. per Unit of Measure";
    //                   IF lrc_ItemLedgerEntry."Qty. per Unit of Measure" <> 0 THEN
    //                     lrc_BatchVariantEntry.Quantity := lrc_ItemApplicationEntry.Quantity / lrc_ItemLedgerEntry."Qty. per Unit of Measure";

    //                   lrc_BatchVariantEntry."Qty (Base) (Item Ledger Entry)" := lrc_ItemLedgerEntry.Quantity;

    //                   lrc_BatchVariantEntry."Detail Entry No." := 0;
    //                   lrc_BatchVariantEntry."Detail Line No." := 0;

    //                   lrc_BatchVariantEntry."Item Ledger Entry No." := lrc_ItemLedgerEntry."Entry No.";
    //                   lrc_BatchVariantEntry."Item Ledger Entry Type" := lrc_ItemLedgerEntry."Entry Type";

    //                   lrc_BatchVariantEntry."Applied Item Ledger Entry No." := lrc_ItemLedgerEntryApplEntry."Entry No.";
    //                   lrc_BatchVariantEntry."Applied Item Ledger Entry Type" := lrc_ItemLedgerEntryApplEntry."Entry Type";

    //                   lrc_BatchVariantEntry.Open := FALSE;

    //                   // BAB 008 IFW40103.s
    //                   lrc_BatchVariantEntry."Quality Rating" := lrc_ItemLedgerEntry."Quality Rating";
    //                   // BAB 008 IFW40103.e

    //                   // BAB 010 DMG50087.s
    //                   lrc_BatchVariantEntry."Ship-to Code" := lrc_ItemLedgerEntry."Ship-to/Order Address Code";
    //                   // BAB 010 DMG50087.e

    //                   lrc_BatchVariantEntry.INSERT(TRUE);

    //                 UNTIL lrc_ItemApplicationEntry.NEXT() = 0;

    //               END ELSE BEGIN
    //                 // Keine Ausgleichsposten für Umlagerung vorhanden!
    //                 MESSAGE(AGILES_LT_TEXT001);
    //               END;


    //             // ----------------------------------------------------------------------------------------------------------
    //             // Positiver Umlagerungsposten
    //             // ----------------------------------------------------------------------------------------------------------
    //             END ELSE BEGIN

    //               // Suche nach Abgangsumlagerung

    //               lrc_ItemLedgerEntryTransfer.SETCURRENTKEY("Transfer Order No.");
    //               lrc_ItemLedgerEntryTransfer.SETRANGE("Item No.",lrc_ItemLedgerEntry."Item No.");
    //               lrc_ItemLedgerEntryTransfer.SETRANGE("Entry Type",lrc_ItemLedgerEntry."Entry Type");
    //               lrc_ItemLedgerEntryTransfer.SETRANGE("Transfer Order No.",lrc_ItemLedgerEntry."Transfer Order No.");
    //               lrc_ItemLedgerEntryTransfer.SETRANGE("Source Doc. Line No.",lrc_ItemLedgerEntry."Source Doc. Line No.");
    //               lrc_ItemLedgerEntryTransfer.SETRANGE(Positive,FALSE);
    //               lrc_ItemLedgerEntryTransfer.SETFILTER("Location Code",'<>%1',lrc_ItemLedgerEntry."Location Code");
    //               IF lrc_ItemLedgerEntryTransfer.FIND('-') THEN
    //                 REPEAT

    //                   lrc_Location.GET(lrc_ItemLedgerEntryTransfer."Location Code");
    //                   IF (lrc_Location."Use As In-Transit" = FALSE) AND
    //                      (lrc_ItemLedgerEntryTransfer."Location Code" <> lrc_ItemLedgerEntry."Location Code") THEN BEGIN

    //                     IF (lrc_ItemLedgerEntryTransfer.Quantity * -1) <> lrc_ItemLedgerEntry.Quantity THEN
    //                       ERROR('Umlagerungsmenge Abgangsposten nicht identisch mit Zugangsposten aus Umlagerung!');

    //                     // Bestehende Posten löschen
    //                     lrc_BatchVariantEntry.RESET();
    //                     lrc_BatchVariantEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //                     lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //                     lrc_BatchVariantEntry.DELETEALL();

    //                     // Ausgleichsposten des Abgangs auf den Zugang übertragen
    //                     lrc_ItemApplicationEntry.RESET();
    //                     lrc_ItemApplicationEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //                     lrc_ItemApplicationEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntryTransfer."Entry No.");
    //                     IF lrc_ItemApplicationEntry.FIND('-') THEN BEGIN
    //                       REPEAT

    //                         // Posten von dem die Menge abgebucht wurde lesen
    //                         lrc_ItemLedgerEntryApplEntry.GET(lrc_ItemApplicationEntry."Inbound Item Entry No.");

    //                         lrc_BatchVariantEntry.RESET();
    //                         lrc_BatchVariantEntry.INIT();
    //                         lrc_BatchVariantEntry."Entry No." := 0;
    //                         lrc_BatchVariantEntry."Master Batch No." := lrc_ItemLedgerEntryApplEntry."Master Batch No.";
    //                         lrc_BatchVariantEntry."Batch No." := lrc_ItemLedgerEntryApplEntry."Batch No.";
    //                         lrc_BatchVariantEntry."Batch Variant No." := lrc_ItemLedgerEntryApplEntry."Batch Variant No.";
    //                         lrc_BatchVariantEntry."Document No." := lrc_ItemLedgerEntry."Document No.";
    //                         lrc_BatchVariantEntry."Document Line No." := 0;
    //                         lrc_BatchVariantEntry."Source Doc. Type" := lrc_ItemLedgerEntry."Source Doc. Type";
    //                         lrc_BatchVariantEntry."Source Doc. No." := lrc_ItemLedgerEntry."Source Doc. No.";
    //                         lrc_BatchVariantEntry."Source Doc. Line No." := lrc_ItemLedgerEntry."Source Doc. Line No.";
    //                         //lrc_BatchVariantEntry."Status Customs Duty" :=
    //                         lrc_BatchVariantEntry."Posting Date" := lrc_ItemLedgerEntry."Posting Date";
    //                         lrc_BatchVariantEntry."Item No." := lrc_ItemLedgerEntry."Item No.";
    //                         lrc_BatchVariantEntry."Variant Code" := lrc_ItemLedgerEntry."Variant Code";
    //                         lrc_BatchVariantEntry."Location Code" := lrc_ItemLedgerEntry."Location Code";
    //                         lrc_BatchVariantEntry.Positive := lrc_ItemLedgerEntry.Positive;
    //                         lrc_BatchVariantEntry."Base Unit Of Measure Code" := lrc_ItemLedgerEntry."Base Unit of Measure";
    //                         lrc_BatchVariantEntry."Quantity (Base)" := lrc_ItemApplicationEntry.Quantity * -1;
    //                         lrc_BatchVariantEntry."Invoiced Quantity" := 0;
    //                         lrc_BatchVariantEntry."Unit of Measure Code" := lrc_ItemLedgerEntry."Unit of Measure Code";
    //                         lrc_BatchVariantEntry."Qty. per Unit of Measure" := lrc_ItemLedgerEntry."Qty. per Unit of Measure";
    //                         IF lrc_ItemLedgerEntry."Qty. per Unit of Measure" <> 0 THEN
    //                           lrc_BatchVariantEntry.Quantity := lrc_BatchVariantEntry."Quantity (Base)" /
    //                                                             lrc_ItemLedgerEntry."Qty. per Unit of Measure";

    //                         lrc_BatchVariantEntry."Qty (Base) (Item Ledger Entry)" := lrc_ItemLedgerEntry.Quantity;

    //                         lrc_BatchVariantEntry."Detail Entry No." := 0;
    //                         lrc_BatchVariantEntry."Detail Line No." := 0;

    //                         lrc_BatchVariantEntry."Item Ledger Entry No." := lrc_ItemLedgerEntry."Entry No.";
    //                         lrc_BatchVariantEntry."Item Ledger Entry Type" := lrc_ItemLedgerEntry."Entry Type";

    //                         //lrc_BatchVariantEntry."Applied Item Ledger Entry No." := lrc_ItemLedgerEntryApplEntry."Entry No.";
    //                         //lrc_BatchVariantEntry."Applied Item Ledger Entry Type" := lrc_ItemLedgerEntryApplEntry."Entry Type";

    //                         lrc_BatchVariantEntry.Open := FALSE;

    //                         // BAB 008 IFW40103.s
    //                         lrc_BatchVariantEntry."Quality Rating" := lrc_ItemLedgerEntry."Quality Rating";
    //                         // BAB 008 IFW40103.e

    //                         // BAB 010 DMG50087.s
    //                         lrc_BatchVariantEntry."Ship-to Code" := lrc_ItemLedgerEntry."Ship-to/Order Address Code";
    //                         // BAB 010 DMG50087.e

    //                         lrc_BatchVariantEntry.INSERT(TRUE);


    //                       UNTIL lrc_ItemApplicationEntry.NEXT() = 0;
    //                     END ELSE BEGIN
    //                       // Keine Ausgleichsposten bezogene Umlagerung gefunden!
    //                       ERROR(AGILES_LT_TEXT001);
    //                     END;

    //                     EXIT;
    //                   END;

    //                 UNTIL lrc_ItemLedgerEntryApplEntry.NEXT() = 0;

    //             END;
    //           END;
    //         END;
    //     end;

    //     procedure CreateMissingMasterBatch()
    //     var
    //         lrc_ItemLedgerEntry: Record "32";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         //
    //         // ----------------------------------------------------------------------------------------------

    //         IF lrc_ItemLedgerEntry.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             ItemLedgEntryNewMasterBatch(lrc_ItemLedgerEntry."Entry No.");
    //           UNTIL lrc_ItemLedgerEntry.NEXT() = 0;
    //         END;
    //     end;

    //     procedure "-- ASSORTMENT LINE --"()
    //     begin
    //     end;

    //     procedure BatchVarAllAssortmentLines(vco_AssortmentVersionNo: Code[20];vin_AssortmentLineNo: Integer;vbn_Dialog: Boolean)
    //     var
    //         lcu_AssortmentMgt: Codeunit "5110329";
    //         lrc_AssortmentVersion: Record "5110339";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_BatchVariant: Record "5110366";
    //         lco_BatchNo: Code[20];
    //         lco_BatchVarNo: Code[20];
    //         ADF_LT_TEXT001: Label 'Möchten Sie für das Sortiment %1 Pos.-Var. Nummern vergeben?';
    //         ADF_LT_TEXT002: Label 'Möchten Sie für das Sortiment %1 und die Zeile %2 Pos.-Var. Nummern vergeben?';
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         //
    //         // ----------------------------------------------------------------------------------------------

    //         lrc_AssortmentVersion.GET(vco_AssortmentVersionNo);

    //         IF vbn_Dialog = TRUE THEN BEGIN
    //           IF vin_AssortmentLineNo <> 0 THEN BEGIN
    //             // Möchten Sie für das Sortiment %1 Pos.-Var. Nummern vergeben?
    //             IF NOT CONFIRM(ADF_LT_TEXT002,FALSE,lrc_AssortmentVersion."Assortment Code",vin_AssortmentLineNo) THEN
    //               EXIT;
    //           END ELSE BEGIN
    //             // Möchten Sie für das Sortiment %1 Pos.-Var. Nummern vergeben?
    //             IF NOT CONFIRM(ADF_LT_TEXT001,FALSE,lrc_AssortmentVersion."Assortment Code") THEN
    //               EXIT;
    //           END;
    //         END;

    //         lrc_AssortmentVersionLine.RESET();
    //         lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortmentVersion."No.");
    //         IF vin_AssortmentLineNo <> 0 THEN
    //           lrc_AssortmentVersionLine.SETRANGE("Line No.",vin_AssortmentLineNo);
    //         IF lrc_AssortmentVersionLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //           REPEAT
    //             IF lrc_AssortmentVersionLine."Batch Variant No." = '' THEN BEGIN
    //               // Einstandspreis kalkulieren
    //               lcu_AssortmentMgt.AssortLineCalcUnitCost(lrc_AssortmentVersionLine);
    //               lrc_AssortmentVersionLine.MODIFY();

    //               lco_BatchNo := '';
    //               lco_BatchVarNo := '';
    //               BatchVarNewUpdFromAssort(lrc_AssortmentVersionLine,lco_BatchNo,lco_BatchVarNo);
    //               lrc_AssortmentVersionLine."Batch No." := lco_BatchNo;
    //               lrc_AssortmentVersionLine."Batch Variant No." := lco_BatchVarNo;
    //               lrc_AssortmentVersionLine.MODIFY();
    //             END ELSE BEGIN
    //               lrc_BatchVariant.GET(lrc_AssortmentVersionLine."Batch Variant No.");
    //               IF lrc_BatchVariant.Source = lrc_BatchVariant.Source::Assortment THEN BEGIN
    //                 // Einstandspreis kalkulieren
    //                 lcu_AssortmentMgt.AssortLineCalcUnitCost(lrc_AssortmentVersionLine);

    //                 lco_BatchNo := lrc_AssortmentVersionLine."Batch No.";
    //                 lco_BatchVarNo := lrc_AssortmentVersionLine."Batch Variant No.";
    //                 BatchVarNewUpdFromAssort(lrc_AssortmentVersionLine,lco_BatchNo,lco_BatchVarNo);
    //               END;
    //             END;
    //           UNTIL lrc_AssortmentVersionLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure BatchVarNewUpdFromAssort(vrc_AssortmentVersionLine: Record "5110340";var rco_BatchCode: Code[20];var rco_BatchVarCode: Code[20])
    //     var
    //         lcu_NoSeriesManagement: Codeunit "396";
    //         lcu_GlobalFunctionsMgt: Codeunit "5110300";
    //         lcu_BaseDataTemplateMgt: Codeunit "5087929";
    //         lrc_MasterBatchSetup: Record "5110363";
    //         lrc_ADFSetup: Record "5110302";
    //         lrc_MasterBatch: Record "5110364";
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_DimensionValue: Record "349";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_Vendor: Record "Vendor";
    //         lco_BatchCode: Code[20];
    //         lco_BatchVariantCode: Code[20];
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Positionsvariante anlegen und aktualisieren auf Basis einer Sortimentszeile
    //         // ----------------------------------------------------------------------------------------------

    //         IF NOT lrc_Item.GET(vrc_AssortmentVersionLine."Item No.") THEN
    //           EXIT;
    //         IF lrc_Item."Batch Item" = FALSE THEN
    //           EXIT;
    //         IF vrc_AssortmentVersionLine."Unit of Measure Code" = '' THEN
    //           EXIT;



    //         lrc_MasterBatchSetup.GET();
    //         lrc_MasterBatchSetup.TESTFIELD("Assort. Master Batch No.");

    //         // ------------------------------------------------------------------------------
    //         // Position anlegen falls leer
    //         // ------------------------------------------------------------------------------
    //         IF vrc_AssortmentVersionLine."Batch No." = '' THEN BEGIN

    //           lrc_MasterBatchSetup.TESTFIELD("Assort. Batch No. Series");
    //           lco_BatchCode := lcu_NoSeriesManagement.GetNextNo(lrc_MasterBatchSetup."Assort. Batch No. Series",WORKDATE,TRUE);

    //           // Positionssatz anlegen
    //           lrc_Batch.RESET();
    //           lrc_Batch.INIT();
    //           lrc_Batch."No." := lco_BatchCode;
    //           lrc_Batch."Master Batch No." := lrc_MasterBatchSetup."Assort. Master Batch No.";
    //           lrc_Batch.VALIDATE("Vendor No.",vrc_AssortmentVersionLine."Vendor No.");
    //           lrc_Batch.Source := lrc_Batch.Source::Assortment;
    //           lrc_Batch."Source No." := vrc_AssortmentVersionLine."Assortment Version No.";
    //           lrc_Batch.insert();

    //           // Kontrolle auf Dimensionsanlage und Anlage der Position als Dimension
    //           IF lrc_MasterBatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
    //             lrc_DimensionValue.RESET();
    //             lrc_DimensionValue.INIT();
    //             lrc_DimensionValue."Dimension Code" := lrc_MasterBatchSetup."Dim. Code Batch No.";
    //             lrc_DimensionValue.Code := lrc_Batch."No.";
    //             lrc_DimensionValue.Name := 'Position';
    //             lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
    //             lrc_DimensionValue."Global Dimension No." := lrc_MasterBatchSetup."Dim. No. Batch No.";
    //             lrc_DimensionValue.insert();
    //             //RS Anlage Partie als Dimension
    //             lrc_DimensionValue.RESET();
    //             lrc_DimensionValue.INIT();
    //             lrc_DimensionValue."Dimension Code" := 'PARTIE';
    //             lrc_DimensionValue.Code := lrc_Batch."Master Batch No.";
    //             lrc_DimensionValue.Name := lrc_Batch."Master Batch No.";
    //             lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
    //             lrc_DimensionValue.insert();
    //           END;

    //         END ELSE BEGIN
    //           lrc_Batch.GET(rco_BatchCode);
    //         END;

    //         // ------------------------------------------------------------------------------
    //         // Positionsvariante anlegen falls leer
    //         // ------------------------------------------------------------------------------
    //         IF vrc_AssortmentVersionLine."Batch Variant No." = '' THEN BEGIN

    //           // Prüfung ob Artikeleinheit besteht
    //           IF NOT lrc_ItemUnitofMeasure.GET(vrc_AssortmentVersionLine."Item No.",
    //                                            vrc_AssortmentVersionLine."Unit of Measure Code") THEN BEGIN
    //             lrc_UnitofMeasure.GET(vrc_AssortmentVersionLine."Unit of Measure Code");
    //             lrc_UnitofMeasure.TESTFIELD("Qty. (BU) per Unit of Measure");

    //             // Artikeleinheit anlegen
    //             lrc_ItemUnitofMeasure.RESET();
    //             lrc_ItemUnitofMeasure.INIT();
    //             lrc_ItemUnitofMeasure."Item No." := vrc_AssortmentVersionLine."Item No.";
    //             lrc_ItemUnitofMeasure.Code := lrc_UnitofMeasure.Code;
    //             lrc_ItemUnitofMeasure."Qty. per Unit of Measure" := lrc_UnitofMeasure."Qty. (BU) per Unit of Measure";
    //             lrc_ItemUnitofMeasure."Kind of Unit of Measure" := lrc_UnitofMeasure."Kind of Unit of Measure";
    //             lrc_ItemUnitofMeasure."Gross Weight" := lrc_UnitofMeasure."Gross Weight";
    //             lrc_ItemUnitofMeasure."Net Weight" := lrc_UnitofMeasure."Net Weight";
    //             lrc_ItemUnitofMeasure."Weight of Packaging" := lrc_UnitofMeasure."Weight of Packaging";
    //             lrc_ItemUnitofMeasure.insert();
    //           END;

    //           // Postfixzähler ermitteln
    //           lrc_Batch.GET(lco_BatchCode);
    //           lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
    //           lrc_Batch.MODIFY();

    //           lco_BatchVariantCode := lco_BatchCode + lrc_MasterBatchSetup."Assort. Batch Var. Separator" +
    //                                   lcu_GlobalFunctionsMgt.FormatIntegerWithBeginningZero(
    //                                   lrc_Batch."Batch Variant Postfix Counter",
    //                                   lrc_MasterBatchSetup."Assort. Batch V. PostfixPlaces");

    //           // Positionsvariantensatz anlegen
    //           lrc_BatchVariant.RESET();
    //           lrc_BatchVariant.INIT();
    //           lrc_BatchVariant."No." := lco_BatchVariantCode;
    //           lrc_BatchVariant."Master Batch No." := lrc_MasterBatchSetup."Assort. Master Batch No.";
    //           lrc_BatchVariant."Batch No." := lco_BatchCode;
    //           lrc_BatchVariant.Source := lrc_BatchVariant.Source::Assortment;
    //           lrc_BatchVariant.INSERT(TRUE);
    //           COMMIT;

    //         END ELSE BEGIN
    //           lrc_BatchVariant.GET(vrc_AssortmentVersionLine."Batch Variant No.");
    //           IF lrc_BatchVariant.Source <> lrc_BatchVariant.Source::Assortment THEN
    //             EXIT;
    //         END;


    //         // --------------------------------------------------------------------
    //         // Positionsvariante aktualisieren
    //         // --------------------------------------------------------------------
    //         lrc_BatchVariant."Item No." := vrc_AssortmentVersionLine."Item No.";
    //         lrc_BatchVariant."Variant Code" := vrc_AssortmentVersionLine."Variant Code";
    //         lrc_BatchVariant.Description := vrc_AssortmentVersionLine."Item Description";
    //         lrc_BatchVariant."Description 2" := vrc_AssortmentVersionLine."Item Description 2";

    //         lrc_BatchVariant."Item Main Category Code" := lrc_Item."Item Main Category Code";
    //         lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
    //         lrc_BatchVariant."Product Group Code" := lrc_Item."Product Group Code";

    //         lrc_BatchVariant."Base Unit of Measure (BU)" := vrc_AssortmentVersionLine."Base Unit of Measure (BU)";
    //         lrc_BatchVariant."Unit of Measure Code" := vrc_AssortmentVersionLine."Unit of Measure Code";
    //         lrc_BatchVariant."Qty. per Unit of Measure" := vrc_AssortmentVersionLine."Qty. per Unit of Measure";
    //         lrc_BatchVariant."Content Unit of Measure (CP)" := vrc_AssortmentVersionLine."Content Unit of Measure (CP)";
    //         lrc_BatchVariant."Packing Unit of Measure (PU)" := vrc_AssortmentVersionLine."Packing Unit of Measure (PU)";
    //         lrc_BatchVariant."Qty. (PU) per Collo (CU)" := vrc_AssortmentVersionLine."Qty. PU per CU";
    //         lrc_BatchVariant."Transport Unit of Measure (TU)" := vrc_AssortmentVersionLine."Transport Unit of Measure (TU)";
    //         lrc_BatchVariant."Qty. (Unit) per Transp. (TU)" := vrc_AssortmentVersionLine."Qty. Unit per TU";
    //         lrc_BatchVariant."No. of Layers on TU" := vrc_AssortmentVersionLine."No. of Layers on TU";

    //         lrc_BatchVariant."Price Base (Purch. Price)" := vrc_AssortmentVersionLine."Price Base (Purch. Price)";
    //         lrc_BatchVariant."Purch. Price (Price Base)" := vrc_AssortmentVersionLine."Purch. Price (Price Base)";
    //         lrc_BatchVariant."Market Unit Cost (Base) (LCY)" := 0;
    //         lrc_BatchVariant."Price Base (Sales Price)" := vrc_AssortmentVersionLine."Price Base (Sales Price)";
    //         lrc_BatchVariant."Sales Price (Price Base)" := vrc_AssortmentVersionLine."Sales Price (Price Base)";

    //         lrc_BatchVariant."Purch. Price (UOM) (LCY)" := vrc_AssortmentVersionLine."Direct Unit Cost (LCY)";
    //         lrc_BatchVariant."Purch. Price Net (UOM) (LCY)" := vrc_AssortmentVersionLine."Direct Unit Cost (LCY)";
    //         lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := vrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)";
    //         lrc_BatchVariant."Indirect Cost Amount" := vrc_AssortmentVersionLine."Indirect Cost Amt (Unit) (LCY)";
    //         lrc_BatchVariant."Unit Cost (UOM) (LCY)" := vrc_AssortmentVersionLine."Unit Cost (LCY)";

    //         lrc_BatchVariant."Vendor No." := vrc_AssortmentVersionLine."Vendor No.";
    //         IF lrc_Vendor.GET(vrc_AssortmentVersionLine."Vendor No.") THEN
    //           lrc_BatchVariant."Vendor Search Name" := lrc_Vendor."Search Name";
    //         lrc_BatchVariant."Producer No." := vrc_AssortmentVersionLine."Manufacturer No.";

    //         lrc_BatchVariant."Country of Origin Code" := vrc_AssortmentVersionLine."Country of Origin Code";
    //         lrc_BatchVariant."Variety Code" := vrc_AssortmentVersionLine."Variety Code";
    //         lrc_BatchVariant."Trademark Code" := vrc_AssortmentVersionLine."Trademark Code";
    //         lrc_BatchVariant."Caliber Code" := vrc_AssortmentVersionLine."Caliber Code";
    //         lrc_BatchVariant."Vendor Caliber Code" := vrc_AssortmentVersionLine."Vendor Caliber Code";
    //         lrc_BatchVariant."Item Attribute 3" := vrc_AssortmentVersionLine."Item Attribute 3";
    //         lrc_BatchVariant."Item Attribute 2" := vrc_AssortmentVersionLine."Item Attribute 2";
    //         lrc_BatchVariant."Grade of Goods Code" := vrc_AssortmentVersionLine."Grade of Goods Code";
    //         lrc_BatchVariant."Item Attribute 7" := vrc_AssortmentVersionLine."Item Attribute 7";
    //         lrc_BatchVariant."Item Attribute 5" := vrc_AssortmentVersionLine."Item Attribute 5";
    //         lrc_BatchVariant."Item Attribute 6" := vrc_AssortmentVersionLine."Item Attribute 6";
    //         lrc_BatchVariant."Item Attribute 4" := vrc_AssortmentVersionLine."Item Attribute 4";
    //         lrc_BatchVariant."Coding Code" := vrc_AssortmentVersionLine."Coding Code";
    //         lrc_BatchVariant."Cultivation Association Code" := vrc_AssortmentVersionLine."Cultivation Association Code";
    //         lrc_BatchVariant."Item Attribute 1" := vrc_AssortmentVersionLine."Item Attribute 1";
    //         lrc_BatchVariant."Cultivation Type" := vrc_AssortmentVersionLine."Cultivation Type";

    //         lrc_BatchVariant."Net Weight" := vrc_AssortmentVersionLine."Net Weight";
    //         lrc_BatchVariant."Gross Weight" := vrc_AssortmentVersionLine."Gross Weight";
    //         lrc_BatchVariant."Average Customs Weight" := 0;

    //         lrc_BatchVariant."Original Quantity" := 0;

    //         IF vrc_AssortmentVersionLine."Starting Date Assortment" <> 0D THEN BEGIN
    //           lrc_BatchVariant."Departure Date" := vrc_AssortmentVersionLine."Starting Date Assortment" - 1;
    //           lrc_BatchVariant."Order Date" := vrc_AssortmentVersionLine."Starting Date Assortment" - 1;
    //           lrc_BatchVariant."Date of Delivery" := vrc_AssortmentVersionLine."Starting Date Assortment";
    //         END;
    //         lrc_BatchVariant."Date of Expiry" := 0D;

    //         lrc_BatchVariant."Kind of Settlement" := lrc_BatchVariant."Kind of Settlement"::"Fix Price";
    //         lrc_BatchVariant.Weight := vrc_AssortmentVersionLine.Weight;
    //         lrc_BatchVariant."Lot No. Producer" := '';

    //         lrc_BatchVariant."Entry Location Code" := vrc_AssortmentVersionLine."Entry Location Code";
    //         lrc_BatchVariant."Location Reference No." := '';
    //         lrc_BatchVariant."Shelf No." := '';

    //         lrc_BatchVariant."Info 1" := vrc_AssortmentVersionLine."Info 1";
    //         lrc_BatchVariant."Info 2" := vrc_AssortmentVersionLine."Info 2";
    //         lrc_BatchVariant."Info 3" := vrc_AssortmentVersionLine."Info 3";
    //         lrc_BatchVariant."Info 4" := vrc_AssortmentVersionLine."Info 4";

    //         lrc_BatchVariant."Kind of Loading" := lrc_BatchVariant."Kind of Loading"::" ";
    //         lrc_BatchVariant."Fiscal Agent Code" := '';

    //         lrc_BatchVariant."Voyage No." := '';
    //         lrc_BatchVariant."Container No." := '';
    //         lrc_BatchVariant."Means of Transport Type" := lrc_BatchVariant."Means of Transport Type"::Truck;
    //         lrc_BatchVariant."Means of Transp. Code (Depart)" := '';
    //         lrc_BatchVariant."Means of Transp. Code (Arriva)" := '';
    //         lrc_BatchVariant."Means of Transport Info" := '';
    //         lrc_BatchVariant."Port of Discharge Code" := '';
    //         lrc_BatchVariant."Date of Discharge" := 0D;
    //         lrc_BatchVariant."Time of Discharge" := 0T;
    //         lrc_BatchVariant."Waste Disposal Duty" := lrc_BatchVariant."Waste Disposal Duty"::" ";
    //         lrc_BatchVariant."Waste Disposal Payment By" := lrc_BatchVariant."Waste Disposal Payment By"::Vendor;
    //         lrc_BatchVariant."Status Customs Duty" := lrc_BatchVariant."Status Customs Duty"::Verzollt;

    //         lrc_BatchVariant."Empties Item No." := vrc_AssortmentVersionLine."Empties Item No.";
    //         lrc_BatchVariant."Empties Quantity" := 1;

    //         lrc_BatchVariant."Company Season Code" := '';

    //         lrc_BatchVariant.Source := lrc_BatchVariant.Source::Assortment;
    //         lrc_BatchVariant."Source No." := vrc_AssortmentVersionLine."Assortment Version No.";
    //         lrc_BatchVariant."Source Line No." := vrc_AssortmentVersionLine."Line No.";
    //         lrc_BatchVariant."Source Company" := COMPANYNAME;

    //         lrc_ADFSetup.GET();
    //         IF lrc_ADFSetup."Create Search No from BatchVar" = TRUE THEN BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item,lrc_BatchVariant);
    //         END ELSE BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);
    //         END;

    //         lrc_BatchVariant."B/L Shipper" := '';
    //         lrc_BatchVariant.State := lrc_BatchVariant.State::Open;

    //         lrc_BatchVariant."Purch. Doc. Subtype Code" := '';
    //         lrc_BatchVariant."Shortcut Dimension 1 Code" := '';
    //         lrc_BatchVariant."Shortcut Dimension 2 Code" := '';
    //         lrc_BatchVariant."Shortcut Dimension 3 Code" := '';
    //         lrc_BatchVariant."Shortcut Dimension 4 Code" := '';

    //         lrc_BatchVariant.MODIFY();


    //         // Rückgabewerte setzen
    //         rco_BatchCode := lco_BatchCode;
    //         rco_BatchVarCode := lco_BatchVariantCode;
    //     end;

    //     procedure "----"()
    //     begin
    //     end;

    //     procedure AllBatchVarCalcState()
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung des Status für alle Pos.-Var.
    //         // -----------------------------------------------------------------------------------------

    //         IF lrc_BatchVariant.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             BatchVarCalcState(lrc_BatchVariant."No.");
    //           UNTIL lrc_BatchVariant.NEXT() = 0;
    //         END;
    //     end;

    //     procedure BatchVarCalcState(vco_BatchVarNo: Code[20])
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung des Status
    //         // -----------------------------------------------------------------------------------------

    //         lrc_BatchVariant.GET(vco_BatchVarNo);

    //         CASE lrc_BatchVariant.Source OF
    //         lrc_BatchVariant.Source::" ":
    //           BEGIN
    //             lrc_BatchVariant.State := lrc_BatchVariant.State::Closed;
    //             lrc_BatchVariant.MODIFY();
    //           END;

    //         lrc_BatchVariant.Source::"Purch. Order":
    //           BEGIN
    //             lrc_BatchVariant.CALCFIELDS("B.V. Purch. Rec. (Qty)","B.V. Sales Shipped (Qty)","B.V. Inventory (Qty.)",
    //                                         "B.V. Sales Order (Qty)","B.V. Purch. Order (Qty)");
    //             IF lrc_BatchVariant."B.V. Inventory (Qty.)" <> 0 THEN BEGIN
    //               lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
    //               lrc_BatchVariant.MODIFY();
    //             END ELSE BEGIN
    //               // FTW 001 00000000.s
    //               // Prüfung auf gebuchten Ver- und Einkauf entfernt, da es auch sein kann, dass die gesamte Einkaufsmenge
    //               // wieder gutschrieben wurde, ohne dass es zu einem Verkauf kam.
    //               //IF (lrc_BatchVariant."B.V. Purch. Rec. (Qty)" <> 0) AND
    //               //   (lrc_BatchVariant."B.V. Sales Shipped (Qty)" <> 0) AND
    //               IF (lrc_BatchVariant."B.V. Purch. Rec. (Qty)" = (lrc_BatchVariant."B.V. Sales Shipped (Qty)" * -1)) AND
    //               // FTW 001 00000000.e
    //                  (lrc_BatchVariant."B.V. Sales Order (Qty)" = 0) AND
    //                  (lrc_BatchVariant."B.V. Purch. Order (Qty)" = 0) THEN BEGIN
    //                 lrc_BatchVariant.State := lrc_BatchVariant.State::Closed;
    //                 lrc_BatchVariant.MODIFY();
    //               END ELSE BEGIN
    //                 lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
    //                 lrc_BatchVariant.MODIFY();
    //               END;
    //             END;
    //           END;

    //         lrc_BatchVariant.Source::Assortment:
    //           BEGIN
    //             lrc_AssortmentVersionLine.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //             IF lrc_AssortmentVersionLine.FINDFIRST() THEN BEGIN
    //               IF lrc_AssortmentVersionLine."Ending Date Assortment" >= TODAY THEN BEGIN
    //                 lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
    //                 lrc_BatchVariant.MODIFY();
    //               END ELSE BEGIN
    //                 lrc_BatchVariant.CALCFIELDS("B.V. Sales Order (Qty)");
    //                 IF lrc_BatchVariant."B.V. Sales Order (Qty)" = 0 THEN BEGIN
    //                   lrc_BatchVariant.State := lrc_BatchVariant.State::Closed;
    //                   lrc_BatchVariant.MODIFY();
    //                 END ELSE BEGIN
    //                   lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
    //                   lrc_BatchVariant.MODIFY();
    //                 END;
    //               END;
    //             END;
    //           END;

    //         lrc_BatchVariant.Source::Dummy:
    //           BEGIN
    //             lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
    //             lrc_BatchVariant.MODIFY();
    //           END;
    //         END;
    //     end;

    //     procedure "---ITEM RETURN---"()
    //     begin
    //     end;

    //     procedure ReturnOrderCreateBatchVar(var vrc_SalesCrMemoLine: Record "37")
    //     var
    //         lrc_ItemJournalLine: Record "83";
    //         lrc_ItemJournalLine2: Record "83";
    //         lco_MasterBatchNo: Code[20];
    //         lco_BatchNo: Code[20];
    //         lin_BatchVariantCounter: Integer;
    //         lin_MaxBatchVariantCounter: Integer;
    //         lrc_BatchSetup: Record "5110363";
    //         lco_AktMasterBatchNo: Code[20];
    //         lco_AktBatchNo: Code[20];
    //         lco_AktBatchVariantNo: Code[20];
    //         lrc_SalesCrMemoLine: Record "37";
    //     begin
    //         // -------------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------------

    //         IF CONFIRM('Wollen sie eine neue Positionsnummer vegeben?',FALSE) THEN BEGIN

    //         lrc_BatchSetup.GET();
    //         lrc_BatchSetup.TESTFIELD("IJnlLi Master Batch No. Series");

    //         lin_BatchVariantCounter := 1;
    //         lin_MaxBatchVariantCounter := 0;

    //         lco_MasterBatchNo := '';
    //         lco_BatchNo := '';

    //         IF (vrc_SalesCrMemoLine.Type = vrc_SalesCrMemoLine.Type::Item) AND (vrc_SalesCrMemoLine."No." <> '') THEN BEGIN

    //           IF (vrc_SalesCrMemoLine.Quantity <> 0) AND
    //             (vrc_SalesCrMemoLine."Master Batch No." = '') AND
    //             (vrc_SalesCrMemoLine."Batch No." = '') AND
    //             (vrc_SalesCrMemoLine."Batch Variant No." = '') THEN BEGIN

    //                        // Partienummer vergeben
    //                        ReturnOrderNewMasterBatch(lco_AktMasterBatchNo);
    //                        vrc_SalesCrMemoLine."Master Batch No." := lco_AktMasterBatchNo;

    //                        IF lrc_BatchSetup."IJnlLi Allocation Batch No." =
    //                           lrc_BatchSetup."IJnlLi Allocation Batch No."::"New Batch No. per Line" THEN BEGIN
    //                           lco_AktBatchNo := '';
    //                        END;

    //                        // Positionsnr vergeben
    //                        ReturnOrderNewBatch(vrc_SalesCrMemoLine, lco_BatchNo, lco_AktBatchNo);
    //                        vrc_SalesCrMemoLine."Batch No." := lco_AktBatchNo;

    //                        // Positionsvariantennr vergeben
    //                        ReturnOrderNewBatchVar(vrc_SalesCrMemoLine, lco_BatchNo, lco_AktBatchVariantNo);
    //                        // Positionsnummer ggfls. geändert durch Erreichen des Postfix - Endes
    //                        lco_AktBatchNo := lco_BatchNo;

    //                        //IF lrc_SalesCrMemoLine.GET(vrc_SalesCrMemoLine."Document Type",
    //                        //                           vrc_SalesCrMemoLine."Document No.",
    //                        //                           vrc_SalesCrMemoLine."Line No.") THEN BEGIN
    //                        vrc_SalesCrMemoLine."Batch No." := lco_BatchNo;
    //                        vrc_SalesCrMemoLine."Batch Variant No." := lco_AktBatchVariantNo;
    //                        vrc_SalesCrMemoLine.MODIFY( TRUE);

    //                        lco_MasterBatchNo := lrc_SalesCrMemoLine."Master Batch No.";
    //                        lco_BatchNo := lrc_SalesCrMemoLine."Batch No.";
    //                        //END;
    //                    END;
    //                  END;
    //         END;
    //     end;

    //     procedure ReturnOrderNewMasterBatch(var rco_MasterBatchCodeReturn: Code[20])
    //     var
    //         NoSeriesManagement: Codeunit "396";
    //         BatchSetup: Record "5110363";
    //         MasterBatch: Record "5110364";
    //         TEXT000: Label 'Vergabe Partienr. fehlgeschlagen!';
    //         lco_MasterBatchCode: Code[20];
    //         TEXT001: Label 'Vergabe Positionsnr. fehlgeschlagen!';
    //         lrc_DimensionValue: Record "349";
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Anlage einer neuen Partie über Artikelbuchblattzeile
    //         // ------------------------------------------------------------------------------------------

    //         // Einrichtung lesen
    //         BatchSetup.GET();

    //         // Kontrolle ob Partiewesen aktiv ist
    //         IF BatchSetup."Batchsystem activ" = FALSE THEN BEGIN
    //           rco_MasterBatchCodeReturn := '';
    //           EXIT;
    //         END;


    //         CASE BatchSetup."IJnlLi Allocation Master Batch" OF
    //           BatchSetup."IJnlLi Allocation Master Batch"::"One Master Batch No per Journal Batch Name":
    //             BEGIN
    //               // Kontrolle ob Partie Code bereits vorhanden
    //               //IF rco_MasterBatchCode <> '' THEN BEGIN
    //               //  rco_MasterBatchCodeReturn := rco_MasterBatchCode;
    //                 EXIT;
    //               //END;
    //             END;
    //           BatchSetup."IJnlLi Allocation Master Batch"::"New Master Batch No. per Line":
    //             BEGIN
    //             END;
    //         END;

    //         // --------------------------------------------------------------------------
    //         // Vergabe über Setup Einrichtung
    //         // --------------------------------------------------------------------------
    //         BEGIN
    //           BatchSetup.TESTFIELD("IJnlLi Master Batch No. Series");
    //           lco_MasterBatchCode := NoSeriesManagement.GetNextNo(BatchSetup."IJnlLi Master Batch No. Series",WORKDATE,TRUE);
    //         END;

    //         IF lco_MasterBatchCode = '' THEN
    //           // Vergabe Partienr. fehlgeschlagen!
    //           ERROR(TEXT000);

    //         // ---------------------------------------------------------------------------
    //         // Datensatz Master Batch anlegen
    //         // ---------------------------------------------------------------------------
    //         MasterBatch.RESET();
    //         MasterBatch.INIT();
    //         MasterBatch."No." := lco_MasterBatchCode;
    //         MasterBatch.Source := MasterBatch.Source::"Inventory Journal Line";

    //         MasterBatch.insert();

    //         //RS Anlage Partie als Dimension
    //         lrc_DimensionValue.SETRANGE("Dimension Code", 'PARTIE');
    //         lrc_DimensionValue.SETRANGE(Code, lco_MasterBatchCode);
    //         IF NOT lrc_DimensionValue.FINDSET(FALSE, FALSE) THEN BEGIN
    //           lrc_DimensionValue.INIT();
    //           lrc_DimensionValue."Dimension Code" := 'PARTIE';
    //           lrc_DimensionValue.Code := lco_MasterBatchCode;
    //           lrc_DimensionValue.Name := lco_MasterBatchCode;
    //           lrc_DimensionValue.insert();
    //         END;

    //         // Rückgabewerte setzen
    //         rco_MasterBatchCodeReturn := MasterBatch."No.";
    //     end;

    //     procedure ReturnOrderNewBatch(vrc_SalesCrMemoLine: Record "37";rco_BatchNo: Code[20];var rco_BatchNoReturn: Code[20])
    //     var
    //         NoSeriesManagement: Codeunit "396";
    //         lrc_MasterBatch: Record "5110364";
    //         BatchSetup: Record "5110363";
    //         Batch: Record "5110365";
    //         DimensionValue: Record "349";
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Anlage einer neuen Position aus der Artikelbuchblattzeile
    //         // ----------------------------------------------------------------------------------------

    //         IF rco_BatchNoReturn <> '' THEN
    //           EXIT;

    //         BatchSetup.GET();
    //         IF BatchSetup."Batchsystem activ" = FALSE THEN
    //           EXIT;

    //         IF BatchSetup."IJnlLi Allocation Batch No." =
    //            BatchSetup."IJnlLi Allocation Batch No."::"One Batch No per Journal Batch Name" THEN BEGIN
    //           IF rco_BatchNo = '' THEN BEGIN
    //               CASE BatchSetup."IJnlLi Source Batch No." OF
    //                 BatchSetup."IJnlLi Source Batch No."::"No. Series":
    //                    BEGIN
    //                       BatchSetup.TESTFIELD("IJnlLi Batch No. Series");
    //                       rco_BatchNoReturn := NoSeriesManagement.GetNextNo(BatchSetup."IJnlLi Batch No. Series",WORKDATE,TRUE);
    //                    END;
    //                 BatchSetup."IJnlLi Source Batch No."::"Master Batch No.":
    //                    BEGIN
    //                       vrc_SalesCrMemoLine.TESTFIELD("Master Batch No.");
    //                       rco_BatchNoReturn := vrc_SalesCrMemoLine."Master Batch No.";
    //                    END;

    //                 BatchSetup."IJnlLi Source Batch No."::"Master Batch No. + Postfix":
    //                     BEGIN

    //                       vrc_SalesCrMemoLine.TESTFIELD("Master Batch No.");

    //                       // Postfixzähler ermitteln
    //                       lrc_MasterBatch.GET(vrc_SalesCrMemoLine."Master Batch No.");
    //                       lrc_MasterBatch."Batch Postfix Counter" := lrc_MasterBatch."Batch Postfix Counter" + 1;
    //                       lrc_MasterBatch.MODIFY();

    //                       rco_BatchNoReturn := lrc_MasterBatch."No." +
    //                                            BatchSetup."Batch Separator" +
    //                                            lcu_GlobalFunctions.FormatIntegerWithBeginningZero(
    //                                            lrc_MasterBatch."Batch Postfix Counter",
    //                                            BatchSetup."Batch Postfix Places");

    //                     END;
    //                 END;

    //           END ELSE BEGIN
    //             rco_BatchNoReturn := rco_BatchNo;
    //             EXIT;
    //           END;
    //         END ELSE BEGIN
    //            CASE BatchSetup."IJnlLi Source Batch No." OF
    //              BatchSetup."IJnlLi Source Batch No."::"No. Series":
    //                 BEGIN
    //                    BatchSetup.TESTFIELD("IJnlLi Batch No. Series");
    //                    rco_BatchNoReturn := NoSeriesManagement.GetNextNo(BatchSetup."IJnlLi Batch No. Series",WORKDATE,TRUE);
    //                 END;
    //              BatchSetup."IJnlLi Source Batch No."::"Master Batch No.":
    //                 BEGIN
    //                    vrc_SalesCrMemoLine.TESTFIELD("Master Batch No.");
    //                    rco_BatchNoReturn := vrc_SalesCrMemoLine."Master Batch No.";
    //                 END;

    //              BatchSetup."IJnlLi Source Batch No."::"Master Batch No. + Postfix":
    //                 BEGIN
    //                    vrc_SalesCrMemoLine.TESTFIELD("Master Batch No.");

    //                    // Postfixzähler ermitteln
    //                    lrc_MasterBatch.GET(vrc_SalesCrMemoLine."Master Batch No.");
    //                    lrc_MasterBatch."Batch Postfix Counter" := lrc_MasterBatch."Batch Postfix Counter" + 1;
    //                    lrc_MasterBatch.MODIFY();

    //                    rco_BatchNoReturn := lrc_MasterBatch."No." +
    //                                         BatchSetup."Batch Separator" +
    //                                         lcu_GlobalFunctions.FormatIntegerWithBeginningZero(
    //                                         lrc_MasterBatch."Batch Postfix Counter",
    //                                         BatchSetup."Batch Postfix Places");

    //                  END;
    //              END;
    //         END;

    //         IF rco_BatchNoReturn = '' THEN
    //           ERROR('Positionsnr. konnte nicht ermittelt werden!');

    //         // Positionsdatensatz anlegen
    //         Batch.RESET();
    //         Batch.INIT();
    //         Batch."No." := rco_BatchNoReturn;
    //         Batch."Master Batch No." := vrc_SalesCrMemoLine."Master Batch No.";
    //         Batch.Source := Batch.Source::"Inventory Journal Line";
    //         Batch."Kind of Settlement" := 0;

    //         // FV4 014 00000000.s
    //         Batch."Shortcut Dimension 1 Code" := vrc_SalesCrMemoLine."Shortcut Dimension 1 Code";
    //         Batch."Shortcut Dimension 2 Code" := vrc_SalesCrMemoLine."Shortcut Dimension 2 Code";
    //         Batch."Shortcut Dimension 3 Code" := vrc_SalesCrMemoLine."Shortcut Dimension 3 Code";
    //         Batch."Shortcut Dimension 4 Code" := vrc_SalesCrMemoLine."Shortcut Dimension 4 Code";
    //         // FV4 014 00000000.e

    //         Batch.insert();

    //         // Kontrolle auf Dimensionsanlage und Anlage der Partie als Dimension
    //         IF BatchSetup."Dim. Code Batch No." <> '' THEN BEGIN
    //           DimensionValue.RESET();
    //           DimensionValue.INIT();
    //           DimensionValue."Dimension Code" := BatchSetup."Dim. Code Batch No.";
    //           DimensionValue.Code := Batch."No.";
    //           DimensionValue.Name := 'Position';
    //           DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
    //           DimensionValue."Global Dimension No." := BatchSetup."Dim. No. Batch No.";
    //           DimensionValue.insert();
    //           //RS Anlage Partie als Dimension
    //           IF NOT DimensionValue.GET('PARTIE', Batch."Master Batch No.") THEN BEGIN
    //             DimensionValue.RESET();
    //             DimensionValue.INIT();
    //             DimensionValue."Dimension Code" := 'PARTIE';
    //             DimensionValue.Code := Batch."Master Batch No.";
    //             DimensionValue.Name := Batch."Master Batch No.";
    //             DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
    //             DimensionValue.insert();
    //           END;
    //         END;

    //         // Rückgabewert setzen
    //         rco_BatchNoReturn := Batch."No.";
    //     end;

    //     procedure ReturnOrderNewBatchVar(vrc_SalesCrMemoLine: Record "37";var rco_BatchCode: Code[20];var rco_BatchVariantCode: Code[20])
    //     var
    //         BatchManagement: Codeunit "5110307";
    //         GlobalFunctions: Codeunit "5110300";
    //         lcu_BaseDataTemplateMgt: Codeunit "5087929";
    //         NoSeriesManagement: Codeunit "396";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_ItemUnitOfMeasure: Record "5404";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_PriceCalculation: Record "5110320";
    //         lco_BatchCode: Code[20];
    //         BatchVariantCode: Code[20];
    //         TEXT001: Label 'Positionsnummer konnte nicht ermittelt werden!';
    //         TEXT003: Label 'Positionsvariantennr. konnte nicht generiert werden!';
    //         lin_MaxWert: Integer;
    //         lco_AktBatchCode: Code[20];
    //         lbn_ChangeBack: Boolean;
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // ----------------------------------------------------------------------
    //         // Anlage einer neuen Positionsvariante aus Artikelbuchblattzeile
    //         // ----------------------------------------------------------------------

    //         // Kontrolle ob Artikel und Artikelnummer oder Batchvariante
    //         IF (vrc_SalesCrMemoLine."No." = '') OR
    //            (vrc_SalesCrMemoLine."Batch Variant No." <> '') THEN
    //           EXIT;

    //         // Artikel lesen und Kontrolle ob Artikel Batchgeführt ist
    //         lrc_Item.GET(vrc_SalesCrMemoLine."No.");
    //         IF lrc_Item."Batch Item" = FALSE THEN
    //           EXIT;

    //         lrc_BatchSetup.GET();

    //         // Kontrolle ob Partienummer vergeben wurde
    //         vrc_SalesCrMemoLine.TESTFIELD("Master Batch No.");
    //         vrc_SalesCrMemoLine.TESTFIELD("Batch No.");

    //         lco_BatchCode := vrc_SalesCrMemoLine."Batch No.";

    //         CASE
    //            lrc_BatchSetup."IJnlLi Source Batch Variant" OF
    //            lrc_BatchSetup."IJnlLi Source Batch Variant"::"No. Series":
    //              BEGIN
    //                lrc_BatchSetup.TESTFIELD("IJnlLi Batch Variant No Series");
    //                BatchVariantCode:= NoSeriesManagement.GetNextNo(lrc_BatchSetup."IJnlLi Batch Variant No Series",WORKDATE,TRUE);
    //              END;
    //            lrc_BatchSetup."IJnlLi Source Batch Variant"::"Batch No.":
    //              BEGIN
    //                BatchVariantCode := vrc_SalesCrMemoLine."Batch No.";
    //              END;
    //            lrc_BatchSetup."IJnlLi Source Batch Variant"::"Batch No. + Postfix":
    //              BEGIN
    //                // Postfixzähler ermitteln
    //                lrc_Batch.GET(lco_BatchCode);

    //                CASE
    //                  lrc_BatchSetup."Batch Variant Postfix Places" OF
    //                    1: lin_MaxWert := 8;
    //                    2: lin_MaxWert := 98;
    //                    3: lin_MaxWert := 998;
    //                    4: lin_MaxWert := 9998;
    //                    5: lin_MaxWert := 99998;
    //                END;

    //                IF lrc_Batch."Batch Variant Postfix Counter" <= lin_MaxWert THEN BEGIN
    //                   lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
    //                   lrc_Batch.MODIFY();
    //                END ELSE BEGIN
    //                   // neue Positionsnr vergeben
    //                   lco_AktBatchCode := '';
    //                   lbn_ChangeBack := FALSE;

    //                   IF lrc_BatchSetup."IJnlLi Allocation Batch No." =
    //                      lrc_BatchSetup."IJnlLi Allocation Batch No."::"One Batch No per Journal Batch Name" THEN BEGIN
    //                      lrc_BatchSetup."IJnlLi Allocation Batch No." :=
    //                         lrc_BatchSetup."IJnlLi Allocation Batch No."::"New Batch No. per Line";
    //                      lbn_ChangeBack := TRUE;
    //                      lrc_BatchSetup.MODIFY();
    //                   END;

    //                   ReturnOrderNewBatch(  vrc_SalesCrMemoLine, lco_BatchCode, lco_AktBatchCode);
    //                   lco_BatchCode := lco_AktBatchCode;

    //                   IF lbn_ChangeBack = TRUE THEN BEGIN
    //                      lrc_BatchSetup."IJnlLi Allocation Batch No." :=
    //                         lrc_BatchSetup."IJnlLi Allocation Batch No."::"One Batch No per Journal Batch Name";
    //                      lrc_BatchSetup.MODIFY();
    //                   END;
    //                   lrc_Batch.GET(lco_BatchCode);
    //                   lrc_Batch."Batch Variant Postfix Counter" := lrc_Batch."Batch Variant Postfix Counter" + 1;
    //                   lrc_Batch.MODIFY();
    //                 END;

    //                 BatchVariantCode := lco_BatchCode + lrc_BatchSetup."Batch Variant Separator" +
    //                                     GlobalFunctions.FormatIntegerWithBeginningZero(
    //                                                 lrc_Batch."Batch Variant Postfix Counter",
    //                                                 lrc_BatchSetup."Batch Variant Postfix Places");
    //              END;
    //         END;

    //         IF BatchVariantCode = '' THEN
    //           // Positionsvariantennr. konnte nicht generiert werden!
    //           ERROR(TEXT003);

    //         SetBatchStatusOpen(lco_BatchCode);

    //         // --------------------------------------------------------------------
    //         // Positionsvariante anlegen
    //         // --------------------------------------------------------------------
    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.INIT();
    //         lrc_BatchVariant."No." := BatchVariantCode;
    //         lrc_BatchVariant."Master Batch No." := vrc_SalesCrMemoLine."Master Batch No.";
    //         lrc_BatchVariant."Batch No." := lco_BatchCode;
    //         lrc_BatchVariant."Item No." := vrc_SalesCrMemoLine."No.";
    //         lrc_BatchVariant."Variant Code" := vrc_SalesCrMemoLine."Variant Code";

    //         lrc_BatchVariant.Description := lrc_Item.Description;
    //         lrc_BatchVariant."Description 2" := lrc_Item."Description 2";

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Create Search No from BatchVar" = TRUE THEN BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.ItemSearchNameFromBatchVar(lrc_Item,lrc_BatchVariant);
    //         END ELSE BEGIN
    //           lrc_BatchVariant."Search Description" := lcu_BaseDataTemplateMgt.GenerateItemSearchDesc(lrc_Item);
    //         END;

    //         IF (lrc_BatchVariant.Description = '') AND
    //            (lrc_BatchVariant."Description 2" = '') THEN BEGIN
    //           lrc_BatchVariant.Description := vrc_SalesCrMemoLine.Description;
    //         END;

    //         lrc_BatchVariant."Item Main Category Code" := lrc_Item."Item Main Category Code";
    //         lrc_BatchVariant."Item Category Code" := lrc_Item."Item Category Code";
    //         lrc_BatchVariant."Product Group Code" := lrc_Item."Product Group Code";
    //         lrc_BatchVariant."Base Unit of Measure (BU)" := vrc_SalesCrMemoLine."Base Unit of Measure (BU)";
    //         lrc_BatchVariant."Unit of Measure Code" := vrc_SalesCrMemoLine."Unit of Measure Code";
    //         lrc_BatchVariant."Qty. per Unit of Measure" := vrc_SalesCrMemoLine."Qty. per Unit of Measure";

    //         lrc_ItemUnitOfMeasure.RESET();
    //         IF lrc_ItemUnitOfMeasure.GET(vrc_SalesCrMemoLine."No.",vrc_SalesCrMemoLine."Unit of Measure Code") THEN BEGIN
    //           CASE lrc_ItemUnitOfMeasure."Kind of Unit of Measure" OF
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Base Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Base Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;
    //                END;
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Content Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Content Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;
    //                END;
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Packing Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;

    //                END;
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Collo Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;
    //                END;
    //              lrc_ItemUnitOfMeasure."Kind of Unit of Measure"::"Transport Unit":
    //                BEGIN
    //                  lrc_PriceCalculation.RESET();
    //                  lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
    //                                                 lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
    //                  lrc_PriceCalculation.SETRANGE("Internal Calc. Type",
    //                                                 lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit");
    //                  IF (lrc_PriceCalculation.FIND('-')) AND
    //                     (lrc_PriceCalculation.COUNT() = 1) THEN BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceCalculation.Code;
    //                  END ELSE BEGIN
    //                    lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //                  END;
    //                END;
    //              ELSE
    //                lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //           END;
    //         END ELSE BEGIN
    //           lrc_BatchVariant."Price Base (Purch. Price)" := '';
    //         END;
    //         lrc_BatchVariant."Purch. Price (Price Base)" := vrc_SalesCrMemoLine."Sales Price (Price Base)";

    //         lrc_BatchVariant."Market Unit Cost (Base) (LCY)" := 0;

    //         lrc_BatchVariant."Vendor No." := '';
    //         lrc_BatchVariant."Vendor Search Name" := '';
    //         lrc_BatchVariant."Producer No." := '';

    //         lrc_BatchVariant."Country of Origin Code" := vrc_SalesCrMemoLine."Country of Origin Code";
    //         lrc_BatchVariant."Variety Code" := vrc_SalesCrMemoLine."Variety Code";
    //         lrc_BatchVariant."Trademark Code" := vrc_SalesCrMemoLine."Trademark Code";
    //         lrc_BatchVariant."Caliber Code" := vrc_SalesCrMemoLine."Caliber Code";
    //         lrc_BatchVariant."Vendor Caliber Code" := vrc_SalesCrMemoLine."Vendor Caliber Code";
    //         lrc_BatchVariant."Item Attribute 3" := vrc_SalesCrMemoLine."Item Attribute 3";
    //         lrc_BatchVariant."Item Attribute 2" := vrc_SalesCrMemoLine."Item Attribute 2";
    //         lrc_BatchVariant."Grade of Goods Code" := vrc_SalesCrMemoLine."Grade of Goods Code";
    //         lrc_BatchVariant."Item Attribute 7" := vrc_SalesCrMemoLine."Item Attribute 7";
    //         lrc_BatchVariant."Item Attribute 4" := vrc_SalesCrMemoLine."Item Attribute 4";
    //         lrc_BatchVariant."Coding Code" := vrc_SalesCrMemoLine."Coding Code";
    //         lrc_BatchVariant."Item Attribute 5" := vrc_SalesCrMemoLine."Item Attribute 5";

    //         lrc_BatchVariant."Departure Date" := vrc_SalesCrMemoLine."Shipment Date";
    //         lrc_BatchVariant."Order Date" := TODAY;
    //         lrc_BatchVariant."Date of Delivery" := vrc_SalesCrMemoLine."Shipment Date";

    //         lrc_BatchVariant."Kind of Settlement" := 0;
    //         lrc_BatchVariant.Weight := 0;
    //         //IF vrc_SalesCrMemoLine."Lot No. Producer" <> '' THEN BEGIN
    //         //   lrc_BatchVariant."Lot No. Producer" := rrc_ItemJournalLine."Lot No. Producer";
    //         //END;
    //         lrc_BatchVariant."Entry Location Code" := vrc_SalesCrMemoLine."Location Code";


    //         lrc_BatchVariant."Kind of Loading" := 0;
    //         lrc_BatchVariant."Voyage No." := '';
    //         lrc_BatchVariant."Container No." := '';
    //         lrc_BatchVariant."Means of Transport Type" := 0;
    //         lrc_BatchVariant."Means of Transp. Code (Depart)" := '';
    //         lrc_BatchVariant."Means of Transp. Code (Arriva)" := '';
    //         lrc_BatchVariant."Means of Transport Info" := '';

    //          lrc_BatchVariant.Source := lrc_BatchVariant.Source::"Item Journal Line";

    //         lrc_BatchVariant."Guaranteed Shelf Life" := lrc_Item."Guaranteed Shelf Life Purch.";

    //         lrc_BatchVariant."Shortcut Dimension 1 Code" := vrc_SalesCrMemoLine."Shortcut Dimension 1 Code";
    //         lrc_BatchVariant."Shortcut Dimension 2 Code" := vrc_SalesCrMemoLine."Shortcut Dimension 2 Code";
    //         lrc_BatchVariant."Shortcut Dimension 3 Code" := vrc_SalesCrMemoLine."Shortcut Dimension 3 Code";
    //         lrc_BatchVariant."Shortcut Dimension 4 Code" := vrc_SalesCrMemoLine."Shortcut Dimension 4 Code";

    //         lrc_BatchVariant.State := lrc_BatchVariant.State::Open;
    //         lrc_BatchVariant.insert();

    //         // Rückgabewerte setzen
    //         rco_BatchCode := lco_BatchCode;
    //         rco_BatchVariantCode := BatchVariantCode;
    //     end;


    //     procedure CalcStockBatchVar_2(vco_BatchVariantNo: Code[20];vco_LocationFilter: Code[1024];vdc_Rounding: Decimal;var rdc_PackInput: Decimal;vdc_ShowInQtyperUnitofMeasure: Decimal)
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchSetup: Record "5110363";
    //         "--  DMG 002 DMG50035": Integer;
    //         lrc_Location: Record "14";
    //         lco_LocationFilter: Code[1024];
    //         lcu_StockManagement: Codeunit "5110339";
    //     begin
    //         //mly 141014 - CalcStockBatchVar_2
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Bestände für eine Positionsvariante
    //         // -----------------------------------------------------------------------------------------
    //         // Parameter:  vco_BatchVariantNo
    //         //             vco_LocationFilter
    //         //             vdc_Rounding
    //         //             rdc_Bestand
    //         //             rdc_BestandVerf
    //         //             rdc_ErwBestandVerf
    //         //             rdc_MgeInAuftrag
    //         //             rdc_MgeInBestellung
    //         //             rdc_MgeReserviertFV
    //         //             rdc_MgeVerzollungsauftrag
    //         //             rdc_MgeInRechnung
    //         //             rdc_MgeInVkLieferung
    //         //             rdc_MgeInEkLieferung
    //         //             vdc_ShowInQtyperUnitofMeasure
    //         // -----------------------------------------------------------------------------------------

    //         lrc_BatchSetup.GET();

    //         rdc_PackInput     := 0;

    //         IF lrc_BatchVariant.GET(vco_BatchVariantNo) THEN BEGIN

    //           // DMG 002 DMG50035
    //           IF vco_LocationFilter <> '' THEN
    //              lrc_BatchVariant.SETFILTER("Location Filter", vco_LocationFilter);


    //           lrc_BatchVariant.CALCFIELDS("Pack. Input (Qty)");

    //           IF vdc_ShowInQtyperUnitofMeasure <> 1 THEN BEGIN
    //             IF vdc_ShowInQtyperUnitofMeasure <> 0 THEN
    //               rdc_PackInput := ROUND((lrc_BatchVariant."Pack. Input (Qty)" / vdc_ShowInQtyperUnitofMeasure),vdc_Rounding)
    //              ELSE
    //               rdc_PackInput := 0;
    //           END;

    //         END;
    //     end;

    var
        ErrorText: Text;
}

