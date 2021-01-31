table 5110465 "POI Warehouse Receive Line"
{
    Caption = 'Warehouse Receive Line';

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Purchase,Transfer,,,Sales,,,Packing';
            OptionMembers = Purchase,Transfer,,,Sales,,,Packing;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Purchase)) "Purchase Header"."No."
            ELSE
            IF (Source = CONST(Sales)) "Sales Header"."No."
            ELSE
            IF (Source = CONST(Transfer)) "Transfer Header"."No."
            ELSE
            IF (Source = CONST(Packing)) "POI Pack. Order Header";
        }
        field(3; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(9; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Date of Arrival"; Date)
        {
            Caption = 'Date of Arrival';

        }
        field(11; "Time of Arrival"; Time)
        {
            Caption = 'Time of Arrival';
        }
        field(15; "Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
        }
        field(16; "Means of Transport"; Option)
        {
            Caption = 'Means of Transport';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(17; "Means of Transport Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(18; "Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
        }
        field(20; "Shipping Agent Code"; Code[20])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(21; "Shipping Agent Name"; Text[30])
        {
            Caption = 'Shipping Agent Name';
        }
        field(40; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(41; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));

        }
        field(42; "Item Description"; Text[30])
        {
            Caption = 'Item Description';
        }
        field(43; "Item Description 2"; Text[30])
        {
            Caption = 'Item Description 2';
        }
        field(47; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "Shipping Agent";
        }
        field(48; "Batch No"; Code[20])
        {
            Caption = 'Batch No';
        }
        field(49; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
        }
        field(50; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";
        }
        field(51; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety";
        }
        field(52; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
            ValidateTableRelation = false;
        }
        field(53; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber";
            ValidateTableRelation = false;
        }
        field(54; "Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            TableRelation = "POI Caliber - Vendor Caliber"."Vendor No." WHERE("Caliber Code" = FIELD("Caliber Code"));
            ValidateTableRelation = false;
        }
        field(55; "Quality Code"; Code[10])
        {
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3";
        }
        field(56; "Color Code"; Code[10])
        {
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(57; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods";
        }
        field(58; "Conservation Code"; Code[10])
        {
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(59; "Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(60; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";
        }
        field(61; "Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(65; "Info 1"; Code[30])
        {
            Caption = 'Info 1';
        }
        field(66; "Info 2"; Code[50])
        {
            Caption = 'Info 2';
        }
        field(67; "Info 3"; Code[20])
        {
            Caption = 'Info 3';
        }
        field(68; "Info 4"; Code[20])
        {
            Caption = 'Info 4';
        }
        field(70; "Gross Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF Weight <> Weight::"Gross Weight" THEN
                    ERROR('Brutto Wiegen nicht zulässig!');
            end;
        }
        field(71; "Net Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF Weight <> Weight::"Net Weight" THEN
                    ERROR('Netto Wiegen nicht zulässig!');
            end;
        }
        field(72; "Total Gross Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Total Gross Weight';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF Weight <> Weight::"Gross Weight" THEN
                    ERROR('Brutto Wiegen nicht zulässig!');
            end;
        }
        field(73; "Total Net Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Total Net Weight';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF Weight <> Weight::"Net Weight" THEN
                    ERROR('Netto Wiegen nicht zulässig!');
            end;
        }
        field(75; Weight; Option)
        {
            Caption = 'Weight';
            OptionCaption = ' ,Gross Weight,Net Weight';
            OptionMembers = " ","Gross Weight","Net Weight";
        }
        field(80; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(81; "Vendor Name"; Text[30])
        {
            Caption = 'Vendor Name';
        }
        field(83; "Vendor Lot No."; Code[20])
        {
            Caption = 'Vendor Lot No.';
        }
        field(85; "Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Verzollt,Unverzollt,Eingangsverzollung';
            OptionMembers = " ",Verzollt,Unverzollt,Eingangsverzollung;
        }
        field(99; "Transfer-from Location Code"; Code[10])
        {
            Caption = 'Transfer-from Location Code';
            TableRelation = Location;
        }
        field(100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(110; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(120; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(130; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Packing Unit of Measure" = CONST(true));
        }
        field(131; "Qty. (PU) per Collo (CU)"; Decimal)
        {
            Caption = 'Qty. (PU) per Collo (CU)';
        }
        field(132; "Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';
        }
        field(135; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(136; "Qty. (CU) per Pallet (TU)"; Decimal)
        {
            Caption = 'Qty. (CU) per Pallet (TU)';
        }
        field(137; "Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';
        }
        field(150; "Quantity to Receive"; Decimal)
        {
            Caption = 'Quantity to Receive';

            trigger OnValidate()
            var
                AGILES_LT_TEXT002Txt: Label 'You can not post more quantity than transfered!';
                AGILES_LT_TEXT001Txt: Label 'It is not possible to post more quantity than ordered!';
            begin

                // Menge prüfen
                CASE Source OF
                    Source::Purchase:
                        BEGIN

                            lrc_PurchaseLine.RESET();
                            lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
                            lrc_PurchaseLine.SETRANGE("Document No.", "Source No.");
                            lrc_PurchaseLine.SETRANGE("Line No.", "Source Line No.");
                            lrc_PurchaseLine.FIND('-');
                            IF lrc_PurchaseLine."Outstanding Quantity" < "Quantity to Receive" THEN
                                // Sie können nicht mehr Menge buchen als bestellt!
                                ERROR(AGILES_LT_TEXT001Txt)

                        END;
                    Source::Transfer:
                        BEGIN

                            lrc_TransferLine.RESET();
                            lrc_TransferLine.SETRANGE("Document No.", "Source No.");
                            lrc_TransferLine.SETRANGE("Line No.", "Source Line No.");
                            lrc_TransferLine.FIND('-');
                            IF lrc_TransferLine."Outstanding Quantity" < "Quantity to Receive" THEN
                                // Sie können nicht mehr Menge buchen als umgelagert!
                                ERROR(AGILES_LT_TEXT002Txt)

                        END;
                    ELSE
                        ERROR('');
                END;


                IF "Qty. (CU) per Pallet (TU)" <> 0 THEN
                    "Quantity to Receive (TU)" := ROUND("Quantity to Receive" / "Qty. (CU) per Pallet (TU)", 0.00001)
                ELSE
                    "Quantity to Receive (TU)" := 0;
            end;
        }
        field(152; "Quantity to Receive (TU)"; Decimal)
        {
            Caption = 'Quantity to Receive (TU)';

            trigger OnValidate()
            begin
                VALIDATE("Quantity to Receive", ("Quantity to Receive (TU)" * "Qty. (CU) per Pallet (TU)"));
            end;
        }
        field(160; "Vendor Shipment No."; Code[20])
        {
            Caption = 'Vendor Shipment No.';
        }
        field(200; "Post Arrival"; Boolean)
        {
            Caption = 'Post Arrival';

            trigger OnValidate()
            begin
                IF "Post Arrival" = TRUE THEN
                    "Post Arrival by" := copystr(USERID(), 1, 20)
                ELSE
                    "Post Arrival by" := '';
            end;
        }
        field(210; "Post Arrival by"; Code[20])
        {
            Caption = 'Post Arrival by';
        }
    }

    keys
    {
        key(Key1; Source, "Source No.", "Source Line No.")
        {
        }
        key(Key2; "Date of Arrival", "Time of Arrival")
        {
        }
    }
    var
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_TransferLine: Record "Transfer Line";
}

