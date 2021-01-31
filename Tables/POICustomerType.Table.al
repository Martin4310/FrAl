table 50910 "POI Customer Type"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "POI Customer Type";
    LookupPageId = "POI Customer Type";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Beschreibung';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}