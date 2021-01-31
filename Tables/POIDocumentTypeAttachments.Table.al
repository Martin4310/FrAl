table 50911 "POI Documenttype Attachments"
{
    Caption = 'Documenttype Attachments';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document type Code"; Code[10])
        {
            Caption = 'Document Type Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Document type Code")
        {
            Clustered = true;
        }
    }

}