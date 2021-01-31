table 5110458 "POI Sales Claim Notify Comment"
{

    Caption = 'Sales Claim Notify Comment';

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
        field(50; "Not Transfer To Credit Memo"; Boolean)
        {
            Caption = 'Not Transfer To Credit Memo';
        }
        field(50010; "Dok.Date"; Date)
        {
            Caption = 'Belegdatum';
        }
        field(50020; "Status from"; Code[50])
        {
            Caption = 'Status von';
        }
        field(50021; "Status Date"; Date)
        {
            Caption = 'Status am';
        }
        field(50022; "Claim Status"; Option)
        {
            Caption = 'Reklamationsstatus';
            OptionMembers = erfasst,"zur Prüfung",Kreditormeldung,Abrechnen,Gutschrifterstellung;

            trigger OnValidate()
            begin
                "Status from" := copystr(USERID(), 1, 50);
                "Status Date" := TODAY();
            end;
        }
        field(50023; Status; Boolean)
        {
            Caption = 'Status';
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
        key(Key2; "Document No.", "Dok.Date", "Claim Status")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Dok.Date" = 0D THEN "Dok.Date" := TODAY();
        IF "Status Date" = 0D THEN "Status Date" := TODAY();
        IF "Status from" = '' THEN "Status from" := copystr(USERID(), 1, 50);
        "User-ID" := copystr(UPPERCASE(USERID()), 1, 50);
    end;
}

