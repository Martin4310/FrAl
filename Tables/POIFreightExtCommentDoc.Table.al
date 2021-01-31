table 5087931 "POI Freight Ext Comment Doc."
{
    Caption = 'Freight Ord Comment Print Doc.';

    fields
    {
        field(1; "Freight Comment Entry No."; Integer)
        {
            Caption = 'Freight Comment Entry No.';
        }
        field(2; "Print Document Code"; Code[20])
        {
            Caption = 'Print Document Code';
            TableRelation = "POI Print Documents".Code WHERE("Document Source" = CONST(Sales));
        }
        field(5; "Detail Code"; Code[20])
        {
            Caption = 'Detail Code';
            Description = 'Spediteur,Lager';
        }
        field(10; "Print Document Description"; Text[50])
        {
            Caption = 'Print Document Description';
        }
        field(11; "Sort Order"; Integer)
        {
            Caption = 'Sort Order';
        }
        field(12; Print; Boolean)
        {
            Caption = 'Print';
        }
        field(13; Consignee; Option)
        {
            Caption = 'Consignee';
            OptionCaption = ' ,Order Address,,,Delivery Adress,,,Invoice Adress,,,Departure Warehouse,Arrival Warehouse,,Shipping Agent,,,Customer Clearance,,,Quality Control';
            OptionMembers = " ","Order Address",,,"Delivery Adress",,,"Invoice Adress",,,"Departure Warehouse","Arrival Warehouse",,"Shipping Agent",,,"Customer Clearance",,,"Quality Control";
        }
        field(15; "Multiple Entry for"; Option)
        {
            Caption = 'Multiple Entry for';
            OptionCaption = ' ,Location,Physical Location,Departure Region,,Shipping Agent';
            OptionMembers = " ",Location,"Physical Location","Departure Region",,"Shipping Agent";
        }
    }

    keys
    {
        key(Key1; "Freight Comment Entry No.", "Print Document Code", "Detail Code")
        {
        }
        key(Key2; "Sort Order")
        {
        }
    }
}

