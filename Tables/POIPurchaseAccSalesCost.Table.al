table 5087960 "POI Purchase Acc. Sales Cost"
{
    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(4; "Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            TableRelation = "POI Cost Category";
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(25; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                Amount := "Direct Unit Cost" * Quantity;
            end;
        }
        field(26; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';

            trigger OnValidate()
            begin
                Amount := "Direct Unit Cost" * Quantity;
            end;
        }
        field(30; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(31; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(32; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(35; "Amount (MW)"; Decimal)
        {
            Caption = 'Amount (MW)';
        }
        field(40; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Cost Category Code")
        {
        }
    }
}

