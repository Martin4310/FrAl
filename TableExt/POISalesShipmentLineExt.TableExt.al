tableextension 50034 "POI Sales Shipment Line Ext" extends "Sales Shipment Line"
{
    fields
    {
        field(50000; "POI Batch No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Batch No.';
            TableRelation = "POI Batch" where("Master Batch No." = field("POI Master Batch No."));
        }
        field(50001; "POI Master Batch No."; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Master batch No.';
            TableRelation = "POI Master Batch";
        }
        field(50002; "POI Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            DataClassification = CustomerContent;
            TableRelation = "POI Batch Variant"."No." where("Master Batch No." = field("POI Master Batch No."));
        }
        field(50003; "POI Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code WHERE("Item Category Code" = FIELD("Item Category Code"));
        }
        field(50040; "POI Empties Blanket Order No."; Code[20])
        {
        }
        field(50041; "POI Empt Blank Order Line No."; Integer)
        {
        }
        field(5110324; "POI Batch Var. Detail ID"; Integer)
        {
            Caption = 'Batch Var. Detail ID';
        }
        field(5110326; "POI Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
        }
        field(5110370; "POI Price Unit of Measure"; Code[10])
        {
            Caption = 'Price Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(5110380; "POI Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            Editable = false;
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."));
        }
        field(5110381; "POI Packing Unit of Meas (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            Description = 'DSD';
        }
        field(5110382; "POI Qty. (PU) per Unit of Meas"; Decimal)
        {
            Caption = 'Qty. (PU) per Unit of Measure';
        }
        field(5110383; "POI Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';
        }
        field(5110384; "POI Transport Unit of Meas(TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
        }
        field(5110385; "POI Qty.(Unit) per Transp.Unit"; Decimal)
        {
            Caption = 'Qty. (Unit) per Transp. Unit';
        }
        field(5110386; "POI Quantity (TU)"; Decimal)
        {
            Caption = 'Quantity (TU)';
        }
        field(5110387; "POI Collo Unit of Measure (PQ)"; Code[10])
        {
            Caption = 'Collo Unit of Measure (PQ)';
            TableRelation = "Unit of Measure";
        }
        field(5110388; "POI Content Unit of Meas (COU)"; Code[10])
        {
            Caption = 'Content Unit of Measure (COU)';
            TableRelation = "Unit of Measure";
        }
        field(5110389; "POI Partial Quantity (PQ)"; Boolean)
        {
            Caption = 'Partial Quantity (PQ)';
        }
        field(5110390; "POI Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(false));
        }
        field(5110391; "POI Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';
        }
        field(5110395; "POI Quality Rating"; Option)
        {
            Caption = 'Quality Rating';
            OptionCaption = ' ,,,,,1 Decay,2 Damaged,3 Empty,4 Loading,,6 Sample,7 Weight,8 Others';
            OptionMembers = " ",,,,,"1 Decay","2 Damaged","3 Empty","4 Loading",,"6 Sample","7 Weight","8 Others";
        }
        field(5110397; "POI Qty.(COU)per Pack.Unit(PU)"; Decimal)
        {
            Caption = 'Qty. (COU) per Pack. Unit (PU)';
        }
        field(5110410; "POI Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = IF (Type = CONST(Item)) Item WHERE("POI Item Typ" = CONST("Empties Item"));
        }
        field(5110411; "POI Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            Description = 'LVW';
        }
        field(5110432; "POI Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
            ValidateTableRelation = false;
        }
        field(5110435; "POI Info 1"; Code[30])
        {
            Caption = 'Info 1';
            Description = 'BSI';
        }
        field(5110436; "POI Info 2"; Code[50])
        {
            Caption = 'Info 2';
            Description = 'BSI';
        }
        field(5110437; "POI Info 3"; Code[20])
        {
            Caption = 'Info 3';
            Description = 'BSI';
        }
        field(5110438; "POI Info 4"; Code[20])
        {
            Caption = 'Info 4';
            Description = 'BSI';
        }
        field(5110440; "POI Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            Description = 'EIA';
            TableRelation = "Country/Region";
        }
        field(5110441; "POI Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            Description = 'EIA';
            TableRelation = "POI Variety";
        }
        field(5110442; "POI Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            Description = 'EIA';
            TableRelation = "POI Trademark";
            ValidateTableRelation = false;
        }
        field(5110443; "POI Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber";
            ValidateTableRelation = false;
        }
        field(5110444; "POI Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber - Vendor Caliber"."Vendor No.";
            ValidateTableRelation = false;
        }
        field(5110445; "POI Quality Code"; Code[10])
        {
            Caption = 'Quality Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 3";
        }
        field(5110446; "POI Color Code"; Code[10])
        {
            Caption = 'Color Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 2";
        }
        field(5110447; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            Description = 'EIA';
            TableRelation = "POI Grade of Goods";
        }
        field(5110448; "POI Conservation Code"; Code[10])
        {
            Caption = 'Conservation Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 7";
        }
        field(5110449; "POI Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 4";
        }
        field(5110450; "POI Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            Description = 'EIA';
            TableRelation = "POI Coding";
        }
        field(5110451; "POI Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110452; "POI Proper Name Code"; Code[20])
        {
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
        }
        field(5110453; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(5110454; "POI Cultivation Associat. Code"; Code[10])
        {
            Caption = 'Cultivation Association Code';
            Description = 'EIA';
            TableRelation = "POI Cultivation Association";
        }
        field(5110800; "POI Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
    }

}