table 5087939 "POI Batch Var. - Locations"
{

    fields
    {
        field(1; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
        }
        field(2; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(10; "Assigned Locations"; Code[150])
        {
            Caption = 'Assigned Locations';
        }
    }

    keys
    {
        key(Key1; "Batch Variant No.")
        {
        }
        key(Key2; "Batch No.")
        {
        }
    }
}

