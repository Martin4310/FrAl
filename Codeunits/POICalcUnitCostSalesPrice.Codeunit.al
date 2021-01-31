codeunit 5110335 "POI Calc Unit Cost/Sales Price"
{
    var
        lrc_PurchLine: Record "Purchase Line";
    //     Permissions = TableData 37 = rimd;

    //     procedure SalesBatchVarCalcSalesPrice123(vrc_SalesHeader: Record "36"; vco_BatchVarNo: Code[20]; vco_SalesPriceBase: Code[10]; vdc_MargePerc: Decimal; var rdc_SalesPrice: Decimal; var rdc_SalesPrice1: Decimal; var rdc_SalesPrice2: Decimal; var rdc_SalesPrice3: Decimal; var rdc_SalesFreight: Decimal)
    //     var
    //         lrc_MasterBatchSetup: Record "5110363";
    //         lrc_SalesLine: Record "37";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_Customer: Record "Customer";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_Location: Record "14";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         lrc_SalesDiscount: Record "5110344";
    //         lrc_PriceBase: Record "5110320";
    //         ldc_SalesFreightPerTranspUnit: Decimal;
    //         ldc_SalesFreightPerUnit: Decimal;
    //         ldc_DiscountPerc: Decimal;
    //         ldc_DiscountAmtPerUnit: Decimal;
    //         ldc_SalesPriceMarge: Decimal;
    //         ldc_SalesPriceMarge1: Decimal;
    //         ldc_SalesPriceMarge2: Decimal;
    //         ldc_SalesPriceMarge3: Decimal;
    //     begin
    //         // -----------------------------------------------------------------------------------------------
    //         // -----------------------------------------------------------------------------------------------

    //         lrc_MasterBatchSetup.GET();
    //         lrc_BatchVariant.GET(vco_BatchVarNo);
    //         IF NOT lrc_Customer.GET(vrc_SalesHeader."Sell-to Customer No.") THEN
    //             EXIT;

    //         // -----------------------------------------------------------------------------------------------
    //         // Verkaufsfrachtkosten berechnen
    //         // -----------------------------------------------------------------------------------------------

    //         ldc_SalesFreightPerUnit := 0;
    //         lrc_SalesLine.SETCURRENTKEY("Batch Variant No.");
    //         lrc_SalesLine.SETRANGE("Batch Variant No.", vco_BatchVarNo);
    //         lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //         lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //         IF lrc_SalesLine.FINDFIRST() THEN BEGIN
    //             IF lrc_SalesLine.Quantity <> 0 THEN
    //                 ldc_SalesFreightPerUnit := ROUND(lrc_SalesLine."Freight Costs Amount (LCY)" /
    //                                                  lrc_SalesLine.Quantity, 0.01, '>')
    //             ELSE
    //                 ldc_SalesFreightPerUnit := 0;
    //         END;
    //         /*--
    //         IF lrc_ShipmentMethod.GET(vrc_SalesHeader."Shipment Method Code") THEN BEGIN
    //           IF lrc_ShipmentMethod."Incl. Freight to Final Loc." = TRUE THEN BEGIN

    //             IF lrc_UnitofMeasure.GET(lrc_BatchVariant."Transport Unit of Measure (TU)") THEN;
    //             lrc_Location.GET(vrc_SalesHeader."Location Code");

    //             lrc_ShipAgentFreightcost.Reset();
    //             lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",vrc_SalesHeader."Shipping Agent Code");
    //             lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_Location."Departure Region Code");
    //             lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code",vrc_SalesHeader."Arrival Region Code");
    //             lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base",
    //                                               lrc_ShipAgentFreightcost."Freight Cost Tarif Base"::"Pallet Type");
    //             lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",lrc_UnitofMeasure."Freight Unit of Measure (FU)");
    //             lrc_ShipAgentFreightcost.SETRANGE(Pauschal,FALSE);
    //             IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //               ldc_SalesFreightPerTranspUnit := lrc_ShipAgentFreightcost."Freight Rate per Unit";
    //               IF lrc_BatchVariant."Qty. (CU) per Pallet (TU)" <> 0 THEN
    //                 ldc_SalesFreightPerUnit := ROUND(ldc_SalesFreightPerTranspUnit /
    //                                                lrc_BatchVariant."Qty. (CU) per Pallet (TU)",0.01,'>');
    //             END;

    //           END;
    //         END;
    //         --*/

    //         // -----------------------------------------------------------------------------------------------
    //         // Konditionen berechnen
    //         // -----------------------------------------------------------------------------------------------
    //         lrc_SalesDiscount.Reset();
    //         lrc_SalesDiscount.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //         lrc_SalesDiscount.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //         IF lrc_SalesDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 CASE lrc_SalesDiscount."Base Discount Value" OF
    //                     lrc_SalesDiscount."Base Discount Value"::Prozentsatz:
    //                         BEGIN
    //                             ldc_DiscountPerc := ldc_DiscountPerc + lrc_SalesDiscount."Discount Value";
    //                         END;
    //                     lrc_SalesDiscount."Base Discount Value"::"Betrag Pro Kolli":
    //                         BEGIN
    //                             ldc_DiscountAmtPerUnit := ldc_DiscountAmtPerUnit + lrc_SalesDiscount."Discount Value";
    //                         END;
    //                 END;
    //             UNTIL lrc_SalesDiscount.NEXT() = 0;
    //         END;

    //         // -----------------------------------------------------------------------------------------------
    //         // Verkaufspreise berechnen
    //         // -----------------------------------------------------------------------------------------------
    //         ldc_SalesPriceMarge1 :=
    //             ((lrc_BatchVariant."Unit Cost (UOM) (LCY)" +
    //              ldc_SalesFreightPerUnit) * 100) /
    //             (100 - (lrc_MasterBatchSetup."B.I.S. Marge 1" + ldc_DiscountPerc));

    //         ldc_SalesPriceMarge2 :=
    //             ((lrc_BatchVariant."Unit Cost (UOM) (LCY)" +
    //              ldc_SalesFreightPerUnit) * 100) /
    //             (100 - (lrc_MasterBatchSetup."B.I.S. Marge 2" + ldc_DiscountPerc));

    //         ldc_SalesPriceMarge3 :=
    //             ((lrc_BatchVariant."Unit Cost (UOM) (LCY)" +
    //              ldc_SalesFreightPerUnit) * 100) /
    //             (100 - (lrc_MasterBatchSetup."B.I.S. Marge 3" + ldc_DiscountPerc));


    //         // -----------------------------------------------------------------------------------------------
    //         // Kollo Preis in die Preisbezugsgröße umrechnen
    //         // -----------------------------------------------------------------------------------------------
    //         IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Sales Price",
    //                              vco_SalesPriceBase) THEN BEGIN
    //             CASE lrc_PriceBase."Internal Calc. Type" OF
    //                 lrc_PriceBase."Internal Calc. Type"::" ":
    //                     ;
    //                 lrc_PriceBase."Internal Calc. Type"::"Base Unit":
    //                     BEGIN
    //                         IF lrc_BatchVariant."Qty. per Unit of Measure" <> 0 THEN BEGIN
    //                             ldc_SalesPriceMarge1 := ROUND(ldc_SalesPriceMarge1 / lrc_BatchVariant."Qty. per Unit of Measure", 0.01, '>');
    //                             ldc_SalesPriceMarge2 := ROUND(ldc_SalesPriceMarge2 / lrc_BatchVariant."Qty. per Unit of Measure", 0.01, '>');
    //                             ldc_SalesPriceMarge3 := ROUND(ldc_SalesPriceMarge3 / lrc_BatchVariant."Qty. per Unit of Measure", 0.01, '>');
    //                             ldc_SalesFreightPerUnit := ROUND(ldc_SalesFreightPerUnit / lrc_BatchVariant."Qty. per Unit of Measure", 0.01, '>');
    //                         END;
    //                     END;

    //                 lrc_PriceBase."Internal Calc. Type"::"Content Unit":
    //                     ERROR('');

    //                 lrc_PriceBase."Internal Calc. Type"::"Packing Unit":
    //                     BEGIN
    //                         IF lrc_BatchVariant."Qty. (PU) per Collo (CU)" <> 0 THEN BEGIN
    //                             ldc_SalesPriceMarge1 := ROUND(ldc_SalesPriceMarge1 / lrc_BatchVariant."Qty. (PU) per Collo (CU)", 0.01, '>');
    //                             ldc_SalesPriceMarge2 := ROUND(ldc_SalesPriceMarge2 / lrc_BatchVariant."Qty. (PU) per Collo (CU)", 0.01, '>');
    //                             ldc_SalesPriceMarge3 := ROUND(ldc_SalesPriceMarge3 / lrc_BatchVariant."Qty. (PU) per Collo (CU)", 0.01, '>');
    //                             ldc_SalesFreightPerUnit := ROUND(ldc_SalesFreightPerUnit / lrc_BatchVariant."Qty. (PU) per Collo (CU)", 0.01, '>');
    //                         END;
    //                     END;

    //                 lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
    //                     ;

    //                 lrc_PriceBase."Internal Calc. Type"::"Transport Unit":
    //                     ;

    //                 lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
    //                     BEGIN
    //                         ldc_SalesPriceMarge1 := ROUND(ldc_SalesPriceMarge1 / lrc_BatchVariant."Gross Weight", 0.01, '>');
    //                         ldc_SalesPriceMarge2 := ROUND(ldc_SalesPriceMarge2 / lrc_BatchVariant."Gross Weight", 0.01, '>');
    //                         ldc_SalesPriceMarge3 := ROUND(ldc_SalesPriceMarge3 / lrc_BatchVariant."Gross Weight", 0.01, '>');
    //                         ldc_SalesFreightPerUnit := ROUND(ldc_SalesFreightPerUnit / lrc_BatchVariant."Gross Weight", 0.01, '>');
    //                     END;

    //                 lrc_PriceBase."Internal Calc. Type"::"Net Weight":
    //                     BEGIN
    //                         ldc_SalesPriceMarge1 := ROUND(ldc_SalesPriceMarge1 / lrc_BatchVariant."Net Weight", 0.01, '>');
    //                         ldc_SalesPriceMarge2 := ROUND(ldc_SalesPriceMarge2 / lrc_BatchVariant."Net Weight", 0.01, '>');
    //                         ldc_SalesPriceMarge3 := ROUND(ldc_SalesPriceMarge3 / lrc_BatchVariant."Net Weight", 0.01, '>');
    //                         ldc_SalesFreightPerUnit := ROUND(ldc_SalesFreightPerUnit / lrc_BatchVariant."Net Weight", 0.01, '>');
    //                     END;

    //                 lrc_PriceBase."Internal Calc. Type"::"Total Price":
    //                     ;
    //             END;

    //         END ELSE BEGIN
    //         END;

    //         // Rückgabewerte setzen
    //         rdc_SalesPrice := 0;
    //         rdc_SalesPrice1 := ldc_SalesPriceMarge1;
    //         rdc_SalesPrice2 := ldc_SalesPriceMarge2;
    //         rdc_SalesPrice3 := ldc_SalesPriceMarge3;
    //         rdc_SalesFreight := ldc_SalesFreightPerUnit;

    //     end;

    //     procedure SalesBatchVarCalcMargePercAmt(vrc_SalesLine: Record "37"; vin_Result: Option; var rdc_MargeUnitPer: Decimal; var rdc_MargeUnitAmt: Decimal; var rdc_MargeTotalAmt: Decimal)
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_SalesDiscount: Record "5110344";
    //         lrc_Customer: Record "Customer";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_Location: Record "14";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         lrc_PriceBase: Record "5110320";
    //         ldc_DiscountPerc: Decimal;
    //         ldc_DiscountAmtPerUnit: Decimal;
    //         ldc_SalesFreightPerTranspUnit: Decimal;
    //         ldc_SalesFreightPerUnit: Decimal;
    //         ldc_MargeUnit: Decimal;
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         //
    //         // ----------------------------------------------------------------------------------------------
    //         // vin_Result: 0 = Kollo
    //         //             1 = Preisbezug
    //         // ----------------------------------------------------------------------------------------------

    //         IF vrc_SalesLine."Batch Variant No." = '' THEN
    //             EXIT;
    //         IF NOT lrc_BatchVariant.GET(vrc_SalesLine."Batch Variant No.") THEN
    //             EXIT;
    //         IF NOT lrc_SalesHeader.GET(vrc_SalesLine."Document Type", vrc_SalesLine."Document No.") THEN
    //             EXIT;

    //         // -----------------------------------------------------------------------------------------------
    //         // Konditionen berechnen
    //         // -----------------------------------------------------------------------------------------------
    //         lrc_SalesDiscount.Reset();
    //         lrc_SalesDiscount.SETRANGE("Document Type", vrc_SalesLine."Document Type");
    //         lrc_SalesDiscount.SETRANGE("Document No.", vrc_SalesLine."Document No.");
    //         IF lrc_SalesDiscount.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 CASE lrc_SalesDiscount."Base Discount Value" OF
    //                     lrc_SalesDiscount."Base Discount Value"::Prozentsatz:
    //                         BEGIN
    //                             ldc_DiscountPerc := ldc_DiscountPerc + lrc_SalesDiscount."Discount Value";
    //                         END;
    //                     lrc_SalesDiscount."Base Discount Value"::"Betrag Pro Kolli":
    //                         BEGIN
    //                             ldc_DiscountAmtPerUnit := ldc_DiscountAmtPerUnit + lrc_SalesDiscount."Discount Value";
    //                         END;
    //                 END;
    //             UNTIL lrc_SalesDiscount.NEXT() = 0;
    //         END;

    //         // Verkaufspreis
    //         rdc_MargeUnitAmt := vrc_SalesLine."Unit Price";

    //         // Rabatte Prozentual
    //         IF ldc_DiscountPerc <> 0 THEN BEGIN
    //             rdc_MargeUnitAmt := rdc_MargeUnitAmt - (vrc_SalesLine."Unit Price" * (ldc_DiscountPerc / 100));
    //         END;
    //         // Rabatte Absolut
    //         IF ldc_DiscountAmtPerUnit <> 0 THEN BEGIN
    //             rdc_MargeUnitAmt := rdc_MargeUnitAmt - ldc_DiscountAmtPerUnit;
    //         END;

    //         IF vrc_SalesLine.Quantity <> 0 THEN
    //             ldc_SalesFreightPerUnit := ROUND(vrc_SalesLine."Freight Costs Amount (LCY)" /
    //                                              vrc_SalesLine.Quantity, 0.00001)
    //         ELSE
    //             ldc_SalesFreightPerUnit := 0;
    //         rdc_MargeUnitAmt := rdc_MargeUnitAmt - ldc_SalesFreightPerUnit;

    //         /*--
    //         // Verkaufsfrachtkosten berechnen
    //         IF lrc_ShipmentMethod.GET(lrc_SalesHeader."Shipment Method Code") THEN BEGIN
    //           IF lrc_ShipmentMethod."Incl. Freight to Final Loc." = TRUE THEN BEGIN

    //             IF lrc_UnitofMeasure.GET(lrc_BatchVariant."Transport Unit of Measure (TU)") THEN;
    //             lrc_Location.GET(lrc_SalesHeader."Location Code");

    //             lrc_ShipAgentFreightcost.Reset();
    //             lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_SalesHeader."Shipping Agent Code");
    //             lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_Location."Departure Region Code");
    //             lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code",lrc_SalesHeader."Arrival Region Code");
    //             lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base",
    //                                               lrc_ShipAgentFreightcost."Freight Cost Tarif Base"::"Pallet Type");
    //             lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",lrc_UnitofMeasure."Freight Unit of Measure (FU)");
    //             lrc_ShipAgentFreightcost.SETRANGE(Pauschal,FALSE);
    //             IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //               ldc_SalesFreightPerTranspUnit := lrc_ShipAgentFreightcost."Freight Rate per Unit";
    //               IF lrc_BatchVariant."Qty. (CU) per Pallet (TU)" <> 0 THEN BEGIN
    //                 ldc_SalesFreightPerUnit := ROUND(ldc_SalesFreightPerTranspUnit /
    //                                                  lrc_BatchVariant."Qty. (CU) per Pallet (TU)",0.00001);
    //               END;
    //             END;

    //           END;
    //           rdc_MargeUnitAmt := rdc_MargeUnitAmt - ldc_SalesFreightPerUnit;
    //         END;
    //         --*/

    //         // Marge Betrag
    //         rdc_MargeUnitAmt := rdc_MargeUnitAmt - lrc_BatchVariant."Unit Cost (UOM) (LCY)";
    //         rdc_MargeTotalAmt := rdc_MargeUnitAmt * vrc_SalesLine.Quantity;

    //         // Kollo Preis in die Preisbezugsgröße umrechnen
    //         IF vin_Result = 1 THEN BEGIN
    //             IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Sales Price",
    //                                  vrc_SalesLine."Price Base (Sales Price)") THEN BEGIN
    //                 CASE lrc_PriceBase."Internal Calc. Type" OF
    //                     lrc_PriceBase."Internal Calc. Type"::" ":
    //                         ;
    //                     lrc_PriceBase."Internal Calc. Type"::"Base Unit":
    //                         BEGIN
    //                             IF vrc_SalesLine."Qty. per Unit of Measure" <> 0 THEN
    //                                 rdc_MargeUnitAmt := ROUND(rdc_MargeUnitAmt / vrc_SalesLine."Qty. per Unit of Measure", 0.01);
    //                         END;
    //                     lrc_PriceBase."Internal Calc. Type"::"Packing Unit":
    //                         BEGIN
    //                             IF vrc_SalesLine."Qty. (PU) per Unit of Measure" <> 0 THEN
    //                                 rdc_MargeUnitAmt := ROUND(rdc_MargeUnitAmt / vrc_SalesLine."Qty. (PU) per Unit of Measure", 0.01);
    //                         END;
    //                     lrc_PriceBase."Internal Calc. Type"::"Net Weight":
    //                         BEGIN
    //                             IF vrc_SalesLine."Net Weight" <> 0 THEN
    //                                 rdc_MargeUnitAmt := ROUND(rdc_MargeUnitAmt / vrc_SalesLine."Net Weight", 0.01);
    //                         END;
    //                     lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
    //                         BEGIN
    //                             IF vrc_SalesLine."Gross Weight" <> 0 THEN
    //                                 rdc_MargeUnitAmt := ROUND(rdc_MargeUnitAmt / vrc_SalesLine."Gross Weight", 0.01);
    //                         END;
    //                 END;
    //             END;
    //         END;

    //         // Marge Prozent
    //         IF vrc_SalesLine."Sales Price (Price Base)" <> 0 THEN
    //             rdc_MargeUnitPer := ROUND(rdc_MargeUnitAmt / vrc_SalesLine."Sales Price (Price Base)" * 100, 0.01)
    //         ELSE
    //             rdc_MargeUnitPer := 0;

    //     end;

    //     procedure SalesTotalMarge(vco_SalesDocType: Option "0","1","2","3","4","5","6"; vco_SalesDocNo: Code[20]; var rdc_MargeTotalAmt: Decimal; var rdc_MargeTotalPer: Decimal; var rdc_TranspUnitTotalQty: Decimal; var rco_ArrTransportItemNo: array[100] of Code[20]; var rdc_ArrTransportQty: array[100] of Decimal; var rdc_SalesFreightPerTranspUnit: Decimal)
    //     var
    //         lcu_GlobalFunctionsMgt: Codeunit "5110300";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_Location: Record "14";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         ldc_SalesAmt: Decimal;
    //         ldc_MargeAmt: Decimal;
    //         ldc_MargePer: Decimal;
    //         ldc_TranspUnitQty: Decimal;
    //         ldc_SalesFreightPerTranspUnit: Decimal;
    //         lin_ArrCounter: Integer;
    //     begin
    //         // -----------------------------------------------------------------------------------
    //         // Funktion zur Kalkulation der Gesamtmarge eines Auftrages
    //         // -----------------------------------------------------------------------------------

    //         rdc_MargeTotalAmt := 0;
    //         rdc_MargeTotalPer := 0;
    //         rdc_TranspUnitTotalQty := 0;
    //         CLEAR(rco_ArrTransportItemNo);
    //         CLEAR(rdc_ArrTransportQty);

    //         lrc_SalesHeader.GET(vco_SalesDocType, vco_SalesDocNo);

    //         lrc_SalesLine.SETRANGE("Document Type", vco_SalesDocType);
    //         lrc_SalesLine.SETRANGE("Document No.", vco_SalesDocNo);
    //         IF lrc_SalesLine.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 IF (lrc_SalesLine.Type = lrc_SalesLine.Type::Item) AND
    //                    (lrc_SalesLine.Subtyp = lrc_SalesLine.Subtyp::" ") AND
    //                    (lrc_SalesLine."No." <> '') THEN BEGIN

    //                     ldc_SalesAmt := ldc_SalesAmt +
    //                       (lrc_SalesLine."Unit Price" * lrc_SalesLine.Quantity);

    //                     ldc_MargeAmt := ldc_MargeAmt +
    //                       ((lrc_SalesLine."Unit Price" * lrc_SalesLine.Quantity) -
    //                        lrc_SalesLine."Line Discount Amount" -
    //                        lrc_SalesLine."Inv. Discount Amount" -
    //                        lrc_SalesLine."Freight Costs Amount (LCY)" -
    //                        (lrc_SalesLine."Unit Cost (LCY)" * lrc_SalesLine.Quantity));

    //                     ldc_TranspUnitQty := ldc_TranspUnitQty + lrc_SalesLine."Quantity (TU)";

    //                     IF (lrc_SalesLine."Transport Unit of Measure (TU)" <> '') AND
    //                        (lrc_SalesLine.Quantity <> 0) THEN BEGIN
    //                         // Funktion um ein Inhalt in einem Array zu finden
    //                         // vcoArrCode,vin_ArrDim,vco_SearchContent
    //                         IF lcu_GlobalFunctionsMgt.Arr100FindEntry(rco_ArrTransportItemNo, 10,
    //                                                                lrc_SalesLine."Transport Unit of Measure (TU)",
    //                                                                lin_ArrCounter) = FALSE THEN BEGIN
    //                             rco_ArrTransportItemNo[lin_ArrCounter] := rco_ArrTransportItemNo[lin_ArrCounter] +
    //                                                                       lrc_SalesLine."Transport Unit of Measure (TU)";
    //                             rdc_ArrTransportQty[lin_ArrCounter] := rdc_ArrTransportQty[lin_ArrCounter] +
    //                                                                    lrc_SalesLine."Quantity (TU)";
    //                         END ELSE BEGIN
    //                             rdc_ArrTransportQty[lin_ArrCounter] := rdc_ArrTransportQty[lin_ArrCounter] +
    //                                                                    lrc_SalesLine."Quantity (TU)";
    //                         END;
    //                     END;


    //                 END;
    //             UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;

    //         IF ldc_SalesAmt <> 0 THEN
    //             ldc_MargePer := ROUND(ldc_MargeAmt * 100 / ldc_SalesAmt, 0.01);

    //         rdc_MargeTotalAmt := ldc_MargeAmt;
    //         rdc_MargeTotalPer := ldc_MargePer;
    //         rdc_TranspUnitTotalQty := ldc_TranspUnitQty;


    //         IF lrc_ShippingAgent.GET(lrc_SalesHeader."Shipping Agent Code") THEN BEGIN
    //             IF lrc_Location.GET(lrc_SalesHeader."Location Code") THEN BEGIN
    //                 lrc_ShipAgentFreightcost.Reset();
    //                 lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesHeader."Shipping Agent Code");
    //                 lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code", lrc_Location."Departure Region Code");
    //                 lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", lrc_SalesHeader."Arrival Region Code");
    //                 lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base", lrc_ShippingAgent."Freight Cost Tariff Base");
    //                 IF lrc_ShippingAgent."Freight Cost Tariff Base" = lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //                     lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code", '');
    //                 lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1', ROUND(ldc_TranspUnitQty, 1, '>'));
    //                 lrc_ShipAgentFreightcost.SETFILTER("Untill Quantity", '>=%1', ROUND(ldc_TranspUnitQty, 1, '>'));
    //                 IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //                     IF lrc_ShipAgentFreightcost.Pauschal = TRUE THEN BEGIN
    //                         ldc_SalesFreightPerTranspUnit := lrc_ShipAgentFreightcost."Freight Rate per Unit" /
    //                                                          ROUND(ldc_TranspUnitQty, 1, '>');
    //                     END ELSE BEGIN
    //                         ldc_SalesFreightPerTranspUnit := lrc_ShipAgentFreightcost."Freight Rate per Unit";
    //                     END;
    //                 END;
    //             END;
    //         END;
    //         rdc_SalesFreightPerTranspUnit := ldc_SalesFreightPerTranspUnit;
    //     end;

    //     procedure SalesReLoadUnitCost(vop_SalesDocType: Option "0","1","2","3","4","5","6"; vop_SalesDocNo: Code[20])
    //     var
    //         lrc_SalesLine: Record "37";
    //     begin
    //         // ----------------------------------------------------------------------------
    //         // Funktion zum erneuten Laden der Einstandspreise
    //         // ----------------------------------------------------------------------------

    //         lrc_SalesLine.SETRANGE("Document Type", vop_SalesDocType);
    //         lrc_SalesLine.SETRANGE("Document No.", vop_SalesDocNo);
    //         IF lrc_SalesLine.FINDSET(TRUE, FALSE) THEN BEGIN
    //             REPEAT
    //                 IF (lrc_SalesLine.Type = lrc_SalesLine.Type::Item) AND
    //                    (lrc_SalesLine."No." <> '') THEN BEGIN
    //                     lrc_SalesLine.GetUnitCost();
    //                     lrc_SalesLine.Modify();
    //                 END;
    //             UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    procedure PurchCalcUnitCostUnit(vrc_PurchHeader: Record "Purchase Header")
    begin
        // ----------------------------------------------------------------------------
        // Funktion zur Berechnung des Einstandspreises für einen Einkauf
        // ----------------------------------------------------------------------------

        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
        IF lrc_PurchLine.FINDSET(TRUE, FALSE) THEN
            REPEAT
                IF (lrc_PurchLine.Type = lrc_PurchLine.Type::Item) AND
                   (lrc_PurchLine."No." <> '') AND
                   (lrc_PurchLine."Quantity Invoiced" = 0) THEN BEGIN
                    lrc_PurchLine.UpdateUnitCost();
                    lrc_PurchLine.MODIFY();
                END;
            UNTIL lrc_PurchLine.NEXT() = 0;
    end;

    //     procedure PurchLineCalcUnitCostUnit(vrc_PurchLine: Record "39"; vco_ShipmentMethod: Code[10]; var rdc_FreightCostUnit: Decimal; var rdc_IndirectCostUnit: Decimal; var rdc_UnitCostUnit: Decimal)
    //     var
    //         lrc_PurchHeader: Record "38";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         lrc_CostCategory: Record "5110345";
    //         lrc_StandardCostCalculations: Record "5110551";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_Location: Record "14";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_PriceBase: Record "5110320";
    //         lco_DeparturRegion: Code[20];
    //         lco_ArrivalRegion: Code[10];
    //         ldc_IndirectCostUnit: Decimal;
    //         ldc_SalesFreightPerUnit: Decimal;
    //         ldc_UnitCostUnit: Decimal;
    //         ldc_UnitCostPriceBase: Decimal;
    //         lrc_ShippingAgent: Record "291";
    //         lrc_PurchFreightCosts: Record "5110744";
    //         lbn_Found: Boolean;
    //         ldc_FreightCostAmount: Decimal;
    //     begin
    //         // ----------------------------------------------------------------------------
    //         // Einstandpreis berechnen
    //         // ----------------------------------------------------------------------------

    //         IF (vrc_PurchLine.Type = vrc_PurchLine.Type::Item) AND
    //            (vrc_PurchLine."No." <> '') AND
    //            (vrc_PurchLine."Quantity Invoiced" = 0) THEN BEGIN
    //         END ELSE BEGIN
    //             EXIT;
    //         END;

    //         lrc_PurchHeader.GET(vrc_PurchLine."Document Type", vrc_PurchLine."Document No.");

    //         // ----------------------------------------------------------------------------
    //         // Frachtkosten von Lieferant/Zwischenlager an Ziellager
    //         // ----------------------------------------------------------------------------
    //         IF vco_ShipmentMethod = '' THEN BEGIN
    //             vco_ShipmentMethod := lrc_PurchHeader."Shipment Method Code";
    //         END;

    //         IF lrc_ShipmentMethod.GET(vco_ShipmentMethod) THEN BEGIN
    //             IF (lrc_ShipmentMethod."Incl. Freight to Final Loc." = FALSE) AND
    //                (vrc_PurchLine."Shipping Agent Code" <> '') AND
    //                (vrc_PurchLine."Location Code" <> '') THEN BEGIN

    //                 // Fracht vom Zwischenlager zum Ziellager
    //                 IF (vrc_PurchLine."Location Code" <> '') AND
    //                    (vrc_PurchLine."Entry via Transfer Loc. Code" <> '') AND
    //                    (vrc_PurchLine."Entry via Transfer Loc. Code" <> vrc_PurchLine."Location Code") THEN BEGIN
    //                     lrc_Location.GET(vrc_PurchLine."Entry via Transfer Loc. Code");
    //                     lco_DeparturRegion := lrc_Location."Departure Region Code";
    //                     lrc_Location.GET(vrc_PurchLine."Location Code");
    //                     lco_ArrivalRegion := lrc_Location."Arrival Region Code";
    //                     // Fracht vom Lieferanten zum Ziellager
    //                 END ELSE BEGIN
    //                     lco_DeparturRegion := lrc_PurchHeader."Departure Region Code";
    //                     lrc_Location.GET(vrc_PurchLine."Location Code");
    //                     lco_ArrivalRegion := lrc_Location."Arrival Region Code";
    //                 END;

    //                 IF NOT lrc_ShippingAgent.GET(vrc_PurchLine."Shipping Agent Code") THEN
    //                     lrc_ShippingAgent.INIT();

    //                 lrc_ShipAgentFreightcost.Reset();
    //                 lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", vrc_PurchLine."Shipping Agent Code");
    //                 lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code", lco_DeparturRegion);
    //                 lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", lco_ArrivalRegion);
    //                 lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base", lrc_ShippingAgent."Freight Cost Tariff Base");
    //                 IF lrc_ShippingAgent."Freight Cost Tariff Base" =
    //                     lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN BEGIN
    //                     lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code", vrc_PurchLine."Freight Unit of Measure (FU)");
    //                 END;
    //                 lrc_ShipAgentFreightcost.SETRANGE(Pauschal, FALSE);
    //                 IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //                     CASE lrc_ShipAgentFreightcost."Freight Cost Tarif Base" OF
    //                         lrc_ShipAgentFreightcost."Freight Cost Tarif Base"::Collo:
    //                             ldc_SalesFreightPerUnit := lrc_ShipAgentFreightcost."Freight Rate per Unit";
    //                         lrc_ShipAgentFreightcost."Freight Cost Tarif Base"::"Pallet Type",
    //                         lrc_ShipAgentFreightcost."Freight Cost Tarif Base"::Pallet:
    //                             BEGIN
    //                                 IF vrc_PurchLine.Quantity <> 0 THEN BEGIN
    //                                     ldc_SalesFreightPerUnit := ROUND(ROUND(vrc_PurchLine."Quantity (TU)", 0.00001) *
    //                                                                    lrc_ShipAgentFreightcost."Freight Rate per Unit" /
    //                                                                    vrc_PurchLine.Quantity, 0.01, '>');
    //                                 END ELSE BEGIN
    //                                     ldc_SalesFreightPerUnit := 0;
    //                                 END;
    //                             END;
    //                     END;
    //                 END ELSE BEGIN
    //                     ldc_SalesFreightPerUnit := 0;
    //                 END;
    //             END;
    //         END;

    //         // NKS 001 NKS60003.s
    //         lrc_PurchFreightCosts.RESET();
    //         lrc_PurchFreightCosts.SETRANGE("Document Type", vrc_PurchLine."Document Type");
    //         lrc_PurchFreightCosts.SETRANGE("Doc. No.", vrc_PurchLine."Document No.");
    //         lrc_PurchFreightCosts.SETRANGE(Type, lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //         lrc_PurchFreightCosts.SETRANGE("Freight Cost Manual Entered", TRUE);
    //         lrc_PurchFreightCosts.SETRANGE("Freight Cost Tariff Base",
    //                                        lrc_PurchFreightCosts."Freight Cost Tariff Base"::Pallet);
    //         lbn_Found := lrc_PurchFreightCosts.FINDFIRST();

    //         IF NOT lbn_Found THEN BEGIN
    //             lrc_PurchFreightCosts.SETRANGE("Freight Cost Tariff Base",
    //                                            lrc_PurchFreightCosts."Freight Cost Tariff Base"::"Pallet Type");
    //             lrc_PurchFreightCosts.SETRANGE("Freight Unit Code", vrc_PurchLine."Freight Unit of Measure (FU)");
    //             lbn_Found := lrc_PurchFreightCosts.FINDFIRST();
    //         END;

    //         IF lbn_Found AND ((lrc_PurchFreightCosts."Freight Costs Amount (LCY)" <> 0) OR
    //           (lrc_PurchFreightCosts."Freight Cost Price (LCY)" <> 0)) THEN BEGIN
    //             ldc_FreightCostAmount := lrc_PurchFreightCosts."Freight Cost Price (LCY)";
    //             IF (ldc_FreightCostAmount = 0) AND (lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" <> 0) THEN BEGIN
    //                 ldc_FreightCostAmount := lrc_PurchFreightCosts."Freight Costs Amount (LCY)" /
    //                                          lrc_PurchFreightCosts."Qty. of Freight Units (SDF)";
    //             END;

    //             IF vrc_PurchLine.Quantity <> 0 THEN BEGIN
    //                 ldc_SalesFreightPerUnit := ROUND(ROUND(vrc_PurchLine."Quantity (TU)", 0.00001) *
    //                                                  ldc_FreightCostAmount / vrc_PurchLine.Quantity, 0.01, '>');
    //             END ELSE BEGIN
    //                 ldc_SalesFreightPerUnit := 0;
    //             END;
    //         END;
    //         // NKS 001 NKS60003.e

    //         // ----------------------------------------------------------------------------
    //         // Plankosten für Einkaufszeile berechnen
    //         // ----------------------------------------------------------------------------
    //         IF (vrc_PurchLine.Type = vrc_PurchLine.Type::Item) AND
    //            (vrc_PurchLine."No." <> '') AND
    //            (vrc_PurchLine.Subtyp = vrc_PurchLine.Subtyp::" ") THEN BEGIN
    //             lrc_CostCategory.SETRANGE("Indirect Cost (Purchase)", TRUE);
    //             IF lrc_CostCategory.FINDSET(FALSE, FALSE) THEN BEGIN
    //                 REPEAT
    //                     lrc_StandardCostCalculations.Reset();
    //                     lrc_StandardCostCalculations.SETCURRENTKEY("Cost Category Code", "Buy-From Vendor No.",
    //                       "Via Entry Location Code", "Entry Location Code", "Shipping Agent Code", "Customer Duty",
    //                       "Product Group Code", "Item No.", "Item Country of Origin Code", "Valid From");
    //                     lrc_StandardCostCalculations.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                     lrc_StandardCostCalculations.SETFILTER("Buy-From Vendor No.", '%1|%2', vrc_PurchLine."Buy-from Vendor No.", '');
    //                     lrc_StandardCostCalculations.SETFILTER("Via Entry Location Code", '%1|%2', vrc_PurchLine."Entry via Transfer Loc. Code", '');
    //                     lrc_StandardCostCalculations.SETFILTER("Entry Location Code", '%1|%2', vrc_PurchLine."Location Code", '');
    //                     lrc_StandardCostCalculations.SETFILTER("Item Category Code", '%1|%2', vrc_PurchLine."Item Category Code", '');
    //                     lrc_StandardCostCalculations.SETFILTER("Product Group Code", '%1|%2', vrc_PurchLine."Product Group Code", '');
    //                     lrc_StandardCostCalculations.SETFILTER("Item No.", '%1|%2', vrc_PurchLine."No.", '');
    //                     lrc_StandardCostCalculations.SETFILTER("Item Country of Origin Code", '%1|%2', vrc_PurchLine."Country of Origin Code", '');
    //                     lrc_StandardCostCalculations.SETFILTER("Shipping Agent Code", '%1|%2', vrc_PurchLine."Shipping Agent Code", '');
    //                     lrc_StandardCostCalculations.SETFILTER("Valid From", '<=%1', TODAY);
    //                     lrc_StandardCostCalculations.SETFILTER("Valid Till", '>=%1|%2', Today(), 0D);
    //                     IF lrc_StandardCostCalculations.FINDLAST THEN BEGIN
    //                         CASE lrc_StandardCostCalculations.Reference OF
    //                             lrc_StandardCostCalculations.Reference::Collo:
    //                                 BEGIN
    //                                     ldc_IndirectCostUnit := ldc_IndirectCostUnit + lrc_StandardCostCalculations."Reference Amount";
    //                                 END;
    //                             lrc_StandardCostCalculations.Reference::Pallet:
    //                                 BEGIN
    //                                     IF vrc_PurchLine.Quantity <> 0 THEN BEGIN
    //                                         ldc_IndirectCostUnit := ldc_IndirectCostUnit +
    //                                                               ROUND(ROUND(vrc_PurchLine."Quantity (TU)", 0.00001) *
    //                                                                     lrc_StandardCostCalculations."Reference Amount" /
    //                                                                     vrc_PurchLine.Quantity, 0.01, '>');
    //                                     END ELSE BEGIN
    //                                         ldc_IndirectCostUnit := 0;
    //                                     END;
    //                                 END;
    //                         END;
    //                     END;
    //                 UNTIL lrc_CostCategory.NEXT() = 0;
    //             END;
    //         END;

    //         ldc_UnitCostUnit := vrc_PurchLine."Direct Unit Cost" + ldc_IndirectCostUnit + ldc_SalesFreightPerUnit;

    //         IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price",
    //                              vrc_PurchLine."Price Base (Purch. Price)") THEN BEGIN
    //             CASE lrc_PriceBase."Internal Calc. Type" OF
    //                 lrc_PriceBase."Internal Calc. Type"::" ":
    //                     ldc_UnitCostPriceBase := ldc_UnitCostUnit;

    //                 lrc_PriceBase."Internal Calc. Type"::"Base Unit":
    //                     IF vrc_PurchLine."Qty. per Unit of Measure" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_PurchLine."Qty. per Unit of Measure";

    //                 lrc_PriceBase."Internal Calc. Type"::"Content Unit":
    //                     ;

    //                 lrc_PriceBase."Internal Calc. Type"::"Packing Unit":
    //                     IF vrc_PurchLine."Qty. (PU) per Unit of Measure" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_PurchLine."Qty. (PU) per Unit of Measure";

    //                 lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
    //                     ldc_UnitCostPriceBase := ldc_UnitCostUnit;

    //                 lrc_PriceBase."Internal Calc. Type"::"Transport Unit":
    //                     ;

    //                 lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
    //                     IF vrc_PurchLine."Gross Weight" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_PurchLine."Gross Weight";

    //                 lrc_PriceBase."Internal Calc. Type"::"Net Weight":
    //                     IF vrc_PurchLine."Net Weight" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_PurchLine."Net Weight";

    //                 lrc_PriceBase."Internal Calc. Type"::"Total Price":
    //                     ;
    //             END;
    //         END ELSE BEGIN
    //             ldc_UnitCostPriceBase := ldc_UnitCostUnit;
    //         END;

    //         // Rückgabewerte setzen
    //         rdc_FreightCostUnit := ldc_SalesFreightPerUnit;
    //         rdc_IndirectCostUnit := ldc_IndirectCostUnit;
    //         rdc_UnitCostUnit := ldc_UnitCostUnit;
    //     end;

    //     procedure PurchLineCalcUnitCostPriceBase(vrc_PurchLine: Record "39"): Decimal
    //     var
    //         lrc_PriceBase: Record "5110320";
    //         ldc_UnitCostUnit: Decimal;
    //         ldc_UnitCostPriceBase: Decimal;
    //     begin
    //         // -----------------------------------------------------------------------------------------------
    //         // Funktion zur Umrechnung des Einstandspreises pro Einheit in die Preiseinheit
    //         // -----------------------------------------------------------------------------------------------

    //         ldc_UnitCostUnit := vrc_PurchLine."Unit Cost (LCY)";

    //         IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price",
    //                              vrc_PurchLine."Price Base (Purch. Price)") THEN BEGIN
    //             CASE lrc_PriceBase."Internal Calc. Type" OF
    //                 lrc_PriceBase."Internal Calc. Type"::" ":
    //                     ldc_UnitCostPriceBase := ldc_UnitCostUnit;

    //                 lrc_PriceBase."Internal Calc. Type"::"Base Unit":
    //                     IF vrc_PurchLine."Qty. per Unit of Measure" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_PurchLine."Qty. per Unit of Measure";

    //                 lrc_PriceBase."Internal Calc. Type"::"Content Unit":
    //                     ;

    //                 lrc_PriceBase."Internal Calc. Type"::"Packing Unit":
    //                     IF vrc_PurchLine."Qty. (PU) per Unit of Measure" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_PurchLine."Qty. (PU) per Unit of Measure";

    //                 lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
    //                     ldc_UnitCostPriceBase := ldc_UnitCostUnit;

    //                 lrc_PriceBase."Internal Calc. Type"::"Transport Unit":
    //                     ;

    //                 lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
    //                     IF (vrc_PurchLine."Total Gross Weight" <> 0) AND (vrc_PurchLine.Quantity <> 0) THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / (vrc_PurchLine."Total Gross Weight" / vrc_PurchLine.Quantity);

    //                 lrc_PriceBase."Internal Calc. Type"::"Net Weight":
    //                     IF (vrc_PurchLine."Total Net Weight" <> 0) AND (vrc_PurchLine.Quantity <> 0) THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / (vrc_PurchLine."Total Net Weight" / vrc_PurchLine.Quantity);

    //                 lrc_PriceBase."Internal Calc. Type"::"Total Price":
    //                     ;
    //             END;
    //         END ELSE BEGIN
    //             ldc_UnitCostPriceBase := ldc_UnitCostUnit;
    //         END;

    //         EXIT(ldc_UnitCostPriceBase);
    //     end;

    //     procedure PurchTotalTransportQty(vco_PurchDocType: Option "0","1","2","3","4","5","6"; vco_PurchDocNo: Code[20]; var rdc_TranspUnitTotalQty: Decimal; var rco_ArrTransportItemNo: array[100] of Code[20]; var rdc_ArrTransportQty: array[100] of Decimal)
    //     var
    //         lcu_GlobalFunctionsMgt: Codeunit "5110300";
    //         lrc_PurchLine: Record "39";
    //         ldc_TranspUnitQty: Decimal;
    //         lin_ArrCounter: Integer;
    //     begin


    //         rdc_TranspUnitTotalQty := 0;
    //         CLEAR(rco_ArrTransportItemNo);
    //         CLEAR(rdc_ArrTransportQty);

    //         lrc_PurchLine.SETRANGE("Document Type", vco_PurchDocType);
    //         lrc_PurchLine.SETRANGE("Document No.", vco_PurchDocNo);
    //         IF lrc_PurchLine.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 IF (lrc_PurchLine.Type = lrc_PurchLine.Type::Item) AND
    //                    (lrc_PurchLine.Subtyp = lrc_PurchLine.Subtyp::" ") AND
    //                    (lrc_PurchLine."No." <> '') THEN BEGIN

    //                     ldc_TranspUnitQty := ldc_TranspUnitQty + lrc_PurchLine."Quantity (TU)";

    //                     IF lrc_PurchLine."Transport Unit of Measure (TU)" <> '' THEN BEGIN
    //                         // Funktion um ein Inhalt in einem Array zu finden
    //                         // vcoArrCode,vin_ArrDim,vco_SearchContent
    //                         IF lcu_GlobalFunctionsMgt.Arr100FindEntry(rco_ArrTransportItemNo, 10,
    //                                                                lrc_PurchLine."Transport Unit of Measure (TU)",
    //                                                                lin_ArrCounter) = FALSE THEN BEGIN
    //                             rco_ArrTransportItemNo[lin_ArrCounter] := rco_ArrTransportItemNo[lin_ArrCounter] +
    //                                                                       lrc_PurchLine."Transport Unit of Measure (TU)";
    //                             rdc_ArrTransportQty[lin_ArrCounter] := rdc_ArrTransportQty[lin_ArrCounter] +
    //                                                                    lrc_PurchLine."Quantity (TU)";
    //                         END ELSE BEGIN
    //                             rdc_ArrTransportQty[lin_ArrCounter] := rdc_ArrTransportQty[lin_ArrCounter] +
    //                                                                    lrc_PurchLine."Quantity (TU)";
    //                         END;
    //                     END;


    //                 END;
    //             UNTIL lrc_PurchLine.NEXT() = 0;
    //         END;

    //         rdc_TranspUnitTotalQty := ldc_TranspUnitQty;
    //     end;

    //     procedure BatchVarCalcUnitCostPriceBase(vrc_BatchVariant: Record "5110366"; var rdc_DirektUnitCostPriceBase: Decimal; var rdc_UnitCostPriceBase: Decimal)
    //     var
    //         lrc_PriceBase: Record "5110320";
    //         ldc_UnitCostUnit: Decimal;
    //         ldc_UnitCostPriceBase: Decimal;
    //         ldc_DirectUnitCostPriceBase: Decimal;
    //     begin
    //         // -----------------------------------------------------------------------------------------------
    //         // Funktion zur Umrechnung des Einstandspreises pro Einheit in die Preiseinheit
    //         // -----------------------------------------------------------------------------------------------

    //         ldc_UnitCostUnit := vrc_BatchVariant."Unit Cost (UOM) (LCY)";
    //         ldc_DirectUnitCostPriceBase := vrc_BatchVariant."Purch. Price (Price Base)";

    //         IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price",
    //                              vrc_BatchVariant."Price Base (Purch. Price)") THEN BEGIN
    //             CASE lrc_PriceBase."Internal Calc. Type" OF
    //                 lrc_PriceBase."Internal Calc. Type"::" ":
    //                     ldc_UnitCostPriceBase := ldc_UnitCostUnit;

    //                 lrc_PriceBase."Internal Calc. Type"::"Base Unit":
    //                     IF vrc_BatchVariant."Qty. per Unit of Measure" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_BatchVariant."Qty. per Unit of Measure";

    //                 lrc_PriceBase."Internal Calc. Type"::"Content Unit":
    //                     ;

    //                 lrc_PriceBase."Internal Calc. Type"::"Packing Unit":
    //                     IF vrc_BatchVariant."Qty. (PU) per Collo (CU)" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_BatchVariant."Qty. (PU) per Collo (CU)";

    //                 lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
    //                     ldc_UnitCostPriceBase := ldc_UnitCostUnit;

    //                 lrc_PriceBase."Internal Calc. Type"::"Transport Unit":
    //                     ;

    //                 lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
    //                     IF vrc_BatchVariant."Gross Weight" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_BatchVariant."Gross Weight";

    //                 lrc_PriceBase."Internal Calc. Type"::"Net Weight":
    //                     IF vrc_BatchVariant."Net Weight" <> 0 THEN
    //                         ldc_UnitCostPriceBase := ldc_UnitCostUnit / vrc_BatchVariant."Net Weight";

    //                 lrc_PriceBase."Internal Calc. Type"::"Total Price":
    //                     ;
    //             END;
    //         END ELSE BEGIN
    //             ldc_UnitCostPriceBase := ldc_UnitCostUnit;
    //         END;

    //         rdc_UnitCostPriceBase := ldc_UnitCostPriceBase;
    //         rdc_DirektUnitCostPriceBase := ldc_DirectUnitCostPriceBase;
    //     end;
}

