table 5110719 "POI Pack. Order Comment"
{
    Caption = 'Packing Order Comment';

    fields
    {
        field(1; "Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
            TableRelation = "POI Pack. Order Header"."No.";
        }
        field(2; "Doc. Line No. Output"; Integer)
        {
            Caption = 'Doc. Line No. Output';
            TableRelation = "POI Pack. Order Output Items"."Line No." WHERE("Doc. No." = FIELD("Doc. No."));
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Packing Order,,,Input Trade Item,,,Input Cost,,,Input Packing Material,,,Productionlines,,,Output Item,,,Label';
            OptionMembers = " ","Packing Order",,,"Input Trade Item",,,"Input Cost",,,"Input Packing Material",,,Productionlines,,,"Output Item",,,Label;
        }
        field(4; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Date; Date)
        {
            Caption = 'Date';
        }
        field(12; Comment; Text[120])
        {
            Caption = 'Comment';
        }
        field(50030; "User-ID"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Doc. No.", "Doc. Line No. Output", Type, "Source Line No.", "Line No.")
        {
        }
    }


    trigger OnInsert()
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
        "User-ID" := copystr(UPPERCASE(USERID()), 1, 20);
    end;

    trigger OnModify()
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;

    trigger OnRename()
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;
}

