table 5110319 "POI Product Group - Variety"
{
    Caption = 'Product Group - Variety';
    // DrillDownFormID = Form5110439;
    // LookupFormID = Form5110439;

    fields
    {
        field(2; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            NotBlank = true;
            TableRelation = "POI Product Group".Code;

            trigger OnValidate()

            begin
                //IF ( "Product Group Code" <> xRec."Product Group Code" ) AND
                //   ( "Product Group Code" <> '' ) THEN BEGIN
                lrc_ProductGroup.RESET();
                lrc_ProductGroup.SETRANGE(Code, "Product Group Code");
                IF lrc_ProductGroup.FIND('-') THEN
                    IF lrc_ProductGroup.COUNT() = 1 THEN
                        "Product Group Description" := lrc_ProductGroup.Description;
                // END;
            end;
        }
        field(3; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety".Code;

            trigger OnValidate()
            var
                lrc_Variety: Record "POI Variety";
            begin
                IF ("Variety Code" <> xRec."Variety Code") AND ("Variety Code" <> '') THEN
                    IF lrc_Variety.GET("Variety Code") THEN
                        "Variety Description" := lrc_Variety.Description;
            end;
        }
        field(10; "Variety Description"; Text[50])
        {
            CalcFormula = Lookup ("POI Variety".Description WHERE(Code = FIELD("Variety Code")));
            Caption = 'Variety Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Product Group Description"; Text[50])
        {
            CalcFormula = Lookup ("POI Product Group".Description WHERE(Code = FIELD("Product Group Code")));
            Caption = 'Product Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Variety Search Description"; Code[50])
        {
            CalcFormula = Lookup ("POI Variety"."Search Description" WHERE(Code = FIELD("Variety Code")));
            Caption = 'Variety Search Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Product Group Code", "Variety Code")
        {
        }
    }

    procedure FillFromBatch(vbn_DeleteAll: Boolean)
    var
        lrc_ProductGroupVariety: Record "POI Product Group - Variety";
        lrc_Batch: Record "POI Batch";
        ldg_Dialog: Dialog;
    begin
        // -----------------------------------------------------------------
        // Funktion zum Laden der Kombinationen aus den Buchungen
        // -----------------------------------------------------------------

        ldg_Dialog.OPEN('Bearbeite #1########################');

        IF vbn_DeleteAll = TRUE THEN BEGIN
            ldg_Dialog.UPDATE(1, 'Löschung Einträge');
            lrc_ProductGroupVariety.DELETEALL();
            COMMIT();
        END;

        IF lrc_Batch.FIND('-') THEN
            REPEAT
                ldg_Dialog.UPDATE(1, 'Batch ' + lrc_Batch."No.");

                lrc_ProductGroupVariety.RESET();
                lrc_ProductGroupVariety.INIT();
                lrc_ProductGroupVariety."Product Group Code" := lrc_Batch."Product Group Code";
                lrc_ProductGroupVariety."Variety Code" := lrc_Batch."Variety Code";
                IF NOT lrc_ProductGroupVariety.INSERT() THEN;

            UNTIL lrc_Batch.NEXT() = 0;

        ldg_Dialog.CLOSE();
    end;

    var
        lrc_ProductGroup: Record "POI Product Group";
}

