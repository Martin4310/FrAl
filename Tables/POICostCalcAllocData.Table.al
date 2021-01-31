table 5110589 "POI Cost Calc. - Alloc. Data"
{
    Caption = 'Cost Calc. - Alloc. Data';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            TableRelation = "POI Cost Category";

        }
        field(4; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = IF ("Voyage No." = FILTER(<> '')) "POI Master Batch" WHERE("Voyage No." = FIELD("Voyage No."))
            ELSE
            IF ("Voyage No." = FILTER('')) "POI Master Batch";
        }
        field(5; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch" WHERE("Master Batch No." = FIELD("Master Batch No."));
        }
        field(6; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant" WHERE("Master Batch No." = FIELD("Master Batch No."),
                                                   "Batch No." = FIELD("Batch No."));
        }
        field(8; "Entry Level"; Option)
        {
            Caption = 'Entry Level';
            Description = ' ,Voyage,Container,Master Batch,Batch';
            OptionCaption = ' ,Voyage,Container,Master Batch,Batch';
            OptionMembers = " ",Voyage,Container,"Master Batch",Batch;
        }
        field(9; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Description = ' ,Cost Category,Enter Data,,,,,Detail Batch,Detail Batchvariant';
            OptionCaption = ' ,Cost Category,Enter Data,,,,,Detail Batch,Detail Batch Variant';
            OptionMembers = " ","Cost Category","Enter Data",,,,,"Detail Batch","Detail Batch Variant";
        }
        field(10; "Document No. 2"; Code[20])
        {
            Caption = 'Document No.';
        }
        field(12; "Reduce Cost from Turnover"; Boolean)
        {
            Caption = 'Reduce Cost from Turnover';
        }
        field(14; "Indirect Cost (Purchase)"; Boolean)
        {
            Caption = 'Indirect Cost (Purchase)';
        }
        field(15; "Cost Allocation"; Option)
        {
            Caption = 'Cost Allocation';
            OptionCaption = ' ,Direct Purchase Cost,,,,,Indirect Purchase Cost';
            OptionMembers = " ","Direct Purchase Cost",,,,,"Indirect Purchase Cost";
        }
        field(18; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(20; "Cost Schema Name"; Code[10])
        {
            Caption = 'Cost Schema Name';
            TableRelation = "POI Cost Schema Name";
        }
        field(44; "Means of Transport Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
        }
        field(45; "Voyage No."; Code[20])
        {
            Caption = 'Voyage No.';
            TableRelation = "POI Voyage";
        }
        field(46; "Container No."; Code[20])
        {
            Caption = 'Container No.';
            TableRelation = "POI Container";
        }
        field(50; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            ValidateTableRelation = false;
        }
        field(52; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
        }
        field(53; "Vendor External Doc. No."; Code[20])
        {
            Caption = 'Vendor External Doc. No.';
        }
        field(54; "Expected Posting Date"; Date)
        {
            Caption = 'Expected Posting Date';
        }
        field(55; "Qty. Colli"; Decimal)
        {
            Caption = 'Qty. Colli';
        }
        field(56; "Qty. Pallet"; Decimal)
        {
            Caption = 'Qty. Pallet';
        }
        field(57; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(58; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(60; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(61; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            Editable = false;
        }
        field(63; "Allocation Error"; Boolean)
        {
            Caption = 'Allocation Error';
        }
        field(64; "Allocation Level"; Option)
        {
            Caption = 'Allocation Level';
            Description = ' ,Voyage No.,Master Batch No.,Batch No.,Container No.';
            OptionCaption = ' ,Voyage No.,Master Batch No.,Batch No.,Container No.';
            OptionMembers = " ","Voyage No.","Master Batch No.","Batch No.","Container No.";
        }
        field(65; "Allocation Type"; Option)
        {
            Caption = 'Allocation Type';
            Description = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionCaption = ' ,Pallets,Kolli,Net Weight,Gross Weight,Lines,Amount';
            OptionMembers = " ",Pallets,Kolli,"Net Weight","Gross Weight",Lines,Amount;
        }
        field(67; Allocated; Boolean)
        {
            Caption = 'Allocated';
        }
        field(68; "Einmal Umlage"; Boolean)
        {
            Caption = 'Einmal Umlage';
        }
        field(70; Released; Boolean)
        {
            Caption = 'Released';
        }
        field(71; "Released by"; Code[20])
        {
            Caption = 'Released by';
        }
        field(72; "Released Date"; Date)
        {
            Caption = 'Released Date';
        }
        field(75; "Last Change by"; Code[20])
        {
            Caption = 'Last Change by';
        }
        field(76; "Last Change Date"; Date)
        {
            Caption = 'Last Change Date';
        }
        field(80; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(81; "Reference Price"; Option)
        {
            Caption = 'Reference Price';
            Description = 'Amount,Pallet,Colli,Net Weight,Gross Weight';
            OptionCaption = 'Amount,Pallet,Colli,Net Weight,Gross Weight';
            OptionMembers = Amount,Pallet,Colli,"Net Weight","Gross Weight";
        }
        field(83; "Via Location Code"; Code[10])
        {
            Caption = 'Via Location Code';
        }
        field(84; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
        }
        field(85; "Departure Region"; Code[10])
        {
            Caption = 'Abgangsregion Code';
        }
        field(87; "Arrival Region Code"; Code[10])
        {
            Caption = 'Zugangsregion Code';
        }
        field(88; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Zusteller Code';
        }
        field(90; Comment; Text[50])
        {
            Caption = 'Comment';
        }
        field(95; "Generated by System"; Boolean)
        {
            Caption = 'Generated by System';
        }
        field(96; "Generated by"; Option)
        {
            Caption = 'Generiert durch';
            Description = ' ,Standard Cost Calculation';
            OptionCaption = ' ,Standard Cost Calculation';
            OptionMembers = " ","Standard Cost Calculation";
        }
        field(100; "Entered Amount (LCY) (FF)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Cost Calc. - Enter Data"."Amount (LCY)" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                              "Voyage No." = FILTER(''),
                                                                              "Master Batch No." = FIELD("Master Batch No."),
                                                                              "Entry Type" = CONST("Enter Data")));
            Caption = 'Entered Amount (LCY) (FF)';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Posted Amount (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Geb. Betrag (MW)';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(102; "Released Amount (LCY) (FF)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Cost Calc. - Enter Data"."Amount (LCY)" WHERE("Cost Category Code" = FIELD("Cost Category Code"),
                                                                              "Master Batch No." = FIELD("Master Batch No."),
                                                                              "Entry Type" = CONST("Enter Data"),
                                                                              Released = CONST(true)));
            Caption = 'Released Amount (LCY) (FF)';
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(103; "Entered Amount (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Entered Amount (LCY)';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(104; "Released Amount (LCY)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Released Amount (LCY)';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(105; "Cost per Collo"; Decimal)
        {
            Caption = 'Cost per Collo';
        }
        field(106; "Cost per Pallet"; Decimal)
        {
            Caption = 'Cost per Pallet';
        }
        field(110; "Cost Category Description"; Text[50])
        {
            CalcFormula = Lookup ("POI Cost Category".Description WHERE(Code = FIELD("Cost Category Code")));
            Caption = 'Kostenkategorie Beschreibung';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(123; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            TableRelation = Currency;
        }
        field(124; "Invoice Currency Factor"; Decimal)
        {
            Caption = 'Invoice Currency Factor';
        }
        field(125; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';
        }
        field(150; "Attached to Entry No."; Integer)
        {
            Caption = 'Attached to Entry No.';
        }
        field(151; "Attached to Doc. No."; Code[20])
        {
            Caption = 'Attached to Doc. No.';
        }
        field(152; "Attached Entry Subtype"; Option)
        {
            Caption = 'Attached Entry Subtype';
            Description = ' ,Voyage,Container,Master Batch,Batch';
            OptionCaption = ' ,Voyage,Container,Master Batch,Batch';
            OptionMembers = " ",Voyage,Container,"Master Batch",Batch;
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
        key(Key2; "Document No. 2")
        {
        }
        key(Key3; "Batch No.", "Cost Allocation")
        {
            SumIndexFields = "Amount (LCY)";
        }
        key(Key4; "Entry Type", "Attached to Entry No.")
        {
        }
        key(Key5; "Entry Type", "Batch No.", "Reduce Cost from Turnover")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        lrc_CostCalcAllocData: Record "POI Cost Calc. - Alloc. Data";
    begin
        IF "Entry No." = 0 THEN
            lrc_CostCalcAllocData.LOCKTABLE();
        IF lrc_CostCalcAllocData.FINDLAST() THEN
            "Entry No." := lrc_CostCalcAllocData."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;
}

