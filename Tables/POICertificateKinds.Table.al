table 50007 "POI Certificate Kinds"
{
    DataPerCompany = false;
    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Comment"; Text[50])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(key1; Code) { }
    }
}