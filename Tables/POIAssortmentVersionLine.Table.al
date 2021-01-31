table 5110340 "POI Assortment Version Line"
{

    Caption = 'Assortment Version Line';
    // DrillDownFormID = Form5088172;
    // LookupFormID = Form5088172;

    fields
    {
        field(1; "Assortment Version No."; Code[20])
        {
            Caption = 'Assortment Version No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(7; "Assortment Code"; Code[10])
        {
            Caption = 'Assortment Code';
            TableRelation = "POI Assortment";
        }
        field(8; "Starting Date Assortment"; Date)
        {
            Caption = 'Starting Date Assortment';
        }
        field(9; "Ending Date Assortment"; Date)
        {
            Caption = 'Ending Date Assortment';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item,,,,,,,Text';
            OptionMembers = Item,,,,,,,Text;
        }
        field(11; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var

                lrc_AssortmentVersion: Record "POI Assortment Version";
                lrc_AssortmentVersionLine: Record "POI Assortment Version Line";
                lrc_Item: Record Item;
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
            begin
                ItemNo_Validate();
                CheckIfModifyIsAllowed(FIELDNO("Item No."));

                IF (xRec."Item No." <> '') AND
                   (xRec."Item No." <> "Item No.") THEN BEGIN
                    // Möchten Sie den bestehenden Datensatz ändern?
                    IF NOT CONFIRM(ADF_GT_TEXT003Txt) THEN
                        ERROR('');
                END ELSE
                    // Kontrolle ob Artikel bereits im Sortiment enthalten ist
                    IF "Item No." <> '' THEN BEGIN
                        lrc_AssortmentVersionLine.RESET();
                        lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.", "Assortment Version No.");
                        lrc_AssortmentVersionLine.SETFILTER("Line No.", '<>%1', "Line No.");
                        lrc_AssortmentVersionLine.SETRANGE("Item No.", "Item No.");
                        lrc_AssortmentVersionLine.SETRANGE("Vendor No.", "Vendor No.");
                        lrc_AssortmentVersionLine.SETRANGE("Manufacturer No.", "Manufacturer No.");
                        IF NOT lrc_AssortmentVersionLine.ISEMPTY() THEN
                            IF gbn_NoGUI = FALSE THEN
                                // Artikel bereits im Sortiment. Möchten Sie den Artikel zusätzlich aufnehmen?
                                IF NOT CONFIRM(ADF_GT_TEXT004Txt) THEN
                                    ERROR('');
                    END;


                // Kontrolle ob es ein Basissortiment gibt --> Falls ja dann muss der Artikel dort enthalten sein
                IF "Item No." <> '' THEN
                    IF lrc_Assortment.GET("Assortment Code") THEN
                        IF lrc_Assortment."Assortment Source" <> lrc_Assortment."Assortment Source"::"Base Assortment" THEN BEGIN
                            lrc_Assortment.RESET();
                            lrc_Assortment.SETRANGE("Assortment Source", lrc_Assortment."Assortment Source"::"Base Assortment");
                            IF lrc_Assortment.FINDFIRST() THEN BEGIN
                                lrc_AssortmentVersionLine.RESET();
                                lrc_AssortmentVersionLine.SETRANGE("Assortment Code", lrc_Assortment.Code);
                                lrc_AssortmentVersionLine.SETFILTER("Starting Date Assortment", '<=%1', TODAY());
                                lrc_AssortmentVersionLine.SETFILTER("Ending Date Assortment", '>=%1', TODAY());
                                lrc_AssortmentVersionLine.SETRANGE("Item No.", "Item No.");
                                IF lrc_AssortmentVersionLine.ISEMPTY() THEN
                                    // Artikel nicht zulässig, da nicht im Basissortiment enthalten!
                                    ERROR(ADF_GT_TEXT002Txt);
                            END;
                        END;

                IF "Item No." <> '' THEN BEGIN
                    lrc_AssortmentVersion.GET("Assortment Version No.");
                    lrc_Item.GET("Item No.");
                    lrc_Item.TESTFIELD(Blocked, FALSE);
                    lrc_Item.TESTFIELD("Base Unit of Measure");

                    "Item No. 2" := lrc_Item."No. 2";
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Search Description" := lrc_Item."Search Description";
                    "Starting Date Assortment" := lrc_AssortmentVersion."Starting Date Assortment";
                    "Ending Date Assortment" := lrc_AssortmentVersion."Ending Date Assortment";

                    "Country of Origin Code" := lrc_Item."POI Countr of Ori Code (Fruit)";
                    "Variety Code" := lrc_Item."POI Variety Code";
                    "Trademark Code" := lrc_Item."POI Trademark Code";
                    "Caliber Code" := lrc_Item."POI Caliber Code";
                    "Vendor Caliber Code" := '';
                    "Grade of Goods Code" := lrc_Item."POI Grade of Goods Code";
                    "Coding Code" := lrc_Item."POI Coding Code";

                    "Item Attribute 1" := lrc_Item."POI Item Attribute 1";
                    "Item Attribute 2" := lrc_Item."POI Item Attribute 2";
                    "Item Attribute 3" := lrc_Item."POI Item Attribute 3";
                    "Item Attribute 4" := lrc_Item."POI Item Attribute 4";
                    "Item Attribute 5" := lrc_Item."POI Item Attribute 5";
                    "Item Attribute 6" := lrc_Item."POI Item Attribute 6";
                    "Item Attribute 7" := lrc_Item."POI Item Attribute 7";

                    "Item Main Category Code" := lrc_Item."POI Item Main Category Code";
                    VALIDATE("Item Category Code", lrc_Item."Item Category Code");
                    "Product Group Code" := lrc_Item."POI Product Group Code";

                    VALIDATE("Empties Item No.", lrc_Item."POI Empties Item No.");

                    "Currency Code" := lrc_AssortmentVersion."Currency Code";

                    "Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
                    "Unit of Measure Code" := lrc_Item."Purch. Unit of Measure";
                    "Sales Unit of Measure Code" := lrc_Item."Sales Unit of Measure";

                    IF "Unit of Measure Code" <> '' THEN BEGIN
                        lrc_ItemUnitofMeasure.GET("Item No.", "Unit of Measure Code");
                        "Qty. per Unit of Measure" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
                    END;

                    VALIDATE("Unit of Measure Code", lrc_Item."Sales Unit of Measure");
                    VALIDATE("Price Base (Purch. Price)", lrc_Item."POI Price Base (Purch. Price)");
                    VALIDATE("Price Base (Sales Price)", lrc_Item."POI Price Base (Sales Price)");

                END ELSE BEGIN

                    "Item No. 2" := '';
                    "Item Description" := '';
                    "Item Description 2" := '';
                    "Search Description" := '';
                    "Starting Date Assortment" := 0D;
                    "Ending Date Assortment" := 0D;

                    "Country of Origin Code" := '';
                    "Variety Code" := '';
                    "Trademark Code" := '';
                    "Caliber Code" := '';
                    "Vendor Caliber Code" := '';
                    "Coding Code" := '';
                    "Grade of Goods Code" := '';

                    "Item Attribute 1" := '';
                    "Item Attribute 2" := '';
                    "Item Attribute 3" := '';
                    "Item Attribute 4" := '';
                    "Item Attribute 5" := '';
                    "Item Attribute 6" := '';
                    "Item Attribute 7" := '';

                    "Item Main Category Code" := '';
                    "Item Category Code" := '';
                    "Product Group Code" := '';

                    "Empties Item No." := '';
                    "Empties Item Description" := '';

                    "Currency Code" := '';

                    "Qty. per Unit of Measure" := 1;
                    "Base Unit of Measure (BU)" := '';
                    "Unit of Measure Code" := '';
                    "Sales Unit of Measure Code" := '';
                    "Packing Unit of Measure (PU)" := '';
                    "Content Unit of Measure (CP)" := '';

                    "Qty. per Unit of Measure" := 0;
                    "Qty. per Price Unit" := 0;

                    VALIDATE("Unit of Measure Code", '');
                    "Price Base (Sales Price)" := '';
                    VALIDATE("Price Base (Purch. Price)", '');

                END;
            end;
        }
        field(12; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(13; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF ("Item No." = FILTER(<> '')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."))
            ELSE
            "POI Batch Variant";

            trigger OnValidate()
            var
                lrc_BatchVariant: Record "POI Batch Variant";
                lrc_UnitofMeasure: Record "Unit of Measure";
            begin
                IF "Batch Variant No." = '' THEN BEGIN
                    VALIDATE("Item No.");
                    EXIT;
                END;

                IF "Batch Variant No." = xRec."Batch Variant No." THEN
                    EXIT;

                IF (xRec."Batch Variant No." <> '') AND
                   ("Batch Variant No." <> xRec."Batch Variant No.") THEN
                    ERROR('Eingabe nicht zulässig!');

                lrc_BatchVariant.GET("Batch Variant No.");
                IF CurrFieldNo = FIELDNO("Batch Variant No.") THEN
                    IF (lrc_BatchVariant.Source <> lrc_BatchVariant.Source::"Purch. Order") AND
                       (lrc_BatchVariant.Source <> lrc_BatchVariant.Source::"Packing Order") THEN
                        ERROR('Herkunft muss Einkauf oder Packerei sein!');

                VALIDATE("Item No.", lrc_BatchVariant."Item No.");
                "Variant Code" := lrc_BatchVariant."Variant Code";

                "Batch No." := lrc_BatchVariant."Batch No.";
                "Master Batch No." := lrc_BatchVariant."Master Batch No.";

                "Item Description" := lrc_BatchVariant.Description;
                "Item Description 2" := lrc_BatchVariant."Description 2";
                "Search Description" := lrc_BatchVariant."Search Description";

                "Item Main Category Code" := lrc_BatchVariant."Item Main Category Code";
                "Item Category Code" := lrc_BatchVariant."Item Category Code";
                "Product Group Code" := lrc_BatchVariant."Product Group Code";

                "Vendor No." := lrc_BatchVariant."Vendor No.";
                "Vendor Order Address Code" := '';
                "Manufacturer No." := lrc_BatchVariant."Producer No.";
                "Shipment Method Code" := lrc_BatchVariant."Shipment Method Code";

                "Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
                "Variety Code" := lrc_BatchVariant."Variety Code";
                "Trademark Code" := lrc_BatchVariant."Trademark Code";
                "Caliber Code" := lrc_BatchVariant."Caliber Code";
                "Vendor Caliber Code" := lrc_BatchVariant."Vendor Caliber Code";
                "Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
                "Coding Code" := lrc_BatchVariant."Coding Code";
                "Cultivation Type" := lrc_BatchVariant."Cultivation Type";
                "Cultivation Association Code" := lrc_BatchVariant."Cultivation Association Code";

                "Item Attribute 1" := lrc_BatchVariant."Item Attribute 1";
                "Item Attribute 2" := lrc_BatchVariant."Item Attribute 2";
                "Item Attribute 3" := lrc_BatchVariant."Item Attribute 3";
                "Item Attribute 4" := lrc_BatchVariant."Item Attribute 4";
                "Item Attribute 5" := lrc_BatchVariant."Item Attribute 5";
                "Item Attribute 6" := lrc_BatchVariant."Item Attribute 6";
                "Item Attribute 7" := lrc_BatchVariant."Item Attribute 7";

                "Info 1" := lrc_BatchVariant."Info 1";
                "Info 2" := lrc_BatchVariant."Info 2";
                "Info 3" := lrc_BatchVariant."Info 3";
                "Info 4" := lrc_BatchVariant."Info 4";

                "Unit of Measure Code" := lrc_BatchVariant."Unit of Measure Code";
                "Base Unit of Measure (BU)" := lrc_BatchVariant."Base Unit of Measure (BU)";
                "Qty. per Unit of Measure" := lrc_BatchVariant."Qty. per Unit of Measure";

                "Packing Unit of Measure (PU)" := lrc_BatchVariant."Packing Unit of Measure (PU)";
                "Qty. PU per CU" := lrc_BatchVariant."Qty. (PU) per Collo (CU)";
                "Qty. Packing Units" := 0;

                "Transport Unit of Measure (TU)" := lrc_BatchVariant."Transport Unit of Measure (TU)";
                "Qty. Unit per TU" := lrc_BatchVariant."Qty. (Unit) per Transp. (TU)";
                "Qty. Transport Units" := 0;
                "No. of Layers on TU" := lrc_BatchVariant."No. of Layers on TU";
                IF lrc_UnitofMeasure.GET(lrc_BatchVariant."Transport Unit of Measure (TU)") THEN
                    "Freight Unit of Measure" := lrc_UnitofMeasure."POI Freight Unit of Meas (FU)";

                "Content Unit of Measure (CP)" := lrc_BatchVariant."Content Unit of Measure (CP)";
                "Qty. Base Unit per Cont. Unit" := 0;

                Weight := lrc_BatchVariant.Weight;
                "Gross Weight" := lrc_BatchVariant."Gross Weight";
                "Net Weight" := lrc_BatchVariant."Net Weight";

                "Sales Unit of Measure Code" := "Unit of Measure Code";
                VALIDATE("Price Base (Purch. Price)", lrc_BatchVariant."Price Base (Purch. Price)");
                VALIDATE("Purch. Price (Price Base)", lrc_BatchVariant."Purch. Price (Price Base)");

                "Entry Location Code" := lrc_BatchVariant."Entry Location Code";
                "Entry via Transfer Loc. Code" := lrc_BatchVariant."Entry via Transfer Loc. Code";

                VALIDATE("Price Base (Sales Price)", lrc_BatchVariant."Price Base (Sales Price)");
                "Sales Price (Price Base)" := lrc_BatchVariant."Sales Price (Price Base)";

                "Expected Receipt Date" := lrc_BatchVariant."Date of Delivery";
                "Empties Item No." := lrc_BatchVariant."Empties Item No.";
                "Ship-Agent Code to Transf. Loc" := '';
                "Shipping Agent Code" := lrc_BatchVariant."Shipping Agent Code";

                "Freight Cost per Unit (LCY)" := 0;
                "Freight Cost Amount (LCY)" := 0;
                "Cost Calc. per Unit (LCY)" := 0;
                "Cost Calc. Amount (LCY)" := 0;
                "Indirect Cost Amt (Unit) (LCY)" := lrc_BatchVariant."Indirect Cost Amount";
                "Unit Cost (LCY)" := lrc_BatchVariant."Unit Cost (UOM) (LCY)";
            end;
        }
        field(14; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(15; "Item Description 2"; Text[100])
        {
            Caption = 'Item Description 2';
        }
        field(16; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
            Editable = false;
        }
        field(17; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(18; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(19; "Item No. 2"; Code[20])
        {
            Caption = 'Item No. 2';
        }
        field(20; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                CheckIfModifyIsAllowed(FIELDNO("Country of Origin Code"));
            end;
        }
        field(21; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety";

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                CheckIfModifyIsAllowed(FIELDNO("Variety Code"));
                lrc_Item.GET("Item No.");
                IF lrc_Item."POI Variety Code" <> '' THEN
                    IF lrc_Item."POI Variety Code" <> "Variety Code" THEN
                        "Variety Code" := lrc_Item."POI Variety Code";
            end;
        }
        field(22; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";

            trigger OnValidate()
            begin
                CheckIfModifyIsAllowed(FIELDNO("Trademark Code"));
            end;
        }
        field(23; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber";
            ValidateTableRelation = false;

            trigger OnValidate()
            var


                lrc_AssortVersionLineDetail: Record "POI Assort Version Line Detail";
                lcu_BaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
            begin
                lcu_BaseDataMgt.CaliberValidateSearch("Caliber Code", "Product Group Code",
                                                     (CurrFieldNo = FIELDNO("Caliber Code")));
                CheckIfModifyIsAllowed(FIELDNO("Caliber Code"));

                lrc_AssortVersionLineDetail.SETRANGE("Assortment Version No.", "Assortment Version No.");
                lrc_AssortVersionLineDetail.SETRANGE("Assortment Version Line No.", "Line No.");
                lrc_AssortVersionLineDetail.SETRANGE(Type, lrc_AssortVersionLineDetail.Type::Caliber);
                IF NOT lrc_AssortVersionLineDetail.ISEMPTY() THEN
                    lrc_AssortVersionLineDetail.DELETEALL();

                IF "Caliber Code" <> '' THEN BEGIN
                    lrc_CaliberDetail.SETRANGE("Caliber Code", "Caliber Code");
                    IF lrc_CaliberDetail.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            lrc_AssortVersionLineDetail.RESET();
                            lrc_AssortVersionLineDetail.INIT();
                            lrc_AssortVersionLineDetail."Assortment Version No." := "Assortment Version No.";
                            lrc_AssortVersionLineDetail."Assortment Version Line No." := "Line No.";
                            lrc_AssortVersionLineDetail.Type := lrc_AssortVersionLineDetail.Type::Caliber;
                            lrc_AssortVersionLineDetail."No." := lrc_CaliberDetail."Caliber Code Detail";
                            lrc_AssortVersionLineDetail."Assortment Code" := "Assortment Code";
                            lrc_AssortVersionLineDetail.INSERT();
                        UNTIL lrc_CaliberDetail.NEXT() = 0;
                END;
            end;
        }
        field(24; "Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            TableRelation = "POI Caliber - Vendor Caliber"."Vendor No." WHERE("Caliber Code" = FIELD("Caliber Code"));
            ValidateTableRelation = false;
        }
        field(25; "Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3";

            trigger OnValidate()
            begin
                CheckIfModifyIsAllowed(FIELDNO("Item Attribute 3"));
            end;
        }
        field(26; "Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(27; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods";
        }
        field(28; "Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(29; "Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(30; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";
        }
        field(31; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            Editable = false;
            TableRelation = "POI Product Group".Code;
        }
        field(33; "Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(34; "Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            TableRelation = "POI Proper Name";
        }
        field(35; "Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            begin
                CheckIfModifyIsAllowed(FIELDNO("Base Unit of Measure (BU)"));
            end;
        }
        field(36; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            Editable = false;

            trigger OnValidate()
            begin
                CheckIfModifyIsAllowed(FIELDNO("Qty. per Unit of Measure"));
            end;
        }
        field(40; "Sales Unit of Measure Code"; Code[10])
        {
            Caption = 'Sales Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(41; "Vendor Order Address Code"; Code[10])
        {
            Caption = 'Vendor Order Address Code';
        }
        field(42; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No." WHERE(Blocked = FILTER(' '));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
                lcu_BaseData: Codeunit "POI Base Data Mgt";
                AGILES_TEXT002Txt: Label 'Vendor %1 don''t exist !', Comment = '%1';
            begin
                IF NOT lcu_BaseData.VendorValidate("Vendor No.") THEN
                    ERROR(AGILES_TEXT002Txt, "Vendor No.");

                IF "Vendor No." <> '' THEN BEGIN
                    IF "Vendor No." <> xRec."Vendor No." THEN BEGIN
                        lrc_Vendor.GET("Vendor No.");
                        "Vendor Name" := lrc_Vendor.Name;
                        "Territory Code" := lrc_Vendor."Territory Code";
                        "Manufacturer No." := '';
                        "Cultivation Type" := lrc_Vendor."POI Cultivation Type";
                        "Cultivation Association Code" := lrc_Vendor."POI Cultivation Associat. Code";
                        "Country of Origin Code" := lrc_Vendor."POI Country of Origin Code";
                        "Entry via Transfer Loc. Code" := lrc_Vendor."POI Entry via Transf Loc. Code";
                        "Entry Location Code" := lrc_Vendor."Location Code";
                        "Shipment Method Code" := lrc_Vendor."Shipment Method Code";
                        "Ship-Agent Code to Transf. Loc" := lrc_Vendor."POI Sh-Ag Code to Transf. Loc";
                        "Shipping Agent Code" := lrc_Vendor."Shipping Agent Code";
                    END;
                END ELSE BEGIN
                    "Vendor Name" := '';
                    "Territory Code" := '';
                    "Manufacturer No." := '';
                    "Cultivation Type" := "Cultivation Type"::" ";
                    "Cultivation Association Code" := '';
                    "Country of Origin Code" := '';
                    IF xRec."Vendor No." <> '' THEN BEGIN
                        "Entry via Transfer Loc. Code" := '';
                        "Entry Location Code" := '';
                        "Shipment Method Code" := '';
                        "Ship-Agent Code to Transf. Loc" := '';
                        "Shipping Agent Code" := '';
                    END;
                END;
            end;
        }
        field(43; "Manufacturer No."; Code[20])
        {
            Caption = 'Manufacturer No.';
            TableRelation = Manufacturer;
        }
        field(44; "Planing Quantity"; Decimal)
        {
            Caption = 'Planing Quantity';
        }
        field(45; "Planing Date"; Date)
        {
            Caption = 'Planing Date';
        }
        field(46; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(47; "Item Main Category Code"; Code[10])
        {
            Caption = 'Item Main Category Code';
            TableRelation = "POI Item Main Category";
        }
        field(48; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";

            trigger OnValidate()
            var
                lrc_ItemCategory: Record "Item Category";
            begin
                IF lrc_ItemCategory.GET("Item Category Code") THEN
                    "Item Category Sorting" := lrc_ItemCategory."POI Sorting in Price List";
            end;
        }
        field(50; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(51; "Cultivation Association Code"; Code[10])
        {
            Caption = 'Cultivation Association Code';
            Description = 'EIA';
            TableRelation = "POI Cultivation Association";
        }
        field(52; "Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(55; "Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
                                                     Blocked = CONST(false));

            trigger OnValidate()
            begin
                CheckIfModifyIsAllowed(FIELDNO("Price Base (Purch. Price)"));
                VALIDATE("Purch. Price (Price Base)");
            end;
        }
        field(56; "Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'Purch. Price (Price Base)';

            trigger OnValidate()
            var
                lrc_PriceBase: Record "POI Price Base";
            begin
                CheckIfModifyIsAllowed(FIELDNO("Purch. Price (Price Base)"));

                // Einkaufspreis pro Kollo berechnen
                "Direct Unit Cost (LCY)" := 0;
                IF lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Purch. Price", "Price Base (Purch. Price)") THEN
                    CASE lrc_PriceBase."Internal Calc. Type" OF
                        lrc_PriceBase."Internal Calc. Type"::"Base Unit":
                            "Direct Unit Cost (LCY)" := ("Purch. Price (Price Base)" * "Qty. per Unit of Measure");
                        lrc_PriceBase."Internal Calc. Type"::"Content Unit":
                            ERROR('Nicht codiert');
                        lrc_PriceBase."Internal Calc. Type"::"Packing Unit":
                            "Direct Unit Cost (LCY)" := ("Purch. Price (Price Base)" * "Qty. PU per CU");
                        lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
                            "Direct Unit Cost (LCY)" := "Purch. Price (Price Base)";
                        lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
                            "Direct Unit Cost (LCY)" := "Purch. Price (Price Base)" * "Gross Weight";
                        lrc_PriceBase."Internal Calc. Type"::"Net Weight":
                            "Direct Unit Cost (LCY)" := "Purch. Price (Price Base)" * "Net Weight";
                        ELSE
                            ERROR('Nicht codiert');
                    END ELSE
                    "Direct Unit Cost (LCY)" := "Purch. Price (Price Base)";
            end;
        }
        field(57; "Entry Location Code"; Code[10])
        {
            Caption = 'Entry Location Code';
            TableRelation = Location;
        }
        field(58; "Entry via Transfer Loc. Code"; Code[10])
        {
            Caption = 'Entry via Transfer Loc. Code';
            TableRelation = Location;
        }
        field(59; "Territory Code"; Code[10])
        {
            Caption = 'Gebietscode';
            TableRelation = Territory;
        }
        field(60; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
            DecimalPlaces = 0 : 5;
        }
        field(61; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
        }
        field(62; Weight; Option)
        {
            Caption = 'Weight';
            OptionCaption = ' ,Net Weight,Gross Weight';
            OptionMembers = " ","Net Weight","Gross Weight";
        }
        field(65; "Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchMgt: Codeunit "POI BAM Batch Management";
            //lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF (Type = Type::Item) AND
                   ("Batch No." <> '') THEN
                    lcu_BatchMgt.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 0, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 1");
            end;
        }
        field(66; "Info 2"; Code[50])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchMgt: Codeunit "POI BAM Batch Management";
            //lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF (Type = Type::Item) AND
                   ("Batch No." <> '') THEN
                    lcu_BatchMgt.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 1, lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 2");
            end;
        }
        field(67; "Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchMgt: Codeunit "POI BAM Batch Management";
            //lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF (Type = Type::Item) AND
                   ("Batch No." <> '') THEn
                    lcu_BatchMgt.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 2,
                                                    lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 3");
            end;
        }
        field(68; "Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchMgt: Codeunit "POI BAM Batch Management";
            //lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF (Type = Type::Item) AND
                   ("Batch No." <> '') THEn
                    lcu_BatchMgt.UpdBatchSourceInfo("Batch No.", "Batch Variant No.", 3,
                                                    lrc_BatchInfoDetails."Comment Type"::"Sales Information", "Info 4");

            end;
        }
        field(70; "Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(false));

            trigger OnValidate()
            var
                lrc_PriceBase: Record "POI Price Base";
                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
                //lrc_SalesPrice: Record "Sales Price";
                lco_PriceGroupFilter: Code[100];
                TEXT001Txt: Label 'Berechnungsart konnte keiner Einheit zugeordnet werden!';
            begin
                CheckIfModifyIsAllowed(FIELDNO("Price Base (Sales Price)"));

                IF "Price Base (Sales Price)" = '' THEN BEGIN
                    "Sales Price Unit of Measure" := "Sales Unit of Measure Code";
                    EXIT;
                END;

                // Artikelnummer muss eingegeben sein
                TESTFIELD("Item No.");

                // Preisberechnungsart lesen
                lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Sales Price", "Price Base (Sales Price)");
                lrc_PriceBase.TESTFIELD(Blocked, FALSE);

                // Einheitensatz lesen
                TESTFIELD("Sales Unit of Measure Code");
                lrc_UnitofMeasure.GET("Sales Unit of Measure Code");

                // Kontrolle ob es bereits Preise auf der vorhergehenden Einheit gibt
                IF CurrFieldNo = FIELDNO("Price Base (Sales Price)") THEN
                    IF "Price Base (Sales Price)" <> xRec."Price Base (Sales Price)" THEN BEGIN

                        // Alle zugeordneten Preise lesen
                        lrc_AssortCustPriceGroup.SETRANGE("Assortment Code", "Assortment Code");
                        IF lrc_AssortCustPriceGroup.FIND('-') THEN
                            REPEAT
                                IF lco_PriceGroupFilter = '' THEN
                                    lco_PriceGroupFilter := lrc_AssortCustPriceGroup."Customer Price Group Code"
                                ELSE
                                    lco_PriceGroupFilter := copystr(lco_PriceGroupFilter + '|' + lrc_AssortCustPriceGroup."Customer Price Group Code", 1, 100);
                            UNTIL lrc_AssortCustPriceGroup.NEXT() = 0;

                        // IF lco_PriceGroupFilter <> '' THEN BEGIN //TODO: was soll das?
                        //     lrc_SalesPrice.RESET();
                        //     lrc_SalesPrice.SETRANGE("Item No.", "Item No.");
                        //     lrc_SalesPrice.SETRANGE("Sales Type", lrc_SalesPrice."Sales Type"::"Customer Price Group");
                        //     lrc_SalesPrice.SETFILTER("Sales Code", lco_PriceGroupFilter);
                        //     lrc_SalesPrice.SETFILTER("Starting Date", '>=%1', "Starting Date Assortment");
                        //     IF "Ending Date Assortment" <> 0D THEN
                        //         lrc_SalesPrice.SETFILTER("Ending Date", '<=%1', "Ending Date Assortment");
                        //     lrc_SalesPrice.SETRANGE("Currency Code", "Currency Code");
                        //     lrc_SalesPrice.SETRANGE("Unit of Measure Code", xRec."Sales Price Unit of Measure");
                        //     IF lrc_SalesPrice.FIND('-') THEN;
                        // END;
                    END;




                IF "Price Base (Sales Price)" = '' THEN BEGIN
                    "Sales Price Unit of Measure" := '';
                    Weight := Weight::" ";
                    "Qty. per Price Unit" := 0;
                    EXIT;
                END;

                // ------------------------------------------------------------------------------------
                // Preiseinheit für Preisliste ermitteln
                // ------------------------------------------------------------------------------------
                lrc_UnitofMeasure.GET("Sales Unit of Measure Code");

                CASE lrc_PriceBase."Internal Calc. Type" OF
                    lrc_PriceBase."Internal Calc. Type"::"Base Unit":
                        BEGIN
                            TESTFIELD("Base Unit of Measure (BU)");
                            "Sales Price Unit of Measure" := "Base Unit of Measure (BU)";
                        END;
                    lrc_PriceBase."Internal Calc. Type"::"Content Unit":
                        BEGIN
                            lrc_UnitofMeasure.TESTFIELD("POI Content Unit of Meas (CP)");
                            "Sales Price Unit of Measure" := lrc_UnitofMeasure."POI Content Unit of Meas (CP)";
                        END;
                    lrc_PriceBase."Internal Calc. Type"::"Packing Unit":
                        BEGIN
                            lrc_UnitofMeasure.TESTFIELD("POI Packing Unit of Meas (PU)");
                            "Sales Price Unit of Measure" := lrc_UnitofMeasure."POI Packing Unit of Meas (PU)";
                        END;
                    lrc_PriceBase."Internal Calc. Type"::"Collo Unit":
                        "Sales Price Unit of Measure" := lrc_UnitofMeasure.Code;
                    lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
                        BEGIN
                            lrc_PriceBase.TESTFIELD("Price Unit Weighting");
                            "Sales Price Unit of Measure" := lrc_PriceBase."Price Unit Weighting";
                            Weight := lrc_PriceBase.Weight;
                            "Qty. per Price Unit" := 1;
                        END;
                    lrc_PriceBase."Internal Calc. Type"::"Net Weight":
                        BEGIN
                            lrc_PriceBase.TESTFIELD("Price Unit Weighting");
                            "Sales Price Unit of Measure" := lrc_PriceBase."Price Unit Weighting";
                            Weight := lrc_PriceBase.Weight;
                            "Qty. per Price Unit" := 1;
                        END;
                    ELSE
                        // Berechnungsart konnte keiner Einheit zugeordnet werden!
                        ERROR(TEXT001Txt);
                END;

                // Menge Basis pro Preiseinheit lesen
                IF lrc_ItemUnitofMeasure.GET("Item No.", "Sales Price Unit of Measure") THEN
                    "Qty. per Price Unit" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
            end;
        }
        field(72; "Sales Price (Price Base)"; Decimal)
        {
            Caption = 'Sales Price (Price Base)';
        }
        field(73; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(74; "Qty. per Price Unit"; Decimal)
        {
            Caption = 'Qty. per Price Unit';
        }
        field(75; "Sales Price Unit of Measure"; Code[10])
        {
            Caption = 'Sales Price Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(76; "Starting Date Price"; Date)
        {
            Caption = 'Starting Date Price';
        }
        field(77; "Ending Date Price"; Date)
        {
            Caption = 'Ending Date Price';
        }
        field(78; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(79; "Calculate Price Qty Transport"; Boolean)
        {
            Caption = 'Calculate Price Qty Transport';
        }
        field(80; "New Item in Assortment"; Boolean)
        {
            Caption = 'New Item in Assortment';
        }
        field(81; "Modified Sales Price"; Option)
        {
            Caption = 'Modified Sales Price';
            OptionCaption = ' ,Raised,Lowered';
            OptionMembers = " ",Raised,Lowered;
        }
        field(82; "Teilselektion 1"; Boolean)
        {
            CaptionClass = '3302,1,1';
            Caption = 'Teilselektion 1';
        }
        field(83; "Teilselektion 2"; Code[10])
        {
            CaptionClass = '3302,1,2';
            Caption = 'Teilselektion 2';
        }
        field(85; "Blocked for Assortment List"; Boolean)
        {
            Caption = 'Blocked for Assortment List';
        }
        field(86; "Blocked for Sale"; Boolean)
        {
            Caption = 'Blocked for Sale';

            trigger OnValidate()
            var
                AGILES_TEXT001Txt: Label 'Möchten Sie die Einstellung in die Aufträge übertragen?';
            begin
                // Möchten Sie die Einstellung in die Aufträge übertragen?
                IF CONFIRM(AGILES_TEXT001Txt) THEN BEGIN
                    lrc_SalesLine.RESET();
                    lrc_SalesLine.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Shipment Date");
                    lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
                    lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
                    lrc_SalesLine.SETRANGE("No.", "Item No.");
                    IF lrc_SalesLine.FINDSET(TRUE, FALSE) THEN
                        REPEAT
                            IF ("Blocked for Sale" = FALSE) OR
                               (("Blocked for Sale" = TRUE) AND
                                (lrc_SalesLine.Quantity = 0)) THEN BEGIN
                                lrc_SalesLine."POI Blocked for Sale" := "Blocked for Sale";
                                lrc_SalesLine.MODIFY();
                            END;
                        UNTIL lrc_SalesLine.NEXT() = 0;
                END;
            end;
        }
        field(87; "Blocked for Webshop"; Boolean)
        {
            Caption = 'Blocked for Webshop';
        }
        field(89; "Price Type"; Option)
        {
            Caption = 'Price Type';
            OptionCaption = ' ,Einführungspreis,Herstelleraktionspreis,Messepreis,Echt BIO Aktion,Power Flyer,Dauertiefpreis,Abverkauf';
            OptionMembers = " ","Einführungspreis",Herstelleraktionspreis,Messepreis,"Echt BIO Aktion","Power Flyer",Dauertiefpreis,Abverkauf;
        }
        field(90; "External Comment 1"; Text[80])
        {
            Caption = 'External Comment 1';
        }
        field(91; "Internal Comment"; Text[80])
        {
            Caption = 'Internal Comment';
        }
        field(92; "Language External Comment 1"; Code[10])
        {
            Caption = 'Language External Comment 1';
            TableRelation = Language;
        }
        field(93; "External Standard Text Code"; Code[10])
        {
            Caption = 'External Standard Text Code';
            TableRelation = "Standard Text".Code;
        }
        field(94; "External Comment 2"; Text[80])
        {
            Caption = 'External Comment 2';
        }
        field(95; "Language External Comment 2"; Code[10])
        {
            Caption = 'Language External Comment 2';
            TableRelation = Language;
        }
        field(96; "External Comment 3"; Text[80])
        {
            Caption = 'External Comment 3';
        }
        field(97; "Language External Comment 3"; Code[10])
        {
            Caption = 'Language External Comment 3';
            TableRelation = Language;
        }
        field(98; "External Comment 4"; Text[80])
        {
            Caption = 'External Comment 4';
        }
        field(99; "Language External Comment 4"; Code[10])
        {
            Caption = 'Language External Comment 4';
            TableRelation = Language;
        }
        field(100; "Sort Sequence"; Integer)
        {
            Caption = 'Sort Sequence';
        }
        field(101; "Automatic Allocation"; Boolean)
        {
            Caption = 'Automatic Allocation';
        }
        field(102; Shortcut; Code[20])
        {
            Caption = 'Shortcut';
        }
        field(103; "Print Bold"; Boolean)
        {
            Caption = 'Print Bold';
        }
        field(105; "Item Category Sorting"; Integer)
        {
            Caption = 'Item Category Sorting';
        }
        field(110; "Fair Trade"; Boolean)
        {
            Caption = 'Fair Trade';
        }
        field(111; "Free of CO2"; Boolean)
        {
            Caption = 'Free of CO2';
        }
        field(112; "Air-Shipped"; Boolean)
        {
            Caption = 'Air-Shipped';
        }
        field(113; "Authentic Seeds Variety"; Boolean)
        {
            Caption = 'Authentic Seeds Variety';
        }
        field(120; "Variety Description"; Text[30])
        {
            Caption = 'Variety Description';
        }
        field(121; "Caliber Description"; Text[30])
        {
            Caption = 'Caliber Description';
        }
        field(130; "Vendor Item No."; Code[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(200; Inactive; Boolean)
        {
            Caption = 'Inactive';
        }
        field(201; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(202; "Ref. Date Validation"; Option)
        {
            Caption = 'Ref. Date Validation';
            OptionCaption = 'Order Date,Shipment Date,Requested Delivery Date,Promised Delivery Date';
            OptionMembers = "Order Date","Shipment Date","Requested Delivery Date","Promised Delivery Date";
        }
        field(330; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Collo Unit of Measure" = CONST(true));
            ValidateTableRelation = false;

            trigger OnValidate()
            var

                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
                lrc_Item: Record Item;
                lcu_BaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
            begin
                lcu_BaseDataMgt.UOMValidateSearch("Unit of Measure Code",
                                                  "Item No.",
                                                  (CurrFieldNo = FIELDNO("Unit of Measure Code")),
                                                  TRUE);

                CheckIfModifyIsAllowed(FIELDNO("Unit of Measure Code"));

                lrc_Item.GET("Item No.");
                IF "Unit of Measure Code" <> '' THEN BEGIN

                    // Artikeleinheitentabelle suchen
                    IF lrc_ItemUnitofMeasure.GET("Item No.", "Unit of Measure Code") THEN BEGIN

                        "Base Unit of Measure (BU)" := lrc_Item."Base Unit of Measure";
                        "Qty. per Unit of Measure" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
                        "Packing Unit of Measure (PU)" := '';
                        "Qty. PU per CU" := 0;
                        "Content Unit of Measure (CP)" := '';
                        "Transport Unit of Measure (TU)" := '';
                        "Sales Unit of Measure Code" := "Unit of Measure Code";
                        "Gross Weight" := lrc_ItemUnitofMeasure."POI Gross Weight";
                        "Net Weight" := lrc_ItemUnitofMeasure."POI Net Weight";

                    END ELSE BEGIN
                        lrc_UnitofMeasure.GET("Unit of Measure Code");
                        "Base Unit of Measure (BU)" := lrc_UnitofMeasure."POI Base Unit of Measure (BU)";
                        "Qty. per Unit of Measure" := lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas";
                        "Packing Unit of Measure (PU)" := lrc_UnitofMeasure."POI Packing Unit of Meas (PU)";
                        "Qty. PU per CU" := lrc_UnitofMeasure."POI Qty. (PU) per Unit of Meas";
                        "Content Unit of Measure (CP)" := lrc_UnitofMeasure."POI Content Unit of Meas (CP)";
                        "Transport Unit of Measure (TU)" := lrc_UnitofMeasure."POI Transp. Unit of Meas (TU)";
                        "Sales Unit of Measure Code" := "Unit of Measure Code";

                        "Gross Weight" := lrc_UnitofMeasure."POI Gross Weight";
                        "Net Weight" := lrc_UnitofMeasure."POI Net Weight";
                    END;

                END ELSE BEGIN
                    "Qty. per Unit of Measure" := 1;
                    "Base Unit of Measure (BU)" := '';
                    "Packing Unit of Measure (PU)" := '';
                    "Content Unit of Measure (CP)" := '';
                    "Transport Unit of Measure (TU)" := '';
                    "Sales Unit of Measure Code" := '';
                    "Gross Weight" := 0;
                    "Net Weight" := 0;
                END;

                VALIDATE(Quantity);
                VALIDATE("Price Base (Sales Price)");
            end;
        }
        field(332; Quantity; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                VALIDATE("Quantity (Base)");
                IF CurrFieldNo <> FIELDNO("Qty. Packing Units") THEN BEGIN
                    VALIDATE("Qty. Packing Units");
                    VALIDATE("Qty. PU per CU");
                END;
                IF CurrFieldNo <> FIELDNO("Qty. Transport Units") THEN
                    VALIDATE("Qty. Transport Units");
            end;
        }
        field(344; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';

            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(350; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Packing Unit of Measure" = CONST(true));
        }
        field(351; "Qty. PU per CU"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. PU per CU';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                IF "Qty. PU per CU" <> 0 THEN
                    VALIDATE("Qty. Packing Units", (Quantity * "Qty. PU per CU"))
                ELSE
                    VALIDATE("Qty. Packing Units", 0);
            end;
        }
        field(352; "Qty. Packing Units"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. Packing Units';
            DecimalPlaces = 0 : 5;
        }
        field(353; "Freight Unit of Measure"; Code[10])
        {
            Caption = 'Frachteinheitencode';
            TableRelation = "Unit of Measure";
        }
        field(354; "No. of Layers on TU"; Decimal)
        {
            Caption = 'No. of Layers on TU';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(355; "Transport Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_ItemTransportUnitFactor: Record "POI Factor Transport Unit";
                lcu_UnitMgt: Codeunit "POI Unit Mgt";
                ldc_PalletFaktor: Decimal;
            begin
                CheckIfModifyIsAllowed(FIELDNO("Transport Unit of Measure (TU)"));

                IF ("Transport Unit of Measure (TU)" <> '') AND
                   ("Transport Unit of Measure (TU)" <> xRec."Transport Unit of Measure (TU)") AND
                   (CurrFieldNo <> 0) THEN BEGIN
                    lcu_UnitMgt.GetItemVendorUnitPalletFactor("Item No.",
                                                              lrc_ItemTransportUnitFactor."Reference Typ"::Vendor,
                                                              "Vendor No.",
                                                              "Unit of Measure Code",
                                                              "Qty. per Unit of Measure",
                                                              "Empties Item No.",
                                                              "Transport Unit of Measure (TU)",
                                                              ldc_PalletFaktor);
                    IF ldc_PalletFaktor <> 0 THEN
                        VALIDATE("Qty. Unit per TU", ldc_PalletFaktor);
                END;

                // Frachteinheit lesen
                IF lrc_UnitofMeasure.GET("Transport Unit of Measure (TU)") THEN
                    "Freight Unit of Measure" := lrc_UnitofMeasure."POI Freight Unit of Meas (FU)";
            end;
        }
        field(356; "Qty. Unit per TU"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. Unit per TU';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                CheckIfModifyIsAllowed(FIELDNO("Qty. Unit per TU"));

                IF CurrFieldNo = FIELDNO("Qty. Unit per TU") THEn
                    IF "Qty. Unit per TU" <> 0 THEN
                        VALIDATE("Qty. Transport Units", (Quantity / "Qty. Unit per TU"))
                    ELSE
                        VALIDATE("Qty. Transport Units", 0);

            end;
        }
        field(357; "Qty. Transport Units"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. Transport Units';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Qty. Transport Units") THEN
                    VALIDATE(Quantity, ("Qty. Transport Units" * "Qty. Unit per TU"))
                ELSE
                    IF "Qty. Unit per TU" <> 0 THEN
                        "Qty. Transport Units" := Quantity / "Qty. Unit per TU"
                    ELSE
                        "Qty. Transport Units" := 0;
            end;
        }
        field(358; "Content Unit of Measure (CP)"; Code[10])
        {
            Caption = 'Content Unit of Measure (CP)';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(359; "Qty. Base Unit per Cont. Unit"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. Base Unit per Cont. Unit';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("Qty. Unit per TU") THEN
                    IF "Qty. Unit per TU" <> 0 THEN
                        VALIDATE("Qty. Transport Units", (Quantity / "Qty. Unit per TU"))
                    ELSE
                        VALIDATE("Qty. Transport Units", 0);
            end;
        }
        field(360; "Empties Item No."; Code[20])
        {
            Caption = 'Empty Item No.';
            TableRelation = Item WHERE("POI Item Typ" = CONST("Empties Item"));

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF lrc_Item.GET("Empties Item No.") THEN
                    "Empties Item Description" := COPYSTR(lrc_Item.Description + ' ' + lrc_Item."Description 2", 1, 60)
                ELSE
                    "Empties Item Description" := '';
            end;
        }
        field(361; "Empties Item Description"; Text[60])
        {
            Caption = 'Leergut Artikelbeschreibung';
        }
        field(365; "Ship-Agent Code to Transf. Loc"; Code[20])
        {
            Caption = 'Ship-Agent Code to Transf. Loc';
            TableRelation = "Shipping Agent";
        }
        field(366; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(370; "Direct Unit Cost (LCY)"; Decimal)
        {
            Caption = 'Direct Unit Cost (LCY)';
        }
        field(376; "Freight Cost per Unit (LCY)"; Decimal)
        {
            Caption = 'Freight Cost per Unit (LCY)';
        }
        field(377; "Freight Cost Amount (LCY)"; Decimal)
        {
            Caption = 'Freight Cost Amount (LCY)';
        }
        field(380; "Cost Calc. per Unit (LCY)"; Decimal)
        {
            Caption = 'Cost Calc. per Unit (LCY)';
        }
        field(382; "Cost Calc. Amount (LCY)"; Decimal)
        {
            Caption = 'Cost Calc. Amount (LCY)';
        }
        field(385; "Indirect Cost Amt (Unit) (LCY)"; Decimal)
        {
            Caption = 'Indirect Cost Amt (Unit) (LCY)';
        }
        field(390; "Unit Cost (LCY)"; Decimal)
        {
            Caption = 'Unit Cost (LCY)';

            trigger OnValidate()
            var
                ldc_DirectUnitCost: Decimal;
            begin
                // Einkaufspreis in Preis pro Einheit umrechnen
                ldc_DirectUnitCost := "Purch. Price (Price Base)";

                "Unit Cost (LCY)" := ldc_DirectUnitCost +
                                     "Freight Cost per Unit (LCY)" +
                                     "Cost Calc. per Unit (LCY)";
            end;
        }
        field(400; "No. of Entries"; Integer)
        {
            CalcFormula = Count ("POI Assortment Version Line" WHERE("Item No." = FIELD("Item No."),
                                                                 "Starting Date Assortment" = FIELD("Date Filter")));
            Caption = 'No. of Entries';
            Editable = false;
            FieldClass = FlowField;
        }
        field(500; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(550; "Minimum Qty. 2"; Decimal)
        {
            Caption = 'Min. Mge. 2';
        }
        field(551; "Sales Price (Price Base) 2"; Decimal)
        {
            Caption = 'Sales Price (Price Base) 2';
        }
        field(555; "Minimum Qty. 3"; Decimal)
        {
            Caption = 'Min. Mge. 3';
        }
        field(556; "Sales Price (Price Base) 3"; Decimal)
        {
            Caption = 'Sales Price (Price Base) 3';
        }
        field(560; "Minimum Qty. 4"; Decimal)
        {
            Caption = 'Min. Mge. 4';
        }
        field(561; "Sales Price (Price Base) 4"; Decimal)
        {
            Caption = 'Sales Price (Price Base) 4';
        }
        field(580; "Shop Sales Price (LCY)"; Decimal)
        {
            Caption = 'Shop Sales Price (LCY)';
        }
        field(581; "Shop Sales Price Type"; Option)
        {
            Caption = 'Shop Sales Price Type';
            OptionCaption = ' ,Empfohlener Preis,Festpreis';
            OptionMembers = " ","Empfohlener Preis",Festpreis;
        }
        field(582; "Shop Sales Price Source"; Option)
        {
            Caption = 'Ladenverkaufspreis Herkunft';
            OptionCaption = 'Manufacturer,Dealer';
            OptionMembers = Manufacturer,Dealer;
        }
    }

    keys
    {
        key(Key1; "Assortment Version No.", "Line No.")
        {
        }
        key(Key2; "Sort Sequence", "Item Description")
        {
        }
        key(Key3; "Item Main Category Code", "Item Category Code", "Product Group Code", "Search Description")
        {
        }
        key(Key4; "Item No.", "Assortment Code", "Starting Date Assortment", "Ending Date Assortment")
        {
        }
        key(Key5; "Item No. 2")
        {
        }
        key(Key6; "Item No.", "Assortment Version No.")
        {
        }
        key(Key7; "Item Description")
        {
        }
        key(Key8; "Search Description")
        {
        }
        key(Key9; "Assortment Version No.", "Assortment Code", "Item Category Code", "Territory Code", "Vendor No.", "Teilselektion 1", "Teilselektion 2")
        {
        }
        key(Key10; "Batch Variant No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_AssortVersionLineDetail: Record "POI Assort Version Line Detail";
        lrc_SalesPrice: Record "Sales Price";
        lrc_Batch: Record "POI Batch Info Details";
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        lrc_AssortVersionLineDetail.SETRANGE("Assortment Version No.", "Assortment Version No.");
        lrc_AssortVersionLineDetail.SETRANGE("Assortment Version Line No.", "Line No.");
        IF NOT lrc_AssortVersionLineDetail.ISEMPTY() THEN
            lrc_AssortVersionLineDetail.DELETEALL();

        lrc_SalesPrice.SETRANGE("POI Assort. Version No.", "Assortment Version No.");
        lrc_SalesPrice.SETRANGE("POI Assort. Version Line No.", "Line No.");
        IF NOT lrc_SalesPrice.ISEMPTY() THEN
            lrc_SalesPrice.DELETEALL();

        IF "Batch Variant No." <> '' THEN
            IF lrc_BatchVariant.GET("Batch Variant No.") THEN
                IF lrc_BatchVariant.Source = lrc_BatchVariant.Source::Assortment THEN BEGIN
                    lrc_BatchVariant.CALCFIELDS("B.V. Sales Order (Qty)");
                    IF lrc_BatchVariant."B.V. Sales Order (Qty)" <> 0 THEN
                        // Löschung nicht zulässig. Es sind Verkaufsaufträge zugeordnet!
                        ERROR(ADF_GT_TEXT001Txt)
                    ELSE BEGIN
                        lrc_Batch.GET(lrc_BatchVariant."Batch No.");
                        lrc_Batch.DELETE(TRUE);
                        lrc_BatchVariant.DELETE(TRUE);
                    END;
                END;
    end;

    trigger OnInsert()
    var
        //lrc_Assortment: Record "POI Assortment";
        lrc_AssortmentVersion: Record "POI Assortment Version";
    begin
        lrc_AssortmentVersion.GET("Assortment Version No.");
        lrc_AssortmentVersion.TESTFIELD("Assortment Code");
        lrc_AssortmentVersion.TESTFIELD("Starting Date Assortment");
        lrc_AssortmentVersion.TESTFIELD("Starting Date Price");

        IF "Line No." = 0 THEN BEGIN
            lrc_AssortmentVersionLine.RESET();
            lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.", "Assortment Version No.");
            IF lrc_AssortmentVersionLine.FINDLAST() THEN
                "Line No." := lrc_AssortmentVersionLine."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        "Assortment Code" := lrc_AssortmentVersion."Assortment Code";
        "Starting Date Assortment" := lrc_AssortmentVersion."Starting Date Assortment";
        "Ending Date Assortment" := lrc_AssortmentVersion."Ending Date Assortment";
        "Currency Code" := lrc_AssortmentVersion."Currency Code";
        "Starting Date Price" := lrc_AssortmentVersion."Starting Date Price";
        "Ref. Date Validation" := lrc_AssortmentVersion."Ref. Date Validation";
        "Planing Date" := lrc_AssortmentVersion."Planing Date";
    end;

    var
        ADF_GT_TEXT001Txt: Label 'Löschung nicht zulässig. Es sind Verkaufsaufträge zugeordnet!';
        ADF_GT_TEXT002Txt: Label 'Artikel nicht zulässig, da nicht im Basissortiment enthalten!';
        ADF_GT_TEXT003Txt: Label 'Möchten Sie den bestehenden Datensatz ändern?';
        ADF_GT_TEXT004Txt: Label 'Artikel bereits im Sortiment. Möchten Sie den Artikel zusätzlich aufnehmen?';
        //ADF_GT_TEXT005Txt: Label 'Vendor %1 don''t exist !';
        gbn_NoGUI: Boolean;

    procedure ItemNo_Validate()
    var
        lcu_BaseData: Codeunit "POI Base Data Mgt";
        lco_No: Code[20];
        Text01Txt: Label 'Artikelnr. / Suchbegriff nicht vorhanden!';
    begin
        IF lcu_BaseData.ItemNoSearch("Item No.", 0, '', 0D, FALSE, '', lco_No) = FALSE THEN
            ERROR(Text01Txt)
        ELSE
            "Item No." := lco_No;

    end;

    procedure SetGUINotAvailable(vbn_NoGUI: Boolean)
    begin
        gbn_NoGUI := vbn_NoGUI;
    end;

    procedure CheckIfModifyIsAllowed(vin_FieldNo: Integer)
    var
        lrc_BatchVariant: Record "POI Batch Variant";
    begin
        IF CurrFieldNo <> vin_FieldNo THEN
            EXIT;
        IF "Batch Variant No." = '' THEN
            EXIT;

        IF CurrFieldNo = vin_FieldNo THEN BEGIN
            lrc_BatchVariant.GET("Batch Variant No.");
            IF (lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Purch. Order") OR
               (lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Packing Order") THEN
                ERROR('Änderung nicht zulässig!');
        END;
    end;

    procedure AssistEdit(vin_CurrFieldNo: Integer)
    var
        lcu_AssortmentMgt: Codeunit "POI Assortment Management";
    begin
        lcu_AssortmentMgt.EnterDetailInVersionLine(Rec, vin_CurrFieldNo);
    end;

    var
        lrc_Assortment: Record "POI Assortment";
        lrc_CaliberDetail: Record "POI Caliber Detail";
        lrc_AssortCustPriceGroup: Record "POI Assortmt-Cust. Price Group";
        lrc_SalesLine: Record "Sales Line";
        lrc_AssortmentVersionLine: Record "POI Assortment Version Line";
}

