table 5110552 "POI Vendor - Import Documents"
{
    Caption = 'Vendor - Import Documents';

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(3; "Import Document Code"; Code[20])
        {
            Caption = 'Import Document Code';
            TableRelation = "POI Import Documents";
        }
        field(10; "Due Date before Receiving"; DateFormula)
        {
            Caption = 'Due Date before Receiving';
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Import Document Code")
        {
        }
    }
}

