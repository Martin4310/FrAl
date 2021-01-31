table 5110562 "POI Purch./Sales Doc. Refer."
{
    Caption = 'Purch./Sales Doc. Reference';

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            Description = 'Purchase,Sales,Transfer';
            OptionCaption = 'Purchase,Sales,Transfer';
            OptionMembers = Purchase,Sales,Transfer;
        }
        field(3; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Description = ' ,Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,,,,,Picking Order,None';
            InitValue = "None";
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,,,,,Picking Order,None';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,,,,,,"Picking Order","None";
        }
        field(4; "Doc. Subtype Code"; Code[10])
        {
            Caption = 'Doc. Subtype Code';
            TableRelation = IF (Source = CONST(Sales),
                                "Document Type" = FILTER(None)) "POI Sales Doc. Subtype".Code
            ELSE
            IF (Source = CONST(Sales),
                                         "Document Type" = FILTER(<> None)) "POI Sales Doc. Subtype".Code WHERE("Document Type" = FIELD("Document Type"))
            ELSE
            IF (Source = CONST(Purchase),
                                                  "Document Type" = FILTER(None)) "POI Purch. Doc. Subtype".Code
            ELSE
            IF (Source = CONST(Purchase),
                                                           "Document Type" = FILTER(<> None)) "POI Purch. Doc. Subtype".Code WHERE("Document Type" = FIELD("Document Type"));
        }
        field(6; "Reference Type"; Option)
        {
            Caption = 'Reference Type';
            Description = 'Cust. Price Group,Shipping Agent,Location,Payment Term,Shipment Method';
            OptionCaption = 'Cust. Price Group,Shipping Agent,Location,Payment Term,Shipment Method,Arrival Region';
            OptionMembers = "Cust. Price Group","Shipping Agent",Location,"Payment Term","Shipment Method","Arrival Region";
        }
        field(10; "Reference Source Code"; Code[20])
        {
            Caption = 'Referenz Herkunftscode';
            TableRelation = IF (Source = CONST(Sales)) Customer."No."
            ELSE
            IF (Source = CONST(Purchase)) Vendor."No.";
        }
        field(11; "Reference Code"; Code[20])
        {
            Caption = 'Reference Code';
            TableRelation = IF (Source = CONST(Sales),
                                "Reference Type" = CONST("Cust. Price Group")) "Customer Price Group".Code
            ELSE
            IF ("Reference Type" = CONST("Shipping Agent")) "Shipping Agent".Code
            ELSE
            IF ("Reference Type" = CONST(Location)) Location.Code
            ELSE
            IF ("Reference Type" = CONST("Payment Term")) "Payment Terms".Code
            ELSE
            IF ("Reference Type" = CONST("Shipment Method")) "Shipment Method".Code
            ELSE
            IF ("Reference Type" = CONST("Arrival Region")) "POI Departure Region".Code;
        }
    }

    keys
    {
        key(Key1; Source, "Document Type", "Doc. Subtype Code", "Reference Source Code", "Reference Type")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Reference Type" = "Reference Type"::"Cust. Price Group" THEN
            TESTFIELD(Source, Source::Sales)
        ELSE
            IF "Reference Type" = "Reference Type"::"Arrival Region" THEN
                TESTFIELD(Source, Source::Sales);
    end;
}

