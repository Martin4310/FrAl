table 5110503 "POI Pallet - Item Lines"
{

    Caption = 'Pallet - Item Lines';
    // DrillDownFormID = Form5087957;
    // LookupFormID = Form5087957;

    fields
    {
        field(1; "Pallet No."; Code[30])
        {
            Caption = 'Pallet No.';
            TableRelation = "POI Pallets"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(12; "Pallet Unit Code"; Code[10])
        {
            Caption = 'Paletten Einheitencode';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(13; "Pallet Freight Unit Code"; Code[10])
        {
            Caption = 'Pallet Freight Unit Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(15; "NVE No."; Code[30])
        {
            Caption = 'NVE No.';
        }
        field(16; "Location Code"; Code[10])
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
                    lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");

            end;
        }
        field(17; "Location Bin Code"; Code[10])
        {
            Caption = 'Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE("Location Code" = FIELD("Location Code"));

            trigger OnValidate()
            var
                lrc_Pallets: Record "POI Pallets";
                lcu_PalletManagement: Codeunit "POI Pallet Management";

            begin
                IF lrc_Pallets.GET("Pallet No.") THEN
                    TESTFIELD("Location Bin Code", lrc_Pallets."Location Bin Code");

                IF "Location Bin Code" <> xRec."Location Bin Code" THEN
                    lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
            end;
        }
        field(18; "Release From Location Bin Code"; Code[10])
        {
            Caption = 'Release From Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE("Location Code" = FIELD("Location Code"));
        }
        field(30; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF "Item No." <> '' THEN BEGIN
                    lrc_Item.GET("Item No.");
                    "Base Unit of Measure" := lrc_Item."Base Unit of Measure";
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                END;
            end;
        }
        field(31; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("Item No."));
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
        field(42; Quantity; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(43; "Selected Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Selected Quantity';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(44; "Repacking Unit of Measure Code"; Code[10])
        {
            Caption = 'Repacking Unit of Measure Code';
            TableRelation = "Unit of Measure".Code;
        }
        field(45; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            //TableRelation = "Unit of Measure" WHERE("Is Base Unit of Measure" = CONST(true));
        }
        field(46; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
        }
        field(47; "Quantity (Base)"; Decimal)
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
        field(53; "Batch Var. Status"; Option)
        {
            CalcFormula = Lookup ("POI Batch Variant".State WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Batch Var. Status';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,Manuell Gesperrt,Löschung';
            OptionMembers = Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,"Manuell Gesperrt","Löschung";
        }
        field(54; "Batch Var. Country of Origin"; Code[10])
        {
            CalcFormula = Lookup ("POI Batch Variant"."Country of Origin Code" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Batch Var. Country of Origin';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Country/Region";
        }
        field(55; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(57; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
        }
        field(60; "Gross Weight"; Decimal)
        {
            Caption = 'Gross Weight';
        }
        field(80; "Salesman/Purchaser Code"; Code[20])
        {
            Caption = 'Salesman/Purchaser Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            begin
                IF STRPOS("Owner Name", 'Meyer') > 0 THEN
                    VALIDATE(Salesman, "Salesman/Purchaser Code");
            end;
        }
        field(90; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Purchase Order,Packing Order,Physical Inventory,Sales Order,Partial Transfer,Sales Claim Advice,Sales Creait Memo,Transfer Order';
            OptionMembers = "Purchase Order","Packing Order","Physical Inventory","Sales Order","Partial Transfer","Sales Claim Advice","Sales Credit Memo","Transfer Order";
        }
        field(91; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST("Purchase Order")) "Purchase Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            // IF (Source = CONST("Sales Claim Advice")) "Sales Claim Notify Header"."No."
            // ELSE
            IF (Source = CONST("Sales Credit Memo")) "Sales Header"."No." WHERE("Document Type" = CONST("Credit Memo"))
            ELSE
            IF (Source = CONST("Transfer Order")) "Transfer Header"."No.";
        }
        field(92; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(95; "Posted Source"; Option)
        {
            Caption = 'Posted Source';
            OptionCaption = ' ,Purchase Receipt';
            OptionMembers = " ","Purchase Receipt";
        }
        field(96; "Posted Source No."; Code[20])
        {
            Caption = 'Posted Source No.';
        }
        field(97; "Posted Source Line No."; Integer)
        {
            Caption = 'Posted Source Line No.';
        }
        field(100; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Opened,Closed';
            OptionMembers = " ",Opened,Closed;
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
        field(160; "Owner Name"; Text[50])
        {
            Caption = 'Owner Name';

            trigger OnValidate()
            begin
                IF STRPOS("Owner Name", 'Meyer') > 0 THEN
                    IF "Salesman/Purchaser Code" = '' THEN
                        VALIDATE("Salesman/Purchaser Code", 'MEYER')
                    ELSE
                        VALIDATE("Salesman/Purchaser Code")
                ELSE
                    VALIDATE(Salesman, "Owner Name");
            end;
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
        field(300; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(301; "Creation From Userid"; Code[50])
        {
            Caption = 'Creation From Userid';
            Editable = false;
            TableRelation = User."User Name";
        }
        field(305; "Change Date"; Date)
        {
            Caption = 'Change Date';
            Editable = false;
        }
        field(306; "Change From Userid"; Code[50])
        {
            Caption = 'Change From Userid';
            Editable = false;
            TableRelation = User."User Name";
        }
        field(310; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(400; "Quantity Outgoing Pallets"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Outgoing Pallet".Quantity WHERE("Pallet No." = FIELD("Pallet No."),
                                                                 "Pallet Line No." = FIELD("Line No."),
                                                                 "Document Type" = FIELD("Outgoing Source Filter"),
                                                                 "Document No." = FIELD("Outgoing Source No. Filter"),
                                                                 "Document Line No." = FIELD("Outgoing Source LineNo. Filter"),
                                                                 "Document Line No. Output" = FIELD("Outgoing Source OPLineNoFilter"),
                                                                 Posted = CONST(false)));
            Caption = 'Quantity Outgoing Pallets';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(401; "Qty (Base) Outgoing Pallets"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Outgoing Pallet"."Quantity (Base)" WHERE("Pallet No." = FIELD("Pallet No."),
                                                                          "Pallet Line No." = FIELD("Line No."),
                                                                          "Document Type" = FIELD("Outgoing Source Filter"),
                                                                          "Document No." = FIELD("Outgoing Source No. Filter"),
                                                                          "Document Line No." = FIELD("Outgoing Source LineNo. Filter"),
                                                                          "Document Line No. Output" = FIELD("Outgoing Source OPLineNoFilter"),
                                                                          Posted = CONST(false)));
            Caption = 'Quantity (Base) Outgoing Pallets';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TESTFIELD("Qty. per Unit of Measure", 1);
                VALIDATE(Quantity, "Quantity (Base)");
            end;
        }
        field(450; "Quantity Incoming Pallets"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Incoming Pallet".Quantity WHERE("Pallet No." = FIELD("Pallet No."),
                                                                 Posted = CONST(false)));
            Caption = 'Quantity Incoming Pallets';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(451; "Qty (Base) Incoming Pallets"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Incoming Pallet"."Quantity (Base)" WHERE("Pallet No." = FIELD("Pallet No."),
                                                                          Posted = CONST(false)));
            Caption = 'Quantity (Base) Incoming Pallets';
            DecimalPlaces = 0 : 5;
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TESTFIELD("Qty. per Unit of Measure", 1);
                VALIDATE(Quantity, "Quantity (Base)");
            end;
        }
        field(500; "Outgoing Source Filter"; Option)
        {
            Caption = 'Outgoing Source Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
            OptionCaption = 'Sales Order,Packing Order,Physical Inventory,Transfer Order';
            OptionMembers = "Sales Order","Packing Order","Physical Inventory","Transfer Order";
        }
        field(501; "Outgoing Source No. Filter"; Code[20])
        {
            Caption = 'Outgoing Source No. Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
        }
        field(502; "Outgoing Source LineNo. Filter"; Integer)
        {
            Caption = 'Outgoing Source Line No. Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
        }
        field(503; "Outgoing Source OPLineNoFilter"; Integer)
        {
            Caption = 'Outgoing Source Output Line No. Filter';
            Description = 'FlowFilter';
            FieldClass = FlowFilter;
        }
        field(600; "Market Unit Cost (Base)(LCY)"; Decimal)
        {
            CalcFormula = Lookup ("POI Batch Variant"."Market Unit Cost (Base) (LCY)" WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Market Unit Cost (Base) (LCY) Batch Variant';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(610;"Market Unit Price (fixed)(LCY)";Decimal)
        // {
        //     CalcFormula = Lookup(Item."Market Unit Price (fixed)(LCY)" WHERE ("No."=FIELD("Item No.")));
        //     Caption = 'Market Unit Price (fixed) (LCY) Item';
        //     Description = 'Flowfield';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(611;"Last Market Unit Price (LCY)";Decimal)
        // {
        //     CalcFormula = Lookup(Item."Last Market Unit Price (LCY)" WHERE ("No."=FIELD("Item No.")));
        //     Caption = 'Last Market Unit Price (LCY) Item';
        //     Description = 'Flowfield';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(800; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Item Journal Template";
        }
        field(801; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(802; "Item Journal Line"; Integer)
        {
            Caption = 'Item Journal Line';
        }
        field(810; "Qty. (Phys. Inventory)"; Decimal)
        {
            Caption = 'Qty. (Phys. Inventory)';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Qty. (Phys. Inventory)" >= Quantity then begin
                    VALIDATE("Inventory Entry Type", "Inventory Entry Type"::"Positive Adjmt.");
                    VALIDATE("Diff. Qty. (Phys. Inventory)", "Qty. (Phys. Inventory)" - Quantity);
                end else begin
                    VALIDATE("Inventory Entry Type", "Inventory Entry Type"::"Negative Adjmt.");
                    VALIDATE("Diff. Qty. (Phys. Inventory)", Quantity - "Qty. (Phys. Inventory)");
                end;
            end;
        }
        field(815; "Inventory Entry Type"; Option)
        {
            Caption = 'Inventory Entry Type';
            OptionCaption = ' ,Positive Adjmt.,Negative Adjmt.';
            OptionMembers = " ","Positive Adjmt.","Negative Adjmt.";

            trigger OnValidate()
            var
                AgilesText001Txt: Label 'Änderung nur bei Inventurmenge 0 möglich !';
            begin
                if (CurrFieldNo = FieldNo("Inventory Entry Type"))
                and ("Inventory Entry Type" <> xRec."Inventory Entry Type")
                and ("Inventory Entry Type" = "Inventory Entry Type"::" ") then begin
                    TESTFIELD("Qty. (Phys. Inventory)", 0);
                    "Journal Template Name" := '';
                    "Journal Batch Name" := '';
                    "Item Journal Line" := 0;
                    "Diff. Qty. (Phys. Inventory)" := 0;
                end else
                    Error(AgilesText001Txt); //TODO: Schleifenfehler
            end;
        }
        field(820; "Diff. Qty. (Phys. Inventory)"; Decimal)
        {
            Caption = 'Diff. Qty. (Phys. Inventory)';
            DecimalPlaces = 0 : 5;
        }
        field(1016; "Subst Location Code"; Code[10])
        {
            Caption = 'Substitution Location Code';
            TableRelation = Location;
        }
        field(1017; "Subst Location Bin Code"; Code[10])
        {
            Caption = 'Substitution Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE ("Location Code"=FIELD("Subst Location Code"));
        }
        field(1030; "Subst Item No."; Code[20])
        {
            Caption = 'Substitution Item No.';
            TableRelation = Item;
        }
        field(1035; "Subst Item Description"; Text[50])
        {
            Caption = 'Substitution Item Description';
        }
        field(1036; "Subst Item Description 2"; Text[50])
        {
            Caption = 'Substitution Item Description 2';
        }
        field(1040; "Subst Unit of Measure Code"; Code[10])
        {
            Caption = 'Substitution Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Subst Item No."));
        }
        field(1042; "Subst Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Substitution Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(1045; "Subst Base Unit of Measure"; Code[10])
        {
            Caption = 'Substitution Base Unit of Measure';
            //TableRelation = "Unit of Measure" WHERE ("Is Base Unit of Measure"=CONST(true));
        }
        field(1046; "Subst Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Substitution Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
        }
        field(1047; "Subst Quantity (Base)"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Substitution Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(1050; "Subst Master Batch No."; Code[20])
        {
            Caption = 'Substitution Master Batch No.';
            TableRelation = "POI Master Batch";
        }
        field(1051; "Subst Batch No."; Code[20])
        {
            Caption = 'Substitution Batch No.';
            TableRelation = "POI Batch";
        }
        field(1052; "Subst Batch Variant No."; Code[20])
        {
            Caption = 'Substitution Batch Variant No.';
            TableRelation = "POI Batch Variant";
        }
        field(57000; Salesman; Code[30])
        {
            Caption = 'Salesman';
            Description = 'GME';
        }
        field(5110390; "Price Base (Purch. Price)"; Code[10])
        {
            Caption = 'Price Base (Purch. Price)';
            Editable = false;
            //TableRelation = "Price Base".Code WHERE ("Purch./Sales Price Calc."=CONST("Purch. Price"),
            //                                         Blocked=CONST(false));
        }
        field(5110391; "Purch. Price (Price Base)"; Decimal)
        {
            Caption = 'Purch. Price (Price Base)';
            Editable = false;
        }
        field(5110435; "Info 1"; Code[30])
        {
            CaptionClass = '5110300,1,1';
            Caption = 'Info 1';
            Description = 'BSI';
        }
        field(5110436; "Info 2"; Code[50])
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
        key(Key1; "Pallet No.", "Line No.")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key2; "Item No.", "Variant Code", Status)
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key3; "Item No.", "Variant Code", "Location Code", "Unit of Measure Code", "Master Batch No.", "Batch No.", "Batch Variant No.", "Location Bin Code")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key4; "Pallet No.", Status, "Location Code", "Location Bin Code")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key5; "Batch Variant No.", Quantity)
        {
        }
        key(Key6; "Item No.", "Location Code", "Location Bin Code", "Unit of Measure Code", "Date of Expiry")
        {
        }
        key(Key7; "Journal Template Name", "Journal Batch Name", "Item Journal Line")
        {
        }
        key(Key8; "Location Code", "Location Bin Code", "Item No.", "Unit of Measure Code", "Batch Variant No.")
        {
        }
        key(Key9; Salesman, "Item Description", "Item No.")
        {
            SumIndexFields = "Quantity (Base)";
        }
        key(Key10; Status, "Item No.", "Location Code", "Location Bin Code")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key11; "Batch Variant No.", "Batch No.", "Master Batch No.", "Item No.", "Location Code", "Unit of Measure Code", "Variant Code", "Location Bin Code")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
    }

    trigger OnDelete()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        lcu_PalletManagement.CheckDeletePallet("Pallet No.", 0, 0, 0, 0, "Pallet No.", "Line No.");
        IF (Status = Status::" ") OR
           (Status = Status::Opened) THEN
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", -"Quantity (Base)", '', '', '')
        ELSE
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, '', '', '');
    end;

    trigger OnInsert()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";

    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_PalletItemLines.SETCURRENTKEY("Pallet No.", Status, "Location Code", "Location Bin Code");
            lrc_PalletItemLines.SETRANGE("Pallet No.", "Pallet No.");
            IF lrc_PalletItemLines.FIND('+') THEN
                "Line No." := lrc_PalletItemLines."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        "Creation Date" := TODAY();
        "Creation From Userid" := copystr(USERID(), 1, 50);

        IF (Status = Status::" ") OR (Status = Status::Opened) THEN
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", "Quantity (Base)", '', '', '')
        ELSE
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, '', '', '');
    end;

    trigger OnModify()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        "Change Date" := TODAY();
        "Change From Userid" := copystr(USERID(), 1, 50);

        lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0,
                                                        xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
    end;

    trigger OnRename()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        "Change Date" := TODAY();
        "Change From Userid" := copystr(USERID(), 1, 50);

        lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0,
                                                       xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
    end;

    procedure FillFromIncomingPallet(var rrc_IncomingPallet: Record "POI Incoming Pallet")
    var
        lrc_Pallets: Record "POI Pallets";
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_UnitofMeasure: Record "Unit of Measure";
    begin
        // -------------------------------------------------------------------------------------------
        // Palettenzeile mit den Daten aus der "Incoming Pallet" füllen
        // Folgende Felder werden in der aufrufenden Funktion zugewiesen
        // Source, "Posting Date"
        // -------------------------------------------------------------------------------------------

        lrc_Pallets.GET(rrc_IncomingPallet."Pallet No.");
        rrc_IncomingPallet.GetPurchInfoFromPurchOrder(lrc_PurchaseHeader, lrc_PurchaseLine);

        "Pallet No." := lrc_Pallets."No.";
        "NVE No." := lrc_Pallets."NVE No.";
        "Item No." := rrc_IncomingPallet."Item No.";
        "Item Description" := rrc_IncomingPallet."Item Description";
        "Item Description 2" := rrc_IncomingPallet."Item Description 2";
        "Variant Code" := rrc_IncomingPallet."Variant Code";
        "Location Code" := rrc_IncomingPallet."Location Code";
        "Location Bin Code" := rrc_IncomingPallet."Location Bin Code";
        "Unit of Measure Code" := rrc_IncomingPallet."Unit of Measure Code";
        "Base Unit of Measure" := rrc_IncomingPallet."Base Unit of Measure";
        "Qty. per Unit of Measure" := rrc_IncomingPallet."Qty. per Unit of Measure";
        Quantity := rrc_IncomingPallet.Quantity;
        "Quantity (Base)" := rrc_IncomingPallet."Quantity (Base)";
        "Master Batch No." := rrc_IncomingPallet."Master Batch No.";
        "Batch No." := rrc_IncomingPallet."Batch No.";
        "Batch Variant No." := rrc_IncomingPallet."Batch Variant No.";
        "Source No." := rrc_IncomingPallet."Document No.";
        "Source Line No." := rrc_IncomingPallet."Document Line No.";
        Status := Status::Opened;
        "Vendor No." := lrc_PurchaseHeader."Buy-from Vendor No.";
        "Vendor Name" := lrc_PurchaseHeader."Buy-from Vendor Name";
        "Salesman/Purchaser Code" := lrc_PurchaseHeader."Purchaser Code";
        "Pallet Unit Code" := rrc_IncomingPallet."Pallet Transport Unit Code";
        "Pallet Freight Unit Code" := rrc_IncomingPallet."Pallet Freight Unit Code";
        "Lot No." := rrc_IncomingPallet."Lot No.";
        "Date of Expiry" := rrc_IncomingPallet."Date of Expiry";
        "Owner Vendor No." := rrc_IncomingPallet."Owner Vendor No.";
        "Owner Name" := rrc_IncomingPallet."Owner Name";
        "Owner Comment" := rrc_IncomingPallet."Owner Comment";
        "Info 1" := rrc_IncomingPallet."Info 1";
        "Info 2" := rrc_IncomingPallet."Info 2";
        "Info 3" := rrc_IncomingPallet."Info 3";
        "Info 4" := rrc_IncomingPallet."Info 4";

        lrc_UnitofMeasure.GET(rrc_IncomingPallet."Unit of Measure Code");
        //"Gross Weight" := lrc_UnitofMeasure."Gross Weight"; //TODO: Grossweight in unit of measure

        //"Price Base (Purch. Price)" := lrc_PurchaseLine."Price Base (Purch. Price)"; //TODO: Price Base in Purchase line
        //"Purch. Price (Price Base)" := lrc_PurchaseLine."Purch. Price (Price Base)";
    end;

    var
        lrc_PalletItemLines: Record "POI Pallet - Item Lines";
}

