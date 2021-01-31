tableextension 50036 "POI Sales InvoiceLine Ext" extends "Sales Invoice Line"
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
    }

}