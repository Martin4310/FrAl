codeunit 5110313 "POI Freight Management"
{
    //     // Permissions = TableData 37=rimd,
    //     //               TableData 5087923=rimd,
    //     //               TableData 5110549=rimd;

    //     procedure TransferSetLocShipAgent(vco_TransferNo: Code[20])
    //     var
    //         lrc_TransferHeader: Record "Transfer Header";
    //         lrc_TransferLine: Record "Transfer Line";
    //         lrc_TransferFreightCosts: Record "5110407";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_ShipAgentDepRegTarif: Record "5110335";
    //         lbn_FrachtAufBasisPalettenTyp: Boolean;
    //         lco_DepartureRegionCode: Code[10];
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Setzen der Lager und Spediteure pro Umlagerungsauftrag
    //         // ---------------------------------------------------------------------------------

    //         lrc_TransferHeader.GET(vco_TransferNo);
    //         lrc_TransferHeader.TESTFIELD("Departure Region Code");

    //         lrc_ShippingAgent.GET(lrc_TransferHeader."Shipping Agent Code");

    //         // Löschung von Sätzen die durch Änderung nicht mehr benötigt werden
    //         lrc_TransferFreightCosts.RESET();
    //         lrc_TransferFreightCosts.SETRANGE("Transfer Doc. No.",lrc_TransferHeader."No.");
    //         lrc_TransferFreightCosts.SETFILTER("Shipping Agent Code",'<>%1',lrc_TransferHeader."Shipping Agent Code");
    //         IF lrc_TransferFreightCosts.FIND('-') THEN
    //           lrc_TransferFreightCosts.DELETEALL();

    //         lbn_FrachtAufBasisPalettenTyp := FALSE;
    //         lrc_ShipAgentDepRegTarif.RESET();
    //         lrc_ShipAgentDepRegTarif.SETRANGE("Shipping Agent Code",lrc_TransferHeader."Shipping Agent Code");
    //         lrc_ShipAgentDepRegTarif.SETRANGE("Departure Region Code",lrc_TransferHeader."Departure Region Code");
    //         IF lrc_ShipAgentDepRegTarif.FIND('-') THEN BEGIN
    //           IF lrc_ShipAgentDepRegTarif."Freight Cost Tariff Base" =
    //              lrc_ShipAgentDepRegTarif."Freight Cost Tariff Base"::"Pallet Type" THEN BEGIN
    //             lbn_FrachtAufBasisPalettenTyp := TRUE;
    //           END;
    //         END ELSE BEGIN
    //           IF lrc_ShippingAgent."Freight Cost Tariff Base" =
    //              lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //             lbn_FrachtAufBasisPalettenTyp := TRUE;
    //         END;


    //         IF lbn_FrachtAufBasisPalettenTyp = TRUE THEN BEGIN
    //           lrc_TransferLine.RESET();
    //           lrc_TransferLine.SETRANGE("Document No.",lrc_TransferHeader."No.");
    //           IF lrc_TransferLine.FIND('-') THEN
    //             REPEAT
    //               IF lrc_TransferLine."Freight Unit of Measure" = '' THEN BEGIN
    //                 lrc_UnitofMeasure.GET(lrc_TransferLine."Transport Unit of Measure (TU)");
    //                 lrc_TransferLine."Freight Unit of Measure" := lrc_UnitofMeasure."Freight Unit of Measure (FU)";
    //                 lrc_TransferLine.MODIFY();
    //               END;
    //               lrc_TransferFreightCosts.RESET();
    //               lrc_TransferFreightCosts.INIT();
    //               lrc_TransferFreightCosts."Transfer Doc. No." := lrc_TransferHeader."No.";
    //               lrc_TransferFreightCosts."Entry Type" := lrc_TransferFreightCosts."Entry Type"::"Sped.+AbgReg.+Frachteinheit";
    //               lrc_TransferFreightCosts."Shipping Agent Code" := lrc_TransferHeader."Shipping Agent Code";
    //               lrc_TransferFreightCosts."Freight Departure Region" := lrc_TransferHeader."Departure Region Code";
    //               lrc_TransferFreightCosts."Freight Unit Code" := lrc_TransferLine."Freight Unit of Measure";
    //               lrc_TransferFreightCosts."Freight Cost Manual" := FALSE;
    //               lrc_TransferFreightCosts."Freight Cost Tarif Level" := lrc_ShippingAgent."Freight Cost Tariff Level"::"Departure Region";
    //               lrc_TransferFreightCosts."Freight Cost Tarif Base" := lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type";
    //               IF NOT lrc_TransferFreightCosts.INSERT THEN;
    //             UNTIL lrc_TransferLine.NEXT() = 0;
    //         END ELSE BEGIN
    //           lrc_TransferFreightCosts.RESET();
    //           lrc_TransferFreightCosts.INIT();
    //           lrc_TransferFreightCosts."Transfer Doc. No." := lrc_TransferHeader."No.";
    //           lrc_TransferFreightCosts."Entry Type" := lrc_TransferFreightCosts."Entry Type"::"Sped.+AbgReg.+Frachteinheit";
    //           lrc_TransferFreightCosts."Shipping Agent Code" := lrc_TransferHeader."Shipping Agent Code";
    //           lrc_TransferFreightCosts."Freight Departure Region" := lrc_TransferHeader."Departure Region Code";
    //           lrc_TransferFreightCosts."Freight Unit Code" := '';
    //           lrc_TransferFreightCosts."Freight Cost Manual" := FALSE;
    //           lrc_TransferFreightCosts."Freight Cost Tarif Level" := lrc_ShippingAgent."Freight Cost Tariff Level"::"Departure Region";

    //           lrc_ShipAgentDepRegTarif.RESET();
    //           lrc_ShipAgentDepRegTarif.SETRANGE("Shipping Agent Code",lrc_TransferHeader."Shipping Agent Code");
    //           lrc_ShipAgentDepRegTarif.SETRANGE("Departure Region Code",lrc_TransferHeader."Departure Region Code");
    //           IF lrc_ShipAgentDepRegTarif.FIND('-') THEN
    //             lrc_TransferFreightCosts."Freight Cost Tarif Base" := lrc_ShipAgentDepRegTarif."Freight Cost Tariff Base"
    //           ELSE
    //             lrc_TransferFreightCosts."Freight Cost Tarif Base" := lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type";

    //           IF NOT lrc_TransferFreightCosts.INSERT THEN;
    //         END;
    //     end;

    //     procedure TransferFreightsPerOrder(vco_TransferNo: Code[20])
    //     var
    //         lrc_TransferHeader: Record "Transfer Header";
    //         lrc_TransferLine: Record "Transfer Line";
    //         lrc_TransferFreightCosts: Record "5110407";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         "--- FRA 009 DMG50000": Integer;
    //         ldc_TUQuantity: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Frachtkosten pro Umlagerungsauftrag
    //         // ---------------------------------------------------------------------------------

    //         lrc_TransferHeader.GET(vco_TransferNo);
    //         IF (lrc_TransferHeader."Transfer-from Code" = '') OR
    //            (lrc_TransferHeader."Shipping Agent Code" = '') THEN
    //           EXIT;

    //         lrc_ShippingAgent.GET(lrc_TransferHeader."Shipping Agent Code");

    //         lrc_TransferFreightCosts.RESET();
    //         lrc_TransferFreightCosts.SETRANGE("Transfer Doc. No.",lrc_TransferHeader."No.");
    //         lrc_TransferFreightCosts.SETRANGE("Entry Type",lrc_TransferFreightCosts."Entry Type"::"Sped.+AbgReg.+Frachteinheit");
    //         lrc_TransferFreightCosts.SETRANGE("Shipping Agent Code",lrc_TransferHeader."Shipping Agent Code");
    //         IF lrc_TransferFreightCosts.FIND('-') THEN BEGIN
    //           REPEAT
    //             IF lrc_TransferFreightCosts."Freight Cost Manual" = TRUE THEN BEGIN
    //               // Manuelle Frachtkosten validieren damit auch neue Zeilen berücksichtigt werden!
    //               lrc_TransferFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)");
    //             END ELSE BEGIN
    //               CASE lrc_TransferFreightCosts."Freight Cost Tarif Base" OF
    //               lrc_TransferFreightCosts."Freight Cost Tarif Base"::Weight:
    //                 BEGIN
    //                   lrc_TransferFreightCosts.CALCFIELDS("Gross Weight");

    //                   lrc_ShipAgentFreightcost.RESET();
    //                   lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_TransferFreightCosts."Shipping Agent Code");
    //                   lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_TransferHeader."POI Arrival Region Code");
    //                   lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_TransferHeader."Departure Region Code");
    //                   lrc_ShipAgentFreightcost.SETFILTER("From Quantity",
    //                                                           '<=%1',lrc_TransferFreightCosts."Gross Weight");
    //                   lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",
    //                                                           '>=%1',lrc_TransferFreightCosts."Gross Weight");
    //                   IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
    //                     IF lrc_ShipAgentFreightcost.Pauschal THEN
    //                       lrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" :=
    //                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                     ELSE
    //                       lrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" :=
    //                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                  lrc_TransferFreightCosts."Gross Weight";
    //                     lrc_TransferFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)");
    //                     lrc_TransferFreightCosts."Freight Rate" := TRUE;
    //                     lrc_TransferFreightCosts.MODIFY();
    //                   END ELSE BEGIN
    //                     lrc_TransferFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)",0);
    //                     lrc_TransferFreightCosts."Freight Rate" := FALSE;
    //                     lrc_TransferFreightCosts.MODIFY();
    //                   END;
    //                 END;

    //               lrc_TransferFreightCosts."Freight Cost Tarif Base"::Pallet:
    //                 BEGIN
    //                   lrc_TransferFreightCosts.CALCFIELDS(Quantity);

    //                   // FRA 009 DMG50000.s
    //                   ldc_TUQuantity := lrc_TransferFreightCosts.Quantity;
    //                   ldc_TUQuantity := PalletTolerance(ldc_TUQuantity, lrc_TransferFreightCosts."Shipping Agent Code");
    //                   // FRA 009 DMG50000.e

    //                   lrc_ShipAgentFreightcost.RESET();
    //                   lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_TransferFreightCosts."Shipping Agent Code");
    //                   lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_TransferHeader."POI Arrival Region Code");
    //                   lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_TransferHeader."Departure Region Code");
    //                   lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",lrc_TransferFreightCosts."Freight Unit Code");
    //                   // FRA 009 DMG50000.s
    //                   // lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                   //                                         ROUND(lrc_TransferFreightCosts.Quantity,1,'>'));
    //                   // lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                   //                                         ROUND(lrc_TransferFreightCosts.Quantity,1,'>'));
    //                   lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                                                           ROUND(ldc_TUQuantity,1,'>'));
    //                   lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                                                           ROUND(ldc_TUQuantity,1,'>'));
    //                   // FRA 009 DMG50000.e
    //                   IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
    //                     IF lrc_ShipAgentFreightcost.Pauschal THEN
    //                       lrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" := lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                     ELSE
    //                       lrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" :=
    //                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                  // FRA 009 DMG50000.s
    //                                                  // ROUND(lrc_TransferFreightCosts.Quantity,1,'>');
    //                                                  ROUND(ldc_TUQuantity,1,'>');
    //                                                  // FRA 009 DMG50000.e
    //                     lrc_TransferFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)");
    //                     lrc_TransferFreightCosts."Freight Rate" := TRUE;
    //                     lrc_TransferFreightCosts.MODIFY();
    //                   END ELSE BEGIN
    //                     lrc_TransferFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)",0);
    //                     lrc_TransferFreightCosts."Freight Rate" := FALSE;
    //                     lrc_TransferFreightCosts.MODIFY();
    //                   END;
    //                 END;

    //               lrc_TransferFreightCosts."Freight Cost Tarif Base"::"Pallet Type":
    //                 BEGIN
    //                   lrc_TransferFreightCosts.CALCFIELDS("No. of Freight Units");

    //                   // FRA 009 DMG50000.s
    //                   ldc_TUQuantity := lrc_TransferFreightCosts."No. of Freight Units";
    //                   ldc_TUQuantity := PalletTolerance(ldc_TUQuantity, lrc_TransferFreightCosts."Shipping Agent Code");
    //                   // FRA 009 DMG50000.e

    //                   lrc_ShipAgentFreightcost.RESET();
    //                   lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_TransferFreightCosts."Shipping Agent Code");
    //                   lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_TransferHeader."POI Arrival Region Code");
    //                   lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_TransferHeader."Departure Region Code");
    //                   lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",lrc_TransferFreightCosts."Freight Unit Code");
    //                   // FRA 009 DMG50000.s
    //                   // lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                   //                                         ROUND(lrc_TransferFreightCosts."No. of Freight Units",1,'>'));
    //                   // lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                   //                                         ROUND(lrc_TransferFreightCosts."No. of Freight Units",1,'>'));
    //                   lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                                                           ROUND(ldc_TUQuantity ,1,'>'));
    //                   lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                                                           ROUND(ldc_TUQuantity ,1,'>'));
    //                   // FRA 009 DMG50000.e
    //                   IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
    //                     IF lrc_ShipAgentFreightcost.Pauschal THEN
    //                       lrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" := lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                     ELSE
    //                       lrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" :=
    //                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                  // FRA 009 DMG50000.s
    //                                                  // ROUND(lrc_TransferFreightCosts."No. of Freight Units",1,'>');
    //                                                  ROUND(ldc_TUQuantity,1,'>');
    //                                                  // FRA 009 DMG50000.e
    //                     lrc_TransferFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)");
    //                     lrc_TransferFreightCosts."Freight Rate" := TRUE;
    //                     lrc_TransferFreightCosts.MODIFY();
    //                   END ELSE BEGIN
    //                     lrc_TransferFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)",0);
    //                     lrc_TransferFreightCosts."Freight Rate" := FALSE;
    //                     lrc_TransferFreightCosts.MODIFY();
    //                   END;
    //                 END;

    //               lrc_TransferFreightCosts."Freight Cost Tarif Base"::"Collo Weight":
    //                 BEGIN
    //                   ERROR('Collo Weight ist nicht codiert!');
    //                 END;
    //               lrc_TransferFreightCosts."Freight Cost Tarif Base"::Collo:
    //                 BEGIN
    //                   ERROR('Collo ist nicht codiert!');
    //                 END;
    //               END;
    //             END;
    //           UNTIL lrc_TransferFreightCosts.NEXT() = 0;
    //         END;
    //     end;

    //     procedure TransferFreightAllocLines(vco_TransferNo: Code[20])
    //     var
    //         lrc_TransferFreightCosts: Record "5110407";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------

    //         lrc_TransferFreightCosts.RESET();
    //         lrc_TransferFreightCosts.SETRANGE("Transfer Doc. No.",vco_TransferNo);
    //         lrc_TransferFreightCosts.SETRANGE("Entry Type",lrc_TransferFreightCosts."Entry Type"::"Sped.+AbgReg.+Frachteinheit");
    //         IF lrc_TransferFreightCosts.FIND('-') THEN BEGIN
    //           REPEAT
    //             TransferFreightAllocPerLine(lrc_TransferFreightCosts);
    //           UNTIL lrc_TransferFreightCosts.NEXT() = 0;
    //         END;
    //     end;

    //     procedure TransferFreightAllocPerLine(rrc_TransferFreightCosts: Record "5110407")
    //     var
    //         lrc_TransferLine: Record "Transfer Line";
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zur Verteilung der Umlagerungs Frachtkosten auf die Zeilen
    //         // --------------------------------------------------------------------------------------

    //         IF (rrc_TransferFreightCosts."Entry Type" = rrc_TransferFreightCosts."Entry Type"::"Sped.+AbgReg.+Frachteinheit") THEN BEGIN

    //           lrc_TransferLine.SETRANGE("Document No.",rrc_TransferFreightCosts."Transfer Doc. No.");
    //           IF rrc_TransferFreightCosts."Freight Unit Code" <> '' THEN
    //             lrc_TransferLine.SETRANGE("Freight Unit of Measure",rrc_TransferFreightCosts."Freight Unit Code");
    //           IF lrc_TransferLine.FIND('-') THEN BEGIN
    //             REPEAT

    //               CASE rrc_TransferFreightCosts."Freight Cost Tarif Base" OF
    //                 rrc_TransferFreightCosts."Freight Cost Tarif Base"::"Pallet Type":
    //                 BEGIN
    //                   rrc_TransferFreightCosts.CALCFIELDS("No. of Freight Units");
    //                   lrc_TransferLine."POI Reference Freight Costs" := lrc_TransferLine."POI Reference Freight Costs"::"Pallet Type";
    //                   IF rrc_TransferFreightCosts."No. of Freight Units" <> 0 THEN
    //                     lrc_TransferLine.VALIDATE("POI Freight Cost per Ref. Unit",
    //                                               (rrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" /
    //                                                rrc_TransferFreightCosts."No. of Freight Units"))
    //                   ELSE
    //                     lrc_TransferLine.VALIDATE("POI Freight Cost per Ref. Unit",0);
    //                   lrc_TransferLine.MODIFY();
    //                 END;


    //                 rrc_TransferFreightCosts."Freight Cost Tarif Base"::Pallet:
    //                 BEGIN
    //                   rrc_TransferFreightCosts.CALCFIELDS(Quantity);
    //                   lrc_TransferLine."POI Reference Freight Costs" := rrc_TransferFreightCosts."Freight Cost Tarif Base";
    //                   IF rrc_TransferFreightCosts.Quantity <> 0 THEN
    //                     lrc_TransferLine.VALIDATE("POI Freight Cost per Ref. Unit",
    //                                              (rrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" /
    //                                               rrc_TransferFreightCosts.Quantity))
    //                   ELSE
    //                     lrc_TransferLine.VALIDATE("POI Freight Cost per Ref. Unit",0);
    //                   lrc_TransferLine.MODIFY();
    //                 END;

    //                 rrc_TransferFreightCosts."Freight Cost Tarif Base"::Collo:
    //                 BEGIN
    //                 /*
    //                   rrc_SalesFreightCosts.CALCFIELDS("Anzahl Kolli");
    //                   lrc_SalesLine."POI Reference Freight Costs" := rrc_SalesFreightCosts."Frachtkosten Tariffbasis";
    //                   IF rrc_SalesFreightCosts."Anzahl Kolli" <> 0 THEN
    //                     lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit",(rrc_SalesFreightCosts."POI Freight Costs Amount (LCY)" /
    //                                                                           rrc_SalesFreightCosts."Anzahl Kolli"))
    //                     ELSE
    //                       lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit",0);
    //                   lrc_SalesLine.MODIFY();
    //                  */
    //                 END;

    //                 rrc_TransferFreightCosts."Freight Cost Tarif Base"::Weight:
    //                 BEGIN
    //                   rrc_TransferFreightCosts.CALCFIELDS("Gross Weight");
    //                   lrc_TransferLine."POI Reference Freight Costs" := rrc_TransferFreightCosts."Freight Cost Tarif Base";
    //                   IF rrc_TransferFreightCosts."Gross Weight" <> 0 THEN
    //                     lrc_TransferLine.VALIDATE("POI Freight Cost per Ref. Unit",
    //                                               (rrc_TransferFreightCosts."POI Freight Costs Amount (LCY)" /
    //                                                rrc_TransferFreightCosts."Gross Weight"))
    //                   ELSE
    //                     lrc_TransferLine.VALIDATE("POI Freight Cost per Ref. Unit",0);
    //                   lrc_TransferLine.MODIFY();
    //                 END;

    //               END;

    //             UNTIL lrc_TransferLine.NEXT() = 0;
    //           END;
    //         END;

    //     end;

    //     procedure TransferShowFreights(vco_TransferNo: Code[20])
    //     var
    //         lrc_TransferFreightCosts: Record "5110407";
    //         lfm_TransferFreightCosts: Form "5088103";
    //     begin
    //         // -----------------------------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Frachtkosten je Spediteur
    //         // -----------------------------------------------------------------------------------------------------------

    //         lrc_TransferFreightCosts.RESET();
    //         lrc_TransferFreightCosts.SETRANGE("Transfer Doc. No.",vco_TransferNo);
    //         lrc_TransferFreightCosts.SETRANGE("Entry Type",lrc_TransferFreightCosts."Entry Type"::"Sped.+AbgReg.+Frachteinheit");
    //         lfm_TransferFreightCosts.SETTABLEVIEW(lrc_TransferFreightCosts);
    //         lfm_TransferFreightCosts.RUNMODAL;

    //         lrc_TransferFreightCosts.RESET();
    //         lrc_TransferFreightCosts.SETRANGE("Transfer Doc. No.",vco_TransferNo);
    //         lrc_TransferFreightCosts.SETRANGE("Entry Type",lrc_TransferFreightCosts."Entry Type"::"Sped.+AbgReg.+Frachteinheit");
    //         IF lrc_TransferFreightCosts.FIND('-') THEN BEGIN
    //           REPEAT
    //             TransferFreightAllocPerLine(lrc_TransferFreightCosts);
    //           UNTIL lrc_TransferFreightCosts.NEXT() = 0;
    //         END;
    //     end;

    //     procedure TransferFreightCostDuty(vco_TransferNo: Code[20])
    //     var
    //         lrc_TransferHeader: Record "Transfer Header";
    //         lrc_TransferDocType: Record "5110412";
    //         AGILES_TEXT001: Label 'Bitte geben Sie die Frachtkosten ein!';
    //     begin
    //         // -----------------------------------------------------------------------------------------------------------
    //         // Funktion zur Kontrolle Fracht falls Pflichtfeld
    //         // -----------------------------------------------------------------------------------------------------------

    //         lrc_TransferHeader.GET(vco_TransferNo);
    //         lrc_TransferDocType.GET(lrc_TransferHeader."Transfer Doc. Subtype Code");

    //         IF lrc_TransferDocType."Transfer Freight Cost" <> lrc_TransferDocType."Transfer Freight Cost"::" " THEN BEGIN
    //           lrc_TransferHeader.CALCFIELDS("Freight Costs (LCY)");
    //           IF lrc_TransferHeader."Freight Costs (LCY)" <= 0 THEN
    //             // Bitte geben Sie die Frachtkosten ein!
    //             ERROR(AGILES_TEXT001);
    //         END;
    //     end;

    //     procedure TransferCalcQtyInFreightOrders(vco_OrderNo: Code[20];vco_OrderLineNo: Integer): Decimal
    //     var
    //         lrc_FreightOrderDetailLine: Record "5110440";
    //         ldc_QtyInFreightOrders: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Menge in Frachtaufträgen
    //         // ---------------------------------------------------------------------------------


    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source",lrc_FreightOrderDetailLine."Doc. Source"::Transfer);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Type",lrc_FreightOrderDetailLine."Doc. Source Type"::Order);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source No.",vco_OrderNo);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Line No.",vco_OrderLineNo);
    //         IF lrc_FreightOrderDetailLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             ldc_QtyInFreightOrders := ldc_QtyInFreightOrders + lrc_FreightOrderDetailLine."Qty. to Ship";
    //           UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;
    //         END;

    //         EXIT(ldc_QtyInFreightOrders);
    //     end;


    procedure SalesSetLocShipAgent(vrc_SalesHeader: Record "Sales Header")
    var
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Location: Record Location;
        lrc_ShippingAgent: Record "Shipping Agent";
        lrc_ShipAgentDepRegTarif: Record "POI Ship.Agent Dep. Reg. Tarif";
    begin
        // ------------------------------------------------------------------------------------------------------
        // Funktion zum Setzen der Lager - Zusteller Kombinationen aus einem Verkaufsdokument
        // ------------------------------------------------------------------------------------------------------

        // Kontrolle auf Lagerortgruppe
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
        lrc_SalesLine.SETRANGE("POI Subtyp", lrc_SalesLine."POI Subtyp"::" ");
        IF lrc_SalesLine.FIND('-') THEN
            REPEAT
                // Werte ergänzen falls fehlend
                IF (lrc_SalesLine."Location Code" <> '') AND
                   (lrc_SalesLine."POI Location Group Code" = '') THEN BEGIN
                    lrc_Location.GET(lrc_SalesLine."Location Code");
                    lrc_SalesLine."POI Location Group Code" := lrc_Location."POI Location Group Code";
                END;
                IF (lrc_SalesLine."POI Transp. Unit of Meas (TU)" <> '') AND
                   (lrc_SalesLine."POI Freight Unit of Meas (FU)" = '') THEN BEGIN
                    lrc_UnitofMeasure.GET(lrc_SalesLine."POI Transp. Unit of Meas (TU)");
                    lrc_SalesLine."POI Freight Unit of Meas (FU)" := lrc_UnitofMeasure."POI Freight Unit of Meas (FU)";
                END;
                IF (lrc_SalesLine."Shipping Agent Code" = '') THEN
                    IF vrc_SalesHeader."Shipping Agent Code" <> '' THEN
                        lrc_SalesLine."Shipping Agent Code" := vrc_SalesHeader."Shipping Agent Code";

                // Abgangsregion ermitteln
                IF (lrc_SalesLine."Location Code" <> '') AND
                   (lrc_SalesLine."Shipping Agent Code" <> '') THEN BEGIN
                    lrc_ShipAgentDepRegLoc.RESET();
                    lrc_ShipAgentDepRegLoc.SETFILTER("Shipping Agent Code", '%1|%2', '', lrc_SalesLine."Shipping Agent Code");
                    lrc_ShipAgentDepRegLoc.SETRANGE("Location Code", lrc_SalesLine."Location Code");
                    IF lrc_ShipAgentDepRegLoc.FIND('+') THEN
                        lrc_SalesLine."POI Departure Region Code" := lrc_ShipAgentDepRegLoc."Departure Region Code"
                    ELSE
                        lrc_SalesLine."POI Departure Region Code" := '';
                END ELSE
                    lrc_SalesLine."POI Departure Region Code" := '';
                lrc_SalesLine.MODIFY();
            UNTIL lrc_SalesLine.NEXT() = 0;



        // ----------------------------------------------------------------------------------------------------
        //
        // ----------------------------------------------------------------------------------------------------
        lrc_SalesFreightCosts.RESET();
        lrc_SalesFreightCosts.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesFreightCosts.SETRANGE("Doc. No.", vrc_SalesHeader."No.");
        lrc_SalesFreightCosts.SETRANGE(Type, lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
        lrc_SalesFreightCosts.SETRANGE("Freight Cost Manual Entered", FALSE);
        IF lrc_SalesFreightCosts.FINDSET(FALSE, FALSE) THEN
            REPEAT
                lrc_SalesFreightCosts.DELETE();
            UNTIL lrc_SalesFreightCosts.NEXT() = 0;

        // ----------------------------------------------------------------------------------------------------
        // Zeilenkombinationen löschen falls diese nicht mehr vorhanden sind aufgrund von Änderungen
        // in den Sales Lines
        // ----------------------------------------------------------------------------------------------------
        lrc_SalesFreightCosts.RESET();
        lrc_SalesFreightCosts.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesFreightCosts.SETRANGE("Doc. No.", vrc_SalesHeader."No.");
        IF lrc_SalesFreightCosts.FIND('-') THEN
            REPEAT

                lrc_SalesLine.RESET();

                CASE lrc_SalesFreightCosts.Type OF
                    lrc_SalesFreightCosts.Type::Spediteur:
                        BEGIN
                            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesFreightCosts."Document Type");
                            lrc_SalesLine.SETRANGE("Document No.", lrc_SalesFreightCosts."Doc. No.");
                            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                            lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                            lrc_SalesLine.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts."Shipping Agent Code");
                            IF NOT lrc_SalesLine.FIND('-') THEN
                                lrc_SalesFreightCosts.DELETE();
                        END;
                    lrc_SalesFreightCosts.Type::Lager:
                        BEGIN
                            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesFreightCosts."Document Type");
                            lrc_SalesLine.SETRANGE("Document No.", lrc_SalesFreightCosts."Doc. No.");
                            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                            lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                            lrc_SalesLine.SETRANGE("Location Code", lrc_SalesFreightCosts."Location Code");
                            IF NOT lrc_SalesLine.FIND('-') THEN
                                lrc_SalesFreightCosts.DELETE();
                        END;
                    lrc_SalesFreightCosts.Type::"Lager+Spediteur":
                        BEGIN
                            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesFreightCosts."Document Type");
                            lrc_SalesLine.SETRANGE("Document No.", lrc_SalesFreightCosts."Doc. No.");
                            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                            lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                            lrc_SalesLine.SETRANGE("Location Code", lrc_SalesFreightCosts."Location Code");
                            lrc_SalesLine.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts."Shipping Agent Code");
                            IF NOT lrc_SalesLine.FIND('-') THEN
                                lrc_SalesFreightCosts.DELETE();
                        END;
                    lrc_SalesFreightCosts.Type::"Sped.+AbgReg":
                        BEGIN
                            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesFreightCosts."Document Type");
                            lrc_SalesLine.SETRANGE("Document No.", lrc_SalesFreightCosts."Doc. No.");
                            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                            lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                            lrc_SalesLine.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts."Shipping Agent Code");
                            lrc_SalesLine.SETRANGE("POI Departure Region Code", lrc_SalesFreightCosts."Departure Region Code");
                            IF NOT lrc_SalesLine.FIND('-') THEN
                                lrc_SalesFreightCosts.DELETE();
                        END;
                    lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit":
                        IF lrc_SalesFreightCosts."Freight Unit Code" <> '' THEN BEGIN
                            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesFreightCosts."Document Type");
                            lrc_SalesLine.SETRANGE("Document No.", lrc_SalesFreightCosts."Doc. No.");
                            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                            lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                            lrc_SalesLine.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts."Shipping Agent Code");
                            lrc_SalesLine.SETRANGE("POI Departure Region Code", lrc_SalesFreightCosts."Departure Region Code");
                            lrc_SalesLine.SETRANGE("POI Freight Unit of Meas (FU)", lrc_SalesFreightCosts."Freight Unit Code");
                            IF NOT lrc_SalesLine.FIND('-') THEN
                                lrc_SalesFreightCosts.DELETE();
                        END ELSE BEGIN
                            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesFreightCosts."Document Type");
                            lrc_SalesLine.SETRANGE("Document No.", lrc_SalesFreightCosts."Doc. No.");
                            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                            lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                            lrc_SalesLine.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts."Shipping Agent Code");
                            lrc_SalesLine.SETRANGE("POI Departure Region Code", lrc_SalesFreightCosts."Departure Region Code");
                            IF NOT lrc_SalesLine.FINDFIRST() THEN
                                lrc_SalesFreightCosts.DELETE();
                        END;
                END;
            UNTIL lrc_SalesFreightCosts.NEXT() = 0;
        // -------------------------------------------------------------------------------------------------
        // Nicht vorhandene Zeilenkombinationen aufbauen
        // -------------------------------------------------------------------------------------------------
        lrc_SalesFreightCosts.RESET();
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
        lrc_SalesLine.SETFILTER("No.", '<>%1', '');
        lrc_SalesLine.SETFILTER("Shipping Agent Code", '<>%1', '');
        lrc_SalesLine.SETRANGE("POI Subtyp", lrc_SalesLine."POI Subtyp"::" ");
        IF lrc_SalesLine.FIND('-') THEN
            REPEAT
                lrc_ShippingAgent.GET(lrc_SalesLine."Shipping Agent Code");
                lrc_Location.GET(lrc_SalesLine."Location Code");
                IF lrc_SalesLine."Shipping Agent Code" <> '' THEN
                    IF NOT lrc_SalesFreightCosts.GET(lrc_SalesLine."Document Type",
                                                     lrc_SalesLine."Document No.",
                                                     lrc_SalesFreightCosts.Type::Spediteur,
                                                     '',
                                                     '',
                                                     '',
                                                     lrc_SalesLine."Shipping Agent Code", '') THEN BEGIN
                        lrc_SalesFreightCosts.RESET();
                        lrc_SalesFreightCosts.INIT();
                        lrc_SalesFreightCosts."Document Type" := lrc_SalesLine."Document Type";
                        lrc_SalesFreightCosts."Doc. No." := lrc_SalesLine."Document No.";
                        lrc_SalesFreightCosts.Type := lrc_SalesFreightCosts.Type::Spediteur;
                        lrc_SalesFreightCosts."Departure Region Code" := '';
                        lrc_SalesFreightCosts."Location Code" := '';
                        lrc_SalesFreightCosts."Location Group Code" := '';
                        lrc_SalesFreightCosts."Shipping Agent Code" := lrc_SalesLine."Shipping Agent Code";
                        lrc_SalesFreightCosts."Freight Unit Code" := '';
                        lrc_SalesFreightCosts."Freight Cost Tariff Base" := lrc_ShippingAgent."POI Freight Cost Tariff Base";
                        lrc_SalesFreightCosts.INSERT();
                    END;
                IF (lrc_SalesLine."Shipping Agent Code" <> '') AND (lrc_SalesLine."POI Departure Region Code" <> '') THEN
                    IF NOT lrc_SalesFreightCosts.GET(lrc_SalesLine."Document Type",
                                                     lrc_SalesLine."Document No.",
                                                     lrc_SalesFreightCosts.Type::"Sped.+AbgReg",
                                                     '',
                                                     '',
                                                     lrc_SalesLine."POI Departure Region Code",
                                                     lrc_SalesLine."Shipping Agent Code",
                                                     '') THEN BEGIN
                        lrc_SalesFreightCosts.RESET();
                        lrc_SalesFreightCosts.INIT();
                        lrc_SalesFreightCosts."Document Type" := lrc_SalesLine."Document Type";
                        lrc_SalesFreightCosts."Doc. No." := lrc_SalesLine."Document No.";
                        lrc_SalesFreightCosts.Type := lrc_SalesFreightCosts.Type::"Sped.+AbgReg";
                        lrc_SalesFreightCosts."Location Code" := '';
                        lrc_SalesFreightCosts."Location Group Code" := '';
                        lrc_SalesFreightCosts."Departure Region Code" := lrc_SalesLine."POI Departure Region Code";
                        lrc_SalesFreightCosts."Shipping Agent Code" := lrc_SalesLine."Shipping Agent Code";
                        lrc_SalesFreightCosts."Freight Unit Code" := '';
                        IF lrc_ShipAgentDepRegTarif.GET(lrc_ShippingAgent.Code, lrc_SalesLine."POI Departure Region Code") THEN
                            lrc_SalesFreightCosts."Freight Cost Tariff Base" := lrc_ShipAgentDepRegTarif."Freight Cost Tariff Base"
                        ELSE
                            lrc_SalesFreightCosts."Freight Cost Tariff Base" := lrc_ShippingAgent."POI Freight Cost Tariff Base";
                        lrc_SalesFreightCosts.INSERT();
                    END;


                IF (lrc_SalesLine."Shipping Agent Code" <> '') AND (lrc_SalesLine."POI Departure Region Code" <> '') THEN BEGIN
                    lrc_SalesFreightCosts.RESET();
                    lrc_SalesFreightCosts.INIT();
                    lrc_SalesFreightCosts."Document Type" := lrc_SalesLine."Document Type";
                    lrc_SalesFreightCosts."Doc. No." := lrc_SalesLine."Document No.";
                    lrc_SalesFreightCosts.Type := lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit";
                    lrc_SalesFreightCosts."Departure Region Code" := lrc_SalesLine."POI Departure Region Code";
                    lrc_SalesFreightCosts."Location Code" := '';
                    lrc_SalesFreightCosts."Location Group Code" := '';
                    lrc_SalesFreightCosts."Shipping Agent Code" := lrc_SalesLine."Shipping Agent Code";
                    IF lrc_ShipAgentDepRegTarif.GET(lrc_ShippingAgent.Code, lrc_SalesLine."POI Departure Region Code") THEN
                        lrc_SalesFreightCosts."Freight Cost Tariff Base" := lrc_ShipAgentDepRegTarif."Freight Cost Tariff Base"
                    ELSE
                        lrc_SalesFreightCosts."Freight Cost Tariff Base" := lrc_ShippingAgent."POI Freight Cost Tariff Base";

                    IF vrc_SalesHeader."POI Freight Calculation" = vrc_SalesHeader."POI Freight Calculation"::"Manual in Line" THEN BEGIN
                        lrc_SalesFreightCosts."Freight Cost Tariff Base" :=
                            lrc_SalesFreightCosts."Freight Cost Tariff Base"::"From Position";
                        lrc_SalesFreightCosts."Departure Region Code" := '';
                        lrc_SalesLine."POI Departure Region Code" := '';
                    END;

                    IF (lrc_SalesFreightCosts."Freight Cost Tariff Base" = lrc_SalesFreightCosts."Freight Cost Tariff Base"::"Pallet Type") OR
                       (lrc_SalesFreightCosts."Freight Cost Tariff Base" = lrc_SalesFreightCosts."Freight Cost Tariff Base"::"Pallet Type Weight") THEN
                        lrc_SalesFreightCosts."Freight Unit Code" := lrc_SalesLine."POI Freight Unit of Meas (FU)"
                    ELSE
                        lrc_SalesFreightCosts."Freight Unit Code" := '';
                    IF NOT lrc_SalesFreightCosts.GET(lrc_SalesLine."Document Type",
                                                     lrc_SalesLine."Document No.",
                                                     lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit",
                                                     '',
                                                     '',
                                                     lrc_SalesLine."POI Departure Region Code",
                                                     lrc_SalesLine."Shipping Agent Code",
                                                     lrc_SalesFreightCosts."Freight Unit Code") THEN
                        lrc_SalesFreightCosts.INSERT();
                END;
                IF (lrc_SalesLine."Location Code" <> '') AND (lrc_SalesLine."Shipping Agent Code" <> '') THEN
                    IF NOT lrc_SalesFreightCosts.GET(lrc_SalesLine."Document Type",
                                                     lrc_SalesLine."Document No.",
                                                     lrc_SalesFreightCosts.Type::"Lager+Spediteur",
                                                     lrc_SalesLine."Location Code",
                                                     '',
                                                     '',
                                                     lrc_SalesLine."Shipping Agent Code",
                                                     '') THEN BEGIN
                        lrc_SalesFreightCosts.RESET();
                        lrc_SalesFreightCosts.INIT();
                        lrc_SalesFreightCosts."Document Type" := lrc_SalesLine."Document Type";
                        lrc_SalesFreightCosts."Doc. No." := lrc_SalesLine."Document No.";
                        lrc_SalesFreightCosts.Type := lrc_SalesFreightCosts.Type::"Lager+Spediteur";
                        lrc_SalesFreightCosts."Departure Region Code" := '';
                        lrc_SalesFreightCosts."Location Code" := lrc_SalesLine."Location Code";
                        lrc_SalesFreightCosts."Location Group Code" := '';
                        lrc_SalesFreightCosts."Shipping Agent Code" := lrc_SalesLine."Shipping Agent Code";
                        lrc_SalesFreightCosts."Freight Unit Code" := '';
                        lrc_SalesFreightCosts."Freight Cost Tariff Base" := lrc_ShippingAgent."POI Freight Cost Tariff Base";
                        lrc_SalesFreightCosts.INSERT();
                    END;

                IF (lrc_SalesLine."Location Code" <> '') THEN
                    IF NOT lrc_SalesFreightCosts.GET(lrc_SalesLine."Document Type",
                                                     lrc_SalesLine."Document No.",
                                                     lrc_SalesFreightCosts.Type::Lager,
                                                     lrc_SalesLine."Location Code",
                                                     '',
                                                     '',
                                                     '',
                                                     '') THEN BEGIN
                        lrc_SalesFreightCosts.RESET();
                        lrc_SalesFreightCosts.INIT();
                        lrc_SalesFreightCosts."Document Type" := lrc_SalesLine."Document Type";
                        lrc_SalesFreightCosts."Doc. No." := lrc_SalesLine."Document No.";
                        lrc_SalesFreightCosts.Type := lrc_SalesFreightCosts.Type::Lager;
                        lrc_SalesFreightCosts."Departure Region Code" := '';
                        lrc_SalesFreightCosts."Location Code" := lrc_SalesLine."Location Code";
                        lrc_SalesFreightCosts."Location Group Code" := '';
                        lrc_SalesFreightCosts."Shipping Agent Code" := '';
                        lrc_SalesFreightCosts."Freight Unit Code" := '';
                        lrc_SalesFreightCosts.INSERT();
                    END;
            UNTIL lrc_SalesLine.NEXT() = 0;
    end;

    procedure SalesFreightCostsPerOrder(vrc_SalesHeader: Record "Sales Header"): Boolean
    var
        lrc_ShippingAgent: Record "Shipping Agent";
        lrc_ShipmentMethod: Record "Shipment Method";
        lrc_UnitofMeasure: Record "Unit of Measure";
        //lcu_Sales: Codeunit "POI Sales Mgt";
        "ldc_QtyofFreightUnits(SDF)": Decimal;
        ldc_TUQuantity: Decimal;
        WeightValue: Decimal;
        lbn_FrachtenAufNull: Boolean;
    begin
        // ---------------------------------------------------------------------------------------------------------
        // Funktion zum Berechnen der Frachtkosten pro Kollo / Palette / Gewicht / Pauschal / Kollogewicht
        // ---------------------------------------------------------------------------------------------------------

        lbn_FrachtenAufNull := FALSE;

        // Kontrolle ob alle Kombinationen in Seitentabelle angelegt sind
        SalesSetLocShipAgent(vrc_SalesHeader);

        // Kontrolle ob der Verkaufspreis aufgrund der Lieferbedingung Fracht enthält
        IF vrc_SalesHeader."POI Freight Calculation" = vrc_SalesHeader."POI Freight Calculation"::Standard THEN
            IF (vrc_SalesHeader."POI Arrival Region Code" = '') OR
               (vrc_SalesHeader."Shipping Agent Code" = '') OR
               (vrc_SalesHeader."Shipment Method Code" = '') THEN
                lbn_FrachtenAufNull := TRUE
            ELSE BEGIN
                lrc_ShipmentMethod.GET(vrc_SalesHeader."Shipment Method Code");
                IF lrc_ShipmentMethod."POI Incl. Freig to Final Loc." = FALSE THEN
                    lbn_FrachtenAufNull := TRUE;
            END;

        // Keine Frachtkosten im Verkaufspreis
        IF lbn_FrachtenAufNull = TRUE THEN BEGIN
            // Spediteure lesen
            lrc_SalesFreightCosts.RESET();
            lrc_SalesFreightCosts.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
            lrc_SalesFreightCosts.SETRANGE("Doc. No.", vrc_SalesHeader."No.");
            lrc_SalesFreightCosts.SETRANGE(Type, lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
            IF lrc_SalesFreightCosts.FIND('-') THEN
                REPEAT
                    IF vrc_SalesHeader."POI Arrival Region Code" = '' THEN BEGIN
                        IF lrc_SalesFreightCosts."Freight Cost Manual Entered" = FALSE THEN BEGIN
                            lrc_SalesFreightCosts.VALIDATE("Freight Costs Amount (LCY)", 0);
                            lrc_SalesFreightCosts.MODIFY();
                        END ELSE BEGIN
                            lrc_SalesFreightCosts.VALIDATE("Freight Costs Amount (LCY)");
                            lrc_SalesFreightCosts.MODIFY();
                        END;
                    END ELSE BEGIN
                        lrc_SalesFreightCosts.VALIDATE("Freight Costs Amount (LCY)", 0);
                        lrc_SalesFreightCosts.MODIFY();
                    END;
                UNTIL lrc_SalesFreightCosts.NEXT() = 0
            ELSE BEGIN
                IF vrc_SalesHeader."Shipping Agent Code" = '' THEN BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                    lrc_SalesLine.SETRANGE("POI Subtyp", lrc_SalesLine."POI Subtyp"::" ");
                    IF lrc_SalesLine.FIND('-') THEN
                        REPEAT
                            lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                            lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)", 0);
                            lrc_SalesLine.MODIFY(TRUE);
                        UNTIL lrc_SalesLine.NEXT() = 0;
                END;
                EXIT(FALSE);
            END;


            // ---------------------------------------------------------------------------------------
            // Spediteure lesen
            // ---------------------------------------------------------------------------------------
            lrc_SalesFreightCosts.RESET();
            lrc_SalesFreightCosts.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
            lrc_SalesFreightCosts.SETRANGE("Doc. No.", vrc_SalesHeader."No.");
            lrc_SalesFreightCosts.SETRANGE(Type, lrc_SalesFreightCosts.Type::Spediteur);
            IF lrc_SalesFreightCosts.FIND('-') THEN
                REPEAT
                    lrc_ShippingAgent.GET(lrc_SalesFreightCosts."Shipping Agent Code");
                    lrc_SalesFreightCosts2.RESET();
                    lrc_SalesFreightCosts2.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesFreightCosts2.SETRANGE("Doc. No.", vrc_SalesHeader."No.");
                    lrc_SalesFreightCosts2.SETRANGE(Type, lrc_SalesFreightCosts2.Type::"Sped.+AbgReg.+Frachteinheit");
                    lrc_SalesFreightCosts2.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts."Shipping Agent Code");
                    IF lrc_SalesFreightCosts2.FIND('-') THEN
                        REPEAT
                            // Manuelle Frachtkosten validieren damit auch neue Zeilen berücksichtigt werden!
                            IF lrc_SalesFreightCosts2."Freight Cost Manual Entered" = TRUE THEN BEGIN
                                lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                lrc_SalesFreightCosts2.MODIFY();
                                COMMIT();
                            END ELSE BEGIN
                                //Frachtkosten zunächst zurücksetzen
                                lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)", 0);
                                lrc_SalesFreightCosts2.MODIFY();
                                // -------------------------------------------------------------------------------
                                // Frachtkosten Kalkulation über Frachttariffe
                                // -------------------------------------------------------------------------------
                                IF vrc_SalesHeader."POI Freight Calculation" = vrc_SalesHeader."POI Freight Calculation"::Standard THEN
                                    // Frachtkosten auf Basis Gewicht
                                    CASE lrc_SalesFreightCosts2."Freight Cost Tariff Base" OF
                                        lrc_SalesFreightCosts2."Freight Cost Tariff Base"::Weight:
                                            BEGIN
                                                lrc_SalesFreightCosts2.CALCFIELDS("Gross Weight (SD)", "Net Weight (SD)");
                                                CASE lrc_ShippingAgent."POI Freight Cost Ref. Weight" OF
                                                    lrc_ShippingAgent."POI Freight Cost Ref. Weight"::"Net Weight":
                                                        WeightValue := lrc_SalesFreightCosts2."Net Weight (SD)";
                                                    lrc_ShippingAgent."POI Freight Cost Ref. Weight"::"Gross Weight":
                                                        WeightValue := lrc_SalesFreightCosts2."Gross Weight (SD)";
                                                    ELSE
                                                        lrc_ShippingAgent.TESTFIELD("POI Freight Cost Ref. Weight");
                                                END;
                                                lrc_ShipAgentFreightcost.RESET();
                                                lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code", lrc_SalesFreightCosts2."Departure Region Code");
                                                lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1', WeightValue);
                                                lrc_ShipAgentFreightcost.SETFILTER("Until Quantity", '>=%1', WeightValue);
                                                IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                    IF lrc_ShipAgentFreightcost.Pauschal THEN
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" := lrc_ShipAgentFreightcost."Freight Rate per Unit"
                                                    ELSE
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" := lrc_ShipAgentFreightcost."Freight Rate per Unit" * WeightValue;
                                                    lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                END ELSE
                                                    ERROR(lrc_ShipAgentFreightcost.GETFILTERS());
                                                lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
                                                lrc_SalesFreightCosts2.MODIFY();
                                            END;


                                        // -------------------------------------------------------------------------------------------------
                                        // Frachtkosten auf Basis Anzahl je Palettentypen
                                        // -------------------------------------------------------------------------------------------------
                                        lrc_SalesFreightCosts2."Freight Cost Tariff Base"::"Pallet Type":
                                            BEGIN
                                                lrc_SalesFreightCosts2.CALCFIELDS("Qty. of Freight Units (SDF)");
                                                "ldc_QtyofFreightUnits(SDF)" := PalletTolerance(lrc_SalesFreightCosts2."Qty. of Freight Units (SDF)",
                                                                                                lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.RESET();
                                                lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code", lrc_SalesFreightCosts2."Departure Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code", lrc_SalesFreightCosts2."Freight Unit Code");
                                                lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1',
                                                                                   ROUND("ldc_QtyofFreightUnits(SDF)", 1, '>'));
                                                lrc_ShipAgentFreightcost.SETFILTER("Until Quantity", '>=%1',
                                                                                   ROUND("ldc_QtyofFreightUnits(SDF)", 1, '>'));
                                                IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                    IF lrc_ShipAgentFreightcost.Pauschal THEN
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                      lrc_ShipAgentFreightcost."Freight Rate per Unit"
                                                    ELSE
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                        lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                        ROUND("ldc_QtyofFreightUnits(SDF)", 1, '>');
                                                    lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                END ELSE
                                                    IF lrc_UnitofMeasure.GET(lrc_SalesFreightCosts2."Freight Unit Code") THEN
                                                        IF lrc_UnitofMeasure."POI Ref. Freight Unit" <> '' THEN BEGIN
                                                            lrc_UnitofMeasure.TESTFIELD("POI Ref. Freight Unit Qty");
                                                            lrc_ShipAgentFreightcost.RESET();
                                                            lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                            lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                            lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code", lrc_SalesFreightCosts2."Departure Region Code");
                                                            lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code", lrc_UnitofMeasure."POI Ref. Freight Unit");
                                                            lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1',
                                                                                               ROUND(("ldc_QtyofFreightUnits(SDF)" /
                                                                                                      lrc_UnitofMeasure."POI Ref. Freight Unit Qty"), 1, '>'));
                                                            lrc_ShipAgentFreightcost.SETFILTER("Until Quantity", '>=%1',
                                                                                                ROUND(("ldc_QtyofFreightUnits(SDF)" /
                                                                                                      lrc_UnitofMeasure."POI Ref. Freight Unit Qty"), 1, '>'));
                                                            IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                                IF lrc_ShipAgentFreightcost.Pauschal THEN
                                                                    lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit"
                                                                ELSE
                                                                    lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                                    lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                                    ROUND("ldc_QtyofFreightUnits(SDF)" /
                                                                                                          lrc_UnitofMeasure."POI Ref. Freight Unit Qty", 1, '>');
                                                                lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                            END;
                                                        END;
                                                lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
                                                lrc_SalesFreightCosts2.MODIFY();
                                            END;
                                        // -------------------------------------------------------------------------------------------------
                                        // Frachtkosten auf Basis Anzahl je Palettentypen und Gewicht
                                        // -------------------------------------------------------------------------------------------------
                                        lrc_SalesFreightCosts2."Freight Cost Tariff Base"::"Pallet Type Weight":
                                            BEGIN
                                                lrc_SalesFreightCosts2.CALCFIELDS("Qty. of Freight Units (SDF)", "Gross Weight (SD)", "Net Weight (SD)");
                                                "ldc_QtyofFreightUnits(SDF)" := PalletTolerance(lrc_SalesFreightCosts2."Qty. of Freight Units (SDF)",
                                                                                                lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.RESET();
                                                lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code", lrc_SalesFreightCosts2."Departure Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code", lrc_SalesFreightCosts2."Freight Unit Code");
                                                lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1',
                                                                                   ROUND("ldc_QtyofFreightUnits(SDF)", 1, '>'));
                                                lrc_ShipAgentFreightcost.SETFILTER("Until Quantity", '>=%1', ROUND("ldc_QtyofFreightUnits(SDF)", 1, '>'));
                                                IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                    IF lrc_ShipAgentFreightcost.Pauschal THEN
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" := lrc_ShipAgentFreightcost."Freight Rate per Unit"
                                                    ELSE
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" := lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                        ROUND(lrc_SalesFreightCosts2."Net Weight (SD)", 1, '>');
                                                    lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                END ELSE

                                                    IF lrc_UnitofMeasure.GET(lrc_SalesFreightCosts2."Freight Unit Code") THEN
                                                        IF lrc_UnitofMeasure."POI Ref. Freight Unit" <> '' THEN BEGIN
                                                            lrc_UnitofMeasure.TESTFIELD("POI Ref. Freight Unit Qty");
                                                            lrc_ShipAgentFreightcost.RESET();
                                                            lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                            lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                            lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code", lrc_SalesFreightCosts2."Departure Region Code");
                                                            lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code", lrc_UnitofMeasure."POI Ref. Freight Unit");
                                                            lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1',
                                                                                               ROUND(("ldc_QtyofFreightUnits(SDF)" /
                                                                                                      lrc_UnitofMeasure."POI Ref. Freight Unit Qty"), 1, '>'));
                                                            lrc_ShipAgentFreightcost.SETFILTER("Until Quantity", '>=%1',
                                                                                                ROUND(("ldc_QtyofFreightUnits(SDF)" /
                                                                                                      lrc_UnitofMeasure."POI Ref. Freight Unit Qty"), 1, '>'));
                                                            IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                                IF lrc_ShipAgentFreightcost.Pauschal THEN
                                                                    lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit"
                                                                ELSE
                                                                    lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                                    lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                                    ROUND(lrc_SalesFreightCosts2."Net Weight (SD)", 1, '>');
                                                                lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                            END;
                                                        END;
                                                lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
                                                lrc_SalesFreightCosts2.MODIFY();
                                            END;
                                        // -------------------------------------------------------------------------------------------------
                                        // Frachtkosten auf Basis Anzahl Paletten
                                        // -------------------------------------------------------------------------------------------------
                                        lrc_SalesFreightCosts2."Freight Cost Tariff Base"::Pallet:
                                            BEGIN

                                                lrc_SalesFreightCosts2.CALCFIELDS("Qty. of Pallets (SD)");
                                                ldc_TUQuantity := lrc_SalesFreightCosts2."Qty. of Pallets (SD)";
                                                ldc_TUQuantity := PalletTolerance(ldc_TUQuantity, lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.RESET();
                                                lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",
                                                                                            lrc_SalesFreightCosts2."Departure Region Code");
                                                lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1',
                                                                                     ROUND(ldc_TUQuantity, 1, '>'));
                                                lrc_ShipAgentFreightcost.SETFILTER("Until Quantity", '>=%1',
                                                                                     ROUND(ldc_TUQuantity, 1, '>'));
                                                IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                    IF lrc_ShipAgentFreightcost.Pauschal THEN
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                         lrc_ShipAgentFreightcost."Freight Rate per Unit"
                                                    ELSE
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                         lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                         ROUND(ldc_TUQuantity, 1, '>');
                                                    lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                END;
                                                lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)",
                                                                                lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" +
                                                                                lrc_ShipAgentFreightcost."addition fix per order");
                                                lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
                                                lrc_SalesFreightCosts2.MODIFY();

                                            END;
                                        // -------------------------------------------------------------------------------------------------
                                        // Frachtkosten auf Basis Anzahl Paletten und Gewicht
                                        // -------------------------------------------------------------------------------------------------
                                        lrc_SalesFreightCosts2."Freight Cost Tariff Base"::"Pallet Weight":
                                            BEGIN
                                                lrc_SalesFreightCosts2.CALCFIELDS("Qty. of Pallets (SD)", "Gross Weight (SD)", "Gross Weight (SDF)",
                                                                                  "Net Weight (SD)", "Net Weight (SDF)");
                                                ldc_TUQuantity := lrc_SalesFreightCosts2."Qty. of Pallets (SD)";
                                                ldc_TUQuantity := PalletTolerance(ldc_TUQuantity, lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.RESET();
                                                lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",
                                                                                  lrc_SalesFreightCosts2."Departure Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code", '');
                                                lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1',
                                                                                   ROUND(ldc_TUQuantity, 1, '>'));
                                                lrc_ShipAgentFreightcost.SETFILTER("Until Quantity", '>=%1',
                                                                                   ROUND(ldc_TUQuantity, 1, '>'));
                                                IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                    IF lrc_ShipAgentFreightcost.Pauschal THEn
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                         lrc_ShipAgentFreightcost."Freight Rate per Unit"
                                                    ELSE
                                                        CASE lrc_ShippingAgent."POI Freight Cost Ref. Weight" OF
                                                            lrc_ShippingAgent."POI Freight Cost Ref. Weight"::"Net Weight":
                                                                lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                                 lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                                 ROUND(lrc_SalesFreightCosts2."Net Weight (SD)", 1, '>');
                                                            lrc_ShippingAgent."POI Freight Cost Ref. Weight"::"Gross Weight":
                                                                lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                                 lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                                 ROUND(lrc_SalesFreightCosts2."Gross Weight (SD)", 1, '>');
                                                            ELSE
                                                                lrc_ShippingAgent.TESTFIELD("POI Freight Cost Ref. Weight");
                                                        END;
                                                    lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                END;
                                                lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
                                                lrc_SalesFreightCosts2.MODIFY();

                                            END;
                                        // -------------------------------------------------------------------------------------------------
                                        // Frachtkosten auf Basis Kollogewicht
                                        // -------------------------------------------------------------------------------------------------
                                        lrc_SalesFreightCosts2."Freight Cost Tariff Base"::"Collo Weight":
                                            BEGIN
                                                lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" := 0;
                                                lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
                                                lrc_SalesFreightCosts2.MODIFY();
                                                lrc_SalesLine.RESET();
                                                lrc_SalesLine.SETRANGE("Document Type", lrc_SalesFreightCosts2."Document Type");
                                                lrc_SalesLine.SETRANGE("Document No.", lrc_SalesFreightCosts2."Doc. No.");
                                                lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                                                lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                                                lrc_SalesLine.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_SalesLine.SETFILTER("POI Departure Region Code", '%1', '');
                                                IF lrc_SalesLine.FIND('-') THEN
                                                    REPEAT
                                                        lrc_SalesLine."POI Reference Freight Costs" := lrc_SalesLine."POI Reference Freight Costs"::Collo;
                                                        lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                                                        lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)", 0);
                                                        lrc_SalesLine.MODIFY();
                                                    UNTIL lrc_SalesLine.NEXT() = 0;
                                                lrc_SalesLine.SETRANGE("POI Departure Region Code", lrc_SalesFreightCosts2."Departure Region Code");
                                                IF lrc_SalesLine.FIND('-') THEN BEGIN
                                                    REPEAT
                                                        lrc_SalesLine."POI Reference Freight Costs" := lrc_SalesFreightCosts2."Freight Cost Tariff Base";
                                                        lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                                                        lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)", 0);
                                                        lrc_SalesLine.MODIFY();
                                                    UNTIL lrc_SalesLine.NEXT() = 0;
                                                    IF lrc_SalesLine.FIND('-') THEN
                                                        REPEAT
                                                            IF (lrc_SalesLine."Gross Weight" > 0) AND (lrc_SalesLine.Quantity > 0) THEN BEGIN
                                                                lrc_ShipAgentFreightcost.RESET();
                                                                lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",
                                                                                                  lrc_SalesFreightCosts2."Shipping Agent Code");
                                                                lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                                lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",
                                                                                                  lrc_SalesFreightCosts2."Departure Region Code");
                                                                lrc_ShipAgentFreightcost.SETFILTER("From Quantity",
                                                                                                   '<=%1', lrc_SalesLine."Gross Weight");
                                                                lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",
                                                                                                   '>=%1', lrc_SalesLine."Gross Weight");
                                                                IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit",
                                                                                           lrc_ShipAgentFreightcost."Freight Rate per Unit");
                                                                    IF lrc_ShipAgentFreightcost.Pauschal THEN BEGIN
                                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                               lrc_ShipAgentFreightcost."Freight Rate per Unit";
                                                                        lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)", lrc_ShipAgentFreightcost."Freight Rate per Unit");
                                                                    END ELSE BEGIN
                                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                                       lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" +
                                                                                                       (lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                                       lrc_SalesLine.Quantity);
                                                                        lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                                        lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)",
                                                                                               (lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                                lrc_SalesLine.Quantity));
                                                                    END;
                                                                    lrc_SalesLine.MODIFY();
                                                                END ELSE BEGIN
                                                                    lrc_SalesLine."POI Reference Freight Costs" := lrc_SalesLine."POI Reference Freight Costs"::Collo;
                                                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                                                                    lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)", 0);
                                                                    lrc_SalesLine.MODIFY();
                                                                    MESSAGE('Zeile ' + FORMAT(lrc_SalesLine."Line No.") +
                                                                            ', Kollogewicht-Frachtkosten nicht gefunden : ' +
                                                                            lrc_ShipAgentFreightcost.GETFILTERS());
                                                                END;
                                                                lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
                                                                lrc_SalesFreightCosts2.MODIFY();
                                                            END;
                                                        UNTIL lrc_SalesLine.NEXT() = 0;
                                                END;
                                            END;
                                        // -------------------------------------------------------------------------------------------------
                                        // Frachkosten auf Basis Anzahl Kolli
                                        // -------------------------------------------------------------------------------------------------
                                        lrc_SalesFreightCosts2."Freight Cost Tariff Base"::Collo:
                                            BEGIN
                                                lrc_SalesFreightCosts2.CALCFIELDS("Qty. of Colli (SD)");
                                                ldc_TUQuantity := lrc_SalesFreightCosts2."Qty. of Colli (SD)";
                                                ldc_TUQuantity := ROUND(ldc_TUQuantity, 0.001);
                                                lrc_ShipAgentFreightcost.RESET();
                                                lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code", vrc_SalesHeader."POI Arrival Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",
                                                                                  lrc_SalesFreightCosts2."Departure Region Code");
                                                lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code", '');
                                                lrc_ShipAgentFreightcost.SETFILTER("From Quantity", '<=%1',
                                                                                   ROUND(ldc_TUQuantity, 1, '>'));
                                                lrc_ShipAgentFreightcost.SETFILTER("Until Quantity", '>=%1',
                                                                                   ROUND(ldc_TUQuantity, 1, '>'));
                                                IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
                                                    IF lrc_ShipAgentFreightcost.Pauschal THEN
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                         lrc_ShipAgentFreightcost."Freight Rate per Unit"
                                                    ELSE
                                                        lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" :=
                                                                                         lrc_ShipAgentFreightcost."Freight Rate per Unit" *
                                                                                         ROUND(ldc_TUQuantity, 1, '>');
                                                    lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                                END;
                                                lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
                                                lrc_SalesFreightCosts2.MODIFY();
                                            END;
                                    END
                                // -------------------------------------------------------------------------------
                                // Frachtkosten manuell pro Verkaufszeile erfasst
                                // -------------------------------------------------------------------------------
                                ELSE BEGIN
                                    lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" := 0;
                                    lrc_SalesFreightCosts2.VALIDATE("Freight Costs Amount (LCY)");
                                    lrc_SalesFreightCosts2."Cargo Rate" := FALSE;
                                    lrc_SalesFreightCosts2.MODIFY();
                                    lrc_SalesLine.RESET();
                                    lrc_SalesLine.SETRANGE("Document Type", lrc_SalesFreightCosts2."Document Type");
                                    lrc_SalesLine.SETRANGE("Document No.", lrc_SalesFreightCosts2."Doc. No.");
                                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
                                    lrc_SalesLine.SETRANGE("Shipping Agent Code", lrc_SalesFreightCosts2."Shipping Agent Code");
                                    lrc_SalesLine.SETRANGE("POI Subtyp", lrc_SalesLine."POI Subtyp"::" ");
                                    IF lrc_SalesLine.FIND('-') THEN
                                        REPEAT
                                            IF (lrc_SalesLine."POI Freight Costs Amount (LCY)" <> 0) THEN BEGIN
                                                lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" := lrc_SalesFreightCosts2."Freight Costs Amount (LCY)" +
                                                                                                       lrc_SalesLine."POI Freight Costs Amount (LCY)";
                                                lrc_SalesFreightCosts2.MODIFY();
                                            END;
                                        UNTIL lrc_SalesLine.NEXT() = 0;
                                END;
                            END;
                        UNTIL lrc_SalesFreightCosts2.NEXT() = 0;
                UNTIL lrc_SalesFreightCosts.NEXT() = 0
            ELSE
                EXIT(FALSE);
            EXIT(TRUE);
        end;
    end;

    procedure SalesFreightAllocPerLine(vrc_SalesFreightCosts: Record "POI Sales Freight Costs")
    var
        lrc_SalesHeader: Record "Sales Header";
        "ldc_QtyofFreightUnits(SDF)": Decimal;
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Verteilung der Frachtkosten auf die Verkaufszeilen
        // --------------------------------------------------------------------------------------
        // Verkaufskopfsatz lesen
        lrc_SalesHeader.GET(vrc_SalesFreightCosts."Document Type", vrc_SalesFreightCosts."Doc. No.");
        IF lrc_SalesHeader."POI Freight Calculation" <> lrc_SalesHeader."POI Freight Calculation"::Standard THEN
            EXIT;
        IF (vrc_SalesFreightCosts.Type = vrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit") THEN BEGIN
            lrc_SalesLine.SETRANGE("Document Type", vrc_SalesFreightCosts."Document Type");
            lrc_SalesLine.SETRANGE("Document No.", vrc_SalesFreightCosts."Doc. No.");
            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
            lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Trade Item");
            lrc_SalesLine.SETRANGE("Shipping Agent Code", vrc_SalesFreightCosts."Shipping Agent Code");
            lrc_SalesLine.SETRANGE("POI Departure Region Code", vrc_SalesFreightCosts."Departure Region Code");
            IF vrc_SalesFreightCosts."Freight Unit Code" <> '' THEN
                lrc_SalesLine.SETRANGE("POI Freight Unit of Meas (FU)", vrc_SalesFreightCosts."Freight Unit Code");
            lrc_SalesLine.SETRANGE("POI Subtyp", lrc_SalesLine."POI Subtyp"::" ");
            IF lrc_SalesLine.FIND('-') THEN
                REPEAT
                    CASE vrc_SalesFreightCosts."Freight Cost Tariff Base" OF
                        vrc_SalesFreightCosts."Freight Cost Tariff Base"::"Pallet Type",
                        vrc_SalesFreightCosts."Freight Cost Tariff Base"::"Pallet Type Weight":
                            BEGIN
                                vrc_SalesFreightCosts.CALCFIELDS("Qty. of Freight Units (SDF)");
                                "ldc_QtyofFreightUnits(SDF)" := ROUND(vrc_SalesFreightCosts."Qty. of Freight Units (SDF)", 0.00001);
                                lrc_SalesLine."POI Reference Freight Costs" := lrc_SalesLine."POI Reference Freight Costs"::Pallet;
                                IF vrc_SalesFreightCosts."Qty. of Freight Units (SDF)" <> 0 THEN
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", ROUND((vrc_SalesFreightCosts."Freight Costs Amount (LCY)" / "ldc_QtyofFreightUnits(SDF)"), 0.00001))
                                ELSE
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                                lrc_SalesLine."POI Freight Costs Amount (LCY)" := ROUND(lrc_SalesLine."POI Freight Cost per Ref. Unit" * lrc_SalesLine."POI Quantity (TU)", 0.00001);
                                lrc_SalesLine.MODIFY();
                            END;
                        vrc_SalesFreightCosts."Freight Cost Tariff Base"::Pallet,
                        vrc_SalesFreightCosts."Freight Cost Tariff Base"::"Pallet Weight":
                            BEGIN
                                vrc_SalesFreightCosts.CALCFIELDS("Qty. of Pallets (SD)");
                                lrc_SalesLine."POI Reference Freight Costs" := vrc_SalesFreightCosts."Freight Cost Tariff Base";
                                IF vrc_SalesFreightCosts."Qty. of Pallets (SD)" <> 0 THEN
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", ROUND((vrc_SalesFreightCosts."Freight Costs Amount (LCY)" /
                                                                                          vrc_SalesFreightCosts."Qty. of Pallets (SD)"), 0.00001))
                                ELSE
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                                lrc_SalesLine."POI Freight Costs Amount (LCY)" := lrc_SalesLine."POI Freight Cost per Ref. Unit" * lrc_SalesLine."POI Quantity (TU)";
                                lrc_SalesLine.MODIFY();
                            END;
                        vrc_SalesFreightCosts."Freight Cost Tariff Base"::"Collo Weight":
                            BEGIN
                                // Nichts zurückschreiben bei Kollogewicht
                                IF lrc_SalesLine."POI Reference Freight Costs" <> lrc_SalesLine."POI Reference Freight Costs" THEN BEGIN
                                    lrc_SalesLine."POI Reference Freight Costs" := vrc_SalesFreightCosts."Freight Cost Tariff Base";
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                                END;
                                lrc_SalesLine.MODIFY();
                            END;
                        vrc_SalesFreightCosts."Freight Cost Tariff Base"::Collo:
                            BEGIN
                                vrc_SalesFreightCosts.CALCFIELDS("Qty. of Colli (SD)");
                                lrc_SalesLine."POI Reference Freight Costs" := vrc_SalesFreightCosts."Freight Cost Tariff Base";
                                IF vrc_SalesFreightCosts."Qty. of Colli (SD)" <> 0 THEN
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", (vrc_SalesFreightCosts."Freight Costs Amount (LCY)" / vrc_SalesFreightCosts."Qty. of Colli (SD)"))
                                ELSE
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                                lrc_SalesLine."POI Freight Costs Amount (LCY)" := lrc_SalesLine."POI Freight Cost per Ref. Unit" * lrc_SalesLine.Quantity;
                                lrc_SalesLine.MODIFY();
                            END;
                        vrc_SalesFreightCosts."Freight Cost Tariff Base"::Weight:
                            BEGIN
                                vrc_SalesFreightCosts.CALCFIELDS("Gross Weight (SD)");
                                lrc_SalesLine."POI Reference Freight Costs" := vrc_SalesFreightCosts."Freight Cost Tariff Base";
                                IF vrc_SalesFreightCosts."Gross Weight (SD)" <> 0 THEN
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", ROUND((vrc_SalesFreightCosts."Freight Costs Amount (LCY)" /
                                                                                          vrc_SalesFreightCosts."Gross Weight (SD)"), 0.00001))
                                ELSE
                                    lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
                                lrc_SalesLine."POI Freight Costs Amount (LCY)" := lrc_SalesLine."POI Freight Cost per Ref. Unit" * lrc_SalesLine."POI Total Gross Weight";
                                lrc_SalesLine.MODIFY();
                            END;
                    END;
                UNTIL lrc_SalesLine.NEXT() = 0;
        END;
    end;

    //     procedure SalesShowFreightCosts(vop_DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";vco_DocumentNo: Code[20])
    //     var
    //         lrc_SalesFreightCosts: Record "5110549";
    //         lfm_SalesFreightCosts: Form "5110691";
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Frachtkosten
    //         // -----------------------------------------------------------------------------------------

    //         lrc_SalesFreightCosts.FILTERGROUP(2);
    //         lrc_SalesFreightCosts.SETRANGE("Document Type", vop_DocumentType);
    //         lrc_SalesFreightCosts.SETRANGE("Doc. No.", vco_DocumentNo);
    //         lrc_SalesFreightCosts.SETRANGE(Type, lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //         lrc_SalesFreightCosts.FILTERGROUP(0);

    //         lfm_SalesFreightCosts.SETTABLEVIEW(lrc_SalesFreightCosts);
    //         lfm_SalesFreightCosts.RUNMODAL;
    //     end;

    //     procedure SalesShowShippingAgent(vop_DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";vco_DocumentNo: Code[20])
    //     var
    //         lcu_FreightManagement: Codeunit "5110313";
    //         lrc_SalesFreightCosts: Record "5110549";
    //         lfm_SalesShippingAgent: Form "5110692";
    //         lrc_SalesHeader: Record "36";
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Zusteller - Lager in einem Auftrag
    //         // -----------------------------------------------------------------------------------------
    //         IF (vop_DocumentType <> vop_DocumentType::Order) AND
    //            (vop_DocumentType <> vop_DocumentType::Invoice) AND
    //            (vop_DocumentType <> vop_DocumentType::"Credit Memo") THEN
    //           EXIT;

    //         lrc_SalesHeader.GET(vop_DocumentType,vco_DocumentNo);

    //         SalesSetLocShipAgent(lrc_SalesHeader);
    //         COMMIT;

    //         lrc_SalesFreightCosts.FILTERGROUP(2);
    //         lrc_SalesFreightCosts.SETRANGE("Document Type",vop_DocumentType);
    //         lrc_SalesFreightCosts.SETRANGE("Doc. No.",vco_DocumentNo);
    //         lrc_SalesFreightCosts.SETRANGE(Type, lrc_SalesFreightCosts.Type::Spediteur);
    //         lrc_SalesFreightCosts.FILTERGROUP(0);
    //         lfm_SalesShippingAgent.SETTABLEVIEW(lrc_SalesFreightCosts);
    //         lfm_SalesShippingAgent.RUNMODAL;
    //     end;

    //     procedure SalesShowFreightPerShipAg(vrc_SalesFreightCosts: Record "5110549")
    //     var
    //         lrc_SalesFreightCosts: Record "5110549";
    //         lrc_ShippingAgent: Record "291";
    //         lfm_SalesShipingAgFreightcost: Form "5110693";
    //         AGILES_LT_001: Label 'Übergebene Satzart nicht zulässig!';
    //         AGILES_LT_002: Label 'Tariffebene Lagerortgruppe nicht zulässig!';
    //         AGILES_LT_003: Label 'Tariffebene Lagerorte nicht zulässig!';
    //         AGILES_LT_004: Label 'Identifizierung Tariffebene nicht möglich!';
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Frachten pro Spediteur
    //         // ---------------------------------------------------------------------------------

    //         IF vrc_SalesFreightCosts.Type <> vrc_SalesFreightCosts.Type::Spediteur THEN
    //           // Übergebene Satzart nicht zulässig!
    //           ERROR(AGILES_LT_001);

    //         lrc_ShippingAgent.GET(vrc_SalesFreightCosts."Shipping Agent Code");

    //         CASE lrc_ShippingAgent."Freight Cost Tariff Level" OF
    //         // Tariffebene Lagerortgruppe nicht zulässig!
    //         lrc_ShippingAgent."Freight Cost Tariff Level"::"Physical Locations": ERROR(AGILES_LT_002);
    //         // Tariffebene Lagerorte nicht zulässig!
    //         lrc_ShippingAgent."Freight Cost Tariff Level"::Locations: ERROR(AGILES_LT_003);
    //         lrc_ShippingAgent."Freight Cost Tariff Level"::"Departure Region":
    //           BEGIN
    //             lrc_SalesFreightCosts.FILTERGROUP(2);
    //             lrc_SalesFreightCosts.SETRANGE("Document Type",vrc_SalesFreightCosts."Document Type");
    //             lrc_SalesFreightCosts.SETRANGE("Doc. No.",vrc_SalesFreightCosts."Doc. No.");
    //             lrc_SalesFreightCosts.SETRANGE(Type, lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //             lrc_SalesFreightCosts.SETRANGE("Shipping Agent Code",vrc_SalesFreightCosts."Shipping Agent Code");
    //             lrc_SalesFreightCosts.FILTERGROUP(0);
    //             lfm_SalesShipingAgFreightcost.SETTABLEVIEW(lrc_SalesFreightCosts);
    //             lfm_SalesShipingAgFreightcost.RUNMODAL;
    //           END;
    //         ELSE
    //           // Identifizierung Tariffebene nicht möglich!
    //           ERROR(AGILES_LT_004);
    //         END;
    //     end;

    //     procedure SalesCalcQtyInFreightOrders(vco_OrderNo: Code[20];vco_OrderLineNo: Integer): Decimal
    //     var
    //         lrc_FreightOrderDetailLine: Record "5110440";
    //         ldc_QtyInFreightOrders: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Menge in Frachtaufträgen
    //         // ---------------------------------------------------------------------------------

    //         lrc_FreightOrderDetailLine.SETCURRENTKEY("Doc. Source","Doc. Source Type","Doc. Source No.","Doc. Source Line No.");
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source",lrc_FreightOrderDetailLine."Doc. Source"::Sales);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Type",lrc_FreightOrderDetailLine."Doc. Source Type"::Order);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source No.",vco_OrderNo);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Line No.",vco_OrderLineNo);
    //         IF lrc_FreightOrderDetailLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             ldc_QtyInFreightOrders := ldc_QtyInFreightOrders + lrc_FreightOrderDetailLine."Qty. to Ship";
    //           UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;
    //         END;

    //         EXIT(ldc_QtyInFreightOrders);
    //     end;

    //     procedure SalesFreightCheck(var rrc_SalesHeader: Record "36")
    //     var
    //         lrc_SalesLine: Record "37";
    //         lrc_SalesFreightCosts: Record "5110549";
    //         ldc_TotalAmountFreightCosts: Decimal;
    //         ldc_TotalAmountSalesLine: Decimal;
    //         ldc_MinAmount: Decimal;
    //         ldc_MaxAmount: Decimal;
    //         AgilesText001: Label '%1 %2: Wrong Freight Costs: Value 1 %3 and Value 2 %4. ';
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         //
    //         // ---------------------------------------------------------------------------------

    //         // FRA 003 00000000.s
    //         ldc_TotalAmountFreightCosts := 0;
    //         ldc_TotalAmountSalesLine := 0;
    //         ldc_MinAmount := 0;
    //         ldc_MaxAmount := 0;

    //         lrc_SalesFreightCosts.RESET();
    //         lrc_SalesFreightCosts.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //         lrc_SalesFreightCosts.SETRANGE("Doc. No.",rrc_SalesHeader."No.");
    //         lrc_SalesFreightCosts.SETRANGE(Type,lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //         IF lrc_SalesFreightCosts.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             ldc_TotalAmountFreightCosts := ldc_TotalAmountFreightCosts + lrc_SalesFreightCosts."POI Freight Costs Amount (LCY)";
    //           UNTIL lrc_SalesFreightCosts.NEXT() = 0;
    //         END;

    //         lrc_SalesLine.RESET();
    //         lrc_SalesLine.SETRANGE("Document Type",rrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",rrc_SalesHeader."No.");
    //         lrc_SalesLine.SETFILTER("POI Freight Costs Amount (LCY)",'<>%1',0);
    //         IF lrc_SalesLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             ldc_TotalAmountSalesLine := ldc_TotalAmountSalesLine + lrc_SalesLine."POI Freight Costs Amount (LCY)"
    //           UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;

    //         // Es darf nur eine 0,1 %ige Abweichung geben (auf Grund von Rundungsdifferenzen)
    //         ldc_MinAmount := ldc_TotalAmountSalesLine - ((ldc_TotalAmountSalesLine / 100) * 0.1);
    //         ldc_MaxAmount := ldc_TotalAmountSalesLine + ((ldc_TotalAmountSalesLine / 100) * 0.1);

    //         //xxIF (ldc_TotalAmountFreightCosts < ldc_MinAmount) OR (ldc_TotalAmountFreightCosts > ldc_MaxAmount) THEN BEGIN
    //         //  ERROR(AgilesText001,rrc_SalesHeader."Document Type",rrc_SalesHeader."No.",ldc_TotalAmountFreightCosts,ldc_TotalAmountSalesLine);
    //         //xxEND;
    //         // FRA 003 00000000.e
    //     end;

    //     procedure SalesFreightCostPerLine(vrc_SalesLine: Record "37"): Decimal
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         lrc_Location: Record "14";
    //         ldc_FreightRatePerFreightUnit: Decimal;
    //         ldc_FreightRateAmount: Decimal;
    //     begin
    //         // ------------------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Frachtkosten pro Zeile
    //         // ------------------------------------------------------------------------------------------------------

    //         ldc_FreightRateAmount := 0;

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') THEN
    //           EXIT(ldc_FreightRateAmount);

    //         IF NOT lrc_SalesHeader.GET(vrc_SalesLine."Document Type",vrc_SalesLine."Document No.") THEN
    //           EXIT(ldc_FreightRateAmount);
    //         IF vrc_SalesLine."Shipping Agent Code" = '' THEN BEGIN
    //           IF NOT lrc_ShippingAgent.GET(vrc_SalesLine."Shipping Agent Code") THEN
    //             EXIT(ldc_FreightRateAmount);
    //         END ELSE BEGIN
    //           IF NOT lrc_ShippingAgent.GET(lrc_SalesHeader."Shipping Agent Code") THEN
    //             EXIT(ldc_FreightRateAmount);
    //         END;


    //         IF NOT lrc_ShipmentMethod.GET(lrc_SalesHeader."Shipment Method Code") THEN
    //           EXIT(ldc_FreightRateAmount);
    //         IF lrc_ShipmentMethod."Incl. Freight to Final Loc." = FALSE THEN
    //           EXIT(ldc_FreightRateAmount);
    //         IF lrc_SalesHeader."POI Arrival Region Code" = '' THEN
    //           EXIT(ldc_FreightRateAmount);
    //         IF NOT lrc_Location.GET(vrc_SalesLine."Location Code") THEN
    //           EXIT(ldc_FreightRateAmount);

    //         lrc_ShipAgentFreightcost.RESET();
    //         IF vrc_SalesLine."Shipping Agent Code" = '' THEN
    //           lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",vrc_SalesLine."Shipping Agent Code")
    //         ELSE
    //           lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_SalesHeader."Shipping Agent Code");
    //         lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_SalesHeader."POI Arrival Region Code");
    //         lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_Location."Departure Region Code");

    //         lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base",lrc_ShippingAgent."Freight Cost Tariff Base");
    //         IF lrc_ShippingAgent."Freight Cost Tariff Base" = lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //           lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",vrc_SalesLine."Freight Unit of Measure (FU)");
    //         IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //           ldc_FreightRateAmount := lrc_ShipAgentFreightcost."Freight Rate per Unit" * vrc_SalesLine."Quantity (TU)";
    //         END;

    //         EXIT(ldc_FreightRateAmount);
    //     end;

    //     procedure "-- PURCHASE --"()
    //     begin
    //     end;

    //     procedure PurchSetLocShipAgent(vrc_PurchHeader: Record "38")
    //     var
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_PurchaseLine: Record "39";
    //         lrc_UnitofMeasure: Record "204";
    //         lrc_PurchFreightCosts: Record "5110744";
    //         lrc_TempPurchFreightCosts: Record "5110744" temporary;
    //         lrc_Vendor: Record "Vendor";
    //         lrc_OrderAddress: Record "224";
    //         lrc_Location: Record "14";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_ShipAgentDepRegTarif: Record "5110335";
    //         lrc_ShipAgentDepRegLoc: Record "5110404";
    //         lco_DepartureRegionCode: Code[20];
    //         lco_ArrivalRegionCode: Code[20];
    //         lco_ViaDepartureRegionCode: Code[20];
    //         lco_ViaArrivalRegionCode: Code[20];
    //     begin
    //         // ------------------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der Lager - Zusteller Kombinationen aus einem Einkaufsdokument
    //         // ------------------------------------------------------------------------------------------------------

    //         // Lieferbedingung lesen
    //         lrc_ShipmentMethod.GET(vrc_PurchHeader."Shipment Method Code");

    //         // Alles Löschen wenn Fracht im Preis inklusive ist
    //         IF lrc_ShipmentMethod."Incl. Freight to Final Loc." = TRUE THEN BEGIN
    //           lrc_PurchFreightCosts.RESET();
    //           lrc_PurchFreightCosts.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //           lrc_PurchFreightCosts.SETRANGE("Doc. No.",vrc_PurchHeader."No.");
    //           IF NOT lrc_PurchFreightCosts.isempty()THEN BEGIN
    //             // Frachtkosteneinträge löschen
    //             lrc_PurchFreightCosts.DELETEALL();

    //             // Frachtkosten in Einkaufszeilen auf Null setzen
    //             lrc_PurchaseLine.RESET();
    //             lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
    //             lrc_PurchaseLine.SETRANGE("Document No.",vrc_PurchHeader."No.");
    //             lrc_PurchaseLine.SETRANGE(Type,lrc_PurchaseLine.Type::Item);
    //             lrc_PurchaseLine.SETRANGE("POI Item Typ",lrc_PurchaseLine."POI Item Typ"::"Trade Item");
    //             lrc_PurchaseLine.SETRANGE(Subtyp,lrc_PurchaseLine.Subtyp::" ");
    //             lrc_PurchaseLine.SETFILTER("No.",'<>%1','');
    //             IF lrc_PurchaseLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //               lrc_PurchaseLine."POI Freight Cost per Ref. Unit" := 0;
    //               lrc_PurchaseLine."POI Freight Costs Amount (LCY)" := 0;
    //               lrc_PurchaseLine.MODIFY();
    //             END;

    //             // Frachtkostenkontrolle zurücksetzen
    //             // Planungseinträge auf Null setzen
    //           END;
    //           EXIT;
    //         END;

    //         // Kreditor lesen
    //         lrc_Vendor.GET(vrc_PurchHeader."Buy-from Vendor No.");

    //         // Manuell eingegebene Frachtkosten in Temp Satz kopieren
    //         lrc_PurchFreightCosts.RESET();
    //         lrc_PurchFreightCosts.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //         lrc_PurchFreightCosts.SETRANGE("Doc. No.",vrc_PurchHeader."No.");
    //         lrc_PurchFreightCosts.SETRANGE(Type,lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //         lrc_PurchFreightCosts.SETRANGE("Freight Cost Manual Entered",TRUE);
    //         IF lrc_PurchFreightCosts.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             lrc_TempPurchFreightCosts := lrc_PurchFreightCosts;
    //             lrc_TempPurchFreightCosts.insert();
    //           UNTIL lrc_PurchFreightCosts.NEXT() = 0;
    //         END;

    //         // Frachtkosteneinträge löschen
    //         lrc_PurchFreightCosts.RESET();
    //         lrc_PurchFreightCosts.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //         lrc_PurchFreightCosts.SETRANGE("Doc. No.",vrc_PurchHeader."No.");
    //         IF NOT lrc_PurchFreightCosts.isempty()THEN
    //           lrc_PurchFreightCosts.DELETEALL();

    //         lrc_PurchaseLine.RESET();
    //         lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
    //         lrc_PurchaseLine.SETRANGE("Document No.",vrc_PurchHeader."No.");
    //         lrc_PurchaseLine.SETRANGE(Type,lrc_PurchaseLine.Type::Item);
    //         lrc_PurchaseLine.SETRANGE("POI Item Typ",lrc_PurchaseLine."POI Item Typ"::"Trade Item");
    //         lrc_PurchaseLine.SETRANGE(Subtyp,lrc_PurchaseLine.Subtyp::" ");
    //         lrc_PurchaseLine.SETFILTER("No.",'<>%1','');
    //         IF lrc_PurchaseLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //           REPEAT
    //             // Werte ergänzen falls fehlend
    //             IF (lrc_PurchaseLine."Location Code" = '') AND
    //                (vrc_PurchHeader."Location Code" <> '') THEN BEGIN
    //               lrc_PurchaseLine."Location Code" := vrc_PurchHeader."Location Code";
    //             END;
    //             IF lrc_PurchaseLine."Location Code" = lrc_PurchaseLine."Entry via Transfer Loc. Code" THEN BEGIN
    //               lrc_PurchaseLine."Entry via Transfer Loc. Code" := '';
    //             END;
    //             IF (lrc_PurchaseLine."Location Code" <> '') AND
    //                (lrc_PurchaseLine."Location Group Code" = '') THEN BEGIN
    //               lrc_Location.GET(lrc_PurchaseLine."Location Code");
    //               lrc_PurchaseLine."Location Group Code" := lrc_Location."Location Group Code";
    //             END;
    //             IF (lrc_PurchaseLine."Transport Unit of Measure (TU)" <> '') AND
    //                (lrc_PurchaseLine."Freight Unit of Measure (FU)" = '') THEN BEGIN
    //               lrc_UnitofMeasure.GET(lrc_PurchaseLine."Transport Unit of Measure (TU)");
    //               lrc_PurchaseLine."Freight Unit of Measure (FU)" := lrc_UnitofMeasure."Freight Unit of Measure (FU)";
    //             END;
    //             IF (lrc_PurchaseLine."Shipping Agent Code" = '') THEN BEGIN
    //               IF vrc_PurchHeader."Shipping Agent Code" <> '' THEN BEGIN
    //                 lrc_PurchaseLine."Shipping Agent Code" := vrc_PurchHeader."Shipping Agent Code";
    //               END;
    //             END;
    //             IF (lrc_PurchaseLine."Ship-Agent Code to Transf. Loc" = '') AND
    //                (lrc_PurchaseLine."Entry via Transfer Loc. Code" <> '') THEN BEGIN
    //               IF vrc_PurchHeader."Ship-Agent Code to Transf. Loc" <> '' THEN BEGIN
    //                 lrc_PurchaseLine."Ship-Agent Code to Transf. Loc" := vrc_PurchHeader."Ship-Agent Code to Transf. Loc";
    //               END;
    //             END;
    //             lrc_PurchaseLine.MODIFY();


    //             IF (lrc_PurchaseLine."Entry via Transfer Loc. Code" <> '') AND
    //                (lrc_PurchaseLine."Location Code" <> '') AND
    //                (lrc_PurchaseLine."Location Code" <> lrc_PurchaseLine."Entry via Transfer Loc. Code") THEN BEGIN

    //               // -----------------------------------------------------------------------
    //               // Fracht vom Lieferanten zum Zwischenlager
    //               // -----------------------------------------------------------------------
    //               IF lrc_ShipmentMethod."Incl. Freight to Transfer Loc." = FALSE THEN BEGIN

    //                 lrc_ShippingAgent.GET(lrc_PurchaseLine."Ship-Agent Code to Transf. Loc");

    //                 // Abgangsregion ermitteln
    //                 lco_DepartureRegionCode := '';
    //                 IF lrc_PurchaseLine."Order Address Code" <> '' THEN BEGIN
    //                   lrc_OrderAddress.RESET();
    //                   lrc_OrderAddress.SETFILTER("Vendor No.",'%1|%2',vrc_PurchHeader."Buy-from Vendor No.",'');
    //                   lrc_OrderAddress.SETRANGE(Code,lrc_PurchaseLine."Order Address Code");
    //                   lrc_OrderAddress.FINDLAST;
    //                   lrc_OrderAddress.TESTFIELD("Departure Region Code");
    //                   lco_DepartureRegionCode := lrc_OrderAddress."Departure Region Code";
    //                 END ELSE BEGIN
    //                   lrc_Vendor.TESTFIELD("Departure Region Code");
    //                   lco_DepartureRegionCode := lrc_Vendor."Departure Region Code";
    //                 END;

    //                 // Zugangsregion ermitteln
    //                 lrc_Location.GET(lrc_PurchaseLine."Entry via Transfer Loc. Code");
    //                 lrc_Location.TESTFIELD("POI Arrival Region Code");
    //                 lco_ArrivalRegionCode := lrc_Location."POI Arrival Region Code";

    //                 // Zustellersatz einfügen
    //                 lrc_PurchFreightCosts.RESET();
    //                 lrc_PurchFreightCosts.INIT();
    //                 lrc_PurchFreightCosts."Document Type" := lrc_PurchaseLine."Document Type";
    //                 lrc_PurchFreightCosts."Doc. No." := lrc_PurchaseLine."Document No.";
    //                 lrc_PurchFreightCosts.Type := lrc_PurchFreightCosts.Type::Spediteur;
    //                 lrc_PurchFreightCosts."Departure Region Code" := '';
    //                 lrc_PurchFreightCosts."POI Arrival Region Code" := '';
    //                 lrc_PurchFreightCosts."Shipping Agent Code" := lrc_PurchaseLine."Ship-Agent Code to Transf. Loc";
    //                 lrc_PurchFreightCosts."Freight Unit Code" := '';
    //                 IF NOT lrc_PurchFreightCosts.INSERT THEN;

    //                 // Frachtsatz einfügen
    //                 lrc_PurchFreightCosts.RESET();
    //                 lrc_PurchFreightCosts.SETRANGE("Document Type",lrc_PurchaseLine."Document Type");
    //                 lrc_PurchFreightCosts.SETRANGE("Doc. No.",lrc_PurchaseLine."Document No.");
    //                 lrc_PurchFreightCosts.SETRANGE(Type,lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //                 lrc_PurchFreightCosts.SETRANGE("Departure Region Code",lco_DepartureRegionCode);
    //                 lrc_PurchFreightCosts.SETRANGE("POI Arrival Region Code",lco_ArrivalRegionCode);
    //                 lrc_PurchFreightCosts.SETRANGE("Shipping Agent Code",lrc_PurchaseLine."Ship-Agent Code to Transf. Loc");
    //                 lrc_PurchFreightCosts.SETRANGE("Freight Unit Code",lrc_PurchaseLine."Freight Unit of Measure (FU)");
    //                 IF NOT lrc_PurchFreightCosts.FINDFIRST() THEN BEGIN
    //                   lrc_PurchFreightCosts.RESET();
    //                   lrc_PurchFreightCosts.INIT();
    //                   lrc_PurchFreightCosts."Document Type" := lrc_PurchaseLine."Document Type";
    //                   lrc_PurchFreightCosts."Doc. No." := lrc_PurchaseLine."Document No.";
    //                   lrc_PurchFreightCosts.Type := lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit";
    //                   lrc_PurchFreightCosts."Departure Region Code" := lco_DepartureRegionCode;
    //                   lrc_PurchFreightCosts."POI Arrival Region Code" := lco_ArrivalRegionCode;
    //                   lrc_PurchFreightCosts."Shipping Agent Code" := lrc_PurchaseLine."Ship-Agent Code to Transf. Loc";
    //                   lrc_PurchFreightCosts."Freight Cost Tariff Base" := lrc_ShippingAgent."Freight Cost Tariff Base";
    //                   lrc_PurchFreightCosts."Freight Unit Code" := lrc_PurchaseLine."Freight Unit of Measure (FU)";
    //                   lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" := lrc_PurchaseLine."Quantity (TU)";
    //                   lrc_PurchFreightCosts."Qty. of Colli (SDF)" := lrc_PurchaseLine.Quantity;
    //                   lrc_PurchFreightCosts."Gross Weight (SDF)" := lrc_PurchaseLine."Total Gross Weight";
    //                   lrc_PurchFreightCosts."Net Weight (SDF)" := lrc_PurchaseLine."Total Net Weight";
    //                   lrc_PurchFreightCosts."Source Target Type" := lrc_PurchFreightCosts."Source Target Type"::"Vendor to Via Location";
    //                   IF lrc_PurchaseLine."Order Address Code" <> '' THEN BEGIN
    //                     lrc_PurchFreightCosts."Source Departure" := lrc_PurchFreightCosts."Source Departure"::"Vendor Order Address";
    //                     lrc_PurchFreightCosts."Source Departure No." := lrc_PurchaseLine."Order Address Code";
    //                   END ELSE BEGIN
    //                     lrc_PurchFreightCosts."Source Departure" := lrc_PurchFreightCosts."Source Departure"::Vendor;
    //                     lrc_PurchFreightCosts."Source Departure No." := lrc_PurchaseLine."Buy-from Vendor No.";
    //                   END;
    //                   lrc_PurchFreightCosts."Source Arrival" := lrc_PurchFreightCosts."Source Arrival"::"Via Location";
    //                   lrc_PurchFreightCosts."Source Arrival No." := lrc_PurchaseLine."Entry via Transfer Loc. Code";
    //                   lrc_PurchFreightCosts.insert();
    //                 END ELSE BEGIN
    //                   lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" := lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" +
    //                                                                          lrc_PurchaseLine."Quantity (TU)";
    //                   lrc_PurchFreightCosts."Qty. of Colli (SDF)" := lrc_PurchFreightCosts."Qty. of Colli (SDF)" +
    //                                                                  lrc_PurchaseLine.Quantity;
    //                   lrc_PurchFreightCosts."Gross Weight (SDF)" := lrc_PurchFreightCosts."Gross Weight (SDF)" +
    //                                                                 lrc_PurchaseLine."Total Gross Weight";
    //                   lrc_PurchFreightCosts."Net Weight (SDF)" := lrc_PurchFreightCosts."Net Weight (SDF)" +
    //                                                               lrc_PurchaseLine."Total Net Weight";
    //                   lrc_PurchFreightCosts.MODIFY();
    //                 END;

    //               END;

    //               // -----------------------------------------------------------------------
    //               // Fracht vom Zwischenlager zum Ziellager
    //               // -----------------------------------------------------------------------
    //               IF (lrc_ShipmentMethod."Incl. Freight to Final Loc." = FALSE) THEN BEGIN

    //                 lrc_ShippingAgent.GET(lrc_PurchaseLine."Shipping Agent Code");

    //                 // Abgangsregion ermitteln
    //                 lrc_Location.GET(lrc_PurchaseLine."Entry via Transfer Loc. Code");
    //                 lrc_Location.TESTFIELD("Departure Region Code");
    //                 lco_DepartureRegionCode := lrc_Location."Departure Region Code";

    //                 // Zugangsregion ermitteln
    //                 lrc_Location.GET(lrc_PurchaseLine."Location Code");
    //                 lrc_Location.TESTFIELD("POI Arrival Region Code");
    //                 lco_ArrivalRegionCode := lrc_Location."POI Arrival Region Code";

    //                 // Zustellersatz einfügen
    //                 lrc_PurchFreightCosts.RESET();
    //                 lrc_PurchFreightCosts.INIT();
    //                 lrc_PurchFreightCosts."Document Type" := lrc_PurchaseLine."Document Type";
    //                 lrc_PurchFreightCosts."Doc. No." := lrc_PurchaseLine."Document No.";
    //                 lrc_PurchFreightCosts.Type := lrc_PurchFreightCosts.Type::Spediteur;
    //                 lrc_PurchFreightCosts."Departure Region Code" := '';
    //                 lrc_PurchFreightCosts."POI Arrival Region Code" := '';
    //                 lrc_PurchFreightCosts."Shipping Agent Code" := lrc_PurchaseLine."Shipping Agent Code";
    //                 lrc_PurchFreightCosts."Freight Unit Code" := '';
    //                 IF NOT lrc_PurchFreightCosts.INSERT THEN;

    //                 // Frachtsatz einfügen
    //                 lrc_PurchFreightCosts.RESET();
    //                 lrc_PurchFreightCosts.SETRANGE("Document Type",lrc_PurchaseLine."Document Type");
    //                 lrc_PurchFreightCosts.SETRANGE("Doc. No.",lrc_PurchaseLine."Document No.");
    //                 lrc_PurchFreightCosts.SETRANGE(Type,lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //                 lrc_PurchFreightCosts.SETRANGE("Departure Region Code",lco_DepartureRegionCode);
    //                 lrc_PurchFreightCosts.SETRANGE("POI Arrival Region Code",lco_ArrivalRegionCode);
    //                 lrc_PurchFreightCosts.SETRANGE("Shipping Agent Code",lrc_PurchaseLine."Shipping Agent Code");
    //                 lrc_PurchFreightCosts.SETRANGE("Freight Unit Code",lrc_PurchaseLine."Freight Unit of Measure (FU)");
    //                 IF NOT lrc_PurchFreightCosts.FINDFIRST() THEN BEGIN
    //                   lrc_PurchFreightCosts.RESET();
    //                   lrc_PurchFreightCosts.INIT();
    //                   lrc_PurchFreightCosts."Document Type" := lrc_PurchaseLine."Document Type";
    //                   lrc_PurchFreightCosts."Doc. No." := lrc_PurchaseLine."Document No.";
    //                   lrc_PurchFreightCosts.Type := lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit";
    //                   lrc_PurchFreightCosts."Departure Region Code" := lco_DepartureRegionCode;
    //                   lrc_PurchFreightCosts."POI Arrival Region Code" := lco_ArrivalRegionCode;
    //                   lrc_PurchFreightCosts."Shipping Agent Code" := lrc_PurchaseLine."Shipping Agent Code";
    //                   lrc_PurchFreightCosts."Freight Cost Tariff Base" := lrc_ShippingAgent."Freight Cost Tariff Base";
    //                   lrc_PurchFreightCosts."Freight Unit Code" := lrc_PurchaseLine."Freight Unit of Measure (FU)";
    //                   lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" := lrc_PurchaseLine."Quantity (TU)";
    //                   lrc_PurchFreightCosts."Qty. of Colli (SDF)" := lrc_PurchaseLine.Quantity;
    //                   lrc_PurchFreightCosts."Gross Weight (SDF)" := lrc_PurchaseLine."Total Gross Weight";
    //                   lrc_PurchFreightCosts."Net Weight (SDF)" := lrc_PurchaseLine."Total Net Weight";
    //                   lrc_PurchFreightCosts."Source Target Type" := lrc_PurchFreightCosts."Source Target Type"::"Via Location to Location";
    //                   lrc_PurchFreightCosts."Source Departure" := lrc_PurchFreightCosts."Source Departure"::"Via Location";
    //                   lrc_PurchFreightCosts."Source Departure No." := lrc_PurchaseLine."Entry via Transfer Loc. Code";
    //                   lrc_PurchFreightCosts."Source Arrival" := lrc_PurchFreightCosts."Source Arrival"::Location;
    //                   lrc_PurchFreightCosts."Source Arrival No." := lrc_PurchaseLine."Location Code";
    //                   lrc_PurchFreightCosts.insert();
    //                 END ELSE BEGIN
    //                   lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" := lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" +
    //                                                                          lrc_PurchaseLine."Quantity (TU)";
    //                   lrc_PurchFreightCosts."Qty. of Colli (SDF)" := lrc_PurchFreightCosts."Qty. of Colli (SDF)" +
    //                                                                  lrc_PurchaseLine.Quantity;
    //                   lrc_PurchFreightCosts."Gross Weight (SDF)" := lrc_PurchFreightCosts."Gross Weight (SDF)" +
    //                                                                 lrc_PurchaseLine."Total Gross Weight";
    //                   lrc_PurchFreightCosts."Net Weight (SDF)" := lrc_PurchFreightCosts."Net Weight (SDF)" +
    //                                                               lrc_PurchaseLine."Total Net Weight";
    //                   lrc_PurchFreightCosts.MODIFY();
    //                 END;

    //               END;

    //             END ELSE BEGIN

    //               // -----------------------------------------------------------------------
    //               // Fracht vom Lieferanten zum Ziellager
    //               // -----------------------------------------------------------------------
    //               IF (lrc_PurchaseLine."Location Code" <> '') AND
    //                  (lrc_ShipmentMethod."Incl. Freight to Final Loc." = FALSE) THEN BEGIN

    //                 lrc_ShippingAgent.GET(lrc_PurchaseLine."Shipping Agent Code");

    //                 // Abgangsregion ermitteln
    //                 lco_DepartureRegionCode := '';
    //                 IF lrc_PurchaseLine."Order Address Code" <> '' THEN BEGIN
    //                   lrc_OrderAddress.RESET();
    //                   lrc_OrderAddress.SETFILTER("Vendor No.",'%1|%2',vrc_PurchHeader."Buy-from Vendor No.",'');
    //                   lrc_OrderAddress.SETRANGE(Code,lrc_PurchaseLine."Order Address Code");
    //                   lrc_OrderAddress.FINDLAST;
    //                   lrc_OrderAddress.TESTFIELD("Departure Region Code");
    //                   lco_DepartureRegionCode := lrc_OrderAddress."Departure Region Code";
    //                 END ELSE BEGIN
    //                   lrc_Vendor.TESTFIELD("Departure Region Code");
    //                   lco_DepartureRegionCode := lrc_Vendor."Departure Region Code";
    //                 END;

    //                 lrc_Location.GET(lrc_PurchaseLine."Location Code");
    //                 lrc_Location.TESTFIELD("POI Arrival Region Code");
    //                 lco_ArrivalRegionCode := lrc_Location."POI Arrival Region Code";

    //                 // Zustellersatz einfügen
    //                 lrc_PurchFreightCosts.RESET();
    //                 lrc_PurchFreightCosts.INIT();
    //                 lrc_PurchFreightCosts."Document Type" := lrc_PurchaseLine."Document Type";
    //                 lrc_PurchFreightCosts."Doc. No." := lrc_PurchaseLine."Document No.";
    //                 lrc_PurchFreightCosts.Type := lrc_PurchFreightCosts.Type::Spediteur;
    //                 lrc_PurchFreightCosts."Departure Region Code" := '';
    //                 lrc_PurchFreightCosts."POI Arrival Region Code" := '';
    //                 lrc_PurchFreightCosts."Shipping Agent Code" := lrc_PurchaseLine."Shipping Agent Code";
    //                 lrc_PurchFreightCosts."Freight Unit Code" := '';
    //                 IF NOT lrc_PurchFreightCosts.INSERT THEN;

    //                 // Frachtsatz einfügen
    //                 lrc_PurchFreightCosts.RESET();
    //                 lrc_PurchFreightCosts.SETRANGE("Document Type",lrc_PurchaseLine."Document Type");
    //                 lrc_PurchFreightCosts.SETRANGE("Doc. No.",lrc_PurchaseLine."Document No.");
    //                 lrc_PurchFreightCosts.SETRANGE(Type,lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //                 lrc_PurchFreightCosts.SETRANGE("Departure Region Code",lco_DepartureRegionCode);
    //                 lrc_PurchFreightCosts.SETRANGE("POI Arrival Region Code",lco_ArrivalRegionCode);
    //                 lrc_PurchFreightCosts.SETRANGE("Shipping Agent Code",lrc_PurchaseLine."Shipping Agent Code");
    //                 lrc_PurchFreightCosts.SETRANGE("Freight Unit Code",lrc_PurchaseLine."Freight Unit of Measure (FU)");
    //                 IF NOT lrc_PurchFreightCosts.FINDFIRST() THEN BEGIN
    //                   lrc_PurchFreightCosts.RESET();
    //                   lrc_PurchFreightCosts.INIT();
    //                   lrc_PurchFreightCosts."Document Type" := lrc_PurchaseLine."Document Type";
    //                   lrc_PurchFreightCosts."Doc. No." := lrc_PurchaseLine."Document No.";
    //                   lrc_PurchFreightCosts.Type := lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit";
    //                   lrc_PurchFreightCosts."Departure Region Code" := lco_DepartureRegionCode;
    //                   lrc_PurchFreightCosts."POI Arrival Region Code" := lco_ArrivalRegionCode;
    //                   lrc_PurchFreightCosts."Shipping Agent Code" := lrc_PurchaseLine."Shipping Agent Code";
    //                   lrc_PurchFreightCosts."Freight Cost Tariff Base" := lrc_ShippingAgent."Freight Cost Tariff Base";
    //                   lrc_PurchFreightCosts."Freight Unit Code" := lrc_PurchaseLine."Freight Unit of Measure (FU)";
    //                   lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" := lrc_PurchaseLine."Quantity (TU)";
    //                   lrc_PurchFreightCosts."Qty. of Colli (SDF)" := lrc_PurchaseLine.Quantity;
    //                   lrc_PurchFreightCosts."Gross Weight (SDF)" := lrc_PurchaseLine."Total Gross Weight";
    //                   lrc_PurchFreightCosts."Net Weight (SDF)" := lrc_PurchaseLine."Total Net Weight";
    //                   lrc_PurchFreightCosts."Source Target Type" := lrc_PurchFreightCosts."Source Target Type"::"Vendor to Location";
    //                   IF lrc_PurchaseLine."Order Address Code" <> '' THEN BEGIN
    //                     lrc_PurchFreightCosts."Source Departure" := lrc_PurchFreightCosts."Source Departure"::"Vendor Order Address";
    //                     lrc_PurchFreightCosts."Source Departure No." := lrc_PurchaseLine."Order Address Code";
    //                   END ELSE BEGIN
    //                     lrc_PurchFreightCosts."Source Departure" := lrc_PurchFreightCosts."Source Departure"::Vendor;
    //                     lrc_PurchFreightCosts."Source Departure No." := lrc_PurchaseLine."Buy-from Vendor No.";
    //                   END;
    //                   lrc_PurchFreightCosts."Source Arrival" := lrc_PurchFreightCosts."Source Arrival"::Location;
    //                   lrc_PurchFreightCosts."Source Arrival No." := lrc_PurchaseLine."Location Code";
    //                   lrc_PurchFreightCosts.insert();
    //                 END ELSE BEGIN
    //                   lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" := lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" +
    //                                                                        lrc_PurchaseLine."Quantity (TU)";
    //                   lrc_PurchFreightCosts."Qty. of Colli (SDF)" := lrc_PurchFreightCosts."Qty. of Colli (SDF)" +
    //                                                                lrc_PurchaseLine.Quantity;
    //                   lrc_PurchFreightCosts."Gross Weight (SDF)" := lrc_PurchFreightCosts."Gross Weight (SDF)" +
    //                                                               lrc_PurchaseLine."Total Gross Weight";
    //                   lrc_PurchFreightCosts."Net Weight (SDF)" := lrc_PurchFreightCosts."Net Weight (SDF)" +
    //                                                             lrc_PurchaseLine."Total Net Weight";
    //                   lrc_PurchFreightCosts.MODIFY();
    //                 END;
    //               END;

    //             END;
    //           UNTIL lrc_PurchaseLine.NEXT() = 0;
    //         END;

    //         // Manuelle Frachtraten wieder setzen falls noch gültiger Satz
    //         IF lrc_TempPurchFreightCosts.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             lrc_PurchFreightCosts.RESET();
    //             lrc_PurchFreightCosts.SETRANGE("Document Type",lrc_TempPurchFreightCosts."Document Type");
    //             lrc_PurchFreightCosts.SETRANGE("Doc. No.",lrc_TempPurchFreightCosts."Doc. No.");
    //             lrc_PurchFreightCosts.SETRANGE(Type,lrc_TempPurchFreightCosts.Type);
    //             lrc_PurchFreightCosts.SETRANGE("Departure Region Code",lrc_TempPurchFreightCosts."Departure Region Code");
    //             lrc_PurchFreightCosts.SETRANGE("POI Arrival Region Code",lrc_TempPurchFreightCosts."POI Arrival Region Code");
    //             lrc_PurchFreightCosts.SETRANGE("Shipping Agent Code",lrc_TempPurchFreightCosts."Shipping Agent Code");
    //             lrc_PurchFreightCosts.SETRANGE("Freight Unit Code",lrc_TempPurchFreightCosts."Freight Unit Code");
    //             IF lrc_PurchFreightCosts.FINDFIRST() THEN BEGIN
    //               lrc_PurchFreightCosts."POI Freight Costs Amount (LCY)" := lrc_TempPurchFreightCosts."POI Freight Costs Amount (LCY)";
    //               lrc_PurchFreightCosts."Freight Cost Amount" := lrc_TempPurchFreightCosts."Freight Cost Amount";
    //               lrc_PurchFreightCosts."Freight Cost Price (LCY)" := lrc_TempPurchFreightCosts."Freight Cost Price (LCY)";
    //               lrc_PurchFreightCosts."Freight Cost Manual Entered" := lrc_TempPurchFreightCosts."Freight Cost Manual Entered";
    //               lrc_PurchFreightCosts.MODIFY();
    //             END;
    //           UNTIL lrc_TempPurchFreightCosts.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         PurchFreightCostsPerOrder(vrc_PurchHeader);
    //         PurchFreightAllocPerLine(vrc_PurchHeader."Document Type",vrc_PurchHeader."No.");
    //         COMMIT;
    //     end;

    //     procedure PurchFreightCostsPerOrder(vrc_PurchHeader: Record "38"): Boolean
    //     var
    //         lrc_PurchFreightCosts: Record "5110744";
    //         lrc_PurchFreightCosts2: Record "5110744";
    //         lrc_PurchLine: Record "39";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_UnitofMeasure: Record "204";
    //         ldc_QtyofFreightUnitsSDF: Decimal;
    //         ldc_TUQuantity: Decimal;
    //         lbn_SetFreightCostToZero: Boolean;
    //         ADF_LT_TEXT001: Label 'Tariff Base %1 not valid!';
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // Funktion zum Berechnen der Frachtkosten pro Kollo / Palette / Gewicht / Pauschal / Kollogewicht
    //         // ---------------------------------------------------------------------------------------------------------

    //         lbn_SetFreightCostToZero := FALSE;

    //         /*--
    //         // Kontrolle ob alle Kombinationen in Seitentabelle angelegt sind
    //         //xxSalesSetLocShipAgent(vrc_SalesHeader);

    //         // Kontrolle ob der Einkaufspreis aufgrund der Lieferbedingung Fracht enthält
    //         IF vrc_SalesHeader."Freight Calculation" = vrc_SalesHeader."Freight Calculation"::Standard THEN BEGIN
    //           IF (vrc_SalesHeader."POI Arrival Region Code" = '') OR
    //              (vrc_SalesHeader."Shipping Agent Code" = '') OR
    //              (vrc_SalesHeader."Shipment Method Code" = '') THEN BEGIN
    //             lbn_SetFreightCostToZero := TRUE;
    //           END ELSE BEGIN
    //             lrc_ShipmentMethod.GET(vrc_SalesHeader."Shipment Method Code");
    //             IF lrc_ShipmentMethod."Incl. Freight to Destination" = FALSE THEN
    //               lbn_SetFreightCostToZero := TRUE;
    //           END;
    //         END;

    //         // Keine Frachtkosten im Verkaufspreis
    //         IF lbn_SetFreightCostToZero = TRUE THEN BEGIN
    //           // Spediteure lesen
    //           lrc_SalesFreightCosts.RESET();
    //           lrc_SalesFreightCosts.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //           lrc_SalesFreightCosts.SETRANGE("Doc. No.",vrc_SalesHeader."No.");
    //           lrc_SalesFreightCosts.SETRANGE(Type,lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //           IF lrc_SalesFreightCosts.FIND('-') THEN BEGIN
    //             REPEAT
    //              IF vrc_SalesHeader."POI Arrival Region Code" = '' THEN BEGIN
    //                 IF lrc_SalesFreightCosts."Freight Cost Manual Entered" = FALSE THEN BEGIN
    //                   lrc_SalesFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)",0);
    //                   lrc_SalesFreightCosts.MODIFY();
    //                 END ELSE BEGIN
    //                   lrc_SalesFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)");
    //                   lrc_SalesFreightCosts.MODIFY();
    //                 END;
    //               END ELSE BEGIN
    //                 lrc_SalesFreightCosts.VALIDATE("POI Freight Costs Amount (LCY)",0);
    //                 lrc_SalesFreightCosts.MODIFY();
    //               END;
    //             UNTIL lrc_SalesFreightCosts.NEXT() = 0;

    //           END ELSE BEGIN
    //             IF vrc_SalesHeader."Shipping Agent Code" = '' THEN BEGIN
    //               lrc_SalesLine.RESET();
    //               lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //               lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //               lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //               lrc_SalesLine.SETRANGE("POI Item Typ",lrc_SalesLine."POI Item Typ"::"Trade Item");
    //               lrc_SalesLine.SETRANGE(Subtyp,lrc_SalesLine.Subtyp::" ");
    //               IF lrc_SalesLine.FIND('-') THEN BEGIN
    //                 REPEAT
    //                   lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit",0);
    //                   lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)" ,0);
    //                   lrc_SalesLine.MODIFY(TRUE);
    //                 UNTIL lrc_SalesLine.NEXT() = 0;
    //               END;
    //             END;
    //           END;

    //           EXIT(FALSE);
    //         END;
    //         --*/


    //         // ---------------------------------------------------------------------------------------
    //         // Spediteure lesen
    //         // ---------------------------------------------------------------------------------------
    //         lrc_PurchFreightCosts.RESET();
    //         lrc_PurchFreightCosts.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //         lrc_PurchFreightCosts.SETRANGE("Doc. No.",vrc_PurchHeader."No.");
    //         lrc_PurchFreightCosts.SETRANGE(Type,lrc_PurchFreightCosts.Type::Spediteur);
    //         IF lrc_PurchFreightCosts.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             lrc_ShippingAgent.GET(lrc_PurchFreightCosts."Shipping Agent Code");

    //             lrc_PurchFreightCosts2.RESET();
    //             lrc_PurchFreightCosts2.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //             lrc_PurchFreightCosts2.SETRANGE("Doc. No.",vrc_PurchHeader."No.");
    //             lrc_PurchFreightCosts2.SETRANGE(Type,lrc_PurchFreightCosts2.Type::"Sped.+AbgReg.+Frachteinheit");
    //             lrc_PurchFreightCosts2.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts."Shipping Agent Code");
    //             IF lrc_PurchFreightCosts2.FINDSET(TRUE,FALSE) THEN BEGIN
    //               REPEAT

    //                 // Manuelle Frachtkosten validieren damit auch neue Zeilen berücksichtigt werden!
    //                 IF lrc_PurchFreightCosts2."Freight Cost Manual Entered" = TRUE THEN BEGIN

    //                   lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                   lrc_PurchFreightCosts2.MODIFY();
    //                   COMMIT;

    //                 END ELSE BEGIN

    //                   // Frachtkosten zunächst zurücksetzen
    //                   lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)", 0);
    //                   lrc_PurchFreightCosts2.MODIFY();

    //                   // -------------------------------------------------------------------------------
    //                   // Frachtkosten Kalkulation über Frachttariffe
    //                   // -------------------------------------------------------------------------------
    //                   IF vrc_PurchHeader."Freight Calculation" = vrc_PurchHeader."Freight Calculation"::Standard THEN BEGIN

    //                     // Frachtkosten auf Basis Gewicht
    //                     CASE lrc_PurchFreightCosts2."Freight Cost Tariff Base" OF
    //                     lrc_PurchFreightCosts2."Freight Cost Tariff Base"::Weight:
    //                     BEGIN
    //         /*------
    //                       lrc_SalesFreightCosts2.CALCFIELDS("Gross Weight (SD)","Net Weight (SD)");

    //                       lrc_ShipAgentFreightcost.RESET();
    //                       lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts2."Shipping Agent Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",vrc_SalesHeader."POI Arrival Region Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_SalesFreightCosts2."Departure Region Code");
    //                       lrc_ShipAgentFreightcost.SETFILTER("From Quantity",
    //                                                          '<=%1',lrc_SalesFreightCosts2."Gross Weight (SD)");
    //                       lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",
    //                                                          '>=%1',lrc_SalesFreightCosts2."Gross Weight (SD)");
    //                       IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
    //                         IF lrc_ShipAgentFreightcost.Pauschal THEN
    //                           lrc_SalesFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                         ELSE
    //                           lrc_SalesFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                  lrc_SalesFreightCosts2."Gross Weight (SD)";
    //                         lrc_SalesFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                       END ELSE BEGIN
    //                         ERROR(lrc_ShipAgentFreightcost.GETFILTERS);
    //                       END;

    //                       lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
    //                       lrc_SalesFreightCosts2.MODIFY();
    //         -----*/
    //                     END;


    //                     // -------------------------------------------------------------------------------------------------
    //                     // Frachtkosten auf Basis Anzahl je Palettentypen
    //                     // -------------------------------------------------------------------------------------------------
    //                     lrc_PurchFreightCosts2."Freight Cost Tariff Base"::"Pallet Type":
    //                     BEGIN
    //                        ldc_QtyofFreightUnitsSDF := PalletTolerance(lrc_PurchFreightCosts2."Qty. of Freight Units (SDF)",
    //                                                                    lrc_PurchFreightCosts2."Shipping Agent Code");

    //                        lrc_ShipAgentFreightcost.RESET();
    //                        lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts2."Shipping Agent Code");
    //                        lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_PurchFreightCosts2."POI Arrival Region Code");
    //                        lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_PurchFreightCosts2."Departure Region Code");
    //                        lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",lrc_PurchFreightCosts2."Freight Unit Code");
    //                        lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                                                           ROUND(ldc_QtyofFreightUnitsSDF,1,'>'));
    //                        lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                                                           ROUND(ldc_QtyofFreightUnitsSDF,1,'>'));
    //                        IF lrc_ShipAgentFreightcost.FINDLAST THEN BEGIN
    //                          IF lrc_ShipAgentFreightcost.Pauschal THEN BEGIN
    //                            lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                          lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                          END ELSE BEGIN
    //                            lrc_PurchFreightCosts2."Freight Cost Price (LCY)" := lrc_ShipAgentFreightcost."Freight Rate per Unit";
    //                            lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                            lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                            ROUND(ldc_QtyofFreightUnitsSDF,1,'>');
    //                          END;
    //                          lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                        END ELSE BEGIN

    //                          IF lrc_UnitofMeasure.GET(lrc_PurchFreightCosts2."Freight Unit Code") THEN BEGIN
    //                            IF lrc_UnitofMeasure."Ref. Freight Unit" <> '' THEN BEGIN
    //                              lrc_UnitofMeasure.TESTFIELD("Ref. Freight Unit Qty");

    //                              lrc_ShipAgentFreightcost.RESET();
    //                              lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts2."Shipping Agent Code");
    //                              lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_PurchFreightCosts2."POI Arrival Region Code");
    //                              lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_PurchFreightCosts2."Departure Region Code");
    //                              lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",lrc_UnitofMeasure."Ref. Freight Unit");
    //                              lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                                                                 ROUND((ldc_QtyofFreightUnitsSDF /
    //                                                                        lrc_UnitofMeasure."Ref. Freight Unit Qty"),1,'>'));
    //                              lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                                                                  ROUND((ldc_QtyofFreightUnitsSDF /
    //                                                                        lrc_UnitofMeasure."Ref. Freight Unit Qty"),1,'>'));
    //                              IF lrc_ShipAgentFreightcost.FINDLAST THEN BEGIN

    //                                IF lrc_ShipAgentFreightcost.Pauschal THEN BEGIN
    //                                  lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                                lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                                END ELSE BEGIN
    //                                  lrc_PurchFreightCosts2."Freight Cost Price (LCY)" := lrc_ShipAgentFreightcost."Freight Rate per Unit";
    //                                  lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                                  ROUND(ldc_QtyofFreightUnitsSDF /
    //                                                                        lrc_UnitofMeasure."Ref. Freight Unit Qty",1,'>');
    //                                END;
    //                                lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");

    //                              END;

    //                            END;
    //                          END;

    //                        END;

    //                        lrc_PurchFreightCosts2."Cargo Rate" := TRUE;
    //                        lrc_PurchFreightCosts2.MODIFY();
    //                     END;


    //                     // -------------------------------------------------------------------------------------------------
    //                     // Frachtkosten auf Basis Anzahl je Palettentypen und Gewicht
    //                     // -------------------------------------------------------------------------------------------------
    //                     lrc_PurchFreightCosts2."Freight Cost Tariff Base"::"Pallet Type Weight":
    //                     BEGIN
    //                        ldc_QtyofFreightUnitsSDF := PalletTolerance(lrc_PurchFreightCosts2."Qty. of Freight Units (SDF)",
    //                                                                    lrc_PurchFreightCosts2."Shipping Agent Code");

    //                        lrc_ShipAgentFreightcost.RESET();
    //                        lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts2."Shipping Agent Code");
    //                        lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_PurchFreightCosts2."POI Arrival Region Code");
    //                        lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_PurchFreightCosts2."Departure Region Code");
    //                        lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",lrc_PurchFreightCosts2."Freight Unit Code");
    //                        lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                                                           ROUND(ldc_QtyofFreightUnitsSDF,1,'>'));
    //                        lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                                                           ROUND(ldc_QtyofFreightUnitsSDF,1,'>'));
    //                        IF lrc_ShipAgentFreightcost.FINDLAST THEN BEGIN
    //                          IF lrc_ShipAgentFreightcost.Pauschal THEN BEGIN
    //                            lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                          lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                          END ELSE BEGIN
    //                            lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                            lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                            ROUND(lrc_PurchFreightCosts2."Net Weight (SD)",1,'>');
    //                          END;
    //                          lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                        END ELSE BEGIN

    //                          IF lrc_UnitofMeasure.GET(lrc_PurchFreightCosts2."Freight Unit Code") THEN BEGIN
    //                            IF lrc_UnitofMeasure."Ref. Freight Unit" <> '' THEN BEGIN
    //                              lrc_UnitofMeasure.TESTFIELD("Ref. Freight Unit Qty");

    //                              lrc_ShipAgentFreightcost.RESET();
    //                              lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts2."Shipping Agent Code");
    //                              lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_PurchFreightCosts2."POI Arrival Region Code");
    //                              lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_PurchFreightCosts2."Departure Region Code");
    //                              lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",lrc_UnitofMeasure."Ref. Freight Unit");
    //                              lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                                                                 ROUND((ldc_QtyofFreightUnitsSDF /
    //                                                                        lrc_UnitofMeasure."Ref. Freight Unit Qty"),1,'>'));
    //                              lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                                                                  ROUND((ldc_QtyofFreightUnitsSDF /
    //                                                                        lrc_UnitofMeasure."Ref. Freight Unit Qty"),1,'>'));
    //                              IF lrc_ShipAgentFreightcost.FINDLAST THEN BEGIN
    //                                IF lrc_ShipAgentFreightcost.Pauschal THEN BEGIN
    //                                  lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                                lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                                END ELSE BEGIN
    //                                  lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                                  lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                                  ROUND(lrc_PurchFreightCosts2."Net Weight (SD)",1,'>');
    //                                END;
    //                                lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                              END;
    //                            END;
    //                          END;
    //                        END;

    //                        lrc_PurchFreightCosts2."Cargo Rate" := TRUE;
    //                        lrc_PurchFreightCosts2.MODIFY();
    //                     END;


    //                     // -------------------------------------------------------------------------------------------------
    //                     // Frachtkosten auf Basis Anzahl Paletten
    //                     // -------------------------------------------------------------------------------------------------
    //                     lrc_PurchFreightCosts2."Freight Cost Tariff Base"::Pallet:
    //                     BEGIN

    //         //xx              lrc_PurchFreightCosts2.CALCFIELDS("Qty. of Pallets (SD)");
    //                       //lrc_PurchFreightCosts2.CALCFIELDS("Qty. of Freight Units (SDF)");
    //                       ldc_TUQuantity := lrc_PurchFreightCosts2."Qty. of Freight Units (SDF)";
    //         //              ldc_TUQuantity := lrc_PurchFreightCosts2."Qty. of Pallets (SD)";
    //                       ldc_TUQuantity := PalletTolerance(ldc_TUQuantity, lrc_PurchFreightCosts2."Shipping Agent Code");


    //                       lrc_ShipAgentFreightcost.RESET();
    //                       lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts2."Shipping Agent Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_PurchFreightCosts2."POI Arrival Region Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lrc_PurchFreightCosts2."Departure Region Code");
    //                       //lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",
    //                       //        lrc_SalesFreightCosts2."Freight Unit Code");
    //                       // FRA 009 DMG50000.s
    //                       // lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                       //                                      ROUND(lrc_SalesFreightCosts2."Qty. of Pallets (SD)",1,'>'));
    //                       // lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                       //                                      ROUND(lrc_SalesFreightCosts2."Qty. of Pallets (SD)",1,'>'));
    //                       lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',ROUND(ldc_TUQuantity ,1,'>'));
    //                       lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',ROUND(ldc_TUQuantity,1,'>'));
    //                       // FRA 009 DMG50000.e
    //                       IF lrc_ShipAgentFreightcost.FINDLAST THEN BEGIN
    //                         IF lrc_ShipAgentFreightcost.Pauschal THEN
    //                           lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                            lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                         ELSE
    //                           lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                            lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                            // ROUND(lrc_SalesFreightCosts2."Qty. of Pallets (SD)",1,'>');
    //                                                            ROUND(ldc_TUQuantity,1,'>');
    //                         lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                       END;

    //                       lrc_PurchFreightCosts2."Cargo Rate" := TRUE;
    //                       lrc_PurchFreightCosts2.MODIFY();

    //                     END;


    //                     // -------------------------------------------------------------------------------------------------
    //                     // Frachtkosten auf Basis Anzahl Paletten und Gewicht
    //                     // -------------------------------------------------------------------------------------------------
    //                     lrc_PurchFreightCosts2."Freight Cost Tariff Base"::"Pallet Weight":
    //                     BEGIN

    //         //xx              lrc_PurchFreightCosts2.CALCFIELDS("Qty. of Pallets (SD)","Gross Weight (SD)","Gross Weight (SDF)",
    //         //xx                                                "Net Weight (SD)","Net Weight (SDF)");

    //                       ldc_TUQuantity := lrc_PurchFreightCosts2."Qty. of Pallets (SD)";
    //                       ldc_TUQuantity := PalletTolerance(ldc_TUQuantity, lrc_PurchFreightCosts2."Shipping Agent Code");

    //                       lrc_ShipAgentFreightcost.RESET();
    //                       lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts2."Shipping Agent Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_PurchFreightCosts2."POI Arrival Region Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",
    //                                                         lrc_PurchFreightCosts2."Departure Region Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",'');
    //                       // lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                       //                                    ROUND(lrc_SalesFreightCosts2."Qty. of Pallets (SD)",1,'>'));
    //                       // lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                       //                                    ROUND(lrc_SalesFreightCosts2."Qty. of Pallets (SD)",1,'>'));
    //                       lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',ROUND(ldc_TUQuantity,1,'>'));
    //                       lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',ROUND(ldc_TUQuantity,1,'>'));
    //                       IF lrc_ShipAgentFreightcost.FINDLAST THEN BEGIN
    //                         IF lrc_ShipAgentFreightcost.Pauschal THEN BEGIN
    //                           lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                            lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                         END ELSE BEGIN
    //                           CASE lrc_ShippingAgent."POI Freight Cost Ref. Weight" OF
    //                           lrc_ShippingAgent."POI Freight Cost Ref. Weight"::"Net Weight":
    //                             lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                              lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                              ROUND(lrc_PurchFreightCosts2."Net Weight (SD)",1,'>');
    //                           lrc_ShippingAgent."POI Freight Cost Ref. Weight"::"Gross Weight":
    //                             lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                              lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                              ROUND(lrc_PurchFreightCosts2."Gross Weight (SD)",1,'>');
    //                           ELSE
    //                             lrc_ShippingAgent.TESTFIELD("POI Freight Cost Ref. Weight");
    //                           END;
    //                         END;
    //                         lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                       END;

    //                       lrc_PurchFreightCosts2."Cargo Rate" := TRUE;
    //                       lrc_PurchFreightCosts2.MODIFY();

    //                     END;


    //                     // -------------------------------------------------------------------------------------------------
    //                     // Frachtkosten auf Basis Kollogewicht
    //                     // -------------------------------------------------------------------------------------------------
    //                     lrc_PurchFreightCosts2."Freight Cost Tariff Base"::"Collo Weight":
    //                     BEGIN

    //                       // Tariff Base %1 not valid!
    //                       ERROR(ADF_LT_TEXT001,lrc_PurchFreightCosts2."Freight Cost Tariff Base")

    //         /*-------
    //                       lrc_SalesFreightCosts2."POI Freight Costs Amount (LCY)" := 0;
    //                       lrc_SalesFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                       lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
    //                       lrc_SalesFreightCosts2.MODIFY();

    //                       lrc_SalesLine.RESET();
    //                       lrc_SalesLine.SETRANGE("Document Type",lrc_SalesFreightCosts2."Document Type");
    //                       lrc_SalesLine.SETRANGE("Document No.",lrc_SalesFreightCosts2."Doc. No.");
    //                       lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //                       lrc_SalesLine.SETRANGE("POI Item Typ",lrc_SalesLine."POI Item Typ"::"Trade Item");
    //                       lrc_SalesLine.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts2."Shipping Agent Code");
    //                       lrc_SalesLine.SETFILTER("Departure Region Code",'%1','');
    //                       IF lrc_SalesLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //                         REPEAT
    //                           lrc_SalesLine."POI Reference Freight Costs" := lrc_SalesLine."POI Reference Freight Costs"::Collo;
    //                           lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
    //                           lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)", 0);
    //                           lrc_SalesLine.MODIFY();
    //                         UNTIL lrc_SalesLine.NEXT() = 0;
    //                       END;

    //                       lrc_SalesLine.SETRANGE("Departure Region Code",lrc_SalesFreightCosts2."Departure Region Code");
    //                       IF lrc_SalesLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //                         REPEAT
    //                           lrc_SalesLine."POI Reference Freight Costs" := lrc_SalesFreightCosts2."Freight Cost Tariff Base";
    //                           lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
    //                           lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)", 0);
    //                           lrc_SalesLine.MODIFY();
    //                         UNTIL lrc_SalesLine.NEXT() = 0;

    //                         IF lrc_SalesLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //                           REPEAT

    //                             IF (lrc_SalesLine."Gross Weight" > 0) AND
    //                                (lrc_SalesLine.Quantity > 0) THEN BEGIN

    //                               lrc_ShipAgentFreightcost.RESET();
    //                               lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",
    //                                                                 lrc_SalesFreightCosts2."Shipping Agent Code");
    //                               lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",vrc_SalesHeader."POI Arrival Region Code");
    //                               lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",
    //                                                                 lrc_SalesFreightCosts2."Departure Region Code");
    //                               lrc_ShipAgentFreightcost.SETFILTER("From Quantity",
    //                                                                  '<=%1',lrc_SalesLine."Gross Weight");
    //                               lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",
    //                                                                  '>=%1',lrc_SalesLine."Gross Weight");
    //                               IF lrc_ShipAgentFreightcost.FIND('+') THEN BEGIN
    //                                 lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit",
    //                                                        lrc_ShipAgentFreightcost."Freight Rate per Unit");

    //                                 IF lrc_ShipAgentFreightcost.Pauschal THEN BEGIN
    //                                   lrc_SalesFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                          lrc_ShipAgentFreightcost."Freight Rate per Unit";
    //                                   lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)",
    //                                                          lrc_ShipAgentFreightcost."Freight Rate per Unit");
    //                                 END ELSE BEGIN
    //                                   lrc_SalesFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                                  lrc_SalesFreightCosts2."POI Freight Costs Amount (LCY)" +
    //                                                                  (lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                                  lrc_SalesLine.Quantity);
    //                                   lrc_SalesFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                                   lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)",
    //                                                          (lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                           lrc_SalesLine.Quantity));
    //                                 END;
    //                                 lrc_SalesLine.MODIFY();

    //                               END ELSE BEGIN
    //                                 lrc_SalesLine."POI Reference Freight Costs" := lrc_SalesLine."POI Reference Freight Costs"::Collo;
    //                                 lrc_SalesLine.VALIDATE("POI Freight Cost per Ref. Unit", 0);
    //                                 lrc_SalesLine.VALIDATE("POI Freight Costs Amount (LCY)", 0);
    //                                 lrc_SalesLine.MODIFY();
    //                                 MESSAGE('Zeile ' + FORMAT(lrc_SalesLine."Line No.") +
    //                                         ', Kollogewicht-Frachtkosten nicht gefunden : ' +
    //                                         lrc_ShipAgentFreightcost.GETFILTERS);
    //                               END;

    //                               lrc_SalesFreightCosts2."Cargo Rate" := TRUE;
    //                               lrc_SalesFreightCosts2.MODIFY();

    //                             END;

    //                           UNTIL lrc_SalesLine.NEXT() = 0;
    //                         END;

    //                       END;
    //         ----*/
    //                     END;


    //                     // -------------------------------------------------------------------------------------------------
    //                     // Frachkosten auf Basis Anzahl Kolli
    //                     // -------------------------------------------------------------------------------------------------
    //                     lrc_PurchFreightCosts2."Freight Cost Tariff Base"::Collo:
    //                     BEGIN

    //         //xx              lrc_PurchFreightCosts2.CALCFIELDS("Qty. of Colli (SD)");
    //                       ldc_TUQuantity := lrc_PurchFreightCosts2."Qty. of Colli (SD)";
    //                       ldc_TUQuantity := ROUND(ldc_TUQuantity, 0.001);

    //                       lrc_ShipAgentFreightcost.RESET();
    //                       lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts2."Shipping Agent Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_PurchFreightCosts2."POI Arrival Region Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",
    //                                                         lrc_PurchFreightCosts2."Departure Region Code");
    //                       lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",'');
    //                       // lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',
    //                       //                                    ROUND(lrc_SalesFreightCosts2."Qty. of Colli (SD)",1,'>'));
    //                       // lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',
    //                       //                                    ROUND(lrc_SalesFreightCosts2."Qty. of Colli (SD)",1,'>'));
    //                       lrc_ShipAgentFreightcost.SETFILTER("From Quantity",'<=%1',ROUND(ldc_TUQuantity,1,'>'));
    //                       lrc_ShipAgentFreightcost.SETFILTER("Until Quantity",'>=%1',ROUND(ldc_TUQuantity,1,'>'));
    //                       IF lrc_ShipAgentFreightcost.FINDLAST THEN BEGIN
    //                         IF lrc_ShipAgentFreightcost.Pauschal THEN
    //                           lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                            lrc_ShipAgentFreightcost."Freight Rate per Unit"
    //                         ELSE
    //                           lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" :=
    //                                                            lrc_ShipAgentFreightcost."Freight Rate per Unit" *
    //                                                            // FRA 009 DMG50000.s
    //                                                            // ROUND(lrc_SalesFreightCosts2."Qty. of Colli (SD)",1,'>');
    //                                                            ROUND(ldc_TUQuantity,1,'>');
    //                                                            // FRA 009 DMG50000.e
    //                         lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                       END;
    //                       lrc_PurchFreightCosts2."Cargo Rate" := TRUE;
    //                       lrc_PurchFreightCosts2.MODIFY();
    //                     END;

    //                   END;


    //                   // -------------------------------------------------------------------------------
    //                   // Frachtkosten manuell pro Verkaufszeile erfasst
    //                   // -------------------------------------------------------------------------------
    //                   END ELSE BEGIN

    //                     lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" := 0;
    //                     lrc_PurchFreightCosts2.VALIDATE("POI Freight Costs Amount (LCY)");
    //                     lrc_PurchFreightCosts2."Cargo Rate" := FALSE;
    //                     lrc_PurchFreightCosts2.MODIFY();

    //                     lrc_PurchLine.RESET();
    //                     lrc_PurchLine.SETRANGE("Document Type",lrc_PurchFreightCosts2."Document Type");
    //                     lrc_PurchLine.SETRANGE("Document No.",lrc_PurchFreightCosts2."Doc. No.");
    //                     lrc_PurchLine.SETRANGE(Type,lrc_PurchLine.Type::Item);
    //                     lrc_PurchLine.SETRANGE("POI Item Typ",lrc_PurchLine."POI Item Typ"::"Trade Item");
    //                     lrc_PurchLine.SETRANGE("Shipping Agent Code",lrc_PurchFreightCosts2."Shipping Agent Code");
    //                     lrc_PurchLine.SETRANGE(Subtyp,lrc_PurchLine.Subtyp::" ");
    //                     IF lrc_PurchLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //                       REPEAT
    //                         IF (lrc_PurchLine."POI Freight Costs Amount (LCY)" <> 0) THEN BEGIN
    //                           lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" := lrc_PurchFreightCosts2."POI Freight Costs Amount (LCY)" +
    //                                                                                  lrc_PurchLine."POI Freight Costs Amount (LCY)";
    //                           lrc_PurchFreightCosts2.MODIFY();
    //                         END;
    //                       UNTIL lrc_PurchLine.NEXT() = 0;
    //                     END;

    //                   END;
    //                 END;
    //               UNTIL lrc_PurchFreightCosts2.NEXT() = 0;
    //             END;
    //           UNTIL lrc_PurchFreightCosts.NEXT() = 0;
    //         END ELSE BEGIN
    //           EXIT(FALSE);
    //         END;

    //         EXIT(TRUE);

    //     end;

    //     procedure PurchFreightAllocPerLine(vop_PurchDocType: Option "0","1","2","3","4","5","6";vco_PurchDocNo: Code[20])
    //     var
    //         lrc_PurchHeader: Record "38";
    //         lrc_PurchLine: Record "39";
    //         lrc_PurchFreightCosts: Record "5110744";
    //         "ldc_QtyofFreightUnits(SDF)": Decimal;
    //         lbn_AllocateFreightToLine: Boolean;
    //     begin
    //         // --------------------------------------------------------------------------------------------------------
    //         // Funktion zur Verteilung der Frachtkosten auf die Einkaufszeilen
    //         // --------------------------------------------------------------------------------------------------------

    //         // Verkaufskopfsatz lesen
    //         lrc_PurchHeader.GET(vop_PurchDocType,vco_PurchDocNo);

    //         IF lrc_PurchHeader."Freight Calculation" <> lrc_PurchHeader."Freight Calculation"::Standard THEN
    //           EXIT;

    //         lrc_PurchLine.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //         lrc_PurchLine.SETRANGE("Document No.",lrc_PurchHeader."No.");
    //         lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
    //         lrc_PurchLine.SETRANGE("POI Item Typ",lrc_PurchLine."POI Item Typ"::"Trade Item");
    //         IF lrc_PurchLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //           REPEAT

    //             // Frachtkosten auf Null setzen
    //             lrc_PurchLine."POI Freight Cost per Ref. Unit" := 0;
    //             lrc_PurchLine."POI Freight Costs Amount (LCY)" := 0;

    //             // Anteilige Frachtkosten ermitteln
    //             lrc_PurchFreightCosts.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //             lrc_PurchFreightCosts.SETRANGE("Doc. No.",lrc_PurchHeader."No.");
    //             lrc_PurchFreightCosts.SETRANGE(Type,lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //             lrc_PurchFreightCosts.SETRANGE("Freight Unit Code",lrc_PurchLine."Freight Unit of Measure (FU)");
    //             IF lrc_PurchFreightCosts.FINDSET(FALSE,FALSE) THEN BEGIN
    //               REPEAT

    //                 lbn_AllocateFreightToLine := FALSE;
    //                 CASE lrc_PurchFreightCosts."Source Target Type" OF
    //                 lrc_PurchFreightCosts."Source Target Type"::"Vendor to Location":
    //                   BEGIN
    //                     IF (lrc_PurchLine."Entry via Transfer Loc. Code" = '') OR
    //                        (lrc_PurchLine."Entry via Transfer Loc. Code" = lrc_PurchLine."Location Code") THEN
    //                       lbn_AllocateFreightToLine := TRUE;
    //                   END;
    //                 lrc_PurchFreightCosts."Source Target Type"::"Vendor to Via Location":
    //                   BEGIN
    //                     IF (lrc_PurchLine."Entry via Transfer Loc. Code" <> '') AND
    //                        (lrc_PurchLine."Entry via Transfer Loc. Code" <> lrc_PurchLine."Location Code") THEN
    //                       lbn_AllocateFreightToLine := TRUE;
    //                   END;
    //                 lrc_PurchFreightCosts."Source Target Type"::"Via Location to Location":
    //                   BEGIN
    //                     IF (lrc_PurchLine."Entry via Transfer Loc. Code" <> '') AND
    //                        (lrc_PurchLine."Location Code" <> '') AND
    //                        (lrc_PurchLine."Entry via Transfer Loc. Code" <> lrc_PurchLine."Location Code") THEN
    //                       lbn_AllocateFreightToLine := TRUE;
    //                   END;
    //                 END;

    //                 IF lbn_AllocateFreightToLine = TRUE THEN BEGIN

    //                   CASE lrc_PurchFreightCosts."Freight Cost Tariff Base" OF
    //                   lrc_PurchFreightCosts."Freight Cost Tariff Base"::"Pallet Type",
    //                   lrc_PurchFreightCosts."Freight Cost Tariff Base"::Pallet:
    //                     BEGIN
    //                       IF lrc_PurchLine."Quantity (TU)" <> 0 THEN BEGIN
    //                         lrc_PurchLine."POI Freight Costs Amount (LCY)" := lrc_PurchLine."POI Freight Costs Amount (LCY)" +
    //                                                               (lrc_PurchFreightCosts."POI Freight Costs Amount (LCY)" /
    //                                                                lrc_PurchFreightCosts."Qty. of Freight Units (SDF)" *
    //                                                                lrc_PurchLine."Quantity (TU)");
    //                         lrc_PurchLine."POI Freight Cost per Ref. Unit" := lrc_PurchLine."POI Freight Costs Amount (LCY)" /
    //                                                                lrc_PurchLine."Quantity (TU)";
    //                       END;
    //                     END;
    //                   END;

    //                 END;

    //               UNTIL lrc_PurchFreightCosts.NEXT() = 0;
    //             END;

    //             lrc_PurchLine.MODIFY(TRUE);
    //           UNTIL lrc_PurchLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PurchFreightSetInCalcCosts(vrc_PurchaseHeader: Record "38")
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Frachtkosten in Kalkulatorische Plankosten setzen
    //         // ----------------------------------------------------------------------------------------------
    //     end;

    //     procedure PurchShowFreights(vop_DocType: Option "0","1","2","3","4","5","6";vco_DocNo: Code[20];vbn_CalcFreightCost: Boolean)
    //     var
    //         lrc_PurchHeader: Record "38";
    //         lrc_PurchFreightCosts: Record "5110744";
    //         lfm_PurchFreightCosts: Form "5110364";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Anzeige der Frachtkosten
    //         // ----------------------------------------------------------------------------------------------

    //         IF vbn_CalcFreightCost = TRUE THEN BEGIN
    //           lrc_PurchHeader.GET(vop_DocType,vco_DocNo);
    //           PurchSetLocShipAgent(lrc_PurchHeader);
    //           COMMIT;
    //         END;

    //         lrc_PurchFreightCosts.FILTERGROUP(2);
    //         lrc_PurchFreightCosts.SETRANGE("Document Type",vop_DocType);
    //         lrc_PurchFreightCosts.SETRANGE("Doc. No.",vco_DocNo);
    //         lrc_PurchFreightCosts.SETRANGE(Type,lrc_PurchFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //         lrc_PurchFreightCosts.FILTERGROUP(0);

    //         lfm_PurchFreightCosts.SETTABLEVIEW(lrc_PurchFreightCosts);
    //         lfm_PurchFreightCosts.RUNMODAL;
    //     end;

    //     procedure "-- FREIGHT ORDER --"()
    //     begin
    //     end;

    //     procedure PurchCalcQtyInFreightOrders(vco_OrderNo: Code[20];vco_OrderLineNo: Integer): Decimal
    //     var
    //         lrc_FreightOrderDetailLine: Record "5110440";
    //         ldc_QtyInFreightOrders: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Menge in Frachtaufträgen
    //         // ---------------------------------------------------------------------------------


    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source",lrc_FreightOrderDetailLine."Doc. Source"::Purchase);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Type",lrc_FreightOrderDetailLine."Doc. Source Type"::Order);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source No.",vco_OrderNo);
    //         lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Line No.",vco_OrderLineNo);
    //         IF lrc_FreightOrderDetailLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             ldc_QtyInFreightOrders := ldc_QtyInFreightOrders + lrc_FreightOrderDetailLine."Qty. to Ship";
    //           UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;
    //         END;

    //         EXIT(ldc_QtyInFreightOrders);
    //     end;


    procedure AllocateFreightCost(vrc_FreightOrderHeader: Record "POI Freight Order Header")
    var
        lbn_FirstSalesLine: Boolean;
        AGILES_LT_001Txt: Label 'Tarifbasis nicht zulässig!';
    begin
        // ---------------------------------------------------------------------------------
        // Funktion zur Verteilung der Frachtkosten
        // ---------------------------------------------------------------------------------

        vrc_FreightOrderHeader.CALCFIELDS("Calc. Qty. Pallets to Ship", "Calc. Qty. Colli to Ship",
                                          "Calc. Gross Weight to Ship", "Calc. Net Weight to Ship");

        IF vrc_FreightOrderHeader."Freight Costs (LCY)" = 0 THEN BEGIN

            lrc_FreightOrderDetailLine.SETRANGE("Freight Order No.", vrc_FreightOrderHeader."No.");
            IF lrc_FreightOrderDetailLine.FIND('-') THEN
                REPEAT
                    lrc_FreightOrderDetailLine."Freight Costs (LCY)" := 0;
                    lrc_FreightOrderDetailLine.MODIFY();
                UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;

        END ELSE
            CASE vrc_FreightOrderHeader."Freight Cost Tariff Base" OF
                vrc_FreightOrderHeader."Freight Cost Tariff Base"::Collo:
                    // Tarifbasis nicht zulässig!
                    ERROR(AGILES_LT_001Txt);
                vrc_FreightOrderHeader."Freight Cost Tariff Base"::Pallet:
                    BEGIN

                        lrc_FreightOrderDetailLine.SETRANGE("Freight Order No.", vrc_FreightOrderHeader."No.");
                        IF lrc_FreightOrderDetailLine.FIND('-') THEN
                            REPEAT
                                IF vrc_FreightOrderHeader."Calc. Qty. Pallets to Ship" <> 0 THEN BEGIN
                                    lrc_FreightOrderDetailLine."Freight Costs (LCY)" :=
                                                           vrc_FreightOrderHeader."Freight Costs (LCY)" /
                                                           vrc_FreightOrderHeader."Calc. Qty. Pallets to Ship" *
                                                           lrc_FreightOrderDetailLine."Qty. Transport Unit to Ship";
                                    lrc_FreightOrderDetailLine.MODIFY();
                                END ELSE BEGIN
                                    lrc_FreightOrderDetailLine."Freight Costs (LCY)" := 0;
                                    lrc_FreightOrderDetailLine.MODIFY();
                                END;
                            UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;

                    END;
                ELSE
                    // Tarifbasis nicht zulässig!
                    ERROR(AGILES_LT_001Txt)
            END;

        lrc_FreightOrderDetailLine.RESET();
        lrc_FreightOrderDetailLine.SETRANGE("Freight Order No.", vrc_FreightOrderHeader."No.");
        IF lrc_FreightOrderDetailLine.FIND('-') THEN
            REPEAT

                lbn_FirstSalesLine := FALSE;

                CASE lrc_FreightOrderDetailLine."Doc. Source" OF
                    lrc_FreightOrderDetailLine."Doc. Source"::Sales:
                        BEGIN
                            lrc_SalesLine.RESET();
                            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
                            lrc_SalesLine.SETRANGE("Document No.", lrc_FreightOrderDetailLine."Doc. Source No.");
                            lrc_SalesLine.SETRANGE("Line No.", lrc_FreightOrderDetailLine."Doc. Source Line No.");
                            IF lrc_SalesLine.FIND('-') THEN BEGIN
                                IF lbn_FirstSalesLine = FALSE THEN BEGIN
                                    lrc_SalesLine."POI Freight Costs Amount (LCY)" := 0;
                                    lbn_FirstSalesLine := TRUE;
                                END;

                                lrc_FreightOrderDetailLine2.RESET();
                                lrc_FreightOrderDetailLine2.SETRANGE("Doc. Source", lrc_FreightOrderDetailLine."Doc. Source");
                                lrc_FreightOrderDetailLine2.SETRANGE("Doc. Source Type", lrc_FreightOrderDetailLine."Doc. Source Type");
                                lrc_FreightOrderDetailLine2.SETRANGE("Doc. Source No.", lrc_FreightOrderDetailLine."Doc. Source No.");
                                lrc_FreightOrderDetailLine2.SETRANGE("Doc. Source Line No.", lrc_FreightOrderDetailLine."Doc. Source Line No.");
                                IF lrc_FreightOrderDetailLine2.FIND('-') THEN
                                    REPEAT
                                        lrc_SalesLine."POI Freight Costs Amount (LCY)" := lrc_SalesLine."POI Freight Costs Amount (LCY)" + lrc_FreightOrderDetailLine2."Freight Costs (LCY)";
                                    UNTIL lrc_FreightOrderDetailLine2.NEXT() = 0;


                                lrc_SalesLine.MODIFY();
                            END;
                        END;

                END;
            UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;
    end;

    //     procedure FreightCostContrPurchLoad(vrc_PurchHeader: Record "38")
    //     var
    //         lrc_FreightCostControle: Record "5087923";
    //         lrc_SalesFreightCosts: Record "5110744";
    //         lrc_SalesLine: Record "39";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zum Laden der Frachtkosten aus Einkäufen für die Kostenkontrolle
    //         // ---------------------------------------------------------------------------------

    //         vrc_PurchHeader.TESTFIELD("No.");

    //         // Bestehende Einträge ohne Frachtrechnung löschen
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_PurchHeader."No.");
    //         lrc_FreightCostControle.SETRANGE("Freight Inv. Recieved",FALSE);
    //         IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //           lrc_FreightCostControle.DELETEALL();
    //         END;

    //         // Bestehende Einträge Kalk. Frachtkosten zurücksetzen
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_PurchHeader."No.");
    //         IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := 0;
    //             lrc_FreightCostControle.MODIFY();
    //           UNTIL lrc_FreightCostControle.NEXT() = 0;
    //         END;


    //         // Kalkulierte Verkaufsfrachtkosten in Kostenkontrolle übertragen
    //         lrc_SalesFreightCosts.RESET();
    //         lrc_SalesFreightCosts.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //         lrc_SalesFreightCosts.SETRANGE("Doc. No.",vrc_PurchHeader."No.");
    //         lrc_SalesFreightCosts.SETRANGE(Type,lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //         IF lrc_SalesFreightCosts.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Wegen Umstellung auf Abgangsregion als Teil des Schlüssels übergangsweise Prüfung ob es einen Satz ohne Abgangsregion gibt
    //             lrc_FreightCostControle.RESET();
    //             lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //             lrc_FreightCostControle.SETRANGE("Source No.",vrc_PurchHeader."No.");
    //             lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //             lrc_FreightCostControle.SETRANGE("Departure Region Code",lrc_SalesFreightCosts."Departure Region Code");
    //             IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN
    //               lrc_FreightCostControle.RESET();
    //               lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //               lrc_FreightCostControle.SETRANGE("Source No.",vrc_PurchHeader."No.");
    //               lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //               lrc_FreightCostControle.SETRANGE("Departure Region Code",'');
    //               IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //                 lrc_FreightCostControle."Departure Region Code" := lrc_SalesFreightCosts."Departure Region Code";
    //                 lrc_FreightCostControle."Freight Unit Code" := lrc_SalesFreightCosts."Freight Unit Code";
    //         ////        lrc_FreightCostControle."POI Arrival Region Code" := vrc_PurchHeader."POI Arrival Region Code";
    //                 lrc_FreightCostControle."Freight Cost Tariff Base" := lrc_SalesFreightCosts."Freight Cost Tariff Base";
    //                 lrc_FreightCostControle."Shipping Date" := lrc_SalesFreightCosts."Shipment Date";
    //                 lrc_FreightCostControle."Freight Cost Manual" := lrc_SalesFreightCosts."Freight Cost Manual Entered";
    //                 lrc_FreightCostControle."Cust. No." := vrc_PurchHeader."Buy-from Vendor No.";
    //                 lrc_FreightCostControle."Cust. Name" := vrc_PurchHeader."Buy-from Vendor Name";
    //                 lrc_FreightCostControle."Cust. City" := vrc_PurchHeader."Buy-from City";
    //         ////        lrc_FreightCostControle."Cust.Ship-to City" := vrc_PurchHeader."Ship-to City";
    //                 // FRA 006 DMG50000.s
    //                 lrc_FreightCostControle."Document Subtype Code" := vrc_PurchHeader."Purch. Doc. Subtype Code";
    //                 // FRA 006 DMG50000.e
    //                 lrc_FreightCostControle.MODIFY();
    //               END;
    //             END;

    //             lrc_FreightCostControle.RESET();
    //             lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //             lrc_FreightCostControle.SETRANGE("Source No.",vrc_PurchHeader."No.");
    //             lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //             lrc_FreightCostControle.SETRANGE("Departure Region Code",lrc_SalesFreightCosts."Departure Region Code");
    //             IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN

    //               lrc_FreightCostControle.RESET();
    //               lrc_FreightCostControle.INIT();
    //               lrc_FreightCostControle.Source := lrc_FreightCostControle.Source::Purchase;
    //               lrc_FreightCostControle."Source No." := vrc_PurchHeader."No.";
    //               lrc_FreightCostControle.Source := lrc_FreightCostControle.Source::Sales;
    //               // FRA 006 DMG50000.s
    //               lrc_FreightCostControle."Document Subtype Code" := vrc_PurchHeader."Purch. Doc. Subtype Code";
    //               // FRA 006 DMG50000.e

    //               lrc_FreightCostControle."Shipping Agent Code" := lrc_SalesFreightCosts."Shipping Agent Code";
    //               lrc_FreightCostControle."Departure Region Code" := lrc_SalesFreightCosts."Departure Region Code";

    //               lrc_FreightCostControle."Freight Unit Code" := lrc_SalesFreightCosts."Freight Unit Code";
    //         ////      lrc_FreightCostControle."POI Arrival Region Code" := vrc_PurchHeader."POI Arrival Region Code";
    //               lrc_FreightCostControle."Freight Cost Tariff Base" := lrc_SalesFreightCosts."Freight Cost Tariff Base";
    //               lrc_FreightCostControle."No Posting of Difference" := TRUE;

    //               lrc_SalesLine.RESET();
    //               lrc_SalesLine.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //               lrc_SalesLine.SETRANGE("Document No.",vrc_PurchHeader."No.");
    //               lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //               IF lrc_SalesLine.FIND('-') THEN BEGIN
    //                 lrc_FreightCostControle."Item Information" := lrc_SalesLine."No." + ' / ' +
    //                                                               lrc_SalesLine.Description + ' / ' +
    //                                                               lrc_SalesLine."Unit of Measure";
    //               END;

    //               lrc_FreightCostControle.insert();

    //             END;

    //             // Felder aktualisieren und Kalk. Wert aufaddieren
    //             lrc_FreightCostControle."Freight Cost Manual" := lrc_SalesFreightCosts."Freight Cost Manual Entered";
    //             lrc_FreightCostControle."Cust. No." := vrc_PurchHeader."Buy-from Vendor No.";
    //             lrc_FreightCostControle."Cust. Name" := vrc_PurchHeader."Buy-from Vendor Name";
    //             lrc_FreightCostControle."Cust. City" := vrc_PurchHeader."Buy-from City";
    //         ////    lrc_FreightCostControle."Cust.Ship-to City" := vrc_PurchHeader."Ship-to City";
    //         ////    lrc_FreightCostControle."Shipping Date" := vrc_PurchHeader."Shipment Date";
    //         ////    lrc_FreightCostControle."Promised Delivery Date" := vrc_PurchHeader."Promised Delivery Date";
    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := lrc_FreightCostControle."Calc. Freight Cost Amount" +
    //                                                                    lrc_SalesFreightCosts."POI Freight Costs Amount (LCY)";
    //             IF lrc_FreightCostControle."Freight Inv. Recieved" = TRUE THEN BEGIN
    //               lrc_FreightCostControle."Difference Calc. and Inv. Amt." := lrc_FreightCostControle."Freight Inv. Cost Amount" -
    //                                                                           lrc_FreightCostControle."Calc. Freight Cost Amount" -
    //                                                                           lrc_FreightCostControle."Posted Difference Amount";
    //             END ELSE BEGIN
    //               lrc_FreightCostControle."Difference Calc. and Inv. Amt." := 0;
    //             END;

    //             // FRA 006 DMG50000.s
    //             lrc_FreightCostControle."Document Subtype Code" := vrc_PurchHeader."Purch. Doc. Subtype Code";
    //             // FRA 006 DMG50000.e
    //             lrc_FreightCostControle.MODIFY();

    //           UNTIL lrc_SalesFreightCosts.NEXT() = 0;

    //         END;
    //     end;

    //     procedure FreightCostContrSalesLoad(vrc_SalesHeader: Record "36")
    //     var
    //         lrc_FreightCostControle: Record "5087923";
    //         lrc_SalesFreightCosts: Record "5110549";
    //         lrc_SalesLine: Record "37";
    //         lcu_CustomerSpecificFunctions: Codeunit "5110348";
    //         lrc_FruitVisionSetup: Record "5110302";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zum Laden der Frachtkosten aus Verkäufen für die Kostenkontrolle
    //         // ---------------------------------------------------------------------------------

    //         vrc_SalesHeader.TESTFIELD("No.");

    //         // FRA 014 DMG50000.s
    //         IF vrc_SalesHeader."Document Type" = vrc_SalesHeader."Document Type"::Quote THEN BEGIN
    //           EXIT;
    //         END;
    //         // FRA 014 DMG50000.e

    //         // FRA 013 DMG500000.s
    //         lrc_FruitVisionSetup.GET();
    //         // FRA 013 DMG500000.e

    //         // Bestehende Einträge ohne Frachtrechnung löschen
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesHeader."No.");
    //         lrc_FreightCostControle.SETRANGE("Freight Inv. Recieved",FALSE);
    //         IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //           lrc_FreightCostControle.DELETEALL();
    //         END;

    //         // Bestehende Einträge Kalk. Frachtkosten zurücksetzen
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesHeader."No.");
    //         IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := 0;
    //             lrc_FreightCostControle.MODIFY();
    //           UNTIL lrc_FreightCostControle.NEXT() = 0;
    //         END;


    //         // Kalkulierte Verkaufsfrachtkosten in Kostenkontrolle übertragen
    //         lrc_SalesFreightCosts.RESET();
    //         lrc_SalesFreightCosts.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //         lrc_SalesFreightCosts.SETRANGE("Doc. No.",vrc_SalesHeader."No.");
    //         lrc_SalesFreightCosts.SETRANGE(Type,lrc_SalesFreightCosts.Type::"Sped.+AbgReg.+Frachteinheit");
    //         IF lrc_SalesFreightCosts.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Wegen Umstellung auf Abgangsregion als Teil des Schlüssels übergangsweise Prüfung ob es einen Satz ohne Abgangsregion gibt
    //             lrc_FreightCostControle.RESET();
    //             lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //             lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesHeader."No.");
    //             lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //             lrc_FreightCostControle.SETRANGE("Departure Region Code",lrc_SalesFreightCosts."Departure Region Code");
    //             IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN
    //               lrc_FreightCostControle.RESET();
    //               lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //               lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesHeader."No.");
    //               lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //               lrc_FreightCostControle.SETRANGE("Departure Region Code",'');
    //               IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //                 lrc_FreightCostControle."Departure Region Code" := lrc_SalesFreightCosts."Departure Region Code";
    //                 lrc_FreightCostControle."Freight Unit Code" := lrc_SalesFreightCosts."Freight Unit Code";
    //                 lrc_FreightCostControle."POI Arrival Region Code" := vrc_SalesHeader."POI Arrival Region Code";
    //                 lrc_FreightCostControle."Freight Cost Tariff Base" := lrc_SalesFreightCosts."Freight Cost Tariff Base";
    //                 lrc_FreightCostControle."Shipping Date" := lrc_SalesFreightCosts."Shipment Date";
    //                 lrc_FreightCostControle."Freight Cost Manual" := lrc_SalesFreightCosts."Freight Cost Manual Entered";
    //                 lrc_FreightCostControle."Cust. No." := vrc_SalesHeader."Sell-to Customer No.";
    //                 lrc_FreightCostControle."Cust. Name" := vrc_SalesHeader."Sell-to Customer Name";
    //                 lrc_FreightCostControle."Cust. City" := vrc_SalesHeader."Sell-to City";
    //                 lrc_FreightCostControle."Cust.Ship-to City" := vrc_SalesHeader."Ship-to City";

    //                 // FRA 006 DMG50000.s
    //                 lrc_FreightCostControle."Document Subtype Code" := vrc_SalesHeader."Sales Doc. Subtype Code";
    //                 // FRA 006 DMG50000.e

    //                 // FRA 013 DMG50000.s
    //                 IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //                   lrc_FreightCostControle."Main Sales Order No." := lcu_CustomerSpecificFunctions.GetMainOrderNumber(
    //                                                                       vrc_SalesHeader."No.");
    //                 END;
    //                 // FRA 013 DMG50000.e

    //                 lrc_FreightCostControle.MODIFY();
    //               END;
    //             END;

    //             lrc_FreightCostControle.RESET();
    //             lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //             lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesHeader."No.");
    //             lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //             lrc_FreightCostControle.SETRANGE("Departure Region Code",lrc_SalesFreightCosts."Departure Region Code");
    //             IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN

    //               lrc_FreightCostControle.RESET();
    //               lrc_FreightCostControle.INIT();
    //               lrc_FreightCostControle.Source := lrc_FreightCostControle.Source::Sales;
    //               lrc_FreightCostControle."Source No." := vrc_SalesHeader."No.";
    //               lrc_FreightCostControle.Source := lrc_FreightCostControle.Source::Sales;
    //               // FRA 006 DMG50000.s
    //               lrc_FreightCostControle."Document Subtype Code" := vrc_SalesHeader."Sales Doc. Subtype Code";
    //               // FRA 006 DMG50000.e

    //               lrc_FreightCostControle."Shipping Agent Code" := lrc_SalesFreightCosts."Shipping Agent Code";
    //               lrc_FreightCostControle."Departure Region Code" := lrc_SalesFreightCosts."Departure Region Code";

    //               lrc_FreightCostControle."Freight Unit Code" := lrc_SalesFreightCosts."Freight Unit Code";
    //               lrc_FreightCostControle."POI Arrival Region Code" := vrc_SalesHeader."POI Arrival Region Code";
    //               lrc_FreightCostControle."Freight Cost Tariff Base" := lrc_SalesFreightCosts."Freight Cost Tariff Base";
    //               lrc_FreightCostControle."No Posting of Difference" := TRUE;

    //               lrc_SalesLine.RESET();
    //               lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //               lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //               lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //               IF lrc_SalesLine.FIND('-') THEN BEGIN
    //                 lrc_FreightCostControle."Item Information" := lrc_SalesLine."No." + ' / ' +
    //                                                               lrc_SalesLine.Description + ' / ' +
    //                                                               lrc_SalesLine."Unit of Measure";
    //               END;
    //               // FRA 013 DMG50000.s
    //               IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //                 lrc_FreightCostControle."Main Sales Order No." := lcu_CustomerSpecificFunctions.GetMainOrderNumber(
    //                                                                     lrc_SalesLine."Document No.");
    //               END;
    //               // FRA 013 DMG50000.e

    //               lrc_FreightCostControle.insert();

    //             END;

    //             // Felder aktualisieren und Kalk. Wert aufaddieren
    //             lrc_FreightCostControle."Freight Cost Manual" := lrc_SalesFreightCosts."Freight Cost Manual Entered";
    //             lrc_FreightCostControle."Cust. No." := vrc_SalesHeader."Sell-to Customer No.";
    //             lrc_FreightCostControle."Cust. Name" := vrc_SalesHeader."Sell-to Customer Name";
    //             lrc_FreightCostControle."Cust. City" := vrc_SalesHeader."Sell-to City";
    //             lrc_FreightCostControle."Cust.Ship-to City" := vrc_SalesHeader."Ship-to City";
    //             lrc_FreightCostControle."Shipping Date" := vrc_SalesHeader."Shipment Date";
    //             lrc_FreightCostControle."Promised Delivery Date" := vrc_SalesHeader."Promised Delivery Date";
    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := lrc_FreightCostControle."Calc. Freight Cost Amount" +
    //                                                                    lrc_SalesFreightCosts."POI Freight Costs Amount (LCY)";
    //             IF lrc_FreightCostControle."Freight Inv. Recieved" = TRUE THEN BEGIN
    //               lrc_FreightCostControle."Difference Calc. and Inv. Amt." := lrc_FreightCostControle."Freight Inv. Cost Amount" -
    //                                                                           lrc_FreightCostControle."Calc. Freight Cost Amount" -
    //                                                                           lrc_FreightCostControle."Posted Difference Amount";
    //             END ELSE BEGIN
    //               lrc_FreightCostControle."Difference Calc. and Inv. Amt." := 0;
    //             END;

    //             // FRA 017 DMG50000.s
    //         ////    lrc_FreightCostControle."Signed Shipment Recieved" := vrc_SalesHeader."Signed Shipment Recieved";
    //         ////    lrc_FreightCostControle."Signed Shipment Date Recieved" := vrc_SalesHeader."Signed Shipment Date Recieved";
    //             // FRA 017 DMG50000.e

    //             // FRA 006 DMG50000.s
    //             lrc_FreightCostControle."Document Subtype Code" := vrc_SalesHeader."Sales Doc. Subtype Code";
    //             // FRA 006 DMG50000.e
    //             lrc_FreightCostControle.MODIFY();

    //           UNTIL lrc_SalesFreightCosts.NEXT() = 0;

    //         END;
    //     end;

    //     procedure FreightCostContrSalesSetPostNo()
    //     begin
    //     end;

    //     procedure FreightCostContrSaleUpdate(vrc_FreightCostControle: Record "5087923";vbn_Batch: Boolean)
    //     var
    //         lrc_FreightCostControle: Record "5087923";
    //         lrc_FruitVisionTempII: Record "5087936";
    //         lrc_SalesShipmentLine: Record "111";
    //         lrc_TransferShipmentLine: Record "5745";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_ShipAgentDepRegTarif: Record "5110335";
    //         lrc_GeneralLedgerSetup: Record "98";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_PostDocDim: Record "359";
    //         lrc_GenJournalLine: Record "81" temporary;
    //         ldc_DiffFreightCostAmt: Decimal;
    //         ldc_SumPalett: Decimal;
    //         ldc_SumColli: Decimal;
    //         ldc_SumTotalNetWeight: Decimal;
    //         ldc_SumTotalGrossWeight: Decimal;
    //         ldc_PostingAmount: Decimal;
    //         lin_LineNo: Integer;
    //         AGILES_LT_TEXT001: Label 'Dimensionsebene nicht zulässig !';
    //         AGILES_LT_TEXT002: Label 'Calc. Freight Cost';
    //         AGILES_LT_TEXT003: Label 'Frachttariffbasis nicht kodiert %1';
    //         AGILES_LT_TEXT004: Label 'Dimensionsebene nicht zulässig!';
    //         "-- FRA 005 DMG50110 L": Integer;
    //         lrc_DimensionTemp: Record "5087936" temporary;
    //         lin_EntryNo: Integer;
    //         "--- FRA 011 DMG50000": Integer;
    //         lrc_Fruitvisionsetup: Record "5110302";
    //         lrc_BatchVariantEntry: Record "5110368";
    //         lrc_BatchNoTemp: Record "5110365" temporary;
    //         ldc_BVE_Colli: Decimal;
    //         ldc_BVE_Pallets: Decimal;
    //         lrc_SourceCodeSetup: Record "Source Code Setup";
    //         "--- FRA 012 DMG50202": Integer;
    //         lrc_ItemLedgerEntry: Record "32";
    //         ldt_PostingDate: Date;
    //         WeightValue: Decimal;
    //         SumWeightValue: Decimal;
    //         "***POI 001 FRAKORR": Integer;
    //         lrc_PortSetup: Record "50005";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Differenz in Frachtkosten buchen
    //         // ---------------------------------------------------------------------------------

    //         // Prüfung ob eine Differenz gebucht werden soll
    //         IF vrc_FreightCostControle."No Posting of Difference" = TRUE THEN
    //           EXIT;

    //         // Prüfung ob eine Differenz vorhanden ist
    //         IF ((vrc_FreightCostControle."Calc. Freight Cost Amount" +
    //              vrc_FreightCostControle."Posted Difference Amount") -
    //             vrc_FreightCostControle."Freight Inv. Cost Amount") = 0 THEN
    //           EXIT;

    //         // Frachtkostenkontrollsatz lesen
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETRANGE(Source,vrc_FreightCostControle.Source);
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_FreightCostControle."Source No.");
    //         lrc_FreightCostControle.SETRANGE("Shipping Agent Code",vrc_FreightCostControle."Shipping Agent Code");
    //         lrc_FreightCostControle.SETRANGE("Departure Region Code",vrc_FreightCostControle."Departure Region Code");
    //         lrc_FreightCostControle.FINDFIRST;

    //         //RS+  141218 ldt_Postingdate mit Posting date aus Frachtkostentabelle verwenden
    //         //mly+ 141103
    //         // geändert RS ldt_PostingDate := lrc_FreightCostControle."Promised Delivery Date";
    //         //orig - ldt_PostingDate := lrc_FreightCostControle."Freight Inv. Date Recieved";
    //         ldt_PostingDate := lrc_FreightCostControle."Posting Date";
    //         //mly-
    //         //RS-

    //         // Temp Tabelle löschen
    //         lrc_FruitVisionTempII.RESET();
    //         lrc_FruitVisionTempII.SETRANGE("User ID",UserID());
    //         lrc_FruitVisionTempII.SETRANGE("Entry Type",lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost");
    //         lrc_FruitVisionTempII.DELETEALL();

    //         ldc_SumPalett := 0;
    //         ldc_SumColli := 0;

    //         // PORT.s
    //         ldc_SumTotalNetWeight := 0;
    //         ldc_SumTotalGrossWeight := 0;
    //         // PORT.e

    //         // FRA 005 DMG50110.s
    //         lrc_GeneralLedgerSetup.GET();
    //         lin_EntryNo := 0;
    //         // FRA 005 DMG50110.e

    //         // FRA 011 DMG50000.s
    //         lrc_Fruitvisionsetup.GET();
    //         // FRA 011 DMG50000.e

    //         CASE lrc_FreightCostControle.Source OF
    //         lrc_FreightCostControle.Source::Sales :
    //           BEGIN

    //             // Alle gelieferten Positionen ermitteln
    //             lrc_SalesShipmentLine.RESET();
    //             lrc_SalesShipmentLine.SETCURRENTKEY("Order No.","Order Line No.","Posting Date");
    //             lrc_SalesShipmentLine.SETRANGE("Order No.",lrc_FreightCostControle."Source No.");
    //             lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
    //             lrc_SalesShipmentLine.SETFILTER("No.",'<>%1','');
    //             lrc_SalesShipmentLine.SETRANGE("Shipping Agent Code",lrc_FreightCostControle."Shipping Agent Code");
    //             IF lrc_SalesShipmentLine.FIND('-') THEN BEGIN
    //               REPEAT

    //                 // FRA 011 DMG50000.s
    //                 IF lrc_Fruitvisionsetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
    //                   // erst Einträge in TEMP Tabelle generieren

    //                   lrc_BatchNoTemp.DELETEALL();

    //                   lrc_BatchVariantEntry.RESET();
    //                   lrc_BatchVariantEntry.SETCURRENTKEY("Document No.","Document Line No.");
    //                   lrc_BatchVariantEntry.SETRANGE("Document No.", lrc_SalesShipmentLine."Document No.");
    //                   lrc_BatchVariantEntry.SETRANGE("Document Line No.", lrc_SalesShipmentLine."Line No.");
    //                   IF lrc_BatchVariantEntry.FIND('-') THEN BEGIN
    //                      REPEAT
    //                        lrc_BatchNoTemp.INIT();
    //                        lrc_BatchNoTemp."No." := lrc_BatchVariantEntry."Batch No.";
    //                        IF ABS(lrc_SalesShipmentLine."Quantity (Base)") = ABS(lrc_BatchVariantEntry."Quantity (Base)") THEN BEGIN
    //                          lrc_BatchNoTemp."Net Weight" := lrc_SalesShipmentLine.Quantity;
    //                        END ELSE BEGIN
    //                          lrc_BatchNoTemp."Net Weight" := ROUND( ABS(lrc_BatchVariantEntry."Quantity (Base)") /
    //                                                                      lrc_BatchVariantEntry."Qty. per Unit of Measure", 0.000001);
    //                        END;
    //                        lrc_BatchNoTemp.INSERT( TRUE);
    //                      UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //                   END;

    //                   lrc_BatchNoTemp.RESET();
    //                   IF lrc_BatchNoTemp.COUNT() = 0 THEN BEGIN
    //                     lrc_BatchNoTemp.INIT();
    //                     lrc_BatchNoTemp."No." := lrc_SalesShipmentLine."Batch No.";
    //                     lrc_BatchNoTemp."Net Weight" := lrc_SalesShipmentLine.Quantity;
    //                     lrc_BatchNoTemp.INSERT( TRUE);
    //                   END;

    //                   lrc_BatchNoTemp.RESET();
    //                   IF lrc_BatchNoTemp.FIND('-') THEN BEGIN
    //                     REPEAT

    //                       lrc_FruitVisionTempII.RESET();
    //                       lrc_FruitVisionTempII.SETRANGE("User ID",UserID());
    //                       lrc_FruitVisionTempII.SETRANGE("Entry Type",lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost");
    //                       lrc_FruitVisionTempII.SETRANGE("FC Batch No.", lrc_BatchNoTemp."No.");
    //                       IF NOT lrc_FruitVisionTempII.FIND('-') THEN BEGIN
    //                         lrc_FruitVisionTempII.RESET();
    //                         lrc_FruitVisionTempII.INIT();
    //                         lrc_FruitVisionTempII."User ID" := USERID;
    //                         lrc_FruitVisionTempII."Entry Type" := lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost";
    //                         lrc_FruitVisionTempII."Entry No." := 0;
    //                         lrc_FruitVisionTempII."FC Batch No." := lrc_BatchNoTemp."No.";
    //                         lrc_FruitVisionTempII.INSERT(TRUE);
    //                       END;

    //                       IF ABS(lrc_SalesShipmentLine."Quantity (Base)") = lrc_BatchNoTemp."Net Weight" THEN BEGIN

    //                         ldc_BVE_Colli := lrc_SalesShipmentLine.Quantity;
    //                         ldc_BVE_Pallets := lrc_SalesShipmentLine."Quantity (TU)";

    //                       END ELSE BEGIN

    //                         // im Feld Nettogewicht, wurde die Menge zwischengespeichert
    //                         ldc_BVE_Colli := lrc_BatchNoTemp."Net Weight";

    //                         ldc_BVE_Pallets := lrc_SalesShipmentLine."Quantity (TU)";
    //                         ldc_BVE_Pallets := ROUND((ldc_BVE_Pallets / lrc_SalesShipmentLine.Quantity) * ldc_BVE_Colli, 0.00001);

    //                       END;

    //                       lrc_FruitVisionTempII."FC Qty. Pallets" := lrc_FruitVisionTempII."FC Qty. Pallets" + ldc_BVE_Pallets;
    //                       lrc_FruitVisionTempII."FC Qty. Colli" := lrc_FruitVisionTempII."FC Qty. Colli" + ldc_BVE_Colli;
    //                       lrc_FruitVisionTempII.MODIFY();

    //                       ldc_SumPalett := ldc_SumPalett + ldc_BVE_Pallets;
    //                       ldc_SumColli := ldc_SumColli + ldc_BVE_Colli;

    //                       // FRA 005 DMG50110.s
    //                       // Dimensionen bezogen auf die Positionsnr. abspeichern
    //                       // "BB Master Batch No." = Dimensionsnr.
    //                       // "BB Batch No."        = Dimensionswert

    //                       IF lrc_GeneralLedgerSetup."Shortcut Dimension 1 Code" <> '' THEN BEGIN
    //                         lrc_PostDocDim.RESET();
    //                         lrc_PostDocDim.SETRANGE("Table ID",111);
    //                         lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                         lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                         lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 1 Code");
    //                         IF lrc_PostDocDim.FIND('-') THEN BEGIN
    //                           lrc_DimensionTemp.RESET();
    //                           lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                           lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                           lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_BatchNoTemp."No.");
    //                           lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'1');
    //                           lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                           IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                             lrc_DimensionTemp.INIT();
    //                             lrc_DimensionTemp."User ID" := USERID;
    //                             lin_EntryNo := lin_EntryNo + 1;
    //                             lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                             lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                             lrc_DimensionTemp."FC Batch No." := lrc_BatchNoTemp."No.";
    //                             lrc_DimensionTemp."BB Master Batch No." := '1';
    //                             lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                             lrc_DimensionTemp.insert();
    //                           END;

    //                         END;
    //                       END;

    //                       IF lrc_GeneralLedgerSetup."Shortcut Dimension 2 Code" <> '' THEN BEGIN
    //                         lrc_PostDocDim.RESET();
    //                         lrc_PostDocDim.SETRANGE("Table ID",111);
    //                         lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                         lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                         lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 2 Code");
    //                         IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                           lrc_DimensionTemp.RESET();
    //                           lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                           lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                           lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_BatchNoTemp."No.");
    //                           lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'2');
    //                           lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                           IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                             lrc_DimensionTemp.INIT();
    //                             lrc_DimensionTemp."User ID" := USERID;
    //                             lin_EntryNo := lin_EntryNo + 1;
    //                             lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                             lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                             lrc_DimensionTemp."FC Batch No." := lrc_BatchNoTemp."No.";
    //                             lrc_DimensionTemp."BB Master Batch No." := '2';
    //                             lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                             lrc_DimensionTemp.insert();
    //                           END;

    //                         END;
    //                       END;

    //                       IF lrc_GeneralLedgerSetup."Shortcut Dimension 3 Code" <> '' THEN BEGIN
    //                         lrc_PostDocDim.RESET();
    //                         lrc_PostDocDim.SETRANGE("Table ID",111);
    //                         lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                         lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                         lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 3 Code");
    //                         IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                           lrc_DimensionTemp.RESET();
    //                           lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                           lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                           lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_BatchNoTemp."No.");
    //                           lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'3');
    //                           lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                           IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                             lrc_DimensionTemp.INIT();
    //                             lrc_DimensionTemp."User ID" := USERID;
    //                             lin_EntryNo := lin_EntryNo + 1;
    //                             lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                             lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                             lrc_DimensionTemp."FC Batch No." := lrc_BatchNoTemp."No.";
    //                             lrc_DimensionTemp."BB Master Batch No." := '3';
    //                             lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                             lrc_DimensionTemp.insert();
    //                           END;

    //                         END;
    //                       END;

    //                       IF lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code" <> '' THEN BEGIN
    //                         lrc_PostDocDim.RESET();
    //                         lrc_PostDocDim.SETRANGE("Table ID",111);
    //                         lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                         lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                         lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code");
    //                         IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                           lrc_DimensionTemp.RESET();
    //                           lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                           lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                           lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_BatchNoTemp."No.");
    //                           lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'4');
    //                           lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                           IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                             lrc_DimensionTemp.INIT();
    //                             lrc_DimensionTemp."User ID" := USERID;
    //                             lin_EntryNo := lin_EntryNo + 1;
    //                             lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                             lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                             lrc_DimensionTemp."FC Batch No." := lrc_BatchNoTemp."No.";
    //                             lrc_DimensionTemp."BB Master Batch No." := '4';
    //                             lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                             lrc_DimensionTemp.insert();
    //                           END;

    //                         END ELSE BEGIN
    //                           //POI 001 FRAKORR  JST 120613 002 geb.Belegdimension mit Dimension 4 Kosten(Tbl359 Belegnr.= lieferung vorhanden ?
    //                           //1.Nachtrag in die Tbl 359
    //                                             //POI 002 FRAKORR  JST 150713 002 Frachtkostenkorrektur per Port Setup II Tabelle
    //                           lrc_PortSetup.GET();

    //                           lrc_PostDocDim."Table ID":=111;
    //                           lrc_PostDocDim."Document No.":=lrc_SalesShipmentLine."Document No.";
    //                           lrc_PostDocDim."Line No.":=lrc_SalesShipmentLine."Line No.";
    //                           lrc_PostDocDim."Dimension Code":=lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code";
    //                             //POI 002 FRAKORR  JST 150713 002 Frachtkostenkorrektur per Port Setup II Tabelle
    //                           lrc_PostDocDim."Dimension Value Code":=lrc_PortSetup."Freight-Korr Cost Category";
    //                           lrc_PostDocDim.insert();
    //                           lrc_PostDocDim.RESET();
    //                           lrc_PostDocDim.SETRANGE("Table ID",111);
    //                           lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                           lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                           lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code");
    //                           lrc_PostDocDim.FIND('-');
    //                           //2.Dimension=Kosten zum Buchen freigeben
    //                           lrc_DimensionTemp.RESET();
    //                           lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                           lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                           lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                           lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'4');
    //                           lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                           IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                            lrc_DimensionTemp.INIT();
    //                             lrc_DimensionTemp."User ID" := USERID;
    //                             lin_EntryNo := lin_EntryNo + 1;
    //                             lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                             lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                             lrc_DimensionTemp."FC Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                             lrc_DimensionTemp."BB Master Batch No." := '4';
    //                             lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                             lrc_DimensionTemp.insert();
    //                           END;
    //                         END;
    //                         //POI 001 FRAKORR  JST 120613 002 geb.Belegdimension mit Dimension 4 Kosten(Tbl359 Belegnr.= lieferung vorhanden ?


    //                       END;
    //                       // FRA 005 DMG50110.e
    //                     UNTIL lrc_BatchNoTemp.NEXT() = 0;
    //                   END;

    //                 END ELSE BEGIN
    //                 // FRA 011 DMG50000.e

    //                   lrc_FruitVisionTempII.RESET();
    //                   lrc_FruitVisionTempII.SETRANGE("User ID",UserID());
    //                   lrc_FruitVisionTempII.SETRANGE("Entry Type",lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost");
    //                   lrc_FruitVisionTempII.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                   IF NOT lrc_FruitVisionTempII.FIND('-') THEN BEGIN
    //                     lrc_FruitVisionTempII.RESET();
    //                     lrc_FruitVisionTempII.INIT();
    //                     lrc_FruitVisionTempII."User ID" := USERID;
    //                     lrc_FruitVisionTempII."Entry Type" := lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost";
    //                     lrc_FruitVisionTempII."Entry No." := 0;
    //                     lrc_FruitVisionTempII."FC Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                     lrc_FruitVisionTempII.INSERT(TRUE);
    //                   END;

    //                   lrc_FruitVisionTempII."FC Qty. Pallets" := lrc_FruitVisionTempII."FC Qty. Pallets"+lrc_SalesShipmentLine."Quantity (TU)";
    //                   lrc_FruitVisionTempII."FC Qty. Colli" := lrc_FruitVisionTempII."FC Qty. Colli" + lrc_SalesShipmentLine.Quantity;

    //                   // PORT.s
    //                   lrc_FruitVisionTempII."FC Total Net Weight" := lrc_FruitVisionTempII."FC Total Net Weight" +
    //                                                                  lrc_SalesShipmentLine."Total Net Weight";
    //                   lrc_FruitVisionTempII."FC Total Gross Weight" := lrc_FruitVisionTempII."FC Total Gross Weight" +
    //                                                                    lrc_SalesShipmentLine."Total Gross Weight";
    //                   // PORT.e

    //                   lrc_FruitVisionTempII.MODIFY();

    //                   ldc_SumPalett := ldc_SumPalett + lrc_SalesShipmentLine."Quantity (TU)";
    //                   ldc_SumColli := ldc_SumColli + lrc_SalesShipmentLine.Quantity;

    //                   // PORT.s
    //                   ldc_SumTotalNetWeight := ldc_SumTotalNetWeight + lrc_SalesShipmentLine."Total Net Weight";
    //                   ldc_SumTotalGrossWeight := ldc_SumTotalGrossWeight + lrc_SalesShipmentLine."Total Gross Weight";
    //                   // PORT.e

    //                   // FRA 005 DMG50110.s
    //                   // Dimensionen bezogen auf die Positionsnr. abspeichern
    //                   // "BB Master Batch No." = Dimensionsnr.
    //                   // "BB Batch No."        = Dimensionswert

    //                   IF lrc_GeneralLedgerSetup."Shortcut Dimension 1 Code" <> '' THEN BEGIN
    //                     lrc_PostDocDim.RESET();
    //                     lrc_PostDocDim.SETRANGE("Table ID",111);
    //                     lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                     lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                     lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 1 Code");
    //                     IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                       lrc_DimensionTemp.RESET();
    //                       lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                       lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                       lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                       lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'1');
    //                       lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                       IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                         lrc_DimensionTemp.INIT();
    //                         lrc_DimensionTemp."User ID" := USERID;
    //                         lin_EntryNo := lin_EntryNo + 1;
    //                         lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                         lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                         lrc_DimensionTemp."FC Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                         lrc_DimensionTemp."BB Master Batch No." := '1';
    //                         lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                         lrc_DimensionTemp.insert();
    //                       END;

    //                     END;
    //                   END;

    //                   IF lrc_GeneralLedgerSetup."Shortcut Dimension 2 Code" <> '' THEN BEGIN
    //                     lrc_PostDocDim.RESET();
    //                     lrc_PostDocDim.SETRANGE("Table ID",111);
    //                     lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                     lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                     lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 2 Code");
    //                     IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                       lrc_DimensionTemp.RESET();
    //                       lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                       lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                       lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                       lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'2');
    //                       lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                       IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                         lrc_DimensionTemp.INIT();
    //                         lrc_DimensionTemp."User ID" := USERID;
    //                         lin_EntryNo := lin_EntryNo + 1;
    //                         lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                         lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                         lrc_DimensionTemp."FC Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                         lrc_DimensionTemp."BB Master Batch No." := '2';
    //                         lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                         lrc_DimensionTemp.insert();
    //                       END;

    //                     END;
    //                   END;

    //                   IF lrc_GeneralLedgerSetup."Shortcut Dimension 3 Code" <> '' THEN BEGIN
    //                     lrc_PostDocDim.RESET();
    //                     lrc_PostDocDim.SETRANGE("Table ID",111);
    //                     lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                     lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                     lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 3 Code");
    //                     IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                       lrc_DimensionTemp.RESET();
    //                       lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                       lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                       lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                       lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'3');
    //                       lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                       IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                         lrc_DimensionTemp.INIT();
    //                         lrc_DimensionTemp."User ID" := USERID;
    //                         lin_EntryNo := lin_EntryNo + 1;
    //                         lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                         lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                         lrc_DimensionTemp."FC Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                         lrc_DimensionTemp."BB Master Batch No." := '3';
    //                         lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                         lrc_DimensionTemp.insert();
    //                       END;

    //                     END;
    //                   END;

    //                   IF lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code" <> '' THEN BEGIN
    //                     lrc_PostDocDim.RESET();
    //                     lrc_PostDocDim.SETRANGE("Table ID",111);
    //                     lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                     lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                     lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code");
    //                     IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                       lrc_DimensionTemp.RESET();
    //                       lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                       lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                       lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                       lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'4');
    //                       lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                       IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                         lrc_DimensionTemp.INIT();
    //                         lrc_DimensionTemp."User ID" := USERID;
    //                         lin_EntryNo := lin_EntryNo + 1;
    //                         lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                         lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                         lrc_DimensionTemp."FC Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                         lrc_DimensionTemp."BB Master Batch No." := '4';
    //                         lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                         lrc_DimensionTemp.insert();
    //                       END;

    //                     END ELSE BEGIN
    //                         //POI 001 FRAKORR  JST 120613 002 geb.Belegdimension mit Dimension 4 Kosten(Tbl359 Belegnr.= lieferung vorhanden ?
    //                         //1.Nachtrag in die Tbl 359
    //                         lrc_PortSetup.GET();
    //                         lrc_PostDocDim."Table ID":=111;
    //                         lrc_PostDocDim."Document No.":=lrc_SalesShipmentLine."Document No.";
    //                         lrc_PostDocDim."Line No.":=lrc_SalesShipmentLine."Line No.";
    //                         lrc_PostDocDim."Dimension Code":=lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code";
    //                           //POI 002 FRAKORR  JST 150713 002 Frachtkostenkorrektur per Port Setup II Tabelle
    //                         lrc_PostDocDim."Dimension Value Code":=lrc_PortSetup."Freight-Korr Cost Category";
    //                         lrc_PostDocDim.insert();
    //                         lrc_PostDocDim.RESET();
    //                         lrc_PostDocDim.SETRANGE("Table ID",111);
    //                         lrc_PostDocDim.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                         lrc_PostDocDim.SETRANGE("Line No.",lrc_SalesShipmentLine."Line No.");
    //                         lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code");
    //                         lrc_PostDocDim.FIND('-');
    //                         //2.Dimension=Kosten zum Buchen freigeben
    //                         lrc_DimensionTemp.RESET();
    //                         lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                         lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                         lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                         lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'4');
    //                         lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                         IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                           lrc_DimensionTemp.INIT();
    //                           lrc_DimensionTemp."User ID" := USERID;
    //                           lin_EntryNo := lin_EntryNo + 1;
    //                           lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                           lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                           lrc_DimensionTemp."FC Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                           lrc_DimensionTemp."BB Master Batch No." := '4';
    //                           lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                           lrc_DimensionTemp.insert();
    //                         END;
    //                       END;
    //                       //POI 001 FRAKORR  JST 120613 002 geb.Belegdimension mit Dimension 4 Kosten(Tbl359 Belegnr.= lieferung vorhanden ?

    //                   END;
    //                   // FRA 005 DMG50110.e
    //                 // FRA 011 DMG50000.s
    //                 END;
    //                 // FRA 011 DMG50000.e

    //               UNTIL lrc_SalesShipmentLine.NEXT() = 0;
    //             END ELSE BEGIN

    //         //TEST FRACHT AUS GUTSCHRIFT/REKLMATION---------Differnezbuchung----------------------------------------------------------
    //         //TEST FRACHT AUS GUTSCHRIFT/REKLMATION---------Differnezbuchung----------------------------------------------------------

    //               IF vbn_Batch = FALSE THEN BEGIN
    //                 ERROR('Es sind keine gebuchten Lieferzeilen vorhanden! Bitte Fracht im Verkaufsbeleg ändern!');
    //               END ELSE BEGIN
    //                 EXIT;
    //               END;
    //             END;

    //           END;

    //         lrc_FreightCostControle.Source::Transfer :
    //           BEGIN

    //             lrc_TransferShipmentLine.RESET();
    //             lrc_TransferShipmentLine.SETRANGE("Transfer Order No.",lrc_FreightCostControle."Source No.");
    //             lrc_TransferShipmentLine.SETFILTER("Item No.",'<>%1','');
    //             IF lrc_TransferShipmentLine.FIND('-') THEN BEGIN
    //               REPEAT

    //                 lrc_FruitVisionTempII.RESET();
    //                 lrc_FruitVisionTempII.SETRANGE("User ID",UserID());
    //                 lrc_FruitVisionTempII.SETRANGE("Entry Type",lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost");
    //                 lrc_FruitVisionTempII.SETRANGE("FC Batch No.",lrc_TransferShipmentLine."Batch No.");
    //                 IF NOT lrc_FruitVisionTempII.FIND('-') THEN BEGIN
    //                   lrc_FruitVisionTempII.RESET();
    //                   lrc_FruitVisionTempII.INIT();
    //                   lrc_FruitVisionTempII."User ID" := USERID;
    //                   lrc_FruitVisionTempII."Entry Type" := lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost";
    //                   lrc_FruitVisionTempII."Entry No." := 0;
    //                   lrc_FruitVisionTempII."FC Batch No." := lrc_TransferShipmentLine."Batch No.";
    //                   lrc_FruitVisionTempII.INSERT(TRUE);
    //                 END;

    //                 lrc_FruitVisionTempII."FC Qty. Pallets" := lrc_FruitVisionTempII."FC Qty. Pallets" +
    //                                                            lrc_TransferShipmentLine."Quantity (TU)";
    //                 lrc_FruitVisionTempII."FC Qty. Colli" := lrc_FruitVisionTempII."FC Qty. Colli" +
    //                                                          lrc_TransferShipmentLine.Quantity;

    //                 // PORT.s
    //                 lrc_FruitVisionTempII."FC Total Net Weight" := lrc_FruitVisionTempII."FC Total Net Weight" +
    //                                                                lrc_TransferShipmentLine."Total Net Weight";
    //                 lrc_FruitVisionTempII."FC Total Gross Weight" := lrc_FruitVisionTempII."FC Total Gross Weight" +
    //                                                                  lrc_TransferShipmentLine."Total Gross Weight";
    //                 // PORT.e

    //                 lrc_FruitVisionTempII.MODIFY();

    //                 ldc_SumPalett := ldc_SumPalett + lrc_TransferShipmentLine."Quantity (TU)";
    //                 ldc_SumColli := ldc_SumColli + lrc_TransferShipmentLine.Quantity;

    //                 // PORT.s
    //                 ldc_SumTotalNetWeight := ldc_SumTotalNetWeight + lrc_TransferShipmentLine."Total Net Weight";
    //                 ldc_SumTotalGrossWeight := ldc_SumTotalGrossWeight + lrc_TransferShipmentLine."Total Gross Weight";
    //                 // PORT.e

    //                 // FRA 005 DMG50110.s
    //                 // Dimensionen bezogen auf die Positionsnr. abspeichern
    //                 // "BB Master Batch No." = Dimensionsnr.
    //                 // "BB Batch No."        = Dimensionswert

    //                 IF lrc_GeneralLedgerSetup."Shortcut Dimension 1 Code" <> '' THEN BEGIN
    //                   lrc_PostDocDim.RESET();
    //                   lrc_PostDocDim.SETRANGE("Table ID",5745);
    //                   lrc_PostDocDim.SETRANGE("Document No.",lrc_TransferShipmentLine."Document No.");
    //                   lrc_PostDocDim.SETRANGE("Line No.",lrc_TransferShipmentLine."Line No.");
    //                   lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 1 Code");
    //                   IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                     lrc_DimensionTemp.RESET();
    //                     lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                     lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                     lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_TransferShipmentLine."Batch No.");
    //                     lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'1');
    //                     lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                     IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                       lrc_DimensionTemp.INIT();
    //                       lrc_DimensionTemp."User ID" := USERID;
    //                       lin_EntryNo := lin_EntryNo + 1;
    //                       lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                       lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                       lrc_DimensionTemp."FC Batch No." := lrc_TransferShipmentLine."Batch No.";
    //                       lrc_DimensionTemp."BB Master Batch No." := '1';
    //                       lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                       lrc_DimensionTemp.insert();
    //                     END;

    //                   END;
    //                 END;

    //                 IF lrc_GeneralLedgerSetup."Shortcut Dimension 2 Code" <> '' THEN BEGIN
    //                   lrc_PostDocDim.RESET();
    //                   lrc_PostDocDim.SETRANGE("Table ID",5745);
    //                   lrc_PostDocDim.SETRANGE("Document No.",lrc_TransferShipmentLine."Document No.");
    //                   lrc_PostDocDim.SETRANGE("Line No.",lrc_TransferShipmentLine."Line No.");
    //                   lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 2 Code");
    //                   IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                     lrc_DimensionTemp.RESET();
    //                     lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                     lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                     lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_TransferShipmentLine."Batch No.");
    //                     lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'2');
    //                     lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                     IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                       lrc_DimensionTemp.INIT();
    //                       lrc_DimensionTemp."User ID" := USERID;
    //                       lin_EntryNo := lin_EntryNo + 1;
    //                       lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                       lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                       lrc_DimensionTemp."FC Batch No." := lrc_TransferShipmentLine."Batch No.";
    //                       lrc_DimensionTemp."BB Master Batch No." := '2';
    //                       lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                       lrc_DimensionTemp.insert();
    //                     END;

    //                   END;
    //                 END;

    //                 IF lrc_GeneralLedgerSetup."Shortcut Dimension 3 Code" <> '' THEN BEGIN
    //                   lrc_PostDocDim.RESET();
    //                   lrc_PostDocDim.SETRANGE("Table ID",5745);
    //                   lrc_PostDocDim.SETRANGE("Document No.",lrc_TransferShipmentLine."Document No.");
    //                   lrc_PostDocDim.SETRANGE("Line No.",lrc_TransferShipmentLine."Line No.");
    //                   lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 3 Code");
    //                   IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                     lrc_DimensionTemp.RESET();
    //                     lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                     lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                     lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_TransferShipmentLine."Batch No.");
    //                     lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'3');
    //                     lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                     IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                       lrc_DimensionTemp.INIT();
    //                       lrc_DimensionTemp."User ID" := USERID;
    //                       lin_EntryNo := lin_EntryNo + 1;
    //                       lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                       lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                       lrc_DimensionTemp."FC Batch No." := lrc_TransferShipmentLine."Batch No.";
    //                       lrc_DimensionTemp."BB Master Batch No." := '3';
    //                       lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                       lrc_DimensionTemp.insert();
    //                     END;

    //                   END;
    //                 END;

    //                 IF lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code" <> '' THEN BEGIN
    //                   lrc_PostDocDim.RESET();
    //                   lrc_PostDocDim.SETRANGE("Table ID",5745);
    //                   lrc_PostDocDim.SETRANGE("Document No.",lrc_TransferShipmentLine."Document No.");
    //                   lrc_PostDocDim.SETRANGE("Line No.",lrc_TransferShipmentLine."Line No.");
    //                   lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code");
    //                   IF lrc_PostDocDim.FIND('-') THEN BEGIN

    //                     lrc_DimensionTemp.RESET();
    //                     lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                     lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                     lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_TransferShipmentLine."Batch No.");
    //                     lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'4');
    //                     lrc_DimensionTemp.SETRANGE("BB Batch No.",lrc_PostDocDim."Dimension Value Code");
    //                     IF NOT lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                       lrc_DimensionTemp.INIT();
    //                       lrc_DimensionTemp."User ID" := USERID;
    //                       lin_EntryNo := lin_EntryNo + 1;
    //                       lrc_DimensionTemp."Entry No." := lin_EntryNo;
    //                       lrc_DimensionTemp."Entry Type" := lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost";
    //                       lrc_DimensionTemp."FC Batch No." := lrc_TransferShipmentLine."Batch No.";
    //                       lrc_DimensionTemp."BB Master Batch No." := '4';
    //                       lrc_DimensionTemp."BB Batch No." := lrc_PostDocDim."Dimension Value Code";
    //                       lrc_DimensionTemp.insert();
    //                     END;

    //                   END;
    //                 END;
    //                 // FRA 005 DMG50110.e
    //               UNTIL lrc_TransferShipmentLine.NEXT() = 0;
    //             END ELSE BEGIN
    //               IF vbn_Batch = FALSE THEN BEGIN
    //                 ERROR('Es sind keine gebuchten Umlagerungszeilen vorhanden! Bitte Fracht im Umlagerungsbeleg ändern!');
    //               END ELSE BEGIN
    //                 EXIT;
    //               END;
    //             END;

    //           END;

    //         lrc_FreightCostControle.Source::"Freight Order" :
    //           BEGIN
    //             EXIT;
    //           END;

    //         END;

    //         // PORT.s
    //         // IF (ldc_SumPalett = 0) AND (ldc_SumColli = 0) THEN BEGIN
    //         IF (ldc_SumPalett = 0) AND (ldc_SumColli = 0) AND (ldc_SumTotalNetWeight = 0) AND (ldc_SumTotalGrossWeight = 0) THEN BEGIN
    //         // PORT.e
    //           IF vbn_Batch = FALSE THEN BEGIN
    //             ERROR('Keine Mengen vorhanden!');
    //           END ELSE BEGIN
    //             EXIT;
    //           END;
    //         END;

    //         // Differenzbetrag berechnen
    //         ldc_DiffFreightCostAmt := lrc_FreightCostControle."Freight Inv. Cost Amount" -
    //                                   lrc_FreightCostControle."Calc. Freight Cost Amount" -
    //                                   lrc_FreightCostControle."Posted Difference Amount";

    //         // PORT.s
    //         lrc_ShippingAgent.GET(lrc_FreightCostControle."Shipping Agent Code");
    //         // PORT.e

    //         // Differenzbetrag auf die einzelnen Positionen verteilen
    //         lrc_FruitVisionTempII.RESET();
    //         lrc_FruitVisionTempII.SETRANGE("User ID",UserID());
    //         lrc_FruitVisionTempII.SETRANGE("Entry Type",lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost");
    //         IF lrc_FruitVisionTempII.FIND('-') THEN BEGIN
    //           REPEAT

    //             ldc_PostingAmount := 0;
    //             // Betrag auf die Positionen verteilen
    //             CASE lrc_FreightCostControle."Freight Cost Tariff Base" OF
    //             lrc_FreightCostControle."Freight Cost Tariff Base"::Collo:
    //               BEGIN
    //                 IF (ldc_SumColli * lrc_FruitVisionTempII."FC Qty. Colli") <> 0 THEN
    //                   ldc_PostingAmount := ROUND(ldc_DiffFreightCostAmt / ldc_SumColli * lrc_FruitVisionTempII."FC Qty. Colli",0.01);

    //                 lrc_FruitVisionTempII."FC Posting Amount" := ldc_PostingAmount;
    //                 lrc_FruitVisionTempII.MODIFY();

    //               END;
    //             lrc_FreightCostControle."Freight Cost Tariff Base"::Pallet:
    //               BEGIN
    //                 IF (ldc_SumPalett * lrc_FruitVisionTempII."FC Qty. Pallets") <> 0 THEN
    //                   ldc_PostingAmount := ROUND(ldc_DiffFreightCostAmt / ldc_SumPalett * lrc_FruitVisionTempII."FC Qty. Pallets",0.01);

    //                 lrc_FruitVisionTempII."FC Posting Amount" := ldc_PostingAmount;
    //                 lrc_FruitVisionTempII.MODIFY();

    //               END;
    //             lrc_FreightCostControle."Freight Cost Tariff Base"::Weight:
    //               BEGIN
    //                 // PORT.s
    //                 // ERROR(AGILES_LT_TEXT003, FORMAT(lrc_FreightCostControle."Freight Cost Tariff Base"));
    //                 WeightValue := 0;
    //                 SumWeightValue := 0;
    //                 CASE lrc_ShippingAgent."POI Freight Cost Ref. Weight" OF
    //                   lrc_ShippingAgent."POI Freight Cost Ref. Weight"::"Net Weight":
    //                     BEGIN
    //                       WeightValue := lrc_FruitVisionTempII."FC Total Net Weight";
    //                       SumWeightValue := ldc_SumTotalNetWeight;
    //                     END;
    //                   lrc_ShippingAgent."POI Freight Cost Ref. Weight"::"Gross Weight":
    //                     BEGIN
    //                       WeightValue := lrc_FruitVisionTempII."FC Total Gross Weight";
    //                       SumWeightValue := ldc_SumTotalGrossWeight;
    //                     END;
    //                 ELSE
    //                   lrc_ShippingAgent.TESTFIELD("POI Freight Cost Ref. Weight");
    //                 END;

    //                 IF (SumWeightValue * WeightValue) <> 0 THEN
    //                   ldc_PostingAmount := ROUND(ldc_DiffFreightCostAmt / SumWeightValue * WeightValue,0.01);

    //                 lrc_FruitVisionTempII."FC Posting Amount" := ldc_PostingAmount;
    //                 lrc_FruitVisionTempII.MODIFY();
    //                 // PORT.e
    //               END;
    //             lrc_FreightCostControle."Freight Cost Tariff Base"::"Pallet Type":
    //               BEGIN
    //                 IF (ldc_SumPalett * lrc_FruitVisionTempII."FC Qty. Pallets") <> 0 THEN
    //                   ldc_PostingAmount := ROUND(ldc_DiffFreightCostAmt / ldc_SumPalett * lrc_FruitVisionTempII."FC Qty. Pallets",0.01);

    //                 lrc_FruitVisionTempII."FC Posting Amount" := ldc_PostingAmount;
    //                 lrc_FruitVisionTempII.MODIFY();

    //               END;
    //             lrc_FreightCostControle."Freight Cost Tariff Base"::"Collo Weight":
    //               BEGIN
    //                 ERROR(AGILES_LT_TEXT003, FORMAT(lrc_FreightCostControle."Freight Cost Tariff Base"));
    //               END;
    //             lrc_FreightCostControle."Freight Cost Tariff Base"::"from Position":
    //               BEGIN
    //                 ERROR(AGILES_LT_TEXT003, FORMAT(lrc_FreightCostControle."Freight Cost Tariff Base"));
    //               END;
    //             END;

    //           UNTIL lrc_FruitVisionTempII.NEXT() = 0;


    //           // -----------------------------------------------------------------------------------------------------------------
    //           // Differenzbeträge buchen
    //           // -----------------------------------------------------------------------------------------------------------------
    //           lrc_GeneralLedgerSetup.GET();
    //           lrc_BatchSetup.GET();
    //           lrc_SourceCodeSetup.GET();

    //           lrc_ShippingAgent.GET(lrc_FreightCostControle."Shipping Agent Code");
    //           lrc_ShippingAgent.TESTFIELD("Freight CoCo. G/L Acc. No");
    //           lrc_ShippingAgent.TESTFIELD("Freight CoCo. Bal. G/L Acc. No");

    //           lrc_FruitVisionTempII.RESET();
    //           lrc_FruitVisionTempII.SETRANGE("User ID",UserID());
    //           lrc_FruitVisionTempII.SETRANGE("Entry Type",lrc_FruitVisionTempII."Entry Type"::"Posting Add. Freight Cost");
    //           IF lrc_FruitVisionTempII.FIND('-') THEN BEGIN
    //             REPEAT

    //               IF lrc_FruitVisionTempII."FC Posting Amount" <> 0 THEN BEGIN

    //                 lrc_GenJournalLine.RESET();
    //                 lrc_GenJournalLine.INIT();
    //                 lrc_GenJournalLine."Journal Template Name" := '';
    //                 lrc_GenJournalLine."Journal Batch Name" := '';
    //                 lin_LineNo := lin_LineNo + 10000;
    //                 lrc_GenJournalLine."Line No." := lin_LineNo;
    //                 lrc_GenJournalLine."Document Type" := lrc_GenJournalLine."Document Type"::" ";
    //                 lrc_GenJournalLine."Document No." := lrc_FreightCostControle."Source No.";
    //                 lrc_GenJournalLine.VALIDATE("Posting Date",ldt_PostingDate);
    //                 lrc_GenJournalLine."External Document No." := lrc_FreightCostControle."Source No.";

    //         ////        IF lrc_SourceCodeSetup."Diffposting Calc. Freight Cost" <> '' THEN BEGIN
    //         ////          lrc_GenJournalLine."Source Code" := lrc_SourceCodeSetup."Diffposting Calc. Freight Cost";
    //         ////        END;

    //                 lrc_GenJournalLine."Account Type" := lrc_GenJournalLine."Account Type"::"G/L Account";
    //                 lrc_GenJournalLine.VALIDATE("Account No.",lrc_ShippingAgent."Freight CoCo. G/L Acc. No");
    //                 lrc_GenJournalLine.VALIDATE("Currency Code",'');

    //                 IF lrc_ShippingAgent."Freight CoCo. Amout Deb./Cred." = lrc_ShippingAgent."Freight CoCo. Amout Deb./Cred."::Soll THEN BEGIN
    //                   IF lrc_ShippingAgent."Freight CoCo. Change Sign" = TRUE THEN
    //                     lrc_GenJournalLine."Debit Amount" := lrc_GenJournalLine."Debit Amount" +
    //                                                          (lrc_FruitVisionTempII."FC Posting Amount" * -1)
    //                   ELSE
    //                     lrc_GenJournalLine."Debit Amount" := lrc_GenJournalLine."Debit Amount" +
    //                                                          lrc_FruitVisionTempII."FC Posting Amount";
    //                   lrc_GenJournalLine.VALIDATE("Debit Amount");
    //                 END ELSE BEGIN
    //                   IF lrc_ShippingAgent."Freight CoCo. Change Sign" = TRUE THEN
    //                     lrc_GenJournalLine."Credit Amount" := lrc_GenJournalLine."Credit Amount" +
    //                                                           (lrc_FruitVisionTempII."FC Posting Amount" * -1)
    //                   ELSE
    //                     lrc_GenJournalLine."Credit Amount" := lrc_GenJournalLine."Credit Amount" +
    //                                                           lrc_FruitVisionTempII."FC Posting Amount";
    //                   lrc_GenJournalLine.VALIDATE("Credit Amount");
    //                 END;

    //                 lrc_GenJournalLine."Bal. Account Type" := lrc_GenJournalLine."Bal. Account Type"::"G/L Account";
    //                 lrc_GenJournalLine.VALIDATE("Bal. Account No.",lrc_ShippingAgent."Freight CoCo. Bal. G/L Acc. No");

    //                 // FRA 005 DMG50110.s
    //                 // Zuweisung der gespeicherten Dimensionen auf Positionsebene.
    //                 // Pro Position darf es theoretisch nur einen Eintrag für eine Dimension geben.
    //                 lrc_DimensionTemp.RESET();
    //                 lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                 lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                 // FRA 012 00000000.s
    //                 // lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                 lrc_DimensionTemp.SETRANGE("FC Batch No.",  lrc_FruitVisionTempII."FC Batch No.");
    //                 // FRA 012 00000000.e
    //                 lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'1');
    //                 IF lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                   // "BB Batch No." = Dimensionswert
    //                   lrc_GenJournalLine.VALIDATE("Shortcut Dimension 1 Code",lrc_DimensionTemp."BB Batch No.");
    //                 END;

    //                 lrc_DimensionTemp.RESET();
    //                 lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                 lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                 // FRA 012 00000000.s
    //                 // lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                 lrc_DimensionTemp.SETRANGE("FC Batch No.",  lrc_FruitVisionTempII."FC Batch No.");
    //                 // FRA 012 00000000.e
    //                 lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'2');
    //                 IF lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                   // "BB Batch No." = Dimensionswert
    //                   lrc_GenJournalLine.VALIDATE("Shortcut Dimension 2 Code",lrc_DimensionTemp."BB Batch No.");
    //                 END;

    //                 lrc_DimensionTemp.RESET();
    //                 lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                 lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                 // FRA 012 00000000.s
    //                 // lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                 lrc_DimensionTemp.SETRANGE("FC Batch No.",  lrc_FruitVisionTempII."FC Batch No.");
    //                 // FRA 012 00000000.e
    //                 lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'3');
    //                 IF lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                   // "BB Batch No." = Dimensionswert
    //                   lrc_GenJournalLine.VALIDATE("Shortcut Dimension 3 Code",lrc_DimensionTemp."BB Batch No.");
    //                 END;

    //                 lrc_DimensionTemp.RESET();
    //                 lrc_DimensionTemp.SETRANGE("User ID",UserID());
    //                 lrc_DimensionTemp.SETRANGE("Entry Type",lrc_DimensionTemp."Entry Type"::"Posting Add. Freight Cost");
    //                 // FRA 012 00000000.s
    //                 // lrc_DimensionTemp.SETRANGE("FC Batch No.",lrc_SalesShipmentLine."Batch No.");
    //                 lrc_DimensionTemp.SETRANGE("FC Batch No.",  lrc_FruitVisionTempII."FC Batch No.");
    //                 // FRA 012 00000000.e
    //                 lrc_DimensionTemp.SETRANGE("BB Master Batch No.",'4');
    //                 IF lrc_DimensionTemp.FIND('-') THEN BEGIN
    //                   // "BB Batch No." = Dimensionswert
    //                   lrc_GenJournalLine.VALIDATE("Shortcut Dimension 4 Code",lrc_DimensionTemp."BB Batch No.");
    //                 END;

    //                 /* ALTER CODE
    //                 IF lrc_GeneralLedgerSetup."Shortcut Dimension 1 Code" <> '' THEN BEGIN
    //                   lrc_PostDocDim.SETRANGE("Table ID",112);
    //                   lrc_PostDocDim.SETRANGE("Document No.",lrc_FreightCostControle."Source No.");
    //                   lrc_PostDocDim.SETRANGE("Line No.",0);
    //                   lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 1 Code");
    //                   IF lrc_PostDocDim.FIND('-') THEN BEGIN
    //                     lrc_GenJournalLine.VALIDATE("Shortcut Dimension 1 Code",lrc_PostDocDim."Dimension Value Code");
    //                   END;
    //                 END;
    //                 IF lrc_GeneralLedgerSetup."Shortcut Dimension 2 Code" <> '' THEN BEGIN
    //                   lrc_PostDocDim.SETRANGE("Table ID",112);
    //                   lrc_PostDocDim.SETRANGE("Document No.",lrc_FreightCostControle."Source No.");
    //                   lrc_PostDocDim.SETRANGE("Line No.",0);
    //                   lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 2 Code");
    //                   IF lrc_PostDocDim.FIND('-') THEN BEGIN
    //                     lrc_GenJournalLine.VALIDATE("Shortcut Dimension 2 Code",lrc_PostDocDim."Dimension Value Code");
    //                   END;
    //                 END;
    //                 IF lrc_GeneralLedgerSetup."Shortcut Dimension 3 Code" <> '' THEN BEGIN
    //                   lrc_PostDocDim.SETRANGE("Table ID",112);
    //                   lrc_PostDocDim.SETRANGE("Document No.",lrc_FreightCostControle."Source No.");
    //                   lrc_PostDocDim.SETRANGE("Line No.",0);
    //                   lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 3 Code");
    //                   IF lrc_PostDocDim.FIND('-') THEN BEGIN
    //                     lrc_GenJournalLine.VALIDATE("Shortcut Dimension 3 Code",lrc_PostDocDim."Dimension Value Code");
    //                   END;
    //                 END;
    //                 IF lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code" <> '' THEN BEGIN
    //                   lrc_PostDocDim.SETRANGE("Table ID",112);
    //                   lrc_PostDocDim.SETRANGE("Document No.",lrc_FreightCostControle."Source No.");
    //                   lrc_PostDocDim.SETRANGE("Line No.",0);
    //                   lrc_PostDocDim.SETRANGE("Dimension Code",lrc_GeneralLedgerSetup."Shortcut Dimension 4 Code");
    //                   IF lrc_PostDocDim.FIND('-') THEN BEGIN
    //                     lrc_GenJournalLine.VALIDATE("Shortcut Dimension 4 Code",lrc_PostDocDim."Dimension Value Code");
    //                   END;
    //                 END;
    //                 */
    //                 // FRA 005 DMG50110.e

    //                 CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                   lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                     lrc_GenJournalLine.VALIDATE("Shortcut Dimension 1 Code",lrc_FruitVisionTempII."FC Batch No.");
    //                   lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                     lrc_GenJournalLine.VALIDATE("Shortcut Dimension 2 Code",lrc_FruitVisionTempII."FC Batch No.");
    //                   lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                     lrc_GenJournalLine.VALIDATE("Shortcut Dimension 3 Code",lrc_FruitVisionTempII."FC Batch No.");
    //                   lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                     lrc_GenJournalLine.VALIDATE("Shortcut Dimension 4 Code",lrc_FruitVisionTempII."FC Batch No.");
    //                   ELSE
    //                     // Dimensionsebene nicht zulässig!
    //                     ERROR(AGILES_LT_TEXT004);
    //                 END;

    //                 lrc_GenJournalLine."Source Type" := lrc_GenJournalLine."Source Type"::Customer;
    //                 lrc_GenJournalLine."Source No." := '';

    //                 IF lrc_ShippingAgent."Freight CoCo. Description" <> '' THEN
    //                   lrc_GenJournalLine.Description := lrc_ShippingAgent."Freight CoCo. Description"
    //                 ELSE
    //                   // Kalk. Frachtkosten
    //                   lrc_GenJournalLine.Description := AGILES_LT_TEXT002;

    //                 lrc_GenJournalLine.insert();

    //               END;

    //             UNTIL lrc_FruitVisionTempII.NEXT() = 0;

    //             // ----------------------------------------------------------------------------
    //             // Zeilen buchen
    //             // ----------------------------------------------------------------------------
    //             lrc_GenJournalLine.RESET();
    //             IF lrc_GenJournalLine.FIND('-') THEN
    //               REPEAT
    //                 IF lrc_GenJournalLine.Amount <> 0 THEN
    //                   CODEUNIT.RUN(12,lrc_GenJournalLine);
    //               UNTIL lrc_GenJournalLine.NEXT() = 0;

    //           END;

    //           // Frachtkostenkontrollsatz aktualisieren
    //           lrc_FreightCostControle."Posted Difference Amount" := lrc_FreightCostControle."Posted Difference Amount" + ldc_DiffFreightCostAmt;
    //           lrc_FreightCostControle."Difference Calc. and Inv. Amt." := lrc_FreightCostControle."Freight Inv. Cost Amount" -
    //                                                                       lrc_FreightCostControle."Calc. Freight Cost Amount" -
    //                                                                       lrc_FreightCostControle."Posted Difference Amount";

    //           // FRA 006 DMG50000.s
    //           // lrc_FreightCostControle."Document Subtype Code" := '';
    //           // FRA 006 DMG50000.e
    //           lrc_FreightCostControle.MODIFY();

    //         END;

    //     end;

    //     procedure FreightCostControleTransLoad(vrc_TransferHeader: Record "Transfer Header")
    //     var
    //         lrc_FreightCostControle: Record "5087923";
    //         lrc_TransferFreightCost: Record "5110407";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zum Laden der Frachtkosten aus Umlagerungen für die Kostenkontrolle
    //         // ---------------------------------------------------------------------------------

    //         vrc_TransferHeader.TESTFIELD("No.");

    //         // Bestehende Einträge löschen, wenn noch keine Frachtrechnung vorliegt
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETFILTER(Source,'%1|%2',lrc_FreightCostControle.Source::Transfer,
    //                                                          lrc_FreightCostControle.Source::Sales);
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_TransferHeader."No.");
    //         lrc_FreightCostControle.SETRANGE("Freight Inv. Recieved",FALSE);
    //         IF lrc_FreightCostControle.FIND('-') THEN
    //           lrc_FreightCostControle.DELETEALL();

    //         // Werte auf Null setzen
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETFILTER(Source,'%1|%2',lrc_FreightCostControle.Source::Transfer,
    //                                                          lrc_FreightCostControle.Source::Sales);
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_TransferHeader."No.");
    //         IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := 0;
    //             lrc_FreightCostControle.MODIFY();
    //           UNTIL lrc_FreightCostControle.NEXT() = 0;
    //         END;


    //         lrc_TransferFreightCost.RESET();
    //         lrc_TransferFreightCost.SETRANGE("Transfer Doc. No.",vrc_TransferHeader."No.");
    //         lrc_TransferFreightCost.SETRANGE("Entry Type",lrc_TransferFreightCost."Entry Type"::"Sped.+AbgReg.+Frachteinheit");
    //         IF lrc_TransferFreightCost.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_FreightCostControle.RESET();
    //             lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Transfer);
    //             lrc_FreightCostControle.SETRANGE("Source No.",lrc_TransferFreightCost."Transfer Doc. No.");
    //             lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_TransferFreightCost."Shipping Agent Code");
    //             lrc_FreightCostControle.SETRANGE("Departure Region Code",lrc_TransferFreightCost."Freight Departure Region");
    //             IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN
    //               lrc_FreightCostControle.RESET();
    //               lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Transfer);
    //               lrc_FreightCostControle.SETRANGE("Source No.",lrc_TransferFreightCost."Transfer Doc. No.");
    //               lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_TransferFreightCost."Shipping Agent Code");
    //               lrc_FreightCostControle.SETRANGE("Departure Region Code",'');
    //               IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN
    //                 lrc_FreightCostControle.RESET();
    //                 lrc_FreightCostControle.INIT();
    //                 lrc_FreightCostControle.Source := lrc_FreightCostControle.Source::Transfer;
    //                 lrc_FreightCostControle."Source No." := lrc_TransferFreightCost."Transfer Doc. No.";
    //                 lrc_FreightCostControle.Source := lrc_FreightCostControle.Source::Transfer;
    //                 // FRA 006 DMG50000.s
    //                 lrc_FreightCostControle."Document Subtype Code" := vrc_TransferHeader."Transfer Doc. Subtype Code";
    //                 // FRA 006 DMG50000.e
    //                 lrc_FreightCostControle."Shipping Agent Code" := lrc_TransferFreightCost."Shipping Agent Code";
    //                 lrc_FreightCostControle."Departure Region Code" := lrc_TransferFreightCost."Freight Departure Region";
    //                 lrc_FreightCostControle."POI Arrival Region Code" := vrc_TransferHeader."POI Arrival Region Code";
    //                 lrc_FreightCostControle."Freight Unit Code" := lrc_TransferFreightCost."Freight Unit Code";
    //                 lrc_FreightCostControle."Freight Cost Tariff Base" := lrc_TransferFreightCost."Freight Cost Tarif Base";
    //                 lrc_FreightCostControle."No Posting of Difference" := TRUE;
    //                 lrc_FreightCostControle.insert();
    //               END;

    //             END;

    //             lrc_FreightCostControle."Departure Region Code" := lrc_TransferFreightCost."Freight Departure Region";

    //             lrc_FreightCostControle."Cust. Name" := vrc_TransferHeader."Transfer-to Name";
    //             lrc_FreightCostControle."Cust. City" := vrc_TransferHeader."Transfer-to City";
    //             lrc_FreightCostControle."Cust.Ship-to City" := vrc_TransferHeader."Transfer-to City";
    //             lrc_FreightCostControle."Shipping Date" := vrc_TransferHeader."Shipment Date";
    //             lrc_FreightCostControle."Promised Delivery Date" := vrc_TransferHeader."Shipment Date";
    //             lrc_FreightCostControle."Freight Cost Manual" := lrc_TransferFreightCost."Freight Cost Manual";
    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := lrc_FreightCostControle."Calc. Freight Cost Amount" +
    //                                                                    lrc_TransferFreightCost."POI Freight Costs Amount (LCY)";

    //             // FRA 006 DMG50000.s
    //             lrc_FreightCostControle."Document Subtype Code" := vrc_TransferHeader."Transfer Doc. Subtype Code";
    //             // FRA 006 DMG50000.e
    //             lrc_FreightCostControle.MODIFY();

    //           UNTIL lrc_TransferFreightCost.NEXT() = 0;

    //         END;
    //     end;

    //     procedure FreightCostContrTransSetPostNo()
    //     begin
    //     end;

    //     procedure FreightCostContrSalesClaimLoad(vrc_SalesClaimHeader: Record "5110455")
    //     var
    //         lrc_FreightCostControle: Record "5087923";
    //         lrc_SalesFreightCosts: Record "5110549";
    //         lrc_SalesClaimLine: Record "5110456";
    //     begin

    //         //FRA 007 KHH50268.s

    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zum Laden der Frachtkosten aus Verkaufsreklamationen für die Kostenkontrolle
    //         // ---------------------------------------------------------------------------------------

    //         vrc_SalesClaimHeader.TESTFIELD("No.");

    //         // Bestehende Einträge ohne Frachtrechnung löschen
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::"Sales Claim Order");
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesClaimHeader."No.");
    //         lrc_FreightCostControle.SETRANGE("Freight Inv. Recieved",FALSE);
    //         IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //           lrc_FreightCostControle.DELETEALL();
    //         END;

    //         // Bestehende Einträge Kalk. Frachtkosten zurücksetzen
    //         lrc_FreightCostControle.RESET();
    //         lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::"Sales Claim Order");
    //         lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesClaimHeader."No.");
    //         IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := 0;
    //             lrc_FreightCostControle.MODIFY();
    //           UNTIL lrc_FreightCostControle.NEXT() = 0;
    //         END;


    //             /*
    //             // Wegen Umstellung auf Abgangsregion als Teil des Schlüssels übergangsweise Prüfung ob es einen Satz ohne Abgangsregion gibt
    //             lrc_FreightCostControle.RESET();
    //             lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //             lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesHeader."No.");
    //             lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //             lrc_FreightCostControle.SETRANGE("Departure Region Code",lrc_SalesFreightCosts."Departure Region Code");
    //             IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN
    //               lrc_FreightCostControle.RESET();
    //               lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::Sales);
    //               lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesHeader."No.");
    //               lrc_FreightCostControle.SETRANGE("Shipping Agent Code",lrc_SalesFreightCosts."Shipping Agent Code");
    //               lrc_FreightCostControle.SETRANGE("Departure Region Code",'');
    //               IF lrc_FreightCostControle.FIND('-') THEN BEGIN
    //                 lrc_FreightCostControle."Departure Region Code" := lrc_SalesFreightCosts."Departure Region Code";
    //                 lrc_FreightCostControle."Freight Unit Code" := lrc_SalesFreightCosts."Freight Unit Code";
    //                 lrc_FreightCostControle."POI Arrival Region Code" := vrc_SalesHeader."POI Arrival Region Code";
    //                 lrc_FreightCostControle."Freight Cost Tariff Base" := lrc_SalesFreightCosts."Freight Cost Tariff Base";
    //                 lrc_FreightCostControle."Shipping Date" := lrc_SalesFreightCosts."Shipment Date";
    //                 lrc_FreightCostControle."Freight Cost Manual" := lrc_SalesFreightCosts."Freight Cost Manual Entered";
    //                 lrc_FreightCostControle."Cust. No." := vrc_SalesHeader."Sell-to Customer No.";
    //                 lrc_FreightCostControle."Cust. Name" := vrc_SalesHeader."Sell-to Customer Name";
    //                 lrc_FreightCostControle."Cust. City" := vrc_SalesHeader."Sell-to City";
    //                 lrc_FreightCostControle."Cust.Ship-to City" := vrc_SalesHeader."Ship-to City";

    //                 tControle.
    //                 lrc_FreightCostControle.MODIFY();
    //               END;
    //             END;
    //             */

    //         IF vrc_SalesClaimHeader."Freight Cost Amount (LC)" <> 0 THEN BEGIN
    //             lrc_FreightCostControle.RESET();
    //             lrc_FreightCostControle.SETRANGE(Source,lrc_FreightCostControle.Source::"Sales Claim Order");
    //             lrc_FreightCostControle.SETRANGE("Source No.",vrc_SalesClaimHeader."No.");
    //             lrc_FreightCostControle.SETRANGE("Shipping Agent Code",vrc_SalesClaimHeader."Claim Shipping Agent Code");
    //             IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN

    //               lrc_FreightCostControle.RESET();
    //               lrc_FreightCostControle.INIT();
    //               lrc_FreightCostControle.Source := lrc_FreightCostControle.Source::"Sales Claim Order";
    //               lrc_FreightCostControle."Source No." := vrc_SalesClaimHeader."No.";
    //               lrc_FreightCostControle."Document Subtype Code" := vrc_SalesClaimHeader."Claim Doc. Subtype Code";

    //               lrc_FreightCostControle."Shipping Agent Code" := vrc_SalesClaimHeader."Claim Shipping Agent Code";

    //               lrc_FreightCostControle."Freight Cost Tariff Base" := lrc_FreightCostControle."Freight Cost Tariff Base"::"Pallet Type";
    //               lrc_FreightCostControle."No Posting of Difference" := TRUE;

    //               lrc_SalesClaimLine.RESET();
    //               lrc_SalesClaimLine.SETRANGE("Document No.",vrc_SalesClaimHeader."No.");
    //               lrc_SalesClaimLine.SETRANGE(Type,lrc_SalesClaimLine.Type::Item);
    //               lrc_SalesClaimLine.SETRANGE(Claim,TRUE);
    //               IF lrc_SalesClaimLine.FIND('-') THEN BEGIN
    //                 lrc_FreightCostControle."Item Information" := lrc_SalesClaimLine."No." + ' / ' +
    //                                                               lrc_SalesClaimLine.Description + ' / ' +
    //                                                               lrc_SalesClaimLine."Unit of Measure Code";
    //               END;
    //               lrc_FreightCostControle.insert();
    //             END;

    //             // Felder aktualisieren und Kalk. Wert aufaddieren
    //             lrc_FreightCostControle."Freight Cost Manual" := TRUE;
    //             lrc_FreightCostControle."Cust. No." := vrc_SalesClaimHeader."Sell-to Customer No.";
    //             lrc_FreightCostControle."Cust. Name" := vrc_SalesClaimHeader."Sell-to Customer Name";
    //             lrc_FreightCostControle."Cust. City" := vrc_SalesClaimHeader."Sell-to City";
    //             lrc_FreightCostControle."Cust.Ship-to City" := vrc_SalesClaimHeader."Ship-to City";
    //             lrc_FreightCostControle."Shipping Date" := vrc_SalesClaimHeader."Shipment Date";
    //             lrc_FreightCostControle."Promised Delivery Date" := vrc_SalesClaimHeader."Claim Date";
    //             lrc_FreightCostControle."Calc. Freight Cost Amount" := lrc_FreightCostControle."Calc. Freight Cost Amount" +
    //                                                                    vrc_SalesClaimHeader."Freight Cost Amount (LC)";
    //             IF lrc_FreightCostControle."Freight Inv. Recieved" = TRUE THEN BEGIN
    //               lrc_FreightCostControle."Difference Calc. and Inv. Amt." := lrc_FreightCostControle."Freight Inv. Cost Amount" -
    //                                                                           lrc_FreightCostControle."Calc. Freight Cost Amount" -
    //                                                                           lrc_FreightCostControle."Posted Difference Amount";
    //             END ELSE BEGIN
    //               lrc_FreightCostControle."Difference Calc. and Inv. Amt." := 0;
    //             END;

    //             lrc_FreightCostControle.MODIFY();

    //         END;

    //         //FRA 007 KHH50268.e

    //     end;

    //     procedure "-- FRA 016 DMG50201"()
    //     begin
    //     end;

    //     procedure CalcProRataTransferFreightCost(vco_BatchVariantCode: Code[20];vco_LocationCode: Code[10];vco_ActualQuantityCollo: Decimal) ldc_ProRataTransferFreightCost: Decimal
    //     var
    //         ldc_FreightCostAmount: Decimal;
    //         ldc_QuantityCollo: Decimal;
    //         lrc_TransferHeader: Record "Transfer Header";
    //         lrc_TransferLine: Record "Transfer Line";
    //         lrc_TransferShipmentHeader: Record "5744";
    //         lrc_TransferShipmentLine: Record "5745";
    //         lrc_Location: Record "14";
    //         lrc_LocationGroup: Record "5110329";
    //         lrc_LocationGroupLocations: Record "5110330";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_FreightOrderDetailLine: Record "5110440";
    //         lbn_ValidLocation: Boolean;
    //     begin
    //         // FRA 016 DMG50201.s

    //         ldc_ProRataTransferFreightCost := 0;

    //         ldc_FreightCostAmount := 0;
    //         ldc_QuantityCollo := 0;

    //         // Gesamtfracht ausrechnen
    //         IF vco_BatchVariantCode <> '' THEN BEGIN
    //            IF lrc_BatchVariant.GET(vco_BatchVariantCode) THEN BEGIN

    //              lrc_FruitVisionSetup.GET();

    //              // ------------------------------------------------------------------------------------------
    //              // Menge und Betrag Frachtkosten gebuchte Umlagerungen berechnen
    //              // ------------------------------------------------------------------------------------------
    //              lrc_TransferLine.RESET();
    //              lrc_TransferLine.SETCURRENTKEY("Item No.","Batch Variant No.");
    //              lrc_TransferLine.SETRANGE("Item No.", lrc_BatchVariant."Item No.");
    //              lrc_TransferLine.SETRANGE("Batch Variant No.", lrc_BatchVariant."No.");
    //              lrc_TransferLine.SETFILTER("Outstanding Quantity",'<>%1',0);
    //              IF lrc_TransferLine.FIND('-') THEN BEGIN
    //                REPEAT
    //                  lrc_TransferHeader.GET(lrc_TransferLine."Document No.");

    //                  lbn_ValidLocation := FALSE;

    //                  lrc_Location.GET(lrc_TransferLine."Transfer-to Code");
    //                  // Lagerort ist identisch
    //                  IF lrc_Location.Code = vco_LocationCode THEN BEGIN
    //                    lbn_ValidLocation := TRUE;
    //                  END ELSE BEGIN
    //                    // entspricht die Lagerortgruppe des Lagerortes der Zeile, dem des übermittelten Lagerortes
    //                    IF lrc_Location."Location Group Code" <> '' THEN BEGIN
    //                      IF lrc_LocationGroup.GET(lrc_Location."Location Group Code") THEN BEGIN
    //                         lrc_LocationGroupLocations.RESET();
    //                         lrc_LocationGroupLocations.SETRANGE("Location Group Code", lrc_LocationGroup.Code);
    //                         lrc_LocationGroupLocations.SETRANGE("Location Code",  vco_LocationCode);
    //                         IF lrc_LocationGroupLocations.FINDFIRST() THEN BEGIN
    //                           lbn_ValidLocation := TRUE;
    //                         END;
    //                      END;
    //                    END;
    //                  END;

    //                  IF lbn_ValidLocation = TRUE THEN BEGIN
    //                    // Werte berechnen falls mit Frachtaufträgen gearbeitet wird
    //                    IF lrc_FruitVisionSetup."TF Transfer Freight activ" = TRUE THEN BEGIN
    //                      lrc_FreightOrderDetailLine.RESET();
    //                      lrc_FreightOrderDetailLine.SETCURRENTKEY("Doc. Source","Doc. Source Type","Doc. Source No.","Freight Order No.");
    //                      lrc_FreightOrderDetailLine.SETRANGE("Doc. Source",lrc_FreightOrderDetailLine."Doc. Source"::Transfer);
    //                      lrc_FreightOrderDetailLine.SETRANGE("Doc. Source No.", lrc_TransferHeader."No.");
    //                      lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Line No.",lrc_TransferLine."Line No.");
    //                      lrc_FreightOrderDetailLine.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //                      IF lrc_FreightOrderDetailLine.FIND('-') THEN BEGIN
    //                        REPEAT
    //                          ldc_QuantityCollo := ldc_QuantityCollo + lrc_FreightOrderDetailLine."Qty. to Ship";
    //                          ldc_FreightCostAmount := ldc_FreightCostAmount + lrc_FreightOrderDetailLine."Freight Costs (LCY)";
    //                        UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;
    //                      END;
    //                    END ELSE BEGIN
    //                      ldc_QuantityCollo := ldc_QuantityCollo + lrc_TransferLine."Outstanding Quantity";
    //                      ldc_FreightCostAmount := ldc_FreightCostAmount +
    //                        ROUND(((lrc_TransferLine."POI Freight Costs Amount (LCY)" /
    //                          lrc_TransferLine.Quantity) * lrc_TransferLine."Outstanding Quantity"), 0.00001);
    //                    END;
    //                  END;
    //                 UNTIL lrc_TransferLine.NEXT() = 0;
    //              END;

    //              // ------------------------------------------------------------------------------------------
    //              // Menge und Betrag Frachtkosten gebuchte Umlagerungen berechnen
    //              // ------------------------------------------------------------------------------------------
    //              lrc_TransferShipmentLine.RESET();
    //              lrc_TransferShipmentLine.SETCURRENTKEY("Item No.","Batch Variant No.");
    //              lrc_TransferShipmentLine.SETRANGE("Item No.", lrc_BatchVariant."Item No.");
    //              lrc_TransferShipmentLine.SETRANGE("Batch Variant No.", lrc_BatchVariant."No.");
    //              lrc_TransferShipmentLine.SETFILTER(Quantity,'<>%1',0);
    //              IF lrc_TransferShipmentLine.FIND('-') THEN BEGIN
    //                REPEAT
    //                  lrc_TransferShipmentHeader.GET(lrc_TransferShipmentLine."Document No.");

    //                  lbn_ValidLocation := FALSE;

    //                  lrc_Location.GET(lrc_TransferShipmentLine."Transfer-to Code");
    //                  // Lagerort ist identisch
    //                  IF lrc_Location.Code = vco_LocationCode THEN BEGIN
    //                    lbn_ValidLocation := TRUE;
    //                  END ELSE BEGIN
    //                    // entspricht die Lagerortgruppe des Lagerortes der Zeile, dem des übermittelten Lagerortes
    //                    IF lrc_Location."Location Group Code" <> '' THEN BEGIN
    //                      IF lrc_LocationGroup.GET(lrc_Location."Location Group Code") THEN BEGIN
    //                         lrc_LocationGroupLocations.RESET();
    //                         lrc_LocationGroupLocations.SETRANGE("Location Group Code", lrc_LocationGroup.Code);
    //                         lrc_LocationGroupLocations.SETRANGE("Location Code",  vco_LocationCode);
    //                         IF lrc_LocationGroupLocations.FINDFIRST() THEN BEGIN
    //                           lbn_ValidLocation := TRUE;
    //                         END;
    //                      END;
    //                    END;
    //                  END;

    //                  IF lbn_ValidLocation = TRUE THEN BEGIN
    //                    // Werte berechnen falls mit Frachtaufträgen gearbeitet wird
    //                    IF lrc_FruitVisionSetup."TF Transfer Freight activ" = TRUE THEN BEGIN
    //                      lrc_FreightOrderDetailLine.RESET();
    //                      lrc_FreightOrderDetailLine.SETCURRENTKEY("Doc. Source","Doc. Source Type","Doc. Source No.","Freight Order No.");
    //                      lrc_FreightOrderDetailLine.SETRANGE("Doc. Source",lrc_FreightOrderDetailLine."Doc. Source"::Transfer);
    //                      lrc_FreightOrderDetailLine.SETRANGE("Doc. Source No.", lrc_TransferShipmentHeader."Transfer Order No.");
    //                      lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Line No.",lrc_TransferShipmentLine."Line No.");
    //                      lrc_FreightOrderDetailLine.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //                      IF lrc_FreightOrderDetailLine.FIND('-') THEN BEGIN
    //                        REPEAT
    //                          ldc_QuantityCollo := ldc_QuantityCollo + lrc_FreightOrderDetailLine."Qty. to Ship";
    //                          ldc_FreightCostAmount := ldc_FreightCostAmount + lrc_FreightOrderDetailLine."Freight Costs (LCY)";
    //                        UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;
    //                      END;
    //                    END ELSE BEGIN
    //                      ldc_QuantityCollo := ldc_QuantityCollo + lrc_TransferShipmentLine.Quantity;
    //                      ldc_FreightCostAmount := ldc_FreightCostAmount + lrc_TransferShipmentLine."POI Freight Costs Amount (LCY)";
    //                    END;
    //                  END;
    //                 UNTIL lrc_TransferShipmentLine.NEXT() = 0;
    //              END;

    //              IF ldc_FreightCostAmount < 1 THEN BEGIN
    //                ldc_FreightCostAmount := 0;
    //              END;

    //            END;
    //         END;

    //         // anteilige Kosten ausrechnen
    //         IF (ldc_FreightCostAmount <> 0) AND
    //            (ldc_QuantityCollo <> 0) AND
    //            (vco_ActualQuantityCollo <> 0) THEN BEGIN
    //            ldc_ProRataTransferFreightCost := ROUND(((ldc_FreightCostAmount / ldc_QuantityCollo) * vco_ActualQuantityCollo), 0.00001);
    //         END;
    //         // FRA 016 DMG50201.e
    //     end;

    procedure PalletTolerance(pdc_Quantity: Decimal; pco_ShippingAgent: Code[10]): Decimal
    var
        lrc_ShippingAgent: Record "Shipping Agent";
        ldc_Tolerance: Decimal;
    begin
        IF lrc_ShippingAgent.GET(pco_ShippingAgent) THEN
            ldc_Tolerance := lrc_ShippingAgent."POI Freight Tolerance"
        ELSE
            ldc_Tolerance := 0;

        // Abziehen eines festen Toleranzwerts (1,007 Paletten können noch auf eine Palette gepackt werden)
        IF pdc_Quantity > 0 THEN BEGIN
            pdc_Quantity := pdc_Quantity - ldc_Tolerance;
            // Sollte der Wert negativ oder null werden, wird er wieder aufaddiert, da ansonsten u.U. keinerlei
            // Frachtkosten berechnet würden.
            IF pdc_Quantity <= 0 THEN
                pdc_Quantity := pdc_Quantity + ldc_Tolerance;
        END;

        EXIT(ROUND(pdc_Quantity, 0.001));
    end;

    //     procedure "-- GENERAL FUNCTIONS --"()
    //     begin
    //     end;

    //     procedure CopyFreightCostsFromArrivalReg(vrc_ShipAgentFreightcost: Record "5110405")
    //     var
    //         lrc_FromShipAgentFreightcost: Record "5110405";
    //         lrc_ToShipAgentFreightcost: Record "5110405";
    //         lrc_ArrivalRegion: Record "5110408";
    //         ADF_LT_TEXT001: Label 'Copy freight costs from Arrival region %1 to arrival region %2?';
    //     begin
    //         // -----------------------------------------------------------------------------------------------
    //         // Funktion zum Kopieren von Frachtkosten von einer Zugangsregion etc. in eine andere
    //         // -----------------------------------------------------------------------------------------------

    //         vrc_ShipAgentFreightcost.TESTFIELD("Shipping Agent Code");
    //         vrc_ShipAgentFreightcost.TESTFIELD("POI Arrival Region Code");

    //         // Neue Zugangsregion auswählen
    //         lrc_ArrivalRegion.RESET();
    //         lrc_ArrivalRegion.SETFILTER(Code,'<>%1',vrc_ShipAgentFreightcost."POI Arrival Region Code");
    //         IF FORM.RUNMODAL(0,lrc_ArrivalRegion) <> ACTION::LookupOK THEN
    //           EXIT;

    //         IF NOT CONFIRM(ADF_LT_TEXT001,FALSE,vrc_ShipAgentFreightcost."POI Arrival Region Code",lrc_ArrivalRegion.Code) THEN
    //           EXIT;

    //         lrc_ToShipAgentFreightcost.RESET();
    //         lrc_ToShipAgentFreightcost.SETRANGE("Shipping Agent Code",vrc_ShipAgentFreightcost."Shipping Agent Code");
    //         lrc_ToShipAgentFreightcost.SETRANGE("POI Arrival Region Code",lrc_ArrivalRegion.Code);
    //         lrc_ToShipAgentFreightcost.SETRANGE("Departure Region Code",vrc_ShipAgentFreightcost."Departure Region Code");
    //         IF NOT lrc_ToShipAgentFreightcost.isempty()THEN
    //           lrc_ToShipAgentFreightcost.DELETEALL();

    //         lrc_FromShipAgentFreightcost.RESET();
    //         lrc_FromShipAgentFreightcost.SETRANGE("Shipping Agent Code",vrc_ShipAgentFreightcost."Shipping Agent Code");
    //         lrc_FromShipAgentFreightcost.SETRANGE("POI Arrival Region Code",vrc_ShipAgentFreightcost."POI Arrival Region Code");
    //         lrc_FromShipAgentFreightcost.SETRANGE("Departure Region Code",vrc_ShipAgentFreightcost."Departure Region Code");
    //         IF lrc_FromShipAgentFreightcost.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             lrc_ToShipAgentFreightcost.TRANSFERFIELDS(lrc_FromShipAgentFreightcost);
    //             lrc_ToShipAgentFreightcost."POI Arrival Region Code" := lrc_ArrivalRegion.Code;
    //             lrc_ToShipAgentFreightcost.insert();
    //           UNTIL lrc_FromShipAgentFreightcost.NEXT() = 0;
    //         END;
    //     end;

    //     procedure EnterFreightRateManual()
    //     var
    //         lrc_ADFTempIII: Record "5087984";
    //         lfm_EnternewFreightRate: Form "5110686";
    //     begin
    //         // ---------------------------------------------------------------------------------------------------
    //         //
    //         // ---------------------------------------------------------------------------------------------------

    //         lrc_ADFTempIII.SETRANGE("User ID",UserID());
    //         lrc_ADFTempIII.SETRANGE("Entry Type",lrc_ADFTempIII."Entry Type"::"Freight Rate");
    //         lrc_ADFTempIII.DELETEALL();

    //         lrc_ADFTempIII.RESET();
    //         lrc_ADFTempIII.INIT();
    //         lrc_ADFTempIII."User ID" := USERID;
    //         lrc_ADFTempIII."Entry Type" := lrc_ADFTempIII."Entry Type"::"Freight Rate";
    //         lrc_ADFTempIII.insert();

    //         COMMIT;

    //         lrc_ADFTempIII.FILTERGROUP(2);
    //         lrc_ADFTempIII.SETRANGE("User ID",UserID());
    //         lrc_ADFTempIII.SETRANGE("Entry Type",lrc_ADFTempIII."Entry Type"::"Freight Rate");
    //         lrc_ADFTempIII.FILTERGROUP(0);

    //         lfm_EnternewFreightRate.SETTABLEVIEW(lrc_ADFTempIII);
    //         lfm_EnternewFreightRate.RUN;
    //     end;

    //     procedure SaveFreightRate()
    //     var
    //         lrc_ADFTempIII: Record "5087984";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //     begin


    //         lrc_ADFTempIII.SETRANGE("User ID",UserID());
    //         lrc_ADFTempIII.SETRANGE("Entry Type",lrc_ADFTempIII."Entry Type"::"Freight Rate");
    //         lrc_ADFTempIII.FINDFIRST;

    //         lrc_ADFTempIII.TESTFIELD("FRR Shippiing Agent Code");
    //         lrc_ADFTempIII.TESTFIELD("FRR Departure Region Code");
    //         lrc_ADFTempIII.TESTFIELD("FRR Arrival Region Code");
    //         lrc_ADFTempIII.TESTFIELD("FRR Freight Unit Code");

    //         IF (lrc_ADFTempIII."FRR From Qty 1" <> 0) AND
    //            (lrc_ADFTempIII."FRR To Qty 1" <> 0) THEN BEGIN
    //           lrc_ShipAgentFreightcost.VALIDATE("Shipping Agent Code",lrc_ADFTempIII."FRR Shippiing Agent Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("POI Arrival Region Code",lrc_ADFTempIII."FRR Arrival Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Departure Region Code",lrc_ADFTempIII."FRR Departure Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Unit of Measure Code",lrc_ADFTempIII."FRR Freight Unit Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("From Quantity",lrc_ADFTempIII."FRR From Qty 1");
    //           lrc_ShipAgentFreightcost.VALIDATE("Until Quantity",lrc_ADFTempIII."FRR To Qty 1");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Rate per Unit",lrc_ADFTempIII."FRR Freight Rate 1");
    //           IF NOT lrc_ShipAgentFreightcost.INSERT THEN
    //             lrc_ShipAgentFreightcost.MODIFY();
    //         END;

    //         IF (lrc_ADFTempIII."FRR From Qty 2" <> 0) AND
    //            (lrc_ADFTempIII."FRR To Qty 2" <> 0) THEN BEGIN
    //           lrc_ShipAgentFreightcost.VALIDATE("Shipping Agent Code",lrc_ADFTempIII."FRR Shippiing Agent Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("POI Arrival Region Code",lrc_ADFTempIII."FRR Arrival Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Departure Region Code",lrc_ADFTempIII."FRR Departure Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Unit of Measure Code",lrc_ADFTempIII."FRR Freight Unit Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("From Quantity",lrc_ADFTempIII."FRR From Qty 2");
    //           lrc_ShipAgentFreightcost.VALIDATE("Until Quantity",lrc_ADFTempIII."FRR To Qty 2");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Rate per Unit",lrc_ADFTempIII."FRR Freight Rate 2");
    //           IF NOT lrc_ShipAgentFreightcost.INSERT THEN
    //             lrc_ShipAgentFreightcost.MODIFY();
    //         END;

    //         IF (lrc_ADFTempIII."FRR From Qty 3" <> 0) AND
    //            (lrc_ADFTempIII."FRR To Qty 3" <> 0) THEN BEGIN
    //           lrc_ShipAgentFreightcost.VALIDATE("Shipping Agent Code",lrc_ADFTempIII."FRR Shippiing Agent Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("POI Arrival Region Code",lrc_ADFTempIII."FRR Arrival Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Departure Region Code",lrc_ADFTempIII."FRR Departure Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Unit of Measure Code",lrc_ADFTempIII."FRR Freight Unit Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("From Quantity",lrc_ADFTempIII."FRR From Qty 3");
    //           lrc_ShipAgentFreightcost.VALIDATE("Until Quantity",lrc_ADFTempIII."FRR To Qty 3");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Rate per Unit",lrc_ADFTempIII."FRR Freight Rate 3");
    //           IF NOT lrc_ShipAgentFreightcost.INSERT THEN
    //             lrc_ShipAgentFreightcost.MODIFY();
    //         END;

    //         IF (lrc_ADFTempIII."FRR From Qty 4" <> 0) AND
    //            (lrc_ADFTempIII."FRR To Qty 4" <> 0) THEN BEGIN
    //           lrc_ShipAgentFreightcost.VALIDATE("Shipping Agent Code",lrc_ADFTempIII."FRR Shippiing Agent Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("POI Arrival Region Code",lrc_ADFTempIII."FRR Arrival Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Departure Region Code",lrc_ADFTempIII."FRR Departure Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Unit of Measure Code",lrc_ADFTempIII."FRR Freight Unit Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("From Quantity",lrc_ADFTempIII."FRR From Qty 4");
    //           lrc_ShipAgentFreightcost.VALIDATE("Until Quantity",lrc_ADFTempIII."FRR To Qty 4");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Rate per Unit",lrc_ADFTempIII."FRR Freight Rate 4");
    //           IF NOT lrc_ShipAgentFreightcost.INSERT THEN
    //             lrc_ShipAgentFreightcost.MODIFY();
    //         END;

    //         IF (lrc_ADFTempIII."FRR From Qty 5" <> 0) AND
    //            (lrc_ADFTempIII."FRR To Qty 5" <> 0) THEN BEGIN
    //           lrc_ShipAgentFreightcost.VALIDATE("Shipping Agent Code",lrc_ADFTempIII."FRR Shippiing Agent Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("POI Arrival Region Code",lrc_ADFTempIII."FRR Arrival Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Departure Region Code",lrc_ADFTempIII."FRR Departure Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Unit of Measure Code",lrc_ADFTempIII."FRR Freight Unit Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("From Quantity",lrc_ADFTempIII."FRR From Qty 5");
    //           lrc_ShipAgentFreightcost.VALIDATE("Until Quantity",lrc_ADFTempIII."FRR To Qty 5");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Rate per Unit",lrc_ADFTempIII."FRR Freight Rate 5");
    //           IF NOT lrc_ShipAgentFreightcost.INSERT THEN
    //             lrc_ShipAgentFreightcost.MODIFY();
    //         END;

    //         IF (lrc_ADFTempIII."FRR From Qty 6" <> 0) AND
    //            (lrc_ADFTempIII."FRR To Qty 6" <> 0) THEN BEGIN
    //           lrc_ShipAgentFreightcost.VALIDATE("Shipping Agent Code",lrc_ADFTempIII."FRR Shippiing Agent Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("POI Arrival Region Code",lrc_ADFTempIII."FRR Arrival Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Departure Region Code",lrc_ADFTempIII."FRR Departure Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Unit of Measure Code",lrc_ADFTempIII."FRR Freight Unit Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("From Quantity",lrc_ADFTempIII."FRR From Qty 6");
    //           lrc_ShipAgentFreightcost.VALIDATE("Until Quantity",lrc_ADFTempIII."FRR To Qty 6");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Rate per Unit",lrc_ADFTempIII."FRR Freight Rate 6");
    //           IF NOT lrc_ShipAgentFreightcost.INSERT THEN
    //             lrc_ShipAgentFreightcost.MODIFY();
    //         END;

    //         IF (lrc_ADFTempIII."FRR From Qty 7" <> 0) AND
    //            (lrc_ADFTempIII."FRR To Qty 7" <> 0) THEN BEGIN
    //           lrc_ShipAgentFreightcost.VALIDATE("Shipping Agent Code",lrc_ADFTempIII."FRR Shippiing Agent Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("POI Arrival Region Code",lrc_ADFTempIII."FRR Arrival Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Departure Region Code",lrc_ADFTempIII."FRR Departure Region Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Unit of Measure Code",lrc_ADFTempIII."FRR Freight Unit Code");
    //           lrc_ShipAgentFreightcost.VALIDATE("From Quantity",lrc_ADFTempIII."FRR From Qty 7");
    //           lrc_ShipAgentFreightcost.VALIDATE("Until Quantity",lrc_ADFTempIII."FRR To Qty 7");
    //           lrc_ShipAgentFreightcost.VALIDATE("Freight Rate per Unit",lrc_ADFTempIII."FRR Freight Rate 7");
    //           lrc_ShipAgentFreightcost.Pauschal := lrc_ADFTempIII."FRR Total Lorry";
    //           IF NOT lrc_ShipAgentFreightcost.INSERT THEN
    //             lrc_ShipAgentFreightcost.MODIFY();
    //         END;
    //     end;
    var
        lrc_SalesLine: Record "Sales Line";
        lrc_SalesFreightCosts: Record "POI Sales Freight Costs";
        lrc_ShipAgentDepRegLoc: Record "POI Ship.-Agent/Dep.-Reg./Loc.";
        lrc_SalesFreightCosts2: Record "POI Sales Freight Costs";
        lrc_ShipAgentFreightcost: Record "POI Ship.-Agent Freightcost";
        lrc_FreightOrderDetailLine: Record "POI Freight Order Detail Line";
        lrc_FreightOrderDetailLine2: Record "POI Freight Order Detail Line";
}

