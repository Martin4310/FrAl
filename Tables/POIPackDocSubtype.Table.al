table 5110725 "POI Pack. Doc. Subtype"
{

    Caption = 'Pack. Doc. Subtype';
    // DrillDownFormID = Form5110751;
    // LookupFormID = Form5110751;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Packing Order,,,Sorting Order,,,Substitution Order';
            OptionMembers = "Packing Order",,,"Sorting Order",,,"Substitution Order";
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(15; "In Selection"; Boolean)
        {
            Caption = 'In Selection';
        }
        field(20; "Page ID Pack. Order Card"; Integer)
        {
            Caption = 'Page ID Pack. Order Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(21; "Page ID Pack. Order Comment"; Integer)
        {
            Caption = 'Page ID Pack. Order Comment';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(22; "Page ID Input Item"; Integer)
        {
            Caption = 'Page ID Input Item';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(23; "Page ID Input Packing Material"; Integer)
        {
            Caption = 'Page ID Input Packing Material';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(24; "Page ID Input Res. and Costs"; Integer)
        {
            Caption = 'Page ID Input Res. and Costs';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(25; "Page ID Sorting Order Card"; Integer)
        {
            Caption = 'Page ID Sorting Pack. Order Card';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(30; "Allow Scrolling in P.O. Card"; Boolean)
        {
            Caption = 'Allow Scrolling in P.O. Card';
        }
        field(40; "Packing Order No. Series"; Code[10])
        {
            Caption = 'Packing Order No. Series';
            TableRelation = "No. Series";
        }
        field(45; "Default Output Location Code"; Code[10])
        {
            Caption = 'Default Output Location Code';
            TableRelation = Location.Code;
        }
        field(46; "Default Packing Location Code"; Code[10])
        {
            Caption = 'Default Packing Location Code';
            TableRelation = Location.Code;
        }
        field(47; "Default Empties Location Code"; Code[10])
        {
            Caption = 'Default Empties Location Code';
            TableRelation = Location.Code;
        }
        field(48; "Default Input Location Code"; Code[10])
        {
            Caption = 'Default Input Location Code';
            TableRelation = Location.Code;
        }
        field(50; "Empties Price Group"; Code[20])
        {
            Caption = 'Empties Price Group';
            Description = 'LVW';
            //TableRelation = "Empties Price Groups".Code; //TODO: empties prices
        }
        field(60; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                //IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                //  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                //    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
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
        // field(90;"Default Production Line Code";Code[10])
        // {
        //     Caption = 'Default Production Line Code';
        //     TableRelation = "Production Lines";
        // }
        field(95; "Default Pack.-by Vendor No."; Code[20])
        {
            Caption = 'Default Pack.-by Vendor No.';
            TableRelation = Vendor;
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
        field(208; "Preallocation Lot No."; Code[20])
        {
            Caption = 'Preallocation Lot No.';
        }
        field(250; "Input Loc. Item as in Header"; Boolean)
        {
            Caption = 'Input Loc. Item as in Header';
        }
        field(500; "Post Substitution Order Direct"; Boolean)
        {
            Caption = 'Post Substitution Order Directly';
            Description = 'PAL';
        }
        field(600; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(601; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                // BAB 001 DMG50052.s
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                // BAB 001 DMG50052.e
            end;
        }
        field(602; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                // BAB 001 DMG50052.s
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
                // BAB 001 DMG50052.e
            end;
        }
        field(603; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate()
            begin
                // BAB 001 DMG50052.s
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
                // BAB 001 DMG50052.e
            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    trigger OnDelete()
    var
    //lrc_PackDocTypeRecipe: Record "5110724";
    begin
        // lrc_PackDocTypeRecipe.RESET();
        // lrc_PackDocTypeRecipe.SETRANGE( lrc_PackDocTypeRecipe."Pack. Doc. Subtype Code", Code );
        // IF lrc_PackDocTypeRecipe.FIND('-') THEN
        //   lrc_PackDocTypeRecipe.DELETEALL( TRUE );
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        lrc_BatchSetup: Record "POI Master Batch Setup";
        lcu_DimMgt: Codeunit DimensionManagement;
        AGILESText001Txt: Label 'This dimension could not be defined.';
    begin
        IF ShortcutDimCode <> '' THEN BEGIN
            lrc_BatchSetup.GET();
            IF lrc_BatchSetup."Dim. No. Batch No." = FieldNumber THEN
                // Für die Position eingestellte Dimension kann nicht vorbelegt werden
                ERROR(AGILESText001Txt);
        END;

        lcu_DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        MODIFY();
    end;
}

