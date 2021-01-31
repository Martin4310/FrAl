table 5110421 "POI Claim Reason"
{
    // DrillDownFormID = Form5087976;
    // LookupFormID = Form5087976;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(12; "Search Name"; Code[20])
        {
            Caption = 'Search Name';
        }
        field(15; "Purchase Reason"; Boolean)
        {
            Caption = 'Purchase Reason';
        }
        field(16; "Sales Reason"; Boolean)
        {
            Caption = 'Sales Reason';
        }
        field(17; "Fault Reason"; Boolean)
        {
            Caption = 'Fault Reason';
        }
        field(20; "Claim Reason Group Code"; Code[10])
        {
            Caption = 'Claim Reason Group Code';
            TableRelation = "POI Claim Reason Group";
        }
        field(25; Emphasis; Decimal)
        {
            Caption = 'Emphasis';
            DecimalPlaces = 0 : 1;
        }
        field(30; "Default Item Charge"; Code[20])
        {
            Caption = 'Default Item Charge';
            TableRelation = "Item Charge";
        }
        field(31; "Default Gen. Prod. Posting Gr."; Code[20])
        {
            Caption = 'Default Gen. Prod. Posting Gr.';
            TableRelation = "Gen. Product Posting Group";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    trigger OnDelete()
    begin
        ERROR('Das Löschen von Reklamationsgrund ist nicht zulässig.');
    end;
}

