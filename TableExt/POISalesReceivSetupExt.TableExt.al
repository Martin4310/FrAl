tableextension 50031 "POI Sales Receiv Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "POI Tour No."; Code[20])
        {
            Caption = 'EK Tour Nr.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50001; "POI Credit Check first"; DateFormula)
        {
            Caption = '1.Kreditprüfung nach';
            DataClassification = CustomerContent;
        }
        field(50002; "POI Credit Check second"; DateFormula)
        {
            Caption = '2.Kreditprüfung nach';
            DataClassification = CustomerContent;
        }
    }

}