table 50917 "POI Special Nos Type"
{
    DataClassification = CustomerContent;
    DrillDownPageId = "POI Special Type";
    LookupPageId = "POI Special Type";
    DataPerCompany = false;

    fields
    {
        field(1; "Special Type"; Code[10])
        {
            Caption = 'Special Type';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Special Code"; Text[30])
        {
            Caption = 'Special Code';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Special Type", "Special Code")
        {
            Clustered = true;
        }
    }

}