table 50013 "POI Account setting Helper"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "AccountNo"; Code[20])
        {
            Caption = 'AccountNo';
            DataClassification = CustomerContent;
        }
        field(2; Company; Text[50])
        {
            Caption = 'Company';
            DataClassification = CustomerContent;
        }
        field(3; "PI European Sourcing"; Boolean)
        {
            Caption = 'PIES';
            DataClassification = CustomerContent;
        }
        field(4; "PI Fruit"; Boolean)
        {
            Caption = 'PI Fruit';
            DataClassification = CustomerContent;
        }
        field(5; "PI Organics"; Boolean)
        {
            Caption = 'PI Organics';
            DataClassification = CustomerContent;
        }
        field(6; "PI Bananas"; Boolean)
        {
            Caption = 'PI Bananas';
            DataClassification = CustomerContent;
        }
        field(7; "PI Dutch Growers"; Boolean)
        {
            Caption = 'PI Dutch Growers';
            DataClassification = CustomerContent;
        }
        field(8; "PI StammdatenPort"; Boolean)
        {
            Caption = 'PI StammdatenPort';
            DataClassification = CustomerContent;
        }
        field(9; "PI GmbH"; Boolean)
        {
            Caption = 'PI GmbH';
            DataClassification = CustomerContent;
        }
        field(10; "Account Type"; enum "POI VendorCustomer")
        {
            // OptionMembers = Vendor,Customer,Contact;
            // OptionCaption = 'Vendor,Customer,Contact';
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; "AccountNo", "Account Type")
        {
            Clustered = true;
        }
    }

}