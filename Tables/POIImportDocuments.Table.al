table 5110557 "POI Import Documents"
{
    Caption = 'Import Documents';
    // DrillDownFormID = Form5110498;
    // LookupFormID = Form5110498;

    fields
    {
        field(1; "Code"; Code[20])
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

