table 50920 "POI Packing Cost Controle"
{
    Caption = 'Packing Cost Controle';

    fields
    {
        field(1; "Pack. Order No."; Code[20])
        {
            Caption = 'Pack. Order No.';
        }
        field(10; "Pack.-by Vendor No."; Code[20])
        {
            Caption = 'Pack.-by Vendor No.';
            TableRelation = Vendor;
        }
        field(11; "Pack.-by Name"; Text[50])
        {
            Caption = 'Pack.-by Name';
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(21; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(22; "Item Description 2"; Text[100])
        {
            Caption = 'Item Description 2';
        }
        field(30; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(31; "Packing Date"; Date)
        {
            CaptionClass = '5110700,1,2';
            Caption = 'Packing Date';
        }
        field(40; "Calc. Pack. Cost Amount"; Decimal)
        {
            Caption = 'Calc. Pack. Cost Amount';
        }
        field(50; "Invoice Recieved"; Boolean)
        {
            Caption = 'Invoice Recieved';
        }
        field(51; "Date Invoice Recieved"; Date)
        {
            Caption = 'Date Invoice Recieved';
        }
        field(55; "Pack. Invoice No."; Code[20])
        {
            Caption = 'Pack. Invoice No.';
        }
        field(56; "Pack. Invoice Date"; Date)
        {
            Caption = 'Pack. Invoice Date';
        }
        field(58; "Pack. Cost Amount"; Decimal)
        {
            Caption = 'Pack. Cost Amount';
        }
        field(60; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Pack. Order No.")
        {
        }
    }
}

