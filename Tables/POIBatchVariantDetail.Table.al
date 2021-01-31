table 5110487 "POI Batch Variant Detail"
{

    Caption = 'Batch Variant Detail';
    // DrillDownFormID = Form5110619;
    // LookupFormID = Form5110619;
    PasteIsValid = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(9; Source; Option)
        {
            Caption = 'Source';
            Description = ' ,Purchase,Sales,Transfer,Item Journal';
            OptionCaption = ' ,Purchase,Sales,Transfer,Item Journal';
            OptionMembers = " ",Purchase,Sales,Transfer,"Item Journal";
        }
        field(10; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Description = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Input Packerei,Output Packerei,,,Transfer,Ship Transfer,Receive Transfer,,,Item Journal';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Input Packerei,Output Packerei,,,Transfer,Ship Transfer,Receive Transfer,,,Item Journal';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,"Input Packerei","Output Packerei",,,Transfer,"Ship Transfer","Receive Transfer",,,"Item Journal";
        }
        field(11; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(12; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(15; "Sales Shipment Date"; Date)
        {
            Caption = 'Sales Shipment Date';
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(21; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(30; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";

            trigger OnValidate()
            begin
                "Batch No." := '';
                "Batch Variant No." := '';
            end;
        }
        field(31; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = IF ("Master Batch No." = FILTER(<> '')) "POI Batch" WHERE("Master Batch No." = FIELD("Master Batch No."))
            ELSE
            "POI Batch";

            trigger OnValidate()
            var
                lrc_Batch: Record "POI Batch";
            begin
                IF "Batch No." <> '' THEN BEGIN
                    lrc_Batch.GET("Batch No.");
                    IF "Master Batch No." <> lrc_Batch."Master Batch No." THEN
                        "Master Batch No." := lrc_Batch."Master Batch No.";
                    "Batch Variant No." := '';
                END ELSE
                    "Batch Variant No." := '';
            end;
        }
        field(32; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF ("Batch No." = FILTER(<> '')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                                               "Variant Code" = FIELD("Variant Code"),
                                                                               "Batch No." = FIELD("Batch No."))
            ELSE
            "POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                                                                           "Variant Code" = FIELD("Variant Code"));

            trigger OnValidate()
            var

                lrc_BatchVariant: Record "POI Batch Variant";
                lrc_BatchVariantDetail: Record "POI Batch Variant Detail";
            //lcu_ExtendedDimensionMgt: Codeunit "5087916";
            begin
                IF "Batch Variant No." <> '' THEN BEGIN
                    TESTFIELD("Item No.");
                    lrc_BatchVariant.GET("Batch Variant No.");

                    // Kontrolle ob die Positionsvariante bereits enthalten ist
                    lrc_BatchVariantDetail.SETRANGE("Entry No.", "Entry No.");
                    lrc_BatchVariantDetail.SETFILTER("Line No.", '<>%1', "Line No.");
                    lrc_BatchVariantDetail.SETRANGE("Batch Variant No.", "Batch Variant No.");
                    IF not lrc_BatchVariantDetail.IsEmpty() THEN
                        // Positionsvariante ist bereits enthalten!
                        ERROR(AGILES_TEXT001Txt);
                    IF "Item No." <> lrc_BatchVariant."Item No." THEN
                        // Artikelnr. Positionsvariante entspricht nicht der bezogenen Artikelnr.!
                        ERROR(AGILES_TEXT002Txt);
                    "Master Batch No." := lrc_BatchVariant."Master Batch No.";
                    "Batch No." := lrc_BatchVariant."Batch No.";
                    "Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";

                    //lcu_ExtendedDimensionMgt.EDM_BatchVarDetailItem(Rec);

                END ELSE
                    "Expected Receipt Date" := 0D;
            end;
        }
        field(33; "Pack. Lot No."; Code[20])
        {
            Caption = 'Pack. Lot No.';
        }
        field(35; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(40; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(42; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(45; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            var
                lcu_StockMgt: Codeunit "POI Stock Management";
                lcu_CustomerSpecificFunctions: Codeunit "POI Customer Spec. Functions";
            begin
                // Kontrolle Feldinhalte
                TESTFIELD("Master Batch No.");
                TESTFIELD("Batch No.");
                TESTFIELD("Batch Variant No.");
                TESTFIELD("Qty. per Unit of Measure");

                // Kontrolle Wareneingangsdatum
                IF CurrFieldNo = FIELDNO(Quantity) THEN
                    IF Quantity <> 0 THEN
                        IF "Expected Receipt Date" <> 0D THEN
                            IF "Expected Receipt Date" > "Sales Shipment Date" THEN
                                IF NOT CONFIRM('ACHTUNG: Wareneingangsdatum Positionsvariante liegt hinter dem Warenausgangsdatum Verkauf!\' +
                                               'Möchten Sie trotzdem zuweisen?') THEN
                                    ERROR('');


                IF NOT gbn_NoBatchVarCheckAvail THEN


                    // Kontrolle ob Bestand die Menge zulässt
                    IF Quantity <> 0 THEN
                        lcu_StockMgt.BatchVarCheckAvail("Batch Variant No.", "Location Code", 0D,
                                                       (Quantity * "Qty. per Unit of Measure"),
                                                       (xRec.Quantity * "Qty. per Unit of Measure"));


                // Menge
                "Qty. (Base)" := Quantity * "Qty. per Unit of Measure";
                // Zu buchende Menge
                "Qty. to Post" := Quantity - "Qty. Posted";
                "Qty. to Post (Base)" := "Qty. (Base)" - "Qty. Posted (Base)";
                // Restmengen
                "Qty. Outstanding" := Quantity - "Qty. Posted";
                "Qty. Outstanding (Base)" := "Qty. (Base)" - "Qty. Posted (Base)";

                grc_FruitVisionSetup.GET();
                IF (grc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE') THEN
                    IF Quantity <> 0 THEN
                        lcu_CustomerSpecificFunctions.TestGuarShelfLifeFromVarDetail(Rec);

                IF CurrFieldNo <> 0 THEN
                    TESTFIELD("Automatic Picking", FALSE);


                IF NOT gbn_KeepOriginalQuantity THEN
                    "Original Picking Quantity" := Quantity;

                "Qty. to Post" := Quantity - "Qty. Posted";
                "Qty. to Post (Base)" := "Qty. (Base)" - "Qty. Posted (Base)";

                CalcBlanketOrderOutstQuantity("Entry No.", 0);
            end;
        }
        field(48; "Qty. to Post"; Decimal)
        {
            Caption = 'Qty. to Post';

            trigger OnValidate()
            begin

                IF "Qty. to Post" > (Quantity - "Qty. Posted") THEN
                    ERROR('Menge zu buchen darf nicht größer als Menge sein!');

                IF CurrFieldNo <> 0 THEN
                    TESTFIELD("Automatic Picking", FALSE);

            end;
        }
        field(50; "Qty. Posted"; Decimal)
        {
            Caption = 'Qty. Posted';

            trigger OnValidate()
            begin
                "Qty. to Post" := Quantity - "Qty. Posted";
                "Qty. to Post (Base)" := "Qty. (Base)" - "Qty. Posted (Base)";
            end;
        }
        field(51; "Qty. Outstanding"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. Outstanding';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                CalcBlanketOrderOutstQuantity("Entry No.", 0);
            end;
        }
        field(60; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(61; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 6;
        }
        field(62; "Qty. (Base)"; Decimal)
        {
            Caption = 'Qty. (Base)';

            trigger OnValidate()
            begin
                CalcBlanketOrderOutstQuantity("Entry No.", 0);
            end;
        }
        field(64; "Qty. to Post (Base)"; Decimal)
        {
            Caption = 'Qty. to Post (Base)';
        }
        field(66; "Qty. Posted (Base)"; Decimal)
        {
            Caption = 'Qty. Posted (Base)';
        }
        field(67; "Qty. Outstanding (Base)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. Outstanding (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                CalcBlanketOrderOutstQuantity("Entry No.", 0);
            end;
        }
        field(98; "Qty. Source Line"; Decimal)
        {
            Caption = 'Qty. Source Line';
        }
        field(99; "Source from Doc. Line"; Boolean)
        {
            Caption = 'Source from Doc. Line';
        }
        // field(100; "Qty. Batch Var. Entry (Base)"; Decimal)
        // {
        //     CalcFormula = - Sum ("Batch Variant Entry"."Quantity (Base)" WHERE("Detail Entry No." = FIELD("Entry No."),
        //                                                                       "Detail Line No." = FIELD("Line No.")));
        //     Caption = 'Qty. Batch Var. Entry (Base)';
        //     DecimalPlaces = 0 : 5;
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(101; "Lot No. Producer"; Code[20])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Lot No. Producer" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Lot No. Producer';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Variety Code"; Code[10])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Variant Code" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Variety Code';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            //TableRelation = Variety;
        }
        field(111; "Trademark Code"; Code[20])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Trademark Code" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Trademark Code';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            //TableRelation = Trademark;
        }
        field(112; "Caliber Code"; Code[10])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Caliber Code" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Caliber Code';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            //TableRelation = Caliber;
            //ValidateTableRelation = false;
        }
        field(113; "Means of Transp. Code (Arriva)"; Code[20])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Means of Transp. Code (Arriva)" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Means of Transp. Code (Arriva)';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(300; "Number of Pallet Item Lines"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count ("POI Pallet - Item Lines" WHERE("Batch Variant No." = FIELD("Batch Variant No."),
                                                              "Batch No." = FIELD("Batch No."),
                                                              "Master Batch No." = FIELD("Master Batch No."),
                                                              "Item No." = FIELD("Item No."),
                                                              "Location Code" = FIELD("Location Code"),
                                                              "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                              "Variant Code" = FIELD("Variant Code")));
            Caption = 'Number of Pallet Item Lines';
            Description = 'PAL Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(301; "Qty(Base) of Pallet Item Lines"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum ("POI Pallet - Item Lines"."Quantity (Base)" WHERE("Batch Variant No." = FIELD("Batch Variant No."),
                                                                              "Batch No." = FIELD("Batch No."),
                                                                              "Master Batch No." = FIELD("Master Batch No."),
                                                                              "Item No." = FIELD("Item No."),
                                                                              "Location Code" = FIELD("Location Code"),
                                                                              "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                              "Variant Code" = FIELD("Variant Code")));
            Caption = 'Quantity (Base) Pallet Item Lines';
            DecimalPlaces = 0 : 5;
            Description = 'PAL Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(302; "Quantity Pallet Item Lines"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum ("POI Pallet - Item Lines".Quantity WHERE("Batch Variant No." = FIELD("Batch Variant No."),
                                                                     "Batch No." = FIELD("Batch No."),
                                                                     "Master Batch No." = FIELD("Master Batch No."),
                                                                     "Item No." = FIELD("Item No."),
                                                                     "Location Code" = FIELD("Location Code"),
                                                                     "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                     "Variant Code" = FIELD("Variant Code")));
            Caption = 'Quantity Pallet Item Lines';
            DecimalPlaces = 0 : 5;
            Description = 'PAL Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(310; "Number of Outgoing Pallet Line"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count ("POI Outgoing Pallet" WHERE("Batch Variant No." = FIELD("Batch Variant No."),
                                                          "Batch No." = FIELD("Batch No."),
                                                          "Master Batch No." = FIELD("Master Batch No."),
                                                          "Item No." = FIELD("Item No."),
                                                          "Location Code" = FIELD("Location Code"),
                                                          "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                          "Variant Code" = FIELD("Variant Code"),
                                                          "Document Type" = CONST("Sales Order"),
                                                          "Document No." = FIELD("Source No."),
                                                          "Document Line No." = FIELD("Source Line No.")));
            Caption = 'Number of Outgoing Pallet Line';
            Description = 'PAL Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(311; "Qty (Base) Outgoing Pallet"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum ("POI Outgoing Pallet"."Quantity (Base)" WHERE("Batch Variant No." = FIELD("Batch Variant No."),
                                                                          "Batch No." = FIELD("Batch No."),
                                                                          "Master Batch No." = FIELD("Master Batch No."),
                                                                          "Item No." = FIELD("Item No."),
                                                                          "Location Code" = FIELD("Location Code"),
                                                                          "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                          "Variant Code" = FIELD("Variant Code"),
                                                                          "Document Type" = CONST("Sales Order"),
                                                                          "Document No." = FIELD("Source No."),
                                                                          "Document Line No." = FIELD("Source Line No.")));
            Caption = 'Quantity (Base) Outgoing Pallet';
            DecimalPlaces = 0 : 5;
            Description = 'PAL Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(400; "Picking Type"; Option)
        {
            Caption = 'Picking Type';
            Description = 'Allowance,Suggestion,No Allowance';
            InitValue = Suggestion;
            OptionCaption = 'Allowance,Suggestion,No Allowance';
            OptionMembers = Allowance,Suggestion,"No Allowance";
        }
        field(401; "Automatic Picking"; Boolean)
        {
            Caption = 'Automatic Picking';
            Editable = false;

            trigger OnValidate()
            begin
                IF CurrFieldNo <> 0 THEN
                    TESTFIELD("Automatic Picking", FALSE);
            end;
        }
        field(402; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
        }
        field(403; "Original Picking Quantity"; Decimal)
        {
            Caption = 'Original Picking Quantity';
            Editable = false;
        }
        field(410; "Country of Origin Code"; Code[10])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Country of Origin Code" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Country of Origin Code';
            Description = 'FlowField';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(600; "Sales Source Document Status"; Option)
        // {
        //     CalcFormula = Lookup ("Sales Header"."Document Status" WHERE("Document Type" = FIELD("Source Type"),
        //                                                                  "No." = FIELD("Source No.")));
        //     Caption = 'Sales Source Document Status';
        //     Description = 'FlowField';
        //     FieldClass = FlowField;
        //     OptionCaption = 'Offen,Prüfung erforderlich,Erfassung abgeschlossen,,,Freigabe Kommissionierung,,Fehlerhafte Kommissionierung,Kommissionierung,,,Rückerfassung erfolgt,,,Lieferschein erstellt,,,Freigabe Fakturierung,,,,Faktura erstellt,,,,Abgeschlossen,,,Manuell Abgeschlossen,,,Storniert,,,Gelöscht';
        //     OptionMembers = Offen,"Prüfung erforderlich","Erfassung abgeschlossen",,,"Freigabe Kommissionierung",,"Fehlerhafte Kommissionierung",Kommissionierung,,,"Rückerfassung erfolgt",,,"Lieferschein erstellt",,,"Freigabe Fakturierung",,,,"Faktura erstellt",,,,Abgeschlossen,,,"Manuell Abgeschlossen",,,Storniert,,,"Gelöscht";
        // }
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
    }

    keys
    {
        key(Key1; "Entry No.", "Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Quantity, "Qty. to Post", "Qty. Posted", "Qty. Outstanding", "Qty. (Base)", "Qty. to Post (Base)", "Qty. Posted (Base)", "Qty. Outstanding (Base)";
        }
        key(Key2; "Item No.", "Variant Code", "Batch Variant No.", "Location Code", "Sales Shipment Date")
        {
            SumIndexFields = Quantity, "Qty. to Post", "Qty. Posted", "Qty. Outstanding", "Qty. (Base)", "Qty. to Post (Base)", "Qty. Posted (Base)", "Qty. Outstanding (Base)";
        }
        key(Key3; Source, "Source Type", "Batch Variant No.", "Location Code", "Sales Shipment Date")
        {
            SumIndexFields = Quantity, "Qty. to Post", "Qty. Posted", "Qty. Outstanding", "Qty. (Base)", "Qty. to Post (Base)", "Qty. Posted (Base)", "Qty. Outstanding (Base)";
        }
        key(Key4; Source, "Source Type", "Source No.", "Source Line No.", "Batch Variant No.", "Item No.", "Location Code")
        {
            SumIndexFields = Quantity, "Qty. to Post", "Qty. Posted", "Qty. Outstanding", "Qty. (Base)", "Qty. to Post (Base)", "Qty. Posted (Base)", "Qty. Outstanding (Base)";
        }
        key(Key5; "Item No.", "Master Batch No.", "Batch No.", "Batch Variant No.")
        {
        }
        key(Key6; "Expected Receipt Date")
        {
            SumIndexFields = Quantity, "Qty. to Post", "Qty. Posted", "Qty. Outstanding", "Qty. (Base)", "Qty. to Post (Base)", "Qty. Posted (Base)", "Qty. Outstanding (Base)";
        }
        key(Key7; Source, "Source Type", "Source No.", "Source Line No.", "Date of Expiry", "Expected Receipt Date")
        {
        }
        key(Key8; "Automatic Picking")
        {
        }
        key(Key9; "Batch Variant No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
    begin

        CheckScanUser();

        IF (Quantity <> "Qty. Posted") AND
           ("Batch Variant No." <> '') THEN
            lcu_BatchManagement.OpenBatchVarStatusIfZero("Batch Variant No.");


    end;

    trigger OnInsert()
    var
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
        lrc_Rec_RemainingQtyBase: Decimal;
        lrc_RemainingQtyBase: Decimal;
    begin
        CheckScanUser();

        TESTFIELD("Entry No.");
        IF "Line No." = 0 THEN BEGIN
            lrc_BatchVariantDetail.SETRANGE("Entry No.", "Entry No.");
            IF lrc_BatchVariantDetail.FIND('+') THEN
                "Line No." := lrc_BatchVariantDetail."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        lrc_Rec_RemainingQtyBase := "Qty. (Base)" - "Qty. Posted (Base)";
        IF NOT lrc_BatchVariantDetail.GET("Entry No.", "Line No.") THEN
            lrc_BatchVariantDetail.INIT();
        lrc_RemainingQtyBase := lrc_BatchVariantDetail."Qty. (Base)" - lrc_BatchVariantDetail."Qty. Posted (Base)";
        lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
                                                       lrc_RemainingQtyBase - lrc_Rec_RemainingQtyBase);
    end;

    trigger OnModify()
    var
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
        //lcu_ExtendedDimensionMgt: Codeunit "5087916";
        lrc_Rec_RemainingQtyBase: Decimal;
        lrc_RemainingQtyBase: Decimal;
    begin
        CheckScanUser();


        //lcu_ExtendedDimensionMgt.EDM_BatchVarDetailItem(Rec);



        lrc_Rec_RemainingQtyBase := "Qty. (Base)" - "Qty. Posted (Base)";
        IF NOT lrc_BatchVariantDetail.GET("Entry No.", "Line No.") THEN
            lrc_BatchVariantDetail.INIT();
        lrc_RemainingQtyBase := lrc_BatchVariantDetail."Qty. (Base)" - lrc_BatchVariantDetail."Qty. Posted (Base)";
        lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
                                                       lrc_RemainingQtyBase - lrc_Rec_RemainingQtyBase);
    end;

    trigger OnRename()
    begin

        CheckScanUser();
    end;

    var
        grc_FruitVisionSetup: Record "POI ADF Setup";
        //gdc_RefQty: Decimal;

        gbn_KeepOriginalQuantity: Boolean;
        AGILES_TEXT001Txt: Label 'Positionsvariante ist bereits enthalten!';
        AGILES_TEXT002Txt: Label 'Artikelnr. Positionsvariante entspricht nicht der bezogenen Artikelnr.!';
        gbn_NoBatchVarCheckAvail: Boolean;

    procedure SetReferenceQty(vdc_RefQty: Decimal)
    begin
    end;

    procedure ValidatePackLotNo()
    begin
    end;

    procedure SetKeepOriginalQuantity()
    begin
        gbn_KeepOriginalQuantity := TRUE;
    end;

    procedure CheckScanUser()
    var
    //lrc_SalesHeader: Record "Sales Header";
    begin
        // IF GUIALLOWED() THEN
        //     CASE Source OF
        //         Source::Sales:
        //             IF lrc_SalesHeader.GET("Source Type", "Source No.") THEN
        //                 IF lrc_SalesHeader."Scanner User ID" <> '' THEN
        //                     lrc_SalesHeader.FIELDERROR("Scanner User ID"); //TODO: scanner user id in sales Header
        //     END;
    end;

    procedure SetNoBatchVarCheckAvail()
    begin

        gbn_NoBatchVarCheckAvail := TRUE;

    end;

    procedure CalcBlanketOrderOutstQuantity(vin_EntryNo: Integer; vdc_Quantity: Decimal)
    var
        ldc_SalesQuantityBase: Decimal;
        ldc_SalesQuantity: Decimal;
    begin
        IF vin_EntryNo <> 0 THEN
            GET(vin_EntryNo, 1);

        IF "Source Type" = "Source Type"::"Blanket Order" THEN BEGIN
            lrc_SalesLine.SETCURRENTKEY("Document Type", "Blanket Order No.", "Blanket Order Line No.");
            lrc_SalesLine.SETRANGE("Blanket Order No.", "Source No.");
            lrc_SalesLine.SETRANGE("Blanket Order Line No.", "Source Line No.");
            IF lrc_SalesLine.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    ldc_SalesQuantity := ldc_SalesQuantity + lrc_SalesLine.Quantity;
                    ldc_SalesQuantityBase := ldc_SalesQuantityBase + lrc_SalesLine."Quantity (Base)" -
                                             lrc_SalesLine."Quantity Invoiced";
                UNTIL lrc_SalesLine.NEXT() = 0;
            lrc_SalesShipmentLine.SETCURRENTKEY("Blanket Order No.", "Blanket Order Line No.");
            lrc_SalesShipmentLine.SETRANGE("Blanket Order No.", "Source No.");
            lrc_SalesShipmentLine.SETRANGE("Blanket Order Line No.", "Source Line No.");
            IF lrc_SalesShipmentLine.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    ldc_SalesQuantity := ldc_SalesQuantity + lrc_SalesShipmentLine.Quantity - lrc_SalesShipmentLine."Quantity Invoiced";
                    ldc_SalesQuantityBase := ldc_SalesQuantityBase + lrc_SalesShipmentLine."Quantity (Base)" -
                                             (lrc_SalesShipmentLine."Quantity Invoiced" / lrc_SalesShipmentLine."Qty. per Unit of Measure");
                UNTIL lrc_SalesShipmentLine.NEXT() = 0;
            lrc_SalesInvoiceLine.SETCURRENTKEY("Blanket Order No.", "Blanket Order Line No.");
            lrc_SalesInvoiceLine.SETRANGE("Blanket Order No.", "Source No.");
            lrc_SalesInvoiceLine.SETRANGE("Blanket Order Line No.", "Source Line No.");
            IF lrc_SalesInvoiceLine.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    ldc_SalesQuantity := ldc_SalesQuantity + lrc_SalesInvoiceLine.Quantity;
                    ldc_SalesQuantityBase := ldc_SalesQuantityBase + lrc_SalesInvoiceLine."Quantity (Base)";
                UNTIL lrc_SalesInvoiceLine.NEXT() = 0;
            lrc_SalesCrMemoLine.SETCURRENTKEY("Blanket Order No.", "Blanket Order Line No.");
            lrc_SalesCrMemoLine.SETRANGE("Blanket Order No.", "Source No.");
            lrc_SalesCrMemoLine.SETRANGE("Blanket Order Line No.", "Source Line No.");
            IF lrc_SalesCrMemoLine.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    ldc_SalesQuantity := ldc_SalesQuantity - lrc_SalesCrMemoLine.Quantity;
                    ldc_SalesQuantityBase := ldc_SalesQuantityBase - lrc_SalesCrMemoLine."Quantity (Base)";
                UNTIL lrc_SalesCrMemoLine.NEXT() = 0;
            "Qty. Outstanding" := Quantity - ldc_SalesQuantity - vdc_Quantity;
            "Qty. Outstanding (Base)" := "Qty. (Base)" - ldc_SalesQuantityBase - (vdc_Quantity / "Qty. per Unit of Measure");
            MODIFY();
        END;
    end;

    var
        lrc_BatchVariantDetail: Record "POI Batch Variant Detail";
        lrc_SalesLine: Record "Sales Line";
        lrc_SalesInvoiceLine: Record "Sales Invoice Line";
        lrc_SalesShipmentLine: Record "Sales Shipment Line";
        lrc_SalesCrMemoLine: Record "Sales Cr.Memo Line";
}

