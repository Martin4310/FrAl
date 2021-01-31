table 5110445 "POI Incoming Pallet"
{
    Caption = 'Incoming Pallet';
    // DrillDownFormID = Form5088048;
    // LookupFormID = Form5110550;

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
            ValidateTableRelation = false;
        }
        field(11; "Pos./Neg. Adjustment"; Option)
        {
            Caption = 'Pos./Neg. Adjustment';
            OptionCaption = 'Pos. Adjustment,Neg. Adjustment';
            OptionMembers = "Pos. Adjustment","Neg. Adjustment";

            trigger OnValidate()
            var
                AgilesText001Txt: Label 'Die Menge muss < 0 sein !';
                AgilesText002Txt: Label 'Die Menge muss >= 0 sein !';
            begin
                IF "Pos./Neg. Adjustment" = "Pos./Neg. Adjustment"::"Pos. Adjustment" THEN
                    IF Quantity < 0 THEN
                        ERROR(AgilesText002Txt);
                IF "Pos./Neg. Adjustment" <> "Pos./Neg. Adjustment"::"Pos. Adjustment" THEN
                    IF Quantity > 0 THEN
                        ERROR(AgilesText001Txt);
            end;
        }
        field(13; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Purchase Order,Packing Order,Physical Inventory,Partial Transfer,Sales Claim Advice,Sales Credit Memo,Transfer Order';
            OptionMembers = "Purchase Order","Packing Order","Physical Inventory","Partial Transfer","Sales Claim Advice","Sales Credit Memo","Transfer Order";
        }
        field(14; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = IF ("Document Type" = CONST("Purchase Order")) "Purchase Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF ("Document Type" = CONST("Packing Order")) "POI Pack. Order Header"."No."
            // ELSE
            // IF ("Document Type" = CONST("Sales Claim Advice")) "Sales Claim Notify Header"."No."
            ELSE
            IF ("Document Type" = CONST("Sales Credit Memo")) "Sales Header"."No." WHERE("Document Type" = CONST("Credit Memo"))
            ELSE
            IF ("Document Type" = CONST("Transfer Order")) "Transfer Header"."No.";
        }
        field(15; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            TableRelation = IF ("Document Type" = CONST("Purchase Order")) "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                                                                       "Document No." = FIELD("Document No."))
            ELSE
            IF ("Document Type" = CONST("Packing Order")) "POI Pack. Order Output Items"."Line No." WHERE("Doc. No." = FIELD("Document No."),
            "Line No." = FIELD("Line No."))
            // ELSE
            // IF ("Document Type" = CONST("Sales Claim Advice")) "Sales Claim Notify Line"."Line No." WHERE("Document No." = FIELD("Document No."))
            ELSE
            IF ("Document Type" = CONST("Sales Credit Memo")) "Sales Line"."Line No." WHERE("Document Type" = CONST("Credit Memo"), "Document No." = FIELD("Document No."));

            trigger OnValidate()
            begin
                IF "Document Line No." <> 0 THEN
                    CASE
                      "Document Type" OF
                        "Document Type"::"Purchase Order":
                            BEGIN
                                lrc_PurchaseLine.RESET();
                                lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
                                lrc_PurchaseLine.SETRANGE("Document No.", "Document No.");
                                lrc_PurchaseLine.SETRANGE("Line No.", "Document Line No.");
                                lrc_PurchaseLine.FIND('-');

                                IF (lrc_PurchaseLine.Type <> lrc_PurchaseLine.Type::Item) OR
                                   (lrc_PurchaseLine."No." = '') THEN
                                    ERROR('Es sind nur Artikelzeilen zulässig!');

                                IF lrc_PurchaseLine.Quantity >= 0 THEN
                                    "Pos./Neg. Adjustment" := "Pos./Neg. Adjustment"::"Pos. Adjustment"
                                ELSE
                                    "Pos./Neg. Adjustment" := "Pos./Neg. Adjustment"::"Neg. Adjustment";

                                "Item No." := lrc_PurchaseLine."No.";
                                "Variant Code" := lrc_PurchaseLine."Variant Code";
                                "Unit of Measure Code" := lrc_PurchaseLine."Unit of Measure Code";
                                Quantity := lrc_PurchaseLine.Quantity;
                                "Master Batch No." := lrc_PurchaseLine."POI Master Batch No.";
                                "Batch No." := lrc_PurchaseLine."POI Batch No.";
                                "Batch Variant No." := lrc_PurchaseLine."POI Batch Variant No.";
                            END;
                        "Document Type"::"Packing Order":
                            BEGIN
                                lrc_PackOrderOutputItems.RESET();
                                lrc_PackOrderOutputItems.SETRANGE("Doc. No.", "Document No.");
                                lrc_PackOrderOutputItems.SETRANGE("Line No.", "Document Line No.");
                                lrc_PackOrderOutputItems.FIND('-');

                                IF (lrc_PackOrderOutputItems."Item No." = '') THEN
                                    ERROR('Es sind nur Artikelzeilen zulässig!');

                                IF lrc_PackOrderOutputItems.Quantity >= 0 THEN
                                    "Pos./Neg. Adjustment" := "Pos./Neg. Adjustment"::"Pos. Adjustment"
                                ELSE
                                    "Pos./Neg. Adjustment" := "Pos./Neg. Adjustment"::"Neg. Adjustment";

                                "Item No." := lrc_PackOrderOutputItems."Item No.";
                                "Variant Code" := lrc_PackOrderOutputItems."Variant Code";
                                "Unit of Measure Code" := lrc_PackOrderOutputItems."Unit of Measure Code";
                                Quantity := lrc_PackOrderOutputItems.Quantity;
                                "Master Batch No." := lrc_PackOrderOutputItems."Master Batch No.";
                                "Batch No." := lrc_PackOrderOutputItems."Batch No.";
                                "Batch Variant No." := lrc_PackOrderOutputItems."Batch Variant No.";
                            END;
                    END;
            end;
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            TableRelation = Item;

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF "Item No." <> '' THEN BEGIN
                    lrc_Item.GET("Item No.");
                    "Item Description" := copystr(lrc_Item.Description, 1, 50);
                    "Item Description 2" := lrc_Item."Description 2";
                END;
            end;
        }
        field(21; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            Editable = false;
        }
        field(25; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(26; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(40; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));

            trigger OnValidate()
            var
                lrc_itemUnitOfMeasure: Record "Item Unit of Measure";
            begin
                "Qty. per Unit of Measure" := 0;
                IF "Unit of Measure Code" <> '' THEN BEGIN
                    lrc_itemUnitOfMeasure.GET("Item No.", "Unit of Measure Code");
                    lrc_itemUnitOfMeasure.TESTFIELD("Qty. per Unit of Measure");
                    "Qty. per Unit of Measure" := lrc_itemUnitOfMeasure."Qty. per Unit of Measure";
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
                    TESTFIELD("Pos./Neg. Adjustment", "Pos./Neg. Adjustment"::"Pos. Adjustment")
                ELSE
                    IF Quantity < 0 THEN
                        TESTFIELD("Pos./Neg. Adjustment", "Pos./Neg. Adjustment"::"Neg. Adjustment");
                "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
            end;
        }
        field(44; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(45; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
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
            Editable = false;
            TableRelation = "POI Master Batch";
        }
        field(51; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
            Editable = false;
            TableRelation = "POI Batch";
        }
        field(52; "Batch Variant No."; Code[20])
        {
            Caption = 'Batch Variant No.';
            Editable = false;
            TableRelation = "POI Batch Variant";
        }
        field(53; "Status Batch Variant No."; Option)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("POI Batch Variant".State WHERE("No." = FIELD("Batch Variant No.")));
            Caption = 'Status Batch Variant No.';
            Description = 'Flowfield';
            Editable = false;

            OptionCaption = 'Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,Manuell Gesperrt,Löschung';
            OptionMembers = Neuanlage,Offen,Geschlossen,Abgerechnet,Gesperrt,"Manuell Gesperrt","Löschung";
        }
        field(54; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
        }
        field(55; "Date of Expiry"; Date)
        {
            Caption = 'Date of Expiry';
        }
        field(60; "Pallet Transport Unit Code"; Code[10])
        {
            Caption = 'Pallet Transport Unit Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(61; "Pallet Freight Unit Code"; Code[10])
        {
            Caption = 'Pallet Freight Unit Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(70; "Container No."; Code[20])
        {
            Caption = 'Container No.';
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
                Vendor: Record Vendor;
            begin
                IF Vendor.GET("Owner Vendor No.") THEN
                    VALIDATE("Owner Name", Vendor.Name);
            end;
        }
        field(200; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location;

            trigger OnValidate()
            var
                lcu_PalletManagement: Codeunit "POI Pallet Management";
            begin
                IF "Location Code" = '' THEN
                    "Location Bin Code" := ''
                ELSE
                    IF "Location Code" <> xRec."Location Code" THEN
                        "Location Bin Code" := '';

                IF "Location Code" <> xRec."Location Code" THEN
                    lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");

            end;
        }
        field(201; "Location Bin Code"; Code[10])
        {
            Caption = 'Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE("Location Code"=FIELD("Location Code")); //TODO: location bins

            trigger OnValidate()
            var

                lcu_PalletManagement: Codeunit "POI Pallet Management";
                AgilesText01Txt: Label 'Der Stellplatz muss dem Stellplatz der Palette %1 entsprechen !', Comment = '%1';

            begin
                lcu_PalletManagement.IsLocationBinFree("Location Code", "Location Bin Code", "Pallet No.");

                lrc_Pallets.GET("Pallet No.");
                case lrc_Pallets."Location Bin Code" of
                    '':
                        begin
                            lrc_Pallets.VALIDATE("Location Bin Code", "Location Bin Code");
                            lrc_Pallets.MODIFY();
                        end;
                    xRec."Location Bin Code":
                        begin
                            lrc_Pallets.VALIDATE("Location Bin Code", "Location Bin Code");
                            lrc_Pallets.MODIFY();
                        end;
                    else
                        if lrc_Pallets."Location Bin Code" <> "Location Bin Code" THEN
                            ERROR(AgilesText01Txt);
                end;
                IF "Location Bin Code" <> xRec."Location Bin Code" THEN
                    lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
            end;
        }
        field(300; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
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
        field(500; "Vendor Pallet No."; Code[30])
        {
            Caption = 'Vendor Pallet No.';
        }
        field(501; "Shipping Agent Pallet No."; Code[30])
        {
            Caption = 'Shipping Agent Pallet No.';
        }
        field(502; "Warehouse Pallet No."; Code[30])
        {
            Caption = 'Warehouse Pallet No.';
        }
        field(510; "Producer Information"; Text[80])
        {
            Caption = 'Producer Information';
        }
        field(1020; "Subst Location Code"; Code[10])
        {
            Caption = 'Substitution Location Code';
            TableRelation = Location;
        }
        field(1025; "Subst Item Description"; Text[50])
        {
            Caption = 'Substitution Item Description';
        }
        field(1026; "Subst Item Description 2"; Text[50])
        {
            Caption = 'Substitution Item Description 2';
        }
        field(1040; "Subst Unit of Measure Code"; Code[10])
        {
            Caption = 'Substitution Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Subst Item No."));
        }
        field(1041; "Subst Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Substitution Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(1044; "Subst Base Unit of Measure"; Code[10])
        {
            Caption = 'Substitution Base Unit of Measure';
            //TableRelation = "Unit of Measure" WHERE ("Is Base Unit of Measure"=CONST(true)); //TODO: Is base unit of measure
        }
        field(1045; "Subst Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Substitution Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
        }
        field(1046; "Subst Quantity (Base)"; Decimal)
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
        field(1200; "Subst Location Bin Code"; Code[10])
        {
            Caption = 'Substitution Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE ("Location Code"=FIELD("Subst Location Code"));
        }
        field(1201; "Subst Item No."; Code[20])
        {
            Caption = 'Substitution Item No.';
            TableRelation = Item;
        }
        field(1250; "Qty. to Receive"; Decimal)
        {
            Caption = 'Qty. to Receive';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                AgilesText001Txt: Label '''Menge akt. Lieferung'' darf nicht größer als %1 sein', Comment = '%1';
            begin
                IF "Qty. to Receive" = 0 THEN
                    EXIT;
                IF "Qty. to Receive" > Quantity THEN
                    ERROR(AgilesText001Txt, Quantity);
            end;
        }
        field(1500; "Change to Purchase Line"; Integer)
        {
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = CONST(Order),
                                                              "Document No." = FIELD("Document No."),
                                                              Type = CONST(Item));

            trigger OnValidate()
            var
                lrc_PurchaseLine: Record "Purchase Line";
            begin

                IF "Line No." = 0 THEN
                    EXIT;

                lrc_PurchaseLine.GET(lrc_PurchaseLine."Document Type"::Order, "Document No.", "Change to Purchase Line");

                IF "Item No." <> lrc_PurchaseLine."No." THEN
                    ERROR('Artikelnr. abweichend!');
                IF "Unit of Measure Code" <> lrc_PurchaseLine."Unit of Measure Code" THEN
                    ERROR('Einheit ist abweichend!');

                "Document Line No." := lrc_PurchaseLine."Line No.";
                "Master Batch No." := lrc_PurchaseLine."POI Master Batch No.";
                "Batch No." := lrc_PurchaseLine."POI Batch No.";
                "Batch Variant No." := lrc_PurchaseLine."POI Batch Variant No.";

                "Change to Purchase Line" := 0;
                MODIFY();
            end;
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
        key(Key1; "Entry No.", "Line No.")
        {
        }
        key(Key2; "Entry No.", "Pallet No.")
        {
        }
        key(Key3; "Pallet No.")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key4; "Pallet No.", Posted, "Location Code", "Location Bin Code")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key5; "Item No.", "Variant Code", "Location Code", "Unit of Measure Code", "Master Batch No.", "Batch No.", "Batch Variant No.")
        {
            SumIndexFields = Quantity, "Quantity (Base)";
        }
        key(Key6; "Batch Variant No.")
        {
        }
        key(Key7; "Posted Document No.", "Posting Date")
        {
        }
        key(Key8; "Document Type", "Document No.", "Document Line No.", "Pallet No.")
        {
        }
        key(Key9; "Location Code", "Item No.", "Location Bin Code", "Pallet No.")
        {
        }
        key(Key10; "Document Type", "Document No.", "Document Line No.", Posted)
        {
            SumIndexFields = Quantity;
        }
        key(Key11; "Entry No.", Posted, "Document Type", "Document No.", "Document Line No.")
        {
        }
        key(Key12; "Entry No.", "Location Code", "Location Bin Code", "Item No.", "Pallet No.")
        {
        }
        key(Key13; "Vendor Pallet No.")
        {
        }
        key(Key14; "Shipping Agent Pallet No.")
        {
        }
        key(Key15; "Producer Information")
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
        lcu_PalletManagement.CheckDeletePallet("Pallet No.", "Entry No.", "Line No.", 0, 0, '', 0);
        IF Posted = FALSE THEN
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", -"Quantity (Base)", '', '', '')
        ELSE
            lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, '', '', '');
    end;

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_PurchPallet.SETRANGE("Entry No.", "Entry No.");
            IF lrc_PurchPallet.FIND('+') THEN
                "Line No." := lrc_PurchPallet."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        IF ("Pallet Transport Unit Code" = '') OR
           ("Pallet Freight Unit Code" = '') THEN BEGIN
            lrc_FruitVisionSetup.GET();
            IF ("Pallet Transport Unit Code" = '') THEN
                IF lrc_FruitVisionSetup."Default Pallet Unit Code" <> '' THEN
                    "Pallet Transport Unit Code" := lrc_FruitVisionSetup."Default Pallet Unit Code";

            IF ("Pallet Freight Unit Code" = '') THEN
                IF lrc_FruitVisionSetup."Default Pallet Freight Unit" <> '' THEN
                    "Pallet Freight Unit Code" := lrc_FruitVisionSetup."Default Pallet Freight Unit";
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
        lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
    end;

    trigger OnRename()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        lcu_PalletManagement.ActualLocationBinPalletNo("Pallet No.", "Location Code", "Location Bin Code", 0, xRec."Pallet No.", xRec."Location Code", xRec."Location Bin Code");
    end;

    procedure GetPurchInfoFromPurchOrder(var rrc_PurchaseHeader: Record "Purchase Header"; var rrc_PurchaseLine: Record "Purchase Line")
    begin
        // ----------------------------------------------------------------------------------------------------------
        // Funktion liefert die EK Info für die Palette
        // Die Variablen rrc_PurchaseHeader, rrc_PurchaseLine werden mit der Info gefüllt oder bleiben leer
        // ----------------------------------------------------------------------------------------------------------
        CLEAR(rrc_PurchaseHeader);
        CLEAR(rrc_PurchaseLine);
        IF "Entry No." = 0 THEN
            EXIT;

        IF "Pallet No." = '' THEN
            IF "Line No." = 0 THEN
                EXIT;


        IF "Document Type" = "Document Type"::"Purchase Order" THEN BEGIN
            IF NOT rrc_PurchaseHeader.GET(rrc_PurchaseHeader."Document Type"::Order, "Document No.") THEN
                EXIT;
            IF rrc_PurchaseLine.GET(rrc_PurchaseHeader."Document Type", rrc_PurchaseHeader."No.", "Document Line No.") THEN;
            EXIT;
        END;

        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Pallet No.");
        lrc_IncomingPallet.SETRANGE("Pallet No.");
        lrc_IncomingPallet.SETRANGE("Document Type", lrc_IncomingPallet."Document Type"::"Purchase Order");
        IF lrc_IncomingPallet.FIND('+') THEN BEGIN
            IF NOT rrc_PurchaseHeader.GET(rrc_PurchaseHeader."Document Type"::Order, lrc_IncomingPallet."Document No.") THEN
                EXIT;

            IF rrc_PurchaseLine.GET(rrc_PurchaseHeader."Document Type", rrc_PurchaseHeader."No.", lrc_IncomingPallet."Document Line No.") THEN;
            EXIT;
        END;

        lrc_Pallets.GET("Pallet No.");
        lrc_Pallets.GetPurchInfo(rrc_PurchaseHeader, rrc_PurchaseLine);
    end;

    procedure CreateFromOutgoingPallet(var rrc_OutgoingPallet: Record "POI Outgoing Pallet"; vco_LocationCode: Code[20]; vdc_Quantity: Decimal; vin_DocumentType: Integer)
    begin
        // -----------------------------------------------------------------------------------
        // Folgende Felder werden in der aufrufenden Funktion ermittelt:
        // Quantity, "Location Code", "Document Type"
        // -----------------------------------------------------------------------------------

        INIT();

        "Entry No." := rrc_OutgoingPallet."Entry No.";
        "Line No." := 0;
        INSERT(TRUE);

        VALIDATE("Document Type", vin_DocumentType);
        FillFromOutgoingPallet(rrc_OutgoingPallet);
        VALIDATE(Quantity, vdc_Quantity);
        VALIDATE("Qty. to Receive", Quantity);
        VALIDATE("Location Code", vco_LocationCode);
        MODIFY(TRUE);
    end;

    procedure FillFromOutgoingPallet(var rrc_OutgoingPallet: Record "POI Outgoing Pallet")
    begin
        // -----------------------------------------------------------
        // Eingehende Palettenzeile mit den Daten aus der Ausgehende Palettenzeile füllen
        // -----------------------------------------------------------
        "Document No." := rrc_OutgoingPallet."Document No.";
        "Document Line No." := rrc_OutgoingPallet."Document Line No.";
        "Pallet No." := rrc_OutgoingPallet."Pallet No.";
        "Item No." := rrc_OutgoingPallet."Item No.";
        "Item Description" := rrc_OutgoingPallet."Item Description";
        "Item Description 2" := rrc_OutgoingPallet."Item Description 2";
        "Variant Code" := rrc_OutgoingPallet."Variant Code";
        "Unit of Measure Code" := rrc_OutgoingPallet."Unit of Measure Code";
        "Base Unit of Measure" := rrc_OutgoingPallet."Base Unit of Measure";
        "Qty. per Unit of Measure" := rrc_OutgoingPallet."Qty. per Unit of Measure";
        "Master Batch No." := rrc_OutgoingPallet."Master Batch No.";
        "Batch No." := rrc_OutgoingPallet."Batch No.";
        "Batch Variant No." := rrc_OutgoingPallet."Batch Variant No.";
        "Lot No." := rrc_OutgoingPallet."Lot No.";
        "Pallet Transport Unit Code" := rrc_OutgoingPallet."Pallet Transport Unit Code";
        "Pallet Freight Unit Code" := rrc_OutgoingPallet."Pallet Freight Unit Code";
        "Owner Vendor No." := rrc_OutgoingPallet."Owner Vendor No.";
        "Owner Name" := rrc_OutgoingPallet."Owner Name";
        "Owner Comment" := rrc_OutgoingPallet."Owner Comment";
        "Info 1" := rrc_OutgoingPallet."Info 1";
        "Info 2" := rrc_OutgoingPallet."Info 2";
        "Info 3" := rrc_OutgoingPallet."Info 3";
        "Info 4" := rrc_OutgoingPallet."Info 4";
        "Location Bin Code" := '';
        "Date of Expiry" := rrc_OutgoingPallet."Date of Expiry";
    end;

    procedure SplitLine()
    begin
        lrc_IncomingPallet := Rec;
        lrc_IncomingPallet."Line No." := 0;
        lrc_IncomingPallet.Quantity := Quantity - "Qty. to Receive";
        lrc_IncomingPallet."Qty. to Receive" := lrc_IncomingPallet.Quantity;
        lrc_IncomingPallet.Posted := FALSE;
        lrc_IncomingPallet."Posted Document No." := '';
        lrc_IncomingPallet."Posted Document Line No." := 0;
        lrc_IncomingPallet.INSERT(TRUE);

        Quantity := "Qty. to Receive";
        "Qty. to Receive" := 0;
        MODIFY();
    end;

    var
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
        lrc_Pallets: Record "POI Pallets";
        lrc_PurchPallet: Record "POI Incoming Pallet";
        lrc_IncomingPallet: Record "POI Incoming Pallet";
}

