tableextension 50110 "POI Ship-To Address Ext." extends "Ship-to Address"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "POI successor Customer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'successor Customer';
        }
        field(5110330; "POI Appendix Shipment Method"; Text[30])
        {
            Caption = 'Appendix Shipment Method';
            Description = 'FV';
        }
    }
}