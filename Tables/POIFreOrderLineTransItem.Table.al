table 5110606 "POI Fre Order Line Trans. Item"
{
    Caption = 'Freight Order Line Trans. Item';
    // DrillDownFormID = Form5088027;
    // LookupFormID = Form5088027;

    fields
    {
        field(1; "Tour Order No."; Code[20])
        {
            Caption = 'Tour Order No.';
        }
        field(2; "Tour Order Line No."; Integer)
        {
            Caption = 'Tour Order Line No.';
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(10; "Item Description"; Text[30])
        {
            Caption = 'Item Description';
        }
        field(11; "Item Description 2"; Text[30])
        {
            Caption = 'Item Description 2';
        }
        field(50; "Calc. Quantity"; Decimal)
        {
            Caption = 'Calc. Quantity';
        }
        field(52; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
    }

    keys
    {
        key(Key1; "Tour Order No.", "Tour Order Line No.", "Item No.")
        {
            SumIndexFields = "Calc. Quantity", Quantity;
        }
    }
}

