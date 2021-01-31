codeunit 5110325 "POI EIM Empties Item Mgt"
{

    procedure PurchAttachEmptiesToPurchLines(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vin_LineNo: Integer)
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchHeader: Record "Purchase Header";
        //lrc_RefundCosts: Record "POI Empties/Transport Ref Cost";
        lrc_Item2: Record Item;
        lrc_BOMComponent: Record "BOM Component";
        lrc_CompanyChain: Record "POI Company Chain";
        lrc_Vendor: Record Vendor;
        lrc_GenProductPostingGroup: Record "Gen. Product Posting Group";
        lco_ItemArray: array[100] of Code[20];
        ldc_BOMQuantity: array[100] of Decimal;
        lin_ArrayCounter: Integer;
        lbn_LineAvailable: Boolean;
        lin_LineNo: Integer;
        //ldc_SaveQuantityToInvoice: Decimal;
        ldt_Date: Date;
        lop_SourceType: Option Customer,Vendor,"Shipping Agent","Empties Price Group";
        lop_EmptiesAllocation: Option "Without Stock-Keeping Without Invoice","With Stock-Keeping Without Invoice","With Stock-Keeping With Invoice";
        SSPText01Txt: Label 'Multiple Levels aren''t supported at empties ! %1 - %2', Comment = '%1 %2';
        ldc_UnitPrice: Decimal;
    begin
        // ----------------------------------------------------------------------------------------------------------
        // Funktionen zur Erstellung und Aktualisierung der Leergutartikelzeilen zu einer Artikelzeile im Einkauf
        // ----------------------------------------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();
        lrc_PurchHeader.GET(vop_DocType, vco_DocNo);

        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        IF vin_LineNo <> 0 THEN
            lrc_PurchLine.SETRANGE("Line No.", vin_LineNo);
        lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
        lrc_PurchLine.SETRANGE("POI Subtyp", lrc_PurchLine."POI Subtyp"::" ");
        //RS zurückschreiben der Leergutzeilennummer in die Artikelzeile
        //IF lrc_PurchLine.FINDSET(FALSE,FALSE) THEN BEGIN
        IF lrc_PurchLine.FINDSET(TRUE, FALSE) THEN BEGIN

            lrc_Vendor.GET(lrc_PurchHeader."Buy-from Vendor No.");
            IF (NOT lrc_CompanyChain.GET(lrc_Vendor."POI Chain Name")) OR (lrc_Vendor."POI Chain Name" = '') THEN
                lop_EmptiesAllocation := lrc_Vendor."POI Empties Allocation"
            ELSE
                IF lrc_Vendor."POI Active Empties Definition" = lrc_Vendor."POI Active Empties Definition"::Vendor THEN
                    lop_EmptiesAllocation := lrc_Vendor."POI Empties Allocation"
                ELSE
                    lop_EmptiesAllocation := lrc_CompanyChain."Empties Allocation";



            REPEAT
                IF (lrc_PurchLine."POI Empties Item No." = '') OR (lrc_PurchLine."POI Empties Quantity" = 0) OR (lrc_PurchLine.Quantity = 0) THEN
                    PurchDeleteEmptiesItemLines(lrc_PurchLine)
                ELSE BEGIN

                    CLEAR(lco_ItemArray);
                    CLEAR(ldc_BOMQuantity);

                    PurchDeleteEmptiesItemLines(lrc_PurchLine);

                    lrc_Item.GET(lrc_PurchLine."POI Empties Item No.");
                    lrc_Item.CALCFIELDS("POI Bill of Materials");

                    // Artikel oder Stückliste laden
                    IF lrc_Item."POI Bill of Materials" = TRUE THEN BEGIN
                        lrc_BOMComponent.RESET();
                        lrc_BOMComponent.SETRANGE("Parent Item No.", lrc_PurchLine."POI Empties Item No.");
                        lrc_BOMComponent.SETRANGE(Type, lrc_BOMComponent.Type::Item);
                        lrc_BOMComponent.SETFILTER("No.", '<>%1', '');
                        IF lrc_BOMComponent.FINDSET(FALSE, FALSE) THEN BEGIN
                            lin_ArrayCounter := 1;
                            REPEAT
                                lrc_BOMComponent.CALCFIELDS("Assembly BOM");
                                IF lrc_BOMComponent."Assembly BOM" = TRUE THEN
                                    ERROR(SSPText01Txt, lrc_BOMComponent."No.", lrc_BOMComponent."Parent Item No.");
                                lco_ItemArray[lin_ArrayCounter] := lrc_BOMComponent."No.";
                                ldc_BOMQuantity[lin_ArrayCounter] := lrc_BOMComponent."Quantity per";
                                lin_ArrayCounter := lin_ArrayCounter + 1;
                            UNTIL lrc_BOMComponent.NEXT() = 0;
                        END ELSE BEGIN
                            lco_ItemArray[1] := lrc_PurchLine."POI Empties Item No.";
                            ldc_BOMQuantity[1] := 1;
                        END;
                    END ELSE BEGIN
                        lco_ItemArray[1] := lrc_PurchLine."POI Empties Item No.";
                        ldc_BOMQuantity[1] := 1;
                    END;

                    // Alle Pfandartikel für die Zeile lesen
                    lin_ArrayCounter := 1;
                    REPEAT
                        IF lco_ItemArray[lin_ArrayCounter] <> '' THEN BEGIN

                            // Preis ermitteln
                            ldc_UnitPrice := 0;
                            ldt_Date := lrc_PurchHeader."Order Date";
                            IF ldt_Date = 0D THEN
                                ldt_Date := lrc_PurchHeader."Document Date";

                            IF (lrc_PurchHeader."Document Type" = lrc_PurchHeader."Document Type"::"Credit Memo") OR
                               (lrc_PurchHeader."Document Type" = lrc_PurchHeader."Document Type"::"Return Order") THEN
                                CalculateEmptiesShipmentPrice(lco_ItemArray[lin_ArrayCounter],
                                                              lop_SourceType::Vendor,
                                                              lrc_PurchLine."Buy-from Vendor No.",
                                                              lrc_PurchHeader."Location Code",
                                                              ldt_Date,
                                                              1,
                                                              1,
                                                              ldc_UnitPrice)
                            ELSE
                                CalculateEmptiesReceiptPrice(lco_ItemArray[lin_ArrayCounter],
                                                             lop_SourceType::Vendor,
                                                             lrc_PurchLine."Buy-from Vendor No.",
                                                             lrc_PurchHeader."Location Code",
                                                             ldt_Date,
                                                             1,
                                                             1,
                                                             lrc_PurchHeader."Document Type",
                                                             lrc_PurchHeader."No.",
                                                             0,
                                                             ldc_UnitPrice);



                            IF (ldc_BOMQuantity[lin_ArrayCounter] <> 0) AND
                               ((lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping Without Invoice") OR
                                (lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping With Invoice")) THEN BEGIN

                                // Kontrolle ob es bereits den Pfandartikel als zugeordnete Eink.-Zeile gibt
                                lbn_LineAvailable := FALSE;
                                lrc_PurchLine2.RESET();
                                lrc_PurchLine2.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                                lrc_PurchLine2.SETRANGE("Document No.", lrc_PurchHeader."No.");
                                lrc_PurchLine2.SETRANGE(Type, lrc_PurchLine2.Type::Item);
                                lrc_PurchLine2.SETRANGE("No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_PurchLine2.SETRANGE("POI Subtyp", lrc_PurchLine2."POI Subtyp"::"Refund Empties");
                                lrc_PurchLine2.SETRANGE("Attached to Line No.", lrc_PurchLine."Line No.");
                                IF lrc_PurchLine2.findfirst() THEN
                                    lbn_LineAvailable := TRUE;

                                IF lbn_LineAvailable = FALSE THEN BEGIN
                                    // Nächste frei Zeilennummer ermitteln
                                    lrc_PurchLine2.RESET();
                                    lrc_PurchLine2.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                                    lrc_PurchLine2.SETRANGE("Document No.", lrc_PurchHeader."No.");
                                    lrc_PurchLine2.SETRANGE("POI Subtyp", lrc_PurchLine2."POI Subtyp"::"Refund Empties");
                                    lrc_PurchLine2.SETRANGE("Attached to Line No.", lrc_PurchLine."Line No.");
                                    IF lrc_PurchLine2.FINDLAST() THEN
                                        lin_LineNo := lrc_PurchLine2."Line No." + 10
                                    ELSE
                                        lin_LineNo := lrc_PurchLine."Line No." + 100;

                                    // Neue Zeile anlegen
                                    lrc_PurchLine2.RESET();
                                    lrc_PurchLine2.INIT();
                                    lrc_PurchLine2."Document Type" := lrc_PurchLine."Document Type";
                                    lrc_PurchLine2."Document No." := lrc_PurchLine."Document No.";
                                    lrc_PurchLine2."Line No." := lin_LineNo;
                                    lrc_PurchLine2.INSERT(TRUE);
                                    lrc_PurchLine2."Buy-from Vendor No." := lrc_PurchLine."Buy-from Vendor No.";
                                    lrc_PurchLine2.Type := lrc_PurchLine2.Type::Item;
                                    lrc_PurchLine2.VALIDATE("No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_PurchLine2."POI Subtyp" := lrc_PurchLine2."POI Subtyp"::"Refund Empties";
                                    lrc_PurchLine2."Attached to Line No." := lrc_PurchLine."Line No.";
                                    IF lrc_PurchLine2."Gen. Prod. Posting Group" <> '' THEN BEGIN
                                        lrc_GenProductPostingGroup.GET(lrc_PurchLine2."Gen. Prod. Posting Group");
                                        IF lrc_GenProductPostingGroup."POI Prod.Post.Grp. Empt. Item" <> '' THEN
                                            lrc_PurchLine2.VALIDATE("Gen. Prod. Posting Group", lrc_GenProductPostingGroup."POI Prod.Post.Grp. Empt. Item");
                                    END;
                                    lrc_PurchLine2.MODIFY(TRUE);
                                    //RS zurückschreiben der Leergutzeilennr. in die Artikelzeile
                                    lrc_PurchLine."POI Empties Attached Line No" := lrc_PurchLine2."Line No.";
                                    lrc_PurchLine.MODIFY(TRUE);
                                END;

                                // Zeile aktualisieren
                                lrc_PurchLine2."Location Code" := lrc_PurchLine."Location Code";

                                //RS Menge nicht Quantity * Empties Quantity
                                /*******************************
                                lrc_PurchLine2.VALIDATE(Quantity,(lrc_PurchLine.Quantity *
                                                                  lrc_PurchLine."POI Empties Quantity" *
                                                                  ldc_BOMQuantity[lin_ArrayCounter]));
                                ********************************/
                                lrc_PurchLine2.VALIDATE(Quantity, (lrc_PurchLine."POI Empties Quantity" *
                                                                  ldc_BOMQuantity[lin_ArrayCounter]));
                                //RS.e
                                lrc_PurchLine2.VALIDATE("POI Price Base (Purch. Price)", '');
                                IF lrc_Item2.GET(lrc_PurchLine2."No.") THEN
                                    IF lrc_Item2."POI Price Base (Purch. Price)" <> '' THEN BEGIN
                                        lrc_PriceCalculation.RESET();
                                        lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
                                                                      lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
                                        lrc_PriceCalculation.SETRANGE(Code, lrc_Item2."POI Price Base (Purch. Price)");
                                        IF lrc_PriceCalculation.findfirst() THEN
                                            IF lrc_PriceCalculation."Internal Calc. Type" =
                                               lrc_PriceCalculation."Internal Calc. Type"::"Base Unit" THEN
                                                lrc_PurchLine2.VALIDATE("POI Price Base (Purch. Price)", lrc_Item2."POI Price Base (Purch. Price)");
                                    END;

                                IF lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping With Invoice" THEN BEGIN
                                    lrc_PurchLine2.VALIDATE("POI Purch. Price (Price Base)", ldc_UnitPrice);
                                    lrc_PurchLine2.ADF_CalcMarketUnitPrice();
                                END ELSE
                                    lrc_PurchLine2.VALIDATE("POI Purch. Price (Price Base)", 0);

                                lrc_PurchLine2.VALIDATE("Qty. to Receive", (lrc_PurchLine."POI Empties Quantity" *
                                                        ldc_BOMQuantity[lin_ArrayCounter]));
                                lrc_PurchLine2.VALIDATE("Qty. to Invoice", (lrc_PurchLine."POI Empties Quantity" *
                                                        ldc_BOMQuantity[lin_ArrayCounter]));

                                lrc_PurchLine2.VALIDATE("Shortcut Dimension 1 Code", lrc_PurchLine."Shortcut Dimension 1 Code");
                                lrc_PurchLine2.VALIDATE("Shortcut Dimension 2 Code", lrc_PurchLine."Shortcut Dimension 2 Code");
                                lrc_PurchLine2.VALIDATE("POI Shortcut Dimension 3 Code", lrc_PurchLine."POI Shortcut Dimension 3 Code");
                                lrc_PurchLine2.VALIDATE("POI Shortcut Dimension 4 Code", lrc_PurchLine."POI Shortcut Dimension 4 Code");
                                lrc_PurchLine2."Allow Invoice Disc." := FALSE;
                                lrc_PurchLine2.VALIDATE("Gen. Bus. Posting Group", lrc_PurchLine."Gen. Bus. Posting Group");
                                lrc_PurchLine2.VALIDATE("VAT Bus. Posting Group", lrc_PurchLine."VAT Bus. Posting Group");
                                lrc_PurchLine2.MODIFY(TRUE);

                            END;
                        END;

                        lin_ArrayCounter := lin_ArrayCounter + 1;
                    UNTIL lin_ArrayCounter > 10;
                END;

            UNTIL lrc_PurchLine.next() = 0;
        END;

    end;

    procedure PurchDeleteEmptiesItemLines(vrc_PurchaseLine: Record "Purchase Line")
    begin
        // ---------------------------------------------------------------------------------
        // Leergut Zeilen zu einer Artikelzeile löschen
        // ---------------------------------------------------------------------------------

        IF vrc_PurchaseLine."Line No." = 0 THEN
            EXIT;

        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseLine."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseLine."Document No.");
        lrc_PurchaseLine.SETRANGE("Attached to Line No.", vrc_PurchaseLine."Line No.");
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
        lrc_PurchaseLine.SETRANGE("POI Subtyp", lrc_PurchaseLine."POI Subtyp"::"Refund Empties");
        IF lrc_PurchaseLine.FINDSET(TRUE, FALSE) THEN
            REPEAT
                IF (lrc_PurchaseLine."Quantity Received" = 0) AND
                   (lrc_PurchaseLine."Quantity Invoiced" = 0) THEN
                    IF lrc_PurchaseLine."Receipt No." = '' THEN
                        lrc_PurchaseLine.DELETE(TRUE);
            UNTIL lrc_PurchaseLine.NEXT() = 0;
    end;

    procedure PurchGetEmptiesItemData(rco_ItemNo: Code[20]; rco_UnitOfMeasureCode: Code[10]; var vrc_EmptiesItemNo: Code[20]; var vdc_EmptiesItemQuantity: Decimal)
    var
        //lrc_EmptyItem: Record Item;
        lrc_UnitOfMeasure: Record "Unit of Measure";
    begin
        // --------------------------------------------------------------------------------------
        // Leergutartikel aus Pos.-Var., Artikeleinheit, Artikel oder Einheit lesen
        // --------------------------------------------------------------------------------------
        IF rco_ItemNo = '' THEN
            EXIT;

        // Artikel
        lrc_Item.GET(rco_ItemNo);

        vrc_EmptiesItemNo := lrc_Item."POI Empties Item No.";
        IF lrc_Item."POI Empties Posting Item No." <> '' THEN
            vrc_EmptiesItemNo := lrc_Item."POI Empties Posting Item No.";
        vdc_EmptiesItemQuantity := lrc_Item."POI Empties Quantity";

        IF rco_UnitOfMeasureCode <> '' THEN BEGIN
            lrc_UnitOfMeasure.GET(rco_UnitOfMeasureCode);

            // Artikeleinheit
            lrc_ItemUnitofMeasure.RESET();
            lrc_ItemUnitofMeasure.SETRANGE("Item No.", rco_ItemNo);
            lrc_ItemUnitofMeasure.SETRANGE(Code, rco_UnitOfMeasureCode);
            IF lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
                IF lrc_ItemUnitofMeasure."POI Empties Item No." <> '' THEN BEGIN
                    vrc_EmptiesItemNo := lrc_ItemUnitofMeasure."POI Empties Item No.";
                    IF lrc_ItemUnitofMeasure."POI Empties Quantity" > 0 THEN
                        vdc_EmptiesItemQuantity := lrc_ItemUnitofMeasure."POI Empties Quantity";
                END ELSE
                    // Einheit
                    IF lrc_UnitOfMeasure."POI Empties Item No." <> '' THEN BEGIN
                        vrc_EmptiesItemNo := lrc_UnitOfMeasure."POI Empties Item No.";
                        IF lrc_UnitOfMeasure."POI Qty. Empties Items" > 0 THEN
                            vdc_EmptiesItemQuantity := lrc_UnitOfMeasure."POI Qty. Empties Items";
                    END;
            END ELSE
                // Einheit
                IF lrc_UnitOfMeasure."POI Empties Item No." <> '' THEN BEGIN
                    vrc_EmptiesItemNo := lrc_UnitOfMeasure."POI Empties Item No.";
                    IF lrc_UnitOfMeasure."POI Qty. Empties Items" > 0 THEN
                        vdc_EmptiesItemQuantity := lrc_UnitOfMeasure."POI Qty. Empties Items";
                END;
        END;

    end;

    procedure DeleteEmptiesItemSalesLines(vrc_SalesLine: Record "Sales Line")
    begin
        // -------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------

        IF vrc_SalesLine."Line No." = 0 THEN
            EXIT;

        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", vrc_SalesLine."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", vrc_SalesLine."Document No.");
        lrc_SalesLine.SETRANGE("Attached to Line No.", vrc_SalesLine."Line No.");
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETRANGE("POI Subtyp", lrc_SalesLine."POI Subtyp"::"Refund Empties");
        IF lrc_SalesLine.FINDSET(TRUE, FALSE) THEN
            REPEAT
                IF (lrc_SalesLine."Quantity Shipped" = 0) AND
                     (lrc_SalesLine."Quantity Invoiced" = 0) THEN
                    IF lrc_SalesLine."Shipment No." = '' THEN
                        lrc_SalesLine.DELETE(TRUE);
            UNTIL lrc_SalesLine.NEXT() = 0;

    end;

    procedure SalesGetEmptiesItemData(rco_ItemNo: Code[20]; rco_UnitOfMeasureCode: Code[10]; rco_BatchVarNo: Code[20]; var vrc_EmptiesItemNo: Code[20]; var vdc_EmptiesItemQuantity: Decimal)
    var
        //lrc_BatchVariant: Record "POI Batch Variant";
        //lrc_EmptyItem: Record Item;
        lrc_UnitOfMeasure: Record "Unit of Measure";
    begin
        // --------------------------------------------------------------------------------------
        // Leergutartikel aus Pos.-Var., Artikeleinheit, Artikel oder Einheit lesen
        // --------------------------------------------------------------------------------------

        IF rco_ItemNo = '' THEN
            EXIT;

        // Artikel
        lrc_Item.GET(rco_ItemNo);

        vrc_EmptiesItemNo := lrc_Item."POI Empties Item No.";
        IF lrc_Item."POI Empties Posting Item No." <> '' THEN
            vrc_EmptiesItemNo := lrc_Item."POI Empties Posting Item No.";
        vdc_EmptiesItemQuantity := lrc_Item."POI Empties Quantity";

        IF rco_UnitOfMeasureCode <> '' THEN BEGIN
            lrc_UnitOfMeasure.GET(rco_UnitOfMeasureCode);

            // Artikeleinheit
            lrc_ItemUnitofMeasure.RESET();
            lrc_ItemUnitofMeasure.SETRANGE("Item No.", rco_ItemNo);
            lrc_ItemUnitofMeasure.SETRANGE(Code, rco_UnitOfMeasureCode);
            IF lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
                IF lrc_ItemUnitofMeasure."POI Empties Item No." <> '' THEN BEGIN
                    vrc_EmptiesItemNo := lrc_ItemUnitofMeasure."POI Empties Item No.";
                    IF lrc_ItemUnitofMeasure."POI Empties Quantity" > 0 THEN
                        vdc_EmptiesItemQuantity := lrc_ItemUnitofMeasure."POI Empties Quantity";
                END ELSE
                    // Einheit
                    IF lrc_UnitOfMeasure."POI Empties Item No." <> '' THEN BEGIN
                        vrc_EmptiesItemNo := lrc_UnitOfMeasure."POI Empties Item No.";
                        IF lrc_UnitOfMeasure."POI Qty. Empties Items" > 0 THEN
                            vdc_EmptiesItemQuantity := lrc_UnitOfMeasure."POI Qty. Empties Items";
                    END;
            END ELSE
                // Einheit
                IF lrc_UnitOfMeasure."POI Empties Item No." <> '' THEN BEGIN
                    vrc_EmptiesItemNo := lrc_UnitOfMeasure."POI Empties Item No.";
                    IF lrc_UnitOfMeasure."POI Qty. Empties Items" > 0 THEN
                        vdc_EmptiesItemQuantity := lrc_UnitOfMeasure."POI Qty. Empties Items";
                END;
        END;

    end;

    procedure EmptiesItemSalesLines(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vin_LineNo: Integer)
    var
    // lrc_FruitVisionSetup: Record "POI ADF Setup";
    // lrc_SalesHeader: Record "Sales Header";
    // lrc_SalesLine: Record "Sales Line";
    // lrc_SalesLine2: Record "Sales Line";
    // lrc_SalesLine3: Record "Sales Line";
    // lrc_Item2: Record Item;
    // lrc_PriceCalculation: Record "POI Price Base";
    // ldc_UnitPrice: Decimal;
    // ldc_ReducedUnitPrice: Decimal;
    // lrc_Item: Record Item;
    // lrc_BOMComponent: Record "BOM Component";
    // lco_ItemArray: array[100] of Code[20];
    // ldc_BOMQuantity: array[100] of Decimal;
    // ldc_PossibleFullPriceQuantity: array[100] of Decimal;
    // ldc_PossibleFullPriceQtyShip: array[100] of Decimal;
    // ldc_PossibleFullPriceQtyInv: array[100] of Decimal;
    // lin_ArrayCounter: Integer;
    // ldc_ReducedPriceQuantity: Decimal;
    // lrc_RefundCosts: Record "POI Empties/Transport Ref Cost";
    // lbn_LineAvailable: Boolean;
    // lin_LineNo: Integer;
    // lin_LineCreated: Integer;
    // lrc_QuantityForSameItem: Decimal;
    // ldc_SaveQuantityToInvoice: Decimal;
    // lbn_PriceFound: Boolean;
    // lrc_GenProductPostingGroup: Record "Gen. Product Posting Group";
    // lop_EmptiesAllocation: Option "Without Stock-Keeping Without Invoice","With Stock-Keeping Without Invoice","With Stock-Keeping With Invoice";
    // lrc_Customer: Record Customer;
    // lrc_CompanyChain: Record "POI Company Chain";
    // ldt_Date: Date;
    // SSPText01Txt: Label 'Multiple Levels aren''t supported at empties !';
    begin
        // -------------------------------------------------------------------------------------
        // Funktionen zur Erstellung / Aktualisierung der Leergutartikelzeilen Verkauf
        // -------------------------------------------------------------------------------------
        /**************** RS - über Funktion SalesAttachEmptiestoSalesLines gelöst
        lrc_FruitVisionSetup.GET();
        IF lrc_SalesHeader.GET(vop_DocType,vco_DocNo) THEN;
        
        IF lrc_FruitVisionSetup."Empties/Transport Type" = lrc_FruitVisionSetup."Empties/Transport Type"::"Systematik 2" THEN BEGIN
          IF (lrc_SalesHeader."Sales Doc. Subtype Code" <> '') AND
             ((lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::Invoice) AND
              (lrc_SalesHeader."Sales Doc. Subtype Code" = lrc_FruitVisionSetup."SalesInv Empties Doc. Typ Code")) OR
             ((lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") AND
              (lrc_SalesHeader."Sales Doc. Subtype Code" = lrc_FruitVisionSetup."SalesCrM Empties Doc. Typ Code")) THEN BEGIN
          END ELSE BEGIN
            EXIT;
          END;
        END;
        
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
        IF vin_LineNo <> 0 THEN
          lrc_SalesLine.SETRANGE("Line No.", vin_LineNo);
        lrc_SalesLine.SETRANGE(Subtyp, lrc_SalesLine."POI Subtyp"::" ");
        IF lrc_SalesLine.FINDSET(TRUE,FALSE) THEN BEGIN
        
          lrc_Customer.GET(lrc_SalesHeader."Sell-to Customer No.");
          IF (NOT lrc_CompanyChain.GET(lrc_Customer."Chain Name")) OR
             (lrc_Customer."Chain Name" = '') THEN BEGIN
            lop_EmptiesAllocation := lrc_Customer."POI Empties Allocation";
          END ELSE BEGIN
            IF lrc_Customer."Activ Empties Definition" = lrc_Customer."Activ Empties Definition"::Customer THEN BEGIN
              lop_EmptiesAllocation := lrc_Customer."POI Empties Allocation";
            END ELSE BEGIN
              lop_EmptiesAllocation := lrc_CompanyChain."Empties Allocation";
            END;
          END;
        
          REPEAT
        
            // Menge Leergut gemäß Stammdaten setzen - Hilfslösung
            IF lrc_SalesLine."POI Empties Item No." <> '' THEN BEGIN
              IF lrc_Item.GET(lrc_SalesLine."POI Empties Item No.") THEN BEGIN
                lrc_SalesLine."Empties Quantity" := lrc_Item."Empties Quantity";
                lrc_SalesLine.MODIFY();
              END;
            END;
        
            // Keine Leergut
            IF (lrc_SalesLine."POI Empties Item No." = '') OR
               (lrc_SalesLine."Empties Quantity" = 0) OR
               (lrc_SalesLine.Quantity = 0) THEN BEGIN
        
              DeleteEmptiesItemSalesLines(lrc_SalesLine);
        
            // Leergut
            END ELSE BEGIN
        
              DeleteEmptiesItemSalesLines(lrc_SalesLine);
        
              lrc_Item.GET(lrc_SalesLine."POI Empties Item No.");
        
               CLEAR(lco_ItemArray);
               CLEAR(ldc_BOMQuantity);
               CLEAR(ldc_PossibleFullPriceQuantity);
               CLEAR(ldc_PossibleFullPriceQtyShip);
               CLEAR(ldc_PossibleFullPriceQtyInv);
        
               lrc_Item.CALCFIELDS("Bill of Materials");
               IF lrc_Item."Bill of Materials" = TRUE THEN BEGIN
                  lrc_BOMComponent.RESET();
                  lrc_BOMComponent.SETRANGE("Parent Item No.", lrc_SalesLine."POI Empties Item No.");
                  lrc_BOMComponent.SETRANGE( Type, lrc_BOMComponent.Type::Item);
                  lrc_BOMComponent.SETFILTER("No.", '<>%1', '');
                  IF lrc_BOMComponent.FIND('-') THEN BEGIN
                     lin_ArrayCounter := 1;
                     REPEAT
                       lrc_BOMComponent.CALCFIELDS("Bill of Materials");
                       IF lrc_BOMComponent."Bill of Materials" = TRUE THEN BEGIN
                          ERROR( SSPText01Txt, lrc_BOMComponent."No.", lrc_BOMComponent."Parent Item No.");
                       END;
                       lco_ItemArray[lin_ArrayCounter] := lrc_BOMComponent."No.";
                       ldc_BOMQuantity[lin_ArrayCounter] := lrc_BOMComponent."Quantity per";
                       ldc_PossibleFullPriceQuantity[lin_ArrayCounter] :=
                          CalcQuantity(lrc_SalesLine.Quantity, lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]);
                       ldc_PossibleFullPriceQtyShip[lin_ArrayCounter] :=
                          CalcQuantity(lrc_SalesLine."Qty. to Ship", lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]);
                       ldc_PossibleFullPriceQtyInv[lin_ArrayCounter] :=
                          CalcQuantity(lrc_SalesLine."Qty. to Invoice", lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]);
        
                       lin_ArrayCounter := lin_ArrayCounter + 1;
        
                     UNTIL lrc_BOMComponent.NEXT() = 0;
                  END ELSE BEGIN
                     lco_ItemArray[1] := lrc_SalesLine."POI Empties Item No.";
                     ldc_BOMQuantity[1] := 1;
                  END;
        
               END ELSE BEGIN
                  lco_ItemArray[1] := lrc_SalesLine."POI Empties Item No.";
                  ldc_BOMQuantity[1] := 1;
                  ldc_PossibleFullPriceQuantity[1] :=
                     CalcQuantity(lrc_SalesLine.Quantity, lrc_SalesLine, ldc_BOMQuantity[1]);
                  ldc_PossibleFullPriceQtyShip[1] :=
                     CalcQuantity(lrc_SalesLine."Qty. to Ship", lrc_SalesLine, ldc_BOMQuantity[1]);
                  ldc_PossibleFullPriceQtyInv[1] :=
                     CalcQuantity(lrc_SalesLine."Qty. to Invoice", lrc_SalesLine, ldc_BOMQuantity[1]);
               END;
        
               IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                  (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN BEGIN
                  lin_ArrayCounter := 1;
                 REPEAT
                    IF lco_ItemArray[lin_ArrayCounter] <> '' THEN BEGIN
                       lrc_Customer.GET(lrc_SalesLine."Sell-to Customer No.");
                       IF lrc_Customer."Observe Reduced Refund Costs" = TRUE THEN BEGIN
        
                           lrc_Item.GET(lco_ItemArray[lin_ArrayCounter]);
                           // lrc_Item.SETFILTER("Location Filter", '%1', vco_LocationFilter);
                           lrc_Item.SETRANGE("Location Filter");
                           lrc_Item.SETFILTER("Source Type Filter", '%1', lrc_Item."Source Type Filter"::Customer);
                           lrc_Item.SETFILTER("Source No. Filter", '%1', lrc_SalesLine."Sell-to Customer No.");
                           lrc_Item.SETRANGE("Date Filter");
                           lrc_Item.CALCFIELDS("Empties Shipment Sale (Qty.)", "Empties Receipt Sale (Qty.)");
        
                           lrc_QuantityForSameItem := 0;
                           // existiert dieser Artikel bereits im gleichen Beleg,
                           // gelten die Mengen auch schon als zurückgenommen
                           lrc_SalesLine2.RESET();
                           lrc_SalesLine2.SETRANGE("Document Type", lrc_SalesLine."Document Type");
                           lrc_SalesLine2.SETRANGE("Document No.", lrc_SalesLine."Document No.");
                           lrc_SalesLine2.SETRANGE(lrc_SalesLine2.Type, lrc_SalesLine2.Type::Item);
                           lrc_SalesLine2.SETRANGE("No.", lco_ItemArray[lin_ArrayCounter]);
                           IF lrc_SalesLine."Line No." > 1 THEN BEGIN
                              lrc_SalesLine2.SETFILTER("Line No.", '..%1', lrc_SalesLine."Line No." - 1);
                           END;
                           IF lrc_SalesLine2.FIND('-') THEN BEGIN
                              REPEAT
                                 lrc_QuantityForSameItem := lrc_QuantityForSameItem + lrc_SalesLine2."Outstanding Qty. (Base)";
                              UNTIL lrc_SalesLine2.NEXT() = 0;
                              lrc_Item."Empties Receipt Sale (Qty.)" := lrc_Item."Empties Receipt Sale (Qty.)" + lrc_QuantityForSameItem;
                           END;
        
                           IF lrc_Item."Empties Shipment Sale (Qty.)" - lrc_Item."Empties Receipt Sale (Qty.)" > 0 THEN BEGIN
                              IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <=
                                 (lrc_Item."Empties Shipment Sale (Qty.)" - lrc_Item."Empties Receipt Sale (Qty.)") THEN BEGIN
                              END ELSE BEGIN
                                 ldc_PossibleFullPriceQuantity[lin_ArrayCounter] :=
                                    lrc_Item."Empties Shipment Sale (Qty.)" - lrc_Item."Empties Receipt Sale (Qty.)";
                                  // diese Werte müssen manuell gesetzt werden
                                  ldc_PossibleFullPriceQtyShip[lin_ArrayCounter] := 0;
                                  ldc_PossibleFullPriceQtyInv[lin_ArrayCounter] := 0;
                              END;
                           END ELSE BEGIN
                              ldc_PossibleFullPriceQuantity[lin_ArrayCounter] := 0;
                              ldc_PossibleFullPriceQtyShip[lin_ArrayCounter] := 0;
                              ldc_PossibleFullPriceQtyInv[lin_ArrayCounter] := 0;
                           END;
                       END;
                     END;
        
                    lin_ArrayCounter := lin_ArrayCounter + 1;
                 UNTIL lin_ArrayCounter > 100;
               END;
        
               // LVW 013 SCH40046.s
               ldt_Date := lrc_SalesHeader."Order Date";
               IF ldt_Date = 0D THEN BEGIN
                 ldt_Date := lrc_SalesHeader."Document Date"
               END;
               // LVW 013 SCH40046.e
        
               lin_ArrayCounter := 1;
               REPEAT
                 IF lco_ItemArray[lin_ArrayCounter] <> '' THEN BEGIN
                     ldc_UnitPrice := 0;
                     ldc_ReducedUnitPrice := 0;
                     ldc_ReducedPriceQuantity := 0;
        
                     lrc_Customer.GET(lrc_SalesLine."Sell-to Customer No.");
                     IF NOT lrc_CompanyChain.GET(lrc_Customer."Chain Name") THEN
                       lrc_CompanyChain.INIT();
        
                  lbn_PriceFound := FALSE;
                     IF lbn_PriceFound = FALSE THEN BEGIN
                        // Price Customer
                        lrc_RefundCosts.RESET();
                        lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Customer);
                        lrc_RefundCosts.SETRANGE("Source No.", lrc_SalesLine."Sell-to Customer No.");
                        lrc_RefundCosts.SETFILTER("Starting Date",'%1..%2',0D, ldt_Date);
                        lrc_RefundCosts.SETFILTER("Ending Date",'%1|>=%2',0D, ldt_Date);
                        IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                           IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                              (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN BEGIN
                              IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                 CalcQuantity(lrc_SalesLine.Quantity, lrc_SalesLine,
                                    ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                 ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                 lbn_PriceFound := TRUE;
                              END ELSE BEGIN
                                 IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                    ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                    lbn_PriceFound := TRUE;
                                 END;
                                 IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                     CalcQuantity(lrc_SalesLine.Quantity, lrc_SalesLine,
                                       ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                    ldc_ReducedPriceQuantity :=
                                       CalcQuantity(lrc_SalesLine.Quantity, lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) -
                                       ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                    IF ldc_ReducedPriceQuantity > 0 THEN BEGIN
                                       IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN BEGIN
                                          ldc_ReducedUnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                       END ELSE BEGIN
                                          ldc_ReducedUnitPrice := lrc_RefundCosts."Reduced Receipt Price (LCY)";
                                       END;
                                    END;
                                    lbn_PriceFound := TRUE;
                                 END;
                              END;
                           END ELSE BEGIN
                              ldc_UnitPrice := lrc_RefundCosts."Shipment Price (LCY)";
                              lbn_PriceFound := TRUE;
                           END;
                        END;
                     END;
        
                     IF lbn_PriceFound = FALSE THEN BEGIN
                        // Price "Company Chain" Customer
                        IF lrc_Customer."Chain Name" <> '' THEN BEGIN
                           lrc_RefundCosts.RESET();
                           lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                           lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                           lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain.Code);
                           lrc_RefundCosts.SETFILTER("Starting Date",'%1..%2',0D, ldt_Date);
                           lrc_RefundCosts.SETFILTER("Ending Date",'%1|>=%2',0D, ldt_Date);
                           IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                              IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                                 (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN BEGIN
                                 IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                    CalcQuantity(lrc_SalesLine.Quantity, lrc_SalesLine,
                                       ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                    ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                    lbn_PriceFound := TRUE;
                                 END ELSE BEGIN
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                       ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                       lbn_PriceFound := TRUE;
                                    END;
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                        CalcQuantity(lrc_SalesLine.Quantity, lrc_SalesLine,
                                          ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                       ldc_ReducedPriceQuantity :=
                                         CalcQuantity(lrc_SalesLine.Quantity, lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter])
        -
                                          ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                       IF ldc_ReducedPriceQuantity > 0 THEN BEGIN
                                          IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN BEGIN
                                             ldc_ReducedUnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                          END ELSE BEGIN
                                             ldc_ReducedUnitPrice := lrc_RefundCosts."Reduced Receipt Price (LCY)";
                                          END;
                                       END;
                                       lbn_PriceFound := TRUE;
                                    END;
                                 END;
                              END ELSE BEGIN
                                 ldc_UnitPrice := lrc_RefundCosts."Shipment Price (LCY)";
                                 lbn_PriceFound := TRUE;
                              END;
                           END;
                        END;
                     END;
        
                     IF lbn_PriceFound = FALSE THEN BEGIN
                        // Price "Empties Price Group" Customer
                        IF lrc_Customer."Empties Price Group" <> '' THEN BEGIN
                           lrc_RefundCosts.RESET();
                           lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                           lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                           lrc_RefundCosts.SETRANGE("Source No.", lrc_Customer."Empties Price Group");
                           lrc_RefundCosts.SETFILTER("Starting Date",'%1..%2',0D, ldt_Date);
                           lrc_RefundCosts.SETFILTER("Ending Date",'%1|>=%2',0D,ldt_Date);
                           IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                              IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                                 (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN BEGIN
                                 IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                    CalcQuantity(lrc_SalesLine.Quantity,
                                      lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                    ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                    lbn_PriceFound := TRUE;
                                 END ELSE BEGIN
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                       ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                       lbn_PriceFound := TRUE;
                                    END;
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                       CalcQuantity(lrc_SalesLine.Quantity,
                                         lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                       ldc_ReducedPriceQuantity :=
                                          CalcQuantity(lrc_SalesLine.Quantity,
                                            lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) -
                                          ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                       IF ldc_ReducedPriceQuantity > 0 THEN BEGIN
                                          IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN BEGIN
                                             ldc_ReducedUnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                          END ELSE BEGIN
                                             ldc_ReducedUnitPrice := lrc_RefundCosts."Reduced Receipt Price (LCY)";
                                          END;
                                       END;
                                       lbn_PriceFound := TRUE;
                                    END;
                                 END;
                              END ELSE BEGIN
                                 ldc_UnitPrice := lrc_RefundCosts."Shipment Price (LCY)";
                                 lbn_PriceFound := TRUE;
                              END;
                           END;
                        END;
                     END;
        
                     IF lbn_PriceFound = FALSE THEN BEGIN
                        // Price "Empties Price Group" "Company Chain"
                        IF lrc_Customer."Chain Name" <> '' THEN BEGIN
                           IF lrc_CompanyChain."Empties Price Group" <> '' THEN BEGIN
                              lrc_RefundCosts.RESET();
                              lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                              lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                              lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain."Empties Price Group");
                              lrc_RefundCosts.SETFILTER("Starting Date",'%1..%2',0D, ldt_Date);
                              lrc_RefundCosts.SETFILTER("Ending Date",'%1|>=%2',0D, ldt_Date);
                              IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                 IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                                    (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN BEGIN
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                       CalcQuantity(lrc_SalesLine.Quantity,
                                         lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                       ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                       lbn_PriceFound := TRUE;
                                    END ELSE BEGIN
                                       IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                          ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                          lbn_PriceFound := TRUE;
                                       END;
                                       IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                          CalcQuantity(lrc_SalesLine.Quantity,
                                            lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                          ldc_ReducedPriceQuantity :=
                                             CalcQuantity(lrc_SalesLine.Quantity,
                                               lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) -
                                             ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                          IF ldc_ReducedPriceQuantity > 0 THEN BEGIN
                                             IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN BEGIN
                                                ldc_ReducedUnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                             END ELSE BEGIN
                                                ldc_ReducedUnitPrice := lrc_RefundCosts."Reduced Receipt Price (LCY)";
                                             END;
                                          END;
                                          lbn_PriceFound := TRUE;
                                       END;
                                    END;
                                 END ELSE BEGIN
                                    ldc_UnitPrice := lrc_RefundCosts."Shipment Price (LCY)";
                                    lbn_PriceFound := TRUE;
                                 END;
                              END;
                           END;
                        END;
                     END;
        
                     IF lbn_PriceFound = FALSE THEN BEGIN
                        // all Customer
                        lrc_RefundCosts.RESET();
                        lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Customer);
                        lrc_RefundCosts.SETRANGE("Source No.", '');
                        lrc_RefundCosts.SETFILTER("Starting Date",'%1..%2',0D, ldt_Date);
                        lrc_RefundCosts.SETFILTER("Ending Date",'%1|>=%2',0D, ldt_Date);
                        IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                           IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                              (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN BEGIN
                              IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                 CalcQuantity(lrc_SalesLine.Quantity,
                                   lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                 ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                 lbn_PriceFound := TRUE;
                              END ELSE BEGIN
                                 IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                    ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                    lbn_PriceFound := TRUE;
                                 END;
                                 IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                    CalcQuantity(lrc_SalesLine.Quantity,
                                      lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                    ldc_ReducedPriceQuantity :=
                                       CalcQuantity(lrc_SalesLine.Quantity,
                                         lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) -
                                       ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                    IF ldc_ReducedPriceQuantity > 0 THEN BEGIN
                                       IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN BEGIN
                                          ldc_ReducedUnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                       END ELSE BEGIN
                                          ldc_ReducedUnitPrice := lrc_RefundCosts."Reduced Receipt Price (LCY)";
                                       END;
                                    END;
                                    lbn_PriceFound := TRUE;
                                 END;
                              END;
                           END ELSE BEGIN
                              ldc_UnitPrice := lrc_RefundCosts."Shipment Price (LCY)";
                              lbn_PriceFound := TRUE;
                           END;
                        END;
                     END;
        
        
                     IF lbn_PriceFound = FALSE THEN BEGIN
                        // Price all "Company Chain"
                        IF lrc_Customer."Chain Name" <> '' THEN BEGIN
                           lrc_RefundCosts.RESET();
                           lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                           lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                           lrc_RefundCosts.SETRANGE("Source No.", '');
                           lrc_RefundCosts.SETFILTER("Starting Date",'%1..%2',0D, ldt_Date);
                           lrc_RefundCosts.SETFILTER("Ending Date",'%1|>=%2',0D, ldt_Date);
                           IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                              IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                                 (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN BEGIN
                                 IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                    CalcQuantity(lrc_SalesLine.Quantity,
                                      lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                    ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                    lbn_PriceFound := TRUE;
                                 END ELSE BEGIN
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                       ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                       lbn_PriceFound := TRUE;
                                    END;
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                       CalcQuantity(lrc_SalesLine.Quantity,
                                         lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                       ldc_ReducedPriceQuantity :=
                                          CalcQuantity(lrc_SalesLine.Quantity,
                                            lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) -
                                          ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                       IF ldc_ReducedPriceQuantity > 0 THEN BEGIN
                                          IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN BEGIN
                                             ldc_ReducedUnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                          END ELSE BEGIN
                                             ldc_ReducedUnitPrice := lrc_RefundCosts."Reduced Receipt Price (LCY)";
                                          END;
                                       END;
                                       lbn_PriceFound := TRUE;
                                    END;
                                 END;
                              END ELSE BEGIN
                                 ldc_UnitPrice := lrc_RefundCosts."Shipment Price (LCY)";
                                 lbn_PriceFound := TRUE;
                              END;
                           END;
                        END;
                     END;
        
                     IF lbn_PriceFound = FALSE THEN BEGIN
                        // Price Global
                        lrc_RefundCosts.RESET();
                        lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Sales Global");
                        lrc_RefundCosts.SETRANGE("Source No.", '');
                        lrc_RefundCosts.SETFILTER("Starting Date",'%1..%2',0D, ldt_Date);
                        lrc_RefundCosts.SETFILTER("Ending Date",'%1|>=%2',0D, ldt_Date);
                        IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                           IF (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                              (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order") THEN BEGIN
                              IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                 CalcQuantity(lrc_SalesLine.Quantity,
                                   lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                 ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                 lbn_PriceFound := TRUE;
                              END ELSE BEGIN
                                 IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                     ldc_UnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                     lbn_PriceFound := TRUE;
                                  END;
                                  IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                     CalcQuantity(lrc_SalesLine.Quantity,
                                       lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                     ldc_ReducedPriceQuantity :=
                                        CalcQuantity(lrc_SalesLine.Quantity,
                                          lrc_SalesLine, ldc_BOMQuantity[lin_ArrayCounter]) -
                                        ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                     IF ldc_ReducedPriceQuantity > 0 THEN BEGIN
                                        IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN BEGIN
                                           ldc_ReducedUnitPrice := lrc_RefundCosts."Receipt Price (LCY)";
                                        END ELSE BEGIN
                                           ldc_ReducedUnitPrice := lrc_RefundCosts."Reduced Receipt Price (LCY)";
                                        END;
                                     END;
                                     lbn_PriceFound := TRUE;
                                  END;
                               END;
                            END ELSE BEGIN
                               ldc_UnitPrice := lrc_RefundCosts."Shipment Price (LCY)";
                               lbn_PriceFound := TRUE;
                            END;
                        END;
                     END;
        
        
                  lin_LineCreated := 0;
        
                     IF (lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping Without Invoice") OR
                        (lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping With Invoice") THEN BEGIN
        
                        IF (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <> 0) OR
                           (ldc_UnitPrice <> 0) THEN BEGIN
                           // Voller Annahmepreis
                           lbn_LineAvailable := FALSE;
                           lrc_SalesLine2.RESET();
                           lrc_SalesLine2.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
                           lrc_SalesLine2.SETRANGE("Document No.",lrc_SalesHeader."No.");
                           lrc_SalesLine2.SETRANGE(Type,lrc_SalesLine2.Type::Item);
                           lrc_SalesLine2.SETRANGE("No.", lco_ItemArray[lin_ArrayCounter]);
                           lrc_SalesLine2.SETRANGE(Subtyp,lrc_SalesLine2."POI Subtyp"::"Refund Empties");
                           lrc_SalesLine2.SETRANGE("Attached to Line No.",lrc_SalesLine."Line No.");
                           IF lrc_SalesLine2.findfirst() THEN BEGIN
                             lbn_LineAvailable := TRUE;
                           END ELSE BEGIN
                             lbn_LineAvailable := FALSE;
                           END;
        
                           // LVW 009 00000000.s
                           lrc_SalesLine3.RESET();
                           lrc_SalesLine3.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
                           lrc_SalesLine3.SETRANGE("Document No.",lrc_SalesHeader."No.");
                           lrc_SalesLine3.SETRANGE(Subtyp,lrc_SalesLine3."POI Subtyp"::"Refund Empties");
                           lrc_SalesLine3.SETRANGE("Attached to Line No.",lrc_SalesLine."Line No.");
                           IF lrc_SalesLine3.FINDLAST() THEN BEGIN
                              lin_LineNo := lrc_SalesLine3."Line No." + 50;
                           END ELSE BEGIN
                              lin_LineNo := lrc_SalesLine."Line No." + 100;
                           END;
                           // LVW 009 00000000.e
        
                           //xx
                           IF lbn_LineAvailable = FALSE THEN BEGIN
                             lrc_SalesLine2.RESET();
                             lrc_SalesLine2.INIT();
                             lrc_SalesLine2."Document Type" := lrc_SalesLine."Document Type";
                             lrc_SalesLine2."Document No." := lrc_SalesLine."Document No.";
                             lrc_SalesLine2."Line No." := lin_LineNo;
                             lrc_SalesLine2.INSERT(TRUE);
                             lrc_SalesLine2."Sell-to Customer No." := lrc_SalesLine."Sell-to Customer No.";
                             lrc_SalesLine2.Type := lrc_SalesLine2.Type::Item;
                             lrc_SalesLine2.VALIDATE("No.", lco_ItemArray[lin_ArrayCounter]);
                             lrc_SalesLine2."POI Subtyp" := lrc_SalesLine2."POI Subtyp"::"Refund Empties";
                             lrc_SalesLine2."Attached to Line No." := lrc_SalesLine."Line No.";
                             IF lrc_SalesLine2."Gen. Prod. Posting Group" <> '' THEN BEGIN
                                lrc_GenProductPostingGroup.GET(lrc_SalesLine2."Gen. Prod. Posting Group");
                                IF lrc_GenProductPostingGroup."Prod.Post.Grp. Empties Item" <> '' THEN BEGIN
                                   lrc_SalesLine2.VALIDATE("Gen. Prod. Posting Group",
                                      lrc_GenProductPostingGroup."Prod.Post.Grp. Empties Item");
                                END;
                             END;
                             lrc_SalesLine2.MODIFY(TRUE);
                           END;
        
                           lrc_SalesLine2."Location Code" := lrc_SalesLine."Location Code";
                           lrc_SalesLine2.VALIDATE(Quantity, ldc_PossibleFullPriceQuantity[lin_ArrayCounter]);
                           lrc_SalesLine2.VALIDATE("Qty. to Ship", ldc_PossibleFullPriceQtyShip[lin_ArrayCounter]);
                           lrc_SalesLine2.VALIDATE("Qty. to Invoice", ldc_PossibleFullPriceQtyInv[lin_ArrayCounter]);
        
                           lrc_SalesLine2.VALIDATE("POI Price Base (Sales Price)",'');
                           IF lrc_Item2.GET(lrc_SalesLine2."No.") THEN BEGIN
                             IF lrc_Item2."POI Price Base (Sales Price)" <> '' THEN BEGIN
                               lrc_PriceCalculation.RESET();
                               lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
                                                              lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price");
                               lrc_PriceCalculation.SETRANGE( Code, lrc_Item2."POI Price Base (Sales Price)");
                               IF lrc_PriceCalculation.findfirst() THEN BEGIN
                                 IF lrc_PriceCalculation."Internal Calc. Type" =
                                     lrc_PriceCalculation."Internal Calc. Type"::"Base Unit" THEN BEGIN
                                    lrc_SalesLine2.VALIDATE("POI Price Base (Sales Price)", lrc_Item2."POI Price Base (Sales Price)");
                                 END;
                               END;
                             END;
                           END;
        
                           // LVW 003 FV400020.s
                           IF lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping With Invoice" THEN BEGIN
                             lrc_SalesLine2.VALIDATE("Sales Price (Price Base)", ldc_UnitPrice );
                           END ELSE BEGIN
                             lrc_SalesLine2.VALIDATE("Sales Price (Price Base)", 0);
                           END;
                           // LVW 003 FV400020.e
                           lrc_SalesLine2.VALIDATE("Shortcut Dimension 1 Code",lrc_SalesLine."Shortcut Dimension 1 Code");
                           lrc_SalesLine2.VALIDATE("Shortcut Dimension 2 Code",lrc_SalesLine."Shortcut Dimension 2 Code");
                           lrc_SalesLine2.VALIDATE("Shortcut Dimension 3 Code",lrc_SalesLine."Shortcut Dimension 3 Code");
                           lrc_SalesLine2.VALIDATE("Shortcut Dimension 4 Code",lrc_SalesLine."Shortcut Dimension 4 Code");
                           lrc_SalesLine2."Allow Invoice Disc." := FALSE;
        
                           // LVW 012 IFW40120.s
                           lrc_SalesLine2.VALIDATE("Gen. Bus. Posting Group",lrc_SalesLine."Gen. Bus. Posting Group");
                           lrc_SalesLine2.VALIDATE("VAT Bus. Posting Group",lrc_SalesLine."VAT Bus. Posting Group");
                           // LVW 012 IFW40120.e
        
                           lrc_SalesLine2."POI Subtyp" := lrc_SalesLine2."POI Subtyp"::"Refund Empties";
                           lrc_SalesLine2.MODIFY(TRUE);
        
                           lin_LineCreated := lin_LineNo;
        
                        END;
        
                    IF ((lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Credit Memo") OR
                        (lrc_SalesHeader."Document Type" = lrc_SalesHeader."Document Type"::"Return Order")) AND
                        ((ldc_ReducedUnitPrice <> 0) OR (ldc_ReducedPriceQuantity <> 0)) THEN BEGIN
        
                           // reduzierter Annahmepreis
                           lbn_LineAvailable := FALSE;
                           lrc_SalesLine2.RESET();
                           lrc_SalesLine2.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
                           lrc_SalesLine2.SETRANGE("Document No.",lrc_SalesHeader."No.");
                           IF lin_LineCreated <> 0 THEN BEGIN
                             lrc_SalesLine2.SETFILTER("Line No.", '<>%1', lin_LineCreated );
                           END;
                           lrc_SalesLine2.SETRANGE(Type,lrc_SalesLine2.Type::Item);
                           lrc_SalesLine2.SETRANGE("No.", lco_ItemArray[lin_ArrayCounter]);
                      lrc_SalesLine2.SETRANGE(Subtyp,lrc_SalesLine2."POI Subtyp"::"Refund Empties");
                           lrc_SalesLine2.SETRANGE("Attached to Line No.",lrc_SalesLine."Line No.");
                           IF lrc_SalesLine2.FIND('-') THEN BEGIN
                             lbn_LineAvailable := TRUE;
                           END ELSE BEGIN
                             lbn_LineAvailable := FALSE;
                              END;
        
                           lrc_SalesLine2.RESET();
                           lrc_SalesLine2.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
                           lrc_SalesLine2.SETRANGE("Document No.",lrc_SalesHeader."No.");
                      lrc_SalesLine2.SETRANGE(Subtyp,lrc_SalesLine2."POI Subtyp"::"Refund Empties");
                           lrc_SalesLine2.SETRANGE("Attached to Line No.",lrc_SalesLine."Line No.");
                           IF lrc_SalesLine2.FIND('+') THEN BEGIN
                              lin_LineNo := lrc_SalesLine2."Line No." + 50;
                           END ELSE BEGIN
                              lin_LineNo := lrc_SalesLine."Line No." + 100;
                           END;
                           //yy
                           IF lbn_LineAvailable = FALSE THEN BEGIN
                             lrc_SalesLine2.RESET();
                             lrc_SalesLine2.INIT();
                             lrc_SalesLine2."Document Type" := lrc_SalesLine."Document Type";
                             lrc_SalesLine2."Document No." := lrc_SalesLine."Document No.";
                             lrc_SalesLine2."Line No." := lin_LineNo;
                             lrc_SalesLine2.INSERT(TRUE);
                             lrc_SalesLine2."Sell-to Customer No." := lrc_SalesLine."Sell-to Customer No.";
                             lrc_SalesLine2.Type := lrc_SalesLine2.Type::Item;
                             lrc_SalesLine2.VALIDATE("No.", lco_ItemArray[lin_ArrayCounter]);
                             lrc_SalesLine2."POI Subtyp" := lrc_SalesLine2."POI Subtyp"::"Refund Empties";
                             lrc_SalesLine2."Attached to Line No." := lrc_SalesLine."Line No.";
        
                             IF lrc_SalesLine2."Gen. Prod. Posting Group" <> '' THEN BEGIN
                               lrc_GenProductPostingGroup.GET(lrc_SalesLine2."Gen. Prod. Posting Group");
                               IF lrc_GenProductPostingGroup."Prod.Post.Grp. Empties Item" <> '' THEN BEGIN
                                 lrc_SalesLine2.VALIDATE("Gen. Prod. Posting Group",
                                    lrc_GenProductPostingGroup."Prod.Post.Grp. Empties Item");
                               END;
                             END;
        
                             lrc_SalesLine2.MODIFY( TRUE);
        
                           END;
        
                           lrc_SalesLine2."Location Code" := lrc_SalesLine."Location Code";
                           lrc_SalesLine2.VALIDATE(Quantity, ldc_ReducedPriceQuantity );
                           lrc_SalesLine2.VALIDATE("POI Price Base (Sales Price)",'');
                           IF lrc_Item2.GET(lrc_SalesLine2."No.") THEN BEGIN
                             IF lrc_Item2."POI Price Base (Sales Price)" <> '' THEN BEGIN
                               lrc_PriceCalculation.RESET();
                               lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
                                                              lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price");
                               lrc_PriceCalculation.SETRANGE( Code, lrc_Item2."POI Price Base (Sales Price)");
                               IF lrc_PriceCalculation.FIND('-') THEN BEGIN
                                 IF lrc_PriceCalculation."Internal Calc. Type" =
                                    lrc_PriceCalculation."Internal Calc. Type"::"Base Unit" THEN BEGIN
                                   lrc_SalesLine2.VALIDATE("POI Price Base (Sales Price)", lrc_Item2."POI Price Base (Sales Price)");
                                 END;
                               END;
                             END;
                           END;
        
                           IF lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping With Invoice" THEN BEGIN
                             lrc_SalesLine2.VALIDATE("Sales Price (Price Base)", ldc_ReducedUnitPrice );
                           END ELSE BEGIN
                             lrc_SalesLine2.VALIDATE("Sales Price (Price Base)", 0);
                           END;
        
                           lrc_SalesLine2.VALIDATE("Shortcut Dimension 1 Code",lrc_SalesLine."Shortcut Dimension 1 Code");
                           lrc_SalesLine2.VALIDATE("Shortcut Dimension 2 Code",lrc_SalesLine."Shortcut Dimension 2 Code");
                           lrc_SalesLine2.VALIDATE("Shortcut Dimension 3 Code",lrc_SalesLine."Shortcut Dimension 3 Code");
                           lrc_SalesLine2.VALIDATE("Shortcut Dimension 4 Code",lrc_SalesLine."Shortcut Dimension 4 Code");
                           lrc_SalesLine2."Allow Invoice Disc." := FALSE;
        
                           // LVW 012 IFW40120.s
                           lrc_SalesLine2.VALIDATE("Gen. Bus. Posting Group",lrc_SalesLine."Gen. Bus. Posting Group");
                           lrc_SalesLine2.VALIDATE("VAT Bus. Posting Group",lrc_SalesLine."VAT Bus. Posting Group");
                           // LVW 012 IFW40120.e
        
                           lrc_SalesLine2."POI Subtyp" := lrc_SalesLine2."POI Subtyp"::"Refund Empties";
                           lrc_SalesLine2.MODIFY(TRUE);
        
                        END;
        
                     END;
        
                 END;
        
                 lin_ArrayCounter := lin_ArrayCounter + 1;
               UNTIL lin_ArrayCounter > 100;
        
              IF (lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping Without Invoice") OR
                 (lop_EmptiesAllocation = lop_EmptiesAllocation::"With Stock-Keeping With Invoice") THEN BEGIN
                  ldc_SaveQuantityToInvoice := lrc_SalesLine."Qty. to Invoice";
                lrc_SalesLine.VALIDATE("Qty. to Ship");
                lrc_SalesLine.VALIDATE("Qty. to Invoice", ldc_SaveQuantityToInvoice);
                lrc_SalesLine.MODIFY(TRUE);
               END;
        
            END;
          UNTIL lrc_SalesLine.next() = 0;
        END;
        *************** RS - über Funktion SalesAttachEmptiestoSalesLines gelöst*/

    end;

    procedure CalculateEmptiesShipmentPrice(vco_EmptiesItemNo: Code[20]; vop_SourceType: Option Customer,Vendor,"Shipping Agent","Empties Price Group"; vco_SourceNo: Code[20]; vco_LocationFilter: Code[10]; vdt_Date: Date; vdc_Quantity: Decimal; vdc_EmptiesQuantity: Decimal; var vdc_RefundsAmount: Decimal): Decimal
    var
        lrc_Customer: Record Customer;
        lrc_Vendor: Record Vendor;
        lrc_ShippingAgent: Record "Shipping Agent";
        lrc_BOMComponent: Record "BOM Component";
        lrc_CompanyChain: Record "POI Company Chain";
        lbn_PriceFound: Boolean;
        ldc_UnitPrice: Decimal;
        lco_ItemArray: array[100] of Code[20];
        ldc_BOMQuantity: array[100] of Decimal;
        lin_ArrayCounter: Integer;
        SSPText01Txt: Label 'Multiple Levels aren''t supported at empties ! %1 - %2', Comment = '%1 %2';
    begin
        // ------------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Abgabepreises (Pfandgebühr) für Leergut
        // ------------------------------------------------------------------------------------------

        vdc_RefundsAmount := 0;
        ldc_UnitPrice := 0;

        IF (vco_EmptiesItemNo = '') OR
           (vdc_Quantity = 0) OR
           (vdc_EmptiesQuantity = 0) THEN
            EXIT;

        CLEAR(lco_ItemArray);
        CLEAR(ldc_BOMQuantity);
        lrc_Item.GET(vco_EmptiesItemNo);
        lrc_Item.CALCFIELDS("POI Bill of Materials");
        IF lrc_Item."POI Bill of Materials" = TRUE THEN BEGIN
            lrc_BOMComponent.RESET();
            lrc_BOMComponent.SETRANGE("Parent Item No.", vco_EmptiesItemNo);
            lrc_BOMComponent.SETRANGE(Type, lrc_BOMComponent.Type::Item);
            lrc_BOMComponent.SETFILTER("No.", '<>%1', '');
            IF lrc_BOMComponent.FINDSET(FALSE, FALSE) THEN BEGIN
                lin_ArrayCounter := 1;
                REPEAT
                    lrc_BOMComponent.CALCFIELDS("Assembly BOM");
                    IF lrc_BOMComponent."Assembly BOM" = TRUE THEN
                        ERROR(SSPText01Txt, lrc_BOMComponent."No.", lrc_BOMComponent."Parent Item No.");
                    lco_ItemArray[lin_ArrayCounter] := lrc_BOMComponent."No.";
                    ldc_BOMQuantity[lin_ArrayCounter] := lrc_BOMComponent."Quantity per";
                    lin_ArrayCounter := lin_ArrayCounter + 1;
                UNTIL lrc_BOMComponent.NEXT() = 0;
            END ELSE BEGIN
                lco_ItemArray[1] := vco_EmptiesItemNo;
                ldc_BOMQuantity[1] := 1;
            END;
        END ELSE BEGIN
            lco_ItemArray[1] := vco_EmptiesItemNo;
            ldc_BOMQuantity[1] := 1;
        END;
        lin_ArrayCounter := 1;
        REPEAT
            IF lco_ItemArray[lin_ArrayCounter] <> '' THEN
                CASE vop_SourceType OF
                    vop_SourceType::Customer:
                        BEGIN
                            lrc_Customer.GET(vco_SourceNo);
                            IF NOT lrc_CompanyChain.GET(lrc_Customer."Chain Name") THEN
                                lrc_CompanyChain.INIT();
                            lbn_PriceFound := FALSE;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Customer
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Customer);
                                lrc_RefundCosts.SETRANGE("Source No.", vco_SourceNo);
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                                     (ldc_BOMQuantity[lin_ArrayCounter] *
                                                      lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Company Chain" Customer
                                IF lrc_Customer."Chain Name" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain.Code);
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                                         (ldc_BOMQuantity[lin_ArrayCounter] *
                                                          lrc_RefundCosts."Shipment Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" Customer
                                IF lrc_Customer."POI Empties Price Group" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_Customer."POI Empties Price Group");
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" "Company Chain"
                                IF lrc_Customer."Chain Name" <> '' THEN
                                    IF lrc_CompanyChain."Empties Price Group" <> '' THEN BEGIN
                                        lrc_RefundCosts.RESET();
                                        lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                        lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain."Empties Price Group");
                                        lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                        lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                        IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                            ldc_UnitPrice := ldc_UnitPrice +
                                               (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                            lbn_PriceFound := TRUE;
                                        END;
                                    END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price all Customer
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Customer);
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price all "Company Chain"
                                IF lrc_Customer."Chain Name" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                                    lrc_RefundCosts.SETRANGE("Source No.", '');
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Global
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Sales Global");
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                        END;

                    vop_SourceType::Vendor:
                        BEGIN

                            lrc_Vendor.GET(vco_SourceNo);
                            IF NOT lrc_CompanyChain.GET(lrc_Vendor."POI Chain Name") THEN
                                lrc_CompanyChain.INIT();
                            lbn_PriceFound := FALSE;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Vendor
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Vendor);
                                lrc_RefundCosts.SETRANGE("Source No.", vco_SourceNo);
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Company Chain" Vendor
                                IF lrc_Vendor."POI Chain Name" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain.Code);
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" Vendor
                                IF lrc_Vendor."POI Empties Price Group" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_Vendor."POI Empties Price Group");
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" "Company Chain"
                                IF lrc_Vendor."POI Chain Name" <> '' THEN
                                    IF lrc_CompanyChain."Empties Price Group" <> '' THEN BEGIN
                                        lrc_RefundCosts.RESET();
                                        lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                        lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain."Empties Price Group");
                                        lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                        lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                        IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                            ldc_UnitPrice := ldc_UnitPrice +
                                               (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                            lbn_PriceFound := TRUE;
                                        END;
                                    END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price all Vendor
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Vendor);
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price all "Company Chain"
                                IF lrc_Vendor."POI Chain Name" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                                    lrc_RefundCosts.SETRANGE("Source No.", '');
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Global
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Purchase Global");
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                        END;

                    vop_SourceType::"Shipping Agent":
                        BEGIN

                            lrc_ShippingAgent.GET(vco_SourceNo);
                            lbn_PriceFound := FALSE;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price "Shipping Agent"
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Shipping Agent");
                                lrc_RefundCosts.SETRANGE("Source No.", vco_SourceNo);
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" "Shipping Agent"
                                IF lrc_ShippingAgent."POI Empties Price Group" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_ShippingAgent."POI Empties Price Group");
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price all "Shipping Agent"
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Shipping Agent");
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;


                            // VORHER WISSEN WIR OB EINKAUF ODER VERKAUF BEI SHIPPING AGENT
                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Global
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Sales Global");
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Shipment Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                        END;
                END;
            lin_ArrayCounter := lin_ArrayCounter + 1;
        UNTIL lin_ArrayCounter > 100;

        vdc_RefundsAmount := ROUND(vdc_Quantity * vdc_EmptiesQuantity * ldc_UnitPrice, 0.01);
    end;

    procedure CalculateEmptiesReceiptPrice(vco_EmptiesItemNo: Code[20]; vop_SourceType: Option Customer,Vendor,"Shipping Agent","Empties Price Group"; vco_SourceNo: Code[20]; vco_LocationFilter: Code[10]; vdt_Date: Date; vdc_Quantity: Decimal; vdc_EmptiesQuantity: Decimal; vop_DocumentType: Option "0","1","2","3","4","5","6","7","8","9"; vco_DocumentNo: Code[20]; vin_DocumentLineNo: Integer; var vdc_RefundsAmount: Decimal): Decimal
    var
        lrc_Customer: Record Customer;
        lrc_Vendor: Record Vendor;
        lrc_ShippingAgent: Record "Shipping Agent";
        lrc_BOMComponent: Record "BOM Component";
        lrc_CompanyChain: Record "POI Company Chain";
        lco_ItemArray: array[100] of Code[20];
        ldc_BOMQuantity: array[100] of Decimal;
        ldc_PossibleFullPriceQuantity: array[100] of Decimal;
        lin_ArrayCounter: Integer;
        ldc_ReducedPriceQuantity: Decimal;
        lrc_QuantityForSameItem: Decimal;
        ldc_UnitPrice: Decimal;
        lbn_PriceFound: Boolean;
        SSPText01Txt: Label 'Multiple Levels aren''t supported at empties ! %1 - %2', Comment = '%1 %2';
    begin
        // ------------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Annahmepreises (Pfandgebühr) für Leergut
        // ------------------------------------------------------------------------------------------

        vdc_RefundsAmount := 0;
        ldc_UnitPrice := 0;

        IF (vco_EmptiesItemNo = '') OR
           (vdc_Quantity = 0) OR
           (vdc_EmptiesQuantity = 0) THEN
            EXIT;

        lrc_Item.GET(vco_EmptiesItemNo);
        lrc_Item.CALCFIELDS("POI Bill of Materials");

        CLEAR(lco_ItemArray);
        CLEAR(ldc_BOMQuantity);
        CLEAR(ldc_PossibleFullPriceQuantity);

        IF lrc_Item."POI Bill of Materials" = TRUE THEN BEGIN
            lrc_BOMComponent.RESET();
            lrc_BOMComponent.SETRANGE("Parent Item No.", vco_EmptiesItemNo);
            lrc_BOMComponent.SETRANGE(Type, lrc_BOMComponent.Type::Item);
            lrc_BOMComponent.SETFILTER("No.", '<>%1', '');
            IF lrc_BOMComponent.FIND('-') THEN BEGIN
                lin_ArrayCounter := 1;
                REPEAT
                    lrc_BOMComponent.CALCFIELDS("Assembly BOM");
                    IF lrc_BOMComponent."Assembly BOM" THEN
                        ERROR(SSPText01Txt, lrc_BOMComponent."No.", lrc_BOMComponent."Parent Item No.");
                    lco_ItemArray[lin_ArrayCounter] := lrc_BOMComponent."No.";
                    ldc_BOMQuantity[lin_ArrayCounter] := lrc_BOMComponent."Quantity per";
                    ldc_PossibleFullPriceQuantity[lin_ArrayCounter] :=
                                                          (vdc_Quantity * vdc_EmptiesQuantity) *
                                                           ldc_BOMQuantity[lin_ArrayCounter];

                    lin_ArrayCounter := lin_ArrayCounter + 1;
                UNTIL lrc_BOMComponent.NEXT() = 0;
            END ELSE BEGIN
                lco_ItemArray[1] := vco_EmptiesItemNo;
                ldc_BOMQuantity[1] := 1;
            END;
        END ELSE BEGIN
            lco_ItemArray[1] := vco_EmptiesItemNo;
            ldc_BOMQuantity[1] := 1;
            ldc_PossibleFullPriceQuantity[1] :=
                                        (vdc_Quantity * vdc_EmptiesQuantity) *
                                        ldc_BOMQuantity[1];
        END;


        IF vop_SourceType = vop_SourceType::Customer THEN BEGIN
            lin_ArrayCounter := 1;
            REPEAT
                IF lco_ItemArray[lin_ArrayCounter] <> '' THEN BEGIN
                    lrc_Customer.GET(vco_SourceNo);
                    IF lrc_Customer."POI Obser Reduced Refund Costs" = TRUE THEN BEGIN
                        lrc_Item.GET(lco_ItemArray[lin_ArrayCounter]);
                        // lrc_Item.SETFILTER("Location Filter", '%1', vco_LocationFilter );
                        lrc_Item.SETRANGE("Location Filter");
                        lrc_Item.SETFILTER("POI Source Type Filter", '%1', lrc_Item."POI Source Type Filter"::Customer);
                        lrc_Item.SETFILTER("POI Source No. Filter", '%1', vco_SourceNo);
                        lrc_Item.SETRANGE("Date Filter");
                        lrc_Item.CALCFIELDS("POI Empties Shipm Sale (Qty.)", "POI Empties Rec Sale (Qty.)");

                        lrc_QuantityForSameItem := 0;
                        // existiert dieser Artikel bereits im gleichen Beleg,
                        // gelten die Mengen auch schon als zurückgenommen
                        lrc_SalesLine.RESET();
                        lrc_SalesLine.SETRANGE("Document Type", vop_DocumentType);
                        lrc_SalesLine.SETRANGE("Document No.", vco_DocumentNo);
                        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                        lrc_SalesLine.SETRANGE("No.", lco_ItemArray[lin_ArrayCounter]);
                        // IF vin_DocumentLineNo > 1 THEN BEGIN
                        //    lrc_SalesLine.SETFILTER("Line No.", '..%1', vin_DocumentLineNo - 1);
                        // END;
                        IF lrc_SalesLine.FIND('-') THEN BEGIN
                            REPEAT
                                lrc_QuantityForSameItem := lrc_QuantityForSameItem + lrc_SalesLine."Outstanding Qty. (Base)";
                            UNTIL lrc_SalesLine.next() = 0;
                            lrc_Item."POI Empties Rec Sale (Qty.)" := lrc_Item."POI Empties Rec Sale (Qty.)" + lrc_QuantityForSameItem;
                        END;

                        IF lrc_Item."POI Empties Shipm Sale (Qty.)" - lrc_Item."POI Empties Rec Sale (Qty.)" > 0 THEN BEGIN
                            IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > (lrc_Item."POI Empties Shipm Sale (Qty.)" - lrc_Item."POI Empties Rec Sale (Qty.)") THEN
                                ldc_PossibleFullPriceQuantity[lin_ArrayCounter] := lrc_Item."POI Empties Shipm Sale (Qty.)" - lrc_Item."POI Empties Rec Sale (Qty.)";
                        END ELSE
                            ldc_PossibleFullPriceQuantity[lin_ArrayCounter] := 0;
                    END;
                END;
                lin_ArrayCounter := lin_ArrayCounter + 1;
            UNTIL lin_ArrayCounter > 100;
        END;


        lin_ArrayCounter := 1;
        REPEAT
            IF lco_ItemArray[lin_ArrayCounter] <> '' THEN
                CASE vop_SourceType OF

                    vop_SourceType::Customer:
                        BEGIN

                            lrc_Customer.GET(vco_SourceNo);
                            IF NOT lrc_CompanyChain.GET(lrc_Customer."Chain Name") THEN
                                lrc_CompanyChain.INIT();
                            lbn_PriceFound := FALSE;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Customer
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Customer);
                                lrc_RefundCosts.SETRANGE("Source No.", vco_SourceNo);
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                       (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END ELSE BEGIN
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                            ldc_UnitPrice := ldc_UnitPrice +
                                               (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                            lbn_PriceFound := TRUE;
                                        END;
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                           (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                            ldc_ReducedPriceQuantity :=
                                               (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) -
                                               ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                            IF ldc_ReducedPriceQuantity > 0 THEN
                                                IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN
                                                    ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Receipt Price (LCY)")
                                                ELSE
                                                    ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Reduced Receipt Price (LCY)");
                                            lbn_PriceFound := TRUE;
                                        END;
                                    END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" "Company Chain"
                                IF lrc_Customer."Chain Name" <> '' THEN
                                    IF lrc_CompanyChain."Empties Price Group" <> '' THEN BEGIN
                                        lrc_RefundCosts.RESET();
                                        lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                        lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain."Empties Price Group");
                                        lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                        lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                        IF lrc_RefundCosts.FINDLAST() THEN
                                            IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                               (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                                ldc_UnitPrice := ldc_UnitPrice +
                                                   (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                                lbn_PriceFound := TRUE;
                                            END ELSE BEGIN
                                                IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                                    ldc_UnitPrice := ldc_UnitPrice +
                                                       (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                                    lbn_PriceFound := TRUE;
                                                END;
                                                IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                                   (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                                    ldc_ReducedPriceQuantity :=
                                                       (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) -
                                                       ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                                    IF ldc_ReducedPriceQuantity > 0 THEN
                                                        IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN
                                                            ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Receipt Price (LCY)")
                                                        ELSE
                                                            ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Reduced Receipt Price (LCY)");
                                                    lbn_PriceFound := TRUE;
                                                END;
                                            END;
                                    END;


                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" Customer
                                IF lrc_Customer."POI Empties Price Group" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_Customer."POI Empties Price Group");
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                           (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                            ldc_UnitPrice := ldc_UnitPrice +
                                               (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                            lbn_PriceFound := TRUE;
                                        END ELSE BEGIN
                                            IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                                ldc_UnitPrice := ldc_UnitPrice +
                                                   (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                                lbn_PriceFound := TRUE;
                                            END;
                                            IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                               (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                                ldc_ReducedPriceQuantity :=
                                                   (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) -
                                                   ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                                IF ldc_ReducedPriceQuantity > 0 THEN
                                                    IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN
                                                        ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Receipt Price (LCY)")
                                                    ELSE
                                                        ldc_UnitPrice := ldc_UnitPrice +
                                                           (ldc_ReducedPriceQuantity *
                                                              lrc_RefundCosts."Reduced Receipt Price (LCY)");
                                                lbn_PriceFound := TRUE;
                                            END;
                                        END;
                                END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Company Chain" Vendor
                                IF lrc_Customer."Chain Name" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain.Code);
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                           (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                            ldc_UnitPrice := ldc_UnitPrice +
                                               (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                            lbn_PriceFound := TRUE;
                                        END ELSE BEGIN
                                            IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN BEGIN
                                                ldc_UnitPrice := ldc_UnitPrice +
                                                   (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                                lbn_PriceFound := TRUE;
                                            END;
                                            IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                               (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                                ldc_ReducedPriceQuantity :=
                                                   (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) -
                                                   ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                                IF ldc_ReducedPriceQuantity > 0 THEN
                                                    IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN
                                                        ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Receipt Price (LCY)")
                                                    ELSE
                                                        ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Reduced Receipt Price (LCY)");
                                                lbn_PriceFound := TRUE;
                                            END;
                                        END;
                                END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price all Customer
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Customer);
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                       (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN
                                        ldc_UnitPrice := ldc_UnitPrice + (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)")
                                    ELSE BEGIN
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN
                                            ldc_UnitPrice := ldc_UnitPrice + (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <> (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                            ldc_ReducedPriceQuantity := (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) - ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                            IF ldc_ReducedPriceQuantity > 0 THEN
                                                IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN
                                                    ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Receipt Price (LCY)")
                                                ELSE
                                                    ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Reduced Receipt Price (LCY)");
                                        END;
                                    END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price all "Company Chain"
                                IF lrc_Customer."Chain Name" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                                    lrc_RefundCosts.SETRANGE("Source No.", '');
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                           (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN
                                            ldc_UnitPrice := ldc_UnitPrice +
                                               (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)")
                                        ELSE BEGIN
                                            IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN
                                                ldc_UnitPrice := ldc_UnitPrice +
                                                   (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                            IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                               (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                                ldc_ReducedPriceQuantity :=
                                                   (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) - ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                                IF ldc_ReducedPriceQuantity > 0 THEN
                                                    IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN
                                                        ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Receipt Price (LCY)")
                                                    ELSE
                                                        ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Reduced Receipt Price (LCY)");
                                            END;
                                        END;
                                END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Global
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Sales Global");
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN
                                    IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] >=
                                       (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN
                                        ldc_UnitPrice := ldc_UnitPrice + (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)")
                                    ELSE BEGIN
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] > 0 THEN
                                            ldc_UnitPrice := ldc_UnitPrice + (ldc_PossibleFullPriceQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                        IF ldc_PossibleFullPriceQuantity[lin_ArrayCounter] <>
                                           (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) THEN BEGIN
                                            ldc_ReducedPriceQuantity := (vdc_Quantity * vdc_EmptiesQuantity * ldc_BOMQuantity[lin_ArrayCounter]) - ldc_PossibleFullPriceQuantity[lin_ArrayCounter];
                                            IF ldc_ReducedPriceQuantity > 0 THEN
                                                IF lrc_RefundCosts."Reduced Receipt Price (LCY)" = 0 THEN
                                                    ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Receipt Price (LCY)")
                                                ELSE
                                                    ldc_UnitPrice := ldc_UnitPrice + (ldc_ReducedPriceQuantity * lrc_RefundCosts."Reduced Receipt Price (LCY)");
                                        END;
                                    END;
                            END;
                        END;



                    vop_SourceType::Vendor:
                        BEGIN

                            lrc_Vendor.GET(vco_SourceNo);
                            IF NOT lrc_CompanyChain.GET(lrc_Vendor."POI Chain Name") THEN
                                lrc_CompanyChain.INIT();
                            lbn_PriceFound := FALSE;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Vendor
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Vendor);
                                lrc_RefundCosts.SETRANGE("Source No.", vco_SourceNo);
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Company Chain" Vendor
                                IF lrc_Vendor."POI Chain Name" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain.Code);
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" Vendor
                                IF lrc_Vendor."POI Empties Price Group" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_Vendor."POI Empties Price Group");
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" "Company Chain"
                                IF lrc_Vendor."POI Chain Name" <> '' THEN
                                    IF lrc_CompanyChain."Empties Price Group" <> '' THEN BEGIN
                                        lrc_RefundCosts.RESET();
                                        lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                        lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                        lrc_RefundCosts.SETRANGE("Source No.", lrc_CompanyChain."Empties Price Group");
                                        lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                        lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                        IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                            ldc_UnitPrice := ldc_UnitPrice +
                                               (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                            lbn_PriceFound := TRUE;
                                        END;
                                    END;


                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price all Vendor
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::Vendor);
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEn
                                // Price all "Company Chain"
                                IF lrc_Vendor."POI Chain Name" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Company Chain");
                                    lrc_RefundCosts.SETRANGE("Source No.", '');
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FINDLAST() THEN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Global
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Purchase Global");
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FINDLAST() THEN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                               (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                lbn_PriceFound := TRUE;
                            END;

                        END;


                    vop_SourceType::"Shipping Agent":
                        BEGIN

                            lrc_ShippingAgent.GET(vco_SourceNo);
                            lbn_PriceFound := FALSE;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price "Shipping Agent"
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Shipping Agent");
                                lrc_RefundCosts.SETRANGE("Source No.", vco_SourceNo);
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FIND('+') THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEN
                                // Price "Empties Price Group" "Shipping Agent"
                                IF lrc_ShippingAgent."POI Empties Price Group" <> '' THEN BEGIN
                                    lrc_RefundCosts.RESET();
                                    lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                    lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Empties Price Group");
                                    lrc_RefundCosts.SETRANGE("Source No.", lrc_ShippingAgent."POI Empties Price Group");
                                    lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                    lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                    IF lrc_RefundCosts.FIND('+') THEN BEGIN
                                        ldc_UnitPrice := ldc_UnitPrice +
                                           (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                        lbn_PriceFound := TRUE;
                                    END;
                                END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price all "Shipping Agent"
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Shipping Agent");
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FIND('+') THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                            IF lbn_PriceFound = FALSE THEN BEGIN
                                // Price Global
                                lrc_RefundCosts.RESET();
                                lrc_RefundCosts.SETRANGE("Item No.", lco_ItemArray[lin_ArrayCounter]);
                                lrc_RefundCosts.SETRANGE("Source Type", lrc_RefundCosts."Source Type"::"Sales Global");
                                lrc_RefundCosts.SETRANGE("Source No.", '');
                                lrc_RefundCosts.SETFILTER("Starting Date", '%1..%2', 0D, vdt_Date);
                                lrc_RefundCosts.SETFILTER("Ending Date", '%1|>=%2', 0D, vdt_Date);
                                IF lrc_RefundCosts.FIND('+') THEN BEGIN
                                    ldc_UnitPrice := ldc_UnitPrice +
                                       (ldc_BOMQuantity[lin_ArrayCounter] * lrc_RefundCosts."Receipt Price (LCY)");
                                    lbn_PriceFound := TRUE;
                                END;
                            END;

                        END;
                END;
            lin_ArrayCounter := lin_ArrayCounter + 1;
        UNTIL lin_ArrayCounter > 10;

        IF vop_SourceType = vop_SourceType::Customer THEN
            vdc_RefundsAmount := ROUND(ldc_UnitPrice, 0.01)
        ELSE
            vdc_RefundsAmount := ROUND(vdc_Quantity * vdc_EmptiesQuantity * ldc_UnitPrice, 0.01);
    end;

    local procedure CalcQuantity(pdc_Quantity: Decimal; prc_SalesLine: Record "Sales Line"; pdc_BomQuantity: Decimal) ldc_Empties: Decimal
    var
        lrc_UnitofMeasure: Record "Unit of Measure";
        lin_Faktor: Integer;
    begin

        IF NOT prc_SalesLine."POI Partial Quantity (PQ)" THEN
            ldc_Empties := pdc_Quantity * prc_SalesLine."POI Empties Quantity" * pdc_BomQuantity
        ELSE BEGIN
            // Über "Collo Unit of Measure (PQ)" rechnen, welcher Menge an Kolli dies entspricht
            // dies dann kaufmännisch runden.
            // Mindestens ist der Faktor aber immer 1
            // 1 ist testweise
            lin_Faktor := 1;
            IF lrc_UnitofMeasure.GET(prc_SalesLine."POI Collo Unit of Measure (PQ)") THEN
                // Um sicherzustellen, dass der richtige Faktor verwendet wird, wird hier geschaut, ob die Anbruchseinheit
                // der Verkaufszeile der Verpackungseinheit aus der Hinterlegung entspricht
                IF prc_SalesLine."Unit of Measure Code" = lrc_UnitofMeasure."POI Packing Unit of Meas (PU)" THEN BEGIN
                    lin_Faktor := ROUND(prc_SalesLine.Quantity / lrc_UnitofMeasure."POI Qty. (PU) per Unit of Meas", 1);
                    // Es muss immer mindestens 1 sein
                    IF lin_Faktor < 1 THEN
                        lin_Faktor := 1;
                END;
            ldc_Empties := lin_Faktor * prc_SalesLine."POI Empties Quantity" * pdc_BomQuantity;
        END;
    end;



    procedure EmPurchShowTransportEmpties(vrc_PurchHeader: Record "Purchase Header"; vbn_TransportItems: Boolean; vbn_EmptyItems: Boolean)
    var
        lrc_PurchDocType: Record "POI Purch. Doc. Subtype";
    //lrc_FruitVisionSetup: Record "POI ADF Setup";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Anzeige der Transportartikel und Leergutartikel
        // -----------------------------------------------------------------------------

        // Belegunterart lesen
        lrc_PurchDocType.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."POI Purch. Doc. Subtype Code");
        // Kontrolle ob Formularnummer für Belegunterart eingetragen ist
        lrc_PurchDocType.TESTFIELD("Form ID Empties Card");

        // Transportartikel laden
        IF vbn_TransportItems = TRUE THEN
            EmPurchLoadTransportItems(vrc_PurchHeader);
        // Leergutartikel laden
        IF vbn_EmptyItems = TRUE THEN
            EmPurchLoadEmptiesItems(vrc_PurchHeader);
        COMMIT();

        lrc_PurchEmpties.RESET();
        lrc_PurchEmpties.FILTERGROUP(0);
        lrc_PurchEmpties.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchEmpties.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchEmpties.FILTERGROUP(0);
        Page.RUNMODAL(lrc_PurchDocType."Form ID Empties Card", lrc_PurchEmpties);

        // Transportmittelartikel anlegen
        IF vbn_TransportItems = TRUE THEN
            EmCreatePurchLinesTranspItems(vrc_PurchHeader);
        // Leergutartikel anlegen
        IF vbn_EmptyItems = TRUE THEN
            EmCreatePurchLinesEmptiesItems(vrc_PurchHeader);
    end;

    procedure EmPurchLoadTransportItems(vrc_PurchHeader: Record "Purchase Header")
    var
        //lrc_Location: Record Location;
        lrc_Vendor: Record Vendor;
        //lco_EmptiesLocationCode: Code[10];
        lbn_LoadTransportItem: Boolean;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Laden der Transportartikel im Einkauf
        // -----------------------------------------------------------------------------

        vrc_PurchHeader.TESTFIELD("Buy-from Vendor No.");
        vrc_PurchHeader.TESTFIELD("Location Code");
        lrc_Vendor.GET(vrc_PurchHeader."Buy-from Vendor No.");

        // Kontrolle ob die Transportmittel bereits geladen sind
        lbn_LoadTransportItem := FALSE;
        lrc_PurchEmpties.RESET();
        lrc_PurchEmpties.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchEmpties.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchEmpties.SETRANGE("Item Typ", lrc_PurchEmpties."Item Typ"::"Transport Item");
        IF lrc_PurchEmpties.ISEMPTY() THEN BEGIN

            // Alle zulässigen Transportmittel für den Kreditor laden
            IF lbn_LoadTransportItem = FALSE THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::Vendor);
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", vrc_PurchHeader."Buy-from Vendor No.");
                IF NOT lrc_VendCustShipAgentEmpties.ISEMPTY() THEN
                    lbn_LoadTransportItem := TRUE;
            END;
            // Alle zulässigen Transportmittel für die Unternehmenskette laden
            IF (lbn_LoadTransportItem = FALSE) AND (lrc_Vendor."POI Chain Name" <> '') THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Company Chain");
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", lrc_Vendor."POI Chain Name");
                IF NOT lrc_VendCustShipAgentEmpties.ISEMPTY() THEN
                    lbn_LoadTransportItem := TRUE;
            END;
            // Alle zulässigen Transportmittel Global laden
            IF lbn_LoadTransportItem = FALSE THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Purchase Global");
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", '');
                IF NOT lrc_VendCustShipAgentEmpties.ISEMPTY() THEN
                    lbn_LoadTransportItem := TRUE;
            END;

            IF lbn_LoadTransportItem = TRUE THEN
                IF lrc_VendCustShipAgentEmpties.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        lrc_PurchEmpties.RESET();
                        lrc_PurchEmpties.INIT();
                        lrc_PurchEmpties."Document Type" := vrc_PurchHeader."Document Type";
                        lrc_PurchEmpties."Document No." := vrc_PurchHeader."No.";
                        lrc_PurchEmpties.Source := lrc_PurchEmpties.Source::Vendor;
                        lrc_PurchEmpties."Source No." := vrc_PurchHeader."Buy-from Vendor No.";
                        lrc_PurchEmpties.VALIDATE("Item No.", lrc_VendCustShipAgentEmpties."Item No.");
                        lrc_PurchEmpties.VALIDATE("Location Code", vrc_PurchHeader."Location Code");
                        lrc_PurchEmpties."Line No." := 0;

                        // Abrechnung immer über Kreditor
                        lrc_PurchEmpties."Empties Allocation" := lrc_Vendor."POI Empties Allocation";
                        lrc_PurchEmpties."Empties Calculation" := lrc_Vendor."POI Empties Calculation";

                        EmPurchGetPrices(lrc_RefundCosts, vrc_PurchHeader, lrc_Vendor, lrc_PurchEmpties."Item No.");
                        lrc_PurchEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                        lrc_PurchEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");

                        lrc_PurchEmpties.INSERT(TRUE);
                    UNTIL lrc_VendCustShipAgentEmpties.next() = 0;


            // Alle Transportmittel aus dem Artikelstamm laden
            IF lbn_LoadTransportItem = FALSE THEN BEGIN
                lrc_Item.RESET();
                lrc_Item.SETCURRENTKEY("POI Item Typ");
                lrc_Item.SETRANGE("POI Item Typ", lrc_Item."POI Item Typ"::"Transport Item");
                lrc_Item.SETRANGE(Blocked, FALSE);
                IF lrc_Item.FINDSET(FALSE, FALSE) THEN
                    REPEAT
                        lrc_PurchEmpties.RESET();
                        lrc_PurchEmpties.INIT();
                        lrc_PurchEmpties."Document Type" := vrc_PurchHeader."Document Type";
                        lrc_PurchEmpties."Document No." := vrc_PurchHeader."No.";
                        lrc_PurchEmpties.Source := lrc_PurchEmpties.Source::Vendor;
                        lrc_PurchEmpties."Source No." := vrc_PurchHeader."Buy-from Vendor No.";
                        lrc_PurchEmpties.VALIDATE("Item No.", lrc_Item."No.");
                        lrc_PurchEmpties.VALIDATE("Location Code", vrc_PurchHeader."Location Code");
                        lrc_PurchEmpties."Line No." := 0;
                        // Abrechnung immer über Kreditor
                        lrc_PurchEmpties."Empties Allocation" := lrc_Vendor."POI Empties Allocation";
                        lrc_PurchEmpties."Empties Calculation" := lrc_Vendor."POI Empties Calculation";
                        // Pfandpreise lesen
                        EmPurchGetPrices(lrc_RefundCosts, vrc_PurchHeader, lrc_Vendor, lrc_PurchEmpties."Item No.");
                        lrc_PurchEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                        lrc_PurchEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");
                        lrc_PurchEmpties.INSERT(TRUE);
                    UNTIL lrc_Item.next() = 0;
            END;

        END;

        // ---------------------------------------------------------------------------------
        // Mengen aus Einkaufszeilen abgleichen
        // ---------------------------------------------------------------------------------
        lrc_PurchEmpties.RESET();
        lrc_PurchEmpties.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchEmpties.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchEmpties.SETRANGE("Item Typ", lrc_PurchEmpties."Item Typ"::"Transport Item");
        lrc_PurchEmpties.SETRANGE("Empties Calculation", lrc_PurchEmpties."Empties Calculation"::"Same Document");
        IF lrc_PurchEmpties.FINDSET(TRUE, FALSE) THEN
            REPEAT
                IF lrc_PurchEmpties."Rec. Created Line No." <> 0 THEN
                    IF lrc_PurchLine.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."No.", lrc_PurchEmpties."Rec. Created Line No.") THEN BEGIN
                        lrc_PurchEmpties.VALIDATE("Rec. Quantity", lrc_PurchLine.Quantity);
                        lrc_PurchEmpties."Rec. Qty. Received" := lrc_PurchLine."Quantity Received";
                        lrc_PurchEmpties."Rec. Qty. Invoiced" := lrc_PurchLine."Quantity Invoiced";
                        lrc_PurchEmpties.MODIFY();
                    END;
                IF lrc_PurchEmpties."Ship. Created Line No." <> 0 THEN
                    IF lrc_PurchLine.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."No.", lrc_PurchEmpties."Ship. Created Line No.") THEN BEGIN
                        lrc_PurchEmpties.VALIDATE("Ship. Quantity", lrc_PurchLine.Quantity * -1);
                        lrc_PurchEmpties."Ship. Qty. Shipped" := lrc_PurchLine."Quantity Received" * -1;
                        lrc_PurchEmpties."Ship. Qty. Invoiced" := lrc_PurchLine."Quantity Invoiced" * -1;
                        lrc_PurchEmpties.MODIFY();
                    END;
            UNTIL lrc_PurchEmpties.next() = 0;
    end;

    procedure EmPurchLoadEmptiesItems(vrc_PurchHeader: Record "Purchase Header")
    var
        lrc_Vendor: Record Vendor;
        lco_EmptiesItemNo: Code[20];
    //lin_LineNo: Integer;
    //lbn_NeuLaden: Boolean;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Laden der Leergutartikel auf Basis der eingekauften Artikel
        // -----------------------------------------------------------------------------

        vrc_PurchHeader.TESTFIELD("Buy-from Vendor No.");
        vrc_PurchHeader.TESTFIELD("Location Code");
        lrc_Vendor.GET(vrc_PurchHeader."Buy-from Vendor No.");

        // ---------------------------------------------------------------------------
        // Kontrolle ob Leergutartikel bereits geladen sind
        // ---------------------------------------------------------------------------
        lrc_PurchEmpties.RESET();
        lrc_PurchEmpties.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchEmpties.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchEmpties.SETRANGE("Item Typ", lrc_PurchEmpties."Item Typ"::"Empties Item");
        IF lrc_PurchEmpties.FIND('-') THEN
            REPEAT
                lrc_PurchEmpties."Rec. Calc. Quantity" := 0;
                lrc_PurchEmpties."Ship. Calc. Quantity" := 0;
                IF lrc_PurchEmpties."Empties Calculation" = lrc_PurchEmpties."Empties Calculation"::"Same Document" THEN BEGIN
                    lrc_PurchEmpties."Rec. Quantity" := 0;
                    lrc_PurchEmpties."Rec. Qty. to Receive" := 0;
                    lrc_PurchEmpties."Rec. Qty. Received" := 0;
                    lrc_PurchEmpties."Rec. Qty. to Invoice" := 0;
                    lrc_PurchEmpties."Rec. Qty. Invoiced" := 0;
                    lrc_PurchEmpties."Rec. Qty. to Transfer" := 0;
                    lrc_PurchEmpties."Rec. Qty. Transfered" := 0;
                    lrc_PurchEmpties."Ship. Quantity" := 0;
                    lrc_PurchEmpties."Ship. Qty. to Ship" := 0;
                    lrc_PurchEmpties."Ship. Qty. Shipped" := 0;
                    lrc_PurchEmpties."Ship. Qty. to Invoice" := 0;
                    lrc_PurchEmpties."Ship. Qty. Invoiced" := 0;
                    lrc_PurchEmpties."Ship. Qty. to Transfer" := 0;
                    lrc_PurchEmpties."Ship. Qty. Transfered" := 0;
                END;
                lrc_PurchEmpties.MODIFY();
            UNTIL lrc_PurchEmpties.next() = 0;

        // ---------------------------------------------------------------------------
        // Artikel mit Leergut lesen
        // ---------------------------------------------------------------------------
        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
        lrc_PurchLine.SETFILTER("No.", '<>%1', '');
        lrc_PurchLine.SETFILTER("POI Empties Item No.", '<>%1', '');
        lrc_PurchLine.SETFILTER("POI Empties Quantity", '>%1', 0);
        lrc_PurchLine.SETFILTER("POI Item Typ", '<>%1&<>%2', lrc_PurchLine."POI Item Typ"::"Transport Item",
                                                       lrc_PurchLine."POI Item Typ"::"Empties Item");
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                IF (lrc_PurchLine."POI Empties Item No." <> '') AND
                   (lrc_PurchLine."POI Empties Quantity" > 0) THEN BEGIN
                    // Leergutartikelnummer ermitteln
                    lrc_Item.GET(lrc_PurchLine."POI Empties Item No.");
                    IF lrc_Item."POI Empties Posting Item No." <> '' THEN
                        lco_EmptiesItemNo := lrc_Item."POI Empties Posting Item No."
                    ELSE
                        lco_EmptiesItemNo := lrc_Item."No.";
                    lrc_PurchEmpties.RESET();
                    lrc_PurchEmpties.SETRANGE("Document Type", lrc_PurchLine."Document Type");
                    lrc_PurchEmpties.SETRANGE("Document No.", lrc_PurchLine."Document No.");
                    lrc_PurchEmpties.SETRANGE("Item No.", lco_EmptiesItemNo);
                    lrc_PurchEmpties.SETRANGE("Location Code", lrc_PurchLine."Location Code");
                    IF NOT lrc_PurchEmpties.FIND('-') THEN BEGIN
                        lrc_PurchEmpties.RESET();
                        lrc_PurchEmpties.INIT();
                        lrc_PurchEmpties."Document Type" := lrc_PurchLine."Document Type";
                        lrc_PurchEmpties."Document No." := lrc_PurchLine."Document No.";
                        lrc_PurchEmpties.VALIDATE("Item No.", lco_EmptiesItemNo);
                        lrc_PurchEmpties.VALIDATE("Location Code", lrc_PurchLine."Location Code");
                        lrc_PurchEmpties."Line No." := 0;
                        lrc_PurchEmpties.Source := lrc_PurchEmpties.Source::Vendor;
                        lrc_PurchEmpties."Source No." := vrc_PurchHeader."Buy-from Vendor No.";
                        // Abrechnung immer über Kreditor
                        lrc_PurchEmpties."Empties Allocation" := lrc_Vendor."POI Empties Allocation";
                        lrc_PurchEmpties."Empties Calculation" := lrc_Vendor."POI Empties Calculation";
                        EmPurchGetPrices(lrc_RefundCosts, vrc_PurchHeader, lrc_Vendor, lrc_PurchEmpties."Item No.");
                        lrc_PurchEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                        lrc_PurchEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");
                        lrc_PurchEmpties.INSERT(TRUE);
                    END;
                    IF lrc_PurchLine.Quantity > 0 THEN
                        lrc_PurchEmpties."Rec. Calc. Quantity" := lrc_PurchEmpties."Rec. Calc. Quantity" +
                                                                   (lrc_PurchLine.Quantity * lrc_PurchLine."POI Empties Quantity")
                    ELSE
                        lrc_PurchEmpties."Ship. Calc. Quantity" := lrc_PurchEmpties."Ship. Calc. Quantity" +
                                                                   (lrc_PurchLine.Quantity * lrc_PurchLine."POI Empties Quantity" * -1);
                    lrc_PurchEmpties.MODIFY();
                END;
            UNTIL lrc_PurchLine.next() = 0;



        // ---------------------------------------------------------------------------
        // Leergutartikel lesen
        // ---------------------------------------------------------------------------
        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
        lrc_PurchLine.SETFILTER("No.", '<>%1', '');
        lrc_PurchLine.SETFILTER("POI Item Typ", '%1', lrc_PurchLine."POI Item Typ"::"Empties Item");
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                lrc_PurchEmpties.RESET();
                lrc_PurchEmpties.SETRANGE("Document Type", lrc_PurchLine."Document Type");
                lrc_PurchEmpties.SETRANGE("Document No.", lrc_PurchLine."Document No.");
                lrc_PurchEmpties.SETRANGE("Item No.", lrc_PurchLine."No.");
                lrc_PurchEmpties.SETRANGE("Location Code", lrc_PurchLine."Location Code");
                IF NOT lrc_PurchEmpties.FIND('-') THEN BEGIN
                    lrc_PurchEmpties.RESET();
                    lrc_PurchEmpties.INIT();
                    lrc_PurchEmpties."Document Type" := lrc_PurchLine."Document Type";
                    lrc_PurchEmpties."Document No." := lrc_PurchLine."Document No.";
                    lrc_PurchEmpties.VALIDATE("Item No.", lrc_PurchLine."No.");
                    lrc_PurchEmpties.VALIDATE("Location Code", lrc_PurchLine."Location Code");
                    lrc_PurchEmpties."Line No." := 0;
                    lrc_PurchEmpties.Source := lrc_PurchEmpties.Source::Vendor;
                    lrc_PurchEmpties."Source No." := vrc_PurchHeader."Buy-from Vendor No.";
                    // Abrechnung immer über Kreditor
                    lrc_PurchEmpties."Empties Allocation" := lrc_Vendor."POI Empties Allocation";
                    lrc_PurchEmpties."Empties Calculation" := lrc_Vendor."POI Empties Calculation";
                    EmPurchGetPrices(lrc_RefundCosts, vrc_PurchHeader, lrc_Vendor, lrc_PurchEmpties."Item No.");
                    lrc_PurchEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                    lrc_PurchEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");
                    lrc_PurchEmpties.INSERT(TRUE);
                END;
                IF lrc_PurchLine.Quantity > 0 THEN BEGIN
                    lrc_PurchEmpties.VALIDATE("Rec. Quantity", lrc_PurchEmpties."Rec. Quantity" +
                                                        (lrc_PurchLine.Quantity));
                    lrc_PurchEmpties.VALIDATE("Rec. Qty. Received", lrc_PurchEmpties."Rec. Qty. Received" +
                                                             (lrc_PurchLine."Quantity Received"));
                    lrc_PurchEmpties.VALIDATE("Rec. Qty. Invoiced", lrc_PurchEmpties."Rec. Qty. Invoiced" +
                                                             (lrc_PurchLine."Quantity Invoiced"));
                END ELSE BEGIN
                    lrc_PurchEmpties.VALIDATE("Ship. Quantity", lrc_PurchEmpties."Ship. Quantity" +
                                                         (-lrc_PurchLine.Quantity));
                    lrc_PurchEmpties.VALIDATE("Ship. Qty. Shipped", lrc_PurchEmpties."Ship. Qty. Shipped" +
                                                             (-lrc_PurchLine."Quantity Received"));
                    lrc_PurchEmpties.VALIDATE("Ship. Qty. Invoiced", lrc_PurchEmpties."Ship. Qty. Invoiced" +
                                                              (-lrc_PurchLine."Quantity Invoiced"));
                END;
                lrc_PurchEmpties.MODIFY();
            UNTIL lrc_PurchLine.next() = 0;


        // ---------------------------------------------------------------------------
        // Mengen umsetzen
        // ---------------------------------------------------------------------------
        lrc_PurchEmpties.RESET();
        lrc_PurchEmpties.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchEmpties.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchEmpties.SETRANGE("Item Typ", lrc_PurchEmpties."Item Typ"::"Empties Item");
        IF lrc_PurchEmpties.FIND('-') THEN
            REPEAT
                IF lrc_PurchEmpties."Rec. Quantity" = 0 THEN
                    lrc_PurchEmpties.VALIDATE("Rec. Quantity", lrc_PurchEmpties."Rec. Calc. Quantity");
                IF lrc_PurchEmpties."Ship. Quantity" = 0 THEN
                    lrc_PurchEmpties.VALIDATE("Ship. Quantity", lrc_PurchEmpties."Ship. Calc. Quantity");
                lrc_PurchEmpties.MODIFY();
            UNTIL lrc_PurchEmpties.next() = 0;
    end;

    procedure EmCreatePurchLinesEmptiesItems(vrc_PurchHeader: Record "Purchase Header")
    var
        //lrc_FruitVisionSetup: Record "POI ADF Setup";
        //lrc_Item: Record Item;
        //lco_EmptiesItemNo: Code[20];
        lin_LineNo: Integer;
        //lbn_NeuLaden: Boolean;
        ldc_QuantityToReceive: Decimal;
        ldc_QuantityToInvoice: Decimal;
        ldc_Quantity: Decimal;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Erstellung der Einkaufszeilen Leergutartikel
        // -----------------------------------------------------------------------------

        // Einkaufszeilen anlegen
        lin_LineNo := EmEmptiesTranspStartLineNo();
        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
        IF lrc_PurchLine.FIND('+') THEN
            lin_LineNo := lrc_PurchLine."Line No.";
        lrc_PurchEmpties.RESET();
        lrc_PurchEmpties.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchEmpties.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchEmpties.SETRANGE("Item Typ", lrc_PurchEmpties."Item Typ"::"Empties Item");
        lrc_PurchEmpties.SETRANGE(Source, lrc_PurchEmpties.Source::Vendor);
        lrc_PurchEmpties.SETRANGE("Source No.", vrc_PurchHeader."Buy-from Vendor No.");
        lrc_PurchEmpties.SETFILTER("Empties Allocation", '%1|%2',
                                      lrc_PurchEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice",
                                      lrc_PurchEmpties."Empties Allocation"::"With Stock-Keeping With Invoice");
        lrc_PurchEmpties.SETRANGE("Empties Calculation", lrc_PurchEmpties."Empties Calculation"::"Same Document");
        IF lrc_PurchEmpties.FIND('-') THEN
            REPEAT
                // -----------------------------------------------------------------------------
                // Leergutabgabe
                // -----------------------------------------------------------------------------
                IF lrc_PurchEmpties."Rec. Quantity" > 0 THEN BEGIN
                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETRANGE("No.", lrc_PurchEmpties."Item No.");
                    lrc_PurchLine.SETRANGE("POI Item Typ", lrc_PurchLine."POI Item Typ"::"Empties Item");
                    lrc_PurchLine.SETRANGE("Location Code", lrc_PurchEmpties."Location Code");
                    lrc_PurchLine.SETFILTER(Quantity, '>%1', 0);
                    IF lrc_PurchLine.FIND('-') THEN BEGIN
                        lrc_PurchLine.VALIDATE(Quantity, lrc_PurchEmpties."Rec. Quantity");
                        lrc_PurchLine.MODIFY();
                    END ELSE BEGIN
                        lrc_PurchLine.RESET();
                        lrc_PurchLine.INIT();
                        lrc_PurchLine."Document Type" := vrc_PurchHeader."Document Type";
                        lrc_PurchLine."Document No." := vrc_PurchHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_PurchLine."Line No." := lin_LineNo;
                        lrc_PurchLine.INSERT(TRUE);
                        lrc_PurchLine.VALIDATE(Type, lrc_PurchLine.Type::Item);
                        lrc_PurchLine.VALIDATE("No.", lrc_PurchEmpties."Item No.");
                        lrc_PurchLine.VALIDATE("Location Code", lrc_PurchEmpties."Location Code");
                        ldc_QuantityToReceive := lrc_PurchEmpties."Rec. Qty. to Receive";
                        ldc_QuantityToInvoice := lrc_PurchEmpties."Rec. Qty. to Invoice";
                        lrc_PurchLine.VALIDATE("Line Discount %", 0);
                        lrc_PurchLine.VALIDATE("Allow Invoice Disc.", FALSE);
                        IF (lrc_PurchEmpties."Rec. Qty. to Receive" = 0) AND
                           (lrc_PurchEmpties."Rec. Qty. to Invoice" = 0) THEN
                            ldc_Quantity := 0
                        ELSE
                            IF (lrc_PurchEmpties."Rec. Qty. to Receive" > lrc_PurchEmpties."Rec. Qty. to Invoice") THEN
                                ldc_Quantity := lrc_PurchEmpties."Rec. Qty. to Receive"
                            ELSE
                                ldc_Quantity := lrc_PurchEmpties."Rec. Qty. to Invoice";

                        IF (lrc_PurchEmpties."Document Type" = lrc_PurchEmpties."Document Type"::"Credit Memo") OR
                           (lrc_PurchEmpties."Document Type" = lrc_PurchEmpties."Document Type"::"Return Order") THEN BEGIN
                            ldc_Quantity := ldc_Quantity * (-1);
                            ldc_QuantityToReceive := ldc_QuantityToReceive * (-1);
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice * (-1);
                        END ELSE BEGIN
                            ldc_Quantity := ldc_Quantity;
                            ldc_QuantityToReceive := ldc_QuantityToReceive;
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice;
                        END;
                        lrc_PurchLine.VALIDATE(Quantity);
                        IF lrc_PurchLine."Qty. to Receive" <> ldc_QuantityToReceive THEN
                            lrc_PurchLine.VALIDATE(Quantity, lrc_PurchLine."Quantity Received" + ldc_QuantityToReceive);
                        lrc_PurchLine.VALIDATE("Qty. to Invoice", ldc_QuantityToInvoice);
                        IF lrc_PurchEmpties."Empties Allocation" =
                           lrc_PurchEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                            lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)", 0)
                        ELSE BEGIN
                            lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)", lrc_PurchEmpties."Rec. Refund Price");
                            lrc_PurchLine.ADF_CalcMarketUnitPrice();
                        END;
                        lrc_PurchLine.MODIFY();
                    END;

                END ELSE BEGIN
                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETRANGE("No.", lrc_PurchEmpties."Item No.");
                    lrc_PurchLine.SETRANGE("POI Item Typ", lrc_PurchLine."POI Item Typ"::"Empties Item");
                    lrc_PurchLine.SETRANGE("Location Code", lrc_PurchEmpties."Location Code");
                    lrc_PurchLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_PurchLine.FIND('-') THEN
                        IF lrc_PurchLine."Quantity Received" = 0 THEN
                            lrc_PurchLine.DELETE(TRUE);
                END;


                // -----------------------------------------------------------------------------
                // Leergutannahme
                // -----------------------------------------------------------------------------
                IF lrc_PurchEmpties."Ship. Quantity" > 0 THEN BEGIN

                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETRANGE("No.", lrc_PurchEmpties."Item No.");
                    lrc_PurchLine.SETRANGE("POI Item Typ", lrc_PurchLine."POI Item Typ"::"Empties Item");
                    lrc_PurchLine.SETRANGE("Location Code", lrc_PurchEmpties."Location Code");
                    lrc_PurchLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_PurchLine.FIND('-') THEN BEGIN
                        lrc_PurchLine.VALIDATE(Quantity, (lrc_PurchEmpties."Ship. Quantity" * -1));
                        lrc_PurchLine.MODIFY();
                    END ELSE BEGIN
                        lrc_PurchLine.RESET();
                        lrc_PurchLine.INIT();
                        lrc_PurchLine."Document Type" := vrc_PurchHeader."Document Type";
                        lrc_PurchLine."Document No." := vrc_PurchHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_PurchLine."Line No." := lin_LineNo;
                        lrc_PurchLine.INSERT(TRUE);
                        lrc_PurchLine.VALIDATE(Type, lrc_PurchLine.Type::Item);
                        lrc_PurchLine.VALIDATE("No.", lrc_PurchEmpties."Item No.");
                        lrc_PurchLine.VALIDATE("Location Code", lrc_PurchEmpties."Location Code");

                        // LVW 007 FV400020.s
                        // lrc_PurchLine.VALIDATE(Quantity,(lrc_PurchEmpties."Ship. Quantity" * -1));

                        ldc_QuantityToReceive := lrc_PurchEmpties."Ship. Qty. to Ship";
                        ldc_QuantityToInvoice := lrc_PurchEmpties."Ship. Qty. to Invoice";

                        lrc_PurchLine.VALIDATE("Line Discount %", 0);
                        lrc_PurchLine.VALIDATE("Allow Invoice Disc.", FALSE);

                        IF (lrc_PurchEmpties."Ship. Qty. to Ship" = 0) AND
                           (lrc_PurchEmpties."Ship. Qty. to Invoice" = 0) THEn
                            ldc_Quantity := 0
                        ELSE
                            IF (lrc_PurchEmpties."Ship. Qty. to Ship" > lrc_PurchEmpties."Ship. Qty. to Invoice") THEN
                                ldc_Quantity := lrc_PurchEmpties."Ship. Qty. to Ship"
                            ELSE
                                ldc_Quantity := lrc_PurchEmpties."Ship. Qty. to Invoice";

                        IF (lrc_PurchEmpties."Document Type" = lrc_PurchEmpties."Document Type"::"Credit Memo") OR
                           (lrc_PurchEmpties."Document Type" = lrc_PurchEmpties."Document Type"::"Return Order") THEN BEGIN
                            ldc_Quantity := ldc_Quantity;
                            ldc_QuantityToReceive := ldc_QuantityToReceive;
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice;
                        END ELSE BEGIN
                            ldc_Quantity := ldc_Quantity * (-1);
                            ldc_QuantityToReceive := ldc_QuantityToReceive * (-1);
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice * (-1);
                        END;

                        lrc_PurchLine.VALIDATE(Quantity);
                        IF lrc_PurchLine."Qty. to Receive" <> ldc_QuantityToReceive THEN
                            lrc_PurchLine.VALIDATE(Quantity, lrc_PurchLine."Quantity Received" + ldc_QuantityToReceive);
                        lrc_PurchLine.VALIDATE("Qty. to Invoice", ldc_QuantityToInvoice);
                        IF lrc_PurchEmpties."Empties Allocation" =
                           lrc_PurchEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                            lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)", 0)
                        ELSE BEGIN
                            lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)", lrc_PurchEmpties."Ship. Refund Price");
                            lrc_PurchLine.ADF_CalcMarketUnitPrice();
                        END;
                        lrc_PurchLine.MODIFY();
                    END;
                END ELSE BEGIN
                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETRANGE("No.", lrc_PurchEmpties."Item No.");
                    lrc_PurchLine.SETRANGE("POI Item Typ", lrc_PurchLine."POI Item Typ"::"Empties Item");
                    lrc_PurchLine.SETRANGE("Location Code", lrc_PurchEmpties."Location Code");
                    lrc_PurchLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_PurchLine.FIND('-') THEN
                        IF lrc_PurchLine."Quantity Received" = 0 THEN
                            lrc_PurchLine.DELETE(TRUE);
                END;

            UNTIL lrc_PurchEmpties.next() = 0
        ELSE BEGIN
            lrc_PurchEmpties.SETRANGE("Empties Calculation", lrc_PurchEmpties."Empties Calculation"::"Same Document");
            IF lrc_PurchEmpties.FIND('-') THEN
                REPEAT
                    // -----------------------------------------------------------------------------
                    // Transportmittel
                    // -----------------------------------------------------------------------------
                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETRANGE("No.", lrc_PurchEmpties."Item No.");
                    lrc_PurchLine.SETRANGE("POI Item Typ", lrc_PurchLine."POI Item Typ"::"Empties Item");
                    lrc_PurchLine.SETRANGE("Location Code", lrc_PurchEmpties."Location Code");
                    lrc_PurchLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_PurchLine.FIND('-') THEn
                        IF lrc_PurchLine."Quantity Received" = 0 THEN
                            lrc_PurchLine.DELETE(TRUE);
                    // -----------------------------------------------------------------------------
                    // Leergutannahme
                    // -----------------------------------------------------------------------------
                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETRANGE("No.", lrc_PurchEmpties."Item No.");
                    lrc_PurchLine.SETRANGE("POI Item Typ", lrc_PurchLine."POI Item Typ"::"Empties Item");
                    lrc_PurchLine.SETRANGE("Location Code", lrc_PurchEmpties."Location Code");
                    lrc_PurchLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_PurchLine.FIND('-') THEN
                        IF lrc_PurchLine."Quantity Received" = 0 THEN
                            lrc_PurchLine.DELETE(TRUE);
                UNTIL lrc_PurchEmpties.next() = 0;
        END;
    end;

    procedure EmCreatePurchLinesTranspItems(vrc_PurchHeader: Record "Purchase Header")
    var
        //lrc_FruitVisionSetup: Record "POI ADF Setup";
        //lrc_Item: Record Item;
        //lco_EmptiesItemNo: Code[20];
        lin_LineNo: Integer;
        //lbn_NeuLaden: Boolean;
        ldc_QuantityToReceive: Decimal;
        ldc_QuantityToInvoice: Decimal;
        ldc_Quantity: Decimal;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Erstellung der Einkaufszeilen Tranportartikel
        // -----------------------------------------------------------------------------

        // Einkaufszeilen anlegen
        lin_LineNo := EmEmptiesTranspStartLineNo();
        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
        IF lrc_PurchLine.FINDLAST() THEN
            lin_LineNo := lrc_PurchLine."Line No.";

        lrc_PurchEmpties.RESET();
        lrc_PurchEmpties.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchEmpties.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchEmpties.SETRANGE("Item Typ", lrc_PurchEmpties."Item Typ"::"Transport Item");
        lrc_PurchEmpties.SETRANGE(Source, lrc_PurchEmpties.Source::Vendor);
        lrc_PurchEmpties.SETRANGE("Source No.", vrc_PurchHeader."Buy-from Vendor No.");
        lrc_PurchEmpties.SETFILTER("Empties Allocation", '%1|%2',
                                   lrc_PurchEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice",
                                   lrc_PurchEmpties."Empties Allocation"::"With Stock-Keeping With Invoice");
        lrc_PurchEmpties.SETRANGE("Empties Calculation", lrc_PurchEmpties."Empties Calculation"::"Same Document");
        IF lrc_PurchEmpties.FINDSET(TRUE, FALSE) THEN
            REPEAT

                // -----------------------------------------------------------------------------
                // Transportmittel
                // -----------------------------------------------------------------------------
                IF lrc_PurchEmpties."Rec. Quantity" > 0 THEN BEGIN

                    IF (lrc_PurchEmpties."Rec. Created Line No." = 0) OR
                       ((lrc_PurchEmpties."Rec. Created Line No." > 0) AND
                        (NOT lrc_PurchLine.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."No.",
                                               lrc_PurchEmpties."Rec. Created Line No."))) THEN BEGIN
                        lrc_PurchLine.RESET();
                        lrc_PurchLine.INIT();
                        lrc_PurchLine."Document Type" := vrc_PurchHeader."Document Type";
                        lrc_PurchLine."Document No." := vrc_PurchHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_PurchLine."Line No." := lin_LineNo;
                        lrc_PurchLine.INSERT(TRUE);
                        lrc_PurchLine.VALIDATE(Type, lrc_PurchLine.Type::Item);
                        lrc_PurchLine.VALIDATE("No.", lrc_PurchEmpties."Item No.");
                        lrc_PurchLine.VALIDATE("Location Code", lrc_PurchEmpties."Location Code");
                        lrc_PurchLine.VALIDATE("Line Discount %", 0);
                        lrc_PurchLine.VALIDATE("Allow Invoice Disc.", FALSE);
                    END;

                    ldc_QuantityToReceive := lrc_PurchEmpties."Rec. Qty. to Receive";
                    ldc_QuantityToInvoice := lrc_PurchEmpties."Rec. Qty. to Invoice";

                    IF (lrc_PurchEmpties."Rec. Qty. to Receive" = 0) AND
                       (lrc_PurchEmpties."Rec. Qty. to Invoice" = 0) THEN
                        ldc_Quantity := 0
                    ELSE
                        IF (lrc_PurchEmpties."Rec. Qty. to Receive" > lrc_PurchEmpties."Rec. Qty. to Invoice") THEN
                            ldc_Quantity := lrc_PurchEmpties."Rec. Qty. to Receive"
                        ELSE
                            ldc_Quantity := lrc_PurchEmpties."Rec. Qty. to Invoice";



                    IF (lrc_PurchEmpties."Document Type" = lrc_PurchEmpties."Document Type"::"Credit Memo") OR
                       (lrc_PurchEmpties."Document Type" = lrc_PurchEmpties."Document Type"::"Return Order") THEN BEGIN
                        ldc_Quantity := ldc_Quantity * (-1);
                        ldc_QuantityToReceive := ldc_QuantityToReceive * (-1);
                        ldc_QuantityToInvoice := ldc_QuantityToInvoice * (-1);
                    END ELSE BEGIN
                        ldc_Quantity := ldc_Quantity;
                        ldc_QuantityToReceive := ldc_QuantityToReceive;
                        ldc_QuantityToInvoice := ldc_QuantityToInvoice;
                    END;

                    lrc_PurchLine.VALIDATE(Quantity);
                    IF lrc_PurchLine."Qty. to Receive" <> ldc_QuantityToReceive THEN
                        lrc_PurchLine.VALIDATE(Quantity, lrc_PurchLine."Quantity Received" + ldc_QuantityToReceive);
                    lrc_PurchLine.VALIDATE("Qty. to Invoice", ldc_QuantityToInvoice);

                    IF lrc_PurchEmpties."Empties Allocation" =
                      lrc_PurchEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                        lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)", 0)
                    ELSE BEGIN
                        lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)", lrc_PurchEmpties."Rec. Refund Price");
                        lrc_PurchLine.ADF_CalcMarketUnitPrice();
                    END;

                    lrc_PurchLine.MODIFY();

                    // Zeilennummer zurückschreiben
                    lrc_PurchEmpties."Rec. Created Line No." := lrc_PurchLine."Line No.";
                    lrc_PurchEmpties.MODIFY();

                END ELSE
                    IF lrc_PurchEmpties."Rec. Created Line No." <> 0 THEN
                        IF lrc_PurchLine.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."No.",
                                             lrc_PurchEmpties."Rec. Created Line No.") THEN BEGIN
                            // Zeilennummer löschen
                            lrc_PurchLine.DELETE(TRUE);
                            // Zeilennummer auf Null setzen
                            lrc_PurchEmpties."Rec. Created Line No." := 0;
                            lrc_PurchEmpties.MODIFY();
                        END;


                // -----------------------------------------------------------------------------
                // Leergutannahme
                // -----------------------------------------------------------------------------
                IF lrc_PurchEmpties."Ship. Quantity" > 0 THEN BEGIN

                    IF (lrc_PurchEmpties."Ship. Created Line No." = 0) OR
                       ((lrc_PurchEmpties."Ship. Created Line No." > 0) AND
                        (NOT lrc_PurchLine.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."No.",
                                               lrc_PurchEmpties."Ship. Created Line No."))) THEN BEGIN
                        lrc_PurchLine.RESET();
                        lrc_PurchLine.INIT();
                        lrc_PurchLine."Document Type" := vrc_PurchHeader."Document Type";
                        lrc_PurchLine."Document No." := vrc_PurchHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_PurchLine."Line No." := lin_LineNo;
                        lrc_PurchLine.INSERT(TRUE);
                        lrc_PurchLine.VALIDATE(Type, lrc_PurchLine.Type::Item);
                        lrc_PurchLine.VALIDATE("No.", lrc_PurchEmpties."Item No.");
                        lrc_PurchLine.VALIDATE("Location Code", lrc_PurchEmpties."Location Code");
                        lrc_PurchLine.VALIDATE("Line Discount %", 0);
                        lrc_PurchLine.VALIDATE("Allow Invoice Disc.", FALSE);
                    END;

                    ldc_QuantityToReceive := lrc_PurchEmpties."Ship. Qty. to Ship";
                    ldc_QuantityToInvoice := lrc_PurchEmpties."Ship. Qty. to Invoice";


                    IF (lrc_PurchEmpties."Ship. Qty. to Ship" = 0) AND
                       (lrc_PurchEmpties."Ship. Qty. to Invoice" = 0) THEN
                        ldc_Quantity := 0
                    ELSE
                        IF (lrc_PurchEmpties."Ship. Qty. to Ship" > lrc_PurchEmpties."Ship. Qty. to Invoice") THEN
                            ldc_Quantity := lrc_PurchEmpties."Ship. Qty. to Ship"
                        ELSE
                            ldc_Quantity := lrc_PurchEmpties."Ship. Qty. to Invoice";


                    IF (lrc_PurchEmpties."Document Type" = lrc_PurchEmpties."Document Type"::"Credit Memo") OR
                       (lrc_PurchEmpties."Document Type" = lrc_PurchEmpties."Document Type"::"Return Order") THEN BEGIN
                        ldc_Quantity := ldc_Quantity;
                        ldc_QuantityToReceive := ldc_QuantityToReceive;
                        ldc_QuantityToInvoice := ldc_QuantityToInvoice;
                    END ELSE BEGIN
                        ldc_Quantity := ldc_Quantity * (-1);
                        ldc_QuantityToReceive := ldc_QuantityToReceive * (-1);
                        ldc_QuantityToInvoice := ldc_QuantityToInvoice * (-1);
                    END;

                    lrc_PurchLine.VALIDATE(Quantity);
                    IF lrc_PurchLine."Qty. to Receive" <> ldc_QuantityToReceive THEN
                        lrc_PurchLine.VALIDATE(Quantity, lrc_PurchLine."Quantity Received" + ldc_QuantityToReceive);
                    lrc_PurchLine.VALIDATE("Qty. to Invoice", ldc_QuantityToInvoice);
                    IF lrc_PurchEmpties."Empties Allocation" =
                       lrc_PurchEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                        lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)", 0)
                    ELSE BEGIN
                        lrc_PurchLine.VALIDATE("POI Purch. Price (Price Base)", lrc_PurchEmpties."Ship. Refund Price");
                        lrc_PurchLine.ADF_CalcMarketUnitPrice();
                    END;
                    lrc_PurchLine.MODIFY();

                    // Zeilennummer zurückschreiben
                    lrc_PurchEmpties."Ship. Created Line No." := lrc_PurchLine."Line No.";
                    lrc_PurchEmpties.MODIFY();

                END ELSE

                    IF lrc_PurchEmpties."Ship. Created Line No." <> 0 THEN
                        IF lrc_PurchLine.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."No.",
                                             lrc_PurchEmpties."Ship. Created Line No.") THEN BEGIN
                            // Zeilennummer löschen
                            lrc_PurchLine.DELETE(TRUE);
                            // Zeilennummer auf Null setzen
                            lrc_PurchEmpties."Ship. Created Line No." := 0;
                            lrc_PurchEmpties.MODIFY();
                        END;
            UNTIL lrc_PurchEmpties.next() = 0
        ELSE BEGIN
            lrc_PurchEmpties.SETRANGE("Empties Calculation", lrc_PurchEmpties."Empties Calculation"::"Same Document");
            IF lrc_PurchEmpties.FIND('-') THEN
                REPEAT
                    // -----------------------------------------------------------------------------
                    // Transportmittel
                    // -----------------------------------------------------------------------------
                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETRANGE("No.", lrc_PurchEmpties."Item No.");
                    lrc_PurchLine.SETRANGE("POI Item Typ", lrc_PurchLine."POI Item Typ"::"Transport Item");
                    lrc_PurchLine.SETRANGE("Location Code", lrc_PurchEmpties."Location Code");
                    lrc_PurchLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_PurchLine.FIND('-') THEN
                        IF lrc_PurchLine."Quantity Received" = 0 THEN
                            lrc_PurchLine.DELETE(TRUE);
                    // -----------------------------------------------------------------------------
                    // Leergutannahme
                    // -----------------------------------------------------------------------------
                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
                    lrc_PurchLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETRANGE("No.", lrc_PurchEmpties."Item No.");
                    lrc_PurchLine.SETRANGE("POI Item Typ", lrc_PurchLine."POI Item Typ"::"Transport Item");
                    lrc_PurchLine.SETRANGE("Location Code", lrc_PurchEmpties."Location Code");
                    lrc_PurchLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_PurchLine.FIND('-') THEN
                        IF lrc_PurchLine."Quantity Received" = 0 THEN
                            lrc_PurchLine.DELETE(TRUE);
                UNTIL lrc_PurchEmpties.next() = 0;
        END;
    end;

    procedure EmPurchGetPrices(var rrc_RefundCosts: Record "POI Empties/Transport Ref Cost"; vrc_PurchHeader: Record "Purchase Header"; vrc_Vendor: Record Vendor; vco_ItemNo: Code[20])
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Preise Einkaufspreise Leergut/Transportmittel
        // -----------------------------------------------------------------------------

        // Keine Berechnung an Kreditor
        IF vrc_Vendor."POI Empties Allocation" <> vrc_Vendor."POI Empties Allocation"::"With Stock-Keeping With Invoice" THEN BEGIN
            rrc_RefundCosts.RESET();
            rrc_RefundCosts.INIT();
            EXIT;
        END;

        // Preis Kreditor suchen
        rrc_RefundCosts.RESET();
        rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
        rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::Vendor);
        rrc_RefundCosts.SETRANGE("Source No.", vrc_Vendor."No.");
        rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
        rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
        IF rrc_RefundCosts.FINDLAST() THEN
            EXIT;

        // Preis Unternehmenskette suchen
        IF vrc_Vendor."POI Chain Name" <> '' THEN BEGIN
            rrc_RefundCosts.RESET();
            rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
            rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::"Company Chain");
            rrc_RefundCosts.SETRANGE("Source No.", vrc_Vendor."POI Chain Name");
            rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
            rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
            IF rrc_RefundCosts.FINDLAST() THEN
                EXIT;
        END;

        // Preis Leergutpreisgruppe suchen
        IF vrc_Vendor."POI Empties Price Group" <> '' THEN BEGIN
            rrc_RefundCosts.RESET();
            rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
            rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::"Empties Price Group");
            rrc_RefundCosts.SETRANGE("Source No.", vrc_Vendor."POI Empties Price Group");
            rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
            rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
            IF rrc_RefundCosts.FINDLAST() THEN
                EXIT;
        END;

        // Preis Kreditor allgemein
        rrc_RefundCosts.RESET();
        rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
        rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::Vendor);
        rrc_RefundCosts.SETRANGE("Source No.", '');
        rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
        rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
        IF rrc_RefundCosts.FINDLAST() THEN
            EXIT;

        // Preis Einkauf Global suchen
        rrc_RefundCosts.RESET();
        rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
        rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::"Purchase Global");
        rrc_RefundCosts.SETRANGE("Source No.", '');
        rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
        rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_PurchHeader."Expected Receipt Date", 0D);
        IF rrc_RefundCosts.FINDLAST() THEN
            EXIT;

        rrc_RefundCosts.RESET();
        rrc_RefundCosts.INIT();
        EXIT;
    end;

    procedure EmEmptiesTranspStartLineNo(): Integer
    begin
        EXIT(9000000);
    end;

    procedure EmSalesShowTransportEmpties(vrc_SalesHeader: Record "Sales Header"; vbn_TransportItems: Boolean; vbn_EmptyItems: Boolean)
    var
        lrc_SalesDocType: Record "POI Sales Doc. Subtype";
    //lrc_FruitvisionSetup: Record "POI ADF Setup";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Anzeige der Transportartikel und Leergutartikel
        // -----------------------------------------------------------------------------

        // Kontrolle ob Formularnummer für Belegunterart eingetragen ist
        lrc_SalesDocType.GET(vrc_SalesHeader."Document Type", vrc_SalesHeader."POI Sales Doc. Subtype Code");
        lrc_SalesDocType.TESTFIELD("Form ID Empties Card");

        // Transportartikel laden
        IF vbn_TransportItems = TRUE THEN
            EmSalesLoadTransportItems(vrc_SalesHeader);
        // Leergutartikel laden
        IF vbn_EmptyItems = TRUE THEN
            EmSalesLoadEmptiesItems(vrc_SalesHeader);
        COMMIT();

        lrc_SalesEmpties.RESET();
        lrc_SalesEmpties.FILTERGROUP(2);
        lrc_SalesEmpties.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesEmpties.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesEmpties.FILTERGROUP(0);
        Page.RUNMODAL(lrc_SalesDocType."Form ID Empties Card", lrc_SalesEmpties);

        // Transportmittelartikel anlegen
        IF vbn_TransportItems = TRUE THEN
            EmCreateSalesLinesTranspItems(vrc_SalesHeader);
        // Leergutartikel anlegen
        IF vbn_EmptyItems = TRUE THEN
            EmCreateSalesLinesEmptiesItems(vrc_SalesHeader);
    end;

    procedure EmSalesLoadTransportItems(vrc_SalesHeader: Record "Sales Header")
    var
        //lrc_Location: Record Location;
        lrc_Customer: Record Customer;
        lrc_ShipmentMethod: Record "Shipment Method";
        //lco_EmptiesLocationCode: Code[10];
        lbn_TransportmittelGeladen: Boolean;
    //lbn_TransportItemShippingAgent: Boolean;

    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Laden der Transportartikel
        // -----------------------------------------------------------------------------

        vrc_SalesHeader.TESTFIELD("Sell-to Customer No.");
        vrc_SalesHeader.TESTFIELD("Location Code");
        lrc_Customer.GET(vrc_SalesHeader."Sell-to Customer No.");


        // Kontrolle ob die Transportmittel bereits geladen sind
        lbn_TransportmittelGeladen := FALSE;
        lrc_SalesEmpties.RESET();
        lrc_SalesEmpties.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesEmpties.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesEmpties.SETRANGE("Item Typ", lrc_SalesEmpties."Item Typ"::"Transport Item");
        IF NOT lrc_SalesEmpties.FIND('-') THEN BEGIN

            // Alle zulässigen Transportmittel für den Debitoren laden
            IF lbn_TransportmittelGeladen = FALSE THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::Customer);
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", vrc_SalesHeader."Sell-to Customer No.");
                lrc_VendCustShipAgentEmpties.SETRANGE("Item Typ", lrc_VendCustShipAgentEmpties."Item Typ"::"Transport Item");
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    lbn_TransportmittelGeladen := TRUE;
            END;
            // Alle zulässigen Transportmittel für die Unternehmenskette laden
            IF (lbn_TransportmittelGeladen = FALSE) AND (lrc_Customer."Chain Name" <> '') THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Company Chain");
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", lrc_Customer."Chain Name");
                lrc_VendCustShipAgentEmpties.SETRANGE("Item Typ", lrc_VendCustShipAgentEmpties."Item Typ"::"Transport Item");
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    lbn_TransportmittelGeladen := TRUE;
            END;
            // Alle zulässigen Transportmittel Global laden
            IF lbn_TransportmittelGeladen = FALSE THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Sales Global");
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", '');
                lrc_VendCustShipAgentEmpties.SETRANGE("Item Typ", lrc_VendCustShipAgentEmpties."Item Typ"::"Transport Item");
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    lbn_TransportmittelGeladen := TRUE;
            END;

            IF lbn_TransportmittelGeladen = TRUE THEN
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    REPEAT
                        lrc_SalesEmpties.RESET();
                        lrc_SalesEmpties.INIT();
                        lrc_SalesEmpties."Document Type" := vrc_SalesHeader."Document Type";
                        lrc_SalesEmpties."Document No." := vrc_SalesHeader."No.";
                        lrc_SalesEmpties.Source := lrc_SalesEmpties.Source::Customer;
                        lrc_SalesEmpties."Source No." := vrc_SalesHeader."Sell-to Customer No.";
                        lrc_SalesEmpties.VALIDATE("Item No.", lrc_VendCustShipAgentEmpties."Item No.");
                        lrc_SalesEmpties.VALIDATE("Location Code", vrc_SalesHeader."Location Code");
                        lrc_SalesEmpties."Line No." := 0;
                        // Abrechnung immer über Debitor
                        lrc_SalesEmpties."Empties Allocation" := lrc_Customer."POI Empties Allocation";
                        lrc_SalesEmpties."Empties Calculation" := lrc_Customer."POI Empties Calculation";

                        EmSalesGetPrices(lrc_RefundCosts, vrc_SalesHeader, lrc_Customer, lrc_SalesEmpties."Item No.");
                        lrc_SalesEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                        lrc_SalesEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");

                        lrc_SalesEmpties.INSERT(TRUE);
                    UNTIL lrc_VendCustShipAgentEmpties.next() = 0;
            // ------------------------------------------------------------------------------------
            // Transportmittel mit den Transportmitteln des Zustellers vervollständigen, aber nur,
            // wenn die Lieferbedingung nicht als Selbstabholer markiert ist
            // ------------------------------------------------------------------------------------
            lrc_ShipmentMethod."POI Self-Collector" := FALSE;
            IF vrc_SalesHeader."Shipment Method Code" <> '' THEN
                lrc_ShipmentMethod.GET(vrc_SalesHeader."Shipment Method Code");
            IF lrc_ShipmentMethod."POI Self-Collector" = FALSE THEN
                IF vrc_SalesHeader."Shipping Agent Code" <> '' THEN BEGIN
                    lrc_VendCustShipAgentEmpties.RESET();
                    lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Shipping Agent");
                    lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", vrc_SalesHeader."Shipping Agent Code");
                    lrc_VendCustShipAgentEmpties.SETRANGE("Item Typ", lrc_VendCustShipAgentEmpties."Item Typ"::"Transport Item");
                    IF lrc_VendCustShipAgentEmpties.FIND('-') THEN BEGIN
                        lbn_TransportmittelGeladen := TRUE;
                        REPEAT
                            //-------------------------------------------------------------------------------------------
                            // Zeile einfügen nur, wenn solcher Artikel dem vrc_SalesHeader noch nicht zugewiesen ist
                            //-------------------------------------------------------------------------------------------
                            lrc_SalesEmpties.RESET();
                            lrc_SalesEmpties.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                            lrc_SalesEmpties.SETRANGE("Document No.", vrc_SalesHeader."No.");
                            lrc_SalesEmpties.SETRANGE("Item Typ", lrc_SalesEmpties."Item Typ"::"Transport Item");
                            lrc_SalesEmpties.SETRANGE("Item No.", lrc_VendCustShipAgentEmpties."Item No.");
                            IF NOT lrc_SalesEmpties.FIND('-') THEN BEGIN
                                lrc_SalesEmpties.INIT();
                                lrc_SalesEmpties."Document Type" := vrc_SalesHeader."Document Type";
                                lrc_SalesEmpties."Document No." := vrc_SalesHeader."No.";
                                lrc_SalesEmpties.Source := lrc_SalesEmpties.Source::"Shipping Agent";
                                lrc_SalesEmpties."Source No." := vrc_SalesHeader."Shipping Agent Code";
                                lrc_SalesEmpties.VALIDATE("Item No.", lrc_VendCustShipAgentEmpties."Item No.");
                                lrc_SalesEmpties.VALIDATE("Location Code", vrc_SalesHeader."Location Code");
                                lrc_SalesEmpties."Line No." := 0;
                                // Abrechnung immer über Debitor
                                lrc_SalesEmpties."Empties Allocation" := lrc_Customer."POI Empties Allocation";
                                lrc_SalesEmpties."Empties Calculation" := lrc_Customer."POI Empties Calculation";

                                EmSalesGetPrices(lrc_RefundCosts, vrc_SalesHeader, lrc_Customer, lrc_SalesEmpties."Item No.");
                                lrc_SalesEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                                lrc_SalesEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");

                                lrc_SalesEmpties.INSERT(TRUE);

                            END;
                        UNTIL lrc_VendCustShipAgentEmpties.next() = 0;
                    END;
                END;

            // Alle Transportmittel aus dem Artikelstamm laden
            IF lbn_TransportmittelGeladen = FALSE THEN BEGIN
                lrc_Item.RESET();
                lrc_Item.SETCURRENTKEY("POI Item Typ", Blocked);
                lrc_Item.SETRANGE("POI Item Typ", lrc_Item."POI Item Typ"::"Transport Item");
                lrc_Item.SETRANGE(Blocked, FALSE);
                IF lrc_Item.FIND('-') THEN BEGIN
                    REPEAT
                        lrc_SalesEmpties.RESET();
                        lrc_SalesEmpties.INIT();
                        lrc_SalesEmpties."Document Type" := vrc_SalesHeader."Document Type";
                        lrc_SalesEmpties."Document No." := vrc_SalesHeader."No.";
                        lrc_SalesEmpties.Source := lrc_SalesEmpties.Source::Customer;
                        lrc_SalesEmpties."Source No." := vrc_SalesHeader."Sell-to Customer No.";
                        lrc_SalesEmpties.VALIDATE("Item No.", lrc_Item."No.");
                        lrc_SalesEmpties.VALIDATE("Location Code", vrc_SalesHeader."Location Code");
                        lrc_SalesEmpties."Line No." := 0;
                        // Abrechnung immer über Debitor
                        lrc_SalesEmpties."Empties Allocation" := lrc_Customer."POI Empties Allocation";
                        lrc_SalesEmpties."Empties Calculation" := lrc_Customer."POI Empties Calculation";

                        EmSalesGetPrices(lrc_RefundCosts, vrc_SalesHeader, lrc_Customer, lrc_SalesEmpties."Item No.");
                        lrc_SalesEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                        lrc_SalesEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");

                        lrc_SalesEmpties.INSERT(TRUE);
                    UNTIL lrc_Item.next() = 0;
                    lbn_TransportmittelGeladen := TRUE;
                END;
            END;

            // Alle Werte auf Null setzen
        END ELSE BEGIN
            REPEAT
                lrc_SalesEmpties."Ship. Calc. Quantity" := 0;
                lrc_SalesEmpties."Rec. Calc. Quantity" := 0;
                IF lrc_SalesEmpties."Empties Calculation" = lrc_SalesEmpties."Empties Calculation"::"Same Document" THEN BEGIN
                    lrc_SalesEmpties."Ship. Quantity" := 0;
                    lrc_SalesEmpties."Ship. Qty. to Ship" := 0;
                    lrc_SalesEmpties."Ship. Qty. Shipped" := 0;
                    lrc_SalesEmpties."Ship. Qty. to Invoice" := 0;
                    lrc_SalesEmpties."Ship. Qty. Invoiced" := 0;
                    lrc_SalesEmpties."Ship. Qty. to Transfer" := 0;
                    lrc_SalesEmpties."Ship. Qty. Transfered" := 0;
                    lrc_SalesEmpties."Rec. Quantity" := 0;
                    lrc_SalesEmpties."Rec. Qty. to Receive" := 0;
                    lrc_SalesEmpties."Rec. Qty. Received" := 0;
                    lrc_SalesEmpties."Rec. Qty. to Invoice" := 0;
                    lrc_SalesEmpties."Rec. Qty. Invoiced" := 0;
                    lrc_SalesEmpties."Rec. Qty. to Transfer" := 0;
                    lrc_SalesEmpties."Rec. Qty. Transfered" := 0;
                END;
                lrc_SalesEmpties.MODIFY();
            UNTIL lrc_SalesEmpties.next() = 0;
            lbn_TransportmittelGeladen := TRUE;
        END;

        // ---------------------------------------------------------------------------------
        // Mengen aus Verkaufszeilen laden
        // ---------------------------------------------------------------------------------
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETCURRENTKEY("Document Type", "Document No.", Type, "No.", "POI Subtyp", "POI Item Typ");
        lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETFILTER("No.", '<>%1', '');
        lrc_SalesLine.SETRANGE("POI Subtyp", lrc_SalesLine."POI Subtyp"::"Refund Empties");
        lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Transport Item");
        IF lrc_SalesLine.FIND('-') THEN
            REPEAT

                IF (lrc_SalesLine.Quantity = 0) AND (lrc_SalesLine."Quantity Shipped" = 0) THEN
                    lrc_SalesLine.DELETE(TRUE)
                ELSE BEGIN
                    lrc_SalesEmpties.RESET();
                    lrc_SalesEmpties.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesEmpties.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesEmpties.SETRANGE("Item Typ", lrc_SalesEmpties."Item Typ"::"Transport Item");
                    lrc_SalesEmpties.SETRANGE("Item No.", lrc_SalesLine."No.");
                    lrc_SalesEmpties.SETRANGE("Location Code", lrc_SalesLine."Location Code");
                    IF NOT lrc_SalesEmpties.FIND('-') THEN BEGIN
                        lrc_SalesEmpties.RESET();
                        lrc_SalesEmpties.INIT();
                        lrc_SalesEmpties."Document Type" := vrc_SalesHeader."Document Type";
                        lrc_SalesEmpties."Document No." := vrc_SalesHeader."No.";
                        lrc_SalesEmpties.Source := lrc_SalesEmpties.Source::Customer;
                        lrc_SalesEmpties."Source No." := vrc_SalesHeader."Sell-to Customer No.";
                        lrc_SalesEmpties.VALIDATE("Item No.", lrc_SalesLine."No.");
                        lrc_SalesEmpties.VALIDATE("Location Code", lrc_SalesLine."Location Code");
                        lrc_SalesEmpties."Line No." := 0;
                        // Abrechnung immer über Debitor
                        lrc_SalesEmpties."Empties Allocation" := lrc_Customer."POI Empties Allocation";
                        lrc_SalesEmpties."Empties Calculation" := lrc_Customer."POI Empties Calculation";
                        EmSalesGetPrices(lrc_RefundCosts, vrc_SalesHeader, lrc_Customer, lrc_SalesEmpties."Item No.");
                        lrc_SalesEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                        lrc_SalesEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");
                        lrc_SalesEmpties.INSERT(TRUE);
                    END;
                    IF lrc_SalesLine.Quantity > 0 THEN BEGIN
                        lrc_SalesEmpties.VALIDATE("Ship. Quantity", lrc_SalesEmpties."Ship. Quantity" + lrc_SalesLine.Quantity);
                        lrc_SalesEmpties.VALIDATE("Ship. Qty. Shipped",
                                                  (lrc_SalesEmpties."Ship. Qty. Shipped" + lrc_SalesLine."Quantity Shipped"));
                        lrc_SalesEmpties.VALIDATE("Ship. Qty. Invoiced",
                                                  (lrc_SalesEmpties."Ship. Qty. Invoiced" + lrc_SalesLine."Quantity Invoiced"));
                        lrc_SalesEmpties.MODIFY();
                    END;
                    IF lrc_SalesLine.Quantity < 0 THEN BEGIN
                        lrc_SalesEmpties.VALIDATE("Rec. Quantity", lrc_SalesEmpties."Rec. Quantity" + (-lrc_SalesLine.Quantity));
                        lrc_SalesEmpties.VALIDATE("Rec. Qty. Received",
                           lrc_SalesEmpties."Rec. Qty. Received" + (-lrc_SalesLine."Quantity Shipped"));
                        lrc_SalesEmpties.VALIDATE("Rec. Qty. Invoiced",
                           lrc_SalesEmpties."Rec. Qty. Invoiced" + (-lrc_SalesLine."Quantity Invoiced"));
                        lrc_SalesEmpties.MODIFY();
                    END;
                END;

            UNTIL lrc_SalesLine.next() = 0;
    end;

    procedure EmSalesLoadEmptiesItems(vrc_SalesHeader: Record "Sales Header")
    var
        lrc_Customer: Record Customer;
        lco_EmptiesItemNo: Code[20];
        //lin_LineNo: Integer;
        //lbn_NeuLaden: Boolean;
        lbn_LeergutGeladen: Boolean;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Laden der Leergutartikel auf Basis der verkauften Artikel
        // -----------------------------------------------------------------------------

        vrc_SalesHeader.TESTFIELD("Sell-to Customer No.");
        vrc_SalesHeader.TESTFIELD("Location Code");
        lrc_Customer.GET(vrc_SalesHeader."Sell-to Customer No.");


        // Kontrolle ob die Leergüter bereits geladen sind
        lbn_LeergutGeladen := FALSE;
        lrc_SalesEmpties.RESET();
        lrc_SalesEmpties.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesEmpties.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesEmpties.SETRANGE("Item Typ", lrc_SalesEmpties."Item Typ"::"Empties Item");
        IF NOT lrc_SalesEmpties.FIND('-') THEN BEGIN

            // Alle zulässigen Leergüter für den Debitoren laden
            IF lbn_LeergutGeladen = FALSE THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::Customer);
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", vrc_SalesHeader."Sell-to Customer No.");
                lrc_VendCustShipAgentEmpties.SETRANGE("Item Typ", lrc_VendCustShipAgentEmpties."Item Typ"::"Empties Item");
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    lbn_LeergutGeladen := TRUE;
            END;
            // Alle zulässigen Leergüter für die Unternehmenskette laden
            IF (lbn_LeergutGeladen = FALSE) AND (lrc_Customer."Chain Name" <> '') THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Company Chain");
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", lrc_Customer."Chain Name");
                lrc_VendCustShipAgentEmpties.SETRANGE("Item Typ", lrc_VendCustShipAgentEmpties."Item Typ"::"Empties Item");
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    lbn_LeergutGeladen := TRUE;
            END;
            // Alle zulässigen Leergüter Global laden
            IF lbn_LeergutGeladen = FALSE THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Sales Global");
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", '');
                lrc_VendCustShipAgentEmpties.SETRANGE("Item Typ", lrc_VendCustShipAgentEmpties."Item Typ"::"Empties Item");
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    lbn_LeergutGeladen := TRUE;
            END;

            IF lbn_LeergutGeladen = TRUE THEN
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    REPEAT
                        lrc_SalesEmpties.RESET();
                        lrc_SalesEmpties.INIT();
                        lrc_SalesEmpties."Document Type" := vrc_SalesHeader."Document Type";
                        lrc_SalesEmpties."Document No." := vrc_SalesHeader."No.";
                        lrc_SalesEmpties.Source := lrc_SalesEmpties.Source::Customer;
                        lrc_SalesEmpties."Source No." := vrc_SalesHeader."Sell-to Customer No.";
                        lrc_SalesEmpties.VALIDATE("Item No.", lrc_VendCustShipAgentEmpties."Item No.");
                        lrc_SalesEmpties.VALIDATE("Location Code", vrc_SalesHeader."Location Code");
                        lrc_SalesEmpties."Line No." := 0;

                        // Abrechnung immer über Debitor
                        lrc_SalesEmpties."Empties Allocation" := lrc_Customer."POI Empties Allocation";
                        lrc_SalesEmpties."Empties Calculation" := lrc_Customer."POI Empties Calculation";

                        EmSalesGetPrices(lrc_RefundCosts, vrc_SalesHeader, lrc_Customer, lrc_SalesEmpties."Item No.");
                        lrc_SalesEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                        lrc_SalesEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");

                        lrc_SalesEmpties.INSERT(TRUE);
                    UNTIL lrc_VendCustShipAgentEmpties.next() = 0
                ELSE
                    ERROR('Keine Leergüter gefunden! Trotz Zuordnung!');

            // Alle Werte auf Null setzen
        END ELSE BEGIN
            REPEAT
                lrc_SalesEmpties."Ship. Calc. Quantity" := 0;
                lrc_SalesEmpties."Rec. Calc. Quantity" := 0;
                IF lrc_SalesEmpties."Empties Calculation" = lrc_SalesEmpties."Empties Calculation"::"Same Document" THEN BEGIN
                    lrc_SalesEmpties."Ship. Quantity" := 0;
                    lrc_SalesEmpties."Ship. Qty. to Ship" := 0;
                    lrc_SalesEmpties."Ship. Qty. Shipped" := 0;
                    lrc_SalesEmpties."Ship. Qty. to Invoice" := 0;
                    lrc_SalesEmpties."Ship. Qty. Invoiced" := 0;
                    lrc_SalesEmpties."Ship. Qty. to Transfer" := 0;
                    lrc_SalesEmpties."Ship. Qty. Transfered" := 0;
                    lrc_SalesEmpties."Rec. Quantity" := 0;
                    lrc_SalesEmpties."Rec. Qty. to Receive" := 0;
                    lrc_SalesEmpties."Rec. Qty. Received" := 0;
                    lrc_SalesEmpties."Rec. Qty. to Invoice" := 0;
                    lrc_SalesEmpties."Rec. Qty. Invoiced" := 0;
                    lrc_SalesEmpties."Rec. Qty. to Transfer" := 0;
                    lrc_SalesEmpties."Rec. Qty. Transfered" := 0;
                END;
                lrc_SalesEmpties.MODIFY();
            UNTIL lrc_SalesEmpties.next() = 0;
            lbn_LeergutGeladen := TRUE;
        END;


        // ---------------------------------------------------------------------------
        // Artikel mit Leergut lesen
        // ---------------------------------------------------------------------------
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETFILTER("No.", '<>%1', '');
        lrc_SalesLine.SETFILTER("POI Empties Item No.", '<>%1', '');
        lrc_SalesLine.SETFILTER("POI Empties Quantity", '>%1', 0);
        lrc_SalesLine.SETFILTER("POI Item Typ", '<>%1&<>%2', lrc_SalesLine."POI Item Typ"::"Transport Item",
                                                       lrc_SalesLine."POI Item Typ"::"Empties Item");
        IF lrc_SalesLine.FIND('-') THEN
            REPEAT
                IF (lrc_SalesLine."POI Empties Item No." <> '') AND
                   (lrc_SalesLine."POI Empties Quantity" > 0) THEN BEGIN

                    // Leergutartikelnummer ermitteln
                    lrc_Item.GET(lrc_SalesLine."POI Empties Item No.");
                    IF lrc_Item."POI Empties Posting Item No." <> '' THEN
                        lco_EmptiesItemNo := lrc_Item."POI Empties Posting Item No."
                    ELSE
                        lco_EmptiesItemNo := lrc_Item."No.";

                    lrc_SalesEmpties.RESET();
                    lrc_SalesEmpties.SETRANGE("Document Type", lrc_SalesLine."Document Type");
                    lrc_SalesEmpties.SETRANGE("Document No.", lrc_SalesLine."Document No.");
                    lrc_SalesEmpties.SETRANGE("Item No.", lco_EmptiesItemNo);
                    lrc_SalesEmpties.SETRANGE("Location Code", lrc_SalesLine."Location Code");
                    IF NOT lrc_SalesEmpties.FIND('-') THEN BEGIN
                        lrc_SalesEmpties.RESET();
                        lrc_SalesEmpties.INIT();
                        lrc_SalesEmpties."Document Type" := lrc_SalesLine."Document Type";
                        lrc_SalesEmpties."Document No." := lrc_SalesLine."Document No.";
                        lrc_SalesEmpties.VALIDATE("Item No.", lco_EmptiesItemNo);
                        lrc_SalesEmpties.VALIDATE("Location Code", lrc_SalesLine."Location Code");
                        lrc_SalesEmpties."Line No." := 0;
                        lrc_SalesEmpties.Source := lrc_SalesEmpties.Source::Customer;
                        lrc_SalesEmpties."Source No." := vrc_SalesHeader."Sell-to Customer No.";
                        // Abrechnung immer über Debitor
                        lrc_SalesEmpties."Empties Allocation" := lrc_Customer."POI Empties Allocation";
                        lrc_SalesEmpties."Empties Calculation" := lrc_Customer."POI Empties Calculation";
                        EmSalesGetPrices(lrc_RefundCosts, vrc_SalesHeader, lrc_Customer, lrc_SalesEmpties."Item No.");
                        lrc_SalesEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                        lrc_SalesEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");
                        lrc_SalesEmpties.INSERT(TRUE);
                    END;
                    IF lrc_SalesLine."POI Partial Quantity (PQ)" = FALSE THEN
                        IF lrc_SalesLine.Quantity > 0 THEN
                            lrc_SalesEmpties."Ship. Calc. Quantity" := lrc_SalesEmpties."Ship. Calc. Quantity" +
                                                                       (lrc_SalesLine.Quantity * lrc_SalesLine."POI Empties Quantity")
                        ELSE
                            lrc_SalesEmpties."Rec. Calc. Quantity" := lrc_SalesEmpties."Rec. Calc. Quantity" +
                                                                       (lrc_SalesLine.Quantity * lrc_SalesLine."POI Empties Quantity" * -1);
                    lrc_SalesEmpties.MODIFY();
                END;
            UNTIL lrc_SalesLine.next() = 0;



        // ---------------------------------------------------------------------------
        // Leergutartikel lesen
        // ---------------------------------------------------------------------------
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETFILTER("No.", '<>%1', '');
        lrc_SalesLine.SETFILTER("POI Item Typ", '%1', lrc_SalesLine."POI Item Typ"::"Empties Item");
        IF lrc_SalesLine.FIND('-') THEN
            REPEAT
                lrc_SalesEmpties.RESET();
                lrc_SalesEmpties.SETRANGE("Document Type", lrc_SalesLine."Document Type");
                lrc_SalesEmpties.SETRANGE("Document No.", lrc_SalesLine."Document No.");
                lrc_SalesEmpties.SETRANGE("Item No.", lrc_SalesLine."No.");
                lrc_SalesEmpties.SETRANGE("Location Code", lrc_SalesLine."Location Code");
                IF NOT lrc_SalesEmpties.FIND('-') THEN BEGIN
                    lrc_SalesEmpties.RESET();
                    lrc_SalesEmpties.INIT();
                    lrc_SalesEmpties."Document Type" := lrc_SalesLine."Document Type";
                    lrc_SalesEmpties."Document No." := lrc_SalesLine."Document No.";
                    lrc_SalesEmpties.VALIDATE("Item No.", lrc_SalesLine."No.");
                    lrc_SalesEmpties.VALIDATE("Location Code", lrc_SalesLine."Location Code");
                    lrc_SalesEmpties."Line No." := 0;
                    lrc_SalesEmpties.Source := lrc_SalesEmpties.Source::Customer;
                    lrc_SalesEmpties."Source No." := vrc_SalesHeader."Sell-to Customer No.";
                    // Abrechnung immer über Debitor
                    lrc_SalesEmpties."Empties Allocation" := lrc_Customer."POI Empties Allocation";
                    lrc_SalesEmpties."Empties Calculation" := lrc_Customer."POI Empties Calculation";
                    EmSalesGetPrices(lrc_RefundCosts, vrc_SalesHeader, lrc_Customer, lrc_SalesEmpties."Item No.");
                    lrc_SalesEmpties.VALIDATE("Ship. Refund Price", lrc_RefundCosts."Shipment Price (LCY)");
                    lrc_SalesEmpties.VALIDATE("Rec. Refund Price", lrc_RefundCosts."Receipt Price (LCY)");
                    lrc_SalesEmpties.INSERT(TRUE);
                END;
                IF lrc_SalesLine.Quantity > 0 THEN BEGIN
                    lrc_SalesEmpties.VALIDATE("Ship. Quantity", lrc_SalesEmpties."Ship. Quantity" +
                                                         lrc_SalesLine.Quantity);
                    lrc_SalesEmpties.VALIDATE("Ship. Qty. Shipped", lrc_SalesEmpties."Ship. Qty. Shipped" +
                                                             lrc_SalesLine."Quantity Shipped");
                    lrc_SalesEmpties.VALIDATE("Ship. Qty. Invoiced", lrc_SalesEmpties."Ship. Qty. Invoiced" +
                                                              lrc_SalesLine."Quantity Invoiced");
                END ELSE BEGIN
                    lrc_SalesEmpties.VALIDATE("Rec. Quantity", lrc_SalesEmpties."Rec. Quantity" +
                                                        (lrc_SalesLine.Quantity * -1));
                    lrc_SalesEmpties.VALIDATE("Rec. Qty. Received", lrc_SalesEmpties."Rec. Qty. Received" +
                                                             (lrc_SalesLine."Quantity Shipped" * -1));
                    lrc_SalesEmpties.VALIDATE("Rec. Qty. Invoiced", lrc_SalesEmpties."Rec. Qty. Invoiced" +
                                                             (lrc_SalesLine."Quantity Invoiced" * -1));
                END;
                lrc_SalesEmpties.MODIFY();
            UNTIL lrc_SalesLine.next() = 0;



        // ---------------------------------------------------------------------------
        // Mengen umsetzen
        // ---------------------------------------------------------------------------
        lrc_SalesEmpties.RESET();
        lrc_SalesEmpties.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesEmpties.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesEmpties.SETRANGE("Item Typ", lrc_SalesEmpties."Item Typ"::"Empties Item");
        IF lrc_SalesEmpties.FIND('-') THEN
            REPEAT
                IF lrc_SalesEmpties."Ship. Quantity" = 0 THEN
                    lrc_SalesEmpties.VALIDATE("Ship. Quantity", lrc_SalesEmpties."Ship. Calc. Quantity");
                IF lrc_SalesEmpties."Rec. Quantity" = 0 THEN
                    lrc_SalesEmpties.VALIDATE("Rec. Quantity", lrc_SalesEmpties."Rec. Calc. Quantity");
                lrc_SalesEmpties.MODIFY();
            UNTIL lrc_SalesEmpties.next() = 0;
    end;

    procedure EmCreateSalesLinesEmptiesItems(vrc_SalesHeader: Record "Sales Header")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        //lrc_Item: Record Item;
        //lco_EmptiesItemNo: Code[20];
        lin_LineNo: Integer;
        //lbn_NeuLaden: Boolean;
        ldc_QuantityToShip: Decimal;
        ldc_QuantityToInvoice: Decimal;
        ldc_Quantity: Decimal;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Erstellung der Verkaufszeilen Leergutartikel
        // -----------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();

        // Letzte Verkaufszeilen ermitteln
        lin_LineNo := EmEmptiesTranspStartLineNo();
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
        IF lrc_SalesLine.FIND('+') THEN
            lin_LineNo := lrc_SalesLine."Line No.";


        // Leergutzeilen lesen
        lrc_SalesEmpties.RESET();
        lrc_SalesEmpties.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesEmpties.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesEmpties.SETRANGE("Item Typ", lrc_SalesEmpties."Item Typ"::"Empties Item");

        lrc_SalesEmpties.SETRANGE(Source, lrc_SalesEmpties.Source::Customer);
        lrc_SalesEmpties.SETRANGE("Source No.", vrc_SalesHeader."Sell-to Customer No.");
        lrc_SalesEmpties.SETFILTER("Empties Allocation", '%1|%2',
                                   lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice",
                                   lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping With Invoice");
        lrc_SalesEmpties.SETRANGE("Empties Calculation", lrc_SalesEmpties."Empties Calculation"::"Same Document");
        IF lrc_SalesEmpties.FIND('-') THEN
            REPEAT

                // -----------------------------------------------------------------------------
                // Leergutabgabe
                // -----------------------------------------------------------------------------
                IF lrc_SalesEmpties."Ship. Quantity" > 0 THEN BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Empties Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '>%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN BEGIN
                        IF lrc_FruitVisionSetup."Internal Customer Code" = 'EFG' THEN
                            lrc_SalesLine.VALIDATE(Quantity, lrc_SalesEmpties."Ship. Calc. Quantity")
                        ELSE
                            lrc_SalesLine.VALIDATE(Quantity, lrc_SalesEmpties."Ship. Quantity");
                        IF lrc_SalesEmpties."Empties Allocation" =
                           lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", 0)
                        ELSE
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Ship. Refund Price");
                        lrc_SalesLine.MODIFY();
                    END ELSE BEGIN
                        lrc_SalesLine.RESET();
                        lrc_SalesLine.INIT();
                        lrc_SalesLine."Document Type" := vrc_SalesHeader."Document Type";
                        lrc_SalesLine."Document No." := vrc_SalesHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_SalesLine."Line No." := lin_LineNo;
                        lrc_SalesLine.INSERT(TRUE);
                        lrc_SalesLine.VALIDATE(Type, lrc_SalesLine.Type::Item);
                        lrc_SalesLine.VALIDATE("No.", lrc_SalesEmpties."Item No.");
                        lrc_SalesLine.VALIDATE("Location Code", lrc_SalesEmpties."Location Code");
                        ldc_QuantityToShip := lrc_SalesEmpties."Ship. Qty. to Ship";
                        ldc_QuantityToInvoice := lrc_SalesEmpties."Ship. Qty. to Invoice";
                        lrc_SalesLine.VALIDATE("Line Discount %", 0);
                        lrc_SalesLine.VALIDATE("Allow Invoice Disc.", FALSE);
                        IF (lrc_SalesEmpties."Ship. Qty. to Ship" = 0) AND
                           (lrc_SalesEmpties."Ship. Qty. to Invoice" = 0) THEN
                            ldc_Quantity := 0
                        ELSE
                            IF (lrc_SalesEmpties."Ship. Qty. to Ship" > lrc_SalesEmpties."Ship. Qty. to Invoice") THEN
                                ldc_Quantity := lrc_SalesEmpties."Ship. Qty. to Ship"
                            ELSE
                                ldc_Quantity := lrc_SalesEmpties."Ship. Qty. to Invoice";
                        IF (lrc_SalesEmpties."Document Type" = lrc_SalesEmpties."Document Type"::"Credit Memo") OR
                           (lrc_SalesEmpties."Document Type" = lrc_SalesEmpties."Document Type"::"Return Order") THEN BEGIN
                            ldc_Quantity := ldc_Quantity * (-1);
                            ldc_QuantityToShip := ldc_QuantityToShip * (-1);
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice * (-1);
                        END ELSE BEGIN
                            ldc_Quantity := ldc_Quantity;
                            ldc_QuantityToShip := ldc_QuantityToShip;
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice;
                        END;
                        lrc_SalesLine.VALIDATE(Quantity);
                        IF lrc_SalesLine."Qty. to Ship" <> ldc_QuantityToShip THEN
                            lrc_SalesLine.VALIDATE(Quantity, lrc_SalesLine."Quantity Shipped" + ldc_QuantityToShip);
                        lrc_SalesLine.VALIDATE("Qty. to Invoice", ldc_QuantityToInvoice);
                        IF lrc_SalesEmpties."Empties Allocation" =
                           lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", 0)
                        ELSE
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Ship. Refund Price");
                        lrc_SalesLine.MODIFY();
                    END;
                END ELSE BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Empties Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN
                        IF lrc_SalesLine."Quantity Shipped" = 0 THEN
                            lrc_SalesLine.DELETE(TRUE);
                END;


                // -----------------------------------------------------------------------------
                // Leergutannahme
                // -----------------------------------------------------------------------------
                IF lrc_SalesEmpties."Rec. Quantity" > 0 THEN BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Empties Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN BEGIN
                        lrc_SalesLine.VALIDATE(Quantity, (lrc_SalesEmpties."Rec. Quantity" * -1));
                        IF lrc_SalesEmpties."Empties Allocation" =
                           lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", 0)
                        ELSE
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Ship. Refund Price");
                        lrc_SalesLine.MODIFY();
                    END ELSE BEGIN
                        lrc_SalesLine.RESET();
                        lrc_SalesLine.INIT();
                        lrc_SalesLine."Document Type" := vrc_SalesHeader."Document Type";
                        lrc_SalesLine."Document No." := vrc_SalesHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_SalesLine."Line No." := lin_LineNo;
                        lrc_SalesLine.INSERT(TRUE);
                        lrc_SalesLine.VALIDATE(Type, lrc_SalesLine.Type::Item);
                        lrc_SalesLine.VALIDATE("No.", lrc_SalesEmpties."Item No.");
                        lrc_SalesLine.VALIDATE("Location Code", lrc_SalesEmpties."Location Code");
                        ldc_QuantityToShip := lrc_SalesEmpties."Rec. Qty. to Receive";
                        ldc_QuantityToInvoice := lrc_SalesEmpties."Rec. Qty. to Invoice";
                        lrc_SalesLine.VALIDATE("Line Discount %", 0);
                        lrc_SalesLine.VALIDATE("Allow Invoice Disc.", FALSE);
                        IF (lrc_SalesEmpties."Rec. Qty. to Receive" = 0) AND
                           (lrc_SalesEmpties."Rec. Qty. to Invoice" = 0) THEN
                            ldc_Quantity := 0
                        ELSE
                            IF (lrc_SalesEmpties."Rec. Qty. to Receive" > lrc_SalesEmpties."Rec. Qty. to Invoice") THEn
                                ldc_Quantity := lrc_SalesEmpties."Rec. Qty. to Receive"
                            ELSE
                                ldc_Quantity := lrc_SalesEmpties."Rec. Qty. to Invoice";
                        IF (lrc_SalesEmpties."Document Type" = lrc_SalesEmpties."Document Type"::"Credit Memo") OR
                           (lrc_SalesEmpties."Document Type" = lrc_SalesEmpties."Document Type"::"Return Order") THEN BEGIN
                            ldc_Quantity := ldc_Quantity;
                            ldc_QuantityToShip := ldc_QuantityToShip;
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice;
                        END ELSE BEGIN
                            ldc_Quantity := ldc_Quantity * (-1);
                            ldc_QuantityToShip := ldc_QuantityToShip * (-1);
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice * (-1);
                        END;

                        lrc_SalesLine.VALIDATE(Quantity);
                        IF lrc_SalesLine."Qty. to Ship" <> ldc_QuantityToShip THEN
                            lrc_SalesLine.VALIDATE(Quantity, lrc_SalesLine."Quantity Shipped" + ldc_QuantityToShip);
                        lrc_SalesLine.VALIDATE("Qty. to Invoice", ldc_QuantityToInvoice);
                        IF lrc_SalesEmpties."Empties Allocation" =
                           lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEn
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", 0)
                        ELSE
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Rec. Refund Price");
                        lrc_SalesLine.MODIFY();
                    END;

                END ELSE BEGIN

                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Empties Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN
                        IF lrc_SalesLine."Quantity Shipped" = 0 THEN
                            lrc_SalesLine.DELETE(TRUE);
                END;
            UNTIL lrc_SalesEmpties.next() = 0
        ELSE BEGIN
            lrc_SalesEmpties.SETFILTER("Empties Calculation", '<>%1', lrc_SalesEmpties."Empties Calculation"::"Same Document");
            IF lrc_SalesEmpties.FIND('-') THEN
                REPEAT
                    // -----------------------------------------------------------------------------
                    // Leergutabgabe
                    // -----------------------------------------------------------------------------
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Empties Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN
                        IF lrc_SalesLine."Quantity Shipped" = 0 THEN
                            lrc_SalesLine.DELETE(TRUE);
                    // -----------------------------------------------------------------------------
                    // Leergutrücknahme
                    // -----------------------------------------------------------------------------
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Empties Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN
                        IF lrc_SalesLine."Quantity Shipped" = 0 THEN
                            lrc_SalesLine.DELETE(TRUE);
                UNTIL lrc_SalesEmpties.next() = 0;
        END;
    end;

    procedure EmCreateSalesLinesTranspItems(vrc_SalesHeader: Record "Sales Header")
    var
        //lrc_FruitVisionSetup: Record "POI ADF Setup";
        //lrc_Item: Record Item;
        lrc_Item2: Record Item;
        //lco_EmptiesItemNo: Code[20];
        lin_LineNo: Integer;
        //lbn_NeuLaden: Boolean;
        ldc_QuantityToShip: Decimal;
        ldc_QuantityToInvoice: Decimal;
        ldc_Quantity: Decimal;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Erstellung der Verkaufszeilen Tranportartikel
        // -----------------------------------------------------------------------------

        // Letzte Verkaufszeilen ermitteln
        lin_LineNo := EmEmptiesTranspStartLineNo();
        lrc_SalesLine.RESET();
        lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
        IF lrc_SalesLine.FIND('+') THEN
            lin_LineNo := lrc_SalesLine."Line No.";


        lrc_SalesEmpties.RESET();
        lrc_SalesEmpties.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
        lrc_SalesEmpties.SETRANGE("Document No.", vrc_SalesHeader."No.");
        lrc_SalesEmpties.SETRANGE("Item Typ", lrc_SalesEmpties."Item Typ"::"Transport Item");

        // LVW 005 FV400020.s
        lrc_SalesEmpties.SETRANGE(Source, lrc_SalesEmpties.Source::Customer);
        lrc_SalesEmpties.SETRANGE("Source No.", vrc_SalesHeader."Sell-to Customer No.");
        lrc_SalesEmpties.SETFILTER("Empties Allocation", '%1|%2',
                                   lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice",
                                   lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping With Invoice");
        lrc_SalesEmpties.SETRANGE("Empties Calculation", lrc_SalesEmpties."Empties Calculation"::"Same Document");
        // LVW 005 FV400020.e

        IF lrc_SalesEmpties.FIND('-') THEN
            REPEAT
                // -----------------------------------------------------------------------------
                // Transportmittel
                // -----------------------------------------------------------------------------
                IF lrc_SalesEmpties."Ship. Quantity" > 0 THEN BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Transport Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '>%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN BEGIN
                        lrc_SalesLine.VALIDATE(Quantity, lrc_SalesEmpties."Ship. Quantity");
                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)", '');
                        IF lrc_Item2.GET(lrc_SalesLine."No.") THEN
                            IF lrc_Item2."POI Price Base (Sales Price)" <> '' THEN BEGIN
                                lrc_PriceCalculation.RESET();
                                lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
                                                               lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price");
                                lrc_PriceCalculation.SETRANGE(Code, lrc_Item2."POI Price Base (Sales Price)");
                                IF lrc_PriceCalculation.FIND('-') THEN
                                    IF lrc_PriceCalculation."Internal Calc. Type" = lrc_PriceCalculation."Internal Calc. Type"::"Base Unit" THEn
                                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)", lrc_Item2."POI Price Base (Sales Price)");
                            END;

                        lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Ship. Refund Price");
                        lrc_SalesLine.MODIFY();
                    END ELSE BEGIN
                        lrc_SalesLine.RESET();
                        lrc_SalesLine.INIT();
                        lrc_SalesLine."Document Type" := vrc_SalesHeader."Document Type";
                        lrc_SalesLine."Document No." := vrc_SalesHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_SalesLine."Line No." := lin_LineNo;
                        lrc_SalesLine.INSERT(TRUE);
                        lrc_SalesLine.VALIDATE(Type, lrc_SalesLine.Type::Item);
                        lrc_SalesLine.VALIDATE("No.", lrc_SalesEmpties."Item No.");
                        lrc_SalesLine.VALIDATE("Location Code", lrc_SalesEmpties."Location Code");
                        ldc_QuantityToShip := lrc_SalesEmpties."Ship. Qty. to Ship";
                        ldc_QuantityToInvoice := lrc_SalesEmpties."Ship. Qty. to Invoice";
                        lrc_SalesLine.VALIDATE("Line Discount %", 0);
                        lrc_SalesLine.VALIDATE("Allow Invoice Disc.", FALSE);
                        IF (lrc_SalesEmpties."Ship. Qty. to Ship" = 0) AND
                           (lrc_SalesEmpties."Ship. Qty. to Invoice" = 0) THEN
                            ldc_Quantity := 0
                        ELSE
                            IF (lrc_SalesEmpties."Ship. Qty. to Ship" > lrc_SalesEmpties."Ship. Qty. to Invoice") THEN
                                ldc_Quantity := lrc_SalesEmpties."Ship. Qty. to Ship"
                            ELSE
                                ldc_Quantity := lrc_SalesEmpties."Ship. Qty. to Invoice";



                        IF (lrc_SalesEmpties."Document Type" = lrc_SalesEmpties."Document Type"::"Credit Memo") OR
                           (lrc_SalesEmpties."Document Type" = lrc_SalesEmpties."Document Type"::"Return Order") THEN BEGIN
                            ldc_Quantity := ldc_Quantity * (-1);
                            ldc_QuantityToShip := ldc_QuantityToShip * (-1);
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice * (-1);
                        END ELSE BEGIN
                            ldc_Quantity := ldc_Quantity;
                            ldc_QuantityToShip := ldc_QuantityToShip;
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice;
                        END;

                        lrc_SalesLine.VALIDATE(Quantity);
                        IF lrc_SalesLine."Qty. to Ship" <> ldc_QuantityToShip THEN
                            lrc_SalesLine.VALIDATE(Quantity, lrc_SalesLine."Quantity Shipped" + ldc_QuantityToShip);
                        lrc_SalesLine.VALIDATE("Qty. to Invoice", ldc_QuantityToInvoice);


                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)", '');
                        IF lrc_Item2.GET(lrc_SalesLine."No.") THEN
                            IF lrc_Item2."POI Price Base (Sales Price)" <> '' THEN BEGIN
                                lrc_PriceCalculation.RESET();
                                lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
                                                               lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price");
                                lrc_PriceCalculation.SETRANGE(Code, lrc_Item2."POI Price Base (Sales Price)");
                                IF lrc_PriceCalculation.FIND('-') THEN
                                    IF lrc_PriceCalculation."Internal Calc. Type" = lrc_PriceCalculation."Internal Calc. Type"::"Base Unit" THEN
                                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)", lrc_Item2."POI Price Base (Sales Price)");
                            END;

                        lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Ship. Refund Price");
                        IF lrc_SalesEmpties."Empties Allocation" = lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", 0)
                        ELSE
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Ship. Refund Price");
                        lrc_SalesLine.MODIFY();
                    END;
                END ELSE BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Transport Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN
                        IF lrc_SalesLine."Quantity Shipped" = 0 THEN
                            lrc_SalesLine.DELETE(TRUE);
                END;


                // -----------------------------------------------------------------------------
                // Leergutannahme
                // -----------------------------------------------------------------------------
                IF lrc_SalesEmpties."Rec. Quantity" <> 0 THEN BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Transport Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN BEGIN
                        lrc_SalesLine.VALIDATE(Quantity, (lrc_SalesEmpties."Rec. Quantity" * -1));
                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)", '');
                        IF lrc_Item2.GET(lrc_SalesLine."No.") THEN
                            IF lrc_Item2."POI Price Base (Sales Price)" <> '' THEN BEGIN
                                lrc_PriceCalculation.RESET();
                                lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.", lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price");
                                lrc_PriceCalculation.SETRANGE(Code, lrc_Item2."POI Price Base (Sales Price)");
                                IF lrc_PriceCalculation.FIND('-') THEN
                                    IF lrc_PriceCalculation."Internal Calc. Type" = lrc_PriceCalculation."Internal Calc. Type"::"Base Unit" THEN
                                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)", lrc_Item2."POI Price Base (Sales Price)");
                            END;

                        lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Rec. Refund Price");
                        lrc_SalesLine.MODIFY();
                    END ELSE BEGIN
                        lrc_SalesLine.RESET();
                        lrc_SalesLine.INIT();
                        lrc_SalesLine."Document Type" := vrc_SalesHeader."Document Type";
                        lrc_SalesLine."Document No." := vrc_SalesHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_SalesLine."Line No." := lin_LineNo;
                        lrc_SalesLine.INSERT(TRUE);
                        lrc_SalesLine.VALIDATE(Type, lrc_SalesLine.Type::Item);
                        lrc_SalesLine.VALIDATE("No.", lrc_SalesEmpties."Item No.");
                        lrc_SalesLine.VALIDATE("Location Code", lrc_SalesEmpties."Location Code");
                        ldc_QuantityToShip := lrc_SalesEmpties."Rec. Qty. to Receive";
                        ldc_QuantityToInvoice := lrc_SalesEmpties."Rec. Qty. to Invoice";
                        lrc_SalesLine.VALIDATE("Line Discount %", 0);
                        lrc_SalesLine.VALIDATE("Allow Invoice Disc.", FALSE);
                        IF (lrc_SalesEmpties."Rec. Qty. to Receive" = 0) AND (lrc_SalesEmpties."Rec. Qty. to Invoice" = 0) THEN
                            ldc_Quantity := 0
                        ELSE
                            IF (lrc_SalesEmpties."Rec. Qty. to Receive" > lrc_SalesEmpties."Rec. Qty. to Invoice") THEN
                                ldc_Quantity := lrc_SalesEmpties."Rec. Qty. to Receive"
                            ELSE
                                ldc_Quantity := lrc_SalesEmpties."Rec. Qty. to Invoice";

                        IF (lrc_SalesEmpties."Document Type" = lrc_SalesEmpties."Document Type"::"Credit Memo") OR
                           (lrc_SalesEmpties."Document Type" = lrc_SalesEmpties."Document Type"::"Return Order") THEN BEGIN
                            ldc_Quantity := ldc_Quantity;
                            ldc_QuantityToShip := ldc_QuantityToShip;
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice;
                        END ELSE BEGIN
                            ldc_Quantity := ldc_Quantity * (-1);
                            ldc_QuantityToShip := ldc_QuantityToShip * (-1);
                            ldc_QuantityToInvoice := ldc_QuantityToInvoice * (-1);
                        END;

                        lrc_SalesLine.VALIDATE(Quantity);
                        IF lrc_SalesLine."Qty. to Ship" <> ldc_QuantityToShip THEN
                            lrc_SalesLine.VALIDATE(Quantity, lrc_SalesLine."Quantity Shipped" + ldc_QuantityToShip);
                        lrc_SalesLine.VALIDATE("Qty. to Invoice", ldc_QuantityToInvoice);
                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)", '');
                        IF lrc_Item2.GET(lrc_SalesLine."No.") THEN
                            IF lrc_Item2."POI Price Base (Sales Price)" <> '' THEN BEGIN
                                lrc_PriceCalculation.RESET();
                                lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.",
                                                               lrc_PriceCalculation."Purch./Sales Price Calc."::"Sales Price");
                                lrc_PriceCalculation.SETRANGE(Code, lrc_Item2."POI Price Base (Sales Price)");
                                IF lrc_PriceCalculation.FIND('-') THEN
                                    IF lrc_PriceCalculation."Internal Calc. Type" = lrc_PriceCalculation."Internal Calc. Type"::"Base Unit" THEN
                                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)", lrc_Item2."POI Price Base (Sales Price)");
                            END;
                        lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Rec. Refund Price");
                        IF lrc_SalesEmpties."Empties Allocation" =
                           lrc_SalesEmpties."Empties Allocation"::"With Stock-Keeping Without Invoice" THEN
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", 0)
                        ELSE
                            lrc_SalesLine.VALIDATE("Sales Price (Price Base)", lrc_SalesEmpties."Rec. Refund Price");
                        lrc_SalesLine.MODIFY();
                    END;
                END ELSE BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Transport Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN
                        IF lrc_SalesLine."Quantity Shipped" = 0 THEN
                            lrc_SalesLine.DELETE(TRUE);
                END;

            UNTIL lrc_SalesEmpties.next() = 0
        ELSE BEGIN
            lrc_SalesEmpties.SETFILTER("Empties Calculation", '<>%1', lrc_SalesEmpties."Empties Calculation"::"Same Document");
            IF lrc_SalesEmpties.FIND('-') THEN
                REPEAT
                    // -----------------------------------------------------------------------------
                    // Transportmittelabgabe
                    // -----------------------------------------------------------------------------
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Transport Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN
                        IF lrc_SalesLine."Quantity Shipped" = 0 THEN
                            lrc_SalesLine.DELETE(TRUE);
                    // -----------------------------------------------------------------------------
                    // Transportmittelrücknahme
                    // -----------------------------------------------------------------------------
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
                    lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
                    lrc_SalesLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", lrc_SalesEmpties."Item No.");
                    lrc_SalesLine.SETRANGE("POI Item Typ", lrc_SalesLine."POI Item Typ"::"Transport Item");
                    lrc_SalesLine.SETRANGE("Location Code", lrc_SalesEmpties."Location Code");
                    lrc_SalesLine.SETFILTER(Quantity, '<%1', 0);
                    IF lrc_SalesLine.FIND('-') THEN
                        IF lrc_SalesLine."Quantity Shipped" = 0 THEN
                            lrc_SalesLine.DELETE(TRUE);
                UNTIL lrc_SalesEmpties.next() = 0;
        END;
    end;

    procedure EmSalesGetPrices(var rrc_RefundCosts: Record "POI Empties/Transport Ref Cost"; vrc_SalesHeader: Record "Sales Header"; vrc_Customer: Record Customer; vco_ItemNo: Code[20])
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung der Verkaufspreise Leergut/Transportmittel
        // -----------------------------------------------------------------------------

        // Keine Berechnung an Debitor
        IF vrc_Customer."POI Empties Allocation" <> vrc_Customer."POI Empties Allocation"::"With Stock-Keeping With Invoice" THEN BEGIN
            rrc_RefundCosts.RESET();
            rrc_RefundCosts.INIT();
            EXIT;
        END;

        // Preis Debitor suchen
        rrc_RefundCosts.RESET();
        rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
        rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::Customer);
        rrc_RefundCosts.SETRANGE("Source No.", vrc_Customer."No.");
        rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
        rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
        IF rrc_RefundCosts.FIND('+') THEN
            EXIT;

        // Preis Unternehmenskette suchen
        IF vrc_Customer."Chain Name" <> '' THEN BEGIN
            rrc_RefundCosts.RESET();
            rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
            rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::"Company Chain");
            rrc_RefundCosts.SETRANGE("Source No.", vrc_Customer."Chain Name");
            rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
            rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
            IF rrc_RefundCosts.FIND('+') THEN
                EXIT;
        END;

        // Preis Leergutpreisgruppe suchen
        IF vrc_Customer."POI Empties Price Group" <> '' THEN BEGIN
            rrc_RefundCosts.RESET();
            rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
            rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::"Empties Price Group");
            rrc_RefundCosts.SETRANGE("Source No.", vrc_Customer."POI Empties Price Group");
            rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
            rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
            IF rrc_RefundCosts.FIND('+') THEN
                EXIT;
        END;
        // Preis Debitor allgemein
        rrc_RefundCosts.RESET();
        rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
        rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::Customer);
        rrc_RefundCosts.SETRANGE("Source No.", '');
        rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
        rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
        IF rrc_RefundCosts.FIND('+') THEN
            EXIT;
        // Preis Global suchen
        rrc_RefundCosts.RESET();
        rrc_RefundCosts.SETRANGE("Item No.", vco_ItemNo);
        rrc_RefundCosts.SETRANGE("Source Type", rrc_RefundCosts."Source Type"::"Sales Global");
        rrc_RefundCosts.SETRANGE("Source No.", '');
        rrc_RefundCosts.SETFILTER("Starting Date", '<=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
        rrc_RefundCosts.SETFILTER("Ending Date", '>=%1|%2', vrc_SalesHeader."Promised Delivery Date", 0D);
        IF rrc_RefundCosts.FIND('+') THEN
            EXIT;
        rrc_RefundCosts.RESET();
        rrc_RefundCosts.INIT();
        EXIT;
    end;

    procedure EmTransferShowTransportEmpties(vrc_TransferHeader: Record "Transfer Header")
    var
        lrc_TransferDocType: Record "POI Transfer Doc. Subtype";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Anzeige der Transportartikel und Leergutartikel in Umlagerung
        // -----------------------------------------------------------------------------

        // Kontrolle ob Formularnummer für Belegunterart eingetragen ist
        lrc_TransferDocType.GET(vrc_TransferHeader."POI Transfer Doc. Subtype Code");
        lrc_TransferDocType.TESTFIELD("Page ID Empties Card");

        // Transportartikel laden
        EmTransferLoadTransportItems(vrc_TransferHeader);
        // Leergutartikel laden
        EmTransferLoadEmptiesItems(vrc_TransferHeader);

        COMMIT();
        lrc_TransferEmpties.RESET();
        lrc_TransferEmpties.FILTERGROUP(0);
        lrc_TransferEmpties.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferEmpties.FILTERGROUP(0);

        Page.RUNMODAL(lrc_TransferDocType."Page ID Empties Card", lrc_TransferEmpties);

        // Transportmittel- und Leergutartikel anlegen
        EmTransferLinesTranspEmpties(vrc_TransferHeader)
    end;

    procedure EmTransferLoadTransportItems(vrc_TransferHeader: Record "Transfer Header")
    var
        //lrc_Location: Record Location;
        //lco_EmptiesLocationCode: Code[10];
        lbn_TransportmittelGeladen: Boolean;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Laden der Transportartikel im Umlagerungsauftrag
        // -----------------------------------------------------------------------------

        vrc_TransferHeader.TESTFIELD("Transfer-from Code");
        vrc_TransferHeader.TESTFIELD("Transfer-to Code");

        // Kontrolle ob die Transportmittel bereits geladen sind
        lbn_TransportmittelGeladen := FALSE;
        lrc_TransferEmpties.RESET();
        lrc_TransferEmpties.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferEmpties.SETRANGE("Item Typ", lrc_TransferEmpties."Item Typ"::"Transport Item");
        IF NOT lrc_TransferEmpties.FIND('-') THEN BEGIN

            // Alle zulässigen Transportmittel für die Umlagerungen laden
            IF lbn_TransportmittelGeladen = FALSE THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::Transfer);
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", '');
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    lbn_TransportmittelGeladen := TRUE;
            END;

            // Alle zulässigen Transportmittel Global laden
            IF lbn_TransportmittelGeladen = FALSE THEN BEGIN
                lrc_VendCustShipAgentEmpties.RESET();
                lrc_VendCustShipAgentEmpties.SETRANGE(Source, lrc_VendCustShipAgentEmpties.Source::"Sales Global");
                lrc_VendCustShipAgentEmpties.SETRANGE("Source No.", '');
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    lbn_TransportmittelGeladen := TRUE;
            END;

            IF lbn_TransportmittelGeladen = TRUE THEN
                IF lrc_VendCustShipAgentEmpties.FIND('-') THEN
                    REPEAT
                        lrc_TransferEmpties.RESET();
                        lrc_TransferEmpties.INIT();
                        lrc_TransferEmpties."Document No." := vrc_TransferHeader."No.";
                        lrc_TransferEmpties."Line No." := 0;
                        lrc_TransferEmpties.VALIDATE("Item No.", lrc_VendCustShipAgentEmpties."Item No.");
                        lrc_TransferEmpties.VALIDATE("Location Code", vrc_TransferHeader."Transfer-from Code");
                        lrc_TransferEmpties."Empties Allocation" := lrc_TransferEmpties."Empties Allocation"::"With Stock-Keeping With Invoice";
                        lrc_TransferEmpties."Empties Calculation" := lrc_TransferEmpties."Empties Calculation"::"Same Document";
                        lrc_TransferEmpties.INSERT(TRUE);
                    UNTIL lrc_VendCustShipAgentEmpties.next() = 0
                ELSE
                    ERROR('Keine Transportmittel trotz Zuordnung gefunden!');

            // Alle Transportmittel aus dem Artikelstamm laden
            IF lbn_TransportmittelGeladen = FALSE THEN BEGIN
                lrc_Item.RESET();
                lrc_Item.SETCURRENTKEY("POI Item Typ", Blocked);
                lrc_Item.SETRANGE("POI Item Typ", lrc_Item."POI Item Typ"::"Transport Item");
                lrc_Item.SETRANGE(Blocked, FALSE);
                IF lrc_Item.FIND('-') THEN BEGIN
                    REPEAT
                        lrc_TransferEmpties.RESET();
                        lrc_TransferEmpties.INIT();
                        lrc_TransferEmpties."Document No." := vrc_TransferHeader."No.";
                        lrc_TransferEmpties."Line No." := 0;
                        lrc_TransferEmpties.VALIDATE("Item No.", lrc_Item."No.");
                        lrc_TransferEmpties.VALIDATE("Location Code", vrc_TransferHeader."Transfer-from Code");
                        lrc_TransferEmpties."Empties Allocation" := lrc_TransferEmpties."Empties Allocation"::"With Stock-Keeping With Invoice";
                        lrc_TransferEmpties."Empties Calculation" := lrc_TransferEmpties."Empties Calculation"::"Same Document";
                        lrc_TransferEmpties.INSERT(TRUE);
                    UNTIL lrc_Item.next() = 0;
                    lbn_TransportmittelGeladen := TRUE;
                END;
            END;

            // Alle Werte auf Null setzen
        END ELSE BEGIN
            REPEAT
                lrc_TransferEmpties."Ship. Calc. Quantity" := 0;
                lrc_TransferEmpties."Ship. Quantity" := 0;
                lrc_TransferEmpties."Ship. Qty. to Ship" := 0;
                lrc_TransferEmpties."Ship. Qty. Shipped" := 0;
                lrc_TransferEmpties."Ship. Qty. to Invoice" := 0;
                lrc_TransferEmpties."Ship. Qty. Invoiced" := 0;
                lrc_TransferEmpties."Ship. Qty. to Transfer" := 0;
                lrc_TransferEmpties."Ship. Qty. Transfered" := 0;
                lrc_TransferEmpties.MODIFY();
            UNTIL lrc_TransferEmpties.next() = 0;
            lbn_TransportmittelGeladen := TRUE;
        END;

        // ---------------------------------------------------------------------------------
        // Mengen aus Umlagerungszeilen laden
        // ---------------------------------------------------------------------------------
        lrc_TransferLine.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferLine.SETFILTER("Item No.", '<>%1', '');
        lrc_TransferLine.SETRANGE("POI Subtyp", lrc_TransferLine."POI Subtyp"::Refund);
        lrc_TransferLine.SETRANGE("POI Item Typ", lrc_TransferLine."POI Item Typ"::"Transport Item");
        IF lrc_TransferLine.FIND('-') THEN
            REPEAT

                IF (lrc_TransferLine.Quantity = 0) AND (lrc_TransferLine."Quantity Shipped" = 0) THEN
                    lrc_TransferLine.DELETE(TRUE)
                ELSE BEGIN
                    lrc_TransferEmpties.RESET();
                    lrc_TransferEmpties.SETRANGE("Document No.", vrc_TransferHeader."No.");
                    lrc_TransferEmpties.SETRANGE("Item Typ", lrc_TransferEmpties."Item Typ"::"Transport Item");
                    lrc_TransferEmpties.SETRANGE("Item No.", lrc_TransferLine."Item No.");
                    lrc_TransferEmpties.SETRANGE("Location Code", vrc_TransferHeader."Transfer-from Code");
                    IF NOT lrc_TransferEmpties.FIND('-') THEN BEGIN
                        lrc_TransferEmpties.RESET();
                        lrc_TransferEmpties.INIT();
                        lrc_TransferEmpties."Document No." := vrc_TransferHeader."No.";
                        lrc_TransferEmpties.VALIDATE("Item No.", lrc_TransferLine."Item No.");
                        lrc_TransferEmpties.VALIDATE("Location Code", vrc_TransferHeader."Transfer-from Code");
                        lrc_TransferEmpties."Line No." := 0;
                        lrc_TransferEmpties."Empties Allocation" := lrc_TransferEmpties."Empties Allocation"::"With Stock-Keeping With Invoice";
                        lrc_TransferEmpties."Empties Calculation" := lrc_TransferEmpties."Empties Calculation"::"Same Document";
                        lrc_TransferEmpties.INSERT(TRUE);
                    END;
                    IF lrc_TransferLine.Quantity > 0 THEN BEGIN
                        lrc_TransferEmpties."Ship. Quantity" := lrc_TransferEmpties."Ship. Quantity" + lrc_TransferLine.Quantity;
                        lrc_TransferEmpties."Ship. Qty. Shipped" := lrc_TransferEmpties."Ship. Qty. Shipped" + lrc_TransferLine."Quantity Shipped";
                        lrc_TransferEmpties.MODIFY();
                    END;
                    IF lrc_TransferLine.Quantity < 0 THEN
                        ERROR('Negative Menge in Umlagerung nicht zulässig!');
                END;
            UNTIL lrc_TransferLine.next() = 0;
    end;

    procedure EmTransferLoadEmptiesItems(vrc_TransferHeader: Record "Transfer Header")
    var
        lco_EmptiesItemNo: Code[20];
    //lin_LineNo: Integer;
    //lbn_NeuLaden: Boolean;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Laden der Leergutartikel auf Basis der umgelagerten Artikel
        // -----------------------------------------------------------------------------
        vrc_TransferHeader.TESTFIELD("Transfer-from Code");
        vrc_TransferHeader.TESTFIELD("Transfer-to Code");
        // ---------------------------------------------------------------------------
        // Kontrolle ob Leergutartikel bereits geladen sind
        // ---------------------------------------------------------------------------
        lrc_TransferEmpties.RESET();
        lrc_TransferEmpties.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferEmpties.SETRANGE("Item Typ", lrc_TransferEmpties."Item Typ"::"Empties Item");
        IF lrc_TransferEmpties.FIND('-') THEN
            REPEAT
                lrc_TransferEmpties."Ship. Calc. Quantity" := 0;
                lrc_TransferEmpties."Ship. Quantity" := 0;
                lrc_TransferEmpties."Ship. Qty. to Ship" := 0;
                lrc_TransferEmpties."Ship. Qty. Shipped" := 0;
                lrc_TransferEmpties."Ship. Qty. to Invoice" := 0;
                lrc_TransferEmpties."Ship. Qty. Invoiced" := 0;
                lrc_TransferEmpties."Ship. Qty. to Transfer" := 0;
                lrc_TransferEmpties."Ship. Qty. Transfered" := 0;
                lrc_TransferEmpties.MODIFY();
            UNTIL lrc_TransferEmpties.next() = 0;
        // ---------------------------------------------------------------------------
        // Artikel mit Leergut lesen
        // ---------------------------------------------------------------------------
        lrc_TransferLine.RESET();
        lrc_TransferLine.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferLine.SETFILTER("Item No.", '<>%1', '');
        lrc_TransferLine.SETFILTER("POI Empties Item No.", '<>%1', '');
        lrc_TransferLine.SETFILTER("POI Empties Quantity", '>%1', 0);
        lrc_TransferLine.SETFILTER("POI Item Typ", '<>%1&<>%2', lrc_TransferLine."POI Item Typ"::"Transport Item", lrc_TransferLine."POI Item Typ"::"Empties Item");
        IF lrc_TransferLine.FIND('-') THEN
            REPEAT
                IF (lrc_TransferLine."POI Empties Item No." <> '') AND (lrc_TransferLine."POI Empties Quantity" > 0) THEN BEGIN
                    // Leergutartikelnummer ermitteln
                    lrc_Item.GET(lrc_TransferLine."POI Empties Item No.");
                    IF lrc_Item."POI Empties Posting Item No." <> '' THEN
                        lco_EmptiesItemNo := lrc_Item."POI Empties Posting Item No."
                    ELSE
                        lco_EmptiesItemNo := lrc_Item."No.";
                    lrc_TransferEmpties.RESET();
                    lrc_TransferEmpties.SETRANGE("Document No.", vrc_TransferHeader."No.");
                    lrc_TransferEmpties.SETRANGE("Item No.", lco_EmptiesItemNo);
                    lrc_TransferEmpties.SETRANGE("Location Code", vrc_TransferHeader."Transfer-from Code");
                    IF NOT lrc_TransferEmpties.FIND('-') THEN BEGIN
                        lrc_TransferEmpties.RESET();
                        lrc_TransferEmpties.INIT();
                        lrc_TransferEmpties."Document No." := lrc_TransferLine."Document No.";
                        lrc_TransferEmpties.VALIDATE("Item No.", lco_EmptiesItemNo);
                        lrc_TransferEmpties.VALIDATE("Location Code", vrc_TransferHeader."Transfer-from Code");
                        lrc_TransferEmpties."Line No." := 0;
                        lrc_TransferEmpties."Empties Allocation" := lrc_TransferEmpties."Empties Allocation"::"With Stock-Keeping With Invoice";
                        lrc_TransferEmpties."Empties Calculation" := lrc_TransferEmpties."Empties Calculation"::"Same Document";
                        lrc_TransferEmpties.INSERT(TRUE);
                    END;
                    IF lrc_TransferLine.Quantity > 0 THEN
                        lrc_TransferEmpties."Ship. Calc. Quantity" := lrc_TransferEmpties."Ship. Calc. Quantity" + (lrc_TransferLine.Quantity * lrc_TransferLine."POI Empties Quantity")
                    ELSE
                        ERROR('Negative Mengen in Umlagerung nicht zulässig!');
                    lrc_TransferEmpties.MODIFY();
                END;
            UNTIL lrc_TransferLine.next() = 0;


        // ---------------------------------------------------------------------------
        // Leergutartikel lesen
        // ---------------------------------------------------------------------------
        lrc_TransferLine.RESET();
        lrc_TransferLine.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferLine.SETFILTER("Item No.", '<>%1', '');
        lrc_TransferLine.SETFILTER("POI Item Typ", '%1', lrc_TransferLine."POI Item Typ"::"Empties Item");
        IF lrc_TransferLine.FIND('-') THEN
            REPEAT
                lrc_TransferEmpties.RESET();
                lrc_TransferEmpties.SETRANGE("Document No.", lrc_TransferLine."Document No.");
                lrc_TransferEmpties.SETRANGE("Item No.", lco_EmptiesItemNo);
                lrc_TransferEmpties.SETRANGE("Location Code", vrc_TransferHeader."Transfer-from Code");
                IF NOT lrc_TransferEmpties.FIND('-') THEN BEGIN
                    lrc_TransferEmpties.RESET();
                    lrc_TransferEmpties.INIT();
                    lrc_TransferEmpties."Document No." := lrc_TransferLine."Document No.";
                    lrc_TransferEmpties.VALIDATE("Item No.", lco_EmptiesItemNo);
                    lrc_TransferEmpties.VALIDATE("Location Code", vrc_TransferHeader."Transfer-from Code");
                    lrc_TransferEmpties."Line No." := 0;
                    lrc_TransferEmpties."Empties Allocation" := lrc_TransferEmpties."Empties Allocation"::"With Stock-Keeping With Invoice";
                    lrc_TransferEmpties."Empties Calculation" := lrc_TransferEmpties."Empties Calculation"::"Same Document";
                    lrc_TransferEmpties.INSERT(TRUE);
                END;
                IF lrc_TransferLine.Quantity > 0 THEN BEGIN
                    lrc_TransferEmpties."Ship. Quantity" := lrc_TransferEmpties."Ship. Quantity" + lrc_TransferLine.Quantity;
                    lrc_TransferEmpties."Ship. Qty. Shipped" := lrc_TransferEmpties."Ship. Qty. Shipped" + lrc_TransferLine."Quantity Shipped";
                END;
                lrc_TransferEmpties.MODIFY();
            UNTIL lrc_TransferLine.next() = 0;
        // ---------------------------------------------------------------------------
        // Mengen umsetzen
        // ---------------------------------------------------------------------------
        lrc_TransferEmpties.RESET();
        lrc_TransferEmpties.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferEmpties.SETRANGE("Item Typ", lrc_TransferEmpties."Item Typ"::"Empties Item");
        IF lrc_TransferEmpties.FIND('-') THEN
            REPEAT
                IF lrc_TransferEmpties."Ship. Quantity" = 0 THEN
                    lrc_TransferEmpties."Ship. Quantity" := lrc_TransferEmpties."Ship. Calc. Quantity";
                lrc_TransferEmpties.MODIFY();
            UNTIL lrc_TransferEmpties.next() = 0;
    end;

    procedure EmTransferLinesTranspEmpties(vrc_TransferHeader: Record "Transfer Header")
    var
        //lrc_FruitVisionSetup: Record "POI ADF Setup";
        //lrc_Item: Record Item;
        //lco_EmptiesItemNo: Code[20];
        lin_LineNo: Integer;
    //lbn_NeuLaden: Boolean;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Erstellung der Umlagerungszeilen Tranport- und Leergutartikel
        // -----------------------------------------------------------------------------

        // Verkaufszeilen anlegen
        lin_LineNo := EmEmptiesTranspStartLineNo();
        lrc_TransferLine.RESET();
        lrc_TransferLine.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
        IF lrc_TransferLine.FIND('+') THEN
            lin_LineNo := lrc_TransferLine."Line No.";
        lrc_TransferEmpties.RESET();
        lrc_TransferEmpties.SETRANGE("Document No.", vrc_TransferHeader."No.");
        lrc_TransferEmpties.SETFILTER("Item Typ", '%1|%2', lrc_TransferEmpties."Item Typ"::"Transport Item", lrc_TransferEmpties."Item Typ"::"Empties Item");
        IF lrc_TransferEmpties.FIND('-') THEN
            REPEAT
                // -----------------------------------------------------------------------------
                // Transportmittel
                // -----------------------------------------------------------------------------
                IF lrc_TransferEmpties."Ship. Quantity" > 0 THEN BEGIN
                    lrc_TransferLine.RESET();
                    lrc_TransferLine.SETRANGE("Document No.", vrc_TransferHeader."No.");
                    lrc_TransferLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_TransferLine.SETRANGE("Item No.", lrc_TransferEmpties."Item No.");
                    lrc_TransferLine.SETRANGE("POI Item Typ", lrc_TransferEmpties."Item Typ");
                    lrc_TransferLine.SETRANGE("Transfer-from Code", lrc_TransferEmpties."Location Code");
                    lrc_TransferLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_TransferLine.FIND('-') THEN BEGIN
                        lrc_TransferLine.VALIDATE(Quantity, lrc_TransferEmpties."Ship. Quantity");
                        lrc_TransferLine.MODIFY();
                    END ELSE BEGIN
                        lrc_TransferLine.RESET();
                        lrc_TransferLine.INIT();
                        lrc_TransferLine."Document No." := vrc_TransferHeader."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_TransferLine."Line No." := lin_LineNo;
                        lrc_TransferLine.INSERT(TRUE);
                        lrc_TransferLine.VALIDATE("Item No.", lrc_TransferEmpties."Item No.");
                        lrc_TransferLine.VALIDATE("Transfer-from Code", lrc_TransferEmpties."Location Code");
                        lrc_TransferLine.VALIDATE(Quantity, lrc_TransferEmpties."Ship. Quantity");
                        lrc_TransferLine.MODIFY();
                    END;
                END ELSE BEGIN
                    lrc_TransferLine.RESET();
                    lrc_TransferLine.SETRANGE("Document No.", vrc_TransferHeader."No.");
                    lrc_TransferLine.SETFILTER("Line No.", '>=%1', EmEmptiesTranspStartLineNo());
                    lrc_TransferLine.SETRANGE("Item No.", lrc_TransferEmpties."Item No.");
                    lrc_TransferLine.SETRANGE("POI Item Typ", lrc_TransferEmpties."Item Typ");
                    lrc_TransferLine.SETRANGE("Transfer-from Code", lrc_TransferEmpties."Location Code");
                    lrc_TransferLine.SETFILTER(Quantity, '>=%1', 0);
                    IF lrc_TransferLine.FIND('-') THEN
                        IF lrc_TransferLine."Quantity Shipped" = 0 THEN
                            lrc_TransferLine.DELETE(TRUE);
                END;
            UNTIL lrc_TransferEmpties.next() = 0;
    end;

    procedure SalesAttachEmptiestoSalesLines(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vin_LineNo: Integer; var rin_EmptiesLineNo: Integer; var rco_EmptiesBlanketDocNo: Code[20]; var rin_EmptiesBlanketLineNo: Integer; vdc_EmptiesQuantity: Decimal)
    var
        lrc_SalesHeader: Record "Sales Header";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_Customer: Record Customer;
        lin_LineNo: Integer;
        lin_LineNo2: Integer;
        l_LfdNo: Integer;
    begin
        //---------------------------------------------------
        //Funktion zur Anlage der Leergutzeilen im VK-Auftrag
        //vop_DocType Option
        //vco_DocNo Code20
        //vin_LineNo Integer
        //rin_EmptiesLineNo Integer
        //rco_EmptiesBlanket DocNoCode20
        //rin_EmptiesBlanket LineNoInteger
        //vdc_EmptiesQuantity Decimal
        //---------------------------------------------------

        lrc_SalesHeader.GET(vop_DocType, vco_DocNo);
        lrc_SalesLine.GET(vop_DocType, vco_DocNo, vin_LineNo);
        IF lrc_SalesLine.Type <> lrc_SalesLine.Type::Item THEN
            EXIT;

        lrc_BatchVariant.GET(lrc_SalesLine."POI Batch Variant No.");

        CASE lrc_BatchVariant.Source OF
            lrc_BatchVariant.Source::"Purch. Order":
                BEGIN
                    lrc_PurchLine.SETRANGE("POI Batch Variant No.", lrc_SalesLine."POI Batch Variant No.");
                    lrc_PurchLine.FINDSET(FALSE, FALSE);

                    IF lrc_PurchLine."POI Empties Attached Line No" <> 0 THEN BEGIN //1

                        //Prüfung ob Leergutzeile in Verkaufsauftrag oder in Rahmenauftrag eingefügt werden soll
                        lrc_Customer.GET(lrc_SalesLine."Sell-to Customer No.");
                        IF lrc_Customer."POI Leergutberechnung an Deb" = '' THEN BEGIN //2

                            //Leergutberechnung erfolgt direkt an Kunden
                            //------------------------------------------

                            //ermitteln von Leergut Positionsnummer und laden der Positions Variante
                            lrc_PurchLine2.GET(lrc_PurchLine."Document Type", lrc_PurchLine."Document No.", lrc_PurchLine."POI Empties Attached Line No");
                            lrc_BatchVariant.GET(lrc_PurchLine2."POI Batch Variant No.");

                            IF lrc_SalesLine."POI Empties Line No" <> 0 THEN BEGIN //3
                                MESSAGE('Es ist bereits eine Leergutzeile zur Zeile %1 vorhanden', lrc_SalesLine."Line No.");
                                EXIT;
                            END;

                            //Leergutzeile anlegen
                            lrc_SalesLine2.RESET();
                            lrc_SalesLine2.INIT();
                            lrc_SalesLine2."Document Type" := lrc_SalesLine."Document Type";
                            lrc_SalesLine2."Document No." := lrc_SalesLine."Document No.";
                            lrc_SalesLine2."Line No." := lrc_SalesLine."Line No." + 100;
                            lrc_SalesLine2.VALIDATE("Sell-to Customer No.", lrc_SalesHeader."Sell-to Customer No.");
                            lrc_SalesLine2.VALIDATE("Bill-to Customer No.", lrc_SalesHeader."Bill-to Customer No.");
                            lrc_SalesLine2.INSERT(TRUE);
                            lrc_SalesLine2.VALIDATE(Type, lrc_SalesLine2.Type::Item);
                            lrc_SalesLine2.VALIDATE("No.", lrc_SalesLine."POI Empties Item No.");
                            lrc_SalesLine2.VALIDATE("Location Code", lrc_SalesLine."Location Code");
                            lrc_SalesLine2.VALIDATE("POI Batch Variant No.", lrc_BatchVariant."No.");
                            lrc_SalesLine2.MODIFY(TRUE);
                            IF vop_DocType = vop_DocType::"4" THEN
                                lrc_SalesLine2.VALIDATE(Quantity, -vdc_EmptiesQuantity)
                            ELSE
                                lrc_SalesLine2.VALIDATE(Quantity, vdc_EmptiesQuantity);
                            lrc_SalesLine2."Attached to Line No." := lrc_SalesLine."Line No.";
                            lrc_SalesLine2.MODIFY(TRUE);

                            //Leergutzeilennummer in VK-Zeile übernehmen
                            rin_EmptiesLineNo := lrc_SalesLine."Line No." + 100;//lrc_SalesLine2."Line No.";
                            EXIT;
                            ///END ELSE BEGIN
                            //MESSAGE('Zur Position %1 gibt es keine zugeordnete Leergutzeile', lrc_PurchLine."POI Batch Variant No.");
                            //END;
                        END ELSE BEGIN

                            //Leergutberechnung erfolgt an Europool, Rahmenauftragszeile anlegen
                            //------------------------------------------------------------------

                            //ermitteln von Leergut Positionsnummer und laden der Positions Variante
                            lrc_PurchLine2.GET(lrc_PurchLine."Document Type", lrc_PurchLine."Document No.", lrc_PurchLine."POI Empties Attached Line No");
                            lrc_BatchVariant.GET(lrc_PurchLine2."POI Batch Variant No.");
                            SalesHeaderHELP.RESET();
                            SalesHeaderHELP.SETRANGE("Document Type", SalesHeaderHELP."Document Type"::"Blanket Order");
                            SalesHeaderHELP.SETRANGE("Sell-to Customer No.", lrc_Customer."POI Leergutberechnung an Deb");
                            SalesHeaderHELP.SETRANGE(Status, lrc_SalesHeader2.Status::Open);
                            IF SalesHeaderHELP.FINDSET() THEN
                                REPEAT
                                    Buffer.INIT();
                                    Buffer.code1 := 'EPS';
                                    Buffer.code2 := SalesHeaderHELP."No.";
                                    Buffer.Integer1 := DATE2DMY(lrc_PurchLine."Expected Receipt Date", 2);
                                    Buffer.Integer2 := DATE2DMY(lrc_PurchLine."Expected Receipt Date", 3);
                                    Buffer.Integer3 := DATE2DMY(SalesHeaderHELP."Document Date", 2);
                                    Buffer.integer4 := DATE2DMY(SalesHeaderHELP."Document Date", 3);
                                    IF (Buffer.Integer1 = Buffer.Integer3) AND (Buffer.Integer2 = Buffer.integer4) THEN BEGIN
                                        Buffer.INSERT();
                                        l_LfdNo += 1;
                                    END;
                                UNTIL SalesHeaderHELP.next() = 0;
                            Buffer.RESET();
                            Buffer.SETRANGE(Buffer.code1, 'EPS');
                            IF Buffer.FINDLAST() THEN;
                            lrc_SalesHeader2.SETRANGE("Sell-to Customer No.", lrc_Customer."POI Leergutberechnung an Deb");
                            lrc_SalesHeader2.SETRANGE("Document Type", lrc_SalesHeader2."Document Type"::"Blanket Order");
                            lrc_SalesHeader2.SETRANGE(Status, lrc_SalesHeader2.Status::Open);
                            lrc_SalesHeader2.SETRANGE("No.", Buffer.code2);
                            //Prüfung ob Rahmenauftrag und Rahmenauftragszeile vorhanden
                            IF lrc_SalesHeader2.FINDSET(FALSE, FALSE) THEN BEGIN
                                lrc_SalesLine2.RESET();
                                lrc_SalesLine2.SETRANGE("Document Type", lrc_SalesHeader2."Document Type");
                                lrc_SalesLine2.SETRANGE("POI Customer Order No.", lrc_SalesLine."Document No.");
                                lrc_SalesLine2.SETRANGE("POI Customer Line Reference", lrc_SalesLine."Line No.");
                                IF lrc_SalesLine2.FINDSET(FALSE, FALSE) THEN BEGIN
                                    MESSAGE('Es ist bereits eine Leergutzeile zur Zeile %1 vorhanden', lrc_SalesLine."Line No.");
                                    EXIT;
                                END;
                            END ELSE
                                ERROR('Es ist kein offener Rahmenauftrag für Leergut Debitor %1 vorhanden',
                                      lrc_Customer."POI Leergutberechnung an Deb");
                            lrc_SalesHeader2.RESET();
                            lrc_SalesHeader2.SETRANGE("Sell-to Customer No.", lrc_Customer."POI Leergutberechnung an Deb");
                            lrc_SalesHeader2.SETRANGE("Document Type", lrc_SalesHeader2."Document Type"::"Blanket Order");
                            lrc_SalesHeader2.SETRANGE("No.", Buffer.code2);
                            lrc_SalesHeader2.FIND();

                            //letzte Line No. ermitteln
                            lrc_SalesLine2.RESET();
                            lrc_SalesLine2.SETRANGE("Document Type", lrc_SalesHeader2."Document Type");
                            lrc_SalesLine2.SETRANGE("Document No.", lrc_SalesHeader2."No.");
                            IF lrc_SalesLine2.FINDLAST() THEN
                                lin_LineNo := lrc_SalesLine2."Line No."
                            ELSE
                                lin_LineNo := 10000;


                            //Leergutzheile anlegen
                            lrc_SalesLine2.RESET();
                            lrc_SalesLine2.INIT();
                            lrc_SalesLine2."Document Type" := lrc_SalesHeader2."Document Type";
                            lrc_SalesLine2."Document No." := lrc_SalesHeader2."No.";
                            lrc_SalesLine2."Line No." := lin_LineNo + 10000;
                            lrc_SalesLine2.VALIDATE("Sell-to Customer No.", lrc_SalesHeader2."Sell-to Customer No.");
                            lrc_SalesLine2.VALIDATE("Bill-to Customer No.", lrc_SalesHeader2."Bill-to Customer No.");
                            lrc_SalesLine2.INSERT(TRUE);
                            lrc_SalesLine2.VALIDATE(Type, lrc_SalesLine2.Type::Item);
                            lrc_SalesLine2.VALIDATE("No.", lrc_SalesLine."POI Empties Item No.");
                            lrc_SalesLine2.VALIDATE("Location Code", lrc_SalesLine."Location Code");
                            lrc_SalesLine2.VALIDATE("POI Batch Variant No.", lrc_BatchVariant."No.");
                            lrc_SalesLine2.MODIFY(TRUE);
                            IF vop_DocType = vop_DocType::"4" THEN //bei Gutschrift negative Menge
                                lrc_SalesLine2.VALIDATE(Quantity, -vdc_EmptiesQuantity)
                            ELSE
                                lrc_SalesLine2.VALIDATE(Quantity, vdc_EmptiesQuantity);
                            lrc_SalesLine2.VALIDATE("POI Empties Order No. Refer", lrc_SalesLine."Document No."); //link Rahmenauftragszeile/Auftragsz.
                            lrc_SalesLine2.VALIDATE("POI Empt Order Ref. Line No.", lrc_SalesLine."Line No.");//link Rahmenauftragszeile/Auftragszeile
                            lrc_SalesLine2."POI Item Attribute 6" := lrc_SalesLine."POI Item Attribute 6";
                            lrc_SalesLine2.MODIFY(TRUE);

                            //Leergutzeilennummer und Leergutauftragsnummer in VK-Zeile übernehmen
                            rco_EmptiesBlanketDocNo := lrc_SalesLine2."Document No.";
                            rin_EmptiesBlanketLineNo := lrc_SalesLine2."Line No.";
                            EXIT;
                            //END ELSE BEGIN
                            //MESSAGE('Zur Position %1 gibt es keine zugeordnete Leergutzeile', lrc_PurchLine."POI Batch Variant No.");
                            //END
                        END;
                    END;

                    //COMMIT;
                END;
            lrc_BatchVariant.Source::"Packing Order":
                BEGIN
                    //160229 RS zuerst zugehörige Leergutzeile ermitteln
                    lrc_PackOrderOutput.SETRANGE("Batch Variant No.", lrc_SalesLine."POI Batch Variant No.");
                    lrc_PackOrderOutput.FINDSET(FALSE, FALSE);
                    lin_LineNo2 := lrc_PackOrderOutput."Empties Attached Line No.";
                    lrc_PackOrderOutput.RESET();
                    lrc_PackOrderOutput.SETRANGE("Master Batch No.", lrc_SalesLine."POI Master Batch No.");
                    lrc_PackOrderOutput.SETRANGE("Line No.", lin_LineNo2);
                    lrc_PackOrderOutput.FINDSET(FALSE, FALSE);

                    //Prüfung ob Leergutzeile in Verkaufsauftrag oder in Rahmenauftrag eingefügt werden soll
                    lrc_Customer.GET(lrc_SalesLine."Sell-to Customer No.");
                    IF lrc_Customer."POI Leergutberechnung an Deb" = '' THEN BEGIN //2
                                                                                   //Leergutberechnung erfolgt direkt an Kunden
                                                                                   //------------------------------------------
                                                                                   //ermitteln von Leergut Positionsnummer und laden der Positions Variante
                        lrc_BatchVariant.GET(lrc_PackOrderOutput."Batch Variant No.");
                        IF lrc_SalesLine."POI Empties Line No" <> 0 THEN BEGIN //3
                            MESSAGE('Es ist bereits eine Leergutzeile zur Zeile %1 vorhanden', lrc_SalesLine."Line No.");
                            EXIT;
                        END; //3e

                        //Leergutzheile anlegen
                        lrc_SalesLine2.RESET();
                        lrc_SalesLine2.INIT();
                        lrc_SalesLine2."Document Type" := lrc_SalesLine."Document Type";
                        lrc_SalesLine2."Document No." := lrc_SalesLine."Document No.";
                        lrc_SalesLine2."Line No." := lrc_SalesLine."Line No." + 100;
                        lrc_SalesLine2.VALIDATE("Sell-to Customer No.", lrc_SalesHeader."Sell-to Customer No.");
                        lrc_SalesLine2.VALIDATE("Bill-to Customer No.", lrc_SalesHeader."Bill-to Customer No.");
                        lrc_SalesLine2.INSERT(TRUE);
                        lrc_SalesLine2.VALIDATE(Type, lrc_SalesLine2.Type::Item);
                        lrc_SalesLine2.VALIDATE("No.", lrc_SalesLine."POI Empties Item No.");
                        lrc_SalesLine2.VALIDATE("Location Code", lrc_SalesLine."Location Code");
                        lrc_SalesLine2.VALIDATE("POI Batch Variant No.", lrc_BatchVariant."No.");
                        lrc_SalesLine2.MODIFY(TRUE);
                        IF vop_DocType = vop_DocType::"4" THEN //bei Gutschrift negative Menge
                            lrc_SalesLine2.VALIDATE(Quantity, -vdc_EmptiesQuantity)
                        ELSE
                            lrc_SalesLine2.VALIDATE(Quantity, vdc_EmptiesQuantity);
                        lrc_SalesLine2."Attached to Line No." := lrc_SalesLine."Line No.";
                        lrc_SalesLine2.MODIFY(TRUE);
                        //Leergutzeilennummer in VK-Zeile übernehmen
                        rin_EmptiesLineNo := lrc_SalesLine."Line No." + 100;//lrc_SalesLine2."Line No.";
                        EXIT;
                        //END ELSE BEGIN
                        //MESSAGE('Zur Position %1 gibt es keine zugeordnete Leergutzeile', lrc_PackOrderOutput."Batch Variant No.");
                        //END;
                    END ELSE BEGIN

                        //Leergutberechnung erfolgt an Europool, Rahmenauftragszeile anlegen
                        //------------------------------------------------------------------
                        //ermitteln von Leergut Positionsnummer und laden der Positions Variante
                        lrc_BatchVariant.GET(lrc_PackOrderOutput."Batch Variant No.");

                        lrc_SalesHeader2.SETRANGE("Sell-to Customer No.", lrc_Customer."POI Leergutberechnung an Deb");
                        lrc_SalesHeader2.SETRANGE("Document Type", lrc_SalesHeader2."Document Type"::"Blanket Order");
                        lrc_SalesHeader2.SETRANGE(Status, lrc_SalesHeader2.Status::Open);
                        //Prüfung ob Rahmenauftrag und Rahmenauftragszeile vorhanden
                        IF lrc_SalesHeader2.FINDSET(FALSE, FALSE) THEN BEGIN
                            lrc_SalesLine2.RESET();
                            lrc_SalesLine2.SETRANGE("Document Type", lrc_SalesHeader2."Document Type");
                            lrc_SalesLine2.SETRANGE("POI Customer Order No.", lrc_SalesLine."Document No.");
                            lrc_SalesLine2.SETRANGE("POI Customer Line Reference", lrc_SalesLine."Line No.");
                            IF lrc_SalesLine2.FINDSET(FALSE, FALSE) THEN BEGIN
                                MESSAGE('Es ist bereits eine Leergutzeile zur Zeile %1 vorhanden', lrc_SalesLine."Line No.");
                                EXIT;
                            END;
                        END ELSE
                            ERROR('Es ist kein offener Rahmenauftrag für Leergut Debitor %1 vorhanden',
                                  lrc_Customer."POI Leergutberechnung an Deb");
                        lrc_SalesHeader2.RESET();
                        lrc_SalesHeader2.SETRANGE("Sell-to Customer No.", lrc_Customer."POI Leergutberechnung an Deb");
                        lrc_SalesHeader2.SETRANGE("Document Type", lrc_SalesHeader2."Document Type"::"Blanket Order");
                        lrc_SalesHeader2.FINDLAST();
                        //letzte Line No. ermitteln
                        lrc_SalesLine2.RESET();
                        lrc_SalesLine2.SETRANGE("Document Type", lrc_SalesHeader2."Document Type");
                        lrc_SalesLine2.SETRANGE("Document No.", lrc_SalesHeader2."No.");
                        IF lrc_SalesLine2.FINDLAST() THEN
                            lin_LineNo := lrc_SalesLine2."Line No."
                        ELSE
                            lin_LineNo := 10000;
                        //Leergutzheile anlegen
                        lrc_SalesLine2.RESET();
                        lrc_SalesLine2.INIT();
                        lrc_SalesLine2."Document Type" := lrc_SalesHeader2."Document Type";
                        lrc_SalesLine2."Document No." := lrc_SalesHeader2."No.";
                        lrc_SalesLine2."Line No." := lin_LineNo + 10000;
                        lrc_SalesLine2.VALIDATE("Sell-to Customer No.", lrc_SalesHeader2."Sell-to Customer No.");
                        lrc_SalesLine2.VALIDATE("Bill-to Customer No.", lrc_SalesHeader2."Bill-to Customer No.");
                        lrc_SalesLine2.INSERT(TRUE);
                        lrc_SalesLine2.VALIDATE(Type, lrc_SalesLine2.Type::Item);
                        lrc_SalesLine2.VALIDATE("No.", lrc_SalesLine."POI Empties Item No.");
                        lrc_SalesLine2.VALIDATE("Location Code", lrc_SalesLine."Location Code");
                        lrc_SalesLine2.VALIDATE("POI Batch Variant No.", lrc_BatchVariant."No.");
                        lrc_SalesLine2.MODIFY(TRUE);
                        IF vop_DocType = vop_DocType::"4" THEN //bei Gutschrift negative Menge
                            lrc_SalesLine2.VALIDATE(Quantity, -vdc_EmptiesQuantity)
                        ELSE
                            lrc_SalesLine2.VALIDATE(Quantity, vdc_EmptiesQuantity);
                        lrc_SalesLine2.VALIDATE("POI Empties Order No. Refer", lrc_SalesLine."Document No."); //link Rahmenauftragszeile/Auftragsz.
                        lrc_SalesLine2.VALIDATE("POI Empt Order Ref. Line No.", lrc_SalesLine."Line No.");//link Rahmenauftragszeile/Auftragszeile
                        lrc_SalesLine2."POI Item Attribute 6" := lrc_SalesLine."POI Item Attribute 6";
                        lrc_SalesLine2.MODIFY(TRUE);
                        //Leergutzeilennummer und Leergutauftragsnummer in VK-Zeile übernehmen
                        rco_EmptiesBlanketDocNo := lrc_SalesLine2."Document No.";
                        rin_EmptiesBlanketLineNo := lrc_SalesLine2."Line No.";
                        EXIT;
                        //END ELSE BEGIN
                        //MESSAGE('Zur Position %1 gibt es keine zugeordnete Leergutzeile', lrc_PurchLine."POI Batch Variant No.");
                        //END
                    END;
                END;

        END;
    end;

    procedure SalesAttachEmptiesfromClaim(vco_BatchVariantNo: Code[20]; vco_SalesOrderNo: Code[20]; vin_SalesOrderLineNo: Integer; vco_ClaimLocationCode: Code[20]; vco_EmptiesItemNo: Code[20]; vdc_ClaimQuantity: Decimal; vcd_CrMemoNo: Code[20]; vcd_Customer: Code[20]; var rco_EmptiesBlanketDocNo: Code[20]; var rin_EmptiesBlanketLineNo: Integer)
    var
    // lrc_BatchVariant: Record "POI Batch Variant";
    // lrc_SalesHeader: Record "Sales Header";
    // lrc_Customer: Record Customer;
    // lrc_SalesLine: Record "Sales Line";
    // lrc_ProperName: Record "POI Proper Name";
    // lrc_PurchaseLine: Record "Purchase Line";
    // lrc_PurchaseLine2: Record "Purchase Line";
    // lin_LineNo: Integer;
    begin
        /************************************
        //----------------------------------------------------------------------------------
        //Funktion zur Erstellung einer Gutschriftszeile im Rahmenauftrag aus einer VK Rekla
        //----------------------------------------------------------------------------------
        //Leergutberechnung erfolgt an Europool, Rahmenauftragszeile anlegen
        
        //vco_BatchVariantNo Code20
        //vco_SalesOrderNo Code20
        //vin_SalesOrderLineNo Integer
        //vco_ClaimLocationCode Code20
        //vco_EmptiesItemNo Code20
        //vdc_ClaimQuantity Decimal
        //vcd_CrMemoNo Code 20
        //vcd_Customer Code 20
        //rco_EmptiesBlanketDocNo Code 20
        //rin_EmptiesBlanketLineNo Integer
        
        //-----------------------------------------------------------------------------------
        IF NOT CONFIRM('Soll die Leergutmenge ebenfalls gutgeschrieben werden?', TRUE) THEN BEGIN
          MESSAGE('Die zugehörige Rahmenauftragszeile ist nicht angelegt');
          EXIT;
        END;
        
        //ermitteln von Leergut Positionsnummer und laden der Positions Variante
        IF vco_BatchVariantNo <> '' THEN
          lrc_BatchVariant.GET(vco_BatchVariantNo);
        lrc_Customer.GET(vcd_Customer);
        
        CASE lrc_BatchVariant.Source OF
          lrc_BatchVariant.Source::"Purch. Order":
          BEGIN
            lrc_SalesHeader.SETRANGE("Sell-to Customer No.", lrc_Customer."POI Leergutberechnung an Deb");
            lrc_SalesHeader.SETRANGE("Document Type", lrc_SalesHeader."Document Type":: "Blanket Order");
            lrc_SalesHeader.SETRANGE(Status, lrc_SalesHeader.Status :: Open);
            IF NOT lrc_SalesHeader.FINDLAST() THEN
              ERROR('Es ist kein offener Rahmenauftrag für Leergut Debitor %1 vorhanden',
                    lrc_Customer."POI Leergutberechnung an Deb");
            //zugehörige Leergutpartie ermitteln
            lrc_PurchaseLine.SETRANGE("Batch Variant No.", vco_BatchVariantNo);
            lrc_PurchaseLine.FINDSET(FALSE, FALSE);
            lrc_PurchaseLine2.SETRANGE("Document Type", lrc_PurchaseLine."Document Type");
            lrc_PurchaseLine2.SETRANGE("Document No.", lrc_PurchaseLine."Document No.");
            lrc_PurchaseLine2.SETRANGE("Line No.", lrc_PurchaseLine."Empties Attached Line No");
            lrc_PurchaseLine2.FINDSET(FALSE, FALSE);
        
            lrc_SalesLine.RESET();
            lrc_SalesLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
            lrc_SalesLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
            IF lrc_SalesLine.FINDLAST() THEN
              lin_LineNo := lrc_SalesLine."Line No."
            ELSE
              lin_LineNo := 10000;
        
            //Leergutzeile anlegen
            lrc_SalesLine.RESET();
            lrc_SalesLine.INIT();
            lrc_SalesLine."Document Type" := lrc_SalesHeader."Document Type";
            lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
            lrc_SalesLine."Line No." := lin_LineNo + 10000;
            lrc_SalesLine.VALIDATE("Sell-to Customer No.",lrc_SalesHeader."Sell-to Customer No.");
            lrc_SalesLine.VALIDATE("Bill-to Customer No.",lrc_SalesHeader."Bill-to Customer No.");
            lrc_SalesLine.INSERT(TRUE);
            lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::Item);
            lrc_SalesLine.VALIDATE("No.", vco_EmptiesItemNo);
            lrc_SalesLine.VALIDATE("Location Code", vco_ClaimLocationCode);
            lrc_SalesLine.VALIDATE("Batch Variant No.", lrc_PurchaseLine2."Batch Variant No.");
            lrc_SalesLine.MODIFY(TRUE);
            lrc_SalesLine.VALIDATE(Quantity, -vdc_ClaimQuantity);
            lrc_SalesLine."Empties Order No. Reference" := vco_SalesOrderNo; //link Rahmenauftragszeile
                                                                              //ursprüngl. Auftragsz.
            lrc_SalesLine."Info 1" := vcd_CrMemoNo;
            lrc_ProperName.SETRANGE(Artikelnummer, vco_EmptiesItemNo);
            IF lrc_ProperName.FINDSET(FALSE, FALSE) THEN
              lrc_SalesLine."Item Attribute 6" := lrc_ProperName.Code;
            lrc_SalesLine.MODIFY(TRUE);
            rco_EmptiesBlanketDocNo := lrc_SalesLine."Document No.";
            rin_EmptiesBlanketLineNo := lrc_SalesLine."Line No.";
        
            EXIT;
          END;
        
          lrc_BatchVariant.Source::"Packing Order":
            BEGIN
              lrc_SalesHeader.SETRANGE("Sell-to Customer No.", lrc_Customer."POI Leergutberechnung an Deb");
              lrc_SalesHeader.SETRANGE("Document Type", lrc_SalesHeader."Document Type":: "Blanket Order");
              lrc_SalesHeader.SETRANGE(Status, lrc_SalesHeader.Status :: Open);
              IF NOT lrc_SalesHeader.FINDLAST() THEN
                ERROR('Es ist kein offener Rahmenauftrag für Leergut Debitor %1 vorhanden',
                      lrc_Customer."POI Leergutberechnung an Deb");
              lrc_SalesLine.RESET();
              lrc_SalesLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
              lrc_SalesLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
              IF lrc_SalesLine.FINDLAST() THEN
                lin_LineNo := lrc_SalesLine."Line No."
              ELSE
                lin_LineNo := 10000;
              //Leergutzeile anlegen
              lrc_SalesLine.RESET();
              lrc_SalesLine.INIT();
              lrc_SalesLine."Document Type" := lrc_SalesHeader."Document Type";
              lrc_SalesLine."Document No." := lrc_SalesHeader."No.";
              lrc_SalesLine."Line No." := lin_LineNo + 10000;
              lrc_SalesLine.VALIDATE("Sell-to Customer No.",lrc_SalesHeader."Sell-to Customer No.");
              lrc_SalesLine.VALIDATE("Bill-to Customer No.",lrc_SalesHeader."Bill-to Customer No.");
              lrc_SalesLine.INSERT(TRUE);
              lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::Item);
              lrc_SalesLine.VALIDATE("No.", vco_EmptiesItemNo);
              lrc_SalesLine.VALIDATE("Location Code", vco_ClaimLocationCode);
              lrc_SalesLine.VALIDATE("Batch Variant No.", vco_BatchVariantNo);
              lrc_SalesLine.MODIFY(TRUE);
              lrc_SalesLine.VALIDATE(Quantity, -vdc_ClaimQuantity);
              lrc_SalesLine."Empties Order No. Reference" := vco_SalesOrderNo; //link Rahmenauftragszeile
                                                                                //ursprüngl. Auftragsz.
              lrc_SalesLine."Info 1" := vcd_CrMemoNo;
              lrc_ProperName.SETRANGE(Artikelnummer, vco_EmptiesItemNo);
              IF lrc_ProperName.FINDSET(FALSE, FALSE) THEN
                lrc_SalesLine."Item Attribute 6" := lrc_ProperName.Code;
              lrc_SalesLine.MODIFY(TRUE);
              rco_EmptiesBlanketDocNo := lrc_SalesLine."Document No.";
              rin_EmptiesBlanketLineNo := lrc_SalesLine."Line No.";
              EXIT;
            END;
        END;
        *************************************/

    end;

    procedure PurchAttachEmptiesToCurrLine(vrc_PurchLine: Record "Purchase Line"; vrc_PurchHeader: Record "Purchase Header"; var rin_EmptiesLineNo: Integer)
    var
        lbo_Destination: Boolean;
    begin
        //---------------------------------------------------------------
        //Funktion um aus der aktuellen Zeile eine Leergutzeile anzulegen
        //---------------------------------------------------------------
        //lrc_PurchHeader.GET(vrc_PurchLine."Document Type", vrc_PurchLine."Document No.");
        //lrc_PurchLine.GET(vop_DocType, vco_DocNo, vin_LineNo);

        IF vrc_PurchLine.Type <> vrc_PurchLine.Type::Item THEN
            EXIT;

        IF vrc_PurchLine."POI Empties Attached Line No" <> 0 THEN BEGIN
            MESSAGE('Zur Einkaufszeile %1 besteht bereits eine Leergutzeile', vrc_PurchLine."Line No.");
            EXIT;
        END;

        IF vrc_PurchHeader."POI Destination Country Code" = '' THEN BEGIN
            lbo_Destination := TRUE;
            vrc_PurchHeader."POI Destination Country Code" := 'NL';
            vrc_PurchHeader.MODIFY();
        END;

        //----------------------------------
        //Leergutzeile anlegen
        //----------------------------------
        lrc_PurchLine2.RESET();
        lrc_PurchLine2.INIT();
        lrc_PurchLine2."Document Type" := vrc_PurchLine."Document Type";
        lrc_PurchLine2."Document No." := vrc_PurchLine."Document No.";
        lrc_PurchLine2."Line No." := vrc_PurchLine."Line No." + 100;
        lrc_PurchLine2.INSERT(TRUE);
        lrc_PurchLine2.VALIDATE("Buy-from Vendor No.", vrc_PurchHeader."Buy-from Vendor No.");
        lrc_PurchLine2.VALIDATE("Pay-to Vendor No.", vrc_PurchHeader."Pay-to Vendor No.");
        lrc_PurchLine2.VALIDATE(Type, lrc_PurchLine2.Type::Item);
        lrc_PurchLine2.VALIDATE("No.", vrc_PurchLine."POI Empties Item No.");
        lrc_PurchLine2."Location Code" := vrc_PurchLine."Location Code";
        lrc_PurchLine2.VALIDATE(Quantity, vrc_PurchLine."POI Empties Quantity");
        lrc_PurchLine2."Attached to Line No." := vrc_PurchLine."Line No.";
        lrc_PurchLine2.MODIFY(TRUE);

        lrc_PurchLine2.GET(vrc_PurchLine."Document Type", vrc_PurchLine."Document No.", vrc_PurchLine."Line No." + 100);
        lrc_Item.GET(lrc_PurchLine2."No.");
        lrc_PurchLine2.VALIDATE("POI Price Base (Purch. Price)", lrc_Item."POI Price Base (Purch. Price)");
        //Preis aus Leerguttabelle
        lrc_EmptiesPrice.SETRANGE("Item No.", lrc_PurchLine2."No.");
        //lrc_EmptiesPrice.SETRANGE("Source Type", lrc_EmptiesPrice."Source Type"::"Purchase Global");
        lrc_EmptiesPrice.SETRANGE("Source Type", lrc_EmptiesPrice."Source Type"::Vendor);
        lrc_EmptiesPrice.SETFILTER("Starting Date", '<=%1', lrc_PurchLine2."POI Departure Date");
        lrc_EmptiesPrice.SETFILTER("Ending Date", '>=%1|%2', lrc_PurchLine2."POI Departure Date", 0D);

        IF lrc_EmptiesPrice.FINDSET(FALSE, FALSE) THEN
            lrc_PurchLine2.VALIDATE("POI Purch. Price (Price Base)", lrc_EmptiesPrice."Receipt Price (LCY)");
        lrc_PurchLine2.MODIFY(TRUE);

        IF lbo_Destination = TRUE THEN BEGIN
            vrc_PurchHeader."POI Destination Country Code" := '';
            vrc_PurchHeader.MODIFY();
        END;

        rin_EmptiesLineNo := lrc_PurchLine2."Line No.";
        EXIT;
    end;

    procedure PackInputAttachEmptiesLine(vco_PackOrderInputNo: Code[20]; vin_PackOrderInputLineNo: Integer; vdc_quantity: Decimal)
    var
        lrc_PackOrderInputLine2: Record "POI Pack. Order Input Items";
        lrc_BatchVariant: Record "POI Batch Variant";
    //lrc_PackOrderOutputLine: Record "POI Pack. Order Output Items";
    //lin_OutputLine: Integer;
    begin
        //----------------------------------------------------------
        //Funktion zum Anlegen der Leergut Inputzeile im Packauftrag
        //  vco_PackOrderInputNo - Packauftragsnummer
        //  vin_PackOrderInputLineNo
        //  vdc_Quantity - Leergutmenge
        //----------------------------------------------------------
        //Artikelzeile laden
        lrc_PackOrderInputLine.GET(vco_PackOrderInputNo, 0, vin_PackOrderInputLineNo);

        IF lrc_PackOrderInputLine."Empties Attached Line No." <> 0 THEN BEGIN
            MESSAGE('Zur Packauftragsinputzeile %1 besteht bereits eine Leergutzeile', vin_PackOrderInputLineNo);
            EXIT;
        END;

        //--------------------
        //Leergutzeile anlegen
        //--------------------
        lrc_PackOrderInputLine2.RESET();
        lrc_PackOrderInputLine2.INIT();
        lrc_PackOrderInputLine2."Doc. No." := lrc_PackOrderInputLine."Doc. No.";
        lrc_PackOrderInputLine2."Doc. Line No. Output" := 0;
        lrc_PackOrderInputLine2."Line No." := lrc_PackOrderInputLine."Line No." + 100;
        lrc_PackOrderInputLine2.INSERT();

        //InputLine aus Packauftrag oder aus EK-Bestellung
        lrc_BatchVariant.GET(lrc_PackOrderInputLine."Batch Variant No.");

        CASE lrc_BatchVariant.Source OF
            lrc_BatchVariant.Source::"Purch. Order":
                BEGIN
                    //Leergutartikel aus EK-Zeile laden
                    lrc_PurchaseLine.SETRANGE("POI Batch Variant No.", lrc_PackOrderInputLine."Batch Variant No.");
                    lrc_PurchaseLine.FINDSET();
                    lrc_PurchaseLine.GET(lrc_PurchaseLine."Document Type", lrc_PurchaseLine."Document No.",
                                         lrc_PurchaseLine."POI Empties Attached Line No");
                    lrc_PackOrderInputLine2.VALIDATE(Type, lrc_PackOrderInputLine2.Type::Item);
                    lrc_PackOrderInputLine2.VALIDATE("Item No.", lrc_PackOrderInputLine."Empties Item No.");
                    lrc_PackOrderInputLine2.VALIDATE("Batch Variant No.", lrc_PurchaseLine."POI Batch Variant No.");
                    lrc_PackOrderInputLine2.VALIDATE("Location Code", lrc_PackOrderInputLine."Location Code");
                    lrc_PackOrderInputLine2.VALIDATE(Quantity, vdc_quantity);
                    lrc_PackOrderInputLine2."Attached to Line No." := lrc_PackOrderInputLine."Line No.";
                    lrc_PackOrderInputLine2.MODIFY(TRUE);
                    lrc_PackOrderInputLine."Empties Attached Line No." := lrc_PackOrderInputLine2."Line No.";
                    lrc_PackOrderInputLine."Empties Item Qty." := vdc_quantity;
                    lrc_PackOrderInputLine.MODIFY(TRUE);
                    COMMIT();
                END;
            lrc_BatchVariant.Source::"Packing Order":
                BEGIN
                    // lrc_PackOrderOutputLine.SETRANGE("Batch Variant No.", lrc_PackOrderInputLine."Batch Variant No.");
                    // lrc_PackOrderOutputLine.FINDSET();
                    lrc_PackOrderInputLine2.VALIDATE(Type, lrc_PackOrderInputLine2.Type::Item);
                    lrc_PackOrderInputLine2.VALIDATE("Item No.", lrc_PackOrderInputLine."Empties Item No.");
                    lrc_PackOrderInputLine2.VALIDATE("Batch Variant No.", lrc_PurchaseLine."POI Batch Variant No.");
                    lrc_PackOrderInputLine2.VALIDATE("Location Code", lrc_PackOrderInputLine."Location Code");
                    lrc_PackOrderInputLine2.VALIDATE(Quantity, vdc_quantity);
                    lrc_PackOrderInputLine2."Attached to Line No." := lrc_PackOrderInputLine."Line No.";
                    lrc_PackOrderInputLine2.MODIFY(TRUE);
                    lrc_PackOrderInputLine."Empties Attached Line No." := lrc_PackOrderInputLine2."Line No.";
                    lrc_PackOrderInputLine."Empties Item Qty." := vdc_quantity;
                    lrc_PackOrderInputLine.MODIFY(TRUE);
                    COMMIT();
                END;
        END;
    end;

    procedure PackOutputAttachEmptiesLine(vrc_PackOrderOutputLine: Record "POI Pack. Order Output Items")
    var
        lrc_PackOrderOutputLine2: Record "POI Pack. Order Output Items";
    begin
        //----------------------------------------------------------
        //Funktion zum Anlegen der Leergut Outputzeile im Packauftrag
        //  vco_PackOrderOutputNo - Packauftragsnummer
        //  vin_PackOrderOutputLineNo
        //  vdc_Quantity - Leergutmenge
        //----------------------------------------------------------
        //Artikelzeile laden
        // lrc_PackOrderOutputLine.GET(vco_PackOrderOutputNo, vin_PackOrderOutputLineNo);

        IF vrc_PackOrderOutputLine."Empties Attached Line No." <> 0 THEN BEGIN
            MESSAGE('Zur Packauftragsinputzeile %1 besteht bereits eine Leergutzeile', vrc_PackOrderOutputLine."Line No.");
            EXIT;
        END;

        //--------------------
        //Leergutzeile anlegen
        //--------------------
        lrc_PackOrderOutputLine2.RESET();
        lrc_PackOrderOutputLine2.INIT();
        lrc_PackOrderOutputLine2."Type of Packing Product" := lrc_PackOrderOutputLine2."Type of Packing Product"::"Finished Product";
        lrc_PackOrderOutputLine2."Doc. No." := vrc_PackOrderOutputLine."Doc. No.";
        lrc_PackOrderOutputLine2."Line No." := vrc_PackOrderOutputLine."Line No." + 100;
        lrc_PackOrderOutputLine2.INSERT(TRUE);

        lrc_PackOrderOutputLine2.VALIDATE("Item No.", vrc_PackOrderOutputLine."Empties Item No.");
        lrc_PackOrderOutputLine2.VALIDATE(Quantity, vrc_PackOrderOutputLine.Quantity);
        lrc_PackOrderOutputLine2."Attached to Line No." := vrc_PackOrderOutputLine."Line No.";
        lrc_PackOrderOutputLine2.VALIDATE("Location Code", vrc_PackOrderOutputLine."Location Code");
        lrc_PackOrderOutputLine2.MODIFY(TRUE);
        COMMIT();
    end;

    procedure TransferAttachEmptiesLine(var vrc_TransferLine: Record "Transfer Line")
    var
        lrc_TransferLine2: Record "Transfer Line";
        lrc_BatchVariant: Record "POI Batch Variant";
    //lrc_PurchLine2: Record "Purchase Line";
    begin
        //----------------------------------------------------------
        //Funktion zum Anlegen der Umlagerungs-Leergutzeile
        //  vco_TransferNo - Packauftragsnummer
        //  vin_TransferLineNo
        //  vdc_Quantity - Leergutmenge
        //----------------------------------------------------------

        IF vrc_TransferLine."POI Empties Attached Line No." <> 0 THEN
            //MESSAGE('Zur Umlagerungsinputzeile %1 besteht bereits eine Leergutzeile', vrc_TransferLine."Line No.");
            EXIT;

        //--------------------
        //Leergutzeile anlegen
        //--------------------
        lrc_TransferLine2.RESET();
        lrc_TransferLine2.INIT();
        lrc_TransferLine2."Document No." := vrc_TransferLine."Document No.";
        lrc_TransferLine2."Line No." := vrc_TransferLine."Line No." + 100;
        lrc_TransferLine2.INSERT();

        //InputLine aus Packauftrag oder aus EK-Bestellung
        lrc_BatchVariant.GET(vrc_TransferLine."POI Batch Variant No.");

        CASE lrc_BatchVariant.Source OF
            lrc_BatchVariant.Source::"Purch. Order":
                BEGIN
                    //Leergutartikel aus EK-Zeile laden
                    lrc_PurchaseLine.SETRANGE("POI Batch Variant No.", vrc_TransferLine."POI Batch Variant No.");
                    lrc_PurchaseLine.FINDSET();
                    lrc_PurchaseLine.GET(lrc_PurchaseLine."Document Type", lrc_PurchaseLine."Document No.",
                                         lrc_PurchaseLine."POI Empties Attached Line No");
                    lrc_TransferLine2.VALIDATE("Item No.", vrc_TransferLine."POI Empties Item No.");
                    lrc_TransferLine2.VALIDATE("POI Batch Variant No.", lrc_PurchaseLine."POI Batch Variant No.");
                    lrc_TransferLine2.VALIDATE("Transfer-from Code", vrc_TransferLine."Transfer-from Code");
                    lrc_TransferLine2.VALIDATE("Transfer-to Code", vrc_TransferLine."Transfer-to Code");
                    lrc_TransferLine2.VALIDATE(Quantity, vrc_TransferLine.Quantity);
                    lrc_TransferLine2."POI Attached to Line No." := vrc_TransferLine."Line No.";
                    lrc_TransferLine2.MODIFY(TRUE);
                    COMMIT();
                    vrc_TransferLine."POI Empties Attached Line No." := lrc_TransferLine2."Line No.";
                    vrc_TransferLine."POI Empties Quantity" := lrc_TransferLine2.Quantity;
                END;
            lrc_BatchVariant.Source::"Packing Order":
                BEGIN
                    //Leergutartikel aus EK-Zeile laden
                    lrc_PackOrderOutputLine.SETRANGE("Batch Variant No.", vrc_TransferLine."POI Batch Variant No.");
                    lrc_PackOrderOutputLine.FINDSET();
                    lrc_PackOrderOutputLine.GET(lrc_PackOrderOutputLine."Doc. No.", lrc_PackOrderOutputLine."Empties Attached Line No.");
                    lrc_TransferLine2.VALIDATE("Item No.", vrc_TransferLine."POI Empties Item No.");
                    lrc_TransferLine2.VALIDATE("POI Batch Variant No.", lrc_PackOrderOutputLine."Batch Variant No.");
                    lrc_TransferLine2.VALIDATE("Transfer-from Code", vrc_TransferLine."Transfer-from Code");
                    lrc_TransferLine2.VALIDATE("Transfer-to Code", vrc_TransferLine."Transfer-to Code");
                    lrc_TransferLine2.VALIDATE(Quantity, vrc_TransferLine.Quantity);
                    lrc_TransferLine2."POI Attached to Line No." := vrc_TransferLine."Line No.";
                    lrc_TransferLine2.MODIFY(TRUE);
                    vrc_TransferLine."POI Empties Attached Line No." := lrc_TransferLine2."Line No.";
                    vrc_TransferLine."POI Empties Quantity" := lrc_TransferLine2.Quantity;
                    vrc_TransferLine.MODIFY(TRUE);
                    COMMIT();
                END;
        END
    end;

    procedure CreatePurchase(vco_VendorNo: Code[10]; vdt_PackingDate: Date; vco_ItemNo: Code[10]; vco_LocationCode: Code[20])
    begin
    end;

    var
        lrc_PurchLine: Record "Purchase Line";
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_PurchLine2: Record "Purchase Line";
        lrc_PriceCalculation: Record "POI Price Base";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_RefundCosts: Record "POI Empties/Transport Ref Cost";
        lrc_SalesLine: Record "Sales Line";
        lrc_Item: Record Item;
        lrc_PurchEmpties: Record "POI Purchase Empties";
        lrc_VendCustShipAgentEmpties: Record "POI V/C Ship.AgentEmpties";
        lrc_SalesEmpties: Record "POI Sales Empties";

        lrc_EmptiesPrice: Record "POI Empties/Transport Ref Cost";
        lrc_PackOrderInputLine: Record "POI Pack. Order Input Items";
        lrc_TransferEmpties: Record "POI Transfer Empties";
        lrc_TransferLine: Record "Transfer Line";
        lrc_SalesLine2: Record "Sales Line";
        lrc_SalesHeader2: Record "Sales Header";
        lrc_PackOrderOutput: Record "POI Pack. Order Input Items";
        SalesHeaderHELP: Record "Sales Header";
        Buffer: Record "POI temp Buffer" temporary;
        lrc_PackOrderOutputLine: Record "POI Pack. Order Input Items";
}

