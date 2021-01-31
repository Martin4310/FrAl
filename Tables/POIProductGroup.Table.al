table 50933 "POI Product Group"
{
    Caption = 'Product Group';
    //LookupFormID = Form5731;

    fields
    {
        field(1; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category".Code;
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            Description = 'von 30 auf 50';

            trigger OnValidate()
            begin
                "Search Description" := Description;
            end;
        }
        field(7300; "Warehouse Class Code"; Code[10])
        {
            Caption = 'Warehouse Class Code';
            TableRelation = "Warehouse Class";
        }
        field(5110300; "Def. Batch Item"; Boolean)
        {
            Caption = 'Def. Batch Item';

            trigger OnValidate()
            var
                lcu_BatchMgt: Codeunit "POI BAM Batch Management";
            begin
                lcu_BatchMgt.SetBatchItemInItem(Rec);
            end;
        }
        field(5110301; "Stockout Warning"; Option)
        {
            Caption = 'Stockout Warning';
            OptionCaption = ' ,Warning,Blocking';
            OptionMembers = " ",Warning,Blocking;

            trigger OnValidate()
            begin
                lrc_Item.SETCURRENTKEY("POI Item Main Category Code", "Item Category Code", "POI Product Group Code", "Search Description");
                lrc_Item.SETRANGE("POI Product Group Code", Code);
                IF lrc_Item.FIND('-') THEN
                    REPEAT
                        lrc_Item."POI Stock Action on neg. Check" := "Stockout Warning";
                        lrc_Item.MODIFY();
                    UNTIL lrc_Item.NEXT() = 0;
            end;
        }
        field(5110302; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(5110303; "Def. Item Typ"; Option)
        {
            Caption = 'Def. Item Typ';
            Description = 'Trade Item,,Empties Item,Transport Item,,Packing Material,,,Spare Parts,,Insurance Item,Freight Item,Dummy Item';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material,,,Spare Parts,,Insurance Item,Freight Item,Dummy Item';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material",,,"Spare Parts",,"Insurance Item","Freight Item","Dummy Item";
        }
        field(5110305; "Sorting in Price List"; Integer)
        {
            Caption = 'Sorting in Price List';
        }
        field(5110306; "Save Cust. Sales Price"; Boolean)
        {
            Caption = 'Save Cust. Sales Price';
        }
        field(5110308; "Def. Tariff No."; Code[10])
        {
            Caption = 'Def. Tariff No.';
            TableRelation = "Tariff Number";
        }
        field(5110310; "Def. Cultivation Type"; Option)
        {
            Caption = 'Def. Cultivation Type';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(5110311; "Def. Base Unit of Measure"; Code[10])
        {
            Caption = 'Def. Base Unit of Measure';
            Description = 'FV';
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
        field(5110466; "Transport Temperature"; Decimal)
        {
            BlankZero = true;
            Caption = 'Transport Temperature';
            DecimalPlaces = 0 : 2;
            Description = 'PVP';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Item Category Code", "Code")
        {
        }
    }

    trigger OnDelete()
    begin
        ERROR('Der Datensatz darf nicht gelöscht werden');
    end;

    trigger OnInsert()

    begin
        //RS Dimension anlegen
        lrc_DimensionValue.SETRANGE("Dimension Code", 'PRODUKTGRUPPE');
        lrc_DimensionValue.SETRANGE(Code, Code);
        IF NOT lrc_DimensionValue.FINDSET(FALSE, FALSE) THEN BEGIN
            lrc_DimensionValue.INIT();
            lrc_DimensionValue."Dimension Code" := 'PRODUKTGRUPPE';
            lrc_DimensionValue.Code := Code;
            lrc_DimensionValue.Name := Description;
            lrc_DimensionValue.INSERT();
        END;
    end;

    trigger OnRename()
    begin
        // Rename im Artikelstamm muss manuell ausprogrammiert werden
        ERROR('Der Datensatz darf nicht gelöscht werden');
    end;

    var
        lrc_Item: Record Item;
        lrc_DimensionValue: Record "Dimension Value";
}

