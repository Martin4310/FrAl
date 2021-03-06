table 5110312 "POI Coding"
{

    Caption = 'Coding';
    // DrillDownFormID = Form5110427;
    // LookupFormID = Form5110427;

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
        field(20; "EAN Source"; Option)
        {
            Caption = 'EAN Source';
            Description = 'Herkunft der Kodierung';
            OptionCaption = ' ,Mandant EAN,,Debitor EAN,,,,SAN,,,,,,Kreditor EAN,Sonstige';
            OptionMembers = " ","Mandant EAN",,"Debitor EAN",,,,SAN,,,,,,"Kreditor EAN",Sonstige;
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
        lrc_Item.SETRANGE("POI Coding Code", Code);
        IF NOT lrc_Item.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT002Txt);

        lrc_ItemLedgerEntry.SETRANGE("POI Coding Code", Code);
        IF NOT lrc_ItemLedgerEntry.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT003Txt);

        lrc_BatchVariant.SETRANGE("Coding Code", Code);
        IF NOT lrc_BatchVariant.ISEMPTY() THEN
            ERROR(ADF_GT_TEXT001Txt);
    end;

    var
        ADF_GT_TEXT001Txt: Label 'Löschung nicht zulässig. Kodierung in Pos.-Var. vorhanden!';
        ADF_GT_TEXT002Txt: Label 'Löschung nicht zulässig. Kodierung in Artikelnr. vorhanden!';
        ADF_GT_TEXT003Txt: Label 'Löschung nicht zulässig. Kodierung in Artikelposten vorhanden!';
}

