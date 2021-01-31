table 50927 "POI W.D. Journal Line"
{
    Caption = 'W.D. Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "POI W.D. Journ. Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "POI W.D. Journ. Name"."Journal Batch Name";
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(11; "Disposal of Waste Company"; Option)
        {
            Caption = 'Entsorgungsunternehmen';
            Description = 'DSD';
            OptionCaption = ' ,DSD,BellandVision,Interseroh,Edeka,,,,ARA';
            OptionMembers = " ",DSD,BellandVision,Interseroh,Edeka,Fruitness,"Belland Ratio","Belland Tegut",ARA,METRO;
        }
        field(13; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 2 : 5;
        }
        field(14; "Quantity Collo"; Decimal)
        {
            CalcFormula = Sum ("POI W.D. Journ. Line Entry"."Quantity Collo" WHERE("Journal Template Name" = FIELD("Journal Template Name"),
                                                                               "Journal Batch Name" = FIELD("Journal Batch Name"),
                                                                               "Journal Line No" = FIELD("Line No.")));
            Caption = 'Quantity Collo';
            Description = 'Kalkuliertes Feld';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; Quantity; Decimal)
        {
            CalcFormula = Sum ("POI W.D. Journ. Line Entry".Quantity WHERE("Journal Template Name" = FIELD("Journal Template Name"),
                                                                       "Journal Batch Name" = FIELD("Journal Batch Name"),
                                                                       "Journal Line No" = FIELD("Line No.")));
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
            Description = 'Kalkuliertes Feld';
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(21; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(22; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(27; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            TableRelation = "Unit of Measure".Code WHERE("POI Is Packing Unit of Measure" = CONST(true));
        }
        field(28; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(29; "Unit Of Measure Code"; Text[30])
        {
            Caption = 'Unit Of Measure Code';
            TableRelation = "Unit of Measure".Code;
        }
        field(30; "Category Code"; Code[10])
        {
            Caption = 'Category Code';
            TableRelation = "POI W.D. Category";
        }
        field(31; "Weight in Kg"; Decimal)
        {
            Caption = 'Weight in Kg';
        }
        field(33; "Orig. Line No."; Integer)
        {
            Caption = 'Orig. Line No.';
        }
        field(34; Evaluated; Boolean)
        {
            Caption = 'Evaluated';
        }
        field(35; "Reporting Quantity"; Decimal)
        {
            Caption = 'Reporting Quantity';
        }
        field(36; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(40; "Mengenbezug auf Umverpackung"; Boolean)
        {
            Caption = 'Mengenbezug auf Umverpackung';
        }
        field(50; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(51; "Vendor Country Code"; Code[10])
        {
            Caption = 'Vendor Country Code';
            TableRelation = "Country/Region";
        }
        field(60; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(50000; "Expected Receipt Date"; Date)
        {
            Caption = 'Wareneingangsdatum';
        }
        field(50001; "Anzahl Posten"; Integer)
        {
            CalcFormula = Count ("POI W.D. Journ. Line Entry" WHERE("Journal Template Name" = FIELD("Journal Template Name"),
                                                                "Journal Batch Name" = FIELD("Journal Batch Name"),
                                                                "Journal Line No" = FIELD("Line No."),
                                                                "Location Code" = FIELD("Location Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Location Code"; Code[10])
        {
            CalcFormula = Lookup ("POI W.D. Journ. Line Entry"."Location Code" WHERE("Journal Template Name" = FIELD("Journal Template Name"),
                                                                                 "Journal Batch Name" = FIELD("Journal Batch Name"),
                                                                                 "Journal Line No" = FIELD("Line No.")));
            Caption = 'Location Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Location Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5110321; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(5110322; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            NotBlank = true;
            TableRelation = "POI Batch";
        }
        field(5110323; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(5110350; Trademark; Code[20])
        {
            Caption = 'Marke';
        }
        field(5110360; "G.1 Amount"; Decimal)
        {
        }
        field(5110361; "G.2 Amount"; Decimal)
        {
        }
        field(5110362; "G.3 Amount"; Decimal)
        {
        }
        field(5110363; "G.5 Amount"; Decimal)
        {
        }
        field(5110364; "G.8 Amount"; Decimal)
        {
        }
        field(5110365; "G.1 Weight"; Decimal)
        {
        }
        field(5110366; "G.2 Weight"; Decimal)
        {
        }
        field(5110367; "G.3 Weight"; Decimal)
        {
        }
        field(5110368; "G.5 Weight"; Decimal)
        {
        }
        field(5110369; "G.8 Weight"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
        }
        key(Key2; "Item No.", "Variant Code", "Batch Variant No.", "Unit Of Measure Code")
        {
        }
        key(Key3; "Journal Template Name", "Journal Batch Name", Description, "Item No.", "Unit Of Measure Code")
        {
        }
    }

    trigger OnDelete()
    begin
        DSDBuchBlattzeilePosten.RESET();
        DSDBuchBlattzeilePosten.SETRANGE("Journal Template Name", "Journal Template Name");
        DSDBuchBlattzeilePosten.SETRANGE("Journal Batch Name", "Journal Batch Name");
        DSDBuchBlattzeilePosten.SETRANGE("Item No.", "Item No.");
        DSDBuchBlattzeilePosten.SETRANGE("Variant Code", "Variant Code");
        DSDBuchBlattzeilePosten.SETRANGE("Batch Variant No.", "Batch Variant No.");
        DSDBuchBlattzeilePosten.SETRANGE("Unit Of Measure Code", "Unit Of Measure Code");
        DSDBuchBlattzeilePosten.SETRANGE("Journal Line No", "Line No.");
        IF DSDBuchBlattzeilePosten.FIND('-') THEN;
        DSDBuchBlattzeilePosten.DELETEALL();

        DSDJournLineErrorEntry.RESET();
        DSDJournLineErrorEntry.SETRANGE("Journal Template Name", "Journal Template Name");
        DSDJournLineErrorEntry.SETRANGE("Journal Batch Name", "Journal Batch Name");
        DSDJournLineErrorEntry.SETRANGE("Item No.", "Item No.");
        DSDJournLineErrorEntry.SETRANGE("Variant Code", "Variant Code");
        DSDJournLineErrorEntry.SETRANGE("Batch Variant No.", "Batch Variant No.");
        DSDJournLineErrorEntry.SETRANGE("Unit Of Measure Code", "Unit Of Measure Code");
        IF DSDJournLineErrorEntry.FIND('-') THEN;
        DSDJournLineErrorEntry.DELETEALL();
    end;

    trigger OnInsert()
    begin
        DSDBuchBlVorlage.GET("Journal Template Name");
        DSDBuchBlName.GET("Journal Template Name", "Journal Batch Name");
        DSDBuchBlName.TESTFIELD(Evaluated, FALSE);
    end;

    trigger OnModify()
    begin
        DSDBuchBlName.GET("Journal Template Name", "Journal Batch Name");
        DSDBuchBlName.TESTFIELD(Evaluated, FALSE);
    end;

    trigger OnRename()
    begin
        ERROR('Umbenennung nicht zulässig!');
    end;

    var
        DSDBuchBlVorlage: Record "POI W.D. Journ. Template";
        DSDBuchBlName: Record "POI W.D. Journ. Name";
        DSDBuchBlattzeilePosten: Record "POI W.D. Journ. Line Entry";
        DSDJournLineErrorEntry: Record "POI W.D. Journ. Line Err Entry";
}

