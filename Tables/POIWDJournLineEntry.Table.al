table 50928 "POI W.D. Journ. Line Entry"
{
    Caption = 'W.D. Journ. Line Entry';
    //DrillDownFormID = Form5087909; //TODO: drilldown page id
    //LookupFormID = Form5087909;

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
            TableRelation = "POI W.D. Journ. Name"."Journal Batch Name" WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(3; "Journal Line No"; Integer)
        {
        }
        field(4; "Line No"; Integer)
        {
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Invoice,Credit Memo,Purchase';
            OptionMembers = " ",Invoice,"Credit Memo",Purchase;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(8; "Sub Line No."; Integer)
        {
            Caption = 'Sub Line No';
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(11; "Disposal of Waste Company"; Option)
        {
            Caption = 'Entsorgungsunternehmen';
            OptionCaption = ' ,DSD,BellandVision,Interseroh,Edeka,,,,ARA';
            OptionMembers = " ",DSD,BellandVision,Interseroh,Edeka,Fruitness,"Belland Ratio","Belland Tegut",ARA,METRO;
        }
        field(15; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
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
        field(23; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(24; "Unit Of Measure Code"; Text[10])
        {
            Caption = 'Unit Of Measure Code';
        }
        field(25; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 0;
        }
        field(26; "Quantity Reported"; Decimal)
        {
            Caption = 'Quantity Reported';
        }
        field(27; "Packing Unit of Measure (PU)"; Code[10])
        {
            Caption = 'Packing Unit of Measure (PU)';
            TableRelation = "Unit of Measure".Code WHERE("POI Is Packing Unit of Measure" = CONST(true));
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
        field(35; "Quantity Collo"; Decimal)
        {
            Caption = 'Quantity Collo';
        }
        field(50; Evaluated; Boolean)
        {
            Caption = 'Evaluated';
        }
        field(60; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 2 : 5;
        }
        field(100; "DSD Big Packing"; Boolean)
        {
            Caption = 'DSD Big Packing';
        }
        field(110; Temp; Boolean)
        {
            Caption = 'Temp';
        }
        field(50000; "Expected Receipt Date"; Date)
        {
            Caption = 'Wareneingangsdatum';
        }
        field(50002; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
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
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Journal Line No", "Line No", "Document Type", "Document No.", "Document Line No.", "Sub Line No.")
        {
        }
        key(Key2; "Journal Template Name", "Journal Batch Name", "Item No.", "Variant Code", "Batch Variant No.", "Unit Of Measure Code")
        {
            SumIndexFields = Quantity, "Quantity Collo";
        }
        key(Key3; "Document Type", "Document No.", "Document Line No.")
        {
        }
        key(Key4; "Journal Template Name", "Journal Batch Name", "Document Type", "Document No.", "Document Line No.", "Sub Line No.")
        {
        }
        key(Key5; "Journal Template Name", "Journal Batch Name", "Document Type", "Document No.", "Item No.")
        {
        }
    }

    trigger OnInsert()
    begin
        DSDBuchBlVorlage.GET("Journal Template Name");
        DSDBuchBlName.GET("Journal Template Name", "Journal Batch Name");
    end;

    trigger OnModify()
    begin
        DSDBuchBlName.GET("Journal Template Name", "Journal Batch Name");
        DSDBuchBlName.TESTFIELD(Evaluated, FALSE);
    end;

    trigger OnRename()
    begin
        DSDBuchBlName.GET("Journal Template Name", "Journal Batch Name");
        DSDBuchBlName.TESTFIELD(Evaluated, FALSE);
    end;

    var
        DSDBuchBlVorlage: Record "POI W.D. Journ. Template";
        DSDBuchBlName: Record "POI W.D. Journ. Name";
}

