table 5110426 "POI Cust./Vend. Ext.Comm. Doc."
{
    Caption = 'Cust./Vend. Comment Print Doc.';
    // DrillDownFormID = Form5110426;
    // LookupFormID = Form5110426;

    fields
    {
        field(1; "Cust./Vend. Comment Entry No."; Integer)
        {
            Caption = 'Cust./Vend. Comment Entry No.';
        }
        field(2; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = ' ,Purchase,,,Sales,,,Transfer,,,Packerei,,,Sales Clearance Statement,Customs Clearance,Account Sales,Freight Order,Sales Statement';
            OptionMembers = " ",Purchase,,,Sales,,,Transfer,,,Packerei,,,"Sales Clearance Statement","Customs Clearance","Account Sales","Freight Order","Sales Statement";
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Transfer';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,Transfer;
        }
        field(4; "Print Document Code"; Code[20])
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
        field(17; "Posted Doc. Type"; Option)
        {
            Caption = 'Posted Doc. Type';
            OptionCaption = ' ,Posted Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt/Shipment';
            OptionMembers = " ","Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Receipt/Shipment";
        }
    }

    keys
    {
        key(Key1; "Cust./Vend. Comment Entry No.", Source, "Document Type", "Print Document Code", "Detail Code")
        {
        }
        key(Key2; "Sort Order")
        {
        }
    }
}

