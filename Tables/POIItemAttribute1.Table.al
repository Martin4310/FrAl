table 5087982 "POI Item Attribute 1"
{
    Caption = 'Item Attribute 1';
    // DrillDownFormID = Form5110430;
    // LookupFormID = Form5110430;

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                "Search Description" := Description;
            end;
        }
        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(12; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }
}

