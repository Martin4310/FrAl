tableextension 50035 "POI sales Credit memo Line Ext" extends "Sales Cr.Memo Line"
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
    }

}