table 5110393 "POI Vendor Main Group"
{

    Caption = 'Vendor Main Group';
    // DrillDownFormID = Form5110304;
    // LookupFormID = Form5110304;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
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
        ERROR('Sie dürfen die Kreditorenhauptgruppe nicht löschen');
    end;

    trigger OnInsert()
    var
        lrc_DimensionValue: Record "Dimension Value";
    begin
        lrc_DimensionValue.INIT();
        lrc_DimensionValue."Dimension Code" := 'KREDITORENHAUPTGR';
        lrc_DimensionValue.Code := Code;
        lrc_DimensionValue.Name := Description;
        lrc_DimensionValue.INSERT();
    end;

    trigger OnRename()
    begin
        ERROR('Sie dürfen die Kreditorenhauptgruppe nicht umbenennen');
    end;
}

