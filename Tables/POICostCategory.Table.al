table 50021 "POI Cost Category"
{
    Caption = 'Cost Category';
    //DrillDownFormID = Form5087940;
    //LookupFormID = Form5087940;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                "Search Description" := Description;
            end;
        }
        field(11; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(12; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
            DataClassification = CustomerContent;
        }
        field(14; Comment; Text[100])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(19; "Cost Detail Source"; Integer)
        {
            Caption = 'Kostenherkunft Detail';
            DataClassification = CustomerContent;
        }
        field(20; "Cost Global Source"; Option)
        {
            Caption = 'Cost Global Source';
            DataClassification = CustomerContent;
            Description = ' ,Sales,Purchase,Transfer,Packing,Production,Location,Other';
            OptionCaption = ' ,Sales,Purchase,Transfer,Packing,Production,Location,Other';
            OptionMembers = " ",Sales,Purchase,Transfer,Packing,Production,Location,Other;
        }
        field(21; "Cost Type General"; Option)
        {
            Caption = 'Cost Type General';
            DataClassification = CustomerContent;
            Description = ' ,External Cost,,Internal Cost,,Provision,Commission';
            OptionCaption = ' ,External Cost,,Internal Cost,,Provision,Commission';
            OptionMembers = " ","External Cost",,"Internal Cost",,Provision,Commission;
        }
        field(22; "Cost Subgroup"; Option)
        {
            Caption = 'Cost Subgroup';
            DataClassification = CustomerContent;
            Description = ' ,Direct Sales Freight Cost,Indirect Sales Freight Cost,Sales Freight Cost Total,Transfer Freight Cost,Manual Freight Cost';
            OptionCaption = ' ,Direct Sales Freight Cost,Indirect Sales Freight Cost,Sales Freight Cost Total,Transfer Freight Cost,Manual Freight Cost';
            OptionMembers = " ","Direct Sales Freight Cost","Indirect Sales Freight Cost","Sales Freight Cost Total","Transfer Freight Cost","Manual Freight Cost";
        }
        field(23; "Cost Group"; Option)
        {
            Caption = 'Cost Group';
            DataClassification = CustomerContent;
            Description = ' ,Sales Freight Cost,Sorting Cost';
            OptionCaption = ' ,Sales Freight Cost,Sorting Cost';
            OptionMembers = " ","Sales Freight Cost","Sorting Cost";
        }
        field(25; "Qty. (Cost Inv.) Refered to"; Option)
        {
            Caption = 'Qty. (Cost Inv.) Refered to';
            DataClassification = CustomerContent;
            Description = ' ,Pallet,Collo,Net Weight,Gross Weight';
            OptionCaption = ' ,Pallet,Collo,Net Weight,Gross Weight';
            OptionMembers = " ",Pallet,Collo,"Net Weight","Gross Weight";
        }
        field(48; "Cost Allocation"; Option)
        {
            Caption = 'Cost Allocation';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Direct Purchase Cost,,,,,Indirect Purchase Cost';
            OptionMembers = " ","Direct Purchase Cost",,,,,"Indirect Purchase Cost";
        }
        field(50; "Direct Cost (Purchase)"; Boolean)
        {
            Caption = 'Direct Cost (Purchase)';
            DataClassification = CustomerContent;
            Description = 'Einkauf Warenkosten';
        }
        field(52; "Load in Split Posting"; Boolean)
        {
            Caption = 'Load in Split Posting';
            DataClassification = CustomerContent;
        }
        field(53; "Belongs to CIF Cost"; Boolean)
        {
            Caption = 'Belongs to CIF Cost';
            DataClassification = CustomerContent;
        }
        field(54; "Allowed In Pack. Order"; Boolean)
        {
            Caption = 'Allowed In Pack. Order';
            DataClassification = CustomerContent;
        }
        field(55; "Calculate in Account Sales"; Boolean)
        {
            Caption = 'Calculate in Account Sales';
            DataClassification = CustomerContent;
        }
        field(56; "Pack. Order Cost Controle"; Option)
        {
            Caption = 'Pack. Order Cost Controle';
            DataClassification = CustomerContent;
            Description = ' ,Packing Cost,Freight Cost';
            OptionCaption = ' ,Packing Cost,Freight Cost';
            OptionMembers = " ","Packing Cost","Freight Cost";
        }
        field(57; "Reduce Cost from Turnover"; Boolean)
        {
            Caption = 'Reduce Cost from Turnover';
            DataClassification = CustomerContent;

            trigger OnValidate()

            begin
                // Werte in Kostenschemazeilen aktualisieren
                lrc_CostSchemaLine.RESET();
                lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
                lrc_CostSchemaLine.SETRANGE(Totaling, Code);
                IF lrc_CostSchemaLine.FINDSET(TRUE, FALSE) THEN
                    REPEAT
                        lrc_CostSchemaLine."Reduce Cost from Turnover" := "Reduce Cost from Turnover";
                        lrc_CostSchemaLine.MODIFY(TRUE);
                    UNTIL lrc_CostSchemaLine.NEXT() = 0;
            end;
        }
        field(58; "Post Not Imputed Cost"; Boolean)
        {
            Caption = 'Post Not Imputed Cost';
            DataClassification = CustomerContent;
        }
        field(59; "Indirect Cost (Purchase)"; Boolean)
        {
            Caption = 'Indirect Cost (Purchase)';
            DataClassification = CustomerContent;
            Description = 'Einkauf Warennebenkosten';
        }
        field(60; "Allocation Type"; Option)
        {
            Caption = 'Allocation Type';
            DataClassification = CustomerContent;
            Description = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionCaption = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount,Qty. Cost Inv. - Cr.Memo';
            OptionMembers = " ",Pallets,Kolli,"Net Weight","Gross Weight",Lines,Amount,"Qty. Cost Inv. - Cr.Memo";

            trigger OnValidate()
            begin
                // Werte in Kostenschemazeilen aktualisieren
                lrc_CostSchemaLine.RESET();
                lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
                lrc_CostSchemaLine.SETRANGE(Totaling, Code);
                IF lrc_CostSchemaLine.FINDSET(TRUE, FALSE) THEN
                    REPEAT
                        lrc_CostSchemaLine."Allocation Type" := "Allocation Type";
                        lrc_CostSchemaLine.MODIFY(TRUE);
                    UNTIL lrc_CostSchemaLine.NEXT() = 0;
            end;
        }
        field(65; "Allowed in Sales Claim Notify"; Boolean)
        {
            Caption = 'Allowed in Sales Claim Notify';
            DataClassification = CustomerContent;
        }
        field(66; "Allowed in Purch. Claim Notify"; Boolean)
        {
            Caption = 'Allowed in Purch. Claim Notify';
            DataClassification = CustomerContent;
        }
        field(75; "No. of G/L Accounts"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("POI Cost Category Accounts" WHERE("Cost Category Code" = FIELD(Code)));
            Caption = 'No. of G/L Accounts';
            Editable = false;
        }
        field(76; "No. of Cost Schema Entries"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count ("POI Cost Schema Line" WHERE("Totaling Type" = CONST("Cost Category"),
                                                          Totaling = FIELD(Code)));
            Caption = 'No. of Cost Schema Entries';
            Editable = false;

        }
        field(79; "Sorting in Acc. Sales"; Integer)
        {
            Caption = 'Sorting in Acc. Sales';
            DataClassification = CustomerContent;

            trigger OnValidate()

            begin
                // Werte in Kostenschemazeilen aktualisieren
                lrc_CostSchemaLine.RESET();
                lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
                lrc_CostSchemaLine.SETRANGE(Totaling, Code);
                IF lrc_CostSchemaLine.FINDSET(TRUE, FALSE) THEN
                    REPEAT
                        lrc_CostSchemaLine."Sorting in Acc. Sales" := "Sorting in Acc. Sales";
                        lrc_CostSchemaLine.MODIFY(TRUE);
                    UNTIL lrc_CostSchemaLine.NEXT() = 0;
            end;
        }
        field(80; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(200; "Default Amt. (LCY) Enter Data"; Decimal)
        {
            Caption = 'Default Amt. (LCY) Enter Data';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; "Search Description")
        {
        }
        key(Key3; "Sorting in Acc. Sales")
        {
        }
        key(Key4; Comment, "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var

    //     lrc_CostCategoryAccounts: Record "Cost Category Accounts";
    //     lrc_RecipeInputCost: Record "5110705";
    //     lrc_Erzeugerabrechnung: Record "5110501";
    //     lrc_PackOrderInputCosts: Record "5110716";
    begin
        //ERROR('Sie dürfen die Kostenkategorie nicht löschen, bitte an den Admin wenden');

        // Prüfung ob Kostenkategorie in Sachposten vorhanden ist
        // Prüfung ob Kostenkategorie als Dimensionswert angelegt ist
        lrc_CostSchemaLine.reset();
        lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
        lrc_CostSchemaLine.SETRANGE(Totaling, Code);
        IF NOT lrc_CostSchemaLine.ISEMPTY() THEN
            // Kostenkategorie ist im Kostenschema %1 vorhanden! Löschung nicht zulässig.
            ERROR(AGILES_TEXT001Txt, Code, lrc_CostSchemaLine."Cost Schema Code");

        //     lrc_PackOrderInputCosts.Reset();
        //     lrc_PackOrderInputCosts.SETRANGE(Type, lrc_PackOrderInputCosts.Type::"Cost Category");
        //     lrc_PackOrderInputCosts.SETRANGE("No.", Code);
        //     IF NOT lrc_PackOrderInputCosts.isempty()THEN
        //         // Kostenkategorie ist im Packereiauftrag %1 vorhanden! Löschung nicht zulässig.
        //         ERROR(AGILES_TEXT002Txt, Code, lrc_PackOrderInputCosts."Doc. No.");

        //     lrc_RecipeInputCost.Reset();
        //     lrc_RecipeInputCost.SETCURRENTKEY(Type, "No.");
        //     lrc_RecipeInputCost.SETRANGE(Type, lrc_RecipeInputCost.Type::"Cost Category");
        //     lrc_RecipeInputCost.SETRANGE("No.", Code);
        //     IF lrc_RecipeInputCost.FIND('-') THEN
        //         lrc_RecipeInputCost.DELETEALL(TRUE);

        //     lrc_Erzeugerabrechnung.Reset();
        //     lrc_Erzeugerabrechnung.SETRANGE("Cost Category Code", Code);
        //     IF NOT lrc_Erzeugerabrechnung.ISEMPTY() THEN
        //         lrc_Erzeugerabrechnung.DELETEALL(TRUE);

        //     // Zugehörige Sachkonten löschen
        //     lrc_CostCategoryAccounts.RESET();
        //     lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", Code);
        //     lrc_CostCategoryAccounts.DELETEALL();
    end;

    trigger OnInsert()
    begin
        //RS Anlage DimensionsCode Kostenkategorie
        lrc_DimensionValue.SETFILTER("Dimension Code", 'KOSTEN');
        lrc_DimensionValue.SETRANGE(Code, Code);
        IF NOT lrc_DimensionValue.FINDSET() THEN BEGIN
            lrc_DimensionValue.RESET();
            lrc_DimensionValue.INIT();
            lrc_DimensionValue."Dimension Code" := 'KOSTEN';
            lrc_DimensionValue.Code := Code;
            lrc_DimensionValue.Name := Description;
            lrc_DimensionValue.INSERT(TRUE);

            //Dimension Kostenkategorie setzen
            lrc_DimensionValue."Global Dimension No." := 4;

            lrc_DimensionValue.MODIFY(TRUE);
        END;
    end;

    trigger OnRename()
    begin
        ERROR('Sie dürfen die Kostenkategorie nicht umbenennen, bitte an den Admin wenden');
    end;

    var
        lrc_CostSchemaLine: Record "POI Cost Schema Line";
        lrc_DimensionValue: Record "Dimension Value";
        AGILES_TEXT001Txt: Label 'Kostenkategorie %1 ist im Kostenschema %2 vorhanden! Löschung nicht zulässig.', Comment = '%1 %2';
    //AGILES_TEXT002Txt: Label 'Kostenkategorie %1 ist im Packereiauftrag %2 vorhanden! Löschung nicht zulässig.';
}

