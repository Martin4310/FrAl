codeunit 5110306 "POI CCM Cost Calc. Mgt"
{

    //     var
    //         Text001: Label 'Es sind manuelle Plankosten vorhanden. Bitte prüfen, ob die aktuelle Änderung einen Einfluss darauf haben könnte.';
    //         Text002: Label 'Kostenkategorie %1 bereits vorhanden.';
    //         Text003: Label 'Update Planning Costs:';
    //         Text004: Label 'Plankosten können nicht berechnet werden. Feld %1 ist für Position %2 nicht gefüllt.';
    //         Text005: Label 'Plankosten können nicht berechnet werden. Feld %1 oder %2 sind für Position %3 nicht gefüllt.';

    //     procedure EnterDataAllCalcCost(vop_EntryType: Option Voyage,Container,"Master Batch",All; vco_EntryCode: Code[20])
    //     var
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //         lrc_Voyage: Record "POI Voyage";
    //         lrc_MasterBatch: Record "POI Master Batch";
    //     //lfm_CalcCostEnterData: Form "5087950";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung von Plankosten ohne Bezug, mit Reise, Container oder Partie als Bezug
    //         // Immer ohne Vorgabe Kostenkategorie !!!
    //         // ----------------------------------------------------------------------------------------------
    //         // vop_EntryType (Voyage,Container,Master Batch,All)
    //         // vco_EntryCode
    //         // ----------------------------------------------------------------------------------------------

    //         CASE vop_EntryType OF
    //             vop_EntryType::Voyage:
    //                 BEGIN
    //                     lrc_Voyage.GET(vco_EntryCode);
    //                     // Filter auf die Erfassungssätze setzen
    //                     lrc_CostCalcEnterData.RESET();
    //                     lrc_CostCalcEnterData.FILTERGROUP(2);
    //                     lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //                     lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::Voyage);
    //                     lrc_CostCalcEnterData.SETRANGE("Voyage No.", lrc_Voyage."No.");
    //                     lrc_CostCalcEnterData.FILTERGROUP(0);

    //                     // vco_CostCategoryCode
    //                     // vin_EntryLevel ( ,Voyage,Container,Master Batch,Batch)
    //                     // vco_MasterBatchNo
    //                     // vco_BatchNoCode
    //                     // vco_VoyageNoCode
    //                     // vco_ContainerNo
    //                     // lfm_CalcCostEnterData.SetGlobals('', 1, '', '', lrc_Voyage."No.", '');TODO: Page

    //                     // lfm_CalcCostEnterData.SETTABLEVIEW(lrc_CostCalcEnterData);
    //                     // lfm_CalcCostEnterData.RUNMODAL;
    //                 END;

    //             vop_EntryType::Container:
    //                 BEGIN
    //                     // Filter auf die Erfassungssätze setzen
    //                     lrc_CostCalcEnterData.RESET();
    //                     lrc_CostCalcEnterData.FILTERGROUP(2);
    //                     lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //                     lrc_CostCalcEnterData.FILTERGROUP(0);
    //                 END;

    //             vop_EntryType::"Master Batch":
    //                 BEGIN
    //                     lrc_MasterBatch.GET(vco_EntryCode);
    //                     // Filter auf die Erfassungssätze setzen
    //                     lrc_CostCalcEnterData.RESET();
    //                     //      lrc_CostCalcEnterData.FILTERGROUP(2);
    //                     lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //                     lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");
    //                     lrc_CostCalcEnterData.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                     //      lrc_CostCalcEnterData.FILTERGROUP(0);

    //                     // vco_CostCategoryCode
    //                     // vin_EntryLevel ( ,Voyage,Container,Master Batch,Batch)
    //                     // vco_MasterBatchNo
    //                     // vco_BatchNoCode
    //                     // vco_VoyageNoCode
    //                     // vco_ContainerNo
    //                     // lfm_CalcCostEnterData.SetGlobals('', 3, lrc_MasterBatch."No.", '', '', '');//TODO: page

    //                     // lfm_CalcCostEnterData.SETTABLEVIEW(lrc_CostCalcEnterData);
    //                     // lfm_CalcCostEnterData.RUNMODAL;

    //                     // Erfasste Kosten umlegen auf Positionen und Positionsvarianten
    //                     IF lrc_CostCalcEnterData.FINDSET(FALSE, FALSE) THEN
    //                         REPEAT
    //                             AllocateCostPerEnterDataRec(lrc_CostCalcEnterData);
    //                         UNTIL lrc_CostCalcEnterData.NEXT() = 0;

    //                     // LoopAllocateEnterData(USERID,0);
    //                 END;

    //             vop_EntryType::All:
    //                 ;
    //         END;
    //     end;

    //     procedure LoadCostCatAllMasterBatch(vco_VoyageNo: Code[20]; vbn_DeleteAllBefore: Boolean; vbn_CheckCostSchema: Boolean)
    //     var
    //         lrc_MasterBatch: Record "POI Master Batch";
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // Kostenkategorien für alle Partien aufbauen
    //         // ---------------------------------------------------------------------------------------------------------

    //         lrc_MasterBatch.RESET();
    //         IF vco_VoyageNo <> '' THEN
    //             lrc_MasterBatch.SETRANGE("Voyage No.", vco_VoyageNo);
    //         IF lrc_MasterBatch.FINDFIRST() THEN BEGIN
    //             REPEAT
    //                 LoadCostCat(lrc_MasterBatch."Voyage No.", '', lrc_MasterBatch."No.", '', vbn_DeleteAllBefore, vbn_CheckCostSchema, FALSE, FALSE);
    //             UNTIL lrc_MasterBatch.NEXT() = 0;
    //         END;
    //     end;

    //     procedure LoadCostCat(vco_VoyageNo: Code[20]; vco_ContainerNo: Code[20]; vco_MasterBatchNo: Code[20]; vco_SalesOrderNo: Code[20]; vbn_DeleteAllBefore: Boolean; vbn_CheckCostSchema: Boolean; NoEnteredCostCheck: Boolean; NoPostedCostCheck: Boolean)
    //     var
    //         lrc_CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_CostCategory: Record "POI Cost Category";
    //         lrc_Voyage: Record "POI Voyage";
    //         lrc_CostSchemaLine: Record "POI Cost Schema Line";
    //         lrc_CostCalcCategories: Record "5087942";
    //         lcu_PostedCostMgt: Codeunit "5110359";
    //         lco_CostSchemaName: Code[20];
    //         lbn_InsertCostCategory: Boolean;
    //         Level: Option Voyage,Container,"Master Batch";
    //         SalesOrder: Record "Sales Header";
    //         FreightMgt: Codeunit "5110313";
    //         ldc_PostedCostCostCat: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------
    //         // Alle Kostenkategorien für eine Reise / Container / Partie laden
    //         // ---------------------------------------------------------------------------------------------------------

    //         // ---------------------------------------------------------------------------------------
    //         // Kostenkategorien zu einer Reise anlegen
    //         // ---------------------------------------------------------------------------------------
    //         IF lrc_Voyage.GET(vco_VoyageNo) THEN BEGIN
    //             // Kostenschema welches zur Prüfung verwendet werden soll
    //             lco_CostSchemaName := '';
    //             IF vbn_CheckCostSchema THEN BEGIN
    //                 lco_CostSchemaName := CheckCostSchema(lrc_Voyage."No.", '', '');
    //             END;

    //             // Alle bereits vorhandenen Kombinationen vorher löschen
    //             IF vbn_DeleteAllBefore THEN BEGIN
    //                 lrc_CostCalcCostCategories.RESET();
    //                 lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level", "Voyage No.", "Container No.", "Batch No.", "Cost Category Code");
    //                 lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::Voyage);
    //                 lrc_CostCalcCostCategories.SETRANGE("Voyage No.", lrc_Voyage."No.");
    //                 lrc_CostCalcCostCategories.DELETEALL();
    //             END;


    //             lrc_CostCategory.RESET();
    //             IF lrc_CostCategory.FINDSET() THEN BEGIN
    //                 REPEAT

    //                     lbn_InsertCostCategory := TRUE;

    //                     IF (lrc_CostCategory."Cost Type General" = lrc_CostCategory."Cost Type General"::Provision) OR
    //                        (lrc_CostCategory."Cost Type General" = lrc_CostCategory."Cost Type General"::Commission) THEN BEGIN
    //                         lbn_InsertCostCategory := FALSE;
    //                     END;

    //                     // Prüfen ob Kostenkategorie in bezogenem Kostenschema vorhanden ist
    //                     IF lco_CostSchemaName <> '' THEN BEGIN
    //                         IF NOT lrc_CostCategory."Reduce Cost from Turnover" THEN BEGIN
    //                             lrc_CostSchemaLine.RESET();
    //                             lrc_CostSchemaLine.SETRANGE("Cost Schema Code", lco_CostSchemaName);
    //                             lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
    //                             lrc_CostSchemaLine.SETRANGE(Totaling, lrc_CostCategory.Code);
    //                             IF NOT lrc_CostSchemaLine.FINDFIRST() THEN BEGIN
    //                                 lbn_InsertCostCategory := FALSE;

    //                                 // Eventuell bestehen Eintrag löschen
    //                                 lrc_CostCalcCostCategories.RESET();
    //                                 lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level", "Voyage No.", "Container No.", "Batch No.", "Cost Category Code");
    //                                 lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::Voyage);
    //                                 lrc_CostCalcCostCategories.SETRANGE("Voyage No.", vco_VoyageNo);
    //                                 lrc_CostCalcCostCategories.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                                 IF NOT lrc_CostCalcCostCategories.isempty()THEN
    //                                     lrc_CostCalcCostCategories.DELETEALL();
    //                             END;
    //                         END;
    //                     END;

    //                 UNTIL lrc_CostCategory.NEXT() = 0;
    //             END;

    //         END;


    //         // ---------------------------------------------------------------------------------------
    //         // Kostenkategorien zu einem Container anlegen
    //         // ---------------------------------------------------------------------------------------
    //         vco_ContainerNo := '';
    //         IF vco_ContainerNo <> '' THEN BEGIN
    //             ERROR('Nicht verfügbar!');
    //         END;


    //         // ---------------------------------------------------------------------------------------
    //         // Kostenkategorien zu einer Partie anlegen
    //         // ---------------------------------------------------------------------------------------
    //         IF lrc_MasterBatch.GET(vco_MasterBatchNo) THEN BEGIN

    //             // Kostenschema welches zur Prüfung verwendet werden soll
    //             lco_CostSchemaName := '';
    //             IF vbn_CheckCostSchema THEN BEGIN
    //                 lco_CostSchemaName := CheckCostSchema('', '', lrc_MasterBatch."No.");
    //             END;

    //             // Alle bereits vorhandenen Kombinationen vorher löschen
    //             IF vbn_DeleteAllBefore THEN BEGIN
    //                 lrc_CostCalcCostCategories.RESET();
    //                 lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level", "Master Batch No.", "Cost Category Code");
    //                 lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::"Master Batch");
    //                 lrc_CostCalcCostCategories.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                 lrc_CostCalcCostCategories.DELETEALL();
    //             END;

    //             // Temp Tabelle mit Kostenkategorien löschen (für Erfassung über Matrix)
    //             lrc_CostCalcCategories.RESET();
    //             lrc_CostCalcCategories.SETRANGE("User Id", UserID());
    //             lrc_CostCalcCategories.DELETEALL();


    //             // Alle Kostenkategorien lesen
    //             lrc_CostCategory.RESET();
    //             IF lrc_CostCategory.FINDSET() THEN BEGIN
    //                 REPEAT

    //                     lbn_InsertCostCategory := TRUE;

    //                     IF (lrc_CostCategory."Cost Type General" = lrc_CostCategory."Cost Type General"::Provision) OR
    //                        (lrc_CostCategory."Cost Type General" = lrc_CostCategory."Cost Type General"::Commission) THEN BEGIN
    //                         lbn_InsertCostCategory := FALSE;
    //                     END;

    //                     // Prüfen ob Kostenkategorie in bezogenem Kostenschema vorhanden ist
    //                     IF lco_CostSchemaName <> '' THEN BEGIN

    //                         // TEST
    //                         // IF not lrc_CostCategory."Reduce Cost from Turnover" THEN BEGIN
    //                         // TEST

    //                         // Prüfen, ob Plan oder gebuchte Kosten für diese Kategorie vorhanden sind
    //                         // IFW 001 EXO40002.s
    //                         IF CheckCostCatValues(lrc_CostCategory, Level::"Master Batch", lrc_MasterBatch."No.", NoEnteredCostCheck,
    //                                                                                                            NoPostedCostCheck) THEN BEGIN
    //                             lbn_InsertCostCategory := TRUE;
    //                         END ELSE BEGIN

    //                             lrc_CostCalcCostCategories.RESET();
    //                             lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level", "Master Batch No.", "Cost Category Code");
    //                             lrc_CostCalcCostCategories.SETRANGE("Entry Level",
    //                               lrc_CostCalcCostCategories."Entry Level"::"Master Batch");
    //                             lrc_CostCalcCostCategories.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                             lrc_CostCalcCostCategories.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                             IF lrc_CostCalcCostCategories.FINDFIRST() THEN BEGIN

    //                                 //To-do              IF NOT lrc_CostCalcCostCategories."Manually Entered" THEN BEGIN
    //                                 // IFW 001 EXO40002.e
    //                                 lrc_CostSchemaLine.RESET();
    //                                 lrc_CostSchemaLine.SETRANGE("Cost Schema Code", lco_CostSchemaName);
    //                                 lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
    //                                 lrc_CostSchemaLine.SETRANGE(Totaling, lrc_CostCategory.Code);
    //                                 IF NOT lrc_CostSchemaLine.FINDFIRST() THEN BEGIN
    //                                     lbn_InsertCostCategory := FALSE;

    //                                     // Eventuell bestehen Eintrag löschen
    //                                     lrc_CostCalcCostCategories.RESET();
    //                                     lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level", "Master Batch No.", "Cost Category Code");
    //                                     lrc_CostCalcCostCategories.SETRANGE("Entry Level",
    //                                                                         lrc_CostCalcCostCategories."Entry Level"::"Master Batch");
    //                                     lrc_CostCalcCostCategories.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                                     lrc_CostCalcCostCategories.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                                     IF NOT lrc_CostCalcCostCategories.isempty()THEN
    //                                         lrc_CostCalcCostCategories.DELETEALL();
    //                                 END;
    //                                 // IFW 001 EXO40002.s
    //                                 //              END;

    //                             END ELSE BEGIN
    //                                 lrc_CostSchemaLine.RESET();
    //                                 lrc_CostSchemaLine.SETRANGE("Cost Schema Code", lco_CostSchemaName);
    //                                 lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
    //                                 lrc_CostSchemaLine.SETRANGE(Totaling, lrc_CostCategory.Code);
    //                                 IF lrc_CostSchemaLine.isempty()THEN BEGIN
    //                                     lbn_InsertCostCategory := FALSE;
    //                                 END;
    //                             END;

    //                         END;
    //                         // IFW 001 EXO40002.e

    //                         // TEST
    //                         // END;
    //                         // TEST

    //                     END;


    //                     IF lbn_InsertCostCategory THEN BEGIN
    //                         //RS gebuchte Kosten ermitteln
    //                         ldc_PostedCostCostCat := 0;
    //                         lcu_PostedCostMgt.CalcPostedCost(lrc_MasterBatch."No.", lrc_CostCategory.Code);
    //                         // Temp Tabelle mit Kostenkategorien füllen (für Erfassung über Matrix)
    //                         lrc_CostCalcCategories.RESET();
    //                         lrc_CostCalcCategories.INIT();
    //                         lrc_CostCalcCategories."User Id" := USERID;
    //                         lrc_CostCalcCategories."Cost Category Code" := lrc_CostCategory.Code;
    //                         lrc_CostCalcCategories."Cost Category Description" := lrc_CostCategory.Description;
    //                         lrc_CostCalcCategories."Sort Order" := lrc_CostSchemaLine."Line No.";
    //                         lrc_CostCalcCategories.insert();

    //                         // Kostenkategorie Ebene Partie eintragen
    //                         lrc_CostCalcCostCategories.RESET();
    //                         lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level", "Master Batch No.", "Cost Category Code");
    //                         lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::"Master Batch");
    //                         lrc_CostCalcCostCategories.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                         lrc_CostCalcCostCategories.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                         IF lrc_CostCalcCostCategories.isempty()THEN BEGIN
    //                             lrc_CostCalcCostCategories.RESET();
    //                             lrc_CostCalcCostCategories.INIT();
    //                             lrc_CostCalcCostCategories."Entry Level" := lrc_CostCalcCostCategories."Entry Level"::"Master Batch";
    //                             lrc_CostCalcCostCategories."Voyage No." := lrc_MasterBatch."Voyage No.";
    //                             lrc_CostCalcCostCategories."Container No." := lrc_MasterBatch."Container Code";
    //                             lrc_CostCalcCostCategories."Master Batch No." := lrc_MasterBatch."No.";
    //                             lrc_CostCalcCostCategories."Batch No." := '';
    //                             lrc_CostCalcCostCategories."Cost Category Code" := lrc_CostCategory.Code;
    //                             lrc_CostCalcCostCategories."Reduce Cost from Turnover" := lrc_CostCategory."Reduce Cost from Turnover";
    //                             lrc_CostCalcCostCategories."Indirect Cost (Purchase)" := lrc_CostCategory."Indirect Cost (Purchase)";
    //                             lrc_CostCalcCostCategories."Product Group Code" := '';
    //                             lrc_CostCalcCostCategories."Posted Amt (LCY)" := ldc_PostedCostCostCat;
    //                             lrc_CostCalcCostCategories.INSERT(TRUE);
    //                         END ELSE BEGIN
    //                             IF lrc_CostCalcCostCategories.FIND('-') THEN BEGIN
    //                                 lrc_CostCalcCostCategories."Posted Amt (LCY)" := ldc_PostedCostCostCat;
    //                                 lrc_CostCalcCostCategories.MODIFY();
    //                             END;
    //                         END;

    //                         // --------------------------------------------------------------------
    //                         // Vorbelegungsbetrag berechnen
    //                         // --------------------------------------------------------------------



    //                     END;

    //                 UNTIL lrc_CostCategory.NEXT() = 0;
    //             END;

    //         END;

    //     end;

    //     procedure LoadCostCatPerBatch(vco_VoyageNo: Code[20]; vco_MasterBatch: Code[20]; vco_Batch: Code[20])
    //     var
    //         lrc_Batch: Record "POI Batch";
    //         lrc_CostCategory: Record "POI Cost Category";
    //         lrc_CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zum Laden aller Kostenkategorien pro Position
    //         // ----------------------------------------------------------------------------------------------

    //         IF vco_VoyageNo <> '' THEN
    //             lrc_Batch.SETRANGE("Voyage No.", vco_VoyageNo);
    //         IF vco_MasterBatch <> '' THEN
    //             lrc_Batch.SETRANGE("Master Batch No.", vco_MasterBatch);
    //         IF vco_Batch <> '' THEN
    //             lrc_Batch.SETRANGE("No.", vco_Batch);
    //         IF lrc_Batch.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT

    //                 lrc_CostCategory.SETRANGE("Indirect Cost (Purchase)", TRUE);
    //                 IF lrc_CostCategory.FINDSET(FALSE, FALSE) THEN BEGIN
    //                     REPEAT

    //                         lrc_CostCalcEnterData.RESET();
    //                         lrc_CostCalcEnterData.INIT();
    //                         lrc_CostCalcEnterData."Document No." := 0;
    //                         lrc_CostCalcEnterData.VALIDATE("Cost Category Code", lrc_CostCategory.Code);
    //                         lrc_CostCalcEnterData."Master Batch No." := lrc_Batch."Master Batch No.";
    //                         lrc_CostCalcEnterData."Batch No." := lrc_Batch."No.";
    //                         lrc_CostCalcEnterData."Batch Variant No." := '';
    //                         lrc_CostCalcEnterData."Entry Level" := lrc_CostCalcEnterData."Entry Level"::"Master Batch";
    //                         lrc_CostCalcEnterData."Entry Type" := lrc_CostCalcEnterData."Entry Type"::"Enter Data";
    //                         lrc_CostCalcEnterData."Document No. 2" := '';
    //                         lrc_CostCalcEnterData."Reduce Cost from Turnover" := lrc_CostCategory."Reduce Cost from Turnover";
    //                         lrc_CostCalcEnterData."Indirect Cost (Purchase)" := lrc_CostCategory."Indirect Cost (Purchase)";
    //                         lrc_CostCalcEnterData.INSERT(TRUE);

    //                     UNTIL lrc_CostCategory.NEXT() = 0;
    //                 END;


    //             UNTIL lrc_Batch.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CheckCostSchema(vco_VoyageNo: Code[20]; vco_ContainerNo: Code[20]; vco_MasterBatchNo: Code[20]): Code[20]
    //     var
    //         lrc_BatchVariant: Record "POI Batch Variant";
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_Vendor: Record Vendor;
    //         lco_CostSchemaName: Code[20];
    //         lrc_MasterBatch: Record "POI Master Batch";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung des zugrunde liegenden Kostenschematas über den Lieferanten
    //         // ----------------------------------------------------------------------------------------------

    //         lrc_BatchVariant.RESET();
    //         IF vco_VoyageNo <> '' THEN BEGIN
    //             lrc_BatchVariant.SETCURRENTKEY("Voyage No.");
    //             lrc_BatchVariant.SETRANGE("Voyage No.", vco_VoyageNo);
    //         END;
    //         IF vco_ContainerNo <> '' THEN BEGIN
    //             lrc_BatchVariant.SETRANGE("Container No.", vco_ContainerNo);
    //         END;
    //         IF vco_MasterBatchNo <> '' THEN BEGIN
    //             lrc_BatchVariant.SETCURRENTKEY("Master Batch No.", "Batch No.");
    //             lrc_BatchVariant.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //             //RS
    //             lrc_MasterBatch.GET(vco_MasterBatchNo);
    //         END;


    //         /***********
    //         //RS erst Kostenschema aus Partie, dann aus Kreditor
    //         lrc_BatchVariant.SETFILTER("Vendor No.",'<>%1','');
    //         IF lrc_BatchVariant.FINDFIRST() THEN BEGIN
    //           lrc_MasterBatch.GET(lrc_BatchVariant."Master Batch No.");
    //           IF lrc_MasterBatch."Cost Schema Name Code" <> '' THEN BEGIN
    //             lco_CostSchemaName := lrc_MasterBatch."Cost Schema Name Code"
    //           END ELSE BEGIN
    //             IF lrc_Vendor.GET(lrc_BatchVariant."Vendor No.") THEN BEGIN
    //               lco_CostSchemaName := lrc_Vendor."A.S. Cost Schema Name Code";
    //             END;
    //           END;
    //         END;
    //         ***********/

    //         //RS Kostenschema immer aus Master Batch
    //         IF lrc_MasterBatch."Cost Schema Name Code" <> '' THEN
    //             lco_CostSchemaName := lrc_MasterBatch."Cost Schema Name Code";

    //         // Standard Kostenschema laden, wenn kein anderes gefunden wurde
    //         IF lco_CostSchemaName = '' THEN BEGIN
    //             lrc_FruitVisionSetup.GET();
    //             lco_CostSchemaName := lrc_FruitVisionSetup."Purch. Cost Schema Name";
    //         END;

    //         EXIT(lco_CostSchemaName);

    //     end;

    //     procedure CostCatCalcTotals(vop_EntryType: Option Voyage,Container,"Master Batch","Sales Order"; vco_EntryCode: Code[20]; vco_CostCategoryCode: Code[20]; ReloadCostCat: Boolean)
    //     var
    //         lrc_CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Summen je Kostenkategorie und Ebene (Reise,Container,Partie)
    //         // ----------------------------------------------------------------------------------------------

    //         IF ReloadCostCat THEN BEGIN

    //             // Kontrolle ob Datensätze Kostenkategorie für Reise / Container / Partie aufgebaut sind
    //             IF vco_EntryCode <> '' THEN BEGIN
    //                 CASE vop_EntryType OF
    //                     vop_EntryType::Voyage:
    //                         LoadCostCat(vco_EntryCode, '', '', '', FALSE, FALSE, FALSE, FALSE);
    //                     vop_EntryType::Container:
    //                         LoadCostCat('', vco_EntryCode, '', '', FALSE, FALSE, FALSE, FALSE);
    //                     vop_EntryType::"Master Batch":
    //                         LoadCostCat('', '', vco_EntryCode, '', FALSE, TRUE
    //                                     , FALSE, FALSE); // TEST: Letzter Parameter von FALSE auf TRUE
    //                                                      // EXO40091.S
    //                     vop_EntryType::"Sales Order":
    //                         LoadCostCat('', '', '', vco_EntryCode, FALSE, TRUE, FALSE, FALSE);
    //                 // EXO40091.E
    //                 END;
    //             END;

    //         END;
    //         //RS Berechnung CostCalcCostCategories auskommentiert, in Tab Feld als FlowField definiert
    //         //{****************************************
    //         // Kostenkategorien entsprechend der Übergabeparameter filtern und lesen
    //         lrc_CostCalcCostCategories.RESET();
    //         IF vco_EntryCode <> '' THEN BEGIN
    //             CASE vop_EntryType OF
    //                 vop_EntryType::Voyage:
    //                     BEGIN
    //                         lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level");
    //                         lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::Voyage);
    //                         lrc_CostCalcCostCategories.SETRANGE("Voyage No.", vco_EntryCode);
    //                     END;
    //                 vop_EntryType::Container:
    //                     BEGIN
    //                         lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level");
    //                         lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::Container);
    //                         lrc_CostCalcCostCategories.SETRANGE("Container No.", vco_EntryCode);
    //                     END;
    //                 vop_EntryType::"Master Batch":
    //                     BEGIN
    //                         lrc_CostCalcCostCategories.SETCURRENTKEY("Entry Level");
    //                         lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::"Master Batch");
    //                         lrc_CostCalcCostCategories.SETRANGE("Master Batch No.", vco_EntryCode);
    //                     END;
    //             END;
    //         END;
    //         IF vco_CostCategoryCode <> '' THEN BEGIN
    //             lrc_CostCalcCostCategories.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //         END;
    //         IF lrc_CostCalcCostCategories.FINDSET() THEN BEGIN
    //             REPEAT

    //                 lrc_CostCalcCostCategories."Entered Amt (LCY)" := 0;
    //                 lrc_CostCalcCostCategories."Released Amt (LCY)" := 0;

    //                 lrc_CostCalcEnterData.RESET();
    //                 lrc_CostCalcEnterData.SETCURRENTKEY("Entry Type");
    //                 //RS Filtersetzung nicht auf "Detail Batch" sondern auf "Enter Data"
    //                 //lrc_CostCalcEnterData.SETRANGE("Entry Type",lrc_CostCalcEnterData."Entry Type"::"Detail Batch");
    //                 lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //                 lrc_CostCalcEnterData.SETRANGE("Cost Category Code", lrc_CostCalcCostCategories."Cost Category Code");

    //                 // Abgrenzung in Abhängigkeit der Ebene der Kostenkategorie
    //                 // TEST.s
    //                 CASE lrc_CostCalcCostCategories."Entry Level" OF
    //                     lrc_CostCalcCostCategories."Entry Level"::Voyage:
    //                         BEGIN
    //                             lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::Voyage);
    //                             lrc_CostCalcEnterData.SETRANGE("Voyage No.", lrc_CostCalcCostCategories."Voyage No.");
    //                         END;
    //                     lrc_CostCalcCostCategories."Entry Level"::Container:
    //                         BEGIN
    //                             lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::Container);
    //                             lrc_CostCalcEnterData.SETRANGE("Container No.", lrc_CostCalcCostCategories."Container No.");
    //                         END;
    //                     lrc_CostCalcCostCategories."Entry Level"::"Master Batch":
    //                         BEGIN
    //                             lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");
    //                             lrc_CostCalcEnterData.SETRANGE("Master Batch No.", lrc_CostCalcCostCategories."Master Batch No.");
    //                         END;
    //                 END;
    //                 // TEST.e

    //                 IF lrc_CostCalcEnterData.FINDSET() THEN BEGIN
    //                     REPEAT
    //                         lrc_CostCalcCostCategories."Entered Amt (LCY)" := lrc_CostCalcCostCategories."Entered Amt (LCY)" +
    //                                                                           lrc_CostCalcEnterData."Amount (LCY)";
    //                         IF lrc_CostCalcEnterData.Released THEN BEGIN
    //                             lrc_CostCalcCostCategories."Released Amt (LCY)" := lrc_CostCalcCostCategories."Released Amt (LCY)" +
    //                                                                             lrc_CostCalcEnterData."Amount (LCY)";
    //                         END;
    //                     UNTIL lrc_CostCalcEnterData.NEXT() = 0;
    //                 END;

    //                 CalcDifferenceAmt(lrc_CostCalcCostCategories);

    //                 lrc_CostCalcCostCategories.MODIFY();

    //             UNTIL lrc_CostCalcCostCategories.NEXT() = 0;
    //         END;
    //         //*********************************//RS.e}
    //     end;

    //     procedure "-"()
    //     begin
    //     end;

    //     procedure EnterCalcCostPerCostCat(vop_EntryType: Option Voyage,Container,"Master Batch","Sales Order"; vco_EntryCode: Code[20])
    //     var
    //         lcu_PostedCostMgt: Codeunit "5110359";
    //         lrc_Voyage: Record "POI Voyage";
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";
    //         //lfm_Voyage: Form "POI Voyage";
    //         //lfm_MasterBatchList: Form "POI Batch Temp";
    //         //lfm_CalcCostCostCategory: Form "5087949";
    //         lop_AllocationLevel: Option "All Level","Cost Category","Cost Category+Voyage","Cost Category+Voyage+Master Batch",Voyage,"Master Batch","Cost Category+Master Batch";
    //         SalesOrder: Record "Sales Header";
    //         CostCategory: Record "POI Cost Category";
    //         FreightMgt: Codeunit "5110313";
    //         lco_CostSchemaName: Code[20];
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         // Funktion zur Eingabe von Plankosten über die Kostenkategorien
    //         // über Ebene Reise, Container oder Partie
    //         // ----------------------------------------------------------------------------------------------

    //         // EXO40091:
    //         // Erweiterung um Sales Order

    //         CASE vop_EntryType OF
    //             // ----------------------------------------------------------------------------------------
    //             vop_EntryType::Voyage:
    //                 // ----------------------------------------------------------------------------------------
    //                 BEGIN

    //                     // Reisenummer aus Liste auswählen, falls keine übergeben wurde
    //                     IF vco_EntryCode = '' THEN BEGIN
    //                         lfm_Voyage.LOOKUPMODE := TRUE;
    //                         lfm_Voyage.EDITABLE := FALSE;
    //                         IF lfm_Voyage.RUNMODAL <> ACTION::LookupOK THEN
    //                             EXIT;
    //                         lfm_Voyage.GETRECORD(lrc_Voyage);
    //                     END ELSE BEGIN
    //                         lrc_Voyage.GET(vco_EntryCode);
    //                     END;

    //                     // Kostenkategorien prüfen und gegebenenfalls laden
    //                     LoadCostCat(lrc_Voyage."No.", '', '', '', FALSE, TRUE, FALSE, FALSE);
    //                     COMMIT;

    //                     lrc_CostCalcCostCategories.RESET();
    //                     lrc_CostCalcCostCategories.FILTERGROUP(2);
    //                     lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::Voyage);
    //                     lrc_CostCalcCostCategories.SETRANGE("Voyage No.", lrc_Voyage."No.");
    //                     lrc_CostCalcCostCategories.FILTERGROUP(0);

    //                     lfm_CalcCostCostCategory.SETTABLEVIEW(lrc_CostCalcCostCategories);
    //                     lfm_CalcCostCostCategory.RUNMODAL;

    //                 END;


    //             // ----------------------------------------------------------------------------------------
    //             vop_EntryType::Container:
    //                 // ----------------------------------------------------------------------------------------
    //                 BEGIN
    //                     ERROR('Funktionalität steht nicht zur Verfügung!');
    //                 END;


    //             // ----------------------------------------------------------------------------------------
    //             vop_EntryType::"Master Batch":
    //                 // ----------------------------------------------------------------------------------------
    //                 BEGIN

    //                     // Partienummer aus Liste auswählen, falls keine übergeben wurde
    //                     IF vco_EntryCode = '' THEN BEGIN
    //                         lfm_MasterBatchList.LOOKUPMODE := TRUE;
    //                         IF lfm_MasterBatchList.RUNMODAL <> ACTION::LookupOK THEN
    //                             EXIT;
    //                         lfm_MasterBatchList.GETRECORD(lrc_MasterBatch);
    //                     END ELSE BEGIN
    //                         lrc_MasterBatch.GET(vco_EntryCode);
    //                     END;

    //                     // Kostenkategorien prüfen und gegebenenfalls laden
    //                     LoadCostCat('', '', lrc_MasterBatch."No.", '', FALSE, TRUE, FALSE, FALSE);


    //                     lrc_CostCalcCostCategories.RESET();
    //                     lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::"Master Batch");
    //                     lrc_CostCalcCostCategories.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                     IF lrc_CostCalcCostCategories.FINDSET() THEN BEGIN
    //                         REPEAT
    //                             CalcPostCostMasterBatchCostCat(lrc_CostCalcCostCategories."Entry No."); // To-Do ,FALSE,FALSE);
    //                                                                                                     //RS gebuchte Kosten ermitteln
    //                             lcu_PostedCostMgt.CalcPostedCost(lrc_CostCalcCostCategories."Cost Category Code", lrc_MasterBatch."No.");
    //                         UNTIL lrc_CostCalcCostCategories.NEXT() = 0;
    //                     END;

    //                     // IFW 001 EXO40002.s
    //                     //RS auskommentiert, nur laden bei expliziter Auswahl
    //                     //CreateStandardPlanCost(lrc_MasterBatch."No.");
    //                     // IFW 001 EXO40002.e

    //                     COMMIT;


    //                     lrc_CostCalcCostCategories.RESET();
    //                     lrc_CostCalcCostCategories.FILTERGROUP(2);
    //                     lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::"Master Batch");
    //                     lrc_CostCalcCostCategories.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                     lrc_CostCalcCostCategories.FILTERGROUP(0);

    //                     lfm_CalcCostCostCategory.SETTABLEVIEW(lrc_CostCalcCostCategories);
    //                     lfm_CalcCostCostCategory.RUNMODAL;

    //                 END;

    //         END;
    //     end;

    //     procedure EnterDataByRecCalcCost(vrc_CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";)
    //     begin
    //         // --------------------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung der Kosten zu einer bestimmten Kostenkategorie mit einer bestimmten Ebene
    //         // Übergeben wird der Kostenkategorien Satz
    //         // --------------------------------------------------------------------------------------------------

    //         CASE vrc_CostCalcCostCategories."Entry Level" OF
    //             vrc_CostCalcCostCategories."Entry Level"::Voyage:
    //                 EnterDataCalcCostByCostCat(0, vrc_CostCalcCostCategories."Voyage No.",
    //                                              vrc_CostCalcCostCategories."Cost Category Code");

    //             vrc_CostCalcCostCategories."Entry Level"::Container:
    //                 EnterDataCalcCostByCostCat(1, vrc_CostCalcCostCategories."Container No.",
    //                                              vrc_CostCalcCostCategories."Cost Category Code");

    //             vrc_CostCalcCostCategories."Entry Level"::"Master Batch":
    //                 EnterDataCalcCostByCostCat(2, vrc_CostCalcCostCategories."Master Batch No.",
    //                                              vrc_CostCalcCostCategories."Cost Category Code");

    //             vrc_CostCalcCostCategories."Entry Level"::Batch:
    //                 EnterDataCalcCostByCostCat(3, vrc_CostCalcCostCategories."Batch No.",
    //                                              vrc_CostCalcCostCategories."Cost Category Code");
    //         END;
    //     end;

    //     procedure EnterDataCalcCostByCostCat(vop_EntryType: Option Voyage,Container,"Master Batch","Sales Order"; vco_EntryCode: Code[20]; vco_CostCategoryCode: Code[20])
    //     var
    //         lrc_CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCategory: Record "POI Cost Category";
    //         //lfm_CalcCostEnterData: Form "5087950";
    //         AGILES_LT_TEXT001: Label 'Satzart %1 nicht zulässig!';
    //     begin
    //         // -----------------------------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung der Kosten zu einer Kostenkategorie auf einer Ebene (Reise, Conatiner oder Partie)
    //         // -----------------------------------------------------------------------------------------------------------

    //         lrc_CostCategory.GET(vco_CostCategoryCode);

    //         lrc_CostCalcCostCategories.RESET();

    //         CASE vop_EntryType OF
    //             vop_EntryType::Voyage:
    //                 BEGIN
    //                     lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::Voyage);
    //                     lrc_CostCalcCostCategories.SETRANGE("Voyage No.", vco_EntryCode);
    //                     lrc_CostCalcCostCategories.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                 END;
    //             vop_EntryType::Container:
    //                 BEGIN
    //                     lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::Container);
    //                     lrc_CostCalcCostCategories.SETRANGE("Container No.", vco_EntryCode);
    //                     lrc_CostCalcCostCategories.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                 END;
    //             vop_EntryType::"Master Batch":
    //                 BEGIN
    //                     lrc_CostCalcCostCategories.SETRANGE("Entry Level", lrc_CostCalcCostCategories."Entry Level"::"Master Batch");
    //                     lrc_CostCalcCostCategories.SETRANGE("Master Batch No.", vco_EntryCode);
    //                     lrc_CostCalcCostCategories.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                 END;

    //         END;
    //         lrc_CostCalcCostCategories.FINDFIRST();


    //         // Bestehende Erfassungssätze abgrenzen
    //         lrc_CostCalcEnterData.RESET();
    //         lrc_CostCalcEnterData.SETCURRENTKEY("Entry Type", "Entry Level", "Cost Category Code",
    //                                             "Voyage No.", "Container No.", "Master Batch No.", "Batch No.");
    //         lrc_CostCalcEnterData.FILTERGROUP(2);
    //         lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //         CASE vop_EntryType OF
    //             vop_EntryType::Voyage:
    //                 BEGIN
    //                     lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::Voyage);
    //                     lrc_CostCalcCostCategories.TESTFIELD("Voyage No.");
    //                     lrc_CostCalcEnterData.SETRANGE("Voyage No.", lrc_CostCalcCostCategories."Voyage No.");
    //                 END;
    //             vop_EntryType::Container:
    //                 BEGIN
    //                     lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::Container);
    //                     lrc_CostCalcCostCategories.TESTFIELD("Container No.");
    //                     lrc_CostCalcEnterData.SETRANGE("Container No.", lrc_CostCalcCostCategories."Container No.");
    //                 END;
    //             vop_EntryType::"Master Batch":
    //                 BEGIN
    //                     lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");
    //                     lrc_CostCalcCostCategories.TESTFIELD("Master Batch No.");
    //                     lrc_CostCalcEnterData.SETRANGE("Master Batch No.", lrc_CostCalcCostCategories."Master Batch No.");
    //                 END;
    //         END;

    //         lrc_CostCalcEnterData.SETRANGE("Cost Category Code", lrc_CostCategory.Code);

    //         // Übergabe des Kostenkategoriesatzes mit Ebene
    //         // To-Do lfm_CalcCostEnterData.SetGlobals(lrc_CostCalcCostCategories);
    //         // Setzen der vorhandenen Erfassungssätze
    //         lfm_CalcCostEnterData.SETTABLEVIEW(lrc_CostCalcEnterData);
    //         //RS Übergabe gco_MasterBatchNo als Vorgabe für neue Zeilen
    //         lfm_CalcCostEnterData.SetGlobals(lrc_CostCalcCostCategories."Cost Category Code", 0,
    //                                          lrc_CostCalcCostCategories."Master Batch No.", '', '', '');
    //         lfm_CalcCostEnterData.RUNMODAL;


    //         // --------------------------------------------------------------------------------------------------------
    //         // Erfasste Kosten umlegen auf Positionen und Positionsvarianten
    //         // --------------------------------------------------------------------------------------------------------
    //         IF lrc_CostCalcEnterData.FINDSET() THEN BEGIN
    //             REPEAT
    //                 IF NOT lrc_CostCalcEnterData.Allocated THEN BEGIN
    //                     AllocateCostPerEnterDataRec(lrc_CostCalcEnterData);

    //                     // TEST
    //                     lrc_CostCalcEnterData.GET(lrc_CostCalcEnterData."Document No.");

    //                     lrc_CostCalcEnterData.Allocated := TRUE;
    //                     lrc_CostCalcEnterData.MODIFY();
    //                 END;
    //             UNTIL lrc_CostCalcEnterData.NEXT() = 0;

    //             //RS.a
    //             //  {
    //             //vormals auskommentierter Bereich wieder aktiviert
    //             // Summen in den Kostenkategorien auf den verschiedenen Ebenen aufaddieren
    //             //RS nur "Master Batch No."
    //             //IF lrc_CostCalcCostCategories."Voyage No." <> '' THEN
    //             //CostCatCalcTotals(0,lrc_CostCalcCostCategories."Voyage No.",lrc_CostCalcCostCategories."Cost Category Code", );
    //             //IF lrc_CostCalcCostCategories."Container No." <> '' THEN
    //             //CostCatCalcTotals(1,lrc_CostCalcCostCategories."Container No.",lrc_CostCalcCostCategories."Cost Category Code");
    //             IF lrc_CostCalcEnterData."Master Batch No." <> '' THEN
    //                 CostCatCalcTotals(2, lrc_CostCalcCostCategories."Master Batch No.", lrc_CostCalcCostCategories."Cost Category Code", FALSE);
    //             //RS.e  }

    //         END;

    //         // Summen in den Kostenkategorien auf den verschiedenen Ebenen aufaddieren
    //         IF lrc_CostCalcCostCategories."Voyage No." <> '' THEN
    //             CostCatCalcTotals(0, lrc_CostCalcCostCategories."Voyage No.", lrc_CostCalcCostCategories."Cost Category Code", TRUE);

    //         IF lrc_CostCalcCostCategories."Container No." <> '' THEN
    //             CostCatCalcTotals(1, lrc_CostCalcCostCategories."Container No.", lrc_CostCalcCostCategories."Cost Category Code", TRUE);

    //         IF lrc_CostCalcCostCategories."Master Batch No." <> '' THEN
    //             CostCatCalcTotals(2, lrc_CostCalcCostCategories."Master Batch No.", lrc_CostCalcCostCategories."Cost Category Code", TRUE);
    //     end;

    procedure AllocateCostPerEnterDataRec(vrc_CostCalculation: Record "POI Cost Calc. - Enter Data")
    var

        lrc_ADFSetup: Record "POI ADF Setup";
        lrc_MasterBatch: Record "POI Master Batch";
        lrc_Batch: Record "POI Batch";
        lrc_Item: Record Item;
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
        ADF_LT_TEXT013Txt: Label 'Entry Type %1 not allowed!', Comment = '%1';
    begin
        // ----------------------------------------------------------------------------------------------
        // Funktion zur Umlage der Kosten eines Erfassungssatzes auf die Positionen und Pos.-Var.
        // ----------------------------------------------------------------------------------------------

        // Kontrolle ob Satzart korrekt
        IF vrc_CostCalculation."Entry Type" <> vrc_CostCalculation."Entry Type"::"Enter Data" THEN
            // Satzart %1 nicht zulässig!
            ERROR(ADF_LT_TEXT013Txt, vrc_CostCalculation."Entry Type");

        // Keine erneute Verteilung falls Saz bereits verteilt ist
        IF vrc_CostCalculation.Allocated THEN
            EXIT;

        // probeweiser mal neuer Code von IW
        // Detailzeilen "Batch Variant" löschen
        lrc_CostCalcDetailBatchVar.RESET();
        lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Attached to Entry No.");
        lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
        lrc_CostCalcDetailBatchVar.SETRANGE("Attached to Entry No.", vrc_CostCalculation."Document No.");
        lrc_CostCalcDetailBatchVar.DELETEALL();

        // Detailzeilen "Batch" löschen
        lrc_CostCalcDetailBatch.RESET();
        lrc_CostCalcDetailBatch.SETCURRENTKEY("Entry Type", "Attached to Entry No.");
        lrc_CostCalcDetailBatch.SETRANGE("Entry Type", lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
        lrc_CostCalcDetailBatch.SETRANGE("Attached to Entry No.", vrc_CostCalculation."Document No.");
        lrc_CostCalcDetailBatch.DELETEALL();

        lrc_ADFSetup.GET();
        CASE lrc_ADFSetup."Cost Category Calc. Type" OF
            lrc_ADFSetup."Cost Category Calc. Type"::"Rekursiv von Zeile":
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
                    lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
                    lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                    lrc_PurchLine.SETFILTER("No.", '<>%1', '');
                    IF lrc_PurchLine.FINDSET() THEN
                        REPEAT
                            lrc_CostCalcDetailBatchVar.RESET();
                            lrc_CostCalcDetailBatchVar.INIT();
                            lrc_CostCalcDetailBatchVar."Entry No." := 0;
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
                            IF lrc_CostCalcDetailBatch.FINDFIRST() THEN BEGIN
                                lrc_CostCalcDetailBatch.Amount := lrc_CostCalcDetailBatch.Amount + lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                                lrc_CostCalcDetailBatch."Amount (LCY)" := lrc_CostCalcDetailBatch."Amount (LCY)" +
                                                                          lrc_PurchLine."POI Cost Calc. Amount (LCY)";
                                lrc_CostCalcDetailBatch.MODIFY();
                            END ELSE BEGIN

                                lrc_CostCalcDetailBatch.RESET();
                                lrc_CostCalcDetailBatch.INIT();
                                lrc_CostCalcDetailBatch."Entry No." := 0;
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
            lrc_ADFSetup."Cost Category Calc. Type"::Standard:
                BEGIN

                    // Positionen und Gesamtmengen in Temp. Tabelle laden
                    CASE vrc_CostCalculation."Allocation Level" OF
                        vrc_CostCalculation."Allocation Level"::"Voyage No.":
                            lcu_BatchMgt.LoadBatchNoInBuffer('', vrc_CostCalculation."Voyage No.", '', '', '');
                        vrc_CostCalculation."Allocation Level"::"Container No.":
                            ERROR('Verteilungsebene Container nicht verfügbar!');
                        vrc_CostCalculation."Allocation Level"::"Master Batch No.":
                            lcu_BatchMgt.LoadBatchNoInBuffer(vrc_CostCalculation."Master Batch No.", '', '', '', '');
                        vrc_CostCalculation."Allocation Level"::"Batch No.":
                            ERROR('Verteilungsebene Position nicht verfügbar!');
                    END;

                    // Kontrolle ob Eingrenzung auf bestimmte Positionen und Neuberechnung der Summen
                    RecalcBatchTempAttachAlocBatch(vrc_CostCalculation."Document No.");

                    // Datensatz mit Gesamtsummensatz über Voyage / Master Batch in Temp. Tabelle lesen
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
                    IF NOT lrc_MasterBatchTemp.FINDFIRST() THEN
                        EXIT;


                    // --------------------------------------------------------------------------------------
                    // Von Enter Data auf Detail Batch verteilen
                    // --------------------------------------------------------------------------------------
                    lrc_CostCalculationData.RESET();
                    lrc_CostCalculationData.SETRANGE("Document No.", vrc_CostCalculation."Document No.");
                    IF lrc_CostCalculationData.FINDSET(FALSE, FALSE) THEN
                        REPEAT

                            // --------------------------------------------------------------------------------------------
                            // Verteilung auf die Positionen
                            // --------------------------------------------------------------------------------------------
                            IF lrc_CostCalculationData."Batch No." = '' THEN BEGIN
                                ldc_SumAmount := 0;
                                ldc_SumAmountMW := 0;
                                // Schleife um alle Positionen
                                lrc_BatchTemp.RESET();
                                lrc_BatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                                lrc_BatchTemp.SETRANGE("Userid Code", USERID());
                                lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
                                lrc_BatchTemp.SETRANGE("MCS Without Allocation", FALSE);
                                lrc_BatchTemp.SETFILTER("MCS Quantity Colli", '<>%1', 0);
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
                                        lrc_CostCalcDetailBatch.TRANSFERFIELDS(lrc_CostCalculationData);
                                        lrc_CostCalcDetailBatch."Entry No." := 0;
                                        lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
                                        lrc_CostCalcDetailBatch."Batch No." := lrc_BatchTemp."MCS Batch No.";
                                        lrc_CostCalcDetailBatch."Master Batch No." := lrc_Batch."Master Batch No.";
                                        lrc_CostCalcDetailBatch."Voyage No." := lrc_Batch."Voyage No.";
                                        lrc_CostCalcDetailBatch."Container No." := lrc_Batch."Container No.";
                                        lrc_CostCalcDetailBatch.VALIDATE(Amount, ldc_Amount);
                                        lrc_CostCalcDetailBatch.Price := lrc_CostCalcDetailBatch.Amount;
                                        lrc_CostCalcDetailBatch."Reference Price" := lrc_CostCalcDetailBatch."Reference Price"::Amount;
                                        lrc_CostCalcDetailBatch."Amount (LCY)" := ldc_AmountMW;
                                        lrc_CostCalcDetailBatch."Attached to Entry No." := lrc_CostCalculationData."Document No.";
                                        lrc_CostCalcDetailBatch."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
                                        lrc_CostCalcDetailBatch."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";
                                        lrc_CostCalcDetailBatch.INSERT(TRUE);
                                        ldc_SumAmount := ldc_SumAmount + ldc_Amount;
                                        ldc_SumAmountMW := ldc_SumAmountMW + ldc_AmountMW;
                                    UNTIL lrc_BatchTemp.NEXT() = 0;

                                    // Kontrolle ob verteilter Betrag dem Gesamtbetrag entspricht, Differenz auf letzte Zeile übertragen
                                    IF ldc_SumAmount <> lrc_CostCalculationData.Amount THEN
                                        IF lrc_CostCalcDetailBatch."Entry No." <> 0 THEN BEGIN
                                            ldc_SumAmount := lrc_CostCalculationData.Amount - ldc_SumAmount;
                                            ldc_SumAmountMW := lrc_CostCalculationData."Amount (LCY)" - ldc_SumAmountMW;
                                            lrc_CostCalcDetailBatch.VALIDATE(Amount, (lrc_CostCalcDetailBatch.Amount + ldc_SumAmount));
                                            lrc_CostCalcDetailBatch.MODIFY();
                                        END;


                                END;

                                // --------------------------------------------------------------------------------------------
                                // Erfassungssatz bereits inklusive Angabe Position
                                // --------------------------------------------------------------------------------------------
                            END ELSE BEGIN
                                lrc_Batch.GET(lrc_CostCalculationData."Batch No.");
                                lrc_CostCalcDetailBatch.RESET();
                                lrc_CostCalcDetailBatch.TRANSFERFIELDS(lrc_CostCalculationData);
                                lrc_CostCalcDetailBatch."Entry No." := 0;
                                lrc_CostCalcDetailBatch."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch";
                                lrc_CostCalcDetailBatch."Master Batch No." := lrc_Batch."Master Batch No.";
                                lrc_CostCalcDetailBatch."Voyage No." := lrc_Batch."Voyage No.";
                                lrc_CostCalcDetailBatch."Container No." := lrc_Batch."Container No.";
                                lrc_CostCalcDetailBatch.Price := lrc_CostCalcDetailBatch.Amount;
                                lrc_CostCalcDetailBatch."Reference Price" := lrc_CostCalcDetailBatch."Reference Price"::Amount;
                                lrc_CostCalcDetailBatch."Attached to Entry No." := lrc_CostCalculationData."Document No.";
                                lrc_CostCalcDetailBatch."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
                                lrc_CostCalcDetailBatch."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";
                                lrc_CostCalcDetailBatch.INSERT(TRUE);

                            END;

                            // SFR 02.07.2007 die folgenden beiden Zeilen sind wichtig auf einem SQL - Server
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
                    lrc_CostCalcDetailBatch.SETRANGE("Document No. 2", vrc_CostCalculation."Document No. 2");
                    lrc_CostCalcDetailBatch.SETRANGE("Entry Type", lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch");
                    lrc_CostCalcDetailBatch.SETRANGE("Cost Category Code", vrc_CostCalculation."Cost Category Code");
                    IF lrc_CostCalcDetailBatch.FINDSET(FALSE, FALSE) THEN
                        REPEAT

                            lrc_CostCalcDetailBatch.TESTFIELD("Batch No.");

                            // Summensatz Position lesen
                            lrc_BatchTemp.RESET();
                            lrc_BatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                            lrc_BatchTemp.SETRANGE("Userid Code", USERID());
                            lrc_BatchTemp.SETRANGE("MCS Master Batch No.", lrc_CostCalcDetailBatch."Master Batch No.");
                            lrc_BatchTemp.SETRANGE("MCS Batch No.", lrc_CostCalcDetailBatch."Batch No.");
                            lrc_BatchTemp.SETRANGE("MCS Without Allocation", FALSE);
                            lrc_BatchTemp.SETFILTER("MCS Quantity Colli", '<>%1', 0);
                            IF lrc_BatchTemp.FIND('-') THEN BEGIN

                                // Schleife um die Positionsvarianten der Position
                                lrc_BatchVariant.RESET();
                                lrc_BatchVariant.SETCURRENTKEY("Master Batch No.", "Batch No.");
                                lrc_BatchVariant.SETRANGE("Master Batch No.", lrc_CostCalcDetailBatch."Master Batch No.");
                                lrc_BatchVariant.SETRANGE("Batch No.", lrc_CostCalcDetailBatch."Batch No.");
                                IF lrc_BatchVariant.FIND('-') THEN
                                    REPEAT
                                        // Einkaufszeile lesen
                                        lrc_PurchLine.RESET();
                                        lrc_PurchLine.SETCURRENTKEY("POI Batch Variant No.", Type, "No.", "Document Type");
                                        lrc_PurchLine.SETRANGE("POI Batch Variant No.", lrc_BatchVariant."No.");
                                        lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                                        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
                                        lrc_PurchLine.SETRANGE("POI Master Batch No.", lrc_BatchVariant."Master Batch No.");
                                        lrc_PurchLine.SETRANGE("POI Batch No.", lrc_BatchVariant."Batch No.");
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
                                            lrc_CostCalcDetailBatchVar."Entry No." := 0;
                                            lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch Variant";
                                            lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_BatchVariant."No.";
                                            lrc_CostCalcDetailBatchVar.VALIDATE(Amount, ldc_Amount);
                                            lrc_CostCalcDetailBatchVar.Price := lrc_CostCalcDetailBatchVar.Amount;
                                            lrc_CostCalcDetailBatchVar."Reference Price" := lrc_CostCalcDetailBatchVar."Reference Price"::Amount;
                                            lrc_CostCalcDetailBatchVar."Attached to Entry No." := lrc_CostCalculationData."Document No.";
                                            lrc_CostCalcDetailBatchVar."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
                                            lrc_CostCalcDetailBatchVar."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";
                                            lrc_CostCalcDetailBatchVar.INSERT(TRUE);
                                        END ELSE BEGIN
                                            // Detailzeile Batch einfügen
                                            lrc_CostCalcDetailBatchVar.RESET();
                                            lrc_CostCalcDetailBatchVar.INIT();
                                            lrc_CostCalcDetailBatchVar := lrc_CostCalcDetailBatch;
                                            lrc_CostCalcDetailBatchVar."Entry No." := 0;
                                            lrc_CostCalcDetailBatchVar."Entry Type" := lrc_CostCalcDetailBatch."Entry Type"::"Detail Batch Variant";
                                            lrc_CostCalcDetailBatchVar."Batch Variant No." := lrc_BatchVariant."No.";
                                            //lrc_CostCalcDetailBatchVar.VALIDATE(Amount,ldc_Amount);
                                            lrc_CostCalcDetailBatchVar.Price := lrc_CostCalcDetailBatchVar.Amount;
                                            lrc_CostCalcDetailBatchVar."Reference Price" := lrc_CostCalcDetailBatchVar."Reference Price"::Amount;
                                            lrc_CostCalcDetailBatchVar."Attached to Entry No." := lrc_CostCalculationData."Document No.";
                                            lrc_CostCalcDetailBatchVar."Attached to Doc. No." := lrc_CostCalculationData."Document No. 2";
                                            lrc_CostCalcDetailBatchVar."Attached Entry Subtype" := lrc_CostCalculationData."Entry Level";
                                            lrc_CostCalcDetailBatchVar.INSERT(TRUE);
                                        END;
                                    UNTIL lrc_BatchVariant.NEXT() = 0;
                                // Reste der letzten Positionsvariante zuordnen
                            END;
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
                    CASE vrc_CostCalculation."Allocation Level" OF
                        vrc_CostCalculation."Allocation Level"::"Voyage No.":
                            BEGIN
                                lrc_PurchHeader.SETCURRENTKEY("POI Voyage No.");
                                lrc_PurchHeader.SETRANGE("POI Voyage No.", vrc_CostCalculation."Voyage No.");
                                lrc_PurchHeader.SETRANGE("Document Type", lrc_PurchHeader."Document Type"::Order);
                            END;
                        vrc_CostCalculation."Allocation Level"::"Master Batch No.":
                            BEGIN
                                lrc_PurchHeader.SETCURRENTKEY("POI Master Batch No.");
                                lrc_PurchHeader.SETRANGE("POI Master Batch No.", vrc_CostCalculation."Master Batch No.");
                                lrc_PurchHeader.SETRANGE("Document Type", lrc_PurchHeader."Document Type"::Order);
                            END;
                    END;
                    IF lrc_PurchHeader.FINDSET(FALSE, FALSE) THEN
                        REPEAT

                            lrc_PurchLine.RESET();
                            lrc_PurchLine.SETCURRENTKEY("POI Batch Variant No.", Type, "No.", "Document Type");
                            lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                            lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
                            lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                            lrc_PurchLine.SETFILTER("No.", '<>%1', '');
                            lrc_PurchLine.SETFILTER("POI Batch Variant No.", '<>%1', '');
                            IF lrc_PurchLine.FINDSET(TRUE, FALSE) THEN
                                REPEAT

                                    // Werte auf Null setzen
                                    lrc_PurchLine."POI Cost Calc. Amount (LCY)" := 0;
                                    lrc_PurchLine."POI Cost Calc. (UOM) (LCY)" := 0;
                                    lrc_PurchLine."POI Indirect Cost Amount (LCY)" := 0;

                                    lrc_CostCalcDetailBatchVar.RESET();
                                    //xx         lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type","Master Batch No.","Batch No.","Batch Variant No.","Vendor No.");
                                    lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
                                    lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", lrc_PurchLine."POI Master Batch No.");
                                    lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.", lrc_PurchLine."POI Batch No.");
                                    lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.", lrc_PurchLine."POI Batch Variant No.");
                                    IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
                                        REPEAT
                                            // Alle Kosten aufaddieren
                                            lrc_PurchLine."POI Cost Calc. Amount (LCY)" := lrc_PurchLine."POI Cost Calc. Amount (LCY)" +
                                                                                       lrc_CostCalcDetailBatchVar."Amount (LCY)";
                                            // Indirekte Kosten aufaddieren
                                            IF lrc_CostCalcDetailBatchVar."Indirect Cost (Purchase)" THEN
                                                lrc_PurchLine."POI Indirect Cost Amount (LCY)" := lrc_PurchLine."POI Indirect Cost Amount (LCY)" +
                                                                                              lrc_CostCalcDetailBatchVar."Amount (LCY)";
                                        UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;
                                    IF lrc_PurchLine.Quantity <> 0 THEn
                                        lrc_PurchLine."POI Cost Calc. (UOM) (LCY)" := ROUND(lrc_PurchLine."POI Cost Calc. Amount (LCY)" /
                                                                                           lrc_PurchLine.Quantity, 0.00001);
                                    IF lrc_Item.GET(lrc_PurchLine."No.") THEn
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
                                BEGIN
                                    lrc_BatchVariant.SETCURRENTKEY("Voyage No.");
                                    lrc_BatchVariant.SETRANGE("Voyage No.", vrc_CostCalculation."Voyage No.");
                                END;
                            vrc_CostCalculation."Allocation Level"::"Master Batch No.":
                                BEGIN
                                    lrc_BatchVariant.SETCURRENTKEY("Master Batch No.");
                                    lrc_BatchVariant.SETRANGE("Master Batch No.", vrc_CostCalculation."Master Batch No.");
                                END;
                        END;
                        IF lrc_BatchVariant.FINDSET(TRUE, FALSE) THEN
                            REPEAT
                                lrc_BatchVariant.CALCFIELDS("B.V. Purch. Rec. (Qty)", "B.V. Purch. Order (Qty)");
                                // Werte zurücksetzen
                                lrc_BatchVariant."Cost Calc. Amount (LCY)" := 0;
                                lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := 0;
                                lrc_CostCalcDetailBatchVar.RESET();
                                lrc_CostCalcDetailBatchVar.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.",
                                                                         "Batch Variant No.", "Vendor No.");
                                lrc_CostCalcDetailBatchVar.SETRANGE("Entry Type", lrc_CostCalcDetailBatchVar."Entry Type"::"Detail Batch Variant");
                                lrc_CostCalcDetailBatchVar.SETRANGE("Master Batch No.", lrc_BatchVariant."Master Batch No.");
                                lrc_CostCalcDetailBatchVar.SETRANGE("Batch No.", lrc_BatchVariant."Batch No.");
                                lrc_CostCalcDetailBatchVar.SETRANGE("Batch Variant No.", lrc_BatchVariant."No.");
                                IF lrc_CostCalcDetailBatchVar.FIND('-') THEN
                                    REPEAT
                                        lrc_BatchVariant."Cost Calc. Amount (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" + lrc_CostCalcDetailBatchVar."Amount (LCY)";
                                    UNTIL lrc_CostCalcDetailBatchVar.NEXT() = 0;
                                IF (lrc_BatchVariant."B.V. Purch. Rec. (Qty)" +
                                    lrc_BatchVariant."B.V. Purch. Order (Qty)") <> 0 THEN
                                    lrc_BatchVariant."Cost Calc. (UOM) (LCY)" := lrc_BatchVariant."Cost Calc. Amount (LCY)" /
                                                     ((lrc_BatchVariant."B.V. Purch. Rec. (Qty)" +
                                                       lrc_BatchVariant."B.V. Purch. Order (Qty)") /
                                                      lrc_BatchVariant."Qty. per Unit of Measure");
                                lrc_BatchVariant.MODIFY();
                            UNTIL lrc_BatchVariant.NEXT() = 0;
                    END;
                END;
        END;
    end;

    procedure RecalcBatchTempAttachAlocBatch(vin_EntryNo: Integer)
    var
        lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    begin
        // --------------------------------------------------------------------------------------------------------------------
        // Funktion zum Löschen der Positionen aus der BatchTemp die bei der Umverteilung nicht berücksichtigt werden sollen
        // --------------------------------------------------------------------------------------------------------------------
        lrc_CostCalculation.GET(vin_EntryNo);
        IF lrc_CostCalculation."Entry Type" <> lrc_CostCalculation."Entry Type"::"Enter Data" THEN
            EXIT;
        lrc_BatchTemp.RESET();
        lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
        lrc_BatchTemp.SETRANGE("Userid Code", USERID());
        lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
        IF lrc_BatchTemp.FINDSET(TRUE, FALSE) THEN
            REPEAT
                lrc_CostCalcAllocBatch.RESET();
                lrc_CostCalcAllocBatch.SETRANGE("Document No.", lrc_CostCalculation."Document No.");
                lrc_CostCalcAllocBatch.SETRANGE("Batch No.", lrc_BatchTemp."MCS Batch No.");
                lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", lrc_CostCalculation."Document No. 2");
                IF lrc_CostCalcAllocBatch.FINDFIRST() THEN BEGIN
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
        IF lrc_MasterBatchTemp.FINDSET(TRUE, FALSE) THEN
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
        IF lrc_BatchTemp.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF NOT lrc_BatchTemp."MCS Without Allocation" THEN BEGIN
                    IF lrc_BatchTemp."MCS Voyage No." <> '' THEN BEGIN
                        lrc_MasterBatchTemp.RESET();
                        lrc_MasterBatchTemp.SETRANGE("Entry Type", lrc_MasterBatchTemp."Entry Type"::MCS);
                        lrc_MasterBatchTemp.SETRANGE("Userid Code", USERID());
                        lrc_MasterBatchTemp.SETRANGE("MCS Master Batch No.", '');
                        lrc_MasterBatchTemp.SETRANGE("MCS Voyage No.", lrc_BatchTemp."MCS Voyage No.");
                        lrc_MasterBatchTemp.SETRANGE("MCS Batch No.", '');
                        lrc_MasterBatchTemp.FINDFIRST();
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
                        lrc_MasterBatchTemp.FINDFIRST();
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

    //     procedure LoopAllocateEnterData(vco_UseriID: Code[20]; vin_EntryID: Integer)
    //     var
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------------------------
    //         // Funktion zum Umlegen von erfassten Kosten
    //         // ------------------------------------------------------------------------------------------------------------------------------

    //         lrc_CostCalcEnterData.RESET();
    //         IF vco_UseriID <> '' THEN
    //             lrc_CostCalcEnterData.SETRANGE("Last Change by", vco_UseriID);
    //         IF vin_EntryID <> 0 THEN
    //             lrc_CostCalcEnterData.SETRANGE("Document No.", vin_EntryID);
    //         lrc_CostCalcEnterData.SETRANGE(Allocated, FALSE);
    //         lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //         WHILE lrc_CostCalcEnterData.FINDFIRST() DO BEGIN

    //             AllocateCostPerEnterDataRec(lrc_CostCalcEnterData);
    //             lrc_CostCalcEnterData.Allocated := TRUE;
    //             lrc_CostCalcEnterData.MODIFY();

    //             IF lrc_CostCalcEnterData."Voyage No." <> '' THEN
    //                 CostCatCalcTotals(0, lrc_CostCalcEnterData."Voyage No.", lrc_CostCalcEnterData."Cost Category Code", TRUE);
    //             IF lrc_CostCalcEnterData."Container No." <> '' THEN
    //                 CostCatCalcTotals(1, lrc_CostCalcEnterData."Container No.", lrc_CostCalcEnterData."Cost Category Code", TRUE);
    //             IF lrc_CostCalcEnterData."Master Batch No." <> '' THEN
    //                 CostCatCalcTotals(2, lrc_CostCalcEnterData."Master Batch No.", lrc_CostCalcEnterData."Cost Category Code", TRUE);

    //         END;
    //     end;

    //     procedure AllocatePlanCostToBatch(vrc_CostCalculation: Record "POI Cost Calc. - Enter Data")
    //     var
    //         lcu_BatchMgt: Codeunit "POI BAM Batch Management";
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_BatchTemp: Record "POI Batch Temp";
    //         lrc_PurchaseLine: Record "Purchase Line";
    //         lrc_NewCostCalculation: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCalcAllocBatch: Record "POI Cost Calc. - Alloc. Batch";
    //         lrc_Batch: Record "POI Batch";
    //         lrc_CostCategory: Record "POI Cost Category";
    //         lrc_CostCategoryAllocation: Record "5110553";
    //         //lfm_FHKostenverteilungPartien: Form "5087960";
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
    //         lin_LineNo: Integer;
    //         lbn_FirstLoop: Boolean;
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------------
    //         // Eingabe der Kostenverteilung auf Positionen (Kosten sollen auf die jeweilige Position verteilt werden oder nicht)
    //         // für eine Eingabezeile Plankosten
    //         // ------------------------------------------------------------------------------------------------------------------

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
    //                 IF lrc_CostCategoryAllocation.FINDFIRST() THEN BEGIN
    //                     CASE lrc_CostCategoryAllocation."Allocation Type" OF
    //                         lrc_CostCategoryAllocation."Allocation Type"::Pallets:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Pallets;
    //                         lrc_CostCategoryAllocation."Allocation Type"::Kolli:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Kolli;
    //                         lrc_CostCategoryAllocation."Allocation Type"::"Net Weight":
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::"Net Weight";
    //                         lrc_CostCategoryAllocation."Allocation Type"::"Gross Weight":
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::"Gross Weight";
    //                         lrc_CostCategoryAllocation."Allocation Type"::Lines:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Lines;
    //                         lrc_CostCategoryAllocation."Allocation Type"::Amount:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Amount;
    //                     END;
    //                 END ELSE BEGIN
    //                     CASE lrc_CostCategory."Allocation Type" OF
    //                         lrc_CostCategory."Allocation Type"::Pallets:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Pallets;
    //                         lrc_CostCategory."Allocation Type"::Kolli:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Kolli;
    //                         lrc_CostCategory."Allocation Type"::"Net Weight":
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::"Net Weight";
    //                         lrc_CostCategory."Allocation Type"::"Gross Weight":
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::"Gross Weight";
    //                         lrc_CostCategory."Allocation Type"::Lines:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Lines;
    //                         lrc_CostCategory."Allocation Type"::Amount:
    //                             lrc_BatchTemp."MCS Allocation Key" := lrc_BatchTemp."MCS Allocation Key"::Amount;
    //                     END;
    //                 END;

    //                 // Kontrolle ob es bereits eine Belegung gibt
    //                 lrc_CostCalcAllocBatch.RESET();
    //                 lrc_CostCalcAllocBatch.SETRANGE("Document No.", vrc_CostCalculation."Document No.");
    //                 lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", vrc_CostCalculation."Document No. 2");
    //                 lrc_CostCalcAllocBatch.SETRANGE("Batch No.", lrc_BatchTemp."MCS Batch No.");
    //                 IF lrc_CostCalcAllocBatch.FINDFIRST() THEN BEGIN
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

    //         // Bestehende Zuordnungen löschen
    //         lrc_CostCalcAllocBatch.RESET();
    //         lrc_CostCalcAllocBatch.SETRANGE("Document No.", vrc_CostCalculation."Document No.");
    //         lrc_CostCalcAllocBatch.SETRANGE("Document No. 2", vrc_CostCalculation."Document No. 2");
    //         IF NOT lrc_CostCalcAllocBatch.isempty()THEN
    //             lrc_CostCalcAllocBatch.DELETEALL();

    //         // Ergebnis übertragen
    //         lrc_BatchTemp.RESET();
    //         lrc_BatchTemp.SETRANGE("Userid Code", UserID());
    //         lrc_BatchTemp.SETRANGE("Entry Type", lrc_BatchTemp."Entry Type"::MCS);
    //         lrc_BatchTemp.SETFILTER("MCS Allocation Key", '<>%1', lrc_BatchTemp."MCS Allocation Key"::" ");
    //         lrc_BatchTemp.SETFILTER("MCS Batch No.", '<>%1', '');
    //         IF lrc_BatchTemp.FINDSET(FALSE, FALSE) THEN BEGIN
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
    //                 lrc_CostCalcAllocBatch."Cost Category Code" := vrc_CostCalculation."Cost Category Code";
    //                 lrc_CostCalcAllocBatch.INSERT(TRUE);
    //             UNTIL lrc_BatchTemp.NEXT() = 0;
    //         END ELSE BEGIN
    //             // Keine gültigen Verteilungsschlüssel vorhanden!
    //             ERROR(AGILES_LT_TEXT003);
    //         END;

    //         //RS Kalkulation Qty. Colli, Qty. Pallets, Kosten/Kolli und Kosten/Palette in tbl 5110564
    //         lrc_NewCostCalculation.RESET();
    //         lrc_NewCostCalculation := vrc_CostCalculation;
    //         lrc_NewCostCalculation.CalcQtyByMasterBatch(vrc_CostCalculation."Master Batch No.");
    //         lrc_NewCostCalculation.MODIFY();
    //     end;

    //     procedure CalcPostCostMasterBatchCostCat(vin_EntryNo: Integer)
    //     var
    //         lcu_PostedCostMgt: Codeunit "5110359";
    //         lrc_CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";
    //         ldc_SumNetChange: Decimal;
    //         ldc_SumNetChangeQty: Decimal;
    //     begin
    //         //RS - Funkition überwiegend von Agiles auskommentiert, läuft ins Leere über Tab CostCalcEnterData als Flowfield realisiert
    //         // ------------------------------------------------------------------------------------------------------------------------
    //         // Funktion zum Berechnen der Geb. Kosten für eine Kostenkategorie und eine Partie
    //         // ------------------------------------------------------------------------------------------------------------------------

    //         //RS lrc_CostCalcCostCategories.GET(vin_EntryNo);

    //         // Funktion zur Berechnung der gebuchten Kosten auf einer Position / Partie oder Reise für eine Kostenkategorie
    //         // vop_Subtype (0=Alle,1=Reise,2=Container,3=MasterBatch,4=Batch)
    //         // vco_SubTypeCode
    //         // vco_CostCategoryCode
    //         // rdc_SumNetChange
    //         // rdc_SumNetChangeQty
    //         //xxlcu_PostedCostMgt.CalcPostCostMasterBatchCostCat(3,lrc_CostCalcCostCategories."Master Batch No.",
    //         //xx                  lrc_CostCalcCostCategories."Cost Category Code",0D,0D,ldc_SumNetChange,ldc_SumNetChangeQty);

    //         //RS lrc_CostCalcCostCategories."Posted Amt (LCY)" := ldc_SumNetChange;
    //         //RS lrc_CostCalcCostCategories.MODIFY();
    //     end;

    //     procedure "-- CALC VALUES --"()
    //     begin
    //     end;

    //     procedure TotalCalcCostVoyageCostCat(vco_VoyageNo: Code[20]; vco_CostCategoryCode: Code[20]): Decimal
    //     var
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_CostCalcAllocData: Record "POI Cost Calc. - Alloc. Data";
    //         ldc_CalcCost: Decimal;
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung Summe Plankosten für eine Reise und je nach Übergabe Kostenkategorie
    //         // ------------------------------------------------------------------------------------------------------------------------------
    //         // Eigentlich steht der Wert bereits in den Summenfeldern der Kostenkategorien !!!
    //         // ------------------------------------------------------------------------------------------------------------------------------

    //         ldc_CalcCost := 0;

    //         lrc_MasterBatch.RESET();
    //         lrc_MasterBatch.SETRANGE("Voyage No.", vco_VoyageNo);
    //         IF lrc_MasterBatch.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 lrc_CostCalcAllocData.RESET();
    //                 //xxlrc_CostCalcAllocData.SETCURRENTKEY("Entry Type","Master Batch No.","Batch No.","Cost Category Code");
    //                 lrc_CostCalcAllocData.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //                 IF vco_CostCategoryCode <> '' THEN
    //                     lrc_CostCalcAllocData.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //                 lrc_CostCalcAllocData.SETRANGE("Entry Type", lrc_CostCalcAllocData."Entry Type"::"Detail Batch");
    //                 IF lrc_CostCalcAllocData.FINDSET(FALSE, FALSE) THEN BEGIN
    //                     REPEAT
    //                         ldc_CalcCost := ldc_CalcCost + lrc_CostCalcAllocData."Amount (LCY)";
    //                     UNTIL lrc_CostCalcAllocData.NEXT() = 0;
    //                 END;
    //             UNTIL lrc_MasterBatch.NEXT() = 0;
    //         END;

    //         EXIT(ldc_CalcCost);
    //     end;

    //     procedure TotalCalcCostMBatchCostCat(vco_MasterBatchNo: Code[20]; vco_CostCategoryCode: Code[20]): Decimal
    //     var
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //         ldc_CalcCost: Decimal;
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung Summe Plankosten für eine Partie und je nach Übergabe Kostenkategorie
    //         // ------------------------------------------------------------------------------------------------------------------------------
    //         // Eigentlich steht der Wert bereits in den Summenfeldern der Kostenkategorien !!!
    //         // ------------------------------------------------------------------------------------------------------------------------------

    //         ldc_CalcCost := 0;

    //         lrc_MasterBatch.RESET();
    //         //lrc_MasterBatch.SETRANGE("No.",vco_MasterBatchNo);
    //         //IF lrc_MasterBatch.FINDFIRST() THEN BEGIN
    //         IF lrc_MasterBatch.GET(vco_MasterBatchNo) THEN BEGIN
    //             //REPEAT
    //             lrc_CostCalcEnterData.RESET();
    //             lrc_CostCalcEnterData.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.", "Cost Category Code");
    //             // xox
    //             lrc_CostCalcEnterData.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //             IF vco_CostCategoryCode <> '' THEN
    //                 lrc_CostCalcEnterData.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //             lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Detail Batch");
    //             IF lrc_CostCalcEnterData.FINDSET() THEN BEGIN
    //                 REPEAT
    //                     ldc_CalcCost := ldc_CalcCost + lrc_CostCalcEnterData."Amount (LCY)";
    //                 UNTIL lrc_CostCalcEnterData.NEXT() = 0;
    //             END;
    //             //UNTIL lrc_MasterBatch.NEXT() = 0;
    //         END;

    //         EXIT(ldc_CalcCost);
    //     end;

    //     procedure TotalCalcCostBatchCostCat(vco_BatchNo: Code[20]; vco_CostCategoryCode: Code[20]): Decimal
    //     var
    //         lrc_CostCalcAllocData: Record "POI Cost Calc. - Alloc. Data";
    //         ldc_CalcCost: Decimal;
    //     begin
    //         // ------------------------------------------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung Summe Plankosten für eine Position und je nach Übergabe Kostenkategorie
    //         // ------------------------------------------------------------------------------------------------------------------------------
    //         // Eigentlich steht der Wert bereits in den Summenfeldern der Kostenkategorien !!!
    //         // ------------------------------------------------------------------------------------------------------------------------------

    //         ldc_CalcCost := 0;

    //         lrc_CostCalcAllocData.RESET();
    //         lrc_CostCalcAllocData.SETRANGE("Batch No.", vco_BatchNo);
    //         IF vco_CostCategoryCode <> '' THEN
    //             lrc_CostCalcAllocData.SETRANGE("Cost Category Code", vco_CostCategoryCode);
    //         lrc_CostCalcAllocData.SETRANGE("Entry Type", lrc_CostCalcAllocData."Entry Type"::"Detail Batch");
    //         IF lrc_CostCalcAllocData.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 ldc_CalcCost := ldc_CalcCost + lrc_CostCalcAllocData."Amount (LCY)";
    //             UNTIL lrc_CostCalcAllocData.NEXT() = 0;
    //         END;

    //         EXIT(ldc_CalcCost);
    //     end;

    //     procedure "--"()
    //     begin
    //     end;

    //     procedure CreateDimValFromCostCategory()
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

    //     procedure "-- MATRIX COST INVOICE --"()
    //     begin
    //     end;

    //     procedure MatrixEnterData(vco_MasterBatchCode: Code[20])
    //     var
    //         lrc_FruitVisionSetup: Record "POI ADF Setup";
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //     //lfm_CostCalcEnterMatrix: Form "5087948";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zur Erfassung der Kosten über die Matrix
    //         // ---------------------------------------------------------------------------------
    //         //LoadCostCat Aufruf geändert, DeletAllBefore auf FALSE
    //         //LoadCostCat('','',vco_MasterBatchCode,'',TRUE,TRUE,FALSE,FALSE);
    //         LoadCostCat('', '', vco_MasterBatchCode, '', FALSE, TRUE, FALSE, FALSE);
    //         COMMIT;

    //         lfm_CostCalcEnterMatrix.SetValues(vco_MasterBatchCode);
    //         lfm_CostCalcEnterMatrix.RUNMODAL;

    //         // Erfasste Kosten umlegen auf Positionen und Positionsvarianten
    //         lrc_CostCalcEnterData.RESET();
    //         lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //         lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");
    //         lrc_CostCalcEnterData.SETRANGE("Master Batch No.", vco_MasterBatchCode);
    //         IF lrc_CostCalcEnterData.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 AllocateCostPerEnterDataRec(lrc_CostCalcEnterData);
    //             UNTIL lrc_CostCalcEnterData.NEXT() = 0;
    //         END;
    //     end;

    //     procedure "-- PURCHASE COST INVOICE --"()
    //     begin
    //     end;

    //     procedure LoadCostCalcInPurchInvoice(vrc_PurchHeader: Record "Purchase Header")
    //     var
    //         lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
    //     //lfm_CalcCostLoadinPurchInv: Form "5087952";
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion zum Laden von Sollkosten in Eink.-Rechnung auf Basis des Kreditors
    //         // ---------------------------------------------------------------------------------

    //         lrc_CostCalculation.RESET();
    //         lrc_CostCalculation.SETCURRENTKEY("Entry Type", "Vendor No.", Released, "No. of Loadings in Doc.");

    //         //lrc_CostCalculation.FILTERGROUP(2);
    //         lrc_CostCalculation.SETRANGE("Entry Type", lrc_CostCalculation."Entry Type"::"Enter Data");
    //         lrc_CostCalculation.SETRANGE("Vendor No.", vrc_PurchHeader."Buy-from Vendor No.");
    //         //lrc_CostCalculation.FILTERGROUP(0);
    //         lrc_CostCalculation.SETRANGE(Released, TRUE);
    //         lrc_CostCalculation.SETRANGE("No. of Loadings in Doc.", 0);

    //         lfm_CalcCostLoadinPurchInv.SetPurchaseHeader(vrc_PurchHeader);
    //         lfm_CalcCostLoadinPurchInv.SETTABLEVIEW(lrc_CostCalculation);
    //         lfm_CalcCostLoadinPurchInv.EDITABLE := FALSE;
    //         lfm_CalcCostLoadinPurchInv.LOOKUPMODE := TRUE;
    //         IF lfm_CalcCostLoadinPurchInv.RUNMODAL <> ACTION::LookupOK THEN
    //             EXIT;
    //     end;

    //     procedure CreatePurchInvLines(var rrc_CostCalculation: Record "POI Cost Calc. - Enter Data"; vrc_PurchHeader: Record "Purchase Header")
    //     var
    //         lrc_ADFSetup: Record "POI ADF Setup";
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_CostCalcAllocData: Record "POI Cost Calc. - Alloc. Data";
    //         lrc_PurchLine: Record "Purchase Line";
    //         lrc_CostCategoryAccounts: Record "5110346";
    //         lrc_GLAccount: Record "G/L Account";
    //         //lfm_CostCategoryAccounts: Form "5087941";
    //         lin_LineNo: Integer;
    //         lco_GLAccountNo: Code[20];
    //         ldc_CheckSum: Decimal;
    //         gbn_SetFilterOnGroup: Boolean;
    //         AGILES_LT_TEXT001: Label 'Der Kostenkategorie sind keine Sachkonten zugeordnet!';
    //         AGILES_LT_TEXT002: Label 'Abbruch!';
    //         AGILES_LT_TEXT003: Label 'Fehlerhafte Dimensionszuordnung Position!';
    //         AGILES_LT_TEXT004: Label 'Fehlerhafte Dimensionszuordnung Kostenkategorie!';
    //         AGILES_LT_TEXT005: Label 'Es sind keine Kostenkalkulationszeilen auf Positionsebene für Nummer %1 vorhanden!';
    //         ADF_LT_TEXT006: Label 'Posting from Cost Calculation';
    //     begin
    //         // ---------------------------------------------------------------------------------
    //         // Funktion
    //         // ---------------------------------------------------------------------------------

    //         lrc_ADFSetup.GET();
    //         lrc_BatchSetup.GET();

    //         // Filter wird übergeben
    //         IF rrc_CostCalculation.FIND('-') THEN BEGIN
    //             REPEAT

    //                 lco_GLAccountNo := '';

    //                 // Über die Kostenkategorie das Sachkonto ermitteln - Suche mit Buchungsgruppenfilter
    //                 gbn_SetFilterOnGroup := FALSE;
    //                 lrc_CostCategoryAccounts.RESET();
    //                 lrc_CostCategoryAccounts.CALCFIELDS("Gen. Bus. Posting Group");
    //                 lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
    //                 lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", rrc_CostCalculation."Cost Category Code");
    //                 lrc_CostCategoryAccounts.SETRANGE("Gen. Bus. Posting Group", vrc_PurchHeader."Gen. Bus. Posting Group");
    //                 IF lrc_CostCategoryAccounts.FINDFIRST() THEN BEGIN
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
    //                     IF NOT lrc_CostCategoryAccounts.FINDFIRST() THEN BEGIN
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
    //                     IF gbn_SetFilterOnGroup THEN BEGIN
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

    //                 ldc_CheckSum := 0;

    //                 lrc_PurchLine.RESET();
    //                 lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
    //                 lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
    //                 IF lrc_PurchLine.FINDLAST THEN
    //                     lin_LineNo := lrc_PurchLine."Line No."
    //                 ELSE
    //                     lin_LineNo := 0;

    //                 // Alle zugehörigen Einträge auf Positionsebene lesen und Einkaufsrechnungszeile anlegen
    //                 lrc_CostCalcAllocData.RESET();
    //                 lrc_CostCalcAllocData.SETCURRENTKEY("Document No. 2");
    //                 lrc_CostCalcAllocData.SETRANGE("Document No. 2", rrc_CostCalculation."Document No. 2");
    //                 lrc_CostCalcAllocData.SETRANGE("Entry Type", lrc_CostCalcAllocData."Entry Type"::"Detail Batch");
    //                 lrc_CostCalcAllocData.SETFILTER("Amount (LCY)", '<>%1', 0);
    //                 IF lrc_CostCalcAllocData.FINDSET(FALSE, FALSE) THEN BEGIN

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
    //                     // Buchung von Plankosten
    //                     lrc_PurchLine.Description := ADF_LT_TEXT006;
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
    //                         lrc_PurchLine.VALIDATE("Direct Unit Cost", lrc_CostCalcAllocData.Amount);

    //                         // Dimension Position setzen
    //                         CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //                             lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 1 Code", lrc_CostCalcAllocData."Batch No.");
    //                             lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 2 Code", lrc_CostCalcAllocData."Batch No.");
    //                             lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 3 Code", lrc_CostCalcAllocData."Batch No.");
    //                             lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 4 Code", lrc_CostCalcAllocData."Batch No.");
    //                             ELSE
    //                                 // Fehlerhafte Dimensionszuordnung Position!
    //                                 ERROR(AGILES_LT_TEXT003)
    //                         END;

    //                         // Dimension Kostenkategorie setzen
    //                         CASE lrc_ADFSetup."Dim. No. Cost Category" OF
    //                             lrc_ADFSetup."Dim. No. Cost Category"::"1. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 1 Code", lrc_CostCalcAllocData."Cost Category Code");
    //                             lrc_ADFSetup."Dim. No. Cost Category"::"2. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 2 Code", lrc_CostCalcAllocData."Cost Category Code");
    //                             lrc_ADFSetup."Dim. No. Cost Category"::"3. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 3 Code", lrc_CostCalcAllocData."Cost Category Code");
    //                             lrc_ADFSetup."Dim. No. Cost Category"::"4. Dimension":
    //                                 lrc_PurchLine.VALIDATE("Shortcut Dimension 4 Code", lrc_CostCalcAllocData."Cost Category Code");
    //                             ELSE
    //                                 // Fehlerhafte Dimensionszuordnung Kostenkategorie!
    //                                 ERROR(AGILES_LT_TEXT004)
    //                         END;

    //                         // Plankosten Belegnr
    //                         lrc_PurchLine."Cost Calc. Document No." := rrc_CostCalculation."Document No. 2";
    //                         lrc_PurchLine."Cost Category Code" := lrc_CostCalcAllocData."Cost Category Code";
    //                         lrc_PurchLine."Master Batch No." := lrc_CostCalcAllocData."Master Batch No.";
    //                         lrc_PurchLine."Batch No." := lrc_CostCalcAllocData."Batch No.";

    //                         lrc_PurchLine.MODIFY(TRUE);
    //                         ldc_CheckSum := ldc_CheckSum + lrc_PurchLine."Line Amount";

    //                     UNTIL lrc_CostCalcAllocData.NEXT() = 0;

    //                     IF ldc_CheckSum <> rrc_CostCalculation.Amount THEN BEGIN
    //                         ldc_CheckSum := rrc_CostCalculation.Amount - ldc_CheckSum;
    //                         lrc_PurchLine.VALIDATE("Direct Unit Cost", (lrc_PurchLine."Direct Unit Cost" + ldc_CheckSum));
    //                         lrc_PurchLine.MODIFY();
    //                     END;

    //                 END ELSE BEGIN
    //                     // Es sind keine Kostenkalkulationszeilen auf Positionsebene für Nummer .. vorhanden!
    //                     ERROR(AGILES_LT_TEXT005, rrc_CostCalculation."Document No.");
    //                 END;


    //                 rrc_CostCalculation."No. of Loadings in Doc." := rrc_CostCalculation."No. of Loadings in Doc." + 1;
    //                 rrc_CostCalculation.Status := rrc_CostCalculation.Status::Closed;
    //                 rrc_CostCalculation.MODIFY();

    //             UNTIL rrc_CostCalculation.NEXT() = 0;

    //         END;
    //     end;

    //     procedure "---"()
    //     begin
    //     end;

    //     procedure ShowCostCatPerBatch(vco_VoyageNo: Code[20]; vco_MasterBatchNo: Code[20]; vco_BatchNo: Code[20]; vco_CostCategoryCode: Code[20])
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

    //     procedure ShowCostCatPerBatchVar(vco_VoyageNo: Code[20]; vco_MasterBatchNo: Code[20]; vco_BatchNo: Code[20]; vco_BatchVarNo: Code[20]; vco_CostCategoryCode: Code[20])
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

    //     procedure CalcPlanCostPerPurchLine(vco_PurchOrderNo: Code[20]; vco_MasterBatchNo: Code[20]; vco_VoyageNo: Code[20])
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
    //                 ////    lrc_PurchLine.SETCURRENTKEY("Document Type",Type,"Master Batch No.","Batch No.","Batch Variant No.");
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
    //                                 IF lrc_CostCalcDetailBatchVar."Indirect Cost (Purchase)" THEN
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
    //                              ((lrc_BatchVariant."B.V. Purch. Rec. (Qty)" + lrc_BatchVariant."B.V. Purch. Order (Qty)") /
    //                                  lrc_BatchVariant."Qty. per Unit of Measure");
    //                     END;

    //                     lrc_BatchVariant.MODIFY();

    //                 UNTIL lrc_BatchVariant.NEXT() = 0;

    //             END;

    //         END;
    //     end;

    //     procedure CreateStandardPlanCost(vco_MasterBatchNo: Code[20])
    //     var
    //         lrc_MasterBatch: Record "POI Master Batch";
    //         lrc_Batch: Record "POI Batch";
    //         lrc_BatchContainer: Record "POI Batch";
    //         lrc_StandardCostCalculations: Record "5110551";
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //         StandardCostCalculationsTemp: Record "5110551" temporary;
    //         lrc_CostCatDummy: Record "POI Cost Category";
    //         CostCatTemp: Record "POI Cost Category" temporary;
    //         CostCalcEnterDataTemp: Record "POI Cost Calc. - Enter Data" temporary;
    //         lbn_ValidCostCalc: Boolean;
    //         ldc_Amount: Decimal;
    //         ldc_QtyPallet: Decimal;
    //         NoInsert: Boolean;
    //         TotalQtyOrderCUBase: Decimal;
    //         TotalQtyRecCUBase: Decimal;
    //         TotalQty: Decimal;
    //         Qty: Decimal;
    //         LastBatchNo: Code[20];
    //         SplitAmt: Decimal;
    //         DiffAmt: Decimal;
    //         Window: Dialog;
    //         TotalRecNo: Integer;
    //         RecNo: Integer;
    //         ErrorSkip: Boolean;
    //         "----RS": Integer;
    //         lrc_PurchHeaderRS: Record "Purchase Header";
    //         lrc_PurchLineRS: Record "Purchase Line";
    //         ldc_QuantityContainer: Decimal;
    //         ldc_AnzahlZeilen: Integer;
    //         lrc_BatchVariant: Record "POI Batch Variant";
    //         lrc_PackOrderHeader: Record "POI Pack. Order Header";
    //         lrc_PackOrderInput: Record "POI Pack. Order Input Items";
    //         lrc_PackOrderOutput: Record "POI Pack. Order Output Items";
    //         ldc_PackInput: Decimal;
    //     begin
    //         // ---------------------------------------------------------------------------------------------------------------------
    //         // Funktion zur Erstellung von Plankosten auf Basis der Standardplankosten
    //         // ---------------------------------------------------------------------------------------------------------------------
    //         lrc_MasterBatch.GET(vco_MasterBatchNo);
    //         lrc_MasterBatch.TESTFIELD("Expected Receipt Date");

    //         lrc_CostCalcEnterData.RESET();
    //         lrc_CostCalcEnterData.SETCURRENTKEY("Entry Type", "Voyage No.", "Master Batch No.", "Cost Category Code");
    //         lrc_CostCalcEnterData.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");

    //         // xxx
    //         lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");

    //         lrc_CostCalcEnterData.SETRANGE("Generated by System", TRUE);
    //         // IFW 001 EXO40002.s
    //         //lrc_CostCalcEnterData.SETRANGE("Manually Changed Value",FALSE);
    //         // IFW 001 EXO40002.e
    //         IF NOT lrc_CostCalcEnterData.isempty()THEN
    //             lrc_CostCalcEnterData.DELETEALL(TRUE);

    //         lrc_Batch.RESET();
    //         lrc_Batch.SETCURRENTKEY("Master Batch No.");
    //         lrc_Batch.SETRANGE("Master Batch No.", lrc_MasterBatch."No.");
    //         IF lrc_Batch.FINDSET() THEN BEGIN
    //             IF GUIALLOWED THEN BEGIN
    //                 Window.OPEN(Text003 + ' ' +
    //                             '@1@@@@@@@@@@@@@@@@@@@@@\');

    //                 TotalRecNo := lrc_Batch.COUNTAPPROX;
    //                 RecNo := 0;
    //                 Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));
    //             END;

    //             REPEAT //UNTIL lrc_Batch.NEXT() = 0

    //                 IF GUIALLOWED THEN BEGIN
    //                     Window.UPDATE(1, ROUND(RecNo / TotalRecNo * 10000, 1));
    //                     RecNo := RecNo + 1;
    //                 END;

    //                 lrc_StandardCostCalculations.RESET();

    //                 // IFW 001 EXO40002.s
    //                 FilterStandardCostCalcTable(lrc_StandardCostCalculations, lrc_CostCatDummy, lrc_MasterBatch, lrc_Batch);
    //                 // IFW 001 EXO40002.e
    //                 //170119
    //                 IF lrc_StandardCostCalculations.FINDSET() THEN BEGIN
    //                     REPEAT
    //                         lbn_ValidCostCalc := TRUE;
    //                         ldc_Amount := 0;

    //                         // Standard Plankostensatz bilden
    //                         IF lbn_ValidCostCalc THEN BEGIN

    //                             CASE lrc_StandardCostCalculations.Reference OF

    //                                 lrc_StandardCostCalculations.Reference::Collo:
    //                                     BEGIN // Betrag pro Kollo
    //                                         IF lrc_Batch.Source <> lrc_Batch.Source::"Packing Order" THEN BEGIN
    //                                             IF lrc_Batch."Qty. per Unit of Measure" <> 0 THEN BEGIN
    //                                                 lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
    //                                                 ldc_Amount := ((lrc_Batch."Purch. Order (Qty) (Base)" +
    //                                                                 lrc_Batch."Purch. Rec. (Qty) (Base)") / lrc_Batch."Qty. per Unit of Measure") *
    //                                                                 lrc_StandardCostCalculations."Reference Amount";
    //                                             END ELSE BEGIN
    //                                                 MESSAGE(Text004, lrc_Batch.FIELDCAPTION("Qty. per Unit of Measure"), lrc_Batch."No.");
    //                                             END;
    //                                         END ELSE BEGIN
    //                                             CASE lrc_StandardCostCalculations."Berechnungsbasis Packauftrag" OF
    //                                                 lrc_StandardCostCalculations."Berechnungsbasis Packauftrag"::Input:
    //                                                     BEGIN
    //                                                         lrc_PackOrderHeader.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                                                         lrc_PackOrderHeader.FINDSET(FALSE, FALSE);
    //                                                         lrc_PackOrderHeader.CALCFIELDS("Tot. Qty. Output (Base)");
    //                                                         lrc_PackOrderInput.SETRANGE("Doc. No.", lrc_PackOrderHeader."No.");
    //                                                         lrc_PackOrderInput.SETRANGE("No Revenue", FALSE);
    //                                                         IF lrc_PackOrderInput.FINDSET(FALSE, FALSE) THEN BEGIN
    //                                                             ldc_PackInput := 0;
    //                                                             REPEAT
    //                                                                 ldc_PackInput += lrc_PackOrderInput.Quantity;
    //                                                             UNTIL lrc_PackOrderInput.NEXT() = 0;
    //                                                         END;
    //                                                         lrc_BatchVariant.RESET();
    //                                                         lrc_BatchVariant.GET(lrc_Batch."No.");
    //                                                         lrc_BatchVariant.CALCFIELDS("B.V. Pack. Output (Qty)");
    //                                                         ldc_Amount := ((lrc_BatchVariant."B.V. Pack. Output (Qty)" /
    //                                                                         lrc_PackOrderHeader."Tot. Qty. Output (Base)") *
    //                                                                         ldc_PackInput) * lrc_StandardCostCalculations."Reference Amount";
    //                                                     END;
    //                                                 lrc_StandardCostCalculations."Berechnungsbasis Packauftrag"::Output:
    //                                                     BEGIN
    //                                                         lrc_BatchVariant.RESET();
    //                                                         lrc_BatchVariant.GET(lrc_Batch."No.");
    //                                                         lrc_BatchVariant.CALCFIELDS("B.V. Pack. Output (Qty)");
    //                                                         ldc_Amount := ((lrc_BatchVariant."B.V. Pack. Output (Qty)" / lrc_BatchVariant."Qty. per Unit of Measure") *
    //                                                                         lrc_StandardCostCalculations."Reference Amount");
    //                                                     END;
    //                                             END;
    //                                         END;
    //                                     END; //END: lrc_StandardCostCalculations.Reference::Collo:

    //                                 lrc_StandardCostCalculations.Reference::Pallet:
    //                                     BEGIN  // Betrag pro Palette
    //                                         IF lrc_Batch.Source <> lrc_Batch.Source::"Packing Order" THEN BEGIN
    //                                             IF (lrc_Batch."Qty. per Unit of Measure" <> 0) AND (lrc_Batch."Qty. (Unit) per Transp. (TU)" <> 0) THEN BEGIN
    //                                                 lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
    //                                                 ldc_Amount := (((lrc_Batch."Purch. Order (Qty) (Base)" +
    //                                                                  lrc_Batch."Purch. Rec. (Qty) (Base)") / lrc_Batch."Qty. per Unit of Measure") /
    //                                                                  lrc_Batch."Qty. (Unit) per Transp. (TU)") *
    //                                                               lrc_StandardCostCalculations."Reference Amount";
    //                                             END ELSE BEGIN
    //                                                 MESSAGE(Text005, lrc_Batch.FIELDCAPTION("Qty. per Unit of Measure"),
    //                                                                 lrc_Batch.FIELDCAPTION("Qty. (Unit) per Transp. (TU)"), lrc_Batch."No.");
    //                                             END;
    //                                         END ELSE BEGIN //Partieherkunft Packauftrag
    //                                             CASE lrc_StandardCostCalculations."Berechnungsbasis Packauftrag" OF
    //                                                 lrc_StandardCostCalculations."Berechnungsbasis Packauftrag"::Input:

    //                                                     BEGIN
    //                                                         lrc_PackOrderHeader.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                                                         lrc_PackOrderHeader.FINDSET(FALSE, FALSE);
    //                                                         lrc_PackOrderHeader.CALCFIELDS("Tot. Qty. Output (Base)");
    //                                                         lrc_PackOrderInput.SETRANGE("Doc. No.", lrc_PackOrderHeader."No.");
    //                                                         lrc_PackOrderInput.SETRANGE("No Revenue", FALSE);
    //                                                         IF lrc_PackOrderInput.FINDSET(FALSE, FALSE) THEN BEGIN
    //                                                             ldc_PackInput := 0;
    //                                                             REPEAT
    //                                                                 ldc_PackInput += lrc_PackOrderInput."Quantity (TU)";
    //                                                             UNTIL lrc_PackOrderInput.NEXT() = 0;
    //                                                         END;
    //                                                         lrc_BatchVariant.RESET();
    //                                                         lrc_BatchVariant.GET(lrc_Batch."No.");
    //                                                         lrc_BatchVariant.CALCFIELDS("B.V. Pack. Output (Qty)");
    //                                                         ldc_Amount := ((lrc_BatchVariant."B.V. Pack. Output (Qty)" /
    //                                                                         lrc_PackOrderHeader."Tot. Qty. Output (Base)") *
    //                                                                         ldc_PackInput) * lrc_StandardCostCalculations."Reference Amount";
    //                                                     END;

    //                                                 lrc_StandardCostCalculations."Berechnungsbasis Packauftrag"::Output:
    //                                                     BEGIN
    //                                                         lrc_PackOrderOutput.RESET();
    //                                                         lrc_PackOrderOutput.SETRANGE("Batch Variant No.", lrc_Batch."No.");
    //                                                         lrc_PackOrderOutput.FINDSET(FALSE, FALSE);
    //                                                         ldc_Amount := lrc_PackOrderOutput."Quantity (TU)" * lrc_StandardCostCalculations."Reference Amount";
    //                                                     END;
    //                                             END;
    //                                         END;
    //                                     END; //END: lrc_StandardCostCalculations.Reference::Palette:

    //                                 lrc_StandardCostCalculations.Reference::Container: //Betrag pro Container
    //                                     BEGIN
    //                                         IF lrc_Batch.Source <> lrc_Batch.Source::"Packing Order" THEN BEGIN
    //                                             ErrorSkip := FALSE;
    //                                             // Gesamtpalettenzahl Container berechnen
    //                                             IF (lrc_Batch."Qty. per Unit of Measure" <> 0) AND (lrc_Batch."Qty. (Unit) per Transp. (TU)" <> 0) THEN BEGIN

    //                                                 ldc_QtyPallet := 0;
    //                                                 lrc_BatchContainer.RESET();
    //                                                 lrc_BatchContainer.SETRANGE("Master Batch No.", lrc_Batch."Master Batch No.");
    //                                                 lrc_BatchContainer.SETRANGE("Container No.", lrc_Batch."Container No.");
    //                                                 IF lrc_BatchContainer.FINDSET() THEN BEGIN
    //                                                     REPEAT

    //                                                         IF (lrc_BatchContainer."Qty. per Unit of Measure" <> 0) AND
    //                                                            (lrc_BatchContainer."Qty. (Unit) per Transp. (TU)" <> 0) THEN BEGIN
    //                                                             lrc_BatchContainer.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
    //                                                             ldc_QtyPallet := ldc_QtyPallet +
    //                                                                              (((lrc_BatchContainer."Purch. Order (Qty) (Base)" +
    //                                                                              lrc_BatchContainer."Purch. Rec. (Qty) (Base)") /
    //                                                                              lrc_BatchContainer."Qty. per Unit of Measure") /
    //                                                                              lrc_BatchContainer."Qty. (Unit) per Transp. (TU)");
    //                                                         END ELSE BEGIN
    //                                                             ErrorSkip := TRUE;
    //                                                             ldc_QtyPallet := 0;
    //                                                         END;

    //                                                     UNTIL (lrc_BatchContainer.NEXT() = 0) OR ErrorSkip;

    //                                                     IF ErrorSkip THEN BEGIN
    //                                                         MESSAGE(Text005, lrc_BatchContainer.FIELDCAPTION("Qty. per Unit of Measure"),
    //                                                                         lrc_BatchContainer.FIELDCAPTION("Qty. (Unit) per Transp. (TU)"), lrc_Batch."No.");
    //                                                     END;

    //                                                 END;

    //                                                 // Betrag pro Palette
    //                                                 IF ldc_QtyPallet <> 0 THEN BEGIN
    //                                                     lrc_PurchHeaderRS.GET(lrc_PurchHeaderRS."Document Type"::Order, lrc_Batch."Master Batch No.");
    //                                                     IF lrc_PurchHeaderRS."No. of Containers" <> 0 THEN
    //                                                         ldc_QuantityContainer := lrc_PurchHeaderRS."No. of Containers";
    //                                                     lrc_PurchLineRS.SETRANGE("Master Batch No.", lrc_PurchHeaderRS."No.");
    //                                                     IF lrc_PurchLineRS.COUNT = 0 THEN
    //                                                         ldc_AnzahlZeilen := 1
    //                                                     ELSE
    //                                                         ldc_AnzahlZeilen := lrc_PurchLineRS.COUNT;

    //                                                     lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
    //                                                     ldc_Amount := (lrc_StandardCostCalculations."Reference Amount" /
    //                                                                    ldc_QtyPallet) *
    //                                                                     (((lrc_Batch."Purch. Order (Qty) (Base)" +
    //                                                                      lrc_Batch."Purch. Rec. (Qty) (Base)") / lrc_Batch."Qty. per Unit of Measure") /
    //                                                                      lrc_Batch."Qty. (Unit) per Transp. (TU)") *
    //                                                                      ldc_QuantityContainer;  //RS Anzahl Cont. aus Kopf, da u. U. mehrere Container in einer Zeile
    //                                                                                              //ldc_AnzahlZeilen;       //RS gez. durch Anzahl Zeilen, da für jede Zeile ein Durchlauf
    //                                                 END ELSE BEGIN
    //                                                     ldc_Amount := 0;
    //                                                 END;

    //                                             END ELSE BEGIN
    //                                                 MESSAGE(Text005, lrc_Batch.FIELDCAPTION("Qty. per Unit of Measure"),
    //                                                                 lrc_Batch.FIELDCAPTION("Qty. (Unit) per Transp. (TU)"), lrc_Batch."No.");
    //                                             END;
    //                                         END ELSE BEGIN
    //                                             ERROR('nicht definiert');
    //                                         END;
    //                                     END; //lrc_StandardCostCalculations.Reference::Container:

    //                                 lrc_StandardCostCalculations.Reference::"Net Weight": //Net Weight
    //                                     BEGIN
    //                                         IF lrc_Batch.Source <> lrc_Batch.Source::"Packing Order" THEN BEGIN
    //                                             // Betrag pro Kilo Nettogewicht
    //                                             IF lrc_Batch."Qty. per Unit of Measure" <> 0 THEN BEGIN
    //                                                 // TEST
    //                                                 // ldc_Amount := lrc_StandardCostCalculations."Reference Amount" * lrc_Batch."Net Weight";
    //                                                 lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
    //                                                 ldc_Amount := (((lrc_Batch."Purch. Order (Qty) (Base)" +
    //                                                                 lrc_Batch."Purch. Rec. (Qty) (Base)") / lrc_Batch."Qty. per Unit of Measure") *
    //                                                               lrc_Batch."Net Weight") * lrc_StandardCostCalculations."Reference Amount";
    //                                             END ELSE BEGIN
    //                                                 MESSAGE(Text004, lrc_Batch.FIELDCAPTION("Qty. per Unit of Measure"), lrc_Batch."No.");
    //                                             END;
    //                                         END ELSE BEGIN
    //                                             CASE lrc_StandardCostCalculations."Berechnungsbasis Packauftrag" OF
    //                                                 lrc_StandardCostCalculations."Berechnungsbasis Packauftrag"::Input:
    //                                                     BEGIN
    //                                                         lrc_PackOrderHeader.SETRANGE("Master Batch No.", vco_MasterBatchNo);
    //                                                         lrc_PackOrderHeader.FINDSET(FALSE, FALSE);
    //                                                         lrc_PackOrderHeader.CALCFIELDS("Tot. Qty. Output (Base)");
    //                                                         lrc_PackOrderInput.SETRANGE("Doc. No.", lrc_PackOrderHeader."No.");
    //                                                         lrc_PackOrderInput.SETRANGE("No Revenue", FALSE);
    //                                                         IF lrc_PackOrderInput.FINDSET(FALSE, FALSE) THEN BEGIN
    //                                                             ldc_PackInput := 0;
    //                                                             REPEAT
    //                                                                 ldc_PackInput += lrc_PackOrderInput."Quantity (Base)";
    //                                                             UNTIL lrc_PackOrderInput.NEXT() = 0;
    //                                                         END;
    //                                                         lrc_BatchVariant.RESET();
    //                                                         lrc_BatchVariant.GET(lrc_Batch."No.");
    //                                                         lrc_BatchVariant.CALCFIELDS("B.V. Pack. Output (Qty)");
    //                                                         ldc_Amount := ((lrc_BatchVariant."B.V. Pack. Output (Qty)" /
    //                                                                         lrc_PackOrderHeader."Tot. Qty. Output (Base)") *
    //                                                                         ldc_PackInput) * lrc_StandardCostCalculations."Reference Amount";
    //                                                     END;
    //                                                 lrc_StandardCostCalculations."Berechnungsbasis Packauftrag"::Output:
    //                                                     BEGIN
    //                                                         lrc_BatchVariant.RESET();
    //                                                         lrc_BatchVariant.GET(lrc_Batch."No.");
    //                                                         lrc_BatchVariant.CALCFIELDS("B.V. Pack. Output (Qty)");
    //                                                         ldc_Amount := lrc_BatchVariant."B.V. Pack. Output (Qty)" *
    //                                                                       lrc_StandardCostCalculations."Reference Amount";
    //                                                     END;
    //                                             END;
    //                                         END;
    //                                     END; //lrc_StandardCostCalculations.Reference::"Net Weight":

    //                                 lrc_StandardCostCalculations.Reference::"Gross Weight": //Gross Weight
    //                                     BEGIN
    //                                         IF lrc_Batch.Source <> lrc_Batch.Source::"Packing Order" THEN BEGIN
    //                                             // Betrag pro Kilo Bruttogewicht
    //                                             IF lrc_Batch."Qty. per Unit of Measure" <> 0 THEN BEGIN
    //                                                 // TEST
    //                                                 // ldc_Amount := lrc_StandardCostCalculations."Reference Amount" * lrc_Batch."Gross Weight";
    //                                                 lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
    //                                                 ldc_Amount := (((lrc_Batch."Purch. Order (Qty) (Base)" +
    //                                                                 lrc_Batch."Purch. Rec. (Qty) (Base)") / lrc_Batch."Qty. per Unit of Measure") *
    //                                                               lrc_Batch."Gross Weight") * lrc_StandardCostCalculations."Reference Amount";
    //                                             END ELSE BEGIN
    //                                                 MESSAGE(Text004, lrc_Batch.FIELDCAPTION("Qty. per Unit of Measure"), lrc_Batch."No.");
    //                                             END;
    //                                         END ELSE BEGIN
    //                                             ERROR('nicht definiert');
    //                                         END;
    //                                     END; //lrc_StandardCostCalculations.Reference::"Gross Weight":

    //                                 lrc_StandardCostCalculations.Reference::Amount: //Verteilungsebene Einkaufsbetrag
    //                                     BEGIN
    //                                         IF lrc_Batch.Source <> lrc_Batch.Source::"Packing Order" THEN BEGIN
    //                                             lrc_PurchLineRS.SETRANGE("Batch No.", lrc_Batch."No.");
    //                                             IF lrc_PurchLineRS.FINDSET() THEN
    //                                                 ldc_Amount := lrc_PurchLineRS.Quantity * lrc_PurchLineRS."Purch. Price (Price Base)" *
    //                                                              lrc_StandardCostCalculations."Reference Amount";
    //                                         END ELSE BEGIN
    //                                             ERROR('nicht definiert');
    //                                         END;
    //                                     END; //lrc_StandardCostCalculations.Reference::Amount

    //                                 lrc_StandardCostCalculations.Reference::"Standard Collo": //Standard Collo
    //                                     BEGIN
    //                                         ERROR('Die Verteilungsmethode Standard Kollo ist zur Zeit nicht vorgesehen');
    //                                     END; //lrc_StandardCostCalculations.Reference::"Standard Collo":

    //                                 lrc_StandardCostCalculations.Reference::General: //General
    //                                     BEGIN
    //                                         IF lrc_Batch.Source <> lrc_Batch.Source::"Packing Order" THEN BEGIN
    //                                             // Betrag
    //                                             IF lrc_Batch."Qty. per Unit of Measure" <> 0 THEN BEGIN
    //                                                 TotalQtyOrderCUBase := 0;
    //                                                 TotalQtyRecCUBase := 0;
    //                                                 TotalQty := 0;
    //                                                 Qty := 0;
    //                                                 SplitAmt := 0;
    //                                                 DiffAmt := 0;
    //                                                 lrc_Batch.CALCFIELDS("Purch. Order (Qty) (Base)", "Purch. Rec. (Qty) (Base)");
    //                                                 CalcTotalQuantity(TotalQtyOrderCUBase, TotalQtyRecCUBase, LastBatchNo,
    //                                                                   lrc_MasterBatch."No.", lrc_StandardCostCalculations);

    //                                                 TotalQty := (TotalQtyRecCUBase + TotalQtyOrderCUBase) / lrc_Batch."Qty. per Unit of Measure";
    //                                                 Qty := (lrc_Batch."Purch. Order (Qty) (Base)" + lrc_Batch."Purch. Rec. (Qty) (Base)") /
    //                                                         lrc_Batch."Qty. per Unit of Measure";
    //                                                 SplitAmt := ROUND((lrc_StandardCostCalculations."Reference Amount" / TotalQty) *
    //                                                                    Qty, 0.01);

    //                                                 StandardCostCalculationsTemp.RESET();
    //                                                 IF NOT StandardCostCalculationsTemp.GET(lrc_StandardCostCalculations."Entry No.") THEN BEGIN
    //                                                     StandardCostCalculationsTemp."Entry No." := lrc_StandardCostCalculations."Entry No.";
    //                                                     StandardCostCalculationsTemp."Reference Amount" := SplitAmt;
    //                                                     StandardCostCalculationsTemp.insert();
    //                                                 END ELSE BEGIN
    //                                                     StandardCostCalculationsTemp."Reference Amount" += SplitAmt;
    //                                                     StandardCostCalculationsTemp.MODIFY();
    //                                                 END;

    //                                                 IF lrc_Batch."No." <> LastBatchNo THEN
    //                                                     ldc_Amount := SplitAmt
    //                                                 ELSE BEGIN
    //                                                     DiffAmt := StandardCostCalculationsTemp."Reference Amount" - lrc_StandardCostCalculations."Reference Amount";
    //                                                     ldc_Amount := SplitAmt - DiffAmt;
    //                                                 END;
    //                                             END ELSE BEGIN
    //                                                 MESSAGE(Text004, lrc_Batch.FIELDCAPTION("Qty. per Unit of Measure"), lrc_Batch."No.");
    //                                             END;
    //                                         END ELSE BEGIN
    //                                             ERROR('nicht definiert');
    //                                         END;
    //                                     END; //lrc_StandardCostCalculations.Reference::General:
    //                             END; //CASE lrc_StandardCostCalculations.Reference OF

    //                             // IFW 001 EXO40002.s
    //                             NoInsert := FALSE;
    //                             lrc_CostCalcEnterData.RESET();
    //                             lrc_CostCalcEnterData.SETRANGE("Cost Category Code", lrc_StandardCostCalculations."Cost Category Code");
    //                             lrc_CostCalcEnterData.SETRANGE("Master Batch No.", lrc_Batch."Master Batch No.");
    //                             // TEST <-- Nur prüfen, ob es irgendwelche manuellen Änderungen für diese Kostenkategorie
    //                             lrc_CostCalcEnterData.SETRANGE("Batch No.", lrc_Batch."No.");
    //                             lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");
    //                             lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //                             //lrc_CostCalcEnterData.SETRANGE("Manually Changed Value",TRUE);
    //                             IF NOT lrc_CostCalcEnterData.isempty()THEN
    //                                 NoInsert := TRUE;
    //                             // IFW 001 EXO40002.e

    //                             // -------------------------------------------------------------------------------------------
    //                             // Plankostensatz anlegen
    //                             // -------------------------------------------------------------------------------------------
    //                             IF (ldc_Amount <> 0) AND (NOT NoInsert) THEN BEGIN

    //                                 lrc_CostCalcEnterData.RESET();
    //                                 lrc_CostCalcEnterData.INIT();
    //                                 lrc_CostCalcEnterData."Document No." := 0;
    //                                 lrc_CostCalcEnterData.INSERT(TRUE);

    //                                 lrc_CostCalcEnterData.VALIDATE("Cost Category Code", lrc_StandardCostCalculations."Cost Category Code");
    //                                 lrc_CostCalcEnterData.VALIDATE("Master Batch No.", lrc_Batch."Master Batch No.");
    //                                 lrc_CostCalcEnterData.VALIDATE("Batch No.", lrc_Batch."No.");
    //                                 lrc_CostCalcEnterData.VALIDATE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");
    //                                 lrc_CostCalcEnterData.VALIDATE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //                                 //RS "Documen No. 2 wird beim Einfügen des Datensatzes in lrc_CostCalcEnterData gesetzt
    //                                 //lrc_CostCalcEnterData."Document No. 2" := '';
    //                                 lrc_CostCalcEnterData."Voyage No." := lrc_Batch."Voyage No.";
    //                                 lrc_CostCalcEnterData."Container No." := lrc_Batch."Container No.";
    //                                 lrc_CostCalcEnterData.VALIDATE("Vendor No.", lrc_StandardCostCalculations."Cost Inv. Vendor No.");
    //                                 lrc_CostCalcEnterData.VALIDATE("Currency Code", lrc_StandardCostCalculations."Currency Code");
    //                                 lrc_CostCalcEnterData.VALIDATE(Amount, ldc_Amount);
    //                                 lrc_CostCalcEnterData."Allocation Level" := lrc_CostCalcEnterData."Allocation Level"::"Master Batch No.";
    //                                 IF lrc_StandardCostCalculations.Reference = lrc_StandardCostCalculations.Reference::Pallet THEN
    //                                     lrc_CostCalcEnterData.VALIDATE("Allocation Type", lrc_CostCalcEnterData."Allocation Type"::Pallets)
    //                                 ELSE
    //                                     lrc_CostCalcEnterData.VALIDATE("Allocation Type", lrc_CostCalcEnterData."Allocation Type"::Kolli);
    //                                 lrc_CostCalcEnterData."Generated by System" := TRUE;

    //                                 lrc_CostCalcEnterData.MODIFY(TRUE);
    //                                 COMMIT;

    //                                 IF NOT CostCatTemp.GET(lrc_CostCalcEnterData."Cost Category Code") THEN BEGIN
    //                                     CostCatTemp.INIT();
    //                                     CostCatTemp.Code := lrc_CostCalcEnterData."Cost Category Code";
    //                                     CostCatTemp.insert();
    //                                 END;

    //                                 // Verteilung durchführen
    //                                 AllocateCostPerEnterDataRec(lrc_CostCalcEnterData);

    //                             END;

    //                         END;

    //                     UNTIL lrc_StandardCostCalculations.NEXT() = 0;

    //                 END;

    //             UNTIL lrc_Batch.NEXT() = 0;

    //             // Summe berechnen
    //             CostCatTemp.RESET();
    //             IF CostCatTemp.FINDSET() THEN
    //                 REPEAT
    //                     CostCatCalcTotals(2, lrc_MasterBatch."No.", CostCatTemp.Code, TRUE);
    //                 UNTIL CostCatTemp.NEXT() = 0;

    //             IF GUIALLOWED THEN
    //                 Window.CLOSE;

    //         END;
    //     end;

    //     procedure CheckCostCatValues(var CostCategory: Record "POI Cost Category"; Level: Option Voyage,Container,"Master Batch"; SourceCode: Code[20]; NoEnteredCostCheck: Boolean; NoPostedCostCheck: Boolean): Boolean
    //     var
    //         CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //         PostedCostMgt: Codeunit "5110359";
    //         TotalNetChange: Decimal;
    //         TotalNetChangeQty: Decimal;
    //     begin
    //         // IFW 001 EXO40002.s
    //         // 20131204.s
    //         IF NOT NoEnteredCostCheck THEN BEGIN
    //             // 20131204.e
    //             CostCalcEnterData.RESET();
    //             CostCalcEnterData.SETCURRENTKEY("Entry Type");
    //             CostCalcEnterData.SETRANGE("Entry Type", CostCalcEnterData."Entry Type"::"Detail Batch");
    //             CostCalcEnterData.SETRANGE("Cost Category Code", CostCategory.Code);
    //             CASE Level OF
    //                 Level::Voyage:
    //                     BEGIN
    //                         CostCalcEnterData.SETRANGE("Entry Level", CostCalcEnterData."Entry Level"::Voyage);
    //                         CostCalcEnterData.SETRANGE("Voyage No.", SourceCode);
    //                     END;
    //                 Level::Container:
    //                     BEGIN
    //                         CostCalcEnterData.SETRANGE("Entry Level", CostCalcEnterData."Entry Level"::Container);
    //                         CostCalcEnterData.SETRANGE("Container No.", SourceCode);
    //                     END;
    //                 Level::"Master Batch":
    //                     BEGIN
    //                         CostCalcEnterData.SETRANGE("Entry Level", CostCalcEnterData."Entry Level"::"Master Batch");
    //                         CostCalcEnterData.SETRANGE("Master Batch No.", SourceCode);
    //                     END;
    //             END;
    //             CostCalcEnterData.SETFILTER("Amount (LCY)", '<>%1', 0);
    //             IF NOT CostCalcEnterData.isempty()THEN
    //                 EXIT(TRUE);
    //             // 20131204.s
    //         END;

    //         IF NOT NoPostedCostCheck THEN BEGIN
    //             // 20131204.e
    //             CASE Level OF
    //                 Level::Voyage:
    //                     ;
    //                 Level::Container:
    //                     ;
    //                 Level::"Master Batch":
    //                     BEGIN
    //                         PostedCostMgt.CalcPostCostMasterBatchCostCat(3, SourceCode,
    //                                       CostCategory.Code, 0D, 0D, TotalNetChange, TotalNetChangeQty);
    //                     END;
    //             END;
    //         END;

    //         // 20131204.s
    //         IF NoPostedCostCheck AND NoPostedCostCheck THEN
    //             EXIT(TRUE);
    //         // 20131204.e

    //         IF TotalNetChange <> 0 THEN
    //             EXIT(TRUE);

    //         EXIT(FALSE);
    //         // IFW 001 EXO40002.e
    //     end;

    //     procedure FilterStandardCostCalcTable(var StandardCostCalculations: Record "5110551"; var CostCategory: Record "POI Cost Category"; var MasterBatch: Record "POI Master Batch"; var Batch: Record "POI Batch")
    //     begin
    //         //RS Filtersetzung geändert
    //         IF CostCategory.Code <> '' THEN
    //             StandardCostCalculations.SETRANGE("Cost Category Code", CostCategory.Code);

    //         StandardCostCalculations.SETFILTER("Valid From", '<=%1|%2', MasterBatch."Expected Receipt Date", 0D);
    //         StandardCostCalculations.SETFILTER("Valid Till", '>=%1|%2', MasterBatch."Expected Receipt Date", 0D);

    //         StandardCostCalculations.SETFILTER("Buy-From Vendor No.", '%1|%2', Batch."Vendor No.", '');
    //         StandardCostCalculations.SETFILTER("Entry Location Code", '%1|%2', Batch."Entry Location Code", '');
    //         StandardCostCalculations.SETFILTER("Via Entry Location Code", '%1|%2', Batch."Via Entry Location Code", '');
    //         CASE Batch."Status Customs Duty" OF
    //             Batch."Status Customs Duty"::Verzollt:
    //                 StandardCostCalculations.SETFILTER("Customer Duty", '%1|%2', StandardCostCalculations."Customer Duty"::Verzollt,
    //                                                                              StandardCostCalculations."Customer Duty"::" ");
    //             Batch."Status Customs Duty"::Unverzollt:
    //                 StandardCostCalculations.SETFILTER("Customer Duty", '%1|%2', StandardCostCalculations."Customer Duty"::Unverzollt,
    //                                                                              StandardCostCalculations."Customer Duty"::" ");
    //         END;
    //         StandardCostCalculations.SETFILTER("Item Category Code", '%1|%2', Batch."Item Category Code", '');
    //         StandardCostCalculations.SETFILTER("Product Group Code", '%1|%2', Batch."Product Group Code", '');
    //         StandardCostCalculations.SETFILTER("Item No.", '%1|%2', Batch."Item No.", '');
    //         StandardCostCalculations.SETFILTER("Item Country of Origin Code", '%1|%2', Batch."Country of Origin Code", '');
    //         StandardCostCalculations.SETFILTER("Shipping Agent Code", '%1|%2', MasterBatch."Shipping Agent Code", '');

    //         //RS zusätzliche Filterung auf Zusatzmerkmal
    //         IF Batch.Zusatzmerkmal <> '' THEN BEGIN
    //             StandardCostCalculations.SETRANGE(Zusatzmerkmal, Batch.Zusatzmerkmal);
    //             IF StandardCostCalculations.isempty()THEN
    //                 StandardCostCalculations.SETRANGE(Zusatzmerkmal, '');
    //         END;

    //         //RS zusätzliche Filterung auf Abgangslager
    //         StandardCostCalculations.SETFILTER("Departure Location Code", '%1|%2', Batch."Departure Location Code", '');

    //         // IF StandardCostCalculations.COUNT > 1 THEN
    //         //  ERROR('Mehr als ein Standardplankostensatz gefunden, bitte an Rainer wenden');

    //         //RS bei Plankosten für Packaufträge muss die Berechnungsbasis (Input/Output) angegeben sein
    //         IF Batch.Source = Batch.Source::"Packing Order" THEN
    //             StandardCostCalculations.SETFILTER("Berechnungsbasis Packauftrag", '<>%1',
    //                                               StandardCostCalculations."Berechnungsbasis Packauftrag"::" ");

    //         /************************
    //         StandardCostCalculations.SETRANGE("Buy-From Vendor No.", Batch."Vendor No.");
    //         IF StandardCostCalculations.isempty()THEN
    //           StandardCostCalculations.SETFILTER("Buy-From Vendor No.", '%1', '');

    //         StandardCostCalculations.SETRANGE("Entry Location Code", Batch."Entry Location Code");
    //         IF StandardCostCalculations.isempty()THEN
    //           StandardCostCalculations.SETFILTER("Entry Location Code", '%1', '');

    //         StandardCostCalculations.SETRANGE("Via Entry Location Code", Batch."Via Entry Location Code");
    //         IF StandardCostCalculations.isempty()THEN
    //           StandardCostCalculations.SETFILTER("Via Entry Location Code", '%1', '');

    //         CASE Batch."Status Customs Duty" OF
    //         Batch."Status Customs Duty"::Verzollt:
    //           StandardCostCalculations.SETRANGE("Customer Duty", StandardCostCalculations."Customer Duty"::Verzollt);
    //         Batch."Status Customs Duty"::Unverzollt:
    //           StandardCostCalculations.SETRANGE("Customer Duty",StandardCostCalculations."Customer Duty"::Unverzollt);
    //         Batch."Status Customs Duty"::" ":
    //         StandardCostCalculations.SETRANGE("Customer Duty", 0);
    //         END;

    //         StandardCostCalculations.SETRANGE("Item Category Code", Batch."Item Category Code");
    //         IF StandardCostCalculations.isempty()THEN
    //           StandardCostCalculations.SETFILTER("Item Category Code", '%1', '');

    //         StandardCostCalculations.SETRANGE("Product Group Code", Batch."Product Group Code");
    //         IF StandardCostCalculations.isempty()THEN
    //           StandardCostCalculations.SETFILTER("Product Group Code", '%1', '');

    //         StandardCostCalculations.SETRANGE("Item No.", Batch."Item No.");
    //         IF StandardCostCalculations.isempty()THEN
    //           StandardCostCalculations.SETFILTER("Item No.", '%1', '');

    //         StandardCostCalculations.SETRANGE("Item Country of Origin Code", Batch."Country of Origin Code");
    //         IF StandardCostCalculations.isempty()THEN
    //           StandardCostCalculations.SETFILTER("Item Country of Origin Code", '%1', '');

    //         StandardCostCalculations.SETRANGE("Shipping Agent Code", MasterBatch."Shipping Agent Code");
    //         IF StandardCostCalculations.isempty()THEN
    //           StandardCostCalculations.SETFILTER("Shipping Agent Code", '%1', '');
    //         ************************/
    //         //To-do StandardCostCalculations.SETFILTER("Shipment Method Code",'%1|%2',MasterBatch."Shipment Method Code",'');
    //         //To-do StandardCostCalculations.SETFILTER("Means of Transport Type",'%1|%2',MasterBatch."Means of Transport Type",
    //         //To-do                                        StandardCostCalculations."Means of Transport Type"::"0");
    //         //To-do StandardCostCalculations.SETFILTER("Means of Transport Info",'%1|%2',MasterBatch."Means of Transport Info",'');

    //         // 20130419

    //     end;

    //     procedure CalcTotalQuantity(var TotalQtyOrderCUBase: Decimal; var TotalQtyRecCUBase: Decimal; var LastBatchNo: Code[20]; MasterBatchNo: Code[20]; var DefaultStandardCostCalc: Record "5110551")
    //     var
    //         StandardCostCalculations: Record "5110551";
    //         CostCategory: Record "POI Cost Category";
    //         MasterBatch: Record "POI Master Batch";
    //         Batch: Record "POI Batch";
    //     begin
    //         MasterBatch.GET(MasterBatchNo);
    //         MasterBatch.TESTFIELD("Expected Receipt Date");

    //         TotalQtyOrderCUBase := 0;
    //         TotalQtyRecCUBase := 0;
    //         Batch.RESET();
    //         Batch.SETCURRENTKEY("Master Batch No.");
    //         Batch.SETRANGE("Master Batch No.", MasterBatch."No.");
    //         IF Batch.FINDSET() THEN BEGIN
    //             REPEAT
    //                 Batch.CALCFIELDS("Purch. Rec. (Qty) (Base)", "Purch. Order (Qty) (Base)");
    //                 CostCategory.RESET();
    //                 IF CostCategory.FINDSET() THEN BEGIN
    //                     REPEAT

    //                         StandardCostCalculations.RESET();
    //                         FilterStandardCostCalcTable(StandardCostCalculations, CostCategory, MasterBatch, Batch);
    //                         IF StandardCostCalculations.FINDSET() THEN BEGIN
    //                             REPEAT
    //                                 IF StandardCostCalculations."Entry No." = DefaultStandardCostCalc."Entry No." THEN BEGIN
    //                                     TotalQtyOrderCUBase += Batch."Purch. Order (Qty) (Base)";
    //                                     TotalQtyRecCUBase += Batch."Purch. Rec. (Qty) (Base)";
    //                                     LastBatchNo := Batch."No.";
    //                                 END;
    //                             UNTIL StandardCostCalculations.NEXT() = 0;
    //                         END;
    //                     UNTIL CostCategory.NEXT() = 0;
    //                 END;
    //             UNTIL Batch.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CalcUnitCostPerPurchLine(vrc_PurchaseLine: Record "Purchase Line"): Decimal
    //     var
    //         lrc_CostCategory: Record "POI Cost Category";
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //         ldc_PurchaseIndirectCost: Decimal;
    //     begin
    //         // --------------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung des Einstandspreises auf Basis Einkaufspreis plus Plankosten
    //         // --------------------------------------------------------------------------------------------

    //         lrc_CostCategory.SETRANGE("Indirect Cost (Purchase)", TRUE);
    //         IF lrc_CostCategory.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 lrc_CostCalcEnterData.SETRANGE("Batch Variant No.", vrc_PurchaseLine."Batch Variant No.");
    //                 lrc_CostCalcEnterData.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                 lrc_CostCalcEnterData.SETRANGE("Entry Level", lrc_CostCalcEnterData."Entry Level"::"Master Batch");
    //                 lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Enter Data");
    //                 IF lrc_CostCalcEnterData.FINDSET(FALSE, FALSE) THEN BEGIN
    //                     REPEAT

    //                         lrc_CostCalcEnterData."Qty. Colli" := vrc_PurchaseLine.Quantity;
    //                         lrc_CostCalcEnterData."Qty. Pallet" := vrc_PurchaseLine."Quantity (TU)";

    //                         ldc_PurchaseIndirectCost := ldc_PurchaseIndirectCost + 0;

    //                     UNTIL lrc_CostCalcEnterData.NEXT() = 0;
    //                 END;
    //             UNTIL lrc_CostCategory.NEXT() = 0;
    //         END;

    //         IF vrc_PurchaseLine.Quantity = 0 THEN BEGIN

    //             ldc_PurchaseIndirectCost := ROUND(ldc_PurchaseIndirectCost / vrc_PurchaseLine.Quantity, 0.01, '>');
    //             // Achtung Währung muss noch berücksichtigt werden
    //             vrc_PurchaseLine."Unit Cost (LCY)" := vrc_PurchaseLine."Direct Unit Cost" +
    //                                                   ldc_PurchaseIndirectCost;
    //             vrc_PurchaseLine."Indirect Cost %" := (((vrc_PurchaseLine."Unit Cost (LCY)" /
    //                                                      vrc_PurchaseLine."Direct Unit Cost") * 100) - 100);

    //         END ELSE BEGIN
    //             vrc_PurchaseLine."Indirect Cost %" := 0;
    //         END;

    //         EXIT(vrc_PurchaseLine."Indirect Cost %");
    //     end;

    //     procedure CostCalcIndCostperPurchHeader(vop_DocType: Option "0","1","2","3","4","5","6"; vco_DocNo: Code[20])
    //     var
    //         lrc_PurchaseHeader: Record "Purchase Header";
    //         lrc_PurchaseLine: Record "Purchase Line";
    //     begin

    //         lrc_PurchaseHeader.GET(vop_DocType, vco_DocNo);

    //         lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
    //         lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
    //         lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
    //         lrc_PurchaseLine.SETFILTER("No.", '<>%1', '');
    //         IF lrc_PurchaseLine.FINDSET(TRUE, FALSE) THEN BEGIN
    //             REPEAT
    //                 IF lrc_PurchaseLine."Batch No." <> '' THEN BEGIN

    //                     CostCalcIndCostperPurchLine(lrc_PurchaseLine);

    //                 END;
    //             UNTIL lrc_PurchaseLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CostCalcIndCostperPurchLine(vrc_PurchaseLine: Record "Purchase Line"): Decimal
    //     var
    //         lrc_CostCalcEnterData: Record "POI Cost Calc. - Enter Data";
    //         lrc_CostCategory: Record "POI Cost Category";
    //         ldc_PurchaseIndirectCost: Decimal;
    //     begin


    //         lrc_CostCalcEnterData.SETRANGE("Entry Type", lrc_CostCalcEnterData."Entry Type"::"Detail Batch");
    //         lrc_CostCalcEnterData.SETRANGE("Batch No.", vrc_PurchaseLine."Batch No.");
    //         IF lrc_CostCalcEnterData.FINDSET(TRUE, FALSE) THEN BEGIN
    //             REPEAT
    //                 IF lrc_CostCategory.GET(lrc_CostCalcEnterData."Cost Category Code") THEN BEGIN
    //                     IF lrc_CostCategory."Indirect Cost (Purchase)" THEN BEGIN

    //                         ldc_PurchaseIndirectCost := ldc_PurchaseIndirectCost + lrc_CostCalcEnterData."Amount (LCY)";

    //                     END;
    //                 END;
    //             UNTIL lrc_CostCalcEnterData.NEXT() = 0;
    //         END;

    //         EXIT(ldc_PurchaseIndirectCost);
    //     end;

    //     procedure CostCalcPurchLine(vrc_PurchLine: Record "Purchase Line"): Decimal
    //     var
    //         lrc_CostCategory: Record "POI Cost Category";
    //         lrc_StandardCostCalculations: Record "5110551";
    //         ldc_IndirectCost: Decimal;
    //     begin
    //         // ----------------------------------------------------------------------------
    //         // Plankosten für Einkaufszeile berechnen
    //         // ----------------------------------------------------------------------------

    //         IF (vrc_PurchLine.Type <> vrc_PurchLine.Type::Item) OR
    //            (vrc_PurchLine."No." = '') THEN
    //             EXIT(0);

    //         lrc_CostCategory.SETRANGE("Indirect Cost (Purchase)", TRUE);
    //         IF lrc_CostCategory.FINDSET(FALSE, FALSE) THEN BEGIN
    //             REPEAT
    //                 lrc_StandardCostCalculations.RESET();
    //                 lrc_StandardCostCalculations.SETRANGE("Cost Category Code", lrc_CostCategory.Code);
    //                 lrc_StandardCostCalculations.SETFILTER("Buy-From Vendor No.", '%1|%2', vrc_PurchLine."Buy-from Vendor No.", '');
    //                 lrc_StandardCostCalculations.SETFILTER("Via Entry Location Code", '%1|%2', vrc_PurchLine."Entry via Transfer Loc. Code", '');
    //                 lrc_StandardCostCalculations.SETFILTER("Entry Location Code", '%1|%2', vrc_PurchLine."Location Code", '');
    //                 lrc_StandardCostCalculations.SETFILTER("Item Category Code", '%1|%2', vrc_PurchLine."Item Category Code", '');
    //                 lrc_StandardCostCalculations.SETFILTER("Product Group Code", '%1|%2', vrc_PurchLine."Product Group Code", '');
    //                 lrc_StandardCostCalculations.SETFILTER("Item No.", '%1|%2', vrc_PurchLine."No.", '');
    //                 lrc_StandardCostCalculations.SETFILTER("Item Country of Origin Code", '%1|%2', vrc_PurchLine."Country of Origin Code", '');
    //                 lrc_StandardCostCalculations.SETFILTER("Shipping Agent Code", '%1|%2', vrc_PurchLine."Shipping Agent Code", '');
    //                 lrc_StandardCostCalculations.SETFILTER("Valid From", '<=%1', TODAY);
    //                 lrc_StandardCostCalculations.SETFILTER("Valid Till", '>=%1|%2', Today(), 0D);
    //                 IF lrc_StandardCostCalculations.FINDLAST THEN BEGIN
    //                     CASE lrc_StandardCostCalculations.Reference OF
    //                         lrc_StandardCostCalculations.Reference::Collo:
    //                             BEGIN
    //                                 ldc_IndirectCost := ldc_IndirectCost +
    //                                                     ROUND(vrc_PurchLine.Quantity *
    //                                                           lrc_StandardCostCalculations."Reference Amount", 0.01, '>');
    //                             END;
    //                         lrc_StandardCostCalculations.Reference::Pallet:
    //                             BEGIN
    //                                 ldc_IndirectCost := ldc_IndirectCost +
    //                                                     ROUND(ROUND(vrc_PurchLine."Quantity (TU)", 1, '>') *
    //                                                           lrc_StandardCostCalculations."Reference Amount", 0.01, '>');
    //                             END;
    //                     END;
    //                 END;
    //             UNTIL lrc_CostCategory.NEXT() = 0;
    //         END;

    //         EXIT(ldc_IndirectCost);
    //     end;

    //     procedure CalcCostsByBatch(SourceMasterBatchNo: Code[20]; var BatchNo: Code[20]; SourceDocumentOptionNo: Integer; SourceDocumentNo: Code[20]; SourceDocumentLineNo: Integer; CostDocumentOptionNo: Integer; CostDocumentNo: Code[20]; CostDocumentLineNo: Integer; ItemShptEntryNo: Integer; var PurchCosts: Decimal; var RTOCosts: Decimal; var RTOCostsNoAssignment: Decimal; var PackingCosts: Decimal)
    //     var
    //         BatchSetup: Record "POI Master Batch Setup";
    //         GeneralLedgerSetup: Record "General Ledger Setup";
    //         Batch: Record "POI Batch";
    //         MasterBatch: Record "POI Master Batch";
    //         CostCategory: Record "POI Cost Category";
    //         CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         PackOrderRevperInpBatch: Record "5110726";
    //         CostCategoryAccounts: Record "5110346";
    //         GLEntry: Record "G/L Entry";
    //         ItemLedgerEntry: Record "Item Ledger Entry";
    //         CostCatCode: Code[20];
    //         GLAccountFilter: Text[1024];
    //         PackOrderInputItems: Record "POI Pack. Order Input Items";
    //         Ratio: Decimal;
    //         BatchVariant: Record "POI Batch Variant";
    //         Purchased: Decimal;
    //         PackPurchCosts: Decimal;
    //         PackRTOCosts: Decimal;
    //         PackRTOCostsNoAssignment: Decimal;
    //         PackPackingCosts: Decimal;
    //     begin
    //         PurchCosts := 0;
    //         RTOCosts := 0;
    //         RTOCostsNoAssignment := 0;
    //         PackingCosts := 0;

    //         IF BatchNo = '' THEN
    //             EXIT;

    //         IF SourceMasterBatchNo = '' THEN
    //             EXIT;

    //         Batch.GET(BatchNo);
    //         MasterBatch.GET(SourceMasterBatchNo);

    //         BatchSetup.GET();
    //         GeneralLedgerSetup.GET();



    //         GLEntry.RESET();
    //         GLEntry.SETCURRENTKEY("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code",
    //                               "Global Dimension 2 Code", "Global Dimension 3 Code", "Global Dimension 4 Code",
    //                               "Close Income Statement Dim. ID", "Posting Date");

    //         GLAccountFilter := BuildGLAccFilter('');
    //         GLEntry.SETFILTER("G/L Account No.", GLAccountFilter);

    //         CASE BatchSetup."Dim. No. Batch No." OF
    //             BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                 GLEntry.SETRANGE("Global Dimension 1 Code", Batch."No.");
    //             BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                 GLEntry.SETRANGE("Global Dimension 2 Code", Batch."No.");
    //             BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                 GLEntry.SETRANGE("Global Dimension 3 Code", Batch."No.");
    //             BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                 GLEntry.SETRANGE("Global Dimension 4 Code", Batch."No.");
    //         END;

    //         CASE BatchSetup."Dim. No. Cost Category" OF
    //             BatchSetup."Dim. No. Cost Category"::"1. Dimension":
    //                 GLEntry.SETFILTER("Global Dimension 1 Code", '<>%1', '');
    //             BatchSetup."Dim. No. Cost Category"::"2. Dimension":
    //                 GLEntry.SETFILTER("Global Dimension 2 Code", '<>%1', '');
    //             BatchSetup."Dim. No. Cost Category"::"3. Dimension":
    //                 GLEntry.SETFILTER("Global Dimension 3 Code", '<>%1', '');
    //             BatchSetup."Dim. No. Cost Category"::"4. Dimension":
    //                 GLEntry.SETFILTER("Global Dimension 4 Code", '<>%1', '');
    //         END;

    //         IF GLEntry.FINDSET() THEN
    //             REPEAT

    //                 CASE BatchSetup."Dim. No. Cost Category" OF
    //                     BatchSetup."Dim. No. Cost Category"::"1. Dimension":
    //                         CostCatCode := GLEntry."Global Dimension 1 Code";
    //                     BatchSetup."Dim. No. Cost Category"::"2. Dimension":
    //                         CostCatCode := GLEntry."Global Dimension 2 Code";
    //                     BatchSetup."Dim. No. Cost Category"::"3. Dimension":
    //                         CostCatCode := GLEntry."Global Dimension 3 Code";
    //                     BatchSetup."Dim. No. Cost Category"::"4. Dimension":
    //                         CostCatCode := GLEntry."Global Dimension 4 Code";
    //                 END;

    //                 IF CostCategory.GET(CostCatCode) AND (NOT CostCategory."Direct Cost (Purchase)") THEN BEGIN

    //                     // Cost Schema Code,Cost Category Code,G/L Account No.,Dimension Code,Dimension Value
    //                     IF CostCategoryAccounts.GET('', CostCatCode, GLEntry."G/L Account No.",
    //                                                 BatchSetup."Dim. Code Cost Category", CostCatCode) THEN BEGIN

    //                         // EK-Kosten
    //                         IF NOT CostCategory."Reduce Cost from Turnover" THEN
    //                             PurchCosts += GLEntry.Amount;

    //                         // VK-RTO-Kosten

    //                         IF CostCategory."Reduce Cost from Turnover" THEN BEGIN
    //                             //  IF ItemShptEntryNo <> 0 THEN BEGIN
    //                             //    IF GLEntry."Cost Item Shpt. Entry No." = ItemShptEntryNo THEN
    //                             //      RTOCosts += GLEntry.Amount;
    //                             //  END ELSE BEGIN
    //                             //    IF (CostDocumentOptionNo <> 0) AND
    //                             //       (CostDocumentNo <> '') AND
    //                             //       (CostDocumentLineNo <> 0) THEN BEGIN
    //                             //      IF (GLEntry."Cost Document Type" = CostDocumentOptionNo) AND
    //                             //         (GLEntry."Cost Document No." = CostDocumentNo) AND
    //                             //         (GLEntry."Cost Document Line No." = CostDocumentLineNo) THEN BEGIN
    //                             //        RTOCosts += GLEntry.Amount;
    //                             //      END;
    //                             //    END;
    //                             //  END;

    //                             //  IF (GLEntry."Cost Document No." = '') AND (GLEntry."Cost Item Shpt. Entry No." = 0) THEN BEGIN
    //                             RTOCostsNoAssignment += GLEntry.Amount;
    //                             //  END;
    //                         END;

    //                     END;

    //                 END;

    //             UNTIL GLEntry.NEXT() = 0;



    //         // Packerei Kosten
    //         PackOrderRevperInpBatch.RESET();
    //         PackOrderRevperInpBatch.SETCURRENTKEY("Item Ledger Entry No.", "Sales Order Doc. No.", "Sales Order Line No.");

    //         //IF ItemShptEntryNo <> 0 THEN BEGIN
    //         //  PackOrderRevperInpBatch.SETRANGE("Item Ledger Entry No.",ItemShptEntryNo);
    //         //END ELSE BEGIN
    //         //  PackOrderRevperInpBatch.SETRANGE("Sales Order Doc. No.",SourceDocumentNo);
    //         //  PackOrderRevperInpBatch.SETRANGE("Sales Order Line No.",SourceDocumentLineNo);
    //         //END;

    //         PackOrderRevperInpBatch.SETRANGE("Output Batch No.", Batch."No.");
    //         IF PackOrderRevperInpBatch.FINDSET() THEN
    //             REPEAT

    //                 //IF MasterBatch."Cost Status" = MasterBatch."Cost Status"::"Planned Costs" THEN BEGIN
    //                 //  PackingCosts += PackOrderRevperInpBatch."Input Pack. Cost Planned (LCY)" * -1;
    //                 //END;

    //                 //IF MasterBatch."Cost Status" = MasterBatch."Cost Status"::"Posted Costs" THEN BEGIN
    //                 PackingCosts += PackOrderRevperInpBatch."Input Packing Cost (LCY)" * -1;
    //             //END;

    //             UNTIL PackOrderRevperInpBatch.NEXT() = 0;

    //         // MVO 27.05.13.s
    //         // Kommt die Partie aus einer Packerei?
    //         // Wenn ja, werden die Kosten von dort aufaddiert
    //         BatchVariant.RESET();
    //         BatchVariant.SETRANGE("Batch No.", BatchNo);
    //         IF BatchVariant.FINDFIRST()() THEN
    //             IF (BatchVariant.Source = BatchVariant.Source::"Packing Order") THEN BEGIN
    //                 PackOrderInputItems.SETRANGE("Doc. No.", BatchVariant."Source No.");
    //                 //PackOrderInputItems.SETRANGE("Line No.", BatchVariant."Source Line No.");

    //                 //IF (MasterBatch.Source = MasterBatch.Source::"Packing Order") THEN BEGIN
    //                 //PackOrderInputItems.SETRANGE("Doc. No.", MasterBatch."Source No.");
    //                 IF PackOrderInputItems.FINDSET() THEN
    //                     REPEAT
    //                         Ratio := PackOrderInputItems."Quantity (Base)";

    //                         IF BatchVariant.GET(PackOrderInputItems."Batch Variant No.") THEN BEGIN
    //                             BatchVariant.CALCFIELDS("B.V. Purch. Order (Qty)", "B.V. Purch. Rec. (Qty)",
    //                                                     "B.V. Pack. Output (Qty)", "B.V. Pos. Shipped Adjmt. (Qty)");
    //                             IF BatchVariant."B.V. Purch. Order (Qty)" <> 0 THEN
    //                                 Purchased := BatchVariant."B.V. Purch. Order (Qty)"
    //                             ELSE
    //                                 IF BatchVariant."B.V. Purch. Rec. (Qty)" <> 0 THEN
    //                                     Purchased := BatchVariant."B.V. Purch. Rec. (Qty)"
    //                                 ELSE
    //                                     IF BatchVariant."B.V. Pack. Output (Qty)" <> 0 THEN
    //                                         Purchased := BatchVariant."B.V. Pack. Output (Qty)"
    //                                     ELSE
    //                                         Purchased := BatchVariant."B.V. Pos. Shipped Adjmt. (Qty)";
    //                         END ELSE
    //                             Purchased := 0;

    //                         IF Purchased <> 0 THEN
    //                             Ratio := Ratio / Purchased
    //                         ELSE
    //                             Ratio := 0;

    //                         CalcCostsByBatch(PackOrderInputItems."Master Batch No.", PackOrderInputItems."Batch No.",
    //                                          ItemLedgerEntry."Source Doc. Type"::"Input Packing Order",
    //                                          PackOrderInputItems."Doc. No.", PackOrderInputItems."Line No.",
    //                                          //To-Do? CostDocumentOptionNo, CostDocumentNo, CostDocumentLineNo, ItemShptEntryNo,
    //                                          0, '', 0, 0,
    //                                          PackPurchCosts, PackRTOCosts, PackRTOCostsNoAssignment, PackPackingCosts);

    //                         PurchCosts += PackPurchCosts * Ratio;
    //                         RTOCosts += PackRTOCosts * Ratio;
    //                         RTOCostsNoAssignment += PackRTOCostsNoAssignment * Ratio;
    //                         PackingCosts += PackPackingCosts * Ratio;

    //                     UNTIL PackOrderInputItems.NEXT(1) = 0;
    //             END;
    //     end;

    //     procedure CalcPurchAmt(var BatchVariant: Record "POI Batch Variant"; var PurchGrossAmt: Decimal; var PurchDisc: Decimal; var PurchNetAmt: Decimal; var PurchQtyBase: Decimal)
    //     var
    //         PurchHdr: Record "Purchase Header";
    //         PurchLine: Record "Purchase Line";
    //         PurchItemLedgerEntry: Record "Item Ledger Entry";
    //         BatchSetup: Record "POI Master Batch Setup";
    //         GeneralLedgerSetup: Record "General Ledger Setup";
    //         MasterBatch: Record "POI Master Batch";
    //         CostCategory: Record "POI Cost Category";
    //         CostCalculation: Record "POI Cost Calc. - Enter Data";
    //         CostCategoryAccounts: Record "POI Cost Category Accounts";
    //         GLEntry: Record "G/L Entry";
    //         ValueEntry: Record "Value Entry";
    //         PackOrderInputItems: Record "POI Pack. Order Input Items";
    //         PackBatchVariant: Record "POI Batch Variant";
    //         PackOrderOutputItems: Record "POI Pack. Order Output Items";
    //         BatchVariant2: Record "POI Batch Variant";
    //         CostCatDimCode: Code[20];
    //         GLAccountFilter: Text[1024];
    //         Ratio: Decimal;
    //         Purchased: Decimal;
    //         PackPurchGrossAmt: Decimal;
    //         PackPurchDisc: Decimal;
    //         PackPurchNetAmt: Decimal;
    //         PackPurchQtyBase: Decimal;
    //         QtyRcdNotInvoiced: Decimal;
    //         LocalPurchGrossAmt: Decimal;
    //         LocalPurchDisc: Decimal;
    //         LocalPurchNetAmt: Decimal;
    //         LocalPurchQtyBase: Decimal;
    //     begin
    //         PurchGrossAmt := 0;
    //         PurchDisc := 0;
    //         PurchNetAmt := 0;
    //         PurchQtyBase := 0;

    //         BatchSetup.GET();
    //         GeneralLedgerSetup.GET();

    //         IF NOT MasterBatch.GET(BatchVariant."Master Batch No.") THEN
    //             EXIT;


    //         // -----------------------------------
    //         // ungebuchte Beträge und Mengen holen
    //         // -----------------------------------
    //         LocalPurchGrossAmt := 0;
    //         LocalPurchDisc := 0;
    //         LocalPurchNetAmt := 0;
    //         LocalPurchQtyBase := 0;

    //         PurchLine.RESET();
    //         PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
    //         PurchLine.SETRANGE("Document No.", BatchVariant."Source No.");
    //         PurchLine.SETRANGE("Line No.", BatchVariant."Source Line No.");
    //         PurchLine.SETFILTER("Outstanding Quantity", '<>%1', 0);
    //         IF PurchLine.FINDFIRST() THEN BEGIN
    //             PurchHdr.GET(PurchLine."Document Type", PurchLine."Document No.");
    //             LocalPurchGrossAmt := PurchLine."Direct Unit Cost" * PurchLine."Outstanding Quantity";
    //             LocalPurchDisc := PurchLine."Line Discount Amount" -
    //                               PurchLine."Inv. Discount Amount" -
    //                               PurchLine."Inv. Disc. not Relat. to Goods" -
    //                               PurchLine."Accruel Inv. Disc. (External)" -
    //                               PurchLine."Accruel Inv. Disc. (Internal)";
    //             LocalPurchDisc := (LocalPurchDisc / PurchLine.Quantity) * PurchLine."Outstanding Quantity";

    //             IF PurchHdr."Currency Code" <> '' THEN BEGIN
    //                 IF LocalPurchGrossAmt <> 0 THEN
    //                     LocalPurchGrossAmt := CalcInLCY(PurchHdr."Posting Date",
    //                                                     PurchHdr."Currency Code",
    //                                                     LocalPurchGrossAmt,
    //                                                     PurchHdr."Currency Factor");
    //                 IF LocalPurchDisc <> 0 THEN
    //                     LocalPurchDisc := CalcInLCY(PurchHdr."Posting Date",
    //                                                 PurchHdr."Currency Code",
    //                                                 LocalPurchDisc,
    //                                                 PurchHdr."Currency Factor");
    //             END;

    //             // Nettobetrag berechnen
    //             LocalPurchNetAmt := LocalPurchGrossAmt - LocalPurchDisc;

    //             // Menge
    //             LocalPurchQtyBase := PurchLine."Outstanding Qty. (Base)";

    //             // In Originalvariablen übertragen
    //             PurchGrossAmt += LocalPurchGrossAmt;
    //             PurchDisc += LocalPurchDisc;
    //             PurchNetAmt += LocalPurchNetAmt;
    //             PurchQtyBase += LocalPurchQtyBase;

    //         END;


    //         // ---------------------------------------------------------------------------------------------------------------
    //         // gelieferte Mengen, gelieferte aber nicht fakt. Beträge und fakturierte Beträge (nur tatsächliche Beträge) holen
    //         // ---------------------------------------------------------------------------------------------------------------
    //         PurchItemLedgerEntry.RESET();
    //         PurchItemLedgerEntry.SETCURRENTKEY("Entry Type", "Master Batch No.", "Batch No.");
    //         PurchItemLedgerEntry.SETRANGE("Entry Type", PurchItemLedgerEntry."Entry Type"::Purchase);
    //         PurchItemLedgerEntry.SETRANGE("Master Batch No.", BatchVariant."Master Batch No.");
    //         PurchItemLedgerEntry.SETRANGE("Batch No.", BatchVariant."Batch No.");
    //         IF PurchItemLedgerEntry.FINDSET() THEN BEGIN
    //             REPEAT

    //                 // Werte zurücksetzen
    //                 LocalPurchGrossAmt := 0;
    //                 LocalPurchDisc := 0;
    //                 LocalPurchNetAmt := 0;
    //                 LocalPurchQtyBase := 0;
    //                 QtyRcdNotInvoiced := 0;

    //                 // FlowFields berechnen
    //                 PurchItemLedgerEntry.CALCFIELDS("Purchase Amount (Actual)");
    //                 PurchItemLedgerEntry.CALCFIELDS("Inv. Disc. (Actual)", "Inv. Disc. not Relat. to Goods",
    //                                                 "Accruel Inv. Disc. (External)", "Accruel Inv. Disc. (Internal)");

    //                 // gelieferte Mengen
    //                 LocalPurchQtyBase := PurchItemLedgerEntry.Quantity;

    //                 // In Originalvariable übertragen
    //                 PurchQtyBase += LocalPurchQtyBase;


    //                 // gelieferte und nicht fakt. Beträge
    //                 QtyRcdNotInvoiced := (PurchItemLedgerEntry.Quantity - PurchItemLedgerEntry."Invoiced Quantity") /
    //                                      PurchItemLedgerEntry."Qty. per Unit of Measure";

    //                 IF QtyRcdNotInvoiced > 0 THEN BEGIN
    //                     IF NOT ((PurchItemLedgerEntry."Invoiced Quantity" = 0) AND (PurchItemLedgerEntry."Purchase Amount (Actual)" <> 0)) THEN BEGIN

    //                         PurchLine.RESET();
    //                         PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
    //                         PurchLine.SETRANGE("Document No.", BatchVariant."Source No.");
    //                         PurchLine.SETRANGE("Line No.", BatchVariant."Source Line No.");
    //                         IF PurchLine.FINDFIRST() THEN BEGIN
    //                             PurchHdr.GET(PurchLine."Document Type", PurchLine."Document No.");
    //                             LocalPurchGrossAmt := PurchLine."Direct Unit Cost" * QtyRcdNotInvoiced;
    //                             LocalPurchDisc := PurchLine."Line Discount Amount" -
    //                                               PurchLine."Inv. Discount Amount" -
    //                                               PurchLine."Inv. Disc. not Relat. to Goods" -
    //                                               PurchLine."Accruel Inv. Disc. (External)" -
    //                                               PurchLine."Accruel Inv. Disc. (Internal)";
    //                             LocalPurchDisc := (LocalPurchDisc / PurchLine.Quantity) * QtyRcdNotInvoiced;

    //                             // ggf. Währung umrechnen
    //                             PurchHdr.GET(PurchLine."Document Type", PurchLine."Document No.");
    //                             IF PurchHdr."Currency Code" <> '' THEN BEGIN
    //                                 IF LocalPurchGrossAmt <> 0 THEN
    //                                     LocalPurchGrossAmt := CalcInLCY(PurchItemLedgerEntry."Posting Date",
    //                                                                     PurchHdr."Currency Code",
    //                                                                     LocalPurchGrossAmt,
    //                                                                     PurchHdr."Currency Factor");
    //                                 IF LocalPurchDisc <> 0 THEN
    //                                     LocalPurchDisc := CalcInLCY(PurchItemLedgerEntry."Posting Date",
    //                                                                 PurchHdr."Currency Code",
    //                                                                 LocalPurchDisc,
    //                                                                 PurchHdr."Currency Factor");
    //                             END;

    //                             // Nettobetrag berechnen
    //                             LocalPurchNetAmt := LocalPurchGrossAmt - LocalPurchDisc;

    //                             // In Originalvariablen übertragen
    //                             PurchGrossAmt += LocalPurchGrossAmt;
    //                             PurchDisc += LocalPurchDisc;
    //                             PurchNetAmt += LocalPurchNetAmt;

    //                         END;
    //                     END;
    //                 END;


    //                 // fakturierte Beträge (nur tatsächliche Beträge)
    //                 LocalPurchGrossAmt := 0;
    //                 LocalPurchDisc := 0;
    //                 LocalPurchNetAmt := 0;

    //                 LocalPurchGrossAmt := PurchItemLedgerEntry."Purchase Amount (Actual)" -
    //                                       PurchItemLedgerEntry."Inv. Disc. (Actual)";
    //                 LocalPurchDisc := (PurchItemLedgerEntry."Inv. Disc. (Actual)" +
    //                                    PurchItemLedgerEntry."Inv. Disc. not Relat. to Goods" +
    //                                    PurchItemLedgerEntry."Accruel Inv. Disc. (External)" +
    //                                    PurchItemLedgerEntry."Accruel Inv. Disc. (Internal)") * -1;

    //                 // Nettobetrag berechnen
    //                 LocalPurchNetAmt := LocalPurchGrossAmt - LocalPurchDisc;

    //                 /*
    //                 // Zu-/Abschlagswertposten mit Kosten Code und Position wieder rausrechnen, weil diese unten
    //                 // bei den Kosten als Sachposten schon dazugezählt werden
    //                 ValueEntry.RESET();
    //                 ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
    //                 ValueEntry.SETRANGE("Item Ledger Entry No.",PurchItemLedgerEntry."Entry No.");
    //                 ValueEntry.SETFILTER("Item Charge No.",'<>%1','');

    //                 CASE BatchSetup."Dim. No. Batch No." OF
    //                   BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //                     ValueEntry.SETFILTER("Global Dimension 1 Code",'<>%1','');
    //                   BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //                     ValueEntry.SETFILTER("Global Dimension 2 Code",'<>%1','');
    //                   BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //                     ValueEntry.SETFILTER("Global Dimension 3 Code",'<>%1','');
    //                   BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //                     ValueEntry.SETFILTER("Global Dimension 4 Code",'<>%1','');
    //                 END;

    //                 CASE BatchSetup."Dim. No. Cost Category" OF
    //                   BatchSetup."Dim. No. Cost Category"::"1. Dimension":
    //                     ValueEntry.SETFILTER("Global Dimension 1 Code",'<>%1','');
    //                   BatchSetup."Dim. No. Cost Category"::"2. Dimension":
    //                     ValueEntry.SETFILTER("Global Dimension 2 Code",'<>%1','');
    //                   BatchSetup."Dim. No. Cost Category"::"3. Dimension":
    //                     ValueEntry.SETFILTER("Global Dimension 3 Code",'<>%1','');
    //                   BatchSetup."Dim. No. Cost Category"::"4. Dimension":
    //                     ValueEntry.SETFILTER("Global Dimension 4 Code",'<>%1','');
    //                 END;
    //                 IF ValueEntry.FINDSET() THEN BEGIN
    //                   REPEAT
    //                     LocalPurchNetAmt -= ValueEntry."Purchase Amount (Actual)";
    //                   UNTIL ValueEntry.NEXT() = 0;
    //                 END;
    //                 */

    //                 // In Originalvariablen übertragen
    //                 PurchGrossAmt += LocalPurchGrossAmt;
    //                 PurchDisc += LocalPurchDisc;
    //                 PurchNetAmt += LocalPurchNetAmt;

    //             UNTIL PurchItemLedgerEntry.NEXT() = 0;
    //         END;


    //         // Werte zurücksetzen
    //         LocalPurchNetAmt := 0;


    //         // -------------------------------------------------------------
    //         // Plankosten und gebuchte Kosten für den Wareneinsatz berechnen
    //         // -------------------------------------------------------------
    //         /*
    //         // EK-Plankosten
    //         IF MasterBatch."Cost Status" = MasterBatch."Cost Status"::"Planned Costs" THEN BEGIN
    //           CostCategory.RESET();
    //           CostCategory.SETRANGE("Reduce Cost from Turnover",FALSE);
    //           CostCategory.SETRANGE("Direct Cost (Purchase)",TRUE); // <- Nur Wareneinsatzkategorien
    //           IF CostCategory.FINDSET() THEN BEGIN
    //             REPEAT
    //               CostCalculation.RESET();
    //               CostCalculation.SETCURRENTKEY("Master Batch No.","Batch No.","Batch Variant No.");
    //               CostCalculation.SETRANGE("Batch No.",BatchVariant."Batch No.");
    //               CostCalculation.SETRANGE("Cost Category Code",CostCategory.Code);
    //               CostCalculation.SETRANGE("Entry Type",CostCalculation."Entry Type"::"Detail Batch");
    //               IF CostCalculation.FINDSET() THEN
    //                 REPEAT
    //                   LocalPurchNetAmt += CostCalculation."Amount (LCY)";
    //                 UNTIL CostCalculation.NEXT() = 0;
    //             UNTIL CostCategory.NEXT() = 0;

    //             // In Originalvariablen übertragen
    //             PurchNetAmt += LocalPurchNetAmt;

    //           END;
    //         END;


    //         // Werte zurücksetzen
    //         LocalPurchNetAmt := 0;


    //         // EK-Kosten (gebucht)
    //         IF MasterBatch."Cost Status" = MasterBatch."Cost Status"::"Posted Costs" THEN BEGIN

    //           GLEntry.RESET();
    //           GLEntry.SETCURRENTKEY("G/L Account No.","Business Unit Code","Global Dimension 1 Code",
    //                                 "Global Dimension 2 Code","Global Dimension 3 Code","Global Dimension 4 Code",
    //                                 "Close Income Statement Dim. ID","Posting Date");

    //           GLAccountFilter := BuildGLAccFilter('');
    //           GLEntry.SETFILTER("G/L Account No.",GLAccountFilter);

    //           CASE BatchSetup."Dim. No. Batch No." OF
    //             BatchSetup."Dim. No. Batch No."::"1. Dimension":
    //               GLEntry.SETRANGE("Global Dimension 1 Code",BatchVariant."Batch No.");
    //             BatchSetup."Dim. No. Batch No."::"2. Dimension":
    //               GLEntry.SETRANGE("Global Dimension 2 Code",BatchVariant."Batch No.");
    //             BatchSetup."Dim. No. Batch No."::"3. Dimension":
    //               GLEntry.SETRANGE("Global Dimension 3 Code",BatchVariant."Batch No.");
    //             BatchSetup."Dim. No. Batch No."::"4. Dimension":
    //               GLEntry.SETRANGE("Global Dimension 4 Code",BatchVariant."Batch No.");
    //           END;

    //           CASE BatchSetup."Dim. No. Cost Category" OF
    //             BatchSetup."Dim. No. Cost Category"::"1. Dimension":
    //               GLEntry.SETFILTER("Global Dimension 1 Code",'<>%1','');
    //             BatchSetup."Dim. No. Cost Category"::"2. Dimension":
    //               GLEntry.SETFILTER("Global Dimension 2 Code",'<>%1','');
    //             BatchSetup."Dim. No. Cost Category"::"3. Dimension":
    //               GLEntry.SETFILTER("Global Dimension 3 Code",'<>%1','');
    //             BatchSetup."Dim. No. Cost Category"::"4. Dimension":
    //               GLEntry.SETFILTER("Global Dimension 4 Code",'<>%1','');
    //           END;

    //           IF GLEntry.FINDSET() THEN BEGIN
    //             REPEAT

    //               CASE BatchSetup."Dim. No. Cost Category" OF
    //                 BatchSetup."Dim. No. Cost Category"::"1. Dimension":
    //                   CostCatDimCode := GLEntry."Global Dimension 1 Code";
    //                 BatchSetup."Dim. No. Cost Category"::"2. Dimension":
    //                   CostCatDimCode := GLEntry."Global Dimension 2 Code";
    //                 BatchSetup."Dim. No. Cost Category"::"3. Dimension":
    //                   CostCatDimCode := GLEntry."Global Dimension 3 Code";
    //                 BatchSetup."Dim. No. Cost Category"::"4. Dimension":
    //                   CostCatDimCode := GLEntry."Global Dimension 4 Code";
    //               END;

    //               IF CostCategory.GET(CostCatDimCode) AND CostCategory."Direct Cost (Purchase)" THEN BEGIN
    //                 // Cost Schema Code,Cost Category Code,G/L Account No.,Dimension Code,Dimension Value
    //                 IF CostCategoryAccounts.GET('',CostCatDimCode,GLEntry."G/L Account No.",
    //                                             BatchSetup."Dim. Code Cost Category",CostCatDimCode) THEN BEGIN
    //                   IF NOT CostCategory."Reduce Cost from Turnover" THEN
    //                     LocalPurchNetAmt += GLEntry.Amount;
    //                 END;
    //               END;
    //             UNTIL GLEntry.NEXT() = 0;

    //             // In Originalvariablen übertragen
    //             PurchNetAmt += LocalPurchNetAmt;

    //           END;
    //         END;
    //         */

    //         // MVO 27.05.13.s
    //         // Kommt die Partie aus einer Packerei?
    //         // Wenn ja, werden die Kosten von dort aufaddiert
    //         IF (BatchVariant.Source = BatchVariant.Source::"Packing Order") THEN BEGIN
    //             PackOrderInputItems.SETRANGE("Doc. No.", BatchVariant."Source No.");

    //             // MVO 10.06.13.s
    //             // Es gibt immer nur genau einen Output-Artikel, also wird auf alle Input-Artikel der Packerei abgegrenzt
    //             // PackOrderInputItems.SETRANGE("Header Line No.", BatchVariant."Source Line No.");
    //             // PackOrderInputItems.SETRANGE("Line No.", BatchVariant."Source Line No.");

    //             PackOrderOutputItems.SETRANGE("Doc. No.", BatchVariant."Source No.");
    //             // 20130826.s
    //             // PackOrderOutputItems.FINDFIRST();
    //             IF PackOrderOutputItems.FINDFIRST() THEN
    //                 // 20130826.e
    //                 PurchQtyBase := PackOrderOutputItems."Quantity (Base)";

    //             // MVO 10.06.13.e

    //             // IF (MasterBatch.Source = MasterBatch.Source::"Packing Order") THEN BEGIN
    //             // PackOrderInputItems.SETRANGE("Doc. No.", MasterBatch."Source No.");
    //             IF PackOrderInputItems.FINDSET() THEN
    //                 REPEAT

    //                     Ratio := PackOrderInputItems."Quantity (Base)";

    //                     IF BatchVariant2.GET(PackOrderInputItems."Batch Variant No.") THEN BEGIN
    //                         BatchVariant2.CALCFIELDS("B.V. Purch. Order (Qty)", "B.V. Purch. Rec. (Qty)",
    //                                                 "B.V. Pack. Output (Qty)", "B.V. Pos. Shipped Adjmt. (Qty)");
    //                         IF BatchVariant2."B.V. Purch. Order (Qty)" <> 0 THEN
    //                             Purchased := BatchVariant2."B.V. Purch. Order (Qty)"
    //                         ELSE
    //                             IF BatchVariant2."B.V. Purch. Rec. (Qty)" <> 0 THEN
    //                                 Purchased := BatchVariant2."B.V. Purch. Rec. (Qty)"
    //                             ELSE
    //                                 IF BatchVariant2."B.V. Pack. Output (Qty)" <> 0 THEN
    //                                     Purchased := BatchVariant2."B.V. Pack. Output (Qty)"
    //                                 ELSE
    //                                     Purchased := BatchVariant2."B.V. Pos. Shipped Adjmt. (Qty)";
    //                     END ELSE
    //                         Purchased := 0;

    //                     IF Purchased <> 0 THEN
    //                         Ratio := Ratio / Purchased
    //                     ELSE
    //                         Ratio := 0;

    //                     IF PackBatchVariant.GET(PackOrderInputItems."Batch Variant No.") THEN BEGIN
    //                         CalcPurchAmt(PackBatchVariant, PackPurchGrossAmt, PackPurchDisc, PackPurchNetAmt, PackPurchQtyBase);

    //                         // In Originalvariablen übertragen
    //                         PurchGrossAmt += PackPurchGrossAmt * Ratio;
    //                         PurchDisc += PackPurchDisc * Ratio;
    //                         PurchNetAmt += PackPurchNetAmt * Ratio;

    //                     END;

    //                 // MVO 10.06.13
    //                 // PurchQtyBase += PackPurchQtyBase * Ratio;

    //                 UNTIL PackOrderInputItems.NEXT(1) = 0;
    //         END;

    //     end;

    //     procedure BuildGLAccFilter(CostCatCode: Code[20]) ReturnFilter: Text[1024]
    //     var
    //         CostCatAccounts: Record "5110346";
    //         GLAccount: Record "G/L Account" temporary;
    //         FirstLoop: Boolean;
    //     begin
    //         CLEAR(CostCatAccounts);
    //         CLEAR(GLAccount);
    //         GLAccount.DELETEALL();

    //         IF CostCatCode <> '' THEN
    //             CostCatAccounts.SETRANGE("Cost Category Code", CostCatCode);

    //         IF CostCatAccounts.FINDSET() THEN BEGIN
    //             REPEAT
    //                 IF NOT GLAccount.GET(CostCatAccounts."G/L Account No.") THEN BEGIN
    //                     GLAccount.INIT();
    //                     GLAccount."No." := CostCatAccounts."G/L Account No.";
    //                     GLAccount.insert();
    //                 END;
    //             UNTIL CostCatAccounts.NEXT() = 0;
    //         END;

    //         GLAccount.RESET();
    //         IF GLAccount.FINDSET() THEN BEGIN
    //             ReturnFilter := '';
    //             FirstLoop := TRUE;
    //             REPEAT
    //                 IF FirstLoop THEN BEGIN
    //                     ReturnFilter := GLAccount."No.";
    //                     FirstLoop := FALSE;
    //                 END ELSE
    //                     ReturnFilter := ReturnFilter + '|' + GLAccount."No.";
    //             UNTIL GLAccount.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CalcInLCY(PostingDate2: Date; CurrCode2: Code[20]; Amount2: Decimal; Factor2: Decimal): Decimal
    //     var
    //         CurrExChange2: Record "Currency Exchange Rate";
    //     begin
    //         IF PostingDate2 = 0D THEN
    //             PostingDate2 := WORKDATE;
    //         Amount2 := CurrExChange2.ExchangeAmtFCYToLCY(PostingDate2, CurrCode2, Amount2, Factor2);
    //         EXIT(Amount2);
    //     end;

    //     procedure CalcDifferenceAmt(var CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";)
    //     begin
    //         // To-Do
    //         //CostCalcCostCategories."Difference Amt. (LCY)" := (CostCalcCostCategories."Entered Amt (LCY)" +
    //         //                                                  CostCalcCostCategories."Released Amt (LCY)") -
    //         //                                                  CostCalcCostCategories."Posted Amt (LCY)";
    //     end;
    var
        lrc_BatchVariant: Record "POI Batch Variant";
        //lrc_CostCalculation: Record "POI Cost Calc. - Enter Data";
        lrc_CostCalculationData: Record "POI Cost Calc. - Enter Data";
        lrc_CostCalcDetailBatch: Record "POI Cost Calc. - Alloc. Data";
        lrc_CostCalcDetailBatchVar: Record "POI Cost Calc. - Alloc. Data";
        //lrc_CostCalcAllocData: Record "POI Cost Calc. - Alloc. Data";
        lrc_BatchTemp: Record "POI Batch Temp";
        lrc_MasterBatchTemp: Record "POI Batch Temp";
        lrc_PurchHeader: Record "Purchase Header";
        lrc_PurchLine: Record "Purchase Line";
        lrc_CostCalcAllocBatch: Record "POI Cost Calc. - Alloc. Batch";
}

