table 50930 "POI W.D. From Posted Line"
{
    Caption = 'W.D. From Posted Line';

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
        field(3; "Sub Line No"; Integer)
        {
            Caption = 'Sub Line No';
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF (Type = CONST("Charge (Item)")) "Item Charge";
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(13; "Unit of Measure"; Text[30])
        {
            Caption = 'Unit of Measure';
            Description = 'FV von 10 auf 30';
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(22; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(50; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(52; "Disposal of Waste Company"; Option)
        {
            Caption = 'Entsorgungsunternehmen';
            OptionCaption = ' ,DSD,BellandVision,Interseroh,Edeka,,,,ARA';
            OptionMembers = " ",DSD,BellandVision,Interseroh,Edeka,Fruitness,"Belland Ratio","Belland Tegut",ARA,METRO;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        field(50000; "Expected Receipt Date"; Date)
        {
            Caption = 'Wareneingangsdatum';
        }
        field(5110321; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(5110322; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = "POI Batch";
        }
        field(5110323; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(5110350; Trademark; Code[20])
        {
        }
        field(5110381; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            Description = 'DSD';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.", "Sub Line No")
        {
            MaintainSIFTIndex = false;
        }
    }
}

