table 5087937 "POI Purchase Container Lines"
{
    Caption = 'Purchase Container Lines';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            Editable = false;
        }
        field(6; "Container Code"; Code[20])
        {
            Caption = 'Container Code';
            TableRelation = "POI Container";
            ValidateTableRelation = false;
        }
        field(8; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(15; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
        }
        field(16; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(17; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
        }
        field(20; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure Code';
        }
        field(22; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line No.", "Container Code", "Line No.")
        {
        }
    }
}

