table 5110413 "POI Purch. Doc. Subtype Filter"
{
    // DrillDownFormID = Form5110413;
    // LookupFormID = Form5110413;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Purch. Doc. Subtype Code"; Code[10])
        {
            Caption = 'Purch. Doc. Subtype Code';
        }
        field(4; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Vendor,Location,Vendor Chain,,,Item Chain,,,Item,Product Group,Item Category,,,UserID';
            OptionMembers = Vendor,Location,"Vendor Chain",,,"Item Chain",,,Item,"Product Group","Item Category",,,UserID;
        }
        field(5; "Source No."; Code[50])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Vendor)) Vendor."No."
            ELSE
            IF (Source = CONST(Location)) Location.Code
            ELSE
            IF (Source = CONST("Vendor Chain")) "POI Company Chain".Code
            ELSE
            IF (Source = CONST("Item Chain")) "POI Company Chain".Code
            ELSE
            IF (Source = CONST(Item)) Item."No."
            ELSE
            IF (Source = CONST("Product Group")) "POI Product Group".Code
            ELSE
            IF (Source = CONST("Item Category")) "Item Category".Code
            ELSE
            IF (Source = CONST(Userid)) "User Setup"."User ID";
        }
        field(15; "Not Allowed"; Boolean)
        {
            Caption = 'Not Allowed';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Purch. Doc. Subtype Code", Source, "Source No.")
        {
        }
    }
}

