table 5110397 "POI Customer Main Group"
{
    Caption = 'Customer Main Group';
    // DrillDownFormID = Form5110307;
    // LookupFormID = Form5110307;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
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
        // IF NOT SingleInstance.GetSync() THEN
        //   ERROR('Sie dürfen die Debitorenhauptgruppe nicht ändern');
    end;

    trigger OnInsert()
    var
        lrc_DimensionValue: Record "Dimension Value";
    begin
        lrc_DimensionValue.INIT();
        lrc_DimensionValue."Dimension Code" := 'Debitorenhauptgruppe';
        lrc_DimensionValue.Code := Code;
        lrc_DimensionValue.Name := Description;
        lrc_DimensionValue.INSERT();
    end;

    trigger OnRename()
    begin
        ERROR('Sie dürfen die Debitorenhauptgruppe nicht umbenennen');
    end;

    var
    //SingleInstance: Codeunit "60020";
}

