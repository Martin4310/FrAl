table 5110480 "POI Main Product Groups"
{
    Caption = 'Main Product Groups';
    // DrillDownFormID = Form5110440;
    // LookupFormID = Form5110440;

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
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }
}

