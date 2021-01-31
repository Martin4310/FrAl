codeunit 5110304 "POI Cost Calc. Management"
{
    //     procedure _ShowCostCatPerVoyContMBatch(vop_Subtype: Option " ",Voyage,Container,"Master Batch",Batch; vco_VoyageNo: Code[20]; vco_ContainerNo: Code[20]; vco_MasterBatchNo: Code[20])
    //     var
    //         lrc_Voyage: Record "POI Voyage";
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         //lfm_Voyage: Page "POI Voyage";
    //         //lfm_MasterBatchList: Form "5110369";
    //         //lfm_CalcCostCostCategory: Form "5087949";
    //         lop_AllocationLevel: Option "All Level","Cost Category","Cost Category+Voyage","Cost Category+Voyage+Master Batch",Voyage,"Master Batch","Cost Category+Master Batch";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Kostenkalkulation über die Reisenr.
    //         // ----------------------------------------------------------------------------------------------
    //         // vop_Subtype
    //         // vco_VoyageNo
    //         // vco_ContainerNo
    //         // vco_MasterBatchNo
    //         // ----------------------------------------------------------------------------------------------

    //         CASE vop_Subtype OF
    //             // ----------------------------------------------------------------------------------------------
    //             vop_Subtype::Voyage:
    //                 // ----------------------------------------------------------------------------------------------
    //                 BEGIN

    //                     // Reisenummer aus Liste auswählen, falls keine übergeben wurde
    //                     IF vco_VoyageNo = '' THEN BEGIN
    //                         lfm_Voyage.LOOKUPMODE := TRUE;
    //                         lfm_Voyage.EDITABLE := FALSE;
    //                         IF lfm_Voyage.RUNMODAL <> ACTION::LookupOK THEN
    //                             EXIT;
    //                         lfm_Voyage.GETRECORD(lrc_Voyage);
    //                         vco_VoyageNo := lrc_Voyage."No.";
    //                     END ELSE BEGIN
    //                         lrc_Voyage.GET(vco_VoyageNo);
    //                     END;

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Voyage);
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //                     IF lrc_CostCalculation.FIND('-') THEN BEGIN
    //                         REPEAT
    //                             IF lrc_CostCalculation."Allocation Level" <> lrc_CostCalculation."Allocation Level"::"Voyage No." THEN BEGIN
    //                                 lrc_CostCalculation."Allocation Level" := lrc_CostCalculation."Allocation Level"::"Voyage No.";
    //                                 lrc_CostCalculation.MODIFY();
    //                             END;
    //                         UNTIL lrc_CostCalculation.NEXT() = 0;
    //                     END ELSE BEGIN
    //                         _LoadCostCategories(1, vco_VoyageNo, '', '');
    //                     END;

    //                     _CalcMasterBatchCostPerCat(1, vco_VoyageNo, '', '', '', TRUE);
    //                     COMMIT;

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
    //                     lrc_CostCalculation.FILTERGROUP(2);
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Voyage);
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //                     lrc_CostCalculation.FILTERGROUP(0);

    //                     lop_AllocationLevel := lop_AllocationLevel::"Cost Category+Voyage";
    //                     ////    lfm_CalcCostCostCategory.SetParamValues(lop_AllocationLevel,vco_VoyageNo,'');
    //                     lfm_CalcCostCostCategory.SETTABLEVIEW(lrc_CostCalculation);
    //                     lfm_CalcCostCostCategory.RUNMODAL;

    //                 END;

    //             // ----------------------------------------------------------------------------------------------
    //             vop_Subtype::Container:
    //                 // ----------------------------------------------------------------------------------------------
    //                 BEGIN
    //                 END;

    //             // ----------------------------------------------------------------------------------------------
    //             vop_Subtype::"Master Batch":
    //                 // ----------------------------------------------------------------------------------------------
    //                 BEGIN

    //                     // Partienummer aus Liste auswählen, falls keine übergeben wurde
    //                     IF vco_MasterBatchNo = '' THEN BEGIN
    //                         lfm_MasterBatchList.LOOKUPMODE := TRUE;
    //                         IF lfm_MasterBatchList.RUNMODAL <> ACTION::LookupOK THEN
    //                             EXIT;
    //                         lfm_MasterBatchList.GETRECORD(lrc_MasterBatch);
    //                         vco_MasterBatchNo := lrc_MasterBatch."No.";
    //                     END;

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::"Master Batch");
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                     IF lrc_CostCalculation.FIND('-') THEN BEGIN
    //                         REPEAT
    //                             IF lrc_CostCalculation."Allocation Level" <> lrc_CostCalculation."Allocation Level"::"Master Batch No." THEN BEGIN
    //                                 lrc_CostCalculation."Allocation Level" := lrc_CostCalculation."Allocation Level"::"Master Batch No.";
    //                                 lrc_CostCalculation.MODIFY();
    //                             END;
    //                         UNTIL lrc_CostCalculation.NEXT() = 0;
    //                     END ELSE BEGIN
    //                         _LoadCostCategories(3, '', '', vco_MasterBatchNo);
    //                     END;

    //                     _CalcMasterBatchCostPerCat(3, '', '', vco_MasterBatchNo, '', TRUE);
    //                     COMMIT;

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
    //                     lrc_CostCalculation.FILTERGROUP(2);
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::"Master Batch");
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                     lrc_CostCalculation.FILTERGROUP(0);

    //                     IF lrc_MasterBatch."Voyage No." <> '' THEN
    //                         lop_AllocationLevel := lop_AllocationLevel::"Cost Category+Voyage+Master Batch"
    //                     ELSE
    //                         lop_AllocationLevel := lop_AllocationLevel::"Cost Category+Master Batch";
    //                     ////    lfm_CalcCostCostCategory.SetParamValues(lop_AllocationLevel,'',vco_MasterBatchNo);
    //                     lfm_CalcCostCostCategory.SETTABLEVIEW(lrc_CostCalculation);
    //                     lfm_CalcCostCostCategory.RUNMODAL;

    //                 END;
    //         END;
    //     end;

    //     procedure _ShowCostCatPerBatch(vco_VoyageNo: Code[20]; vco_MasterBatchNo: Code[20]; vco_BatchNo: Code[20]; vco_CostCategoryCode: Code[20])
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //     //lfm_CalcCostBatchDetail: Form "5087947";
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Kosten verteilt auf die Positionen
    //         // ---------------------------------------------------------------------------------------

    //         lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Cost Category Code");
    //         lrc_CostCalculation.FILTERGROUP(2);
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Detail Batch");
    //         IF vco_VoyageNo <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //         IF vco_MasterBatchNo <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF vco_BatchNo <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Batch No.", vco_BatchNo);
    //         IF vco_CostCategoryCode <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //         lrc_CostCalculation.FILTERGROUP(0);

    //         lfm_CalcCostBatchDetail.SETTABLEVIEW(lrc_CostCalculation);
    //         lfm_CalcCostBatchDetail.RUNMODAL;
    //     end;

    //     procedure _ShowCostCatPerBatchVar(vco_VoyageNo: Code[20]; vco_MasterBatchNo: Code[20]; vco_BatchNo: Code[20]; vco_BatchVarNo: Code[20]; vco_CostCategoryCode: Code[20])
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //     //lfm_CalcCostBatchVarDetails: Form "5087951";
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Kosten verteilt auf die Positionsvarianten
    //         // ---------------------------------------------------------------------------------------

    //         lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Cost Category Code");
    //         lrc_CostCalculation.FILTERGROUP(2);
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Detail Batch Variant");
    //         IF vco_VoyageNo <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //         IF vco_MasterBatchNo <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF vco_BatchNo <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Batch No.", vco_BatchNo);
    //         IF vco_CostCategoryCode <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //         lrc_CostCalculation.FILTERGROUP(0);

    //         lfm_CalcCostBatchVarDetails.SETTABLEVIEW(lrc_CostCalculation);
    //         lfm_CalcCostBatchVarDetails.RUNMODAL;
    //     end;

    //     procedure _CreateDimValFromCostCategory()
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_CostCategory: Record "POI Cost Category";
    //         lrc_DimensionValue: Record "Dimension Value";
    //         AGILES_LT_TEXT001: Label 'Fehlerhafte Dimensionszuordnung Kostenkategorie!';
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Erstellung von Dimensionen aus den Kostenkategorien
    //         // ----------------------------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();
    //         lrc_FruitVisionSetup.TESTFIELD("Dim. Code Cost Category");

    //         IF lrc_CostCategory.FIND('-') THEN
    //             REPEAT

    //                 lrc_DimensionValue.SETRANGE("Dimension Code", lrc_FruitVisionSetup."Dim. Code Cost Category");
    //                 lrc_DimensionValue.SETRANGE(Code, lrc_CostCategory.Code);
    //                 IF lrc_DimensionValue.FIND('-') THEN BEGIN
    //                 END ELSE BEGIN

    //                     lrc_DimensionValue.RESET();
    //                     lrc_DimensionValue.INIT();
    //                     lrc_DimensionValue."Dimension Code" := lrc_FruitVisionSetup."Dim. Code Cost Category";
    //                     lrc_DimensionValue.Code := lrc_CostCategory.Code;
    //                     lrc_DimensionValue.Name := lrc_CostCategory.Description;

    //                     lrc_DimensionValue.INSERT(TRUE);

    //                     // Dimension Kostenkategorie setzen
    //                     CASE lrc_FruitVisionSetup."Dim. No. Cost Category" OF
    //                         lrc_FruitVisionSetup."Dim. No. Cost Category"::"1. Dimension":
    //                             lrc_DimensionValue."Global Dimension No." := 1;
    //                         lrc_FruitVisionSetup."Dim. No. Cost Category"::"2. Dimension":
    //                             lrc_DimensionValue."Global Dimension No." := 2;
    //                         lrc_FruitVisionSetup."Dim. No. Cost Category"::"3. Dimension":
    //                             lrc_DimensionValue."Global Dimension No." := 3;
    //                         lrc_FruitVisionSetup."Dim. No. Cost Category"::"4. Dimension":
    //                             lrc_DimensionValue."Global Dimension No." := 4;
    //                         ELSE
    //                             // Fehlerhafte Dimensionszuordnung Kostenkategorie!
    //                             ERROR(AGILES_LT_TEXT001)
    //                     END;

    //                     lrc_DimensionValue.MODIFY(TRUE);
    //                 END;

    //             UNTIL lrc_CostCategory.NEXT() = 0;
    //     end;

    //     procedure _CostSchemaCatAcc(vrc_CostSchemaLine: Record "POI Cost Schema Line")
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung der Sachkonten bei Zuordnung über das Schema
    //         // ----------------------------------------------------------------------------------------------

    //         ERROR('Für zukünftigen Gebrauch!');
    //     end;

    //     procedure _LoadCostCategories(vop_Subtype: Option " ",Voyage,Container,"Master Batch"; vco_VoyageNo: Code[20]; vco_ContainerNo: Code[20]; vco_MasterBatchNo: Code[20])
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_Voyage: Record "POI Voyage";
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_Vendor: Record Vendor;
    //         lrc_CostSchemaLine: Record "POI Cost Schema Line";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCategory: Record "POI Cost Category";
    //         lrc_CostCalcCategories: Record "5087942";
    //         lco_CostSchemaName: Code[20];
    //         AGILES_LT_TEXT001: Label 'Kreditorennr. in Partie nicht gefüllt! Trotzdem laden?';
    //         AGILES_LT_TEXT002: Label 'Reisenummer, Containernummer und Partienummer leer!';
    //         AGILES_LT_TEXT003: Label 'Keine Partienummer zur Reisenummer vorhanden';
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zum Laden der Kostenkategorien
    //         // ----------------------------------------------------------------------------------------------

    //         IF vop_Subtype = vop_Subtype::" " THEN
    //             ERROR('Satzunterart ist nicht definiert!');

    //         IF (vco_VoyageNo = '') AND
    //            (vco_MasterBatchNo = '') AND
    //            (vco_ContainerNo = '') THEN BEGIN
    //             // Reisenummer, Containernummer und Partienummer leer!
    //             ERROR(AGILES_LT_TEXT002);
    //         END;

    //         CASE vop_Subtype OF
    //             vop_Subtype::Voyage:
    //                 BEGIN
    //                     lrc_Voyage.GET(vco_VoyageNo);
    //                     lrc_MasterBatch.RESET();
    //                     lrc_MasterBatch.SETRANGE("Voyage No.", lrc_Voyage."No.");
    //                     IF NOT lrc_MasterBatch.FIND('-') THEN
    //                         // Keine Partienummer zur Reisenummer vorhanden
    //                         ERROR(AGILES_LT_TEXT003);

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Voyage);
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //                     lrc_CostCalculation.DELETEALL();

    //                 END;
    //             vop_Subtype::Container:
    //                 BEGIN
    //                     lrc_MasterBatch.RESET();
    //                     lrc_MasterBatch.SETRANGE("Container Code", vco_ContainerNo);
    //                     lrc_MasterBatch.FIND('-');

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Container);
    //                     lrc_CostCalculation.SETRANGE("Container No.", vco_ContainerNo);
    //                     lrc_CostCalculation.DELETEALL();

    //                 END;
    //             vop_Subtype::"Master Batch":
    //                 BEGIN
    //                     lrc_MasterBatch.GET(vco_MasterBatchNo);

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::"Master Batch");
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                     lrc_CostCalculation.DELETEALL();

    //                 END;
    //         END;


    //         // -------------------------------------------------------------------------------------------------------
    //         // Kostenschema ermitteln als Grundlage für die Auswahl der zu ladenden Kostenkategorien
    //         // -------------------------------------------------------------------------------------------------------
    //         IF lrc_MasterBatch."Vendor No." = '' THEN BEGIN
    //             // Kreditorennr. in Partie nicht gefüllt! Trotzdem laden?
    //             IF NOT CONFIRM(AGILES_LT_TEXT001) THEN
    //                 EXIT;
    //             // Standard Kostenschema laden
    //             lrc_FruitVisionSetup.GET();
    //             lrc_FruitVisionSetup.TESTFIELD("Purch. Cost Schema Name");
    //             lco_CostSchemaName := lrc_FruitVisionSetup."Purch. Cost Schema Name";
    //         END ELSE BEGIN
    //             lrc_Vendor.GET(lrc_MasterBatch."Vendor No.");
    //             IF lrc_MasterBatch."Cost Schema Name Code" <> '' THEN BEGIN
    //                 // Kostenschema der Partie laden
    //                 lco_CostSchemaName := lrc_MasterBatch."Cost Schema Name Code";
    //             END ELSE BEGIN
    //                 IF lrc_Vendor."A.S. Cost Schema Name Code" = '' THEN BEGIN
    //                     lrc_FruitVisionSetup.GET();
    //                     lrc_FruitVisionSetup.TESTFIELD("Purch. Cost Schema Name");
    //                     lco_CostSchemaName := lrc_FruitVisionSetup."Purch. Cost Schema Name";
    //                 END ELSE BEGIN
    //                     // Kostenschema des Lieferanten laden
    //                     lco_CostSchemaName := lrc_Vendor."A.S. Cost Schema Name Code";
    //                 END;
    //             END;
    //         END;

    //         // Temp Tabelle mit Kostenkategorien löschen (für Erfassung über Matrix)
    //         lrc_CostCalcCategories.RESET();
    //         lrc_CostCalcCategories.SETRANGE("User Id", UserID());
    //         lrc_CostCalcCategories.DELETEALL();




    //         // -------------------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------------------
    //         lrc_CostSchemaLine.RESET();
    //         lrc_CostSchemaLine.SETRANGE("Cost Schema Code", lco_CostSchemaName);
    //         lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
    //         lrc_CostSchemaLine.SETFILTER(Totaling, '<>%1', '');
    //         IF lrc_CostSchemaLine.FIND('-') THEN BEGIN
    //             REPEAT

    //                 // Kostenkategorie
    //                 lrc_CostCategory.GET(lrc_CostSchemaLine.Totaling);

    //                 IF (lrc_CostCategory."Cost Type General" = lrc_CostCategory."Cost Type General"::Provision) OR
    //                    (lrc_CostCategory."Cost Type General" = lrc_CostCategory."Cost Type General"::Commission) THEN BEGIN
    //                     // Zeilen nicht laden die als Provision oder Commission gekennzeichnet sind.

    //                 END ELSE BEGIN

    //                     lrc_CostCalcCategories.RESET();
    //                     lrc_CostCalcCategories.INIT();
    //                     lrc_CostCalcCategories."User Id" := USERID;
    //                     lrc_CostCalcCategories."Cost Category Code" := lrc_CostCategory.Code;
    //                     lrc_CostCalcCategories."Cost Category Description" := lrc_CostCategory.Description;
    //                     lrc_CostCalcCategories."Sort Order" := lrc_CostSchemaLine."Line No.";
    //                     lrc_CostCalcCategories.insert();

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Cost Category Code", lrc_CostSchemaLine.Totaling);
    //                     CASE vop_Subtype OF
    //                         vop_Subtype::Voyage:
    //                             BEGIN
    //                                 lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Voyage);
    //                                 lrc_CostCalculation.SETRANGE("Voyage No.", lrc_MasterBatch."Voyage No.");
    //                                 //lrc_CostCalculation.SETRANGE("Container No.",'');
    //                                 //lrc_CostCalculation.SETRANGE("Master Batch No.",'');
    //                             END;
    //                         vop_Subtype::Container:
    //                             BEGIN
    //                                 lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Container);
    //                                 //lrc_CostCalculation.SETRANGE("Voyage No.",'');
    //                                 lrc_CostCalculation.SETRANGE("Container No.", lrc_MasterBatch."Container Code");
    //                                 //lrc_CostCalculation.SETRANGE("Master Batch No.",'');
    //                             END;
    //                         vop_Subtype::"Master Batch":
    //                             BEGIN
    //                                 lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::"Master Batch");
    //                                 //lrc_CostCalculation.SETRANGE("Voyage No.",'');
    //                                 //lrc_CostCalculation.SETRANGE("Container No.",'');
    //                                 lrc_CostCalculation.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                             END;
    //                     END;
    //                     IF NOT lrc_CostCalculation.FIND('-') THEN BEGIN

    //                         lrc_CostCalculation.RESET();
    //                         lrc_CostCalculation.INIT();
    //                         lrc_CostCalculation."Document No." := 0;
    //                         lrc_CostCalculation."Entry Type" := lrc_CostCalculation."Entry Type"::"Cost Category";
    //                         lrc_CostCalculation."Cost Category Code" := lrc_CostSchemaLine.Totaling;

    //                         CASE vop_Subtype OF
    //                             vop_Subtype::Voyage:
    //                                 BEGIN
    //                                     lrc_CostCalculation."Entry Level" := lrc_CostCalculation."Entry Level"::Voyage;
    //                                     lrc_CostCalculation."Allocation Level" := lrc_CostCalculation."Allocation Level"::"Voyage No.";
    //                                     lrc_CostCalculation."Voyage No." := lrc_MasterBatch."Voyage No.";
    //                                     lrc_CostCalculation."Container No." := '';
    //                                     lrc_CostCalculation."Master Batch No." := '';
    //                                 END;
    //                             vop_Subtype::Container:
    //                                 BEGIN
    //                                     lrc_CostCalculation."Entry Level" := lrc_CostCalculation."Entry Level"::Container;
    //                                     lrc_CostCalculation."Allocation Level" := lrc_CostCalculation."Allocation Level"::"Container No.";
    //                                     lrc_CostCalculation."Voyage No." := '';
    //                                     lrc_CostCalculation."Container No." := lrc_MasterBatch."Container Code";
    //                                     lrc_CostCalculation."Master Batch No." := '';
    //                                 END;
    //                             vop_Subtype::"Master Batch":
    //                                 BEGIN
    //                                     lrc_CostCalculation."Entry Level" := lrc_CostCalculation."Entry Level"::"Master Batch";
    //                                     lrc_CostCalculation."Allocation Level" := lrc_CostCalculation."Allocation Level"::"Master Batch No.";
    //                                     lrc_CostCalculation."Voyage No." := '';
    //                                     lrc_CostCalculation."Container No." := '';
    //                                     lrc_CostCalculation."Master Batch No." := lrc_MasterBatch."No.";
    //                                     IF lrc_MasterBatch."Voyage No." <> '' THEN
    //                                         lrc_CostCalculation."Voyage No." := lrc_MasterBatch."Voyage No.";
    //                                 END;
    //                         END;
    //                         lrc_CostCalculation."Batch No." := '';
    //                         lrc_CostCalculation."Batch Variant No." := '';

    //                         lrc_CostCalculation."Reduce Cost from Turnover" := lrc_CostCategory."Reduce Cost from Turnover";
    //                         lrc_CostCalculation."Indirect Cost (Purchase)" := lrc_CostCategory."Indirect Cost (Purchase)";

    //                         lrc_CostCalculation.INSERT(TRUE);


    //                         // Vorbelegungsbetrag berechnen
    //                         IF lrc_CostSchemaLine."Default Amt. (LCY) Enter Data" <> 0 THEN BEGIN
    //                             lrc_CostCalculation.RESET();
    //                             lrc_CostCalculation.INIT();
    //                             lrc_CostCalculation."Document No." := 0;
    //                             lrc_CostCalculation."Cost Category Code" := lrc_CostSchemaLine.Totaling;
    //                             lrc_CostCalculation."Master Batch No." := vco_MasterBatchNo;
    //                             lrc_CostCalculation."Batch No." := '';
    //                             lrc_CostCalculation."Batch Variant No." := '';
    //                             lrc_CostCalculation."Reduce Cost from Turnover" := lrc_CostCategory."Reduce Cost from Turnover";
    //                             lrc_CostCalculation."Indirect Cost (Purchase)" := lrc_CostCategory."Indirect Cost (Purchase)";
    //                             lrc_CostCalculation.INSERT(TRUE);

    //                             lrc_CostCalculation."Entry Type" := lrc_CostCalculation."Entry Type"::"Enter Data";
    //                             lrc_CostCalculation.Amount := lrc_CostSchemaLine."Default Amt. (LCY) Enter Data";
    //                             lrc_CostCalculation."Amount (LCY)" := lrc_CostSchemaLine."Default Amt. (LCY) Enter Data";
    //                             lrc_CostCalculation."Currency Factor" := 1;
    //                             lrc_CostCalculation.MODIFY(TRUE);

    //                             __MasterBatchCalcCost(vco_MasterBatchNo, lrc_CostSchemaLine.Totaling);
    //                         END;

    //                     END;
    //                 END;
    //             UNTIL lrc_CostSchemaLine.NEXT() = 0;
    //         END;

    //         // -------------------------------------------------------------------------
    //         // Alle Kostenkategorien dazufügen
    //         // -------------------------------------------------------------------------
    //         lrc_CostCategory.RESET();
    //         IF lrc_CostCategory.FIND('-') THEN BEGIN
    //             REPEAT

    //                 IF (lrc_CostCategory."Cost Type General" = lrc_CostCategory."Cost Type General"::Provision) OR
    //                    (lrc_CostCategory."Cost Type General" = lrc_CostCategory."Cost Type General"::Commission) THEN BEGIN

    //                 END ELSE BEGIN

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                     CASE vop_Subtype OF
    //                         vop_Subtype::Voyage:
    //                             BEGIN
    //                                 lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Voyage);
    //                                 lrc_CostCalculation.SETRANGE("Voyage No.", lrc_MasterBatch."Voyage No.");
    //                                 //lrc_CostCalculation.SETRANGE("Container No.",'');
    //                                 //lrc_CostCalculation.SETRANGE("Master Batch No.",'');
    //                             END;
    //                         vop_Subtype::Container:
    //                             BEGIN
    //                                 lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Container);
    //                                 //lrc_CostCalculation.SETRANGE("Voyage No.",'');
    //                                 lrc_CostCalculation.SETRANGE("Container No.", lrc_MasterBatch."Container Code");
    //                                 //lrc_CostCalculation.SETRANGE("Master Batch No.",'');
    //                             END;
    //                         vop_Subtype::"Master Batch":
    //                             BEGIN
    //                                 lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::"Master Batch");
    //                                 //lrc_CostCalculation.SETRANGE("Voyage No.",'');
    //                                 //lrc_CostCalculation.SETRANGE("Container No.",'');
    //                                 lrc_CostCalculation.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                             END;
    //                     END;
    //                     IF NOT lrc_CostCalculation.FIND('-') THEN BEGIN

    //                         lrc_CostCalculation.RESET();
    //                         lrc_CostCalculation.INIT();
    //                         lrc_CostCalculation."Document No." := 0;
    //                         lrc_CostCalculation."Entry Type" := lrc_CostCalculation."Entry Type"::"Cost Category";
    //                         lrc_CostCalculation."Cost Category Code" := lrc_CostCategory.Code;

    //                         CASE vop_Subtype OF
    //                             vop_Subtype::Voyage:
    //                                 BEGIN
    //                                     lrc_CostCalculation."Entry Level" := lrc_CostCalculation."Entry Level"::Voyage;
    //                                     lrc_CostCalculation."Allocation Level" := lrc_CostCalculation."Allocation Level"::"Voyage No.";
    //                                     lrc_CostCalculation."Voyage No." := lrc_MasterBatch."Voyage No.";
    //                                     lrc_CostCalculation."Container No." := '';
    //                                     lrc_CostCalculation."Master Batch No." := '';
    //                                 END;
    //                             vop_Subtype::Container:
    //                                 BEGIN
    //                                     lrc_CostCalculation."Entry Level" := lrc_CostCalculation."Entry Level"::Container;
    //                                     lrc_CostCalculation."Allocation Level" := lrc_CostCalculation."Allocation Level"::"Container No.";
    //                                     lrc_CostCalculation."Voyage No." := '';
    //                                     lrc_CostCalculation."Container No." := lrc_MasterBatch."Container Code";
    //                                     lrc_CostCalculation."Master Batch No." := '';
    //                                 END;
    //                             vop_Subtype::"Master Batch":
    //                                 BEGIN
    //                                     lrc_CostCalculation."Entry Level" := lrc_CostCalculation."Entry Level"::"Master Batch";
    //                                     lrc_CostCalculation."Allocation Level" := lrc_CostCalculation."Allocation Level"::"Master Batch No.";
    //                                     lrc_CostCalculation."Voyage No." := '';
    //                                     lrc_CostCalculation."Container No." := '';
    //                                     lrc_CostCalculation."Master Batch No." := lrc_MasterBatch."No.";
    //                                     IF lrc_MasterBatch."Voyage No." <> '' THEN
    //                                         lrc_CostCalculation."Voyage No." := lrc_MasterBatch."Voyage No.";
    //                                 END;
    //                         END;
    //                         lrc_CostCalculation."Batch No." := '';
    //                         lrc_CostCalculation."Batch Variant No." := '';

    //                         lrc_CostCalculation."Reduce Cost from Turnover" := lrc_CostCategory."Reduce Cost from Turnover";
    //                         lrc_CostCalculation."Indirect Cost (Purchase)" := lrc_CostCategory."Indirect Cost (Purchase)";

    //                         lrc_CostCalculation.INSERT(TRUE);

    //                     END;

    //                 END;
    //             UNTIL lrc_CostCategory.NEXT() = 0;
    //         END;
    //     end;

    //     procedure _ChangeCostCategories(vco_MasterBatchNo: Code[20]; vco_CostSchemaName: Code[20])
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_Vendor: Record Vendor;
    //         lrc_CostSchemaLine: Record "POI Cost Schema Line";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         AGILES_LT_TEXT001: Label 'Abbruch!';
    //         AGILES_LT_TEXT002: Label 'Es existieren bereits %1 Kalkulationszeilen, möchten Sie das Kostenschema %2 laden?';
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zum Wechseln der Kostenkategorien
    //         // ----------------------------------------------------------------------------------------------

    //         IF vco_CostSchemaName = '' THEN
    //             EXIT;
    //         IF vco_MasterBatchNo = '' THEN
    //             EXIT;

    //         lrc_MasterBatch.GET(vco_MasterBatchNo);
    //         IF lrc_MasterBatch."Vendor No." = '' THEN
    //             EXIT;
    //         lrc_Vendor.GET(lrc_MasterBatch."Vendor No.");

    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //         lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF lrc_CostCalculation.FIND('-') THEN
    //             IF NOT CONFIRM(AGILES_LT_TEXT002, TRUE, lrc_CostCalculation.COUNT(), vco_CostSchemaName) THEN
    //                 // Abbruch!
    //                 ERROR(AGILES_LT_TEXT001);

    //         lrc_CostSchemaLine.RESET();
    //         lrc_CostSchemaLine.SETCURRENTKEY("Cost Schema Code", "Totaling Type", Totaling);
    //         lrc_CostSchemaLine.SETRANGE("Cost Schema Code", vco_CostSchemaName);
    //         lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
    //         IF lrc_CostSchemaLine.FIND('-') THEN
    //             REPEAT
    //                 lrc_CostCalculation.RESET();
    //                 lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //                 lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                 lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                 lrc_CostCalculation.SETRANGE("Cost Category Code", lrc_CostSchemaLine.Totaling);
    //                 IF NOT lrc_CostCalculation.FIND('-') THEN BEGIN

    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.INIT();
    //                     lrc_CostCalculation."Document No." := 0;
    //                     lrc_CostCalculation."Cost Category Code" := lrc_CostSchemaLine.Totaling;
    //                     lrc_CostCalculation."Master Batch No." := vco_MasterBatchNo;
    //                     lrc_CostCalculation."Batch No." := '';
    //                     lrc_CostCalculation."Batch Variant No." := '';
    //                     lrc_CostCalculation."Entry Type" := lrc_CostCalculation."Entry Type"::"Cost Category";
    //                     lrc_CostCalculation.INSERT(TRUE);

    //                     IF lrc_CostSchemaLine."Default Amt. (LCY) Enter Data" <> 0 THEN BEGIN
    //                         lrc_CostCalculation.RESET();
    //                         lrc_CostCalculation.INIT();
    //                         lrc_CostCalculation."Document No." := 0;
    //                         lrc_CostCalculation."Cost Category Code" := lrc_CostSchemaLine.Totaling;
    //                         lrc_CostCalculation."Master Batch No." := vco_MasterBatchNo;
    //                         lrc_CostCalculation."Batch No." := '';
    //                         lrc_CostCalculation."Batch Variant No." := '';
    //                         lrc_CostCalculation.INSERT(TRUE);
    //                         lrc_CostCalculation."Entry Type" := lrc_CostCalculation."Entry Type"::"Enter Data";
    //                         lrc_CostCalculation.Amount := lrc_CostSchemaLine."Default Amt. (LCY) Enter Data";
    //                         lrc_CostCalculation."Amount (LCY)" := lrc_CostSchemaLine."Default Amt. (LCY) Enter Data";
    //                         lrc_CostCalculation."Currency Factor" := 1;
    //                         lrc_CostCalculation.MODIFY(TRUE);
    //                         __MasterBatchCalcCost(vco_MasterBatchNo, lrc_CostSchemaLine.Totaling);
    //                     END;

    //                 END;
    //             UNTIL lrc_CostSchemaLine.NEXT() = 0;


    //         // Rückwärts testen ob Kategorien gelöscht werden können die nicht zum Schema gehören
    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //         lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF lrc_CostCalculation.FIND('-') THEN
    //             REPEAT
    //                 lrc_CostSchemaLine.RESET();
    //                 lrc_CostSchemaLine.SETCURRENTKEY("Cost Schema Code", "Totaling Type", Totaling);
    //                 lrc_CostSchemaLine.SETRANGE("Cost Schema Code", vco_CostSchemaName);
    //                 lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
    //                 lrc_CostSchemaLine.SETRANGE(Totaling, lrc_CostCalculation."Cost Category Code");
    //                 IF NOT lrc_CostSchemaLine.FIND('-') THEN BEGIN
    //                     lrc_CostCalculation.DELETE(TRUE);
    //                 END;
    //             UNTIL lrc_CostCalculation.NEXT() = 0;
    //     end;

    //     procedure _CalcMasterBatchCostPerCat(vop_Subtype: Option " ",Voyage,Container,"Master Batch"; vco_VoyageNo: Code[20]; vco_ContainerNo: Code[20]; vco_MasterBatchNo: Code[20]; vco_CostCategoryCode: Code[20]; vbn_Dialog: Boolean)
    //     var
    //         lcu_PostedCostMgt: Codeunit "5110359";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         ldl_Dialog: Dialog;
    //         AGILES_LT_TEXT001: Label 'Calculate Cost Category';
    //         ldc_NetChangeQty: Decimal;
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion Berechnung der gebuchten Kosten pro Kostenkategorie
    //         // ----------------------------------------------------------------------------------------------
    //         // vop_Subtype
    //         // vco_VoyageNo
    //         // vco_ContainerNo
    //         // vco_MasterBatchNo
    //         // vco_CostCategoryCode
    //         // vbn_Dialog
    //         // ----------------------------------------------------------------------------------------------

    //         IF vbn_Dialog = TRUE THEN
    //             ldl_Dialog.OPEN(AGILES_LT_TEXT001 + ' #1###############');


    //         CASE vop_Subtype OF
    //             vop_Subtype::Voyage:
    //                 BEGIN
    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Voyage No.", "Master Batch No.", "Cost Category Code");
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Voyage);
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //                     lrc_CostCalculation.SETRANGE("Container No.", '');
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", '');
    //                 END;
    //             vop_Subtype::Container:
    //                 BEGIN
    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Voyage No.", "Master Batch No.", "Cost Category Code");
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Container);
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", '');
    //                     lrc_CostCalculation.SETRANGE("Container No.", vco_ContainerNo);
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", '');
    //                 END;
    //             vop_Subtype::"Master Batch":
    //                 BEGIN
    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Voyage No.", "Master Batch No.", "Cost Category Code");
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::"Master Batch");
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", '');
    //                     lrc_CostCalculation.SETRANGE("Container No.", '');
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                 END;
    //         END;
    //         IF lrc_CostCalculation.FIND('-') THEN BEGIN
    //             REPEAT

    //                 IF vbn_Dialog = TRUE THEN
    //                     ldl_Dialog.UPDATE(1, lrc_CostCalculation."Cost Category Code");

    //                 // ----------------------------------------------------------------------------------------------------------
    //                 // vop_Subtype
    //                 // vco_VoyageNo
    //                 // vco_ContainerNo
    //                 // vco_MasterBatchNo
    //                 // vco_BatchNo
    //                 // vco_CostCategoryCode
    //                 // ----------------------------------------------------------------------------------------------------------
    //                 CASE vop_Subtype OF
    //                     vop_Subtype::Voyage:
    //                         BEGIN
    //                             lcu_PostedCostMgt.CalcPostCostMasterBatchCostCat(1,
    //                                                                              lrc_CostCalculation."Voyage No.",
    //                                                                              lrc_CostCalculation."Cost Category Code", 0D, 0D,
    //                                                                              lrc_CostCalculation."Calc. Posted Amount (LCY)",
    //                                                                              ldc_NetChangeQty);

    //                             // Erfasste und freigegebene Kosten berechnen
    //                         END;

    //                     vop_Subtype::Container:
    //                         BEGIN
    //                             lcu_PostedCostMgt.CalcPostCostMasterBatchCostCat(2,
    //                                                                              lrc_CostCalculation."Container No.",
    //                                                                              lrc_CostCalculation."Cost Category Code", 0D, 0D,
    //                                                                              lrc_CostCalculation."Calc. Posted Amount (LCY)",
    //                                                                              ldc_NetChangeQty);

    //                             // Erfasste und freigegebene Kosten berechnen
    //                         END;

    //                     vop_Subtype::"Master Batch":
    //                         BEGIN
    //                             lcu_PostedCostMgt.CalcPostCostMasterBatchCostCat(3,
    //                                                                              lrc_CostCalculation."Master Batch No.",
    //                                                                              lrc_CostCalculation."Cost Category Code", 0D, 0D,
    //                                                                              lrc_CostCalculation."Calc. Posted Amount (LCY)",
    //                                                                              ldc_NetChangeQty);

    //                             // Erfasste und freigegebene Kosten berechnen
    //                         END;
    //                 END;

    //                 lrc_CostCalculation.MODIFY();

    //             UNTIL lrc_CostCalculation.NEXT() = 0;
    //         END;

    //         IF vbn_Dialog = TRUE THEN
    //             ldl_Dialog.CLOSE;
    //     end;

    //     procedure _EnterDataVoyage(vco_VoyageNo: Code[20])
    //     var
    //         lrc_Voyage: Record "POI Voyage";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         //lfm_Voyage: Form "POI Voyage";
    //         //lfm_CalcCostEnterData: Form "5087950";
    //         lop_AllocationLevel: Option "All Level","Cost Category","Cost Category+Voyage","Cost Category+Voyage+Master Batch",Voyage,"Master Batch";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung aller Kosten für eine Reise
    //         // ----------------------------------------------------------------------------------------------

    //         // Reisenummer aus Liste auswählen, falls keine übergeben wurde
    //         IF vco_VoyageNo = '' THEN BEGIN
    //             lfm_Voyage.LOOKUPMODE := TRUE;
    //             lfm_Voyage.EDITABLE := FALSE;
    //             IF lfm_Voyage.RUNMODAL <> ACTION::LookupOK THEN
    //                 EXIT;
    //             lfm_Voyage.GETRECORD(lrc_Voyage);
    //             vco_VoyageNo := lrc_Voyage."No.";
    //         END;

    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //         lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //         lrc_CostCalculation.SETRANGE("Master Batch No.", '');
    //         IF NOT lrc_CostCalculation.FIND('-') THEN BEGIN
    //             _LoadCostCategories(1, vco_VoyageNo, '', '');
    //         END;

    //         _CalcMasterBatchCostPerCat(1, vco_VoyageNo, '', '', '', TRUE);
    //         COMMIT;

    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
    //         lrc_CostCalculation.FILTERGROUP(2);
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Enter Data");
    //         lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //         lrc_CostCalculation.FILTERGROUP(0);

    //         lop_AllocationLevel := lop_AllocationLevel::Voyage;

    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.INIT();
    //         lrc_CostCalculation."Voyage No." := vco_VoyageNo;
    //         lrc_CostCalculation."Entry Type" := lrc_CostCalculation."Entry Type"::"Cost Category";

    //         ////lfm_CalcCostEnterData.SetGlobals(lop_AllocationLevel,lrc_CostCalculation);
    //         lfm_CalcCostEnterData.RUNMODAL;

    //         // Erfasste Kosten kalkulieren und umlegen auf Positionen und Positionsvarianten
    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Enter Data");
    //         lrc_CostCalculation.SETRANGE("Voyage No.", vco_VoyageNo);
    //         IF lrc_CostCalculation.FIND('-') THEN BEGIN
    //             REPEAT
    //                 IF lrc_CostCalculation.Allocated = FALSE THEN BEGIN
    //                     _AllocateCostPerEnterDataRec(lrc_CostCalculation);
    //                 END;
    //             UNTIL lrc_CostCalculation.NEXT() = 0;
    //         END;
    //     end;

    //     procedure _EnterDataCostCatMasterBatch(vop_AllocationLevel: Option "All Level","Cost Category","Cost Category+Voyage","Cost Category+Voyage+Master Batch",Voyage,"Master Batch","Cost Category+Master Batch"; vrc_CostCalculationCostCat: Record "POI Cost Calc. - Enter Data")
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lfm_CalcCostEnterData: Form "5087950";
    //         AGILES_LT_TEXT001: Label 'Satzart %1 nicht zulässig!';
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung der Kosten zu einer Kostenkategorie
    //         // ----------------------------------------------------------------------------------------------

    //         IF vrc_CostCalculationCostCat."Entry Type" <> vrc_CostCalculationCostCat."Entry Type"::"Cost Category" THEN
    //             // Satzart %1 nicht zulässig!
    //             ERROR(AGILES_LT_TEXT001, vrc_CostCalculationCostCat."Entry Type");
    //         vrc_CostCalculationCostCat.TESTFIELD("Cost Category Code");


    //         // --------------------------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------------------------
    //         lrc_CostCalculation.RESET();
    //         //lrc_CostCalculation.SETCURRENTKEY("Entry Type","Master Batch No.","Cost Category Code");
    //         lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Entry Level", "Cost Category Code",
    //                                           "Voyage No.", "Container No.", "Master Batch No.", "Batch No.");
    //         lrc_CostCalculation.FILTERGROUP(2);
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Enter Data");
    //         lrc_CostCalculation.SETRANGE("Entry Level", vrc_CostCalculationCostCat."Entry Level");
    //         lrc_CostCalculation.SETRANGE("Cost Category Code", vrc_CostCalculationCostCat."Cost Category Code");

    //         CASE vrc_CostCalculationCostCat."Entry Level" OF
    //             vrc_CostCalculationCostCat."Entry Level"::Voyage:
    //                 BEGIN
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", vrc_CostCalculationCostCat."Voyage No.");
    //                 END;

    //             vrc_CostCalculationCostCat."Entry Level"::Container:
    //                 BEGIN
    //                 END;

    //             vrc_CostCalculationCostCat."Entry Level"::"Master Batch":
    //                 BEGIN
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", vrc_CostCalculationCostCat."Master Batch No.");
    //                 END;
    //         END;

    //         ////lfm_CalcCostEnterData.SetGlobals(vop_AllocationLevel,vrc_CostCalculationCostCat);
    //         lfm_CalcCostEnterData.SETTABLEVIEW(lrc_CostCalculation);
    //         lfm_CalcCostEnterData.RUNMODAL;



    //         // --------------------------------------------------------------------------------------------------------
    //         // Erfasste Kosten kalkulieren und umlegen auf Positionen und Positionsvarianten
    //         // --------------------------------------------------------------------------------------------------------
    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETRANGE("Cost Category Code", vrc_CostCalculationCostCat."Cost Category Code");
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Enter Data");
    //         CASE vop_AllocationLevel OF
    //             vop_AllocationLevel::"Cost Category+Voyage":
    //                 BEGIN
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", vrc_CostCalculationCostCat."Voyage No.");
    //                 END;
    //             vop_AllocationLevel::"Cost Category+Voyage+Master Batch",
    //             vop_AllocationLevel::"Cost Category+Master Batch":
    //                 BEGIN
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", vrc_CostCalculationCostCat."Master Batch No.");
    //                 END;
    //             ELSE
    //                 ERROR('Zuordnung Verteilungsebene %1 fehlgeschlagen!', vop_AllocationLevel);
    //         END;
    //         IF lrc_CostCalculation.FIND('-') THEN BEGIN
    //             REPEAT
    //                 IF lrc_CostCalculation.Allocated = FALSE THEN BEGIN
    //                     _AllocateCostPerEnterDataRec(lrc_CostCalculation);
    //                 END;
    //             UNTIL lrc_CostCalculation.NEXT() = 0;
    //         END;

    //     end;

    procedure _AllocateCostPerEnterDataRec(vrc_CostCalculation: Record "POI Cost Calc. - Enter Data")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_MasterBatch: Record "POI Master Batch";
        lrc_Batch: Record "POI Batch";
        lcu_BatchMgt: Codeunit "POI BAM Batch Management";
        ldc_SumAmount: Decimal;
        ldc_SumAmountMW: Decimal;
        ldc_Proz: Decimal;
        ldc_Amount: Decimal;
        ldc_AmountMW: Decimal;
        AGILES_LT_TEXT001Txt: Label 'Herkunft nicht identifiziert!';
        AGILES_LT_TEXT002Txt: Label 'Herkunft nicht zulässig!';
        AGILES_LT_TEXT003Txt: Label 'Betrag kann nicht über Paletten verteilt werden!';
        AGILES_LT_TEXT004Txt: Label 'Betrag kann nicht über Kolli verteilt werden!';
        AGILES_LT_TEXT005Txt: Label 'Betrag kann nicht über Nettogewicht verteilt werden!';
        AGILES_LT_TEXT006Txt: Label 'Betrag kann nicht über Bruttogewicht verteilt werden!';
        AGILES_LT_TEXT007Txt: Label 'Betrag kann nicht über Anzahl Zeilen verteilt werden!';
        AGILES_LT_TEXT008Txt: Label 'Betrag kann nicht über Gesamtbetrag verteilt werden!';
        AGILES_LT_TEXT009Txt: Label 'Betrag kann nicht über Paletten auf die Positionsvarianten verteilt werden!';
        AGILES_LT_TEXT010Txt: Label 'Betrag kann nicht über Kolli auf die Positionsvarianten verteilt werden!';
        AGILES_LT_TEXT011Txt: Label 'Betrag kann nicht über Nettogewicht verteilt werden!';
    //AGILES_LT_TEXT012Txt: Label 'Herkunft nicht codiert %1!';
    begin
        // ----------------------------------------------------------------------------------------------
        // Funktion zur Kalkulation und Umlage der Kosten
        // ----------------------------------------------------------------------------------------------

        IF vrc_CostCalculation."Entry Type" <> vrc_CostCalculation."Entry Type"::"Enter Data" THEN
            ERROR('Satzart %1 nicht zulässig!', vrc_CostCalculation."Entry Type");

        IF vrc_CostCalculation.Allocated = TRUE THEN
            EXIT;

        // Detailzeilen "Batch Variant" löschen
        lrc_CostCalcDetailBatchVar.RESET();
        lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
        lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
        lrc_CostCalcDetailBatchVar.SETRANGE("Attached to Entry No.", vrc_CostCalculation."Document No.");
        lrc_CostCalcDetailBatchVar.DELETEALL();

        // Detailzeilen "Batch" löschen
        lrc_CostCalcDetailBatch.RESET();
        lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
        lrc_CostCalcDetailBatch.SETRANGE("Entry Type", lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
        lrc_CostCalcDetailBatch.SETRANGE("Attached to Entry No.", vrc_CostCalculation."Document No.");
        lrc_CostCalcDetailBatch.DELETEALL();


        // --------------------------------------------------------------------------------------------------------------
        //
        // --------------------------------------------------------------------------------------------------------------
        lrc_FruitVisionSetup.GET();
        CASE lrc_FruitVisionSetup."Cost Category Calc. Type" OF
            lrc_FruitVisionSetup."Cost Category Calc. Type"::"Rekursiv von Zeile":
                BEGIN

                    // ---------------------------------------------------------------
                    // Positionen und Gesamtmengen in Temp Tabelle laden
                    // ---------------------------------------------------------------
                    lrc_MasterBatch.GET(vrc_CostCalculation."Master Batch No.");
                    CASE lrc_MasterBatch.Source OF
                        lrc_MasterBatch.Source::"Purch. Order":
                            // Einkaufskopf lesen
                            lrc_PurchHeader.GET(lrc_PurchHeader."Document Type"::Order, lrc_MasterBatch."Source No.");
                        lrc_MasterBatch.Source::"Sorting Order":
                            // Herkunft nicht zulässig!
                            ERROR(AGILES_LT_TEXT002Txt);
                        lrc_MasterBatch.Source::" ":
                            // Herkunft nicht identifiziert!
                            ERROR(AGILES_LT_TEXT001Txt);
                    END;

                    lrc_PurchLine.RESET();
                    lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETFILTER("No.", '<>%1', '');
                    IF lrc_PurchLine.FIND('-') THEN
                        REPEAT

                            lrc_CostCalcDetailBatchVar.RESET();
                            lrc_CostCalcDetailBatchVar.INIT();
                            lrc_CostCalcDetailBatchVar."Document No." := 0;
                            lrc_CostCalcDetailBatchVar."Cost Category Code" := 'STD';
                            lrc_CostCalcDetailBatchVar."Master Batch No." := lrc_PurchLine."POI Master Batch No.";
                            lrc_CostCalcDetailBatchVar."Batch No." := lrc_PurchLine."POI Batch No.";
                            lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_PurchLine."POI Batch Variant No.";
                            lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant";
                            lrc_CostCalcDetailBatchVar."Product Group Code" := lrc_PurchLine."POI Product Group Code";
                            lrc_CostCalcDetailBatchVar."Cost Schema Name" := 'STD';
                            lrc_CostCalcDetailBatchVar."Vendor No." := lrc_PurchLine."Buy-from Vendor No.";
                            lrc_CostCalcDetailBatchVar."Expected Posting Date" := 0D;
                            lrc_CostCalcDetailBatchVar."Currency Code" := lrc_PurchLine."Currency Code";
                            lrc_CostCalcDetailBatchVar."Currency Factor" := 1;
                            lrc_CostCalcDetailBatchVar.Amount := lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                            lrc_CostCalcDetailBatchVar."Amount (LCY)" := lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                            lrc_CostCalcDetailBatchVar."Allocation Type" := lrc_CostCalcDetailBatchVar."Allocation Type"::" ";
                            lrc_CostCalcDetailBatchVar.INSERT(TRUE);

                            lrc_CostCalcDetailBatch.RESET();
                            lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Cost Category Code");
                            lrc_CostCalcDetailBatch.SETRANGE("Cost Category Code", 'STD');
                            lrc_CostCalcDetailBatch.SETRANGE("Master Batch No.", lrc_PurchLine."POI Master Batch No.");
                            lrc_CostCalcDetailBatch.SETRANGE("Batch No.", lrc_PurchLine."POI Batch No.");
                            lrc_CostCalcDetailBatch.SETRANGE("Entry Type", lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
                            IF lrc_CostCalcDetailBatch.FIND('-') THEN BEGIN

                                lrc_CostCalcDetailBatch.Amount := lrc_CostCalcDetailBatch.Amount + lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                                lrc_CostCalcDetailBatch."Amount (LCY)" := lrc_CostCalcDetailBatch."Amount (LCY)" +
                                                                          lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                                lrc_CostCalcDetailBatch.MODIFY();

                            END ELSE BEGIN

                                lrc_CostCalcDetailBatch.RESET();
                                lrc_CostCalcDetailBatch.INIT();
                                lrc_CostCalcDetailBatch."Document No." := 0;
                                lrc_CostCalcDetailBatch."Cost Category Code" := 'STD';
                                lrc_CostCalcDetailBatch."Master Batch No." := lrc_PurchLine."POI Master Batch No.";
                                lrc_CostCalcDetailBatch."Batch No." := lrc_PurchLine."POI Batch No.";
                                lrc_CostCalcDetailBatch."Batch Variant No." := lrc_PurchLine."POI Batch Variant No.";
                                lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
                                lrc_CostCalcDetailBatch."Product Group Code" := lrc_PurchLine."POI Product Group Code";
                                lrc_CostCalcDetailBatch."Cost Schema Name" := 'STD';
                                lrc_CostCalcDetailBatch."Vendor No." := lrc_PurchLine."Buy-from Vendor No.";
                                lrc_CostCalcDetailBatch."Expected Posting Date" := 0D;
                                lrc_CostCalcDetailBatch."Currency Code" := lrc_PurchLine."Currency Code";
                                lrc_CostCalcDetailBatch."Currency Factor" := 1;
                                lrc_CostCalcDetailBatch.Amount := lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                                lrc_CostCalcDetailBatch."Amount (LCY)" := lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                                lrc_CostCalcDetailBatch."Allocation Type" := lrc_CostCalcDetailBatch."Allocation Type"::" ";
                                lrc_CostCalcDetailBatch.INSERT(TRUE);

                            END;

                        UNTIL lrc_PurchLine.NEXT() = 0;


                END;


            // --------------------------------------------------------------------------------------------------------------
            //
            // --------------------------------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Cost Category Calc. Type"::Standard:
                BEGIN

                    // Positionen und Gesamtmengen in Temp. Tabelle laden
                    CASE vrc_CostCalculation."Allocation Level" OF
                        vrc_CostCalculation."Allocation Level"::"Voyage No.":
                            lcu_BatchMgt.LoadBatchNoInBuffer('', vrc_CostCalculation."Voyage No.", '', '', '');
                        vrc_CostCalculation."Allocation Level"::"Master Batch No.":
                            lcu_BatchMgt.LoadBatchNoInBuffer(vrc_CostCalculation."Master Batch No.", '', '', '', '');
                    END;

                    // Kontrolle ob Eingrenzung auf bestimmte Positionen und Neuberechnung der Summen
                    _RecalcBatchTmpAttachAlocBatch(vrc_CostCalculation."Document No.");

                    // Datensatz mit Gesamtsummensatz über Master Batch in Temp. Tabelle lesen
                    lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                    lrc_MasterBatchTemp.SETRANGE("Userid Code", USERID());
                    lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
                    CASE vrc_CostCalculation."Allocation Level" OF
                        vrc_CostCalculation."Allocation Level"::"Voyage No.":
                            BEGIN
                                lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", vrc_CostCalculation."Voyage No.");
                                lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", '');
                            END;
                        vrc_CostCalculation."Allocation Level"::"Master Batch No.":
                            BEGIN
                                lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", vrc_CostCalculation."Master Batch No.");
                                lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", '');
                            END;
                    END;

                    IF NOT lrc_MasterBatchTemp.FIND('-') THEN
                        EXIT;



                    // --------------------------------------------------------------------------------------
                    // Von Enter Data auf Detail Batch verteilen
                    // --------------------------------------------------------------------------------------
                    lrc_CostCalculationData.RESET();
                    lrc_CostCalculationData.SETRANGE("Document No.", vrc_CostCalculation."Document No.");
                    IF lrc_CostCalculationData.FIND('-') THEn
                        REPEAT

                            // Verteilung auf die Positionen
                            IF lrc_CostCalculationData."Batch No." = '' THEN BEGIN

                                ldc_SumAmount := 0;
                                ldc_SumAmountMW := 0;

                                // Schleife um alle Positionen
                                lrc_BatchTemp.RESET();
                                lrc_BatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                                lrc_BatchTemp.SETRANGE("Userid Code", USERID());
                                lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
                                lrc_BatchTemp.SETRANGE("MCS Without Allocation", FALSE);
                                IF lrc_BatchTemp.FIND('-') THEN BEGIN
                                    REPEAT

                                        lrc_Batch.GET(lrc_BatchTemp."MCS Batch No.");

                                        CASE lrc_CostCalculationData."Allocation Type" OF
                                            lrc_CostCalculationData."Allocation Type"::Pallets:
                                                BEGIN
                                                    IF lrc_MasterBatchTemp."MCS Quantity Pallets" = 0 THEN
                                                        // Betrag kann nicht über Paletten verteilt werden!
                                                        ERROR(AGILES_LT_TEXT003Txt);
                                                    ldc_Proz := lrc_BatchTemp."MCS Quantity Pallets" / lrc_MasterBatchTemp."MCS Quantity Pallets";
                                                    ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
                                                END;

                                            lrc_CostCalculationData."Allocation Type"::Kolli:
                                                BEGIN
                                                    IF lrc_MasterBatchTemp."MCS Quantity Colli" = 0 THEN
                                                        // Betrag kann nicht über Kolli verteilt werden!
                                                        ERROR(AGILES_LT_TEXT004Txt);
                                                    ldc_Proz := lrc_BatchTemp."MCS Quantity Colli" / lrc_MasterBatchTemp."MCS Quantity Colli";
                                                    ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
                                                END;

                                            lrc_CostCalculationData."Allocation Type"::"Net Weight":
                                                BEGIN
                                                    IF lrc_MasterBatchTemp."MCS Net Weight" = 0 THEN
                                                        // Betrag kann nicht über Nettogewicht verteilt werden!
                                                        ERROR(AGILES_LT_TEXT005Txt);
                                                    ldc_Proz := lrc_BatchTemp."MCS Net Weight" / lrc_MasterBatchTemp."MCS Net Weight";
                                                    ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
                                                END;

                                            lrc_CostCalculationData."Allocation Type"::"Gross Weight":
                                                BEGIN
                                                    IF lrc_MasterBatchTemp."MCS Gross Weight" = 0 THEN
                                                        // Betrag kann nicht über Bruttogewicht verteilt werden!
                                                        ERROR(AGILES_LT_TEXT006Txt);
                                                    ldc_Proz := lrc_BatchTemp."MCS Gross Weight" / lrc_MasterBatchTemp."MCS Gross Weight";
                                                    ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
                                                END;

                                            lrc_CostCalculationData."Allocation Type"::Lines:
                                                BEGIN
                                                    IF lrc_MasterBatchTemp."MCS No. of Lines" = 0 THEN
                                                        // Betrag kann nicht über Anzahl Zeilen verteilt werden!
                                                        ERROR(AGILES_LT_TEXT007Txt);
                                                    ldc_Proz := lrc_BatchTemp."MCS No. of Lines" / lrc_MasterBatchTemp."MCS No. of Lines";
                                                    ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
                                                END;

                                            lrc_CostCalculationData."Allocation Type"::Amount:
                                                BEGIN
                                                    IF lrc_MasterBatchTemp."MCS Total Amount" = 0 THEN
                                                        // Betrag kann nicht über Gesamtbetrag verteilt werden!
                                                        ERROR(AGILES_LT_TEXT008Txt);
                                                    ldc_Proz := lrc_BatchTemp."MCS Total Amount" / lrc_MasterBatchTemp."MCS Total Amount";
                                                    ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
                                                END;
                                        END;

                                        // Detailzeile Batch einfügen
                                        lrc_CostCalcDetailBatch.RESET();
                                        lrc_CostCalcDetailBatch := lrc_CostCalculationData;
                                        lrc_CostCalcDetailBatch."Document No." := 0;
                                        lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
                                        lrc_CostCalcDetailBatch."Batch No." := lrc_BatchTemp."MCS Batch No.";
                                        lrc_CostCalcDetailBatch."Master Batch No." := lrc_Batch."Master Batch No.";
                                        lrc_CostCalcDetailBatch."Voyage No." := lrc_Batch."Voyage No.";
                                        lrc_CostCalcDetailBatch.VALIDATE(Amount, ldc_Amount);
                                        lrc_CostCalcDetailBatch."Attached to Entry No." := lrc_CostCalculationData."Document No.";
                                        lrc_CostCalcDetailBatch."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
                                        lrc_CostCalcDetailBatch."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";
                                        lrc_CostCalcDetailBatch.INSERT(TRUE);
                                        ldc_SumAmount := ldc_SumAmount + ldc_Amount;
                                        ldc_SumAmountMW := ldc_SumAmountMW + ldc_AmountMW;
                                    UNTIL lrc_BatchTemp.NEXT() = 0;
                                    // Kontrolle ob verteilter Betrag dem Gesamtbetrag entspricht
                                    // Differenz auf letzte Zeile übertragen
                                    IF ldc_SumAmount <> lrc_CostCalculationData.Amount THEN
                                        IF lrc_CostCalcDetailBatch."Document No." <> 0 THEN BEGIN
                                            ldc_SumAmount := lrc_CostCalculationData.Amount - ldc_SumAmount;
                                            ldc_SumAmountMW := lrc_CostCalculationData."Amount (LCY)" - ldc_SumAmountMW;
                                            lrc_CostCalcDetailBatch.VALIDATE(Amount, (lrc_CostCalcDetailBatch.Amount + ldc_SumAmount));
                                            lrc_CostCalcDetailBatch.MODIFY();
                                        END;
                                END;
                            END ELSE BEGIN
                                lrc_Batch.GET(lrc_CostCalculationData."Batch No.");
                                lrc_CostCalcDetailBatch.RESET();
                                lrc_CostCalcDetailBatch := lrc_CostCalculationData;
                                lrc_CostCalcDetailBatch."Document No." := 0;
                                lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
                                lrc_CostCalcDetailBatch."Master Batch No." := lrc_Batch."Master Batch No.";
                                lrc_CostCalcDetailBatch."Voyage No." := lrc_Batch."Voyage No.";
                                lrc_CostCalcDetailBatch."Attached to Entry No." := lrc_CostCalculationData."Document No.";
                                lrc_CostCalcDetailBatch."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
                                lrc_CostCalcDetailBatch."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";
                                lrc_CostCalcDetailBatch.INSERT(TRUE);
                            END;
                            IF lrc_CostCalculationData.RECORDLEVELLOCKING() THEN
                                COMMIT();
                            // Kennzeichen auf "Verteilt" setzen
                            lrc_CostCalculationData.Allocated := TRUE;
                            lrc_CostCalculationData.MODIFY();
                        UNTIL lrc_CostCalculationData.NEXT() = 0;



                    // --------------------------------------------------------------------------------------
                    // Von Detail Batch auf Detail Batch Variant verteilen
                    // --------------------------------------------------------------------------------------
                    lrc_CostCalcDetailBatch.RESET();
                    lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
                    lrc_CostCalcDetailBatch.SETRANGE("Entry Type", lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
                    lrc_CostCalcDetailBatch.SETRANGE("Cost Category Code", vrc_CostCalculation."Cost Category Code");
                    lrc_CostCalcDetailBatch.SETRANGE("Attached to Entry No.", vrc_CostCalculation."Document No.");
                    lrc_CostCalcDetailBatch.SETRANGE("Document No. 2", vrc_CostCalculation."Document No. 2");
                    IF lrc_CostCalcDetailBatch.FIND('-') THEN
                        REPEAT
                            lrc_CostCalcDetailBatch.TESTFIELD("Batch No.");
                            // Summensatz Position lesen
                            lrc_BatchTemp.RESET();
                            lrc_BatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                            lrc_BatchTemp.SETRANGE("Userid Code", USERID());
                            lrc_BatchTemp.SETRANGE("MCS Batch No.", lrc_CostCalcDetailBatch."Batch No.");
                            lrc_BatchTemp.SETRANGE("MCS Master Batch No.", lrc_CostCalcDetailBatch."Master Batch No.");
                            lrc_BatchTemp.FIND('-');
                            // Schleife um die Positionsvarianten der Position
                            lrc_BatchVariant.RESET();
                            lrc_BatchVariant.SETCURRENTKEY("Master Batch No.", "Batch No.");
                            lrc_BatchVariant.SETRANGE("Master Batch No.", lrc_CostCalcDetailBatch."Master Batch No.");
                            lrc_BatchVariant.SETRANGE("Batch No.", lrc_CostCalcDetailBatch."Batch No.");
                            IF lrc_BatchVariant.FIND('-') THEN
                                REPEAT
                                    // Einkaufszeile lesen
                                    lrc_PurchLine.RESET();
                                    lrc_PurchLine.SETCURRENTKEY("Document Type", Type, "POI Master Batch No.", "POI Batch No.", "POI Batch Variant No.");
                                    lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
                                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                                    lrc_PurchLine.SETRANGE("POI Master Batch No.", lrc_BatchVariant."Master Batch No.");
                                    lrc_PurchLine.SETRANGE("POI Batch No.", lrc_BatchVariant."Batch No.");
                                    lrc_PurchLine.SETRANGE("POI Batch Variant No.", lrc_BatchVariant."No.");
                                    lrc_PurchLine.SETFILTER(Quantity, '<>%1', 0);
                                    IF lrc_PurchLine.FIND('-') THEN BEGIN
                                        ldc_Proz := 0;
                                        ldc_Amount := 0;
                                        ldc_AmountMW := 0;
                                        CASE lrc_CostCalcDetailBatch."Allocation Type" OF
                                            lrc_CostCalcDetailBatch."Allocation Type"::Pallets:
                                                BEGIN
                                                    IF lrc_BatchTemp."MCS Quantity Pallets" = 0 THEN
                                                        // Betrag kann nicht über Paletten auf die Positionsvarianten verteilt werden!
                                                        ERROR(AGILES_LT_TEXT009Txt);
                                                    IF lrc_PurchLine."POI Quantity (TU)" <> 0 THEN BEGIN
                                                        ldc_Proz := lrc_PurchLine."POI Quantity (TU)" / lrc_BatchTemp."MCS Quantity Pallets";
                                                        ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
                                                    END ELSE
                                                        ldc_Amount := lrc_CostCalcDetailBatch.Amount;
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
                                                END;
                                            lrc_CostCalcDetailBatch."Allocation Type"::Kolli:
                                                BEGIN
                                                    IF lrc_BatchTemp."MCS Quantity Colli" = 0 THEN
                                                        // Betrag kann nicht über Kolli auf die Positionsvarianten verteilt werden!
                                                        ERROR(AGILES_LT_TEXT010Txt);
                                                    ldc_Proz := lrc_PurchLine.Quantity / lrc_BatchTemp."MCS Quantity Colli";
                                                    ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
                                                END;
                                            lrc_CostCalcDetailBatch."Allocation Type"::"Net Weight":
                                                BEGIN
                                                    IF lrc_BatchTemp."MCS Net Weight" = 0 THEN
                                                        // Betrag kann nicht über Nettogewicht verteilt werden!
                                                        ERROR(AGILES_LT_TEXT011Txt);
                                                    ldc_Proz := lrc_PurchLine."POI Total Net Weight" / lrc_BatchTemp."MCS Net Weight";
                                                    ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
                                                END;
                                            lrc_CostCalcDetailBatch."Allocation Type"::"Gross Weight":
                                                BEGIN
                                                    IF lrc_BatchTemp."MCS Gross Weight" = 0 THEN
                                                        // Betrag kann nicht über Bruttogewicht verteilt werden!
                                                        ERROR(AGILES_LT_TEXT006Txt);
                                                    ldc_Proz := lrc_PurchLine."POI Total Gross Weight" / lrc_BatchTemp."MCS Gross Weight";
                                                    ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
                                                END;
                                            lrc_CostCalcDetailBatch."Allocation Type"::Lines:
                                                BEGIN
                                                    IF lrc_BatchTemp."MCS No. of Lines" = 0 THEN
                                                        // Betrag kann nicht über Anzahl Zeilen verteilt werden!
                                                        ERROR(AGILES_LT_TEXT007Txt);
                                                    ldc_Proz := 1 / lrc_BatchTemp."MCS No. of Lines";
                                                    ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
                                                END;
                                            lrc_CostCalcDetailBatch."Allocation Type"::Amount:
                                                BEGIN
                                                    IF lrc_BatchTemp."MCS Total Amount" = 0 THEN
                                                        // Betrag kann nicht über Gesamtbetrag verteilt werden!
                                                        ERROR(AGILES_LT_TEXT008Txt);
                                                    ldc_Proz := lrc_PurchLine.Amount / lrc_BatchTemp."MCS Total Amount";
                                                    ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
                                                    ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
                                                END;
                                        END;
                                        // Detailzeile Batch einfügen
                                        lrc_CostCalcDetailBatchVar.RESET();
                                        lrc_CostCalcDetailBatchVar.INIT();
                                        lrc_CostCalcDetailBatchVar := lrc_CostCalcDetailBatch;
                                        lrc_CostCalcDetailBatchVar."Document No." := 0;
                                        lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch Variant";
                                        lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_BatchVariant."No.";
                                        lrc_CostCalcDetailBatchVar.VALIDATE(Amount, ldc_Amount);
                                        lrc_CostCalcDetailBatchVar."Attached to Entry No." := lrc_CostCalculationData."Document No.";
                                        lrc_CostCalcDetailBatchVar."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
                                        lrc_CostCalcDetailBatchVar."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";
                                        lrc_CostCalcDetailBatchVar.INSERT(TRUE);
                                    END ELSE BEGIN
                                        // Detailzeile Batch einfügen
                                        lrc_CostCalcDetailBatchVar.RESET();
                                        lrc_CostCalcDetailBatchVar.INIT();
                                        lrc_CostCalcDetailBatchVar := lrc_CostCalcDetailBatch;
                                        lrc_CostCalcDetailBatchVar."Document No." := 0;
                                        lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch Variant";
                                        lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_BatchVariant."No.";
                                        //lrc_CostCalcDetailBatchVar.VALIDATE(Amount,ldc_Amount);
                                        lrc_CostCalcDetailBatchVar."Attached to Entry No." := lrc_CostCalculationData."Document No.";
                                        lrc_CostCalcDetailBatchVar."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
                                        lrc_CostCalcDetailBatchVar."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";
                                        lrc_CostCalcDetailBatchVar.INSERT(TRUE);
                                    END;
                                UNTIL lrc_BatchVariant.NEXT() = 0;
                        // Reste der letzten Positionsvariante zuordnen
                        UNTIL lrc_CostCalcDetailBatch.NEXT() = 0;

                    // -------------------------------------------------------------------------------------------------
                    // Kosten in die Herkunftszeilen übertragen
                    // -------------------------------------------------------------------------------------------------

                    IF vrc_CostCalculation."Master Batch No." <> '' THEN BEGIN
                        lrc_MasterBatch.GET(vrc_CostCalculation."Master Batch No.");
                        IF lrc_MasterBatch.Source <> lrc_MasterBatch.Source::"Purch. Order" THEN
                            EXIT;
                    END;


                    // Einkaufskopf lesen
                    lrc_PurchHeader.RESET();
                    lrc_PurchHeader.SETRANGE("Document Type", lrc_PurchHeader."Document Type"::Order);
                    CASE vrc_CostCalculation."Allocation Level" OF
                        vrc_CostCalculation."Allocation Level"::"Voyage No.":
                            lrc_PurchHeader.SETRANGE("POI Voyage No.", vrc_CostCalculation."Voyage No.");
                        vrc_CostCalculation."Allocation Level"::"Master Batch No.":
                            lrc_PurchHeader.SETRANGE("POI Master Batch No.", vrc_CostCalculation."Master Batch No.");
                    END;
                    IF lrc_PurchHeader.FIND('-') THEN
                        REPEAT
                            lrc_PurchLine.RESET();
                            lrc_PurchLine.SETCURRENTKEY("Document Type", Type, "POI Master Batch No.", "POI Batch No.", "POI Batch Variant No.");
                            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                            lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
                            lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                            lrc_PurchLine.SETFILTER("No.", '<>%1', '');
                            lrc_PurchLine.SETFILTER("POI Batch Variant No.", '<>%1', '');
                            IF lrc_PurchLine.FIND('-') THEN
                                REPEAT
                                    // Werte auf Null setzen
                                    lrc_PurchLine."POI Cost Calc. Amount (LCY)" := 0;
                                    lrc_PurchLine."POI Cost Calc. (UOM) (LCY)" := 0;
                                    lrc_PurchLine."POI Indirect Cost Amount (LCY)" := 0;

                                    lrc_CostCalcDetailBatchVar.RESET();
                                    lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Batch Variant No.", "Vendor No.");
                                    lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", lrc_PurchLine."POI Master Batch No.");
                                    lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.", lrc_PurchLine."POI Batch No.");
                                    lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.", lrc_PurchLine."POI Batch Variant No.");
                                    lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
                                    IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
                                        REPEAT
                                            // Alle Kosten aufaddieren
                                            lrc_PurchLine."POI Cost Calc. Amount (LCY)" := lrc_PurchLine."POI Cost Calc. Amount (LCY)" +
                                                                                       lrc_CostCalcDetailBatchVar."Amount (LCY)";
                                            // Indirekte Kosten aufaddieren
                                            IF lrc_CostCalcDetailBatchVar."Indirect Cost (Purchase)" = TRUE THEN
                                                lrc_PurchLine."POI Indirect Cost Amount (LCY)" := lrc_PurchLine."POI Indirect Cost Amount (LCY)" +
                                                                                              lrc_CostCalcDetailBatchVar."Amount (LCY)";
                                        UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;

                                    IF lrc_PurchLine.Quantity <> 0 THEN
                                        lrc_PurchLine."POI Cost Calc. (UOM) (LCY)" := ROUND(lrc_PurchLine."POI Cost Calc. Amount (LCY)" /
                                                                                           lrc_PurchLine.Quantity, 0.00001);
                                    lrc_PurchLine.UpdateUnitCost();
                                    lrc_PurchLine.MODIFY();
                                    // Werte in die Batch Variant schreiben
                                    IF lrc_BatchVariant.GET(lrc_PurchLine."POI Batch Variant No.") THEN BEGIN
                                        lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                                        lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := lrc_PurchLine."POI Cost Calc. (UOM) (LCY)";
                                        // Indirekte Kosten
                                        lrc_BatchVariant.MODIFY();
                                    END;

                                UNTIL lrc_PurchLine.NEXT() = 0;

                        UNTIL lrc_PurchHeader.NEXT() = 0
                    // Werte nur in Positionsvariante schreiben, da Einkauf nicht mehr vorhanden
                    ELSE BEGIN

                        lrc_BatchVariant.RESET();
                        CASE vrc_CostCalculation."Allocation Level" OF
                            vrc_CostCalculation."Allocation Level"::"Voyage No.":
                                lrc_BatchVariant.SETRANGE("Voyage No.", vrc_CostCalculation."Voyage No.");
                            vrc_CostCalculation."Allocation Level"::"Master Batch No.":
                                lrc_BatchVariant.SETRANGE("Master Batch No.", vrc_CostCalculation."Master Batch No.");
                        END;
                        IF lrc_BatchVariant.FIND('-') THEN
                            REPEAT
                                lrc_BatchVariant.CALCFIELDS("B.V. Purch. Rec. (Qty)", "B.V. Purch. Order (Qty)");
                                // Werte zurücksetzen
                                lrc_BatchVariant."Cost Calc. Amount (LCY)" := 0;
                                lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := 0;
                                lrc_CostCalcDetailBatchVar.RESET();
                                lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Batch Variant No.", "Vendor No.");
                                lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", lrc_BatchVariant."Master Batch No.");
                                lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.", lrc_BatchVariant."Batch No.");
                                lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.", lrc_BatchVariant."No.");
                                lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
                                IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
                                    REPEAT
                                        lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" + lrc_CostCalcDetailBatchVar."Amount (LCY)";
                                    UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;
                                IF (lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") <> 0 THEN
                                    lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" /
                                      ((lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") /
                                       lrc_BatchVariant."Qty. per Unit of Measure");
                                lrc_BatchVariant.MODIFY();
                            UNTIL lrc_BatchVariant.NEXT() = 0;
                    END;

                END;

        END;
    end;

    //     procedure _UpdSignIndirectCostPurchase(vco_MasterBatchNo: Code[20])
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCategory: Record "POI Cost Category";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Aktualisierung Kennzeichen Indirekte Kosten Einkauf
    //         // ---------------------------------------------------------------------------------

    //         IF vco_MasterBatchNo <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF lrc_CostCalculation.FIND('-') THEN
    //             REPEAT
    //                 IF lrc_CostCategory.GET(lrc_CostCalculation."Cost Category Code") THEN BEGIN
    //                     lrc_CostCalculation."Indirect Cost (Purchase)" := lrc_CostCategory."Indirect Cost (Purchase)";
    //                 END ELSE BEGIN
    //                     lrc_CostCalculation."Indirect Cost (Purchase)" := FALSE;
    //                 END;
    //                 lrc_CostCalculation.MODIFY();
    //             UNTIL lrc_CostCalculation.NEXT() = 0;
    //     end;

    //     procedure _UpdSignReduceFromTurnover(vco_MasterBatchNo: Code[20])
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCategory: Record "POI Cost Category";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Aktualisierung Kennzeichen Kosten vom Umsatz abziehen
    //         // ---------------------------------------------------------------------------------

    //         IF vco_MasterBatchNo <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF lrc_CostCalculation.FIND('-') THEN
    //             REPEAT
    //                 IF lrc_CostCategory.GET(lrc_CostCalculation."Cost Category Code") THEN BEGIN
    //                     lrc_CostCalculation."Reduce Cost from Turnover" := lrc_CostCategory."Reduce Cost from Turnover";
    //                 END ELSE BEGIN
    //                     lrc_CostCalculation."Reduce Cost from Turnover" := FALSE;
    //                 END;
    //                 lrc_CostCalculation.MODIFY();
    //             UNTIL lrc_CostCalculation.NEXT() = 0;
    //     end;

    //     procedure _LoadDutyCalcCostFromSales(vco_MasterBatchNo: Code[20])
    //     var
    //         lrc_Batch: Record "POI Batch";
    //         lrc_SalesDutyCostControle: Record "5087943";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         ldc_DutyCostPerBatch: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zum Laden der kalkulierten Zollkosten aus den Verkäufen
    //         // ---------------------------------------------------------------------------------

    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
    //         lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF NOT lrc_CostCalculation.FIND('-') THEN
    //             _LoadCostCategories(3, '', '', vco_MasterBatchNo);


    //         lrc_Batch.RESET();
    //         lrc_Batch.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF lrc_Batch.FIND('-') THEN BEGIN
    //             REPEAT

    //                 ldc_DutyCostPerBatch := 0;

    //                 lrc_SalesDutyCostControle.RESET();
    //                 lrc_SalesDutyCostControle.SETRANGE("Batch No.", lrc_Batch."No.");
    //                 IF lrc_SalesDutyCostControle.FIND('-') THEN
    //                     REPEAT
    //                         ldc_DutyCostPerBatch := ldc_DutyCostPerBatch + lrc_SalesDutyCostControle."Cust. Duty Amount (LCY)";
    //                     UNTIL lrc_SalesDutyCostControle.NEXT() = 0;




    //                 lrc_CostCalculation.RESET();
    //                 lrc_CostCalculation.SETRANGE("Master Batch No.", lrc_Batch."Master Batch No.");
    //                 lrc_CostCalculation.SETRANGE("Batch No.", lrc_Batch."No.");
    //                 lrc_CostCalculation.SETRANGE("Batch Variant No.", '');
    //                 lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Enter Data");
    //                 lrc_CostCalculation.SETRANGE("Cost Category Code", '????');
    //                 IF NOT lrc_CostCalculation.FIND('-') THEN BEGIN
    //                     IF ldc_DutyCostPerBatch <> 0 THEN BEGIN




    //                     END;
    //                 END ELSE BEGIN
    //                     lrc_CostCalculation.VALIDATE(Amount, ldc_DutyCostPerBatch);
    //                 END;

    //             UNTIL lrc_Batch.NEXT() = 0;

    //         END;
    //     end;

    //     procedure "-- MATRIX COST INVOICE --"()
    //     begin
    //     end;

    //     procedure _MatrixEnterData(vco_MasterBatchCode: Code[20])
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Erfassung der Kosten über die Matrix
    //         // ---------------------------------------------------------------------------------
    //         ERROR('Nicht genutzt');
    //         /*
    //         _LoadCostCategories(3,'','',vco_MasterBatchCode);
    //         COMMIT;

    //         lfm_CostCalcEnterMatrix.SetValues(vco_MasterBatchCode);
    //         lfm_CostCalcEnterMatrix.RUNMODAL;

    //         __MasterBatchCalcCost(vco_MasterBatchCode,'');
    //         */

    //     end;

    //     procedure "-- PURCHASE COST INVOICE --"()
    //     begin
    //     end;

    //     procedure _LoadCostCalcInPurchInvoice(vrc_PurchHeader: Record "Purchase Header")
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalculationBatch: Record "POI Cost Calc. - Enter Data";
    //         lrc_PurchLine: Record "Purchase Line";
    //         lrc_CostCategoryAccounts: Record "5110346";
    //         lrc_GLAccount: Record "G/L Account";
    //         lfm_CostCategoryAccounts: Form "5110346";
    //         lin_LineNo: Integer;
    //         lco_GLAccountNo: Code[20];
    //         ldc_KontollSumme: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zum Laden von Sollkosten in Eink.-Rechnung auf Basis des Kreditors
    //         // ---------------------------------------------------------------------------------
    //         ERROR('Nicht genutzt');
    //         /*

    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETCURRENTKEY("Entry Type","Vendor No.",Released,"No. of Loadings in Doc.");

    //         lrc_CostCalculation.FILTERGROUP(2);
    //         lrc_CostCalculation.SETRANGE("Entry Type",lrc_CostCalculation."Entry Type"::"Enter Data");
    //         lrc_CostCalculation.SETRANGE("Vendor No.",vrc_PurchHeader."Buy-from Vendor No.");
    //         lrc_CostCalculation.FILTERGROUP(0);
    //         lrc_CostCalculation.SETRANGE(Released,TRUE);
    //         lrc_CostCalculation.SETRANGE("No. of Loadings in Doc.",0);

    //         lfm_CalcCostLoadinPurchInv.SetPurchaseHeader(vrc_PurchHeader);
    //         lfm_CalcCostLoadinPurchInv.SETTABLEVIEW(lrc_CostCalculation);
    //         lfm_CalcCostLoadinPurchInv.EDITABLE := FALSE;
    //         lfm_CalcCostLoadinPurchInv.LOOKUPMODE := TRUE;
    //         IF lfm_CalcCostLoadinPurchInv.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;
    //         */

    //         /*---------------------------------------------
    //         lrc_CostCalculation.RESET();
    //         lfm_CalcCostLoadinPurchInv.GETRECORD(lrc_CostCalculation);

    //         IF lrc_CostCalculation.Freigegeben = FALSE THEN
    //           ERROR('Der ausgewählte Kostensatz ist noch nicht freigegeben!');


    //         // Über die Kostenkategorie das Sachkonto ermitteln
    //         lrc_CostCategoryAccounts.RESET();
    //         lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code",'');
    //         lrc_CostCategoryAccounts.SETRANGE("Cost Category Code",lrc_CostCalculation."Cost Category Code");
    //         IF lrc_CostCategoryAccounts.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_GLAccount.GET(lrc_CostCategoryAccounts."G/L Account No.");
    //             IF lrc_GLAccount."Gen. Bus. Posting Group" = vrc_PurchHeader."Gen. Bus. Posting Group" THEN BEGIN
    //               lco_GLAccountNo := lrc_CostCategoryAccounts."G/L Account No.";
    //             END;
    //           UNTIL lrc_CostCategoryAccounts.NEXT() = 0;


    //           // Auswahl Sachkonto durch den Anwender über die zugeordneten Konten
    //           IF lco_GLAccountNo = '' THEN BEGIN

    //             lrc_CostCategoryAccounts.RESET();
    //             lrc_CostCategoryAccounts.FILTERGROUP(2);
    //             lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code",'');
    //             lrc_CostCategoryAccounts.SETRANGE("Cost Category Code",lrc_CostCalculation."Cost Category Code");
    //             lrc_CostCategoryAccounts.FILTERGROUP(0);
    //             lfm_CostCategoryAccounts.SETTABLEVIEW(lrc_CostCategoryAccounts);
    //             lfm_CostCategoryAccounts.LOOKUPMODE := TRUE;
    //             IF lfm_CostCategoryAccounts.RUNMODAL <> ACTION::LookupOK THEN
    //               ERROR('Abbruch!');

    //             lrc_CostCategoryAccounts.RESET();
    //             lfm_CostCategoryAccounts.GETRECORD(lrc_CostCategoryAccounts);
    //             lco_GLAccountNo := lrc_CostCategoryAccounts."G/L Account No.";

    //           END;

    //         END ELSE BEGIN
    //           ERROR('Der Kostenkategorie sind keine Sachkonten zugeordnet!');
    //         END;

    //         lrc_FruitVisionSetup.GET();
    //         lrc_BatchSetup.GET();
    //         ldc_KontollSumme := 0;

    //         lrc_PurchLine.RESET();
    //         lrc_PurchLine.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //         lrc_PurchLine.SETRANGE("Document No.",vrc_PurchHeader."No.");
    //         IF lrc_PurchLine.FIND('+') THEN
    //           lin_LineNo := lrc_PurchLine."Line No."
    //         ELSE
    //           lin_LineNo := 0;

    //         // Alle zugehörigen Einträge auf Positionsebene lesen und Einkaufsrechnungszeile anlegen
    //         lrc_CostCalculationBatch.RESET();
    //         lrc_CostCalculationBatch.SETRANGE("Attached to Entry No.",lrc_CostCalculation."Entry No.");
    //         IF lrc_CostCalculationBatch.FIND('-') THEN BEGIN

    //           // Überschrift setzen
    //           lrc_PurchLine.RESET();
    //           lrc_PurchLine."Document Type" := vrc_PurchHeader."Document Type";
    //           lrc_PurchLine."Document No." := vrc_PurchHeader."No.";
    //           lin_LineNo := lin_LineNo + 10000;
    //           lrc_PurchLine."Line No." := lin_LineNo;
    //           lrc_PurchLine."Buy-from Vendor No." := vrc_PurchHeader."Buy-from Vendor No.";
    //           lrc_PurchLine."Pay-to Vendor No." := vrc_PurchHeader."Pay-to Vendor No.";
    //           lrc_PurchLine.INSERT(TRUE);
    //           lrc_PurchLine.Type := lrc_PurchLine.Type::" ";
    //           lrc_PurchLine.Description := 'Buchung';
    //           lrc_PurchLine.MODIFY();


    //           REPEAT

    //             lrc_PurchLine.RESET();
    //             lrc_PurchLine."Document Type" := vrc_PurchHeader."Document Type";
    //             lrc_PurchLine."Document No." := vrc_PurchHeader."No.";
    //             lin_LineNo := lin_LineNo + 10000;
    //             lrc_PurchLine."Line No." := lin_LineNo;
    //             lrc_PurchLine."Buy-from Vendor No." := vrc_PurchHeader."Buy-from Vendor No.";
    //             lrc_PurchLine."Pay-to Vendor No." := vrc_PurchHeader."Pay-to Vendor No.";
    //             lrc_PurchLine.INSERT(TRUE);

    //             lrc_PurchLine.VALIDATE(Type,lrc_PurchLine.Type::"G/L Account");
    //             lrc_PurchLine.VALIDATE("No.",lco_GLAccountNo);

    //             lrc_PurchLine.VALIDATE(Quantity,1);
    //             lrc_PurchLine.VALIDATE("Direct Unit Cost",lrc_CostCalculationBatch."Amount (LCY)");

    //             // Dimension Position setzen
    //             CASE lrc_BatchSetup."Dim. No. Batch" OF
    //             lrc_BatchSetup."Dim. No. Batch"::"1. Dimension":
    //               lrc_PurchLine.VALIDATE("Shortcut Dimension 1 Code",lrc_CostCalculationBatch."Batch No.");
    //             lrc_BatchSetup."Dim. No. Batch"::"2. Dimension":
    //               lrc_PurchLine.VALIDATE("Shortcut Dimension 2 Code",lrc_CostCalculationBatch."Batch No.");
    //             lrc_BatchSetup."Dim. No. Batch"::"3. Dimension":
    //               lrc_PurchLine.VALIDATE("Shortcut Dimension 3 Code",lrc_CostCalculationBatch."Batch No.");
    //             lrc_BatchSetup."Dim. No. Batch"::"4. Dimension":
    //               lrc_PurchLine.VALIDATE("Shortcut Dimension 4 Code",lrc_CostCalculationBatch."Batch No.");
    //             ELSE
    //               ERROR('Fehlerhafte Dimensionszuordnung Position!')
    //             END;

    //             // Dimension Kostenkategorie setzen
    //             CASE lrc_FruitVisionSetup."Dim. No. Cost Category" OF
    //             lrc_FruitVisionSetup."Dim. No. Cost Category"::"1. Dimension":
    //             lrc_PurchLine.VALIDATE("Shortcut Dimension 1 Code",lrc_CostCalculationBatch."Cost Category Code");
    //             lrc_FruitVisionSetup."Dim. No. Cost Category"::"2. Dimension":
    //             lrc_PurchLine.VALIDATE("Shortcut Dimension 2 Code",lrc_CostCalculationBatch."Cost Category Code");
    //             lrc_FruitVisionSetup."Dim. No. Cost Category"::"3. Dimension":
    //             lrc_PurchLine.VALIDATE("Shortcut Dimension 3 Code",lrc_CostCalculationBatch."Cost Category Code");
    //             lrc_FruitVisionSetup."Dim. No. Cost Category"::"4. Dimension":
    //             lrc_PurchLine.VALIDATE("Shortcut Dimension 4 Code",lrc_CostCalculationBatch."Cost Category Code");
    //             ELSE
    //               ERROR('Fehlerhafte Dimensionszuordnung Kostenkategorie!')
    //             END;

    //             lrc_PurchLine.MODIFY(TRUE);

    //             ldc_KontollSumme := ldc_KontollSumme + lrc_PurchLine."Line Amount";


    //           UNTIL lrc_CostCalculationBatch.NEXT() = 0;


    //           IF ldc_KontollSumme <> lrc_CostCalculation."Amount (LCY)" THEN BEGIN

    //             ldc_KontollSumme := lrc_CostCalculation."Amount (LCY)" - ldc_KontollSumme;
    //             lrc_PurchLine.VALIDATE("Direct Unit Cost",(lrc_PurchLine."Direct Unit Cost" + ldc_KontollSumme));
    //             lrc_PurchLine.MODIFY();

    //           END;

    //         END ELSE
    //           ERROR('Es sind keine Kostenkalkulationszeilen auf Positionsebene vorhanden!');
    //         -------------------------------------------*/

    //     end;

    //     procedure _CreatePurchInvLines(var rrc_CostCalculation: Record "POI Cost Calc. - Enter Data"; vrc_PurchHeader: Record "Purchase Header")
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_CostCalculationBatch: Record "POI Cost Calc. - Enter Data";
    //         lrc_PurchLine: Record "Purchase Line";
    //         lrc_CostCategoryAccounts: Record "5110346";
    //         lrc_GLAccount: Record "G/L Account";
    //         lfm_CostCategoryAccounts: Form "5110346";
    //         lin_LineNo: Integer;
    //         lco_GLAccountNo: Code[20];
    //         ldc_KontollSumme: Decimal;
    //         gbn_SetFilterOnGroup: Boolean;
    //         AGILES_LT_TEXT001: Label 'Der Kostenkategorie sind keine Sachkonten zugeordnet!';
    //         AGILES_LT_TEXT002: Label 'Abbruch!';
    //         AGILES_LT_TEXT003: Label 'Fehlerhafte Dimensionszuordnung Position!';
    //         AGILES_LT_TEXT004: Label 'Fehlerhafte Dimensionszuordnung Kostenkategorie!';
    //         AGILES_LT_TEXT005: Label 'Es sind keine Kostenkalkulationszeilen auf Positionsebene für Nummer %1 vorhanden!';
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion
    //         // ---------------------------------------------------------------------------------

    //         lrc_FruitVisionSetup.GET();
    //         lrc_BatchSetup.GET();

    //         // AGILES START 080908 --> Änderung des Filters wieder entfernt da nur eine Zeile mitgenommen wird
    //         //rrc_CostCalculation.SETRANGE(Released,TRUE);
    //         // AGILES END
    //         IF rrc_CostCalculation.FIND('-') THEN BEGIN
    //             REPEAT

    //                 lco_GLAccountNo := '';

    //                 // KOK 004 FV400075.s
    //                 // Über die Kostenkategorie das Sachkonto ermitteln
    //                 // Suche mit Buchungsgruppenfilter
    //                 gbn_SetFilterOnGroup := FALSE;
    //                 lrc_CostCategoryAccounts.RESET();
    //                 lrc_CostCategoryAccounts.CALCFIELDS("Gen. Bus. Posting Group");
    //                 lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
    //                 lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", rrc_CostCalculation."Cost Category Code");
    //                 lrc_CostCategoryAccounts.SETRANGE("Gen. Bus. Posting Group", vrc_PurchHeader."Gen. Bus. Posting Group");
    //                 IF lrc_CostCategoryAccounts.FIND('-') THEN BEGIN
    //                     IF lrc_CostCategoryAccounts.COUNT = 1 THEN BEGIN
    //                         lco_GLAccountNo := lrc_CostCategoryAccounts."G/L Account No.";
    //                     END ELSE BEGIN
    //                         gbn_SetFilterOnGroup := TRUE;
    //                         lco_GLAccountNo := '';
    //                     END;
    //                 END ELSE BEGIN
    //                     // Suche ohne Buchungsgruppenfilter
    //                     lrc_CostCategoryAccounts.RESET();
    //                     lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
    //                     lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", rrc_CostCalculation."Cost Category Code");
    //                     IF NOT lrc_CostCategoryAccounts.FIND('-') THEN BEGIN
    //                         // Der Kostenkategorie sind keine Sachkonten zugeordnet!
    //                         ERROR(AGILES_LT_TEXT001);
    //                     END;
    //                 END;

    //                 // Auswahl Sachkonto durch den Anwender über die zugeordneten Konten
    //                 IF lco_GLAccountNo = '' THEN BEGIN

    //                     COMMIT;
    //                     CLEAR(lfm_CostCategoryAccounts);

    //                     lrc_CostCategoryAccounts.RESET();
    //                     lrc_CostCategoryAccounts.FILTERGROUP(2);
    //                     lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
    //                     lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", rrc_CostCalculation."Cost Category Code");
    //                     IF gbn_SetFilterOnGroup = TRUE THEN BEGIN
    //                         lrc_CostCategoryAccounts.CALCFIELDS("Gen. Bus. Posting Group");
    //                         lrc_CostCategoryAccounts.SETRANGE("Gen. Bus. Posting Group", vrc_PurchHeader."Gen. Bus. Posting Group");
    //                     END;
    //                     lrc_CostCategoryAccounts.FILTERGROUP(0);
    //                     lfm_CostCategoryAccounts.SETTABLEVIEW(lrc_CostCategoryAccounts);
    //                     lfm_CostCategoryAccounts.LOOKUPMODE := TRUE;
    //                     IF lfm_CostCategoryAccounts.RUNMODAL <> ACTION::LookupOK THEN
    //                         // Abbruch!
    //                         ERROR(AGILES_LT_TEXT002);

    //                     lrc_CostCategoryAccounts.RESET();
    //                     lfm_CostCategoryAccounts.GETRECORD(lrc_CostCategoryAccounts);
    //                     lco_GLAccountNo := lrc_CostCategoryAccounts."G/L Account No.";

    //                 END;
    //                 // KOK 004 FV400075.e

    //                 ldc_KontollSumme := 0;

    //                 lrc_PurchLine.RESET();
    //                 lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
    //                 lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
    //                 IF lrc_PurchLine.FIND('+') THEN
    //                     lin_LineNo := lrc_PurchLine."Line No."
    //                 ELSE
    //                     lin_LineNo := 0;

    //                 // Alle zugehörigen Einträge auf Positionsebene lesen und Einkaufsrechnungszeile anlegen
    //                 lrc_CostCalculationBatch.RESET();
    //                 lrc_CostCalculationBatch.SETRANGE("Attached to Entry No.", rrc_CostCalculation."Document No.");
    //                 // FV START 070207
    //                 lrc_CostCalculationBatch.SETFILTER("Amount (LCY)", '<>%1', 0);
    //                 // FV ENDE
    //                 IF lrc_CostCalculationBatch.FIND('-') THEN BEGIN

    //                     // Überschrift setzen
    //                     lrc_PurchLine.RESET();
    //                     lrc_PurchLine.INIT();
    //                     lrc_PurchLine."Document Type" := vrc_PurchHeader."Document Type";
    //                     lrc_PurchLine."Document No." := vrc_PurchHeader."No.";
    //                     lin_LineNo := lin_LineNo + 10000;
    //                     lrc_PurchLine."Line No." := lin_LineNo;
    //                     lrc_PurchLine."Buy-from Vendor No." := vrc_PurchHeader."Buy-from Vendor No.";
    //                     lrc_PurchLine."Pay-to Vendor No." := vrc_PurchHeader."Pay-to Vendor No.";
    //                     lrc_PurchLine.INSERT(TRUE);
    //                     lrc_PurchLine.Type := lrc_PurchLine.Type::" ";
    //                     lrc_PurchLine.Description := 'Buchung';
    //                     lrc_PurchLine.MODIFY();

    //                     REPEAT

    //                         lrc_PurchLine.RESET();
    //                         lrc_PurchLine."Document Type" := vrc_PurchHeader."Document Type";
    //                         lrc_PurchLine."Document No." := vrc_PurchHeader."No.";
    //                         lin_LineNo := lin_LineNo + 10000;
    //                         lrc_PurchLine."Line No." := lin_LineNo;
    //                         lrc_PurchLine."Buy-from Vendor No." := vrc_PurchHeader."Buy-from Vendor No.";
    //                         lrc_PurchLine."Pay-to Vendor No." := vrc_PurchHeader."Pay-to Vendor No.";
    //                         lrc_PurchLine.INSERT(TRUE);

    //                         lrc_PurchLine.VALIDATE(Type, lrc_PurchLine.Type::"G/L Account");
    //                         lrc_PurchLine.VALIDATE("No.", lco_GLAccountNo);

    //                         lrc_PurchLine.VALIDATE(Quantity, 1);
    //                         lrc_PurchLine.VALIDATE("Direct Unit Cost", lrc_CostCalculationBatch."Amount (LCY)");

    //                         // Dimension Position setzen
    //                         CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                             lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 1 Code", lrc_CostCalculationBatch."Batch No.");
    //                             lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 2 Code", lrc_CostCalculationBatch."Batch No.");
    //                             lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 3 Code", lrc_CostCalculationBatch."Batch No.");
    //                             lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 4 Code", lrc_CostCalculationBatch."Batch No.");
    //                             ELSE
    //                                 // Fehlerhafte Dimensionszuordnung Position!
    //                                 ERROR(AGILES_LT_TEXT003)
    //                         END;

    //                         // Dimension Kostenkategorie setzen
    //                         CASE lrc_FruitVisionSetup."Dim. No. Cost Category" OF
    //                             lrc_FruitVisionSetup."Dim. No. Cost Category"::"1. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 1 Code", lrc_CostCalculationBatch."Cost Category Code");
    //                             lrc_FruitVisionSetup."Dim. No. Cost Category"::"2. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 2 Code", lrc_CostCalculationBatch."Cost Category Code");
    //                             lrc_FruitVisionSetup."Dim. No. Cost Category"::"3. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 3 Code", lrc_CostCalculationBatch."Cost Category Code");
    //                             lrc_FruitVisionSetup."Dim. No. Cost Category"::"4. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 4 Code", lrc_CostCalculationBatch."Cost Category Code");
    //                             ELSE
    //                                 // Fehlerhafte Dimensionszuordnung Kostenkategorie!
    //                                 ERROR(AGILES_LT_TEXT004)
    //                         END;

    //                         lrc_PurchLine.MODIFY(TRUE);
    //                         ldc_KontollSumme := ldc_KontollSumme + lrc_PurchLine."Line Amount";

    //                     UNTIL lrc_CostCalculationBatch.NEXT() = 0;

    //                     IF ldc_KontollSumme <> rrc_CostCalculation."Amount (LCY)" THEN BEGIN
    //                         ldc_KontollSumme := rrc_CostCalculation."Amount (LCY)" - ldc_KontollSumme;
    //                         lrc_PurchLine.VALIDATE("Direct Unit Cost", (lrc_PurchLine."Direct Unit Cost" + ldc_KontollSumme));
    //                         lrc_PurchLine.MODIFY();
    //                     END;

    //                 END ELSE
    //                     // Es sind keine Kostenkalkulationszeilen auf Positionsebene für Nummer .. vorhanden!
    //                     ERROR(AGILES_LT_TEXT005, rrc_CostCalculation."Document No.");


    //                 // FV START 130508
    //                 rrc_CostCalculation."No. of Loadings in Doc." := rrc_CostCalculation."No. of Loadings in Doc." + 1;
    //                 rrc_CostCalculation.MODIFY();
    //             // FV ENDE

    //             UNTIL rrc_CostCalculation.NEXT() = 0;

    //         END;
    //     end;

    //     procedure "-- PLAN COST BY VOYAGE --"()
    //     begin
    //     end;

    //     procedure _Test(vrc_CostCalculation: Record "POI Cost Calc. - Enter Data")
    //     var
    //         lcu_BatchMgt: Codeunit "POI BAM Batch Management";
    //         lrc_PurchaseHeader: Record "Purchase Header";
    //         lrc_BatchTemp: Record "5110369";
    //     //lfm_FVPurchCostInvAllocation: Form "5110564";
    //     begin

    //         // ---------------------------------------------------
    //         // Funktion zum Verteilen von Plankosten
    //         // ---------------------------------------------------

    //         // Prüfung auf Satzart
    //         IF vrc_CostCalculation."Entry Type" <> vrc_CostCalculation."Entry Type"::"Enter Data" THEN
    //             ERROR('Satzart nicht zugelassen!');
    //         // Prüfung auf Betrag
    //         vrc_CostCalculation.TESTFIELD("Amount (LCY)");
    //         // Prüfung auf Reisenummer und Partienummer
    //         IF (vrc_CostCalculation."Master Batch No." = '') AND
    //            (vrc_CostCalculation."Voyage No." = '') THEN
    //             ERROR('Partienummer und Reisenummer nicht vorhanden!');


    //         // Werte in Buffer laden
    //         lcu_BatchMgt.LoadBatchNoInBuffer(vrc_CostCalculation."Master Batch No.",
    //                                          vrc_CostCalculation."Voyage No.",
    //                                          '', lrc_PurchaseHeader."No.", '');


    //         // Fenster zur Bearbeitung öffnen
    //         COMMIT;
    //         lrc_BatchTemp.RESET();
    //         lrc_BatchTemp.FILTERGROUP(2);
    //         lrc_BatchTemp.SETRANGE("Userid Code", UserID());
    //         lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
    //         lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
    //         lrc_BatchTemp.FILTERGROUP(0);
    //         lfm_FVPurchCostInvAllocation.LOOKUPMODE := TRUE;
    //         lfm_FVPurchCostInvAllocation.SETTABLEVIEW(lrc_BatchTemp);
    //         IF lfm_FVPurchCostInvAllocation.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT;
    //     end;

    //     procedure "-- PLAN COST --"()
    //     begin
    //     end;

    //     procedure _EnterDataAllocateCalcCost(vrc_CostCalculation: Record "POI Cost Calc. - Enter Data")
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_Batch: Record "POI Batch";
    //         lrc_BatchVariant: Record "POI Batch Variant";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalculationData: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalcDetailBatch: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalcDetailBatchVar: Record "POI Cost Calc. - Enter Data";
    //         "-": Integer;
    //         lcu_BatchMgt: Codeunit "POI BAM Batch Management";
    //         lrc_BatchTemp: Record "5110369";
    //         lrc_MasterBatchTemp: Record "5110369";
    //         lrc_PurchHeader: Record "Purchase Header";
    //         lrc_PurchLine: Record "Purchase Line";
    //         "--": Integer;
    //         ldc_SumAmount: Decimal;
    //         ldc_SumAmountMW: Decimal;
    //         ldc_Proz: Decimal;
    //         ldc_Amount: Decimal;
    //         ldc_AmountMW: Decimal;
    //         AGILES_LT_TEXT001: Label 'Herkunft nicht identifiziert!';
    //         AGILES_LT_TEXT002: Label 'Herkunft nicht zulässig!';
    //         AGILES_LT_TEXT003: Label 'Betrag kann nicht über Paletten verteilt werden!';
    //         AGILES_LT_TEXT004: Label 'Betrag kann nicht über Kolli verteilt werden!';
    //         AGILES_LT_TEXT005: Label 'Betrag kann nicht über Nettogewicht verteilt werden!';
    //         AGILES_LT_TEXT006: Label 'Betrag kann nicht über Bruttogewicht verteilt werden!';
    //         AGILES_LT_TEXT007: Label 'Betrag kann nicht über Anzahl Zeilen verteilt werden!';
    //         AGILES_LT_TEXT008: Label 'Betrag kann nicht über Gesamtbetrag verteilt werden!';
    //         AGILES_LT_TEXT009: Label 'Betrag kann nicht über Paletten auf die Positionsvarianten verteilt werden!';
    //         AGILES_LT_TEXT010: Label 'Betrag kann nicht über Kolli auf die Positionsvarianten verteilt werden!';
    //         AGILES_LT_TEXT011: Label 'Betrag kann nicht über Nettogewicht verteilt werden!';
    //         AGILES_LT_TEXT012: Label 'Herkunft nicht codiert %1!';
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Kalkulation und Umlage der Kosten
    //         // ----------------------------------------------------------------------------------------------

    //         /*--

    //         lrc_FruitVisionSetup.GET();
    //         IF lrc_FruitVisionSetup."Cost Category Calc. Type" <>
    //            lrc_FruitVisionSetup."Cost Category Calc. Type"::"Stand" THEN
    //           EXIT;


    //         // ---------------------------------------------------------------
    //         // Detailzeilen löschen
    //         // ---------------------------------------------------------------

    //         // Detailzeilen "Batch" löschen
    //         lrc_CostCalcDetailBatch.RESET();
    //         lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type","Master Batch No.","Cost Category Code");
    //         lrc_CostCalcDetailBatch.SETRANGE("Entry Type",lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
    //         lrc_CostCalcDetailBatch.SETRANGE("Master Batch No.",vco_MasterBatchNo);
    //         IF vco_CostCategoryCode <> '' THEN
    //           lrc_CostCalcDetailBatch.SETRANGE("Cost Category Code",vco_CostCategoryCode);
    //         lrc_CostCalcDetailBatch.DELETEALL();

    //         // Detailzeilen "Batch Variant" löschen
    //         lrc_CostCalcDetailBatchVar.RESET();
    //         lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type","Master Batch No.","Cost Category Code");
    //         lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type",lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batchvariant");
    //         lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.",vco_MasterBatchNo);
    //         IF vco_CostCategoryCode <> '' THEN
    //           lrc_CostCalcDetailBatchVar.SETRANGE("Cost Category Code",vco_CostCategoryCode);
    //         lrc_CostCalcDetailBatchVar.DELETEALL();


    //           // ---------------------------------------------------------------
    //           // Positionen und Gesamtmengen in Temp Tabelle laden
    //           // ---------------------------------------------------------------
    //           lrc_MasterBatch.GET(vco_MasterBatchNo);
    //           CASE lrc_MasterBatch.Source OF
    //           lrc_MasterBatch.Source::"Purch. Order":
    //             BEGIN
    //               // Einkaufskopf lesen
    //               IF lrc_PurchHeader.GET(lrc_PurchHeader."Document Type"::Order,lrc_MasterBatch."Source No.") THEN BEGIN
    //                 // Positionen und Gesamtmengen in Temp. Tabelle laden
    //                 lcu_BatchMgt.LoadBatchNoInBuffer(vco_MasterBatchNo,'','',lrc_PurchHeader);
    //                 // Werte in Einkaufszeilen auf Null Setzen
    //                 lrc_PurchLine.RESET();
    //                 lrc_PurchLine.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //                 lrc_PurchLine.SETRANGE("Document No.",lrc_PurchHeader."No.");
    //                 IF lrc_PurchLine.FIND('-') THEN BEGIN
    //                   lrc_PurchLine.MODIFYALL("Cost Calc. per Unit (LCY)",0);
    //                   lrc_PurchLine.MODIFYALL("Cost Calc. Amount (LCY)",0);
    //                 END;
    //               END;
    //             END;
    //           lrc_MasterBatch.Source::" ":
    //             BEGIN
    //               // Herkunft nicht identifiziert!
    //               ERROR(AGILES_LT_TEXT001);
    //             END;
    //           ELSE
    //             // Herkunft nicht zulässig!
    //             ERROR(AGILES_LT_TEXT002);
    //           END;

    //           // Gesamtsummensatz über Master Batch in Temp. Tabelle lesen
    //           lrc_MasterBatchTemp.SETRANGE(Type,lrc_MasterBatchTemp.Type::MCS);
    //           lrc_MasterBatchTemp.SETRANGE("Userid Code",UserID());
    //           lrc_MasterBatchTemp.SETRANGE("MCS Batch No.",'');
    //           lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.",vco_MasterBatchNo);
    //           lrc_MasterBatchTemp.FIND('-');

    //           // Schleife um die Kostenkategorien innerhalb der Partienummer
    //           lrc_CostCalculation.RESET();
    //           lrc_CostCalculation.SETCURRENTKEY("Entry Type","Master Batch No.","Cost Category Code");
    //           lrc_CostCalculation.SETRANGE("Master Batch No.",vco_MasterBatchNo);
    //           IF vco_CostCategoryCode <> '' THEN
    //             lrc_CostCalculation.SETRANGE("Cost Category Code",vco_CostCategoryCode);
    //           lrc_CostCalculation.SETRANGE("Entry Type",lrc_CostCalculation."Entry Type"::"Cost Category");
    //           IF lrc_CostCalculation.FIND('-') THEN
    //             REPEAT

    //               // --------------------------------------------------------------------------------------
    //               // Von Enter Data auf Detail Batch verteilen
    //               // --------------------------------------------------------------------------------------
    //               lrc_CostCalculationData.RESET();
    //               lrc_CostCalculationData.SETCURRENTKEY("Entry Type","Master Batch No.","Cost Category Code");
    //               lrc_CostCalculationData.SETRANGE("Master Batch No.",lrc_CostCalculation."Master Batch No.");
    //               lrc_CostCalculationData.SETRANGE("Cost Category Code",lrc_CostCalculation."Cost Category Code");
    //               lrc_CostCalculationData.SETRANGE("Entry Type",lrc_CostCalculationData."Entry Type"::"Enter Data");
    //               IF lrc_CostCalculationData.FIND('-') THEN
    //                 REPEAT

    //                   // Verteilung auf die Positionen
    //                   IF lrc_CostCalculationData."Batch No." = '' THEN BEGIN

    //                     ldc_SumAmount := 0;
    //                     ldc_SumAmountMW := 0;

    //                     // Schleife um alle Positionen
    //                     lrc_BatchTemp.RESET();
    //                     lrc_BatchTemp.SETRANGE(Type,lrc_MasterBatchTemp.Type::MCS);
    //                     lrc_BatchTemp.SETRANGE("Userid Code",UserID());
    //                     lrc_BatchTemp.SETFILTER("MCS Batch No.",'<>%1','');
    //                     lrc_BatchTemp.SETRANGE("MCS Master Batch No.",vco_MasterBatchNo);
    //                     IF lrc_BatchTemp.FIND('-') THEN BEGIN
    //                       REPEAT

    //                         CASE lrc_CostCalculationData."Allocation Type" OF
    //                         lrc_CostCalculationData."Allocation Type"::Pallets:
    //                           BEGIN
    //                             IF lrc_MasterBatchTemp."MCS Quantity Pallets" = 0 THEN
    //                               // Betrag kann nicht über Paletten verteilt werden!
    //                               ERROR(AGILES_LT_TEXT003);
    //                             ldc_Proz := lrc_BatchTemp."MCS Quantity Pallets" / lrc_MasterBatchTemp."MCS Quantity Pallets";
    //                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalculationData."Allocation Type"::Kolli:
    //                           BEGIN
    //                             IF lrc_MasterBatchTemp."MCS Quantity Colli" = 0 THEN
    //                               // Betrag kann nicht über Kolli verteilt werden!
    //                               ERROR(AGILES_LT_TEXT004);
    //                             ldc_Proz := lrc_BatchTemp."MCS Quantity Colli" / lrc_MasterBatchTemp."MCS Quantity Colli";
    //                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor",0.01);
    //                            END;

    //                         lrc_CostCalculationData."Allocation Type"::"Net Weight":
    //                           BEGIN
    //                             IF lrc_MasterBatchTemp."MCS Nettogewicht" = 0 THEN
    //                               // Betrag kann nicht über Nettogewicht verteilt werden!
    //                               ERROR(AGILES_LT_TEXT005);
    //                             ldc_Proz := lrc_BatchTemp."MCS Nettogewicht" / lrc_MasterBatchTemp."MCS Nettogewicht";
    //                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalculationData."Allocation Type"::"Gross Weight":
    //                           BEGIN
    //                             IF lrc_MasterBatchTemp."MCS Bruttogewicht" = 0 THEN
    //                               // Betrag kann nicht über Bruttogewicht verteilt werden!
    //                               ERROR(AGILES_LT_TEXT006);
    //                             ldc_Proz := lrc_BatchTemp."MCS Bruttogewicht" / lrc_MasterBatchTemp."MCS Bruttogewicht";
    //                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalculationData."Allocation Type"::Lines:
    //                           BEGIN
    //                             IF lrc_MasterBatchTemp."MCS No. of Lines" = 0 THEN
    //                               // Betrag kann nicht über Anzahl Zeilen verteilt werden!
    //                               ERROR(AGILES_LT_TEXT007);
    //                             ldc_Proz := lrc_BatchTemp."MCS No. of Lines" / lrc_MasterBatchTemp."MCS No. of Lines";
    //                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalculationData."Allocation Type"::Amount:
    //                           BEGIN
    //                             IF lrc_MasterBatchTemp."MCS Total Amount" = 0 THEN
    //                               // Betrag kann nicht über Gesamtbetrag verteilt werden!
    //                               ERROR(AGILES_LT_TEXT008);
    //                             ldc_Proz := lrc_BatchTemp."MCS Total Amount" / lrc_MasterBatchTemp."MCS Total Amount";
    //                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor",0.01);
    //                           END;
    //                         END;

    //                         // Detailzeile Batch einfügen
    //                         lrc_CostCalcDetailBatch.RESET();
    //                         lrc_CostCalcDetailBatch := lrc_CostCalculationData;
    //                         lrc_CostCalcDetailBatch."Entry No." := 0;
    //                         lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
    //                         lrc_CostCalcDetailBatch."Batch No." := lrc_BatchTemp."MCS Batch No.";
    //                         lrc_CostCalcDetailBatch.VALIDATE(Amount,ldc_Amount);
    //                         lrc_CostCalcDetailBatch."Attached to Entry No." := lrc_CostCalculationData."Entry No.";
    //                         lrc_CostCalcDetailBatch."Attached to Doc. No." := lrc_CostCalculationData."Document No.";
    //                         lrc_CostCalcDetailBatch."Attached Entry Subtype" := lrc_CostCalculationData."Entry Subtype";

    //                         lrc_CostCalcDetailBatch.INSERT(TRUE);

    //                         ldc_SumAmount := ldc_SumAmount + ldc_Amount;
    //                         ldc_SumAmountMW := ldc_SumAmountMW + ldc_AmountMW;

    //                       UNTIL lrc_BatchTemp.NEXT() = 0;

    //                       // Kontrolle ob verteilter Betrag dem Gesamtbetrag entspricht
    //                       // Differenz auf letzte Zeile übertragen
    //                       IF ldc_SumAmount <> lrc_CostCalculationData.Amount THEN BEGIN
    //                         IF lrc_CostCalcDetailBatch."Entry No." <> 0 THEN BEGIN
    //                           ldc_SumAmount := lrc_CostCalculationData.Amount - ldc_SumAmount;
    //                           ldc_SumAmountMW := lrc_CostCalculationData."Amount (LCY)" - ldc_SumAmountMW;
    //                           lrc_CostCalcDetailBatch.VALIDATE(Amount,(lrc_BatchCostCalcLine.Amount + ldc_SumAmount));
    //                           lrc_CostCalcDetailBatch.MODIFY();
    //                         END;
    //                       END;

    //                     END;
    //                   END ELSE BEGIN

    //                     lrc_CostCalcDetailBatch.RESET();
    //                     lrc_CostCalcDetailBatch := lrc_CostCalculationData;

    //                     lrc_CostCalcDetailBatch."Entry No." := 0;
    //                     lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
    //                     lrc_CostCalcDetailBatch."Attached to Entry No." := lrc_CostCalculationData."Entry No.";
    //                     lrc_CostCalcDetailBatch."Attached to Doc. No." := lrc_CostCalculationData."Document No.";
    //                     lrc_CostCalcDetailBatch."Attached Entry Subtype" := lrc_CostCalculationData."Entry Subtype";

    //                     lrc_CostCalcDetailBatch.INSERT(TRUE);

    //                   END;

    //                   // SFR 02.07.2007 die folgenden beiden Zeilen sind wichtig auf einem SQL - Server
    //                   IF lrc_CostCalculationData.RECORDLEVELLOCKING() THEN
    //                     COMMIT;

    //                 UNTIL lrc_CostCalculationData.NEXT() = 0;


    //               // --------------------------------------------------------------------------------------
    //               // Einkaufszeile lesen und Werte zurücksetzen
    //               // --------------------------------------------------------------------------------------
    //               lrc_PurchLine.RESET();
    //               lrc_PurchLine.SETCURRENTKEY( "Document Type",Type,"Master Batch No.","Batch No.","Batch Variant No." );
    //               lrc_PurchLine.SETRANGE("Document Type",lrc_PurchLine."Document Type"::Order);
    //               lrc_PurchLine.SETRANGE(Type,lrc_PurchLine.Type::Item);
    //               lrc_PurchLine.SETRANGE("Master Batch No.",vco_MasterBatchNo);
    //               IF lrc_PurchLine.FIND('-') THEN
    //                 REPEAT
    //                   lrc_PurchLine."Cost Calc. per Unit (LCY)" := 0;
    //                   lrc_PurchLine."Cost Calc. Amount (LCY)" := 0;
    //                   lrc_PurchLine.MODIFY();
    //                 UNTIL lrc_PurchLine.NEXT() = 0;


    //               // --------------------------------------------------------------------------------------
    //               // Von Detail Batch auf Detail Batch Variant verteilen
    //               // --------------------------------------------------------------------------------------
    //               lrc_CostCalcDetailBatch.RESET();
    //               lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type","Master Batch No.","Cost Category Code");
    //               lrc_CostCalcDetailBatch.SETRANGE("Master Batch No.",lrc_CostCalculation."Master Batch No.");
    //               lrc_CostCalcDetailBatch.SETRANGE("Cost Category Code",lrc_CostCalculation."Cost Category Code");
    //               lrc_CostCalcDetailBatch.SETRANGE("Entry Type",lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
    //               IF lrc_CostCalcDetailBatch.FIND('-') THEN
    //                 REPEAT

    //                   lrc_CostCalcDetailBatch.TESTFIELD("Batch No.");

    //                   // Summensatz Position lesen
    //                   lrc_BatchTemp.RESET();
    //                   lrc_BatchTemp.SETRANGE(Type,lrc_MasterBatchTemp.Type::MCS);
    //                   lrc_BatchTemp.SETRANGE("Userid Code",UserID());
    //                   lrc_BatchTemp.SETRANGE("MCS Batch No.",lrc_CostCalcDetailBatch."Batch No.");
    //                   lrc_BatchTemp.SETRANGE("MCS Master Batch No.",lrc_CostCalcDetailBatch."Master Batch No.");
    //                   lrc_BatchTemp.FIND('-');

    //                   // Schleife um die Positionsvarianten der Position
    //                   lrc_BatchVariant.RESET();
    //                   lrc_BatchVariant.SETCURRENTKEY("Master Batch No.","Batch No.");
    //                   lrc_BatchVariant.SETRANGE("Master Batch No.",lrc_CostCalcDetailBatch."Master Batch No.");
    //                   lrc_BatchVariant.SETRANGE("Batch No.",lrc_CostCalcDetailBatch."Batch No.");
    //                   IF lrc_BatchVariant.FIND('-') THEN
    //                     REPEAT

    //                       // Einkaufszeile lesen
    //                       lrc_PurchLine.RESET();
    //                       lrc_PurchLine.SETCURRENTKEY( "Document Type",Type,"Master Batch No.","Batch No.","Batch Variant No." );
    //                       lrc_PurchLine.SETRANGE("Document Type",lrc_PurchLine."Document Type"::Order);
    //                       lrc_PurchLine.SETRANGE(Type,lrc_PurchLine.Type::Item);
    //                       lrc_PurchLine.SETRANGE("Master Batch No.",lrc_BatchVariant."Master Batch No.");
    //                       lrc_PurchLine.SETRANGE("Batch No.",lrc_BatchVariant."Batch No.");
    //                       lrc_PurchLine.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //                       lrc_PurchLine.SETFILTER(Quantity,'<>%1',0);
    //                       IF lrc_PurchLine.FIND('-') THEN BEGIN

    //                         ldc_Proz := 0;
    //                         ldc_Amount := 0;
    //                         ldc_AmountMW := 0;

    //                         CASE lrc_CostCalcDetailBatch."Allocation Type" OF
    //                         lrc_CostCalcDetailBatch."Allocation Type"::Pallets:
    //                           BEGIN
    //                             IF lrc_BatchTemp."MCS Quantity Pallets" = 0 THEN
    //                               // Betrag kann nicht über Paletten auf die Positionsvarianten verteilt werden!
    //                               ERROR(AGILES_LT_TEXT009);
    //                             IF lrc_PurchLine."Quantity (TU)" <> 0 THEN BEGIN
    //                               ldc_Proz := lrc_PurchLine."Quantity (TU)" / lrc_BatchTemp."MCS Quantity Pallets";
    //                               ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz,0.01);
    //                             END ELSE BEGIN
    //                               ldc_Amount := lrc_CostCalcDetailBatch.Amount;
    //                             END;
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalcDetailBatch."Allocation Type"::Kolli:
    //                           BEGIN
    //                             IF lrc_BatchTemp."MCS Quantity Colli" = 0 THEN
    //                               // Betrag kann nicht über Kolli auf die Positionsvarianten verteilt werden!
    //                               ERROR(AGILES_LT_TEXT010);
    //                             ldc_Proz := lrc_PurchLine.Quantity / lrc_BatchTemp."MCS Quantity Colli";
    //                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalcDetailBatch."Allocation Type"::"Net Weight":
    //                           BEGIN
    //                             IF lrc_BatchTemp."MCS Nettogewicht" = 0 THEN
    //                               // Betrag kann nicht über Nettogewicht verteilt werden!
    //                               ERROR(AGILES_LT_TEXT011);
    //                             ldc_Proz := lrc_PurchLine."Total Net Weight" / lrc_BatchTemp."MCS Nettogewicht";
    //                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalcDetailBatch."Allocation Type"::"Gross Weight":
    //                           BEGIN
    //                             IF lrc_BatchTemp."MCS Bruttogewicht" = 0 THEN
    //                               // Betrag kann nicht über Bruttogewicht verteilt werden!
    //                               ERROR(AGILES_LT_TEXT006);
    //                             ldc_Proz := lrc_PurchLine."Total Gross Weight" / lrc_BatchTemp."MCS Bruttogewicht";
    //                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalcDetailBatch."Allocation Type"::Lines:
    //                           BEGIN
    //                             IF lrc_BatchTemp."MCS No. of Lines" = 0 THEN
    //                               // Betrag kann nicht über Anzahl Zeilen verteilt werden!
    //                               ERROR(AGILES_LT_TEXT007);
    //                             ldc_Proz := 1 / lrc_BatchTemp."MCS No. of Lines";
    //                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor",0.01);
    //                           END;

    //                         lrc_CostCalcDetailBatch."Allocation Type"::Amount:
    //                           BEGIN
    //                             IF lrc_BatchTemp."MCS Total Amount" = 0 THEN
    //                               // Betrag kann nicht über Gesamtbetrag verteilt werden!
    //                               ERROR(AGILES_LT_TEXT008);
    //                             ldc_Proz := lrc_PurchLine.Amount / lrc_BatchTemp."MCS Total Amount";
    //                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz,0.01);
    //                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor",0.01);
    //                           END;

    //                         END;

    //                         // Detailzeile Batch einfügen
    //                         lrc_CostCalcDetailBatchVar.RESET();
    //                         lrc_CostCalcDetailBatchVar.INIT();
    //                         lrc_CostCalcDetailBatchVar := lrc_CostCalcDetailBatch;
    //                         lrc_CostCalcDetailBatchVar."Entry No." := 0;
    //                         lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batchvariant";
    //                         lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_BatchVariant."No.";
    //                         lrc_CostCalcDetailBatchVar.VALIDATE(Amount,ldc_Amount);
    //                         lrc_CostCalcDetailBatchVar."Attached to Entry No." := lrc_CostCalcDetailBatch."Entry No.";
    //                         lrc_CostCalcDetailBatchVar."Attached to Doc. No." := lrc_CostCalcDetailBatch."Document No.";
    //                         lrc_CostCalcDetailBatchVar."Attached Entry Subtype" := lrc_CostCalcDetailBatch."Entry Subtype";

    //                         lrc_CostCalcDetailBatchVar.INSERT(TRUE);

    //                       END ELSE BEGIN

    //                         // Detailzeile Batch einfügen
    //                         lrc_CostCalcDetailBatchVar.RESET();
    //                         lrc_CostCalcDetailBatchVar.INIT();
    //                         lrc_CostCalcDetailBatchVar := lrc_CostCalcDetailBatch;
    //                         lrc_CostCalcDetailBatchVar."Entry No." := 0;
    //                         lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batchvariant";
    //                         lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_BatchVariant."No.";
    //                         //lrc_CostCalcDetailBatchVar.VALIDATE(Amount,ldc_Amount);
    //                         lrc_CostCalcDetailBatchVar."Attached to Entry No." := lrc_CostCalcDetailBatch."Entry No.";
    //                         lrc_CostCalcDetailBatchVar."Attached to Doc. No." := lrc_CostCalcDetailBatch."Document No.";
    //                         lrc_CostCalcDetailBatchVar."Attached Entry Subtype" := lrc_CostCalcDetailBatch."Entry Subtype";
    //                         lrc_CostCalcDetailBatchVar.INSERT(TRUE);

    //                       END;

    //                     UNTIL lrc_BatchVariant.NEXT() = 0;

    //                   // Reste der letzten Positionsvariante zuordnen



    //                 UNTIL lrc_CostCalcDetailBatch.NEXT() = 0;

    //             UNTIL lrc_CostCalculation.NEXT() = 0;


    //           // -----------------------------------------------------------------
    //           // Kosten in die Herkunftszeilen übertragen
    //           // -----------------------------------------------------------------
    //           CASE lrc_MasterBatch.Source OF
    //           lrc_MasterBatch.Source::"Purch. Order":
    //             BEGIN
    //               // Einkaufskopf lesen
    //               IF lrc_PurchHeader.GET(lrc_PurchHeader."Document Type"::Order,lrc_MasterBatch."Source No.") THEN BEGIN

    //                 lrc_PurchLine.RESET();
    //                 lrc_PurchLine.SETCURRENTKEY( "Document Type",Type,"Master Batch No.","Batch No.","Batch Variant No." );
    //                 lrc_PurchLine.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //                 lrc_PurchLine.SETRANGE("Document No.",lrc_PurchHeader."No.");
    //                 lrc_PurchLine.SETRANGE(Type,lrc_PurchLine.Type::Item);
    //                 lrc_PurchLine.SETFILTER("No.",'<>%1','');
    //                 lrc_PurchLine.SETFILTER("Batch Variant No.",'<>%1','');
    //                 IF lrc_PurchLine.FIND('-') THEN BEGIN
    //                   REPEAT

    //                     // Werte auf Null setzen
    //                     lrc_PurchLine."Cost Calc. Amount (LCY)" := 0;
    //                     lrc_PurchLine."Cost Calc. per Unit (LCY)" := 0;
    //                     lrc_PurchLine."Indirect Cost Amount (LCY)" := 0;

    //                     lrc_CostCalcDetailBatchVar.RESET();
    //                     lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type","Master Batch No.","Batch No.","Batch Variant No.","Vendor No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.",lrc_PurchLine."Master Batch No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.",lrc_PurchLine."Batch No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.",lrc_PurchLine."Batch Variant No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type",lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batchvariant");
    //                     IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
    //                       REPEAT
    //                         // Alle Kosten aufaddieren
    //                         lrc_PurchLine."Cost Calc. Amount (LCY)" := lrc_PurchLine."Cost Calc. Amount (LCY)" +
    //                                                                    lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                         // Indirekte Kosten aufaddieren
    //                         IF lrc_CostCalcDetailBatchVar."Indirect Cost (Purchase)" = TRUE THEN
    //                           lrc_PurchLine."Indirect Cost Amount (LCY)" := lrc_PurchLine."Indirect Cost Amount (LCY)" +
    //                                                                         lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                       UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;

    //                     IF lrc_PurchLine.Quantity <> 0 THEN
    //                       lrc_PurchLine."Cost Calc. per Unit (LCY)" := ROUND(lrc_PurchLine."Cost Calc. Amount (LCY)" /
    //                                                                          lrc_PurchLine.Quantity,0.00001);

    //                     // FV START 131107
    //                     lrc_PurchLine.UpdateUnitCost;
    //                     // FV ENDE

    //                     lrc_PurchLine.MODIFY();

    //                     // Werte in die Batch Variant schreiben
    //                     IF lrc_BatchVariant.GET(lrc_PurchLine."Batch Variant No.") THEN BEGIN
    //                       lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                       lrc_BatchVariant."Cost Calc. per Unit (LCY)" := lrc_PurchLine."Cost Calc. per Unit (LCY)";
    //                       // Indirekte Kosten
    //                       lrc_BatchVariant.MODIFY();
    //                     END;

    //                   UNTIL lrc_PurchLine.NEXT() = 0;
    //                 END;

    //               // Werte nur in Positionsvariante schreiben, da Einkauf nicht mehr vorhanden
    //               END ELSE BEGIN

    //                 lrc_BatchVariant.RESET();
    //                 lrc_BatchVariant.SETRANGE("Master Batch No.",lrc_MasterBatch."No.");
    //                 IF lrc_BatchVariant.FIND('-') THEN
    //                   REPEAT

    //                     lrc_BatchVariant.CALCFIELDS("B.V. Purch. Rec. (Qty)","B.V. Purch. Order (Qty)");

    //                     // Werte zurücksetzen
    //                     lrc_BatchVariant."Cost Calc. Amount (LCY)" := 0;
    //                     lrc_BatchVariant."Cost Calc. per Unit (LCY)" := 0;

    //                     lrc_CostCalcDetailBatchVar.RESET();
    //                     lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type","Master Batch No.","Batch No.",
    //                                                              "Batch Variant No.","Vendor No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.",lrc_BatchVariant."Master Batch No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.",lrc_BatchVariant."Batch No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type",lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batchvariant");
    //                     IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
    //                       REPEAT
    //                         lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" +
    //                                                                       lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                       UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;

    //                     IF (lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") <> 0 THEN
    //                       lrc_BatchVariant."Cost Calc. per Unit (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" /
    //                         ((lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") /
    //                          lrc_BatchVariant."Qty. per Unit of Measure");

    //                     lrc_BatchVariant.MODIFY();

    //                   UNTIL lrc_BatchVariant.NEXT() = 0;
    //               END;
    //             END;

    //           lrc_MasterBatch.Source::" ":
    //             BEGIN
    //               // Herkunft nicht identifiziert!
    //               ERROR(AGILES_LT_TEXT001);
    //             END;
    //           ELSE
    //             // Herkunft nicht codiert %1!
    //             ERROR(AGILES_LT_TEXT001, FORMAT(lrc_MasterBatch.Source));
    //           END;


    //         --*/

    //     end;

    //     procedure _AllocatePlanCostToBatch(vrc_CostCalculation: Record "POI Cost Calc. - Enter Data")
    //     var
    //         lcu_BatchMgt: Codeunit "POI BAM Batch Management";
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_BatchTemp: Record "5110369";
    //         lrc_PurchaseLine: Record "Purchase Line";
    //         lrc_NewCostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalcAllocBatch: Record "5110554";
    //         lrc_Batch: Record "POI Batch";
    //         lrc_CostCategory: Record "POI Cost Category";
    //         lrc_CostCategoryAllocation: Record "5110553";
    //         //lfm_FHKostenverteilungPartien: Form "5110564";
    //         lbn_FirstLoop: Boolean;
    //         lin_LineNo: Integer;
    //         ldc_GesMgeKolli: Decimal;
    //         ldc_GesMgePaletten: Decimal;
    //         ldc_GesMgeBruttogewicht: Decimal;
    //         ldc_GesMgeNettogewicht: Decimal;
    //         ldc_GesMgeZeilen: Decimal;
    //         ldc_BetragsAnteil: Decimal;
    //         ldc_SummeBetragsAnteil: Decimal;
    //         AGILES_LT_TEXT002: Label 'Der Zeile ist bereits eine Position zugeordnet!';
    //         AGILES_LT_TEXT003: Label 'Keine gültigen Verteilungsschlüssel vorhanden!';
    //         AGILES_LT_TEXT004: Label 'Reisenummer oder Partienummer muss angegeben sein!';
    //         AGILES_LT_TEXT005: Label 'Verteilungsart %1 nicht codiert!';
    //         AGILES_LT_TEXT006: Label 'Reisenummer und Partienummer nicht gefüllt!';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Kostenverteilung für eine Eingabezeile Plankosten
    //         // -------------------------------------------------------------------------------------

    //         IF vrc_CostCalculation."Batch No." <> '' THEN
    //             // Der Zeile ist bereits eine Position zugeordnet!
    //             ERROR(AGILES_LT_TEXT002);

    //         // Kontrolle ob bestimmte Werte gefüllt sind
    //         IF (vrc_CostCalculation."Master Batch No." = '') AND
    //            (vrc_CostCalculation."Voyage No." = '') THEN
    //             // Reisenummer oder Partienummer muss angegeben sein!
    //             ERROR(AGILES_LT_TEXT004);

    //         vrc_CostCalculation.TESTFIELD("Cost Category Code");
    //         vrc_CostCalculation.TESTFIELD("Document No. 2");
    //         vrc_CostCalculation.TESTFIELD("Document No.");

    //         // Einrichtungen lesen
    //         lrc_FruitVisionSetup.GET();
    //         lrc_BatchSetup.GET();

    //         CASE vrc_CostCalculation."Allocation Level" OF
    //             vrc_CostCalculation."Allocation Level"::"Voyage No.":
    //                 lcu_BatchMgt.LoadBatchNoInBuffer('', vrc_CostCalculation."Voyage No.", '', '', '');
    //             vrc_CostCalculation."Allocation Level"::"Master Batch No.":
    //                 lcu_BatchMgt.LoadBatchNoInBuffer(vrc_CostCalculation."Master Batch No.", '', '', '', '');
    //         END;

    //         lrc_CostCategory.GET(vrc_CostCalculation."Cost Category Code");

    //         lrc_BatchTemp.RESET();
    //         lrc_BatchTemp.SETRANGE("Userid Code", UserID());
    //         lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
    //         lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
    //         IF lrc_BatchTemp.FIND('-') THEN BEGIN
    //             REPEAT

    //                 lrc_Batch.GET(lrc_BatchTemp."MCS Batch No.");

    //                 lrc_CostCategoryAllocation.RESET();
    //                 lrc_CostCategoryAllocation.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                 lrc_CostCategoryAllocation.SETRANGE("Product Group Code", lrc_Batch."Product Group Code");
    //                 IF lrc_CostCategoryAllocation.FIND('-') THEN BEGIN
    //                     CASE lrc_CostCategoryAllocation."Allocation Type" OF
    //                         lrc_CostCategoryAllocation."Allocation Type"::Pallets:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Kolli;
    //                         lrc_CostCategoryAllocation."Allocation Type"::Kolli:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Pallets;
    //                         lrc_CostCategoryAllocation."Allocation Type"::"Net Weight":
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Lines;
    //                         lrc_CostCategoryAllocation."Allocation Type"::"Gross Weight":
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::"Net Weight";
    //                         lrc_CostCategoryAllocation."Allocation Type"::Lines:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::"Gross Weight";
    //                         lrc_CostCategoryAllocation."Allocation Type"::Amount:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Amount;
    //                     END;
    //                 END ELSE BEGIN
    //                     CASE lrc_CostCategory."Allocation Type" OF
    //                         lrc_CostCategory."Allocation Type"::Pallets:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Kolli;
    //                         lrc_CostCategory."Allocation Type"::Kolli:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Pallets;
    //                         lrc_CostCategory."Allocation Type"::"Net Weight":
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Lines;
    //                         lrc_CostCategory."Allocation Type"::"Gross Weight":
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::"Net Weight";
    //                         lrc_CostCategory."Allocation Type"::Lines:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::"Gross Weight";
    //                         lrc_CostCategory."Allocation Type"::Amount:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Amount;
    //                     END;
    //                 END;

    //                 // Kontrolle ob es bereits eine Belegung gibt
    //                 lrc_CostCalcAllocBatch.RESET();
    //                 lrc_CostCalcAllocBatch.SETRANGE("Document No.", vrc_CostCalculation."Document No.");
    //                 lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", vrc_CostCalculation."Document No. 2");
    //                 lrc_CostCalcAllocBatch.SETRANGE("Batch No.", lrc_BatchTemp."MCS Batch No.");
    //                 IF lrc_CostCalcAllocBatch.FIND('-') THEN BEGIN
    //                     lrc_BatchTemp."MCS Without Allocation" := lrc_CostCalcAllocBatch."Without Allocation";
    //                     lrc_BatchTemp."MCS Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key";
    //                 END;

    //                 lrc_BatchTemp.MODIFY();
    //             UNTIL lrc_BatchTemp.NEXT() = 0;
    //         END;

    //         // Fenster zur Bearbeitung öffnen
    //         COMMIT;
    //         lrc_BatchTemp.RESET();
    //         lrc_BatchTemp.FILTERGROUP(2);
    //         lrc_BatchTemp.SETRANGE("Userid Code", UserID());
    //         lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
    //         lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
    //         lrc_BatchTemp.FILTERGROUP(0);
    //         lfm_FHKostenverteilungPartien.LOOKUPMODE := TRUE;
    //         lfm_FHKostenverteilungPartien.SETTABLEVIEW(lrc_BatchTemp);
    //         IF lfm_FHKostenverteilungPartien.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT;

    //         COMMIT;

    //         // Bestehende Zuordnungen löschen
    //         lrc_CostCalcAllocBatch.RESET();
    //         lrc_CostCalcAllocBatch.SETRANGE("Document No.", vrc_CostCalculation."Document No.");
    //         lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", vrc_CostCalculation."Document No. 2");
    //         lrc_CostCalcAllocBatch.DELETEALL();


    //         // Ergebnis übertragen
    //         lrc_BatchTemp.RESET();
    //         lrc_BatchTemp.SETRANGE("Userid Code", UserID());
    //         lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
    //         lrc_BatchTemp.SETFILTER("MCS Allocation Key", '<>%1', lrc_BatchTemp."MCS Allocation Key"::" ");
    //         lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
    //         IF lrc_BatchTemp.FIND('-') THEN BEGIN
    //             REPEAT
    //                 // Verteilungssatz einfügen
    //                 lrc_CostCalcAllocBatch.RESET();
    //                 lrc_CostCalcAllocBatch.INIT();
    //                 lrc_CostCalcAllocBatch."Document No." := vrc_CostCalculation."Document No.";
    //                 lrc_CostCalcAllocBatch."Document No. 2" := vrc_CostCalculation."Document No. 2";
    //                 lrc_CostCalcAllocBatch."Batch No." := lrc_BatchTemp."MCS Batch No.";
    //                 lrc_CostCalcAllocBatch."Master Batch No." := lrc_BatchTemp."MCS Master Batch No.";
    //                 lrc_CostCalcAllocBatch."Without Allocation" := lrc_BatchTemp."MCS Without Allocation";
    //                 lrc_CostCalcAllocBatch."Allocation Key" := lrc_BatchTemp."MCS Allocation Key";
    //                 lrc_CostCalcAllocBatch.insert();
    //             UNTIL lrc_BatchTemp.NEXT() = 0;
    //         END ELSE BEGIN
    //             // Keine gültigen Verteilungsschlüssel vorhanden!
    //             ERROR(AGILES_LT_TEXT003);
    //         END;
    //     end;

    //     procedure _EnterDataDeleteAttachedLines(vin_EntryNo: Integer)
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalculationAttached: Record "POI Cost Calc. - Enter Data";
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Funktion zum Löschen von anhängenden Zeilen
    //         // ----------------------------------------------------------------------------------

    //         lrc_CostCalculation.GET(vin_EntryNo);
    //         IF lrc_CostCalculation."Entry Type" <> lrc_CostCalculation."Entry Type"::"Enter Data" THEN
    //             EXIT;

    //         lrc_CostCalculationAttached.RESET();
    //         lrc_CostCalculationAttached.SETRANGE("Cost Category Code", lrc_CostCalculation."Cost Category Code");
    //         lrc_CostCalculationAttached.SETFILTER("Entry Type", '%1|%2',
    //                                               lrc_CostCalculationAttached."Entry Type"::"Detail Batch",
    //                                               lrc_CostCalculationAttached."Entry Type"::"Detail Batch Variant");
    //         lrc_CostCalculationAttached.SETRANGE("Attached to Entry No.", lrc_CostCalculation."Document No.");
    //         lrc_CostCalculationAttached.SETRANGE("Document No. 2", lrc_CostCalculation."Document No. 2");
    //         lrc_CostCalculationAttached.DELETEALL();
    //     end;

    //     procedure _EnterDataDeletAttachAlocBatch(vin_EntryNo: Integer)
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalcAllocBatch: Record "5110554";
    //     begin
    //         // ----------------------------------------------------------------------------------
    //         // Funktion zum Löschen zugeordneten Batchzeilen
    //         // ----------------------------------------------------------------------------------


    //         lrc_CostCalculation.GET(vin_EntryNo);
    //         IF lrc_CostCalculation."Entry Type" <> lrc_CostCalculation."Entry Type"::"Enter Data" THEN
    //             EXIT;

    //         lrc_CostCalcAllocBatch.RESET();
    //         lrc_CostCalcAllocBatch.SETRANGE("Document No.", lrc_CostCalculation."Document No.");
    //         lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", lrc_CostCalculation."Document No. 2");
    //         lrc_CostCalcAllocBatch.DELETEALL();
    //     end;

    procedure _RecalcBatchTmpAttachAlocBatch(vin_EntryNo: Integer)
    var
        lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    begin
        // ----------------------------------------------------------------------------------
        // Funktion zum Löschen der Positionen aus der BatchTemp die bei der Umverteilung nicht berücksichtig werden sollen
        // ----------------------------------------------------------------------------------


        lrc_CostCalculation.GET(vin_EntryNo);
        IF lrc_CostCalculation."Entry Type" <> lrc_CostCalculation."Entry Type"::"Enter Data" THEN
            EXIT;

        lrc_BatchTemp.RESET();
        lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
        lrc_BatchTemp.SETRANGE("Userid Code", USERID());
        lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
        IF lrc_BatchTemp.FIND('-') THEN
            REPEAT
                lrc_CostCalcAllocBatch.RESET();
                lrc_CostCalcAllocBatch.SETRANGE("Document No.", lrc_CostCalculation."Document No.");
                lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", lrc_CostCalculation."Document No. 2");
                lrc_CostCalcAllocBatch.SETRANGE("Batch No.", lrc_BatchTemp."MCS Batch No.");
                IF lrc_CostCalcAllocBatch.FIND('-') THEN BEGIN
                    lrc_BatchTemp."MCS Without Allocation" := lrc_CostCalcAllocBatch."Without Allocation";
                    lrc_BatchTemp."MCS Allocation Key" := lrc_CostCalcAllocBatch."Allocation Key";
                    lrc_BatchTemp.MODIFY();
                END ELSE BEGIN
                    lrc_BatchTemp."MCS Without Allocation" := TRUE;
                    lrc_BatchTemp.MODIFY();
                END;
            UNTIL lrc_BatchTemp.NEXT() = 0;


        // Summensätze auf Null setzen
        lrc_MasterBatchTemp.RESET();
        lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
        lrc_MasterBatchTemp.SETRANGE("Userid Code", USERID());
        lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
        IF lrc_MasterBatchTemp.FIND('-') THEN
            REPEAT
                lrc_MasterBatchTemp."MCS Total Amount" := 0;
                lrc_MasterBatchTemp."MCS Quantity Colli" := 0;
                lrc_MasterBatchTemp."MCS Quantity Pallets" := 0;
                lrc_MasterBatchTemp."MCS Quantity Packings" := 0;
                lrc_MasterBatchTemp."MCS Gross Weight" := 0;
                lrc_MasterBatchTemp."MCS Net Weight" := 0;
                lrc_MasterBatchTemp."MCS No. of Lines" := 0;
                lrc_MasterBatchTemp.MODIFY();
            UNTIL lrc_MasterBatchTemp.NEXT() = 0;

        // Summen berechnen für Reisenummer und Partienummer/n
        lrc_BatchTemp.RESET();
        lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
        lrc_BatchTemp.SETRANGE("Userid Code", USERID());
        lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
        IF lrc_BatchTemp.FIND('-') THEN
            REPEAT
                IF lrc_BatchTemp."MCS Without Allocation" = FALSE THEN BEGIN
                    IF lrc_BatchTemp."MCS Voyage No." <> '' THEN BEGIN
                        lrc_MasterBatchTemp.RESET();
                        lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                        lrc_MasterBatchTemp.SETRANGE("Userid Code", USERID());
                        lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", '');
                        lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", lrc_BatchTemp."MCS Voyage No.");
                        lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
                        lrc_MasterBatchTemp.FIND('-');
                        lrc_MasterBatchTemp."MCS Total Amount" := lrc_MasterBatchTemp."MCS Total Amount" +
                                                                  lrc_BatchTemp."MCS Total Amount";
                        lrc_MasterBatchTemp."MCS Quantity Colli" := lrc_MasterBatchTemp."MCS Quantity Colli" +
                                                                    lrc_BatchTemp."MCS Quantity Colli";
                        lrc_MasterBatchTemp."MCS Quantity Pallets" := lrc_MasterBatchTemp."MCS Quantity Pallets" +
                                                                      lrc_BatchTemp."MCS Quantity Pallets";
                        lrc_MasterBatchTemp."MCS Quantity Packings" := lrc_MasterBatchTemp."MCS Quantity Packings" +
                                                                       lrc_BatchTemp."MCS Quantity Packings";
                        lrc_MasterBatchTemp."MCS Gross Weight" := lrc_MasterBatchTemp."MCS Gross Weight" +
                                                                  lrc_BatchTemp."MCS Gross Weight";
                        lrc_MasterBatchTemp."MCS Net Weight" := lrc_MasterBatchTemp."MCS Net Weight" +
                                                                lrc_BatchTemp."MCS Net Weight";
                        lrc_MasterBatchTemp."MCS No. of Lines" := lrc_MasterBatchTemp."MCS No. of Lines" +
                                                                  lrc_BatchTemp."MCS No. of Lines";
                        lrc_MasterBatchTemp.MODIFY();
                    END;
                    IF lrc_BatchTemp."MCS Master Batch No." <> '' THEN BEGIN
                        lrc_MasterBatchTemp.RESET();
                        lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                        lrc_MasterBatchTemp.SETRANGE("Userid Code", USERID());
                        lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", lrc_BatchTemp."MCS Master Batch No.");
                        lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", '');
                        lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
                        lrc_MasterBatchTemp.FIND('-');
                        lrc_MasterBatchTemp."MCS Total Amount" := lrc_MasterBatchTemp."MCS Total Amount" +
                                                                  lrc_BatchTemp."MCS Total Amount";
                        lrc_MasterBatchTemp."MCS Quantity Colli" := lrc_MasterBatchTemp."MCS Quantity Colli" +
                                                                    lrc_BatchTemp."MCS Quantity Colli";
                        lrc_MasterBatchTemp."MCS Quantity Pallets" := lrc_MasterBatchTemp."MCS Quantity Pallets" +
                                                                      lrc_BatchTemp."MCS Quantity Pallets";
                        lrc_MasterBatchTemp."MCS Quantity Packings" := lrc_MasterBatchTemp."MCS Quantity Packings" +
                                                                       lrc_BatchTemp."MCS Quantity Packings";
                        lrc_MasterBatchTemp."MCS Gross Weight" := lrc_MasterBatchTemp."MCS Gross Weight" +
                                                                  lrc_BatchTemp."MCS Gross Weight";
                        lrc_MasterBatchTemp."MCS Net Weight" := lrc_MasterBatchTemp."MCS Net Weight" +
                                                                lrc_BatchTemp."MCS Net Weight";
                        lrc_MasterBatchTemp."MCS No. of Lines" := lrc_MasterBatchTemp."MCS No. of Lines" +
                                                                  lrc_BatchTemp."MCS No. of Lines";
                        lrc_MasterBatchTemp.MODIFY();
                    END;
                END;
            UNTIL lrc_BatchTemp.NEXT() = 0;
    end;

    //     procedure _CalcTotalPerCostCat(vrc_CostCalculation: Record "POI Cost Calc. - Enter Data")
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         ldc_TotalAmountEnterd: Decimal;
    //         ldc_TotalAmountReleased: Decimal;
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Erfassten Summen
    //         // ------------------------------------------------------------------------------------------------

    //         IF vrc_CostCalculation."Entry Type" <> vrc_CostCalculation."Entry Type"::"Cost Category" THEN
    //             EXIT;

    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Detail Batch");
    //         lrc_CostCalculation.SETRANGE("Cost Category Code", vrc_CostCalculation."Cost Category Code");
    //         CASE vrc_CostCalculation."Entry Level" OF
    //             vrc_CostCalculation."Entry Level"::Voyage:
    //                 BEGIN
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Voyage);
    //                     lrc_CostCalculation.SETRANGE("Voyage No.", vrc_CostCalculation."Voyage No.");
    //                 END;
    //             vrc_CostCalculation."Entry Level"::Container:
    //                 BEGIN
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::Container);
    //                 END;
    //             vrc_CostCalculation."Entry Level"::"Master Batch":
    //                 BEGIN
    //                     lrc_CostCalculation.SETRANGE("Entry Level", lrc_CostCalculation."Entry Level"::"Master Batch");
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", vrc_CostCalculation."Master Batch No.");
    //                 END;
    //         END;
    //         IF lrc_CostCalculation.FIND('-') THEN BEGIN
    //             REPEAT
    //                 ldc_TotalAmountEnterd := ldc_TotalAmountEnterd + lrc_CostCalculation."Amount (LCY)";
    //                 IF lrc_CostCalculation.Released = TRUE THEN BEGIN
    //                     ldc_TotalAmountReleased := ldc_TotalAmountReleased + lrc_CostCalculation."Amount (LCY)";
    //                 END;
    //             UNTIL lrc_CostCalculation.NEXT() = 0;
    //         END ELSE BEGIN
    //             ldc_TotalAmountEnterd := 0;
    //             ldc_TotalAmountReleased := 0;
    //         END;


    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.GET(vrc_CostCalculation."Document No.");
    //         lrc_CostCalculation."Entered Amount (LCY)" := ldc_TotalAmountEnterd;
    //         lrc_CostCalculation."Released Amount (LCY)" := ldc_TotalAmountReleased;
    //         lrc_CostCalculation.MODIFY();
    //     end;

    //     procedure _CalcPlanCostPerPurchLine(vco_PurchOrderNo: Code[20]; vco_MasterBatchNo: Code[20]; vco_VoyageNo: Code[20])
    //     var
    //         lrc_PurchHeader: Record "Purchase Header";
    //         lrc_PurchLine: Record "Purchase Line";
    //         lrc_CostCalcDetailBatchVar: Record "POI Cost Calc. - Enter Data";
    //         lrc_BatchVariant: Record "POI Batch Variant";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Plankosten pro Einkaufszeile (Position)
    //         // ----------------------------------------------------------------------------------------------


    //         // Einkaufskopf lesen
    //         lrc_PurchHeader.RESET();
    //         lrc_PurchHeader.SETRANGE("Document Type", lrc_PurchHeader."Document Type"::Order);
    //         IF vco_PurchOrderNo <> '' THEN
    //             lrc_PurchHeader.SETRANGE("No.", vco_PurchOrderNo);
    //         IF vco_MasterBatchNo <> '' THEN
    //             lrc_PurchHeader.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF vco_VoyageNo <> '' THEN
    //             lrc_PurchHeader.SETRANGE("Voyage No.", vco_VoyageNo);
    //         IF lrc_PurchHeader.FIND('-') THEN BEGIN
    //             REPEAT

    //                 lrc_PurchLine.RESET();
    //                 lrc_PurchLine.SETCURRENTKEY("Document Type", Type, "Master Batch No.", "Batch No.", "Batch Variant No.");
    //                 lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
    //                 lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
    //                 lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
    //                 lrc_PurchLine.SETFILTER("No.", '<>%1', '');
    //                 lrc_PurchLine.SETFILTER("Batch Variant No.", '<>%1', '');
    //                 IF lrc_PurchLine.FIND('-') THEN BEGIN
    //                     REPEAT

    //                         // Werte auf Null setzen
    //                         lrc_PurchLine."Cost Calc. Amount (LCY)" := 0;
    //                         lrc_PurchLine."Cost Calc. (UOM) (LCY)" := 0;
    //                         lrc_PurchLine."Indirect Cost Amount (LCY)" := 0;

    //                         lrc_CostCalcDetailBatchVar.RESET();
    //                         lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Batch Variant No.", "Vendor No.");
    //                         lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", lrc_PurchLine."Master Batch No.");
    //                         lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.", lrc_PurchLine."Batch No.");
    //                         lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.", lrc_PurchLine."Batch Variant No.");
    //                         lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
    //                         IF lrc_CostCalcDetailBatchVar.FIND('-') THEN BEGIN
    //                             REPEAT
    //                                 // Alle Kosten aufaddieren
    //                                 lrc_PurchLine."Cost Calc. Amount (LCY)" := lrc_PurchLine."Cost Calc. Amount (LCY)" +
    //                                                                            lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                                 // Indirekte Kosten aufaddieren
    //                                 IF lrc_CostCalcDetailBatchVar."Indirect Cost (Purchase)" = TRUE THEN
    //                                     lrc_PurchLine."Indirect Cost Amount (LCY)" := lrc_PurchLine."Indirect Cost Amount (LCY)" +
    //                                                                                   lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                             UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;
    //                         END;

    //                         IF lrc_PurchLine.Quantity <> 0 THEN BEGIN
    //                             lrc_PurchLine."Cost Calc. (UOM) (LCY)" := ROUND(lrc_PurchLine."Cost Calc. Amount (LCY)" /
    //                                                                                lrc_PurchLine.Quantity, 0.00001);
    //                         END;

    //                         // FV START 131107
    //                         lrc_PurchLine.UpdateUnitCost;
    //                         // FV ENDE

    //                         lrc_PurchLine.MODIFY();

    //                         // Werte in die Batch Variant schreiben
    //                         IF lrc_BatchVariant.GET(lrc_PurchLine."Batch Variant No.") THEN BEGIN
    //                             lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                             lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := lrc_PurchLine."Cost Calc. (UOM) (LCY)";
    //                             // Indirekte Kosten
    //                             lrc_BatchVariant.MODIFY();
    //                         END;

    //                     UNTIL lrc_PurchLine.NEXT() = 0;
    //                 END;


    //             UNTIL lrc_PurchHeader.NEXT() = 0;


    //             // Werte nur in Positionsvariante schreiben, da Einkauf nicht mehr vorhanden
    //         END ELSE BEGIN

    //             lrc_BatchVariant.RESET();
    //             IF vco_PurchOrderNo <> '' THEN BEGIN
    //                 lrc_BatchVariant.SETRANGE("No.", '');
    //             END;
    //             IF vco_MasterBatchNo <> '' THEN
    //                 lrc_BatchVariant.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //             IF vco_VoyageNo <> '' THEN
    //                 lrc_BatchVariant.SETRANGE("Voyage No.", vco_VoyageNo);
    //             IF lrc_BatchVariant.FIND('-') THEN BEGIN
    //                 REPEAT

    //                     lrc_BatchVariant.CALCFIELDS("B.V. Purch. Rec. (Qty)", "B.V. Purch. Order (Qty)");

    //                     // Werte zurücksetzen
    //                     lrc_BatchVariant."Cost Calc. Amount (LCY)" := 0;
    //                     lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := 0;

    //                     lrc_CostCalcDetailBatchVar.RESET();
    //                     lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.",
    //                                                              "Batch Variant No.", "Vendor No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", lrc_BatchVariant."Master Batch No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.", lrc_BatchVariant."Batch No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.", lrc_BatchVariant."No.");
    //                     lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
    //                     IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
    //                         REPEAT
    //                             lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" +
    //                                                                           lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                         UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;

    //                     IF (lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") <> 0 THEN BEGIN
    //                         lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" /
    //                           ((lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") /
    //                            lrc_BatchVariant."Qty. per Unit of Measure");
    //                     END;

    //                     lrc_BatchVariant.MODIFY();

    //                 UNTIL lrc_BatchVariant.NEXT() = 0;

    //             END;

    //         END;
    //     end;

    //     procedure __MasterBatchCalcCost(vco_MasterBatchNo: Code[20]; vco_CostCategoryCode: Code[20])
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_Batch: Record "POI Batch";
    //         lrc_BatchVariant: Record "POI Batch Variant";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalculationData: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalcDetailBatch: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalcDetailBatchVar: Record "POI Cost Calc. - Enter Data";
    //         "-": Integer;
    //         lcu_BatchMgt: Codeunit "POI BAM Batch Management";
    //         lrc_BatchTemp: Record "5110369";
    //         lrc_MasterBatchTemp: Record "5110369";
    //         lrc_PurchHeader: Record "Purchase Header";
    //         lrc_PurchLine: Record "Purchase Line";
    //         "--": Integer;
    //         ldc_SumAmount: Decimal;
    //         ldc_SumAmountMW: Decimal;
    //         ldc_Proz: Decimal;
    //         ldc_Amount: Decimal;
    //         ldc_AmountMW: Decimal;
    //         AGILES_LT_TEXT001: Label 'Herkunft nicht identifiziert!';
    //         AGILES_LT_TEXT002: Label 'Herkunft nicht zulässig!';
    //         AGILES_LT_TEXT003: Label 'Betrag kann nicht über Paletten verteilt werden!';
    //         AGILES_LT_TEXT004: Label 'Betrag kann nicht über Kolli verteilt werden!';
    //         AGILES_LT_TEXT005: Label 'Betrag kann nicht über Nettogewicht verteilt werden!';
    //         AGILES_LT_TEXT006: Label 'Betrag kann nicht über Bruttogewicht verteilt werden!';
    //         AGILES_LT_TEXT007: Label 'Betrag kann nicht über Anzahl Zeilen verteilt werden!';
    //         AGILES_LT_TEXT008: Label 'Betrag kann nicht über Gesamtbetrag verteilt werden!';
    //         AGILES_LT_TEXT009: Label 'Betrag kann nicht über Paletten auf die Positionsvarianten verteilt werden!';
    //         AGILES_LT_TEXT010: Label 'Betrag kann nicht über Kolli auf die Positionsvarianten verteilt werden!';
    //         AGILES_LT_TEXT011: Label 'Betrag kann nicht über Nettogewicht verteilt werden!';
    //         AGILES_LT_TEXT012: Label 'Herkunft nicht codiert %1!';
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Kalkulation und Umlage der Kosten
    //         // ----------------------------------------------------------------------------------------------

    //         // ---------------------------------------------------------------
    //         // Detailzeilen löschen
    //         // ---------------------------------------------------------------

    //         // Detailzeilen "Batch" löschen
    //         lrc_CostCalcDetailBatch.RESET();
    //         lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //         lrc_CostCalcDetailBatch.SETRANGE("Entry Type", lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
    //         lrc_CostCalcDetailBatch.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF vco_CostCategoryCode <> '' THEN
    //             lrc_CostCalcDetailBatch.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //         lrc_CostCalcDetailBatch.DELETEALL();

    //         // Detailzeilen "Batch Variant" löschen
    //         lrc_CostCalcDetailBatchVar.RESET();
    //         lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //         lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
    //         lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //         IF vco_CostCategoryCode <> '' THEN
    //             lrc_CostCalcDetailBatchVar.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //         lrc_CostCalcDetailBatchVar.DELETEALL();


    //         // --------------------------------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------------------------------
    //         lrc_FruitVisionSetup.GET();
    //         CASE lrc_FruitVisionSetup."Cost Category Calc. Type" OF
    //             lrc_FruitVisionSetup."Cost Category Calc. Type"::"Rekursiv von Zeile":
    //                 BEGIN

    //                     // ---------------------------------------------------------------
    //                     // Positionen und Gesamtmengen in Temp Tabelle laden
    //                     // ---------------------------------------------------------------
    //                     lrc_MasterBatch.GET(vco_MasterBatchNo);
    //                     CASE lrc_MasterBatch.Source OF
    //                         lrc_MasterBatch.Source::"Purch. Order":
    //                             BEGIN
    //                                 // Einkaufskopf lesen
    //                                 lrc_PurchHeader.GET(lrc_PurchHeader."Document Type"::Order, lrc_MasterBatch."Source No.");
    //                             END;
    //                         lrc_MasterBatch.Source::"Sorting Order":
    //                             BEGIN
    //                                 // Herkunft nicht zulässig!
    //                                 ERROR(AGILES_LT_TEXT002);
    //                             END;
    //                         lrc_MasterBatch.Source::" ":
    //                             BEGIN
    //                                 // Herkunft nicht identifiziert!
    //                                 ERROR(AGILES_LT_TEXT001);
    //                             END;
    //                     END;

    //                     lrc_PurchLine.RESET();
    //                     lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
    //                     lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
    //                     lrc_PurchLine.SETFILTER("No.", '<>%1', '');
    //                     IF lrc_PurchLine.FIND('-') THEN BEGIN
    //                         REPEAT

    //                             lrc_CostCalcDetailBatchVar.RESET();
    //                             lrc_CostCalcDetailBatchVar.INIT();
    //                             lrc_CostCalcDetailBatchVar."Document No." := 0;
    //                             lrc_CostCalcDetailBatchVar."Cost Category Code" := 'STD';
    //                             lrc_CostCalcDetailBatchVar."Master Batch No." := lrc_PurchLine."Master Batch No.";
    //                             lrc_CostCalcDetailBatchVar."Batch No." := lrc_PurchLine."Batch No.";
    //                             lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_PurchLine."Batch Variant No.";
    //                             lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant";
    //                             lrc_CostCalcDetailBatchVar."Product Group Code" := lrc_PurchLine."Product Group Code";
    //                             lrc_CostCalcDetailBatchVar."Cost Schema Name" := 'STD';
    //                             lrc_CostCalcDetailBatchVar."Vendor No." := lrc_PurchLine."Buy-from Vendor No.";
    //                             lrc_CostCalcDetailBatchVar."Expected Posting Date" := 0D;
    //                             lrc_CostCalcDetailBatchVar."Currency Code" := lrc_PurchLine."Currency Code";
    //                             lrc_CostCalcDetailBatchVar."Currency Factor" := 1;
    //                             lrc_CostCalcDetailBatchVar.Amount := lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                             lrc_CostCalcDetailBatchVar."Amount (LCY)" := lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                             lrc_CostCalcDetailBatchVar."Allocation Type" := lrc_CostCalcDetailBatchVar."Allocation Type"::" ";
    //                             lrc_CostCalcDetailBatchVar.INSERT(TRUE);

    //                             lrc_CostCalcDetailBatch.RESET();
    //                             lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Cost Category Code");
    //                             lrc_CostCalcDetailBatch.SETRANGE("Cost Category Code", 'STD');
    //                             lrc_CostCalcDetailBatch.SETRANGE("Master Batch No.", lrc_PurchLine."Master Batch No.");
    //                             lrc_CostCalcDetailBatch.SETRANGE("Batch No.", lrc_PurchLine."Batch No.");
    //                             lrc_CostCalcDetailBatch.SETRANGE("Entry Type", lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
    //                             IF lrc_CostCalcDetailBatch.FIND('-') THEN BEGIN

    //                                 lrc_CostCalcDetailBatch.Amount := lrc_CostCalcDetailBatch.Amount + lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                                 lrc_CostCalcDetailBatch."Amount (LCY)" := lrc_CostCalcDetailBatch."Amount (LCY)" +
    //                                                                           lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                                 lrc_CostCalcDetailBatch.MODIFY();

    //                             END ELSE BEGIN

    //                                 lrc_CostCalcDetailBatch.RESET();
    //                                 lrc_CostCalcDetailBatch.INIT();
    //                                 lrc_CostCalcDetailBatch."Document No." := 0;
    //                                 lrc_CostCalcDetailBatch."Cost Category Code" := 'STD';
    //                                 lrc_CostCalcDetailBatch."Master Batch No." := lrc_PurchLine."Master Batch No.";
    //                                 lrc_CostCalcDetailBatch."Batch No." := lrc_PurchLine."Batch No.";
    //                                 lrc_CostCalcDetailBatch."Batch Variant No." := lrc_PurchLine."Batch Variant No.";
    //                                 lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
    //                                 lrc_CostCalcDetailBatch."Product Group Code" := lrc_PurchLine."Product Group Code";
    //                                 lrc_CostCalcDetailBatch."Cost Schema Name" := 'STD';
    //                                 lrc_CostCalcDetailBatch."Vendor No." := lrc_PurchLine."Buy-from Vendor No.";
    //                                 lrc_CostCalcDetailBatch."Expected Posting Date" := 0D;
    //                                 lrc_CostCalcDetailBatch."Currency Code" := lrc_PurchLine."Currency Code";
    //                                 lrc_CostCalcDetailBatch."Currency Factor" := 1;
    //                                 lrc_CostCalcDetailBatch.Amount := lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                                 lrc_CostCalcDetailBatch."Amount (LCY)" := lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                                 lrc_CostCalcDetailBatch."Allocation Type" := lrc_CostCalcDetailBatch."Allocation Type"::" ";
    //                                 lrc_CostCalcDetailBatch.INSERT(TRUE);

    //                             END;

    //                         UNTIL lrc_PurchLine.NEXT() = 0;
    //                     END;

    //                 END;


    //             // --------------------------------------------------------------------------------------------------------------
    //             //
    //             // --------------------------------------------------------------------------------------------------------------
    //             lrc_FruitVisionSetup."Cost Category Calc. Type"::Standard:
    //                 BEGIN

    //                     // ---------------------------------------------------------------
    //                     // Positionen und Gesamtmengen in Temp Tabelle laden
    //                     // ---------------------------------------------------------------
    //                     lrc_MasterBatch.GET(vco_MasterBatchNo);
    //                     CASE lrc_MasterBatch.Source OF
    //                         lrc_MasterBatch.Source::"Purch. Order":
    //                             BEGIN
    //                                 // Einkaufskopf lesen
    //                                 IF lrc_PurchHeader.GET(lrc_PurchHeader."Document Type"::Order, lrc_MasterBatch."Source No.") THEN BEGIN
    //                                     // Positionen und Gesamtmengen in Temp. Tabelle laden
    //                                     lcu_BatchMgt.LoadBatchNoInBuffer(vco_MasterBatchNo, '', '', lrc_PurchHeader."No.", '');
    //                                     // Werte in Einkaufszeilen auf Null Setzen
    //                                     lrc_PurchLine.RESET();
    //                                     lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
    //                                     lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
    //                                     IF lrc_PurchLine.FIND('-') THEN BEGIN
    //                                         lrc_PurchLine.MODIFYALL("Cost Calc. (UOM) (LCY)", 0);
    //                                         lrc_PurchLine.MODIFYALL("Cost Calc. Amount (LCY)", 0);
    //                                     END;
    //                                 END;
    //                             END;
    //                         lrc_MasterBatch.Source::" ":
    //                             BEGIN
    //                                 // Herkunft nicht identifiziert!
    //                                 ERROR(AGILES_LT_TEXT001);
    //                             END;
    //                         ELSE
    //                             // Herkunft nicht zulässig!
    //                             ERROR(AGILES_LT_TEXT002);
    //                     END;

    //                     // Gesamtsummensatz über Master Batch in Temp. Tabelle lesen
    //                     lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
    //                     lrc_MasterBatchTemp.SETRANGE("Userid Code", UserID());
    //                     lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
    //                     lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", vco_MasterBatchNo);
    //                     lrc_MasterBatchTemp.FIND('-');

    //                     // Schleife um die Kostenkategorien innerhalb der Partienummer
    //                     lrc_CostCalculation.RESET();
    //                     lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //                     lrc_CostCalculation.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                     IF vco_CostCategoryCode <> '' THEN
    //                         lrc_CostCalculation.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //                     lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Cost Category");
    //                     IF lrc_CostCalculation.FIND('-') THEN
    //                         REPEAT

    //                             // --------------------------------------------------------------------------------------
    //                             // Von Enter Data auf Detail Batch verteilen
    //                             // --------------------------------------------------------------------------------------
    //                             lrc_CostCalculationData.RESET();
    //                             lrc_CostCalculationData.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //                             lrc_CostCalculationData.SETRANGE("Master Batch No.", lrc_CostCalculation."Master Batch No.");
    //                             lrc_CostCalculationData.SETRANGE("Cost Category Code", lrc_CostCalculation."Cost Category Code");
    //                             lrc_CostCalculationData.SETRANGE("Entry Type", lrc_CostCalculationData."Entry Type"::"Enter Data");
    //                             IF lrc_CostCalculationData.FIND('-') THEN
    //                                 REPEAT

    //                                     // Verteilung auf die Positionen
    //                                     IF lrc_CostCalculationData."Batch No." = '' THEN BEGIN

    //                                         ldc_SumAmount := 0;
    //                                         ldc_SumAmountMW := 0;

    //                                         // Schleife um alle Positionen
    //                                         lrc_BatchTemp.RESET();
    //                                         lrc_BatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
    //                                         lrc_BatchTemp.SETRANGE("Userid Code", UserID());
    //                                         lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
    //                                         lrc_BatchTemp.SETRANGE("MCS Master Batch No.", vco_MasterBatchNo);
    //                                         IF lrc_BatchTemp.FIND('-') THEN BEGIN
    //                                             REPEAT

    //                                                 CASE lrc_CostCalculationData."Allocation Type" OF
    //                                                     lrc_CostCalculationData."Allocation Type"::Pallets:
    //                                                         BEGIN
    //                                                             IF lrc_MasterBatchTemp."MCS Quantity Pallets" = 0 THEN
    //                                                                 // Betrag kann nicht über Paletten verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT003);
    //                                                             ldc_Proz := lrc_BatchTemp."MCS Quantity Pallets" / lrc_MasterBatchTemp."MCS Quantity Pallets";
    //                                                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalculationData."Allocation Type"::Kolli:
    //                                                         BEGIN
    //                                                             IF lrc_MasterBatchTemp."MCS Quantity Colli" = 0 THEN
    //                                                                 // Betrag kann nicht über Kolli verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT004);
    //                                                             ldc_Proz := lrc_BatchTemp."MCS Quantity Colli" / lrc_MasterBatchTemp."MCS Quantity Colli";
    //                                                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalculationData."Allocation Type"::"Net Weight":
    //                                                         BEGIN
    //                                                             IF lrc_MasterBatchTemp."MCS Net Weight" = 0 THEN
    //                                                                 // Betrag kann nicht über Nettogewicht verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT005);
    //                                                             ldc_Proz := lrc_BatchTemp."MCS Net Weight" / lrc_MasterBatchTemp."MCS Net Weight";
    //                                                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalculationData."Allocation Type"::"Gross Weight":
    //                                                         BEGIN
    //                                                             IF lrc_MasterBatchTemp."MCS Gross Weight" = 0 THEN
    //                                                                 // Betrag kann nicht über Bruttogewicht verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT006);
    //                                                             ldc_Proz := lrc_BatchTemp."MCS Gross Weight" / lrc_MasterBatchTemp."MCS Gross Weight";
    //                                                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalculationData."Allocation Type"::Lines:
    //                                                         BEGIN
    //                                                             IF lrc_MasterBatchTemp."MCS No. of Lines" = 0 THEN
    //                                                                 // Betrag kann nicht über Anzahl Zeilen verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT007);
    //                                                             ldc_Proz := lrc_BatchTemp."MCS No. of Lines" / lrc_MasterBatchTemp."MCS No. of Lines";
    //                                                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalculationData."Allocation Type"::Amount:
    //                                                         BEGIN
    //                                                             IF lrc_MasterBatchTemp."MCS Total Amount" = 0 THEN
    //                                                                 // Betrag kann nicht über Gesamtbetrag verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT008);
    //                                                             ldc_Proz := lrc_BatchTemp."MCS Total Amount" / lrc_MasterBatchTemp."MCS Total Amount";
    //                                                             ldc_Amount := ROUND(lrc_CostCalculationData.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalculationData."Currency Factor", 0.01);
    //                                                         END;
    //                                                 END;

    //                                                 // Detailzeile Batch einfügen
    //                                                 lrc_CostCalcDetailBatch.RESET();
    //                                                 lrc_CostCalcDetailBatch := lrc_CostCalculationData;
    //                                                 lrc_CostCalcDetailBatch."Document No." := 0;
    //                                                 lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
    //                                                 lrc_CostCalcDetailBatch."Batch No." := lrc_BatchTemp."MCS Batch No.";
    //                                                 lrc_CostCalcDetailBatch.VALIDATE(Amount, ldc_Amount);
    //                                                 lrc_CostCalcDetailBatch."Attached to Entry No." := lrc_CostCalculationData."Document No.";
    //                                                 lrc_CostCalcDetailBatch."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
    //                                                 lrc_CostCalcDetailBatch."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";

    //                                                 lrc_CostCalcDetailBatch.INSERT(TRUE);

    //                                                 ldc_SumAmount := ldc_SumAmount + ldc_Amount;
    //                                                 ldc_SumAmountMW := ldc_SumAmountMW + ldc_AmountMW;

    //                                             UNTIL lrc_BatchTemp.NEXT() = 0;

    //                                             // Kontrolle ob verteilter Betrag dem Gesamtbetrag entspricht
    //                                             // Differenz auf letzte Zeile übertragen
    //                                             IF ldc_SumAmount <> lrc_CostCalculationData.Amount THEN BEGIN
    //                                                 IF lrc_CostCalcDetailBatch."Document No." <> 0 THEN BEGIN
    //                                                     ldc_SumAmount := lrc_CostCalculationData.Amount - ldc_SumAmount;
    //                                                     ldc_SumAmountMW := lrc_CostCalculationData."Amount (LCY)" - ldc_SumAmountMW;
    //                                                     lrc_CostCalcDetailBatch.VALIDATE(Amount, (lrc_CostCalcDetailBatch.Amount + ldc_SumAmount));
    //                                                     lrc_CostCalcDetailBatch.MODIFY();
    //                                                 END;
    //                                             END;

    //                                         END;
    //                                     END ELSE BEGIN

    //                                         lrc_CostCalcDetailBatch.RESET();
    //                                         lrc_CostCalcDetailBatch := lrc_CostCalculationData;

    //                                         lrc_CostCalcDetailBatch."Document No." := 0;
    //                                         lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
    //                                         lrc_CostCalcDetailBatch."Attached to Entry No." := lrc_CostCalculationData."Document No.";
    //                                         lrc_CostCalcDetailBatch."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
    //                                         lrc_CostCalcDetailBatch."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";

    //                                         lrc_CostCalcDetailBatch.INSERT(TRUE);

    //                                     END;

    //                                     // SFR 02.07.2007 die folgenden beiden Zeilen sind wichtig auf einem SQL - Server
    //                                     IF lrc_CostCalculationData.RECORDLEVELLOCKING() THEN
    //                                         COMMIT;

    //                                 UNTIL lrc_CostCalculationData.NEXT() = 0;


    //                             // --------------------------------------------------------------------------------------
    //                             // Einkaufszeile lesen und Werte zurücksetzen
    //                             // --------------------------------------------------------------------------------------
    //                             lrc_PurchLine.RESET();
    //                             lrc_PurchLine.SETCURRENTKEY("Document Type", Type, "Master Batch No.", "Batch No.", "Batch Variant No.");
    //                             lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
    //                             lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
    //                             lrc_PurchLine.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                             IF lrc_PurchLine.FIND('-') THEN BEGIN
    //                                 REPEAT
    //                                     lrc_PurchLine."Cost Calc. (UOM) (LCY)" := 0;
    //                                     lrc_PurchLine."Cost Calc. Amount (LCY)" := 0;
    //                                     lrc_PurchLine.MODIFY();
    //                                 UNTIL lrc_PurchLine.NEXT() = 0;
    //                             END;

    //                             // --------------------------------------------------------------------------------------
    //                             // Von Detail Batch auf Detail Batch Variant verteilen
    //                             // --------------------------------------------------------------------------------------
    //                             lrc_CostCalcDetailBatch.RESET();
    //                             lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type", "Master Batch No.", "Cost Category Code");
    //                             lrc_CostCalcDetailBatch.SETRANGE("Master Batch No.", lrc_CostCalculation."Master Batch No.");
    //                             lrc_CostCalcDetailBatch.SETRANGE("Cost Category Code", lrc_CostCalculation."Cost Category Code");
    //                             lrc_CostCalcDetailBatch.SETRANGE("Entry Type", lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
    //                             IF lrc_CostCalcDetailBatch.FIND('-') THEN BEGIN
    //                                 REPEAT

    //                                     lrc_CostCalcDetailBatch.TESTFIELD("Batch No.");

    //                                     // Summensatz Position lesen
    //                                     lrc_BatchTemp.RESET();
    //                                     lrc_BatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
    //                                     lrc_BatchTemp.SETRANGE("Userid Code", UserID());
    //                                     lrc_BatchTemp.SETRANGE("MCS Batch No.", lrc_CostCalcDetailBatch."Batch No.");
    //                                     lrc_BatchTemp.SETRANGE("MCS Master Batch No.", lrc_CostCalcDetailBatch."Master Batch No.");
    //                                     lrc_BatchTemp.FIND('-');

    //                                     // Schleife um die Positionsvarianten der Position
    //                                     lrc_BatchVariant.RESET();
    //                                     lrc_BatchVariant.SETCURRENTKEY("Master Batch No.", "Batch No.");
    //                                     lrc_BatchVariant.SETRANGE("Master Batch No.", lrc_CostCalcDetailBatch."Master Batch No.");
    //                                     lrc_BatchVariant.SETRANGE("Batch No.", lrc_CostCalcDetailBatch."Batch No.");
    //                                     IF lrc_BatchVariant.FIND('-') THEN
    //                                         REPEAT

    //                                             // Einkaufszeile lesen
    //                                             lrc_PurchLine.RESET();
    //                                             lrc_PurchLine.SETCURRENTKEY("Document Type", Type, "Master Batch No.", "Batch No.", "Batch Variant No.");
    //                                             lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
    //                                             lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
    //                                             lrc_PurchLine.SETRANGE("Master Batch No.", lrc_BatchVariant."Master Batch No.");
    //                                             lrc_PurchLine.SETRANGE("Batch No.", lrc_BatchVariant."Batch No.");
    //                                             lrc_PurchLine.SETRANGE("Batch Variant No.", lrc_BatchVariant."No.");
    //                                             lrc_PurchLine.SETFILTER(Quantity, '<>%1', 0);
    //                                             IF lrc_PurchLine.FIND('-') THEN BEGIN

    //                                                 ldc_Proz := 0;
    //                                                 ldc_Amount := 0;
    //                                                 ldc_AmountMW := 0;

    //                                                 CASE lrc_CostCalcDetailBatch."Allocation Type" OF
    //                                                     lrc_CostCalcDetailBatch."Allocation Type"::Pallets:
    //                                                         BEGIN
    //                                                             IF lrc_BatchTemp."MCS Quantity Pallets" = 0 THEN
    //                                                                 // Betrag kann nicht über Paletten auf die Positionsvarianten verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT009);
    //                                                             IF lrc_PurchLine."Quantity (TU)" <> 0 THEN BEGIN
    //                                                                 ldc_Proz := lrc_PurchLine."Quantity (TU)" / lrc_BatchTemp."MCS Quantity Pallets";
    //                                                                 ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
    //                                                             END ELSE BEGIN
    //                                                                 ldc_Amount := lrc_CostCalcDetailBatch.Amount;
    //                                                             END;
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalcDetailBatch."Allocation Type"::Kolli:
    //                                                         BEGIN
    //                                                             IF lrc_BatchTemp."MCS Quantity Colli" = 0 THEN
    //                                                                 // Betrag kann nicht über Kolli auf die Positionsvarianten verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT010);
    //                                                             ldc_Proz := lrc_PurchLine.Quantity / lrc_BatchTemp."MCS Quantity Colli";
    //                                                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalcDetailBatch."Allocation Type"::"Net Weight":
    //                                                         BEGIN
    //                                                             IF lrc_BatchTemp."MCS Net Weight" = 0 THEN
    //                                                                 // Betrag kann nicht über Nettogewicht verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT011);
    //                                                             ldc_Proz := lrc_PurchLine."Total Net Weight" / lrc_BatchTemp."MCS Net Weight";
    //                                                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalcDetailBatch."Allocation Type"::"Gross Weight":
    //                                                         BEGIN
    //                                                             IF lrc_BatchTemp."MCS Gross Weight" = 0 THEN
    //                                                                 // Betrag kann nicht über Bruttogewicht verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT006);
    //                                                             ldc_Proz := lrc_PurchLine."Total Gross Weight" / lrc_BatchTemp."MCS Gross Weight";
    //                                                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalcDetailBatch."Allocation Type"::Lines:
    //                                                         BEGIN
    //                                                             IF lrc_BatchTemp."MCS No. of Lines" = 0 THEN
    //                                                                 // Betrag kann nicht über Anzahl Zeilen verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT007);
    //                                                             ldc_Proz := 1 / lrc_BatchTemp."MCS No. of Lines";
    //                                                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
    //                                                         END;

    //                                                     lrc_CostCalcDetailBatch."Allocation Type"::Amount:
    //                                                         BEGIN
    //                                                             IF lrc_BatchTemp."MCS Total Amount" = 0 THEN
    //                                                                 // Betrag kann nicht über Gesamtbetrag verteilt werden!
    //                                                                 ERROR(AGILES_LT_TEXT008);
    //                                                             ldc_Proz := lrc_PurchLine.Amount / lrc_BatchTemp."MCS Total Amount";
    //                                                             ldc_Amount := ROUND(lrc_CostCalcDetailBatch.Amount * ldc_Proz, 0.01);
    //                                                             ldc_AmountMW := ROUND(ldc_Amount * lrc_CostCalcDetailBatch."Currency Factor", 0.01);
    //                                                         END;

    //                                                 END;

    //                                                 // Detailzeile Batch einfügen
    //                                                 lrc_CostCalcDetailBatchVar.RESET();
    //                                                 lrc_CostCalcDetailBatchVar.INIT();
    //                                                 lrc_CostCalcDetailBatchVar := lrc_CostCalcDetailBatch;
    //                                                 lrc_CostCalcDetailBatchVar."Document No." := 0;
    //                                                 lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch Variant";
    //                                                 lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_BatchVariant."No.";
    //                                                 lrc_CostCalcDetailBatchVar.VALIDATE(Amount, ldc_Amount);
    //                                                 lrc_CostCalcDetailBatchVar."Attached to Entry No." := lrc_CostCalcDetailBatch."Document No.";
    //                                                 lrc_CostCalcDetailBatchVar."Attached to Doc. No." := lrc_CostCalcDetailBatch."Document No. 2";
    //                                                 lrc_CostCalcDetailBatchVar."Attached Entry Subtype" := lrc_CostCalcDetailBatch."Entry Level";

    //                                                 lrc_CostCalcDetailBatchVar.INSERT(TRUE);

    //                                             END ELSE BEGIN

    //                                                 // Detailzeile Batch einfügen
    //                                                 lrc_CostCalcDetailBatchVar.RESET();
    //                                                 lrc_CostCalcDetailBatchVar.INIT();
    //                                                 lrc_CostCalcDetailBatchVar := lrc_CostCalcDetailBatch;
    //                                                 lrc_CostCalcDetailBatchVar."Document No." := 0;
    //                                                 lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch Variant";
    //                                                 lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_BatchVariant."No.";
    //                                                 //lrc_CostCalcDetailBatchVar.VALIDATE(Amount,ldc_Amount);
    //                                                 lrc_CostCalcDetailBatchVar."Attached to Entry No." := lrc_CostCalcDetailBatch."Document No.";
    //                                                 lrc_CostCalcDetailBatchVar."Attached to Doc. No." := lrc_CostCalcDetailBatch."Document No. 2";
    //                                                 lrc_CostCalcDetailBatchVar."Attached Entry Subtype" := lrc_CostCalcDetailBatch."Entry Level";

    //                                                 lrc_CostCalcDetailBatchVar.INSERT(TRUE);


    //                                             END;

    //                                         UNTIL lrc_BatchVariant.NEXT() = 0;

    //                                 // Reste der letzten Positionsvariante zuordnen



    //                                 UNTIL lrc_CostCalcDetailBatch.NEXT() = 0;
    //                             END;

    //                         UNTIL lrc_CostCalculation.NEXT() = 0;


    //                     // -----------------------------------------------------------------
    //                     // Kosten in die Herkunftszeilen übertragen
    //                     // -----------------------------------------------------------------
    //                     CASE lrc_MasterBatch.Source OF
    //                         lrc_MasterBatch.Source::"Purch. Order":
    //                             BEGIN
    //                                 // Einkaufskopf lesen
    //                                 IF lrc_PurchHeader.GET(lrc_PurchHeader."Document Type"::Order, lrc_MasterBatch."Source No.") THEN BEGIN

    //                                     lrc_PurchLine.RESET();
    //                                     lrc_PurchLine.SETCURRENTKEY("Document Type", Type, "Master Batch No.", "Batch No.", "Batch Variant No.");
    //                                     lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
    //                                     lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
    //                                     lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
    //                                     lrc_PurchLine.SETFILTER("No.", '<>%1', '');
    //                                     lrc_PurchLine.SETFILTER("Batch Variant No.", '<>%1', '');
    //                                     IF lrc_PurchLine.FIND('-') THEN BEGIN
    //                                         REPEAT

    //                                             // Werte auf Null setzen
    //                                             lrc_PurchLine."Cost Calc. Amount (LCY)" := 0;
    //                                             lrc_PurchLine."Cost Calc. (UOM) (LCY)" := 0;
    //                                             lrc_PurchLine."Indirect Cost Amount (LCY)" := 0;

    //                                             lrc_CostCalcDetailBatchVar.RESET();
    //                                             lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Batch Variant No.", "Vendor No.");
    //                                             lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", lrc_PurchLine."Master Batch No.");
    //                                             lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.", lrc_PurchLine."Batch No.");
    //                                             lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.", lrc_PurchLine."Batch Variant No.");
    //                                             lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
    //                                             IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
    //                                                 REPEAT
    //                                                     // Alle Kosten aufaddieren
    //                                                     lrc_PurchLine."Cost Calc. Amount (LCY)" := lrc_PurchLine."Cost Calc. Amount (LCY)" +
    //                                                                                                lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                                                     // Indirekte Kosten aufaddieren
    //                                                     IF lrc_CostCalcDetailBatchVar."Indirect Cost (Purchase)" = TRUE THEN
    //                                                         lrc_PurchLine."Indirect Cost Amount (LCY)" := lrc_PurchLine."Indirect Cost Amount (LCY)" +
    //                                                                                                       lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                                                 UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;

    //                                             IF lrc_PurchLine.Quantity <> 0 THEN
    //                                                 lrc_PurchLine."Cost Calc. (UOM) (LCY)" := ROUND(lrc_PurchLine."Cost Calc. Amount (LCY)" /
    //                                                                                                    lrc_PurchLine.Quantity, 0.00001);

    //                                             // FV START 131107
    //                                             lrc_PurchLine.UpdateUnitCost;
    //                                             // FV ENDE

    //                                             lrc_PurchLine.MODIFY();

    //                                             // Werte in die Batch Variant schreiben
    //                                             IF lrc_BatchVariant.GET(lrc_PurchLine."Batch Variant No.") THEN BEGIN
    //                                                 lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_PurchLine."Cost Calc. Amount (LCY)";
    //                                                 lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := lrc_PurchLine."Cost Calc. (UOM) (LCY)";
    //                                                 // Indirekte Kosten
    //                                                 lrc_BatchVariant.MODIFY();
    //                                             END;

    //                                         UNTIL lrc_PurchLine.NEXT() = 0;
    //                                     END;

    //                                     // Werte nur in Positionsvariante schreiben, da Einkauf nicht mehr vorhanden
    //                                 END ELSE BEGIN

    //                                     lrc_BatchVariant.RESET();
    //                                     lrc_BatchVariant.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                                     IF lrc_BatchVariant.FIND('-') THEN
    //                                         REPEAT

    //                                             lrc_BatchVariant.CALCFIELDS("B.V. Purch. Rec. (Qty)", "B.V. Purch. Order (Qty)");

    //                                             // Werte zurücksetzen
    //                                             lrc_BatchVariant."Cost Calc. Amount (LCY)" := 0;
    //                                             lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := 0;

    //                                             lrc_CostCalcDetailBatchVar.RESET();
    //                                             lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.",
    //                                                                                      "Batch Variant No.", "Vendor No.");
    //                                             lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", lrc_BatchVariant."Master Batch No.");
    //                                             lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.", lrc_BatchVariant."Batch No.");
    //                                             lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.", lrc_BatchVariant."No.");
    //                                             lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
    //                                             IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
    //                                                 REPEAT
    //                                                     lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" +
    //                                                                                                   lrc_CostCalcDetailBatchVar."Amount (LCY)";
    //                                                 UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;

    //                                             IF (lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") <> 0 THEN
    //                                                 lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" /
    //                                                   ((lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") /
    //                                                    lrc_BatchVariant."Qty. per Unit of Measure");

    //                                             lrc_BatchVariant.MODIFY();

    //                                         UNTIL lrc_BatchVariant.NEXT() = 0;
    //                                 END;
    //                             END;

    //                         lrc_MasterBatch.Source::" ":
    //                             BEGIN
    //                                 // Herkunft nicht identifiziert!
    //                                 ERROR(AGILES_LT_TEXT001);
    //                             END;
    //                         ELSE
    //                             // Herkunft nicht codiert %1!
    //                             ERROR(AGILES_LT_TEXT001, FORMAT(lrc_MasterBatch.Source));
    //                     END;

    //                 END;
    //         END;
    //     end;
    var
        lrc_CostCalcAllocBatch: Record "POI Cost Calc. - Alloc. Batch";
        lrc_BatchTemp: Record "POI Batch Temp";
        lrc_MasterBatchTemp: Record "POI Batch Temp";
        lrc_BatchVariant: Record "POI Batch Variant";
        //lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
        lrc_CostCalculationData: Record "POI Cost Calc. - Enter Data";
        lrc_CostCalcDetailBatch: Record "POI Cost Calc. - Enter Data";
        lrc_CostCalcDetailBatchVar: Record "POI Cost Calc. - Enter Data";
        lrc_PurchHeader: Record "Purchase Header";
        lrc_PurchLine: Record "Purchase Line";
}

