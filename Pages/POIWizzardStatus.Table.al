table 50945 "POI Wizzard Status"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Type"; option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionCaption = ',Artikel,Debitor,Kreditor';
            OptionMembers = " ",Item,Customer,Vendor;
        }
        field(2; Status; Code[20])
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Beschreibung';
            DataClassification = CustomerContent;
        }
        field(4; Step; Integer)
        {
            Caption = 'Schritt-Nr.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Type", Status)
        {
            Clustered = true;
        }
    }

}