table 50023 "POI Cost Schema Line"
{
    Caption = 'Cost Schema Line';
    //DrillDownFormID = Form5087945;
    //LookupFormID = Form5087945;

    fields
    {
        field(1; "Cost Schema Code"; Code[10])
        {
            Caption = 'Cost Schema Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Schema Name";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(10; "Row No."; Code[20])
        {
            Caption = 'Row No.';
            DataClassification = CustomerContent;
        }
        field(11; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(18; "Totaling Type"; Option)
        {
            Caption = 'Totaling Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Cost Category,Filter Cost Category,,Formel';
            OptionMembers = " ","Cost Category","Filter Cost Category",,Formel;
        }
        field(20; Totaling; Code[80])
        {
            Caption = 'Totaling';
            DataClassification = CustomerContent;
            TableRelation = IF ("Totaling Type" = CONST("Cost Category")) "POI Cost Category"
            ELSE
            IF ("Totaling Type" = CONST("Filter Cost Category")) "POI Cost Category";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_CostCategory: Record "POI Cost Category";
            begin
                CASE "Totaling Type" OF
                    "Totaling Type"::" ":
                        BEGIN
                            Totaling := '';
                            Description := '';
                            "Sorting in Acc. Sales" := 0;
                            "Reduce Cost from Turnover" := FALSE;
                            "Calculate in Account Sales" := FALSE;
                            "Default Amt. (LCY) Enter Data" := 0;
                            "Allocation Type" := 0;
                        END;
                    "Totaling Type"::"Cost Category":
                        BEGIN
                            // Werte zurücksetzen
                            Description := '';
                            "Sorting in Acc. Sales" := 0;
                            "Reduce Cost from Turnover" := FALSE;
                            "Calculate in Account Sales" := FALSE;
                            "Default Amt. (LCY) Enter Data" := 0;
                            "Allocation Type" := 0;

                            // Wert wenn vohanden lesen und setzen
                            IF Totaling <> '' THEN BEGIN
                                lrc_CostCategory.GET(Totaling);
                                IF lrc_CostCategory."Reduce Cost from Turnover" = TRUE THEN
                                    ERROR('Kostenkategorie %1 wird vom Umsatz abgezogen! Nicht zulässig als Eintrag.', lrc_CostCategory.Code);
                                Description := lrc_CostCategory.Description;
                                "Sorting in Acc. Sales" := lrc_CostCategory."Sorting in Acc. Sales";
                                "Reduce Cost from Turnover" := lrc_CostCategory."Reduce Cost from Turnover";
                                "Calculate in Account Sales" := lrc_CostCategory."Calculate in Account Sales";
                                "Default Amt. (LCY) Enter Data" := lrc_CostCategory."Default Amt. (LCY) Enter Data";
                                "Allocation Type" := lrc_CostCategory."Allocation Type";
                            END;
                        END;
                    "Totaling Type"::"Filter Cost Category":

                        ERROR('Eintrag nicht zulässig!');

                    "Totaling Type"::Formel:
                        BEGIN
                            Totaling := UPPERCASE(Totaling);
                            CheckFormula(Totaling);
                        END;
                END;
            end;
        }
        field(25; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(28; "Reverse Sign"; Boolean)
        {
            Caption = 'Reverse Sign';
            DataClassification = CustomerContent;
        }
        field(48; "Sorting in Acc. Sales"; Integer)
        {
            Caption = 'Sorting in Acc. Sales';
            DataClassification = CustomerContent;
        }
        field(50; "Sorting in Sales Clearance"; Integer)
        {
            Caption = 'Sorting in Sales Clearance';
            DataClassification = CustomerContent;
            Description = 'ZVM';
        }
        field(51; "Cost Type in Sales Clearance"; Option)
        {
            Caption = 'Cost Type in Sales Clearance';
            DataClassification = CustomerContent;
            Description = 'ZVM';
            OptionCaption = 'Costs,Advanced Payment,Commission,Weight Costs,Duty Temporary';
            OptionMembers = Costs,"Advanced Payment",Commission,"Weight Costs","Duty Temporary";
        }
        field(52; "Commission % Sales Clearance"; Decimal)
        {
            Caption = 'Kommission % Sales Clearance';
            DataClassification = CustomerContent;
            Description = 'ZVM';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                TESTFIELD("Cost Type in Sales Clearance", "Cost Type in Sales Clearance"::Commission);
            end;
        }
        field(53; "Duty Temp. % Sales Clearance"; Decimal)
        {
            Caption = 'Duty Temporary % Sales Clearance';
            DataClassification = CustomerContent;
            Description = 'ZVM';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                TESTFIELD("Cost Type in Sales Clearance", "Cost Type in Sales Clearance"::"Duty Temporary");
            end;
        }
        field(54; "Kg Weight(LCY) Sales Clearance"; Decimal)
        {
            Caption = 'Weight Value (LCY) per 100 Kg Sales Clearance';
            DataClassification = CustomerContent;
            Description = 'ZVM';
            MinValue = 0;

            trigger OnValidate()
            begin
                TESTFIELD("Cost Type in Sales Clearance", "Cost Type in Sales Clearance"::"Weight Costs");
            end;
        }
        field(57; "Reduce Cost from Turnover"; Boolean)
        {
            Caption = 'Reduce Cost from Turnover';
            DataClassification = CustomerContent;
        }
        field(58; Show; Option)
        {
            Caption = 'Show';
            DataClassification = CustomerContent;
            OptionCaption = 'Yes,No,If Any Column Not Zero';
            OptionMembers = Yes,No,"If Any Column Not Zero";
        }
        field(60; "New Page"; Boolean)
        {
            Caption = 'New Page';
            DataClassification = CustomerContent;
        }
        field(61; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(62; "Dimension 1 Filter"; Code[20])
        {
            CaptionClass = GetCaptionClass(1);
            Caption = 'Dimension 1 Filter';
            FieldClass = FlowFilter;
        }
        field(63; "Dimension 2 Filter"; Code[20])
        {
            CaptionClass = GetCaptionClass(2);
            Caption = 'Dimension 2 Filter';
            FieldClass = FlowFilter;
        }
        field(65; "Dimension 3 Filter"; Code[20])
        {
            CaptionClass = GetCaptionClass(3);
            Caption = 'Dimension 3 Filter';
            FieldClass = FlowFilter;
        }
        field(66; "Dimension 4 Filter"; Code[20])
        {
            CaptionClass = GetCaptionClass(4);
            Caption = 'Dimension 4 Filter';
            FieldClass = FlowFilter;
        }
        field(67; "Dimension 1 Totaling"; Text[80])
        {
            CaptionClass = GetCaptionClass(5);
            Caption = 'Dimension 1 Totaling';
            DataClassification = CustomerContent;
        }
        field(68; "Dimension 2 Totaling"; Text[80])
        {
            CaptionClass = GetCaptionClass(6);
            Caption = 'Dimension 2 Totaling';
            DataClassification = CustomerContent;
        }
        field(69; "Dimension 3 Totaling"; Text[80])
        {
            CaptionClass = GetCaptionClass(7);
            Caption = 'Dimension 3 Totaling';
            DataClassification = CustomerContent;
        }
        field(70; "Dimension 4 Totaling"; Text[80])
        {
            CaptionClass = GetCaptionClass(8);
            Caption = 'Dimension 4 Totaling';
            DataClassification = CustomerContent;
        }
        field(71; Bold; Boolean)
        {
            Caption = 'Bold';
            DataClassification = CustomerContent;
        }
        field(72; Italic; Boolean)
        {
            Caption = 'Italic';
            DataClassification = CustomerContent;
        }
        field(73; Underline; Boolean)
        {
            Caption = 'Underline';
            DataClassification = CustomerContent;
        }
        field(74; "Show Opposite Sign"; Boolean)
        {
            Caption = 'Show Opposite Sign';
            DataClassification = CustomerContent;
        }
        field(80; "FREI 80"; Integer)
        {
            Caption = 'FREI 80';
            DataClassification = CustomerContent;
            Editable = false;
            Enabled = false;
        }
        field(81; "FREI 81"; Integer)
        {
            Caption = 'FREI 81';
            DataClassification = CustomerContent;
            Editable = false;
            Enabled = false;
        }
        field(85; "Calculate in Account Sales"; Boolean)
        {
            Caption = 'Calculate in Account Sales';
            DataClassification = CustomerContent;
        }
        field(87; "Expecting Costs"; Option)
        {
            Caption = 'Expecting Costs';
            DataClassification = CustomerContent;
            Description = ' ,Low,Middle,High,Sure';
            OptionCaption = ' ,Low,Middle,High,Sure';
            OptionMembers = " ",Low,Middle,High,Sure;
        }
        field(90; "Cost Global Source"; Option)
        {
            Caption = 'Cost Global Source';
            DataClassification = CustomerContent;
            Description = ' ,Sales,Purchase,Transfer,Packing,,,Other';
            OptionCaption = ' ,Sales,Purchase,Transfer,Packing,Production,Location,Other';
            OptionMembers = " ",Sales,Purchase,Transfer,Packing,Production,Location,Other;
        }
        field(91; "Cost Type General"; Option)
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
            Description = ' ,Kosten Extern,,Kosten Intern,,Provision,Kommission';
            OptionCaption = ' ,External Cost,,Internal Cost,,Provision,Commission';
            OptionMembers = " ","External Cost",,"Internal Cost",,Provision,Commission;
        }
        field(92; "Cost Subgroup"; Option)
        {
            Caption = 'Type of Freight Costs';
            DataClassification = CustomerContent;
            Description = ' ,Direkte Vk Fracht,Indirekte Vk Fracht,Vk Fracht Gesamt,Umlagerungsfracht,Manuelle Frachten';
            OptionCaption = ' ,Direct Sales Freight Cost,Indirect Sales Freight Cost,Sales Freight Cost Total,Transfer Freight Cost,Manual Freight Cost';
            OptionMembers = " ","Direct Sales Freight Cost","Indirect Sales Freight Cost","Sales Freight Cost Total","Transfer Freight Cost","Manual Freight Cost";
        }
        field(93; "Cost Group"; Option)
        {
            Caption = 'Type of Costs';
            DataClassification = CustomerContent;
            Description = ' ,Vk Frachtkosten,Sortierkosten';
            OptionCaption = ' ,Sales Freight Cost,Sorting Cost';
            OptionMembers = " ","Sales Freight Cost","Sorting Cost";
        }
        field(94; "Allocation Type"; Option)
        {
            Caption = 'Allocation Type';
            DataClassification = CustomerContent;
            Description = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionCaption = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount,Qty. Cost Inv. - Cr.Memo';
            OptionMembers = " ",Pallets,Kolli,"Net Weight","Gross Weight",Lines,Amount,"Qty. Cost Inv. - Cr.Memo";
        }
        field(100; "Splitt Type"; Option)
        {
            Caption = 'Splitt Type';
            DataClassification = CustomerContent;
            Description = ' ,Item Category';
            OptionCaption = ' ,Item Category';
            OptionMembers = " ","Item Category";
        }
        field(200; "Default Amt. (LCY) Enter Data"; Decimal)
        {
            Caption = 'Default Amount (LCY) Enter Data';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
        }
    }

    keys
    {
        key(Key1; "Cost Schema Code", "Line No.")
        {
        }
        key(Key2; "Cost Schema Code", "Totaling Type", Totaling)
        {
        }
        key(Key3; "Sorting in Acc. Sales")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        Fct_OnModify();
    end;

    var
        Text001Txt: Label 'The parenthesis at position %1 is misplaced.', Comment = '%1';
        Text002Txt: Label 'You cannot have two consecutive operators. The error occurred at position %1.', Comment = '%1';
        Text003Txt: Label 'There is an operand missing after position %1.', Comment = '%1';
        Text004Txt: Label 'There are more left parentheses than right parentheses.';
        Text005Txt: Label 'There are more right parentheses than left parentheses.';
        Text006Txt: Label '1,6,,Dimension 1 Filter';
        Text007Txt: Label '1,6,,Dimension 2 Filter';
        Text008Txt: Label '1,6,,Dimension 3 Filter';
        Text009Txt: Label '1,6,,Dimension 4 Filter';
        Text010Txt: Label ',, Totaling';
        Text011Txt: Label '1,5,,Dimension 1 Totaling';
        Text012Txt: Label '1,5,,Dimension 2 Totaling';
        Text013Txt: Label '1,5,,Dimension 3 Totaling';
        Text014Txt: Label '1,5,,Dimension 4 Totaling';

    procedure Fct_OnModify()
    begin
        IF lrc_CostSchemaName.GET("Cost Schema Code") THEN BEGIN
            lrc_CostSchemaName."Last Date/Time Modified" := CREATEDATETIME(TODAY(), TIME());
            lrc_CostSchemaName."Last Modification by User ID" := CopyStr(USERID(), 1, 20);
            lrc_CostSchemaName.Released := FALSE;
            lrc_CostSchemaName.MODIFY();
        END;
    end;

    procedure CheckFormula(Formula: Code[80])
    var
        i: Integer;
        ParenthesesLevel: Integer;
        HasOperator: Boolean;
    begin
        ParenthesesLevel := 0;
        FOR i := 1 TO STRLEN(Formula) DO BEGIN
            IF Formula[i] = '(' THEN
                ParenthesesLevel := ParenthesesLevel + 1
            ELSE
                IF Formula[i] = ')' THEN
                    ParenthesesLevel := ParenthesesLevel - 1;
            IF ParenthesesLevel < 0 THEN
                ERROR(Text001Txt, i);
            IF Formula[i] IN ['+', '-', '*', '/', '^'] THEN BEGIN
                IF HasOperator THEN
                    ERROR(Text002Txt, i)
                ELSE
                    HasOperator := TRUE;
                IF i = STRLEN(Formula) THEN
                    ERROR(Text003Txt, i)
                ELSE
                    IF Formula[i + 1] = ')' THEN
                        ERROR(Text003Txt, i);
            END ELSE
                HasOperator := FALSE;
        END;
        IF ParenthesesLevel > 0 THEN
            ERROR(Text004Txt)
        ELSE
            IF ParenthesesLevel < 0 THEN
                ERROR(Text005Txt);
    end;

    procedure GetCaptionClass(AnalysisViewDimType: Integer): Text[250]
    var
        lrc_GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        lrc_GeneralLedgerSetup.GET();
        CASE AnalysisViewDimType OF
            1:
                IF lrc_GeneralLedgerSetup."Global Dimension 1 Code" <> '' THEN
                    EXIT('1,6,' + lrc_GeneralLedgerSetup."Global Dimension 1 Code")
                ELSE
                    EXIT(Text006Txt);
            2:
                IF lrc_GeneralLedgerSetup."Global Dimension 2 Code" <> '' THEN
                    EXIT('1,6,' + lrc_GeneralLedgerSetup."Global Dimension 2 Code")
                ELSE
                    EXIT(Text007Txt);
            3:
                IF lrc_GeneralLedgerSetup."POI Global Dimension 3 Code" <> '' THEN
                    EXIT('1,6,' + lrc_GeneralLedgerSetup."POI Global Dimension 3 Code")
                ELSE
                    EXIT(Text008Txt);
            4:
                IF lrc_GeneralLedgerSetup."POI Global Dimension 4 Code" <> '' THEN
                    EXIT('1,6,' + lrc_GeneralLedgerSetup."POI Global Dimension 4 Code")
                ELSE
                    EXIT(Text009Txt);
            5:
                IF lrc_GeneralLedgerSetup."Global Dimension 1 Code" <> '' THEN
                    EXIT('1,5,' + lrc_GeneralLedgerSetup."Global Dimension 1 Code" + Text010Txt)
                ELSE
                    EXIT(Text011Txt);
            6:
                IF lrc_GeneralLedgerSetup."Global Dimension 2 Code" <> '' THEN
                    EXIT('1,5,' + lrc_GeneralLedgerSetup."Global Dimension 2 Code" + Text010Txt)
                ELSE
                    EXIT(Text012Txt);
            7:
                IF lrc_GeneralLedgerSetup."POI Global Dimension 3 Code" <> '' THEN
                    EXIT('1,5,' + lrc_GeneralLedgerSetup."POI Global Dimension 3 Code" + Text010Txt)
                ELSE
                    EXIT(Text013Txt);
            8:
                IF lrc_GeneralLedgerSetup."POI Global Dimension 4 Code" <> '' THEN
                    EXIT('1,5,' + lrc_GeneralLedgerSetup."POI Global Dimension 4 Code" + Text010Txt)
                ELSE
                    EXIT(Text014Txt);
        END;
    end;

    var
        lrc_CostSchemaName: Record "POI Cost Schema Name";
}

