table 50951 "POI Department Function"
{
    DataClassification = CustomerContent;
    Caption = 'Abteilungsfunktionen';

    fields
    {
        field(1; "Department Code"; Enum "POI Department")
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
        }
        Field(2; "Function Code"; Code[20])
        {
            Caption = 'Funktionscode';
            DataClassification = CustomerContent;
        }
        field(3; "Function Name"; Text[50])
        {
            Caption = 'Funktionsbeschreibung';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Department Code"; "Function Code")
        {
            Clustered = true;
        }
    }

}