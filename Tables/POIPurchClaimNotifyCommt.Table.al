table 5110464 "POI Purch. Claim Notify Commt"
{

    Caption = 'Purch. Claim Notify Comment';

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
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Header,Footer,Line';
            OptionMembers = " ",Header,Footer,Line;
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Comment; Text[100])
        {
            Caption = 'Comment';
        }
        field(50030; "User-ID"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Doc. Line No.", Type, "Line No.")
        {
        }
    }

    trigger OnInsert()
    begin
        "User-ID" := copystr(UPPERCASE(USERID()), 1, 50);
    end;
}

