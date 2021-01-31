table 5110379 "POI Intrastat Default Values"
{
    Caption = 'Intrastat Default Values';
    // DrillDownFormID = Form5110477;
    // LookupFormID = Form5110477;

    fields
    {
        field(1; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(2; "Business Transaction Type"; Option)
        {
            Caption = 'Business Transaction Type';
            OptionCaption = 'Sales,Sales Credit Memo,Purchase,Purchase Credit Memo';
            OptionMembers = Sales,"Sales Credit Memo",Purchase,"Purchase Credit Memo";
        }
        field(10; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(11; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(12; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(13; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
    }

    keys
    {
        key(Key1; "Gen. Bus. Posting Group", "Business Transaction Type")
        {
        }
    }
}

