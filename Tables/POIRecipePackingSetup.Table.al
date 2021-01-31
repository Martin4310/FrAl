table 5110701 "POI Recipe & Packing Setup"
{
    Caption = 'Recipe & Packing Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Recipe No. Series"; Code[10])
        {
            Caption = 'Recipe No. Series';
            TableRelation = "No. Series";
        }
        field(20; "Packing Order No. Series"; Code[10])
        {
            Caption = 'Packing Order No. Series';
            TableRelation = "No. Series";
        }
        field(25; "Substitution Order No. Series"; Code[10])
        {
            Caption = 'Substitution Order No. Series';
            Description = 'PAL';
            TableRelation = "No. Series";
        }
        field(30; "Sorting Order No. Series"; Code[10])
        {
            Caption = 'Sorting Order No. Series';
            TableRelation = "No. Series";
        }
        field(39; "Default Loc. from Pack. Vendor"; Boolean)
        {
            Caption = 'Default Loc. from Pack. Vendor';
        }
        field(40; "Default Output Location Code"; Code[10])
        {
            Caption = 'Default Output Location Code';
            TableRelation = Location.Code;
        }
        field(41; "Default Packing Location Code"; Code[10])
        {
            Caption = 'Default Packing Location Code';
            TableRelation = Location.Code;
        }
        field(42; "Default Empties Location Code"; Code[10])
        {
            Caption = 'Default Empties Location Code';
            TableRelation = Location.Code;
        }
        field(43; "Default Input Location Code"; Code[10])
        {
            Caption = 'Default Input Location Code';
            TableRelation = Location.Code;
        }
        field(50; "Empties Price Group"; Code[20])
        {
            Caption = 'Empties Price Group';
            Description = 'LVW';
            //TableRelation = "Empties Price Groups".Code; //TODO: empties price group
        }
        field(60; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(70; "PackItem Quant. Decimal Places"; Integer)
        {
            Caption = 'Packing Item Quantity Decimal Places';
            MaxValue = 5;
            MinValue = 0;
        }
        field(80; "Post Calc. Costs By Reg.Order"; Boolean)
        {
            Caption = 'Post Calculated Costs By Registering Order';
        }
        field(85; "Rating for Qty without Revenue"; Option)
        {
            Caption = 'Rating for Qty without Revenue';
            OptionCaption = ' ,,,,,1 Decay,2 Damaged,3 Empty,4 Loading,,6 Sample,7 Weight,8 Others';
            OptionMembers = " ",,,,,"1 Decay","2 Damaged","3 Empty","4 Loading",,"6 Sample","7 Weight","8 Others";
        }
        field(90; "Default Production Line Code"; Code[10])
        {
            Caption = 'Default Production Line Code';
            //TableRelation = "Production Lines";
        }
        field(95; "Default Pack.-by Vendor No."; Code[20])
        {
            Caption = 'Default Pack.-by Vendor No.';
            TableRelation = Vendor;
        }
        field(98; "Default Cust.-No. Verderb"; Code[20])
        {
            Caption = 'Default Cust.-No. Verderb';
            TableRelation = Customer;
        }
        field(100; "Company Filter"; Text[150])
        {
            Caption = 'Company Filter';
        }
        field(150; "Stock Contr. Item Input Post."; Option)
        {
            Caption = 'Stock Contr. Item Input Post.';
            Description = ' ,Available Stock,Expected Available Stock';
            OptionCaption = ' ,Available Stock,Expected Available Stock';
            OptionMembers = " ","Available Stock","Expected Available Stock";
        }
        field(155; "Stock Contr. Batch Input Post."; Option)
        {
            Caption = 'Stock Contr. Batch Input Post.';
            Description = ' ,Available Stock,Expected Available Stock';
            OptionCaption = ' ,Available Stock,Expected Available Stock';
            OptionMembers = " ","Available Stock","Expected Available Stock";
        }
        field(200; "Page ID Pack. Order Card"; Integer)
        {
            Caption = 'Page ID Pack. Order Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(204; "Page ID Pack. Order Comment"; Integer)
        {
            Caption = 'Page ID Pack. Order Comment';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(205; "Page ID Input Item"; Integer)
        {
            Caption = 'Page ID Input Item';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(206; "Page ID Input Packing Material"; Integer)
        {
            Caption = 'Page ID Input Packing Material';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(207; "Page ID Input Res. and Costs"; Integer)
        {
            Caption = 'Page ID Input Res. and Costs';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(208; "Preallocation Lot No."; Code[20])
        {
            Caption = 'Preallocation Lot No.';
        }
        field(210; "Page ID Sorting Order Card"; Integer)
        {
            Caption = 'Page ID Sorting Packing Order Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(212; "Page ID Recipe List"; Integer)
        {
            Caption = 'Page ID Recipe List';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(213; "Page ID Recipe Card"; Integer)
        {
            Caption = 'Page ID Recipe Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(220; "Page Up/Down Pack. Order Card"; Boolean)
        {
            Caption = 'Page Up/Down Pack. Order Card';
        }
        field(250; "Input Loc. Item as in Header"; Boolean)
        {
            Caption = 'Input Loc. Item as in Header';
        }
        field(300; "Pack. Doc. Type Code FAS"; Code[10])
        {
            Caption = 'Pack. Doc. Type Code Feature Assortment';
            TableRelation = "POI Pack. Doc. Subtype".Code;
        }
        field(500; "Post Substitution Order Direct"; Boolean)
        {
            Caption = 'Post Substitution Order Directly';
            Description = 'PAL';
        }
        field(600; "Check Product Group"; Boolean)
        {
            Caption = 'Check Product Group';
        }
        field(700; "Calc. Input Cost by Trademark"; Boolean)
        {
            Caption = 'Kalk. Inputkosten durch Markencode';
            Description = 'NUT';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }
}

