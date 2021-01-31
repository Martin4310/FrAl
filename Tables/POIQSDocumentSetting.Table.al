table 50900 "POI QS Document Setting"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[10])
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

}