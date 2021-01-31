table 5110317 "POI Product Group - Unit"
{
    Caption = 'Product Group - Unit';
    // DrillDownFormID = Form5110437;
    // LookupFormID = Form5110437;

    fields
    {
        field(2; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            NotBlank = true;
            TableRelation = "POI Product Group".Code;
        }
        field(3; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(10; "Unit of Measure Description"; Text[30])
        {
            CalcFormula = Lookup ("Unit of Measure".Description WHERE(Code = FIELD("Unit of Measure Code")));
            Caption = 'Unit of Measure Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Product Group Description"; Text[30])
        {
            CalcFormula = Lookup ("POI Product Group".Description WHERE(Code = FIELD("Product Group Code")));
            Caption = 'Product Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Unit Search Description"; Code[50])
        {
            CalcFormula = Lookup ("Unit of Measure"."POI Search Description" WHERE(Code = FIELD("Unit of Measure Code")));
            Caption = 'Unit Search Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Product Group Code", "Unit of Measure Code")
        {
        }
    }


    procedure FillFromBatch(vbn_DeleteAll: Boolean)
    var
        lrc_ProductGroupUnit: Record "POI Product Group - Unit";
        lrc_Batch: Record "POI Batch";
        ldg_Dialog: Dialog;
    begin
        // -----------------------------------------------------------------
        // Funktion zum Laden der Kombinationen aus den Buchungen
        // -----------------------------------------------------------------

        ldg_Dialog.OPEN('Bearbeite #1########################');

        IF vbn_DeleteAll = TRUE THEN BEGIN
            ldg_Dialog.UPDATE(1, 'Löschung Einträge');
            lrc_ProductGroupUnit.DELETEALL();
            COMMIT();
        END;

        IF lrc_Batch.FINDSET(FALSE, FALSE) THEN
            REPEAT
                ldg_Dialog.UPDATE(1, 'Batch ' + lrc_Batch."No.");
                lrc_ProductGroupUnit.RESET();
                lrc_ProductGroupUnit.INIT();
                lrc_ProductGroupUnit."Product Group Code" := lrc_Batch."Product Group Code";
                lrc_ProductGroupUnit."Unit of Measure Code" := lrc_Batch."Unit of Measure Code";
                IF NOT lrc_ProductGroupUnit.INSERT() THEN;
            UNTIL lrc_Batch.NEXT() = 0;

        ldg_Dialog.CLOSE();
    end;
}

