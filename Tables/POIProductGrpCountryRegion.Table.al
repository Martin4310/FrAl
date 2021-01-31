table 5110318 "POI Product Grp-Country/Region"
{
    Caption = 'Product Group - Country/Region';
    // DrillDownFormID = Form5110438;
    // LookupFormID = Form5110438;

    fields
    {
        field(2; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            NotBlank = true;
            TableRelation = "POI Product Group".Code;
        }
        field(3; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                lrc_Country: Record "Country/Region";
            begin
                IF lrc_Country.GET("Country/Region Code") THEN
                    "Country Group Code" := lrc_Country."POI Country Group Code"
                ELSE
                    "Country Group Code" := '';
            end;
        }
        field(10; "Country Group Code"; Code[10])
        {
            Caption = 'Country Group Code';
            Editable = false;
            TableRelation = "POI Country Group";
        }
        field(11; "Country/Region Name"; Text[30])
        {
            CalcFormula = Lookup ("Country/Region".Name WHERE(Code = FIELD("Country/Region Code")));
            Caption = 'Country/Region Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Product Group Description"; Text[30])
        {
            CalcFormula = Lookup ("POI Product Group".Description WHERE(Code = FIELD("Product Group Code")));
            Caption = 'Product Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Product Group Code", "Country/Region Code")
        {
        }
    }

    procedure FillFromBatch(vbn_DeleteAll: Boolean)
    var
        lrc_ProductGroupCountry: Record "POI Product Grp-Country/Region";
        lrc_Batch: Record "POI Batch";
        ldg_Dialog: Dialog;
    begin
        // -----------------------------------------------------------------
        // Funktion zum Laden der Kombinationen aus den Buchungen
        // -----------------------------------------------------------------

        ldg_Dialog.OPEN('Bearbeite #1########################');

        IF vbn_DeleteAll = TRUE THEN BEGIN
            ldg_Dialog.UPDATE(1, 'Löschung Einträge');
            lrc_ProductGroupCountry.DELETEALL();
            COMMIT();
        END;

        IF lrc_Batch.FIND('-') THEN
            REPEAT
                ldg_Dialog.UPDATE(1, 'Batch ' + lrc_Batch."No.");

                lrc_ProductGroupCountry.RESET();
                lrc_ProductGroupCountry.INIT();
                lrc_ProductGroupCountry."Product Group Code" := lrc_Batch."Product Group Code";
                lrc_ProductGroupCountry."Country/Region Code" := lrc_Batch."Country of Origin Code";
                IF NOT lrc_ProductGroupCountry.INSERT() THEN;

            UNTIL lrc_Batch.NEXT() = 0;

        ldg_Dialog.CLOSE();
    end;
}

