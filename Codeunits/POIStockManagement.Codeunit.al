codeunit 5110339 "POI Stock Management"
{

    Permissions = TableData 32 = rm;

    trigger OnRun()
    begin
        BatchVarFillLocationsUpdAll();
    end;

    procedure ItemStock(vco_ItemNo: Code[20]; vco_VariantCode: Code[10]; vco_LocationCode: Code[10]; vdt_RefDate: Date; vco_UnitOfMeasureCode: Code[10]): Decimal
    var
        lrc_Item: Record Item;
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        ldc_QtyInStock: Decimal;
        lco_LocationFilter: Code[1024];
    begin
        // -----------------------------------------------------------------------------------------------
        // Gebuchte Bestandsmenge zu einem Stichtag
        // Rückgabewert: Bestand
        // -----------------------------------------------------------------------------------------------
        // vco_ItemNo
        // vco_VariantCode
        // vco_LocationCode
        // vdt_RefDate
        // vco_UnitOfMeasureCode
        // -----------------------------------------------------------------------------------------------
        Clear(ldc_QtyInStock);
        IF NOT lrc_Item.GET(vco_ItemNo) THEN
            EXIT(ldc_QtyInStock);

        IF vco_VariantCode <> '' THEN
            lrc_Item.SETFILTER("Variant Filter", vco_VariantCode);
        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_Item.SETRANGE("Location Filter")
            ELSE
                lrc_Item.SETFILTER("Location Filter", lco_LocationFilter);
        END;
        IF vdt_RefDate <> 0D THEN
            lrc_Item.SETFILTER("Date Filter", '..%1', vdt_RefDate);

        lrc_Item.CALCFIELDS("Net Change");
        ldc_QtyInStock := lrc_Item."Net Change";

        IF vco_UnitOfMeasureCode <> '' THEN BEGIN
            lrc_ItemUnitofMeasure.GET(lrc_Item."No.", vco_UnitOfMeasureCode);
            ldc_QtyInStock := ROUND(ldc_QtyInStock / lrc_ItemUnitofMeasure."Qty. per Unit of Measure", 0.00001);
        END;

        EXIT(ldc_QtyInStock);
    end;

    procedure ItemStockAvail(vco_ItemNo: Code[20]; vco_VariantCode: Code[10]; vco_UnitOfMeasureCode: Code[10]; vco_LocationCode: Code[10]; vdt_RefDate: Date): Decimal
    var
        lrc_Item: Record Item;
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        ldc_QtyAvailInStock: Decimal;
        lco_LocationFilter: Code[1024];

    begin
        // -----------------------------------------------------------------------------------------------
        // Verfügbarer Bestand zu einem Stichtag
        // Rückgabewert
        // -----------------------------------------------------------------------------------------------
        // Bestand (Bestand nicht datumsbezogen)
        // abzüglich der datumsbezogenen Verkäufe, Reservierungen,Umlagerungen und Packereiverbräuche
        // -----------------------------------------------------------------------------------------------
        // vco_ItemNo
        // vco_VariantCode
        // vco_UnitOfMeasureCode
        // vco_LocationCode
        // vdt_RefDate
        // -----------------------------------------------------------------------------------------------
        Clear(ldc_QtyAvailInStock);
        IF NOT lrc_Item.GET(vco_ItemNo) THEN
            EXIT(ldc_QtyAvailInStock);

        IF vco_VariantCode <> '' THEN
            lrc_Item.SETFILTER("Variant Filter", vco_VariantCode);
        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_Item.SETRANGE("Location Filter")
            ELSE
                lrc_Item.SETFILTER("Location Filter", lco_LocationFilter);
        END;
        IF vdt_RefDate <> 0D THEN
            lrc_Item.SETFILTER("Date Filter", '..%1', vdt_RefDate);

        lrc_Item.CALCFIELDS(Inventory, "Qty. on Sales Order",
                            "POI Qty. on Reservation (FV)", "Trans. Ord. Shipment (Qty.)",
                            "POI Qty. on Packing Input", "POI Qty. on Pack PackItem Inp");

        ldc_QtyAvailInStock := lrc_Item.Inventory -
                               lrc_Item."Qty. on Sales Order" -
                               lrc_Item."POI Qty. on Reservation (FV)" -
                               lrc_Item."POI Qty. on Packing Input" -
                               lrc_Item."POI Qty. on Pack PackItem Inp" -
                               lrc_Item."Trans. Ord. Shipment (Qty.)";

        lrc_BatchSetup.GET();
        lrc_Item.CALCFIELDS("POI Qty. on Sales Credit Memo", "POI Qty. on Purchase Cred Memo");

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEn
            ldc_QtyAvailInStock := ldc_QtyAvailInStock + lrc_Item."POI Qty. on Sales Credit Memo";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            ldc_QtyAvailInStock := ldc_QtyAvailInStock - lrc_Item."POI Qty. on Purchase Cred Memo";

        IF vco_UnitOfMeasureCode <> '' THEN
            IF lrc_ItemUnitofMeasure.GET(lrc_Item."No.", vco_UnitOfMeasureCode) THEN
                ldc_QtyAvailInStock := ROUND(ldc_QtyAvailInStock / lrc_ItemUnitofMeasure."Qty. per Unit of Measure", 0.00001);

        EXIT(ldc_QtyAvailInStock);
    end;

    procedure ItemStockExpAvail(vco_ItemNo: Code[20]; vco_VariantCode: Code[10]; vco_UnitOfMeasureCode: Code[10]; vco_LocationCode: Code[10]; vdt_RefDate: Date): Decimal
    var
        lrc_Item: Record Item;
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        ldc_QtyExpAvailInStock: Decimal;
        lco_LocationFilter: Code[1024];

    begin
        // -----------------------------------------------------------------------------------------------
        // Erwartet Verfügbarer Bestand zu einem Stichtag
        // Rückgabewert
        // -----------------------------------------------------------------------------------------------
        // Bestand (Bestand nicht datumsbezogen)
        // abzüglich der datumsbezogenen Verkäufe, Reservierungen,Umlagerungen und Packereiverbräuche
        // zuzüglich der datumsbezogenen Einkäufe, Umlagerungen und Packereiergebnisse
        // -----------------------------------------------------------------------------------------------
        // vco_ItemNo
        // vco_VariantCode
        // vco_UnitOfMeasureCode
        // vco_LocationCode
        // vdt_RefDate
        // -----------------------------------------------------------------------------------------------
        Clear(ldc_QtyExpAvailInStock);
        IF NOT lrc_Item.GET(vco_ItemNo) THEN
            EXIT(ldc_QtyExpAvailInStock);

        IF vco_VariantCode <> '' THEN
            lrc_Item.SETFILTER("Variant Filter", vco_VariantCode);
        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_Item.SETRANGE("Location Filter")
            ELSE
                lrc_Item.SETFILTER("Location Filter", lco_LocationFilter);
        END;
        IF vdt_RefDate <> 0D THEN
            lrc_Item.SETFILTER("Date Filter", '..%1', vdt_RefDate);

        lrc_Item.CALCFIELDS(Inventory, "Qty. on Sales Order",
                            "POI Qty. on Reservation (FV)", "Trans. Ord. Shipment (Qty.)",
                            "POI Qty. on Packing Input", "POI Qty. on Pack PackItem Inp",
                            "POI Qty. on Packing Output", "Qty. on Purch. Order",
                            "Trans. Ord. Receipt (Qty.)", "Qty. in Transit");

        ldc_QtyExpAvailInStock := lrc_Item.Inventory -
                                  lrc_Item."Qty. on Sales Order" -
                                  lrc_Item."POI Qty. on Reservation (FV)" -
                                  lrc_Item."POI Qty. on Packing Input" -
                                  lrc_Item."POI Qty. on Pack PackItem Inp" -
                                  lrc_Item."Trans. Ord. Shipment (Qty.)" +

                                  lrc_Item."POI Qty. on Packing Output" +
                                  lrc_Item."Qty. on Purch. Order" +
                                  lrc_Item."Trans. Ord. Receipt (Qty.)" +
                                  lrc_Item."Qty. in Transit";

        lrc_BatchSetup.GET();
        lrc_Item.CALCFIELDS("POI Qty. on Sales Credit Memo", "POI Qty. on Purchase Cred Memo");

        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
            ldc_QtyExpAvailInStock := ldc_QtyExpAvailInStock + lrc_Item."POI Qty. on Sales Credit Memo";

        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            ldc_QtyExpAvailInStock := ldc_QtyExpAvailInStock - lrc_Item."POI Qty. on Purchase Cred Memo";

        IF vco_UnitOfMeasureCode <> '' THEN
            IF lrc_ItemUnitofMeasure.GET(lrc_Item."No.", vco_UnitOfMeasureCode) THEN
                ldc_QtyExpAvailInStock := ROUND(ldc_QtyExpAvailInStock / lrc_ItemUnitofMeasure."Qty. per Unit of Measure", 0.00001);

        EXIT(ldc_QtyExpAvailInStock);
    end;

    procedure ItemStockAll(vco_ItemNo: Code[20]; vco_VariantCode: Code[10]; vco_UnitOfMeasureCode: Code[10]; vco_LocationCode: Code[10]; vdt_RefDate: Date; var rdc_QtyInStock: Decimal; var rdc_QtyAvailInStock: Decimal; var rdc_QtyExpAvailInStock: Decimal)
    var
        lrc_Item: Record Item;
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lco_LocationFilter: Code[1024];

    begin
        // -----------------------------------------------------------------------------------------------
        // Bestand, Bestand verfügbar und Bestand erwartet verfügbar
        // Referenzwerte: Bestand, Verfügbarer Bestand, Erwartet verfügbarer Bestand
        // -----------------------------------------------------------------------------------------------
        // Bestand (Bestand nicht datumsbezogen)
        // abzüglich der datumsbezogenen Verkäufe, Reservierungen,Umlagerungen und Packereiverbräuche
        // zuzüglich der datumsbezogenen Einkäufe, Umlagerungen und Packereiergebnisse
        // -----------------------------------------------------------------------------------------------

        rdc_QtyInStock := 0;
        rdc_QtyAvailInStock := 0;
        rdc_QtyExpAvailInStock := 0;

        IF NOT lrc_Item.GET(vco_ItemNo) THEN
            EXIT;

        IF vco_VariantCode <> '' THEN
            lrc_Item.SETFILTER("Variant Filter", vco_VariantCode);
        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_Item.SETRANGE("Location Filter")
            ELSE
                lrc_Item.SETFILTER("Location Filter", lco_LocationFilter);
        END;
        IF vdt_RefDate <> 0D THEN
            lrc_Item.SETFILTER("Date Filter", '..%1', vdt_RefDate);

        lrc_Item.CALCFIELDS(Inventory, "Qty. on Sales Order",
                            "POI Qty. on Reservation (FV)", "Trans. Ord. Shipment (Qty.)",
                            "POI Qty. on Packing Input", "POI Qty. on Pack PackItem Inp",
                            "POI Qty. on Packing Output", "Qty. on Purch. Order",
                            "Trans. Ord. Receipt (Qty.)", "Qty. in Transit");

        // Bestand
        rdc_QtyInStock := lrc_Item.Inventory;

        // Verfügbarer Bestand
        rdc_QtyAvailInStock := lrc_Item.Inventory -
                               lrc_Item."Qty. on Sales Order" -
                               lrc_Item."POI Qty. on Reservation (FV)" -
                               lrc_Item."POI Qty. on Packing Input" -
                               lrc_Item."POI Qty. on Pack PackItem Inp" -
                               lrc_Item."Trans. Ord. Shipment (Qty.)";

        // Erwartet verfügbarer Bestand
        rdc_QtyExpAvailInStock := lrc_Item.Inventory -
                                  lrc_Item."Qty. on Sales Order" -
                                  lrc_Item."POI Qty. on Reservation (FV)" -
                                  lrc_Item."POI Qty. on Packing Input" -
                                  lrc_Item."POI Qty. on Pack PackItem Inp" -
                                  lrc_Item."Trans. Ord. Shipment (Qty.)" +

                                  lrc_Item."POI Qty. on Packing Output" +
                                  lrc_Item."Qty. on Purch. Order" +
                                  lrc_Item."Trans. Ord. Receipt (Qty.)" +
                                  lrc_Item."Qty. in Transit";

        lrc_BatchSetup.GET();
        lrc_Item.CALCFIELDS("POI Qty. on Sales Credit Memo", "POI Qty. on Purchase Cred Memo");

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
            rdc_QtyAvailInStock := rdc_QtyAvailInStock + lrc_Item."POI Qty. on Sales Credit Memo";

        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
            rdc_QtyExpAvailInStock := rdc_QtyExpAvailInStock +
                                 lrc_Item."POI Qty. on Sales Credit Memo";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            rdc_QtyAvailInStock := rdc_QtyAvailInStock - lrc_Item."POI Qty. on Purchase Cred Memo";

        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            rdc_QtyExpAvailInStock := rdc_QtyExpAvailInStock - lrc_Item."POI Qty. on Purchase Cred Memo";


        IF vco_UnitOfMeasureCode <> '' THEN
            IF lrc_ItemUnitofMeasure.GET(lrc_Item."No.", vco_UnitOfMeasureCode) THEN BEGIN
                rdc_QtyExpAvailInStock := ROUND(rdc_QtyExpAvailInStock / lrc_ItemUnitofMeasure."Qty. per Unit of Measure", 0.00001);
                rdc_QtyAvailInStock := ROUND(rdc_QtyAvailInStock / lrc_ItemUnitofMeasure."Qty. per Unit of Measure", 0.00001);
                rdc_QtyInStock := ROUND(rdc_QtyInStock / lrc_ItemUnitofMeasure."Qty. per Unit of Measure", 0.00001);
            END;
    end;

    procedure ItemCheckAvail(vco_ItemNo: Code[20]; vco_VariantCode: Code[10]; vco_UnitOfMeasureCode: Code[10]; vco_LocationCode: Code[10]; vdt_RefDate: Date; vdc_OrgQty: Decimal; vdc_NewQty: Decimal)
    var
        lrc_Item: Record Item;
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        ldc_QtyAvail: Decimal;
        lco_LocationFilter: Code[1024];
        ErrorLabel: Text;

    begin
        // -----------------------------------------------------------------------------------------------
        // Prüfe ob Artikelbestand verfügbar ist
        // -----------------------------------------------------------------------------------------------
        // vco_ItemNo
        // vco_VariantCode
        // vco_UnitOfMeasureCode
        // vco_LocationCode
        // vdt_RefDate

        // vdc_OrgQty
        // vdc_NewQty
        // -----------------------------------------------------------------------------------------------

        IF vdc_NewQty <= vdc_OrgQty THEN
            EXIT;
        IF NOT lrc_Item.GET(vco_ItemNo) THEN
            EXIT;

        IF vco_VariantCode <> '' THEN
            lrc_Item.SETFILTER("Variant Filter", vco_VariantCode);
        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_Item.SETRANGE("Location Filter")
            ELSE
                lrc_Item.SETFILTER("Location Filter", lco_LocationFilter);
        END;
        IF vdt_RefDate <> 0D THEN
            lrc_Item.SETFILTER("Date Filter", '..%1', vdt_RefDate);

        lrc_Item.CALCFIELDS("Qty. on Purch. Order", "Qty. on Sales Order", "Trans. Ord. Receipt (Qty.)",
                            "Trans. Ord. Shipment (Qty.)", "Net Change", Inventory, "Purch. Req. Receipt (Qty.)",
                            "POI Qty. on Packing Input", "POI Qty. on Packing Output", "POI Qty. on Reservation (FV)",
                            "POI Qty. on Pack PackItem Inp", "Qty. in Transit");

        ldc_QtyAvail := lrc_Item."Net Change" +
                        lrc_Item."Qty. on Purch. Order" +
                        lrc_Item."Purch. Req. Receipt (Qty.)" +
                        lrc_Item."POI Qty. on Packing Output" +
                        lrc_Item."Qty. in Transit" +
                        lrc_Item."Trans. Ord. Receipt (Qty.)" -

                        lrc_Item."Qty. on Sales Order" -
                        lrc_Item."POI Qty. on Reservation (FV)" -
                        lrc_Item."POI Qty. on Packing Input" -
                        lrc_Item."POI Qty. on Pack PackItem Inp" -
                        lrc_Item."Trans. Ord. Shipment (Qty.)";

        lrc_BatchSetup.GET();
        lrc_Item.CALCFIELDS("POI Qty. on Sales Credit Memo", "POI Qty. on Purchase Cred Memo");

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
            ldc_QtyAvail := ldc_QtyAvail + lrc_Item."POI Qty. on Sales Credit Memo";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            ldc_QtyAvail := ldc_QtyAvail - lrc_Item."POI Qty. on Purchase Cred Memo";

        IF vco_UnitOfMeasureCode <> '' THEN
            IF lrc_ItemUnitofMeasure.GET(lrc_Item."No.", vco_UnitOfMeasureCode) THEN
                ldc_QtyAvail := ROUND(ldc_QtyAvail / lrc_ItemUnitofMeasure."Qty. per Unit of Measure", 0.00001);

        CASE lrc_Item."POI Stock Action on neg. Check" OF
            lrc_Item."POI Stock Action on neg. Check"::" ":
                ;

            lrc_Item."POI Stock Action on neg. Check"::Warning:
                IF (ldc_QtyAvail - (vdc_NewQty - vdc_OrgQty)) <= 0 THEN
                    IF NOT CONFIRM('Es ist kein ausreichender Bestand verfügbar!\' +
                                   'Referenzdatum ' + FORMAT(vdt_RefDate) + '\' +
                                   'Verfügbarer Bestand ' + FORMAT(ldc_QtyAvail) + '\' +
                                   'Ursprüngliche Menge ' + FORMAT(vdc_OrgQty) + '\' +
                                   'Neue Menge ' + FORMAT(vdc_NewQty) + '\' +
                                   'Möchten Sie den Artikel trotzdem verkaufen?') THEN
                        ERROR('');
            lrc_Item."POI Stock Action on neg. Check"::Blocking:
                IF (ldc_QtyAvail - (vdc_NewQty - vdc_OrgQty)) < 0 THEN begin
                    ErrorLabel := 'Es ist kein ausreichender Bestand verfügbar!\\' +
                          'Referenzdatum ' + FORMAT(vdt_RefDate) + '\' +
                          'Verfügbarer Bestand ' + FORMAT(ldc_QtyAvail) + '\' +
                          'Ursprüngliche Menge ' + FORMAT(vdc_OrgQty) + '\' +
                          'Neue Menge ' + FORMAT(vdc_NewQty) + '\\' +
                          'Der Artikel kann nicht verkauft werden!';
                    Error(ErrorLabel);
                end;
        END;
    end;

    procedure BatchVarStock(vco_BatchVarNo: Code[20]; vco_LocationCode: Code[10]): Decimal
    var
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        ldc_Stock: Decimal;
        lco_LocationFilter: Code[1024];
    begin
        // -----------------------------------------------------------------------------------------------
        // Menge Bestand für Positionsvariante berechnen
        // -----------------------------------------------------------------------------------------------

        IF NOT lrc_BatchVariant.GET(vco_BatchVarNo) THEN
            EXIT;

        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_BatchVariant.SETRANGE("Location Filter")
            ELSE
                lrc_BatchVariant.SETFILTER("Location Filter", lco_LocationFilter);
        END;

        lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)", "B.V. Net Change (Qty.)");
        ldc_Stock := lrc_BatchVariant."B.V. Inventory (Qty.)";

        lrc_ItemUnitofMeasure.GET(lrc_BatchVariant."Item No.", lrc_BatchVariant."Unit of Measure Code");
        ldc_Stock := ldc_Stock / lrc_ItemUnitofMeasure."Qty. per Unit of Measure";

        EXIT(ldc_Stock);
    end;

    procedure BatchVarStockAvail(vco_BatchVarNo: Code[20]; vco_LocationCode: Code[10]): Decimal
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        ldc_StockAvail: Decimal;
        ldc_StockExpAvail: Decimal;
        lco_LocationFilter: Code[1024];
    begin
        // -----------------------------------------------------------------------------------------------
        // Verfügbare Menge für Positionsvariante berechnen
        // -----------------------------------------------------------------------------------------------

        lrc_BatchSetup.GET();

        IF NOT lrc_BatchVariant.GET(vco_BatchVarNo) THEN
            EXIT;

        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_BatchVariant.SETRANGE("Location Filter")
            ELSE
                lrc_BatchVariant.SETFILTER("Location Filter", lco_LocationFilter);
        END;

        lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)", "B.V. Net Change (Qty.)",
                                    "B.V. Purch. Order (Qty)", "B.V. Sales Order (Qty)",
                                    "B.V. FV Reservation (Qty)", "B.V. Pack. Input (Qty)",
                                    "B.V. Pack. Pack.-Input (Qty)", "B.V. Pack. Output (Qty)",
                                    "B.V. Sales Cr. Memo (Qty)", "B.V. Purch. Cr. Memo (Qty)");

        lrc_BatchVariant.CALCFIELDS("B.V. Transfer Ship (Qty)", lrc_BatchVariant."B.V. Transfer Rec. (Qty)",
                                     "B.V. Transfer in Transit (Qty)");

        ldc_StockAvail := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                          lrc_BatchVariant."B.V. Sales Order (Qty)" -
                          lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                          lrc_BatchVariant."B.V. Transfer Ship (Qty)" -
                          lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                          lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)";

        ldc_StockExpAvail := ldc_StockAvail +
                             lrc_BatchVariant."B.V. Purch. Order (Qty)" +
                             lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                             lrc_BatchVariant."B.V. Pack. Output (Qty)" +
                             lrc_BatchVariant."B.V. Transfer in Transit (Qty)";


        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
            ldc_StockAvail := ldc_StockAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        // Verkaufsgutschriften in die erw. verf. Menge einbeziehen
        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
            ldc_StockExpAvail := ldc_StockExpAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            ldc_StockAvail := ldc_StockAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            ldc_StockExpAvail := ldc_StockExpAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        IF lrc_ItemUnitofMeasure.GET(lrc_BatchVariant."Item No.", lrc_BatchVariant."Unit of Measure Code") THEN BEGIN
            ldc_StockAvail := ldc_StockAvail / lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
            ldc_StockExpAvail := ldc_StockExpAvail / lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
        END ELSE BEGIN
            ldc_StockAvail := ldc_StockAvail / lrc_BatchVariant."Qty. per Unit of Measure";
            ldc_StockExpAvail := ldc_StockExpAvail / lrc_BatchVariant."Qty. per Unit of Measure";
        END;

        EXIT(ldc_StockAvail);
    end;

    procedure BatchVarStockExpAvail(vco_BatchVarNo: Code[20]; vco_LocationCode: Code[10]): Decimal
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_BatchVariant: Record "POI Batch Variant";
        //lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_UnitofMeasure: Record "Unit of Measure";
        ldc_StockAvail: Decimal;
        ldc_StockExpAvail: Decimal;
        lco_LocationFilter: Code[1024];
    begin
        // -----------------------------------------------------------------------------------------------
        // Erwartet Verfügbare Menge für Positionsvariante berechnen
        // -----------------------------------------------------------------------------------------------

        lrc_BatchSetup.GET();

        IF NOT lrc_BatchVariant.GET(vco_BatchVarNo) THEN
            EXIT;

        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_BatchVariant.SETRANGE("Location Filter")
            ELSE
                lrc_BatchVariant.SETFILTER("Location Filter", lco_LocationFilter);
        END;

        lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)", "B.V. Net Change (Qty.)",
                                    "B.V. Purch. Order (Qty)", "B.V. Sales Order (Qty)",
                                    "B.V. FV Reservation (Qty)", "B.V. Pack. Input (Qty)",
                                    "B.V. Pack. Pack.-Input (Qty)", "B.V. Pack. Output (Qty)",
                                    "B.V. Purch. Cr. Memo (Qty)", "B.V. Sales Cr. Memo (Qty)");

        lrc_BatchVariant.CALCFIELDS("B.V. Transfer Ship (Qty)", lrc_BatchVariant."B.V. Transfer Rec. (Qty)",
                                     "B.V. Transfer in Transit (Qty)");

        ldc_StockAvail := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                          lrc_BatchVariant."B.V. Sales Order (Qty)" -
                          lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                          lrc_BatchVariant."B.V. Transfer Ship (Qty)" -
                          lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                          lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)";

        ldc_StockExpAvail := ldc_StockAvail +
                             lrc_BatchVariant."B.V. Purch. Order (Qty)" +
                             lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                             lrc_BatchVariant."B.V. Pack. Output (Qty)" +
                             lrc_BatchVariant."B.V. Transfer in Transit (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
            ldc_StockAvail := ldc_StockAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";
        // Verkaufsgutschriften in die erw. verf. Menge einbeziehen
        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEn
            ldc_StockExpAvail := ldc_StockExpAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            ldc_StockAvail := ldc_StockAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";
        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            ldc_StockExpAvail := ldc_StockExpAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        //IF NOT
        lrc_UnitofMeasure.GET(lrc_BatchVariant."Unit of Measure Code");
        //THEN ERROR('No %1 - Code %2',lrc_BatchVariant."No.",lrc_BatchVariant."Unit of Measure Code");

        IF lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" = 0 THEN
            ldc_StockAvail := 0
        ELSE
            ldc_StockAvail := ldc_StockAvail / lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas";
        IF lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" = 0 THEN
            ldc_StockExpAvail := 0
        ELSE
            ldc_StockExpAvail := ldc_StockExpAvail / lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas";

        //ldc_StockAvail := ldc_StockAvail / lrc_UnitofMeasure."Qty. (BU) per Unit of Measure";
        //ldc_StockExpAvail := ldc_StockExpAvail / lrc_UnitofMeasure."Qty. (BU) per Unit of Measure";

        EXIT(ldc_StockExpAvail);
    end;

    procedure BatchVarStockAll(vco_BatchVarNo: Code[20]; vco_LocationCode: Code[10]; vdt_RefDate: Date; var rdc_Stock: Decimal; var rdc_StockAvail: Decimal; var rdc_StockExpAvail: Decimal)
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lco_LocationFilter: Code[1024];
    begin
        // -----------------------------------------------------------------------------------------------
        // Bestand, Verfügbare Menge und erwartet Verfügbare Menge für Positionsvariante berechnen
        // -----------------------------------------------------------------------------------------------
        // vco_BatchVarNo
        // vco_LocationCode
        // vdt_RefDate
        // rdc_Stock
        // rdc_StockAvail
        // rdc_StockExpAvail
        //
        // Referenzwert: Bestand, Verfügbarer Bestand, Erwartet verfügbarer Bestand
        // -----------------------------------------------------------------------------------------------

        rdc_Stock := 0;
        rdc_StockAvail := 0;
        rdc_StockExpAvail := 0;

        IF NOT lrc_BatchVariant.GET(vco_BatchVarNo) THEN
            EXIT;

        lrc_BatchSetup.GET();

        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_BatchVariant.SETRANGE("Location Filter")
            ELSE
                lrc_BatchVariant.SETFILTER("Location Filter", lco_LocationFilter);
        END;

        // Filter auf Referenzdatum (Warenausgangsdatum / Wareneingangsdatum)
        IF vdt_RefDate <> 0D THEN
            lrc_BatchVariant.SETFILTER("Date Filter", '..%1', vdt_RefDate);

        lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)", "B.V. Net Change (Qty.)",
                                    "B.V. Purch. Order (Qty)", "B.V. Sales Order (Qty)",
                                    "B.V. FV Reservation (Qty)", "B.V. Pack. Input (Qty)",
                                    "B.V. Pack. Pack.-Input (Qty)", "B.V. Pack. Output (Qty)",
                                    "B.V. Transfer Ship (Qty)", "B.V. Transfer Rec. (Qty)",
                                    "B.V. Transfer in Transit (Qty)",
                                    "B.V. Purch. Cr. Memo (Qty)",
                                    "B.V. Sales Cr. Memo (Qty)");

        rdc_Stock := lrc_BatchVariant."B.V. Inventory (Qty.)";

        rdc_StockAvail := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                          lrc_BatchVariant."B.V. Sales Order (Qty)" -
                          lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                          lrc_BatchVariant."B.V. Transfer Ship (Qty)" -
                          lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                          lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)";

        rdc_StockExpAvail := rdc_StockAvail +
                             lrc_BatchVariant."B.V. Purch. Order (Qty)" +
                             lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                             lrc_BatchVariant."B.V. Pack. Output (Qty)" +
                             lrc_BatchVariant."B.V. Transfer in Transit (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
            rdc_StockAvail := rdc_StockAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        // Erw. Verf. Bestand inkl. Verkaufsgutschriften
        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
            rdc_StockExpAvail := rdc_StockExpAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            rdc_StockAvail := rdc_StockAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            rdc_StockExpAvail := rdc_StockExpAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        lrc_ItemUnitofMeasure.GET(lrc_BatchVariant."Item No.", lrc_BatchVariant."Unit of Measure Code");
        rdc_Stock := rdc_Stock / lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
        rdc_StockAvail := rdc_StockAvail / lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
        rdc_StockExpAvail := rdc_StockExpAvail / lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
    end;

    procedure BatchVarCheckAvail(vco_BatchVariantNo: Code[20]; vco_LocationCode: Code[10]; vdt_RefDate: Date; vdc_NewQty: Decimal; vdc_OldQty: Decimal)
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_Item: Record Item;
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_UnitofMeasure: Record "Unit of Measure";
        ldc_Avail: Decimal;
        ldc_ExpAvail: Decimal;
        ldc_DiffMge: Decimal;
        lco_UnitOfMeasure: Code[20];
        lco_LocationFilter: Code[1024];
        ErrorLabel: Text;
    begin
        // -----------------------------------------------------------------------------------------------
        // Prüfung ob Bestand ausreicht bei Eingabe Menge in Sales Line und Sales Batch Var Detail
        // -----------------------------------------------------------------------------------------------
        // vco_BatchVariantNo
        // vco_LocationCode
        // vdt_RefDate
        // vdc_NewQty (Basis)
        // vdc_OldQty (Basis)
        // -----------------------------------------------------------------------------------------------

        // Differenzmenge berechnen
        ldc_DiffMge := vdc_NewQty - vdc_OldQty;

        // Keine Prüfung wenn Menge reduziert
        IF ldc_DiffMge <= 0 THEN
            EXIT;

        lrc_BatchSetup.GET();

        // Keine Prüfung wenn Dummy Pos.-Var.
        IF (lrc_BatchSetup."Dummy Batch Variant No." <> '') AND
           (vco_BatchVariantNo = lrc_BatchSetup."Dummy Batch Variant No.") THEN
            EXIT;

        IF NOT lrc_BatchVariant.GET(vco_BatchVariantNo) THEN
            EXIT;

        // Keine Prüfung wenn Pos.-Var. aus einem anderen Mandanten oder aus Sortiment
        IF (lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Company Copy") OR
           (lrc_BatchVariant.Source = lrc_BatchVariant.Source::Assortment) THEN
            EXIT;

        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_BatchVariant.SETRANGE("Location Filter")
            ELSE
                lrc_BatchVariant.SETFILTER("Location Filter", lco_LocationFilter);
        END;

        // Filter auf Referenzdatum (Warenausgangsdatum / Wareneingangsdatum)
        IF vdt_RefDate <> 0D THEN
            lrc_BatchVariant.SETFILTER("Date Filter", '..%1', vdt_RefDate);

        // Werte kalkulieren
        lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)",
                                    "B.V. Net Change (Qty.)",
                                    "B.V. Purch. Order (Qty)",
                                    "B.V. Sales Order (Qty)",
                                    "B.V. FV Reservation (Qty)",
                                    "B.V. Pack. Input (Qty)",
                                    "B.V. Pack. Pack.-Input (Qty)",
                                    "B.V. Pack. Output (Qty)",
                                    "B.V. Transfer Ship (Qty)",
                                    "B.V. Transfer Rec. (Qty)",
                                    "B.V. Transfer in Transit (Qty)",
                                    "B.V. Purch. Cr. Memo (Qty)",
                                    "B.V. Sales Cr. Memo (Qty)");

        // Verfügbaren Bestand berechnen
        ldc_Avail := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                     lrc_BatchVariant."B.V. Sales Order (Qty)" -
                     lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                     lrc_BatchVariant."B.V. Transfer Ship (Qty)" -
                     lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                     lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)";

        // Erwartet verfügbaren Bestand berechnen
        ldc_ExpAvail := ldc_Avail +
                        lrc_BatchVariant."B.V. Purch. Order (Qty)" +
                        lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                        lrc_BatchVariant."B.V. Pack. Output (Qty)" +
                        lrc_BatchVariant."B.V. Transfer in Transit (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
            ldc_Avail := ldc_Avail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        // Gutschriften in den verfügbaren Bestand einbeziehen
        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
            ldc_ExpAvail := ldc_ExpAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            ldc_Avail := ldc_Avail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            ldc_ExpAvail := ldc_ExpAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        lco_UnitOfMeasure := lrc_BatchVariant."Base Unit of Measure (BU)";

        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Internal Customer Code" = 'BIOTROPIC' THEN
            IF lrc_BatchVariant."Qty. per Unit of Measure" <> 1 THEN BEGIN
                ldc_DiffMge := ldc_DiffMge / lrc_BatchVariant."Qty. per Unit of Measure";
                ldc_ExpAvail := ldc_ExpAvail / lrc_BatchVariant."Qty. per Unit of Measure";
                ldc_Avail := ldc_Avail / lrc_BatchVariant."Qty. per Unit of Measure";
                lco_UnitOfMeasure := lrc_BatchVariant."Unit of Measure Code";
            END;


        // Erwartet verfügbarer Bestand ist NICHT ausreichend
        IF ldc_DiffMge > ldc_ExpAvail THEN BEGIN
            lrc_Item.GET(lrc_BatchVariant."Item No.");
            IF lrc_Item."POI Steuerung Artikeleinheiten" =
               lrc_Item."POI Steuerung Artikeleinheiten"::"Keine Einheitsverpackung (gewogen)" THEN BEGIN
                IF (ldc_ExpAvail < 0) OR (ABS(ldc_DiffMge - ldc_ExpAvail) > lrc_BatchVariant."Qty. per Unit of Measure") THEN begin
                    ErrorLabel := 'Positionsvariante: ' + vco_BatchVariantNo + '\' +
                       'Der erwartet verfügbare Bestand ' + FORMAT(ldc_ExpAvail) + ' ' + lco_UnitOfMeasure + '\' +
                       'ist nicht ausreichend für die Menge ' + FORMAT(ldc_DiffMge) + ' ' + lco_UnitOfMeasure;
                    Error(ErrorLabel);
                end
            END ELSE BEGIN
                // Mengen in Kolloeinheit umrechnen
                IF lco_UnitOfMeasure = lrc_BatchVariant."Base Unit of Measure (BU)" THEN
                    IF lrc_BatchVariant."Unit of Measure Code" <> lrc_BatchVariant."Base Unit of Measure (BU)" THEN
                        IF lrc_UnitofMeasure.GET(lrc_BatchVariant."Unit of Measure Code") THEN BEGIN
                            lco_UnitOfMeasure := lrc_BatchVariant."Unit of Measure Code";
                            ldc_ExpAvail := ROUND(ldc_ExpAvail / lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas", 0.00001);
                            ldc_DiffMge := ROUND(ldc_DiffMge / lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas", 0.00001);
                        END;



                CASE lrc_BatchSetup."Batch Stockout Warning" OF
                    lrc_BatchSetup."Batch Stockout Warning"::" ":
                        ;
                    lrc_BatchSetup."Batch Stockout Warning"::Warning:
                        IF NOT CONFIRM('Positionsvariante: ' + vco_BatchVariantNo + '\' +
                              'Der erwartet verfügbare Bestand ' + FORMAT(ldc_ExpAvail) + ' ' + lco_UnitOfMeasure + '\' +
                              'ist nicht ausreichend für die Menge ' + FORMAT(ldc_DiffMge) + ' ' + lco_UnitOfMeasure) THEN
                            ERROR('');
                    lrc_BatchSetup."Batch Stockout Warning"::Blocking:
                        begin
                            ErrorLabel := 'Positionsvariante: ' + vco_BatchVariantNo + '\' +
                                  'Der erwartet verfügbare Bestand ' + FORMAT(ldc_ExpAvail) + ' ' + lco_UnitOfMeasure + '\' +
                                  'ist nicht ausreichend für die Menge ' + FORMAT(ldc_DiffMge) + ' ' + lco_UnitOfMeasure;
                            Error(ErrorLabel);
                        end;
                END;
            END;
        END;

        // Erw. Verfügbarer Bestand ist ausreichend aber NICHT der verfügbare Bestand
        IF (ldc_DiffMge > ldc_Avail) AND
           (ldc_DiffMge <= ldc_ExpAvail) THEN
            IF lrc_FruitVisionSetup."Message Selling Exp. Stock" = TRUE THEN BEGIN
                // Mengen in Kolloeinheit umrechnen
                IF lco_UnitOfMeasure = lrc_BatchVariant."Base Unit of Measure (BU)" THEN
                    IF lrc_BatchVariant."Unit of Measure Code" <> lrc_BatchVariant."Base Unit of Measure (BU)" THEN
                        IF lrc_UnitofMeasure.GET(lrc_BatchVariant."Unit of Measure Code") THEN BEGIN
                            lco_UnitOfMeasure := lrc_BatchVariant."Unit of Measure Code";
                            ldc_Avail := ROUND(ldc_Avail / lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas", 0.00001);
                            ldc_ExpAvail := ROUND(ldc_ExpAvail / lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas", 0.00001);
                        END;
                IF (lrc_BatchVariant.Source <> lrc_BatchVariant.Source::Dummy) and (lrc_BatchVariant.Source <> lrc_BatchVariant.Source::Assortment) THEN
                    IF lrc_BatchSetup."Batch Stockout Warning" <> lrc_BatchSetup."Batch Stockout Warning"::" " THEN
                        IF NOT CONFIRM('Positionsvariante: ' + vco_BatchVariantNo + '\' +
                                       'Der verfügbare Bestand ist nicht ausreichend ' + FORMAT(ldc_Avail) + ' ' + lco_UnitOfMeasure + '\' +
                                       'Der erwartet verfügbare Bestand ist ausreichend ' + FORMAT(ldc_ExpAvail) + ' ' + lco_UnitOfMeasure + '\' +
                                       'Möchten Sie übernehmen?') THEN
                            ERROR('Abbruch!');
            END;
    end;

    procedure BatchVarTransfer(vrc_TransferLine: Record "Transfer Line")
    var
        lrc_Item: Record Item;
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        // -----------------------------------------------------------------------------------------------
        // Funktion zum Prüfen ob ausreichend Bestand für Positionsvariantennr vorhanden ist
        // -----------------------------------------------------------------------------------------------

        IF (vrc_TransferLine."Item No." = '') OR
           (vrc_TransferLine."POI Batch Variant No." = '') OR
           (vrc_TransferLine.Quantity <= 0) THEN
            EXIT;

        // Artikel lesen
        lrc_Item.GET(vrc_TransferLine."Item No.");
        // Positionsvariante lesen
        lrc_BatchVariant.GET(vrc_TransferLine."POI Batch Variant No.");

        // Kontrollieren ob Artikelnr. identisch sind
        IF lrc_BatchVariant."Item No." <> lrc_Item."No." THEN
            ERROR('Artikelnr. Positionsvariante abweichend von Artikelnr. Umlagerungszeile!');
    end;

    procedure BatchVarCheckAvailTransfer(vco_BatchVariantNo: Code[20]; vco_LocationCode: Code[10]; vdt_RefDate: Date; vdc_NewQty: Decimal; vdc_OldQty: Decimal)
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        //lrc_Item: Record Item;
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lco_LocationFilter: Code[1024];
        ldc_Avail: Decimal;
        ldc_ExpAvail: Decimal;
        ldc_DiffMge: Decimal;

        lco_UnitOfMeasure: Code[20];
        ErrorLabel: Text;
    begin
        // -----------------------------------------------------------------------------------------------
        // Prüfung ob Bestand ausreicht bei Eingabe Menge in Sales Line und Sales Batch Var Detail
        // -----------------------------------------------------------------------------------------------
        // Aufruf aus Tab 5741 Transfer Line, Quantity OnValidate
        // vco_BatchVariantNo
        // vco_LocationCode   Transfer-from Code
        // vdt_RefDate        0D
        // vdc_NewQty (Basis) Quantity
        // vdc_OldQty (Basis) xRec.Quantity
        // -----------------------------------------------------------------------------------------------

        ldc_DiffMge := vdc_NewQty - vdc_OldQty;
        IF ldc_DiffMge <= 0 THEN
            EXIT;

        lrc_BatchVariant.GET(vco_BatchVariantNo);

        IF lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Company Copy" THEN
            EXIT;

        lrc_BatchSetup.GET();

        // Prüfung ob Dummy Variante
        IF vco_BatchVariantNo = lrc_BatchSetup."Dummy Batch Variant No." THEN
            EXIT;

        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_BatchVariant.SETRANGE("Location Filter")
            ELSE
                lrc_BatchVariant.SETFILTER("Location Filter", lco_LocationFilter);
        END;

        // Filter auf Referenzdatum (Warenausgangsdatum / Wareneingangsdatum)
        IF vdt_RefDate <> 0D THEN
            lrc_BatchVariant.SETFILTER("Date Filter", '..%1', vdt_RefDate);


        // Werte kalkulieren
        lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)",
                                    "B.V. Net Change (Qty.)",
                                    "B.V. Purch. Order (Qty)",
                                    "B.V. Sales Order (Qty)",
                                    "B.V. FV Reservation (Qty)",
                                    "B.V. Pack. Input (Qty)",
                                    "B.V. Pack. Pack.-Input (Qty)",
                                    "B.V. Pack. Output (Qty)",
                                    "B.V. Transfer Ship (Qty)",
                                    "B.V. Transfer Rec. (Qty)",
                                    "B.V. Transfer in Transit (Qty)",
                                    "B.V. Purch. Cr. Memo (Qty)",
                                    "B.V. Sales Cr. Memo (Qty)");

        // Verfügbaren Bestand berechnen
        ldc_Avail := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                     lrc_BatchVariant."B.V. Sales Order (Qty)" -
                     lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                     lrc_BatchVariant."B.V. Transfer Ship (Qty)" -
                     lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                     lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)";

        // Erwartet verfügbaren Bestand berechnen
        ldc_ExpAvail := ldc_Avail +
                        lrc_BatchVariant."B.V. Purch. Order (Qty)" +
                        lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                        lrc_BatchVariant."B.V. Pack. Output (Qty)" +
                        lrc_BatchVariant."B.V. Transfer in Transit (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEn
            ldc_Avail := ldc_Avail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        // Erw. Verf. Bestand inkl. Verkaufsgutschriften
        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
            ldc_ExpAvail := ldc_ExpAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            ldc_Avail := ldc_Avail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            ldc_ExpAvail := ldc_ExpAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        lco_UnitOfMeasure := lrc_BatchVariant."Base Unit of Measure (BU)";

        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Internal Customer Code" = 'BIOTROPIC' THEN
            IF lrc_BatchVariant."Qty. per Unit of Measure" <> 1 THEN BEGIN
                ldc_DiffMge := ldc_DiffMge / lrc_BatchVariant."Qty. per Unit of Measure";
                ldc_ExpAvail := ldc_ExpAvail / lrc_BatchVariant."Qty. per Unit of Measure";
                ldc_Avail := ldc_Avail / lrc_BatchVariant."Qty. per Unit of Measure";
                lco_UnitOfMeasure := lrc_BatchVariant."Unit of Measure Code";
            END;

        // Erwartet verfügbarer Bestand ist NICHT ausreichend
        IF ldc_DiffMge > ldc_ExpAvail THEN begin
            ErrorLabel := 'Positionsvariante: ' + vco_BatchVariantNo + '\' +
                  'Der erwartet verfügbare Bestand ' + FORMAT(ldc_ExpAvail) + ' ' + lco_UnitOfMeasure + '\' +
                  'ist nicht ausreichend für die Menge ' + FORMAT(ldc_DiffMge) + ' ' + lco_UnitOfMeasure;
            Error(ErrorLabel);
        end;

        IF GUIALLOWED() THEN
            // Erw. Verfügbarer Bestand ist ausreichend aber NICHT verfügbarer Bestand
            IF (ldc_DiffMge > ldc_Avail) AND (ldc_DiffMge <= ldc_ExpAvail) THEN
                IF lrc_FruitVisionSetup."Internal Customer Code" <> 'MFLMÜNSTER' THEN
                    IF NOT CONFIRM('Positionsvariante: ' + vco_BatchVariantNo + '\' +
                                   'Der verfügbare Bestand ist nicht ausreichend ' + FORMAT(ldc_Avail) + ' ' + lco_UnitOfMeasure + '\' +
                                   'Der erwartet verfügbare Bestand ist ausreichend ' + FORMAT(ldc_ExpAvail) + ' ' + lco_UnitOfMeasure + '\' +
                                   'Möchten Sie übernehmen?') THEN
                        ERROR('');
    end;

    procedure BatchVarCheckAvailTransferTo(vco_BatchVariantNo: Code[20]; vco_LocationCode: Code[10]; vdt_RefDate: Date; vdc_NewQty: Decimal; vdc_OldQty: Decimal)
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        //lrc_Item: Record Item;
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lco_LocationFilter: Code[1024];
        ldc_Avail: Decimal;
        ldc_ExpAvail: Decimal;
        ldc_DiffMge: Decimal;

        lco_UnitOfMeasure: Code[20];
        ErrorLabel: Text;
    begin
        // -----------------------------------------------------------------------------------------------
        // Prüfung ob Bestand ausreicht bei Eingabe Menge in Sales Line und Sales Batch Var Detail
        // -----------------------------------------------------------------------------------------------
        // Aufruf aus Tab 5741 Transfer Line, Quantity OnValidate
        // vco_BatchVariantNo
        // vco_LocationCode   Transfer-from Code
        // vdt_RefDate        0D
        // vdc_NewQty (Basis) Quantity
        // vdc_OldQty (Basis) xRec.Quantity
        // -----------------------------------------------------------------------------------------------

        ldc_DiffMge := vdc_NewQty - vdc_OldQty;
        IF ldc_DiffMge >= 0 THEN
            EXIT;

        lrc_BatchVariant.GET(vco_BatchVariantNo);

        IF lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Company Copy" THEN
            EXIT;

        lrc_BatchSetup.GET();

        // Prüfung ob Dummy Variante
        IF vco_BatchVariantNo = lrc_BatchSetup."Dummy Batch Variant No." THEN
            EXIT;

        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN BEGIN
            // Filter für Lagerorte aufbauen
            lco_LocationFilter := GetLocFilter(vco_LocationCode);
            // Filter Lagerorte setzen
            IF lco_LocationFilter = '' THEN
                lrc_BatchVariant.SETRANGE("Location Filter")
            ELSE
                lrc_BatchVariant.SETFILTER("Location Filter", lco_LocationFilter);
        END;

        // Filter auf Referenzdatum (Warenausgangsdatum / Wareneingangsdatum)
        IF vdt_RefDate <> 0D THEN
            lrc_BatchVariant.SETFILTER("Date Filter", '..%1', vdt_RefDate);


        // Werte kalkulieren
        lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)",
                                    "B.V. Net Change (Qty.)",
                                    "B.V. Purch. Order (Qty)",
                                    "B.V. Sales Order (Qty)",
                                    "B.V. FV Reservation (Qty)",
                                    "B.V. Pack. Input (Qty)",
                                    "B.V. Pack. Pack.-Input (Qty)",
                                    "B.V. Pack. Output (Qty)",
                                    "B.V. Transfer Ship (Qty)",
                                    "B.V. Transfer Rec. (Qty)",
                                    "B.V. Transfer in Transit (Qty)",
                                    "B.V. Purch. Cr. Memo (Qty)",
                                    "B.V. Sales Cr. Memo (Qty)");

        // Verfügbaren Bestand berechnen
        ldc_Avail := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                     lrc_BatchVariant."B.V. Sales Order (Qty)" -
                     lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                     lrc_BatchVariant."B.V. Transfer Ship (Qty)" -
                     lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                     lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)";

        // Erwartet verfügbaren Bestand berechnen
        ldc_ExpAvail := ldc_Avail +
                        lrc_BatchVariant."B.V. Purch. Order (Qty)" +
                        lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                        lrc_BatchVariant."B.V. Pack. Output (Qty)" +
                        lrc_BatchVariant."B.V. Transfer in Transit (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
            ldc_Avail := ldc_Avail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        // Erw. Verf. Bestand inkl. Verkaufsgutschriften
        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
            ldc_ExpAvail := ldc_ExpAvail + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            ldc_Avail := ldc_Avail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            ldc_ExpAvail := ldc_ExpAvail - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";


        lco_UnitOfMeasure := lrc_BatchVariant."Base Unit of Measure (BU)";

        lrc_FruitVisionSetup.GET();

        // Erwartet verfügbarer Bestand ist NICHT ausreichend
        IF -ldc_DiffMge > ldc_ExpAvail THEN begin//RS ldc_DiffMge ist immer negativ, verfügbare Menge >= 0
            ErrorLabel := 'Positionsvariante: ' + vco_BatchVariantNo + '\' +
                  'Der erwartet verfügbare Bestand ' + FORMAT(ldc_ExpAvail) + ' ' + lco_UnitOfMeasure + '\' +
                  'ist nicht ausreichend für die Menge ' + FORMAT(ldc_DiffMge) + ' ' + lco_UnitOfMeasure;
            Error(ErrorLabel);
        end;

        IF GUIALLOWED() THEN
            // Erw. Verfügbarer Bestand ist ausreichend aber NICHT verfügbarer Bestand
            IF (ldc_DiffMge < ldc_Avail) AND (ldc_DiffMge <= ldc_ExpAvail) THEN
                IF lrc_FruitVisionSetup."Internal Customer Code" <> 'MFLMÜNSTER' THEN
                    IF NOT CONFIRM('Positionsvariante: ' + vco_BatchVariantNo + '\' +
                                   'Der verfügbare Bestand ist nicht ausreichend ' + FORMAT(ldc_Avail) + ' ' + lco_UnitOfMeasure + '\' +
                                   'Der erwartet verfügbare Bestand ist ausreichend ' + FORMAT(ldc_ExpAvail) + ' ' + lco_UnitOfMeasure + '\' +
                                   'Möchten Sie übernehmen?') THEN
                        ERROR('');
    end;

    procedure BatchVarSalesReservation(vco_BatchVariantNo: Code[20]; vco_LocationCode: Code[10]): Decimal
    var
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        // -----------------------------------------------------------------------------------------------
        //
        // -----------------------------------------------------------------------------------------------

        lrc_BatchVariant.GET(vco_BatchVariantNo);
        // Filter auf Lagerorte
        IF vco_LocationCode <> '' THEN
            lrc_BatchVariant.SETFILTER("Location Filter", vco_LocationCode);


        // Werte kalkulieren
        lrc_BatchVariant.CALCFIELDS("B.V. FV Reservation (Qty)");

        EXIT(lrc_BatchVariant."B.V. FV Reservation (Qty)");
    end;

    procedure BatchVarFillLocations(vco_BatchVarNo: Code[20]; vco_BatchNo: Code[20]; vco_ItemNo: Code[20]; vco_LocCode: Code[10])
    begin
        // -----------------------------------------------------------------------------------------------
        // Funktion zur Speicherung der Lagerorte einer Positionsvariante
        // -----------------------------------------------------------------------------------------------

        IF (vco_BatchVarNo = '') OR (vco_LocCode = '') THEN
            EXIT;

        IF NOT lrc_BatchVarLocations.GET(vco_BatchVarNo) THEN BEGIN
            lrc_BatchVarLocations.RESET();
            lrc_BatchVarLocations.INIT();
            lrc_BatchVarLocations."Batch Variant No." := vco_BatchVarNo;
            lrc_BatchVarLocations."Batch No." := vco_BatchNo;
            lrc_BatchVarLocations."Item No." := vco_ItemNo;
            lrc_BatchVarLocations."Assigned Locations" := '';
            lrc_BatchVarLocations.INSERT();
        END;

        IF lrc_BatchVarLocations."Assigned Locations" = '' THEN BEGIN
            lrc_BatchVarLocations."Assigned Locations" := '|' + vco_LocCode + '|';
            lrc_BatchVarLocations.MODIFY();
        END ELSE
            IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + vco_LocCode + '|') <= 0 THEN BEGIN
                lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + vco_LocCode + '|', 1, 150);
                lrc_BatchVarLocations.MODIFY();
            END;
    end;

    procedure BatchVarFillLocationsUpdAll()
    var
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        // -----------------------------------------------------------------------------------------------
        // Funktion zur Speicherung der Lagerorte für alle Positionsvarianten
        // -----------------------------------------------------------------------------------------------

        lrc_BatchVarLocations.RESET();
        lrc_BatchVarLocations.DELETEALL();
        COMMIT();

        IF lrc_BatchVariant.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF NOT lrc_BatchVarLocations.GET(lrc_BatchVariant."No.") THEN BEGIN
                    lrc_BatchVarLocations.RESET();
                    lrc_BatchVarLocations.INIT();
                    lrc_BatchVarLocations."Batch Variant No." := lrc_BatchVariant."No.";
                    lrc_BatchVarLocations."Batch No." := lrc_BatchVariant."Batch No.";
                    lrc_BatchVarLocations."Item No." := lrc_BatchVariant."Item No.";
                    lrc_BatchVarLocations.INSERT();
                END;

                lrc_BatchVarLocations."Assigned Locations" := '';

                // Suche in Einkauf
                lrc_PurchaseLine.SETCURRENTKEY("POI Batch Variant No.");
                lrc_PurchaseLine.SETRANGE("POI Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
                IF lrc_PurchaseLine.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_PurchaseLine."Location Code" + '|') <= 0 THEN
                            IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                                lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_PurchaseLine."Location Code" + '|'
                            ELSE
                                lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_PurchaseLine."Location Code" + '|', 1, 150);
                    UNTIL lrc_PurchaseLine.NEXT() = 0;


                // Suche in Umlagerungen
                lrc_TransferLine.SETRANGE("POI Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
                IF lrc_TransferLine.FINDSET(FALSE, FALSE) THEn
                    REPEAT
                        IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_TransferLine."Transfer-from Code" + '|') <= 0 THEN
                            IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                                lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_TransferLine."Transfer-from Code" + '|'
                            ELSE
                                lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_TransferLine."Transfer-from Code" + '|', 1, 150);
                        IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_TransferLine."Transfer-to Code" + '|') <= 0 THEN
                            IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                                lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_TransferLine."Transfer-to Code" + '|'
                            ELSE
                                lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_TransferLine."Transfer-to Code" + '|', 1, 150);

                    UNTIL lrc_TransferLine.NEXT() = 0;

                // Suche in Packerei Output
                lrc_PackOrderOutputItems.SETCURRENTKEY("Batch Variant No.");
                lrc_PackOrderOutputItems.SETRANGE("Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
                IF lrc_PackOrderOutputItems.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_PackOrderOutputItems."Location Code" + '|') <= 0 THEN
                            IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                                lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_PackOrderOutputItems."Location Code" + '|'
                            ELSE
                                lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_PackOrderOutputItems."Location Code" + '|', 1, 150);
                    UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

                // Suche in Artikelposten
                lrc_ItemLedgerEntry.SETCURRENTKEY("POI Batch Variant No.");
                lrc_ItemLedgerEntry.SETRANGE("POI Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
                IF lrc_ItemLedgerEntry.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_ItemLedgerEntry."Location Code" + '|') <= 0 THEN
                            IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                                lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_ItemLedgerEntry."Location Code" + '|'
                            ELSE
                                lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_ItemLedgerEntry."Location Code" + '|', 1, 150);
                    UNTIL lrc_ItemLedgerEntry.NEXT() = 0;

                // Suche in VK-Gutschriften (nicht gebucht)
                lrc_SalesLine.SETCURRENTKEY("POI Batch No.", "POI Batch Variant No.");
                lrc_SalesLine.SETRANGE("POI Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
                lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::"Credit Memo");
                IF lrc_SalesLine.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_SalesLine."Location Code" + '|') <= 0 THEN
                            IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                                lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_SalesLine."Location Code" + '|'
                            ELSE
                                lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_SalesLine."Location Code" + '|', 1, 150);
                    UNTIL lrc_SalesLine.NEXT() = 0;


                lrc_BatchVarLocations.MODIFY();
            UNTIL lrc_BatchVariant.NEXT() = 0;
    end;

    procedure BatchVarFillLocationsUpd(var rrc_BatchVariant: Record "POI Batch Variant")
    begin
        // -----------------------------------------------------------------------------------------------
        // Funktion zur Speicherung der Lagerorte für alle Positionsvarianten
        // -----------------------------------------------------------------------------------------------

        IF lrc_BatchVarLocations.GET(rrc_BatchVariant."No.") THEN
            lrc_BatchVarLocations.DELETE();

        lrc_BatchVarLocations.INIT();
        lrc_BatchVarLocations."Batch Variant No." := rrc_BatchVariant."No.";
        lrc_BatchVarLocations."Batch No." := rrc_BatchVariant."Batch No.";
        lrc_BatchVarLocations."Item No." := rrc_BatchVariant."Item No.";
        lrc_BatchVarLocations.INSERT();

        lrc_BatchVarLocations."Assigned Locations" := '';

        // Suche in Einkauf
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETCURRENTKEY("POI Batch Variant No.", Type, "No.", "Document Type");
        lrc_PurchaseLine.SETRANGE("POI Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
        IF lrc_PurchaseLine.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF lrc_PurchaseLine."Location Code" <> '' THEN
                    IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_PurchaseLine."Location Code" + '|') <= 0 THEN
                        IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                            lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_PurchaseLine."Location Code" + '|'
                        ELSE
                            lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_PurchaseLine."Location Code" + '|', 1, 150);
            UNTIL lrc_PurchaseLine.NEXT() = 0;

        // Suche in Umlagerungen
        lrc_PurchaseLine.RESET();
        lrc_TransferLine.SETRANGE("POI Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
        IF lrc_TransferLine.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF lrc_TransferLine."Transfer-from Code" <> '' THEN
                    IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_TransferLine."Transfer-from Code" + '|') <= 0 THEN
                        IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                            lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_TransferLine."Transfer-from Code" + '|'
                        ELSE
                            lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_TransferLine."Transfer-from Code" + '|', 1, 150);
                IF lrc_TransferLine."Transfer-to Code" <> '' THEN
                    IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_TransferLine."Transfer-to Code" + '|') <= 0 THEN
                        IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                            lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_TransferLine."Transfer-to Code" + '|'
                        ELSE
                            lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_TransferLine."Transfer-to Code" + '|', 1, 150);
            UNTIL lrc_TransferLine.NEXT() = 0;


        // Suche in Packerei Output
        lrc_PackOrderOutputItems.RESET();
        lrc_PackOrderOutputItems.SETCURRENTKEY("Batch Variant No.");
        lrc_PackOrderOutputItems.SETRANGE("Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
        IF lrc_PackOrderOutputItems.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF lrc_PackOrderOutputItems."Location Code" <> '' THEN
                    IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_PackOrderOutputItems."Location Code" + '|') <= 0 THEN
                        IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                            lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_PackOrderOutputItems."Location Code" + '|'
                        ELSE
                            lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_PackOrderOutputItems."Location Code" + '|', 1, 150);
            UNTIL lrc_PackOrderOutputItems.NEXT() = 0;


        // Suche in Artikelposten
        lrc_ItemLedgerEntry.RESET();
        lrc_ItemLedgerEntry.SETCURRENTKEY("POI Batch Variant No.", "Item No.", "Variant Code",
                                          "Entry Type", "Location Code", "Posting Date");
        lrc_ItemLedgerEntry.SETRANGE("POI Batch Variant No.", lrc_BatchVarLocations."Batch Variant No.");
        IF lrc_ItemLedgerEntry.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF lrc_ItemLedgerEntry."Location Code" <> '' THEN
                    IF STRPOS(lrc_BatchVarLocations."Assigned Locations", '|' + lrc_ItemLedgerEntry."Location Code" + '|') <= 0 THEN
                        IF lrc_BatchVarLocations."Assigned Locations" = '' THEN
                            lrc_BatchVarLocations."Assigned Locations" := '|' + lrc_ItemLedgerEntry."Location Code" + '|'
                        ELSE
                            lrc_BatchVarLocations."Assigned Locations" := copystr(lrc_BatchVarLocations."Assigned Locations" + lrc_ItemLedgerEntry."Location Code" + '|', 1, 150);
            UNTIL lrc_ItemLedgerEntry.NEXT() = 0;


        lrc_BatchVarLocations.MODIFY();
    end;

    procedure BatchVarGetLocations(vco_BatchVarNo: Code[20]; var rco_ArrLocationCode: array[20] of Code[10])
    var
        lco_LocationAssigned: Code[100];
        lin_ArrCounter: Integer;
        lin_PosCol: Integer;
        lbn_Loop: Boolean;
    begin

        CLEAR(rco_ArrLocationCode);

        IF NOT lrc_BatchVarLocations.GET(vco_BatchVarNo) THEN
            EXIT;
        lco_LocationAssigned := copystr(lrc_BatchVarLocations."Assigned Locations", 1, 100);
        IF COPYSTR(lco_LocationAssigned, 1, 1) <> '|' THEN
            EXIT;
        lco_LocationAssigned := COPYSTR(lco_LocationAssigned, 2, 100);

        lin_ArrCounter := 0;
        lbn_Loop := TRUE;
        WHILE lbn_Loop = TRUE DO BEGIN
            lin_PosCol := STRPOS(lco_LocationAssigned, '|');
            IF lin_PosCol > 0 THEN BEGIN
                lin_ArrCounter := lin_ArrCounter + 1;
                rco_ArrLocationCode[lin_ArrCounter] := copystr(COPYSTR(lco_LocationAssigned, 1, (lin_PosCol - 1)), 1, MaxStrLen(rco_ArrLocationCode[lin_ArrCounter]));
                lco_LocationAssigned := COPYSTR(lco_LocationAssigned, (lin_PosCol + 1), 100);
            END ELSE
                lbn_Loop := FALSE;
        END;
    end;

    procedure BatchVarPurchLineShowValues(vrc_PurchLine: Record "Purchase Line"; var rdc_QtyInSalesOrder: Decimal; var rdc_QtyInSalesShipment: Decimal; var rdc_QtyInSalesInvoice: Decimal; var rdc_QtyInSalesReservation: Decimal; var rdc_QtyInPackOrderInput: Decimal; var rdc_QtyInPurchClaimOrder: Decimal; var rdc_QtyInCustClearanceOrder: Decimal)
    var
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        // -----------------------------------------------------------------------------------------------
        // Mengen in Einkaufszeile anzeigen
        // -----------------------------------------------------------------------------------------------
        // rdc_QtyInSalesOrder
        // rdc_QtyInSalesShipment
        // rdc_QtyInSalesInvoice
        // rdc_QtyInSalesReservation
        // rdc_QtyInPackOrderInput
        // rdc_QtyInPurchClaimOrder
        // rdc_QtyInCustClearanceOrder
        // -----------------------------------------------------------------------------------------------

        rdc_QtyInSalesOrder := 0;
        rdc_QtyInSalesShipment := 0;
        rdc_QtyInSalesInvoice := 0;
        rdc_QtyInSalesReservation := 0;
        rdc_QtyInPackOrderInput := 0;
        rdc_QtyInPurchClaimOrder := 0;
        rdc_QtyInCustClearanceOrder := 0;

        IF (vrc_PurchLine.Type <> vrc_PurchLine.Type::Item) OR
           (vrc_PurchLine."No." = '') THEN
            EXIT;

        IF vrc_PurchLine."POI Batch Variant No." = '' THEN
            EXIT;

        IF NOT lrc_BatchVariant.GET(vrc_PurchLine."POI Batch Variant No.") THEN BEGIN
            MESSAGE('Pos.-Var. Nr. %1 Nicht vorhanden!', vrc_PurchLine."POI Batch Variant No.");
            EXIT;
        END;

        lrc_BatchVariant.CALCFIELDS("B.V. Sales Order (Qty)", "B.V. Sales Shipped (Qty)",
                                   "B.V. Sales Inv. (Qty.)", "B.V. FV Reservation (Qty)",
                                   "B.V. Pack. Input (Qty)", "B.V. Purch. Claim (Qty.)",
                                   "B.V. Customer Clearance (Qty.)");

        IF vrc_PurchLine."Qty. per Unit of Measure" <> 0 THEN BEGIN
            rdc_QtyInSalesOrder := ROUND(lrc_BatchVariant."B.V. Sales Order (Qty)" / vrc_PurchLine."Qty. per Unit of Measure", 0.00001);
            rdc_QtyInSalesShipment := ROUND((lrc_BatchVariant."B.V. Sales Shipped (Qty)" * -1) /
                                             vrc_PurchLine."Qty. per Unit of Measure", 0.00001);
            rdc_QtyInSalesInvoice := ROUND((lrc_BatchVariant."B.V. Sales Inv. (Qty.)" * -1) /
                                            vrc_PurchLine."Qty. per Unit of Measure", 0.00001);
            rdc_QtyInSalesReservation := ROUND(lrc_BatchVariant."B.V. FV Reservation (Qty)" /
                                               vrc_PurchLine."Qty. per Unit of Measure", 0.00001);
            rdc_QtyInPackOrderInput := ROUND(lrc_BatchVariant."B.V. Pack. Input (Qty)" /
                                             vrc_PurchLine."Qty. per Unit of Measure", 0.00001);
            rdc_QtyInPurchClaimOrder := ROUND(lrc_BatchVariant."B.V. Purch. Claim (Qty.)" /
                                              vrc_PurchLine."Qty. per Unit of Measure", 0.00001);
            rdc_QtyInCustClearanceOrder := ROUND(lrc_BatchVariant."B.V. Customer Clearance (Qty.)" /
                                                 vrc_PurchLine."Qty. per Unit of Measure", 0.00001);
        END;
    end;

    procedure ItemQtyReqLine(vco_ItemNo: Code[20]; vco_LocationCode: Code[10]; vdt_RefDate: Date; var rdc_QtyStock: Decimal; var rdc_QtySalesOrder: Decimal)
    var
        lrc_Item: Record Item;
    begin
        // -----------------------------------------------------------------------------------------------
        // Mengen zur Anzeige im Bestellvorschlag berechnen
        // -----------------------------------------------------------------------------------------------

        IF NOT lrc_Item.GET(vco_ItemNo) THEN
            EXIT;

        IF vco_LocationCode <> '' THEN
            lrc_Item.SETFILTER("Location Filter", '%1', vco_LocationCode);
        IF vdt_RefDate <> 0D THEN
            lrc_Item.SETFILTER("Date Filter", '..%1', vdt_RefDate);

        lrc_Item.CALCFIELDS(Inventory, "Qty. on Sales Order");

        rdc_QtyStock := lrc_Item.Inventory;
        rdc_QtySalesOrder := lrc_Item."Qty. on Sales Order";
    end;

    procedure "-- DIVERS FUNCTIONS --"()
    begin
    end;

    procedure GetLocFilter(vco_LocationCode: Code[10]): Code[1024]
    var
        lrc_Location: Record "Location";
        lco_LocationFilter: Code[1024];
    begin
        // -----------------------------------------------------------------------------------------------
        // Funktion zur Erstellung eines Filters in Abhängigkeit der Einstellung für den Ausgangslagerort
        // -----------------------------------------------------------------------------------------------

        lrc_Location.GET(vco_LocationCode);

        CASE lrc_Location."POI Level Stock Control" OF
            lrc_Location."POI Level Stock Control"::Location:
                lco_LocationFilter := lrc_Location.Code;
            lrc_Location."POI Level Stock Control"::"Location Group":
                BEGIN
                    lrc_LocGroupLocs.SETRANGE("Location Group Code", lrc_Location."POI Location Group Code");
                    IF lrc_LocGroupLocs.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            IF lco_LocationFilter = '' THEN
                                lco_LocationFilter := lrc_LocGroupLocs."Location Code"
                            ELSE
                                lco_LocationFilter := copystr(lco_LocationFilter + '|' + lrc_LocGroupLocs."Location Code", 1, 1024);
                        UNTIL lrc_LocGroupLocs.NEXT() = 0;
                END;
            lrc_Location."POI Level Stock Control"::Company:
                lco_LocationFilter := '';
        END;

        EXIT(lco_LocationFilter);
    end;

    procedure CheckItemAvailible(rco_ItemNo: Code[20]; rco_VariantCode: Code[10]; rco_LocationCode: Code[10]; rco_BatchVariantCode: Code[20]; rop_Pruefungsart: Option Bestand,"Verfügbarer Bestand","erwarteter Verfügbarer Bestand")
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_Item: Record Item;
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_Location: Record "Location";
        SSPText01Txt: Label 'Artikel %1, Positionsvariante %2, Lagerort %3 : Es ist nicht genügend Bestand zum Buchen vorhanden !', Comment = '%1 %2 %3';
        SSPText02Txt: Label 'Artikel %1, Positionsvariante %2 : Es ist nicht genügend Bestand zum Buchen vorhanden auf %3!', Comment = '%1 %2 %3';
        SSPText03Txt: Label 'Artikel %1, Lagerort %2 : Es ist nicht genügend Bestand zum Buchen vorhanden !', Comment = '%1 %2 ';
        SSPText04Txt: Label 'Artikel %1 : Es ist nicht genügend Bestand zum Buchen vorhanden auf %2!', Comment = '%1 %2 ';
        ldc_Bestand: Decimal;
        ldc_BestandVerf: Decimal;
        ldc_ErwBestandVerf: Decimal;
        ldc_Pruefungswert: Decimal;
    begin
        // -----------------------------------------------------------------------------------------------
        // Artikel Bestandsprüfung
        // -----------------------------------------------------------------------------------------------

        lrc_Location.GET(rco_LocationCode);
        lrc_Item.GET(rco_ItemNo);

        ldc_Bestand := 0;
        ldc_BestandVerf := 0;
        ldc_ErwBestandVerf := 0;

        IF lrc_Item."POI Batch Item" = TRUE THEN BEGIN

            lrc_BatchSetup.GET();

            lrc_BatchVariant.GET(rco_BatchVariantCode);
            IF (lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::Location) OR
               (lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::"Location Group") THEN
                lrc_BatchVariant.SETRANGE("Location Filter", rco_LocationCode);

            lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)",
                                         "B.V. Purch. Order (Qty)",
                                         "B.V. Sales Order (Qty)",
                                         "B.V. FV Reservation (Qty)",
                                         "B.V. Transfer Rec. (Qty)",
                                         "B.V. Transfer Ship (Qty)",
                                         "B.V. Transfer in Transit (Qty)",
                                         "B.V. Pack. Input (Qty)",
                                         "B.V. Pack. Pack.-Input (Qty)",
                                         "B.V. Pack. Output (Qty)",
                                         "B.V. Purch. Cr. Memo (Qty)",
                                         "B.V. Sales Cr. Memo (Qty)");

            ldc_Bestand := lrc_BatchVariant."B.V. Inventory (Qty.)";

            ldc_BestandVerf := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                               lrc_BatchVariant."B.V. Sales Order (Qty)" -
                               lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                               lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                               lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)" -
                               lrc_BatchVariant."B.V. Transfer Ship (Qty)";

            ldc_ErwBestandVerf := lrc_BatchVariant."B.V. Inventory (Qty.)" +
                                  lrc_BatchVariant."B.V. Purch. Order (Qty)" +
                                  lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                                  // lrc_BatchVariant."B.V. Transfer in Transit (Qty)" -
                                  lrc_BatchVariant."B.V. Transfer in Transit (Qty)" +
                                  lrc_BatchVariant."B.V. Pack. Output (Qty)" -
                                  lrc_BatchVariant."B.V. Sales Order (Qty)" -
                                  lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                                  lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                                  lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)" -
                                  lrc_BatchVariant."B.V. Transfer Ship (Qty)";

            IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
                ldc_BestandVerf := ldc_BestandVerf + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

            // Erw. Verf. Bestand inkl. Verkaufsgutschriften
            IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
                ldc_ErwBestandVerf := ldc_ErwBestandVerf + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

            IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
                ldc_BestandVerf := ldc_BestandVerf - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

            IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
                ldc_ErwBestandVerf := ldc_ErwBestandVerf - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

            CASE rop_Pruefungsart OF
                rop_Pruefungsart::Bestand:
                    ldc_Pruefungswert := ldc_Bestand;
                rop_Pruefungsart::"Verfügbarer Bestand":
                    ldc_Pruefungswert := ldc_BestandVerf;
                rop_Pruefungsart::"erwarteter Verfügbarer Bestand":
                    ldc_Pruefungswert := ldc_ErwBestandVerf;
            END;

            IF (ldc_Pruefungswert < 0) THEN
                // 'Es ist nicht genügend Bestand zum Buchen vorhanden!'
                IF (lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::Location) OR
                   (lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::"Location Group") THEN
                    ERROR(SSPText01Txt, rco_ItemNo, rco_BatchVariantCode, rco_LocationCode)
                ELSE
                    ERROR(SSPText02Txt, rco_ItemNo, rco_BatchVariantCode, rco_LocationCode);


        END ELSE BEGIN
            lrc_Item.SETRANGE("Variant Filter", rco_VariantCode);
            IF (lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::Location) OR
               (lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::"Location Group") THEN
                lrc_Item.SETRANGE("Location Filter", rco_LocationCode);

            lrc_Item.CALCFIELDS(Inventory, "Reserved Qty. on Inventory",
                                 "Qty. on Purch. Order",
                                 "Trans. Ord. Receipt (Qty.)",
                                 "POI Qty. on Packing Output",
                                 "Qty. on Prod. Order",
                                 "Qty. on Sales Order",
                                 "POI Qty. on Reservation (FV)",
                                 "POI Qty. on Packing Input",
                                 "POI Qty. on Pack PackItem Inp",
                                 "Qty. on Component Lines",
                                 "Trans. Ord. Shipment (Qty.)");

            ldc_Bestand := lrc_Item.Inventory - lrc_Item."Reserved Qty. on Inventory";

            ldc_BestandVerf := lrc_Item.Inventory -
                               lrc_Item."Reserved Qty. on Inventory" -
                               lrc_Item."Qty. on Sales Order" -
                               lrc_Item."POI Qty. on Reservation (FV)" -
                               lrc_Item."POI Qty. on Packing Input" -
                               lrc_Item."POI Qty. on Pack PackItem Inp" -
                               lrc_Item."Qty. on Component Lines" -
                               lrc_Item."Trans. Ord. Shipment (Qty.)";

            ldc_ErwBestandVerf := lrc_Item.Inventory +
                                  lrc_Item."Reserved Qty. on Inventory" -
                                  lrc_Item."Qty. on Purch. Order" +
                                  lrc_Item."Trans. Ord. Receipt (Qty.)" +
                                  lrc_Item."POI Qty. on Packing Output" -
                                  lrc_Item."Qty. on Prod. Order" -
                                  lrc_Item."Qty. on Sales Order" -
                                  lrc_Item."POI Qty. on Reservation (FV)" -
                                  lrc_Item."POI Qty. on Packing Input" -
                                  lrc_Item."POI Qty. on Pack PackItem Inp" -
                                  lrc_Item."Qty. on Component Lines" -
                                  lrc_Item."Trans. Ord. Shipment (Qty.)";

            CASE rop_Pruefungsart OF
                rop_Pruefungsart::Bestand:
                    ldc_Pruefungswert := ldc_Bestand;
                rop_Pruefungsart::"Verfügbarer Bestand":
                    ldc_Pruefungswert := ldc_BestandVerf;
                rop_Pruefungsart::"erwarteter Verfügbarer Bestand":
                    ldc_Pruefungswert := ldc_ErwBestandVerf;
            END;

            IF (ldc_Pruefungswert < 0) THEN
                IF (lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::Location) OR
                   (lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::"Location Group") THEN
                    ERROR(SSPText03Txt, rco_ItemNo, rco_LocationCode)
                ELSE
                    ERROR(SSPText04Txt, rco_ItemNo, rco_LocationCode);
        END;

    end;

    procedure CheckBatchVariantAvailible(vco_ItemNo: Code[20]; vco_VariantCode: Code[10]; vco_BatchVariantCode: Code[20]; vco_LocationCode: Code[10]; vdt_ShipmentDate: Date)
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lrc_Item: Record Item;
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_Location: Record "Location";
        lco_LocLocationGroup: Code[150];
        ldc_Bestand: Decimal;
        ldc_BestandVerf: Decimal;
        ldc_ErwBestandVerf: Decimal;
    // ldc_Pruefungswert: Decimal;
    // SSPText01Txt: Label 'Artikel %1, Positionsvariante %2, Lagerort %3 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    // SSPText02Txt: Label 'Artikel %1, Positionsvariante %2 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    // SSPText03Txt: Label 'Artikel %1, Lagerort %2 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    // SSPText04Txt: Label 'Artikel %1 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    begin
        // -----------------------------------------------------------------------------------------------
        // Positionsvariante Bestandsprüfung
        // -----------------------------------------------------------------------------------------------

        ldc_Bestand := 0;
        ldc_BestandVerf := 0;
        ldc_ErwBestandVerf := 0;

        lrc_Item.GET(vco_ItemNo);
        IF lrc_Item."POI Batch Item" = FALSE THEN
            EXIT;

        // Positionsvariante lesen
        lrc_BatchVariant.GET(vco_BatchVariantCode);

        lrc_BatchSetup.GET();

        // Lagerort lesen und Filter setzen
        IF lrc_Location.GET(vco_LocationCode) THEN
            CASE lrc_Location."POI Level Stock Control" OF
                lrc_Location."POI Level Stock Control"::Location:
                    lrc_BatchVariant.SETRANGE("Location Filter", lrc_Location.Code);
                lrc_Location."POI Level Stock Control"::"Location Group":
                    BEGIN
                        lrc_Location.TESTFIELD("POI Location Group Code");
                        lrc_LocationGroupLocations.SETRANGE("Location Group Code", lrc_Location."POI Location Group Code");
                        IF lrc_LocationGroupLocations.FINDSET(FALSE, FALSE) THEN begin
                            REPEAT
                                IF lco_LocLocationGroup = '' THEN
                                    lco_LocLocationGroup := lrc_LocationGroupLocations."Location Code"
                                ELSE
                                    lco_LocLocationGroup := copystr(lco_LocLocationGroup + '|' + lrc_LocationGroupLocations."Location Code", 1, 150);
                            UNTIL lrc_LocationGroupLocations.NEXT() = 0;
                            lrc_BatchVariant.SETFILTER("Location Filter", lco_LocLocationGroup);
                        END;
                    END;
                lrc_Location."POI Level Stock Control"::Company:
                    lrc_BatchVariant.SETRANGE("Location Filter");
            END;

        // Warenausgangsdatum setzen
        //IF vdt_ShipmentDate <> 0D THEN
        //  lrc_BatchVariant.SETFILTER("Date Filter",'..%1',vdt_ShipmentDate);
        lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)",
                                    "B.V. Purch. Order (Qty)",
                                    "B.V. Sales Order (Qty)",
                                    "B.V. FV Reservation (Qty)",
                                    "B.V. Transfer Rec. (Qty)",
                                    "B.V. Transfer Ship (Qty)",
                                    "B.V. Transfer in Transit (Qty)",
                                    "B.V. Pack. Input (Qty)",
                                    "B.V. Pack. Pack.-Input (Qty)",
                                    "B.V. Pack. Output (Qty)",
                                    "B.V. Purch. Cr. Memo (Qty)",
                                    "B.V. Sales Cr. Memo (Qty)");

        ldc_Bestand := lrc_BatchVariant."B.V. Inventory (Qty.)";

        ldc_BestandVerf := lrc_BatchVariant."B.V. Inventory (Qty.)" -
                           lrc_BatchVariant."B.V. Sales Order (Qty)" -
                           lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                           lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                           lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)" -
                           lrc_BatchVariant."B.V. Transfer Ship (Qty)";

        ldc_ErwBestandVerf := lrc_BatchVariant."B.V. Inventory (Qty.)" +
                              lrc_BatchVariant."B.V. Purch. Order (Qty)" +
                              lrc_BatchVariant."B.V. Transfer Rec. (Qty)" +
                              // lrc_BatchVariant."B.V. Transfer in Transit (Qty)" -
                              lrc_BatchVariant."B.V. Transfer in Transit (Qty)" +
                              lrc_BatchVariant."B.V. Pack. Output (Qty)" -
                              lrc_BatchVariant."B.V. Sales Order (Qty)" -
                              lrc_BatchVariant."B.V. FV Reservation (Qty)" -
                              lrc_BatchVariant."B.V. Pack. Input (Qty)" -
                              lrc_BatchVariant."B.V. Pack. Pack.-Input (Qty)" -
                              lrc_BatchVariant."B.V. Transfer Ship (Qty)";

        IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN
            ldc_BestandVerf := ldc_BestandVerf + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";

        // Erw. Verf. Bestand inkl. Verkaufsgutschriften
        IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
            ldc_ErwBestandVerf := ldc_ErwBestandVerf + lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";
        IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN
            ldc_BestandVerf := ldc_BestandVerf - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";
        IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
            ldc_ErwBestandVerf := ldc_ErwBestandVerf - lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";
    end;

    procedure ShowStockItems()
    begin
    end;

    procedure Load_UserID_LocationGroup(var rco_LocationGroupFilter: Code[1024]; var rco_LocationFilter: Code[1024]; vco_UserID: Code[20])
    var
        lrc_UserSetup: Record "User Setup";
    begin
        // ----------------------------------------------------------------------------------------------------------
        //
        // ----------------------------------------------------------------------------------------------------------
        rco_LocationGroupFilter := '';
        rco_LocationFilter := '';

        IF lrc_UserSetup.GET(vco_UserID) THEN
            IF (lrc_UserSetup."POI Loc Group Filter Sales" <> '') OR
               (lrc_UserSetup."POI Loc Group Filter Decay" <> '') THEN BEGIN

                IF lrc_UserSetup."POI Loc Group Filter Sales" <> '' THEN BEGIN
                    lrc_LocationGroupLocations.RESET();
                    lrc_LocationGroupLocations.SETRANGE("Location Group Code", lrc_UserSetup."POI Loc Group Filter Sales");
                    IF lrc_LocationGroupLocations.FIND('-') THEN BEGIN
                        IF rco_LocationGroupFilter = '' THEn
                            rco_LocationGroupFilter := lrc_UserSetup."POI Loc Group Filter Sales"
                        ELSE
                            rco_LocationGroupFilter := copystr(rco_LocationGroupFilter + '|' + lrc_UserSetup."POI Loc Group Filter Sales", 1, 1024);

                        REPEAT
                            IF rco_LocationFilter = '' THEn
                                rco_LocationFilter := lrc_LocationGroupLocations."Location Code"
                            ELSE
                                rco_LocationFilter := copystr(rco_LocationFilter + '|' + lrc_LocationGroupLocations."Location Code", 1, 1024);

                        UNTIL lrc_LocationGroupLocations.NEXT() = 0;
                    END;
                END;

                IF lrc_UserSetup."POI Loc Group Filter Decay" <> '' THEN BEGIN
                    lrc_LocationGroupLocations.RESET();
                    lrc_LocationGroupLocations.SETRANGE("Location Group Code", lrc_UserSetup."POI Loc Group Filter Decay");
                    IF lrc_LocationGroupLocations.FINDSET(FALSE, FALSE) THEN BEGIN
                        IF rco_LocationGroupFilter = '' THEN
                            rco_LocationGroupFilter := lrc_UserSetup."POI Loc Group Filter Decay"
                        ELSE
                            rco_LocationGroupFilter := copystr(rco_LocationGroupFilter + '|' + lrc_UserSetup."POI Loc Group Filter Decay", 1, 1024);
                        REPEAT
                            IF rco_LocationFilter = '' THEN
                                rco_LocationFilter := lrc_LocationGroupLocations."Location Code"
                            ELSE
                                rco_LocationFilter := copystr(rco_LocationFilter + '|' + lrc_LocationGroupLocations."Location Code", 1, 1024);
                        UNTIL lrc_LocationGroupLocations.NEXT() = 0;
                    END;
                END;
            END;
    end;

    procedure Is_Valid_UserID_LocationFilter(vco_LocationFilter: Code[1024]; vco_UserID: Code[20]): Boolean
    var
        lrc_UserSetup: Record "User Setup";
        lco_LocationGroupFilter: Code[1024];
        lco_LocationFilter: Code[1024];
        lco_Location: Code[10];
    begin

        IF vco_LocationFilter <> '' THEN
            IF lrc_UserSetup.GET(vco_UserID) THEN
                IF (lrc_UserSetup."POI Loc Group Filter Sales" <> '') OR (lrc_UserSetup."POI Loc Group Filter Decay" <> '') THEN BEGIN
                    Load_UserID_LocationGroup(lco_LocationGroupFilter, lco_LocationFilter, vco_UserID);
                    IF lco_LocationFilter <> '' THEN
                        IF STRPOS(vco_LocationFilter, '|') = 0 THEN BEGIN
                            lco_Location := copystr(vco_LocationFilter, 1, 10);
                            IF STRPOS(lco_LocationFilter, lco_Location) = 0 THEN
                                EXIT(FALSE);
                        END ELSE BEGIN
                            REPEAT
                                lco_Location := copystr(COPYSTR(vco_LocationFilter, 1, STRPOS(vco_LocationFilter, '|') - 1), 1, 10);
                                vco_LocationFilter := copystr(COPYSTR(vco_LocationFilter, STRPOS(vco_LocationFilter, '|') + 1), 1, 1024);
                                IF STRPOS(lco_LocationFilter, lco_Location) = 0 THEN
                                    EXIT(FALSE);
                            UNTIL STRPOS(vco_LocationFilter, '|') = 0;
                            IF (STRPOS(vco_LocationFilter, '|') = 0) AND (vco_LocationFilter <> '') THEN
                                IF STRPOS(lco_LocationFilter, vco_LocationFilter) = 0 THEN
                                    EXIT(FALSE);
                        END;
                END;
        EXIT(TRUE);
    end;

    procedure Stock_OverLocationGroupFilter(vco_LocationCode: Code[10]; vop_SalesDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; vco_SalesOrderNo: Code[20]) lbn_StockOverLocationGroup: Boolean
    var
        lrc_SalesHeader: Record "Sales Header";
        lrc_SalesDocSubtype: Record "POI Sales Doc. Subtype";
        //lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Location: Record "Location";
        lrc_UserSetup: Record "User Setup";
        lco_LocationFilterSales: Code[1024];
        lco_LocationFilterQH: Code[1024];

    begin
        // ----------------------------------------------------------------------------------------------------------
        //
        // ----------------------------------------------------------------------------------------------------------
        // Diese Funktion gibt ein TRUE zurück, wenn entsprechend der Einstellung im OK Button
        // der Forms Strg-P und Strg-M, eine Umsetzung des dort gewählten Lgerortes auf eine
        // Feste Eingrenzung des Verkaufsbeleges besteht und somit der Lagerbestand der Lagergruppe
        // als Lagerbestand bei der Eingabe einer Menge erfolgen muss
        // ----------------------------------------------------------------------------------------------------------

        lbn_StockOverLocationGroup := FALSE;

        IF lrc_SalesHeader.GET(vop_SalesDocumentType, vco_SalesOrderNo) THEN
            IF lrc_SalesDocSubtype.GET(lrc_SalesDocSubtype."Document Type"::Order, lrc_SalesHeader."POI Sales Doc. Subtype Code") THEN
                IF lrc_SalesDocSubtype."Restrict Locations" = lrc_SalesDocSubtype."Restrict Locations"::"Feste Eingrenzung" THEn
                    IF lrc_UserSetup.GET() THEN BEGIN
                        lrc_SalesDocSubtypeFilter.RESET();
                        lrc_SalesDocSubtypeFilter.SETRANGE("Document Type", lrc_SalesDocSubtypeFilter."Document Type"::Order);
                        lrc_SalesDocSubtypeFilter.SETRANGE("Sales Doc. Subtype Code", lrc_SalesHeader."POI Sales Doc. Subtype Code");
                        lrc_SalesDocSubtypeFilter.SETRANGE(Source, lrc_SalesDocSubtypeFilter.Source::Location);
                        IF lrc_SalesDocSubtypeFilter.FINDFIRST() THEN
                            IF lrc_SalesDocSubtypeFilter.COUNTAPPROX() = 1 THEN
                                IF lrc_Location.GET(vco_LocationCode) THEN
                                    IF lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::"Location Group" THEN
                                        IF (lrc_UserSetup."POI Loc Group Filter Sales" = lrc_Location."POI Location Group Code") OR
                                           (lrc_UserSetup."POI Loc Group Filter Decay" = lrc_Location."POI Location Group Code") THEN
                                            lbn_StockOverLocationGroup := TRUE
                                        ELSE BEGIN
                                            IF lrc_UserSetup."POI Loc Group Filter Sales" <> '' THEN BEGIN
                                                lco_LocationFilterSales := '';
                                                lrc_LocationGroupLocations.RESET();
                                                lrc_LocationGroupLocations.SETFILTER("Location Group Code", lrc_UserSetup."POI Loc Group Filter Sales");
                                                IF lrc_LocationGroupLocations.FINDSET(FALSE, FALSE) THEN
                                                    REPEAT
                                                        IF lco_LocationFilterSales = '' THEN
                                                            lco_LocationFilterSales := lrc_LocationGroupLocations."Location Code"
                                                        ELSE
                                                            lco_LocationFilterSales := copystr(lco_LocationFilterSales + '|' + lrc_LocationGroupLocations."Location Code", 1, 1024);
                                                    UNTIL lrc_LocationGroupLocations.NEXT() = 0;
                                            END;

                                            IF lrc_UserSetup."POI Loc Group Filter Decay" <> '' THEN BEGIN
                                                lco_LocationFilterQH := '';
                                                lrc_LocationGroupLocations.RESET();
                                                lrc_LocationGroupLocations.SETFILTER("Location Group Code", lrc_UserSetup."POI Loc Group Filter Decay");
                                                IF lrc_LocationGroupLocations.FINDSET(FALSE, FALSE) THEN
                                                    REPEAT
                                                        IF lco_LocationFilterQH = '' THEN
                                                            lco_LocationFilterQH := lrc_LocationGroupLocations."Location Code"
                                                        ELSE
                                                            lco_LocationFilterQH := copystr(lco_LocationFilterQH + '|' + lrc_LocationGroupLocations."Location Code", 1, 1024);
                                                    UNTIL lrc_LocationGroupLocations.NEXT() = 0;
                                            END;

                                            IF STRPOS(vco_LocationCode, lco_LocationFilterSales) > 0 THEN BEGIN
                                                lrc_SalesDocSubtypeFilter.RESET();
                                                lrc_SalesDocSubtypeFilter.SETRANGE("Document Type", lrc_SalesDocSubtypeFilter."Document Type"::Order);
                                                lrc_SalesDocSubtypeFilter.SETRANGE("Sales Doc. Subtype Code", lrc_SalesHeader."POI Sales Doc. Subtype Code");
                                                lrc_SalesDocSubtypeFilter.SETRANGE(Source, lrc_SalesDocSubtypeFilter.Source::Location);
                                                lrc_SalesDocSubtypeFilter.SETFILTER("Source No.", lco_LocationFilterSales);
                                                IF lrc_SalesDocSubtypeFilter.FINDFIRST() THEN
                                                    IF lrc_SalesDocSubtypeFilter.COUNTAPPROX() = 1 THEN
                                                        IF lrc_Location.GET(vco_LocationCode) THEN
                                                            IF lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::"Location Group" THEN
                                                                IF (lrc_UserSetup."POI Loc Group Filter Sales" = lrc_Location."POI Location Group Code") THEn
                                                                    lbn_StockOverLocationGroup := TRUE
                                            END ELSE
                                                IF STRPOS(vco_LocationCode, lco_LocationFilterQH) > 0 THEN BEGIN
                                                    lrc_SalesDocSubtypeFilter.RESET();
                                                    lrc_SalesDocSubtypeFilter.SETRANGE("Document Type", lrc_SalesDocSubtypeFilter."Document Type"::Order);
                                                    lrc_SalesDocSubtypeFilter.SETRANGE("Sales Doc. Subtype Code", lrc_SalesHeader."POI Sales Doc. Subtype Code");
                                                    lrc_SalesDocSubtypeFilter.SETRANGE(Source, lrc_SalesDocSubtypeFilter.Source::Location);
                                                    lrc_SalesDocSubtypeFilter.SETFILTER("Source No.", lco_LocationFilterQH);
                                                    IF lrc_SalesDocSubtypeFilter.FIND('-') THEN
                                                        IF lrc_SalesDocSubtypeFilter.COUNTAPPROX() = 1 THEN
                                                            IF lrc_Location.GET(vco_LocationCode) THEN
                                                                IF lrc_Location."POI Level Stock Control" = lrc_Location."POI Level Stock Control"::"Location Group" THEN
                                                                    IF (lrc_UserSetup."POI Loc Group Filter Decay" = lrc_Location."POI Location Group Code") THEN
                                                                        lbn_StockOverLocationGroup := TRUE;
                                                END;
                                        END;
                    end;
        EXIT(lbn_StockOverLocationGroup);
    end;

    var
        lrc_BatchVarLocations: Record "POI Batch Var. - Locations";
        lrc_LocationGroupLocations: Record "POI Location Group - Locations";
        lrc_LocGroupLocs: Record "POI Location Group - Locations";
        lrc_SalesDocSubtypeFilter: Record "POI Sales Doc. Subtype Filter";
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_ItemLedgerEntry: Record "Item Ledger Entry";
        lrc_TransferLine: Record "Transfer Line";
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
        lrc_SalesLine: Record "Sales Line";
}

