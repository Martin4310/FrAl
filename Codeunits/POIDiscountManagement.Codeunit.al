codeunit 5110312 "POI Discount Management"
{


    //     // Permissions = TableData 36=rimd,
    //     //               TableData 37=rimd,
    //     //               TableData 38=rimd,
    //     //               TableData 39=rimd,
    //     //               TableData 5110380=rimd,
    //     //               TableData 5110382=rimd;
    //     var
    //         gop_PurchDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Receipt","Posted Invoice","Posted Return Shipment","Posted Credit Memo","Arch. Quote","Arch. Order","Arch. Blanket Order";
    //         gop_SalesDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo","Arch. Quote","Arch. Order","Arch. Blanket Order";
    //         gin_VersionNo: Integer;
    //         gco_LanguageCode: Code[20];


    //     procedure VendorDisc(vco_VendorCode: Code[20]; vco_OrderAdressCode: Code[10])
    //     var
    //         lrc_Vendor: Record Vendor;
    //         lrc_VendorDiscount: Record "5110385";
    //     //lfm_VendorDiscount: Form "5110385";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Kreditorenrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_VendorDiscount.RESET();
    //         lrc_VendorDiscount.FILTERGROUP(2);
    //         lrc_VendorDiscount.SETRANGE(Source, lrc_VendorDiscount.Source::Vendor);
    //         lrc_VendorDiscount.SETRANGE("Source No.", vco_VendorCode);
    //         IF vco_OrderAdressCode <> '' THEN
    //             lrc_VendorDiscount.SETRANGE("Order Address Code", vco_OrderAdressCode);
    //         lrc_VendorDiscount.FILTERGROUP(0);
    //         lfm_VendorDiscount.SETTABLEVIEW(lrc_VendorDiscount);
    //         lfm_VendorDiscount.RUNMODAL();
    //     end;

    //     procedure PurchDisc(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    //     var
    //         lrc_PurchDiscount: Record "5110381";
    //     //lfm_PurchDiscount: Form "5110381";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Einkaufsrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_PurchDiscount.FILTERGROUP(2);
    //         lrc_PurchDiscount.SETRANGE("Document Type", vop_DocType);
    //         lrc_PurchDiscount.SETRANGE("Document No.", vco_DocNo);
    //         lrc_PurchDiscount.FILTERGROUP(0);

    //         lfm_PurchDiscount.SETTABLEVIEW(lrc_PurchDiscount);
    //         lfm_PurchDiscount.RUNMODAL;

    //         // Kontrolle ob Leereinträge vorhanden sind
    //         lrc_PurchDiscount.RESET();
    //         lrc_PurchDiscount.SETRANGE("Document Type", vop_DocType);
    //         lrc_PurchDiscount.SETRANGE("Document No.", vco_DocNo);
    //         lrc_PurchDiscount.SETRANGE("Discount Code", '');
    //         IF NOT lrc_PurchDiscount.isempty()THEN
    //             lrc_PurchDiscount.DELETEALL(TRUE);
    //     end;

    procedure PurchDiscLoad(vrc_PurchHeader: Record "Purchase Header"; vbn_Dialog: Boolean)
    var
        lrc_Vendor: Record Vendor;
        lrc_PurchDiscount: Record "POI Purch. Discount";
        lin_Loops: Integer;

        ADF_LT_TEXT001Txt: Label 'Kreditorenrabatte laden?';
    begin
        // -------------------------------------------------------------------------------------
        // Funktionen zum Laden der Rabatte
        // -------------------------------------------------------------------------------------

        IF vbn_Dialog = TRUE THEN
            // Rechnungsrabatte laden?
            IF NOT CONFIRM(ADF_LT_TEXT001Txt) THEN
                ERROR('');

        // Einkaufskopfsatz lesen
        vrc_PurchHeader.TESTFIELD("Buy-from Vendor No.");
        lrc_Vendor.GET(vrc_PurchHeader."Buy-from Vendor No.");

        // Bestehende Rabattsätze löschen
        lrc_PurchDiscount.RESET();
        lrc_PurchDiscount.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchDiscount.SETRANGE("Document No.", vrc_PurchHeader."No.");
        IF NOT lrc_PurchDiscount.ISEMPTY() THEN
            lrc_PurchDiscount.DELETEALL();

        lin_Loops := 1;
        WHILE lin_Loops <= 3 DO BEGIN

            // Rabatte laden
            CASE lin_Loops OF
                // Kreditorenrabatte laden
                1:
                    BEGIN
                        lrc_VendorDiscount.RESET();
                        lrc_VendorDiscount.SETRANGE(Source, lrc_VendorDiscount.Source::Vendor);
                        lrc_VendorDiscount.SETRANGE("Source No.", vrc_PurchHeader."Buy-from Vendor No.");
                        lrc_VendorDiscount.SETFILTER("Valid from Date", '<=%1', vrc_PurchHeader."Document Date");
                        lrc_VendorDiscount.SETFILTER("Valid to Date", '>=%1|%2', vrc_PurchHeader."Document Date", 0D);
                    END;

                // Kreditorgruppenrabatte laden
                2:
                    BEGIN
                        lrc_VendorDiscount.RESET();
                        lrc_VendorDiscount.SETRANGE(Source, lrc_VendorDiscount.Source::"Vendor Group");
                        lrc_VendorDiscount.SETRANGE("Source No.", lrc_Vendor."POI Vendor Group Code");
                        lrc_VendorDiscount.SETFILTER("Valid from Date", '<=%1', vrc_PurchHeader."Document Date");
                        lrc_VendorDiscount.SETFILTER("Valid to Date", '>=%1|%2', vrc_PurchHeader."Document Date", 0D);
                    END;

                // Kreditorhauptgruppenrabatte laden
                3:
                    BEGIN
                        lrc_VendorDiscount.RESET();
                        lrc_VendorDiscount.SETRANGE(Source, lrc_VendorDiscount.Source::"Vendor Main Group");
                        lrc_VendorDiscount.SETRANGE("Source No.", lrc_Vendor."POI Vendor Main Group Code");
                        lrc_VendorDiscount.SETFILTER("Valid from Date", '<=%1', vrc_PurchHeader."Document Date");
                        lrc_VendorDiscount.SETFILTER("Valid to Date", '>=%1|%2', vrc_PurchHeader."Document Date", 0D);
                    END;

            END;

            IF lrc_VendorDiscount.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    lrc_PurchDiscount.RESET();
                    lrc_PurchDiscount.INIT();
                    lrc_PurchDiscount."Document Type" := vrc_PurchHeader."Document Type";
                    lrc_PurchDiscount."Document No." := vrc_PurchHeader."No.";
                    lrc_PurchDiscount."Entry No." := 0;
                    lrc_PurchDiscount."Calculation Level" := lrc_VendorDiscount."Calculation Level";
                    lrc_PurchDiscount."Discount Code" := lrc_VendorDiscount."Discount Code";
                    lrc_PurchDiscount."Discount Type" := lrc_VendorDiscount."Discount Type";
                    lrc_PurchDiscount."Base Discount Value" := lrc_VendorDiscount."Base Discount Value";
                    lrc_PurchDiscount."Discount Value" := lrc_VendorDiscount."Discount Value";
                    lrc_PurchDiscount."Basis %-Satz inkl. Ums.-St." := lrc_VendorDiscount."Basis %-Satz inkl. Ums.-St.";
                    lrc_PurchDiscount."Payment Timing" := lrc_VendorDiscount."Payment Timing";
                    lrc_PurchDiscount."Currency Code" := vrc_PurchHeader."Currency Code";
                    lrc_PurchDiscount."Currency Factor" := vrc_PurchHeader."Currency Factor";
                    lrc_PurchDiscount."Buy-from Vendor No." := vrc_PurchHeader."Buy-from Vendor No.";
                    lrc_PurchDiscount."Eingrenzung Frachteinheit" := lrc_VendorDiscount."Restrict. Freight Unit";
                    lrc_PurchDiscount."Item No." := lrc_VendorDiscount."Item No.";
                    lrc_PurchDiscount."Product Group Code" := lrc_VendorDiscount."Product Group Code";
                    lrc_PurchDiscount."Item Category Code" := lrc_VendorDiscount."Item Category Code";
                    lrc_PurchDiscount."Discount Depend on Weight" := lrc_VendorDiscount."Discount Depend on Weight";
                    lrc_PurchDiscount."Ref. Disc. Depend on Weight" := lrc_VendorDiscount."Ref. Disc. Depend on Weight";
                    lrc_PurchDiscount."Discount not on Customer Duty" := lrc_VendorDiscount."Discount not on Customer Duty";

                    // BAUSTELLE ???
                    //    IF lrc_CompanyDiscount.Level > 0 THEN
                    //      lrc_PurchDiscount.Level := lrc_VendorDiscount.Level;
                    IF lrc_VendorDiscount."Calculation Level" > 0 THEN
                        lrc_PurchDiscount."Calculation Level" := lrc_VendorDiscount."Calculation Level";
                    lrc_PurchDiscount.INSERT(TRUE);
                UNTIL lrc_VendorDiscount.NEXT() = 0;
            lin_Loops := lin_Loops + 1;
        END;

        // Firmenrabatte laden
        lrc_CompanyDiscount.SETRANGE(Type, lrc_CompanyDiscount.Type::Vendor);
        lrc_CompanyDiscount.SETFILTER("Valid from Date", '<=%1', vrc_PurchHeader."Document Date");
        lrc_CompanyDiscount.SETFILTER("Valid to Date", '>=%1|%2', vrc_PurchHeader."Document Date", 0D);
        IF lrc_CompanyDiscount.FINDSET(FALSE, FALSE) THEN
            REPEAT
                lrc_PurchDiscount.RESET();
                lrc_PurchDiscount.INIT();
                lrc_PurchDiscount."Document Type" := vrc_PurchHeader."Document Type";
                lrc_PurchDiscount."Document No." := vrc_PurchHeader."No.";
                lrc_PurchDiscount."Entry No." := 0;
                lrc_PurchDiscount."Calculation Level" := lrc_CompanyDiscount."Calculation Level";
                lrc_PurchDiscount."Discount Code" := lrc_CompanyDiscount."Discount Code";
                lrc_PurchDiscount."Discount Type" := lrc_CompanyDiscount."Discount Type";
                lrc_PurchDiscount."Base Discount Value" := lrc_CompanyDiscount."Base Discount Value";
                lrc_PurchDiscount."Discount Value" := lrc_CompanyDiscount."Discount Value";
                lrc_PurchDiscount."Basis %-Satz inkl. Ums.-St." := lrc_CompanyDiscount."Basis %-Value incl. VAT";
                lrc_PurchDiscount."Payment Timing" := lrc_CompanyDiscount."Payment Timing";
                lrc_PurchDiscount."Currency Code" := vrc_PurchHeader."Currency Code";
                lrc_PurchDiscount."Currency Factor" := vrc_PurchHeader."Currency Factor";
                lrc_PurchDiscount."Buy-from Vendor No." := vrc_PurchHeader."Buy-from Vendor No.";
                lrc_PurchDiscount."Ref. Disc. Depend on Weight" := lrc_CompanyDiscount."Ref. Disc. Depend on Weight";
                lrc_PurchDiscount.INSERT(TRUE);
            UNTIL lrc_CompanyDiscount.NEXT() = 0;
    end;

    procedure PurchDiscCalcLines(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
    begin
        // -------------------------------------------------------------------------------------
        // Funktion zur Kalkulation der Rabattwerte und zum Schreiben der Zeilen
        // -------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Vend. Discount not Activ" THEN
            EXIT;

        PurchDiscCalc(vop_DocType, vco_DocNo);
        PurchDiscPurchLines(vop_DocType, vco_DocNo);
    end;

    procedure PurchDiscCalc(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_PurchHeader: Record "Purchase Header";
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Disc: Record "POI Discount";
        ldc_WarenRabRechnung: Decimal;
        ldc_RechRabRechnung: Decimal;
        "ldc_Rückstellungsrabatt": Decimal;
        ldc_SumWarenRabRechnung: Decimal;
        ldc_ArrSumDiscLevelPurchLine: array[9] of Decimal;
        lin_StartLevel: Integer;
        lin_AktuellerLevel: Integer;
        ldc_RoundingValue: Decimal;
        lin_PurchLineCount: Integer;
        ldc_DifferenceAmount: Decimal;
        ldc_SplitAmount: Decimal;
        ADF_LT_TEXT001Txt: Label 'Bezugsgröße für Levelabstufung nicht verfügbar!';
        ADF_LT_TEXT002Txt: Label 'Bezugsgröße für Einkauf nicht verfügbar!';
    begin
        // -------------------------------------------------------------------------------------
        // Funktion zur Kalkulation der Rabattwerte
        // -------------------------------------------------------------------------------------

        IF NOT lrc_PurchHeader.GET(vop_DocType, vco_DocNo) THEN
            EXIT;

        lrc_PurchDiscLine.RESET();
        lrc_PurchDiscLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchDiscLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        lrc_PurchDiscLine.DELETEALL();

        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        IF lrc_PurchLine.FINDSET(TRUE, FALSE) THEN BEGIN

            lrc_PurchLineLast.RESET();
            lrc_PurchLineLast.COPY(lrc_PurchLine);
            lrc_PurchLineLast.SETRANGE("Allow Invoice Disc.", TRUE);
            lrc_PurchLineLast.SETFILTER(Quantity, '<>%1', 0);
            IF lrc_PurchLineLast.FINDLAST() THEN
                lin_PurchLineCount := lrc_PurchLineLast.COUNT();

            REPEAT

                // Werte zurücksetzen
                CLEAR(ldc_ArrSumDiscLevelPurchLine);
                ldc_WarenRabRechnung := 0;
                ldc_RechRabRechnung := 0;
                ldc_Rückstellungsrabatt := 0;

                IF (lrc_PurchLine."Allow Invoice Disc." = TRUE) AND
                   (lrc_PurchLine.Quantity <> 0) THEN BEGIN

                    // Rabatte Bestellung lesen
                    lrc_PurchDisc.RESET();
                    lrc_PurchDisc.SETCURRENTKEY("Calculation Level");
                    lrc_PurchDisc.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                    lrc_PurchDisc.SETRANGE("Document No.", lrc_PurchHeader."No.");
                    lrc_PurchDisc.SETFILTER("Item No.", '%1|%2', lrc_PurchLine."No.", '');
                    lrc_PurchDisc.SETFILTER("Product Group Code", '%1|%2', lrc_PurchLine."POI Product Group Code", '');
                    lrc_PurchDisc.SETFILTER("Item Category Code", '%1|%2', lrc_PurchLine."Item Category Code", '');
                    IF lrc_PurchDisc.FIND('-') THEN BEGIN

                        lin_StartLevel := lrc_PurchDisc."Calculation Level";
                        lin_AktuellerLevel := lrc_PurchDisc."Calculation Level";

                        REPEAT

                            lrc_Disc.GET(lrc_PurchDisc."Discount Code");

                            IF (lrc_Disc."Sub Typ" = lrc_Disc."Sub Typ"::" ") OR
                               ((lrc_Disc."Sub Typ" = lrc_Disc."Sub Typ"::VVE) AND
                                (lrc_PurchLine."POI Empties Quantity" = 0)) THEN BEGIN

                                IF lrc_PurchDisc."Calculation Level" > lin_AktuellerLevel THEN
                                    lin_AktuellerLevel := lrc_PurchDisc."Calculation Level";

                                // Rabattzeile Bestellung lesen / anlegen
                                lrc_PurchDiscLine.RESET();
                                lrc_PurchDiscLine.SETRANGE("Document Type", lrc_PurchDisc."Document Type");
                                lrc_PurchDiscLine.SETRANGE("Document No.", lrc_PurchDisc."Document No.");
                                lrc_PurchDiscLine.SETRANGE("Purch. Disc. Entry No.", lrc_PurchDisc."Entry No.");
                                lrc_PurchDiscLine.SETRANGE("Document Line No.", lrc_PurchLine."Line No.");
                                IF NOT lrc_PurchDiscLine.FINDFIRST() THEN BEGIN
                                    // Neuanlage
                                    lrc_PurchDiscLine.RESET();
                                    lrc_PurchDiscLine.INIT();
                                    lrc_PurchDiscLine."Document Type" := lrc_PurchDisc."Document Type";
                                    lrc_PurchDiscLine."Document No." := lrc_PurchDisc."Document No.";
                                    lrc_PurchDiscLine."Purch. Disc. Entry No." := lrc_PurchDisc."Entry No.";
                                    lrc_PurchDiscLine."Document Line No." := lrc_PurchLine."Line No.";
                                    lrc_PurchDiscLine.INSERT();
                                END;

                                lrc_PurchDiscLine."Discount Code" := lrc_PurchDisc."Discount Code";
                                lrc_PurchDiscLine."Discount Type" := lrc_PurchDisc."Discount Type";
                                lrc_PurchDiscLine."Base Discount Value" := lrc_PurchDisc."Base Discount Value";
                                lrc_PurchDiscLine."Discount Value" := lrc_PurchDisc."Discount Value";
                                lrc_PurchDiscLine."Basis %-Satz inkl. Ums.-St." := lrc_PurchDisc."Basis %-Satz inkl. Ums.-St.";
                                lrc_PurchDiscLine."Payment Timing" := lrc_PurchDisc."Payment Timing";

                                IF lrc_PurchLine.Type = lrc_PurchLine.Type::Item THEN BEGIN
                                    lrc_PurchDiscLine."Item No." := lrc_PurchLine."No.";
                                    lrc_PurchDiscLine."Variant Code" := lrc_PurchLine."Variant Code";
                                END ELSE BEGIN
                                    lrc_PurchDiscLine."Item No." := '';
                                    lrc_PurchDiscLine."Variant Code" := '';
                                END;
                                lrc_PurchDiscLine.VALIDATE("Batch No.", lrc_PurchLine."POI Batch No.");


                                IF lrc_PurchHeader."Currency Code" = '' THEN BEGIN
                                    lrc_PurchDiscLine."Currency Code" := lrc_PurchHeader."Currency Code";
                                    lrc_PurchDiscLine."Currency Factor" := 1;
                                END ELSE BEGIN
                                    lrc_PurchDiscLine."Currency Code" := lrc_PurchHeader."Currency Code";
                                    lrc_PurchDiscLine."Currency Factor" := lrc_PurchHeader."Currency Factor";
                                END;
                                lrc_PurchDiscLine."Buy-from Vendor No." := lrc_PurchHeader."Buy-from Vendor No.";
                                lrc_PurchDiscLine."Document Posting Date" := lrc_PurchHeader."Posting Date";


                                CASE lrc_PurchDisc."Base Discount Value" OF
                                    lrc_PurchDisc."Base Discount Value"::Prozentsatz:
                                        IF lrc_PurchDisc."Basis %-Satz inkl. Ums.-St." = FALSE THEN
                                            IF lin_AktuellerLevel > 1 THEN
                                                lrc_PurchDiscLine."Disc. Amount" := (lrc_PurchLine."Line Amount" -
                                                                                    ldc_ArrSumDiscLevelPurchLine[(lin_AktuellerLevel - 1)]) *
                                                                                    (lrc_PurchDiscLine."Discount Value" / 100)
                                            ELSE
                                                lrc_PurchDiscLine."Disc. Amount" := lrc_PurchLine."Line Amount" *
                                                                                        (lrc_PurchDiscLine."Discount Value" / 100)
                                        ELSE
                                            IF lin_AktuellerLevel > 1 THEN
                                                lrc_PurchDiscLine."Disc. Amount" := (lrc_PurchLine."Line Amount" -
                                                                                     ldc_ArrSumDiscLevelPurchLine[(lin_AktuellerLevel - 1)]) *
                                                                                     (1 + (lrc_PurchLine."VAT %" / 100)) *
                                                                                     (lrc_PurchDiscLine."Discount Value" / 100)
                                            ELSE
                                                lrc_PurchDiscLine."Disc. Amount" := (lrc_PurchLine."Line Amount" *
                                                                                    (1 + (lrc_PurchLine."VAT %" / 100))) *
                                                                                    (lrc_PurchDiscLine."Discount Value" / 100);
                                    lrc_PurchDisc."Base Discount Value"::"Absoluter Betrag auf Zeilenbasis":
                                        begin
                                            ldc_SplitAmount := 0;
                                            ldc_DifferenceAmount := 0;
                                            // Rabattbetrag durch die Anzahl der Zeilen teilen
                                            ldc_SplitAmount := ROUND(lrc_PurchDiscLine."Discount Value" / lin_PurchLineCount, 0.01);
                                            IF lrc_PurchLine."Line No." <> lrc_PurchLineLast."Line No." THEN
                                                // normale Zeile
                                                lrc_PurchDiscLine."Disc. Amount" := ldc_SplitAmount
                                            ELSE BEGIN
                                                // letzte Zeile --> Summierung Restsumme
                                                ldc_DifferenceAmount := (ldc_SplitAmount * lin_PurchLineCount) - lrc_PurchDiscLine."Discount Value";
                                                lrc_PurchDiscLine."Disc. Amount" := ldc_SplitAmount - ldc_DifferenceAmount;
                                            END;
                                        end;
                                    lrc_PurchDisc."Base Discount Value"::"Betrag Pro Kolli":
                                        lrc_PurchDiscLine."Disc. Amount" := lrc_PurchLine.Quantity * lrc_PurchDisc."Discount Value";
                                    lrc_PurchDisc."Base Discount Value"::Kolloeinheit:
                                        BEGIN
                                            lrc_UnitofMeasure.GET(lrc_PurchLine."Unit of Measure Code");
                                            lrc_PurchDiscLine."Disc. Amount" := lrc_PurchLine.Quantity * lrc_UnitofMeasure."POI Purch. Acc per Collo (LCY)";
                                        END;

                                    lrc_PurchDisc."Base Discount Value"::"Proz. auf Einheit gerundet":
                                        IF lin_AktuellerLevel > 1 THEN
                                            // Bezugsgröße für Levelabstufung nicht verfügbar!
                                            ERROR(ADF_LT_TEXT001Txt)
                                        ELSE
                                            lrc_PurchDiscLine."Disc. Amount" := ROUND((lrc_PurchLine."Direct Unit Cost" *
                                                                                      (lrc_PurchDiscLine."Discount Value" / 100)), 0.01) *
                                                                                      lrc_PurchLine.Quantity;
                                    lrc_PurchDisc."Base Discount Value"::"Gew.-Abhängiger Betrag":
                                        // Bezugsgröße für Einkauf nicht verfügbar!
                                        ERROR(ADF_LT_TEXT002Txt);
                                    //RS Betrag pro Palette
                                    lrc_PurchDisc."Base Discount Value"::"Betrag pro Transporteinheit":
                                        lrc_PurchDiscLine."Disc. Amount" := lrc_PurchLine."POI Quantity (TU)" * lrc_PurchDisc."Discount Value";
                                END;


                                // Werte für zu erhalten und zu fakturieren berechnen
                                IF lrc_PurchLine."Document Type" = lrc_PurchLine."Document Type"::"Credit Memo" THEN BEGIN
                                    lrc_PurchDiscLine."Disc. Amount to Ship" := lrc_PurchDiscLine."Disc. Amount";
                                    lrc_PurchDiscLine."Disc. Amount to Invoice" := lrc_PurchDiscLine."Disc. Amount";
                                END ELSE BEGIN
                                    lrc_PurchDiscLine."Disc. Amount to Ship" := lrc_PurchDiscLine."Disc. Amount" *
                                                                                    lrc_PurchLine."Qty. to Receive" /
                                                                                    lrc_PurchLine.Quantity;
                                    lrc_PurchDiscLine."Disc. Amount to Invoice" := lrc_PurchDiscLine."Disc. Amount" *
                                                                                    lrc_PurchLine."Qty. to Invoice" /
                                                                                    lrc_PurchLine.Quantity;
                                END;
                                // Rabattbeträge in lokale Währung umrechnen
                                lrc_PurchDiscLine."Disc. Amount (LCY)" := lrc_PurchDiscLine."Disc. Amount" /
                                                                              lrc_PurchDiscLine."Currency Factor";
                                lrc_PurchDiscLine."Disc. Amount to Ship (LCY)" := lrc_PurchDiscLine."Disc. Amount to Ship" /
                                                                                      lrc_PurchDiscLine."Currency Factor";
                                lrc_PurchDiscLine."Disc. Amount to Invoice (LCY)" := lrc_PurchDiscLine."Disc. Amount to Invoice" /
                                                                                         lrc_PurchDiscLine."Currency Factor";

                                // Rabattbeträge runden
                                ldc_RoundingValue := 0.01;

                                lrc_PurchDiscLine."Disc. Amount" := ROUND(lrc_PurchDiscLine."Disc. Amount", ldc_RoundingValue);
                                lrc_PurchDiscLine."Disc. Amount to Invoice" := ROUND(lrc_PurchDiscLine."Disc. Amount to Invoice", ldc_RoundingValue);
                                lrc_PurchDiscLine."Disc. Amount to Ship" := ROUND(lrc_PurchDiscLine."Disc. Amount to Ship", ldc_RoundingValue);
                                lrc_PurchDiscLine."Disc. Amount (LCY)" := ROUND(lrc_PurchDiscLine."Disc. Amount (LCY)", ldc_RoundingValue);
                                lrc_PurchDiscLine."Disc. Amount to Ship (LCY)" := ROUND(lrc_PurchDiscLine."Disc. Amount to Ship (LCY)",
                                                                                    ldc_RoundingValue);
                                lrc_PurchDiscLine."Disc. Amount to Invoice (LCY)" :=
                                                                              ROUND(lrc_PurchDiscLine."Disc. Amount to Invoice (LCY)",
                                                                                    ldc_RoundingValue);

                                // Kontierung
                                lrc_PurchDiscLine."Gen. Bus. Posting Group" := lrc_PurchLine."Gen. Bus. Posting Group";
                                IF (lrc_PurchDisc."Discount Type" = lrc_PurchDisc."Discount Type"::Warenrechnungsrabatt) OR
                                   (lrc_PurchDisc."Discount Type" = lrc_PurchDisc."Discount Type"::Artikelrabatt) THEN
                                    lrc_PurchDiscLine."Gen. Prod. Posting Group" := lrc_PurchLine."Gen. Prod. Posting Group"
                                ELSE BEGIN
                                    lrc_Disc.GET(lrc_PurchDisc."Discount Code");
                                    lrc_Disc.TESTFIELD("Gen. Prod. Posting Group");
                                    lrc_PurchDiscLine."Gen. Prod. Posting Group" := lrc_Disc."Gen. Prod. Posting Group";
                                END;

                                lrc_PurchDiscLine.MODIFY();

                                // Rabatte nach VAT % und Zahlungszeitpunkt aufaddieren
                                IF lrc_PurchDisc."Payment Timing" = lrc_PurchDisc."Payment Timing"::Invoice THEN BEGIN
                                    IF (lrc_PurchDisc."Discount Type" = lrc_PurchDisc."Discount Type"::Warenrechnungsrabatt) OR
                                       (lrc_PurchDisc."Discount Type" = lrc_PurchDisc."Discount Type"::Artikelrabatt) THEn
                                        ldc_WarenRabRechnung := ldc_WarenRabRechnung + lrc_PurchDiscLine."Disc. Amount"
                                    ELSE
                                        ldc_RechRabRechnung := ldc_RechRabRechnung + lrc_PurchDiscLine."Disc. Amount";
                                END ELSE
                                    ldc_Rückstellungsrabatt := ldc_Rückstellungsrabatt + lrc_PurchDiscLine."Disc. Amount";
                                ldc_ArrSumDiscLevelPurchLine[lin_AktuellerLevel] := ldc_ArrSumDiscLevelPurchLine[lin_AktuellerLevel] +
                                                                                    lrc_PurchDiscLine."Disc. Amount"
                            END;

                        UNTIL lrc_PurchDisc.NEXT() = 0;
                    END;

                END;

                // Werte in Einkaufszeile zurückschreiben
                IF ldc_WarenRabRechnung <> lrc_PurchLine."Inv. Discount Amount" THEN
                    lrc_PurchLine.VALIDATE("Inv. Discount Amount", ldc_WarenRabRechnung);
                lrc_PurchLine."POI Inv.Disc.not Rela.to Goods" := ldc_RechRabRechnung;
                lrc_PurchLine."POI Accr Inv. Disc. (External)" := ldc_Rückstellungsrabatt;
                lrc_PurchLine.MODIFY();

            UNTIL lrc_PurchLine.NEXT() = 0;



            // Rabatte aus Rabattzeilen aufaddieren
            lrc_PurchDisc.RESET();
            lrc_PurchDisc.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
            lrc_PurchDisc.SETRANGE("Document No.", lrc_PurchHeader."No.");
            IF lrc_PurchDisc.FINDSET(TRUE, FALSE) THEN
                REPEAT
                    lrc_PurchDisc."Disc. Amount" := 0;
                    lrc_PurchDisc."Disc. Amount to Invoice" := 0;
                    lrc_PurchDisc."Disc. Amount to Ship" := 0;
                    lrc_PurchDisc."Disc. Amount (LCY)" := 0;
                    lrc_PurchDisc."Disc. Amount to Invoice (LCY)" := 0;
                    lrc_PurchDisc."Disc. Amount to Ship (LCY)" := 0;
                    lrc_PurchDiscLine.SETRANGE("Document Type", lrc_PurchDisc."Document Type");
                    lrc_PurchDiscLine.SETRANGE("Document No.", lrc_PurchDisc."Document No.");
                    lrc_PurchDiscLine.SETRANGE("Purch. Disc. Entry No.", lrc_PurchDisc."Entry No.");
                    IF lrc_PurchDiscLine.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            lrc_PurchDisc."Disc. Amount" := ROUND(lrc_PurchDisc."Disc. Amount" +
                                                                   lrc_PurchDiscLine."Disc. Amount", 0.01);
                            lrc_PurchDisc."Disc. Amount to Invoice" := ROUND(lrc_PurchDisc."Disc. Amount to Invoice" +
                                                                   lrc_PurchDiscLine."Disc. Amount to Invoice", 0.01);
                            lrc_PurchDisc."Disc. Amount to Ship" := ROUND(lrc_PurchDisc."Disc. Amount to Ship" +
                                                                   lrc_PurchDiscLine."Disc. Amount to Ship", 0.01);
                            lrc_PurchDisc."Disc. Amount (LCY)" := ROUND(lrc_PurchDisc."Disc. Amount (LCY)" +
                                                                   lrc_PurchDiscLine."Disc. Amount (LCY)", 0.01);
                            lrc_PurchDisc."Disc. Amount to Invoice (LCY)" := ROUND(lrc_PurchDisc."Disc. Amount to Invoice (LCY)" +
                                                                   lrc_PurchDiscLine."Disc. Amount to Invoice (LCY)", 0.01);
                            lrc_PurchDisc."Disc. Amount to Ship (LCY)" := ROUND(lrc_PurchDisc."Disc. Amount to Ship (LCY)" +
                                                                   lrc_PurchDiscLine."Disc. Amount to Ship (LCY)", 0.01);
                        UNTIL lrc_PurchDiscLine.NEXT() = 0;
                    lrc_PurchDisc.MODIFY();
                    // Gesamtsumme Warenrechnungsrabatt auf Rechnung addieren
                    IF ((lrc_PurchDisc."Discount Type" = lrc_PurchDisc."Discount Type"::Warenrechnungsrabatt) OR
                        (lrc_PurchDisc."Discount Type" = lrc_PurchDisc."Discount Type"::Artikelrabatt)) AND
                       (lrc_PurchDisc."Payment Timing" = lrc_PurchDisc."Payment Timing"::Invoice) THEN
                        ldc_SumWarenRabRechnung := ldc_SumWarenRabRechnung + lrc_PurchDisc."Disc. Amount";
                UNTIL lrc_PurchDisc.NEXT() = 0;
        END;

        lrc_PurchHeader."Invoice Discount Calculation" := lrc_PurchHeader."Invoice Discount Calculation"::Amount;
        lrc_PurchHeader."Invoice Discount Value" := ldc_SumWarenRabRechnung;
        lrc_PurchHeader."Invoice Disc. Code" := '';
        lrc_PurchHeader.MODIFY();
    end;

    procedure PurchDiscPurchLines(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchHeader: Record "Purchase Header";
        lrc_Discount: Record "POI Discount";
        lbn_LineAvailable: Boolean;
        lco_ProductPostGroup: Code[10];
        ldc_DiscAmount: Decimal;
        lco_GlAccountNo: Code[20];
        ADF_LT_TEXT001Txt: Label 'Produktbuchungsgruppe Rabattcode %1 abweichend von Prod.-Buch.-Grp. %2', Comment = '%1 %2';
    // lrc_DocumentDimension: Record "357"; //TODO: dimension
    // lrc_DocumentDimension2: Record "357";
    begin
        // -------------------------------------------------------------------------------------
        // Funktionen zur Erstellung / Aktualisierung der nicht Warenbezogenen Rabattzeilen
        // -------------------------------------------------------------------------------------

        IF lrc_PurchHeader.GET(vop_DocType, vco_DocNo) THEN;

        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                lco_ProductPostGroup := '';
                ldc_DiscAmount := 0;
                lrc_PurchLineDisc.RESET();
                lrc_PurchLineDisc.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                lrc_PurchLineDisc.SETRANGE("Document No.", lrc_PurchHeader."No.");
                lrc_PurchLineDisc.SETRANGE(Type, lrc_PurchLineDisc.Type::"G/L Account");
                lrc_PurchLineDisc.SETRANGE("POI Subtyp", lrc_PurchLineDisc."POI Subtyp"::Discount);
                lrc_PurchLineDisc.SETRANGE("Attached to Line No.", lrc_PurchLine."Line No.");
                IF lrc_PurchLineDisc.FIND('-') THEN
                    lbn_LineAvailable := TRUE
                ELSE
                    lbn_LineAvailable := FALSE;
                lrc_PurchDiscountLine.RESET();
                lrc_PurchDiscountLine.SETRANGE("Document Type", lrc_PurchLine."Document Type");
                lrc_PurchDiscountLine.SETRANGE("Document No.", lrc_PurchLine."Document No.");
                lrc_PurchDiscountLine.SETRANGE("Document Line No.", lrc_PurchLine."Line No.");
                lrc_PurchDiscountLine.SETRANGE("Discount Type", lrc_PurchDiscountLine."Discount Type"::Rechnungsrabatt);
                lrc_PurchDiscountLine.SETRANGE("Payment Timing", lrc_PurchDiscountLine."Payment Timing"::Invoice);
                IF lrc_PurchDiscountLine.FIND('-') THEN BEGIN
                    REPEAT
                        lrc_Discount.GET(lrc_PurchDiscountLine."Discount Code");
                        lrc_Discount.TESTFIELD("Gen. Prod. Posting Group");
                        IF lco_ProductPostGroup = '' THEN
                            lco_ProductPostGroup := lrc_Discount."Gen. Prod. Posting Group"
                        ELSE
                            IF lco_ProductPostGroup <> lrc_Discount."Gen. Prod. Posting Group" THEN
                                // Produktbuchungsgruppe Rabattcode %1 abweichend von Prod.-Buch.-Grp. %2
                                ERROR(ADF_LT_TEXT001Txt, lrc_Discount.Code, lco_ProductPostGroup);
                        ldc_DiscAmount := ldc_DiscAmount + lrc_PurchDiscountLine."Disc. Amount";
                    UNTIL lrc_PurchDiscountLine.NEXT() = 0;

                    IF lbn_LineAvailable = FALSE THEN BEGIN
                        lrc_PurchLineDisc.RESET();
                        lrc_PurchLineDisc.INIT();
                        lrc_PurchLineDisc."Document Type" := lrc_PurchLine."Document Type";
                        lrc_PurchLineDisc."Document No." := lrc_PurchLine."Document No.";
                        lrc_PurchLineDisc."Line No." := lrc_PurchLine."Line No." + 10;
                        lrc_PurchLineDisc.INSERT();
                        lrc_PurchLineDisc."Buy-from Vendor No." := lrc_PurchLine."Buy-from Vendor No.";
                        lrc_PurchLineDisc.Type := lrc_PurchLineDisc.Type::"G/L Account";
                        // Sachkonto feststellen
                        //RS Sachkonto nicht aus PurchHeader sondern aus PurchLine
                        lco_GlAccountNo := PurchGetDiscAlloc(lrc_PurchLine."Gen. Bus. Posting Group", lco_ProductPostGroup);
                        lrc_PurchLineDisc.VALIDATE("No.", lco_GlAccountNo);
                        IF lco_ProductPostGroup <> '' THEN
                            lrc_PurchLineDisc.VALIDATE("Gen. Prod. Posting Group", lco_ProductPostGroup);
                        lrc_PurchLineDisc.VALIDATE(Quantity, lrc_PurchLine.Quantity);
                        lrc_PurchLineDisc.VALIDATE("POI Price Base (Purch. Price)", '');
                        lrc_PurchLineDisc.VALIDATE("POI Purch. Price (Price Base)",
                                          (ROUND(ldc_DiscAmount / lrc_PurchLineDisc.Quantity, 0.00001) * -1));
                        lrc_PurchLineDisc."POI Master Batch No." := lrc_PurchLine."POI Master Batch No.";
                        lrc_PurchLineDisc.VALIDATE("POI Batch No.", lrc_PurchLine."POI Batch No.");
                        lrc_PurchLineDisc."Attached to Line No." := lrc_PurchLine."Line No.";
                    END;

                    lrc_PurchLineDisc."Location Code" := lrc_PurchLine."Location Code";
                    lrc_PurchLineDisc.VALIDATE(Quantity, lrc_PurchLine.Quantity);
                    lrc_PurchLineDisc.VALIDATE("POI Price Base (Purch. Price)", '');
                    lrc_PurchLineDisc.VALIDATE("POI Purch. Price (Price Base)", (ROUND(ldc_DiscAmount / lrc_PurchLineDisc.Quantity, 0.00001) * -1));
                    IF lrc_PurchLine."Shortcut Dimension 1 Code" <> '' THEN
                        lrc_PurchLineDisc.VALIDATE("Shortcut Dimension 1 Code", lrc_PurchLine."Shortcut Dimension 1 Code");
                    IF lrc_PurchLine."Shortcut Dimension 2 Code" <> '' THEN
                        lrc_PurchLineDisc.VALIDATE("Shortcut Dimension 2 Code", lrc_PurchLine."Shortcut Dimension 2 Code");
                    IF lrc_PurchLine."POI Shortcut Dimension 3 Code" <> '' THEN
                        lrc_PurchLineDisc.VALIDATE("POI Shortcut Dimension 3 Code", lrc_PurchLine."POI Shortcut Dimension 3 Code");
                    IF lrc_PurchLine."POI Shortcut Dimension 4 Code" <> '' THEN
                        lrc_PurchLineDisc.VALIDATE("POI Shortcut Dimension 4 Code", lrc_PurchLine."POI Shortcut Dimension 4 Code");

                    // //RS Übernahme Dimensionen in Rabattzeile //TODO: Dimensionen
                    // lrc_DocumentDimension.RESET();
                    // lrc_DocumentDimension.SETRANGE("Table ID", 39);
                    // lrc_DocumentDimension.SETRANGE("Document Type", lrc_PurchLine."Document Type");
                    // lrc_DocumentDimension.SETRANGE("Document No.", lrc_PurchLine."Document No.");
                    // lrc_DocumentDimension.SETRANGE("Line No.", lrc_PurchLine."Line No.");
                    // IF lrc_DocumentDimension.FINDSET(FALSE, FALSE) THEN BEGIN
                    //     REPEAT
                    //         lrc_DocumentDimension2.SETRANGE("Table ID", 39);
                    //         lrc_DocumentDimension2.SETRANGE("Document Type", lrc_DocumentDimension."Document Type");
                    //         lrc_DocumentDimension2.SETRANGE("Document No.", lrc_DocumentDimension."Document No.");
                    //         lrc_DocumentDimension2.SETRANGE("Line No.", lrc_PurchLineDisc."Line No.");
                    //         lrc_DocumentDimension2.SETRANGE("Dimension Code", lrc_DocumentDimension."Dimension Code");
                    //         IF NOT lrc_DocumentDimension2.FINDSET() THEN BEGIN
                    //             lrc_DocumentDimension2.RESET();
                    //             lrc_DocumentDimension2.INIT();
                    //             lrc_DocumentDimension2."Table ID" := 39;
                    //             lrc_DocumentDimension2."Document Type" := lrc_DocumentDimension."Document Type";
                    //             lrc_DocumentDimension2."Document No." := lrc_DocumentDimension."Document No.";
                    //             lrc_DocumentDimension2."Line No." := lrc_PurchLineDisc."Line No.";
                    //             lrc_DocumentDimension2."Dimension Code" := lrc_DocumentDimension."Dimension Code";
                    //             lrc_DocumentDimension2."Dimension Value Code" := lrc_DocumentDimension."Dimension Value Code";
                    //             lrc_DocumentDimension2.insert();
                    //         END;
                    //     UNTIL lrc_DocumentDimension.NEXT() = 0;


                    lrc_PurchLineDisc."POI Subtyp" := lrc_PurchLineDisc."POI Subtyp"::Discount;
                    lrc_PurchLineDisc."Allow Invoice Disc." := FALSE;
                    lrc_PurchLineDisc.MODIFY();

                    IF lrc_PurchLine."Qty. to Receive" <> 0 THEN
                        lrc_PurchLineDisc.VALIDATE("Qty. to Receive", lrc_PurchLine."Qty. to Receive")
                    ELSE
                        IF lrc_PurchLine."Quantity Received" <> lrc_PurchLine.Quantity THEN
                            lrc_PurchLineDisc.VALIDATE("Qty. to Receive", 0);
                    IF lrc_PurchLine."Qty. to Invoice" <> 0 THEN
                        lrc_PurchLineDisc.VALIDATE("Qty. to Invoice", lrc_PurchLine."Qty. to Invoice")
                    ELSE
                        IF lrc_PurchLine."Quantity Invoiced" <> lrc_PurchLine.Quantity THEN
                            lrc_PurchLineDisc.VALIDATE("Qty. to Invoice", 0);

                    lrc_FruitVisionSetup.GET();
                    CASE lrc_FruitVisionSetup."Sales Disc. Line G.B. Grp." OF
                        lrc_FruitVisionSetup."Sales Disc. Line G.B. Grp."::"Equal to Source Line":
                            BEGIN
                                lrc_PurchLineDisc.VALIDATE("Gen. Bus. Posting Group", lrc_PurchLine."Gen. Bus. Posting Group");
                                lrc_PurchLineDisc.VALIDATE("VAT Bus. Posting Group", lrc_PurchLine."VAT Bus. Posting Group");
                            END;
                    END;

                    lrc_PurchLineDisc.MODIFY();

                END ELSE
                    IF lbn_LineAvailable = TRUE THEN
                        lrc_PurchLineDisc.DELETE(TRUE);
            UNTIL lrc_PurchLine.NEXT() = 0;
    end;

    //     procedure PurchShowDiscSum(vop_DocTyp: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; var rbn_Vorhanden: Boolean; var rdc_RgRabWare: Decimal; var rdc_RgRabOhneWarenBezug: Decimal; var "rdc_RgRabRückstellung": Decimal)
    //     var
    //         lrc_PurchDiscount: Record "5110381";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Berechnung der Rabattwerte für Anzeige in Einkaufsvorgang Kopf
    //         // -------------------------------------------------------------------------------------

    //         // Werte zurücksetzen
    //         rbn_Vorhanden := FALSE;
    //         rdc_RgRabWare := 0;
    //         rdc_RgRabOhneWarenBezug := 0;
    //         rdc_RgRabRückstellung := 0;

    //         lrc_PurchDiscount.RESET();
    //         lrc_PurchDiscount.SETRANGE("Document Type", vop_DocTyp);
    //         lrc_PurchDiscount.SETRANGE("Document No.", vco_DocNo);
    //         IF lrc_PurchDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 rbn_Vorhanden := TRUE;
    //                 CASE lrc_PurchDiscount."Base Discount Value" OF
    //                     lrc_PurchDiscount."Base Discount Value"::Prozentsatz:
    //                         BEGIN
    //                             IF (lrc_PurchDiscount."Payment Timing" = lrc_PurchDiscount."Payment Timing"::Invoice) THEN BEGIN
    //                                 IF (lrc_PurchDiscount."Discount Type" = lrc_PurchDiscount."Discount Type"::Warenrechnungsrabatt) OR
    //                                    (lrc_PurchDiscount."Discount Type" = lrc_PurchDiscount."Discount Type"::Artikelrabatt) THEN BEGIN
    //                                     rdc_RgRabWare := rdc_RgRabWare + lrc_PurchDiscount."Discount Value";
    //                                 END ELSE BEGIN
    //                                     rdc_RgRabOhneWarenBezug := rdc_RgRabOhneWarenBezug + lrc_PurchDiscount."Discount Value";
    //                                 END;
    //                             END ELSE BEGIN
    //                                 rdc_RgRabRückstellung := rdc_RgRabRückstellung + lrc_PurchDiscount."Discount Value";
    //                             END;
    //                         END;
    //                 END;
    //             UNTIL lrc_PurchDiscount.NEXT() = 0;
    //         END;
    //     end;

    procedure PurchGetDiscAlloc(vco_GenBusPostingGroup: Code[20]; vco_GenProdPostingGroup: Code[10]): Code[20]
    var
        lrc_GeneralPostingSetup: Record "General Posting Setup";
        AGILES_LT_TEXT001Txt: Label 'Kontierung für %1 und %2 nicht vorhanden!', Comment = '%1 %2';
    begin
        // -------------------------------------------------------------------------------------
        // Funktion zur Ermittlung des Sachkontos für nicht Warenbezogene Rechnungsrabatte
        // -------------------------------------------------------------------------------------

        lrc_GeneralPostingSetup.RESET();
        lrc_GeneralPostingSetup.SETRANGE("Gen. Bus. Posting Group", vco_GenBusPostingGroup);
        lrc_GeneralPostingSetup.SETRANGE("Gen. Prod. Posting Group", vco_GenProdPostingGroup);
        IF NOT lrc_GeneralPostingSetup.FINDFIRST() THEN
            // Kontierung für %1 und %2 nicht vorhanden!
            ERROR(AGILES_LT_TEXT001Txt, vco_GenBusPostingGroup, vco_GenProdPostingGroup);
        lrc_GeneralPostingSetup.TESTFIELD("POI Purch.Inv.Disc.ohne WB Acc");
        EXIT(lrc_GeneralPostingSetup."POI Purch.Inv.Disc.ohne WB Acc");
    end;

    //     procedure PurchPrintInvDiscount(vin_DocumentType: Integer; vco_DocumentNo: Code[20]; var rtx_Rechnungsrabatte: array[4] of Text[100])
    //     var
    //         lrc_PurchaseDiscount: Record "5110381";
    //         lrc_Discount: Record "5110383";
    //         "lin_Zähler": Integer;
    //         lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // Funktion zum Ausgabe der Warenrechnungsrabatte
    //         // ---------------------------------------------------------------------------------------------------------

    //         lrc_PurchaseDiscount.RESET();
    //         lrc_PurchaseDiscount.SETRANGE("Document Type", vin_DocumentType);
    //         lrc_PurchaseDiscount.SETRANGE("Document No.", vco_DocumentNo);
    //         lrc_PurchaseDiscount.SETFILTER("Discount Type", '%1|%2', lrc_PurchaseDiscount."Discount Type"::Warenrechnungsrabatt,
    //                                                                lrc_PurchaseDiscount."Discount Type"::Artikelrabatt);
    //         lrc_PurchaseDiscount.SETRANGE("Payment Timing", lrc_PurchaseDiscount."Payment Timing"::Invoice);
    //         IF lrc_PurchaseDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 lrc_Discount.GET(lrc_PurchaseDiscount."Discount Code");
    //                 lin_Zähler := lin_Zähler + 1;
    //                 IF lin_Zähler <= ARRAYLEN(rtx_Rechnungsrabatte) THEN BEGIN
    //                     IF lrc_PurchaseDiscount."Base Discount Value" = lrc_PurchaseDiscount."Base Discount Value"::Prozentsatz THEN BEGIN
    //                         rtx_Rechnungsrabatte[lin_Zähler] := lrc_Discount.Description + ', ' +
    //                                                             FORMAT(lrc_PurchaseDiscount."Base Discount Value") +
    //                                                             ' ' + FORMAT(lrc_PurchaseDiscount."Discount Value");
    //                         rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler] + '%';
    //                     END ELSE BEGIN
    //                         rtx_Rechnungsrabatte[lin_Zähler] := lrc_Discount.Description + ', ' +
    //                                                             FORMAT(lrc_PurchaseDiscount."Base Discount Value") + ' ' +
    //                                                             lcu_GlobalFunctions.StrNumberFormat(FORMAT(lrc_PurchaseDiscount."Discount Value"), 2,
    //                                                             FALSE);
    //                     END;
    //                     rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler];
    //                 END;
    //             UNTIL lrc_PurchaseDiscount.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PurchPostArchShowDiscSum(vop_DocTyp: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment"; vco_DocNo: Code[20]; vin_VersNo: Integer; var rbn_Vorhanden: Boolean; var rdc_RgRabWare: Decimal; var rdc_RgRabOhneWarenBezug: Decimal; var "rdc_RgRabRückstellung": Decimal)
    //     var
    //         lrc_PurchasePostArchivDiscount: Record "5110388";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Berechnung der Rabattwerte für Anzeige im geb. Kopf / Archiv. Kopf
    //         // -------------------------------------------------------------------------------------

    //         // Werte zurücksetzen
    //         rbn_Vorhanden := FALSE;
    //         rdc_RgRabWare := 0;
    //         rdc_RgRabOhneWarenBezug := 0;
    //         rdc_RgRabRückstellung := 0;

    //         lrc_PurchasePostArchivDiscount.RESET();
    //         lrc_PurchasePostArchivDiscount.SETRANGE("Document Type", vop_DocTyp);
    //         lrc_PurchasePostArchivDiscount.SETRANGE("Document No.", vco_DocNo);
    //         lrc_PurchasePostArchivDiscount.SETRANGE("Version No.", vin_VersNo);
    //         IF lrc_PurchasePostArchivDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 rbn_Vorhanden := TRUE;
    //                 CASE lrc_PurchasePostArchivDiscount."Base Discount Value" OF
    //                     lrc_PurchasePostArchivDiscount."Base Discount Value"::Prozentsatz:
    //                         BEGIN
    //                             IF (lrc_PurchasePostArchivDiscount."Payment Timing" =
    //                                 lrc_PurchasePostArchivDiscount."Payment Timing"::Invoice) THEN BEGIN
    //                                 IF ((lrc_PurchasePostArchivDiscount."Discount Type" =
    //                                      lrc_PurchasePostArchivDiscount."Discount Type"::Warenrechnungsrabatt) OR
    //                                      (lrc_PurchasePostArchivDiscount."Discount Type" =
    //                                       lrc_PurchasePostArchivDiscount."Discount Type"::Artikelrabatt)) THEN BEGIN
    //                                     rdc_RgRabWare := rdc_RgRabWare + lrc_PurchasePostArchivDiscount."Discount Value";
    //                                 END ELSE BEGIN
    //                                     rdc_RgRabOhneWarenBezug := rdc_RgRabOhneWarenBezug + lrc_PurchasePostArchivDiscount."Discount Value";
    //                                 END;
    //                             END ELSE BEGIN
    //                                 rdc_RgRabRückstellung := rdc_RgRabRückstellung + lrc_PurchasePostArchivDiscount."Discount Value";
    //                             END;
    //                         END;
    //                 END;
    //             UNTIL lrc_PurchasePostArchivDiscount.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PurchPostArchShowDiscount(vop_DocTyp: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment"; vco_DocNo: Code[20]; vin_VersNo: Integer)
    //     var
    //         lrc_PurchasePostArchivDiscount: Record "5110388";
    //         lfm_PurchasePostArchivDiscount: Form "5110388";
    //         AGILES_LT_TEXT001: Label 'There exist no discount''s for this document %1 !';
    //         AGILES_LT_TEXT002: Label 'There exist no discount''s for this document %1, version %2 !';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige der Rabattwerte geb. /Archivierte Einkaufsbelege
    //         // -------------------------------------------------------------------------------------

    //         lrc_PurchasePostArchivDiscount.RESET();
    //         lrc_PurchasePostArchivDiscount.SETRANGE("Document Type", vop_DocTyp);
    //         lrc_PurchasePostArchivDiscount.SETRANGE("Document No.", vco_DocNo);
    //         lrc_PurchasePostArchivDiscount.SETRANGE("Version No.", vin_VersNo);
    //         IF NOT lrc_PurchasePostArchivDiscount.isempty()THEN BEGIN
    //             lfm_PurchasePostArchivDiscount.SETTABLEVIEW(lrc_PurchasePostArchivDiscount);
    //             lfm_PurchasePostArchivDiscount.RUNMODAL;
    //         END ELSE BEGIN
    //             IF vin_VersNo = 0 THEN BEGIN
    //                 ERROR(AGILES_LT_TEXT001, vco_DocNo);
    //             END ELSE BEGIN
    //                 ERROR(AGILES_LT_TEXT002, vco_DocNo, vin_VersNo);
    //             END;
    //         END;
    //     end;

    //     procedure PurchPostedArchiveDiscount(lop_InsertType: Option PostedDocument,Archiv; lrc_PurchHeader: Record "Purchase Header"; lco_InvHeaderNo: Code[20]; lco_CreditMemoHeaderNo: Code[20]; lin_VersNo: Integer)
    //     var
    //         lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment";
    //         lco_DocNo: Code[20];
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         gin_VersionNo := lin_VersNo;
    //         CASE lop_InsertType OF
    //             lop_InsertType::PostedDocument:
    //                 WITH lrc_PurchHeader DO BEGIN
    //                     IF NOT Invoice THEN
    //                         EXIT;

    //                     IF Invoice THEN BEGIN
    //                         IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
    //                             lop_DiscDocType := lop_DiscDocType::"Posted Invoice";
    //                             lco_DocNo := lco_InvHeaderNo;
    //                         END ELSE BEGIN// Credit Memo
    //                             lop_DiscDocType := lop_DiscDocType::"Posted Credit Memo";
    //                             lco_DocNo := lco_CreditMemoHeaderNo;
    //                         END;
    //                     END;
    //                 END;

    //             lop_InsertType::Archiv:
    //                 WITH lrc_PurchHeader DO BEGIN
    //                     CASE "Document Type" OF
    //                         "Document Type"::Quote:
    //                             lop_DiscDocType := lop_DiscDocType::"Archive Quote";
    //                         "Document Type"::"Blanket Order":
    //                             lop_DiscDocType := lop_DiscDocType::"Archive Blanket Order";
    //                         "Document Type"::Order:
    //                             lop_DiscDocType := lop_DiscDocType::"Archive Order";
    //                     END;
    //                     lco_DocNo := "No.";
    //                 END;
    //         END;

    //         PurchInsertPostArchDisc(lrc_PurchHeader, lop_DiscDocType, lco_DocNo);
    //     end;

    //     procedure PurchInsertPostArchDisc(lrc_PurchHeader: Record "Purchase Header"; lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment"; lco_PostedDocNo: Code[20])
    //     var
    //         lrc_PurchDisc: Record "5110381";
    //         lrc_PurchDiscLine: Record "5110382";
    //         lrc_PostedPurchDisc: Record "5110388";
    //         lrc_PostedPurchDiscLine: Record "5110389";
    //         lrc_PurchDiscArchive: Record "5110388";
    //         lrc_PurchDiscArchiveLine: Record "5110389";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         // Suche Rabatte
    //         lrc_PurchDisc.RESET();
    //         lrc_PurchDisc.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
    //         lrc_PurchDisc.SETRANGE("Document No.", lrc_PurchHeader."No.");
    //         IF lrc_PurchDisc.FIND('-') THEN BEGIN
    //             REPEAT
    //                 lrc_PostedPurchDisc.INIT();
    //                 lrc_PostedPurchDisc.TRANSFERFIELDS(lrc_PurchDisc);
    //                 lrc_PostedPurchDisc."Document Type" := lop_DiscDocType;
    //                 lrc_PostedPurchDisc."Document No." := lco_PostedDocNo;
    //                 lrc_PostedPurchDisc."Entry No." := lrc_PurchDisc."Entry No.";
    //                 lrc_PostedPurchDisc."Version No." := gin_VersionNo;

    //                 // Füge gebuchte Rabatt Belege ein
    //                 IF NOT lrc_PostedPurchDisc.INSERT THEN
    //                     lrc_PostedPurchDisc.MODIFY();

    //                 lrc_PurchDiscLine.SETRANGE("Document Type", lrc_PurchDisc."Document Type");
    //                 lrc_PurchDiscLine.SETRANGE("Document No.", lrc_PurchDisc."Document No.");
    //                 lrc_PurchDiscLine.SETRANGE("Purch. Disc. Entry No.", lrc_PurchDisc."Entry No.");
    //                 IF lrc_PurchDiscLine.FIND('-') THEN BEGIN
    //                     REPEAT
    //                         lrc_PostedPurchDiscLine.INIT();
    //                         lrc_PostedPurchDiscLine.TRANSFERFIELDS(lrc_PurchDiscLine);
    //                         lrc_PostedPurchDiscLine."Document Type" := lop_DiscDocType;
    //                         lrc_PostedPurchDiscLine."Document No." := lco_PostedDocNo;
    //                         lrc_PostedPurchDiscLine."Purch. Disc. Entry No." := lrc_PurchDiscLine."Purch. Disc. Entry No.";
    //                         lrc_PostedPurchDiscLine."Document Line No." := lrc_PurchDiscLine."Document Line No.";
    //                         lrc_PostedPurchDiscLine."Version No." := gin_VersionNo;
    //                         IF NOT lrc_PostedPurchDiscLine.INSERT THEN
    //                             lrc_PostedPurchDiscLine.MODIFY();
    //                     UNTIL lrc_PurchDiscLine.NEXT() = 0;
    //                 END;
    //             UNTIL lrc_PurchDisc.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PurchDocCopy(lin_FromDocType: Integer; lco_FromDocNo: Code[20]; lrc_ToPurchHeader: Record "Purchase Header"; lin_VersionNo: Integer)
    //     var
    //         lrc_PurchPostArchDisc: Record "5110388";
    //         lrc_PurchDiscount: Record "5110381";
    //         lrc_NewPurchDiscount: Record "5110381";
    //         Text001: Label 'Discounts allready exists. If you continue, discounts will de deleted.\Do you wish to continue?';
    //         Text002: Label 'Process stopped.';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         gop_PurchDocType := lin_FromDocType;
    //         gin_VersionNo := lin_VersionNo;

    //         IF gop_PurchDocType IN [gop_PurchDocType::Quote, gop_PurchDocType::"Blanket Order", gop_PurchDocType::Order,
    //                                 gop_PurchDocType::Invoice, gop_PurchDocType::"Return Order", gop_PurchDocType::"Credit Memo"]
    //         THEN BEGIN
    //             WITH lrc_PurchDiscount DO BEGIN
    //                 CASE gop_PurchDocType OF
    //                     gop_PurchDocType::Quote:
    //                         SETRANGE("Document Type", "Document Type"::Quote);
    //                     gop_PurchDocType::"Blanket Order":
    //                         SETRANGE("Document Type", "Document Type"::"Blanket Order");
    //                     gop_PurchDocType::Order:
    //                         SETRANGE("Document Type", "Document Type"::Order);
    //                     gop_PurchDocType::Invoice:
    //                         SETRANGE("Document Type", "Document Type"::Invoice);
    //                     gop_PurchDocType::"Return Order":
    //                         SETRANGE("Document Type", "Document Type"::"Return Order");
    //                     gop_PurchDocType::"Credit Memo":
    //                         SETRANGE("Document Type", "Document Type"::"Credit Memo");
    //                 END;
    //                 SETRANGE("Document No.", lco_FromDocNo);
    //                 IF FIND('-') THEN BEGIN

    //                     // Lösche vorhandene Rabatte
    //                     lrc_NewPurchDiscount.SETRANGE("Document Type", lrc_ToPurchHeader."Document Type");
    //                     lrc_NewPurchDiscount.SETRANGE("Document No.", lrc_ToPurchHeader."No.");
    //                     IF lrc_NewPurchDiscount.FIND('-') THEN
    //                         IF CONFIRM(Text001, TRUE) THEN
    //                             lrc_NewPurchDiscount.DELETEALL(TRUE)
    //                         ELSE
    //                             ERROR(Text002);

    //                     lrc_NewPurchDiscount.SETRANGE("Document Type");
    //                     lrc_NewPurchDiscount.SETRANGE("Document No.");

    //                     REPEAT
    //                         lrc_NewPurchDiscount.INIT();
    //                         lrc_NewPurchDiscount.TRANSFERFIELDS(lrc_PurchDiscount);
    //                         lrc_NewPurchDiscount."Document Type" := lrc_ToPurchHeader."Document Type";
    //                         lrc_NewPurchDiscount."Document No." := lrc_ToPurchHeader."No.";
    //                         lrc_NewPurchDiscount."Entry No." := "Entry No.";
    //                         IF lrc_NewPurchDiscount.INSERT THEN;
    //                     UNTIL NEXT = 0;
    //                 END;
    //             END;
    //         END ELSE BEGIN
    //             WITH lrc_PurchPostArchDisc DO BEGIN
    //                 CASE gop_PurchDocType OF
    //                     gop_PurchDocType::"Posted Invoice":
    //                         SETRANGE("Document Type", "Document Type"::"Posted Invoice");
    //                     gop_PurchDocType::"Posted Credit Memo":
    //                         SETRANGE("Document Type", "Document Type"::"Posted Credit Memo");
    //                     gop_PurchDocType::"Arch. Quote":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Quote");
    //                     gop_PurchDocType::"Arch. Order":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Order");
    //                     gop_PurchDocType::"Arch. Blanket Order":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Blanket Order");
    //                 END;
    //                 SETRANGE("Document No.", lco_FromDocNo);
    //                 SETRANGE("Version No.", gin_VersionNo);
    //                 IF FIND('-') THEN BEGIN

    //                     //Lösche vorhandene Rabatte
    //                     lrc_NewPurchDiscount.SETRANGE("Document Type", lrc_ToPurchHeader."Document Type");
    //                     lrc_NewPurchDiscount.SETRANGE("Document No.", lrc_ToPurchHeader."No.");
    //                     IF lrc_NewPurchDiscount.FIND('-') THEN
    //                         IF CONFIRM(Text001, TRUE) THEN
    //                             lrc_NewPurchDiscount.DELETEALL
    //                         ELSE
    //                             ERROR(Text002);

    //                     lrc_NewPurchDiscount.SETRANGE("Document Type");
    //                     lrc_NewPurchDiscount.SETRANGE("Document No.");

    //                     REPEAT
    //                         lrc_NewPurchDiscount.INIT();
    //                         lrc_NewPurchDiscount.TRANSFERFIELDS(lrc_PurchPostArchDisc);
    //                         lrc_NewPurchDiscount."Document Type" := lrc_ToPurchHeader."Document Type";
    //                         lrc_NewPurchDiscount."Document No." := lrc_ToPurchHeader."No.";
    //                         lrc_NewPurchDiscount."Entry No." := "Entry No.";
    //                         IF lrc_NewPurchDiscount.INSERT THEN;
    //                     UNTIL NEXT = 0;
    //                 END;
    //             END;
    //         END;
    //     end;

    //     procedure PurchDocCopyLines(lrc_FromPurchLine: Record "Purchase Line"; lrc_ToPurchLine: Record "Purchase Line")
    //     var
    //         lrc_PurchPostArchDiscLine: Record "5110389";
    //         lrc_PurchDiscountLine: Record "5110382";
    //         lrc_NewPurchDiscountLine: Record "5110382";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         IF gop_PurchDocType IN [gop_PurchDocType::Quote, gop_PurchDocType::"Blanket Order", gop_PurchDocType::Order,
    //                                 gop_PurchDocType::Invoice, gop_PurchDocType::"Return Order", gop_PurchDocType::"Credit Memo"]
    //         THEN BEGIN
    //             WITH lrc_PurchDiscountLine DO BEGIN
    //                 CASE gop_PurchDocType OF
    //                     gop_PurchDocType::Quote:
    //                         SETRANGE("Document Type", "Document Type"::Quote);
    //                     gop_PurchDocType::"Blanket Order":
    //                         SETRANGE("Document Type", "Document Type"::"Blanket Order");
    //                     gop_PurchDocType::Order:
    //                         SETRANGE("Document Type", "Document Type"::Order);
    //                     gop_PurchDocType::Invoice:
    //                         SETRANGE("Document Type", "Document Type"::Invoice);
    //                     gop_PurchDocType::"Return Order":
    //                         SETRANGE("Document Type", "Document Type"::"Return Order");
    //                     gop_PurchDocType::"Credit Memo":
    //                         SETRANGE("Document Type", "Document Type"::"Credit Memo");
    //                 END;
    //                 SETRANGE("Document No.", lrc_FromPurchLine."Document No.");
    //                 IF FIND('-') THEN
    //                     REPEAT
    //                         lrc_NewPurchDiscountLine.INIT();
    //                         lrc_NewPurchDiscountLine.TRANSFERFIELDS(lrc_PurchDiscountLine);
    //                         lrc_NewPurchDiscountLine."Document Type" := lrc_ToPurchLine."Document Type";
    //                         lrc_NewPurchDiscountLine."Document No." := lrc_ToPurchLine."Document No.";
    //                         lrc_NewPurchDiscountLine."Document Line No." := lrc_ToPurchLine."Line No.";
    //                         lrc_NewPurchDiscountLine."Purch. Disc. Entry No." := "Purch. Disc. Entry No.";
    //                         IF lrc_NewPurchDiscountLine.INSERT THEN;
    //                     UNTIL NEXT = 0;
    //             END;
    //         END ELSE BEGIN
    //             WITH lrc_PurchPostArchDiscLine DO BEGIN
    //                 CASE gop_PurchDocType OF
    //                     gop_PurchDocType::"Posted Invoice":
    //                         SETRANGE("Document Type", "Document Type"::"Posted Invoice");
    //                     gop_PurchDocType::"Posted Credit Memo":
    //                         SETRANGE("Document Type", "Document Type"::"Posted Credit Memo");
    //                     gop_PurchDocType::"Arch. Quote":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Quote");
    //                     gop_PurchDocType::"Arch. Order":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Blanket Order");
    //                     gop_PurchDocType::"Arch. Blanket Order":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Quote");
    //                 END;
    //                 SETRANGE("Document No.", lrc_FromPurchLine."Document No.");
    //                 SETRANGE("Version No.", gin_VersionNo);
    //                 IF FIND('-') THEN
    //                     REPEAT
    //                         lrc_NewPurchDiscountLine.INIT();
    //                         lrc_NewPurchDiscountLine.TRANSFERFIELDS(lrc_PurchPostArchDiscLine);
    //                         lrc_NewPurchDiscountLine."Document Type" := lrc_ToPurchLine."Document Type";
    //                         lrc_NewPurchDiscountLine."Document No." := lrc_ToPurchLine."Document No.";
    //                         lrc_NewPurchDiscountLine."Document Line No." := lrc_ToPurchLine."Line No.";
    //                         lrc_NewPurchDiscountLine."Purch. Disc. Entry No." := "Purch. Disc. Entry No.";
    //                         IF lrc_NewPurchDiscountLine.INSERT THEN;
    //                     UNTIL NEXT = 0;
    //             END;
    //         END;
    //     end;

    //     procedure CustomerDisc(vco_CustomerCode: Code[20]; vco_ShipToAdressCode: Code[10])
    //     var
    //         lrc_Customer: Record Customer;
    //         lrc_CustomerDiscount: Record "5110386";
    //     //lfm_CustomerDiscount: Form "5110386";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Debitorenrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_CustomerDiscount.RESET();
    //         lrc_CustomerDiscount.FILTERGROUP(2);
    //         lrc_CustomerDiscount.SETRANGE(Source, lrc_CustomerDiscount.Source::Customer);

    //         lrc_CustomerDiscount.SETRANGE("Source No.", vco_CustomerCode);
    //         IF vco_ShipToAdressCode <> '' THEN
    //             lrc_CustomerDiscount.SETRANGE("Ship-to Address Code", vco_ShipToAdressCode);
    //         lrc_CustomerDiscount.FILTERGROUP(0);

    //         lfm_CustomerDiscount.SETTABLEVIEW(lrc_CustomerDiscount);
    //         lfm_CustomerDiscount.RUNMODAL;
    //     end;

    //     procedure SalesDisc(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    //     var
    //         lrc_SalesDiscount: Record "5110344";
    //     //lfm_SalesDiscount: Form "5110379";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Verkaufsrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_SalesDiscount.FILTERGROUP(2);
    //         lrc_SalesDiscount.SETRANGE("Document Type", vop_DocType);
    //         lrc_SalesDiscount.SETRANGE("Document No.", vco_DocNo);
    //         lrc_SalesDiscount.FILTERGROUP(0);

    //         lfm_SalesDiscount.SETTABLEVIEW(lrc_SalesDiscount);
    //         lfm_SalesDiscount.RUNMODAL;

    //         // Kontrolle ob Leereinträge vorhanden sind
    //         lrc_SalesDiscount.RESET();
    //         lrc_SalesDiscount.SETRANGE("Document Type", vop_DocType);
    //         lrc_SalesDiscount.SETRANGE("Document No.", vco_DocNo);
    //         lrc_SalesDiscount.SETRANGE("Discount Code", '');
    //         IF NOT lrc_SalesDiscount.isempty()THEN
    //             lrc_SalesDiscount.DELETEALL(TRUE);
    //     end;

    //     procedure SalesDiscLoad(vrc_SalesHeader: Record "Sales Header"; vbn_Dialog: Boolean)
    //     var
    //         ADF_LT_TEXT001: Label 'Load Customer Discounts?';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zum Laden der Rabatte
    //         // -------------------------------------------------------------------------------------

    //         IF vbn_Dialog = TRUE THEN BEGIN
    //             // Möchten Sie die Debitorenrabatte laden?
    //             IF NOT CONFIRM(ADF_LT_TEXT001) THEN
    //                 ERROR('');
    //         END;

    //         // Verkaufskopfsatz lesen
    //         vrc_SalesHeader.TESTFIELD("Sell-to Customer No.");
    //         IF vrc_SalesHeader."Sell-to Customer No." = vrc_SalesHeader."Bill-to Customer No." THEN
    //             SalesDiscLoadCustNo(vrc_SalesHeader, vrc_SalesHeader."Sell-to Customer No.")
    //         ELSE
    //             SalesDiscLoadCustNo(vrc_SalesHeader, vrc_SalesHeader."Bill-to Customer No."); //TEST für KöllaHH!!!!!!
    //     end;

    //     procedure SalesDiscCalcLines(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zur Kalkulation der Rabattwerte und zum Schreiben der Zeilen
    //         // -------------------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Cust. Discount not Activ" = TRUE THEN
    //             EXIT;

    //         SalesDiscCalc(vop_DocType, vco_DocNo);
    //         SalesDiscSalesLines(vop_DocType, vco_DocNo);
    //     end;

    //     procedure SalesDiscSalesLines(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    //     var
    //         lrc_SalesHeader: Record "Sales Header";
    //         lrc_SalesLine: Record "Sales Line";
    //         lrc_SalesDiscountLine: Record "5110380";
    //         lrc_SalesLineDisc: Record "Sales Line";
    //         lrc_Discount: Record "5110383";
    //         lbn_LineAvailable: Boolean;
    //         lco_ProductPostGroup: Code[10];
    //         ldc_DiscAmount: Decimal;
    //         lco_GlAccountNo: Code[20];
    //         lin_LineCounter: Integer;
    //         lrc_Discount2: Record "5110383";
    //         AGILES_LT_TEXT001: Label 'Produktbuchungsgruppe Rabattcode %1 abweichend von Prod.Buch.Gruppe %2!';
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         "-- IFW 001 IFW40139": Integer;
    //         lrc_SalesShipmentLine: Record "Sales Shipment Line";
    //     // lrc_DocumentDimension: Record "357"; //TODO: dimension
    //     // lrc_DocumentDimension2: Record "357";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Erstellung / Aktualisierung der nicht Warenbezogenen Rabattzeilen
    //         // -------------------------------------------------------------------------------------

    //         IF lrc_SalesHeader.GET(vop_DocType, vco_DocNo) THEN;

    //         lrc_SalesLine.RESET();
    //         lrc_SalesLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //         IF lrc_SalesLine.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT

    //                 lin_LineCounter := 0;

    //                 lrc_Discount2.RESET();
    //                 lrc_Discount2.SETRANGE("Discount Type", lrc_Discount2."Discount Type"::Rechnungsrabatt);
    //                 lrc_Discount2.SETRANGE("Payment Timing", lrc_Discount2."Payment Timing"::Invoice);
    //                 IF lrc_Discount2.FIND('-') THEN BEGIN
    //                     REPEAT
    //                         lin_LineCounter := lin_LineCounter + 10;

    //                         lco_ProductPostGroup := '';
    //                         ldc_DiscAmount := 0;

    //                         lrc_SalesLineDisc.RESET();
    //                         //hf001-
    //                         lrc_SalesLineDisc.SETCURRENTKEY("Document Type", "Document No.", Type, Subtyp, "Attached to Line No.", "Discount Code");
    //                         //hf001+
    //                         lrc_SalesLineDisc.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //                         lrc_SalesLineDisc.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //                         lrc_SalesLineDisc.SETRANGE(Type, lrc_SalesLineDisc.Type::"G/L Account");
    //                         lrc_SalesLineDisc.SETRANGE(Subtyp, lrc_SalesLineDisc.Subtyp::Discount);
    //                         lrc_SalesLineDisc.SETRANGE("Attached to Line No.", lrc_SalesLine."Line No.");
    //                         lrc_SalesLineDisc.SETRANGE("Discount Code", lrc_Discount2.Code);
    //                         //hf001-
    //                         //IF lrc_SalesLineDisc.FIND('-') THEN
    //                         //  lbn_LineAvailable := TRUE
    //                         //ELSE
    //                         //  lbn_LineAvailable := FALSE;
    //                         lbn_LineAvailable := lrc_SalesLineDisc.FIND('-');
    //                         //hf001+

    //                         lrc_SalesDiscountLine.RESET();
    //                         //hf001-
    //                         lrc_SalesDiscountLine.SETCURRENTKEY("Document Type", "Document No."
    //                           , "Document Line No.", "Discount Type", "Payment Timing", "Discount Code");
    //                         //hf001+
    //                         lrc_SalesDiscountLine.SETRANGE("Document Type", lrc_SalesLine."Document Type");
    //                         lrc_SalesDiscountLine.SETRANGE("Document No.", lrc_SalesLine."Document No.");
    //                         lrc_SalesDiscountLine.SETRANGE("Document Line No.", lrc_SalesLine."Line No.");
    //                         lrc_SalesDiscountLine.SETRANGE("Discount Type", lrc_SalesDiscountLine."Discount Type"::Rechnungsrabatt);
    //                         lrc_SalesDiscountLine.SETRANGE("Payment Timing", lrc_SalesDiscountLine."Payment Timing"::Invoice);
    //                         lrc_SalesDiscountLine.SETRANGE("Discount Code", lrc_Discount2.Code);
    //                         IF lrc_SalesDiscountLine.FINDSET(FALSE, FALSE) THEN BEGIN
    //                             REPEAT
    //                                 lrc_Discount.GET(lrc_SalesDiscountLine."Discount Code");
    //                                 lrc_Discount.TESTFIELD("Gen. Prod. Posting Group");
    //                                 IF lco_ProductPostGroup = '' THEN BEGIN
    //                                     lco_ProductPostGroup := lrc_Discount."Gen. Prod. Posting Group";
    //                                 END ELSE BEGIN
    //                                     IF lco_ProductPostGroup <> lrc_Discount."Gen. Prod. Posting Group" THEN
    //                                         // Produktbuchungsgruppe Rabattcode %1 abweichend von Prod.Buch.Gruppe %2!
    //                                         ERROR(AGILES_LT_TEXT001, lrc_Discount.Code, lco_ProductPostGroup);
    //                                 END;
    //                                 ldc_DiscAmount := ldc_DiscAmount + lrc_SalesDiscountLine."Disc. Amount";
    //                             UNTIL lrc_SalesDiscountLine.NEXT() = 0;

    //                             IF lbn_LineAvailable = FALSE THEN BEGIN
    //                                 lrc_SalesLineDisc.RESET();
    //                                 lrc_SalesLineDisc.INIT();
    //                                 lrc_SalesLineDisc."Document Type" := lrc_SalesLine."Document Type";
    //                                 lrc_SalesLineDisc."Document No." := lrc_SalesLine."Document No.";
    //                                 lrc_SalesLineDisc."Line No." := lrc_SalesLine."Line No." + lin_LineCounter;
    //                                 lrc_SalesLineDisc.insert();

    //                                 lrc_SalesLineDisc."Sell-to Customer No." := lrc_SalesLine."Sell-to Customer No.";
    //                                 lrc_SalesLineDisc.Type := lrc_SalesLineDisc.Type::"G/L Account";
    //                                 // Sachkonto feststellen
    //                                 //RS GLAccount nicht aus SalesHeader
    //                                 //lco_GlAccountNo := SalesGetDiscAlloc(lrc_SalesHeader."Gen. Bus. Posting Group",lco_ProductPostGroup);
    //                                 lco_GlAccountNo := SalesGetDiscAlloc(lrc_SalesLine."Gen. Bus. Posting Group", lco_ProductPostGroup);
    //                                 lrc_SalesLineDisc.VALIDATE("No.", lco_GlAccountNo);
    //                                 IF lco_ProductPostGroup <> '' THEN BEGIN
    //                                     lrc_SalesLineDisc.VALIDATE("Gen. Prod. Posting Group", lco_ProductPostGroup);
    //                                 END;
    //                                 lrc_SalesLineDisc.VALIDATE(Quantity, lrc_SalesLine.Quantity);
    //                                 lrc_SalesLineDisc.VALIDATE("Price Base (Sales Price)", '');
    //                                 lrc_SalesLineDisc.VALIDATE("Sales Price (Price Base)",
    //                                                   (ROUND(ldc_DiscAmount / lrc_SalesLineDisc.Quantity, 0.00001) * -1));
    //                                 lrc_SalesLineDisc."Master Batch No." := lrc_SalesLine."Master Batch No.";
    //                                 lrc_SalesLineDisc.VALIDATE("Batch No.", lrc_SalesLine."Batch No.");
    //                                 lrc_SalesLineDisc."Attached to Line No." := lrc_SalesLine."Line No.";

    //                                 IF (lrc_SalesLine."Document Type" = lrc_SalesLine."Document Type"::Invoice) AND
    //                                    (lrc_SalesLine."Shipment No." <> '') AND
    //                                    (lrc_SalesLine."Shipment Line No." <> 0) THEN BEGIN

    //                                     // In Lieferung nachschauen
    //                                     lrc_SalesShipmentLine.RESET();
    //                                     //hf001-
    //                                     lrc_SalesShipmentLine.SETCURRENTKEY("Document No.", "Attached to Line No.", Type, "No."
    //                                         , Quantity, "Gen. Prod. Posting Group");
    //                                     //hf001+
    //                                     lrc_SalesShipmentLine.SETRANGE("Document No.", lrc_SalesLine."Shipment No.");
    //                                     lrc_SalesShipmentLine.SETRANGE("Attached to Line No.", lrc_SalesLine."Shipment Line No.");
    //                                     // Ist es hinreichend identisch?
    //                                     lrc_SalesShipmentLine.SETRANGE(Type, lrc_SalesLineDisc.Type);
    //                                     lrc_SalesShipmentLine.SETRANGE("No.", lrc_SalesLineDisc."No.");
    //                                     lrc_SalesShipmentLine.SETRANGE(Quantity, lrc_SalesLineDisc.Quantity);
    //                                     lrc_SalesShipmentLine.SETRANGE("Gen. Prod. Posting Group", lrc_SalesLineDisc."Gen. Prod. Posting Group");
    //                                     // lrc_SalesShipmentLine.SETRANGE("Sales Price (Price Base)", lrc_SalesLineDisc."Sales Price (Price Base)");
    //                                     // lrc_SalesShipmentLine.SETRANGE("Master Batch No.", lrc_SalesLineDisc."Master Batch No.");
    //                                     // lrc_SalesShipmentLine.SETRANGE("Batch No.", lrc_SalesLineDisc."Batch No.");
    //                                     IF lrc_SalesShipmentLine.FIND('-') THEN BEGIN
    //                                         // Aus zugehöriger Lieferzeile Werte übernehmen
    //                                         lrc_SalesLineDisc."Shipment No." := lrc_SalesShipmentLine."Document No.";
    //                                         lrc_SalesLineDisc."Shipment Line No." := lrc_SalesShipmentLine."Line No.";
    //                                         // Zuweisung des "Sell-to Customer No." aus der Lieferzeile, da dieser sich unterscheiden könnte
    //                                         // Wenn die Sachkontozeile per Standard abgerufen würde, würde der Sell-To Customer ebenfalls
    //                                         // dem aus der Lieferung entsprechen. (Programmierung ist noch deaktiviert)
    //                                         // lrc_SalesLineDisc."Sell-to Customer No." := lrc_SalesShipmentLine."Sell-to Customer No.";
    //                                     END;

    //                                 END;

    //                             END;

    //                             lrc_SalesLineDisc."Location Code" := lrc_SalesLine."Location Code";
    //                             lrc_SalesLineDisc.VALIDATE(Quantity, lrc_SalesLine.Quantity);
    //                             lrc_SalesLineDisc.VALIDATE("Price Base (Sales Price)", '');
    //                             lrc_SalesLineDisc.VALIDATE("Sales Price (Price Base)",
    //                                               (ROUND(ldc_DiscAmount / lrc_SalesLineDisc.Quantity, 0.00001) * -1));

    //                             IF lrc_SalesLine."Shortcut Dimension 1 Code" <> '' THEN
    //                                 lrc_SalesLineDisc.VALIDATE("Shortcut Dimension 1 Code", lrc_SalesLine."Shortcut Dimension 1 Code");
    //                             IF lrc_SalesLine."Shortcut Dimension 2 Code" <> '' THEN
    //                                 lrc_SalesLineDisc.VALIDATE("Shortcut Dimension 2 Code", lrc_SalesLine."Shortcut Dimension 2 Code");
    //                             IF lrc_SalesLine."Shortcut Dimension 3 Code" <> '' THEN
    //                                 lrc_SalesLineDisc.VALIDATE("Shortcut Dimension 3 Code", lrc_SalesLine."Shortcut Dimension 3 Code");
    //                             IF lrc_SalesLine."Shortcut Dimension 4 Code" <> '' THEN
    //                                 lrc_SalesLineDisc.VALIDATE("Shortcut Dimension 4 Code", lrc_SalesLine."Shortcut Dimension 4 Code");
    //                             lrc_SalesLineDisc.Subtyp := lrc_SalesLineDisc.Subtyp::Discount;
    //                             lrc_SalesLineDisc."Allow Invoice Disc." := FALSE;

    //                             //RS Übernahme Dimensionen in Rabattzeile
    //                             lrc_DocumentDimension.RESET();
    //                             lrc_DocumentDimension.SETRANGE("Table ID", 37);
    //                             lrc_DocumentDimension.SETRANGE("Document Type", lrc_SalesLine."Document Type");
    //                             lrc_DocumentDimension.SETRANGE("Document No.", lrc_SalesLine."Document No.");
    //                             lrc_DocumentDimension.SETRANGE("Line No.", lrc_SalesLine."Line No.");
    //                             IF lrc_DocumentDimension.FINDSET(FALSE, FALSE) THEN BEGIN
    //                                 REPEAT
    //                                     lrc_DocumentDimension2.SETRANGE("Table ID", 37);
    //                                     lrc_DocumentDimension2.SETRANGE("Document Type", lrc_DocumentDimension."Document Type");
    //                                     lrc_DocumentDimension2.SETRANGE("Document No.", lrc_DocumentDimension."Document No.");
    //                                     lrc_DocumentDimension2.SETRANGE("Line No.", lrc_SalesLineDisc."Line No.");
    //                                     lrc_DocumentDimension2.SETRANGE("Dimension Code", lrc_DocumentDimension."Dimension Code");
    //                                     IF NOT lrc_DocumentDimension2.FINDSET() THEN BEGIN
    //                                         lrc_DocumentDimension2.RESET();
    //                                         lrc_DocumentDimension2.INIT();
    //                                         lrc_DocumentDimension2."Table ID" := 37;
    //                                         lrc_DocumentDimension2."Document Type" := lrc_DocumentDimension."Document Type";
    //                                         lrc_DocumentDimension2."Document No." := lrc_DocumentDimension."Document No.";
    //                                         lrc_DocumentDimension2."Line No." := lrc_SalesLineDisc."Line No.";
    //                                         lrc_DocumentDimension2."Dimension Code" := lrc_DocumentDimension."Dimension Code";
    //                                         lrc_DocumentDimension2."Dimension Value Code" := lrc_DocumentDimension."Dimension Value Code";
    //                                         lrc_DocumentDimension2.insert();
    //                                     END;
    //                                 UNTIL lrc_DocumentDimension.NEXT() = 0;
    //                             END;

    //                             //RS.e

    //                             IF lrc_SalesLine."Qty. to Ship" <> 0 THEN BEGIN
    //                                 lrc_SalesLineDisc.VALIDATE("Qty. to Ship", lrc_SalesLine."Qty. to Ship");
    //                             END ELSE BEGIN
    //                                 IF lrc_SalesLine."Quantity Shipped" <> lrc_SalesLine.Quantity THEN BEGIN
    //                                     lrc_SalesLineDisc.VALIDATE("Qty. to Ship", 0);
    //                                 END;
    //                             END;
    //                             IF lrc_SalesLine."Qty. to Invoice" <> 0 THEN BEGIN
    //                                 lrc_SalesLineDisc.VALIDATE("Qty. to Invoice", lrc_SalesLine."Qty. to Invoice");
    //                             END ELSE BEGIN
    //                                 IF lrc_SalesLine."Quantity Invoiced" <> lrc_SalesLine.Quantity THEN BEGIN
    //                                     lrc_SalesLineDisc.VALIDATE("Qty. to Invoice", 0);
    //                                 END;
    //                             END;

    //                             lrc_SalesLineDisc."Discount Code" := lrc_Discount.Code;

    //                             lrc_FruitVisionSetup.GET();
    //                             CASE lrc_FruitVisionSetup."Sales Disc. Line G.B. Grp." OF
    //                                 lrc_FruitVisionSetup."Sales Disc. Line G.B. Grp."::"Equal to Source Line":
    //                                     BEGIN
    //                                         lrc_SalesLineDisc.VALIDATE("Gen. Bus. Posting Group", lrc_SalesLine."Gen. Bus. Posting Group");
    //                                         lrc_SalesLineDisc.VALIDATE("VAT Bus. Posting Group", lrc_SalesLine."VAT Bus. Posting Group");
    //                                     END;
    //                             END;

    //                             lrc_SalesLineDisc.MODIFY();
    //                         END ELSE BEGIN
    //                             IF lbn_LineAvailable = TRUE THEN BEGIN
    //                                 lrc_SalesLineDisc.DELETE(TRUE);
    //                             END;
    //                         END;

    //                     UNTIL lrc_Discount2.NEXT() = 0;
    //                 END;

    //             UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure SalesDiscCalc(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    //     var
    //         lrc_SalesHeader: Record "Sales Header";
    //         lrc_SalesLine: Record "Sales Line";
    //         lrc_SalesLine2: Record "Sales Line";
    //         lrc_SalesLine3: Record "Sales Line";
    //         lrc_SalesDisc: Record "5110344";
    //         lrc_SalesDiscLine: Record "5110380";
    //         lrc_UnitofMeasure: Record "Unit of Measure";
    //         lrc_Disc: Record "5110383";
    //         lrc_DiscWeightSalesPrice: Record "5110350";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_Vendor: Record Vendor;
    //         lrc_CountryRegion: Record "9";
    //         lrc_SalesDiscTemp: Record "5110344" temporary;
    //         lrc_BatchSetup: Record "5110363";
    //         lco_VendorNo: Code[20];
    //         lco_VendorCountryGroup: Code[20];
    //         ldc_GoodsInvDisc: Decimal;
    //         ldc_NonGoodsInvDisc: Decimal;
    //         ldc_AccruelInvDisc: Decimal;
    //         ldc_TotalGoodsInvDisc: Decimal;
    //         ldc_ArrSumDiscLevelSalesLine: array[9] of Decimal;
    //         ldc_RoundingValue: Decimal;
    //         ldc_SalesLineAmount: Decimal;
    //         ldc_DifferenceAmount: Decimal;
    //         ldc_SplitAmount: Decimal;
    //         ldc_TotalQuantityCU: Decimal;
    //         lin_StartLevel: Integer;
    //         lin_ActCalcLevel: Integer;
    //         AGILES_LT_TEXT001: Label 'Bezugsgröße Rabatt %1 für Verkauf nicht zugelassen!';
    //         lin_SalesLineLast: Integer;
    //         lin_SalesLineCount: Integer;
    //         lbn_DiscNotValidFor: Boolean;
    //         lrc_Item: Record Item;
    //         "-- RAB 007 SCH40046 L": Integer;
    //         lbn_IsEmptiesItem: Boolean;
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zur Kalkulation der Rabattwerte
    //         // -------------------------------------------------------------------------------------

    //         // Verkaufskopfsatz lesen
    //         IF NOT lrc_SalesHeader.GET(vop_DocType, vco_DocNo) THEN
    //             EXIT;

    //         lrc_SalesDiscLine.RESET();
    //         lrc_SalesDiscLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //         lrc_SalesDiscLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //         lrc_SalesDiscLine.DELETEALL();

    //         lrc_SalesLine.RESET();
    //         lrc_SalesLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN

    //             lin_SalesLineCount := 0;
    //             lin_SalesLineLast := 0;
    //             ldc_TotalQuantityCU := 0;

    //             lrc_SalesLine2.RESET();
    //             lrc_SalesLine2.COPY(lrc_SalesLine);
    //             lrc_SalesLine2.SETRANGE("Allow Invoice Disc.", TRUE);
    //             lrc_SalesLine2.SETFILTER(Quantity, '<>%1', 0);
    //             IF lrc_SalesLine2.FINDSET(FALSE, FALSE) THEN BEGIN
    //                 REPEAT
    //                     lin_SalesLineCount := lin_SalesLineCount + 1;
    //                     ldc_TotalQuantityCU := ldc_TotalQuantityCU + lrc_SalesLine2.Quantity;
    //                 UNTIL lrc_SalesLine2.NEXT() = 0;
    //                 lin_SalesLineLast := lrc_SalesLine2."Line No.";
    //             END;

    //             REPEAT

    //                 lbn_IsEmptiesItem := FALSE;
    //                 IF lrc_SalesLine.Type = lrc_SalesLine.Type::Item THEN BEGIN
    //                     IF lrc_Item.GET(lrc_SalesLine."No.") THEN BEGIN
    //                         lbn_IsEmptiesItem := (lrc_Item."Empties Quantity" <> 0);
    //                     END;
    //                 END;

    //                 // Werte zurücksetzen
    //                 CLEAR(ldc_ArrSumDiscLevelSalesLine);
    //                 ldc_GoodsInvDisc := 0;
    //                 ldc_NonGoodsInvDisc := 0;
    //                 ldc_AccruelInvDisc := 0;

    //                 IF (lrc_SalesLine."Allow Invoice Disc." = TRUE) AND
    //                    (lrc_SalesLine.Quantity <> 0) THEN BEGIN

    //                     // Kreditor lesen
    //                     lco_VendorNo := '';
    //                     lco_VendorCountryGroup := '';
    //                     IF lrc_BatchVariant.GET(lrc_SalesLine."Batch Variant No.") THEN BEGIN
    //                         lco_VendorNo := lrc_BatchVariant."Vendor No.";
    //                         IF lrc_Vendor.GET(lco_VendorNo) THEN BEGIN
    //                             IF lrc_CountryRegion.GET(lrc_Vendor."Country/Region Code") THEN
    //                                 lco_VendorCountryGroup := lrc_CountryRegion."Country Group Code";
    //                         END;
    //                     END;

    //                     // Rabatte Auftrag lesen
    //                     lrc_SalesDisc.RESET();
    //                     lrc_SalesDisc.SETCURRENTKEY("Calculation Level");
    //                     lrc_SalesDisc.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //                     lrc_SalesDisc.SETRANGE("Document No.", lrc_SalesHeader."No.");

    //                     IF lrc_SalesLine.Type = lrc_SalesLine.Type::"Charge (Item)" THEN BEGIN
    //                         lrc_SalesDisc.SETFILTER("Item No.", '%1|%2', lrc_SalesLine."Reference Item No.", '')
    //                     END ELSE BEGIN
    //                         lrc_SalesDisc.SETFILTER("Item No.", '%1|%2', lrc_SalesLine."No.", '');
    //                         lrc_SalesDisc.SETFILTER("Unit of Measure Code", '%1|%2', lrc_SalesLine."Unit of Measure Code", '');
    //                     END;

    //                     lrc_SalesDisc.SETFILTER("Product Group Code", '%1|%2', lrc_SalesLine."Product Group Code", '');
    //                     lrc_SalesDisc.SETFILTER("Item Category Code", '%1|%2', lrc_SalesLine."Item Category Code", '');
    //                     lrc_SalesDisc.SETFILTER("Vendor No.", '%1|%2', lco_VendorNo, '');
    //                     lrc_SalesDisc.SETFILTER("Vendor Country Group", '%1|%2', lco_VendorCountryGroup, '');
    //                     lrc_SalesDisc.SETFILTER("Location Code", '%1|%2', lrc_SalesLine."Location Code", '');
    //                     lrc_SalesDisc.SETFILTER("Shipment Method Code", '%1|%2', lrc_SalesHeader."Shipment Method Code", '');
    //                     lrc_SalesDisc.SETFILTER("Trademark Code", '%1|%2', lrc_SalesLine."Trademark Code", '');
    //                     lrc_SalesDisc.SETFILTER("Service Invoice Customer No.", '%1|%2', lrc_SalesHeader."Service Invoice to Cust. No.", '');
    //                     lrc_SalesDisc.SETFILTER("Person in Charge Code", '%1|%2', lrc_SalesHeader."Person in Charge Code", '');
    //                     lrc_SalesDisc.SETFILTER("Status Customs Duty", '%1|%2', lrc_SalesLine."Status Customs Duty",
    //                                                                           lrc_SalesDisc."Status Customs Duty"::" ");
    //                     IF lrc_SalesDisc.FIND('-') THEN BEGIN

    //                         lin_StartLevel := lrc_SalesDisc."Calculation Level";
    //                         lin_ActCalcLevel := lrc_SalesDisc."Calculation Level";

    //                         REPEAT

    //                             IF lrc_Disc.GET(lrc_SalesDisc."Discount Code") THEN BEGIN

    //                                 // Prüfung ob der Rabatt ein Ausschlusskriterium beinhaltet
    //                                 lbn_DiscNotValidFor := FALSE;
    //                                 IF (lrc_SalesDisc."Not Valid for" <> lrc_SalesDisc."Not Valid for"::" ") AND
    //                                    (lrc_SalesDisc."Not Valid for Filter" <> '') THEN BEGIN

    //                                     // Prüfung ob das Ausschlusskriterium für die aktuelle Verkaufszeile zutrifft
    //                                     lrc_SalesLine3.RESET();
    //                                     lrc_SalesLine3.SETRANGE("Document Type", lrc_SalesLine."Document Type");
    //                                     lrc_SalesLine3.SETRANGE("Document No.", lrc_SalesLine."Document No.");
    //                                     lrc_SalesLine3.SETRANGE("Line No.", lrc_SalesLine."Line No.");
    //                                     CASE lrc_SalesDisc."Not Valid for" OF
    //                                         lrc_SalesDisc."Not Valid for"::"Item Category":
    //                                             BEGIN
    //                                                 lrc_SalesLine3.SETFILTER("Item Category Code", lrc_SalesDisc."Not Valid for Filter");
    //                                             END;
    //                                         lrc_SalesDisc."Not Valid for"::"Product Group":
    //                                             BEGIN
    //                                                 lrc_SalesLine3.SETFILTER("Product Group Code", lrc_SalesDisc."Not Valid for Filter");
    //                                             END;
    //                                         lrc_SalesDisc."Not Valid for"::"Item No.":
    //                                             BEGIN
    //                                                 lrc_SalesLine3.SETFILTER("No.", lrc_SalesDisc."Not Valid for Filter");
    //                                             END;
    //                                         lrc_SalesDisc."Not Valid for"::Trademark:
    //                                             BEGIN
    //                                                 lrc_SalesLine3.SETFILTER("Trademark Code", lrc_SalesDisc."Not Valid for Filter");
    //                                             END;
    //                                         //RS Erweiterung Verpackungscode
    //                                         lrc_SalesDisc."Not Valid for"::"Proper Name":
    //                                             BEGIN
    //                                                 lrc_SalesLine3.SETFILTER("Item Attribute 6", lrc_SalesDisc."Not Valid for Filter");
    //                                             END;
    //                                     //RS Ende Erweiterung Verpackungscode
    //                                     END;
    //                                     IF lrc_SalesLine3.FIND('-') THEN
    //                                         lbn_DiscNotValidFor := TRUE;
    //                                 END;

    //                                 IF ((lrc_Disc."Sub Typ" = lrc_Disc."Sub Typ"::" ") OR
    //                                     ((lrc_Disc."Sub Typ" = lrc_Disc."Sub Typ"::VVE) //AND
    //                                                                                     //RS lrc_SalesLine."Empties Quantity" trotzdem Rabatt!!!
    //                                                                                     // RAB 007 SCH40046.s
    //                                                                                     //(lrc_SalesLine."Empties Quantity" = 0)
    //                                      AND NOT lbn_IsEmptiesItem)) AND
    //                                     // RAB 007 SCH40046.e

    //                                     (lbn_DiscNotValidFor = FALSE) THEN BEGIN

    //                                     IF lrc_SalesDisc."Calculation Level" > lin_ActCalcLevel THEN
    //                                         lin_ActCalcLevel := lrc_SalesDisc."Calculation Level";

    //                                     // Rabattzeile Auftrag lesen / anlegen
    //                                     lrc_SalesDiscLine.RESET();
    //                                     lrc_SalesDiscLine.SETRANGE("Document Type", lrc_SalesDisc."Document Type");
    //                                     lrc_SalesDiscLine.SETRANGE("Document No.", lrc_SalesDisc."Document No.");
    //                                     lrc_SalesDiscLine.SETRANGE("Sales Disc. Entry No.", lrc_SalesDisc."Entry No.");
    //                                     lrc_SalesDiscLine.SETRANGE("Document Line No.", lrc_SalesLine."Line No.");
    //                                     IF NOT lrc_SalesDiscLine.FIND('-') THEN BEGIN
    //                                         // Neuanlage
    //                                         lrc_SalesDiscLine.RESET();
    //                                         lrc_SalesDiscLine.INIT();
    //                                         lrc_SalesDiscLine."Document Type" := lrc_SalesDisc."Document Type";
    //                                         lrc_SalesDiscLine."Document No." := lrc_SalesDisc."Document No.";
    //                                         lrc_SalesDiscLine."Sales Disc. Entry No." := lrc_SalesDisc."Entry No.";
    //                                         lrc_SalesDiscLine."Document Line No." := lrc_SalesLine."Line No.";
    //                                         lrc_SalesDiscLine.insert();
    //                                     END;

    //                                     lrc_SalesDiscLine."Discount Code" := lrc_SalesDisc."Discount Code";
    //                                     lrc_SalesDiscLine."Discount Type" := lrc_SalesDisc."Discount Type";
    //                                     lrc_SalesDiscLine."Base Discount Value" := lrc_SalesDisc."Base Discount Value";
    //                                     lrc_SalesDiscLine."Discount Value" := lrc_SalesDisc."Discount Value";
    //                                     lrc_SalesDiscLine."Basis %-Value incl. VAT" := lrc_SalesDisc."Basis %-Value incl. VAT";
    //                                     lrc_SalesDiscLine."Payment Timing" := lrc_SalesDisc."Payment Timing";
    //                                     // DMG 005 DMG50043.s
    //                                     // lrc_SalesDiscLine."Discount Depend on Weight" := lrc_SalesDisc."Discount Depend on Weight";
    //                                     // DMG 005 DMG50043.e
    //                                     lrc_SalesDiscLine."Discount not on Customer Duty" := lrc_SalesDisc."Discount not on Customer Duty";
    //                                     lrc_SalesDiscLine."Restrict. Freight Unit" := lrc_SalesDisc."Restrict. Freight Unit";
    //                                     lrc_SalesDiscLine."Location Code" := lrc_SalesDisc."Location Code";
    //                                     lrc_SalesDiscLine."Product Group Code" := lrc_SalesDisc."Product Group Code";
    //                                     lrc_SalesDiscLine."Item Category Code" := lrc_SalesDisc."Item Category Code";
    //                                     lrc_SalesDiscLine."Trademark Code" := lrc_SalesDisc."Trademark Code";
    //                                     lrc_SalesDiscLine."Vendor No." := lrc_SalesDisc."Vendor No.";
    //                                     lrc_SalesDiscLine."Vendor Country Group" := lrc_SalesDisc."Vendor Country Group";
    //                                     lrc_SalesDiscLine."Service Invoice Customer No." := lrc_SalesDisc."Service Invoice Customer No.";
    //                                     lrc_SalesDiscLine."Shipment Method Code" := lrc_SalesDisc."Shipment Method Code";
    //                                     lrc_SalesDiscLine."Person in Charge Code" := lrc_SalesDisc."Person in Charge Code";
    //                                     lrc_SalesDiscLine."Status Customs Duty" := lrc_SalesDisc."Status Customs Duty";
    //                                     lrc_SalesDiscLine."Posting to Sell-to Customer" := lrc_SalesDisc."Posting to Sell-to Customer";

    //                                     IF lrc_SalesLine.Type = lrc_SalesLine.Type::Item THEN BEGIN
    //                                         lrc_SalesDiscLine."Item No." := lrc_SalesLine."No.";
    //                                         lrc_SalesDiscLine."Variant Code" := lrc_SalesLine."Variant Code";
    //                                         lrc_SalesDiscLine."Unit of Measure Code" := lrc_SalesDisc."Unit of Measure Code";
    //                                     END ELSE BEGIN
    //                                         // Rabatte müssen bei Gutschrfiten aus Reklamationen als Sachposten gebucht werden
    //                                         // wenn die Artikelnr. leer ist funktioniert es nicht!

    //                                         //IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") AND
    //                                         //  (lrc_SalesHeader."Sales Claim Notify No." <> '') THEN BEGIN
    //                                         IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") AND
    //                                            (lrc_SalesLine.Type = lrc_SalesLine.Type::"Charge (Item)") THEN BEGIN
    //                                             lrc_BatchSetup.GET();
    //                                             CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                                                 lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                                                     lrc_SalesDiscLine.VALIDATE("Batch No.", lrc_SalesLine."Shortcut Dimension 1 Code");
    //                                                 lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                                                     lrc_SalesDiscLine.VALIDATE("Batch No.", lrc_SalesLine."Shortcut Dimension 2 Code");
    //                                                 lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                                                     lrc_SalesDiscLine.VALIDATE("Batch No.", lrc_SalesLine."Shortcut Dimension 3 Code");
    //                                                 lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                                                     lrc_SalesDiscLine.VALIDATE("Batch No.", lrc_SalesLine."Shortcut Dimension 4 Code");
    //                                             END;
    //                                             lrc_SalesDiscLine."Item No." := lrc_SalesLine."No.";
    //                                             lrc_SalesDiscLine."Variant Code" := '';
    //                                         END ELSE BEGIN
    //                                             lrc_SalesDiscLine."Item No." := '';
    //                                             lrc_SalesDiscLine."Variant Code" := '';
    //                                         END;
    //                                     END;
    //                                     lrc_SalesDiscLine.VALIDATE("Batch No.", lrc_SalesLine."Batch No.");

    //                                     IF lrc_SalesHeader."Currency Code" = '' THEN BEGIN
    //                                         lrc_SalesDiscLine."Currency Code" := lrc_SalesHeader."Currency Code";
    //                                         lrc_SalesDiscLine."Currency Factor" := 1;
    //                                     END ELSE BEGIN
    //                                         lrc_SalesDiscLine."Currency Code" := lrc_SalesHeader."Currency Code";
    //                                         lrc_SalesDiscLine."Currency Factor" := lrc_SalesHeader."Currency Factor";
    //                                     END;
    //                                     lrc_SalesDiscLine."Sell-to Customer No." := lrc_SalesHeader."Sell-to Customer No.";
    //                                     lrc_SalesDiscLine."Document Posting Date" := lrc_SalesHeader."Posting Date";


    //                                     CASE lrc_SalesDisc."Base Discount Value" OF
    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::Prozentsatz:
    //                                             BEGIN
    //                                                 ldc_SalesLineAmount := lrc_SalesLine."Line Amount";

    //                                                 // Kontrolle ob Rabatt nur auf Verkaufspreis ohne Zoll
    //                                                 IF lrc_SalesDiscLine."Discount not on Customer Duty" = TRUE THEN BEGIN
    //                                                     IF (lrc_SalesLine."Status Customs Duty" = lrc_SalesLine."Status Customs Duty"::Payed) OR
    //                                                        (lrc_SalesLine."Status Customs Duty" = lrc_SalesLine."Status Customs Duty"::" ") THEN BEGIN
    //                                                         // Zollanteil aus dem Verkaufsbetrag rausrechnen --> Zoll in Fremdwährung umrechnen
    //                                                         IF lrc_SalesHeader."Currency Code" <> '' THEN BEGIN
    //                                                             ldc_SalesLineAmount := ldc_SalesLineAmount -
    //                                                                                    (lrc_SalesLine."Cust. Duty Amount (LCY)" *
    //                                                                                     lrc_SalesHeader."Currency Factor");
    //                                                         END ELSE BEGIN
    //                                                             ldc_SalesLineAmount := ldc_SalesLineAmount - lrc_SalesLine."Cust. Duty Amount (LCY)";
    //                                                         END;
    //                                                     END;
    //                                                 END ELSE BEGIN
    //                                                 END;

    //                                                 IF lrc_SalesDisc."Basis %-Value incl. VAT" = FALSE THEN BEGIN
    //                                                     IF lin_ActCalcLevel > 1 THEN BEGIN
    //                                                         lrc_SalesDiscLine."Disc. Amount" := (ldc_SalesLineAmount -
    //                                                                                             ldc_ArrSumDiscLevelSalesLine[(lin_ActCalcLevel - 1)]) *
    //                                                                                             (lrc_SalesDiscLine."Discount Value" / 100);
    //                                                         // RAB 011 0806637A.s
    //                                                         lrc_SalesDiscLine."Base Disc. Amount" := (ldc_SalesLineAmount -
    //                                                                                                   ldc_ArrSumDiscLevelSalesLine[(lin_ActCalcLevel - 1)]);
    //                                                         // RAB 011 0806637A.e

    //                                                     END ELSE BEGIN
    //                                                         lrc_SalesDiscLine."Disc. Amount" := ldc_SalesLineAmount *
    //                                                                                             (lrc_SalesDiscLine."Discount Value" / 100);
    //                                                         // RAB 011 0806637A.s
    //                                                         lrc_SalesDiscLine."Base Disc. Amount" := ldc_SalesLineAmount;
    //                                                         // RAB 011 0806637A.e
    //                                                     END;
    //                                                 END ELSE BEGIN
    //                                                     IF lin_ActCalcLevel > 1 THEN BEGIN
    //                                                         lrc_SalesDiscLine."Disc. Amount" := (ldc_SalesLineAmount -
    //                                                                                             ldc_ArrSumDiscLevelSalesLine[(lin_ActCalcLevel - 1)]) *
    //                                                                                             (1 + (lrc_SalesLine."VAT %" / 100)) *
    //                                                                                             (lrc_SalesDiscLine."Discount Value" / 100);
    //                                                         // RAB 011 0806637A.s
    //                                                         lrc_SalesDiscLine."Base Disc. Amount" := (ldc_SalesLineAmount -
    //                                                                                                   ldc_ArrSumDiscLevelSalesLine[(lin_ActCalcLevel - 1)]) *
    //                                                                                                   (1 + (lrc_SalesLine."VAT %" / 100));
    //                                                         // RAB 011 0806637A.e

    //                                                     END ELSE BEGIN
    //                                                         lrc_SalesDiscLine."Disc. Amount" := (ldc_SalesLineAmount *
    //                                                                                             (1 + (lrc_SalesLine."VAT %" / 100))) *
    //                                                                                             (lrc_SalesDiscLine."Discount Value" / 100);
    //                                                         // RAB 011 0806637A.s
    //                                                         lrc_SalesDiscLine."Base Disc. Amount" := ldc_SalesLineAmount *
    //                                                                                                  (1 + (lrc_SalesLine."VAT %" / 100));
    //                                                         // RAB 011 0806637A.e

    //                                                     END;
    //                                                 END;
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Absoluter Betrag auf Zeilenbasis":
    //                                             BEGIN
    //                                                 ldc_SplitAmount := 0;
    //                                                 ldc_DifferenceAmount := 0;
    //                                                 // Rabattbetrag durch die Anzahl der Zeilen teilen
    //                                                 ldc_SplitAmount := ROUND(lrc_SalesDiscLine."Discount Value" / lin_SalesLineCount, 0.01);

    //                                                 IF lrc_SalesLine."Line No." <> lin_SalesLineLast THEN BEGIN
    //                                                     // normale Zeile
    //                                                     lrc_SalesDiscLine."Disc. Amount" := ldc_SplitAmount;
    //                                                 END ELSE BEGIN
    //                                                     // letzte Zeile --> Summierung Restsumme
    //                                                     ldc_DifferenceAmount := (ldc_SplitAmount * lin_SalesLineCount) - lrc_SalesDiscLine."Discount Value";
    //                                                     lrc_SalesDiscLine."Disc. Amount" := ldc_SplitAmount - ldc_DifferenceAmount;
    //                                                 END;
    //                                                 // Umrechnung auf andere Währung falls vorhanden
    //                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN BEGIN
    //                                                     lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDiscLine."Disc. Amount" * lrc_SalesDiscLine."Currency Factor";
    //                                                 END;
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Absoluter Betrag auf Kollobasis":
    //                                             BEGIN
    //                                                 ldc_SplitAmount := 0;
    //                                                 ldc_DifferenceAmount := 0;
    //                                                 // Rabattbetrag durch die Menge Kollo teilen
    //                                                 ldc_SplitAmount := ROUND((lrc_SalesDiscLine."Discount Value" / ldc_TotalQuantityCU) *
    //                                                                           lrc_SalesLine.Quantity, 0.01);

    //                                                 IF NOT lrc_SalesDiscTemp.GET(lrc_SalesDisc."Document Type",
    //                                                                              lrc_SalesDisc."Document No.",
    //                                                                              lrc_SalesDisc."Entry No.") THEN BEGIN
    //                                                     lrc_SalesDiscTemp."Document Type" := lrc_SalesDisc."Document Type";
    //                                                     lrc_SalesDiscTemp."Document No." := lrc_SalesDisc."Document No.";
    //                                                     lrc_SalesDiscTemp."Entry No." := lrc_SalesDisc."Entry No.";
    //                                                     lrc_SalesDiscTemp."Disc. Amount" := ldc_SplitAmount;
    //                                                     lrc_SalesDiscTemp.insert();
    //                                                 END ELSE BEGIN
    //                                                     lrc_SalesDiscTemp."Disc. Amount" := lrc_SalesDiscTemp."Disc. Amount" + ldc_SplitAmount;
    //                                                     lrc_SalesDiscTemp.MODIFY();
    //                                                 END;

    //                                                 IF lrc_SalesLine."Line No." <> lin_SalesLineLast THEN BEGIN
    //                                                     // normale Zeile
    //                                                     lrc_SalesDiscLine."Disc. Amount" := ldc_SplitAmount;
    //                                                 END ELSE BEGIN
    //                                                     // letzte Zeile --> Summierung Restsumme
    //                                                     ldc_DifferenceAmount := lrc_SalesDiscTemp."Disc. Amount" - lrc_SalesDiscLine."Discount Value";
    //                                                     lrc_SalesDiscLine."Disc. Amount" := ldc_SplitAmount - ldc_DifferenceAmount;
    //                                                 END;

    //                                                 // Umrechnung auf andere Währung falls vorhanden
    //                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN BEGIN
    //                                                     lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDiscLine."Disc. Amount" * lrc_SalesDiscLine."Currency Factor";
    //                                                 END;

    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Betrag Pro Kolli":
    //                                             BEGIN
    //                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_SalesLine.Quantity * lrc_SalesDisc."Discount Value";
    //                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                     lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDiscLine."Disc. Amount" * lrc_SalesDiscLine."Currency Factor";
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::Kolloeinheit:
    //                                             BEGIN
    //                                                 lrc_UnitofMeasure.GET(lrc_SalesLine."Unit of Measure Code");
    //                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_SalesLine.Quantity * lrc_UnitofMeasure."Sales Accruel per Collo (LCY)";
    //                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                     lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDiscLine."Disc. Amount" * lrc_SalesDiscLine."Currency Factor";
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Proz. auf Einheit gerundet":
    //                                             BEGIN
    //                                                 // Bezugsgröße Rabatt für Verkauf nicht zugelassen!
    //                                                 ERROR(AGILES_LT_TEXT001, FORMAT(lrc_SalesDisc."Base Discount Value"));
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Betrag Pro Frachteinheit":
    //                                             BEGIN
    //                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_SalesLine."Quantity (TU)" * lrc_SalesDisc."Discount Value";
    //                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                     lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDiscLine."Disc. Amount" * lrc_SalesDiscLine."Currency Factor";
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Betrag pro Kilo":
    //                                             BEGIN
    //                                                 // Bezugsgröße Rabatt für Verkauf nicht zugelassen!
    //                                                 ERROR(AGILES_LT_TEXT001, FORMAT(lrc_SalesDisc."Base Discount Value"));
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Gew.-Abhängiger Betrag":
    //                                             BEGIN

    //                                                 CASE lrc_SalesDisc."Ref. Disc. Depend on Weight" OF
    //                                                     lrc_SalesDisc."Ref. Disc. Depend on Weight"::" ":
    //                                                         BEGIN
    //                                                             lrc_DiscWeightSalesPrice.RESET();
    //                                                             lrc_DiscWeightSalesPrice.SETRANGE("Discount Code", lrc_SalesDisc."Discount Code");
    //                                                             lrc_DiscWeightSalesPrice.SETRANGE("Unit Type", lrc_DiscWeightSalesPrice."Unit Type"::Weight);
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Customer No.", '%1|%2', lrc_SalesLine."Sell-to Customer No.", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Item No.", '%1|%2', lrc_SalesLine."No.", '');
    //                                                             IF lrc_Item.GET(lrc_SalesLine."No.") THEN BEGIN
    //                                                                 lrc_DiscWeightSalesPrice.SETFILTER("Item Main Category Code", '%1|%2', lrc_Item."Item Main Category Code", '');
    //                                                             END;
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Item Category Code", '%1|%2', lrc_SalesLine."Item Category Code", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Product Group Code", '%1|%2', lrc_SalesLine."Product Group Code", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER(Unit, '<=%1', lrc_SalesLine."Qty. per Unit of Measure");
    //                                                             IF lrc_DiscWeightSalesPrice.FINDLAST THEN BEGIN
    //                                                                 lrc_SalesDiscLine."Discount Value" := lrc_DiscWeightSalesPrice."Amount per Unit";
    //                                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_DiscWeightSalesPrice."Amount per Unit" * lrc_SalesLine.Quantity;
    //                                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                                     lrc_SalesDiscLine."Disc. Amount" := ROUND(lrc_SalesDiscLine."Disc. Amount" *
    //                                                                                                               lrc_SalesDiscLine."Currency Factor", 0.00001);
    //                                                             END;
    //                                                         END;

    //                                                     lrc_SalesDisc."Ref. Disc. Depend on Weight"::"Net Weight Collo":
    //                                                         BEGIN
    //                                                             lrc_DiscWeightSalesPrice.RESET();
    //                                                             lrc_DiscWeightSalesPrice.SETRANGE("Discount Code", lrc_SalesDisc."Discount Code");
    //                                                             lrc_DiscWeightSalesPrice.SETRANGE("Unit Type", lrc_DiscWeightSalesPrice."Unit Type"::Weight);
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Customer No.", '%1|%2', lrc_SalesLine."Sell-to Customer No.", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Item No.", '%1|%2', lrc_SalesLine."No.", '');
    //                                                             IF lrc_Item.GET(lrc_SalesLine."No.") THEN BEGIN
    //                                                                 lrc_DiscWeightSalesPrice.SETFILTER("Item Main Category Code", '%1|%2', lrc_Item."Item Main Category Code", '');
    //                                                             END;
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Item Category Code", '%1|%2', lrc_SalesLine."Item Category Code", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Product Group Code", '%1|%2', lrc_SalesLine."Product Group Code", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER(Unit, '<=%1', lrc_SalesLine."Net Weight");
    //                                                             IF lrc_DiscWeightSalesPrice.FINDLAST THEN BEGIN
    //                                                                 lrc_SalesDiscLine."Discount Value" := lrc_DiscWeightSalesPrice."Amount per Unit";
    //                                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_DiscWeightSalesPrice."Amount per Unit" * lrc_SalesLine.Quantity;
    //                                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                                     lrc_SalesDiscLine."Disc. Amount" := ROUND(lrc_SalesDiscLine."Disc. Amount" *
    //                                                                                                               lrc_SalesDiscLine."Currency Factor", 0.00001);
    //                                                             END;
    //                                                         END;

    //                                                     lrc_SalesDisc."Ref. Disc. Depend on Weight"::"Gross Weight Collo":
    //                                                         BEGIN
    //                                                             lrc_DiscWeightSalesPrice.RESET();
    //                                                             lrc_DiscWeightSalesPrice.SETRANGE("Discount Code", lrc_SalesDisc."Discount Code");
    //                                                             lrc_DiscWeightSalesPrice.SETRANGE("Unit Type", lrc_DiscWeightSalesPrice."Unit Type"::Weight);
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Customer No.", '%1|%2', lrc_SalesLine."Sell-to Customer No.", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Item No.", '%1|%2', lrc_SalesLine."No.", '');
    //                                                             IF lrc_Item.GET(lrc_SalesLine."No.") THEN BEGIN
    //                                                                 lrc_DiscWeightSalesPrice.SETFILTER("Item Main Category Code", '%1|%2', lrc_Item."Item Main Category Code", '');
    //                                                             END;
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Item Category Code", '%1|%2', lrc_SalesLine."Item Category Code", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Product Group Code", '%1|%2', lrc_SalesLine."Product Group Code", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER(Unit, '<=%1', lrc_SalesLine."Gross Weight");
    //                                                             IF lrc_DiscWeightSalesPrice.FIND('+') THEN BEGIN
    //                                                                 lrc_SalesDiscLine."Discount Value" := lrc_DiscWeightSalesPrice."Amount per Unit";
    //                                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_DiscWeightSalesPrice."Amount per Unit" * lrc_SalesLine.Quantity;
    //                                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                                     lrc_SalesDiscLine."Disc. Amount" := ROUND(lrc_SalesDiscLine."Disc. Amount" *
    //                                                                                                               lrc_SalesDiscLine."Currency Factor", 0.00001);
    //                                                             END;
    //                                                         END;

    //                                                 END;
    //                                             END;

    //                                         lrc_SalesDisc."Base Discount Value"::"VK-Preis abhängiger Betrag":
    //                                             BEGIN
    //                                                 lrc_DiscWeightSalesPrice.RESET();
    //                                                 lrc_DiscWeightSalesPrice.SETRANGE("Discount Code", lrc_SalesDisc."Discount Code");
    //                                                 lrc_DiscWeightSalesPrice.SETRANGE("Unit Type", lrc_DiscWeightSalesPrice."Unit Type"::"Sales Price");
    //                                                 lrc_DiscWeightSalesPrice.SETFILTER("Customer No.", '%1|%2', lrc_SalesLine."Sell-to Customer No.", '');
    //                                                 lrc_DiscWeightSalesPrice.SETFILTER("Item No.", '%1|%2', lrc_SalesLine."No.", '');
    //                                                 IF lrc_Item.GET(lrc_SalesLine."No.") THEN BEGIN
    //                                                     lrc_DiscWeightSalesPrice.SETFILTER("Item Main Category Code", '%1|%2', lrc_Item."Item Main Category Code", '');
    //                                                 END;
    //                                                 lrc_DiscWeightSalesPrice.SETFILTER("Item Category Code", '%1|%2', lrc_SalesLine."Item Category Code", '');
    //                                                 lrc_DiscWeightSalesPrice.SETFILTER("Product Group Code", '%1|%2', lrc_SalesLine."Product Group Code", '');
    //                                                 lrc_DiscWeightSalesPrice.SETFILTER(Unit, '<=%1', lrc_SalesLine."Sales Price (Price Base)");
    //                                                 IF lrc_DiscWeightSalesPrice.FIND('+') THEN BEGIN
    //                                                     lrc_SalesDiscLine."Discount Value" := lrc_DiscWeightSalesPrice."Amount per Unit";
    //                                                     lrc_SalesDiscLine."Disc. Amount" := lrc_DiscWeightSalesPrice."Amount per Unit" * lrc_SalesLine.Quantity;
    //                                                     IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                         lrc_SalesDiscLine."Disc. Amount" := ROUND(lrc_SalesDiscLine."Disc. Amount" *
    //                                                                                                   lrc_SalesDiscLine."Currency Factor", 0.00001);
    //                                                 END;
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Betrag pro Netto Kilo":
    //                                             BEGIN
    //                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_SalesLine."Total Net Weight" * lrc_SalesDisc."Discount Value";
    //                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                     lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDiscLine."Disc. Amount" * lrc_SalesDiscLine."Currency Factor";
    //                                             END;

    //                                         // -----------------------------------------------------------------------------------------------------
    //                                         lrc_SalesDisc."Base Discount Value"::"Betrag pro Brutto Kilo":
    //                                             BEGIN

    //                                                 CASE lrc_SalesDisc."Ref. Disc. Depend on Weight" OF
    //                                                     lrc_SalesDisc."Ref. Disc. Depend on Weight"::"Gross Weight Collo":
    //                                                         BEGIN
    //                                                             lrc_DiscWeightSalesPrice.RESET();
    //                                                             lrc_DiscWeightSalesPrice.SETRANGE("Discount Code", lrc_SalesDisc."Discount Code");
    //                                                             lrc_DiscWeightSalesPrice.SETRANGE("Unit Type", lrc_DiscWeightSalesPrice."Unit Type"::Weight);
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Customer No.", '%1|%2', lrc_SalesLine."Sell-to Customer No.", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Item No.", '%1|%2', lrc_SalesLine."No.", '');
    //                                                             IF lrc_Item.GET(lrc_SalesLine."No.") THEN BEGIN
    //                                                                 lrc_DiscWeightSalesPrice.SETFILTER("Item Main Category Code", '%1|%2', lrc_Item."Item Main Category Code", '');
    //                                                             END;
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Item Category Code", '%1|%2', lrc_SalesLine."Item Category Code", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER("Product Group Code", '%1|%2', lrc_SalesLine."Product Group Code", '');
    //                                                             lrc_DiscWeightSalesPrice.SETFILTER(Unit, '<=%1', lrc_SalesLine."Gross Weight");
    //                                                             IF lrc_DiscWeightSalesPrice.FINDLAST THEN BEGIN
    //                                                                 lrc_SalesDiscLine."Discount Value" := lrc_DiscWeightSalesPrice."Amount per Unit";
    //                                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_DiscWeightSalesPrice."Amount per Unit" *
    //                                                                                                      lrc_SalesLine."Total Gross Weight";
    //                                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                                     lrc_SalesDiscLine."Disc. Amount" := ROUND(lrc_SalesDiscLine."Disc. Amount" *
    //                                                                                                               lrc_SalesDiscLine."Currency Factor", 0.00001);
    //                                                             END ELSE BEGIN
    //                                                                 lrc_SalesDiscLine."Discount Value" := lrc_DiscWeightSalesPrice."Amount per Unit";
    //                                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDisc."Discount Value" * lrc_SalesLine."Total Gross Weight";
    //                                                                 IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                                     lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDiscLine."Disc. Amount" *
    //                                                                                                         lrc_SalesDiscLine."Currency Factor";
    //                                                             END;

    //                                                         END;

    //                                                     ELSE BEGIN
    //                                                             lrc_SalesDiscLine."Disc. Amount" := lrc_SalesLine."Total Gross Weight" * lrc_SalesDisc."Discount Value";
    //                                                             IF lrc_SalesDiscLine."Currency Code" <> '' THEN
    //                                                                 lrc_SalesDiscLine."Disc. Amount" := lrc_SalesDiscLine."Disc. Amount" * lrc_SalesDiscLine."Currency Factor";
    //                                                         END;
    //                                                 END;

    //                                             END;

    //                                     END;

    //                                     // Werte für zu erhalten und zu fakturieren berechnen
    //                                     IF lrc_SalesLine."Document Type" = lrc_SalesLine."Document Type"::"Credit Memo" THEN BEGIN
    //                                         lrc_SalesDiscLine."Disc. Amount to Ship" := lrc_SalesDiscLine."Disc. Amount";
    //                                         lrc_SalesDiscLine."Disc. Amount to Invoice" := lrc_SalesDiscLine."Disc. Amount";
    //                                         // RAB 011 0806637A.s
    //                                         lrc_SalesDiscLine."Base Disc. Amount to Invoice" := lrc_SalesDiscLine."Base Disc. Amount";
    //                                         lrc_SalesDiscLine."Base Disc. Amount to Ship" := lrc_SalesDiscLine."Base Disc. Amount";
    //                                         // RAB 011 0806637A.e

    //                                     END ELSE BEGIN
    //                                         lrc_SalesDiscLine."Disc. Amount to Ship" := lrc_SalesDiscLine."Disc. Amount" *
    //                                                                                         lrc_SalesLine."Qty. to Ship" /
    //                                                                                         lrc_SalesLine.Quantity;
    //                                         lrc_SalesDiscLine."Disc. Amount to Invoice" := lrc_SalesDiscLine."Disc. Amount" *
    //                                                                                         lrc_SalesLine."Qty. to Invoice" /
    //                                                                                         lrc_SalesLine.Quantity;
    //                                         // RAB 011 0806637A.s
    //                                         lrc_SalesDiscLine."Base Disc. Amount to Invoice" := lrc_SalesDiscLine."Base Disc. Amount" *
    //                                                                                             lrc_SalesLine."Qty. to Invoice" /
    //                                                                                              lrc_SalesLine.Quantity;
    //                                         lrc_SalesDiscLine."Base Disc. Amount to Ship" := lrc_SalesDiscLine."Base Disc. Amount" *
    //                                                                                          lrc_SalesLine."Qty. to Ship" /
    //                                                                                          lrc_SalesLine.Quantity;
    //                                         // RAB 011 0806637A.e

    //                                     END;

    //                                     // Rabattbeträge in lokale Währung umrechnen
    //                                     lrc_SalesDiscLine."Disc. Amount (LCY)" := lrc_SalesDiscLine."Disc. Amount" /
    //                                                                                   lrc_SalesDiscLine."Currency Factor";
    //                                     lrc_SalesDiscLine."Disc. Amount to Ship (LCY)" := lrc_SalesDiscLine."Disc. Amount to Ship" /
    //                                                                                           lrc_SalesDiscLine."Currency Factor";
    //                                     lrc_SalesDiscLine."Disc. Amount to Invoice (LCY)" := lrc_SalesDiscLine."Disc. Amount to Invoice" /
    //                                                                                              lrc_SalesDiscLine."Currency Factor";

    //                                     // RAB 011 0806637A.s
    //                                     lrc_SalesDiscLine."Base Disc. Amount (LCY)" := lrc_SalesDiscLine."Base Disc. Amount" /
    //                                                                                    lrc_SalesDiscLine."Currency Factor";
    //                                     lrc_SalesDiscLine."Base Disc. Amount to Shi (LCY)" := lrc_SalesDiscLine."Base Disc. Amount to Ship" /
    //                                                                                           lrc_SalesDiscLine."Currency Factor";
    //                                     lrc_SalesDiscLine."Base Disc. Amount to Inv (LCY)" := lrc_SalesDiscLine."Base Disc. Amount to Invoice" /
    //                                                                                           lrc_SalesDiscLine."Currency Factor";
    //                                     // RAB 011 0806637A.e


    //                                     // Rabattbeträge runden
    //                                     // POI 001 0818795A.S
    //                                     //POI 001 00000000 JST 080213 001 Funktion "SalesDiscCalc": Anpassung Rabattrundung -> Lidl 10626
    //                                     //IF lrc_SalesDiscLine."Sell-to Customer No." = '10626'
    //                                     //  THEN ldc_RoundingValue := 0.00001
    //                                     //  ELSE ldc_RoundingValue := 0.01;
    //                                     ldc_RoundingValue := 0.01;

    //                                     lrc_SalesDiscLine."Disc. Amount" := ROUND(lrc_SalesDiscLine."Disc. Amount", ldc_RoundingValue);
    //                                     //lrc_SalesDiscLine."Disc. Amount to Invoice" := ROUND(lrc_SalesDiscLine."Disc. Amount to Invoice",
    //                                     //ldc_RoundingValue);
    //                                     lrc_SalesDiscLine.VALIDATE("Disc. Amount to Invoice", lrc_SalesDiscLine."Disc. Amount");
    //                                     // POI 001 0818795A.E
    //                                     lrc_SalesDiscLine."Disc. Amount to Ship" := ROUND(lrc_SalesDiscLine."Disc. Amount to Ship", ldc_RoundingValue);
    //                                     lrc_SalesDiscLine."Disc. Amount (LCY)" := ROUND(lrc_SalesDiscLine."Disc. Amount (LCY)", ldc_RoundingValue);
    //                                     lrc_SalesDiscLine."Disc. Amount to Ship (LCY)" := ROUND(lrc_SalesDiscLine."Disc. Amount to Ship (LCY)",
    //                                                                                             ldc_RoundingValue);
    //                                     lrc_SalesDiscLine."Disc. Amount to Invoice (LCY)" := ROUND(lrc_SalesDiscLine."Disc. Amount to Invoice (LCY)",
    //                                                                                                ldc_RoundingValue);
    //                                     // RAB 011 0806637A.s
    //                                     lrc_SalesDiscLine."Base Disc. Amount" := ROUND(lrc_SalesDiscLine."Base Disc. Amount", ldc_RoundingValue);
    //                                     lrc_SalesDiscLine."Base Disc. Amount to Invoice" := ROUND(lrc_SalesDiscLine."Base Disc. Amount to Invoice",
    //                                                                                         ldc_RoundingValue);
    //                                     lrc_SalesDiscLine."Base Disc. Amount to Ship" := ROUND(lrc_SalesDiscLine."Base Disc. Amount to Ship",
    //                                                                                            ldc_RoundingValue);
    //                                     lrc_SalesDiscLine."Base Disc. Amount (LCY)" := ROUND(lrc_SalesDiscLine."Base Disc. Amount (LCY)",
    //                                                                                           ldc_RoundingValue);
    //                                     lrc_SalesDiscLine."Base Disc. Amount to Shi (LCY)" := ROUND(lrc_SalesDiscLine."Base Disc. Amount to Shi (LCY)",
    //                                                                                                 ldc_RoundingValue);
    //                                     lrc_SalesDiscLine."Base Disc. Amount to Inv (LCY)" := ROUND(lrc_SalesDiscLine."Base Disc. Amount to Inv (LCY)",
    //                                                                                                 ldc_RoundingValue);
    //                                     // RAB 011 0806637A.e

    //                                     // Kontierung
    //                                     lrc_SalesDiscLine."Gen. Bus. Posting Group" := lrc_SalesLine."Gen. Bus. Posting Group";
    //                                     IF (lrc_SalesDisc."Discount Type" = lrc_SalesDisc."Discount Type"::Warenrechnungsrabatt) OR
    //                                        (lrc_SalesDisc."Discount Type" = lrc_SalesDisc."Discount Type"::Artikelrabatt) THEN BEGIN
    //                                         lrc_SalesDiscLine."Gen. Prod. Posting Group" := lrc_SalesLine."Gen. Prod. Posting Group"
    //                                     END ELSE BEGIN
    //                                         lrc_Disc.GET(lrc_SalesDisc."Discount Code");
    //                                         lrc_Disc.TESTFIELD("Gen. Prod. Posting Group");
    //                                         lrc_SalesDiscLine."Gen. Prod. Posting Group" := lrc_Disc."Gen. Prod. Posting Group";
    //                                     END;

    //                                     lrc_SalesDiscLine.MODIFY();

    //                                     // Rabatte nach VAT % und Zahlungszeitpunkt aufaddieren
    //                                     IF lrc_SalesDisc."Payment Timing" = lrc_SalesDisc."Payment Timing"::Invoice THEN BEGIN
    //                                         IF (lrc_SalesDisc."Discount Type" = lrc_SalesDisc."Discount Type"::Warenrechnungsrabatt) OR
    //                                            (lrc_SalesDisc."Discount Type" = lrc_SalesDisc."Discount Type"::Artikelrabatt) THEN BEGIN
    //                                             ldc_GoodsInvDisc := ldc_GoodsInvDisc + lrc_SalesDiscLine."Disc. Amount";
    //                                         END ELSE BEGIN
    //                                             ldc_NonGoodsInvDisc := ldc_NonGoodsInvDisc + lrc_SalesDiscLine."Disc. Amount";
    //                                         END;
    //                                     END ELSE BEGIN
    //                                         ldc_AccruelInvDisc := ldc_AccruelInvDisc + lrc_SalesDiscLine."Disc. Amount";
    //                                     END;

    //                                     ldc_ArrSumDiscLevelSalesLine[lin_ActCalcLevel] := ldc_ArrSumDiscLevelSalesLine[lin_ActCalcLevel] +
    //                                                                                         lrc_SalesDiscLine."Disc. Amount"
    //                                 END;

    //                             END;
    //                         UNTIL lrc_SalesDisc.NEXT() = 0;
    //                     END;

    //                 END ELSE BEGIN
    //                     // Kontrolle ob es bereits einen Zeilenrabattsatz gibt

    //                 END;

    //                 // Werte in Verkaufszeile zurückschreiben
    //                 IF ldc_GoodsInvDisc <> lrc_SalesLine."Inv. Discount Amount" THEN BEGIN
    //                     lrc_SalesLine.VALIDATE("Inv. Discount Amount", ldc_GoodsInvDisc);
    //                 END;
    //                 lrc_SalesLine."Inv. Disc. not Relat. to Goods" := ldc_NonGoodsInvDisc;
    //                 lrc_SalesLine."Accruel Inv. Disc. (External)" := ldc_AccruelInvDisc;
    //                 lrc_SalesLine.MODIFY();

    //             UNTIL lrc_SalesLine.NEXT() = 0;


    //             // -----------------------------------------------------------------------------------------------------------------
    //             // Rabatte aus Rabattzeilen aufaddieren
    //             // -----------------------------------------------------------------------------------------------------------------
    //             lrc_SalesDisc.RESET();
    //             lrc_SalesDisc.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //             lrc_SalesDisc.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //             IF lrc_SalesDisc.FINDSET(TRUE, FALSE) THEN BEGIN
    //                 REPEAT
    //                     lrc_SalesDisc."Disc. Amount" := 0;
    //                     lrc_SalesDisc."Disc. Amount to Invoice" := 0;
    //                     lrc_SalesDisc."Disc. Amount to Ship" := 0;
    //                     lrc_SalesDisc."Disc. Amount (LCY)" := 0;
    //                     lrc_SalesDisc."Disc. Amount to Invoice (LCY)" := 0;
    //                     lrc_SalesDisc."Disc. Amount to Ship (LCY)" := 0;

    //                     // RAB 011 0806637A.s
    //                     lrc_SalesDisc."Base Disc. Amount" := 0;
    //                     lrc_SalesDisc."Base Disc. Amount to Invoice" := 0;
    //                     lrc_SalesDisc."Base Disc. Amount to Ship" := 0;
    //                     lrc_SalesDisc."Base Disc. Amount (LCY)" := 0;
    //                     lrc_SalesDisc."Base Disc. Amount to Inv (LCY)" := 0;
    //                     lrc_SalesDisc."Base Disc. Amount to Shi (LCY)" := 0;
    //                     // RAB 011 0806637A.e

    //                     lrc_SalesDiscLine.SETRANGE("Document Type", lrc_SalesDisc."Document Type");
    //                     lrc_SalesDiscLine.SETRANGE("Document No.", lrc_SalesDisc."Document No.");
    //                     lrc_SalesDiscLine.SETRANGE("Sales Disc. Entry No.", lrc_SalesDisc."Entry No.");
    //                     IF lrc_SalesDiscLine.FINDSET(FALSE, FALSE) THEN BEGIN
    //                         REPEAT
    //                             lrc_SalesDisc."Disc. Amount" := ROUND(lrc_SalesDisc."Disc. Amount" +
    //                                                                   lrc_SalesDiscLine."Disc. Amount", 0.01);
    //                             lrc_SalesDisc."Disc. Amount to Invoice" := ROUND(lrc_SalesDisc."Disc. Amount to Invoice" +
    //                                                                              lrc_SalesDiscLine."Disc. Amount to Invoice", 0.01);
    //                             lrc_SalesDisc."Disc. Amount to Ship" := ROUND(lrc_SalesDisc."Disc. Amount to Ship" +
    //                                                                           lrc_SalesDiscLine."Disc. Amount to Ship", 0.01);
    //                             lrc_SalesDisc."Disc. Amount (LCY)" := ROUND(lrc_SalesDisc."Disc. Amount (LCY)" +
    //                                                                         lrc_SalesDiscLine."Disc. Amount (LCY)", 0.01);
    //                             lrc_SalesDisc."Disc. Amount to Invoice (LCY)" := ROUND(lrc_SalesDisc."Disc. Amount to Invoice (LCY)" +
    //                                                                                    lrc_SalesDiscLine."Disc. Amount to Invoice (LCY)", 0.01);
    //                             lrc_SalesDisc."Disc. Amount to Ship (LCY)" := ROUND(lrc_SalesDisc."Disc. Amount to Ship (LCY)" +
    //                                                                                 lrc_SalesDiscLine."Disc. Amount to Ship (LCY)", 0.01);

    //                             // RAB 011 0806637A.s
    //                             lrc_SalesDisc."Base Disc. Amount" := ROUND(lrc_SalesDisc."Base Disc. Amount" +
    //                                                                         lrc_SalesDiscLine."Base Disc. Amount", 0.01);
    //                             lrc_SalesDisc."Base Disc. Amount to Invoice" := ROUND(lrc_SalesDisc."Base Disc. Amount to Invoice" +
    //                                                                                    lrc_SalesDiscLine."Base Disc. Amount to Invoice", 0.01);
    //                             lrc_SalesDisc."Base Disc. Amount to Ship" := ROUND(lrc_SalesDisc."Base Disc. Amount to Ship" +
    //                                                                                 lrc_SalesDiscLine."Base Disc. Amount to Ship", 0.01);
    //                             lrc_SalesDisc."Base Disc. Amount (LCY)" := ROUND(lrc_SalesDisc."Base Disc. Amount (LCY)" +
    //                                                                               lrc_SalesDiscLine."Base Disc. Amount (LCY)", 0.01);
    //                             lrc_SalesDisc."Base Disc. Amount to Inv (LCY)" := ROUND(lrc_SalesDisc."Base Disc. Amount to Inv (LCY)" +
    //                                                                                          lrc_SalesDiscLine."Base Disc. Amount to Inv (LCY)", 0.01);
    //                             lrc_SalesDisc."Base Disc. Amount to Shi (LCY)" := ROUND(lrc_SalesDisc."Base Disc. Amount to Shi (LCY)" +
    //                                                                                       lrc_SalesDiscLine."Base Disc. Amount to Shi (LCY)", 0.01);
    //                         // RAB 011 0806637A.e

    //                         UNTIL lrc_SalesDiscLine.NEXT() = 0;
    //                     END;

    //                     lrc_SalesDisc.MODIFY();

    //                     // Gesamtsumme Warenrechnungsrabatt auf Rechnung addieren
    //                     IF ((lrc_SalesDisc."Discount Type" = lrc_SalesDisc."Discount Type"::Warenrechnungsrabatt) OR
    //                         (lrc_SalesDisc."Discount Type" = lrc_SalesDisc."Discount Type"::Artikelrabatt)) AND
    //                        (lrc_SalesDisc."Payment Timing" = lrc_SalesDisc."Payment Timing"::Invoice) THEN BEGIN
    //                         ldc_TotalGoodsInvDisc := ldc_TotalGoodsInvDisc + lrc_SalesDisc."Disc. Amount";
    //                     END;

    //                 UNTIL lrc_SalesDisc.NEXT() = 0;
    //             END;

    //         END;

    //         // Werte in den Verkaufskopfsatz zurückschreiben
    //         lrc_SalesHeader."Invoice Discount Calculation" := lrc_SalesHeader."Invoice Discount Calculation"::Amount;
    //         lrc_SalesHeader."Invoice Discount Value" := ldc_TotalGoodsInvDisc;
    //         lrc_SalesHeader."Invoice Disc. Code" := '';
    //         lrc_SalesHeader.MODIFY();
    //     end;

    //     procedure SalesShowDiscSum(vop_DocTyp: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; var rbn_Vorhanden: Boolean; var rdc_RgRabWare: Decimal; var rdc_RgRabOhneWarenBezug: Decimal; var "rdc_RgRabRückstellung": Decimal)
    //     var
    //         lrc_SalesDiscount: Record "5110344";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Berechnung der Rabattwerte für Anzeige in Verkaufsvorgang Kopf
    //         // -------------------------------------------------------------------------------------

    //         // Werte zurücksetzen
    //         rbn_Vorhanden := FALSE;
    //         rdc_RgRabWare := 0;
    //         rdc_RgRabOhneWarenBezug := 0;
    //         rdc_RgRabRückstellung := 0;

    //         lrc_SalesDiscount.RESET();
    //         lrc_SalesDiscount.SETRANGE("Document Type", vop_DocTyp);
    //         lrc_SalesDiscount.SETRANGE("Document No.", vco_DocNo);
    //         IF lrc_SalesDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 rbn_Vorhanden := TRUE;
    //                 CASE lrc_SalesDiscount."Base Discount Value" OF
    //                     lrc_SalesDiscount."Base Discount Value"::Prozentsatz:
    //                         BEGIN
    //                             IF (lrc_SalesDiscount."Payment Timing" = lrc_SalesDiscount."Payment Timing"::Invoice) THEN BEGIN
    //                                 IF (lrc_SalesDiscount."Discount Type" = lrc_SalesDiscount."Discount Type"::Warenrechnungsrabatt) OR
    //                                    (lrc_SalesDiscount."Discount Type" = lrc_SalesDiscount."Discount Type"::Artikelrabatt) THEN BEGIN
    //                                     rdc_RgRabWare := rdc_RgRabWare + lrc_SalesDiscount."Discount Value";
    //                                 END ELSE BEGIN
    //                                     rdc_RgRabOhneWarenBezug := rdc_RgRabOhneWarenBezug + lrc_SalesDiscount."Discount Value";
    //                                 END;
    //                             END ELSE BEGIN
    //                                 rdc_RgRabRückstellung := rdc_RgRabRückstellung + lrc_SalesDiscount."Discount Value";
    //                             END;
    //                         END;
    //                 END;
    //             UNTIL lrc_SalesDiscount.NEXT() = 0;
    //         END;
    //     end;

    //     procedure SalesPrintInvDiscount(vin_DocumentType: Integer; vco_DocumentNo: Code[20]; var rtx_Rechnungsrabatte: array[4] of Text[100])
    //     var
    //         lrc_SalesDiscount: Record "5110344";
    //         lrc_Discount: Record "5110383";
    //         "lin_Zähler": Integer;
    //         lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // Funktion zum Ausgabe der Warenrechnungsrabatte
    //         // ---------------------------------------------------------------------------------------------------------

    //         lrc_SalesDiscount.RESET();
    //         lrc_SalesDiscount.SETRANGE("Document Type", vin_DocumentType);
    //         lrc_SalesDiscount.SETRANGE("Document No.", vco_DocumentNo);
    //         lrc_SalesDiscount.SETFILTER("Discount Type", '%1|%2',
    //                                     lrc_SalesDiscount."Discount Type"::Warenrechnungsrabatt,
    //                                     lrc_SalesDiscount."Discount Type"::Artikelrabatt);
    //         lrc_SalesDiscount.SETRANGE("Payment Timing", lrc_SalesDiscount."Payment Timing"::Invoice);
    //         IF lrc_SalesDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 IF lrc_Discount.GET(lrc_SalesDiscount."Discount Code") THEN BEGIN
    //                     lin_Zähler := lin_Zähler + 1;

    //                     // Rabatte übersetzen
    //                     IF gco_LanguageCode <> '' THEN
    //                         GetDiscountTranslation(gco_LanguageCode, lrc_Discount);

    //                     IF lin_Zähler <= ARRAYLEN(rtx_Rechnungsrabatte) THEN BEGIN
    //                         IF lrc_SalesDiscount."Base Discount Value" = lrc_SalesDiscount."Base Discount Value"::Prozentsatz THEN BEGIN
    //                             rtx_Rechnungsrabatte[lin_Zähler] := lrc_Discount.Description + ', ' +
    //                                                                 FORMAT(lrc_SalesDiscount."Base Discount Value") +
    //                                                                 ' ' + FORMAT(lrc_SalesDiscount."Discount Value");
    //                             rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler] + '%';
    //                         END ELSE BEGIN
    //                             rtx_Rechnungsrabatte[lin_Zähler] := lrc_Discount.Description + ', ' + FORMAT(lrc_SalesDiscount."Base Discount Value") +
    //                                                               ' ' + lcu_GlobalFunctions.StrNumberFormat(FORMAT(lrc_SalesDiscount."Discount Value"), 2,
    //                                                               FALSE);
    //                         END;
    //                         rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler];
    //                     END;
    //                 END;
    //             UNTIL lrc_SalesDiscount.NEXT() = 0;
    //         END;
    //     end;

    //     procedure SalesGetDiscAlloc(vco_GenBusPostingGroup: Code[10]; vco_GenProdPostingGroup: Code[10]): Code[20]
    //     var
    //         lrc_GeneralPostingSetup: Record "General Posting Setup";
    //         AGILES_LT_TEXT001: Label 'Kontierung für %1 und %2 nicht vorhanden!';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung des Sachkontos für nicht Warenbezogene Rechnungsrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_GeneralPostingSetup.RESET();
    //         lrc_GeneralPostingSetup.SETRANGE("Gen. Bus. Posting Group", vco_GenBusPostingGroup);
    //         lrc_GeneralPostingSetup.SETRANGE("Gen. Prod. Posting Group", vco_GenProdPostingGroup);
    //         IF NOT lrc_GeneralPostingSetup.FINDFIRST() THEN
    //             // Kontierung für %1 und %2 nicht vorhanden!
    //             ERROR(AGILES_LT_TEXT001, vco_GenBusPostingGroup, vco_GenProdPostingGroup);

    //         lrc_GeneralPostingSetup.TESTFIELD("Sales Inv.Disc. ohne WB Acc.");
    //         EXIT(lrc_GeneralPostingSetup."Sales Inv.Disc. ohne WB Acc.");
    //     end;

    //     procedure PostedSalesPrintInvDiscount(vin_DocumentType: Integer; vco_DocumentNo: Code[20]; var rtx_Rechnungsrabatte: array[4] of Text[100])
    //     var
    //         lrc_PostedSalesDiscount: Record "5110390";
    //         lrc_Discount: Record "5110383";
    //         "lin_Zähler": Integer;
    //         lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // Funktion zum Ausgabe der Warenrechnungsrabatte
    //         // ---------------------------------------------------------------------------------------------------------

    //         lrc_PostedSalesDiscount.RESET();
    //         lrc_PostedSalesDiscount.SETRANGE("Document Type", vin_DocumentType);
    //         lrc_PostedSalesDiscount.SETRANGE("Document No.", vco_DocumentNo);
    //         lrc_PostedSalesDiscount.SETFILTER("Discount Type", '%1|%2', lrc_PostedSalesDiscount."Discount Type"::Warenrechnungsrabatt,
    //                                                                    lrc_PostedSalesDiscount."Discount Type"::Artikelrabatt);
    //         lrc_PostedSalesDiscount.SETRANGE("Payment Timing", lrc_PostedSalesDiscount."Payment Timing"::Invoice);
    //         lrc_PostedSalesDiscount.SETFILTER("Disc. Amount", '<>%1', 0);
    //         IF lrc_PostedSalesDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 lrc_Discount.GET(lrc_PostedSalesDiscount."Discount Code");
    //                 lin_Zähler := lin_Zähler + 1;

    //                 IF lin_Zähler <= ARRAYLEN(rtx_Rechnungsrabatte) THEN BEGIN
    //                     IF lrc_PostedSalesDiscount."Base Discount Value" = lrc_PostedSalesDiscount."Base Discount Value"::Prozentsatz THEN BEGIN
    //                         rtx_Rechnungsrabatte[lin_Zähler] := lrc_Discount."Print Description";
    //                         IF rtx_Rechnungsrabatte[lin_Zähler] <> '' THEN
    //                             rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler] + ', ' +
    //                                                                 FORMAT(lrc_PostedSalesDiscount."Base Discount Value") +
    //                                                                ' ' + FORMAT(lrc_PostedSalesDiscount."Discount Value")
    //                         ELSE
    //                             rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler] +
    //                                                                 FORMAT(lrc_PostedSalesDiscount."Base Discount Value") +
    //                                                                 ' ' + FORMAT(lrc_PostedSalesDiscount."Discount Value");

    //                         rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler] + '%';

    //                     END ELSE BEGIN
    //                         rtx_Rechnungsrabatte[lin_Zähler] := lrc_Discount."Print Description";
    //                         IF rtx_Rechnungsrabatte[lin_Zähler] <> '' THEN
    //                             rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler] + ', ' +
    //                                                                 FORMAT(lrc_PostedSalesDiscount."Base Discount Value") +
    //                                                                 ' ' + lcu_GlobalFunctions.StrNumberFormat(
    //                                                                 FORMAT(lrc_PostedSalesDiscount."Discount Value"), 2, FALSE)
    //                         ELSE
    //                             rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler] +
    //                                                                 FORMAT(lrc_PostedSalesDiscount."Base Discount Value") +
    //                                                                 ' ' + lcu_GlobalFunctions.StrNumberFormat(
    //                                                                 FORMAT(lrc_PostedSalesDiscount."Discount Value"), 2, FALSE);
    //                     END;
    //                     rtx_Rechnungsrabatte[lin_Zähler] := rtx_Rechnungsrabatte[lin_Zähler];
    //                 END;
    //             UNTIL lrc_PostedSalesDiscount.NEXT() = 0;
    //         END;
    //     end;

    //     procedure SalesPostedArchiveDiscount(lop_InsertType: Option PostedDocument,Archiv; lrc_SalesHeader: Record "Sales Header"; lco_InvHeaderNo: Code[20]; lco_CreditMemoHeaderNo: Code[20]; lin_VersNo: Integer)
    //     var
    //         lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Receipt";
    //         lco_DocNo: Code[20];
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         gin_VersionNo := lin_VersNo;
    //         CASE lop_InsertType OF
    //             lop_InsertType::PostedDocument:
    //                 WITH lrc_SalesHeader DO BEGIN
    //                     IF NOT Invoice THEN
    //                         EXIT;

    //                     IF Invoice THEN BEGIN
    //                         IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice] THEN BEGIN
    //                             lop_DiscDocType := lop_DiscDocType::"Posted Invoice";
    //                             lco_DocNo := lco_InvHeaderNo;
    //                         END ELSE BEGIN // Credit Memo
    //                             lop_DiscDocType := lop_DiscDocType::"Posted Credit Memo";
    //                             lco_DocNo := lco_CreditMemoHeaderNo;
    //                         END;
    //                     END;
    //                 END;

    //             lop_InsertType::Archiv:
    //                 WITH lrc_SalesHeader DO BEGIN
    //                     CASE "Document Type" OF
    //                         "Document Type"::Quote:
    //                             lop_DiscDocType := lop_DiscDocType::"Archive Quote";
    //                         "Document Type"::"Blanket Order":
    //                             lop_DiscDocType := lop_DiscDocType::"Archive Blanket Order";
    //                         "Document Type"::Order:
    //                             lop_DiscDocType := lop_DiscDocType::"Archive Order";
    //                     END;
    //                     lco_DocNo := "No.";
    //                 END;
    //         END;

    //         SalesInsertPostArchDisc(lrc_SalesHeader, lop_DiscDocType, lco_DocNo);
    //     end;

    //     procedure SalesInsertPostArchDisc(lrc_SalesHeader: Record "Sales Header"; lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Receipt"; lco_PostedDocNo: Code[20])
    //     var
    //         lrc_SalesDisc: Record "5110344";
    //         lrc_SalesDiscLine: Record "5110380";
    //         lrc_PostedSalesDisc: Record "5110390";
    //         lrc_PostedSalesDiscLine: Record "5110391";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         // Suche Rabatte
    //         lrc_SalesDisc.RESET();
    //         lrc_SalesDisc.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //         lrc_SalesDisc.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //         IF lrc_SalesDisc.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 lrc_PostedSalesDisc.INIT();
    //                 lrc_PostedSalesDisc.TRANSFERFIELDS(lrc_SalesDisc);
    //                 lrc_PostedSalesDisc."Document Type" := lop_DiscDocType;
    //                 lrc_PostedSalesDisc."Document No." := lco_PostedDocNo;
    //                 lrc_PostedSalesDisc."Entry No." := lrc_SalesDisc."Entry No.";
    //                 lrc_PostedSalesDisc."Version No." := gin_VersionNo;

    //                 // Füge gebuchte Rabatt Belege ein
    //                 IF NOT lrc_PostedSalesDisc.INSERT THEN
    //                     lrc_PostedSalesDisc.MODIFY();

    //                 lrc_SalesDiscLine.SETRANGE("Document Type", lrc_SalesDisc."Document Type");
    //                 lrc_SalesDiscLine.SETRANGE("Document No.", lrc_SalesDisc."Document No.");
    //                 lrc_SalesDiscLine.SETRANGE("Sales Disc. Entry No.", lrc_SalesDisc."Entry No.");
    //                 IF lrc_SalesDiscLine.FINDSET(FALSE, FALSE) THEN BEGIN
    //                     REPEAT
    //                         lrc_PostedSalesDiscLine.INIT();
    //                         lrc_PostedSalesDiscLine.TRANSFERFIELDS(lrc_SalesDiscLine);
    //                         lrc_PostedSalesDiscLine."Document Type" := lop_DiscDocType;
    //                         lrc_PostedSalesDiscLine."Document No." := lco_PostedDocNo;
    //                         lrc_PostedSalesDiscLine."Sales Disc. Entry No." := lrc_SalesDiscLine."Sales Disc. Entry No.";
    //                         lrc_PostedSalesDiscLine."Document Line No." := lrc_SalesDiscLine."Document Line No.";
    //                         lrc_PostedSalesDiscLine."Version No." := gin_VersionNo;
    //                         IF NOT lrc_PostedSalesDiscLine.INSERT THEN
    //                             lrc_PostedSalesDiscLine.MODIFY();
    //                     UNTIL lrc_SalesDiscLine.NEXT() = 0;
    //                 END;
    //             UNTIL lrc_SalesDisc.NEXT() = 0;
    //         END;
    //     end;

    //     procedure SalesDocCopy(lin_FromDocType: Integer; lco_FromDocNo: Code[20]; lrc_ToSalesHeader: Record "Sales Header"; lin_VersionNo: Integer)
    //     var
    //         lrc_SalesPostArchDisc: Record "5110390";
    //         lrc_SalesDiscount: Record "5110344";
    //         lrc_NewSalesDiscount: Record "5110344";
    //         AGILES_LT_TEXT001: Label 'Discounts allready exists. If you continue, discounts will de deleted.\Do you wish to continue?';
    //         AGILES_LT_TEXT002: Label 'Process stopped.';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         gop_SalesDocType := lin_FromDocType;
    //         gin_VersionNo := lin_VersionNo;

    //         IF gop_SalesDocType IN [gop_SalesDocType::Quote, gop_SalesDocType::"Blanket Order", gop_SalesDocType::Order,
    //                                 gop_SalesDocType::Invoice, gop_SalesDocType::"Return Order", gop_SalesDocType::"Credit Memo"]
    //         THEN BEGIN
    //             WITH lrc_SalesDiscount DO BEGIN
    //                 CASE gop_SalesDocType OF

    //                     gop_SalesDocType::Quote:
    //                         SETRANGE("Document Type", "Document Type"::Quote);
    //                     gop_SalesDocType::"Blanket Order":
    //                         SETRANGE("Document Type", "Document Type"::"Blanket Order");
    //                     gop_SalesDocType::Order:
    //                         SETRANGE("Document Type", "Document Type"::Order);
    //                     gop_SalesDocType::Invoice:
    //                         SETRANGE("Document Type", "Document Type"::Invoice);
    //                     gop_SalesDocType::"Return Order":
    //                         SETRANGE("Document Type", "Document Type"::"Return Order");
    //                     gop_SalesDocType::"Credit Memo":
    //                         SETRANGE("Document Type", "Document Type"::"Credit Memo");
    //                 END;
    //                 lrc_SalesDiscount.SETRANGE("Document No.", lco_FromDocNo);
    //                 IF FIND('-') THEN BEGIN

    //                     // Lösche vorhandene Rabatte
    //                     lrc_NewSalesDiscount.SETRANGE("Document Type", lrc_ToSalesHeader."Document Type");
    //                     lrc_NewSalesDiscount.SETRANGE("Document No.", lrc_ToSalesHeader."No.");
    //                     IF lrc_NewSalesDiscount.FIND('-') THEN
    //                         IF CONFIRM(AGILES_LT_TEXT001, TRUE) THEN
    //                             lrc_NewSalesDiscount.DELETEALL(TRUE)
    //                         ELSE
    //                             ERROR(AGILES_LT_TEXT002);

    //                     lrc_NewSalesDiscount.SETRANGE("Document Type");
    //                     lrc_NewSalesDiscount.SETRANGE("Document No.");

    //                     REPEAT
    //                         lrc_NewSalesDiscount.INIT();
    //                         lrc_NewSalesDiscount.TRANSFERFIELDS(lrc_SalesDiscount);
    //                         lrc_NewSalesDiscount."Document Type" := lrc_ToSalesHeader."Document Type";
    //                         lrc_NewSalesDiscount."Document No." := lrc_ToSalesHeader."No.";
    //                         lrc_NewSalesDiscount."Entry No." := "Entry No.";
    //                         IF lrc_NewSalesDiscount.INSERT THEN;
    //                     UNTIL NEXT = 0;
    //                 END;
    //             END;

    //         END ELSE BEGIN

    //             WITH lrc_SalesPostArchDisc DO BEGIN
    //                 CASE gop_SalesDocType OF
    //                     gop_SalesDocType::"Posted Invoice":
    //                         SETRANGE("Document Type", "Document Type"::"Posted Invoice");
    //                     gop_SalesDocType::"Posted Credit Memo":
    //                         SETRANGE("Document Type", "Document Type"::"Posted Credit Memo");
    //                     gop_SalesDocType::"Arch. Quote":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Quote");
    //                     gop_SalesDocType::"Arch. Order":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Blanket Order");
    //                     gop_SalesDocType::"Arch. Blanket Order":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Quote");
    //                 END;
    //                 SETRANGE("Document No.", lco_FromDocNo);
    //                 SETRANGE("Version No.", gin_VersionNo);
    //                 IF FIND('-') THEN BEGIN
    //                     // Lösche vorhandene Rabatte
    //                     lrc_NewSalesDiscount.SETRANGE("Document Type", lrc_ToSalesHeader."Document Type");
    //                     lrc_NewSalesDiscount.SETRANGE("Document No.", lrc_ToSalesHeader."No.");
    //                     IF lrc_NewSalesDiscount.FIND('-') THEN
    //                         IF CONFIRM(AGILES_LT_TEXT001, TRUE) THEN
    //                             lrc_NewSalesDiscount.DELETEALL
    //                         ELSE
    //                             ERROR(AGILES_LT_TEXT002);

    //                     lrc_NewSalesDiscount.SETRANGE("Document Type");
    //                     lrc_NewSalesDiscount.SETRANGE("Document No.");
    //                     REPEAT
    //                         lrc_NewSalesDiscount.INIT();
    //                         lrc_NewSalesDiscount.TRANSFERFIELDS(lrc_SalesPostArchDisc);
    //                         lrc_NewSalesDiscount."Document Type" := lrc_ToSalesHeader."Document Type";
    //                         lrc_NewSalesDiscount."Document No." := lrc_ToSalesHeader."No.";
    //                         lrc_NewSalesDiscount."Entry No." := "Entry No.";
    //                         IF lrc_NewSalesDiscount.INSERT THEN;
    //                     UNTIL NEXT = 0;
    //                 END;
    //             END;

    //         END;
    //     end;

    //     procedure SalesDocCopyLines(lrc_FromSalesLine: Record "Sales Line"; lrc_ToSalesLine: Record "Sales Line")
    //     var
    //         lrc_SalesPostArchDiscLine: Record "5110391";
    //         lrc_SalesDiscountLine: Record "5110380";
    //         lrc_NewSalesDiscountLine: Record "5110380";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         IF gop_SalesDocType IN [gop_SalesDocType::Quote, gop_SalesDocType::"Blanket Order", gop_SalesDocType::Order,
    //                                 gop_SalesDocType::Invoice, gop_SalesDocType::"Return Order", gop_SalesDocType::"Credit Memo"]
    //         THEN BEGIN
    //             WITH lrc_SalesDiscountLine DO BEGIN
    //                 CASE gop_SalesDocType OF
    //                     gop_SalesDocType::Quote:
    //                         SETRANGE("Document Type", "Document Type"::Quote);
    //                     gop_SalesDocType::"Blanket Order":
    //                         SETRANGE("Document Type", "Document Type"::"Blanket Order");
    //                     gop_SalesDocType::Order:
    //                         SETRANGE("Document Type", "Document Type"::Order);
    //                     gop_SalesDocType::Invoice:
    //                         SETRANGE("Document Type", "Document Type"::Invoice);
    //                     gop_SalesDocType::"Return Order":
    //                         SETRANGE("Document Type", "Document Type"::"Return Order");
    //                     gop_SalesDocType::"Credit Memo":
    //                         SETRANGE("Document Type", "Document Type"::"Credit Memo");
    //                 END;
    //                 SETRANGE("Document No.", lrc_FromSalesLine."Document No.");
    //                 IF FINDSET(FALSE, FALSE) THEN
    //                     REPEAT
    //                         lrc_NewSalesDiscountLine.INIT();
    //                         lrc_NewSalesDiscountLine.TRANSFERFIELDS(lrc_SalesDiscountLine);
    //                         lrc_NewSalesDiscountLine."Document Type" := lrc_ToSalesLine."Document Type";
    //                         lrc_NewSalesDiscountLine."Document No." := lrc_ToSalesLine."Document No.";
    //                         lrc_NewSalesDiscountLine."Document Line No." := lrc_ToSalesLine."Line No.";
    //                         lrc_NewSalesDiscountLine."Sales Disc. Entry No." := "Sales Disc. Entry No.";
    //                         IF lrc_NewSalesDiscountLine.INSERT THEN;
    //                     UNTIL NEXT = 0;
    //             END;
    //         END ELSE BEGIN
    //             WITH lrc_SalesPostArchDiscLine DO BEGIN
    //                 CASE gop_SalesDocType OF
    //                     gop_SalesDocType::"Posted Invoice":
    //                         SETRANGE("Document Type", "Document Type"::"Posted Invoice");
    //                     gop_SalesDocType::"Posted Credit Memo":
    //                         SETRANGE("Document Type", "Document Type"::"Posted Credit Memo");
    //                     gop_SalesDocType::"Arch. Quote":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Quote");
    //                     gop_SalesDocType::"Arch. Order":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Order");
    //                     gop_SalesDocType::"Arch. Blanket Order":
    //                         SETRANGE("Document Type", "Document Type"::"Archive Blanket Order");
    //                 END;
    //                 SETRANGE("Document No.", lrc_FromSalesLine."Document No.");
    //                 SETRANGE("Version No.", gin_VersionNo);
    //                 IF FINDSET(FALSE, FALSE) THEN
    //                     REPEAT
    //                         lrc_NewSalesDiscountLine.INIT();
    //                         lrc_NewSalesDiscountLine.TRANSFERFIELDS(lrc_SalesPostArchDiscLine);
    //                         lrc_NewSalesDiscountLine."Document Type" := lrc_ToSalesLine."Document Type";
    //                         lrc_NewSalesDiscountLine."Document No." := lrc_ToSalesLine."Document No.";
    //                         lrc_NewSalesDiscountLine."Document Line No." := lrc_ToSalesLine."Line No.";
    //                         lrc_NewSalesDiscountLine."Sales Disc. Entry No." := "Sales Disc. Entry No.";
    //                         IF lrc_NewSalesDiscountLine.INSERT THEN;
    //                     UNTIL NEXT = 0;
    //             END;
    //         END;
    //     end;

    //     procedure SalesPostArchShowDiscount(vop_DocTyp: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment"; vco_DocNo: Code[20]; vin_VersNo: Integer)
    //     var
    //         lrc_SalesPostArchivDiscount: Record "5110390";
    //         lfm_PurchasePostArchivDiscount: Form "5110388";
    //         AGILES_LT_TEXT001: Label 'There exist no discount''s for this document %1 !';
    //         AGILES_LT_TEXT002: Label 'There exist no discount''s for this document %1, version %2 !';
    //     //lfm_SalesPostArchivDiscount: Form "5110390";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige der Rabattwerte geb. /Archivierte Verkaufsbelege
    //         // -------------------------------------------------------------------------------------

    //         lrc_SalesPostArchivDiscount.RESET();
    //         lrc_SalesPostArchivDiscount.SETRANGE("Document Type", vop_DocTyp);
    //         lrc_SalesPostArchivDiscount.SETRANGE("Document No.", vco_DocNo);
    //         lrc_SalesPostArchivDiscount.SETRANGE("Version No.", vin_VersNo);
    //         IF NOT lrc_SalesPostArchivDiscount.isempty()THEN BEGIN
    //             lfm_SalesPostArchivDiscount.SETTABLEVIEW(lrc_SalesPostArchivDiscount);
    //             lfm_SalesPostArchivDiscount.RUNMODAL;
    //         END ELSE BEGIN
    //             IF vin_VersNo = 0 THEN BEGIN
    //                 ERROR(AGILES_LT_TEXT001, vco_DocNo);
    //             END ELSE BEGIN
    //                 ERROR(AGILES_LT_TEXT002, vco_DocNo, vin_VersNo);
    //             END;
    //         END;
    //     end;

    //     procedure SalesPostArchShowDiscSum(vop_DocTyp: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment"; vco_DocNo: Code[20]; vin_VersNo: Integer; var rbn_Vorhanden: Boolean; var rdc_RgRabWare: Decimal; var rdc_RgRabOhneWarenBezug: Decimal; var "rdc_RgRabRückstellung": Decimal)
    //     var
    //         lrc_SalesPostArchivDiscount: Record "5110390";
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktionen zur Berechnung der Rabattwerte für Anzeige im geb. Verkauf Kopf / Archiv. Kopf
    //         // -----------------------------------------------------------------------------------------

    //         // Werte zurücksetzen
    //         rbn_Vorhanden := FALSE;
    //         rdc_RgRabWare := 0;
    //         rdc_RgRabOhneWarenBezug := 0;
    //         rdc_RgRabRückstellung := 0;

    //         lrc_SalesPostArchivDiscount.RESET();
    //         lrc_SalesPostArchivDiscount.SETRANGE("Document Type", vop_DocTyp);
    //         lrc_SalesPostArchivDiscount.SETRANGE("Document No.", vco_DocNo);
    //         lrc_SalesPostArchivDiscount.SETRANGE("Version No.", vin_VersNo);
    //         IF lrc_SalesPostArchivDiscount.FIND('-') THEN BEGIN
    //             REPEAT
    //                 rbn_Vorhanden := TRUE;
    //                 CASE lrc_SalesPostArchivDiscount."Base Discount Value" OF
    //                     lrc_SalesPostArchivDiscount."Base Discount Value"::Prozentsatz:
    //                         BEGIN
    //                             IF (lrc_SalesPostArchivDiscount."Payment Timing" =
    //                                 lrc_SalesPostArchivDiscount."Payment Timing"::Invoice) THEN BEGIN
    //                                 IF (lrc_SalesPostArchivDiscount."Discount Type" =
    //                                     lrc_SalesPostArchivDiscount."Discount Type"::Warenrechnungsrabatt) OR
    //                                    (lrc_SalesPostArchivDiscount."Discount Type" =
    //                                     lrc_SalesPostArchivDiscount."Discount Type"::Artikelrabatt) THEN BEGIN
    //                                     rdc_RgRabWare := rdc_RgRabWare + lrc_SalesPostArchivDiscount."Discount Value";
    //                                 END ELSE BEGIN
    //                                     rdc_RgRabOhneWarenBezug := rdc_RgRabOhneWarenBezug + lrc_SalesPostArchivDiscount."Discount Value";
    //                                 END;
    //                             END ELSE BEGIN
    //                                 rdc_RgRabRückstellung := rdc_RgRabRückstellung + lrc_SalesPostArchivDiscount."Discount Value";
    //                             END;
    //                         END;
    //                 END;
    //             UNTIL lrc_SalesPostArchivDiscount.NEXT() = 0;
    //         END;
    //     end;

    //     procedure SetLanguageCode(vco_LanguageCode: Code[20])
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------

    //         gco_LanguageCode := vco_LanguageCode;
    //     end;

    //     procedure GetDiscountTranslation(vco_ReportLanguageCode: Code[20]; var rrc_Discount: Record "5110383")
    //     var
    //         lrc_LanguageTranslation: Record "5110321";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der Übersetzung für die Rabattbeschreibung
    //         // -------------------------------------------------------------------------------------

    //         IF lrc_LanguageTranslation.GET(DATABASE::Discount, rrc_Discount.Code, '', vco_ReportLanguageCode) THEN
    //             rrc_Discount.Description := lrc_LanguageTranslation.Description;
    //     end;

    //     procedure CustomerGroupDisc(rco_CustomerGroupCode: Code[10])
    //     var
    //         lrc_Customer: Record Customer;
    //         lrc_CustomerDiscount: Record "5110386";
    //         lfm_CustomerDiscount: Form "5110386";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Debitorengruppenrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_CustomerDiscount.RESET();
    //         lrc_CustomerDiscount.FILTERGROUP(2);
    //         lrc_CustomerDiscount.SETRANGE(Source, lrc_CustomerDiscount.Source::"Customer Group");
    //         lrc_CustomerDiscount.SETRANGE("Source No.", rco_CustomerGroupCode);
    //         lrc_CustomerDiscount.FILTERGROUP(0);

    //         lfm_CustomerDiscount.SETTABLEVIEW(lrc_CustomerDiscount);
    //         lfm_CustomerDiscount.RUNMODAL;
    //     end;

    //     procedure CustomerMainGroupDisc(rco_CustomerMainGroupCode: Code[10])
    //     var
    //         lrc_Customer: Record Customer;
    //         lrc_CustomerDiscount: Record "5110386";
    //     //lfm_CustomerDiscount: Form "5110386";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Debitorenhauptgruppenrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_CustomerDiscount.RESET();
    //         lrc_CustomerDiscount.FILTERGROUP(2);
    //         lrc_CustomerDiscount.SETRANGE(Source, lrc_CustomerDiscount.Source::"Customer Main Group");
    //         lrc_CustomerDiscount.SETRANGE("Source No.", rco_CustomerMainGroupCode);
    //         lrc_CustomerDiscount.FILTERGROUP(0);

    //         lfm_CustomerDiscount.SETTABLEVIEW(lrc_CustomerDiscount);
    //         lfm_CustomerDiscount.RUNMODAL;
    //     end;

    //     procedure CustomerHierarchyDisc(rco_HierarchieCode: Code[13])
    //     var
    //         lrc_Customer: Record Customer;
    //         lrc_CustomerDiscount: Record "5110386";
    //     //lfm_CustomerDiscount: Form "5110386";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Debitorenhierarchierabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_CustomerDiscount.RESET();
    //         lrc_CustomerDiscount.FILTERGROUP(2);
    //         lrc_CustomerDiscount.SETRANGE(Source, lrc_CustomerDiscount.Source::"Customer Hierarchy");
    //         lrc_CustomerDiscount.SETRANGE("Source No.", rco_HierarchieCode);
    //         lrc_CustomerDiscount.FILTERGROUP(0);

    //         lfm_CustomerDiscount.SETTABLEVIEW(lrc_CustomerDiscount);
    //         lfm_CustomerDiscount.RUNMODAL;
    //     end;

    //     procedure VendorGroupDisc(rco_VendorGroupCode: Code[10])
    //     var
    //         lrc_Vendor: Record Vendor;
    //         lrc_VendorDiscount: Record "5110385";
    //     //lfm_VendorDiscount: Form "5110385";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Kreditorengruppenrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_VendorDiscount.RESET();
    //         lrc_VendorDiscount.FILTERGROUP(2);
    //         lrc_VendorDiscount.SETRANGE(Source, lrc_VendorDiscount.Source::"Vendor Group");
    //         lrc_VendorDiscount.SETRANGE("Source No.", rco_VendorGroupCode);
    //         lrc_VendorDiscount.FILTERGROUP(0);

    //         lfm_VendorDiscount.SETTABLEVIEW(lrc_VendorDiscount);
    //         lfm_VendorDiscount.RUNMODAL;
    //     end;

    //     procedure VendorMainGroupDisc(rco_VendorMainGroupCode: Code[10])
    //     var
    //         lrc_Vendor: Record Vendor;
    //         lrc_VendorDiscount: Record "5110385";
    //     //lfm_VendorDiscount: Form "5110385";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Kreditorenhauptgruppenrabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_VendorDiscount.RESET();
    //         lrc_VendorDiscount.FILTERGROUP(2);
    //         lrc_VendorDiscount.SETRANGE(Source, lrc_VendorDiscount.Source::"Vendor Main Group");
    //         lrc_VendorDiscount.SETRANGE("Source No.", rco_VendorMainGroupCode);
    //         lrc_VendorDiscount.FILTERGROUP(0);

    //         lfm_VendorDiscount.SETTABLEVIEW(lrc_VendorDiscount);
    //         lfm_VendorDiscount.RUNMODAL;
    //     end;

    //     procedure VendorHierarchyDisc(rco_HierarchieCode: Code[13])
    //     var
    //         lrc_Vendor: Record Vendor;
    //         lrc_VendorDiscount: Record "5110385";
    //     //lfm_VendorDiscount: Form "5110385";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zur Anzeige / Bearbeitung der Kreditorenhierarchierabatte
    //         // -------------------------------------------------------------------------------------

    //         lrc_VendorDiscount.RESET();
    //         lrc_VendorDiscount.FILTERGROUP(2);
    //         lrc_VendorDiscount.SETRANGE(Source, lrc_VendorDiscount.Source::"Vendor Hierarchy");
    //         lrc_VendorDiscount.SETRANGE("Source No.", rco_HierarchieCode);
    //         lrc_VendorDiscount.FILTERGROUP(0);

    //         lfm_VendorDiscount.SETTABLEVIEW(lrc_VendorDiscount);
    //         lfm_VendorDiscount.RUNMODAL;
    //     end;

    //     procedure SalesDiscLoadCustNo(vrc_SalesHeader: Record "Sales Header"; vco_CustomerNo: Code[10])
    //     var
    //         lrc_Customer: Record Customer;
    //         lrc_CustomerDiscount: Record "5110386";
    //         lrc_CompanyDiscount: Record "5110387";
    //         lrc_SalesDiscount: Record "5110344";
    //         lin_Loops: Integer;
    //         lrc_CustVendHierarchyChronolog: Record "5110547";
    //         lrc_Discount: Record "5110383";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktionen zum Laden der Rabatte
    //         // -------------------------------------------------------------------------------------

    //         // RAB 007 IFW40112.s
    //         // Die Funktion wurde aus der Funktion "SalesDiscLoad" verschoben und "Sell-To Customer" jeweils durch vco_CustomerNo ersetzt
    //         // Zu klären: Es gibt in diesem Quelltext zweimal die Zuweisung von "Sell-To Customer" - ändern oder nicht?

    //         // Verkaufskopfsatz lesen
    //         lrc_Customer.GET(vco_CustomerNo);

    //         // Bestehende Rabattsätze löschen
    //         lrc_SalesDiscount.RESET();
    //         lrc_SalesDiscount.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //         lrc_SalesDiscount.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //         IF NOT lrc_SalesDiscount.isempty()THEN
    //             lrc_SalesDiscount.DELETEALL();

    //         lin_Loops := 1;

    //         WHILE lin_Loops <= 3 DO BEGIN

    //             // Rabatte laden
    //             CASE lin_Loops OF

    //                 // Debitorenrabatte laden
    //                 1:
    //                     BEGIN
    //                         lrc_CustomerDiscount.RESET();
    //                         lrc_CustomerDiscount.SETRANGE(Source, lrc_CustomerDiscount.Source::Customer);
    //                         lrc_CustomerDiscount.SETRANGE("Source No.", vco_CustomerNo);
    //                         lrc_CustomerDiscount.SETFILTER("Valid from Date", '<=%1', vrc_SalesHeader."Document Date");
    //                         lrc_CustomerDiscount.SETFILTER("Valid to Date", '>=%1|%2', vrc_SalesHeader."Document Date", 0D);
    //                     END;

    //                 // Debitorgruppenrabatte laden
    //                 2:
    //                     BEGIN
    //                         lrc_CustomerDiscount.RESET();
    //                         lrc_CustomerDiscount.SETRANGE(Source, lrc_CustomerDiscount.Source::"Customer Group");
    //                         lrc_CustomerDiscount.SETRANGE("Source No.", lrc_Customer."Customer Group Code");
    //                         lrc_CustomerDiscount.SETFILTER("Valid from Date", '<=%1', vrc_SalesHeader."Document Date");
    //                         lrc_CustomerDiscount.SETFILTER("Valid to Date", '>=%1|%2', vrc_SalesHeader."Document Date", 0D);
    //                     END;

    //                 // Debitorhauptgruppenrabatte laden
    //                 3:
    //                     BEGIN
    //                         lrc_CustomerDiscount.RESET();
    //                         lrc_CustomerDiscount.SETRANGE(Source, lrc_CustomerDiscount.Source::"Customer Main Group");
    //                         lrc_CustomerDiscount.SETRANGE("Source No.", lrc_Customer."Customer Main Group Code");
    //                         lrc_CustomerDiscount.SETFILTER("Valid from Date", '<=%1', vrc_SalesHeader."Document Date");
    //                         lrc_CustomerDiscount.SETFILTER("Valid to Date", '>=%1|%2', vrc_SalesHeader."Document Date", 0D);
    //                     END;

    //             END;

    //             IF lrc_CustomerDiscount.FINDSET(FALSE, FALSE) THEN
    //                 REPEAT
    //                     lrc_SalesDiscount.RESET();
    //                     lrc_SalesDiscount.INIT();
    //                     lrc_SalesDiscount."Document Type" := vrc_SalesHeader."Document Type";
    //                     lrc_SalesDiscount."Document No." := vrc_SalesHeader."No.";
    //                     lrc_SalesDiscount."Entry No." := 0;
    //                     lrc_SalesDiscount."Discount Code" := lrc_CustomerDiscount."Discount Code";
    //                     lrc_SalesDiscount."Discount Type" := lrc_CustomerDiscount."Discount Type";
    //                     lrc_SalesDiscount."Base Discount Value" := lrc_CustomerDiscount."Base Discount Value";
    //                     lrc_SalesDiscount."Discount Value" := lrc_CustomerDiscount."Discount Value";
    //                     lrc_SalesDiscount."Basis %-Value incl. VAT" := lrc_CustomerDiscount."Basis %-Value incl. VAT";
    //                     lrc_SalesDiscount."Payment Timing" := lrc_CustomerDiscount."Payment Timing";
    //                     IF lrc_Discount.GET(lrc_CustomerDiscount."Discount Code") THEN
    //                         lrc_SalesDiscount."Discount Source" := lrc_Discount."Discount Source";
    //                     lrc_SalesDiscount."Ref. Disc. Depend on Weight" := lrc_CustomerDiscount."Ref. Disc. Depend on Weight";
    //                     lrc_SalesDiscount."Discount not on Customer Duty" := lrc_CustomerDiscount."Discount not on Customer Duty";
    //                     lrc_SalesDiscount."Currency Code" := vrc_SalesHeader."Currency Code";
    //                     lrc_SalesDiscount."Currency Factor" := vrc_SalesHeader."Currency Factor";
    //                     lrc_SalesDiscount."Sell-to Customer No." := vrc_SalesHeader."Sell-to Customer No.";
    //                     lrc_SalesDiscount."Restrict. Freight Unit" := lrc_CustomerDiscount."Restrict. Freight Unit";
    //                     lrc_SalesDiscount."Item No." := lrc_CustomerDiscount."Item No.";
    //                     lrc_SalesDiscount."Unit of Measure Code" := lrc_CustomerDiscount."Unit of Measure Code";
    //                     lrc_SalesDiscount."Product Group Code" := lrc_CustomerDiscount."Product Group Code";
    //                     lrc_SalesDiscount."Item Category Code" := lrc_CustomerDiscount."Item Category Code";
    //                     lrc_SalesDiscount."Trademark Code" := lrc_CustomerDiscount."Trademark Code";
    //                     lrc_SalesDiscount."Vendor No." := lrc_CustomerDiscount."Vendor No.";
    //                     lrc_SalesDiscount."Vendor Country Group" := lrc_CustomerDiscount."Vendor Country Group";
    //                     lrc_SalesDiscount."Service Invoice Customer No." := lrc_CustomerDiscount."Service Invoice Customer No.";

    //                     lrc_SalesDiscount."Shipment Method Code" := lrc_CustomerDiscount."Shipment Method Code";
    //                     lrc_SalesDiscount."Restrict. Freight Unit" := lrc_CustomerDiscount."Restrict. Freight Unit";
    //                     lrc_SalesDiscount."Restrict. Transport Unit" := lrc_CustomerDiscount."Restrict. Transport Unit";
    //                     lrc_SalesDiscount."Location Code" := lrc_CustomerDiscount."Location Code";
    //                     lrc_SalesDiscount."Person in Charge Code" := lrc_CustomerDiscount."Person in Charge Code";
    //                     lrc_SalesDiscount."Status Customs Duty" := lrc_CustomerDiscount."Status Customs Duty";
    //                     lrc_SalesDiscount."Posting to Sell-to Customer" := lrc_CustomerDiscount."Posting to Sell-to Customer";

    //                     lrc_SalesDiscount."Not Valid for" := lrc_CustomerDiscount."Not Valid for";
    //                     lrc_SalesDiscount."Not Valid for Filter" := lrc_CustomerDiscount."Not Valid for Filter";

    //                     // BAUSTELLE ???
    //                     //    IF lrc_CompanyDiscount.Level > 0 THEN
    //                     //      lrc_SalesDiscount.Level := lrc_CustomerDiscount.Level;
    //                     IF lrc_CustomerDiscount."Calculation Level" > 0 THEN
    //                         lrc_SalesDiscount."Calculation Level" := lrc_CustomerDiscount."Calculation Level";

    //                     lrc_SalesDiscount.INSERT(TRUE);

    //                 UNTIL lrc_CustomerDiscount.NEXT() = 0;

    //             lin_Loops := lin_Loops + 1;
    //         END;

    //         // Firmenrabatte laden
    //         lrc_CompanyDiscount.RESET();
    //         lrc_CompanyDiscount.SETRANGE(Type, lrc_CompanyDiscount.Type::Customer);
    //         lrc_CompanyDiscount.SETFILTER("Valid from Date", '<=%1', vrc_SalesHeader."Document Date");
    //         lrc_CompanyDiscount.SETFILTER("Valid to Date", '>=%1|%2', vrc_SalesHeader."Document Date", 0D);
    //         IF lrc_CompanyDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 lrc_SalesDiscount.RESET();
    //                 lrc_SalesDiscount.INIT();
    //                 lrc_SalesDiscount."Document Type" := vrc_SalesHeader."Document Type";
    //                 lrc_SalesDiscount."Document No." := vrc_SalesHeader."No.";
    //                 IF lrc_CompanyDiscount."Calculation Level" > 0 THEN
    //                     lrc_SalesDiscount."Calculation Level" := lrc_CompanyDiscount."Calculation Level";
    //                 lrc_SalesDiscount."Entry No." := 0;
    //                 lrc_SalesDiscount."Discount Code" := lrc_CompanyDiscount."Discount Code";
    //                 lrc_SalesDiscount."Discount Type" := lrc_CompanyDiscount."Discount Type";
    //                 lrc_SalesDiscount."Base Discount Value" := lrc_CompanyDiscount."Base Discount Value";
    //                 lrc_SalesDiscount."Discount Value" := lrc_CompanyDiscount."Discount Value";
    //                 lrc_SalesDiscount."Basis %-Value incl. VAT" := lrc_CompanyDiscount."Basis %-Value incl. VAT";
    //                 lrc_SalesDiscount."Payment Timing" := lrc_CompanyDiscount."Payment Timing";
    //                 lrc_SalesDiscount."Ref. Disc. Depend on Weight" := lrc_CompanyDiscount."Ref. Disc. Depend on Weight";
    //                 lrc_SalesDiscount."Discount not on Customer Duty" := lrc_CompanyDiscount."Discount not on Customer Duty";
    //                 lrc_SalesDiscount."Currency Code" := vrc_SalesHeader."Currency Code";
    //                 lrc_SalesDiscount."Currency Factor" := vrc_SalesHeader."Currency Factor";
    //                 lrc_SalesDiscount."Sell-to Customer No." := vrc_SalesHeader."Sell-to Customer No.";
    //                 lrc_SalesDiscount."Restrict. Freight Unit" := lrc_CompanyDiscount."Restrict. Freight Unit";
    //                 lrc_SalesDiscount."Item No." := lrc_CompanyDiscount."Item No.";
    //                 lrc_SalesDiscount."Unit of Measure Code" := lrc_CompanyDiscount."Unit of Measure Code";
    //                 lrc_SalesDiscount."Product Group Code" := lrc_CompanyDiscount."Product Group Code";
    //                 lrc_SalesDiscount."Item Category Code" := lrc_CompanyDiscount."Item Category Code";
    //                 lrc_SalesDiscount."Trademark Code" := lrc_CompanyDiscount."Trademark Code";
    //                 lrc_SalesDiscount."Vendor No." := lrc_CompanyDiscount."Vendor No.";
    //                 lrc_SalesDiscount."Vendor Country Group" := lrc_CompanyDiscount."Vendor Country Group";
    //                 lrc_SalesDiscount."Service Invoice Customer No." := lrc_CompanyDiscount."Service Invoice Customer No.";

    //                 lrc_SalesDiscount."Shipment Method Code" := lrc_CompanyDiscount."Shipment Method";
    //                 lrc_SalesDiscount."Restrict. Freight Unit" := lrc_CompanyDiscount."Restrict. Freight Unit";
    //                 lrc_SalesDiscount."Restrict. Transport Unit" := lrc_CompanyDiscount."Restrict. Transport Unit";
    //                 lrc_SalesDiscount."Location Code" := lrc_CompanyDiscount."Location Code";

    //                 lrc_SalesDiscount."Person in Charge Code" := lrc_CompanyDiscount."Person in Charge Code";
    //                 lrc_SalesDiscount."Status Customs Duty" := lrc_CompanyDiscount."Status Customs Duty";

    //                 lrc_SalesDiscount."Not Valid for" := lrc_CompanyDiscount."Not Valid for";
    //                 lrc_SalesDiscount."Not Valid for Filter" := lrc_CompanyDiscount."Not Valid for Filter";

    //                 lrc_SalesDiscount.INSERT(TRUE);
    //             UNTIL lrc_CompanyDiscount.NEXT() = 0;
    //         END;
    //     end;

    //     procedure AddDiscountToSalesPrice(vrc_SalesLine: Record "Sales Line")
    //     var
    //         lrc_SalesHeader: Record "Sales Header";
    //         lrc_SalesDisc: Record "5110344";
    //         lco_VendorNo: Code[20];
    //         lrc_BatchVariant: Record "5110366";
    //         lco_VendorCountryGroup: Code[20];
    //         lrc_Vendor: Record Vendor;
    //         lrc_CountryRegion: Record "Country/Region";
    //         lrc_Disc: Record "5110383";
    //         lbn_DiscNotValidFor: Boolean;
    //         lrc_SalesLine3: Record "Sales Line";
    //         "ldc_SalesPrice(Price Base)": Decimal;
    //         lrc_PriceBase: Record "POI Price Base";
    //         ldc_DiscountValue: Decimal;
    //         lin_AktuellerLevel: Integer;
    //         ldc_ArrSumDiscLevelSalesLine: array[9] of Decimal;
    //         ldc_AddDiscount: Decimal;
    //         ldc_AktDiscount: Decimal;
    //     begin

    //         // Verkaufskopfsatz lesen
    //         IF NOT lrc_SalesHeader.GET(vrc_SalesLine."Document Type", vrc_SalesLine."Document No.") THEN
    //             EXIT;

    //         IF (vrc_SalesLine."Allow Invoice Disc." = TRUE) AND
    //            (vrc_SalesLine.Quantity <> 0) THEN BEGIN

    //             // Kreditor lesen
    //             lco_VendorNo := '';
    //             lco_VendorCountryGroup := '';
    //             IF lrc_BatchVariant.GET(vrc_SalesLine."Batch Variant No.") THEN BEGIN
    //                 lco_VendorNo := lrc_BatchVariant."Vendor No.";
    //                 IF lrc_Vendor.GET(lco_VendorNo) THEN BEGIN
    //                     IF lrc_CountryRegion.GET(lrc_Vendor."Country/Region Code") THEN
    //                         lco_VendorCountryGroup := lrc_CountryRegion."Country Group Code";
    //                 END;
    //             END;

    //             // Rabatte Auftrag lesen
    //             lrc_SalesDisc.RESET();
    //             lrc_SalesDisc.SETCURRENTKEY("Calculation Level");
    //             lrc_SalesDisc.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //             lrc_SalesDisc.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //             lrc_SalesDisc.SETFILTER("Item No.", '%1|%2', vrc_SalesLine."No.", '');
    //             lrc_SalesDisc.SETFILTER("Product Group Code", '%1|%2', vrc_SalesLine."Product Group Code", '');
    //             lrc_SalesDisc.SETFILTER("Item Category Code", '%1|%2', vrc_SalesLine."Item Category Code", '');
    //             lrc_SalesDisc.SETFILTER("Vendor No.", '%1|%2', lco_VendorNo, '');
    //             lrc_SalesDisc.SETFILTER("Vendor Country Group", '%1|%2', lco_VendorCountryGroup, '');
    //             lrc_SalesDisc.SETFILTER("Location Code", '%1|%2', vrc_SalesLine."Location Code", '');
    //             lrc_SalesDisc.SETFILTER("Shipment Method Code", '%1|%2', lrc_SalesHeader."Shipment Method Code", '');
    //             lrc_SalesDisc.SETFILTER("Trademark Code", '%1|%2', vrc_SalesLine."Trademark Code", '');
    //             lrc_SalesDisc.SETFILTER("Service Invoice Customer No.", '%1|%2', lrc_SalesHeader."Service Invoice to Cust. No.", '');
    //             lrc_SalesDisc.SETFILTER("Person in Charge Code", '%1|%2', lrc_SalesHeader."Person in Charge Code", '');
    //             lrc_SalesDisc.SETFILTER("Status Customs Duty", '%1|%2', vrc_SalesLine."Status Customs Duty",
    //                                                                   lrc_SalesDisc."Status Customs Duty"::" ");
    //             IF lrc_SalesDisc.FIND('-') THEN BEGIN
    //                 ldc_AddDiscount := 0;
    //                 REPEAT
    //                     lin_AktuellerLevel := lrc_SalesDisc."Calculation Level";

    //                     IF lrc_Disc.GET(lrc_SalesDisc."Discount Code") THEN BEGIN
    //                         // Prüfung ob der Rabatt ein Ausschlusskriterium beinhaltet
    //                         lbn_DiscNotValidFor := FALSE;
    //                         IF (lrc_SalesDisc."Not Valid for" <> lrc_SalesDisc."Not Valid for"::" ") AND
    //                            (lrc_SalesDisc."Not Valid for Filter" <> '') THEN BEGIN
    //                             // Prüfung ob das Ausschlusskriterium für die aktuelle Verkaufszeile zutrifft
    //                             lrc_SalesLine3.RESET();
    //                             lrc_SalesLine3.SETRANGE("Document Type", vrc_SalesLine."Document Type");
    //                             lrc_SalesLine3.SETRANGE("Document No.", vrc_SalesLine."Document No.");
    //                             lrc_SalesLine3.SETRANGE("Line No.", vrc_SalesLine."Line No.");
    //                             CASE lrc_SalesDisc."Not Valid for" OF
    //                                 lrc_SalesDisc."Not Valid for"::"Item Category":
    //                                     lrc_SalesLine3.SETFILTER("Item Category Code", lrc_SalesDisc."Not Valid for Filter");
    //                                 lrc_SalesDisc."Not Valid for"::"Product Group":
    //                                     lrc_SalesLine3.SETFILTER("Product Group Code", lrc_SalesDisc."Not Valid for Filter");
    //                                 lrc_SalesDisc."Not Valid for"::"Item No.":
    //                                     lrc_SalesLine3.SETFILTER("No.", lrc_SalesDisc."Not Valid for Filter");
    //                                 lrc_SalesDisc."Not Valid for"::Trademark:
    //                                     lrc_SalesLine3.SETFILTER("Trademark Code", lrc_SalesDisc."Not Valid for Filter");
    //                             END;
    //                             IF lrc_SalesLine3.FINDFIRST() THEN
    //                                 lbn_DiscNotValidFor := TRUE;
    //                         END;

    //                         IF ((lrc_Disc."Sub Typ" = lrc_Disc."Sub Typ"::" ") OR
    //                             ((lrc_Disc."Sub Typ" = lrc_Disc."Sub Typ"::VVE) AND
    //                             (vrc_SalesLine."Empties Quantity" = 0))) AND
    //                             (lbn_DiscNotValidFor = FALSE) THEN BEGIN

    //                             IF lrc_SalesDisc."Calculation Level" > lin_AktuellerLevel THEN
    //                                 lin_AktuellerLevel := lrc_SalesDisc."Calculation Level";

    //                             CASE lrc_SalesDisc."Base Discount Value" OF
    //                                 // -----------------------------------------------------------------------------------------------------
    //                                 lrc_SalesDisc."Base Discount Value"::Prozentsatz:
    //                                     BEGIN
    //                                         IF lin_AktuellerLevel > 1 THEN BEGIN
    //                                             "ldc_SalesPrice(Price Base)" := ldc_ArrSumDiscLevelSalesLine[(lin_AktuellerLevel - 1)];
    //                                         END ELSE BEGIN
    //                                             "ldc_SalesPrice(Price Base)" := vrc_SalesLine."Sales Price (Price Base)";
    //                                         END;
    //                                         IF lrc_SalesDisc."Discount Value" <> 0 THEN BEGIN
    //                                             ldc_AktDiscount := ROUND(("ldc_SalesPrice(Price Base)" /
    //                                                                      (100 - lrc_SalesDisc."Discount Value") * 100) -
    //                                                                       "ldc_SalesPrice(Price Base)", 0.01);
    //                                         END;
    //                                     END;

    //                                 // -----------------------------------------------------------------------------------------------------
    //                                 lrc_SalesDisc."Base Discount Value"::"Betrag Pro Kolli":
    //                                     BEGIN
    //                                         IF lrc_SalesDisc."Discount Value" <> 0 THEN BEGIN
    //                                             IF vrc_SalesLine."Price Base (Sales Price)" <> '' THEN BEGIN

    //                                                 IF lin_AktuellerLevel > 1 THEN BEGIN
    //                                                     "ldc_SalesPrice(Price Base)" := ldc_ArrSumDiscLevelSalesLine[(lin_AktuellerLevel - 1)];
    //                                                 END ELSE BEGIN
    //                                                     "ldc_SalesPrice(Price Base)" := vrc_SalesLine."Sales Price (Price Base)";
    //                                                 END;

    //                                                 ldc_DiscountValue := lrc_SalesDisc."Discount Value";

    //                                                 lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Sales Price",
    //                                                                    vrc_SalesLine."Price Base (Sales Price)");

    //                                                 CASE lrc_PriceBase."Internal Calc. Type" OF
    //                                                     lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
    //                                                         BEGIN
    //                                                             ldc_AktDiscount := ldc_DiscountValue;
    //                                                         END;
    //                                                     lrc_PriceBase."Internal Calc. Type"::"Net Weight":
    //                                                         BEGIN
    //                                                             IF (vrc_SalesLine."Net Weight" <> 0) THEN BEGIN
    //                                                                 ldc_DiscountValue := ROUND(lrc_SalesDisc."Discount Value" / vrc_SalesLine."Net Weight", 0.00001);
    //                                                                 ldc_AktDiscount := ldc_DiscountValue;
    //                                                             END;
    //                                                         END;
    //                                                     lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
    //                                                         BEGIN
    //                                                             IF (vrc_SalesLine."Gross Weight" <> 0) THEN BEGIN
    //                                                                 ldc_DiscountValue := ROUND(lrc_SalesDisc."Discount Value" / vrc_SalesLine."Gross Weight", 0.00001);
    //                                                                 ldc_AktDiscount := ldc_DiscountValue;
    //                                                             END;
    //                                                         END;
    //                                                 END;
    //                                             END;
    //                                         END;
    //                                     END;

    //                             END;
    //                         END;

    //                         ldc_AddDiscount := ldc_AddDiscount + ldc_AktDiscount;
    //                         "ldc_SalesPrice(Price Base)" := "ldc_SalesPrice(Price Base)" + ldc_AktDiscount;
    //                         ldc_ArrSumDiscLevelSalesLine[lin_AktuellerLevel] := "ldc_SalesPrice(Price Base)";

    //                     END;
    //                 UNTIL lrc_SalesDisc.NEXT() = 0;
    //             END;

    //             // Werte in Verkaufszeile zurückschreiben
    //             IF (ldc_AddDiscount <> 0) AND
    //                (vrc_SalesLine."Sales Price (Price Base)" <> 0) THEN BEGIN
    //                 vrc_SalesLine.VALIDATE("Sales Price (Price Base)", vrc_SalesLine."Sales Price (Price Base)" + ldc_AddDiscount);
    //                 vrc_SalesLine.MODIFY();
    //             END;

    //         END;
    //     end;

    //     procedure AddDiscountToPurchasePrice(vrc_PurchaseLine: Record "Purchase Line")
    //     var
    //         lrc_PurchaseHeader: Record "Purchase Header";
    //         lrc_PurchaseDisc: Record "5110381";
    //         lrc_Disc: Record "5110383";
    //         "ldc_PurchasePrice(Price Base)": Decimal;
    //         lrc_PriceBase: Record "POI Price Base";
    //         ldc_DiscountValue: Decimal;
    //         lin_AktuellerLevel: Integer;
    //         ldc_ArrSumDiscLevelPurchLine: array[9] of Decimal;
    //         ldc_AddDiscount: Decimal;
    //         ldc_AktDiscount: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         //
    //         // ---------------------------------------------------------------------------------------------

    //         // DMG 008 DMG50128.s

    //         // Einkopfsatz lesen
    //         IF NOT lrc_PurchaseHeader.GET(vrc_PurchaseLine."Document Type", vrc_PurchaseLine."Document No.") THEN
    //             EXIT;

    //         IF (vrc_PurchaseLine."Allow Invoice Disc." = TRUE) AND
    //            (vrc_PurchaseLine.Quantity <> 0) THEN BEGIN

    //             // Rabatte Bestellung lesen
    //             lrc_PurchaseDisc.RESET();
    //             lrc_PurchaseDisc.SETCURRENTKEY("Calculation Level");
    //             lrc_PurchaseDisc.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
    //             lrc_PurchaseDisc.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
    //             lrc_PurchaseDisc.SETFILTER("Item No.", '%1|%2', vrc_PurchaseLine."No.", '');
    //             lrc_PurchaseDisc.SETFILTER("Product Group Code", '%1|%2', vrc_PurchaseLine."Product Group Code", '');
    //             lrc_PurchaseDisc.SETFILTER("Item Category Code", '%1|%2', vrc_PurchaseLine."Item Category Code", '');
    //             IF lrc_PurchaseDisc.FIND('-') THEN BEGIN
    //                 ldc_AddDiscount := 0;
    //                 REPEAT

    //                     lin_AktuellerLevel := lrc_PurchaseDisc."Calculation Level";

    //                     IF lrc_Disc.GET(lrc_PurchaseDisc."Discount Code") THEN BEGIN

    //                         IF (lrc_Disc."Sub Typ" = lrc_Disc."Sub Typ"::" ") OR
    //                            ((lrc_Disc."Sub Typ" = lrc_Disc."Sub Typ"::VVE) AND
    //                              (vrc_PurchaseLine."Empties Quantity" = 0)) THEN BEGIN

    //                             IF lrc_PurchaseDisc."Calculation Level" > lin_AktuellerLevel THEN
    //                                 lin_AktuellerLevel := lrc_PurchaseDisc."Calculation Level";

    //                             CASE lrc_PurchaseDisc."Base Discount Value" OF
    //                                 // -----------------------------------------------------------------------------------------------------
    //                                 lrc_PurchaseDisc."Base Discount Value"::Prozentsatz:
    //                                     BEGIN
    //                                         IF lin_AktuellerLevel > 1 THEN BEGIN
    //                                             "ldc_PurchasePrice(Price Base)" := ldc_ArrSumDiscLevelPurchLine[(lin_AktuellerLevel - 1)];
    //                                         END ELSE BEGIN
    //                                             "ldc_PurchasePrice(Price Base)" := vrc_PurchaseLine."Purch. Price (Price Base)";
    //                                         END;
    //                                         IF lrc_PurchaseDisc."Discount Value" <> 0 THEN BEGIN
    //                                             ldc_AktDiscount := ROUND(("ldc_PurchasePrice(Price Base)" /
    //                                                                (100 - lrc_PurchaseDisc."Discount Value") * 100) -
    //                                                                "ldc_PurchasePrice(Price Base)", 0.01);
    //                                         END;
    //                                     END;
    //                                 // -----------------------------------------------------------------------------------------------------
    //                                 lrc_PurchaseDisc."Base Discount Value"::"Betrag Pro Kolli":
    //                                     BEGIN
    //                                         IF lrc_PurchaseDisc."Discount Value" <> 0 THEN BEGIN

    //                                             IF vrc_PurchaseLine."Price Base (Purch. Price)" <> '' THEN BEGIN

    //                                                 IF lin_AktuellerLevel > 1 THEN BEGIN
    //                                                     "ldc_PurchasePrice(Price Base)" := ldc_ArrSumDiscLevelPurchLine[(lin_AktuellerLevel - 1)];
    //                                                 END ELSE BEGIN
    //                                                     "ldc_PurchasePrice(Price Base)" := vrc_PurchaseLine."Purch. Price (Price Base)";
    //                                                 END;

    //                                                 ldc_DiscountValue := lrc_PurchaseDisc."Discount Value";

    //                                                 lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price",
    //                                                                   vrc_PurchaseLine."Price Base (Purch. Price)");

    //                                                 CASE lrc_PriceBase."Internal Calc. Type" OF
    //                                                     lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
    //                                                         BEGIN
    //                                                             ldc_AktDiscount := ldc_DiscountValue;
    //                                                         END;
    //                                                     lrc_PriceBase."Internal Calc. Type"::"Net Weight":
    //                                                         BEGIN
    //                                                             IF (vrc_PurchaseLine."Net Weight" <> 0) THEN BEGIN
    //                                                                 ldc_DiscountValue := ROUND(lrc_PurchaseDisc."Discount Value" /
    //                                                                                      vrc_PurchaseLine."Net Weight", 0.00001);
    //                                                                 ldc_AktDiscount := ldc_DiscountValue;
    //                                                             END;
    //                                                         END;
    //                                                     lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
    //                                                         BEGIN
    //                                                             IF (vrc_PurchaseLine."Gross Weight" <> 0) THEN BEGIN
    //                                                                 ldc_DiscountValue := ROUND(lrc_PurchaseDisc."Discount Value" /
    //                                                                                      vrc_PurchaseLine."Gross Weight", 0.00001);
    //                                                                 ldc_AktDiscount := ldc_DiscountValue;
    //                                                             END;
    //                                                         END;
    //                                                 END;
    //                                             END;

    //                                         END;
    //                                     END;

    //                             END;
    //                         END;

    //                         ldc_AddDiscount := ldc_AddDiscount + ldc_AktDiscount;
    //                         "ldc_PurchasePrice(Price Base)" := "ldc_PurchasePrice(Price Base)" + ldc_AktDiscount;
    //                         ldc_ArrSumDiscLevelPurchLine[lin_AktuellerLevel] := "ldc_PurchasePrice(Price Base)";
    //                     END;
    //                 UNTIL lrc_PurchaseDisc.NEXT() = 0;
    //             END;

    //             // Werte in Einkaufszeile zurückschreiben
    //             IF (ldc_AddDiscount <> 0) AND
    //                (vrc_PurchaseLine."Purch. Price (Price Base)" <> 0) THEN BEGIN
    //                 vrc_PurchaseLine.VALIDATE("Purch. Price (Price Base)",
    //                                           vrc_PurchaseLine."Purch. Price (Price Base)" + ldc_AddDiscount);
    //                 vrc_PurchaseLine.MODIFY();
    //             END;
    //         END;
    //     end;
    var
        lrc_PurchLine: Record "Purchase Line";
        lrc_PurchLineLast: Record "Purchase Line";
        lrc_PurchDisc: Record "POI Purch. Discount";
        lrc_PurchDiscLine: Record "POI Purch. Discount Line";
        lrc_VendorDiscount: Record "POI Vendor Discount";
        lrc_CompanyDiscount: Record "POI Company Discount";
        lrc_PurchDiscountLine: Record "POI Purch. Discount Line";
        lrc_PurchLineDisc: Record "Purchase Line";
}

