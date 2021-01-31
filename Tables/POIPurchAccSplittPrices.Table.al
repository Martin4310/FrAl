table 5110740 "POI Purch. Acc. Splitt Prices"
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
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(45; "Original Purchase Price"; Decimal)
        {
            Caption = 'Original Purchase Price';
        }
        field(50; "1. Quantity"; Decimal)
        {
            Caption = '1. Menge';

            trigger OnValidate()
            begin
                "1. Direct Unit Cost Amount" := "1. Quantity" * "1. Direct Unit Cost";
            end;
        }
        field(51; "1. Direct Unit Cost"; Decimal)
        {
            Caption = '1. Ek-Preis';

            trigger OnValidate()
            begin
                "1. Direct Unit Cost Amount" := "1. Quantity" * "1. Direct Unit Cost";
            end;
        }
        field(52; "1. Direct Unit Cost Amount"; Decimal)
        {
            Caption = '1. Ek-Betrag';
        }
        field(59; "1. Comment"; Text[50])
        {
            Caption = '1. Bemerkung';
        }
        field(60; "2. Quantity"; Decimal)
        {
            Caption = '2. Menge';

            trigger OnValidate()
            begin
                "2. Direct Unit Cost Amount" := "2. Quantity" * "2. Direct Unit Cost";
            end;
        }
        field(61; "2. Direct Unit Cost"; Decimal)
        {
            Caption = '2. Ek-Preis';

            trigger OnValidate()
            begin
                "2. Direct Unit Cost Amount" := "2. Quantity" * "2. Direct Unit Cost";
            end;
        }
        field(62; "2. Direct Unit Cost Amount"; Decimal)
        {
            Caption = '2. Ek-Betrag';
        }
        field(69; "2. Comment"; Text[50])
        {
            Caption = '2. Bemerkung';
        }
        field(70; "3. Quantity"; Decimal)
        {
            Caption = '3. Menge';

            trigger OnValidate()
            begin
                "3. Direct Unit Cost Amount" := "3. Quantity" * "3. Direct Unit Cost";
            end;
        }
        field(71; "3. Direct Unit Cost"; Decimal)
        {
            Caption = '3. Ek-Preis';

            trigger OnValidate()
            begin
                "3. Direct Unit Cost Amount" := "3. Quantity" * "3. Direct Unit Cost";
            end;
        }
        field(72; "3. Direct Unit Cost Amount"; Decimal)
        {
            Caption = '3. Ek-Betrag';
        }
        field(79; "3. Comment"; Text[50])
        {
            Caption = '3. Bemerkung';
        }
        field(80; "4. Quantity"; Decimal)
        {
            Caption = '4. Menge';

            trigger OnValidate()
            begin
                "4. Direct Unit Cost Amount" := "4. Quantity" * "4. Direct Unit Cost";
            end;
        }
        field(81; "4. Direct Unit Cost"; Decimal)
        {
            Caption = '4. Ek-Preis';

            trigger OnValidate()
            begin
                "4. Direct Unit Cost Amount" := "4. Quantity" * "4. Direct Unit Cost";
            end;
        }
        field(82; "4. Direct Unit Cost Amount"; Decimal)
        {
            Caption = '4. Ek-Betrag';
        }
        field(89; "4. Comment"; Text[50])
        {
            Caption = '4. Bemerkung';
        }
        field(90; "5. Quantity"; Decimal)
        {
            Caption = '5. Menge';

            trigger OnValidate()
            begin
                "5. Direct Unit Cost Amount" := "5. Quantity" * "5. Direct Unit Cost";
            end;
        }
        field(91; "5. Direct Unit Cost"; Decimal)
        {
            Caption = '5. Ek-Preis';

            trigger OnValidate()
            begin
                "5. Direct Unit Cost Amount" := "5. Quantity" * "5. Direct Unit Cost";
            end;
        }
        field(92; "5. Direct Unit Cost Amount"; Decimal)
        {
            Caption = '5. Ek-Betrag';
        }
        field(99; "5. Comment"; Text[50])
        {
            Caption = '5. Bemerkung';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
        }
    }
}

