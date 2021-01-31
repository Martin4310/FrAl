table 5110526 "POI Product Group - Trademark"
{
    Caption = 'Product Group - Trademark';
    // DrillDownFormID = Form5110445;
    // LookupFormID = Form5110445;

    fields
    {
        field(2; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            NotBlank = true;
            TableRelation = "POI Product Group".Code;
        }
        field(3; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(10; "Trademark Description"; Text[30])
        {
            CalcFormula = Lookup ("POI Trademark".Description WHERE(Code = FIELD("Trademark Code")));
            Caption = 'Trademark Description';
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
        key(Key1; "Product Group Code", "Trademark Code")
        {
        }
    }

    var
        Text000Txt: Label 'Processing #1###############2#########', Comment = '#1 #2';
        Text001Txt: Label 'Deleting Entries';
        Text003Txt: Label 'Do you want to delete all %1 and create them automatically from the %2?', Comment = '%1 %2';

    procedure FillFromBatch(DeleteAllRecs: Boolean)
    var
        ProdGrpTrademark: Record "POI Product Group - Trademark";
        Batch: Record "POI Batch";
        OK: Boolean;
        Dialog: Dialog;
    begin
        // -----------------------------------------------------------------
        // Funktion zum Laden der Kombinationen aus den Buchungen
        // -----------------------------------------------------------------

        IF NOT CONFIRM(Text003Txt, FALSE, TABLECAPTION(), Batch.TABLECAPTION()) THEN
            EXIT;

        Dialog.OPEN(Text000Txt);

        IF DeleteAllRecs THEN BEGIN
            Dialog.UPDATE(1, Text001Txt);
            ProdGrpTrademark.DELETEALL();
            COMMIT();
        END;

        IF Batch.FINDSET() THEN
            REPEAT
                Dialog.UPDATE(1, STRSUBSTNO(Text000Txt, Batch.TABLECAPTION(), Batch."No."));

                ProdGrpTrademark.INIT();
                ProdGrpTrademark."Product Group Code" := Batch."Product Group Code";
                ProdGrpTrademark."Trademark Code" := Batch."Trademark Code";
                OK := ProdGrpTrademark.INSERT();
            UNTIL Batch.NEXT() = 0;

        Dialog.CLOSE();
    end;
}

