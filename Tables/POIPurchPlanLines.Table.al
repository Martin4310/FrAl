table 5110559 "POI Purch. Plan Lines"
{
    Caption = 'Purch. Plan Lines';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(9; "Planing No."; Code[20])
        {
            Caption = 'Planing No.';
            TableRelation = "POI Purch. Plan";
        }
        field(10; "Vendor No."; Code[20])
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
                    lrc_Vendor.GET("Vendor No.");
                    "Vend. Name" := lrc_Vendor.Name;
                    "Vend. Name 2" := lrc_Vendor."Name 2";
                    "Territory Code" := lrc_Vendor."Territory Code";
                    "Producer No." := '';
                    "Prod. Name" := '';

                    IF "Country of Origin Code" = '' THEN
                        "Country of Origin Code" := lrc_Vendor."POI Country of Origin Code";

                END ELSE BEGIN
                    "Vend. Name" := '';
                    "Vend. Name 2" := '';
                    "Territory Code" := '';
                    "Producer No." := '';
                    "Prod. Name" := '';
                END;
            end;
        }
        field(12; "Vend. Name"; Text[100])
        {
            Caption = 'Vend. Name';
        }
        field(13; "Vend. Name 2"; Text[50])
        {
            Caption = 'Vend. Name 2';
        }
        field(19; "Vend. Comment"; Text[80])
        {
            Caption = 'Vend. Comment';
        }
        field(20; "Vend. Quote No."; Code[20])
        {
            Caption = 'Kred.-Angebotsnr.';
        }
        field(21; "Vend. Quote Date"; Date)
        {
            Caption = 'Vend. Quote Date';
        }
        field(22; "Vend. Item No."; Code[20])
        {
            Caption = 'Vend. Item No.';
        }
        field(25; "Vend. Entry Location"; Code[10])
        {
            Caption = 'Vend. Entry Location';
            TableRelation = Location;
        }
        field(40; "Producer No."; Code[20])
        {
            Caption = 'Producer No.';
            TableRelation = Vendor."No." WHERE("POI Is Manufacturer" = CONST(true),
                                              Blocked = FILTER(' '));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                lcu_BaseData: Codeunit "POI Base Data Mgt";
                lco_ReturnCode: Code[20];
            begin
                lco_ReturnCode := lcu_BaseData.ProducerLookUp("Vendor No.");
                IF (lco_ReturnCode <> '') THEN
                    VALIDATE("Producer No.", lco_ReturnCode);
            end;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
                lcu_BaseData: Codeunit "POI Base Data Mgt";
                AGILES_TEXT002Txt: Label 'Vendor %1 don''t exist !', Comment = '%1';

            begin
                IF NOT lcu_BaseData.VendorValidate("Producer No.") THEN
                    ERROR(AGILES_TEXT002Txt, "Producer No.");

                lcu_BaseData.ProducerValidate("Producer No.", "Vendor No.");

                IF "Producer No." <> '' THEN BEGIN
                    lrc_Vendor.GET("Producer No.");
                    "Prod. Name" := lrc_Vendor.Name;
                END ELSE BEGIN
                    "Producer No." := '';
                    "Prod. Name" := '';
                END;
            end;
        }
        field(42; "Prod. Name"; Text[100])
        {
            Caption = 'Prod. Name';
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(59; "Territory Code"; Code[10])
        {
            Caption = 'Gebietscode';
            TableRelation = Territory;
        }
        field(60; "Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
        }
        field(70; "Planing Starting Date"; Date)
        {
            Caption = 'Planing Starting Date';
        }
        field(71; "Planing Ending Date"; Date)
        {
            Caption = 'Planing Ending Date';
        }
        field(80; "Shipping Date Vendor"; Date)
        {
            Caption = 'Shipping Date Vendor';
        }
        field(81; "Expected Receipt Date Location"; Date)
        {
            Caption = 'Expected Receipt Date Location';
        }
        field(83; "Shipping Date"; Date)
        {
            Caption = 'Shipping Date';
        }
        field(90; "Via Entry Location Code"; Code[10])
        {
            Caption = 'Via Entry Location Code';
            TableRelation = Location;
        }
        field(300; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                // Eingabe Validieren
                ValidateItemNo();

                // Kopfsatz lesen und Werte validieren
                // GetAgencyPlanHeader();

                IF grc_AgencyPlanHeader."Planing Type" = grc_AgencyPlanHeader."Planing Type"::"Vendor Assortment" THEN BEGIN
                    "Vendor No." := grc_AgencyPlanHeader."Vendor No.";
                    "Vend. Name" := grc_AgencyPlanHeader."Vend. Name";
                    "Territory Code" := grc_AgencyPlanHeader."Territory Code";
                    "Producer No." := grc_AgencyPlanHeader."Producer No.";
                    "Prod. Name" := grc_AgencyPlanHeader."Prod. Name";
                END;

                "Planing Starting Date" := grc_AgencyPlanHeader."Planing Starting Date";
                "Shipping Date Vendor" := grc_AgencyPlanHeader."Shipping Date Vendor";
                "Expected Receipt Date Location" := grc_AgencyPlanHeader."Expected Receipt Date Location";
                "Shipping Date" := grc_AgencyPlanHeader."Shipping Date";

                Quantity := 0;

                IF "Item No." <> '' THEN BEGIN
                    lrc_Item.GET("Item No.");
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";

                    "Country of Origin Code" := lrc_Item."POI Countr of Ori Code (Fruit)";
                    "Variety Code" := lrc_Item."POI Variety Code";
                    "Trademark Code" := lrc_Item."POI Trademark Code";
                    "Caliber Code" := lrc_Item."POI Caliber Code";
                    "Quality Code" := lrc_Item."POI Item Attribute 3";
                    "Color Code" := lrc_Item."POI Item Attribute 2";
                    "Grade of Goods Code" := lrc_Item."POI Grade of Goods Code";
                    "Conservation Code" := lrc_Item."POI Item Attribute 7";
                    "Packing Code" := lrc_Item."POI Item Attribute 4";
                    "Coding Code" := lrc_Item."POI Coding Code";
                    "Treatment Code" := lrc_Item."POI Item Attribute 5";
                    "Proper Name Code" := lrc_Item."POI Item Attribute 6";
                    "Cultivation Type" := lrc_Item."POI Cultivation Type";

                    "Base Unit of Measure" := lrc_Item."Base Unit of Measure";
                    "Batch Item" := lrc_Item."POI Batch Item";

                    VALIDATE("Unit of Measure Code", lrc_Item."Sales Unit of Measure");
                    VALIDATE("Price Base (Purch. Price)", lrc_Item."POI Price Base (Purch. Price)");

                END ELSE BEGIN
                    "Item Description" := '';
                    "Item Description 2" := '';

                    "Country of Origin Code" := '';
                    "Variety Code" := '';
                    "Trademark Code" := '';
                    "Caliber Code" := '';
                    "Vendor Caliber Code" := '';
                    "Quality Code" := '';
                    "Color Code" := '';
                    "Grade of Goods Code" := '';
                    "Conservation Code" := '';
                    "Packing Code" := '';
                    "Coding Code" := '';
                    "Treatment Code" := '';
                    "Proper Name Code" := '';
                    "Cultivation Type" := "Cultivation Type"::" ";

                    "Unit of Measure Code" := '';
                    "Qty. per Unit of Measure" := 1;

                    "Batch Item" := FALSE;
                    VALIDATE("Price Base (Purch. Price)", '');

                END;
            end;
        }
        field(301; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(303; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(304; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(307; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(308; "Batch No."; Code[20])
        {
            Caption = 'Positionsnr.';
            TableRelation = "POI Batch";
        }
        field(309; "Batch Var. No."; Code[20])
        {
            Caption = 'Pos.-Var. Nr.';
            TableRelation = "POI Batch Variant";
        }
        field(310; "Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            TableRelation = "Country/Region".Code;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF lrc_Item.GET("Item No.") THEN
                    IF lrc_Item."POI Countr of Ori Code (Fruit)" <> '' THEN
                        "Country of Origin Code" := lrc_Item."POI Countr of Ori Code (Fruit)";
            end;
        }
        field(311; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety".Code;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF lrc_Item.GET("Item No.") THEN
                    IF lrc_Item."POI Variety Code" <> '' THEN
                        "Variety Code" := lrc_Item."POI Variety Code";
            end;
        }
        field(312; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(313; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;
        }
        field(314; "Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            TableRelation = "POI Caliber - Vendor Caliber"."Vendor No." WHERE("Caliber Code" = FIELD("Caliber Code"));
            ValidateTableRelation = false;
        }
        field(315; "Quality Code"; Code[10])
        {
            Caption = 'Quality Code';
            TableRelation = "POI Item Attribute 3".Code;
        }
        field(316; "Color Code"; Code[10])
        {
            Caption = 'Color Code';
            TableRelation = "POI Item Attribute 2";
        }
        field(317; "Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            TableRelation = "POI Grade of Goods";
        }
        field(318; "Conservation Code"; Code[10])
        {
            Caption = 'Conservation Code';
            TableRelation = "POI Item Attribute 7";
        }
        field(319; "Packing Code"; Code[10])
        {
            Caption = 'Packing Code';
            TableRelation = "POI Item Attribute 4";
        }
        field(320; "Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            TableRelation = "POI Coding";
        }
        field(321; "Treatment Code"; Code[10])
        {
            Caption = 'Treatment Code';
            TableRelation = "POI Item Attribute 5";
        }
        field(322; "Proper Name Code"; Code[20])
        {
            Caption = 'Proper Name Code';
            TableRelation = "POI Proper Name";
            ValidateTableRelation = false;
        }
        field(323; "Certificate Control Board"; Code[20])
        {
            Caption = 'Certificate Control Board';
            TableRelation = "POI Certificate Control Board";
        }
        field(324; "Cultivation Association"; Code[10])
        {
            Caption = 'Cultivation Association';
            TableRelation = "POI Cultivation Association";
        }
        field(325; "Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(326; "Cultivation Process Code"; Code[10])
        {
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(330; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Collo Unit of Measure" = CONST(true));

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
                //lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
                lrc_item: Record Item;
            begin
                IF "Unit of Measure Code" <> '' THEN BEGIN
                    lrc_UnitofMeasure.GET("Unit of Measure Code");
                    "Packing Unit of Measure" := lrc_UnitofMeasure."POI Packing Unit of Meas (PU)";
                    "Qty. PU per CU" := lrc_UnitofMeasure."POI Qty. (PU) per Unit of Meas";
                    "Qty. per Unit of Measure" := lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas";
                    //xx  lrc_ItemUnitofMeasure.GET("Item No.","Unit of Measure Code");
                    lrc_item.GET("Item No.");
                    //"Transport Unit of Measure" := lrc_item."Transport Unit of Measure (TU)"; //TODO: feld klären
                END ELSE
                    "Qty. per Unit of Measure" := 1;

                VALIDATE(Quantity);
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

                VALIDATE("Purchase Price (Price Base)");
            end;
        }
        field(340; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(342; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(344; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';

            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(350; "Packing Unit of Measure"; Code[10])
        {
            Caption = 'Packing Unit of Measure';
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
        field(355; "Transport Unit of Measure"; Code[10])
        {
            Caption = 'Transport Unit of Measure';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(356; "Qty. Unit per TU"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. Unit per TU';
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
        field(380; "Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));

            trigger OnValidate()
            begin
                "Empties Quantity" := 1;
            end;
        }
        field(381; "Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(383; "Empties Item Name"; Text[30])
        {
            CalcFormula = Lookup (Item.Description WHERE("No." = FIELD("Empties Item No.")));
            Caption = 'Empties Item Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(390; "Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Purch. Price"),
                                                     Blocked = CONST(false));

            trigger OnValidate()
            var
                lrc_PriceCalculation: Record "POI Price Base";
                lcu_PurchaseMgt: Codeunit "POI Purch. Mgt";
            begin
                "Price Unit of Measure Code" := lcu_PurchaseMgt.PurchPlanLineGetPriceUnit(Rec);

                lrc_PriceCalculation.RESET();
                lrc_PriceCalculation.SETRANGE("Purch./Sales Price Calc.", lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price");
                lrc_PriceCalculation.SETRANGE(Code, "Price Base (Purch. Price)");

                VALIDATE("Purchase Price (Price Base)");
            end;
        }
        field(392; "Price Unit of Measure Code"; Code[10])
        {
            Caption = 'Price Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(393; "Qty. per Price Unit"; Decimal)
        {
            Caption = 'Qty. per Price Unit';
        }
        field(400; "Purchase Price (Price Base)"; Decimal)
        {
            Caption = 'Purchase Price (Price Base)';

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
                lrc_UnitofMeasure2: Record "Unit of Measure";
            begin
                IF "Price Unit of Measure Code" = '' THEN
                    "Direct Unit Amount" := "Purchase Price (Price Base)" * Quantity
                ELSE BEGIN
                    lrc_UnitofMeasure.GET("Price Unit of Measure Code");
                    IF lrc_UnitofMeasure."POI Base Unit of Measure (BU)" <> "Base Unit of Measure" THEN
                        ERROR('Basiseinheit der Preiseinheit ist abweichend!');

                    IF lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" = 0 THEN BEGIN
                        lrc_UnitofMeasure2.GET("Unit of Measure Code");
                        lrc_UnitofMeasure2.TESTFIELD("POI Qty. (BU) per Packing Unit");
                        "Direct Unit Amount" := "Quantity (Base)" /
                                                     lrc_UnitofMeasure2."POI Qty. (BU) per Packing Unit" *
                                                     "Purchase Price (Price Base)";
                    END ELSE
                        "Direct Unit Amount" := "Quantity (Base)" / lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" *
                                                   "Purchase Price (Price Base)";
                END;
            end;
        }
        field(409; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            Editable = false;
        }
        field(410; "Direct Unit Amount"; Decimal)
        {
            Caption = 'Direct Unit Amount';
        }
        field(412; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(413; "Unit Cost Amount"; Decimal)
        {
            Caption = 'Unit Cost Amount';
        }
        field(415; "Freight Cost"; Decimal)
        {
            Caption = 'Frachtkosten';
        }
        field(416; "Demurrage Cost"; Decimal)
        {
            Caption = 'Demurrage Cost';
        }
        field(417; "Other Costs"; Decimal)
        {
            Caption = 'Sonstige Kosten';
        }
        field(420; "Sales Price"; Decimal)
        {
            Caption = 'Sales Price';
        }
        field(424; "Outlet Sales Price (incl. VAT)"; Decimal)
        {
            Caption = 'Outlet Sales Price (incl. VAT)';
        }
        field(500; "Internal Comment"; Text[80])
        {
            Caption = 'Internal Comment';
        }
        field(501; "External Comment 1"; Text[80])
        {
            Caption = 'External Comment 1';
        }
        field(502; "Language External Comment 1"; Code[10])
        {
            Caption = 'Language External Comment 1';
            TableRelation = Language;
        }
        field(503; "External Standard Text Code"; Code[10])
        {
            Caption = 'External Standard Text Code';
            TableRelation = "Standard Text".Code;
        }
        field(504; "External Comment 2"; Text[80])
        {
            Caption = 'External Comment 2';
        }
        field(505; "Language External Comment 2"; Code[10])
        {
            Caption = 'Language External Comment 2';
            TableRelation = Language;
        }
        field(506; "External Comment 3"; Text[80])
        {
            Caption = 'External Comment 3';
        }
        field(507; "Language External Comment 3"; Code[10])
        {
            Caption = 'Language External Comment 3';
            TableRelation = Language;
        }
        field(508; "External Comment 4"; Text[80])
        {
            Caption = 'External Comment 4';
        }
        field(509; "Language External Comment 4"; Code[10])
        {
            Caption = 'Language External Comment 4';
            TableRelation = Language;
        }
        field(580; "Assortment Version No."; Code[20])
        {
            Caption = 'Assortment Version No.';
        }
        field(581; "Assortment Version Line No."; Integer)
        {
            Caption = 'Assortment Version Line No.';
        }
        field(5110326; "Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Item Description", "Variety Code", "Country of Origin Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // Kontrolle Verknüpfung Verkauf ????? vor Löschung
    end;

    trigger OnInsert()
    var
        lrc_PurchPlanLines: Record "POI Purch. Plan Lines";
    begin
        IF "Entry No." > 0 THEN
            IF lrc_PurchPlanLines.GET("Entry No.") THEN
                "Entry No." := 0;

        IF "Entry No." = 0 THEN
            IF lrc_PurchPlanLines.FINDLAST() THEN
                "Entry No." := lrc_PurchPlanLines."Entry No." + 1
            ELSE
                "Entry No." := 1;
    end;

    var
        grc_AgencyPlanHeader: Record "POI Purch. Plan";

    procedure GetAgencyPlanHeader()
    begin
        IF grc_AgencyPlanHeader.GET("Planing No.") THEN BEGIN

            IF grc_AgencyPlanHeader."Planing Type" = grc_AgencyPlanHeader."Planing Type"::"Vendor Assortment" THEN
                grc_AgencyPlanHeader.TESTFIELD("Vendor No.");

            IF grc_AgencyPlanHeader."Planing Type" <> grc_AgencyPlanHeader."Planing Type"::"Quotes by Item" THEN BEGIN
                grc_AgencyPlanHeader.TESTFIELD("Planing Starting Date");
                grc_AgencyPlanHeader.TESTFIELD("Shipping Date");
            END;
        END;
    end;

    procedure ValidateItemNo()
    var
        lcu_BaseDataMgt: Codeunit "POI BDM Base Data Mgmt";
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zur Validierung der Nummern Eingabe
        // --------------------------------------------------------------------------------------

        IF "Item No." = '' THEN
            EXIT;

        // -----------------------------------------------------------------------------------
        // Funktion zur Suche eines Artikels
        // rco_ItemNo
        // vbn_Search
        // vop_Source
        // vdt_OrderDate
        // vco_CustomerNo
        // vbn_SearchInAssortment
        // vco_AssortmentVersionNo
        // -----------------------------------------------------------------------------------
        lcu_BaseDataMgt.ItemValidateSearch("Item No.", (CurrFieldNo = FIELDNO("Item No.")), 1, 0D, '', FALSE, '');
    end;
}

