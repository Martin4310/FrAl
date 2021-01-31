table 5110500 "POI Pallets"
{


    Caption = 'Pallets';
    // DrillDownFormID = Form5087954;
    // LookupFormID = Form5087954;

    fields
    {
        field(1; "No."; Code[30])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                ChangeLocBinUnitOfMeasInLines();
            end;
        }
        field(11; "NVE No."; Code[30])
        {
            Caption = 'NVE No.';

            trigger OnValidate()
            var
                lrc_PalletItemLines: Record "POI Pallet - Item Lines";
            begin

                IF "NVE No." <> xRec."NVE No." THEN BEGIN
                    lrc_PalletItemLines.Reset();
                    lrc_PalletItemLines.SETRANGE("Pallet No.", "No.");
                    IF NOT lrc_PalletItemLines.ISEMPTY() THEN
                        ERROR(AgilesText004Txt);
                END;

            end;
        }
        field(12; "Pallet Unit Code"; Code[10])
        {
            Caption = 'Paletten Einheitencode';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));

            trigger OnValidate()
            var
                lrc_PalletItemLines: Record "POI Pallet - Item Lines";
            begin

                IF "Pallet Unit Code" <> xRec."Pallet Unit Code" THEN BEGIN
                    lrc_PalletItemLines.Reset();
                    lrc_PalletItemLines.SETRANGE("Pallet No.", "No.");
                    IF NOT lrc_PalletItemLines.ISEMPTY() THEN
                        ERROR(AgilesText002Txt);
                END;


                ChangeLocBinUnitOfMeasInLines();
            end;
        }
        field(13; "Pallet Freight Unit Code"; Code[10])
        {
            Caption = 'Pallet Freight Unit Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));

            trigger OnValidate()
            var
                lrc_PalletItemLines: Record "POI Pallet - Item Lines";
            begin

                IF "Pallet Freight Unit Code" <> xRec."Pallet Freight Unit Code" THEN BEGIN
                    lrc_PalletItemLines.Reset();
                    lrc_PalletItemLines.SETRANGE("Pallet No.", "No.");
                    IF NOT lrc_PalletItemLines.ISEMPTY() THEn
                        ERROR(AgilesText003Txt);
                END;


                ChangeLocBinUnitOfMeasInLines();
            end;
        }
        field(15; "Mix Pallet"; Boolean)
        {
            Caption = 'Mix Pallet';
        }
        field(90; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Purchase Order,Packing Order,Physical Inventory,Sales Order,Partial Transfer,Sales Claim Advice,Sales Credit Memo';
            OptionMembers = "Purchase Order","Packing Order","Physical Inventory","Sales Order","Partial Transfer","Sales Claim Advice","Sales Credit Memo";
        }
        field(91; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST("Purchase Order")) "Purchase Header"."No." WHERE("Document Type" = CONST(Order))
            // ELSE
            // IF (Source = CONST("Sales Claim Advice")) "Sales Claim Notify Header"."No."
            ELSE
            IF (Source = CONST("Sales Credit Memo")) "Sales Header"."No." WHERE("Document Type" = CONST("Credit Memo"));
        }
        field(92; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(100; "No. of Detail Lines"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Pallet - Item Lines" WHERE("Pallet No." = FIELD("No.")));
            Caption = 'No. of Units in Detail';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "No. of Incoming Lines"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Incoming Pallet" WHERE("Pallet No." = FIELD("No.")));
            Caption = 'No. of Incoming Lines';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "No. of Outgoing Lines"; Integer)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Count ("POI Outgoing Pallet" WHERE("Pallet No." = FIELD("No.")));
            Caption = 'No. of Outgoing Lines';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(150; "No. of Archiv Detail Lines"; Integer)
        // {
        //     BlankNumbers = BlankZero;
        //     CalcFormula = Count ("xArchiv Pallet - Item Lines" WHERE("Pallet No." = FIELD("No.")));
        //     Caption = 'No. of Archiv Units in Detail';
        //     Description = 'Flowfield';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(151; "No. of Archiv Incoming Lines"; Integer)
        // {
        //     BlankNumbers = BlankZero;
        //     CalcFormula = Count ("xArchiv Incoming Pallet" WHERE("Pallet No." = FIELD("No.")));
        //     Caption = 'No. of Archiv Incoming Lines';
        //     Description = 'Flowfield';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(152; "No. of Archiv Outgoing Lines"; Integer)
        // {
        //     BlankNumbers = BlankZero;
        //     CalcFormula = Count ("xArchiv Outgoing Pallet" WHERE("Pallet No." = FIELD("No.")));
        //     Caption = 'No. of Archiv Outgoing Lines';
        //     Description = 'Flowfield';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(200; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                lrc_PalletItemLines: Record "POI Pallet - Item Lines";
                lcu_PalletManagement: Codeunit "POI Pallet Management";

            begin
                IF "Location Code" = '' THEN
                    "Location Bin Code" := ''
                ELSE
                    IF "Location Code" <> xRec."Location Code" THEN
                        "Location Bin Code" := '';


                IF "Location Code" <> xRec."Location Code" THEN BEGIN
                    lrc_PalletItemLines.Reset();
                    lrc_PalletItemLines.SETRANGE("Pallet No.", "No.");
                    IF NOT lrc_PalletItemLines.ISEMPTY() THEN
                        ERROR(AgilesText001Txt);

                END;


                lcu_PalletManagement.IsLocationBinFree("Location Code", "Location Bin Code", "No.");

                ChangeLocBinUnitOfMeasInLines();

                IF "Location Code" <> xRec."Location Code" THEN
                    lcu_PalletManagement.ActualLocationBinPalletNo("No.", "Location Code", "Location Bin Code", 0,
                                                                    xRec."No.", xRec."Location Code", xRec."Location Bin Code");
            end;
        }
        field(201; "Location Bin Code"; Code[10])
        {
            Caption = 'Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE("Location Code" = FIELD("Location Code"));

            // trigger OnValidate() //TODO: Location bin code
            // var
            //     lrc_Location: Record Location;
            //     lcu_PalletManagement: Codeunit "POI Pallet Management";
            //     AgilesText01Txt: Label 'Bei Lagerort %1 muss ein Stellplatz eingegeben werden !';
            // begin
            //     IF "Location Bin Code" = '' THEN
            //         IF "Location Code" <> '' THEN BEGIN
            //             lrc_Location.GET("Location Code");
            //             IF lrc_Location."Location Bin Pallets Required" = TRUE THEN
            //                 ERROR(AgilesText01Txt, "Location Code");
            //         END;

            //     lcu_PalletManagement.IsLocationBinFree("Location Code", "Location Bin Code", "No.");

            //     ChangeLocBinUnitOfMeasInLines();

            //     IF "Location Bin Code" <> xRec."Location Bin Code" THEN
            //         lcu_PalletManagement.ActualLocationBinPalletNo("No.", "Location Code", "Location Bin Code", 0,
            //                                                         xRec."No.", xRec."Location Code", xRec."Location Bin Code");

            //     IF lrc_Location.GET("Location Code") THEN BEGIN
            //         IF "Location Bin Code" <> lrc_Location."Release Location Bin Code" THEN
            //             VALIDATE("Release From Location Bin Code", '');
            //     END ELSE
            //         VALIDATE("Release From Location Bin Code", '');
            // end;
        }
        field(202; "Release From Location Bin Code"; Code[10])
        {
            Caption = 'Release From Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE("Location Code" = FIELD("Location Code"));

            // trigger OnValidate() //TODO: Location bin code
            // var
            //     lrc_Location: Record Location;
            //     lcu_PalletManagement: Codeunit "POI Pallet Management";
            //     AgilesText01Txt: Label 'Bei Lagerort %1 muss ein Stellplatz eingegeben werden !';
            // begin
            //     IF CurrFieldNo = FIELDNO("Release From Location Bin Code") THEN BEGIN
            //         IF "Release From Location Bin Code" = '' THEN
            //             IF "Location Code" <> '' THEN BEGIN
            //                 lrc_Location.GET("Location Code");
            //                 IF lrc_Location."Location Bin Pallets Required" = TRUE THEN
            //                     ERROR(AgilesText01Txt, "Location Code");

            //             END;

            //         lcu_PalletManagement.IsLocationBinFree("Location Code", "Location Bin Code", "No.");
            //     END;

            //     ChangeLocBinUnitOfMeasInLines();
            // end;
        }
        field(300; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(301; "Creation From User-ID"; Code[20])
        {
            Caption = 'Created from User ID';
            Editable = false;
            TableRelation = "User Setup";
        }
        field(305; "Change Date"; Date)
        {
            Caption = 'Change Date';
            Editable = false;
        }
        field(306; "Change From User-ID"; Code[20])
        {
            Caption = 'Change from User ID';
            Editable = false;
            TableRelation = "User Setup";
        }
        field(310; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(480; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(500; "Vendor Pallet No."; Code[30])
        {
            Caption = 'Vendor Pallet No.';
        }
        field(501; "Warehouse Pallet No."; Code[30])
        {
            Caption = 'Warehouse Pallet No.';
        }
        field(510; "Producer Information"; Text[80])
        {
            Caption = 'Producer Information';
        }
        field(600; "Temp. Recorder Serial No."; Code[20])
        {
            Caption = 'Temp. Recorder Serial No.';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Vendor Pallet No.")
        {
        }
        key(Key3; "Warehouse Pallet No.")
        {
        }
        key(Key4; "Producer Information")
        {
        }
        key(Key5; Source, "Source No.", "Source Line No.", "Vendor Pallet No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var

        lrc_LocationBinPalletNo: Record "POI Location Bin - Pallet No.";
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin

        lrc_PalletItemLines.Reset();
        lrc_PalletItemLines.SETRANGE("Pallet No.", "No.");
        IF NOT lrc_PalletItemLines.ISEMPTY() THEn
            ERROR(AgilesText005Txt);


        lrc_PalletItemLines.Reset();
        lrc_PalletItemLines.SETRANGE("Pallet No.", "No.");
        IF lrc_PalletItemLines.FIND('-') THEN
            lrc_PalletItemLines.DELETEALL(); // kein DELETEALL( TRUE );


        lrc_IncomingPallet.Reset();
        lrc_IncomingPallet.SETRANGE("Pallet No.", "No.");
        IF lrc_IncomingPallet.FIND('-') THEN
            lrc_IncomingPallet.DELETEALL(); // kein DELETEALL( TRUE );


        lrc_OutgoingPallet.Reset();
        lrc_OutgoingPallet.SETRANGE("Pallet No.", "No.");
        IF lrc_OutgoingPallet.FIND('-') THEN
            lrc_OutgoingPallet.DELETEALL(); // kein DELETEALL( TRUE );


        lrc_LocationBinPalletNo.Reset();
        lrc_LocationBinPalletNo.SETRANGE("Pallet No.", "No.");
        IF lrc_LocationBinPalletNo.FIND('-') THEN
            lrc_LocationBinPalletNo.DELETEALL(TRUE);

        lcu_PalletManagement.ActualLocationBinPalletNo("No.", "Location Code", "Location Bin Code", 0,
                                                          '', '', '');
    end;

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_PalletManagement: Codeunit "POI Pallet Management";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;

    begin
        // Palettennummer aus Standard Nr. Serie vergeben falls leer
        IF "No." = '' THEN BEGIN
            lrc_FruitVisionSetup.GET();
            lrc_FruitVisionSetup.TESTFIELD("Pallet No. No. Serie");
            "No." := lcu_NoSeriesManagement.GetNextNo(lrc_FruitVisionSetup."Pallet No. No. Serie", TODAY(), TRUE);
        END;

        "Creation Date" := TODAY();
        "Creation From User-ID" := copystr(USERID(), 1, 20);

        lcu_PalletManagement.ActualLocationBinPalletNo("No.", "Location Code", "Location Bin Code", 0, '', '', '');
    end;

    trigger OnModify()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        "Change Date" := TODAY();
        "Change From User-ID" := copystr(USERID(), 1, 20);

        lcu_PalletManagement.ActualLocationBinPalletNo("No.", "Location Code", "Location Bin Code", 0, xRec."No.", xRec."Location Code", xRec."Location Bin Code");
    end;

    trigger OnRename()
    var
        lcu_PalletManagement: Codeunit "POI Pallet Management";
    begin
        "Change Date" := TODAY();
        "Change From User-ID" := copystr(USERID(), 1, 20);

        lcu_PalletManagement.ActualLocationBinPalletNo("No.", "Location Code", "Location Bin Code", 0, xRec."No.", xRec."Location Code", xRec."Location Bin Code");
    end;

    var
        AgilesText001Txt: Label 'Location Code kann''t be changed. The Item Lines already exist.';
        AgilesText002Txt: Label 'Pallet Unit Code kann''t be changed. The Item Lines already exist.';
        AgilesText003Txt: Label 'Pallet Freight Unit Code kann''t be changed. The Item Lines already exist.';
        AgilesText004Txt: Label 'NVE No. kann''t be changed. The Item Lines already exist.';
        AgilesText005Txt: Label 'Pallet kann''t be deleted. The Item Lines already exist.';

    procedure ChangeLocBinUnitOfMeasInLines()
    begin
        // -------------------------------------------------------------------------------
        // Funktion zur Übertragung Lager und Stellplatz in die Palettenzeilen
        // -------------------------------------------------------------------------------

        lrc_PalletItemLines.RESET();
        lrc_PalletItemLines.SETRANGE("Pallet No.", "No.");
        IF lrc_PalletItemLines.FIND('-') THEN
            REPEAT

                lrc_PalletItemLines."Location Code" := "Location Code";
                lrc_PalletItemLines."Location Bin Code" := "Location Bin Code";
                lrc_PalletItemLines."Release From Location Bin Code" := "Release From Location Bin Code";
                lrc_PalletItemLines."Pallet Unit Code" := "Pallet Unit Code";
                lrc_PalletItemLines."Pallet Freight Unit Code" := "Pallet Freight Unit Code";
                lrc_PalletItemLines."NVE No." := "NVE No.";
                lrc_PalletItemLines.MODIFY();

            UNTIL lrc_PalletItemLines.NEXT() = 0;

        lrc_IncomingPallet.RESET();
        lrc_IncomingPallet.SETCURRENTKEY("Pallet No.");
        lrc_IncomingPallet.SETRANGE("Pallet No.", "No.");
        IF lrc_IncomingPallet.FIND('-') THEN
            REPEAT

                lrc_IncomingPallet."Location Code" := "Location Code";
                lrc_IncomingPallet."Location Bin Code" := "Location Bin Code";
                lrc_IncomingPallet."Pallet Transport Unit Code" := "Pallet Unit Code";
                lrc_IncomingPallet."Pallet Freight Unit Code" := "Pallet Freight Unit Code";
                lrc_IncomingPallet.MODIFY();

            UNTIL lrc_IncomingPallet.NEXT() = 0;

        lrc_OutgoingPallet.Reset();
        lrc_OutgoingPallet.SETCURRENTKEY("Pallet No.");
        lrc_OutgoingPallet.SETRANGE("Pallet No.", "No.");
        IF lrc_OutgoingPallet.FIND('-') THEN
            REPEAT

                lrc_OutgoingPallet."Location Code" := "Location Code";
                lrc_OutgoingPallet."Location Bin Code" := "Location Bin Code";
                lrc_OutgoingPallet."Release From Location Bin Code" := "Release From Location Bin Code";
                lrc_OutgoingPallet.MODIFY();

            UNTIL lrc_OutgoingPallet.NEXT() = 0;
    end;

    procedure GetPurchInfo(var rrc_PurchaseHeader: Record "Purchase Header"; var rrc_PurchaseLine: Record "Purchase Line")
    begin
        // ----------------------------------------------------------------------------------------------------------
        // Funktion liefert die EK Info für die Palette
        // Die Variablen rrc_PurchaseHeader, rrc_PurchaseLine werden mit der Info gefüllt oder bleiben leer
        // ----------------------------------------------------------------------------------------------------------


        CLEAR(rrc_PurchaseHeader);
        CLEAR(rrc_PurchaseLine);

        IF "No." = '' THEN
            EXIT;

        IF "Source No." = '' THEN
            EXIT;

        CASE Source OF
            Source::"Purchase Order":
                rrc_PurchaseHeader."Document Type" := rrc_PurchaseHeader."Document Type"::Order;
            ELSE
                EXIT;
        END;

        IF NOT rrc_PurchaseHeader.GET(rrc_PurchaseHeader."Document Type", "Source No.") THEN
            EXIT;
        IF rrc_PurchaseLine.GET(rrc_PurchaseHeader."Document Type", rrc_PurchaseHeader."No.", "Source Line No.") THEN;
    end;

    var
        lrc_PalletItemLines: Record "POI Pallet - Item Lines";
        lrc_IncomingPallet: Record "POI Incoming Pallet";
        lrc_OutgoingPallet: Record "POI Outgoing Pallet";
}

