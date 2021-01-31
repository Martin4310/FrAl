tableextension 50028 "POI Unit of Measure ext" extends "Unit of Measure" //MyTargetTableId
{
    fields
    {
        field(50000; "POI Is Freight Unit of Measure"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Freight Unit of Measure';
        }
        field(50002; "POI Pack Unit of Measure (PU)"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Packing Unit of Measure (PU)';
        }
        field(50003; "POI Is Transportation Unit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Transportation Unit';
        }
        field(50004; "POI Is Base Unit of Measure"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Base Unit of Measure';
        }
        field(50005; "POI Is Collo Unit of Measure"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Collo Unit of Measure';
        }
        field(50006; "POI Net Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Net Weight';
        }
        field(50007; "POI Gross Weight"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Gross Weight';
        }
        field(50008; "POI is Overpacking Unit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Ist Umverpackung';
        }
        field(50009; "POI Lenght"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Länge';
        }
        field(50010; "POI Wide"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Breite';
        }
        field(50011; "POI Height"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Höhe';
        }
        field(5110301; "POI Is Packing Unit of Measure"; Boolean)
        {
            Caption = 'Is Packing Unit of Measure';
        }
        field(5110309; "POI Kind of Unit of Measure"; Option)
        {
            Caption = 'Kind of Unit of Measure';
            OptionCaption = ' ,Base Unit,Content Unit,Packing Unit,Collo Unit,Transport Unit,,,Weight Unit';
            OptionMembers = " ","Base Unit","Content Unit","Packing Unit","Collo Unit","Transport Unit",,,"Weight Unit";
        }
        field(5110310; "POI Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            Description = 'FV';
            TableRelation = "Unit of Measure" WHERE("POI Is Base Unit of Measure" = CONST(true));
        }
        field(5110311; "POI Qty. (BU) per Unit of Meas"; Decimal)
        {
            Caption = 'Qty. (BU) per Unit of Measure';
            DecimalPlaces = 0 : 8;
            Description = 'FV';
        }
        field(5110315; "POI Packing Unit of Meas (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Packing Unit of Measure" = CONST(true));

            trigger OnValidate()
            begin
                IF "POI Packing Unit of Meas (PU)" = '' THEN
                    TESTFIELD("POI Content Unit of Meas (CP)", '');
            end;
        }
        field(5110316; "POI Qty. (PU) per Unit of Meas"; Decimal)
        {
            Caption = 'Qty. (PU) per Unit of Measure';
            DecimalPlaces = 0 : 8;
            Description = 'DSD';

            trigger OnValidate()
            begin
                IF "POI Qty. (PU) per Unit of Meas" <> 0 THEN
                    "POI Qty. (BU) per Packing Unit" := "POI Qty. (BU) per Unit of Meas" / "POI Qty. (PU) per Unit of Meas"
                ELSE
                    "POI Qty. (BU) per Packing Unit" := 0;
            end;
        }
        field(5110317; "POI Qty. (BU) per Packing Unit"; Decimal)
        {
            Caption = 'Qty. (BU) per Packing Unit';
            DecimalPlaces = 0 : 8;

        }
        field(5110318; "POI Content Unit of Meas (CP)"; Code[10])
        {
            Caption = 'Content Unit of Measure (CP)';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                IF "POI Content Unit of Meas (CP)" <> '' THEN
                    TESTFIELD("POI Packing Unit of Meas (PU)");
            end;
        }
        field(5110319; "POI Qty. (CP) per Packing Unit"; Decimal)
        {
            Caption = 'Qty. (CP) per Packing Unit';
            DecimalPlaces = 0 : 8;

            trigger OnValidate()
            begin
                IF "POI Qty. (CP) per Packing Unit" <> 0 THEN
                    TESTFIELD("POI Content Unit of Meas (CP)");
            end;
        }
        field(5110320; "POI Transp. Unit of Meas (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            Description = 'FV';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
            begin
                IF "POI Transp. Unit of Meas (TU)" <> xRec."POI Transp. Unit of Meas (TU)" THEN
                    IF "POI Transp. Unit of Meas (TU)" = '' THEN
                        "POI Qty. per Transp. Unit (TU)" := 0
                    ELSE BEGIN
                        lrc_UnitofMeasure.GET("POI Transp. Unit of Meas (TU)");
                        IF (lrc_UnitofMeasure."POI Number of Tiers" <> 0) AND
                           (lrc_UnitofMeasure."POI Number of Units per Tier" <> 0) THEN
                            "POI Qty. per Transp. Unit (TU)" := lrc_UnitofMeasure."POI Number of Tiers" * lrc_UnitofMeasure."POI Number of Units per Tier";
                    END;
            end;
        }
        field(5110321; "POI Qty. per Transp. Unit (TU)"; Decimal)
        {
            Caption = 'Qty. per Transport Unit (TU)';
            DecimalPlaces = 0 : 8;
            Description = 'FV';

            trigger OnValidate()
            begin
                IF "POI Qty. per Transp. Unit (TU)" <> 0 THEN
                    TESTFIELD("POI Transp. Unit of Meas (TU)");
            end;
        }
        field(5110323; "POI Freight Unit of Meas (FU)"; Code[10])
        {
            Caption = 'Freight Unit of Measure (FU)';
            Description = 'FV';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(5110330; "POI Part. Qty. Unit of Measure"; Code[10])
        {
            Caption = 'Partitial Qty. Unit of Measure';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            var
                TEXT001Txt: Label 'Anbruchseinheit muss einer vorhandenen Einheit entsprechen!';
            begin
                IF "POI Part. Qty. Unit of Measure" <> '' THEN
                    IF ("POI Part. Qty. Unit of Measure" <> Code) AND
                       ("POI Part. Qty. Unit of Measure" <> "POI Base Unit of Measure (BU)") AND
                       ("POI Part. Qty. Unit of Measure" <> "POI Packing Unit of Meas (PU)") AND
                       ("POI Part. Qty. Unit of Measure" <> "POI Content Unit of Meas (CP)") THEN
                        // Anbruchseinheit muss einer vorhandenen Einheit entsprechen!
                        ERROR(TEXT001Txt);
            end;
        }
        field(5110331; "POI Ref. Freight Unit"; Code[10])
        {
            Caption = 'Ref. Freight Unit';
        }
        field(5110332; "POI Ref. Freight Unit Qty"; Decimal)
        {
            Caption = 'Ref. Freight Unit Qty';
        }
        field(5110335; "POI Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));

            trigger OnValidate()
            begin
                IF "POI Empties Item No." <> xRec."POI Empties Item No." THEN
                    IF "POI Empties Item No." <> '' THEN
                        "POI Qty. Empties Items" := 1
                    ELSE
                        "POI Qty. Empties Items" := 0;
            end;
        }
        field(5110336; "POI Qty. Empties Items"; Decimal)
        {
            Caption = 'Qty. Empties Items';
            DecimalPlaces = 0 : 5;
            Description = 'LVW';
        }
        field(5110373; "POI Weight of Packaging"; Decimal)
        {
            Caption = 'Weight of Packaging';
            DecimalPlaces = 3 : 3;
            Description = 'FV';

            trigger OnValidate()
            begin
                IF "POI Weight of Packaging" <> 0 THEN
                    IF ("POI Net Weight" = 0) AND ("POI Gross Weight" <> 0) THEN
                        "POI Net Weight" := "POI Gross Weight" - "POI Weight of Packaging"
                    ELSE
                        IF ("POI Net Weight" <> 0) AND ("POI Gross Weight" = 0) THEN
                            "POI Gross Weight" := "POI Net Weight" + "POI Weight of Packaging";


            end;
        }
        field(5110386; "POI Number of Tiers"; Decimal)
        {
            Caption = 'Number of Tiers';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5110387; "POI Number of Units per Tier"; Decimal)
        {
            Caption = 'Number of Units per Tier';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5110391; "POI Purch. Acc per Collo (LCY)"; Decimal)
        {
            Caption = 'Purch. Accruel per Collo (LCY)';
            Description = 'FV';
        }
        field(5110399; "POI Blocked"; Option)
        {
            Caption = 'Blocked';
            Description = 'FV';
            OptionCaption = ' ,Purchase,Sales,Total';
            OptionMembers = " ",Purchase,Sales,Total;
        }
        field(5110627; "POI Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
    }

}