table 5110504 "POI Label Cross Reference"
{
    Caption = 'Label Cross Reference';

    fields
    {
        field(1; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Item Main Category,Item Category,Product Group,Item';
            OptionMembers = "Item Main Category","Item Category","Product Group",Item;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST("Item Main Category")) "POI Item Main Category".Code
            ELSE
            IF ("Source Type" = CONST("Item Category")) "Item Category".Code
            ELSE
            IF ("Source Type" = CONST("Product Group")) "POI Product Group".Code
            ELSE
            IF ("Source Type" = CONST(Item)) Item."No.";
        }
        field(4; "Cross-Reference Type"; Option)
        {
            Caption = 'Cross-Reference Type';
            OptionCaption = ' ,Customer,Vendor,Company Chain,Customer Group';
            OptionMembers = " ",Customer,Vendor,"Company Chain","Customer Group";
        }
        field(5; "Cross-Reference Type No."; Code[30])
        {
            Caption = 'Cross-Reference Type No.';
            TableRelation = IF ("Cross-Reference Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Cross-Reference Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Cross-Reference Type" = CONST("Company Chain")) "POI Company Chain".Code
            ELSE
            IF ("Cross-Reference Type" = CONST("Customer Group")) "POI Customer Group".Code;
        }
        field(6; "Usage Type"; Option)
        {
            Caption = 'Usage Type';
            OptionCaption = ' ,Warehouse Receipts,Warehouse Shipment,Packing Order,Sorting Order';
            OptionMembers = " ","Warehouse Receipts","Warehouse Shipment","Packing Order","Sorting Order";
        }
        field(7; Labelusage; Option)
        {
            Caption = 'Labelusage';
            OptionCaption = ' ,Collo Unit Label,Packing Unit Label,Content Unit Label,Transport Unit Label,Freight Unit Label';
            OptionMembers = "Collo Unit Label","Packing Unit Label","Content Unit Label","Transport Unit Label","Freight Unit Label";
        }
        field(8; "Cross-Reference Report ID"; Integer)
        {
            Caption = 'Cross-Reference No. Report ID';
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(100; "Picture I"; BLOB)
        {
            Caption = 'Picture I';
        }
        field(101; "Picture II"; BLOB)
        {
            Caption = 'Picture II';
        }
        field(102; "Picture III"; BLOB)
        {
            Caption = 'Picture III';
        }
        field(103; "Picture IV"; BLOB)
        {
            Caption = 'Picture IV';
        }
        field(104; "Picture V"; BLOB)
        {
            Caption = 'Picture V';
        }
        field(50000; "Reference Item No."; Text[30])
        {
            Caption = 'Reference Item No.';
        }
        field(60000; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            Description = '!!! --  mit zu Primekey -- !!!';
            NotBlank = true;
            TableRelation = IF ("Source Type" = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("Source No."));
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source No.", "Cross-Reference Type", "Cross-Reference Type No.", "Unit of Measure", "Usage Type", Labelusage)
        {
        }
        key(Key2; "Cross-Reference Type", "Cross-Reference Type No.")
        {
        }
    }

    trigger OnInsert()
    begin
        IF ("Cross-Reference Type No." <> '') AND
           ("Cross-Reference Type" = "Cross-Reference Type"::" ")
        THEN
            ERROR(Text000Txt, FIELDCAPTION("Cross-Reference Type No."));
    end;

    trigger OnRename()
    begin
        IF ("Cross-Reference Type No." <> '') AND
           ("Cross-Reference Type" = "Cross-Reference Type"::" ")
        THEN
            ERROR(Text000Txt, FIELDCAPTION("Cross-Reference Type No."));
    end;

    var
        Text000Txt: Label 'You cannot enter a  %1 for a blank Cross-Reference Type.', Comment = '%1';
}

