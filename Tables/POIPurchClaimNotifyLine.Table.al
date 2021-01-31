table 5110462 "POI Purch. Claim Notify Line"
{
    Caption = 'Purch. Claim Notify Line';
    // DrillDownFormID = Form5087975;
    // LookupFormID = Form5087975;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(9; Claim; Boolean)
        {
            Caption = 'Claim';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item';
            OptionMembers = " ",Item;

            trigger OnValidate()
            begin
                IF xRec.Type <> Type THEN
                    VALIDATE("No.", '');
            end;
        }
        field(11; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(Item)) Item;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
                lrc_StandardText: Record "Standard Text";
            begin
                IF "No." = '' THEN BEGIN
                    Description := '';
                    "Description 2" := '';
                    "Master Batch No." := '';
                    "Batch No." := '';
                    "Batch Variant No." := '';
                    "Variety Code" := '';
                    "Country of Origin Code" := '';
                    "Trademark Code" := '';
                    "Caliber Code" := '';
                    "Item Attribute 2" := '';
                    "Grade of Goods Code" := '';
                    "Item Attribute 7" := '';
                    "Item Attribute 4" := '';
                    "Coding Code" := '';
                    "Item Attribute 5" := '';
                    "Unit of Measure Code" := '';
                    "Base Unit of Measure (BU)" := '';
                    "Qty. per Unit of Measure" := 0;
                    Quantity := 0;
                    "Purch. Order No." := '';
                    "Purch. Order Line No." := 0;
                    EXIT;
                END;

                CASE Type OF
                    // Textbaustein
                    Type::" ":
                        BEGIN
                            lrc_StandardText.GET("No.");
                            Description := lrc_StandardText.Description;
                        END;
                    // Artikel
                    Type::Item:
                        BEGIN
                            lrc_Item.GET("No.");
                            Description := lrc_Item.Description;
                            "Description 2" := lrc_Item."Description 2";
                            "Master Batch No." := '';
                            "Batch No." := '';
                            "Batch Variant No." := '';
                            "Variety Code" := lrc_Item."POI Variety Code";
                            "Country of Origin Code" := lrc_Item."Country/Region of Origin Code";
                            "Trademark Code" := lrc_Item."POI Trademark Code";
                            "Caliber Code" := lrc_Item."POI Caliber Code";
                            "Item Attribute 2" := lrc_Item."POI Item Attribute 2";
                            "Grade of Goods Code" := lrc_Item."POI Grade of Goods Code";
                            "Item Attribute 7" := lrc_Item."POI Item Attribute 7";
                            "Item Attribute 4" := lrc_Item."POI Item Attribute 4";
                            "Coding Code" := lrc_Item."POI Coding Code";
                            "Item Attribute 5" := lrc_Item."POI Item Attribute 5";
                            "Unit of Measure Code" := lrc_Item."Base Unit of Measure";
                            "Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
                            "Qty. per Unit of Measure" := 1;
                            Quantity := 0;
                            "Purch. Order No." := '';
                            "Purch. Order Line No." := 0;
                        END;
                END;
            end;
        }
        field(12; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(13; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(15; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(16; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch";
        }
        field(17; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF (Type = CONST(Item),
                                "No." = FILTER(''),
                                "Master Batch No." = FILTER(''),
                                "Batch No." = FILTER('')) "POI Batch Variant"
            ELSE
            IF (Type = CONST(Item),
                                         "No." = FILTER(<> ''),
                                         "Master Batch No." = FILTER(''),
                                         "Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("No."))
            ELSE
            IF (Type = CONST(Item),
                                                  "Master Batch No." = FILTER(<> ''),
                                                  "Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("No."),
                                                                                               "Master Batch No." = FIELD("Master Batch No."))
            ELSE
            IF (Type = CONST(Item),
                                                                                                        "Master Batch No." = FILTER(<> ''),
                                                                                                        "Batch No." = FILTER(<> '')) "POI Batch Variant" WHERE("Item No." = FIELD("No."),
                                                                                                                                                       "Master Batch No." = FIELD("Master Batch No."),
                                                                                                                                                       "Batch No." = FIELD("Batch No."));
        }
        field(18; "Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
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
        field(24; "Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(25; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods";
        }
        field(26; "Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(27; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(28; "Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(30; "Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(31; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";
        }
        field(32; "Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(33; "Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3";
        }
        field(34; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
        }
        field(35; "Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(36; "Cultivation Association Code"; Code[10])
        {
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Cultivation Association";
        }
        field(40; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(41; "Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            Editable = false;
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(42; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            Editable = false;
        }
        field(44; "Quantity Received"; Decimal)
        {
            Caption = 'Quantity Received';
        }
        field(45; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                // Menge Paletten berechnen
                IF "Qty. (CU) per Pallet (TU)" <> 0 THEN
                    "Quantity (TU)" := Quantity / "Qty. (CU) per Pallet (TU)"
                ELSE
                    "Quantity (TU)" := 0;
            end;
        }
        field(48; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(50; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(51; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(60; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            Description = 'DSD';
            TableRelation = "Unit of Measure" WHERE("POI Is Packing Unit of Measure" = CONST(true));
        }
        field(61; "Qty. (PU) per Collo (CU)"; Decimal)
        {
            Caption = 'Qty. (PU) per Collo (CU)';
        }
        field(62; "Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';
        }
        field(63; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnLookup()
            var
                lrc_ItemTransportUnitFactor: Record "POI Factor Transport Unit";
                lrc_PurchClaimHeader: Record "POI Purch. Claim Notify Header";
                lcu_UnitMgt: Codeunit "POI Unit Mgt";
                //lcu_PalletManagement: Codeunit "POI Pallet Management";
                ldc_PalletFaktor: Decimal;
            begin
                // hier.s
                TESTFIELD("Qty. per Unit of Measure");
                TransportUnitOfMeasure_Validat();

                IF ("Transport Unit of Measure (TU)" <> '') AND
                   ("Transport Unit of Measure (TU)" <> xRec."Transport Unit of Measure (TU)") AND
                   (CurrFieldNo <> 0) THEN BEGIN
                    lrc_PurchClaimHeader.GET("Document No.");
                    lcu_UnitMgt.GetItemVendorUnitPalletFactor("No.",
                                                              lrc_ItemTransportUnitFactor."Reference Typ"::Vendor,
                                                              lrc_PurchClaimHeader."Buy-from Vendor No.",
                                                              "Unit of Measure Code",
                                                              "Qty. per Unit of Measure",
                                                              '',
                                                              "Transport Unit of Measure (TU)",
                                                              ldc_PalletFaktor);
                    IF ldc_PalletFaktor <> 0 THEN BEGIN
                        "Qty. (CU) per Pallet (TU)" := ldc_PalletFaktor;
                        // Menge Paletten berechnen
                        IF "Qty. (CU) per Pallet (TU)" <> 0 THEN
                            "Quantity (TU)" := Quantity / "Qty. (CU) per Pallet (TU)"
                        ELSE
                            "Quantity (TU)" := 0;
                    END;
                END;

            end;

            trigger OnValidate()
            begin
                IF "Qty. (CU) per Pallet (TU)" <> 0 THEN
                    "Quantity (TU)" := Quantity / "Qty. (CU) per Pallet (TU)"
                ELSE
                    "Quantity (TU)" := 0;
            end;
        }
        field(64; "Qty. (CU) per Pallet (TU)"; Decimal)
        {
            Caption = 'Qty. (CU) per Pallet (TU)';

            trigger OnValidate()
            begin
                // hier.s
                VALIDATE(Quantity);
                // hier.e
            end;
        }
        field(65; "Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';

            trigger OnValidate()
            begin
                // hier.s
                IF CurrFieldNo = FIELDNO("Quantity (TU)") THEN BEGIN
                    TESTFIELD("Qty. (CU) per Pallet (TU)");
                    // Menge Kolli berechnen
                    VALIDATE(Quantity, ("Quantity (TU)" * "Qty. (CU) per Pallet (TU)"));
                END;
                // hier.e
            end;
        }
        field(66; "Collo Unit of Measure (CU)"; Code[10])
        {
            Caption = 'Collo Unit of Measure (CU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Collo Unit of Measure" = CONST(true));
        }
        field(67; "Content Unit of Measure (COU)"; Code[10])
        {
            Caption = 'Content Unit of Measure (COU)';
            TableRelation = "Unit of Measure";
        }
        field(70; "Info 1"; Code[30])
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
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.",
                      "Batch Variant No.", 0, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 1");
            end;
        }
        field(71; "Info 2"; Code[50])
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
                    lcu_BatchManagement.UpdBatchSourceInfo(
                      "Batch No.",
                      "Batch Variant No.", 1, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 2");
            end;
        }
        field(72; "Info 3"; Code[20])
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
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.",
                      "Batch Variant No.", 2, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 3");
            end;
        }
        field(73; "Info 4"; Code[20])
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
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.",
                      "Batch Variant No.", 3, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 4");
            end;
        }
        field(80; "Purch. Order No."; Code[20])
        {
            Caption = 'Purch. Order No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            begin
                IF "Purch. Order No." <> xRec."Purch. Order No." THEN
                    VALIDATE("Purch. Order Line No.", 0);
            end;
        }
        field(81; "Purch. Order Line No."; Integer)
        {
            Caption = 'Purch. Order Line No.';
            Editable = false;
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                              "Document No." = FIELD("Purch. Order No."));

            trigger OnValidate()
            var
                lrc_PurchaseLine: Record "Purchase Line";
                SSPText001Txt: Label 'Purchase Line must be Item!';
            begin
                IF "Purch. Order Line No." = 0 THEN
                    VALIDATE("No.", '')
                ELSE BEGIN
                    TESTFIELD("Purch. Order No.");
                    lrc_PurchaseLine.GET(lrc_PurchaseLine."Document Type"::Order, "Purch. Order No.", "Purch. Order Line No.");
                    IF lrc_PurchaseLine.Type <> lrc_PurchaseLine.Type::Item THEN
                        ERROR(SSPText001Txt);
                    Type := Type::Item;
                    "No." := lrc_PurchaseLine."No.";
                    Description := lrc_PurchaseLine.Description;
                    "Description 2" := lrc_PurchaseLine."Description 2";
                    "Master Batch No." := lrc_PurchaseLine."POI Master Batch No.";
                    "Batch No." := lrc_PurchaseLine."POI Batch No.";
                    "Batch Variant No." := lrc_PurchaseLine."POI Batch Variant No.";
                    "Variety Code" := lrc_PurchaseLine."POI Variety Code";
                    "Country of Origin Code" := lrc_PurchaseLine."POI Country of Origin Code";
                    "Trademark Code" := lrc_PurchaseLine."POI Trademark Code";
                    "Caliber Code" := lrc_PurchaseLine."POI Caliber Code";
                    "Item Attribute 2" := lrc_PurchaseLine."POI Item Attribute 2";
                    "Grade of Goods Code" := lrc_PurchaseLine."POI Grade of Goods Code";
                    "Item Attribute 7" := lrc_PurchaseLine."POI Item Attribute 7";
                    "Item Attribute 4" := lrc_PurchaseLine."POI Item Attribute 4";
                    "Coding Code" := lrc_PurchaseLine."POI Coding Code";
                    "Item Attribute 5" := lrc_PurchaseLine."POI Item Attribute 5";
                    "Unit of Measure Code" := lrc_PurchaseLine."Unit of Measure Code";
                    "Base Unit of Measure (BU)" := lrc_PurchaseLine."POI Base Unit of Measure (BU)";
                    "Qty. per Unit of Measure" := lrc_PurchaseLine."Qty. per Unit of Measure";
                    Quantity := lrc_PurchaseLine.Quantity;
                    "Quantity (Base)" := lrc_PurchaseLine.Quantity * lrc_PurchaseLine."Qty. per Unit of Measure";
                    Quantity := lrc_PurchaseLine.Quantity;
                    "Info 1" := lrc_PurchaseLine."POI Info 1";
                    "Info 2" := lrc_PurchaseLine."POI Info 2";
                    "Info 3" := lrc_PurchaseLine."POI Info 3";
                    "Info 4" := lrc_PurchaseLine."POI Info 4";
                END;
            end;
        }
        field(85; "Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            Editable = false;
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
                                                     Blocked = CONST(false));
        }
        field(86; "Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'Purch. Price (Price Base)';
        }
        field(87; "Purch. Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(90; "No. of Claim Reasons"; Integer)
        {
            CalcFormula = Count ("POI Purch. Claim Notify Reason" WHERE("Document No." = FIELD("Document No."),
                                                                    "Doc. Line No." = FIELD("Line No.")));
            Caption = 'No. of Claim Reasons';
            Editable = false;
            FieldClass = FlowField;
        }
        field(91; "Main Claim Reason Code"; Code[20])
        {
            Caption = 'Main Claim Reason Code';
            TableRelation = "POI Claim Reason" WHERE("Purchase Reason" = CONST(true));
        }
        field(93; "Main Claim Reason Discription"; Text[70])
        {
            Caption = 'Main Claim Reason Discription';
        }
        field(99; "Sales Quality Rating"; Option)
        {
            Caption = 'Sales Quality Rating';
            OptionCaption = ' ,,,,,1 Decay,2 Damaged,3 Empty,4 Loading,,6 Sample,7 Weight,8 Others';
            OptionMembers = " ",,,,,"1 Decay","2 Damaged","3 Empty","4 Loading",,"6 Sample","7 Weight","8 Others";
        }
        field(100; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(101; "Shipping Agent Code Claim"; Code[10])
        {
            Caption = 'Shipping Agent Code Claim';
            TableRelation = "Shipping Agent".Code;
        }
        field(105; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(106; "Location Code Claim"; Code[10])
        {
            Caption = 'Location Code Claim';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(198; "Claim Quantity (Original)"; Decimal)
        {
            Caption = 'Claim Quantity (Original)';
        }
        field(200; "Claim Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Claim Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(201; "Claim Return Quantity"; Boolean)
        {
            Caption = 'Claim Return Quantity';
        }
        field(210; "Claim Sales Unit Price"; Decimal)
        {
            Caption = 'Claim Sales Unit Price';
        }
        field(211; "Claim Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Claim Sales Price (Price Base)';
        }
        field(215; "Claim Sales Amount"; Decimal)
        {
            Caption = 'Claim Sales Amount';
        }
        field(220; "Claim Verlust"; Decimal)
        {
            Caption = 'Claim Verlust';
            Description = '?????';
        }
        field(230; "Claim Diff. Price (Price Base)"; Decimal)
        {
            Caption = 'Claim Diff. Price (Price Base)';
        }
        field(231; "Claim Diff. Unit Price"; Decimal)
        {
            Caption = 'Claim Diff. Unit Price';
        }
        field(232; "Claim Diff. Amount"; Decimal)
        {
            Caption = 'Claim Diff. Amount';
        }
        field(250; "Fault Reason Code"; Code[20])
        {
            Caption = 'Fault Reason Code';
            TableRelation = "POI Claim Reason" WHERE("Fault Reason" = CONST(true));
        }
        field(253; "Person Causing Fault"; Option)
        {
            Caption = 'Person Causing Fault';
            Description = ' ,Verkäufer,Kommissionierer,Fahrer,Kunde,,,,,Sonstige';
            OptionCaption = ' ,Verkäufer,Kommissionierer,Fahrer,Kunde,,,,,Sonstige';
            OptionMembers = " ","Verkäufer",Kommissionierer,Fahrer,Kunde,,,,,Sonstige;
        }
        field(255; "Person Causing Fault Desc."; Text[30])
        {
            Caption = 'Person Causing Fault Desc.';
        }
        field(260; "Type of Reaction"; Option)
        {
            Caption = 'Type of Reaction';
            Description = ' ,Lieferschein geändert,Nachliefern am Datum,Umtausch am Datum,Retoure am Datum,Neuer Preis';
            OptionCaption = ' ,Lieferschein geändert,Nachliefern am Datum,Umtausch am Datum,Retoure am Datum,Neuer Preis';
            OptionMembers = " ","Lieferschein geändert","Nachliefern am Datum","Umtausch am Datum","Retoure am Datum","Neuer Preis";
        }
        field(270; "Type of Action"; Option)
        {
            Caption = 'Type of Action';
            Description = ' ,Wertgutschrift,Wertugutschrift und Entsorgung durch Debitor,,,,,Rücksendung';
            OptionMembers = " ",Wertgutschrift,"Wertugutschrift und Entsorgung durch Debitor",,,,,"Rücksendung";
        }
        field(271; "Subtype of Action"; Option)
        {
            Caption = 'Subtype of Action';
            Description = ' ,Zum Rücksendelager,,,Zum Rücksendelager und Rückgabe Lieferant,,,Zum Rücksendelager und Entsorgung';
            OptionMembers = " ","Zum Rücksendelager",,,"Zum Rücksendelager und Rückgabe Lieferant",,,"Zum Rücksendelager und Entsorgung";
        }
        field(280; "Posted Claim Qty."; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Posted Claim Qty.';
            DecimalPlaces = 0 : 5;
            Description = '<>FlowField';
            Editable = false;
        }
        field(281; "Posted Claim Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Posted Claim Amount';
            Description = '<>FlowField';
            Editable = false;
        }
        field(290; "Transfered to Cr.M./Return O."; Boolean)
        {
            Caption = 'Transfered to Cr.M./Return O.';
        }
        field(292; "Cr.M./Return O. No."; Code[20])
        {
            Caption = 'Cr.M./Return O. No.';
        }
        field(293; "Cr.M./Return O. Line No."; Integer)
        {
            Caption = 'Cr.M./Return O. Line No.';
        }
        field(300; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Waiting,,,,,Closed';
            OptionMembers = Open,Waiting,,,,,Closed;
        }
        field(301; "Status Comment"; Text[80])
        {
            Caption = 'Status Comment';
        }
        field(400; "Claim Doc. Subtype Code"; Code[10])
        {
            Caption = 'Claim Doc. Subtype Code';
            TableRelation = "POI Claim Doc. Subtype".Code WHERE("Document Type" = CONST("Purchase Claim"));
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
        key(Key2; "Purch. Order No.", "Purch. Order Line No.")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key3; "Batch Variant No.")
        {
            SumIndexFields = "Quantity (Base)", Quantity;
        }
        key(Key4; "Batch No.")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_PurchClaimAdviceReason: Record "POI Purch. Claim Notify Reason";
        lrc_PurchClaimAdviceComment: Record "POI Purch. Claim Notify Commt";
    begin
        lrc_PurchClaimAdviceReason.SETRANGE("Document No.", "Document No.");
        lrc_PurchClaimAdviceReason.SETRANGE("Doc. Line No.", "Line No.");
        lrc_PurchClaimAdviceReason.DELETEALL();

        lrc_PurchClaimAdviceComment.SETRANGE("Document No.", "Document No.");
        lrc_PurchClaimAdviceComment.SETRANGE("Doc. Line No.", "Line No.");
        lrc_PurchClaimAdviceComment.DELETEALL();
    end;

    trigger OnInsert()
    var
        lrc_PurchClaimHeader: Record "POI Purch. Claim Notify Header";
    begin
        lrc_PurchClaimHeader.GET("Document No.");
        "Claim Doc. Subtype Code" := lrc_PurchClaimHeader."Claim Doc. Subtype Code";
    end;

    procedure TransportUnitOfMeasure_Validat()
    var
        lrc_UnitofMeasure: Record "Unit of Measure";
    begin
        // --------------------------------------------------------------------------------------
        // Validierung Transport Unit
        // --------------------------------------------------------------------------------------

        IF "Transport Unit of Measure (TU)" <> '' THEN BEGIN
            lrc_ItemUnitOfMeasure.RESET();
            lrc_ItemUnitOfMeasure.SETRANGE("Item No.", "No.");
            lrc_ItemUnitOfMeasure.SETRANGE(Code, "Transport Unit of Measure (TU)");
            IF lrc_ItemUnitOfMeasure.FIND('-') THEN
                "Qty. (CU) per Pallet (TU)" := lrc_ItemUnitOfMeasure."Qty. per Unit of Measure" / "Qty. per Unit of Measure"
            ELSE BEGIN
                lrc_UnitofMeasure.GET("Transport Unit of Measure (TU)");
                "Qty. (CU) per Pallet (TU)" := (lrc_UnitofMeasure."POI Qty. per Transp. Unit (TU)" *
                                                  lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas") /
                                                  "Qty. per Unit of Measure";
            END;

            IF "Qty. (CU) per Pallet (TU)" <> 0 THEN
                "Quantity (TU)" := Quantity / "Qty. (CU) per Pallet (TU)"
            ELSE
                "Quantity (TU)" := 0;

        END ELSE BEGIN
            "Qty. (CU) per Pallet (TU)" := 0;
            "Quantity (TU)" := 0;
        END;
    end;

    var
        lrc_ItemUnitOfMeasure: Record "Item Unit of Measure";
}

