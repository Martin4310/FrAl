table 5110440 "POI Freight Order Detail Line"
{
    Caption = 'Freight Order Detail Line';
    // DrillDownFormID = Form5110509;
    // LookupFormID = Form5110509;

    fields
    {
        field(1; "Freight Order No."; Code[20])
        {
            Caption = 'Tour Order No.';
        }
        field(2; "Freight Order Line No."; Integer)
        {
            Caption = 'Tour Order Line No.';
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Arrival Type"; Option)
        {
            Caption = 'Arrival Type';
            OptionCaption = 'Customer,Ship-To Address,Vendor,Pick-Up Addresse,,,Location';
            OptionMembers = Customer,"Ship-To Address",Vendor,"Pick-Up Addresse",,,Location;
        }
        field(11; "Arrival Code"; Code[20])
        {
            Caption = 'Arrival Code';
            TableRelation = IF ("Arrival Type" = CONST(Customer)) Customer
            ELSE
            IF ("Arrival Type" = CONST("Ship-To Address")) Customer
            ELSE
            IF ("Arrival Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Arrival Type" = CONST("Pick-Up Addresse")) Vendor;
        }
        field(12; "Arrival Subcode"; Code[10])
        {
            Caption = 'Arrival Subcode';
            TableRelation = IF ("Arrival Type" = CONST("Ship-To Address")) "Ship-to Address".Code WHERE("Customer No." = FIELD("Arrival Code"))
            ELSE
            IF ("Arrival Type" = CONST("Pick-Up Addresse")) "Order Address".Code WHERE("Vendor No." = FIELD("Arrival Code"));
        }
        field(19; "Doc. Source"; Option)
        {
            Caption = 'Doc. Source';
            Description = ' ,Purchase,Transfer,Sales';
            OptionCaption = ' ,Purchase,Transfer,Sales';
            OptionMembers = " ",Purchase,Transfer,Sales;
        }
        field(20; "Doc. Source Type"; Option)
        {
            Caption = 'Doc. Source Type';
            Description = ' ,Order,,,Shipment,,,Invoice';
            OptionCaption = ' ,Order,,,Shipment,,,Receipt,,,Invoice';
            OptionMembers = " ","Order",,,Shipment,,,Receipt,,,Invoice;
        }
        field(21; "Doc. Source No."; Code[20])
        {
            Caption = 'Doc. Source No.';
            TableRelation = IF ("Doc. Source" = CONST(Sales),
                                "Doc. Source Type" = CONST(Order)) "Sales Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(22; "Doc. Source Line No."; Integer)
        {
            Caption = 'Doc. Source Line No.';
        }
        field(25; "Correction State"; Option)
        {
            Caption = 'Correction State';
            OptionCaption = ' ,Annahmeverweigerung';
            OptionMembers = " ",Annahmeverweigerung;
        }
        field(33; "Quality Code"; Code[10])
        {
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(34; "Color Code"; Code[10])
        {
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(35; "Conservation Code"; Code[10])
        {
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(36; "Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(37; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";
        }
        field(38; "Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(39; "Proper Name Code"; Code[20])
        {
            Caption = 'Proper Name Code';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(40; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety";
        }
        field(41; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber";
        }
        field(42; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(43; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";
        }
        field(44; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods";
        }
        field(45; "Location Reference No."; Code[20])
        {
            Caption = 'Location Reference No.';
        }
        field(46; "Shelf No."; Code[10])
        {
            Caption = 'Shelf No.';
        }
        field(50; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(51; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }
        field(52; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
        }
        field(53; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(54; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
        }
        field(55; "Item Description"; Text[30])
        {
            Caption = 'Item Description';
        }
        field(56; "Item Description 2"; Text[30])
        {
            Caption = 'Item Description 2';
        }
        field(60; "Quantity Order"; Decimal)
        {
            Caption = 'Quantity Order';
        }
        field(61; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                AGILES_TEXT_001Txt: Label 'Eine Änderung der Einheit ist nicht zulässig !';
            begin
                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN
                    IF "Doc. Source No." <> '' THEN
                        ERROR(AGILES_TEXT_001Txt);
            end;
        }
        field(63; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
        }
        field(64; "Quantity (Base) Order"; Decimal)
        {
            Caption = 'Quantity (Base) Order';
        }
        field(65; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(66; "Unit of Transport Code"; Code[10])
        {
            Caption = 'Unit of Transport Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(67; "Qty. Transport Unit"; Decimal)
        {
            Caption = 'Qty. Transport Unit';
        }
        field(68; "Qty. per Transport Unit"; Decimal)
        {
            Caption = 'Qty. per Transport Unit';
        }
        field(80; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
        }
        field(81; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
        }
        field(82; "Total Gross Weight"; Decimal)
        {
            Caption = 'Total Gross Weight';
        }
        field(83; "Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
        }
        field(85; "Qty. Shipped"; Decimal)
        {
            Caption = 'Qty. Shipped';
            Editable = false;
        }
        field(86; "Qty. Transport Unit Shipped"; Decimal)
        {
            Caption = 'Qty. Transport Unit Shipped';
            Editable = false;
        }
        field(90; "Qty. to Ship"; Decimal)
        {
            Caption = 'Qty. to Ship';

            trigger OnValidate()
            var
                AGILES_TEXT_001Txt: Label 'Menge größer als Auftragsmenge nicht zulässig!';
                ldc_QtyShipped: Decimal;
            begin
                IF CurrFieldNo = FIELDNO("Qty. to Ship") THEN BEGIN

                    // Kontrolle ob Menge ausreicht
                    IF "Qty. to Ship" > "Quantity Order" THEN
                        // Menge größer als Auftragsmenge nicht zulässig!
                        ERROR(AGILES_TEXT_001Txt);

                    // Kontrolle ob Restmenge ausreicht
                    ldc_QtyShipped := 0;
                    lrc_FreightOrderDetailLine.SETRANGE("Doc. Source", "Doc. Source");
                    lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Type", "Doc. Source Type");
                    lrc_FreightOrderDetailLine.SETRANGE("Doc. Source No.", "Doc. Source No.");
                    lrc_FreightOrderDetailLine.SETRANGE("Doc. Source Line No.", "Doc. Source Line No.");
                    IF lrc_FreightOrderDetailLine.FIND('-') THEN
                        REPEAT
                            IF (lrc_FreightOrderDetailLine."Freight Order No." <> "Freight Order No.") AND
                               (lrc_FreightOrderDetailLine."Freight Order Line No." <> "Freight Order Line No.") THEN
                                ldc_QtyShipped := ldc_QtyShipped + lrc_FreightOrderDetailLine."Qty. to Ship";
                        UNTIL lrc_FreightOrderDetailLine.NEXT() = 0;

                    "Qty. Shipped" := ldc_QtyShipped;
                    IF "Qty. per Transport Unit" <> 0 THEN
                        "Qty. Transport Unit Shipped" := ldc_QtyShipped / "Qty. per Transport Unit"
                    ELSE
                        "Qty. Transport Unit Shipped" := 0;

                    IF (ldc_QtyShipped + "Qty. to Ship") > "Quantity Order" THEN
                        ERROR('Menge zu verladen übersteigt Gesamtmenge Auftrag!');

                    IF "Qty. per Transport Unit" <> 0 THEN
                        "Qty. Transport Unit to Ship" := "Qty. to Ship" / "Qty. per Transport Unit"
                    ELSE
                        "Qty. Transport Unit to Ship" := 0;


                    "Total Gross Weight to Ship" := "Gross Weight" * "Qty. to Ship";
                    "Total Net Weight to Ship" := "Net Weight" * "Qty. to Ship";
                END;
            end;
        }
        field(91; "Qty. Transport Unit to Ship"; Decimal)
        {
            Caption = 'Qty. Transport Unit to Ship';

            trigger OnValidate()
            var
                AGILES_TEXT_001Txt: Label 'Menge größer als Auftragsmenge nicht zulässig!';
            begin
                IF CurrFieldNo = FIELDNO("Qty. Transport Unit to Ship") THEN BEGIN

                    // Kontrolle ob Menge ausreicht
                    IF ("Qty. Transport Unit to Ship" * "Qty. per Transport Unit") > "Quantity Order" THEN
                        // Menge größer als Auftragsmenge nicht zulässig!
                        ERROR(AGILES_TEXT_001Txt);
                    // Kontrolle ob Restmenge ausreicht


                    "Qty. to Ship" := "Qty. Transport Unit to Ship" * "Qty. per Transport Unit";

                    "Total Gross Weight to Ship" := "Gross Weight" * "Qty. to Ship";
                    "Total Net Weight to Ship" := "Net Weight" * "Qty. to Ship";

                END;
            end;
        }
        field(97; "Total Gross Weight to Ship"; Decimal)
        {
            Caption = 'Total Gross Weight to Ship';
        }
        field(98; "Total Net Weight to Ship"; Decimal)
        {
            Caption = 'Total Net Weight to Ship';
        }
        field(100; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(110; "Freight Costs (LCY)"; Decimal)
        {
            Caption = 'Freight Costs (LCY)';
        }
        field(115; "Inv. Freight Costs (LCY)"; Decimal)
        {
            Caption = 'Inv. Freight Costs (LCY)';
        }
    }

    keys
    {
        key(Key1; "Freight Order No.", "Freight Order Line No.", "Line No.")
        {
            SumIndexFields = "Total Gross Weight", "Total Net Weight", "Qty. to Ship", "Qty. Transport Unit to Ship", "Total Gross Weight to Ship", "Total Net Weight to Ship", "Quantity Order", "Qty. Transport Unit";
        }
        key(Key2; "Doc. Source", "Doc. Source Type", "Doc. Source No.", "Freight Order No.")
        {
        }
        key(Key3; "Master Batch No.", "Batch No.", "Batch Variant No.", "Doc. Source")
        {
        }
        key(Key4; "Doc. Source", "Doc. Source Type", "Doc. Source No.", "Doc. Source Line No.")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_TourOrderDetailLine.SETRANGE("Freight Order No.", "Freight Order No.");
            lrc_TourOrderDetailLine.SETRANGE("Freight Order Line No.", "Freight Order Line No.");
            IF lrc_TourOrderDetailLine.FIND('+') THEN
                "Line No." := lrc_TourOrderDetailLine."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;
    end;

    var
        lrc_TourOrderDetailLine: Record "POI Freight Order Detail Line";
        lrc_FreightOrderDetailLine: Record "POI Freight Order Detail Line";
}

