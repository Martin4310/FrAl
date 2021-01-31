table 50939 "POI Certif. Cust/Vend Chapter"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'lfd. Nr.';
            DataClassification = CustomerContent;
        }
        field(2; "Certificate Type"; Code[20])
        {
            Caption = 'Certificate Type';
            DataClassification = CustomerContent;
        }
        field(3; "Certificate Chapter No."; Code[20])
        {
            Caption = 'Kapitelnr.';
            DataClassification = CustomerContent;
        }
        field(4; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = " ",confirmed,rejected;
            OptionCaption = ',erfüllt,abgelehnt';
            DataClassification = CustomerContent;
        }
        field(5; "Chapter Description"; Text[100])
        {
            Caption = 'Kapitelbezeichnung';
            DataClassification = CustomerContent;
        }
        field(10; "Dokument Link"; Text[250])
        {
            Caption = 'Link zum Dokument';
            DataClassification = CustomerContent;
            ExtendedDatatype = URL;
        }
    }


    keys
    {
        key(PK; "Entry No.", "Certificate Chapter No.")
        {
            Clustered = true;
        }
    }

}