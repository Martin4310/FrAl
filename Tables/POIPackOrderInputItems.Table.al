table 5110714 "POI Pack. Order Input Items"
{


    Caption = 'Pack. Order Input Items';
    // DrillDownFormID = Form5110735;
    // LookupFormID = Form5110735;
    PasteIsValid = false;

    fields
    {
        field(1; "Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
            DataClassification = CustomerContent;
        }
        field(2; "Doc. Line No. Output"; Integer)
        {
            Caption = 'Doc. Line No. Output';
            TableRelation = "POI Pack. Order Output Items"."Line No." WHERE("Doc. No." = FIELD("Doc. No."));
            DataClassification = CustomerContent;
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(9; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Rohware,Packartikel';
            OptionMembers = Item,"Packing Item";
            DataClassification = CustomerContent;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            ValidateTableRelation = false;

            trigger OnValidate()
            var

                lrc_FruitVisionSetup: Record "POI ADF Setup";
                lrc_Item: Record Item;
                lrc_RecipePackingSetup: Record "POI Recipe & Packing Setup";
                lcu_BaseDataMgt: Codeunit "POI Base Data Mgt";
                lcu_RecipePackingManagement: Codeunit "POI ADF Recipe & Packing Mgt";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
                lco_No: Code[20];
            begin
                IF lcu_BaseDataMgt.ItemNoSearch("Item No.", 0, '', TODAY(), FALSE, '', lco_No) = FALSE THEN BEGIN
                    lrc_FruitVisionSetup.GET();
                    IF lrc_FruitVisionSetup."Sales Beep if Item not found" = TRUE THEN
                        ERROR('')
                    ELSE
                        ERROR('');
                END ELSE
                    "Item No." := lco_No;

                TESTFIELD("Quantity Consumed", 0);

                lrc_RecipePackingSetup.GET();


                IF "Item No." <> xRec."Item No." THEN
                    lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI(copystr(FIELDCAPTION("Item No."), 1, 100), Rec);


                IF "Item No." <> '' THEN BEGIN

                    lrc_Item.GET("Item No.");

                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Item Category Code" := lrc_Item."Item Category Code";
                    "Product Group Code" := lrc_Item."POI Product Group Code";
                    "Item Typ" := lrc_Item."POI Item Typ";

                    IF lrc_RecipePackingSetup."Check Product Group" = TRUE THEN BEGIN
                        lrc_PackOrderOutputItems.RESET();
                        lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "Doc. No.");
                        IF lrc_PackOrderOutputItems.FIND('-') THEN
                            REPEAT
                                TESTFIELD("Product Group Code", lrc_PackOrderOutputItems."Product Group Code");
                            UNTIL lrc_PackOrderOutputItems.NEXT() = 0;
                    END;

                    "Variety Code" := lrc_Item."POI Variety Code";
                    "Country of Origin Code" := lrc_Item."POI Countr of Ori Code (Fruit)";
                    "Trademark Code" := lrc_Item."POI Trademark Code";
                    "Caliber Code" := lrc_Item."POI Caliber Code";
                    "Color Code" := lrc_Item."POI Item Attribute 2";
                    "Grade of Goods Code" := lrc_Item."POI Grade of Goods Code";
                    "Conservation Code" := lrc_Item."POI Item Attribute 7";
                    "Packing Code" := lrc_Item."POI Item Attribute 4";
                    "Coding Code" := lrc_Item."POI Coding Code";
                    "Quality Code" := lrc_Item."POI Item Attribute 3";
                    "Treatment Code" := lrc_Item."POI Item Attribute 5";

                    "Item Typ" := lrc_Item."POI Item Typ";

                    "Base Unit of Measure Code" := lrc_Item."Base Unit of Measure";

                    IF lrc_Item."Purch. Unit of Measure" <> '' THEN
                        VALIDATE("Unit of Measure Code", lrc_Item."Purch. Unit of Measure")
                    ELSE
                        VALIDATE("Unit of Measure Code", lrc_Item."Base Unit of Measure");

                    "Net Weight" := 0;
                    "Total Net Weight" := 0;
                    "Gross Weight" := 0;
                    "Total Gross Weight" := 0;
                    VALIDATE("Direct Unit Cost (LCY)", lcu_RecipePackingManagement.FindItemDirectUnitPrice("Item No.", "Batch Variant No."));


                END ELSE BEGIN

                    "Item Description" := '';
                    "Item Description 2" := '';
                    "Item Category Code" := '';
                    "Product Group Code" := '';
                    "Item Typ" := 0;
                    "Variety Code" := '';
                    "Country of Origin Code" := '';
                    "Trademark Code" := '';
                    "Caliber Code" := '';
                    "Color Code" := '';
                    "Grade of Goods Code" := '';
                    "Conservation Code" := '';
                    "Packing Code" := '';
                    "Coding Code" := '';
                    "Quality Code" := '';
                    "Treatment Code" := '';
                    "Base Unit of Measure Code" := '';
                    VALIDATE("Unit of Measure Code");

                    "Net Weight" := 0;
                    "Total Net Weight" := 0;
                    "Gross Weight" := 0;
                    "Total Gross Weight" := 0;

                    VALIDATE("Direct Unit Cost (LCY)", 0);
                    VALIDATE("Spectrum Caliber A-Goods", '');

                END;
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
                    lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI(COPYSTR(FIELDCAPTION("Variant Code"), 1, 100), Rec);
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
                    lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI(copystr(FIELDCAPTION("Master Batch No."), 1, 100), Rec);

                "^"(FIELDNO("Master Batch No."));
            end;
        }
        field(13; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = IF ("Master Batch No." = FILTER(<> '')) "POI Batch"."No." WHERE("Master Batch No." = FIELD("Master Batch No."))
            ELSE
            IF ("Master Batch No." = FILTER('')) "POI Batch"."No.";

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Batch No." <> xRec."Batch No." THEN
                    lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI(copystr(FIELDCAPTION("Batch No."), 1, 100), Rec);

                "^"(FIELDNO("Batch No."));
                VALIDATE("Batch Variant No.", "Batch No.");
            end;
        }
        field(14; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF ("Item No." = FILTER(''),
                                "Master Batch No." = FILTER(''),
                                "Batch No." = FILTER('')) "POI Batch Variant"
            ELSE
            IF ("Item No." = FILTER(<> ''),
                                         "Master Batch No." = FILTER(''),
                                         "Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."))
            ELSE
            IF ("Master Batch No." = FILTER(<> ''),
                                                  "Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                                                               "Master Batch No." = FIELD("Master Batch No."))
            ELSE
            IF ("Master Batch No." = FILTER(<> ''),
                                                                                                        "Batch No." = FILTER(<> '')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                                                                                                                       "Master Batch No." = FIELD("Master Batch No."),
                                                                                                                                                       "Batch No." = FIELD("Batch No."));

            trigger OnValidate()
            var
                lrc_BatchVariantPackingQuality: Record "POI Pack. Batch Var. Quality";
                lrc_Item: Record Item;
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                lcu_PalletManagement: Codeunit "POI Pallet Management";

            begin

                IF "Batch Variant No." <> xRec."Batch Variant No." THEN
                    lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI(copystr(FIELDCAPTION("Batch Variant No."), 1, 100), Rec);


                "^"(FIELDNO("Batch Variant No."));

                IF "Batch Variant No." <> xRec."Batch Variant No." THEN BEGIN


                    IF (Quantity <> 0) AND ("Location Code" <> '') THEN BEGIN
                        // Bestandskontrolle
                        lrc_Item.GET("Item No.");
                        IF (lrc_Item."POI Batch Item" = TRUE) AND
                           ("Batch Variant No." <> '') THEN
                            gcu_StockMgt.BatchVarCheckAvail("Batch Variant No.", "Location Code", 0D, (Quantity * "Qty. per Unit of Measure"), 0);

                        VALIDATE(Quantity);
                    END;


                    IF xRec."Batch Variant No." <> '' THEN
                        lcu_BatchManagement.OpenBatchVarStatusIfZero(xRec."Batch Variant No.");

                    IF ("Batch Variant No." <> '') AND ("Batch No." <> '') THEN BEGIN
                        lrc_BatchVariantPackingQuality.RESET();
                        IF lrc_BatchVariantPackingQuality.GET("Batch Variant No.", "Batch No.") THEN BEGIN
                            "A-Goods Factor %" := lrc_BatchVariantPackingQuality."Exp. % Sorting Quality 1";
                            IF lrc_BatchVariantPackingQuality."Spectrum Caliber A-Goods" <> '' THEN
                                "Spectrum Caliber A-Goods" := lrc_BatchVariantPackingQuality."Spectrum Caliber A-Goods";
                            VALIDATE("Qty. per Unit of Measure");
                        END;
                    END;

                    IF "Batch Variant No." <> '' THEN
                        lcu_BatchManagement.BatchVariantRecalc("Item No.", "Batch Variant No.");

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
        field(18; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(19; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(20; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety";
        }
        field(21; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";
        }
        field(22; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(23; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber";
        }
        field(24; "Color Code"; Code[10])
        {
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(25; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods".Code;
        }
        field(26; "Conservation Code"; Code[10])
        {
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(27; "Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(28; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";
        }
        field(29; "Quality Code"; Code[10])
        {
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3";
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin

                IF "Location Code" <> xRec."Location Code" THEN BEGIN
                    lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI(copystr(FIELDCAPTION("Location Code"), 1, 100), Rec);
                    IF Quantity <> 0 THEN
                        VALIDATE(Quantity, 0);
                END;

            end;
        }
        field(31; "Location Group Code"; Code[10])
        {
            Caption = 'Location Group Code';
            TableRelation = "POI Location Group";
        }
        field(32; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                lrc_UnitOfMeasure: Record "Unit of Measure";
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                TESTFIELD("Quantity Consumed", 0);


                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN
                    lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI(copystr(FIELDCAPTION("Unit of Measure Code"), 1, 100), Rec);


                IF "Unit of Measure Code" <> '' THEN BEGIN
                    lrc_UnitOfMeasure.GET("Unit of Measure Code");
                    "Unit of Measure" := lrc_UnitOfMeasure.Description;
                    lrc_ItemUnitofMeasure.GET("Item No.", "Unit of Measure Code");
                    "Qty. per Unit of Measure" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
                    VALIDATE("Qty. per Unit of Measure")
                END ELSE BEGIN
                    "Unit of Measure" := '';
                    "Qty. per Unit of Measure" := 1;
                    VALIDATE("Qty. per Unit of Measure")
                END;

                SetWeightValues();
            end;
        }
        field(33; "Unit of Measure"; Text[50])
        {
            Caption = 'Unit of Measure';
            Description = 'FH von 10 auf 30';
            DataClassification = CustomerContent;
        }
        field(34; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            var
                lrc_Item: Record Item;
                lrc_PackOrderHeader: Record "POI Pack. Order Header";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
            //SSPText01Txt: Label 'Menge darf nicht weniger als verbrauchte Menge sein !';
            //lrc_PositionPlanningSetup: Record "5110488"; //TODO: planning
            //lcu_PurchaseDispoMgt: Codeunit "5110380";

            begin
                TESTFIELD("Location Code");

                // Bestandskontrolle
                lrc_Item.GET("Item No.");
                IF (lrc_Item."POI Batch Item" = TRUE) AND ("Batch Variant No." <> '') THEN
                    gcu_StockMgt.BatchVarCheckAvail("Batch Variant No.", "Location Code", 0D, (Quantity * "Qty. per Unit of Measure"), (xRec.Quantity * "Qty. per Unit of Measure"));

                "Quantity to Consume" := Quantity - "Quantity Consumed";
                "Remaining Quantity" := Quantity - "Quantity Consumed";

                VALIDATE("Qty. per Unit of Measure");
                VALIDATE("Direct Unit Cost (LCY)");

                VALIDATE("Gross Weight");
                VALIDATE("Net Weight");


                IF Quantity < xRec.Quantity THEN
                    lcu_BatchManagement.OpenBatchVarStatusIfZero("Batch Variant No.")
                ELSE BEGIN
                    IF NOT lrc_PackOrderInputItems.GET("Doc. No.", "Doc. Line No. Output", "Line No.") THEN
                        lrc_PackOrderInputItems.INIT();
                    lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
                     lrc_PackOrderInputItems."Remaining Quantity (Base)" - "Remaining Quantity (Base)");
                END;



                IF "Qty. (Unit) per Transp.(TU)" <> 0 THEN
                    "Quantity (TU)" := ROUND(Quantity / "Qty. (Unit) per Transp.(TU)", 0.00001)
                ELSE
                    "Quantity (TU)" := 0;

                // Menge darf nur dann manuell geändert werden, wenn der Pckauftrag kein Volgebeleg in der Planung ist
                IF CurrFieldNo = FIELDNO(Quantity) THEN BEGIN
                    lrc_PackOrderHeader."No." := "Doc. No.";
                    lrc_PackOrderHeader.IsNextDocPlaning(TRUE);
                END;


                // IF NOT gbn_IndirectCall THEN  //TODO: planning
                //     IF lrc_PositionPlanningSetup.GET() THEN BEGIN
                //         IF lrc_PositionPlanningSetup."Update Assigned Document Lines" THEN BEGIN
                //             IF MODIFY(TRUE) THEN BEGIN
                //                 lcu_PurchaseDispoMgt.UpdateAssignedLines(Rec, xRec, DATABASE::"Pack. Order Input Items", FIELDNO(Quantity));
                //             END;
                //         END;
                //     END;

                //RS bei Leergutmengenänderung Anpassung Artikelzeile
                //RS Menge für Leergutartikel darf nicht größer als Menge in Artikelzeile sein
                IF (("Item Typ" = "Item Typ"::"Empties Item") AND ("Attached to Line No." <> 0)) THEN BEGIN
                    lrc_PackOrderInputItems.GET("Doc. No.", 0, "Attached to Line No.");
                    IF Quantity > lrc_PackOrderInputItems.Quantity THEN
                        ERROR('Die Leergutmenge darf nicht größer als die Artikelmenge sein');
                END ELSE
                    IF "Empties Attached Line No." <> 0 THEN BEGIN
                        VALIDATE("Empties Item Qty.", Quantity);
                        lrc_PackOrderInputItems.GET("Doc. No.", 0, "Empties Attached Line No.");
                        IF lrc_PackOrderInputItems.Quantity > Quantity THEN BEGIN
                            lrc_PackOrderInputItems.Quantity := Quantity;
                            lrc_PackOrderInputItems.MODIFY();
                        END;
                    END;

            end;
        }
        field(35; "Quantity to Consume"; Decimal)
        {
            Caption = 'Quantity to Consume';

            trigger OnValidate()
            var
                Agilestext01Txt: Label 'Die zu verbrauchende Menge %1 darf die Restmenge %2 nicht übersteigen !', Comment = '%1 %2';
                AgilesText02Txt: Label 'Sie können nicht mehr stornieren %1 als gebucht ist %2 !', Comment = '%1 %2';
            begin
                IF "Quantity to Consume" < 0 THEN BEGIN
                    IF (ABS("Quantity to Consume") > "Quantity Consumed") THEN
                        // 'Sie können nicht mehr stornieren %1 als gebucht ist %2 !'
                        ERROR(AgilesText02Txt, "Quantity to Consume", "Quantity Consumed");
                END ELSE
                    IF ("Quantity to Consume" * Quantity < 0) OR
                       (ABS("Quantity to Consume") > ABS("Remaining Quantity")) OR
                       (Quantity * "Remaining Quantity" < 0) THEN
                        // 'Die zu verbrauchende Menge darf die Restmenge nicht übersteigen !'
                        ERROR(Agilestext01Txt, "Quantity to Consume", "Remaining Quantity");

                VALIDATE("Qty. per Unit of Measure");
            end;
        }
        field(36; "Quantity Consumed"; Decimal)
        {
            Caption = 'Quantity Consumed';
            DataClassification = CustomerContent;
        }
        field(37; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DataClassification = CustomerContent;
        }
        field(42; "Base Unit of Measure Code"; Code[10])
        {
            Caption = 'Base Unit of Measure Code';
            TableRelation = "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(43; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
                ldc_OutputQtyBase: Decimal;
            begin

                IF "Qty. per Unit of Measure" <> xRec."Qty. per Unit of Measure" THEN
                    lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI(copystr(FIELDCAPTION("Qty. per Unit of Measure"), 1, 100), Rec);


                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                IF "A-Goods Factor %" = 0 THEN
                    "A-Goods Quantity (Base)" := "Quantity (Base)"
                ELSE
                    "A-Goods Quantity (Base)" := ("Quantity (Base)" / 100) * "A-Goods Factor %";

                "Quantity to Consume (Base)" := "Quantity to Consume" * "Qty. per Unit of Measure";
                "Quantity Consumed (Base)" := "Quantity Consumed" * "Qty. per Unit of Measure";
                "Remaining Quantity (Base)" := "Remaining Quantity" * "Qty. per Unit of Measure";

                lrc_PackOrderOutputItems.RESET();
                lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "Doc. No.");
                IF "Doc. Line No. Output" <> 0 THEN
                    lrc_PackOrderOutputItems.SETRANGE("Line No.", "Doc. Line No. Output");

                ldc_OutputQtyBase := 0;
                IF lrc_PackOrderOutputItems.FIND('-') THEN
                    REPEAT
                        ldc_OutputQtyBase := ldc_OutputQtyBase + lrc_PackOrderOutputItems."Quantity (Base)";
                    UNTIL lrc_PackOrderOutputItems.NEXT() = 0;


                IF "Factor %" = 0 THEN
                    "Factor Quantity (Base)" := 0
                ELSE
                    "Factor Quantity (Base)" := ROUND((ldc_OutputQtyBase / 100) * "Factor %", 0.00001);
            end;
        }
        field(44; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(45; "Quantity to Consume (Base)"; Decimal)
        {
            Caption = 'Quantity to Consume (Base)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(46; "Quantity Consumed (Base)"; Decimal)
        {
            Caption = 'Quantity Consumed (Base)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(47; "Remaining Quantity (Base)"; Decimal)
        {
            Caption = 'Remaining Quantity (Base)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(48; "A-Goods Factor %"; Decimal)
        {
            Caption = 'A-Goods Factor %';
            Editable = false;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                VALIDATE("Qty. per Unit of Measure");
            end;
        }
        field(49; "A-Goods Quantity (Base)"; Decimal)
        {
            Caption = 'A-Goods Quantity (Base)';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(51; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
            DataClassification = CustomerContent;
        }
        field(54; "Lot No. Batch Variant"; Code[20])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Lot No. Producer" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Lot No. Batch Variant';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(55; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Total Net Weight" := "Net Weight" * Quantity;
            end;
        }
        field(56; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
            DataClassification = CustomerContent;
        }
        field(57; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Total Gross Weight" := "Gross Weight" * Quantity;
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
            begin
                IF ("Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 0, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 1");
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
            begin
                IF ("Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 1, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 2");
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
            begin
                IF ("Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 2, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 3");
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
            begin
                IF ("Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 3, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 4");
            end;
        }
        field(65; "Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));
        }
        field(66; "Empties Item Qty."; Decimal)
        {
            Caption = 'Empties Item Qty.';
            DecimalPlaces = 0 : 5;
            Description = 'LVW';
        }
        field(70; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            begin
                IF "Transport Unit of Measure (TU)" = '' THEN BEGIN
                    "Quantity (TU)" := 0;
                    "Qty. (Unit) per Transp.(TU)" := 0;
                END;
            end;
        }
        field(71; "Qty. (Unit) per Transp.(TU)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. (Unit) per Transp.(TU)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Qty. (Unit) per Transp.(TU)") THEn
                    IF "Qty. (Unit) per Transp.(TU)" <> 0 THEN BEGIN
                        TESTFIELD("Transport Unit of Measure (TU)");
                        "Quantity (TU)" := ROUND(Quantity / "Qty. (Unit) per Transp.(TU)", 0.00001);
                    END ELSE
                        "Quantity (TU)" := 0;
            end;
        }
        field(72; "Quantity (TU)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity (TU)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Quantity (TU)") THEN BEGIN
                    IF "Quantity (TU)" <> 0 THEN BEGIN
                        TESTFIELD("Transport Unit of Measure (TU)");
                        TESTFIELD("Qty. (Unit) per Transp.(TU)");
                    END;
                    VALIDATE(Quantity, ("Quantity (TU)" * "Qty. (Unit) per Transp.(TU)"));
                END;

            end;
        }
        field(80; "Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(81; "Proper Name Code"; Code[20])
        {
            Caption = 'Proper Name Code';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(82; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(83; "Cultivation Process Code"; Code[10])
        {
            Caption = 'Cultivation Process Code';
            TableRelation = "POI Item Attribute 1";
        }
        field(84; "Cultivation Association Code"; Code[10])
        {
            Caption = 'Cultivation Association Code';
            TableRelation = "POI Cultivation Association";
        }
        field(85; "Item Typ"; Option)
        {
            Caption = 'Item Typ';
            Description = 'Standard,Batch Item,Empties Item';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material";
        }
        field(86; "Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
        }
        field(90; "Direct Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost (LCY)';

            trigger OnValidate()
            begin
                "Amount (LCY)" := "Direct Unit Cost (LCY)" * Quantity;
            end;
        }
        field(91; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(100; "Date of Consumption"; Date)
        {
            Caption = 'Date of Consumption';
        }
        field(101; "Time of Consumption"; Time)
        {
            Caption = 'Time of Consumption';
        }
        field(120; "Calculatory Costs per Unit"; Decimal)
        {
            Caption = 'Calculatory Costs per Unit';
        }
        field(121; "Calculatory Cost Amount"; Decimal)
        {
            Caption = 'Calculatory Cost Amount';
        }
        field(124; "Manual Cost Input"; Boolean)
        {
            Caption = 'Manual Cost Input';
        }
        field(125; "Costs per Unit"; Decimal)
        {
            Caption = 'Costs per Unit';

            trigger OnValidate()
            begin
                "Cost Amount" := "Costs per Unit" * Quantity;
            end;
        }
        field(126; "Cost Amount"; Decimal)
        {
            Caption = 'Cost Amount';
        }
        field(130; "Calc. Revenue per Unit"; Decimal)
        {
            Caption = 'Calculatory Revenue per Unit';
            Editable = false;
        }
        field(131; "Calc. Revenue Amount"; Decimal)
        {
            Caption = 'Calculatory Revenue Amount';
            Editable = false;
        }
        field(140; "No Revenue"; Boolean)
        {
            Caption = 'No Revenue';
        }
        field(150; Distribution; Option)
        {
            Caption = 'Distribution';
            OptionCaption = ' ,Weight,Collo';
            OptionMembers = " ",Weight,Collo;
        }
        field(159; "Manual Revenue Input"; Boolean)
        {
            Caption = 'Manual Revenue Input';

            trigger OnValidate()
            var
                lrc_PackOrderHeader: Record "POI Pack. Order Header";
            begin
                lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
                lrc_PackOrderInput.Reset();
                IF "Manual Revenue Input" THEN BEGIN
                    lrc_PackOrderInput.SETRANGE("Doc. No.", "Doc. No.");
                    lrc_PackOrderInput.SETFILTER("Line No.", '<>%1', "Line No.");
                    IF lrc_PackOrderInput.FINDSET() THEN
                        REPEAT
                            lrc_PackOrderInput."Manual Revenue Input" := TRUE;
                            lrc_PackOrderInput.MODIFY();
                        UNTIL lrc_PackOrderInput.NEXT() = 0;
                END ELSE BEGIN
                    "Manual Revenue Factor" := 0;
                    lrc_PackOrderInput.SETRANGE("Doc. No.", "Doc. No.");
                    lrc_PackOrderInput.SETFILTER("Line No.", '<>%1', "Line No.");
                    IF lrc_PackOrderInput.FINDSET() THEN
                        REPEAT
                            lrc_PackOrderInput."Manual Revenue Input" := FALSE;
                            lrc_PackOrderInput."Manual Revenue Factor" := 0;
                            lrc_PackOrderInput.MODIFY();
                        UNTIL lrc_PackOrderInput.NEXT() = 0;

                END;
            end;
        }
        field(160; "Factor %"; Decimal)
        {
            Caption = 'Factor %';
            DecimalPlaces = 0 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(161; "Revenue per Unit"; Decimal)
        {
            Caption = 'Revenue per Unit';

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Revenue per Unit") THEN
                    "Manual Revenue Input" := TRUE;
                "Revenue Amount" := "Revenue per Unit" * "Quantity Consumed";
            end;
        }
        field(162; "Revenue Amount"; Decimal)
        {
            Caption = 'Revenue Amount';
        }
        field(165; "Factor Quantity (Base)"; Decimal)
        {
            Caption = 'Factor Quantity (Base)';
            Editable = false;
        }
        field(170; "Perc. Total Qty."; Decimal)
        {
            Caption = 'Perc. Total Qty.';
        }
        field(171; "Perc. Qty. with Revenue"; Decimal)
        {
            Caption = 'Perc. Qty. with Revenue';
        }
        field(180; "Line Quantity (CU)"; Decimal)
        {
            Caption = 'Maschine Menge (Kolli)';
        }
        field(181; "Line Quantity (Verderb)"; Decimal)
        {
            Caption = 'Maschine Davon Menge Ausfall';
        }
        field(184; "Attached to Line No."; Integer)
        {
        }
        field(190; "Pallet No."; Code[30])
        {
            Caption = 'Pallet No.';
            TableRelation = "POI Pallets";
        }
        field(200; Comment; Boolean)
        {
            CalcFormula = Exist ("POI Pack. Order Comment" WHERE("Doc. No." = FIELD("Doc. No."),
                                                             Type = CONST("Input Trade Item"),
                                                             "Source Line No." = FIELD("Line No.")));
            Caption = 'Comment';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "Comment Text"; Text[80])
        {
            Caption = 'Comment Text';
        }
        // field(250;"Production Line Code";Code[10]) //TODO: production line
        // {
        //     Caption = 'Production Line Code';
        //     TableRelation = "Production Lines".Code;

        //     trigger OnValidate()
        //     var
        //         lcu_RecipePackingManagement: Codeunit "5110700";
        //     begin
        //         TESTFIELD( "Quantity Consumed", 0 );

        //         lcu_RecipePackingManagement.CheckExistingPaProductionLine( "Doc. No.", "Production Line Code" );
        //     end;
        // }
        field(300; Einstandsbetrag; Decimal)
        {
            Caption = 'Einstandsbetrag';
        }
        field(400; "Last Posting Date"; Date)
        {
            Caption = 'Last Posting Date';
        }
        field(401; "Date of Posting"; Date)
        {
            Caption = 'Date of Posting';
        }
        field(402; "Userid of Posting"; Code[20])
        {
            Caption = 'Userid of Posting';
        }
        // field(800;"Created From Recipe Code";Code[20])
        // {
        //     Caption = 'Created From Recipe Code';
        //     TableRelation = "Recipe Header".No.;
        // }
        field(801; "Created From Customer No."; Code[20])
        {
            Caption = 'Created From Customer No.';
            TableRelation = Customer."No.";
        }
        field(802; "Created From Line No."; Integer)
        {
            Caption = 'Created From Line No.';
        }
        field(900; "Picking Type"; Option)
        {
            Caption = 'Picking Type';
            InitValue = Suggestion;
            OptionCaption = 'Allowance,Suggestion,No Allowance';
            OptionMembers = Allowance,Suggestion,"No Allowance";
        }
        field(901; "Automatic Picking"; Boolean)
        {
            Caption = 'Automatic Picking';
            Editable = false;
        }
        field(902; "Picking Source Line No."; Integer)
        {
            Caption = 'Picking Source Line No.';
        }
        field(903; "Picking Quantity"; Decimal)
        {
            Caption = 'Quantity to Assign';

            trigger OnValidate()
            begin
                CheckAttachedLines();
            end;
        }
        field(950; "Grab Items"; Option)
        {
            Caption = 'Rohware zusammenfassen';
            OptionMembers = " ","1","2","3","4","5","6","7","8","9";
        }
        field(50001; "Means of Transp. Code (Arriva)"; Code[20])
        {
            CalcFormula = Lookup ("POI Master Batch"."Means of Transp. Code (Arriva)" WHERE("No." = FIELD("Master Batch No.")));
            Caption = 'Transportmittel Code (Ankunft)';
            FieldClass = FlowField;
        }
        field(50002; "Expected Receipt Date"; Date)
        {
            CalcFormula = Lookup ("POI Master Batch"."Expected Receipt Date" WHERE("No." = FIELD("Master Batch No.")));
            Caption = 'Erwartetes Wareneingangsdatum';
            FieldClass = FlowField;
        }
        field(50005; "Manual Revenue Factor"; Decimal)
        {
            Caption = 'Manuelle Erlösfaktor';

            trigger OnValidate()
            begin
                IF "Manual Revenue Factor" > 100 THEN
                    ERROR('Der Erlösanteil kann nicht mehr als 100% betragen');
            end;
        }
        field(50010; "Empties Attached Line No."; Integer)
        {
        }
        field(50020; PurchOrderGenerated; Boolean)
        {
            Caption = 'EK-Bestellung aus Packauftrag angelegt';
        }
        field(50030; "Container No."; Code[20])
        {
            CalcFormula = Lookup ("POI Batch"."Container No." WHERE("No." = FIELD("Batch No.")));
            Editable = false;
            FieldClass = FlowField;
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
        field(5110324; "Batch Var. Detail Entry No."; Integer)
        {
            Caption = 'Batch Var. Detail Entry No.';
        }
        field(5110898; "Spectrum Caliber A-Goods"; Code[50])
        {
            Caption = 'Spectrum Caliber A-Goods';
            Description = 'MEV';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;
        }
        field(5110899; "Pack. Refrenznr."; Code[30])
        {
        }
    }

    keys
    {
        key(Key1; "Doc. No.", "Doc. Line No. Output", "Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Total Net Weight", "Total Gross Weight", "A-Goods Quantity (Base)", "Remaining Quantity", "Remaining Quantity (Base)", "Calc. Revenue Amount", "Calculatory Cost Amount", "Revenue Amount", "Cost Amount", "Amount (LCY)", Quantity;
        }
        key(Key2; "Item No.", "Variant Code", "Batch Variant No.", "Location Code")
        {
            SumIndexFields = "Quantity (Base)", "Quantity to Consume", "Remaining Quantity (Base)", "Remaining Quantity";
        }
        key(Key3; "Item No.", "Country of Origin Code", "Unit of Measure Code", "Caliber Code")
        {
        }
        key(Key4; "Master Batch No.", "Batch No.", "Batch Variant No.")
        {
            SumIndexFields = "Remaining Quantity";
        }
        key(Key5; "No Revenue")
        {
            SumIndexFields = "Total Net Weight", "Total Gross Weight", "A-Goods Quantity (Base)", "Remaining Quantity", "Remaining Quantity (Base)", "Calc. Revenue Amount", "Calculatory Cost Amount", "Revenue Amount", "Cost Amount", "Amount (LCY)", Quantity;
        }
        key(Key6; "Batch No.")
        {
        }
        key(Key7; "Batch Variant No.")
        {
        }
        key(Key8; "Doc. No.", "Item No.")
        {
        }
        key(Key9; "Batch Variant No.", "Location Code")
        {
            SumIndexFields = "Quantity (Base)", "Quantity to Consume", "Remaining Quantity (Base)", "Remaining Quantity";
        }
        key(Key10; "Item No.", "Variant Code", "Batch Variant No.", "Location Code", "Remaining Quantity")
        {
        }
        key(Key11; "Doc. No.", "Grab Items", "Line No.")
        {
        }
    }



    trigger OnDelete()
    var
        lrc_PackOrderComment: Record "POI Pack. Order Comment";
        lrc_PurchLine: Record "Purchase Line";
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
        lcu_PalletManagement: Codeunit "POI Pallet Management";
        AGILES_TEXT001Txt: Label 'Verbrauch ist bereits gebucht! Löschung nicht zulässig.';
    //lcu_PurchaseDispoMgt: Codeunit "5110380"; //TODO: dispo

    begin

        IF "Quantity Consumed" <> 0 THEN
            // Verbrauch ist bereits gebucht! Löschung nicht zulässig.
            ERROR(AGILES_TEXT001Txt);


        // Zeile darf nicht gelöscht werden, wenn damit verknüpfte Output Zeile einen Folgebeleg Planung hat
        //lcu_PurchaseDispoMgt.RebuildDispolineOnPackInput(Rec); //TODO: dispo


        lrc_PackOrderComment.RESET();
        lrc_PackOrderComment.SETRANGE("Doc. No.", "Doc. No.");
        lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
        lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Input Trade Item");
        lrc_PackOrderComment.SETRANGE("Source Line No.", "Line No.");
        IF lrc_PackOrderComment.FIND('-') THEN
            lrc_PackOrderComment.DELETEALL(TRUE);


        lcu_PalletManagement.ErrorIfOutgoingPalletLineEx_PI('', Rec);



        IF (Quantity <> "Quantity Consumed") AND ("Batch Variant No." <> '') THEN
            lcu_BatchManagement.OpenBatchVarStatusIfZero("Batch Variant No.");


        //RS Verbindung zu Leergutzeile in Artikelzeile löschen
        IF (("Item Typ" = "Item Typ"::"Empties Item") AND ("Attached to Line No." <> 0)) THEN BEGIN
            lrc_PackOrderInputItems.GET("Doc. No.", 0, "Attached to Line No.");
            lrc_PackOrderInputItems."Empties Item No." := '';
            // lrc_PackOrderInputItems."Empties Item Qty." := 0; //TODO: Feld Klären
            lrc_PackOrderInputItems."Empties Attached Line No." := 0;
            lrc_PackOrderInputItems.MODIFY();
        END;


        //RS zugehörige Leergutzeile löschen
        IF "Empties Attached Line No." <> 0 THEN BEGIN
            lrc_PackOrderInputItems.GET("Doc. No.", 0, "Empties Attached Line No.");
            lrc_PackOrderInputItems.DELETE(TRUE);
        END;

        //RS zugehörige Einkaufsbestellungszeile löschen, wenn automatisch generiert
        IF PurchOrderGenerated = TRUE THEN BEGIN
            VALIDATE(Quantity, 0);
            lrc_PurchLine.SETRANGE("POI Batch Variant No.", "Batch Variant No.");
            IF lrc_PurchLine.FINDSET(TRUE, TRUE) THEN
                lrc_PurchLine.DELETE(TRUE)
            ELSE
                MESSAGE('die zugehörige Einkaufszeile existiert nicht mehr');
        END;


        DeleteAttachedLines();
    end;

    trigger OnInsert()
    var
    //lrc_RecipePackingSetup: Record "5110701";
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");

        TESTFIELD("Doc. No.");
        lrc_PackOrderHeader.GET("Doc. No.");

        // IF "Production Line Code" = '' THEN
        //     "Production Line Code" := lrc_PackOrderHeader."Production Line Code"


        // IF "Location Code" = '' THEN  //TODO: receipt
        //     IF lrc_PackOrderHeader."Inp. Item Loc. Code" <> '' THEn
        //         VALIDATE("Location Code", lrc_PackOrderHeader."Inp. Item Loc. Code")
        //     ELSE BEGIN
        //         lrc_RecipePackingSetup.GET();
        //         IF lrc_RecipePackingSetup."Default Input Location Code" <> '' THEN
        //             VALIDATE("Location Code", lrc_RecipePackingSetup."Default Input Location Code")
        //         ELSE
        //             IF lrc_PackOrderHeader."Outp. Item Location Code" <> '' THEN
        //                 VALIDATE("Location Code", lrc_PackOrderHeader."Outp. Item Location Code");
        //     END;
    end;

    trigger OnModify()
    var
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");


        IF NOT lrc_PackOrderInputItems.GET("Doc. No.", "Doc. Line No. Output", "Line No.") THEN
            lrc_PackOrderInputItems.INIT();
        lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
                 lrc_PackOrderInputItems."Remaining Quantity (Base)" - "Remaining Quantity (Base)");

    end;

    trigger OnRename()
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;

    var
        gcu_StockMgt: Codeunit "POI Stock Management";
        gbn_IndirectCall: Boolean;

    procedure "^"(vin_FieldNo: Integer)
    var
        lrc_Batch: Record "POI Batch";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_Item: Record Item;
        lco_BatchVariantNo: Code[20];
        TEXT001Txt: Label 'Artikelnr. aus Positionsvariante abweichend !';

    begin
        // ----------------------------------------------------------------------------
        // Validate Fields: Master Batch No., Batch No, Batch Variant No.
        // ----------------------------------------------------------------------------

        CASE vin_FieldNo OF
            // Partienummer
            FIELDNO("Master Batch No."):
                BEGIN
                    IF "Master Batch No." = '' THEN BEGIN
                        "Batch No." := '';
                        "Batch Variant No." := '';
                        EXIT;
                    END;
                    IF Rec."Master Batch No." <> xRec."Master Batch No." THEN BEGIN
                        "Batch No." := '';
                        "Batch Variant No." := '';
                        Quantity := 0;
                    END;
                END;

            // Positionsnummer
            FIELDNO("Batch No."):
                BEGIN

                    // Positionsvariante zurücksetzen
                    "Batch Variant No." := '';
                    // Keine Eingabe
                    IF "Batch No." = '' THEN
                        EXIT;


                    // Partie lesen und setzen
                    lrc_Batch.GET("Batch No.");
                    "Master Batch No." := lrc_Batch."Master Batch No.";
                END;

            // Positionsvariantennummer
            FIELDNO("Batch Variant No."):
                BEGIN

                    IF "Item No." <> '' THEN BEGIN
                        lrc_Item.GET("Item No.");
                        lrc_Item.TESTFIELD("POI Batch Item");
                    END;

                    // Keine Eingabe
                    IF "Batch Variant No." = '' THEN BEGIN
                        "Master Batch No." := '';
                        "Batch No." := '';
                        EXIT;
                    END;

                    // Batchvariante lesen
                    lrc_BatchVariant.GET("Batch Variant No.");
                    lrc_BatchVariant.TESTFIELD(State, lrc_BatchVariant.State::Open);

                    // Kontrolle Artikelnr. aus Zeile und Artikelnr. aus Batchvariante
                    IF ("Item No." <> '') AND (lrc_BatchVariant."Item No." <> "Item No.") THEN
                        // Artikelnr. aus Positionsvariante abweichend!
                        ERROR(TEXT001Txt);

                    // Artikelnr. setzen
                    IF "Item No." = '' THEN BEGIN
                        lco_BatchVariantNo := "Batch Variant No.";
                        VALIDATE("Item No.", lrc_BatchVariant."Item No.");
                        "Batch Variant No." := lco_BatchVariantNo;
                    END;

                    VALIDATE("Unit of Measure Code", lrc_BatchVariant."Unit of Measure Code");
                    "Transport Unit of Measure (TU)" := lrc_BatchVariant."Transport Unit of Measure (TU)";
                    "Qty. (Unit) per Transp.(TU)" := lrc_BatchVariant."Qty. (Unit) per Transp. (TU)";

                    VALIDATE("Location Code", lrc_BatchVariant."Entry Location Code");

                    // Werte aus Positionsvariante in Zeile setzen
                    "Master Batch No." := lrc_BatchVariant."Master Batch No.";
                    "Batch No." := lrc_BatchVariant."Batch No.";

                    "Variant Code" := lrc_BatchVariant."Variant Code";
                    "Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
                    "Variety Code" := lrc_BatchVariant."Variety Code";
                    "Trademark Code" := lrc_BatchVariant."Trademark Code";
                    "Caliber Code" := lrc_BatchVariant."Caliber Code";
                    "Quality Code" := lrc_BatchVariant."Item Attribute 3";
                    "Color Code" := lrc_BatchVariant."Item Attribute 2";
                    "Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
                    "Conservation Code" := lrc_BatchVariant."Item Attribute 7";
                    "Packing Code" := lrc_BatchVariant."Item Attribute 4";
                    "Coding Code" := lrc_BatchVariant."Coding Code";
                    "Treatment Code" := lrc_BatchVariant."Item Attribute 5";
                    "Info 1" := lrc_BatchVariant."Info 1";
                    "Info 2" := lrc_BatchVariant."Info 2";
                    "Info 3" := lrc_BatchVariant."Info 3";
                    "Info 4" := lrc_BatchVariant."Info 4";
                    "Empties Item No." := lrc_BatchVariant."Empties Item No.";
                END;
        END;
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

            VALIDATE("Gross Weight", lrc_UnitofMeasure."POI Gross Weight");
            VALIDATE("Net Weight", lrc_UnitofMeasure."POI Net Weight");

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

    procedure CheckAttachedLines()
    var
        ldc_PostedQuantity: Decimal;
        AGILESText001Txt: Label 'Quantity %1 lower that Quantity %2 in attached Lines.', Comment = '%1 %2';
    begin
        ldc_PostedQuantity := 0;
        lrc_PackOrderInputItems.RESET();
        lrc_PackOrderInputItems.SETRANGE("Doc. No.", "Doc. No.");
        lrc_PackOrderInputItems.SETRANGE("Picking Source Line No.", "Line No.");
        IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
            REPEAT
                ldc_PostedQuantity := ldc_PostedQuantity + lrc_PackOrderInputItems."Quantity Consumed";
            UNTIL lrc_PackOrderInputItems.NEXT() = 0;

            IF "Picking Quantity" < ldc_PostedQuantity THEN
                ERROR(AGILESText001Txt, "Picking Quantity", ldc_PostedQuantity);
        END;
    end;

    procedure DeleteAttachedLines()
    var
        ldc_PostedQuantity: Decimal;
        AGILESText001Txt: Label 'Line can not be deleted. Posted Quantity in attached Lines.';
    begin
        ldc_PostedQuantity := 0;
        lrc_PackOrderInputItems.RESET();
        lrc_PackOrderInputItems.SETRANGE("Doc. No.", "Doc. No.");
        lrc_PackOrderInputItems.SETRANGE("Picking Source Line No.", "Line No.");
        IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
            REPEAT
                ldc_PostedQuantity := ldc_PostedQuantity + lrc_PackOrderInputItems."Quantity Consumed";
            UNTIL lrc_PackOrderInputItems.NEXT() = 0;

            IF ldc_PostedQuantity > 0 THEN
                ERROR(AGILESText001Txt);

            lrc_PackOrderInputItems.DELETEALL(TRUE);
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
        lrc_PackOrderInput: Record "POI Pack. Order Input Items";
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_PackOrderOutputItems: Record "POI Pack. Order Input Items";
}

