table 5110478 "POI Proper Name"
{

    Caption = 'Proper Name';
    // DrillDownFormID = Form5110431;
    // LookupFormID = Form5110431;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(12; "Search Description"; Code[30])
        {
            Caption = 'Search Description';
        }
        field(50000; Interseroh; Boolean)
        {
        }
        field(50001; Artikelnummer; Code[20])
        {
            TableRelation = Item;
        }
        field(50002; Einkaufspreis; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }
}

