table 5110404 "POI Ship.-Agent/Dep.-Reg./Loc."
{

    Caption = 'Ship.-Agent/Dep.-Reg./Loc.';
    // DrillDownFormID = Form5110404;
    // LookupFormID = Form5110404;

    fields
    {
        field(1; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(2; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "POI Departure Region";
        }
        field(3; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Shipping Agent Code", "Departure Region Code", "Location Code")
        {
        }
    }
}

