table 5110713 "POI Pack. Order Output Items"
{
    Caption = 'Pack. Order Output Items';
    // DrillDownFormID = Form5110738;
    // LookupFormID = Form5110738;
    PasteIsValid = false;
    Permissions = TableData 32 = rm;

    fields
    {
        field(1; "Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(9; "Type of Packing Product"; Option)
        {
            Caption = 'Type of Packing Product';
            OptionCaption = ' ,Finished Product,,,Industry Goods,,,Fruit Juice,,,Spoilt,,,Sub-/Out-Size,,,,,,,Difference';
            OptionMembers = " ","Finished Product",,,"Industry Goods",,,"Fruit Juice",,,Spoilt,,,"Sub-/Out-Size",,,,,,,Difference;

            trigger OnValidate()
            var
                lrc_PackOrderHeader: Record "POI Pack. Order Header";
            begin
                IF "Type of Packing Product" <> xRec."Type of Packing Product" THEN
                    IF "Type of Packing Product" = "Type of Packing Product"::"Finished Product" THEN BEGIN
                        lrc_PackOrderHeader.GET("Doc. No.");
                        IF lrc_PackOrderHeader."Item No." <> '' THEN
                            VALIDATE("Item No.", lrc_PackOrderHeader."Item No.");
                    END;

            end;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";

            trigger OnValidate()
            var

                lrc_Item: Record Item;
                lrc_PackOrderHeader: Record "POI Pack. Order Header";
                lrc_FruitVisionSetup: Record "POI ADF Setup";
                lrc_ItemUnitOfMeasure: Record "Item Unit of Measure";
                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_BatchVariant: Record "POI Batch Variant";
                lrc_PackOrderLabels: Record "POI Pack. Order Labels";
                lrc_BatchSetup: Record "POI Master Batch Setup";
                lcu_BatchMgt: Codeunit "POI BAM Batch Management";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
                lco_BatchVariantNo: Code[20];
                lco_BatchNo: Code[20];
                SSPText01Txt: Label 'Change not possible, please delete first the label lines for this line !';
            begin
                TESTFIELD("Quantity Produced", 0);

                IF (xRec."Item No." <> "Item No.") AND
                   (xRec."Item No." <> '') AND
                   ("Batch Variant No." <> '') THEN
                    IF lrc_BatchVariant.GET("Batch Variant No.") THEN
                        IF "Quantity Produced" = 0 THEN BEGIN
                            lrc_BatchVariant.DELETE(TRUE);
                            "Batch Variant No." := '';
                        END;

                IF ("Item No." <> xRec."Item No.") THEN BEGIN
                    lrc_PackOrderLabels.RESET();
                    lrc_PackOrderLabels.SETRANGE("Doc. No.", "Doc. No.");
                    lrc_PackOrderLabels.SETRANGE("Doc. Line No. Output", "Line No.");
                    IF not lrc_PackOrderLabels.IsEmpty() THEN
                        // Änderung nicht möglich, erst Etikettenzeilen dieser Zeile löschen
                        ERROR(SSPText01Txt);


                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Item No."), 1, 100), Rec);


                END;

                CheckChangeItemNo();

                IF ("Item No." <> '') THEN BEGIN

                    lrc_PackOrderHeader.GET("Doc. No.");
                    lrc_FruitVisionSetup.GET();
                    lrc_Item.GET("Item No.");

                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Item Typ" := lrc_Item."POI Item Typ";

                    "Feature Level" := lrc_FruitVisionSetup."Feature Level";

                    "Item Category Code" := lrc_Item."Item Category Code";
                    //"Product Group Code" := lrc_Item."Product Group Code";
                    //"Country of Origin Code" := lrc_Item."Country of Origin Code (Fruit)";
                    //"Variety Code" := lrc_Item."Variety Code";
                    //"Caliber Code" := lrc_Item."Caliber Code";

                    //"Coding Code" := lrc_Item."Coding Code";


                    "Unit of Measure Code" := lrc_Item."Purch. Unit of Measure";

                    lrc_UnitofMeasure.GET(lrc_Item."Purch. Unit of Measure");
                    lrc_ItemUnitOfMeasure.GET(lrc_Item."No.", lrc_Item."Purch. Unit of Measure");
                    "Qty. per Unit of Measure" := lrc_ItemUnitOfMeasure."Qty. per Unit of Measure";

                    "Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
                    "Reference Unit for Pack. Qty." := lrc_Item."Base Unit of Measure";
                    "Collo Unit of Measure (CU)" := lrc_Item."Purch. Unit of Measure";

                    //VALIDATE("Price Base (Purch. Price)", lrc_Item."Price Base (Purch. Price)");//TODO: price base
                    //VALIDATE("Price Base (Sales Price)", lrc_Item."Price Base (Sales Price)");

                    "Packing Unit of Measure (PU)" := lrc_UnitofMeasure."POI Packing Unit of Meas (PU)";
                    "Qty. (PU) per Unit of Measure" := lrc_UnitofMeasure."POI Qty. (PU) per Unit of Meas";

                    "Transport Unit of Measure (TU)" := '';
                    IF "Transport Unit of Measure (TU)" = '' THEN
                        "Transport Unit of Measure (TU)" := lrc_UnitofMeasure."POI Transp. Unit of Meas (TU)";
                    "Content Unit of Measure (COU)" := '';

                    IF "Unit of Measure Code" <> '' THEN
                        FillCrossReferenceNo(FIELDNO("Unit of Measure Code"), Rec);

                    IF "Transport Unit of Measure (TU)" <> '' THEN
                        FillCrossReferenceNo(FIELDNO("Transport Unit of Measure (TU)"), Rec);
                    IF "Packing Unit of Measure (PU)" <> '' THEN
                        FillCrossReferenceNo(FIELDNO("Packing Unit of Measure (PU)"), Rec);


                    VALIDATE(Quantity, 0);
                    VALIDATE("Location Code", lrc_PackOrderHeader."Outp. Item Location Code");

                    ////  VALIDATE( "Spectrum Caliber A-Goods", lrc_Item."Spectrum Caliber A-Goods" );

                    // Positionsvariantennr vergeben
                    IF (lrc_Item."POI Batch Item" = TRUE) AND
                       ("Batch Variant No." = '') THEN BEGIN

                        lrc_PackOrderHeader.TESTFIELD("Master Batch No.");
                        lrc_BatchSetup.GET();

                        CASE lrc_PackOrderHeader."Document Type" OF
                            lrc_PackOrderHeader."Document Type"::"Packing Order":
                                CASE lrc_BatchSetup."Pack. Allocation Batch No." OF
                                    lrc_BatchSetup."Pack. Allocation Batch No."::"One Batch No. per Order":
                                        BEGIN
                                            lrc_PackOrderHeader.TESTFIELD("Batch No.");
                                            "Master Batch No." := lrc_PackOrderHeader."Master Batch No.";
                                            "Batch No." := lrc_PackOrderHeader."Batch No.";
                                            lco_BatchNo := lrc_PackOrderHeader."Batch No.";
                                            lcu_BatchMgt.PackNewBatchVar(Rec, lco_BatchNo, lco_BatchVariantNo);
                                            "Batch Variant No." := lco_BatchVariantNo;
                                        END;
                                    lrc_BatchSetup."Pack. Allocation Batch No."::"New Batch No. per Line":
                                        BEGIN
                                            "Master Batch No." := lrc_PackOrderHeader."Master Batch No.";
                                            lco_BatchNo := '';
                                            lcu_BatchMgt.PackNewBatchVar(Rec, lco_BatchNo, lco_BatchVariantNo);
                                            "Batch No." := lco_BatchNo;
                                            "Batch Variant No." := lco_BatchVariantNo;
                                        END;
                                END;
                            lrc_PackOrderHeader."Document Type"::"Sorting Order":
                                CASE lrc_BatchSetup."Sort. Allocation Batch No." OF
                                    lrc_BatchSetup."Sort. Allocation Batch No."::"One Batch No. per Order":
                                        BEGIN
                                            lrc_PackOrderHeader.TESTFIELD("Batch No.");
                                            "Master Batch No." := lrc_PackOrderHeader."Master Batch No.";
                                            "Batch No." := lrc_PackOrderHeader."Batch No.";
                                            lco_BatchNo := lrc_PackOrderHeader."Batch No.";
                                            lcu_BatchMgt.PackNewBatchVar(Rec, lco_BatchNo, lco_BatchVariantNo);
                                            "Batch Variant No." := lco_BatchVariantNo;
                                        END;
                                    lrc_BatchSetup."Sort. Allocation Batch No."::"New Batch No. per Line":
                                        BEGIN
                                            "Master Batch No." := lrc_PackOrderHeader."Master Batch No.";
                                            lco_BatchNo := '';
                                            lcu_BatchMgt.PackNewBatchVar(Rec, lco_BatchNo, lco_BatchVariantNo);
                                            "Batch No." := lco_BatchNo;
                                            "Batch Variant No." := lco_BatchVariantNo;
                                        END;
                                END;
                            lrc_PackOrderHeader."Document Type"::"Substitution Order":
                                CASE lrc_BatchSetup."Subst. Allocation Batch No." OF
                                    lrc_BatchSetup."Subst. Allocation Batch No."::"One Batch No. per Order":
                                        BEGIN
                                            lrc_PackOrderHeader.TESTFIELD("Batch No.");
                                            "Master Batch No." := lrc_PackOrderHeader."Master Batch No.";
                                            "Batch No." := lrc_PackOrderHeader."Batch No.";
                                            lco_BatchNo := lrc_PackOrderHeader."Batch No.";
                                            lcu_BatchMgt.PackNewBatchVar(Rec, lco_BatchNo, lco_BatchVariantNo);
                                            "Batch Variant No." := lco_BatchVariantNo;
                                        END;
                                    lrc_BatchSetup."Subst. Allocation Batch No."::"New Batch No. per Line":
                                        BEGIN
                                            "Master Batch No." := lrc_PackOrderHeader."Master Batch No.";
                                            lco_BatchNo := '';
                                            lcu_BatchMgt.PackNewBatchVar(Rec, lco_BatchNo, lco_BatchVariantNo);
                                            "Batch No." := lco_BatchNo;
                                            "Batch Variant No." := lco_BatchVariantNo;
                                        END;
                                END;
                        END;
                        "Batch Variant generated" := TRUE;
                    END;
                    SetWeightValues();

                END ELSE BEGIN

                    "Item Typ" := "Item Typ"::"Trade Item";

                    lrc_FruitVisionSetup.GET();
                    "Feature Level" := lrc_FruitVisionSetup."Feature Level";

                    "Item Description" := '';
                    "Item Description 2" := '';
                    "Item Category Code" := '';
                    "Product Group Code" := '';
                    "Country of Origin Code" := '';

                    "Cultivation Type" := "Cultivation Type"::" ";

                    "Unit of Measure Code" := '';
                    "Qty. per Unit of Measure" := 1;

                    "Base Unit of Measure (BU)" := '';
                    "Collo Unit of Measure (CU)" := '';
                    "Packing Unit of Measure (PU)" := '';
                    "Qty. (PU) per Unit of Measure" := 0;
                    "Transport Unit of Measure (TU)" := '';
                    "Content Unit of Measure (COU)" := '';

                    VALIDATE(Quantity, 0);
                    VALIDATE("Spectrum Caliber A-Goods", '');

                END;

                // Zugeordnete Lagerorte aktualisieren
                IF ("Location Code" <> '') AND ("Batch Variant No." <> '') THEN
                    gcu_StockMgt.BatchVarFillLocations("Batch Variant No.", "Batch No.", "Item No.", "Location Code");

                CalcQuantityPer();
            end;
        }
        field(11; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Variant Code" <> xRec."Variant Code" THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Location Code"), 1, 100), Rec);
            end;
        }
        field(12; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Master Batch No." <> xRec."Master Batch No." THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Master Batch No."), 1, 100), Rec);
            end;
        }
        field(13; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch";

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Batch No." <> xRec."Batch No." THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Batch No."), 1, 100), Rec);
            end;
        }
        field(14; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant";

            trigger OnValidate()
            var
                lrc_Item: Record Item;
                lrc_BatchVariant: Record "POI Batch Variant";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF CurrFieldNo = FIELDNO("Batch Variant No.") THEN
                    IF "Batch Variant generated" = TRUE THEN
                        // Änderung nicht zulässig!
                        ERROR(AGILES_TEXT002Txt);

                IF "Batch Variant No." <> xRec."Batch Variant No." THEn
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Batch Variant No."), 1, 100), Rec);

                IF "Batch Variant No." = '' THEN BEGIN
                    lrc_Item.GET("Item No.");
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";

                    //"Variety Code" := lrc_Item."Variety Code";
                    // "Country of Origin Code" := lrc_Item."Country of Origin Code (Fruit)";

                    // "Caliber Code" := lrc_Item."Caliber Code";

                    // "Coding Code" := lrc_Item."Coding Code";


                    "Batch No." := '';
                END ELSE
                    IF lrc_BatchVariant.GET("Batch Variant No.") THEN BEGIN
                        //"Variety Code" := lrc_BatchVariant."Variety Code";
                        "Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";

                        "Caliber Code" := lrc_BatchVariant."Caliber Code";

                        //"Coding Code" := lrc_BatchVariant."Coding Code";


                        IF ("Batch No." = '') OR ("Batch No." <> lrc_BatchVariant."Batch No.") THEN
                            "Batch No." := lrc_BatchVariant."Batch No."
                    END;
            end;
        }
        field(15; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(16; "Item Description 2"; Text[100])
        {
            Caption = 'Item Description 2';
        }
        field(17; "Item Main Category Code"; Code[10])
        {
            Caption = 'Item Main Category Code';
        }
        field(18; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(19; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(20; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety";

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Variety Code") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Variety Code"));
            end;
        }
        field(21; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
            //lcu_ExtendedDimensionMgt: Codeunit "5087916"; //TODO: extended Dimension
            begin
                // PAC 002 DMG50054.s
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                // IF CurrFieldNo = FIELDNO("Country of Origin Code") THEN
                //     gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Country of Origin Code"));


                // Dimension aufgrund erweiterter Kriterien suchen
                //lcu_ExtendedDimensionMgt.EDM_PackOutputLineItem(Rec);
            end;
        }
        field(22; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Trademark Code") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Trademark Code"));

            end;
        }
        field(23; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber";

            trigger OnValidate()
            begin

                // IF CurrFieldNo = FIELDNO("Caliber Code") THEN
                //     gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Caliber Code"));
            end;
        }
        field(24; "Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Item Attribute 2") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Item Attribute 2"));
            end;
        }
        field(25; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods".Code;

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Grade of Goods Code") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Grade of Goods Code"));
            end;
        }
        field(26; "Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Item Attribute 7") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Item Attribute 7"));
            end;
        }
        field(27; "Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Item Attribute 4") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Item Attribute 4"));
            end;
        }
        field(28; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Coding Code") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Coding Code"));
            end;
        }
        field(29; "Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3";

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Item Attribute 3") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Item Attribute 3"));
            end;
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                lrc_Location: Record Location;
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                TESTFIELD("Quantity Produced", 0);

                IF "Location Code" <> '' THEN BEGIN
                    lrc_Location.GET("Location Code");
                    //"Location Group Code" := lrc_Location."Location Group Code"; //TODO: Location group code

                    // Zugeordnete Lagerorte aktualisieren
                    IF "Batch Variant No." <> '' THEN
                        gcu_StockMgt.BatchVarFillLocations("Batch Variant No.", "Batch No.", "Item No.", "Location Code");

                END ELSE
                    "Location Group Code" := '';


                IF "Location Code" <> xRec."Location Code" THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Location Code"), 1, 100), Rec);
            end;
        }
        field(31; "Location Group Code"; Code[10])
        {
            Caption = 'Location Group Code';
            //TableRelation = "Location Group";
        }
        field(32; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                lcu_BaseDataMgt: Codeunit "POI Base Data Mgt";
            begin
                VALIDATE("Unit of Measure Code", lcu_BaseDataMgt.PackOutpUnitOfMeasureLookUp("Product Group Code", "Item No."));
            end;

            trigger OnValidate()
            var
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
                lrc_UnitOfMeasure: Record "Unit of Measure";
                lcu_BatchMgt: Codeunit "POI BAM Batch Management";
                lcu_BaseDataMgt: Codeunit "POI Base Data Mgt";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            //lcu_Purchase: Codeunit "5110323";
            begin
                "Unit of Measure Code" := lcu_BaseDataMgt.PackOutpUnitOfMeasureValidate(Rec);
                TESTFIELD("Item No.");
                TESTFIELD("Quantity Produced", 0);

                IF "Unit of Measure Code" <> '' THEN BEGIN
                    lrc_UnitOfMeasure.GET("Unit of Measure Code");
                    IF "Base Unit of Measure (BU)" <> lrc_UnitOfMeasure."POI Base Unit of Measure (BU)" THEN
                        //     // Basiseinheit Artikel und Einheitencode sind abweichend!
                        ERROR(AGILES_TEXT010Txt);
                    lrc_ItemUnitofMeasure.GET("Item No.", "Unit of Measure Code");
                    "Qty. per Unit of Measure" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
                    "Packing Unit of Measure (PU)" := lrc_UnitOfMeasure."POI Packing Unit of Meas (PU)"; //TODO: unit of measure
                    "Qty. (PU) per Unit of Measure" := lrc_UnitOfMeasure."POI Qty. (PU) per Unit of Meas";
                    "Unit of Measure" := lrc_UnitOfMeasure.Description;
                    VALIDATE(Quantity);
                END ELSE BEGIN
                    "Qty. per Unit of Measure" := 1;
                    "Quantity (Base)" := 0;
                    "Packing Unit of Measure (PU)" := '';
                    "Qty. (PU) per Unit of Measure" := 0;
                    "Unit of Measure" := '';
                END;

                CalcQuantityPer();

                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN BEGIN

                    IF "Batch Variant No." <> '' THEN
                        IF lcu_BatchMgt.BatchVarCheckIfInOpenDoc("Item No.", "Batch Variant No.", '') = TRUE THEN
                            // Änderung nicht zulässig, Positionsvariante %1 ist in Belegen zugeordnet!
                            ERROR(AGILES_TEXT003Txt, "Batch Variant No.");
                    IF "Unit of Measure Code" <> '' THEN
                        FillCrossReferenceNo(FIELDNO("Unit of Measure Code"), Rec);


                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Unit of Measure Code"), 1, 100), Rec);

                END;

                SetWeightValues();


                VALIDATE("Market Unit Cost (Price Base)");

            end;
        }
        field(33; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
        }
        field(34; Quantity; Decimal)  //TODO: Quantity Validate trigger
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                //lrc_ItemVariant: Record "Item Variant";
                lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
                //         lrc_PositionPlanningSetup: Record "5110488";
                //         lcu_PurchaseDispoMgt: Codeunit "5110380";
                lrc_PackOrderHeader: Record "POI Pack. Order Header";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                ldc_Factor: Decimal;
                //         lrc_RecipeHeader: Record "5110710";
                ldc_Qty: Decimal;
                ldc_Qty1: Decimal;
            begin
                IF (Quantity * "Quantity Produced" < 0) OR
                   (ABS(Quantity) < ABS("Quantity Produced")) THEN
                    // Menge darf nicht weniger als die gepackte Menge sein!
                    ERROR(AGILES_TEXT004Txt);

                // Prüfen, ob Menge gemindert werden darf
                IF ("Item No." <> '') AND ("Batch Variant No." <> '') THEN
                    IF NOT lcu_BatchManagement.PackCheckStockBatchVar(Rec, xRec) THEN
                        ERROR('');

                VALIDATE("Qty. per Unit of Measure");

                IF Quantity > xRec.Quantity THEN
                    lcu_BatchManagement.OpenBatchVarStatusIfZero("Batch Variant No.")
                ELSE BEGIN
                    IF NOT lrc_PackOrderOutputItems.GET("Doc. No.", "Line No.") THEN
                        lrc_PackOrderOutputItems.INIT();
                    lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
                                                "Remaining Quantity (Base)" - lrc_PackOrderOutputItems."Remaining Quantity (Base)");
                END;

                // Zugeordnete Lagerorte aktualisieren
                IF ("Location Code" <> '') AND ("Batch Variant No." <> '') THEN
                    gcu_StockMgt.BatchVarFillLocations("Batch Variant No.", "Batch No.", "Item No.", "Location Code");

                CalcQuantity();

                // Menge darf nur dann manuell geändert werden, wenn der Pckauftrag kein Volgebeleg in der Planung ist
                IF CurrFieldNo = FIELDNO(Quantity) THEN BEGIN
                    lrc_PackOrderHeader."No." := "Doc. No.";
                    lrc_PackOrderHeader.IsNextDocPlaning(TRUE);
                END;

                // IF NOT gbn_IndirectCall THEN BEGIN
                //     IF lrc_PositionPlanningSetup.GET() THEN BEGIN
                //         IF lrc_PositionPlanningSetup."Update Assigned Document Lines" THEN BEGIN
                //             IF "Line No." <> 0 THEN BEGIN
                //                 MODIFY(TRUE);
                //                 lcu_PurchaseDispoMgt.UpdateAssignedLines(Rec, xRec, DATABASE::"Pack. Order Output Items", FIELDNO(Quantity));
                //             END;
                //         END;
                //     END;
                // END;


                "Quantity to Produce" := Quantity - "Quantity Produced";
                "Remaining Quantity" := Quantity - "Quantity Produced";

                VALIDATE("Qty. per Unit of Measure");

                IF Quantity <> 0 THEN
                    IF Quantity <> xRec.Quantity THEN BEGIN

                        //Menge aktualisieren
                        ldc_Factor := 0;
                        ldc_Qty := 0;
                        lrc_PackOrderInputItems.RESET();
                        lrc_PackOrderInputItems.SETRANGE("Doc. No.", "Doc. No.");
                        IF lrc_PackOrderInputItems.FIND('-') THEN
                            //RS Abfrage nur relevant bei Factor % in INPUTZEILE
                            //IF CONFIRM(AGILES_TEXT012Txt,FALSE) THEN
                            REPEAT
                                IF lrc_PackOrderInputItems."Factor %" <> 0 THEN BEGIN
                                    ldc_Factor := lrc_PackOrderInputItems."Factor %";
                                    IF "Qty. per Unit of Measure" <> 0 THEN
                                        IF lrc_PackOrderInputItems.Quantity = 0 THEN BEGIn
                                            ldc_Qty := ROUND((("Total Net Weight" / 100) * lrc_PackOrderInputItems."Factor %") / lrc_PackOrderInputItems."Net Weight", 1, '>');
                                            lrc_PackOrderInputItems.VALIDATE(Quantity, ldc_Qty);
                                            lrc_PackOrderInputItems.MODIFY();
                                        END ELSE BEGIN
                                            ldc_Qty := ROUND((("Total Net Weight" / 100) * lrc_PackOrderInputItems."Factor %") / lrc_PackOrderInputItems."Net Weight", 1, '>');
                                            lrc_PackOrderInputItems.VALIDATE(Quantity, ldc_Qty);
                                            lrc_PackOrderInputItems.MODIFY();
                                        END;
                                END;
                            UNTIL lrc_PackOrderInputItems.NEXT(1) = 0;
                        //Menge aktualisieren
                        ldc_Factor := 0;
                        ldc_Qty := 0;
                        ldc_Qty1 := 0;
                        lrc_PackOrderPackItems.RESET();
                        lrc_PackOrderPackItems.SETRANGE("Doc. No.", "Doc. No.");
                        IF lrc_PackOrderPackItems.FIND('-') THEN
                            IF CONFIRM(AGILES_TEXT013Txt, FALSE) THEN
                                REPEAT
                                    IF xRec.Quantity <> 0 THEN BEGIN
                                        ldc_Qty := (lrc_PackOrderPackItems.Quantity / xRec.Quantity);
                                        ldc_Qty1 := ldc_Qty * Quantity;
                                        lrc_PackOrderPackItems.VALIDATE(Quantity, ldc_Qty1);
                                        lrc_PackOrderPackItems.MODIFY();
                                    END;
                                UNTIL lrc_PackOrderPackItems.NEXT(1) = 0;
                    END;

                //Leergutmenge einpflegen
                IF "Empties Item No." <> '' THEN
                    VALIDATE("Empties Quantity", Quantity);
            end;
        }
        field(35; "Quantity to Produce"; Decimal)
        {
            Caption = 'Quantity to Produce';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF ("Quantity to Produce" < 0) THEN BEGIN
                    IF (ABS("Quantity to Produce") > "Quantity Produced") THEN
                        // Sie können nicht mehr stornieren %1 als gebucht ist %2!
                        ERROR(AGILES_TEXT006Txt, "Quantity to Produce", "Quantity Produced");
                END ELSE
                    IF ("Quantity to Produce" * Quantity < 0) OR
                       (ABS("Quantity to Produce") > ABS("Remaining Quantity")) OR
                       (Quantity * "Remaining Quantity" < 0) THEN
                        // Die zu packende Menge %1 darf die Restmenge %2 nicht übersteigen!
                        ERROR(AGILES_TEXT005Txt, "Quantity to Produce", "Remaining Quantity");

                VALIDATE("Qty. per Unit of Measure");

                IF "Quantity to Produce" = 0 THEN BEGIN
                    VALIDATE("Copies Label (Unit)", 0);
                    VALIDATE("Copies Label (PU)", 0);
                    VALIDATE("Copies Label (TU)", 0);
                END ELSE BEGIN
                    VALIDATE("Copies Label (Unit)", ABS("Quantity to Produce"));
                    VALIDATE("Copies Label (PU)", ABS("Quantity to Produce") * "Qty. (PU) per Unit of Measure");
                    IF "Qty. (Unit) per Transp.(TU)" = 0 THEN
                        VALIDATE("Copies Label (TU)", 0)
                    ELSE
                        VALIDATE("Copies Label (TU)", ABS("Quantity to Produce") / "Qty. (Unit) per Transp.(TU)");

                END;
            end;
        }
        field(36; "Quantity Produced"; Decimal)
        {
            Caption = 'Quantity Produced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(37; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(43; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                "Quantity to Produce (Base)" := "Quantity to Produce" * "Qty. per Unit of Measure";
                "Quantity Produced (Base)" := "Quantity Produced" * "Qty. per Unit of Measure";
                "Remaining Quantity (Base)" := "Remaining Quantity" * "Qty. per Unit of Measure";
                IF (xRec."Qty. per Unit of Measure" <> "Qty. per Unit of Measure") THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Qty. per Unit of Measure"), 1, 100), Rec);
                CalcQuantity();
            end;
        }
        field(44; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(45; "Quantity to Produce (Base)"; Decimal)
        {
            Caption = 'Quantity to Produce (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(46; "Quantity Produced (Base)"; Decimal)
        {
            Caption = 'Quantity Produced (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(47; "Remaining Quantity (Base)"; Decimal)
        {
            Caption = 'Remaining Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(55; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';

            trigger OnValidate()
            begin
                "Total Net Weight" := "Net Weight" * Quantity;


                VALIDATE("Market Unit Cost (Price Base)");

            end;
        }
        field(56; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
        }
        field(57; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';

            trigger OnValidate()
            begin
                "Total Gross Weight" := "Gross Weight" * Quantity;


                VALIDATE("Market Unit Cost (Price Base)");

            end;
        }
        field(58; "Total Gross Weight"; Decimal)
        {
            Caption = 'Total Gross Weight';
        }
        field(60; "Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin

                IF ("Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 0, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 1");

                IF "Info 1" <> xRec."Info 1" THEN
                    lcu_PalletManagement.ActualFieldsFromPackOutputLine(copystr(FIELDCAPTION("Info 1"), 1, 100), Rec, xRec);

            end;
        }
        field(61; "Info 2"; Code[50])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF ("Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 1, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 2");

                IF "Info 2" <> xRec."Info 2" THEN
                    lcu_PalletManagement.ActualFieldsFromPackOutputLine(copystr(FIELDCAPTION("Info 2"), 1, 100), Rec, xRec)
            end;
        }
        field(62; "Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin

                IF ("Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 2, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 3");

                IF "Info 3" <> xRec."Info 3" THEn
                    lcu_PalletManagement.ActualFieldsFromPackOutputLine(copystr(FIELDCAPTION("Info 3"), 1, 100), Rec, xRec)
            end;
        }
        field(63; "Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF ("Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 3, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 4");

                IF "Info 4" <> xRec."Info 4" THEN
                    lcu_PalletManagement.ActualFieldsFromPackOutputLine(copystr(FIELDCAPTION("Info 4"), 1, 100), Rec, xRec)
            end;
        }
        field(65; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Lot No." <> xRec."Lot No." THEN
                    lcu_PalletManagement.ActualFieldsFromPackOutputLine(copystr(FIELDCAPTION("Lot No."), 1, 100), Rec, xRec)
            end;
        }
        field(67; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Expiry Date" <> xRec."Expiry Date" THEN
                    lcu_PalletManagement.ActualFieldsFromPackOutputLine(Copystr(FIELDCAPTION("Expiry Date"), 1, 100), Rec, xRec)
            end;
        }
        field(68; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';

            trigger OnValidate()
            var
            //lcu_RecipePackingManagement: Codeunit "5110700"; TODO: receipt
            begin
                //lcu_RecipePackingManagement.ActualLotNoInActualLine(Rec);
            end;
        }
        field(69; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(80; "Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                IF CurrFieldNo = FIELDNO("Item Attribute 5") THEN
                    gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Item Attribute 5"));
            end;
        }
        field(82; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(85; "Item Typ"; Option)
        {
            Caption = 'Item Typ';
            Description = 'Standard,Batch Item,Empties Item';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material";
        }
        field(87; "Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));

            trigger OnValidate()
            begin
                IF "Empties Quantity" = 0 THEN
                    "Empties Quantity" := 1;
            end;
        }
        field(88; "Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            DecimalPlaces = 0 : 5;
            Description = 'LVW';

            trigger OnValidate()
            var
                lcu_EmptiesMgt: Codeunit "POI EIM Empties Item Mgt";
                ldc_EmptiesInputQuantity: Decimal;
                ldc_EmptiesOutputQuantity: Decimal;
            begin
                //Leergutzeile anlegen
                IF "Empties Quantity" <> 0 THEN BEGIN
                    //RS Prüfung, ob EPS Menge in Inputzeilen ausreichend
                    lrc_EmptiesPackInputLine.SETRANGE("Doc. No.", "Doc. No.");
                    lrc_EmptiesPackInputLine.SETRANGE("Item No.", "Empties Item No.");
                    IF lrc_EmptiesPackInputLine.FINDSET() THEN
                        REPEAT
                            ldc_EmptiesInputQuantity := ldc_EmptiesInputQuantity + lrc_EmptiesPackInputLine.Quantity;
                        UNTIL lrc_EmptiesPackInputLine.NEXT() = 0;
                    lrc_EmptiesPackOutputLine.SETRANGE("Doc. No.", "Doc. No.");
                    lrc_EmptiesPackOutputLine.SETRANGE("Item No.", "Item No.");
                    //170919 rs
                    //lrc_EmptiesPackOutputLine.SETRANGE("Item Attribute 6", Rec."Item Attribute 6");
                    //170919 rs.e
                    lrc_EmptiesPackOutputLine.SETFILTER("Line No.", '<>%1', "Line No.");
                    IF lrc_EmptiesPackOutputLine.FINDSET() THEN
                        REPEAT
                            ldc_EmptiesOutputQuantity := ldc_EmptiesOutputQuantity + lrc_EmptiesPackOutputLine.Quantity;
                        UNTIL lrc_EmptiesPackOutputLine.NEXT() = 0;
                    ldc_EmptiesOutputQuantity := ldc_EmptiesOutputQuantity + "Empties Quantity";
                    // IF ldc_EmptiesOutputQuantity > ldc_EmptiesInputQuantity THEN
                    //     ERROR('Bitte passen Sie zuerst die Input-Menge für %1 an', "Item Attribute 6");
                    //Ende Prüfung EPS Menge in Inputzeilen

                    //Anlegen Leergutzeile
                    IF "Empties Attached Line No." = 0 THEN BEGIN
                        lcu_EmptiesMgt.PackOutputAttachEmptiesLine(Rec);
                        "Empties Attached Line No." := "Line No." + 100;
                    END ELSE BEGIN //Empties Attached Line No. <> 0, nur Anpassung Menge
                        IF Rec."Empties Quantity" > xRec."Empties Quantity" THEN BEGIN //Leergutmenge erhöht
                                                                                       //Prüfung ob EPS Menge in Inputzeilen ausreichend
                            lrc_EmptiesPackInputLine.RESET();
                            lrc_EmptiesPackInputLine.SETRANGE("Doc. No.", "Doc. No.");
                            lrc_EmptiesPackInputLine.SETRANGE("Item No.", "Empties Item No.");
                            IF lrc_EmptiesPackInputLine.FINDSET() THEN
                                REPEAT
                                    ldc_EmptiesInputQuantity := ldc_EmptiesInputQuantity + lrc_EmptiesPackInputLine.Quantity;
                                UNTIL lrc_EmptiesPackInputLine.NEXT() = 0;
                            lrc_EmptiesPackOutputLine.RESET();
                            lrc_EmptiesPackOutputLine.SETRANGE("Doc. No.", "Doc. No.");
                            lrc_EmptiesPackOutputLine.SETRANGE("Item No.", "Item No.");
                            lrc_EmptiesPackOutputLine.SETFILTER("Line No.", '<>%1', "Line No.");
                            IF lrc_EmptiesPackOutputLine.FINDSET() THEN BEGIN
                                REPEAT
                                    ldc_EmptiesOutputQuantity := ldc_EmptiesOutputQuantity + lrc_EmptiesPackOutputLine.Quantity;
                                UNTIL lrc_EmptiesPackOutputLine.NEXT() = 0;
                                ldc_EmptiesOutputQuantity := ldc_EmptiesOutputQuantity + "Empties Quantity";
                            END;
                            ldc_EmptiesOutputQuantity := ldc_EmptiesOutputQuantity + "Empties Quantity";
                            // IF ldc_EmptiesOutputQuantity > ldc_EmptiesInputQuantity THEN
                            //     ERROR('Bitte passen Sie zuerst die Input-Menge für %1 an', "Item Attribute 6");
                        END; //Ende Prüfung EPS Menge in In- und Outputzeilen

                        lrc_EmptiesPackOutputLine.RESET();
                        lrc_EmptiesPackOutputLine.SETRANGE("Doc. No.", "Doc. No.");
                        lrc_EmptiesPackOutputLine.SETRANGE("Line No.", "Empties Attached Line No.");
                        IF lrc_EmptiesPackOutputLine.FINDSET(TRUE, FALSE) THEN BEGIN
                            lrc_EmptiesPackOutputLine.VALIDATE(Quantity, Rec."Empties Quantity");
                            lrc_EmptiesPackOutputLine.MODIFY();
                        END;
                    END;
                END;
            end;
        }
        field(120; "Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
        }
        field(121; "Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';
        }
        field(131; "Sales Green Point Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Green Point Amount (LCY)';
        }
        field(138; "Sales Discount Amt. (LCY)"; Decimal)
        {
            Caption = 'Sales Discount Amt. (LCY)';
        }
        field(140; "Sales Freight Costs Amt. (LCY)"; Decimal)
        {
            Caption = 'Sales Freight Costs Amt. (LCY)';
        }
        field(150; "Unit Cost Price (Input)"; Decimal)
        {
            Caption = 'Unit Cost Price (Input)';
        }
        field(155; "Market Cost Price (Input)"; Decimal)
        {
            Caption = 'Market Cost Price (Input)';
        }
        field(160; "Reference Unit for Pack. Qty."; Code[10])
        {
            Caption = 'Reference Unit for Pack. Qty.';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
            begin
                IF "Reference Unit for Pack. Qty." = '' THEN
                    "Reference Unit for Pack. Qty." := "Base Unit of Measure (BU)"
                ELSE BEGIN
                    lrc_UnitofMeasure.GET("Unit of Measure Code");
                    IF ("Reference Unit for Pack. Qty." <> lrc_UnitofMeasure."POI Base Unit of Measure (BU)") AND
                       ("Reference Unit for Pack. Qty." <> lrc_UnitofMeasure."POI Packing Unit of Meas (PU)") AND
                       ("Reference Unit for Pack. Qty." <> lrc_UnitofMeasure."POI Content Unit of Meas (CP)") THEN
                        // Die Referenzeinheit ist nicht in der zu packenden Einheit enthalten!
                        ERROR(AGILES_TEXT007Txt);
                END;
            end;
        }
        field(198; Comment; Boolean)
        {
            CalcFormula = Exist ("POI Pack. Order Comment" WHERE("Doc. No." = FIELD("Doc. No."),
                                                             "Doc. Line No. Output" = FIELD("Line No."),
                                                             Type = CONST("Output Item"),
                                                             "Source Line No." = FIELD("Line No.")));
            Caption = 'Comment';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(200; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Posted';
            OptionMembers = Offen,Gebucht;
        }
        field(201; "Batch Variant generated"; Boolean)
        {
            Caption = 'Batch Variant generated';
        }
        field(280; "Amount Cost Calculation (LCY)"; Decimal)
        {
            Caption = 'Amount Cost Calculation (LCY)';
        }
        field(281; "Amount Posted Costs (LCY)"; Decimal)
        {
            Caption = 'Amount Posted Costs (LCY)';
        }
        field(282; "Amount Chargeable Costs (LCY)"; Decimal)
        {
            Caption = 'Amount Chargeable Costs (LCY)';
        }
        field(298; "Sales Gross Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Gross Amount (LCY)';
        }
        field(299; "Sales Net Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Net Amount (LCY)';
        }
        field(300; "Sales Net Net Amount (LCY)"; Decimal)
        {
            Caption = 'Sales Net Net Amount (LCY)';
        }
        field(301; "Sales Qty. (Base)"; Decimal)
        {
            Caption = 'Sales Qty. (Base)';
        }
        field(302; "Sales Qty."; Decimal)
        {
            Caption = 'Sales Qty.';
        }
        field(310; Einkaufsbetrag; Decimal)
        {
            Caption = 'Einkaufsbetrag';
        }
        field(312; Einstandsbetrag; Decimal)
        {
            Caption = 'Einstandsbetrag';
        }
        field(350; "Feature Level"; Option)
        {
            Caption = 'Feature Level';
            OptionCaption = 'Item,Batch Variant';
            OptionMembers = Item,"Batch Variant";
        }
        field(401; "Posted At"; Date)
        {
            Caption = 'Posted At';
        }
        field(402; "Posted By Userid"; Code[20])
        {
            Caption = 'Posted By Userid';
        }
        field(500; "Output (Filler)"; Code[8])
        {
            Caption = 'Output (Filler)';
        }
        field(600; "Cross-Reference No. (Unit)"; Code[20])
        {
            Caption = 'Cross-Reference No. (Unit)';
        }
        field(601; "Cross-Reference No. (PU)"; Code[20])
        {
            Caption = 'Cross-Reference No. (PU)';
        }
        field(602; "Cross-Reference No. (TU)"; Code[20])
        {
            Caption = 'Cross-Reference No. (TU)';
        }
        field(610; "Label (Unit)"; Code[10])
        {
            Caption = 'Label (Unit)';
            //TableRelation = Label.Code;
        }
        field(611; "Label (PU)"; Code[10])
        {
            Caption = 'Label (PU)';
            //TableRelation = Label.Code;
        }
        field(612; "Label (TU)"; Code[10])
        {
            Caption = 'Label (TU)';
            //TableRelation = Label.Code;
        }
        field(620; "Copies Label (Unit)"; Decimal)
        {
            Caption = 'Copies Label (Unit)';
            DecimalPlaces = 0 : 0;
        }
        field(621; "Copies Label (PU)"; Decimal)
        {
            Caption = 'Copies Label (PU)';
            DecimalPlaces = 0 : 0;
        }
        field(622; "Copies Label (TU)"; Decimal)
        {
            Caption = 'Copies Label (TU)';
            DecimalPlaces = 0 : 0;
        }
        field(800; Inventory; Decimal)
        {
            CalcFormula = Sum ("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "POI Batch Variant No." = FIELD("Batch Variant Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(900; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(901; "Batch Variant Filter"; Code[20])
        {
            Caption = 'Batch Variant Filter';
            FieldClass = FlowFilter;
            TableRelation = "POI Batch Variant";
        }
        field(50000; "Empties Attached Line No."; Integer)
        {
            Description = 'RS Verknüpfung mit Leergutzeile';
        }
        field(50010; "Attached to Line No."; Integer)
        {
            Description = 'RS Verknüpfung Leergutzeile mit Artikelzeil';
        }
        field(55020; "Expected Capacity Need"; Decimal)
        {
            Caption = 'Expected Capacity Need';
            DecimalPlaces = 0 : 5;
            Description = 'CCB01';
        }
        field(55021; "Resource Shift Code"; Code[10])
        {
            Caption = 'Resource Shift Code';
            Description = 'CCB01';
            //TableRelation = Table55021;
        }
        field(55022; "Packing Date"; Date)
        {
            CaptionClass = '5110700,1,2';
            Caption = 'Packing Date';
            Description = 'CCB01';
        }
        field(55023; "No. of Operators required"; Integer)
        {
            BlankZero = true;
            Caption = 'No. of Operators required';
            Description = 'CCB01';
            MinValue = 0;
        }
        field(55024; "No. of Operators allocated"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count ("POI Pack. Order Input Costs" WHERE("Doc. No." = FIELD("Doc. No."),
                                                                 "Doc. Line No. Output" = FIELD("Line No."),
                                                                 Type = CONST(Resource)));
            Caption = 'No. of Operators required';
            Description = 'CCB01';
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(5110310; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5110311; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(5110312; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(5110313; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(5110315; "Waste Disposal Duty"; Option)
        {
            Caption = 'Waste Disposal Duty';
            Description = 'DSD';
            OptionCaption = ' ,DSD Duty,ARA Duty';
            OptionMembers = " ","DSD Duty","ARA Duty";
        }
        field(5110316; "Waste Disposal Payment Thru"; Option)
        {
            Caption = 'Waste Disposal Payment Thru';
            Description = 'DSD';
            OptionCaption = 'Us,Vendor';
            OptionMembers = Us,Vendor;
        }
        field(5110324; "Batch Var. Detail Entry No."; Integer)
        {
            Caption = 'Batch Var. Detail Entry No.';
        }
        field(5110360; "Location Reference No."; Code[20])
        {
            Caption = 'Location Reference No.';
        }
        field(5110361; "Internal Reference No."; Code[20])
        {
            Caption = 'Interne Referenznr.';
        }
        field(5110370; "Price Unit of Measure"; Code[10])
        {
            Caption = 'Price Unit of Measure';
            Description = 'MEK';
            TableRelation = "Unit of Measure";
        }
        field(5110380; "Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin

                IF (xRec."Base Unit of Measure (BU)" <> "Base Unit of Measure (BU)") THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Base Unit of Measure (BU)"), 1, 100), Rec);

            end;
        }
        field(5110381; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            Description = 'DSD';
            TableRelation = "Unit of Measure" WHERE("POI Is Packing Unit of Measure" = CONST(true));

            trigger OnValidate()
            begin
                IF "Packing Unit of Measure (PU)" <> xRec."Packing Unit of Measure (PU)" THEN BEGIN
                    IF "Packing Unit of Measure (PU)" <> '' THEN
                        FillCrossReferenceNo(FIELDNO("Packing Unit of Measure (PU)"), Rec);

                    VALIDATE("Market Unit Cost (Price Base)");
                END;
            end;
        }
        field(5110382; "Qty. (PU) per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. (PU) per Unit of Measure';

            trigger OnValidate()
            begin
                VALIDATE(Quantity);
            end;
        }
        field(5110383; "Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';

            trigger OnValidate()
            begin
                VALIDATE(Quantity);
            end;
        }
        field(5110384; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin

                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                // IF CurrFieldNo = FIELDNO("Transport Unit of Measure (TU)") THEN BEGIN  //TODO: Attribute
                //     gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Transport Unit of Measure (TU)"));
                // END;


                IF "Transport Unit of Measure (TU)" <> xRec."Transport Unit of Measure (TU)" THEN BEGIN
                    IF "Transport Unit of Measure (TU)" <> '' THEN
                        FillCrossReferenceNo(FIELDNO("Transport Unit of Measure (TU)"), Rec);
                    VALIDATE("Market Unit Cost (Price Base)");
                END;

                IF ((xRec."Transport Unit of Measure (TU)" <> "Transport Unit of Measure (TU)")) AND ("Transport Unit of Measure (TU)" <> '') THEN
                    lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO(copystr(FIELDCAPTION("Transport Unit of Measure (TU)"), 1, 100), Rec);


            end;
        }
        field(5110385; "Qty. (Unit) per Transp.(TU)"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transp.(TU)';

            trigger OnValidate()
            begin
                // Prüfen, ob Merkmal generell geändert werdendarf
                // Pflichtmerkmal darf nicht geändert werden, wenn Menge <> 0
                // IF CurrFieldNo = FIELDNO("Qty. (Unit) per Transp.(TU)") THEN BEGIN  //TODO: Attribute prüfen
                //     gcu_ItemAttributeMgt.PackingLineCheckOnValidate(Rec, xRec, FIELDNO("Qty. (Unit) per Transp.(TU)"));
                // END;

                VALIDATE(Quantity);
            end;
        }
        field(5110386; "Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';

            trigger OnValidate()
            begin
                VALIDATE(Quantity);
            end;
        }
        field(5110387; "Collo Unit of Measure (CU)"; Code[10])
        {
            Caption = 'Collo Unit of Measure (CU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Collo Unit of Measure" = CONST(true));
        }
        field(5110388; "Content Unit of Measure (COU)"; Code[10])
        {
            Caption = 'Content Unit of Measure (COU)';
            TableRelation = "Unit of Measure";
        }
        field(5110390; "Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            Description = 'MEK';
            // TableRelation = "Price Base".Code WHERE("Purch./Sales Price Calc."=CONST("Purch. Price"),
            //                                          Blocked=CONST(No));

            trigger OnValidate()
            var
            //lcu_RecipePackingManagement: Codeunit "5110700";
            begin

                //"Price Unit of Measure" := lcu_RecipePackingManagement.PurchLineGetPriceUnit(Rec);

            end;
        }
        field(5110397; "Qty. (COU) per Pack. Unit (PU)"; Decimal)
        {
            Caption = 'Qty. (COU) per Pack. Unit (PU)';
        }
        field(5110408; "Market Unit Cost (Basis) (LCY)"; Decimal)
        {
            Caption = 'Market Unit Cost (Basis) (LCY)';
            Description = 'MEK';
        }
        field(5110409; "Market Unit Cost (Price Base)"; Decimal)
        {
            Caption = 'Market Unit Cost (Price Base)';
            Description = 'MEK';

            trigger OnValidate()
            var
                //lrc_PriceCalculation: Record "5110320";
                lop_Weight: Option " ",Netto,Brutto,,,,"Anbruch Netto wiegen";
            //lcu_RecipePackingManagement: Codeunit "5110700";
            begin

                // Keine Änderung falls Lieferung bereits erfolgt
                IF CurrFieldNo = FIELDNO("Market Unit Cost (Price Base)") THEN
                    IF "Quantity Produced" <> 0 THEN
                        // Es sind bereits Mengen produziert. Möchten Sie trotzdem ändern?
                        IF NOT CONFIRM(AGILES_TEXT008Txt) THEN
                            ERROR('');


                // Umrechnen in die Basiseinheit über die Einkaufseinheit

                // lrc_PriceCalculation.Reset();
                // lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.", lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
                // lrc_PriceCalculation.SETRANGE(Code, "Price Base (Purch. Price)");
                // IF lrc_PriceCalculation.FIND('-') THEN
                //     lop_Weight := lrc_PriceCalculation.Weight
                // ELSE
                //     lop_Weight := lop_Weight::" ";

                // "Market Unit Cost (Basis) (LCY)" := lcu_RecipePackingManagement.PurchCalcUnitPrice(Rec, TRUE);
                IF "Qty. per Unit of Measure" <> 0 THEN
                    CASE lop_Weight OF
                        lop_Weight::" ":
                            "Market Unit Cost (Basis) (LCY)" := "Market Unit Cost (Basis) (LCY)" / "Qty. per Unit of Measure";
                        lop_Weight::Netto:
                            IF "Net Weight" <> 0 THEN
                                "Market Unit Cost (Basis) (LCY)" := "Market Unit Cost (Basis) (LCY)" / "Net Weight"
                            ELSE
                                "Market Unit Cost (Basis) (LCY)" := 0;
                        lop_Weight::Brutto:
                            IF "Gross Weight" <> 0 THEN
                                "Market Unit Cost (Basis) (LCY)" := "Market Unit Cost (Basis) (LCY)" / "Gross Weight"
                            ELSE
                                "Market Unit Cost (Basis) (LCY)" := 0;
                    END
                ELSE
                    "Market Unit Cost (Basis) (LCY)" := "Market Unit Cost (Basis) (LCY)";

                // Item Ledger Entry Einträge suchen
                IF "Quantity Produced" <> 0 THEN BEGIN
                    lrc_ItemLedgerEntry.SETCURRENTKEY("Item No.", "Posting Date", "Entry Type", "POI Source Doc. Type", "Location Code", "Variant Code");
                    lrc_ItemLedgerEntry.SETRANGE("Entry Type", lrc_ItemLedgerEntry."Entry Type"::"Positive Adjmt.");
                    lrc_ItemLedgerEntry.SETRANGE("Item No.", "Item No.");
                    lrc_ItemLedgerEntry.SETRANGE("POI Source Doc. Type", lrc_ItemLedgerEntry."POI Source Doc. Type"::"Output Packing Order");
                    lrc_ItemLedgerEntry.SETRANGE("POI Source Doc. No.", "Doc. No.");
                    lrc_ItemLedgerEntry.SETRANGE("POI Source Doc. Line No.", "Line No.");
                    IF lrc_ItemLedgerEntry.FIND('-') THEN
                        REPEAT
                            lrc_ItemLedgerEntry."POI Market Purch. Price" := "Market Unit Cost (Basis) (LCY)";
                            lrc_ItemLedgerEntry."POI Market Purch. Amount" := "Market Unit Cost (Basis) (LCY)" *
                                                                          lrc_ItemLedgerEntry.Quantity;
                            lrc_ItemLedgerEntry.MODIFY();
                        UNTIL lrc_ItemLedgerEntry.NEXT() = 0
                    ELSE
                        // Artikelposten nicht gefunden!
                        ERROR(AGILES_TEXT009Txt);
                END;

            end;
        }
        field(5110460; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
        }
        field(5110898; "Spectrum Caliber A-Goods"; Code[50])
        {
            Caption = 'Spectrum Caliber A-Goods';
            Description = 'MEV';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
            //lcu_RecipePackingManagement: Codeunit "5110700";
            begin
                // IF "Spectrum Caliber A-Goods" <> xRec."Spectrum Caliber A-Goods" THEN
                //     lcu_RecipePackingManagement.CalcSpektrumQuantityOutputLine("Doc. No.", "Line No.", Rec);

            end;
        }
        field(5110899; "Exp. Quantity (Base) Spectrum"; Decimal)
        {
            Caption = 'Expected Quantity (Base) Spectrum';
            DecimalPlaces = 0 : 5;
            Description = 'MEV';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Doc. No.", "Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Sales Net Net Amount (LCY)", "Total Net Weight", "Total Gross Weight", "Amount Cost Calculation (LCY)", "Amount Posted Costs (LCY)", "Amount Chargeable Costs (LCY)", Quantity, "Quantity Produced", "Quantity (TU)", "Quantity (PU)", "Remaining Quantity", "Remaining Quantity (Base)";
        }
        key(Key2; "Item No.", "Variant Code", "Batch Variant No.", "Location Code")
        {
            SumIndexFields = "Quantity (Base)", "Quantity Produced (Base)", "Remaining Quantity (Base)", "Sales Net Net Amount (LCY)", "Remaining Quantity";
        }
        key(Key3; "Type of Packing Product")
        {
            SumIndexFields = "Quantity (Base)", "Quantity Produced (Base)", "Remaining Quantity (Base)", "Remaining Quantity";
        }
        key(Key4; "Type of Packing Product", "Item No.")
        {
        }
        key(Key5; "Type of Packing Product", "Packing Date", "Resource Shift Code")
        {
            SumIndexFields = "Expected Capacity Need";
        }
        key(Key6; "Resource Shift Code")
        {
        }
        key(Key7; "Master Batch No.", "Batch No.", "Batch Variant No.")
        {
        }
        key(Key8; "Batch No.")
        {
        }
        key(Key9; "Batch Variant No.")
        {
        }
        key(Key10; "Doc. No.", "Item No.")
        {
        }
        key(Key11; "Batch Variant No.", "Location Code")
        {
            SumIndexFields = "Quantity (Base)", "Quantity Produced (Base)", "Remaining Quantity (Base)", "Sales Net Net Amount (LCY)", "Remaining Quantity";
        }
        key(Key12; "Unit of Measure Code", "Item No.")
        {
        }
        key(Key13; "Item No.", "Variant Code", "Batch Variant No.", "Location Code", "Remaining Quantity")
        {
        }
        key(Key14; "Location Code", "Batch Variant No.", "Expected Receipt Date")
        {
            SumIndexFields = "Quantity (Base)", "Quantity Produced (Base)", "Remaining Quantity (Base)", "Remaining Quantity";
        }
    }

    trigger OnDelete()
    var
        lrc_PackOrderComment: Record "POI Pack. Order Comment";
        lrc_BatchVariant: Record "POI Batch Variant";
        //lrc_FeatureAssortmentCustLine: Record "5110359";
        //lrc_Dispolines: Record "POI Dispolines";
        //lrc_Dispolines2: Record "POI Dispolines";
        lrc_PackOrderOutputLine: Record "POI Pack. Order Output Items";
        lcu_BatchMgt: Codeunit "POI BAM Batch Management";
        //lcu_PurchaseDispoMgt: Codeunit "5110380";
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    //lcu_Purchase: Codeunit "5110323";
    begin
        TESTFIELD("Quantity Produced", 0);

        //RS Prüfung ob verbundene Leergutzeile
        IF (("Item Typ" = "Item Typ"::"Empties Item") AND ("Attached to Line No." <> 0)) THEN
            ERROR('Sie können die Leergutzeile nicht löschen, bitte löschen sie die dazugehörige Artikelzeile oder den Verpackungscode');

        lrc_PackOrderComment.RESET();
        lrc_PackOrderComment.SETRANGE("Doc. No.", "Doc. No.");
        lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", "Line No.");
        lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Output Item");
        lrc_PackOrderComment.SETRANGE("Source Line No.", "Line No.");
        IF lrc_PackOrderComment.FIND('-') THEN
            lrc_PackOrderComment.DELETEALL(TRUE);

        //RS zugehörige Leergutzeile löschen
        IF "Empties Attached Line No." <> 0 THEN BEGIN
            lrc_PackOrderOutputLine.GET("Doc. No.", "Empties Attached Line No.");
            lrc_PackOrderOutputLine.DELETE(FALSE);
        END;


        lcu_PalletManagement.ErrorIfIncomingPalletLineEx_PO('', Rec);


        IF ("Item No." <> '') AND ("Batch Variant No." <> '') THEN BEGIN
            IF lcu_BatchMgt.BatchVarCheckIfInOpenDoc("Item No.", "Batch Variant No.", '') = TRUE THEN
                // Löschung nicht zulässig, Positionsvariante %1 ist in Belegen zugeordnet!
                ERROR(AGILES_TEXT001Txt, "Batch Variant No.");
            IF lrc_BatchVariant.GET("Batch Variant No.") THEN
                IF "Quantity Produced" = 0 THEN
                    lrc_BatchVariant.DELETE(TRUE);
        END;

        // IF ("Master Batch No." <> '') AND //TODO: assortments
        //    ("Batch No." <> '') AND
        //    ("Batch Variant No." <> '') THEN BEGIN
        //     lrc_FeatureAssortmentCustLine.Reset();
        //     lrc_FeatureAssortmentCustLine.SETCURRENTKEY("Master Batch No.", "Batch No.", "Batch Variant No.");
        //     lrc_FeatureAssortmentCustLine.SETRANGE("Master Batch No.", "Master Batch No.");
        //     lrc_FeatureAssortmentCustLine.SETRANGE("Batch No.", "Batch No.");
        //     lrc_FeatureAssortmentCustLine.SETRANGE("Batch Variant No.", "Batch Variant No.");
        //     IF lrc_FeatureAssortmentCustLine.FIND('-') THEN BEGIN
        //         REPEAT
        //             IF lrc_FeatureAssortmentCustLine."Document No." = '' THEN BEGIN
        //                 lrc_FeatureAssortmentCustLine.DELETE(TRUE);
        //             END;
        //         UNTIL lrc_FeatureAssortmentCustLine.NEXT() = 0;
        //     END;
        // END;

        // lcu_PurchaseDispoMgt.RebuildDispolineOnPackOutput(Rec);

        // lrc_Dispolines.Reset();
        // lrc_Dispolines.SETCURRENTKEY( "Document Type","Document No.","Document Line Line No.","Line No." );
        // lrc_Dispolines.SETRANGE( "Document Type", lrc_Dispolines."Document Type"::"Packing Order" );
        // lrc_Dispolines.SETRANGE( "Document No.", "Doc. No." );
        // lrc_Dispolines.SETRANGE( "Document Line Line No.", "Line No." );
        // IF lrc_Dispolines.FIND('-') THEN BEGIN
        //   // lrc_Dispolines.DELETEALL( TRUE );
        //   IF "Quantity Produced" <> 0 THEN BEGIN
        //     lrc_Dispolines.DELETEALL(TRUE);
        //   END ELSE BEGIN
        //     REPEAT
        //       IF lrc_Dispolines."Created From Dispoline" <> 0D THEN BEGIN

        // lrc_Dispolines2.Reset();
        // lrc_Dispolines2.INIT();
        // lrc_Dispolines2."Document Type" := lrc_Dispolines2."Document Type"::Position;
        // lrc_Dispolines2."Document No." := lrc_Dispolines."Batch Variant No.";
        // lrc_Dispolines2."Document Line Line No." := 0;
        // lrc_Dispolines2."Line No." := lrc_Dispolines."Line No.";
        // lrc_Dispolines2.Date := lrc_Dispolines.Date;
        // lrc_Dispolines2.Quantity := lrc_Dispolines.Quantity;
        // lrc_Dispolines2."Licence Code" := lrc_Dispolines."Licence Code";
        // lrc_Dispolines2.Description := lrc_Dispolines.Description;
        // lrc_Dispolines2.Datetext := lrc_Dispolines.Datetext;
        // lrc_Dispolines2."Unit of Measure Code" := lrc_Dispolines."Unit of Measure Code";
        // lrc_Dispolines2.Description := lrc_Dispolines.Description;
        // lrc_Dispolines2."Batch No." := lrc_Dispolines."Batch No.";
        // lrc_Dispolines2."Batch Variant No." := lrc_Dispolines."Batch Variant No.";
        // lrc_Dispolines2."Source No" := lrc_Dispolines."Source No";
        // // PVP 002 00000000.s
        // lrc_Dispolines2."Source Type" := lrc_Dispolines."Source Type";
        // lrc_Dispolines2."Customer Group" := lrc_Dispolines."Customer Group";
        // // PVP 002 00000000.e
        // // PVP 003 00000000.s
        // lrc_Dispolines2."Currency Code" := lrc_Dispolines."Currency Code";
        // IF lrc_Dispolines2."Source Type" = lrc_Dispolines2."Source Type"::"Customer Group" THEN BEGIN
        //   lrc_Dispolines2."Source No" := lrc_Dispolines."Customer Group"
        // END;
        // // PVP 003 00000000.e
        // lrc_Dispolines2."Gen. Bus. Posting Group" := lrc_Dispolines."Gen. Bus. Posting Group";
        // lrc_Dispolines2."Planning Customer" := lrc_Dispolines."Planning Customer";
        // lrc_Dispolines2."Price Base (Sales Price)" := lrc_Dispolines."Price Base (Sales Price)";
        // lrc_Dispolines2."Sales Price (Price Base)" := lrc_Dispolines."Sales Price (Price Base)";
        // lrc_Dispolines2."Created From Dispoline" := 0D;
        // lrc_Dispolines2."Planning Flag" := lrc_Dispolines."Planning Flag";
        // lrc_Dispolines2."Loading Confirmed" := lrc_Dispolines."Loading Confirmed";
        // lrc_Dispolines2."Quantity Zero Confirmed" := lrc_Dispolines."Quantity Zero Confirmed";
        // lrc_Dispolines2."Disposition For Week" := lrc_Dispolines."Disposition For Week";
        // lrc_Dispolines2."Transport Unit of Measure (TU)" := lrc_Dispolines."Transport Unit of Measure (TU)";
        // // PVP 004 00000000.s
        // lrc_Dispolines2."Original Planning Line Qty" := lrc_Dispolines."Original Planning Line Qty";
        // // PVP 004 00000000.e
        // // PVP 005 00000000.s
        // lrc_Dispolines2."Nos. Released as Print" := lrc_Dispolines."Nos. Released as Print";
        // lrc_Dispolines2."Last Date of Print" := lrc_Dispolines."Last Date of Print";
        // lrc_Dispolines2."Nos. Released as Fax" := lrc_Dispolines."Nos. Released as Fax";
        // lrc_Dispolines2."Last Date of Fax" := lrc_Dispolines."Last Date of Fax";
        // lrc_Dispolines2."Nos. Released as Mail" := lrc_Dispolines."Nos. Released as Mail";
        // lrc_Dispolines2."Last Date of Mail" := lrc_Dispolines."Last Date of Mail";
        // // PVP 005 00000000.e
        // // DMG 001 DMG50027.s
        // lrc_Dispolines2."Maturation Location" := lrc_Dispolines."Maturation Location";
        // lrc_Dispolines2."Code Description" := lrc_Dispolines."Code Description";
        // lrc_Dispolines2."Source Name" := lrc_Dispolines."Source Name";
        // lrc_Dispolines2."No Document Generation" := lrc_Dispolines."No Document Generation";
        // lrc_Dispolines2."Qty. (Unit) per Transp. Unit" := lrc_Dispolines."Qty. (Unit) per Transp. Unit";
        // lrc_Dispolines2."Quantity (TU)" := lrc_Dispolines."Quantity (TU)";
        // lrc_Dispolines2.Status := lrc_Dispolines.Status;
        // lrc_Dispolines2.Comment := lrc_Dispolines.Comment;
        // lrc_Dispolines2."Source Type Comment" := lrc_Dispolines."Source Type Comment";
        // // DMG 001 DMG50027.e
        // // PVP 006 DMG50027.s
        // lrc_Dispolines2."Transport Temperature" := lrc_Dispolines."Transport Temperature";
        // lrc_Dispolines2."Shipping Agent Code" := lrc_Dispolines."Shipping Agent Code";
        // lrc_Dispolines2."Ship. Agent Maturat. Location" := lrc_Dispolines."Ship. Agent Maturat. Location";
        // lrc_Dispolines2."Create Doc. After PreMaturat." := lrc_Dispolines."Create Doc. After PreMaturat.";
        // lrc_Dispolines2."Shipping Time" := lrc_Dispolines."Shipping Time";
        // lrc_Dispolines2."Ship. Time Maturat. Location" := lrc_Dispolines."Ship. Time Maturat. Location";
        // lrc_Dispolines2."Maturation Time" := lrc_Dispolines."Maturation Time";
        // // PVP 006 DMG50027.e

        // lrc_Dispolines2.insert();



        //       END;
        //     UNTIL lrc_Dispolines.NEXT() = 0;
        //     lrc_Dispolines.DELETEALL(TRUE);
        //   END;
        // END;

    end;

    trigger OnInsert()
    var

        lrc_FruitvisionSetup: Record "POI ADF Setup";
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        lrc_PackDocSubtype: Record "POI Pack. Doc. Subtype";
        //lcu_ExtendedDimensionMgt: Codeunit "5087916";
        //lcu_RecipePackingManagement: Codeunit "5110700";
        lcu_BatchMgt: Codeunit "POI BAM Batch Management";
        lcu_CustomerSpecificFunctions: Codeunit "POI Customer Spec. Functions";
    begin
        TESTFIELD("Doc. No.");
        lrc_PackOrderHeader.GET("Doc. No.");

        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");

        // Werte aus Kopfsatz setzen
        "Expected Receipt Date" := lrc_PackOrderHeader."Expected Receipt Date";
        "Promised Receipt Date" := lrc_PackOrderHeader."Promised Receipt Date";
        IF lrc_PackOrderHeader."Master Batch No." <> '' THEN
            "Master Batch No." := lrc_PackOrderHeader."Master Batch No.";
        IF lrc_PackOrderHeader."Batch No." <> '' THEN
            "Batch No." := lrc_PackOrderHeader."Batch No.";

        "Packing Date" := lrc_PackOrderHeader."Packing Date";
        // IF "Production Line Code" = '' THEN
        //     "Production Line Code" := lrc_PackOrderHeader."Production Line Code"


        IF lrc_PackOrderHeader."Outp. Item Location Code" <> '' THEN
            VALIDATE("Location Code", lrc_PackOrderHeader."Outp. Item Location Code");

        //lcu_RecipePackingManagement.ActualLotNoInActualLine(Rec);

        lrc_FruitvisionSetup.GET();
        IF lrc_FruitvisionSetup."Internal Customer Code" = 'KOELLAHH' THEN //Funktion nicht aktiv
            lcu_CustomerSpecificFunctions.SetLotNumber(Rec);

        // Dimensionen aus Belegunterart übernehmen
        IF lrc_PackOrderHeader."Pack. Doc. Type Code" <> '' THEN
            IF lrc_PackDocSubtype.GET(lrc_PackOrderHeader."Pack. Doc. Type Code") THEN BEGIN
                "Shortcut Dimension 1 Code" := lrc_PackDocSubtype."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := lrc_PackDocSubtype."Shortcut Dimension 2 Code";
                "Shortcut Dimension 3 Code" := lrc_PackDocSubtype."Shortcut Dimension 3 Code";
                "Shortcut Dimension 4 Code" := lrc_PackDocSubtype."Shortcut Dimension 4 Code";
            END;

        // Dimension aufgrund erweiterter Kriterien suchen
        // lcu_ExtendedDimensionMgt.EDM_PackOutputLineItem(Rec);

        // Positionsvariante aktualisieren
        lcu_BatchMgt.PackUpdBatchVar(Rec);
    end;

    trigger OnModify()
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        //lcu_ExtendedDimensionMgt: Codeunit "5087916";
        lcu_BatchMgt: Codeunit "POI BAM Batch Management";

    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");

        // Dimension aufgrund erweiterter Kriterien suchen
        //lcu_ExtendedDimensionMgt.EDM_PackOutputLineItem(Rec);

        // Positionsvariante aktualisieren
        lcu_BatchMgt.PackUpdBatchVar(Rec);

        // Zugeordnete Lagerorte aktualisieren
        IF ("Location Code" <> '') AND ("Batch Variant No." <> '') THEN
            gcu_StockMgt.BatchVarFillLocations("Batch Variant No.", "Batch No.", "Item No.", "Location Code");
    end;

    trigger OnRename()
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;

    var
        gcu_StockMgt: Codeunit "POI Stock Management";
        AGILES_TEXT001Txt: Label 'Löschung nicht zulässig, Positionsvariante %1 ist in Belegen zugeordnet!', Comment = '%1';
        AGILES_TEXT002Txt: Label 'Änderung nicht zulässig!';
        AGILES_TEXT003Txt: Label 'Änderung nicht zulässig, Positionsvariante %1 ist in Belegen zugeordnet!', Comment = '%1';
        AGILES_TEXT004Txt: Label 'Menge darf nicht weniger als die gepackte Menge sein!';
        AGILES_TEXT005Txt: Label 'Die zu packende Menge %1 darf die Restmenge %2 nicht übersteigen!', Comment = '%1 %2';
        AGILES_TEXT006Txt: Label 'Sie können nicht mehr stornieren %1 als gebucht ist %2!', Comment = '%1%2';
        AGILES_TEXT007Txt: Label 'Die Referenzeinheit ist nicht in der zu packenden Einheit enthalten!';
        AGILES_TEXT008Txt: Label 'Es sind bereits Mengen produziert. Möchten Sie trotzdem ändern?';
        AGILES_TEXT009Txt: Label 'Artikelposten nicht gefunden!';
        AGILES_TEXT010Txt: Label 'Basiseinheit Artikel und Einheitencode sind abweichend!';
        // AGILES_TEXT011Txt: Label 'Pack. Order %1: Mandatory field %2 in the line %3 is empty';
        //gcu_ItemAttributeMgt: Codeunit "5087910";
        gbn_IndirectCall: Boolean;
        // AGILES_TEXT012Txt: Label 'Menge Rohware berechnen?';
        AGILES_TEXT013Txt: Label 'Menge Verpackung berechnen?';

    procedure CalcQuantity()
    var
        lrc_FruitvisionSetup: Record "POI ADF Setup";
        lcu_CustomerSpecificFunctions: Codeunit "POI Customer Spec. Functions";
        ldc_OutputQtyBase: Decimal;
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Berechnung der Mengen
        // --------------------------------------------------------------------------------------

        CASE CurrFieldNo OF

            // -----------------------------------------------------------
            // Keine explizite Eingabe
            // -----------------------------------------------------------
            0:
                BEGIN
                    // Menge Verpackungen berechnen
                    "Quantity (PU)" := Quantity * "Qty. (PU) per Unit of Measure";
                    // Menge Paletten berechnen
                    IF "Qty. (Unit) per Transp.(TU)" <> 0 THEN
                        "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp.(TU)"
                    ELSE
                        "Quantity (TU)" := 0;
                END;

            // -----------------------------------------------------------
            // Eingabe Menge Verkaufseinheit
            // -----------------------------------------------------------
            FIELDNO(Quantity):
                BEGIN
                    // Menge Verpackungen berechnen
                    "Quantity (PU)" := Quantity * "Qty. (PU) per Unit of Measure";
                    // Menge Paletten berechnen
                    IF "Qty. (Unit) per Transp.(TU)" <> 0 THEN
                        "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp.(TU)"
                    ELSE
                        "Quantity (TU)" := 0;
                END;

            // -----------------------------------------------------------
            // Eingabe Menge Paletten
            // -----------------------------------------------------------
            FIELDNO("Quantity (TU)"):
                BEGIN
                    // Menge Kolli berechnen
                    Quantity := "Quantity (TU)" * "Qty. (Unit) per Transp.(TU)";
                    // Menge Verpackungen berechnen
                    "Quantity (PU)" := Quantity * "Qty. (PU) per Unit of Measure";
                END;

            // -----------------------------------------------------------
            // Eingabe Menge Verpackungen
            // -----------------------------------------------------------
            FIELDNO("Quantity (PU)"):
                BEGIN
                    // Menge Kolli berechnen
                    TESTFIELD("Qty. (PU) per Unit of Measure");
                    Quantity := "Quantity (PU)" / "Qty. (PU) per Unit of Measure";
                    // Menge Paletten berechnen
                    IF "Qty. (Unit) per Transp.(TU)" <> 0 THEN
                        "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp.(TU)"
                    ELSE
                        "Quantity (TU)" := 0;
                END;

            // -----------------------------------------------------------
            // Eingabe Menge Verpackungen pro Einheit
            // -----------------------------------------------------------
            FIELDNO("Qty. (PU) per Unit of Measure"):
                // Menge Verpackungen berechnen
                "Quantity (PU)" := Quantity * "Qty. (PU) per Unit of Measure";
            // -----------------------------------------------------------
            // Eingabe Menge Einheiten pro Transporteinheit
            // -----------------------------------------------------------
            FIELDNO("Qty. (Unit) per Transp.(TU)"):
                // Menge Paletten berechnen
                IF "Qty. (Unit) per Transp.(TU)" <> 0 THEN
                    "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp.(TU)"
                ELSE
                    "Quantity (TU)" := 0;
        END;

        VALIDATE("Gross Weight");
        VALIDATE("Net Weight");

        lrc_FruitvisionSetup.GET(); //keine Tabelle vorhanden
        IF lrc_FruitvisionSetup."Internal Customer Code" = 'MEV' THEN
            lcu_CustomerSpecificFunctions.MEV_CalcCapNeed(Rec);

        lrc_PackOrderInputItems.RESET();
        lrc_PackOrderInputItems.SETRANGE("Doc. No.", "Doc. No.");
        IF lrc_PackOrderInputItems.FIND('-') THEN
            REPEAT

                lrc_PackOrderOutputItems.RESET();
                lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "Doc. No.");
                lrc_PackOrderOutputItems.SETFILTER("Line No.", '<>%1', "Line No.");
                IF lrc_PackOrderInputItems."Doc. Line No. Output" <> 0 THEN BEGIN
                    IF (lrc_PackOrderOutputItems."Line No." = lrc_PackOrderInputItems."Doc. Line No. Output") AND
                       (lrc_PackOrderOutputItems."Line No." = "Line No.") THEN
                        ldc_OutputQtyBase := "Quantity (Base)";
                END ELSE
                    ldc_OutputQtyBase := "Quantity (Base)";
                IF lrc_PackOrderOutputItems.FIND('-') THEN
                    REPEAT
                        ldc_OutputQtyBase := ldc_OutputQtyBase + lrc_PackOrderOutputItems."Quantity (Base)";
                    UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
                IF lrc_PackOrderInputItems."Factor %" = 0 THEN
                    lrc_PackOrderInputItems."Factor Quantity (Base)" := 0
                ELSE
                    lrc_PackOrderInputItems."Factor Quantity (Base)" := ROUND((ldc_OutputQtyBase / 100) * lrc_PackOrderInputItems."Factor %", 0.00001);
                lrc_PackOrderInputItems.MODIFY();
            UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    end;

    procedure CalcQuantityPer()
    var
        lrc_UnitOfMeasure: Record "Unit of Measure";
    begin
        // ------------------------------------------------------------------------------------
        // Berechnung der Umrechnungsfaktoren von Unit of Measure in die anderen Einheiten
        // ------------------------------------------------------------------------------------

        "Qty. (PU) per Unit of Measure" := 0;
        "Qty. (COU) per Pack. Unit (PU)" := 0;
        "Qty. (Unit) per Transp.(TU)" := 0;
        "Quantity (PU)" := 0;
        "Quantity (TU)" := 0;

        IF ("Item No." = '') OR
           ("Qty. per Unit of Measure" = 0) THEN
            EXIT;

        // Umrechnunsgfaktoren berechnen
        IF "Packing Unit of Measure (PU)" <> '' THEN BEGIN
            lrc_UnitOfMeasure.GET("Unit of Measure Code");
            IF "Packing Unit of Measure (PU)" <> lrc_UnitOfMeasure."POI Packing Unit of Meas (PU)" THEN
                ERROR('Verpackungseingeit ist abweichend von Verpackungseinheit der Artikeleinheit!');
            "Qty. (PU) per Unit of Measure" := lrc_UnitOfMeasure."POI Qty. (PU) per Unit of Meas";

            IF "Content Unit of Measure (COU)" <> '' THEN
                "Qty. (COU) per Pack. Unit (PU)" := lrc_UnitOfMeasure."POI Qty. (CP) per Packing Unit";
        END;

        IF "Transport Unit of Measure (TU)" <> '' THEN BEGIN
            lrc_UnitOfMeasure.GET("Unit of Measure Code");
            IF lrc_UnitOfMeasure."POI Transp. Unit of Meas (TU)" = "Transport Unit of Measure (TU)" THEN
                "Qty. (Unit) per Transp.(TU)" := lrc_UnitOfMeasure."POI Qty. per Transp. Unit (TU)";
            IF lrc_ItemUnitofMeasure.GET("Item No.", "Transport Unit of Measure (TU)") THEN
                "Qty. (Unit) per Transp.(TU)" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure" / "Qty. per Unit of Measure";
        END;

        // Menge berechnen
        "Quantity (PU)" := Quantity * "Qty. (PU) per Unit of Measure";
        IF "Qty. (Unit) per Transp.(TU)" <> 0 THEN
            "Quantity (TU)" := Quantity / "Qty. (Unit) per Transp.(TU)"
    end;

    procedure FillCrossReferenceNo(rin_FieldNo: Integer; var vrc_PackOrderOutputItems: Record "POI Pack. Order Output Items")
    var

        lrc_Customer: Record Customer;
        lrc_PackOrderHeader: Record "POI Pack. Order Header";

        lco_CrossReferenceNo: Code[20];
    begin
        IF vrc_PackOrderOutputItems."Item No." = '' THEN
            EXIT;

        lrc_PackOrderHeader.GET("Doc. No.");

        lco_CrossReferenceNo := '';

        // Artikelreferenz suchen
        // Debitor
        IF lrc_PackOrderHeader."Customer No." <> '' THEN BEGIN
            lrc_ItemCrossReferenz.RESET();
            lrc_ItemCrossReferenz.SETRANGE("Item No.", vrc_PackOrderOutputItems."Item No.");
            lrc_ItemCrossReferenz.SETFILTER("Variant Code", '%1|%2', vrc_PackOrderOutputItems."Variant Code", '');
            CASE rin_FieldNo OF
                FIELDNO("Unit of Measure Code"):
                    lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Unit of Measure Code", '');
                FIELDNO("Transport Unit of Measure (TU)"):
                    lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Transport Unit of Measure (TU)", '');
                FIELDNO("Packing Unit of Measure (PU)"):
                    lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Packing Unit of Measure (PU)", '');
            END;
            lrc_ItemCrossReferenz.SETRANGE("Cross-Reference Type", lrc_ItemCrossReferenz."Cross-Reference Type"::Customer);
            lrc_ItemCrossReferenz.SETRANGE("Cross-Reference Type No.", lrc_PackOrderHeader."Customer No.");
            IF lrc_ItemCrossReferenz.FIND('-') THEn
                lco_CrossReferenceNo := lrc_ItemCrossReferenz."Cross-Reference No.";
        END;

        // Unternehmenskette aus Packereiauftrag
        IF lco_CrossReferenceNo = '' THEN
            IF lrc_PackOrderHeader."Chain Name" <> '' THEN BEGIN
                lrc_ItemCrossReferenz.RESET();
                lrc_ItemCrossReferenz.SETRANGE("Item No.", vrc_PackOrderOutputItems."Item No.");
                lrc_ItemCrossReferenz.SETFILTER("Variant Code", '%1|%2', vrc_PackOrderOutputItems."Variant Code", '');
                CASE rin_FieldNo OF
                    FIELDNO("Unit of Measure Code"):
                        lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Unit of Measure Code", '');
                    FIELDNO("Transport Unit of Measure (TU)"):
                        lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Transport Unit of Measure (TU)", '');
                    FIELDNO("Packing Unit of Measure (PU)"):
                        lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Packing Unit of Measure (PU)", '');
                END;
                //lrc_ItemCrossReferenz.SETRANGE("Cross-Reference Type", lrc_ItemCrossReferenz."Cross-Reference Type"::"19");
                lrc_ItemCrossReferenz.SETRANGE("Cross-Reference Type No.", lrc_PackOrderHeader."Chain Name");
                IF lrc_ItemCrossReferenz.FIND('-') THEN
                    lco_CrossReferenceNo := lrc_ItemCrossReferenz."Cross-Reference No.";
            END;

        // Unternehmenskette aus Debitor
        IF lco_CrossReferenceNo = '' THEN
            IF lrc_PackOrderHeader."Customer No." <> '' THEN
                IF lrc_Customer.GET(lrc_PackOrderHeader."Customer No.") THEN
                    IF lrc_Customer."Chain Name" <> '' THEN BEGIN
                        lrc_ItemCrossReferenz.RESET();
                        lrc_ItemCrossReferenz.SETRANGE("Item No.", vrc_PackOrderOutputItems."Item No.");
                        lrc_ItemCrossReferenz.SETFILTER("Variant Code", '%1|%2', vrc_PackOrderOutputItems."Variant Code", '');
                        CASE rin_FieldNo OF
                            FIELDNO("Unit of Measure Code"):
                                lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2',
                                  vrc_PackOrderOutputItems."Unit of Measure Code", '');
                            FIELDNO("Transport Unit of Measure (TU)"):
                                lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2',
                                  vrc_PackOrderOutputItems."Transport Unit of Measure (TU)", '');
                            FIELDNO("Packing Unit of Measure (PU)"):
                                lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2',
                                  vrc_PackOrderOutputItems."Packing Unit of Measure (PU)", '');
                        END;
                        //lrc_ItemCrossReferenz.SETRANGE("Cross-Reference Type",lrc_ItemCrossReferenz."Cross-Reference Type"::"19");
                        lrc_ItemCrossReferenz.SETRANGE("Cross-Reference Type No.", lrc_Customer."Chain Name");
                        IF lrc_ItemCrossReferenz.FIND('-') THEN
                            lco_CrossReferenceNo := lrc_ItemCrossReferenz."Cross-Reference No.";
                    END;

        IF lco_CrossReferenceNo = '' THEN BEGIN
            lrc_ItemCrossReferenz.RESET();
            lrc_ItemCrossReferenz.SETRANGE("Item No.", vrc_PackOrderOutputItems."Item No.");
            lrc_ItemCrossReferenz.SETFILTER("Variant Code", '%1|%2', vrc_PackOrderOutputItems."Variant Code", '');
            CASE rin_FieldNo OF
                FIELDNO("Unit of Measure Code"):
                    lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Unit of Measure Code", '');
                FIELDNO("Transport Unit of Measure (TU)"):
                    lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Transport Unit of Measure (TU)", '');
                FIELDNO("Packing Unit of Measure (PU)"):
                    lrc_ItemCrossReferenz.SETFILTER("Unit of Measure", '%1|%2', vrc_PackOrderOutputItems."Packing Unit of Measure (PU)", '');
            END;
            lrc_ItemCrossReferenz.SETRANGE("Cross-Reference Type", lrc_ItemCrossReferenz."Cross-Reference Type"::" ");
            lrc_ItemCrossReferenz.SETRANGE("Cross-Reference Type No.");
            IF lrc_ItemCrossReferenz.FIND('-') THEN
                lco_CrossReferenceNo := lrc_ItemCrossReferenz."Cross-Reference No.";
        END;

        IF lco_CrossReferenceNo <> '' THEN
            CASE rin_FieldNo OF
                FIELDNO("Unit of Measure Code"):
                    vrc_PackOrderOutputItems.VALIDATE("Cross-Reference No. (Unit)", lco_CrossReferenceNo);
                FIELDNO("Transport Unit of Measure (TU)"):
                    vrc_PackOrderOutputItems.VALIDATE("Cross-Reference No. (TU)", lco_CrossReferenceNo);
                FIELDNO("Packing Unit of Measure (PU)"):
                    vrc_PackOrderOutputItems.VALIDATE("Cross-Reference No. (PU)", lco_CrossReferenceNo);
            END;

        // Etikett füllen
        lrc_PackOrderLabels.RESET();
        lrc_PackOrderLabels.SETRANGE("Doc. No.", vrc_PackOrderOutputItems."Doc. No.");
        lrc_PackOrderLabels.SETRANGE("Doc. Line No. Output", vrc_PackOrderOutputItems."Line No.");
        CASE rin_FieldNo OF
            FIELDNO("Unit of Measure Code"):
                BEGIN
                    lrc_PackOrderLabels.SETRANGE("Unit Of Measure Code", vrc_PackOrderOutputItems."Unit of Measure Code");
                    IF lrc_PackOrderLabels.FIND('-') THEN
                        vrc_PackOrderOutputItems.VALIDATE("Label (Unit)", lrc_PackOrderLabels."Label Code");
                END;
            FIELDNO("Transport Unit of Measure (TU)"):
                BEGIN
                    lrc_PackOrderLabels.SETRANGE("Unit Of Measure Code", vrc_PackOrderOutputItems."Transport Unit of Measure (TU)");
                    IF lrc_PackOrderLabels.FIND('-') THEN
                        vrc_PackOrderOutputItems.VALIDATE("Label (TU)", lrc_PackOrderLabels."Label Code");
                END;
            FIELDNO("Packing Unit of Measure (PU)"):
                BEGIN
                    lrc_PackOrderLabels.SETRANGE("Unit Of Measure Code", vrc_PackOrderOutputItems."Packing Unit of Measure (PU)");
                    IF lrc_PackOrderLabels.FIND('-') THEN
                        vrc_PackOrderOutputItems.VALIDATE("Label (PU)", lrc_PackOrderLabels."Label Code");
                END;
        END;
    end;

    procedure CheckChangeItemNo()
    begin
        // --------------------------------------------------------------------------------
        // Prüfung ob Wechsel der Artikelnummer --> Positionsvariante auf gelöscht setzen
        // --------------------------------------------------------------------------------
    end;

    procedure SetWeightValues()
    var
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Item: Record Item;
    begin
        // ----------------------------------------------------------------------------------------------------------
        // Funktion zum Setzen der Gewichte
        // ----------------------------------------------------------------------------------------------------------

        IF "Unit of Measure Code" <> '' THEN BEGIN
            lrc_UnitofMeasure.GET("Unit of Measure Code");
            lrc_ItemUnitofMeasure.RESET();
            lrc_ItemUnitofMeasure.SETRANGE("Item No.", "Item No.");
            lrc_ItemUnitofMeasure.SETRANGE(Code, "Unit of Measure Code");
            IF lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
                IF lrc_ItemUnitofMeasure."POI Gross Weight" <> 0 THEN
                    VALIDATE("Gross Weight", lrc_ItemUnitofMeasure."POI Gross Weight")
                ELSE
                    IF lrc_UnitofMeasure.GET("Unit of Measure Code") THEN
                        VALIDATE("Gross Weight", lrc_UnitofMeasure."POI Gross Weight");
                IF lrc_ItemUnitofMeasure."POI Net Weight" <> 0 THEN
                    VALIDATE("Net Weight", lrc_ItemUnitofMeasure."POI Net Weight")
                ELSE
                    IF lrc_UnitofMeasure.GET("Unit of Measure Code") THEN
                        VALIDATE("Net Weight", lrc_UnitofMeasure."POI Net Weight");
            END ELSE BEGIN
                VALIDATE("Gross Weight", lrc_UnitofMeasure."POI Gross Weight");
                VALIDATE("Net Weight", lrc_UnitofMeasure."POI Net Weight");
            END;
        END ELSE BEGIN
            "Gross Weight" := 0;
            "Net Weight" := 0;
            "Total Gross Weight" := 0;
            "Total Net Weight" := 0;

            IF lrc_Item.GET("Item No.") THEN BEGIN
                VALIDATE("Gross Weight", lrc_Item."Gross Weight" * "Qty. per Unit of Measure");
                VALIDATE("Net Weight", lrc_Item."Net Weight" * "Qty. per Unit of Measure");
            END;

        END;
    end;

    procedure SetIndirectCall(vbn_IndirectCall: Boolean)
    begin
        // -------------------------------
        // Globale Set-Funktion, die nur innerhalb der aktiven Variablen gilt. (Setzt sich bei Abbruch von Funktionen
        // automatisch wieder zurück, daher besser als SingleInstance)
        // -------------------------------
        gbn_IndirectCall := vbn_IndirectCall;
    end;

    var

        lrc_PackOrderInputItems: Record "POI Pack. Order Input Items";
        lrc_PackOrderPackItems: Record "POI PO Input Pack. Items";
        lrc_EmptiesPackOutputLine: Record "POI Pack. Order Output Items";
        lrc_EmptiesPackInputLine: Record "POI Pack. Order Input Items";
        lrc_ItemCrossReferenz: Record "Item Cross Reference";
        lrc_PackOrderLabels: Record "POI Pack. Order Labels";
        lrc_ItemLedgerEntry: Record "Item Ledger Entry";
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        gcu_ItemAttributeMgt: Codeunit "POI Item Attribute Mask Mgt";

}

