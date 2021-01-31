codeunit 5110700 "POI ADF Recipe & Packing Mgt"
{
    var
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_PackingOrderHeader: Record "POI Pack. Order Header";

    //     Permissions = TableData 32=rim,
    //                   TableData 5802=rim;

    //     procedure ShowRecipe(vco_RezepturCode: Code[20])
    //     var
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_Rezeptur: Record "5110710";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige / Bearbeitung Rezeptur
    //         // ----------------------------------------------------------------------------------------
    //         lrc_RecipePackingSetup.GET();
    //         lrc_RecipePackingSetup.TESTFIELD("Form ID Recipe Card");

    //         lrc_Rezeptur.FILTERGROUP(2);
    //         lrc_Rezeptur.SETRANGE("No.",vco_RezepturCode);
    //         lrc_Rezeptur.FILTERGROUP(0);

    //         FORM.RUNMODAL(lrc_RecipePackingSetup."Form ID Recipe Card",lrc_Rezeptur);
    //     end;

    //     procedure NewRecipe()
    //     var
    //         lrc_Rezeptur: Record "5110710";
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_NoSeries: Record "308";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Neuanlage Rezeptur
    //         // ----------------------------------------------------------------------------------------

    //         lrc_RecipePackingSetup.GET();
    //         lrc_RecipePackingSetup.TESTFIELD("Recipe No. Series");
    //         IF lrc_NoSeries.GET(lrc_RecipePackingSetup."Recipe No. Series") THEN BEGIN
    //           IF lrc_NoSeries."Default Nos." = TRUE THEN BEGIN
    //             lrc_Rezeptur.Reset();
    //             lrc_Rezeptur.INIT();
    //             lrc_Rezeptur."No." := '';
    //             lrc_Rezeptur.INSERT(TRUE);
    //             COMMIT;

    //             ShowRecipe(lrc_Rezeptur."No.");
    //           END;
    //         END;
    //     end;

    //     procedure RecipeInputItems(vrc_RecipeHeader: Record "5110710")
    //     var
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_RecipeInputItems: Record "5110706";
    //         lfm_RecipeInputItems: Form "5110706";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige / Erfassung der Artikel
    //         // --------------------------------------------------------------------------------------

    //         vrc_RecipeHeader.TESTFIELD("No.");
    //         lfm_RecipeInputItems.SetGlobalValues(vrc_RecipeHeader);

    //         lrc_RecipeInputItems.FILTERGROUP(2);
    //         lrc_RecipeInputItems.SETRANGE("Recipe No.",vrc_RecipeHeader."No.");
    //         lrc_RecipeInputItems.FILTERGROUP(0);

    //         lfm_RecipeInputItems.SETTABLEVIEW(lrc_RecipeInputItems);
    //         lfm_RecipeInputItems.RUNMODAL;
    //     end;

    //     procedure RecipeInputAlternativItems(vrc_RecipeInputTradeItem: Record "5110706")
    //     var
    //         lrc_RecipeInputTradeItem: Record "5110706";
    //         lfm_RecipeInputAlternTradeItem: Form "5110711";
    //         AGILES_LT_TEXT001: Label 'Die Ausgangszeile ist eine bereist zugeordnete Zeile!';
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung von alternativen Input Artikel
    //         // ----------------------------------------------------------------------------------------

    //         IF vrc_RecipeInputTradeItem."Attached to Line No." <> 0 THEN
    //           // Die Ausgangszeile ist eine bereist zugeordnete Zeile!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_RecipeInputTradeItem.FILTERGROUP(2);
    //         lrc_RecipeInputTradeItem.SETRANGE("Recipe No.",vrc_RecipeInputTradeItem."Recipe No.");
    //         lrc_RecipeInputTradeItem.SETRANGE("Attached to Line No.",vrc_RecipeInputTradeItem."Line No.");
    //         lrc_RecipeInputTradeItem.FILTERGROUP(0);

    //         lfm_RecipeInputAlternTradeItem.SetGlobalValues(vrc_RecipeInputTradeItem);
    //         lfm_RecipeInputAlternTradeItem.SETTABLEVIEW(lrc_RecipeInputTradeItem);
    //         lfm_RecipeInputAlternTradeItem.RUNMODAL;
    //     end;

    //     procedure RecipeInputPackingItems(vrc_RecipeHeader: Record "5110710")
    //     var
    //         lrc_RecipeInputPackingItem: Record "5110704";
    //         lfm_RecipeInputPackingItem: Form "5110704";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige / Erfassung der Verpackungsartikel
    //         // --------------------------------------------------------------------------------------

    //         vrc_RecipeHeader.TESTFIELD("No.");
    //         lfm_RecipeInputPackingItem.SetGlobalValues(vrc_RecipeHeader);

    //         lrc_RecipeInputPackingItem.FILTERGROUP(2);
    //         lrc_RecipeInputPackingItem.SETRANGE("Recipe No.",vrc_RecipeHeader."No.");
    //         lrc_RecipeInputPackingItem.FILTERGROUP(0);

    //         lfm_RecipeInputPackingItem.SETTABLEVIEW(lrc_RecipeInputPackingItem);
    //         lfm_RecipeInputPackingItem.RUNMODAL;
    //     end;

    //     procedure RecipeInputCosts(vrc_RecipeHeader: Record "5110710")
    //     var
    //         lrc_RecipeInputCost: Record "5110705";
    //         lfm_RecipeInputCost: Form "5110705";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige / Erfassung der Kosten
    //         // --------------------------------------------------------------------------------------

    //         vrc_RecipeHeader.TESTFIELD("No.");

    //         lfm_RecipeInputCost.SetGlobalValues(vrc_RecipeHeader);

    //         lrc_RecipeInputCost.FILTERGROUP(2);
    //         lrc_RecipeInputCost.SETRANGE("Recipe No.",vrc_RecipeHeader."No.");
    //         lrc_RecipeInputCost.FILTERGROUP(0);

    //         lfm_RecipeInputCost.SETTABLEVIEW(lrc_RecipeInputCost);
    //         lfm_RecipeInputCost.RUNMODAL;
    //     end;

    //     procedure CheckExistingTradeItemNo(rco_RecipeCode: Code[20])
    //     var
    //         lrc_RecipeHeader: Record "5110710";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------
    //         lrc_RecipeHeader.GET( rco_RecipeCode );
    //         lrc_RecipeHeader.TESTFIELD( "Item No." );
    //     end;

    //     procedure EditRecipeComment(rco_RecipeCode: Code[20];rin_OutputLine: Integer;rop_Type: Option "Recipe Card","Packing Order",,,"Input Trade Item",,,"Input Cost",,,"Input Packing Material",,,Productionlines,,,"Output Item",,,Label;vco_SourceCode: Code[20];vin_SourceLine: Integer)
    //     var
    //         lrc_RecipeComment: Record "5110707";
    //         lfm_RecipeComment: Form "5110707";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         CLEAR( lfm_RecipeComment );

    //         CASE rop_Type OF
    //           rop_Type::"Recipe Card":
    //             BEGIN
    //               IF rco_RecipeCode = '' THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Packing Order":
    //             BEGIN
    //               IF rco_RecipeCode = '' THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Input Trade Item":
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Input Cost":
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Input Packing Material":
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //           rop_Type::Productionlines:
    //             BEGIN
    //               IF vco_SourceCode = '' THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Output Item":
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //           rop_Type::Label:
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //         END;

    //         lrc_RecipeComment.Reset();
    //         lrc_RecipeComment.SETRANGE("Recipe Code", rco_RecipeCode);
    //         lrc_RecipeComment.SETRANGE("Doc. Line No. Output", rin_OutputLine);
    //         lrc_RecipeComment.SETRANGE(Type, rop_Type);
    //         lrc_RecipeComment.SETRANGE("Source Code", vco_SourceCode);
    //         lrc_RecipeComment.SETRANGE("Source Line No.", vin_SourceLine);

    //         lfm_RecipeComment.SETTABLEVIEW(lrc_RecipeComment);
    //         lfm_RecipeComment.RUN;

    //         CLEAR(lfm_RecipeComment);
    //     end;

    //     procedure EditRecipeLabels(rco_RecipeCode: Code[20];rin_OutputLine: Integer)
    //     var
    //         lrc_RecipeLabels: Record "5110700";
    //         lfm_RecipeLabels: Form "5110700";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         CLEAR(lfm_RecipeLabels);

    //         lrc_RecipeLabels.Reset();
    //         lrc_RecipeLabels.SETRANGE("Recipe Code", rco_RecipeCode);
    //         lrc_RecipeLabels.SETRANGE("Doc. Line No. Output", rin_OutputLine);

    //         lfm_RecipeLabels.SETTABLEVIEW(lrc_RecipeLabels);
    //         lfm_RecipeLabels.RUN;

    //         CLEAR(lfm_RecipeLabels);
    //     end;

    procedure FindItemDirectUnitPrice(vco_ItemNo: Code[20]; vco_BatchVarNo: Code[20]) ldc_DirectUnitPrice: Decimal
    var
        lrc_Item: Record Item;
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_ItemLedgerEntry: Record "Item Ledger Entry";
        lrc_PriceBase: Record "POI Price Base";
        ldc_Quantity: Decimal;
    begin
        // --------------------------------------------------------------------------------------
        // Ermittlung des Einstandspreises
        // --------------------------------------------------------------------------------------

        ldc_DirectUnitPrice := 0;

        IF (vco_ItemNo <> '') AND (vco_BatchVarNo = '') THEN BEGIN
            IF lrc_Item.GET(vco_ItemNo) THEN
                IF lrc_Item."Last Direct Cost" <> 0 THEN
                    ldc_DirectUnitPrice := lrc_Item."Last Direct Cost"
                ELSE
                    ldc_DirectUnitPrice := lrc_Item."Unit Cost";
        END ELSE BEGIN
            IF (vco_BatchVarNo <> '') THEN
                lrc_BatchVariant.GET(vco_BatchVarNo);
            lrc_ItemLedgerEntry.RESET();
            lrc_ItemLedgerEntry.SETCURRENTKEY("Entry Type", "Item No.", "Variant Code", "POI Batch Variant No.", "Drop Shipment", "Location Code", "Posting Date");
            lrc_ItemLedgerEntry.SETRANGE("Item No.", lrc_BatchVariant."Item No.");
            lrc_ItemLedgerEntry.SETRANGE("Entry Type", lrc_ItemLedgerEntry."Entry Type"::Purchase);
            lrc_ItemLedgerEntry.SETRANGE("POI Batch Variant No.", lrc_BatchVariant."No.");
            IF lrc_ItemLedgerEntry.FIND('-') THEN BEGIN
                REPEAT
                    lrc_ItemLedgerEntry.CALCFIELDS("Purchase Amount (Expected)", "Purchase Amount (Actual)");
                    ldc_DirectUnitPrice := ldc_DirectUnitPrice + (lrc_ItemLedgerEntry."Purchase Amount (Expected)" + lrc_ItemLedgerEntry."Purchase Amount (Actual)");
                    ldc_Quantity := ldc_Quantity + lrc_ItemLedgerEntry.Quantity;
                UNTIL lrc_ItemLedgerEntry.NEXT() = 0;
                IF ldc_Quantity <> 0 THEN
                    ldc_DirectUnitPrice := ROUND(ldc_DirectUnitPrice / ldc_Quantity, 0.00001);
            END ELSE BEGIN
                // Einkaufspreis aus Einkaufsbestellung lesen
                lrc_PurchaseLine.RESET();
                lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
                lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
                lrc_PurchaseLine.SETRANGE("No.", lrc_BatchVariant."Item No.");
                lrc_PurchaseLine.SETRANGE("POI Batch Variant No.", lrc_BatchVariant."No.");
                IF lrc_PurchaseLine.FIND('-') THEN
                    ldc_DirectUnitPrice := ROUND(lrc_PurchaseLine."Direct Unit Cost" / lrc_PurchaseLine."Qty. per Unit of Measure", 0.00001)
                ELSE
                    IF lrc_BatchVariant."Price Base (Purch. Price)" <> '' THEN
                        IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price", lrc_BatchVariant."Price Base (Purch. Price)") THEN
                            IF (lrc_PriceBase."Internal Calc. Type" = lrc_PriceBase."Internal Calc. Type"::"Collo Unit") OR
                               (lrc_PriceBase."Internal Calc. Type" = lrc_PriceBase."Internal Calc. Type"::"Base Unit") OR
                               (lrc_PriceBase."Internal Calc. Type" = lrc_PriceBase."Internal Calc. Type"::" ") THEN
                                ldc_DirectUnitPrice := lrc_BatchVariant."Purch. Price (Price Base)";
            END;
        END;
        EXIT(ldc_DirectUnitPrice);
    end;

    //     procedure RecipeChangeStatus(rrc_NewStatus: Option Planning,,Released,,Blocked;var vrc_RecipeHeader: Record "5110710")
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         CASE rrc_NewStatus OF
    //           rrc_NewStatus::Planning:
    //             BEGIN
    //               vrc_RecipeHeader.VALIDATE("Released Userid",'');
    //               vrc_RecipeHeader.VALIDATE("Released Date", 0D);
    //               vrc_RecipeHeader.VALIDATE("Released Time", 0T);
    //             END;
    //           rrc_NewStatus::Released:
    //             BEGIN
    //               vrc_RecipeHeader.VALIDATE("Released Userid", UserID());
    //               vrc_RecipeHeader.VALIDATE("Released Date", WORKDATE);
    //               vrc_RecipeHeader.VALIDATE("Released Time", TIME);
    //             END;
    //           rrc_NewStatus::Blocked:
    //             BEGIN
    //             END;
    //         END;
    //         vrc_RecipeHeader.Status := rrc_NewStatus;
    //         vrc_RecipeHeader.MODIFY();
    //     end;

    //     procedure RecipeCopy(vco_OrgRecipeCode: Code[20]): Code[20]
    //     var
    //         lrc_RecHeader: Record "5110710";
    //         lrc_RecOutputItems: Record "5110708";
    //         lrc_RecInputItems: Record "5110706";
    //         lrc_RecInputPackingItems: Record "5110704";
    //         lrc_RecInputCost: Record "5110705";
    //         lrc_RecComment: Record "5110707";
    //         lrc_RecProductionLines: Record "5110709";
    //         lrc_RecCustomer: Record "5110711";
    //         lrc_RecLabels: Record "5110700";
    //         "-": Integer;
    //         lrc_NewRecHeader: Record "5110710";
    //         lrc_NewRecOutputItems: Record "5110708";
    //         lrc_NewRecInputItems: Record "5110706";
    //         lrc_NewRecInputPackingItems: Record "5110704";
    //         lrc_NewRecInputCost: Record "5110705";
    //         lrc_NewRecComment: Record "5110707";
    //         lrc_NewRecProductionLines: Record "5110709";
    //         lrc_NewRecCustomer: Record "5110711";
    //         lrc_NewRecLabels: Record "5110700";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Rezeptur Kopieren
    //         // ----------------------------------------------------------------------------------------

    //         lrc_RecHeader.GET(vco_OrgRecipeCode);

    //         lrc_NewRecHeader := lrc_RecHeader;
    //         lrc_NewRecHeader."No." := '';
    //         lrc_NewRecHeader.INSERT(TRUE);

    //         lrc_RecOutputItems.SETRANGE("Recipe No.",lrc_RecHeader."No.");
    //         IF lrc_RecOutputItems.FIND('-') THEN
    //           REPEAT
    //             lrc_NewRecOutputItems := lrc_RecOutputItems;
    //             lrc_NewRecOutputItems."Recipe No." := lrc_NewRecHeader."No.";
    //             lrc_NewRecOutputItems.insert();
    //           UNTIL lrc_RecOutputItems.NEXT() = 0;

    //         lrc_RecInputItems.SETRANGE("Recipe No.",lrc_RecHeader."No.");
    //         IF lrc_RecInputItems.FIND('-') THEN
    //           REPEAT
    //             lrc_NewRecInputItems := lrc_RecInputItems;
    //             lrc_NewRecInputItems."Recipe No." := lrc_NewRecHeader."No.";
    //             lrc_NewRecInputItems.insert();
    //           UNTIL lrc_RecInputItems.NEXT() = 0;

    //         lrc_RecInputPackingItems.SETRANGE("Recipe No.",lrc_RecHeader."No.");
    //         IF lrc_RecInputPackingItems.FIND('-') THEN
    //           REPEAT
    //             lrc_NewRecInputPackingItems := lrc_RecInputPackingItems;
    //             lrc_NewRecInputPackingItems."Recipe No." := lrc_NewRecHeader."No.";
    //             lrc_NewRecInputPackingItems.insert();
    //           UNTIL lrc_RecInputPackingItems.NEXT() = 0;

    //         lrc_RecInputCost.SETRANGE("Recipe No.",lrc_RecHeader."No.");
    //         IF lrc_RecInputCost.FIND('-') THEN
    //           REPEAT
    //             lrc_NewRecInputCost := lrc_RecInputCost;
    //             lrc_NewRecInputCost."Recipe No." := lrc_NewRecHeader."No.";
    //             lrc_NewRecInputCost.insert();
    //           UNTIL lrc_RecInputCost.NEXT() = 0;

    //         lrc_RecComment.SETRANGE("Recipe Code",lrc_RecHeader."No.");
    //         IF lrc_RecComment.FIND('-') THEN
    //           REPEAT
    //             lrc_NewRecComment := lrc_RecComment;
    //             lrc_NewRecComment."Recipe Code" := lrc_NewRecHeader."No.";
    //             lrc_NewRecComment.insert();
    //           UNTIL lrc_RecComment.NEXT() = 0;

    //         lrc_RecProductionLines.SETRANGE("Recipe No.",lrc_RecHeader."No.");
    //         IF lrc_RecProductionLines.FIND('-') THEN
    //           REPEAT
    //             lrc_NewRecProductionLines := lrc_RecProductionLines;
    //             lrc_NewRecProductionLines."Recipe No." := lrc_NewRecHeader."No.";
    //             lrc_NewRecProductionLines.insert();
    //           UNTIL lrc_RecProductionLines.NEXT() = 0;

    //         lrc_RecCustomer.SETRANGE("Recipe No.",lrc_RecHeader."No.");
    //         IF lrc_RecCustomer.FIND('-') THEN
    //           REPEAT
    //             lrc_NewRecCustomer := lrc_RecCustomer;
    //             lrc_NewRecCustomer."Recipe No." := lrc_NewRecHeader."No.";
    //             lrc_NewRecCustomer.insert();
    //           UNTIL lrc_RecCustomer.NEXT() = 0;

    //         lrc_RecLabels.SETRANGE("Recipe Code",lrc_RecHeader."No.");
    //         IF lrc_RecLabels.FIND('-') THEN
    //           REPEAT
    //             lrc_NewRecLabels := lrc_RecLabels;
    //             lrc_NewRecLabels."Recipe Code" := lrc_NewRecHeader."No.";
    //             lrc_NewRecLabels.insert();
    //           UNTIL lrc_RecLabels.NEXT() = 0;


    //         EXIT(lrc_NewRecHeader."No.");
    //     end;

    //     procedure PurchLineGetPriceUnit(vrc_PackOrderOutputItems: Record "5110713"): Code[10]
    //     var
    //         lrc_PriceCalculation: Record "5110320";
    //         lrc_UnitofMeasure: Record "204";
    //         AGILES_LT_TEXT001: Label 'Preisbasis nicht zulässig!';
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der Preiseinheit
    //         //
    //         // Achtung : Funktion aus der Codeunit Purch. Mgt übernommen und angepasst, bei Änderungen
    //         //           beide Stellen pflegen
    //         // ---------------------------------------------------------------------------------------

    //         IF vrc_PackOrderOutputItems."Price Base (Purch. Price)" = '' THEN
    //           EXIT('');
    //         IF vrc_PackOrderOutputItems."Unit of Measure Code" = '' THEN
    //           EXIT('');

    //         lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price",
    //                                  vrc_PackOrderOutputItems."Price Base (Purch. Price)");

    //         CASE lrc_PriceCalculation."Internal Calc. Type" OF
    //         lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
    //           BEGIN
    //             vrc_PackOrderOutputItems.TESTFIELD("Base Unit of Measure (BU)");
    //             EXIT(vrc_PackOrderOutputItems."Base Unit of Measure (BU)");
    //           END;

    //         lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
    //           BEGIN
    //             // Preisbasis nicht zulässig!
    //             ERROR(AGILES_LT_TEXT001);
    //           END;

    //         lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":
    //           BEGIN
    //             lrc_UnitofMeasure.GET(vrc_PackOrderOutputItems."Unit of Measure Code");
    //             IF lrc_UnitofMeasure."Packing Unit of Measure (PU)" <> '' THEN
    //               EXIT(lrc_UnitofMeasure."Packing Unit of Measure (PU)")
    //             ELSE
    //               EXIT('');
    //           END;

    //         lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
    //           BEGIN
    //             EXIT(vrc_PackOrderOutputItems."Unit of Measure Code");
    //           END;

    //         lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
    //           BEGIN
    //             vrc_PackOrderOutputItems.TESTFIELD("Transport Unit of Measure (TU)");
    //             vrc_PackOrderOutputItems.TESTFIELD("Qty. (Unit) per Transp.(TU)");
    //             EXIT(vrc_PackOrderOutputItems."Transport Unit of Measure (TU)");
    //           END;

    //         lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
    //           BEGIN
    //             lrc_PriceCalculation.TESTFIELD("Price Unit Weighting");
    //             EXIT(lrc_PriceCalculation."Price Unit Weighting");
    //           END;

    //         lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
    //           BEGIN
    //             lrc_PriceCalculation.TESTFIELD("Price Unit Weighting");
    //             EXIT(lrc_PriceCalculation."Price Unit Weighting");
    //           END;

    //         lrc_PriceCalculation."Internal Calc. Type"::"Total Price":
    //           BEGIN
    //             EXIT('');
    //           END;
    //         END;
    //     end;

    //     procedure PurchCalcUnitPrice(vrc_PackOrderOutputItems: Record "5110713";vbn_MarketUnitPrice: Boolean): Decimal
    //     var
    //         lrc_PriceCalculation: Record "5110320";
    //         lrc_ItemUnitofMeasure: Record "5404";
    //         lrc_UnitofMeasure: Record "204";
    //         ldc_Preis: Decimal;
    //         ldc_PreisProKollo: Decimal;
    //         AGILES_LT_TEXT001: Label 'Bitte geben Sie zuerst die Menge Kolli pro Palette ein!';
    //         AGILES_LT_TEXT002: Label 'Bitte geben Sie zuerst die Menge Kolli ein!';
    //         AGILES_LT_TEXT003: Label 'Preisberechnungsart nicht zulässig!';
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung des Einkaufseinheiten Preises
    //         //
    //         // Achtung : Funktion aus der Codeunit Purch. Mgt übernommen und angepasst, bei Änderungen
    //         //           beide Stellen pflegen
    //         // ---------------------------------------------------------------------------------------

    //         IF vbn_MarketUnitPrice = TRUE THEN BEGIN
    //           IF vrc_PackOrderOutputItems."Item No." = '' THEN
    //             EXIT( vrc_PackOrderOutputItems."Market Unit Cost (Price Base)");
    //           IF vrc_PackOrderOutputItems."Unit of Measure Code" = '' THEN
    //             EXIT(vrc_PackOrderOutputItems."Market Unit Cost (Price Base)");
    //           IF vrc_PackOrderOutputItems."Market Unit Cost (Price Base)" = 0 THEN
    //             EXIT(vrc_PackOrderOutputItems."Market Unit Cost (Price Base)");
    //           IF vrc_PackOrderOutputItems."Price Base (Purch. Price)" = '' THEN
    //             EXIT(vrc_PackOrderOutputItems."Market Unit Cost (Price Base)");
    //           ldc_Preis := vrc_PackOrderOutputItems."Market Unit Cost (Price Base)";

    //         END ELSE BEGIN
    //           /*
    //           IF vrc_PackOrderOutputItems."Item No." = '' THEN
    //             EXIT(vrc_PackOrderOutputItems."Purch. Price (Price Base)");
    //           IF vrc_PackOrderOutputItems."Unit of Measure Code" = '' THEN
    //             EXIT(vrc_PackOrderOutputItems."Purch. Price (Price Base)");
    //           IF vrc_PackOrderOutputItems."Purch. Price (Price Base)" = 0 THEN
    //             EXIT(vrc_PackOrderOutputItems."Purch. Price (Price Base)");
    //           IF vrc_PackOrderOutputItems."Price Base (Purch. Price)" = '' THEN
    //             EXIT(vrc_PackOrderOutputItems."Purch. Price (Price Base)");
    //           ldc_Preis := vrc_PackOrderOutputItems."Purch. Price (Price Base)";
    //           */
    //           ldc_Preis := vrc_PackOrderOutputItems."Market Unit Cost (Price Base)";
    //         END;

    //         IF NOT lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price",
    //                                  vrc_PackOrderOutputItems."Price Base (Purch. Price)") THEN
    //           EXIT(ldc_Preis);

    //         CASE lrc_PriceCalculation."Internal Calc. Type" OF

    //           // ---------------------------------------------------------------------------------------------
    //           // Preiseingabe entspricht dem Preis für einen Kollo --> Umrechnung in Verkaufseinheit
    //           // KOLLO: Menge (Kollo) * Preis
    //           // ---------------------------------------------------------------------------------------------
    //           lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
    //             BEGIN
    //               vrc_PackOrderOutputItems.TESTFIELD("Price Unit of Measure");
    //               lrc_UnitofMeasure.GET(vrc_PackOrderOutputItems."Price Unit of Measure");
    //               lrc_UnitofMeasure.TESTFIELD("Qty. (BU) per Unit of Measure");
    //               ldc_Preis := ldc_Preis /
    //                            lrc_UnitofMeasure."Qty. (BU) per Unit of Measure" *
    //                            vrc_PackOrderOutputItems."Qty. per Unit of Measure";
    //               EXIT(ldc_Preis);
    //             END;


    //           // ---------------------------------------------------------------------------------------------
    //           // VERPACKUNG: Menge (Kollo) * Menge (UE) * Preis
    //           // ---------------------------------------------------------------------------------------------
    //           lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":
    //             BEGIN
    //               vrc_PackOrderOutputItems.TESTFIELD("Price Unit of Measure");
    //               lrc_UnitofMeasure.GET(vrc_PackOrderOutputItems."Unit of Measure Code");
    //               lrc_UnitofMeasure.TESTFIELD("Packing Unit of Measure (PU)",vrc_PackOrderOutputItems."Price Unit of Measure");
    //               lrc_UnitofMeasure.TESTFIELD("Qty. (PU) per Unit of Measure");
    //               ldc_Preis := ldc_Preis *
    //                            lrc_UnitofMeasure."Qty. (PU) per Unit of Measure";
    //               EXIT(ldc_Preis);
    //             END;


    //           // ---------------------------------------------------------------------------------------------
    //           // INHALT: Menge (Kollo) * Menge (UE) * Menge (IE) * Preis
    //           // ---------------------------------------------------------------------------------------------
    //           lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
    //             BEGIN
    //               // Preisberechnungsart nicht zulässig!
    //               ERROR(AGILES_LT_TEXT003);
    //             END;


    //           // ---------------------------------------------------------------------------------------------
    //           // BASIS: Menge (Kollo) * Menge (UE) * Menge (IE) * Preis
    //           // ---------------------------------------------------------------------------------------------
    //           lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
    //             BEGIN
    //               vrc_PackOrderOutputItems.TESTFIELD("Base Unit of Measure (BU)");
    //               ldc_Preis := ldc_Preis * vrc_PackOrderOutputItems."Qty. per Unit of Measure";
    //               EXIT(ldc_Preis);
    //             END;

    //           // ---------------------------------------------------------------------------------------------
    //           // PALETTE: Menge (TE) * Preis
    //           // ---------------------------------------------------------------------------------------------
    //           lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
    //             BEGIN
    //         // sf offen        ldc_Preis := vrc_PackOrderOutputItems."Purch. Price (Price Base)";
    //                 ldc_Preis := 0;
    //                 IF vrc_PackOrderOutputItems."Qty. (Unit) per Transp.(TU)" <> 0 THEN BEGIN
    //                   ldc_Preis := ldc_Preis / vrc_PackOrderOutputItems."Qty. (Unit) per Transp.(TU)";
    //                   EXIT(ldc_Preis);
    //                 END ELSE BEGIN
    //                   ldc_Preis := 0;
    //                   MESSAGE('Preis Null, da Menge pro Palette nicht vorhanden!');
    //                   EXIT(ldc_Preis);
    //                 END;
    //             END;

    //           // ---------------------------------------------------------------------------------------------
    //           // NETTO: Nettogewicht (gesamt) * Preis
    //           // ---------------------------------------------------------------------------------------------
    //           lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
    //             BEGIN
    //               ldc_Preis := ldc_Preis * vrc_PackOrderOutputItems."Net Weight";
    //               EXIT(ldc_Preis);
    //             END;

    //           // ---------------------------------------------------------------------------------------------
    //           // BRUTTO: Bruttogewicht (gesamt) * Preis
    //           // ---------------------------------------------------------------------------------------------
    //           lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
    //             BEGIN
    //               ldc_Preis := ldc_Preis * vrc_PackOrderOutputItems."Gross Weight";
    //               EXIT(ldc_Preis);
    //             END;

    //           // ---------------------------------------------------------------------------------------------
    //           // GESAMT: Gesamtpreis
    //           // ---------------------------------------------------------------------------------------------
    //           lrc_PriceCalculation."Internal Calc. Type"::"Total Price":
    //             BEGIN
    //               IF vrc_PackOrderOutputItems.Quantity <> 0 THEN BEGIN
    //                 ldc_Preis := ldc_Preis / vrc_PackOrderOutputItems.Quantity;
    //                 EXIT(ldc_Preis);
    //               END ELSE
    //                 // Bitte geben Sie zuerst die Menge ein!
    //                 ERROR(AGILES_LT_TEXT002);
    //             END;

    //           // ---------------------------------------------------------------------------------------------
    //           // Ausnahmeregelung
    //           // ---------------------------------------------------------------------------------------------
    //           ELSE
    //             BEGIN
    //               EXIT(ldc_Preis);
    //             END;

    //         END;

    //     end;

    //     procedure "-- PACKING --"()
    //     begin
    //     end;

    //     procedure SelectPackDocType(): Code[10]
    //     var
    //         lrc_PackDocType: Record "5110725";
    //         lfm_PackDocType: Form "5110751";
    //         lrc_UserSetup: Record "91";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Auswahl der Belegart
    //         // -----------------------------------------------------------------------------

    //         lrc_PackDocType.FILTERGROUP(2);
    //         lrc_PackDocType.SETRANGE("In Selection",TRUE);
    //         IF lrc_UserSetup.GET( USERID ) THEN BEGIN
    //           IF lrc_UserSetup."Pack. Doc. Subtype Filter" <> '' THEN BEGIN
    //              lrc_PackDocType.SETFILTER( Code, lrc_UserSetup."Pack. Doc. Subtype Filter" );
    //           END;
    //         END;

    //         lrc_PackDocType.FILTERGROUP(0);
    //         IF lrc_PackDocType.COUNT() > 1 THEN BEGIN
    //           lfm_PackDocType.LOOKUPMODE := TRUE;
    //           lfm_PackDocType.SETTABLEVIEW(lrc_PackDocType);
    //           IF lfm_PackDocType.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT('');
    //           lrc_PackDocType.Reset();
    //           lfm_PackDocType.GETRECORD(lrc_PackDocType);
    //         END ELSE BEGIN
    //           IF NOT lrc_PackDocType.FINDFIRST() THEN
    //             EXIT('');
    //         END;

    //         EXIT(lrc_PackDocType.Code);
    //     end;

    procedure PackShowOrder(vco_PackingOrderCode: Code[20])
    var
        lrc_RecipePackingSetup: Record "POI Recipe & Packing Setup";
        lrc_PackDocType: Record "POI Pack. Doc. Subtype";
    begin
        // ----------------------------------------------------------------------------------------
        // Funktion zur Anzeige / Bearbeitung Packereiauftrag
        // ----------------------------------------------------------------------------------------
        lrc_PackingOrderHeader.Reset();
        lrc_RecipePackingSetup.GET();
        lrc_RecipePackingSetup.TESTFIELD("Page ID Pack. Order Card");

        IF lrc_RecipePackingSetup."Page Up/Down Pack. Order Card" = FALSE THEN
            lrc_PackingOrderHeader.FILTERGROUP(2);
        lrc_PackingOrderHeader.SETRANGE("No.", vco_PackingOrderCode);
        lrc_PackingOrderHeader.FILTERGROUP(0);

        lrc_PackingOrderHeader.FINDFIRST();
        IF lrc_PackDocType.GET(lrc_PackingOrderHeader."Pack. Doc. Type Code") THEN BEGIN
            lrc_PackDocType.TESTFIELD("Page ID Pack. Order Card");
            Page.RUN(lrc_PackDocType."Page ID Pack. Order Card", lrc_PackingOrderHeader);
        END ELSE
            Page.RUN(lrc_RecipePackingSetup."Page ID Pack. Order Card", lrc_PackingOrderHeader);
    end;

    //     procedure PackNewOrder(vco_PackDocType: Code[10])
    //     var
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lrc_PackingOrderHeader: Record "5110712";
    //         lco_MasterBatchCode: Code[20];
    //         lco_BatchCode: Code[20];
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_Location: Record "14";
    //         lrc_BatchSetup: Record "5110363";
    //         "--- PAC 011 00000000": Integer;
    //         lrc_PackDocSubtype: Record "5110725";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Neuanlage Packereiauftrag
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackingOrderHeader.Reset();
    //         lrc_PackingOrderHeader.INIT();
    //         lrc_PackingOrderHeader."No." := '';
    //         lrc_PackingOrderHeader."Document Type" := lrc_PackingOrderHeader."Document Type"::"Packing Order";
    //         lrc_PackingOrderHeader."Pack. Doc. Type Code" := vco_PackDocType;
    //         lrc_PackingOrderHeader.INSERT(TRUE);

    //         lrc_RecipePackingSetup.GET();

    //         // PAC 011 00000000.s
    //         IF ( vco_PackDocType = '' ) OR
    //            ( NOT lrc_PackDocSubtype.GET( vco_PackDocType ) ) THEN BEGIN
    //            lrc_PackDocSubtype.INIT();
    //         END;
    //         IF lrc_PackDocSubtype."Default Output Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Outp. Item Location Code" := lrc_PackDocSubtype."Default Output Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Outp. Item Location Code" := lrc_RecipePackingSetup."Default Output Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         IF lrc_PackDocSubtype."Default Packing Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Inp. Packing Item Loc. Code" := lrc_PackDocSubtype."Default Packing Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Inp. Packing Item Loc. Code" := lrc_RecipePackingSetup."Default Packing Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         IF lrc_PackDocSubtype."Default Empties Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Inp. Empties Item Loc. Code" := lrc_PackDocSubtype."Default Empties Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Inp. Empties Item Loc. Code" := lrc_RecipePackingSetup."Default Empties Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         // PAC 011 00000000.e

    //         IF lrc_PackingOrderHeader."Outp. Item Location Code" <> '' THEN BEGIN
    //           IF lrc_Location.GET( lrc_PackingOrderHeader."Outp. Item Location Code" ) THEN BEGIN
    //             IF lrc_Location."Vendor No." <> '' THEN BEGIN
    //               lrc_PackingOrderHeader.VALIDATE("Vendor No.", lrc_Location."Vendor No.");
    //               lrc_PackingOrderHeader.VALIDATE("Pack.-by Vendor No.", lrc_Location."Vendor No.");
    //             END;
    //           END;
    //         END;

    //         lcu_BatchMgt.PackNewMasterBatch(lrc_PackingOrderHeader,lco_MasterBatchCode);
    //         lrc_PackingOrderHeader."Master Batch No." := lco_MasterBatchCode;
    //         lrc_PackingOrderHeader.Modify();

    //         lrc_BatchSetup.GET();
    //         IF lrc_BatchSetup."Pack. Allocation Batch No." =
    //                lrc_BatchSetup."Pack. Allocation Batch No."::"One Batch No. per Order" THEN BEGIN
    //           lcu_BatchMgt.PackNewBatch(lrc_PackingOrderHeader,lco_BatchCode);
    //           lrc_PackingOrderHeader."Batch No." := lco_BatchCode;
    //           lrc_PackingOrderHeader.Modify();
    //         END;

    //         COMMIT;

    //         PackShowOrder(lrc_PackingOrderHeader."No.");
    //     end;

    //     procedure PackInputItems(vrc_PackOrderHeader: Record "5110712")
    //     var
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_PackOrderInputItems: Record "5110714";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige und Erfassung der Artikel (Rohware) Packereiauftrag
    //         // --------------------------------------------------------------------------------------

    //         vrc_PackOrderHeader.TESTFIELD("No.");

    //         lrc_RecipePackingSetup.GET();
    //         lrc_RecipePackingSetup.TESTFIELD("Form ID Input Item");

    //         lrc_PackOrderInputItems.FILTERGROUP(2);
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",vrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputItems.FILTERGROUP(0);

    //         FORM.RUNMODAL(lrc_RecipePackingSetup."Form ID Input Item",lrc_PackOrderInputItems);
    //     end;

    //     procedure PackInputPackItems(vrc_PackOrderHeader: Record "5110712")
    //     var
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige und Erfassung der Verpackungsartikel Packereiauftrag
    //         // --------------------------------------------------------------------------------------

    //         vrc_PackOrderHeader.TESTFIELD("No.");

    //         lrc_RecipePackingSetup.GET();
    //         lrc_RecipePackingSetup.TESTFIELD("Form ID Input Packing Material");

    //         lrc_PackOrderInputPackItems.FILTERGROUP(2);
    //         lrc_PackOrderInputPackItems.SETRANGE("Doc. No.",vrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputPackItems.FILTERGROUP(0);

    //         FORM.RUNMODAL(lrc_RecipePackingSetup."Form ID Input Packing Material",lrc_PackOrderInputPackItems);
    //     end;

    //     procedure PackInputCosts(vrc_PackOrderHeader: Record "5110712")
    //     var
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige und Erfassung der Kosten Packereiauftrag
    //         // --------------------------------------------------------------------------------------

    //         vrc_PackOrderHeader.TESTFIELD("No.");

    //         // Packkosten aufgrund von Vorgaben kalkulieren
    //         CalcDefaultPackingCost(vrc_PackOrderHeader."No.");
    //         COMMIT;

    //         lrc_RecipePackingSetup.GET();
    //         lrc_RecipePackingSetup.TESTFIELD("Form ID Input Res. and Costs");

    //         lrc_PackOrderInputCosts.FILTERGROUP(2);
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",vrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.FILTERGROUP(0);

    //         FORM.RUNMODAL(lrc_RecipePackingSetup."Form ID Input Res. and Costs",lrc_PackOrderInputCosts);

    //         // Kosten kalkulieren
    //         PackCalcCosts(vrc_PackOrderHeader."No.",TRUE);

    //         // Kosten auf die Outputzeilen verteilen
    //         AllocateCostToOutputLines(vrc_PackOrderHeader."No.");
    //     end;

    //     procedure PackComment(rco_DocNo: Code[20];vin_DocLineNoOutput: Integer;rop_Type: Option "Recipe Card","Packing Order",,,"Input Trade Item",,,"Input Cost",,,"Input Packing Material",,,Productionlines,,,"Output Item",,,Label;vin_SourceLine: Integer)
    //     var
    //         lrc_PackOrderComment: Record "5110719";
    //         lfm_PackOrderComment: Form "5110736";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         CLEAR(lfm_PackOrderComment);

    //         CASE rop_Type OF
    //           rop_Type::"Recipe Card":
    //             BEGIN
    //               IF rco_DocNo = '' THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Packing Order":
    //             BEGIN
    //               IF rco_DocNo = '' THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Input Trade Item":
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Input Cost":
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Input Packing Material":
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //           rop_Type::"Output Item":
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //           rop_Type::Label:
    //             BEGIN
    //               IF vin_SourceLine = 0 THEN
    //                 EXIT;
    //             END;
    //         END;

    //         lrc_PackOrderComment.Reset();
    //         lrc_PackOrderComment.SETRANGE( "Doc. No.", rco_DocNo );
    //         lrc_PackOrderComment.SETRANGE( "Doc. Line No. Output", vin_DocLineNoOutput );
    //         lrc_PackOrderComment.SETRANGE( Type, rop_Type );
    //         lrc_PackOrderComment.SETRANGE( "Source Line No.", vin_SourceLine );

    //         lfm_PackOrderComment.SETTABLEVIEW( lrc_PackOrderComment );
    //         lfm_PackOrderComment.RUN;

    //         CLEAR( lfm_PackOrderComment );
    //     end;

    //     procedure PackLabels(rco_DocNo: Code[20];vin_DocLineNoOutput: Integer)
    //     var
    //         lrc_PackOrderLabels: Record "5110718";
    //         lfm_PackOrderLabels: Form "5110737";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         CLEAR(lfm_PackOrderLabels);

    //         lrc_PackOrderLabels.Reset();
    //         lrc_PackOrderLabels.SETRANGE("Doc. No.", rco_DocNo);
    //         lrc_PackOrderLabels.SETRANGE("Doc. Line No. Output", vin_DocLineNoOutput);

    //         lfm_PackOrderLabels.SETTABLEVIEW(lrc_PackOrderLabels);
    //         lfm_PackOrderLabels.RUN;

    //         CLEAR(lfm_PackOrderLabels);
    //     end;

    //     procedure ActualLotNoInAllLines(rrc_PackOrderHeader: Record "5110712")
    //     var
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_Resource: Record Resource;
    //         lrc_ProductionLines: Record "5110703";
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lco_WorkLayerLeaderSignalLotNo: Code[2];
    //         lco_ProductionLineSignalLotNo: Code[2];
    //         lco_LotNo: Code[20];
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         lrc_RecipePackingSetup.GET();

    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.", rrc_PackOrderHeader."No.");
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN

    //           lco_WorkLayerLeaderSignalLotNo := '';
    //           lco_ProductionLineSignalLotNo := '';

    //           IF lrc_Resource.GET( rrc_PackOrderHeader."Shift Supervisior" ) THEN BEGIN
    //         //xx    lco_WorkLayerLeaderSignalLotNo := lrc_Resource."Signal Lot. No.";
    //           END;

    //           REPEAT
    //             IF lrc_PackOrderOutputItems."Quantity Produced" = 0 THEN BEGIN
    //               IF lrc_ProductionLines.GET( lrc_PackOrderOutputItems."Production Line Code" ) THEN BEGIN
    //                 lco_ProductionLineSignalLotNo := lrc_ProductionLines."Signal Lot. No.";
    //               END;

    //               // PAC 005 00000000.s
    //               lco_LotNo := lrc_RecipePackingSetup."Preallocation Lot No.";
    //               // PAC 005 00000000.e

    //               IF lrc_PackOrderOutputItems."Promised Receipt Date" <> 0D THEN BEGIN

    //                 // Kalenderwoche Lieferdatum
    //                 lco_LotNo := lco_LotNo + ' ' +
    //                              FORMAT(DATE2DWY(lrc_PackOrderOutputItems."Promised Receipt Date", 2));

    //                 // Tag der Kalenderwoche Lieferdatum
    //                 lco_LotNo := lco_LotNo + '' +
    //                              FORMAT(DATE2DWY(lrc_PackOrderOutputItems."Promised Receipt Date", 1));

    //                 // Arbeitstag der Woche Packdatum ( Mo = 1 )
    //                 lco_LotNo := lco_LotNo + ' ' +
    //                              FORMAT(DATE2DMY(rrc_PackOrderHeader."Packing Date", 1));

    //               END;

    //               // Maschinennummer
    //               lco_LotNo := lco_LotNo + '' + lco_ProductionLineSignalLotNo;
    //               // Schichtleiter
    //               lco_LotNo := lco_LotNo + ' ' + lco_WorkLayerLeaderSignalLotNo;

    //               lrc_PackOrderOutputItems.VALIDATE("Lot No.", lco_LotNo);
    //               lrc_PackOrderOutputItems.MODIFY(TRUE);

    //             END;
    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //         END;
    //     end;

    //     procedure ActualLotNoInActualLine(var vrc_PackOrderOutputItems: Record "5110713")
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_Resource: Record Resource;
    //         lrc_ProductionLines: Record "5110703";
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lco_WorkLayerLeaderSignalLotNo: Code[2];
    //         lco_ProductionLineSignalLotNo: Code[2];
    //         lco_LotNo: Code[20];
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         // PAC 005 00000000.s
    //         lrc_RecipePackingSetup.GET();
    //         // PAC 005 00000000.e

    //         // PAC 009 00000000.s
    //         // IF (vrc_PackOrderOutputItems."Type of Packing Product" <>
    //         IF (vrc_PackOrderOutputItems."Type of Packing Product" >
    //         // PAC 009 00000000.e
    //             vrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product") OR
    //            (vrc_PackOrderOutputItems."Quantity Produced" <> 0) THEN BEGIN
    //           EXIT;
    //         END;

    //         lrc_PackOrderHeader.GET( vrc_PackOrderOutputItems."Doc. No." );

    //         lco_WorkLayerLeaderSignalLotNo := '';
    //         lco_ProductionLineSignalLotNo := '';

    //         IF lrc_Resource.GET( lrc_PackOrderHeader."Shift Supervisior" ) THEN BEGIN
    //         //xx  lco_WorkLayerLeaderSignalLotNo := lrc_Resource."Signal Lot. No.";
    //         END;

    //         IF lrc_ProductionLines.GET( vrc_PackOrderOutputItems."Production Line Code" ) THEN BEGIN
    //           lco_ProductionLineSignalLotNo := lrc_ProductionLines."Signal Lot. No.";
    //         END;

    //         // PAC 005 00000000.s
    //         lco_LotNo := lrc_RecipePackingSetup."Preallocation Lot No.";
    //         // PAC 005 00000000.e

    //         IF vrc_PackOrderOutputItems."Promised Receipt Date" <> 0D THEN BEGIN
    //           // Kalenderwoche Packdatum
    //           lco_LotNo := lco_LotNo + ' ' +
    //                        FORMAT(DATE2DWY(lrc_PackOrderHeader."Packing Date", 2));
    //           // Tag der Kalenderwoche Packdatum
    //           lco_LotNo := lco_LotNo + '' +
    //                        FORMAT(DATE2DWY(lrc_PackOrderHeader."Packing Date", 1));
    //           // Arbeitstag der Woche Lieferdatum ( Mo = 1 )
    //           lco_LotNo := lco_LotNo + ' ' +
    //                        FORMAT(DATE2DMY(vrc_PackOrderOutputItems."Promised Receipt Date", 1));
    //         END;

    //         // Maschinennummer
    //         lco_LotNo := lco_LotNo + '' + lco_ProductionLineSignalLotNo;
    //         // Schichtleiter
    //         lco_LotNo := lco_LotNo + ' ' + lco_WorkLayerLeaderSignalLotNo;

    //         vrc_PackOrderOutputItems.VALIDATE("Lot No.", lco_LotNo);
    //     end;

    //     procedure PackOrderChangeStatus(rrc_NewStatus: Option Open,Registered,Deleted;var vrc_PackOrderHeader: Record "5110712")
    //     var
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //         AGILES_LT_TEXT001: Label 'Für die Outputzeile %1, %2, Menge %3 besteht noch eine zu buchende Restmenge von %4, Trotzdem registrieren ?';
    //         AGILES_LT_TEXT002: Label 'Für die Inputartikel, Zeile %1, %2, Menge %3 besteht noch eine zu buchende Restmenge von %4, Trotzdem registrieren ?';
    //         AGILES_LT_TEXT003: Label 'Für die Input Verpackungsartikel, Zeile %1, %2, Menge %3 besteht noch eine zu buchende Restmenge von %4, Trotzdem registrieren ?';
    //         AGILES_LT_TEXT004: Label 'Für die Inputkosten, Zeile %1, %2, Menge %3 besteht noch eine zu buchende Restmenge von %4, Trotzdem registrieren ?';
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         IF ((rrc_NewStatus = rrc_NewStatus::Registered) OR
    //             (rrc_NewStatus = rrc_NewStatus::Deleted)) AND
    //            // POI 004.S
    //            //(vrc_PackOrderHeader.Status = vrc_PackOrderHeader.Status::Open) THEN BEGIN
    //            (vrc_PackOrderHeader.Status = vrc_PackOrderHeader.Status::Open) OR
    //            (vrc_PackOrderHeader.Status = vrc_PackOrderHeader.Status::"8") THEN BEGIN
    //            // POI 004.E

    //           lrc_PackOrderOutputItems.Reset();
    //           lrc_PackOrderOutputItems.SETRANGE( "Doc. No.", vrc_PackOrderHeader."No." );
    //           IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //             REPEAT
    //               IF (lrc_PackOrderOutputItems.Quantity <> 0) AND
    //                  (lrc_PackOrderOutputItems.Quantity <> lrc_PackOrderOutputItems."Quantity Produced") THEN BEGIN
    //                 IF NOT CONFIRM(AGILES_LT_TEXT001, TRUE, lrc_PackOrderOutputItems."Line No.",
    //                                lrc_PackOrderOutputItems."Item No.", lrc_PackOrderOutputItems.Quantity,
    //                                lrc_PackOrderOutputItems."Remaining Quantity" ) THEN BEGIN
    //                   ERROR('');
    //                 END;
    //               END;
    //             UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //           END;

    //           lrc_PackOrderInputItems.Reset();
    //           lrc_PackOrderOutputItems.SETRANGE( "Doc. No.", vrc_PackOrderHeader."No." );
    //           IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //             REPEAT
    //               IF (lrc_PackOrderInputItems.Quantity <> 0) AND
    //                  (lrc_PackOrderInputItems.Quantity <> lrc_PackOrderInputItems."Quantity Consumed") THEN BEGIN
    //                 IF NOT CONFIRM(AGILES_LT_TEXT002, TRUE, lrc_PackOrderInputItems."Line No.",
    //                                lrc_PackOrderInputItems."Item No.", lrc_PackOrderInputItems.Quantity,
    //                                lrc_PackOrderInputItems."Remaining Quantity") THEN BEGIN
    //                   ERROR('');
    //                 END;
    //               END;
    //             UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //           END;

    //           lrc_PackOrderInputPackItems.Reset();
    //           lrc_PackOrderInputPackItems.SETRANGE( "Doc. No.", vrc_PackOrderHeader."No." );
    //           IF lrc_PackOrderInputPackItems.FIND('-') THEN BEGIN
    //             REPEAT
    //               IF (lrc_PackOrderInputPackItems.Quantity <> 0) AND
    //                  (lrc_PackOrderInputPackItems.Quantity <> lrc_PackOrderInputPackItems."Quantity Consumed") THEN BEGIN
    //                 IF NOT CONFIRM(AGILES_LT_TEXT003, TRUE, lrc_PackOrderInputPackItems."Line No.",
    //                                lrc_PackOrderInputPackItems."Item No.", lrc_PackOrderInputPackItems.Quantity,
    //                                lrc_PackOrderInputPackItems."Remaining Quantity") THEN BEGIN
    //                   ERROR('');
    //                 END;
    //               END;
    //             UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //           END;

    //           lrc_PackOrderInputCosts.Reset();
    //           lrc_PackOrderInputCosts.SETRANGE( "Doc. No.", vrc_PackOrderHeader."No." );
    //           lrc_PackOrderInputCosts.SETRANGE( Type, lrc_PackOrderInputCosts.Type::Resource );
    //           IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //             REPEAT
    //               IF (lrc_PackOrderInputCosts.Quantity <> 0) AND
    //                  (lrc_PackOrderInputCosts.Quantity <> lrc_PackOrderInputCosts."Quantity Consumed") THEN BEGIN
    //                 IF NOT CONFIRM(AGILES_LT_TEXT004, TRUE, lrc_PackOrderInputCosts."Line No.",
    //                                lrc_PackOrderInputCosts."No.", lrc_PackOrderInputCosts.Quantity,
    //                                lrc_PackOrderInputCosts."Remaining Quantity") THEN BEGIN
    //                   ERROR('');
    //                 END;
    //               END;
    //             UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //           END;

    //         END;

    //         vrc_PackOrderHeader.Status := rrc_NewStatus;
    //         vrc_PackOrderHeader.MODIFY();
    //     end;

    //     procedure SplittPackInputItemLine(vrc_PackOrderInputItems: Record "5110714")
    //     var
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderInputItemsNew: Record "5110714";
    //         lfm_FVPackOrderSplitInput: Form "5110742";
    //         ldc_SplittMenge: Decimal;
    //         ltx_Bemerkungstext: Text[80];
    //         lbn_NoRevenue: Boolean;
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Splittung einer Inputzeile während der Abbrechnung
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackOrderInputItems.FILTERGROUP(2);
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",vrc_PackOrderInputItems."Doc. No.");
    //         lrc_PackOrderInputItems.SETRANGE("Doc. Line No. Output",vrc_PackOrderInputItems."Doc. Line No. Output");
    //         lrc_PackOrderInputItems.SETRANGE("Line No.",vrc_PackOrderInputItems."Line No.");
    //         lrc_PackOrderInputItems.FILTERGROUP(0);

    //         lfm_FVPackOrderSplitInput.SETTABLEVIEW(lrc_PackOrderInputItems);
    //         IF lfm_FVPackOrderSplitInput.RUNMODAL = ACTION::OK THEN BEGIN

    //           // Variable lesen
    //           lfm_FVPackOrderSplitInput.ReturnValues(ldc_SplittMenge,ltx_Bemerkungstext,lbn_NoRevenue);
    //           IF ldc_SplittMenge <= 0 THEN
    //             EXIT;

    //           // Ursprungssatz lesen
    //           lrc_PackOrderInputItems.GET(vrc_PackOrderInputItems."Doc. No.",
    //                                       vrc_PackOrderInputItems."Doc. Line No. Output",
    //                                       vrc_PackOrderInputItems."Line No.");

    //           // Splittzeile erstellen
    //           lrc_PackOrderInputItemsNew.Reset();
    //           lrc_PackOrderInputItemsNew.INIT();
    //           lrc_PackOrderInputItemsNew := lrc_PackOrderInputItems;
    //           lrc_PackOrderInputItemsNew."Doc. No." := lrc_PackOrderInputItems."Doc. No.";
    //           lrc_PackOrderInputItemsNew."Doc. Line No. Output" := lrc_PackOrderInputItems."Doc. Line No. Output";
    //           lrc_PackOrderInputItemsNew."Line No." := lrc_PackOrderInputItems."Line No." + 100;
    //           lrc_PackOrderInputItemsNew.insert();

    //           lrc_PackOrderInputItemsNew.VALIDATE(Quantity,ldc_SplittMenge);
    //           lrc_PackOrderInputItemsNew."Comment Text" := ltx_Bemerkungstext;
    //           lrc_PackOrderInputItemsNew."No Revenue" := lbn_NoRevenue;
    //           lrc_PackOrderInputItemsNew.Modify();


    //           // Bezogene Splittzeile um die abgesplittete Menge reduzieren
    //           lrc_PackOrderInputItems.FIND('-');
    //           lrc_PackOrderInputItems.VALIDATE(Quantity,(lrc_PackOrderInputItems.Quantity - ldc_SplittMenge));
    //           lrc_PackOrderInputItems.Modify();


    //           // Rekalkulation der Werte



    //         END;
    //     end;

    //     procedure CalcDefaultPackingCost(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_CostCategory: Record "5110345";
    //         lrc_PackingCosts: Record "5110723";
    //         lrc_PackingSetup: Record "5110701";
    //         ldc_AmountLCY: Decimal;
    //         ldc_Quantity: Decimal;
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Packkosten auf Basis der Tabelle Packing Cost
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);

    //         // Kontrolle auf Output Zeilen Tafelware
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         IF NOT lrc_PackOrderOutputItems.FIND('-') THEN
    //           EXIT;

    //         // Alle Kostenkategorien lesen
    //         lrc_CostCategory.Reset();
    //         lrc_CostCategory.SETRANGE("Allowed In Pack. Order",TRUE);
    //         IF lrc_CostCategory.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Suche nach Default Kosten
    //             lrc_PackingCosts.Reset();
    //             lrc_PackingCosts.SETRANGE("Vendor No.",lrc_PackOrderHeader."Pack.-by Vendor No.");
    //             lrc_PackingCosts.SETRANGE("Cost Category Code",lrc_CostCategory.Code);
    //             //MOD WZI XOS.s
    //             //Artikelkategorie eingrenzen
    //             lrc_PackingCosts.SETFILTER("Item Category Code",'%1|%2',lrc_PackOrderOutputItems."Item Category Code",'');
    //             //MOD WZI XOS.e
    //             lrc_PackingCosts.SETFILTER("Product Group Code",'%1|%2',lrc_PackOrderOutputItems."Product Group Code",'');
    //             lrc_PackingCosts.SETFILTER("Item No.",'%1|%2',lrc_PackOrderOutputItems."Item No.",'');

    //             //MOD WZI XOS.s
    //             lrc_PackingCosts.SETFILTER("Unit of Measure",'%1|%2',lrc_PackOrderOutputItems."Unit of Measure Code",'');
    //             lrc_PackingCosts.SETFILTER(Trademark,'%1|%2',lrc_PackOrderOutputItems."Trademark Code",'');
    //             lrc_PackingCosts.SETFILTER("Packing Unit of Measure",'%1|%2',
    //                                                                   lrc_PackOrderOutputItems."Reference Unit for Pack. Qty.",'');
    //             //MOD WZI XOS.e
    //             IF lrc_PackingCosts.FIND('+') THEN BEGIN

    //               // Kontrolle ob es bereits einen Kostensatz gibt
    //               lrc_PackOrderInputCosts.Reset();
    //               lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //               lrc_PackOrderInputCosts.SETRANGE(Type,lrc_PackOrderInputCosts.Type::"Cost Category");
    //               lrc_PackOrderInputCosts.SETRANGE("No.",lrc_PackingCosts."Cost Category Code");
    //               IF NOT lrc_PackOrderInputCosts.FIND('-') THEN BEGIN

    //                 // Input Kostensatz anlegen
    //                 lrc_PackOrderInputCosts.Reset();
    //                 lrc_PackOrderInputCosts.INIT();
    //                 lrc_PackOrderInputCosts."Doc. No." := lrc_PackOrderHeader."No.";
    //                 lrc_PackOrderInputCosts."Doc. Line No. Output" := 0;
    //                 lrc_PackOrderInputCosts."Line No." := 0;
    //                 lrc_PackOrderInputCosts.Type := lrc_PackOrderInputCosts.Type::"Cost Category";
    //                 lrc_PackOrderInputCosts.VALIDATE("No.",lrc_PackingCosts."Cost Category Code");
    //                 //MOD WZI XOS.s
    //                 //Bezugsgröße setzen
    //                 IF lrc_PackingCosts."Allocation Base Costs" <> lrc_PackingCosts."Allocation Base Costs"::" " THEN
    //                   lrc_PackOrderInputCosts.VALIDATE("Allocation Base Costs",lrc_PackingCosts."Allocation Base Costs")
    //                 ELSE
    //                   lrc_PackOrderInputCosts.VALIDATE("Allocation Base Costs",lrc_PackOrderInputCosts."Allocation Base Costs"::Packing);
    //                 //MOD WZI XOS.e
    //                 lrc_PackOrderInputCosts."Allocation Price (LCY)" := lrc_PackingCosts."Price per Unit";
    //                 lrc_PackOrderInputCosts."Qty. per Unit of Measure" := 1;
    //                 lrc_PackOrderInputCosts.INSERT(TRUE);

    //                 // Betrag und Menge aufgrund der Bezugsgröße berechnen
    //                 InputCostCalcAmount(lrc_PackOrderInputCosts,ldc_AmountLCY,ldc_Quantity);

    //                 // Menge ist kleiner als die bereits verbrauchte Menge
    //                 IF ldc_Quantity < lrc_PackOrderInputCosts."Quantity Consumed" THEN
    //                   ERROR('');

    //                 // Mengen setzen und berechnen
    //                 lrc_PackOrderInputCosts.Quantity := ldc_Quantity;
    //                 lrc_PackOrderInputCosts."Quantity to Consume" := lrc_PackOrderInputCosts.Quantity -
    //                                                                  lrc_PackOrderInputCosts."Quantity Consumed";
    //                 lrc_PackOrderInputCosts."Remaining Quantity" := lrc_PackOrderInputCosts.Quantity -
    //                                                                 lrc_PackOrderInputCosts."Quantity Consumed";

    //                 // Beträge setzen und berechnen
    //                 lrc_PackOrderInputCosts."Amount (LCY)" := ldc_AmountLCY;
    //                 lrc_PackOrderInputCosts."Calculated Costs (LCY)" := lrc_PackOrderInputCosts."Amount (LCY)";
    //                 IF lrc_PackOrderInputCosts."Posted Costs (LCY)" = 0 THEN BEGIN
    //                   lrc_PackOrderInputCosts."Chargeable Costs (LCY)" := lrc_PackOrderInputCosts."Amount (LCY)";
    //                 END ELSE BEGIN
    //                   lrc_PackOrderInputCosts."Chargeable Costs (LCY)" := lrc_PackOrderInputCosts."Posted Costs (LCY)";
    //                 END;

    //                 lrc_PackOrderInputCosts.Modify();

    //               END ELSE BEGIN

    //                 // Input Kostensatz aktualisieren
    //                 // Betrag und Menge aufgrund der Bezugsgröße berechnen
    //                 InputCostCalcAmount(lrc_PackOrderInputCosts,ldc_AmountLCY,ldc_Quantity);

    //                 // Menge ist kleiner als die bereits verbrauchte Menge
    //                 IF ldc_Quantity < lrc_PackOrderInputCosts."Quantity Consumed" THEN
    //                   ERROR('');

    //                 // Mengen setzen und berechnen
    //                 lrc_PackOrderInputCosts.Quantity := ldc_Quantity;
    //                 lrc_PackOrderInputCosts."Quantity to Consume" := lrc_PackOrderInputCosts.Quantity -
    //                                                                  lrc_PackOrderInputCosts."Quantity Consumed";
    //                 lrc_PackOrderInputCosts."Remaining Quantity" := lrc_PackOrderInputCosts.Quantity -
    //                                                                 lrc_PackOrderInputCosts."Quantity Consumed";

    //                 // Beträge setzen und berechnen
    //                 lrc_PackOrderInputCosts."Amount (LCY)" := ldc_AmountLCY;
    //                 lrc_PackOrderInputCosts."Calculated Costs (LCY)" := lrc_PackOrderInputCosts."Amount (LCY)";
    //                 IF lrc_PackOrderInputCosts."Posted Costs (LCY)" = 0 THEN BEGIN
    //                   lrc_PackOrderInputCosts."Chargeable Costs (LCY)" := lrc_PackOrderInputCosts."Amount (LCY)";
    //                 END ELSE BEGIN
    //                   lrc_PackOrderInputCosts."Chargeable Costs (LCY)" := lrc_PackOrderInputCosts."Posted Costs (LCY)";
    //                 END;

    //                 lrc_PackOrderInputCosts.Modify();
    //               END;

    //             END;
    //           UNTIL lrc_CostCategory.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CalcInputPercentages(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_PackOrderInputItems: Record "5110714";
    //         ldc_QtyBase: Decimal;
    //         ldc_QtyBaseWithRevenue: Decimal;
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Prozentualen Mengenanteile Input
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             ldc_QtyBase := ldc_QtyBase + lrc_PackOrderInputItems."Quantity to Consume (Base)" +
    //                                          lrc_PackOrderInputItems."Quantity Consumed (Base)";
    //             IF lrc_PackOrderInputItems."No Revenue" = FALSE THEN
    //               ldc_QtyBaseWithRevenue := ldc_QtyBaseWithRevenue + lrc_PackOrderInputItems."Quantity to Consume (Base)" +
    //                                                                  lrc_PackOrderInputItems."Quantity Consumed (Base)";
    //           UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //         END;

    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_PackOrderInputItems."Perc. Total Qty." := 0;
    //             lrc_PackOrderInputItems."Perc. Qty. with Revenue" := 0;
    //             IF ldc_QtyBase <> 0 THEN
    //               lrc_PackOrderInputItems."Perc. Total Qty." := (lrc_PackOrderInputItems."Quantity to Consume (Base)" +
    //                                            lrc_PackOrderInputItems."Quantity Consumed (Base)") / ldc_QtyBase * 100;
    //             IF ldc_QtyBaseWithRevenue <> 0 THEN
    //               lrc_PackOrderInputItems."Perc. Qty. with Revenue" := (lrc_PackOrderInputItems."Quantity to Consume (Base)" +
    //                                            lrc_PackOrderInputItems."Quantity Consumed (Base)") / ldc_QtyBaseWithRevenue * 100;
    //             lrc_PackOrderInputItems.Modify();
    //           UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PackDeleteEmptyLines(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zum Löschen von leeren Zeilen
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         lrc_PackOrderInputCosts.SETRANGE(Quantity,0);
    //         //180307 rs Zeile nur löschen, wenn keine Inputposition zugeordnet
    //         lrc_PackOrderInputCosts.SETFILTER("Doc. Line No. Input", '<>0');
    //         //180307 rs.e
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN
    //           lrc_PackOrderInputCosts.DELETEALL();

    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         lrc_PackOrderInputItems.SETRANGE(Quantity,0);
    //         //180307 rs Zeile nur löschen, wenn keine Position angegeben
    //         lrc_PackOrderInputItems.SETRANGE("Batch Variant No.", '');
    //         //180307 rs.e
    //         IF lrc_PackOrderInputItems.FIND('-') THEN
    //           lrc_PackOrderInputItems.DELETEALL();

    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         lrc_PackOrderOutputItems.SETRANGE(Quantity,0);
    //         //180307 rs Zeile nur löschen, wenn keine Artikelnummer
    //         lrc_PackOrderOutputItems.SETRANGE(lrc_PackOrderOutputItems."Item No.", '');
    //         //180307 rs.e
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           lrc_PackOrderOutputItems.DELETEALL();

    //         COMMIT;
    //     end;

    //     procedure PackOutputEnterTransportUnits(vrc_PackOrderOutputItems: Record "5110713")
    //     var
    //         lrc_PackOrderOutputTU: Record "5110737";
    //         lfm_PackOrderOutputTU: Form "5088111";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung der Output Transporteinheiten
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackOrderOutputTU.Reset();
    //         lrc_PackOrderOutputTU.FILTERGROUP(0);
    //         lrc_PackOrderOutputTU.SETRANGE("Doc. No.",vrc_PackOrderOutputItems."Doc. No.");
    //         lrc_PackOrderOutputTU.SETRANGE("Doc. Output Line No.",vrc_PackOrderOutputItems."Line No.");
    //         lrc_PackOrderOutputTU.FILTERGROUP(2);

    //         lfm_PackOrderOutputTU.SETTABLEVIEW(lrc_PackOrderOutputTU);
    //         lfm_PackOrderOutputTU.RUNMODAL;
    //     end;

    //     procedure PackLoadRecipe(vco_PackOrderNo: Code[20];vco_RecipeCode: Code[20])
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //         lrc_PackOrderRecipeLines: Record "5110612";
    //         lrc_RecipeHeader: Record "5110710";
    //         lrc_RecipeOutputItems: Record "5110708";
    //         lrc_RecipeInputItems: Record "5110706";
    //         lrc_RecipeInputPackingItems: Record "5110704";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zum Laden einer Rezeptur in einen Packauftrag
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         lrc_RecipeHeader.GET(vco_RecipeCode);

    //         lrc_RecipeOutputItems.SETRANGE("Recipe No.",lrc_RecipeHeader."No.");
    //         IF lrc_PackOrderOutputItems.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT


    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //         END;

    //         lrc_RecipeInputItems.SETRANGE("Recipe No.",lrc_RecipeHeader."No.");
    //         IF lrc_RecipeInputItems.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT


    //           UNTIL lrc_RecipeInputItems.NEXT() = 0;
    //         END;
    //     end;

    //     procedure "-- SORTING --"()
    //     begin
    //     end;

    //     procedure SortingShowOrder(vco_PackingOrderCode: Code[20])
    //     var
    //         lrc_PackingOrderHeader: Record "5110712";
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lfm_PackingOrder: Form "5110730";
    //         lrc_PackDocType: Record "5110725";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige / Bearbeitung Sortierauftrag
    //         // ----------------------------------------------------------------------------------------

    //         lrc_RecipePackingSetup.GET();
    //         lrc_RecipePackingSetup.TESTFIELD("Form ID Sorting Order Card");

    //         IF lrc_RecipePackingSetup."Page Up/Down Pack. Order Card" = FALSE THEN
    //           lrc_PackingOrderHeader.FILTERGROUP(2);
    //         lrc_PackingOrderHeader.SETRANGE("No.",vco_PackingOrderCode );
    //         lrc_PackingOrderHeader.FILTERGROUP(0);

    //         lrc_PackingOrderHeader.FIND('-');
    //         //IF lrc_PackDocType.GET(lrc_PackDocType."Document Type"::"Packing Order",lrc_PackingOrderHeader."Pack. Doc. Type Code") THEN BEGIN
    //         IF lrc_PackDocType.GET(lrc_PackingOrderHeader."Pack. Doc. Type Code") THEN BEGIN
    //           lrc_PackDocType.TESTFIELD("Form ID Sorting Order Card");
    //           FORM.RUN(lrc_PackDocType."Form ID Sorting Order Card",lrc_PackingOrderHeader);
    //         END ELSE
    //           FORM.RUN(lrc_RecipePackingSetup."Form ID Sorting Order Card",lrc_PackingOrderHeader);
    //     end;

    //     procedure SortingNewOrder(vco_PackDocType: Code[10])
    //     var
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lrc_PackingOrderHeader: Record "5110712";
    //         lco_MasterBatchCode: Code[20];
    //         lco_BatchCode: Code[20];
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_Location: Record "14";
    //         lrc_BatchSetup: Record "5110363";
    //         "--- PAC 011 00000000": Integer;
    //         lrc_PackDocSubtype: Record "5110725";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Neuanlage Sortierauftrag
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackingOrderHeader.Reset();
    //         lrc_PackingOrderHeader.INIT();
    //         lrc_PackingOrderHeader."No." := '';
    //         lrc_PackingOrderHeader."Document Type" := lrc_PackingOrderHeader."Document Type"::"Sorting Order";
    //         lrc_PackingOrderHeader."Pack. Doc. Type Code" := vco_PackDocType;
    //         lrc_PackingOrderHeader.INSERT(TRUE);

    //         lrc_RecipePackingSetup.GET();

    //         // PAC 011 00000000.s
    //         IF ( vco_PackDocType = '' ) OR
    //            ( NOT lrc_PackDocSubtype.GET( vco_PackDocType ) ) THEN BEGIN
    //            lrc_PackDocSubtype.INIT();
    //         END;
    //         IF lrc_PackDocSubtype."Default Output Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Outp. Item Location Code" := lrc_PackDocSubtype."Default Output Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Outp. Item Location Code" := lrc_RecipePackingSetup."Default Output Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         IF lrc_PackDocSubtype."Default Packing Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Inp. Packing Item Loc. Code" := lrc_PackDocSubtype."Default Packing Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Inp. Packing Item Loc. Code" := lrc_RecipePackingSetup."Default Packing Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         IF lrc_PackDocSubtype."Default Empties Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Inp. Empties Item Loc. Code" := lrc_PackDocSubtype."Default Empties Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Inp. Empties Item Loc. Code" := lrc_RecipePackingSetup."Default Empties Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         // PAC 011 00000000.e

    //         IF lrc_PackingOrderHeader."Outp. Item Location Code" <> '' THEN BEGIN
    //           IF lrc_Location.GET( lrc_PackingOrderHeader."Outp. Item Location Code" ) THEN BEGIN
    //             IF lrc_Location."Vendor No." <> '' THEN BEGIN
    //               lrc_PackingOrderHeader.VALIDATE("Vendor No.", lrc_Location."Vendor No.");
    //               lrc_PackingOrderHeader.VALIDATE("Pack.-by Vendor No.", lrc_Location."Vendor No.");
    //             END;
    //           END;
    //         END;

    //         lcu_BatchMgt.PackNewMasterBatch(lrc_PackingOrderHeader,lco_MasterBatchCode);
    //         lrc_PackingOrderHeader."Master Batch No." := lco_MasterBatchCode;
    //         lrc_PackingOrderHeader.Modify();

    //         lrc_BatchSetup.GET();
    //         IF lrc_BatchSetup."Pack. Allocation Batch No." =
    //            lrc_BatchSetup."Pack. Allocation Batch No."::"One Batch No. per Order" THEN BEGIN
    //           lcu_BatchMgt.PackNewBatch(lrc_PackingOrderHeader,lco_BatchCode);
    //           lrc_PackingOrderHeader."Batch No." := lco_BatchCode;
    //           lrc_PackingOrderHeader.Modify();
    //         END;
    //         COMMIT;

    //         SortingShowOrder(lrc_PackingOrderHeader."No.");
    //     end;

    //     procedure PackPostConsumedInput(vco_PackOrderNo: Code[20])
    //     var
    //         lcu_ItemJnlPostLine: Codeunit "22";
    //         lcu_FGuBPartien: Codeunit "5110300";
    //         lcu_StockMgt: Codeunit "5110339";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_ItemJournalLine: Record "83" temporary;
    //         lrc_Item: Record Item;
    //         lcu_ItemCheckAvail: Codeunit "311";
    //         lop_Pruefungsart: Option Bestand,"Verfügbarer Bestand","erwarteter Verfügbarer Bestand";
    //         lrc_Location: Record "14";
    //         ldc_Bestand: Decimal;
    //         ldc_ErwVerfBestand: Decimal;
    //         lrc_BatchVariant: Record "5110366";
    //         AGILES_LT_TEXT001: Label 'Artikel %1, Positionsvariante %2, Lagerort %3 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    //         AGILES_LT_TEXT002: Label 'Artikel %1, Positionsvariante %2 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    //         AGILES_LT_TEXT003: Label 'Artikel %1, Lagerort %2 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    //         AGILES_LT_TEXT004: Label 'Artikel %1 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    //         "-- Agiles L PAL 002": Integer;
    //         lcu_PalletManagement: Codeunit "5110346";
    //         AGILES_LT_TEXT005: Label 'Dimensionsebene nicht zulässig!';
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zum Buchen der Verbräuche (Inputzeilen Rohware / Handelsartikel)
    //         // -----------------------------------------------------------------------------------------

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         lrc_PackOrderHeader.TESTFIELD("Pack.-by Vendor No.");
    //         lrc_PackOrderHeader.TESTFIELD("Master Batch No.");
    //         // POI 004.S
    //         //lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    //         IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::"8" THEN
    //           lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    //         // POI 004.E
    //         lrc_PackOrderHeader.TESTFIELD("Posting Date");

    //         // PAC 012 DMG50131.s
    //         IF GUIALLOWED THEN BEGIN
    //         // PAC 012 DMG50131.e

    //         IF NOT CONFIRM('Ist das Buchungsdatum ' + FORMAT(lrc_PackOrderHeader."Posting Date") +
    //                        ' für den Verbrauch richtig?') THEN
    //           ERROR('');

    //         // PAC 012 DMG50131.s
    //         END;
    //         // PAC 012 DMG50131.e

    //         lrc_FruitVisionSetup.GET();
    //         lrc_BatchSetup.GET();

    //         // Prüfung ob alle Werte gesetzt sind
    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputItems.SETFILTER("Quantity to Consume",'<>%1',0);
    //         IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_PackOrderInputItems.TESTFIELD("Item No.");
    //             lrc_Item.Reset();
    //             lrc_Item.GET(lrc_PackOrderInputItems."Item No.");

    //             IF lrc_Item."Batch Item" = TRUE THEN BEGIN
    //               IF (lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Automatic from System") OR
    //                  (lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Dummy and Batch Job") THEN BEGIN
    //                 // Keine Prüfung auf Partienummern
    //                 IF lrc_BatchSetup."Dummy Batch Variant No." <> '' THEN BEGIN
    //                   lrc_PackOrderInputItems."Batch Variant No." := lrc_BatchSetup."Dummy Batch Variant No.";
    //                   lrc_PackOrderInputItems.Modify();
    //                 END;
    //               END ELSE BEGIN
    //                 lrc_PackOrderInputItems.TESTFIELD("Master Batch No.");
    //                 lrc_PackOrderInputItems.TESTFIELD("Batch No.");
    //                 lrc_PackOrderInputItems.TESTFIELD("Batch Variant No.");
    //               END;
    //             END;

    //             lrc_PackOrderInputItems.TESTFIELD("Location Code");
    //             lrc_PackOrderInputItems.TESTFIELD("Unit of Measure Code");
    //             lrc_PackOrderInputItems.TESTFIELD("Base Unit of Measure Code");
    //             lrc_PackOrderInputItems.TESTFIELD("Qty. per Unit of Measure");

    //             // dieser Code ist aus der Codeunit 311 übernommen,
    //             // vom Bestand muss jedoch die aktuelle Menge noch abgezogen werden
    //             lrc_Location.GET( lrc_PackOrderInputItems."Location Code" );
    //             ldc_Bestand := 0;

    //             IF (lrc_Item."Batch Item" = TRUE) AND
    //                (lrc_BatchSetup."Sales Batch Assignment" <> lrc_BatchSetup."Sales Batch Assignment"::"Automatic from System") AND
    //                (lrc_BatchSetup."Sales Batch Assignment" <> lrc_BatchSetup."Sales Batch Assignment"::"Dummy and Batch Job") THEN BEGIN

    //               lrc_BatchVariant.GET(lrc_PackOrderInputItems."Batch Variant No.");

    //               ldc_ErwVerfBestand := lcu_StockMgt.BatchVarStockExpAvail(lrc_PackOrderInputItems."Batch Variant No.",
    //                                                                        lrc_PackOrderInputItems."Location Code");

    //               ldc_ErwVerfBestand := ldc_ErwVerfBestand * lrc_PackOrderInputItems."Qty. per Unit of Measure";
    //               ldc_ErwVerfBestand := ldc_ErwVerfBestand + lrc_PackOrderInputItems."Quantity to Consume (Base)";

    //               IF (ldc_ErwVerfBestand < 0) AND (lrc_PackOrderInputItems."Quantity to Consume (Base)" > 0) THEN BEGIN
    //                 // Es ist nicht genügend Bestand zum Buchen vorhanden!
    //                 IF (lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::Location) OR
    //                    (lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::"Location Group") THEN BEGIN
    //                   ERROR(AGILES_LT_TEXT001, lrc_PackOrderInputItems."Item No.",
    //                         lrc_PackOrderInputItems."Batch Variant No.", lrc_PackOrderInputItems."Location Code");
    //                 END ELSE BEGIN
    //                   ERROR(AGILES_LT_TEXT002, lrc_PackOrderInputItems."Item No.",
    //                         lrc_PackOrderInputItems."Batch Variant No.", lrc_PackOrderInputItems."Location Code");
    //                 END;
    //               END;

    //             END ELSE BEGIN

    //               lrc_Item.SETFILTER("Variant Filter", lrc_PackOrderInputItems."Variant Code");
    //               IF (lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::Location) OR
    //                  (lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::"Location Group") THEN BEGIN
    //                 lrc_Item.SETFILTER("Location Filter", lrc_PackOrderInputItems."Location Code");
    //               END;

    //               lrc_Item.CALCFIELDS(Inventory, "Reserved Qty. on Inventory");
    //               ldc_Bestand := lrc_Item.Inventory - lrc_Item."Reserved Qty. on Inventory";

    //               IF ((ldc_Bestand - lrc_PackOrderInputItems."Quantity to Consume (Base)") < 0) THEN BEGIN
    //                 IF (lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::Location) OR
    //                    (lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::"Location Group") THEN BEGIN
    //                   ERROR(AGILES_LT_TEXT003, lrc_PackOrderInputItems."Item No.", lrc_PackOrderInputItems."Location Code");
    //                 END ELSE BEGIN
    //                   ERROR(AGILES_LT_TEXT004, lrc_PackOrderInputItems."Item No.", lrc_PackOrderInputItems."Location Code");
    //                 END;
    //               END;

    //             END;
    //           UNTIL lrc_PackOrderInputItems.NEXT() = 0;

    //           // PAL 002 00000000.s
    //           lcu_PalletManagement.PackOrderInputPostCheckPallet(lrc_PackOrderHeader);
    //           // PAL 002 00000000.e

    //         END ELSE
    //           ERROR('');

    //         //RS Prüfung ob Menge Leergut in In- und Outputzeilen identisch
    //         EPSInputOutput(vco_PackOrderNo);

    //         // --------------------------------------------------------------------------------------------
    //         // Buchungsblatt füllen und buchen
    //         // --------------------------------------------------------------------------------------------
    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //           REPEAT

    //           // PAL 002 00000000.s
    //           lcu_PalletManagement.PackOrderInputPostOutgoingPall( lrc_PackOrderHeader );
    //           // PAL 002 00000000.e

    //           IF lrc_PackOrderInputItems."Quantity to Consume" <> 0 THEN BEGIN
    //             CLEAR(lcu_ItemJnlPostLine);

    //             lrc_ItemJournalLine.Reset();
    //             lrc_ItemJournalLine.DELETEALL();

    //             lrc_ItemJournalLine.Reset();
    //             lrc_ItemJournalLine.INIT();
    //             lrc_ItemJournalLine."Journal Template Name" := ''; //'ARTIKEL';
    //             lrc_ItemJournalLine."Journal Batch Name" := ''; //'PACKEREI';
    //             lrc_ItemJournalLine."Line No." := 0; //10000;

    //             lrc_ItemJournalLine.VALIDATE("Item No.",lrc_PackOrderInputItems."Item No.");
    //             lrc_ItemJournalLine.VALIDATE("Variant Code",lrc_PackOrderInputItems."Variant Code");
    //             lrc_ItemJournalLine.VALIDATE("Posting Date",lrc_PackOrderHeader."Posting Date");

    //             lrc_ItemJournalLine."Master Batch No." := lrc_PackOrderInputItems."Master Batch No.";
    //             lrc_ItemJournalLine."Batch No." := lrc_PackOrderInputItems."Batch No.";
    //             lrc_ItemJournalLine."Batch Variant No." := lrc_PackOrderInputItems."Batch Variant No.";

    //             IF lrc_PackOrderInputItems."Quantity to Consume" > 0 THEN
    //               lrc_ItemJournalLine.VALIDATE("Entry Type",lrc_ItemJournalLine."Entry Type"::"Negative Adjmt.")
    //             ELSE
    //               lrc_ItemJournalLine.VALIDATE("Entry Type",lrc_ItemJournalLine."Entry Type"::"Positive Adjmt.");

    //             lrc_ItemJournalLine.VALIDATE("Gen. Bus. Posting Group",lrc_PackOrderHeader."Gen. Bus. Posting Group");
    //             lrc_ItemJournalLine."Document No." := lrc_PackOrderHeader."No.";
    //             lrc_ItemJournalLine.Description := '';
    //             lrc_ItemJournalLine.VALIDATE("Location Code",lrc_PackOrderInputItems."Location Code");
    //             lrc_ItemJournalLine."Salespers./Purch. Code" := lrc_PackOrderHeader."Person in Charge Code";

    //             lrc_ItemJournalLine."Country of Origin Code" := lrc_PackOrderInputItems."Country of Origin Code";
    //             lrc_ItemJournalLine."Variety Code" := lrc_PackOrderInputItems."Variety Code";
    //             lrc_ItemJournalLine."Trademark Code" := lrc_PackOrderInputItems."Trademark Code";
    //             lrc_ItemJournalLine."Caliber Code" := lrc_PackOrderInputItems."Caliber Code";
    //             lrc_ItemJournalLine."Item Attribute 2" := lrc_PackOrderInputItems."Color Code";
    //             lrc_ItemJournalLine."Grade of Goods Code" := lrc_PackOrderInputItems."Grade of Goods Code";
    //             lrc_ItemJournalLine."Item Attribute 7" := lrc_PackOrderInputItems."Conservation Code";
    //             lrc_ItemJournalLine."Item Attribute 4" := lrc_PackOrderInputItems."Packing Code";
    //             lrc_ItemJournalLine."Coding Code" := lrc_PackOrderInputItems."Coding Code";
    //             lrc_ItemJournalLine."Item Attribute 3" := lrc_PackOrderInputItems."Quality Code";

    //             lrc_ItemJournalLine."Source Doc. Type" := lrc_ItemJournalLine."Source Doc. Type"::"Input Packerei";
    //             lrc_ItemJournalLine."Source Doc. No." := lrc_PackOrderInputItems."Doc. No.";
    //             lrc_ItemJournalLine."Source Doc. Line No." := lrc_PackOrderInputItems."Line No.";

    //             lrc_ItemJournalLine."Batch No." := lrc_PackOrderInputItems."Batch No.";
    //             lrc_ItemJournalLine."Batch Variant No." := lrc_PackOrderInputItems."Batch Variant No.";

    //             CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //               lrc_BatchSetup."Dim. No. Batch No."::" ":
    //                 BEGIN
    //                 END;
    //               lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                 lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code",lrc_PackOrderInputItems."Batch No.");
    //               lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                 lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 2 Code",lrc_PackOrderInputItems."Batch No.");
    //               lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                 lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 3 Code",lrc_PackOrderInputItems."Batch No.");
    //               lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                 lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 4 Code",lrc_PackOrderInputItems."Batch No.");
    //               ELSE
    //                 // Dimensionsebene nicht zulässig!
    //                 ERROR(AGILES_LT_TEXT005);
    //             END;

    //             lrc_ItemJournalLine.VALIDATE("Unit of Measure Code",lrc_PackOrderInputItems."Unit of Measure Code");
    //             lrc_ItemJournalLine.VALIDATE(Quantity,ABS(lrc_PackOrderInputItems."Quantity to Consume"));

    //             lrc_ItemJournalLine.insert();

    //             // PAC 006 00000000.s
    //             lrc_PackOrderInputItems."Quantity Consumed" := lrc_PackOrderInputItems."Quantity Consumed" +
    //                                                            lrc_PackOrderInputItems."Quantity to Consume";
    //             lrc_PackOrderInputItems."Quantity Consumed (Base)" := lrc_PackOrderInputItems."Quantity Consumed" *
    //                                                            lrc_PackOrderInputItems."Qty. per Unit of Measure";


    //             lrc_PackOrderInputItems."Remaining Quantity" := lrc_PackOrderInputItems.Quantity -
    //                                                             lrc_PackOrderInputItems."Quantity Consumed";
    //             lrc_PackOrderInputItems."Remaining Quantity (Base)" := lrc_PackOrderInputItems."Remaining Quantity" *
    //                                                                    lrc_PackOrderInputItems."Qty. per Unit of Measure";
    //             lrc_PackOrderInputItems.Modify();
    //             // PAC 006 00000000.e

    //             lcu_ItemJnlPostLine.RUN(lrc_ItemJournalLine);

    //             // FV START 051005 --> Bei negativer Buchung wird die Menge reduziert
    //             IF lrc_PackOrderInputItems."Quantity to Consume" < 0 THEN BEGIN
    //               lrc_PackOrderInputItems.VALIDATE( Quantity, lrc_PackOrderInputItems.Quantity +
    //                                                   lrc_PackOrderInputItems."Quantity to Consume" );
    //               lrc_PackOrderInputItems."Quantity (Base)" := lrc_PackOrderInputItems."Quantity (Base)" +
    //                                                            lrc_PackOrderInputItems."Quantity to Consume (Base)";
    //             END;
    //             // FV ENDE

    //             lrc_PackOrderInputItems."Quantity to Consume" := 0;
    //             lrc_PackOrderInputItems."Quantity to Consume (Base)" := 0;

    //             IF lrc_PackOrderInputItems."Date of Posting" = 0D THEN BEGIN
    //               lrc_PackOrderInputItems."Date of Posting" := TODAY;
    //               lrc_PackOrderInputItems."Userid of Posting" := USERID;
    //             END;

    //             lrc_PackOrderInputItems."Last Posting Date" := lrc_PackOrderHeader."Posting Date";
    //             lrc_PackOrderInputItems.Modify();

    //           END;

    //           UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //           COMMIT;
    //         END;
    //     end;

    //     procedure PackPostConsumedPacking(vco_PackOrderNo: Code[20])
    //     var
    //         lcu_ItemJnlPostLine: Codeunit "22";
    //         lcu_FGuBPartien: Codeunit "5110300";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //         lrc_ItemJournalLine: Record "83" temporary;
    //         lrc_Item: Record Item;
    //         lcu_ItemCheckAvail: Codeunit "311";
    //         lop_Pruefungsart: Option Bestand,"Verfügbarer Bestand","erwarteter Verfügbarer Bestand";
    //         lrc_Location: Record "14";
    //         ldc_Bestand: Decimal;
    //         lrc_BatchVariant: Record "5110366";
    //         AGILES_LT_TEXT001: Label 'Artikel %1, Positionsvariante %2, Lagerort %3 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    //         AGILES_LT_TEXT002: Label 'Artikel %1, Positionsvariante %2 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    //         AGILES_LT_TEXT003: Label 'Artikel %1, Lagerort %2 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    //         AGILES_LT_TEXT004: Label 'Artikel %1 : Es ist nicht genügend Bestand zum Buchen vorhanden !';
    //         AGILES_LT_TEXT005: Label 'Es gibt nichts zu buchen!';
    //         AGILES_LT_TEXT006: Label 'Dimensionsebene nicht zulässig!';
    //     begin
    //         // ---------------------------------------------------------------------------------------------------
    //         // Funktion zum Buchen der Verbräuche (Inputzeilen Verpackungsartikel, Leergut, Transportmittel)
    //         // ---------------------------------------------------------------------------------------------------

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);



    //         lrc_PackOrderHeader.TESTFIELD("Pack.-by Vendor No.");
    //         lrc_PackOrderHeader.TESTFIELD("Master Batch No.");
    //         // POI 004.S
    //         //lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    //         IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::"8" THEN
    //           lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    //         // POI 004.E

    //         lrc_FruitVisionSetup.GET();
    //         lrc_BatchSetup.GET();

    //         // Prüfung ob alle Werte gesetzt sind
    //         lrc_PackOrderInputPackItems.Reset();
    //         lrc_PackOrderInputPackItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputPackItems.SETFILTER("Quantity to Consume",'<>%1',0);
    //         IF lrc_PackOrderInputPackItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_Item.GET(lrc_PackOrderInputPackItems."Item No.");
    //             lrc_PackOrderInputPackItems.TESTFIELD("Item No.");

    //             IF lrc_Item."Batch Item" = TRUE THEN BEGIN
    //               lrc_PackOrderInputPackItems.TESTFIELD("Master Batch No.");
    //               lrc_PackOrderInputPackItems.TESTFIELD("Batch No.");
    //               lrc_PackOrderInputPackItems.TESTFIELD("Batch Variant No.");
    //             END;

    //             lrc_PackOrderInputPackItems.TESTFIELD("Location Code");
    //             lrc_PackOrderInputPackItems.TESTFIELD("Unit of Measure Code");
    //             lrc_PackOrderInputPackItems.TESTFIELD("Base Unit of Measure Code");
    //             lrc_PackOrderInputPackItems.TESTFIELD("Qty. per Unit of Measure");

    //             //MOS WZI XOX.s
    //             lrc_Item.GET( lrc_PackOrderInputPackItems."Item No." );
    //             IF lrc_Item."No Stock in Packing Order" = FALSE THEN BEGIN
    //             //MOS WZI XOX.s

    //                // dieser Code ist aus der Codeunit 311 übernommen,
    //                // vom Bestand muss jedoch die aktuelle Menge noch abgezogen werden
    //                lrc_Location.GET(lrc_PackOrderInputPackItems."Location Code");
    //                ldc_Bestand := 0;

    //                IF lrc_Item."Batch Item" = TRUE THEN BEGIN

    //                  lrc_BatchVariant.GET(lrc_PackOrderInputPackItems."Batch Variant No.");

    //                  IF (lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::Location ) OR
    //                     (lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::"Location Group") THEN BEGIN
    //                    lrc_BatchVariant.SETRANGE("Location Filter", lrc_PackOrderInputPackItems."Location Code" );
    //                  END;

    //                  lrc_BatchVariant.CALCFIELDS( "B.V. Inventory (Qty.)" );

    //                  ldc_Bestand := lrc_BatchVariant."B.V. Inventory (Qty.)";
    //                  ldc_Bestand := ldc_Bestand - lrc_PackOrderInputPackItems."Quantity to Consume (Base)";

    //                  IF ( ldc_Bestand < 0 ) THEN BEGIN
    //                    // Es ist nicht genügend Bestand zum Buchen vorhanden!
    //                    IF ( lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::Location ) OR
    //                        ( lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::"Location Group" ) THEN BEGIN
    //                      ERROR( AGILES_LT_TEXT001, lrc_PackOrderInputPackItems."Item No.",
    //                             lrc_PackOrderInputPackItems."Batch Variant No.", lrc_PackOrderInputPackItems."Location Code" );
    //                    END ELSE BEGIN
    //                      ERROR( AGILES_LT_TEXT002, lrc_PackOrderInputPackItems."Item No.",
    //                             lrc_PackOrderInputPackItems."Batch Variant No.", lrc_PackOrderInputPackItems."Location Code" );
    //                    END;
    //                  END;

    //                END ELSE BEGIN
    //                  lrc_Item.SETRANGE("Variant Filter", lrc_PackOrderInputPackItems."Variant Code" );
    //                  IF ( lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::Location ) OR
    //                     ( lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::"Location Group" ) THEN BEGIN
    //                     lrc_Item.SETRANGE("Location Filter",  lrc_PackOrderInputPackItems."Location Code" );
    //                  END;

    //                  lrc_Item.CALCFIELDS( Inventory, "Reserved Qty. on Inventory" );

    //                  ldc_Bestand := lrc_Item.Inventory - lrc_Item."Reserved Qty. on Inventory";

    //                  IF ( ldc_Bestand < 0 ) THEN BEGIN
    //                    IF ( lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::Location ) OR
    //                       ( lrc_Location."Level Stock Control" = lrc_Location."Level Stock Control"::"Location Group" ) THEN BEGIN
    //                       ERROR( AGILES_LT_TEXT003, lrc_PackOrderInputPackItems."Item No.", lrc_PackOrderInputPackItems."Location Code" );
    //                    END ELSE BEGIN
    //                       ERROR( AGILES_LT_TEXT004, lrc_PackOrderInputPackItems."Item No.", lrc_PackOrderInputPackItems."Location Code" );
    //                    END;
    //                  END;
    //                END;
    //                // PAC 004 00000000.e
    //              END;
    //           UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //         END ELSE
    //           // Es gibt nichts zu buchen!
    //           ERROR(AGILES_LT_TEXT005);


    //         // Buchungsblatt füllen und buchen
    //         lrc_PackOrderInputPackItems.Reset();
    //         lrc_PackOrderInputPackItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderInputPackItems.FIND('-') THEN BEGIN
    //           REPEAT

    //             IF lrc_PackOrderInputPackItems."Quantity to Consume" <> 0 THEN BEGIN
    //               //MOS WZI XOX.s
    //               lrc_Item.GET( lrc_PackOrderInputPackItems."Item No." );
    //               IF lrc_Item."No Stock in Packing Order" = FALSE THEN BEGIN
    //               //MOS WZI XOX.s

    //               CLEAR(lcu_ItemJnlPostLine);

    //               lrc_ItemJournalLine.Reset();
    //               lrc_ItemJournalLine.DELETEALL();

    //               lrc_ItemJournalLine.Reset();
    //               lrc_ItemJournalLine.INIT();
    //               lrc_ItemJournalLine."Journal Template Name" := ''; //'ARTIKEL';
    //               lrc_ItemJournalLine."Journal Batch Name" := ''; //'PACKEREI';
    //               lrc_ItemJournalLine."Line No." := 0; //10000;
    //               lrc_ItemJournalLine.VALIDATE("Item No.",lrc_PackOrderInputPackItems."Item No.");
    //               lrc_ItemJournalLine.VALIDATE("Variant Code",lrc_PackOrderInputPackItems."Variant Code");
    //               lrc_ItemJournalLine.VALIDATE("Posting Date",lrc_PackOrderHeader."Posting Date");

    //               lrc_ItemJournalLine."Master Batch No." := lrc_PackOrderInputPackItems."Master Batch No.";
    //               lrc_ItemJournalLine."Batch No." := lrc_PackOrderInputPackItems."Batch No.";
    //               lrc_ItemJournalLine."Batch Variant No." := lrc_PackOrderInputPackItems."Batch Variant No.";

    //               IF lrc_PackOrderInputPackItems."Quantity to Consume" > 0 THEN
    //                 lrc_ItemJournalLine.VALIDATE("Entry Type",lrc_ItemJournalLine."Entry Type"::"Negative Adjmt.")
    //               ELSE
    //                 lrc_ItemJournalLine.VALIDATE("Entry Type",lrc_ItemJournalLine."Entry Type"::"Positive Adjmt.");

    //               lrc_ItemJournalLine.VALIDATE("Gen. Bus. Posting Group",lrc_PackOrderHeader."Gen. Bus. Posting Group");
    //               lrc_ItemJournalLine."Document No." := lrc_PackOrderHeader."No.";
    //               lrc_ItemJournalLine.Description := '';
    //               lrc_ItemJournalLine.VALIDATE("Location Code",lrc_PackOrderInputPackItems."Location Code");
    //               lrc_ItemJournalLine."Salespers./Purch. Code" := lrc_PackOrderHeader."Person in Charge Code";

    //               lrc_ItemJournalLine."Source Doc. Type" := lrc_ItemJournalLine."Source Doc. Type"::"Input Packerei";
    //               lrc_ItemJournalLine."Source Doc. No." := lrc_PackOrderInputPackItems."Doc. No.";
    //               lrc_ItemJournalLine."Source Doc. Line No." := lrc_PackOrderInputPackItems."Line No.";

    //               lrc_ItemJournalLine."Batch No." := lrc_PackOrderInputPackItems."Batch No.";
    //               lrc_ItemJournalLine."Batch Variant No." := lrc_PackOrderInputPackItems."Batch Variant No.";

    //               CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                 lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                   lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code",lrc_PackOrderInputPackItems."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                   lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 2 Code",lrc_PackOrderInputPackItems."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                   lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 3 Code",lrc_PackOrderInputPackItems."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                   lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 4 Code",lrc_PackOrderInputPackItems."Batch No.");
    //                 ELSE
    //                   // Dimensionsebene nicht zulässig!
    //                   ERROR(AGILES_LT_TEXT006);
    //               END;

    //               lrc_ItemJournalLine.VALIDATE("Unit of Measure Code",lrc_PackOrderInputPackItems."Unit of Measure Code");
    //               lrc_ItemJournalLine.VALIDATE(Quantity,ABS(lrc_PackOrderInputPackItems."Quantity to Consume"));

    //               lrc_ItemJournalLine.insert();
    //               lcu_ItemJnlPostLine.RUN(lrc_ItemJournalLine);
    //               END;

    //               lrc_PackOrderInputPackItems."Quantity Consumed" := lrc_PackOrderInputPackItems."Quantity Consumed" +
    //                                                              lrc_PackOrderInputPackItems."Quantity to Consume";
    //               lrc_PackOrderInputPackItems."Quantity Consumed (Base)" := lrc_PackOrderInputPackItems."Quantity Consumed" *
    //                                                              lrc_PackOrderInputPackItems."Qty. per Unit of Measure";

    //               lrc_PackOrderInputPackItems."Remaining Quantity" := lrc_PackOrderInputPackItems.Quantity -
    //                                                               lrc_PackOrderInputPackItems."Quantity Consumed";
    //               lrc_PackOrderInputPackItems."Remaining Quantity (Base)" := lrc_PackOrderInputPackItems."Remaining Quantity" *
    //                                                                      lrc_PackOrderInputPackItems."Qty. per Unit of Measure";

    //               IF lrc_PackOrderInputPackItems.Quantity >= 0 THEN BEGIN
    //                 // FV START 051005 --> Bei negativer Buchung wird die Menge reduziert
    //                 IF lrc_PackOrderInputPackItems."Quantity to Consume" < 0 THEN BEGIN
    //                   lrc_PackOrderInputPackItems.VALIDATE(Quantity, lrc_PackOrderInputPackItems.Quantity +
    //                                                        lrc_PackOrderInputPackItems."Quantity to Consume");
    //                   lrc_PackOrderInputPackItems."Quantity (Base)" := lrc_PackOrderInputPackItems."Quantity (Base)" +
    //                                                                    lrc_PackOrderInputPackItems."Quantity to Consume (Base)";
    //                 END;
    //               END;
    //               // FV ENDE

    //               lrc_PackOrderInputPackItems."Quantity to Consume" := 0;
    //               lrc_PackOrderInputPackItems."Quantity to Consume (Base)" := 0;

    //               IF lrc_PackOrderInputPackItems."Date of Posting" = 0D THEN BEGIN
    //                 lrc_PackOrderInputPackItems."Date of Posting" := TODAY;
    //                 lrc_PackOrderInputPackItems."Userid of Posting" := USERID;
    //               END;

    //               lrc_PackOrderInputPackItems.Modify();

    //             END;

    //           UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //           COMMIT;
    //         END;
    //     end;

    //     procedure PackPostOutput(vco_PackOrderNo: Code[20])
    //     var
    //         lcu_ItemJnlPostLine: Codeunit "22";
    //         lcu_FGuBPartien: Codeunit "5110300";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_ItemJournalLine: Record "83" temporary;
    //         lin_Zeilennummer: Integer;
    //         AGILES_LT_TEXT001: Label 'Dimensionsebene nicht zulässig!';
    //         lrc_Item: Record Item;
    //         "-- Agiles L PAL 001": Integer;
    //         lcu_PalletManagement: Codeunit "5110346";
    //         AGILES_LT_TEXT002: Label 'Es gibt nichts zu buchen!';
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zum Buchen der Ergebnisse
    //         // -----------------------------------------------------------------------------------------

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         lrc_PackOrderHeader.TESTFIELD("Pack.-by Vendor No.");
    //         lrc_PackOrderHeader.TESTFIELD("Master Batch No.");
    //         // POI 004.S
    //         //lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    //         IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::"8" THEN
    //           lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    //         // POI 004.E

    //         lrc_FruitVisionSetup.GET();
    //         lrc_BatchSetup.GET();

    //         // Prüfung ob alle Werte gesetzt sind
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderOutputItems.SETFILTER("Quantity to Produce",'<>%1',0);
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_PackOrderOutputItems.TESTFIELD("Item No.");

    //             lrc_Item.GET( lrc_PackOrderOutputItems."Item No." );
    //             IF lrc_Item."Batch Item" = TRUE THEN BEGIN
    //               lrc_PackOrderOutputItems.TESTFIELD("Master Batch No.");
    //               lrc_PackOrderOutputItems.TESTFIELD("Batch No.");
    //               lrc_PackOrderOutputItems.TESTFIELD("Batch Variant No.");
    //             END;

    //             lrc_PackOrderOutputItems.TESTFIELD("Location Code");
    //             lrc_PackOrderOutputItems.TESTFIELD("Unit of Measure Code");
    //             lrc_PackOrderOutputItems.TESTFIELD("Base Unit of Measure (BU)");
    //             lrc_PackOrderOutputItems.TESTFIELD("Qty. per Unit of Measure");

    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

    //           // PAL 001 00000000.s
    //           lcu_PalletManagement.PackOrderOutputPostCheckPallet( lrc_PackOrderHeader );
    //           // PAL 001 00000000.e

    //         END ELSE BEGIN
    //           // Es gibt nichts zu buchen!
    //           ERROR(AGILES_LT_TEXT002);
    //         END;

    //         //RS Prüfung ob Menge Leergut in In- und Outputzeilen identisch
    //         EPSInputOutput(vco_PackOrderNo);

    //         // Buchungsblatt füllen und buchen
    //         lin_Zeilennummer := 0;
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderOutputItems.SETFILTER("Quantity to Produce",'<>%1',0);
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN

    //           // PAL 001 00000000.s
    //           lcu_PalletManagement.PackOrderOutputPostIncomPallet( lrc_PackOrderHeader );
    //           // PAL 001 00000000.e

    //           REPEAT

    //             CLEAR(lcu_ItemJnlPostLine);

    //             lrc_ItemJournalLine.Reset();
    //             lrc_ItemJournalLine.INIT();
    //             lrc_ItemJournalLine."Journal Template Name" := '';
    //             lrc_ItemJournalLine."Journal Batch Name" := '';

    //             lin_Zeilennummer := lin_Zeilennummer + 10000;
    //             lrc_ItemJournalLine."Line No." := lin_Zeilennummer;

    //             lrc_ItemJournalLine.VALIDATE("Item No.",lrc_PackOrderOutputItems."Item No.");
    //             lrc_ItemJournalLine.VALIDATE("Variant Code",lrc_PackOrderOutputItems."Variant Code");

    //             lrc_ItemJournalLine."Master Batch No." := lrc_PackOrderOutputItems."Master Batch No.";
    //             lrc_ItemJournalLine."Batch No." := lrc_PackOrderOutputItems."Batch No.";
    //             lrc_ItemJournalLine."Batch Variant No." := lrc_PackOrderOutputItems."Batch Variant No.";

    //             lrc_ItemJournalLine.VALIDATE("Posting Date",lrc_PackOrderHeader."Posting Date");
    //             lrc_ItemJournalLine.VALIDATE("Gen. Bus. Posting Group",lrc_PackOrderHeader."Gen. Bus. Posting Group");
    //             IF lrc_PackOrderOutputItems."Quantity to Produce" > 0 THEN
    //               lrc_ItemJournalLine.VALIDATE("Entry Type",lrc_ItemJournalLine."Entry Type"::"Positive Adjmt.")
    //             ELSE
    //               lrc_ItemJournalLine.VALIDATE("Entry Type",lrc_ItemJournalLine."Entry Type"::"Negative Adjmt.");
    //             lrc_ItemJournalLine."Document No." := lrc_PackOrderHeader."No.";
    //             lrc_ItemJournalLine.Description := '';
    //             lrc_ItemJournalLine.VALIDATE("Location Code",lrc_PackOrderOutputItems."Location Code");
    //             lrc_ItemJournalLine."Salespers./Purch. Code" := lrc_PackOrderHeader."Person in Charge Code";

    //             lrc_ItemJournalLine."Country of Origin Code" := lrc_PackOrderOutputItems."Country of Origin Code";
    //             lrc_ItemJournalLine."Variety Code" := lrc_PackOrderOutputItems."Variety Code";
    //             lrc_ItemJournalLine."Trademark Code" := lrc_PackOrderOutputItems."Trademark Code";
    //             lrc_ItemJournalLine."Caliber Code" := lrc_PackOrderOutputItems."Caliber Code";
    //             lrc_ItemJournalLine."Item Attribute 2" := lrc_PackOrderOutputItems."Item Attribute 2";
    //             lrc_ItemJournalLine."Grade of Goods Code" := lrc_PackOrderOutputItems."Grade of Goods Code";
    //             lrc_ItemJournalLine."Item Attribute 7" := lrc_PackOrderOutputItems."Item Attribute 7";
    //             lrc_ItemJournalLine."Item Attribute 4" := lrc_PackOrderOutputItems."Item Attribute 4";
    //             lrc_ItemJournalLine."Coding Code" := lrc_PackOrderOutputItems."Coding Code";
    //             lrc_ItemJournalLine."Item Attribute 3" := lrc_PackOrderOutputItems."Item Attribute 3";

    //             lrc_ItemJournalLine."Source Doc. Type" := lrc_ItemJournalLine."Source Doc. Type"::"Output Packerei";
    //             lrc_ItemJournalLine."Source Doc. No." := lrc_PackOrderOutputItems."Doc. No.";
    //             lrc_ItemJournalLine."Source Doc. Line No." := lrc_PackOrderOutputItems."Line No.";

    //             CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //               lrc_BatchSetup."Dim. No. Batch No."::" ":
    //                 BEGIN
    //                 END;
    //               lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                 lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code",lrc_PackOrderOutputItems."Batch No.");
    //               lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                 lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 2 Code",lrc_PackOrderOutputItems."Batch No.");
    //               lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                 lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 3 Code",lrc_PackOrderOutputItems."Batch No.");
    //               lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                 lrc_ItemJournalLine.VALIDATE("Shortcut Dimension 4 Code",lrc_PackOrderOutputItems."Batch No.");
    //               ELSE
    //                 // Dimensionsebene nicht zulässig!
    //                 ERROR(AGILES_LT_TEXT001);
    //             END;

    //             lrc_ItemJournalLine.VALIDATE("Unit of Measure Code",lrc_PackOrderOutputItems."Unit of Measure Code");
    //             lrc_ItemJournalLine.VALIDATE(Quantity,ABS(lrc_PackOrderOutputItems."Quantity to Produce"));

    //             lrc_ItemJournalLine.insert();
    //             lcu_ItemJnlPostLine.RUN(lrc_ItemJournalLine);

    //             // Gebuchte Menge in Zeile Output schreiben
    //             lrc_PackOrderOutputItems."Quantity Produced" := lrc_PackOrderOutputItems."Quantity Produced" +
    //                                                             lrc_PackOrderOutputItems."Quantity to Produce";

    //             lrc_PackOrderOutputItems."Remaining Quantity" := lrc_PackOrderOutputItems.Quantity -
    //                                                              lrc_PackOrderOutputItems."Quantity Produced";

    //             lrc_PackOrderOutputItems."Quantity to Produce" := lrc_PackOrderOutputItems.Quantity -
    //                                                               lrc_PackOrderOutputItems."Quantity Produced";

    //             lrc_PackOrderOutputItems."Quantity to Produce (Base)" := lrc_PackOrderOutputItems."Quantity to Produce" *
    //                                                                      lrc_PackOrderOutputItems."Qty. per Unit of Measure";
    //             lrc_PackOrderOutputItems."Quantity Produced (Base)" := lrc_PackOrderOutputItems."Quantity Produced" *
    //                                                                    lrc_PackOrderOutputItems."Qty. per Unit of Measure";
    //             lrc_PackOrderOutputItems."Remaining Quantity (Base)" := lrc_PackOrderOutputItems."Remaining Quantity" *
    //                                                                     lrc_PackOrderOutputItems."Qty. per Unit of Measure";

    //             lrc_PackOrderOutputItems.Modify();

    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

    //         END;
    //     end;

    //     procedure PackPostInputCost(vco_PackOrderNo: Code[20])
    //     var
    //         lcu_ResJnlPostLine: Codeunit "212";
    //         lcu_FGuBPartien: Codeunit "5110300";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_ResJournalLine: Record "207" temporary;
    //         AGILES_LT_TEXT001: Label 'Es gibt nichts zu buchen !';
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zum Buchen der Kosten ( nur Ressource )
    //         // -----------------------------------------------------------------------------------------

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         lrc_PackOrderHeader.TESTFIELD("Pack.-by Vendor No.");
    //         lrc_PackOrderHeader.TESTFIELD("Master Batch No.");
    //         // POI 004.S
    //         //lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    //         IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::"8" THEN
    //           lrc_PackOrderHeader.TESTFIELD(Status, lrc_PackOrderHeader.Status::Open);
    //         // POI 004.E

    //         lrc_FruitVisionSetup.GET();

    //         // Prüfung ob alle Werte gesetzt sind
    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.SETRANGE(Type, lrc_PackOrderInputCosts.Type::Resource);
    //         lrc_PackOrderInputCosts.SETFILTER("Quantity to Consume",'<>%1',0);
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_PackOrderInputCosts.TESTFIELD( "No." );
    //             lrc_PackOrderInputCosts.TESTFIELD("Unit of Measure Code");
    //             lrc_PackOrderInputCosts.TESTFIELD("Qty. per Unit of Measure");
    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //         END ELSE BEGIN
    //           ERROR(AGILES_LT_TEXT001);
    //         END;

    //         // Buchungsblatt füllen und buchen
    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.SETRANGE( Type, lrc_PackOrderInputCosts.Type::Resource );
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //           REPEAT

    //             IF lrc_PackOrderInputCosts."Quantity to Consume" <> 0 THEN BEGIN
    //               CLEAR(lcu_ResJnlPostLine);

    //               lrc_ResJournalLine.Reset();
    //               lrc_ResJournalLine.DELETEALL();

    //               lrc_ResJournalLine.Reset();
    //               lrc_ResJournalLine.INIT();
    //               lrc_ResJournalLine."Journal Template Name" := ''; //'ARTIKEL';
    //               lrc_ResJournalLine."Journal Batch Name" := ''; //'PACKEREI';
    //               lrc_ResJournalLine."Line No." := 0; //10000;

    //               lrc_ResJournalLine.VALIDATE( "Entry Type", lrc_ResJournalLine."Entry Type"::Usage );
    //               lrc_ResJournalLine.VALIDATE( "Document No.", lrc_PackOrderHeader."No." );
    //               lrc_ResJournalLine.VALIDATE( "Posting Date", lrc_PackOrderHeader."Posting Date");
    //               lrc_ResJournalLine.VALIDATE( "Resource No.", lrc_PackOrderInputCosts."No." );
    //               lrc_ResJournalLine.VALIDATE( "Unit of Measure Code", lrc_PackOrderInputCosts."Unit of Measure Code" );
    //               lrc_ResJournalLine.VALIDATE( "Work Type Code", lrc_PackOrderInputCosts."Work Type Code" );

    //               lrc_ResJournalLine.VALIDATE( Description, lrc_PackOrderInputCosts.Description );

    //               lrc_ResJournalLine.VALIDATE( Chargeable, FALSE );

    //               lrc_ResJournalLine.VALIDATE( Quantity, lrc_PackOrderInputCosts."Quantity to Consume" );
    //               lrc_ResJournalLine.VALIDATE( "Direct Unit Cost", lrc_PackOrderInputCosts."Allocation Price (LCY)" );
    //               lrc_ResJournalLine.VALIDATE( "Unit Cost", lrc_PackOrderInputCosts."Allocation Price (LCY)" );

    //               lrc_ResJournalLine.VALIDATE( "Gen. Bus. Posting Group", lrc_PackOrderHeader."Gen. Bus. Posting Group");
    //               lrc_ResJournalLine.VALIDATE( "Qty. per Unit of Measure", lrc_PackOrderInputCosts."Qty. per Unit of Measure" );

    //         //     lrc_ResJournalLine."Shortcut Dimension 1 Code"
    //         //     lrc_ResJournalLine."Shortcut Dimension 2 Code"
    //         //     lrc_ResJournalLine."Shortcut Dimension 3 Code"
    //         //     lrc_ResJournalLine."Shortcut Dimension 4 Code"

    //               lrc_ResJournalLine.insert();
    //               lcu_ResJnlPostLine.RUN(lrc_ResJournalLine);

    //               lrc_PackOrderInputCosts."Posted Costs (LCY)" := lrc_PackOrderInputCosts."Posted Costs (LCY)" +
    //                                                               ROUND(lrc_PackOrderInputCosts."Allocation Price (LCY)" *
    //                                                                     lrc_PackOrderInputCosts."Quantity to Consume", 0.00001);

    //               lrc_PackOrderInputCosts."Quantity Consumed" := lrc_PackOrderInputCosts."Quantity Consumed" +
    //                                                              lrc_PackOrderInputCosts."Quantity to Consume";
    //               lrc_PackOrderInputCosts."Quantity Consumed (Base)" := lrc_PackOrderInputCosts."Quantity Consumed" *
    //                                                              lrc_PackOrderInputCosts."Qty. per Unit of Measure";

    //               lrc_PackOrderInputCosts."Remaining Quantity" := lrc_PackOrderInputCosts.Quantity -
    //                                                               lrc_PackOrderInputCosts."Quantity Consumed";
    //               lrc_PackOrderInputCosts."Remaining Quantity (Base)" := lrc_PackOrderInputCosts."Remaining Quantity" *
    //                                                                      lrc_PackOrderInputCosts."Qty. per Unit of Measure";

    //               // FV START 051005 --> Bei negativer Buchung wird die Menge reduziert
    //               IF lrc_PackOrderInputCosts."Quantity to Consume" < 0 THEN BEGIN
    //                 lrc_PackOrderInputCosts.VALIDATE(Quantity, lrc_PackOrderInputCosts.Quantity +
    //                                                  lrc_PackOrderInputCosts."Quantity to Consume");
    //                 lrc_PackOrderInputCosts."Quantity (Base)" := lrc_PackOrderInputCosts."Quantity (Base)" +
    //                                                              lrc_PackOrderInputCosts."Quantity to Consume (Base)";
    //               END;
    //               // FV ENDE

    //               lrc_PackOrderInputCosts."Quantity to Consume" := 0;
    //               lrc_PackOrderInputCosts."Quantity to Consume (Base)" := 0;

    //               IF lrc_PackOrderInputCosts."Date of Posting" = 0D THEN BEGIN
    //                 lrc_PackOrderInputCosts."Date of Posting" := TODAY;
    //                 lrc_PackOrderInputCosts."Userid of Posting" := USERID;
    //               END;

    //               lrc_PackOrderInputCosts.Modify();

    //             END;

    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //           COMMIT;
    //         END;
    //     end;

    //     procedure "-- ERSATZARTIKEL --"()
    //     begin
    //     end;

    //     procedure SubstitutionShowOrder(vco_PackingOrderCode: Code[20])
    //     var
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_PackingOrderHeader: Record "5110712";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige / Bearbeitung Ersatzartikelpackereiauftrag
    //         // ----------------------------------------------------------------------------------------

    //         lrc_RecipePackingSetup.GET();
    //         lrc_RecipePackingSetup.TESTFIELD("Form ID Pack. Order Card");

    //         lrc_PackingOrderHeader.SETRANGE("No.",vco_PackingOrderCode );

    //         FORM.RUN(lrc_RecipePackingSetup."Form ID Pack. Order Card",lrc_PackingOrderHeader);
    //     end;

    //     procedure SubstitutionNewOrder(rbn_ShowOrder: Boolean;vco_PackDocType: Code[10]): Code[20]
    //     var
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lrc_PackingOrderHeader: Record "5110712";
    //         lco_MasterBatchCode: Code[20];
    //         lco_BatchCode: Code[20];
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_Location: Record "14";
    //         lrc_BatchSetup: Record "5110363";
    //         "--- PAC 011 00000000": Integer;
    //         lrc_PackDocSubtype: Record "5110725";
    //     begin
    //         // ----------------------------------------------------------------------------------------
    //         // Funktion zur Neuanlage Ersatzartikel-Packereiauftrag
    //         // ----------------------------------------------------------------------------------------

    //         lrc_PackingOrderHeader.Reset();
    //         lrc_PackingOrderHeader.INIT();
    //         lrc_PackingOrderHeader."No." := '';
    //         lrc_PackingOrderHeader."Document Type" := lrc_PackingOrderHeader."Document Type"::"Substitution Order";
    //         lrc_PackingOrderHeader."Pack. Doc. Type Code" := vco_PackDocType;
    //         lrc_PackingOrderHeader.INSERT(TRUE);

    //         lrc_RecipePackingSetup.GET();

    //         // PAC 011 00000000.s
    //         IF ( vco_PackDocType = '' ) OR
    //            ( NOT lrc_PackDocSubtype.GET( vco_PackDocType ) ) THEN BEGIN
    //            lrc_PackDocSubtype.INIT();
    //         END;
    //         IF lrc_PackDocSubtype."Default Output Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Outp. Item Location Code" := lrc_PackDocSubtype."Default Output Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Outp. Item Location Code" := lrc_RecipePackingSetup."Default Output Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         IF lrc_PackDocSubtype."Default Packing Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Inp. Packing Item Loc. Code" := lrc_PackDocSubtype."Default Packing Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Inp. Packing Item Loc. Code" := lrc_RecipePackingSetup."Default Packing Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         IF lrc_PackDocSubtype."Default Empties Location Code" <> '' THEN BEGIN
    //           lrc_PackingOrderHeader."Inp. Empties Item Loc. Code" := lrc_PackDocSubtype."Default Empties Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackingOrderHeader."Inp. Empties Item Loc. Code" := lrc_RecipePackingSetup."Default Empties Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         // PAC 011 00000000.e

    //         IF lrc_PackingOrderHeader."Outp. Item Location Code" <> '' THEN BEGIN
    //           IF lrc_Location.GET(lrc_PackingOrderHeader."Outp. Item Location Code") THEN BEGIN
    //             IF lrc_Location."Vendor No." <> '' THEN BEGIN
    //               lrc_PackingOrderHeader.VALIDATE("Vendor No.", lrc_Location."Vendor No.");
    //               lrc_PackingOrderHeader.VALIDATE("Pack.-by Vendor No.", lrc_Location."Vendor No.");
    //             END;
    //           END;
    //         END;

    //         lcu_BatchMgt.PackNewMasterBatch(lrc_PackingOrderHeader,lco_MasterBatchCode);
    //         lrc_PackingOrderHeader."Master Batch No." := lco_MasterBatchCode;
    //         lrc_PackingOrderHeader.Modify();

    //         lrc_BatchSetup.GET();
    //         IF lrc_BatchSetup."Pack. Allocation Batch No." =
    //           lrc_BatchSetup."Pack. Allocation Batch No."::"One Batch No. per Order" THEN BEGIN
    //           lcu_BatchMgt.PackNewBatch(lrc_PackingOrderHeader,lco_BatchCode);
    //           lrc_PackingOrderHeader."Batch No." := lco_BatchCode;
    //           lrc_PackingOrderHeader.Modify();
    //         END;

    //         COMMIT;

    //         IF rbn_ShowOrder = TRUE THEN BEGIN
    //           PackShowOrder(lrc_PackingOrderHeader."No.");
    //         END;

    //         EXIT(lrc_PackingOrderHeader."No.");
    //     end;

    //     procedure "-- OTHER FUNCTIONS --"()
    //     begin
    //     end;

    //     procedure CreatePackOrderFromFeatureAss(var vrc_FeatureAssortmentCustoPric: Record "5110374")
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_FeatureAssortment: Record "5110353";
    //         lrc_FeatureAssortmentLines: Record "5110352";
    //         lrc_FeatureAssortmentCustLine: Record "5110359";
    //         lrc_FeatureAssortmentCustoPric: Record "5110374";
    //         lfm_PackOrder: Form "5110730";
    //         lrc_RecipeHeader: Record "5110710";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PackOrderOutputItems2: Record "5110713";
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //         lrc_PackOrderInputPackItems2: Record "5110715";
    //         lrc_RecipeInputPackingItems: Record "5110704";
    //         lrc_RecipeProductionLines: Record "5110709";
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_Location: Record "14";
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lco_MasterBatchCode: Code[20];
    //         lco_BatchCode: Code[20];
    //         lrc_Customer: Record "Customer";
    //         lrc_BatchSetup: Record "5110363";
    //         ldc_InputPackItemQuantity: Decimal;
    //         lrc_ItemUnitOfMeasure: Record "5404";
    //         lrc_ItemUnitOfMeasure2: Record "5404";
    //         ldc_Rounding: Decimal;
    //         lrc_BatchVariant: Record "5110366";
    //         lin_LineNo: Integer;
    //         lrc_Item: Record Item;
    //         lin_NumberProductionslines: Integer;
    //         SSPText01: Label 'There exist %1 productionlines, do you want to split the quantity %2 ?';
    //         "--- PAC 011 00000000": Integer;
    //         lrc_PackDocSubtype: Record "5110725";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------

    //         lrc_FeatureAssortment.GET( vrc_FeatureAssortmentCustoPric."Assortment Code" );

    //         lrc_FeatureAssortmentLines.GET( vrc_FeatureAssortmentCustoPric."Assortment Code",
    //                                         vrc_FeatureAssortmentCustoPric."Assortment Line No." );
    //         lrc_FeatureAssortmentLines.TESTFIELD( "Item No." );

    //         vrc_FeatureAssortmentCustoPric.TESTFIELD( "Shipment Date" );
    //         vrc_FeatureAssortmentCustoPric.TESTFIELD( "Recorded Quantity" );

    //         // es muss ein Rezept mit Status Freigegeben existieren
    //         lrc_RecipeHeader.Reset();
    //         lrc_RecipeHeader.SETCURRENTKEY( "Item No.", Status );
    //         lrc_RecipeHeader.SETRANGE( "Item No.", lrc_FeatureAssortmentLines."Item No." );
    //         lrc_RecipeHeader.SETRANGE( Status, lrc_RecipeHeader.Status::Released );
    //         lrc_RecipeHeader.FIND('-');

    //         lrc_PackOrderHeader.Reset();
    //         lrc_PackOrderHeader.INIT();
    //         lrc_PackOrderHeader."No." := '';
    //         lrc_PackOrderHeader."Document Type" := lrc_PackOrderHeader."Document Type"::"Packing Order";

    //         lrc_RecipePackingSetup.GET();
    //         lrc_RecipePackingSetup.TESTFIELD( "Pack. Doc. Type Code FAS" );
    //         lrc_PackOrderHeader."Pack. Doc. Type Code" := lrc_RecipePackingSetup."Pack. Doc. Type Code FAS";
    //         lrc_PackOrderHeader.INSERT( TRUE );

    //         lrc_RecipePackingSetup.GET();

    //         // PAC 011 00000000.s
    //         IF ( lrc_RecipePackingSetup."Pack. Doc. Type Code FAS" = '' ) OR
    //            ( NOT lrc_PackDocSubtype.GET( lrc_RecipePackingSetup."Pack. Doc. Type Code FAS" ) ) THEN BEGIN
    //            lrc_PackDocSubtype.INIT();
    //         END;
    //         IF lrc_PackDocSubtype."Default Output Location Code" <> '' THEN BEGIN
    //           lrc_PackOrderHeader."Outp. Item Location Code" := lrc_PackDocSubtype."Default Output Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackOrderHeader."Outp. Item Location Code" := lrc_RecipePackingSetup."Default Output Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         IF lrc_PackDocSubtype."Default Packing Location Code" <> '' THEN BEGIN
    //           lrc_PackOrderHeader."Inp. Packing Item Loc. Code" := lrc_PackDocSubtype."Default Packing Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackOrderHeader."Inp. Packing Item Loc. Code" := lrc_RecipePackingSetup."Default Packing Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         IF lrc_PackDocSubtype."Default Empties Location Code" <> '' THEN BEGIN
    //           lrc_PackOrderHeader."Inp. Empties Item Loc. Code" := lrc_PackDocSubtype."Default Empties Location Code";
    //         END ELSE BEGIN
    //         // PAC 011 00000000.e
    //           lrc_PackOrderHeader."Inp. Empties Item Loc. Code" := lrc_RecipePackingSetup."Default Empties Location Code";
    //         // PAC 011 00000000.s
    //         END;
    //         // PAC 011 00000000.e

    //         IF lrc_PackOrderHeader."Outp. Item Location Code" <> '' THEN BEGIN
    //           IF lrc_Location.GET(lrc_PackOrderHeader."Outp. Item Location Code") THEN BEGIN
    //             IF lrc_Location."Vendor No." <> '' THEN BEGIN
    //               lrc_PackOrderHeader.VALIDATE("Vendor No.", lrc_Location."Vendor No.");
    //               lrc_PackOrderHeader.VALIDATE("Pack.-by Vendor No.", lrc_Location."Vendor No.");
    //             END;
    //           END;
    //         END;

    //         lcu_BatchMgt.PackNewMasterBatch(lrc_PackOrderHeader,lco_MasterBatchCode);
    //         lrc_PackOrderHeader."Master Batch No." := lco_MasterBatchCode;
    //         lrc_PackOrderHeader.Modify();

    //         lrc_BatchSetup.GET();
    //         IF lrc_BatchSetup."Pack. Allocation Batch No." =
    //            lrc_BatchSetup."Pack. Allocation Batch No."::"One Batch No. per Order" THEN BEGIN
    //           lcu_BatchMgt.PackNewBatch(lrc_PackOrderHeader,lco_BatchCode);
    //           lrc_PackOrderHeader."Batch No." := lco_BatchCode;
    //           lrc_PackOrderHeader.Modify();
    //         END;

    //         lrc_PackOrderHeader.VALIDATE( "Item No.", lrc_FeatureAssortmentLines."Item No." );

    //         lrc_PackOrderHeader.VALIDATE( "Chain Name", lrc_FeatureAssortment."Chain Name" );

    //         // Debitor eintragen, wenn es nur für einen Debitor eine "Erfasste Mengen" gibt
    //         lrc_FeatureAssortmentCustoPric.Reset();
    //         lrc_FeatureAssortmentCustoPric.SETRANGE( "Assortment Code", vrc_FeatureAssortmentCustoPric."Assortment Code" );
    //         lrc_FeatureAssortmentCustoPric.SETRANGE( "Assortment Line No.", vrc_FeatureAssortmentCustoPric."Assortment Line No." );
    //         lrc_FeatureAssortmentCustoPric.SETRANGE( "Shipment Date", vrc_FeatureAssortmentCustoPric."Shipment Date" );
    //         lrc_FeatureAssortmentCustoPric.SETFILTER( "Customer No.", '<>%1', '' );
    //         IF lrc_FeatureAssortmentCustoPric.FIND('-') THEN BEGIN
    //           IF lrc_FeatureAssortmentCustoPric.COUNT() = 1 THEN BEGIN
    //             lrc_Customer.GET( lrc_FeatureAssortmentCustoPric."Customer No." );
    //             lrc_PackOrderHeader.VALIDATE( "Customer No.", lrc_FeatureAssortmentCustoPric."Customer No." );
    //             IF lrc_Customer."Chain Name" <> '' THEN BEGIN
    //               lrc_PackOrderHeader.VALIDATE( "Chain Name", lrc_Customer."Chain Name" );
    //             END;
    //           END;
    //         END;

    //         lrc_PackOrderHeader.VALIDATE("Order Date", vrc_FeatureAssortmentCustoPric."Shipment Date");
    //         lrc_PackOrderHeader.VALIDATE("Packing Date", vrc_FeatureAssortmentCustoPric."Shipment Date");
    //         lrc_PackOrderHeader.VALIDATE("Promised Receipt Date", vrc_FeatureAssortmentCustoPric."Shipment Date");

    //         lrc_PackOrderHeader.VALIDATE("Recipe Code", lrc_RecipeHeader."No.");

    //         // Produktionslinie eintragen, wenn es nur eine gibt
    //         lin_NumberProductionslines := 1;
    //         lrc_RecipeProductionLines.Reset();
    //         lrc_RecipeProductionLines.SETRANGE( "Recipe No.", lrc_RecipeHeader."No." );
    //         IF lrc_RecipeProductionLines.FIND('-') THEN BEGIN

    //            lrc_RecipeProductionLines.SETRANGE( Default, TRUE );
    //            IF lrc_RecipeProductionLines.FIND('-') THEN BEGIN
    //              lrc_PackOrderHeader.VALIDATE( "Production Line Code", lrc_RecipeProductionLines."Productionline Code" );
    //            END ELSE BEGIN
    //              lrc_RecipeProductionLines.SETRANGE( Default );
    //              IF lrc_RecipeProductionLines.COUNT() = 1 THEN BEGIN
    //                lrc_PackOrderHeader.VALIDATE( "Production Line Code", lrc_RecipeProductionLines."Productionline Code" );
    //              END;
    //            END;
    //            lrc_RecipeProductionLines.SETRANGE( Default );
    //            IF lrc_PackOrderHeader."Production Line Code" <> '' THEN BEGIN
    //              IF lrc_RecipeProductionLines.COUNT() > 1 THEN BEGIN
    //                IF CONFIRM(SSPText01, TRUE, lrc_RecipeProductionLines.COUNT(),
    //                           vrc_FeatureAssortmentCustoPric."Recorded Quantity" ) THEN BEGIN
    //                  lin_NumberProductionslines := lrc_RecipeProductionLines.COUNT();
    //                END;
    //              END;
    //            END;
    //         END;

    //         lrc_PackOrderHeader.VALIDATE( "Assortment Code", vrc_FeatureAssortmentCustoPric."Assortment Code" );
    //         lrc_PackOrderHeader.VALIDATE( "Assortment Line No.", vrc_FeatureAssortmentCustoPric."Assortment Line No." );

    //         lrc_PackOrderHeader.MODIFY( TRUE );

    //         // in den Outputzeilen, Tafelware die Menge setzen
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETCURRENTKEY( "Type of Packing Product","Item No." );
    //         lrc_PackOrderOutputItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         lrc_PackOrderOutputItems.SETRANGE( "Item No.", lrc_FeatureAssortmentLines."Item No." );
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //            // nur einmal die Menge setzen
    //            lrc_PackOrderOutputItems.VALIDATE( Quantity, vrc_FeatureAssortmentCustoPric."Recorded Quantity" / lin_NumberProductionslines );
    //            lrc_PackOrderOutputItems.MODIFY( TRUE );

    //            lrc_BatchVariant.GET( lrc_PackOrderOutputItems."Batch Variant No." );

    //            // Menge der Verpackungen setzen
    //            lrc_PackOrderInputPackItems.Reset();
    //            lrc_PackOrderInputPackItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //            IF lrc_PackOrderInputPackItems.FIND('-') THEN BEGIN
    //               REPEAT

    //                     ldc_InputPackItemQuantity := 1;

    //                     lrc_RecipeInputPackingItems.Reset();
    //                     lrc_RecipeInputPackingItems.SETRANGE( "Recipe No.", lrc_PackOrderInputPackItems."Created From Recipe Code" );
    //                     lrc_RecipeInputPackingItems.SETRANGE( "Customer No.", lrc_PackOrderInputPackItems."Created From Customer No." );
    //                     lrc_RecipeInputPackingItems.SETRANGE( "Line No.", lrc_PackOrderInputPackItems."Created From Line No." );
    //                     IF lrc_RecipeInputPackingItems.FIND('-') THEN BEGIN

    //                        // Basiseinheit der Artikel muss gleich sein
    //                        // beide Artikeleinheiten müssen vorhanden sein
    //                        IF ( lrc_ItemUnitOfMeasure.GET( lrc_PackOrderOutputItems."Item No.",
    //                                                        lrc_PackOrderOutputItems."Unit of Measure Code" ) ) THEN BEGIN

    //                           lrc_RecipePackingSetup.GET();
    //                           IF lrc_RecipePackingSetup."PackItem Quant. Decimal Places" = 1 THEN BEGIN
    //                              ldc_Rounding := 0.1
    //                           END ELSE BEGIN
    //                              IF lrc_RecipePackingSetup."PackItem Quant. Decimal Places" = 2 THEN BEGIN
    //                                 ldc_Rounding := 0.01
    //                              END ELSE BEGIN
    //                                 IF lrc_RecipePackingSetup."PackItem Quant. Decimal Places" = 3 THEN BEGIN
    //                                    ldc_Rounding := 0.001
    //                                 END ELSE BEGIN
    //                                    IF lrc_RecipePackingSetup."PackItem Quant. Decimal Places" = 4 THEN BEGIN
    //                                      ldc_Rounding := 0.0001
    //                                    END ELSE BEGIN
    //                                      IF lrc_RecipePackingSetup."PackItem Quant. Decimal Places" = 5 THEN BEGIN
    //                                         ldc_Rounding := 0.00001
    //                                      END ELSE BEGIN
    //                                         ldc_Rounding := 1;
    //                                      END;
    //                                    END;
    //                                 END;
    //                              END;
    //                           END;

    //                           // Gesamtmenge in Basiseinheit ausrechnen
    //                           ldc_InputPackItemQuantity :=
    //                                     ( vrc_FeatureAssortmentCustoPric."Recorded Quantity" *
    //                                       lrc_ItemUnitOfMeasure."Qty. per Unit of Measure" );

    //                           // Gesamtmenge geteilt durch Rezeptmenge
    //                           IF ( lrc_RecipeHeader."Qty. (Base)" <> 0 ) AND
    //                              ( lrc_RecipeHeader."Qty. (Base)" <> 1 ) THEN BEGIN
    //                              ldc_InputPackItemQuantity := ldc_InputPackItemQuantity /
    //                                                           lrc_RecipeHeader."Qty. (Base)";
    //                           END;

    //                           // Gesamtmenge umrechnen in Rezepteinheit
    //                           IF lrc_ItemUnitOfMeasure2.GET(  lrc_PackOrderOutputItems."Item No.",
    //                              lrc_RecipeHeader."Unit of Measure Code" ) THEN BEGIN
    //                              IF lrc_ItemUnitOfMeasure."Qty. per Unit of Measure" <>
    //                                 lrc_ItemUnitOfMeasure2."Qty. per Unit of Measure" THEN BEGIN
    //                                  ldc_InputPackItemQuantity := ldc_InputPackItemQuantity /
    //                                                               lrc_ItemUnitOfMeasure2."Qty. per Unit of Measure";
    //                              END;
    //                           END;

    //                           // Gesamtmenge ausrechnen
    //                           ldc_InputPackItemQuantity := ROUND( ( ldc_InputPackItemQuantity / lin_NumberProductionslines ) *
    //                              lrc_RecipeInputPackingItems.Quantity, ldc_Rounding );
    //                           IF ldc_InputPackItemQuantity < ldc_Rounding THEN BEGIN
    //                              ldc_InputPackItemQuantity := ldc_Rounding;
    //                           END;

    //                        END;

    //                        // Menge wegschreiben
    //                        CASE lrc_RecipeInputPackingItems."Way Of Process" OF
    //                           lrc_RecipeInputPackingItems."Way Of Process"::Packing:
    //                              BEGIN
    //                                lrc_PackOrderInputPackItems.VALIDATE( Quantity, ldc_InputPackItemQuantity );
    //                              END;
    //                           lrc_RecipeInputPackingItems."Way Of Process"::"Empties Input":
    //                              BEGIN
    //                                lrc_PackOrderInputPackItems.VALIDATE( Quantity, ldc_InputPackItemQuantity );
    //                              END;
    //                           lrc_RecipeInputPackingItems."Way Of Process"::"Empties Output":
    //                              BEGIN
    //                                lrc_PackOrderInputPackItems.VALIDATE( Quantity, -ldc_InputPackItemQuantity );
    //                              END;
    //                        END;
    //                        lrc_PackOrderInputPackItems.MODIFY( TRUE );
    //                     END ELSE BEGIN
    //                        lrc_PackOrderInputPackItems.VALIDATE( Quantity, ldc_InputPackItemQuantity );
    //                        lrc_PackOrderInputPackItems.MODIFY( TRUE );
    //                     END;

    //               UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //            END;

    //         END;

    //         IF lin_NumberProductionslines > 1 THEN BEGIN
    //            lrc_PackOrderOutputItems.Reset();
    //            lrc_PackOrderOutputItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //            lin_LineNo := 0;

    //            IF lrc_PackOrderOutputItems.FIND('+') THEN BEGIN
    //               lin_LineNo := lrc_PackOrderOutputItems."Line No.";
    //            END;

    //            lrc_PackOrderOutputItems.Reset();
    //            lrc_PackOrderOutputItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //            // PAC 009 00000000.s
    //            // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //            //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //            lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                               lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //            // PAC 009 00000000.e
    //            lrc_PackOrderOutputItems.SETRANGE( "Item No.", lrc_FeatureAssortmentLines."Item No." );
    //            lrc_PackOrderOutputItems.SETFILTER( "Production Line Code", '%1', lrc_PackOrderHeader."Production Line Code" );

    //            IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //               REPEAT

    //                  lrc_RecipeProductionLines.Reset();
    //                  lrc_RecipeProductionLines.SETRANGE( "Recipe No.", lrc_PackOrderHeader."Recipe Code" );
    //                  lrc_RecipeProductionLines.SETFILTER( "Productionline Code", '<>%1', lrc_PackOrderHeader."Production Line Code" );
    //                  IF lrc_RecipeProductionLines.FIND('-') THEN BEGIN
    //                     REPEAT

    //                        lrc_PackOrderOutputItems2.INIT();
    //                        lrc_PackOrderOutputItems2.TRANSFERFIELDS( lrc_PackOrderOutputItems );
    //                        lin_LineNo := lin_LineNo + 10000;
    //                        lrc_PackOrderOutputItems2."Line No." := lin_LineNo;
    //                        lrc_PackOrderOutputItems2."Production Line Code" := lrc_RecipeProductionLines."Productionline Code";
    //                        lrc_PackOrderOutputItems2."Batch Variant No." := '';
    //                        lrc_PackOrderOutputItems2.VALIDATE( "Item No." );
    //                        lrc_PackOrderOutputItems2.VALIDATE( Quantity, lrc_PackOrderOutputItems.Quantity );
    //                        lrc_PackOrderOutputItems2.INSERT( TRUE );

    //                     UNTIL lrc_RecipeProductionLines.NEXT() = 0;
    //                  END;
    //               UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //            END;

    //            lrc_PackOrderInputPackItems.Reset();
    //            lrc_PackOrderInputPackItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //            lin_LineNo := 0;

    //            IF lrc_PackOrderInputPackItems.FIND('+') THEN BEGIN
    //               lin_LineNo := lrc_PackOrderInputPackItems."Line No.";
    //            END;

    //            lrc_PackOrderInputPackItems.Reset();
    //            lrc_PackOrderInputPackItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //            lrc_PackOrderInputPackItems.SETFILTER( "Production Line Code", '%1', lrc_PackOrderHeader."Production Line Code" );
    //            IF lrc_PackOrderInputPackItems.FIND('-') THEN BEGIN
    //               REPEAT

    //                  lrc_RecipeProductionLines.Reset();
    //                  lrc_RecipeProductionLines.SETRANGE( "Recipe No.", lrc_PackOrderHeader."Recipe Code" );
    //                  lrc_RecipeProductionLines.SETFILTER( "Productionline Code", '<>%1', lrc_PackOrderHeader."Production Line Code" );
    //                  IF lrc_RecipeProductionLines.FIND('-') THEN BEGIN
    //                     REPEAT

    //                        lrc_PackOrderInputPackItems2.INIT();
    //                        lrc_PackOrderInputPackItems2.TRANSFERFIELDS( lrc_PackOrderInputPackItems );
    //                        lin_LineNo := lin_LineNo + 10000;
    //                        lrc_PackOrderInputPackItems2."Line No." := lin_LineNo;
    //                        lrc_PackOrderInputPackItems2."Production Line Code" := lrc_RecipeProductionLines."Productionline Code";
    //                        lrc_PackOrderInputPackItems2.INSERT( TRUE );

    //                     UNTIL lrc_RecipeProductionLines.NEXT() = 0;
    //                  END;
    //               UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //            END;

    //         END;

    //         vrc_FeatureAssortmentCustoPric."Pack. Order No." := lrc_PackOrderHeader."No.";
    //         vrc_FeatureAssortmentCustoPric.MODIFY( TRUE );

    //         // Kontrolle, ob erfasste Mengen existieren, diese dann dem Packereiauftrag zuordnen
    //         IF lrc_FeatureAssortment."Quantity Assignment" =
    //            lrc_FeatureAssortment."Quantity Assignment"::Nessessary THEN BEGIN
    //            CreateFeatureAssortmCustLine( vrc_FeatureAssortmentCustoPric."Assortment Code",
    //                                          vrc_FeatureAssortmentCustoPric."Assortment Line No.",
    //                                          vrc_FeatureAssortmentCustoPric."Shipment Date",
    //                                          lrc_BatchVariant."No.",
    //                                          lrc_PackOrderOutputItems."Location Code",
    //                                          '' );
    //         END;
    //     end;

    //     procedure CreateFeatureAssortmCustLine(rco_AssortmentCode: Code[20];rin_AssortmentLineNo: Integer;rdt_ShipmentDate: Date;rco_BatchVariantNo: Code[20];rco_LocationCode: Code[10];rco_Customer: Code[20])
    //     var
    //         lInt_LineNo: Integer;
    //         lrc_Item: Record Item;
    //         lrc_BatchVariant: Record "5110366";
    //         lcu_BatchManagement: Codeunit "5110307";
    //         ldc_Bestand: Decimal;
    //         ldc_BestandVerf: Decimal;
    //         ldc_ErwBestandVerf: Decimal;
    //         ldc_MgeInAuftrag: Decimal;
    //         ldc_MgeInBestellung: Decimal;
    //         ldc_Invoice: Decimal;
    //         ldc_Shipment: Decimal;
    //         ldc_PurchReceive: Decimal;
    //         ldc_MgeReserviertFV: Decimal;
    //         ldc_CustomerClearance: Decimal;
    //         ldc_RemainingQuantity: Decimal;
    //         lrc_FeatureAssortmentCustoPric: Record "5110374";
    //         lrc_FeatureAssortmentCustLine: Record "5110359";
    //         lrc_FeatureAssortmentLines: Record "5110352";
    //     begin
    //         lrc_FeatureAssortmentLines.GET( rco_AssortmentCode, rin_AssortmentLineNo );

    //         lrc_BatchVariant.GET( rco_BatchVariantNo );

    //         lrc_FeatureAssortmentCustoPric.Reset();
    //         lrc_FeatureAssortmentCustoPric.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //         lrc_FeatureAssortmentCustoPric.SETRANGE( "Assortment Line No.", rin_AssortmentLineNo );
    //         lrc_FeatureAssortmentCustoPric.SETRANGE( "Shipment Date", rdt_ShipmentDate );
    //         IF rco_Customer = '' THEN BEGIN
    //            lrc_FeatureAssortmentCustoPric.SETFILTER( "Customer No.", '<>%1', '' );
    //         END ELSE BEGIN
    //            lrc_FeatureAssortmentCustoPric.SETFILTER( "Customer No.", '%1', rco_Customer );
    //         END;
    //         IF lrc_FeatureAssortmentCustoPric.FIND('-') THEN BEGIN
    //            REPEAT

    //              lrc_FeatureAssortmentCustLine.Reset();
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Assortment Line No.", rin_AssortmentLineNo );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Shipment Date", rdt_ShipmentDate );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Customer No.", lrc_FeatureAssortmentCustoPric."Customer No." );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Item No.", lrc_FeatureAssortmentLines."Item No." );
    //              lrc_FeatureAssortmentCustLine.SETFILTER( "Document No.", '<>%1', '' );
    //              IF lrc_FeatureAssortmentCustLine.FIND('-') THEN BEGIN

    //              END;

    //              lrc_FeatureAssortmentCustLine.Reset();
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Assortment Line No.", rin_AssortmentLineNo );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Shipment Date", rdt_ShipmentDate );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Customer No.", lrc_FeatureAssortmentCustoPric."Customer No." );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Item No.", lrc_FeatureAssortmentLines."Item No." );
    //              lrc_FeatureAssortmentCustLine.SETRANGE( "Document No.", '' );
    //              IF NOT lrc_FeatureAssortmentCustLine.FIND('-') THEN BEGIN

    //                 lrc_FeatureAssortmentCustLine.Reset();
    //                 lrc_FeatureAssortmentCustLine.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //                 lrc_FeatureAssortmentCustLine.SETRANGE( "Assortment Line No.", rin_AssortmentLineNo );
    //                 lrc_FeatureAssortmentCustLine.SETRANGE( "Shipment Date", rdt_ShipmentDate );
    //                 lrc_FeatureAssortmentCustLine.SETRANGE( "Customer No.", lrc_FeatureAssortmentCustoPric."Customer No." );
    //                 IF lrc_FeatureAssortmentCustLine.FIND('+') THEN BEGIN
    //                    lInt_LineNo := lrc_FeatureAssortmentCustLine."Line No." + 10000;
    //                 END ELSE BEGIN
    //                    lInt_LineNo := 10000;
    //                 END;

    //                 lrc_FeatureAssortmentCustLine.Reset();
    //                 lrc_FeatureAssortmentCustLine.INIT();
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Assortment Code", rco_AssortmentCode );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Assortment Line No.", rin_AssortmentLineNo );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Shipment Date", rdt_ShipmentDate );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Customer No.", lrc_FeatureAssortmentCustoPric."Customer No." );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Line No.", lInt_LineNo );

    //                 lrc_Item.GET( lrc_BatchVariant."Item No." );

    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Item Typ", lrc_Item."Item Typ" );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Item No.",  lrc_BatchVariant."Item No." );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Variant Code",  lrc_BatchVariant."Variant Code" );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Item Description", lrc_BatchVariant.Description );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Item Description 2", lrc_BatchVariant."Description 2" );
    //                 // lrc_FeatureAssortmentCustLine.VALIDATE( "Item Main Category Code", lrc_BatchVariant."Item Main Categorie Code");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Item Category Code", lrc_BatchVariant."Item Category Code");

    //                 // Merkmale der Positionsvariante setzen
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Product Group Code", lrc_BatchVariant."Product Group Code");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Variety Code", lrc_BatchVariant."Variety Code");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Country of Origin Code", lrc_BatchVariant."Country of Origin Code");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Trademark Code", lrc_BatchVariant."Trademark Code");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Caliber Code", lrc_BatchVariant."Caliber Code" );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Color Code", lrc_BatchVariant."Item Attribute 2");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Grade of Goods Code", lrc_BatchVariant."Grade of Goods Code");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Conservation Code", lrc_BatchVariant."Item Attribute 7");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "AP Code",lrc_BatchVariant."Item Attribute 4" );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Coding Code", lrc_BatchVariant."Coding Code");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Quality Code", lrc_BatchVariant."Item Attribute 3");
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Location Code", rco_LocationCode );

    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Master Batch No.", lrc_BatchVariant."Master Batch No." );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Batch No.", lrc_BatchVariant."Batch No." );
    //                 lrc_FeatureAssortmentCustLine.VALIDATE( "Batch Variant No.", lrc_BatchVariant."No." );

    //                 lcu_BatchManagement.CalcStockBatchVar( lrc_BatchVariant."No.",
    //                                                        rco_LocationCode,
    //                                                        0.1,
    //                                                        ldc_Bestand,
    //                                                        ldc_BestandVerf,
    //                                                        ldc_ErwBestandVerf,
    //                                                        ldc_MgeInAuftrag,
    //                                                        ldc_MgeInBestellung,
    //                                                        ldc_MgeReserviertFV,
    //                                                        ldc_CustomerClearance,
    //                                                        ldc_Invoice,
    //                                                        ldc_Shipment,
    //                                                        ldc_PurchReceive,
    //                                                        1);
    //                 ldc_RemainingQuantity := 0;

    //                 lrc_FeatureAssortmentCustoPric.CALCFIELDS( "Assigned Quantity", "Assigned Quantity Order" );

    //                 ldc_RemainingQuantity :=
    //                    lrc_FeatureAssortmentCustoPric."Recorded Quantity" -
    //                    ( lrc_FeatureAssortmentCustoPric."Assigned Quantity" +
    //                      lrc_FeatureAssortmentCustoPric."Assigned Quantity Order" );

    //                 IF ( ldc_RemainingQuantity > 0 ) AND ( ldc_ErwBestandVerf > 0 ) THEN BEGIN
    //                     IF ldc_RemainingQuantity >= ldc_ErwBestandVerf THEN BEGIN
    //                        lrc_FeatureAssortmentCustLine.VALIDATE( Quantity, ldc_ErwBestandVerf );
    //                     END ELSE BEGIN
    //                        IF ldc_RemainingQuantity < ldc_ErwBestandVerf THEN BEGIN
    //                           lrc_FeatureAssortmentCustLine.VALIDATE( Quantity, ldc_RemainingQuantity );
    //                        END;
    //                     END;
    //                 END;

    //                 IF lrc_FeatureAssortmentCustLine.Quantity <> 0 THEN
    //                    lrc_FeatureAssortmentCustLine.INSERT( TRUE );
    //              END;

    //            UNTIL lrc_FeatureAssortmentCustoPric.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CalcSpektrumQuantityOutputLine(rco_PackOrder: Code[20];rin_PackOrderLineNo: Integer;var vrc_PackOrderOutputItems: Record "5110713")
    //     var
    //         lrc_BatchVariantPackingQuality: Record "5110367";
    //         lrc_BatchVarPackQualityCaliber: Record "5110486";
    //         lco_MinSpectrumCaliber: Code[10];
    //         lco_MaxSpectrumCaliber: Code[10];
    //         ldc_QuantityInSpectrum: Decimal;
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         ldc_PercentAGoods: Decimal;
    //         ldc_TotalQuantityBase: Decimal;
    //     begin
    //         lrc_PackOrderHeader.GET( rco_PackOrder );

    //         IF rin_PackOrderLineNo <> 0 THEN BEGIN
    //           // PAC 009 00000000.s
    //           // IF vrc_PackOrderOutputItems."Type of Packing Product" <>
    //           IF vrc_PackOrderOutputItems."Type of Packing Product" >
    //           // PAC 009 00000000.e
    //                                         vrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product" THEN
    //               EXIT;

    //            ldc_PercentAGoods := 100;
    //            ldc_TotalQuantityBase := 0;

    //               lrc_PackOrderInputItems.Reset();
    //               lrc_PackOrderInputItems.SETRANGE( "Doc. No.", rco_PackOrder );
    //               lrc_PackOrderInputItems.SETRANGE( "Production Line Code", vrc_PackOrderOutputItems."Production Line Code" );
    //               IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //                  REPEAT
    //                      lrc_BatchVariantPackingQuality.Reset();
    //                      lrc_BatchVariantPackingQuality.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                      lrc_BatchVariantPackingQuality.SETRANGE( "Batch No.", lrc_PackOrderInputItems."Batch No." );
    //                      IF ( lrc_BatchVariantPackingQuality.FIND('-') ) AND
    //                         ( lrc_BatchVariantPackingQuality."Quantity (Profed)" <> 0 ) THEN BEGIN

    //                         IF ( vrc_PackOrderOutputItems."Spectrum Caliber A-Goods" <> '' ) AND
    //                            ( lrc_PackOrderInputItems."Batch Variant No." <> '' ) AND
    //                            ( lrc_PackOrderInputItems."Batch No." <> '' ) THEN BEGIN


    //                            lrc_BatchVarPackQualityCaliber.Reset();
    //                            lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                            lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch No.", lrc_PackOrderInputItems."Batch No." );
    //                            lrc_BatchVarPackQualityCaliber.SETFILTER( "Caliber Code",
    //                                                                      vrc_PackOrderOutputItems."Spectrum Caliber A-Goods" );

    //                            lco_MinSpectrumCaliber := lrc_BatchVarPackQualityCaliber.GETRANGEMIN( "Caliber Code" );
    //                            lco_MaxSpectrumCaliber := lrc_BatchVarPackQualityCaliber.GETRANGEMAX( "Caliber Code" );

    //                            ldc_QuantityInSpectrum := 0;

    //                            lrc_BatchVarPackQualityCaliber.Reset();
    //                            lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                            lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch No.",
    //                               lrc_PackOrderInputItems."Batch No." );
    //                            IF lrc_BatchVarPackQualityCaliber.FIND('-') THEN BEGIN
    //                               REPEAT
    //                                   IF ( lco_MinSpectrumCaliber = '' ) AND ( lco_MaxSpectrumCaliber = '' ) THEN BEGIN
    //                                      ldc_QuantityInSpectrum :=  ldc_QuantityInSpectrum +
    //                                         lrc_BatchVarPackQualityCaliber."Quantity (Profed)";
    //                                   END ELSE BEGIN
    //                                      IF lrc_BatchVarPackQualityCaliber."Caliber Code" < lco_MinSpectrumCaliber THEN BEGIN
    //                                      END ELSE BEGIN
    //                                         IF lrc_BatchVarPackQualityCaliber."Caliber Code" > lco_MaxSpectrumCaliber THEN BEGIN
    //                                         END ELSE BEGIN
    //                                            ldc_QuantityInSpectrum :=  ldc_QuantityInSpectrum +
    //                                               lrc_BatchVarPackQualityCaliber."Quantity (Profed)";
    //                                         END;
    //                                      END;
    //                                   END;
    //                               UNTIL lrc_BatchVarPackQualityCaliber.NEXT() = 0;

    //                               ldc_PercentAGoods := ( ldc_QuantityInSpectrum / lrc_BatchVariantPackingQuality."Quantity (Profed)" ) * 100;

    //                               ldc_TotalQuantityBase := ldc_TotalQuantityBase +
    //                                                        ROUND( ( lrc_PackOrderInputItems."Quantity (Base)" / 100 ) * ldc_PercentAGoods,
    //                                                               0.00001 );

    //                            END ELSE BEGIN
    //                               ldc_TotalQuantityBase := ldc_TotalQuantityBase + lrc_PackOrderInputItems."Quantity (Base)";
    //                            END;

    //                         END ELSE BEGIN
    //                            ldc_TotalQuantityBase := ldc_TotalQuantityBase + lrc_PackOrderInputItems."Quantity (Base)";
    //                         END;
    //                      END ELSE BEGIN
    //                          ldc_TotalQuantityBase := ldc_TotalQuantityBase + lrc_PackOrderInputItems."Quantity (Base)"
    //                      END;
    //                  UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //               END;

    //               vrc_PackOrderOutputItems.VALIDATE( "Exp. Quantity (Base) Spectrum", ldc_TotalQuantityBase );
    //               vrc_PackOrderOutputItems.MODIFY( TRUE );

    //         END ELSE BEGIN
    //            lrc_PackOrderOutputItems.Reset();
    //            lrc_PackOrderOutputItems.SETRANGE( "Doc. No.", rco_PackOrder );
    //            // PAC 009 00000000.s
    //            // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //            //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //            lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                               lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //            // PAC 009 00000000.e
    //            IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //               REPEAT

    //                  ldc_PercentAGoods := 100;
    //                  ldc_TotalQuantityBase := 0;

    //                  lrc_PackOrderInputItems.Reset();
    //                  lrc_PackOrderInputItems.SETRANGE( "Doc. No.", rco_PackOrder );
    //                  lrc_PackOrderInputItems.SETRANGE( "Production Line Code", lrc_PackOrderOutputItems."Production Line Code" );
    //                  IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //                     REPEAT

    //                         lrc_BatchVariantPackingQuality.Reset();
    //                         lrc_BatchVariantPackingQuality.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                         lrc_BatchVariantPackingQuality.SETRANGE( "Batch No.", lrc_PackOrderInputItems."Batch No." );
    //                         IF ( lrc_BatchVariantPackingQuality.FIND('-') ) AND
    //                            ( lrc_BatchVariantPackingQuality."Quantity (Profed)" <> 0 ) THEN BEGIN

    //                            IF ( lrc_PackOrderOutputItems."Spectrum Caliber A-Goods" <> '' ) AND
    //                               ( lrc_PackOrderInputItems."Batch Variant No." <> '' ) AND
    //                               ( lrc_PackOrderInputItems."Batch No." <> '' ) THEN BEGIN


    //                               lrc_BatchVarPackQualityCaliber.Reset();
    //                               lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                               lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch No.", lrc_PackOrderInputItems."Batch No." );
    //                               lrc_BatchVarPackQualityCaliber.SETFILTER( "Caliber Code",
    //                                                                         lrc_PackOrderOutputItems."Spectrum Caliber A-Goods" );

    //                               lco_MinSpectrumCaliber := lrc_BatchVarPackQualityCaliber.GETRANGEMIN( "Caliber Code" );
    //                               lco_MaxSpectrumCaliber := lrc_BatchVarPackQualityCaliber.GETRANGEMAX( "Caliber Code" );

    //                               ldc_QuantityInSpectrum := 0;

    //                               lrc_BatchVarPackQualityCaliber.Reset();
    //                               lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                               lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch No.",
    //                                  lrc_PackOrderInputItems."Batch No." );
    //                               IF lrc_BatchVarPackQualityCaliber.FIND('-') THEN BEGIN
    //                                  REPEAT
    //                                      IF ( lco_MinSpectrumCaliber = '' ) AND ( lco_MaxSpectrumCaliber = '' ) THEN BEGIN
    //                                         ldc_QuantityInSpectrum :=  ldc_QuantityInSpectrum +
    //                                            lrc_BatchVarPackQualityCaliber."Quantity (Profed)";
    //                                      END ELSE BEGIN
    //                                         IF lrc_BatchVarPackQualityCaliber."Caliber Code" < lco_MinSpectrumCaliber THEN BEGIN
    //                                         END ELSE BEGIN
    //                                            IF lrc_BatchVarPackQualityCaliber."Caliber Code" > lco_MaxSpectrumCaliber THEN BEGIN
    //                                            END ELSE BEGIN
    //                                               ldc_QuantityInSpectrum :=  ldc_QuantityInSpectrum +
    //                                                  lrc_BatchVarPackQualityCaliber."Quantity (Profed)";
    //                                            END;
    //                                         END;
    //                                      END;
    //                                  UNTIL lrc_BatchVarPackQualityCaliber.NEXT() = 0;

    //                                  ldc_PercentAGoods := (ldc_QuantityInSpectrum /
    //                                                        lrc_BatchVariantPackingQuality."Quantity (Profed)") * 100;

    //                                  ldc_TotalQuantityBase := ldc_TotalQuantityBase +
    //                                                           ROUND((lrc_PackOrderInputItems."Quantity (Base)" / 100 ) *
    //                                                                 ldc_PercentAGoods, 0.00001 );

    //                               END ELSE BEGIN
    //                                  ldc_TotalQuantityBase := ldc_TotalQuantityBase + lrc_PackOrderInputItems."Quantity (Base)";
    //                               END;

    //                            END ELSE BEGIN
    //                               ldc_TotalQuantityBase := ldc_TotalQuantityBase + lrc_PackOrderInputItems."Quantity (Base)";
    //                            END;
    //                         END ELSE BEGIN
    //                             ldc_TotalQuantityBase := ldc_TotalQuantityBase + lrc_PackOrderInputItems."Quantity (Base)";
    //                         END;
    //                     UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //                  END;

    //                  lrc_PackOrderOutputItems.VALIDATE( "Exp. Quantity (Base) Spectrum", ldc_TotalQuantityBase );
    //                  lrc_PackOrderOutputItems.MODIFY( TRUE );

    //               UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //            END;
    //         END;
    //     end;

    //     procedure CalcSpektrumQuantityInputLine(rbn_ActualRecord: Boolean;rco_PackOrder: Code[20];var vrc_PackOrderInputItems: Record "5110714";var vco_ProductionLines: array [100] of Code[10];var vdc_OutputQuantityBase: array [100] of Decimal;var vdc_OutputRemainingQuantitBase: array [100] of Decimal;var vdc_InputQuantityBase: array [100] of Decimal;var vdc_InputRemainingQuantitBase: array [100] of Decimal)
    //     var
    //         lrc_BatchVariantPackingQuality: Record "5110367";
    //         lrc_BatchVarPackQualityCaliber: Record "5110486";
    //         lco_MinSpectrumCaliber: Code[10];
    //         lco_MaxSpectrumCaliber: Code[10];
    //         ldc_QuantityInSpectrum: Decimal;
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         ldc_PercentAGoods: Decimal;
    //         lrc_OutputTotalBuffer: Record "332" temporary;
    //         lrc_InputTotalBuffer: Record "332" temporary;
    //         lin_Counter: Integer;
    //         "-- KDK 002 00000000": Integer;
    //         lbn_ShowQtyInBaseQty: Boolean;
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         lrc_PackOrderHeader.GET( rco_PackOrder );

    //         // KDK 002 00000000.s
    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //           lbn_ShowQtyInBaseQty := FALSE;
    //         END ELSE BEGIN
    //           lbn_ShowQtyInBaseQty := TRUE;
    //         END;
    //         // KDK 002 00000000.e

    //         CLEAR( vdc_OutputQuantityBase );
    //         CLEAR( vdc_OutputRemainingQuantitBase );
    //         CLEAR( vdc_InputQuantityBase );
    //         CLEAR( vdc_InputRemainingQuantitBase );

    //         CLEAR( lrc_OutputTotalBuffer );
    //         CLEAR( lrc_InputTotalBuffer );
    //         lin_Counter := 0;

    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETCURRENTKEY( "Type of Packing Product","Item No." );
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         // IF lrc_PackOrderHeader."Item No." <> '' THEN BEGIN
    //         //   lrc_PackOrderOutputItems.SETRANGE( "Item No.", lrc_PackOrderHeader."Item No." );
    //         // END;
    //         lrc_PackOrderOutputItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //            REPEAT

    //                IF lrc_PackOrderOutputItems."Production Line Code" = '' THEN BEGIN
    //                   lrc_OutputTotalBuffer.SETRANGE( "Currency Code", '          ' );
    //                   IF NOT lrc_OutputTotalBuffer.FIND('-') THEN BEGIN
    //                      lrc_OutputTotalBuffer.INIT();
    //                      lrc_OutputTotalBuffer."Currency Code" := '          ';
    //                      lin_Counter := lin_Counter + 1;
    //                      lrc_OutputTotalBuffer.Counter := lin_Counter;
    //                      lrc_OutputTotalBuffer.INSERT( TRUE );
    //                   END ELSE BEGIN
    //                      lin_Counter := lrc_OutputTotalBuffer.Counter;
    //                   END;
    //                   lrc_InputTotalBuffer.SETRANGE( "Currency Code", '          ' );
    //                   IF NOT lrc_InputTotalBuffer.FIND('-') THEN BEGIN
    //                      lrc_InputTotalBuffer.INIT();
    //                      lrc_InputTotalBuffer."Currency Code" := '          ';
    //                      lrc_InputTotalBuffer.Counter := lin_Counter;
    //                      lrc_InputTotalBuffer.INSERT( TRUE );
    //                   END;
    //                END ELSE BEGIN
    //                   lrc_OutputTotalBuffer.SETRANGE( "Currency Code", lrc_PackOrderOutputItems."Production Line Code" );
    //                   IF NOT lrc_OutputTotalBuffer.FIND('-') THEN BEGIN
    //                      lrc_OutputTotalBuffer.INIT();
    //                      lrc_OutputTotalBuffer."Currency Code" := lrc_PackOrderOutputItems."Production Line Code";
    //                      lin_Counter := lin_Counter + 1;
    //                      lrc_OutputTotalBuffer.Counter := lin_Counter;
    //                      lrc_OutputTotalBuffer.INSERT( TRUE );
    //                   END ELSE BEGIN
    //                      lin_Counter := lrc_OutputTotalBuffer.Counter;
    //                   END;
    //                   lrc_InputTotalBuffer.SETRANGE( "Currency Code", lrc_PackOrderOutputItems."Production Line Code" );
    //                   IF NOT lrc_InputTotalBuffer.FIND('-') THEN BEGIN
    //                      lrc_InputTotalBuffer.INIT();
    //                      lrc_InputTotalBuffer."Currency Code" := lrc_PackOrderOutputItems."Production Line Code";
    //                      lrc_InputTotalBuffer.Counter := lin_Counter;
    //                      lrc_InputTotalBuffer.INSERT( TRUE );
    //                   END;
    //                END;

    //                // KDK 002 00000000.s
    //                IF lbn_ShowQtyInBaseQty = TRUE THEN BEGIN
    //                // KDK 002 00000000.e
    //                  lrc_OutputTotalBuffer."Total Amount" :=
    //                    lrc_OutputTotalBuffer."Total Amount" + lrc_PackOrderOutputItems."Quantity (Base)";
    //                  lrc_OutputTotalBuffer."Total Amount (LCY)" :=
    //                    lrc_OutputTotalBuffer."Total Amount (LCY)" + lrc_PackOrderOutputItems."Remaining Quantity (Base)";
    //                  lrc_OutputTotalBuffer.MODIFY( TRUE );
    //                // KDK 002 00000000.s
    //                END ELSE BEGIN
    //                  lrc_OutputTotalBuffer."Total Amount" :=
    //                    lrc_OutputTotalBuffer."Total Amount" + lrc_PackOrderOutputItems.Quantity;
    //                  lrc_OutputTotalBuffer."Total Amount (LCY)" :=
    //                    lrc_OutputTotalBuffer."Total Amount (LCY)" + lrc_PackOrderOutputItems."Remaining Quantity";
    //                  lrc_OutputTotalBuffer.MODIFY( TRUE );
    //                END;
    //                // KDK 002 00000000.e
    //            UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //         END;

    //         ldc_PercentAGoods := 100;

    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE( "Doc. No.", rco_PackOrder );
    //         IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //            REPEAT

    //                IF lrc_PackOrderInputItems."Production Line Code" = '' THEN BEGIN
    //                   lrc_OutputTotalBuffer.SETRANGE( "Currency Code", '          ' );
    //                   IF NOT lrc_OutputTotalBuffer.FIND('-') THEN BEGIN
    //                      lrc_OutputTotalBuffer.INIT();
    //                      lrc_OutputTotalBuffer."Currency Code" := '          ';
    //                      lin_Counter := lin_Counter + 1;
    //                      lrc_OutputTotalBuffer.Counter := lin_Counter;
    //                      lrc_OutputTotalBuffer.INSERT( TRUE );
    //                   END ELSE BEGIN
    //                      lin_Counter := lrc_OutputTotalBuffer.Counter;
    //                   END;
    //                   lrc_InputTotalBuffer.SETRANGE( "Currency Code", '          ' );
    //                   IF NOT lrc_InputTotalBuffer.FIND('-') THEN BEGIN
    //                      lrc_InputTotalBuffer.INIT();
    //                      lrc_InputTotalBuffer."Currency Code" := '          ';
    //                      lrc_InputTotalBuffer.Counter := lin_Counter;
    //                      lrc_InputTotalBuffer.INSERT( TRUE );
    //                   END;
    //                END ELSE BEGIN
    //                   lrc_OutputTotalBuffer.SETRANGE( "Currency Code", lrc_PackOrderInputItems."Production Line Code" );
    //                   IF NOT lrc_OutputTotalBuffer.FIND('-') THEN BEGIN
    //                      lrc_OutputTotalBuffer.INIT();
    //                      lrc_OutputTotalBuffer."Currency Code" := lrc_PackOrderInputItems."Production Line Code";
    //                      lin_Counter := lin_Counter + 1;
    //                      lrc_OutputTotalBuffer.Counter := lin_Counter;
    //                      lrc_OutputTotalBuffer.INSERT( TRUE );
    //                   END ELSE BEGIN
    //                      lin_Counter := lrc_OutputTotalBuffer.Counter;
    //                   END;
    //                   lrc_InputTotalBuffer.SETRANGE( "Currency Code", lrc_PackOrderInputItems."Production Line Code" );
    //                   IF NOT lrc_InputTotalBuffer.FIND('-') THEN BEGIN
    //                      lrc_InputTotalBuffer.INIT();
    //                      lrc_InputTotalBuffer."Currency Code" := lrc_PackOrderInputItems."Production Line Code";
    //                      lrc_InputTotalBuffer.Counter := lin_Counter;
    //                      lrc_InputTotalBuffer.INSERT( TRUE );
    //                   END;
    //                END;

    //                lrc_BatchVariantPackingQuality.Reset();
    //                lrc_BatchVariantPackingQuality.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                lrc_BatchVariantPackingQuality.SETRANGE( "Batch No.", lrc_PackOrderInputItems."Batch No." );
    //                IF ( lrc_BatchVariantPackingQuality.FIND('-') ) AND
    //                   ( lrc_BatchVariantPackingQuality."Quantity (Profed)" <> 0 ) THEN BEGIN
    //                   IF ( lrc_PackOrderInputItems."Spectrum Caliber A-Goods" <> '' ) AND
    //                      ( lrc_PackOrderInputItems."Batch Variant No." <> '' ) AND
    //                      ( lrc_PackOrderInputItems."Batch No." <> '' ) THEN BEGIN

    //                      lrc_BatchVarPackQualityCaliber.Reset();
    //                      lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                      lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch No.", lrc_PackOrderInputItems."Batch No." );
    //                      lrc_BatchVarPackQualityCaliber.SETFILTER( "Caliber Code",
    //                                                                lrc_PackOrderInputItems."Spectrum Caliber A-Goods" );

    //                      lco_MinSpectrumCaliber := lrc_BatchVarPackQualityCaliber.GETRANGEMIN( "Caliber Code" );
    //                      lco_MaxSpectrumCaliber := lrc_BatchVarPackQualityCaliber.GETRANGEMAX( "Caliber Code" );

    //                      ldc_QuantityInSpectrum := 0;

    //                      lrc_BatchVarPackQualityCaliber.Reset();
    //                      lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch Variant No.", lrc_PackOrderInputItems."Batch Variant No." );
    //                      lrc_BatchVarPackQualityCaliber.SETRANGE( "Batch No.",
    //                                                               lrc_PackOrderInputItems."Batch No." );
    //                      IF lrc_BatchVarPackQualityCaliber.FIND('-') THEN BEGIN
    //                         REPEAT
    //                             IF ( lco_MinSpectrumCaliber = '' ) AND ( lco_MaxSpectrumCaliber = '' ) THEN BEGIN
    //                                ldc_QuantityInSpectrum :=  ldc_QuantityInSpectrum +
    //                                   lrc_BatchVarPackQualityCaliber."Quantity (Profed)";
    //                             END ELSE BEGIN
    //                                IF lrc_BatchVarPackQualityCaliber."Caliber Code" < lco_MinSpectrumCaliber THEN BEGIN
    //                                END ELSE BEGIN
    //                                   IF lrc_BatchVarPackQualityCaliber."Caliber Code" > lco_MaxSpectrumCaliber THEN BEGIN
    //                                   END ELSE BEGIN
    //                                      ldc_QuantityInSpectrum :=  ldc_QuantityInSpectrum +
    //                                         lrc_BatchVarPackQualityCaliber."Quantity (Profed)";
    //                                   END;
    //                                END;
    //                             END;
    //                         UNTIL lrc_BatchVarPackQualityCaliber.NEXT() = 0;

    //                         ldc_PercentAGoods := ( ldc_QuantityInSpectrum / lrc_BatchVariantPackingQuality."Quantity (Profed)" ) * 100;

    //                         lrc_InputTotalBuffer."Total Amount" :=
    //                            lrc_InputTotalBuffer."Total Amount" +
    //                                ROUND( ( lrc_PackOrderInputItems."Quantity (Base)" / 100 ) * ldc_PercentAGoods,
    //                                                         0.00001 );
    //                         lrc_InputTotalBuffer."Total Amount (LCY)" :=
    //                           lrc_InputTotalBuffer."Total Amount (LCY)" +
    //                                ROUND( ( lrc_PackOrderInputItems."Remaining Quantity (Base)" / 100 ) * ldc_PercentAGoods,
    //                                                         0.00001 );
    //                         lrc_InputTotalBuffer.Counter := lin_Counter;
    //                         lrc_InputTotalBuffer.MODIFY( TRUE );

    //                         IF rbn_ActualRecord = TRUE THEN BEGIN
    //                            IF ( vrc_PackOrderInputItems."Doc. No." = lrc_PackOrderInputItems."Doc. No." ) AND
    //                               ( vrc_PackOrderInputItems."Doc. Line No. Output" = lrc_PackOrderInputItems."Doc. Line No. Output" ) AND
    //                               ( vrc_PackOrderInputItems."Line No." = lrc_PackOrderInputItems."Line No." ) THEN BEGIN
    //                               vrc_PackOrderInputItems."A-Goods Factor %" :=  ldc_PercentAGoods;
    //                               vrc_PackOrderInputItems.VALIDATE( "Qty. per Unit of Measure" );
    //                               vrc_PackOrderInputItems.MODIFY( TRUE );
    //                            END ELSE BEGIN
    //                               lrc_PackOrderInputItems."A-Goods Factor %" :=  ldc_PercentAGoods;
    //                               lrc_PackOrderInputItems.VALIDATE( "Qty. per Unit of Measure" );
    //                               lrc_PackOrderInputItems.MODIFY( TRUE );
    //                            END;
    //                         END;
    //                      END ELSE BEGIN
    //                         lrc_InputTotalBuffer."Total Amount" :=
    //                            lrc_InputTotalBuffer."Total Amount" + lrc_PackOrderInputItems."Quantity (Base)";
    //                         lrc_InputTotalBuffer."Total Amount (LCY)" :=
    //                           lrc_InputTotalBuffer."Total Amount (LCY)" + lrc_PackOrderInputItems."Remaining Quantity (Base)";
    //                         lrc_InputTotalBuffer.MODIFY( TRUE );

    //                         IF rbn_ActualRecord = TRUE THEN BEGIN
    //                            IF ( vrc_PackOrderInputItems."Doc. No." = lrc_PackOrderInputItems."Doc. No." ) AND
    //                               ( vrc_PackOrderInputItems."Doc. Line No. Output" = lrc_PackOrderInputItems."Doc. Line No. Output" ) AND
    //                               ( vrc_PackOrderInputItems."Line No." = lrc_PackOrderInputItems."Line No." ) THEN BEGIN
    //                               vrc_PackOrderInputItems."A-Goods Factor %" := 0;
    //                               vrc_PackOrderInputItems.VALIDATE( "Qty. per Unit of Measure" );
    //                               vrc_PackOrderInputItems.MODIFY( TRUE );
    //                            END ELSE BEGIN
    //                               lrc_PackOrderInputItems."A-Goods Factor %" := 0;
    //                               lrc_PackOrderInputItems.VALIDATE( "Qty. per Unit of Measure" );
    //                               lrc_PackOrderInputItems.MODIFY( TRUE );
    //                            END;
    //                         END;
    //                      END;

    //                   END ELSE BEGIN
    //                      lrc_InputTotalBuffer."Total Amount" :=
    //                         lrc_InputTotalBuffer."Total Amount" + lrc_PackOrderInputItems."Quantity (Base)";
    //                      lrc_InputTotalBuffer."Total Amount (LCY)" :=
    //                        lrc_InputTotalBuffer."Total Amount (LCY)" + lrc_PackOrderInputItems."Remaining Quantity (Base)";
    //                      lrc_InputTotalBuffer.MODIFY( TRUE );

    //                      IF rbn_ActualRecord = TRUE THEN BEGIN
    //                         IF ( vrc_PackOrderInputItems."Doc. No." = lrc_PackOrderInputItems."Doc. No." ) AND
    //                            ( vrc_PackOrderInputItems."Doc. Line No. Output" = lrc_PackOrderInputItems."Doc. Line No. Output" ) AND
    //                            ( vrc_PackOrderInputItems."Line No." = lrc_PackOrderInputItems."Line No." ) THEN BEGIN
    //                            vrc_PackOrderInputItems."A-Goods Factor %" := 0;
    //                            vrc_PackOrderInputItems.VALIDATE( "Qty. per Unit of Measure" );
    //                            vrc_PackOrderInputItems.MODIFY( TRUE );
    //                         END ELSE BEGIN
    //                            lrc_PackOrderInputItems."A-Goods Factor %" := 0;
    //                            lrc_PackOrderInputItems.VALIDATE( "Qty. per Unit of Measure" );
    //                            lrc_PackOrderInputItems.MODIFY( TRUE );
    //                         END;
    //                      END;
    //                   END;
    //                END ELSE BEGIN
    //                   // KDK 002 00000000.s
    //                   IF lbn_ShowQtyInBaseQty = TRUE THEN BEGIN
    //                   // KDK 002 00000000.e
    //                      lrc_InputTotalBuffer."Total Amount" :=
    //                         lrc_InputTotalBuffer."Total Amount" + lrc_PackOrderInputItems."Quantity (Base)";
    //                      lrc_InputTotalBuffer."Total Amount (LCY)" :=
    //                        lrc_InputTotalBuffer."Total Amount (LCY)" + lrc_PackOrderInputItems."Remaining Quantity (Base)";
    //                   // KDK 002 00000000.s
    //                   END ELSE BEGIN
    //                      lrc_InputTotalBuffer."Total Amount" :=
    //                         lrc_InputTotalBuffer."Total Amount" + lrc_PackOrderInputItems.Quantity;
    //                      lrc_InputTotalBuffer."Total Amount (LCY)" :=
    //                        lrc_InputTotalBuffer."Total Amount (LCY)" + lrc_PackOrderInputItems."Remaining Quantity";
    //                   END;
    //                   // KDK 002 00000000.e
    //                   lrc_InputTotalBuffer.MODIFY( TRUE );

    //                   IF rbn_ActualRecord = TRUE THEN BEGIN
    //                      IF ( vrc_PackOrderInputItems."Doc. No." = lrc_PackOrderInputItems."Doc. No." ) AND
    //                         ( vrc_PackOrderInputItems."Doc. Line No. Output" = lrc_PackOrderInputItems."Doc. Line No. Output" ) AND
    //                         ( vrc_PackOrderInputItems."Line No." = lrc_PackOrderInputItems."Line No." ) THEN BEGIN
    //                         vrc_PackOrderInputItems."A-Goods Factor %" := 0;
    //                         vrc_PackOrderInputItems.VALIDATE( "Qty. per Unit of Measure" );
    //                         vrc_PackOrderInputItems.MODIFY( TRUE );
    //                      END ELSE BEGIN
    //                         lrc_PackOrderInputItems."A-Goods Factor %" := 0;
    //                         lrc_PackOrderInputItems.VALIDATE( "Qty. per Unit of Measure" );
    //                         lrc_PackOrderInputItems.MODIFY( TRUE );
    //                      END;
    //                   END;
    //                END;

    //            UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //         END;

    //         lrc_OutputTotalBuffer.Reset();
    //         lrc_InputTotalBuffer.Reset();
    //         lin_Counter := 0;

    //         IF lrc_OutputTotalBuffer.FIND('-') THEN BEGIN
    //            REPEAT
    //               lin_Counter := lin_Counter + 1;

    //               lrc_InputTotalBuffer.SETRANGE( "Currency Code", lrc_OutputTotalBuffer."Currency Code" );
    //               lrc_InputTotalBuffer.FIND('-');

    //               vco_ProductionLines[lin_Counter] := lrc_OutputTotalBuffer."Currency Code";
    //               vdc_OutputQuantityBase[lin_Counter] := lrc_OutputTotalBuffer."Total Amount";
    //               vdc_OutputRemainingQuantitBase[lin_Counter] := lrc_OutputTotalBuffer."Total Amount (LCY)";
    //               vdc_InputQuantityBase[lin_Counter] := lrc_InputTotalBuffer."Total Amount";
    //               vdc_InputRemainingQuantitBase[lin_Counter] := lrc_InputTotalBuffer."Total Amount (LCY)";

    //               vdc_OutputQuantityBase[100] := vdc_OutputQuantityBase[100] +  lrc_OutputTotalBuffer."Total Amount";
    //               vdc_OutputRemainingQuantitBase[100] := vdc_OutputRemainingQuantitBase[100] +  lrc_OutputTotalBuffer."Total Amount (LCY)";
    //               vdc_InputQuantityBase[100] := vdc_InputQuantityBase[100] + lrc_InputTotalBuffer."Total Amount";
    //               vdc_InputRemainingQuantitBase[100] := vdc_InputRemainingQuantitBase[100] + lrc_InputTotalBuffer."Total Amount (LCY)";

    //            UNTIL lrc_OutputTotalBuffer.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CheckExistingPaProductionLine(rco_PackingOrderNo: Code[20];rco_ProductionLine: Code[10])
    //     var
    //         lrc_PackOrderProductionLines: Record "5110720";
    //         lin_NextLineNo: Integer;
    //     begin
    //         IF rco_ProductionLine = '' THEN
    //            EXIT;
    //         lrc_PackOrderProductionLines.SETCURRENTKEY( "Production Line Code" );
    //         lrc_PackOrderProductionLines.SETRANGE( "Doc. No.", rco_PackingOrderNo );
    //         lrc_PackOrderProductionLines.SETRANGE( "Production Line Code", rco_ProductionLine );
    //         IF NOT lrc_PackOrderProductionLines.FIND('-') THEN BEGIN
    //            lin_NextLineNo := 0;
    //            lrc_PackOrderProductionLines.Reset();
    //            lrc_PackOrderProductionLines.SETRANGE( "Doc. No.", rco_PackingOrderNo );
    //            IF lrc_PackOrderProductionLines.FIND('+') THEN BEGIN
    //               lin_NextLineNo := lrc_PackOrderProductionLines."Line No.";
    //            END;

    //            lin_NextLineNo := lin_NextLineNo + 10000;

    //            lrc_PackOrderProductionLines.Reset();
    //            lrc_PackOrderProductionLines.INIT();
    //            lrc_PackOrderProductionLines.VALIDATE( "Doc. No.", rco_PackingOrderNo );
    //            lrc_PackOrderProductionLines.VALIDATE( "Line No.", lin_NextLineNo );
    //            lrc_PackOrderProductionLines.VALIDATE( "Production Line Code", rco_ProductionLine );
    //            lrc_PackOrderProductionLines.INSERT( TRUE );

    //         END;
    //     end;

    //     procedure "-- ABRECHNUNG --"()
    //     begin
    //     end;

    //     procedure PackCalcStatement(vco_PackOrderNo: Code[20];rbn_ConFirm: Boolean)
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         ldc_ProzSatz: Decimal;
    //         "-- Agiles KDK 001": Integer;
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_PackOrderCosts: Record "5110716";
    //     begin
    //         // -------------------------------------------------------------------------------
    //         // Funktion zur Erstellung der Packerei-Abrechnung
    //         // -------------------------------------------------------------------------------

    //         // Packerei Kopfsatz lesen
    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);

    //         // Leere Zeilen löschen
    //         PackDeleteEmptyLines(vco_PackOrderNo);

    //         // Prozentuale Input Anteile berechnen
    //         CalcInputPercentages(vco_PackOrderNo);

    //         // Packereierlöse berechnen
    //         PackCalcRevenues(vco_PackOrderNo);
    //         COMMIT;


    //         // Packereierlöse auf die Input Positionen umlegen
    //         CalcRevPerBatchPerPostingDate(vco_PackOrderNo);

    //         // Kosten kalkulieren
    //         lrc_FruitVisionSetup.GET();
    //         // SCA 014 DMG50061.s
    //         IF GUIALLOWED THEN BEGIN
    //           PackCalcCosts(vco_PackOrderNo,rbn_ConFirm);
    //         END ELSE BEGIN
    //           PackCalcCosts(vco_PackOrderNo,FALSE);
    //         END;
    //         // SCA 014 DMG50061.e
    //         COMMIT;

    //         // Kosten auf die Output Zeilen verteilen
    //         AllocateCostToOutputLines(vco_PackOrderNo);
    //         COMMIT;

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         lrc_PackOrderHeader.CALCFIELDS("Tot. Net Weight Input","Tot. Net Weight Inp. (Revenue)",
    //                                        "Tot. Net Weight Output",
    //                                        "Tot. Sales Net Amount (LCY)","Tot. Calc. Costs",
    //                                        "Tot. Posted Costs","Tot. Acc. Costs");

    //         // Nettoerlöse aus Verkäufen
    //         // Kalk. Kosten
    //         // Gebuchte Kosten
    //         // Reinerlös = Nettoerlöse aus Verkäufen abzüglich der Kalk. Kosten ODER gebuchten Kosten
    //         // Schwund = Gesamtkilo Input - Gesamtkilo Output
    //         lrc_PackOrderHeader."Tot. Loss (n.w.)" := lrc_PackOrderHeader."Tot. Net Weight Input" -
    //                                                   lrc_PackOrderHeader."Tot. Net Weight Output";
    //         // Prozentualer Schwund
    //         IF lrc_PackOrderHeader."Tot. Net Weight Input" <> 0 THEN
    //           lrc_PackOrderHeader."Tot. Loss Perc. (n.w.)" := (lrc_PackOrderHeader."Tot. Loss (n.w.)" /
    //                                                            lrc_PackOrderHeader."Tot. Net Weight Input" * 100)
    //         ELSE
    //           lrc_PackOrderHeader."Tot. Loss Perc. (n.w.)" := 0;


    //         CASE lrc_PackOrderHeader."Result Based on" OF
    //         lrc_PackOrderHeader."Result Based on"::"Cost Calculation":
    //           lrc_PackOrderHeader."Total Amount Result" := lrc_PackOrderHeader."Tot. Sales Net Amount (LCY)" -
    //                                                        lrc_PackOrderHeader."Tot. Calc. Costs";
    //         lrc_PackOrderHeader."Result Based on"::"Posted Cost":
    //           lrc_PackOrderHeader."Total Amount Result" := lrc_PackOrderHeader."Tot. Sales Net Amount (LCY)" -
    //                                                        lrc_PackOrderHeader."Tot. Posted Costs";
    //         lrc_PackOrderHeader."Result Based on"::"Settled Cost":
    //           lrc_PackOrderHeader."Total Amount Result" := lrc_PackOrderHeader."Tot. Sales Net Amount (LCY)" -
    //                                                        lrc_PackOrderHeader."Tot. Acc. Costs";
    //         END;
    //         lrc_PackOrderHeader.Modify();


    //         // ------------------------------------------------------------------------------
    //         // Verteilung auf die Inputzeilen nach Gewicht
    //         // ------------------------------------------------------------------------------
    //         IF lrc_PackOrderHeader."Tot. Net Weight Input" <> 0 THEN BEGIN

    //           lrc_PackOrderInputItems.Reset();
    //           lrc_PackOrderInputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //           IF lrc_PackOrderInputItems.FIND('-') THEN
    //             REPEAT

    //               // Umsatz auf die Inputzeilen verteilen die auch Umsatz bekommen sollen
    //               IF lrc_PackOrderInputItems."No Revenue" = FALSE THEN BEGIN
    //                 lrc_PackOrderInputItems.TESTFIELD("Perc. Qty. with Revenue");
    //                 //180216 rs
    //                 //ldc_ProzSatz := ROUND(lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100,0.00001);
    //                 IF NOT lrc_PackOrderInputItems."Manual Revenue Input" THEN
    //                   ldc_ProzSatz := ROUND(lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100,0.00001)
    //                 ELSE
    //                   ldc_ProzSatz := ROUND(lrc_PackOrderInputItems."Manual Revenue Factor" / 100,0.00001);
    //                 //180216 rs.e
    //                 //180302 rs Kostenaufteilung wenn Kosten direkt einer Position zugeordnet
    //                 lrc_PackOrderCosts.SETRANGE("Doc. No.", lrc_PackOrderHeader."No.");
    //                 lrc_PackOrderCosts.SETRANGE("Kosten auf Inputposition", TRUE);
    //                 IF NOT lrc_PackOrderCosts.FINDFIRST() THEN BEGIN
    //                   lrc_PackOrderInputItems."Calc. Revenue Amount" :=
    //                                           ROUND(lrc_PackOrderHeader."Total Amount Result" * ldc_ProzSatz,0.01);
    //                 END ELSE BEGIN
    //                   lrc_PackOrderInputItems."Calc. Revenue Amount" :=
    //                                           ROUND(lrc_PackOrderHeader."Tot. Sales Net Amount (LCY)" *  ldc_ProzSatz,0.01);

    //                   lrc_PackOrderCosts.SETRANGE("Doc. Line No. Input", lrc_PackOrderInputItems."Line No.");
    //                   IF lrc_PackOrderCosts.FINDSET(FALSE, FALSE) THEN
    //                     REPEAT
    //                       lrc_PackOrderInputItems."Calc. Revenue Amount" -= lrc_PackOrderCosts."Amount (LCY)";
    //                     UNTIL lrc_PackOrderCosts.NEXT() = 0;
    //                   lrc_PackOrderCosts.SETRANGE("Doc. Line No. Input");
    //                   lrc_PackOrderCosts.SETRANGE("Kosten auf Inputposition", FALSE);
    //                   IF lrc_PackOrderCosts.FINDSET(FALSE, FALSE) THEN
    //                     REPEAT
    //                       lrc_PackOrderInputItems."Calc. Revenue Amount" -= ROUND(lrc_PackOrderCosts."Amount (LCY)" *
    //                                                                         lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100,0.00001);
    //                     UNTIL lrc_PackOrderCosts.NEXT=0;

    //                 END;

    //                 lrc_PackOrderInputItems."Calc. Revenue per Unit" :=
    //                                         ROUND(lrc_PackOrderInputItems."Calc. Revenue Amount" /
    //                                               lrc_PackOrderInputItems.Quantity,0.00001);

    //                 // Umsatz nur setzen wenn nicht manuell eingegeben
    //                 //180216 rs
    //                 //IF lrc_PackOrderInputItems."Manual Revenue Input" = FALSE THEN BEGIN
    //                 lrc_PackOrderInputItems."Revenue per Unit" := lrc_PackOrderInputItems."Calc. Revenue per Unit";
    //                 lrc_PackOrderInputItems."Revenue Amount" := lrc_PackOrderInputItems."Calc. Revenue Amount";
    //                 //END;
    //               END ELSE BEGIN
    //                 lrc_PackOrderInputItems."Calc. Revenue per Unit" := 0;
    //                 lrc_PackOrderInputItems."Calc. Revenue Amount" := 0;
    //                 lrc_PackOrderInputItems."Revenue per Unit" := 0;
    //                 lrc_PackOrderInputItems."Revenue Amount" := 0;
    //               END;

    //               // Kosten auf alle Inputzeilen verteilen
    //               ldc_ProzSatz := ROUND(lrc_PackOrderInputItems."Perc. Total Qty." / 100,0.00001);
    //               CASE lrc_PackOrderHeader."Result Based on" OF
    //               lrc_PackOrderHeader."Result Based on"::"Cost Calculation":
    //                 lrc_PackOrderInputItems."Calculatory Costs per Unit" := ROUND(
    //                                              (lrc_PackOrderHeader."Tot. Calc. Costs" * ldc_ProzSatz) /
    //                                               lrc_PackOrderInputItems.Quantity,0.00001);
    //               lrc_PackOrderHeader."Result Based on"::"Posted Cost":
    //                 lrc_PackOrderInputItems."Calculatory Costs per Unit" := ROUND(
    //                                              (lrc_PackOrderHeader."Tot. Posted Costs" * ldc_ProzSatz) /
    //                                               lrc_PackOrderInputItems.Quantity,0.00001);
    //               lrc_PackOrderHeader."Result Based on"::"Settled Cost":
    //                 lrc_PackOrderInputItems."Calculatory Costs per Unit" := ROUND(
    //                                              (lrc_PackOrderHeader."Tot. Acc. Costs" * ldc_ProzSatz) /
    //                                               lrc_PackOrderInputItems.Quantity,0.00001);
    //               END;

    //               lrc_PackOrderInputItems."Calculatory Cost Amount" := ROUND(lrc_PackOrderInputItems."Calculatory Costs per Unit" *
    //                                                                          lrc_PackOrderInputItems.Quantity,0.01);
    //               // Kosten nur setzen wenn nicht manuell eingegeben
    //               IF lrc_PackOrderInputItems."Manual Cost Input" = FALSE THEN BEGIN
    //                 lrc_PackOrderInputItems."Costs per Unit" := lrc_PackOrderInputItems."Calculatory Costs per Unit";
    //                 lrc_PackOrderInputItems."Cost Amount" := lrc_PackOrderInputItems."Calculatory Cost Amount";
    //               END;

    //               lrc_PackOrderInputItems.Modify();
    //             UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //         END;
    //         COMMIT;


    //         // Tabelle für Packkostenkontrolle füllen
    //         PackCostsToCostControl(vco_PackOrderNo);
    //     end;

    //     procedure PackCalcRevenues(vco_PackOrderNo: Code[20])
    //     var
    //         lcu_BatchMgt: Codeunit "5110307";
    //         lcu_DSDFunktion: Codeunit "5087901";
    //         lrc_PackOrderRevenues: Record "5110717";
    //         lrc_PackOrderRevPerInpBatch: Record "5110726";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderHeader2: Record "5110712";
    //         lrc_BatchVariantEntry: Record "5110368";
    //         lrc_BatchVariantDetail: Record "5110487";
    //         lrc_ItemLedgerEntry: Record "32";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesShipmentHeader: Record "110";
    //         lrc_Customer: Record "Customer";
    //         lrc_UnitOfMeasure: Record "204";
    //         lrc_FreightOrderDetailLine: Record "5110440";
    //         ldc_SummeBetragBrutto: Decimal;
    //         ldc_SummeBetragNetto: Decimal;
    //         ldc_SummeBetragNettoNetto: Decimal;
    //         ldc_SummeRabatt: Decimal;
    //         ldc_SummeDSDARA: Decimal;
    //         ldc_SummeFrachtkosten: Decimal;
    //         ldc_SummeMenge: Decimal;
    //         "-": Integer;
    //         ldc_TotalTurnover: Decimal;
    //         lrc_SalesShipmentLine: Record "111";
    //         "--rs": Integer;
    //         ldc_SumQuantityBase: Decimal;
    //         lrc_PackOrderHeader3: Record "5110712";
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Funktion zum Laden der Verkäufe auf die Packereioutputposition
    //         // ------------------------------------------------------------------------------------------

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);

    //         // --------------------------------------------------------------------------
    //         // Bestehende Erlöszeilen löschen
    //         // --------------------------------------------------------------------------
    //         lrc_PackOrderRevenues.Reset();
    //         lrc_PackOrderRevenues.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         IF lrc_PackOrderRevenues.FIND('-') THEN
    //           lrc_PackOrderRevenues.DELETEALL(TRUE);


    //         // --------------------------------------------------------------------------
    //         // Output Zeilen lesen und Werte rekalkulieren
    //         // --------------------------------------------------------------------------
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderOutputItems.SETFILTER("Item No.",'<>%1','');
    //         lrc_PackOrderOutputItems.SETFILTER("Batch Variant No.",'<>%1','');
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             // Rekalkulation der Werte
    //             lrc_BatchVariantEntry.Reset();
    //             lrc_BatchVariantEntry.SETCURRENTKEY("Batch Variant No.","Item Ledger Entry Type","Location Code","Posting Date");
    //             lrc_BatchVariantEntry.SETRANGE("Batch Variant No.",lrc_PackOrderOutputItems."Batch Variant No.");
    //             lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry Type",lrc_BatchVariantEntry."Item Ledger Entry Type"::Sale);
    //             IF lrc_BatchVariantEntry.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lcu_BatchMgt.CalcValueBatchVarEntry(lrc_BatchVariantEntry."Entry No.");
    //               UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //             END;
    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //         END;
    //         COMMIT;


    //         // --------------------------------------------------------------------------
    //         // Output Zeilen lesen und Erlöse berechnen
    //         // --------------------------------------------------------------------------
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETCURRENTKEY("Doc. No.","Item No.");
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderOutputItems.SETFILTER("Item No.",'<>%1','');
    //         lrc_PackOrderOutputItems.SETFILTER("Batch Variant No.",'<>%1','');
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_PackOrderOutputItems.TESTFIELD("Qty. per Unit of Measure");

    //             // Werte zurücksetzen
    //             ldc_SummeMenge := 0;
    //             ldc_SummeBetragBrutto := 0;
    //             ldc_SummeRabatt := 0;
    //             ldc_SummeFrachtkosten := 0;
    //             ldc_SummeBetragNetto := 0;
    //             ldc_SummeDSDARA := 0;
    //             ldc_SummeBetragNettoNetto := 0;

    //             // --------------------------------------------------------------------------------------------------------------
    //             // Mengen in Aufträgen berechnen
    //             // --------------------------------------------------------------------------------------------------------------
    //             lrc_BatchVariantDetail.Reset();
    //             lrc_BatchVariantDetail.SETCURRENTKEY(Source,"Source Type","Batch Variant No.","Location Code","Sales Shipment Date");
    //             lrc_BatchVariantDetail.SETRANGE(Source,lrc_BatchVariantDetail.Source::Sales);
    //             //180502 rs
    //             //lrc_BatchVariantDetail.SETRANGE("Source Type",lrc_BatchVariantDetail."Source Type"::Order);
    //             lrc_BatchVariantDetail.SETFILTER("Source Type", '%1|%2', lrc_BatchVariantDetail."Source Type"::Order,
    //                                                                      lrc_BatchVariantDetail."Source Type"::"Blanket Order");
    //             //180502 rs.e
    //             lrc_BatchVariantDetail.SETRANGE("Batch Variant No.",lrc_PackOrderOutputItems."Batch Variant No.");
    //             //lrc_BatchVariantDetail.SETFILTER("Qty. Outstanding",'<>%1',0);
    //             IF lrc_BatchVariantDetail.FIND('-') THEN BEGIN
    //                 REPEAT

    //                 IF lrc_BatchVariantDetail."Qty. Outstanding" <> 0 THEN BEGIN
    //                   //180205 rs
    //                   //IF lrc_SalesLine.GET(lrc_SalesLine."Document Type"::Order,
    //                   IF lrc_SalesLine.GET(lrc_BatchVariantDetail."Source Type",
    //                                        lrc_BatchVariantDetail."Source No.",
    //                                        lrc_BatchVariantDetail."Source Line No.") THEN BEGIN


    //                     lrc_SalesHeader.GET(lrc_SalesLine."Document Type",lrc_SalesLine."Document No.");
    //                     IF lrc_SalesLine.Quantity = 0 THEN BEGIN
    //                       lrc_SalesLine.Quantity := 1;
    //                     END;

    //                     // Neuen Satz anlegen
    //                     lrc_PackOrderRevenues.Reset();
    //                     lrc_PackOrderRevenues.INIT();
    //                     lrc_PackOrderRevenues."Doc. No." := lrc_PackOrderHeader."No.";
    //                     lrc_PackOrderRevenues."Line No." := 0;

    //                     lrc_PackOrderRevenues."Doc. Output Line No." := lrc_PackOrderOutputItems."Line No.";

    //                     lrc_PackOrderRevenues."Source Type" := lrc_PackOrderRevenues."Source Type"::"Sales Order";
    //                     lrc_PackOrderRevenues."Item Ledger Entry No." := 0;

    //                     lrc_PackOrderRevenues."Pack. Order Doc. No." := lrc_PackOrderOutputItems."Doc. No.";
    //                     lrc_PackOrderRevenues."Pack. Order Output Line No." := lrc_PackOrderOutputItems."Line No.";
    //                     // POI 004.S
    //                     // lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status;
    //                     IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::"8" THEN
    //                       lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status
    //                     ELSE
    //                       lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status::Open;
    //                     // POI 004.E

    //                     lrc_PackOrderRevenues."Shipment Date" := lrc_SalesLine."Shipment Date";
    //                     lrc_PackOrderRevenues."Promised Delivery Date" := lrc_SalesLine."Promised Delivery Date";

    //                     lrc_PackOrderRevenues."Posting Doc. No." := lrc_SalesLine."Document No.";
    //                     // PAC 016 00000000.s
    //                     lrc_PackOrderRevenues."Posting Doc. Line No." := lrc_SalesLine."Line No.";
    //                     // PAC 016 00000000.e

    //                     lrc_PackOrderRevenues."Posting Date" := lrc_SalesHeader."Promised Delivery Date";

    //                     lrc_PackOrderRevenues."Customer No." := lrc_SalesLine."Sell-to Customer No.";
    //                     IF lrc_Customer.GET(lrc_PackOrderRevenues."Customer No.") THEN
    //                       lrc_PackOrderRevenues."Customer Name" := lrc_Customer."Search Name";

    //                     lrc_PackOrderRevenues."Item No." := lrc_SalesLine."No.";
    //                     lrc_PackOrderRevenues."Output Batch Variant No." := lrc_BatchVariantDetail."Batch Variant No.";
    //                     lrc_PackOrderRevenues."Output Batch No." := lrc_BatchVariantDetail."Batch No.";
    //                     lrc_PackOrderRevenues."Output Master Batch No." := lrc_BatchVariantDetail."Master Batch No.";
    //                     lrc_PackOrderRevenues."Output Location Code" := lrc_PackOrderOutputItems."Location Code";

    //                     lrc_PackOrderRevenues."Location Code" := lrc_SalesLine."Location Code";

    //                     //lrc_PackOrderRevenues."Quantity (Base)" := lrc_SalesLine."Outstanding Qty. (Base)";
    //                     //180205 rs - falsches Vorzeichen
    //                     //lrc_PackOrderRevenues."Quantity (Base)" := lrc_BatchVariantDetail."Qty. Outstanding (Base)";
    //                     lrc_PackOrderRevenues."Quantity (Base)" := -lrc_BatchVariantDetail."Qty. Outstanding (Base)";
    //                     lrc_PackOrderRevenues."Qty. per Unit of Measure" := lrc_SalesLine."Qty. per Unit of Measure";
    //                     lrc_PackOrderRevenues."Unit of Measure Code" := lrc_SalesLine."Unit of Measure Code";
    //                     lrc_PackOrderRevenues.Quantity := (lrc_PackOrderRevenues."Quantity (Base)" /
    //                                                        lrc_PackOrderRevenues."Qty. per Unit of Measure");

    //                     lrc_PackOrderRevenues."Gross Amount (LCY)" :=
    //                                            //180205 (lrc_SalesLine."Unit Price" * lrc_PackOrderRevenues.Quantity);
    //                                            (lrc_SalesLine."Unit Price" * lrc_PackOrderRevenues.Quantity * -1);

    //                     lrc_PackOrderRevenues."Inv. Disc. (Actual)" :=
    //                                            (lrc_SalesLine."Inv. Discount Amount" / lrc_SalesLine.Quantity *
    //                                             //180205 lrc_PackOrderRevenues.Quantity) * -1;
    //                                             lrc_PackOrderRevenues.Quantity);

    //                     lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" :=
    //                                            (lrc_SalesLine."Inv. Disc. not Relat. to Goods" / lrc_SalesLine.Quantity *
    //                                             //180205 lrc_PackOrderRevenues.Quantity) * -1;
    //                                             lrc_PackOrderRevenues.Quantity);

    //                     lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" :=
    //                                            (lrc_SalesLine."Accruel Inv. Disc. (External)" / lrc_SalesLine.Quantity *
    //                                             //180205 lrc_PackOrderRevenues.Quantity) * -1;
    //                                             lrc_PackOrderRevenues.Quantity);

    //                     lrc_PackOrderRevenues."Accruel Inv. Disc. (External)" :=
    //                                            (lrc_SalesLine."Accruel Inv. Disc. (Internal)" / lrc_SalesLine.Quantity *
    //                                             //180205 lrc_PackOrderRevenues.Quantity) * -1;
    //                                             lrc_PackOrderRevenues.Quantity);

    //                     lrc_PackOrderRevenues."Freight Costs Amount (LCY)" :=
    //                                            (lrc_SalesLine."Freight Costs Amount (LCY)" / lrc_SalesLine.Quantity *
    //                                             //180205 lrc_PackOrderRevenues.Quantity) * -1;
    //                                             lrc_PackOrderRevenues.Quantity);

    //                     lrc_PackOrderRevenues."Net Amount (LCY)" :=
    //                                            lrc_PackOrderRevenues."Gross Amount (LCY)" +
    //                                            lrc_PackOrderRevenues."Inv. Disc. (Actual)" +
    //                                            lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" +
    //                                            lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" +
    //                                            lrc_PackOrderRevenues."Accruel Inv. Disc. (External)" +
    //                                            lrc_PackOrderRevenues."Freight Costs Amount (LCY)";

    //                     lrc_PackOrderRevenues."DSD/ARA Amount (LCY)" :=
    //                                            (lrc_SalesLine."Waste Disposal Amount (LCY)" / lrc_SalesLine.Quantity *
    //                                             //180205 lrc_PackOrderRevenues.Quantity)  * -1;
    //                                             lrc_PackOrderRevenues.Quantity);

    //                     lrc_PackOrderRevenues."Net Net Amount (LCY)" :=
    //                                            lrc_PackOrderRevenues."Net Amount (LCY)" +
    //                                            lrc_PackOrderRevenues."DSD/ARA Amount (LCY)";

    //                     lrc_PackOrderRevenues."Status Customs Duty" := lrc_SalesLine."Status Customs Duty";
    //                     lrc_PackOrderRevenues."Sales Order Doc. No." := lrc_SalesLine."Document No.";
    //                     lrc_PackOrderRevenues."Sales Order Line No." := lrc_SalesLine."Line No.";

    //                     lrc_PackOrderRevenues.INSERT(TRUE);

    //                     // Summe pro Outputzeile
    //                     ldc_SummeMenge := ldc_SummeMenge + lrc_PackOrderRevenues."Quantity (Base)";
    //                     ldc_SummeBetragBrutto := ldc_SummeBetragBrutto + lrc_PackOrderRevenues."Gross Amount (LCY)";
    //                     ldc_SummeRabatt := ldc_SummeRabatt + lrc_PackOrderRevenues."Inv. Disc. (Actual)" +
    //                                                          lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" +
    //                                                          lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" +
    //                                                          lrc_PackOrderRevenues."Accruel Inv. Disc. (External)";
    //                     ldc_SummeFrachtkosten := ldc_SummeFrachtkosten + lrc_PackOrderRevenues."Freight Costs Amount (LCY)";
    //                     ldc_SummeBetragNetto := ldc_SummeBetragNetto + lrc_PackOrderRevenues."Net Amount (LCY)";
    //                     ldc_SummeDSDARA := ldc_SummeDSDARA + lrc_PackOrderRevenues."DSD/ARA Amount (LCY)";
    //                     ldc_SummeBetragNettoNetto := ldc_SummeBetragNettoNetto + lrc_PackOrderRevenues."Net Net Amount (LCY)";

    //                    END;
    //                   END;
    //                 UNTIL lrc_BatchVariantDetail.NEXT() = 0;
    //             END;

    //             // --------------------------------------------------------------------------------------------------------------
    //             // Gebuchte (gelieferte) Mengen berechnen
    //             // --------------------------------------------------------------------------------------------------------------
    //             lrc_BatchVariantEntry.Reset();
    //             lrc_BatchVariantEntry.SETCURRENTKEY("Batch Variant No.","Item Ledger Entry Type","Location Code","Posting Date");
    //             lrc_BatchVariantEntry.SETRANGE("Batch Variant No.",lrc_PackOrderOutputItems."Batch Variant No.");
    //             lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry Type",lrc_BatchVariantEntry."Item Ledger Entry Type"::Sale);
    //             IF lrc_BatchVariantEntry.FIND('-') THEN BEGIN
    //               REPEAT

    //                 lrc_ItemLedgerEntry.GET(lrc_BatchVariantEntry."Item Ledger Entry No.");

    //                 lrc_PackOrderRevenues.Reset();
    //                 lrc_PackOrderRevenues.INIT();
    //                 lrc_PackOrderRevenues."Doc. No." := lrc_PackOrderHeader."No.";
    //                 lrc_PackOrderRevenues."Line No." := 0;

    //                 lrc_PackOrderRevenues."Doc. Output Line No." := lrc_PackOrderOutputItems."Line No.";

    //                 lrc_PackOrderRevenues."Source Type" := lrc_PackOrderRevenues."Source Type"::"Item Ledger Entry";

    //                 lrc_PackOrderRevenues."Item Ledger Entry No." := lrc_ItemLedgerEntry."Entry No.";
    //                 lrc_PackOrderRevenues."Pack. Order Doc. No." := lrc_PackOrderOutputItems."Doc. No.";
    //                 lrc_PackOrderRevenues."Pack. Order Output Line No." := lrc_PackOrderOutputItems."Line No.";
    //                 // POI 004.S
    //                 // lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status;
    //                 IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::"8" THEN
    //                   lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status
    //                 ELSE
    //                   lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status::Open;
    //                 // POI 004.E

    //                 // Kontrolle auf Lieferschein
    //                 IF lrc_SalesShipmentHeader.GET(lrc_ItemLedgerEntry."Document No.") THEN BEGIN
    //                   lrc_PackOrderRevenues."Shipment Date" := lrc_SalesShipmentHeader."Shipment Date";
    //                   lrc_PackOrderRevenues."Promised Delivery Date" := lrc_SalesShipmentHeader."Promised Delivery Date";
    //                 END ELSE BEGIN
    //                   lrc_PackOrderRevenues."Shipment Date" := lrc_ItemLedgerEntry."Posting Date";
    //                   lrc_PackOrderRevenues."Promised Delivery Date" := lrc_ItemLedgerEntry."Posting Date";
    //                 END;

    //                 lrc_PackOrderRevenues."Posting Doc. No." := lrc_ItemLedgerEntry."Document No.";
    //                 // PAC 016 00000000.s
    //                 lrc_PackOrderRevenues."Posting Doc. Line No." := lrc_ItemLedgerEntry."Source Doc. Line No.";
    //                 // PAC 016 00000000.e

    //                 lrc_PackOrderRevenues."Posting Date" := lrc_ItemLedgerEntry."Posting Date";
    //                 lrc_PackOrderRevenues."Customer No." := lrc_ItemLedgerEntry."Source No.";
    //                 IF lrc_Customer.GET(lrc_PackOrderRevenues."Customer No.") THEN
    //                   lrc_PackOrderRevenues."Customer Name" := lrc_Customer."Search Name";

    //                 lrc_PackOrderRevenues."Item No." := lrc_ItemLedgerEntry."Item No.";
    //                 lrc_PackOrderRevenues."Output Batch Variant No." := lrc_BatchVariantEntry."Batch Variant No.";
    //                 lrc_PackOrderRevenues."Output Batch No." := lrc_BatchVariantEntry."Batch No.";
    //                 lrc_PackOrderRevenues."Output Master Batch No." := lrc_BatchVariantEntry."Master Batch No.";
    //                 lrc_PackOrderRevenues."Location Code" := lrc_ItemLedgerEntry."Location Code";

    //                 lrc_PackOrderRevenues."Quantity (Base)" := lrc_BatchVariantEntry."Quantity (Base)";
    //                 lrc_PackOrderRevenues."Qty. per Unit of Measure" := lrc_BatchVariantEntry."Qty. per Unit of Measure";

    //                 lrc_PackOrderRevenues."Unit of Measure Code" := lrc_BatchVariantEntry."Unit of Measure Code";
    //                 lrc_PackOrderRevenues.Quantity := (lrc_PackOrderRevenues."Quantity (Base)" /
    //                                                    lrc_PackOrderRevenues."Qty. per Unit of Measure");

    //         //xx        lrc_PackOrderRevenues."Gross Amount (LCY)" :=
    //         //xx                               lrc_BatchVariantEntry."Sales Amount (Actual)" +
    //         //xx                               lrc_BatchVariantEntry."Sales Amount (Expected)" -
    //         //xx                               lrc_BatchVariantEntry."Inv. Disc. (Actual)";

    //         //xx        lrc_PackOrderRevenues."Inv. Disc. (Actual)" := lrc_BatchVariantEntry."Inv. Disc. (Actual)";
    //         //xx        lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" := lrc_BatchVariantEntry."Inv. Disc. not Relat. to Goods";
    //         //xx        lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" := lrc_BatchVariantEntry."Accruel Inv. Disc. (Internal)";
    //         //xx        lrc_PackOrderRevenues."Accruel Inv. Disc. (External)" := lrc_BatchVariantEntry."Accruel Inv. Disc. (External)";

    //                 // ADF
    //                 lrc_ItemLedgerEntry.CALCFIELDS("Sales Amount (Actual)","Freight Costs","Inv. Disc. not Relat. to Goods",
    //                                               "Green Point Costs","Accruel Inv. Disc. (External)","Inv. Disc. (Actual)",
    //                                               "Sales Amount (Expected)","Accruel Inv. Disc. (Internal)");


    //                 lrc_PackOrderRevenues."Gross Amount (LCY)" :=
    //                                        lrc_ItemLedgerEntry."Sales Amount (Actual)" +
    //                                        lrc_ItemLedgerEntry."Sales Amount (Expected)" -
    //                                        lrc_ItemLedgerEntry."Inv. Disc. (Actual)";

    //                 lrc_PackOrderRevenues."Inv. Disc. (Actual)" := lrc_ItemLedgerEntry."Inv. Disc. (Actual)";
    //                 lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" := lrc_ItemLedgerEntry."Inv. Disc. not Relat. to Goods";
    //                 lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" := lrc_ItemLedgerEntry."Accruel Inv. Disc. (Internal)";
    //                 lrc_PackOrderRevenues."Accruel Inv. Disc. (External)" := lrc_ItemLedgerEntry."Accruel Inv. Disc. (External)";
    //                 // ADF

    //          /*
    //                  lrc_PackOrderRevenues."Gross Amount (LCY)" :=
    //                                        lrc_BatchVariantEntry."Sales Amount (Actual)" +
    //                                        lrc_BatchVariantEntry."Sales Amount (Expected)" -
    //                                        lrc_BatchVariantEntry."Inv. Disc. (Actual)";

    //                 lrc_PackOrderRevenues."Inv. Disc. (Actual)" := lrc_BatchVariantEntry."Inv. Disc. (Actual)";
    //                 lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" := lrc_BatchVariantEntry."Inv. Disc. not Relat. to Goods";
    //                 lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" := lrc_BatchVariantEntry."Accruel Inv. Disc. (Internal)";
    //                 lrc_PackOrderRevenues."Accruel Inv. Disc. (External)" := lrc_BatchVariantEntry."Accruel Inv. Disc. (External)";
    //           */

    //                 // ----------------------------------------------------------------------------------------------------
    //                 // Frachtkosten berechnen
    //                 // ----------------------------------------------------------------------------------------------------
    //         //xx        lrc_PackOrderRevenues."Freight Costs Amount (LCY)" := lrc_BatchVariantEntry."Freightcosts (Actual)";

    //                 // ADF
    //                 lrc_PackOrderRevenues."Freight Costs Amount (LCY)" := lrc_ItemLedgerEntry."Freight Costs";
    //                 // ADF

    //                 IF lrc_SalesShipmentLine.GET( lrc_BatchVariantEntry."Document No.", lrc_BatchVariantEntry."Document Line No." ) THEN BEGIN
    //                    IF lrc_SalesShipmentLine."Freight Costs Amount (LCY)" <> 0 THEN BEGIN
    //                      lrc_PackOrderRevenues."Freight Costs Amount (LCY)" := lrc_SalesShipmentLine."Freight Costs Amount (LCY)" /
    //                                                       lrc_SalesShipmentLine.Quantity *  lrc_PackOrderRevenues.Quantity ;
    //                    END;
    //                 END;

    //                 lrc_FreightOrderDetailLine.Reset();
    //                 lrc_FreightOrderDetailLine.SETRANGE("Doc. Source",lrc_FreightOrderDetailLine."Doc. Source"::Sales);
    //                 lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Type",lrc_FreightOrderDetailLine."Doc. Source Type"::Order);
    //                 lrc_FreightOrderDetailLine.SETRANGE("Doc. Source No.",lrc_ItemLedgerEntry."Source Doc. No.");
    //                 lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Line No.",lrc_ItemLedgerEntry."Source Doc. Line No.");
    //                 IF lrc_FreightOrderDetailLine.FIND('-') THEN BEGIN
    //                   lrc_PackOrderRevenues."Freight Costs Amount (LCY)" := 0;
    //                   REPEAT
    //                     lrc_PackOrderRevenues."Freight Costs Amount (LCY)" := lrc_PackOrderRevenues."Freight Costs Amount (LCY)" +
    //                                                                           lrc_FreightOrderDetailLine."Freight Costs (LCY)";
    //                   UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;
    //                   lrc_PackOrderRevenues."Freight Costs Amount (LCY)" := lrc_PackOrderRevenues."Freight Costs Amount (LCY)" * -1;

    //                   // Positiver Verkauf = stornierte Lieferung
    //                   IF lrc_ItemLedgerEntry.Quantity > 0 THEN
    //                     lrc_PackOrderRevenues."Freight Costs Amount (LCY)" := lrc_PackOrderRevenues."Freight Costs Amount (LCY)" * -1;
    //                 END;

    //                 // N E U E R  C O D E
    //                 // V E R P A C K U N G S E I N H E I T  A U S  E I N H E I T  H O L E N
    //                 IF lrc_UnitOfMeasure.GET(lrc_ItemLedgerEntry."Unit of Measure Code") THEN;

    //                 IF lrc_PackOrderOutputItems."Waste Disposal Payment Thru" =
    //                    lrc_PackOrderOutputItems."Waste Disposal Payment Thru"::Us THEN BEGIN
    //                   lrc_PackOrderRevenues."DSD/ARA Amount (LCY)" := ROUND(
    //                                       (lcu_DSDFunktion.CalcCharge(lrc_ItemLedgerEntry."Product Group Code",
    //                                        lrc_ItemLedgerEntry."Item No.",
    //                                        lrc_ItemLedgerEntry."Unit of Measure Code",
    //                                        // M E N G E  V E R P A C K U N G S E I N H E I T  Ü B E R G E B E N
    //                                        (lrc_UnitOfMeasure."Qty. (PU) per Unit of Measure") *
    //                                        lrc_PackOrderRevenues.Quantity )), 0.01);

    //                 //ZRR 001 ZRR40216.e
    //                 END ELSE BEGIN
    //                   lrc_PackOrderRevenues."DSD/ARA Amount (LCY)" := 0;
    //                 END;

    //         //xx        lrc_PackOrderRevenues."Net Amount (LCY)" :=
    //         //xx                               lrc_BatchVariantEntry."Sales Amount (Actual)" +
    //         //xx                               lrc_BatchVariantEntry."Sales Amount (Expected)" +
    //         //xx                               lrc_BatchVariantEntry."Inv. Disc. not Relat. to Goods" +
    //         //xx                               lrc_BatchVariantEntry."Accruel Inv. Disc. (Internal)" +
    //         //xx                               lrc_BatchVariantEntry."Accruel Inv. Disc. (External)" +
    //         //xx                               lrc_PackOrderRevenues."Freight Costs Amount (LCY)";

    //         //xx        lrc_PackOrderRevenues."Net Net Amount (LCY)" :=
    //         //xx                               lrc_BatchVariantEntry."Sales Amount (Actual)" +
    //         //xx                               lrc_BatchVariantEntry."Sales Amount (Expected)" +
    //         //xx                               lrc_BatchVariantEntry."Inv. Disc. not Relat. to Goods" +
    //         //xx                               lrc_BatchVariantEntry."Accruel Inv. Disc. (Internal)" +
    //         //xx                               lrc_BatchVariantEntry."Accruel Inv. Disc. (External)" +
    //         //xx                               lrc_PackOrderRevenues."Freight Costs Amount (LCY)" +
    //         //xx                               lrc_PackOrderRevenues."DSD/ARA Amount (LCY)";

    //                 // ADF
    //                 lrc_PackOrderRevenues."Net Amount (LCY)" :=
    //                                        lrc_ItemLedgerEntry."Sales Amount (Actual)" +
    //                                        lrc_ItemLedgerEntry."Sales Amount (Expected)" +
    //                                        lrc_ItemLedgerEntry."Inv. Disc. not Relat. to Goods" +
    //                                        lrc_ItemLedgerEntry."Accruel Inv. Disc. (Internal)" +
    //                                        lrc_ItemLedgerEntry."Accruel Inv. Disc. (External)" +
    //                                        lrc_PackOrderRevenues."Freight Costs Amount (LCY)";

    //                 lrc_PackOrderRevenues."Net Net Amount (LCY)" :=
    //                                        lrc_ItemLedgerEntry."Sales Amount (Actual)" +
    //                                        lrc_ItemLedgerEntry."Sales Amount (Expected)" +
    //                                        lrc_ItemLedgerEntry."Inv. Disc. not Relat. to Goods" +
    //                                        lrc_ItemLedgerEntry."Accruel Inv. Disc. (Internal)" +
    //                                        lrc_ItemLedgerEntry."Accruel Inv. Disc. (External)" +
    //                                        lrc_ItemLedgerEntry."Freight Costs" +
    //                                        lrc_ItemLedgerEntry."Green Point Costs";
    //                 // ADF
    //                 /*
    //                  lrc_PackOrderRevenues."Net Amount (LCY)" :=
    //                                        lrc_BatchVariantEntry."Sales Amount (Actual)" +
    //                                        lrc_BatchVariantEntry."Sales Amount (Expected)" +
    //                                        lrc_BatchVariantEntry."Inv. Disc. not Relat. to Goods" +
    //                                        lrc_BatchVariantEntry."Accruel Inv. Disc. (Internal)" +
    //                                        lrc_BatchVariantEntry."Accruel Inv. Disc. (External)" +
    //                                        lrc_PackOrderRevenues."Freight Costs Amount (LCY)";

    //                 lrc_PackOrderRevenues."Net Net Amount (LCY)" :=
    //                                        lrc_BatchVariantEntry."Sales Amount (Actual)" +
    //                                        lrc_BatchVariantEntry."Sales Amount (Expected)" +
    //                                        lrc_BatchVariantEntry."Inv. Disc. not Relat. to Goods" +
    //                                        lrc_BatchVariantEntry."Accruel Inv. Disc. (Internal)" +
    //                                        lrc_BatchVariantEntry."Accruel Inv. Disc. (External)" +
    //                                        lrc_PackOrderRevenues."Freight Costs Amount (LCY)" +
    //                                        lrc_PackOrderRevenues."DSD/ARA Amount (LCY)";
    //                 */

    //                 lrc_PackOrderRevenues."Status Customs Duty" := lrc_BatchVariantEntry."Status Customs Duty";

    //                 lrc_PackOrderRevenues."Sales Order Doc. No." := lrc_BatchVariantEntry."Source Doc. No.";
    //                 lrc_PackOrderRevenues."Sales Order Line No." := lrc_BatchVariantEntry."Source Doc. Line No.";

    //                 lrc_PackOrderRevenues.INSERT(TRUE);

    //                 // Summe pro Outputzeile
    //                 ldc_SummeMenge := ldc_SummeMenge + lrc_PackOrderRevenues."Quantity (Base)";
    //                 ldc_SummeBetragBrutto := ldc_SummeBetragBrutto + lrc_PackOrderRevenues."Gross Amount (LCY)";
    //                 ldc_SummeRabatt := ldc_SummeRabatt + lrc_PackOrderRevenues."Inv. Disc. (Actual)" +
    //                                                        lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" +
    //                                                        lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" +
    //                                                        lrc_PackOrderRevenues."Accruel Inv. Disc. (External)";
    //                 ldc_SummeFrachtkosten := ldc_SummeFrachtkosten + lrc_PackOrderRevenues."Freight Costs Amount (LCY)";
    //                 ldc_SummeBetragNetto := ldc_SummeBetragNetto + lrc_PackOrderRevenues."Net Amount (LCY)";
    //                 ldc_SummeDSDARA := ldc_SummeDSDARA + lrc_PackOrderRevenues."DSD/ARA Amount (LCY)";
    //                 ldc_SummeBetragNettoNetto := ldc_SummeBetragNettoNetto + lrc_PackOrderRevenues."Net Net Amount (LCY)";

    //               UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //             END;


    //             // --------------------------------------------------------------------------------------------------------------
    //             // Kontrolle ob Output als Input in einem anderen Packauftrag verwendet wurde
    //             // --------------------------------------------------------------------------------------------------------------
    //             lrc_PackOrderHeader.Blocked := lrc_PackOrderHeader.Blocked::" ";
    //             lrc_PackOrderHeader.Modify();

    //             lrc_PackOrderInputItems.Reset();
    //             lrc_PackOrderInputItems.SETCURRENTKEY( "Batch Variant No." );
    //             lrc_PackOrderInputItems.SETRANGE("Batch Variant No.",lrc_PackOrderOutputItems."Batch Variant No.");
    //             IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //               REPEAT

    //                 // Falls der nachfolgende Packauftrag noch nicht abgerechnet ist, dann den Aktuellen sperren für Abrechnung
    //                 lrc_PackOrderHeader2.GET(lrc_PackOrderInputItems."Doc. No.");
    //                 // POI 004.S
    //                 //IF lrc_PackOrderHeader2.Status = lrc_PackOrderHeader2.Status::Open THEN BEGIN
    //                 IF (lrc_PackOrderHeader2.Status = lrc_PackOrderHeader2.Status::Open) OR
    //                    (lrc_PackOrderHeader2.Status = lrc_PackOrderHeader2.Status::"8") THEN BEGIN
    //                 // POI 004.E
    //                   lrc_PackOrderHeader.Blocked := lrc_PackOrderHeader.Blocked::"Sperre wegen Output in Input";
    //                   lrc_PackOrderHeader.Modify();
    //                 END;

    //                 lrc_PackOrderRevPerInpBatch.Reset();
    //                 lrc_PackOrderRevPerInpBatch.SETRANGE("Doc. No.",lrc_PackOrderInputItems."Doc. No.");
    //                 lrc_PackOrderRevPerInpBatch.SETRANGE("Input Batch Variant No.",lrc_PackOrderInputItems."Batch Variant No.");
    //                 lrc_PackOrderRevPerInpBatch.SETRANGE("Doc. Line No. Input",lrc_PackOrderInputItems."Line No.");
    //                 IF lrc_PackOrderRevPerInpBatch.FIND('-') THEN BEGIN
    //                   REPEAT

    //                     lrc_PackOrderRevenues.Reset();
    //                     lrc_PackOrderRevenues.INIT();
    //                     lrc_PackOrderRevenues."Doc. No." := lrc_PackOrderHeader."No.";
    //                     lrc_PackOrderRevenues."Line No." := 0;
    //                     lrc_PackOrderRevenues."Doc. Output Line No." := lrc_PackOrderOutputItems."Line No.";

    //                     lrc_PackOrderRevenues."Source Type" := lrc_PackOrderRevenues."Source Type"::"Packing Order Input";
    //                     lrc_PackOrderRevenues."Item Ledger Entry No." := lrc_PackOrderRevPerInpBatch."Item Ledger Entry No.";
    //                     lrc_PackOrderRevenues."Pack. Order Doc. No." := lrc_PackOrderOutputItems."Doc. No.";
    //                     lrc_PackOrderRevenues."Pack. Order Output Line No." := lrc_PackOrderOutputItems."Line No.";
    //                     // POI 004.S
    //                     // lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status;
    //                     IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::"8" THEN
    //                       lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status
    //                     ELSE
    //                       lrc_PackOrderRevenues."Pack. Order State" := lrc_PackOrderHeader.Status::Open;
    //                     // POI 004.E

    //                     lrc_PackOrderRevenues."Shipment Date" := lrc_PackOrderRevPerInpBatch."Shipment Date";
    //                     lrc_PackOrderRevenues."Promised Delivery Date" := lrc_PackOrderRevPerInpBatch."Promised Delivery Date";

    //                     lrc_PackOrderRevenues."Posting Doc. No." := lrc_PackOrderRevPerInpBatch."Posting Doc. No.";
    //                     lrc_PackOrderRevenues."Posting Doc. Line No." := lrc_PackOrderRevPerInpBatch."Posting Doc. Line No.";

    //                     lrc_PackOrderRevenues."Posting Date" := lrc_PackOrderRevPerInpBatch."Posting Date";
    //                     lrc_PackOrderRevenues."Customer No." := lrc_PackOrderRevPerInpBatch."Customer No.";
    //                     lrc_PackOrderRevenues."Customer Name" := lrc_PackOrderRevPerInpBatch."Customer Name";

    //                     lrc_PackOrderRevenues."Item No." := lrc_PackOrderInputItems."Item No.";
    //                     lrc_PackOrderRevenues."Output Batch Variant No." := lrc_PackOrderInputItems."Batch Variant No.";
    //                     lrc_PackOrderRevenues."Output Batch No." := lrc_PackOrderInputItems."Batch No.";
    //                     lrc_PackOrderRevenues."Output Master Batch No." := lrc_PackOrderInputItems."Master Batch No.";

    //                     lrc_PackOrderRevenues."Location Code" := lrc_PackOrderInputItems."Location Code";

    //                     lrc_PackOrderRevenues."Quantity (Base)" := lrc_PackOrderRevPerInpBatch."Quantity (Base)" * -1;
    //                     lrc_PackOrderRevenues."Qty. per Unit of Measure" := lrc_PackOrderRevPerInpBatch."Qty. per Unit of Measure";

    //                     lrc_PackOrderRevenues."Unit of Measure Code" := lrc_PackOrderRevPerInpBatch."Unit of Measure Code";
    //                     lrc_PackOrderRevenues.Quantity := lrc_PackOrderRevPerInpBatch.Quantity * -1;

    //                     lrc_PackOrderRevenues."Gross Amount (LCY)" := lrc_PackOrderRevPerInpBatch."Gross Amount (LCY)";
    //                     lrc_PackOrderRevenues."Inv. Disc. (Actual)" := lrc_PackOrderRevPerInpBatch."Inv. Disc. (Actual)";
    //                     lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" := lrc_PackOrderRevPerInpBatch."Rg.-Rab. ohne Wbz. (Act)";
    //                     lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" := lrc_PackOrderRevPerInpBatch."Accruel Inv. Disc. (Internal)";
    //                     lrc_PackOrderRevenues."Accruel Inv. Disc. (External)" := lrc_PackOrderRevPerInpBatch."Accruel Inv. Disc. (External)";
    //                     lrc_PackOrderRevenues."Freight Costs Amount (LCY)" := lrc_PackOrderRevPerInpBatch."Freight Costs Amount (LCY)";

    //                     IF lrc_PackOrderOutputItems."Waste Disposal Payment Thru" =
    //                       lrc_PackOrderOutputItems."Waste Disposal Payment Thru"::Us THEN BEGIN
    //                       lrc_PackOrderRevenues."DSD/ARA Amount (LCY)" := 0;
    //                     END ELSE BEGIN
    //                       lrc_PackOrderRevenues."DSD/ARA Amount (LCY)" := 0;
    //                     END;

    //                     lrc_PackOrderRevenues."Net Amount (LCY)" := lrc_PackOrderRevPerInpBatch."Net Amount (LCY)";
    //                     lrc_PackOrderRevenues."Net Net Amount (LCY)" := lrc_PackOrderRevPerInpBatch."Amount (LCY)";

    //                     lrc_PackOrderRevenues."Status Customs Duty" := lrc_PackOrderRevPerInpBatch."Status Customs Duty";
    //                     lrc_PackOrderRevenues."Sales Order Doc. No." := lrc_PackOrderRevPerInpBatch."Sales Order Doc. No.";
    //                     lrc_PackOrderRevenues."Sales Order Line No." := lrc_PackOrderRevPerInpBatch."Sales Order Line No.";
    //                     lrc_PackOrderRevenues.INSERT(TRUE);

    //                     // Summe pro Outputzeile
    //                     ldc_SummeMenge := ldc_SummeMenge + lrc_PackOrderRevenues."Quantity (Base)";
    //                     ldc_SummeBetragBrutto := ldc_SummeBetragBrutto + lrc_PackOrderRevenues."Gross Amount (LCY)";
    //                     ldc_SummeRabatt := ldc_SummeRabatt + lrc_PackOrderRevenues."Inv. Disc. (Actual)" +
    //                                                          lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" +
    //                                                          lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" +
    //                                                          lrc_PackOrderRevenues."Accruel Inv. Disc. (External)";
    //                     ldc_SummeFrachtkosten := ldc_SummeFrachtkosten + lrc_PackOrderRevenues."Freight Costs Amount (LCY)";
    //                     ldc_SummeBetragNetto := ldc_SummeBetragNetto + lrc_PackOrderRevenues."Net Amount (LCY)";
    //                     ldc_SummeDSDARA := ldc_SummeDSDARA + lrc_PackOrderRevenues."DSD/ARA Amount (LCY)";
    //                     ldc_SummeBetragNettoNetto := ldc_SummeBetragNettoNetto + lrc_PackOrderRevenues."Net Net Amount (LCY)";

    //                   UNTIL lrc_PackOrderRevPerInpBatch.NEXT() = 0;
    //                 END;

    //               UNTIL lrc_PackOrderInputItems.NEXT() = 0;

    //             END;

    //             // Summe in Outputzeile speichern
    //             lrc_PackOrderOutputItems."Sales Qty. (Base)" := ldc_SummeMenge;
    //             lrc_PackOrderOutputItems."Sales Qty." := lrc_PackOrderOutputItems."Sales Qty. (Base)" /
    //                                                      lrc_PackOrderOutputItems."Qty. per Unit of Measure";
    //             lrc_PackOrderOutputItems."Sales Gross Amount (LCY)" := ldc_SummeBetragBrutto;
    //             lrc_PackOrderOutputItems."Sales Freight Costs Amt. (LCY)" := ldc_SummeFrachtkosten;
    //             lrc_PackOrderOutputItems."Sales Discount Amt. (LCY)" := ldc_SummeRabatt;
    //             lrc_PackOrderOutputItems."Sales Net Amount (LCY)" := ldc_SummeBetragNetto;
    //             lrc_PackOrderOutputItems."Sales Green Point Amount (LCY)" := ldc_SummeDSDARA;
    //             lrc_PackOrderOutputItems."Sales Net Net Amount (LCY)" := ldc_SummeBetragNettoNetto;
    //             lrc_PackOrderOutputItems.Modify();

    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //         END;


    //         // ---------------------------------------------------------------------------------------
    //         // Prozentanteile am Gesamtumsatz berechnen
    //         // ---------------------------------------------------------------------------------------
    //         ldc_TotalTurnover := 0;
    //         ldc_SummeMenge:=0;

    //         //POI 006 160727 rs
    //         ldc_SumQuantityBase := 0;

    //         // Summe Umsatz berechnen
    //         lrc_PackOrderRevenues.Reset();
    //         lrc_PackOrderRevenues.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         IF lrc_PackOrderRevenues.FIND('-') THEN BEGIN
    //           REPEAT
    //             ldc_TotalTurnover := ldc_TotalTurnover + lrc_PackOrderRevenues."Net Net Amount (LCY)";
    //             //POI 006 160727 rs
    //             ldc_SumQuantityBase += lrc_PackOrderRevenues."Quantity (Base)";
    //             lrc_PackOrderRevenues.Modify();
    //           UNTIL lrc_PackOrderRevenues.NEXT() = 0;

    //           // Anteile Prozente berechnen
    //           IF lrc_PackOrderRevenues.FIND('-') THEN BEGIN
    //             REPEAT
    //               lrc_PackOrderRevenues."Percentage of Total Turnover" := 0;
    //               IF ldc_TotalTurnover <> 0 THEN

    //                 lrc_PackOrderRevenues."Percentage of Total Turnover" := lrc_PackOrderRevenues."Net Net Amount (LCY)" /
    //                                                                         ldc_TotalTurnover * 100
    //               ELSE
    //                 //POI 003 ERROR    JST 181213 001 PackCalcRevenues -> ldc_SummeMenge eventuelle 0-Division abfangen
    //                 //lrc_PackOrderRevenues."Percentage of Total Turnover" := lrc_PackOrderRevenues."Quantity (Base)" /
    //                 IF ldc_SummeMenge <> 0 THEN
    //                   lrc_PackOrderRevenues."Percentage of Total Turnover" := lrc_PackOrderRevenues."Quantity (Base)" /
    //                                                                         ldc_SummeMenge * 100;
    //               //POI 006 170213 rs
    //               lrc_PackOrderHeader3.GET(vco_PackOrderNo);
    //               lrc_PackOrderHeader3.CALCFIELDS("Tot. Qty. Output (Base)");

    //                //POI 006 160727 rs
    //               IF ldc_SumQuantityBase <> 0 THEN
    //               //  lrc_PackOrderRevenues."Percentage of Total Quantity" := lrc_PackOrderRevenues."Quantity (Base)" /
    //               //                                                         ldc_SumQuantityBase * 100
    //                 //POI 006 160227 rs
    //                 lrc_PackOrderRevenues."Percentage of Total Quantity" := lrc_PackOrderRevenues."Quantity (Base)" /
    //                                                                        lrc_PackOrderHeader3."Tot. Qty. Output (Base)" * 100 * (-1)
    //               ELSE
    //                 lrc_PackOrderRevenues."Percentage of Total Quantity" := 0.0001;
    //               //POI 006.e
    //               lrc_PackOrderRevenues.Modify();

    //             UNTIL lrc_PackOrderRevenues.NEXT() = 0;
    //           END;
    //         END;

    //     end;

    //     procedure PackCalcCosts(vco_PackOrderNo: Code[20];rbn_ConFirm: Boolean)
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_CostCategoryAccounts: Record "5110346";
    //         lrc_GeneralLedgerSetup: Record "98";
    //         lrc_GLAccount: Record "G/L Account";
    //         lrc_BatchSetup: Record "5110363";
    //         AGILES_LT_001: Label 'Dimensionsebene nicht zulässig!';
    //         lco_BatchNoDimFilter: Text[1024];
    //         AGILES_LT_002: Label 'Wollen Sie die Kosten für den Packereiauftrag %1 neu kalkulieren ?';
    //         AGILES_LT_003: Label 'Wollen Sie die Kosten für den Sortierauftrag %1 neu kalkulieren ?';
    //         AGILES_LT_004: Label 'Wollen Sie die Kosten für den Ersatzartikelpackereiauftrag %1 neu kalkulieren ?';
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Packerei Kosten kalkulieren
    //         // ------------------------------------------------------------------------------------------------

    //         IF rbn_ConFirm = TRUE THEN BEGIN
    //           CASE lrc_PackOrderHeader."Document Type" OF
    //           lrc_PackOrderHeader."Document Type"::"Packing Order":
    //             BEGIN
    //               //IF NOT CONFIRM( AGILES_LT_002, TRUE, vco_PackOrderNo ) THEN BEGIN
    //               //  EXIT;
    //               //END;
    //             END;
    //           lrc_PackOrderHeader."Document Type"::"Sorting Order":
    //             BEGIN
    //               IF NOT CONFIRM( AGILES_LT_003, TRUE, vco_PackOrderNo ) THEN BEGIN
    //                 EXIT;
    //               END;
    //             END;
    //           ELSE
    //             BEGIN
    //             END;
    //           END;
    //         END;

    //         lrc_BatchSetup.GET();

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         lrc_PackOrderHeader.CALCFIELDS("Tot. Qty. Packing Output","Tot. Qty. Units Output");
    //         lrc_PackOrderHeader.TESTFIELD("Pack.-by Vendor No.");

    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.SETFILTER("No.",'<>%1','');
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //           REPEAT

    //             // --------------------------------------------------------------------------------------------
    //             // Kostenbetrag berechnen
    //             // --------------------------------------------------------------------------------------------
    //             InputCostCalcAmount(lrc_PackOrderInputCosts,lrc_PackOrderInputCosts."Amount (LCY)",
    //                                                         lrc_PackOrderInputCosts.Quantity);
    //             lrc_PackOrderInputCosts.VALIDATE(Quantity);
    //             lrc_PackOrderInputCosts."Calculated Costs (LCY)" := lrc_PackOrderInputCosts."Amount (LCY)";

    //             // --------------------------------------------------------------------------------------------
    //             // Gebuchte Kosten berechnen für Kostenkategorien
    //             // --------------------------------------------------------------------------------------------
    //             IF lrc_PackOrderInputCosts.Type = lrc_PackOrderInputCosts.Type::"Cost Category" THEN BEGIN

    //               lrc_PackOrderInputCosts.TESTFIELD("No.");

    //               lrc_GeneralLedgerSetup.GET();
    //               lrc_PackOrderInputCosts."Posted Costs (LCY)" := 0;

    //               // Positionsfilter aufbauen
    //               lco_BatchNoDimFilter := lrc_PackOrderHeader."Batch No.";
    //               lrc_PackOrderOutputItems.Reset();
    //               lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //               IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //                 lco_BatchNoDimFilter := '';
    //                 REPEAT
    //                   IF lrc_PackOrderOutputItems."Batch No." <> '' THEN BEGIN
    //                     IF lco_BatchNoDimFilter = '' THEN BEGIN
    //                       lco_BatchNoDimFilter := lrc_PackOrderOutputItems."Batch No.";
    //                     END ELSE BEGIN
    //                       lco_BatchNoDimFilter := lco_BatchNoDimFilter + '|' + lrc_PackOrderOutputItems."Batch No.";
    //                     END;
    //                   END;
    //                 UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //               END;

    //               lrc_CostCategoryAccounts.Reset();
    //               lrc_CostCategoryAccounts.SETRANGE(lrc_CostCategoryAccounts."Cost Category Code",lrc_PackOrderInputCosts."No.");
    //               IF lrc_CostCategoryAccounts.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   IF lrc_GLAccount.GET( lrc_CostCategoryAccounts."G/L Account No." ) THEN BEGIN

    //                     CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                        lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                          lrc_GLAccount.SETFILTER("Global Dimension 1 Filter", lco_BatchNoDimFilter );
    //                        lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                          lrc_GLAccount.SETFILTER("Global Dimension 2 Filter", lco_BatchNoDimFilter );
    //                        lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                          lrc_GLAccount.SETFILTER("Global Dimension 3 Filter", lco_BatchNoDimFilter );
    //                        lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                          lrc_GLAccount.SETFILTER("Global Dimension 4 Filter", lco_BatchNoDimFilter );
    //                        ELSE
    //                          // Dimensionsebene nicht zulässig!
    //                          ERROR(AGILES_LT_001);
    //                     END;

    //                     // Kontrolle ob es eine weitere Dimensionseingrenzung auf dem Konto gibt
    //                     IF (lrc_CostCategoryAccounts."Dimension Code" <> '') AND
    //                        (lrc_CostCategoryAccounts."Dimension Value" <> '') THEN BEGIN
    //                       CASE lrc_CostCategoryAccounts."Dimension Code" OF
    //                       lrc_GeneralLedgerSetup."Global Dimension 1 Code":
    //                         lrc_GLAccount.SETRANGE("Global Dimension 1 Code",lrc_CostCategoryAccounts."Dimension Value");
    //                       lrc_GeneralLedgerSetup."Global Dimension 2 Code":
    //                         lrc_GLAccount.SETRANGE("Global Dimension 2 Code",lrc_CostCategoryAccounts."Dimension Value");
    //                       lrc_GeneralLedgerSetup."Global Dimension 3 Code":
    //                         lrc_GLAccount.SETRANGE("Global Dimension 3 Code",lrc_CostCategoryAccounts."Dimension Value");
    //                       lrc_GeneralLedgerSetup."Global Dimension 4 Code":
    //                         lrc_GLAccount.SETRANGE("Global Dimension 4 Code",lrc_CostCategoryAccounts."Dimension Value");
    //                       END;
    //                     END;

    //                     lrc_GLAccount.CALCFIELDS("Net Change");
    //                     lrc_PackOrderInputCosts."Posted Costs (LCY)" := lrc_PackOrderInputCosts."Posted Costs (LCY)" +
    //                                                                     lrc_GLAccount."Net Change";
    //                   END;
    //                 UNTIL lrc_CostCategoryAccounts.NEXT() = 0;

    //                 lrc_PackOrderInputCosts."Chargeable Costs (LCY)" := lrc_PackOrderInputCosts."Posted Costs (LCY)";
    //               END;

    //             END ELSE BEGIN
    //               lrc_PackOrderInputCosts."Chargeable Costs (LCY)" := lrc_PackOrderInputCosts."Posted Costs (LCY)";
    //             END;

    //             IF lrc_PackOrderInputCosts."Chargeable Costs (LCY)" = 0 THEN
    //               lrc_PackOrderInputCosts.VALIDATE("Chargeable Costs (LCY)",lrc_PackOrderInputCosts."Calculated Costs (LCY)");

    //             lrc_PackOrderInputCosts.Modify();

    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;

    //         END;
    //     end;

    //     procedure PackCostsToCostControl(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_CostCategory: Record "5110345";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderCostControle: Record "5110727";
    //         lrc_FreightCostControle: Record "5087923";
    //         ldc_PackCostAmount: Decimal;
    //         ldc_FreightCostAmount: Decimal;
    //     begin
    //         // --------------------------------------------------------------------------------------------------------------
    //         // Kostenkontrolle Packaufträge füllen / aktualisieren
    //         // --------------------------------------------------------------------------------------------------------------
    //         //PAC 015 DMG50179.s
    //         //lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         IF lrc_PackOrderHeader.GET(vco_PackOrderNo) THEN BEGIN
    //         //PAC 015 DMG50179.e

    //           // --------------------------------------------------------------------------------------------------------------
    //           // Packkostenkontrolle
    //           // --------------------------------------------------------------------------------------------------------------
    //           lrc_CostCategory.Reset();
    //           lrc_CostCategory.SETFILTER("Pack. Order Cost Controle",'%1|%2',
    //                                     lrc_CostCategory."Pack. Order Cost Controle"::"Packing Cost",
    //                                     lrc_CostCategory."Pack. Order Cost Controle"::" ");
    //           IF lrc_CostCategory.FIND('-') THEN BEGIN

    //             IF NOT lrc_PackOrderCostControle.GET(lrc_PackOrderHeader."No.") THEN BEGIN
    //               lrc_PackOrderCostControle.Reset();
    //               lrc_PackOrderCostControle.INIT();
    //               lrc_PackOrderCostControle."Pack. Order No." := vco_PackOrderNo;
    //               lrc_PackOrderCostControle.insert();
    //             END ELSE BEGIN
    //               // Aktion wenn Rechnung bereits vorhanden !?!
    //               IF lrc_PackOrderCostControle."Invoice Recieved" = TRUE THEN BEGIN
    //               END;
    //             END;

    //             // Packkostenbetrag berechnen
    //             ldc_PackCostAmount := 0;
    //             lrc_PackOrderInputCosts.Reset();
    //             lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //             lrc_PackOrderInputCosts.SETRANGE(Type,lrc_PackOrderInputCosts.Type::"Cost Category");
    //             lrc_PackOrderInputCosts.SETFILTER("No.",'<>%1','');
    //             IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_CostCategory.Reset();
    //                 lrc_CostCategory.GET(lrc_PackOrderInputCosts."No.");
    //                 IF (lrc_CostCategory."Pack. Order Cost Controle" =
    //                   lrc_CostCategory."Pack. Order Cost Controle"::"Packing Cost") OR
    //                   (lrc_CostCategory."Pack. Order Cost Controle" =
    //                   lrc_CostCategory."Pack. Order Cost Controle"::" ") THEN BEGIN
    //                   ldc_PackCostAmount := ldc_PackCostAmount + lrc_PackOrderInputCosts."Calculated Costs (LCY)";
    //                 END;
    //               UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //             END;

    //             lrc_PackOrderCostControle."Pack.-by Vendor No." := lrc_PackOrderHeader."Pack.-by Vendor No.";
    //             lrc_PackOrderCostControle."Pack.-by Name" := lrc_PackOrderHeader."Pack.-by Name";
    //             lrc_PackOrderCostControle."Item No." := lrc_PackOrderHeader."Item No.";
    //             lrc_PackOrderCostControle."Item Description" := lrc_PackOrderHeader.Description;
    //             lrc_PackOrderCostControle."Item Description 2" := lrc_PackOrderHeader."Description 2";
    //             lrc_PackOrderCostControle."Order Date" := lrc_PackOrderHeader."Order Date";
    //             lrc_PackOrderCostControle."Packing Date" := lrc_PackOrderHeader."Packing Date";
    //             lrc_PackOrderCostControle."Calc. Pack. Cost Amount" := ldc_PackCostAmount;
    //             lrc_PackOrderCostControle.Modify();

    //           END;

    //           // --------------------------------------------------------------------------------------------------------------
    //           // Frachtkostenkontrolle
    //           // --------------------------------------------------------------------------------------------------------------
    //           lrc_CostCategory.Reset();
    //           lrc_CostCategory.SETRANGE("Pack. Order Cost Controle",lrc_CostCategory."Pack. Order Cost Controle"::"Freight Cost");
    //           IF lrc_CostCategory.FIND('-') THEN BEGIN

    //             lrc_FreightCostControle.Reset();
    //             lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::"Packing Order");
    //             lrc_FreightCostControle.SETRANGE("Source No.",lrc_PackOrderHeader."No.");
    //             IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN
    //               lrc_FreightCostControle.Reset();
    //               lrc_FreightCostControle.INIT();
    //               lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::"Packing Order");
    //               lrc_FreightCostControle.SETRANGE("Source No.",lrc_PackOrderHeader."No.");

    //               // PAC 013 DMG50000.s
    //               lrc_FreightCostControle."Document Subtype Code" := lrc_PackOrderHeader."Pack. Doc. Type Code";
    //               // PAC 013 DMG50000.e

    //               lrc_FreightCostControle.INSERT(TRUE);
    //             END ELSE BEGIN
    //             END;


    //             // Frachtkostenbetrag berechnen
    //             ldc_FreightCostAmount := 0;
    //             lrc_PackOrderInputCosts.Reset();
    //             lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //             lrc_PackOrderInputCosts.SETRANGE(Type,lrc_PackOrderInputCosts.Type::"Cost Category");
    //             lrc_PackOrderInputCosts.SETFILTER("No.",'<>%1','');
    //             IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //               REPEAT
    //                lrc_CostCategory.Reset();
    //                 lrc_CostCategory.GET(lrc_PackOrderInputCosts."No.");
    //                 IF lrc_CostCategory."Pack. Order Cost Controle" =
    //                    lrc_CostCategory."Pack. Order Cost Controle"::"Freight Cost" THEN BEGIN
    //                   ldc_FreightCostAmount := ldc_FreightCostAmount + lrc_PackOrderInputCosts."Calculated Costs (LCY)";
    //                 END;
    //               UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //             END;


    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := ldc_FreightCostAmount;
    //             lrc_FreightCostControle."Freight Cost Manual" := TRUE;
    //             lrc_FreightCostControle.Modify();

    //           END;
    //         END;
    //     end;

    //     procedure InputCostCalcAmount(vrc_PackOrderInputCosts: Record "5110716";var rdc_AllocAmount: Decimal;var rdc_Qty: Decimal)
    //     var
    //         AGILES_TEXT001: Label 'This choice %1 is not yet possible !';
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         ldc_QtyPack: Decimal;
    //         ldc_QtyPallet: Decimal;
    //         ldc_QtyKolli: Decimal;
    //         ldc_QtyNetWeight: Decimal;
    //         ldc_QtyGrossWeight: Decimal;
    //         ldc_Lines: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Berechnung des Betrages aufgrund der Bezugsgröße
    //         // ---------------------------------------------------------------------------------

    //         IF vrc_PackOrderInputCosts."Allocation Price (LCY)" = 0 THEN BEGIN
    //           rdc_AllocAmount := 0;
    //           rdc_Qty := 1;
    //           EXIT;
    //         END;

    //         // Summenwerte aufaddieren
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",vrc_PackOrderInputCosts."Doc. No.");
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         lrc_PackOrderOutputItems.SETFILTER("Item No.",'<>%1','');
    //         // Eingrenzung auf eine bestimmte Outputzeile
    //         IF vrc_PackOrderInputCosts."Doc. Line No. Output" <> 0 THEN
    //           lrc_PackOrderOutputItems.SETRANGE("Line No.",vrc_PackOrderInputCosts."Doc. Line No. Output");
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           REPEAT
    //             ldc_QtyPack := ldc_QtyPack + lrc_PackOrderOutputItems."Quantity (PU)";
    //             ldc_QtyPallet := ldc_QtyPallet + lrc_PackOrderOutputItems."Quantity (TU)";
    //             ldc_QtyKolli := ldc_QtyKolli + lrc_PackOrderOutputItems.Quantity;
    //             ldc_QtyNetWeight := ldc_QtyNetWeight + lrc_PackOrderOutputItems."Total Net Weight";
    //             ldc_QtyGrossWeight := ldc_QtyGrossWeight + lrc_PackOrderOutputItems."Total Gross Weight";
    //             ldc_Lines := ldc_Lines + 1;
    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

    //         CASE vrc_PackOrderInputCosts."Allocation Base Costs" OF
    //         vrc_PackOrderInputCosts."Allocation Base Costs"::Packing:
    //           BEGIN
    //             rdc_AllocAmount := (vrc_PackOrderInputCosts."Allocation Price (LCY)" * ldc_QtyPack);
    //             rdc_Qty := ldc_QtyPack;
    //           END;
    //         vrc_PackOrderInputCosts."Allocation Base Costs"::Pallets:
    //           BEGIN
    //             rdc_AllocAmount := (vrc_PackOrderInputCosts."Allocation Price (LCY)" * ldc_QtyPallet);
    //             rdc_Qty := ldc_QtyPallet;
    //           END;
    //         vrc_PackOrderInputCosts."Allocation Base Costs"::Kolli:
    //           BEGIN
    //             rdc_AllocAmount := (vrc_PackOrderInputCosts."Allocation Price (LCY)" * ldc_QtyKolli);
    //             rdc_Qty := ldc_QtyKolli;
    //           END;
    //         vrc_PackOrderInputCosts."Allocation Base Costs"::"Net Weight":
    //           BEGIN
    //             rdc_AllocAmount := (vrc_PackOrderInputCosts."Allocation Price (LCY)" * ldc_QtyNetWeight);
    //             rdc_Qty := ldc_QtyNetWeight;
    //           END;
    //         vrc_PackOrderInputCosts."Allocation Base Costs"::"Gross Weight":
    //           BEGIN
    //             rdc_AllocAmount := (vrc_PackOrderInputCosts."Allocation Price (LCY)" * ldc_QtyGrossWeight);
    //             rdc_Qty := ldc_QtyGrossWeight;
    //           END;
    //         vrc_PackOrderInputCosts."Allocation Base Costs"::Lines:
    //           BEGIN
    //             rdc_AllocAmount := (vrc_PackOrderInputCosts."Allocation Price (LCY)" * ldc_Lines);
    //             rdc_Qty := ldc_Lines;
    //           END;
    //         vrc_PackOrderInputCosts."Allocation Base Costs"::Amount:
    //           BEGIN
    //             rdc_AllocAmount := (vrc_PackOrderInputCosts."Allocation Price (LCY)");
    //             rdc_Qty := 1;
    //           END;
    //         END;
    //     end;

    //     procedure AllocateCostToOutputLines(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //         AGILES_LT_TEXT001: Label 'Nicht zulässig: %1 !';
    //         lr_GLEntry: Record "17";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Verteilung der Kosten auf die Positionsvarianten Output
    //         // -----------------------------------------------------------------------------

    //         // Pack.-Auftragskopf lesen
    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);

    //         // Werte kalkulieren
    //         lrc_PackOrderHeader.CALCFIELDS("Tot. Qty. Units Output","Tot. Qty. Packing Output",
    //                                        "Tot. Gross Weight Output","Tot. Net Weight Output");

    //         // Kosten in den Outputzeilen zurücksetzen
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderOutputItems.MODIFYALL("Amount Cost Calculation (LCY)",0);
    //         lrc_PackOrderOutputItems.MODIFYALL("Amount Posted Costs (LCY)",0);
    //         lrc_PackOrderOutputItems.MODIFYALL("Amount Chargeable Costs (LCY)",0);
    //         COMMIT;


    //         // ----------------------------------------------------------------------------------------
    //         // Kosten nur für jeweils eine bestimmte Zeilen
    //         // Ressourcen und Kostenkategorien
    //         // ----------------------------------------------------------------------------------------
    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.SETFILTER("Doc. Line No. Output",'<>%1',0);
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_PackOrderOutputItems.Reset();
    //             lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //             lrc_PackOrderOutputItems.SETRANGE("Line No.",lrc_PackOrderInputCosts."Doc. Line No. Output");
    //             IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //               REPEAT

    //                 // --------------------------------------------------------------------------------
    //                 // Kalkulierte Kosten
    //                 // --------------------------------------------------------------------------------
    //                 IF lrc_PackOrderInputCosts."Calculated Costs (LCY)" <> 0 THEN BEGIN
    //                   CASE lrc_PackOrderInputCosts."Allocation Batch No." OF
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Packing:
    //                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" :=
    //                                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" +
    //                                       lrc_PackOrderInputCosts."Calculated Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" :=
    //                                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" +
    //                                       lrc_PackOrderInputCosts."Calculated Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Kolli:
    //                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" :=
    //                                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" +
    //                                       lrc_PackOrderInputCosts."Calculated Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::"Net Weight":
    //                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" :=
    //                                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" +
    //                                       lrc_PackOrderInputCosts."Calculated Costs (LCY)";
    //                   END;
    //                 END;

    //                 // --------------------------------------------------------------------------------
    //                 // Gebuchte Kosten
    //                 // --------------------------------------------------------------------------------
    //                 IF lrc_PackOrderInputCosts."Posted Costs (LCY)" <> 0 THEN BEGIN
    //                   CASE lrc_PackOrderInputCosts."Allocation Batch No." OF
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Packing:
    //                     lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                                      lrc_PackOrderInputCosts."Posted Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                     lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                                      lrc_PackOrderInputCosts."Posted Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Kolli:
    //                     lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                                      lrc_PackOrderInputCosts."Posted Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::"Net Weight":
    //                     lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                                      lrc_PackOrderInputCosts."Posted Costs (LCY)";
    //                   END;
    //                 END;

    //                 // --------------------------------------------------------------------------------
    //                 // Abzurechnende Kosten
    //                 // --------------------------------------------------------------------------------
    //                 IF lrc_PackOrderInputCosts."Chargeable Costs (LCY)" <> 0 THEN BEGIN
    //                   CASE lrc_PackOrderInputCosts."Allocation Batch No." OF
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Packing:
    //                     lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" +
    //                                      lrc_PackOrderInputCosts."Chargeable Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                     lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" +
    //                                      lrc_PackOrderInputCosts."Chargeable Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Kolli:
    //                     lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" +
    //                                      lrc_PackOrderInputCosts."Chargeable Costs (LCY)";
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::"Net Weight":
    //                     lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" +
    //                                      lrc_PackOrderInputCosts."Chargeable Costs (LCY)";
    //                   END;
    //                 END;

    //                 lrc_PackOrderOutputItems.Modify();

    //               UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //             END;
    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //         END;


    //         // ----------------------------------------------------------------------------------------
    //         // Kosten die auf alle Zeilen verteilt werden
    //         // Ressourcen und Kostenkategorien
    //         // ----------------------------------------------------------------------------------------
    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. Line No. Output",0);
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_PackOrderOutputItems.Reset();
    //             lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //             IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //               REPEAT

    //                 // --------------------------------------------------------------------------------
    //                 // Kalkulierte Kosten
    //                 // --------------------------------------------------------------------------------
    //                 IF lrc_PackOrderInputCosts."Calculated Costs (LCY)" <> 0 THEN BEGIN
    //                   CASE lrc_PackOrderInputCosts."Allocation Batch No." OF
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Packing:
    //                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" :=
    //                                   lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" +
    //                                   ROUND((lrc_PackOrderInputCosts."Calculated Costs (LCY)" /
    //                                          lrc_PackOrderHeader."Tot. Qty. Packing Output" *
    //                                          lrc_PackOrderOutputItems."Quantity (PU)"),0.01);

    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Kolli:
    //                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" :=
    //                                  lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" +
    //                                   ROUND((lrc_PackOrderInputCosts."Calculated Costs (LCY)" /
    //                                          lrc_PackOrderHeader."Tot. Qty. Units Output" *
    //                                          lrc_PackOrderOutputItems.Quantity),0.01);

    //                   //180302 rs auskommentiert
    //                   //lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                   //    BEGIN
    //                         // Nicht zulässig!
    //                   //      ERROR(AGILES_LT_TEXT001,lrc_PackOrderInputCosts."Allocation Batch No."::Amount);
    //                   //    END;


    //                   lrc_PackOrderInputCosts."Allocation Batch No."::"Net Weight",
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                     BEGIN
    //                       //-POI-JW 08.10.18
    //                       lr_GLEntry.Reset();
    //                       lr_GLEntry.SETRANGE("Batch Cost Account",lr_GLEntry."Batch Cost Account"::Cost);
    //                       lr_GLEntry.SETRANGE("Batch No.",lrc_PackOrderOutputItems."Batch Variant No.");
    //                       IF lr_GLEntry.FIND('-') THEN BEGIN
    //                       //+POI-JW 08.10.18

    //                         lrc_PackOrderOutputItems.TESTFIELD( "Total Net Weight" );
    //                         // IF lrc_PackOrderOutputItems."Total Net Weight" <> 0 THEN
    //                         lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" :=
    //                                       lrc_PackOrderOutputItems."Amount Cost Calculation (LCY)" +
    //                                       ROUND((lrc_PackOrderInputCosts."Calculated Costs (LCY)" /
    //                                              lrc_PackOrderHeader."Tot. Net Weight Output" *
    //                                              lrc_PackOrderOutputItems."Total Net Weight"),0.01);

    //                       //-POI-JW 08.10.18
    //                       END;
    //                       //+POI-JW 08.10.18
    //                     END;
    //                   END;
    //                 END;

    //                 // --------------------------------------------------------------------------------
    //                 // Gebuchte Kosten
    //                 // --------------------------------------------------------------------------------
    //                 IF lrc_PackOrderInputCosts."Posted Costs (LCY)" <> 0 THEN BEGIN
    //                   CASE lrc_PackOrderInputCosts."Allocation Batch No." OF
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Packing:
    //                       lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" := lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                                   ROUND((lrc_PackOrderInputCosts."Posted Costs (LCY)" /
    //                                          lrc_PackOrderHeader."Tot. Qty. Packing Output" *
    //                                          lrc_PackOrderOutputItems."Quantity (PU)"),0.01);

    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Kolli:
    //                       lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" := lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                                   ROUND((lrc_PackOrderInputCosts."Posted Costs (LCY)" /
    //                                          lrc_PackOrderHeader."Tot. Qty. Units Output" *
    //                                          lrc_PackOrderOutputItems.Quantity),0.01);

    //                   //180302 rs
    //                   //lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                   //    BEGIN
    //                   //      // Nicht zulässig!
    //                   //      ERROR(AGILES_LT_TEXT001,lrc_PackOrderInputCosts."Allocation Batch No."::Amount);
    //                   //    END;

    //                   lrc_PackOrderInputCosts."Allocation Batch No."::"Net Weight",
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                     BEGIN
    //                       //-POI-JW 08.10.18
    //                       lr_GLEntry.Reset();
    //                       lr_GLEntry.SETRANGE("Batch Cost Account",lr_GLEntry."Batch Cost Account"::Cost);
    //                       lr_GLEntry.SETRANGE("Batch No.",lrc_PackOrderOutputItems."Batch Variant No.");
    //                       IF lr_GLEntry.FIND('-') THEN BEGIN
    //                       //+POI-JW 08.10.18
    //                         lrc_PackOrderOutputItems.TESTFIELD( "Total Net Weight" );
    //                         // IF lrc_PackOrderOutputItems."Total Net Weight" <> 0 THEN
    //                           lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" := lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                                       ROUND((lrc_PackOrderInputCosts."Posted Costs (LCY)" /
    //                                              lrc_PackOrderHeader."Tot. Net Weight Output" *
    //                                              lrc_PackOrderOutputItems."Total Net Weight"),0.01);
    //                       //-POI-JW 08.10.18
    //                       END;
    //                       //+POI-JW 08.10.18
    //                     END;
    //                   END;

    //                 END;

    //                 // --------------------------------------------------------------------------------
    //                 // Abzurechnende Kosten
    //                 // --------------------------------------------------------------------------------
    //                 IF lrc_PackOrderInputCosts."Chargeable Costs (LCY)" <> 0 THEN BEGIN
    //                   CASE lrc_PackOrderInputCosts."Allocation Batch No." OF
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Packing:
    //                       lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" :=
    //                                   lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" +
    //                                   ROUND((lrc_PackOrderInputCosts."Chargeable Costs (LCY)" /
    //                                          lrc_PackOrderHeader."Tot. Qty. Packing Output" *
    //                                          lrc_PackOrderOutputItems."Quantity (PU)"),0.01);

    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Kolli:
    //                       lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" :=
    //                                   lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" +
    //                                   ROUND((lrc_PackOrderInputCosts."Chargeable Costs (LCY)" /
    //                                          lrc_PackOrderHeader."Tot. Qty. Units Output" *
    //                                          lrc_PackOrderOutputItems.Quantity),0.01);

    //                   //180302 rs
    //                   //lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                     //  BEGIN
    //                         // Nicht zulässig!
    //                       //  ERROR(AGILES_LT_TEXT001,lrc_PackOrderInputCosts."Allocation Batch No."::Amount);
    //                       //END;
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::"Net Weight",
    //                   lrc_PackOrderInputCosts."Allocation Batch No."::Amount:
    //                       BEGIN
    //                         //-POI-JW 08.10.18
    //                         lr_GLEntry.Reset();
    //                         lr_GLEntry.SETRANGE("Batch Cost Account",lr_GLEntry."Batch Cost Account"::Cost);
    //                         lr_GLEntry.SETRANGE("Batch No.",lrc_PackOrderOutputItems."Batch Variant No.");
    //                         IF lr_GLEntry.FIND('-') THEN BEGIN
    //                         //-POI-JW 08.10.18
    //                           lrc_PackOrderOutputItems.TESTFIELD( "Total Net Weight" );
    //                           // IF lrc_PackOrderOutputItems."Total Net Weight" <> 0 THEN
    //                             lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" :=
    //                                      lrc_PackOrderOutputItems."Amount Chargeable Costs (LCY)" +
    //                                      ROUND((lrc_PackOrderInputCosts."Chargeable Costs (LCY)" /
    //                                             lrc_PackOrderHeader."Tot. Net Weight Output" *
    //                                             lrc_PackOrderOutputItems."Total Net Weight"),0.01);
    //                         //-POI-JW 08.10.18
    //                        END;
    //                         //+POI-JW 08.10.18
    //                       END;
    //                   END;
    //                 END;

    //                 lrc_PackOrderOutputItems.Modify();
    //               UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //             END;
    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //         END;


    //         // ----------------------------------------------------------------------------------------
    //         // Verpackungsartikel für eine bestimmte Zeilen
    //         // ----------------------------------------------------------------------------------------
    //         lrc_PackOrderInputPackItems.Reset();
    //         lrc_PackOrderInputPackItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputPackItems.SETFILTER("Doc. Line No. Output",'<>%1',0);
    //         IF lrc_PackOrderInputPackItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF lrc_PackOrderInputPackItems."Item Typ" = lrc_PackOrderInputPackItems."Item Typ"::"Packing Material" THEN BEGIN
    //                // --------------------------------------------------------------------------------
    //                // Gebuchte Kosten
    //                // --------------------------------------------------------------------------------
    //                lrc_PackOrderOutputItems.Reset();
    //                lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //                lrc_PackOrderOutputItems.SETRANGE("Line No.",lrc_PackOrderInputPackItems."Doc. Line No. Output");
    //                IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //                  REPEAT
    //                    IF (lrc_PackOrderInputPackItems."Quantity Consumed" <> 0) AND
    //                       (lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" <> 0) THEN BEGIN

    //                      CASE lrc_PackOrderInputPackItems."Allocation Batch No." OF
    //                        lrc_PackOrderInputPackItems."Allocation Batch No."::Packing:
    //                          lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                            lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                             ROUND( lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" *
    //                                    lrc_PackOrderInputPackItems."Quantity Consumed" );
    //                        lrc_PackOrderInputPackItems."Allocation Batch No."::Amount:
    //                          lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                             lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                             ROUND( lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" *
    //                                    lrc_PackOrderInputPackItems."Quantity Consumed" );
    //                        lrc_PackOrderInputPackItems."Allocation Batch No."::Kolli:
    //                          lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                             lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                             ROUND( lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" *
    //                                    lrc_PackOrderInputPackItems."Quantity Consumed" );
    //                        lrc_PackOrderInputPackItems."Allocation Batch No."::"Net Weight":
    //                          lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                             lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                             ROUND( lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" *
    //                                    lrc_PackOrderInputPackItems."Quantity Consumed" );
    //                      END;

    //                    END;

    //                    lrc_PackOrderOutputItems.Modify();
    //                  UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //               END;

    //             END;
    //           UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //         END;


    //         // ----------------------------------------------------------------------------------------
    //         // Verpackungsartikel die auf alle Zeilen verteilt werden
    //         // ----------------------------------------------------------------------------------------
    //         lrc_PackOrderInputPackItems.Reset();
    //         lrc_PackOrderInputPackItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputPackItems.SETRANGE("Doc. Line No. Output",0);
    //         IF lrc_PackOrderInputPackItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF lrc_PackOrderInputPackItems."Item Typ" = lrc_PackOrderInputPackItems."Item Typ"::"Packing Material" THEN BEGIN

    //                // --------------------------------------------------------------------------------
    //                // Gebuchte Kosten
    //                // --------------------------------------------------------------------------------
    //                lrc_PackOrderOutputItems.Reset();
    //                lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //                IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //                  REPEAT

    //                    IF (lrc_PackOrderInputPackItems."Quantity Consumed" <> 0) AND
    //                       (lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" <> 0) THEN BEGIN

    //                      CASE lrc_PackOrderInputPackItems."Allocation Batch No." OF
    //                      lrc_PackOrderInputPackItems."Allocation Batch No."::Packing:
    //                        BEGIN
    //                          lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                             lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                             ROUND((ROUND(lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" *
    //                                          lrc_PackOrderInputPackItems."Quantity Consumed" ) /
    //                                          lrc_PackOrderHeader."Tot. Qty. Packing Output" *
    //                                          lrc_PackOrderOutputItems."Quantity (PU)"),0.01);
    //                        END;

    //                      lrc_PackOrderInputPackItems."Allocation Batch No."::Kolli:
    //                        BEGIN
    //                          lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                             lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                             ROUND((ROUND(lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" *
    //                                          lrc_PackOrderInputPackItems."Quantity Consumed" ) /
    //                                          lrc_PackOrderHeader."Tot. Qty. Units Output" *
    //                                          lrc_PackOrderOutputItems.Quantity),0.01);
    //                        END;

    //                      lrc_PackOrderInputPackItems."Allocation Batch No."::Amount:
    //                        BEGIN
    //                          lrc_PackOrderOutputItems.TESTFIELD("Total Net Weight");
    //                          lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                             lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                             ROUND((ROUND(lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" *
    //                                          lrc_PackOrderInputPackItems."Quantity Consumed" ) /
    //                                          lrc_PackOrderHeader."Tot. Net Weight Output" *
    //                                          lrc_PackOrderOutputItems."Total Net Weight"),0.01);
    //                        END;

    //                      lrc_PackOrderInputPackItems."Allocation Batch No."::"Net Weight":
    //                        BEGIN
    //                          lrc_PackOrderOutputItems.TESTFIELD("Total Net Weight");
    //                          lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" :=
    //                             lrc_PackOrderOutputItems."Amount Posted Costs (LCY)" +
    //                             ROUND((ROUND(lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)" *
    //                                          lrc_PackOrderInputPackItems."Quantity Consumed" ) /
    //                                          lrc_PackOrderHeader."Tot. Net Weight Output" *
    //                                          lrc_PackOrderOutputItems."Total Net Weight"),0.01);
    //                        END;

    //                      END;
    //                    END;
    //                    lrc_PackOrderOutputItems.Modify();
    //                  UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //               END;
    //             END;
    //           UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PackereiauftragAbschluss(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         AGILES_LT_TEXT001: Label 'State is not open!';
    //         AGILES_LT_TEXT002: Label 'Input %1 %2 - %3 Menge und Menge verbraucht sind nicht identisch!';
    //         AGILES_LT_TEXT003: Label 'Input Packing %1 %2 - %3 Menge und Menge verbraucht sind nicht identisch!';
    //         AGILES_LT_TEXT004: Label 'Kosten Resourcen %1 %2 - %3 Menge und Menge verbraucht sind nicht identisch!';
    //         AGILES_LT_TEXT005: Label 'Output %1 %2 - %3 Menge und Menge verbraucht sind nicht identisch!';
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Funktion zum Abschluß eines Packereiauftrages
    //         // --------------------------------------------------------------------------------

    //         //RS Prüfung ob Menge Leergut in In- und Outputzeilen identisch
    //         EPSInputOutput(vco_PackOrderNo);

    //         // Gesamtkalkulation
    //         PackCalcStatement(vco_PackOrderNo,TRUE);

    //         // Kopfsatz lesen
    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         // POI 004.S
    //         //IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::Open THEN
    //         //  // Status ist nicht offen!
    //         //  ERROR(AGILES_LT_TEXT001);
    //         IF (lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::Open) AND
    //            (lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::"8") THEN
    //           ERROR(AGILES_LT_TEXT001);
    //         // POI 004.E

    //         lrc_PackOrderHeader.TESTFIELD("Pack.-by Vendor No.");

    //         // -----------------------------------------------------------------------------------
    //         // Kontrolle ob alles gebucht / verbraucht / Produziert ist
    //         // -----------------------------------------------------------------------------------

    //         // Kontrolle Inputzeilen Rohware
    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF lrc_PackOrderInputItems.Quantity <> lrc_PackOrderInputItems."Quantity Consumed" THEN
    //               ERROR(AGILES_LT_TEXT002, lrc_PackOrderInputItems."Line No.",
    //                     lrc_PackOrderInputItems."Item No.",
    //                     lrc_PackOrderInputItems."Batch Variant No.");
    //           UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //         END;

    //         // Kontrolle Inputzeilen Verpackungen
    //         lrc_PackOrderInputPackItems.Reset();
    //         lrc_PackOrderInputPackItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderInputPackItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF lrc_PackOrderInputPackItems.Quantity <> lrc_PackOrderInputPackItems."Quantity Consumed" THEN
    //               ERROR(AGILES_LT_TEXT003, lrc_PackOrderInputPackItems."Line No.",
    //                     lrc_PackOrderInputPackItems."Item No.",
    //                     lrc_PackOrderInputPackItems."Batch Variant No.");
    //           UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //         END;

    //         // Kontrolle Kosten Resourcenzeilen
    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE( "Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF (lrc_PackOrderInputCosts.Type = lrc_PackOrderInputCosts.Type::Resource) AND
    //                (lrc_PackOrderInputCosts.Quantity <> lrc_PackOrderInputCosts."Quantity Consumed") THEN
    //               ERROR(AGILES_LT_TEXT004, lrc_PackOrderInputCosts."Line No.",
    //                     lrc_PackOrderInputCosts."No.",'');
    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //         END;

    //         // Kontrolle Outputzeilen
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF lrc_PackOrderOutputItems.Quantity <> lrc_PackOrderOutputItems."Quantity Produced" THEN
    //               ERROR(AGILES_LT_TEXT005, lrc_PackOrderInputItems."Line No.",
    //                     lrc_PackOrderOutputItems."Item No.",lrc_PackOrderOutputItems."Batch Variant No.");
    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //         END;

    //         // -----------------------------------------------------------------------------------
    //         // Bewertung durchführen
    //         // -----------------------------------------------------------------------------------
    //         ValuationII(vco_PackOrderNo);

    //         // -----------------------------------------------------------------------------------
    //         // Datensatz für Packkostenkontrolle schreiben
    //         // -----------------------------------------------------------------------------------
    //         PackCostsToCostControl(vco_PackOrderNo);

    //         // Status setzen
    //         lrc_PackOrderHeader.Status := lrc_PackOrderHeader.Status::Registered;
    //         lrc_PackOrderHeader.Modify();

    //         // Kalkulatorische Kosten buchen
    //         lrc_RecipePackingSetup.GET();
    //         IF lrc_RecipePackingSetup."Post Calc. Costs By Reg.Order" = TRUE THEN BEGIN
    //           PackCalcCostPosting(lrc_PackOrderHeader."No.")
    //         END;
    //     end;

    //     procedure PackCalcCostPosting(vco_Packereiauftragsnr: Code[20])
    //     var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PackingAllocation: Record "5110721";
    //         lrc_GenJournalLine: Record "81" temporary;
    //         lrc_CostCategory: Record "5110345";
    //         lin_Zeilennr: Integer;
    //         AGILES_LT_TEXT001: Label 'Dimensionsebene nicht zulässig!';
    //         lco_BatchNo: Code[20];
    //         AGILES_LT_TEXT002: Label 'State must be Registered!';
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zum Buchen der kalkulatorischen Kosten
    //         // -----------------------------------------------------------------------------------------

    //         lrc_BatchSetup.GET();

    //         lin_Zeilennr := 0;
    //         lrc_PackOrderHeader.GET(vco_Packereiauftragsnr);
    //         IF lrc_PackOrderHeader.Status <> lrc_PackOrderHeader.Status::Registered THEN
    //           // Status muss Registriert sein!
    //           ERROR(AGILES_LT_TEXT002);

    //         lrc_PackOrderHeader.TESTFIELD("Pack.-by Vendor No.");

    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No." , lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.SETRANGE(Type, lrc_PackOrderInputCosts.Type::"Cost Category");
    //         lrc_PackOrderInputCosts.SETFILTER("No." ,'<>%1','');
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Kostenkategorie lesen
    //             lrc_CostCategory.GET(lrc_PackOrderInputCosts."No.");

    //             IF (lrc_CostCategory."Post Not Imputed Cost" = FALSE) AND
    //                (lrc_PackOrderInputCosts."Date of Posting" = 0D) AND
    //                (lrc_PackOrderInputCosts."Chargeable Costs (LCY)" <> 0) THEN BEGIN

    //               // -----------------------------------------------------------------------
    //               // Kontierungssatz lesen
    //               // -----------------------------------------------------------------------
    //               lrc_PackingAllocation.Reset();
    //               lrc_PackingAllocation.SETRANGE("Vendor No.", lrc_PackOrderHeader."Pack.-by Vendor No.");
    //               lrc_PackingAllocation.SETRANGE("Cost Category Code", lrc_PackOrderInputCosts."No.");
    //               IF NOT lrc_PackingAllocation.FIND('-') THEN BEGIN
    //                 lrc_PackingAllocation.Reset();
    //                 lrc_PackingAllocation.SETRANGE("Vendor No.", '');
    //                 lrc_PackingAllocation.SETRANGE("Cost Category Code", lrc_PackOrderInputCosts."No.");
    //                 IF NOT lrc_PackingAllocation.FIND('-') THEN BEGIN
    //                   lrc_PackingAllocation.Reset();
    //                   lrc_PackingAllocation.SETRANGE("Vendor No.", lrc_PackOrderHeader."Pack.-by Vendor No.");
    //                   lrc_PackingAllocation.SETRANGE("Cost Category Code", '');
    //                   lrc_PackingAllocation.FIND('-');
    //                 END;
    //               END;

    //               // -----------------------------------------------------------------------
    //               // Buchungssatz erstellen
    //               // -----------------------------------------------------------------------
    //               lrc_PackingAllocation.TESTFIELD("G/L Account No.");
    //               lrc_PackingAllocation.TESTFIELD("Bal. G/L Account No.");

    //               lrc_GenJournalLine.Reset();
    //               lrc_GenJournalLine.INIT();
    //               lin_Zeilennr := lin_Zeilennr + 10000;
    //               lrc_GenJournalLine."Line No." := lin_Zeilennr;
    //               IF lrc_PackOrderHeader."Posting Date" <> 0D THEN
    //                 lrc_GenJournalLine.VALIDATE("Posting Date",lrc_PackOrderHeader."Posting Date")
    //               ELSE
    //                 lrc_GenJournalLine.VALIDATE("Posting Date",TODAY);
    //               lrc_GenJournalLine."Document No." := lrc_PackOrderHeader."No.";

    //               lrc_GenJournalLine.VALIDATE("Account Type", lrc_GenJournalLine."Account Type"::"G/L Account");
    //               lrc_GenJournalLine.VALIDATE("Account No.", lrc_PackingAllocation."G/L Account No." );

    //               lrc_GenJournalLine.VALIDATE("Bal. Account Type", lrc_GenJournalLine."Bal. Account Type"::"G/L Account" );
    //               lrc_GenJournalLine.VALIDATE("Bal. Account No.", lrc_PackingAllocation."Bal. G/L Account No." );

    //               IF lrc_PackingAllocation."Amout Deb./Cred." = lrc_PackingAllocation."Amout Deb./Cred."::Soll THEN BEGIN
    //                 IF lrc_PackingAllocation."Turn Sign" = TRUE THEN BEGIN
    //                   lrc_GenJournalLine.VALIDATE("Debit Amount", lrc_PackOrderInputCosts."Chargeable Costs (LCY)" * -1);
    //                 END ELSE BEGIN
    //                   lrc_GenJournalLine.VALIDATE("Debit Amount", lrc_PackOrderInputCosts."Chargeable Costs (LCY)");
    //                 END;
    //               END ELSE BEGIN
    //                 IF lrc_PackingAllocation."Turn Sign" = TRUE THEN BEGIN
    //                   lrc_GenJournalLine.VALIDATE("Credit Amount", lrc_PackOrderInputCosts."Chargeable Costs (LCY)" * -1);
    //                 END ELSE BEGIN
    //                   lrc_GenJournalLine.VALIDATE("Credit Amount", lrc_PackOrderInputCosts."Chargeable Costs (LCY)");
    //                 END;
    //               END;

    //               IF lrc_PackingAllocation."Posting Description" <> '' THEN BEGIN
    //                 lrc_GenJournalLine.Description := lrc_PackingAllocation."Posting Description";
    //               END ELSE BEGIN
    //                 lrc_GenJournalLine.Description := 'Kosten Packerei ' + lrc_PackingAllocation."Cost Category Code";
    //               END;

    //               lrc_GenJournalLine."Source Type" := lrc_GenJournalLine."Source Type"::Vendor;
    //               lrc_GenJournalLine."Source No." := lrc_PackOrderHeader."Pack.-by Vendor No.";

    //               lco_BatchNo := '';
    //               lrc_PackOrderOutputItems.Reset();
    //               lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //               // PAC 009 00000000.s
    //               // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //               //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //               lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                                  lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //               // PAC 009 00000000.e
    //               IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   IF lrc_PackOrderOutputItems."Batch No." <> '' THEN BEGIN
    //                     lco_BatchNo := lrc_PackOrderOutputItems."Batch No.";
    //                   END;
    //                 UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //               END;

    //               CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                 lrc_BatchSetup."Dim. No. Batch No."::" ":
    //                   BEGIN
    //                   END;
    //                 lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                   lrc_GenJournalLine.VALIDATE("Shortcut Dimension 1 Code",  lco_BatchNo );
    //                 lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                   lrc_GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", lco_BatchNo );
    //                 lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                   lrc_GenJournalLine.VALIDATE("Shortcut Dimension 3 Code", lco_BatchNo );
    //                 lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                   lrc_GenJournalLine.VALIDATE("Shortcut Dimension 4 Code", lco_BatchNo );
    //                 ELSE
    //                   // Dimensionsebene nicht zulässig!
    //                   ERROR(AGILES_LT_TEXT001);
    //               END;

    //               lrc_GenJournalLine.insert();

    //               // -----------------------------------------------------------------------
    //               // Buchen
    //               // -----------------------------------------------------------------------
    //               CODEUNIT.RUN(12,lrc_GenJournalLine);

    //               lrc_PackOrderInputCosts."Date of Posting" := TODAY;
    //               lrc_PackOrderInputCosts."Userid of Posting" := USERID;
    //               lrc_PackOrderInputCosts.Modify();

    //             END;

    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;
    //         END;
    //     end;

    //     procedure Valuation(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_ItemLedgerEntry: Record "32";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_ValueEntry: Record "5802";
    //         lrc_ValueEntry2: Record "5802";
    //         ldc_SumEk: Decimal;
    //         ldc_SumMEK: Decimal;
    //         ldc_SumCost: Decimal;
    //         ldc_QtyPostedOutput: Decimal;
    //         ldc_CostActual: Decimal;
    //         ldc_CostActualBase: Decimal;
    //         ldc_MarketCostActualBase: Decimal;
    //         lin_EntryNo: Integer;
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         ldc_EK: Decimal;
    //         lrc_Vendor: Record "Vendor";
    //     begin
    //         // --------------------------------------------------------------------------------------------
    //         // Bewertung durchführen
    //         // --------------------------------------------------------------------------------------------


    //         ldc_SumEk := 0;
    //         ldc_SumMEK := 0;
    //         ldc_SumCost := 0;

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);

    //         // Input Posten
    //         lrc_ItemLedgerEntry.Reset();
    //         lrc_ItemLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
    //         lrc_ItemLedgerEntry.SETRANGE("Document No.",lrc_PackOrderHeader."No.");
    //         lrc_ItemLedgerEntry.SETFILTER("Entry Type",'%1|%2',lrc_ItemLedgerEntry."Entry Type"::"Positive Adjmt.",
    //                                                            lrc_ItemLedgerEntry."Entry Type"::"Negative Adjmt.");
    //         lrc_ItemLedgerEntry.SETRANGE("Source Doc. Type",lrc_ItemLedgerEntry."Source Doc. Type"::"Input Packing Order");
    //         lrc_ItemLedgerEntry.SETRANGE("Source Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_ItemLedgerEntry.FIND('-') THEN
    //           REPEAT

    //         /*
    //             ldc_SumEk := ldc_SumEk + (lrc_ItemLedgerEntry."Cost Amount" * -1);
    //         */

    //             ldc_SumMEK := ldc_SumMEK + (lrc_ItemLedgerEntry."Market Cost Amount" * -1);

    //             IF ( lrc_ItemLedgerEntry."Batch No." <> '' ) AND
    //                ( lrc_ItemLedgerEntry."Batch Variant No." <> '' ) THEN BEGIN
    //                IF ( lrc_Batch.GET( lrc_ItemLedgerEntry."Batch No." ) ) AND
    //                   ( lrc_BatchVariant.GET( lrc_ItemLedgerEntry."Batch Variant No." )) THEN BEGIN
    //                  lrc_Batch.CALCFIELDS("Purch. Rec. (Qty) (Base)","Purch. Order (Qty) (Base)","Cost Calc. Amount (LCY)",
    //                                       "Posted Cost Amount","P.O. Amount (LCY)", "P.O. Line Discount Amt. (LCY)",
    //                                       "Pur. Amount (Actual)",
    //                                       "Pur. Amount (Expected)", "Pur. Rg.Rab. ohne Wbz.", "Pur. Accruel Inv. Disc. (Ext)",
    //                                       "Pur. Accruel Inv. Disc. (Int)");

    //                  IF lrc_Batch."Purch. Order (Qty) (Base)" <> 0 THEN BEGIN
    //                    ldc_EK := lrc_Batch."P.O. Amount (LCY)";
    //                    ldc_EK := ldc_EK - lrc_Batch."P.O. Line Discount Amt. (LCY)";
    //                  END ELSE BEGIN
    //                    ldc_EK := lrc_Batch."Pur. Amount (Actual)" +
    //                                        lrc_Batch."Pur. Amount (Expected)";

    //                    ldc_EK := ldc_EK - lrc_Batch."Pur. Rg.Rab. ohne Wbz." -
    //                                                           lrc_Batch."Pur. Accruel Inv. Disc. (Ext)" -
    //                                                           lrc_Batch."Pur. Accruel Inv. Disc. (Int)";
    //                  END;

    //                  lrc_Vendor.Reset();
    //                  IF NOT lrc_Vendor.GET(lrc_BatchVariant."Vendor No.") THEN
    //                    lrc_Vendor.INIT();

    //                  IF lrc_Batch."Pur. Amount (Actual)" = 0 THEN BEGIN
    //                    IF (lrc_BatchVariant."Kind of Settlement" <> lrc_BatchVariant."Kind of Settlement"::"Fix Price") AND
    //                       (lrc_Vendor."A.S. Commission Fee %" <> 0) THEN BEGIN
    //                      ldc_EK := ldc_EK - (ldc_EK * (lrc_Vendor."A.S. Commission Fee %"/100));
    //                    END;
    //                  END ELSE BEGIN
    //                    IF lrc_Batch."Cost Calc. Amount (LCY)" > lrc_Batch."Posted Cost Amount" THEN
    //                      ldc_EK := ldc_EK + lrc_Batch."Cost Calc. Amount (LCY)"
    //                    ELSE
    //                      ldc_EK := ldc_EK + lrc_Batch."Posted Cost Amount";
    //                  END;

    //                  IF (lrc_Batch."Purch. Rec. (Qty) (Base)" + lrc_Batch."Purch. Order (Qty) (Base)") <> 0 THEN
    //                    ldc_EK := ldc_EK / (lrc_Batch."Purch. Rec. (Qty) (Base)" + lrc_Batch."Purch. Order (Qty) (Base)")
    //                  ELSE
    //                    ldc_EK := 0;

    //                END;
    //             END;

    //             IF ldc_EK <> 0 THEN BEGIN
    //              ldc_SumEk := ldc_SumEk + ( ldc_EK * ABS( lrc_ItemLedgerEntry.Quantity ) );
    //             END ELSE BEGIN
    //               lrc_ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
    //               ldc_SumEk := ldc_SumEk + (lrc_ItemLedgerEntry."Cost Amount (Expected)" * -1) +
    //                                      (lrc_ItemLedgerEntry."Cost Amount (Actual)" * -1);
    //             END;

    //           UNTIL lrc_ItemLedgerEntry.NEXT() = 0;


    //         // Kostenposten --> Verteilung auf Output fehlt noch
    //         ldc_SumCost := 0;
    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.SETRANGE(Type,lrc_PackOrderInputCosts.Type::"Cost Category");
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN
    //           REPEAT
    //             ldc_SumCost := ldc_SumCost + lrc_PackOrderInputCosts."Amount (LCY)";
    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;

    //         // Ressourcenposten




    //         // Output Tafelware
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         lrc_PackOrderOutputItems.SETFILTER("Item No.",'<>%1','');
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           REPEAT
    //             ldc_QtyPostedOutput := ldc_QtyPostedOutput + lrc_PackOrderOutputItems."Quantity Produced (Base)";
    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

    //         IF ldc_QtyPostedOutput = 0 THEN
    //           EXIT;

    //         ldc_CostActualBase := ROUND((ldc_SumEk + ldc_SumCost) / ldc_QtyPostedOutput,0.00001);
    //         ldc_MarketCostActualBase := ROUND((ldc_SumMEK + ldc_SumCost) / ldc_QtyPostedOutput,0.00001);


    //         // Output Posten
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           REPEAT

    //             lrc_ItemLedgerEntry.Reset();
    //             lrc_ItemLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
    //             lrc_ItemLedgerEntry.SETRANGE("Document No.",lrc_PackOrderHeader."No.");
    //             lrc_ItemLedgerEntry.SETFILTER("Entry Type",'%1|%2',lrc_ItemLedgerEntry."Entry Type"::"Positive Adjmt.",
    //                                                               lrc_ItemLedgerEntry."Entry Type"::"Negative Adjmt.");
    //             lrc_ItemLedgerEntry.SETRANGE("Source Doc. Type",lrc_ItemLedgerEntry."Source Doc. Type"::"Output Packing Order");
    //             lrc_ItemLedgerEntry.SETRANGE("Source Doc. No.",lrc_PackOrderHeader."No.");
    //             lrc_ItemLedgerEntry.SETRANGE("Source Doc. Line No.",lrc_PackOrderOutputItems."Line No.");
    //             IF lrc_ItemLedgerEntry.FIND('-') THEN
    //               REPEAT
    //                 lrc_ValueEntry2.LOCKTABLE;

    //                 lrc_ValueEntry2.Reset();
    //                 IF lrc_ValueEntry2.FIND('+') THEN
    //                   lin_EntryNo := lrc_ValueEntry2."Entry No." + 1
    //                 ELSE
    //                   lin_EntryNo := 1;

    //                 lrc_ItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");

    //                 IF lrc_ItemLedgerEntry."Cost Amount (Actual)" <>
    //                    (ROUND(lrc_ItemLedgerEntry.Quantity * ldc_CostActualBase,0.00001)) THEN BEGIN

    //                   lrc_ValueEntry.Reset();
    //                   lrc_ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Expected Cost");
    //                   lrc_ValueEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //                   lrc_ValueEntry.FIND('-');

    //                   lrc_ValueEntry2 := lrc_ValueEntry;
    //                   lrc_ValueEntry2."Entry No." := lin_EntryNo;
    //                   lrc_ValueEntry2."Posting Date" := TODAY;
    //                   lrc_ValueEntry2."Cost Amount (Actual)" := (ROUND(lrc_ItemLedgerEntry.Quantity * ldc_CostActualBase,0.00001)) -
    //                                                             lrc_ItemLedgerEntry."Cost Amount (Actual)";
    //                   lrc_ValueEntry2.Description := 'Bewertung Packerei';

    //                   lrc_ValueEntry2.Adjustment := FALSE;
    //                   lrc_ValueEntry2."User ID" := USERID;
    //                   lrc_ValueEntry2.insert();

    //                 END;

    //                 // Werte in Artikelposten aktualisieren
    //                 lrc_ItemLedgerEntry."Cost Amount" := ROUND(lrc_ItemLedgerEntry.Quantity * ldc_CostActualBase,0.00001);
    //                 lrc_ItemLedgerEntry."Market Cost Amount" := ROUND(lrc_ItemLedgerEntry.Quantity * ldc_MarketCostActualBase,0.00001);
    //                 lrc_ItemLedgerEntry.Modify();

    //               UNTIL lrc_ItemLedgerEntry.NEXT() = 0;



    //             IF ldc_QtyPostedOutput <> 0 THEN BEGIN
    //               lrc_PackOrderOutputItems."Unit Cost Price (Input)" := ldc_CostActualBase;
    //               lrc_PackOrderOutputItems."Market Cost Price (Input)" := ldc_MarketCostActualBase;
    //             END ELSE BEGIN
    //               lrc_PackOrderOutputItems."Unit Cost Price (Input)" := 0;
    //               lrc_PackOrderOutputItems."Market Cost Price (Input)" := 0;
    //             END;
    //             lrc_PackOrderOutputItems.Modify();

    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

    //     end;

    //     procedure ValuationII(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_ItemLedgerEntry: Record "32";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_ValueEntry: Record "5802";
    //         lrc_ValueEntry2: Record "5802";
    //         ldc_SumEk: Decimal;
    //         ldc_SumMEK: Decimal;
    //         ldc_SumCost: Decimal;
    //         ldc_QtyPostedOutput: Decimal;
    //         ldc_CostActual: Decimal;
    //         ldc_CostActualBase: Decimal;
    //         ldc_MarketCostActualBase: Decimal;
    //         lin_EntryNo: Integer;
    //         lrc_Batch: Record "5110365";
    //         lrc_BatchVariant: Record "5110366";
    //         ldc_EK: Decimal;
    //         lrc_Vendor: Record "Vendor";
    //         "--- DMG 002 DMG50307": Integer;
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_PackOrderInputPackItems: Record "5110715";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lbn_EKFromItemLedgerEntry: Boolean;
    //         "-- DMG 003 DMG50307": Integer;
    //         lrc_PriceBase: Record "5110320";
    //     begin
    //         // --------------------------------------------------------------------------------------------
    //         // Bewertung durchführen
    //         // --------------------------------------------------------------------------------------------

    //         ldc_SumEk := 0;
    //         ldc_SumMEK := 0;
    //         ldc_SumCost := 0;

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);

    //         // DMG 002 DMG50307.s
    //         lrc_FruitVisionSetup.GET();
    //         lbn_EKFromItemLedgerEntry := TRUE;
    //         //IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //            ldc_SumEk := 0;
    //            lrc_PackOrderInputPackItems.Reset();
    //            lrc_PackOrderInputPackItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //            IF lrc_PackOrderInputPackItems.FINDSET() THEN BEGIN
    //              REPEAT
    //                 ldc_SumEk := ldc_SumEk + ( lrc_PackOrderInputPackItems."Quantity Consumed" *
    //                                            lrc_PackOrderInputPackItems."Direct Unit Cost (LCY)");
    //              UNTIL lrc_PackOrderInputPackItems.NEXT() = 0;
    //            END;

    //            lrc_PackOrderInputItems.Reset();
    //            lrc_PackOrderInputItems.SETRANGE( "Doc. No.", lrc_PackOrderHeader."No." );
    //            IF lrc_PackOrderInputItems.FINDSET() THEN BEGIN
    //              REPEAT
    //                 ldc_SumEk := ldc_SumEk + ( lrc_PackOrderInputItems."Quantity Consumed" *
    //                                            lrc_PackOrderInputItems."Direct Unit Cost (LCY)");
    //              UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //            END;

    //            ldc_SumEk := ROUND( ldc_SumEk, 0.00001 );

    //            IF ldc_SumEk <> 0 THEN BEGIN
    //              lbn_EKFromItemLedgerEntry := FALSE;
    //            END;

    //         //END;
    //         IF lbn_EKFromItemLedgerEntry = TRUE THEN BEGIN
    //         // DMG 002 DMG50307.e

    //           // Input Posten
    //           lrc_ItemLedgerEntry.Reset();
    //           lrc_ItemLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
    //           lrc_ItemLedgerEntry.SETRANGE("Document No.",lrc_PackOrderHeader."No.");
    //           lrc_ItemLedgerEntry.SETFILTER("Entry Type",'%1|%2',lrc_ItemLedgerEntry."Entry Type"::"Positive Adjmt.",
    //                                                              lrc_ItemLedgerEntry."Entry Type"::"Negative Adjmt.");
    //           lrc_ItemLedgerEntry.SETRANGE("Source Doc. Type",lrc_ItemLedgerEntry."Source Doc. Type"::"Input Packing Order");
    //           lrc_ItemLedgerEntry.SETRANGE("Source Doc. No.",lrc_PackOrderHeader."No.");
    //           IF lrc_ItemLedgerEntry.FIND('-') THEN BEGIN
    //             REPEAT

    //         /*
    //               ldc_SumEk := ldc_SumEk + (lrc_ItemLedgerEntry."Cost Amount" * -1);
    //         */

    //               ldc_SumMEK := ldc_SumMEK + (lrc_ItemLedgerEntry."Market Cost Amount" * -1);

    //               IF ( lrc_ItemLedgerEntry."Batch No." <> '' ) AND
    //                  ( lrc_ItemLedgerEntry."Batch Variant No." <> '' ) THEN BEGIN
    //                  IF ( lrc_Batch.GET( lrc_ItemLedgerEntry."Batch No." ) ) AND
    //                     ( lrc_BatchVariant.GET( lrc_ItemLedgerEntry."Batch Variant No." )) THEN BEGIN
    //                    lrc_Batch.CALCFIELDS("Purch. Rec. (Qty) (Base)","Purch. Order (Qty) (Base)","Cost Calc. Amount (LCY)",
    //                                         "Posted Cost Amount","P.O. Amount (LCY)", lrc_Batch."Pur. Inv. Disc. (Act)",
    //                                         "Pur. Amount (Actual)",
    //                                         "Pur. Amount (Expected)", "Pur. Rg.Rab. ohne Wbz.", "Pur. Accruel Inv. Disc. (Ext)",
    //                                         "Pur. Accruel Inv. Disc. (Int)");

    //                    IF lrc_Batch."Purch. Order (Qty) (Base)" <> 0 THEN BEGIN
    //                      ldc_EK := lrc_Batch."P.O. Amount (LCY)";
    //                      ldc_EK := ldc_EK - lrc_Batch."P.O. Line Discount Amt. (LCY)";
    //                    END ELSE BEGIN
    //                      ldc_EK := lrc_Batch."Pur. Amount (Actual)" +
    //                                          lrc_Batch."Pur. Amount (Expected)";

    //                      ldc_EK := ldc_EK - lrc_Batch."Pur. Rg.Rab. ohne Wbz." -
    //                                                             lrc_Batch."Pur. Accruel Inv. Disc. (Ext)" -
    //                                                             lrc_Batch."Pur. Accruel Inv. Disc. (Int)";
    //                    END;

    //                    lrc_Vendor.Reset();
    //                    IF NOT lrc_Vendor.GET(lrc_BatchVariant."Vendor No.") THEN
    //                      lrc_Vendor.INIT();

    //                    IF lrc_Batch."Pur. Amount (Actual)" = 0 THEN BEGIN
    //                      IF (lrc_BatchVariant."Kind of Settlement" <> lrc_BatchVariant."Kind of Settlement"::"Fix Price") AND
    //                         (lrc_Vendor."A.S. Commission Fee %" <> 0) THEN BEGIN
    //                        ldc_EK := ldc_EK - (ldc_EK * (lrc_Vendor."A.S. Commission Fee %"/100));
    //                      END;
    //                    END ELSE BEGIN
    //                      IF lrc_Batch."Cost Calc. Amount (LCY)" > lrc_Batch."Posted Cost Amount" THEN
    //                        ldc_EK := ldc_EK + lrc_Batch."Cost Calc. Amount (LCY)"
    //                      ELSE
    //                        ldc_EK := ldc_EK + lrc_Batch."Posted Cost Amount";
    //                    END;

    //                    IF (lrc_Batch."Purch. Rec. (Qty) (Base)" + lrc_Batch."Purch. Order (Qty) (Base)") <> 0 THEN
    //                      ldc_EK := ldc_EK / (lrc_Batch."Purch. Rec. (Qty) (Base)" + lrc_Batch."Purch. Order (Qty) (Base)")
    //                    ELSE
    //                      ldc_EK := 0;

    //                  END;
    //               END;

    //               IF ldc_EK <> 0 THEN BEGIN
    //                ldc_SumEk := ldc_SumEk + ( ldc_EK * ABS( lrc_ItemLedgerEntry.Quantity ) );
    //               END ELSE BEGIN
    //                 lrc_ItemLedgerEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
    //                 ldc_SumEk := ldc_SumEk + (lrc_ItemLedgerEntry."Cost Amount (Expected)" * -1) +
    //                                        (lrc_ItemLedgerEntry."Cost Amount (Actual)" * -1);
    //               END;

    //             UNTIL lrc_ItemLedgerEntry.NEXT() = 0;
    //           END;
    //         // DMG 002 DMG50307.s
    //         END;
    //         // DMG 002 DMG50307.e

    //         // Kostenposten --> Verteilung auf Output fehlt noch
    //         ldc_SumCost := 0;
    //         lrc_PackOrderInputCosts.Reset();
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderInputCosts.SETRANGE(Type,lrc_PackOrderInputCosts.Type::"Cost Category");
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN
    //           REPEAT
    //             ldc_SumCost := ldc_SumCost + lrc_PackOrderInputCosts."Amount (LCY)";
    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;

    //         // Ressourcenposten

    //         // Output Tafelware
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         lrc_PackOrderOutputItems.SETFILTER("Item No.",'<>%1','');
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             ldc_QtyPostedOutput := ldc_QtyPostedOutput + lrc_PackOrderOutputItems."Quantity Produced (Base)";
    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //         END;

    //         IF ldc_QtyPostedOutput = 0 THEN
    //           EXIT;

    //         ldc_CostActualBase := ROUND((ldc_SumEk + ldc_SumCost) / ldc_QtyPostedOutput,0.00001);
    //         ldc_MarketCostActualBase := ROUND((ldc_SumMEK + ldc_SumCost) / ldc_QtyPostedOutput,0.00001);

    //         // DMG 003 DMG50307.s
    //         //IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //           IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //             IF lrc_PackOrderOutputItems.COUNT() = 1 THEN BEGIN

    //               lrc_PackOrderOutputItems.Einstandsbetrag := ROUND( ( ldc_CostActualBase * ldc_QtyPostedOutput ), 0.01 );

    //               lrc_PackOrderOutputItems.MODIFY( TRUE );

    //               IF lrc_PackOrderOutputItems."Batch Variant No." <> '' THEN BEGIN
    //                 IF lrc_BatchVariant.GET( lrc_PackOrderOutputItems."Batch Variant No." ) THEN BEGIN
    //                    lrc_PriceBase.Reset();
    //                    lrc_PriceBase.SETRANGE( "Purch./Sales Price Calc.", lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price" );
    //                    lrc_PriceBase.SETRANGE( "Internal Calc. Type", lrc_PriceBase."Internal Calc. Type"::"Collo Unit" );
    //                    IF lrc_PriceBase.FINDFIRST() THEN BEGIN
    //                      lrc_BatchVariant."Price Base (Purch. Price)" := lrc_PriceBase.Code;
    //                      lrc_BatchVariant."Purch. Price (Price Base)" := ldc_CostActualBase;
    //                      lrc_BatchVariant.Modify();
    //                    END;
    //                 END;
    //               END;

    //             END;
    //           END;
    //         //END;
    //         // DMG 003 DMG50307.e

    //         // Output Posten
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           REPEAT

    //             lrc_ItemLedgerEntry.Reset();
    //             lrc_ItemLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
    //             lrc_ItemLedgerEntry.SETRANGE("Document No.",lrc_PackOrderHeader."No.");
    //             lrc_ItemLedgerEntry.SETFILTER("Entry Type",'%1|%2',lrc_ItemLedgerEntry."Entry Type"::"Positive Adjmt.",
    //                                                               lrc_ItemLedgerEntry."Entry Type"::"Negative Adjmt.");
    //             lrc_ItemLedgerEntry.SETRANGE("Source Doc. Type",lrc_ItemLedgerEntry."Source Doc. Type"::"Output Packing Order");
    //             lrc_ItemLedgerEntry.SETRANGE("Source Doc. No.",lrc_PackOrderHeader."No.");
    //             lrc_ItemLedgerEntry.SETRANGE("Source Doc. Line No.",lrc_PackOrderOutputItems."Line No.");
    //             IF lrc_ItemLedgerEntry.FIND('-') THEN
    //               REPEAT
    //                 lrc_ValueEntry2.LOCKTABLE;

    //                 lrc_ValueEntry2.Reset();
    //                 IF lrc_ValueEntry2.FIND('+') THEN
    //                   lin_EntryNo := lrc_ValueEntry2."Entry No." + 1
    //                 ELSE
    //                   lin_EntryNo := 1;

    //                 lrc_ItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");

    //                 IF lrc_ItemLedgerEntry."Cost Amount (Actual)" <>
    //                    (ROUND(lrc_ItemLedgerEntry.Quantity * ldc_CostActualBase,0.00001)) THEN BEGIN

    //                   lrc_ValueEntry.Reset();
    //                   lrc_ValueEntry.SETCURRENTKEY("Item Ledger Entry No.","Expected Cost");
    //                   lrc_ValueEntry.SETRANGE("Item Ledger Entry No.",lrc_ItemLedgerEntry."Entry No.");
    //                   lrc_ValueEntry.FIND('-');

    //                   lrc_ValueEntry2 := lrc_ValueEntry;
    //                   lrc_ValueEntry2."Entry No." := lin_EntryNo;
    //                   lrc_ValueEntry2."Posting Date" := TODAY;
    //                   lrc_ValueEntry2."Cost Amount (Actual)" := (ROUND(lrc_ItemLedgerEntry.Quantity * ldc_CostActualBase,0.00001)) -
    //                                                             lrc_ItemLedgerEntry."Cost Amount (Actual)";
    //                   lrc_ValueEntry2.Description := 'Bewertung Packerei';

    //                   lrc_ValueEntry2.Adjustment := FALSE;
    //                   lrc_ValueEntry2."User ID" := USERID;
    //                   lrc_ValueEntry2.insert();

    //                 END;

    //                 // Werte in Artikelposten aktualisieren
    //                 lrc_ItemLedgerEntry."Cost Amount" := ROUND(lrc_ItemLedgerEntry.Quantity * ldc_CostActualBase,0.00001);
    //                 lrc_ItemLedgerEntry."Market Cost Amount" := ROUND(lrc_ItemLedgerEntry.Quantity * ldc_MarketCostActualBase,0.00001);
    //                 lrc_ItemLedgerEntry.Modify();

    //               UNTIL lrc_ItemLedgerEntry.NEXT() = 0;



    //             IF ldc_QtyPostedOutput <> 0 THEN BEGIN
    //               lrc_PackOrderOutputItems."Unit Cost Price (Input)" := ldc_CostActualBase;
    //               lrc_PackOrderOutputItems."Market Cost Price (Input)" := ldc_MarketCostActualBase;
    //             END ELSE BEGIN
    //               lrc_PackOrderOutputItems."Unit Cost Price (Input)" := 0;
    //               lrc_PackOrderOutputItems."Market Cost Price (Input)" := 0;
    //             END;
    //             lrc_PackOrderOutputItems.Modify();

    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

    //     end;

    //     procedure CalcRevPerBatchPerPostingDate(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderRevenues: Record "5110717";
    //         lrc_PackOrderRevperInpBatch: Record "5110726";
    //         lrc_Customer: Record "Customer";
    //         lrc_PackCost: Record "5110716";
    //         ldc_PackCost: Decimal;
    //         ldc_PackCostPerBaseUnit: Decimal;
    //         AGILES_LT_001: Label 'PACKVERLUST';
    //         "***POI60049 + port.jst": Integer;
    //         ldc_FaktorInOut: Decimal;
    //         lcu_Port_Sales: Codeunit "5110797";
    //         ldc_QuantityInput: Decimal;
    //         ldc_QuantityInputBase: Decimal;
    //         ldc_QuantityOutput: Decimal;
    //         ldc_QuantityOutputBAse: Decimal;
    //         lbn_PackCostAllocation: Boolean;
    //         ldc_PackInputQuantity: Decimal;
    //         ldc_PackCostTemp: Decimal;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Berechnung Umsatz pro Beleg auf die Input-Positionen verteilen
    //         // ------------------------------------------------------------------------------------
    //         //rrrr
    //         lrc_RecipePackingSetup.GET();

    //         lrc_PackOrderHeader.GET(vco_PackOrderNo);
    //         lrc_PackOrderHeader.CALCFIELDS("Tot. Calc. Costs","Tot. Posted Costs","Tot. Acc. Costs","Tot. Qty. Input (Base)");
    //         IF lrc_PackOrderHeader."Tot. Acc. Costs" <> 0 THEN
    //           ldc_PackCost := lrc_PackOrderHeader."Tot. Acc. Costs"
    //         ELSE
    //           ldc_PackCost := lrc_PackOrderHeader."Tot. Calc. Costs";

    //         //180228 rs Packkosten nur auf Partien mit Erlösanteil
    //         // Packkosten pro Inputeinheit
    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.", vco_PackOrderNo);
    //         lrc_PackOrderInputItems.SETRANGE("No Revenue", TRUE);
    //         IF NOT lrc_PackOrderInputItems.FINDSET(FALSE, FALSE) THEN BEGIN
    //           IF lrc_PackOrderHeader."Tot. Qty. Input (Base)" <> 0 THEN
    //             ldc_PackCostPerBaseUnit := ldc_PackCost / lrc_PackOrderHeader."Tot. Qty. Input (Base)"
    //           ELSE
    //             ldc_PackCostPerBaseUnit := 0;
    //         END ELSE BEGIN
    //           lrc_PackOrderInputItems.SETRANGE("No Revenue", FALSE);
    //           REPEAT
    //             ldc_PackInputQuantity += lrc_PackOrderInputItems."Quantity (Base)";
    //           UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //           IF lrc_PackOrderHeader."Tot. Qty. Input (Base)" <> 0 THEN
    //             ldc_PackCostPerBaseUnit := ldc_PackCost / ldc_PackInputQuantity
    //           ELSE
    //             ldc_PackCostPerBaseUnit := 0;
    //         END;
    //         //180228 rs.e

    //         //Packkostenaufteilung auf Inputposition
    //         lrc_PackCost.SETRANGE("Doc. No.", vco_PackOrderNo);
    //         lrc_PackCost.SETRANGE("Kosten auf Inputposition", TRUE);
    //         IF lrc_PackCost.FINDFIRST() THEN
    //           lbn_PackCostAllocation := TRUE;

    //         // Sätze löschen
    //         lrc_PackOrderRevperInpBatch.Reset();
    //         lrc_PackOrderRevperInpBatch.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         lrc_PackOrderRevperInpBatch.DELETEALL();

    //         // Input Item lesen
    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Kein Erlös für die Inputzeile
    //             IF lrc_PackOrderInputItems."No Revenue" = TRUE THEN BEGIN

    //               lrc_RecipePackingSetup.TESTFIELD("Default Cust.-No. Verderb");

    //               // Dummy Umsatzsatz erzeugen mit den Packkosten
    //               lrc_PackOrderRevperInpBatch.Reset();
    //               lrc_PackOrderRevperInpBatch.INIT();
    //               lrc_PackOrderRevperInpBatch."Doc. No." := lrc_PackOrderInputItems."Doc. No.";
    //               lrc_PackOrderRevperInpBatch."Doc. Line No. Output" := lrc_PackOrderInputItems."Doc. Line No. Output";
    //               lrc_PackOrderRevperInpBatch."Doc. Line No. Input" := lrc_PackOrderInputItems."Line No.";
    //               lrc_PackOrderRevperInpBatch."Line No." := 0;

    //               lrc_PackOrderRevperInpBatch."Posting Doc. No." := AGILES_LT_001;
    //               lrc_PackOrderRevperInpBatch."Posting Date" := lrc_PackOrderInputItems."Date of Posting";

    //               lrc_PackOrderRevperInpBatch."Shipment Date" := lrc_PackOrderInputItems."Date of Posting";
    //               lrc_PackOrderRevperInpBatch."Promised Delivery Date" := lrc_PackOrderInputItems."Date of Posting";

    //               lrc_PackOrderRevperInpBatch."Item No." := lrc_PackOrderInputItems."Item No.";
    //               lrc_PackOrderRevperInpBatch."Variant Code" := lrc_PackOrderInputItems."Variant Code";
    //               lrc_PackOrderRevperInpBatch."Input Master Batch No." := lrc_PackOrderInputItems."Master Batch No.";
    //               lrc_PackOrderRevperInpBatch."Input Batch No." := lrc_PackOrderInputItems."Batch No.";
    //               lrc_PackOrderRevperInpBatch."Input Batch Variant No." := lrc_PackOrderInputItems."Batch Variant No.";

    //               lrc_PackOrderRevperInpBatch.Quantity := lrc_PackOrderInputItems.Quantity;
    //               lrc_PackOrderRevperInpBatch."Unit of Measure Code" := lrc_PackOrderInputItems."Unit of Measure Code";
    //               lrc_PackOrderRevperInpBatch."Qty. per Unit of Measure" := lrc_PackOrderInputItems."Qty. per Unit of Measure";
    //               lrc_PackOrderRevperInpBatch."Quantity (Base)" := lrc_PackOrderInputItems."Quantity (Base)";
    //               lrc_PackOrderRevperInpBatch."Base Unit of Measure" := lrc_PackOrderInputItems."Base Unit of Measure Code";

    //               lrc_PackOrderRevperInpBatch."Input Location Code" := lrc_PackOrderInputItems."Location Code";
    //               lrc_PackOrderRevperInpBatch."Output Location Code" := lrc_PackOrderRevenues."Location Code";

    //               lrc_PackOrderRevperInpBatch."Gross Amount (LCY)" := 0;
    //               lrc_PackOrderRevperInpBatch."DSD/ARA Amount (LCY)" := 0;
    //               lrc_PackOrderRevperInpBatch."Freight Costs Amount (LCY)" := 0;
    //               lrc_PackOrderRevperInpBatch."Inv. Disc. (Actual)" := 0;
    //               lrc_PackOrderRevperInpBatch."Rg.-Rab. ohne Wbz. (Act)" := 0;
    //               lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (Internal)" := 0;
    //               lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (External)" := 0;
    //               lrc_PackOrderRevperInpBatch."Net Amount (LCY)" := 0;

    //               //180228 rs Kein Erlös auf Inputzeile aber Kosten?
    //               /**********
    //               IF lbn_PackCostAllocation THEN
    //                 lrc_PackOrderRevperInpBatch."Input Packing Cost (LCY)" := ROUND(ldc_PackCostPerBaseUnit *
    //                                                                           lrc_PackOrderRevperInpBatch."Quantity (Base)" *
    //                                                                           -1,0.00001)
    //               ELSE BEGIN
    //                 //lrc_PackOrderRevperInpBatch."Input Packing Cost (LCY)" := PackCostAlloc(vco_PackOrderNo,

    //               END;
    //               IF lbn_PackCostAllocation THEN
    //                 lrc_PackOrderRevperInpBatch."Total Packing Cost (LCY)" := ROUND(lrc_PackOrderRevperInpBatch."Input Packing Cost (LCY)" +
    //                                                                           lrc_PackOrderRevperInpBatch."DSD/ARA Amount (LCY)",0.00001)
    //               ELSE BEGIN

    //               END;
    //               ********/
    //               //180228 rs.e
    //               lrc_PackOrderRevperInpBatch."Amount (LCY)" := 0;

    //               // Zollstatus auf bezahlt gesetzt?????
    //               lrc_PackOrderRevperInpBatch."Status Customs Duty" := lrc_PackOrderRevperInpBatch."Status Customs Duty"::Payed;

    //               lrc_PackOrderRevperInpBatch."Customer No." := lrc_RecipePackingSetup."Default Cust.-No. Verderb";
    //               lrc_PackOrderRevperInpBatch."Customer Name" := '';
    //               IF lrc_Customer.GET(lrc_PackOrderRevperInpBatch."Customer No.") THEN
    //                 lrc_PackOrderRevperInpBatch."Customer Name" := lrc_Customer.Name;

    //               lrc_PackOrderRevperInpBatch."Sales Order Doc. No." := lrc_PackOrderRevenues."Sales Order Doc. No.";
    //               lrc_PackOrderRevperInpBatch."Sales Order Line No." := lrc_PackOrderRevenues."Sales Order Line No.";

    //               lrc_PackOrderRevperInpBatch.INSERT(TRUE);

    //             END ELSE BEGIN // Erlös für die Inputzeile

    //               // Alle Umsätze lesen
    //               lrc_PackOrderRevenues.Reset();
    //               lrc_PackOrderRevenues.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //               IF lrc_PackOrderRevenues.FIND('-') THEN BEGIN
    //                 REPEAT

    //                   // Umsätze anteilig auf Input
    //                   lrc_PackOrderRevperInpBatch.Reset();
    //                   lrc_PackOrderRevperInpBatch.INIT();
    //                   lrc_PackOrderRevperInpBatch."Doc. No." := lrc_PackOrderInputItems."Doc. No.";
    //                   lrc_PackOrderRevperInpBatch."Doc. Line No. Output" := lrc_PackOrderInputItems."Doc. Line No. Output";
    //                   lrc_PackOrderRevperInpBatch."Doc. Line No. Input" := lrc_PackOrderInputItems."Line No.";
    //                   lrc_PackOrderRevperInpBatch."Line No." := 0;

    //                   lrc_PackOrderRevperInpBatch."Posting Doc. No." := lrc_PackOrderRevenues."Posting Doc. No.";
    //                   // PAC 016 00000000.s
    //                   lrc_PackOrderRevperInpBatch."Posting Doc. Line No." := lrc_PackOrderRevenues."Posting Doc. Line No.";
    //                   // PAC 016 00000000.e

    //                   lrc_PackOrderRevperInpBatch."Posting Date" := lrc_PackOrderRevenues."Posting Date";

    //                   lrc_PackOrderRevperInpBatch."Shipment Date" := lrc_PackOrderRevenues."Shipment Date";
    //                   lrc_PackOrderRevperInpBatch."Promised Delivery Date" := lrc_PackOrderRevenues."Promised Delivery Date";

    //                   lrc_PackOrderRevperInpBatch."Item No." := lrc_PackOrderInputItems."Item No.";
    //                   lrc_PackOrderRevperInpBatch."Variant Code" := lrc_PackOrderInputItems."Variant Code";
    //                   lrc_PackOrderRevperInpBatch."Input Master Batch No." := lrc_PackOrderInputItems."Master Batch No.";
    //                   lrc_PackOrderRevperInpBatch."Input Batch No." := lrc_PackOrderInputItems."Batch No.";
    //                   lrc_PackOrderRevperInpBatch."Input Batch Variant No." := lrc_PackOrderInputItems."Batch Variant No.";

    //                   lrc_PackOrderRevperInpBatch."Output Master Batch No." := lrc_PackOrderRevenues."Output Master Batch No.";
    //                   lrc_PackOrderRevperInpBatch."Output Batch No." := lrc_PackOrderRevenues."Output Batch No.";
    //                   lrc_PackOrderRevperInpBatch."Output Batch Variant No." := lrc_PackOrderRevenues."Output Batch Variant No.";

    //                   lrc_PackOrderRevperInpBatch."Unit of Measure Code" := lrc_PackOrderRevenues."Unit of Measure Code";

    //                   //POI 006 160727 rs
    //                   //lrc_PackOrderRevperInpBatch.Quantity := ROUND(lrc_PackOrderInputItems.Quantity *
    //                   //                                        (lrc_PackOrderRevenues."Percentage of Total Turnover" / 100),0.00001);
    //                   lrc_PackOrderRevperInpBatch.Quantity := ROUND(lrc_PackOrderInputItems.Quantity *
    //                                                           (lrc_PackOrderRevenues."Percentage of Total Quantity" / 100),0.00001);
    //                   //POI 006 160727 rs.e
    //                   lrc_PackOrderRevperInpBatch."Qty. per Unit of Measure" := lrc_PackOrderInputItems."Qty. per Unit of Measure";
    //                   //POI 006 160727 rs
    //                   //lrc_PackOrderRevperInpBatch."Quantity (Base)" := ROUND(lrc_PackOrderInputItems."Quantity (Base)" *
    //                   //                                      (lrc_PackOrderRevenues."Percentage of Total Turnover" / 100),0.00001);
    //                   lrc_PackOrderRevperInpBatch."Quantity (Base)" := ROUND(lrc_PackOrderInputItems."Quantity (Base)" *
    //                                                         (lrc_PackOrderRevenues."Percentage of Total Quantity" / 100),0.00001);
    //                   //POI 006 160727 rs.e
    //                   // PAC 017 00000000.s
    //                   IF lrc_PackOrderRevenues."Item Ledger Entry No." <> 0 THEN BEGIN
    //                     lrc_PackOrderRevperInpBatch."Revenue Quantity" := lrc_PackOrderRevenues.Quantity* -1;
    //                     lrc_PackOrderRevperInpBatch."Revenue Quantity (Base)" := lrc_PackOrderRevenues."Quantity (Base)"*-1;
    //                     lrc_PackOrderRevperInpBatch."Revenue Qty. per UnitofMeasure" := lrc_PackOrderRevenues."Qty. per Unit of Measure";
    //                   END ELSE BEGIN
    //                     lrc_PackOrderRevperInpBatch."Revenue Quantity" := lrc_PackOrderRevenues.Quantity;
    //                     lrc_PackOrderRevperInpBatch."Revenue Quantity (Base)" := lrc_PackOrderRevenues."Quantity (Base)";
    //                     lrc_PackOrderRevperInpBatch."Revenue Qty. per UnitofMeasure" := lrc_PackOrderRevenues."Qty. per Unit of Measure";
    //                   END;
    //                   // PAC 017 00000000.e

    //                   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //                   //POI 001 POSVAR   JST 291013 001 Anpassung an Restmengenfeld in Ergänzung mit Fa.Agiles Kennzeichen POI60049
    //                   //POI60049.S
    //                   //port.jst 29.10.13 Faktor Menge Input-Geesamtmenge/Output-Gesamtmenge berechnen
    //                   //Dies falls die Inputmenge anders ist als die Outputmenge -> muss der Faktor mit dazu
    //                   IF lrc_PackOrderHeader."No." = 'PAUF000383' THEN BEGIN
    //                     ldc_FaktorInOut := ldc_FaktorInOut;
    //                     ldc_FaktorInOut := ldc_FaktorInOut;
    //                   END;
    //                   //POI 001 POSVAR   JST 281113 001 Nachbesserung Fkts-Aufruf Port_Sales.GetInputOutputGesamtMenge
    //                   lcu_Port_Sales.Pack_GetInputOutputGesamtMenge(lrc_PackOrderHeader,ldc_QuantityInput,ldc_QuantityInputBase
    //                                                                 ,ldc_QuantityOutput,ldc_QuantityOutputBAse);

    //                   IF ldc_QuantityOutputBAse <> 0
    //                      THEN ldc_FaktorInOut := ldc_QuantityInputBase / ldc_QuantityOutputBAse
    //                      ELSE ldc_FaktorInOut := 1;

    //                   lrc_PackOrderRevperInpBatch."Output Qty. Quota" :=
    //                     (lrc_PackOrderRevperInpBatch."Revenue Quantity" / 100 * lrc_PackOrderInputItems."Perc. Total Qty.")*ldc_FaktorInOut;
    //                   //port.jst 24.10.13 auch die Basismenge berechnen mit Mengeneinheit des Verkaufes
    //                   lrc_PackOrderRevperInpBatch."Output Qty. Quota (Base)":=
    //                   (lrc_PackOrderRevperInpBatch."Output Qty. Quota" * lrc_PackOrderRevperInpBatch."Qty. per Unit of Measure");

    //                   // POI60049.E
    //                   //POI 001 POSVAR   JST 291013 001 Anpassung an Restmengenfeld in Ergänzung mit Fa.Agiles Kennzeichen POI60049
    //                   //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    //                   lrc_PackOrderRevperInpBatch."Base Unit of Measure" := lrc_PackOrderInputItems."Base Unit of Measure Code";

    //                   lrc_PackOrderRevperInpBatch."Input Location Code" := lrc_PackOrderInputItems."Location Code";
    //                   lrc_PackOrderRevperInpBatch."Output Location Code" := lrc_PackOrderRevenues."Location Code";
    //                   //180219 rs Wenn individuelle Prozentsätzt, dann diese verwenden
    //                   IF NOT lrc_PackOrderInputItems."Manual Revenue Input" THEN BEGIN
    //                     lrc_PackOrderRevperInpBatch."Gross Amount (LCY)" := ROUND(lrc_PackOrderRevenues."Gross Amount (LCY)" *
    //                                                                       (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100),0.00001);

    //                     lrc_PackOrderRevperInpBatch."DSD/ARA Amount (LCY)" := ROUND(lrc_PackOrderRevenues."DSD/ARA Amount (LCY)" *
    //                                                                         (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100),0.00001);
    //                     lrc_PackOrderRevperInpBatch."Freight Costs Amount (LCY)" := ROUND(lrc_PackOrderRevenues."Freight Costs Amount (LCY)" *
    //                                                                          (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100),0.00001);
    //                     lrc_PackOrderRevperInpBatch."Inv. Disc. (Actual)" := lrc_PackOrderRevenues."Inv. Disc. (Actual)" *
    //                                                                               (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100);
    //                     lrc_PackOrderRevperInpBatch."Rg.-Rab. ohne Wbz. (Act)" := lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" *
    //                                                                               (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100);
    //                     lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (Internal)" := lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" *
    //                                                                               (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100);
    //                     lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (External)" := lrc_PackOrderRevenues."Accruel Inv. Disc. (External)" *
    //                                                                               (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100);
    //           //        lrc_PackOrderRevperInpBatch."Net Amount (LCY)" := lrc_PackOrderRevenues."Net Amount (LCY)" *
    //           //                                                            (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100);

    //                     lrc_PackOrderRevperInpBatch."Net Amount (LCY)" := lrc_PackOrderRevperInpBatch."Gross Amount (LCY)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Freight Costs Amount (LCY)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Inv. Disc. (Actual)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Rg.-Rab. ohne Wbz. (Act)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (Internal)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (External)";
    //                   END ELSE BEGIN //individuelle Erlösfaktoren
    //                     lrc_PackOrderRevperInpBatch."Gross Amount (LCY)" := ROUND(lrc_PackOrderRevenues."Gross Amount (LCY)" *
    //                                                                       (lrc_PackOrderInputItems."Manual Revenue Factor" / 100),0.00001);

    //                     lrc_PackOrderRevperInpBatch."DSD/ARA Amount (LCY)" := ROUND(lrc_PackOrderRevenues."DSD/ARA Amount (LCY)" *
    //                                                                         (lrc_PackOrderInputItems."Manual Revenue Factor" / 100),0.00001);
    //                     lrc_PackOrderRevperInpBatch."Freight Costs Amount (LCY)" := ROUND(lrc_PackOrderRevenues."Freight Costs Amount (LCY)" *
    //                                                                          (lrc_PackOrderInputItems."Manual Revenue Factor" / 100),0.00001);
    //                     lrc_PackOrderRevperInpBatch."Inv. Disc. (Actual)" := lrc_PackOrderRevenues."Inv. Disc. (Actual)" *
    //                                                                               (lrc_PackOrderInputItems."Manual Revenue Factor" / 100);
    //                     lrc_PackOrderRevperInpBatch."Rg.-Rab. ohne Wbz. (Act)" := lrc_PackOrderRevenues."Rg.-Rab. ohne Wbz. (Act)" *
    //                                                                               (lrc_PackOrderInputItems."Manual Revenue Factor" / 100);
    //                     lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (Internal)" := lrc_PackOrderRevenues."Accruel Inv. Disc. (Internal)" *
    //                                                                               (lrc_PackOrderInputItems."Manual Revenue Factor" / 100);
    //                     lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (External)" := lrc_PackOrderRevenues."Accruel Inv. Disc. (External)" *
    //                                                                               (lrc_PackOrderInputItems."Manual Revenue Factor" / 100);
    //           //        lrc_PackOrderRevperInpBatch."Net Amount (LCY)" := lrc_PackOrderRevenues."Net Amount (LCY)" *
    //           //                                                            (lrc_PackOrderInputItems."Perc. Qty. with Revenue" / 100);

    //                     lrc_PackOrderRevperInpBatch."Net Amount (LCY)" := lrc_PackOrderRevperInpBatch."Gross Amount (LCY)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Freight Costs Amount (LCY)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Inv. Disc. (Actual)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Rg.-Rab. ohne Wbz. (Act)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (Internal)" +
    //                                                                     lrc_PackOrderRevperInpBatch."Accruel Inv. Disc. (External)";


    //                   END;
    //                   //rrr
    //                   IF NOT lbn_PackCostAllocation THEN
    //                     lrc_PackOrderRevperInpBatch."Input Packing Cost (LCY)" := ldc_PackCostPerBaseUnit *
    //                                                                               lrc_PackOrderRevperInpBatch."Quantity (Base)" * -1
    //                   ELSE
    //                     lrc_PackOrderRevperInpBatch."Input Packing Cost (LCY)" := PackCostAlloc(vco_PackOrderNo,
    //                                                                               lrc_PackOrderInputItems) *
    //                                                                               lrc_PackOrderRevperInpBatch."Quantity (Base)" * -1;

    //                   lrc_PackOrderRevperInpBatch."Total Packing Cost (LCY)" := lrc_PackOrderRevperInpBatch."Input Packing Cost (LCY)" +
    //                                                                               lrc_PackOrderRevperInpBatch."DSD/ARA Amount (LCY)";


    //                   // Erlös einschließlich Abzug von Packkosten und DSD
    //                   //180302 rs
    //                   //lrc_PackOrderRevperInpBatch."Amount (LCY)" := lrc_PackOrderInputItems."Revenue Amount" *
    //                   //                                              (lrc_PackOrderRevenues."Percentage of Total Turnover" / 100);
    //                   lrc_PackOrderRevperInpBatch."Amount (LCY)" := lrc_PackOrderRevperInpBatch."Net Amount (LCY)" +
    //                                                                 lrc_PackOrderRevperInpBatch."Total Packing Cost (LCY)";
    //                   //180302 rs.e

    //                   lrc_PackOrderRevperInpBatch."Item Ledger Entry No." := lrc_PackOrderRevenues."Item Ledger Entry No.";

    //                   lrc_PackOrderRevperInpBatch."Status Customs Duty" := lrc_PackOrderRevenues."Status Customs Duty";

    //                   lrc_PackOrderRevperInpBatch."Customer No." := lrc_PackOrderRevenues."Customer No.";
    //                   lrc_PackOrderRevperInpBatch."Customer Name" := '';
    //                   IF lrc_Customer.GET(lrc_PackOrderRevperInpBatch."Customer No.") THEN
    //                     lrc_PackOrderRevperInpBatch."Customer Name" := lrc_Customer.Name;

    //                   lrc_PackOrderRevperInpBatch."Sales Order Doc. No." := lrc_PackOrderRevenues."Sales Order Doc. No.";
    //                   lrc_PackOrderRevperInpBatch."Sales Order Line No." := lrc_PackOrderRevenues."Sales Order Line No.";

    //                   lrc_PackOrderRevperInpBatch.INSERT(TRUE);

    //                 UNTIL lrc_PackOrderRevenues.NEXT() = 0;
    //               END;

    //             END;
    //           UNTIL lrc_PackOrderInputItems.NEXT() = 0;

    //         END;

    //     end;

    //     procedure "--"()
    //     begin
    //     end;

    //     procedure TEST(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderInputCosts: Record "5110716";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_PurchLine: Record "39";
    //         lrc_ItemLedgerEntry: Record "32";
    //         ldc_Einstandsbetrag: Decimal;
    //         ldc_Kostenbetrag: Decimal;
    //         ldc_MgeOutPutBasis: Decimal;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------


    //         // Inputzeilen bewerten
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         IF lrc_PackOrderInputItems.FIND('-') THEN
    //           REPEAT

    //             lrc_PackOrderInputItems.Einstandsbetrag := 0;

    //             // Einstandsbetrag ermitteln
    //             lrc_PurchLine.SETRANGE("Document Type",lrc_PurchLine."Document Type"::Order);
    //             lrc_PurchLine.SETRANGE("Batch No.",lrc_PackOrderInputItems."Batch No.");
    //             lrc_PurchLine.SETRANGE("Batch Variant No.",lrc_PackOrderInputItems."Batch Variant No.");
    //             lrc_PurchLine.SETFILTER("Outstanding Quantity",'<>%1',0);
    //             IF lrc_PurchLine.FIND('-') THEN BEGIN
    //               lrc_PackOrderInputItems.Einstandsbetrag := lrc_PurchLine."Direct Unit Cost" * lrc_PackOrderInputItems.Quantity;
    //             END;

    //             lrc_PackOrderInputItems.Modify();
    //             ldc_Einstandsbetrag := ldc_Einstandsbetrag + lrc_PackOrderInputItems.Einstandsbetrag;

    //           UNTIL lrc_PackOrderInputItems.NEXT() = 0;


    //         // Input Verpackungsmaterial bewerten



    //         // Kosten aufaddieren
    //         lrc_PackOrderInputCosts.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         IF lrc_PackOrderInputCosts.FIND('-') THEN
    //           REPEAT
    //             ldc_Kostenbetrag := ldc_Kostenbetrag + lrc_PackOrderInputCosts."Amount (LCY)";
    //           UNTIL lrc_PackOrderInputCosts.NEXT() = 0;


    //         // Menge Tafelware berechnen
    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           REPEAT
    //             ldc_MgeOutPutBasis := ldc_MgeOutPutBasis + lrc_PackOrderOutputItems."Quantity (Base)";
    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;

    //         lrc_PackOrderOutputItems.Reset();
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",vco_PackOrderNo);
    //         // PAC 009 00000000.s
    //         // lrc_PackOrderOutputItems.SETRANGE("Type of Packing Product",
    //         //                                    lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         // PAC 009 00000000.e
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN
    //           REPEAT
    //             lrc_PackOrderOutputItems.Einstandsbetrag := (ldc_Einstandsbetrag + ldc_Kostenbetrag) /
    //                                                         ldc_MgeOutPutBasis *
    //                                                         lrc_PackOrderOutputItems."Quantity (Base)";
    //             lrc_PackOrderOutputItems.Modify();
    //           UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
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

    //         lrc_ItemCrossReference.Reset();
    //         lrc_ItemCrossReference.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_ItemCrossReference.SETRANGE("Cross-Reference Type",lrc_ItemCrossReference."Cross-Reference Type"::"Bar Code");
    //         IF lrc_Customer."Cross-Reference Type No." <> '' THEN BEGIN
    //           lrc_ItemCrossReference.SETRANGE("Cross-Reference Type No.",lrc_Customer."Cross-Reference Type No.");
    //         END;
    //         lrc_ItemCrossReference.SETRANGE("Unit of Measure",vco_UnitofMeasureCode);
    //         IF lrc_ItemCrossReference.FIND('-') THEN BEGIN
    //           EXIT(lrc_ItemCrossReference."Cross-Reference No.");
    //         END;

    //         EXIT('');
    //         // FV4 005 00000000.e
    //     end;

    //     procedure "-----"()
    //     begin
    //     end;

    //     procedure PORT()
    //     begin
    //     end;

    //     procedure EPSInputOutput(vco_PackOrderNo: Code[20])
    //     var
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_Item: Record Item;
    //         ldc_OutputQuantity: array [10] of Decimal;
    //         ldc_InputQuantity: array [10] of Decimal;
    //         lco_ItemNo: array [10] of Code[20];
    //         lin_i: Integer;
    //         lin_j: Integer;
    //     begin
    //         //-----------------------------------------------------------------------
    //         //Funktion zur Überprüfung der Input und Outputmengen bei Leergutartikeln
    //         //vco_PackOrderNo - Packauftragsnummer Code 20
    //         //-----------------------------------------------------------------------

    //         //170109 rs eingefügt, damit Regina alte Aufträge ausbuchen kann.
    //         IF vco_PackOrderNo < 'PACK17-0001' THEN
    //           EXIT;

    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.", vco_PackOrderNo);
    //         lrc_PackOrderInputItems.SETRANGE(lrc_PackOrderInputItems."Item Typ", lrc_PackOrderInputItems."Item Typ" :: "Empties Item");

    //         IF lrc_PackOrderInputItems.FINDSET() THEN BEGIN
    //           IF lrc_PackOrderInputItems.COUNT = 1 THEN BEGIN
    //             lrc_PackOrderOutputItems.SETRANGE("Doc. No.", vco_PackOrderNo);
    //             lrc_PackOrderOutputItems.SETRANGE("Item No.", lrc_PackOrderInputItems."Item No.");
    //             IF lrc_PackOrderOutputItems.FINDSET() THEN BEGIN
    //               REPEAT
    //                 ldc_OutputQuantity[1] := ldc_OutputQuantity[1] + lrc_PackOrderOutputItems.Quantity;
    //               UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //               IF ldc_OutputQuantity[1] < lrc_PackOrderInputItems.Quantity THEN
    //                 ERROR('Der Menge des Leergutartikels %1 ist in den Outputzeilen kleiner als die Menge Input',
    //                        lrc_PackOrderInputItems."Item Description");
    //             END ELSE BEGIN //keine Outputzeile vorhanden
    //                 ERROR('Der Leergutartikel %1 ist nicht in den Outputzeilen enthalten', lrc_PackOrderInputItems."Item Description");
    //             END;
    //           END ELSE BEGIN //mehr als eine LeergutInputzeile
    //             //Prüfung, wieviele verschiedene Leergutartikel
    //             lrc_PackOrderInputItems.SETCURRENTKEY("Doc. No.", "Item No.");
    //             lrc_PackOrderOutputItems.SETCURRENTKEY("Doc. No.", "Item No.");
    //             lrc_PackOrderOutputItems.SETRANGE("Doc. No.", vco_PackOrderNo);
    //             lin_i := 1;
    //             lco_ItemNo[lin_i] := lrc_PackOrderInputItems."Item No.";
    //             REPEAT
    //               IF lco_ItemNo[lin_i] <> lrc_PackOrderInputItems."Item No." THEN BEGIN
    //                 lin_i +=1;
    //                 lco_ItemNo[lin_i] := lrc_PackOrderInputItems."Item No.";
    //                 ldc_InputQuantity[lin_i] := ldc_InputQuantity[lin_i] + lrc_PackOrderInputItems.Quantity;
    //                 lrc_PackOrderOutputItems.SETRANGE("Item No.", lco_ItemNo[lin_i]);
    //                 IF lrc_PackOrderOutputItems.FINDSET() THEN BEGIN
    //                   ldc_OutputQuantity[lin_i] := 0;
    //                   REPEAT
    //                     ldc_OutputQuantity[lin_i] := ldc_OutputQuantity[lin_i] + lrc_PackOrderOutputItems.Quantity;
    //                   UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //                 END;
    //               END ELSE BEGIN
    //                 ldc_InputQuantity[lin_i] := ldc_InputQuantity[lin_i] + lrc_PackOrderInputItems.Quantity;
    //                 lrc_PackOrderOutputItems.SETRANGE("Item No.", lco_ItemNo[lin_i]);
    //                 IF lrc_PackOrderOutputItems.FINDSET() THEN BEGIN
    //                   ldc_OutputQuantity[lin_i] := 0;
    //                   REPEAT
    //                     ldc_OutputQuantity[lin_i] := ldc_OutputQuantity[lin_i] + lrc_PackOrderOutputItems.Quantity;
    //                   UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
    //                 END;
    //               END;
    //             UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //             FOR lin_j := 1 TO lin_i DO BEGIN
    //               IF ldc_OutputQuantity[lin_j] < ldc_InputQuantity[lin_j] THEN BEGIN
    //                 lrc_Item.GET(lco_ItemNo[lin_j]);
    //                 ERROR('Die Menge des Leergutartikels %1 ist im Output kleiner als im Input', lrc_Item.Description);
    //               END;
    //             END;
    //           END;
    //         END;
    //     end;

    //     procedure EPS_Bestellung(vcd_Vendor: Code[20];vdt_OrderDate: Date;vcd_ItemNo: Code[20];vdc_Quantity: Decimal;vcd_PackOrderNo: Code[20];var rcd_PurchOrderNo: Code[10])
    //     var
    //         lrc_PurchHeader: Record "38";
    //         lrc_PurchLine: Record "39";
    //         lrc_Location: Record "14";
    //         lrc_RecipePackingSetup: Record "5110701";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lbo_Location: Boolean;
    //         lin_LineNo: Integer;
    //     begin
    //         //-------------------------------------------------------------
    //         //Funktion zum Anlegen einer EPS-Inputzeile aus dem Packauftrag
    //         //-------------------------------------------------------------

    //         //Einkaufskopf anlegen
    //         lrc_PurchHeader.Reset();
    //         lrc_PurchHeader.INIT();
    //         lrc_PurchHeader."Document Type" := lrc_PurchHeader."Document Type" :: Order;
    //         lrc_PurchHeader."No." := '';
    //         lrc_PurchHeader."Purch. Doc. Subtype Code" := 'FRUCHT';
    //         lrc_PurchHeader.INSERT(TRUE);
    //         lrc_PurchHeader.VALIDATE("Buy-from Vendor No.", vcd_Vendor);
    //         lrc_PurchHeader.VALIDATE("Order Date", vdt_OrderDate);
    //         lrc_Location.SETRANGE(lrc_Location."Vendor No.", vcd_Vendor);
    //         IF NOT lrc_Location.FINDSET() THEN BEGIN
    //           MESSAGE('Der Kreditor %1 ist nicht als Lager vorhanden, bitte bearbeiten Sie die Bestellung nach', vcd_Vendor);
    //           lbo_Location := TRUE;
    //         END;
    //         lrc_PurchHeader.VALIDATE("Departure Location Code", lrc_Location.Code);
    //         lrc_PurchHeader.VALIDATE("Destination Country Code", lrc_Location."Country/Region Code");
    //         lrc_PurchHeader.VALIDATE("Expected Receipt Date", vdt_OrderDate);
    //         lrc_PurchHeader.VALIDATE("Planned Receipt Date", vdt_OrderDate);
    //         lrc_PurchHeader.VALIDATE("Departure Date",vdt_OrderDate);
    //         lrc_PurchHeader.VALIDATE("Shipment Method Code", 'Verzolt ab');
    //         lrc_PurchHeader."Your Reference" := vcd_PackOrderNo;
    //         lrc_PurchHeader.Modify();
    //         COMMIT;

    //         //Einkaufszeile anlegen
    //         lrc_PurchLine.Reset();
    //         lrc_PurchLine.INIT();
    //         lrc_PurchLine."Document Type" := lrc_PurchLine."Document Type" :: Order;
    //         lrc_PurchLine."Document No." := lrc_PurchHeader."No.";
    //         lrc_PurchLine."Line No." := 10000;
    //         lrc_PurchLine."Purch. Doc. Subtype Code" := 'FRUCHT';
    //         lrc_PurchLine.INSERT(TRUE);
    //         lrc_PurchLine.VALIDATE(Type, lrc_PurchLine.Type :: Item);
    //         lrc_PurchLine.VALIDATE("No.", vcd_ItemNo);
    //         lrc_PurchLine.VALIDATE("Location Code", lrc_Location.Code);
    //         lrc_PurchLine.VALIDATE(Quantity, vdc_Quantity);
    //         lrc_PurchLine.Modify();
    //         COMMIT;

    //         //PackOrderInputZeile anlegen

    //         lrc_RecipePackingSetup.GET();
    //         lrc_PackOrderHeader.GET(vcd_PackOrderNo);
    //         IF lrc_RecipePackingSetup."Input Loc. Item as in Header" = TRUE THEN BEGIN
    //           IF lrc_PackOrderHeader."Inp. Item Loc. Code" <> lrc_PurchLine."Location Code" THEN
    //             ERROR('Lagerort stimmt nicht mit Lagerort Pack.-Auftrag überein!');
    //         END;

    //         // Letzte Zeilennummer ermitteln
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderInputItems.FIND('+') THEN
    //           lin_LineNo := lrc_PackOrderInputItems."Line No."
    //         ELSE
    //           lin_LineNo := 0;

    //         // -------------------------------------------------------------------------
    //         // Packzeile Input anlegen
    //         // -------------------------------------------------------------------------
    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.INIT();
    //         lrc_PackOrderInputItems."Doc. No." := lrc_PackOrderHeader."No.";
    //         lrc_PackOrderInputItems."Doc. Line No. Output" := 0;
    //         lrc_PackOrderInputItems."Line No." := lin_LineNo + 10000;
    //         lrc_PackOrderInputItems.INSERT(TRUE);
    //         lrc_PackOrderInputItems.VALIDATE("Item No.", vcd_ItemNo);
    //         lrc_PackOrderInputItems.VALIDATE("Batch Variant No.", lrc_PurchLine."Batch Variant No.");
    //         lrc_PackOrderInputItems.VALIDATE("Location Code", lrc_Location.Code);
    //         lrc_PackOrderInputItems.VALIDATE(Quantity, vdc_Quantity);
    //         lrc_PackOrderInputItems.PurchOrderGenerated := TRUE;
    //         lrc_PackOrderInputItems.MODIFY(TRUE);
    //         COMMIT;

    //         //PurchaseHeaderNo als Rückgabewert
    //         rcd_PurchOrderNo := lrc_PurchHeader."No.";
    //         EXIT;
    //     end;

    //     procedure PackCostAlloc(vco_PackOrderNo: Code[20];vrc_PackInput: Record "5110714") rdc_PackCost: Decimal
    //     var
    //         lrc_PackOrderInput: Record "5110714";
    //         lrc_PackOrderCost: Record "5110716";
    //         ldc_InputQuantity: Decimal;
    //     begin
    //         // -----------------------------------------------------------------------------------
    //         // Funktion zur Aufteilung der Packkosten bei individueller Zuweisung auf Input-Partie
    //         // -----------------------------------------------------------------------------------

    //         lrc_PackOrderInput.SETRANGE("Doc. No.", vco_PackOrderNo);
    //         lrc_PackOrderInput.SETRANGE("No Revenue", FALSE);
    //         IF lrc_PackOrderInput.FINDSET(FALSE, FALSE) THEN BEGIN
    //           REPEAT
    //             ldc_InputQuantity += lrc_PackOrderInput."Quantity (Base)";
    //           UNTIL lrc_PackOrderInput.NEXT() = 0;
    //         END;

    //         lrc_PackOrderCost.SETRANGE("Doc. No.", vco_PackOrderNo);
    //         lrc_PackOrderCost.SETRANGE(lrc_PackOrderCost."Doc. Line No. Input", vrc_PackInput."Line No.");
    //         IF lrc_PackOrderCost.FINDSET(FALSE, FALSE) THEN BEGIN
    //           REPEAT
    //             rdc_PackCost += lrc_PackOrderCost."Amount (LCY)";
    //           UNTIL lrc_PackOrderCost.NEXT() = 0;
    //         END;


    //         lrc_PackOrderCost.SETRANGE(lrc_PackOrderCost."Doc. Line No. Input", 0);
    //         IF lrc_PackOrderCost.FINDSET(FALSE, FALSE) THEN
    //           IF ldc_InputQuantity <> 0 THEN
    //             rdc_PackCost += lrc_PackOrderCost."Amount (LCY)" / ldc_InputQuantity *
    //                             vrc_PackInput."Quantity (Base)";
    //         rdc_PackCost := rdc_PackCost / vrc_PackInput."Quantity (Base)";
    //     end;
}