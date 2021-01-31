table 5110326 "POI Container"
{

    Caption = 'Container';
    // DrillDownFormID = Form5110444;
    // LookupFormID = Form5110444;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(11; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,20,40,40-HC';
            OptionMembers = " ","20","40","40-HC";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }
}

