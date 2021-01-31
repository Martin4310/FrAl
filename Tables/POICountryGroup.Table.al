table 5110332 "POI Country Group"
{

    Caption = 'Country Group';
    // DrillDownFormID = Form50019;
    // LookupFormID = Form50019;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
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

