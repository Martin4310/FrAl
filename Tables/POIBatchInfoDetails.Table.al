table 50102 "POI Batch Info Details"
{
    Caption = 'Batch Info Details';
    //DrillDownFormID = Form5110354;
    //LookupFormID = Form5110354;

    fields
    {
        field(1; "Batch Source Type"; Option)
        {
            Caption = 'Batch Source Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Master Batch No.,Batch No.,Batch Variant No.';
            OptionMembers = "Master Batch No.","Batch No.","Batch Variant No.";
        }
        field(2; "Batch Source No."; Code[20])
        {
            Caption = 'Batch Source No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Batch Source Type" = CONST("Master Batch No.")) "POI Master Batch"."No." WHERE("No." = FIELD("Batch Source No."))
            ELSE
            IF ("Batch Source Type" = CONST("Batch No.")) "POI Batch"."No." WHERE("No." = FIELD("Batch Source No."))
            ELSE
            IF ("Batch Source Type" = CONST("Batch Variant No.")) "POI Batch Variant"."No." WHERE("No." = FIELD("Batch Source No."));
        }
        field(3; "Field Caption"; Option)
        {
            Caption = 'Field Caption';
            DataClassification = CustomerContent;
            OptionCaption = 'Info 1,Info 2,Info 3,Info 4';
            OptionMembers = "Info 1","Info 2","Info 3","Info 4";
        }
        field(4; "Comment Type"; Option)
        {
            Caption = 'Comment Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Internal,Sales Information,Quality Information';
            OptionMembers = " ",Internal,"Sales Information","Quality Information";
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; Comment; Text[100])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(11; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(12; "User ID"; Code[20])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
        }
        field(13; "Modified Date"; Date)
        {
            Caption = 'Modified Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Modified from User ID"; Code[20])
        {
            Caption = 'Modified from User ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
        }
    }

    keys
    {
        key(Key1; "Batch Source Type", "Batch Source No.", "Field Caption", "Comment Type", "Line No.")
        {
        }
    }

    trigger OnInsert()
    begin
        "User ID" := CopyStr(USERID(), 1, 20);
        "Modified Date" := TODAY();
        "Modified from User ID" := CopyStr(USERID(), 1, 20);
    end;

    trigger OnModify()
    begin
        "Modified Date" := TODAY();
        "Modified from User ID" := CopyStr(USERID(), 1, 20);
    end;

    trigger OnRename()
    var
        SSPText001Txt: Label 'Not renaming permitted !';
    begin
        ERROR(SSPText001Txt);
    end;

}

