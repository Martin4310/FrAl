codeunit 5087910 "POI Item Attribute Mask Mgt"
{


    var
        AGILESText001Txt: Label 'Mandatory field %1 in the line %2 is empty.', Comment = '%1 %2';
    //System: Codeunit "1";

    procedure GetItemAttributesMask(var rrc_ItemAttributesMask: Record "POI Item Attributes Mask"; var rrc_Item: Record Item)
    var
        ltx_Empty: Text[30];
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        ltx_Empty := '';
        rrc_ItemAttributesMask.RESET();
        rrc_ItemAttributesMask.SETRANGE(Area, rrc_ItemAttributesMask.Area);
        rrc_ItemAttributesMask.SETFILTER("Item Main Category Code", '%1|%2', rrc_Item."POI Item Main Category Code", ltx_Empty);
        rrc_ItemAttributesMask.SETFILTER("Item Category Code", '%1|%2', rrc_Item."Item Category Code", ltx_Empty);
        rrc_ItemAttributesMask.SETFILTER("Product Group Code", '%1|%2', rrc_Item."POI Product Group Code", ltx_Empty);
        rrc_ItemAttributesMask.SETFILTER("Item No.", '%1|%2', rrc_Item."No.", ltx_Empty);
        rrc_ItemAttributesMask.FINDLAST();
    end;


    procedure PurchLineCheckOnValidate(var rrc_RecPurchaseLine: Record "Purchase Line"; var rrc_xRecPurchaseLine: Record "Purchase Line"; vin_FieldNo: Integer)
    var
        lrc_ItemAttributesMask: Record "POI Item Attributes Mask";
        lrc_Item: Record Item;
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        // Systematik nur für Artikelzeilen anwenden
        IF (rrc_RecPurchaseLine.Type <> rrc_RecPurchaseLine.Type::Item) OR
           (rrc_RecPurchaseLine."No." = '') THEN
            EXIT;

        // Wenn die Systematik noch nicht im Einsatz ist, keine Prüfung durchführen
        IF lrc_ItemAttributesMask.Isempty() THEN
            EXIT;

        // Filter einstellen und die Zeile für die Auswertung finden
        // Artikelhierarchie des Artikels als Filterkriterien benutzen
        lrc_Item.GET(rrc_RecPurchaseLine."No.");
        // Bereich einstellen und als Filterkriterien weiter benutzen benutzen
        lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Purchase;
        // Zeile zur Auswertung finden
        GetItemAttributesMask(lrc_ItemAttributesMask, lrc_Item);
        PurchLineCheckEditable(lrc_ItemAttributesMask, vin_FieldNo);
        PurchLineCheckMandatory(rrc_RecPurchaseLine, rrc_xRecPurchaseLine, vin_FieldNo, lrc_ItemAttributesMask);
    end;

    procedure PurchLineCheckOnPostPrint(var rrc_PurchaseLine: Record "Purchase Line")
    var
        lrc_ItemAttributesMask: Record "POI Item Attributes Mask";
        lrc_Item: Record Item;
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        // Systematik nur für Artikelzeilen anwenden
        IF (rrc_PurchaseLine.Type <> rrc_PurchaseLine.Type::Item) OR
           (rrc_PurchaseLine."No." = '') THEN
            EXIT;

        // Wenn die Systematik noch nicht im Einsatz ist, keine Prüfung durchführen
        lrc_ItemAttributesMask.RESET();
        IF lrc_ItemAttributesMask.Isempty() THEN
            EXIT;

        // Filter einstellen und die Zeile für die Auswertung finden
        // Artikelhierarchie des Artikels als Filterkriterien benutzen
        lrc_Item.GET(rrc_PurchaseLine."No.");
        // Bereich einstellen und als Filterkriterien weiter benutzen benutzen
        lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Purchase;
        // Zeile zur Auswertung finden
        GetItemAttributesMask(lrc_ItemAttributesMask, lrc_Item);

        PurchLineCheckMandatoryFilled(rrc_PurchaseLine, lrc_ItemAttributesMask);
    end;

    procedure PurchLineCheckEditable(var rrc_ItemAttributesMask: Record "POI Item Attributes Mask"; vin_FieldNo: Integer)
    var
        lrc_PurchaseLine: Record "Purchase Line";
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        WITH lrc_PurchaseLine DO
            CASE vin_FieldNo OF
                FIELDNO("POI Country of Origin Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Country of Origin");
                FIELDNO("POI Variety Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Variety");
                FIELDNO("POI Caliber Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Caliber");
                FIELDNO("POI Vendor Caliber Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Vendor Caliber");
                FIELDNO("POI Trademark Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Trademark");
                //FIELDNO("Item Attribute 3"):           rrc_ItemAttributesMask.TESTFIELD("Edit. Quality");
                //FIELDNO("Item Attribute 2"):             rrc_ItemAttributesMask.TESTFIELD("Edit. Color");
                FIELDNO("POI Grade of Goods Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Grade of Goods");
                //FIELDNO("Item Attribute 7"):      rrc_ItemAttributesMask.TESTFIELD("Edit. Conservation");
                //FIELDNO("Item Attribute 4"):           rrc_ItemAttributesMask.TESTFIELD("Edit. Packing");
                FIELDNO("POI Coding Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Coding");
            //FIELDNO("Item Attribute 5"):         rrc_ItemAttributesMask.TESTFIELD("Edit. Treatment");
            END;

    end;

    procedure PurchLineCheckMandatory(var rrc_RecPurchaseLine: Record "Purchase Line"; var rrc_xRecPurchaseLine: Record "Purchase Line"; vin_FieldNo: Integer; var rrc_ItemAttributesMask: Record "POI Item Attributes Mask")
    var
        lrc_PurchaseLine: Record "Purchase Line";
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        WITH lrc_PurchaseLine Do
            CASE vin_FieldNo OF
                FIELDNO("POI Country of Origin Code"):
                    IF rrc_RecPurchaseLine."POI Country of Origin Code" <> rrc_xRecPurchaseLine."POI Country of Origin Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Country of Origin" <> 0 THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Variety Code"):
                    IF rrc_RecPurchaseLine."POI Variety Code" <> rrc_xRecPurchaseLine."POI Variety Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Variety" <> 0 THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Caliber Code"):
                    IF rrc_RecPurchaseLine."POI Caliber Code" <> rrc_xRecPurchaseLine."POI Caliber Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Caliber" <> 0 THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Vendor Caliber Code"):
                    IF rrc_RecPurchaseLine."POI Vendor Caliber Code" <> rrc_xRecPurchaseLine."POI Vendor Caliber Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Vendor Caliber" <> 0 THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Trademark Code"):
                    IF rrc_RecPurchaseLine."POI Trademark Code" <> rrc_xRecPurchaseLine."POI Trademark Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Trademark" <> 0 THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Item Attribute 3"):
                    ;
                FIELDNO("POI Item Attribute 2"):
                    ;
                FIELDNO("POI Grade of Goods Code"):
                    IF rrc_RecPurchaseLine."POI Grade of Goods Code" <> rrc_xRecPurchaseLine."POI Grade of Goods Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Grade of Goods" <> 0 THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Item Attribute 7"):
                    ;
                FIELDNO("POI Item Attribute 4"):
                    ;
                FIELDNO("POI Coding Code"):
                    IF rrc_RecPurchaseLine."POI Coding Code" <> rrc_xRecPurchaseLine."POI Coding Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Coding" <> 0 THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Item Attribute 5"):
                    ;
                FIELDNO("Shortcut Dimension 1 Code"):
                    IF rrc_RecPurchaseLine."Shortcut Dimension 1 Code" <> rrc_xRecPurchaseLine."Shortcut Dimension 1 Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Dimension 1" THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("Shortcut Dimension 2 Code"):
                    IF rrc_RecPurchaseLine."Shortcut Dimension 2 Code" <> rrc_xRecPurchaseLine."Shortcut Dimension 2 Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Dimension 2" THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Shortcut Dimension 3 Code"):
                    IF rrc_RecPurchaseLine."POI Shortcut Dimension 3 Code" <> rrc_xRecPurchaseLine."POI Shortcut Dimension 3 Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Dimension 3" THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Shortcut Dimension 4 Code"):
                    IF rrc_RecPurchaseLine."POI Shortcut Dimension 4 Code" <> rrc_xRecPurchaseLine."POI Shortcut Dimension 4 Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Dimension 4" THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Transport Unit of Meas(TU)"):
                    IF rrc_RecPurchaseLine."POI Transport Unit of Meas(TU)" <> rrc_xRecPurchaseLine."POI Transport Unit of Meas(TU)" THEN
                        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Qty. (Unit) per Transp(TU)"):
                    IF rrc_RecPurchaseLine."POI Qty. (Unit) per Transp(TU)" <> rrc_xRecPurchaseLine."POI Qty. (Unit) per Transp(TU)" THEN
                        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" THEN
                            rrc_RecPurchaseLine.TESTFIELD(Quantity, 0);
                FIELDNO(Quantity):
                    IF (rrc_RecPurchaseLine.Quantity <> rrc_xRecPurchaseLine.Quantity) AND (rrc_RecPurchaseLine.Quantity <> 0) THEN
                        PurchLineCheckMandatoryFilled(rrc_RecPurchaseLine, rrc_ItemAttributesMask);
            END;
    end;

    procedure PurchLineCheckMandatoryFilled(var rrc_PurchaseLine: Record "Purchase Line"; var rrc_ItemAttributesMask: Record "POI Item Attributes Mask")
    begin
        // ----------------------------------------------------------------------------------------
        // Funktion prüft, ob alle pflichtigen Merkmale in der Zeile gefüllt sind
        // ----------------------------------------------------------------------------------------
        IF rrc_ItemAttributesMask."Mandatory Attributes" = TRUE THEn
            WITH rrc_PurchaseLine DO BEGIN

                IF rrc_ItemAttributesMask."Mandatory Country of Origin" <> 0 THEN
                    IF "POI Country of Origin Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Country of Origin Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Variety" <> 0 THEN
                    IF "POI Variety Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Variety Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Caliber" <> 0 THEN
                    IF "POI Caliber Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Caliber Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Trademark" <> 0 THEN
                    IF "POI Trademark Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Trademark Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Grade of Goods" <> 0 THEN
                    IF "POI Grade of Goods Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Grade of Goods Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Coding" <> 0 THEN
                    IF "POI Coding Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Coding Code"), "Line No.");

            END;

        IF rrc_ItemAttributesMask."Mandatory Dimensions" = TRUE THEN
            WITH rrc_PurchaseLine DO BEGIn

                IF rrc_ItemAttributesMask."Mandatory Dimension 1" = TRUE THEN
                    IF "Shortcut Dimension 1 Code" = '' THEN
                        ERROR(AGILESText001Txt, System.CaptionClassTranslate('1,2,1'), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Dimension 2" = TRUE THEN
                    IF "Shortcut Dimension 2 Code" = '' THEN
                        ERROR(AGILESText001Txt, System.CaptionClassTranslate('1,2,2'), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Dimension 3" = TRUE THEN
                    IF "POI Shortcut Dimension 3 Code" = '' THEN
                        ERROR(AGILESText001Txt, System.CaptionClassTranslate('1,2,3'), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Dimension 4" = TRUE THEn
                    IF "POI Shortcut Dimension 4 Code" = '' THEn
                        ERROR(AGILESText001Txt, System.CaptionClassTranslate('1,2,4'), "Line No.");
            END;

        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" = TRUE THEn
            WITH rrc_PurchaseLine DO BEGIN
                IF "POI Transport Unit of Meas(TU)" = '' THEN
                    ERROR(AGILESText001Txt, FIELDCAPTION("POI Transport Unit of Meas(TU)"), "Line No.");

                IF "POI Qty. (Unit) per Transp(TU)" = 0 THEN
                    ERROR(AGILESText001Txt, FIELDCAPTION("POI Qty. (Unit) per Transp(TU)"), "Line No.");

            END;
    end;

    procedure PurchLineCompareWithItem(vrc_PurchaseLine: Record "Purchase Line"; vin_FieldNo: Integer)
    var
        lrc_Item: Record Item;
    begin
        // -------------------------------------------------------------------------------------------
        // Funktion zum Abgleich der Attribute zwischen Artikelstamm und Eingabe Einkaufszeile
        // -------------------------------------------------------------------------------------------

        IF (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR
           (vrc_PurchaseLine."No." = '') THEN
            EXIT;

        lrc_Item.GET(vrc_PurchaseLine."No.");

        CASE vin_FieldNo OF
            vrc_PurchaseLine.FIELDNO("POI Country of Origin Code"):
                BEGIN
                    IF lrc_Item."POI Countr of Ori Code (Fruit)" = '' THEN
                        EXIT;
                    IF lrc_Item."POI Countr of Ori Code (Fruit)" <> vrc_PurchaseLine."POI Country of Origin Code" THEN
                        ERROR('');
                END;

            vrc_PurchaseLine.FIELDNO("POI Variety Code"):
                ;

            vrc_PurchaseLine.FIELDNO("POI Trademark Code"):
                ;

            vrc_PurchaseLine.FIELDNO("POI Caliber Code"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Vendor Caliber Code"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Item Attribute 3"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Item Attribute 2"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Grade of Goods Code"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Item Attribute 7"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Item Attribute 4"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Coding Code"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Item Attribute 5"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Item Attribute 6"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Cultivation Type"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Cultivation Associat. Code"):
                ;
            vrc_PurchaseLine.FIELDNO("POI Item Attribute 1"):
                ;
        END;
    end;


    procedure SalesLineCheckOnValidate(var rrc_RecSalesLine: Record "Sales Line"; var rrc_xRecSalesLine: Record "Sales Line"; vin_FieldNo: Integer)
    var
        lrc_ItemAttributesMask: Record "POI Item Attributes Mask";
        lrc_Item: Record Item;
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        // Systematik nur für Artikelzeilen anwenden
        IF rrc_RecSalesLine.Type <> rrc_RecSalesLine.Type::Item THEN
            EXIT;

        // Wenn die Systematik noch nicht im Einsatz ist, keine Prüfung durchführen
        lrc_ItemAttributesMask.RESET();
        IF lrc_ItemAttributesMask.Isempty() THEN
            EXIT;

        // Filter einstellen und die Zeile für die Auswertung finden
        // Artikelhierarchie des Artikels als Filterkriterien benutzen
        IF rrc_RecSalesLine."No." = '' THEN
            CLEAR(lrc_Item)
        ELSE
            lrc_Item.GET(rrc_RecSalesLine."No.");

        // Bereich einstellen und als Filterkriterien weiter benutzen benutzen
        lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Sales;
        // Zeile zur Auswertung finden
        GetItemAttributesMask(lrc_ItemAttributesMask, lrc_Item);
        SalesLineCheckEditable(lrc_ItemAttributesMask, vin_FieldNo);
        SalesLineCheckMandatory(rrc_RecSalesLine, rrc_xRecSalesLine, vin_FieldNo, lrc_ItemAttributesMask);
    end;

    procedure SalesLineCheckOnPostPrint(var rrc_SalesLine: Record "Sales Line")
    var
        lrc_ItemAttributesMask: Record "POI Item Attributes Mask";
        lrc_Item: Record Item;
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        // Systematik nur für Artikelzeilen anwenden
        IF (rrc_SalesLine.Type <> rrc_SalesLine.Type::Item) OR (rrc_SalesLine."No." = '') THEn
            EXIT;


        // Wenn die Systematik noch nicht im Einsatz ist, keine Prüfung durchführen
        lrc_ItemAttributesMask.RESET();
        IF lrc_ItemAttributesMask.Isempty() THEN
            EXIT;

        // Filter einstellen und die Zeile für die Auswertung finden
        // Artikelhierarchie des Artikels als Filterkriterien benutzen
        lrc_Item.GET(rrc_SalesLine."No.");
        // Bereich einstellen und als Filterkriterien weiter benutzen benutzen
        lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Sales;
        // Zeile zur Auswertung finden
        GetItemAttributesMask(lrc_ItemAttributesMask, lrc_Item);
        SalesLineCheckMandatoryFilled(rrc_SalesLine, lrc_ItemAttributesMask);
    end;

    procedure SalesLineCheckEditable(var rrc_ItemAttributesMask: Record "POI Item Attributes Mask"; vin_FieldNo: Integer)
    var
        lrc_SalesLine: Record "Sales Line";
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        WITH lrc_SalesLine DO
            CASE vin_FieldNo OF
                FIELDNO("POI Country of Origin Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Country of Origin");
                FIELDNO("POI Variety Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Variety");
                FIELDNO("POI Caliber Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Caliber");
                FIELDNO("POI Vendor Caliber Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Vendor Caliber");
                FIELDNO("POI Trademark Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Trademark");
                //FIELDNO("Item Attribute 3"):           rrc_ItemAttributesMask.TESTFIELD("Edit. Quality");
                //FIELDNO("Item Attribute 2"):             rrc_ItemAttributesMask.TESTFIELD("Edit. Color");
                FIELDNO("POI Grade of Goods Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Grade of Goods");
                //FIELDNO("Item Attribute 7"):      rrc_ItemAttributesMask.TESTFIELD("Edit. Conservation");
                //FIELDNO("Item Attribute 4"):           rrc_ItemAttributesMask.TESTFIELD("Edit. Packing");
                FIELDNO("POI Coding Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Coding");
            //FIELDNO("Item Attribute 5"):         rrc_ItemAttributesMask.TESTFIELD("Edit. Treatment");
            END;
    end;

    procedure SalesLineCheckMandatory(var rrc_RecSalesLine: Record "Sales Line"; var rrc_xRecSalesLine: Record "Sales Line"; vin_FieldNo: Integer; var rrc_ItemAttributesMask: Record "POI Item Attributes Mask")
    var
        lrc_SalesLine: Record "Sales Line";
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        WITH lrc_SalesLine DO
            CASE vin_FieldNo OF
                FIELDNO("POI Country of Origin Code"):
                    IF rrc_RecSalesLine."POI Country of Origin Code" <> rrc_xRecSalesLine."POI Country of Origin Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Country of Origin" <> 0 THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Variety Code"):
                    IF rrc_RecSalesLine."POI Variety Code" <> rrc_xRecSalesLine."POI Variety Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Variety" <> 0 THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Caliber Code"):
                    IF rrc_RecSalesLine."POI Caliber Code" <> rrc_xRecSalesLine."POI Caliber Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Caliber" <> 0 THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Vendor Caliber Code"):
                    IF rrc_RecSalesLine."POI Vendor Caliber Code" <> rrc_xRecSalesLine."POI Vendor Caliber Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Vendor Caliber" <> 0 THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Trademark Code"):
                    IF rrc_RecSalesLine."POI Trademark Code" <> rrc_xRecSalesLine."POI Trademark Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Trademark" <> 0 THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Item Attribute 3"):
                    ;
                FIELDNO("POI Item Attribute 2"):
                    ;
                FIELDNO("POI Grade of Goods Code"):
                    IF rrc_RecSalesLine."POI Grade of Goods Code" <> rrc_xRecSalesLine."POI Grade of Goods Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Grade of Goods" <> 0 THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Item Attribute 7"):
                    ;
                FIELDNO("POI Item Attribute 4"):
                    ;
                FIELDNO("POI Coding Code"):
                    ;
                FIELDNO("POI Item Attribute 5"):
                    ;
                FIELDNO("Shortcut Dimension 1 Code"):
                    IF rrc_RecSalesLine."Shortcut Dimension 1 Code" <> rrc_xRecSalesLine."Shortcut Dimension 1 Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Dimension 1" THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("Shortcut Dimension 2 Code"):
                    IF rrc_RecSalesLine."Shortcut Dimension 2 Code" <> rrc_xRecSalesLine."Shortcut Dimension 2 Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Dimension 2" THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Shortcut Dimension 3 Code"):
                    IF rrc_RecSalesLine."POI Shortcut Dimension 3 Code" <> rrc_xRecSalesLine."POI Shortcut Dimension 3 Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Dimension 3" THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Shortcut Dimension 4 Code"):
                    IF rrc_RecSalesLine."POI Shortcut Dimension 4 Code" <> rrc_xRecSalesLine."POI Shortcut Dimension 4 Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Dimension 4" THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Transp. Unit of Meas (TU)"):
                    IF rrc_RecSalesLine."POI Transp. Unit of Meas (TU)" <> rrc_xRecSalesLine."POI Transp. Unit of Meas (TU)" THEN
                        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO("POI Qty.(Unit) per Transp.(TU)"):

                    IF rrc_RecSalesLine."POI Qty.(Unit) per Transp.(TU)" <> rrc_xRecSalesLine."POI Qty.(Unit) per Transp.(TU)" THEN
                        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" THEN
                            rrc_RecSalesLine.TESTFIELD(Quantity, 0);
                FIELDNO(Quantity):
                    IF (rrc_RecSalesLine.Quantity <> rrc_xRecSalesLine.Quantity) AND (rrc_RecSalesLine.Quantity <> 0) THEN
                        SalesLineCheckMandatoryFilled(rrc_RecSalesLine, rrc_ItemAttributesMask);
            END;
    end;

    procedure SalesLineCheckMandatoryFilled(var rrc_SalesLine: Record "Sales Line"; var rrc_ItemAttributesMask: Record "POI Item Attributes Mask")
    begin
        // ----------------------------------------------------------------------------------------
        // Funktion prüft, ob alle pflichtigen Merkmale in der Zeile gefüllt sind
        // ----------------------------------------------------------------------------------------

        IF rrc_ItemAttributesMask."Mandatory Attributes" = TRUE THEN
            WITH rrc_SalesLine DO BEGIN
                IF rrc_ItemAttributesMask."Mandatory Country of Origin" <> 0 THEN
                    IF "POI Country of Origin Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Country of Origin Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Variety" <> 0 THEN
                    IF "POI Variety Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Variety Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Caliber" <> 0 THEN
                    IF "POI Caliber Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Caliber Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Trademark" <> 0 THEN
                    IF "POI Trademark Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Trademark Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Grade of Goods" <> 0 THEN
                    IF "POI Grade of Goods Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Grade of Goods Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Coding" <> 0 THEN
                    IF "POI Coding Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("POI Coding Code"), "Line No.");
            END;


        IF rrc_ItemAttributesMask."Mandatory Dimensions" = TRUE THEN
            WITH rrc_SalesLine DO BEGIN
                IF rrc_ItemAttributesMask."Mandatory Dimension 1" = TRUE THEN
                    IF "Shortcut Dimension 1 Code" = '' THEN
                        ERROR(AGILESText001Txt, System.CaptionClassTranslate('1,2,1'), "Line No.");
                IF rrc_ItemAttributesMask."Mandatory Dimension 2" = TRUE THEN
                    IF "Shortcut Dimension 2 Code" = '' THEN
                        ERROR(AGILESText001Txt, System.CaptionClassTranslate('1,2,2'), "Line No.");
                IF rrc_ItemAttributesMask."Mandatory Dimension 3" = TRUE THEN
                    IF "POI Shortcut Dimension 3 Code" = '' THEN
                        ERROR(AGILESText001Txt, System.CaptionClassTranslate('1,2,3'), "Line No.");
                IF rrc_ItemAttributesMask."Mandatory Dimension 4" = TRUE THEN
                    IF "POI Shortcut Dimension 4 Code" = '' THEN
                        ERROR(AGILESText001Txt, System.CaptionClassTranslate('1,2,4'), "Line No.");
            END;

        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" = TRUE THEN
            WITH rrc_SalesLine DO begin
                IF "POI Transp. Unit of Meas (TU)" = '' THEN
                    ERROR(AGILESText001Txt, FIELDCAPTION("POI Transp. Unit of Meas (TU)"), "Line No.");
                IF "POI Qty.(Unit) per Transp.(TU)" = 0 THEN
                    ERROR(AGILESText001Txt, FIELDCAPTION("POI Qty.(Unit) per Transp.(TU)"), "Line No.");
            END;

    end;

    procedure PackingLineCheckOnValidate(var rrc_RecPackOrderOutputItems: Record "POI Pack. Order Output Items"; var rrc_xRecPackOrderOutputItems: Record "POI Pack. Order Output Items"; vin_FieldNo: Integer)
    var
        lrc_ItemAttributesMask: Record "POI Item Attributes Mask";
        lrc_Item: Record Item;
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        // Wenn die Systematik noch nicht im Einsatz ist, keine Prüfung durchführen
        lrc_ItemAttributesMask.RESET();
        IF lrc_ItemAttributesMask.Isempty() THEN
            EXIT;

        // Filter einstellen und die Zeile für die Auswertung finden
        // Artikelhierarchie des Artikels als Filterkriterien benutzen
        IF rrc_RecPackOrderOutputItems."Item No." = '' THEN
            CLEAR(lrc_Item)
        ELSE
            lrc_Item.GET(rrc_RecPackOrderOutputItems."Item No.");

        // Bereich einstellen und als Filterkriterien weiter benutzen benutzen
        lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Packing;
        // Zeile zur Auswertung finden
        GetItemAttributesMask(lrc_ItemAttributesMask, lrc_Item);
        PackingLineCheckEditable(lrc_ItemAttributesMask, vin_FieldNo);
        PackingLineCheckMandatory(rrc_RecPackOrderOutputItems, rrc_xRecPackOrderOutputItems, vin_FieldNo, lrc_ItemAttributesMask);
    end;

    procedure PackingLineCheckOnPostPrint(var rrc_PackOrderOutputItems: Record "POI Pack. Order Output Items")
    var
        lrc_ItemAttributesMask: Record "POI Item Attributes Mask";
        lrc_Item: Record Item;

    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        // Systematik nur für Artikelzeilen anwenden
        IF rrc_PackOrderOutputItems."Item No." = '' THEN
            EXIT;

        // Wenn die Systematik noch nicht im Einsatz ist, keine Prüfung durchführen
        lrc_ItemAttributesMask.RESET();
        IF lrc_ItemAttributesMask.Isempty() THEN
            EXIT;

        // Filter einstellen und die Zeile für die Auswertung finden
        // Artikelhierarchie des Artikels als Filterkriterien benutzen
        lrc_Item.GET(rrc_PackOrderOutputItems."Item No.");
        // Bereich einstellen und als Filterkriterien weiter benutzen benutzen
        lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Packing;
        // Zeile zur Auswertung finden
        GetItemAttributesMask(lrc_ItemAttributesMask, lrc_Item);
        PackingLineCheckMandatorFilled(rrc_PackOrderOutputItems, lrc_ItemAttributesMask);
    end;

    procedure PackingLineCheckEditable(var rrc_ItemAttributesMask: Record "POI Item Attributes Mask"; vin_FieldNo: Integer)
    var
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        WITH lrc_PackOrderOutputItems DO
            CASE vin_FieldNo OF
                FIELDNO("Country of Origin Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Country of Origin");
                FIELDNO("Variety Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Variety");
                FIELDNO("Caliber Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Caliber");
                FIELDNO("Trademark Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Trademark");
                //FIELDNO("Item Attribute 3"):           rrc_ItemAttributesMask.TESTFIELD("Edit. Quality");
                //FIELDNO("Item Attribute 2"):             rrc_ItemAttributesMask.TESTFIELD("Edit. Color");
                FIELDNO("Grade of Goods Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Grade of Goods");
                //FIELDNO("Item Attribute 7"):      rrc_ItemAttributesMask.TESTFIELD("Edit. Conservation");
                //FIELDNO("Item Attribute 4"):           rrc_ItemAttributesMask.TESTFIELD("Edit. Packing");
                FIELDNO("Coding Code"):
                    rrc_ItemAttributesMask.TESTFIELD("Edit. Coding");
            //FIELDNO("Item Attribute 5"):         rrc_ItemAttributesMask.TESTFIELD("Edit. Treatment");
            END;
    end;

    procedure PackingLineCheckMandatory(var rrc_RecPackOrderOutputItems: Record "POI Pack. Order Output Items"; var rrc_xRecPackOrderOutputItems: Record "POI Pack. Order Output Items"; vin_FieldNo: Integer; var rrc_ItemAttributesMask: Record "POI Item Attributes Mask")
    var
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
    begin
        // -------------------------------------------------------------------------------------------
        //
        // -------------------------------------------------------------------------------------------

        WITH lrc_PackOrderOutputItems DO
            CASE vin_FieldNo OF
                FIELDNO("Country of Origin Code"):
                    IF rrc_RecPackOrderOutputItems."Country of Origin Code" <> rrc_xRecPackOrderOutputItems."Country of Origin Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Country of Origin" <> 0 THEN
                            rrc_RecPackOrderOutputItems.TESTFIELD(Quantity, 0);
                FIELDNO("Variety Code"):
                    IF rrc_RecPackOrderOutputItems."Variety Code" <> rrc_xRecPackOrderOutputItems."Variety Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Variety" <> 0 THEN
                            rrc_RecPackOrderOutputItems.TESTFIELD(Quantity, 0);
                FIELDNO("Caliber Code"):
                    IF rrc_RecPackOrderOutputItems."Caliber Code" <> rrc_xRecPackOrderOutputItems."Caliber Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Caliber" <> 0 THEN
                            rrc_RecPackOrderOutputItems.TESTFIELD(Quantity, 0);
                FIELDNO("Trademark Code"):
                    IF rrc_RecPackOrderOutputItems."Trademark Code" <> rrc_xRecPackOrderOutputItems."Trademark Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Trademark" <> 0 THEN
                            rrc_RecPackOrderOutputItems.TESTFIELD(Quantity, 0);
                FIELDNO("Item Attribute 3"):
                    ;
                FIELDNO("Item Attribute 2"):
                    ;
                FIELDNO("Grade of Goods Code"):
                    IF rrc_RecPackOrderOutputItems."Grade of Goods Code" <> rrc_xRecPackOrderOutputItems."Grade of Goods Code" THEN
                        IF rrc_ItemAttributesMask."Mandatory Grade of Goods" <> 0 THEN
                            rrc_RecPackOrderOutputItems.TESTFIELD(Quantity, 0);
                FIELDNO("Item Attribute 7"):
                    ;
                FIELDNO("Item Attribute 4"):
                    ;
                FIELDNO("Coding Code"):
                    ;
                FIELDNO("Item Attribute 5"):
                    ;
                FIELDNO("Transport Unit of Measure (TU)"):
                    IF rrc_RecPackOrderOutputItems."Transport Unit of Measure (TU)" <> rrc_xRecPackOrderOutputItems."Transport Unit of Measure (TU)" THEN
                        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" THEN
                            rrc_RecPackOrderOutputItems.TESTFIELD(Quantity, 0);
                FIELDNO("Qty. (Unit) per Transp.(TU)"):
                    IF rrc_RecPackOrderOutputItems."Qty. (Unit) per Transp.(TU)" <> rrc_xRecPackOrderOutputItems."Qty. (Unit) per Transp.(TU)" THEN
                        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" THEN
                            rrc_RecPackOrderOutputItems.TESTFIELD(Quantity, 0);
                FIELDNO(Quantity):
                    IF (rrc_RecPackOrderOutputItems.Quantity <> rrc_xRecPackOrderOutputItems.Quantity) AND (rrc_RecPackOrderOutputItems.Quantity <> 0) THEN
                        PackingLineCheckMandatorFilled(rrc_RecPackOrderOutputItems, rrc_ItemAttributesMask);
            END;
    end;

    procedure PackingLineCheckMandatorFilled(var rrc_PackOrderOutputItems: Record "POI Pack. Order Output Items"; var rrc_ItemAttributesMask: Record "POI Item Attributes Mask")
    begin
        // ----------------------------------------------------------------------------------------
        // Funktion prüft, ob alle pflichtigen Merkmale in der Zeile gefüllt sind
        // ----------------------------------------------------------------------------------------

        IF rrc_ItemAttributesMask."Mandatory Attributes" = TRUE THEN
            WITH rrc_PackOrderOutputItems DO BEGIN
                IF rrc_ItemAttributesMask."Mandatory Country of Origin" <> 0 THEN
                    IF "Country of Origin Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("Country of Origin Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Variety" <> 0 THEN
                    IF "Variety Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("Variety Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Caliber" <> 0 THEN
                    IF "Caliber Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("Caliber Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Trademark" <> 0 THEN
                    IF "Trademark Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("Trademark Code"), "Line No.");

                IF rrc_ItemAttributesMask."Mandatory Coding" <> 0 THEN
                    IF "Coding Code" = '' THEN
                        ERROR(AGILESText001Txt, FIELDCAPTION("Coding Code"), "Line No.");
            END;

        IF rrc_ItemAttributesMask."Mandatory Fields TransportUnit" = TRUE THEN
            WITH rrc_PackOrderOutputItems DO BEGIN
                IF "Transport Unit of Measure (TU)" = '' THEN
                    ERROR(AGILESText001Txt, FIELDCAPTION("Transport Unit of Measure (TU)"), "Line No.");
                IF "Qty. (Unit) per Transp.(TU)" = 0 THEN
                    ERROR(AGILESText001Txt, FIELDCAPTION("Qty. (Unit) per Transp.(TU)"), "Line No.");
            END;
    end;
}

