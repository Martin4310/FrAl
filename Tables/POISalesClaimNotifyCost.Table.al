table 5110731 "POI Sales Claim Notify Cost"
{
    Caption = 'Sales Claim Notify Cost';
    // DrillDownFormID = Form5088071;
    // LookupFormID = Form5088071;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Doc. Line No.';
        }
        field(10; "Doc. Type"; Option)
        {
            Caption = 'Doc. Type';
            OptionCaption = 'Credit Memo,Invoice';
            OptionMembers = "Credit Memo",Invoice;

            trigger OnValidate()
            begin
                IF "Doc. Type" <> "Doc. Type"::"Credit Memo" THEN
                    ERROR('Option für zukünftigen Gebrauch!');
            end;
        }
        field(12; "Send to"; Option)
        {
            Caption = 'Send to';
            OptionCaption = 'Customer,Vendor';
            OptionMembers = Customer,Vendor;

            trigger OnValidate()
            begin
                IF "Send to" <> "Send to"::Customer THEN
                    ERROR('Option für zukünftigen Gebrauch!');
            end;
        }
        field(14; "Send to No."; Code[20])
        {
            Caption = 'Empfänger Nr.';
            TableRelation = IF ("Send to" = CONST(Customer)) Customer
            ELSE
            IF ("Send to" = CONST(Vendor)) Vendor;
        }
        field(30; "Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            TableRelation = "POI Cost Category" WHERE("Allowed in Sales Claim Notify" = CONST(true));

            trigger OnValidate()
            var
                lrc_CostCategory: Record "POI Cost Category";
            begin
                IF lrc_CostCategory.GET("Cost Category Code") THEN
                    "Posting Description" := lrc_CostCategory.Description
                ELSE
                    "Posting Description" := '';
            end;
        }
        field(34; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "POI Cost Category Accounts"."G/L Account No." WHERE("Cost Category Code" = FIELD("Cost Category Code"));
        }
        field(40; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(46; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(50; "Attached to Doc. Line No."; Integer)
        {
            Caption = 'Attached to Doc. Line No.';
            TableRelation = "POI Sales Claim Notify Line"."Line No." WHERE("Document No." = FIELD("Document No."));

            trigger OnValidate()
            begin
                IF "Line No." = 0 THEN BEGIN
                    lrc_SalesClaimAdviceCost.SETRANGE("Document No.", "Document No.");
                    IF lrc_SalesClaimAdviceCost.FIND('+') THEN
                        "Line No." := lrc_SalesClaimAdviceCost."Line No." + 10000
                    ELSE
                        "Line No." := 10000;
                END;
            end;
        }
        field(52; "In Document"; Option)
        {
            Caption = 'In Document';
            OptionCaption = 'Credit Memo Document,Separat Document,Single Document';
            OptionMembers = "Credit Memo Document","Separat Document","Single Document";

            trigger OnValidate()
            begin
                IF "In Document" <> "In Document"::"Credit Memo Document" THEN
                    ERROR('Option für zukünftigen Gebrauch!');
            end;
        }
        field(54; "Document Created"; Boolean)
        {
            Caption = 'Document Created';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            SumIndexFields = "Amount (LCY)";
        }
    }

    trigger OnInsert()
    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_SalesClaimAdviceCost.SETRANGE("Document No.", "Document No.");
            IF lrc_SalesClaimAdviceCost.FIND('+') THEN
                "Line No." := lrc_SalesClaimAdviceCost."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;
    end;

    var
        lrc_SalesClaimAdviceCost: Record "POI Sales Claim Notify Cost";
}

