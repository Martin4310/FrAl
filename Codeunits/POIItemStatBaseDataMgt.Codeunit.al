codeunit 5110384 "POI Item Stat. Base Data Mgt"
{

    //     trigger OnRun()
    //     begin
    //         LoadAllValues(TRUE, '');
    //     end;

    procedure LoadAllValues(vbn_AllBatches: Boolean; vco_BatchVarNo: Code[20])
    var
        lrc_ItemStatisticBaseData: Record "POI Item Stat. Base Data";
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Item: Record Item;
        lrc_Variety: Record "POI Variety";
        lin_EntryNo_1: Integer;
    begin
        // ----------------------------------------------------------------------------------------------
        //
        // ----------------------------------------------------------------------------------------------

        IF vbn_AllBatches = TRUE THEN BEGIN
            lrc_ItemStatisticBaseData.RESET();
            lrc_ItemStatisticBaseData.DELETEALL();
            COMMIT();
            lin_EntryNo_1 := 0;
        END;

        lrc_BatchVariant.RESET();
        IF vco_BatchVarNo <> '' THEN BEGIN
            lrc_BatchVariant.SETRANGE("No.", vco_BatchVarNo);
            lrc_BatchVariant.SETFILTER("Country of Origin Code", '<>%1', '');
            lrc_BatchVariant.SETFILTER("Unit of Measure Code", '<>%1', '');
            lrc_BatchVariant.SETFILTER("Item No.", '<>%1', '');
            lrc_BatchVariant.SETFILTER("Product Group Code", '<>%1', '');
        END ELSE BEGIN
            IF vbn_AllBatches = FALSE THEN
                lrc_BatchVariant.SETRANGE(State, lrc_BatchVariant.State::Open);
            lrc_BatchVariant.SETFILTER("Country of Origin Code", '<>%1', '');
            lrc_BatchVariant.SETFILTER("Unit of Measure Code", '<>%1', '');
            lrc_BatchVariant.SETFILTER("Item No.", '<>%1', '');
            lrc_BatchVariant.SETFILTER("Product Group Code", '<>%1', '');
        END;
        IF lrc_BatchVariant.FINDSET(FALSE, FALSE) THEN
            REPEAT
                lrc_Item.GET(lrc_BatchVariant."Item No.");
                lrc_ProductGroup.RESET();
                lrc_ProductGroup.SETRANGE(Code, lrc_BatchVariant."Product Group Code");
                IF NOT lrc_ProductGroup.FINDFIRST() THEN BEGIN
                    lrc_Item.TESTFIELD("POI Product Group Code");
                    lrc_ProductGroup.RESET();
                    lrc_ProductGroup.SETRANGE(Code, lrc_Item."POI Product Group Code");
                    lrc_ProductGroup.FINDFIRST();
                    lrc_BatchVariant."Product Group Code" := lrc_ProductGroup.Code;
                END;
                lrc_ItemStatisticBaseData.RESET();
                lrc_ItemStatisticBaseData.SETRANGE("Entry Type", lrc_ItemStatisticBaseData."Entry Type"::"Prod.Grp");
                lrc_ItemStatisticBaseData.SETRANGE("Product Group Code", lrc_BatchVariant."Product Group Code");
                IF NOT lrc_ItemStatisticBaseData.FINDFIRST() THEN BEGIN
                    lrc_ItemStatisticBaseData.RESET();
                    lrc_ItemStatisticBaseData.INIT();
                    lrc_ItemStatisticBaseData."Entry Type" := lrc_ItemStatisticBaseData."Entry Type"::"Prod.Grp";
                    IF vco_BatchVarNo = '' THEN
                        lin_EntryNo_1 := lin_EntryNo_1 + 1
                    ELSE
                        lin_EntryNo_1 := 0;
                    lrc_ItemStatisticBaseData."Entry No." := lin_EntryNo_1;
                    lrc_ItemStatisticBaseData."Item Category Code" := lrc_BatchVariant."Item Category Code";
                    lrc_ItemStatisticBaseData."Product Group Code" := lrc_BatchVariant."Product Group Code";
                    IF lrc_ProductGroup."Search Description" <> '' THEN
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup."Search Description"
                    ELSE
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup.Description;
                    lrc_ItemStatisticBaseData.INSERT(TRUE);
                END;
                lrc_ItemStatisticBaseData.RESET();
                lrc_ItemStatisticBaseData.SETRANGE("Entry Type", lrc_ItemStatisticBaseData."Entry Type"::Item);
                lrc_ItemStatisticBaseData.SETRANGE("Item No.", lrc_BatchVariant."Item No.");
                IF NOT lrc_ItemStatisticBaseData.FINDFIRST() THEN BEGIN
                    lrc_ItemStatisticBaseData.RESET();
                    lrc_ItemStatisticBaseData.INIT();
                    lrc_ItemStatisticBaseData."Entry Type" := lrc_ItemStatisticBaseData."Entry Type"::Item;
                    IF vco_BatchVarNo = '' THEN
                        lin_EntryNo_1 := lin_EntryNo_1 + 1
                    ELSE
                        lin_EntryNo_1 := 0;
                    lrc_ItemStatisticBaseData."Entry No." := lin_EntryNo_1;
                    lrc_ItemStatisticBaseData."Item Category Code" := lrc_BatchVariant."Item Category Code";
                    lrc_ItemStatisticBaseData."Product Group Code" := lrc_BatchVariant."Product Group Code";
                    IF lrc_ProductGroup."Search Description" <> '' THEN
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup."Search Description"
                    ELSE
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup.Description;
                    lrc_ItemStatisticBaseData."Item No." := lrc_BatchVariant."Item No.";
                    lrc_ItemStatisticBaseData."Item Description" := lrc_BatchVariant.Description;
                    lrc_ItemStatisticBaseData."Item Description 2" := lrc_BatchVariant."Description 2";
                    lrc_ItemStatisticBaseData."Search Description" := lrc_Item."Search Description";
                    lrc_ItemStatisticBaseData.INSERT(TRUE);
                END;
                lrc_ItemStatisticBaseData.RESET();
                lrc_ItemStatisticBaseData.SETRANGE("Entry Type", lrc_ItemStatisticBaseData."Entry Type"::"Item+Country");
                lrc_ItemStatisticBaseData.SETRANGE("Item No.", lrc_BatchVariant."Item No.");
                lrc_ItemStatisticBaseData.SETRANGE("Country of Origin Code", lrc_BatchVariant."Country of Origin Code");
                IF NOT lrc_ItemStatisticBaseData.FINDFIRST() THEN BEGIN
                    lrc_ItemStatisticBaseData.RESET();
                    lrc_ItemStatisticBaseData.INIT();
                    lrc_ItemStatisticBaseData."Entry Type" := lrc_ItemStatisticBaseData."Entry Type"::"Item+Country";
                    IF vco_BatchVarNo = '' THEN
                        lin_EntryNo_1 := lin_EntryNo_1 + 1
                    ELSE
                        lin_EntryNo_1 := 0;
                    lrc_ItemStatisticBaseData."Entry No." := lin_EntryNo_1;
                    lrc_ItemStatisticBaseData."Item Category Code" := lrc_BatchVariant."Item Category Code";
                    lrc_ItemStatisticBaseData."Product Group Code" := lrc_BatchVariant."Product Group Code";
                    IF lrc_ProductGroup."Search Description" <> '' THEN
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup."Search Description"
                    ELSE
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup.Description;
                    lrc_ItemStatisticBaseData."Item No." := lrc_BatchVariant."Item No.";
                    lrc_ItemStatisticBaseData."Item Description" := lrc_BatchVariant.Description;
                    lrc_ItemStatisticBaseData."Item Description 2" := lrc_BatchVariant."Description 2";
                    lrc_ItemStatisticBaseData."Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
                    lrc_ItemStatisticBaseData."Search Description" := lrc_Item."Search Description";
                    lrc_ItemStatisticBaseData.INSERT(TRUE);
                END;
                lrc_ItemStatisticBaseData.RESET();
                lrc_ItemStatisticBaseData.SETRANGE("Entry Type", lrc_ItemStatisticBaseData."Entry Type"::"Item+Country+Variety");
                lrc_ItemStatisticBaseData.SETRANGE("Product Group Code", lrc_BatchVariant."Product Group Code");
                lrc_ItemStatisticBaseData.SETRANGE("Item No.", lrc_BatchVariant."Item No.");
                lrc_ItemStatisticBaseData.SETRANGE("Country of Origin Code", lrc_BatchVariant."Country of Origin Code");
                lrc_ItemStatisticBaseData.SETRANGE("Variety Code", lrc_BatchVariant."Variety Code");
                IF NOT lrc_ItemStatisticBaseData.FINDFIRST() THEN BEGIN
                    lrc_ItemStatisticBaseData.RESET();
                    lrc_ItemStatisticBaseData.INIT();
                    lrc_ItemStatisticBaseData."Entry Type" := lrc_ItemStatisticBaseData."Entry Type"::"Item+Country+Variety";
                    IF vco_BatchVarNo = '' THEN
                        lin_EntryNo_1 := lin_EntryNo_1 + 1
                    ELSE
                        lin_EntryNo_1 := 0;
                    lrc_ItemStatisticBaseData."Entry No." := lin_EntryNo_1;
                    lrc_ItemStatisticBaseData."Item Category Code" := lrc_BatchVariant."Item Category Code";
                    lrc_ItemStatisticBaseData."Product Group Code" := lrc_BatchVariant."Product Group Code";
                    IF lrc_ProductGroup."Search Description" <> '' THEN
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup."Search Description"
                    ELSE
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup.Description;
                    lrc_ItemStatisticBaseData."Item No." := lrc_BatchVariant."Item No.";
                    lrc_ItemStatisticBaseData."Item Description" := lrc_BatchVariant.Description;
                    lrc_ItemStatisticBaseData."Item Description 2" := lrc_BatchVariant."Description 2";
                    lrc_ItemStatisticBaseData."Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
                    lrc_ItemStatisticBaseData."Variety Code" := lrc_BatchVariant."Variety Code";
                    IF lrc_Variety.GET(lrc_BatchVariant."Variety Code") THEN
                        lrc_ItemStatisticBaseData."Variety Description" := lrc_Variety.Description;
                    lrc_ItemStatisticBaseData."Search Description" := lrc_Item."Search Description";
                    lrc_ItemStatisticBaseData.INSERT(TRUE);
                END;
                lrc_ItemStatisticBaseData.RESET();
                lrc_ItemStatisticBaseData.SETRANGE("Entry Type", lrc_ItemStatisticBaseData."Entry Type"::"Item+Country+Variety+Unit");
                lrc_ItemStatisticBaseData.SETRANGE("Product Group Code", lrc_BatchVariant."Product Group Code");
                lrc_ItemStatisticBaseData.SETRANGE("Item No.", lrc_BatchVariant."Item No.");
                lrc_ItemStatisticBaseData.SETRANGE("Country of Origin Code", lrc_BatchVariant."Country of Origin Code");
                lrc_ItemStatisticBaseData.SETRANGE("Variety Code", lrc_BatchVariant."Variety Code");
                lrc_ItemStatisticBaseData.SETRANGE("Unit of Measure Code", lrc_BatchVariant."Unit of Measure Code");
                IF NOT lrc_ItemStatisticBaseData.FINDFIRST() THEN BEGIN
                    IF NOT lrc_UnitofMeasure.GET(lrc_BatchVariant."Unit of Measure Code") THEN
                        lrc_UnitofMeasure.INIT();

                    lrc_ItemStatisticBaseData.RESET();
                    lrc_ItemStatisticBaseData.INIT();
                    lrc_ItemStatisticBaseData."Entry Type" := lrc_ItemStatisticBaseData."Entry Type"::"Item+Country+Variety+Unit";
                    IF vco_BatchVarNo = '' THEN
                        lin_EntryNo_1 := lin_EntryNo_1 + 1
                    ELSE
                        lin_EntryNo_1 := 0;
                    lrc_ItemStatisticBaseData."Entry No." := lin_EntryNo_1;
                    lrc_ItemStatisticBaseData."Item Category Code" := lrc_BatchVariant."Item Category Code";
                    lrc_ItemStatisticBaseData."Product Group Code" := lrc_BatchVariant."Product Group Code";
                    IF lrc_ProductGroup."Search Description" <> '' THEN
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup."Search Description"
                    ELSE
                        lrc_ItemStatisticBaseData."Product Group Search Desc." := lrc_ProductGroup.Description;
                    lrc_ItemStatisticBaseData."Item No." := lrc_BatchVariant."Item No.";
                    lrc_ItemStatisticBaseData."Item Description" := lrc_BatchVariant.Description;
                    lrc_ItemStatisticBaseData."Item Description 2" := lrc_BatchVariant."Description 2";
                    lrc_ItemStatisticBaseData."Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
                    lrc_ItemStatisticBaseData."Variety Code" := lrc_BatchVariant."Variety Code";
                    IF lrc_Variety.GET(lrc_BatchVariant."Variety Code") THEN
                        lrc_ItemStatisticBaseData."Variety Description" := lrc_Variety.Description;
                    lrc_ItemStatisticBaseData."Unit of Measure Code" := lrc_BatchVariant."Unit of Measure Code";
                    lrc_ItemStatisticBaseData."Net Weight" := lrc_UnitofMeasure."POI Net Weight";
                    lrc_ItemStatisticBaseData."Search Description" := lrc_Item."Search Description";
                    lrc_ItemStatisticBaseData.INSERT(TRUE);
                END;
            UNTIL lrc_BatchVariant.NEXT() = 0;
    end;

    //     procedure CreateMatrixLines(vrc_ItemStatBaseData: Record "5110729"; vtx_DateFilterValue: Text[80]; vtx_StatusFilterValue: Text[80]; vtx_VendorFilterValue: Text[80]; vco_MeansOfTransportCode: Code[20]; vco_VoyageNo: Code[20]; vco_ContainerNo: Code[20]; vop_Values: Option "Exp. Avail. Qty.","Sales Qty.","Purchase Qty."; vco_LocationCode: Code[10]; vco_TrademarkFilterValue: Code[60]; vco_GradeOfGoodsFilterValue: Code[60])
    //     var
    //         lcu_StockMgt: Codeunit "5110339";
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_MatrixLines: Record "5110418";
    //         lrc_MatrixColumns: Record "5110419";
    //         lrc_MatrixValues: Record "5087940";
    //         lrc_ItemStatMatrixCriteria: Record "5110728";
    //         lrc_Item: Record Item;
    //         lrc_Location: Record "14";
    //         lrc_Caliber: Record "5110304";
    //         lrc_MeansofTransport: Record "5110324";
    //         lrc_Voyage: Record "5110325";
    //         lrc_ReservationLine: Record "5110449";
    //         lin_LineNo: Integer;
    //         lin_ArrCounter: Integer;
    //         lco_ArrLocationCodes: array[20] of Code[10];
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Generierung der Matrix Zeilen
    //         // ----------------------------------------------------------------------------------------------

    //         lrc_MatrixLines.RESET();
    //         lrc_MatrixLines.SETRANGE("User ID", UserID());
    //         lrc_MatrixLines.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //         lrc_MatrixLines.DELETEALL();

    //         lrc_MatrixColumns.RESET();
    //         lrc_MatrixColumns.SETRANGE("User ID", UserID());
    //         lrc_MatrixColumns.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //         lrc_MatrixColumns.DELETEALL();

    //         lrc_MatrixValues.RESET();
    //         lrc_MatrixValues.SETRANGE("User ID", UserID());
    //         lrc_MatrixValues.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //         lrc_MatrixValues.DELETEALL();

    //         lrc_FruitVisionSetup.GET();

    //         COMMIT;

    //         lrc_ItemStatMatrixCriteria.SETRANGE(Code, '');
    //         IF NOT lrc_ItemStatMatrixCriteria.FINDFIRST() THEN
    //             lrc_ItemStatMatrixCriteria.INIT();

    //         lin_LineNo := 0;

    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.SETCURRENTKEY(State, "Item Category Code", "Product Group Code", "Country of Origin Code",
    //                                        "Variety Code", "Trademark Code", "Caliber Code", "Item No.", "Vendor No.", "Date of Delivery");

    //         CASE vrc_ItemStatBaseData."Entry Type" OF
    //             vrc_ItemStatBaseData."Entry Type"::"Prod.Grp":
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                 END;
    //             vrc_ItemStatBaseData."Entry Type"::Item:
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                 END;
    //             vrc_ItemStatBaseData."Entry Type"::"Item+Country":
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                     lrc_BatchVariant.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                 END;
    //             vrc_ItemStatBaseData."Entry Type"::"Item+Country+Variety":
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                     lrc_BatchVariant.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                     lrc_BatchVariant.SETRANGE("Variety Code", vrc_ItemStatBaseData."Variety Code");
    //                 END;
    //             vrc_ItemStatBaseData."Entry Type"::"Item+Country+Variety+Unit":
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                     lrc_BatchVariant.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                     lrc_BatchVariant.SETRANGE("Variety Code", vrc_ItemStatBaseData."Variety Code");
    //                     lrc_BatchVariant.SETRANGE("Unit of Measure Code", vrc_ItemStatBaseData."Unit of Measure Code");
    //                 END;
    //         END;

    //         IF vtx_VendorFilterValue <> '' THEN
    //             lrc_BatchVariant.SETFILTER("Vendor No.", vtx_VendorFilterValue);
    //         IF vtx_DateFilterValue <> '' THEN
    //             lrc_BatchVariant.SETFILTER("Date of Delivery", vtx_DateFilterValue);
    //         IF vtx_StatusFilterValue <> '' THEN
    //             lrc_BatchVariant.SETFILTER(State, vtx_StatusFilterValue);
    //         IF vco_MeansOfTransportCode <> '' THEN
    //             lrc_BatchVariant.SETRANGE("Means of Transp. Code (Arriva)", vco_MeansOfTransportCode);
    //         IF vco_VoyageNo <> '' THEN
    //             lrc_BatchVariant.SETRANGE("Voyage No.", vco_VoyageNo);
    //         IF vco_ContainerNo <> '' THEN
    //             lrc_BatchVariant.SETRANGE("Container No.", vco_ContainerNo);

    //         IF vco_TrademarkFilterValue <> '' THEN
    //             lrc_BatchVariant.SETFILTER("Trademark Code", vco_TrademarkFilterValue);
    //         IF vco_GradeOfGoodsFilterValue <> '' THEN
    //             lrc_BatchVariant.SETFILTER("Grade of Goods Code", vco_GradeOfGoodsFilterValue);

    //         IF lrc_BatchVariant.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT

    //                 // --------------------------------------------------------------------------------------------
    //                 // Matrix Spalten einfügen --> Kaliber
    //                 // --------------------------------------------------------------------------------------------
    //                 lrc_MatrixColumns.RESET();
    //                 lrc_MatrixColumns.INIT();
    //                 lrc_MatrixColumns."User ID" := USERID;
    //                 lrc_MatrixColumns."Entry Type" := lrc_MatrixColumns."Entry Type"::"Item Statistic Matrix";
    //                 lrc_MatrixColumns.Code := lrc_BatchVariant."Caliber Code";
    //                 lrc_MatrixColumns."Sort Sequence" := 0;
    //                 IF lrc_MatrixColumns.INSERT THEN BEGIN
    //                     IF lrc_Caliber.GET(lrc_BatchVariant."Caliber Code") THEN BEGIN
    //                         lrc_MatrixColumns."Sort Sequence" := lrc_Caliber."Sort Sequence";
    //                         lrc_MatrixColumns.Modify();
    //                     END;
    //                 END;


    //                 // --------------------------------------------------------------------------------------------
    //                 //
    //                 // --------------------------------------------------------------------------------------------
    //                 // Artikel lesen
    //                 lrc_Item.GET(lrc_BatchVariant."Item No.");
    //                 // Mögliche Lagerorte laden - auf denen sich die Pos.-Var. jemals befunden hat
    //                 lcu_StockMgt.BatchVarGetLocations(lrc_BatchVariant."No.", lco_ArrLocationCodes);
    //                 // Schleife um alle Läger
    //                 lin_ArrCounter := 1;
    //                 WHILE lco_ArrLocationCodes[lin_ArrCounter] <> '' DO BEGIN

    //                     IF (vco_LocationCode = '') OR
    //                        (vco_LocationCode = lco_ArrLocationCodes[lin_ArrCounter]) THEN BEGIN

    //                         lrc_Location.GET(lco_ArrLocationCodes[lin_ArrCounter]);
    //                         IF lrc_Location."Use As In-Transit" = FALSE THEN BEGIN

    //                             lrc_MatrixLines.RESET();
    //                             lrc_MatrixLines.SETRANGE("User ID", UserID());
    //                             lrc_MatrixLines.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //                             lrc_MatrixLines.SETRANGE("Country of Origin Code", lrc_BatchVariant."Country of Origin Code");
    //                             lrc_MatrixLines.SETRANGE("Variety Code", lrc_BatchVariant."Variety Code");
    //                             lrc_MatrixLines.SETRANGE("Collo Unit of Measure Code", lrc_BatchVariant."Unit of Measure Code");
    //                             lrc_MatrixLines.SETRANGE("Means of Transport Code", lrc_BatchVariant."Means of Transp. Code (Arriva)");
    //                             lrc_MatrixLines.SETRANGE("Expected Delivery Date", lrc_BatchVariant."Date of Delivery");
    //                             lrc_MatrixLines.SETRANGE("Location Code", lco_ArrLocationCodes[lin_ArrCounter]);

    //                             // Weitere Kriterien in Abhängigkeit der Schablone
    //                             //          IF lrc_ItemStatMatrixCriteria.Code <> '' THEN BEGIN
    //                             IF lrc_ItemStatMatrixCriteria."Trademark Code" = TRUE THEN
    //                                 lrc_MatrixLines.SETRANGE("Trademark Code", lrc_BatchVariant."Trademark Code");
    //                             IF lrc_ItemStatMatrixCriteria."Grade of Goods Code" = TRUE THEN
    //                                 lrc_MatrixLines.SETRANGE("Grade of Goods Code", lrc_BatchVariant."Grade of Goods Code");
    //                             IF lrc_ItemStatMatrixCriteria."Packing Code" = TRUE THEN
    //                                 lrc_MatrixLines.SETRANGE("Packing Code", lrc_BatchVariant."Item Attribute 4");
    //                             IF lrc_ItemStatMatrixCriteria."Vendor No." = TRUE THEN
    //                                 lrc_MatrixLines.SETRANGE("Vendor No.", lrc_BatchVariant."Vendor No.");
    //                             IF lrc_ItemStatMatrixCriteria."Container No." = TRUE THEN
    //                                 lrc_MatrixLines.SETRANGE("Container No.", lrc_BatchVariant."Container No.");
    //                             IF lrc_ItemStatMatrixCriteria."Transport Unit Code" = TRUE THEN
    //                                 lrc_MatrixLines.SETRANGE("Transport Unit of Measure", lrc_BatchVariant."Transport Unit of Measure (TU)");
    //                             IF lrc_ItemStatMatrixCriteria."Qty. Colli per Transport Unit" = TRUE THEN
    //                                 lrc_MatrixLines.SETRANGE("Qty. Colli per Transport Unit", lrc_BatchVariant."Qty. (Unit) per Transp. (TU)");
    //                             //KHH 001 KHH50293.s
    //                             IF lrc_ItemStatMatrixCriteria."Coding Code" = TRUE THEN
    //                                 lrc_MatrixLines.SETRANGE("Coding Code", lrc_BatchVariant."Coding Code");
    //                             //KHH 001 KHH50293.e
    //                             //          END;

    //                             IF NOT lrc_MatrixLines.FINDFIRST() THEN BEGIN

    //                                 lrc_MatrixLines.RESET();
    //                                 lrc_MatrixLines.INIT();
    //                                 lrc_MatrixLines."User ID" := USERID;
    //                                 lrc_MatrixLines."Entry Type" := lrc_MatrixLines."Entry Type"::"Item Statistic Matrix";
    //                                 lin_LineNo := lin_LineNo + 1;
    //                                 lrc_MatrixLines."Entry No." := lin_LineNo;
    //                                 lrc_MatrixLines."Content Type" := lrc_MatrixLines."Content Type"::Line;

    //                                 lrc_MatrixLines."Item No." := lrc_BatchVariant."Item No.";
    //                                 lrc_MatrixLines."Item Search Description" := lrc_Item."Search Description";
    //                                 lrc_MatrixLines."Variant Code" := '';
    //                                 lrc_MatrixLines."Item Description" := lrc_Item.Description;
    //                                 lrc_MatrixLines."Item Category Code" := lrc_Item."Item Category Code";
    //                                 lrc_MatrixLines."Product Group Code" := lrc_Item."Product Group Code";

    //                                 lrc_MatrixLines."Base Unit of Measure" := lrc_Item."Base Unit of Measure";
    //                                 lrc_MatrixLines."Collo Unit of Measure Code" := lrc_BatchVariant."Unit of Measure Code";
    //                                 lrc_MatrixLines."Packing Unit of Measure" := lrc_BatchVariant."Packing Unit of Measure (PU)";
    //                                 lrc_MatrixLines."Transport Unit of Measure" := lrc_BatchVariant."Transport Unit of Measure (TU)";

    //                                 lrc_MatrixLines."Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
    //                                 lrc_MatrixLines."Variety Code" := lrc_BatchVariant."Variety Code";
    //                                 lrc_MatrixLines."Trademark Code" := lrc_BatchVariant."Trademark Code";
    //                                 lrc_MatrixLines."Caliber Code" := lrc_BatchVariant."Caliber Code";
    //                                 lrc_MatrixLines."Vendor Caliber Code" := lrc_BatchVariant."Vendor Caliber Code";
    //                                 lrc_MatrixLines."Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
    //                                 lrc_MatrixLines."Packing Code" := lrc_BatchVariant."Item Attribute 4";
    //                                 lrc_MatrixLines."Coding Code" := lrc_BatchVariant."Coding Code";
    //                                 lrc_MatrixLines."Quality Code" := lrc_BatchVariant."Item Attribute 3";
    //                                 lrc_MatrixLines."Color Code" := lrc_BatchVariant."Item Attribute 2";
    //                                 lrc_MatrixLines."Conservation Code" := lrc_BatchVariant."Item Attribute 7";
    //                                 lrc_MatrixLines."Treatment Code" := lrc_BatchVariant."Item Attribute 5";
    //                                 lrc_MatrixLines."Info 1" := lrc_BatchVariant."Info 1";
    //                                 lrc_MatrixLines."Info 2" := lrc_BatchVariant."Info 2";
    //                                 lrc_MatrixLines."Info 3" := lrc_BatchVariant."Info 3";
    //                                 lrc_MatrixLines."Info 4" := lrc_BatchVariant."Info 4";

    //                                 lrc_MatrixLines."Container No." := lrc_BatchVariant."Container No.";
    //                                 lrc_MatrixLines."Vendor No." := lrc_BatchVariant."Vendor No.";
    //                                 lrc_MatrixLines."Vendor Searchname" := lrc_BatchVariant."Vendor Search Name";
    //                                 lrc_MatrixLines."Location Reference No." := lrc_BatchVariant."Location Reference No.";
    //                                 lrc_MatrixLines."Expected Delivery Date" := lrc_BatchVariant."Date of Delivery";
    //                                 lrc_MatrixLines."Date of Expiry" := lrc_BatchVariant."Date of Expiry";

    //                                 lrc_MatrixLines."Master Batch No." := lrc_BatchVariant."Master Batch No.";
    //                                 lrc_MatrixLines."Batch No." := lrc_BatchVariant."Batch No.";
    //                                 lrc_MatrixLines."Batch Variant No." := lrc_BatchVariant."No.";

    //                                 lrc_MatrixLines."Voyage No." := lrc_BatchVariant."Voyage No.";
    //                                 lrc_MatrixLines."Voyage Description" := '';
    //                                 IF lrc_Voyage.GET(lrc_MatrixLines."Voyage No.") THEN
    //                                     lrc_MatrixLines."Voyage Description" := lrc_Voyage.Description;
    //                                 lrc_MatrixLines."Means of Transport Type" := lrc_BatchVariant."Means of Transport Type";
    //                                 lrc_MatrixLines."Means of Transport Code" := lrc_BatchVariant."Means of Transp. Code (Arriva)";
    //                                 IF lrc_MeansofTransport.GET(lrc_MatrixLines."Means of Transport Type",
    //                                                             lrc_MatrixLines."Means of Transport Code") THEN BEGIN
    //                                     lrc_MatrixLines."Means of Transport Desc." := lrc_MeansofTransport.Name;
    //                                 END ELSE BEGIN
    //                                     lrc_MatrixLines."Means of Transport Desc." := lrc_MatrixLines."Means of Transport Code";
    //                                 END;
    //                                 lrc_MatrixLines."Entry Location Code" := lrc_BatchVariant."Entry Location Code";
    //                                 lrc_MatrixLines."Location Code" := lco_ArrLocationCodes[lin_ArrCounter];

    //                                 lrc_MatrixLines."Qty. Base per Collo" := lrc_BatchVariant."Qty. per Unit of Measure";
    //                                 lrc_MatrixLines."Qty. Colli per Transport Unit" := lrc_BatchVariant."Qty. (Unit) per Transp. (TU)";

    //                                 // Spaltenwert berechnen
    //                                 IF CalcMatrixColumValues(lrc_MatrixLines, lrc_BatchVariant,
    //                                                          lrc_BatchVariant."Caliber Code", vtx_DateFilterValue,
    //                                                          vtx_StatusFilterValue, vtx_VendorFilterValue,
    //                                                          vop_Values) = TRUE THEN BEGIN
    //                                     lrc_MatrixLines.insert();
    //                                 END;

    //                             END ELSE BEGIN

    //                                 // Spaltenwert berechnen
    //                                 CalcMatrixColumValues(lrc_MatrixLines, lrc_BatchVariant,
    //                                                       lrc_BatchVariant."Caliber Code", vtx_DateFilterValue,
    //                                                       vtx_StatusFilterValue, vtx_VendorFilterValue, vop_Values);

    //                             END;

    //                         END;
    //                     END;

    //                     lin_ArrCounter := lin_ArrCounter + 1;
    //                 END;

    //             UNTIL lrc_BatchVariant.next()()= 0;

    //             // Summensatz eingeben
    //             lrc_MatrixLines.RESET();
    //             lrc_MatrixLines.INIT();
    //             lrc_MatrixLines."User ID" := USERID;
    //             lrc_MatrixLines."Entry Type" := lrc_MatrixLines."Entry Type"::"Item Statistic Matrix";
    //             lin_LineNo := lin_LineNo + 1;
    //             lrc_MatrixLines."Entry No." := lin_LineNo;
    //             lrc_MatrixLines."Content Type" := lrc_MatrixLines."Content Type"::Footer;
    //             lrc_MatrixLines."Item No." := lrc_BatchVariant."Item No.";
    //             lrc_MatrixLines."Item Search Description" := lrc_Item."Search Description";
    //             lrc_MatrixLines.insert();

    //         END;

    //         // Kontrolle auf geschlossene Pos.-Var. die aber noch in einem Reservierungsauftrag enthalten sind
    //         IF lrc_FruitVisionSetup."ISB Show Sales Reservation" = TRUE THEN BEGIN

    //             CASE vrc_ItemStatBaseData."Entry Type" OF
    //                 vrc_ItemStatBaseData."Entry Type"::"Prod.Grp":
    //                     BEGIN
    //                         lrc_ReservationLine.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     END;
    //                 vrc_ItemStatBaseData."Entry Type"::Item:
    //                     BEGIN
    //                         lrc_ReservationLine.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                         lrc_ReservationLine.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                     END;
    //                 vrc_ItemStatBaseData."Entry Type"::"Item+Country":
    //                     BEGIN
    //                         lrc_ReservationLine.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                         lrc_ReservationLine.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                         lrc_ReservationLine.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                     END;
    //                 vrc_ItemStatBaseData."Entry Type"::"Item+Country+Variety":
    //                     BEGIN
    //                         lrc_ReservationLine.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                         lrc_ReservationLine.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                         lrc_ReservationLine.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                         lrc_ReservationLine.SETRANGE("Variety Code", vrc_ItemStatBaseData."Variety Code");
    //                     END;
    //                 vrc_ItemStatBaseData."Entry Type"::"Item+Country+Variety+Unit":
    //                     BEGIN
    //                         lrc_ReservationLine.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                         lrc_ReservationLine.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                         lrc_ReservationLine.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                         lrc_ReservationLine.SETRANGE("Variety Code", vrc_ItemStatBaseData."Variety Code");
    //                         lrc_ReservationLine.SETRANGE("Unit of Measure Code", vrc_ItemStatBaseData."Unit of Measure Code");
    //                     END;
    //             END;

    //             IF vtx_VendorFilterValue <> '' THEN
    //                 lrc_ReservationLine.SETFILTER("Vendor No.", vtx_VendorFilterValue);
    //             IF vco_MeansOfTransportCode <> '' THEN
    //                 lrc_BatchVariant.SETRANGE("Means of Transp. Code (Arriva)", vco_MeansOfTransportCode);
    //             IF vco_VoyageNo <> '' THEN
    //                 lrc_ReservationLine.SETRANGE("Voyage No.", vco_VoyageNo);
    //             IF vco_ContainerNo <> '' THEN
    //                 lrc_ReservationLine.SETRANGE("Container No.", vco_ContainerNo);
    //             IF vco_TrademarkFilterValue <> '' THEN
    //                 lrc_ReservationLine.SETFILTER("Trademark Code", vco_TrademarkFilterValue);
    //             IF vco_GradeOfGoodsFilterValue <> '' THEN
    //                 lrc_ReservationLine.SETFILTER("Grade of Goods Code", vco_GradeOfGoodsFilterValue);

    //             lrc_ReservationLine.SETFILTER("Remaining Qty.", '<>%1', 0);
    //             IF lrc_ReservationLine.FINDSET(FALSE, FALSE) THEN BEGIN
    //                 REPEAT

    //                     IF lrc_BatchVariant.GET(lrc_ReservationLine."Batch Variant No.") THEN BEGIN

    //                         IF lrc_BatchVariant.State <> lrc_BatchVariant.State::Open THEN BEGIN

    //                             // IF vtx_DateFilterValue <> '' THEN
    //                             //   lrc_BatchVariant.SETFILTER("Date of Delivery",vtx_DateFilterValue);
    //                             // IF vtx_StatusFilterValue <> '' THEN
    //                             //   lrc_BatchVariant.SETFILTER(Status,vtx_StatusFilterValue);

    //                             // --------------------------------------------------------------------------------------------
    //                             // Matrix Spalten einfügen --> Kaliber
    //                             // --------------------------------------------------------------------------------------------
    //                             lrc_MatrixColumns.RESET();
    //                             lrc_MatrixColumns.INIT();
    //                             lrc_MatrixColumns."User ID" := USERID;
    //                             lrc_MatrixColumns."Entry Type" := lrc_MatrixColumns."Entry Type"::"Item Statistic Matrix";
    //                             lrc_MatrixColumns.Code := lrc_BatchVariant."Caliber Code";
    //                             lrc_MatrixColumns."Sort Sequence" := 0;
    //                             IF lrc_MatrixColumns.INSERT THEN BEGIN
    //                                 IF lrc_Caliber.GET(lrc_BatchVariant."Caliber Code") THEN BEGIN
    //                                     lrc_MatrixColumns."Sort Sequence" := lrc_Caliber."Sort Sequence";
    //                                     lrc_MatrixColumns.Modify();
    //                                 END;
    //                             END;


    //                             // --------------------------------------------------------------------------------------------
    //                             //
    //                             // --------------------------------------------------------------------------------------------
    //                             // Artikel lesen
    //                             lrc_Item.GET(lrc_BatchVariant."Item No.");
    //                             // Mögliche Lagerorte laden - auf denen sich die Pos.-Var. jemals befunden hat
    //                             lcu_StockMgt.BatchVarGetLocations(lrc_BatchVariant."No.", lco_ArrLocationCodes);
    //                             // Schleife um alle Läger
    //                             lin_ArrCounter := 1;
    //                             WHILE lco_ArrLocationCodes[lin_ArrCounter] <> '' DO BEGIN

    //                                 IF (vco_LocationCode = '') OR
    //                                    (vco_LocationCode = lco_ArrLocationCodes[lin_ArrCounter]) THEN BEGIN

    //                                     lrc_Location.GET(lco_ArrLocationCodes[lin_ArrCounter]);
    //                                     IF lrc_Location."Use As In-Transit" = FALSE THEN BEGIN

    //                                         lrc_MatrixLines.RESET();
    //                                         lrc_MatrixLines.SETRANGE("User ID", UserID());
    //                                         lrc_MatrixLines.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //                                         lrc_MatrixLines.SETRANGE("Country of Origin Code", lrc_BatchVariant."Country of Origin Code");
    //                                         lrc_MatrixLines.SETRANGE("Variety Code", lrc_BatchVariant."Variety Code");
    //                                         lrc_MatrixLines.SETRANGE("Collo Unit of Measure Code", lrc_BatchVariant."Unit of Measure Code");
    //                                         lrc_MatrixLines.SETRANGE("Means of Transport Code", lrc_BatchVariant."Means of Transp. Code (Arriva)");
    //                                         lrc_MatrixLines.SETRANGE("Expected Delivery Date", lrc_BatchVariant."Date of Delivery");
    //                                         lrc_MatrixLines.SETRANGE("Location Code", lco_ArrLocationCodes[lin_ArrCounter]);

    //                                         // Weitere Kriterien in Abhängigkeit der Schablone
    //                                         IF lrc_ItemStatMatrixCriteria.Code <> '' THEN BEGIN
    //                                             IF lrc_ItemStatMatrixCriteria."Trademark Code" = TRUE THEN
    //                                                 lrc_MatrixLines.SETRANGE("Trademark Code", lrc_BatchVariant."Trademark Code");
    //                                             IF lrc_ItemStatMatrixCriteria."Grade of Goods Code" = TRUE THEN
    //                                                 lrc_MatrixLines.SETRANGE("Grade of Goods Code", lrc_BatchVariant."Grade of Goods Code");
    //                                             IF lrc_ItemStatMatrixCriteria."Packing Code" = TRUE THEN
    //                                                 lrc_MatrixLines.SETRANGE("Packing Code", lrc_BatchVariant."Item Attribute 4");
    //                                             IF lrc_ItemStatMatrixCriteria."Vendor No." = TRUE THEN
    //                                                 lrc_MatrixLines.SETRANGE("Vendor No.", lrc_BatchVariant."Vendor No.");
    //                                             IF lrc_ItemStatMatrixCriteria."Container No." = TRUE THEN
    //                                                 lrc_MatrixLines.SETRANGE("Container No.", lrc_BatchVariant."Container No.");
    //                                             IF lrc_ItemStatMatrixCriteria."Transport Unit Code" = TRUE THEN
    //                                                 lrc_MatrixLines.SETRANGE("Transport Unit of Measure", lrc_BatchVariant."Transport Unit of Measure (TU)");
    //                                             IF lrc_ItemStatMatrixCriteria."Qty. Colli per Transport Unit" = TRUE THEN
    //                                                 lrc_MatrixLines.SETRANGE("Qty. Colli per Transport Unit", lrc_BatchVariant."Qty. (Unit) per Transp. (TU)");
    //                                         END;

    //                                         IF NOT lrc_MatrixLines.FINDFIRST() THEN BEGIN

    //                                             lrc_MatrixLines.RESET();
    //                                             lrc_MatrixLines.INIT();
    //                                             lrc_MatrixLines."User ID" := USERID;
    //                                             lrc_MatrixLines."Entry Type" := lrc_MatrixLines."Entry Type"::"Item Statistic Matrix";
    //                                             lin_LineNo := lin_LineNo + 1;
    //                                             lrc_MatrixLines."Entry No." := lin_LineNo;
    //                                             lrc_MatrixLines."Content Type" := lrc_MatrixLines."Content Type"::Line;

    //                                             lrc_MatrixLines."Item No." := lrc_BatchVariant."Item No.";
    //                                             lrc_MatrixLines."Item Search Description" := lrc_Item."Search Description";
    //                                             lrc_MatrixLines."Variant Code" := '';
    //                                             lrc_MatrixLines."Item Description" := lrc_Item.Description;
    //                                             lrc_MatrixLines."Item Category Code" := lrc_Item."Item Category Code";
    //                                             lrc_MatrixLines."Product Group Code" := lrc_Item."Product Group Code";

    //                                             lrc_MatrixLines."Base Unit of Measure" := lrc_Item."Base Unit of Measure";
    //                                             lrc_MatrixLines."Collo Unit of Measure Code" := lrc_BatchVariant."Unit of Measure Code";
    //                                             lrc_MatrixLines."Packing Unit of Measure" := lrc_BatchVariant."Packing Unit of Measure (PU)";
    //                                             lrc_MatrixLines."Transport Unit of Measure" := lrc_BatchVariant."Transport Unit of Measure (TU)";

    //                                             lrc_MatrixLines."Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
    //                                             lrc_MatrixLines."Variety Code" := lrc_BatchVariant."Variety Code";
    //                                             lrc_MatrixLines."Trademark Code" := lrc_BatchVariant."Trademark Code";
    //                                             lrc_MatrixLines."Caliber Code" := lrc_BatchVariant."Caliber Code";
    //                                             lrc_MatrixLines."Vendor Caliber Code" := lrc_BatchVariant."Vendor Caliber Code";
    //                                             lrc_MatrixLines."Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
    //                                             lrc_MatrixLines."Packing Code" := lrc_BatchVariant."Item Attribute 4";
    //                                             lrc_MatrixLines."Coding Code" := lrc_BatchVariant."Coding Code";
    //                                             lrc_MatrixLines."Quality Code" := lrc_BatchVariant."Item Attribute 3";
    //                                             lrc_MatrixLines."Color Code" := lrc_BatchVariant."Item Attribute 2";
    //                                             lrc_MatrixLines."Conservation Code" := lrc_BatchVariant."Item Attribute 7";
    //                                             lrc_MatrixLines."Treatment Code" := lrc_BatchVariant."Item Attribute 5";
    //                                             lrc_MatrixLines."Info 1" := lrc_BatchVariant."Info 1";
    //                                             lrc_MatrixLines."Info 2" := lrc_BatchVariant."Info 2";
    //                                             lrc_MatrixLines."Info 3" := lrc_BatchVariant."Info 3";
    //                                             lrc_MatrixLines."Info 4" := lrc_BatchVariant."Info 4";

    //                                             lrc_MatrixLines."Container No." := lrc_BatchVariant."Container No.";
    //                                             lrc_MatrixLines."Vendor No." := lrc_BatchVariant."Vendor No.";
    //                                             lrc_MatrixLines."Vendor Searchname" := lrc_BatchVariant."Vendor Search Name";
    //                                             lrc_MatrixLines."Location Reference No." := lrc_BatchVariant."Location Reference No.";
    //                                             lrc_MatrixLines."Expected Delivery Date" := lrc_BatchVariant."Date of Delivery";
    //                                             lrc_MatrixLines."Date of Expiry" := lrc_BatchVariant."Date of Expiry";

    //                                             lrc_MatrixLines."Master Batch No." := lrc_BatchVariant."Master Batch No.";
    //                                             lrc_MatrixLines."Batch No." := lrc_BatchVariant."Batch No.";
    //                                             lrc_MatrixLines."Batch Variant No." := lrc_BatchVariant."No.";

    //                                             lrc_MatrixLines."Voyage No." := lrc_BatchVariant."Voyage No.";
    //                                             lrc_MatrixLines."Voyage Description" := '';
    //                                             IF lrc_Voyage.GET(lrc_MatrixLines."Voyage No.") THEN
    //                                                 lrc_MatrixLines."Voyage Description" := lrc_Voyage.Description;
    //                                             lrc_MatrixLines."Means of Transport Type" := lrc_BatchVariant."Means of Transport Type";
    //                                             lrc_MatrixLines."Means of Transport Code" := lrc_BatchVariant."Means of Transp. Code (Arriva)";
    //                                             IF lrc_MeansofTransport.GET(lrc_MatrixLines."Means of Transport Type",
    //                                                                         lrc_MatrixLines."Means of Transport Code") THEN BEGIN
    //                                                 lrc_MatrixLines."Means of Transport Desc." := lrc_MeansofTransport.Name;
    //                                             END ELSE BEGIN
    //                                                 lrc_MatrixLines."Means of Transport Desc." := lrc_MatrixLines."Means of Transport Code";
    //                                             END;
    //                                             lrc_MatrixLines."Entry Location Code" := lrc_BatchVariant."Entry Location Code";
    //                                             lrc_MatrixLines."Location Code" := lco_ArrLocationCodes[lin_ArrCounter];

    //                                             lrc_MatrixLines."Qty. Base per Collo" := lrc_BatchVariant."Qty. per Unit of Measure";
    //                                             lrc_MatrixLines."Qty. Colli per Transport Unit" := lrc_BatchVariant."Qty. (Unit) per Transp. (TU)";

    //                                             // Spaltenwert berechnen
    //                                             IF CalcMatrixColumValues(lrc_MatrixLines, lrc_BatchVariant,
    //                                                                      lrc_BatchVariant."Caliber Code", vtx_DateFilterValue,
    //                                                                      vtx_StatusFilterValue, vtx_VendorFilterValue,
    //                                                                      vop_Values) = TRUE THEN BEGIN
    //                                                 lrc_MatrixLines.insert();
    //                                             END;

    //                                         END ELSE BEGIN

    //                                             // Spaltenwert berechnen
    //                                             CalcMatrixColumValues(lrc_MatrixLines, lrc_BatchVariant,
    //                                                                   lrc_BatchVariant."Caliber Code", vtx_DateFilterValue,
    //                                                                   vtx_StatusFilterValue, vtx_VendorFilterValue, vop_Values);

    //                                         END;

    //                                     END;
    //                                 END;

    //                                 lin_ArrCounter := lin_ArrCounter + 1;

    //                             END;
    //                         END;
    //                     END;
    //                 UNTIL lrc_ReservationLine.next()()= 0;
    //             END;
    //         END;
    //     end;

    //     procedure CalcMatrixColumValues(vrc_MatrixLines: Record "5110418"; vrc_BatchVariant: Record "5110366"; vco_CaliberCode: Code[10]; vtx_DateFilterValue: Text[80]; vtx_StatusFilterValue: Text[80]; vtx_VendorFilterValue: Text[80]; vop_Values: Option "Exp. Avail. Qty.","Sales Qty.","Purchase Qty."): Boolean
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_BatchSetup: Record "5110363";
    //         lrc_MatrixLines: Record "5110418";
    //         lrc_MatrixValues: Record "5087940";
    //         gdc_QtyReservation: Decimal;
    //         "-": Integer;
    //         gdc_BatchVarStockBE: Decimal;
    //         gdc_BatchVarAvailStockBE: Decimal;
    //         gdc_BatchVarEstAvailStockBE: Decimal;
    //         "--": Integer;
    //         gdc_StockBE: Decimal;
    //         gdc_AvailStockBE: Decimal;
    //         gdc_AvailStockKO: Decimal;
    //         gdc_AvailStockPA: Decimal;
    //         gdc_EstAvailStockBE: Decimal;
    //         gdc_EstAvailStockKO: Decimal;
    //         gdc_EstAvailStockPA: Decimal;
    //         gdc_SalesReservationKO: Decimal;
    //     begin
    //         // --------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Spaltenwerte
    //         // --------------------------------------------------------------------------------------------

    //         // Werte zurücksetzen
    //         gdc_StockBE := 0;
    //         gdc_AvailStockBE := 0;
    //         gdc_AvailStockKO := 0;
    //         gdc_AvailStockPA := 0;
    //         gdc_EstAvailStockBE := 0;
    //         gdc_EstAvailStockKO := 0;
    //         gdc_EstAvailStockPA := 0;
    //         gdc_SalesReservationKO := 0;

    //         lrc_BatchSetup.GET();

    //         IF vrc_MatrixLines."Location Code" = '' THEN
    //             EXIT;

    //         CASE vrc_MatrixLines."Content Type" OF
    //             // --------------------------------------------------------------------------------------------
    //             //
    //             // --------------------------------------------------------------------------------------------
    //             vrc_MatrixLines."Content Type"::Line:
    //                 BEGIN

    //                     lrc_BatchVariant.RESET();
    //                     lrc_BatchVariant.SETRANGE("No.", vrc_BatchVariant."No.");
    //                     IF lrc_BatchVariant.FINDSET(FALSE, FALSE) THEN BEGIN
    //                         REPEAT

    //                             lrc_BatchVariant.SETFILTER("Location Filter", vrc_MatrixLines."Location Code");

    //                             CASE vop_Values OF
    //                                 vop_Values::"Exp. Avail. Qty.":
    //                                     BEGIN

    //                                         lrc_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)", "B.V. FV Reservation (Qty)", "B.V. Sales Order (Qty)",
    //                                                                     "B.V. Transfer Ship (Qty)", "B.V. Pack. Input (Qty)",
    //                                                                     "B.V. Purch. Order (Qty)", "B.V. Pack. Output (Qty)",
    //                                                                     "B.V. Purch. Cr. Memo (Qty)",
    //                                                                     "B.V. Transfer Rec. (Qty)", "B.V. Sales Cr. Memo (Qty)");

    //                                         gdc_BatchVarStockBE := lrc_BatchVariant."B.V. Inventory (Qty.)";

    //                                         gdc_BatchVarAvailStockBE := (gdc_BatchVarStockBE -
    //                                                                      lrc_BatchVariant."B.V. FV Reservation (Qty)" -
    //                                                                      lrc_BatchVariant."B.V. Sales Order (Qty)" -
    //                                                                      lrc_BatchVariant."B.V. Transfer Ship (Qty)" -
    //                                                                      lrc_BatchVariant."B.V. Pack. Input (Qty)");

    //                                         gdc_BatchVarEstAvailStockBE := (gdc_BatchVarAvailStockBE +
    //                                                                         lrc_BatchVariant."B.V. Purch. Order (Qty)" +
    //                                                                         lrc_BatchVariant."B.V. Pack. Output (Qty)" +
    //                                                                         lrc_BatchVariant."B.V. Transfer Rec. (Qty)");

    //                                         IF lrc_BatchSetup."Avail. Stock incl. Sales Cr. M" = TRUE THEN BEGIN
    //                                             gdc_BatchVarAvailStockBE := gdc_BatchVarAvailStockBE +
    //                                                                  lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";
    //                                         END;

    //                                         IF lrc_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN BEGIN
    //                                             gdc_BatchVarEstAvailStockBE := gdc_BatchVarEstAvailStockBE +
    //                                                                            lrc_BatchVariant."B.V. Sales Cr. Memo (Qty)";
    //                                         END;

    //                                         IF lrc_BatchSetup."Avail. Stock incl. Purch Cr. M" = TRUE THEN BEGIN
    //                                             gdc_BatchVarStockBE := gdc_BatchVarStockBE -
    //                                                                  lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";
    //                                         END;

    //                                         IF lrc_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN BEGIN
    //                                             gdc_BatchVarEstAvailStockBE := gdc_BatchVarEstAvailStockBE -
    //                                                                  lrc_BatchVariant."B.V. Purch. Cr. Memo (Qty)";
    //                                         END;

    //                                         // Summe in Basiseinheiten
    //                                         gdc_StockBE := gdc_StockBE + gdc_BatchVarStockBE;
    //                                         gdc_AvailStockBE := gdc_AvailStockBE + gdc_BatchVarAvailStockBE;
    //                                         gdc_EstAvailStockBE := gdc_EstAvailStockBE + gdc_BatchVarEstAvailStockBE;

    //                                         IF lrc_BatchVariant."Qty. per Unit of Measure" <> 0 THEN BEGIN

    //                                             gdc_AvailStockKO := gdc_AvailStockKO +
    //                                                                 (gdc_BatchVarAvailStockBE / lrc_BatchVariant."Qty. per Unit of Measure");
    //                                             gdc_EstAvailStockKO := gdc_EstAvailStockKO +
    //                                                                    (gdc_BatchVarEstAvailStockBE / lrc_BatchVariant."Qty. per Unit of Measure");

    //                                             gdc_SalesReservationKO := gdc_SalesReservationKO +
    //                                                                      (lrc_BatchVariant."B.V. FV Reservation (Qty)" / lrc_BatchVariant."Qty. per Unit of Measure");

    //                                             IF lrc_BatchVariant."Qty. (Unit) per Transp. (TU)" <> 0 THEN BEGIN
    //                                                 gdc_AvailStockPA := gdc_AvailStockPA +
    //                                                                     (gdc_BatchVarAvailStockBE / lrc_BatchVariant."Qty. per Unit of Measure" /
    //                                                                     lrc_BatchVariant."Qty. (Unit) per Transp. (TU)");
    //                                                 gdc_EstAvailStockPA := gdc_EstAvailStockPA +
    //                                                                        (gdc_BatchVarEstAvailStockBE / lrc_BatchVariant."Qty. per Unit of Measure" /
    //                                                                        lrc_BatchVariant."Qty. (Unit) per Transp. (TU)");
    //                                             END;

    //                                         END ELSE BEGIN
    //                                             IF vrc_MatrixLines."Collo Unit of Measure Code" <> '' THEN BEGIN
    //                                                 gdc_EstAvailStockKO := gdc_EstAvailStockKO + gdc_BatchVarEstAvailStockBE;
    //                                                 gdc_EstAvailStockPA := gdc_EstAvailStockPA + gdc_BatchVarEstAvailStockBE;
    //                                             END ELSE BEGIN
    //                                                 gdc_EstAvailStockKO := gdc_EstAvailStockKO + gdc_BatchVarEstAvailStockBE;
    //                                                 gdc_EstAvailStockPA := gdc_EstAvailStockPA + gdc_BatchVarEstAvailStockBE;
    //                                             END;
    //                                         END;

    //                                     END;

    //                                 vop_Values::"Sales Qty.":
    //                                     BEGIN

    //                                     END;

    //                                 vop_Values::"Purchase Qty.":
    //                                     BEGIN

    //                                         lrc_BatchVariant.CALCFIELDS("B.V. Pack. Output (Qty)", "B.V. Pos. Shipped Adjmt. (Qty)",
    //                                                                     "B.V. Purch. Order (Qty)", "B.V. Purch. Rec. (Qty)");

    //                                         gdc_BatchVarAvailStockBE := lrc_BatchVariant."B.V. Pack. Output (Qty)" +
    //                                                                     lrc_BatchVariant."B.V. Pos. Shipped Adjmt. (Qty)" +
    //                                                                     lrc_BatchVariant."B.V. Purch. Order (Qty)" +
    //                                                                     lrc_BatchVariant."B.V. Purch. Rec. (Qty)";

    //                                         gdc_BatchVarEstAvailStockBE := gdc_BatchVarAvailStockBE;

    //                                         // Summe in Basiseinheiten
    //                                         gdc_StockBE := 0;
    //                                         gdc_AvailStockBE := gdc_AvailStockBE + gdc_BatchVarAvailStockBE;
    //                                         gdc_EstAvailStockBE := gdc_EstAvailStockBE + gdc_BatchVarEstAvailStockBE;

    //                                         IF lrc_BatchVariant."Qty. per Unit of Measure" <> 0 THEN BEGIN

    //                                             gdc_AvailStockKO := gdc_AvailStockKO +
    //                                                                 (gdc_BatchVarAvailStockBE / lrc_BatchVariant."Qty. per Unit of Measure");
    //                                             gdc_EstAvailStockKO := gdc_EstAvailStockKO +
    //                                                                    (gdc_BatchVarEstAvailStockBE / lrc_BatchVariant."Qty. per Unit of Measure");

    //                                             IF lrc_BatchVariant."Qty. (Unit) per Transp. (TU)" <> 0 THEN BEGIN
    //                                                 gdc_AvailStockPA := gdc_AvailStockPA +
    //                                                                     (gdc_BatchVarAvailStockBE / lrc_BatchVariant."Qty. per Unit of Measure" /
    //                                                                     lrc_BatchVariant."Qty. (Unit) per Transp. (TU)");
    //                                                 gdc_EstAvailStockPA := gdc_EstAvailStockPA +
    //                                                                        (gdc_BatchVarEstAvailStockBE / lrc_BatchVariant."Qty. per Unit of Measure" /
    //                                                                        lrc_BatchVariant."Qty. (Unit) per Transp. (TU)");
    //                                             END;

    //                                         END ELSE BEGIN

    //                                             IF vrc_MatrixLines."Collo Unit of Measure Code" <> '' THEN BEGIN
    //                                                 gdc_EstAvailStockKO := gdc_EstAvailStockKO + gdc_BatchVarEstAvailStockBE;
    //                                                 gdc_EstAvailStockPA := gdc_EstAvailStockPA + gdc_BatchVarEstAvailStockBE;
    //                                             END ELSE BEGIN
    //                                                 gdc_EstAvailStockKO := gdc_EstAvailStockKO + gdc_BatchVarEstAvailStockBE;
    //                                                 gdc_EstAvailStockPA := gdc_EstAvailStockPA + gdc_BatchVarEstAvailStockBE;
    //                                             END;

    //                                         END;

    //                                     END;

    //                             END;
    //                         UNTIL lrc_BatchVariant.next()()= 0;
    //                     END;

    //                 END;

    //             // --------------------------------------------------------------------------------------------
    //             //
    //             // --------------------------------------------------------------------------------------------
    //             vrc_MatrixLines."Content Type"::Footer:
    //                 BEGIN
    //                 END;

    //         END;


    //         lrc_MatrixValues.RESET();
    //         lrc_MatrixValues.SETRANGE("User ID", UserID());
    //         lrc_MatrixValues.SETRANGE("Entry Type", lrc_MatrixValues."Entry Type"::"Item Statistic Matrix");
    //         lrc_MatrixValues.SETRANGE("Entry No.", vrc_MatrixLines."Entry No.");
    //         lrc_MatrixValues.SETRANGE("X-Axis Value", vco_CaliberCode);
    //         IF NOT lrc_MatrixValues.FINDFIRST() THEN BEGIN
    //             lrc_MatrixValues.RESET();
    //             lrc_MatrixValues.INIT();
    //             lrc_MatrixValues."User ID" := USERID;
    //             lrc_MatrixValues."Entry Type" := lrc_MatrixValues."Entry Type"::"Item Statistic Matrix";
    //             lrc_MatrixValues."Entry No." := vrc_MatrixLines."Entry No.";
    //             lrc_MatrixValues."X-Axis Value" := vco_CaliberCode;
    //             lrc_MatrixValues.insert();
    //         END;

    //         lrc_MatrixValues."Value 1" := lrc_MatrixValues."Value 1" + gdc_EstAvailStockPA;
    //         lrc_MatrixValues."Value 2" := lrc_MatrixValues."Value 2" + gdc_EstAvailStockKO;
    //         lrc_MatrixValues."Value 3" := lrc_MatrixValues."Value 3" + gdc_EstAvailStockBE;
    //         lrc_MatrixValues."Value 4" := lrc_MatrixValues."Value 4" + gdc_SalesReservationKO;
    //         lrc_MatrixValues.Modify();

    //         IF (lrc_MatrixValues."Value 1" <> 0) OR
    //            (lrc_MatrixValues."Value 2" <> 0) OR
    //            (lrc_MatrixValues."Value 3" <> 0) OR
    //            (lrc_MatrixValues."Value 4" <> 0) THEN
    //             EXIT(TRUE)
    //         ELSE
    //             EXIT(FALSE);
    //     end;

    //     procedure ShowBatchVariants(vrc_ItemStatBaseData: Record "5110729"; vtx_DateFilter: Text[80]; vtx_VendorFilter: Text[80]; vtx_StatusFilter: Text[80])
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der zugehörigen Pos.-Var.-Sätze
    //         // ------------------------------------------------------------------------------------------

    //         lrc_BatchVariant.RESET();
    //         lrc_BatchVariant.SETCURRENTKEY(State, "Item Category Code", "Product Group Code", "Country of Origin Code",
    //                                        "Variety Code", "Trademark Code", "Caliber Code", "Item No.", "Vendor No.", "Date of Delivery");

    //         CASE vrc_ItemStatBaseData."Entry Type" OF
    //             vrc_ItemStatBaseData."Entry Type"::"Prod.Grp":
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                 END;
    //             vrc_ItemStatBaseData."Entry Type"::Item:
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                 END;
    //             vrc_ItemStatBaseData."Entry Type"::"Item+Country":
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                     lrc_BatchVariant.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                 END;
    //             vrc_ItemStatBaseData."Entry Type"::"Item+Country+Variety":
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                     lrc_BatchVariant.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                     lrc_BatchVariant.SETRANGE("Variety Code", vrc_ItemStatBaseData."Variety Code");
    //                 END;
    //             vrc_ItemStatBaseData."Entry Type"::"Item+Country+Variety+Unit":
    //                 BEGIN
    //                     lrc_BatchVariant.SETRANGE("Product Group Code", vrc_ItemStatBaseData."Product Group Code");
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                     lrc_BatchVariant.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                     lrc_BatchVariant.SETRANGE("Variety Code", vrc_ItemStatBaseData."Variety Code");
    //                     lrc_BatchVariant.SETRANGE("Unit of Measure Code", vrc_ItemStatBaseData."Unit of Measure Code");
    //                 END;
    //         END;

    //         IF vtx_DateFilter <> '' THEN
    //             lrc_BatchVariant.SETFILTER("Date of Delivery", vtx_DateFilter);
    //         IF vtx_VendorFilter <> '' THEN
    //             lrc_BatchVariant.SETFILTER("Vendor No.", vtx_VendorFilter);
    //         IF vtx_StatusFilter <> '' THEN
    //             lrc_BatchVariant.SETFILTER(State, vtx_StatusFilter);

    //         FORM.RUNMODAL(5110482, lrc_BatchVariant);
    //     end;

    //     procedure TEST()
    //     begin
    //     end;

    //     procedure "-"()
    //     begin
    //     end;

    //     procedure OLD_CreateMatrixLines(vrc_ItemStatBaseData: Record "5110729"; vtx_DateFilter: Text[80]; vtx_VendorFilter: Text[80]; vtx_StatusFilter: Text[80])
    //     var
    //         lcu_StockMgt: Codeunit "5110339";
    //         lrc_MatrixLines: Record "5110418";
    //         lrc_MatrixColumns: Record "5110419";
    //         lrc_MatrixValues: Record "5087940";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_Item: Record Item;
    //         lin_LineNo: Integer;
    //         lin_ArrCounter: Integer;
    //         lco_ArrLocationCodes: array[20] of Code[10];
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Generierung der Matrix Zeilen
    //         // ----------------------------------------------------------------------------------------------

    //         lrc_MatrixLines.RESET();
    //         lrc_MatrixLines.SETRANGE("User ID", UserID());
    //         lrc_MatrixLines.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //         lrc_MatrixLines.DELETEALL();

    //         lrc_MatrixColumns.RESET();
    //         lrc_MatrixColumns.SETRANGE("User ID", UserID());
    //         lrc_MatrixColumns.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //         lrc_MatrixColumns.DELETEALL();

    //         lrc_MatrixValues.RESET();
    //         lrc_MatrixValues.SETRANGE("User ID", UserID());
    //         lrc_MatrixValues.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //         lrc_MatrixValues.DELETEALL();

    //         COMMIT;


    //         lin_LineNo := 0;

    //         CASE vrc_ItemStatBaseData."Entry Type" OF
    //             vrc_ItemStatBaseData."Entry Type"::"Prod.Grp":
    //                 BEGIN
    //                     //  ERROR('Nicht verfügbar!');
    //                     EXIT;
    //                 END;

    //             vrc_ItemStatBaseData."Entry Type"::"Item+Country+Variety+Unit":
    //                 BEGIN

    //                     lrc_BatchVariant.RESET();
    //                     IF vtx_StatusFilter <> '' THEN
    //                         lrc_BatchVariant.SETFILTER(State, vtx_StatusFilter);
    //                     lrc_BatchVariant.SETRANGE("Item No.", vrc_ItemStatBaseData."Item No.");
    //                     lrc_BatchVariant.SETRANGE("Country of Origin Code", vrc_ItemStatBaseData."Country of Origin Code");
    //                     lrc_BatchVariant.SETRANGE("Variety Code", vrc_ItemStatBaseData."Variety Code");
    //                     lrc_BatchVariant.SETRANGE("Unit of Measure Code", vrc_ItemStatBaseData."Unit of Measure Code");
    //                     IF vtx_VendorFilter <> '' THEN
    //                         lrc_BatchVariant.SETFILTER("Vendor No.", vtx_VendorFilter);
    //                     IF vtx_DateFilter <> '' THEN
    //                         lrc_BatchVariant.SETFILTER("Date of Delivery", vtx_DateFilter);
    //                     IF lrc_BatchVariant.FIND('-') THEN BEGIN
    //                         REPEAT

    //                             // Matrix Spalten einfügen
    //                             lrc_MatrixColumns.RESET();
    //                             lrc_MatrixColumns.INIT();
    //                             lrc_MatrixColumns."User ID" := USERID;
    //                             lrc_MatrixColumns."Entry Type" := lrc_MatrixColumns."Entry Type"::"Item Statistic Matrix";
    //                             lrc_MatrixColumns.Code := lrc_BatchVariant."Caliber Code";
    //                             lrc_MatrixColumns."Sort Sequence" := 0;
    //                             IF NOT lrc_MatrixColumns.INSERT THEN;

    //                             // Artikel lesen
    //                             lrc_Item.GET(lrc_BatchVariant."Item No.");
    //                             // Mögliche Lagerorte laden
    //                             lcu_StockMgt.BatchVarGetLocations(lrc_BatchVariant."No.", lco_ArrLocationCodes);
    //                             // Schleife um alle Läger
    //                             lin_ArrCounter := 1;
    //                             WHILE lco_ArrLocationCodes[lin_ArrCounter] <> '' DO BEGIN

    //                                 lrc_MatrixLines.RESET();
    //                                 lrc_MatrixLines.SETRANGE("User ID", UserID());
    //                                 lrc_MatrixLines.SETRANGE("Entry Type", lrc_MatrixLines."Entry Type"::"Item Statistic Matrix");
    //                                 lrc_MatrixLines.SETRANGE("Country of Origin Code", lrc_BatchVariant."Country of Origin Code");
    //                                 lrc_MatrixLines.SETRANGE("Variety Code", lrc_BatchVariant."Variety Code");
    //                                 lrc_MatrixLines.SETRANGE("Collo Unit of Measure Code", lrc_BatchVariant."Unit of Measure Code");

    //                                 // Zusätzliche Kriterien
    //                                 lrc_MatrixLines.SETRANGE("Means of Transport Code", lrc_BatchVariant."Means of Transp. Code (Arriva)");
    //                                 lrc_MatrixLines.SETRANGE("Expected Delivery Date", lrc_BatchVariant."Date of Delivery");
    //                                 lrc_MatrixLines.SETRANGE("Location Code", lco_ArrLocationCodes[lin_ArrCounter]);
    //                                 IF NOT lrc_MatrixLines.FIND('-') THEN BEGIN

    //                                     lrc_MatrixLines.RESET();
    //                                     lrc_MatrixLines.INIT();
    //                                     lrc_MatrixLines."User ID" := USERID;
    //                                     lrc_MatrixLines."Entry Type" := lrc_MatrixLines."Entry Type"::"Item Statistic Matrix";
    //                                     lin_LineNo := lin_LineNo + 1;
    //                                     lrc_MatrixLines."Entry No." := lin_LineNo;
    //                                     lrc_MatrixLines."Content Type" := lrc_MatrixLines."Content Type"::Line;
    //                                     lrc_MatrixLines."Item No." := lrc_BatchVariant."Item No.";
    //                                     lrc_MatrixLines."Item Search Description" := lrc_Item."Search Description";
    //                                     lrc_MatrixLines."Variant Code" := '';
    //                                     lrc_MatrixLines."Item Description" := lrc_Item.Description;
    //                                     lrc_MatrixLines."Item Category Code" := lrc_Item."Item Category Code";
    //                                     lrc_MatrixLines."Product Group Code" := lrc_Item."Product Group Code";
    //                                     lrc_MatrixLines."Base Unit of Measure" := lrc_Item."Base Unit of Measure";
    //                                     lrc_MatrixLines."Collo Unit of Measure Code" := lrc_BatchVariant."Unit of Measure Code";
    //                                     lrc_MatrixLines."Packing Unit of Measure" := lrc_BatchVariant."Packing Unit of Measure (PU)";
    //                                     lrc_MatrixLines."Transport Unit of Measure" := lrc_BatchVariant."Transport Unit of Measure (TU)";
    //                                     lrc_MatrixLines."Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
    //                                     lrc_MatrixLines."Variety Code" := lrc_BatchVariant."Variety Code";
    //                                     lrc_MatrixLines."Trademark Code" := lrc_BatchVariant."Trademark Code";
    //                                     lrc_MatrixLines."Caliber Code" := lrc_BatchVariant."Caliber Code";
    //                                     lrc_MatrixLines."Vendor Caliber Code" := lrc_BatchVariant."Vendor Caliber Code";
    //                                     lrc_MatrixLines."Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
    //                                     lrc_MatrixLines."Packing Code" := lrc_BatchVariant."Item Attribute 4";
    //                                     lrc_MatrixLines."Coding Code" := lrc_BatchVariant."Coding Code";
    //                                     lrc_MatrixLines."Quality Code" := lrc_BatchVariant."Item Attribute 3";
    //                                     lrc_MatrixLines."Color Code" := lrc_BatchVariant."Item Attribute 2";
    //                                     lrc_MatrixLines."Conservation Code" := lrc_BatchVariant."Item Attribute 7";
    //                                     lrc_MatrixLines."Treatment Code" := lrc_BatchVariant."Item Attribute 5";
    //                                     lrc_MatrixLines."Info 1" := lrc_BatchVariant."Info 1";
    //                                     lrc_MatrixLines."Info 2" := lrc_BatchVariant."Info 2";
    //                                     lrc_MatrixLines."Info 3" := lrc_BatchVariant."Info 3";
    //                                     lrc_MatrixLines."Info 4" := lrc_BatchVariant."Info 4";
    //                                     lrc_MatrixLines."Container No." := lrc_BatchVariant."Container No.";
    //                                     lrc_MatrixLines."Vendor No." := lrc_BatchVariant."Vendor No.";
    //                                     lrc_MatrixLines."Vendor Searchname" := lrc_BatchVariant."Vendor Search Name";
    //                                     lrc_MatrixLines."Location Reference No." := lrc_BatchVariant."Location Reference No.";
    //                                     lrc_MatrixLines."Expected Delivery Date" := lrc_BatchVariant."Date of Delivery";
    //                                     lrc_MatrixLines."Date of Expiry" := lrc_BatchVariant."Date of Expiry";
    //                                     lrc_MatrixLines."Master Batch No." := lrc_BatchVariant."Master Batch No.";
    //                                     lrc_MatrixLines."Batch No." := lrc_BatchVariant."Batch No.";
    //                                     lrc_MatrixLines."Batch Variant No." := lrc_BatchVariant."No.";

    //                                     lrc_MatrixLines."Voyage No." := lrc_BatchVariant."Voyage No.";
    //                                     lrc_MatrixLines."Means of Transport Type" := lrc_BatchVariant."Means of Transport Type";
    //                                     lrc_MatrixLines."Means of Transport Code" := lrc_BatchVariant."Means of Transp. Code (Arriva)";
    //                                     lrc_MatrixLines."Entry Location Code" := lrc_BatchVariant."Entry Location Code";
    //                                     lrc_MatrixLines."Location Code" := lco_ArrLocationCodes[lin_ArrCounter];
    //                                     lrc_MatrixLines."Qty. Base per Collo" := lrc_BatchVariant."Qty. per Unit of Measure";
    //                                     lrc_MatrixLines."Qty. Colli per Transport Unit" := lrc_BatchVariant."Qty. (Unit) per Transp. (TU)";
    //                                     lrc_MatrixLines.insert();

    //                                     // Spaltenwert berechnen
    //                                     //          CalcMatrixColumValues(lrc_MatrixLines,lrc_BatchVariant."Caliber Code");

    //                                 END ELSE BEGIN

    //                                     // Spaltenwert berechnen
    //                                     //          CalcMatrixColumValues(lrc_MatrixLines,lrc_BatchVariant."Caliber Code");

    //                                 END;

    //                                 lin_ArrCounter := lin_ArrCounter + 1;
    //                             END;

    //                         UNTIL lrc_BatchVariant.next()()= 0;



    //                     END;
    //                 END;

    //         END;

    //     end;
    var
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_ProductGroup: Record "POI Product Group";
}

