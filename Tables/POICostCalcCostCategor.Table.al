table 5110548 "POI Cost Calc. - Cost Categor"
{
    Caption = 'Cost Calc. - Cost Categories';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Entry Level"; Option)
        {
            Caption = 'Entry Level';
            Description = ' ,Voyage,Container,Master Batch,Batch';
            OptionCaption = ' ,Voyage,Container,Master Batch,Batch';
            OptionMembers = " ",Voyage,Container,"Master Batch",Batch;
        }
        field(12; "Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
        }
        field(14; "Container No."; Code[20])
        {
            Caption = 'Container No.';
            TableRelation = "POI Container";
        }
        field(16; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = IF ("Voyage No." = FILTER(<> '')) "POI Master Batch" WHERE("Voyage No." = FIELD("Voyage No."))
            ELSE
            IF ("Voyage No." = FILTER('')) "POI Master Batch";
        }
        field(17; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch" WHERE("Master Batch No." = FIELD("Master Batch No."));
        }
        field(20; "Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            TableRelation = "POI Cost Category";
        }
        field(21; "Cost Category Description"; Text[50])
        {
            CalcFormula = Lookup ("POI Cost Category".Description WHERE(Code = FIELD("Cost Category Code")));
            Caption = 'Kostenkategorie Beschreibung';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Cost Schema Name"; Code[10])
        {
            Caption = 'Cost Schema Name';
            TableRelation = "POI Cost Schema Name";
        }
        field(24; "Reduce Cost from Turnover"; Boolean)
        {
            Caption = 'Reduce Cost from Turnover';
        }
        field(25; "Indirect Cost (Purchase)"; Boolean)
        {
            Caption = 'Indirect Cost (Purchase)';
        }
        field(26; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(70; "Entered Amt (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Cost Calc. - Enter Data"."Amount (LCY)" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                              "Master Batch No." = FIELD("Master Batch No."),
                                                                              "Entry Type" = FILTER("Enter Data")));
            Caption = 'Entered Amt (LCY)';
            DecimalPlaces = 2 : 2;
            Description = 'RS geändert in Flow Field - tbl5110564';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Released Amt (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Cost Calc. - Enter Data"."Released Amount (LCY)" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                                       "Master Batch No." = FIELD("Master Batch No.")));
            Caption = 'Released Amt (LCY)';
            DecimalPlaces = 2 : 2;
            Description = 'RS geändert in Flow Field - tbl5110564';
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "Posted Amt (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Cost Calc. - Enter Data"."Posted Amount (LCY)" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                                     "Master Batch No." = FIELD("Master Batch No.")));
            Caption = 'Geb. Betrag (MW)';
            DecimalPlaces = 2 : 2;
            Description = 'RS geändert in Flow Field - tbl5110564';
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "Entered Amount"; Decimal)
        {
            CalcFormula = Sum ("POI Cost Calc. - Enter Data"."Amount (LCY)" WHERE("Master Batch No." = FIELD("Master Batch No."),
                                                                              "Cost Category Code" = FIELD("Cost Category Code")));
            FieldClass = FlowField;
        }
        field(190; "No. of Loadings in Doc."; Integer)
        {
            Caption = 'No. of Loadings in Doc.';
        }
        field(200; "No. of Lines Entered"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Cost Calc. - Enter Data" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                 "Master Batch No." = FIELD("Master Batch No."),
                                                                 "Entry Type" = CONST("Enter Data")));
            Caption = 'No. of Lines Entered';
            Editable = false;
            FieldClass = FlowField;
        }
        field(202; "No. of Lines Released"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Cost Calc. - Enter Data" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                 "Master Batch No." = FIELD("Master Batch No."),
                                                                 "Entry Type" = CONST("Enter Data"),
                                                                 Released = CONST(true)));
            Caption = 'No. of Lines Released';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Entry Level", "Voyage No.", "Container No.", "Batch No.", "Cost Category Code")
        {
        }
        key(Key3; "Entry Level", "Master Batch No.", "Cost Category Code")
        {
        }
    }

    trigger OnInsert()
    var
        lrc_CostCalcCostCategories: Record "POI Cost Calc. - Cost Categor";
    begin
        IF lrc_CostCalcCostCategories.FINDLAST() THEN
            "Entry No." := lrc_CostCalcCostCategories."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;
}

