codeunit 5110348 "POI Customer Spec. Functions"
{



    //     var
    //         ivZEVKPost: Codeunit "61505";
    //         gdt_PostingDate: Date;


    //     procedure PrintPurchPalletLabel(var vrc_IncomingPallet: Record "5110445")
    //     var
    //         lrp_SCHLablePrint: Report "53001";
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // F40 001 00000000.s
    //         lrc_FruitVisionSetup.GET();
    //         // KDK 001 00000000.s
    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'SCHLIECKER' THEN BEGIN
    //         // KDK 001 00000000.e
    //            CLEAR(lrp_SCHLablePrint);
    //            lrp_SCHLablePrint.SETTABLEVIEW(vrc_IncomingPallet);
    //            lrp_SCHLablePrint.RUNMODAL;
    //            CLEAR(lrp_SCHLablePrint);
    //         // KDK 001 00000000.s
    //         END;
    //         // KDK 001 00000000.e
    //         // F40 001 00000000.e
    //     end;

    //     procedure Init_BDInsuranceSetup()
    //     var
    //         lrc_BDInsuranceSetup: Record "5110572";
    //     begin
    //         // WKV 001 WKVL0001.s
    //         WITH lrc_BDInsuranceSetup DO
    //           IF NOT FIND('-') THEN BEGIN
    //             INIT();
    //             INSERT(TRUE);
    //           END;
    //         // WKV 001 WKVL0001.e
    //     end;

    //     procedure Init_ARASetup()
    //     var
    //         lrc_ARASetup: Record "69502";
    //     begin
    //         // ARA 001 00000000.s
    //         WITH lrc_ARASetup DO
    //           IF NOT FIND('-') THEN BEGIN
    //             INIT();
    //             INSERT(TRUE);
    //           END;
    //         // ARA 001 00000000.e
    //     end;

    //     procedure PrintCombinedInvoice(var vrc_CombineInvoiceEntry: Record "5110485")
    //     var
    //         "-- L F40 002": Integer;
    //         lrc_CombineInvoiceEntry: Record "5110485";
    //         lrp_FNOCombineSalesInvoiceM: Report "52516";
    //         lrp_FNOTotalCombSalesInvM: Report "52513";
    //         lrp_GRUCombineSalesInvoice: Report "63064";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrp_EFGCombineSalesInvoice: Report "63563";
    //     begin
    //         // F40 002 00000000.s
    //         lrc_FruitVisionSetup.GET();

    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'EFG' THEN BEGIN
    //           lrc_CombineInvoiceEntry.Reset();
    //           lrc_CombineInvoiceEntry.SETRANGE("No.", vrc_CombineInvoiceEntry."No.");
    //           lrp_EFGCombineSalesInvoice.SETTABLEVIEW(lrc_CombineInvoiceEntry);
    //           lrp_EFGCombineSalesInvoice.USEREQUESTFORM := TRUE;
    //           lrp_EFGCombineSalesInvoice.RUNMODAL;
    //           EXIT;
    //         END;

    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'GRU' THEN BEGIN
    //           lrc_CombineInvoiceEntry.Reset();
    //           lrc_CombineInvoiceEntry.SETRANGE("No.", vrc_CombineInvoiceEntry."No.");
    //           lrp_GRUCombineSalesInvoice.SETTABLEVIEW(lrc_CombineInvoiceEntry);
    //           lrp_GRUCombineSalesInvoice.USEREQUESTFORM := TRUE;
    //           lrp_GRUCombineSalesInvoice.RUNMODAL;
    //         END ELSE BEGIN
    //           lrc_CombineInvoiceEntry.Reset();
    //           lrc_CombineInvoiceEntry.SETRANGE("No.", vrc_CombineInvoiceEntry."No.");
    //           IF vrc_CombineInvoiceEntry."Entry Type" = vrc_CombineInvoiceEntry."Entry Type"::"Comb.-Invoice" THEN BEGIN
    //             lrp_FNOCombineSalesInvoiceM.SETTABLEVIEW(lrc_CombineInvoiceEntry);
    //             lrp_FNOCombineSalesInvoiceM.USEREQUESTFORM := TRUE;
    //             lrp_FNOCombineSalesInvoiceM.RUNMODAL;
    //           END ELSE BEGIN
    //             IF vrc_CombineInvoiceEntry."Entry Type" = vrc_CombineInvoiceEntry."Entry Type"::"Collected Comb.-Invoice" THEN BEGIN
    //               lrp_FNOTotalCombSalesInvM.SETTABLEVIEW(lrc_CombineInvoiceEntry);
    //               lrp_FNOTotalCombSalesInvM.USEREQUESTFORM := TRUE;
    //               lrp_FNOTotalCombSalesInvM.RUNMODAL;
    //             END;
    //           END;
    //         END;

    //         // F40 002 00000000.e
    //     end;

    //     procedure "----- Agiles BTR"()
    //     begin
    //     end;

    //     procedure BTR_Report_SalesShipProfMII(var vrc_SalesHeader: Record "36")
    //     var
    //         "-- SSP L KDK 001": Integer;
    //         lrp_BTRSalesShipProfMII: Report "53525";
    //         lrp_BTRLieferscheinoffenIT: Report "53530";
    //         lrp_BTRLieferscheinoffen: Report "53501";
    //     begin
    //         // BTR 001 00000000.s
    //         IF ( vrc_SalesHeader."Sales Doc. Subtype Code" = 'ITALIEN' ) OR
    //            ( vrc_SalesHeader."Sales Doc. Subtype Code" = 'HOLLAND' ) THEN BEGIN
    //           // lrp_BTRLieferscheinoffenIT.SETTABLEVIEW(vrc_SalesHeader);
    //           // lrp_BTRLieferscheinoffenIT.USEREQUESTFORM( FALSE );
    //           // lrp_BTRLieferscheinoffenIT.RUNMODAL;
    //         END ELSE BEGIN
    //           // BTR 004 0801902A.s
    //           // lrp_BTRSalesShipProfMII.SETTABLEVIEW(vrc_SalesHeader);
    //           // lrp_BTRSalesShipProfMII.USEREQUESTFORM( FALSE );
    //           // lrp_BTRSalesShipProfMII.RUNMODAL;
    //           lrp_BTRLieferscheinoffen.SETTABLEVIEW(vrc_SalesHeader);
    //           lrp_BTRLieferscheinoffen.USEREQUESTFORM( FALSE );
    //           lrp_BTRLieferscheinoffen.RUNMODAL;
    //           // BTR 004 0801902A.e

    //         END;
    //         // BTR 001 00000000.e
    //     end;

    //     procedure BTR_SetPostDateFromSourceDoc(var rrc_SalesHeader: Record "36";vdt_SourcePostingDate: Date)
    //     var
    //         lrc_PaymentTerms: Record "3";
    //         lcu_GenJnlCheckLine: Codeunit "11";
    //     begin
    //         // BTR 002 BTR40069.s
    //         //--------------------------------------------------------------------------------------------------------------------------
    //         // Beim erstellen von Gutschrift aus Reklamationsmeldung wird Buchungsdatum des Ursprungsbeleges genommen
    //         //--------------------------------------------------------------------------------------------------------------------------
    //         IF vdt_SourcePostingDate = 0D THEN BEGIN
    //           EXIT;
    //         END;
    //         // BTR 002 BTR40069.e

    //         // BTR 003 BTR40085.s
    //         // ----------------------------------------------------------------------------------------------------------------------
    //         // Buchungsdatum soll in zugelassenem Buchungsperiod des Users bzw. der FiBu liegen, sonst wird TODAY zugewiesen
    //         // ----------------------------------------------------------------------------------------------------------------------

    //         IF lcu_GenJnlCheckLine.DateNotAllowed( vdt_SourcePostingDate ) THEN BEGIN
    //           rrc_SalesHeader."Posting Date" := TODAY;
    //         END ELSE BEGIN
    //           rrc_SalesHeader."Posting Date" := vdt_SourcePostingDate;
    //         END;

    //         // BTR 003 BTR40085.e
    //     end;

    //     procedure BTR_DelRefPostPurchLineToSales(var rrc_SalesLine: Record "37")
    //     var
    //         lrc_PurchaseLine: Record "39";
    //         lrc_PurchRcptLine: Record "121";
    //         AGILESText001: Label 'Die Verknüpfung in Einkaufszeile %1 Beleg %2 %3, Menge %4 %5 wurde gelöscht.';
    //     begin
    //         // BTR 005 BTR40107.s
    //         // -------------------------------------------------------------------------------------------------------------------
    //         // Funktion trennt die Verbindung zwischen einer noch nicht gelieferten VK Zeile und einer schon gelieferten EK Zeile
    //         //--------------------------------------------------------------------------------------------------------------------

    //         // Keine Aktion falls Standard Direktlieferung
    //         IF rrc_SalesLine."Drop Shipment" = TRUE THEN BEGIN
    //           EXIT;
    //         END;

    //         // Keine Aktion, wenn die Zeile schon geliefert wurde
    //         IF rrc_SalesLine."Quantity Shipped" <> 0 THEN BEGIN
    //           EXIT;
    //         END;

    //         IF (rrc_SalesLine."Purchase Order No." = '') OR (rrc_SalesLine."Purch. Order Line No." = 0) THEN BEGIN
    //           EXIT;
    //         END;

    //         IF lrc_PurchaseLine.GET(lrc_PurchaseLine."Document Type"::Order,rrc_SalesLine."Purchase Order No.",
    //                 rrc_SalesLine."Purch. Order Line No.")
    //         THEN BEGIN
    //           // Keine Aktion, wenn die Verbindung nicht mehr existiert
    //           IF (lrc_PurchaseLine."Sales Order No." <> rrc_SalesLine."Document No.") OR
    //              (lrc_PurchaseLine."Sales Order Line No." <> rrc_SalesLine."Line No.")
    //           THEN BEGIN
    //             EXIT;
    //           END;

    //           // Keine Aktion, wenn die Zeile noch nicht geliefert wurde
    //           IF lrc_PurchaseLine."Quantity Received" <> 0 THEN BEGIN
    //             // Verbindung auch in den dazugehörigen Lieferungszeilen löschen
    //             lrc_PurchRcptLine.Reset();
    //             lrc_PurchRcptLine.SETCURRENTKEY("Order No.","Order Line No.","Posting Date");
    //             lrc_PurchRcptLine.SETRANGE("Order No.",lrc_PurchaseLine."Document No.");
    //             lrc_PurchRcptLine.SETRANGE("Order Line No.",lrc_PurchaseLine."Line No.");
    //             IF lrc_PurchRcptLine.FIND('-') THEN BEGIN
    //               REPEAT
    //                 IF (lrc_PurchRcptLine."Sales Order No." = lrc_PurchaseLine."Sales Order No.") AND
    //                    (lrc_PurchRcptLine."Sales Order Line No." = lrc_PurchaseLine."Sales Order Line No.")
    //                 THEN BEGIN
    //                   lrc_PurchRcptLine."Sales Order No." := '';
    //                   lrc_PurchRcptLine."Sales Order Line No." := 0;
    //                   lrc_PurchRcptLine.Modify();
    //                 END;
    //               UNTIL lrc_PurchRcptLine.NEXT() = 0;
    //             END;

    //             lrc_PurchaseLine."Sales Order No." := '';
    //             lrc_PurchaseLine."Sales Order Line No." := 0;
    //             lrc_PurchaseLine.Modify();

    //             rrc_SalesLine."Purchase Order No." := '';
    //             rrc_SalesLine."Purch. Order Line No." := 0;
    //             rrc_SalesLine.Modify();
    //             MESSAGE(AGILESText001,lrc_PurchaseLine."Line No.",lrc_PurchaseLine."Document Type",
    //                     lrc_PurchaseLine."Document No.",lrc_PurchaseLine.Quantity,lrc_PurchaseLine."Unit of Measure Code");

    //           END;
    //         END;

    //         // BTR 005 BTR40107.e
    //     end;

    //     procedure "----- Agiles MEV"()
    //     begin
    //     end;

    //     procedure MEV_Init()
    //     var
    //         lrc_MEVSetup: Record "55000";
    //         lrc_FruitvisionCaption: Record "5110300";
    //         lrc_FruitvisionCaptiontranslat: Record "5110301";
    //     begin
    //         // MEV 001 MEV00001.s
    //         IF NOT lrc_MEVSetup.GET THEN BEGIN
    //            lrc_MEVSetup.INIT();
    //            lrc_MEVSetup.INSERT( TRUE );
    //         END;

    //         // Prozentsätze
    //         IF lrc_MEVSetup."% Sorting Quality 1" = '' THEN BEGIN
    //            lrc_MEVSetup."% Sorting Quality 1" := 'P_SQUALITY1';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'P_SQUALITY1' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'P_SQUALITY1' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. % A-Ware' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY1' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY1' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. % A-Ware' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY1' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY1' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. % A-Goods' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."% Sorting Quality 2" = '' THEN BEGIN
    //            lrc_MEVSetup."% Sorting Quality 2" := 'P_SQUALITY2';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'P_SQUALITY2' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'P_SQUALITY2' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. % 2. Qualität' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY2' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY2' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. % 2. Qualität' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY2' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY2' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. % 2. Quality' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."% Sorting Quality 3" = '' THEN BEGIN
    //            lrc_MEVSetup."% Sorting Quality 3" := 'P_SQUALITY3';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'P_SQUALITY3' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'P_SQUALITY3' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. % Mostware' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY3' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY3' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. % Mostware' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY3' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY3' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. % Fruit Juice' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."% Sorting Quality 4" = '' THEN BEGIN
    //            lrc_MEVSetup."% Sorting Quality 4" := 'P_SQUALITY4';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'P_SQUALITY4' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'P_SQUALITY4' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. % Faule' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY4' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY4' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. % Faule' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY4' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY4' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. % Foul' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."% Sorting Quality 5" = '' THEN BEGIN
    //            lrc_MEVSetup."% Sorting Quality 5" := 'P_SQUALITY5';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'P_SQUALITY5' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'P_SQUALITY5' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. % Unterkaliber' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY5' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY5' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. % Unterkaliber' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY5' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY5' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. % Smaller Caliber' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."% Sorting Quality 6" = '' THEN BEGIN
    //            lrc_MEVSetup."% Sorting Quality 6" := 'P_SQUALITY6';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'P_SQUALITY6' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'P_SQUALITY6' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. % Überkaliber' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY6' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY6' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. % Überkaliber' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'P_SQUALITY6' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'P_SQUALITY6' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. % Bigger Caliber' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;

    //         // Mengen
    //         IF lrc_MEVSetup."Quantity Sorting Quality 1" = '' THEN BEGIN
    //            lrc_MEVSetup."Quantity Sorting Quality 1" := 'M_SQUALITY1';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'M_SQUALITY1' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'M_SQUALITY1' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. Menge A-Ware' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY1' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY1' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. Menge A-Ware' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY1' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY1' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. Quantity A-Goods' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."Quantity Sorting Quality 2" = '' THEN BEGIN
    //            lrc_MEVSetup."Quantity Sorting Quality 2" := 'M_SQUALITY2';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'M_SQUALITY2' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'M_SQUALITY2' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. Menge 2. Qualität' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY2' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY2' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. Menge 2. Qualität' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY2' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY2' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. Quantity 2. Quality' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."Quantity Sorting Quality 3" = '' THEN BEGIN
    //            lrc_MEVSetup."Quantity Sorting Quality 3" := 'M_SQUALITY3';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'M_SQUALITY3' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'M_SQUALITY3' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. Menge Mostware' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY3' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY3' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. Menge Mostware' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY3' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY3' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. Quantity Fruit Juice' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."Quantity Sorting Quality 4" = '' THEN BEGIN
    //            lrc_MEVSetup."Quantity Sorting Quality 4" := 'M_SQUALITY4';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'M_SQUALITY4' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'M_SQUALITY4' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. Menge Faule' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY4' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY4' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. Menge Faule' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY4' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY4' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. Quantity Foul' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."Quantity Sorting Quality 5" = '' THEN BEGIN
    //            lrc_MEVSetup."Quantity Sorting Quality 5" := 'M_SQUALITY5';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'M_SQUALITY5' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'M_SQUALITY5' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. Menge Unterkaliber' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY5' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY5' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. Menge Unterkaliber' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY5' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY5' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. Quantity Smaller Caliber' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         IF lrc_MEVSetup."Quantity Sorting Quality 6" = '' THEN BEGIN
    //            lrc_MEVSetup."Quantity Sorting Quality 6" := 'M_SQUALITY6';
    //            lrc_MEVSetup.Modify();
    //            lrc_FruitvisionCaption.Reset();
    //            lrc_FruitvisionCaption.SETRANGE( Code, 'M_SQUALITY6' );
    //            IF NOT lrc_FruitvisionCaption.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaption.INIT();
    //               lrc_FruitvisionCaption.VALIDATE( Code, 'M_SQUALITY6' );
    //               lrc_FruitvisionCaption.VALIDATE( Name, 'Erw. Menge Überkaliber 6' );
    //               lrc_FruitvisionCaption.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY6' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1031 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY6' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1031 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Erw. Menge Überkaliber' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //            lrc_FruitvisionCaptiontranslat.Reset();
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( Code, 'M_SQUALITY6' );
    //            lrc_FruitvisionCaptiontranslat.SETRANGE( "Language ID", 1033 );
    //            IF NOT lrc_FruitvisionCaptiontranslat.FIND('-') THEN BEGIN
    //               lrc_FruitvisionCaptiontranslat.INIT();
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Code, 'M_SQUALITY6' );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( "Language ID", 1033 );
    //               lrc_FruitvisionCaptiontranslat.VALIDATE( Name, 'Exp. Quantity Bigger Caliber' );
    //               lrc_FruitvisionCaptiontranslat.INSERT( TRUE );
    //            END;
    //         END;
    //         // MEV 001 MEV00001.e
    //     end;

    procedure MEV_CalcCapNeed(var vrc_PackOrderOutputItems: Record "POI Pack. Order Output Items")
    var
    //ResCapNeedPerUOM: Record "55020";
    begin
        // ResCapNeedPerUOM.Reset();
        // ResCapNeedPerUOM.SETRANGE("Resource No.", vrc_PackOrderOutputItems."Production Line Code");
        // ResCapNeedPerUOM.SETFILTER("Item No.",'%1|%2',vrc_PackOrderOutputItems."Item No.",'');
        // ResCapNeedPerUOM.SETFILTER("Item Category Code",'%1|%2',vrc_PackOrderOutputItems."Item Category Code",'');
        // ResCapNeedPerUOM.SETFILTER("Product Group Code",'%1|%2',vrc_PackOrderOutputItems."Product Group Code",'');
        // IF NOT ResCapNeedPerUOM.FIND('+') THEN
        //   EXIT
        // ELSE
        //   vrc_PackOrderOutputItems."Expected Capacity Need" :=
        //      vrc_PackOrderOutputItems.Quantity * ResCapNeedPerUOM."Capacity Need per Unit";
    end;

    //     procedure MEV_CAPNEED(var vrc_Resource: Record Resource)
    //     var
    //         CapNeedPerUOM: Record "55020";
    //     begin
    //         // MEV 001 MEV00001s

    //         CapNeedPerUOM.Reset();
    //         CapNeedPerUOM.SETRANGE("Resource No.", vrc_Resource."No.");
    //         FORM.RUN(FORM::Form55020,CapNeedPerUOM);
    //         // MEV 001 MEV00001.s
    //     end;

    //     procedure MEV_DefineSortingWithSpectrum(): Boolean
    //     var
    //         lrc_MEVSetup: Record "55000";
    //     begin
    //         // MEV 002 MEV00001.s
    //         lrc_MEVSetup.GET();
    //         EXIT( lrc_MEVSetup."Def. Sorting With Spectrum" );
    //         // MEV 002 MEV00001.s
    //     end;

    //     procedure MEV_AnserSortingQuality(rin_Value: Integer): Code[20]
    //     var
    //         lrc_MEVSetup: Record "55000";
    //     begin
    //         // MEV 002 MEV00001.s
    //         lrc_MEVSetup.GET();
    //         CASE rin_Value OF
    //           1: EXIT( lrc_MEVSetup."QM Answer Sorting Quality 1" );
    //           2: EXIT( lrc_MEVSetup."QM Answer Sorting Quality 2" );
    //           3: EXIT( lrc_MEVSetup."QM Answer Sorting Quality 3" );
    //           4: EXIT( lrc_MEVSetup."QM Answer Sorting Quality 4" );
    //           5: EXIT( lrc_MEVSetup."QM Answer Sorting Quality 5" );
    //           6: EXIT( lrc_MEVSetup."QM Answer Sorting Quality 6" );
    //         END;
    //         EXIT ( '!?!?!?!?!?!?!?!?!?!?' );
    //         // MEV 002 MEV00001.e
    //     end;

    //     procedure "----- Agiles SCH"()
    //     begin
    //     end;

    //     procedure SCH_ErzAbrCreateFile(var vrc_ProducerStatHeader: Record "5110508")
    //     var
    //         lrc_MALSetup: Record "53000";
    //         lrc_ProducerStatHeader: Record "5110508";
    //         lrc_ProducerStatLine: Record "5110509";
    //         lrc_ProducerStatLineVAT: Record "5110509";
    //         lrc_ProducerStatLine2: Record "5110509";
    //         lrc_ProducerStatLine3: Record "5110509";
    //         lrc_ProducerStatLineXRec: Record "5110509";
    //         lrc_Vendor: Record "Vendor";
    //         lrc_PurchInvHeader: Record "122";
    //         lrc_PurchCrMemoHdr: Record "124";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_ItemCategory: Record "5722";
    //         lrc_GradeofGoods: Record "5110308";
    //         lrc_Currency: Record "4";
    //         lrc_FeesProducerStat: Record "5110501";
    //         lrc_ProdVendor: Record "Vendor";
    //         lrc_CostCategoryAccounts: Record "5110346";
    //         lfi_ExportFile: File;
    //         lco_ExportFileName: Code[20];
    //         SSPText001: Label 'Creating file...\\';
    //         ldg_Window: Dialog;
    //         lin_TotalRecNo: Integer;
    //         lin_RecNo: Integer;
    //         SSPText002: Label '@HS';
    //         SSPText003: Label '@PS';
    //         ldc_TotalWeight: Decimal;
    //         ldc_VAT: Decimal;
    //         SSPText004: Label 'Unterschiedliche Warenwert MwSt.-Sätze für Abrechnung %1 vorhanden. ';
    //         ldc_HSAmount: Decimal;
    //         ldc_PSVGAmount: Decimal;
    //         ldc_VL2Amount: Decimal;
    //         ldc_VL1Amount: Decimal;
    //         ldc_VL2Quantity: Decimal;
    //         ldc_VL1Quantity: Decimal;
    //         ldc_VL2Price: Decimal;
    //         ldc_VL1Price: Decimal;
    //         lco_ItemNo: Code[20];
    //         lcu_ProducerStatManagement: Codeunit "5110308";
    //         ltx_Description1: Text[100];
    //         ltx_Description2: Text[100];
    //         lco_ItemCategoryCode: Code[20];
    //         lco_CaliberCode: Code[20];
    //         lrc_Item: Record Item;
    //     begin
    //         // SCH 001 00000000.s
    //         // ----------------------------------------------------------------------------
    //         // Funktion zur Erstellung der Abrechnungsdatei für die Erz. Gemeinschaft M.AL.
    //         // ----------------------------------------------------------------------------

    //         lrc_MALSetup.GET();
    //         lrc_MALSetup.TESTFIELD("Prod. Stat. Distributor No.");
    //         lrc_MALSetup.TESTFIELD("Prod. Stat. Export Path");
    //         lrc_MALSetup.TESTFIELD("Prod. Stat. Distributor No.");
    //         lrc_MALSetup.TESTFIELD("CA Totaling Sales Stock");
    //         lrc_MALSetup.TESTFIELD("CA Totaling Company Stock");
    //         lrc_MALSetup.TESTFIELD("CA Totaling Charge");
    //         lrc_MALSetup.TESTFIELD("Item Category 1");
    //         lrc_MALSetup.TESTFIELD("Item Category 2");
    //         lrc_MALSetup.TESTFIELD("Item Category 3");

    //         ldg_Window.OPEN(
    //           SSPText001 +
    //           '@1@@@@@@@@@@@@@@@@@@@@@\');
    //         ldg_Window.UPDATE(1,0);

    //         lin_TotalRecNo := 0;
    //         lin_RecNo :=0;

    //         WITH vrc_ProducerStatHeader DO BEGIN

    //           FIND('-');

    //             lfi_ExportFile.CREATE(lrc_MALSetup."Prod. Stat. Export Path" + lrc_MALSetup."Prod. Stat. Export Filename");
    //             lfi_ExportFile.TEXTMODE := TRUE;
    //             lin_TotalRecNo := vrc_ProducerStatHeader.COUNTAPPROX;

    //           REPEAT

    //             IF lrc_ProducerStatHeader.GET(vrc_ProducerStatHeader."No.") THEN BEGIN

    //               // Kreditor holen
    //               lrc_Vendor.GET(lrc_ProducerStatHeader."Producer No.");

    //               // Anforderung der M.AL.: Daten sequenziell wegschreiben

    //               // ----------------------
    //               // Hauptsatzkennung '@HS'
    //               // ----------------------
    //               lfi_ExportFile.WRITE(SSPText002);

    //               // Vermarkter-Nr.
    //               lfi_ExportFile.WRITE(lrc_MALSetup."Prod. Stat. Distributor No.");

    //               // Vermarkter-Erzeuger-Nr.
    //               lfi_ExportFile.WRITE(lrc_ProducerStatHeader."Producer No.");

    //               // Abrechnungsnr.
    //               lfi_ExportFile.WRITE(lrc_ProducerStatHeader."No.");

    //               // Abrechnungsdatum
    //               lfi_ExportFile.WRITE(FORMAT(lrc_ProducerStatHeader."Posting Date"));

    //               // Erzeugername1
    //               lfi_ExportFile.WRITE(lrc_Vendor.Name);

    //               // Erzeugername2
    //               lfi_ExportFile.WRITE(lrc_Vendor."Name 2");

    //               // Erzeuger-Straße
    //               lfi_ExportFile.WRITE(lrc_Vendor.Address);

    //               // Erzeuger-PLZ
    //               lfi_ExportFile.WRITE(lrc_Vendor."Post Code");

    //               // Erzeuger-Ort
    //               lfi_ExportFile.WRITE(lrc_Vendor.City);

    //               // Nettowarenwert
    //               // Betrag mit Rundungspräzision ermitteln
    //               ldc_HSAmount := 0;
    //               lrc_Currency.InitRoundingPrecision;
    //               lrc_ProducerStatLine.Reset();
    //               lrc_ProducerStatLine.SETRANGE("Producer Statement No.",lrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine.SETRANGE(Type,lrc_ProducerStatLine.Type::Item);
    //               lrc_ProducerStatLine.SETFILTER("No.",'<>%1','');
    //               lrc_ProducerStatLine.SETRANGE("Item Typ",lrc_ProducerStatLine."Item Typ"::"Trade Item");
    //               IF lrc_ProducerStatLine.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   ldc_HSAmount += lrc_ProducerStatLine.Amount;
    //                 UNTIL lrc_ProducerStatLine.NEXT() = 0;
    //               END;
    //               lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(ROUND(ldc_HSAmount,
    //                                    lrc_Currency."Amount Rounding Precision"))));

    //               // Gewicht
    //               // Summe Gewicht aus Zeilen holen
    //               ldc_TotalWeight := 0;
    //               lrc_ProducerStatLine.Reset();
    //               lrc_ProducerStatLine.SETRANGE("Producer Statement No.",lrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine.SETRANGE(Type,lrc_ProducerStatLine.Type::Item);
    //               lrc_ProducerStatLine.SETFILTER("No.",'<>%1','');
    //               lrc_ProducerStatLine.SETRANGE("Item Typ",lrc_ProducerStatLine."Item Typ"::"Trade Item");
    //               IF lrc_ProducerStatLine.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   ldc_TotalWeight += lrc_ProducerStatLine."Total Net Weight";
    //                 UNTIL lrc_ProducerStatLine.NEXT() = 0;
    //               END;
    //               lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(ROUND(ldc_TotalWeight))));

    //               // MwSt1/MwSt2
    //               // Mehrwertsteuersätze ermitteln
    //               ldc_VAT := 0;
    //               lrc_ProducerStatLineVAT.Reset();
    //               lrc_ProducerStatLineVAT.SETRANGE("Producer Statement No.",vrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLineVAT.SETRANGE(Type,lrc_ProducerStatLineVAT.Type::Item);
    //               lrc_ProducerStatLineVAT.SETFILTER("No.",'<>%1','');
    //               lrc_ProducerStatLineVAT.SETRANGE("Item Typ",lrc_ProducerStatLineVAT."Item Typ"::"Trade Item");
    //               IF lrc_ProducerStatLineVAT.FIND('-') THEN BEGIN
    //                 ldc_VAT := lrc_ProducerStatLineVAT."VAT %";
    //                 REPEAT
    //                   IF lrc_ProducerStatLineVAT."VAT %" <> ldc_VAT THEN BEGIN
    //                     ERROR(SSPText004,vrc_ProducerStatHeader."No.");
    //                   END;
    //                 UNTIL lrc_ProducerStatLineVAT.NEXT() = 0;
    //               END;
    //               lfi_ExportFile.WRITE(ldc_VAT);
    //               lfi_ExportFile.WRITE('16');

    //               // Erzeugerleistungen (sortieren/verpacken) nicht relevant für Schliecker
    //               // Zeilen schreiben für reservierte oder nicht mehr genutzte Felder
    //               // Erzeugerleistungen/Reserviert1/Reserviert2/CMAProzent/CMABetrag
    //               lfi_ExportFile.WRITE(' ');
    //               lfi_ExportFile.WRITE(' ');
    //               lfi_ExportFile.WRITE(' ');
    //               lfi_ExportFile.WRITE(' ');
    //               lfi_ExportFile.WRITE(' ');

    //               // Anteil Absatzfonds
    //               // Berechnungsweise ermitteln
    //               lrc_FeesProducerStat.Reset();
    //               lrc_FeesProducerStat.SETRANGE("Cost Category Code",lrc_MALSetup."CA Totaling Sales Stock");
    //               IF vrc_ProducerStatHeader."Producer No." <> '' THEN BEGIN
    //                 lrc_ProdVendor.GET(vrc_ProducerStatHeader."Producer No.");
    //               END;
    //               lrc_FeesProducerStat.SETRANGE("Member of Prod. Companionship",
    //                                               lrc_ProdVendor."Member of Prod. Companionship");
    //               lrc_FeesProducerStat.SETFILTER("Member State Companionship",'%1|%2',
    //                                                lrc_ProdVendor."Member State Companionship",0);
    //               IF lrc_FeesProducerStat.FIND('+') THEN BEGIN
    //                 lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(lrc_FeesProducerStat.Value)));
    //               END ELSE BEGIN
    //                 lfi_ExportFile.WRITE(' ');
    //               END;

    //               // Sachkonto ermitteln
    //               lrc_CostCategoryAccounts.Reset();
    //               lrc_CostCategoryAccounts.SETRANGE("Cost Category Code",lrc_MALSetup."CA Totaling Sales Stock");
    //               lrc_CostCategoryAccounts.FIND('-');
    //               lrc_CostCategoryAccounts.TESTFIELD("G/L Account No.");

    //               ldc_HSAmount := 0;
    //               lrc_ProducerStatLine2.Reset();
    //               lrc_ProducerStatLine2.SETRANGE("Producer Statement No.",vrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine2.SETRANGE(Type,lrc_ProducerStatLine2.Type::"G/L Account");
    //               lrc_ProducerStatLine2.SETFILTER("No.",lrc_CostCategoryAccounts."G/L Account No.");
    //               IF lrc_ProducerStatLine2.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   ldc_HSAmount += lrc_ProducerStatLine2.Amount;
    //                 UNTIL lrc_ProducerStatLine2.NEXT() = 0;
    //               END;

    //               // Summe Absatzfonds
    //               // Betrag mit Rundungspräzision ermitteln
    //               lrc_Currency.InitRoundingPrecision;
    //               lfi_ExportFile.WRITE( lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                 FORMAT(ROUND((ldc_HSAmount * -1),lrc_Currency."Amount Rounding Precision"))));

    //               // Vermarkterleistungen
    //               ldc_HSAmount := 0;
    //               lrc_ProducerStatLine2.Reset();
    //               lrc_ProducerStatLine2.SETRANGE("Producer Statement No.",vrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine2.SETFILTER("No.",'<>%1','');
    //               lrc_ProducerStatLine2.SETFILTER("Item Typ",'%1|%2',lrc_ProducerStatLine2."Item Typ"::"Packing Material",
    //                                               lrc_ProducerStatLine2."Item Typ"::"Empties Item");
    //               lrc_ProducerStatLine2.SETFILTER(Quantity,'<>%1',0);
    //               lrc_ProducerStatLine2.SETFILTER(Amount,'<>%1',0);
    //               IF lrc_ProducerStatLine2.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   ldc_HSAmount += lrc_ProducerStatLine2.Amount;
    //                 UNTIL lrc_ProducerStatLine2.NEXT() = 0;
    //               END;

    //               // Betrag mit Rundungspräzision ermitteln
    //               lrc_Currency.InitRoundingPrecision;
    //               lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                 FORMAT(ROUND((ldc_HSAmount * -1),lrc_Currency."Amount Rounding Precision"))));

    //               // ---------------------
    //               // Kernobstbetriebsfonds
    //               // ---------------------
    //               // Sachkonto ermitteln
    //               lrc_CostCategoryAccounts.Reset();
    //               lrc_CostCategoryAccounts.SETRANGE("Cost Category Code",lrc_MALSetup."CA Totaling Company Stock");
    //               lrc_CostCategoryAccounts.FIND('-');
    //               lrc_CostCategoryAccounts.TESTFIELD("G/L Account No.");

    //               // Betrag ermitteln
    //               ldc_HSAmount := 0;
    //               lrc_ProducerStatLine2.Reset();
    //               lrc_ProducerStatLine2.SETRANGE("Producer Statement No.",vrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine2.SETRANGE(Type,lrc_ProducerStatLine2.Type::"G/L Account");
    //               lrc_ProducerStatLine2.SETFILTER("No.",lrc_CostCategoryAccounts."G/L Account No.");
    //               lrc_ProducerStatLine2.SETRANGE("Item Category Code",lrc_MALSetup."Item Category 2");
    //               IF lrc_ProducerStatLine2.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   ldc_HSAmount += lrc_ProducerStatLine2.Amount;
    //                 UNTIL lrc_ProducerStatLine2.NEXT() = 0;
    //               END;

    //               // Kernobstbetriebsfonds Prozent
    //               // Berechnungsweise ermitteln
    //               IF ldc_HSAmount <> 0 THEN BEGIN
    //                 lrc_FeesProducerStat.Reset();
    //                 lrc_FeesProducerStat.SETRANGE("Cost Category Code",lrc_MALSetup."CA Totaling Company Stock");
    //                 lrc_FeesProducerStat.SETRANGE("Item Category Code",lrc_MALSetup."Item Category 2");
    //                 lrc_ProdVendor.GET(vrc_ProducerStatHeader."Producer No.");
    //                 lrc_FeesProducerStat.SETRANGE("Member of Prod. Companionship",
    //                                               lrc_ProdVendor."Member of Prod. Companionship");
    //                 lrc_FeesProducerStat.SETFILTER("Member State Companionship",'%1|%2',
    //                                                lrc_ProdVendor."Member State Companionship",0);
    //                 IF lrc_FeesProducerStat.FIND('+') THEN BEGIN
    //                   lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(lrc_FeesProducerStat.Value)));
    //                 END ELSE BEGIN
    //                   lfi_ExportFile.WRITE(' ');
    //                 END;
    //               END ELSE BEGIN
    //                 lfi_ExportFile.WRITE(' ');
    //               END;

    //               // Kernobstbetriebsfonds Betrag
    //               // Betrag mit Rundungspräzision ermitteln
    //               lrc_Currency.InitRoundingPrecision;
    //               lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                 FORMAT(ROUND((ldc_HSAmount * -1),lrc_Currency."Amount Rounding Precision"))));

    //               // ----------------------
    //               // Weichobstbetriebsfonds
    //               // ----------------------
    //               // Weichobstbetriebsfonds (Weichobst und Steinobst)
    //               // Sachkonto ermitteln
    //               lrc_CostCategoryAccounts.Reset();
    //               lrc_CostCategoryAccounts.SETRANGE("Cost Category Code",lrc_MALSetup."CA Totaling Company Stock");
    //               lrc_CostCategoryAccounts.FIND('-');
    //               lrc_CostCategoryAccounts.TESTFIELD("G/L Account No.");

    //               // Betrag ermitteln
    //               ldc_HSAmount := 0;
    //               lrc_ProducerStatLine2.Reset();
    //               lrc_ProducerStatLine2.SETRANGE("Producer Statement No.",vrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine2.SETRANGE(Type,lrc_ProducerStatLine2.Type::"G/L Account");
    //               lrc_ProducerStatLine2.SETFILTER("No.",lrc_CostCategoryAccounts."G/L Account No.");
    //               lrc_ProducerStatLine2.SETFILTER("Item Category Code",'%1|%2',lrc_MALSetup."Item Category 1",lrc_MALSetup."Item Category 3");
    //               IF lrc_ProducerStatLine2.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   ldc_HSAmount += lrc_ProducerStatLine2.Amount;
    //                 UNTIL lrc_ProducerStatLine2.NEXT() = 0;
    //               END;

    //               // Weichobstbetriebsfonds Prozent
    //               // Berechnungsweise ermitteln
    //               IF ldc_HSAmount <> 0 THEN BEGIN
    //                 lrc_FeesProducerStat.Reset();
    //                 lrc_FeesProducerStat.SETRANGE("Cost Category Code",lrc_MALSetup."CA Totaling Company Stock");
    //                 lrc_FeesProducerStat.SETFILTER("Item Category Code",'%1|%2',lrc_MALSetup."Item Category 1",lrc_MALSetup."Item Category 3")
    //         ;
    //                 lrc_ProdVendor.GET(vrc_ProducerStatHeader."Producer No.");
    //                 lrc_FeesProducerStat.SETRANGE("Member of Prod. Companionship",
    //                                               lrc_ProdVendor."Member of Prod. Companionship");
    //                 lrc_FeesProducerStat.SETFILTER("Member State Companionship",'%1|%2',
    //                                                lrc_ProdVendor."Member State Companionship",0);
    //                 IF lrc_FeesProducerStat.FIND('+') THEN BEGIN
    //                   lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                     FORMAT(lrc_FeesProducerStat.Value)));
    //                 END ELSE BEGIN
    //                   lfi_ExportFile.WRITE(' ');
    //                 END;
    //               END ELSE BEGIN
    //                 lfi_ExportFile.WRITE(' ');
    //               END;

    //               // Weichobstbetriebsfonds Betrag
    //               // Betrag mit Rundungspräzision ermitteln
    //               lrc_Currency.InitRoundingPrecision;
    //               lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                 FORMAT(ROUND((ldc_HSAmount * -1),lrc_Currency."Amount Rounding Precision"))));

    //               // Zeilen schreiben für reservierte oder nicht mehr genutzte Felder
    //               // Reserviert3/Reserviert4/Reserviert5/Reserviert5/Reserviert6/Reserviert7
    //               lfi_ExportFile.WRITE(' ');
    //               lfi_ExportFile.WRITE(' ');
    //               lfi_ExportFile.WRITE(' ');
    //               lfi_ExportFile.WRITE(' ');
    //               lfi_ExportFile.WRITE(' ');

    //               // ------------------------------------------------------------------------
    //               // Producer Stat. Zeilen zum Kopf holen und jeden Satz einzeln wegschreiben
    //               // ------------------------------------------------------------------------
    //               // Artikeldaten
    //               lrc_ProducerStatLine2.Reset();
    //               lrc_ProducerStatLine2.SETRANGE("Producer Statement No.",lrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine2.SETRANGE(Type,lrc_ProducerStatLine2.Type::Item);
    //               lrc_ProducerStatLine2.SETFILTER("No.",'<>%1','');
    //               lrc_ProducerStatLine2.SETRANGE("Item Typ",lrc_ProducerStatLine2."Item Typ"::"Trade Item");
    //               IF lrc_ProducerStatLine2.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   // --------------------------
    //                   // Positionssatzkennung '@PS'
    //                   // --------------------------
    //                   lfi_ExportFile.WRITE(SSPText003);

    //                   // Vermarkter-Nr./Vermarkter-Erzeuger-Nr./Abrechnungsnr.
    //                   lfi_ExportFile.WRITE(lrc_MALSetup."Prod. Stat. Distributor No.");
    //                   lfi_ExportFile.WRITE(lrc_ProducerStatHeader."Producer No.");
    //                   lfi_ExportFile.WRITE(lrc_ProducerStatHeader."No.");

    //                   // Daten aus Geb. EK-RG Kopf holen
    //                   IF vrc_ProducerStatHeader."Document Type" = vrc_ProducerStatHeader."Document Type"::"Prod. Stat." THEN BEGIN
    //                     lrc_PurchInvHeader.Reset();
    //                     lrc_PurchInvHeader.SETCURRENTKEY("Order No.");
    //                     lrc_PurchInvHeader.SETRANGE("Order No.",lrc_ProducerStatLine2."Source Purch. Doc. No.");
    //                     IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                       // Lieferdatum/Lieferschein-Nr.
    //                       lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                       lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                     END ELSE BEGIN
    //                       lrc_PurchInvHeader.Reset();
    //                       lrc_PurchInvHeader.SETCURRENTKEY("Pre-Assigned No.");
    //                       lrc_PurchInvHeader.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine2."Source Purch. Doc. No.");
    //                       IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                         // Lieferdatum/Lieferschein-Nr.
    //                         lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                         lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                       END ELSE BEGIN
    //                         lfi_ExportFile.WRITE(' ');
    //                         lfi_ExportFile.WRITE(' ');
    //                       END;
    //                     END;
    //                   END ELSE BEGIN
    //                     lrc_PurchCrMemoHdr.Reset();
    //                     lrc_PurchCrMemoHdr.SETCURRENTKEY("Pre-Assigned No.");
    //                     lrc_PurchCrMemoHdr.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine2."Source Purch. Doc. No.");
    //                     IF lrc_PurchCrMemoHdr.FIND('-') THEN BEGIN
    //                       // Lieferdatum/Lieferschein-Nr.
    //                       lfi_ExportFile.WRITE(FORMAT(lrc_PurchCrMemoHdr."Document Date"));
    //                       lfi_ExportFile.WRITE(lrc_PurchCrMemoHdr."Lot No. Producer");
    //                     END ELSE BEGIN
    //                       lfi_ExportFile.WRITE(' ');
    //                       lfi_ExportFile.WRITE(' ');
    //                     END;
    //                   END;

    //                   // SCH 002 00000000.s
    //                   // Artikeldaten aus Positionsvariante holen
    //                   ltx_Description1 := '';
    //                   ltx_Description2 := '';
    //                   lco_ItemCategoryCode := '';
    //                   lco_CaliberCode := '';

    //                   IF lrc_ProducerStatLine2."Batch Variant No." <> '' THEN BEGIN
    //                     lrc_BatchVariant.GET(lrc_ProducerStatLine2."Batch Variant No.");
    //                     ltx_Description1 := lrc_BatchVariant.Description;
    //                     ltx_Description2 := lrc_BatchVariant."Description 2";
    //                     lco_ItemCategoryCode := lrc_BatchVariant."Item Category Code";
    //                     lco_CaliberCode := lrc_BatchVariant."Caliber Code";
    //                   END ELSE BEGIN
    //                     lrc_Item.GET(lrc_ProducerStatLine2."No.");
    //                     ltx_Description1 := lrc_Item.Description;
    //                     ltx_Description2 := lrc_Item."Description 2";
    //                     lco_ItemCategoryCode := lrc_Item."Item Category Code";
    //                     lco_CaliberCode := lrc_Item."Caliber Code";
    //                   END;

    //                   // Sortenbezeichnung1/Sortenbezeichnung2
    //                   lfi_ExportFile.WRITE(ltx_Description1);
    //                   lfi_ExportFile.WRITE(ltx_Description2);

    //                   // Vermarkter-Sorten-Nr.
    //                   IF MAXSTRLEN(lrc_ProducerStatLine2."No.") > 11 THEN BEGIN
    //                     lfi_ExportFile.WRITE(PADSTR(lrc_ProducerStatLine2."No.",11));
    //                   END ELSE BEGIN
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatLine2."No.");
    //                   END;

    //                   // Warengruppe
    //                   IF lco_ItemCategoryCode <> '' THEN BEGIN
    //                     lrc_ItemCategory.GET(lco_ItemCategoryCode);
    //                     lfi_ExportFile.WRITE(lrc_ItemCategory.Description);
    //                   END ELSE BEGIN
    //                     lfi_ExportFile.WRITE(' ');
    //                   END;

    //                   // Handelsklasse
    //                   lfi_ExportFile.WRITE(lrc_ProducerStatLine2."Grade of Goods Code");

    //                   // Größe1/Größe2/Größensonderkennzeichen/Größenangaben
    //                   lfi_ExportFile.WRITE(lco_CaliberCode);
    //                   lfi_ExportFile.WRITE(' ');
    //                   lfi_ExportFile.WRITE(' ');
    //                   lfi_ExportFile.WRITE(' ');
    //                   // SCH 002 00000000.e

    //                   // Menge = Gewicht
    //                   lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                     FORMAT(lrc_ProducerStatLine2."Total Net Weight")));

    //                   // Einzelpreis
    //                   lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                                        FORMAT(ROUND(lrc_ProducerStatLine2."Purch. Price (Price Base)",0.0001))));

    //                   // Nettobetrag
    //                   lrc_Currency.InitRoundingPrecision;
    //                   lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(ROUND(lrc_ProducerStatLine2.Amount,
    //                                        lrc_Currency."Amount Rounding Precision"))));

    //                   // Reserviert1
    //                   lfi_ExportFile.WRITE(' ');

    //                   // Anteil Vermarktergebühr/Betrag Vermarktergebühr
    //                   // Prozentsatz holen
    //                   lrc_FeesProducerStat.Reset();
    //                   lrc_FeesProducerStat.SETRANGE("Cost Category Code",lrc_MALSetup."CA Totaling Charge");
    //                   lrc_FeesProducerStat.SETFILTER("Product Group Code",'%1|%2',lrc_ProducerStatLine2."Product Group Code",'');
    //                   lrc_FeesProducerStat.SETFILTER("Item No.",'%1|%2',lrc_ProducerStatLine2."No.",'');
    //                   lrc_FeesProducerStat.SETFILTER("Vendor No.",'%1|%2',lrc_ProducerStatLine2."Producer Companionship Code",'');
    //                   lrc_ProdVendor.GET(vrc_ProducerStatHeader."Producer No.");
    //                   lrc_FeesProducerStat.SETRANGE("Member of Prod. Companionship",lrc_ProdVendor."Member of Prod. Companionship");
    //                   lrc_FeesProducerStat.SETFILTER("Member State Companionship",'%1|%2',
    //                                                  lrc_ProdVendor."Member State Companionship",0);
    //                   IF lrc_FeesProducerStat.FIND('+') THEN BEGIN
    //                     lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(lrc_FeesProducerStat.Value)));

    //                     ldc_PSVGAmount := 0;
    //                     CASE lrc_FeesProducerStat.Typ OF
    //                     lrc_FeesProducerStat.Typ::Percentage:
    //                       BEGIN
    //                         ldc_PSVGAmount := lrc_ProducerStatLine2.Amount * (lrc_FeesProducerStat.Value/100);
    //                       END;
    //                     lrc_FeesProducerStat.Typ::Amount:
    //                       BEGIN
    //                         ldc_PSVGAmount := lrc_FeesProducerStat.Value;
    //                       END;
    //                     END;
    //                   END ELSE BEGIN
    //                     lfi_ExportFile.WRITE(' ');
    //                   END;

    //                   // Reserviert2
    //                   lfi_ExportFile.WRITE(' ');

    //                   // Betrag Vermarktergebühr
    //                   lrc_Currency.InitRoundingPrecision;
    //                   lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                     FORMAT(ROUND(ldc_PSVGAmount,lrc_Currency."Amount Rounding Precision"))));

    //                   // Reserviert3/Reserviert4/Reserviert5/Reserviert6
    //                   lfi_ExportFile.WRITE(' ');
    //                   lfi_ExportFile.WRITE(' ');
    //                   lfi_ExportFile.WRITE(' ');
    //                   lfi_ExportFile.WRITE(' ');
    //                 UNTIL lrc_ProducerStatLine2.NEXT() = 0;
    //               END;

    //               // ------------------------------------------------------------------
    //               // Pfand aus Zeilen addieren und pro Pfandartikel ausgeben
    //               // Zwei Sätze mit Vermarkterleistung und Vermarkterleistung2 ausgeben
    //               // ------------------------------------------------------------------
    //               // -------------------------------------------
    //               // Bestandserhöhend (Vermarkterleistung2 (9%))
    //               // -------------------------------------------
    //               ldc_VL2Amount := 0;
    //               ldc_VL2Quantity := 0;
    //               lrc_ProducerStatLine3.Reset();
    //               lrc_ProducerStatLine3.SETCURRENTKEY(Type,"No.",Subtyp);
    //               lrc_ProducerStatLine3.SETRANGE("Producer Statement No.",lrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine3.SETFILTER("No.",'<>%1','');
    //               lrc_ProducerStatLine3.SETRANGE(Type,lrc_ProducerStatLine3.Type::Item);
    //               lrc_ProducerStatLine3.SETFILTER("Item Typ",'%1|%2',lrc_ProducerStatLine3."Item Typ"::"Packing Material",
    //                                               lrc_ProducerStatLine3."Item Typ"::"Empties Item");

    //               IF lrc_ProducerStatHeader."Document Type" = lrc_ProducerStatHeader."Document Type"::"Prod. Stat." THEN BEGIN
    //                 lrc_ProducerStatLine3.SETFILTER(Quantity,'>%1',0);
    //               END ELSE BEGIN
    //                 lrc_ProducerStatLine3.SETFILTER(Quantity,'<%1',0);
    //               END;

    //               lrc_ProducerStatLine3.SETFILTER(Amount,'<>%1',0);
    //               IF lrc_ProducerStatLine3.FIND('-') THEN BEGIN
    //                 ldc_VL2Amount := 0;
    //                 ldc_VL2Quantity := 0;
    //                 lco_ItemNo := '';
    //                 lco_ItemNo := lrc_ProducerStatLine3."No.";
    //                 REPEAT
    //                   // Summe pro Pfandartikel berechnen und schreiben
    //                   IF lco_ItemNo = lrc_ProducerStatLine3."No." THEN BEGIN
    //                     ldc_VL2Amount += lrc_ProducerStatLine3.Amount;
    //                     ldc_VL2Quantity += lrc_ProducerStatLine3.Quantity;
    //                     lrc_ProducerStatLineXRec := lrc_ProducerStatLine3;
    //                   END ELSE BEGIN
    //                     // --------------------------------------------
    //                     // Werte schreiben, wenn nächster Artikel kommt
    //                     // --------------------------------------------
    //                     // Positionssatzkennung '@PS'
    //                     lfi_ExportFile.WRITE(SSPText003);
    //                     // Vermarkter-Nr./Vermarkter-Erzeuger-Nr./Abrechnungsnr.
    //                     lfi_ExportFile.WRITE(lrc_MALSetup."Prod. Stat. Distributor No.");
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatHeader."Producer No.");
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatHeader."No.");

    //                   // Daten aus Geb. EK-RG Kopf holen
    //                   IF vrc_ProducerStatHeader."Document Type" = vrc_ProducerStatHeader."Document Type"::"Prod. Stat." THEN BEGIN
    //                     lrc_PurchInvHeader.Reset();
    //                     lrc_PurchInvHeader.SETCURRENTKEY("Order No.");
    //                     lrc_PurchInvHeader.SETRANGE("Order No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                     IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                       // Lieferdatum/Lieferschein-Nr.
    //                       lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                       lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                     END ELSE BEGIN
    //                       lrc_PurchInvHeader.Reset();
    //                       lrc_PurchInvHeader.SETCURRENTKEY("Pre-Assigned No.");
    //                       lrc_PurchInvHeader.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                       IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                         // Lieferdatum/Lieferschein-Nr.
    //                         lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                         lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                       END ELSE BEGIN
    //                         lfi_ExportFile.WRITE(' ');
    //                         lfi_ExportFile.WRITE(' ');
    //                       END;
    //                     END;
    //                   END ELSE BEGIN
    //                     lrc_PurchCrMemoHdr.Reset();
    //                     lrc_PurchCrMemoHdr.SETCURRENTKEY("Pre-Assigned No.");
    //                     lrc_PurchCrMemoHdr.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                     IF lrc_PurchCrMemoHdr.FIND('-') THEN BEGIN
    //                       // Lieferdatum/Lieferschein-Nr.
    //                       lfi_ExportFile.WRITE(FORMAT(lrc_PurchCrMemoHdr."Document Date"));
    //                       lfi_ExportFile.WRITE(lrc_PurchCrMemoHdr."Lot No. Producer");
    //                     END ELSE BEGIN
    //                       lfi_ExportFile.WRITE(' ');
    //                       lfi_ExportFile.WRITE(' ');
    //                     END;
    //                   END;

    //                     // Sortenbezeichnung1/Sortenbezeichnung2
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatLineXRec.Description);
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatLineXRec."Description 2");

    //                     // Vermarkter-Sorten-Nr.
    //                     IF MAXSTRLEN(lco_ItemNo) > 11 THEN BEGIN
    //                       lfi_ExportFile.WRITE(PADSTR(lco_ItemNo,11));
    //                     END ELSE BEGIN
    //                       lfi_ExportFile.WRITE(lco_ItemNo);
    //                     END;

    //                     // Warengruppe
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Handelsklasse
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Größe1/Größe2/Größensonderkennzeichen/Größenangaben
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Menge
    //                     lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(ldc_VL2Quantity)));

    //                     // Einzelpreis
    //                     lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                                          FORMAT(ROUND(lrc_ProducerStatLineXRec."Purch. Price (Price Base)",0.0001))));

    //                     // Nettobetrag
    //                     lrc_Currency.InitRoundingPrecision;
    //                     lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                       FORMAT(ROUND(ldc_VL2Amount,lrc_Currency."Amount Rounding Precision"))));

    //                     // Reserviert1
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Anteil Vermarktergebühr
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Reserviert2
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Betrag Vermarktergebühr
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Reserviert3/Reserviert4/Reserviert5/Reserviert6
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');

    //                     // ------------------------------------
    //                     // Werte aus nächstem Artikel übergeben
    //                     // ------------------------------------
    //                     lco_ItemNo := lrc_ProducerStatLine3."No.";
    //                     ldc_VL2Amount := lrc_ProducerStatLine3.Amount;
    //                     ldc_VL2Quantity := lrc_ProducerStatLine3.Quantity;
    //                   END;
    //                 UNTIL lrc_ProducerStatLine3.NEXT() = 0;
    //                 // -----------------------------------
    //                 // Werte für letzten Artikel schreiben
    //                 // -----------------------------------
    //                 // Positionssatzkennung '@PS'
    //                 lfi_ExportFile.WRITE(SSPText003);

    //                 // Vermarkter-Nr./Vermarkter-Erzeuger-Nr./Abrechnungsnr.
    //                 lfi_ExportFile.WRITE(lrc_MALSetup."Prod. Stat. Distributor No.");
    //                 lfi_ExportFile.WRITE(lrc_ProducerStatHeader."Producer No.");
    //                 lfi_ExportFile.WRITE(lrc_ProducerStatHeader."No.");

    //               // Daten aus Geb. EK-RG Kopf holen
    //               IF vrc_ProducerStatHeader."Document Type" = vrc_ProducerStatHeader."Document Type"::"Prod. Stat." THEN BEGIN
    //                 lrc_PurchInvHeader.Reset();
    //                 lrc_PurchInvHeader.SETCURRENTKEY("Order No.");
    //                 lrc_PurchInvHeader.SETRANGE("Order No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                 IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                   // Lieferdatum/Lieferschein-Nr.
    //                   lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                   lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                 END ELSE BEGIN
    //                   lrc_PurchInvHeader.Reset();
    //                   lrc_PurchInvHeader.SETCURRENTKEY("Pre-Assigned No.");
    //                   lrc_PurchInvHeader.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                   IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                     // Lieferdatum/Lieferschein-Nr.
    //                     lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                     lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                   END ELSE BEGIN
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                   END;
    //                 END;
    //               END ELSE BEGIN
    //                 lrc_PurchCrMemoHdr.Reset();
    //                 lrc_PurchCrMemoHdr.SETCURRENTKEY("Pre-Assigned No.");
    //                 lrc_PurchCrMemoHdr.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                 IF lrc_PurchCrMemoHdr.FIND('-') THEN BEGIN
    //                   // Lieferdatum/Lieferschein-Nr.
    //                   lfi_ExportFile.WRITE(FORMAT(lrc_PurchCrMemoHdr."Document Date"));
    //                   lfi_ExportFile.WRITE(lrc_PurchCrMemoHdr."Lot No. Producer");
    //                 END ELSE BEGIN
    //                   lfi_ExportFile.WRITE(' ');
    //                   lfi_ExportFile.WRITE(' ');
    //                 END;
    //               END;

    //                 // Sortenbezeichnung1/Sortenbezeichnung2
    //                 lfi_ExportFile.WRITE(lrc_ProducerStatLine3.Description);
    //                 lfi_ExportFile.WRITE(lrc_ProducerStatLine3."Description 2");

    //                 // Vermarkter-Sorten-Nr.
    //                 IF MAXSTRLEN(lco_ItemNo) > 11 THEN BEGIN
    //                   lfi_ExportFile.WRITE(PADSTR(lco_ItemNo,11));
    //                 END ELSE BEGIN
    //                   lfi_ExportFile.WRITE(lco_ItemNo);
    //                 END;

    //                 // Warengruppe
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Handelsklasse
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Größe1/Größe2/Größensonderkennzeichen/Größenangaben
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Menge
    //                 lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(ldc_VL2Quantity)));

    //                 // Einzelpreis
    //                 lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                                      FORMAT(ROUND(lrc_ProducerStatLine3."Purch. Price (Price Base)",0.0001))));

    //                 // Nettobetrag
    //                 lrc_Currency.InitRoundingPrecision;
    //                 lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                   FORMAT(ROUND(ldc_VL2Amount,lrc_Currency."Amount Rounding Precision"))));

    //                 // Reserviert1
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Anteil Vermarktergebühr
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Reserviert2
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Betrag Vermarktergebühr
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Reserviert3/Reserviert4/Reserviert5/Reserviert6
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //               END;

    //               // ----------------------------------------------
    //               // Bestandservermindernd (Vermarkterleistung 16%)
    //               // ----------------------------------------------
    //               ldc_VL1Amount := 0;
    //               ldc_VL1Quantity := 0;
    //               lrc_ProducerStatLine3.Reset();
    //               lrc_ProducerStatLine3.SETCURRENTKEY(Type,"No.",Subtyp);
    //               lrc_ProducerStatLine3.SETRANGE("Producer Statement No.",lrc_ProducerStatHeader."No.");
    //               lrc_ProducerStatLine3.SETFILTER("No.",'<>%1','');
    //               lrc_ProducerStatLine3.SETRANGE(Type,lrc_ProducerStatLine3.Type::Item);
    //               lrc_ProducerStatLine3.SETFILTER("Item Typ",'%1|%2',lrc_ProducerStatLine3."Item Typ"::"Packing Material",
    //                                               lrc_ProducerStatLine3."Item Typ"::"Empties Item");

    //               IF lrc_ProducerStatHeader."Document Type" = lrc_ProducerStatHeader."Document Type"::"Prod. Stat." THEN BEGIN
    //                 lrc_ProducerStatLine3.SETFILTER(Quantity,'<%1',0);
    //               END ELSE BEGIN
    //                 lrc_ProducerStatLine3.SETFILTER(Quantity,'>%1',0);
    //               END;

    //               lrc_ProducerStatLine3.SETFILTER(Amount,'<>%1',0);
    //               IF lrc_ProducerStatLine3.FIND('-') THEN BEGIN
    //                 ldc_VL1Amount := 0;
    //                 ldc_VL1Quantity := 0;
    //                 lco_ItemNo := '';
    //                 lco_ItemNo := lrc_ProducerStatLine3."No.";
    //                 REPEAT
    //                   // Summe pro Pfandartikel berechnen und schreiben
    //                   IF lco_ItemNo = lrc_ProducerStatLine3."No." THEN BEGIN
    //                     ldc_VL1Amount += lrc_ProducerStatLine3.Amount;
    //                     ldc_VL1Quantity += lrc_ProducerStatLine3.Quantity;
    //                     lrc_ProducerStatLineXRec := lrc_ProducerStatLine3;
    //                   END ELSE BEGIN
    //                     // --------------------------------------------
    //                     // Werte schreiben, wenn nächster Artikel kommt
    //                     // --------------------------------------------
    //                     // Positionssatzkennung '@PS'
    //                     lfi_ExportFile.WRITE(SSPText003);

    //                     // Vermarkter-Nr./Vermarkter-Erzeuger-Nr./Abrechnungsnr.
    //                     lfi_ExportFile.WRITE(lrc_MALSetup."Prod. Stat. Distributor No.");
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatHeader."Producer No.");
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatHeader."No.");

    //                   // Daten aus Geb. EK-RG Kopf holen
    //                   IF vrc_ProducerStatHeader."Document Type" = vrc_ProducerStatHeader."Document Type"::"Prod. Stat." THEN BEGIN
    //                     lrc_PurchInvHeader.Reset();
    //                     lrc_PurchInvHeader.SETCURRENTKEY("Order No.");
    //                     lrc_PurchInvHeader.SETRANGE("Order No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                     IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                     // Lieferdatum/Lieferschein-Nr.
    //                       lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                       lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                     END ELSE BEGIN
    //                       lrc_PurchInvHeader.Reset();
    //                       lrc_PurchInvHeader.SETCURRENTKEY("Pre-Assigned No.");
    //                       lrc_PurchInvHeader.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                       IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                         // Lieferdatum/Lieferschein-Nr.
    //                         lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                         lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                       END ELSE BEGIN
    //                         lfi_ExportFile.WRITE(' ');
    //                         lfi_ExportFile.WRITE(' ');
    //                       END;
    //                     END;
    //                   END ELSE BEGIN
    //                     lrc_PurchCrMemoHdr.Reset();
    //                     lrc_PurchCrMemoHdr.SETCURRENTKEY("Pre-Assigned No.");
    //                     lrc_PurchCrMemoHdr.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                     IF lrc_PurchCrMemoHdr.FIND('-') THEN BEGIN
    //                       // Lieferdatum/Lieferschein-Nr.
    //                       lfi_ExportFile.WRITE(FORMAT(lrc_PurchCrMemoHdr."Document Date"));
    //                       lfi_ExportFile.WRITE(lrc_PurchCrMemoHdr."Lot No. Producer");
    //                     END ELSE BEGIN
    //                       lfi_ExportFile.WRITE(' ');
    //                       lfi_ExportFile.WRITE(' ');
    //                     END;
    //                   END;

    //                     // Sortenbezeichnung1/Sortenbezeichnung2
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatLineXRec.Description);
    //                     lfi_ExportFile.WRITE(lrc_ProducerStatLineXRec."Description 2");

    //                     // Vermarkter-Sorten-Nr.
    //                     // TEST
    //                     lco_ItemNo := '1' + lco_ItemNo;
    //                     IF MAXSTRLEN(lco_ItemNo) > 11 THEN BEGIN
    //                       lfi_ExportFile.WRITE(PADSTR(lco_ItemNo,11));
    //                     END ELSE BEGIN
    //                       lfi_ExportFile.WRITE(lco_ItemNo);
    //                     END;

    //                     // Warengruppe
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Handelsklasse
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Größe1/Größe2/Größensonderkennzeichen/Größenangaben
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Menge
    //                     lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                       FORMAT(ldc_VL1Quantity)));

    //                     // Einzelpreis
    //                     lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                                          FORMAT(ROUND(lrc_ProducerStatLineXRec."Purch. Price (Price Base)",0.0001))));

    //                     // Nettobetrag
    //                     lrc_Currency.InitRoundingPrecision;
    //                     lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                       FORMAT(ROUND(ldc_VL1Amount,lrc_Currency."Amount Rounding Precision"))));

    //                     // Reserviert1
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Anteil Vermarktergebühr
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Reserviert2
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Betrag Vermarktergebühr
    //                     lfi_ExportFile.WRITE(' ');

    //                     // Reserviert3/Reserviert4/Reserviert5/Reserviert6
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');

    //                     // ------------------------------------
    //                     // Werte aus nächstem Artikel übergeben
    //                     // ------------------------------------
    //                     lco_ItemNo := lrc_ProducerStatLine3."No.";
    //                     ldc_VL1Amount := lrc_ProducerStatLine3.Amount;
    //                     ldc_VL1Quantity := lrc_ProducerStatLine3.Quantity;
    //                   END;
    //                 UNTIL lrc_ProducerStatLine3.NEXT() = 0;

    //                 // -----------------------------------
    //                 // Werte für letzten Artikel schreiben
    //                 // -----------------------------------
    //                 // Positionssatzkennung '@PS'
    //                 lfi_ExportFile.WRITE(SSPText003);

    //                 // Vermarkter-Nr./Vermarkter-Erzeuger-Nr./Abrechnungsnr.
    //                 lfi_ExportFile.WRITE(lrc_MALSetup."Prod. Stat. Distributor No.");
    //                 lfi_ExportFile.WRITE(lrc_ProducerStatHeader."Producer No.");
    //                 lfi_ExportFile.WRITE(lrc_ProducerStatHeader."No.");

    //               // Daten aus Geb. EK-RG Kopf holen
    //               IF vrc_ProducerStatHeader."Document Type" = vrc_ProducerStatHeader."Document Type"::"Prod. Stat." THEN BEGIN
    //                 lrc_PurchInvHeader.Reset();
    //                 lrc_PurchInvHeader.SETCURRENTKEY("Order No.");
    //                 lrc_PurchInvHeader.SETRANGE("Order No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                 IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                   // Lieferdatum/Lieferschein-Nr.
    //                   lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                   lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                 END ELSE BEGIN
    //                   lrc_PurchInvHeader.Reset();
    //                   lrc_PurchInvHeader.SETCURRENTKEY("Pre-Assigned No.");
    //                   lrc_PurchInvHeader.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                   IF lrc_PurchInvHeader.FIND('-') THEN BEGIN
    //                     // Lieferdatum/Lieferschein-Nr.
    //                     lfi_ExportFile.WRITE(FORMAT(lrc_PurchInvHeader."Document Date"));
    //                     lfi_ExportFile.WRITE(lrc_PurchInvHeader."Lot No. Producer");
    //                   END ELSE BEGIN
    //                     lfi_ExportFile.WRITE(' ');
    //                     lfi_ExportFile.WRITE(' ');
    //                   END;
    //                 END;
    //               END ELSE BEGIN
    //                 lrc_PurchCrMemoHdr.Reset();
    //                 lrc_PurchCrMemoHdr.SETCURRENTKEY("Pre-Assigned No.");
    //                 lrc_PurchCrMemoHdr.SETRANGE("Pre-Assigned No.",lrc_ProducerStatLine3."Source Purch. Doc. No.");
    //                 IF lrc_PurchCrMemoHdr.FIND('-') THEN BEGIN
    //                   // Lieferdatum/Lieferschein-Nr.
    //                   lfi_ExportFile.WRITE(FORMAT(lrc_PurchCrMemoHdr."Document Date"));
    //                   lfi_ExportFile.WRITE(lrc_PurchCrMemoHdr."Lot No. Producer");
    //                 END ELSE BEGIN
    //                   lfi_ExportFile.WRITE(' ');
    //                   lfi_ExportFile.WRITE(' ');
    //                 END;
    //               END;

    //                 // Sortenbezeichnung1/Sortenbezeichnung2
    //                 lfi_ExportFile.WRITE(lrc_ProducerStatLine3.Description);
    //                 lfi_ExportFile.WRITE(lrc_ProducerStatLine3."Description 2");

    //                 // Vermarkter-Sorten-Nr.
    //                 // TEST
    //                 lco_ItemNo := '1' + lco_ItemNo;

    //                 IF MAXSTRLEN(lco_ItemNo) > 11 THEN BEGIN
    //                   lfi_ExportFile.WRITE(PADSTR(lco_ItemNo,11));
    //                 END ELSE BEGIN
    //                   lfi_ExportFile.WRITE(lco_ItemNo);
    //                 END;

    //                 // Warengruppe
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Handelsklasse
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Größe1/Größe2/Größensonderkennzeichen/Größenangaben
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Menge
    //                 lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(FORMAT(ldc_VL1Quantity)));

    //                 // Einzelpreis
    //                 lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                                      FORMAT(ROUND(lrc_ProducerStatLine3."Purch. Price (Price Base)",0.0001))));

    //                 // Nettobetrag
    //                 lrc_Currency.InitRoundingPrecision;
    //                 lfi_ExportFile.WRITE(lcu_ProducerStatManagement.ErzAbrStringFormatDecimal(
    //                   FORMAT(ROUND(ldc_VL1Amount,lrc_Currency."Amount Rounding Precision"))));

    //                 // Reserviert1
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Anteil Vermarktergebühr
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Reserviert2
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Betrag Vermarktergebühr
    //                 lfi_ExportFile.WRITE(' ');

    //                 // Reserviert3/Reserviert4/Reserviert5/Reserviert6
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //                 lfi_ExportFile.WRITE(' ');
    //               END;
    //             END;

    //             lin_RecNo := lin_RecNo + 1;
    //             ldg_Window.UPDATE(1,ROUND(lin_RecNo / lin_TotalRecNo * 10000,1));

    //             // Status im Kopfsatz setzen
    //             vrc_ProducerStatHeader.Status := vrc_ProducerStatHeader.Status::Reported;
    //             vrc_ProducerStatHeader.Modify();

    //           UNTIL NEXT = 0;
    //           lfi_ExportFile.CLOSE;
    //         END;
    //         // SCH 001 00000000.e
    //     end;

    //     procedure "----- Agiles FNO"()
    //     begin
    //     end;

    //     procedure FNO_CalcQtyOnHand(var vrc_ItemJournalLine: Record "83")
    //     var
    //         lrp_FNOCalcQtyOnHand: Report "52572";
    //     begin
    //         // FNO 001 00000000.s
    //         CLEAR(lrp_FNOCalcQtyOnHand);
    //         lrp_FNOCalcQtyOnHand.SetItemJnlLine( vrc_ItemJournalLine );
    //         lrp_FNOCalcQtyOnHand.RUNMODAL;
    //         CLEAR(lrp_FNOCalcQtyOnHand);
    //         // FNO 001 00000000.e
    //     end;

    //     procedure FNO_ChangeShipmentDateFromPhon(var vrc_PhoneCallListHeader: Record "5110377")
    //     var
    //         lrp_FNOLIDLPhoneListDelDate: Report "52577";
    //     begin
    //         // FNO 001 00000000.s
    //         lrp_FNOLIDLPhoneListDelDate.SETTABLEVIEW( vrc_PhoneCallListHeader );
    //         lrp_FNOLIDLPhoneListDelDate.RUNMODAL;
    //         // FNO 001 00000000.e
    //     end;

    //     procedure FNO_FillPostenverbindung(var vrc_ItemLedgerEntry: Record "32";rin_Level: Integer)
    //     var
    //         lrc_Postenverfolgung: Record "52503";
    //     begin
    //         // FNO 002 00000000.s
    //         // IFW 002 IFW40098.s
    //         // lrc_Postenverfolgung.INIT();
    //         // lrc_Postenverfolgung."Primary Key" := 0;
    //         // lrc_Postenverfolgung."Check for reference" := rin_Level;
    //         // lrc_Postenverfolgung.Postenart := vrc_ItemLedgerEntry."Entry Type";
    //         // lrc_Postenverfolgung.Artikelpostennr := vrc_ItemLedgerEntry."Entry No.";
    //         // lrc_Postenverfolgung.INSERT(TRUE);
    //         // IFW 002 IFW40098.e
    //         // FNO 002 00000000.e
    //     end;

    //     procedure FNO_CallReportPostenverbindung(var vrc_ItemLedgerEntry: Record "32")
    //     var
    //         lrp_FNOPartieverfolgung: Report "52603";
    //     begin
    //         // FNO 002 00000000.s
    //         lrp_FNOPartieverfolgung.SETTABLEVIEW(vrc_ItemLedgerEntry);
    //         lrp_FNOPartieverfolgung.RUNMODAL;
    //         // FNO 002 00000000.e
    //     end;

    //     procedure FNO_CallReportCalcPlanReqWksh(var vrc_RequisitionLine: Record "246")
    //     var
    //         lrp_FNOCalcPlanReqWksh: Report "52547";
    //     begin
    //         // FNO 002 00000000.s
    //         lrp_FNOCalcPlanReqWksh.SetTemplAndWorksheet(vrc_RequisitionLine."Worksheet Template Name",vrc_RequisitionLine."Journal Batch Name"
    //         );
    //         lrp_FNOCalcPlanReqWksh.RUNMODAL;
    //         CLEAR(lrp_FNOCalcPlanReqWksh);
    //         // FNO 002 00000000.e
    //     end;

    //     procedure FNO_ValidateItemReference(var lrc_ItemCrossReference: Record "5717";lin_CurrFieldNo: Integer)
    //     var
    //         lrc_FNOItemReference: Record "52508";
    //         AgilesText001: Label 'Der Wert existiert nicht in der Hinterlegung. Möchten Sie ihn dennoch übernehmen?';
    //     begin
    //         // FV4 001 FV400090.s
    //         lrc_FNOItemReference.Reset();
    //         lrc_FNOItemReference.SETRANGE("Cross-Reference Type", lrc_ItemCrossReference."Cross-Reference Type");
    //         lrc_FNOItemReference.SETRANGE("Cross-Reference Type No.", lrc_ItemCrossReference."Cross-Reference Type No.");
    //         lrc_FNOItemReference.SETRANGE("No.", lrc_ItemCrossReference."Cross-Reference No.");
    //         IF lin_CurrFieldNo = 0 THEN BEGIN
    //           lrc_FNOItemReference.FIND('-');
    //         END ELSE BEGIN
    //           IF NOT lrc_FNOItemReference.FIND('-') THEN
    //             IF NOT CONFIRM(AgilesText001, FALSE) THEN BEGIN
    //               ERROR('');
    //             END;
    //         END;
    //         // FV4 001 FV400090.e
    //     end;

    //     procedure FNO_LookupItemReference(var lrc_ItemCrossReference: Record "5717")
    //     var
    //         lrc_FNOItemReference: Record "52508";
    //     begin
    //         // FV4 001 FV400090.s
    //         lrc_FNOItemReference.Reset();
    //         lrc_FNOItemReference.SETRANGE("Cross-Reference Type", lrc_ItemCrossReference."Cross-Reference Type");
    //         lrc_FNOItemReference.SETRANGE("Cross-Reference Type No.", lrc_ItemCrossReference."Cross-Reference Type No.");
    //         IF lrc_FNOItemReference.FIND('-') THEN BEGIN
    //           IF FORM.RUNMODAL(0, lrc_FNOItemReference) = ACTION::LookupOK THEN BEGIN
    //             lrc_ItemCrossReference.VALIDATE("Cross-Reference No.", lrc_FNOItemReference."No.");
    //           END;
    //         END;
    //         // FV4 001 FV400090.e
    //     end;

    //     procedure "----- Agiles FIDIS"()
    //     begin
    //     end;

    //     procedure ivFDSSetReminderBlock(var vrc_CustLedgerEntry: Record "21")
    //     var
    //         ivZEVKPost: Codeunit "61505";
    //     begin
    //         // FLI 001 FNO00002.s
    //         // --- ivFDS3.10/KF, 21.07.03 --- BEGINN
    //         ivZEVKPost.SetReminderBlock(vrc_CustLedgerEntry);
    //         // --- ivFDS3.10/KF, 21.07.03 --- ENDE
    //         // FLI 001 FNO00002.e
    //     end;

    //     procedure IsFidisActive() lbn_Fidis: Boolean
    //     var
    //         "-- SSP L FLI 001": Integer;
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_FIDISSetup: Record "61500";
    //     begin
    //         // FLI 001 FNO00002.s
    //         lbn_Fidis := FALSE;
    //         lrc_FruitVisionSetup.GET();
    //         // KDK 001 00000000.s
    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'FNO' THEN BEGIN
    //         // KDK 001 00000000.e
    //            IF lrc_FIDISSetup.GET THEN BEGIN
    //              IF lrc_FIDISSetup."FIDIS Recognized" = FALSE THEN
    //                lbn_Fidis := TRUE;
    //            END;
    //         // KDK 001 00000000.s
    //         END;
    //         // KDK 001 00000000.e

    //         EXIT( lbn_Fidis );
    //         // FLI 001 FNO00002.e
    //     end;

    //     procedure ivFormatFIDISAddress(Adr: Text[30];var vrc_Customer: Record "Customer")
    //     var
    //         HausNr: Text[30];
    //         Pos: Integer;
    //         Z: Integer;
    //         Text61500: Label '%1 kann für %2 %3 %4 nicht automatisch generiert werden.\Bearbeiten Sie das Feld %1 manuell.';
    //     begin
    //         // FLI 001 FNO00002.s
    //         // --- ivFDS3.70/KF, 21.07.03 --- BEGINN
    //         Pos := 0;
    //         FOR Z := STRLEN(Adr) DOWNTO 1 DO
    //           IF Adr[Z] IN ['0'..'9'] THEN
    //             Pos := Z;
    //         IF Pos > 1 THEN BEGIN
    //           vrc_Customer."FIDIS Street" := DELCHR(COPYSTR(Adr,1,Pos - 1),'>');
    //           IF STRLEN(COPYSTR(Adr,Pos)) > MAXSTRLEN(vrc_Customer."FIDIS Street No.") THEN
    //             MESSAGE(Text61500,vrc_Customer.FIELDCAPTION("FIDIS Street No."),vrc_Customer.TABLECAPTION,
    //               vrc_Customer.FIELDCAPTION("No."),vrc_Customer."No.")
    //           ELSE
    //             vrc_Customer."FIDIS Street No." := COPYSTR(Adr,Pos);
    //         END ELSE BEGIN
    //           vrc_Customer."FIDIS Street" := Adr;
    //           vrc_Customer."FIDIS Street No." := '';
    //         END;
    //         // --- ivFDS3.70/KF, 21.07.03 --- ENDE
    //         // FLI 001 FNO00002.e
    //     end;

    //     procedure ivFIDISCity(var vrc_Customer: Record "Customer")
    //     var
    //         FIDISSetup: Record "61500";
    //     begin
    //         // FLI 001 FNO00002.s
    //         // --- ivFDS3.70/KF, 21.07.03 --- BEGINN
    //         IF vrc_Customer."Country/Region Code" = '' THEN BEGIN
    //           FIDISSetup.GET();
    //           IF FIDISSetup."Use FIDIS City" THEN
    //             vrc_Customer."FIDIS City" := vrc_Customer.City;
    //         END;
    //         // --- ivFDS3.70/KF, 21.07.03 --- ENDE
    //         // FLI 001 FNO00002.e
    //     end;

    //     procedure ivFIDISPostCode(PostCode2: Code[20];var vrc_Customer: Record "Customer")
    //     var
    //         FIDISSetup: Record "61500";
    //         Pos: Integer;
    //         lrc_PostCode: Record "225";
    //     begin
    //         // FLI 001 FNO00002.s
    //         // --- ivFDS3.70/KF, 21.07.03 --- BEGINN
    //         FIDISSetup.GET();
    //         IF NOT FIDISSetup."Use FIDIS Post Code" THEN
    //           EXIT;

    //         IF FIDISSetup."Use FIDIS City" THEN
    //           IF lrc_PostCode.GET(PostCode2) THEN
    //             vrc_Customer."FIDIS City" := lrc_PostCode.City;

    //         Pos := STRPOS(PostCode2,'-');
    //         IF Pos = 0 THEN
    //           Pos := STRPOS(PostCode2,' ');
    //         IF Pos > 0 THEN
    //           vrc_Customer."FIDIS Post Code" := COPYSTR(PostCode2,Pos + 1,MAXSTRLEN(vrc_Customer."FIDIS Post Code"))
    //         ELSE
    //           vrc_Customer."FIDIS Post Code" := COPYSTR(PostCode2,1,MAXSTRLEN(vrc_Customer."FIDIS Post Code"));
    //         // --- ivFDS3.70/KF, 21.07.03 --- ENDE
    //         // FLI 001 FNO00002.e
    //     end;

    //     procedure RunCodeunit61510(var vrc_ReminderEntry: Record "300")
    //     begin
    //         // FLI 001 FNO00002.s
    //         // --- ivFDS3.70/KF, 21.07.03 --- BEGINN
    //         CODEUNIT.RUN(CODEUNIT::Codeunit61510,vrc_ReminderEntry);
    //         // --- ivFDS3.70/KF, 21.07.03 --- ENDE
    //         // FLI 001 FNO00002.e
    //     end;

    //     procedure Change_FIDISFactoringCustomer(var vrc_Customer: Record "Customer")
    //     var
    //         CustLedgEntry: Record "21";
    //         GenJnlLine: Record "81";
    //         CustCVLedgEntryBuf: Record "382";
    //         FIDISSetup: Record "61500";
    //         ZRELILedgEntry: Record "61510";
    //         ZEVKLedgEntry: Record "61513";
    //         ZEVKApplLedgEntry: Record "61514";
    //         FIDISRemLedgEntry: Record "61517";
    //         GenJnlPostLine: Codeunit "12";
    //         ZRELIPost: Codeunit "61500";
    //         ZEVKPost: Codeunit "61505";
    //         Text61501: Label 'Für %1 %2 sind Factoring-Link-Posten vorhanden.\Es werden für alle offenen Debitorenposten ZEVK Stornoposten erstellt.\\Wollen Sie %3 auf Nein setzen?';
    //         Text61503: Label 'Für %1 %2 werden ab jetzt Factoring-Link-Posten erstellt.';
    //         Text61505: Label 'Für %1 %2 sind offene %3 vorhanden.\\Wollen Sie die offenen %3 als Factoring-Link-Posten erstellen?';
    //         Text61506: Label 'In der %1 ist das Feld %2 auf nein gesetzt.\\Eine Änderung des Feldes %3 hat keine Auswirkung!';
    //         Text61507: Label 'Für %1 %2 sind offene %3 vorhanden.\Wenn die offenen %3 Ihrem Factor-Partner mitgeteilt werden sollen,\müssen hierfür Fact.-Link-Posten erstellt werden.\\Wollen Sie Factoring-Link-Posten erstellen?';
    //     begin
    //         // FLI 001 FNO00002.s
    //         // --- ivFDS3.10.02/KF, 20.03.03 --- BEGINN
    //         // IF Customer."FIDIS Factoring Customer" = xRec."FIDIS Factoring Customer" THEN
    //         //   EXIT;
    //         FIDISSetup.GET();
    //         IF NOT FIDISSetup."Start Posting Executed" OR FIDISSetup."FIDIS Recognized" THEN
    //           EXIT;
    //         IF NOT FIDISSetup."Posting for Fact. Cust. only" THEN BEGIN
    //           MESSAGE(
    //             Text61506,
    //             FIDISSetup.TABLECAPTION,
    //             FIDISSetup.FIELDCAPTION("Posting for Fact. Cust. only"),
    //            vrc_Customer.FIELDCAPTION("FIDIS Factoring Customer"));
    //           EXIT;
    //         END;

    //         ZRELILedgEntry.Reset();
    //         ZRELILedgEntry.SETCURRENTKEY("Customer No.");
    //         ZRELILedgEntry.SETRANGE("Customer No.",vrc_Customer."No.");
    //         ZEVKLedgEntry.Reset();
    //         ZEVKLedgEntry.SETCURRENTKEY("Customer No.");
    //         ZEVKLedgEntry.SETRANGE("Customer No.",vrc_Customer."No.");
    //         ZEVKApplLedgEntry.Reset();
    //         ZEVKApplLedgEntry.SETCURRENTKEY("Customer No.");
    //         ZEVKApplLedgEntry.SETRANGE("Customer No.",vrc_Customer."No.");
    //         FIDISRemLedgEntry.Reset();
    //         FIDISRemLedgEntry.SETCURRENTKEY("Customer No.");
    //         FIDISRemLedgEntry.SETRANGE("Customer No.",vrc_Customer."No.");

    //         IF NOT vrc_Customer."FIDIS Factoring Customer" THEN BEGIN
    //           IF ZRELILedgEntry.FIND('-') OR
    //              ZEVKLedgEntry.FIND('-') OR
    //              ZEVKApplLedgEntry.FIND('-') OR
    //              FIDISRemLedgEntry.FIND('-')
    //           THEN
    //             IF CONFIRM(
    //                  Text61501,
    //                  FALSE,vrc_Customer.TABLECAPTION,vrc_Customer."No.",
    //                  vrc_Customer.FIELDCAPTION("FIDIS Factoring Customer"))
    //             THEN BEGIN
    //               CustLedgEntry.Reset();
    //               CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
    //               CustLedgEntry.SETRANGE("Customer No.",vrc_Customer."No.");
    //               CustLedgEntry.SETRANGE(Open,TRUE);
    //               IF CustLedgEntry.FIND('-') THEN
    //                 REPEAT
    //                   CustLedgEntry.CALCFIELDS("Remaining Amt. (LCY)");
    //                   ZEVKPost.PostCorrection(
    //                     CustLedgEntry,
    //                     CustLedgEntry."Document No.",
    //                     CustLedgEntry."Posting Date",
    //                     CustLedgEntry."Remaining Amt. (LCY)");
    //                 UNTIL CustLedgEntry.NEXT() = 0;
    //             END ELSE
    //               ERROR('');
    //         END ELSE BEGIN
    //           CustLedgEntry.Reset();
    //           CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date","Currency Code");
    //           CustLedgEntry.SETRANGE("Customer No.",vrc_Customer."No.");
    //           CustLedgEntry.SETRANGE(Open,TRUE);
    //           IF CustLedgEntry.FIND('-') THEN
    //             IF CONFIRM(Text61507,TRUE,vrc_Customer.TABLECAPTION,vrc_Customer."No.",CustLedgEntry.TABLECAPTION) THEN BEGIN
    //               vrc_Customer.LOCKTABLE;
    //               vrc_Customer.Modify();
    //               ZRELILedgEntry.DELETEALL();
    //               ZEVKLedgEntry.DELETEALL();
    //               ZEVKApplLedgEntry.DELETEALL();
    //               FIDISRemLedgEntry.DELETEALL();
    //               REPEAT
    //                 CustLedgEntry.CALCFIELDS(Amount,"Remaining Amount","Remaining Amt. (LCY)");
    //                 CASE CustLedgEntry."Document Type" OF
    //                   CustLedgEntry."Document Type"::" ",
    //                   CustLedgEntry."Document Type"::Invoice,
    //                   CustLedgEntry."Document Type"::"Credit Memo",
    //                   CustLedgEntry."Document Type"::"Finance Charge Memo",
    //                   CustLedgEntry."Document Type"::Reminder:
    //                     BEGIN
    //                       ZRELIPost.SetFactor(CustLedgEntry."Remaining Amount" / CustLedgEntry.Amount);
    //                       CustLedgEntry.Amount := CustLedgEntry."Remaining Amount";
    //                       ZRELIPost.RUN(CustLedgEntry);
    //                     END;
    //                   CustLedgEntry."Document Type"::Payment,
    //                   CustLedgEntry."Document Type"::Refund:
    //                     BEGIN
    //                       GenJnlPostLine.TransferCustLedgEntry(CustCVLedgEntryBuf,CustLedgEntry,TRUE);
    //                       CustCVLedgEntryBuf."Original Amount" := CustCVLedgEntryBuf."Remaining Amount";
    //                       CustCVLedgEntryBuf."Original Amt. (LCY)" := CustCVLedgEntryBuf."Remaining Amt. (LCY)";
    //                       GenJnlLine.INIT();
    //                       GenJnlLine."System-Created Entry" := TRUE;
    //                       GenJnlLine."FIDIS Document No." := CustLedgEntry."Document No.";
    //                       ZEVKPost.InitLedgEntry(CustCVLedgEntryBuf,GenJnlLine);
    //                       ZEVKPost.InsertLedgEntry(CustCVLedgEntryBuf,0,0);
    //                     END;
    //                 END;
    //                 IF CustLedgEntry."On Hold" <> '' THEN
    //                   ZEVKPost.SetReminderBlock(CustLedgEntry);
    //                 CLEAR(ZEVKPost);
    //               UNTIL CustLedgEntry.NEXT() = 0;
    //             END;
    //           MESSAGE(Text61503,vrc_Customer.TABLECAPTION,vrc_Customer."No.");
    //         END;
    //         // --- ivFDS3.10.02/KF, 20.03.03 --- ENDE
    //         // FLI 001 FNO00002.e
    //     end;

    //     procedure SetFIDISDocNo(GenJnlLine2: Record "81")
    //     begin
    //         // FLI 001 FNO00002.s
    //         // --- ivFDS3.70/KF, 21.07.03 --- BEGINN
    //         WITH GenJnlLine2 DO BEGIN
    //           Reset();
    //           SETRANGE("Journal Template Name","Journal Template Name");
    //           SETRANGE("Journal Batch Name","Journal Batch Name");
    //           IF FIND('-') THEN
    //             REPEAT
    //               IF "FIDIS Document No." = '' THEN BEGIN
    //                 "FIDIS Document No." := "Document No.";
    //                 Modify();
    //               END;
    //             UNTIL NEXT = 0;
    //         END;
    //         // --- ivFDS3.70/KF, 21.07.03 --- ENDE
    //         // FLI 001 FNO00002.e
    //     end;

    //     procedure "----- Agiles MFL"()
    //     begin
    //     end;

    //     procedure ChangeDateInSalesOrder(var vrc_SalesHeader: Record "36")
    //     var
    //         lrc_GeneralLedgerSetup: Record "98";
    //         UserSetup: Record "91";
    //         AllowPostingFrom: Date;
    //         AllowPostingto: Date;
    //     begin
    //         // MFL 001 00000000.s

    //         IF vrc_SalesHeader."Document Type" <> vrc_SalesHeader."Document Type"::Order THEN BEGIN
    //           EXIT;
    //         END;

    //         IF vrc_SalesHeader.Invoice = TRUE THEN BEGIN

    //           lrc_GeneralLedgerSetup.GET();
    //           IF (lrc_GeneralLedgerSetup."Allow Posting To" <> 0D) AND (lrc_GeneralLedgerSetup."Allow Posting To" <> 0D) THEN BEGIN

    //             // zugesagtes Lieferdatum prüfen
    //             IF (vrc_SalesHeader."Promised Delivery Date" >= lrc_GeneralLedgerSetup."Allow Posting From") AND
    //                (vrc_SalesHeader."Promised Delivery Date" <= lrc_GeneralLedgerSetup."Allow Posting To") THEN BEGIN

    //               // Buchungsdatum prüfen und ggf. ändern
    //               IF vrc_SalesHeader."Posting Date" <> vrc_SalesHeader."Promised Delivery Date" THEN BEGIN
    //                 vrc_SalesHeader.VALIDATE("Posting Date",vrc_SalesHeader."Promised Delivery Date");
    //               END;

    //             END ELSE BEGIN

    //               // Buchungsdatum auf den 1. des aktuellen Monats setzen
    //               IF vrc_SalesHeader."Posting Date" <> DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3)) THEN BEGIN
    //                 IF CONFIRM('Buchungsdatum auf den %1 setzen',FALSE,DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3))) THEN
    //                   vrc_SalesHeader.VALIDATE("Posting Date",DMY2DATE(1,DATE2DMY(WORKDATE,2),DATE2DMY(WORKDATE,3)))

    //             END;

    //             END;

    //           END;

    //           // Belegdatum prüfen ung ggf. ändern
    //           IF vrc_SalesHeader."Document Date" <> WORKDATE THEN BEGIN
    //             vrc_SalesHeader.VALIDATE("Document Date",WORKDATE);
    //           END;

    //         END;
    //         // MFL 001 00000000.e
    //     end;

    //     procedure ChangeDateInSalesOrder_2(var vrc_SalesHeader: Record "36")
    //     var
    //         GLSetup: Record "98";
    //         UserSetup: Record "91";
    //         AllowPostingFrom: Date;
    //         AllowPostingTo: Date;
    //         AGILESText003: Label 'Buchungsdatum auf den %1 setzen?';
    //     begin
    //         //MFL 001 MFL40112.s
    //         vrc_SalesHeader.TESTFIELD("Promised Delivery Date");

    //         AllowPostingFrom := 0D;
    //         AllowPostingTo := 0D;
    //         gdt_PostingDate := vrc_SalesHeader."Promised Delivery Date";

    //         IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
    //           GLSetup.GET();
    //           IF USERID <> '' THEN
    //             IF UserSetup.GET(Userid()) THEN BEGIN
    //               AllowPostingFrom := GLSetup."Allow Posting From";
    //               AllowPostingTo := GLSetup."Allow Posting To";
    //               //IF FORMAT(UserSetup."Add. Allow Posting From Days") <> '' THEN BEGIN
    //               //  AllowPostingFrom := CALCDATE(UserSetup."Add. Allow Posting From Days",AllowPostingFrom);
    //               //END;
    //               //IF FORMAT(UserSetup."Add. Allow Posting to Days") <> '' THEN BEGIN
    //               //  AllowPostingTo := CALCDATE(UserSetup."Add. Allow Posting to Days",AllowPostingTo);
    //               //END;
    //             END;
    //           IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
    //             AllowPostingFrom := GLSetup."Allow Posting From";
    //             AllowPostingTo := GLSetup."Allow Posting To";
    //           END;
    //           IF AllowPostingTo = 0D THEN
    //             AllowPostingTo := 31129999D;
    //         END;

    //         IF (vrc_SalesHeader."Promised Delivery Date" < AllowPostingFrom) THEN
    //           gdt_PostingDate := AllowPostingFrom
    //         ELSE
    //           gdt_PostingDate := vrc_SalesHeader."Promised Delivery Date";

    //         //if (vrc_SalesHeader."Promised Delivery Date" > AllowPostingTo) THEN
    //         //  gdt_PostingDate := AllowPostingFrom
    //         //ELSE
    //         //  gdt_PostingDate := vrc_SalesHeader."Promised Delivery Date";



    //         vrc_SalesHeader.VALIDATE("Posting Date",gdt_PostingDate);

    //         IF vrc_SalesHeader."Document Date" <> TODAY THEN
    //           vrc_SalesHeader.VALIDATE("Document Date",TODAY);
    //         //MFL 002 MFL40112.e
    //     end;

    //     procedure "----- Agiles GME"()
    //     begin
    //     end;

    //     procedure ExportSalesInvIntoPurchInv(var rrc_SalesInvoiceHeader: Record "112")
    //     var
    //         lrc_DocumentsTransferIntern: Record "57002";
    //         lrc_DocumentsTransferExport: Record "57002";
    //         lrc_DocumentsTransferImport: Record "57002";
    //     begin
    //         // GME 001 GME40015.s

    //         // --------------------------------------------------------------------------
    //         // Gebuchte VK Rechnung sollte aus dem importierten VK Auftrag erstellt werden
    //         // --------------------------------------------------------------------------

    //         // Testen, ob die Rechnung Bezug auf importierte EK Bestellung hat
    //         lrc_DocumentsTransferIntern.Reset();
    //         lrc_DocumentsTransferIntern.SETCURRENTKEY( "Target Company Name", "Target Direction" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Source Company Name", COMPANYNAME );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Source Direction", lrc_DocumentsTransferIntern."Source Direction"::"1" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Company Name", COMPANYNAME );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Direction", lrc_DocumentsTransferIntern."Target Direction"::"1" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Document Type",
    //                                                  lrc_DocumentsTransferIntern."Target Document Type"::"1" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Document No.", rrc_SalesInvoiceHeader."Order No." );
    //         IF NOT lrc_DocumentsTransferIntern.FIND( '-' ) THEN BEGIN
    //           EXIT;
    //         END;

    //         // Weitere zusammenhängende Information finden
    //         lrc_DocumentsTransferImport.Reset();
    //         lrc_DocumentsTransferImport.SETCURRENTKEY( "Target Company Name", "Target Direction" );
    //         lrc_DocumentsTransferImport.SETRANGE( "Source Direction", lrc_DocumentsTransferIntern."Source Direction"::"0" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Company Name", COMPANYNAME );
    //         lrc_DocumentsTransferImport.SETRANGE( "Target Direction", lrc_DocumentsTransferIntern."Target Direction"::"0" );
    //         lrc_DocumentsTransferImport.SETRANGE( "Target Document Type",
    //                                                  lrc_DocumentsTransferImport."Target Document Type"::"0" );
    //         lrc_DocumentsTransferImport.SETRANGE( "Target Document No.", lrc_DocumentsTransferIntern."Source Document No." );
    //         IF NOT lrc_DocumentsTransferImport.FIND( '-' ) THEN BEGIN
    //           EXIT;
    //         END;

    //         // Job anlegen
    //         lrc_DocumentsTransferExport."Source Company Name" := COMPANYNAME;
    //         lrc_DocumentsTransferExport."Source Direction" := lrc_DocumentsTransferExport."Source Direction"::"0";
    //         lrc_DocumentsTransferExport."Source Document Type" :=
    //           lrc_DocumentsTransferExport."Source Document Type"::"5";
    //         lrc_DocumentsTransferExport."Source Document No." := rrc_SalesInvoiceHeader."No.";
    //         lrc_DocumentsTransferExport."Source Line No." := 0;
    //         lrc_DocumentsTransferExport."Source Customer/Vendor No." := rrc_SalesInvoiceHeader."Sell-to Customer No.";

    //         lrc_DocumentsTransferExport."Target Company Name" := lrc_DocumentsTransferImport."Source Company Name";
    //         lrc_DocumentsTransferExport."Target Direction" := lrc_DocumentsTransferExport."Target Direction"::"0";
    //         lrc_DocumentsTransferExport."Target Document Type" := lrc_DocumentsTransferExport."Target Document Type"::"2";
    //         lrc_DocumentsTransferExport."Target Document No." := '';
    //         lrc_DocumentsTransferExport."Target Line No." := 0;
    //         lrc_DocumentsTransferExport."Target Customer/Vendor No." := lrc_DocumentsTransferImport."Source Customer/Vendor No.";

    //         lrc_DocumentsTransferExport."Transfer Date" := rrc_SalesInvoiceHeader."Order Date";
    //         lrc_DocumentsTransferExport."Transfer Time" := 0T;

    //         lrc_DocumentsTransferExport.insert();
    //         // GME 001 GME40015.e
    //     end;

    //     procedure ExportSalesInvIntoPurchInv_2(var rrc_SalesInvoiceHeader: Record "112")
    //     var
    //         lrc_DocumentsTransferIntern: Record "57002";
    //         lrc_DocumentsTransferExport: Record "57002";
    //         lrc_DocumentsTransferImport: Record "57002";
    //         lrc_CompanySeason: Record "5110323";
    //         Text001: Label 'The active Company season for %1 not found';
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Gebuchte VK Rechnung sollte aus der VK Rechnung erstellt werden, die
    //         // aus der importierten EK Rechnung erstellt wurde
    //         // --------------------------------------------------------------------------

    //         // GME 001 GME40015.s
    //         // Testen, ob die Rechnung Bezug auf importierte EK Rechnung hat
    //         lrc_DocumentsTransferIntern.Reset();
    //         lrc_DocumentsTransferIntern.SETCURRENTKEY( "Target Company Name", "Target Direction" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Source Company Name", COMPANYNAME );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Source Direction", lrc_DocumentsTransferIntern."Source Direction"::"1" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Source Document Type",
    //                                                  lrc_DocumentsTransferIntern."Source Document Type"::"2" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Company Name", COMPANYNAME );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Direction", lrc_DocumentsTransferIntern."Target Direction"::"1" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Document Type",
    //                                                  lrc_DocumentsTransferIntern."Target Document Type"::"3" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Document No.", rrc_SalesInvoiceHeader."Pre-Assigned No." );
    //         IF NOT lrc_DocumentsTransferIntern.FIND( '-' ) THEN BEGIN
    //           EXIT;
    //         END;

    //         // Weitere Zusammenhänge mit importierter EK Rechnung
    //         lrc_DocumentsTransferImport.Reset();
    //         lrc_DocumentsTransferImport.SETCURRENTKEY( "Target Company Name", "Target Direction" );
    //         lrc_DocumentsTransferImport.SETRANGE( "Source Direction", lrc_DocumentsTransferIntern."Source Direction"::"0" );
    //         lrc_DocumentsTransferIntern.SETRANGE( "Target Company Name", COMPANYNAME );
    //         lrc_DocumentsTransferImport.SETRANGE( "Target Direction", lrc_DocumentsTransferIntern."Target Direction"::"0" );
    //         lrc_DocumentsTransferImport.SETRANGE( "Target Document Type",
    //                                                  lrc_DocumentsTransferImport."Target Document Type"::"2" );
    //         lrc_DocumentsTransferImport.SETRANGE( "Target Document No.", lrc_DocumentsTransferIntern."Source Document No." );
    //         IF NOT lrc_DocumentsTransferImport.FIND( '-' ) THEN BEGIN
    //           EXIT;
    //         END;

    //         // Aktuelle Firmensaison beim Gegenmandant muss vorhanden sein
    //         lrc_CompanySeason.CHANGECOMPANY( lrc_DocumentsTransferImport."Source Company Name" );
    //         lrc_CompanySeason.Reset();
    //         lrc_CompanySeason.SETCURRENTKEY( "Starting Date", "Ending Date" );
    //         lrc_CompanySeason.SETFILTER( "Starting Date", '<=%1', rrc_SalesInvoiceHeader."Document Date" );
    //         lrc_CompanySeason.SETFILTER( "Ending Date", '>=%1|%2', rrc_SalesInvoiceHeader."Document Date", 0D );
    //         IF NOT lrc_CompanySeason.FIND( '-' ) THEN BEGIN
    //           ERROR( STRSUBSTNO( Text001, lrc_DocumentsTransferImport."Source Company Name" ) );
    //         END;

    //         // Job anlegen
    //         lrc_DocumentsTransferExport."Source Company Name" := COMPANYNAME;
    //         lrc_DocumentsTransferExport."Source Direction" := lrc_DocumentsTransferExport."Source Direction"::"0";
    //         lrc_DocumentsTransferExport."Source Document Type" :=
    //           lrc_DocumentsTransferExport."Source Document Type"::"5";
    //         lrc_DocumentsTransferExport."Source Document No." := rrc_SalesInvoiceHeader."No.";
    //         lrc_DocumentsTransferExport."Source Line No." := 0;
    //         lrc_DocumentsTransferExport."Source Customer/Vendor No." := rrc_SalesInvoiceHeader."Sell-to Customer No.";

    //         lrc_DocumentsTransferExport."Target Company Name" := lrc_DocumentsTransferImport."Source Company Name";
    //         lrc_DocumentsTransferExport."Target Direction" := lrc_DocumentsTransferExport."Target Direction"::"0";
    //         lrc_DocumentsTransferExport."Target Document Type" := lrc_DocumentsTransferExport."Target Document Type"::"2";
    //         lrc_DocumentsTransferExport."Target Document No." := '';
    //         lrc_DocumentsTransferExport."Target Line No." := 0;
    //         lrc_DocumentsTransferExport."Target Customer/Vendor No." := lrc_CompanySeason."Vendor Marketing Charge";

    //         lrc_DocumentsTransferExport."Transfer Date" := rrc_SalesInvoiceHeader."Order Date";
    //         lrc_DocumentsTransferExport."Transfer Time" := 0T;

    //         lrc_DocumentsTransferExport.insert();
    //         // GME 001 GME40015.e
    //     end;

    //     procedure SetProducerItemSeasonPrice(var rrc_PurchaseLine: Record "39"): Boolean
    //     var
    //         lrc_ProducerItemPrice: Record "57003";
    //     begin
    //         // GME 001 GME40015.s

    //         // Es muss eine Artikelzeile sein
    //         IF ( rrc_PurchaseLine.Type <> rrc_PurchaseLine.Type::Item ) OR ( rrc_PurchaseLine."No." = '' ) THEN BEGIN
    //           EXIT( FALSE );
    //         END;

    //         // Produzent muss eingegen werden
    //         IF ( rrc_PurchaseLine."Manufacturer Code" = '' ) THEN BEGIN
    //           EXIT( FALSE );
    //         END;

    //         // Preis für Produzent / Startdatum suchen
    //         lrc_ProducerItemPrice.Reset();
    //         lrc_ProducerItemPrice.SETFILTER( "Producer No.", '%1|%2', '', rrc_PurchaseLine."Manufacturer Code" );
    //         lrc_ProducerItemPrice.SETRANGE( "Item No.", rrc_PurchaseLine."No." );
    //         // GME 003 00000000.s
    //         IF rrc_PurchaseLine."Expected Receipt Date" <> 0D THEN BEGIN
    //           lrc_ProducerItemPrice.SETFILTER( "Starting Date", '%1|..%2', 0D, rrc_PurchaseLine."Expected Receipt Date" );
    //         END ELSE BEGIN
    //         // GME 003 00000000.e
    //           lrc_ProducerItemPrice.SETFILTER( "Starting Date", '%1|..%2', 0D, WORKDATE );
    //         // GME 003 00000000.s
    //         END;
    //         // GME 003 00000000.e
    //         IF lrc_ProducerItemPrice.FIND( '+' ) THEN BEGIN
    //           rrc_PurchaseLine."Purch. Price (Price Base)" := lrc_ProducerItemPrice."Purch. Price (Price Base)";
    //           rrc_PurchaseLine."Price Base (Purch. Price)" := lrc_ProducerItemPrice."Price Base (Purch. Price)";
    //           EXIT( TRUE );
    //         END;

    //         EXIT( FALSE );
    //         // GME 001 GME40015.e
    //     end;

    //     procedure ShowProducerItemSeasonPrice(vco_ProducerNo: Code[20])
    //     var
    //         lrc_ProducerItemPrice: Record "57003";
    //     begin
    //         // GME 001 GME40015.s
    //         IF vco_ProducerNo = '' THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_ProducerItemPrice.Reset();
    //         lrc_ProducerItemPrice.SETFILTER( "Producer No.", '%1|%2', vco_ProducerNo, '' );
    //         FORM.RUNMODAL( FORM::Form57023, lrc_ProducerItemPrice );
    //         // GME 001 GME40015.e
    //     end;

    //     procedure SetProducerFilterOnPurchLine(var rrc_PurchaseLine: Record "39";vco_ProducerNo: Code[20])
    //     begin
    //         // GME 002 00000000.s
    //         IF vco_ProducerNo = '' THEN BEGIN
    //           EXIT;
    //         END;

    //         rrc_PurchaseLine.FILTERGROUP( 2 );
    //         rrc_PurchaseLine.SETFILTER( "Manufacturer Code", '%1|%2', vco_ProducerNo, '' );
    //         rrc_PurchaseLine.FILTERGROUP( 0 );
    //         // GME 002 00000000.e
    //     end;

    //     procedure "----- Agiles GFP"()
    //     begin
    //     end;

    //     procedure CalcDueDateForSalesCrMemo(var rrc_SalesHeader: Record "36";vdt_SourcePromisedDeliveryDate: Date)
    //     var
    //         lrc_PaymentTerms: Record "3";
    //     begin
    //         // GFP 001 GFP40080.s
    //         //--------------------------------------------------------------------------------------------------------------------------
    //         // Beim erstellen von Gutschrift aus Reklamationsmeldung für Berechnung von Fälligkeitsdatum wird "Promised Delivery Date"
    //         // aus Ursprungsbeleg als Basis für Berechnung genommen
    //         //--------------------------------------------------------------------------------------------------------------------------
    //         IF ( rrc_SalesHeader."Payment Terms Code" <> '' ) AND ( vdt_SourcePromisedDeliveryDate <> 0D ) THEN BEGIN
    //           lrc_PaymentTerms.GET( rrc_SalesHeader."Payment Terms Code" );
    //           rrc_SalesHeader."Due Date" := CALCDATE( lrc_PaymentTerms."Due Date Calculation", vdt_SourcePromisedDeliveryDate );
    //           rrc_SalesHeader."Pmt. Discount Date" := CALCDATE( lrc_PaymentTerms."Discount Date Calculation", vdt_SourcePromisedDeliveryDate )
    //         ;
    //         END;
    //         // GFP 001 GFP40080.e
    //     end;

    //     procedure GFP_PrintAdvPaymentPostDoc(vco_AdvPayHeaderNo: Code[20])
    //     var
    //         lrp_GFPAdvPaymentPosDoc: Report "59005";
    //         lrc_AdvPayHeader: Record "5110582";
    //     begin
    //         // GFP 002 GFP40096.s
    //         lrc_AdvPayHeader.Reset();
    //         lrc_AdvPayHeader.SETRANGE( "No.", vco_AdvPayHeaderNo );
    //         lrp_GFPAdvPaymentPosDoc.SETTABLEVIEW( lrc_AdvPayHeader );
    //         lrp_GFPAdvPaymentPosDoc.RUNMODAL;
    //         // GFP 002 GFP40096.e
    //     end;

    //     procedure "----- Agiles KHH"()
    //     begin
    //     end;

    //     procedure ExportSalesOrder(vco_OrderNo: Code[20];vco_Typ: Code[10];vbn_OnlyOneExportPossible: Boolean;prc_SelectionPrintDocuments: Record "5110472")
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_ExportDataToMooy: Record "58011";
    //         lCtx0001: Label 'The freight order % 1 was already exported !';
    //         lCtx0002: Label 'The exemption % 1 was already exported !';
    //         lCtx0003: Label 'There exist no sales lines for %1 %2 !';
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_Location: Record "14";
    //         lrc_SalesComment: Record "5110427";
    //         lrc_Country: Record "9";
    //         lrc_UnitOfMeasure: Record "204";
    //         lin_LineNo: Integer;
    //         lin_InfoCounter: Integer;
    //         ltx_Header1: Text[100];
    //         ltx_Header2: Text[100];
    //         ltx_Header3: Text[100];
    //         ltx_Header4: Text[100];
    //         ltx_Header5: Text[100];
    //         lin_LfdNoExportPerDocumentNo: Integer;
    //         lbn_ExportLine: Boolean;
    //         lrc_ShippingAgent: Record "291";
    //         lrc_Caliber: Record "5110304";
    //         lbn_FillComment: Boolean;
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //     begin
    //         // KHH 001 KHH50012.s
    //         IF ( vco_Typ = 'V FA SPED' ) OR ( vco_Typ = 'V FS LAG' ) THEN BEGIN
    //            IF lrc_SalesHeader.GET( lrc_SalesHeader."Document Type"::Order, vco_OrderNo ) THEN BEGIN
    //               lin_LfdNoExportPerDocumentNo := 1;
    //               lrc_ExportDataToMooy.Reset();
    //               lrc_ExportDataToMooy.SETCURRENTKEY( "Order No.","Document Typ","Version Export Per Document No", "Line No.",
    //                                                   "Shipping Agent","Location Code" );
    //               lrc_ExportDataToMooy.SETRANGE( "Order No.", vco_OrderNo );
    //               lrc_ExportDataToMooy.SETRANGE( "Document Typ", vco_Typ );

    //               // Frachtauftrag
    //               IF prc_SelectionPrintDocuments."Print Doc. Code" = 'V FA SPED' THEN BEGIN
    //                 lrc_ExportDataToMooy.SETRANGE("Shipping Agent",prc_SelectionPrintDocuments."Detail Code");
    //               END;

    //               // Freistellung
    //               IF prc_SelectionPrintDocuments."Print Doc. Code" = 'V FS LAG' THEN BEGIN
    //                 lrc_ExportDataToMooy.SETRANGE("Location Code",prc_SelectionPrintDocuments."Detail Code");
    //               END;

    //               IF lrc_ExportDataToMooy.FIND('+') THEN BEGIN
    //                  lin_LfdNoExportPerDocumentNo := lrc_ExportDataToMooy."Version Export Per Document No" + 1;

    //                  // Testing if only one Export is Possible
    //                  IF vbn_OnlyOneExportPossible = TRUE THEN BEGIN
    //                     IF vco_Typ = 'V FA SPED' THEN BEGIN
    //                        ERROR( lCtx0001, vco_OrderNo );
    //                     END ELSE BEGIN
    //                        ERROR( lCtx0002, vco_OrderNo );
    //                     END;
    //                     lin_LfdNoExportPerDocumentNo := 0;
    //                  END;
    //               END;
    //               IF lin_LfdNoExportPerDocumentNo <> 0 THEN BEGIN
    //                   lrc_SalesLine.Reset();
    //                   lrc_SalesLine.SETCURRENTKEY( "Document Type","Document No.","Line No." );
    //                   lrc_SalesLine.SETRANGE( "Document Type", lrc_SalesHeader."Document Type" );
    //                   lrc_SalesLine.SETRANGE( "Document No.", lrc_SalesHeader."No." );
    //                   lrc_SalesLine.SETRANGE( Type, lrc_SalesLine.Type::Item );
    //                   lrc_SalesLine.SETFILTER( "No.", '<>%1', '' );

    //                   // Frachtauftrag
    //                   IF prc_SelectionPrintDocuments."Print Doc. Code" = 'V FA SPED' THEN BEGIN
    //                     lrc_SalesLine.SETRANGE("Shipping Agent Code",prc_SelectionPrintDocuments."Detail Code");
    //                   END;

    //                   // Freistellung
    //                   IF prc_SelectionPrintDocuments."Print Doc. Code" = 'V FS LAG' THEN BEGIN
    //                     lrc_SalesLine.SETRANGE("Location Code",prc_SelectionPrintDocuments."Detail Code");
    //                   END;

    //                   lrc_SalesLine.SETRANGE( Subtyp, lrc_SalesLine.Subtyp::" " );
    //                   IF NOT lrc_SalesLine.FIND('-') THEN BEGIN
    //                      ERROR( lCtx0003, vco_OrderNo );
    //                   END ELSE BEGIN
    //                       lin_LineNo := 0;

    //                       /*
    //                       // 22.10.2004 Es werden keine Kopfdaten extra übergeben
    //                       lin_LineNo := 10000;


    //                       lrc_ExportDataToMooy.INIT();
    //                       lrc_ExportDataToMooy."Order No." := vco_OrderNo;
    //                       lrc_ExportDataToMooy."Document Typ" := vco_Typ;
    //                       lrc_ExportDataToMooy."Version Export Per Document No" := lin_LfdNoExportPerDocumentNo;
    //                       lrc_ExportDataToMooy."Line No." := lin_LineNo;
    //                       lrc_ExportDataToMooy."Shipping Agent" := lrc_SalesLine."Shipping Agent Code";
    //                       lrc_ExportDataToMooy.Truck := lrc_SalesHeader."Means of Transport Code";
    //                       lrc_ExportDataToMooy."Loading Date" := lrc_SalesHeader."Shipment Date";
    //                       lrc_ExportDataToMooy."Delivery Date" := lrc_SalesHeader."Promised Delivery Date";

    //                       IF lrc_ShipmentMethod.GET( lrc_SalesHeader."Shipment Method Code" ) THEN BEGIN
    //                          lrc_ExportDataToMooy."Delivery Terms" := lrc_ShipmentMethod.Description;
    //                       END ELSE BEGIN
    //                          lrc_ExportDataToMooy."Delivery Terms" := lrc_SalesHeader."Shipment Method Code";
    //                       END;
    //                       lrc_ExportDataToMooy."Addition Delivery Terms" := lrc_SalesHeader."Appendix Shipment Method";

    //                       IF lrc_Location.GET( lrc_SalesHeader."Location Code" ) THEN BEGIN
    //                          lrc_ExportDataToMooy."Load Address Name" := lrc_Location.Name;
    //                          lrc_ExportDataToMooy."Load Address Name2" := lrc_Location."Name 2";
    //                          lrc_ExportDataToMooy."Load Address Address" := lrc_Location.Address;
    //                          lrc_ExportDataToMooy."Load Address Address2" := lrc_Location."Address 2";
    //                          lrc_ExportDataToMooy."Load Address Country" := lrc_Location."Country Code";
    //                          lrc_ExportDataToMooy."Load Address PostCode" := lrc_Location."Post Code";
    //                          lrc_ExportDataToMooy."Load Address City" := lrc_Location.City;
    //                       END ELSE BEGIN
    //                          lrc_ExportDataToMooy."Load Address Name" := lrc_SalesLine."Location Code";
    //                       END;

    //                       IF ( lrc_SalesHeader."Ship-to Name" <> '' ) OR
    //                          ( lrc_SalesHeader."Ship-to Name 2" <> '' ) OR
    //                          ( lrc_SalesHeader."Ship-to Address" <> '' ) OR
    //                          ( lrc_SalesHeader."Ship-to Address 2" <> '' ) OR
    //                          ( lrc_SalesHeader."Ship-to City" <> '' ) OR
    //                          ( lrc_SalesHeader."Ship-to Post Code" <> '' ) OR
    //                          ( lrc_SalesHeader."Ship-to Country Code" <> '' ) THEN BEGIN
    //                          lrc_ExportDataToMooy."Reciever Address Name" := lrc_SalesHeader."Ship-to Name";
    //                          lrc_ExportDataToMooy."Reciever Address Name2" := lrc_SalesHeader."Ship-to Name 2";
    //                          lrc_ExportDataToMooy."Reciever Address Address" := lrc_SalesHeader."Ship-to Address";
    //                          lrc_ExportDataToMooy."Reciever Address Address2" := lrc_SalesHeader."Ship-to Address 2";
    //                          lrc_ExportDataToMooy."Reciever Address Country" := lrc_SalesHeader."Ship-to Country Code";
    //                          lrc_ExportDataToMooy."Reciever Address PostCode" := lrc_SalesHeader."Ship-to Post Code" ;
    //                          lrc_ExportDataToMooy."Reciever Address City" := lrc_SalesHeader."Ship-to City";

    //                       END ELSE BEGIN
    //                          lrc_ExportDataToMooy."Reciever Address Name" := lrc_SalesHeader."Sell-to Customer Name";
    //                          lrc_ExportDataToMooy."Reciever Address Name2" := lrc_SalesHeader."Sell-to Customer Name 2";
    //                          lrc_ExportDataToMooy."Reciever Address Address" := lrc_SalesHeader."Sell-to Address";
    //                          lrc_ExportDataToMooy."Reciever Address Address2" := lrc_SalesHeader."Sell-to Address 2";
    //                          lrc_ExportDataToMooy."Reciever Address Country" := lrc_SalesHeader."Sell-to Country Code";
    //                          lrc_ExportDataToMooy."Reciever Address PostCode" := lrc_SalesHeader."Sell-to Post Code";
    //                          lrc_ExportDataToMooy."Reciever Address City" := lrc_SalesHeader."Sell-to City";
    //                       END;

    //                       lrc_ExportDataToMooy."Number Of Pallets" := 0;
    //                       lrc_ExportDataToMooy."Pallet Typ" := '';
    //                       lrc_ExportDataToMooy."Number Of Kolli" := 0;
    //                       lrc_ExportDataToMooy.Packing := '';
    //                       lrc_ExportDataToMooy.Description := '';
    //                       lrc_ExportDataToMooy.Description2 := '';
    //                       lrc_ExportDataToMooy."Country Of Origin" := '';
    //                       lrc_ExportDataToMooy."Grade Of Goods" := '';
    //                       lrc_ExportDataToMooy.Caliber := '';
    //                       lrc_ExportDataToMooy.Trademark := '';
    //                       lrc_ExportDataToMooy.Information1 := '';
    //                       lrc_ExportDataToMooy.Information2 := '';
    //                       lrc_ExportDataToMooy.Positionnumber := '';

    //                       lrc_ExportDataToMooy."Document Date" := lrc_SalesHeader."Document Date";

    //                       */

    //                       REPEAT

    //                          lbn_ExportLine := FALSE;

    //                          IF vco_Typ = 'V FA SPED' THEN BEGIN
    //                             IF lrc_ShippingAgent.GET( lrc_SalesLine."Shipping Agent Code" ) THEN BEGIN
    //                               IF lrc_ShippingAgent."Export Data Mooy" = TRUE THEN BEGIN
    //                                  lbn_ExportLine := TRUE;
    //                               END;
    //                             END;
    //                          END ELSE BEGIN
    //                            IF vco_Typ = 'V FS LAG' THEN BEGIN
    //                               IF lrc_Location.GET( lrc_SalesLine."Location Code" ) THEN BEGIN
    //         //// FELD NICHT MEHR VORHANDEN !!!
    //         ////                         IF lrc_Location."Export Data Mooy" = TRUE THEN BEGIN
    //         ////                            lbn_ExportLine := TRUE;
    //         ////                         END;
    //                               END;
    //                            END;
    //                          END;

    //                          IF lbn_ExportLine = TRUE THEN BEGIN

    //                             lbn_FillComment := FALSE;
    //                             // Kopfzeilen Bemerkungen
    //                             lrc_SalesComment.Reset();
    //                             lrc_SalesComment.SETRANGE( "Entry Type", lrc_SalesComment."Entry Type"::Line );
    //                             lrc_SalesComment.SETFILTER( "Line No.", '<>%1', 0 );
    //                             lrc_SalesComment.SETRANGE( "Document Source", lrc_SalesComment."Document Source"::Header );
    //                             lrc_SalesComment.SETRANGE( "Document Type", lrc_SalesComment."Document Type"::Order );
    //                             lrc_SalesComment.SETRANGE( "Document No.", vco_OrderNo );
    //                             lrc_SalesComment.SETRANGE( "Document Line No.", 0 );
    //                             lrc_SalesComment.SETRANGE( Placement, lrc_SalesComment.Placement::Header );
    //                             IF lrc_SalesComment.FIND('-') THEN BEGIN
    //                                lrc_SalesCommentPrintDoc.Reset();
    //                                lrc_SalesCommentPrintDoc.SETCURRENTKEY( "Sales Comment Entry No.","Print Document Code","Detail Code" );
    //                                lrc_SalesCommentPrintDoc.SETRANGE( "Sales Comment Entry No.", lrc_SalesComment."Entry No." );
    //                                IF vco_Typ = 'V FA SPED' THEN BEGIN
    //                                  lrc_SalesCommentPrintDoc.SETRANGE( "Print Document Code", 'V FA SPED' );
    //                                  lrc_SalesCommentPrintDoc.SETFILTER( "Detail Code", '%1|%2', lrc_SalesLine."Shipping Agent Code", '' );
    //                                END ELSE BEGIN
    //                                  lrc_SalesCommentPrintDoc.SETRANGE( "Print Document Code", 'V FA LAG' );
    //                                  lrc_SalesCommentPrintDoc.SETFILTER( "Detail Code",  '%1|%2', lrc_SalesLine."Location Code", '');
    //                                END;
    //                                IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                                   IF lrc_SalesCommentPrintDoc.Print = FALSE THEN BEGIN
    //                                      lbn_FillComment := TRUE;
    //                                   END;
    //                                END;
    //                             END;
    //                             IF lbn_FillComment = TRUE THEN BEGIN
    //                               lin_InfoCounter := 1;
    //                               IF lrc_SalesComment.FIND('-') THEN BEGIN
    //                                 REPEAT
    //                                   IF lrc_SalesComment.Comment <> '' THEN
    //                                      lin_InfoCounter := lin_InfoCounter + 1;
    //                                   CASE lin_InfoCounter OF
    //                                     1:ltx_Header1 := lrc_SalesComment.Comment;
    //                                     2:ltx_Header2 := lrc_SalesComment.Comment;
    //                                     3:ltx_Header3 := lrc_SalesComment.Comment;
    //                                     4:ltx_Header4 := lrc_SalesComment.Comment;
    //                                     5:ltx_Header5 := lrc_SalesComment.Comment;
    //                                   END;
    //                                 UNTIL ( lrc_SalesComment.NEXT() = 0 ) OR ( lin_InfoCounter >= 5 );
    //                               END;
    //                             END;

    //                             lin_LineNo := lin_LineNo + 10000;

    //                             lrc_ExportDataToMooy.INIT();
    //                             lrc_ExportDataToMooy."Order No." := vco_OrderNo;
    //                             lrc_ExportDataToMooy."Document Typ" := vco_Typ;
    //                             lrc_ExportDataToMooy."Version Export Per Document No" := lin_LfdNoExportPerDocumentNo;
    //                             lrc_ExportDataToMooy."Line No." := lin_LineNo;
    //                             lrc_ExportDataToMooy."Shipping Agent" := lrc_SalesLine."Shipping Agent Code";
    //                             lrc_ExportDataToMooy.Truck := lrc_SalesHeader."Means of Transport Code";
    //                             lrc_ExportDataToMooy."Loading Date" := lrc_SalesHeader."Shipment Date";
    //                             lrc_ExportDataToMooy."Delivery Date" := lrc_SalesHeader."Promised Delivery Date";

    //                             // IF lrc_ShipmentMethod.GET( lrc_SalesHeader."Shipment Method Code" ) THEN BEGIN
    //                             //    lrc_ExportDataToMooy."Delivery Terms" := lrc_ShipmentMethod.Description;
    //                             // END ELSE BEGIN
    //                                lrc_ExportDataToMooy."Delivery Terms" := lrc_SalesHeader."Shipment Method Code";
    //                             // END;
    //                             lrc_ExportDataToMooy."Addition Delivery Terms" := lrc_SalesHeader."Appendix Shipment Method";

    //                             IF lrc_Location.GET( lrc_SalesLine."Location Code" ) THEN BEGIN
    //                                lrc_ExportDataToMooy."Load Address Name" := lrc_Location.Name;
    //                                lrc_ExportDataToMooy."Load Address Name2" := lrc_Location."Name 2";
    //                                lrc_ExportDataToMooy."Load Address Address" := lrc_Location.Address;
    //                                lrc_ExportDataToMooy."Load Address Address2" := lrc_Location."Address 2";
    //                                lrc_ExportDataToMooy."Load Address Country" := lrc_Location."Country/Region Code";
    //                                lrc_ExportDataToMooy."Load Address PostCode" := lrc_Location."Post Code";
    //                                lrc_ExportDataToMooy."Load Address City" := lrc_Location.City;
    //                             END ELSE BEGIN
    //                                lrc_ExportDataToMooy."Load Address Name" := lrc_SalesLine."Location Code";
    //                             END;

    //                             lrc_ExportDataToMooy."Location Code" := lrc_SalesLine."Location Code";

    //                             IF ( lrc_SalesHeader."Ship-to Name" <> '' ) OR
    //                                ( lrc_SalesHeader."Ship-to Name 2" <> '' ) OR
    //                                ( lrc_SalesHeader."Ship-to Address" <> '' ) OR
    //                                ( lrc_SalesHeader."Ship-to Address 2" <> '' ) OR
    //                                ( lrc_SalesHeader."Ship-to City" <> '' ) OR
    //                                ( lrc_SalesHeader."Ship-to Post Code" <> '' ) OR
    //                                ( lrc_SalesHeader."Ship-to Country/Region Code" <> '' ) THEN BEGIN
    //                                lrc_ExportDataToMooy."Reciever Address Name" := lrc_SalesHeader."Ship-to Name";
    //                                lrc_ExportDataToMooy."Reciever Address Name2" := lrc_SalesHeader."Ship-to Name 2";
    //                                lrc_ExportDataToMooy."Reciever Address Address" := lrc_SalesHeader."Ship-to Address";
    //                                lrc_ExportDataToMooy."Reciever Address Address2" := lrc_SalesHeader."Ship-to Address 2";
    //                                lrc_ExportDataToMooy."Reciever Address Country" := lrc_SalesHeader."Ship-to Country/Region Code";
    //                                lrc_ExportDataToMooy."Reciever Address PostCode" := lrc_SalesHeader."Ship-to Post Code" ;
    //                                lrc_ExportDataToMooy."Reciever Address City" := lrc_SalesHeader."Ship-to City";
    //                             END ELSE BEGIN
    //                                lrc_ExportDataToMooy."Reciever Address Name" := lrc_SalesHeader."Sell-to Customer Name";
    //                                lrc_ExportDataToMooy."Reciever Address Name2" := lrc_SalesHeader."Sell-to Customer Name 2";
    //                                lrc_ExportDataToMooy."Reciever Address Address" := lrc_SalesHeader."Sell-to Address";
    //                                lrc_ExportDataToMooy."Reciever Address Address2" := lrc_SalesHeader."Sell-to Address 2";
    //                                lrc_ExportDataToMooy."Reciever Address Country" := lrc_SalesHeader."Sell-to Country/Region Code";
    //                                lrc_ExportDataToMooy."Reciever Address PostCode" := lrc_SalesHeader."Sell-to Post Code";
    //                                lrc_ExportDataToMooy."Reciever Address City" := lrc_SalesHeader."Sell-to City";
    //                             END;

    //                             lrc_ExportDataToMooy."Number Of Pallets" := lrc_SalesLine."Quantity (TU)";

    //                             lrc_UnitOfMeasure.Reset();
    //                             // IF lrc_UnitOfMeasure.GET( lrc_SalesLine."Transport Unit of Measure (TU)" ) THEN BEGIN
    //                             //   lrc_ExportDataToMooy."Pallet Typ" := lrc_UnitOfMeasure.Description;
    //                             // END ELSE BEGIN
    //                                  lrc_ExportDataToMooy."Pallet Typ" := lrc_SalesLine."Transport Unit of Measure (TU)";
    //                             // END;

    //                             IF lrc_SalesLine."Quantity (TU)" = 0 THEN BEGIN
    //                                lrc_ExportDataToMooy."Number Of Kolli" := lrc_SalesLine."Qty. (Unit) per Transp.(TU)";
    //                             END ELSE BEGIN
    //                                lrc_ExportDataToMooy."Number Of Kolli" := lrc_SalesLine."Qty. (Unit) per Transp.(TU)" *
    //                                   lrc_SalesLine."Quantity (TU)";
    //                             END;

    //                             lrc_UnitOfMeasure.Reset();
    //                             IF lrc_UnitOfMeasure.GET( lrc_SalesLine."Unit of Measure Code" ) THEN BEGIN
    //                                lrc_ExportDataToMooy.Packing := lrc_UnitOfMeasure.Description;
    //                             END ELSE BEGIN
    //                                lrc_ExportDataToMooy.Packing := lrc_SalesLine."Unit of Measure Code";
    //                             END;

    //                             lrc_ExportDataToMooy.Description := lrc_SalesLine.Description;
    //                             lrc_ExportDataToMooy.Description2 := lrc_SalesLine."Description 2";

    //                             // lrc_Country.Reset();
    //                             // IF lrc_Country.GET( lrc_SalesLine."Country of Origin Code" ) THEN BEGIN
    //                             //   lrc_ExportDataToMooy."Country Of Origin" := lrc_Country.Name;
    //                             // END ELSE BEGIN
    //                                lrc_ExportDataToMooy."Country Of Origin" := lrc_SalesLine."Country of Origin Code";
    //                             // END;

    //                             lrc_ExportDataToMooy."Grade Of Goods" := lrc_SalesLine."Grade of Goods Code";
    //                             IF lrc_Caliber.GET( lrc_SalesLine."Caliber Code" ) THEN BEGIN
    //                                IF lrc_Caliber.Description <> '' THEN BEGIN
    //                                   lrc_ExportDataToMooy.Caliber := lrc_Caliber.Description;
    //                                END ELSE BEGIN
    //                                   lrc_ExportDataToMooy.Caliber := lrc_SalesLine."Caliber Code";
    //                                END;
    //                             END ELSE BEGIN
    //                                lrc_ExportDataToMooy.Caliber := lrc_SalesLine."Caliber Code";
    //                             END;

    //                             lrc_ExportDataToMooy.Trademark := lrc_SalesLine."Trademark Code";
    //                             lrc_ExportDataToMooy.Information1 := lrc_SalesLine."Info 1";
    //                             lrc_ExportDataToMooy.Information2 := lrc_SalesLine."Info 2";
    //                             lrc_ExportDataToMooy.Positionnumber := lrc_SalesLine."Batch No.";

    //                             lrc_ExportDataToMooy."Document Date" := lrc_SalesHeader."Document Date";
    //                             lrc_ExportDataToMooy."Note1 Header" := ltx_Header1;
    //                             lrc_ExportDataToMooy."Note2 Header" := ltx_Header2;
    //                             lrc_ExportDataToMooy."Note3 Header" := ltx_Header3;
    //                             lrc_ExportDataToMooy."Note4 Header" := ltx_Header4;
    //                             lrc_ExportDataToMooy."Note5 Header" := ltx_Header5;

    //                             // Zeilenbemerkung
    //                             lbn_FillComment := FALSE;

    //                             lrc_SalesComment.Reset();
    //                             lrc_SalesComment.SETRANGE( "Entry Type", lrc_SalesComment."Entry Type"::Line );
    //                             lrc_SalesComment.SETFILTER( "Line No.", '<>%1', 0 );
    //                             lrc_SalesComment.SETRANGE( "Document Source", lrc_SalesComment."Document Source"::Line );
    //                             lrc_SalesComment.SETRANGE( "Document Type", lrc_SalesComment."Document Type"::Order );
    //                             lrc_SalesComment.SETRANGE( "Document No.", vco_OrderNo );
    //                             lrc_SalesComment.SETRANGE( "Document Line No.", lrc_SalesLine."Line No." );
    //                             lrc_SalesComment.SETRANGE( Placement, lrc_SalesComment.Placement::Line );
    //                             IF lrc_SalesComment.FIND('-') THEN BEGIN
    //                                lrc_SalesCommentPrintDoc.Reset();
    //                                lrc_SalesCommentPrintDoc.SETCURRENTKEY( "Sales Comment Entry No.","Print Document Code","Detail Code" );
    //                                lrc_SalesCommentPrintDoc.SETRANGE( "Sales Comment Entry No.", lrc_SalesComment."Entry No." );
    //                                IF vco_Typ = 'V FA SPED' THEN BEGIN
    //                                  lrc_SalesCommentPrintDoc.SETRANGE( "Print Document Code", 'V FA SPED' );
    //                                  lrc_SalesCommentPrintDoc.SETFILTER( "Detail Code", '%1|%2', lrc_SalesLine."Shipping Agent Code", '' );
    //                                END ELSE BEGIN
    //                                  lrc_SalesCommentPrintDoc.SETRANGE( "Print Document Code", 'V FA LAG' );
    //                                  lrc_SalesCommentPrintDoc.SETFILTER( "Detail Code",  '%1|%2', lrc_SalesLine."Location Code", '');
    //                                END;
    //                                IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                                   IF lrc_SalesCommentPrintDoc.Print = FALSE THEN BEGIN
    //                                      lbn_FillComment := TRUE;
    //                                   END;
    //                                END;
    //                             END;
    //                             IF lbn_FillComment = TRUE THEN BEGIN

    //                               lin_InfoCounter := 1;
    //                               IF lrc_SalesComment.FIND('-') THEN BEGIN
    //                                  REPEAT
    //                                      IF lrc_SalesComment.Comment <> '' THEN
    //                                         lin_InfoCounter := lin_InfoCounter + 1;
    //                                      CASE lin_InfoCounter OF
    //                                         1: lrc_ExportDataToMooy."Note1 Line" := lrc_SalesComment.Comment;
    //                                         2: lrc_ExportDataToMooy."Note2 Line" := lrc_SalesComment.Comment;
    //                                         3: lrc_ExportDataToMooy."Note3 Line" := lrc_SalesComment.Comment;
    //                                         4: lrc_ExportDataToMooy."Note4 Line" := lrc_SalesComment.Comment;
    //                                         5: lrc_ExportDataToMooy."Note5 Line" := lrc_SalesComment.Comment;
    //                                      END;
    //                                  UNTIL ( lrc_SalesComment.NEXT() = 0 ) OR ( lin_InfoCounter >= 5 );
    //                               END;
    //                             END;
    //                             lrc_ExportDataToMooy.INSERT( TRUE );
    //                          END;

    //                       UNTIL lrc_SalesLine.NEXT() = 0;

    //                       // gibt es 5.0 nicht mehr lrc_SalesHeader."Last Date Export MOOY" := WORKDATE;
    //                       // gibt es 5.0 nicht mehr lrc_SalesHeader."Last Time Export MOOY" := TIME;
    //                       // gibt es 5.0 nicht mehr lrc_SalesHeader."Last User ID Export MOOY" := USERID;
    //                       // gibt es 5.0 nicht mehr lrc_SalesHeader.Modify();
    //                   END;
    //               END;
    //            END;
    //         END;
    //         // KHH 001 KHH50012.e

    //     end;

    //     procedure ExportAndUploadDateToMooy(pBln_Export: Boolean;pBln_Upload: Boolean)
    //     var
    //         lfm_FTPConnectionTest: Form "5088041";
    //         lrp_ExportFrachtauftragMooy: Report "58028";
    //         lrp_ExportFreistellungenMooy: Report "58027";
    //         lrc_ExportDataToMooy: Record Item;
    //     begin
    //         // KHH 001 KHH50012.s
    //         IF pBln_Export = TRUE THEN BEGIN

    //            lrc_ExportDataToMooy.LOCKTABLE;
    //            lrp_ExportFrachtauftragMooy.USEREQUESTFORM( FALSE );
    //            lrp_ExportFrachtauftragMooy.RUNMODAL;
    //            COMMIT;

    //            lrc_ExportDataToMooy.LOCKTABLE;
    //            lrp_ExportFreistellungenMooy.USEREQUESTFORM( FALSE );
    //            lrp_ExportFreistellungenMooy.RUNMODAL;
    //            COMMIT;

    //         END;

    //         IF pBln_Upload = TRUE THEN BEGIN
    //            CLEAR(lfm_FTPConnectionTest);
    //            lfm_FTPConnectionTest.UploadFiles( FALSE );
    //            CLEAR(lfm_FTPConnectionTest);
    //         END;
    //         // KHH 001 KHH50012.e
    //     end;

    //     procedure DownloadAndImportDataFromMooy(pBln_Download: Boolean;pBln_Import: Boolean)
    //     var
    //         lfm_FTPConnectionTest: Form "5088041";
    //     begin
    //         // KHH 001 KHH50012.s
    //         IF pBln_Download = TRUE THEN BEGIN
    //            CLEAR(lfm_FTPConnectionTest);
    //            lfm_FTPConnectionTest.DownloadFiles( FALSE );
    //            CLEAR(lfm_FTPConnectionTest);
    //         END;
    //         IF pBln_Import = TRUE THEN BEGIN
    //            // derzeit kein Import aktiv lRep_ImportPalletsfromMOOY.USEREQUESTFORM( FALSE );
    //            // derzeit kein Import aktiv lRep_ImportPalletsfromMOOY.RUNMODAL;
    //         END;
    //         // KHH 001 KHH50012.e
    //     end;

    //     procedure CheckDataToMooy(var vrc_SelectionPrintDocuments: Record "5110472";pBln_Message: Boolean): Boolean
    //     var
    //         lRec_SalesHeader: Record "36";
    //         lCtx00001: Label 'Der Verkaufsbeleg %1 %2 existiert nicht !';
    //         lRec_SalesLine: Record "37";
    //         lCtx00002: Label 'There are no sales lines to export !';
    //         lBln_ExportData: Boolean;
    //         lCtx00003: Label 'There are no guilty sales lines to export !';
    //         lRec_FTPSetup: Record "5110610";
    //         lCtx00004: Label 'The interface Mooy is not active !';
    //         lrc_Location: Record "14";
    //         lrc_ShippingAgent: Record "291";
    //     begin
    //         // KDK 002 KHH50012.s
    //         lRec_FTPSetup.GET();
    //         IF lRec_FTPSetup."FTP Mooy Active" = FALSE THEN BEGIN
    //            IF pBln_Message = TRUE THEN BEGIN
    //               MESSAGE(lCtx00004,vrc_SelectionPrintDocuments."Document Type",vrc_SelectionPrintDocuments."Document No.");
    //            END;
    //            EXIT( FALSE );
    //         END;

    //         IF lRec_SalesHeader.GET(vrc_SelectionPrintDocuments."Document Type",vrc_SelectionPrintDocuments."Document No.") THEN BEGIN

    //            lBln_ExportData := FALSE;

    //            lRec_SalesLine.Reset();
    //            lRec_SalesLine.SETRANGE( "Document Type", lRec_SalesHeader."Document Type" );
    //            lRec_SalesLine.SETRANGE( "Document No.", lRec_SalesHeader."No." );
    //            lRec_SalesLine.SETRANGE( Type, lRec_SalesLine.Type::Item );
    //            lRec_SalesLine.SETFILTER( "No.", '<>%1', '' );
    //            lRec_SalesLine.SETRANGE( Subtyp, lRec_SalesLine.Subtyp::" " );
    //            IF NOT lRec_SalesLine.FIND('-') THEN BEGIN
    //               IF pBln_Message = TRUE THEN BEGIN
    //                  MESSAGE(lCtx00002,vrc_SelectionPrintDocuments."Document Type",vrc_SelectionPrintDocuments."Document No.");
    //               END;
    //               EXIT( FALSE );
    //            END;

    //            // Frachtauftrag
    //            IF vrc_SelectionPrintDocuments."Print Doc. Code" = 'V FA SPED' THEN BEGIN
    //              IF lrc_ShippingAgent.GET(vrc_SelectionPrintDocuments."Detail Code") THEN BEGIN
    //                IF lrc_ShippingAgent."Export Data Mooy" = TRUE THEN BEGIN
    //                  lBln_ExportData := TRUE;
    //                END;
    //              END;
    //            END;

    //            // Freistellung
    //            IF vrc_SelectionPrintDocuments."Print Doc. Code" = 'V FS LAG' THEN BEGIN
    //              IF lrc_Location.GET(vrc_SelectionPrintDocuments."Detail Code") THEN BEGIN
    //         //// FELD NICHT MEHR VORHANDEN !!
    //         ////       IF lrc_Location."Export Data Mooy" = TRUE THEN BEGIN
    //         ////         lBln_ExportData := TRUE;
    //         ////       END;
    //              END;
    //            END;

    //            IF lBln_ExportData = FALSE THEN BEGIN
    //               IF pBln_Message = TRUE THEN BEGIN
    //                  MESSAGE( lCtx00003, lrc_ShippingAgent."Ship.-Ag. Vendor No.", lRec_SalesHeader."Shipping Agent Code" );
    //               END;
    //               EXIT( FALSE );
    //            END ELSE BEGIN
    //               EXIT( TRUE );
    //            END;

    //         END ELSE BEGIN
    //            IF pBln_Message = TRUE THEN BEGIN
    //               MESSAGE(lCtx00001,vrc_SelectionPrintDocuments."Document Type",vrc_SelectionPrintDocuments."Document No.");
    //            END;
    //            EXIT( FALSE );
    //         END;
    //         // KDK 002 KHH50012.e
    //     end;

    //     procedure ActivateExportToMooy(var vrc_SelectionPrintDocuments: Record "5110472")
    //     var
    //         lrc_Location: Record "14";
    //         lrc_FHSalesLocationShipAgent: Record "5110549";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_FTPSetup: Record "5110610";
    //     begin
    //         // KDK 002 KHH50012.s
    //         lrc_FTPSetup.GET();
    //         IF lrc_FTPSetup."Parallel Operation Mooy" = TRUE THEN BEGIN
    //            EXIT;
    //         END;

    //         // Frachtauftrag
    //         IF vrc_SelectionPrintDocuments."Print Doc. Code" = 'V FA SPED' THEN BEGIN
    //           IF lrc_ShippingAgent.GET(vrc_SelectionPrintDocuments."Detail Code") THEN BEGIN
    //             IF lrc_ShippingAgent."Export Data Mooy" = TRUE THEN BEGIN
    //               vrc_SelectionPrintDocuments.Release := FALSE;
    //               vrc_SelectionPrintDocuments.MODIFY(TRUE);
    //             END;
    //           END;
    //         END;

    //         // Freistellung
    //         IF vrc_SelectionPrintDocuments."Print Doc. Code" = 'V FS LAG' THEN BEGIN
    //           IF lrc_Location.GET(vrc_SelectionPrintDocuments."Detail Code") THEN BEGIN
    //         //// FELD NICHT MEHR VORHANDEN!
    //         ////    IF lrc_Location."Export Data Mooy" = TRUE THEN BEGIN
    //         ////      vrc_SelectionPrintDocuments.Release := FALSE;
    //         ////      vrc_SelectionPrintDocuments.MODIFY(TRUE);
    //         ////    END;
    //           END;
    //         END;

    //         // KDK 002 KHH50012.e
    //     end;

    //     procedure RefreshNoOfExportsMooy(var vrc_SelectionPrintDocuments: Record "5110472")
    //     var
    //         lrc_ExportDataToMooy: Record "58011";
    //     begin
    //         // KDK 002 KHH50012.s
    //         vrc_SelectionPrintDocuments."Previous Exports To Mooy" := 0;

    //         lrc_ExportDataToMooy.Reset();
    //         lrc_ExportDataToMooy.SETCURRENTKEY("Order No.","Document Typ","Version Export Per Document No","Line No.",
    //                                            "Shipping Agent","Location Code");
    //         lrc_ExportDataToMooy.SETRANGE( "Order No.", vrc_SelectionPrintDocuments."Document No." );
    //         lrc_ExportDataToMooy.SETRANGE( "Document Typ", vrc_SelectionPrintDocuments."Print Doc. Code" );

    //         CASE vrc_SelectionPrintDocuments."Multiple Entry for" OF
    //           vrc_SelectionPrintDocuments."Multiple Entry for"::Location: lrc_ExportDataToMooy.SETRANGE("Location Code",
    //                                                                       vrc_SelectionPrintDocuments."Detail Code");
    //           vrc_SelectionPrintDocuments."Multiple Entry for"::"Shipping Agent": lrc_ExportDataToMooy.SETRANGE("Shipping Agent",
    //                                                                               vrc_SelectionPrintDocuments."Detail Code");
    //         END;

    //         IF lrc_ExportDataToMooy.FIND('-') THEN BEGIN
    //            REPEAT
    //                IF lrc_ExportDataToMooy."Version Export Per Document No" > vrc_SelectionPrintDocuments."Previous Exports To Mooy" THEN
    //         BEGIN
    //                   vrc_SelectionPrintDocuments."Previous Exports To Mooy" := lrc_ExportDataToMooy."Version Export Per Document No";
    //                   vrc_SelectionPrintDocuments.Modify();
    //                END;
    //            UNTIL lrc_ExportDataToMooy.NEXT() = 0;
    //         END;
    //         // KDK 002 KHH50012.e
    //     end;

    //     procedure SetMooyExport(var vrc_SelectionPrintDocuments: Record "5110472")
    //     var
    //         lRep_FillTableExportDataToMooy: Report "58029";
    //         lText_ExportTyp: Option "Frachtauftrag/Freistellung",Frachtauftrag,Freistellung;
    //         lrec_SalesHeader: Record "36";
    //         lFrm_FHSalesPrintouts: Form "5110443";
    //         lrc_FTPSetup: Record "5110610";
    //         lrc_ExportDataToMooy: Record "58011";
    //     begin
    //         // KDK 002 KHH50012.s
    //         RefreshNoOfExportsMooy(vrc_SelectionPrintDocuments);

    //         IF CheckDataToMooy(vrc_SelectionPrintDocuments,FALSE) THEN BEGIN

    //            // ggf. Aktivierung Export
    //            IF vrc_SelectionPrintDocuments."Previous Exports To Mooy" = 0 THEN BEGIN
    //               vrc_SelectionPrintDocuments."Export To Mooy" := TRUE;
    //               vrc_SelectionPrintDocuments.Modify();
    //            END;

    //            // ggf. Deaktivierung Druck
    //            ActivateExportToMooy(vrc_SelectionPrintDocuments);

    //         END;
    //         // KDK 002 KHH50012.e
    //     end;

    //     procedure StartMooyExport(var vop_DocTyp: Option "1","2","3","4","5","6","7","8","9";var vco_DocNo: Code[20])
    //     var
    //         lRep_FillTableExportDataToMooy: Report "58029";
    //         lText_ExportTyp: Option "Frachtauftrag/Freistellung",Frachtauftrag,Freistellung;
    //         lrec_SalesHeader: Record "36";
    //         lFrm_FHSalesPrintouts: Form "5110443";
    //         lrc_FTPSetup: Record "5110610";
    //         lrc_ExportDataToMooy: Record "58011";
    //         lbn_ExportFA: Boolean;
    //         lbn_ExportFS: Boolean;
    //         lrc_SelectionPrintDocuments: Record "5110472";
    //     begin
    //         // KDK 002 KHH50012.s

    //         // Init
    //         lbn_ExportFA := FALSE;
    //         lbn_ExportFS := FALSE;

    //         // Holen für Filter in den Berichten später
    //         lrec_SalesHeader.Reset();
    //         lrec_SalesHeader.SETRANGE("Document Type",vop_DocTyp);
    //         lrec_SalesHeader.SETRANGE("No.",vco_DocNo);


    //         // Exporte suchen (wichtig für Exporttyp unten)
    //         lrc_SelectionPrintDocuments.Reset();
    //         lrc_SelectionPrintDocuments.SETRANGE(Source,lrc_SelectionPrintDocuments.Source::Sales);
    //         lrc_SelectionPrintDocuments.SETRANGE("Posted Document Type", lrc_SelectionPrintDocuments."Posted Document Type"::" ");
    //         lrc_SelectionPrintDocuments.SETRANGE("Document Type",vop_DocTyp);
    //         lrc_SelectionPrintDocuments.SETRANGE("Document No.",vco_DocNo);
    //         lrc_SelectionPrintDocuments.SETRANGE("Print Doc. Code",'V FA SPED');
    //         lrc_SelectionPrintDocuments.SETRANGE("Export To Mooy",TRUE);
    //         IF lrc_SelectionPrintDocuments.FIND('-') THEN BEGIN
    //           REPEAT
    //             lbn_ExportFA := TRUE;

    //             CLEAR( lRep_FillTableExportDataToMooy );
    //             lRep_FillTableExportDataToMooy.SETTABLEVIEW( lrec_SalesHeader );
    //             lRep_FillTableExportDataToMooy.USEREQUESTFORM( FALSE );
    //             lRep_FillTableExportDataToMooy.SetExportType( lText_ExportTyp::Frachtauftrag,lrc_SelectionPrintDocuments );
    //             lRep_FillTableExportDataToMooy.RUN;
    //             CLEAR( lRep_FillTableExportDataToMooy );

    //           UNTIL lrc_SelectionPrintDocuments.NEXT() = 0;
    //         END;

    //         lrc_SelectionPrintDocuments.Reset();
    //         lrc_SelectionPrintDocuments.SETRANGE(Source,lrc_SelectionPrintDocuments.Source::Sales);
    //         lrc_SelectionPrintDocuments.SETRANGE("Posted Document Type", lrc_SelectionPrintDocuments."Posted Document Type"::" ");
    //         lrc_SelectionPrintDocuments.SETRANGE("Document Type",vop_DocTyp);
    //         lrc_SelectionPrintDocuments.SETRANGE("Document No.",vco_DocNo);
    //         lrc_SelectionPrintDocuments.SETRANGE("Print Doc. Code",'V FS LAG');
    //         lrc_SelectionPrintDocuments.SETRANGE("Export To Mooy",TRUE);
    //         IF lrc_SelectionPrintDocuments.FIND('-') THEN BEGIN
    //           REPEAT

    //             lbn_ExportFS := TRUE;

    //             CLEAR( lRep_FillTableExportDataToMooy );
    //             lRep_FillTableExportDataToMooy.SETTABLEVIEW( lrec_SalesHeader );
    //             lRep_FillTableExportDataToMooy.USEREQUESTFORM( FALSE );
    //             lRep_FillTableExportDataToMooy.SetExportType( lText_ExportTyp::Freistellung,lrc_SelectionPrintDocuments );
    //             lRep_FillTableExportDataToMooy.RUN;
    //             CLEAR( lRep_FillTableExportDataToMooy );

    //           UNTIL lrc_SelectionPrintDocuments.NEXT() = 0;
    //         END;

    //         /*
    //         // Start Export
    //         IF ( lbn_ExportFA = TRUE ) AND
    //            ( lbn_ExportFS = TRUE ) THEN BEGIN
    //            CLEAR( lRep_FillTableExportDataToMooy );
    //            lRep_FillTableExportDataToMooy.SETTABLEVIEW( lrec_SalesHeader );
    //            lRep_FillTableExportDataToMooy.USEREQUESTFORM( FALSE );
    //            lRep_FillTableExportDataToMooy.SetExportType( lText_ExportTyp::"Frachtauftrag/Freistellung",lrc_SelectionPrintDocuments );
    //            lRep_FillTableExportDataToMooy.RUN;
    //            CLEAR( lRep_FillTableExportDataToMooy );
    //         END ELSE BEGIN
    //            IF ( lbn_ExportFA = TRUE ) THEN BEGIN
    //               CLEAR( lRep_FillTableExportDataToMooy );
    //               lRep_FillTableExportDataToMooy.SETTABLEVIEW( lrec_SalesHeader );
    //               lRep_FillTableExportDataToMooy.USEREQUESTFORM( FALSE );
    //               lRep_FillTableExportDataToMooy.SetExportType( lText_ExportTyp::Frachtauftrag,lrc_SelectionPrintDocuments );
    //               lRep_FillTableExportDataToMooy.RUN;
    //               CLEAR( lRep_FillTableExportDataToMooy );
    //            END ELSE BEGIN
    //               IF ( lbn_ExportFS = TRUE ) THEN BEGIN
    //                  CLEAR( lRep_FillTableExportDataToMooy );
    //                  lRep_FillTableExportDataToMooy.SETTABLEVIEW( lrec_SalesHeader );
    //                  lRep_FillTableExportDataToMooy.USEREQUESTFORM( FALSE );
    //                  lRep_FillTableExportDataToMooy.SetExportType( lText_ExportTyp::Freistellung,lrc_SelectionPrintDocuments );
    //                  lRep_FillTableExportDataToMooy.RUN;
    //                  CLEAR( lRep_FillTableExportDataToMooy );
    //               END;
    //            END;
    //         END;
    //         */
    //         // KDK 002 KHH50012.e

    //     end;

    procedure SetLotNumber(var lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items")
    var
    //lrc_KHHLotNumber: Record "58015"; //Tabelle nicht vorhanden
    begin
        // IF lrc_PackOrderOutputItems."Expected Receipt Date" <> 0D THEN BEGIN
        //   lrc_KHHLotNumber.SETRANGE(Date, 0D, lrc_PackOrderOutputItems."Expected Receipt Date");
        //   IF lrc_KHHLotNumber.FIND('+') THEN
        //     lrc_PackOrderOutputItems."Lot No." := lrc_KHHLotNumber."Lot Number";
        // END;
    end;

    //     procedure "----- Agiles IFW"()
    //     begin
    //     end;

    //     procedure ExportAndUploadDateToHHLA(vbn_Upload: Boolean;vbn_Export: Boolean)
    //     var
    //         lrc_IFWSetup: Record "60502";
    //         lrc_FileTransferProtocol: Record "5110622";
    //         lrc_IFWInterfaceHHLAWeidner: Record "60501";
    //         lcu_FileTransferProtocolMgt: Codeunit "5110387";
    //         lrp_IFWNA4ExportWeidnerHHLA: Report "60509";
    //     begin
    //         // IFW 001 IFW40007.s
    //         lrc_IFWSetup.GET();
    //         lrc_IFWSetup.TESTFIELD("File Transfer Protocol Code");
    //         lrc_FileTransferProtocol.GET(lrc_IFWSetup."File Transfer Protocol Code");

    //         IF vbn_Export = TRUE THEN BEGIN
    //            lrc_IFWInterfaceHHLAWeidner.LOCKTABLE;
    //            lrp_IFWNA4ExportWeidnerHHLA.USEREQUESTFORM(FALSE);
    //            lrp_IFWNA4ExportWeidnerHHLA.RUNMODAL;
    //            COMMIT;
    //         END;

    //         IF vbn_Upload = TRUE THEN BEGIN
    //            lcu_FileTransferProtocolMgt.UploadFiles(FALSE,lrc_FileTransferProtocol);
    //         END;
    //         // IFW 001 IFW40007.e
    //     end;

    //     procedure DownloadAndImportDataFromHHLA(vbn_Download: Boolean;vbn_Import: Boolean)
    //     var
    //         lrc_IFWSetup: Record "60502";
    //         lrc_FileTransferProtocol: Record "5110622";
    //         lcu_FileTransferProtocolMgt: Codeunit "5110387";
    //         lrp_IFWNE4ImportHHLAWeidner: Report "60503";
    //     begin
    //         // IFW 001 IFW40007.s
    //         lrc_IFWSetup.GET();
    //         lrc_IFWSetup.TESTFIELD("File Transfer Protocol Code");
    //         lrc_FileTransferProtocol.GET(lrc_IFWSetup."File Transfer Protocol Code");

    //         IF vbn_Download = TRUE THEN BEGIN
    //            lcu_FileTransferProtocolMgt.DownloadFiles(FALSE,lrc_FileTransferProtocol);
    //         END;

    //         IF vbn_Import = TRUE THEN BEGIN
    //            lrp_IFWNE4ImportHHLAWeidner.USEREQUESTFORM(FALSE);
    //            lrp_IFWNE4ImportHHLAWeidner.RUNMODAL;
    //         END;
    //         // IFW 001 IFW40007.e
    //     end;

    //     procedure SetCustomInAllSalesLines(var rrc_SalesHeader: Record "36")
    //     var
    //         lrc_SalesLine: Record "37";
    //         lrc_IFWTransformations: Record "60507";
    //     begin
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",rrc_SalesHeader."No.");
    //         lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN
    //           REPEAT

    //             // auf Kombination prüfen
    //             lrc_IFWTransformations.Reset();
    //             lrc_IFWTransformations.SETRANGE(Type,lrc_IFWTransformations.Type::"0");
    //             lrc_IFWTransformations.SETFILTER("Combination Value 1",'%1|%2',rrc_SalesHeader."Shipment Method Code",'');
    //             lrc_IFWTransformations.SETFILTER("Combination Value 2",'%1|%2',lrc_SalesLine."Gen. Bus. Posting Group",'');
    //             IF lrc_IFWTransformations.FIND('+') THEN BEGIN
    //               lrc_SalesLine."Kind Customs Clearance" := lrc_IFWTransformations."Kind Customs Clearance";
    //             END ELSE BEGIN
    //               lrc_SalesLine."Kind Customs Clearance" := lrc_SalesLine."Kind Customs Clearance"::"0";
    //             END;

    //             lrc_SalesLine.Modify();

    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    // procedure ExtCustomerGrEntry(vco_CustomerNo: Code[20]; vco_CustomerGroupCode: Code[20]; vco_xRecCustomerGroupCode: Code[20]; vbn_DeleteAllForCustNo: Boolean)
    // var
    //     lrc_IFWExtCustGroupAssignm: Record "60518";
    // begin
    //     IF (vco_CustomerNo = '') THEN
    //         EXIT;

    //     // Alle Einträge löschen
    //     IF vbn_DeleteAllForCustNo THEN BEGIN
    //         lrc_IFWExtCustGroupAssignm.RESET();
    //         lrc_IFWExtCustGroupAssignm.SETRANGE("Customer No.", vco_CustomerNo);
    //         IF NOT lrc_IFWExtCustGroupAssignm.ISEMPTY() THEN
    //             lrc_IFWExtCustGroupAssignm.DELETEALL();
    //         EXIT;
    //     END;

    //     // ggf. Datensatz ändern
    //     IF (vco_CustomerGroupCode <> '') AND (vco_xRecCustomerGroupCode <> '') AND
    //        (vco_CustomerGroupCode <> vco_xRecCustomerGroupCode) THEN
    //         IF lrc_IFWExtCustGroupAssignm.GET(vco_CustomerNo, vco_xRecCustomerGroupCode) THEN BEGIN
    //             lrc_IFWExtCustGroupAssignm.DELETE();
    //             IF NOT lrc_IFWExtCustGroupAssignm.GET(vco_CustomerNo, vco_CustomerGroupCode) THEN BEGIN
    //                 lrc_IFWExtCustGroupAssignm.INIT();
    //                 lrc_IFWExtCustGroupAssignm."Customer No." := vco_CustomerNo;
    //                 lrc_IFWExtCustGroupAssignm."Customer Group Code" := vco_CustomerGroupCode;
    //                 lrc_IFWExtCustGroupAssignm.INSERT();
    //             END;
    //         END;

    //     // ggf. Datensatz löschen
    //     IF (vco_CustomerGroupCode = '') AND (vco_xRecCustomerGroupCode <> '') THEN
    //         IF lrc_IFWExtCustGroupAssignm.GET(vco_CustomerNo, vco_xRecCustomerGroupCode) THEN
    //             lrc_IFWExtCustGroupAssignm.DELETE();

    //     // ggf. Datensatz einfügen
    //     IF vco_CustomerGroupCode <> '' THEN
    //         IF NOT lrc_IFWExtCustGroupAssignm.GET(vco_CustomerNo, vco_CustomerGroupCode) THEN BEGIN
    //             lrc_IFWExtCustGroupAssignm.INIT();
    //             lrc_IFWExtCustGroupAssignm."Customer No." := vco_CustomerNo;
    //             lrc_IFWExtCustGroupAssignm."Customer Group Code" := vco_CustomerGroupCode;
    //             lrc_IFWExtCustGroupAssignm.INSERT();
    //         END;
    // end;


    //     procedure LAL_CallReportCalcPlanReqWksh(var vrc_RequisitionLine: Record "246")
    //     var
    //         lrp_FNOCalcPlanReqWksh: Report "5110507";
    //     begin
    //         // FNO 002 00000000.s
    //         lrp_FNOCalcPlanReqWksh.SetTemplAndWorksheet(vrc_RequisitionLine."Worksheet Template Name",
    //                                                     vrc_RequisitionLine."Journal Batch Name");
    //         lrp_FNOCalcPlanReqWksh.RUNMODAL;
    //         CLEAR(lrp_FNOCalcPlanReqWksh);
    //         // FNO 002 00000000.e
    //     end;

    //     procedure SalesPostedArchiveWarehouseman(lop_InsertType: Option PostedDocument,Archiv;lrc_SalesHeader: Record "36";lco_InvHeaderNo: Code[20];lco_CreditMemoHeaderNo: Code[20];lco_ShipHeaderNo: Code[20])
    //     var
    //         lrc_LALSalesOrderWarehouseman: Record "56500";
    //     begin
    //         // FV4 001 FV400090.s
    //         lrc_LALSalesOrderWarehouseman.SalesPostedArchiveWarehouseman(0, lrc_SalesHeader,
    //                                       lco_InvHeaderNo, lco_CreditMemoHeaderNo, lco_ShipHeaderNo);
    //         // FV4 001 FV400090.e
    //     end;

    //     procedure "----- Agiles DMG"()
    //     begin
    //     end;

    //     procedure BatchVariantReturnOrder(var vrc_BatchVariant: Record "5110366")
    //     var
    //         lrc_BarchVarReturnOrderLine: Record "64000";
    //         lrc_Batch: Record "5110365";
    //     begin
    //         //DMG 001 DMG50002.s
    //         lrc_BarchVarReturnOrderLine.SETRANGE("Batch Var. Pos.",vrc_BatchVariant."No.");
    //         FORM.RUN(0,lrc_BarchVarReturnOrderLine);
    //         //DMG 001 DMG50002.s
    //     end;

    //     procedure DrilldownlBatchVarRetOrder(var vrc_BatchVariant: Record "5110366")
    //     var
    //         lrc_BarchVarReturnOrderLine: Record "64000";
    //         lrc_Batch: Record "5110365";
    //         lfm_BatchReturnOrderLine: Form "64003";
    //     begin
    //         //DMG 001 DMG50002.s
    //         lrc_BarchVarReturnOrderLine.SETRANGE("Batch Var. Pos.",vrc_BatchVariant."No.");
    //         lfm_BatchReturnOrderLine.EDITABLE := FALSE;
    //         lfm_BatchReturnOrderLine.SETTABLEVIEW(lrc_BarchVarReturnOrderLine);
    //         lfm_BatchReturnOrderLine.RUNMODAL;
    //         //DMG 001 DMG50002.s
    //     end;

    //     procedure SetApproval(lrc_SalesHeader: Record "36")
    //     var
    //         lcu_DMGApprovals: Codeunit "64000";
    //     begin
    //         // DMG 002 DMG50008.s
    //         lcu_DMGApprovals.SetApproval(lrc_SalesHeader);
    //         // DMG 002 DMG50008.e
    //     end;

    //     procedure TestApproval(lrc_SalesHeader: Record "36"): Boolean
    //     var
    //         lcu_DMGApprovals: Codeunit "64000";
    //     begin
    //         // DMG 002 DMG50008.s
    //         EXIT(lcu_DMGApprovals.TestApproval(lrc_SalesHeader));
    //         // DMG 002 DMG50008.e
    //     end;

    //     procedure CopyApproval(lrc_SalesHeader: Record "36";lop_DocumentType: Option Invoice,"Credit Memo";lco_DocumentNo: Code[20])
    //     var
    //         lcu_DMGApprovals: Codeunit "64000";
    //     begin
    //         // DMG 002 DMG50008.s
    //         lcu_DMGApprovals.CopyApproval(lrc_SalesHeader, lop_DocumentType, lco_DocumentNo);
    //         // DMG 002 DMG50008.e
    //     end;

    //     procedure TestGuarShelfLifeFromSalseLine(var rrc_SalesLine: Record "37")
    //     var
    //         ldt_ShipmentDate: Date;
    //         lrc_SalesHeader: Record "36";
    //     begin
    //         // DMG 003 DMG50017.s
    //         IF rrc_SalesLine."Batch Variant No." = '' THEN BEGIN
    //           EXIT;
    //         END;

    //         ldt_ShipmentDate := rrc_SalesLine."Shipment Date";
    //         IF ldt_ShipmentDate = 0D THEN BEGIN
    //           IF lrc_SalesHeader.GET(rrc_SalesLine."Document Type",rrc_SalesLine."Document No.") THEN BEGIN
    //             ldt_ShipmentDate := lrc_SalesHeader."Shipment Date";
    //           END;
    //         END;

    //         IF ldt_ShipmentDate = 0D THEN BEGIN
    //           ldt_ShipmentDate := WORKDATE;
    //         END;

    //         TestGuaranteedShelfLife(rrc_SalesLine."Batch Variant No.",ldt_ShipmentDate,rrc_SalesLine."Sell-to Customer No.");
    //         // DMG 003 DMG50017.e
    //     end;

    procedure TestGuarShelfLifeFromVarDetail(var rrc_BatchVariantDetail: Record "POI Batch Variant Detail")
    var
        lrc_SalesLine: Record "Sales Line";
        lrc_SalesHeader: Record "Sales Header";
        ldt_ShipmentDate: Date;
    begin
        IF (rrc_BatchVariantDetail.Source = rrc_BatchVariantDetail.Source::Sales) AND
           (rrc_BatchVariantDetail."Source Type" = rrc_BatchVariantDetail."Source Type"::Order) THEN BEGIN

            lrc_SalesLine.GET(lrc_SalesLine."Document Type"::Order, rrc_BatchVariantDetail."Source No.",
                              rrc_BatchVariantDetail."Source Line No.");

            ldt_ShipmentDate := lrc_SalesLine."Shipment Date";
            IF ldt_ShipmentDate = 0D THEN
                IF lrc_SalesHeader.GET(lrc_SalesLine."Document Type", lrc_SalesLine."Document No.") THEN
                    ldt_ShipmentDate := lrc_SalesHeader."Shipment Date";



            IF ldt_ShipmentDate = 0D THEN
                ldt_ShipmentDate := WORKDATE();

            // TestGuaranteedShelfLife(rrc_BatchVariantDetail."Batch Variant No.", ldt_ShipmentDate, lrc_SalesLine."Sell-to Customer No."); //TODO: prüfen
        END;

    end;

    // local procedure TestGuaranteedShelfLife(vco_BatchVariantNo: Code[20]; vdt_ShipmentDate: Date; vco_CustomerNo: Code[20])
    // var
    //     lrc_Item: Record Item;

    //     //lrc_DMGCustomerItem: Record "64005"; //TODO: Customer DMG Item
    //     lrc_BatchVariant: Record "POI Batch Variant";
    //     ldf_GuaranteedShelfLife: DateFormula;
    //     Text002Txt: Label 'The ''Date of Expiry'' from Batch.-Var. %1 will be exceed', Comment = '%1';
    //     Text001Txt: Label 'The ''Guaranteed Shelf Life'' from Batch.-Var. %1 will be exceed', Comment = '%1';

    // begin

    //     lrc_BatchVariant.GET(vco_BatchVariantNo);
    //     IF lrc_Item.GET(lrc_BatchVariant."Item No.") THEN
    //         IF lrc_Item."POI Date of Expiry Mandatory" <> lrc_Item."POI Date of Expiry Mandatory"::" " THEN
    //             lrc_BatchVariant.TESTFIELD("Date of Expiry");

    //     IF lrc_BatchVariant."Date of Expiry" = 0D THEN
    //         EXIT;

    //     // IF lrc_DMGCustomerItem.GET(vco_CustomerNo, lrc_BatchVariant."Item No.") THEN //TODO: DMG Customer
    //     //     ldf_GuaranteedShelfLife := lrc_DMGCustomerItem."Guaranteed Shelf Life"
    //     // ELSE
    //     //     ldf_GuaranteedShelfLife := lrc_BatchVariant."Guaranteed Shelf Life";


    //     IF vdt_ShipmentDate > lrc_BatchVariant."Date of Expiry" THEN
    //         ERROR(Text002Txt, vco_BatchVariantNo);

    //     IF CALCDATE(ldf_GuaranteedShelfLife, vdt_ShipmentDate) > lrc_BatchVariant."Date of Expiry" THEN
    //         ERROR(Text001Txt, vco_BatchVariantNo);

    // end;

    //     procedure TestEditTransferOrder(var rrc_TransferHeaderRec: Record "5740";var rrc_TransferHeaderXRec: Record "5740")
    //     var
    //         lrc_DMGSetup: Record "64006";
    //         Text001: Label 'Transfer Doc. Subtype %1 is for the Requisition assigned.\The transfer order cann''t be edited.';
    //         Text002: Label 'Transfer Doc. Subtype %1 is for the Requisition assigned\and cann''t be seted manual.';
    //     begin
    //         // DMG 003 DMG50018.s
    //         lrc_DMGSetup.GET();
    //         IF lrc_DMGSetup."Requisition Transf. Doc. Subt." = '' THEN BEGIN
    //           EXIT;
    //         END;

    //         IF (rrc_TransferHeaderXRec."Transfer Doc. Subtype Code" <> lrc_DMGSetup."Requisition Transf. Doc. Subt.") AND
    //            (rrc_TransferHeaderRec."Transfer Doc. Subtype Code" <> lrc_DMGSetup."Requisition Transf. Doc. Subt.") THEN BEGIN
    //           EXIT;
    //         END;

    //         IF (rrc_TransferHeaderXRec."Transfer Doc. Subtype Code" <> lrc_DMGSetup."Requisition Transf. Doc. Subt.") AND
    //            (rrc_TransferHeaderRec."Transfer Doc. Subtype Code" = lrc_DMGSetup."Requisition Transf. Doc. Subt.") THEN BEGIN
    //           ERROR(Text002);
    //         END;

    //         ERROR(Text001);
    //         // DMG 003 DMG50017.e
    //     end;

    //     procedure DeleteSWAPLines(var rrc_PurchaseLine: Record "39")
    //     var
    //         lrc_DMGSWAPPurchaseLine: Record "64012";
    //     begin
    //         // DMG 004 DMG50031.s
    //         IF (rrc_PurchaseLine."Document No." = '') OR (rrc_PurchaseLine."Line No." = 0) THEN BEGIN
    //           EXIT;
    //         END;
    //         IF (rrc_PurchaseLine.Type <> rrc_PurchaseLine.Type::Item) THEN BEGIN
    //           EXIT;
    //         END;
    //         IF (rrc_PurchaseLine."No." = '') THEN BEGIN
    //           EXIT;
    //         END;
    //         lrc_DMGSWAPPurchaseLine.Reset();
    //         lrc_DMGSWAPPurchaseLine.SETRANGE("Document Type",rrc_PurchaseLine."Document Type");
    //         lrc_DMGSWAPPurchaseLine.SETRANGE("Document No.",rrc_PurchaseLine."Document No.");
    //         lrc_DMGSWAPPurchaseLine.SETRANGE("Documet Line No.",rrc_PurchaseLine."Line No.");
    //         lrc_DMGSWAPPurchaseLine.DELETEALL();
    //         // DMG 004 DMG50031.e
    //     end;

    //     procedure DeleteSalesPalletInfoLines(var rrc_SalesLine: Record "37")
    //     var
    //         lrc_DMGDocumentPalletInfo: Record "64022";
    //     begin
    //         // DMG 010 DMG50062.s
    //         IF (rrc_SalesLine."Document No." = '') OR (rrc_SalesLine."Line No." = 0) THEN BEGIN
    //           EXIT;
    //         END;
    //         IF (rrc_SalesLine.Type <> rrc_SalesLine.Type::Item) THEN BEGIN
    //           EXIT;
    //         END;
    //         IF (rrc_SalesLine."No." = '') THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_DMGDocumentPalletInfo.Reset();
    //         lrc_DMGDocumentPalletInfo.SETRANGE(lrc_DMGDocumentPalletInfo.Type,lrc_DMGDocumentPalletInfo.Type::"1");
    //         lrc_DMGDocumentPalletInfo.SETRANGE(lrc_DMGDocumentPalletInfo."Document Type",lrc_DMGDocumentPalletInfo."Document Type"::"1");
    //         lrc_DMGDocumentPalletInfo.SETRANGE("Document No.",rrc_SalesLine."Document No.");
    //         lrc_DMGDocumentPalletInfo.SETRANGE("Document Line No.",rrc_SalesLine."Line No.");
    //         lrc_DMGDocumentPalletInfo.DELETEALL();
    //         // DMG 010 DMG50062.e
    //     end;

    //     procedure DeleteTransferPalletInfoLines(var rrc_TransferLine: Record "5741")
    //     var
    //         lrc_DMGDocumentPalletInfo: Record "64022";
    //     begin
    //         // DMG 010 DMG50062.s
    //         IF (rrc_TransferLine."Document No." = '') OR (rrc_TransferLine."Line No." = 0) THEN BEGIN
    //           EXIT;
    //         END;
    //         IF (rrc_TransferLine."Item No." = '') THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_DMGDocumentPalletInfo.Reset();
    //         lrc_DMGDocumentPalletInfo.SETRANGE(lrc_DMGDocumentPalletInfo.Type,lrc_DMGDocumentPalletInfo.Type::"2");
    //         lrc_DMGDocumentPalletInfo.SETRANGE(lrc_DMGDocumentPalletInfo."Document Type",lrc_DMGDocumentPalletInfo."Document Type"::"1");
    //         lrc_DMGDocumentPalletInfo.SETRANGE("Document No.",rrc_TransferLine."Document No.");
    //         lrc_DMGDocumentPalletInfo.SETRANGE("Document Line No.",rrc_TransferLine."Line No.");
    //         lrc_DMGDocumentPalletInfo.DELETEALL();
    //         // DMG 010 DMG50062.e
    //     end;

    //     procedure DeleteSalesDocAssignment(var rrc_SalesHeader: Record "36")
    //     var
    //         lrc_DMGDocumentAssignment: Record "64024";
    //     begin
    //         // DMG 011 DMG50075.s
    //         // aktuelle Einträge löschen
    //         lrc_DMGDocumentAssignment.Reset();
    //         lrc_DMGDocumentAssignment.SETRANGE("Source Type",lrc_DMGDocumentAssignment."Source Type"::"0");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document No.",rrc_SalesHeader."No.");
    //         IF NOT lrc_DMGDocumentAssignment.isempty()THEN BEGIN
    //           lrc_DMGDocumentAssignment.DELETEALL();
    //         END;

    //         // Einträge mit dieser Nr. löschen
    //         lrc_DMGDocumentAssignment.Reset();
    //         lrc_DMGDocumentAssignment.SETRANGE("Source Type",lrc_DMGDocumentAssignment."Source Type"::"0");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //         lrc_DMGDocumentAssignment.SETRANGE("Assignment No.",rrc_SalesHeader."No.");
    //         IF NOT lrc_DMGDocumentAssignment.isempty()THEN BEGIN
    //           lrc_DMGDocumentAssignment.DELETEALL();
    //         END;
    //         // DMG 011 DMG50075.e
    //     end;

    //     procedure DeletePurchDocAssignment(var rrc_PurchaseHeader: Record "38")
    //     var
    //         lrc_DMGDocumentAssignment: Record "64024";
    //     begin
    //         // DMG 011 DMG50075.s
    //         // aktuelle Einträge löschen
    //         lrc_DMGDocumentAssignment.Reset();
    //         lrc_DMGDocumentAssignment.SETRANGE("Source Type",lrc_DMGDocumentAssignment."Source Type"::"1");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document Type",rrc_PurchaseHeader."Document Type");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document No.",rrc_PurchaseHeader."No.");
    //         IF NOT lrc_DMGDocumentAssignment.isempty()THEN BEGIN
    //           lrc_DMGDocumentAssignment.DELETEALL();
    //         END;

    //         // Einträge mit dieser Nr. löschen
    //         lrc_DMGDocumentAssignment.Reset();
    //         lrc_DMGDocumentAssignment.SETRANGE("Source Type",lrc_DMGDocumentAssignment."Source Type"::"1");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document Type",rrc_PurchaseHeader."Document Type");
    //         lrc_DMGDocumentAssignment.SETRANGE("Assignment No.",rrc_PurchaseHeader."No.");
    //         IF NOT lrc_DMGDocumentAssignment.isempty()THEN BEGIN
    //           lrc_DMGDocumentAssignment.DELETEALL();
    //         END;
    //         // DMG 011 DMG50075.e
    //     end;

    //     procedure CheckAssignment(var rrc_SalesHeader: Record "36")
    //     var
    //         lrc_DMGDocumentAssignment: Record "64024";
    //         lrc_SalesHeader: Record "36";
    //     begin
    //         // DMG 012 DMG50075.s
    //         // Prüfung auf zugeordnete Aufträge
    //         lrc_DMGDocumentAssignment.Reset();
    //         lrc_DMGDocumentAssignment.SETRANGE("Source Type",lrc_DMGDocumentAssignment."Source Type"::"0");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document No.",rrc_SalesHeader."No.");
    //         IF NOT lrc_DMGDocumentAssignment.isempty()THEN BEGIN
    //           CalcSalesFreightCostAssignment(rrc_SalesHeader);
    //         END ELSE BEGIN
    //           // Prüfung auf Hauptauftrag
    //           lrc_DMGDocumentAssignment.Reset();
    //           lrc_DMGDocumentAssignment.SETCURRENTKEY("Assignment No.");
    //           lrc_DMGDocumentAssignment.SETRANGE("Source Type",lrc_DMGDocumentAssignment."Source Type"::"0");
    //           lrc_DMGDocumentAssignment.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //           lrc_DMGDocumentAssignment.SETRANGE("Assignment No.",rrc_SalesHeader."No.");
    //           IF lrc_DMGDocumentAssignment.FIND('-') THEN BEGIN
    //             lrc_SalesHeader.GET(lrc_DMGDocumentAssignment."Document Type",lrc_DMGDocumentAssignment."Document No.");
    //             CalcSalesFreightCostAssignment(lrc_SalesHeader);
    //           END;
    //         END;
    //         // DMG 012 DMG50075.e
    //     end;

    //     procedure CalcSalesFreightCostAssignment(var rrc_SalesHeader: Record "36")
    //     var
    //         lrc_DMGDocumentAssignment: Record "64024";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesLineTemp: Record "37" temporary;
    //         lrc_SalesLineTempFreightAmount: Record "37" temporary;
    //         lrc_SalesFreightCosts: Record "5110549";
    //         lrc_SalesFreightCostsTemp: Record "5110549" temporary;
    //         lrc_SalesFreightCostsAssign: Record "5110549";
    //         lrc_ShipAgentDepRegLoc: Record "5110404";
    //         lrc_Location: Record "14";
    //         lcu_FreightManagement: Codeunit "5110313";
    //         ldc_TotalQtyPallets: Decimal;
    //         ldc_TotalFreightAmount: Decimal;
    //         ldc_TotalFreightAmountCheck: Decimal;
    //         ldc_FreightAmount: Decimal;
    //         ldc_DifferenceAmount: Decimal;
    //         lbn_NewLines: Boolean;
    //         AGILESText001: Label 'Lageort';
    //         AGILESText002: Label 'Rundungsdifferenz Fracht';
    //     begin
    //         // DMG 012 DMG50075.s
    //         // Prüfung auf Zuordnungen
    //         ldc_TotalQtyPallets := 0;
    //         ldc_TotalFreightAmount := 0;
    //         lbn_NewLines := FALSE;
    //         lrc_DMGDocumentAssignment.Reset();
    //         lrc_DMGDocumentAssignment.SETRANGE("Source Type",lrc_DMGDocumentAssignment."Source Type"::"0");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //         lrc_DMGDocumentAssignment.SETRANGE("Document No.",rrc_SalesHeader."No.");
    //         IF lrc_DMGDocumentAssignment.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Frachten für alle angehängen Dokumente berechnen
    //             lrc_SalesHeader.GET(lrc_DMGDocumentAssignment."Document Type",lrc_DMGDocumentAssignment."Assignment No.");
    //             lcu_FreightManagement.SalesFreightCostsPerOrder(lrc_SalesHeader);

    //             // Frachttabelle abfragen
    //             lrc_SalesFreightCosts.Reset();
    //             lrc_SalesFreightCosts.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //             lrc_SalesFreightCosts.SETRANGE("Doc. No.",lrc_SalesHeader."No.");
    //             lrc_SalesFreightCosts.SETRANGE(Type,lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //             IF lrc_SalesFreightCosts.FIND('-') THEN BEGIN
    //               REPEAT

    //                 lbn_NewLines := TRUE;

    //                 lrc_SalesFreightCosts.CALCFIELDS("Qty. of Freight Units (SDF)",
    //                                                  "Qty. of Colli (SD)",
    //                                                  "Qty. of Pallets (SD)",
    //                                                  "Gross Weight (SD)",
    //                                                  "Net Weight (SD)",
    //                                                  "Gross Weight (SDF)",
    //                                                  "Net Weight (SDF)");

    //                 // Pufferzeile in Hauptauftrag anlegen
    //                 lrc_SalesLine.Reset();
    //                 lrc_SalesLine.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //                 lrc_SalesLine.SETRANGE("Document No.",rrc_SalesHeader."No.");
    //                 IF lrc_SalesLine.FIND('+') THEN BEGIN
    //                   lrc_SalesLine.INIT();
    //                   lrc_SalesLine."Line No." := lrc_SalesLine."Line No." + 10000;
    //                 END ELSE BEGIN
    //                   lrc_SalesLine.INIT();
    //                   lrc_SalesLine."Line No." := 10000;
    //                 END;

    //                 lrc_SalesLine.insert();

    //                 // wichtige Merkmale ergänzen
    //                 lrc_SalesLine.Type := lrc_SalesLine.Type::Item;
    //                 lrc_SalesLine."Shipping Agent Code" := lrc_SalesFreightCosts."Shipping Agent Code";
    //                 lrc_SalesLine."Departure Region Code" := lrc_SalesFreightCosts."Departure Region Code";
    //                 lrc_SalesLine."Freight Unit of Measure (FU)" := lrc_SalesFreightCosts."Freight Unit Code";
    //                 lrc_SalesLine."Reference Freight Costs" := lrc_SalesFreightCosts."Freight Cost Tariff Base";

    //                 // Mengen- und Gewichtsdaten
    //                 lrc_SalesLine.Quantity := lrc_SalesFreightCosts."Qty. of Colli (SD)";
    //                 lrc_SalesLine."Quantity (TU)" := lrc_SalesFreightCosts."Qty. of Pallets (SD)";
    //                 lrc_SalesLine."Total Net Weight" := lrc_SalesFreightCosts."Net Weight (SD)";
    //                 lrc_SalesLine."Total Gross Weight" := lrc_SalesFreightCosts."Gross Weight (SD)";

    //                 // einen passenden Lagerort eintragen für die automatische Ermittlung des Abgangsregion
    //                 lrc_ShipAgentDepRegLoc.Reset();
    //                 lrc_ShipAgentDepRegLoc.SETRANGE("Departure Region Code",lrc_SalesLine."Departure Region Code");
    //                 lrc_ShipAgentDepRegLoc.SETFILTER("Shipping Agent Code",'%1|%2','',lrc_SalesLine."Shipping Agent Code");
    //                 IF lrc_ShipAgentDepRegLoc.FIND('+') THEN BEGIN
    //                   IF NOT lrc_Location.GET(lrc_ShipAgentDepRegLoc."Location Code") THEN BEGIN
    //                     lrc_ShipAgentDepRegLoc.FIELDERROR(lrc_ShipAgentDepRegLoc."Location Code");
    //                   END;
    //                   lrc_SalesLine."Location Code" := lrc_ShipAgentDepRegLoc."Location Code";
    //                 END;

    //                 // Herkunftsdokument speichern
    //                 lrc_SalesLine."No." := lrc_DMGDocumentAssignment."Assignment No.";

    //                 lrc_SalesLine.Modify();

    //                 // temporär speichern
    //                 lrc_SalesLineTemp := lrc_SalesLine;
    //                 lrc_SalesLineTemp.insert();

    //               UNTIL lrc_SalesFreightCosts.NEXT() = 0;
    //             END;

    //           UNTIL lrc_DMGDocumentAssignment.NEXT() = 0;

    //           IF lbn_NewLines THEN BEGIN

    //             // Manuellhaken auf NEIN, damit die Frachten danach erst einmal berechnet werden können
    //             lrc_SalesFreightCosts.Reset();
    //             lrc_SalesFreightCosts.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //             lrc_SalesFreightCosts.SETRANGE("Doc. No.",rrc_SalesHeader."No.");
    //             lrc_SalesFreightCosts.SETRANGE(Type,lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //             IF lrc_SalesFreightCosts.FIND('-') THEN BEGIN
    //               lrc_SalesFreightCosts.MODIFYALL("Freight Cost Manual Entered",FALSE,TRUE);
    //             END;

    //             // Kalkulation des Hauptauftrags (jetzt sind die neu angelegten Zeilen aus den zugeordneten Aufträgen mit dabei)
    //             lcu_FreightManagement.SalesFreightCostsPerOrder(rrc_SalesHeader);

    //             // Frachtwerte auf die Auftäge aufteilen
    //             lrc_SalesFreightCosts.Reset();
    //             lrc_SalesFreightCosts.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //             lrc_SalesFreightCosts.SETRANGE("Doc. No.",rrc_SalesHeader."No.");
    //             lrc_SalesFreightCosts.SETRANGE(Type,lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //             IF lrc_SalesFreightCosts.FIND('-') THEN BEGIN
    //               REPEAT

    //                 ldc_FreightAmount := 0;

    //                 // Gesamtwert speichern, zur späteren Kontrolle
    //                 ldc_TotalFreightAmount := lrc_SalesFreightCosts."Freight Costs Amount (LCY)";

    //                 // berechnete Werte aus den Zeilen holen
    //                 lrc_SalesLine.Reset();
    //                 lrc_SalesLine.SETRANGE("Document Type",lrc_SalesFreightCosts."Document Type");
    //                 lrc_SalesLine.SETRANGE("Document No.",lrc_SalesFreightCosts."Doc. No.");
    //                 lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //                 lrc_SalesLine.SETRANGE("Item Typ",lrc_SalesLine."Item Typ"::"Trade Item");
    //                 lrc_SalesLine.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //                 lrc_SalesLine.SETRANGE("Departure Region Code",lrc_SalesFreightCosts."Departure Region Code");
    //                 IF lrc_SalesFreightCosts."Freight Unit Code" <> '' THEN BEGIN
    //                   lrc_SalesLine.SETRANGE("Freight Unit of Measure (FU)",lrc_SalesFreightCosts."Freight Unit Code");
    //                 END ELSE BEGIN
    //                   lrc_SalesLine.SETFILTER(Subtyp, '<>%1', lrc_SalesLine.Subtyp::" ");
    //                 END;
    //                 IF lrc_SalesLine.FIND('-') THEN BEGIN
    //                   REPEAT

    //                     // nur aus dem Hauptbeleg erstellte Zeilen verarbeiten
    //                     IF NOT lrc_SalesLineTemp.GET(lrc_SalesLine."Document Type",
    //                                                  lrc_SalesLine."Document No.",lrc_SalesLine."Line No.") THEN BEGIN
    //                       ldc_FreightAmount := ldc_FreightAmount + lrc_SalesLine."Freight Costs Amount (LCY)";
    //                     END ELSE BEGIN

    //                       // generierte Zeilen aus den zugeordneten Aufträgen verarbeiten
    //                       // Frachtzeile aus zugeordneten Auftrag holen
    //                       lrc_SalesFreightCostsAssign.GET(lrc_SalesLine."Document Type",
    //                                                       lrc_SalesLine."No.",
    //                                                       lrc_SalesFreightCostsAssign.Type::"Sped.+AbgReg.+Frachteinheit",
    //                                                       '',
    //                                                       '',
    //                                                       lrc_SalesLine."Departure Region Code",
    //                                                       lrc_SalesLine."Shipping Agent Code",
    //                                                       lrc_SalesLine."Freight Unit of Measure (FU)");

    //                       // Betrag zuweisen und auf manuell setzen
    //                       lrc_SalesFreightCostsAssign.VALIDATE("Freight Costs Amount (LCY)",lrc_SalesLine."Freight Costs Amount (LCY)");

    //                       // Prüfen, ob die zugeordneten Aufträge auch einen Frachtbetrag erhalten haben
    //                       IF lrc_SalesFreightCostsAssign."Freight Costs Amount (LCY)" < 0 THEN BEGIN
    //                         lrc_SalesFreightCostsAssign.TESTFIELD("Freight Costs Amount (LCY)",
    //                                                               lrc_SalesFreightCostsAssign."Freight Costs Amount (LCY)");
    //                       END;

    //                       lrc_SalesFreightCostsAssign.VALIDATE("Freight Cost Manual Entered",TRUE);
    //                       lrc_SalesFreightCostsAssign.MODIFY(TRUE);

    //                     END;

    //                     // Prüfsumme speichern, falls es Rundungsdifferenzen gibt
    //                     ldc_TotalFreightAmountCheck := ldc_TotalFreightAmountCheck + lrc_SalesLine."Freight Costs Amount (LCY)";

    //                   UNTIL lrc_SalesLine.NEXT() = 0;
    //                 END;

    //                 // Rundungsdifferenzen ermitteln und dem Hauptauftrag zuweisen
    //                 ldc_DifferenceAmount := ldc_TotalFreightAmount - ldc_TotalFreightAmountCheck;

    //                 IF ROUND( ldc_DifferenceAmount, 0.00001 ) <> 0 THEN BEGIN
    //                   MESSAGE(AGILESText002, FORMAT(ldc_DifferenceAmount));
    //                 END;

    //                 // Frachtbetrag für Hauptauftrag zuweisen
    //                 lrc_SalesFreightCosts.VALIDATE("Freight Costs Amount (LCY)",ldc_FreightAmount - ldc_DifferenceAmount);
    //                 lrc_SalesFreightCosts.VALIDATE("Freight Cost Manual Entered",TRUE);
    //                 lrc_SalesFreightCosts.MODIFY(TRUE);

    //                 // Gesamtmenge Paletten speichern
    //                 lrc_SalesFreightCosts.CALCFIELDS("Qty. of Pallets (SD)");
    //                 ldc_TotalQtyPallets := ldc_TotalQtyPallets + lrc_SalesFreightCosts."Qty. of Pallets (SD)";

    //               UNTIL lrc_SalesFreightCosts.NEXT() = 0;
    //             END;

    //             // Pufferzeilen wieder löschen
    //             lrc_SalesLineTemp.Reset();
    //             lrc_SalesLineTemp.FIND('-');
    //             REPEAT
    //               lrc_SalesLine.GET(lrc_SalesLineTemp."Document Type",lrc_SalesLineTemp."Document No.",lrc_SalesLineTemp."Line No.");
    //               lrc_SalesLine.DELETE();
    //             UNTIL lrc_SalesLineTemp.NEXT() = 0;

    //           END;
    //         END;
    //         // DMG 012 DMG50075.e
    //     end;

    //     procedure SetFilterBatchVarOnSalesLine(var rrc_SalesLine: Record "37";var rrc_BatchVariant: Record "5110366")
    //     begin
    //         // DMG 013 DMG50079.s
    //         // Filter auf Batch Variant setzen abhängig von den Werten in Sales Line
    //         IF rrc_SalesLine."Country of Origin Code" <> '' THEN BEGIN
    //           rrc_BatchVariant.SETRANGE("Country of Origin Code",rrc_SalesLine."Country of Origin Code");
    //         END;
    //         // DMG 013 DMG50079.e
    //     end;

    //     procedure ValidCountrOfOriginInSalesLine(var rrc_SalesLine: Record "37")
    //     var
    //         lrc_BatchVarDetail: Record "5110487";
    //         AGILESText001: Label 'Trere are Batch Var. Detail assignments. Do you want to delete it?';
    //     begin
    //         // DMG 013 DMG50079.s
    //         // Prüfen, ob die Änderung des Feldes "Country of Origin Code" in Sales Line erlaubt ist
    //         // Wenn das Feld "Country of Origin Code" auf leer geändert wird, dann werden die evtl. vorhandene Zuordnung bleiben

    //         // Wenn noch keine Zuordnung vorhanden ist
    //         IF (rrc_SalesLine."Batch Var. Detail ID" = 0) OR (rrc_SalesLine."Country of Origin Code" = '') THEN BEGIN
    //           EXIT;
    //         END;

    //         // Prüfen, ob die Menge in Details schon zugewiesen ist
    //         lrc_BatchVarDetail.Reset();
    //         lrc_BatchVarDetail.SETRANGE("Entry No.",rrc_SalesLine."Batch Var. Detail ID");
    //         lrc_BatchVarDetail.SETFILTER(Quantity,'<>%1',0);
    //         IF NOT lrc_BatchVarDetail.isempty()THEN BEGIN
    //           // Wenn mindestens eine Zuordnung vorhanden ist, nur nach Bestätigung alle Detailszeilen löschen
    //           IF CONFIRM(AGILESText001) THEN BEGIN
    //             lrc_BatchVarDetail.SETRANGE(Quantity);
    //             lrc_BatchVarDetail.DELETEALL(TRUE);
    //           END ELSE BEGIN
    //             ERROR('');
    //           END;
    //         END ELSE BEGIN
    //           // Wenn keine Zuordnung vorhanden ist, alle Detailszeilen löschen
    //           lrc_BatchVarDetail.SETRANGE(Quantity);
    //           IF NOT lrc_BatchVarDetail.isempty()THEN BEGIN
    //             lrc_BatchVarDetail.DELETEALL(TRUE);
    //           END;
    //         END;
    //         // DMG 013 DMG50079.e
    //     end;

    //     procedure UpdateTransferPalletInfoLines(var rrc_TransferLine: Record "5741")
    //     var
    //         lrc_DMGDocumentPalletInfo: Record "64022";
    //     begin
    //         // DMG 015 DMG50057.s
    //         lrc_DMGDocumentPalletInfo.Reset();
    //         lrc_DMGDocumentPalletInfo.SETRANGE(lrc_DMGDocumentPalletInfo.Type,lrc_DMGDocumentPalletInfo.Type::"2");
    //         lrc_DMGDocumentPalletInfo.SETRANGE(lrc_DMGDocumentPalletInfo."Document Type",lrc_DMGDocumentPalletInfo."Document Type"::"1");
    //         lrc_DMGDocumentPalletInfo.SETRANGE("Document No.",rrc_TransferLine."Document No.");
    //         lrc_DMGDocumentPalletInfo.SETRANGE("Document Line No.",rrc_TransferLine."Line No.");
    //         lrc_DMGDocumentPalletInfo.SETRANGE(Posted,FALSE);
    //         IF NOT lrc_DMGDocumentPalletInfo.isempty()THEN BEGIN
    //           lrc_DMGDocumentPalletInfo.MODIFYALL(lrc_DMGDocumentPalletInfo.Posted,TRUE);
    //           lrc_DMGDocumentPalletInfo.MODIFYALL("Posted With Quantity",rrc_TransferLine."Qty. to Receive");
    //         END;
    //         // DMG 015 DMG50057.e
    //     end;

    //     procedure ActualBUIDateFields(var rrc_BUIItemStatisticEntry: Record "5110579")
    //     var
    //         lrc_DMGWeekSchedule: Record "64020";
    //         lin_DMGYear: Integer;
    //         lin_DMGMonth: Integer;
    //         lin_DMGWeek: Integer;
    //         lin_DMGCalendarWeek: Integer;
    //         lin_DMGQuarter: Integer;
    //         ldt_FirstDayDispositionWeek: Date;
    //         lcu_PositionPlanning: Codeunit "5110345";
    //         lin_CalendarYear: Integer;
    //         lin_CalendarMonth: Integer;
    //         lin_CalendarWeek: Integer;
    //         lin_CalendarCalendarWeek: Integer;
    //         lin_CalendarQuarter: Integer;
    //         lrc_DMGSetup: Record "64006";
    //         lrc_CurrExchRate: Record "330";
    //     begin
    //         // DMG 018 DMG50138.s

    //         ldt_FirstDayDispositionWeek := 0D;
    //         IF rrc_BUIItemStatisticEntry."Disposition Week" <> '' THEN BEGIN
    //            ldt_FirstDayDispositionWeek := lcu_PositionPlanning.CalculateFirstWeekDay( rrc_BUIItemStatisticEntry."Disposition Week",
    //              rrc_BUIItemStatisticEntry."Voyage No." );
    //         END;

    //         IF ldt_FirstDayDispositionWeek <> 0D THEN BEGIN

    //            // Standard Kalender
    //            lin_CalendarYear := DATE2DMY(ldt_FirstDayDispositionWeek, 3);
    //            lin_CalendarWeek := DATE2DWY(ldt_FirstDayDispositionWeek, 2);
    //            lin_CalendarMonth := DATE2DMY(ldt_FirstDayDispositionWeek, 2);
    //            IF ( lin_CalendarMonth = 1 ) OR
    //               ( lin_CalendarMonth = 2 ) OR
    //               ( lin_CalendarMonth = 3 ) THEN BEGIN
    //               lin_CalendarQuarter := 1;
    //            END ELSE BEGIN
    //              IF ( lin_CalendarMonth = 4 ) OR
    //                 ( lin_CalendarMonth = 5 ) OR
    //                 ( lin_CalendarMonth = 6 ) THEN BEGIN
    //                 lin_CalendarQuarter := 2;
    //              END ELSE BEGIN
    //                IF ( lin_CalendarMonth = 7 ) OR
    //                   ( lin_CalendarMonth = 8 ) OR
    //                   ( lin_CalendarMonth = 9 ) THEN BEGIN
    //                   lin_CalendarQuarter := 3;
    //                END ELSE BEGIN
    //                  lin_CalendarQuarter := 4;
    //                END;
    //              END;
    //            END;

    //            rrc_BUIItemStatisticEntry."Quarter Calendar DispoWeek" := FORMAT(lin_CalendarQuarter) + '_' + FORMAT( lin_CalendarYear );
    //            IF lin_CalendarMonth < 10 THEN BEGIN
    //              rrc_BUIItemStatisticEntry."Month Calendar DispoWeek" := '0' + FORMAT( lin_CalendarMonth ) + '_' + FORMAT( lin_CalendarYear );
    //            END ELSE BEGIN
    //              rrc_BUIItemStatisticEntry."Month Calendar DispoWeek" := FORMAT( lin_CalendarMonth ) + '_' + FORMAT( lin_CalendarYear );
    //            END;
    //            IF lin_CalendarWeek < 10 THEN BEGIN
    //              rrc_BUIItemStatisticEntry."Week Calendar DispoWeek" := '0' + FORMAT( lin_CalendarWeek )+ '_' + FORMAT( lin_CalendarYear );
    //            END ELSE BEGIN
    //              rrc_BUIItemStatisticEntry."Week Calendar DispoWeek" := FORMAT( lin_CalendarWeek )+ '_' + FORMAT( lin_CalendarYear );
    //            END;

    //            // DMG Spezifischer Kalender
    //            lrc_DMGWeekSchedule.FindPeriodRecord( ldt_FirstDayDispositionWeek,
    //                                lin_DMGWeek, lin_DMGCalendarWeek, lin_DMGYear, lin_DMGMonth );

    //            IF ( lin_DMGWeek = 0 ) AND
    //               ( lin_DMGCalendarWeek = 0 ) AND
    //               ( lin_DMGYear = 0 ) AND
    //               ( lin_DMGMonth = 0 ) THEN BEGIN

    //              rrc_BUIItemStatisticEntry."Year DispoWeek" := '';
    //              rrc_BUIItemStatisticEntry."Month KDK DispoWeek" := '';
    //              rrc_BUIItemStatisticEntry."Quarter KDK DispoWeek" := '';
    //              rrc_BUIItemStatisticEntry."Week KDK DispoWeek" := '';

    //            END ELSE BEGIN
    //              IF ( lin_DMGMonth = 1 ) OR
    //                 ( lin_DMGMonth = 2 ) OR
    //                 ( lin_DMGMonth = 3 ) THEN BEGIN
    //                 lin_DMGQuarter := 1;
    //              END ELSE BEGIN
    //                IF ( lin_DMGMonth = 4 ) OR
    //                   ( lin_DMGMonth = 5 ) OR
    //                   ( lin_DMGMonth = 6 ) THEN BEGIN
    //                   lin_DMGQuarter := 2;
    //                END ELSE BEGIN
    //                  IF ( lin_DMGMonth = 7 ) OR
    //                     ( lin_DMGMonth = 8 ) OR
    //                     ( lin_DMGMonth = 9 ) THEN BEGIN
    //                     lin_DMGQuarter := 3;
    //                  END ELSE BEGIN
    //                    lin_DMGQuarter := 4;
    //                  END;
    //                END;
    //              END;

    //             rrc_BUIItemStatisticEntry."Year DispoWeek" := FORMAT( lin_DMGYear );
    //             rrc_BUIItemStatisticEntry."Quarter KDK DispoWeek" := FORMAT(lin_DMGQuarter) + '_' + FORMAT( lin_DMGYear );
    //             IF lin_DMGMonth < 10 THEN BEGIN
    //               rrc_BUIItemStatisticEntry."Month KDK DispoWeek" := '0' + FORMAT( lin_DMGMonth ) + '_' + FORMAT( lin_DMGYear );
    //             END ELSE BEGIN
    //               rrc_BUIItemStatisticEntry."Month KDK DispoWeek" := FORMAT( lin_DMGMonth ) + '_' + FORMAT( lin_DMGYear );
    //             END;
    //             IF lin_DMGCalendarWeek < 10 THEN BEGIN
    //               rrc_BUIItemStatisticEntry."Week KDK DispoWeek" := '0' + FORMAT( lin_DMGCalendarWeek )+ '_' + FORMAT( lin_DMGYear );
    //             END ELSE BEGIN
    //               rrc_BUIItemStatisticEntry."Week KDK DispoWeek" := FORMAT( lin_DMGCalendarWeek )+ '_' + FORMAT( lin_DMGYear );
    //             END;
    //           END;
    //         END ELSE BEGIN
    //            rrc_BUIItemStatisticEntry."Year DispoWeek" := '';
    //            rrc_BUIItemStatisticEntry."Month KDK DispoWeek" := '';
    //            rrc_BUIItemStatisticEntry."Month Calendar DispoWeek" := '';
    //            rrc_BUIItemStatisticEntry."Quarter KDK DispoWeek" := '';
    //            rrc_BUIItemStatisticEntry."Quarter Calendar DispoWeek" := '';
    //            rrc_BUIItemStatisticEntry."Week KDK DispoWeek" := '';
    //            rrc_BUIItemStatisticEntry."Week Calendar DispoWeek" := '';
    //         END;

    //         IF rrc_BUIItemStatisticEntry."Inv/CrM Posting Date" <> 0D THEN BEGIN

    //           // Standard Kalender
    //           // bereits in Tabelle erfolgt ActualDateFields

    //           // DMG Spezifischer Kalender
    //           lrc_DMGWeekSchedule.FindPeriodRecord( rrc_BUIItemStatisticEntry."Inv/CrM Posting Date",
    //                                lin_DMGWeek, lin_DMGCalendarWeek, lin_DMGYear, lin_DMGMonth );
    //            IF ( lin_DMGWeek = 0 ) AND
    //               ( lin_DMGCalendarWeek = 0 ) AND
    //               ( lin_DMGYear = 0 ) AND
    //               ( lin_DMGMonth = 0 ) THEN BEGIN

    //              rrc_BUIItemStatisticEntry."Year KDK INV Postingdate" := '';
    //              rrc_BUIItemStatisticEntry."Quarter KDK INV Postingdate" := '';
    //              rrc_BUIItemStatisticEntry."Week KDK INV Postingdate" := '';
    //              rrc_BUIItemStatisticEntry."Month KDK INV Postingdate" := '';

    //           END ELSE BEGIN
    //             IF ( lin_DMGMonth = 1 ) OR
    //                ( lin_DMGMonth = 2 ) OR
    //                ( lin_DMGMonth = 3 ) THEN BEGIN
    //                lin_DMGQuarter := 1;
    //             END ELSE BEGIN
    //               IF ( lin_DMGMonth = 4 ) OR
    //                  ( lin_DMGMonth = 5 ) OR
    //                  ( lin_DMGMonth = 6 ) THEN BEGIN
    //                  lin_DMGQuarter := 2;
    //               END ELSE BEGIN
    //                 IF ( lin_DMGMonth = 7 ) OR
    //                    ( lin_DMGMonth = 8 ) OR
    //                    ( lin_DMGMonth = 9 ) THEN BEGIN
    //                    lin_DMGQuarter := 3;
    //                 END ELSE BEGIN
    //                   lin_DMGQuarter := 4;
    //                 END;
    //               END;
    //             END;

    //             rrc_BUIItemStatisticEntry."Year KDK INV Postingdate" := FORMAT( lin_DMGYear );
    //             rrc_BUIItemStatisticEntry."Quarter KDK INV Postingdate" := FORMAT(lin_DMGQuarter) + '_' + FORMAT( lin_DMGYear );
    //             IF lin_DMGMonth < 10 THEN BEGIN
    //               rrc_BUIItemStatisticEntry."Month KDK INV Postingdate" := '0' + FORMAT( lin_DMGMonth ) + '_' + FORMAT( lin_DMGYear );
    //             END ELSE BEGIN
    //               rrc_BUIItemStatisticEntry."Month KDK INV Postingdate" := FORMAT( lin_DMGMonth ) + '_' + FORMAT( lin_DMGYear );
    //             END;
    //             IF lin_DMGCalendarWeek < 10 THEN BEGIN
    //               rrc_BUIItemStatisticEntry."Week KDK INV Postingdate" := '0' + FORMAT( lin_DMGCalendarWeek )+ '_' + FORMAT( lin_DMGYear );
    //             END ELSE BEGIN
    //               rrc_BUIItemStatisticEntry."Week KDK INV Postingdate" := FORMAT( lin_DMGCalendarWeek )+ '_' + FORMAT( lin_DMGYear );
    //             END;
    //           END;
    //         END ELSE BEGIN
    //           rrc_BUIItemStatisticEntry."Year KDK INV Postingdate" := '';
    //           rrc_BUIItemStatisticEntry."Quarter KDK INV Postingdate" := '';
    //           rrc_BUIItemStatisticEntry."Week KDK INV Postingdate" := '';
    //           rrc_BUIItemStatisticEntry."Month KDK INV Postingdate" := '';
    //         END;

    //         lrc_DMGSetup.GET();
    //         rrc_BUIItemStatisticEntry."Income Reference Currency Code" := lrc_DMGSetup."Income Reference Currency Code";

    //         IF rrc_BUIItemStatisticEntry."Income Reference Currency Code" <> '' THEN BEGIN
    //           IF rrc_BUIItemStatisticEntry."Inv/CrM Posting Date" = 0D THEN BEGIN
    //             rrc_BUIItemStatisticEntry."Income Reference Currency Fact" :=
    //                 lrc_CurrExchRate.ExchangeRate(rrc_BUIItemStatisticEntry."Posting Date",
    //                                               rrc_BUIItemStatisticEntry."Income Reference Currency Code" );
    //           END ELSE BEGIN
    //             rrc_BUIItemStatisticEntry."Income Reference Currency Fact" :=
    //                 lrc_CurrExchRate.ExchangeRate(rrc_BUIItemStatisticEntry."Inv/CrM Posting Date",
    //                                               rrc_BUIItemStatisticEntry."Income Reference Currency Code" );
    //           END;
    //         END ELSE
    //           rrc_BUIItemStatisticEntry."Income Reference Currency Fact" := 0;

    //         rrc_BUIItemStatisticEntry."Balance Reference CurrencyCode" := lrc_DMGSetup."Balance Reference CurrencyCode";
    //         IF rrc_BUIItemStatisticEntry."Balance Reference CurrencyCode" <> '' THEN BEGIN
    //           IF rrc_BUIItemStatisticEntry."Inv/CrM Posting Date" = 0D THEN BEGIN
    //             rrc_BUIItemStatisticEntry."Balance Reference CurrencyFact" :=
    //                 lrc_CurrExchRate.ExchangeRate(rrc_BUIItemStatisticEntry."Posting Date",
    //                                               rrc_BUIItemStatisticEntry."Balance Reference CurrencyCode" );
    //           END ELSE BEGIN
    //             rrc_BUIItemStatisticEntry."Balance Reference CurrencyFact" :=
    //                 lrc_CurrExchRate.ExchangeRate(rrc_BUIItemStatisticEntry."Inv/CrM Posting Date",
    //                                               rrc_BUIItemStatisticEntry."Balance Reference CurrencyCode" );
    //           END;
    //         END ELSE
    //           rrc_BUIItemStatisticEntry."Balance Reference CurrencyFact" := 0;
    //         // DMG 018 DMG50138.s
    //     end;

    //     procedure GetMainOrderNumber(vco_SalesOrderNo: Code[20]) lco_MainSalesOrderNo: Code[20]
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_DMGDocumentAssignment: Record "64024";
    //     begin
    //         // DMG 019 DMG50000.s

    //         lco_MainSalesOrderNo := vco_SalesOrderNo;

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //           lrc_DMGDocumentAssignment.Reset();
    //           lrc_DMGDocumentAssignment.SETCURRENTKEY("Assignment No.");
    //           lrc_DMGDocumentAssignment.SETRANGE("Source Type", lrc_DMGDocumentAssignment."Source Type"::"0" );
    //           lrc_DMGDocumentAssignment.SETRANGE("Document Type", lrc_DMGDocumentAssignment."Document Type"::"1" );
    //           lrc_DMGDocumentAssignment.SETRANGE("Assignment No.", vco_SalesOrderNo );
    //           IF lrc_DMGDocumentAssignment.FIND('-') THEN BEGIN
    //              lco_MainSalesOrderNo := lrc_DMGDocumentAssignment."Document No.";
    //           END;
    //         END;

    //         EXIT( lco_MainSalesOrderNo );
    //         // DMG 019 DMG50000.e
    //     end;

    //     procedure "----- Agiles ZER"()
    //     begin
    //     end;

    //     procedure "-- ZER 001 ZER40241 F"()
    //     begin
    //     end;

    //     procedure ShowInfoFromAdvPayment(var rrc_AdvPayVendorEntry: Record "5110469")
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_PurchaseLine: Record "39";
    //         lfm_ZERPurchaseLinesInfo: Form "60042";
    //     begin
    //         // VFI 001 ZER40241.s
    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Internal Customer Code" <> 'ZERRES' THEN BEGIN
    //           EXIT;
    //         END;

    //         rrc_AdvPayVendorEntry.TESTFIELD("Master Batch No.");

    //         lrc_PurchaseLine.Reset();
    //         lrc_PurchaseLine.SETCURRENTKEY("Batch Variant No.","Batch No.","Master Batch No.",Type,"Document Type");
    //         lrc_PurchaseLine.SETRANGE("Master Batch No.",rrc_AdvPayVendorEntry."Master Batch No.");

    //         CLEAR(lfm_ZERPurchaseLinesInfo);
    //         lfm_ZERPurchaseLinesInfo.SETTABLEVIEW(lrc_PurchaseLine);
    //         lfm_ZERPurchaseLinesInfo.RUN;
    //         // VFI 001 ZER40241.e
    //     end;

    //     procedure "-- KDK 002 00000000 F"()
    //     begin
    //     end;

    //     procedure ShowBatchSelection(var rrc_FruitVisionSetup: Record "5110302";var rrc_SalesHeader: Record "36";vin_Counter: Integer;vco_CustomerNo: Code[20])
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lfm_BatchVariantSelectionZER: Form "60018";
    //         lfm_SalesLineBatchSelectionZER: Form "60019";
    //         lop_CalledFromSource: Option ,Sales,Transfer,"Feature Assortment",Reservation,"Pac Input","Pac Pac Input";
    //     begin
    //         IF rrc_FruitVisionSetup."Sales Loc. only as in Header" = TRUE THEN BEGIN
    //           rrc_SalesHeader.TESTFIELD("Location Code");
    //           lfm_BatchVariantSelectionZER.SetLocation(rrc_SalesHeader."Location Code", '',
    //                                                    rrc_SalesHeader."Sales Doc. Subtype Code",
    //                                                    rrc_SalesHeader."Document Type", FALSE);
    //         END ELSE BEGIN
    //           // Eingrenzung Auswahl auf die Lagerorte der Auftragsart
    //           IF rrc_SalesHeader."Sales Doc. Subtype Code" <> '' THEN
    //              lfm_BatchVariantSelectionZER.SetLocation('', '',
    //                                                       rrc_SalesHeader."Sales Doc. Subtype Code",
    //                                                       rrc_SalesHeader."Document Type", TRUE);
    //         END;

    //         lrc_BatchVariant.Reset();
    //         lrc_BatchVariant.SETRANGE(State, lrc_BatchVariant.State::Open);
    //         lfm_BatchVariantSelectionZER.SetCounter(vin_Counter);
    //         lfm_BatchVariantSelectionZER.ActivateFields(vco_CustomerNo, rrc_SalesHeader."Sales Doc. Subtype Code");
    //         lfm_BatchVariantSelectionZER.SetCalledFrom(lop_CalledFromSource::Sales);
    //         lfm_BatchVariantSelectionZER.SETTABLEVIEW(lrc_BatchVariant);
    //         lfm_BatchVariantSelectionZER.RUNMODAL;
    //     end;

    //     procedure "----- Agiles QUM"()
    //     begin
    //     end;

    //     procedure IS_ModulQUM_Active(): Boolean
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // QUM 001 00000000.s
    //         lrc_FruitVisionSetup.GET();
    //         EXIT( lrc_FruitVisionSetup."Module Quality Management" );
    //         // QUM 001 00000000.e
    //     end;

    //     procedure QUM_BatchVariant_TestSorting(vco_BatchVariantNo: Code[20])
    //     var
    //         lrc_QUMSetup: Record "89450";
    //         lrc_BatchVariantQMHeader: Record "89461";
    //         lcu_QMCheckListManagementCCB: Codeunit "89451";
    //         lrc_QMTemplateHeaderCCB: Record "89451";
    //         lrc_QMHeaderCCB: Record "89458";
    //         lfm_QMHeaderCCB: Form "89453";
    //     begin
    //         // QUM 002 00000000.s
    //         IF vco_BatchVariantNo = '' THEN
    //            EXIT;

    //         lrc_QUMSetup.GET();
    //         lrc_QUMSetup.TESTFIELD( "QM Typ Test Sorting" );
    //         lrc_QUMSetup.TESTFIELD( "QM Template Test Sorting" );
    //         lrc_QMTemplateHeaderCCB.GET( lrc_QUMSetup."QM Template Test Sorting" );

    //         lrc_BatchVariantQMHeader.Reset();
    //         lrc_BatchVariantQMHeader.SETRANGE( "Batch Variant No.", vco_BatchVariantNo );
    //         lrc_BatchVariantQMHeader.SETRANGE( "QM Typ", lrc_QUMSetup."QM Typ Test Sorting" );
    //         IF NOT lrc_BatchVariantQMHeader.FIND('-') THEN BEGIN
    //            lrc_BatchVariantQMHeader.Reset();
    //            lrc_BatchVariantQMHeader.INIT();
    //            lrc_BatchVariantQMHeader."Batch Variant No." := vco_BatchVariantNo;
    //            lrc_BatchVariantQMHeader."QM Typ" := lrc_QUMSetup."QM Typ Test Sorting";
    //            // DMG 006 DMG50042.s
    //            // lrc_BatchVariantQMHeader."QM Header No." := lcu_QMCheckListManagementCCB.CLVorlageInCL( lrc_QMTemplateHeaderCCB );
    //            // DMG 007 DMG50045.s
    //            // lrc_BatchVariantQMHeader."QM Header No." := lcu_QMCheckListManagementCCB.CLVorlageInCL( lrc_QMTemplateHeaderCCB, ''  );
    //            lrc_BatchVariantQMHeader."QM Header No." := lcu_QMCheckListManagementCCB.CLVorlageInCL( lrc_QMTemplateHeaderCCB, '', '', ''  );
    //            // DMG 007 DMG50045.e
    //            // DMG 006 DMG50042.e
    //            lrc_BatchVariantQMHeader.INSERT( TRUE );
    //         END;

    //         lrc_QMHeaderCCB.Reset();
    //         lrc_QMHeaderCCB.SETRANGE( "No.", lrc_BatchVariantQMHeader."QM Header No." );
    //         lfm_QMHeaderCCB.SETTABLEVIEW( lrc_QMHeaderCCB );
    //         lfm_QMHeaderCCB.RUN;
    //         // QUM 002 00000000.e
    //     end;

    //     procedure QUM_BatchVariant_ReceiptOfGood(vco_BatchVariantNo: Code[20];vco_LocationCode: Code[10];lbn_Neuanlage: Boolean)
    //     var
    //         lcu_QMCheckListManagementCCB: Codeunit "89451";
    //         lrc_QUMSetup: Record "89450";
    //         lrc_BatchVariantQMHeader: Record "89461";
    //         lrc_QMTemplateHeaderCCB: Record "89451";
    //         lrc_QMHeaderCCB: Record "89458";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_QUMProductgroup: Record "89462";
    //         lfm_QMHeaderCCB: Form "89453";
    //         lco_QMTypReceiptOfGoods: Code[20];
    //         lco_QMTemplateReceiptOfGoods: Code[20];
    //         AgilesText001: Label 'Es existieren bereits %1 Protokolle zur Positionsvariante %2, Lagerort %3, Trotzdem eine neues Protokoll anlegen ?';
    //         lbn_Create: Boolean;
    //         AgilesText002: Label 'Wollen Sie wirklich einen neues Protokoll für die Positionsvariante %1, Lagerort %2 erstellen ?';
    //     begin
    //         // QUM 002 00000000.s
    //         IF vco_BatchVariantNo = '' THEN
    //            EXIT;

    //         // DMG 006 DMG50042.s
    //         lco_QMTypReceiptOfGoods := '';
    //         lco_QMTemplateReceiptOfGoods := '';
    //         // DMG 006 DMG50042.e

    //         lrc_QUMSetup.GET();
    //         lrc_QUMSetup.TESTFIELD( "QM Typ Receipt Of Goods" );
    //         lrc_QUMSetup.TESTFIELD( "QM Template Receipt Of Goods" );

    //         // DMG 006 DMG50042.s
    //         // lrc_QMTemplateHeaderCCB.GET( lrc_QUMSetup."QM Template Receipt Of Goods" );
    //         lco_QMTemplateReceiptOfGoods := lrc_QUMSetup."QM Template Receipt Of Goods";
    //         lco_QMTypReceiptOfGoods := lrc_QUMSetup."QM Typ Receipt Of Goods";
    //         IF lrc_BatchVariant.GET( vco_BatchVariantNo ) THEN BEGIN
    //            IF ( lrc_BatchVariant."Item Category Code" <> '' ) AND
    //               ( lrc_BatchVariant."Product Group Code" <> '' ) THEN BEGIN
    //              IF lrc_QUMProductgroup.GET( lrc_BatchVariant."Item Category Code", lrc_BatchVariant."Product Group Code" ) THEN BEGIN
    //                IF lrc_QUMProductgroup."QUM Template Receipt Of Goods" <> '' THEN BEGIN
    //                  lco_QMTemplateReceiptOfGoods := lrc_QUMProductgroup."QUM Template Receipt Of Goods";
    //                  lco_QMTypReceiptOfGoods := lrc_QUMProductgroup."QUM Typ Receipt Of Goods";
    //                END;
    //              END;
    //            END;
    //         // DMG 007 DMG50045.s
    //         END ELSE BEGIN
    //           lrc_BatchVariant.INIT();
    //         // DMG 007 DMG50045.e
    //         END;

    //         lrc_QMTemplateHeaderCCB.GET( lco_QMTemplateReceiptOfGoods );
    //         // DMG 006 DMG50042.e

    //         lrc_BatchVariantQMHeader.Reset();

    //         // DMG 005 DMG40042.s
    //         IF lbn_Neuanlage = FALSE THEN BEGIN
    //           lbn_Create := FALSE;
    //           lrc_BatchVariantQMHeader.SETCURRENTKEY( "Batch Variant No.","Location Code", "QM Typ","QM Header No." );
    //         // DMG 005 DMG50042.e
    //           lrc_BatchVariantQMHeader.SETRANGE( "Batch Variant No.", vco_BatchVariantNo );
    //           // DMG 005 DMG50042.s
    //           IF vco_LocationCode <> '' THEN BEGIN
    //             lrc_BatchVariantQMHeader.SETRANGE( "Location Code", vco_LocationCode );
    //           END;
    //           // lrc_BatchVariantQMHeader.SETRANGE( "QM Typ", lrc_QUMSetup."QM Typ Receipt Of Goods" );
    //           lrc_BatchVariantQMHeader.SETRANGE( "QM Typ", lco_QMTypReceiptOfGoods );
    //           // DMG 005 DMG50042.e
    //           IF NOT lrc_BatchVariantQMHeader.FIND('-') THEN BEGIN
    //              lbn_Create := TRUE;
    //           // END ELSE BEGIN
    //           //    IF CONFIRM( AgilesText001, FALSE, lrc_BatchVariantQMHeader.COUNTAPPROX(), lrc_BatchVariantQMHeader."Batch Variant No.",
    //           //       lrc_BatchVariantQMHeader."Location Code" ) THEN BEGIN
    //           //      lbn_Create := TRUE;
    //           //    END;
    //           END;
    //         END ELSE BEGIN
    //           lbn_Create := TRUE;
    //           IF NOT CONFIRM( AgilesText002, TRUE, vco_BatchVariantNo, vco_LocationCode ) THEN BEGIN
    //             EXIT;
    //           END;
    //         END;

    //         IF lbn_Create = TRUE THEN BEGIN
    //           lrc_BatchVariantQMHeader.Reset();
    //           lrc_BatchVariantQMHeader.INIT();
    //           lrc_BatchVariantQMHeader."Batch Variant No." := vco_BatchVariantNo;
    //           lrc_BatchVariantQMHeader.INSERT( TRUE );
    //           // lrc_BatchVariantQMHeader."QM Typ" := lrc_QUMSetup."QM Typ Receipt Of Goods";
    //           lrc_BatchVariantQMHeader."QM Typ" := lco_QMTypReceiptOfGoods;
    //           lrc_BatchVariantQMHeader."Location Code" := vco_LocationCode;

    //           // lrc_BatchVariantQMHeader."QM Header No." := lcu_QMCheckListManagementCCB.CLVorlageInCL( lrc_QMTemplateHeaderCCB );
    //           lrc_BatchVariantQMHeader."QM Header No." := lcu_QMCheckListManagementCCB.CLVorlageInCL( lrc_QMTemplateHeaderCCB,
    //           // DMG 007 DMG50045.s
    //           //                     vco_LocationCode );
    //                                vco_LocationCode, lrc_BatchVariant."Item No.", vco_BatchVariantNo );
    //           // DMG 007 DMG50045.e
    //           lrc_BatchVariantQMHeader.MODIFY( TRUE );
    //         END;

    //         lrc_QMHeaderCCB.Reset();
    //         lrc_QMHeaderCCB.SETRANGE( "No.", lrc_BatchVariantQMHeader."QM Header No." );
    //         lfm_QMHeaderCCB.SETTABLEVIEW( lrc_QMHeaderCCB );
    //         lfm_QMHeaderCCB.RUN;
    //         // QUM 002 00000000.e
    //     end;

    //     procedure QUM_BatchVariant_Inspec_Certif(vco_BatchVariantNo: Code[20];vco_LocationCode: Code[10];lbn_Neuanlage: Boolean)
    //     var
    //         lrc_QUMSetup: Record "89450";
    //         lrc_BatchVariantQMHeader: Record "89461";
    //         lcu_QMCheckListManagementCCB: Codeunit "89451";
    //         lrc_QMTemplateHeaderCCB: Record "89451";
    //         lrc_QMHeaderCCB: Record "89458";
    //         lfm_QMHeaderCCB: Form "89453";
    //         "-- DMG 005 DMG50042": Integer;
    //         lrc_BatchVariant: Record "5110366";
    //         lco_QMTypInspectionCertificate: Code[20];
    //         lco_QMTemplateInspecCertificat: Code[20];
    //         lrc_QUMProductgroup: Record "89462";
    //         AgilesText001: Label 'Es existieren bereits %1 Protokolle zur Positionsvariante %2, Lagerort %3, Trotzdem eine neues Protokoll anlegen ?';
    //         lbn_Create: Boolean;
    //         AgilesText002: Label 'Wollen Sie wirklich einen neues Protokoll für die Positionsvariante %1, Lagerort %2 erstellen ?';
    //     begin
    //         // DMG 008 DMG40045.s
    //         IF vco_BatchVariantNo = '' THEN
    //            EXIT;

    //         // DMG 006 DMG50042.s
    //         lco_QMTypInspectionCertificate := '';
    //         lco_QMTemplateInspecCertificat := '';
    //         // DMG 006 DMG50042.e

    //         lrc_QUMSetup.GET();
    //         lrc_QUMSetup.TESTFIELD( "QM Typ Inspection Certificate");
    //         lrc_QUMSetup.TESTFIELD( "QM Template Inspection Cert" );

    //         // DMG 006 DMG50042.s
    //         // lrc_QMTemplateHeaderCCB.GET( lrc_QUMSetup."QM Template Receipt Of Goods" );
    //         lco_QMTemplateInspecCertificat := lrc_QUMSetup."QM Template Inspection Cert";
    //         lco_QMTypInspectionCertificate := lrc_QUMSetup."QM Typ Inspection Certificate";
    //         IF lrc_BatchVariant.GET( vco_BatchVariantNo ) THEN BEGIN
    //            IF ( lrc_BatchVariant."Item Category Code" <> '' ) AND
    //               ( lrc_BatchVariant."Product Group Code" <> '' ) THEN BEGIN
    //              IF lrc_QUMProductgroup.GET( lrc_BatchVariant."Item Category Code", lrc_BatchVariant."Product Group Code" ) THEN BEGIN
    //                IF lrc_QUMProductgroup."QUM Template Inspection Cert" <> '' THEN BEGIN
    //                  lco_QMTemplateInspecCertificat := lrc_QUMProductgroup."QUM Template Inspection Cert";
    //                  lco_QMTypInspectionCertificate := lrc_QUMProductgroup."QUM Typ Inspection Certificate"
    //                END;
    //              END;
    //            END;
    //         // DMG 007 DMG50045.s
    //         END ELSE BEGIN
    //           lrc_BatchVariant.INIT();
    //         // DMG 007 DMG50045.e
    //         END;

    //         lrc_QMTemplateHeaderCCB.GET( lco_QMTemplateInspecCertificat );
    //         // DMG 006 DMG50042.e

    //         lrc_BatchVariantQMHeader.Reset();
    //         // DMG 005 DMG50042.s

    //         IF lbn_Neuanlage = FALSE THEN BEGIN
    //           lbn_Create := FALSE;
    //           lrc_BatchVariantQMHeader.SETCURRENTKEY( "Batch Variant No.","Location Code", "QM Typ","QM Header No." );
    //         // DMG 005 DMG50042.e
    //           lrc_BatchVariantQMHeader.SETRANGE( "Batch Variant No.", vco_BatchVariantNo );
    //           // DMG 005 DMG50042.s
    //           IF vco_LocationCode <> '' THEN BEGIN
    //             lrc_BatchVariantQMHeader.SETRANGE( "Location Code", vco_LocationCode );
    //           END;
    //           // lrc_BatchVariantQMHeader.SETRANGE( "QM Typ", lrc_QUMSetup."QM Typ Receipt Of Goods" );
    //           lrc_BatchVariantQMHeader.SETRANGE( "QM Typ", lco_QMTypInspectionCertificate );
    //           // DMG 005 DMG50042.e
    //           IF NOT lrc_BatchVariantQMHeader.FIND('-') THEN BEGIN
    //              lbn_Create := TRUE;
    //           // END ELSE BEGIN
    //           //    IF CONFIRM( AgilesText001, FALSE, lrc_BatchVariantQMHeader.COUNTAPPROX(), lrc_BatchVariantQMHeader."Batch Variant No.",
    //           //       lrc_BatchVariantQMHeader."Location Code" ) THEN BEGIN
    //           //      lbn_Create := TRUE;
    //           //    END;
    //           END;
    //         END ELSE BEGIN
    //           lbn_Create := TRUE;
    //           IF NOT CONFIRM( AgilesText002, TRUE, vco_BatchVariantNo, vco_LocationCode ) THEN BEGIN
    //             EXIT;
    //           END;
    //         END;

    //         IF lbn_Create = TRUE THEN BEGIN
    //           lrc_BatchVariantQMHeader.Reset();
    //           lrc_BatchVariantQMHeader.INIT();
    //           lrc_BatchVariantQMHeader."Batch Variant No." := vco_BatchVariantNo;
    //           lrc_BatchVariantQMHeader.INSERT( TRUE );
    //           // lrc_BatchVariantQMHeader."QM Typ" := lrc_QUMSetup."QM Typ Receipt Of Goods";
    //           lrc_BatchVariantQMHeader."QM Typ" := lco_QMTypInspectionCertificate;
    //           lrc_BatchVariantQMHeader."Location Code" := vco_LocationCode;

    //           // lrc_BatchVariantQMHeader."QM Header No." := lcu_QMCheckListManagementCCB.CLVorlageInCL( lrc_QMTemplateHeaderCCB );
    //           lrc_BatchVariantQMHeader."QM Header No." := lcu_QMCheckListManagementCCB.CLVorlageInCL( lrc_QMTemplateHeaderCCB,
    //           // DMG 007 DMG50045.s
    //           //                     vco_LocationCode );
    //                                vco_LocationCode, lrc_BatchVariant."Item No.", vco_BatchVariantNo );
    //           // DMG 007 DMG50045.e
    //           lrc_BatchVariantQMHeader.MODIFY( TRUE );
    //         END;

    //         lrc_QMHeaderCCB.Reset();
    //         lrc_QMHeaderCCB.SETRANGE( "No.", lrc_BatchVariantQMHeader."QM Header No." );
    //         lfm_QMHeaderCCB.SETTABLEVIEW( lrc_QMHeaderCCB );
    //         lfm_QMHeaderCCB.RUN;
    //         // DMG 008 DMG40045.e
    //     end;

    //     procedure QUM_DEL_TABLE89461(var vrc_BatchVariant: Record "5110366")
    //     var
    //         lrc_BatchVariantQMHeader: Record "89461";
    //     begin
    //         // QUM 001 00000001.s
    //         lrc_BatchVariantQMHeader.Reset();
    //         lrc_BatchVariantQMHeader.SETRANGE( lrc_BatchVariantQMHeader."Batch Variant No.", vrc_BatchVariant."No." );
    //         IF lrc_BatchVariantQMHeader.FIND('-') THEN BEGIN
    //            lrc_BatchVariantQMHeader.DELETEALL( TRUE );
    //         END;
    //         // QUM 002 00000001.s
    //     end;

    //     procedure QUM_EDIT_Product_Group_Defin(vrc_ItemCategoryCode: Code[10];vrc_ProductGroupCode: Code[10])
    //     var
    //         lrc_QUMProductGroupDefinition: Record "89462";
    //         lfm_QUMProductGroupDefinition: Form "89469";
    //     begin
    //         // QUM 003 00000000.s
    //         lrc_QUMProductGroupDefinition.Reset();
    //         lrc_QUMProductGroupDefinition.SETRANGE( "Item Category Code", vrc_ItemCategoryCode );
    //         lrc_QUMProductGroupDefinition.SETRANGE( "Product Group Code", vrc_ProductGroupCode );
    //         IF NOT lrc_QUMProductGroupDefinition.FIND('-') THEN BEGIN
    //             lrc_QUMProductGroupDefinition.INIT();
    //             lrc_QUMProductGroupDefinition."Item Category Code" := vrc_ItemCategoryCode;
    //             lrc_QUMProductGroupDefinition."Product Group Code" := vrc_ProductGroupCode;
    //             lrc_QUMProductGroupDefinition.INSERT( TRUE );
    //             COMMIT;
    //         END;
    //         lfm_QUMProductGroupDefinition.SETTABLEVIEW ( lrc_QUMProductGroupDefinition );
    //         lfm_QUMProductGroupDefinition.RUNMODAL;
    //         // QUM 003 00000000.e
    //     end;

    //     procedure "----- Agiles SCA"()
    //     begin
    //     end;

    //     procedure IS_ModulSCA_Active(): Boolean
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // SCA 001 DMG50064.s
    //         lrc_FruitVisionSetup.GET();
    //         EXIT( lrc_FruitVisionSetup."Module Synko Barscan" );
    //         // SCA 001 DMG50064.e
    //     end;

    //     procedure GetBarScanUserID(var vrc_BarScanUserID: Code[20])
    //     var
    //         BarScanComm: Codeunit "5153252";
    //     begin
    //         // SCA 001 DMG50064.s
    //         vrc_BarScanUserID := BarScanComm.GetBarScanUserID();
    //         // SCA 001 DMG50064.e
    //     end;

    //     procedure BarScanComm()
    //     var
    //         "*** synko ***": Integer;
    //         BarScanComm: Codeunit "5153252";
    //         "**synko**": ;
    //         Text5153440: Label 'NAS synko BarScan started.';
    //     begin
    //         // SCA 001 DMG50064.s
    //         MESSAGE(Text5153440);
    //         BarScanComm.RUN;
    //         // SCA 001 DMG50064.e
    //     end;

    //     procedure PrintPINCard(rco_UserID: Code[20])
    //     var
    //         lrc_UserSetup: Record "91";
    //         "--- KDK 002 00000000": Integer;
    //         lrc_FruitvisionSetup: Record "5110302";
    //     begin
    //         // SCA 001 DMG50064.s
    //         lrc_UserSetup.SETRANGE("User ID", rco_UserID );

    //         // KDK 003 00000000.s
    //         lrc_FruitvisionSetup.GET();
    //         IF lrc_FruitvisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //           REPORT.RUN(64020,TRUE,FALSE,lrc_UserSetup);
    //         END ELSE BEGIN
    //         // KDK 003 00000000.e
    //           REPORT.RUN(5153252,TRUE,FALSE,lrc_UserSetup);
    //         // KDK 003 00000000.s
    //         END;
    //         // KDK 003 00000000.e
    //         // SCA 001 DMG50064.e
    //     end;

    //     procedure ScannUserForm(rco_UserID: Code[20])
    //     var
    //         lrc_UserSetup: Record "91";
    //         lrc_DMGUserSetup: Record "64023";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lfm_DMGUserSetup: Form "64050";
    //     begin
    //         // DMG 016 DMG50000.s
    //         lrc_UserSetup.SETRANGE("User ID", rco_UserID );

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //           lrc_DMGUserSetup.Reset();
    //           lrc_DMGUserSetup.SETRANGE( "User ID", rco_UserID );
    //           IF NOT lrc_DMGUserSetup.FIND('-') THEN BEGIN
    //             lrc_DMGUserSetup.INIT();
    //             lrc_DMGUserSetup."User ID" := rco_UserID;
    //             lrc_DMGUserSetup.INSERT( TRUE );
    //             COMMIT;
    //           END;
    //           lfm_DMGUserSetup.SETTABLEVIEW ( lrc_DMGUserSetup );
    //           lfm_DMGUserSetup.RUNMODAL;
    //         END;
    //         // DMG 016 DMG50000.e
    //     end;
}

