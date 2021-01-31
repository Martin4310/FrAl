tableextension 50012 "POI Transfer Line Ext" extends "Transfer Line"
{
    fields
    {
        field(50000; "POI Empties Attached Line No."; Integer)
        {
        }
        field(5110300; "POI Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "POI Shortcut Dimension 3 Code");
            end;
        }
        field(5110301; "POI Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'EDM';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "POI Shortcut Dimension 4 Code");
            end;
        }
        field(5110305; "POI Subtyp"; Option)
        {
            Caption = 'Subtyp';
            OptionCaption = ' ,Discount,Refund';
            OptionMembers = " ",Discount,Refund;
        }
        field(5110307; "POI Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(5110313; "POI Numb of Pallet Item Lines"; Integer)
        {
            BlankZero = true;
            CalcFormula = Count ("POI Pallet - Item Lines" WHERE("Item No." = FIELD("Item No."),
                                                              "Variant Code" = FIELD("Variant Code"),
                                                              "Location Code" = FIELD("Transfer-from Code"),
                                                              "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                              "Master Batch No." = FIELD("POI Master Batch No."),
                                                              "Batch No." = FIELD("POI Batch No."),
                                                              "Batch Variant No." = FIELD("POI Batch Variant No."),
                                                              "Location Bin Code" = FIELD(FILTER("POI Transfer-from Location Bin"))));
            Caption = 'Number of Pallet Item Lines';
            Description = 'PAL Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110314; "POI Qty(Base) of Pallet It Lin"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum ("POI Pallet - Item Lines"."Quantity (Base)" WHERE("Item No." = FIELD("Item No."),
                                                                              "Variant Code" = FIELD("Variant Code"),
                                                                              "Location Code" = FIELD("Transfer-from Code"),
                                                                              "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                              "Master Batch No." = FIELD("POI Master Batch No."),
                                                                              "Batch No." = FIELD("POI Batch No."),
                                                                              "Batch Variant No." = FIELD("POI Batch Variant No."),
                                                                              "Location Bin Code" = FIELD(FILTER("POI Transfer-from Location Bin"))));
            Caption = 'Quantity (Base) Pallet Item Lines';
            DecimalPlaces = 0 : 5;
            Description = 'PAL Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110315; "POI Quantity Pallet Item Lines"; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum ("POI Pallet - Item Lines".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                     "Variant Code" = FIELD("Variant Code"),
                                                                     "Location Code" = FIELD("Transfer-from Code"),
                                                                     "Unit of Measure Code" = FIELD("Unit of Measure Code"),
                                                                     "Master Batch No." = FIELD("POI Master Batch No."),
                                                                     "Batch No." = FIELD("POI Batch No."),
                                                                     "Batch Variant No." = FIELD("POI Batch Variant No."),
                                                                     "Location Bin Code" = FIELD(FILTER("POI Transfer-from Location Bin"))));
            Caption = 'Quantity Pallet Item Lines';
            DecimalPlaces = 0 : 5;
            Description = 'PAL Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110316; "POI Transfer-from Location Bin"; Code[10])
        {
            Caption = 'Transfer-from Location Bin';
            Description = 'PAL';
            TableRelation = "POI Location Bins".Code WHERE("Location Code" = FIELD("Transfer-from Code"));
        }
        field(5110317; "POI Transfer-to Location Bin"; Code[10])
        {
            Caption = 'Transfer-to Location Bin';
            Description = 'PAL';
            TableRelation = "POI Location Bins".Code WHERE("Location Code" = FIELD("Transfer-to Code"));
        }
        field(5110320; "POI Item Typ"; Option)
        {
            Caption = 'Item Typ';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material";
        }
        field(5110321; "POI Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";

            trigger OnValidate()
            begin
                ADF_BatchValidate(FIELDNO("POI Master Batch No."));
            end;
        }
        field(5110322; "POI Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = IF ("POI Master Batch No." = FILTER(<> '')) "POI Batch"."No." WHERE("Master Batch No." = FIELD("POI Master Batch No."))
            ELSE
            IF ("POI Master Batch No." = FILTER('')) "POI Batch"."No.";

            trigger OnValidate()
            begin
                ADF_BatchValidate(FIELDNO("POI Batch No."));
            end;
        }
        field(5110323; "POI Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF ("Item No." = FILTER(''),
                                "POI Master Batch No." = FILTER(<> ''),
                                "POI Batch No." = FILTER(<> '')) "POI Batch Variant" WHERE("Master Batch No." = FIELD("POI Master Batch No."),
                                                                               "Batch No." = FIELD("POI Batch No."))
            ELSE
            IF ("Item No." = FILTER(''),
                                                                                        "POI Master Batch No." = FILTER(''),
                                                                                        "POI Batch No." = FILTER('')) "POI Batch Variant"
            ELSE
            IF ("Item No." = FILTER(<> ''),
                                                                                                 "POI Master Batch No." = FILTER(''),
                                                                                                 "POI Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."))
            ELSE
            IF ("POI Master Batch No." = FILTER(<> ''),
                                                                                                          "POI Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                                                                                                                       "Master Batch No." = FIELD("POI Master Batch No."))
            ELSE
            IF ("POI Master Batch No." = FILTER(<> ''),
                                                                                                                                                                "POI Batch No." = FILTER(<> '')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                                                                                                                                                                               "Master Batch No." = FIELD("POI Master Batch No."),
                                                                                                                                                                                                               "Batch No." = FIELD("POI Batch No."));

            trigger OnValidate()
            begin
                ADF_BatchValidate(FIELDNO("POI Batch Variant No."));
            end;
        }
        field(5110324; "POI Batch Var. Detail ID"; Integer)
        {
            Caption = 'Batch Var. Detail ID';
        }
        field(5110326; "POI Batch Item"; Boolean)
        {
            Caption = 'Batch Item';
        }
        field(5110380; "POI Base Unit of Measure (BU)"; Code[10])
        {
            Caption = 'Base Unit of Measure (BU)';
            Editable = false;
        }
        field(5110381; "POI Packing Unit of Meas (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
        }
        field(5110382; "POI Qty. (PU) per Collo (CU)"; Decimal)
        {
            Caption = 'Qty. (PU) per Collo (CU)';
        }
        field(5110383; "POI Quantity (PU)"; Decimal)
        {
            Caption = 'Quantity (PU)';
        }
        field(5110384; "POI Trans Unit of Measure (TU)"; Code[10])
        {
            Caption = 'Transport Unit of Measure (TU)';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var
                lrc_UnitofMeasure: Record "Unit of Measure";
            begin
                IF "POI Trans Unit of Measure (TU)" <> '' THEN BEGIN
                    lrc_UnitofMeasure.GET("POI Trans Unit of Measure (TU)");
                    "POI Freight Unit of Measure" := lrc_UnitofMeasure."POI Freight Unit of Meas (FU)";
                END ELSE BEGIN
                    "POI Freight Unit of Measure" := '';
                    "POI Qty.(Unit) per Transp.(TU)" := 0;
                    "POI Quantity (TU)" := 0;
                END;
            end;
        }
        field(5110385; "POI Qty.(Unit) per Transp.(TU)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. (Unit) per Transp.(TU)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Qty.(Unit) per Transp.(TU)") THEN
                    IF "POI Qty.(Unit) per Transp.(TU)" <> 0 THEN
                        "POI Quantity (TU)" := ROUND(Quantity / "POI Qty.(Unit) per Transp.(TU)", 0.00001)
                    ELSE
                        "POI Quantity (TU)" := 0;
            end;
        }
        field(5110386; "POI Quantity (TU)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity (TU)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF CurrFieldNo = FIELDNO("POI Quantity (TU)") THEN BEGIN
                    IF "POI Quantity (TU)" <> 0 THEN
                        TESTFIELD("POI Qty.(Unit) per Transp.(TU)");
                    VALIDATE(Quantity, ("POI Quantity (TU)" * "POI Qty.(Unit) per Transp.(TU)"));
                END;
            end;
        }
        field(5110387; "POI Freight Unit of Measure"; Code[10])
        {
            Caption = 'Freight Unit of Measure';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(5110390; "POI Reference Freight Costs"; Option)
        {
            Caption = 'Reference Freight Costs';
            OptionCaption = 'Collo,Pallet,Weight,Pallet Type';
            OptionMembers = Collo,Pallet,Weight,"Pallet Type";

            trigger OnValidate()
            begin
                VALIDATE("POI Frei Costs per Ref. Unit");
            end;
        }
        field(5110391; "POI Frei Costs per Ref. Unit"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Freight Costs per Ref. Unit';

            trigger OnValidate()
            begin
                CASE "POI Reference Freight Costs" OF
                    "POI Reference Freight Costs"::"Pallet Type":
                        "POI Freight Costs Amount (LCY)" := "POI Frei Costs per Ref. Unit" * "POI Quantity (TU)";
                    "POI Reference Freight Costs"::Pallet:
                        "POI Freight Costs Amount (LCY)" := "POI Frei Costs per Ref. Unit" * "POI Quantity (TU)";
                    "POI Reference Freight Costs"::Collo:
                        "POI Freight Costs Amount (LCY)" := "POI Frei Costs per Ref. Unit" * Quantity;
                    "POI Reference Freight Costs"::Weight:
                        "POI Freight Costs Amount (LCY)" := "POI Frei Costs per Ref. Unit" * "POI Total Gross Weight";
                END;
            end;
        }
        field(5110392; "POI Freight Costs Amount (LCY)"; Decimal)
        {
            Caption = 'Freight Costs Amount (LCY)';
        }
        field(5110398; "POI Mark Unit Cost(Basis)(LCY)"; Decimal)
        {
            Caption = 'Market Unit Cost (Basis) (LCY)';
            Description = 'MEK';
        }
        field(5110410; "POI Empties Item No."; Code[20])
        {
            Caption = 'Empties Item No.';
            Description = 'LVW';
            TableRelation = Item WHERE("POI Item Typ" = CONST("Empties Item"));
        }
        field(5110411; "POI Empties Quantity"; Decimal)
        {
            Caption = 'Empties Quantity';
            Description = 'LVW';

            trigger OnValidate()
            var
                lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
            begin
                IF "Document No." > '2344' THEN
                    IF "POI Empties Quantity" <> 0 THEN
                        lcu_EmptiesManagement.TransferAttachEmptiesLine(Rec)
                    ELSE BEGIN  //RS nur Menge in UmlagerungsLeergutzeile anpassen
                        lrc_TransferLine.RESET();
                        lrc_TransferLine.SETRANGE("Document No.", "Document No.");
                        lrc_TransferLine.SETRANGE("Line No.", "POI Empties Attached Line No.");
                        IF lrc_TransferLine.FINDSET(TRUE, FALSE) THEN BEGIN
                            lrc_TransferLine.VALIDATE(Quantity, Rec."POI Empties Quantity");
                            lrc_TransferLine.MODIFY();
                        END;
                    END;
            end;
        }
        field(5110430; "POI Total Net Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Total Net Weight';
            DecimalPlaces = 0 : 3;
        }
        field(5110431; "POI Total Gross Weight"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Total Gross Weight';
            DecimalPlaces = 0 : 3;
        }
        field(5110432; "POI Weight"; Option)
        {
            Caption = 'Weight';
            OptionCaption = ' ,Gross Weight,Net Weight,Manuel Weight';
            OptionMembers = " ","Gross Weight","Net Weight","Manuel Weight";
        }
        field(5110435; "POI Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";

            begin
                IF ("POI Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo(
                       "POI Batch No.", "POI Batch Variant No.", 0,
                       lrc_BatchInfoDetails."Comment Type"::"Sales Information", "POI Info 1");
            end;
        }
        field(5110436; "POI Info 2"; Code[50])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";

            begin
                IF ("POI Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo(
                       "POI Batch No.", "POI Batch Variant No.", 1,
                       lrc_BatchInfoDetails."Comment Type"::"Sales Information", "POI Info 2");
            end;
        }
        field(5110437; "POI Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";
            begin
                IF ("POI Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo(
                       "POI Batch No.", "POI Batch Variant No.", 2,
                       lrc_BatchInfoDetails."Comment Type"::"Sales Information", "POI Info 3");
            end;
        }
        field(5110438; "POI Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'BSI';

            trigger OnValidate()
            var
                lrc_BatchInfoDetails: Record "POI Batch Info Details";
                lcu_BatchManagement: Codeunit "POI BAM Batch Management";

            begin
                IF ("POI Batch No." <> '') THEN
                    lcu_BatchManagement.UpdBatchSourceInfo(
                       "POI Batch No.", "POI Batch Variant No.", 3,
                       lrc_BatchInfoDetails."Comment Type"::"Sales Information", "POI Info 4");
            end;
        }
        field(5110440; "POI Country of Origin Code"; Code[10])
        {
            Caption = 'Country of Origin Code';
            Description = 'EIA';
            TableRelation = "Country/Region";
        }
        field(5110441; "POI Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            Description = 'EIA';
            TableRelation = "POI Variety";
        }
        field(5110442; "POI Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            Description = 'EIA';
            TableRelation = "POI Trademark";
        }
        field(5110443; "POI Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber";
        }
        field(5110444; "POI Vendor Caliber Code"; Code[10])
        {
            Caption = 'Vendor Caliber Code';
            Description = 'EIA';
            TableRelation = "POI Caliber - Vendor Caliber"."Vendor No.";
        }
        field(5110445; "POI Item Attribute 3"; Code[10])
        {
            CaptionClass = '5110310,1,3';
            Caption = 'Quality Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 3";
        }
        field(5110446; "POI Item Attribute 2"; Code[10])
        {
            CaptionClass = '5110310,1,2';
            Caption = 'Color Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 2";
        }
        field(5110447; "POI Grade of Goods Code"; Code[10])
        {
            Caption = 'Grade of Goods Code';
            Description = 'EIA';
            //TableRelation = "POI Grade of Goods";
        }
        field(5110448; "POI Item Attribute 7"; Code[10])
        {
            CaptionClass = '5110310,1,7';
            Caption = 'Conservation Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 7";
        }
        field(5110449; "POI Item Attribute 4"; Code[10])
        {
            CaptionClass = '5110310,1,4';
            Caption = 'Packing Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 4";
        }
        field(5110450; "POI Coding Code"; Code[10])
        {
            Caption = 'Coding Code';
            Description = 'EIA';
            //TableRelation = "POI Coding";
        }
        field(5110451; "POI Item Attribute 5"; Code[10])
        {
            CaptionClass = '5110310,1,5';
            Caption = 'Treatment Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 5";
        }
        field(5110452; "POI Item Attribute 6"; Code[20])
        {
            CaptionClass = '5110310,1,6';
            Caption = 'Proper Name Code';
            Description = 'EIA';
            TableRelation = "POI Proper Name";
        }
        field(5110453; "POI Cultivation Type"; Option)
        {
            Caption = 'Cultivation Type';
            Description = 'EIA';
            OptionCaption = ' ,Transition,Organic,,,Conventional';
            OptionMembers = " ",Transition,Organic,,,Conventional;
        }
        field(5110454; "POI Item Attribute 1"; Code[10])
        {
            CaptionClass = '5110310,1,1';
            Caption = 'Cultivation Process Code';
            Description = 'EIA';
            TableRelation = "POI Item Attribute 1";
        }
        field(5110455; "POI Item Attribute 8"; Code[10])
        {
            CaptionClass = '5110310,1,8';
            Caption = 'Item Attribute 8';
            Description = 'EIA';
        }
        field(5110470; "POI Nb Of Not Posted Outg.Pal."; Integer)
        {
            CalcFormula = Count ("POI Outgoing Pallet" WHERE("Document Type" = CONST("Transfer Order"),
                                                          "Document No." = FIELD("Document No."),
                                                          "Document Line No." = FIELD("Line No."),
                                                          Posted = CONST(false)));
            Caption = 'Number Of Not Posted Outg.Pal.';
            Description = 'PAL,Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110471; "POI Qty. In Not Post Outg.Pal."; Decimal)
        {
            CalcFormula = Sum ("POI Outgoing Pallet".Quantity WHERE("Document Type" = CONST("Transfer Order"),
                                                                 "Document No." = FIELD("Document No."),
                                                                 "Document Line No." = FIELD("Line No."),
                                                                 Posted = CONST(false)));
            Caption = 'Qty. In Not Posted Outg. Pal.';
            Description = 'PAL,Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110472; "POI Number Of Post Outg. Pal."; Integer)
        {
            CalcFormula = Count ("POI Outgoing Pallet" WHERE("Document Type" = CONST("Transfer Order"),
                                                          "Document No." = FIELD("Document No."),
                                                          "Document Line No." = FIELD("Line No."),
                                                          Posted = CONST(true)));
            Caption = 'Number Of Posted Outg.Pal.';
            Description = 'PAL,Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110473; "POI Qty. In Posted Outg. Pal."; Decimal)
        {
            CalcFormula = Sum ("POI Outgoing Pallet".Quantity WHERE("Document Type" = CONST("Transfer Order"),
                                                                 "Document No." = FIELD("Document No."),
                                                                 "Document Line No." = FIELD("Line No."),
                                                                 Posted = CONST(true)));
            Caption = 'Qty. In Posted Outg.Pal.';
            Description = 'PAL,Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110474; "POI Nb Of Not Posted Inc. Pal."; Integer)
        {
            CalcFormula = Count ("POI Incoming Pallet" WHERE("Document Type" = CONST("Transfer Order"),
                                                          "Document No." = FIELD("Document No."),
                                                          "Document Line No." = FIELD("Line No."),
                                                          Posted = CONST(false)));
            Caption = 'Number Of Not Posted Inc. Pal.';
            Description = 'PAL,Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110475; "POI Qty. In Not Post Inc. Pal."; Decimal)
        {
            CalcFormula = Sum ("POI Incoming Pallet".Quantity WHERE("Document Type" = CONST("Transfer Order"),
                                                                 "Document No." = FIELD("Document No."),
                                                                 "Document Line No." = FIELD("Line No."),
                                                                 Posted = CONST(false)));
            Caption = 'Qty. In Not Posted Inc. Pal.';
            Description = 'PAL,Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110476; "POI Number Of Posted Inc. Pal."; Integer)
        {
            CalcFormula = Count ("POI Incoming Pallet" WHERE("Document Type" = CONST("Transfer Order"),
                                                          "Document No." = FIELD("Document No."),
                                                          "Document Line No." = FIELD("Line No."),
                                                          Posted = CONST(true)));
            Caption = 'Number Of Posted Inc. Pal.';
            Description = 'PAL,Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110477; "POI Qty. In Posted Inc. Pal."; Decimal)
        {
            CalcFormula = Sum ("POI Incoming Pallet".Quantity WHERE("Document Type" = CONST("Transfer Order"),
                                                                 "Document No." = FIELD("Document No."),
                                                                 "Document Line No." = FIELD("Line No."),
                                                                 Posted = CONST(true)));
            Caption = 'Qty. In Posted Inc. Pal.';
            Description = 'PAL,Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110500; "POI Automatically Generated"; Boolean)
        {
            Caption = 'Automatically Generated';
            Description = 'SCA';
            Editable = false;
        }
        field(5110501; "POI Generation Type"; Option)
        {
            Caption = 'Generation Type';
            OptionCaption = ' ,New Item,Additional Quantity';
            OptionMembers = " ","New Item","Additional Quantity";
        }
        field(5110510; "POI Pack. Order No."; Code[20])
        {
            Caption = 'Pack.-Auftragsnr.';
            TableRelation = "POI Pack. Order Header"."No.";
        }
        field(5110511; "POI Attached to Line No."; Integer)
        {
            Caption = 'Attached to Line No.';
            Editable = false;
        }
        field(5110512; "POI Original Quantity"; Decimal)
        {
            Caption = 'Original Picking Quantity';
            Editable = false;
        }
        field(5110520; "POI Creat for Sales Doc. Type"; Option)
        {
            Caption = 'Created for Sales Doc. Type';
            Editable = false;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(5110521; "POI Created for Sales Doc. No."; Code[20])
        {
            Caption = 'Created for Sales Doc. No.';
            Editable = false;
        }
        field(5110523; "POI Created for Sales Line No."; Integer)
        {
            Caption = 'Created for Sales Line No.';
            Editable = false;
        }
    }

    keys
    {
        // key(Key5; "POI Batch Variant No.", "Item No.", "Derived From Line No.")
        // {
        //     SumIndexFields = "Outstanding Qty. (Base)", "Qty. in Transit (Base)";
        // }
        // key(Key6; "POI Batch Variant No.", "Item No.", "Transfer-from Code", "Derived From Line No.")
        // {
        //     SumIndexFields = "Outstanding Qty. (Base)", "Qty. in Transit (Base)";
        // }
        // key(Key7; "POI Batch Variant No.", "Item No.", "Transfer-to Code", "Derived From Line No.")
        // {
        //     SumIndexFields = "Outstanding Qty. (Base)", "Qty. in Transit (Base)";
        // }
        // key(Key8; "POI Batch Variant No.", "Derived From Line No.", "Shipment Date")
        // {
        //     SumIndexFields = "Outstanding Qty. (Base)", "Qty. in Transit (Base)";
        // }
        // key(Key9; "POI Batch Variant No.", "Derived From Line No.", "Receipt Date")
        // {
        //     SumIndexFields = "Outstanding Qty. (Base)", "Qty. in Transit (Base)";
        // }
        // key(Key10; "Item No.", "Batch Variant No.")
        // {
        // }
        // key(Key11; "Document No.", "Freight Unit of Measure")
        // {
        //     SumIndexFields = "POI Quantity (TU)";
        // }
        // key(Key12; "Transfer-from Code", "Batch Variant No.", "Derived From Line No.", "Shipment Date")
        // {
        //     SumIndexFields = "Outstanding Qty. (Base)";
        // }
        // key(Key13; "Transfer-to Code", "POI Batch Variant No.", "Derived From Line No.", "Receipt Date")
        // {
        //     SumIndexFields = "Outstanding Qty. (Base)", "Qty. in Transit (Base)";
        // }
    }



    trigger OnDelete()
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        lcu_BatchManagement: Codeunit "POI BAM Batch Management";
    begin
        // TestStatusOpen; //TODO: Teststatus Transfer line

        TESTFIELD("Quantity Shipped", "Quantity Received");
        TESTFIELD("Qty. Shipped (Base)", "Qty. Received (Base)");
        CALCFIELDS("Reserved Qty. Inbnd. (Base)", "Reserved Qty. Outbnd. (Base)");
        TESTFIELD("Reserved Qty. Inbnd. (Base)", 0);
        TESTFIELD("Reserved Qty. Outbnd. (Base)", 0);

        //RS 160205 Prüfung, ob in Belegen vorhanden
        IF (("Item No." <> '') AND ("POI Batch Variant No." <> '')) THEN
            IF "Qty. to Ship" <> 0 THEN
                IF lcu_BatchManagement.BatchVarCheckIfInOpenDoc("Item No.", "POI Batch Variant No.", 'TRANSFER') THEN
                    ERROR('Löschung nicht zulässig, Umlagerungszeile ist in offenene Belegen vorhanden');

        //ReserveTransferLine.DeleteLine(Rec); //TODO: Reservation line 
        WhseValidateSourceLine.TransLineDelete(Rec);

        ItemChargeAssgntPurch.SETCURRENTKEY(
          "Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type", ItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.", "Document No.");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.", "Line No.");
        ItemChargeAssgntPurch.DELETEALL(TRUE);

        //DimMgt.DeleteDocDim(DATABASE::"Transfer Line", DocDim."Document Type"::" ", "Document No.", "Line No."); //TODO: Dimension
    end;

    trigger OnInsert()
    begin
        //TestStatusOpen;
        TransLine2.RESET();
        TransLine2.SETFILTER("Document No.", TransHeader."No.");
        IF TransLine2.FIND('+') THEN
            "Line No." := TransLine2."Line No." + 10000;
        // ReserveTransferLine.VerifyQuantity(Rec, xRec); //TODO: dim
        // DimMgt.InsertDocDim(
        //   DATABASE::"Transfer Line", DocDim."Document Type"::" ", "Document No.", "Line No.",
        //   "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    trigger OnModify()
    begin
        //ReserveTransferLine.VerifyChange(Rec, xRec);
    end;

    trigger OnRename()
    begin
        ERROR(Text001Txt, TABLECAPTION());
    end;

    var
        Item: Record Item;
        TransHeader: Record "Transfer Header";
        //Location: Record Location;
        //DocDim: Record "357";
        //Bin: Record "Bin";
        //Reservation: Form "498";
        //DimMgt: Codeunit "408";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        //ReserveTransferLine: Codeunit "99000836";
        //CheckDateConflict: Codeunit "99000815";
        gbn_NotDeletePlanningLines: Boolean;
        gbn_CalledChanfromCreatFromPla: Boolean;
        gbn_IndirectCall: Boolean;
        gbn_KeepOriginalQuantity: Boolean;
        //AGILES_TEXT004Txt: Label 'Sie können die Menge nicht verändern ! Es sind bereits Mengen von  %1 x %2 in Frachtaufträgen enthalten !';
        Text001Txt: Label 'You cannot rename a %1.', Comment = '%1';
    // Text002Txt: Label 'must not be less than %1';
    // Text003Txt: Label 'Warehouse %1 is required for %2 = %3.';
    // Text004Txt: Label '\The entered information will be disregarded by warehouse operations.';
    // Text005Txt: Label 'You cannot ship more than %1 units.';
    // Text006Txt: Label 'All items have been shipped.';
    // Text008Txt: Label 'You cannot receive more than %1 units.';
    // Text009Txt: Label 'No items are currently in transit.';
    // Text010Txt: Label 'Change %1 from %2 to %3?';
    // Text011Txt: Label 'Outbound,Inbound';


    local procedure InitOutstandingQty()
    begin
        "Outstanding Quantity" := Quantity - "Quantity Shipped";
        "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Shipped (Base)";
        "Completely Shipped" := (Quantity <> 0) AND ("Outstanding Quantity" = 0);
    end;

    local procedure InitQtyToShip()
    begin
        "Qty. to Ship" := "Outstanding Quantity";
        "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
    end;

    local procedure InitQtyToReceive()
    begin
        "Qty. to Receive" := "Qty. in Transit";
        "Qty. to Receive (Base)" := "Qty. in Transit (Base)";
    end;

    local procedure InitQtyInTransit()
    begin
        "Qty. in Transit" := "Quantity Shipped" - "Quantity Received";
        "Qty. in Transit (Base)" := "Qty. Shipped (Base)" - "Qty. Received (Base)";
        "Completely Received" := ("Quantity Shipped" <> 0) AND ("Qty. in Transit" = 0);
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    local procedure GetTransHeader()
    begin
        TESTFIELD("Document No.");
        IF ("Document No." <> TransHeader."No.") THEN
            TransHeader.GET("Document No.");

        TransHeader.TESTFIELD("Shipment Date");
        TransHeader.TESTFIELD("Receipt Date");
        TransHeader.TESTFIELD("Transfer-from Code");
        TransHeader.TESTFIELD("Transfer-to Code");
        TransHeader.TESTFIELD("In-Transit Code");
        "In-Transit Code" := TransHeader."In-Transit Code";
        "Transfer-from Code" := TransHeader."Transfer-from Code";
        "Transfer-to Code" := TransHeader."Transfer-to Code";
        "Shipment Date" := TransHeader."Shipment Date";
        "Receipt Date" := TransHeader."Receipt Date";
        "Shipping Agent Code" := TransHeader."Shipping Agent Code";
        "Shipping Agent Service Code" := TransHeader."Shipping Agent Service Code";
        "Shipping Time" := TransHeader."Shipping Time";
        "Outbound Whse. Handling Time" := TransHeader."Outbound Whse. Handling Time";
        "Inbound Whse. Handling Time" := TransHeader."Inbound Whse. Handling Time";
        Status := TransHeader.Status;
    end;

    procedure ADF_RecOnDelete()
    var
        lrc_OutgoingPallet: Record "POI Outgoing Pallet";
    //lcu_PurchaseDispoMgt: Codeunit "5110380"; //TODO: purchase dispo
    begin
        // -----------------------------------------------------------------------------------------------------------
        //
        // -----------------------------------------------------------------------------------------------------------

        lrc_OutgoingPallet.RESET();
        lrc_OutgoingPallet.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.", Posted);
        lrc_OutgoingPallet.SETRANGE("Document Type", lrc_OutgoingPallet."Document Type"::"Transfer Order");
        lrc_OutgoingPallet.SETRANGE("Document No.", "Document No.");
        lrc_OutgoingPallet.SETRANGE("Document Line No.", "Line No.");
        lrc_OutgoingPallet.SETRANGE(Posted, FALSE);
        lrc_OutgoingPallet.DELETEALL(FALSE);

        // IF (gbn_NotDeletePlanningLines = FALSE) THEN
        //     lcu_PurchaseDispoMgt.RebuildDispolineOnTransferLine(Rec);
    end;

    procedure ADF_BatchValidate(vin_FieldNo: Integer)
    var
        lrc_Batch: Record "POI Batch";
        lrc_Item: Record Item;
        lco_BatchVariantNo: Code[20];
    //TEXT001Txt: Label 'Artikelnr. aus Positionsvariante abweichend !';

    begin
        // ----------------------------------------------------------------------------
        // Validate Fields: Master Batch No., Batch No, Batch Variant No.
        // ----------------------------------------------------------------------------

        TESTFIELD("Quantity Shipped", 0);

        CASE vin_FieldNo OF
            // Partienummer
            FIELDNO("POI Master Batch No."):
                IF "POI Master Batch No." = '' THEN BEGIN
                    "POI Batch No." := '';
                    "POI Batch Variant No." := '';
                    EXIT;
                END;

            // Positionsnummer
            FIELDNO("POI Batch No."):
                BEGIN

                    // Positionsvariante zurücksetzen
                    "POI Batch Variant No." := '';
                    // Keine Eingabe
                    IF "POI Batch No." = '' THEN
                        EXIT;

                    // Partie lesen und setzen
                    lrc_Batch.GET("POI Batch No.");
                    "POI Master Batch No." := lrc_Batch."Master Batch No.";

                    // Kontrolle ob es mehr als eine Positionsvariante gibt
                    lrc_BatchVariant.RESET();
                    lrc_BatchVariant.SETRANGE("Batch No.", "POI Batch No.");
                    IF lrc_BatchVariant.COUNT() = 1 THEN BEGIN
                        lrc_BatchVariant.FIND('-');
                        VALIDATE("POI Batch Variant No.", lrc_BatchVariant."No.");
                    END;

                END;

            // Positionsvariantennummer
            FIELDNO("POI Batch Variant No."):
                BEGIN

                    IF "Item No." <> '' THEN BEGIN
                        lrc_Item.GET("Item No.");
                        lrc_Item.TESTFIELD("POI Batch Item");
                    END;

                    // Keine Eingabe
                    IF "POI Batch Variant No." = '' THEN
                        EXIT;


                    // Batchvariante lesen
                    lrc_BatchVariant.GET("POI Batch Variant No.");

                    // Kontrolle Artikelnr. aus Zeile und Artikelnr. aus Batchvariante übereinstimmend
                    IF ("Item No." <> '') AND (lrc_BatchVariant."Item No." <> "Item No.") THEN
                        // Artikelnr. aus Positionsvariante abweichend!
                        ERROR(TEXT001Txt);

                    // Artikelnr. setzen
                    IF "Item No." = '' THEN BEGIN
                        "POI Master Batch No." := '';
                        "POI Batch No." := '';
                        lco_BatchVariantNo := "POI Batch Variant No.";
                        VALIDATE("Item No.", lrc_BatchVariant."Item No.");
                        "POI Batch Variant No." := lco_BatchVariantNo;
                    END;
                    VALIDATE("Unit of Measure Code", lrc_BatchVariant."Unit of Measure Code");

                    // Werte aus Positionsvariante in Zeile setzen
                    "POI Master Batch No." := lrc_BatchVariant."Master Batch No.";
                    "POI Batch No." := lrc_BatchVariant."Batch No.";

                    "Variant Code" := lrc_BatchVariant."Variant Code";
                    "POI Country of Origin Code" := lrc_BatchVariant."Country of Origin Code";
                    "POI Variety Code" := lrc_BatchVariant."Variety Code";
                    "POI Trademark Code" := lrc_BatchVariant."Trademark Code";
                    "POI Caliber Code" := lrc_BatchVariant."Caliber Code";
                    "POI Item Attribute 3" := lrc_BatchVariant."Item Attribute 3";
                    "POI Item Attribute 2" := lrc_BatchVariant."Item Attribute 2";
                    "POI Grade of Goods Code" := lrc_BatchVariant."Grade of Goods Code";
                    "POI Item Attribute 7" := lrc_BatchVariant."Item Attribute 7";
                    "POI Item Attribute 4" := lrc_BatchVariant."Item Attribute 4";
                    "POI Coding Code" := lrc_BatchVariant."Coding Code";
                    "POI Item Attribute 5" := lrc_BatchVariant."Item Attribute 5";
                    "POI Item Attribute 6" := lrc_BatchVariant."Item Attribute 6";
                    "POI Cultivation Type" := lrc_BatchVariant."Cultivation Type";

                    "POI Info 1" := lrc_BatchVariant."Info 1";
                    "POI Info 2" := lrc_BatchVariant."Info 2";
                    "POI Info 3" := lrc_BatchVariant."Info 3";
                    "POI Info 4" := lrc_BatchVariant."Info 4";

                    "POI Status Customs Duty" := lrc_BatchVariant."Status Customs Duty";

                    "POI Empties Item No." := lrc_BatchVariant."Empties Item No.";
                    "POI Empties Quantity" := lrc_BatchVariant."Empties Quantity";

                    "POI Trans Unit of Measure (TU)" := lrc_BatchVariant."Transport Unit of Measure (TU)";
                    VALIDATE("POI Trans Unit of Measure (TU)", lrc_BatchVariant."Transport Unit of Measure (TU)");

                    "POI Qty.(Unit) per Transp.(TU)" := lrc_BatchVariant."Qty. (Unit) per Transp. (TU)";

                END;

        END;
    end;

    procedure ADF_SetWeightValues()
    var
        lrc_UnitofMeasure: Record "Unit of Measure";
        lrc_Item: Record Item;
        ldc_GrossWeight: Decimal;
        ldc_NetWeight: Decimal;

    begin
        // ----------------------------------------------------------------------------------------------------------
        // Funktion zum Setzen der Gewichte
        // ----------------------------------------------------------------------------------------------------------

        ldc_GrossWeight := 0;
        ldc_NetWeight := 0;

        IF "Unit of Measure Code" <> '' THEN BEGIN

            lrc_UnitofMeasure.GET("Unit of Measure Code");
            lrc_ItemUnitofMeasure.RESET();
            lrc_ItemUnitofMeasure.SETRANGE("Item No.", "Item No.");
            lrc_ItemUnitofMeasure.SETRANGE(Code, "Unit of Measure Code");
            IF lrc_ItemUnitofMeasure.FIND('-') THEN BEGIN
                // Bruttogewicht
                IF lrc_ItemUnitofMeasure."POI Gross Weight" <> 0 THEN
                    ldc_GrossWeight := lrc_ItemUnitofMeasure."POI Gross Weight"
                ELSE
                    ldc_GrossWeight := lrc_UnitofMeasure."POI Gross Weight";
                // Nettogewicht
                IF lrc_ItemUnitofMeasure."POI Net Weight" <> 0 THEN
                    ldc_NetWeight := lrc_ItemUnitofMeasure."POI Net Weight"
                ELSE
                    ldc_NetWeight := lrc_UnitofMeasure."POI Net Weight";

            END ELSE BEGIN
                ldc_GrossWeight := lrc_UnitofMeasure."POI Gross Weight";
                ldc_NetWeight := lrc_UnitofMeasure."POI Net Weight";
            END;

        END ELSE BEGIN

            "Gross Weight" := 0;
            "Net Weight" := 0;
            "POI Total Gross Weight" := 0;
            "POI Total Net Weight" := 0;

            // Gewicht aus Artikelstamm setzen
            IF lrc_Item.GET("Item No.") THEN BEGIN
                ldc_GrossWeight := Item."Gross Weight" * "Qty. per Unit of Measure";
                ldc_NetWeight := Item."Net Weight" * "Qty. per Unit of Measure";
            END;

        END;

        VALIDATE("Gross Weight", ldc_GrossWeight);
        VALIDATE("Net Weight", ldc_NetWeight);
    end;

    procedure ADF_NotDeletePlanningLines(rbn_NotDeletePlanningLines: Boolean)
    begin
        gbn_NotDeletePlanningLines := rbn_NotDeletePlanningLines;
    end;

    procedure ADF_CalledFromCreatingPlanLine(rbn_CalledChanfromCreatFromPla: Boolean)
    begin
        gbn_CalledChanfromCreatFromPla := rbn_CalledChanfromCreatFromPla
    end;

    procedure ADF_CheckIncomingPallet(vco_PalletNo: Code[30]; vdc_Quantity: Decimal): Text[100]
    var
        AGILES_LT_TEXT001Txt: Label 'Incomming Pallet doesn''t exist';
        AGILES_LT_TEXT002Txt: Label 'Incoming Pallet is posted already';
        AGILES_LT_TEXT003Txt: Label 'The Quantity is wrong';
    begin
        // --------------------------------------------------------------------
        // Funktion prüft, ob die vorhandenen nicht gebuchten ausgehenden Paletten mit den Prüfparametern übereinstimmen
        // Es wird eine Fehlermeldung zurückgegeben bzw. eine leere Zeile, wenn alles stimmt
        // --------------------------------------------------------------------

        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.", "Pallet No.");
        lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Transfer Order");
        lrc_IncomingPallet.SETRANGE("Document No.", "Document No.");
        lrc_IncomingPallet.SETRANGE("Document Line No.", "Line No.");
        lrc_IncomingPallet.SETRANGE("Pallet No.", vco_PalletNo);
        IF NOT lrc_IncomingPallet.FIND('-') THEN
            EXIT(AGILES_LT_TEXT001Txt);

        IF lrc_IncomingPallet.Posted = TRUE THEN
            EXIT(AGILES_LT_TEXT002Txt);

        IF lrc_IncomingPallet."Qty. to Receive" <> vdc_Quantity THEN
            EXIT(AGILES_LT_TEXT003Txt);

        EXIT('');
    end;

    procedure ADF_CheckScanUser()
    var
        lrc_TransferHeader: Record "Transfer Header";
    begin
        IF GUIALLOWED() THEN BEGIN
            lrc_TransferHeader.GET("Document No.");
            IF lrc_TransferHeader."POI Scanner User ID" <> '' THEN
                lrc_TransferHeader.FIELDERROR("POI Scanner User ID");
        END;

    end;

    procedure ADF_QuantityValidate()
    var
    // lrc_PositionPlanningSetup: Record "5110488"; //TODO: planning
    // lcu_PurchaseDispoMgt: Codeunit "5110380";
    begin

        // IF NOT gbn_IndirectCall THEN
        //     IF lrc_PositionPlanningSetup.GET() THEN
        //         IF lrc_PositionPlanningSetup."Update Assigned Document Lines" THEN
        //             IF MODIFY(TRUE) THEN
        //                 lcu_PurchaseDispoMgt.UpdateAssignedLines(Rec, xRec, DATABASE::"Transfer Line", FIELDNO(Quantity));

        IF NOT gbn_KeepOriginalQuantity THEN
            "POI Original Quantity" := Quantity;
    end;

    procedure ADF_SetIndirectCall(vbn_IndirectCall: Boolean)
    begin
        // ------------------------------------------------------------------------------------------------------------
        // Globale Set-Funktion, die nur innerhalb der aktiven Variablen gilt. (Setzt sich bei Abbruch von Funktionen
        // automatisch wieder zurück, daher besser als SingleInstance)
        // ------------------------------------------------------------------------------------------------------------
        gbn_IndirectCall := vbn_IndirectCall;
    end;

    procedure ADF_SetKeepOriginalQuantity()
    begin
        gbn_KeepOriginalQuantity := TRUE;
    end;

    procedure ADF_GrossWeightValidate()
    begin
        // ---------------------------------------------------------------------------------
        // Funktion Trigger Validate Field "Gross Weight"
        // ---------------------------------------------------------------------------------
        "POI Total Gross Weight" := "Gross Weight" * Quantity;
    end;

    procedure ADF_NetWeightValidate()
    begin
        // ---------------------------------------------------------------------------------
        // Funktion Trigger Validate Field "Net Weight"
        // --------------------------------------------------------------------------------
        "POI Total Net Weight" := "Net Weight" * Quantity;
    end;

    var
        lrc_TransferLine: Record "Transfer Line";
        lrc_BatchVariant: Record "POI Batch Variant";
        TransLine2: Record "Transfer Line";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_IncomingPallet: Record "POI Incoming Pallet";
}

