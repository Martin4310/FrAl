table 5110449 "POI Reservation Line"
{
    Caption = 'Reservation Line';
    // DrillDownFormID = Form5110496;
    // LookupFormID = Form5110496;

    fields
    {
        field(1; "Res. No."; Code[20])
        {
            Caption = 'Res. No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(9; "Typ of Reservation"; Option)
        {
            Caption = 'Typ of Reservation';
            OptionCaption = 'Sale,Transfer,Packerei,Feature Assortment,Block Goods,User Internal,Other';
            OptionMembers = Sale,Transfer,Packerei,"Feature Assortment","Block Goods","User Internal",Other;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
                lcu_BaseData: Codeunit "POI Base Data Mgt";
                Text01Txt: Label 'Artikelnr. nicht vorhanden!';
                lco_No: Code[20];
            begin
                IF lcu_BaseData.ItemNoSearch("Item No.", 0, '', 0D, FALSE, '', lco_No) = FALSE THEN BEGIN
                    IF lco_No = '' THEN BEGIN
                        "Item No." := lco_No;
                        ERROR('');
                    END ELSE
                        ERROR(Text01Txt);
                END ELSE
                    "Item No." := lco_No;


                IF lrc_Item.GET("Item No.") THEN BEGIN
                    "Variant Code" := '';
                    "Item Typ" := lrc_Item."POI Item Typ";
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Country of Origin Code" := lrc_Item."POI Countr of Ori Code (Fruit)";
                    "Variety Code" := lrc_Item."POI Variety Code";
                    "Trademark Code" := lrc_Item."POI Trademark Code";
                    "Caliber Code" := lrc_Item."POI Caliber Code";
                    "Item Attribute 2" := lrc_Item."POI Item Attribute 2";
                    "Grade of Goods Code" := lrc_Item."POI Grade of Goods Code";
                    "Item Attribute 7" := lrc_Item."POI Item Attribute 7";
                    "Item Attribute 3" := lrc_Item."POI Item Attribute 3";
                    "Item Attribute 4" := lrc_Item."POI Item Attribute 4";
                    "Coding Code" := lrc_Item."POI Coding Code";
                    "Item Attribute 5" := lrc_Item."POI Item Attribute 5";
                    "Base Unit of Measure" := lrc_Item."Base Unit of Measure";

                    // Einheitencode setzen
                    IF lrc_Item."Sales Unit of Measure" <> '' THEN
                        VALIDATE("Unit of Measure Code", lrc_Item."Sales Unit of Measure")
                    ELSE
                        IF lrc_Item."Purch. Unit of Measure" <> '' THEN
                            VALIDATE("Unit of Measure Code", lrc_Item."Purch. Unit of Measure")
                        ELSE
                            VALIDATE("Unit of Measure Code", lrc_Item."Base Unit of Measure");

                    IF CurrFieldNo = FIELDNO("Item No.") THEN BEGIN
                        "Master Batch No." := '';
                        "Batch No." := '';
                        "Batch Variant No." := '';
                    END;

                END ELSE BEGIN
                    "Variant Code" := '';
                    "Item Description" := '';
                    "Item Description 2" := '';
                    "Country of Origin Code" := '';
                    "Variety Code" := '';
                    "Trademark Code" := '';
                    "Caliber Code" := '';
                    "Item Attribute 2" := '';
                    "Grade of Goods Code" := '';
                    "Item Attribute 7" := '';
                    "Item Attribute 3" := '';
                    "Item Attribute 4" := '';
                    "Coding Code" := '';
                    "Item Attribute 5" := '';
                    "Base Unit of Measure" := '';

                    VALIDATE("Unit of Measure Code");

                    "Master Batch No." := '';
                    "Batch No." := '';
                    "Batch Variant No." := '';
                END;

                IF Quantity <> 0 THEN
                    VALIDATE(Quantity, 0);
            end;
        }
        field(11; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF ("Item No." = FILTER('')) "Item Variant".Code
            ELSE
            IF ("Item No." = FILTER(<> '')) "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(12; "Item Typ"; Option)
        {
            Caption = 'Item Typ';
            OptionCaption = 'Standard,File Item,Empties Item';
            OptionMembers = Standard,"File Item","Empties Item";
        }
        field(13; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(14; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = IF ("Master Batch No." = FILTER(<> '')) "POI Batch"."No." WHERE("Master Batch No." = FIELD("Master Batch No."))
            ELSE
            IF ("Master Batch No." = FILTER('')) "POI Batch"."No.";

            trigger OnValidate()
            begin
                // Eingabe Position --> Falls es nur eine Positionsvariante gibt, dann diese setzen
                IF "Batch No." <> '' THEN BEGIN
                    lrc_BatchVariant.SETRANGE("Batch No.", "Batch No.");
                    IF lrc_BatchVariant.COUNT() = 1 THEN BEGIN
                        lrc_BatchVariant.FIND('-');
                        VALIDATE("Batch Variant No.", lrc_BatchVariant."No.");
                        EXIT;
                    END;
                END;
            end;
        }
        field(15; "Batch Variant No."; Code[20])
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
                lrc_BatchVariant: Record "POI Batch Variant";
                lrc_FruitVisionSetup: Record "POI ADF Setup";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                DF_LT_TEXT001Txt: Label 'The base unit of measure for batch variant no and reservation line is divergent !';
            begin
                IF xRec."Batch Variant No." <> '' THEN
                    lcu_BatchManagement.OpenBatchVarStatusIfZero(xRec."Batch Variant No.");
                IF "Batch Variant No." <> '' THEN
                    lcu_BatchManagement.BatchVariantRecalc("Item No.", "Batch Variant No.");
                IF "Batch Variant No." = '' THEN BEGIN
                    VALIDATE("Item No.");
                    EXIT;
                END;

                IF "Item No." = '' THEN BEGIN
                    lrc_BatchVariant.RESET();
                    lrc_BatchVariant.GET("Batch Variant No.");
                    VALIDATE("Item No.", lrc_BatchVariant."Item No.");
                END ELSE
                    lrc_BatchVariant.GET("Batch Variant No.");

                lrc_FruitVisionSetup.GET();
                IF lrc_FruitVisionSetup."Internal Customer Code" = 'BIOTROPIC' THEN
                    VALIDATE("Location Code", lrc_BatchVariant."Entry Location Code");

                IF "Base Unit of Measure" <> lrc_BatchVariant."Base Unit of Measure (BU)" THEN
                    ERROR(DF_LT_TEXT001Txt);

                "Master Batch No." := lrc_BatchVariant."Master Batch No.";
                "Batch No." := lrc_BatchVariant."Batch No.";
                "Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
                "Variety Code" := lrc_BatchVariant."Variety Code";
                "Trademark Code" := lrc_BatchVariant."Trademark Code";
                "Caliber Code" := lrc_BatchVariant."Caliber Code";
                "Item Attribute 2" := lrc_BatchVariant."Item Attribute 2";
                "Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
                "Item Attribute 7" := lrc_BatchVariant."Item Attribute 7";
                "Item Attribute 3" := lrc_BatchVariant."Item Attribute 3";
                "Item Attribute 4" := lrc_BatchVariant."Item Attribute 4";
                "Coding Code" := lrc_BatchVariant."Coding Code";
                "Item Attribute 5" := lrc_BatchVariant."Item Attribute 5";

                "Means of Transport Type" := lrc_BatchVariant."Means of Transport Type";
                "Means of Transport Code" := lrc_BatchVariant."Means of Transp. Code (Arriva)";

                "Voyage No." := lrc_BatchVariant."Voyage No.";
                "Item Category Code" := lrc_BatchVariant."Item Category Code";
                "Product Group Code" := lrc_BatchVariant."Product Group Code";

                VALIDATE("Unit of Measure Code", lrc_BatchVariant."Unit of Measure Code");

                VALIDATE("Transport Unit of Measure (TU)", lrc_BatchVariant."Transport Unit of Measure (TU)");
                VALIDATE("Qty. (CU) per Pallet (TU)", lrc_BatchVariant."Qty. (Unit) per Transp. (TU)");

                "Price Base (Sales Price)" := lrc_BatchVariant."Price Base (Sales Price)";
                "Sales Price (Price Base)" := lrc_BatchVariant."Sales Price (Price Base)";

                "Transport Unit of Measure (TU)" := lrc_BatchVariant."Transport Unit of Measure (TU)";
                "Qty. (CU) per Pallet (TU)" := lrc_BatchVariant."Qty. (Unit) per Transp. (TU)";
            end;
        }
        field(16; "Batch Var. Detail Entry No."; Integer)
        {
            Caption = 'Batch Var. Detail Entry No.';
        }
        field(20; "Sales to Customer No."; Code[20])
        {
            Caption = 'Sales to Customer No.';
            TableRelation = Customer;
        }
        field(21; "Transfer-To Loc. Code"; Code[10])
        {
            Caption = 'Transfer-To Loc. Code';
            TableRelation = Location;
        }
        field(22; "Packing Order No."; Code[20])
        {
            Caption = 'Packing Order No.';
        }
        field(25; "Sales Claim Adv. No."; Code[20])
        {
            Caption = 'Sales Claim Adv. No.';
            TableRelation = "POI Sales Claim Notify Header";
        }
        field(29; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                VALIDATE(Quantity, 0);
            end;
        }
        field(30; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                DF_LT_TEXT001Txt: Label 'Item Number is empty!';
            begin
                IF ("Unit of Measure Code" <> '') AND ("Item No." = '') THEN
                    // Bitte geben Sie zuerst die Artikelnummer ein!
                    ERROR(DF_LT_TEXT001Txt);

                IF "Unit of Measure Code" <> '' THEN BEGIN
                    lrc_ItemUnitofMeasure.SETRANGE("Item No.", "Item No.");
                    lrc_ItemUnitofMeasure.SETRANGE(Code, "Unit of Measure Code");
                    IF lrc_ItemUnitofMeasure.FIND('-') THEN
                        "Qty. per Unit of Measure" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure"
                    ELSE
                        "Qty. per Unit of Measure" := 1;
                END ELSE
                    "Qty. per Unit of Measure" := 0;
            end;
        }
        field(35; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                lrc_ReservationLine: Record "POI Reservation Line";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
                DF_LT_TEXT001Txt: Label 'Location Code is empty!';
            begin
                IF Quantity < 0 THEN
                    ERROR('Negative Menge nicht zulässig!');
                IF (Quantity > 0) AND ("Location Code" = '') THEN
                    // Bitte geben Sie zuerst den Lagerortcode ein!
                    ERROR(DF_LT_TEXT001Txt);

                TESTFIELD("Location Code");

                "Remaining Qty." := Quantity - "Qty. Shipped";
                IF "Remaining Qty." < 0 THEN
                    ERROR('Menge kleiner als ...');

                "Qty. to Ship" := "Remaining Qty.";

                IF CurrFieldNo = FIELDNO(Quantity) THEN
                    IF "Qty. (CU) per Pallet (TU)" <> 0 THEN
                        "Quantity (TU)" := Quantity / "Qty. (CU) per Pallet (TU)"
                    ELSE
                        "Quantity (TU)" := 0;

                CalcQuantity();

                // Bestandsprüfung
                IF ("Batch Variant No." <> '') THEN
                    gcu_StockMgt.BatchVarCheckAvail("Batch Variant No.", "Location Code", 0D,
                                                   (Quantity * "Qty. per Unit of Measure"),
                                                   (xRec.Quantity * "Qty. per Unit of Measure"));



                IF Quantity < xRec.Quantity THEN
                    lcu_BatchManagement.OpenBatchVarStatusIfZero("Batch Variant No.")
                ELSE BEGIN
                    IF NOT lrc_ReservationLine.GET("Res. No.", "Line No.") THEN
                        lrc_ReservationLine.INIT();
                    lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
                      lrc_ReservationLine."Remaining Qty. (Base)" - "Remaining Qty. (Base)");
                END;
            end;
        }
        field(36; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';

            trigger OnValidate()
            begin
                IF "Qty. to Ship" > "Remaining Qty." THEN begin
                    ErrorLabel := "Variant Code" + ': Es stehen noch maximal ' + FORMAT("Remaining Qty.") + ' Kolli zur Verfügung!';
                    ERROR(ErrorLabel);
                end;
                CalcQuantity();
            end;
        }
        field(37; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
        field(38; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(39; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(40; "Qty. to Ship (Base)"; Decimal)
        {
            Caption = 'Qty. to Ship (Base)';
        }
        field(41; "Qty. Shipped (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped (Base)';
        }
        field(44; "Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
        }
        field(45; "Qty. Shipped"; Decimal)
        {
            Caption = 'Qty. Shipped';

            trigger OnValidate()
            begin
                "Remaining Qty." := Quantity - "Qty. Shipped";
                "Qty. to Ship" := Quantity - "Remaining Qty.";

                CalcQuantity();
            end;
        }
        field(46; "Remaining Qty."; Decimal)
        {
            Caption = 'Remaining Qty.';

            trigger OnValidate()
            begin
                CalcQuantity();
            end;
        }
        field(47; "Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(false));
        }
        field(48; "Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';
        }
        field(49; "Price Unit of Measure Code"; Code[10])
        {
            Caption = 'Price Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(50; "Date of Reservation"; Date)
        {
            Caption = 'Date of Reservation';
        }
        field(51; "Reserved Up To Date"; Date)
        {
            Caption = 'Reserved Up To Date';

            trigger OnLookup()
            var
                lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
                ldt_CalendarDate: Date;
            begin
                ldt_CalendarDate := "Reserved Up To Date";
                IF lcu_GlobalFunctions.SelectDateByCalendar(ldt_CalendarDate) THEN
                    VALIDATE("Reserved Up To Date", ldt_CalendarDate);
            end;

            trigger OnValidate()
            begin
                IF State <> State::Opened THEN
                    // Status lässt keine Änderung zu!
                    ERROR(ADF_GT_TEXT002Txt);
                IF "Reserved Up To Date" < TODAY THEN
                    ERROR('Datum nicht zulässig!');
            end;
        }
        field(52; "Reserved Up To Time"; Time)
        {
            Caption = 'Reserved Up To Time';
        }
        field(55; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(58; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(59; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(60; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";
        }
        field(61; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "Country/Region";
        }
        field(62; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "Country/Region";
        }
        field(63; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "Country/Region";
        }
        field(64; "Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            TableRelation = "Country/Region";
        }
        field(65; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "Country/Region";
        }
        field(66; "Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(67; "Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3";
        }
        field(68; "Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(69; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "Country/Region";
        }
        field(70; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            Description = 'FH (z.B. Paletten)';

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
            begin
                IF "Transport Unit of Measure (TU)" = '' THEN BEGIN
                    "Qty. (CU) per Pallet (TU)" := 0;
                    "Quantity (TU)" := 0;
                    "Freight Unit of Measure (FU)" := '';
                END ELSE BEGIN
                    lrc_UnitofMeasure.GET("Transport Unit of Measure (TU)");
                    "Freight Unit of Measure (FU)" := lrc_UnitofMeasure."POI Freight Unit of Meas (FU)";
                END;
            end;
        }
        field(71; "Qty. (CU) per Pallet (TU)"; Decimal)
        {
            Caption = 'Qty. (CU) per Pallet (TU)';
            Description = 'FH Menge in Verkaufseinheiten pro Transporteinheit';

            trigger OnValidate()
            begin
                IF "Qty. (CU) per Pallet (TU)" <> 0 THEN
                    "Quantity (TU)" := Quantity / "Qty. (CU) per Pallet (TU)"
                ELSE
                    "Quantity (TU)" := 0;
            end;
        }
        field(72; "Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Quantity (TU)") THEN
                    IF "Qty. (CU) per Pallet (TU)" <> 0 THEN
                        VALIDATE(Quantity, ("Quantity (TU)" * "Qty. (CU) per Pallet (TU)"))
                    ELSE
                        "Quantity (TU)" := 0;
            end;
        }
        field(73; "Freight Unit of Measure (FU)"; Code[10])
        {
            Caption = 'Freight Unit of Measure (FU)';
        }
        field(75; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(76; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(80; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(85; "Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
        }
        field(88; "Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
        }
        field(89; "Reservation by User ID"; Code[20])
        {
            Caption = 'Reservation by User ID';
        }
        field(90; State; Option)
        {
            Caption = 'State';
            OptionCaption = 'Opened,Used,Deleted';
            OptionMembers = Opened,Used,Deleted;
        }
        field(91; "Used in Source No."; Code[20])
        {
            Caption = 'Used in Source No.';
        }
        field(92; "Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(93; "Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(94; "Container No."; Code[20])
        {
            Caption = 'Container No.';
            TableRelation = "POI Container";
        }
        field(95; "Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Type';
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;

            trigger OnValidate()
            begin
                IF "Means of Transport Type" = "Means of Transport Type"::Ship THEN
                    "Means of Transport Code" := '';
            end;
        }
        field(96; "Means of Transport Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
            TableRelation = IF ("Means of Transport Type" = CONST(Ship)) "POI Means of Transport".Code WHERE(Type = FIELD("Means of Transport Type"));
        }
        field(97; "Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
        }
        field(98; "Date Of Delivery"; Date)
        {
            Caption = 'Date Of Delivery';
        }
        field(100; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(101; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            TableRelation = IF ("Item Category Code" = FILTER(<> '')) "POI Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"))
            ELSE
            "POI Product Group".Code;
        }
    }

    keys
    {
        key(Key1; "Res. No.", "Line No.")
        {
        }
        key(Key2; "Item No.", "Variant Code", "Batch Variant No.")
        {
            SumIndexFields = "Quantity (Base)", "Remaining Qty. (Base)";
        }
        key(Key3; State, "Item No.", "Variant Code", "Batch Variant No.", "Location Code")
        {
            SumIndexFields = "Quantity (Base)", "Remaining Qty. (Base)";
        }
        key(Key4; "Batch Variant No.", "Remaining Qty.")
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
        IF ("Remaining Qty." > 0) AND ("Batch Variant No." <> '') THEN
            lcu_BatchManagement.OpenBatchVarStatusIfZero("Batch Variant No.");
    end;

    trigger OnInsert()
    var
        lrc_ResHeader: Record "POI Reservation Header";
    begin
        TESTFIELD("Res. No.");

        IF "Line No." = 0 THEN BEGIN
            lrc_ResLine.SETRANGE("Res. No.", "Res. No.");
            IF lrc_ResLine.FINDLAST() THEN
                "Line No." := lrc_ResLine."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        lrc_ResHeader.GET("Res. No.");
        "Typ of Reservation" := lrc_ResHeader."Source Reservation";
        "Sales to Customer No." := lrc_ResHeader."Sales to Customer No.";
        "Transfer-To Loc. Code" := lrc_ResHeader."Transfer-To Loc. Code";
        "Location Code" := lrc_ResHeader."Location Code";
        "Date of Reservation" := lrc_ResHeader."Date of Reservation";
        "Reserved Up To Date" := lrc_ResHeader."Reserved Up To Date";
        "Reserved Up To Time" := lrc_ResHeader."Reserved Up To Time";
        "Salesperson Code" := lrc_ResHeader."Salesperson Code";
        "Shipment Date" := lrc_ResHeader."Shipment Date";
        "Promised Delivery Date" := lrc_ResHeader."Promised Delivery Date";
        "Your Reference" := lrc_ResHeader."Your Reference";
    end;

    trigger OnModify()
    var
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
    begin
        IF State <> State::Opened THEN
            ERROR('Status lässt keine Änderung zu!');

        IF NOT lrc_ReservationLine.GET("Res. No.", "Line No.") THEN
            lrc_ReservationLine.INIT();

        lcu_BatchManagement.BatchVariantRecalc_Ins_Mod("Item No.", "Batch Variant No.",
                            lrc_ReservationLine."Remaining Qty. (Base)" - "Remaining Qty. (Base)");
    end;

    trigger OnRename()
    begin
        // Umbenennung nicht zulässig!
        ERROR(ADF_GT_TEXT001Txt);
    end;



    procedure CalcQuantity()
    begin
        "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
        "Qty. to Ship (Base)" := "Qty. to Ship" * "Qty. per Unit of Measure";
        "Qty. Shipped (Base)" := "Qty. Shipped" * "Qty. per Unit of Measure";
        "Remaining Qty. (Base)" := "Remaining Qty." * "Qty. per Unit of Measure";
    end;

    var
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_ResLine: Record "POI Reservation Line";
        lrc_ReservationLine: Record "POI Reservation Line";
        gcu_StockMgt: Codeunit "POI Stock Management";
        ErrorLabel: Text;
        ADF_GT_TEXT001Txt: Label 'Umbenennung nicht zulässig!';
        ADF_GT_TEXT002Txt: Label 'Status lässt keine Änderung zu!';
}

