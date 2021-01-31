tableextension 50004 "POI GeneralLdgerSetupExt" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "POI Global Dimension 3 Code"; Code[20])
        {
            Caption = 'Global Dimension 3 Code';
            DataClassification = CustomerContent;
        }
        field(50001; "POI Global Dimension 4 Code"; Code[20])
        {
            Caption = 'Global Dimension 4 Code';
            DataClassification = CustomerContent;
        }
    }
}