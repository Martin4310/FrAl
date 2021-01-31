table 5087912 "POI Factor Transport Unit"
{
    Caption = 'Factor Transport Unit';
    // DrillDownFormID = Form5110318;
    // LookupFormID = Form5110318;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF ("Item No." = FILTER('')) "Unit of Measure".Code
            ELSE
            IF ("Item No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

        }
        field(3; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
            begin
                IF ("Transport Unit of Measure (TU)" <> xRec."Transport Unit of Measure (TU)") AND ("Transport Unit of Measure (TU)" <> '') THEN
                    IF lrc_UnitofMeasure.GET("Transport Unit of Measure (TU)") THEN BEGIN
                        VALIDATE("No. of Layers", lrc_UnitofMeasure."POI Number of Tiers");
                        VALIDATE("No. Units per of Layer", lrc_UnitofMeasure."POI Number of Units per Tier");
                    END;
            end;
        }
        field(4; "Qty. (Unit) per Transp. Unit"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transp. Unit';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Qty. (Unit) per Transp. Unit" <> xRec."Qty. (Unit) per Transp. Unit" THEN
                    IF "Qty. (Unit) per Transp. Unit" <> 0 THEN
                        IF "No. of Layers" <> 0 THEN
                            "No. Units per of Layer" := "Qty. (Unit) per Transp. Unit" / "No. of Layers"
                        ELSE
                            IF "No. Units per of Layer" <> 0 THEN
                                "No. of Layers" := "Qty. (Unit) per Transp. Unit" / "No. Units per of Layer";
            end;
        }
        field(5; "Reference Typ"; Option)
        {
            Caption = 'Reference Typ';
            Description = ' ,Vendor,Customer,Customer Group,,,,,All';
            OptionCaption = ' ,Vendor,Customer,Customer Group,,,,,All';
            OptionMembers = " ",Vendor,Customer,"Customer Group",,,,,All;
        }
        field(6; "Reference No."; Code[20])
        {
            Caption = 'Reference No.';
            TableRelation = IF ("Reference Typ" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Reference Typ" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Reference Typ" = CONST("Customer Group")) "POI Customer Group".Code;
        }
        field(9; "Empty Item No."; Code[20])
        {
            Caption = 'Empty Item No.';
            TableRelation = Item WHERE("POI Item Typ" = CONST("Empties Item"));
        }
        field(10; "No. of Layers"; Decimal)
        {
            Caption = 'No. of Layers';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "No. of Layers" <> xRec."No. of Layers" THEN
                    IF "No. Units per of Layer" <> 0 THEN
                        "Qty. (Unit) per Transp. Unit" := "No. Units per of Layer" * "No. of Layers"
                    ELSE
                        IF "No. of Layers" <> 0 THEN
                            "No. Units per of Layer" := "Qty. (Unit) per Transp. Unit" / "No. of Layers";


            end;
        }
        field(11; "No. Units per of Layer"; Decimal)
        {
            Caption = 'No. Units per of Layer';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "No. Units per of Layer" <> xRec."No. Units per of Layer" THEN
                    IF "No. of Layers" <> 0 THEN
                        "Qty. (Unit) per Transp. Unit" := "No. Units per of Layer" * "No. of Layers"
                    ELSE
                        IF "No. Units per of Layer" <> 0 THEN
                            "No. of Layers" := "Qty. (Unit) per Transp. Unit" / "No. Units per of Layer";
            end;
        }
        field(20; "Stackability per Bin"; Integer)
        {
            Caption = 'Stackability per Bin';
            InitValue = 1;
            MinValue = 0;
        }
        field(100; "Item Description"; Text[30])
        {
            CalcFormula = Lookup (Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Reference Typ", "Reference No.", "Unit of Measure Code", "Empty Item No.", "Transport Unit of Measure (TU)")
        {
        }
        key(Key2; "Item No.", "Reference Typ", "Reference No.", "Unit of Measure Code", "Transport Unit of Measure (TU)")
        {
        }
    }
}

