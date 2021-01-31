codeunit 5110334 "POI Sales Claim Mgt"
{
    var
        gcu_Port_Sales: Codeunit "POI Port_Sales";
        //gco_ClaimDocSubtypeCode: Code[10];
        //AGILES_TEXT001Txt: Label 'Do you want to select the credit memo in which the sales claim should be inserted?';
        //AGILES_TEXT002Txt: Label 'The creation was aborted.';
        IstPackauftrag: Boolean;
        PackauftragEindeutig: Boolean;
        VendorOrderNo: Code[20];
        BuyFromVendorNo: Code[20];

    //     procedure SalesShowClaimCard(vco_ClaimNo: Code[20])
    //     var
    //         lrc_ADFSetup: Record "5110302";
    //         lrc_SalesClaimHeader: Record "5110455";
    //         AGILESText001: Label 'Reklamationsmeldungsnr. nicht gültig!';
    //         lrc_ClaimDocSubtype: Record "5087971";
    //     begin
    //         // -----------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Verkaufsreklamationsmeldung
    //         // -----------------------------------------------------------------------------------

    //         // VKR 002 DMG50078.s
    //         lrc_SalesClaimHeader.GET(vco_ClaimNo);
    //         IF lrc_SalesClaimHeader."Claim Doc. Subtype Code" <> '' THEN BEGIN
    //           lrc_ClaimDocSubtype.GET(lrc_ClaimDocSubtype."Document Type"::"Sales Claim",lrc_SalesClaimHeader."Claim Doc. Subtype Code");
    //           lrc_ClaimDocSubtype.TESTFIELD("Form ID Card");
    //           lrc_SalesClaimHeader.RESET();
    //           IF lrc_ClaimDocSubtype."Allow Scrolling in Card" = FALSE THEN BEGIN
    //             lrc_SalesClaimHeader.FILTERGROUP(2);
    //             lrc_SalesClaimHeader.SETRANGE("No.",lrc_SalesClaimHeader."No.");
    //             lrc_SalesClaimHeader.FILTERGROUP(0);
    //           END ELSE BEGIN
    //             lrc_SalesClaimHeader.FILTERGROUP(2);
    //             lrc_SalesClaimHeader.SETRANGE("Claim Doc. Subtype Code",lrc_SalesClaimHeader."Claim Doc. Subtype Code");
    //             lrc_SalesClaimHeader.FILTERGROUP(0);
    //           END;
    //           // Karte öffnen
    //           FORM.RUN(lrc_ClaimDocSubtype."Form ID Card",lrc_SalesClaimHeader);
    //         END ELSE BEGIN
    //         // VKR 002 DMG50078.e

    //           lrc_ADFSetup.get();
    //           lrc_ADFSetup.TESTFIELD("Sales Claim Form ID");

    //           lrc_SalesClaimHeader.RESET();
    //           lrc_SalesClaimHeader.FILTERGROUP(2);
    //           lrc_SalesClaimHeader.SETRANGE("No.",vco_ClaimNo);
    //           lrc_SalesClaimHeader.FILTERGROUP(0);

    //           FORM.RUN(lrc_ADFSetup."Sales Claim Form ID",lrc_SalesClaimHeader);

    //         // VKR 002 DMG50078.s
    //         END;
    //         // VKR 002 DMG50078.e
    //     end;

    //     procedure SalesNewClaim(vco_SalesOrderNo: Code[20])
    //     var
    //         lrc_SalesClaimHeader: Record "5110455";
    //     begin
    //         // -----------------------------------------------------------------
    //         // Funktion zur Neuanlage einer Verkaufsreklamation
    //         // -----------------------------------------------------------------

    //         IF vco_SalesOrderNo <> '' THEN BEGIN
    //           IF NOT CheckShipment(vco_SalesOrderNo) THEN
    //             EXIT;
    //         END;

    //         lrc_SalesClaimHeader.RESET();
    //         lrc_SalesClaimHeader.INIT();
    //         lrc_SalesClaimHeader."No." := '';
    //         IF gco_ClaimDocSubtypeCode <> '' THEN
    //           lrc_SalesClaimHeader."Claim Doc. Subtype Code" := gco_ClaimDocSubtypeCode;
    //         lrc_SalesClaimHeader.INSERT(TRUE);
    //         COMMIT;

    //         IF vco_SalesOrderNo <> '' THEN BEGIN
    //           LoadClaimFromOrderNo(lrc_SalesClaimHeader."No.",vco_SalesOrderNo);
    //           COMMIT;
    //         END;

    //         // Lieferscheinnr. in Reklamation übertragen
    //         IF vco_SalesOrderNo <> '' THEN BEGIN
    //           lrc_SalesClaimHeader.GET(lrc_SalesClaimHeader."No.");
    //           LoadClaim(lrc_SalesClaimHeader,vco_SalesOrderNo,'','');  //wzi
    //         END;

    //         SalesShowClaimCard(lrc_SalesClaimHeader."No.");
    //     end;

    //     procedure ClaimNotifyFromSalesOrder(vco_SalesOrderNo: Code[20])
    //     var
    //         lrc_SalesClaimHeader: Record "5110455";
    //         lfm_SalesClaimList: Form "5110547";
    //     begin
    //         // -----------------------------------------------------------------------------------
    //         // Funktion zur Anlage einer Reklamationsmeldung aus einem Verkaufsauftrag
    //         // -----------------------------------------------------------------------------------

    //         lrc_SalesClaimHeader.FILTERGROUP(2);
    //         lrc_SalesClaimHeader.SETRANGE("Sales Order No.",vco_SalesOrderNo);
    //         lrc_SalesClaimHeader.FILTERGROUP(0);

    //         lfm_SalesClaimList.SetGlobal(vco_SalesOrderNo);
    //         lfm_SalesClaimList.SETTABLEVIEW(lrc_SalesClaimHeader);
    //         lfm_SalesClaimList.RUN;
    //     end;

    //     procedure CheckShipment(vco_SalesOrderNo: Code[20]): Boolean
    //     var
    //         lrc_SalesShipmentLine: Record "111";
    //         AGILES_LT_TEXT001: Label 'Es sind keine Lieferzeilen vorhanden. Möchten Sie alle offenen Verkaufszeilen liefern?';
    //         lrc_SalesHeader: Record "36";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zur Kontrolle ob Lieferungen vorhanden sind --> nur dann Reklamation möglich
    //         // -------------------------------------------------------------------------------------

    //         lrc_SalesShipmentLine.RESET();
    //         lrc_SalesShipmentLine.SETCURRENTKEY("Order No.","Order Line No.","Posting Date");
    //         lrc_SalesShipmentLine.SETRANGE("Order No.",vco_SalesOrderNo);
    //         lrc_SalesShipmentLine.SETRANGE(Correction,FALSE);
    //         lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
    //         lrc_SalesShipmentLine.SETFILTER("No.",'<>%1','');
    //         IF NOT lrc_SalesShipmentLine.FINDFIRST() THEN BEGIN

    //           // Es sind keine Lieferzeilen vorhanden. Möchten Sie alle offenen Verkaufszeilen liefern?
    //           IF NOT CONFIRM(AGILES_LT_TEXT001) THEN
    //             EXIT(FALSE);

    //           // Verkaufsauftrag liefern
    //           lrc_SalesHeader.RESET();
    //           lrc_SalesHeader.SETRANGE("Document Type",lrc_SalesHeader."Document Type"::Order);
    //           lrc_SalesHeader.SETRANGE("No.",vco_SalesOrderNo);
    //           lrc_SalesHeader.FIND('-');

    //           lrc_SalesHeader.Ship := TRUE;
    //           lrc_SalesHeader.Receive := FALSE;
    //           lrc_SalesHeader.Invoice := FALSE;

    //           CODEUNIT.RUN(CODEUNIT::"Sales-Post",lrc_SalesHeader);

    //           EXIT(TRUE);

    //         END ELSE BEGIN
    //           EXIT(TRUE);
    //         END;
    //     end;

    procedure LoadClaimFromOrderNo(vco_SalesClaimAdvNo: Code[20]; vco_SalesOrderNo: Code[20])
    var
        lrc_SalesHeader: Record "Sales Header";
        //lrc_SalesShipmentHeader: Record "Sales Shipment Header";
        //lrc_SalesShipmentLine: Record "Sales Shipment Line";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_UserSetup: Record "User Setup";
        lrc_LocationGroup: Record "POI Location Group";
        lrc_BatchVariant: Record "POI Batch Variant";
        lin_LineNo: Integer;
    //lbn_First: Boolean;
    //AGILES_LT_TEXT001Txt: Label 'Möchten Sie alle offenen Verkaufszeilen liefern?';
    begin
        // ----------------------------------------------------------------------------------
        // Funktion zum Laden einer Auftragsnummer in eine Reklamationsmeldung
        // ----------------------------------------------------------------------------------

        lrc_SalesClaimHeader.GET(vco_SalesClaimAdvNo);

        // Laden aus Verkaufsauftrag
        lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order, vco_SalesOrderNo);

        lrc_SalesClaimHeader."Sales Order No." := vco_SalesOrderNo;
        lrc_SalesClaimHeader."Sell-to Customer No." := lrc_SalesHeader."Sell-to Customer No.";
        lrc_SalesClaimHeader."Sell-to Customer Name" := lrc_SalesHeader."Sell-to Customer Name";
        lrc_SalesClaimHeader."Sell-to Customer Name 2" := lrc_SalesHeader."Sell-to Customer Name 2";
        lrc_SalesClaimHeader."Sell-to Address" := lrc_SalesHeader."Sell-to Address";
        lrc_SalesClaimHeader."Sell-to Address 2" := lrc_SalesHeader."Sell-to Address 2";
        lrc_SalesClaimHeader."Sell-to Contact" := lrc_SalesHeader."Sell-to Contact";
        lrc_SalesClaimHeader."Sell-to Country Code" := lrc_SalesHeader."Sell-to Country/Region Code";
        lrc_SalesClaimHeader."Sell-to Post Code" := lrc_SalesHeader."Sell-to Post Code";
        lrc_SalesClaimHeader."Sell-to City" := lrc_SalesHeader."Sell-to City";
        lrc_SalesClaimHeader."Language Code" := lrc_SalesHeader."Language Code";
        lrc_SalesClaimHeader."Bill-to Customer No." := lrc_SalesHeader."Bill-to Customer No.";
        lrc_SalesClaimHeader."Bill-to Name" := lrc_SalesHeader."Bill-to Name";
        lrc_SalesClaimHeader."Bill-to Name 2" := lrc_SalesHeader."Bill-to Name 2";
        lrc_SalesClaimHeader."Bill-to Address" := lrc_SalesHeader."Bill-to Address";
        lrc_SalesClaimHeader."Bill-to Address 2" := lrc_SalesHeader."Bill-to Address 2";
        lrc_SalesClaimHeader."Bill-to City" := lrc_SalesHeader."Bill-to City";
        lrc_SalesClaimHeader."Bill-to Contact" := lrc_SalesHeader."Bill-to Contact";
        lrc_SalesClaimHeader."Bill-to Post Code" := lrc_SalesHeader."Bill-to Post Code";
        lrc_SalesClaimHeader."Bill-to Country Code" := lrc_SalesHeader."Bill-to Country/Region Code";
        lrc_SalesClaimHeader."Ship-to Code" := lrc_SalesHeader."Ship-to Code";
        lrc_SalesClaimHeader."Ship-to Name" := lrc_SalesHeader."Ship-to Name";
        lrc_SalesClaimHeader."Ship-to Name 2" := lrc_SalesHeader."Ship-to Name 2";
        lrc_SalesClaimHeader."Ship-to Address" := lrc_SalesHeader."Ship-to Address";
        lrc_SalesClaimHeader."Ship-to Address 2" := lrc_SalesHeader."Ship-to Address 2";
        lrc_SalesClaimHeader."Ship-to City" := lrc_SalesHeader."Ship-to City";
        lrc_SalesClaimHeader."Ship-to Contact" := lrc_SalesHeader."Ship-to Contact";
        lrc_SalesClaimHeader."Ship-to Post Code" := lrc_SalesHeader."Ship-to Post Code";
        lrc_SalesClaimHeader."Ship-to Country Code" := lrc_SalesHeader."Ship-to Country/Region Code";
        lrc_SalesClaimHeader."Person in Charge Code" := lrc_SalesHeader."POI Person in Charge Code";
        lrc_SalesClaimHeader."Your Reference" := lrc_SalesHeader."Your Reference";

        lrc_SalesClaimHeader."Sales Order Date" := lrc_SalesHeader."Order Date";
        lrc_SalesClaimHeader."Sales Shipment Date" := lrc_SalesHeader."Shipment Date";
        lrc_SalesClaimHeader."Sales Means of Transport" := lrc_SalesHeader."POI Means of Transport Type";
        lrc_SalesClaimHeader."Sales Means of Transp. Code" := lrc_SalesHeader."Means of Transport Code";
        lrc_SalesClaimHeader."Sales Means of Transp. Info" := lrc_SalesHeader."POI Means of Transport Info";
        lrc_SalesClaimHeader."Shipping Agent Code" := lrc_SalesHeader."Shipping Agent Code";
        lrc_SalesClaimHeader."Claim Shipping Agent Code" := lrc_SalesHeader."Shipping Agent Code";
        lrc_SalesClaimHeader."Location Code" := lrc_SalesHeader."Location Code";
        lrc_SalesClaimHeader."Claim Location Code" := lrc_SalesHeader."Location Code";
        lrc_SalesClaimHeader."Sales Doc. Subtyp Code" := lrc_SalesHeader."POI Sales Doc. Subtype Code";

        lrc_SalesClaimHeader."Shipment Date" := lrc_SalesHeader."Shipment Date";

        IF lrc_UserSetup.GET(UserID()) THEN
            IF lrc_UserSetup."POI Loc Group Filter Sales" <> '' THEN BEGIN
                lrc_LocationGroup.GET(lrc_UserSetup."POI Loc Group Filter Sales");
                IF lrc_LocationGroup."Sales Claim Location Code" <> '' THEN
                    lrc_SalesClaimHeader.VALIDATE("Claim Location Code", lrc_LocationGroup."Sales Claim Location Code");
            END;

        lrc_SalesClaimHeader.MODIFY();

        // -----------------------------------------------------------------------------------------
        // Verkaufszeilen laden
        // -----------------------------------------------------------------------------------------
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETFILTER("No.", '<>%1', '');
        IF lrc_SalesLine.FINDSET(FALSE, FALSE) THEN BEGIN

            // Letzte Zeilennummer ermitteln
            lrc_SalesClaimLine.RESET();
            lrc_SalesClaimLine.SETRANGE("Document No.", lrc_SalesClaimHeader."No.");
            IF lrc_SalesClaimLine.FINDLAST() THEN
                lin_LineNo := lrc_SalesClaimLine."Line No."
            ELSE
                lin_LineNo := 0;
            REPEAT

                IF NOT lrc_BatchVariant.GET(lrc_SalesLine."POI Batch Variant No.") THEN
                    lrc_BatchVariant.INIT();


                lrc_SalesClaimLine.RESET();
                lrc_SalesClaimLine.INIT();
                lrc_SalesClaimLine."Document No." := lrc_SalesClaimHeader."No.";
                lin_LineNo := lin_LineNo + 10000;
                lrc_SalesClaimLine."Line No." := lin_LineNo;

                lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
                lrc_SalesClaimLine.VALIDATE("No.", lrc_SalesLine."No.");
                lrc_SalesClaimLine.Description := lrc_SalesLine.Description;
                lrc_SalesClaimLine."Description 2" := lrc_SalesLine."Description 2";
                lrc_SalesClaimLine."Master Batch No." := lrc_SalesLine."POI Master Batch No.";
                lrc_SalesClaimLine."Batch No." := lrc_SalesLine."POI Batch No.";
                lrc_SalesClaimLine."Batch Variant No." := lrc_SalesLine."POI Batch Variant No.";
                lrc_SalesClaimLine."Vendor No." := lrc_BatchVariant."Vendor No.";

                lrc_SalesClaimLine."Variety Code" := lrc_SalesLine."POI Variety Code";
                lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesLine."POI Country of Origin Code";
                lrc_SalesClaimLine."Trademark Code" := lrc_SalesLine."POI Trademark Code";
                lrc_SalesClaimLine."Caliber Code" := lrc_SalesLine."POI Caliber Code";
                lrc_SalesClaimLine."Item Attribute 2" := lrc_SalesLine."POI Item Attribute 2";
                lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesLine."POI Grade of Goods Code";
                lrc_SalesClaimLine."Item Attribute 7" := lrc_SalesLine."POI Item Attribute 7";
                lrc_SalesClaimLine."Item Attribute 4" := lrc_SalesLine."POI Item Attribute 4";
                lrc_SalesClaimLine."Coding Code" := lrc_SalesLine."POI Coding Code";
                lrc_SalesClaimLine."Item Attribute 5" := lrc_SalesLine."POI Item Attribute 5";
                lrc_SalesClaimLine."Item Attribute 3" := lrc_SalesLine."POI Item Attribute 3";

                lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesLine."POI Price Unit of Measure";
                lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesLine."POI Partial Quantity (PQ)";

                lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesLine."Unit of Measure Code";
                lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesLine."POI Base Unit of Measure (BU)";
                lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesLine."Qty. per Unit of Measure";
                lrc_SalesClaimLine."Quantity Shipped" := lrc_SalesLine."Quantity Shipped";
                lrc_SalesClaimLine."Quantity Invoiced" := lrc_SalesLine."Quantity Invoiced";
                lrc_SalesClaimLine.Quantity := lrc_SalesLine.Quantity;
                lrc_SalesClaimLine."Quantity (Base)" := lrc_SalesLine."Qty. per Unit of Measure" * lrc_SalesLine.Quantity;
                lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesLine."Shipping Agent Code";
                lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesLine."Shipping Agent Code";
                lrc_SalesClaimLine."Location Code" := lrc_SalesLine."Location Code";
                lrc_SalesClaimLine."Claim Location Code" := lrc_SalesLine."Location Code";
                lrc_SalesClaimLine."Item Category Code" := lrc_SalesLine."Item Category Code";
                lrc_SalesClaimLine."Product Group Code" := lrc_SalesLine."POI Product Group Code";
                lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesLine."POI Packing Unit of Meas (PU)";
                lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesLine."POI Qty. (PU) per Unit of Meas";
                lrc_SalesClaimLine."Quantity (PU)" := lrc_SalesLine."POI Quantity (PU)";
                lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesLine."POI Transp. Unit of Meas (TU)";

                //lrc_SalesLine."Qty. (Unit) per Transp.(TU)" := lrc_SalesLine."Qty. (Unit) per Transp.(TU)"; ????
                lrc_SalesClaimLine."Quantity (TU)" := lrc_SalesLine."POI Quantity (TU)";
                lrc_SalesClaimLine."Collo Unit of Measure (CU)" := lrc_SalesLine."POI Collo Unit of Measure (PQ)";
                lrc_SalesClaimLine."Content Unit of Measure (COU)" := lrc_SalesLine."POI Content Unit of Meas (COU)";
                lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesLine."POI Partial Quantity (PQ)";
                lrc_SalesClaimLine."Batch Item" := lrc_SalesLine."POI Batch Item";

                lrc_SalesClaimLine."Info 1" := lrc_SalesLine."POI Info 1";
                lrc_SalesClaimLine."Info 2" := lrc_SalesLine."POI Info 2";
                lrc_SalesClaimLine."Info 3" := lrc_SalesLine."POI Info 3";
                lrc_SalesClaimLine."Info 4" := lrc_SalesLine."POI Info 4";

                lrc_SalesClaimLine."Gross Weight" := lrc_SalesLine."Gross Weight";
                lrc_SalesClaimLine."Net Weight" := lrc_SalesLine."Net Weight";
                lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" := lrc_SalesLine."POI Qty.(COU) pr Pack.Unit(PU)";

                lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesLine."Unit Price";
                lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesLine."POI Price Base (Sales Price)";
                lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesLine."Sales Price (Price Base)";
                lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" * lrc_SalesClaimLine.Quantity;

                lrc_SalesClaimLine."Sales Order No." := lrc_SalesLine."Document No.";
                lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesLine."Line No.";
                lrc_SalesClaimLine."Sales Shipment No." := '';
                lrc_SalesClaimLine."Sales Shipment Line No." := 0;

                lrc_SalesClaimLine.Claim := FALSE;

                lrc_SalesClaimLine."Claim Quantity" := 0;
                lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
                lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
                lrc_SalesClaimLine."Claim Sales Amount" := 0;
                lrc_SalesClaimLine."Claim Verlust" := 0;

                //Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
                //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
                BuyFromVendorNo := lrc_BatchVariant."Vendor No.";
                gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesLine."POI Master Batch No.", BuyFromVendorNo,
                                                                      VendorOrderNo, IstPackauftrag, PackauftragEindeutig);
                lrc_SalesClaimLine."Buy-from Vendor No." := BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
                lrc_SalesClaimLine."Vendor Order No." := VendorOrderNo;
                //Return to Vendor ??

                lrc_FruitVisionSetup.GET();

                FetchPriceFromOrder(lrc_SalesClaimLine);

                //RS Übernahme von Leergutinfos
                lrc_SalesClaimLine."Empties Blanket Order No." := lrc_SalesLine."POI Empties Blanket Order No.";
                lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_SalesLine."POI Empt Blanket Ord Line No.";
                lrc_SalesClaimLine."Empties Item No." := lrc_SalesLine."POI Empties Item No.";
                lrc_SalesClaimLine."Empties Quantity" := lrc_SalesLine."POI Empties Quantity";
                lrc_SalesClaimLine.INSERT();


            UNTIL lrc_SalesLine.NEXT() = 0;
        END;
    end;

    procedure LoadClaimFromShipment(var rrc_SalesClaimAdviceHdr: Record "POI Sales Claim Notify Header"; vco_ShipmentNo: Code[20])
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_MasterBatchSetup: Record "POI Master Batch Setup";
        lrc_SalesShipmentLine: Record "Sales Shipment Line";
        lrc_SalesDocType: Record "POI Sales Doc. Subtype";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_UserSetup: Record "User Setup";
        lrc_LocationGroup: Record "POI Location Group";
        AGILES_LT_TEXT002Txt: Label 'Debitor Reklamationsmeldung %1\und Debitor Lieferung %2\sind unterschiedlich!', Comment = '%1 %2';
        AGILES_LT_TEXT001Txt: Label 'Es sind bereits Zeilen vorhanden! Neu laden?';
        lin_LineNo: Integer;
        lbn_InsertLine: Boolean;
    begin
        // -------------------------------------------------------------------------------------
        // Reklamation aus Lieferung laden
        // -------------------------------------------------------------------------------------
        IF vco_ShipmentNo = '' THEN
            EXIT;

        lrc_FruitVisionSetup.get();

        lrc_SalesClaimLine.RESET();
        lrc_SalesClaimLine.SETRANGE("Document No.", rrc_SalesClaimAdviceHdr."No.");
        IF NOT lrc_SalesClaimLine.ISEMPTY() THEN BEGIN
            // Es sind bereits Zeilen vorhanden! Neu laden?
            IF NOT CONFIRM(AGILES_LT_TEXT001Txt) THEN
                ERROR('');
            lrc_SalesClaimLine.DELETEALL(TRUE);
        END;

        lrc_SalesShipmentHdr.GET(vco_ShipmentNo);
        IF (rrc_SalesClaimAdviceHdr."Sell-to Customer No." <> lrc_SalesShipmentHdr."Sell-to Customer No.") THEN
            // Debitor Reklamationsmeldung %1\und Debitor Lieferung %2\sind unterschiedlich!
            ERROR(AGILES_LT_TEXT002Txt, rrc_SalesClaimAdviceHdr."Sell-to Customer No.",
                                      lrc_SalesShipmentHdr."Sell-to Customer No.");

        lrc_MasterBatchSetup.get();
        lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Order, lrc_SalesShipmentHdr."POI Sales Doc. Subtype Code");
        IF lrc_MasterBatchSetup."Sales Batch Assignment" =
           lrc_MasterBatchSetup."Sales Batch Assignment"::"Depend on Doc. Type" THEN
            lrc_MasterBatchSetup."Sales Batch Assignment" := lrc_SalesDocType."Sales Batch Assignment";


        // --------------------------------------------------------------------------------------
        // Verkaufslieferzeilen lesen
        // --------------------------------------------------------------------------------------
        lin_LineNo := 0;
        lrc_SalesShipmentLine.RESET();
        lrc_SalesShipmentLine.SETRANGE("Document No.", lrc_SalesShipmentHdr."No.");
        lrc_SalesShipmentLine.SETRANGE(Type, lrc_SalesShipmentLine.Type::Item);
        lrc_SalesShipmentLine.SETFILTER("No.", '<>%1', '');
        lrc_SalesShipmentLine.SETFILTER(Quantity, '<>%1', 0);
        lrc_SalesShipmentLine.SETRANGE(Correction, FALSE);
        IF lrc_SalesShipmentLine.FINDSET(FALSE, FALSE) THEN
            REPEAT

                lbn_InsertLine := TRUE;
                IF lrc_FruitVisionSetup."Sales Claim Check Dupplex" =
                   lrc_FruitVisionSetup."Sales Claim Check Dupplex"::"One per Shipment Line" THEN BEGIN
                    lrc_SalesClaimLine.RESET();
                    lrc_SalesClaimLine.SETRANGE("Sales Shipment No.", lrc_SalesShipmentLine."Document No.");
                    lrc_SalesClaimLine.SETRANGE("Sales Shipment Line No.", lrc_SalesShipmentLine."Line No.");
                    IF lrc_SalesClaimLine.FINDFIRST() THEN
                        lbn_InsertLine := FALSE;
                END;

                IF lbn_InsertLine = TRUE THEN
                    IF lrc_SalesShipmentLine."POI Batch Item" = FALSE THEN BEGIN

                        lrc_SalesClaimLine.RESET();
                        lrc_SalesClaimLine.INIT();
                        lrc_SalesClaimLine."Document No." := rrc_SalesClaimAdviceHdr."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_SalesClaimLine."Line No." := lin_LineNo;
                        lrc_SalesClaimLine.Claim := FALSE;
                        lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
                        lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
                        lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
                        lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";
                        lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
                        lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
                        lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
                        lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
                        lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
                        lrc_SalesClaimLine."Item Attribute 2" := lrc_SalesShipmentLine."POI Color Code";
                        lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
                        lrc_SalesClaimLine."Item Attribute 7" := lrc_SalesShipmentLine."POI Conservation Code";
                        lrc_SalesClaimLine."Item Attribute 4" := lrc_SalesShipmentLine."POI Packing Code";
                        lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
                        lrc_SalesClaimLine."Item Attribute 5" := lrc_SalesShipmentLine."POI Treatment Code";
                        lrc_SalesClaimLine."Item Attribute 3" := lrc_SalesShipmentLine."POI Quality Code";
                        lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
                        lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
                        lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
                        lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
                        lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
                        lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";
                        lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
                        lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
                        lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";
                        lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001);
                        lrc_SalesClaimLine.Quantity := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001);
                        lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesShipmentLine."Quantity (Base)", 0.00001);
                        lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
                        lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
                        lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001);
                        lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
                        lrc_SalesClaimLine."Qty. (Unit) per Transport (TU)" := lrc_SalesShipmentLine."POI Qty.(Unit) per Transp.Unit";
                        lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001);
                        lrc_SalesClaimLine."Collo Unit of Measure (CU)" := lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
                        lrc_SalesClaimLine."Content Unit of Measure (COU)" := lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";
                        lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
                        lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
                        lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" := lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";
                        lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."POI Price Unit of Measure";
                        lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";
                        lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
                        lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" * lrc_SalesClaimLine.Quantity;
                        lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
                        lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";
                        lrc_SalesClaimLine."Sales Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";
                        lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
                        lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
                        lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
                        lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
                        lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
                        lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
                        lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";
                        lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
                        lrc_SalesClaimLine."Claim Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";
                        lrc_SalesClaimLine."Claim Quantity" := 0;
                        lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
                        lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
                        lrc_SalesClaimLine."Claim Sales Amount" := 0;
                        lrc_SalesClaimLine."Claim Verlust" := 0;
                        //Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
                        //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
                        //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
                        gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.", BuyFromVendorNo,
                                                                            VendorOrderNo, IstPackauftrag, PackauftragEindeutig);
                        lrc_SalesClaimLine."Buy-from Vendor No." := BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
                        lrc_SalesClaimLine."Vendor Order No." := VendorOrderNo;
                        lrc_FruitVisionSetup.GET();
                        FetchPriceFromOrder(lrc_SalesClaimLine);
                        //Leergutinformationen mit übergeben
                        lrc_SalesClaimLine."Empties Blanket Order No." := lrc_SalesShipmentLine."POI Empties Blanket Order No.";
                        lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_SalesShipmentLine."POI Empt Blank Order Line No.";
                        lrc_SalesClaimLine."Empties Item No." := lrc_SalesShipmentLine."POI Empties Item No.";
                        lrc_SalesClaimLine."Empties Quantity" := lrc_SalesShipmentLine."POI Empties Quantity";
                        lrc_SalesClaimLine.INSERT();

                    END ELSE
                        CASE lrc_MasterBatchSetup."Sales Batch Assignment" OF
                            lrc_MasterBatchSetup."Sales Batch Assignment"::"Manual Multiple Line":
                                BEGIN
                                    lrc_SalesShipmentLine.TESTFIELD("POI Batch Var. Detail ID");
                                    lrc_BatchVariantEntry.RESET();
                                    lrc_BatchVariantEntry.SETCURRENTKEY("Detail Entry No.", "Detail Line No.");
                                    lrc_BatchVariantEntry.SETRANGE("Detail Entry No.", lrc_SalesShipmentLine."POI Batch Var. Detail ID");
                                    lrc_BatchVariantEntry.SETRANGE("Source Doc. Type", lrc_BatchVariantEntry."Source Doc. Type"::Order);
                                    lrc_BatchVariantEntry.SETRANGE("Source Doc. No.", lrc_SalesShipmentLine."Order No.");
                                    lrc_BatchVariantEntry.SETRANGE("Document No.", lrc_SalesShipmentLine."Document No.");
                                    lrc_BatchVariantEntry.SETRANGE("Document Line No.", lrc_SalesShipmentLine."Line No.");
                                    lrc_BatchVariantEntry.SETRANGE(Correction, FALSE);
                                    IF lrc_BatchVariantEntry.FINDSET(FALSE, FALSE) THEN
                                        REPEAT
                                            IF NOT lrc_BatchVariant.GET(lrc_BatchVariantEntry."Batch Variant No.") THEN
                                                lrc_BatchVariant.INIT();
                                            lrc_SalesClaimLine.RESET();
                                            lrc_SalesClaimLine.INIT();
                                            lrc_SalesClaimLine."Document No." := rrc_SalesClaimAdviceHdr."No.";
                                            lin_LineNo := lin_LineNo + 10000;
                                            lrc_SalesClaimLine."Line No." := lin_LineNo;
                                            lrc_SalesClaimLine.Claim := FALSE;
                                            lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
                                            lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
                                            lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
                                            lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";
                                            lrc_SalesClaimLine."Master Batch No." := lrc_BatchVariantEntry."Master Batch No.";
                                            lrc_SalesClaimLine."Batch No." := lrc_BatchVariantEntry."Batch No.";
                                            lrc_SalesClaimLine."Batch Variant No." := lrc_BatchVariantEntry."Batch Variant No.";
                                            lrc_SalesClaimLine."Vendor No." := lrc_BatchVariant."Vendor No.";
                                            lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
                                            lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
                                            lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
                                            lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
                                            lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
                                            lrc_SalesClaimLine."Item Attribute 2" := lrc_SalesShipmentLine."POI Color Code";
                                            lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
                                            lrc_SalesClaimLine."Item Attribute 7" := lrc_SalesShipmentLine."POI Conservation Code";
                                            lrc_SalesClaimLine."Item Attribute 4" := lrc_SalesShipmentLine."POI Packing Code";
                                            lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
                                            lrc_SalesClaimLine."Item Attribute 5" := lrc_SalesShipmentLine."POI Treatment Code";
                                            lrc_SalesClaimLine."Item Attribute 3" := lrc_SalesShipmentLine."POI Quality Code";
                                            lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
                                            lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
                                            lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
                                            lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
                                            lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
                                            lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";
                                            lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
                                            lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
                                            lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";
                                            lrc_SalesClaimLine.Quantity := ROUND((lrc_BatchVariantEntry."Quantity (Base)" /
                                                                                 lrc_SalesShipmentLine."Qty. per Unit of Measure") * -1, 0.00001);
                                            lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesClaimLine.Quantity, 0.00001);
                                            lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesClaimLine.Quantity *
                                                                                        lrc_SalesClaimLine."Qty. per Unit of Measure", 0.00001);
                                            lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
                                            lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
                                            lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001);
                                            lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
                                            lrc_SalesClaimLine."Qty. (Unit) per Transport (TU)" := lrc_SalesShipmentLine."POI Qty.(Unit) per Transp.Unit";
                                            lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001);
                                            lrc_SalesClaimLine."Collo Unit of Measure (CU)" := lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
                                            lrc_SalesClaimLine."Content Unit of Measure (COU)" := lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";
                                            lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
                                            lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
                                            lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" := lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";
                                            lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
                                            lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" *
                                                                                 lrc_SalesClaimLine.Quantity;
                                            lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
                                            lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";
                                            lrc_SalesClaimLine."Sales Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";
                                            lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."POI Price Unit of Measure";
                                            lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";
                                            lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
                                            lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
                                            lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
                                            lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
                                            lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
                                            lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
                                            lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";
                                            lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
                                            lrc_SalesClaimLine."Claim Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";
                                            lrc_SalesClaimLine."Claim Quantity" := 0;
                                            lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
                                            lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
                                            lrc_SalesClaimLine."Claim Sales Amount" := 0;
                                            lrc_SalesClaimLine."Claim Verlust" := 0;
                                            //Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
                                            //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
                                            //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
                                            gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.", BuyFromVendorNo,
                                                                                          VendorOrderNo, IstPackauftrag, PackauftragEindeutig);
                                            lrc_SalesClaimLine."Buy-from Vendor No." := BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
                                            lrc_SalesClaimLine."Vendor Order No." := VendorOrderNo;
                                            lrc_FruitVisionSetup.GET();
                                            FetchPriceFromOrder(lrc_SalesClaimLine);
                                            //Leergutinformationen mit übergeben
                                            lrc_SalesClaimLine."Empties Blanket Order No." := lrc_SalesShipmentLine."POI Empties Blanket Order No.";
                                            lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_SalesShipmentLine."POI Empt Blank Order Line No.";
                                            lrc_SalesClaimLine."Empties Item No." := lrc_SalesShipmentLine."POI Empties Item No.";
                                            lrc_SalesClaimLine."Empties Quantity" := lrc_SalesShipmentLine."POI Empties Quantity";
                                            lrc_SalesClaimLine.insert();
                                        UNTIL lrc_BatchVariantEntry.next() = 0;
                                END;
                            lrc_MasterBatchSetup."Sales Batch Assignment"::"Manual Single Line",
                            lrc_MasterBatchSetup."Sales Batch Assignment"::"Automatic from System":
                                BEGIN
                                    IF NOT lrc_BatchVariant.GET(lrc_BatchVariantEntry."Batch Variant No.") THEN
                                        lrc_BatchVariant.INIT();
                                    lrc_SalesClaimLine.RESET();
                                    lrc_SalesClaimLine.INIT();
                                    lrc_SalesClaimLine."Document No." := rrc_SalesClaimAdviceHdr."No.";
                                    lin_LineNo := lin_LineNo + 10000;
                                    lrc_SalesClaimLine."Line No." := lin_LineNo;
                                    lrc_SalesClaimLine.Claim := FALSE;
                                    lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
                                    lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
                                    lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
                                    lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";
                                    lrc_SalesClaimLine."Master Batch No." := lrc_SalesShipmentLine."POI Master Batch No.";
                                    lrc_SalesClaimLine."Batch No." := lrc_SalesShipmentLine."POI Batch No.";
                                    lrc_SalesClaimLine."Batch Variant No." := lrc_SalesShipmentLine."POI Batch Variant No.";
                                    lrc_SalesClaimLine."Vendor No." := lrc_BatchVariant."Vendor No.";
                                    lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
                                    lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
                                    lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
                                    lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
                                    lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
                                    lrc_SalesClaimLine."Item Attribute 2" := lrc_SalesShipmentLine."POI Color Code";
                                    lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
                                    lrc_SalesClaimLine."Item Attribute 7" := lrc_SalesShipmentLine."POI Conservation Code";
                                    lrc_SalesClaimLine."Item Attribute 4" := lrc_SalesShipmentLine."POI Packing Code";
                                    lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
                                    lrc_SalesClaimLine."Item Attribute 5" := lrc_SalesShipmentLine."POI Treatment Code";
                                    lrc_SalesClaimLine."Item Attribute 3" := lrc_SalesShipmentLine."POI Quality Code";
                                    lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
                                    lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
                                    lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
                                    lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
                                    lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
                                    lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";
                                    lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."POI Price Unit of Measure";
                                    lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";
                                    lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
                                    lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
                                    lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";
                                    lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001);
                                    lrc_SalesClaimLine."Quantity Invoiced" := 0;
                                    lrc_SalesClaimLine.Quantity := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001);
                                    lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesShipmentLine."Quantity (Base)", 0.00001);
                                    lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
                                    lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
                                    lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001);
                                    lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
                                    lrc_SalesClaimLine."Qty. (Unit) per Transport (TU)" := lrc_SalesShipmentLine."POI Qty.(Unit) per Transp.Unit";
                                    lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001);
                                    lrc_SalesClaimLine."Collo Unit of Measure (CU)" := lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
                                    lrc_SalesClaimLine."Content Unit of Measure (COU)" := lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";
                                    lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
                                    lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
                                    lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" := lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";
                                    lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
                                    lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" * lrc_SalesClaimLine.Quantity;
                                    lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
                                    lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";
                                    lrc_SalesClaimLine."Sales Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";
                                    lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
                                    lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
                                    lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
                                    lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
                                    lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
                                    lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
                                    lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";
                                    lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
                                    lrc_SalesClaimLine."Claim Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";
                                    lrc_SalesClaimLine."Claim Quantity" := 0;
                                    lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
                                    lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
                                    lrc_SalesClaimLine."Claim Sales Amount" := 0;
                                    lrc_SalesClaimLine."Claim Verlust" := 0;
                                    //Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
                                    //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
                                    gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.", BuyFromVendorNo,
                                                                                      VendorOrderNo, IstPackauftrag, PackauftragEindeutig);
                                    lrc_SalesClaimLine."Buy-from Vendor No." := BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
                                    lrc_SalesClaimLine."Vendor Order No." := VendorOrderNo;
                                    lrc_FruitVisionSetup.GET();
                                    FetchPriceFromOrder(lrc_SalesClaimLine);
                                    //Leergutinformationen mit übergeben
                                    lrc_SalesClaimLine."Empties Blanket Order No." := lrc_SalesShipmentLine."POI Empties Blanket Order No.";
                                    lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_SalesShipmentLine."POI Empt Blank Order Line No.";
                                    lrc_SalesClaimLine."Empties Item No." := lrc_SalesShipmentLine."POI Empties Item No.";
                                    lrc_SalesClaimLine."Empties Quantity" := lrc_SalesShipmentLine."POI Empties Quantity";
                                    lrc_SalesClaimLine.INSERT();
                                END;
                        END;
            UNTIL lrc_SalesShipmentLine.NEXT() = 0;

        // ---------------------------------------------------------------------------------------------
        // Auftragsnummer in Kopfsatz speichern
        // ---------------------------------------------------------------------------------------------
        rrc_SalesClaimAdviceHdr."Sales Invoice No." := '';
        rrc_SalesClaimAdviceHdr."Sales Shipment No." := vco_ShipmentNo;
        rrc_SalesClaimAdviceHdr."Sales Order No." := lrc_SalesShipmentHdr."Order No.";
        rrc_SalesClaimAdviceHdr."Sales Doc. Subtyp Code" := lrc_SalesShipmentHdr."POI Sales Doc. Subtype Code";
        rrc_SalesClaimAdviceHdr."Sales Salesperson Code" := lrc_SalesShipmentHdr."Salesperson Code";
        rrc_SalesClaimAdviceHdr."Location Code" := lrc_SalesShipmentHdr."Location Code";
        rrc_SalesClaimAdviceHdr."Claim Location Code" := lrc_SalesShipmentHdr."Location Code";

        rrc_SalesClaimAdviceHdr."Ship-to Code" := lrc_SalesShipmentHdr."Ship-to Code";
        rrc_SalesClaimAdviceHdr."Ship-to Name" := lrc_SalesShipmentHdr."Ship-to Name";
        rrc_SalesClaimAdviceHdr."Ship-to Name 2" := lrc_SalesShipmentHdr."Ship-to Name 2";
        rrc_SalesClaimAdviceHdr."Ship-to Address" := lrc_SalesShipmentHdr."Ship-to Address";
        rrc_SalesClaimAdviceHdr."Ship-to Address 2" := lrc_SalesShipmentHdr."Ship-to Address 2";
        rrc_SalesClaimAdviceHdr."Ship-to City" := lrc_SalesShipmentHdr."Ship-to City";
        rrc_SalesClaimAdviceHdr."Ship-to Contact" := lrc_SalesShipmentHdr."Ship-to Contact";
        rrc_SalesClaimAdviceHdr."Ship-to Post Code" := lrc_SalesShipmentHdr."Ship-to Post Code";
        rrc_SalesClaimAdviceHdr."Ship-to Country Code" := lrc_SalesShipmentHdr."Ship-to Country/Region Code";

        IF lrc_UserSetup.GET(UserID()) THEN
            IF lrc_UserSetup."POI Loc Group Filter Sales" <> '' THEN
                lrc_LocationGroup.GET(lrc_UserSetup."POI Loc Group Filter Sales");
        IF lrc_LocationGroup."Sales Claim Location Code" <> '' THEN
            rrc_SalesClaimAdviceHdr.VALIDATE("Claim Location Code", lrc_LocationGroup."Sales Claim Location Code");
    end;

    procedure LoadClaimFromInvoice(var rrc_SalesClaimAdviceHdr: Record "POI Sales Claim Notify Header"; vco_InvoiceNo: Code[20])
    var
        lrc_SalesInvoiceHdr: Record "Sales Invoice Header";
        AGILES_LT_TEXT001Txt: Label 'Es konnte keine Lieferung zur Rechnung %1 ermittelt werden!', Comment = '%1';
        AGILES_LT_TEXT002Txt: Label 'Rechnungsnr. %1 hat keine Auftragsnr.!', Comment = '%1';
    begin
        // -------------------------------------------------------------------------------------
        // Reklamation aus Rechnung laden
        // -------------------------------------------------------------------------------------

        IF vco_InvoiceNo = '' THEN
            EXIT;

        lrc_SalesInvoiceHdr.GET(vco_InvoiceNo);
        IF lrc_SalesInvoiceHdr."Order No." = '' THEN
            // Rechnungsnr. %1 hat keine Auftragsnr.!
            ERROR(AGILES_LT_TEXT002Txt, vco_InvoiceNo);

        lrc_SalesShipmentHdr.SETRANGE("Order No.", lrc_SalesInvoiceHdr."Order No.");
        IF NOT lrc_SalesShipmentHdr.FIND('-') THEN
            // Es konnte keine Lieferung zur Rechnung %1 ermittelt werden!
            ERROR(AGILES_LT_TEXT001Txt, vco_InvoiceNo);

        LoadClaimFromShipment(rrc_SalesClaimAdviceHdr, lrc_SalesShipmentHdr."No.");
        rrc_SalesClaimAdviceHdr."Sales Invoice No." := vco_InvoiceNo;
    end;

    //     procedure CheckClaimAdvice(vco_ClaimNo: Code[20])
    //     var
    //         lrc_SalesClaimHeader: Record "5110455";
    //         lrc_SalesClaimLine: Record "5110456";
    //         lrc_IncomingPallet: Record "5110445";
    //         ldc_QuantityBase: Decimal;
    //         ldc_SalesClaimLineQuantityBase: Decimal;
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Reklamation prüfen
    //         // -------------------------------------------------------------------------------------

    //         lrc_SalesClaimHeader.GET(vco_ClaimNo);

    //         lrc_SalesClaimLine.SETRANGE("Document No.",lrc_SalesClaimHeader."No.");
    //         IF lrc_SalesClaimLine.FIND('-') THEN BEGIN
    //           REPEAT

    //             IF lrc_SalesClaimLine."Claim Quantity" > 0 THEN BEGIN
    //               IF lrc_SalesClaimLine."Claim Sales Unit Price" = 0 THEN
    //                 IF NOT CONFIRM('Zeile : ' + FORMAT(lrc_SalesClaimLine."Line No.") +
    //                                ', für die Reklamation ' + lrc_SalesClaimLine.Description +
    //                                ' ist der Preis Null. Ist dies korrekt?') THEN
    //                   ERROR('');
    //               IF lrc_SalesClaimLine."Main Claim Reason Code" = '' THEN
    //                 ERROR('Zeile : ' + FORMAT(lrc_SalesClaimLine."Line No.") +
    //                       ', Bitte geben Sie den Hauptgrund für die Reklamation ein!');

    //             END ELSE BEGIN
    //               IF lrc_SalesClaimLine."Main Claim Reason Code" <> '' THEN
    //                 ERROR('Zeile : ' + FORMAT(lrc_SalesClaimLine."Line No.") +
    //                       ' Bitte entfernen Sie den Hauptgrund!');
    //             END;

    //             // PAL 001 00000000.s
    //             IF lrc_SalesClaimHeader."Pallet Entry ID" <> 0 THEN BEGIN
    //               ldc_QuantityBase := 0;

    //               IF lrc_SalesClaimLine."Claim Return Quantity" = TRUE THEN BEGIN

    //                 lrc_IncomingPallet.RESET();
    //                 lrc_IncomingPallet.SETRANGE("Entry No.", lrc_SalesClaimHeader."Pallet Entry ID");
    //                 lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Sales Claim Advice");
    //                 lrc_IncomingPallet.SETRANGE("Document No.", lrc_SalesClaimLine."Document No.");
    //                 lrc_IncomingPallet.SETRANGE("Document Line No.", lrc_SalesClaimLine."Line No.");
    //                 IF lrc_IncomingPallet.FIND('-') THEN BEGIN
    //                   ldc_QuantityBase := 0;
    //                   REPEAT
    //                     ldc_QuantityBase := ldc_QuantityBase + lrc_IncomingPallet."Quantity (Base)";
    //                   UNTIL lrc_IncomingPallet.NEXT() = 0;
    //                 END;

    //                 ldc_SalesClaimLineQuantityBase := lrc_SalesClaimLine."Claim Quantity" *
    //                                                   lrc_SalesClaimLine."Qty. per Unit of Measure";

    //                 IF lrc_SalesClaimLine."Claim Quantity" >= 0 THEN BEGIN
    //                   IF ldc_QuantityBase > ldc_SalesClaimLineQuantityBase THEN BEGIN
    //                     ERROR('Menge Basis %1 auf Paletten, ist größer als die Reklamationsmenge Basis %2 der Reklamationszeile %3!',
    //                           ldc_QuantityBase, ldc_SalesClaimLineQuantityBase, lrc_SalesClaimLine."Line No.");
    //                   END;
    //                 END ELSE BEGIN
    //                   IF ldc_QuantityBase < ldc_SalesClaimLineQuantityBase THEN BEGIN
    //                     ERROR('Menge Basis %1 auf Paletten, ist kleiner als die Reklamationsmenge Basis %2 der Reklamationszeile %3!',
    //                           ldc_QuantityBase, ldc_SalesClaimLineQuantityBase, lrc_SalesClaimLine."Line No.");
    //                   END;
    //                 END;
    //               END;
    //             END;
    //             // PAL 001 00000000.e

    //           UNTIL lrc_SalesClaimLine.next() = 0;
    //         END;
    //     end;

    procedure SalesClaimAdvLineCalcUnitPrice(vrc_SalesClaimAdviceLine: Record "POI Sales Claim Notify Line"): Decimal
    var
        lrc_PriceCalculation: Record "POI Price Base";
        //lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_UnitofMeasure: Record "Unit of Measure";
        //Text01Txt: Label 'Bitte geben Sie zuerst die Menge Kolli pro Palette ein!';
        Text02Txt: Label 'Bitte geben Sie zuerst die Menge ein!';
        ldc_Preis: Decimal;
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Kollo Preises
        // --------------------------------------------------------------------------------------


        // ---------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Preises bezogen auf die Verkaufseinheit
        // ---------------------------------------------------------------------------------------

        IF vrc_SalesClaimAdviceLine."Price Base (Sales Price)" = '' THEN
            EXIT(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)");


        lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price",
                                 vrc_SalesClaimAdviceLine."Price Base (Sales Price)");

        CASE lrc_PriceCalculation."Internal Calc. Type" OF

            // ---------------------------------------------------------------------------------------------
            // Preiseingabe entspricht dem Preis für einen Kollo --> Umrechnung in Verkaufseinheit
            // KOLLO: Menge (Kollo) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
                BEGIN
                    vrc_SalesClaimAdviceLine.TESTFIELD("Price Unit of Measure Code");
                    lrc_UnitofMeasure.GET(vrc_SalesClaimAdviceLine."Price Unit of Measure Code");
                    ldc_Preis := ROUND(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)" /
                                        lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" *
                                        vrc_SalesClaimAdviceLine."Qty. per Unit of Measure", 0.00001);
                    EXIT(ldc_Preis);
                END;


            // ---------------------------------------------------------------------------------------------
            // VERPACKUNG: Menge (Kollo) * Menge (UE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":
                IF vrc_SalesClaimAdviceLine."Partial Quantity (PQ)" = TRUE THEN BEGIN
                    ldc_Preis := vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)";
                    EXIT(ldc_Preis);
                END ELSE BEGIN
                    vrc_SalesClaimAdviceLine.TESTFIELD("Price Unit of Measure Code");
                    lrc_UnitofMeasure.GET(vrc_SalesClaimAdviceLine."Unit of Measure Code");
                    lrc_UnitofMeasure.TESTFIELD("POI Packing Unit of Meas (PU)", vrc_SalesClaimAdviceLine."Price Unit of Measure Code");
                    lrc_UnitofMeasure.TESTFIELD("POI Qty. (PU) per Unit of Meas");
                    ldc_Preis := ROUND(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)" *
                                        lrc_UnitofMeasure."POI Qty. (PU) per Unit of Meas", 0.00001);
                    EXIT(ldc_Preis);
                END;
            // ---------------------------------------------------------------------------------------------
            // INHALT: Menge (Kollo) * Menge (UE) * Menge (IE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
                ERROR('Preisberechnungsart nicht zulässig!');


            // ---------------------------------------------------------------------------------------------
            // BASIS: Menge (Kollo) * Menge (UE) * Menge (IE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
                BEGIN
                    vrc_SalesClaimAdviceLine.TESTFIELD("Base Unit of Measure (BU)");
                    ldc_Preis := ROUND(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)" *
                                        vrc_SalesClaimAdviceLine."Qty. per Unit of Measure", 0.00001);

                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // PALETTE: Menge (TE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
                IF vrc_SalesClaimAdviceLine."Partial Quantity (PQ)" = TRUE THEN
                    ERROR('Palettenpreis bei Anbruch nicht zulässig!')
                ELSE BEGIN
                    ldc_Preis := vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)";
                    IF vrc_SalesClaimAdviceLine."Qty. (Unit) per Transport (TU)" <> 0 THEN BEGIN
                        ldc_Preis := ROUND(ldc_Preis / vrc_SalesClaimAdviceLine."Qty. (Unit) per Transport (TU)", 0.00001);
                        EXIT(ldc_Preis);
                    END ELSE BEGIN
                        ldc_Preis := 0;
                        MESSAGE('Preis Null, da Menge pro Palette nicht vorhanden!');
                        EXIT(ldc_Preis);
                    END;
                END;

            // ---------------------------------------------------------------------------------------------
            // NETTO: Nettogewicht (gesamt) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
                BEGIN
                    ldc_Preis := ROUND(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)" *
                                       vrc_SalesClaimAdviceLine."Net Weight", 0.00001);
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // BRUTTO: Bruttogewicht (gesamt) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
                BEGIN
                    ldc_Preis := ROUND(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)" *
                                        vrc_SalesClaimAdviceLine."Gross Weight", 0.00001);
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // GESAMT: Gesamtpreis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Total Price":
                IF vrc_SalesClaimAdviceLine."Partial Quantity (PQ)" = TRUE THEN BEGIN
                    IF vrc_SalesClaimAdviceLine.Quantity <> 0 THEN BEGIN
                        ldc_Preis := ROUND(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)" /
                                           vrc_SalesClaimAdviceLine."Claim Quantity", 0.00001);
                        EXIT(ldc_Preis);
                    END ELSE
                        // Bitte geben Sie zuerst die Menge ein!
                        ERROR(Text02Txt);
                END ELSE
                    IF vrc_SalesClaimAdviceLine.Quantity <> 0 THEN BEGIN
                        ldc_Preis := ROUND(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)" /
                                           vrc_SalesClaimAdviceLine."Claim Quantity", 0.00001);
                        EXIT(ldc_Preis);
                    END ELSE
                        // Bitte geben Sie zuerst die Menge ein!
                        ERROR(Text02Txt);
            // ---------------------------------------------------------------------------------------------
            // Ausnahmeregelung
            // ---------------------------------------------------------------------------------------------
            ELSE
                EXIT(vrc_SalesClaimAdviceLine."Claim Sales Price (Price Base)");
        END;

    end;

    //     procedure BatchVarGetSalesClaims(vco_BatchVarNo: Code[20];vbn_ShowText: Boolean): Text[250]
    //     var
    //         lrc_SalesClaimLine: Record "5110456";
    //         lrc_SalesClaimAdviceReason: Record "5110457";
    //         lrc_ClaimAdviceReason: Record "5110421";
    //         ltx_SalesClaimReason: Text[250];
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Zusammenfassung von Verkaufsreklamationen aus einer Positionsvariante
    //         // ---------------------------------------------------------------------------------------

    //         ltx_SalesClaimReason := '';

    //         lrc_SalesClaimLine.SETRANGE("Batch Variant No.",vco_BatchVarNo);
    //         IF lrc_SalesClaimLine.FIND('-') THEN
    //           REPEAT

    //             lrc_SalesClaimAdviceReason.SETRANGE("Document No.",lrc_SalesClaimLine."Document No.");
    //             lrc_SalesClaimAdviceReason.SETRANGE("Doc. Line No.",lrc_SalesClaimLine."Line No.");
    //             IF lrc_SalesClaimAdviceReason.FIND('-') THEN
    //               REPEAT
    //                 IF vbn_ShowText = FALSE THEN BEGIN
    //                   IF ltx_SalesClaimReason = '' THEN BEGIN
    //                     ltx_SalesClaimReason := lrc_SalesClaimAdviceReason."Claim Reason Code";
    //                   END ELSE BEGIN
    //                     IF STRLEN(ltx_SalesClaimReason) < (STRLEN(lrc_SalesClaimAdviceReason."Claim Reason Code") + 4) THEN
    //                       ltx_SalesClaimReason := ltx_SalesClaimReason + ' / ' + lrc_SalesClaimAdviceReason."Claim Reason Code";
    //                   END;
    //                 END ELSE BEGIN
    //                   lrc_ClaimAdviceReason.GET(lrc_SalesClaimAdviceReason."Claim Reason Code");
    //                   IF ltx_SalesClaimReason = '' THEN BEGIN
    //                     ltx_SalesClaimReason := lrc_ClaimAdviceReason."Search Name";
    //                   END ELSE BEGIN
    //                     IF STRLEN(ltx_SalesClaimReason) < (STRLEN(lrc_ClaimAdviceReason."Search Name") + 4) THEN
    //                       ltx_SalesClaimReason := ltx_SalesClaimReason + ' / ' + lrc_ClaimAdviceReason."Search Name";
    //                   END;
    //                 END;
    //               UNTIL lrc_SalesClaimAdviceReason.next() = 0;

    //           UNTIL lrc_SalesClaimLine.next() = 0;

    //         EXIT(ltx_SalesClaimReason);
    //     end;

    //     procedure BatchVarShowSalesClaimLines(vco_MasterBatchNo: Code[20];vco_BatchNo: Code[20];vco_BatchVarNo: Code[20])
    //     var
    //         lrc_SalesClaimLine: Record "5110456";
    //         lfm_SalesClaimAdviceLines: Form "5110540";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Verkaufsreklamationen zu einer Partie/Position/Positionsvariante
    //         // -------------------------------------------------------------------------------------------

    //         IF vco_MasterBatchNo <> '' THEN
    //           lrc_SalesClaimLine.SETRANGE("Master Batch No.",vco_MasterBatchNo);
    //         IF vco_BatchNo <> '' THEN
    //           lrc_SalesClaimLine.SETRANGE("Batch No.",vco_BatchNo);
    //         IF vco_BatchVarNo <> '' THEN
    //           lrc_SalesClaimLine.SETRANGE("Batch Variant No.",vco_BatchVarNo);

    //         lfm_SalesClaimAdviceLines.SETTABLEVIEW(lrc_SalesClaimLine);
    //         lfm_SalesClaimAdviceLines.RUNMODAL();
    //     end;

    //     procedure CreateReservationBlock(vco_ClaimNo: Code[20])
    //     var
    //         lrc_SalesClaimAdvHeader: Record "5110455";
    //         lrc_SalesClaimAdvLine: Record "5110456";
    //         lrc_ReservationHeader: Record "5110448";
    //         lrc_ReservationLine: Record "5110449";
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Erstellung einer Reservierung zum Sperren von Ware
    //         // ---------------------------------------------------------------------------------------
    //         //********RS lt. DevTool nicht verwendet********
    //         lrc_SalesClaimAdvHeader.GET(vco_ClaimNo);

    //         lrc_SalesClaimAdvLine.SETRANGE("Document No.",lrc_SalesClaimAdvHeader."No.");
    //         //lrc_SalesClaimAdvLine.SETRANGE("Claiming Reaction",lrc_SalesClaimAdvLine."Claiming Reaction"::
    //         lrc_SalesClaimAdvLine.SETRANGE("Block Quantity",TRUE);
    //         lrc_SalesClaimAdvLine.SETFILTER("No.",'<>%1','');
    //         IF lrc_SalesClaimAdvLine.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_ReservationHeader.SETRANGE("Sales Claim No.",lrc_SalesClaimAdvHeader."No.");
    //             IF NOT lrc_ReservationHeader.FIND('-') THEN BEGIN
    //               lrc_ReservationHeader.RESET();
    //               lrc_ReservationHeader.INIT();
    //               lrc_ReservationHeader."No." := '';
    //               lrc_ReservationHeader."Source Reservation" := lrc_ReservationHeader."Source Reservation"::"Block Goods";
    //               lrc_ReservationHeader."Date of Reservation" := TODAY;
    //               lrc_ReservationHeader."Reserved Up To Date" := 31129999D;
    //               lrc_ReservationHeader."Sales Claim No." := lrc_SalesClaimAdvHeader."No.";
    //               lrc_ReservationHeader."Location Code" := lrc_SalesClaimAdvLine."Location Code";
    //               lrc_ReservationHeader.INSERT(TRUE);
    //             END;

    //             // Rservierungszeile zum Blockieren anlegen
    //             lrc_ReservationLine.RESET();
    //             lrc_ReservationLine.INIT();
    //             lrc_ReservationLine.INSERT(TRUE);

    //           UNTIL lrc_SalesClaimAdvLine.next() = 0;
    //         END;
    //     end;

    //     procedure LoadDataFromOriginDocInCrMemo(var rrc_SalesClaimAdviceHeader: Record "5110455";var rrc_SalesHeader: Record "36")
    //     var
    //         lrc_SalesDiscountOriginOrder: Record "5110344";
    //         lrc_SalesDiscountExist: Record "5110344";
    //         lrc_SalesDiscountHelp: Record "5110344";
    //         lrc_SalesDiscountNew: Record "5110344";
    //         lrc_SalesHeaderOriginOrder: Record "36";
    //         lrc_SalesShipmentHeader: Record "110";
    //         lrc_SalesInvoiceHeader: Record "112";
    //         lbn_OriginDocFound: Boolean;
    //         lcu_DiscountManagement: Codeunit "5110312";
    //         ldt_DocumentDateHelp: Date;
    //         lrc_SalesPostArchivDiscount: Record "5110390";
    //         lcu_CustomerSpecificFunctions: Codeunit "5110348";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lco_SearchSalesShipmentNo: Code[20];
    //         lrc_SalesClaimNotifyLine: Record "5110456";
    //         lrc_SalesInvoiceLine: Record "113";
    //     begin
    //         // -------------------------------------------------------------------------------------------------------------------
    //         // Funktion zum Laden von Rabatten, Currency für eine Gutschrift aus Ursprungsbeleg (Auftrag bzw. gebuchte Rechnung)
    //         // Wenn kein Ursprungsbeleg ausfindig ist, werden Debitoren- und Firmenrabatte nach Gültigkeitsdatum geholt
    //         // -------------------------------------------------------------------------------------------------------------------

    //         // Existierende Einträge entfernen
    //         lrc_SalesDiscountExist.RESET();
    //         lrc_SalesDiscountExist.SETRANGE(lrc_SalesDiscountExist."Document Type", lrc_SalesDiscountExist."Document Type"::"Credit Memo");
    //         lrc_SalesDiscountExist.SETRANGE(lrc_SalesDiscountExist."Document No.", rrc_SalesHeader."No.");
    //         lrc_SalesDiscountExist.DELETEALL(TRUE);

    //         lco_SearchSalesShipmentNo := rrc_SalesClaimAdviceHeader."Sales Shipment No.";

    //         lrc_FruitVisionSetup.get();

    //         // Auftrag suchen
    //         IF rrc_SalesClaimAdviceHeader."Sales Order No." <> '' THEN BEGIN
    //           IF lrc_SalesHeaderOriginOrder.GET(lrc_SalesHeaderOriginOrder."Document Type"::Order,
    //                                             rrc_SalesClaimAdviceHeader."Sales Order No.") THEN BEGIN

    //             // Currency und Shipment Method Code aus Ursprungsauftrag holen
    //             rrc_SalesHeader."Currency Code" := lrc_SalesHeaderOriginOrder."Currency Code";
    //             rrc_SalesHeader."Currency Factor" := lrc_SalesHeaderOriginOrder."Currency Factor";
    //             rrc_SalesHeader."Shipment Method Code" := lrc_SalesHeaderOriginOrder."Shipment Method Code";
    //             rrc_SalesHeader."Appendix Shipment Method" := lrc_SalesHeaderOriginOrder."Appendix Shipment Method";

    //             rrc_SalesHeader."Arrival Region Code" := lrc_SalesHeaderOriginOrder."Arrival Region Code";

    //             rrc_SalesHeader."Customer Posting Group" := lrc_SalesHeaderOriginOrder."Customer Posting Group";
    //             rrc_SalesHeader."Customer Price Group" := lrc_SalesHeaderOriginOrder."Customer Price Group";

    //             //POI 001 00000000 JST 291112 000 Claim Location und "Claim Shipping Agent Code" entscheidend
    //             //rrc_SalesHeader."Shipping Agent Code" := lrc_SalesHeaderOriginOrder."Shipping Agent Code";
    //             IF rrc_SalesHeader."Shipping Agent Code" = '' //UrsprungsZusteller nur, wenn nicht vorher eingetragen
    //               THEN rrc_SalesHeader."Shipping Agent Code":= lrc_SalesHeaderOriginOrder."Shipping Agent Code";
    //             //location ?? wird hier nicht aus dem Ursprung übernommen

    //             rrc_SalesHeader."Freight Calculation" := lrc_SalesHeaderOriginOrder."Freight Calculation";

    //             rrc_SalesHeader."Means of Transport Type" := lrc_SalesHeaderOriginOrder."Means of Transport Type";
    //             rrc_SalesHeader."Means of Transport Code" := lrc_SalesHeaderOriginOrder."Means of Transport Code";
    //             rrc_SalesHeader."Means of Transport Info" := lrc_SalesHeaderOriginOrder."Means of Transport Info";

    //             rrc_SalesHeader."Sell-to Customer Name" := lrc_SalesHeaderOriginOrder."Sell-to Customer Name";
    //             rrc_SalesHeader."Sell-to Customer Name 2" := lrc_SalesHeaderOriginOrder."Sell-to Customer Name 2";
    //             rrc_SalesHeader."Sell-to Address" := lrc_SalesHeaderOriginOrder."Sell-to Address";
    //             rrc_SalesHeader."Sell-to Address 2" := lrc_SalesHeaderOriginOrder."Sell-to Address 2";
    //             rrc_SalesHeader."Sell-to City" := lrc_SalesHeaderOriginOrder."Sell-to City";
    //             rrc_SalesHeader."Sell-to Contact" := lrc_SalesHeaderOriginOrder."Sell-to Contact";
    //             rrc_SalesHeader."Sell-to Post Code" := lrc_SalesHeaderOriginOrder."Sell-to Post Code";
    //             rrc_SalesHeader."Sell-to County" := lrc_SalesHeaderOriginOrder."Sell-to County";
    //             rrc_SalesHeader."Sell-to Country/Region Code" := lrc_SalesHeaderOriginOrder."Sell-to Country/Region Code";

    //             rrc_SalesHeader."Ship-to Code" := lrc_SalesHeaderOriginOrder."Ship-to Code";
    //             rrc_SalesHeader."Ship-to Name" := lrc_SalesHeaderOriginOrder."Ship-to Name";
    //             rrc_SalesHeader."Ship-to Name 2" := lrc_SalesHeaderOriginOrder."Ship-to Name 2";
    //             rrc_SalesHeader."Ship-to Address" := lrc_SalesHeaderOriginOrder."Ship-to Address";
    //             rrc_SalesHeader."Ship-to Address 2" := lrc_SalesHeaderOriginOrder."Ship-to Address 2";
    //             rrc_SalesHeader."Ship-to City" := lrc_SalesHeaderOriginOrder."Ship-to City";
    //             rrc_SalesHeader."Ship-to Contact" := lrc_SalesHeaderOriginOrder."Ship-to Contact";
    //             rrc_SalesHeader."Ship-to Post Code" := lrc_SalesHeaderOriginOrder."Ship-to Post Code";
    //             rrc_SalesHeader."Ship-to County" := lrc_SalesHeaderOriginOrder."Ship-to County";
    //             //RS VALIDATE um länderspezifische VAT ID zu laden
    //             //rrc_SalesHeader."Ship-to Country/Region Code" := lrc_SalesHeaderOriginOrder."Ship-to Country/Region Code";
    //             rrc_SalesHeader.VALIDATE("Ship-to Country/Region Code", lrc_SalesHeaderOriginOrder."Ship-to Country/Region Code");
    //             rrc_SalesHeader."Bill-to Customer No." := lrc_SalesHeaderOriginOrder."Bill-to Customer No.";
    //             rrc_SalesHeader."Bill-to Name" := lrc_SalesHeaderOriginOrder."Bill-to Name";
    //             rrc_SalesHeader."Bill-to Name 2" := lrc_SalesHeaderOriginOrder."Bill-to Name 2";
    //             rrc_SalesHeader."Bill-to Address" := lrc_SalesHeaderOriginOrder."Bill-to Address";
    //             rrc_SalesHeader."Bill-to Address 2" := lrc_SalesHeaderOriginOrder."Bill-to Address 2";
    //             rrc_SalesHeader."Bill-to City" := lrc_SalesHeaderOriginOrder."Bill-to City";
    //             rrc_SalesHeader."Bill-to Contact" := lrc_SalesHeaderOriginOrder."Bill-to Contact";
    //             rrc_SalesHeader."Bill-to Post Code" := lrc_SalesHeaderOriginOrder."Bill-to Post Code";
    //             rrc_SalesHeader."Bill-to County" := lrc_SalesHeaderOriginOrder."Bill-to County";
    //             rrc_SalesHeader."Bill-to Country/Region Code" := lrc_SalesHeaderOriginOrder."Bill-to Country/Region Code";

    //             rrc_SalesHeader."Status Customs Duty" := lrc_SalesHeaderOriginOrder."Status Customs Duty";

    //             rrc_SalesHeader."Customer Group Code" :=  lrc_SalesHeaderOriginOrder."Customer Group Code";
    //             rrc_SalesHeader."Source Type Liability TU" :=  lrc_SalesHeaderOriginOrder."Source Type Liability TU";
    //             rrc_SalesHeader."Source No. Liability TU" :=  lrc_SalesHeaderOriginOrder."Source No. Liability TU";
    //             rrc_SalesHeader."Split Sales Order to Cust. No." :=  lrc_SalesHeaderOriginOrder."Split Sales Order to Cust. No.";
    //             rrc_SalesHeader."Service Invoice to Cust. No." :=  lrc_SalesHeaderOriginOrder."Service Invoice to Cust. No.";
    //             rrc_SalesHeader."Temp Ship-to Code" :=  lrc_SalesHeaderOriginOrder."Temp Ship-to Code";

    //             rrc_SalesHeader.Modify();


    //             // Rabatte von Ursprungsauftrag finden
    //             lrc_SalesDiscountOriginOrder.SETRANGE("Document Type", lrc_SalesDiscountOriginOrder."Document Type"::Order );
    //             lrc_SalesDiscountOriginOrder.SETRANGE("Document No.", lrc_SalesHeaderOriginOrder."No.");
    //             IF lrc_SalesDiscountOriginOrder.FINDSET(FALSE,FALSE) THEN BEGIN
    //               REPEAT
    //                 lrc_SalesDiscountNew."Document Type" := lrc_SalesDiscountNew."Document Type"::"Credit Memo";
    //                 lrc_SalesDiscountNew."Document No." := rrc_SalesHeader."No.";
    //                 lrc_SalesDiscountNew."Entry No." := 0;

    //                 lrc_SalesDiscountNew."Discount Code" := lrc_SalesDiscountOriginOrder."Discount Code";
    //                 lrc_SalesDiscountNew."Discount Description" := lrc_SalesDiscountOriginOrder."Discount Description";
    //                 lrc_SalesDiscountNew."Discount Type" := lrc_SalesDiscountOriginOrder."Discount Type";
    //                 lrc_SalesDiscountNew."Base Discount Value" := lrc_SalesDiscountOriginOrder."Base Discount Value";
    //                 lrc_SalesDiscountNew."Discount Value" := lrc_SalesDiscountOriginOrder."Discount Value";
    //                 lrc_SalesDiscountNew."Basis %-Value incl. VAT" := lrc_SalesDiscountOriginOrder."Basis %-Value incl. VAT";
    //                 lrc_SalesDiscountNew."Payment Timing" := lrc_SalesDiscountOriginOrder."Payment Timing";
    //                 lrc_SalesDiscountNew."Currency Code" := lrc_SalesDiscountOriginOrder."Currency Code";
    //                 lrc_SalesDiscountNew."Currency Factor" := lrc_SalesDiscountOriginOrder."Currency Factor";
    //                 lrc_SalesDiscountNew."Sell-to Customer No." := lrc_SalesDiscountOriginOrder."Sell-to Customer No.";
    //                 lrc_SalesDiscountNew."Restrict. Freight Unit" := lrc_SalesDiscountOriginOrder."Restrict. Freight Unit";
    //                 lrc_SalesDiscountNew."Item No." := lrc_SalesDiscountOriginOrder."Item No.";
    //                 lrc_SalesDiscountNew."Product Group Code" := lrc_SalesDiscountOriginOrder."Product Group Code";
    //                 lrc_SalesDiscountNew."Item Category Code" := lrc_SalesDiscountOriginOrder."Item Category Code";
    //                 lrc_SalesDiscountNew."Vendor No." := lrc_SalesDiscountOriginOrder."Vendor No.";
    //                 // DMG 001 DMG50043.s
    //                 // lrc_SalesDiscountNew."Discount Depend on Weight" := lrc_SalesDiscountOriginOrder."Discount Depend on Weight";
    //                 // DMG 001 DMG50043.e

    //                 lrc_SalesDiscountNew."Person in Charge Code" := lrc_SalesDiscountOriginOrder."Person in Charge Code";
    //                 lrc_SalesDiscountNew."Status Customs Duty" := lrc_SalesDiscountOriginOrder."Status Customs Duty";


    //                 lrc_SalesDiscountNew."Calculation Level" := lrc_SalesDiscountOriginOrder."Calculation Level";
    //                 lrc_SalesDiscountNew."Discount Source" := lrc_SalesDiscountOriginOrder."Discount Source";
    //                 lrc_SalesDiscountNew."Ref. Disc. Depend on Weight" :=  lrc_SalesDiscountOriginOrder."Ref. Disc. Depend on Weight";
    //                 lrc_SalesDiscountNew."Discount not on Customer Duty" := lrc_SalesDiscountOriginOrder."Discount not on Customer Duty";
    //                 //lrc_SalesDiscountNew." := lrc_SalesDiscountOriginOrder."Customer Price Group";
    //                 lrc_SalesDiscountNew."Ship-to Address Code" := lrc_SalesDiscountOriginOrder."Ship-to Address Code";
    //                 //lrc_SalesDiscountNew."Document Posting Date" := ;
    //                 lrc_SalesDiscountNew."Restrict. Transport Unit" := lrc_SalesDiscountOriginOrder."Restrict. Transport Unit";
    //                 lrc_SalesDiscountNew."Unit of Measure Code" := lrc_SalesDiscountOriginOrder."Unit of Measure Code";
    //                 lrc_SalesDiscountNew."Trademark Code" := lrc_SalesDiscountOriginOrder."Trademark Code";
    //                 lrc_SalesDiscountNew."Vendor Country Group" := lrc_SalesDiscountOriginOrder."Vendor Country Group";
    //                 lrc_SalesDiscountNew."Service Invoice Customer No." := lrc_SalesDiscountOriginOrder."Service Invoice Customer No.";
    //                 lrc_SalesDiscountNew."Im Folgelevel nicht berücksich" := lrc_SalesDiscountOriginOrder."Im Folgelevel nicht berücksich";
    //                 lrc_SalesDiscountNew."Posting to Sell-to Customer" := lrc_SalesDiscountOriginOrder."Posting to Sell-to Customer";

    //                 lrc_SalesDiscountNew."Not Valid for" := lrc_SalesPostArchivDiscount."Not Valid for";
    //                 lrc_SalesDiscountNew."Not Valid for Filter" := lrc_SalesPostArchivDiscount."Not Valid for Filter";
    //                 lrc_SalesDiscountNew."Shipment Method Code"  :=  lrc_SalesPostArchivDiscount."Shipment Method";
    //                 lrc_SalesDiscountNew."Location Code" := lrc_SalesPostArchivDiscount."Location Code";
    //                 lrc_SalesDiscountNew.INSERT(TRUE);
    //               UNTIL lrc_SalesDiscountOriginOrder.next() = 0;
    //             END;
    //             EXIT;

    //           //DMG 007 DMG50193.s
    //           // Nur Auftragsnummer vorhanden, dann letzte Lieferung zur Auftragsnummer suchen
    //           END ELSE BEGIN
    //             //IF (rrc_SalesClaimAdviceHeader."Sales Order No." <> '') AND (rrc_SalesClaimAdviceHeader."Sales Shipment No." = '') AND
    //             //      (rrc_SalesClaimAdviceHeader."Sales Invoice No." = '') THEN BEGIN
    //             IF (rrc_SalesClaimAdviceHeader."Sales Order No." <> '') AND (lco_SearchSalesShipmentNo = '') AND
    //                   (rrc_SalesClaimAdviceHeader."Sales Invoice No." = '') THEN BEGIN

    //               lrc_SalesShipmentHeader.SETCURRENTKEY("Order No.");
    //               lrc_SalesShipmentHeader.SETRANGE("Order No.",rrc_SalesClaimAdviceHeader."Sales Order No.");
    //               //RS-Filterung auf neuere Daten da bei PIB doppelte Auftragsnummern
    //               lrc_SalesShipmentHeader.SETFILTER("Posting Date",'%1..', 010114D);
    //               IF lrc_SalesShipmentHeader.FIND('+') THEN BEGIN

    //                 rrc_SalesHeader."Currency Code" := lrc_SalesShipmentHeader."Currency Code";
    //                 rrc_SalesHeader."Currency Factor" := lrc_SalesShipmentHeader."Currency Factor";
    //                 rrc_SalesHeader."Shipment Method Code" := lrc_SalesShipmentHeader."Shipment Method Code";
    //                 rrc_SalesHeader."Appendix Shipment Method" := lrc_SalesShipmentHeader."Appendix Shipment Method";

    //                 rrc_SalesHeader."Arrival Region Code" := lrc_SalesShipmentHeader."Arrival Region Code";

    //                 rrc_SalesHeader."Customer Posting Group" := lrc_SalesShipmentHeader."Customer Posting Group";
    //                 rrc_SalesHeader."Customer Price Group" := lrc_SalesShipmentHeader."Customer Price Group";

    //                 //POI 001 00000000 JST 291112 000 Claim Location und "Claim Shipping Agent Code" entscheidend
    //                 //rrc_SalesHeader."Shipping Agent Code" := lrc_SalesShipmentHeader."Shipping Agent Code";
    //                 IF rrc_SalesHeader."Shipping Agent Code" = ''
    //                   THEN  rrc_SalesHeader."Shipping Agent Code" := lrc_SalesShipmentHeader."Shipping Agent Code";
    //                 //Location ?? wird hier nicht mit übernommen

    //                 rrc_SalesHeader."Freight Calculation" := lrc_SalesShipmentHeader."Freight Calculation";

    //                 rrc_SalesHeader."Sell-to Customer Name" := lrc_SalesShipmentHeader."Sell-to Customer Name";
    //                 rrc_SalesHeader."Sell-to Customer Name 2" := lrc_SalesShipmentHeader."Sell-to Customer Name 2";
    //                 rrc_SalesHeader."Sell-to Address" := lrc_SalesShipmentHeader."Sell-to Address";
    //                 rrc_SalesHeader."Sell-to Address 2" := lrc_SalesShipmentHeader."Sell-to Address 2";
    //                 rrc_SalesHeader."Sell-to City" := lrc_SalesShipmentHeader."Sell-to City";
    //                 rrc_SalesHeader."Sell-to Contact" := lrc_SalesShipmentHeader."Sell-to Contact";
    //                 rrc_SalesHeader."Sell-to Post Code" := lrc_SalesShipmentHeader."Sell-to Post Code";
    //                 rrc_SalesHeader."Sell-to County" := lrc_SalesShipmentHeader."Sell-to County";
    //                 rrc_SalesHeader."Sell-to Country/Region Code" := lrc_SalesShipmentHeader."Sell-to Country/Region Code";

    //                 rrc_SalesHeader."Ship-to Code" := lrc_SalesShipmentHeader."Ship-to Code";
    //                 rrc_SalesHeader."Ship-to Name" := lrc_SalesShipmentHeader."Ship-to Name";
    //                 rrc_SalesHeader."Ship-to Name 2" := lrc_SalesShipmentHeader."Ship-to Name 2";
    //                 rrc_SalesHeader."Ship-to Address" := lrc_SalesShipmentHeader."Ship-to Address";
    //                 rrc_SalesHeader."Ship-to Address 2" := lrc_SalesShipmentHeader."Ship-to Address 2";
    //                 rrc_SalesHeader."Ship-to City" := lrc_SalesShipmentHeader."Ship-to City";
    //                 rrc_SalesHeader."Ship-to Contact" := lrc_SalesShipmentHeader."Ship-to Contact";
    //                 rrc_SalesHeader."Ship-to Post Code" := lrc_SalesShipmentHeader."Ship-to Post Code";
    //                 rrc_SalesHeader."Ship-to County" := lrc_SalesShipmentHeader."Ship-to County";
    //                 rrc_SalesHeader."Ship-to Country/Region Code" := lrc_SalesShipmentHeader."Ship-to Country/Region Code";

    //                 rrc_SalesHeader."Bill-to Customer No." := lrc_SalesShipmentHeader."Bill-to Customer No.";
    //                 rrc_SalesHeader."Bill-to Name" := lrc_SalesShipmentHeader."Bill-to Name";
    //                 rrc_SalesHeader."Bill-to Name 2" := lrc_SalesShipmentHeader."Bill-to Name 2";
    //                 rrc_SalesHeader."Bill-to Address" := lrc_SalesShipmentHeader."Bill-to Address";
    //                 rrc_SalesHeader."Bill-to Address 2" := lrc_SalesShipmentHeader."Bill-to Address 2";
    //                 rrc_SalesHeader."Bill-to City" := lrc_SalesShipmentHeader."Bill-to City";
    //                 rrc_SalesHeader."Bill-to Contact" := lrc_SalesShipmentHeader."Bill-to Contact";
    //                 rrc_SalesHeader."Bill-to Post Code" := lrc_SalesShipmentHeader."Bill-to Post Code";
    //                 rrc_SalesHeader."Bill-to County" := lrc_SalesShipmentHeader."Bill-to County";
    //                 rrc_SalesHeader."Bill-to Country/Region Code" := lrc_SalesShipmentHeader."Bill-to Country/Region Code";

    //                 rrc_SalesHeader."Status Customs Duty" := lrc_SalesShipmentHeader."Status Customs Duty";

    //                 rrc_SalesHeader."Customer Group Code" :=  lrc_SalesShipmentHeader."Customer Group Code";
    //                 rrc_SalesHeader."Source Type Liability TU" :=  lrc_SalesShipmentHeader."Source Type Liability TU";
    //                 rrc_SalesHeader."Source No. Liability TU" :=  lrc_SalesShipmentHeader."Source No. Liability TU";
    //                 rrc_SalesHeader."Split Sales Order to Cust. No." :=  lrc_SalesShipmentHeader."Split Sales Order to Cust. No.";
    //                 rrc_SalesHeader."Service Invoice to Cust. No." :=  lrc_SalesShipmentHeader."Service Invoice to Cust. No.";
    //                 rrc_SalesHeader."Temp Ship-to Code" :=  lrc_SalesShipmentHeader."Temp Ship-to Code";

    //                 lrc_FruitVisionSetup.get();

    //                 rrc_SalesHeader.Modify();
    //                 //RS Rabatte laden eingefügt
    //                 // Rabatte von Ursprungsauftrag finden
    //                 lrc_SalesDiscountOriginOrder.SETRANGE("Document Type", lrc_SalesDiscountOriginOrder."Document Type"::Order );
    //                 //lrc_SalesDiscountOriginOrder.SETRANGE("Document No.", lrc_SalesHeaderOriginOrder."No.");
    //                 lrc_SalesDiscountOriginOrder.SETRANGE("Document No.", rrc_SalesClaimAdviceHeader."Sales Order No.");
    //                 IF lrc_SalesDiscountOriginOrder.FINDSET(FALSE,FALSE) THEN BEGIN
    //                   REPEAT
    //                     lrc_SalesDiscountNew."Document Type" := lrc_SalesDiscountNew."Document Type"::"Credit Memo";
    //                     lrc_SalesDiscountNew."Document No." := rrc_SalesHeader."No.";
    //                     lrc_SalesDiscountNew."Entry No." := 0;
    //                     lrc_SalesDiscountNew."Discount Code" := lrc_SalesDiscountOriginOrder."Discount Code";
    //                     lrc_SalesDiscountNew."Discount Description" := lrc_SalesDiscountOriginOrder."Discount Description";
    //                     lrc_SalesDiscountNew."Discount Type" := lrc_SalesDiscountOriginOrder."Discount Type";
    //                     lrc_SalesDiscountNew."Base Discount Value" := lrc_SalesDiscountOriginOrder."Base Discount Value";
    //                     lrc_SalesDiscountNew."Discount Value" := lrc_SalesDiscountOriginOrder."Discount Value";
    //                     lrc_SalesDiscountNew."Basis %-Value incl. VAT" := lrc_SalesDiscountOriginOrder."Basis %-Value incl. VAT";
    //                     lrc_SalesDiscountNew."Payment Timing" := lrc_SalesDiscountOriginOrder."Payment Timing";
    //                     lrc_SalesDiscountNew."Currency Code" := lrc_SalesDiscountOriginOrder."Currency Code";
    //                     lrc_SalesDiscountNew."Currency Factor" := lrc_SalesDiscountOriginOrder."Currency Factor";
    //                     lrc_SalesDiscountNew."Sell-to Customer No." := lrc_SalesDiscountOriginOrder."Sell-to Customer No.";
    //                     lrc_SalesDiscountNew."Restrict. Freight Unit" := lrc_SalesDiscountOriginOrder."Restrict. Freight Unit";
    //                     lrc_SalesDiscountNew."Item No." := lrc_SalesDiscountOriginOrder."Item No.";
    //                     lrc_SalesDiscountNew."Product Group Code" := lrc_SalesDiscountOriginOrder."Product Group Code";
    //                     lrc_SalesDiscountNew."Item Category Code" := lrc_SalesDiscountOriginOrder."Item Category Code";
    //                     lrc_SalesDiscountNew."Vendor No." := lrc_SalesDiscountOriginOrder."Vendor No.";
    //                     // DMG 001 DMG50043.s
    //                     // lrc_SalesDiscountNew."Discount Depend on Weight" := lrc_SalesDiscountOriginOrder."Discount Depend on Weight";
    //                     // DMG 001 DMG50043.e
    //                     lrc_SalesDiscountNew."Person in Charge Code" := lrc_SalesDiscountOriginOrder."Person in Charge Code";
    //                     lrc_SalesDiscountNew."Status Customs Duty" := lrc_SalesDiscountOriginOrder."Status Customs Duty";
    //                     lrc_SalesDiscountNew."Calculation Level" := lrc_SalesDiscountOriginOrder."Calculation Level";
    //                     lrc_SalesDiscountNew."Discount Source" := lrc_SalesDiscountOriginOrder."Discount Source";
    //                     lrc_SalesDiscountNew."Ref. Disc. Depend on Weight" :=  lrc_SalesDiscountOriginOrder."Ref. Disc. Depend on Weight";
    //                     lrc_SalesDiscountNew."Discount not on Customer Duty" := lrc_SalesDiscountOriginOrder."Discount not on Customer Duty";
    //                     //lrc_SalesDiscountNew." := lrc_SalesDiscountOriginOrder."Customer Price Group";
    //                     lrc_SalesDiscountNew."Ship-to Address Code" := lrc_SalesDiscountOriginOrder."Ship-to Address Code";
    //                     //lrc_SalesDiscountNew."Document Posting Date" := ;
    //                     lrc_SalesDiscountNew."Restrict. Transport Unit" := lrc_SalesDiscountOriginOrder."Restrict. Transport Unit";
    //                     lrc_SalesDiscountNew."Unit of Measure Code" := lrc_SalesDiscountOriginOrder."Unit of Measure Code";
    //                     lrc_SalesDiscountNew."Trademark Code" := lrc_SalesDiscountOriginOrder."Trademark Code";
    //                     lrc_SalesDiscountNew."Vendor Country Group" := lrc_SalesDiscountOriginOrder."Vendor Country Group";
    //                     lrc_SalesDiscountNew."Service Invoice Customer No." := lrc_SalesDiscountOriginOrder."Service Invoice Customer No.";
    //                     lrc_SalesDiscountNew."Im Folgelevel nicht berücksich" := lrc_SalesDiscountOriginOrder."Im Folgelevel nicht berücksich";
    //                     lrc_SalesDiscountNew."Posting to Sell-to Customer" := lrc_SalesDiscountOriginOrder."Posting to Sell-to Customer";
    //                     lrc_SalesDiscountNew."Not Valid for" := lrc_SalesPostArchivDiscount."Not Valid for";
    //                     lrc_SalesDiscountNew."Not Valid for Filter" := lrc_SalesPostArchivDiscount."Not Valid for Filter";
    //                     lrc_SalesDiscountNew."Shipment Method Code"  :=  lrc_SalesPostArchivDiscount."Shipment Method";
    //                     lrc_SalesDiscountNew."Location Code" := lrc_SalesPostArchivDiscount."Location Code";
    //                     lrc_SalesDiscountNew.INSERT(TRUE);
    //                   UNTIL lrc_SalesDiscountOriginOrder.next() = 0;
    //                 END;
    //                 EXIT;
    //               END;
    //             END;
    //           END;
    //           //DMG 007 DMG50193.e
    //         END;

    //         // Gebuchte Rechnung durch Lieferung und dort vorhandene Auftragsnummer suchen, wenn Auftrag nicht gefunden wurde
    //         //IF rrc_SalesClaimAdviceHeader."Sales Shipment No." <> '' THEN BEGIN
    //         //  IF lrc_SalesShipmentHeader.GET( rrc_SalesClaimAdviceHeader."Sales Shipment No.") THEN BEGIN

    //         IF lco_SearchSalesShipmentNo <> '' THEN BEGIN
    //           IF lrc_SalesShipmentHeader.GET( lco_SearchSalesShipmentNo ) THEN BEGIN

    //             lrc_SalesInvoiceHeader.RESET();
    //             lrc_SalesInvoiceHeader.SETCURRENTKEY("Order No.");
    //             lrc_SalesInvoiceHeader.SETRANGE("Order No.", lrc_SalesShipmentHeader."Order No.");
    //             //RS Abgrenzung auf Datum, da bei PIB doppelte Auftragsnummern
    //             lrc_SalesInvoiceHeader.SETFILTER("Posting Date", '%1..', 010114D);
    //             IF lrc_SalesInvoiceHeader.FINDFIRST() THEN BEGIN

    //               // FV4 002 FV400014.s
    //               // Currency und Shipment Method Code aus Ursprungsauftrag holen
    //               rrc_SalesHeader."Currency Code" := lrc_SalesInvoiceHeader."Currency Code";
    //               rrc_SalesHeader."Currency Factor" := lrc_SalesInvoiceHeader."Currency Factor";
    //               rrc_SalesHeader."Shipment Method Code" := lrc_SalesInvoiceHeader."Shipment Method Code";
    //               rrc_SalesHeader."Appendix Shipment Method" := lrc_SalesInvoiceHeader."Appendix Shipment Method";

    //               rrc_SalesHeader."Arrival Region Code" := lrc_SalesInvoiceHeader."Arrival Region Code";

    //               rrc_SalesHeader."Customer Posting Group" := lrc_SalesInvoiceHeader."Customer Posting Group";
    //               rrc_SalesHeader."Customer Price Group" := lrc_SalesInvoiceHeader."Customer Price Group";

    //               //POI 001 00000000 JST 291112 000 Claim Location und "Claim Shipping Agent Code" entscheidend
    //               IF rrc_SalesHeader."Shipping Agent Code" = ''
    //                 THEN rrc_SalesHeader."Shipping Agent Code" := lrc_SalesInvoiceHeader."Shipping Agent Code";
    //               //Loaction ?? wird hier nicht übernommen

    //               rrc_SalesHeader."Freight Calculation" := lrc_SalesInvoiceHeader."Freight Calculation";

    //               rrc_SalesHeader."Sell-to Customer Name" := lrc_SalesInvoiceHeader."Sell-to Customer Name";
    //               rrc_SalesHeader."Sell-to Customer Name 2" := lrc_SalesInvoiceHeader."Sell-to Customer Name 2";
    //               rrc_SalesHeader."Sell-to Address" := lrc_SalesInvoiceHeader."Sell-to Address";
    //               rrc_SalesHeader."Sell-to Address 2" := lrc_SalesInvoiceHeader."Sell-to Address 2";
    //               rrc_SalesHeader."Sell-to City" := lrc_SalesInvoiceHeader."Sell-to City";
    //               rrc_SalesHeader."Sell-to Contact" := lrc_SalesInvoiceHeader."Sell-to Contact";
    //               rrc_SalesHeader."Sell-to Post Code" := lrc_SalesInvoiceHeader."Sell-to Post Code";
    //               rrc_SalesHeader."Sell-to County" := lrc_SalesInvoiceHeader."Sell-to County";
    //               rrc_SalesHeader."Sell-to Country/Region Code" := lrc_SalesInvoiceHeader."Sell-to Country/Region Code";

    //               rrc_SalesHeader."Ship-to Code" := lrc_SalesInvoiceHeader."Ship-to Code";
    //               rrc_SalesHeader."Ship-to Name" := lrc_SalesInvoiceHeader."Ship-to Name";
    //               rrc_SalesHeader."Ship-to Name 2" := lrc_SalesInvoiceHeader."Ship-to Name 2";
    //               rrc_SalesHeader."Ship-to Address" := lrc_SalesInvoiceHeader."Ship-to Address";
    //               rrc_SalesHeader."Ship-to Address 2" := lrc_SalesInvoiceHeader."Ship-to Address 2";
    //               rrc_SalesHeader."Ship-to City" := lrc_SalesInvoiceHeader."Ship-to City";
    //               rrc_SalesHeader."Ship-to Contact" := lrc_SalesInvoiceHeader."Ship-to Contact";
    //               rrc_SalesHeader."Ship-to Post Code" := lrc_SalesInvoiceHeader."Ship-to Post Code";
    //               rrc_SalesHeader."Ship-to County" := lrc_SalesInvoiceHeader."Ship-to County";
    //               rrc_SalesHeader."Ship-to Country/Region Code" := lrc_SalesInvoiceHeader."Ship-to Country/Region Code";

    //               rrc_SalesHeader."Bill-to Customer No." := lrc_SalesInvoiceHeader."Bill-to Customer No.";
    //               rrc_SalesHeader."Bill-to Name" := lrc_SalesInvoiceHeader."Bill-to Name";
    //               rrc_SalesHeader."Bill-to Name 2" := lrc_SalesInvoiceHeader."Bill-to Name 2";
    //               rrc_SalesHeader."Bill-to Address" := lrc_SalesInvoiceHeader."Bill-to Address";
    //               rrc_SalesHeader."Bill-to Address 2" := lrc_SalesInvoiceHeader."Bill-to Address 2";
    //               rrc_SalesHeader."Bill-to City" := lrc_SalesInvoiceHeader."Bill-to City";
    //               rrc_SalesHeader."Bill-to Contact" := lrc_SalesInvoiceHeader."Bill-to Contact";
    //               rrc_SalesHeader."Bill-to Post Code" := lrc_SalesInvoiceHeader."Bill-to Post Code";
    //               rrc_SalesHeader."Bill-to County" := lrc_SalesInvoiceHeader."Bill-to County";
    //               rrc_SalesHeader."Bill-to Country/Region Code" := lrc_SalesInvoiceHeader."Bill-to Country/Region Code";

    //               // FV4 004 00000000.s
    //               rrc_SalesHeader."Status Customs Duty" := lrc_SalesInvoiceHeader."Status Customs Duty";
    //               // FV4 004 00000000.e

    //               // IFW 001 00000000.s
    //               rrc_SalesHeader."Customer Group Code" :=  lrc_SalesInvoiceHeader."Customer Group Code";
    //               rrc_SalesHeader."Source Type Liability TU" :=  lrc_SalesInvoiceHeader."Source Type Liability TE";
    //               rrc_SalesHeader."Source No. Liability TU" :=  lrc_SalesInvoiceHeader."Source No. Liability TU";
    //               rrc_SalesHeader."Split Sales Order to Cust. No." :=  lrc_SalesInvoiceHeader."Sales Order Customer No.";
    //               rrc_SalesHeader."Service Invoice to Cust. No." :=  lrc_SalesInvoiceHeader."Service Invoice Customer No.";
    //               rrc_SalesHeader."Temp Ship-to Code" :=  lrc_SalesInvoiceHeader."Temp Ship-to Code";
    //               // IFW 001 00000000.e

    //               rrc_SalesHeader.Modify();


    //               // Rabatte von Ursprungsauftrag finden
    //               lrc_SalesPostArchivDiscount.SETRANGE("Document Type", lrc_SalesPostArchivDiscount."Document Type"::"Posted Invoice");
    //               lrc_SalesPostArchivDiscount.SETRANGE("Document No.", lrc_SalesInvoiceHeader."No.");

    //               IF lrc_SalesPostArchivDiscount.FIND('-') THEN BEGIN
    //                 REPEAT

    //                   lrc_SalesDiscountNew."Document Type" := lrc_SalesDiscountNew."Document Type"::"Credit Memo";
    //                   lrc_SalesDiscountNew."Document No." := rrc_SalesHeader."No.";
    //                   lrc_SalesDiscountNew."Entry No." := 0;
    //                   lrc_SalesDiscountNew."Discount Code" := lrc_SalesPostArchivDiscount."Discount Code";
    //                   lrc_SalesDiscountNew."Discount Description" := lrc_SalesPostArchivDiscount."Discount Description";
    //                   lrc_SalesDiscountNew."Discount Type" := lrc_SalesPostArchivDiscount."Discount Type";
    //                   lrc_SalesDiscountNew."Base Discount Value" := lrc_SalesPostArchivDiscount."Base Discount Value";
    //                   lrc_SalesDiscountNew."Discount Value" := lrc_SalesPostArchivDiscount."Discount Value";
    //                   lrc_SalesDiscountNew."Basis %-Value incl. VAT" := lrc_SalesPostArchivDiscount."Basis %-Value incl. VAT";
    //                   lrc_SalesDiscountNew."Payment Timing" := lrc_SalesPostArchivDiscount."Payment Timing";
    //                   lrc_SalesDiscountNew."Currency Code" := lrc_SalesPostArchivDiscount."Currency Code";
    //                   lrc_SalesDiscountNew."Currency Factor" := lrc_SalesPostArchivDiscount."Currency Factor";
    //                   lrc_SalesDiscountNew."Sell-to Customer No." := lrc_SalesPostArchivDiscount."Sell-to Customer No.";
    //                   lrc_SalesDiscountNew."Restrict. Freight Unit" := lrc_SalesPostArchivDiscount."Restrict. Freight Unit";
    //                   lrc_SalesDiscountNew."Item No." := lrc_SalesPostArchivDiscount."Item No.";
    //                   lrc_SalesDiscountNew."Product Group Code" := lrc_SalesPostArchivDiscount."Product Group Code";
    //                   lrc_SalesDiscountNew."Item Category Code" := lrc_SalesPostArchivDiscount."Item Category Code";
    //                   lrc_SalesDiscountNew."Vendor No." := lrc_SalesPostArchivDiscount."Vendor No.";
    //                   // DMG 001 DMG50043.s
    //                   // lrc_SalesDiscountNew."Discount Depend on Weight" := lrc_SalesPostArchivDiscount."Discount Depend on Weight";
    //                   // DMG 001 DMG50043.e

    //                   // VKR 004 DMG50081.s
    //                   lrc_SalesDiscountNew."Person in Charge Code" := lrc_SalesPostArchivDiscount."Person in Charge Code";
    //                   lrc_SalesDiscountNew."Status Customs Duty" := lrc_SalesPostArchivDiscount."Status Customs Duty";
    //                   // VKR 004 DMG50081.e

    //                   // DMG 016 0809625A.s
    //                   lrc_SalesDiscountNew."Calculation Level" := lrc_SalesPostArchivDiscount."Calculation Level";
    //                   lrc_SalesDiscountNew."Discount Source" := lrc_SalesPostArchivDiscount."Discount Source";
    //                   lrc_SalesDiscountNew."Ref. Disc. Depend on Weight" :=  lrc_SalesPostArchivDiscount."Ref. Disc. Depend on Weight";
    //                   lrc_SalesDiscountNew."Discount not on Customer Duty" := lrc_SalesPostArchivDiscount."Discount not on Customer Duty";
    //                   //lrc_SalesDiscountNew."Customer Price Group" := lrc_SalesPostArchivDiscount."Customer Price Group";
    //                   lrc_SalesDiscountNew."Ship-to Address Code" := lrc_SalesPostArchivDiscount."Ship-to Address Code";
    //                   //lrc_SalesDiscountNew."Document Posting Date" := ;
    //                   lrc_SalesDiscountNew."Restrict. Transport Unit" := lrc_SalesPostArchivDiscount."Restrict. Transport Unit";
    //                   lrc_SalesDiscountNew."Unit of Measure Code" := lrc_SalesPostArchivDiscount."Unit of Measure Code";
    //                   lrc_SalesDiscountNew."Trademark Code" := lrc_SalesPostArchivDiscount."Trademark Code";
    //                   lrc_SalesDiscountNew."Vendor Country Group" := lrc_SalesPostArchivDiscount."Vendor Country Group";
    //                   lrc_SalesDiscountNew."Service Invoice Customer No." := lrc_SalesPostArchivDiscount."Service Invoice Customer No.";
    //                   lrc_SalesDiscountNew."Im Folgelevel nicht berücksich" := lrc_SalesPostArchivDiscount."Im Folgelevel nicht berücksich";
    //                   lrc_SalesDiscountNew."Posting to Sell-to Customer" := lrc_SalesPostArchivDiscount."Posting to Sell-to Customer";
    //                   // DMG 016 0809625A.e

    //                   //ADÜ 003 WZI 130208
    //                   lrc_SalesDiscountNew."Not Valid for" := lrc_SalesPostArchivDiscount."Not Valid for";
    //                   lrc_SalesDiscountNew."Not Valid for Filter" := lrc_SalesPostArchivDiscount."Not Valid for Filter";
    //                   lrc_SalesDiscountNew."Shipment Method Code"  :=  lrc_SalesPostArchivDiscount."Shipment Method";
    //                   lrc_SalesDiscountNew."Location Code" := lrc_SalesPostArchivDiscount."Location Code";
    //                   //ADÜ 003 WZI 130208

    //                   lrc_SalesDiscountNew.INSERT(TRUE);
    //                 UNTIL lrc_SalesPostArchivDiscount.next() = 0;
    //               END;
    //               EXIT;

    //             END ELSE BEGIN

    //               // Currency und Shipment Method Code aus Ursprungsauftrag holen
    //               rrc_SalesHeader."Currency Code" := lrc_SalesShipmentHeader."Currency Code";
    //               rrc_SalesHeader."Currency Factor" := lrc_SalesShipmentHeader."Currency Factor";
    //               rrc_SalesHeader."Shipment Method Code" := lrc_SalesShipmentHeader."Shipment Method Code";
    //               rrc_SalesHeader."Appendix Shipment Method" := lrc_SalesShipmentHeader."Appendix Shipment Method";

    //               rrc_SalesHeader."Arrival Region Code" := lrc_SalesShipmentHeader."Arrival Region Code";

    //               rrc_SalesHeader."Customer Posting Group" := lrc_SalesShipmentHeader."Customer Posting Group";
    //               rrc_SalesHeader."Customer Price Group" := lrc_SalesShipmentHeader."Customer Price Group";

    //               //POI 001 00000000 JST 291112 000 Claim Location und "Claim Shipping Agent Code" entscheidend
    //               //rrc_SalesHeader."Shipping Agent Code" := lrc_SalesShipmentHeader."Shipping Agent Code";
    //               IF rrc_SalesHeader."Shipping Agent Code" = ''
    //                 THEN rrc_SalesHeader."Shipping Agent Code" := lrc_SalesShipmentHeader."Shipping Agent Code";
    //               //Location ?? wird hier nicht übernommen

    //               rrc_SalesHeader."Freight Calculation" := lrc_SalesShipmentHeader."Freight Calculation";

    //               rrc_SalesHeader."Sell-to Customer Name" := lrc_SalesShipmentHeader."Sell-to Customer Name";
    //               rrc_SalesHeader."Sell-to Customer Name 2" := lrc_SalesShipmentHeader."Sell-to Customer Name 2";
    //               rrc_SalesHeader."Sell-to Address" := lrc_SalesShipmentHeader."Sell-to Address";
    //               rrc_SalesHeader."Sell-to Address 2" := lrc_SalesShipmentHeader."Sell-to Address 2";
    //               rrc_SalesHeader."Sell-to City" := lrc_SalesShipmentHeader."Sell-to City";
    //               rrc_SalesHeader."Sell-to Contact" := lrc_SalesShipmentHeader."Sell-to Contact";
    //               rrc_SalesHeader."Sell-to Post Code" := lrc_SalesShipmentHeader."Sell-to Post Code";
    //               rrc_SalesHeader."Sell-to County" := lrc_SalesShipmentHeader."Sell-to County";
    //               rrc_SalesHeader."Sell-to Country/Region Code" := lrc_SalesShipmentHeader."Sell-to Country/Region Code";

    //               rrc_SalesHeader."Ship-to Code" := lrc_SalesShipmentHeader."Ship-to Code";
    //               rrc_SalesHeader."Ship-to Name" := lrc_SalesShipmentHeader."Ship-to Name";
    //               rrc_SalesHeader."Ship-to Name 2" := lrc_SalesShipmentHeader."Ship-to Name 2";
    //               rrc_SalesHeader."Ship-to Address" := lrc_SalesShipmentHeader."Ship-to Address";
    //               rrc_SalesHeader."Ship-to Address 2" := lrc_SalesShipmentHeader."Ship-to Address 2";
    //               rrc_SalesHeader."Ship-to City" := lrc_SalesShipmentHeader."Ship-to City";
    //               rrc_SalesHeader."Ship-to Contact" := lrc_SalesShipmentHeader."Ship-to Contact";
    //               rrc_SalesHeader."Ship-to Post Code" := lrc_SalesShipmentHeader."Ship-to Post Code";
    //               rrc_SalesHeader."Ship-to County" := lrc_SalesShipmentHeader."Ship-to County";
    //               rrc_SalesHeader."Ship-to Country/Region Code" := lrc_SalesShipmentHeader."Ship-to Country/Region Code";

    //               rrc_SalesHeader."Bill-to Customer No." := lrc_SalesShipmentHeader."Bill-to Customer No.";
    //               rrc_SalesHeader."Bill-to Name" := lrc_SalesShipmentHeader."Bill-to Name";
    //               rrc_SalesHeader."Bill-to Name 2" := lrc_SalesShipmentHeader."Bill-to Name 2";
    //               rrc_SalesHeader."Bill-to Address" := lrc_SalesShipmentHeader."Bill-to Address";
    //               rrc_SalesHeader."Bill-to Address 2" := lrc_SalesShipmentHeader."Bill-to Address 2";
    //               rrc_SalesHeader."Bill-to City" := lrc_SalesShipmentHeader."Bill-to City";
    //               rrc_SalesHeader."Bill-to Contact" := lrc_SalesShipmentHeader."Bill-to Contact";
    //               rrc_SalesHeader."Bill-to Post Code" := lrc_SalesShipmentHeader."Bill-to Post Code";
    //               rrc_SalesHeader."Bill-to County" := lrc_SalesShipmentHeader."Bill-to County";
    //               rrc_SalesHeader."Bill-to Country/Region Code" := lrc_SalesShipmentHeader."Bill-to Country/Region Code";

    //               rrc_SalesHeader."Status Customs Duty" := lrc_SalesShipmentHeader."Status Customs Duty";

    //               rrc_SalesHeader."Customer Group Code" :=  lrc_SalesShipmentHeader."Customer Group Code";
    //               rrc_SalesHeader."Source Type Liability TU" :=  lrc_SalesShipmentHeader."Source Type Liability TU";
    //               rrc_SalesHeader."Source No. Liability TU" :=  lrc_SalesShipmentHeader."Source No. Liability TU";
    //               rrc_SalesHeader."Split Sales Order to Cust. No." :=  lrc_SalesShipmentHeader."Split Sales Order to Cust. No.";
    //               rrc_SalesHeader."Service Invoice to Cust. No." :=  lrc_SalesShipmentHeader."Service Invoice to Cust. No.";
    //               rrc_SalesHeader."Temp Ship-to Code" :=  lrc_SalesShipmentHeader."Temp Ship-to Code";

    //               rrc_SalesHeader.Modify();

    //               // FV4 002 FV400014.e

    //               // DMG 012 0807000A.s
    //               lrc_SalesInvoiceLine.RESET();
    //               lrc_SalesInvoiceLine.SETCURRENTKEY( "Order No.","Order Line No.","Posting Date" );
    //               lrc_SalesInvoiceLine.SETRANGE("Order No.", lrc_SalesShipmentHeader."Order No.");
    //               lrc_SalesInvoiceLine.SETRANGE("Shipment No.", lrc_SalesShipmentHeader."No." );
    //               IF lrc_SalesInvoiceLine.FINDLAST THEN BEGIN
    //                 // Rabatte von geb. Rechnung zur Geb. Lieferung / Auftrag finden
    //                 lrc_SalesPostArchivDiscount.SETRANGE("Document Type", lrc_SalesPostArchivDiscount."Document Type"::"Posted Invoice");
    //                 lrc_SalesPostArchivDiscount.SETRANGE("Document No.", lrc_SalesInvoiceLine."Document No.");

    //                 IF lrc_SalesPostArchivDiscount.FIND('-') THEN BEGIN
    //                   REPEAT

    //                     lrc_SalesDiscountNew."Document Type" := lrc_SalesDiscountNew."Document Type"::"Credit Memo";
    //                     lrc_SalesDiscountNew."Document No." := rrc_SalesHeader."No.";
    //                     lrc_SalesDiscountNew."Entry No." := 0;
    //                     lrc_SalesDiscountNew."Discount Code" := lrc_SalesPostArchivDiscount."Discount Code";
    //                     lrc_SalesDiscountNew."Discount Description" := lrc_SalesPostArchivDiscount."Discount Description";
    //                     lrc_SalesDiscountNew."Discount Type" := lrc_SalesPostArchivDiscount."Discount Type";
    //                     lrc_SalesDiscountNew."Base Discount Value" := lrc_SalesPostArchivDiscount."Base Discount Value";
    //                     lrc_SalesDiscountNew."Discount Value" := lrc_SalesPostArchivDiscount."Discount Value";
    //                     lrc_SalesDiscountNew."Basis %-Value incl. VAT" := lrc_SalesPostArchivDiscount."Basis %-Value incl. VAT";
    //                     lrc_SalesDiscountNew."Payment Timing" := lrc_SalesPostArchivDiscount."Payment Timing";
    //                     lrc_SalesDiscountNew."Currency Code" := lrc_SalesPostArchivDiscount."Currency Code";
    //                     lrc_SalesDiscountNew."Currency Factor" := lrc_SalesPostArchivDiscount."Currency Factor";
    //                     lrc_SalesDiscountNew."Sell-to Customer No." := lrc_SalesPostArchivDiscount."Sell-to Customer No.";
    //                     lrc_SalesDiscountNew."Restrict. Freight Unit" := lrc_SalesPostArchivDiscount."Restrict. Freight Unit";
    //                     lrc_SalesDiscountNew."Item No." := lrc_SalesPostArchivDiscount."Item No.";
    //                     lrc_SalesDiscountNew."Product Group Code" := lrc_SalesPostArchivDiscount."Product Group Code";
    //                     lrc_SalesDiscountNew."Item Category Code" := lrc_SalesPostArchivDiscount."Item Category Code";
    //                     lrc_SalesDiscountNew."Vendor No." := lrc_SalesPostArchivDiscount."Vendor No.";

    //                     // VKR 004 DMG50081.s
    //                     lrc_SalesDiscountNew."Person in Charge Code" := lrc_SalesPostArchivDiscount."Person in Charge Code";
    //                     lrc_SalesDiscountNew."Status Customs Duty" := lrc_SalesPostArchivDiscount."Status Customs Duty";
    //                     // VKR 004 DMG50081.e

    //                     // DMG 016 0809625A.s
    //                     lrc_SalesDiscountNew."Calculation Level" := lrc_SalesPostArchivDiscount."Calculation Level";
    //                     lrc_SalesDiscountNew."Discount Source" := lrc_SalesPostArchivDiscount."Discount Source";
    //                     lrc_SalesDiscountNew."Ref. Disc. Depend on Weight" := lrc_SalesPostArchivDiscount."Ref. Disc. Depend on Weight";
    //                     lrc_SalesDiscountNew."Discount not on Customer Duty" := lrc_SalesPostArchivDiscount.
    //                                                                                   "Discount not on Customer Duty";
    //                     //lrc_SalesDiscountNew."Customer Price Group" := lrc_SalesPostArchivDiscount."Customer Price Group";
    //                     lrc_SalesDiscountNew."Ship-to Address Code" := lrc_SalesPostArchivDiscount."Ship-to Address Code";
    //                     // lrc_SalesDiscountNew."Document Posting Date" := ;
    //                     lrc_SalesDiscountNew."Restrict. Transport Unit" := lrc_SalesPostArchivDiscount."Restrict. Transport Unit";
    //                     lrc_SalesDiscountNew."Unit of Measure Code" := lrc_SalesPostArchivDiscount."Unit of Measure Code";
    //                     lrc_SalesDiscountNew."Trademark Code" := lrc_SalesPostArchivDiscount."Trademark Code";
    //                     lrc_SalesDiscountNew."Vendor Country Group" := lrc_SalesPostArchivDiscount."Vendor Country Group";
    //                     lrc_SalesDiscountNew."Service Invoice Customer No." := lrc_SalesPostArchivDiscount."Service Invoice Customer No.";
    //                     lrc_SalesDiscountNew."Im Folgelevel nicht berücksich" := lrc_SalesPostArchivDiscount.
    //                                                                                    "Im Folgelevel nicht berücksich";
    //                     lrc_SalesDiscountNew."Posting to Sell-to Customer" := lrc_SalesPostArchivDiscount."Posting to Sell-to Customer";
    //                     // DMG 016 0809625A.e

    //                     //ADš 003 WZI 130208
    //                     lrc_SalesDiscountNew."Not Valid for" := lrc_SalesPostArchivDiscount."Not Valid for";
    //                     lrc_SalesDiscountNew."Not Valid for Filter" := lrc_SalesPostArchivDiscount."Not Valid for Filter";
    //                     lrc_SalesDiscountNew."Shipment Method Code"  :=  lrc_SalesPostArchivDiscount."Shipment Method";
    //                     lrc_SalesDiscountNew."Location Code" := lrc_SalesPostArchivDiscount."Location Code";
    //                     //ADš 003 WZI 130208

    //                     lrc_SalesDiscountNew.INSERT(TRUE);
    //                   UNTIL lrc_SalesPostArchivDiscount.next() = 0;
    //                 END;
    //                 EXIT;
    //               END;
    //             END;
    //           END;
    //         END;

    //         // Werte aus gebuchter Rechnung holen, falls es mehrere Lieferungen zu einer Rechnung gibt
    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Internal Customer Code" = 'DÜRBECK' THEN BEGIN
    //           IF (rrc_SalesClaimAdviceHeader."Sales Shipment No." = '')  AND
    //             (rrc_SalesClaimAdviceHeader."Sales Invoice No." <> '') THEN BEGIN
    //             IF lrc_SalesInvoiceHeader.GET( rrc_SalesClaimAdviceHeader."Sales Invoice No.") THEN BEGIN
    //               // FV4 002 FV400014.s
    //               // Currency und Shipment Method Code aus Ursprungsauftrag holen
    //               rrc_SalesHeader."Currency Code" := lrc_SalesInvoiceHeader."Currency Code";
    //               rrc_SalesHeader."Currency Factor" := lrc_SalesInvoiceHeader."Currency Factor";
    //               rrc_SalesHeader."Shipment Method Code" := lrc_SalesInvoiceHeader."Shipment Method Code";
    //               rrc_SalesHeader."Appendix Shipment Method" := lrc_SalesInvoiceHeader."Appendix Shipment Method";
    //               rrc_SalesHeader."Arrival Region Code" := lrc_SalesInvoiceHeader."Arrival Region Code";

    //               rrc_SalesHeader."Customer Posting Group" := lrc_SalesInvoiceHeader."Customer Posting Group";
    //               rrc_SalesHeader."Customer Price Group" := lrc_SalesInvoiceHeader."Customer Price Group";

    //               //POI 001 00000000 JST 291112 000 Claim Location und "Claim Shipping Agent Code" entscheidend
    //               //rrc_SalesHeader."Shipping Agent Code" := lrc_SalesInvoiceHeader."Shipping Agent Code";
    //               IF rrc_SalesHeader."Shipping Agent Code" = ''
    //                 THEN rrc_SalesHeader."Shipping Agent Code" := lrc_SalesInvoiceHeader."Shipping Agent Code";
    //               //Location ?? wird hier nicht übernommen

    //               rrc_SalesHeader."Freight Calculation" := lrc_SalesInvoiceHeader."Freight Calculation";

    //               rrc_SalesHeader."Means of Transport Type" := lrc_SalesInvoiceHeader."Means of Transport Type";
    //               rrc_SalesHeader."Means of Transport Code" := lrc_SalesInvoiceHeader."Means of Transport Code";
    //               rrc_SalesHeader."Means of Transport Info" := lrc_SalesInvoiceHeader."Means of Transport Info";

    //               rrc_SalesHeader."Sell-to Customer Name" := lrc_SalesInvoiceHeader."Sell-to Customer Name";
    //               rrc_SalesHeader."Sell-to Customer Name 2" := lrc_SalesInvoiceHeader."Sell-to Customer Name 2";
    //               rrc_SalesHeader."Sell-to Address" := lrc_SalesInvoiceHeader."Sell-to Address";
    //               rrc_SalesHeader."Sell-to Address 2" := lrc_SalesInvoiceHeader."Sell-to Address 2";
    //               rrc_SalesHeader."Sell-to City" := lrc_SalesInvoiceHeader."Sell-to City";
    //               rrc_SalesHeader."Sell-to Contact" := lrc_SalesInvoiceHeader."Sell-to Contact";
    //               rrc_SalesHeader."Sell-to Post Code" := lrc_SalesInvoiceHeader."Sell-to Post Code";
    //               rrc_SalesHeader."Sell-to County" := lrc_SalesInvoiceHeader."Sell-to County";
    //               rrc_SalesHeader."Sell-to Country/Region Code" := lrc_SalesInvoiceHeader."Sell-to Country/Region Code";

    //               rrc_SalesHeader."Ship-to Code" := lrc_SalesInvoiceHeader."Ship-to Code";
    //               rrc_SalesHeader."Ship-to Name" := lrc_SalesInvoiceHeader."Ship-to Name";
    //               rrc_SalesHeader."Ship-to Name 2" := lrc_SalesInvoiceHeader."Ship-to Name 2";
    //               rrc_SalesHeader."Ship-to Address" := lrc_SalesInvoiceHeader."Ship-to Address";
    //               rrc_SalesHeader."Ship-to Address 2" := lrc_SalesInvoiceHeader."Ship-to Address 2";
    //               rrc_SalesHeader."Ship-to City" := lrc_SalesInvoiceHeader."Ship-to City";
    //               rrc_SalesHeader."Ship-to Contact" := lrc_SalesInvoiceHeader."Ship-to Contact";
    //               rrc_SalesHeader."Ship-to Post Code" := lrc_SalesInvoiceHeader."Ship-to Post Code";
    //               rrc_SalesHeader."Ship-to County" := lrc_SalesInvoiceHeader."Ship-to County";
    //               rrc_SalesHeader."Ship-to Country/Region Code" := lrc_SalesInvoiceHeader."Ship-to Country/Region Code";

    //               rrc_SalesHeader."Bill-to Customer No." := lrc_SalesInvoiceHeader."Bill-to Customer No.";
    //               rrc_SalesHeader."Bill-to Name" := lrc_SalesInvoiceHeader."Bill-to Name";
    //               rrc_SalesHeader."Bill-to Name 2" := lrc_SalesInvoiceHeader."Bill-to Name 2";
    //               rrc_SalesHeader."Bill-to Address" := lrc_SalesInvoiceHeader."Bill-to Address";
    //               rrc_SalesHeader."Bill-to Address 2" := lrc_SalesInvoiceHeader."Bill-to Address 2";
    //               rrc_SalesHeader."Bill-to City" := lrc_SalesInvoiceHeader."Bill-to City";
    //               rrc_SalesHeader."Bill-to Contact" := lrc_SalesInvoiceHeader."Bill-to Contact";
    //               rrc_SalesHeader."Bill-to Post Code" := lrc_SalesInvoiceHeader."Bill-to Post Code";
    //               rrc_SalesHeader."Bill-to County" := lrc_SalesInvoiceHeader."Bill-to County";
    //               rrc_SalesHeader."Bill-to Country/Region Code" := lrc_SalesInvoiceHeader."Bill-to Country/Region Code";

    //               rrc_SalesHeader."Status Customs Duty" := lrc_SalesInvoiceHeader."Status Customs Duty";

    //               rrc_SalesHeader."Customer Group Code" :=  lrc_SalesInvoiceHeader."Customer Group Code";
    //               rrc_SalesHeader."Source Type Liability TU" :=  lrc_SalesInvoiceHeader."Source Type Liability TE";
    //               rrc_SalesHeader."Source No. Liability TU" :=  lrc_SalesInvoiceHeader."Source No. Liability TU";
    //               rrc_SalesHeader."Split Sales Order to Cust. No." :=  lrc_SalesInvoiceHeader."Sales Order Customer No.";
    //               rrc_SalesHeader."Service Invoice to Cust. No." :=  lrc_SalesInvoiceHeader."Service Invoice Customer No.";
    //               rrc_SalesHeader."Temp Ship-to Code" :=  lrc_SalesInvoiceHeader."Temp Ship-to Code";

    //               rrc_SalesHeader.Modify();
    //               // FV4 002 FV400014.e

    //               // Rabatte von Ursprungsauftrag finden
    //               lrc_SalesPostArchivDiscount.SETRANGE("Document Type", lrc_SalesPostArchivDiscount."Document Type"::"Posted Invoice");
    //               lrc_SalesPostArchivDiscount.SETRANGE("Document No.", lrc_SalesInvoiceHeader."No.");
    //               IF lrc_SalesPostArchivDiscount.FINDSET(FALSE,FALSE) THEN BEGIN
    //                 REPEAT

    //                   lrc_SalesDiscountNew."Document Type" := lrc_SalesDiscountNew."Document Type"::"Credit Memo";
    //                   lrc_SalesDiscountNew."Document No." := rrc_SalesHeader."No.";
    //                   lrc_SalesDiscountNew."Entry No." := 0;
    //                   lrc_SalesDiscountNew."Discount Code" := lrc_SalesPostArchivDiscount."Discount Code";
    //                   lrc_SalesDiscountNew."Discount Description" := lrc_SalesPostArchivDiscount."Discount Description";
    //                   lrc_SalesDiscountNew."Discount Type" := lrc_SalesPostArchivDiscount."Discount Type";
    //                   lrc_SalesDiscountNew."Base Discount Value" := lrc_SalesPostArchivDiscount."Base Discount Value";
    //                   lrc_SalesDiscountNew."Discount Value" := lrc_SalesPostArchivDiscount."Discount Value";
    //                   lrc_SalesDiscountNew."Basis %-Value incl. VAT" := lrc_SalesPostArchivDiscount."Basis %-Value incl. VAT";
    //                   lrc_SalesDiscountNew."Payment Timing" := lrc_SalesPostArchivDiscount."Payment Timing";
    //                   lrc_SalesDiscountNew."Currency Code" := lrc_SalesPostArchivDiscount."Currency Code";
    //                   lrc_SalesDiscountNew."Currency Factor" := lrc_SalesPostArchivDiscount."Currency Factor";
    //                   lrc_SalesDiscountNew."Sell-to Customer No." := lrc_SalesPostArchivDiscount."Sell-to Customer No.";
    //                   lrc_SalesDiscountNew."Restrict. Freight Unit" := lrc_SalesPostArchivDiscount."Restrict. Freight Unit";
    //                   lrc_SalesDiscountNew."Item No." := lrc_SalesPostArchivDiscount."Item No.";
    //                   lrc_SalesDiscountNew."Product Group Code" := lrc_SalesPostArchivDiscount."Product Group Code";
    //                   lrc_SalesDiscountNew."Item Category Code" := lrc_SalesPostArchivDiscount."Item Category Code";
    //                   lrc_SalesDiscountNew."Vendor No." := lrc_SalesPostArchivDiscount."Vendor No.";
    //                   // DMG 001 DMG50043.s
    //                   // lrc_SalesDiscountNew."Discount Depend on Weight" := lrc_SalesPostArchivDiscount."Discount Depend on Weight";
    //                   // DMG 001 DMG50043.e

    //                   // VKR 004 DMG50081.s
    //                   lrc_SalesDiscountNew."Person in Charge Code" := lrc_SalesPostArchivDiscount."Person in Charge Code";
    //                   lrc_SalesDiscountNew."Status Customs Duty" := lrc_SalesPostArchivDiscount."Status Customs Duty";
    //                   // VKR 004 DMG50081.e

    //                   lrc_SalesDiscountNew."Calculation Level" := lrc_SalesPostArchivDiscount."Calculation Level";
    //                   lrc_SalesDiscountNew."Discount Source" := lrc_SalesPostArchivDiscount."Discount Source";
    //                   lrc_SalesDiscountNew."Ref. Disc. Depend on Weight" := lrc_SalesPostArchivDiscount."Ref. Disc. Depend on Weight";
    //                   lrc_SalesDiscountNew."Discount not on Customer Duty" := lrc_SalesPostArchivDiscount."Discount not on Customer Duty";
    //                   //lrc_SalesDiscountNew."Customer Price Group" := lrc_SalesPostArchivDiscount."Customer Price Group";
    //                   lrc_SalesDiscountNew."Ship-to Address Code" := lrc_SalesPostArchivDiscount."Ship-to Address Code";
    //                   lrc_SalesDiscountNew."Restrict. Transport Unit" := lrc_SalesPostArchivDiscount."Restrict. Transport Unit";
    //                   lrc_SalesDiscountNew."Unit of Measure Code" := lrc_SalesPostArchivDiscount."Unit of Measure Code";
    //                   lrc_SalesDiscountNew."Trademark Code" := lrc_SalesPostArchivDiscount."Trademark Code";
    //                   lrc_SalesDiscountNew."Vendor Country Group" := lrc_SalesPostArchivDiscount."Vendor Country Group";
    //                   lrc_SalesDiscountNew."Service Invoice Customer No." := lrc_SalesPostArchivDiscount."Service Invoice Customer No.";
    //                   lrc_SalesDiscountNew."Im Folgelevel nicht berücksich" := lrc_SalesPostArchivDiscount."Im Folgelevel nicht berücksich";
    //                   lrc_SalesDiscountNew."Posting to Sell-to Customer" := lrc_SalesPostArchivDiscount."Posting to Sell-to Customer";


    //                   lrc_SalesDiscountNew."Not Valid for" := lrc_SalesPostArchivDiscount."Not Valid for";
    //                   lrc_SalesDiscountNew."Not Valid for Filter" := lrc_SalesPostArchivDiscount."Not Valid for Filter";
    //                   lrc_SalesDiscountNew."Shipment Method Code"  :=  lrc_SalesPostArchivDiscount."Shipment Method";
    //                   lrc_SalesDiscountNew."Location Code" := lrc_SalesPostArchivDiscount."Location Code";
    //                   lrc_SalesDiscountNew.INSERT(TRUE);
    //                 UNTIL lrc_SalesPostArchivDiscount.next() = 0;
    //               END;
    //               EXIT;
    //             END;
    //           END;
    //         END;

    //         // Wenn kein Ursprungsbeleg ausfindig ist, werden Debitoren- und Firmenrabatte geholt
    //         // Belegdatum der Reklamation soll in gültigem Zeitraum liegen
    //         // Datum von Gutschrift merken
    //         ldt_DocumentDateHelp := rrc_SalesHeader."Document Date";
    //         // Datum von Gutschrift vorlaufig mit Datum von Reklamation begleichen
    //         rrc_SalesHeader."Document Date" := rrc_SalesClaimAdviceHeader."Document Date";
    //         lcu_DiscountManagement.SalesDiscLoad(rrc_SalesHeader,FALSE);
    //         // Datum von Gutschrift zuruecksetzen
    //         rrc_SalesHeader."Document Date" := ldt_DocumentDateHelp;
    //     end;

    //     procedure ShowRegList(vco_SalesClaimNo: Code[20])
    //     var
    //         lrc_SalesClaimHeader: Record "5110455";
    //         lfm_RegSalesClaimAdviceList: Form "5110459";
    //     begin
    //         //********RS lt. DevTool nicht verwendet********


    //         IF vco_SalesClaimNo <> '' THEN BEGIN
    //           lrc_SalesClaimHeader.RESET();
    //           lrc_SalesClaimHeader.SETRANGE("No.", vco_SalesClaimNo);
    //           lfm_RegSalesClaimAdviceList.SETTABLEVIEW(lrc_SalesClaimHeader);
    //           lfm_RegSalesClaimAdviceList.LOOKUPMODE(FALSE);
    //           lfm_RegSalesClaimAdviceList.RUNMODAL();
    //         END;
    //     end;

    procedure LoadClaim(var rrc_SalesClaimHeader: Record "POI Sales Claim Notify Header"; vco_OrderNo: Code[20]; vco_ShipmentNo: Code[20]; vco_InvoiceNo: Code[20])
    var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_SalesClaimLine: Record "5110456";
    //         lrc_BatchVariantEntry: Record ""POI Batch Variant Entry"";
    //         lrc_SalesShipmentHdr: Record "110";
    //         lrc_SalesShipmentLine: Record "111";
    //         lrc_TempSalesShipmentLine: Record "111" temporary;
    //         lrc_SalesInvoiceHeader: Record "112";
    //         lrc_SalesInvoiceLine: Record "113";
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_BatchVariant: Record "5110366";
    //         lin_LineNo: Integer;
    //         AGILES_LT_TEXT001: Label 'Es sind bereits Zeilen vorhanden! Neu laden?';
    //         AGILES_LT_TEXT002: Label 'Keine Lieferzeilen zum Laden in die Reklamation gefunden!';
    //         "-- 006 IFW 40127 L": Integer;
    //         lrc_FruitVisionSetup: Record "5110302";
    //         "-- VKR 009 DMG50020 L": Integer;
    //         lrc_UserSetup: Record "91";
    //         lrc_LocationGroup: Record "5110329";
    //         "****Port": Integer;
    //         lrc_MasterBatch: Record "5110364";
    begin
        //         // -------------------------------------------------------------------------------------
        //         // Reklamation über Auftragsnr. / Lieferungsnr. / Rechnungsnr. aus Lieferung laden
        //         // -------------------------------------------------------------------------------------

        //         IF (vco_OrderNo = '') AND
        //            (vco_ShipmentNo = '') AND
        //            (vco_InvoiceNo = '') THEN
        //           EXIT;

        //         // Lieferungszeilen über Auftragsnummer oder Lieferungsnummer holen
        //         IF (vco_OrderNo <> '') OR
        //            (vco_ShipmentNo <> '') THEN BEGIN

        //           lrc_SalesShipmentLine.RESET();
        //           IF vco_ShipmentNo <> '' THEN BEGIN
        //             lrc_SalesShipmentLine.SETRANGE("Document No.",vco_ShipmentNo);
        //           END;
        //           IF vco_OrderNo <> '' THEN BEGIN
        //             lrc_SalesShipmentLine.SETRANGE("Order No.",vco_OrderNo);
        //           END;
        //           lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
        //           lrc_SalesShipmentLine.SETFILTER("No.",'<>%1','');
        //           lrc_SalesShipmentLine.SETFILTER(Quantity,'<>%1',0);
        //           lrc_SalesShipmentLine.SETRANGE(Correction,FALSE);

        //           //mly 150112
        //           lrc_SalesShipmentLine.SETFILTER("Posting Date",'%1..',010114D);

        //           IF lrc_SalesShipmentLine.FIND('-') THEN BEGIN
        //             REPEAT
        //               IF rrc_SalesClaimHeader."Sell-to Customer No." <> lrc_SalesShipmentLine."Sell-to Customer No." THEN
        //                 ERROR('Debitor Reklamationsmeldung %1\und Debitor Lieferung %2\sind unterschiedlich!',
        //                 rrc_SalesClaimHeader."Sell-to Customer No.",
        //                 lrc_SalesShipmentLine."Sell-to Customer No.");
        //               lrc_TempSalesShipmentLine := lrc_SalesShipmentLine;
        //               lrc_TempSalesShipmentLine.insert();
        //             UNTIL lrc_SalesShipmentLine.next() = 0;
        //           END ELSE BEGIN
        //           END;

        //         END ELSE BEGIN

        //           // Lieferungszeilen über Rechnungsnummer holen
        //           IF vco_InvoiceNo <> '' THEN BEGIN
        //             lrc_SalesInvoiceLine.RESET();
        //             lrc_SalesInvoiceLine.SETRANGE("Document No.",vco_InvoiceNo);
        //             lrc_SalesInvoiceLine.SETRANGE(Type,lrc_SalesInvoiceLine.Type::Item);
        //             lrc_SalesInvoiceLine.SETFILTER("No.",'<>%1','');
        //             lrc_SalesInvoiceLine.SETFILTER(Quantity,'<>%1',0);

        //             //mly 150112
        //             lrc_SalesInvoiceLine.SETFILTER("Posting Date",'%1..',010114D);

        //             IF lrc_SalesInvoiceLine.FIND('-') THEN BEGIN
        //               REPEAT
        //                 lrc_SalesShipmentLine.RESET();
        //                 lrc_SalesShipmentLine.SETRANGE("Document No.",lrc_SalesInvoiceLine."Shipment No.");
        //                 lrc_SalesShipmentLine.SETRANGE("Line No.",lrc_SalesInvoiceLine."Shipment Line No.");
        //                 lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
        //                 lrc_SalesShipmentLine.SETFILTER("No.",'<>%1','');
        //                 lrc_SalesShipmentLine.SETFILTER(Quantity,'<>%1',0);
        //                 IF lrc_SalesShipmentLine.FIND('-') THEN BEGIN

        //                   IF rrc_SalesClaimHeader."Sell-to Customer No." <> lrc_SalesShipmentLine."Sell-to Customer No." THEN
        //                     ERROR('Debitor Reklamationsmeldung %1\und Debitor Lieferung %2\sind unterschiedlich!',
        //                     rrc_SalesClaimHeader."Sell-to Customer No.",
        //                     lrc_SalesShipmentLine."Sell-to Customer No.");

        //                   lrc_TempSalesShipmentLine := lrc_SalesShipmentLine;
        //                   lrc_TempSalesShipmentLine.insert();
        //                 END;
        //               UNTIL lrc_SalesInvoiceLine.next() = 0;
        //             END ELSE BEGIN
        //             END;

        //           END;

        //         END;

        //         IF lrc_TempSalesShipmentLine.COUNT() <= 0 THEN BEGIN
        //           // Keine Lieferzeilen zum Laden in die Reklamation gefunden!
        //           ERROR(AGILES_LT_TEXT002);
        //         END;

        //         lrc_SalesClaimLine.RESET();
        //         lrc_SalesClaimLine.SETRANGE("Document No.",rrc_SalesClaimHeader."No.");
        //         IF lrc_SalesClaimLine.FIND('-') THEN BEGIN
        //           // Es sind bereits Zeilen vorhanden! Neu laden?
        //           IF NOT CONFIRM(AGILES_LT_TEXT001) THEN
        //             EXIT;
        //           lrc_SalesClaimLine.DELETEALL(TRUE);
        //         END;

        //         lrc_BatchSetup.get();

        //         IF lrc_TempSalesShipmentLine.FIND('-') THEN BEGIN

        //           // Verkauf Partiezuweisung aus der ersten Lieferzeile ermitteln
        //           lrc_SalesShipmentHdr.GET(lrc_TempSalesShipmentLine."Document No.");
        //           lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Order, lrc_SalesShipmentHdr."Sales Doc. Subtype Code");

        //           rrc_SalesClaimHeader."Sales Doc. Subtyp Code" := lrc_SalesDocType.Code;

        //           IF lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Depend on Doc. Type" THEN BEGIN
        //             lrc_BatchSetup."Sales Batch Assignment" := lrc_SalesDocType."Sales Batch Assignment";
        //           END;

        //           //POI 001 Port0000 JST 061112 000 Div. Einträge aus der ersten Lieferzeile übernehmen
        //           //POI 001 Port0000 JST 231112 000 Div. Einträge aus der ersten Lieferzeile übernehmen
        //           //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        //         //  rrc_SalesClaimHeader.VALIDATE("Claim Shipping Agent Code",lrc_SalesShipmentHdr."Shipping Agent Code");
        //           //Verkauf aus Lager -> Claim Location Code
        //         //  IF lrc_SalesShipmentHdr."Location Code" <> ''
        //         //    THEN rrc_SalesClaimHeader.VALIDATE("Claim Location Code",lrc_SalesShipmentHdr."Location Code")
        //         //    ELSE rrc_SalesClaimHeader.VALIDATE("Claim Location Code",lrc_SalesShipmentLine."Location Code");
        //           //Exporteur/Kreditor ->Return to Vendor No.
        //         //  IF lrc_TempSalesShipmentLine."Buy-from Vendor No." = '' THEN BEGIN
        //         //    lrc_MasterBatch.GET(lrc_TempSalesShipmentLine."Master Batch No.");
        //         //    rrc_SalesClaimHeader.VALIDATE("Return to Vendor No.",lrc_MasterBatch."Vendor No.");
        //             //Schiffsname
        //             //Eingangsdatum
        //             //Ursprungsland
        //         //  END ELSE BEGIN
        //         //    rrc_SalesClaimHeader.VALIDATE("Return to Vendor No.",lrc_TempSalesShipmentLine."Buy-from Vendor No.");
        //         //  END;
        //           //POI 001 Port0000 JST 061112 000 Div. Einträge aus der ersten Lieferzeile übernehmen
        //           //POI 001 Port0000 JST 231112 000 Div. Einträge aus der ersten Lieferzeile übernehmen
        //           //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

        //           REPEAT

        //             IF (lrc_SalesShipmentLine."POI Batch Item" = FALSE) OR
        //                ((lrc_SalesShipmentLine."POI Batch Item" = TRUE) AND
        //                  ((lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line") OR
        //                    (lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Automatic from System")))
        //                THEN BEGIN

        //                 lrc_SalesClaimLine.RESET();
        //                 lrc_SalesClaimLine.INIT();
        //                 lrc_SalesClaimLine."Document No." := rrc_SalesClaimHeader."No.";
        //                 lin_LineNo := lin_LineNo + 10000;
        //                 lrc_SalesClaimLine."Line No." := lin_LineNo;
        //                 lrc_SalesClaimLine.Claim := FALSE;
        //                 lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
        //                 lrc_SalesClaimLine."No." := lrc_TempSalesShipmentLine."No.";
        //                 lrc_SalesClaimLine.Description := lrc_TempSalesShipmentLine.Description;
        //                 lrc_SalesClaimLine."Description 2" := lrc_TempSalesShipmentLine."Description 2";

        //                 lrc_SalesClaimLine."Master Batch No." := lrc_TempSalesShipmentLine."Master Batch No.";
        //                 lrc_SalesClaimLine."Batch No." := lrc_TempSalesShipmentLine."Batch No.";
        //                 lrc_SalesClaimLine."Batch Variant No." := lrc_TempSalesShipmentLine."Batch Variant No.";
        //                 lrc_SalesClaimLine."Batch Item" := lrc_TempSalesShipmentLine."Batch Item";

        //                 lrc_SalesClaimLine."Variety Code" := lrc_TempSalesShipmentLine."Variety Code";
        //                 lrc_SalesClaimLine."Country of Origin Code" := lrc_TempSalesShipmentLine."Country of Origin Code";
        //                 lrc_SalesClaimLine."Trademark Code" := lrc_TempSalesShipmentLine."Trademark Code";
        //                 lrc_SalesClaimLine."Caliber Code" := lrc_TempSalesShipmentLine."Caliber Code";
        //                 lrc_SalesClaimLine."Item Attribute 2" := lrc_TempSalesShipmentLine."Color Code";
        //                 lrc_SalesClaimLine."Grade of Goods Code" := lrc_TempSalesShipmentLine."Grade of Goods Code";
        //                 lrc_SalesClaimLine."Item Attribute 7" := lrc_TempSalesShipmentLine."Conservation Code";
        //                 lrc_SalesClaimLine."Item Attribute 4" := lrc_TempSalesShipmentLine."Packing Code";
        //                 lrc_SalesClaimLine."Coding Code" := lrc_TempSalesShipmentLine."Coding Code";
        //                 lrc_SalesClaimLine."Item Attribute 5" := lrc_TempSalesShipmentLine."Treatment Code";
        //                 lrc_SalesClaimLine."Item Attribute 3" := lrc_TempSalesShipmentLine."Quality Code";
        //                 lrc_SalesClaimLine."Info 1" := lrc_TempSalesShipmentLine."Info 1";
        //                 lrc_SalesClaimLine."Info 2" := lrc_TempSalesShipmentLine."Info 2";
        //                 lrc_SalesClaimLine."Info 3" := lrc_TempSalesShipmentLine."Info 3";
        //                 lrc_SalesClaimLine."Info 4" := lrc_TempSalesShipmentLine."Info 4";
        //                 lrc_SalesClaimLine."Item Category Code" := lrc_TempSalesShipmentLine."Item Category Code";
        //                 lrc_SalesClaimLine."Product Group Code" := lrc_TempSalesShipmentLine."Product Group Code";

        //                 lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_TempSalesShipmentLine."Price Unit of Measure";
        //                 lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_TempSalesShipmentLine."Partial Quantity (PQ)";

        //                 lrc_SalesClaimLine."Unit of Measure Code" := lrc_TempSalesShipmentLine."Unit of Measure Code";
        //                 lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_TempSalesShipmentLine."Base Unit of Measure (BU)";
        //                 lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_TempSalesShipmentLine."Qty. per Unit of Measure";

        //                 lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_TempSalesShipmentLine.Quantity, 0.00001 );
        //         //      lrc_SalesClaimLine."Quantity Invoiced" := 0;
        //                 lrc_SalesClaimLine.Quantity := ROUND(lrc_TempSalesShipmentLine.Quantity, 0.00001 );

        //                 lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_TempSalesShipmentLine."Quantity (Base)", 0.00001 );
        //                 lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_TempSalesShipmentLine."Packing Unit of Measure (PU)";
        //                 lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_TempSalesShipmentLine."Qty. (PU) per Unit of Measure";
        //                 lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_TempSalesShipmentLine."Quantity (PU)", 0.00001 );
        //                 lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_TempSalesShipmentLine."Transport Unit of Measure (TU)";
        //                 lrc_SalesClaimLine."Qty. (Unit) per Transport (TU)" := lrc_TempSalesShipmentLine."Qty. (Unit) per Transp. Unit";
        //                 lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_TempSalesShipmentLine."Quantity (TU)", 0.00001 );
        //                 lrc_SalesClaimLine."Collo Unit of Measure (CU)" := lrc_TempSalesShipmentLine."Collo Unit of Measure (PQ)";
        //                 lrc_SalesClaimLine."Content Unit of Measure (COU)" := lrc_TempSalesShipmentLine."Content Unit of Measure (COU)";

        //                 lrc_SalesClaimLine."Gross Weight" := lrc_TempSalesShipmentLine."Gross Weight";
        //                 lrc_SalesClaimLine."Net Weight" := lrc_TempSalesShipmentLine."Net Weight";
        //                 lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" := lrc_TempSalesShipmentLine."Qty. (COU) per Pack. Unit (PU)";

        //                 lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_TempSalesShipmentLine."Price Base (Sales Price)";
        //                 lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_TempSalesShipmentLine."Sales Price (Price Base)";
        //                 lrc_SalesClaimLine."Sales Unit Price" := lrc_TempSalesShipmentLine."Unit Price";
        //                 lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" *
        //                                                      lrc_SalesClaimLine.Quantity;

        //                 lrc_SalesClaimLine."Sales Order No." := lrc_TempSalesShipmentLine."Order No.";
        //                 lrc_SalesClaimLine."Sales Order Line No." := lrc_TempSalesShipmentLine."Order Line No.";
        //                 lrc_SalesClaimLine."Sales Shipment No." := lrc_TempSalesShipmentLine."Document No.";
        //                 lrc_SalesClaimLine."Sales Shipment Line No." := lrc_TempSalesShipmentLine."Line No.";

        //                 lrc_SalesClaimLine."Shipping Agent Code" := lrc_TempSalesShipmentLine."Shipping Agent Code";
        //                 lrc_SalesClaimLine."Location Code" := lrc_TempSalesShipmentLine."Location Code";

        //                 lrc_SalesClaimLine."Sales Quality Rating" := lrc_TempSalesShipmentLine."Quality Rating";

        //                 lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_TempSalesShipmentLine."Shipping Agent Code";
        //                 lrc_SalesClaimLine."Claim Location Code" := lrc_TempSalesShipmentLine."Location Code";
        //                 lrc_SalesClaimLine."Claim Quality Rating" := lrc_TempSalesShipmentLine."Quality Rating";
        //                 lrc_SalesClaimLine."Claim Quantity" := 0;
        //                 lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
        //                 lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
        //                 lrc_SalesClaimLine."Claim Sales Amount" := 0;
        //                 lrc_SalesClaimLine."Claim Verlust" := 0;

        //                 //POI 001 00000000 JST 281112 000 Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
        //                 //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
        //                 //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
        //                 gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_TempSalesShipmentLine."Master Batch No.",BuyFromVendorNo,
        //                                                                   VendorOrderNo,IstPackauftrag,PackauftragEindeutig);
        //                 lrc_SalesClaimLine."Buy-from Vendor No.":=BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
        //                 lrc_SalesClaimLine."Vendor Order No.":=VendorOrderNo;
        //                 //Return to Vendor ??
        //                 //POI 001 00000000 JST 281112 e.


        //                 // VKR 006 IFW40127.s
        //                 lrc_FruitVisionSetup.GET();
        //                 //IF (lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT') OR
        //                  //DMG 000 DMG50180.s
        //                 //  (lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN BEGIN
        //                  //DMG 000 DMG50180.e
        //                  FetchPriceFromOrder(lrc_SalesClaimLine);
        //                 //END;
        //                 // VKR 006 IFW40127.e

        //                 //RS Übernahme von Leergutinformationen
        //                 lrc_SalesClaimLine."Empties Blanket Order No." := lrc_TempSalesShipmentLine."Empties Blanket Order No.";
        //                 lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_TempSalesShipmentLine."Empties Blanket Order Line No.";
        //                 lrc_SalesClaimLine."Empties Item No." := lrc_TempSalesShipmentLine."Empties Item No.";
        //                 lrc_SalesClaimLine."Empties Quantity" := lrc_TempSalesShipmentLine."Empties Quantity";
        //                 //RS.e

        //                 lrc_SalesClaimLine.insert();

        //             END ELSE BEGIN

        //               IF lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line" THEN BEGIN

        //                 lrc_TempSalesShipmentLine.TESTFIELD("Batch Var. Detail ID");
        //                 lrc_BatchVariantEntry.RESET();
        //                 lrc_BatchVariantEntry.SETCURRENTKEY("Detail Entry No.","Detail Line No.");
        //                 lrc_BatchVariantEntry.SETRANGE("Detail Entry No.",lrc_TempSalesShipmentLine."Batch Var. Detail ID");
        //                 //DMG 000 DMG50180.s
        //                 lrc_BatchVariantEntry.SETRANGE("Source Doc. Type",lrc_BatchVariantEntry."Source Doc. Type"::Order);
        //                 lrc_BatchVariantEntry.SETRANGE("Source Doc. No.", lrc_TempSalesShipmentLine."Order No.");
        //                 lrc_BatchVariantEntry.SETRANGE("Document No.",lrc_TempSalesShipmentLine."Document No.");
        //                 lrc_BatchVariantEntry.SETRANGE( "Document Line No.",lrc_TempSalesShipmentLine."Line No." );
        //                 lrc_BatchVariantEntry.SETRANGE( Correction, FALSE );
        //                 //DMG 000 DMG50180.e

        //                 IF lrc_BatchVariantEntry.FIND('-') THEN
        //                 REPEAT

        //                   IF NOT lrc_BatchVariant.GET(lrc_BatchVariantEntry."Batch Variant No.") THEN
        //                     lrc_BatchVariant.INIT();

        //                   lrc_SalesClaimLine.RESET();
        //                   lrc_SalesClaimLine.INIT();
        //                   lrc_SalesClaimLine."Document No." := rrc_SalesClaimHeader."No.";
        //                   lin_LineNo := lin_LineNo + 10000;
        //                   lrc_SalesClaimLine."Line No." := lin_LineNo;
        //                   lrc_SalesClaimLine.Claim := FALSE;
        //                   lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
        //                   lrc_SalesClaimLine."No." := lrc_TempSalesShipmentLine."No.";
        //                   lrc_SalesClaimLine.Description := lrc_TempSalesShipmentLine.Description;
        //                   lrc_SalesClaimLine."Description 2" := lrc_TempSalesShipmentLine."Description 2";
        //                   lrc_SalesClaimLine."Master Batch No." := lrc_BatchVariantEntry."Master Batch No.";
        //                   lrc_SalesClaimLine."Batch No." := lrc_BatchVariantEntry."Batch No.";
        //                   lrc_SalesClaimLine."Batch Variant No." := lrc_BatchVariantEntry."Batch Variant No.";
        //                   lrc_SalesClaimLine."Vendor No." := lrc_BatchVariant."Vendor No.";

        //                   lrc_SalesClaimLine."Batch Item" := lrc_TempSalesShipmentLine."Batch Item";
        //                   lrc_SalesClaimLine."Variety Code" := lrc_TempSalesShipmentLine."Variety Code";
        //                   lrc_SalesClaimLine."Country of Origin Code" := lrc_TempSalesShipmentLine."Country of Origin Code";
        //                   lrc_SalesClaimLine."Trademark Code" := lrc_TempSalesShipmentLine."Trademark Code";
        //                   lrc_SalesClaimLine."Caliber Code" := lrc_TempSalesShipmentLine."Caliber Code";
        //                   lrc_SalesClaimLine."Item Attribute 2" := lrc_TempSalesShipmentLine."Color Code";
        //                   lrc_SalesClaimLine."Grade of Goods Code" := lrc_TempSalesShipmentLine."Grade of Goods Code";
        //                   lrc_SalesClaimLine."Item Attribute 7" := lrc_TempSalesShipmentLine."Conservation Code";
        //                   lrc_SalesClaimLine."Item Attribute 4" := lrc_TempSalesShipmentLine."Packing Code";
        //                   lrc_SalesClaimLine."Coding Code" := lrc_TempSalesShipmentLine."Coding Code";
        //                   lrc_SalesClaimLine."Item Attribute 5" := lrc_TempSalesShipmentLine."Treatment Code";
        //                   lrc_SalesClaimLine."Item Attribute 3" := lrc_TempSalesShipmentLine."Quality Code";
        //                   lrc_SalesClaimLine."Info 1" := lrc_TempSalesShipmentLine."Info 1";
        //                   lrc_SalesClaimLine."Info 2" := lrc_TempSalesShipmentLine."Info 2";
        //                   lrc_SalesClaimLine."Info 3" := lrc_TempSalesShipmentLine."Info 3";
        //                   lrc_SalesClaimLine."Info 4" := lrc_TempSalesShipmentLine."Info 4";
        //                   lrc_SalesClaimLine."Item Category Code" := lrc_TempSalesShipmentLine."Item Category Code";
        //                   lrc_SalesClaimLine."Product Group Code" := lrc_TempSalesShipmentLine."Product Group Code";

        //                   lrc_SalesClaimLine."Unit of Measure Code" := lrc_TempSalesShipmentLine."Unit of Measure Code";
        //                   lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_TempSalesShipmentLine."Base Unit of Measure (BU)";
        //                   lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_TempSalesShipmentLine."Qty. per Unit of Measure";

        //                   lrc_SalesClaimLine.Quantity := ROUND((lrc_BatchVariantEntry."Quantity (Base)" /
        //                                                        lrc_TempSalesShipmentLine."Qty. per Unit of Measure") * -1, 0.00001 );
        //                   lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesClaimLine.Quantity, 0.00001 );

        //                   lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesClaimLine.Quantity *
        //                                                                 lrc_SalesClaimLine."Qty. per Unit of Measure", 0.00001 );
        //                   lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_TempSalesShipmentLine."Packing Unit of Measure (PU)";
        //                   lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_TempSalesShipmentLine."Qty. (PU) per Unit of Measure";
        //                   lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_TempSalesShipmentLine."Quantity (PU)", 0.00001 );
        //                   lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_TempSalesShipmentLine."Transport Unit of Measure (TU)";
        //                   lrc_SalesClaimLine."Qty. (Unit) per Transport (TU)" := lrc_TempSalesShipmentLine."Qty. (Unit) per Transp. Unit";
        //                   lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_TempSalesShipmentLine."Quantity (TU)", 0.00001 );
        //                   lrc_SalesClaimLine."Collo Unit of Measure (CU)" := lrc_TempSalesShipmentLine."Collo Unit of Measure (PQ)";
        //                   lrc_SalesClaimLine."Content Unit of Measure (COU)" := lrc_TempSalesShipmentLine."Content Unit of Measure (COU)";

        //                   lrc_SalesClaimLine."Gross Weight" := lrc_TempSalesShipmentLine."Gross Weight";
        //                   lrc_SalesClaimLine."Net Weight" := lrc_TempSalesShipmentLine."Net Weight";
        //                   lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" := lrc_TempSalesShipmentLine."Qty. (COU) per Pack. Unit (PU)";

        //                   lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_TempSalesShipmentLine."Price Base (Sales Price)";
        //                   lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_TempSalesShipmentLine."Sales Price (Price Base)";
        //                   lrc_SalesClaimLine."Sales Unit Price" := lrc_TempSalesShipmentLine."Unit Price";
        //                   lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" *
        //                                                              lrc_SalesClaimLine.Quantity;
        //                   lrc_SalesClaimLine."Sales Quality Rating" := lrc_TempSalesShipmentLine."Quality Rating";

        //                   lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_TempSalesShipmentLine."Price Unit of Measure";
        //                   lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_TempSalesShipmentLine."Partial Quantity (PQ)";

        //                   lrc_SalesClaimLine."Sales Order No." := lrc_TempSalesShipmentLine."Order No.";
        //                   lrc_SalesClaimLine."Sales Order Line No." := lrc_TempSalesShipmentLine."Order Line No.";
        //                   lrc_SalesClaimLine."Sales Shipment No." := lrc_TempSalesShipmentLine."Document No.";
        //                   lrc_SalesClaimLine."Sales Shipment Line No." := lrc_TempSalesShipmentLine."Line No.";

        //                   lrc_SalesClaimLine."Shipping Agent Code" := lrc_TempSalesShipmentLine."Shipping Agent Code";
        //                   lrc_SalesClaimLine."Location Code" := lrc_TempSalesShipmentLine."Location Code";

        //                   lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_TempSalesShipmentLine."Shipping Agent Code";
        //                   lrc_SalesClaimLine."Claim Location Code" := lrc_TempSalesShipmentLine."Location Code";
        //                   lrc_SalesClaimLine."Claim Quantity" := 0;
        //                   lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
        //                   lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
        //                   lrc_SalesClaimLine."Claim Sales Amount" := 0;
        //                   lrc_SalesClaimLine."Claim Verlust" := 0;
        //                   lrc_SalesClaimLine."Claim Quality Rating" := lrc_TempSalesShipmentLine."Quality Rating";

        //                   //POI 001 00000000 JST 281112 000 Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
        //                   //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
        //                   //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
        //                   gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_TempSalesShipmentLine."Master Batch No.",BuyFromVendorNo,
        //                                                                   VendorOrderNo,IstPackauftrag,PackauftragEindeutig);
        //                   lrc_SalesClaimLine."Buy-from Vendor No.":=BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
        //                   lrc_SalesClaimLine."Vendor Order No.":=VendorOrderNo;
        //                   //Return to Vendor ??
        //                   //POI 001 00000000 JST 281112 e.


        //                  // VKR 006 IFW40127.s
        //                  lrc_FruitVisionSetup.GET();
        //                  //IF (lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT') OR
        //                    //DMG 000 DMG50180.s
        //                  //  (lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN BEGIN
        //                    //DMG 000 DMG50180.e
        //                    FetchPriceFromOrder(lrc_SalesClaimLine);
        //                  //END;
        //                 // VKR 006 IFW40127.e
        //                   //RS Übernahme von Leergutinformationen
        //                   lrc_SalesClaimLine."Empties Blanket Order No." := lrc_TempSalesShipmentLine."Empties Blanket Order No.";
        //                   lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_TempSalesShipmentLine."Empties Blanket Order Line No.";
        //                   lrc_SalesClaimLine."Empties Item No." := lrc_TempSalesShipmentLine."Empties Item No.";
        //                   lrc_SalesClaimLine."Empties Quantity" := lrc_TempSalesShipmentLine."Empties Quantity";
        //                   //RS.e

        //                   lrc_SalesClaimLine.insert();

        //                 UNTIL lrc_BatchVariantEntry.next() = 0;

        //               END ELSE BEGIN
        //               END;

        //             END;

        //           UNTIL lrc_TempSalesShipmentLine.next() = 0;
        //         END ELSE BEGIN
        //         END;

        //         // VKR 009 DMG50020.s
        //         IF lrc_UserSetup.GET(UserID()) THEN BEGIN
        //           IF lrc_UserSetup."Location Group Filter Sales" <> '' THEN BEGIN
        //             lrc_LocationGroup.GET(lrc_UserSetup."Location Group Filter Sales");
        //             IF lrc_LocationGroup."Sales Claim Location Code" <> '' THEN BEGIN
        //               rrc_SalesClaimHeader.VALIDATE("Claim Location Code",lrc_LocationGroup."Sales Claim Location Code");
        //             END;
        //           END;
        //         END;
        //         // VKR 009 DMG50020.e

        //         //-POI-JW 16.05.17
        //         rrc_SalesClaimHeader."Shipment Date" := lrc_SalesShipmentHdr."Shipment Date";
        //         //+POI-JW 16.05.17


        //         /* ######################################################################################################

        //         lrc_SalesClaimLine.RESET();
        //         lrc_SalesClaimLine.SETRANGE("Document No.",lrc_SalesClaimHeader."No.");
        //         IF lrc_SalesClaimLine.FIND('-') THEN BEGIN
        //           // Es sind bereits Zeilen vorhanden! Neu laden?
        //           IF NOT CONFIRM(AGILES_LT_TEXT001) THEN
        //             EXIT;
        //           lrc_SalesClaimLine.DELETEALL(TRUE);
        //         END;

        //         lrc_SalesShipmentHdr.GET(vco_ShipmentNo);
        //         IF lrc_SalesClaimHeader."Sell-to Customer No." <> lrc_SalesShipmentHdr."Sell-to Customer No." THEN
        //           ERROR('Debitor Reklamationsmeldung %1\und Debitor Lieferung %2\sind unterschiedlich!',
        //                 lrc_SalesClaimHeader."Sell-to Customer No.",
        //                 lrc_SalesShipmentHdr."Sell-to Customer No.");

        //         lrc_BatchSetup.get();
        //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Order, lrc_SalesShipmentHdr."Sales Doc. Subtype Code");
        //         IF lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Depend on Doc. Type" THEN BEGIN
        //           lrc_BatchSetup."Sales Batch Assignment" := lrc_SalesDocType."Sales Batch Assignment";
        //         END;



        //         // --------------------------------------------------------------------------------------
        //         // Verkaufslieferzeilen lesen
        //         // --------------------------------------------------------------------------------------
        //         lin_LineNo := 0;
        //         lrc_SalesShipmentLine.RESET();
        //         lrc_SalesShipmentLine.SETRANGE("Document No.",lrc_SalesShipmentHdr."No.");
        //         lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
        //         lrc_SalesShipmentLine.SETFILTER("No.",'<>%1','');
        //         lrc_SalesShipmentLine.setfilter(Quantity,'<>%1','');

        //         IF lrc_SalesShipmentLine.FIND('-') THEN BEGIN
        //           REPEAT

        //             IF lrc_SalesShipmentLine."POI Batch Item" = FALSE THEN BEGIN

        //               lrc_SalesClaimLine.RESET();
        //               lrc_SalesClaimLine.INIT();
        //               lrc_SalesClaimLine."Document No." := lrc_SalesClaimHeader."No.";
        //               lin_LineNo := lin_LineNo + 10000;
        //               lrc_SalesClaimLine."Line No." := lin_LineNo;
        //               lrc_SalesClaimLine.Claiming := FALSE;
        //               lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
        //               lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
        //               lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
        //               lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";
        //               lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
        //               lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
        //               lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
        //               lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
        //               lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
        //               lrc_SalesClaimLine."Color Code" := lrc_SalesShipmentLine."POI Color Code";
        //               lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
        //               lrc_SalesClaimLine."Conservation Code" := lrc_SalesShipmentLine."POI Conservation Code";
        //               lrc_SalesClaimLine."Packing Code" := lrc_SalesShipmentLine."POI Packing Code";
        //               lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
        //               lrc_SalesClaimLine."Treatment Code" := lrc_SalesShipmentLine."POI Treatment Code";
        //               lrc_SalesClaimLine."Quality Code" := lrc_SalesShipmentLine."POI Quality Code";
        //               lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
        //               lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
        //               lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
        //               lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
        //               lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
        //               lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";

        //               lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
        //               lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
        //               lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";
        //         //      lrc_SalesClaimLine."FREI 68" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

        //               lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001 );
        //         //      lrc_SalesClaimLine."Quantity Invoiced" := 0;
        //               lrc_SalesClaimLine.Quantity := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001 );

        //               lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesShipmentLine."Quantity (Base)", 0.00001 );
        //               lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
        //               lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
        //               lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001 );
        //               lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
        //               lrc_SalesClaimLine."Qty. (Unit) per Pallet (TU)" := lrc_SalesShipmentLine."Qty. (Unit) per Pallet (TU)";
        //               lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001 );
        //               lrc_SalesClaimLine."Collo Unit of Measure (CU)" :=  lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
        //               lrc_SalesClaimLine."Content Unit of Measure (COU)" :=  lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";

        //               lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
        //               lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
        //               lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" :=  lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";

        //               lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."Price Unit of Measure Code";
        //               lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

        //               lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
        //               lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" * lrc_SalesClaimLine.Quantity;
        //               lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
        //               lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";
        //               lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
        //               lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
        //               lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
        //               lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
        //               lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
        //               lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
        //               lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";
        //               lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
        //               lrc_SalesClaimLine."Claim Quantity" := 0;
        //               lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
        //               lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
        //               lrc_SalesClaimLine."Claim Sale Amount" := 0;
        //               lrc_SalesClaimLine."Claim Verlust" := 0;

        //               //POI 001 00000000 JST 281112 000 Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
        //               //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
        //               //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
        //               gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.",BuyFromVendorNo,
        //                                                                   VendorOrderNo,IstPackauftrag,PackauftragEindeutig);
        //               lrc_SalesClaimLine."Buy-from Vendor No.":=BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
        //               lrc_SalesClaimLine."Vendor Order No.":=VendorOrderNo;
        //               //Return to Vendor ??
        //               //POI 001 00000000 JST 281112 e.

        //               // VKR 006 IFW40127.s
        //               lrc_FruitVisionSetup.GET();
        //               //IF (lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT') OR
        //                 //DMG 000 DMG50180.s
        //               //  (lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN BEGIN
        //                 //DMG 000 DMG50180.s
        //                 FetchPriceFromOrder(lrc_SalesClaimLine);
        //               //END;
        //               // VKR 006 IFW40127.e

        //               //RS Übernahme von Leergutinformationen
        //               lrc_SalesClaimLine."Empties Blanket Order No." := lrc_SalesShipmentLine."POI Empties Blanket Order No.";
        //               lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_SalesShipmentLine."POI Empt Blank Order Line No.";
        //               lrc_SalesClaimLine."Empties Item No." := lrc_SalesShipmentLine."POI Empties Item No.";
        //               lrc_SalesClaimLine."Empties Quantity" := lrc_SalesShipmentLine."POI Empties Quantity";
        //               //RS.e

        //               lrc_SalesClaimLine.insert();

        //             END ELSE BEGIN

        //               CASE lrc_BatchSetup."Sales Batch Assignment" OF
        //               lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line":
        //               BEGIN

        //                 lrc_SalesShipmentLine.TESTFIELD("Batch Var. Detail ID");
        //                 lrc_BatchVariantEntry.RESET();
        //                 lrc_BatchVariantEntry.SETCURRENTKEY("Detail Entry No.","Detail Line No.");
        //                 lrc_BatchVariantEntry.SETRANGE("Detail Entry No.",lrc_SalesShipmentLine."Batch Var. Detail ID");
        //                 //DMG 000 DMG50180.s
        //                 lrc_BatchVariantEntry.SETRANGE("Source Doc. Type",lrc_BatchVariantEntry."Source Doc. Type"::Order);
        //                 lrc_BatchVariantEntry.SETRANGE("Source Doc. No.", lrc_SalesShipmentLine."Order No.");
        //                 lrc_BatchVariantEntry.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
        //                 lrc_BatchVariantEntry.SETRANGE( "Document Line No.", lrc_SalesShipmentLine."Line No." );
        //                 lrc_BatchVariantEntry.SETRANGE( Correction, FALSE );
        //                 //DMG 000 DMG50180.e

        //                 IF lrc_BatchVariantEntry.FIND('-') THEN
        //                 REPEAT

        //                   lrc_SalesClaimLine.RESET();
        //                   lrc_SalesClaimLine.INIT();
        //                   lrc_SalesClaimLine."Document No." := lrc_SalesClaimHeader."No.";
        //                   lin_LineNo := lin_LineNo + 10000;
        //                   lrc_SalesClaimLine."Line No." := lin_LineNo;
        //                   lrc_SalesClaimLine.Claiming := FALSE;
        //                   lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
        //                   lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
        //                   lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
        //                   lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";
        //                   lrc_SalesClaimLine."Master Batch No." := lrc_BatchVariantEntry."Master Batch No.";
        //                   lrc_SalesClaimLine."Batch No." := lrc_BatchVariantEntry."Batch No.";
        //                   lrc_SalesClaimLine."Batch Variant No." := lrc_BatchVariantEntry."Batch Variant No.";
        //                   lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
        //                   lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
        //                   lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
        //                   lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
        //                   lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
        //                   lrc_SalesClaimLine."Color Code" := lrc_SalesShipmentLine."POI Color Code";
        //                   lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
        //                   lrc_SalesClaimLine."Conservation Code" := lrc_SalesShipmentLine."POI Conservation Code";
        //                   lrc_SalesClaimLine."Packing Code" := lrc_SalesShipmentLine."POI Packing Code";
        //                   lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
        //                   lrc_SalesClaimLine."Treatment Code" := lrc_SalesShipmentLine."POI Treatment Code";
        //                   lrc_SalesClaimLine."Quality Code" := lrc_SalesShipmentLine."POI Quality Code";
        //                   lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
        //                   lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
        //                   lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
        //                   lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
        //                   lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
        //                   lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";

        //                   lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
        //                   lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
        //                   lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";
        //         //          lrc_SalesClaimLine."FREI 68" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

        //                   lrc_SalesClaimLine.Quantity := ROUND((lrc_BatchVariantEntry."Quantity (Base)" /
        //                                                        lrc_SalesShipmentLine."Qty. per Unit of Measure") * -1, 0.00001 );
        //                   lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesClaimLine.Quantity, 0.00001 );

        //                   lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesClaimLine.Quantity *
        //                                                                 lrc_SalesClaimLine."Qty. per Unit of Measure", 0.00001 );
        //                   lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
        //                   lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
        //                   lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001 );
        //                   lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
        //                   lrc_SalesClaimLine."Qty. (Unit) per Pallet (TU)" := lrc_SalesShipmentLine."Qty. (Unit) per Pallet (TU)";
        //                   lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001 );
        //                   lrc_SalesClaimLine."Collo Unit of Measure (CU)" :=  lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
        //                   lrc_SalesClaimLine."Content Unit of Measure (COU)" :=  lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";

        //                   lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
        //                   lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
        //                   lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" :=  lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";

        //                   lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
        //                   lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" *
        //                                                              lrc_SalesClaimLine.Quantity;

        //                   lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
        //                   lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";

        //                   lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."Price Unit of Measure Code";
        //                   lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

        //                   lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
        //                   lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
        //                   lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
        //                   lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
        //                   lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
        //                   lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
        //                   lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";
        //                   lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
        //                   lrc_SalesClaimLine."Claim Quantity" := 0;
        //                   lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
        //                   lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
        //                   lrc_SalesClaimLine."Claim Sale Amount" := 0;
        //                   lrc_SalesClaimLine."Claim Verlust" := 0;

        //                   //POI 001 00000000 JST 281112 000 Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
        //                   //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
        //                   //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
        //                   gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.",BuyFromVendorNo,
        //                                                                   VendorOrderNo,IstPackauftrag,PackauftragEindeutig);
        //                   lrc_SalesClaimLine."Buy-from Vendor No.":=BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
        //                   lrc_SalesClaimLine."Vendor Order No.":=VendorOrderNo;
        //                   //Return to Vendor ??
        //                   //POI 001 00000000 JST 281112 e.

        //                   // VKR 006 IFW40127.s
        //                   lrc_FruitVisionSetup.GET();
        //                   //IF (lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT') OR
        //                     //DMG 000 DMG50180.s
        //                   //  (lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN BEGIN
        //                     //DMG 000 DMG50180.s
        //                     FetchPriceFromOrder(lrc_SalesClaimLine);
        //                   //END;
        //                   // VKR 006 IFW40127.e

        //                   //RS Übernahme von Leergutinformationen
        //                   lrc_SalesClaimLine."Empties Blanket Order No." := lrc_SalesShipmentLine."POI Empties Blanket Order No.";
        //                   lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_SalesShipmentLine."POI Empt Blank Order Line No.";
        //                   lrc_SalesClaimLine."Empties Item No." := lrc_SalesShipmentLine."POI Empties Item No.";
        //                   lrc_SalesClaimLine."Empties Quantity" := lrc_SalesShipmentLine."POI Empties Quantity";
        //                   //RS.e

        //                   lrc_SalesClaimLine.insert();

        //                 UNTIL lrc_BatchVariantEntry.next() = 0;

        //               END;

        //               lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line",
        //               lrc_BatchSetup."Sales Batch Assignment"::"Automatic from System":
        //               BEGIN

        //                 IF NOT lrc_BatchVariant.GET(lrc_BatchVariantEntry."Batch Variant No.") THEN
        //                   lrc_BatchVariant.INIT();

        //                 lrc_SalesClaimLine.RESET();
        //                 lrc_SalesClaimLine.INIT();
        //                 lrc_SalesClaimLine."Document No." := lrc_SalesClaimHeader."No.";
        //                 lin_LineNo := lin_LineNo + 10000;
        //                 lrc_SalesClaimLine."Line No." := lin_LineNo;
        //                 lrc_SalesClaimLine.Claiming := FALSE;
        //                 lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
        //                 lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
        //                 lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
        //                 lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";

        //                 lrc_SalesClaimLine."Master Batch No." := lrc_SalesShipmentLine."POI Master Batch No.";
        //                 lrc_SalesClaimLine."Batch No." := lrc_SalesShipmentLine."Batch No.";
        //                 lrc_SalesClaimLine."Batch Variant No." := lrc_SalesShipmentLine."Batch Variant No.";
        //                 lrc_SalesClaimLine."Vendor No." := lrc_BatchVariant."Vendor No.";

        //                 lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
        //                 lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
        //                 lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
        //                 lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
        //                 lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
        //                 lrc_SalesClaimLine."Color Code" := lrc_SalesShipmentLine."POI Color Code";
        //                 lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
        //                 lrc_SalesClaimLine."Conservation Code" := lrc_SalesShipmentLine."POI Conservation Code";
        //                 lrc_SalesClaimLine."Packing Code" := lrc_SalesShipmentLine."POI Packing Code";
        //                 lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
        //                 lrc_SalesClaimLine."Treatment Code" := lrc_SalesShipmentLine."POI Treatment Code";
        //                 lrc_SalesClaimLine."Quality Code" := lrc_SalesShipmentLine."POI Quality Code";
        //                 lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
        //                 lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
        //                 lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
        //                 lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
        //                 lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
        //                 lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";

        //                 lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."Price Unit of Measure Code";
        //                 lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

        //                 lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
        //                 lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
        //                 lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";
        //         //        lrc_SalesClaimLine."FREI 68" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

        //                 lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001 );
        //         //      lrc_SalesClaimLine."Quantity Invoiced" := 0;
        //                 lrc_SalesClaimLine.Quantity := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001 );

        //                 lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesShipmentLine."Quantity (Base)", 0.00001 );
        //                 lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
        //                 lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
        //                 lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001 );
        //                 lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
        //                 lrc_SalesClaimLine."Qty. (Unit) per Pallet (TU)" := lrc_SalesShipmentLine."Qty. (Unit) per Pallet (TU)";
        //                 lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001 );
        //                 lrc_SalesClaimLine."Collo Unit of Measure (CU)" :=  lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
        //                 lrc_SalesClaimLine."Content Unit of Measure (COU)" :=  lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";

        //                 lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
        //                 lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
        //                 lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" :=  lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";

        //                 lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
        //                 lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" *
        //                                                            lrc_SalesClaimLine.Quantity;

        //                 lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
        //                 lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";

        //                 lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
        //                 lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
        //                 lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
        //                 lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
        //                 lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
        //                 lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
        //                 lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";
        //                 lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
        //                 lrc_SalesClaimLine."Claim Quantity" := 0;
        //                 lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
        //                 lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
        //                 lrc_SalesClaimLine."Claim Sale Amount" := 0;
        //                 lrc_SalesClaimLine."Claim Verlust" := 0;

        //                 //POI 001 00000000 JST 281112 000 Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
        //                 //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
        //                 //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
        //                 gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.",BuyFromVendorNo,
        //                                                                   VendorOrderNo,IstPackauftrag,PackauftragEindeutig);
        //                 lrc_SalesClaimLine."Buy-from Vendor No.":=BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
        //                 lrc_SalesClaimLine."Vendor Order No.":=VendorOrderNo;
        //                 //Return to Vendor ??
        //                 //POI 001 00000000 JST 281112 e.


        //                 // VKR 006 IFW40127.s
        //                 lrc_FruitVisionSetup.GET();
        //                 //IF (lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT') OR
        //                   //DMG 000 DMG50180.s
        //                 //  (lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN BEGIN
        //                   //DMG 000 DMG50180.s
        //                   FetchPriceFromOrder(lrc_SalesClaimLine);
        //                 //END;
        //                 // VKR 006 IFW40127.e

        //                 //RS Übernahme von Leergutinformationen
        //                 lrc_SalesClaimLine."Empties Blanket Order No." := lrc_SalesShipmentLine."POI Empties Blanket Order No.";
        //                 lrc_SalesClaimLine."Empties Blanket Order Line No." := lrc_SalesShipmentLine."POI Empt Blank Order Line No.";
        //                 lrc_SalesClaimLine."Empties Item No." := lrc_SalesShipmentLine."POI Empties Item No.";
        //                 lrc_SalesClaimLine."Empties Quantity" := lrc_SalesShipmentLine."POI Empties Quantity";
        //                 //RS.e

        //                 lrc_SalesClaimLine.insert();

        //                 END;
        //               END;
        //             END;

        //           UNTIL lrc_SalesShipmentLine.next() = 0;

        //         END;

        //         // ---------------------------------------------------------------------------------------------
        //         // Auftragsnummer in Kopfsatz speichern
        //         // ---------------------------------------------------------------------------------------------
        //         lrc_SalesClaimHeader."Sales Invoice No." := '';
        //         lrc_SalesClaimHeader."Sales Shipment No." := vco_ShipmentNo;
        //         lrc_SalesClaimHeader."Sales Order No." := lrc_SalesShipmentHdr."Order No.";
        //         lrc_SalesClaimHeader."Sales Doc. Typ Code" := lrc_SalesShipmentHdr."Sales Doc. Subtype Code";
        //         lrc_SalesClaimHeader."Sales Salesperson Code" := lrc_SalesShipmentHdr."Salesperson Code";
        //         lrc_SalesClaimHeader."Location Code" := lrc_SalesShipmentHdr."Location Code";
        //         lrc_SalesClaimHeader."Claim Location Code" := lrc_SalesShipmentHdr."Location Code";

        //         //DMG 006 DMG50185.s
        //         rrc_SalesClaimHeader."Ship-to Code" := lrc_SalesShipmentHdr."Ship-to Code";
        //         rrc_SalesClaimHeader."Ship-to Name" :=  lrc_SalesShipmentHdr."Ship-to Name";
        //         rrc_SalesClaimHeader."Ship-to Name 2" := lrc_SalesShipmentHdr."Ship-to Name 2";
        //         rrc_SalesClaimHeader."Ship-to Address" := lrc_SalesShipmentHdr."Ship-to Address";
        //         rrc_SalesClaimHeader."Ship-to Address 2":=  lrc_SalesShipmentHdr."Ship-to Address 2";
        //         rrc_SalesClaimHeader."Ship-to City" :=  lrc_SalesShipmentHdr."Ship-to City";
        //         rrc_SalesClaimHeader."Ship-to Contact" := lrc_SalesShipmentHdr."Ship-to Contact";
        //         rrc_SalesClaimHeader."Ship-to Post Code" := lrc_SalesShipmentHdr."Ship-to Post Code";
        //         rrc_SalesClaimHeader."Ship-to Country Code" :=  lrc_SalesShipmentHdr."Ship-to Country Code";
        //         //DMG 006 DMG50185.e




        //         ###################################################################################################### */

    end;

    //     procedure CreateSalesCreditMemo(vco_ClaimNo: Code[20])
    //     var
    //         lcu_ReleaseSalesDocument: Codeunit "414";
    //         lcu_SalesPost: Codeunit "80";
    //         lcu_Sales: Codeunit "5110324";
    //         lcu_BatchManagement: Codeunit "5110307";
    //         lcu_PalletManagement: Codeunit "5110346";
    //         lcu_CommentMgt: Codeunit "5110317";
    //         lcu_StockManagement: Codeunit "5110339";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_SalesCreditMemoReasons: Record "5110327";
    //         lrc_SalesClaimHeader: Record "5110455";
    //         lrc_SalesClaimLine: Record "5110456";
    //         lrc_SalesClaimCost: Record "5110731";
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lrc_ItemChargeAssignSales: Record "5809";
    //         lrc_SalesHeader2: Record "36";
    //         lrc_Item: Record Item;
    //         lrc_Item2: Record Item;
    //         lrc_ItemCharge: Record "5800";
    //         lrc_IncomingPallet: Record "5110445";
    //         lrc_IncomingPallet2: Record "5110445";
    //         lrc_SalesShipmentLine: Record "111";
    //         lrc_SalesLine2: Record "37";
    //         lrc_SalesLineChargeItem: Record "37";
    //         lrc_Customer: Record "Customer";
    //         lrc_SalesDiscountLine: Record "5110380";
    //         lco_SalesClaimCrMemoDefItemCha: Code[20];
    //         lco_GenProdPostingGroup: Code[10];
    //         lco_VATProdPostingGroup: Code[10];
    //         lco_VATBusPostingGroup: Code[10];
    //         lco_GenBusPostingGroup: Code[10];
    //         AGILES_LT_TEXT001: Label 'Es sind keine Zeile für eine Gutschrift vorhanden!';
    //         AGILES_LT_TEXT002: Label 'Es ist kein gültiger Zu-/Abschlag vorhanden !';
    //         AGILES_LT_TEXT003: Label 'Es bestehende %1 eingehende Palettenzeilen für die Art Zu-/Abschlag !';
    //         AGILES_LT_TEXT004: Label 'The credit memo %1 could not be posted !';
    //         AGILES_LT_TEXT005: Label 'The credit memo %1 was posted !';
    //         lbn_SalesDocumentLineFound: Boolean;
    //         lbn_FirstLineGL: Boolean;
    //         AGILES_LT_TEXT006: Label 'Status muss auf offen stehen!';
    //         AGILES_LT_TEXT007: Label 'Es wurde bereits eine Gutschrift erzeugt!';
    //         lin_LineNo: Integer;
    //         lin_LineCreated: Integer;
    //         "-- VKR 008 IFW40163 L": Integer;
    //         lbn_NewCreditMemo: Boolean;
    //         ADF_LT_TEXT001: Label 'Preis (Preisbasis) darf nicht Null sein!';
    //         "--- DMG 015 DMG50371 L": Integer;
    //         lrc_ClaimDocSubtype: Record "5087971";
    //         lbn_OpenCreditMemo: Boolean;
    //         AGILES_LT_TEXT008: Label 'Soll die erstellte Gutschrift %1 geöffnet werden ?';
    //         "---RS": InStream;
    //         lcu_EmptiesManagement: Codeunit "5110325";
    //         lrc_PostedDocumentDim: Record "359";
    //         lrc_DocumentDim: Record "357";
    //         lrc_DimensionValue: Record "349";
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Verkaufsgutschrift erstellen
    //         // -------------------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.get();
    //         lrc_BatchSetup.get();

    //         lrc_SalesClaimHeader.GET(vco_ClaimNo);
    //         lrc_SalesClaimHeader.TESTFIELD("Sell-to Customer No.");

    //         IF lrc_SalesClaimHeader.Status <> lrc_SalesClaimHeader.Status::Open THEN
    //           // Status muss auf offen stehen!
    //           //POI 005 REKlSTAT JST 110713 000 Gutschrufterstellung auf bei Status Geschlossen
    //           //hier Error auskommentiert
    //           //ERROR(AGILES_LT_TEXT006);
    //         IF lrc_SalesClaimHeader."Sales Cr. Memo No." <> '' THEN
    //           // Es wurde bereits eine Gutschrift erzeugt!
    //           ERROR(AGILES_LT_TEXT007);

    //         // Kontrolle ob bereits Zeilen in Gutschrift übertragen wurden
    //         lrc_SalesClaimLine.RESET();
    //         lrc_SalesClaimLine.SETRANGE("Document No.",lrc_SalesClaimHeader."No.");
    //         lrc_SalesClaimLine.SETRANGE(Type,lrc_SalesClaimLine.Type::Item);
    //         lrc_SalesClaimLine.SETFILTER("No.",'<>%1','');
    //         lrc_SalesClaimLine.SETRANGE(Claim,TRUE);
    //         lrc_SalesClaimLine.SETRANGE("Transfered to Cr.M./Return O.",TRUE);
    //         IF lrc_SalesClaimLine.FINDFIRST() THEN BEGIN
    //           IF NOT CONFIRM('Mindestens eine Zeile aus der Reklamation wurde bereits in eine Gutschrift / Rücksendung übertragen!' +
    //                          ' Möchten Sie trotzdem fortfahren?') THEN
    //             ERROR('');
    //         END;

    //         // Grund für die Erstellung einer Gutschrift ermitteln
    //         lrc_SalesCreditMemoReasons.RESET();
    //         lrc_SalesCreditMemoReasons.SETRANGE(Claim,TRUE);
    //         IF NOT lrc_SalesCreditMemoReasons.FINDFIRST() THEN
    //           lrc_SalesCreditMemoReasons.INIT();

    //         lrc_SalesClaimLine.RESET();
    //         lrc_SalesClaimLine.SETRANGE("Document No.",lrc_SalesClaimHeader."No.");
    //         lrc_SalesClaimLine.SETRANGE(Claim,TRUE);
    //         lrc_SalesClaimLine.SETRANGE(Type,lrc_SalesClaimLine.Type::Item);
    //         lrc_SalesClaimLine.SETFILTER("No.",'<>%1','');
    //         IF lrc_SalesClaimLine.FINDSET(TRUE,FALSE) THEN BEGIN

    //           lbn_NewCreditMemo := TRUE;
    //           IF lrc_FruitVisionSetup."Sales Claim CrM. Creation" =
    //              lrc_FruitVisionSetup."Sales Claim CrM. Creation"::"Existing Credit Memo" THEN BEGIN
    //             IF CONFIRM(AGILES_TEXT001Txt,TRUE) THEN BEGIN
    //               // Form aufrufen
    //               lrc_SalesHeader.RESET();
    //               lrc_SalesHeader.SETRANGE("Document Type", lrc_SalesHeader."Document Type"::"Credit Memo");
    //               lrc_SalesHeader.SETRANGE("Sell-to Customer No.",lrc_SalesClaimHeader."Sell-to Customer No.");
    //               IF FORM.RUNMODAL(0, lrc_SalesHeader) <> ACTION::LookupOK THEN
    //                 ERROR(AGILES_TEXT002Txt);

    //               lbn_NewCreditMemo := FALSE;
    //               lrc_SalesLine.RESET();
    //               lrc_SalesLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //               lrc_SalesLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //               IF lrc_SalesLine.FINDLAST THEN BEGIN
    //                 lin_LineNo := lrc_SalesLine."Line No.";
    //               END;
    //             END ELSE BEGIN
    //               lbn_NewCreditMemo := TRUE;
    //             END;
    //           END;

    //           // Gutschriftenkopf anlegen
    //           IF lbn_NewCreditMemo THEN BEGIN
    //             lrc_SalesHeader.RESET();
    //             lrc_SalesHeader.INIT();
    //             IF lrc_FruitVisionSetup."Sales Claim Posting Type" =
    //                lrc_FruitVisionSetup."Sales Claim Posting Type"::"Double Stage" THEN BEGIN
    //               lrc_SalesHeader."Document Type" := lrc_SalesHeader."Document Type"::"Return Order";
    //               lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Order,lrc_SalesClaimHeader."Sales Doc. Subtyp Code");
    //               lrc_SalesDocType.TESTFIELD("Return Doc. Subtype Code");
    //               lrc_SalesHeader."Sales Doc. Subtype Code" := lrc_SalesDocType."Return Doc. Subtype Code";
    //               lrc_SalesHeader."Credit Memo Reason Code" := lrc_SalesCreditMemoReasons.Code;
    //               lrc_SalesHeader."No." := '';
    //               lrc_SalesHeader.INSERT(TRUE);
    //             END ELSE BEGIN
    //               lrc_SalesHeader."Document Type" := lrc_SalesHeader."Document Type"::"Credit Memo";
    //               lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Order,lrc_SalesClaimHeader."Sales Doc. Subtyp Code");
    //               lrc_SalesDocType.TESTFIELD("Cr. Memo Doc. Subtype Code");
    //               lrc_SalesHeader."Sales Doc. Subtype Code" := lrc_SalesDocType."Cr. Memo Doc. Subtype Code";
    //               lrc_SalesHeader."Credit Memo Reason Code" := lrc_SalesCreditMemoReasons.Code;
    //               lrc_SalesHeader."No." := '';
    //               lrc_SalesHeader.INSERT(TRUE);
    //             END;

    //             lrc_SalesHeader.VALIDATE("Sell-to Customer No.",lrc_SalesClaimHeader."Sell-to Customer No.");
    //             //POI 001 00000000 JST 291112 000 Claim Location und "Claim Shipping Agent Code" entscheidend
    //             //IF lrc_SalesClaimHeader."Return to Location Code" <> '' THEN
    //             //  lrc_SalesHeader.VALIDATE("Location Code",lrc_SalesClaimHeader."Return to Location Code");
    //             IF lrc_SalesClaimHeader."Claim Location Code" <> '' THEN
    //               lrc_SalesHeader.VALIDATE("Location Code",lrc_SalesClaimHeader."Claim Location Code");
    //             IF lrc_SalesClaimHeader."Claim Shipping Agent Code" <> '' THEN
    //               lrc_SalesHeader."Shipping Agent Code":=lrc_SalesClaimHeader."Claim Shipping Agent Code";
    //             //POI 001 00000000 JST 291112 e.

    //             lrc_SalesHeader."Your Reference" := lrc_SalesClaimHeader."Your Reference";
    //             lrc_SalesHeader."Sales Claim Notify No." := lrc_SalesClaimHeader."No.";

    //             // Bemerkungen aus Reklamation in Gutschrfit kopieren
    //             lcu_CommentMgt.CopySalesClaimComment(lrc_SalesHeader."Document Type",lrc_SalesHeader."No.",0,
    //                                                  lrc_SalesHeader."Sales Claim Notify No.");

    //             IF lrc_SalesClaimHeader."Pallet Entry ID" <> 0 THEN
    //               lrc_SalesHeader."Pallets Entry No." := lcu_PalletManagement.NewPalletEntryNo;

    //             // KHH 006 KHH50240.s
    //               lrc_SalesHeader."Customer Order No." := lrc_SalesClaimHeader."Sales Cust. Order No.";
    //               lrc_SalesHeader."Posting Description" := 'Auftrag' +' '+
    //                                                        lrc_SalesClaimHeader."Sales Order No.";


    //             // FV START 260808
    //             lrc_SalesHeader."Cr. Memo Ship. No." := lrc_SalesClaimHeader."Sales Shipment No.";
    //             lrc_SalesHeader."Cr. Memo Ship. Date" := lrc_SalesClaimHeader."Sales Shipment Posting Date";
    //             lrc_SalesHeader."Cr. Memo Order No." := lrc_SalesClaimHeader."Sales Order No.";
    //             // FV END

    //             //-POI-JW 23.02.17
    //             lrc_SalesHeader."Shipment Date" := lrc_SalesClaimHeader."Shipment Date";
    //             //+POI-JW 23.02.17

    //             // KHH 003 KHH50240.e
    //             lrc_SalesHeader.Modify();

    //             // KHH 003 KHH50240.e
    //             lrc_SalesHeader.Modify();

    //             LoadDataFromOriginDocInCrMemo(lrc_SalesClaimHeader, lrc_SalesHeader);
    //           END;

    //           // ------------------------------------------------------------------------------
    //           // Gutschriftszeilen anlegen
    //           // ------------------------------------------------------------------------------
    //           lin_LineCreated := 0;
    //           REPEAT

    //             lco_GenProdPostingGroup := '';
    //             lco_VATProdPostingGroup := '';
    //             lco_VATBusPostingGroup := '';
    //             lco_GenBusPostingGroup := '';
    //             lbn_SalesDocumentLineFound := FALSE;

    //             // Gutschriftenzeilen für Rücknahme anlegen
    //             IF lrc_SalesClaimLine."Claim Return Quantity" = TRUE THEN BEGIN

    //               lrc_SalesLine.RESET();
    //               lrc_SalesLine.INIT();
    //               lrc_SalesLine."Document Type" := lrc_SalesHeader."Document Type";
    //               lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
    //               lin_LineNo := lin_LineNo + 10000;
    //               lrc_SalesLine."Line No." := lin_LineNo;
    //               lrc_SalesLine.insert();

    //               lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::Item);
    //               lrc_SalesLine.VALIDATE("No.",lrc_SalesClaimLine."No.");

    //               IF lrc_SalesClaimLine.Type = lrc_SalesClaimLine.Type::Item THEN BEGIN
    //                 lrc_Item.GET(lrc_SalesClaimLine."No.");
    //                 lco_GenProdPostingGroup := lrc_Item."Gen. Prod. Posting Group";
    //                 lco_VATProdPostingGroup := lrc_Item."VAT Prod. Posting Group";
    //               END;
    //               lrc_Customer.GET(lrc_SalesHeader."Sell-to Customer No.");
    //               lco_GenBusPostingGroup := lrc_Customer."Gen. Bus. Posting Group";
    //               lco_VATBusPostingGroup := lrc_Customer."VAT Bus. Posting Group";

    //               lrc_SalesLine.VALIDATE("Location Code",lrc_SalesClaimLine."Claim Location Code");
    //               lrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_SalesClaimLine."Unit of Measure Code");

    //               IF lrc_SalesLine."Batch Item" = TRUE THEN BEGIN
    //                 lrc_SalesClaimLine.TESTFIELD("Master Batch No.");
    //                 lrc_SalesClaimLine.TESTFIELD("Batch No.");
    //                 lrc_SalesClaimLine.TESTFIELD("Batch Variant No.");
    //                 lrc_SalesLine."Master Batch No." := lrc_SalesClaimLine."Master Batch No.";
    //                 lrc_SalesLine."Batch No." := lrc_SalesClaimLine."Batch No.";
    //                 lrc_SalesLine.VALIDATE("Batch Variant No.", lrc_SalesClaimLine."Batch Variant No.");
    //               END;
    //               //RS Lagerortkombi in tbl 5087939 füllen
    //               lcu_StockManagement.BatchVarFillLocations(lrc_SalesLine."Batch Variant No.", lrc_SalesLine."Batch No.",
    //                                   lrc_SalesLine."No.", lrc_SalesClaimLine."Claim Location Code");

    //               lrc_SalesLine.VALIDATE(Quantity,lrc_SalesClaimLine."Claim Quantity");
    //               lrc_SalesLine."Reference Doc. No." := lrc_SalesClaimLine."Sales Shipment No.";
    //               lrc_SalesLine."Reference Doc. Line No." := lrc_SalesClaimLine."Sales Shipment Line No.";

    //               IF (lrc_SalesClaimLine."Claim Sales Price (Price Base)" = 0) AND
    //                  (lrc_SalesClaimLine."Claim Sales Unit Price" <> 0) THEN
    //                 // Preis (Preisbasis) darf nicht Null sein!
    //                 ERROR(ADF_LT_TEXT001);

    //               // FV START 030209

    //               IF (lrc_SalesClaimLine."Claim Sales Price (Price Base)" = 0) AND
    //                  (lrc_SalesClaimLine."Claim Sales Unit Price" <> 0) THEN BEGIN
    //                 lrc_SalesLine.VALIDATE("Price Base (Sales Price)", '');
    //                 lrc_SalesLine.VALIDATE("Sales Price (Price Base)",lrc_SalesClaimLine."Claim Sales Unit Price");
    //                 lrc_SalesLine.VALIDATE("Unit Price",lrc_SalesClaimLine."Claim Sales Unit Price");
    //               END ELSE BEGIN
    //                 lrc_SalesLine.VALIDATE("Price Base (Sales Price)", lrc_SalesClaimLine."Price Base (Sales Price)");
    //                 lrc_SalesLine.VALIDATE("Sales Price (Price Base)",lrc_SalesClaimLine."Claim Sales Price (Price Base)");
    //                 lrc_SalesLine.VALIDATE("Unit Price",lrc_SalesClaimLine."Claim Sales Unit Price");
    //               END;


    //               /*
    //               lrc_SalesLine.VALIDATE("Price Base (Sales Price)", lrc_SalesClaimLine."Price Base (Sales Price)");
    //               lrc_SalesLine.VALIDATE("Sales Price (Price Base)",
    //                                      (lrc_SalesClaimLine."Sales Price (Price Base)" -
    //                                       lrc_SalesClaimLine."Claim Sales Price (Price Base)"));
    //              */
    //               lrc_SalesLine.VALIDATE("Net Weight", lrc_SalesClaimLine."Net Weight");
    //               lrc_SalesLine.VALIDATE("Gross Weight", lrc_SalesClaimLine."Gross Weight");

    //               lrc_SalesLine."Empties Item No." := '';
    //               lrc_SalesLine."Empties Quantity" := 0;
    //               lrc_SalesLine."Empties Refund Amount" := 0;
    //               lrc_SalesLine."Empties Line No" := 0;

    //               CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                 lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension" :
    //                         lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension" :
    //                         lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension" :
    //                         lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension" :
    //                         lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code",lrc_SalesClaimLine."Batch No.");
    //               END;

    //               IF (lrc_SalesClaimLine."Sales Shipment No." <> '') AND
    //                  (lrc_SalesClaimLine."Sales Shipment Line No." <> 0) THEN BEGIN
    //                 IF lrc_SalesShipmentLine.GET(lrc_SalesClaimLine."Sales Shipment No.",
    //                                              lrc_SalesClaimLine."Sales Shipment Line No.") THEN BEGIN
    //                   lco_GenProdPostingGroup := lrc_SalesShipmentLine."Gen. Prod. Posting Group";
    //                   lco_VATProdPostingGroup := lrc_SalesShipmentLine."VAT Prod. Posting Group";
    //                   lco_GenBusPostingGroup := lrc_SalesShipmentLine."Gen. Bus. Posting Group";
    //                   lco_VATBusPostingGroup := lrc_SalesShipmentLine."VAT Bus. Posting Group";

    //                   lbn_SalesDocumentLineFound := TRUE;
    //                 END;
    //               END;

    //               IF lbn_SalesDocumentLineFound = FALSE THEN BEGIN
    //                 IF (lrc_SalesClaimLine."Sales Order No." <> '') AND
    //                    (lrc_SalesClaimLine."Sales Order Line No." <> 0) THEN BEGIN
    //                   IF lrc_SalesLine2.GET(lrc_SalesLine2."Document Type"::Order,
    //                                         lrc_SalesClaimLine."Sales Order No.",
    //                                         lrc_SalesClaimLine."Sales Order Line No.") THEN BEGIN
    //                     lco_GenProdPostingGroup := lrc_SalesLine2."Gen. Prod. Posting Group";
    //                     lco_VATProdPostingGroup := lrc_SalesLine2."VAT Prod. Posting Group";
    //                     lco_GenBusPostingGroup := lrc_SalesLine2."Gen. Bus. Posting Group";
    //                     lco_VATBusPostingGroup := lrc_SalesLine2."VAT Bus. Posting Group";


    //                     lbn_SalesDocumentLineFound := TRUE;
    //                   END;
    //                 END;
    //               END;

    //               lrc_SalesLine.VALIDATE("Gen. Prod. Posting Group", lco_GenProdPostingGroup);
    //               lrc_SalesLine.VALIDATE("VAT Prod. Posting Group", lco_VATProdPostingGroup);
    //               lrc_SalesLine.VALIDATE("Gen. Bus. Posting Group", lco_GenBusPostingGroup);
    //               lrc_SalesLine.VALIDATE("VAT Bus. Posting Group", lco_VATBusPostingGroup);

    //               lrc_SalesLine."Reference Doc. Type" := lrc_SalesLine."Reference Doc. Type"::"Sales Shipment";
    //               lrc_SalesLine."Reference Doc. No." := lrc_SalesClaimLine."Sales Shipment No.";
    //               lrc_SalesLine."Reference Doc. Line No." := lrc_SalesClaimLine."Sales Shipment Line No.";
    //               IF lrc_SalesClaimLine.Type = lrc_SalesClaimLine.Type::Item THEN BEGIN
    //                 lrc_SalesLine."Reference Item No." := lrc_SalesClaimLine."No.";
    //               END;

    //               lrc_SalesLine.Modify();

    //               //RS Dimensionen kopieren
    //               IF lrc_SalesClaimLine."Sales Invoice No." <> '' THEN BEGIN
    //                 lrc_PostedDocumentDim.SETRANGE("Table ID", 113);
    //                 lrc_PostedDocumentDim.SETRANGE("Document No.", lrc_SalesClaimLine."Sales Invoice No.");
    //                 lrc_PostedDocumentDim.SETRANGE("Line No.", lrc_SalesClaimLine."Sales Invoice Line No.");
    //                 IF lrc_PostedDocumentDim.FINDSET(FALSE, FALSE) THEN BEGIN
    //                   REPEAT
    //                     IF lrc_PostedDocumentDim."Dimension Value Code" <> '' THEN BEGIN
    //                       IF NOT lrc_DocumentDim.GET(37, lrc_SalesHeader."Document Type", lrc_SalesHeader."No.",
    //                                                  lin_LineNo, lrc_PostedDocumentDim."Dimension Code") THEN BEGIN
    //                         lrc_DocumentDim.INIT();
    //                         lrc_DocumentDim."Table ID" := 37;
    //                         lrc_DocumentDim."Document Type" := lrc_SalesHeader."Document Type";
    //                         lrc_DocumentDim."Document No." := lrc_SalesHeader."No.";
    //                         lrc_DocumentDim."Line No." := lin_LineNo;
    //                         lrc_DocumentDim."Dimension Code" := lrc_PostedDocumentDim."Dimension Code";
    //                         lrc_DocumentDim."Dimension Value Code" := lrc_PostedDocumentDim."Dimension Value Code";
    //                         lrc_DocumentDim.insert();
    //                         lrc_DimensionValue.GET(lrc_PostedDocumentDim."Dimension Code", lrc_PostedDocumentDim."Dimension Value Code");
    //                         CASE lrc_DimensionValue."Global Dimension No." OF
    //                             1:
    //                               BEGIN
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", lrc_DocumentDim."Dimension Value Code");
    //                                 lrc_SalesLine.Modify();
    //                               END;
    //                             2:
    //                               BEGIN
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", lrc_DocumentDim."Dimension Value Code");
    //                                 lrc_SalesLine.Modify();
    //                               END;
    //                             3:
    //                               BEGIN
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", lrc_DocumentDim."Dimension Value Code");
    //                                 lrc_SalesLine.Modify();
    //                               END;
    //                             4:
    //                               BEGIN
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", lrc_DocumentDim."Dimension Value Code");
    //                                 lrc_SalesLine.Modify();
    //                               END;
    //                         END;
    //                       END;
    //                     END;
    //                   UNTIL lrc_PostedDocumentDim.next() = 0;
    //                 END;
    //               END ELSE BEGIN
    //                 IF lrc_SalesClaimLine."Sales Shipment No." <> '' THEN BEGIN
    //                   lrc_PostedDocumentDim.SETRANGE("Table ID", 111);
    //                   lrc_PostedDocumentDim.SETRANGE("Document No.", lrc_SalesClaimLine."Sales Shipment No.");
    //                   lrc_PostedDocumentDim.SETRANGE("Line No.", lrc_SalesClaimLine."Sales Shipment Line No.");
    //                   //RS Kosten ausblenden, da in VK-Lieferzeile INFKORR als Kostencode eingetragen wird, wenn Frachtrg. Diff gebucht
    //                   lrc_PostedDocumentDim.SETFILTER("Dimension Code", '<>%1', 'KOSTEN');
    //                   IF lrc_PostedDocumentDim.FINDSET(FALSE, FALSE) THEN BEGIN
    //                     REPEAT
    //                       IF lrc_PostedDocumentDim."Dimension Value Code" <> '' THEN BEGIN
    //                         IF NOT lrc_DocumentDim.GET(37, lrc_SalesHeader."Document Type", lrc_SalesHeader."No.",
    //                                                    lin_LineNo, lrc_PostedDocumentDim."Dimension Code") THEN BEGIN
    //                           lrc_DocumentDim.INIT();
    //                           lrc_DocumentDim."Table ID" := 37;
    //                           lrc_DocumentDim."Document Type" := lrc_SalesHeader."Document Type";
    //                           lrc_DocumentDim."Document No." := lrc_SalesHeader."No.";
    //                           lrc_DocumentDim."Line No." := lin_LineNo;
    //                           lrc_DocumentDim."Dimension Code" := lrc_PostedDocumentDim."Dimension Code";
    //                           lrc_DocumentDim."Dimension Value Code" := lrc_PostedDocumentDim."Dimension Value Code";
    //                           lrc_DocumentDim.insert();
    //                           lrc_DimensionValue.GET(lrc_PostedDocumentDim."Dimension Code", lrc_PostedDocumentDim."Dimension Value Code");
    //                           CASE lrc_DimensionValue."Global Dimension No." OF
    //                               1:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               2:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               3:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               4:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                           END;
    //                         END;
    //                       END;
    //                     UNTIL lrc_PostedDocumentDim.next() = 0;
    //                   END;
    //                 END ELSE BEGIN
    //                   //JW noch ergänzen
    //                   ERROR('Es gibt keine gebuchte Lieferung. Bitte an NAVISION User wenden.');

    //         /*5.11.
    //                   lrc_DocumentDim.SETRANGE("Table ID", 37);
    //                   lrc_DocumentDim.SETRANGE("Document No.", lrc_SalesClaimLine."Sales Order No.");
    //                   lrc_DocumentDim.SETRANGE("Line No.", lrc_SalesClaimLine."Sales Order Line No.");
    //                   IF lrc_DocumentDim.FINDSET(FALSE, FALSE) THEN BEGIN
    //                     REPEAT
    //                       IF lrc_DocumentDim."Dimension Value Code" <> '' THEN BEGIN
    //         //{5.11.
    //                         IF NOT lrc_DocumentDim.GET(37, lrc_SalesHeader."Document Type", lrc_SalesHeader."No.",
    //                           lin_LineNo, lrc_PostedDocumentDim."Dimension Code") THEN BEGIN

    //                           lrc_DocumentDim.INIT();
    //                           lrc_DocumentDim."Table ID" := 37;
    //                           lrc_DocumentDim."Document Type" := lrc_SalesHeader."Document Type";
    //                           lrc_DocumentDim."Document No." := lrc_SalesHeader."No.";
    //                           lrc_DocumentDim."Line No." := lin_LineNo;
    //                           lrc_DocumentDim."Dimension Code" := lrc_PostedDocumentDim."Dimension Code";
    //                           lrc_DocumentDim."Dimension Value Code" := lrc_PostedDocumentDim."Dimension Value Code";
    //                           lrc_DocumentDim.insert();
    //                           lrc_DimensionValue.GET(lrc_PostedDocumentDim."Dimension Code", lrc_PostedDocumentDim."Dimension Value Code");
    //                           CASE lrc_DimensionValue."Global Dimension No." OF
    //                               1:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               2:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               3:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               4:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                           END;
    //                         END;
    //         //}
    //                       END;
    //                     UNTIL lrc_PostedDocumentDim.next() = 0;
    //                   END;
    //         5.11. */
    //                 END;
    //               END;

    //               //RS.e Dimensionen kopieren


    //               //RS ggf. zugehörige Leergutzeile in Rahmenauftrag anlegen
    //               IF lrc_SalesClaimLine."Empties Blanket Order No." <> '' THEN BEGIN
    //                  lcu_EmptiesManagement.SalesAttachEmptiesfromClaim(lrc_SalesLine."Batch Variant No.", lrc_SalesClaimLine."Sales Order No.",
    //                                                                  lrc_SalesLine."Line No.", lrc_SalesClaimLine."Claim Location Code",
    //                                                                   lrc_SalesClaimLine."Empties Item No.",
    //                                                                   lrc_SalesClaimLine."Claim Quantity",
    //                                                                   lrc_SalesLine."Document No.",lrc_SalesHeader."Sell-to Customer No.",
    //                                                                   lrc_SalesLine."Empties Blanket Order No.",
    //                                                                   lrc_SalesLine."Empties Blanket Order Line No.");
    //                 lrc_SalesLine.Modify();
    //               END;
    //               //RS.e

    //               // PAL 001 00000000.s
    //               IF lrc_SalesClaimHeader."Pallet Entry ID" <> 0 THEN BEGIN
    //                 lrc_IncomingPallet.RESET();
    //                 lrc_IncomingPallet.SETRANGE("Entry No.", lrc_SalesClaimHeader."Pallet Entry ID");
    //                 lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Sales Claim Advice");
    //                 lrc_IncomingPallet.SETRANGE("Document No.", lrc_SalesClaimLine."Document No.");
    //                 lrc_IncomingPallet.SETRANGE("Document Line No.", lrc_SalesClaimLine."Line No.");
    //                 IF lrc_IncomingPallet.FIND('-') THEN BEGIN
    //                   REPEAT
    //                     lrc_IncomingPallet2 := lrc_IncomingPallet;
    //                     lrc_IncomingPallet2."Entry No." := lrc_SalesHeader."Pallets Entry No.";
    //                     lrc_IncomingPallet2."Document Type" := lrc_IncomingPallet2."Document Type"::"Sales Credit Memo";
    //                     lrc_IncomingPallet2."Document No." := lrc_SalesHeader."No.";
    //                     lrc_IncomingPallet2."Document Line No." := lrc_SalesLine."Line No.";
    //                     lrc_IncomingPallet2.insert();
    //                   UNTIL lrc_IncomingPallet.NEXT() = 0;
    //                   IF lrc_IncomingPallet.FIND('-') THEN BEGIN
    //                     lrc_IncomingPallet.DELETEALL();
    //                   END;
    //                 END;
    //               END;
    //               // PAL 001 00000000.e

    //               lin_LineCreated := lin_LineCreated + 1;
    //               lcu_BatchManagement.BatchVariantRecalc(lrc_SalesLine."No.",lrc_SalesLine."Batch Variant No.");


    //             // -------------------------------------------------------------------------------------------------------
    //             // Gutschriftenzeilen für Wertgutschrift anlegen
    //             // -------------------------------------------------------------------------------------------------------
    //             END ELSE BEGIN

    //               CASE lrc_FruitVisionSetup."Sales Claim CrM. only Value" OF
    //               lrc_FruitVisionSetup."Sales Claim CrM. only Value"::"Qty In and Out": //bei Port nicht verwendet
    //               BEGIN

    //                 // ------------------------------------------------------------------------------------------------
    //                 // Nur wenn rein / raus buchen
    //                 // Zuerst Originalwerte Gutschreiben
    //                 // ------------------------------------------------------------------------------------------------

    //                 lrc_SalesLine.RESET();
    //                 lrc_SalesLine.INIT();
    //                 lrc_SalesLine."Document Type" := lrc_SalesHeader."Document Type";
    //                 lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
    //                 lin_LineNo := lin_LineNo + 10000;
    //                 lrc_SalesLine."Line No." := lin_LineNo;
    //                 lrc_SalesLine.insert();

    //                 lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::Item);
    //                 lrc_SalesLine.VALIDATE("No.",lrc_SalesClaimLine."No.");

    //                 IF lrc_SalesClaimLine.Type = lrc_SalesClaimLine.Type::Item THEN BEGIN
    //                   IF lrc_Item.GET(lrc_SalesClaimLine."No.") THEN BEGIN
    //                     lco_GenProdPostingGroup := lrc_Item."Gen. Prod. Posting Group";
    //                     lco_VATProdPostingGroup := lrc_Item."VAT Prod. Posting Group";
    //                   END;
    //                 END;
    //                 IF lrc_Customer.GET(lrc_SalesLine."Sell-to Customer No.") THEN BEGIN
    //                   lco_GenBusPostingGroup := lrc_Customer."Gen. Bus. Posting Group";
    //                   lco_VATBusPostingGroup := lrc_Customer."VAT Bus. Posting Group";
    //                 END;

    //                 lrc_SalesLine.VALIDATE("Location Code",lrc_SalesClaimLine."Claim Location Code");
    //                 lrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_SalesClaimLine."Unit of Measure Code");

    //                 IF lrc_SalesLine."Batch Item" = TRUE THEN BEGIN
    //                   lrc_SalesClaimLine.TESTFIELD("Master Batch No.");
    //                   lrc_SalesClaimLine.TESTFIELD("Batch No.");
    //                   lrc_SalesClaimLine.TESTFIELD("Batch Variant No.");

    //                   lrc_SalesLine."Master Batch No." := lrc_SalesClaimLine."Master Batch No.";
    //                   lrc_SalesLine."Batch No." := lrc_SalesClaimLine."Batch No.";
    //                   lrc_SalesLine.VALIDATE("Batch Variant No.", lrc_SalesClaimLine."Batch Variant No.");
    //                 END;

    //                 lrc_SalesLine.VALIDATE(Quantity,lrc_SalesClaimLine."Claim Quantity");

    //                 lrc_SalesLine."Reference Doc. No." := lrc_SalesClaimLine."Sales Shipment No.";
    //                 lrc_SalesLine."Reference Doc. Line No." := lrc_SalesClaimLine."Sales Shipment Line No.";

    //                 // Zuerst zum Originalpreis zurücknehmen
    //                 lrc_SalesLine.VALIDATE("Price Base (Sales Price)",lrc_SalesClaimLine."Price Base (Sales Price)");
    //                 lrc_SalesLine.VALIDATE("Sales Price (Price Base)",lrc_SalesClaimLine."Sales Price (Price Base)");
    //                 lrc_SalesLine.VALIDATE("Unit Price",lrc_SalesClaimLine."Sales Unit Price");

    //                 //KHH 007 KHH50297.s
    //                 //lrc_SalesLine.SETRANGE("Quality Rating",lrc_SalesClaimLine."Sales Quality Rating");
    //                 lrc_SalesLine.VALIDATE("Quality Rating",lrc_SalesClaimLine."Sales Quality Rating");
    //                 //KHH 007 KHH50297.e

    //                 lrc_SalesLine.VALIDATE("Net Weight", lrc_SalesClaimLine."Net Weight");
    //                 lrc_SalesLine.VALIDATE("Gross Weight", lrc_SalesClaimLine."Gross Weight");

    //                 lrc_SalesLine."Empties Item No." := '';
    //                 lrc_SalesLine."Empties Quantity" := 0;
    //                 lrc_SalesLine."Empties Refund Amount" := 0;
    //                 lrc_SalesLine."Empties Line No" := 0;

    //                 CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                 lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension" :
    //                         lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension" :
    //                         lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension" :
    //                         lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension" :
    //                         lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code",lrc_SalesClaimLine."Batch No.");
    //                 END;

    //                 IF (lrc_SalesClaimLine."Sales Shipment No." <> '') AND
    //                    (lrc_SalesClaimLine."Sales Shipment Line No." <> 0 ) THEN BEGIN
    //                   IF lrc_SalesShipmentLine.GET(lrc_SalesClaimLine."Sales Shipment No.",
    //                                                lrc_SalesClaimLine."Sales Shipment Line No.") THEN BEGIN
    //                     lco_GenProdPostingGroup := lrc_SalesShipmentLine."Gen. Prod. Posting Group";
    //                     lco_VATProdPostingGroup := lrc_SalesShipmentLine."VAT Prod. Posting Group";
    //                     lco_GenBusPostingGroup := lrc_SalesShipmentLine."Gen. Bus. Posting Group";
    //                     lco_VATBusPostingGroup := lrc_SalesShipmentLine."VAT Bus. Posting Group";
    //                     lbn_SalesDocumentLineFound := TRUE;
    //                   END;
    //                 END;

    //                 IF lbn_SalesDocumentLineFound = FALSE THEN BEGIN
    //                   IF (lrc_SalesClaimLine."Sales Order No." <> '') AND
    //                      (lrc_SalesClaimLine."Sales Order Line No." <> 0) THEN BEGIN
    //                   IF lrc_SalesLine2.GET(lrc_SalesLine2."Document Type"::Order,
    //                                         lrc_SalesClaimLine."Sales Order No.",
    //                                         lrc_SalesClaimLine."Sales Order Line No.") THEN BEGIN
    //                     lco_GenProdPostingGroup := lrc_SalesLine2."Gen. Prod. Posting Group";
    //                     lco_VATProdPostingGroup := lrc_SalesLine2."VAT Prod. Posting Group";
    //                     lco_GenBusPostingGroup := lrc_SalesLine2."Gen. Bus. Posting Group";
    //                     lco_VATBusPostingGroup := lrc_SalesLine2."VAT Bus. Posting Group";


    //                     lbn_SalesDocumentLineFound := TRUE;
    //                   END;
    //                   END;
    //                 END;

    //                 lrc_SalesLine.VALIDATE("Gen. Prod. Posting Group", lco_GenProdPostingGroup);
    //                 lrc_SalesLine.VALIDATE("VAT Prod. Posting Group", lco_VATProdPostingGroup);
    //                 lrc_SalesLine.VALIDATE("Gen. Bus. Posting Group", lco_GenBusPostingGroup);
    //                 lrc_SalesLine.VALIDATE("VAT Bus. Posting Group", lco_VATBusPostingGroup);

    //                 lrc_SalesLine."Reference Doc. Type" := lrc_SalesLine."Reference Doc. Type"::"Sales Shipment";
    //                 lrc_SalesLine."Reference Doc. No." := lrc_SalesClaimLine."Sales Shipment No.";
    //                 lrc_SalesLine."Reference Doc. Line No." := lrc_SalesClaimLine."Sales Shipment Line No.";
    //                 IF lrc_SalesClaimLine.Type = lrc_SalesClaimLine.Type::Item THEN
    //                   lrc_SalesLine."Reference Item No." := lrc_SalesClaimLine."No.";

    //                 lrc_SalesLine.Modify();


    //                 // PAL 001 00000000.s
    //                 IF lrc_SalesClaimHeader."Pallet Entry ID" <> 0 THEN BEGIN
    //                   lrc_IncomingPallet.RESET();
    //                   lrc_IncomingPallet.SETRANGE("Entry No.", lrc_SalesClaimHeader."Pallet Entry ID");
    //                   lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Sales Claim Advice");
    //                   lrc_IncomingPallet.SETRANGE("Document No.", lrc_SalesClaimLine."Document No.");
    //                   lrc_IncomingPallet.SETRANGE("Document Line No.", lrc_SalesClaimLine."Line No.");
    //                   IF lrc_IncomingPallet.FIND('-') THEN BEGIN
    //                     REPEAT
    //                       lrc_IncomingPallet2 := lrc_IncomingPallet;
    //                       lrc_IncomingPallet2."Entry No." := lrc_SalesHeader."Pallets Entry No.";
    //                       lrc_IncomingPallet2."Document Type" := lrc_IncomingPallet2."Document Type"::"Sales Credit Memo";
    //                       lrc_IncomingPallet2."Document No." := lrc_SalesHeader."No.";
    //                       lrc_IncomingPallet2."Document Line No." := lrc_SalesLine."Line No.";
    //                       lrc_IncomingPallet2.insert();
    //                     UNTIL lrc_IncomingPallet.NEXT() = 0;
    //                     IF lrc_IncomingPallet.FIND('-') THEN BEGIN
    //                       lrc_IncomingPallet.DELETEALL();
    //                     END;
    //                   END;
    //                 END;
    //                 // PAL 001 00000000.e

    //                 lin_LineCreated := lin_LineCreated + 1;
    //                 lcu_BatchManagement.BatchVariantRecalc(lrc_SalesLine."No.",lrc_SalesLine."Batch Variant No.");


    //                 // -------------------------------------------------------------------------------------------
    //                 // Den korrekten Betrag wieder in Rechnung stellen
    //                 // -------------------------------------------------------------------------------------------

    //                 lrc_SalesLine.RESET();
    //                 lrc_SalesLine.INIT();
    //                 lrc_SalesLine."Document Type" := lrc_SalesHeader."Document Type";
    //                 lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
    //                 lin_LineNo := lin_LineNo + 10000;
    //                 lrc_SalesLine."Line No." := lin_LineNo;
    //                 lrc_SalesLine.insert();

    //                 lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::Item);
    //                 lrc_SalesLine.VALIDATE("No.",lrc_SalesClaimLine."No.");

    //                 IF lrc_SalesClaimLine.Type = lrc_SalesClaimLine.Type::Item THEN BEGIN
    //                   lrc_Item.GET(lrc_SalesClaimLine."No.");
    //                   lco_GenProdPostingGroup := lrc_Item."Gen. Prod. Posting Group";
    //                   lco_VATProdPostingGroup := lrc_Item."VAT Prod. Posting Group";
    //                 END;
    //                 lrc_Customer.GET(lrc_SalesHeader."Sell-to Customer No.");
    //                 lco_GenBusPostingGroup := lrc_Customer."Gen. Bus. Posting Group";
    //                 lco_VATBusPostingGroup := lrc_Customer."VAT Bus. Posting Group";

    //                 lrc_SalesLine.VALIDATE("Location Code",lrc_SalesClaimLine."Claim Location Code");
    //                 lrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_SalesClaimLine."Unit of Measure Code");

    //                 IF lrc_SalesLine."Batch Item" = TRUE THEN BEGIN
    //                   lrc_SalesClaimLine.TESTFIELD("Master Batch No.");
    //                   lrc_SalesClaimLine.TESTFIELD("Batch No.");
    //                   lrc_SalesClaimLine.TESTFIELD("Batch Variant No.");

    //                   lrc_SalesLine."Master Batch No." := lrc_SalesClaimLine."Master Batch No.";
    //                   lrc_SalesLine."Batch No." := lrc_SalesClaimLine."Batch No.";
    //                   lrc_SalesLine.VALIDATE("Batch Variant No.", lrc_SalesClaimLine."Batch Variant No.");
    //                 END;

    //                 lrc_SalesLine.VALIDATE(Quantity,(lrc_SalesClaimLine."Claim Quantity" * -1));

    //                 lrc_SalesLine."Reference Doc. No." := lrc_SalesClaimLine."Sales Shipment No.";
    //                 lrc_SalesLine."Reference Doc. Line No." := lrc_SalesClaimLine."Sales Shipment Line No.";

    //                 IF (lrc_SalesClaimLine."Claim Sales Price (Price Base)" = 0) AND
    //                    (lrc_SalesClaimLine."Claim Sales Unit Price" <> 0) THEN BEGIN
    //                   lrc_SalesLine.VALIDATE("Price Base (Sales Price)", '');
    //                   lrc_SalesLine.VALIDATE("Sales Price (Price Base)",lrc_SalesClaimLine."Claim Sales Unit Price");
    //                   lrc_SalesLine.VALIDATE("Unit Price",lrc_SalesClaimLine."Claim Sales Unit Price");
    //                 END ELSE BEGIN
    //                   lrc_SalesLine.VALIDATE("Price Base (Sales Price)",lrc_SalesClaimLine."Price Base (Sales Price)");
    //                   lrc_SalesLine.VALIDATE("Sales Price (Price Base)",lrc_SalesClaimLine."Claim Sales Price (Price Base)");
    //                   lrc_SalesLine.VALIDATE("Unit Price",lrc_SalesClaimLine."Claim Sales Unit Price");
    //                 END;

    //                 //KHH 007 KHH50297.s
    //                 //lrc_SalesLine.SETRANGE("Quality Rating",lrc_SalesClaimLine."Sales Quality Rating");
    //                 lrc_SalesLine.VALIDATE("Quality Rating",lrc_SalesClaimLine."Claim Quality Rating");
    //                 //KHH 007 KHH50297.e

    //                 lrc_SalesLine.VALIDATE("Net Weight", lrc_SalesClaimLine."Net Weight");
    //                 lrc_SalesLine.VALIDATE("Gross Weight", lrc_SalesClaimLine."Gross Weight");

    //                 lrc_SalesLine."Empties Item No." := '';
    //                 lrc_SalesLine."Empties Quantity" := 0;
    //                 lrc_SalesLine."Empties Refund Amount" := 0;
    //                 lrc_SalesLine."Empties Line No" := 0;

    //                 CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                   lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension" :
    //                           lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code",lrc_SalesClaimLine."Batch No.");
    //                   lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension" :
    //                           lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code",lrc_SalesClaimLine."Batch No.");
    //                   lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension" :
    //                           lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code",lrc_SalesClaimLine."Batch No.");
    //                   lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension" :
    //                           lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code",lrc_SalesClaimLine."Batch No.");
    //                 END;

    //                 IF (lrc_SalesClaimLine."Sales Shipment No." <> '') AND
    //                    (lrc_SalesClaimLine."Sales Shipment Line No." <> 0) THEN BEGIN
    //                   IF lrc_SalesShipmentLine.GET(lrc_SalesClaimLine."Sales Shipment No.",
    //                                                lrc_SalesClaimLine."Sales Shipment Line No.") THEN BEGIN
    //                     lco_GenProdPostingGroup := lrc_SalesShipmentLine."Gen. Prod. Posting Group";
    //                     lco_VATProdPostingGroup := lrc_SalesShipmentLine."VAT Prod. Posting Group";
    //                     lco_GenBusPostingGroup := lrc_SalesShipmentLine."Gen. Bus. Posting Group";
    //                     lco_VATBusPostingGroup := lrc_SalesShipmentLine."VAT Bus. Posting Group";
    //                     lbn_SalesDocumentLineFound := TRUE;
    //                   END;
    //                 END;

    //                 IF lbn_SalesDocumentLineFound = FALSE THEN BEGIN
    //                   IF (lrc_SalesClaimLine."Sales Order No." <> '') AND
    //                      (lrc_SalesClaimLine."Sales Order Line No." <> 0) THEN BEGIN
    //                     IF lrc_SalesLine2.GET(lrc_SalesLine2."Document Type"::Order,
    //                                           lrc_SalesClaimLine."Sales Order No.",
    //                                           lrc_SalesClaimLine."Sales Order Line No.") THEN BEGIN
    //                       lco_GenProdPostingGroup := lrc_SalesLine2."Gen. Prod. Posting Group";
    //                       lco_VATProdPostingGroup := lrc_SalesLine2."VAT Prod. Posting Group";
    //                       lco_GenBusPostingGroup := lrc_SalesLine2."Gen. Bus. Posting Group";
    //                       lco_VATBusPostingGroup := lrc_SalesLine2."VAT Bus. Posting Group";
    //                       lbn_SalesDocumentLineFound := TRUE;
    //                     END;
    //                   END;
    //                 END;

    //                 lrc_SalesLine.VALIDATE("Gen. Prod. Posting Group", lco_GenProdPostingGroup);
    //                 lrc_SalesLine.VALIDATE("VAT Prod. Posting Group", lco_VATProdPostingGroup);
    //                 lrc_SalesLine.VALIDATE("Gen. Bus. Posting Group", lco_GenBusPostingGroup);
    //                 lrc_SalesLine.VALIDATE("VAT Bus. Posting Group", lco_VATBusPostingGroup);

    //                 // VKR 011 IFW40194.s
    //                 lrc_SalesLine."Reference Doc. Type" := lrc_SalesLine."Reference Doc. Type"::"Sales Shipment";
    //                 lrc_SalesLine."Reference Doc. No." := lrc_SalesClaimLine."Sales Shipment No.";
    //                 lrc_SalesLine."Reference Doc. Line No." := lrc_SalesClaimLine."Sales Shipment Line No.";
    //                 IF lrc_SalesClaimLine.Type = lrc_SalesClaimLine.Type::Item THEN BEGIN
    //                   lrc_SalesLine."Reference Item No." := lrc_SalesClaimLine."No.";
    //                 END;
    //                 // VKR 011 IFW40194.e

    //                 lrc_SalesLine.Modify();

    //                 // PAL 001 00000000.s
    //                 IF lrc_SalesClaimHeader."Pallet Entry ID" <> 0 THEN BEGIN
    //                   lrc_IncomingPallet.RESET();
    //                   lrc_IncomingPallet.SETRANGE("Entry No.", lrc_SalesClaimHeader."Pallet Entry ID");
    //                   lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Sales Claim Advice");
    //                   lrc_IncomingPallet.SETRANGE("Document No.", lrc_SalesClaimLine."Document No.");
    //                   lrc_IncomingPallet.SETRANGE("Document Line No.", lrc_SalesClaimLine."Line No.");
    //                   IF lrc_IncomingPallet.FIND('-') THEN BEGIN
    //                     REPEAT
    //                       lrc_IncomingPallet2 := lrc_IncomingPallet;
    //                       lrc_IncomingPallet2."Entry No." := lrc_SalesHeader."Pallets Entry No.";
    //                       lrc_IncomingPallet2."Document Type" := lrc_IncomingPallet2."Document Type"::"Sales Credit Memo";
    //                       lrc_IncomingPallet2."Document No." := lrc_SalesHeader."No.";
    //                       lrc_IncomingPallet2."Document Line No." := lrc_SalesLine."Line No.";
    //                       lrc_IncomingPallet2.insert();
    //                     UNTIL lrc_IncomingPallet.NEXT() = 0;
    //                     IF lrc_IncomingPallet.FIND('-') THEN BEGIN
    //                       lrc_IncomingPallet.DELETEALL();
    //                     END;
    //                   END;
    //                 END;
    //                 // PAL 001 00000000.e

    //                 lin_LineCreated := lin_LineCreated + 1;
    //                 lcu_BatchManagement.BatchVariantRecalc(lrc_SalesLine."No.",lrc_SalesLine."Batch Variant No.");

    //                 // ------------------------------------------------------------------------------------------------
    //                 // ------------------------------------------------------------------------------------------------
    //               END;

    //               lrc_FruitVisionSetup."Sales Claim CrM. only Value"::"Item Charge": //Einstellung Port
    //               BEGIN

    //                 // PAL 001 00000000.s
    //                 IF lrc_SalesClaimHeader."Pallet Entry ID" <> 0 THEN BEGIN
    //                   lrc_IncomingPallet.RESET();
    //                   lrc_IncomingPallet.SETRANGE("Entry No.", lrc_SalesClaimHeader."Pallet Entry ID");
    //                   lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Sales Claim Advice");
    //                   lrc_IncomingPallet.SETRANGE("Document No.", lrc_SalesClaimLine."Document No.");
    //                   lrc_IncomingPallet.SETRANGE("Document Line No.", lrc_SalesClaimLine."Line No.");
    //                   IF lrc_IncomingPallet.FIND('-') THEN BEGIN
    //                     ERROR(AGILES_LT_TEXT003, lrc_IncomingPallet.COUNT());
    //                   END;
    //                 END;
    //                 // PAL 001 00000000.e

    //                 lrc_SalesLine.RESET();
    //                 lrc_SalesLine.INIT();
    //                 lrc_SalesLine."Document Type" := lrc_SalesHeader."Document Type";
    //                 lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
    //                 lin_LineNo := lin_LineNo + 10000;
    //                 lrc_SalesLine."Line No." := lin_LineNo;
    //                 lrc_SalesLine.insert();
    //                 lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::"Charge (Item)");

    //                 lco_GenProdPostingGroup := '';
    //                 lco_VATProdPostingGroup := '';
    //                 lco_GenBusPostingGroup := '';
    //                 lco_VATBusPostingGroup := '';

    //                 lrc_Customer.GET(lrc_SalesHeader."Sell-to Customer No.");
    //                 lco_GenBusPostingGroup := lrc_Customer."Gen. Bus. Posting Group";
    //                 lco_VATBusPostingGroup := lrc_Customer."VAT Bus. Posting Group";

    //                 lco_SalesClaimCrMemoDefItemCha := '';
    //                 IF lrc_SalesClaimLine.Type = lrc_SalesClaimLine.Type::Item THEN BEGIN
    //                   IF lrc_Item.GET(lrc_SalesClaimLine."No.") THEN BEGIN

    //                     lco_GenProdPostingGroup := lrc_Item."Gen. Prod. Posting Group";
    //                     lco_VATProdPostingGroup := lrc_Item."VAT Prod. Posting Group";

    //                     IF (lrc_SalesClaimLine."Sales Shipment No." <> '') AND
    //                        (lrc_SalesClaimLine."Sales Shipment Line No." <> 0) THEN BEGIN
    //                       IF lrc_SalesShipmentLine.GET(lrc_SalesClaimLine."Sales Shipment No.",
    //                                                    lrc_SalesClaimLine."Sales Shipment Line No.") THEN BEGIN
    //                         lco_GenProdPostingGroup := lrc_SalesShipmentLine."Gen. Prod. Posting Group";
    //                         lco_VATProdPostingGroup := lrc_SalesShipmentLine."VAT Prod. Posting Group";
    //                         lco_GenBusPostingGroup := lrc_SalesShipmentLine."Gen. Bus. Posting Group";
    //                         lco_VATBusPostingGroup := lrc_SalesShipmentLine."VAT Bus. Posting Group";
    //                         // LoadBusPostGroupFromShptLine(lrc_SalesLine, lrc_SalesShipmentLine );


    //                         lbn_SalesDocumentLineFound := TRUE;
    //                       END;
    //                     END;

    //                     IF lbn_SalesDocumentLineFound = FALSE THEN BEGIN
    //                       IF (lrc_SalesClaimLine."Sales Order No." <> '') AND
    //                          (lrc_SalesClaimLine."Sales Order Line No." <> 0 ) THEN BEGIN
    //                         IF lrc_SalesLine2.GET(lrc_SalesLine2."Document Type"::Order,
    //                                                lrc_SalesClaimLine."Sales Order No.",
    //                                                lrc_SalesClaimLine."Sales Order Line No.") THEN BEGIN
    //                           lco_GenProdPostingGroup := lrc_SalesLine2."Gen. Prod. Posting Group";
    //                           lco_VATProdPostingGroup := lrc_SalesLine2."VAT Prod. Posting Group";

    //                           // FV4 003 GFP40047.s
    //                           lco_GenBusPostingGroup := lrc_SalesLine2."Gen. Bus. Posting Group";
    //                           lco_VATBusPostingGroup := lrc_SalesLine2."VAT Bus. Posting Group";
    //                           // LoadBusPostGroupFromSalesLine(lrc_SalesLine, lrc_SalesLine2 );
    //                           // FV4 003 GFP40047.e


    //                           lbn_SalesDocumentLineFound := TRUE;
    //                         END;
    //                       END;
    //                     END;

    //                     lrc_ItemCharge.RESET();
    //                     lrc_ItemCharge.SETRANGE("Gen. Prod. Posting Group", lco_GenProdPostingGroup);
    //                     lrc_ItemCharge.SETRANGE("VAT Prod. Posting Group", lco_VATProdPostingGroup);
    //                     lrc_ItemCharge.SETRANGE("Not Relevant for Sales Claim", FALSE);
    //                     IF lrc_Item."Batch Item" = TRUE THEN BEGIN
    //                       lrc_ItemCharge.SETRANGE("Batch Item Charge", TRUE);
    //                     END ELSE BEGIN
    //                       lrc_ItemCharge.SETRANGE("Batch Item Charge", FALSE);
    //                     END;
    //                     lrc_ItemCharge.SETFILTER("No.", '<>%1', '');
    //                     IF lrc_ItemCharge.FINDFIRST() THEN BEGIN
    //                       lco_SalesClaimCrMemoDefItemCha := lrc_ItemCharge."No.";
    //                     END;
    //                   END;
    //                 END;

    //                 IF (lrc_SalesClaimLine."Sales Shipment No." <> '') AND
    //                    (lrc_SalesClaimLine."Sales Shipment Line No." <> 0 ) THEN BEGIN
    //                   IF lrc_SalesShipmentLine.GET(lrc_SalesClaimLine."Sales Shipment No.",
    //                                                 lrc_SalesClaimLine."Sales Shipment Line No.") THEN BEGIN
    //                     lco_GenProdPostingGroup := lrc_SalesShipmentLine."Gen. Prod. Posting Group";
    //                     lco_VATProdPostingGroup := lrc_SalesShipmentLine."VAT Prod. Posting Group";
    //                     // FV4 003 GFP40047.s
    //                     // LoadBusPostGroupFromShptLine(lrc_SalesLine, lrc_SalesShipmentLine );
    //                     lco_VATBusPostingGroup := lrc_SalesShipmentLine."VAT Bus. Posting Group";
    //                     lco_GenBusPostingGroup := lrc_SalesShipmentLine."Gen. Bus. Posting Group";
    //                     // FV4 003 GFP40047.e
    //                     lbn_SalesDocumentLineFound := TRUE;
    //                   END;
    //                 END;

    //                 IF lbn_SalesDocumentLineFound = FALSE THEN BEGIN
    //                   IF (lrc_SalesClaimLine."Sales Order No." <> '') AND
    //                      (lrc_SalesClaimLine."Sales Order Line No." <> 0 ) THEN BEGIN
    //                     IF lrc_SalesLine2.GET(lrc_SalesLine2."Document Type"::Order,
    //                                            lrc_SalesClaimLine."Sales Order No.",
    //                                            lrc_SalesClaimLine."Sales Order Line No.") THEN BEGIN
    //                       lco_GenProdPostingGroup := lrc_SalesLine2."Gen. Prod. Posting Group";
    //                       lco_VATProdPostingGroup := lrc_SalesLine2."VAT Prod. Posting Group";
    //                       // FV4 003 GFP40047.s
    //                       lco_VATBusPostingGroup := lrc_SalesLine2."VAT Bus. Posting Group";
    //                       lco_GenBusPostingGroup := lrc_SalesLine2."Gen. Bus. Posting Group";
    //                       // LoadBusPostGroupFromSalesLine(lrc_SalesLine, lrc_SalesLine2 );
    //                       // FV4 003 GFP40047.e
    //                       lbn_SalesDocumentLineFound := TRUE;
    //                     END;
    //                   END;
    //                 END;

    //                 // Prüfung der FruitVision Einrichtung
    //                 IF lco_SalesClaimCrMemoDefItemCha = '' THEN BEGIN
    //                   lrc_FruitVisionSetup.TESTFIELD("Sales Claim CrM. Def. ItemChar");
    //                   lco_SalesClaimCrMemoDefItemCha := lrc_FruitVisionSetup."Sales Claim CrM. Def. ItemChar";
    //                 END;

    //                 // FV4 006 00000000.s
    //                 IF lco_SalesClaimCrMemoDefItemCha = '' THEN BEGIN
    //                   // Kein Zu-/Abschlag definiert
    //                   ERROR(AGILES_LT_TEXT002);
    //                 // FV4 006 00000000.e
    //                 END ELSE BEGIN
    //                   // FV4 007 00000000.s
    //                   lrc_ItemCharge.GET(lco_SalesClaimCrMemoDefItemCha);
    //                   lrc_ItemCharge.TESTFIELD("Gen. Prod. Posting Group");
    //                   lco_GenProdPostingGroup := lrc_ItemCharge."Gen. Prod. Posting Group";
    //                   lrc_ItemCharge.TESTFIELD("VAT Prod. Posting Group");
    //                   lco_VATProdPostingGroup := lrc_ItemCharge."VAT Prod. Posting Group";
    //                   // FV4 007 00000000.e
    //                 END;

    //                 lrc_SalesLine.VALIDATE("No.", lco_SalesClaimCrMemoDefItemCha );
    //                 lrc_SalesLine.VALIDATE("Location Code",lrc_SalesClaimLine."Claim Location Code");
    //                 lrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_SalesClaimLine."Unit of Measure Code");
    //                 lrc_SalesLine.VALIDATE(Quantity,lrc_SalesClaimLine."Claim Quantity");

    //                 //FV4 003 FV400103.s
    //                 BEGIN
    //                   lrc_SalesLine.VALIDATE("Price Base (Sales Price)", '');
    //                   lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesClaimLine."Claim Sales Unit Price");
    //                   lrc_SalesLine.VALIDATE("Unit Price",lrc_SalesClaimLine."Claim Sales Unit Price");
    //                 END;

    //                 lrc_SalesLine."Reference Doc. No." := lrc_SalesClaimLine."Sales Shipment No.";
    //                 lrc_SalesLine."Reference Doc. Line No." := lrc_SalesClaimLine."Sales Shipment Line No.";
    //                 lrc_SalesLine."Reference Item No." := lrc_SalesClaimLine."No.";

    //                 lrc_SalesLine.VALIDATE( Description, lrc_SalesClaimLine.Description );
    //                 lrc_SalesLine.VALIDATE("Description 2", lrc_SalesClaimLine."Description 2");

    //                 lrc_SalesLine."Empties Item No." := '';
    //                 lrc_SalesLine."Empties Quantity" := 0;
    //                 lrc_SalesLine."Empties Refund Amount" := 0;
    //                 lrc_SalesLine."Empties Line No" := 0;

    //                 CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                 lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension" :
    //                   lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension" :
    //                   lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension" :
    //                   lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code",lrc_SalesClaimLine."Batch No.");
    //                 lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension" :
    //                   lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code",lrc_SalesClaimLine."Batch No.");
    //                 END;

    //                 lrc_SalesLine.VALIDATE("Gen. Prod. Posting Group", lco_GenProdPostingGroup );
    //                 lrc_SalesLine.VALIDATE("VAT Prod. Posting Group", lco_VATProdPostingGroup );
    //                 // FV4 003 GFP40047.s
    //                 lrc_SalesLine.VALIDATE("VAT Bus. Posting Group", lco_VATBusPostingGroup );
    //                 lrc_SalesLine.VALIDATE("Gen. Bus. Posting Group", lco_GenBusPostingGroup );
    //                 // FV4 003 GFP40047.e

    //                 // VKR 011 IFW40194.s
    //                 lrc_SalesLine."Reference Doc. Type" := lrc_SalesLine."Reference Doc. Type"::"Sales Shipment";
    //                 lrc_SalesLine."Reference Doc. No." := lrc_SalesClaimLine."Sales Shipment No.";
    //                 lrc_SalesLine."Reference Doc. Line No." := lrc_SalesClaimLine."Sales Shipment Line No.";
    //                 IF lrc_SalesClaimLine.Type = lrc_SalesClaimLine.Type::Item THEN BEGIN
    //                   lrc_SalesLine."Reference Item No." := lrc_SalesClaimLine."No.";
    //                 END;
    //                 // VKR 011 IFW40194.e

    //                 lin_LineCreated := lin_LineCreated + 1;

    //                 // -----------------------------------------------------------
    //                 // Zu-/Abschlagszeile anlegen
    //                 // -----------------------------------------------------------
    //                 lrc_ItemChargeAssignSales.RESET();
    //                 lrc_ItemChargeAssignSales.INIT();
    //                 lrc_ItemChargeAssignSales."Document Type" := lrc_SalesLine."Document Type";
    //                 lrc_ItemChargeAssignSales."Document No." := lrc_SalesLine."Document No.";
    //                 lrc_ItemChargeAssignSales."Document Line No." := lrc_SalesLine."Line No.";
    //                 lrc_ItemChargeAssignSales."Line No." := 10000;

    //                 lrc_ItemChargeAssignSales.VALIDATE("Item Charge No.",lrc_SalesLine."No.");
    //                 lrc_ItemChargeAssignSales.VALIDATE("Item No.", lrc_SalesLine."Reference Item No.");

    //                 lrc_ItemChargeAssignSales.VALIDATE( Description, lrc_SalesLine.Description );

    //                 lrc_ItemChargeAssignSales.VALIDATE("Applies-to Doc. Type",  lrc_ItemChargeAssignSales."Applies-to Doc. Type"::Shipment );
    //                 lrc_ItemChargeAssignSales.VALIDATE("Applies-to Doc. No.", lrc_SalesClaimLine."Sales Shipment No.");
    //                 lrc_ItemChargeAssignSales.VALIDATE("Applies-to Doc. Line No.", lrc_SalesClaimLine."Sales Shipment Line No.");

    //                 // lrc_ItemChargeAssignSales."Applies-to Doc. Line Amount"
    //                 lrc_ItemChargeAssignSales."Master Batch No." := lrc_SalesClaimLine."Master Batch No.";
    //                 lrc_ItemChargeAssignSales."Batch No." := lrc_SalesClaimLine."Batch No.";
    //                 lrc_ItemChargeAssignSales."Batch Variant No." := lrc_SalesClaimLine."Batch Variant No.";

    //                 lrc_ItemChargeAssignSales.VALIDATE("Qty. to Assign",lrc_SalesLine.Quantity);

    //                 lrc_ItemChargeAssignSales.INSERT(TRUE);

    //                 //ADB 001 ADÜ40063.s
    //                   lrc_SalesLine."Item Category Code" :=  lrc_SalesClaimLine."Item Category Code";
    //                   lrc_SalesLine."Product Group Code" :=  lrc_SalesClaimLine."Product Group Code";
    //                 //ADB 001 ADÜ40063.e
    //                 //FV4 003 FV400103.s
    //                 lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesClaimLine."Claim Sales Unit Price");
    //                 //FV4 003 FV400103.e


    //                 lrc_SalesLine."Master Batch No." := lrc_SalesClaimLine."Master Batch No.";
    //                 lrc_SalesLine."Batch No." := lrc_SalesClaimLine."Batch No.";
    //                 lrc_SalesLine."Batch Variant No." := lrc_SalesClaimLine."Batch Variant No.";

    //                 lrc_SalesLine.Modify();

    //                 //RS Dimensionen kopieren
    //                 IF lrc_SalesClaimLine."Sales Invoice No." <> '' THEN BEGIN
    //                   lrc_PostedDocumentDim.SETRANGE("Table ID", 113);
    //                   lrc_PostedDocumentDim.SETRANGE("Document No.", lrc_SalesClaimLine."Sales Invoice No.");
    //                   lrc_PostedDocumentDim.SETRANGE("Line No.", lrc_SalesClaimLine."Sales Invoice Line No.");
    //                   IF lrc_PostedDocumentDim.FINDSET(FALSE, FALSE)THEN BEGIN
    //                     REPEAT
    //                       IF lrc_PostedDocumentDim."Dimension Value Code" <> '' THEN BEGIN
    //                         IF NOT lrc_DocumentDim.GET(37, lrc_SalesHeader."Document Type", lrc_SalesHeader."No.",
    //                                                    lin_LineNo, lrc_PostedDocumentDim."Dimension Code") THEN BEGIN
    //                           lrc_DocumentDim.INIT();
    //                           lrc_DocumentDim."Table ID" := 37;
    //                           lrc_DocumentDim."Document Type" := lrc_SalesHeader."Document Type";
    //                           lrc_DocumentDim."Document No." := lrc_SalesHeader."No.";
    //                           lrc_DocumentDim."Line No." := lin_LineNo;
    //                           lrc_DocumentDim."Dimension Code" := lrc_PostedDocumentDim."Dimension Code";
    //                           lrc_DocumentDim."Dimension Value Code" := lrc_PostedDocumentDim."Dimension Value Code";
    //                           lrc_DocumentDim.insert();
    //                           lrc_DimensionValue.GET(lrc_PostedDocumentDim."Dimension Code", lrc_PostedDocumentDim."Dimension Value Code");
    //                           CASE lrc_DimensionValue."Global Dimension No." OF
    //                               1:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               2:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               3:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                               4:
    //                                 BEGIN
    //                                   lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", lrc_DocumentDim."Dimension Value Code");
    //                                   lrc_SalesLine.Modify();
    //                                 END;
    //                           END;
    //                         END;
    //                       END;
    //                     UNTIL lrc_PostedDocumentDim.next() = 0;
    //                   END;
    //                 END ELSE BEGIN
    //                   IF lrc_SalesClaimLine."Sales Shipment No." <> '' THEN BEGIN
    //                     lrc_PostedDocumentDim.SETRANGE("Table ID", 111);
    //                     lrc_PostedDocumentDim.SETRANGE("Document No.", lrc_SalesClaimLine."Sales Shipment No.");
    //                     lrc_PostedDocumentDim.SETRANGE("Line No.", lrc_SalesClaimLine."Sales Shipment Line No.");
    //                     //RS Kosten ausblenden, da in VK-Lieferzeile INFKORR als Kostencode eingetragen wird, wenn Frachtrg. Diff gebucht
    //                     lrc_PostedDocumentDim.SETFILTER("Dimension Code", '<>%1', 'KOSTEN');

    //                     IF lrc_PostedDocumentDim.FINDSET(FALSE, FALSE)THEN BEGIN
    //                       REPEAT
    //                         IF lrc_PostedDocumentDim."Dimension Value Code" <> '' THEN BEGIN
    //                           IF NOT lrc_DocumentDim.GET(37, lrc_SalesHeader."Document Type", lrc_SalesHeader."No.",
    //                                                      lin_LineNo, lrc_PostedDocumentDim."Dimension Code") THEN BEGIN
    //                             lrc_DocumentDim.INIT();
    //                             lrc_DocumentDim."Table ID" := 37;
    //                             lrc_DocumentDim."Document Type" := lrc_SalesHeader."Document Type";
    //                             lrc_DocumentDim."Document No." := lrc_SalesHeader."No.";
    //                             lrc_DocumentDim."Line No." := lin_LineNo;
    //                             lrc_DocumentDim."Dimension Code" := lrc_PostedDocumentDim."Dimension Code";
    //                             lrc_DocumentDim."Dimension Value Code" := lrc_PostedDocumentDim."Dimension Value Code";
    //                             lrc_DocumentDim.insert();
    //                             lrc_DimensionValue.GET(lrc_PostedDocumentDim."Dimension Code", lrc_PostedDocumentDim."Dimension Value Code");
    //                             CASE lrc_DimensionValue."Global Dimension No." OF
    //                                 1:
    //                                   BEGIN
    //                                     lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", lrc_DocumentDim."Dimension Value Code");
    //                                     lrc_SalesLine.Modify();
    //                                   END;
    //                                 2:
    //                                   BEGIN
    //                                     lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", lrc_DocumentDim."Dimension Value Code");
    //                                     lrc_SalesLine.Modify();
    //                                   END;
    //                                 3:
    //                                   BEGIN
    //                                     lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", lrc_DocumentDim."Dimension Value Code");
    //                                     lrc_SalesLine.Modify();
    //                                   END;
    //                                 4:
    //                                   BEGIN
    //                                     lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", lrc_DocumentDim."Dimension Value Code");
    //                                     lrc_SalesLine.Modify();
    //                                   END;
    //                             END;
    //                           END;
    //                         END;
    //                       UNTIL lrc_PostedDocumentDim.next() = 0;
    //                     END;
    //                   END ELSE BEGIN
    //                     lrc_DocumentDim.SETRANGE("Table ID", 37);
    //                     lrc_DocumentDim.SETRANGE("Document No.", lrc_SalesClaimLine."Sales Order No.");
    //                     lrc_DocumentDim.SETRANGE("Line No.", lrc_SalesClaimLine."Sales Order Line No.");
    //                     IF lrc_DocumentDim.FINDSET(FALSE, FALSE) THEN BEGIN
    //                       REPEAT
    //                         IF lrc_DocumentDim."Dimension Value Code" <> '' THEN BEGIN
    //                           IF NOT lrc_DocumentDim.GET(37, lrc_SalesHeader."Document Type", lrc_SalesHeader."No.",
    //                                                      lin_LineNo, lrc_PostedDocumentDim."Dimension Code") THEN BEGIN

    //                             lrc_DocumentDim.INIT();
    //                             lrc_DocumentDim."Table ID" := 37;
    //                             lrc_DocumentDim."Document Type" := lrc_SalesHeader."Document Type";
    //                             lrc_DocumentDim."Document No." := lrc_SalesHeader."No.";
    //                             lrc_DocumentDim."Line No." := lin_LineNo;
    //                             lrc_DocumentDim."Dimension Code" := lrc_PostedDocumentDim."Dimension Code";
    //                             lrc_DocumentDim."Dimension Value Code" := lrc_PostedDocumentDim."Dimension Value Code";
    //                             lrc_DocumentDim.insert();
    //                             lrc_DimensionValue.GET(lrc_PostedDocumentDim."Dimension Code", lrc_PostedDocumentDim."Dimension Value Code");
    //                             CASE lrc_DimensionValue."Global Dimension No." OF
    //                                 1:
    //                                   BEGIN
    //                                     lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", lrc_DocumentDim."Dimension Value Code");
    //                                     lrc_SalesLine.Modify();
    //                                   END;
    //                                 2:
    //                                   BEGIN
    //                                     lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", lrc_DocumentDim."Dimension Value Code");
    //                                     lrc_SalesLine.Modify();
    //                                   END;
    //                                 3:
    //                                   BEGIN
    //                                     lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", lrc_DocumentDim."Dimension Value Code");
    //                                     lrc_SalesLine.Modify();
    //                                   END;
    //                                 4:
    //                                   BEGIN
    //                                     lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", lrc_DocumentDim."Dimension Value Code");
    //                                     lrc_SalesLine.Modify();
    //                                   END;
    //                             END;
    //                           END;
    //                         END;
    //                       UNTIL lrc_PostedDocumentDim.next() = 0;
    //                     END;
    //                   END;
    //                 END;

    //                 //RS.e Dimensionen kopieren


    //                 //RS ggf. zugehörige Leergutzeile in Rahmenauftrag anlegen
    //                 IF lrc_SalesClaimLine."Empties Blanket Order No." <> '' THEN BEGIN
    //                   lcu_EmptiesManagement.SalesAttachEmptiesfromClaim(lrc_SalesLine."Batch Variant No.", lrc_SalesClaimLine."Sales Order No.",
    //                                                                     lrc_SalesLine."Line No.", lrc_SalesClaimLine."Claim Location Code",
    //                                                                     lrc_SalesClaimLine."Empties Item No.",
    //                                                                     lrc_SalesClaimLine."Claim Quantity",
    //                                                                     lrc_SalesLine."Document No.",lrc_SalesHeader."Sell-to Customer No.",
    //                                                                     lrc_SalesLine."Empties Blanket Order No.",
    //                                                                     lrc_SalesLine."Empties Blanket Order Line No.");
    //                   lrc_SalesLine.Modify();
    //                 END;
    //               //RS.e
    //               END;
    //               END;

    //             END;

    //             //KHH 010 KHH50279.s
    //             lrc_SalesClaimLine."Transfered to Cr.M./Return O." := TRUE;
    //             lrc_SalesClaimLine."Cr.M./Return O. No." := lrc_SalesHeader."No.";
    //             lrc_SalesClaimLine."Cr.M./Return O. Line No." := lrc_SalesLine."Line No.";
    //             lrc_SalesClaimLine.Modify();
    //             //KHH 010 KHH50279.e

    //           UNTIL lrc_SalesClaimLine.next() = 0;

    //         /*--------------------------------------------------------
    //           //FV4 000 FV400100.s
    //           //Position und Artikelnr. des Zu-/Abschlags in die Rabatte übernehmen
    //           // Beleg berechnen berechnen
    //           IF lrc_FruitVisionSetup."Sales Claim CrM. only Value" =
    //              lrc_FruitVisionSetup."Sales Claim CrM. only Value"::"Item Charge" THEN BEGIN
    //             lcu_Sales.CalcSalesOrder(lrc_SalesHeader);
    //             lrc_SalesLineChargeItem.RESET();
    //             lrc_SalesLineChargeItem.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //             lrc_SalesLineChargeItem.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //             lrc_SalesLineChargeItem.SETRANGE(Type,lrc_SalesLineChargeItem.Type::"Charge (Item)");
    //             IF lrc_SalesLineChargeItem.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_SalesDiscountLine.RESET();
    //                 lrc_SalesDiscountLine.SETRANGE("Document Type",lrc_SalesLineChargeItem."Document Type");
    //                 lrc_SalesDiscountLine.SETRANGE("Document No.",lrc_SalesLineChargeItem."Document No.");
    //                 lrc_SalesDiscountLine.SETRANGE("Document Line No.",lrc_SalesLineChargeItem."Line No.");

    //                 IF lrc_SalesDiscountLine.FIND('-') THEN BEGIN
    //                   REPEAT
    //                     CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                     lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension" :
    //                       lrc_SalesDiscountLine.VALIDATE("Batch No.",lrc_SalesLineChargeItem."Shortcut Dimension 1 Code");
    //                     lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension" :
    //                       lrc_SalesDiscountLine.VALIDATE("Batch No.",lrc_SalesLineChargeItem."Shortcut Dimension 2 Code");
    //                     lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension" :
    //                       lrc_SalesDiscountLine.VALIDATE("Batch No.",lrc_SalesLineChargeItem."Shortcut Dimension 3 Code");
    //                     lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension" :
    //                      lrc_SalesDiscountLine.VALIDATE("Batch No.",lrc_SalesLineChargeItem."Shortcut Dimension 4 Code");
    //                     END;

    //                     lrc_SalesDiscountLine."Item No." := lrc_SalesLineChargeItem."No.";
    //                     lrc_SalesDiscountLine.Modify();
    //                   UNTIL lrc_SalesDiscountLine.NEXT(1) = 0;
    //                 END;
    //              UNTIL lrc_SalesLineChargeItem.NEXT(1) = 0;
    //             END;
    //           END;
    //           //FV4 000 FV400100.e
    //         --------------------------------------------------------------------------------*/


    //           // -------------------------------------------------------------------------------------------------
    //           // Kostenzeilen zur Gutschrift erzeugen
    //           // -------------------------------------------------------------------------------------------------
    //           lbn_FirstLineGL := TRUE;
    //           lrc_SalesClaimCost.RESET();
    //           lrc_SalesClaimCost.SETRANGE("Document No.",vco_ClaimNo);
    //           IF lrc_SalesClaimCost.FIND('-') THEN BEGIN
    //             REPEAT

    //               CASE lrc_SalesClaimCost."Doc. Type" OF
    //               lrc_SalesClaimCost."Doc. Type"::"Credit Memo":
    //                 BEGIN

    //                   IF lrc_SalesClaimCost."Document Created" = FALSE THEN BEGIN
    //                     IF lrc_SalesClaimCost."Send to No." = '' THEN BEGIN

    //                       CASE lrc_SalesClaimCost."In Document" OF
    //                       lrc_SalesClaimCost."In Document"::"Credit Memo Document":
    //                         BEGIN

    //                           IF lbn_FirstLineGL = TRUE THEN BEGIN
    //                             lbn_FirstLineGL := FALSE;
    //                             lrc_SalesLine.RESET();
    //                             lrc_SalesLine.INIT();
    //                             lrc_SalesLine."Document Type" := lrc_SalesHeader."Document Type";
    //                             lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
    //                             lin_LineNo := lin_LineNo + 10000;
    //                             lrc_SalesLine."Line No." := lin_LineNo;
    //                             lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::" ");
    //                             lrc_SalesLine.insert();
    //                           END;

    //                           lrc_SalesLine.RESET();
    //                           lrc_SalesLine.INIT();
    //                           lrc_SalesLine."Document Type" := lrc_SalesHeader."Document Type";
    //                           lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
    //                           lin_LineNo := lin_LineNo + 10000;
    //                           lrc_SalesLine."Line No." := lin_LineNo;
    //                           lrc_SalesLine.insert();

    //                           lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::"G/L Account");
    //                           lrc_SalesLine.VALIDATE("No.",lrc_SalesClaimCost."G/L Account No.");
    //                           lrc_SalesLine.VALIDATE(Quantity,1);
    //                           lrc_SalesLine.VALIDATE("Unit Price",lrc_SalesClaimCost."Amount (LCY)");

    //                           // Positionsnummer und Kostenkategorie setzen setzen
    //                           IF lrc_SalesClaimCost."Attached to Doc. Line No." <> 0 THEN BEGIN

    //                             lrc_SalesClaimLine.RESET();
    //                             lrc_SalesClaimLine.SETRANGE("Document No.",lrc_SalesClaimCost."Document No.");
    //                             lrc_SalesClaimLine.SETRANGE("Line No.",lrc_SalesClaimCost."Attached to Doc. Line No.");
    //                             lrc_SalesClaimLine.FIND('-');

    //                             // -------------------------------------------------------------
    //                             // Dimension setzen
    //                             // -------------------------------------------------------------
    //                             CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                               lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code",lrc_SalesClaimLine."Batch No.");
    //                               lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code",lrc_SalesClaimLine."Batch No.");
    //                               lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code",lrc_SalesClaimLine."Batch No.");
    //                               lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code",lrc_SalesClaimLine."Batch No.");
    //                             END;

    //                             // Dimension setzen
    //                             CASE lrc_FruitVisionSetup."Dim. No. Cost Category" OF
    //                               lrc_FruitVisionSetup."Dim. No. Cost Category"::"1. Dimension":
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code",lrc_SalesClaimCost."Cost Category Code");
    //                               lrc_FruitVisionSetup."Dim. No. Cost Category"::"2. Dimension":
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code",lrc_SalesClaimCost."Cost Category Code");
    //                               lrc_FruitVisionSetup."Dim. No. Cost Category"::"3. Dimension":
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code",lrc_SalesClaimCost."Cost Category Code");
    //                               lrc_FruitVisionSetup."Dim. No. Cost Category"::"4. Dimension":
    //                                 lrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code",lrc_SalesClaimCost."Cost Category Code");
    //                             END;

    //                           END;

    //                           IF lrc_SalesClaimCost."Posting Description" <> '' THEN
    //                             lrc_SalesLine.Description := lrc_SalesClaimCost."Posting Description";

    //                           lrc_SalesLine.Modify();

    //                           // Kennzeichen setzen, daß Kostensatz in Gutschrift übernommen wurde
    //                           lrc_SalesClaimCost."Document Created" := TRUE;
    //                           lrc_SalesClaimCost.Modify();

    //                         END;

    //                       END;

    //                     END;
    //                   END;

    //                 END;
    //                 ELSE
    //                   ERROR('Nicht zulässig!');
    //               END;
    //             UNTIL lrc_SalesClaimCost.next() = 0;
    //           END;

    //           // -------------------------------------------------------------------------------------------------
    //           // Gutschrift buchen
    //           // -------------------------------------------------------------------------------------------------
    //           IF lin_LineCreated > 0 THEN BEGIN
    //             IF lrc_FruitVisionSetup."Internal Customer Code" = 'BIOTROPIC' THEN BEGIN

    //               // Beleg berechnen berechnen
    //               lcu_Sales.CalcSalesOrder(lrc_SalesHeader);

    //               // Belegstatus auf Freigabe Fakturierung
    //               lrc_SalesHeader."Document Status" := lrc_SalesHeader."Document Status"::"Freigabe Fakturierung";
    //               lrc_SalesHeader.Modify();

    //               // Status auf Freigegeben setzen
    //               lcu_ReleaseSalesDocument.RUN(lrc_SalesHeader);

    //               // Beleg buchen, aber nicht drucken
    //               lrc_SalesHeader2.GET(lrc_SalesHeader."Document Type", lrc_SalesHeader."No.");
    //               COMMIT;

    //               CLEAR(lcu_SalesPost);
    //               lcu_SalesPost.ADF_NoMessageWithDocNo(TRUE);
    //               IF lcu_SalesPost.RUN(lrc_SalesHeader2 ) THEN BEGIN
    //                 MESSAGE(AGILES_LT_TEXT005, lrc_SalesHeader2."No.");
    //               END ELSE BEGIN
    //                 MESSAGE(AGILES_LT_TEXT004, lrc_SalesHeader2."No.");
    //               END;
    //               CLEAR(lcu_SalesPost);
    //             // DMG 015 DMG50371.s
    //             END ELSE BEGIN
    //               COMMIT;
    //               lbn_OpenCreditMemo := FALSE;
    //               lrc_ClaimDocSubtype.RESET();
    //               IF lrc_SalesHeader."No." <> '' THEN BEGIN
    //                 IF lrc_ClaimDocSubtype.GET( lrc_ClaimDocSubtype."Document Type"::"Sales Claim",
    //                                           lrc_SalesClaimHeader."Claim Doc. Subtype Code") THEN BEGIN
    //                    IF lrc_ClaimDocSubtype."Action On Registry" =
    //                       lrc_ClaimDocSubtype."Action On Registry"::"Direkt Open Credit Memo" THEN BEGIN
    //                      lbn_OpenCreditMemo := TRUE;
    //                    END ELSE BEGIN
    //                      IF lrc_ClaimDocSubtype."Action On Registry" =
    //                         lrc_ClaimDocSubtype."Action On Registry"::"Question to Open Credit Memo" THEN BEGIN
    //                         IF CONFIRM( AGILES_LT_TEXT008, TRUE, lrc_SalesHeader."No." ) THEN BEGIN
    //                           lbn_OpenCreditMemo := TRUE;
    //                         END;
    //                      END;
    //                    END;
    //                 END;
    //               END;
    //               IF lbn_OpenCreditMemo = TRUE THEN BEGIN
    //                  lcu_Sales.SalesShowCrMemo(lrc_SalesHeader."Document Type",lrc_SalesHeader."No.");
    //               END;
    //             // DMG 015 DMG50371.s


    //             END;
    //           END;

    //         END ELSE BEGIN
    //           // Es sind keine Zeile für eine Gutschrift vorhanden!
    //           ERROR(AGILES_LT_TEXT001);
    //         END;

    //     end;

    //     procedure SelectSalesClaimDocSubtype(): Code[10]
    //     var
    //         lrc_ClaimDocSubtypeFilter: Record "5087972";
    //         lrc_ClaimDocSubtype: Record "5087971";
    //         lrc_ClaimDocSubtype2: Record "5087971";
    //         lrc_UserSetup: Record "91";
    //         lfm_ClaimDocSubtypeList: Form "5110415";
    //         lco_ClaimDocTypeFilter: Code[1024];
    //         lbn_UserFilterClaimDocSubtype: Boolean;
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------------------------------------------
    //         //********RS lt. DevTool nicht verwendet********

    //         // VKR 002 DMG50078.s
    //         // Initialisierung
    //         lbn_UserFilterClaimDocSubtype := FALSE;
    //         lco_ClaimDocTypeFilter := '';

    //         // Filterung vorbereiten
    //         lrc_ClaimDocSubtype.RESET();
    //         lrc_ClaimDocSubtype.FILTERGROUP(2);
    //         lrc_ClaimDocSubtype.SETRANGE("Document Type",lrc_ClaimDocSubtype."Document Type"::"Sales Claim");
    //         lrc_ClaimDocSubtype.SETRANGE("In Selection",TRUE);

    //         // Benutzereinrichtung auf gesetzte Eingrenzungen überprüfen - Filter ggf. aufbauen
    //         IF lrc_UserSetup.GET(UserID()) THEN BEGIN
    //         //xx  IF lrc_UserSetup."Sales Doc. Subtype Filter" <> '' THEN BEGIN
    //         //xx    lrc_ClaimDocSubtype.SETFILTER(Code,lrc_UserSetup."Sales Claim Doc. Sub. Filter");
    //         //xx  END ELSE BEGIN
    //         //xx    lbn_UserFilterClaimDocSubtype := TRUE;
    //         //xx  END;
    //         END ELSE BEGIN
    //           lbn_UserFilterClaimDocSubtype := TRUE;
    //         END;

    //         IF lbn_UserFilterClaimDocSubtype = TRUE THEN BEGIN
    //           lrc_ClaimDocSubtypeFilter.RESET();
    //           lrc_ClaimDocSubtypeFilter.SETRANGE("Document Type",lrc_ClaimDocSubtypeFilter."Document Type"::"Sales Claim");
    //           lrc_ClaimDocSubtypeFilter.SETRANGE(Source,lrc_ClaimDocSubtypeFilter.Source::UserID;
    //           lrc_ClaimDocSubtypeFilter.SETRANGE("Source No.",UserID());
    //           lrc_ClaimDocSubtypeFilter.SETRANGE("Not Allowed",FALSE);
    //           IF lrc_ClaimDocSubtypeFilter.FIND('-') THEN BEGIN

    //             // definierte Belegunterarten für diesen User
    //             REPEAT
    //               IF lco_ClaimDocTypeFilter = '' THEN BEGIN
    //                 lco_ClaimDocTypeFilter := lrc_ClaimDocSubtypeFilter."Claim Doc. Subtype Code";
    //               END ELSE BEGIN
    //                 lco_ClaimDocTypeFilter := lco_ClaimDocTypeFilter  + '|' + lrc_ClaimDocSubtypeFilter."Claim Doc. Subtype Code";
    //               END;
    //             UNTIL lrc_ClaimDocSubtypeFilter.NEXT() = 0;

    //             // Filter anwenden
    //             IF lco_ClaimDocTypeFilter <> '' THEN BEGIN
    //               lrc_ClaimDocSubtype.SETFILTER(Code,lco_ClaimDocTypeFilter);
    //             END;

    //           END ELSE BEGIN

    //             // keine definierte Belegunterarten für diesen User. Gibt es welche für die
    //             // der User ausgeschlossen ist, dann nur auf zulässige Belegunterarten filtern
    //             lrc_ClaimDocSubtypeFilter.RESET();
    //             lrc_ClaimDocSubtypeFilter.SETRANGE("Document Type",lrc_ClaimDocSubtypeFilter."Document Type"::"Sales Claim");
    //             lrc_ClaimDocSubtypeFilter.SETRANGE(Source,lrc_ClaimDocSubtypeFilter.Source::UserID());
    //             lrc_ClaimDocSubtypeFilter.SETRANGE("Source No.",UserID());
    //             lrc_ClaimDocSubtypeFilter.SETRANGE("Not Allowed",TRUE);
    //             IF NOT lrc_ClaimDocSubtypeFilter.isempty()THEN BEGIN

    //               lrc_ClaimDocSubtype2.RESET();
    //               lrc_ClaimDocSubtype2.SETRANGE("Document Type",lrc_ClaimDocSubtype."Document Type"::"Sales Claim");
    //               lrc_ClaimDocSubtype2.SETRANGE("In Selection",TRUE);
    //               IF lrc_ClaimDocSubtype2.FIND('-') THEN BEGIN
    //                 REPEAT

    //                   lrc_ClaimDocSubtypeFilter.RESET();
    //                   lrc_ClaimDocSubtypeFilter.SETRANGE("Document Type",lrc_ClaimDocSubtype2."Document Type");
    //                   lrc_ClaimDocSubtypeFilter.SETRANGE("Claim Doc. Subtype Code",lrc_ClaimDocSubtype2.Code);
    //                   lrc_ClaimDocSubtypeFilter.SETRANGE(Source,lrc_ClaimDocSubtypeFilter.Source::UserID;
    //                   lrc_ClaimDocSubtypeFilter.SETRANGE("Source No.",UserID());
    //                   lrc_ClaimDocSubtypeFilter.SETRANGE("Not Allowed",TRUE);
    //                   IF NOT lrc_ClaimDocSubtypeFilter.FIND('-') THEN BEGIN
    //                     IF lco_ClaimDocTypeFilter = '' THEN BEGIN
    //                       lco_ClaimDocTypeFilter := lrc_ClaimDocSubtype2.Code;
    //                     END ELSE BEGIN
    //                       lco_ClaimDocTypeFilter := lco_ClaimDocTypeFilter  + '|' + lrc_ClaimDocSubtype2.Code;
    //                     END;
    //                   END;

    //                 UNTIL lrc_ClaimDocSubtype2.NEXT() = 0;
    //               END;

    //               // Filter anwenden
    //               IF lco_ClaimDocTypeFilter <> '' THEN BEGIN
    //                 lrc_ClaimDocSubtype.SETFILTER( Code,lco_ClaimDocTypeFilter);
    //               END;

    //             END;
    //           END;
    //         END;

    //         // ggf. Auswahlform öffnen
    //         lrc_ClaimDocSubtype.FILTERGROUP(0);
    //         IF lrc_ClaimDocSubtype.COUNT > 1 THEN BEGIN
    //           CLEAR(lfm_ClaimDocSubtypeList);
    //           lfm_ClaimDocSubtypeList.LOOKUPMODE := TRUE;
    //           lfm_ClaimDocSubtypeList.SETTABLEVIEW(lrc_ClaimDocSubtype);
    //           IF lfm_ClaimDocSubtypeList.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT('');
    //           lrc_ClaimDocSubtype.RESET();
    //           lfm_ClaimDocSubtypeList.GETRECORD(lrc_ClaimDocSubtype);
    //         END ELSE BEGIN
    //           lrc_ClaimDocSubtype.FIND('-');
    //         END;

    //         EXIT(lrc_ClaimDocSubtype.Code);
    //         // VKR 002 DMG50078.e
    //     end;

    //     procedure SetSalesDocSubtypeCode(vco_ClaimDocSubtype: Code[10])
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------------------------------------------

    //         // VKR 002 DMG50078.s
    //         gco_ClaimDocSubtypeCode := vco_ClaimDocSubtype;
    //         // VKR 002 DMG50078.e
    //     end;

    procedure FetchPriceFromOrder(var rrc_SalesClaimLine: Record "POI Sales Claim Notify Line")
    begin
        lrc_SalesInvoiceLine.RESET();
        lrc_SalesInvoiceLine.SETCURRENTKEY("Order No.", "Order Line No.", "Posting Date");
        lrc_SalesInvoiceLine.SETRANGE("Order No.", rrc_SalesClaimLine."Sales Order No.");
        lrc_SalesInvoiceLine.SETRANGE("Order Line No.", rrc_SalesClaimLine."Sales Order Line No.");
        IF lrc_SalesInvoiceLine.FINDFIRST() THEN BEGIN
            rrc_SalesClaimLine."Sales Unit Price" := lrc_SalesInvoiceLine."Unit Price";
            rrc_SalesClaimLine."Sales Amount" := rrc_SalesClaimLine."Sales Unit Price" * rrc_SalesClaimLine.Quantity;
            rrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesInvoiceLine."POI Price Base (Sales Price)";
            rrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesInvoiceLine."POI Sales Price (Price Base)";
        END ELSE BEGIN
            lrc_SalesLine.RESET();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
            lrc_SalesLine.SETRANGE("Document No.", rrc_SalesClaimLine."Sales Order No.");
            lrc_SalesLine.SETRANGE("Line No.", rrc_SalesClaimLine."Sales Order Line No.");
            IF lrc_SalesLine.FINDFIRST() THEN BEGIN
                rrc_SalesClaimLine."Sales Unit Price" := lrc_SalesLine."Unit Price";
                rrc_SalesClaimLine."Sales Amount" := rrc_SalesClaimLine."Sales Unit Price" * rrc_SalesClaimLine.Quantity;
                rrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesLine."POI Price Base (Sales Price)";
                rrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesLine."Sales Price (Price Base)";
            END;
        END;
    end;

    //     procedure SplittClaimLine(vrc_SalesClaimLine: Record "5110456")
    //     var
    //         lrc_OrgSalesClaimLine: Record "5110456";
    //         lrc_NewSalesClaimLine: Record "5110456";
    //         lin_LineNo: Integer;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum Splitten einer Reklamationszeile
    //         // ------------------------------------------------------------------------------------

    //         lrc_OrgSalesClaimLine.GET(vrc_SalesClaimLine."Document No.",vrc_SalesClaimLine."Line No.");
    //         IF lrc_OrgSalesClaimLine.Claim = FALSE THEN
    //           ERROR('Zeile ist nicht reklamiert!');

    //         IF NOT CONFIRM('Möchten Sie die aktuelle Zeile splitten?') THEN
    //           EXIT;

    //         lrc_NewSalesClaimLine.RESET();
    //         lrc_NewSalesClaimLine.SETRANGE("Document No.",lrc_OrgSalesClaimLine."Document No.");
    //         lrc_NewSalesClaimLine.FINDLAST();
    //         lin_LineNo := lrc_NewSalesClaimLine."Line No." + 10000;

    //         lrc_NewSalesClaimLine.RESET();
    //         lrc_NewSalesClaimLine.INIT();
    //         lrc_NewSalesClaimLine := lrc_OrgSalesClaimLine;
    //         lrc_NewSalesClaimLine."Document No." := lrc_OrgSalesClaimLine."Document No.";
    //         lrc_NewSalesClaimLine."Line No." := lin_LineNo;
    //         lrc_NewSalesClaimLine.INSERT(TRUE);

    //         lrc_NewSalesClaimLine.VALIDATE("Claim Quantity" ,0);
    //         lrc_NewSalesClaimLine.MODIFY(TRUE);
    //     end;

    //     procedure LoadAdditionalShipments(var rrc_SalesClaimAdviceHdr: Record "5110455";vco_ShipmentNo: Code[20];"vco OrderNo": Code[20])
    //     var
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_SalesClaimLine: Record "5110456";
    //         lrc_BatchVariantEntry: Record ""POI Batch Variant Entry"";
    //         lrc_SalesShipmentHdr: Record "110";
    //         lrc_SalesShipmentLine: Record "111";
    //         lrc_SalesDocType: Record "5110411";
    //         lin_LineNo: Integer;
    //         lrc_FruitVisionSetup: Record "5110302";
    //         AGILES_LT_TEXT001: Label 'Debitor Reklamationsmeldung %1\und Debitor Lieferung %2\sind unterschiedlich!';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Reklamation aus Lieferung laden
    //         // -------------------------------------------------------------------------------------

    //         // ADÜ 001 ADÜ40059.s
    //         IF (vco_ShipmentNo = '') THEN
    //           EXIT;

    //         lrc_SalesClaimLine.RESET();
    //         lrc_SalesClaimLine.SETRANGE("Document No.",rrc_SalesClaimAdviceHdr."No.");
    //         IF lrc_SalesClaimLine.FIND('+') THEN
    //           lin_LineNo := lrc_SalesClaimLine."Line No.";

    //         lrc_SalesShipmentHdr.GET(vco_ShipmentNo);
    //         IF rrc_SalesClaimAdviceHdr."Sell-to Customer No." <> lrc_SalesShipmentHdr."Sell-to Customer No." THEN
    //           // Debitor Reklamationsmeldung %1\und Debitor Lieferung %2\sind unterschiedlich!
    //           ERROR(AGILES_LT_TEXT001,rrc_SalesClaimAdviceHdr."Sell-to Customer No.",lrc_SalesShipmentHdr."Sell-to Customer No.");

    //         lrc_BatchSetup.get();
    //         lrc_SalesDocType.GET(lrc_SalesDocType."Document Type"::Order, lrc_SalesShipmentHdr."Sales Doc. Subtype Code");
    //         IF lrc_BatchSetup."Sales Batch Assignment" = lrc_BatchSetup."Sales Batch Assignment"::"Depend on Doc. Type" THEN BEGIN
    //           lrc_BatchSetup."Sales Batch Assignment" := lrc_SalesDocType."Sales Batch Assignment";
    //         END;

    //         // --------------------------------------------------------------------------------------------------
    //         // Falls mehr als eine Lieferung pro Auftrag/Rechnung vorhanden sind -> Verkaufslieferzeilen lesen
    //         // --------------------------------------------------------------------------------------------------
    //         lrc_SalesShipmentLine.RESET();
    //         lrc_SalesShipmentLine.SETCURRENTKEY("Order No.","Order Line No.","Posting Date");

    //         // --------------------------------------------------------------------------------------
    //         // Lieferungen mit gleicher Auftragsnummer und abweichender Lieferscheinnr. lesen
    //         // --------------------------------------------------------------------------------------

    //         lrc_SalesShipmentLine.SETRANGE("Order No.","vco OrderNo");
    //         lrc_SalesShipmentLine.SETFILTER("Document No.",'<>%1',vco_ShipmentNo);
    //         lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
    //         lrc_SalesShipmentLine.SETFILTER("No.",'<>%1','');
    //         lrc_SalesShipmentLine.SETFILTER(Quantity,'<>%1',0);
    //         lrc_SalesShipmentLine.SETRANGE(Correction,FALSE);

    //         IF lrc_SalesShipmentLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             IF lrc_SalesShipmentLine."POI Batch Item" = FALSE THEN BEGIN

    //               lrc_SalesClaimLine.RESET();
    //               lrc_SalesClaimLine.INIT();
    //               lrc_SalesClaimLine."Document No." := rrc_SalesClaimAdviceHdr."No.";
    //               lin_LineNo := lin_LineNo + 10000;
    //               lrc_SalesClaimLine."Line No." := lin_LineNo;
    //               lrc_SalesClaimLine.Claim := FALSE;
    //               lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
    //               lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
    //               lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
    //               lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";
    //               lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
    //               lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
    //               lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
    //               lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
    //               lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
    //               lrc_SalesClaimLine."Item Attribute 2" := lrc_SalesShipmentLine."POI Color Code";
    //               lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
    //               lrc_SalesClaimLine."Item Attribute 7" := lrc_SalesShipmentLine."POI Conservation Code";
    //               lrc_SalesClaimLine."Item Attribute 4" := lrc_SalesShipmentLine."POI Packing Code";
    //               lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
    //               lrc_SalesClaimLine."Item Attribute 5" := lrc_SalesShipmentLine."POI Treatment Code";
    //               lrc_SalesClaimLine."Item Attribute 3" := lrc_SalesShipmentLine."POI Quality Code";
    //               lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
    //               lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
    //               lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
    //               lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
    //               lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
    //               lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";

    //               lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
    //               lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
    //               lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";

    //               lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001 );
    //         //      lrc_SalesClaimLine."Quantity Invoiced" := 0;
    //               lrc_SalesClaimLine.Quantity := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001 );

    //               lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesShipmentLine."Quantity (Base)", 0.00001 );
    //               lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
    //               lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
    //               lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001 );
    //               lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
    //               lrc_SalesClaimLine."Qty. (Unit) per Transport (TU)" := lrc_SalesShipmentLine."POI Qty.(Unit) per Transp.Unit";
    //               lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001 );
    //               lrc_SalesClaimLine."Collo Unit of Measure (CU)" :=  lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
    //               lrc_SalesClaimLine."Content Unit of Measure (COU)" :=  lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";

    //               lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
    //               lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
    //               lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" :=  lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";

    //               lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."POI Price Unit of Measure";
    //               lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

    //               lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
    //               lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" * lrc_SalesClaimLine.Quantity;
    //               lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
    //               lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";
    //               lrc_SalesClaimLine."Sales Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";

    //               lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
    //               lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
    //               lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
    //               lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
    //               lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
    //               lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
    //               lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";

    //               lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
    //               lrc_SalesClaimLine."Claim Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";

    //               lrc_SalesClaimLine."Claim Quantity" := 0;
    //               lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
    //               lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
    //               lrc_SalesClaimLine."Claim Sales Amount" := 0;
    //               lrc_SalesClaimLine."Claim Verlust" := 0;

    //               //POI 001 00000000 JST 281112 000 Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
    //               //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
    //               //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
    //               gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.",BuyFromVendorNo,
    //                                                                   VendorOrderNo,IstPackauftrag,PackauftragEindeutig);
    //               lrc_SalesClaimLine."Buy-from Vendor No.":=BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
    //               lrc_SalesClaimLine."Vendor Order No.":=VendorOrderNo;
    //               //Return to Vendor ??
    //               //POI 001 00000000 JST 281112 e.


    //               // VKR 006 IFW40127.s
    //               lrc_FruitVisionSetup.GET();
    //               //IF (lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT') OR
    //                 //DMG 000 DMG50180.s
    //               //  (lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN BEGIN
    //                 //DMG 000 DMG50180.s
    //                 FetchPriceFromOrder(lrc_SalesClaimLine);
    //               //END;
    //               // VKR 006 IFW40127.e

    //               lrc_SalesClaimLine.insert();

    //             END ELSE BEGIN

    //               CASE lrc_BatchSetup."Sales Batch Assignment" OF
    //               lrc_BatchSetup."Sales Batch Assignment"::"Manual Multiple Line":
    //               BEGIN

    //                 lrc_SalesShipmentLine.TESTFIELD("Batch Var. Detail ID");
    //                 lrc_BatchVariantEntry.RESET();
    //                 lrc_BatchVariantEntry.SETCURRENTKEY("Detail Entry No.","Detail Line No.");
    //                 lrc_BatchVariantEntry.SETRANGE("Detail Entry No.",lrc_SalesShipmentLine."Batch Var. Detail ID");
    //                 //DMG 000 DMG50180.s
    //                 lrc_BatchVariantEntry.SETRANGE("Source Doc. Type",lrc_BatchVariantEntry."Source Doc. Type"::Order);
    //                 lrc_BatchVariantEntry.SETRANGE("Source Doc. No.", lrc_SalesShipmentLine."Order No.");
    //                 lrc_BatchVariantEntry.SETRANGE("Document No.",lrc_SalesShipmentLine."Document No.");
    //                 lrc_BatchVariantEntry.SETRANGE( "Document Line No.", lrc_SalesShipmentLine."Line No." );
    //                 lrc_BatchVariantEntry.SETRANGE( Correction, FALSE );
    //                 //DMG 000 DMG50180.e

    //                 IF lrc_BatchVariantEntry.FINDSET(FALSE,FALSE) THEN
    //                 REPEAT

    //                   lrc_SalesClaimLine.RESET();
    //                   lrc_SalesClaimLine.INIT();
    //                   lrc_SalesClaimLine."Document No." := rrc_SalesClaimAdviceHdr."No.";
    //                   lin_LineNo := lin_LineNo + 10000;
    //                   lrc_SalesClaimLine."Line No." := lin_LineNo;
    //                   lrc_SalesClaimLine.Claim := FALSE;
    //                   lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
    //                   lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
    //                   lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
    //                   lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";
    //                   lrc_SalesClaimLine."Master Batch No." := lrc_BatchVariantEntry."Master Batch No.";
    //                   lrc_SalesClaimLine."Batch No." := lrc_BatchVariantEntry."Batch No.";
    //                   lrc_SalesClaimLine."Batch Variant No." := lrc_BatchVariantEntry."Batch Variant No.";
    //                   lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
    //                   lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
    //                   lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
    //                   lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
    //                   lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
    //                   lrc_SalesClaimLine."Item Attribute 2" := lrc_SalesShipmentLine."POI Color Code";
    //                   lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
    //                   lrc_SalesClaimLine."Item Attribute 7" := lrc_SalesShipmentLine."POI Conservation Code";
    //                   lrc_SalesClaimLine."Item Attribute 4" := lrc_SalesShipmentLine."POI Packing Code";
    //                   lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
    //                   lrc_SalesClaimLine."Item Attribute 5" := lrc_SalesShipmentLine."POI Treatment Code";
    //                   lrc_SalesClaimLine."Item Attribute 3" := lrc_SalesShipmentLine."POI Quality Code";
    //                   lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
    //                   lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
    //                   lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
    //                   lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
    //                   lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
    //                   lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";

    //                   lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
    //                   lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
    //                   lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";

    //                   lrc_SalesClaimLine.Quantity := ROUND((lrc_BatchVariantEntry."Quantity (Base)" /
    //                                                        lrc_SalesShipmentLine."Qty. per Unit of Measure") * -1, 0.00001 );
    //                   lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesClaimLine.Quantity, 0.00001 );

    //                   lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesClaimLine.Quantity *
    //                                                                 lrc_SalesClaimLine."Qty. per Unit of Measure", 0.00001 );
    //                   lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
    //                   lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
    //                   lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001 );
    //                   lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
    //                   lrc_SalesClaimLine."Qty. (Unit) per Transport (TU)" := lrc_SalesShipmentLine."POI Qty.(Unit) per Transp.Unit";
    //                   lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001 );
    //                   lrc_SalesClaimLine."Collo Unit of Measure (CU)" :=  lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
    //                   lrc_SalesClaimLine."Content Unit of Measure (COU)" :=  lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";

    //                   lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
    //                   lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
    //                   lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" :=  lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";

    //                   lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
    //                   lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" *
    //                                                              lrc_SalesClaimLine.Quantity;

    //                   lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
    //                   lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";

    //                   lrc_SalesClaimLine."Sales Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";

    //                   lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."POI Price Unit of Measure";
    //                   lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

    //                   lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
    //                   lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
    //                   lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
    //                   lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
    //                   lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
    //                   lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
    //                   lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";

    //                   lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
    //                   lrc_SalesClaimLine."Claim Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";

    //                   lrc_SalesClaimLine."Claim Quantity" := 0;
    //                   lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
    //                   lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
    //                   lrc_SalesClaimLine."Claim Sales Amount" := 0;
    //                   lrc_SalesClaimLine."Claim Verlust" := 0;

    //                   //POI 001 00000000 JST 281112 000 Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
    //                   //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
    //                   //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
    //                   gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.",BuyFromVendorNo,
    //                                                                   VendorOrderNo,IstPackauftrag,PackauftragEindeutig);
    //                   lrc_SalesClaimLine."Buy-from Vendor No.":=BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
    //                   lrc_SalesClaimLine."Vendor Order No.":=VendorOrderNo;
    //                   //Return to Vendor ??
    //                   //POI 001 00000000 JST 281112 e.

    //                   // VKR 006 IFW40127.s
    //                   lrc_FruitVisionSetup.GET();
    //                   //IF (lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT') OR
    //                     //DMG 000 DMG50180.s
    //                   //  (lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN BEGIN
    //                     //DMG 000 DMG50180.s
    //                     FetchPriceFromOrder(lrc_SalesClaimLine);
    //                   //END;
    //                   // VKR 006 IFW40127.e

    //                   lrc_SalesClaimLine.insert();

    //                 UNTIL lrc_BatchVariantEntry.next() = 0;

    //               END;

    //               lrc_BatchSetup."Sales Batch Assignment"::"Manual Single Line",
    //               lrc_BatchSetup."Sales Batch Assignment"::"Automatic from System":
    //               BEGIN

    //                 lrc_SalesClaimLine.RESET();
    //                 lrc_SalesClaimLine.INIT();
    //                 lrc_SalesClaimLine."Document No." := rrc_SalesClaimAdviceHdr."No.";
    //                 lin_LineNo := lin_LineNo + 10000;
    //                 lrc_SalesClaimLine."Line No." := lin_LineNo;
    //                 lrc_SalesClaimLine.Claim := FALSE;
    //                 lrc_SalesClaimLine.Type := lrc_SalesClaimLine.Type::Item;
    //                 lrc_SalesClaimLine."No." := lrc_SalesShipmentLine."No.";
    //                 lrc_SalesClaimLine.Description := lrc_SalesShipmentLine.Description;
    //                 lrc_SalesClaimLine."Description 2" := lrc_SalesShipmentLine."Description 2";

    //                 lrc_SalesClaimLine."Master Batch No." := lrc_SalesShipmentLine."POI Master Batch No.";
    //                 lrc_SalesClaimLine."Batch No." := lrc_SalesShipmentLine."Batch No.";
    //                 lrc_SalesClaimLine."Batch Variant No." := lrc_SalesShipmentLine."Batch Variant No.";

    //                 lrc_SalesClaimLine."Batch Item" := lrc_SalesShipmentLine."POI Batch Item";
    //                 lrc_SalesClaimLine."Variety Code" := lrc_SalesShipmentLine."POI Variety Code";
    //                 lrc_SalesClaimLine."Country of Origin Code" := lrc_SalesShipmentLine."POI Country of Origin Code";
    //                 lrc_SalesClaimLine."Trademark Code" := lrc_SalesShipmentLine."POI Trademark Code";
    //                 lrc_SalesClaimLine."Caliber Code" := lrc_SalesShipmentLine."POI Caliber Code";
    //                 lrc_SalesClaimLine."Item Attribute 2" := lrc_SalesShipmentLine."POI Color Code";
    //                 lrc_SalesClaimLine."Grade of Goods Code" := lrc_SalesShipmentLine."POI Grade of Goods Code";
    //                 lrc_SalesClaimLine."Item Attribute 7" := lrc_SalesShipmentLine."POI Conservation Code";
    //                 lrc_SalesClaimLine."Item Attribute 4" := lrc_SalesShipmentLine."POI Packing Code";
    //                 lrc_SalesClaimLine."Coding Code" := lrc_SalesShipmentLine."POI Coding Code";
    //                 lrc_SalesClaimLine."Item Attribute 5" := lrc_SalesShipmentLine."POI Treatment Code";
    //                 lrc_SalesClaimLine."Item Attribute 3" := lrc_SalesShipmentLine."POI Quality Code";
    //                 lrc_SalesClaimLine."Info 1" := lrc_SalesShipmentLine."POI Info 1";
    //                 lrc_SalesClaimLine."Info 2" := lrc_SalesShipmentLine."POI Info 2";
    //                 lrc_SalesClaimLine."Info 3" := lrc_SalesShipmentLine."POI Info 3";
    //                 lrc_SalesClaimLine."Info 4" := lrc_SalesShipmentLine."POI Info 4";
    //                 lrc_SalesClaimLine."Item Category Code" := lrc_SalesShipmentLine."Item Category Code";
    //                 lrc_SalesClaimLine."Product Group Code" := lrc_SalesShipmentLine."POI Product Group Code";

    //                 lrc_SalesClaimLine."Price Unit of Measure Code" := lrc_SalesShipmentLine."POI Price Unit of Measure";
    //                 lrc_SalesClaimLine."Partial Quantity (PQ)" := lrc_SalesShipmentLine."POI Partial Quantity (PQ)";

    //                 lrc_SalesClaimLine."Unit of Measure Code" := lrc_SalesShipmentLine."Unit of Measure Code";
    //                 lrc_SalesClaimLine."Base Unit of Measure (BU)" := lrc_SalesShipmentLine."POI Base Unit of Measure (BU)";
    //                 lrc_SalesClaimLine."Qty. per Unit of Measure" := lrc_SalesShipmentLine."Qty. per Unit of Measure";

    //                 lrc_SalesClaimLine."Quantity Shipped" := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001 );
    //         //      lrc_SalesClaimLine."Quantity Invoiced" := 0;
    //                 lrc_SalesClaimLine.Quantity := ROUND(lrc_SalesShipmentLine.Quantity, 0.00001 );

    //                 lrc_SalesClaimLine."Quantity (Base)" := ROUND(lrc_SalesShipmentLine."Quantity (Base)", 0.00001 );
    //                 lrc_SalesClaimLine."Packing Unit of Measure (PU)" := lrc_SalesShipmentLine."POI Packing Unit of Meas (PU)";
    //                 lrc_SalesClaimLine."Qty. (PU) per Unit of Measure" := lrc_SalesShipmentLine."POI Qty. (PU) per Unit of Meas";
    //                 lrc_SalesClaimLine."Quantity (PU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (PU)", 0.00001 );
    //                 lrc_SalesClaimLine."Transport Unit of Measure (TU)" := lrc_SalesShipmentLine."POI Transport Unit of Meas(TU)";
    //                 lrc_SalesClaimLine."Qty. (Unit) per Transport (TU)" := lrc_SalesShipmentLine."POI Qty.(Unit) per Transp.Unit";
    //                 lrc_SalesClaimLine."Quantity (TU)" := ROUND(lrc_SalesShipmentLine."POI Quantity (TU)", 0.00001 );
    //                 lrc_SalesClaimLine."Collo Unit of Measure (CU)" :=  lrc_SalesShipmentLine."POI Collo Unit of Measure (PQ)";
    //                 lrc_SalesClaimLine."Content Unit of Measure (COU)" :=  lrc_SalesShipmentLine."POI Content Unit of Meas (COU)";

    //                 lrc_SalesClaimLine."Gross Weight" := lrc_SalesShipmentLine."Gross Weight";
    //                 lrc_SalesClaimLine."Net Weight" := lrc_SalesShipmentLine."Net Weight";
    //                 lrc_SalesClaimLine."Qty. (COU) per Pack. Unit (PU)" :=  lrc_SalesShipmentLine."POI Qty.(COU)per Pack.Unit(PU)";

    //                 lrc_SalesClaimLine."Sales Unit Price" := lrc_SalesShipmentLine."Unit Price";
    //                 lrc_SalesClaimLine."Sales Amount" := lrc_SalesClaimLine."Sales Unit Price" *
    //                                                      lrc_SalesClaimLine.Quantity;

    //                 lrc_SalesClaimLine."Price Base (Sales Price)" := lrc_SalesShipmentLine."POI Price Base (Sales Price)";
    //                 lrc_SalesClaimLine."Sales Price (Price Base)" := lrc_SalesShipmentLine."POI Sales Price (Price Base)";
    //                 lrc_SalesClaimLine."Sales Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";

    //                 lrc_SalesClaimLine."Sales Order No." := lrc_SalesShipmentLine."Order No.";
    //                 lrc_SalesClaimLine."Sales Order Line No." := lrc_SalesShipmentLine."Order Line No.";
    //                 lrc_SalesClaimLine."Sales Shipment No." := lrc_SalesShipmentLine."Document No.";
    //                 lrc_SalesClaimLine."Sales Shipment Line No." := lrc_SalesShipmentLine."Line No.";
    //                 lrc_SalesClaimLine."Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
    //                 lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesShipmentLine."POI Shipping Agent Code";
    //                 lrc_SalesClaimLine."Location Code" := lrc_SalesShipmentLine."Location Code";

    //                 lrc_SalesClaimLine."Claim Location Code" := lrc_SalesShipmentLine."Location Code";
    //                 lrc_SalesClaimLine."Claim Quality Rating" := lrc_SalesShipmentLine."POI Quality Rating";

    //                 lrc_SalesClaimLine."Claim Quantity" := 0;
    //                 lrc_SalesClaimLine."Claim Sales Unit Price" := 0;
    //                 lrc_SalesClaimLine."Claim Sales Price (Price Base)" := 0;
    //                 lrc_SalesClaimLine."Claim Sales Amount" := 0;
    //                 lrc_SalesClaimLine."Claim Verlust" := 0;

    //                 //POI 001 00000000 JST 281112 000 Port-Rekla-Überarbeitung autom. füllen Felder z.B.Buy from Vendor, Vendor Order No.
    //                 //Differenzieren zwischen Partie und EInkauf (z.B. für Packaufträge)
    //                 //BuyFromVendorNo:=lrc_BatchVariant."Vendor No.";
    //                 gcu_Port_Sales.VK_ReklaLineGiveEKBENo(lrc_SalesShipmentLine."POI Master Batch No.",BuyFromVendorNo,
    //                                                                   VendorOrderNo,IstPackauftrag,PackauftragEindeutig);
    //                 lrc_SalesClaimLine."Buy-from Vendor No.":=BuyFromVendorNo; //lrc_SalesClaimLine."Vendor No."
    //                 lrc_SalesClaimLine."Vendor Order No.":=VendorOrderNo;
    //                 //Return to Vendor ??
    //                 //POI 001 00000000 JST 281112 e.

    //                 // VKR 006 IFW40127.s
    //                 lrc_FruitVisionSetup.GET();
    //                 //IF (lrc_FruitVisionSetup."Internal Customer Code" = 'INTERWEICHERT') OR
    //                   //DMG 000 DMG50180.s
    //                 //  (lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN BEGIN
    //                   //DMG 000 DMG50180.s
    //                   FetchPriceFromOrder(lrc_SalesClaimLine);
    //                 //END;
    //                 // VKR 006 IFW40127.e

    //                 lrc_SalesClaimLine.insert();

    //                 END;
    //               END;
    //             END;

    //           UNTIL lrc_SalesShipmentLine.next() = 0;

    //           // ---------------------------------------------------------------------------------------------
    //           // Auftragsnummer in Kopfsatz speichern
    //           // ---------------------------------------------------------------------------------------------
    //           // Lieferscheinnr. leer lassen, da keine eindeutige Zuweisung stattfinden kann
    //           rrc_SalesClaimAdviceHdr."Sales Shipment No." := '';
    //           rrc_SalesClaimAdviceHdr."Sales Order No." := lrc_SalesShipmentHdr."Order No.";
    //           rrc_SalesClaimAdviceHdr."Sales Doc. Subtyp Code" := lrc_SalesShipmentHdr."Sales Doc. Subtype Code";
    //           rrc_SalesClaimAdviceHdr."Sales Salesperson Code" := lrc_SalesShipmentHdr."Salesperson Code";
    //           rrc_SalesClaimAdviceHdr."Location Code" := lrc_SalesShipmentHdr."Location Code";
    //           rrc_SalesClaimAdviceHdr."Claim Location Code" := lrc_SalesShipmentHdr."Location Code";

    //           //DMG 006 DMG50185.s
    //           rrc_SalesClaimAdviceHdr."Ship-to Code" := lrc_SalesShipmentHdr."Ship-to Code";
    //           rrc_SalesClaimAdviceHdr."Ship-to Name" :=  lrc_SalesShipmentHdr."Ship-to Name";
    //           rrc_SalesClaimAdviceHdr."Ship-to Name 2" := lrc_SalesShipmentHdr."Ship-to Name 2";
    //           rrc_SalesClaimAdviceHdr."Ship-to Address" := lrc_SalesShipmentHdr."Ship-to Address";
    //           rrc_SalesClaimAdviceHdr."Ship-to Address 2":=  lrc_SalesShipmentHdr."Ship-to Address 2";
    //           rrc_SalesClaimAdviceHdr."Ship-to City" :=  lrc_SalesShipmentHdr."Ship-to City";
    //           rrc_SalesClaimAdviceHdr."Ship-to Contact" := lrc_SalesShipmentHdr."Ship-to Contact";
    //           rrc_SalesClaimAdviceHdr."Ship-to Post Code" := lrc_SalesShipmentHdr."Ship-to Post Code";
    //           rrc_SalesClaimAdviceHdr."Ship-to Country Code" :=  lrc_SalesShipmentHdr."Ship-to Country/Region Code";
    //           //DMG 006 DMG50185.e
    //         END;


    //         //ADÜ 001 ADÜ40059.e
    //     end;

    procedure AktualSalesClaimLineFromCrMemo(vrc_SalesLine: Record "Sales Line")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
    begin

        IF vrc_SalesLine."Document Type" <> vrc_SalesLine."Document Type"::"Credit Memo" THEN
            EXIT;

        lrc_SalesClaimLine.RESET();
        lrc_SalesClaimLine.SETCURRENTKEY("Cr.M./Return O. No.", "Cr.M./Return O. Line No.");
        lrc_SalesClaimLine.SETRANGE("Cr.M./Return O. No.", vrc_SalesLine."Document No.");
        lrc_SalesClaimLine.SETRANGE("Cr.M./Return O. Line No.", vrc_SalesLine."Line No.");
        IF lrc_SalesClaimLine.FINDFIRST() THEN BEGIN
            IF lrc_SalesClaimLine."Claim Return Quantity" = TRUE THEN BEGIN
                lrc_SalesClaimLine.VALIDATE("Claim Quantity", vrc_SalesLine.Quantity);
                lrc_SalesClaimLine.VALIDATE("Net Weight", vrc_SalesLine."Net Weight");
                lrc_SalesClaimLine.VALIDATE("Gross Weight", vrc_SalesLine."Gross Weight");
                IF vrc_SalesLine."POI Price Base (Sales Price)" = '' THEN BEGIN
                    lrc_SalesClaimLine.VALIDATE("Price Base (Sales Price)", '');
                    lrc_SalesClaimLine.VALIDATE("Claim Sales Unit Price", vrc_SalesLine."Unit Price");
                END ELSE BEGIN
                    lrc_SalesClaimLine.VALIDATE("Price Base (Sales Price)", vrc_SalesLine."POI Price Base (Sales Price)");
                    lrc_SalesClaimLine.VALIDATE("Claim Sales Price (Price Base)", vrc_SalesLine."Sales Price (Price Base)")
                END;
            END ELSE BEGIN
                lrc_FruitVisionSetup.GET();
                CASE lrc_FruitVisionSetup."Sales Claim CrM. only Value" OF
                    lrc_FruitVisionSetup."Sales Claim CrM. only Value"::"Qty In and Out":
                        ;
                    lrc_FruitVisionSetup."Sales Claim CrM. only Value"::"Item Charge":
                        BEGIN
                            lrc_SalesClaimLine.VALIDATE("Price Base (Sales Price)", '');
                            lrc_SalesClaimLine.VALIDATE("Claim Sales Unit Price", vrc_SalesLine."Unit Price");
                        END;
                END;
            END;
            lrc_SalesClaimLine.MODIFY(TRUE);
        END;
    end;

    var
        lrc_SalesLine: Record "Sales Line";
        lrc_SalesClaimHeader: Record "POI Sales Claim Notify Header";
        lrc_SalesClaimLine: Record "POI Sales Claim Notify Line";
        lrc_BatchVariantEntry: Record "POI Batch Variant Entry";
        lrc_SalesShipmentHdr: Record "Sales Shipment Header";
        lrc_SalesInvoiceLine: Record "Sales Invoice Line";
}

