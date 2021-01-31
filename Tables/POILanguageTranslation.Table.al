table 5110321 "POI Language Translation"
{
    Caption = 'Language Translation';
    // DrillDownFormID = Form5110321;
    // LookupFormID = Form5110321;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(4; "Code 2"; Code[20])
        {
            Caption = 'Code 2';
        }
        field(5; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(11; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(12; "Description 3"; Text[100])
        {
            Caption = 'Beschreibung 3';
        }
        field(13; "Description 4"; Text[100])
        {
            Caption = 'Beschreibung 4';
        }
    }

    keys
    {
        key(Key1; "Table ID", "Code", "Code 2", "Language Code")
        {
        }
    }
}

