table 50947 "POI Parameter"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Department; Code[10])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        field(2; "Source Type"; Option)
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
            OptionCaption = ',Contact,Customer,Vendor,Item';
            OptionMembers = " ",Contact,Customer,Vendor,Item;
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            TableRelation = if ("Source Type" = const(Contact)) Contact."No."
            else
            if ("Source Type" = const(Customer)) Customer."No."
            else
            if ("Source Type" = const(Item)) Item."No."
            else
            if ("Source Type" = const(Vendor)) Vendor."No.";
        }
        field(4; Typecode1; Code[20])
        {
            Caption = 'Typecode 1';
            DataClassification = CustomerContent;
        }
        field(5; Typecode2; Code[20])
        {
            Caption = 'Typecode 2';
            DataClassification = CustomerContent;
        }
        field(6; Typecode3; Code[20])
        {
            Caption = 'Typecode 3';
            DataClassification = CustomerContent;
        }
        field(7; "Base Item No."; Code[20])
        {
            Caption = 'Base Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No." where(Blocked = const(false), "POI Is Base Item" = const(true));
        }
        field(8; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
            TableRelation = Item."No." where(Blocked = const(false), "POI Base Item Code" = field("Base Item No."));
        }
        field(9; ValueCode; Code[20])
        {
            Caption = 'VWert Code';
            DataClassification = CustomerContent;
        }
        field(10; ValueText; Text[100])
        {
            Caption = 'Wert Text';
            DataClassification = CustomerContent;
        }
        field(11; ValueInteger; Integer)
        {
            Caption = 'Wert Integer';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; Department, "Source Type", "Source No.", Typecode1, Typecode2, Typecode3)
        {
            Clustered = true;
        }
    }

}