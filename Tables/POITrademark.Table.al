table 5110306 "POI Trademark"
{

    Caption = 'Trademark';
    DrillDownPageID = 5110422;
    LookupPageID = 5110422;

    fields
    {
        field(1; "Code"; Code[20])
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
        field(14; "Belongs to Producer No."; Code[20])
        {
            Caption = 'Belongs to Producer No.';
            TableRelation = Vendor WHERE("POI Is Manufacturer" = CONST(true));
        }
        field(15; "Belongs to Vendor No."; Code[20])
        {
            Caption = 'Belongs to Vendor No.';
            TableRelation = Vendor;
        }
        field(20; "Filter Vendor No."; Code[20])
        {
            Caption = 'Filter Vendor No.';
            FieldClass = FlowFilter;
            TableRelation = Vendor;
            ValidateTableRelation = false;
        }
        field(21; "Trademark from Vendor"; Boolean)
        {
            CalcFormula = Exist ("POI Vendor - Trademark" WHERE("Trademark Code" = FIELD(Code),
                                                            "Vendor No." = FIELD(FILTER("Filter Vendor No."))));
            Caption = 'Trademark from Vendor';
            FieldClass = FlowField;
        }
        field(22; "Trademark Charge Perc."; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Trademark Charge Perc.';
            DecimalPlaces = 0 : 2;
            MaxValue = 100;
            MinValue = 0;
        }
        field(25; "BNN Trademark"; Code[10])
        {
            Caption = 'BNN Trademark';
        }
        field(30; "Belongs to Customer No."; Code[20])
        {
            Caption = 'Gehört zu Kundennr.';
            TableRelation = Customer."No.";
        }
        field(31; "Waste Company"; Option)
        {
            Caption = 'Entsorgungsunternehmen';
            OptionCaption = ' ,DSD,BellandVision,Interseroh,Edeka,,,,ARA';
            OptionMembers = " ",DSD,BellandVision,Interseroh,Edeka,,,,ARA;
        }
        field(32; "Waste Disposal Duty"; Option)
        {
            Caption = 'Entsorgung Pflichtig';
            OptionCaption = ' ,DSD Pflichtig,,,ARA Pflichtig';
            OptionMembers = " ","DSD Pflichtig",,,"ARA Pflichtig";
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
        //ERROR('Marke darf nicht gelöscht werden, bitte an Admin wenden'); TODO: Berechtigung einbauen

        lrc_Item.SETRANGE("POI Trademark Code", Code);
        IF NOT lrc_Item.ISEMPTY() THEN
            ERROR(POI_GT_TEXT002Txt);

        lrc_ItemLedgerEntry.SETRANGE("POI Trademark Code", Code);
        IF NOT lrc_ItemLedgerEntry.ISEMPTY() THEN
            ERROR(POI_GT_TEXT003Txt);

        lrc_BatchVariant.SETRANGE("Trademark Code", Code);
        IF NOT lrc_BatchVariant.ISEMPTY() THEN
            ERROR(POI_GT_TEXT001Txt);
    end;

    trigger OnInsert()
    var
        lrc_DimensionValue: Record "Dimension Value";
    begin
        lrc_DimensionValue.INIT();
        lrc_DimensionValue."Dimension Code" := 'MARKE';
        lrc_DimensionValue.Code := Code;
        lrc_DimensionValue.Name := Description;
        lrc_DimensionValue."Dimension Value Type" := lrc_DimensionValue."Dimension Value Type"::Standard;
        lrc_DimensionValue.INSERT();
    end;

    trigger OnRename()
    begin
        ERROR('Marke darf nicht umbenannt werden, bitte an Admin wenden');
    end;

    var
        POI_GT_TEXT001Txt: Label 'Löschung nicht zulässig. Kaliber in Pos.-Var. vorhanden!';
        POI_GT_TEXT002Txt: Label 'Löschung nicht zulässig. Kaliber in Artikelnr. vorhanden!';
        POI_GT_TEXT003Txt: Label 'Löschung nicht zulässig. Kaliber in Artikelposten vorhanden!';
}

