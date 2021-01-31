table 50944 "POI Unit of Measure Details"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Unit of Measure"; code[20])
        {
            Caption = 'Unit of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure".Code;
        }
        field(2; "Source Type"; Option)
        {
            Caption = 'Herkunftsart';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Customer,Vendor,Item';
            OptionMembers = " ",Customer,Vendor,Item;
        }
        field(3; "Source Code"; Code[20])
        {
            Caption = 'Herkunftsnr.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor
            else
            if ("Source Type" = const(Item)) Item;
        }
        field(4; "Stacking height in mm"; Decimal)
        {
            Caption = 'Stapelhöhe in mm';
            DataClassification = CustomerContent;
        }
        field(5; "Stacking height layers"; Decimal)
        {
            Caption = 'Stapelhöhe in Lagen';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Unit of Measure", "Source Type", "Source Code")
        {
            Clustered = true;
        }
    }

}