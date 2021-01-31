table 5110367 "POI Pack. Batch Var. Quality"
{
    Caption = 'Batch Variant Packing Quality';
    // DrillDownFormID = Form5110373;
    // LookupFormID = Form5110373;

    fields
    {
        field(1; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch";
        }
        field(2; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(11; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant" WHERE("Item No." = FIELD("Item No."));
        }
        field(14; "Unit of Measure Code (Profed)"; Code[10])
        {
            Caption = 'Unit of Measure Code (Profed)';
            NotBlank = true;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                lrc_BatchVarPackQualityCaliber: Record "POI Pack. BatchVar.Qual Calib.";
                lrc_ItemUnitOfMeasure: Record "Item Unit of Measure";
            begin
                IF "Unit of Measure Code (Profed)" <> xRec."Unit of Measure Code (Profed)" THEN BEGIN

                    lrc_ItemUnitOfMeasure.GET("Item No.", "Unit of Measure Code (Profed)");
                    "Qty. per Base Unit of Measure" := lrc_ItemUnitOfMeasure."Qty. per Unit of Measure";

                    lrc_BatchVarPackQualityCaliber.RESET();
                    lrc_BatchVarPackQualityCaliber.SETRANGE("Batch Variant No.", "Batch Variant No.");
                    lrc_BatchVarPackQualityCaliber.SETRANGE("Batch No.", "Batch No.");
                    IF lrc_BatchVarPackQualityCaliber.FIND('-') THEN BEGIN
                        lrc_BatchVarPackQualityCaliber.MODIFYALL("Unit of Measure Code (Profed)", "Unit of Measure Code (Profed)");
                        lrc_BatchVarPackQualityCaliber.MODIFYALL("Qty. per Base Unit of Measure", lrc_ItemUnitOfMeasure."Qty. per Unit of Measure");
                    END;
                END;
            end;
        }
        field(15; "Quantity (Profed)"; Decimal)
        {
            Caption = 'Quantity (Profed)';
            DecimalPlaces = 3 : 3;

            trigger OnValidate()
            begin
                "Quantity (Base) (Profed)" := CalcBaseQty("Quantity (Profed)");
                VALIDATE("Exp. Sorting Quality 1");
                VALIDATE("Exp. Sorting Quality 2");
                VALIDATE("Exp. Sorting Quality 3");
                VALIDATE("Exp. Sorting Quality 4");
                VALIDATE("Exp. Sorting Quality 5");
                VALIDATE("Exp. Sorting Quality 6");
            end;
        }
        field(20; "Exp. Sorting Quality 1"; Decimal)
        {
            CaptionClass = '55001,1,1';
            Caption = 'Exp. Sorting Quality 1';
            DecimalPlaces = 3 : 3;
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. % Sorting Quality 1" := ("Exp. Sorting Quality 1" / "Quantity (Profed)") * 100
                ELSE
                    "Exp. % Sorting Quality 1" := 0;
            end;
        }
        field(22; "Exp. Sorting Quality 2"; Decimal)
        {
            CaptionClass = '55001,1,2';
            Caption = 'Exp. Sorting Quality 2';
            DecimalPlaces = 3 : 3;
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. % Sorting Quality 2" := ("Exp. Sorting Quality 2" / "Quantity (Profed)") * 100
                ELSE
                    "Exp. % Sorting Quality 2" := 0;
            end;
        }
        field(24; "Exp. Sorting Quality 3"; Decimal)
        {
            CaptionClass = '55001,1,3';
            Caption = 'Exp. Sorting Quality 3';
            DecimalPlaces = 3 : 3;
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. % Sorting Quality 3" := ("Exp. Sorting Quality 3" / "Quantity (Profed)") * 100
                ELSE
                    "Exp. % Sorting Quality 3" := 0;
            end;
        }
        field(26; "Exp. Sorting Quality 4"; Decimal)
        {
            CaptionClass = '55001,1,4';
            Caption = 'Exp. Sorting Quality 4';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. % Sorting Quality 4" := ("Exp. Sorting Quality 4" / "Quantity (Profed)") * 100
                ELSE
                    "Exp. % Sorting Quality 4" := 0;
            end;
        }
        field(27; "Exp. Sorting Quality 5"; Decimal)
        {
            CaptionClass = '55001,1,5';
            Caption = 'Exp. Sorting Quality 5';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. % Sorting Quality 5" := ("Exp. Sorting Quality 5" / "Quantity (Profed)") * 100
                ELSE
                    "Exp. % Sorting Quality 5" := 0;
            end;
        }
        field(28; "Exp. Sorting Quality 6"; Decimal)
        {
            CaptionClass = '55001,1,6';
            Caption = 'Exp. Sorting Quality 6';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. % Sorting Quality 6" := ("Exp. Sorting Quality 6" / "Quantity (Profed)") * 100
                ELSE
                    "Exp. % Sorting Quality 6" := 0;
            end;
        }
        field(40; "Exp. % Sorting Quality 1"; Decimal)
        {
            CaptionClass = '55000,1,1';
            Caption = 'Exp. % Sorting Quality 1';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. Sorting Quality 1" := ROUND(("Quantity (Profed)" / 100) * "Exp. % Sorting Quality 1", 0.001)
                ELSE
                    "Exp. Sorting Quality 1" := 0;
            end;
        }
        field(42; "Exp. % Sorting Quality 2"; Decimal)
        {
            CaptionClass = '55000,1,2';
            Caption = 'Exp. % Sorting Quality 2';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. Sorting Quality 2" := ROUND(("Quantity (Profed)" / 100) * "Exp. % Sorting Quality 2", 0.001)
                ELSE
                    "Exp. Sorting Quality 2" := 0;
            end;
        }
        field(44; "Exp. % Sorting Quality 3"; Decimal)
        {
            CaptionClass = '55000,1,3';
            Caption = 'Exp. % Sorting Quality 3';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. Sorting Quality 3" := ROUND(("Quantity (Profed)" / 100) * "Exp. % Sorting Quality 3", 0.001)
                ELSE
                    "Exp. Sorting Quality 3" := 0;
            end;
        }
        field(46; "Exp. % Sorting Quality 4"; Decimal)
        {
            CaptionClass = '55000,1,4';
            Caption = 'Exp. % Sorting Quality 4';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. Sorting Quality 4" := ROUND(("Quantity (Profed)" / 100) * "Exp. % Sorting Quality 4", 0.001)
                ELSE
                    "Exp. Sorting Quality 4" := 0;
            end;
        }
        field(47; "Exp. % Sorting Quality 5"; Decimal)
        {
            CaptionClass = '55000,1,5';
            Caption = 'Exp. % Sorting Quality 5';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. Sorting Quality 5" := ROUND(("Quantity (Profed)" / 100) * "Exp. % Sorting Quality 5", 0.001)
                ELSE
                    "Exp. Sorting Quality 5" := 0;
            end;
        }
        field(48; "Exp. % Sorting Quality 6"; Decimal)
        {
            CaptionClass = '55000,1,6';
            Caption = 'Exp. % Sorting Quality 6';
            Description = 'MEV';

            trigger OnValidate()
            begin
                IF "Quantity (Profed)" <> 0 THEN
                    "Exp. Sorting Quality 6" := ROUND(("Quantity (Profed)" / 100) * "Exp. % Sorting Quality 6", 0.001)
                ELSE
                    "Exp. Sorting Quality 6" := 0;
            end;
        }
        field(80; "Date of Profment"; Date)
        {
            Caption = 'Date of Profment';
        }
        field(81; "Person in Charge"; Code[10])
        {
            Caption = 'Person in Charge';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Person in Charge" = CONST(true));
        }
        field(90; "Base Unit of Measure Code"; Code[10])
        {
            Caption = 'Base Unit of Measure Code';
            Editable = false;
            TableRelation = "Unit of Measure" WHERE("POI Is Base Unit of Measure" = CONST(true));
        }
        field(91; "Quantity (Base) (Profed)"; Decimal)
        {
            Caption = 'Quantity (Base) (Profed)';
            DecimalPlaces = 3 : 3;
            Editable = false;
        }
        field(92; "Qty. per Base Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Base Unit of Measure';
        }
        field(100; "Spectrum Caliber A-Goods"; Code[50])
        {
            Caption = 'Spectrum Caliber A-Goods';
            Description = 'MEV';
            TableRelation = "POI Caliber".Code;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF "Spectrum Caliber A-Goods" <> xRec."Spectrum Caliber A-Goods" THEN
                    ActualQuantityFields(Rec);
            end;
        }
        field(101; "Stage Of Ripe"; Option)
        {
            Caption = 'Stage Of Ripe';
            Description = 'MEV';
            InitValue = ripe;
            OptionCaption = 'very ripe,,,ripe,,,unripe';
            OptionMembers = "very ripe",,,ripe,,,unripe;
        }
        field(102; "Cut Probe"; Option)
        {
            Caption = 'Cut Probe';
            Description = 'MEV';
            OptionCaption = 'good,,,glassy,,,core decay,,,mealy';
            OptionMembers = good,,,glassy,,,"core decay",,,mealy;
        }
        field(103; "PM-Value"; Decimal)
        {
            Caption = 'PM-Value';
            DecimalPlaces = 0 : 2;
            Description = 'MEV';
            MaxValue = 100;
            MinValue = 0;
        }
        field(104; Comment; Text[30])
        {
            Caption = 'Comment';
            Description = 'MEV';
        }
        field(105; "Comment 2"; Text[30])
        {
            Caption = 'Comment 2';
            Description = 'MEV';
        }
        field(106; Purpose; Text[30])
        {
            Caption = 'Purpose';
            Description = 'MEV';
        }
    }

    keys
    {
        key(Key1; "Batch Variant No.", "Batch No.")
        {
        }
    }

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TESTFIELD("Qty. per Base Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Base Unit of Measure", 0.00001));
    end;

    procedure ActualQuantityFields(rrc_BatchVariantPackingQuality: Record "POI Pack. Batch Var. Quality")
    var
        lco_MinSpectrumCaliber: Code[10];
        lco_MaxSpectrumCaliber: Code[10];
        ldc_QuantityInSpectrum: Decimal;
        ldc_QuantityUnderSpectrum: Decimal;
        ldc_QuantityOverSpectrum: Decimal;
    begin
        IF rrc_BatchVariantPackingQuality."Spectrum Caliber A-Goods" <> '' THEN BEGIN
            lrc_BatchVarPackQualityCaliber.RESET();
            lrc_BatchVarPackQualityCaliber.SETRANGE("Batch Variant No.", rrc_BatchVariantPackingQuality."Batch Variant No.");
            lrc_BatchVarPackQualityCaliber.SETRANGE("Batch No.", rrc_BatchVariantPackingQuality."Batch No.");
            lrc_BatchVarPackQualityCaliber.SETFILTER("Caliber Code", rrc_BatchVariantPackingQuality."Spectrum Caliber A-Goods");

            lco_MinSpectrumCaliber := lrc_BatchVarPackQualityCaliber.GETRANGEMIN("Caliber Code");
            lco_MaxSpectrumCaliber := lrc_BatchVarPackQualityCaliber.GETRANGEMAX("Caliber Code");
        END ELSE BEGIN
            lco_MinSpectrumCaliber := '';
            lco_MaxSpectrumCaliber := '';
        END;

        ldc_QuantityInSpectrum := 0;
        ldc_QuantityUnderSpectrum := 0;
        ldc_QuantityOverSpectrum := 0;

        lrc_BatchVarPackQualityCaliber.RESET();
        lrc_BatchVarPackQualityCaliber.SETRANGE("Batch Variant No.", rrc_BatchVariantPackingQuality."Batch Variant No.");
        lrc_BatchVarPackQualityCaliber.SETRANGE("Batch No.", rrc_BatchVariantPackingQuality."Batch No.");
        IF lrc_BatchVarPackQualityCaliber.FIND('-') THEN BEGIN
            REPEAT
                IF (lco_MinSpectrumCaliber = '') AND (lco_MaxSpectrumCaliber = '') THEN
                    ldc_QuantityInSpectrum := ldc_QuantityInSpectrum + lrc_BatchVarPackQualityCaliber."Quantity (Profed)"
                ELSE
                    IF lrc_BatchVarPackQualityCaliber."Caliber Code" < lco_MinSpectrumCaliber THEN
                        ldc_QuantityUnderSpectrum := ldc_QuantityUnderSpectrum + lrc_BatchVarPackQualityCaliber."Quantity (Profed)"
                    ELSE
                        IF lrc_BatchVarPackQualityCaliber."Caliber Code" > lco_MaxSpectrumCaliber THEN
                            ldc_QuantityOverSpectrum := ldc_QuantityOverSpectrum + lrc_BatchVarPackQualityCaliber."Quantity (Profed)"
                        ELSE
                            ldc_QuantityInSpectrum := ldc_QuantityInSpectrum + lrc_BatchVarPackQualityCaliber."Quantity (Profed)";
            UNTIL lrc_BatchVarPackQualityCaliber.NEXT() = 0;

            VALIDATE("Exp. Sorting Quality 1", ldc_QuantityInSpectrum);
            VALIDATE("Exp. Sorting Quality 5", ldc_QuantityUnderSpectrum);
            VALIDATE("Exp. Sorting Quality 6", ldc_QuantityOverSpectrum);
        END;
    end;

    var
        lrc_BatchVarPackQualityCaliber: Record "POI Pack. BatchVar.Qual Calib.";
}

