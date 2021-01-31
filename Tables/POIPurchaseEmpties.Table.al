table 5110454 "POI Purchase Empties"
{
    Caption = 'Purchase Empties';

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Customer,Vendor,Shipping Agent';
            OptionMembers = Customer,Vendor,"Shipping Agent";

            trigger OnValidate()
            begin
                IF xRec.Source <> Rec.Source THEN BEGIN
                    TESTFIELD("Rec. Qty. Received", 0);
                    TESTFIELD("Rec. Qty. Invoiced", 0);
                    TESTFIELD("Ship. Qty. Invoiced", 0);
                    TESTFIELD("Ship. Qty. Shipped", 0);
                    "Source No." := '';
                END;

                IF Source = Source::Customer THEN
                    ERROR(SSPText01Txt);

                IF Source = Source::"Shipping Agent" THEN
                    "Empties Calculation" := "Empties Calculation"::"Separat Document";
            end;
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Customer)) Customer."No."
            ELSE
            IF (Source = CONST(Vendor)) Vendor."No."
            ELSE
            IF (Source = CONST("Shipping Agent")) "Shipping Agent".Code;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
                lrc_Vendor: Record Vendor;
                lrc_ShippingAgent: Record "Shipping Agent";
                lrc_PurchaseHeader: Record "Purchase Header";
                SSPText011Txt: Label 'There exist no purchase line for producer %1 !', Comment = '%1';
                SSPText04Txt: Label 'On producer, this value must be %1 !', Comment = '%1';
                SSPText05Txt: Label 'separat document';
                SSPText01Txt: Label 'There exist no purchase line for shipping agent %1 !', Comment = '%1';
            //SSPText010Txt: Label 'The vendor must be %1 !';
            begin
                IF xRec."Source No." <> Rec."Source No." THEN BEGIN
                    TESTFIELD("Rec. Qty. Received", 0);
                    TESTFIELD("Rec. Qty. Invoiced", 0);
                    TESTFIELD("Ship. Qty. Invoiced", 0);
                    TESTFIELD("Ship. Qty. Shipped", 0);
                END;

                IF ("Source No." <> xRec."Source No.") AND ("Source No." <> '') THEN
                    CASE Source OF
                        Source::Customer:
                            IF lrc_Customer.GET("Source No.") THEN BEGIN
                                VALIDATE("Empties Allocation", lrc_Customer."POI Empties Allocation");
                                VALIDATE("Empties Calculation", lrc_Customer."POI Empties Calculation");
                            END;
                        Source::Vendor:
                            BEGIN
                                IF lrc_Vendor.GET("Source No.") THEN BEGIN
                                    VALIDATE("Empties Allocation", lrc_Vendor."POI Empties Allocation");
                                    VALIDATE("Empties Calculation", lrc_Vendor."POI Empties Calculation");
                                END;
                                IF lrc_PurchaseHeader.GET("Document Type", "Document No.") THEN
                                    IF lrc_PurchaseHeader."Buy-from Vendor No." <> "Source No." THEN BEGIN
                                        lrc_PurchaseLine.RESET();
                                        lrc_PurchaseLine.SETRANGE("Document Type", "Document Type");
                                        lrc_PurchaseLine.SETRANGE("Document No.", "Document No.");
                                        lrc_PurchaseLine.SETRANGE("POI Manufacturer Code", "Source No.");
                                        IF NOT lrc_PurchaseLine.FIND('-') THEN
                                            // Es existieren keine Einkaufszeilen für diesen Produzenten %1
                                            ERROR(SSPText011Txt, "Source No.")
                                        ELSE
                                            IF ("Empties Calculation" = "Empties Calculation"::"Same Document") THEN BEGIN
                                                MESSAGE(SSPText04Txt, SSPText05Txt);
                                                VALIDATE("Empties Calculation", "Empties Calculation"::"Separat Document");
                                            END;
                                    END;
                            END;
                        Source::"Shipping Agent":
                            BEGIN
                                lrc_ShippingAgent.GET("Source No.");

                                lrc_ShippingAgent.TESTFIELD("POI Ship.-Ag. Vendor No.");

                                lrc_Vendor.GET(lrc_ShippingAgent."POI Ship.-Ag. Vendor No.");

                                VALIDATE("Empties Allocation", lrc_ShippingAgent."POI Empties Allocation");
                                VALIDATE("Empties Calculation", lrc_ShippingAgent."POI Empties Calculation");

                                lrc_PurchaseLine.RESET();
                                lrc_PurchaseLine.SETRANGE("Document Type", "Document Type");
                                lrc_PurchaseLine.SETRANGE("Document No.", "Document No.");
                                lrc_PurchaseLine.SETRANGE("POI Shipping Agent Code", "Source No.");
                                IF lrc_PurchaseLine.IsEmpty() THEN
                                    // Es existieren keine Einkaufszeilen für diesen Zusteller %1
                                    ERROR(SSPText01Txt, "Source No.");
                            END;
                    END;

            end;
        }
        field(7; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));

            trigger OnValidate()
            var
                lrc_Item: Record Item;
            begin
                IF xRec."Item No." <> '' THEN BEGIN
                    TESTFIELD("Rec. Qty. Received", 0);
                    TESTFIELD("Rec. Qty. Invoiced", 0);
                    TESTFIELD("Ship. Qty. Shipped", 0);
                    TESTFIELD("Ship. Qty. Invoiced", 0);
                END;

                IF "Item No." <> '' THEN BEGIN
                    lrc_Item.GET("Item No.");
                    "Unit of Measure Code" := lrc_Item."Sales Unit of Measure";
                    "Item Description" := lrc_Item.Description;
                    "Item Description 2" := lrc_Item."Description 2";
                    "Item Typ" := lrc_Item."POI Item Typ";
                END ELSE BEGIN
                    "Unit of Measure Code" := '';
                    "Item Description" := '';
                    "Item Description 2" := '';
                END;
            end;
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            begin
                IF xRec."Location Code" <> Rec."Location Code" THEN BEGIN
                    TESTFIELD("Rec. Qty. Received", 0);
                    TESTFIELD("Rec. Qty. Invoiced", 0);
                    TESTFIELD("Ship. Qty. Shipped", 0);
                    TESTFIELD("Ship. Qty. Invoiced", 0);
                END;

                VALIDATE("Rec. Location Code", "Location Code");
                VALIDATE("Ship. Location Code", "Location Code");
            end;
        }
        field(10; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(11; "Item Description 2"; Text[50])
        {
            Caption = 'Item Description 2';
        }
        field(14; "Item Typ"; Option)
        {
            Caption = 'Item Typ';
            OptionCaption = 'Trade Item,,Empties Item,Transport Item,,Packing Material,,,Spare Parts';
            OptionMembers = "Trade Item",,"Empties Item","Transport Item",,"Packing Material",,,"Spare Parts";
        }
        field(15; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(18; "Rec. Location Code"; Code[10])
        {
            Caption = 'Rec. Location Code';
            TableRelation = Location;
        }
        field(19; "Rec. Calc. Quantity"; Decimal)
        {
            Caption = 'Rec. Calc. Quantity';
        }
        field(20; "Rec. Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                lrc_FruitVisionSetup: Record "POI ADF Setup";
                //lrc_RefundCosts: Record "POI Empties/Transport Refund Cost";
                lrc_PurchaseHeader: Record "Purchase Header";
                lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
                ldt_Date: Date;
            begin
                lrc_FruitVisionSetup.GET();
                IF lrc_FruitVisionSetup."Empties/Transport Type" = lrc_FruitVisionSetup."Empties/Transport Type"::"Systematik 1" THEN BEGIN
                    // Pfandpreise ermitteln
                    lrc_PurchaseHeader.GET("Document Type", "Document No.");
                    ldt_Date := lrc_PurchaseHeader."Order Date";
                    IF ldt_Date = 0D THEN
                        ldt_Date := lrc_PurchaseHeader."Document Date";
                    // Pfand Eingangspreis
                    lcu_EmptiesManagement.CalculateEmptiesShipmentPrice("Item No.",
                                                                          Source,
                                                                          "Source No.",
                                                                          "Location Code",
                                                                          ldt_Date,
                                                                          1,
                                                                          1,
                                                                          "Rec. Refund Price");
                END;

                VALIDATE("Rec. Refund Price");

                IF ("Rec. Quantity" * "Rec. Qty. Received" < 0) OR
                   (ABS("Rec. Quantity") < ABS("Rec. Qty. Received"))
                THEN
                    FIELDERROR("Rec. Quantity", STRSUBSTNO(SSPText06Txt, FIELDCAPTION("Rec. Qty. Received")));

                IF ("Rec. Quantity" * "Rec. Qty. Invoiced" < 0) OR
                   (ABS("Rec. Quantity") < ABS("Rec. Qty. Invoiced"))
                THEN
                    FIELDERROR("Rec. Quantity", STRSUBSTNO(SSPText06Txt, FIELDCAPTION("Rec. Qty. Invoiced")));

                "Rec. Qty. to Receive" := "Rec. Quantity" - "Rec. Qty. Received";

                IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                   ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                   ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN BEGIN
                    "Rec. Qty. to Transfer" := "Rec. Qty. to Receive";
                    "Rec. Qty. to Invoice" := 0;
                END ELSE BEGIN
                    "Rec. Qty. to Invoice" := ("Rec. Qty. to Receive" + "Rec. Qty. Received" - "Rec. Qty. Invoiced");
                    "Rec. Qty. to Transfer" := 0;
                END;
            end;
        }
        field(22; "Rec. Refund Price"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Refund Price';

            trigger OnValidate()
            begin
                "Rec. Refund Amount" := "Rec. Refund Price" * "Rec. Quantity";
            end;
        }
        field(24; "Rec. Refund Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Refund Amount';
        }
        field(30; "Rec. Qty. to Receive"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Qty. to Receive';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF ("Rec. Qty. to Receive" * "Rec. Quantity" < 0) OR
                   (ABS("Rec. Qty. to Receive") > ABS("Rec. Quantity" - "Rec. Qty. Received")) THEN
                    ERROR(
                      SSPText02Txt,
                       "Rec. Quantity" - "Rec. Qty. Received");

                IF "Rec. Qty. to Receive" <> xRec."Rec. Qty. to Receive" THEN
                    IF ("Document Type" = "Document Type"::"Credit Memo") OR
                       ("Document Type" = "Document Type"::Invoice) THEN
                        ERROR(SSPText08Txt);


                IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                   ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                   ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN BEGIN
                    "Rec. Qty. to Transfer" := "Rec. Qty. to Receive";
                    "Rec. Qty. to Invoice" := 0;
                END ELSE BEGIN
                    "Rec. Qty. to Invoice" := ("Rec. Qty. to Receive" + "Rec. Qty. Received" - "Rec. Qty. Invoiced");
                    "Rec. Qty. to Transfer" := 0;
                END;
            end;
        }
        field(31; "Rec. Qty. Received"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Qty. Received';
            DecimalPlaces = 0 : 5;
        }
        field(33; "Rec. Qty. to Invoice"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Qty. to Invoice';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Rec. Qty. to Invoice" <> 0 THEN
                    IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                       ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                       ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN
                        ERROR(SSPText07Txt, "Empties Allocation", "Empties Calculation");

                IF "Rec. Qty. to Invoice" <> xRec."Rec. Qty. to Invoice" THEN
                    IF ("Document Type" = "Document Type"::"Credit Memo") OR
                       ("Document Type" = "Document Type"::Invoice) THEN
                        ERROR(SSPText08Txt);


                IF ("Rec. Qty. to Invoice" * "Rec. Quantity" < 0) OR
                   (ABS("Rec. Qty. to Invoice") > ABS(("Rec. Qty. Received" + "Rec. Qty. to Receive"))) THEN
                    ERROR(
                      SSPText03Txt,
                       ("Rec. Qty. Received" + "Rec. Qty. to Receive"));
            end;
        }
        field(34; "Rec. Qty. Invoiced"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Qty. Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(35; "Rec. Qty. to Transfer"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Qty. to Transfer';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Rec. Qty. to Transfer" <> 0 THEN
                    IF ("Empties Allocation" <> "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR ("Empties Calculation" = "Empties Calculation"::"Same Document") THEN
                        ERROR(SSPText07Txt, "Empties Allocation", "Empties Calculation");

                IF "Rec. Qty. to Transfer" <> xRec."Rec. Qty. to Transfer" THEN
                    IF ("Document Type" = "Document Type"::"Credit Memo") OR ("Document Type" = "Document Type"::Invoice) THEN
                        ERROR(SSPText08Txt);

                IF ("Rec. Qty. to Transfer" * "Rec. Quantity" < 0) OR
                   (ABS("Rec. Qty. to Transfer") > ABS(("Rec. Qty. Received" + "Rec. Qty. to Receive"))) THEN
                    ERROR(
                      SSPText03Txt,
                       ("Rec. Qty. Received" + "Rec. Qty. to Receive"));
            end;
        }
        field(36; "Rec. Qty. Transfered"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Rec. Qty. Transfered';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(38; "Ship. Location Code"; Code[10])
        {
            Caption = 'Ship. Location Code';
            TableRelation = Location;
        }
        field(39; "Ship. Calc. Quantity"; Decimal)
        {
            Caption = 'Ship. Calc. Quantity';
        }
        field(40; "Ship. Quantity"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                //lrc_RefundCosts: Record "POI Empties/Transport Refund Cost";
                lrc_PurchaseHeader: Record "Purchase Header";
                lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
                ldt_date: Date;
            begin
                // Pfandpreise ermitteln
                lrc_PurchaseHeader.GET("Document Type", "Document No.");
                ldt_date := lrc_PurchaseHeader."Order Date";
                IF ldt_date = 0D THEN
                    ldt_date := lrc_PurchaseHeader."Document Date";

                lcu_EmptiesManagement.CalculateEmptiesReceiptPrice("Item No.",
                                                                     Source,
                                                                     "Source No.",
                                                                     "Location Code",
                                                                     ldt_date,
                                                                     1,
                                                                     1,
                                                                     lrc_PurchaseHeader."Document Type",
                                                                     lrc_PurchaseHeader."No.",
                                                                     0,
                                                                     "Ship. Refund Price");

                VALIDATE("Ship. Refund Price");

                IF ("Ship. Quantity" * "Ship. Qty. Shipped" < 0) OR
                   (ABS("Ship. Quantity") < ABS("Ship. Qty. Shipped"))
                THEN
                    FIELDERROR("Ship. Quantity", STRSUBSTNO(SSPText06Txt, FIELDCAPTION("Ship. Qty. Shipped")));

                IF ("Ship. Quantity" * "Ship. Qty. Invoiced" < 0) OR
                   (ABS("Ship. Quantity") < ABS("Ship. Qty. Invoiced"))
                THEN
                    FIELDERROR("Ship. Quantity", STRSUBSTNO(SSPText06Txt, FIELDCAPTION("Ship. Qty. Invoiced")));

                "Ship. Qty. to Ship" := "Ship. Quantity" - "Ship. Qty. Shipped";

                IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                   ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                   ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN BEGIN
                    "Ship. Qty. to Transfer" := "Ship. Qty. to Ship";
                    "Ship. Qty. to Invoice" := 0;
                END ELSE BEGIN
                    "Ship. Qty. to Invoice" := ("Ship. Qty. to Ship" + "Ship. Qty. Shipped" - "Ship. Qty. Invoiced");
                    "Ship. Qty. to Transfer" := 0;
                END;
            end;
        }
        field(42; "Ship. Refund Price"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Refund Price';

            trigger OnValidate()
            begin
                "Ship. Refund Amount" := "Ship. Refund Price" * "Ship. Quantity";
            end;
        }
        field(43; "Ship. Refund Amount"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Refund Amount';
        }
        field(50; "Ship. Qty. to Ship"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. to Ship';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF ("Ship. Qty. to Ship" * "Ship. Quantity" < 0) OR
                   (ABS("Ship. Qty. to Ship") > ABS("Ship. Quantity" - "Ship. Qty. Shipped")) THEN
                    ERROR(
                      SSPText04Txt,
                       "Ship. Quantity" - "Ship. Qty. Shipped");

                IF "Ship. Qty. to Ship" <> xRec."Ship. Qty. to Ship" THEN
                    IF ("Document Type" = "Document Type"::"Credit Memo") OR ("Document Type" = "Document Type"::Invoice) THEN
                        ERROR(SSPText08Txt);

                IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                   ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                   ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN BEGIN
                    "Rec. Qty. to Transfer" := "Ship. Qty. to Ship";
                    "Ship. Qty. to Invoice" := 0;
                END ELSE BEGIN
                    "Ship. Qty. to Invoice" := ("Ship. Qty. to Ship" + "Ship. Qty. Shipped" - "Ship. Qty. Invoiced");
                    "Ship. Qty. to Transfer" := 0;
                END;
            end;
        }
        field(51; "Ship. Qty. Shipped"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. Shipped';
            DecimalPlaces = 0 : 5;
        }
        field(53; "Ship. Qty. to Invoice"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. to Invoice';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Ship. Qty. to Invoice" <> 0 THEN
                    IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                       ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                       ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN
                        ERROR(SSPText07Txt, "Empties Allocation", "Empties Calculation");

                IF "Ship. Qty. to Invoice" <> xRec."Ship. Qty. to Invoice" THEN
                    IF ("Document Type" = "Document Type"::"Credit Memo") OR
                       ("Document Type" = "Document Type"::Invoice) THEN
                        ERROR(SSPText08Txt);

                IF ("Ship. Qty. to Invoice" * "Ship. Quantity" < 0) OR
                   (ABS("Ship. Qty. to Invoice") > ABS(("Ship. Qty. Shipped" + "Ship. Qty. to Ship"))) THEN
                    ERROR(
                      SSPText05Txt,
                       ("Ship. Qty. Shipped" + "Ship. Qty. to Ship"));
            end;
        }
        field(54; "Ship. Qty. Invoiced"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. Invoiced';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(55; "Ship. Qty. to Transfer"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. to Transfer';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                IF "Ship. Qty. to Transfer" <> 0 THEN
                    IF ("Empties Allocation" <> "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                       ("Empties Calculation" = "Empties Calculation"::"Same Document") THEN
                        ERROR(SSPText07Txt, "Empties Allocation", "Empties Calculation");


                IF "Ship. Qty. to Transfer" <> xRec."Ship. Qty. to Transfer" THEN
                    IF ("Document Type" = "Document Type"::"Credit Memo") OR
                       ("Document Type" = "Document Type"::Invoice) THEN
                        ERROR(SSPText08Txt);

                IF ("Ship. Qty. to Transfer" * "Ship. Quantity" < 0) OR
                   (ABS("Ship. Qty. to Transfer") > ABS(("Ship. Qty. Shipped" + "Ship. Qty. to Ship"))) THEN
                    ERROR(
                      SSPText05Txt,
                       ("Ship. Qty. Shipped" + "Ship. Qty. to Ship"));
            end;
        }
        field(56; "Ship. Qty. Transfered"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Ship. Qty. Transfered';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(80; "Empties Allocation"; Option)
        {
            Caption = 'Empties Allocation';
            Description = 'LVW';
            OptionCaption = 'Without Stock-Keeping Without Invoice,With Stock-Keeping Without Invoice,With Stock-Keeping With Invoice';
            OptionMembers = "Without Stock-Keeping Without Invoice","With Stock-Keeping Without Invoice","With Stock-Keeping With Invoice";

            trigger OnValidate()
            begin
                IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") THEN BEGIN
                    TESTFIELD("Ship. Qty. Shipped", 0);
                    TESTFIELD("Ship. Qty. Invoiced", 0);
                    TESTFIELD("Ship. Qty. Transfered", 0);

                    TESTFIELD("Rec. Qty. Received", 0);
                    TESTFIELD("Rec. Qty. Invoiced", 0);
                    TESTFIELD("Rec. Qty. Transfered", 0);
                END;

                IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                   ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                   ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN BEGIN
                    "Rec. Qty. to Transfer" := "Rec. Qty. to Receive";
                    "Ship. Qty. to Transfer" := "Ship. Qty. to Ship";
                    "Rec. Qty. to Invoice" := 0;
                    "Ship. Qty. to Invoice" := 0;
                END ELSE BEGIN
                    "Rec. Qty. to Invoice" := ("Rec. Qty. to Receive" + "Rec. Qty. Received" - "Rec. Qty. Invoiced");
                    "Ship. Qty. to Invoice" := ("Ship. Qty. to Ship" + "Ship. Qty. Shipped" - "Ship. Qty. Invoiced");
                    "Rec. Qty. to Transfer" := 0;
                    "Ship. Qty. to Transfer" := 0;
                END;
            end;
        }
        field(81; "Empties Calculation"; Option)
        {
            Caption = 'Empties Calculation';
            Description = 'LVW';
            OptionCaption = ' ,Same Document,Separat Document,Combine Document';
            OptionMembers = " ","Same Document","Separat Document","Combine Document";

            trigger OnValidate()
            var

                lrc_PurchaseHeader: Record "Purchase Header";
                lrc_PurchaseLine: Record "Purchase Line";
                SSPText04Txt: Label 'On producer, this value must be %1 !', Comment = '%1';
                SSPText05Txt: Label 'separat document';
                SSPText011Txt: Label 'There exist no purchase line for producer %1 !', Comment = '%1';
                SSPText001Txt: Label 'On shipping agent, this value must be %1 !', Comment = '%1';
                SSPText002Txt: Label 'separat document or combine document';
                SSPText003Txt: Label 'The selection combine document ist not possible !';
            begin
                IF ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                   ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN BEGIN
                    TESTFIELD("Ship. Qty. Shipped", 0);
                    TESTFIELD("Ship. Qty. Invoiced", 0);
                    TESTFIELD("Ship. Qty. Transfered", 0);

                    TESTFIELD("Rec. Qty. Received", 0);
                    TESTFIELD("Rec. Qty. Invoiced", 0);
                    TESTFIELD("Rec. Qty. Transfered", 0);
                END;

                IF ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN
                    ERROR(SSPText003Txt);

                IF Source = Source::"Shipping Agent" THEN
                    IF ("Empties Calculation" = "Empties Calculation"::"Same Document") THEN
                        ERROR(SSPText001Txt, SSPText002Txt);


                IF Source = Source::Vendor THEN
                    IF "Source No." <> '' THEN BEGIN
                        lrc_PurchaseHeader.GET("Document Type", "Document No.");
                        IF lrc_PurchaseHeader."Buy-from Vendor No." <> "Source No." THEN BEGIN
                            lrc_PurchaseLine.RESET();
                            lrc_PurchaseLine.SETRANGE("Document Type", "Document Type");
                            lrc_PurchaseLine.SETRANGE("Document No.", "Document No.");
                            lrc_PurchaseLine.SETRANGE("POI Manufacturer Code", "Source No.");
                            IF lrc_PurchaseLine.IsEmpty() THEN
                                // Es existieren keine Einkaufszeilen für diesen Produzenten %1
                                ERROR(SSPText011Txt, "Source No.")
                            ELSE
                                IF ("Empties Calculation" = "Empties Calculation"::"Same Document") THEN BEGIN
                                    MESSAGE(SSPText04Txt, SSPText05Txt);
                                    VALIDATE("Empties Calculation", "Empties Calculation"::"Separat Document");
                                END;
                        END;
                    END;

                IF ("Empties Allocation" = "Empties Allocation"::"Without Stock-Keeping Without Invoice") OR
                   ("Empties Calculation" = "Empties Calculation"::"Separat Document") OR
                   ("Empties Calculation" = "Empties Calculation"::"Combine Document") THEN BEGIN
                    "Rec. Qty. to Transfer" := "Rec. Qty. to Receive";
                    "Ship. Qty. to Transfer" := "Ship. Qty. to Ship";
                    "Rec. Qty. to Invoice" := 0;
                    "Ship. Qty. to Invoice" := 0;
                END ELSE BEGIN
                    "Rec. Qty. to Invoice" := ("Rec. Qty. to Receive" + "Rec. Qty. Received" - "Rec. Qty. Invoiced");
                    "Ship. Qty. to Invoice" := ("Ship. Qty. to Ship" + "Ship. Qty. Shipped" - "Ship. Qty. Invoiced");
                    "Rec. Qty. to Transfer" := 0;
                    "Ship. Qty. to Transfer" := 0;
                END;
            end;
        }
        field(100; "Rec. Created Line No."; Integer)
        {
            Caption = 'Rec. Created Line No.';
        }
        field(110; "Ship. Created Line No."; Integer)
        {
            Caption = 'Ship. Created Line No.';
        }
        field(401; "Created From Posted Doc. Type"; Option)
        {
            Caption = 'Created From Posted Document Type';
            Editable = false;
            OptionCaption = 'Archive Quote,Archive Order,Archive Invoice,Archive Credit Memo,Archive Blanket Order,Archive Return Order,,,,,,,,,,Posted Shipment,Posted Invoice,Posted Credit Memo,Posted Return Shipment';
            OptionMembers = "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment";
        }
        field(402; "Created From Posted Doc. No."; Code[20])
        {
            Caption = 'Created From Posted Document No.';
            Editable = false;
        }
        field(405; "Created From Posted Doc.Source"; Option)
        {
            BlankZero = true;
            Caption = 'Created From Posted Document Source';
            Editable = false;
            OptionCaption = ' ,Sales,Purchase';
            OptionMembers = " ",Sales,Purchase;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", Source, "Source No.", "Item No.", "Location Code")
        {
        }
        key(Key2; "Item Typ")
        {
        }
    }

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchaseHeader: Record "Purchase Header";
    begin
        IF "Line No." = 0 THEN BEGIN
            lrc_PurchEmpties.RESET();
            lrc_PurchEmpties.SETRANGE("Document Type", "Document Type");
            lrc_PurchEmpties.SETRANGE("Document No.", "Document No.");
            IF lrc_PurchEmpties.FINDLAST() THEN
                "Line No." := lrc_PurchEmpties."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        // Setup lesen
        IF ("Location Code" = '') OR
           ("Rec. Location Code" = '') OR
           ("Ship. Location Code" = '') THEN BEGIN
            lrc_FruitVisionSetup.GET();
            IF lrc_PurchaseHeader.GET("Document Type", "Document No.") THEN
                IF lrc_FruitVisionSetup."Empties Location Code" <> '' THEN BEGIN
                    IF "Location Code" = '' THEN
                        "Location Code" := lrc_FruitVisionSetup."Empties Location Code";
                    IF "Rec. Location Code" = '' THEN
                        "Rec. Location Code" := lrc_FruitVisionSetup."Empties Location Code";
                    IF "Ship. Location Code" = '' THEN
                        "Ship. Location Code" := lrc_FruitVisionSetup."Empties Location Code";
                END ELSE BEGIN
                    lrc_PurchaseHeader.TESTFIELD("Location Code");
                    IF "Location Code" = '' THEN
                        "Location Code" := lrc_PurchaseHeader."Location Code";
                    IF "Rec. Location Code" = '' THEN
                        "Rec. Location Code" := lrc_PurchaseHeader."Location Code";
                    IF "Ship. Location Code" = '' THEN
                        "Ship. Location Code" := lrc_PurchaseHeader."Location Code";
                END;
        END;


        IF Source = Source::Customer THEn
            ERROR(SSPText01Txt);
    end;

    trigger OnModify()
    begin
        IF Source = Source::Customer THEN
            ERROR(SSPText01Txt);
    end;

    var
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_PurchEmpties: Record "POI Purchase Empties";
        SSPText01Txt: Label 'The source type customer is not possible !';
        //Text001Txt: Label '%1 mus not be less then %2 ( %3 ).';
        SSPText02Txt: Label 'You cannot ship more than %1 units receipt.', Comment = '%1';
        SSPText03Txt: Label 'You cannot invoice more than %1 units receipt.', Comment = '%1';
        SSPText04Txt: Label 'You cannot ship more than %1 units shipment.', Comment = '%1';
        SSPText05Txt: Label 'You cannot invoice more than %1 units shipment.', Comment = '%1';
        SSPText06Txt: Label 'must not be less than %1', Comment = '%1';
        SSPText07Txt: Label 'You can''t change this value : %1, %2 ! ', Comment = '%1 %2';
        SSPText08Txt: Label 'You can''t change this field, when the document type is invoice or credit memo !';
}

