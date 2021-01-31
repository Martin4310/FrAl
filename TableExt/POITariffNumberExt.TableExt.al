tableextension 50017 "POI Tariff Number Ext" extends "Tariff Number"
{
    fields
    {
        field(50001; "SOVA Description"; Text[300])
        {
            Caption = 'SOVA Beschreibung';
            DataClassification = CustomerContent;
        }
        field(50000; "POI Data changed"; Option)
        {
            OptionMembers = " ",Beschreibung,"nicht vorhanden";
            OptionCaption = ' ,Beschreibung,nicht vorhanden';
            DataClassification = CustomerContent;
        }
        field(5110300; "POI Supplementary Units Code"; Code[20])
        {
            Caption = 'Supplementary Units Code';
            DataClassification = CustomerContent;
        }
        field(5110301; "POI Supplementary Units Code 2"; Code[10])
        {
            Caption = 'Supplementary Units Code 2';
            DataClassification = CustomerContent;
        }
        field(5110310; "POI Customer Duty per Kilo"; Decimal)
        {
            Caption = 'Customer Duty per Kilo';
            DataClassification = CustomerContent;
        }
        field(5110320; "POI No. of Attached Items"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count (Item WHERE("Tariff No." = FIELD("No.")));
            Caption = 'No. of Attached Items';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110350; "POI Description 2"; Text[120])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(5110351; "POI Description 3"; Text[30])
        {
            Caption = 'Description 3';
            DataClassification = CustomerContent;
        }
    }
}