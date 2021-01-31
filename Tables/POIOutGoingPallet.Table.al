table 5110502 "POI Outgoing Pallet"
{

    Caption = 'Outgoing Pallet';
    // DrillDownFormID = Form5088077;
    // LookupFormID = Form5087959;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Zeilennr.';
        }
        field(10; "Pallet No."; Code[30])
        {
            Caption = 'Pallet No.';
            TableRelation = "POI Pallets";

            trigger OnValidate()
            var
                lrc_Pallets: Record "POI Pallets";
            begin
                TESTFIELD("Pallet No.");

                IF lrc_Pallets.GET("Pallet No.") THEN BEGIN
                    "Location Code" := lrc_Pallets."Location Code";
                    "Location Bin Code" := lrc_Pallets."Location Bin Code";
                END;
            end;
        }
        field(11; "Pallet Line No."; Integer)
        {
            Caption = 'Pallet Line No.';
        }
        field(12; "Pallet Transport Unit Code"; Code[10])
        {
            Caption = 'Pallet Transport Unit Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(13; "Pallet Freight Unit Code"; Code[10])
        {
            Caption = 'Pallet Freight Unit Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(14; "NVE No."; Code[30])
        {
            Caption = 'NVE No.';
        }
        field(15; "Source Pallet No."; Code[30])
        {
            Caption = 'Source Pallet No.';
            TableRelation = "POI Pallets";
        }
        field(16; "Source Pallet Line No."; Integer)
        {
            Caption = 'Source Pallet Line No.';
        }
        field(19; "Pos./Neg. Adjustment"; Option)
        {
            Caption = 'Pos./Neg. Adjustment';
            InitValue = "Neg. Adjustment";
            OptionCaption = 'Pos. Adjustment,Neg. Adjustment';
            OptionMembers = "Pos. Adjustment","Neg. Adjustment";

            trigger OnValidate()
            var
                AgilesText001Txt: Label 'Die Menge muss < 0 sein !';
                AgilesText002Txt: Label 'Die Menge muss >= 0 sein !';
            begin
                IF "Pos./Neg. Adjustment" = "Pos./Neg. Adjustment"::"Neg. Adjustment" THEN BEGIN
                    IF Quantity < 0 THEN
                        ERROR(AgilesText002Txt);
                END ELSE
                    IF Quantity > 0 THEN
                        ERROR(AgilesText001Txt);

            end;
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Sales Order,Packing Order,Physical Inventory,Partial Transfer,Sales Claim Advice,Transfer Order';
            OptionMembers = "Sales Order","Packing Order","Physical Inventory","Partial Transfer","Sales Claim Advice","Transfer Order";
        }
        field(21; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF ("Document Type" = CONST("Sales Order")) "Sales Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF ("Document Type" = CONST("Transfer Order")) "Transfer Header"."No.";
        }
        field(22; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            TableRelation = IF ("Document Type" = CONST("Sales Order")) "Sales Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                                                                 "Document No." = FIELD("Document No."));
        }
        field(23; "Document Line No. Output"; Integer)
        {
            Caption = 'Document Line No. Output';
            TableRelation = "POI Pack. Order Output Items"."Line No." WHERE("Doc. No." = FIELD("Document No."));
        }
        field(30; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(31; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
        }
        field(35; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(36; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(40; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
            begin
                "Qty. per Unit of Measure" := 0;
                IF "Unit of Measure Code" <> '' THEN BEGIN
                    lrc_ItemUnitofMeasure.GET("Item No.", "Unit of Measure Code");
                    lrc_ItemUnitofMeasure.TESTFIELD("Qty. per Unit of Measure");
                    "Qty. per Unit of Measure" := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";
                END;
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(41; Quantity; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF Quantity >= 0 THEN
                    TESTFIELD("Pos./Neg. Adjustment", "Pos./Neg. Adjustment"::"Neg. Adjustment")
                ELSE
                    IF Quantity < 0 THEN
                        TESTFIELD("Pos./Neg. Adjustment", "Pos./Neg. Adjustment"::"Pos. Adjustment");

                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(44; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(45; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
        }
        field(46; "Quantity (Base)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TESTFIELD("Qty. per Unit of Measure", 1);
                VALIDATE(Quantity, "Quantity (Base)");
            end;
        }
        field(50; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(51; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            TableRelation = "POI Batch";
        }
        field(52; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(53; "Status Batch Variant No."; Option)
        {
            CalcFormula = Lookup ("POI Batch Variant".State WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Status Batch Variant No.';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,Manuell Gesperrt,Löschung';
            OptionMembers = Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,"Manuell Gesperrt","Löschung";
        }
        field(54; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(57; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
        }
        field(80; "Salespers./Purch. Code"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(90; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Purchase Order,Packing Order,Physical Inventory,Partial Transfer,Transfer Order';
            OptionMembers = "Purchase Order","Packing Order","Physical Inventory","Partial Transfer","Transfer Order";
        }
        field(91; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST("Purchase Order")) "Purchase Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF (Source = CONST("Transfer Order")) "Transfer Header"."No.";
        }
        field(92; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(120; "Warehouse Pallet No."; Code[30])
        {
            Caption = 'Warehouse Pallet No.';
        }
        field(150; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor."No.";
        }
        field(151; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(159; "Vendor Pallet No."; Code[30])
        {
            CalcFormula = Lookup ("POI Pallets"."Vendor Pallet No." WHERE("No." = FIELD("Pallet No.")));
            Caption = 'Vendor Pallet No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(160; "Owner Name"; Text[50])
        {
            Caption = 'Owner Name';
        }
        field(161; "Owner Comment"; Text[50])
        {
            Caption = 'Owner Comment';
        }
        field(162; "Owner Vendor No."; Code[20])
        {
            Caption = 'Owner Vendor No.';
            TableRelation = Vendor;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;

            begin
                IF lrc_Vendor.GET("Owner Vendor No.") THEN
                    VALIDATE("Owner Name", lrc_Vendor.Name);
            end;
        }
        field(200; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                lrc_Pallets: Record "POI Pallets";
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF lrc_Pallets.GET("Pallet No.") THEN
                    TESTFIELD("Location Code", lrc_Pallets."Location Code");


                IF "Location Code" = '' THEN
                    "Location Bin Code" := ''
                ELSE
                    IF "Location Code" <> xRec."Location Code" THEN
                        "Location Bin Code" := '';

                IF "Location Code" <> xRec."Location Code" THEN
                    lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0,
                                                                    xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
            end;
        }
        field(201; "Location Bin Code"; Code[10])
        {
            Caption = 'Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnLookup()
            var
                lrc_Pallets: Record "POI Pallets";
                lcu_PalletManagement: Codeunit "POI Pallet Management";

            begin
                IF lrc_Pallets.GET("Pallet No.") THEN
                    TESTFIELD("Location Bin Code", lrc_Pallets."Location Bin Code");


                IF "Location Bin Code" <> xRec."Location Bin Code" THEN
                    lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0,
                                                                    xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");

            end;
        }
        field(202; "Release From Location Bin Code"; Code[10])
        {
            Caption = 'Release From Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(300; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(301; "Posted Document No."; Code[20])
        {
            Caption = 'Posted Document No.';
            Editable = false;
        }
        field(302; "Posted Document Line No."; Integer)
        {
            Caption = 'Posted Document Line No.';
            Editable = false;
        }
        field(303; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(304; "Posted Doc. Line No. Output"; Integer)
        {
            Caption = 'Posted Doc. Line No. Output';
        }
        field(400; "Quantity Pallet Item Line"; Decimal)
        {
            CalcFormula = Lookup ("POI Pallet - Item Lines".Quantity WHERE("Pallet No." = FIELD("Pallet No."),
                                                                        "Line No." = FIELD("Pallet Line No.")));
            Caption = 'Quantity Pallet Item Line';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(500; "Posting Date Pallet Item Line"; Date)
        {
            CalcFormula = Lookup ("POI Pallet - Item Lines"."Posting Date" WHERE("Pallet No." = FIELD("Pallet No."),
                                                                              "Line No." = FIELD("Pallet Line No.")));
            Caption = 'Posting Date Pallet - Item Line';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5110435; "Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'BSI';
        }
        field(5110436; "Info 2"; Code[20])
        {
            CaptionClass = '5110300,1,2';
            Caption = 'Info 2';
            Description = 'BSI';
        }
        field(5110437; "Info 3"; Code[20])
        {
            CaptionClass = '5110300,1,3';
            Caption = 'Info 3';
            Description = 'BSI';
        }
        field(5110438; "Info 4"; Code[20])
        {
            CaptionClass = '5110300,1,4';
            Caption = 'Info 4';
            Description = 'BSI';
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Line No.")
        {
        }
        key(Key2; "Pallet No.", "Pallet Line No.", "Document Type", "Document No.", "Document Line No.", "Document Line No. Output", Posted)
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key3; "Pallet No.", "Pallet Line No.", Posted, "Location Code", "Location Bin Code")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key4; "Entry No.", "Item No.", "Variant Code", "Location Code", "Unit of Measure Code", "Master Batch No.", "Batch No.", "Batch Variant No.", "Document Type", "Document No.", "Document Line No.", "Document Line No. Output")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key5; "Batch Variant No.")
        {
        }
        key(Key6; "Posted Document No.", "Posting Date")
        {
        }
        key(Key7; "Entry No.", "Pallet No.")
        {
        }
        key(Key8; "Location Code", "Item No.", "Location Bin Code", "Pallet No.")
        {
        }
        key(Key9; "Document Type", "Document No.", "Document Line No.", Posted)
        {
        }
        key(Key10; "Entry No.", "Pallet No.", "Pallet Line No.", "Document Type", "Document No.", "Document Line No.", "Document Line No. Output", "Item No.", "Variant Code", "Unit of Measure Code", "Master Batch No.", "Batch No.", "Batch Variant No.")
        {
        }
        key(Key11; "Entry No.", Posted, "Document Type", "Document No.", "Document Line No.", "Document Line No. Output")
        {
        }
        key(Key12; "Batch Variant No.", "Batch No.", "Master Batch No.", "Item No.", "Location Code", "Unit of Measure Code", "Variant Code", "Document Type", "Document No.", "Document Line No.", "Document Line No. Output")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key13; "Entry No.", "Location Code", "Release From Location Bin Code", "Location Bin Code", "Item No.", "Pallet No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";

    begin
        lcu_PalletManagement.CheckDeletePallet("Pallet No.", 0, 0, "Entry No.", "Line No.", '', 0);
        IF Posted = FALSE THEN
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", -"Quantity (Base)", '', '', '')
        ELSE
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, '', '', '');


        IF "Document Type" = "Document Type"::"Sales Order" THEN BEGIN
            lrc_BatchVariantdetail.RESET();
            lrc_BatchVariantdetail.SETCURRENTKEY(Source, "Source Type", "Source No.", "Source Line No.", "Batch Variant No.", "Item No.", "Location Code");
            lrc_BatchVariantdetail.SETRANGE("Item No.", "Item No.");
            lrc_BatchVariantdetail.SETRANGE("Variant Code", "Variant Code");
            lrc_BatchVariantdetail.SETRANGE("Location Code", "Location Code");
            lrc_BatchVariantdetail.SETRANGE("Unit of Measure Code", "Unit of Measure Code");
            lrc_BatchVariantdetail.SETRANGE("Master Batch No.", "Master Batch No.");
            lrc_BatchVariantdetail.SETRANGE("Batch No.", "Batch No.");
            lrc_BatchVariantdetail.SETRANGE("Batch Variant No.", "Batch Variant No.");
            lrc_BatchVariantdetail.SETRANGE(Source, lrc_BatchVariantdetail.Source::Sales);
            lrc_BatchVariantdetail.SETRANGE("Source Type", lrc_BatchVariantdetail."Source Type"::Order);
            lrc_BatchVariantdetail.SETRANGE("Source No.", "Document No.");
            lrc_BatchVariantdetail.SETRANGE("Source Line No.", "Document Line No.");
            IF lrc_BatchVariantdetail.FIND('-') THEN
                IF lrc_BatchVariantdetail.Quantity >= Quantity THEN BEGIN
                    lrc_BatchVariantdetail.VALIDATE(Quantity, (lrc_BatchVariantdetail.Quantity - Quantity));
                    lrc_BatchVariantdetail.MODIFY(TRUE);
                END;
        END;
    end;

    trigger OnInsert()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_OutgoingPallet.SETRANGE("Entry No.", "Entry No.");
            IF lrc_OutgoingPallet.FIND('+') THEN
                "Line No." := lrc_OutgoingPallet."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        IF Posted = FALSE THEN
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", "Quantity (Base)", '', '', '')
        ELSE
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, '', '', '');
    end;

    trigger OnModify()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        TESTFIELD(Posted, FALSE);
        lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0,
                                                       xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
    end;

    trigger OnRename()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0,
                                                        xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
    end;

    procedure FillFromPalletItemLine(var rrc_PalletItemLines: Record "POI Pallet - Item Lines")
    begin
        // -------------------------------------------------------------------------------------------------
        // Ausgehende Palettenzeile mit den Daten aus der Palette - Artikelzeile füllen
        // Folgende Felder werden in der aufrufenden Funktion gefüllt:
        // "Document Type", "Document No.", "Document Line No.","Document Line No. Output", Quantity
        // -------------------------------------------------------------------------------------------------

        // PAL 004 DMG50019.s
        "Pallet No." := rrc_PalletItemLines."Pallet No.";
        "Pallet Line No." := rrc_PalletItemLines."Line No.";
        "Source Pallet No." := rrc_PalletItemLines."Pallet No.";
        "Source Pallet Line No." := rrc_PalletItemLines."Line No.";
        "Item No." := rrc_PalletItemLines."Item No.";
        "Variant Code" := rrc_PalletItemLines."Variant Code";
        "Unit of Measure Code" := rrc_PalletItemLines."Unit of Measure Code";
        "Base Unit of Measure" := rrc_PalletItemLines."Base Unit of Measure";
        "Qty. per Unit of Measure" := rrc_PalletItemLines."Qty. per Unit of Measure";
        "Master Batch No." := rrc_PalletItemLines."Master Batch No.";
        "Batch No." := rrc_PalletItemLines."Batch No.";
        "Batch Variant No." := rrc_PalletItemLines."Batch Variant No.";
        "Lot No." := rrc_PalletItemLines."Lot No.";
        "Location Code" := rrc_PalletItemLines."Location Code";
        "Location Bin Code" := rrc_PalletItemLines."Location Bin Code";
        "Release From Location Bin Code" := rrc_PalletItemLines."Release From Location Bin Code";
        "Pallet Transport Unit Code" := rrc_PalletItemLines."Pallet Unit Code";
        "Pallet Freight Unit Code" := rrc_PalletItemLines."Pallet Freight Unit Code";
        "NVE No." := rrc_PalletItemLines."NVE No.";
        "Item Description" := rrc_PalletItemLines."Item Description";
        "Item Description 2" := rrc_PalletItemLines."Item Description 2";
        "Date of Expiry" := rrc_PalletItemLines."Date of Expiry";
        "Salespers./Purch. Code" := rrc_PalletItemLines."Salesman/Purchaser Code";
        Source := rrc_PalletItemLines.Source;
        "Source No." := rrc_PalletItemLines."Source No.";
        "Source Line No." := rrc_PalletItemLines."Source Line No.";
        "Vendor No." := rrc_PalletItemLines."Vendor No.";
        "Vendor Name" := rrc_PalletItemLines."Vendor Name";
        "Owner Vendor No." := rrc_PalletItemLines."Owner Vendor No.";
        "Owner Name" := rrc_PalletItemLines."Owner Name";
        "Owner Comment" := rrc_PalletItemLines."Owner Comment";
    end;

    var
        lrc_BatchVariantdetail: Record "POI Batch Variant Detail";
        lrc_OutgoingPallet: Record "POI Outgoing Pallet";
}

