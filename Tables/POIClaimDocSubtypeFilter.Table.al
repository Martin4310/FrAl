table 5087972 "POI Claim Doc. Subtype Filter"
{

    Caption = 'Claim Doc. Subtype Filter';
    // DrillDownFormID = Form5088114;
    // LookupFormID = Form5088114;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Purchase Claim,Sales Claim';
            OptionMembers = "Purchase Claim","Sales Claim";
        }
        field(2; "Claim Doc. Subtype Code"; Code[10])
        {
            Caption = 'Claim Doc. Subtype Code';
        }
        field(4; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'UserID';
            OptionMembers = UserID;
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Userid)) "User Setup";
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
        key(Key1; "Document Type", "Claim Doc. Subtype Code", Source, "Source No.")
        {
        }
    }
}

