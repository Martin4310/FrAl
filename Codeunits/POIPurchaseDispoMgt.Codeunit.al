codeunit 5110380 "POI Purchase Dispo Mgt"
{

    //     var
    //         AGILESText001: Label 'Table: %1\Document No.: %2\Line No.: %3\Next Doc. Planing exists.';
    //         AGILESText002: Label 'Date %1 doesn''t belong to the Week %2.';

    // procedure CreateDispoInputLines(vco_ItemNo: Code[20]; vdt_OrderDate: Date)
    // var
    //     lrc_Item: Record Item;
    //     lrc_GRUPurchDispoQty: Record "63001";
    //     lrc_ItemVendor: Record "Item Vendor";
    // begin

    //     IF vdt_OrderDate = 0D THEN
    //         vdt_OrderDate := TODAY();
    //     lrc_Item.GET(vco_ItemNo);
    //     lrc_ItemVendor.SETRANGE("Item No.", vco_ItemNo);
    //     IF lrc_ItemVendor.FIND('-') THEN BEGIN
    //         REPEAT
    //             lrc_GRUPurchDispoQty.SETRANGE("Item No.", vco_ItemNo);
    //             lrc_GRUPurchDispoQty.SETRANGE("Order Date", vdt_OrderDate);
    //             IF NOT lrc_GRUPurchDispoQty.FIND('-') THEN BEGIN
    //                 lrc_GRUPurchDispoQty.reset();
    //                 lrc_GRUPurchDispoQty.init();
    //                 lrc_GRUPurchDispoQty."Item No." := vco_ItemNo;
    //                 lrc_GRUPurchDispoQty."Order Date" := vdt_OrderDate;
    //                 lrc_GRUPurchDispoQty."Entry No." := 0;
    //                 lrc_GRUPurchDispoQty."Vendor No." := lrc_ItemVendor."Vendor No.";
    //                 lrc_GRUPurchDispoQty."Unit of Measure Code" := lrc_Item."Purch. Unit of Measure";
    //                 lrc_GRUPurchDispoQty.Quantity := 0;
    //                 lrc_GRUPurchDispoQty.INSERT(TRUE);
    //             END;
    //         UNTIL lrc_ItemVendor.next() = 0;
    //         COMMIT();
    //     END;
    // end;

    //     procedure ShowDispoLines(vco_ItemNo: Code[20];vdt_OrderDate: Date)
    //     var
    //         lrc_GRUPurchDispoQty: Record "63001";
    //         lrc_ItemVendor: Record "99";
    //         lfm_GRUPurchDispoQty: Form "63051";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         //
    //         // -----------------------------------------------------------------------------

    //         lrc_GRUPurchDispoQty.FILTERGROUP(2);
    //         lrc_GRUPurchDispoQty.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_GRUPurchDispoQty.SETRANGE("Order Date",vdt_OrderDate);
    //         lrc_GRUPurchDispoQty.FILTERGROUP(0);


    //         lfm_GRUPurchDispoQty.SETTABLEVIEW(lrc_GRUPurchDispoQty);
    //         lfm_GRUPurchDispoQty.RUNMODAL;
    //     end;

    //     procedure CreateRequisition(vdt_OrderDate: Date;vco_VendorNo: Code[20])
    //     var
    //         lrc_RequisitionWkshName: Record "245";
    //         lrc_RequisitionLine: Record "246";
    //         lrc_GRUPurchDispoQty: Record "63001";
    //     begin


    //         lrc_RequisitionWkshName.SETRANGE("Vendor No.",vco_VendorNo);
    //         lrc_RequisitionWkshName.FIND('-');

    //         lrc_GRUPurchDispoQty.SETRANGE("Vendor No.",vco_VendorNo);
    //         lrc_GRUPurchDispoQty.SETRANGE("Order Date",vdt_OrderDate);
    //         IF lrc_GRUPurchDispoQty.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_RequisitionLine.reset();
    //             lrc_RequisitionLine.init();
    //             lrc_RequisitionLine."Worksheet Template Name" := lrc_RequisitionWkshName."Worksheet Template Name";
    //             lrc_RequisitionLine."Journal Batch Name" := lrc_RequisitionWkshName.Name;
    //             lrc_RequisitionLine."Line No." := 0;
    //             lrc_RequisitionLine.Insert();
    //             lrc_RequisitionLine.Type := lrc_RequisitionLine.Type::Item;
    //             lrc_RequisitionLine.VALIDATE("No.",lrc_GRUPurchDispoQty."Item No.");


    //           UNTIL lrc_GRUPurchDispoQty.next() = 0;
    //         END;
    //     end;

    procedure RebuildPositionDispoline(var rrc_FromDispolines: Record "POI Dispolines")
    var
        lrc_Dispolines2: Record "POI Dispolines";
    begin
        // ---------------------------------------------------------------------------------------------------------------
        // Funktion dient für die Wiederherstellung einer Dispolines vom Typ Position
        // Die wird aufgerufen, wenn eine nach der Planung erstellte Belegzeile gelöscht wird - Tabellen 37, 5741, 5110713
        // ---------------------------------------------------------------------------------------------------------------
        lrc_Dispolines := rrc_FromDispolines;
        lrc_Dispolines."Document Type" := lrc_Dispolines."Document Type"::Position;
        lrc_Dispolines."Document Line Line No." := 0;
        lrc_Dispolines."Document No." := rrc_FromDispolines."Batch Variant No.";
        lrc_Dispolines."Document Type 2" := lrc_Dispolines."Document Type 2"::Position;
        lrc_Dispolines."Document No. 2" := '';
        lrc_Dispolines."Document Line Line No. 2" := 0;
        lrc_Dispolines."Document Type 3" := lrc_Dispolines."Document Type 3"::Position;
        lrc_Dispolines."Document No. 3" := '';
        lrc_Dispolines."Document Line Line No. 3" := 0;
        IF lrc_Dispolines."Target Type" = lrc_Dispolines."Target Type"::"Customer Group" THEN
            lrc_Dispolines."Target No" := rrc_FromDispolines."Customer Group";
        lrc_Dispolines."Created From Dispoline" := 0D;
        // Zeilennr. einstellen
        lrc_Dispolines2.reset();
        lrc_Dispolines2 := lrc_Dispolines;
        lrc_Dispolines2.SETRECFILTER();
        IF lrc_Dispolines2.FIND('+') THEN
            lrc_Dispolines."Line No." := lrc_Dispolines2."Line No." + 10000;
        lrc_Dispolines.Insert();
    end;

    //     procedure RebuildDispolineOnSalesLine(var rrc_SalesLine: Record "37")
    //     var
    //         lrc_Dispolines: Record "POI Dispolines";
    //     begin
    //         IF (rrc_SalesLine."Document Type" <> rrc_SalesLine."Document Type"::Order) OR (rrc_SalesLine."Document No." = '') OR
    //            (rrc_SalesLine."Line No." = 0)
    //         THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //         lrc_Dispolines.SETRANGE("Document Type",rrc_SalesLine."Document Type");
    //         lrc_Dispolines.SETRANGE("Document No.",rrc_SalesLine."Document No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No.",rrc_SalesLine."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           IF rrc_SalesLine."Quantity Shipped" <> 0 THEN BEGIN
    //             lrc_Dispolines.DELETEALL(TRUE);
    //           END ELSE BEGIN
    //             REPEAT
    //               IF lrc_Dispolines."Created From Dispoline" <> 0D THEN BEGIN
    //                 // Prüfen, ob Folgebeleg Planung vorhanden ist
    //                 IF (lrc_Dispolines."Document Type 2" <> lrc_Dispolines."Document Type 2"::Position) AND
    //                    (lrc_Dispolines."Document No. 2" <> '') AND (lrc_Dispolines."Document Line Line No. 2" <> 0)
    //                 THEN BEGIN
    //                   ERROR(AGILESText001,rrc_SalesLine.TABLECAPTION,rrc_SalesLine."Document No.",rrc_SalesLine."Line No.");
    //                 END;

    //                 RebuildPositionDispoline(lrc_Dispolines);
    //               END;
    //             UNTIL lrc_Dispolines.next() = 0;
    //             lrc_Dispolines.DELETEALL(TRUE);
    //           END;

    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type 2","Document No. 2","Document Line Line No. 2");
    //         lrc_Dispolines.SETRANGE("Document Type 2",rrc_SalesLine."Document Type");
    //         lrc_Dispolines.SETRANGE("Document No. 2",rrc_SalesLine."Document No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No. 2",rrc_SalesLine."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           // Prüfen, ob Folgebeleg Planung vorhanden ist
    //           IF (lrc_Dispolines."Document Type 3" <> lrc_Dispolines."Document Type 3"::Position) AND
    //              (lrc_Dispolines."Document No. 3" <> '') AND (lrc_Dispolines."Document Line Line No. 3" <> 0)
    //           THEN BEGIN
    //             ERROR(AGILESText001,rrc_SalesLine.TABLECAPTION,rrc_SalesLine."Document No.",rrc_SalesLine."Line No.");
    //           END ELSE BEGIN
    //             lrc_Dispolines."Document Type 2" := lrc_Dispolines."Document Type 2"::Position;
    //             lrc_Dispolines."Document No. 2" := '';
    //             lrc_Dispolines."Document Line Line No. 2" := 0;
    //             lrc_Dispolines."Document Type 3" := lrc_Dispolines."Document Type 3"::Position;
    //             lrc_Dispolines."Document No. 3" := '';
    //             lrc_Dispolines."Document Line Line No. 3" := 0;
    //             lrc_Dispolines.MODIFY();
    //           END;

    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type 3","Document No. 3","Document Line Line No. 3");
    //         lrc_Dispolines.SETRANGE("Document Type 3",rrc_SalesLine."Document Type");
    //         lrc_Dispolines.SETRANGE("Document No. 3",rrc_SalesLine."Document No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No. 3",rrc_SalesLine."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           lrc_Dispolines."Document Type 3" := lrc_Dispolines."Document Type 3"::Position;
    //           lrc_Dispolines."Document No. 3" := '';
    //           lrc_Dispolines."Document Line Line No. 3" := 0;
    //           lrc_Dispolines.MODIFY();
    //         END;

    //         // 
    //     end;

    //     procedure RebuildDispolineOnTransferLine(var rrc_TransferLine: Record "5741")
    //     var
    //         lrc_Dispolines: Record "POI Dispolines";
    //     begin
    //         // 
    //         IF (rrc_TransferLine."Document No." = '') OR (rrc_TransferLine."Line No." = 0) THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //         lrc_Dispolines.SETRANGE("Document Type",lrc_Dispolines."Document Type"::"Transfer Order");
    //         lrc_Dispolines.SETRANGE("Document No.",rrc_TransferLine."Document No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No.",rrc_TransferLine."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           IF rrc_TransferLine."Quantity Shipped" <> 0 THEN BEGIN
    //             lrc_Dispolines.DELETEALL(TRUE);
    //           END ELSE BEGIN
    //             REPEAT
    //               IF lrc_Dispolines."Created From Dispoline" <> 0D THEN BEGIN
    //                 // Prüfen, ob Folgebeleg Planung vorhanden ist
    //                 IF (lrc_Dispolines."Document Type 2" <> lrc_Dispolines."Document Type 2"::Position) AND
    //                    (lrc_Dispolines."Document No. 2" <> '') AND (lrc_Dispolines."Document Line Line No. 2" <> 0)
    //                 THEN BEGIN
    //                   ERROR(AGILESText001,rrc_TransferLine.TABLECAPTION,rrc_TransferLine."Document No.",rrc_TransferLine."Line No.");
    //                 END;

    //                 RebuildPositionDispoline(lrc_Dispolines);
    //               END;
    //             UNTIL lrc_Dispolines.next() = 0;
    //             lrc_Dispolines.DELETEALL(TRUE);
    //           END;

    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type 2","Document No. 2","Document Line Line No. 2");
    //         lrc_Dispolines.SETRANGE("Document Type 2",lrc_Dispolines."Document Type"::"Transfer Order");
    //         lrc_Dispolines.SETRANGE("Document No. 2",rrc_TransferLine."Document No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No. 2",rrc_TransferLine."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           // Prüfen, ob Folgebeleg Planung vorhanden ist
    //           IF (lrc_Dispolines."Document Type 3" <> lrc_Dispolines."Document Type 3"::Position) AND
    //              (lrc_Dispolines."Document No. 3" <> '') AND (lrc_Dispolines."Document Line Line No. 3" <> 0)
    //           THEN BEGIN
    //             ERROR(AGILESText001,rrc_TransferLine.TABLECAPTION,rrc_TransferLine."Document No.",rrc_TransferLine."Line No.");
    //           END ELSE BEGIN
    //             lrc_Dispolines."Document Type 2" := lrc_Dispolines."Document Type 2"::Position;
    //             lrc_Dispolines."Document No. 2" := '';
    //             lrc_Dispolines."Document Line Line No. 2" := 0;
    //             lrc_Dispolines."Document Type 3" := lrc_Dispolines."Document Type 3"::Position;
    //             lrc_Dispolines."Document No. 3" := '';
    //             lrc_Dispolines."Document Line Line No. 3" := 0;
    //             lrc_Dispolines.MODIFY();
    //           END;

    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type 3","Document No. 3","Document Line Line No. 3");
    //         lrc_Dispolines.SETRANGE("Document Type 3",lrc_Dispolines."Document Type"::"Transfer Order");
    //         lrc_Dispolines.SETRANGE("Document No. 3",rrc_TransferLine."Document No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No. 3",rrc_TransferLine."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           lrc_Dispolines."Document Type 3" := lrc_Dispolines."Document Type 3"::Position;
    //           lrc_Dispolines."Document No. 3" := '';
    //           lrc_Dispolines."Document Line Line No. 3" := 0;
    //           lrc_Dispolines.MODIFY();
    //         END;

    //         // 
    //     end;

    //     procedure RebuildDispolineOnPackOutput(var rrc_PackOrderOutputItems: Record "5110713")
    //     var
    //         lrc_Dispolines: Record "POI Dispolines";
    //     begin
    //         // 
    //         IF (rrc_PackOrderOutputItems."Doc. No." = '') OR (rrc_PackOrderOutputItems."Line No." = 0) THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //         lrc_Dispolines.SETRANGE("Document Type",lrc_Dispolines."Document Type"::"Packing Order");
    //         lrc_Dispolines.SETRANGE("Document No.",rrc_PackOrderOutputItems."Doc. No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No.",rrc_PackOrderOutputItems."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           IF rrc_PackOrderOutputItems."Quantity Produced" <> 0 THEN BEGIN
    //             lrc_Dispolines.DELETEALL(TRUE);
    //           END ELSE BEGIN
    //             REPEAT
    //               IF lrc_Dispolines."Created From Dispoline" <> 0D THEN BEGIN
    //                 // Prüfen, ob Folgebeleg Planung vorhanden ist
    //                 IF (lrc_Dispolines."Document Type 2" <> lrc_Dispolines."Document Type 2"::Position) AND
    //                    (lrc_Dispolines."Document No. 2" <> '') AND (lrc_Dispolines."Document Line Line No. 2" <> 0)
    //                 THEN BEGIN
    //                   ERROR(AGILESText001,rrc_PackOrderOutputItems.TABLECAPTION,rrc_PackOrderOutputItems."Doc. No.",
    //                                       rrc_PackOrderOutputItems."Line No.");
    //                 END;

    //                 RebuildPositionDispoline(lrc_Dispolines);
    //               END;
    //             UNTIL lrc_Dispolines.next() = 0;
    //             lrc_Dispolines.DELETEALL(TRUE);
    //           END;

    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type 2","Document No. 2","Document Line Line No. 2");
    //         lrc_Dispolines.SETRANGE("Document Type 2",lrc_Dispolines."Document Type"::"Packing Order");
    //         lrc_Dispolines.SETRANGE("Document No. 2",rrc_PackOrderOutputItems."Doc. No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No. 2",rrc_PackOrderOutputItems."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           // Prüfen, ob Folgebeleg Planung vorhanden ist
    //           IF (lrc_Dispolines."Document Type 3" <> lrc_Dispolines."Document Type 3"::Position) AND
    //              (lrc_Dispolines."Document No. 3" <> '') AND (lrc_Dispolines."Document Line Line No. 3" <> 0)
    //           THEN BEGIN
    //             ERROR(AGILESText001,rrc_PackOrderOutputItems.TABLECAPTION,rrc_PackOrderOutputItems."Doc. No.",
    //                                 rrc_PackOrderOutputItems."Line No.");
    //           END ELSE BEGIN
    //             lrc_Dispolines."Document Type 2" := lrc_Dispolines."Document Type 2"::Position;
    //             lrc_Dispolines."Document No. 2" := '';
    //             lrc_Dispolines."Document Line Line No. 2" := 0;
    //             lrc_Dispolines."Document Type 3" := lrc_Dispolines."Document Type 3"::Position;
    //             lrc_Dispolines."Document No. 3" := '';
    //             lrc_Dispolines."Document Line Line No. 3" := 0;
    //             lrc_Dispolines.MODIFY();
    //           END;

    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type 3","Document No. 3","Document Line Line No. 3");
    //         lrc_Dispolines.SETRANGE("Document Type 3",lrc_Dispolines."Document Type"::"Packing Order");
    //         lrc_Dispolines.SETRANGE("Document No. 3",rrc_PackOrderOutputItems."Doc. No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No. 3",rrc_PackOrderOutputItems."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           lrc_Dispolines."Document Type 3" := lrc_Dispolines."Document Type 3"::Position;
    //           lrc_Dispolines."Document No. 3" := '';
    //           lrc_Dispolines."Document Line Line No. 3" := 0;
    //           lrc_Dispolines.MODIFY();
    //         END;

    //         // 
    //     end;

    //     procedure RebuildDispolineOnPackInput(var rrc_PackOrderInputItems: Record "5110714")
    //     var
    //         lrc_Dispolines: Record "POI Dispolines";
    //     begin
    //         // Funktion prüft nur, ob eine Inputzeile gelöscht werden darf
    //         IF (rrc_PackOrderInputItems."Doc. No." = '') OR (rrc_PackOrderInputItems."Line No." = 0) THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //         lrc_Dispolines.SETRANGE("Document Type",lrc_Dispolines."Document Type"::"Packing Order");
    //         lrc_Dispolines.SETRANGE("Document No.",rrc_PackOrderInputItems."Doc. No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No.",10000);

    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF lrc_Dispolines."Created From Dispoline" <> 0D THEN BEGIN
    //               // Prüfen, ob Folgebeleg Planung vorhanden ist
    //               IF (lrc_Dispolines."Document Type 2" <> lrc_Dispolines."Document Type 2"::Position) AND
    //                  (lrc_Dispolines."Document No. 2" <> '') AND (lrc_Dispolines."Document Line Line No. 2" <> 0)
    //               THEN BEGIN
    //                 ERROR(AGILESText001,rrc_PackOrderInputItems.TABLECAPTION,rrc_PackOrderInputItems."Doc. No.",10000);
    //               END;

    //             END;
    //           UNTIL lrc_Dispolines.next() = 0;

    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type 2","Document No. 2","Document Line Line No. 2");
    //         lrc_Dispolines.SETRANGE("Document Type 2",lrc_Dispolines."Document Type"::"Packing Order");
    //         lrc_Dispolines.SETRANGE("Document No. 2",rrc_PackOrderInputItems."Doc. No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No. 2",10000);
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           // Prüfen, ob Folgebeleg Planung vorhanden ist
    //           IF (lrc_Dispolines."Document Type 3" <> lrc_Dispolines."Document Type 3"::Position) AND
    //              (lrc_Dispolines."Document No. 3" <> '') AND (lrc_Dispolines."Document Line Line No. 3" <> 0)
    //           THEN
    //             ERROR(AGILESText001,rrc_PackOrderInputItems.TABLECAPTION,rrc_PackOrderInputItems."Doc. No.",10000);
    //           EXIT;
    //         END;
    //     end;

    procedure ShowNextDocPlanForTransferLine(var rrc_TransferLine: Record "Transfer Line")
    begin
        IF (rrc_TransferLine."Document No." = '') OR (rrc_TransferLine."Line No." = 0) THEN
            EXIT;
        lrc_Dispolines.reset();
        lrc_Dispolines.SETCURRENTKEY("Document Type", "Document No.", "Document Line Line No.", "Line No.");
        lrc_Dispolines.SETRANGE("Document Type", lrc_Dispolines."Document Type"::"Transfer Order");
        lrc_Dispolines.SETRANGE("Document No.", rrc_TransferLine."Document No.");
        lrc_Dispolines.SETRANGE("Document Line Line No.", rrc_TransferLine."Line No.");
        IF lrc_Dispolines.FIND('-') THEN BEGIN
            IF (lrc_Dispolines."Document Type 2" <> lrc_Dispolines."Document Type 2"::Position) AND
               (lrc_Dispolines."Document No. 2" <> '') AND (lrc_Dispolines."Document Line Line No. 2" <> 0)
            THEN
                lrc_Dispolines.ShowDocument2();
            EXIT;
        END;
        lrc_Dispolines.reset();
        lrc_Dispolines.SETCURRENTKEY("Document Type 2", "Document No. 2", "Document Line Line No. 2");
        lrc_Dispolines.SETRANGE("Document Type 2", lrc_Dispolines."Document Type 2"::"Transfer Order");
        lrc_Dispolines.SETRANGE("Document No. 2", rrc_TransferLine."Document No.");
        lrc_Dispolines.SETRANGE("Document Line Line No. 2", rrc_TransferLine."Line No.");
        IF lrc_Dispolines.FIND('-') THEN BEGIN
            IF (lrc_Dispolines."Document Type 3" <> lrc_Dispolines."Document Type 3"::Position) AND
               (lrc_Dispolines."Document No. 3" <> '') AND (lrc_Dispolines."Document Line Line No. 3" <> 0)
            THEN
                lrc_Dispolines.ShowDocument3();
            EXIT;
        END;
    end;

    //     procedure ShowNextDocPlanForPackOutpLine(var rrc_PackOrderOutputItems: Record "5110713")
    //     var
    //         lrc_Dispolines: Record "POI Dispolines";
    //     begin
    //         //Doc. No.,Line No.
    //         IF (rrc_PackOrderOutputItems."Doc. No." = '') OR (rrc_PackOrderOutputItems."Line No." = 0) THEN
    //           EXIT;
    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //         lrc_Dispolines.SETRANGE("Document Type",lrc_Dispolines."Document Type"::"Packing Order");
    //         lrc_Dispolines.SETRANGE("Document No.",rrc_PackOrderOutputItems."Doc. No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No.",rrc_PackOrderOutputItems."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           IF (lrc_Dispolines."Document Type 2" <> lrc_Dispolines."Document Type 2"::Position) AND
    //              (lrc_Dispolines."Document No. 2" <> '') AND (lrc_Dispolines."Document Line Line No. 2" <> 0)
    //           THEN
    //             lrc_Dispolines.ShowDocument2();
    //           EXIT;
    //         END;

    //         lrc_Dispolines.reset();
    //         lrc_Dispolines.SETCURRENTKEY("Document Type 2","Document No. 2","Document Line Line No. 2");
    //         lrc_Dispolines.SETRANGE("Document Type 2",lrc_Dispolines."Document Type 2"::"Packing Order");
    //         lrc_Dispolines.SETRANGE("Document No. 2",rrc_PackOrderOutputItems."Doc. No.");
    //         lrc_Dispolines.SETRANGE("Document Line Line No. 2",rrc_PackOrderOutputItems."Line No.");
    //         IF lrc_Dispolines.FIND('-') THEN BEGIN
    //           IF (lrc_Dispolines."Document Type 3" <> lrc_Dispolines."Document Type 3"::Position) AND
    //              (lrc_Dispolines."Document No. 3" <> '') AND (lrc_Dispolines."Document Line Line No. 3" <> 0)
    //           THEN
    //             lrc_Dispolines.ShowDocument3();
    //           EXIT;
    //         END;
    //     end;

    //     procedure UpdateAssignedLines(vva_Variant: Variant;vva_xRecVariant: Variant;vin_TableNo: Integer;vin_FieldNo: Integer)
    //     var
    //         lrc_SalesLine: Record "37";
    //         lrc_TransferLine: Record "5741";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_Dispolines: Record "POI Dispolines";
    //         lrc_xRecSalesLine: Record "37";
    //         lrc_xRecTransferLine: Record "5741";
    //         lrc_xRecPackOrderInputItems: Record "5110714";
    //         lrc_xRecPackOrderOutputItems: Record "5110713";
    //         lrc_xRecDispolines: Record "POI Dispolines";
    //     begin
    //         CASE vin_TableNo OF
    //           DATABASE::"Sales Line":
    //             BEGIN

    //               lrc_SalesLine := vva_Variant;
    //               lrc_xRecSalesLine := vva_xRecVariant;

    //               // Suchen auf der ersten Belegebene
    //               lrc_Dispolines.reset();
    //               lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //               lrc_Dispolines.SETRANGE("Document Type",lrc_Dispolines."Document Type"::Order);
    //               lrc_Dispolines.SETRANGE("Document No.",lrc_SalesLine."Document No.");
    //               lrc_Dispolines.SETRANGE("Document Line Line No.",lrc_SalesLine."Line No.");
    //               IF lrc_Dispolines.FIND('-') THEN BEGIN

    //                 // Aktualisierung Positionsplanungszeile
    //                 lrc_Dispolines.SetIndirectCall(TRUE);
    //                 CASE vin_FieldNo OF
    //                   lrc_SalesLine.FIELDNO(Quantity):
    //                     BEGIN
    //                       lrc_Dispolines.VALIDATE(Quantity,lrc_SalesLine.Quantity);
    //                     END;
    //                 END;
    //                 lrc_Dispolines.MODIFY(TRUE);

    //                 // Aktualisierung Belegebene 2 und 3
    //                 CASE vin_FieldNo OF
    //                   lrc_SalesLine.FIELDNO(Quantity):
    //                     BEGIN
    //                       IF lrc_SalesLine.Quantity >= lrc_xRecSalesLine.Quantity THEN BEGIN
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                       END ELSE BEGIN
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                       END;
    //                     END;
    //                 END;
    //               END;
    //             END;
    //           DATABASE::"Transfer Line":
    //             BEGIN
    //               lrc_TransferLine := vva_Variant;
    //               lrc_xRecTransferLine := vva_xRecVariant;
    //               // Suchen auf der ersten Belegebene
    //               lrc_Dispolines.reset();
    //               lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //               lrc_Dispolines.SETRANGE("Document Type",lrc_Dispolines."Document Type"::"Transfer Order");
    //               lrc_Dispolines.SETRANGE("Document No.",lrc_TransferLine."Document No.");
    //               lrc_Dispolines.SETRANGE("Document Line Line No.",lrc_TransferLine."Line No.");
    //               IF lrc_Dispolines.FIND('-') THEN BEGIN
    //                 // Aktualisierung Positionsplanungszeile
    //                 lrc_Dispolines.SetIndirectCall(TRUE);
    //                 CASE vin_FieldNo OF
    //                   lrc_TransferLine.FIELDNO(Quantity):
    //                       lrc_Dispolines.VALIDATE(Quantity,lrc_TransferLine.Quantity);
    //                 END;
    //                 lrc_Dispolines.MODIFY(TRUE)
    //                 // Aktualisierung Belegebene 2 und 3
    //                 CASE vin_FieldNo OF
    //                   lrc_TransferLine.FIELDNO(Quantity):
    //                     BEGIN
    //                       IF lrc_TransferLine.Quantity >= lrc_xRecTransferLine.Quantity THEN BEGIN
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                       END ELSE BEGIN
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                       END;
    //                     END;
    //                 END;
    //               END;
    //             END;
    //           DATABASE::"Pack. Order Input Items":
    //             BEGIN
    //               lrc_PackOrderInputItems := vva_Variant;
    //               lrc_xRecPackOrderInputItems := vva_xRecVariant;
    //               // Outputzeile ermitteln
    //               IF NOT lrc_PackOrderOutputItems.GET(lrc_PackOrderInputItems."Doc. No.",lrc_PackOrderInputItems."Line No.") THEN
    //                 EXIT;
    //               // Suchen auf der ersten Belegebene
    //               lrc_Dispolines.reset();
    //               lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //               lrc_Dispolines.SETRANGE("Document Type",lrc_Dispolines."Document Type"::"Packing Order");
    //               lrc_Dispolines.SETRANGE("Document No.",lrc_PackOrderOutputItems."Doc. No.");
    //               lrc_Dispolines.SETRANGE("Document Line Line No.",lrc_PackOrderOutputItems."Line No.");
    //               IF lrc_Dispolines.FIND('-') THEN BEGIN
    //                 // Aktualisierung Positionsplanungszeile
    //                 lrc_Dispolines.SetIndirectCall(TRUE);
    //                 CASE vin_FieldNo OF
    //                   lrc_PackOrderOutputItems.FIELDNO(Quantity):
    //                       lrc_Dispolines.VALIDATE(Quantity,lrc_PackOrderOutputItems.Quantity);
    //                 END;
    //                 lrc_Dispolines.MODIFY(TRUE);
    //                 // Aktualisierung Belegebene 2 und 3
    //                 CASE vin_FieldNo OF
    //                   lrc_PackOrderOutputItems.FIELDNO(Quantity):
    //                     BEGIN
    //                       IF lrc_PackOrderOutputItems.Quantity >= lrc_xRecPackOrderOutputItems.Quantity THEN BEGIN
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                       END ELSE BEGIN
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                       END;
    //                     END;
    //                 END;
    //               END;
    //             END;
    //           DATABASE::"Pack. Order Output Items":
    //             BEGIN
    //               lrc_PackOrderOutputItems := vva_Variant;
    //               lrc_xRecPackOrderOutputItems := vva_xRecVariant;
    //               // Suchen auf der ersten Belegebene
    //               lrc_Dispolines.reset();
    //               lrc_Dispolines.SETCURRENTKEY("Document Type","Document No.","Document Line Line No.","Line No.");
    //               lrc_Dispolines.SETRANGE("Document Type",lrc_Dispolines."Document Type"::"Packing Order");
    //               lrc_Dispolines.SETRANGE("Document No.",lrc_PackOrderOutputItems."Doc. No.");
    //               lrc_Dispolines.SETRANGE("Document Line Line No.",lrc_PackOrderOutputItems."Line No.");
    //               IF lrc_Dispolines.FIND('-') THEN BEGIN
    //                 // Aktualisierung Positionsplanungszeile
    //                 lrc_Dispolines.SetIndirectCall(TRUE);
    //                 CASE vin_FieldNo OF
    //                   lrc_PackOrderOutputItems.FIELDNO(Quantity):
    //                       lrc_Dispolines.VALIDATE(Quantity,lrc_PackOrderOutputItems.Quantity);
    //                 END;
    //                 lrc_Dispolines.MODIFY(TRUE);
    //                 // Aktualisierung Belegebene 2 und 3
    //                 CASE vin_FieldNo OF
    //                   lrc_PackOrderOutputItems.FIELDNO(Quantity):
    //                     BEGIN
    //                       IF lrc_PackOrderOutputItems.Quantity >= lrc_xRecPackOrderOutputItems.Quantity THEN BEGIN
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                       END ELSE BEGIN
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                         lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                       END;
    //                     END;
    //                 END;
    //               END;
    //             END;
    //           DATABASE::Dispolines:
    //             BEGIN
    //               lrc_Dispolines := vva_Variant;
    //               lrc_xRecDispolines := vva_xRecVariant;
    //               // Aktualisierung Belegebene 1, 2 und 3
    //               CASE vin_FieldNo OF
    //                 lrc_Dispolines.FIELDNO(Quantity):
    //                   BEGIN
    //                     IF lrc_Dispolines.Quantity >= lrc_xRecDispolines.Quantity THEN BEGIN
    //                       lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),1);
    //                       lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                       lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                     END ELSE BEGIN
    //                       lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),3);
    //                       lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),2);
    //                       lrc_Dispolines.UpdateAssignLineFromDispoline(lrc_Dispolines.FIELDNO(Quantity),1);
    //                     END;
    //                   END;
    //               END;
    //             END;
    //         END;
    //     end;

    var

    var
        lrc_Dispolines: Record "POI Dispolines";
}

