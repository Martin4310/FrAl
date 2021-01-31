codeunit 5110322 "POI Transfer Management"
{

    //     procedure SelectTransferDocType(vbn_GlobalCard: Boolean): Code[10]
    //     var
    //         lrc_TransferDocType: Record "5110412";
    //         //lfm_TransferDocTypeList: Form "5110410";
    //         lrc_UserSetup: Record "User Setup";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Auswahl der Belegunterart
    //         // -----------------------------------------------------------------------------

    //         lrc_TransferDocType.FILTERGROUP(2);
    //         lrc_TransferDocType.SETRANGE("In Selection List",TRUE);
    //         IF lrc_UserSetup.GET(Userid()) THEN BEGIN
    //         ////  IF lrc_UserSetup."Transfer Doc. Subtype Filter" <> '' THEN BEGIN
    //         ////    lrc_TransferDocType.SETFILTER(Code, lrc_UserSetup."Transfer Doc. Subtype Filter");
    //         ////  END;
    //         END;
    //         lrc_TransferDocType.FILTERGROUP(0);
    //         IF lrc_TransferDocType.COUNT() > 1 THEN BEGIN
    //           lfm_TransferDocTypeList.LOOKUPMODE := TRUE;
    //           lfm_TransferDocTypeList.SETTABLEVIEW(lrc_TransferDocType);
    //           IF lfm_TransferDocTypeList.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT('');
    //           lrc_TransferDocType.Reset();
    //           lfm_TransferDocTypeList.GETRECORD(lrc_TransferDocType);
    //         END ELSE BEGIN
    //           IF NOT lrc_TransferDocType.FIND('-') THEN
    //             EXIT('');
    //         END;

    //         EXIT(lrc_TransferDocType.Code);
    //     end;

    procedure ShowTransferOrder(vco_TransferNo: Code[20]; vco_TransferDocSubType: Code[10])
    var
        lrc_TransferDocSubtype: Record "POI Transfer Doc. Subtype";
        lrc_TransferHdr: Record "Transfer Header";
    begin
        // --------------------------------------------------------------------------
        // Funktion zur Anzeige Umlagerungsauftrag
        // --------------------------------------------------------------------------

        lrc_TransferDocSubtype.GET(vco_TransferDocSubType);

        lrc_TransferHdr.FILTERGROUP(2);
        lrc_TransferHdr.SETRANGE("No.", vco_TransferNo);
        lrc_TransferHdr.FILTERGROUP(0);

        Page.RUN(lrc_TransferDocSubtype."Page ID Transfer Order Card", lrc_TransferHdr);
    end;

    //     procedure NewTransferOrder(vco_TransferDocType: Code[10])
    //     var
    //         lrc_TransferDocType: Record "5110412";
    //         lrc_TransferHdr: Record "5740";
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zur Neuanlage Umlagerungsauftrag
    //         // --------------------------------------------------------------------------

    //         lrc_TransferHdr.Reset();
    //         lrc_TransferHdr.INIT();
    //         lrc_TransferHdr."No." := '';
    //         lrc_TransferHdr.INSERT(TRUE);

    //         IF vco_TransferDocType = '' THEN BEGIN
    //           lrc_TransferDocType.SETRANGE(Code,'');
    //           IF lrc_TransferDocType.FINDFIRST() THEN BEGIN
    //             lrc_TransferHdr."In-Transit Code" := lrc_TransferDocType."Transit Location Code";
    //             lrc_TransferHdr.MODIFY( TRUE );
    //           END;
    //         END ELSE BEGIN
    //           lrc_TransferHdr.VALIDATE("Transfer Doc. Subtype Code", vco_TransferDocType);
    //           lrc_TransferHdr.MODIFY(TRUE);
    //         END;

    //         // Umlagerungskarte öffnen
    //         ShowTransferOrder(lrc_TransferHdr."No.",vco_TransferDocType);
    //     end;

    //     procedure PostShipRec(vrc_TransferHeader: Record "5740")
    //     var
    //         lcu_TransferOrderPostShipment: Codeunit "5704";
    //         lcu_TransferOrderPostReceipt: Codeunit "5705";
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zum Buchen Umlagerungsausgang und Umlagerungseingang
    //         // --------------------------------------------------------------------------

    //         lcu_TransferOrderPostShipment.RUN(vrc_TransferHeader);
    //         COMMIT;
    //         lcu_TransferOrderPostReceipt.RUN(vrc_TransferHeader);
    //         COMMIT;
    //     end;

    //     procedure ReleaseReceiptOwnLoc(vrc_TransferHdr: Record "5740")
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zum Freigabe Wareneingang aus Umlagerung in eigenes Lager
    //         // --------------------------------------------------------------------------
    //     end;

    //     procedure FillArrShippingAgent(vco_DocNo: Code[20];var rco_ArrResult: array [1000] of Code[20])
    //     var
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //         lrc_TransferHeader: Record "5740";
    //         lrc_TransferLine: Record "5741";
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Füllen eines Array mit allen Shipping Agents
    //         // ---------------------------------------------------------------------------------------

    //         lin_ArrZähler := 0;

    //         lrc_TransferHeader.GET(vco_DocNo);

    //         lrc_TransferLine.SETRANGE("Document No.",lrc_TransferHeader."No.");
    //         lrc_TransferLine.SETFILTER("Shipping Agent Code",'<>%1','');
    //         IF lrc_TransferLine.FIND('-') THEN
    //           REPEAT
    //             IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult,10,lrc_TransferLine."Shipping Agent Code") = 0 THEN BEGIN
    //               lin_ArrZähler := lin_ArrZähler + 1;
    //               rco_ArrResult[lin_ArrZähler] := lrc_TransferLine."Shipping Agent Code";
    //             END;
    //           UNTIL lrc_TransferLine.NEXT() = 0;
    //     end;

    //     procedure FillArrLocation(vco_DocNo: Code[20];var rco_ArrResult: array [1000] of Code[20])
    //     var
    //         lcu_GlobalFunctions: Codeunit "5110300";
    //         lrc_TransferHeader: Record "5740";
    //         lrc_TransferLine: Record "5741";
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Füllen eines Array mit allen Location
    //         // ---------------------------------------------------------------------------------------

    //         lin_ArrZähler := 0;

    //         lrc_TransferHeader.GET(vco_DocNo);

    //         lrc_TransferLine.SETRANGE("Document No.",lrc_TransferHeader."No.");
    //         lrc_TransferLine.SETFILTER("Transfer-from Code",'<>%1','');
    //         IF lrc_TransferLine.FIND('-') THEN
    //           REPEAT
    //             IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult,10,lrc_TransferLine."Transfer-from Code") = 0 THEN BEGIN
    //               lin_ArrZähler := lin_ArrZähler + 1;
    //               rco_ArrResult[lin_ArrZähler] := lrc_TransferLine."Transfer-from Code";
    //             END;
    //           UNTIL lrc_TransferLine.NEXT() = 0;
    //     end;

    //     procedure LoadItemFromPurchOrder(vrc_TransferHeader: Record "5740")
    //     var
    //         lrc_PurchHeader: Record "38";
    //         lrc_PurchLine: Record "39";
    //         lrc_TransferLine: Record "5741";
    //         lfm_PurchOrderList: Form "5110330";
    //         lin_LineNo: Integer;
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Laden der Umlagerungszeilen aus einer Einkaufsbestellung
    //         // ---------------------------------------------------------------------------------------

    //         vrc_TransferHeader.TESTFIELD("Transfer-from Code");

    //         lrc_PurchHeader.FILTERGROUP(2);
    //         lrc_PurchHeader.SETRANGE("Document Type",lrc_PurchHeader."Document Type"::Order);
    //         lrc_PurchHeader.FILTERGROUP(0);
    //         lrc_PurchHeader.SETRANGE("Location Code",vrc_TransferHeader."Transfer-from Code");

    //         lfm_PurchOrderList.SETTABLEVIEW(lrc_PurchHeader);
    //         lfm_PurchOrderList.LOOKUPMODE := TRUE;
    //         IF lfm_PurchOrderList.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_PurchHeader.Reset();
    //         lfm_PurchOrderList.GETRECORD(lrc_PurchHeader);


    //         lrc_TransferLine.Reset();
    //         lrc_TransferLine.SETRANGE("Document No.",vrc_TransferHeader."No.");
    //         IF lrc_TransferLine.FINDLAST THEN
    //           lin_LineNo := lrc_TransferLine."Line No."
    //         ELSE
    //           lin_LineNo := 0;


    //         lrc_PurchLine.Reset();
    //         lrc_PurchLine.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //         lrc_PurchLine.SETRANGE("Document No.",lrc_PurchHeader."No.");
    //         lrc_PurchLine.SETRANGE(Type,lrc_PurchLine.Type::Item);
    //         lrc_PurchLine.SETFILTER("No.",'<>%1','');
    //         lrc_PurchLine.SETRANGE("Location Code",vrc_TransferHeader."Transfer-from Code");
    //         IF lrc_PurchLine.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_TransferLine.Reset();
    //             lrc_TransferLine.INIT();
    //             lrc_TransferLine."Document No." := vrc_TransferHeader."No.";
    //             lin_LineNo := lin_LineNo + 10000;
    //             lrc_TransferLine."Line No." := lin_LineNo;
    //             lrc_TransferLine.VALIDATE("Transfer-from Code",vrc_TransferHeader."Transfer-from Code");
    //             lrc_TransferLine.VALIDATE("Transfer-to Code",vrc_TransferHeader."Transfer-to Code");
    //             lrc_TransferLine.INSERT(TRUE);

    //             lrc_TransferLine.VALIDATE("Item No.",lrc_PurchLine."No.");
    //             lrc_TransferLine.VALIDATE("Batch Variant No.",lrc_PurchLine."Batch Variant No.");
    //             lrc_TransferLine.VALIDATE("Unit of Measure Code",lrc_PurchLine."Unit of Measure Code");
    //             lrc_TransferLine.VALIDATE(Quantity,lrc_PurchLine.Quantity);
    //             lrc_TransferLine.MODIFY(TRUE);

    //             // Mengen aus Einkauf setzen - Eventuell noch Bestandsprüfung einbauen!!!????
    //             lrc_TransferLine.VALIDATE("Unit of Measure Code",lrc_PurchLine."Unit of Measure Code");
    //             lrc_TransferLine.VALIDATE(Quantity,lrc_PurchLine.Quantity);
    //             lrc_TransferLine.MODIFY(TRUE);

    //           UNTIL lrc_PurchLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PostTransferLine(vco_DocumentNo: Code[20];vin_LineNo: Integer;vbn_PostShipment: Boolean;vbn_PostReceipt: Boolean)
    //     var
    //         lrc_TransferHeader: Record "5740";
    //         lrc_TransferLine: Record "5741";
    //         lrc_TransferLineTemp: Record "5741" temporary;
    //         lcu_TransferOrderPostShipment: Codeunit "5704";
    //         lcu_TransferOrderPostReceipt: Codeunit "5705";
    //     begin
    //         // UML 002 DMG50023.s
    //         // -------------------------------------------------------------------------------
    //         // Funktion für die Buchung einer Umlagerungsauftragszeile
    //         // -------------------------------------------------------------------------------
    //         IF NOT lrc_TransferHeader.GET(vco_DocumentNo) THEN BEGIN
    //           EXIT;
    //         END;

    //         // Alle anderen Zeilen im Uml. Auftrag merken und aus der Buchung ausschliessen
    //         lrc_TransferLineTemp.DELETEALL(FALSE);
    //         lrc_TransferLine.Reset();
    //         lrc_TransferLine.SETRANGE("Document No.",vco_DocumentNo);
    //         lrc_TransferLine.SETFILTER("Line No.", '<>%1',vin_LineNo);
    //         IF lrc_TransferLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_TransferLineTemp := lrc_TransferLine;
    //             lrc_TransferLineTemp.INSERT(FALSE);
    //             lrc_TransferLine."Qty. to Ship" := 0;
    //             lrc_TransferLine."Qty. to Receive" := 0;
    //             lrc_TransferLine.MODIFY(FALSE);
    //           UNTIL lrc_TransferLine.NEXT() = 0;
    //         END;

    //         IF vbn_PostShipment  = TRUE THEN BEGIN
    //           lcu_TransferOrderPostShipment.RUN(lrc_TransferHeader);
    //         END;
    //         IF vbn_PostReceipt = TRUE THEN BEGIN
    //           lcu_TransferOrderPostReceipt.RUN(lrc_TransferHeader);
    //         END;

    //         // Bei gleichen Filtern wie oben die Werte in den Zeilen wiederherstellen,
    //         // wenn Uml. Auftrag noch existiert, d.h. noch nicht vollständig gebucht und danach gelöscht wurde
    //         IF NOT lrc_TransferHeader.GET(vco_DocumentNo) THEN BEGIN
    //           EXIT;
    //         END;

    //         IF lrc_TransferLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_TransferLineTemp.GET(lrc_TransferLine."Document No.",lrc_TransferLine."Line No.");
    //             lrc_TransferLine."Qty. to Ship" := lrc_TransferLineTemp."Qty. to Ship";
    //             lrc_TransferLine."Qty. to Receive" := lrc_TransferLineTemp."Qty. to Receive";
    //             lrc_TransferLine.MODIFY(FALSE);
    //           UNTIL lrc_TransferLine.NEXT() = 0;
    //         END;

    //         // UML 002 DMG50023.e
    //     end;

    //     procedure ShowTransferOrdersOnBatchVar(vco_ItemNo: Code[20];vco_BatchVariantNo: Code[20];vco_LocationCode: Code[10];vop_Type: Option "Transfer-to Location","Transfer-from Location")
    //     var
    //         lrc_TransferLine: Record "5741";
    //         lrc_TransferHeader: Record "5740";
    //     begin
    //         // UML 003 DMG50088.s
    //         lrc_TransferLine.Reset();
    //         lrc_TransferLine.SETCURRENTKEY("Item No.","Batch Variant No.");
    //         lrc_TransferLine.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_TransferLine.SETRANGE("Batch Variant No.",vco_BatchVariantNo);
    //         IF vop_Type = vop_Type::"Transfer-to Location" THEN BEGIN
    //           lrc_TransferLine.SETRANGE("Transfer-to Code", vco_LocationCode );
    //         END ELSE BEGIN
    //           lrc_TransferLine.SETRANGE("Transfer-from Code", vco_LocationCode );
    //         END;
    //         IF lrc_TransferLine.FIND('-') THEN BEGIN
    //         /*
    //           REPEAT
    //             lrc_TransferHeader."No." := lrc_TransferLine."Document No.";
    //             lrc_TransferHeader.MARK(TRUE);
    //           UNTIL lrc_TransferLine.NEXT() = 0;
    //         END;
    //         lrc_TransferHeader.MARKEDONLY(TRUE);
    //         FORM.RUNMODAL(FORM::"FV Transfer List",lrc_TransferHeader);
    //         */
    //           FORM.RUNMODAL(FORM::"Transfer Lines",lrc_TransferLine );
    //         END;
    //         // UML 003 DMG50088.e

    //     end;

    //     procedure CheckIfManualEditable(vco_TransferOrderNo: Code[20];vco_TransferDocSubtype: Code[10])
    //     var
    //         lrc_TransferHeader: Record "5740";
    //         lrc_TransferDocSubtype: Record "5110412";
    //         AGILES_LT_TEXT001: Label 'Umlagerungsauftrag kann nicht manuell geändert werden!';
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zur Prüfung ob der Umlagerungsauftrag manuell editiert werden darf
    //         // -----------------------------------------------------------------------------------------

    //         // Für NAS nicht ausführen
    //         IF NOT GUIALLOWED THEN BEGIN
    //           EXIT;
    //         END;

    //         IF vco_TransferDocSubtype = '' THEN BEGIN
    //           IF NOT lrc_TransferHeader.GET(vco_TransferOrderNo) THEN
    //             EXIT;
    //           IF NOT lrc_TransferDocSubtype.GET(lrc_TransferHeader."Transfer Doc. Subtype Code") THEN
    //             EXIT;
    //         END ELSE BEGIN
    //           IF NOT lrc_TransferDocSubtype.GET(vco_TransferDocSubtype) THEN
    //             EXIT;
    //         END;

    //         CASE lrc_TransferDocSubtype."Transfer Order Editable" OF
    //         lrc_TransferDocSubtype."Transfer Order Editable"::"Not editable":
    //           BEGIN
    //             ERROR(AGILES_LT_TEXT001);
    //           END;
    //         END;
    //     end;

    //     procedure "-- UML 005 DMG50142 F"()
    //     begin
    //     end;

    //     procedure CheckAndPostMissingInvTransfer(var rrc_TransferLineToCheck: Record "5741";vin_TransactionNo: Integer)
    //     var
    //         lrc_TransferLine: Record "5741";
    //         lrc_ItemJournalLine: Record "83";
    //         lrc_TransferHeader: Record "5740";
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // UML 005 DMG50142.s
    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Allow Trans. with Missing Inv." = FALSE THEN BEGIN
    //           EXIT;
    //         END;

    //         // Übergabeparameter wurde vorher gefiltert
    //         IF rrc_TransferLineToCheck.GETFILTERS = '' THEN BEGIN
    //           EXIT;
    //         END ELSE BEGIN
    //           lrc_TransferLine.COPY(rrc_TransferLineToCheck);
    //         END;

    //         IF lrc_TransferLine.FINDSET(FALSE,FALSE) THEN BEGIN

    //           lrc_TransferHeader.GET(lrc_TransferLine."Document No.");

    //           REPEAT

    //             lrc_ItemJournalLine.INIT();
    //             lrc_ItemJournalLine."Entry Type" := lrc_ItemJournalLine."Entry Type"::Transfer;
    //             lrc_ItemJournalLine."Item No." := lrc_TransferLine."Item No.";
    //             lrc_ItemJournalLine."Location Code" := lrc_TransferHeader."Transfer-from Code";
    //             lrc_ItemJournalLine."Posting Date" := lrc_TransferHeader."Posting Date";
    //             lrc_ItemJournalLine."Document No." := lrc_TransferHeader."No.";
    //             lrc_ItemJournalLine."Unit of Measure Code" := lrc_TransferLine."Unit of Measure Code";
    //             lrc_ItemJournalLine.Quantity := lrc_TransferLine."Qty. to Ship";
    //             lrc_ItemJournalLine."Quantity (Base)" := lrc_TransferLine."Qty. to Ship (Base)";

    //             CheckAndPostMissingInventory(lrc_ItemJournalLine,vin_TransactionNo);

    //           UNTIL lrc_TransferLine.NEXT() = 0;
    //         END;
    //         // UML 005 DMG50142.e
    //     end;

    //     procedure CheckAndPostMissingInventory(vrc_ItemJnlLineToCheck: Record "83";vin_TransactionNo: Integer)
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_Item: Record Item;
    //         lrc_MissingInvTransferPosting: Record "5087980";
    //         ldc_MissingInventoryBase: Decimal;
    //         ldc_MissingInventoryBase2: Decimal;
    //     begin
    //         /*
    //         // UML 005 DMG50142.s
    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Allow Trans. with Missing Inv." = FALSE THEN BEGIN
    //           EXIT;
    //         END;

    //         // Prüfen, ob genung Bestand vorhanden ist
    //         IF (vrc_ItemJnlLineToCheck."Item No." = '') OR (vrc_ItemJnlLineToCheck."Location Code" = '') OR
    //            (vrc_ItemJnlLineToCheck."Entry Type" <> vrc_ItemJnlLineToCheck."Entry Type"::Transfer) OR
    //            (vrc_ItemJnlLineToCheck.Quantity <= 0) THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_Item.GET(vrc_ItemJnlLineToCheck."Item No.");
    //         lrc_Item.SETFILTER("Location Filter",vrc_ItemJnlLineToCheck."Location Code");
    //         lrc_Item.CALCFIELDS(Inventory);
    //         ldc_MissingInventoryBase := lrc_Item.Inventory - vrc_ItemJnlLineToCheck."Quantity (Base)";

    //         // Vorherige Mengen ermitteln
    //         ldc_MissingInventoryBase2 := 0;
    //         lrc_MissingInvTransferPosting.Reset();
    //         lrc_MissingInvTransferPosting.SETCURRENTKEY("Caption Info1","Info 1 Visible");
    //         lrc_MissingInvTransferPosting.SETRANGE("Caption Info1",vrc_ItemJnlLineToCheck."Location Code");
    //         //xxlrc_MissingInvTransferPosting.SETRANGE("Info 1 Visible",vrc_ItemJnlLineToCheck."Item No.");
    //         //XXlrc_MissingInvTransferPosting.SETRANGE("Transaction No.",vin_TransactionNo);
    //         //xxlrc_MissingInvTransferPosting.SETFILTER("Date Finished",'%1',0D);
    //         lrc_MissingInvTransferPosting.SETRANGE("Posting Status",lrc_MissingInvTransferPosting."Posting Status"::"2");
    //         IF lrc_MissingInvTransferPosting.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             ldc_MissingInventoryBase2 := ldc_MissingInventoryBase2 + lrc_MissingInvTransferPosting."Caption Info2";
    //           UNTIL lrc_MissingInvTransferPosting.NEXT() = 0;
    //         END;

    //         // Vorzeichen drehen
    //         ldc_MissingInventoryBase := ldc_MissingInventoryBase * -1;

    //         // Vorherige Mengen einkalulieren
    //         ldc_MissingInventoryBase := ldc_MissingInventoryBase + ldc_MissingInventoryBase2;

    //         // Für das Ermitteln der vorherigen Mengen müssen alle zu buchenden Zeilen gespeichert werden (auch wo der Bestand noch reicht)
    //         // Allerdings immer mit der Fehlmengemenge 0
    //         IF ldc_MissingInventoryBase <= 0 THEN BEGIN
    //           // Anforderungsdatensatz erzeugen
    //           InsertTransferPostMissingInv(vrc_ItemJnlLineToCheck,
    //                                        0,vin_TransactionNo);
    //           EXIT;
    //         END;


    //         IF ldc_MissingInventoryBase > 0 THEN BEGIN

    //           // Anforderungsdatensatz für fehlende Bestände erzeugen
    //           InsertTransferPostMissingInv(vrc_ItemJnlLineToCheck,
    //                                        ldc_MissingInventoryBase,vin_TransactionNo);

    //           // Inventurbuchung zur Korrektur des Bestandes ausführen
    //           PostMissingInventory(vrc_ItemJnlLineToCheck."Location Code",
    //                                vrc_ItemJnlLineToCheck."Item No.",
    //                                vrc_ItemJnlLineToCheck."Posting Date",vin_TransactionNo);

    //         END;
    //         // UML 005 DMG50142.e
    //         */

    //     end;

    //     procedure GetTransactionNo(): Integer
    //     var
    //         lrc_MissingInvTransferPosting: Record "5087980";
    //     begin
    //         /*
    //         // UML 005 DMG50142.s
    //         lrc_MissingInvTransferPosting.LOCKTABLE;
    //         IF lrc_MissingInvTransferPosting.FINDLAST THEN BEGIN
    //           EXIT(lrc_MissingInvTransferPosting."Transaction No." + 1);
    //         END ELSE BEGIN
    //           EXIT(1);
    //         END;
    //         // UML 005 DMG50142.e
    //         */

    //     end;

    //     procedure InsertTransferPostMissingInv(vrc_ItemJnlLine: Record "83";vdc_MissingQuantityBase: Decimal;vin_TransactionNo: Integer)
    //     var
    //         lrc_MissingInvTransferPosting: Record "5087980";
    //         lin_EntryNo: Integer;
    //     begin
    //         /*
    //         // UML 005 DMG50142.s
    //         lrc_MissingInvTransferPosting.LOCKTABLE;
    //         IF lrc_MissingInvTransferPosting.FINDLAST THEN BEGIN
    //           lin_EntryNo := lrc_MissingInvTransferPosting."Primary Key" + 1;
    //         END ELSE BEGIN
    //           lin_EntryNo := 1;
    //         END;

    //         lrc_MissingInvTransferPosting.INIT();
    //         lrc_MissingInvTransferPosting."Primary Key" := lin_EntryNo;
    //         lrc_MissingInvTransferPosting."Transaction No." := vin_TransactionNo;
    //         lrc_MissingInvTransferPosting."Caption Info1" := vrc_ItemJnlLine."Location Code";
    //         lrc_MissingInvTransferPosting."Info 1 Visible" := vrc_ItemJnlLine."Item No.";
    //         lrc_MissingInvTransferPosting."Posting Date" := vrc_ItemJnlLine."Posting Date";
    //         lrc_MissingInvTransferPosting."Missing Quantity (Base)" := vdc_MissingQuantityBase;
    //         lrc_MissingInvTransferPosting."Caption Info2" := vrc_ItemJnlLine."Quantity (Base)";
    //         lrc_MissingInvTransferPosting."Unit of Measure Code" := vrc_ItemJnlLine."Unit of Measure Code";
    //         IF vdc_MissingQuantityBase <> 0 THEN BEGIN
    //           lrc_MissingInvTransferPosting."Posting Status" := lrc_MissingInvTransferPosting."Posting Status"::"1";
    //         END ELSE BEGIN
    //           lrc_MissingInvTransferPosting."Posting Status" := lrc_MissingInvTransferPosting."Posting Status"::"2";
    //         END;
    //         lrc_MissingInvTransferPosting."Orig. Document No." := vrc_ItemJnlLine."Document No.";
    //         lrc_MissingInvTransferPosting."Date Finished" := 0D;
    //         lrc_MissingInvTransferPosting.insert();
    //         // UML 005 DMG50142.e
    //         */

    //     end;

    //     procedure PostMissingInventory(vco_LocationCode: Code[10];vco_ItemNo: Code[20];vdt_PostingDate: Date;vin_TransactionNo: Integer)
    //     var
    //         lrc_ItemJnlLine: Record "83";
    //         lrc_MissingInvTransferPosting: Record "5087980";
    //         lco_ItemJnlTemplateName: Code[10];
    //         lin_LineNo: Integer;
    //         lrc_Item: Record Item;
    //         lrp_ReportCalculateInventory: Report "790";
    //         lcu_ItemJnlPostBatch: Codeunit "23";
    //         lcu_ItemJnlPostLine: Codeunit "22";
    //         lcu_GlobalParameterSettings: Integer;
    //         lrc_ItemJnlTemplate: Record "82";
    //         lrc_Location: Record "14";
    //         AGILESText001: Label 'APPLY TRANSFER';
    //         ldc_MissingInventory: Decimal;
    //     begin
    //         /*
    //         // UML 005 DMG50142.s
    //         lrc_MissingInvTransferPosting.Reset();
    //         lrc_MissingInvTransferPosting.SETCURRENTKEY("Caption Info1","Info 1 Visible");
    //         lrc_MissingInvTransferPosting.SETRANGE("Caption Info1",vco_LocationCode);
    //         lrc_MissingInvTransferPosting.SETRANGE("Info 1 Visible",vco_ItemNo);
    //         lrc_MissingInvTransferPosting.SETRANGE("Posting Status",lrc_MissingInvTransferPosting."Posting Status"::"1");
    //         lrc_MissingInvTransferPosting.SETRANGE("Transaction No.",vin_TransactionNo);
    //         IF lrc_MissingInvTransferPosting.FINDSET(TRUE,FALSE) THEN BEGIN
    //           REPEAT

    //             // Buchungszeile vorbereiten
    //             lin_LineNo := 10000;
    //             lrc_Item.GET(vco_ItemNo);

    //             lrc_ItemJnlLine.INIT();
    //             lrc_ItemJnlLine."Line No." := lin_LineNo;
    //             lrc_ItemJnlLine."Entry Type" := lrc_ItemJnlLine."Entry Type"::"Positive Adjmt.";
    //             lrc_ItemJnlLine.VALIDATE("Item No.",lrc_Item."No.");

    //             lrc_ItemJnlLine.VALIDATE("Posting Date",lrc_MissingInvTransferPosting."Posting Date");
    //             lrc_ItemJnlLine.VALIDATE("Document No.",AGILESText001);
    //             lrc_ItemJnlLine.VALIDATE("Location Code",lrc_MissingInvTransferPosting."Caption Info1");
    //             lrc_ItemJnlLine.VALIDATE("Unit of Measure Code",lrc_MissingInvTransferPosting."Unit of Measure Code");
    //             IF lrc_ItemJnlLine."Qty. per Unit of Measure" <> 0 THEN BEGIN
    //               ldc_MissingInventory := ROUND(lrc_MissingInvTransferPosting."Missing Quantity (Base)" /
    //                                             lrc_ItemJnlLine."Qty. per Unit of Measure",0.1);
    //             END ELSE BEGIN
    //               ldc_MissingInventory := lrc_MissingInvTransferPosting."Missing Quantity (Base)";
    //             END;
    //             lrc_ItemJnlLine.VALIDATE(Quantity,ldc_MissingInventory);
    //             lrc_ItemJnlLine.VALIDATE("Quantity (Colli)",ldc_MissingInventory);
    //             lrc_ItemJnlLine.Description := lrc_MissingInvTransferPosting."Orig. Document No.";

    //             // Ursprungssatz anpassen
    //             lrc_MissingInvTransferPosting."Posting Status" := lrc_MissingInvTransferPosting."Posting Status"::"2";
    //             lrc_MissingInvTransferPosting.Modify();

    //             // Einzelbuchung über Codeunit 22
    //             CLEAR(lcu_ItemJnlPostLine);
    //         ////    lcu_ItemJnlPostLine.SetNoInsertBatchVariantEntry(TRUE);
    //         ////    lcu_ItemJnlPostLine.SetNoCheckBatchFields(TRUE);
    //             lcu_ItemJnlPostLine.RUN(lrc_ItemJnlLine);

    //           UNTIL lrc_MissingInvTransferPosting.NEXT() = 0;
    //         END;
    //         // UML 005 DMG50142.e
    //          */

    //     end;

    //     procedure PostMissingInventoryOutbound(vin_TransactionNo: Integer)
    //     var
    //         lrc_ItemJnlLine: Record "83";
    //         lrc_MissingInvTransferPosting: Record "5087980";
    //         lco_ItemJnlTemplateName: Code[10];
    //         lin_LineNo: Integer;
    //         lcu_ItemJnlPostBatch: Codeunit "23";
    //         lcu_ItemJnlPostLine: Codeunit "22";
    //         lcu_GlobalParameterSettings: Integer;
    //         lrc_ItemJnlTemplate: Record "82";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_MissingInvTransferPosting2: Record "5087980";
    //         lrc_Item: Record Item;
    //         AGILESText001: Label 'APPLY TRANSFER';
    //         ldc_MissingInventory: Decimal;
    //     begin
    //         /*
    //         // UML 005 DMG50142.s
    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Allow Trans. with Missing Inv." = FALSE THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_MissingInvTransferPosting.Reset();
    //         lrc_MissingInvTransferPosting.SETCURRENTKEY("Date Finished");
    //         lrc_MissingInvTransferPosting.SETFILTER("Date Finished",'%1',0D);
    //         lrc_MissingInvTransferPosting.SETRANGE("Posting Status",lrc_MissingInvTransferPosting."Posting Status"::"2");
    //         lrc_MissingInvTransferPosting.SETRANGE("Transaction No.",vin_TransactionNo);

    //         // Die Sätze mit Fehlmenge 0 werden erst einmal gelöscht
    //         lrc_MissingInvTransferPosting.SETRANGE("Missing Quantity (Base)",0);
    //         IF NOT lrc_MissingInvTransferPosting.isempty()THEN BEGIN
    //           lrc_MissingInvTransferPosting.DELETEALL(FALSE);
    //         END;
    //         lrc_MissingInvTransferPosting.SETRANGE("Missing Quantity (Base)");

    //         IF lrc_MissingInvTransferPosting.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             // Buchungszeile vorbereiten
    //             lin_LineNo := 10000;
    //             lrc_Item.GET(lrc_MissingInvTransferPosting."Info 1 Visible");

    //             lrc_ItemJnlLine.INIT();
    //             lrc_ItemJnlLine."Line No." := lin_LineNo;
    //             lrc_ItemJnlLine."Entry Type" := lrc_ItemJnlLine."Entry Type"::"Negative Adjmt.";
    //             lrc_ItemJnlLine.VALIDATE("Item No.",lrc_Item."No.");

    //             lrc_ItemJnlLine.VALIDATE("Posting Date",lrc_MissingInvTransferPosting."Posting Date");
    //             lrc_ItemJnlLine.VALIDATE("Document No.",AGILESText001);
    //             lrc_ItemJnlLine.VALIDATE("Location Code",lrc_MissingInvTransferPosting."Caption Info1");
    //             lrc_ItemJnlLine.VALIDATE("Unit of Measure Code",lrc_MissingInvTransferPosting."Unit of Measure Code");
    //             IF lrc_ItemJnlLine."Qty. per Unit of Measure" <> 0 THEN BEGIN
    //               ldc_MissingInventory := ROUND(lrc_MissingInvTransferPosting."Missing Quantity (Base)" /
    //                                             lrc_ItemJnlLine."Qty. per Unit of Measure",0.1);
    //             END ELSE BEGIN
    //               ldc_MissingInventory := lrc_MissingInvTransferPosting."Missing Quantity (Base)";
    //             END;
    //             lrc_ItemJnlLine.VALIDATE(Quantity,ldc_MissingInventory);
    //             lrc_ItemJnlLine.VALIDATE("Quantity (Colli)",ldc_MissingInventory);
    //             lrc_ItemJnlLine.Description := lrc_MissingInvTransferPosting."Orig. Document No.";

    //             // Ursprungssatz anpassen
    //             lrc_MissingInvTransferPosting2 := lrc_MissingInvTransferPosting;
    //             lrc_MissingInvTransferPosting2."Posting Status" := lrc_MissingInvTransferPosting2."Posting Status"::"3";
    //             lrc_MissingInvTransferPosting2."Date Finished" := TODAY;
    //             lrc_MissingInvTransferPosting2.Modify();

    //             // Einzelbuchung über Codeunit 22
    //             CLEAR(lcu_ItemJnlPostLine);
    //         ////    lcu_ItemJnlPostLine.SetNoInsertBatchVariantEntry(TRUE);
    //         ////    lcu_ItemJnlPostLine.SetNoCheckBatchFields(TRUE);
    //             lcu_ItemJnlPostLine.RUN(lrc_ItemJnlLine);

    //           UNTIL lrc_MissingInvTransferPosting.NEXT() = 0;
    //         END;
    //         // UML 005 DMG50142.e
    //          */

    //     end;
}

