tableextension 50950 "POI Sales Inv. Header Ext" extends "Sales Invoice Header"
{
    fields
    {
        field(5087900; "POI Promised Delivery Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Promised Delivery Date';
        }
    }

}