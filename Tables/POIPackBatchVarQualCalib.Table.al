table 5110486 "POI Pack. BatchVar.Qual Calib."
{

    Caption = 'Batch Variant Packing Quality Caliber';

    fields
    {
        field(1; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            Editable = false;
            TableRelation = "POI Batch";
        }
        field(2; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            Editable = false;
            TableRelation = "POI Batch Variant";
        }
        field(3; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber".Code;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(11; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            Editable = false;
            TableRelation = "Item Variant" WHERE("Item No." = FIELD("Item No."));
        }
        field(14; "Unit of Measure Code (Profed)"; Code[10])
        {
            Caption = 'Unit of Measure Code (Profed)';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(15; "Quantity (Profed)"; Decimal)
        {
            Caption = 'Quantity (Profed)';
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                "Quantity (Base) (Profed)" := CalcBaseQty("Quantity (Profed)");
            end;
        }
        field(90; "Base Unit of Measure Code"; Code[10])
        {
            Caption = 'Base Unit of Measure Code';
            Editable = false;
            TableRelation = "Unit of Measure" WHERE("POI Is Base Unit of Measure" = CONST(true));
        }
        field(91; "Quantity (Base) (Profed)"; Decimal)
        {
            Caption = 'Quantity (Base) (Profed)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(92; "Qty. per Base Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Base Unit of Measure';
        }
    }

    keys
    {
        key(Key1; "Batch Variant No.", "Batch No.", "Caliber Code")
        {
        }
    }

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TESTFIELD("Qty. per Base Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Base Unit of Measure", 0.00001));
    end;
}

