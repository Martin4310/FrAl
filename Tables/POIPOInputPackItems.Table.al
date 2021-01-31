table 5110715 "POI PO Input Pack. Items"
{

    Caption = 'Pack. Order Input Pack. Items';
    PasteIsValid = false;

    fields
    {
        field(1; "Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
        }
        field(2; "Doc. Line No. Output"; Integer)
        {
            Caption = 'Doc. Line No. Output';
            TableRelation = "POI Pack. Order Output Items"."Line No." WHERE("Doc. No." = FIELD("Doc. No."));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No." WHERE("POI Item Typ" = FILTER("Packing Material" | "Empties Item" | "Transport Item"));

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            //lcu_RecipePackingManagement: Codeunit "5110700";
            begin
                IF "Item No." <> '' THEN BEGIN
                    lrc_Item.GET("Item No.");

                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Item Category Code" := lrc_Item."Item Category Code";
                    //"Product Group Code" := lrc_Item."Product Group Code";

                    "Item Typ" := lrc_Item."POI Item Typ";

                    "Base Unit of Measure Code" := lrc_Item."Base Unit of Measure";
                    IF lrc_Item."Purch. Unit of Measure" <> '' THEN
                        "Unit of Measure Code" := lrc_Item."Purch. Unit of Measure"
                    ELSE
                        "Unit of Measure Code" := "Base Unit of Measure Code";

                    VALIDATE("Unit of Measure Code");
                    VALIDATE(Quantity, 0);

                    //VALIDATE("Direct Unit Cost (LCY)",lcu_RecipePackingManagement.FindItemDirectUnitPrice("Item No.", "Batch Variant No."));

                END ELSE BEGIN

                    "Item Description" := '';
                    "Item Description 2" := '';
                    "Item Category Code" := '';
                    "Product Group Code" := '';

                    "Base Unit of Measure Code" := '';
                    "Unit of Measure Code" := '';
                    VALIDATE("Unit of Measure Code");
                    VALIDATE(Quantity, 0);

                    VALIDATE("Direct Unit Cost (LCY)", 0);

                END;
            end;
        }
        field(11; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(12; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";

            trigger OnValidate()
            begin
                ValidateBatch(FIELDNO("Master Batch No."));
            end;
        }
        field(13; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = IF ("Master Batch No." = FILTER(<> '')) "POI Batch"."No." WHERE("Master Batch No." = FIELD("Master Batch No."))
            ELSE
            IF ("Master Batch No." = FILTER('')) "POI Batch"."No.";

            trigger OnValidate()
            begin
                ValidateBatch(FIELDNO("Batch No."));
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
                lrc_Item: Record Item;
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
            //lcu_RecipePackingMgt: Codeunit "5110700";

            begin
                ValidateBatch(FIELDNO("Batch Variant No."));


                IF (Quantity <> 0) AND ("Location Code" <> '') THEN BEGIN
                    // Bestandskontrolle
                    lrc_Item.GET("Item No.");
                    IF (lrc_Item."POI Batch Item" = TRUE) AND ("Batch Variant No." <> '') THEN
                        gcu_StockMgt.BatchVarCheckAvail("Batch Variant No.", "Location Code", 0D, (Quantity * "Qty. per Unit of Measure"), 0);
                    VALIDATE(Quantity);
                END;

                IF xRec."Batch Variant No." <> '' THEN
                    lcu_BatchManagement.OpenBatchVarStatusIfZero(xRec."Batch Variant No.");

                IF "Batch Variant No." <> '' THEN
                    lcu_BatchManagement.BatchVariantRecalc("Item No.", "Batch Variant No.");

                // VALIDATE("Direct Unit Cost (LCY)",lcu_RecipePackingMgt.FindItemDirectUnitPrice("Item No.","Batch Variant No."));
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
            Editable = false;
            TableRelation = "Item Category";
        }
        field(19; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            Editable = false;
            TableRelation = "POI Product Group".Code;
        }
        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(31; "Location Group Code"; Code[10])
        {
            Caption = 'Location Group Code';
        }
        field(32; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
                SSPText01Txt: Label 'Es sind bereits verbrauchte Mengen vorhanden ! Änderung der Einheit nicht zulässig !';
            begin
                IF ("Unit of Measure Code" <> xRec."Unit of Measure Code") AND
                   ("Quantity Consumed" <> 0) THEN
                    // 'Es sind bereits verbrauchte Mengen vorhanden! Änderung der Einheit nicht zulässig!'
                    ERROR(SSPText01Txt);

                IF "Unit of Measure Code" <> '' THEN BEGIN
                    lrc_ItemUnitofMeasure.GET("Item No.", "Unit of Measure Code");
                    "Qty. per Unit of Measure" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
                    VALIDATE(Quantity, 0);
                END ELSE BEGIN
                    "Qty. per Unit of Measure" := 1;
                    VALIDATE(Quantity, 0);
                END;
            end;
        }
        field(33; "Unit of Measure"; Text[30])
        {
            Caption = 'Unit of Measure';
            Description = 'FH von 10 auf 30';
        }
        field(34; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            var
                lrc_PackOrderInputPackItems: Record "POI PO Input Pack. Items";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                SSPText01Txt: Label 'Menge darf nicht weniger als verbrauchte Menge sein !';

            begin
                IF (Quantity * "Quantity Consumed" < 0) OR
                   (ABS(Quantity) < ABS("Quantity Consumed"))
                THEN
                    // 'Menge darf nicht weniger als verbrauchte Menge sein !'
                    ERROR(SSPText01Txt);

                "Quantity to Consume" := Quantity - "Quantity Consumed";
                "Remaining Quantity" := Quantity - "Quantity Consumed";

                VALIDATE("Qty. per Unit of Measure");
                VALIDATE("Direct Unit Cost (LCY)");

                IF Quantity < xRec.Quantity THEN
                    lcu_BatchManagement.OpenBatchVarStatusIfZero("Batch Variant No.")
                ELSE BEGIN
                    IF NOT lrc_PackOrderInputPackItems.GET("Doc. No.", "Doc. Line No. Output", "Line No.") THEN
                        lrc_PackOrderInputPackItems.INIT();
                    lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
                     lrc_PackOrderInputPackItems."Remaining Quantity (Base)" - "Remaining Quantity (Base)");
                END;
            end;
        }
        field(35; "Quantity to Consume"; Decimal)
        {
            Caption = 'Quantity to Consume';

            trigger OnValidate()
            var
                POItext01Txt: Label 'Die zu verbrauchende Menge %1 darf die Restmenge %2 nicht übersteigen !', Comment = '%1 %2';
                POIText02Txt: Label 'Sie können nicht mehr stornieren %1 als gebucht ist %2 !', Comment = '%1 %2';
            begin
                IF "Quantity to Consume" < 0 THEN BEGIN
                    IF (ABS("Quantity to Consume") > "Quantity Consumed") THEN
                        // 'Sie können nicht mehr stornieren %1 als gebucht ist %2 !'
                        ERROR(POIText02Txt, "Quantity to Consume", "Quantity Consumed");
                END ELSE
                    IF ("Quantity to Consume" * Quantity < 0) OR (ABS("Quantity to Consume") > ABS("Remaining Quantity")) OR (Quantity * "Remaining Quantity" < 0) THEN
                        // 'Die zu verbrauchende Menge darf die Restmenge nicht übersteigen !'
                        ERROR(POItext01Txt, "Quantity to Consume", "Remaining Quantity");

                VALIDATE("Qty. per Unit of Measure");
            end;
        }
        field(36; "Quantity Consumed"; Decimal)
        {
            Caption = 'Quantity Consumed';
        }
        field(37; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
        }
        field(40; "Allocation Batch No."; Option)
        {
            Caption = 'Allocation Batch No.';
            Description = ' ,Verpackung,Palletten,Kolli,Nettogewicht,Bruttogewicht,Zeilen,Betrag';
            InitValue = "Net Weight";
            OptionCaption = ' ,Packing,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionMembers = " ",Packing,Pallets,Kolli,"Net Weight","Gross Weight",Lines,Amount;

            trigger OnValidate()
            var
                SSPText01Txt: Label 'This choice %1 is not yet possible !', Comment = '%1 ';
            begin
                IF ("Allocation Batch No." = "Allocation Batch No."::Pallets) OR
                   ("Allocation Batch No." = "Allocation Batch No."::"Gross Weight") OR
                   ("Allocation Batch No." = "Allocation Batch No."::Lines) THEN
                    // Diese Auswahl %1 ist noch nicht möglich !
                    ERROR(SSPText01Txt, FORMAT("Allocation Batch No."));
            end;
        }
        field(42; "Base Unit of Measure Code"; Code[10])
        {
            Caption = 'Base Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(43; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                "Quantity to Consume (Base)" := "Quantity to Consume" * "Qty. per Unit of Measure";
                "Quantity Consumed (Base)" := "Quantity Consumed" * "Qty. per Unit of Measure";
                "Remaining Quantity (Base)" := "Remaining Quantity" * "Qty. per Unit of Measure";
            end;
        }
        field(44; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(45; "Quantity to Consume (Base)"; Decimal)
        {
            Caption = 'Quantity to Consume (Base)';
        }
        field(46; "Quantity Consumed (Base)"; Decimal)
        {
            Caption = 'Quantity Consumed (Base)';
        }
        field(47; "Remaining Quantity (Base)"; Decimal)
        {
            Caption = 'Remaining Quantity (Base)';
        }
        field(50; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(51; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
        }
        field(54; "Lot No. Batch Variant"; Code[20])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Lot No. Producer" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Lot No. Batch Variant';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Direct Unit Cost (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost (LCY)';

            trigger OnValidate()
            begin
                "Amount (LCY)" := "Direct Unit Cost (LCY)" * Quantity;
            end;
        }
        field(61; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Amount (LCY)") THEN BEGIN
                    TESTFIELD(Quantity);
                    "Direct Unit Cost (LCY)" := "Amount (LCY)" / Quantity;
                END;
            end;
        }
        field(85; "Item Typ"; Option)
        {
            Caption = 'Item Typ';
            Description = 'Standard,Batch Item,Empties Item';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material";
        }
        field(200; Comment; Boolean)
        {
            CalcFormula = Exist ("POI Pack. Order Comment" WHERE("Doc. No." = FIELD("Doc. No."),
                                                             Type = CONST("Input Packing Material"),
                                                             "Source Line No." = FIELD("Line No.")));
            Caption = 'Comment';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(250; "Production Line Code"; Code[10])
        {
            Caption = 'Production Line Code';
            //TableRelation = "Production Lines".Code;

            // trigger OnValidate()
            // var
            //     lcu_RecipePackingManagement: Codeunit "5110700";
            // begin
            //     TESTFIELD( "Quantity Consumed", 0 );

            //     lcu_RecipePackingManagement.CheckExistingPaProductionLine( "Doc. No.", "Production Line Code" );
            // end;
        }
        field(401; "Date of Posting"; Date)
        {
            Caption = 'Date of Posting';
        }
        field(402; "Userid of Posting"; Code[20])
        {
            Caption = 'Userid of Posting';
        }
        field(800; "Created From Recipe Code"; Code[20])
        {
            Caption = 'Created From Recipe Code';
            //TableRelation = "Recipe Header"."No."";
        }
        field(801; "Created From Customer No."; Code[20])
        {
            Caption = 'Created From Customer No.';
            TableRelation = Customer."No.";
        }
        field(802; "Created From Line No."; Integer)
        {
            Caption = 'Created From Line No.';
        }
    }

    keys
    {
        key(Key1; "Doc. No.", "Doc. Line No. Output", "Line No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key2; "Item No.", "Variant Code", "Batch Variant No.", "Location Code")
        {
            SumIndexFields = "Quantity (Base)", "Quantity to Consume", "Remaining Quantity (Base)", "Remaining Quantity";
        }
        key(Key3; "Master Batch No.", "Batch No.", "Batch Variant No.")
        {
        }
        key(Key4; "Batch Variant No.", "Location Code")
        {
            SumIndexFields = "Quantity (Base)", "Quantity to Consume", "Remaining Quantity (Base)", "Remaining Quantity";
        }
        key(Key5; "Item No.", "Variant Code", "Batch Variant No.", "Location Code", "Remaining Quantity")
        {
        }
        key(Key6; "Batch Variant No.", "Posting Date")
        {
            SumIndexFields = "Remaining Quantity (Base)";
        }
    }

    trigger OnDelete()
    var
        lrc_PackOrderComment: Record "POI Pack. Order Comment";
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
        POI_TEXT001Txt: Label 'Menge verbraucht ungleich 0! Löschung nicht zulässig.';
    begin
        IF "Quantity Consumed" <> 0 THEN
            // Menge verbraucht ungleich 0! Löschung nicht zulässig.
            ERROR(POI_TEXT001Txt);


        lrc_PackOrderComment.RESET();
        lrc_PackOrderComment.SETRANGE("Doc. No.", "Doc. No.");
        lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
        lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Input Packing Material");
        lrc_PackOrderComment.SETRANGE("Source Line No.", "Line No.");
        IF lrc_PackOrderComment.FIND('-') THEN
            lrc_PackOrderComment.DELETEALL(TRUE);

        IF (Quantity <> "Quantity Consumed") AND ("Batch Variant No." <> '') THEN
            lcu_BatchManagement.OpenBatchVarStatusIfZero("Batch Variant No.");

    end;

    trigger OnInsert()
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");

        TESTFIELD("Doc. No.");
        lrc_PackOrderHeader.GET("Doc. No.");

        // IF "Production Line Code" = '' THEN
        //    "Production Line Code" := lrc_PackOrderHeader."Production Line Code"
    end;

    trigger OnModify()
    var
        lrc_PackOrderInputPackItems: Record "POI PO Input Pack. Items";
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
        IF NOT lrc_PackOrderInputPackItems.GET("Doc. No.", "Doc. Line No. Output", "Line No.") THEN
            lrc_PackOrderInputPackItems.INIT();
        lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
         lrc_PackOrderInputPackItems."Remaining Quantity (Base)" - "Remaining Quantity (Base)");
    end;

    trigger OnRename()
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;

    var
        gcu_StockMgt: Codeunit "POI Stock Management";

    procedure ValidateBatch(vin_FieldNo: Integer)
    var
        lrc_Batch: Record "POI Batch";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_Item: Record Item;
        lco_BatchVariantNo: Code[20];
        TEXT001Txt: Label 'Artikelnr. aus Positionsvariante abweichend !';
        ldc_Qty: Decimal;
    begin
        // ----------------------------------------------------------------------------
        // Validate Fields: Master Batch No., Batch No, Batch Variant No.
        // ----------------------------------------------------------------------------

        CASE vin_FieldNo OF
            // Partienummer
            FIELDNO("Master Batch No."):
                IF "Master Batch No." = '' THEN BEGIN
                    "Batch No." := '';
                    "Batch Variant No." := '';
                    EXIT;
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
                    IF "Batch Variant No." = '' THEN
                        EXIT;

                    // Batchvariante lesen
                    lrc_BatchVariant.GET("Batch Variant No.");

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
                    ldc_Qty := Quantity;
                    VALIDATE("Unit of Measure Code", lrc_BatchVariant."Unit of Measure Code");
                    VALIDATE(Quantity, ldc_Qty);
                    // Werte aus Positionsvariante in Zeile setzen
                    "Master Batch No." := lrc_BatchVariant."Master Batch No.";
                    "Batch No." := lrc_BatchVariant."Batch No.";

                    "Variant Code" := lrc_BatchVariant."Variant Code";
                END;
        END;
    end;

    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
}

