table 50940 "POI Item Specification"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(2; "Line No:"; integer)
        {
            Caption = 'Zeilennr.';
            DataClassification = CustomerContent;
        }
        field(3; "Attribut Name"; Text[100])
        {
            Caption = 'Merkmalsname';
            DataClassification = CustomerContent;
        }
        field(4; "Attribut Value"; Text[100])
        {
            Caption = 'Merkmalswert';
            DataClassification = CustomerContent;
        }
        field(5; Dependency; Option)
        {
            Caption = 'abhängig von';
            OptionCaption = ' ,Item,Customer,Vendor';
            OptionMembers = " ",Item,Customer,Vendor;
            DataClassification = CustomerContent;
        }
        field(6; Mandatory; Boolean)
        {
            Caption = 'Pflichtfeld';
            DataClassification = CustomerContent;
        }
        field(7; Blocked; Boolean)
        {
            Caption = 'gesperrt';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Item No.", "Line No:")
        {
            Clustered = true;
        }
    }

}