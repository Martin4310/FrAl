tableextension 50003 "POI GLAccountExt" extends "G/L Account"
{
    fields
    {
        field(50000; "POI Allowed in Purchase"; Boolean)
        {
            Caption = 'Allowed in Purchase';
            DataClassification = CustomerContent;
        }
        field(50001; "POI Allowed in Sales"; Boolean)
        {
            Caption = 'Allowed in Sales';
            DataClassification = CustomerContent;
        }
    }
}