table 5110457 "POI Sales Claim Notify Reason"
{
    Caption = 'Sales Claim Notify Reason';
    // DrillDownFormID = Form5110544;
    // LookupFormID = Form5110544;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Doc. Line No."; Integer)
        {
            Caption = 'Doc. Line No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Item';
            OptionMembers = " ",Item;
        }
        field(11; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(Item)) Item;
        }
        field(15; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(16; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch";
        }
        field(17; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF (Type = CONST(Item),
                                "No." = FILTER(''),
                                "Master Batch No." = FILTER(''),
                                "Batch No." = FILTER('')) "POI Batch Variant"
            ELSE
            IF (Type = CONST(Item),
                                         "No." = FILTER(<> ''),
                                         "Master Batch No." = FILTER(''),
                                         "Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("No."))
            ELSE
            IF (Type = CONST(Item),
                                                  "Master Batch No." = FILTER(<> ''),
                                                  "Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("No."),
                                                                                               "Master Batch No." = FIELD("Master Batch No."))
            ELSE
            IF (Type = CONST(Item),
                                                                                                        "Master Batch No." = FILTER(<> ''),
                                                                                                        "Batch No." = FILTER(<> '')) "POI Batch Variant" WHERE("Item No." = FIELD("No."),
                                                                                                                                                       "Master Batch No." = FIELD("Master Batch No."),
                                                                                                                                                       "Batch No." = FIELD("Batch No."));
        }
        field(20; "Claim Reason Code"; Code[20])
        {
            Caption = 'Claim Reason Code';
            TableRelation = "POI Claim Reason" WHERE("Sales Reason" = CONST(true));
        }
        field(21; "Claim Reason Description"; Text[50])
        {
            CalcFormula = Lookup ("POI Claim Reason".Description WHERE(Code = FIELD("Claim Reason Code")));
            Caption = 'Claim Reason Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; Comment; Text[100])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Doc. Line No.", "Line No.")
        {
        }
    }

    trigger OnInsert()
    var
        lrc_SalesClaimAdviceLine: Record "POI Sales Claim Notify Line";
    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_SalesClaimAdviceReason.SETRANGE("Document No.", "Document No.");
            lrc_SalesClaimAdviceReason.SETRANGE("Doc. Line No.", "Doc. Line No.");
            IF lrc_SalesClaimAdviceReason.FIND('+') THEN
                "Line No." := lrc_SalesClaimAdviceReason."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        lrc_SalesClaimAdviceLine.GET("Document No.", "Doc. Line No.");
        "Master Batch No." := lrc_SalesClaimAdviceLine."Master Batch No.";
        "Batch No." := lrc_SalesClaimAdviceLine."Batch No.";
        "Batch Variant No." := lrc_SalesClaimAdviceLine."Batch Variant No.";
    end;

    var
        lrc_SalesClaimAdviceReason: Record "POI Sales Claim Notify Reason";
}

