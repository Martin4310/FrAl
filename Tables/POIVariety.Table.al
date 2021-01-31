table 5110303 "POI Variety"
{

    Caption = 'Sorte';
    DrillDownPageID = 5110420;
    LookupPageID = 5110420;

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

            trigger OnValidate()
            begin
                "Search Description" := Description;
            end;
        }
        field(12; "Search Description"; Code[30])
        {
            Caption = 'Search Description';
        }
        field(20; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;

            trigger OnValidate()
            begin
                TESTFIELD(Code);
                AttachVarietyToProductGroup();
            end;
        }
        field(50; "Internal Code in Item No."; Code[10])
        {
            Caption = 'Internal Code in Item No.';
        }
        // field(60;"Product Group Description";Text[30])
        // {
        //     CalcFormula = Lookup("Product Group".Description WHERE (Code=FIELD(Product Group Code)));
        //     Caption = 'Product Group Description';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(70; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Product Group Code")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_Item: Record Item;
        lrc_ItemLedgerEntry: Record "Item Ledger Entry";
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        lrc_Item.SETRANGE("POI Variety Code", Code);
        IF NOT lrc_Item.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT002Txt);

        lrc_ItemLedgerEntry.SETRANGE("POI Caliber", Code);
        IF NOT lrc_ItemLedgerEntry.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT003Txt);

        lrc_BatchVariant.SETRANGE("Variety Code", Code);
        IF NOT lrc_BatchVariant.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT001Txt);
    end;

    trigger OnModify()
    var
        lcu_BaseData: Codeunit "POI Base Data Mgt";
    begin
        lcu_BaseData.IC_CopyVariety(Rec);
    end;

    var
        ADF_GT_TEXT001Txt: Label 'Löschung nicht zulässig. Sorte in Pos.-Var. vorhanden!';
        ADF_GT_TEXT002Txt: Label 'Löschung nicht zulässig. Sorte in Artikelnr. vorhanden!';
        ADF_GT_TEXT003Txt: Label 'Löschung nicht zulässig. Sorte in Artikelposten vorhanden!';

    procedure CreateSearchDesc()
    var
        lrc_Variety: Record "POI Variety";
    begin
        // ----------------------------------------------------------------------
        // Funktion zur Erstellung des Suchbegriffes
        // ----------------------------------------------------------------------

        lrc_Variety.RESET();
        IF lrc_Variety.FIND('-') THEN
            REPEAT
                lrc_Variety."Search Description" := lrc_Variety.Description;
                lrc_Variety.MODIFY();
            UNTIL lrc_Variety.NEXT() = 0;
    end;

    procedure AttachVarietyToProductGroup()
    // var
    //     lrc_ProductGroupVariety: Record "5110319"; //TODO: Product Gruppe
    begin
        // ----------------------------------------------------------------------
        // Zuordnung in die Referenztabelle Productgroup - Variety eintragen
        // ----------------------------------------------------------------------

        // IF "Product Group Code" <> '' THEN BEGIN
        //     lrc_ProductGroupVariety.Reset();
        //     lrc_ProductGroupVariety.SETRANGE("Product Group Code", "Product Group Code");
        //     lrc_ProductGroupVariety.SETRANGE("Variety Code", Code);
        //     IF NOT lrc_ProductGroupVariety.FIND('-') THEN BEGIN
        //         lrc_ProductGroupVariety.Reset();
        //         lrc_ProductGroupVariety.INIT();
        //         lrc_ProductGroupVariety.VALIDATE("Product Group Code", "Product Group Code");
        //         lrc_ProductGroupVariety.VALIDATE("Variety Code", Code);
        //         lrc_ProductGroupVariety.INSERT(TRUE);
        //     END;
        // END ELSE BEGIN
        //     lrc_ProductGroupVariety.Reset();
        //     lrc_ProductGroupVariety.SETRANGE("Variety Code", Code);
        //     lrc_ProductGroupVariety.DELETEALL();
        // END;
    end;
}

