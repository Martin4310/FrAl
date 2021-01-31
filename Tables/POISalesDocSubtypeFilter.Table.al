table 5110414 "POI Sales Doc. Subtype Filter"
{
    Caption = 'Sales Doc. Subtype Filter';
    // DrillDownFormID = Form5110411;
    // LookupFormID = Form5110411;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,Default Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,"Default Order";
        }
        field(2; "Sales Doc. Subtype Code"; Code[10])
        {
            Caption = 'Sales Doc. Subtype Code';
            TableRelation = IF ("Document Type" = CONST("Default Order")) "POI Sales Doc. Subtype".Code WHERE("Document Type" = CONST(Order))
            ELSE
            "POI Sales Doc. Subtype".Code;
        }
        field(4; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Customer,Location,Customer Chain,,,Item Chain,Item,Product Group,Item Category,,,UserID';
            OptionMembers = Customer,Location,"Customer Chain",,,"Item Chain",Item,"Product Group","Item Category",,,UserID;
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Customer)) Customer
            ELSE
            IF (Source = CONST(Location)) Location
            ELSE
            // IF (Source = CONST("Customer Chain")) "Company Chain"
            // ELSE
            // IF (Source = CONST("Item Chain")) "Company Chain"
            // ELSE
            IF (Source = CONST(Userid)) "User Setup"
            ELSE
            IF (Source = CONST(Item)) Item
            ELSE
            // IF (Source = CONST("Product Group")) "Product Group"
            // ELSE
            IF (Source = CONST("Item Category")) "Item Category";
        }
        field(10; "Only Head Office"; Boolean)
        {
            Caption = 'Only Head Office';
        }
        field(11; "Only Subsidiaries"; Boolean)
        {
            Caption = 'Only Subsidiaries';
        }
        field(15; "Not Allowed"; Boolean)
        {
            Caption = 'Not Allowed';
        }
    }

    keys
    {
        key(Key1; "Document Type", "Sales Doc. Subtype Code", Source, "Source No.")
        {
        }
    }

    fieldgroups
    {
    }
}

