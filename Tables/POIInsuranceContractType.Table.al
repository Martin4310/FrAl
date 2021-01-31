table 50914 "POI Insurance Contract Type"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Contract Type Code"; Code[20])
        {
            Caption = 'Contract Type Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Insurance No."; Code[20])
        {
            Caption = 'Insurance No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
        }
        field(4; Type; Option)
        {
            Optionmembers = Product,Status,Rating;
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Insurance No.", "Contract Type Code", Type)
        {
            Clustered = true;
        }
    }

}