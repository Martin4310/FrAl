table 5110314 "POI Item Attribute 5"
{
    Caption = 'Item Attribute 5';
    // DrillDownFormID = Form5110429;
    // LookupFormID = Form5110429;

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
        field(11; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
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
        lrc_Item.SETRANGE("POI Item Attribute 5", Code);
        IF NOT lrc_Item.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT002Txt);

        lrc_ItemLedgerEntry.SETRANGE("POI Item Attribute 5", Code);
        IF NOT lrc_ItemLedgerEntry.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT003Txt);

        lrc_BatchVariant.SETRANGE("Item Attribute 5", Code);
        IF NOT lrc_BatchVariant.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT001Txt);
    end;

    var
        ADF_GT_TEXT001Txt: Label 'Löschung nicht zulässig. Aufbereitungsart in Pos.-Var. vorhanden!';
        ADF_GT_TEXT002Txt: Label 'Löschung nicht zulässig. Aufbereitungsart in Artikelnr. vorhanden!';
        ADF_GT_TEXT003Txt: Label 'Löschung nicht zulässig. Aufbereitungsart in Artikelposten vorhanden!';
}

