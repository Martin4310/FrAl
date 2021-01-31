table 5110316 "POI Caliber Detail"
{
    // DrillDownFormID = Form5110434;
    // LookupFormID = Form5110434;

    fields
    {
        field(1; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber";
        }
        field(3; "Caliber Code Detail"; Code[10])
        {
            Caption = 'Caliber Code Detail';
            TableRelation = "POI Caliber";
        }
    }

    keys
    {
        key(Key1; "Caliber Code", "Caliber Code Detail")
        {
        }
    }
}

