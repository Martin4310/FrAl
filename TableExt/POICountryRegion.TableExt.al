tableextension 50011 "POI CountryRegion" extends "Country/Region"
{
    fields
    {
        field(50000; "POI Language"; Code[10])
        {
            Caption = 'Language';
            DataClassification = CustomerContent;
            TableRelation = Language.Code;
        }
        field(50001; "POI Relevant"; Boolean)
        {
            Caption = 'verwendet bei Port';
            DataClassification = CustomerContent;
        }
        field(50002; "POI Sepa"; Boolean)
        {
            Caption = 'Sepa ja/nein';
            DataClassification = CustomerContent;
        }
        field(50003; "POI IBAN numbers"; Integer)
        {
            Caption = 'IBAN Länge';
            DataClassification = CustomerContent;
        }
        field(5001902; "POI EU Standard"; Boolean)
        {
            Caption = 'EU Standard';
            DataClassification = CustomerContent;
        }
        field(5110300; "POI Country Group Code"; Code[10])
        {
            Caption = 'Country Group Code';
            Description = 'FV';
            TableRelation = "POI Country Group";
            DataClassification = CustomerContent;
        }
    }
}