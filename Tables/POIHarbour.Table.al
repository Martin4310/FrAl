table 5087985 "POI Harbour"
{
    // DrillDownPageID = 5087979;
    // LookupPageID = 5087979;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(11; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }
}

