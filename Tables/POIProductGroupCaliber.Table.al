table 5110315 "POI Product Group - Caliber"
{
    Caption = 'Product Group - Caliber';
    // DrillDownFormID = Form5110436;
    // LookupFormID = Form5110436;

    fields
    {
        field(2; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            NotBlank = true;
            TableRelation = "POI Product Group".Code;
        }
        field(3; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber";
        }
        field(10; "Caliber Description"; Text[30])
        {
            CalcFormula = Lookup ("POI Caliber".Description WHERE(Code = FIELD("Caliber Code")));
            Caption = 'Caliber Description';
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
    }

    keys
    {
        key(Key1; "Product Group Code", "Caliber Code")
        {
        }
    }


    procedure FillFromBatch(vbn_DeleteAll: Boolean)
    var
        lrc_ProductGroupCaliber: Record "POI Product Group - Caliber";
        lrc_Batch: Record "POI Batch";
        ldg_Dialog: Dialog;
    begin
        // -----------------------------------------------------------------
        // Funktion zum Laden der Kombinationen aus den Buchungen
        // -----------------------------------------------------------------

        ldg_Dialog.OPEN('Bearbeite #1########################');

        IF vbn_DeleteAll = TRUE THEN BEGIN
            ldg_Dialog.UPDATE(1, 'Löschung Einträge');
            lrc_ProductGroupCaliber.DELETEALL();
            COMMIT();
        END;

        IF lrc_Batch.FIND('-') THEN
            REPEAT
                ldg_Dialog.UPDATE(1, 'Batch ' + lrc_Batch."No.");

                lrc_ProductGroupCaliber.RESET();
                lrc_ProductGroupCaliber.INIT();
                lrc_ProductGroupCaliber."Product Group Code" := lrc_Batch."Product Group Code";
                lrc_ProductGroupCaliber."Caliber Code" := lrc_Batch."Caliber Code";
                IF NOT lrc_ProductGroupCaliber.INSERT() THEN;

            UNTIL lrc_Batch.NEXT() = 0;

        ldg_Dialog.CLOSE();
    end;
}

