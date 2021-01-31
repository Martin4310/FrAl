codeunit 50014 "POI Pallet Management"
{
    procedure ActualFieldsFromPackOrdHeader(ChangedFieldName: Text[100]; rrc_RecPackOrderHeader: Record "POI Pack. Order Header"; rrc_xRecPackOrderHeader: Record "POI Pack. Order Header")
    // var
    //     lrc_IncomingPallet: Record "5110445";
    //     lrc_PalletItemLines: Record "5110503";
    //     lbn_UpdateConfirmed: Boolean;
    //     Agiles001Txt: Label 'You have modified %1.\\';
    //     Agiles002Txt: Label 'Do you want to update the existing %2 incoming pallet lines?';
    //     lbn_Modified: Boolean;
    //     Agiles003Txt: Label 'Do you want to update the existing %2 pallet - item lines?';
    begin
        //     IF rrc_RecPackOrderHeader."Pallet Entry ID" = 0 THEN
        //         EXIT;

        //     // Incoming Pallet Lines
        //     lrc_IncomingPallet.RESET();
        //     lrc_IncomingPallet.SETRANGE("Entry No.", rrc_RecPackOrderHeader."Pallet Entry ID");
        //     IF lrc_IncomingPallet.FIND('-') THEN BEGIN

        //         IF NOT GUIALLOWED() THEN
        //             lbn_UpdateConfirmed := TRUE
        //     END ELSE BEGIN
        //         CASE ChangedFieldName OF
        //             rrc_RecPackOrderHeader.FIELDCAPTION("Pack.-by Name"):
        //                 lbn_UpdateConfirmed := TRUE;
        //             rrc_RecPackOrderHeader.FIELDCAPTION("Pack.-by Vendor No."):
        //                 lbn_UpdateConfirmed := FALSE;
        //             rrc_RecPackOrderHeader.FIELDCAPTION("Person in Charge Code"):
        //                 lbn_UpdateConfirmed := FALSE;
        //             rrc_RecPackOrderHeader.FIELDCAPTION("Owner Vendor No."):
        //                 lbn_UpdateConfirmed := FALSE;
        //             rrc_RecPackOrderHeader.FIELDCAPTION(Owner):
        //                 lbn_UpdateConfirmed := TRUE;
        //             ELSE
        //                 lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(Agiles001 + Agiles002, ChangedFieldName, lrc_IncomingPallet.COUNT()));
        //         END;

        //         REPEAT
        //             lbn_Modified := FALSE;
        //             CASE ChangedFieldName OF
        //                 rrc_RecPackOrderHeader.FIELDCAPTION("Pack.-by Name"), rrc_RecPackOrderHeader.FIELDCAPTION(Owner),
        //                rrc_RecPackOrderHeader.FIELDCAPTION("Pack.-by Vendor No."), rrc_RecPackOrderHeader.FIELDCAPTION("Owner Vendor No."):
        //                     IF lbn_UpdateConfirmed THEN BEGIN
        //                         IF rrc_xRecPackOrderHeader."Owner Vendor No." <> '' THEN BEGIN
        //                             IF (lrc_IncomingPallet."Owner Vendor No." = rrc_xRecPackOrderHeader."Owner Vendor No.") OR
        //                                (lrc_IncomingPallet."Owner Vendor No." = '') THEN BEGIN
        //                                 lrc_IncomingPallet.VALIDATE("Owner Vendor No.", rrc_RecPackOrderHeader."Owner Vendor No.");
        //                                 lbn_Modified := TRUE;
        //                             END;
        //                         END ELSE
        //                             IF (lrc_IncomingPallet."Owner Vendor No." = rrc_xRecPackOrderHeader."Pack.-by Vendor No.") OR
        //                                (lrc_IncomingPallet."Owner Vendor No." = '') THEN BEGIN
        //                                 lrc_IncomingPallet.VALIDATE("Owner Vendor No.", rrc_RecPackOrderHeader."Pack.-by Vendor No.");
        //                                 lbn_Modified := TRUE;
        //                             END;
        //                         IF rrc_xRecPackOrderHeader.Owner <> '' THEN BEGIN
        //                             IF (lrc_IncomingPallet."Owner Name" = rrc_xRecPackOrderHeader.Owner) OR
        //                                (lrc_IncomingPallet."Owner Name" = '') THEN BEGIN
        //                                 lrc_IncomingPallet.VALIDATE("Owner Name", rrc_RecPackOrderHeader.Owner);
        //                                 lbn_Modified := TRUE;
        //                             END;
        //                         END ELSE
        //                             IF (lrc_IncomingPallet."Owner Name" = rrc_xRecPackOrderHeader."Pack.-by Name") OR
        //                                (lrc_IncomingPallet."Owner Name" = '') THEN BEGIN
        //                                 lrc_IncomingPallet.VALIDATE("Owner Name", rrc_RecPackOrderHeader."Pack.-by Name");
        //                                 lbn_Modified := TRUE;
        //                             END;
        //                     END;
        //             END;
        //             IF lbn_Modified = TRUE THEN
        //                 lrc_IncomingPallet.MODIFY();
        //         UNTIL lrc_IncomingPallet.NEXT() = 0;
        //     END;

        //     // Pallet Item Lines
        //     lrc_PalletItemLines.Reset();
        //     lrc_PalletItemLines.SETRANGE(Source, lrc_PalletItemLines.Source::"Packing Order");
        //     lrc_PalletItemLines.SETRANGE("Source No.", rrc_RecPackOrderHeader."No.");
        //     IF lrc_PalletItemLines.FIND('-') THEN
        //         IF NOT GUIALLOWED() THEN
        //             lbn_UpdateConfirmed := TRUE
        //         ELSE BEGIN
        //             CASE ChangedFieldName OF
        //                 rrc_RecPackOrderHeader.FIELDCAPTION("Pack.-by Vendor No."):
        //                     lbn_UpdateConfirmed := TRUE;
        //                 rrc_RecPackOrderHeader.FIELDCAPTION("Pack.-by Name"):
        //                     lbn_UpdateConfirmed := TRUE;
        //                 rrc_RecPackOrderHeader.FIELDCAPTION("Person in Charge Code"):
        //                     lbn_UpdateConfirmed := TRUE;
        //                 rrc_RecPackOrderHeader.FIELDCAPTION("Owner Vendor No."):
        //                     lbn_UpdateConfirmed := FALSE;
        //                 rrc_RecPackOrderHeader.FIELDCAPTION(Owner):
        //                     lbn_UpdateConfirmed := TRUE;
        //                 ELSE
        //                     lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(Agiles001Txt + Agiles003Txt, ChangedFieldName, lrc_PalletItemLines.COUNT()));
        //             END;

        //             REPEAT
        //                 lbn_Modified := FALSE;
        //                 CASE ChangedFieldName OF
        //                     rrc_RecPackOrderHeader.FIELDCAPTION("Pack.-by Vendor No."):
        //                         IF lbn_UpdateConfirmed THEN BEGIN
        //                             lrc_PalletItemLines.VALIDATE("Vendor No.", rrc_RecPackOrderHeader."Pack.-by Vendor No.");
        //                             IF rrc_RecPackOrderHeader."Owner Vendor No." = '' THEN
        //                                 lrc_PalletItemLines.VALIDATE("Owner Vendor No.", rrc_RecPackOrderHeader."Pack.-by Vendor No.");
        //                             lbn_Modified := TRUE;
        //                         END;
        //                     rrc_RecPackOrderHeader.FIELDCAPTION("Pack.-by Name"):
        //                         IF lbn_UpdateConfirmed THEN BEGIN
        //                             lrc_PalletItemLines.VALIDATE("Vendor Name", rrc_RecPackOrderHeader."Pack.-by Name");
        //                             IF rrc_RecPackOrderHeader.Owner = '' THEN
        //                                 lrc_PalletItemLines.VALIDATE("Owner Name", rrc_RecPackOrderHeader."Pack.-by Name");
        //                             lbn_Modified := TRUE;
        //                         END;
        //                     rrc_RecPackOrderHeader.FIELDCAPTION("Owner Vendor No."):
        //                         IF lbn_UpdateConfirmed THEN BEGIN
        //                             lrc_PalletItemLines.VALIDATE("Owner Vendor No.", rrc_RecPackOrderHeader."Owner Vendor No.");
        //                             lbn_Modified := TRUE;
        //                         END;
        //                     rrc_RecPackOrderHeader.FIELDCAPTION(Owner):
        //                         IF lbn_UpdateConfirmed THEN BEGIN
        //                             lrc_PalletItemLines.VALIDATE("Owner Name", rrc_RecPackOrderHeader.Owner);
        //                             lbn_Modified := TRUE;
        //                         END;
        //                     rrc_RecPackOrderHeader.FIELDCAPTION("Person in Charge Code"):
        //                         IF lbn_UpdateConfirmed THEN BEGIN
        //                             lrc_PalletItemLines.VALIDATE("Salesman/Purchaser Code", rrc_RecPackOrderHeader."Person in Charge Code");
        //                             lbn_Modified := TRUE;
        //                         END;
        //                 END;
        //                 IF lbn_Modified = TRUE THEN
        //                     lrc_IncomingPallet.MODIFY();
        //             UNTIL lrc_IncomingPallet.NEXT() = 0;
        //         END;

        //     EXIT;
    end;

    procedure ActualFieldsFromPackOutputLine(ChangedFieldName: Text[100]; rrc_RecPackOrderOutputItems: Record "POI Pack. Order Output Items"; rrc_xRecPackOrderOutputItems: Record "POI Pack. Order Output Items")
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        lbn_UpdateConfirmed: Boolean;
        Agiles001Txt: Label 'You have modified %1.\\', Comment = '%1';
        Agiles002Txt: Label 'Do you want to update the existing %2 incoming pallet lines?', Comment = '%1 %2';
        lbn_Modified: Boolean;
    begin
        // Incoming Palet Lines

        lrc_PackOrderHeader.GET(rrc_RecPackOrderOutputItems."Doc. No.");

        IF lrc_PackOrderHeader."Pallet Entry ID" = 0 THEN
            EXIT;

        // Incoming Pallet Lines
        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.");
        lrc_IncomingPallet.SETRANGE("Entry No.", lrc_PackOrderHeader."Pallet Entry ID");
        lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Packing Order");
        lrc_IncomingPallet.SETRANGE("Document No.", rrc_RecPackOrderOutputItems."Doc. No.");
        lrc_IncomingPallet.SETRANGE("Document Line No.", rrc_RecPackOrderOutputItems."Line No.");
        IF lrc_IncomingPallet.FIND('-') THEN
            IF NOT GUIALLOWED() THEN
                lbn_UpdateConfirmed := TRUE
            ELSE BEGIN
                CASE ChangedFieldName OF
                    rrc_RecPackOrderOutputItems.FIELDCAPTION("Expiry Date"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                             Agiles001Txt +
                                             Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPackOrderOutputItems.FIELDCAPTION("Lot No."):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                             Agiles001Txt +
                                             Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPackOrderOutputItems.FIELDCAPTION("Info 1"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                             Agiles001Txt +
                                             Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPackOrderOutputItems.FIELDCAPTION("Info 2"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                             Agiles001Txt +
                                             Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPackOrderOutputItems.FIELDCAPTION("Info 3"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                             Agiles001Txt +
                                             Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPackOrderOutputItems.FIELDCAPTION("Info 4"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                             Agiles001Txt +
                                             Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    ELSE
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                             Agiles001Txt +
                                             Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                END;

                REPEAT
                    lbn_Modified := FALSE;
                    CASE ChangedFieldName OF
                        rrc_RecPackOrderOutputItems.FIELDCAPTION("Expiry Date"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Date of Expiry", rrc_RecPackOrderOutputItems."Expiry Date");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPackOrderOutputItems.FIELDCAPTION("Lot No."):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Lot No.", rrc_RecPackOrderOutputItems."Lot No.");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPackOrderOutputItems.FIELDCAPTION("Info 1"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Info 1", rrc_RecPackOrderOutputItems."Info 1");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPackOrderOutputItems.FIELDCAPTION("Info 2"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Info 2", rrc_RecPackOrderOutputItems."Info 2");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPackOrderOutputItems.FIELDCAPTION("Info 3"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Info 3", rrc_RecPackOrderOutputItems."Info 3");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPackOrderOutputItems.FIELDCAPTION("Info 4"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Info 4", rrc_RecPackOrderOutputItems."Info 4");
                                lbn_Modified := TRUE;
                            END;
                    END;
                    IF lbn_Modified = TRUE THEN
                        lrc_IncomingPallet.MODIFY();
                UNTIL lrc_IncomingPallet.NEXT() = 0;
            END;
    end;

    procedure ActualLocationBinPalletNo(rco_PalletNo: Code[30]; rco_LocationCode: Code[10]; rco_LocationBinCode: Code[10]; rdc_ActualInsertDeleteQuantity: Decimal; rco_OldPalletNo: Code[30]; rco_OldLocationCode: Code[10]; rco_OldLocationBinCode: Code[10])
    var
        ldc_QuantityBase: Decimal;
    begin


        IF (rco_LocationCode = '') AND
           (rco_LocationBinCode = '') AND
           (rco_PalletNo = '') THEN
            EXIT;

        ldc_QuantityBase := rdc_ActualInsertDeleteQuantity;

        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Pallet No.", Posted, "Location Code", "Location Bin Code");
        lrc_IncomingPallet.SETRANGE("Pallet No.", rco_PalletNo);
        lrc_IncomingPallet.SETRANGE(Posted, FALSE);
        lrc_IncomingPallet.SETRANGE("Location Code", rco_LocationCode);
        lrc_IncomingPallet.SETRANGE("Location Bin Code", rco_LocationBinCode);
        IF lrc_IncomingPallet.FIND('-') THEN BEGIN
            lrc_IncomingPallet.CALCSUMS("Quantity (Base)");
            ldc_QuantityBase := ldc_QuantityBase + lrc_IncomingPallet."Quantity (Base)";
        END;

        lrc_OutgoingPallet.RESET();
        lrc_OutgoingPallet.SETCURRENTKEY("Pallet No.", "Pallet Line No.", Posted, "Location Code", "Location Bin Code");
        lrc_OutgoingPallet.SETRANGE("Pallet No.", rco_PalletNo);
        lrc_OutgoingPallet.SETRANGE(Posted, FALSE);
        lrc_OutgoingPallet.SETRANGE("Location Code", rco_LocationCode);
        lrc_OutgoingPallet.SETRANGE("Location Bin Code", rco_LocationBinCode);
        IF lrc_OutgoingPallet.FIND('-') THEN BEGIN
            lrc_OutgoingPallet.CALCSUMS("Quantity (Base)");
            ldc_QuantityBase := ldc_QuantityBase + lrc_OutgoingPallet."Quantity (Base)";
        END;

        lrc_PalletItemLines.RESET();
        lrc_PalletItemLines.SETCURRENTKEY("Pallet No.", Status, "Location Code", "Location Bin Code");
        lrc_PalletItemLines.SETRANGE("Pallet No.", rco_PalletNo);
        lrc_PalletItemLines.SETFILTER(Status, '..%1', lrc_PalletItemLines.Status::Opened);
        lrc_PalletItemLines.SETRANGE("Location Code", rco_LocationCode);
        lrc_PalletItemLines.SETRANGE("Location Bin Code", rco_LocationBinCode);
        IF lrc_PalletItemLines.FIND('-') THEN BEGIN
            lrc_PalletItemLines.CALCSUMS("Quantity (Base)");
            ldc_QuantityBase := ldc_QuantityBase + lrc_PalletItemLines."Quantity (Base)";
        END;

        lrc_LocationBinPalletNo.RESET();
        lrc_LocationBinPalletNo.SETRANGE("Location Code", rco_LocationCode);
        lrc_LocationBinPalletNo.SETRANGE("Location Bin Code", rco_LocationBinCode);
        lrc_LocationBinPalletNo.SETRANGE("Pallet No.", rco_PalletNo);
        IF ldc_QuantityBase = 0 THEN BEGIN
            IF lrc_LocationBinPalletNo.FIND('-') THEN
                lrc_LocationBinPalletNo.DELETE(TRUE);
        END ELSE
            IF NOT lrc_LocationBinPalletNo.FIND('-') THEN BEGIN
                lrc_LocationBinPalletNo.INIT();
                lrc_LocationBinPalletNo.VALIDATE("Location Code", rco_LocationCode);
                lrc_LocationBinPalletNo.VALIDATE("Location Bin Code", rco_LocationBinCode);
                lrc_LocationBinPalletNo.VALIDATE("Pallet No.", rco_PalletNo);
                lrc_LocationBinPalletNo.INSERT(TRUE);
            END;

        // Beim Insert und Delete sind diese Felder alle 3 mit '' gefüllt
        IF (rco_OldLocationCode = '') AND
           (rco_OldLocationBinCode = '') AND
           (rco_OldPalletNo = '') THEN
            EXIT;

        IF (rco_OldLocationCode <> rco_LocationCode) OR
           (rco_OldLocationBinCode <> rco_LocationBinCode) OR
           (rco_OldPalletNo <> rco_PalletNo) THEN BEGIN
            lrc_LocationBinPalletNo.RESET();
            lrc_LocationBinPalletNo.SETRANGE("Location Code", rco_OldLocationCode);
            lrc_LocationBinPalletNo.SETRANGE("Location Bin Code", rco_OldLocationBinCode);
            lrc_LocationBinPalletNo.SETRANGE("Pallet No.", rco_OldPalletNo);
            IF lrc_LocationBinPalletNo.FIND('-') THEN
                lrc_LocationBinPalletNo.DELETE(TRUE);
        END;
    end;

    procedure CheckDeletePallet(rco_PalletNo: Code[30]; CalledFromIncomingEntryID: Integer; CalledFromIncomingLineNo: Integer; CalledFromOutgoingEntryID: Integer; CalledFromOutgoingLineNo: Integer; CalledFromPalletItemLiPalletNo: Code[30]; CalledFromPalletItemLiLineNo: Integer)
    begin
        IF rco_PalletNo = '' THEN
            EXIT;

        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Pallet No.");
        lrc_IncomingPallet.SETRANGE("Pallet No.", rco_PalletNo);
        IF (CalledFromIncomingEntryID <> 0) AND
           (CalledFromIncomingLineNo <> 0) THEN BEGIN
            lrc_IncomingPallet.SETFILTER("Entry No.", '<>%1', CalledFromIncomingEntryID);
            lrc_IncomingPallet.SETFILTER("Line No.", '<>%1', CalledFromIncomingLineNo);
        END;
        IF lrc_IncomingPallet.FIND('-') THEN;

        lrc_OutgoingPallet.RESET();
        lrc_OutgoingPallet.SETCURRENTKEY("Pallet No.");
        lrc_OutgoingPallet.SETRANGE("Pallet No.", rco_PalletNo);
        IF (CalledFromOutgoingEntryID <> 0) AND
           (CalledFromOutgoingLineNo <> 0) THEN BEGIN
            lrc_OutgoingPallet.SETFILTER("Entry No.", '<>%1', CalledFromOutgoingEntryID);
            lrc_OutgoingPallet.SETFILTER("Line No.", '<>%1', CalledFromOutgoingLineNo);
        END;
        IF lrc_OutgoingPallet.FIND('-') THEN;

        lrc_PalletItemLines.RESET();
        lrc_PalletItemLines.SETRANGE("Pallet No.", rco_PalletNo);
        IF (CalledFromPalletItemLiPalletNo <> '') AND
           (CalledFromPalletItemLiLineNo <> 0) THEN
            lrc_PalletItemLines.SETFILTER("Line No.", '<>%1', CalledFromPalletItemLiLineNo);
        IF lrc_PalletItemLines.FIND('-') THEN;

        IF (lrc_IncomingPallet.COUNT() = 0) AND
           (lrc_OutgoingPallet.COUNT() = 0) AND
           (lrc_PalletItemLines.COUNT() = 0) THEN
            IF lrc_Pallets.GET(rco_PalletNo) THEN
                lrc_Pallets.DELETE();
    end;

    procedure IsLocationBinFree(rco_LocationCode: Code[10]; rco_LocationBinCode: Code[10]; rco_PalletNo: Code[30]): Boolean
    var
        lrc_LocationBins: Record "POI Location Bins";
        AgilesText01Txt: Label 'In location bin %1, location code %2, are %3 pallets, allowed are only %4 pallets !', Comment = '%1 %2 %3 %4';
    begin
        IF rco_LocationCode = '' THEN
            EXIT(TRUE);

        IF rco_LocationBinCode = '' THEN
            EXIT(TRUE);

        lrc_LocationBins.GET(rco_LocationCode, rco_LocationBinCode);

        lrc_LocationBinPalletNo.RESET();
        lrc_LocationBinPalletNo.SETRANGE("Location Code", rco_LocationCode);
        lrc_LocationBinPalletNo.SETRANGE("Location Bin Code", rco_LocationBinCode);
        lrc_LocationBinPalletNo.SETFILTER("Pallet No.", '<>%1', '');
        IF lrc_LocationBinPalletNo.FIND('-') THEN BEGIN
            IF lrc_LocationBinPalletNo.COUNT() > (lrc_LocationBins."Maximum Number Of Pallets" - 1) THEn
                ERROR(AgilesText01Txt, rco_LocationBinCode, rco_LocationCode, lrc_LocationBinPalletNo.COUNT(), lrc_LocationBins."Maximum Number Of Pallets")
            ELSE
                EXIT(TRUE);
        END ELSE
            EXIT(TRUE);
    end;

    procedure ErrorIfIncomingPalletLineEx_PO(ChangedFieldName: Text[100]; rrc_PackOrderOutputItems: Record "POI Pack. Order Output Items")
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        AgilesText001Txt: Label 'Feld %1 : Es existieren %2 eingehende Palettenzeilen für diese Zeile %3, Löschung / Initialisierung / Änderung nicht möglich !', Comment = '%1 %2 %3';
    begin
        lrc_PackOrderHeader.GET(rrc_PackOrderOutputItems."Doc. No.");

        IF lrc_PackOrderHeader."Pallet Entry ID" = 0 THEN
            EXIT;

        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.");
        lrc_IncomingPallet.SETRANGE("Entry No.", lrc_PackOrderHeader."Pallet Entry ID");
        lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Packing Order");
        lrc_IncomingPallet.SETRANGE("Document No.", rrc_PackOrderOutputItems."Doc. No.");
        lrc_IncomingPallet.SETRANGE("Document Line No.", rrc_PackOrderOutputItems."Line No.");
        IF lrc_IncomingPallet.FIND('-') THEN
            ERROR(AgilesText001Txt, ChangedFieldName, lrc_IncomingPallet.COUNT(), rrc_PackOrderOutputItems."Line No.");

        EXIT;
    end;

    procedure ErrorIfOutgoingPalletLineEx_PI(ChangedFieldName: Text[100]; rrc_PackOrderInputItems: Record "POI Pack. Order Input Items")
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        AgilesText001Txt: Label 'Feld %1 : Es existieren %2 ausgehende Palettenzeilen für diese Zeile, Löschung / Initialisierung / Änderung nicht möglich !', Comment = '%1 %2';
    begin
        lrc_PackOrderHeader.GET(rrc_PackOrderInputItems."Doc. No.");

        IF lrc_PackOrderHeader."Pallet Entry ID" = 0 THEN
            EXIT;

        // Outgoing Pallet Lines
        lrc_OutgoingPallet.RESET();
        lrc_OutgoingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.",
           "Document Line No. Output");
        lrc_OutgoingPallet.SETRANGE("Entry No.", lrc_PackOrderHeader."Pallet Entry ID");
        lrc_OutgoingPallet.SETRANGE("Document Type", lrc_OutgoingPallet."Document Type"::"Packing Order");
        lrc_OutgoingPallet.SETRANGE("Document No.", lrc_PackOrderHeader."No.");
        lrc_OutgoingPallet.SETRANGE("Document Line No.", rrc_PackOrderInputItems."Line No.");
        lrc_OutgoingPallet.SETRANGE("Document Line No. Output", rrc_PackOrderInputItems."Doc. Line No. Output");
        IF lrc_OutgoingPallet.FIND('-') THEN
            ERROR(AgilesText001Txt, ChangedFieldName, lrc_OutgoingPallet.COUNT());

        EXIT;
    end;

    procedure ErrorIfIncomingPalletLineEx_PL(ChangedFieldName: Text[100]; rrc_PurchLine: Record "Purchase Line")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchaseHeader: Record "Purchase Header";
        AgilesText001Txt: Label 'Feld %1 : Es existieren %2 eingehende Palettenzeilen für diese Zeile %3, Löschung / Initialisierung / Änderung nicht möglich !', Comment = '%1 %2 %3';
        lbn_ModifyAllowed: Boolean;
    begin
        // -----------------------------------------------------------------------------------------------------
        // Prüfung Änderung in Einkaufszeile und Auswirkung auf Palettenzeilen
        // -----------------------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Type of Pallet Systematic" <>
           lrc_FruitVisionSetup."Type of Pallet Systematic"::"Systematik 1" THEN
            EXIT;

        lrc_PurchaseHeader.GET(rrc_PurchLine."Document Type", rrc_PurchLine."Document No.");

        IF lrc_PurchaseHeader."POI Pallets Entry No." = 0 THEN
            EXIT;

        // Incoming Pallet Lines
        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.");
        lrc_IncomingPallet.SETRANGE("Entry No.", lrc_PurchaseHeader."POI Pallets Entry No.");
        lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Purchase Order");
        lrc_IncomingPallet.SETRANGE("Document No.", rrc_PurchLine."Document No.");
        lrc_IncomingPallet.SETRANGE("Document Line No.", rrc_PurchLine."Line No.");

        IF lrc_IncomingPallet.FIND('-') THEN BEGIN
            lbn_ModifyAllowed := FALSE;

            // L A G E R O R T  Ä N D E R N
            IF rrc_PurchLine."Location Code" <> lrc_IncomingPallet."Location Code" THEN BEGIN
                lbn_ModifyAllowed := TRUE;
                lrc_IncomingPallet.MODIFYALL("Location Code", rrc_PurchLine."Location Code", TRUE);
            END;
            // E I N H E I T  Ä N D E R N
            IF rrc_PurchLine."Unit of Measure Code" <> lrc_IncomingPallet."Unit of Measure Code" THEN BEGIN
                lbn_ModifyAllowed := TRUE;
                REPEAT
                    lrc_IncomingPallet."Unit of Measure Code" := rrc_PurchLine."Unit of Measure Code";
                    lrc_IncomingPallet.VALIDATE(Quantity);
                    lrc_IncomingPallet.MODIFY();
                UNTIL lrc_IncomingPallet.NEXT(1) = 0;
            END;

            // W E N N   N I C H T   L A G E R O R T   O D E R   E I N H E I T   G E Ä N D E R T   W U R D E   - >   F E H L ER
            IF lbn_ModifyAllowed = FALSE THEN
                ERROR(AgilesText001Txt, ChangedFieldName, lrc_IncomingPallet.COUNT(), rrc_PurchLine."Line No.");
        END;
    end;

    procedure ActualFieldsFromPurchLine(ChangedFieldName: Text[100]; rrc_RecPurchaseLine: Record "Purchase Line"; rrc_xRecPurchaseLine: Record "Purchase Line")
    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lbn_UpdateConfirmed: Boolean;
        Agiles001Txt: Label 'You have modified %1.\\', Comment = '%1';
        Agiles002Txt: Label 'Do you want to update the existing %2 incoming pallet lines?', Comment = '%1 %2';
        lbn_Modified: Boolean;
    begin
        // ------------------------------------------------------------------------------------------------------
        // Incoming Palet Lines
        // ------------------------------------------------------------------------------------------------------

        lrc_PurchaseHeader.GET(rrc_RecPurchaseLine."Document Type", rrc_RecPurchaseLine."Document No.");
        IF lrc_PurchaseHeader."POI Pallets Entry No." = 0 THEN
            EXIT;

        // Incoming Pallet Lines
        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.");
        lrc_IncomingPallet.SETRANGE("Entry No.", lrc_PurchaseHeader."POI Pallets Entry No.");
        lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Purchase Order");
        lrc_IncomingPallet.SETRANGE("Document No.", rrc_RecPurchaseLine."Document No.");
        lrc_IncomingPallet.SETRANGE("Document Line No.", rrc_RecPurchaseLine."Line No.");
        IF lrc_IncomingPallet.FIND('-') THEN
            IF NOT GUIALLOWED() THEN
                lbn_UpdateConfirmed := TRUE
            ELSE BEGIN
                CASE ChangedFieldName OF
                    rrc_RecPurchaseLine.FIELDCAPTION("POI Date of Expiry"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                               Agiles001Txt +
                                               Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPurchaseLine.FIELDCAPTION("POI Lot No. Producer"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                               Agiles001Txt +
                                               Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPurchaseLine.FIELDCAPTION("POI Info 1"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                               Agiles001Txt +
                                               Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPurchaseLine.FIELDCAPTION("POI Info 2"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                               Agiles001Txt +
                                               Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPurchaseLine.FIELDCAPTION("POI Info 3"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                               Agiles001Txt +
                                               Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    rrc_RecPurchaseLine.FIELDCAPTION("POI Info 4"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                               Agiles001Txt +
                                               Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));

                    rrc_RecPurchaseLine.FIELDCAPTION("Location Code"):
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                               Agiles001Txt +
                                               Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                    ELSE
                        lbn_UpdateConfirmed := CONFIRM(STRSUBSTNO(
                                               Agiles001Txt +
                                               Agiles002Txt, ChangedFieldName, lrc_IncomingPallet.COUNT()));
                END;

                REPEAT
                    lbn_Modified := FALSE;
                    CASE ChangedFieldName OF
                        rrc_RecPurchaseLine.FIELDCAPTION("POI Date of Expiry"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Date of Expiry", rrc_RecPurchaseLine."POI Date of Expiry");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPurchaseLine.FIELDCAPTION("POI Lot No. Producer"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Lot No.", rrc_RecPurchaseLine."POI Lot No. Producer");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPurchaseLine.FIELDCAPTION("POI Info 1"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Info 1", rrc_RecPurchaseLine."POI Info 1");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPurchaseLine.FIELDCAPTION("POI Info 2"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Info 2", rrc_RecPurchaseLine."POI Info 2");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPurchaseLine.FIELDCAPTION("POI Info 3"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Info 3", rrc_RecPurchaseLine."POI Info 3");
                                lbn_Modified := TRUE;
                            END;
                        rrc_RecPurchaseLine.FIELDCAPTION("POI Info 4"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Info 4", rrc_RecPurchaseLine."POI Info 4");
                                lbn_Modified := TRUE;
                            END;

                        rrc_RecPurchaseLine.FIELDCAPTION("Location Code"):
                            IF lbn_UpdateConfirmed THEN BEGIN
                                lrc_IncomingPallet.VALIDATE("Location Code", rrc_RecPurchaseLine."Location Code");
                                lbn_Modified := TRUE;
                            END;

                    END;
                    IF lbn_Modified = TRUE THEN
                        lrc_IncomingPallet.MODIFY();

                UNTIL lrc_IncomingPallet.NEXT() = 0;
            END;
    end;

    procedure PurchUpdPalletsFromPLine(vin_PurchDocType: Integer; vco_PurchNo: Code[20]; vin_PurchLineNo: Integer)
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchaseHeader: Record "Purchase Header";
        AGILES_LT_TEXT001Txt: Label 'Es sind bereits gebuchte eingehende Palettenposten vorhanden!';
        ldc_QtyIncomingPallet: Decimal;
    begin
        // -----------------------------------------------------------------------------
        // Funktion um die Incoming Palettenzeilen zu aktualisieren
        // -----------------------------------------------------------------------------

        lrc_PurchaseHeader.GET(vin_PurchDocType, vco_PurchNo);
        IF lrc_PurchaseHeader."POI Pallets Entry No." = 0 THEN
            EXIT;

        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Type of Pallet Systematic" <> lrc_FruitVisionSetup."Type of Pallet Systematic"::"Systematik 2" THEN
            EXIT;


        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
        lrc_PurchaseLine.SETFILTER("No.", '<>%1', '');
        IF vin_PurchLineNo <> 0 THEN
            lrc_PurchaseLine.SETRANGE("Line No.", vin_PurchLineNo);
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT

                lrc_IncomingPallet.RESET();
                lrc_IncomingPallet.SETRANGE("Entry No.", lrc_PurchaseHeader."POI Pallets Entry No.");
                lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Purchase Order");
                lrc_IncomingPallet.SETRANGE("Document No.", lrc_PurchaseLine."Document No.");
                lrc_IncomingPallet.SETRANGE("Document Line No.", lrc_PurchaseLine."Line No.");
                IF lrc_IncomingPallet.FIND('-') THEN
                    REPEAT

                        IF lrc_IncomingPallet.Posted = TRUE THEN
                            // Es sind bereits gebuchte eingehende Palettenposten vorhanden!
                            ERROR(AGILES_LT_TEXT001Txt);

                        // Palettensatz lesen
                        lrc_Pallets.GET(lrc_IncomingPallet."Pallet No.");

                        // Kontrolle auf Zugang / Abgang entsprechend der Menge
                        // IF (lrc_PurchaseLine.Quantity > 0) AND //TODO: prüfen
                        //    (lrc_IncomingPallet."Pos./Neg. Adjustment" <>
                        //     lrc_IncomingPallet."Pos./Neg. Adjustment"::"Pos. Adjustment") THEN BEGIN

                        // END;

                        IF lrc_IncomingPallet."Item No." <> lrc_PurchaseLine."No." THEN
                            lrc_IncomingPallet."Item No." := lrc_PurchaseLine."No.";


                        IF lrc_IncomingPallet."Variant Code" <> lrc_PurchaseLine."Variant Code" THEN
                            lrc_IncomingPallet."Variant Code" := lrc_PurchaseLine."Variant Code";


                        IF lrc_IncomingPallet."Item Description" <> lrc_PurchaseLine.Description THEN
                            lrc_IncomingPallet."Item Description" := lrc_PurchaseLine.Description;

                        IF lrc_IncomingPallet."Item Description 2" <> lrc_PurchaseLine."Description 2" THEN
                            lrc_IncomingPallet."Item Description 2" := lrc_PurchaseLine."Description 2";

                        IF (lrc_IncomingPallet."Unit of Measure Code" <> lrc_PurchaseLine."Unit of Measure Code") OR
                           (lrc_IncomingPallet."Base Unit of Measure" <> lrc_PurchaseLine."POI Base Unit of Measure (BU)") OR
                           (lrc_IncomingPallet."Qty. per Unit of Measure" <> lrc_PurchaseLine."Qty. per Unit of Measure") THEN BEGIN
                            lrc_IncomingPallet."Unit of Measure Code" := lrc_PurchaseLine."Unit of Measure Code";
                            lrc_IncomingPallet."Base Unit of Measure" := lrc_PurchaseLine."POI Base Unit of Measure (BU)";
                            lrc_IncomingPallet."Qty. per Unit of Measure" := lrc_PurchaseLine."Qty. per Unit of Measure";
                        END;

                        IF lrc_IncomingPallet.Quantity <> lrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)" THEN BEGIN
                            ldc_QtyIncomingPallet := 0;
                            lrc_IncomingPallet2.SETRANGE("Entry No.", lrc_IncomingPallet."Entry No.");
                            lrc_IncomingPallet2.SETRANGE("Pallet No.", lrc_IncomingPallet."Pallet No.");
                            IF lrc_IncomingPallet2.FIND('-') THEN
                                REPEAT
                                    ldc_QtyIncomingPallet := ldc_QtyIncomingPallet + lrc_IncomingPallet2.Quantity;
                                UNTIL lrc_IncomingPallet2.NEXT() = 0;
                            IF ldc_QtyIncomingPallet <> lrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)" THEN BEGIN
                                lrc_IncomingPallet.Quantity := lrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)";
                                lrc_IncomingPallet."Quantity (Base)" := lrc_IncomingPallet.Quantity * lrc_IncomingPallet."Qty. per Unit of Measure";
                            END ELSE
                                lrc_IncomingPallet.VALIDATE(Quantity, lrc_PurchaseLine.Quantity);
                        END ELSE
                            lrc_IncomingPallet.VALIDATE(Quantity, lrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)");
                        IF (lrc_IncomingPallet."Pallet Transport Unit Code" <> lrc_PurchaseLine."POI Transport Unit of Meas(TU)") OR
                           (lrc_IncomingPallet."Pallet Freight Unit Code" <> lrc_PurchaseLine."POI Freight Unit of Meas (FU)") THEN BEGIN
                            lrc_IncomingPallet."Pallet Transport Unit Code" := lrc_PurchaseLine."POI Transport Unit of Meas(TU)";
                            lrc_IncomingPallet."Pallet Freight Unit Code" := lrc_PurchaseLine."POI Freight Unit of Meas (FU)";

                            lrc_Pallets."Pallet Unit Code" := lrc_PurchaseLine."POI Transport Unit of Meas(TU)";
                            lrc_Pallets."Pallet Freight Unit Code" := lrc_PurchaseLine."POI Freight Unit of Meas (FU)";
                            lrc_Pallets.MODIFY();
                        END;

                        IF lrc_IncomingPallet."Master Batch No." <> lrc_PurchaseLine."POI Master Batch No." THEN
                            lrc_IncomingPallet."Master Batch No." := lrc_PurchaseLine."POI Master Batch No.";

                        IF lrc_IncomingPallet."Batch No." <> lrc_PurchaseLine."POI Batch No." THEN
                            lrc_IncomingPallet."Batch No." := lrc_PurchaseLine."POI Batch No.";

                        IF lrc_IncomingPallet."Batch Variant No." <> lrc_PurchaseLine."POI Batch Variant No." THEN
                            lrc_IncomingPallet."Batch Variant No." := lrc_PurchaseLine."POI Batch Variant No.";


                        IF lrc_IncomingPallet."Info 1" <> lrc_PurchaseLine."POI Info 1" THEN
                            lrc_IncomingPallet."Info 1" := lrc_PurchaseLine."POI Info 1";

                        IF lrc_IncomingPallet."Info 2" <> lrc_PurchaseLine."POI Info 2" THEN
                            lrc_IncomingPallet."Info 2" := lrc_PurchaseLine."POI Info 2";

                        IF lrc_IncomingPallet."Info 3" <> lrc_PurchaseLine."POI Info 3" THEN
                            lrc_IncomingPallet."Info 3" := lrc_PurchaseLine."POI Info 3";

                        IF lrc_IncomingPallet."Info 4" <> lrc_PurchaseLine."POI Info 4" THEN
                            lrc_IncomingPallet."Info 4" := lrc_PurchaseLine."POI Info 4";


                        lrc_IncomingPallet.MODIFY();

                    UNTIL lrc_IncomingPallet.NEXT() = 0;

            UNTIL lrc_PurchaseLine.NEXT() = 0;
    end;

    procedure PurchPostCheckPallet(vrc_PurchHeader: Record "Purchase Header")
    var
        lrc_FruitvisionSetup: Record "POI ADF Setup";
        lrc_Location: Record Location;
        ldc_QuantityBase: Decimal;
        AGILES_LT_TEXT001Txt: Label 'Bei Lagerort %1 muss ein Stellplatz eingegeben werden !', Comment = '%1';
        AGILES_LT_TEXT002Txt: Label 'Es existieren eingehende Palettenzeilen, für die es keine Einkaufszeile gibt!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Prüfung der Paletten vor dem Buchen Einkaufslieferung
        // -----------------------------------------------------------------------------

        IF vrc_PurchHeader."POI Pallets Entry No." = 0 THEN
            EXIT;

        lrc_FruitvisionSetup.GET();

        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
        lrc_PurchLine.SETFILTER("No.", '<>%1', '');
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                IF lrc_PurchLine."Qty. to Receive" <> 0 THEN BEGIN
                    ldc_QuantityBase := 0;
                    lrc_PurchLine.TESTFIELD("Location Code");
                    lrc_Location.GET(lrc_PurchLine."Location Code");
                    lrc_IncomingPallet.RESET();
                    lrc_IncomingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.");
                    lrc_IncomingPallet.SETRANGE("Entry No.", vrc_PurchHeader."POI Pallets Entry No.");
                    lrc_IncomingPallet.SETRANGE(Posted, FALSE);
                    lrc_IncomingPallet.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_IncomingPallet.SETRANGE("Document Line No.", lrc_PurchLine."Line No.");
                    IF lrc_IncomingPallet.FIND('-') THEN BEGIN
                        REPEAT

                            lrc_Pallets.GET(lrc_IncomingPallet."Pallet No.");

                            IF lrc_PurchLine."Qty. to Receive" >= 0 THEN
                                lrc_IncomingPallet.TESTFIELD("Pos./Neg. Adjustment", lrc_IncomingPallet."Pos./Neg. Adjustment"::"Pos. Adjustment")
                            ELSE
                                lrc_IncomingPallet.TESTFIELD("Pos./Neg. Adjustment", lrc_IncomingPallet."Pos./Neg. Adjustment"::"Neg. Adjustment");


                            IF lrc_IncomingPallet."Item No." <> lrc_PurchLine."No." THEN
                                ERROR('Artikelnr. %1 der Palette %2, ist abweichend von Artikelnr. %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Item No.", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."No.", lrc_PurchLine."Line No.");

                            IF lrc_IncomingPallet."Unit of Measure Code" <> lrc_PurchLine."Unit of Measure Code" THEN
                                ERROR('Einheit %1 der Palette %2, ist abweichend von Einheit %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Unit of Measure Code", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."Unit of Measure Code", lrc_PurchLine."Line No.");

                            IF lrc_IncomingPallet."Base Unit of Measure" <> lrc_PurchLine."POI Base Unit of Measure (BU)" THEN
                                ERROR('Basiseinheit %1 der Palette %2, ist abweichend von Einheit %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Base Unit of Measure", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."POI Base Unit of Measure (BU)", lrc_PurchLine."Line No.");

                            IF lrc_IncomingPallet."Variant Code" <> lrc_PurchLine."Variant Code" THEN
                                ERROR('Variante %1 der Palette %2, ist abweichend von Variante %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Variant Code", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."Variant Code", lrc_PurchLine."Line No.");

                            IF lrc_IncomingPallet."Location Code" <> lrc_PurchLine."Location Code" THEN
                                ERROR('Lagerort %1 der Palette %2, ist abweichend vom Lagerort %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Location Code", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."Location Code", lrc_PurchLine."Line No.");

                            IF lrc_IncomingPallet."Master Batch No." <> lrc_PurchLine."POI Master Batch No." THEN
                                ERROR('Partienr %1 der Palette %2, ist abweichend von Partienr %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Master Batch No.", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."POI Master Batch No.", lrc_PurchLine."Line No.");

                            IF lrc_IncomingPallet."Batch No." <> lrc_PurchLine."POI Batch No." THEN
                                ERROR('Positionsnr. %1 der Palette %2, ist abweichend von Positionsnr. %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Batch No.", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."POI Batch No.", lrc_PurchLine."Line No.");

                            IF lrc_IncomingPallet."Batch Variant No." <> lrc_PurchLine."POI Batch Variant No." THEN
                                ERROR('Positionsvariante. %1 der Palette %2, ist abweichend von Positionsvariante %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Batch Variant No.", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."POI Batch Variant No.", lrc_PurchLine."Line No.");

                            IF (lrc_Location."POI Locat Bin Pallets Required" = TRUE) AND
                               (lrc_IncomingPallet."Location Bin Code" = '') THEN
                                ERROR('Stellplatzpflicht bei Lagerort %1 : Stellplatz bei Palette %2 fehlt!',
                                 lrc_IncomingPallet."Location Code", lrc_IncomingPallet."Pallet No.");

                            IF (lrc_PurchLine."POI Transport Unit of Meas(TU)" <> '') AND
                               (lrc_PurchLine."POI Transport Unit of Meas(TU)" <>
                                 lrc_IncomingPallet."Pallet Transport Unit Code") THEN
                                ERROR('Die Paletteneinheit %1 für Palette %2 entspricht nicht der Paletteneinheit %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Pallet Transport Unit Code", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."POI Transport Unit of Meas(TU)", lrc_PurchLine."Line No.");

                            IF (lrc_PurchLine."POI Freight Unit of Meas (FU)" <> '') AND
                               (lrc_PurchLine."POI Freight Unit of Meas (FU)" <>
                                 lrc_IncomingPallet."Pallet Freight Unit Code") THEN
                                ERROR('Die Palettenfrachteinheit %1 für Palette %2 entspricht nicht der Fracheinheit %3 der Einkaufszeile %4!',
                                 lrc_IncomingPallet."Pallet Freight Unit Code", lrc_IncomingPallet."Pallet No.",
                                 lrc_PurchLine."POI Freight Unit of Meas (FU)", lrc_PurchLine."Line No.");

                            IF (lrc_Pallets."Location Code" <> lrc_IncomingPallet."Location Code") OR
                               (lrc_Pallets."Location Bin Code" <> lrc_IncomingPallet."Location Bin Code") THEN
                                ERROR('Eingehender Lagerort %1 / Stellplatz %2 entspricht nicht Lagerort %3 / Stellplatz %4 der Palette %5!',
                                 lrc_IncomingPallet."Location Code", lrc_IncomingPallet."Location Bin Code",
                                 lrc_Pallets."Location Code", lrc_Pallets."Location Bin Code", lrc_IncomingPallet."Pallet No.");

                            IF (lrc_Location."POI Locat Bin Pallets Required" = TRUE) AND
                               (lrc_IncomingPallet."Location Bin Code" = '') THEN
                                ERROR(AGILES_LT_TEXT001Txt, lrc_Location.Code);

                            // Menge (Basis) Paletten aufaddieren
                            ldc_QuantityBase := ldc_QuantityBase + lrc_IncomingPallet."Quantity (Base)";
                        UNTIL lrc_IncomingPallet.NEXT() = 0;

                        // Prüfung Mengen
                        IF lrc_PurchLine."Qty. to Receive (Base)" >= 0 THEN BEGIN
                            IF ldc_QuantityBase > lrc_PurchLine."Qty. to Receive (Base)" THEN
                                ERROR('Menge Basis %1 auf Paletten, ist größer als die Menge akt. Lieferung Basis %2 der Einkaufszeile %3!',
                                  ldc_QuantityBase, lrc_PurchLine."Qty. to Receive (Base)", lrc_PurchLine."Line No.");
                        END ELSE
                            IF ldc_QuantityBase < lrc_PurchLine."Qty. to Receive (Base)" THEN
                                ERROR('Menge Basis %1 auf Paletten, ist kleiner als die Menge akt. Lieferung Basis %2 der Einkaufszeile %3!',
                                  ldc_QuantityBase, lrc_PurchLine."Qty. to Receive (Base)", lrc_PurchLine."Line No.");

                    END;

                END ELSE

                    IF lrc_FruitvisionSetup."Only Incoming Pallets" = FALSE THEN BEGIN
                        lrc_IncomingPallet.RESET();
                        lrc_IncomingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.");
                        lrc_IncomingPallet.SETRANGE("Entry No.", vrc_PurchHeader."POI Pallets Entry No.");
                        lrc_IncomingPallet.SETRANGE(Posted, FALSE);
                        lrc_IncomingPallet.SETRANGE("Document No.", vrc_PurchHeader."No.");
                        lrc_IncomingPallet.SETRANGE("Document Line No.", lrc_PurchLine."Line No.");
                        IF lrc_IncomingPallet.FIND('-') THEN
                            ERROR('Es sind %1 Paletten zugeordnet ohne Wareneingang!', lrc_IncomingPallet.COUNT());
                    END;

            UNTIL lrc_PurchLine.NEXT() = 0;

        // Gibt es eingehende Palettenzeilen zu Einkaufszeilen, die nicht existieren
        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.");
        lrc_IncomingPallet.SETRANGE("Entry No.", vrc_PurchHeader."POI Pallets Entry No.");
        lrc_IncomingPallet.SETRANGE("Document No.", vrc_PurchHeader."No.");
        IF lrc_IncomingPallet.FIND('-') THEN
            REPEAT
                IF NOT lrc_PurchLine.GET(lrc_PurchLine."Document Type"::Order, lrc_IncomingPallet."Document No.", lrc_IncomingPallet."Document Line No.") THEN
                    // Es existieren eingehende Palettenzeilen, für die es keine Einkaufszeile gibt!
                    ERROR(AGILES_LT_TEXT002Txt);
            UNTIL lrc_IncomingPallet.NEXT() = 0;
    end;

    procedure ErrorIfIncomingPalletLineEx_SC(ChangedFieldName: Text[100]; rrc_SalesClaimAdviceLine: Record "POI Sales Claim Notify Line")
    var
        lrc_SalesClaimAdviceHeader: Record "POI Sales Claim Notify Header";
        AgilesText001Txt: Label 'Feld %1 : Es existieren %2 eingehende Palettenzeilen für diese Zeile %3, Löschung / Initialisierung / Änderung nicht möglich !', Comment = '%1 %2 %3';
    begin
        lrc_SalesClaimAdviceHeader.GET(rrc_SalesClaimAdviceLine."Document No.");

        IF lrc_SalesClaimAdviceHeader."Pallet Entry ID" = 0 THEN
            EXIT;

        // Incoming Pallet Lines
        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Entry No.", Posted, "Document Type", "Document No.", "Document Line No.");
        lrc_IncomingPallet.SETRANGE("Entry No.", lrc_SalesClaimAdviceHeader."Pallet Entry ID");
        lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Sales Claim Advice");
        lrc_IncomingPallet.SETRANGE("Document No.", rrc_SalesClaimAdviceLine."Document No.");
        lrc_IncomingPallet.SETRANGE("Document Line No.", rrc_SalesClaimAdviceLine."Line No.");
        IF lrc_IncomingPallet.FIND('-') THEN
            ERROR(AgilesText001Txt, ChangedFieldName, lrc_IncomingPallet.COUNT(), rrc_SalesClaimAdviceLine."Line No.");

        EXIT;
    end;

    var
        lrc_IncomingPallet: Record "POI Incoming Pallet";
        lrc_OutgoingPallet: Record "POI Outgoing Pallet";
        lrc_PalletItemLines: Record "POI Pallet - Item Lines";
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_Pallets: Record "POI Pallets";
        lrc_IncomingPallet2: Record "POI Incoming Pallet";
        lrc_PurchLine: Record "Purchase Line";
        lrc_LocationBinPalletNo: Record "POI Location Bin - Pallet No.";
}