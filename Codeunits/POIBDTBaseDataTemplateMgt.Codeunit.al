codeunit 5087929 "POI BDT Base Data Template Mgt"
{
    //     procedure InsertTemplateItem(var rrc_Item: Record Item)
    //     var
    //         lrc_FruitVisionSetup: Record "5110302";
    //         lrc_Item: Record Item;
    //         lrc_ProductGroup: Record "5723";
    //         lrc_ItemEmpties: Record Item;
    //         lrc_Country: Record "9";
    //         lrc_Variety: Record "5110303";
    //         lrc_Caliber: Record "5110304";
    //         lrc_ItemCategory: Record "5722";
    //         lrc_UnitofMeasure: Record "204";
    //         lfm_ProductGroups: Form "5731";
    //         lco_Searchname: Code[60];
    //         lco_ProdGrp: Code[10];
    //         lco_CountryNo: Code[10];
    //         lco_VarietyCode: Code[10];
    //         lco_CaliberCode: Code[10];
    //         lco_UnitOfMeasureCode: Code[10];
    //         lco_EmptiesItem: Code[20];
    //         "--------RS": Integer;
    //         lrc_DefaultDimension: Record "352";
    //         lrc_DimensionValue: Record "349";
    //         lrc_ItemCategory2: Record "5722";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zur Neuanlage Artikel über entsprechende Schablonen
    //         // ---------------------------------------------------------------------------------------------
    //         lrc_FruitVisionSetup.Get();
    //         CASE lrc_FruitVisionSetup."Item Insert Template" OF

    //           // ------------------------------------------------------------------------------------
    //           //
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 1":
    //             BEGIN
    //             END;


    //           // ------------------------------------------------------------------------------------
    //           // Schablone 2 -> Fruchthof Northeim
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 2":
    //             BEGIN

    //               IF STRLEN(rrc_Item."No.") = 10 THEN BEGIN

    //                 // Gastro / Pflanzen Artikel
    //                 IF (COPYSTR(rrc_Item."No.",1,2) = '93') OR
    //                    (COPYSTR(rrc_Item."No.",1,2) = '97') THEN BEGIN

    //                   lrc_ItemCategory.GET(COPYSTR(rrc_Item."No.",1,4));
    //                   lrc_ItemCategory.TESTFIELD("Def. Base Unit of Measure");

    //                   lrc_ProductGroup.SETRANGE("Item Category Code",lrc_ItemCategory.Code);
    //                   lrc_ProductGroup.SETRANGE(Code,(COPYSTR(rrc_Item."No.",1,6)));
    //                   lrc_ProductGroup.FIND('-');

    //                   rrc_Item."POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
    //                   rrc_Item."Item Category Code" := lrc_ItemCategory.Code;
    //                   rrc_Item.VALIDATE("Product Group Code",lrc_ProductGroup.Code);
    //                   rrc_Item.VALIDATE("POI Countr of Ori Code (Fruit)",'DE');
    //                   rrc_Item.VALIDATE("POI Empties Item No.",'');
    //                   rrc_Item.VALIDATE("Base Unit of Measure",lrc_ItemCategory."Def. Base Unit of Measure");

    //                   rrc_Item.Description := lrc_ProductGroup.Description;
    //                   rrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                   rrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                   rrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                 END ELSE BEGIN

    //                   // Bio Artikel
    //                   IF (COPYSTR(rrc_Item."No.",1,2) = '94') THEN BEGIN

    //                     lrc_ItemCategory.GET(COPYSTR(rrc_Item."No.",1,4));
    //                     lrc_ItemCategory.TESTFIELD("Def. Base Unit of Measure");

    //                     lrc_ProductGroup.SETRANGE("Item Category Code",lrc_ItemCategory.Code);
    //                     lrc_ProductGroup.SETRANGE(Code,(COPYSTR(rrc_Item."No.",1,6)));
    //                     lrc_ProductGroup.FIND('-');

    //                     rrc_Item."POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
    //                     rrc_Item."Item Category Code" := lrc_ItemCategory.Code;
    //                     rrc_Item.VALIDATE("Product Group Code",lrc_ProductGroup.Code);
    //                     rrc_Item.VALIDATE("POI Countr of Ori Code (Fruit)",'DE');
    //                     rrc_Item.VALIDATE("POI Empties Item No.",'');
    //                     rrc_Item.VALIDATE("Base Unit of Measure",lrc_ItemCategory."Def. Base Unit of Measure");

    //                     rrc_Item.Description := lrc_ProductGroup.Description;
    //                     rrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                     rrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                     rrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                   // Alle anderen Artikel
    //                   END ELSE BEGIN

    //                     // Leere Werte aus der Artikelnummer erstellen
    //                     lco_ProdGrp := COPYSTR(rrc_Item."No.",1,2);
    //                     lrc_ProductGroup.SETRANGE(Code,lco_ProdGrp);
    //                     IF NOT lrc_ProductGroup.FIND('-') THEN
    //                       EXIT;

    //                     lco_CountryNo := COPYSTR(rrc_Item."No.",3,2);
    //                     lrc_Country.SETRANGE("Internal Code in Item No.",lco_CountryNo);
    //                     lrc_Country.FINDFIRST;

    //                     lco_EmptiesItem := COPYSTR(rrc_Item."No.",5,2);
    //                     lrc_Item.GET(lco_EmptiesItem);

    //                     lrc_ItemCategory.SETRANGE(Code,lrc_ProductGroup."Item Category Code");
    //                     lrc_ItemCategory.FINDFIRST;

    //                     rrc_Item."POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
    //                     rrc_Item."Item Category Code" := lrc_ItemCategory.Code;
    //                     rrc_Item."POI Product Group Code" := lrc_ProductGroup.Code;

    //                     rrc_Item.VALIDATE("POI Countr of Ori Code (Fruit)",lrc_Country.Code);
    //                     rrc_Item.VALIDATE("POI Empties Item No.",lrc_Item."No.");

    //                     IF rrc_Item."Base Unit of Measure" = '' THEN
    //                       rrc_Item.VALIDATE("Base Unit of Measure",'KG');

    //                     rrc_Item.Description := COPYSTR(lrc_ProductGroup.Description,1,30);

    //                     rrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                     rrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                     rrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                     rrc_Item.VALIDATE("Product Group Code");
    //                   END;
    //                 END;

    //               END ELSE BEGIN
    //               END;

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 3 -> Schliecker
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 3":
    //             BEGIN

    //               IF STRLEN(rrc_Item."No.") = 13 THEN BEGIN

    //                   // Leere Werte aus der Artikelnummer erstellen
    //                   lco_ProdGrp := COPYSTR(rrc_Item."No.",1,2);
    //                   lrc_ProductGroup.SETRANGE(Code,lco_ProdGrp);
    //                   IF NOT lrc_ProductGroup.FINDFIRST()THEN
    //                     EXIT;

    //                   lrc_ItemCategory.SETRANGE(Code,lrc_ProductGroup."Item Category Code");
    //                   lrc_ItemCategory.FINDFIRST;

    //                   rrc_Item."POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
    //                   rrc_Item."Item Category Code" := lrc_ItemCategory.Code;
    //                   rrc_Item."POI Product Group Code" := lrc_ProductGroup.Code;

    //                   lrc_Variety.GET(COPYSTR(rrc_Item."No.",1,4));
    //                   rrc_Item."POI Variety Code" := lrc_Variety.Code;

    //                   lrc_UnitofMeasure.SETRANGE("Internal Code Item No.",(COPYSTR(rrc_Item."No.",5,5)));
    //                   lrc_UnitofMeasure.FINDFIRST;
    //                   lrc_UnitofMeasure.TESTFIELD("Base Unit of Measure (BU)");
    //                   rrc_Item.VALIDATE("Base Unit of Measure",lrc_UnitofMeasure."Base Unit of Measure (BU)");

    //                   lco_EmptiesItem := COPYSTR(rrc_Item."No.",8,2);
    //                   lrc_ItemEmpties.GET(lco_EmptiesItem);
    //                   rrc_Item.VALIDATE("POI Empties Item No.",lrc_ItemEmpties."No.");

    //                   lrc_Caliber.SETRANGE("Internal Code in Item No.",(COPYSTR(rrc_Item."No.",10,2)));
    //                   lrc_Caliber.FINDFIRST;
    //                   rrc_Item."POI Caliber Code" := lrc_Caliber.Code;

    //                   rrc_Item."Grade of Goods Code" := 'I';

    //                   lco_CountryNo := COPYSTR(rrc_Item."No.",12,2);
    //                   lrc_Country.SETRANGE("Internal Code in Item No.",lco_CountryNo);
    //                   lrc_Country.FINDFIRST;
    //                   rrc_Item.VALIDATE("POI Countr of Ori Code (Fruit)",lrc_Country.Code);

    //                   rrc_Item.Description := COPYSTR(lrc_Variety.Description + ' ' +
    //                                           lrc_Caliber.Description,1,30);
    //                   rrc_Item."Description 2" := COPYSTR(lrc_UnitofMeasure.Description,1,30);

    //                   rrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                   rrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                   rrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                   rrc_Item.VALIDATE("Product Group Code");

    //               END ELSE BEGIN
    //               END;

    //             END;


    //           // ------------------------------------------------------------------------------------
    //           // Schablone 4 -> Brandenburger Obst
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 4":
    //             BEGIN

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 5 -> Biotropic
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 5":
    //             BEGIN

    //               lrc_ProductGroup.SETRANGE(Code,rrc_Item."No.");
    //               IF lrc_ProductGroup.FIND('-') THEN BEGIN

    //                 lrc_Item.Reset();
    //                 lrc_Item.SETFILTER("No.",'%1',(lrc_ProductGroup.Code + '????'));
    //                 IF lrc_Item.FIND('+') THEN BEGIN
    //                   rrc_Item."No." := INCSTR(lrc_Item."No.");
    //                 END ELSE
    //                   rrc_Item."No." := rrc_Item."No." + '0001';

    //                 lrc_ItemCategory.SETRANGE(Code,lrc_ProductGroup."Item Category Code");
    //                 lrc_ItemCategory.FIND('-');

    //                 rrc_Item."POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
    //                 rrc_Item."Item Category Code" := lrc_ItemCategory.Code;
    //                 rrc_Item."POI Product Group Code" := lrc_ProductGroup.Code;

    //                 rrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                 rrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                 rrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                 rrc_Item.Description := COPYSTR(lrc_ProductGroup.Description,1,30);

    //                 rrc_Item.VALIDATE("Item Category Code", lrc_ProductGroup."Item Category Code");
    //                 rrc_Item.VALIDATE("POI Item Main Category Code", lrc_ItemCategory."POI Item Main Category Code");
    //                 rrc_Item.VALIDATE("Base Unit of Measure", lrc_ItemCategory."Def. Base Unit of Measure");
    //                 rrc_Item."Batch Item" := lrc_ProductGroup."Def. Batch Item";

    //                 rrc_Item."Search Description" := GenerateItemSearchDesc( rrc_Item );
    //                 rrc_Item."Description 2" := GenerateItemDesc2( rrc_Item );

    //               END;

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 12 -> INTERWeichert
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 12":
    //             BEGIN

    //               lrc_ProductGroup.SETRANGE(Code,rrc_Item."No.");
    //               IF lrc_ProductGroup.FIND('-') THEN BEGIN

    //                 lrc_Item.Reset();
    //                 lrc_Item.SETFILTER("No.",'%1',(lrc_ProductGroup.Code + '????'));
    //                 IF lrc_Item.FIND('+') THEN BEGIN
    //                   rrc_Item."No." := INCSTR(lrc_Item."No.");
    //                 END ELSE
    //                   rrc_Item."No." := rrc_Item."No." + '0001';

    //                 lrc_ItemCategory.SETRANGE(Code,lrc_ProductGroup."Item Category Code");
    //                 lrc_ItemCategory.FIND('-');

    //                 rrc_Item."POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
    //                 rrc_Item."Item Category Code" := lrc_ItemCategory.Code;
    //                 rrc_Item."POI Product Group Code" := lrc_ProductGroup.Code;

    //                 rrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                 rrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                 rrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                 rrc_Item.Description := COPYSTR(lrc_ProductGroup.Description,1,30);

    //                 rrc_Item.VALIDATE("Item Category Code", lrc_ProductGroup."Item Category Code");
    //                 rrc_Item.VALIDATE("POI Item Main Category Code", lrc_ItemCategory."POI Item Main Category Code");
    //                 rrc_Item.VALIDATE("Base Unit of Measure", lrc_ItemCategory."Def. Base Unit of Measure");
    //                 rrc_Item."Batch Item" := lrc_ProductGroup."Def. Batch Item";

    //                 rrc_Item."Search Description" := GenerateItemSearchDesc( rrc_Item );
    //                 rrc_Item.Description := GenerateItemDesc1( rrc_Item );
    //                 rrc_Item."Description 2" := GenerateItemDesc2( rrc_Item );

    //               END;

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 13 -> Dürbeck
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 13":
    //             BEGIN

    //               IF rrc_Item."No." = '' THEN BEGIN

    //                 lfm_ProductGroups.LOOKUPMODE := TRUE;
    //                 lfm_ProductGroups.SETTABLEVIEW(lrc_ProductGroup);
    //                 IF lfm_ProductGroups.RUNMODAL <> ACTION::LookupOK THEN
    //                   ERROR('');

    //                 lfm_ProductGroups.GETRECORD(lrc_ProductGroup);

    //                 lrc_Item.Reset();
    //                 // PORT 004.s
    //                 /*lrc_Item.SETFILTER("No.",'%1',(lrc_ProductGroup.Code + '??'));*/
    //                 lrc_Item.SETFILTER("No.",'%1',(lrc_ProductGroup.Code + '???'));
    //                 // PORT 004.e
    //                 IF lrc_Item.FIND('+') THEN BEGIN
    //                   rrc_Item."No." := INCSTR(lrc_Item."No.");
    //                 END ELSE
    //                   // PORT 004.s
    //                   /*rrc_Item."No." := lrc_ProductGroup.Code + '01';*/
    //                   rrc_Item."No." := lrc_ProductGroup.Code + '001';
    //                   // PORT 004.e

    //                 rrc_Item.VALIDATE("Product Group Code", lrc_ProductGroup.Code);
    //                 rrc_Item.Description := lrc_ProductGroup.Description;
    //                 rrc_Item."Search Description" := GenerateItemSearchDesc( rrc_Item );

    //                 //RS Anlage von Dimension 'Kostenträger'
    //                 lrc_DimensionValue.INIT();
    //                 lrc_DimensionValue."Dimension Code" := 'KOSTENTRÄGER';
    //                 lrc_DimensionValue.Code := rrc_Item."No.";
    //                 lrc_DimensionValue.Name := rrc_Item.Description;
    //                 lrc_DimensionValue.INSERT(TRUE);

    //                 //RS Anlage Vorgabedimensionen
    //                 lrc_DefaultDimension.INIT();
    //                 lrc_DefaultDimension."Table ID" := 27;
    //                 lrc_DefaultDimension."No." := rrc_Item."No.";
    //                 lrc_DefaultDimension."Dimension Code" := 'KOSTENTRÄGER';
    //                 lrc_DefaultDimension."Dimension Value Code" := rrc_Item."No.";
    //                 lrc_DefaultDimension.insert();

    //                 lrc_DefaultDimension.INIT();
    //                 lrc_DefaultDimension."Table ID" := 27;
    //                 lrc_DefaultDimension."No." := rrc_Item."No.";
    //                 lrc_DefaultDimension."Dimension Code" := 'ARTIKELHAUPTKAT';
    //                 lrc_ItemCategory2.GET(lrc_ProductGroup."Item Category Code");
    //                 lrc_DefaultDimension."Dimension Value Code" := lrc_ItemCategory2."POI Item Main Category Code";
    //                 lrc_DefaultDimension.insert();

    //                 lrc_DefaultDimension.INIT();
    //                 lrc_DefaultDimension."Table ID" := 27;
    //                 lrc_DefaultDimension."No." := rrc_Item."No.";
    //                 lrc_DefaultDimension."Dimension Code" := 'ARTIKELKATEGORIE';
    //                 lrc_DefaultDimension."Dimension Value Code" := lrc_ProductGroup."Item Category Code";
    //                 lrc_DefaultDimension.insert();


    //                 lrc_DefaultDimension.INIT();
    //                 lrc_DefaultDimension."Table ID" := 27;
    //                 lrc_DefaultDimension."No." := rrc_Item."No.";
    //                 lrc_DefaultDimension."Dimension Code" := 'PRODUKTGRUPPE';
    //                 lrc_DefaultDimension."Dimension Value Code" := lrc_ProductGroup.Code;
    //                 lrc_DefaultDimension.insert();
    //                 //RS.e Anlage Vorgabedimensionen

    //               END;

    //             END;

    //           // ------------------------------------------------------------------------------------
    //           // Schablone 17 -> Del Monte Fresh
    //           // ------------------------------------------------------------------------------------
    //           lrc_FruitVisionSetup."Item Insert Template"::"Schablone 17":
    //             BEGIN

    //               lrc_ProductGroup.SETRANGE(Code,rrc_Item."No.");
    //               IF lrc_ProductGroup.FIND('-') THEN BEGIN

    //                 lrc_Item.Reset();
    //                 lrc_Item.SETFILTER("No.",'%1',(lrc_ProductGroup.Code + '????'));
    //                 IF lrc_Item.FIND('+') THEN BEGIN
    //                   rrc_Item."No." := INCSTR(lrc_Item."No.");
    //                 END ELSE
    //                   rrc_Item."No." := rrc_Item."No." + '0001';

    //                 lrc_ItemCategory.SETRANGE(Code,lrc_ProductGroup."Item Category Code");
    //                 lrc_ItemCategory.FIND('-');

    //                 rrc_Item."POI Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
    //                 rrc_Item."Item Category Code" := lrc_ItemCategory.Code;
    //                 rrc_Item."POI Product Group Code" := lrc_ProductGroup.Code;

    //                 rrc_Item."Gen. Prod. Posting Group" := lrc_ItemCategory."Def. Gen. Prod. Posting Group";
    //                 rrc_Item."VAT Prod. Posting Group" := lrc_ItemCategory."Def. VAT Prod. Posting Group";
    //                 rrc_Item."Inventory Posting Group" := lrc_ItemCategory."Def. Inventory Posting Group";

    //                 rrc_Item.Description := COPYSTR(lrc_ProductGroup.Description,1,30);

    //                 rrc_Item.VALIDATE("Item Category Code", lrc_ProductGroup."Item Category Code");
    //                 rrc_Item.VALIDATE("POI Item Main Category Code", lrc_ItemCategory."POI Item Main Category Code");
    //                 rrc_Item.VALIDATE("Base Unit of Measure", lrc_ItemCategory."Def. Base Unit of Measure");
    //                 rrc_Item."Batch Item" := lrc_ProductGroup."Def. Batch Item";

    //                 rrc_Item."Search Description" := GenerateItemSearchDesc(rrc_Item);

    //               END;

    //             END;
    //         END;

    //     end;

    procedure GenerateItemDesc1(var vrc_Item: Record Item) lxt_ReturnText: Text[50]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        ltx_Description1: Text[100];
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Erstellung der Artikelbeschreibung 2 nach Schablone
        // ---------------------------------------------------------------------------------------------

        IF vrc_Item."No." = '' THEN
            EXIT(lxt_ReturnText);

        lrc_FruitVisionSetup.Get();


        // ------------------------------------------------------------------------------------
        // Schablone 13 -> Im Einsatz Port
        // ------------------------------------------------------------------------------------
        CASE lrc_FruitVisionSetup."Item Insert Template" OF
            lrc_FruitVisionSetup."Item Insert Template"::"Schablone 13":
                BEGIN
                    ltx_Description1 := '';

                    // Produktgruppe
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FINDFIRST() THEN
                        ltx_Description1 := lrc_ProductGroup.Description;

                    // Sorte
                    lrc_Variety.SETRANGE(Code, vrc_Item."POI Variety Code");
                    IF lrc_Variety.FINDFIRST() THEN
                        IF lrc_Variety.Description <> '' THEN BEGIN
                            IF ltx_Description1 <> '' THEN
                                ltx_Description1 := copystr(ltx_Description1 + ' ', 1, MaxStrLen(ltx_Description1));
                            ltx_Description1 := copystr(ltx_Description1 + lrc_Variety.Description, 1, MaxStrLen(ltx_Description1));
                        END;
                END;
        END;

        IF ltx_Description1 = '' THEN
            ltx_Description1 := vrc_Item.Description;

        lxt_ReturnText := COPYSTR(ltx_Description1, 1, MAXSTRLEN(lxt_ReturnText));

        EXIT(lxt_ReturnText);

    end;

    procedure GenerateItemDesc2(var vrc_Item: Record Item) lxt_ReturnText: Text[50]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_ItemEmpties: Record Item;
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Caliber: Record "POI Caliber";
        lrc_Trademark: Record "POI Trademark";
        lrc_Quality: Record "POI Item Attribute 3";
        ltx_Description2: Text[100];
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Erstellung der Artikelbeschreibung 2 nach Schablone
        // ---------------------------------------------------------------------------------------------

        IF vrc_Item."No." = '' THEN
            EXIT(lxt_ReturnText);

        lrc_FruitVisionSetup.Get();
        CASE lrc_FruitVisionSetup."Item Search Desc. Template" OF

            // ------------------------------------------------------------------------------------
            //
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 1":
                ;

            // ------------------------------------------------------------------------------------
            // Schablone 2 -> Fruchthof Northeim
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 2":
                IF STRLEN(vrc_Item."No.") = 10 THEN BEGIN
                    ltx_Description2 := '';

                    // Unternehmensnummer lesen
                    // IF vrc_Item."Only for Company Chain" <> '' THEN //TODO: Company chain
                    //     ltx_Description2 := vrc_Item."Only for Company Chain";

                    // Leergutartikel lesen
                    IF lrc_ItemEmpties.GET(vrc_Item."POI Empties Item No.") THEN
                        IF ltx_Description2 <> '' THEN
                            ltx_Description2 := copystr(ltx_Description2 + ' ' + lrc_ItemEmpties.Description, 1, MaxStrLen(ltx_Description2))
                        ELSE
                            ltx_Description2 := lrc_ItemEmpties.Description;

                    // Abpackung
                    IF vrc_Item."POI Item Attribute 4" <> '' THEN
                        IF ltx_Description2 <> '' THEN
                            ltx_Description2 := copystr(ltx_Description2 + ' ' + vrc_Item."POI Item Attribute 4", 1, MaxStrLen(ltx_Description2))
                        ELSE
                            ltx_Description2 := vrc_Item."POI Item Attribute 4";

                    // Qualität
                    IF vrc_Item."POI Item Attribute 3" <> '' THEN
                        IF ltx_Description2 <> '' THEN
                            ltx_Description2 := copystr(ltx_Description2 + ' ' + vrc_Item."POI Item Attribute 3", 1, MaxStrLen(ltx_Description2))
                        ELSE
                            ltx_Description2 := vrc_Item."POI Item Attribute 3";
                END;

            // ------------------------------------------------------------------------------------
            // Schablone 3 -> Schliecker
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 3":
                IF STRLEN(vrc_Item."No.") = 13 THEN
                    IF lrc_UnitofMeasure.GET(vrc_Item."Purch. Unit of Measure") THEN
                        ltx_Description2 := COPYSTR(lrc_UnitofMeasure.Description, 1, 30);

            // ------------------------------------------------------------------------------------
            // Schablone 4 -> Im Einsatz Brandenburger Obst
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 4":
                ;

            // ------------------------------------------------------------------------------------
            // Schablone 5 -> Im Einsatz Biotropic
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 5":
                BEGIN

                    ltx_Description2 := '';

                    IF (vrc_Item."POI Item Main Category Code" <> '2') and
                       (vrc_Item."POI Item Main Category Code" <> '8') and
                       (vrc_Item."POI Item Main Category Code" <> '9') THEN BEGIN

                        // Produktgruppe
                        lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                        // IF lrc_ProductGroup.FIND('-') THEN
                        //   ltx_Description2 := DELCHR(COPYSTR(lrc_ProductGroup.Description,1,8), '>', ' ');
                        ltx_Description2 := DELCHR(COPYSTR(vrc_Item.Description, 1, 8), '>', ' ');

                        // Sorte
                        IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                            IF ltx_Description2 = '' THEN
                                ltx_Description2 := DELCHR(COPYSTR(lrc_Variety.Description, 1, 8), '>', ' ')
                            ELSE
                                ltx_Description2 := ltx_Description2 + DELCHR(' ' + COPYSTR(lrc_Variety.Description, 1, 8), '>', ' ');


                        // Kaliber
                        IF lrc_Caliber.GET(vrc_Item."POI Caliber Code") THEN
                            IF ltx_Description2 = '' THEN
                                ltx_Description2 := DELCHR(COPYSTR(lrc_Caliber.Description, 1, 10), '>', ' ')
                            ELSE
                                ltx_Description2 := ltx_Description2 + DELCHR(' ' + COPYSTR(lrc_Caliber.Description, 1, 10), '>', ' ');


                        // Kolloeinheit
                        IF lrc_UnitofMeasure.GET(vrc_Item."Purch. Unit of Measure") THEN BEGIN
                            IF ltx_Description2 = '' THEN
                                ltx_Description2 := DELCHR(COPYSTR(lrc_UnitofMeasure.Description, 1, 12), '>', ' ')
                            ELSE
                                ltx_Description2 := ltx_Description2 + DELCHR(' ' + COPYSTR(lrc_UnitofMeasure.Description, 1, 12), '>', ' ');
                        END ELSE
                            IF ltx_Description2 = '' THEN
                                ltx_Description2 := DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' ')
                            ELSE
                                ltx_Description2 := ltx_Description2 + DELCHR(' ' + vrc_Item."Purch. Unit of Measure", '>', ' ');

                        // Herkunft
                        IF ltx_Description2 = '' THEN
                            ltx_Description2 := DELCHR(vrc_Item."POI Countr of Ori Code (Fruit)", '>', ' ')
                        ELSE
                            ltx_Description2 := ltx_Description2 + DELCHR(' ' + vrc_Item."POI Countr of Ori Code (Fruit)", '>', ' ');

                        // Marke
                        IF lrc_Trademark.GET(vrc_Item."POI Trademark Code") THEN
                            IF ltx_Description2 = '' THEN
                                ltx_Description2 := DELCHR(COPYSTR(lrc_Trademark.Description, 1, 10), '>', ' ')
                            ELSE
                                ltx_Description2 := ltx_Description2 + DELCHR(' ' + COPYSTR(lrc_Trademark.Description, 1, 8), '>', ' ');

                        // Qualität
                        IF lrc_Quality.GET(vrc_Item."POI Item Attribute 3") THEN
                            IF ltx_Description2 = '' THEN
                                ltx_Description2 := DELCHR(COPYSTR(lrc_Quality.Description, 1, 4), '>', ' ')
                            ELSE
                                ltx_Description2 := ltx_Description2 + DELCHR(' ' + COPYSTR(lrc_Quality.Description, 1, 4), '>', ' ');
                    END;
                END;

            // -------------------------------------------------------------------------
            // Schablone 10 --> Im Einsatz bei ONKEL
            // -------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 10":
                ltx_Description2 := '';

            // ------------------------------------------------------------------------------------
            // Schablone 12 -> Im Einsatz INTERWeichert
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 12":
                ltx_Description2 := '';

            // ------------------------------------------------------------------------------------
            // Schablone 17 -> Im Einsatz Del Monte Fresh
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 17":
                ltx_Description2 := '';

        END;

        IF ltx_Description2 = '' THEN
            ltx_Description2 := vrc_Item."Description 2";

        lxt_ReturnText := COPYSTR(ltx_Description2, 1, MAXSTRLEN(vrc_Item."Description 2"));


        EXIT(lxt_ReturnText);

    end;

    procedure GenerateAllItemSearchDesc()
    var
        LT_TEXT001Txt: Label 'Möchten Sie den Suchbegriff für alle Artikel neu erstellen?';

    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Erstellung des Artikelsuchbegriffes nach Schablone für alle Artikel
        // ---------------------------------------------------------------------------------------------

        IF NOT CONFIRM(LT_TEXT001Txt) THEN
            EXIT;
        Item.SETRANGE("POI Item Typ", Item."POI Item Typ"::"Trade Item");
        IF Item.FINDSET(TRUE, FALSE) THEN
            REPEAT
                Item."Search Description" := COPYSTR(GenerateItemSearchDesc(Item), 1, MaxStrLen(Item."Search Description"));
                Item.MODIFY();
            UNTIL Item.NEXT() = 0;
    end;

    procedure GenerateItemSearchDesc(var vrc_Item: Record Item): Code[100]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";

        lrc_Country: Record "Country/Region";
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Caliber: Record "POI Caliber";
        lrc_ItemEmpties: Record Item;
        lrc_Quality: Record "POI Item Attribute 3";
        lrc_Trademark: Record "POI Trademark";
        lrc_Color: Record "POI Item Attribute 7";
        lrc_ItemCategory: Record "Item Category";
        lrc_Treatment: Record "POI Item Attribute 5";
        lrc_Conservation: Record "POI Item Attribute 7";
        lco_Searchname: Code[100];
        lco_Searchname2: Code[200];
        lin_Position: Integer;
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Erstellung des Artikelsuchbegriffes nach Schablone
        // ---------------------------------------------------------------------------------------------

        IF vrc_Item."No." = '' THEN
            EXIT('');

        lrc_FruitVisionSetup.Get();
        CASE lrc_FruitVisionSetup."Item Search Desc. Template" OF

            lrc_FruitVisionSetup."Item Search Desc. Template"::" ":
                lco_Searchname := vrc_Item."Search Description";

            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 1":
                BEGIN

                    // Produktgruppe lesen
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF NOT lrc_ProductGroup.FINDFIRST() THEN
                        lrc_ProductGroup.INIT();

                    lco_Searchname := '';

                    IF COPYSTR(vrc_Item."POI Variety Code", 1, 6) <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := COPYSTR(vrc_Item."POI Variety Code", 1, 6)
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."POI Variety Code", 1, 6), 1, 100);

                    IF COPYSTR(vrc_Item."POI Countr of Ori Code (Fruit)", 1, 2) <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := COPYSTR(vrc_Item."POI Countr of Ori Code (Fruit)", 1, 2)
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."POI Countr of Ori Code (Fruit)", 1, 2), 1, 100);

                    IF COPYSTR(vrc_Item."POI Caliber Code", 1, 3) <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := COPYSTR(vrc_Item."POI Caliber Code", 1, 3)
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."POI Caliber Code", 1, 3), 1, 100);

                    IF vrc_Item."Sales Unit of Measure" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_Item."Sales Unit of Measure"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."Sales Unit of Measure", 1, 100);

                    IF COPYSTR(lrc_ItemEmpties."Search Description", 1, 3) <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := COPYSTR(lrc_ItemEmpties."Search Description", 1, 3)
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_ItemEmpties."Search Description", 1, 3), 1, 100);


                END;


            // ------------------------------------------------------------------------------------
            // Schablone 2 -> Fruchthof Northeim
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 2":
                IF STRLEN(vrc_Item."No.") = 10 THEN

                    // --------------------------------------------------------------------------------
                    // GASTRO / PFLANZEN Artikel
                    // --------------------------------------------------------------------------------
                    IF (COPYSTR(vrc_Item."No.", 1, 2) = '93') OR
                           (COPYSTR(vrc_Item."No.", 1, 2) = '97') THEN BEGIN

                        // Produktgruppe lesen
                        lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                        IF NOT lrc_ProductGroup.FIND('-') THEN
                            lrc_ProductGroup.INIT();

                        lco_Searchname := '';

                        // Leergutartikel lesen
                        lrc_ItemEmpties.INIT();
                        IF vrc_Item."POI Empties Item No." <> '' THEN
                            IF lrc_ItemEmpties.GET(vrc_Item."POI Empties Item No.") THEN;
                        IF lco_Searchname = '' THEN
                            lco_Searchname := UPPERCASE(COPYSTR(vrc_Item.Description, 1, 6))
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + UPPERCASE(COPYSTR(vrc_Item.Description, 1, 6)), 1, 100);

                        IF COPYSTR(vrc_Item."POI Variety Code", 1, 6) <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := COPYSTR(vrc_Item."POI Variety Code", 1, 6)
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."POI Variety Code", 1, 6), 1, 100);

                        IF COPYSTR(vrc_Item."POI Caliber Code", 1, 3) <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := COPYSTR(vrc_Item."POI Caliber Code", 1, 3)
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."POI Caliber Code", 1, 3), 1, 100);

                        IF vrc_Item."Sales Unit of Measure" <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := vrc_Item."Sales Unit of Measure"
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."Sales Unit of Measure", 1, 100);


                    END ELSE BEGIN

                        // --------------------------------------------------------------------------------
                        // Frischeartikel inklusive BIO
                        // --------------------------------------------------------------------------------

                        // Produktgruppe lesen
                        lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                        IF NOT lrc_ProductGroup.FIND('-') THEN
                            lrc_ProductGroup.INIT();

                        lco_Searchname := '';

                        // Leergutartikel lesen
                        lrc_ItemEmpties.INIT();
                        IF vrc_Item."POI Empties Item No." <> '' THEN
                            IF lrc_ItemEmpties.GET(vrc_Item."POI Empties Item No.") THEN;
                        IF lco_Searchname = '' THEN
                            lco_Searchname := UPPERCASE(COPYSTR(vrc_Item.Description, 1, 6))
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + UPPERCASE(COPYSTR(vrc_Item.Description, 1, 6)), 1, 100);

                        IF COPYSTR(vrc_Item."POI Variety Code", 1, 6) <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := COPYSTR(vrc_Item."POI Variety Code", 1, 6)
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."POI Variety Code", 1, 6), 1, 100);

                        IF COPYSTR(vrc_Item."POI Countr of Ori Code (Fruit)", 1, 2) <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := COPYSTR(vrc_Item."POI Countr of Ori Code (Fruit)", 1, 2)
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."POI Countr of Ori Code (Fruit)", 1, 2), 1, 100);

                        IF vrc_Item."Sales Unit of Measure" <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := vrc_Item."Sales Unit of Measure"
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."Sales Unit of Measure", 1, 100);

                        IF COPYSTR(vrc_Item."POI Caliber Code", 1, 3) <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := COPYSTR(vrc_Item."POI Caliber Code", 1, 3)
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."POI Caliber Code", 1, 3), 1, 100);

                    END;


            // ------------------------------------------------------------------------------------
            // Schablone 3 -> Schliecker
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 3":


                IF STRLEN(vrc_Item."No.") = 13 THEN BEGIN

                    lco_Searchname := '';

                    // Produktgruppe lesen
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF NOT lrc_ProductGroup.FIND('-') THEN
                        lrc_ProductGroup.INIT();
                    IF lco_Searchname = '' THEN
                        lco_Searchname := COPYSTR(lrc_ProductGroup.Description, 1, 6)
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_ProductGroup.Description, 1, 6), 1, 100);

                    // Sorte
                    IF NOT lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        lrc_Variety.INIT();
                    IF lco_Searchname = '' THEN
                        lco_Searchname := COPYSTR(lrc_Variety.Description, 1, 10)
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_Variety.Description, 1, 10), 1, 100);

                    // Inhalt --> zukünftig den Einheitencode verwenden
                    IF lco_Searchname = '' THEN
                        lco_Searchname := COPYSTR(vrc_Item."Purch. Unit of Measure", 1, 10)
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item."Purch. Unit of Measure", 1, 10), 1, 100);

                    // Kaliber
                    IF NOT lrc_Caliber.GET(vrc_Item."POI Caliber Code") THEN
                        lrc_Caliber.INIT();
                    IF lco_Searchname = '' THEN
                        lco_Searchname := COPYSTR(lrc_Caliber.Description, 1, 6)
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_Caliber.Description, 1, 6), 1, 100);

                    // Herkunftsland
                    IF NOT lrc_Country.GET(vrc_Item."POI Countr of Ori Code (Fruit)") THEN
                        lrc_Country.INIT();
                    IF lco_Searchname = '' THEN
                        lco_Searchname := lrc_Country.Code
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Country.Code, 1, 100);


                END;


            // ------------------------------------------------------------------------------------
            // Schablone 4 -> Brandenburger Obst
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 4":
                BEGIN

                    lco_Searchname := '';

                    // Sorte
                    IF NOT lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        lrc_Variety.INIT();
                    IF lco_Searchname = '' THEN
                        lco_Searchname := COPYSTR(lrc_Variety.Description, 1, 10)
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_Variety.Description, 1, 10), 1, 100);


                    // Kaliber
                    IF NOT lrc_Caliber.GET(vrc_Item."POI Caliber Code") THEN
                        lrc_Caliber.INIT();
                    IF lco_Searchname = '' THEN
                        lco_Searchname := COPYSTR(lrc_Caliber.Description, 1, 10)
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_Caliber.Description, 1, 10), 1, 100);

                    // Kolloeinheit
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."Purch. Unit of Measure"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."Purch. Unit of Measure", 1, 100);

                END;


            // ------------------------------------------------------------------------------------
            // Schablone 5 -> Biotropic
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 5":
                BEGIN

                    lco_Searchname := '';

                    IF (vrc_Item."POI Item Main Category Code" <> '2') and
                       (vrc_Item."POI Item Main Category Code" <> '8') and
                       (vrc_Item."POI Item Main Category Code" <> '9') THEN begin
                        // Produktgruppe
                        lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                        IF lrc_ProductGroup.FIND('-') THEN
                            lco_Searchname := DELCHR(COPYSTR(lrc_ProductGroup.Description, 1, 8), '>', ' ');
                        lco_Searchname := DELCHR(COPYSTR(vrc_Item.Description, 1, 8), '>', ' ');

                        // Sorte
                        IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := DELCHR(COPYSTR(lrc_Variety.Description, 1, 8), '>', ' ')
                            ELSE
                                lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Variety.Description, 1, 8), '>', ' ');


                        // Kaliber
                        IF lrc_Caliber.GET(vrc_Item."POI Caliber Code") THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := DELCHR(COPYSTR(lrc_Caliber.Description, 1, 10), '>', ' ')
                            ELSE
                                lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Caliber.Description, 1, 10), '>', ' ');

                        // Kolloeinheit
                        IF lrc_UnitofMeasure.GET(vrc_Item."Purch. Unit of Measure") THEN BEGIN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := DELCHR(COPYSTR(lrc_UnitofMeasure.Description, 1, 12), '>', ' ')
                            ELSE
                                lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_UnitofMeasure.Description, 1, 12), '>', ' ');
                        END ELSE
                            IF lco_Searchname = '' THEN
                                lco_Searchname := DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' ')
                            ELSE
                                lco_Searchname := lco_Searchname + DELCHR(' ' + vrc_Item."Purch. Unit of Measure", '>', ' ');

                        // Herkunft
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(vrc_Item."POI Countr of Ori Code (Fruit)", '>', ' ')
                        ELSE
                            lco_Searchname := lco_Searchname + DELCHR(' ' + vrc_Item."POI Countr of Ori Code (Fruit)", '>', ' ');

                        // Marke
                        IF lrc_Trademark.GET(vrc_Item."POI Trademark Code") THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := DELCHR(COPYSTR(lrc_Trademark.Description, 1, 10), '>', ' ')
                            ELSE
                                lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Trademark.Description, 1, 8), '>', ' ');

                        // Qualität
                        IF lrc_Quality.GET(vrc_Item."POI Item Attribute 3") THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := DELCHR(COPYSTR(lrc_Quality.Description, 1, 4), '>', ' ')
                            ELSE
                                lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Quality.Description, 1, 4), '>', ' ');
                        vrc_Item."Description 2" := GenerateItemDesc2(vrc_Item);
                    END;
                END;
            // ------------------------------------------------------------------------------------
            // Schablone 6 -> Meyer Gemüsebearbeitung
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 6":
                BEGIN
                    lco_Searchname := '';
                    lco_Searchname2 := '';

                    lin_Position := STRPOS(vrc_Item."Search Description", ' ');
                    IF lin_Position > 1 THEN
                        lco_Searchname2 := copystr(COPYSTR(vrc_Item."Search Description", 1, lin_Position - 1), 1, 200)
                    ELSE
                        IF STRLEN(vrc_Item."Search Description") > 0 THEN
                            lco_Searchname2 := vrc_Item."Search Description";

                    // Produktgruppe
                    lrc_ProductGroup.RESET();
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FIND('-') THEN BEGIN
                        IF lco_Searchname2 = '' THEN
                            lco_Searchname2 := vrc_Item."POI Product Group Code"
                        ELSE
                            lco_Searchname2 := copystr(lco_Searchname2 + ' ' + vrc_Item."POI Product Group Code", 1, 200);
                    END ELSE
                        lrc_ProductGroup.INIT();

                    // Artikelkategorie
                    IF vrc_Item."Item Category Code" <> '' THEN BEGIN
                        lrc_ItemCategory.RESET();
                        lrc_ItemCategory.SETRANGE(Code, vrc_Item."Item Category Code");
                        IF not lrc_ItemCategory.IsEmpty() THEN
                            IF lco_Searchname2 = '' THEN
                                lco_Searchname2 := vrc_Item."Item Category Code"
                            ELSE
                                lco_Searchname2 := copystr(lco_Searchname2 + ' ' + vrc_Item."Item Category Code", 1, 200);
                    END;

                    // Beschreibung
                    IF vrc_Item.Description <> '' THEN
                        IF lco_Searchname2 = '' THEN
                            lco_Searchname2 := vrc_Item.Description
                        ELSE
                            lco_Searchname2 := copystr(lco_Searchname2 + ' ' + vrc_Item.Description, 1, 200);


                    // Beschreibung 2
                    IF vrc_Item."Description 2" <> '' THEN
                        IF lco_Searchname2 = '' THEN
                            lco_Searchname2 := vrc_Item."Description 2"
                        ELSE
                            lco_Searchname2 := copystr(lco_Searchname2 + ' ' + vrc_Item."Description 2", 1, 200);

                    lco_Searchname := COPYSTR(lco_Searchname2, 1, 60);

                END;

            // ------------------------------------------------------------------------------------
            // Schablone 7 -> MFL Münster
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 7":
                lco_Searchname := copystr(vrc_Item.Description + ' ' + vrc_Item."POI Variety Code" + ' ' + vrc_Item."POI Countr of Ori Code (Fruit)", 1, 100);

            // ------------------------------------------------------------------------------------
            // Schablone 8 -> Landlinie
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 8":
                BEGIN
                    lco_Searchname := vrc_Item.Description;
                    IF lrc_Country.GET(vrc_Item."POI Countr of Ori Code (Fruit)") THEN
                        lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Country.Name, 1, 100)
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Countr of Ori Code (Fruit)", 1, 100);
                END;

            // ------------------------------------------------------------------------------------
            // Schablone 9 -> Zerres
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 9":
                BEGIN

                    lco_Searchname := '';

                    // Beschreibung Produktgruppe
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FIND('-') THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_ProductGroup.Description
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + lrc_ProductGroup.Description, 1, 100);

                    // Erzeugerland Code
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."POI Countr of Ori Code (Fruit)"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Countr of Ori Code (Fruit)", 1, 100);

                    // Sortencode
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."POI Variety Code"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Variety Code", 1, 100);

                    // Sortenbeschreibung
                    IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := COPYSTR(lrc_Variety.Description, 1, 15)
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_Variety.Description, 1, 15), 1, 100);

                    // Kaliber
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."POI Caliber Code"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Caliber Code", 1, 100);

                    // Einheitencode
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."Purch. Unit of Measure"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."Purch. Unit of Measure", 1, 100);

                    // Abpackung
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."POI Item Attribute 4"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Item Attribute 4", 1, 100);

                END;

            // ------------------------------------------------------------------------------------
            // Schablone 10 -> Port / ONKEL
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 10":
                BEGIN
                    lco_Searchname := '';
                    // Produktgruppe
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FINDFIRST() THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := UPPERCASE(DELCHR(lrc_ProductGroup.Description, '>', ' '))
                        ELSE
                            lco_Searchname := COPYSTR(lco_Searchname + ' ' + DELCHR(lrc_ProductGroup.Description, '>', ' '), 1, 60);
                    // Sorte
                    IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(lrc_Variety.Description, '>', ' ')
                        ELSE
                            lco_Searchname := COPYSTR(lco_Searchname + ' ' + DELCHR(lrc_Variety.Description, '>', ' '), 1, 60);
                END;

            // ------------------------------------------------------------------------------------
            // Schablone 11 -> AGILES
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 11":
                BEGIN
                    lco_Searchname := '';

                    // Beschreibung
                    IF vrc_Item.Description <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_Item.Description
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item.Description, 1, 100);

                    // Marke
                    IF lrc_Trademark.GET(vrc_Item."POI Trademark Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_Trademark."Search Description"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Trademark."Search Description", 1, 100);


                END;
            // ------------------------------------------------------------------------------------
            // Schablone 12 -> INTERWeichert
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 12":
                BEGIN

                    lco_Searchname := '';

                    // Produktgruppe
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FIND('-') THEN
                        lco_Searchname := UPPERCASE(DELCHR(lrc_ProductGroup.Description, '>', ' '));

                    // Herkunft
                    IF lco_Searchname = '' THEN
                        lco_Searchname := DELCHR(vrc_Item."POI Countr of Ori Code (Fruit)", '>', ' ')
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + DELCHR(vrc_Item."POI Countr of Ori Code (Fruit)", '>', ' '), 1, 100);

                    // Kolloeinheit
                    IF lrc_UnitofMeasure.GET(vrc_Item."Purch. Unit of Measure") THEN BEGIN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' ')
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' '), 1, 100);
                    END ELSE
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' ')
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' '), 1, 100);

                    // Kaliber
                    IF lrc_Caliber.GET(vrc_Item."POI Caliber Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := UPPERCASE(DELCHR(vrc_Item."POI Caliber Code", '>', ' '))
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + UPPERCASE(DELCHR(vrc_Item."POI Caliber Code", '>', ' ')), 1, 100);

                    // Marke
                    IF lrc_Trademark.GET(vrc_Item."POI Trademark Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := UPPERCASE(DELCHR(lrc_Trademark.Description, '>', ' '))
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + UPPERCASE(DELCHR(lrc_Trademark.Description, '>', ' ')), 1, 100);

                    // Farbe
                    IF lrc_Color.GET(vrc_Item."POI Item Attribute 2") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := UPPERCASE(DELCHR(vrc_Item."POI Item Attribute 2", '>', ' '))
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + UPPERCASE(DELCHR(vrc_Item."POI Item Attribute 2", '>', ' ')), 1, 100);


                    // Sorte
                    IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(vrc_Item."POI Variety Code", '>', ' ')
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + DELCHR(vrc_Item."POI Variety Code", '>', ' '), 1, 100);

                    vrc_Item.Description := GenerateItemDesc1(vrc_Item);
                    vrc_Item."Description 2" := GenerateItemDesc2(vrc_Item);
                END;

            // ------------------------------------------------------------------------------------
            // Schablone 13 -> Dürbeck
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 13":
                BEGIN

                    // Artikelbeschreibung
                    lco_Searchname := vrc_Item.Description;

                    // Sorte
                    IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_Variety.Description
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Variety.Description, 1, 100);

                END;

            // ------------------------------------------------------------------------------------
            // Schablone 14 -> Kölla HH
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 14":
                BEGIN

                    lco_Searchname := '';

                    // Sorte
                    IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(lrc_Variety.Description, '>', ' ')
                        ELSE
                            lco_Searchname := COPYSTR(lco_Searchname + ' ' + DELCHR(lrc_Variety.Description, '>', ' '), 1, 60);

                    // Qualität
                    IF lrc_Quality.GET(vrc_Item."POI Item Attribute 3") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_Quality.Description
                        ELSE
                            lco_Searchname := COPYSTR(lco_Searchname + ' ' + lrc_Quality.Description, 1, 60);

                    // Produktgruppe
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FIND('-') THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := UPPERCASE(DELCHR(lrc_ProductGroup.Description, '>', ' '))
                        ELSE
                            lco_Searchname := COPYSTR(lco_Searchname + ' ' + DELCHR(lrc_ProductGroup.Description, '>', ' '), 1, 60);


                END;
            // ------------------------------------------------------------------------------------
            // Schablone 15 -> Grundhöfer GmbH
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 15":
                BEGIN

                    lco_Searchname := '';

                    // --------------------------------------------------------------------------------
                    // LEERGUT/TRANSPORTMITTEL
                    // --------------------------------------------------------------------------------
                    IF (COPYSTR(vrc_Item."No.", 1, 1) = '1') THEN BEGIN

                        // Beschreibung
                        IF vrc_Item.Description <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := vrc_Item.Description
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item.Description, 1, 100);

                        // Artikelhauptkategorie
                        lrc_ItemMainCategory.SETRANGE(Code, vrc_Item."POI Item Main Category Code");
                        IF lrc_ItemMainCategory.FIND('-') THEN
                            IF lrc_ItemMainCategory.Description <> '' THEN
                                IF lco_Searchname = '' THEN
                                    lco_Searchname := UPPERCASE(lrc_ItemMainCategory.Description)
                                ELSE
                                    lco_Searchname := copystr(lco_Searchname + ' ' + UPPERCASE(lrc_ItemMainCategory.Description), 1, 100);

                        // --------------------------------------------------------------------------------
                        // WARE
                        // --------------------------------------------------------------------------------
                    END ELSE BEGIN

                        // Beschreibung
                        IF vrc_Item.Description <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := COPYSTR(vrc_Item.Description, 1, 10)
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(vrc_Item.Description, 1, 10), 1, 100);

                        // Sorte
                        IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                            IF lrc_Variety.Description <> '' THEN
                                IF lco_Searchname = '' THEN
                                    lco_Searchname := COPYSTR(DELCHR(lrc_Variety.Description, '>', ' '), 1, 10)
                                ELSE
                                    lco_Searchname := COPYSTR(lco_Searchname + ' ' + COPYSTR(DELCHR(lrc_Variety.Description, '>', ' '), 1, 10), 1, 100);


                        // Herkunftsland Beschreibung
                        IF lrc_Country.GET(vrc_Item."POI Countr of Ori Code (Fruit)") THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := lrc_Country.Code + ' ' + DELCHR(lrc_Country.Name, '>', ' ')
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Country.Code + ' ' + COPYSTR(DELCHR(lrc_Country.Name, '>', ' '), 1, 3), 1, 100);

                        // Caliber
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(vrc_Item."POI Caliber Code", '>', ' ')
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(DELCHR(vrc_Item."POI Caliber Code", '>', ' '), 1, 8), 1, 100);

                        // Leergutartikel Beschreibung
                        IF lrc_ItemEmpties.GET(vrc_Item."POI Empties Item No.") THEN
                            IF lrc_ItemEmpties.Description <> '' THEN
                                IF lco_Searchname = '' THEN
                                    lco_Searchname := COPYSTR(lrc_ItemEmpties."Search Description", 1, 10)
                                ELSE
                                    lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_ItemEmpties."Search Description", 1, 10), 1, 100);
                    END;

                END;

            // ------------------------------------------------------------------------------------
            // Schablone 16 -> EFG GmbH
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 16":
                BEGIN

                    lco_Searchname := '';

                    // Beschreibung
                    IF vrc_Item.Description <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_Item.Description
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item.Description, 1, 100);

                    // Herkunftsland Code
                    IF lrc_Country.GET(vrc_Item."POI Countr of Ori Code (Fruit)") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_Country.Code
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Country.Code, 1, 100);

                    // Farbe
                    IF lrc_Color.GET(vrc_Item."POI Item Attribute 2") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_Color.Code
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Color.Code, 1, 100);

                    // Sorte
                    IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        IF lrc_Variety.Description <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := lrc_Variety.Code
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Variety.Code, 1, 100);

                    // Kaliber
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."POI Caliber Code"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Caliber Code", 1, 100);

                    // Marke
                    IF lrc_Trademark.GET(vrc_Item."POI Trademark Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_Trademark.Code
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Trademark.Code, 1, 100);


                    // Aufbereitung
                    IF lrc_Treatment.GET(vrc_Item."POI Item Attribute 5") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_Treatment.Code
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + lrc_Treatment.Code, 1, 100);

                    // Kolloeinheit
                    IF lrc_UnitofMeasure.GET(vrc_Item."Purch. Unit of Measure") THEN BEGIN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' ')
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' '), 1, 100);
                    END ELSE
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' ')
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' '), 1, 100);

                    // Eigenname
                    IF vrc_Item."POI Item Attribute 6" <> '' THEN
                        lrc_ProperName.GET(vrc_Item."POI Item Attribute 6");
                    IF lco_Searchname = '' THEN
                        lco_Searchname := COPYSTR(lrc_ProperName.Code, 1, 6)
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + lrc_ProperName.Code, 1, 100);

                    // Abpackung
                    IF vrc_Item."POI Item Attribute 4" <> '' THEN
                        IF lco_Searchname <> '' THEN
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Item Attribute 4", 1, 100)
                        ELSE
                            lco_Searchname := vrc_Item."POI Item Attribute 4";

                    // Leergutartikel Beschreibung
                    IF lrc_ItemEmpties.GET(vrc_Item."POI Empties Item No.") THEN
                        IF lrc_ItemEmpties.Description <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := COPYSTR(lrc_ItemEmpties.Description, 1, 6)
                            ELSE
                                lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_ItemEmpties.Description, 1, 6), 1, 100);
                END;

            // ------------------------------------------------------------------------------------
            // Schablone 17 -> Del Monte Fresh
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 17":
                BEGIN

                    lco_Searchname := '';

                    // Produktgruppe
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    // IF lrc_ProductGroup.FIND('-') THEN
                    //   lco_Searchname := DELCHR(COPYSTR(lrc_ProductGroup.Description,1,8), '>', ' ');
                    lco_Searchname := DELCHR(COPYSTR(vrc_Item.Description, 1, 8), '>', ' ');

                    // Sorte
                    IF lrc_Variety.GET(vrc_Item."POI Variety Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(COPYSTR(lrc_Variety.Description, 1, 8), '>', ' ')
                        ELSE
                            lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Variety.Description, 1, 8), '>', ' ');

                    // Konservierung Code
                    // Regular / Seedless
                    IF lrc_Conservation.GET(vrc_Item."POI Item Attribute 7") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(COPYSTR(lrc_Conservation.Description, 1, 8), '>', ' ')
                        ELSE
                            lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Conservation.Description, 1, 8), '>', ' ');


                    // Kaliber
                    IF lrc_Caliber.GET(vrc_Item."POI Caliber Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(COPYSTR(lrc_Caliber.Description, 1, 10), '>', ' ')
                        ELSE
                            lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Caliber.Description, 1, 10), '>', ' ');

                    // Kolloeinheit
                    IF lrc_UnitofMeasure.GET(vrc_Item."Purch. Unit of Measure") THEN begin
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(COPYSTR(lrc_UnitofMeasure.Description, 1, 12), '>', ' ')
                        ELSE
                            lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_UnitofMeasure.Description, 1, 12), '>', ' ');
                    END ELSE
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(vrc_Item."Purch. Unit of Measure", '>', ' ')
                        ELSE
                            lco_Searchname := lco_Searchname + DELCHR(' ' + vrc_Item."Purch. Unit of Measure", '>', ' ');

                    // Herkunft
                    IF lco_Searchname = '' THEN
                        lco_Searchname := DELCHR(vrc_Item."POI Countr of Ori Code (Fruit)", '>', ' ')
                    ELSE
                        lco_Searchname := lco_Searchname + DELCHR(' ' + vrc_Item."POI Countr of Ori Code (Fruit)", '>', ' ');

                    // Marke
                    IF lrc_Trademark.GET(vrc_Item."POI Trademark Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(COPYSTR(lrc_Trademark.Description, 1, 10), '>', ' ')
                        ELSE
                            lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Trademark.Description, 1, 8), '>', ' ');

                    // Qualität
                    IF lrc_Quality.GET(vrc_Item."POI Item Attribute 3") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := DELCHR(COPYSTR(lrc_Quality.Description, 1, 4), '>', ' ')
                        ELSE
                            lco_Searchname := lco_Searchname + DELCHR(' ' + COPYSTR(lrc_Quality.Description, 1, 4), '>', ' ');
                END;

            // ------------------------------------------------------------------------------------
            // Schablone Agiles dynamics food
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"agiles dynamics food":
                BEGIN

                    lco_Searchname := COPYSTR(vrc_Item.Description, 1, 10);

                    // Beschreibung Produktgruppe
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FINDFIRST() THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := COPYSTR(lrc_ProductGroup.Description, 1, 10)
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_ProductGroup.Description, 1, 10), 1, 100);

                    // Erzeugerland Code
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."POI Countr of Ori Code (Fruit)"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Countr of Ori Code (Fruit)", 1, 100);

                    // Sortencode
                    IF vrc_Item."POI Variety Code" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_Item."POI Variety Code"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Variety Code", 1, 100);

                    // Kaliber
                    IF vrc_Item."POI Caliber Code" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_Item."POI Caliber Code"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Caliber Code", 1, 100);

                    // Marke
                    IF vrc_Item."POI Trademark Code" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_Item."POI Trademark Code"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Trademark Code", 1, 100);

                    // Abpackung
                    IF vrc_Item."POI Item Attribute 4" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_Item."POI Item Attribute 4"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."POI Item Attribute 4", 1, 100);

                    // Einheitencode
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_Item."Purch. Unit of Measure"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_Item."Purch. Unit of Measure", 1, 100);

                END;

        END;

        // Falls kein neuer Suchbegriff, dann bestehenden Suchbegriff zurückgeben
        IF lco_Searchname = '' THEN
            lco_Searchname := vrc_Item."Search Description";

        EXIT(lco_Searchname);

    end;

    //     procedure GenerateItemSearchNameDesc2(vbn_GenerateItemSearchDesc: Boolean;vbn_GenerateItemDesc1: Boolean;vbn_GenerateItemDesc2: Boolean)
    //     var
    //         lrc_Item: Record Item;
    //         ldl_Window: Dialog;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Generierung Suchbegriff und Artikelbeschreibung 2 für alle Artikel
    //         // ------------------------------------------------------------------------------------

    //         ldl_Window.OPEN('Artikelnr. #1#############');
    //         IF lrc_Item.FIND('-') THEN
    //           REPEAT
    //             ldl_Window.UPDATE(1,lrc_Item."No.");

    //             IF vbn_GenerateItemSearchDesc = TRUE THEN
    //               lrc_Item."Search Description" := GenerateItemSearchDesc(lrc_Item);
    //             IF vbn_GenerateItemDesc1 = TRUE THEN
    //               lrc_Item.Description := GenerateItemDesc1(lrc_Item);
    //             IF vbn_GenerateItemDesc2 = TRUE THEN
    //               lrc_Item."Description 2" := GenerateItemDesc2(lrc_Item);
    //             lrc_Item.Modify();

    //             // In alle Mandanten kopieren
    //             // IC_CopyItem(lrc_Item);
    //           UNTIL lrc_Item.NEXT() = 0;
    //         ldl_Window.CLOSE;
    //     end;

    //     procedure GenerateAllBatchVarSearchDesc()
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_Item: Record Item;
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         // Funktion zur Erstellung des Suchbegriffes nach Schablone für alle Pos.-Var.
    //         // ---------------------------------------------------------------------------------------------

    //         IF NOT CONFIRM('Möchten Sie für alle Pos.-Var. die Suchbegriffe neu erstellen?') THEN
    //           EXIT;

    //         IF lrc_BatchVariant.FINDSET(TRUE,FALSE) THEN BEGIN
    //           REPEAT
    //            IF lrc_Item.GET(lrc_BatchVariant."Item No.") THEN BEGIN
    //              lrc_BatchVariant."Search Description" := ItemSearchNameFromBatchVar(lrc_Item,lrc_BatchVariant);
    //              lrc_BatchVariant.Modify();
    //            END;
    //           UNTIL lrc_BatchVariant.NEXT() = 0;
    //         END;
    //     end;

    procedure ItemSearchNameFromBatchVar(vrc_Item: Record Item; vrc_BatchVariant: Record "POI Batch Variant"): Code[100]
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Country: Record "Country/Region";
        // lrc_Variety: Record "POI Variety";
        // lrc_UnitofMeasure: Record "Unit of Measure";
        // lrc_Caliber: Record "POI Caliber";
        // lrc_ItemEmpties: Record Item;
        // lrc_Quality: Record "POI Item Attribute 3";
        // lrc_Trademark: Record "POI Trademark";
        // lrc_Color: Record "POI Item Attribute 2";
        // lrc_ItemCategory: Record "Item Category";
        // lrc_ItemMainCategory: Record "POI Item Main Category";
        // lrc_BatchVariant: Record "POI Batch Variant";
        lco_Searchname: Code[100];
    // lco_Searchname2: Code[200];
    // lin_Position: Integer;
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zur Erstellung des Suchbegriffes nach Schablone
        // ---------------------------------------------------------------------------------------------

        IF vrc_Item."No." = '' THEN
            EXIT('');

        IF vrc_BatchVariant."No." = '' THEN
            EXIT('');

        lrc_FruitVisionSetup.GET();

        CASE lrc_FruitVisionSetup."Item Search Desc. Template" OF

            // ------------------------------------------------------------------------------------
            //
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::" ":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            //
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 1":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 2 -> Fruchthof Northeim
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 2":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 3 -> Schliecker
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 3":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 4 -> Im Einsatz Brandenburger Obst
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 4":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 5 -> Im Einsatz bei Biotropic
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 5":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 6 -> Im Einsatz bei Meyer Gemüsebearbeitung
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 6":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 7 -> Im Einsatz bei MFL Münster
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 7":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 8 -> Im Einsatz bei Landlinie
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 8":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 9 -> Im Einsatz bei Zerres
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 9":

                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 10 -> Im Einsatz bei ONKEL
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 10":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 11 -> Im Einsatz bei AGILES
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 11":
                BEGIN

                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FINDFIRST() THEN;

                    lco_Searchname := COPYSTR(vrc_Item.Description + ' ' +
                                              vrc_BatchVariant."Country of Origin Code" + ' ' +
                                              vrc_BatchVariant."Variety Code" + ' ' +
                                              vrc_BatchVariant."Caliber Code" + ' ' +
                                              COPYSTR(lrc_ProductGroup.Description, 1, 10),
                                                1, 100);
                    lco_Searchname := COPYSTR(lco_Searchname + ' ' + FORMAT(vrc_BatchVariant."Cultivation Type"), 1, 60);

                END;
            // ------------------------------------------------------------------------------------
            // Schablone 12 -> Im Einsatz bei INTERWeichert
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 12":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 13 -> Im Einsatz bei Dürbeck
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 13":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 14 -> Im Einsatz bei Kölla HH
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 14":
                BEGIN

                    lco_Searchname := '';

                    lco_Searchname := vrc_Item."Search Description";

                    // Produktgruppe
                    lrc_ProductGroup.RESET();
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FIND('-') THEN
                        IF lrc_ProductGroup.Description <> '' THEN
                            IF lco_Searchname = '' THEN
                                lco_Searchname := UPPERCASE(DELCHR(lrc_ProductGroup.Description, '>', ' '))
                            ELSE
                                lco_Searchname := COPYSTR((lco_Searchname + ' ' + UPPERCASE(DELCHR(lrc_ProductGroup.Description, '>', ' '))), 1, 60);

                    // Herkunftsland Beschreibung
                    lrc_Country.RESET();
                    IF lrc_Country.GET(vrc_BatchVariant."Country of Origin Code") THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := lrc_Country.Code
                        ELSE
                            lco_Searchname := COPYSTR((lco_Searchname + ' ' + lrc_Country.Code), 1, 60);

                END;

            // ------------------------------------------------------------------------------------
            // Schablone 15 -> Im Einsatz bei Grundhöfer GmbH
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 15":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone 17 -> Del Monte Fresh
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"Schablone 17":
                lco_Searchname := '';

            // ------------------------------------------------------------------------------------
            // Schablone Agiles dynamics food
            // ------------------------------------------------------------------------------------
            lrc_FruitVisionSetup."Item Search Desc. Template"::"agiles dynamics food":
                BEGIN

                    lco_Searchname := COPYSTR(vrc_Item.Description, 1, 10);

                    // Beschreibung Produktgruppe
                    lrc_ProductGroup.SETRANGE(Code, vrc_Item."POI Product Group Code");
                    IF lrc_ProductGroup.FINDFIRST() THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := COPYSTR(lrc_ProductGroup.Description, 1, 10)
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + COPYSTR(lrc_ProductGroup.Description, 1, 10), 1, 100);

                    // Erzeugerland Code
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_BatchVariant."Country of Origin Code"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_BatchVariant."Country of Origin Code", 1, 100);

                    // Sortencode
                    IF vrc_BatchVariant."Variety Code" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_BatchVariant."Variety Code"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_BatchVariant."Variety Code", 1, 100);

                    // Kaliber
                    IF vrc_BatchVariant."Caliber Code" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_BatchVariant."Caliber Code"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_BatchVariant."Caliber Code", 1, 100);

                    // Marke
                    IF vrc_BatchVariant."Trademark Code" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_BatchVariant."Trademark Code"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_BatchVariant."Trademark Code", 1, 100);

                    // Abpackung
                    IF vrc_BatchVariant."Item Attribute 4" <> '' THEN
                        IF lco_Searchname = '' THEN
                            lco_Searchname := vrc_BatchVariant."Item Attribute 4"
                        ELSE
                            lco_Searchname := copystr(lco_Searchname + ' ' + vrc_BatchVariant."Item Attribute 4", 1, 100);

                    // Einheitencode
                    IF lco_Searchname = '' THEN
                        lco_Searchname := vrc_BatchVariant."Unit of Measure Code"
                    ELSE
                        lco_Searchname := copystr(lco_Searchname + ' ' + vrc_BatchVariant."Unit of Measure Code", 1, 100);

                END;

        END;

        // Falls kein neuer Suchbegriff, dann bestehenden Suchbegriff zurückgeben
        IF lco_Searchname = '' THEN
            lco_Searchname := vrc_Item."Search Description";

        EXIT(lco_Searchname);
    end;

    // procedure CopyItemNo(vco_ItemNo: Code[20]): Code[20]
    // var
    //     lcu_NoSeriesManagement: Codeunit "396";
    //     AGILES_LT_TEXT001: Label 'Es wurde keine neue Artikelnummer eingegeben!';
    //     lrc_FruitVisionSetup: Record "5110302";
    //     lrc_Item: Record Item;
    //     lrc_ItemOrg: Record Item;
    //     lrc_InventorySetup: Record "313";
    //     lrc_ItemBlockPricing: Record "5110555";
    //     lfm_FVCopyItem: Form "5110317";
    //     lco_NewItemNo: Code[20];
    // begin
    //     // ------------------------------------------------------------------------------------
    //     // Artikelstammsatz kopieren
    //     // ------------------------------------------------------------------------------------

    //     IF vco_ItemNo = '' THEN
    //       ERROR('');

    //     lrc_Item.FILTERGROUP(2);
    //     lrc_Item.SETRANGE("No.",vco_ItemNo);
    //     lrc_Item.FILTERGROUP(0);

    //     lfm_FVCopyItem.SETTABLEVIEW(lrc_Item);
    //     lfm_FVCopyItem.LOOKUPMODE := TRUE;

    //     lco_NewItemNo := '';

    //     IF lfm_FVCopyItem.RUNMODAL = ACTION::LookupOK THEN BEGIN

    //       // Neue Version.s
    //       lco_NewItemNo := lfm_FVCopyItem.GetNewItemNo();
    //       IF lco_NewItemNo = '' THEN BEGIN
    //         lrc_InventorySetup.Get();
    //         IF lrc_InventorySetup."Item Nos." <> '' THEN BEGIN
    //           lco_NewItemNo := lcu_NoSeriesManagement.GetNextNo(lrc_InventorySetup."Item Nos.",Today(),TRUE);
    //         END ELSE BEGIN
    //           // Es wurde keine neue Artikelnummer eingegeben!
    //           ERROR(AGILES_LT_TEXT001);
    //         END;
    //       END;
    //       // Neue Version.s

    //       lrc_FruitVisionSetup.GET();

    //       lrc_ItemOrg.GET(vco_ItemNo);

    //       lrc_Item := lrc_ItemOrg;
    //       lrc_Item."No." := lco_NewItemNo;
    //       InsertTemplateItem(lrc_Item);
    //       lrc_Item.insert();

    //       lrc_ItemBlockPricing.INIT();
    //       lrc_ItemBlockPricing."Item No." := lrc_Item."No.";
    //       lrc_ItemBlockPricing.insert();

    //       lrc_Item.Description := lrc_ItemOrg.Description;
    //       lrc_Item.Description := GenerateItemDesc1(lrc_Item);
    //       lrc_Item."Search Description" := GenerateItemSearchDesc(lrc_Item);
    //       lrc_Item."Description 2" := GenerateItemDesc2(lrc_Item);

    //       lrc_Item.VALIDATE("Base Unit of Measure",lrc_ItemOrg."Base Unit of Measure");
    //       lrc_Item.Modify();

    //       lrc_Item.VALIDATE("Purch. Unit of Measure",lrc_ItemOrg."Purch. Unit of Measure");

    //       // lrc_Item."POI Empties Item No." := lrc_ItemOrg."POI Empties Item No.";
    //       lrc_Item."Empties Quantity" := lrc_ItemOrg."Empties Quantity";

    //       // Aktiv im Verkauf auf Ja/Nein stellen
    //       IF lrc_FruitVisionSetup."Copy Item" = lrc_FruitVisionSetup."Copy Item"::"Active in Sales is True" THEN
    //         lrc_Item."Activ in Sales" := TRUE
    //       ELSE
    //         lrc_Item."Activ in Sales" := FALSE;

    //       lrc_Item.Modify();

    //       EXIT(lco_NewItemNo);
    //     END;

    //     EXIT(lco_NewItemNo);
    // end;

    // procedure CustCreateCustSearchName(vco_CustNo: Code[20]): Code[50]
    // var
    //     lrc_Customer: Record "Customer";
    //     lco_CustSearchName: Code[50];
    // begin
    //     // ---------------------------------------------------------------------------------
    //     // Debitor Suchbegriff erstellen
    //     // ---------------------------------------------------------------------------------

    //     lrc_Customer.GET(vco_CustNo);
    //     lco_CustSearchName := COPYSTR(lrc_Customer.Name,1,30) + ' ' + COPYSTR(lrc_Customer.City,1,17);

    //     EXIT(lco_CustSearchName);
    // end;
    var
        lrc_ProductGroup: Record "POI Product Group";
        lrc_Variety: Record "POI Variety";
        Item: Record Item;
        lrc_ProperName: Record "POI Proper Name";
        lrc_ItemMainCategory: Record "POI Item Main Category";
}

