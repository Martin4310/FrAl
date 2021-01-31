table 50948 "POI Workflow Task"
{
    DataClassification = CustomerContent;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Source Type"; enum "POI User Type")
        {
            Caption = 'Art';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "Source No."; Code[50])
        {
            Caption = 'Herkunftsnummer';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "ID"; RecordId)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; Description; Text[120])
        {
            Caption = 'Beschreibung';
            DataClassification = CustomerContent;
        }
        field(6; Status; Enum "POI Task Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(7; "Delegated from"; Code[50])
        {
            Caption = 'Delegiert von';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Task No."; Code[20])
        {
            Caption = 'Aufgabennr.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; Archiv; Boolean)
        {
            Caption = 'archiviert';
            DataClassification = CustomerContent;
        }
        Field(10; Company; Code[50])
        {
            Caption = 'Mandant';
            DataClassification = CustomerContent;
            TableRelation = "POI Company".Mandant;
        }
        Field(11; "Account Code"; Code[20])
        {
            Caption = 'Geschäftspartnernr.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(12; "Function Code"; Code[20])
        {
            Caption = 'Funktion';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Chain Code"; Code[20])
        {
            Caption = 'Chain Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Last Reminder Date"; Date)
        {
            Caption = 'Letzte Erinnerung am:';
            DataClassification = CustomerContent;
        }
        field(15; RecordLink; Text[250])
        {
            Caption = 'Datensatzlink';
            ExtendedDatatype = URL;
            Editable = false;
        }
        field(100; "WF Group No"; Integer)
        {
            Caption = 'Gruppierungscode';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}