table 5087922 "POI Language Translation 2"
{
    Caption = 'Language Translation 2';
    DataCaptionFields = "Customer Posting Group", "Line Type";
    // DrillDownFormID = Form5088011;
    // LookupFormID = Form5088011;
    PasteIsValid = false;

    fields
    {
        field(1; "Table ID"; Integer)
        {
            Caption = 'Table ID';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(5; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(9; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(13; "Customer Country Code"; Code[80])
        {
            Caption = 'Customer Country Code';
            TableRelation = "Country/Region";
        }
        field(17; "Departure Country Code"; Code[10])
        {
            Caption = 'Departure Country Code';
            TableRelation = "Country/Region";
        }
        field(21; "Arrival Country Code"; Code[20])
        {
            Caption = 'Arrival Country Code';
            TableRelation = "Country/Region";
        }
        field(22; "Not Arrival Country Code"; Code[10])
        {
        }
        field(25; "Shipment Type"; Option)
        {
            Caption = 'Shipment Type';
            OptionCaption = 'Franco,Selbstabholer';
            OptionMembers = Franco,Selbstabholer;
        }
        field(29; "Line Type"; Option)
        {
            Caption = 'Zeilenart';
            OptionCaption = 'Item,G/L Account,,,,,Subtype VVE';
            OptionMembers = Item,"G/L Account",,,,,"Subtype VVE";
        }
        field(33; "Line Code"; Code[20])
        {
            Caption = 'Zeilencode';
            TableRelation = IF ("Line Type" = CONST(Item)) Item
            ELSE
            IF ("Line Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Line Type" = CONST("Subtype VVE")) "G/L Account";
        }
        field(37; "Additional Inv. Text 1"; Text[100])
        {
            Caption = 'Additional Inv. Text 1';
        }
        field(41; "Additional Inv. Text 2"; Text[100])
        {
            Caption = 'Additional Inv. Text 2';
        }
        field(45; "Additional Inv. Text 3"; Text[100])
        {
            Caption = 'Additional Inv. Text 3';
        }
        field(49; "Additional Inv. Text 4"; Text[100])
        {
            Caption = 'Additional Inv. Text 4';
        }
        field(50001; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(50002; "Departure Location Code"; Code[10])
        {
            Caption = 'Departure Location Code';
            TableRelation = Location;
        }
        field(50003; Source; Option)
        {
            Caption = 'Source';
            Description = 'Sales,Purchase';
            OptionCaption = 'Sales,Purchase';
            OptionMembers = Sales,Purchase;
        }
        field(50004; "State Customer Duty"; Option)
        {
            Caption = 'State Customer Duty';
            OptionCaption = ' ,Duty Paid,Duty unpaid';
            OptionMembers = " ","Duty Paid","Duty unpaid";
        }
        field(50005; "Sales/Purch Doc. Type"; Option)
        {
            Caption = 'Sales Doc. Type';
            OptionCaption = ' ,Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,,,,,Picking Order';
            OptionMembers = " ",Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,,,,,,"Picking Order";
        }
        field(50006; "Sales/Purch Doc. Subtype Code"; Code[10])
        {
            Caption = 'Sales Doc. Subtype Code';
            TableRelation = IF (Source = CONST(Sales)) "POI Sales Doc. Subtype".Code
            ELSE
            IF (Source = CONST(Purchase)) "POI Purch. Doc. Subtype".Code;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Language Code", "Customer Posting Group", "Customer Country Code", "Departure Country Code", "Arrival Country Code", "Not Arrival Country Code", "Shipment Method Code", "Shipment Type", "Departure Location Code", Source, "State Customer Duty", "Sales/Purch Doc. Type", "Sales/Purch Doc. Subtype Code", "Line Type", "Line Code")
        {
        }
        key(Key2; "Table ID", "Customer Posting Group", "Customer Country Code", "Departure Country Code", "Arrival Country Code", "Not Arrival Country Code", "Shipment Method Code", "Shipment Type", "Line Type", "Line Code")
        {
        }
    }
}

