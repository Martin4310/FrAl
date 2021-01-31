table 5110401 "POI Item Main Category"
{
    Caption = 'Item Main Category';
    // DrillDownFormID = Form5110441;
    // LookupFormID = Form5110441;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                "Search Description" := Description;
            end;
        }
        field(5110302; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(5110305; "Sorting in Price List"; Integer)
        {
            Caption = 'Sorting in Price List';
        }
        field(5110306; "Description in Pricelist"; Text[50])
        {
            Caption = 'Description in Pricelist';
        }
        field(5110311; "Def. Base Unit of Measure"; Code[10])
        {
            Caption = 'Def. Base Unit of Measure';
            TableRelation = "Unit of Measure" WHERE("POI Is Base Unit of Measure" = CONST(true));
        }
        field(5110320; "Product Group Code BNN"; Code[10])
        {
            Caption = 'Product Group Code BNN';
            //TableRelation = "BNN Product Group BNN";
        }
        field(5110321; "Product Group Code IfH"; Code[10])
        {
            Caption = 'Product Group Code IfH';
            //TableRelation = "BNN Product Group IfH";
        }
        field(5110325; "Item Group Code"; Code[10])
        {
            Caption = 'Item Group Code';
            //TableRelation = "Main Product Groups";
        }
        field(5110330; "Def. Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Def. Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(5110331; "Def. Inventory Posting Group"; Code[10])
        {
            Caption = 'Def. Inventory Posting Group';
            TableRelation = "Inventory Posting Group".Code;
        }
        field(5110332; "Def. Tax Group Code"; Code[10])
        {
            Caption = 'Def. Tax Group Code';
            TableRelation = "Tax Group".Code;
        }
        field(5110333; "Def. Costing Method"; Option)
        {
            Caption = 'Def. Costing Method';
            OptionCaption = 'FIFO,LIFO,Specific,Average,Standard';
            OptionMembers = FIFO,LIFO,Specific,"Average",Standard;
        }
        field(5110334; "Def. VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'Def. VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Sorting in Price List")
        {
        }
    }

    fieldgroups
    {
    }

    // trigger OnDelete()
    // var
    //     lrc_LabelCrossReference: Record "5110504";
    // begin
    //     ERROR('Datensatz darf nicht gelöscht werden');
    //     lrc_LabelCrossReference.SETRANGE( "Source Type",
    //       lrc_LabelCrossReference."Source Type"::"Item Main Category" );
    //     lrc_LabelCrossReference.SETRANGE( "Source No.", Code );
    //     IF lrc_LabelCrossReference.FIND('-') THEN
    //       lrc_LabelCrossReference.DELETEALL( TRUE );
    // end;

    trigger OnInsert()
    begin
        lrc_DimensionValue.SETRANGE("Dimension Code", 'ARTIKELHAUPTKAT');
        lrc_DimensionValue.SETRANGE(Code, Code);
        IF NOT lrc_DimensionValue.FINDSET(FALSE, FALSE) THEN BEGIN
            lrc_DimensionValue.INIT();
            lrc_DimensionValue."Dimension Code" := 'ARTIKELHAUPTKAT';
            lrc_DimensionValue.Code := Code;
            lrc_DimensionValue.Name := Description;
            lrc_DimensionValue.INSERT();
        END;
    end;

    trigger OnRename()
    begin
        ERROR('Datensatz darf nicht umbenannt werden');
    end;

    var
        lrc_DimensionValue: Record "Dimension Value";
}

