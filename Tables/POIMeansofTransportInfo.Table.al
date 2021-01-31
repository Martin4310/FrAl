table 5110575 "POI Means of Transport Info"
{

    Caption = 'Means of Transport Info';
    // DrillDownFormID = Form5110398;
    // LookupFormID = Form5110398;

    fields
    {
        field(1; "Code"; Code[30])
        {
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

