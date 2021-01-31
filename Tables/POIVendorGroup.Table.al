table 5110394 "POI Vendor Group"
{
    Caption = 'Vendor Group';
    // DrillDownFormID = Form5110305;
    // LookupFormID = Form5110305;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = false;
            DataClassification = CustomerContent;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(20; "Vendor Main Group Code"; Code[10])
        {
            Caption = 'Customer Main Group Code';
            NotBlank = true;
            TableRelation = "POI Vendor Main Group";
            DataClassification = CustomerContent;
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
        ERROR('Sie dürfen die Kreditoregruppe nicht löschen');
    end;

    trigger OnInsert()
    var
        lrc_DimensionValue: Record "Dimension Value";
    begin
        lrc_DimensionValue.INIT();
        lrc_DimensionValue."Dimension Code" := 'KREDITORENHGRUPPE';
        lrc_DimensionValue.Code := Code;
        lrc_DimensionValue.Name := Description;
        lrc_DimensionValue.INSERT();
    end;

    trigger OnRename()
    begin
        ERROR('Sie dürfen die Kreditorengruppe nicht umbenennen');
    end;
}

