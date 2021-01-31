table 50908 "POI Certificate Control Board"
{
    Caption = 'Certificate Control Board';
    DataPerCompany = false;
    DrillDownPageID = "POI Certificate Control Board";
    LookupPageID = "POI Certificate Control Board";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(11; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(20; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(40; "Kontrollstellennr."; Code[20])
        {
            Caption = 'Kontrollstellennr.';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

