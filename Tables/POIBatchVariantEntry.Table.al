table 5110368 "POI Batch Variant Entry"
{
    Caption = 'Batch Variant Entry';
    // DrillDownFormID = Form5110492;
    // LookupFormID = Form5110492;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(11; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = IF ("Master Batch No." = FILTER(<> '')) "POI Batch"."No." WHERE("Master Batch No." = FIELD("Master Batch No."))
            ELSE
            IF ("Master Batch No." = FILTER('')) "POI Batch"."No.";
        }
        field(12; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = IF ("Item No." = FILTER(''),
                                "Master Batch No." = FILTER(''),
                                "Batch No." = FILTER('')) "POI Batch Variant"
            ELSE
            IF ("Item No." = FILTER(<> ''),
                                         "Master Batch No." = FILTER(''),
                                         "Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."))
            ELSE
            IF ("Master Batch No." = FILTER(<> ''),
                                                  "Batch No." = FILTER('')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                                                               "Master Batch No." = FIELD("Master Batch No."))
            ELSE
            IF ("Master Batch No." = FILTER(<> ''),
                                                                                                        "Batch No." = FILTER(<> '')) "POI Batch Variant" WHERE("Item No." = FIELD("Item No."),
                                                                                                                                                       "Master Batch No." = FIELD("Master Batch No."),
                                                                                                                                                       "Batch No." = FIELD("Batch No."));
        }
        field(15; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(16; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(17; "Source Doc. Type"; Option)
        {
            Caption = 'Source Doc. Type';
            Description = 'FV';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,Input Packerei,Output Packerei,,,Transfer,Ship Transfer,Receive Transfer,,,Item Journal';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,"Input Packerei","Output Packerei",,,Transfer,"Ship Transfer","Receive Transfer",,,"Item Journal";
        }
        field(18; "Source Doc. No."; Code[20])
        {
            Caption = 'Source Doc. No.';
        }
        field(19; "Source Doc. Line No."; Integer)
        {
            Caption = 'Source Doc. Line No.';
        }
        field(22; "Status Customs Duty"; Option)
        {
            Caption = 'Status Customs Duty';
            OptionCaption = ' ,Payed,Not Payed';
            OptionMembers = " ",Payed,"Not Payed";
        }
        field(30; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(32; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(33; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(50; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(52; "Base Unit Of Measure Code"; Code[10])
        {
            Caption = 'Base Unit Of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(54; "Quantity (Base)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(57; "Remaining Quantity (Base)"; Decimal)
        {
            Caption = 'Remaining Quantity (Base)';
        }
        field(58; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(59; "Invoiced Quantity"; Decimal)
        {
            Caption = 'Invoiced Quantity';
        }
        field(60; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(61; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
        }
        field(62; Quantity; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(65; "Qty (Base) (Item Ledger Entry)"; Decimal)
        {
            Caption = 'Qty (Base) (Item Ledger Entry)';
        }
        field(66; "Quality Rating"; Option)
        {
            Caption = 'Quality Rating';
            OptionCaption = ' ,,,,,1 Decay,2 Damaged,3 Empty,4 Loading,,6 Sample,7 Weight,8 Others';
            OptionMembers = " ",,,,,"1 Decay","2 Damaged","3 Empty","4 Loading",,"6 Sample","7 Weight","8 Others";
        }
        field(70; "Detail Entry No."; Integer)
        {
            Caption = 'Detail Entry No.';
        }
        field(71; "Detail Line No."; Integer)
        {
            Caption = 'Detail Line No.';
        }
        field(100; Positive; Boolean)
        {
            Caption = 'Positive';
        }
        field(101; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(102; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(103; "Item Ledger Entry Type"; Option)
        {
            Caption = 'Item Ledger Entry Type';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(105; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(106; "Completely Invoiced"; Boolean)
        {
            Caption = 'Completely Invoiced';
        }
        field(108; "Applied Batch Var. Entry No."; Integer)
        {
            Caption = 'Applied Batch Var. Entry No.';
        }
        field(110; "Applied Item Ledger Entry No."; Integer)
        {
            Caption = 'Applied Item Ledger Entry No.';
            TableRelation = "Item Ledger Entry";
        }
        field(111; "Applied Item Ledger Entry Type"; Option)
        {
            Caption = 'Applied Item Ledger Entry Type';
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output;
        }
        field(200; "Correction Entry"; Boolean)
        {
            Caption = 'Correction Entry';
        }
        field(201; "Correction Date"; Date)
        {
            Caption = 'Correction Date';
        }
        field(202; "Correction User ID"; Code[20])
        {
            Caption = 'Correction from User';
        }
        field(300; "Batch Var. not adjusted"; Boolean)
        {
            Caption = 'Batch Var. not adjusted';
        }
        field(590; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
        }
        field(5110310; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5110311; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(5110312; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(5110313; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Detail Entry No.", "Detail Line No.")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key3; "Batch Variant No.", "Item Ledger Entry Type", "Location Code", "Posting Date")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key4; "Item Ledger Entry No.")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key5; "Item No.", "Variant Code", "Location Code", Positive)
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key6; "Item Ledger Entry No.", "Item Ledger Entry Type")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key7; "Item No.", "Item Ledger Entry Type", "Location Code", "Master Batch No.", "Batch No.", "Batch Variant No.", "Variant Code")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key8; "Document No.", "Posting Date")
        {
        }
        key(Key9; "Document No.", "Document Line No.")
        {
        }
        key(Key10; "Item Ledger Entry Type", "Batch No.", "Batch Variant No.", "Master Batch No.")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key11; "Unit of Measure Code", "Item No.")
        {
        }
        key(Key12; "Applied Item Ledger Entry No.")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key13; "Item Ledger Entry Type", "Master Batch No.")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key14; "Source Doc. Type", "Source Doc. No.", "Source Doc. Line No.")
        {
        }
    }

    trigger OnInsert()
    var
        lrc_BatchVariantEntry: Record "POI Batch Variant Entry";
    begin
        IF "Entry No." = 0 THEN
            IF lrc_BatchVariantEntry.FIND('+') THEN
                "Entry No." := lrc_BatchVariantEntry."Entry No." + 1
            ELSE
                "Entry No." := 1;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;

    procedure GetCurrencyCode(): Code[10]
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET();
            GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;
}

