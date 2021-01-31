table 5110420 "POI Claim Reason Group"
{
    Caption = 'Claim Reason Group';
    // DrillDownFormID = Form5087977;
    // LookupFormID = Form5087977;

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
        field(15; "Purchase Reason"; Boolean)
        {
            Caption = 'Purchase Reason';
        }
        field(16; "Sales Reason"; Boolean)
        {
            Caption = 'Sales Reason';
        }
        field(25; Emphasis; Decimal)
        {
            Caption = 'Emphasis';
            DecimalPlaces = 0 : 1;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }
}

