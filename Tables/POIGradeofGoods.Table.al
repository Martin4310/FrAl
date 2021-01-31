table 5110308 "POI Grade of Goods"
{
    Caption = 'Grade of Goods';
    DrillDownPageID = 5110423;
    LookupPageID = 5110423;

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
        field(12; "Search Description"; Code[30])
        {
            Caption = 'Search Description';
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
        lrc_Item.SETRANGE("POI Grade of Goods Code", Code);
        IF NOT lrc_Item.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT002Txt);

        lrc_ItemLedgerEntry.SETRANGE("POI Grade of Goods Code", Code);
        IF NOT lrc_ItemLedgerEntry.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT003Txt);

        lrc_BatchVariant.SETRANGE("Grade of Goods Code", Code);
        IF NOT lrc_BatchVariant.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT001Txt);
    end;

    var
        ADF_GT_TEXT001Txt: Label 'Löschung nicht zulässig. Kaliber in Pos.-Var. vorhanden!';
        ADF_GT_TEXT002Txt: Label 'Löschung nicht zulässig. Kaliber in Artikelnr. vorhanden!';
        ADF_GT_TEXT003Txt: Label 'Löschung nicht zulässig. Kaliber in Artikelposten vorhanden!';
}

