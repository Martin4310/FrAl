table 50916 "POI Contract Data"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Vertragsnr.';
            DataClassification = CustomerContent;
        }
        field(2; "Contract Line"; Integer)
        {
            Caption = 'Zeilennr.';
            DataClassification = CustomerContent;
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Kreditornr.';
            DataClassification = CustomerContent;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Artikelnr.';
            DataClassification = CustomerContent;
        }
        field(5; "valid from"; Date)
        {
            Caption = 'gültig ab';
            DataClassification = CustomerContent;
        }
        field(6; "valid to"; Date)
        {
            Caption = 'gültig bis';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Beschreibung';
            DataClassification = CustomerContent;
        }
        field(8; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Betrag';
        }
        field(9; Period; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ",month,year;
            OptionCaption = ',Monat,Jahr';
        }
    }

    keys
    {
        key(PK; "contract No.", "Contract Line")
        {
            Clustered = true;
        }
    }

}