table 5110304 "POI Caliber"
{
    Caption = 'Caliber';
    DrillDownPageID = "POI Caliber";
    LookupPageID = "POI Caliber";

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
        field(11; "Is Caliber Group"; Boolean)
        {
            Caption = 'Is Caliber Group';
        }
        field(12; "Is Caliber Mix"; Boolean)
        {
            Caption = 'Is Caliber Mix';
        }
        field(20; "Search Description"; Code[30])
        {
            Caption = 'Search Description';
        }
        // field(48; "No. of Entries Caliber Group"; Integer)
        // {
        //     BlankNumbers = BlankZero;
        //     CalcFormula = Count ("Caliber Detail" WHERE("Caliber Code" = FIELD(Code)));
        //     Caption = 'No. of Entries Caliber Group';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(49; "Sort Sequence"; Integer)
        {
            Caption = 'Sort Sequence';
        }
        field(50; "Internal Code in Item No."; Code[10])
        {
            Caption = 'Internal Code in Item No.';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_Item: Record Item;
        lrc_ItemLedgerEntry: Record "Item Ledger Entry";
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        lrc_Item.SETRANGE("POI Caliber Code", Code);
        IF NOT lrc_Item.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT002Txt);

        lrc_ItemLedgerEntry.SETRANGE("POI Caliber", Code);
        IF NOT lrc_ItemLedgerEntry.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT003Txt);

        lrc_BatchVariant.SETRANGE("Caliber Code", Code);
        IF NOT lrc_BatchVariant.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT001Txt);
    end;

    trigger OnModify()
    var
        lcu_BaseData: Codeunit "POI Base Data Mgt";
    begin
        lcu_BaseData.IC_CopyCaliber(Rec);
    end;

    var
        ADF_GT_TEXT001Txt: Label 'Löschung nicht zulässig. Kaliber in Pos.-Var. vorhanden!';
        ADF_GT_TEXT002Txt: Label 'Löschung nicht zulässig. Kaliber in Artikelnr. vorhanden!';
        ADF_GT_TEXT003Txt: Label 'Löschung nicht zulässig. Kaliber in Artikelposten vorhanden!';
}

