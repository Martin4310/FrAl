table 5110716 "POI Pack. Order Input Costs"
{

    Caption = 'Pack. Order Input Costs';
    // DrillDownFormID = Form5110739;
    // LookupFormID = Form5110739;
    PasteIsValid = false;

    fields
    {
        field(1; "Doc. No."; Code[20])
        {
            Caption = 'Doc. No.';
        }
        field(2; "Doc. Line No. Output"; Integer)
        {
            Caption = 'Doc. Line No. Output';
            TableRelation = "POI Pack. Order Output Items"."Line No." WHERE("Doc. No." = FIELD("Doc. No."));
        }
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Cost Category,,,Resource';
            OptionMembers = "Cost Category",,,Resource;
        }
        field(11; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("Cost Category")) "POI Cost Category".Code WHERE("Allowed In Pack. Order" = CONST(true))
            ELSE
            IF (Type = CONST(Resource)) Resource."No.";

            trigger OnValidate()
            var
                lrc_CostCategory: Record "POI Cost Category";
                lrc_Resource: Record Resource;
            //lrc_ResourceGroup: Record "Resource Group";
            begin
                IF "No." = '' THEN BEGIN
                    Description := '';
                    "Description 2" := '';
                    "Allocation Price (LCY)" := 0;
                    EXIT;
                END;

                CASE Type OF
                    Type::"Cost Category":
                        BEGIN
                            lrc_CostCategory.GET("No.");
                            Description := lrc_CostCategory.Description;
                            "Description 2" := lrc_CostCategory."Description 2";
                        END;
                    Type::Resource:
                        BEGIN
                            lrc_Resource.GET("No.");
                            Description := lrc_Resource.Name;
                            "Description 2" := lrc_Resource."Name 2";
                            VALIDATE("Unit of Measure Code", lrc_Resource."Base Unit of Measure");
                            "Allocation Base Costs" := "Allocation Base Costs"::Amount;
                        END;
                END;
            end;
        }
        field(12; "Work Type Code"; Code[10])
        {
            Caption = 'Work Type Code';
            TableRelation = "Work Type";

            trigger OnValidate()
            var
                lrc_WorkType: Record "Work Type";
                lrc_Resource: Record "Resource";
            begin
                IF Type = Type::Resource THEN
                    IF "No." <> '' THEN BEGIN
                        IF lrc_WorkType.GET("Work Type Code") THEN
                            "Unit of Measure Code" := lrc_WorkType."Unit of Measure Code"
                        ELSE BEGIN
                            lrc_Resource.GET("No.");
                            "Unit of Measure Code" := lrc_Resource."Base Unit of Measure";
                        END;
                        FindResourceUnitCost();
                    END;
            end;
        }
        field(13; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(14; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(20; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Resource)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            IF (Type = CONST("Cost Category")) "Unit of Measure";

            trigger OnValidate()
            var
                lrc_Resource: Record Resource;
                lrc_ResUnitofMeasure: Record "Resource Unit of Measure";
            begin
                IF Type = Type::Resource THEN BEGIN
                    IF "Unit of Measure Code" = '' THEN BEGIN
                        lrc_Resource.GET("No.");
                        "Unit of Measure Code" := lrc_Resource."Base Unit of Measure"
                    END;
                    lrc_ResUnitofMeasure.GET("No.", "Unit of Measure Code");
                    "Qty. per Unit of Measure" := lrc_ResUnitofMeasure."Qty. per Unit of Measure";
                    FindResourceUnitCost();
                    VALIDATE(Quantity);
                END;
            end;
        }
        field(23; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            var
                SSPText01Txt: Label 'Menge darf nicht weniger als verbrauchte Menge sein !';
            begin
                IF (CurrFieldNo = FIELDNO(Quantity)) THEN
                    IF (Type = Type::Resource) THEN BEGIN
                        IF (Quantity * "Quantity Consumed" < 0) OR
                           (ABS(Quantity) < ABS("Quantity Consumed"))
                        THEN
                            // Menge darf nicht weniger als verbrauchte Menge sein!
                            ERROR(SSPText01Txt);
                        "Quantity to Consume" := Quantity - "Quantity Consumed";
                        "Remaining Quantity" := Quantity - "Quantity Consumed";
                        VALIDATE("Qty. per Unit of Measure");
                        VALIDATE("Allocation Price (LCY)");
                    END ELSE
                        ERROR('');
            end;
        }
        field(30; "Quantity to Consume"; Decimal)
        {
            Caption = 'Quantity to Consume';

            trigger OnValidate()
            var
                SSPText01Txt: Label 'Die zu verbrauchende Menge darf die Restmenge nicht übersteigen !';
            begin
                IF (("Quantity to Consume" * Quantity) < 0) OR
                   (ABS("Quantity to Consume") > ABS("Remaining Quantity")) OR
                   (Quantity * "Remaining Quantity" < 0) THEN
                    // Die zu verbrauchende Menge darf die Restmenge nicht übersteigen!
                    ERROR(SSPText01Txt);

                VALIDATE("Qty. per Unit of Measure");
            end;
        }
        field(31; "Quantity Consumed"; Decimal)
        {
            Caption = 'Quantity Consumed';
        }
        field(32; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
        }
        field(40; "Allocation Batch No."; Option)
        {
            Caption = 'Allocation Batch No.';
            Description = ' ,Verpackung,Palletten,Kolli,Nettogewicht,Bruttogewicht,Zeilen,Betrag';
            InitValue = "Net Weight";
            OptionCaption = ' ,Packing,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionMembers = " ",Packing,Pallets,Kolli,"Net Weight","Gross Weight",Lines,Amount;

            trigger OnValidate()
            begin
                TESTFIELD("Quantity Consumed", 0);
            end;
        }
        field(43; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
        }
        field(44; "Quantity to Consume (Base)"; Decimal)
        {
            Caption = 'Quantity to Consume (Base)';
        }
        field(45; "Quantity Consumed (Base)"; Decimal)
        {
            Caption = 'Quantity Consumed (Base)';
        }
        field(46; "Remaining Quantity (Base)"; Decimal)
        {
            Caption = 'Remaining Quantity (Base)';
        }
        field(47; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
                "Quantity to Consume (Base)" := "Quantity to Consume" * "Qty. per Unit of Measure";
                "Quantity Consumed (Base)" := "Quantity Consumed" * "Qty. per Unit of Measure";
                "Remaining Quantity (Base)" := "Remaining Quantity" * "Qty. per Unit of Measure";
            end;
        }
        field(50; "Allocation Price (LCY)"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Allocation Price (LCY)';

            trigger OnValidate()
            var
                //lcu_RecipePackingMgt: Codeunit "5110700";
                ldc_AmountLCY: Decimal;
                ldc_Quantity: Decimal;
            begin
                clear(ldc_AmountLCY);
                clear(ldc_Quantity);
                IF CurrFieldNo = FIELDNO("Allocation Price (LCY)") THEN BEGIN

                    // Betrag und Menge aufgrund der Bezugsgröße berechnen
                    //lcu_RecipePackingMgt.InputCostCalcAmount(Rec,ldc_AmountLCY,ldc_Quantity); //TODO: receipt

                    // Menge ist kleiner als die bereits verbrauchte Menge
                    IF ldc_Quantity < "Quantity Consumed" THEN
                        ERROR('');

                    // Mengen setzen und berechnen
                    Quantity := ldc_Quantity;
                    "Quantity to Consume" := Quantity - "Quantity Consumed";
                    "Remaining Quantity" := Quantity - "Quantity Consumed";

                    // Beträge setzen und berechnen
                    "Amount (LCY)" := ldc_AmountLCY;
                    "Calculated Costs (LCY)" := "Amount (LCY)";
                    IF "Posted Costs (LCY)" = 0 THEN
                        "Chargeable Costs (LCY)" := "Amount (LCY)"
                    ELSE
                        "Chargeable Costs (LCY)" := "Posted Costs (LCY)";
                END;
            end;
        }
        field(51; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(60; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(61; "Posting Time"; Time)
        {
            Caption = 'Posting Time';
        }
        field(100; "Allocation Base Costs"; Option)
        {
            Caption = 'Allocation Base Costs';
            Description = ' ,Verpackung,Palletten,Kolli,Nettogewicht,Bruttogewicht,Zeilen,Betrag';
            InitValue = Amount;
            OptionCaption = ' ,Packing,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionMembers = " ",Packing,Pallets,Kolli,"Net Weight","Gross Weight",Lines,Amount;

            trigger OnValidate()
            begin
                TESTFIELD("Quantity Consumed", 0);

                IF (Type = Type::Resource) THEN
                    TESTFIELD("Allocation Base Costs", "Allocation Base Costs"::Amount);

                "Allocation Batch No." := "Allocation Base Costs";

                VALIDATE("Allocation Price (LCY)");
            end;
        }
        field(102; "Calculated Costs (LCY)"; Decimal)
        {
            Caption = 'Calculated Costs (LCY)';
            Editable = false;
        }
        field(103; "Posted Costs (LCY)"; Decimal)
        {
            Caption = 'Posted Costs (LCY)';
            Editable = false;
        }
        field(104; "Chargeable Costs (LCY)"; Decimal)
        {
            Caption = 'Chargeable Costs (LCY)';

            trigger OnValidate()
            var
                lrc_PackOrderHeader: Record "POI Pack. Order Header";
            begin
                IF "Chargeable Costs (LCY)" <> 0 THEN BEGIN
                    lrc_PackOrderHeader.GET("Doc. No.");
                    lrc_PackOrderHeader.TESTFIELD("Cost Transfer", FALSE);
                END;
            end;
        }
        field(200; Comment; Boolean)
        {
            CalcFormula = Exist ("POI Pack. Order Comment" WHERE("Doc. No." = FIELD("Doc. No."),
                                                             Type = CONST("Input Cost"),
                                                             "Source Line No." = FIELD("Line No.")));
            Caption = 'Comment';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(210; "Resource Group No."; Code[20])
        {
            CalcFormula = Lookup (Resource."Resource Group No." WHERE("No." = FIELD("No.")));
            Caption = 'Resource Group No.';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Resource Group";
        }
        field(250; "Production Line Code"; Code[10])
        {
            Caption = 'Production Line Code';
            //TableRelation = "Production Lines".Code;

            trigger OnValidate()
            var
            //lcu_RecipePackingManagement: Codeunit "5110700";
            begin
                TESTFIELD("Quantity Consumed", 0);
                //lcu_RecipePackingManagement.CheckExistingPaProductionLine("Doc. No.","Production Line Code"); //TODO: receipt
            end;
        }
        field(401; "Date of Posting"; Date)
        {
            Caption = 'Date of Posting';
        }
        field(402; "Userid of Posting"; Code[20])
        {
            Caption = 'Userid of Posting';
        }
        field(50000; "Kosten auf Inputposition"; Boolean)
        {
        }
        field(50001; "Doc. Line No. Input"; Integer)
        {
            TableRelation = "POI Pack. Order Input Items"."Line No." WHERE("Doc. No." = FIELD("Doc. No."),
                                                                        Type = FILTER(Item),
                                                                        "Batch Variant No." = FILTER(<> ''));

            trigger OnValidate()
            var
                lrc_PackOrderInput: Record "POI Pack. Order Input Items";
            begin
                IF "Doc. Line No. Input" <> 0 THEN BEGIN
                    lrc_PackOrderInput.GET("Doc. No.", 0, "Doc. Line No. Input");
                    "Batch Variant No. Input" := lrc_PackOrderInput."Batch Variant No.";
                END ELSE
                    "Batch Variant No. Input" := '';
            end;
        }
        field(50002; "Batch Variant No. Input"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Doc. No.", "Doc. Line No. Output", "Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Quantity, "Quantity (Base)", "Remaining Quantity", "Remaining Quantity (Base)", "Calculated Costs (LCY)", "Posted Costs (LCY)", "Chargeable Costs (LCY)", "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_PackOrderComment: Record "POI Pack. Order Comment";
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");

        lrc_PackOrderComment.RESET();
        lrc_PackOrderComment.SETRANGE("Doc. No.", "Doc. No.");
        lrc_PackOrderComment.SETRANGE("Doc. Line No. Output", 0);
        lrc_PackOrderComment.SETRANGE(Type, lrc_PackOrderComment.Type::"Input Cost");
        lrc_PackOrderComment.SETRANGE("Source Line No.", "Line No.");
        IF lrc_PackOrderComment.FIND('-') THEN
            lrc_PackOrderComment.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");

        TESTFIELD("Doc. No.");
        lrc_PackOrderHeader.GET("Doc. No.");

        IF "Line No." = 0 THEN BEGIN
            lrc_PackOrderInputCosts.SETRANGE("Doc. No.", "Doc. No.");
            IF lrc_PackOrderInputCosts.FIND('+') THEN
                "Line No." := lrc_PackOrderInputCosts."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        // IF "Production Line Code" = '' THEN
        //     "Production Line Code" := lrc_PackOrderHeader."Production Line Code"

    end;

    trigger OnModify()

    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;

    trigger OnRename()

    begin
        lrc_PackOrderHeader.TestPackOrderHeaderOpen("Doc. No.");
    end;

    local procedure FindResourceUnitCost()
    var
        lrc_ResourceCost: Record "Resource Cost";
        lcu_ResFindUnitCost: Codeunit "Resource-Find Cost";
    begin
        lrc_ResourceCost.INIT();
        lrc_ResourceCost.Code := "No.";
        lrc_ResourceCost."Work Type Code" := "Work Type Code";
        lcu_ResFindUnitCost.RUN(lrc_ResourceCost);
        VALIDATE("Allocation Price (LCY)", lrc_ResourceCost."Direct Unit Cost" * "Qty. per Unit of Measure");
    end;

    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        lrc_PackOrderInputCosts: Record "POI Pack. Order Input Costs";
}

