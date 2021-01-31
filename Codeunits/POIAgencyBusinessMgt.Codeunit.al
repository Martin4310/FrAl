codeunit 5110352 "POI Agency Business Mgt"
{
    var
        lrc_PurchLine: Record "Purchase Line";
        lrc_SalesLine: Record "Sales Line";
        POI_GT_TEXT001Txt: Label 'Der Einheitencode der verbundenen Einkaufszeile ist abweichend!';
        POI_LT_TEXT011Txt: Label 'Die Verknüpfung in Einkaufszeile %1 Beleg %2 %3, Menge %4 %5 wurde gelöscht !', Comment = '%1 = %2 = %3 = %4 = %5 =';
        POI_GT_TEXT012Txt: Label 'Es wurden bereits Mengen in der Einkaufszeile geliefert!';
    //     procedure PlanShowCard(vco_PlanCode: Code[20])
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_AgencyPlanHeader: Record "5110558";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Planungskarte
    //         // ----------------------------------------------------------------------------------------

    //         IF vco_PlanCode = '' THEN
    //           EXIT;

    //         // Setup lesen
    //         lrc_FruitVisionSetup.GET();

    //         // Eingrenzen auf Übergabewert
    //         lrc_AgencyPlanHeader.Reset();
    //         lrc_AgencyPlanHeader.FILTERGROUP(2);
    //         lrc_AgencyPlanHeader.SETRANGE("No.",vco_PlanCode);
    //         lrc_AgencyPlanHeader.FILTERGROUP(0);

    //         // Planungskarte aufrufen
    //         FORM.RUNMODAL(lrc_FruitVisionSetup."Planing Card Form ID",lrc_AgencyPlanHeader);
    //     end;

    //     procedure PlanNewCard()
    //     var
    //         lrc_AgencyPlanHeader: Record "5110558";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Neuanlage einer Planungskarte
    //         // ----------------------------------------------------------------------------------------

    //         // Neue Karte anlegen
    //         lrc_AgencyPlanHeader.Reset();
    //         lrc_AgencyPlanHeader.INIT();
    //         lrc_AgencyPlanHeader.INSERT(TRUE);
    //         COMMIT;

    //         // Neuangelegte Karte anzeigen
    //         PlanShowCard(lrc_AgencyPlanHeader."No.");
    //     end;

    //     procedure PlanCopy(vco_ToPlanCode: Code[20])
    //     var
    //         lrc_FromAgencyPlanHeader: Record "5110558";
    //         lrc_ToAgencyPlanHeader: Record "5110558";
    //         lrc_FromAgencyPlanLines: Record "5110559";
    //         lrc_ToAgencyPlanLines: Record "5110559";
    //         lfm_AgencyPlanList: Form "5087922";
    //         POI_LT_TEXT001: Label 'Planung kann nicht auf sich selbst kopiert werden!';
    //         POI_LT_TEXT002: Label 'Es sind bereits Planungszeilen vorhanden! Möchten Sie diese löschen?';
    //         POI_LT_TEXT003: Label 'Die Kreditorennummer ist abweichend!';
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zum Kopieren einer Planungskarte
    //         // ----------------------------------------------------------------------------------------

    //         // Ziel Planungskopf lesen und Kontrolle auf benötgte Werte
    //         lrc_ToAgencyPlanHeader.GET(vco_ToPlanCode);
    //         lrc_ToAgencyPlanHeader.TESTFIELD("Planing Starting Date");
    //         lrc_ToAgencyPlanHeader.TESTFIELD("Shipping Date Vendor");
    //         lrc_ToAgencyPlanHeader.TESTFIELD("Expected Receipt Date Location");
    //         lrc_ToAgencyPlanHeader.TESTFIELD("Shipping Date");

    //         // Kontrolle ob bereits Zeilen in der Zielplanung vorhanden sind
    //         lrc_ToAgencyPlanLines.Reset();
    //         lrc_ToAgencyPlanLines.SETRANGE("Entry No.",lrc_ToAgencyPlanHeader."No.");
    //         IF lrc_ToAgencyPlanLines.FIND('-') THEN BEGIN
    //           // Es sind bereits Planungszeilen vorhanden! Möchten Sie diese löschen?
    //           IF CONFIRM(POI_LT_TEXT002) THEN BEGIN
    //             lrc_ToAgencyPlanLines.DELETEALL();
    //             COMMIT;
    //           END ELSE
    //             ERROR('Abbruch!');
    //         END;

    //         lrc_FromAgencyPlanHeader.SETFILTER("No.",'<>%1',lrc_ToAgencyPlanHeader."No.");
    //         lrc_FromAgencyPlanHeader.SETRANGE("Planing Type",lrc_ToAgencyPlanHeader."Planing Type");
    //         IF lrc_ToAgencyPlanHeader."Vendor No." <> '' THEN BEGIN
    //           lrc_FromAgencyPlanHeader.SETRANGE("Vendor No.",lrc_ToAgencyPlanHeader."Vendor No.");
    //         END;
    //         lfm_AgencyPlanList.SETTABLEVIEW(lrc_FromAgencyPlanHeader);
    //         lfm_AgencyPlanList.LOOKUPMODE := TRUE;
    //         IF lfm_AgencyPlanList.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_FromAgencyPlanHeader.Reset();
    //         lfm_AgencyPlanList.GETRECORD(lrc_FromAgencyPlanHeader);
    //         IF lrc_FromAgencyPlanHeader."No." = lrc_ToAgencyPlanHeader."No." THEN
    //           // Planung kann nicht auf sich selbst kopiert werden!
    //           ERROR(POI_LT_TEXT001);

    //         IF lrc_ToAgencyPlanHeader."Vendor No." = '' THEN BEGIN
    //           lrc_ToAgencyPlanHeader.VALIDATE( "Vendor No.", lrc_FromAgencyPlanHeader."Vendor No." );
    //           lrc_ToAgencyPlanHeader."Vend. Name" := lrc_FromAgencyPlanHeader."Vend. Name";
    //           lrc_ToAgencyPlanHeader."Producer No." := lrc_FromAgencyPlanHeader."Producer No.";
    //           lrc_ToAgencyPlanHeader."Prod. Name" := lrc_FromAgencyPlanHeader."Prod. Name";
    //           lrc_ToAgencyPlanHeader.Modify();
    //         END;


    //         IF lrc_FromAgencyPlanHeader."Vendor No." <> lrc_ToAgencyPlanHeader."Vendor No." THEN
    //           // Die Kreditorennummer ist abweichend!
    //           ERROR(POI_LT_TEXT003);


    //         lrc_FromAgencyPlanLines.Reset();
    //         lrc_FromAgencyPlanLines.SETRANGE("Entry No.",lrc_FromAgencyPlanHeader."No.");
    //         IF lrc_FromAgencyPlanLines.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_ToAgencyPlanLines.Reset();
    //             lrc_ToAgencyPlanLines.INIT();
    //             lrc_ToAgencyPlanLines := lrc_FromAgencyPlanLines;
    //             lrc_ToAgencyPlanLines."Entry No." := lrc_ToAgencyPlanHeader."No.";

    //             IF lrc_ToAgencyPlanHeader."Planing Type" <> lrc_ToAgencyPlanHeader."Planing Type"::"Global Assortment" THEN BEGIN
    //               lrc_ToAgencyPlanLines.VALIDATE( "Vendor No.", lrc_ToAgencyPlanHeader."Vendor No." );
    //               lrc_ToAgencyPlanLines."Vend. Name" := lrc_ToAgencyPlanHeader."Vend. Name";
    //               lrc_ToAgencyPlanLines."Producer No." := lrc_FromAgencyPlanLines."Producer No.";
    //               lrc_ToAgencyPlanLines."Prod. Name" := lrc_FromAgencyPlanLines."Prod. Name";
    //             END;

    //             lrc_ToAgencyPlanLines."Planing Starting Date" := lrc_ToAgencyPlanHeader."Planing Starting Date";
    //             lrc_ToAgencyPlanLines."Shipping Date Vendor" := lrc_ToAgencyPlanHeader."Shipping Date Vendor";
    //             lrc_ToAgencyPlanLines."Expected Receipt Date Location" := lrc_ToAgencyPlanHeader."Expected Receipt Date Location";
    //             lrc_ToAgencyPlanLines."Shipping Date" := lrc_ToAgencyPlanHeader."Shipping Date";
    //             lrc_ToAgencyPlanLines."Assortment Version No." := '';
    //             lrc_ToAgencyPlanLines."Assortment Version Line No." := 0;
    //             lrc_ToAgencyPlanLines.INSERT(TRUE);

    //           UNTIL lrc_FromAgencyPlanLines.NEXT() = 0;
    //         END;
    //     end;


    procedure DeleteSalesLine(vrc_SalesLine: Record "Sales Line")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
    // POI_LT_TEXT002Txt: Label 'Es sind bereits Mengen geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Löschung einer Verkaufszeile
        //
        // ACHTUNG: Aufruf der Funktion aus der Form, da das löschen nach Beendigung des Vorganges
        //          noch möglich sein muss
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_SalesLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_SalesLine."Purchase Order No." <> '') AND (vrc_SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
            lrc_PurchLine.Reset();
            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
            lrc_PurchLine.SETRANGE("Document No.", vrc_SalesLine."Purchase Order No.");
            lrc_PurchLine.SETRANGE("Line No.", vrc_SalesLine."Purch. Order Line No.");
            IF lrc_PurchLine.FIND('-') THEN
                IF lrc_PurchLine."Quantity Received" <> 0 THEN BEGIN
                    // Es sind bereits Mengen geliefert!
                    // ERROR(POI_LT_TEXT002Txt);
                    // Alternativ könnte auch einfach nur die Verknüpfung gelöst werden
                    lrc_PurchLine.SuspendStatusCheck(TRUE);
                    lrc_PurchLine.ADF_ChangeCalledFromSalesLine(TRUE);
                    lrc_PurchLine."Sales Order No." := '';
                    lrc_PurchLine."Sales Order Line No." := 0;
                    lrc_PurchLine.Modify();
                END ELSE BEGIN
                    // Menge in Einkaufszeile auf Null setzen damit sieht der Anwender dass eine Zeile gelöscht wurde !?!
                    lrc_PurchLine.SuspendStatusCheck(TRUE);
                    lrc_PurchLine.ADF_ChangeCalledFromSalesLine(TRUE);
                    lrc_PurchLine."Sales Order No." := '';
                    lrc_PurchLine."Sales Order Line No." := 0;
                    lrc_FruitVisionSetup.GET();
                    IF lrc_FruitVisionSetup."Internal Customer Code" = 'BIOTROPIC' THEN
                        MESSAGE(POI_LT_TEXT011Txt, lrc_PurchLine."Line No.", lrc_PurchLine."Document Type",
                                lrc_PurchLine."Document No.", lrc_PurchLine.Quantity, lrc_PurchLine."Unit of Measure Code")
                    ELSE
                        lrc_PurchLine.VALIDATE(Quantity, 0);
                    lrc_PurchLine.Modify();
                END;
        END;
    end;

    procedure ChangeSalesLineQty(vrc_SalesLine: Record "Sales Line")
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung der Menge in der Verkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_SalesLine."Drop Shipment" = TRUE THEN
            EXIT;
        IF (vrc_SalesLine."Purchase Order No." <> '') AND (vrc_SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
            lrc_PurchLine.Reset();
            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
            lrc_PurchLine.SETRANGE("Document No.", vrc_SalesLine."Purchase Order No.");
            lrc_PurchLine.SETRANGE("Line No.", vrc_SalesLine."Purch. Order Line No.");
            IF lrc_PurchLine.FIND('-') THEN BEGIN
                IF vrc_SalesLine."Unit of Measure Code" <> lrc_PurchLine."Unit of Measure Code" THEN
                    // Der Einheitencode der verbundenen Einkaufszeile ist abweichend!
                    ERROR(POI_GT_TEXT001Txt);
                lrc_PurchLine.SuspendStatusCheck(TRUE);
                lrc_PurchLine.ADF_ChangeCalledFromSalesLine(TRUE);
                lrc_PurchLine.VALIDATE(Quantity, vrc_SalesLine.Quantity);
                lrc_PurchLine.MODIFY(TRUE);
            END;
        END;
    end;

    procedure ChangeSalesLineUnit(vrc_SalesLine: Record "Sales Line")
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung der Verkaufseinheit in der Verkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_SalesLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_SalesLine."Purchase Order No." <> '') AND (vrc_SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
            lrc_PurchLine.Reset();
            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
            lrc_PurchLine.SETRANGE("Document No.", vrc_SalesLine."Purchase Order No.");
            lrc_PurchLine.SETRANGE("Line No.", vrc_SalesLine."Purch. Order Line No.");
            IF lrc_PurchLine.FIND('-') THEN
                IF vrc_SalesLine."Unit of Measure Code" <> lrc_PurchLine."Unit of Measure Code" THEN BEGIN
                    IF lrc_PurchLine."Quantity Received" <> 0 THEN
                        // Es wurden bereits Mengen in der Einkaufszeile geliefert!
                        ERROR(POI_GT_TEXT012Txt);
                    lrc_PurchLine.SuspendStatusCheck(TRUE);
                    lrc_PurchLine.ADF_ChangeCalledFromSalesLine(TRUE);
                    lrc_PurchLine.VALIDATE(Quantity, 0);
                    lrc_PurchLine.VALIDATE("Unit of Measure Code", vrc_SalesLine."Unit of Measure Code");
                    lrc_PurchLine.VALIDATE(Quantity, vrc_SalesLine.Quantity);
                    lrc_PurchLine.MODIFY(TRUE);
                END;
        END;
    end;

    procedure ChangeSalesLocationCode(vrc_SalesLine: Record "Sales Line")
    var
        POI_GT_TEXT013Txt: Label 'Es wurden bereits Mengen in der Einkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung der Lagerortes in der Verkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_SalesLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_SalesLine."Purchase Order No." <> '') AND (vrc_SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
            lrc_PurchLine.Reset();
            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
            lrc_PurchLine.SETRANGE("Document No.", vrc_SalesLine."Purchase Order No.");
            lrc_PurchLine.SETRANGE("Line No.", vrc_SalesLine."Purch. Order Line No.");
            IF lrc_PurchLine.FIND('-') THEN
                IF vrc_SalesLine."Location Code" <> lrc_PurchLine."Location Code" THEN BEGIN
                    IF lrc_PurchLine."Quantity Received" <> 0 THEN
                        // Es wurden bereits Mengen in der Einkaufszeile geliefert!
                        ERROR(POI_GT_TEXT013Txt);
                    lrc_PurchLine.SuspendStatusCheck(TRUE);
                    lrc_PurchLine.ADF_ChangeCalledFromSalesLine(TRUE);
                    lrc_PurchLine.VALIDATE("Location Code", vrc_SalesLine."Location Code");
                    lrc_PurchLine.MODIFY(TRUE);
                END;
        END;
    end;

    procedure ChangeSalesWeight(vrc_SalesLine: Record "Sales Line")
    var
        POI_LT_TEXT014Txt: Label 'Es wurden bereits Mengen in der Einkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung Wiegen in der Verkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_SalesLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_SalesLine."Purchase Order No." <> '') AND
           (vrc_SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
            lrc_PurchLine.RESET();
            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
            lrc_PurchLine.SETRANGE("Document No.", vrc_SalesLine."Purchase Order No.");
            lrc_PurchLine.SETRANGE("Line No.", vrc_SalesLine."Purch. Order Line No.");
            IF lrc_PurchLine.FIND('-') THEN BEGIN
                IF vrc_SalesLine."POI Weight" <> lrc_PurchLine."POI Weight" THEN
                    IF lrc_PurchLine."Quantity Received" <> 0 THEN
                        // Es wurden bereits Mengen in der Einkaufszeile geliefert!
                        ERROR(POI_LT_TEXT014Txt);
                lrc_PurchLine.SuspendStatusCheck(TRUE);
                lrc_PurchLine.ADF_ChangeCalledFromSalesLine(TRUE);
                lrc_PurchLine.VALIDATE("POI Weight", vrc_SalesLine."POI Weight");
                lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)");
                lrc_PurchLine.MODIFY(TRUE);
            END;
        END;
    end;

    procedure ChangeSalesNetWeight(vrc_SalesLine: Record "Sales Line")
    var
        POI_LT_TEXT001Txt: Label 'Es wurden bereits Mengen in der Einkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung des Nettogewichtes in der Verkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_SalesLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_SalesLine."Purchase Order No." <> '') AND
           (vrc_SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
            lrc_PurchLine.Reset();
            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
            lrc_PurchLine.SETRANGE("Document No.", vrc_SalesLine."Purchase Order No.");
            lrc_PurchLine.SETRANGE("Line No.", vrc_SalesLine."Purch. Order Line No.");
            IF lrc_PurchLine.FIND('-') THEN
                IF vrc_SalesLine."Net Weight" <> lrc_PurchLine."Net Weight" THEN BEGIN
                    IF lrc_PurchLine."Quantity Received" <> 0 THEN
                        // Es wurden bereits Mengen in der Einkaufszeile geliefert!
                        ERROR(POI_LT_TEXT001Txt);
                    lrc_PurchLine.SuspendStatusCheck(TRUE);
                    lrc_PurchLine.ADF_ChangeCalledFromSalesLine(TRUE);
                    lrc_PurchLine.VALIDATE("Net Weight", vrc_SalesLine."Net Weight");
                    lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)");
                    lrc_PurchLine.MODIFY(TRUE);
                END;
        END;
    end;

    procedure ChangeSalesGrossWeight(vrc_SalesLine: Record "Sales Line")
    var
        POI_LT_TEXT001Txt: Label 'Es wurden bereits Mengen in der Einkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung des Bruttogewichtes in der Verkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_SalesLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_SalesLine."Purchase Order No." <> '') AND
           (vrc_SalesLine."Purch. Order Line No." <> 0) THEN BEGIN
            lrc_PurchLine.Reset();
            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
            lrc_PurchLine.SETRANGE("Document No.", vrc_SalesLine."Purchase Order No.");
            lrc_PurchLine.SETRANGE("Line No.", vrc_SalesLine."Purch. Order Line No.");
            IF lrc_PurchLine.FIND('-') THEN
                IF vrc_SalesLine."Gross Weight" <> lrc_PurchLine."Gross Weight" THEN BEGIN
                    IF lrc_PurchLine."Quantity Received" <> 0 THEN
                        // Es wurden bereits Mengen in der Einkaufszeile geliefert!
                        ERROR(POI_LT_TEXT001Txt);
                    lrc_PurchLine.SuspendStatusCheck(TRUE);
                    lrc_PurchLine.ADF_ChangeCalledFromSalesLine(TRUE);
                    lrc_PurchLine.VALIDATE("Gross Weight", vrc_SalesLine."Gross Weight");
                    lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)");
                    lrc_PurchLine.MODIFY(TRUE);
                END;
        END;
    end;


    procedure DeletePurchLine(vrc_PurchLine: Record "Purchase Line")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        POI_LT_TEXT001Txt: Label 'Die Verknüpfung in Verkaufszeile %1 Beleg %2 %3, Menge %4 %5 wurde gelöscht !', Comment = '%1 = %2 = %3 = %4 = %5 =';
        ldc_Quantity: Decimal;
        POI_LT_TEXT002Txt: Label 'Mit der Verkaufszeile wurden bereits Mengen geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Löschung einer Einkaufszeile
        //
        // ACHTUNG: Aufruf der Funktion aus der Form, da das löschen nach Beendigung des Vorganges
        //          noch möglich sein muss
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_PurchLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_PurchLine."Sales Order No." <> '') AND (vrc_PurchLine."Sales Order Line No." <> 0) THEN BEGIN
            lrc_SalesLine.Reset();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE("Document No.", vrc_PurchLine."Sales Order No.");
            lrc_SalesLine.SETRANGE("Line No.", vrc_PurchLine."Sales Order Line No.");
            IF lrc_SalesLine.FIND('-') THEN BEGIN
                IF lrc_SalesLine."Quantity Shipped" <> 0 THEN
                    // Mit der Verkaufszeile wurden bereits Mengen geliefert!
                    ERROR(POI_LT_TEXT002Txt);
                lrc_SalesLine.SuspendStatusCheck(TRUE);
                lrc_SalesLine.ADF_ChangeCalledFromPurchLine(TRUE);
                lrc_SalesLine."Purchase Order No." := '';
                lrc_SalesLine."Purch. Order Line No." := 0;
                lrc_FruitVisionSetup.GET();
                IF lrc_FruitVisionSetup."Internal Customer Code" = 'BIOTROPIC' THEN BEGIN
                    MESSAGE(POI_LT_TEXT001Txt, lrc_SalesLine."Line No.", lrc_SalesLine."Document Type", lrc_SalesLine."Document No.",
                            lrc_SalesLine.Quantity, lrc_SalesLine."Unit of Measure Code");
                    lrc_SalesLine."POI Order Address Code" := '';
                    lrc_SalesLine."POI Buy-from Vendor No." := '';
                    ldc_Quantity := lrc_SalesLine.Quantity;
                END ELSE BEGIN
                    ldc_Quantity := 0;
                    lrc_SalesLine.VALIDATE(Quantity, 0);
                END;
                lrc_SalesLine.VALIDATE("POI Batch Variant No.", '');
                lrc_SalesLine."POI Master Batch No." := '';
                lrc_SalesLine."POI Batch No." := '';
                IF ldc_Quantity <> 0 THEN
                    lrc_SalesLine.VALIDATE(Quantity, ldc_Quantity);
                lrc_SalesLine.Modify();
            END;
        END;
    end;

    procedure ChangePurchaseLineQty(vrc_PurchaseLine: Record "Purchase Line")
    var
        POI_LT_TEXT001Txt: Label 'Der Einheitencode der verbundenen Verkaufszeile ist abweichend!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung der Menge in der Einkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_PurchaseLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_PurchaseLine."Sales Order No." <> '') AND
           (vrc_PurchaseLine."Sales Order Line No." <> 0) THEN BEGIN

            lrc_SalesLine.Reset();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE("Document No.", vrc_PurchaseLine."Sales Order No.");
            lrc_SalesLine.SETRANGE("Line No.", vrc_PurchaseLine."Sales Order Line No.");
            IF lrc_SalesLine.FIND('-') THEN BEGIN

                IF vrc_PurchaseLine."Unit of Measure Code" <> lrc_SalesLine."Unit of Measure Code" THEN
                    // Der Einheitencode der verbundenen Verkaufszeile ist abweichend!
                    ERROR(POI_LT_TEXT001Txt);

                lrc_SalesLine.SuspendStatusCheck(TRUE);
                lrc_SalesLine.ADF_ChangeCalledFromPurchLine(TRUE);
                lrc_SalesLine.VALIDATE(Quantity, vrc_PurchaseLine.Quantity);
                lrc_SalesLine.MODIFY(TRUE);

                IF vrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)" <> 0 THEN BEGIN
                    lrc_SalesLine."POI Transp. Unit of Meas (TU)" := vrc_PurchaseLine."POI Transport Unit of Meas(TU)";
                    lrc_SalesLine."POI Qty.(Unit) per Transp.(TU)" := vrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)";
                    lrc_SalesLine."POI Quantity (TU)" := ROUND(lrc_SalesLine.Quantity / lrc_SalesLine."POI Qty.(Unit) per Transp.(TU)", 0.01)
                END ELSE
                    lrc_SalesLine."POI Quantity (TU)" := 0;
                lrc_SalesLine.MODIFY(TRUE);
            END;

        END;
    end;

    procedure ChangePurchaseLineUnit(vrc_PurchaseLine: Record "Purchase Line")
    var
        POI_LT_TEXT001Txt: Label 'Es wurden bereits Mengen in der Verkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung der Verkaufseinheit in der Einkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_PurchaseLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_PurchaseLine."Sales Order No." <> '') AND (vrc_PurchaseLine."Sales Order Line No." <> 0) THEN BEGIN
            lrc_SalesLine.Reset();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE("Document No.", vrc_PurchaseLine."Sales Order No.");
            lrc_SalesLine.SETRANGE("Line No.", vrc_PurchaseLine."Sales Order Line No.");
            IF lrc_SalesLine.FIND('-') THEN
                IF vrc_PurchaseLine."Unit of Measure Code" <> lrc_SalesLine."Unit of Measure Code" THEN BEGIN
                    IF lrc_SalesLine."Quantity Shipped" <> 0 THEN
                        // Es wurden bereits Mengen in der Verkaufszeile geliefert!
                        ERROR(POI_LT_TEXT001Txt);
                    lrc_SalesLine.SuspendStatusCheck(TRUE);
                    lrc_SalesLine.ADF_ChangeCalledFromPurchLine(TRUE);
                    lrc_SalesLine.VALIDATE(Quantity, 0);
                    lrc_SalesLine.VALIDATE("Unit of Measure Code", vrc_PurchaseLine."Unit of Measure Code");
                    lrc_SalesLine.VALIDATE(Quantity, vrc_PurchaseLine.Quantity);
                    lrc_SalesLine.MODIFY(TRUE);
                END;
        END;
    end;

    procedure ChangePurchaseLocationCode(vrc_PurchaseLine: Record "Purchase Line")
    var
        POI_LT_TEXT001Txt: Label 'Es wurden bereits Mengen in der Verkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung der Lagerortes in der Einkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_PurchaseLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_PurchaseLine."Sales Order No." <> '') AND (vrc_PurchaseLine."Sales Order Line No." <> 0) THEN BEGIN
            lrc_SalesLine.Reset();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE("Document No.", vrc_PurchaseLine."Sales Order No.");
            lrc_SalesLine.SETRANGE("Line No.", vrc_PurchaseLine."Sales Order Line No.");
            IF lrc_SalesLine.FIND('-') THEN
                IF vrc_PurchaseLine."Location Code" <> lrc_SalesLine."Location Code" THEN BEGIN
                    IF lrc_SalesLine."Quantity Shipped" <> 0 THEN
                        // Es wurden bereits Mengen in der Verkaufszeile geliefert!
                        ERROR(POI_LT_TEXT001Txt);
                    lrc_SalesLine.SuspendStatusCheck(TRUE);
                    lrc_SalesLine.ADF_ChangeCalledFromPurchLine(TRUE);
                    lrc_SalesLine.VALIDATE("Location Code", vrc_PurchaseLine."Location Code");
                    lrc_SalesLine.MODIFY(TRUE);
                END;
        END;
    end;

    procedure ChangePurchaseLineWeight(vrc_PurchaseLine: Record "Purchase Line")
    var
        POI_LT_TEXT001Txt: Label 'Es wurden bereits Mengen in der Verkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung Wiegen in der Einkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_PurchaseLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_PurchaseLine."Sales Order No." <> '') AND
           (vrc_PurchaseLine."Sales Order Line No." <> 0) THEN BEGIN
            lrc_SalesLine.RESET();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE("Document No.", vrc_PurchaseLine."Sales Order No.");
            lrc_SalesLine.SETRANGE("Line No.", vrc_PurchaseLine."Sales Order Line No.");
            IF lrc_SalesLine.FIND('-') THEN
                IF vrc_PurchaseLine."POI Weight" <> lrc_SalesLine."POI Weight" THEN BEGIN
                    IF lrc_SalesLine."Quantity Shipped" <> 0 THEN
                        // Es wurden bereits Mengen in der Verkaufszeile geliefert!
                        ERROR(POI_LT_TEXT001Txt);
                    lrc_SalesLine.SuspendStatusCheck(TRUE);
                    lrc_SalesLine.ADF_ChangeCalledFromPurchLine(TRUE);
                    lrc_SalesLine.VALIDATE("POI Weight", vrc_PurchaseLine."POI Weight");
                    lrc_SalesLine.VALIDATE("Sales Price (Price Base)");
                    lrc_SalesLine.MODIFY(TRUE);
                END;
        END;
    end;

    procedure ChangePurchaseLineNetWeight(vrc_PurchaseLine: Record "Purchase Line")
    var
        POI_LT_TEXT001Txt: Label 'Es wurden bereits Mengen in der Verkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung des Nettogewichtes in der Einkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_PurchaseLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_PurchaseLine."Sales Order No." <> '') AND
           (vrc_PurchaseLine."Sales Order Line No." <> 0) THEN BEGIN
            lrc_SalesLine.Reset();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE("Document No.", vrc_PurchaseLine."Sales Order No.");
            lrc_SalesLine.SETRANGE("Line No.", vrc_PurchaseLine."Sales Order Line No.");
            IF lrc_SalesLine.FIND('-') THEN
                IF vrc_PurchaseLine."Net Weight" <> lrc_SalesLine."Net Weight" THEN BEGIN
                    IF lrc_SalesLine."Quantity Shipped" <> 0 THEN
                        // Es wurden bereits Mengen in der Verkaufszeile geliefert!
                        ERROR(POI_LT_TEXT001Txt);
                    lrc_SalesLine.SuspendStatusCheck(TRUE);
                    lrc_SalesLine.ADF_ChangeCalledFromPurchLine(TRUE);
                    lrc_SalesLine.VALIDATE("Net Weight", vrc_PurchaseLine."Net Weight");
                    lrc_SalesLine.VALIDATE("Sales Price (Price Base)");
                    lrc_SalesLine.MODIFY(TRUE);
                END;
        END;
    end;

    procedure ChangePurchaseLineGrossWeight(vrc_PurchaseLine: Record "Purchase Line")
    var
        POI_LT_TEXT001Txt: Label 'Es wurden bereits Mengen in der Verkaufszeile geliefert!';
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion bei Änderung des Bruttogewichtes in der Einkaufszeile
        // --------------------------------------------------------------------------------------------

        // Keine Aktion falls Standard Direktlieferung
        IF vrc_PurchaseLine."Drop Shipment" = TRUE THEN
            EXIT;

        IF (vrc_PurchaseLine."Sales Order No." <> '') AND
           (vrc_PurchaseLine."Sales Order Line No." <> 0) THEN BEGIN
            lrc_SalesLine.Reset();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE("Document No.", vrc_PurchaseLine."Sales Order No.");
            lrc_SalesLine.SETRANGE("Line No.", vrc_PurchaseLine."Sales Order Line No.");
            IF lrc_SalesLine.FIND('-') THEN BEGIN
                IF vrc_PurchaseLine."Gross Weight" <> lrc_SalesLine."Gross Weight" THEN
                    IF lrc_SalesLine."Quantity Shipped" <> 0 THEN
                        // Es wurden bereits Mengen in der Verkaufszeile geliefert!
                        ERROR(POI_LT_TEXT001Txt);
                lrc_SalesLine.SuspendStatusCheck(TRUE);
                lrc_SalesLine.ADF_ChangeCalledFromPurchLine(TRUE);
                lrc_SalesLine.VALIDATE("Gross Weight", vrc_PurchaseLine."Gross Weight");
                lrc_SalesLine.VALIDATE("Sales Price (Price Base)");
                lrc_SalesLine.MODIFY(TRUE);
            END;
        END;
    end;
}

