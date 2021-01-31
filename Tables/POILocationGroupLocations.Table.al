table 5110330 "POI Location Group - Locations"
{
    Caption = 'Location Group - Locations';
    // DrillDownFormID = Form5110330;
    // LookupFormID = Form5110330;

    fields
    {
        field(1; "Location Group Code"; Code[10])
        {
            Caption = 'Location Group Code';
            NotBlank = true;
            TableRelation = "POI Location Group";
        }
        field(2; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            NotBlank = true;
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Location Group Code", "Location Code")
        {
        }
    }
}

