tableextension 50013 "POI Transfer Shipment Line Ext" extends "Transfer Shipment Line"
{
    fields
    {
        field(5110321; "POI Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
        }
        field(5110322; "POI Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = "POI Batch";
        }
        field(5110323; "POI Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(5110324; "POI Batch Var. Detail ID"; Integer)
        {
            Caption = 'Batch Var. Detail ID';
        }
        field(5110326; "POI Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
        }
    }

}