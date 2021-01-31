table 5110456 "POI Sales Claim Notify Line"
{
    Caption = 'Sales Claim Notify Line';
    // DrillDownFormID = Form5110540;
    // LookupFormID = Form5110540;

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
        field(7; "Claim Doc. Subtype Code"; Code[10])
        {
            Caption = 'Claim Doc. Subtype Code';
            TableRelation = "POI Claim Doc. Subtype".Code WHERE("Document Type" = CONST("Sales Claim"));
        }
        field(8; "Claiming Reaction"; Option)
        {
            Caption = 'Claiming Reaction';
            Description = ' ,Mge. sperren,,,Gel. Mge zurücknehmen,,,,,,,,,,Gel. Mge zurücknehmen - Verderb';
            OptionMembers = " ","Mge. sperren",,,"Gel. Mge zurücknehmen",,,,,,,,,,"Gel. Mge zurücknehmen - Verderb";
        }
        field(9; Claim; Boolean)
        {
            Caption = 'Claim';

            trigger OnValidate()
            var
                lrc_FruitVisionSetup: Record "POI ADF Setup";
                lrc_SalesClaimHeader: Record "POI Sales Claim Notify Header";
                lrc_ClaimDocSubtype: Record "POI Claim Doc. Subtype";
                // lrc_LineRefClaim: Record "POI Sales Claim Notify Line";
                // lrc_LineSearchClaim: Record "POI Sales Claim Notify Line";
                // lrc_SalesClaimNotifyHeader: Record "POI Sales Claim Notify Header";
                // lco_Port_Sales: Codeunit "5110797";
                // lcu_PalletManagement: Codeunit "POI Pallet Management";
                // HeaderModifyEKBE: Boolean;
                // HeaderModifyVendor: Boolean;
                // HeaderModifyMasterBatch: Boolean;
                // PartieLineToHeader: Boolean;
                lco_ClaimDocSubtypeCode: Code[10];
                ErrorLabel: Text;

            //frm_SalesClaimNotifyLine: Form "5110543";

            begin
                // Prüfung ob die Zeile bereits reklamiert wurde
                lrc_FruitVisionSetup.GET();
                CASE lrc_FruitVisionSetup."Sales Claim Check Dupplex" OF
                    lrc_FruitVisionSetup."Sales Claim Check Dupplex"::"One per Shipment Line":
                        BEGIN
                            IF ("Sales Shipment No." <> '') AND
                               ("Sales Shipment Line No." <> 0) THEN BEGIN
                                lrc_SalesClaimLine.RESET();
                                lrc_SalesClaimLine.SETCURRENTKEY("Sales Shipment No.", "Sales Shipment Line No.");
                                lrc_SalesClaimLine.SETFILTER("Document No.", '<>%1', "Document No.");
                                lrc_SalesClaimLine.SETRANGE("Sales Shipment No.", "Sales Shipment No.");
                                lrc_SalesClaimLine.SETRANGE("Sales Shipment Line No.", "Sales Shipment Line No.");
                                lrc_SalesClaimLine.SETRANGE(Claim, TRUE);
                                IF lrc_SalesClaimLine.FINDFIRST() THEN begin
                                    ErrorLabel := 'Zeile (Lieferung) wurde bereits in Reklamation ' + lrc_SalesClaimLine."Document No." + ' reklamiert?';
                                    ERROR(ErrorLabel);
                                end;
                            END;
                            IF ("Sales Order No." <> '') AND
                               ("Sales Order Line No." <> 0) THEN BEGIN
                                lrc_SalesClaimLine.RESET();
                                lrc_SalesClaimLine.SETCURRENTKEY("Sales Order No.", "Sales Order Line No.");
                                lrc_SalesClaimLine.SETFILTER("Document No.", '<>%1', "Document No.");
                                lrc_SalesClaimLine.SETRANGE("Sales Order No.", "Sales Order No.");
                                lrc_SalesClaimLine.SETRANGE("Sales Order Line No.", "Sales Order Line No.");
                                lrc_SalesClaimLine.SETRANGE(Claim, TRUE);
                                IF lrc_SalesClaimLine.FINDFIRST() THEN begin
                                    ErrorLabel := 'Zeile (Auftrag) wurde bereits in Reklamation ' + lrc_SalesClaimLine."Document No." + ' reklamiert?';
                                    ERROR(ErrorLabel);
                                end;
                            END;
                        END;
                END;

                IF Claim <> xRec.Claim THEN BEGIN
                    lco_ClaimDocSubtypeCode := "Claim Doc. Subtype Code";
                    IF lco_ClaimDocSubtypeCode = '' THEN BEGIN
                        lrc_SalesClaimHeader.GET("Document No.");
                        lco_ClaimDocSubtypeCode := lrc_SalesClaimHeader."Claim Doc. Subtype Code";
                    END;

                    IF lco_ClaimDocSubtypeCode <> '' THEN
                        IF lrc_ClaimDocSubtype.GET(lrc_ClaimDocSubtype."Document Type"::"Sales Claim", lco_ClaimDocSubtypeCode) THEN
                            IF (lrc_ClaimDocSubtype."Claim Possibility" <> lrc_ClaimDocSubtype."Claim Possibility"::"Price Claim/Retoure") THEN
                                IF lrc_ClaimDocSubtype."Claim Possibility" = lrc_ClaimDocSubtype."Claim Possibility"::"Retoure Only" THEN
                                    VALIDATE("Claim Return Quantity", TRUE)
                                ELSe
                                    VALIDATE("Claim Return Quantity", FALSE);
                END;
            end;
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            Description = ' ,Artikel';
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
                    "Sales Order No." := '';
                    "Sales Order Line No." := 0;
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
                            "Sales Order No." := '';
                            "Sales Order Line No." := 0;
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
                                "Line No." = FILTER(''),
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
        field(27; "Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(28; "Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(29; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transition,Organic';
            OptionMembers = " ",Transition,Organic;
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
        field(34; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(35; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
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
            TableRelation = "Unit of Measure";
        }
        field(42; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            Editable = false;
        }
        field(43; "Quantity Invoiced"; Decimal)
        {
            Caption = 'Quantity Invoiced';
        }
        field(44; "Quantity Shipped"; Decimal)
        {
            Caption = 'Quantity Shipped';
        }
        field(45; Quantity; Decimal)
        {
            Caption = 'Quantity';
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
        field(55; "Block Quantity"; Boolean)
        {
            Caption = 'Block Quantity';
        }
        field(56; "Rücknahme und Verderb"; Boolean)
        {
            Caption = 'Rücknahme und Verderb';
        }
        field(57; "Price Unit of Measure Code"; Code[10])
        {
            Caption = 'Price Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(58; "Partial Quantity (PQ)"; Boolean)
        {
            Caption = 'Anbruchsmenge (AB)';
        }
        field(60; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            Description = 'DSD';
            TableRelation = "Unit of Measure" WHERE("POI Is Packing Unit of Measure" = CONST(true));
        }
        field(61; "Qty. (PU) per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. (PU) per Unit of Measure';
        }
        field(62; "Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';
        }
        field(63; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(64; "Qty. (Unit) per Transport (TU)"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transport (TU)';
        }
        field(65; "Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';
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
        field(69; "Qty. (COU) per Pack. Unit (PU)"; Decimal)
        {
            Caption = 'Qty. (COU) per Pack. Unit (PU)';
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
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 0, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 1");
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
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 1, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 2");
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
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 2, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 3");
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
                    lcu_BatchManagement.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 3, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 4");
            end;
        }
        field(75; "Sales Unit Price"; Decimal)
        {
            Caption = 'Sales Unit Price';
        }
        field(76; "Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(true));

        }
        field(77; "Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';
        }
        field(78; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
        }
        field(79; "Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount';
        }
        field(80; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            begin
                IF "Sales Order No." <> xRec."Sales Order No." THEn
                    VALIDATE("Sales Order Line No.", 0);
            end;
        }
        field(81; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                           "Document No." = FIELD("Sales Order No."));

            trigger OnValidate()
            var
                lrc_SalesLine: Record "Sales Line";
                lrc_mb: Record "POI Master Batch";
                SSPText001Txt: Label 'Sales Line must be Item!';

            begin
                IF "Sales Order Line No." = 0 THEN
                    VALIDATE("No.", '')
                ELSE BEGIN
                    TESTFIELD("Sales Order No.");
                    lrc_SalesLine.GET(lrc_SalesLine."Document Type"::Order, "Sales Order No.", "Sales Order Line No.");
                    IF lrc_SalesLine.Type <> lrc_SalesLine.Type::Item THEN
                        ERROR(SSPText001Txt);

                    Type := Type::Item;
                    "No." := lrc_SalesLine."No.";
                    Description := lrc_SalesLine.Description;
                    "Description 2" := lrc_SalesLine."Description 2";
                    "Master Batch No." := lrc_SalesLine."POI Master Batch No.";
                    "Batch No." := lrc_SalesLine."POI Batch No.";
                    "Batch Variant No." := lrc_SalesLine."Variant Code";
                    "Variety Code" := lrc_SalesLine."POI Variety Code";
                    "Country of Origin Code" := lrc_SalesLine."POI Country of Origin Code";
                    "Trademark Code" := lrc_SalesLine."POI Trademark Code";
                    "Caliber Code" := lrc_SalesLine."POI Caliber Code";
                    "Item Attribute 2" := lrc_SalesLine."POI Item Attribute 2";
                    "Grade of Goods Code" := lrc_SalesLine."POI Grade of Goods Code";
                    "Item Attribute 7" := lrc_SalesLine."POI Item Attribute 7";
                    "Item Attribute 4" := lrc_SalesLine."POI Item Attribute 4";
                    "Coding Code" := lrc_SalesLine."POI Coding Code";
                    "Item Attribute 5" := lrc_SalesLine."POI Item Attribute 5";
                    "Unit of Measure Code" := lrc_SalesLine."Unit of Measure Code";
                    "Base Unit of Measure (BU)" := lrc_SalesLine."POI Base Unit of Measure (BU)";
                    "Qty. per Unit of Measure" := lrc_SalesLine."Qty. per Unit of Measure";
                    Quantity := lrc_SalesLine.Quantity;
                    "Quantity (Base)" := lrc_SalesLine.Quantity * lrc_SalesLine."Qty. per Unit of Measure";
                    Quantity := lrc_SalesLine.Quantity;
                    "Info 1" := lrc_SalesLine."POI Info 1";
                    "Info 2" := lrc_SalesLine."POI Info 2";
                    "Info 3" := lrc_SalesLine."POI Info 3";
                    "Info 4" := lrc_SalesLine."POI Info 4";
                END;
                IF lrc_SalesLine."POI Master Batch No." <> '' THEN BEGIN
                    lrc_mb.GET(lrc_SalesLine."POI Master Batch No.");
                    "Vendor Name" := lrc_mb."Vendor Search Name";
                END;
            end;
        }
        field(85; "Sales Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
        }
        field(86; "Sales Shipment Line No."; Integer)
        {
            Caption = 'Sales Shipment Line No.';
        }
        field(88; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
        }
        field(89; "Sales Invoice Line No."; Integer)
        {
            Caption = 'Sales Invoice Line No.';
        }
        field(90; "No. of Claim Reasons"; Integer)
        {
            CalcFormula = Count ("POI Sales Claim Notify Reason" WHERE("Document No." = FIELD("Document No."),
                                                                   "Doc. Line No." = FIELD("Line No.")));
            Caption = 'No. of Claim Reasons';
            Editable = false;
            FieldClass = FlowField;
        }
        field(91; "Main Claim Reason Code"; Code[20])
        {
            Caption = 'Main Claim Reason Code';
            TableRelation = "POI Claim Reason" WHERE("Sales Reason" = CONST(true));

            trigger OnValidate()
            var
                lrc_SalesClaimAdviceReason: Record "POI Sales Claim Notify Reason";
                lrc_mb: Record "POI Master Batch";
            begin

                // Eintrag löschen
                IF ("Main Claim Reason Code" = '') AND
                   (xRec."Main Claim Reason Code" <> '') THEN
                    IF CONFIRM('Möchten Sie den Eintrag aus den Reklamationsgründen entfernen?') THEN BEGIN
                        lrc_SalesClaimAdviceReason.SETRANGE("Document No.", "Document No.");
                        lrc_SalesClaimAdviceReason.SETRANGE("Doc. Line No.", "Line No.");
                        lrc_SalesClaimAdviceReason.SETRANGE("Claim Reason Code", xRec."Main Claim Reason Code");
                        IF lrc_SalesClaimAdviceReason.FINDFIRST() THEN
                            lrc_SalesClaimAdviceReason.DELETE(TRUE);
                    END;

                // Neuen Eintrag anlegen
                IF "Main Claim Reason Code" <> '' THEN BEGIN
                    lrc_SalesClaimAdviceReason.SETRANGE("Document No.", "Document No.");
                    lrc_SalesClaimAdviceReason.SETRANGE("Doc. Line No.", "Line No.");
                    lrc_SalesClaimAdviceReason.SETRANGE("Claim Reason Code", "Main Claim Reason Code");
                    IF NOT lrc_SalesClaimAdviceReason.FINDFIRST() THEN BEGIN
                        lrc_SalesClaimAdviceReason.RESET();
                        lrc_SalesClaimAdviceReason.INIT();
                        lrc_SalesClaimAdviceReason."Document No." := "Document No.";
                        lrc_SalesClaimAdviceReason."Doc. Line No." := "Line No.";
                        lrc_SalesClaimAdviceReason."Line No." := 0;
                        lrc_SalesClaimAdviceReason.Type := lrc_SalesClaimAdviceReason.Type::Item;
                        lrc_SalesClaimAdviceReason."No." := "No.";
                        lrc_SalesClaimAdviceReason."Master Batch No." := "Master Batch No.";
                        lrc_SalesClaimAdviceReason."Batch No." := "Batch No.";
                        lrc_SalesClaimAdviceReason."Batch Variant No." := "Batch Variant No.";
                        lrc_SalesClaimAdviceReason."Claim Reason Code" := "Main Claim Reason Code";
                        lrc_SalesClaimAdviceReason.Comment := '';
                        lrc_SalesClaimAdviceReason.INSERT(TRUE);
                    END;
                END;

                IF lrc_SalesClaimAdviceReason."Master Batch No." <> '' THEN BEGIN
                    lrc_mb.GET(lrc_SalesClaimAdviceReason."Master Batch No.");
                    "Vendor Name" := lrc_mb."Vendor Search Name";
                END;


                // Kennzeichen Reklamation setzen
                IF "Main Claim Reason Code" <> '' THEN
                    Claim := TRUE
                ELSE
                    Claim := FALSE;

            end;
        }
        field(93; "Main Claim Reason Discription"; Text[70])
        {
            Caption = 'Main Claim Reason Discription';
        }
        field(95; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(97; "Manufacturer Code"; Code[20])
        {
            Caption = 'Manufacturer Code';
            TableRelation = Manufacturer;
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
        field(101; "Claim Shipping Agent Code"; Code[10])
        {
            Caption = 'Claim Shipping Agent Code';
            TableRelation = "Shipping Agent".Code;
        }
        field(103; "Freight Order No."; Code[20])
        {
            Caption = 'Freight Order No.';
            TableRelation = "POI Freight Order Header"."No.";
        }
        field(104; "Freight Order Line No."; Integer)
        {
            Caption = 'Freight Order Line No.';
        }
        field(105; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(106; "Claim Location Code"; Code[10])
        {
            Caption = 'Claim Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(110; "Claim Quality Rating"; Option)
        {
            Caption = 'Claim Quality Rating';
            OptionCaption = ' ,,,,,1 Decay,2 Damaged,3 Empty,4 Loading,,6 Sample,7 Weight,8 Others';
            OptionMembers = " ",,,,,"1 Decay","2 Damaged","3 Empty","4 Loading",,"6 Sample","7 Weight","8 Others";
        }
        field(198; "Claim Quantity (Original)"; Decimal)
        {
            Caption = 'Claim Quantity (Original)';

            trigger OnValidate()
            begin
                IF ("Claim Quantity" > Quantity) OR
                   ("Claim Quantity" < 0) THEN
                    // Reklamationsmenge darf nicht grösser als Verkaufsmenge und nicht negativ sein!
                    ERROR(AGILES_TEXT002Txt);

                // Reklamationsbetrag
                "Claim Sales Amount" := "Claim Sales Unit Price" * "Claim Quantity";
            end;
        }
        field(200; "Claim Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Claim Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF ("Claim Quantity" > Quantity) OR
                   ("Claim Quantity" < 0) THEN
                    // Reklamationsmenge darf nicht grösser als Verkaufsmenge und nicht negativ sein!
                    ERROR(AGILES_TEXT002Txt);

                IF "Claim Quantity (Original)" <= 0 THEN
                    "Claim Quantity (Original)" := "Claim Quantity";

                // Reklamationsbetrag
                "Claim Sales Amount" := "Claim Sales Unit Price" * "Claim Quantity";
            end;
        }
        field(201; "Claim Return Quantity"; Boolean)
        {
            Caption = 'Claim Return Quantity';

            trigger OnValidate()
            var
                lrc_ClaimDocSubtype: Record "POI Claim Doc. Subtype";
                lrc_SalesClaimHeader: Record "POI Sales Claim Notify Header";
                lcu_SalesClaimAdvice: Codeunit "POI Sales Claim Mgt";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
                lco_ClaimDocSubtypeCode: Code[10];
                AGILES_TEXT0001Txt: Label 'Für die Belegunterart %1, ist nur die Möglichkeit ''%2'' zugelassen !', Comment = '%1 %2';
            begin
                lcu_PalletManagement.ErrorIfIncomingPalletLineEx_SC(copystr(FIELDCAPTION("Claim Return Quantity"), 1, 100), Rec);

                IF "Claim Return Quantity" <> xRec."Claim Return Quantity" THEN
                    VALIDATE("Claim Sales Unit Price", lcu_SalesClaimAdvice.SalesClaimAdvLineCalcUnitPrice(Rec));

                IF "Claim Return Quantity" = TRUE THEN
                    // Preise nachpflegen
                    IF ("Sales Price (Price Base)" <> "Claim Sales Price (Price Base)") AND ("Claim Sales Price (Price Base)" = 0) THEN
                        VALIDATE("Claim Sales Price (Price Base)", "Sales Price (Price Base)");

                IF "Claim Return Quantity" <> xRec."Claim Return Quantity" THEN BEGIN
                    lco_ClaimDocSubtypeCode := "Claim Doc. Subtype Code";
                    IF lco_ClaimDocSubtypeCode = '' THEN BEGIN
                        lrc_SalesClaimHeader.GET("Document No.");
                        lco_ClaimDocSubtypeCode := lrc_SalesClaimHeader."Claim Doc. Subtype Code";
                    END;

                    IF lco_ClaimDocSubtypeCode <> '' THEN
                        IF lrc_ClaimDocSubtype.GET(lrc_ClaimDocSubtype."Document Type"::"Sales Claim", lco_ClaimDocSubtypeCode) THEN
                            IF (lrc_ClaimDocSubtype."Claim Possibility" <> lrc_ClaimDocSubtype."Claim Possibility"::"Price Claim/Retoure") THEN
                                IF "Claim Return Quantity" = TRUE THEN BEGIN
                                    IF (lrc_ClaimDocSubtype."Claim Possibility" = lrc_ClaimDocSubtype."Claim Possibility"::"Claim Only") THEN
                                        ERROR(AGILES_TEXT0001Txt, lco_ClaimDocSubtypeCode, lrc_ClaimDocSubtype."Claim Possibility");
                                END ELSE
                                    IF (lrc_ClaimDocSubtype."Claim Possibility" = lrc_ClaimDocSubtype."Claim Possibility"::"Retoure Only") THEN
                                        ERROR(AGILES_TEXT0001Txt, lco_ClaimDocSubtypeCode, lrc_ClaimDocSubtype."Claim Possibility");
                END;
            end;
        }
        field(210; "Claim Sales Unit Price"; Decimal)
        {
            Caption = 'Claim Sales Unit Price';

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Claim Sales Unit Price") THEN
                    "Claim Sales Price (Price Base)" := 0;

                IF ("Sales Unit Price" <> 0) THEN BEGIN
                    IF ("Claim Sales Unit Price" > ROUND("Sales Unit Price", 0.00001)) OR ("Claim Sales Unit Price" < 0) THEN //Rundungspräzision von 0.0001 auf 0.00001 erhöht
                        // Reklamationspreis darf nicht grösser als Verkaufspreis und nicht negativ sein!
                        ERROR(AGILES_TEXT001Txt);
                END ELSE
                    IF ("Claim Sales Unit Price" < 0) THEN
                        // Reklamationspreis darf nicht grösser als Verkaufspreis und nicht negativ sein!
                        ERROR(AGILES_TEXT001Txt);

                // Reklamationsbetrag
                "Claim Sales Amount" := "Claim Sales Unit Price" * "Claim Quantity";
            end;
        }
        field(211; "Claim Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Claim Sales Price (Price Base)';

            trigger OnValidate()
            var
                lcu_SalesClaimAdvice: Codeunit "POI Sales Claim Mgt";
            begin
                VALIDATE("Claim Sales Unit Price", lcu_SalesClaimAdvice.SalesClaimAdvLineCalcUnitPrice(Rec));
            end;
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
            CalcFormula = Sum ("POI Sales Claim Notify Line"."Claim Quantity" WHERE("Sales Order No." = FIELD("Sales Order No."),
                                                                                "Sales Order Line No." = FIELD("Sales Order Line No."),
                                                                                Claim = CONST(true),
                                                                                Status = CONST(Closed)));
            Caption = 'Posted Claim Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(281; "Posted Claim Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Sales Claim Notify Line"."Claim Sales Amount" WHERE("Sales Order No." = FIELD("Sales Order No."),
                                                                                    "Sales Order Line No." = FIELD("Sales Order Line No."),
                                                                                    Claim = CONST(true),
                                                                                    Status = CONST(Closed)));
            Caption = 'Posted Claim Amount';
            Editable = false;
            FieldClass = FlowField;
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
        field(50001; Basismenge; Integer)
        {
        }
        field(50002; "voraussichtliche Ausfallmenge"; Integer)
        {
        }
        field(50003; "Vendor Name"; Text[50])
        {
            Caption = 'Kred. Name';
        }
        field(50004; Schadenschaetzung; Option)
        {
            OptionMembers = " ","3-5%"," 5-10%"," 10-20%"," >20%"," unbekannt";
        }
        field(50007; "Sell-to Customer No."; Code[20])
        {
            CalcFormula = Lookup ("POI Sales Claim Notify Header"."Sell-to Customer No." WHERE("No." = FIELD("Document No.")));
            Caption = 'Sell-to Customer No.';
            Editable = false;
            FieldClass = FlowField;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

        }
        field(50008; "Sell-to Customer Name"; Text[50])
        {
            CalcFormula = Lookup ("POI Sales Claim Notify Header"."Sell-to Customer Name" WHERE("No." = FIELD("Document No.")));
            Caption = 'Sell-to Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Eink. von Kred.-Nr.';
        }
        field(50012; "Vendor Order No."; Code[20])
        {
            Caption = 'Kred.-Bestellnr.';
        }
        field(50020; "Vendor Expected Receipt Date"; Date)
        {
            CalcFormula = Lookup ("Purchase Header"."Expected Receipt Date" WHERE("No." = FIELD("Master Batch No.")));
            Caption = 'Kred. Erwartetes Wareneingangsdatum';
            FieldClass = FlowField;
        }
        field(50022; "Vendor Means of Transp. Code"; Code[20])
        {
            CalcFormula = Lookup ("Purchase Header"."POI Means of TransCode(Arriva)" WHERE("No." = FIELD("Master Batch No.")));
            Caption = 'Kred. Transportmittel Code (Ankunft)';
            FieldClass = FlowField;
        }
        field(50024; "Vendor Port of Discharge Code"; Code[10])
        {
            CalcFormula = Lookup ("Purchase Header"."POI Port of Disch. Code (UDE)" WHERE("No." = FIELD("Master Batch No.")));
            Caption = 'Port of Discharge Code (UDE)';
            FieldClass = FlowField;
            TableRelation = "Entry/Exit Point";
        }
        field(50040; "Empties Blanket Order No."; Code[20])
        {
        }
        field(50041; "Empties Blanket Order Line No."; Integer)
        {
        }
        field(50042; "Empties Item No."; Code[20])
        {
        }
        field(50043; "Empties Quantity"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Quantity, "Claim Quantity", "Sales Amount", "Claim Sales Amount";
        }
        key(Key2; Claim)
        {
            SumIndexFields = Quantity, "Claim Quantity", "Sales Amount", "Claim Sales Amount";
        }
        key(Key3; "Batch No.")
        {
        }
        key(Key4; Type, "Batch Variant No.")
        {
            SumIndexFields = "Claim Quantity";
        }
        key(Key5; "Sales Order No.", "Sales Order Line No.", Claim, Status)
        {
            SumIndexFields = "Claim Quantity", "Claim Sales Amount", Quantity;
        }
        key(Key6; "Sales Shipment No.", "Sales Shipment Line No.", Claim, Status)
        {
        }
        key(Key7; "Cr.M./Return O. No.", "Cr.M./Return O. Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_SalesClaimAdviceReason: Record "POI Sales Claim Notify Reason";
        lrc_SalesClaimAdviceComment: Record "POI Sales Claim Notify Comment";
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        lrc_SalesClaimAdviceReason.SETRANGE("Document No.", "Document No.");
        lrc_SalesClaimAdviceReason.SETRANGE("Doc. Line No.", "Line No.");
        lrc_SalesClaimAdviceReason.DELETEALL();

        lrc_SalesClaimAdviceComment.SETRANGE("Document No.", "Document No.");
        lrc_SalesClaimAdviceComment.SETRANGE("Doc. Line No.", "Line No.");
        lrc_SalesClaimAdviceComment.DELETEALL();

        lcu_PalletManagement.ErrorIfIncomingPalletLineEx_SC('', Rec);
    end;

    trigger OnInsert()
    var
        lrc_SalesClaimHeader: Record "POI Sales Claim Notify Header";
    begin
        lrc_SalesClaimHeader.GET("Document No.");
        "Claim Doc. Subtype Code" := lrc_SalesClaimHeader."Claim Doc. Subtype Code";
    end;

    trigger OnModify()
    begin
        CalcClaimDiffValues();
    end;

    var
        //MB: Record "POI Master Batch";
        AGILES_TEXT001Txt: Label 'Reklamationspreis darf nicht grösser als Verkaufspreis und nicht negativ sein!';
        AGILES_TEXT002Txt: Label 'Reklamationsmenge darf nicht grösser als Verkaufsmenge und nicht negativ sein!';

    procedure CalcClaimDiffValues()
    begin
        // -------------------------------------------------------------------------------------------------------
        // Funktion zur Berechnung der Differenz zwischen Original Betrag und Reklamationsbetrag
        // -------------------------------------------------------------------------------------------------------

        "Claim Diff. Price (Price Base)" := 0;
        "Claim Diff. Unit Price" := 0;
        "Claim Diff. Amount" := 0;

        IF Claim = TRUE THEN BEGIN
            "Claim Diff. Price (Price Base)" := "Sales Price (Price Base)" - "Claim Sales Price (Price Base)";
            "Claim Diff. Unit Price" := "Sales Unit Price" - "Claim Sales Unit Price";
            IF Quantity <> 0 THEN
                "Claim Diff. Amount" := ("Sales Amount" / Quantity * "Claim Quantity") - "Claim Sales Amount";
        END;
    end;

    procedure ChangeClaimUnitPartitialQty()
    var
        lrc_UnitofMeasure: Record "Unit of Measure";
        ADF_LT_TEXT001Txt: Label 'Anbruch nur für Artikel zulässig!';
        ADF_LT_TEXT002Txt: Label 'Bitte zuerst Artikelnummer eingeben!';
    begin
        // ---------------------------------------------------------------------------------
        // Funktion zum Wechsel der Verkaufseinheit
        // Funktion muss noch in die Codeunit Sales ausgelagert werden
        // ---------------------------------------------------------------------------------

        IF Type <> Type::Item THEN BEGIN
            IF "Partial Quantity (PQ)" = TRUE THEN
                // Anbruch nur für Artikel zulässig!
                ERROR(ADF_LT_TEXT001Txt);
            EXIT;
        END;
        IF "No." = '' THEN
            // Bitte zuerst Artikelnummer eingeben!
            ERROR(ADF_LT_TEXT002Txt);

        // Einheit auf Anbruchseinheit setzen
        IF "Partial Quantity (PQ)" = TRUE THEN BEGIN

            lrc_UnitofMeasure.GET("Unit of Measure Code");
            lrc_UnitofMeasure.TESTFIELD("POI Part. Qty. Unit of Measure");
            // Kolloeinheit die angebrochen wird speichern
            //"Collo Unit of Measure (PQ)" := "Unit of Measure Code";
            VALIDATE(Quantity, (lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" * Quantity));
            VALIDATE("Unit of Measure Code", lrc_UnitofMeasure."POI Part. Qty. Unit of Measure");
            IF Quantity <> 0 THEN
                VALIDATE("Sales Price (Price Base)", ("Sales Price (Price Base)" / Quantity));
            "Partial Quantity (PQ)" := TRUE;

            // Einheit auf Kolloeinheit setzen
        END ELSE
            "Partial Quantity (PQ)" := FALSE;
    end;

    var
        lrc_SalesClaimLine: Record "POI Sales Claim Notify Line";
}

