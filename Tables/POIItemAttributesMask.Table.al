table 5087974 "POI Item Attributes Mask"
{

    Caption = 'Item Attributes Mask';
    PasteIsValid = false;

    fields
    {
        field(1; "Area"; Option)
        {
            Caption = 'Area';
            OptionCaption = 'Item,Purchase,Sales,Packing';
            OptionMembers = Item,Purchase,Sales,Packing;
        }
        field(2; "Item Main Category Code"; Code[10])
        {
            Caption = 'Item Main Category';
            TableRelation = "POI Item Main Category";

            trigger OnLookup()
            var
                lrc_ItemMainCategory: Record "POI Item Main Category";
            begin
                IF Page.RUNMODAL(0, lrc_ItemMainCategory) = ACTION::LookupOK THEN
                    VALIDATE("Item Main Category Code", lrc_ItemMainCategory.Code);
            end;

            trigger OnValidate()
            begin
                IF "Item Main Category Code" = xRec."Item Main Category Code" THEN
                    EXIT;

                "Item Category Code" := '';
                "Product Group Code" := '';
                "Item No." := '';
            end;
        }
        field(3; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category';
            TableRelation = "Item Category";

            trigger OnLookup()
            var
                lrc_ItemCategory: Record "Item Category";
            begin
                IF "Item Main Category Code" <> '' THEN
                    lrc_ItemCategory.SETRANGE("POI Item Main Category Code", "Item Main Category Code");

                IF Page.RUNMODAL(0, lrc_ItemCategory) = ACTION::LookupOK THEN
                    VALIDATE("Item Category Code", lrc_ItemCategory.Code);
            end;

            trigger OnValidate()
            var
                lrc_ItemCategory: Record "Item Category";
                lrc_ItemMainCategory: Record "POI Item Main Category";
            begin
                IF "Item Category Code" = xRec."Item Category Code" THEN
                    EXIT;

                IF "Item Category Code" <> '' THEN BEGIN
                    lrc_ItemCategory.GET("Item Category Code");
                    lrc_ItemCategory.TESTFIELD("POI Item Main Category Code");

                    // Prüfung, ob Artikel Hauptkategorie existiert
                    lrc_ItemMainCategory.GET(lrc_ItemCategory."POI Item Main Category Code");
                    "Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
                END;

                "Product Group Code" := '';
                "Item No." := '';
            end;
        }
        field(4; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group';
            TableRelation = "POI Product Group".Code;

            trigger OnLookup()
            var
                lrc_ProductGroup: Record "POI Product Group";
            begin
                gco_ItemCategorieCode := '';

                IF "Item Category Code" <> '' THEN
                    lrc_ProductGroup.SETRANGE("Item Category Code", "Item Category Code");

                IF Page.RUNMODAL(0, lrc_ProductGroup) = ACTION::LookupOK THEN BEGIN
                    gco_ItemCategorieCode := lrc_ProductGroup."Item Category Code";
                    VALIDATE("Product Group Code", lrc_ProductGroup.Code);
                END;

                gco_ItemCategorieCode := '';
            end;

            trigger OnValidate()
            var
                lrc_ProductGroup: Record "POI Product Group";
                lrc_ItemCategory: Record "Item Category";
                lrc_ItemMainCategory: Record "POI Item Main Category";
            begin
                IF "Product Group Code" = xRec."Product Group Code" THEN
                    EXIT;
                "Item No." := '';
                IF "Product Group Code" = '' THEN
                    EXIT;

                IF gco_ItemCategorieCode <> '' THEN BEGIN
                    lrc_ProductGroup.SETRANGE("Item Category Code", gco_ItemCategorieCode);
                    gco_ItemCategorieCode := '';
                END ELSE
                    IF "Item Category Code" <> '' THEN
                        lrc_ProductGroup.SETRANGE("Item Category Code", "Item Category Code");

                lrc_ProductGroup.SETRANGE(Code, "Product Group Code");
                lrc_ProductGroup.FIND('-');

                // Artikelkategorie muss gefüllt werden
                lrc_ProductGroup.TESTFIELD("Item Category Code");

                // Prüfung, ob Artikelkategorie existiert
                lrc_ItemCategory.GET(lrc_ProductGroup."Item Category Code");
                lrc_ItemCategory.TESTFIELD("POI Item Main Category Code");

                // Prüfung, ob Artikel Hauptkategorie existiert
                lrc_ItemMainCategory.GET(lrc_ItemCategory."POI Item Main Category Code");

                "Item Category Code" := lrc_ProductGroup."Item Category Code";
                "Item Main Category Code" := lrc_ItemCategory."POI Item Main Category Code";
            end;
        }
        field(5; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";

            trigger OnLookup()
            var
                lrc_Item: Record Item;
            begin
                IF "Item Main Category Code" <> '' THEN
                    lrc_Item.SETRANGE("POI Item Main Category Code", "Item Main Category Code");

                IF "Item Category Code" <> '' THEN
                    lrc_Item.SETRANGE("Item Category Code", "Item Category Code");

                IF "Product Group Code" <> '' THEN
                    lrc_Item.SETRANGE("POI Product Group Code", "Product Group Code");

                IF Page.RUNMODAL(0, lrc_Item) = ACTION::LookupOK THEN
                    VALIDATE("Item No.", lrc_Item."No.");
            end;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF ("Item No." = xRec."Item No.") OR
                   ("Item No." = '') THEN
                    EXIT;

                lrc_Item.GET("Item No.");
                lrc_Item.TESTFIELD("POI Item Main Category Code");
                lrc_Item.TESTFIELD("Item Category Code");
                lrc_Item.TESTFIELD("POI Product Group Code");

                "Item Main Category Code" := lrc_Item."POI Item Main Category Code";
                "Item Category Code" := lrc_Item."Item Category Code";
                "Product Group Code" := lrc_Item."POI Product Group Code";
            end;
        }
        field(31; "Edit. Attributes"; Boolean)
        {
            Caption = 'Edit. Attributes';

            trigger OnValidate()
            begin
                IF "Edit. Attributes" = FALSE THEN BEGIN
                    "Edit. Variety" := 0;
                    "Edit. Country of Origin" := 0;
                    "Edit. Caliber" := 0;
                    "Edit. Vendor Caliber" := 0;
                    "Edit. Trademark" := 0;
                    "Edit. Grade of Goods" := 0;
                    "Edit. Coding" := 0;
                    "Edit Item Attribute 1" := 0;
                    "Edit Item Attribute 2" := 0;
                    "Edit Item Attribute 3" := 0;
                    "Edit Item Attribute 4" := 0;
                    "Edit Item Attribute 5" := 0;
                    "Edit Item Attribute 6" := 0;
                    "Edit Item Attribute 7" := 0;
                    "Edit Item Attribute 8" := 0;
                END ELSE BEGIN
                    "Edit. Variety" := 1;
                    "Edit. Country of Origin" := 1;
                    "Edit. Caliber" := 1;
                    "Edit. Vendor Caliber" := 1;
                    "Edit. Trademark" := 1;
                    "Edit. Grade of Goods" := 1;
                    "Edit. Coding" := 1;
                    "Edit Item Attribute 1" := 1;
                    "Edit Item Attribute 2" := 1;
                    "Edit Item Attribute 3" := 1;
                    "Edit Item Attribute 4" := 1;
                    "Edit Item Attribute 5" := 1;
                    "Edit Item Attribute 6" := 1;
                    "Edit Item Attribute 7" := 1;
                    "Edit Item Attribute 8" := 1;
                END;
            end;
        }
        field(32; "Edit. Variety"; Integer)
        {
            Caption = 'Edit. Variety';

            trigger OnValidate()
            begin
                TESTFIELD("Edit. Attributes", TRUE);
                CheckResetEditAttributes();
            end;
        }
        field(33; "Edit. Country of Origin"; Integer)
        {
            Caption = 'Edit. Country of Origin';

            trigger OnValidate()
            begin
                TESTFIELD("Edit. Attributes", TRUE);
                CheckResetEditAttributes();
            end;
        }
        field(34; "Edit. Caliber"; Integer)
        {
            Caption = 'Edit. Caliber';

            trigger OnValidate()
            begin
                TESTFIELD("Edit. Attributes", TRUE);
                CheckResetEditAttributes();
            end;
        }
        field(35; "Edit. Vendor Caliber"; Integer)
        {
            Caption = 'Edit. Vendor Caliber';

            trigger OnValidate()
            begin
                TESTFIELD("Edit. Attributes", TRUE);
                CheckResetEditAttributes();
            end;
        }
        field(36; "Edit. Trademark"; Integer)
        {
            Caption = 'Edit. Trademark';

            trigger OnValidate()
            begin
                TESTFIELD("Edit. Attributes", TRUE);
                CheckResetEditAttributes();
            end;
        }
        field(39; "Edit. Grade of Goods"; Integer)
        {
            Caption = 'Edit. Grade of Goods';

            trigger OnValidate()
            begin
                TESTFIELD("Edit. Attributes", TRUE);
                CheckResetEditAttributes();
            end;
        }
        field(42; "Edit. Coding"; Integer)
        {
            Caption = 'Edit. Coding';

            trigger OnValidate()
            begin
                TESTFIELD("Edit. Attributes", TRUE);
                CheckResetEditAttributes();
            end;
        }
        field(50; "Edit Item Attribute 1"; Integer)
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Edit Item Attribute 1';
        }
        field(51; "Edit Item Attribute 2"; Integer)
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Edit Item Attribute 2';
        }
        field(52; "Edit Item Attribute 3"; Integer)
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Edit Item Attribute 3';
        }
        field(53; "Edit Item Attribute 4"; Integer)
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Edit Item Attribute 4';
        }
        field(54; "Edit Item Attribute 5"; Integer)
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Edit Item Attribute 5';
        }
        field(55; "Edit Item Attribute 6"; Integer)
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Edit Item Attribute 6';
        }
        field(56; "Edit Item Attribute 7"; Integer)
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Edit Item Attribute 7';
        }
        field(57; "Edit Item Attribute 8"; Integer)
        {
            CaptionClass = '5110310,1,8';
            Caption = 'Edit Item Attribute 8';
        }
        field(61; "Mandatory Attributes"; Boolean)
        {
            Caption = 'Mandatory Attributes';

            trigger OnValidate()
            begin
                IF "Mandatory Attributes" = FALSE THEN BEGIN
                    "Mandatory Country of Origin" := 0;
                    "Mandatory Variety" := 0;
                    "Mandatory Caliber" := 0;
                    "Mandatory Vendor Caliber" := 0;
                    "Mandatory Trademark" := 0;
                    "Mandatory Grade of Goods" := 0;
                    "Mandatory Coding" := 0;
                    "Mandatory Item Attribute 1" := 0;
                    "Mandatory Item Attribute 2" := 0;
                    "Mandatory Item Attribute 3" := 0;
                    "Mandatory Item Attribute 4" := 0;
                    "Mandatory Item Attribute 5" := 0;
                    "Mandatory Item Attribute 6" := 0;
                    "Mandatory Item Attribute 7" := 0;
                    "Mandatory Item Attribute 8" := 0;
                END ELSE BEGIN
                    "Mandatory Country of Origin" := 1;
                    "Mandatory Variety" := 1;
                    "Mandatory Caliber" := 1;
                    "Mandatory Vendor Caliber" := 1;
                    "Mandatory Trademark" := 1;
                    "Mandatory Grade of Goods" := 1;
                    "Mandatory Coding" := 1;
                    "Mandatory Item Attribute 1" := 1;
                    "Mandatory Item Attribute 2" := 1;
                    "Mandatory Item Attribute 3" := 1;
                    "Mandatory Item Attribute 4" := 1;
                    "Mandatory Item Attribute 5" := 1;
                    "Mandatory Item Attribute 6" := 1;
                    "Mandatory Item Attribute 7" := 1;
                    "Mandatory Item Attribute 8" := 1;
                END;
            end;
        }
        field(62; "Mandatory Country of Origin"; Integer)
        {
            Caption = 'Mandatory Country of Origin';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Attributes", TRUE);
                CheckResetMandatoryAttributes();
            end;
        }
        field(63; "Mandatory Variety"; Integer)
        {
            Caption = 'Mandatory Variety';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Attributes", TRUE);
                CheckResetMandatoryAttributes();
            end;
        }
        field(64; "Mandatory Caliber"; Integer)
        {
            Caption = 'Mandatory Caliber';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Attributes", TRUE);
                CheckResetMandatoryAttributes();
            end;
        }
        field(65; "Mandatory Vendor Caliber"; Integer)
        {
            Caption = 'Mandatory Vendor Caliber';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Attributes", TRUE);
                CheckResetMandatoryAttributes();
            end;
        }
        field(66; "Mandatory Trademark"; Integer)
        {
            Caption = 'Mandatory Trademark';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Attributes", TRUE);
                CheckResetMandatoryAttributes();
            end;
        }
        field(69; "Mandatory Grade of Goods"; Integer)
        {
            Caption = 'Mandatory Grade of Goods';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Attributes", TRUE);
                CheckResetMandatoryAttributes();
            end;
        }
        field(72; "Mandatory Coding"; Integer)
        {
            Caption = 'Mandatory Coding';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Attributes", TRUE);
                CheckResetMandatoryAttributes();
            end;
        }
        field(80; "Mandatory Item Attribute 1"; Integer)
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Edit Item Attribute 1';
        }
        field(81; "Mandatory Item Attribute 2"; Integer)
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Edit Item Attribute 2';
        }
        field(82; "Mandatory Item Attribute 3"; Integer)
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Edit Item Attribute 3';
        }
        field(83; "Mandatory Item Attribute 4"; Integer)
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Edit Item Attribute 4';
        }
        field(84; "Mandatory Item Attribute 5"; Integer)
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Edit Item Attribute 5';
        }
        field(85; "Mandatory Item Attribute 6"; Integer)
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Edit Item Attribute 6';
        }
        field(86; "Mandatory Item Attribute 7"; Integer)
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Edit Item Attribute 7';
        }
        field(87; "Mandatory Item Attribute 8"; Integer)
        {
            CaptionClass = '5110310,1,8';
            Caption = 'Edit Item Attribute 8';
        }
        field(101; "Mandatory Dimensions"; Boolean)
        {
            Caption = 'Mandatory Attributes';

            trigger OnValidate()
            begin
                IF "Mandatory Dimensions" = FALSE THEN BEGIN
                    "Mandatory Dimension 1" := FALSE;
                    "Mandatory Dimension 2" := FALSE;
                    "Mandatory Dimension 3" := FALSE;
                    "Mandatory Dimension 4" := FALSE;
                END ELSE BEGIN
                    "Mandatory Dimension 1" := TRUE;
                    "Mandatory Dimension 2" := TRUE;
                    "Mandatory Dimension 3" := TRUE;
                    "Mandatory Dimension 4" := TRUE;
                END;
            end;
        }
        field(102; "Mandatory Dimension 1"; Boolean)
        {
            CaptionClass = '1,2,1';
            Caption = 'Mandatory Dimension 1';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Dimensions", TRUE);
                CheckResetMandatoryDimensions();
            end;
        }
        field(103; "Mandatory Dimension 2"; Boolean)
        {
            CaptionClass = '1,2,2';
            Caption = 'Mandatory Dimension 2';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Dimensions", TRUE);
                CheckResetMandatoryDimensions();
            end;
        }
        field(104; "Mandatory Dimension 3"; Boolean)
        {
            CaptionClass = '1,2,3';
            Caption = 'Mandatory Dimension 3';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Dimensions", TRUE);
                CheckResetMandatoryDimensions();
            end;
        }
        field(105; "Mandatory Dimension 4"; Boolean)
        {
            CaptionClass = '1,2,4';
            Caption = 'Mandatory Dimension 4';

            trigger OnValidate()
            begin
                TESTFIELD("Mandatory Dimensions", TRUE);
                CheckResetMandatoryDimensions();
            end;
        }
        field(120; "Mandatory Fields TransportUnit"; Boolean)
        {
            Caption = 'Mandatory Fields Transport Unit';
        }
    }

    keys
    {
        key(Key1; "Area", "Item Main Category Code", "Item Category Code", "Product Group Code", "Item No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        gco_ItemCategorieCode: Code[10];

    procedure CheckResetEditAttributes()
    begin
        /*
        IF (NOT "Edit. Variety") AND (NOT "Edit. Country of Origin") AND (NOT "Edit. Caliber") AND
           (NOT "Edit. Vendor Caliber") AND (NOT "Edit. Trademark") AND (NOT "Edit. Quality") AND
           (NOT "Edit. Color") AND (NOT "Edit. Grade of Goods") AND (NOT "Edit. Conservation") AND
           (NOT "Edit. Packing") AND (NOT "Edit. Coding") AND (NOT "Edit. Treatment")
        THEN BEGIN
          "Edit. Attributes" := FALSE;
        END;
        */

    end;

    procedure CheckResetMandatoryAttributes()
    begin
        /*
        IF (NOT "Mandatory Variety") AND (NOT "Mandatory Country of Origin") AND (NOT "Mandatory Caliber") AND
           (NOT "Mandatory Vendor Caliber") AND (NOT "Mandatory Trademark") AND (NOT "Mandatory Quality") AND
           (NOT "Mandatory Color") AND (NOT "Mandatory Grade of Goods") AND (NOT "Mandatory Conservation") AND
           (NOT "Mandatory Packing") AND (NOT "Mandatory Coding") AND (NOT "Mandatory Treatment")
        THEN BEGIN
          "Mandatory Attributes" := FALSE;
        END;
        */

    end;

    procedure CheckResetMandatoryDimensions()
    begin
        /*
        IF (NOT "Mandatory Dimension 1") AND (NOT "Mandatory Dimension 2") AND (NOT "Mandatory Dimension 3") AND
           (NOT "Mandatory Dimension 4")
        THEN BEGIN
          "Mandatory Dimensions" := FALSE;
        END;
        */

    end;

    procedure CheckSystemLinesExist()
    var
        lrc_ItemAttributesMask: Record "POI Item Attributes Mask";
    begin
        // Systemzeilen werden eingefügt, wenn noch nicht vorhanden
        IF NOT lrc_ItemAttributesMask.GET(lrc_ItemAttributesMask.Area::Item, '', '', '', '') THEN BEGIN
            CLEAR(lrc_ItemAttributesMask);
            lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Item;
            lrc_ItemAttributesMask.INSERT();
        END;

        IF NOT lrc_ItemAttributesMask.GET(lrc_ItemAttributesMask.Area::Purchase, '', '', '', '') THEN BEGIN
            CLEAR(lrc_ItemAttributesMask);
            lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Purchase;
            lrc_ItemAttributesMask.INSERT();
        END;

        IF NOT lrc_ItemAttributesMask.GET(lrc_ItemAttributesMask.Area::Sales, '', '', '', '') THEN BEGIN
            CLEAR(lrc_ItemAttributesMask);
            lrc_ItemAttributesMask.Area := lrc_ItemAttributesMask.Area::Sales;
            lrc_ItemAttributesMask.INSERT();
        END;
    end;
}

