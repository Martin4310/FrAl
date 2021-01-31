table 5110461 "POI Purch. Claim Notify Header"
{
    Caption = 'Purch. Claim Notify Header';
    DrillDownPageID = 5110464;
    LookupPageID = 5110464;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,,,Closed';
            OptionMembers = Open,,,Closed;
        }
        field(10; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
            begin
                IF NOT lrc_Vendor.GET("Buy-from Vendor No.") THEN
                    lrc_Vendor.INIT();

                "Buy-from Vendor Name" := lrc_Vendor.Name;
                "Buy-from Vend. Name 2" := lrc_Vendor."Name 2";
                "Buy-from Adress" := lrc_Vendor.Address;
                "Buy-from Adress 2" := lrc_Vendor."Address 2";
                "Buy-from Contact" := lrc_Vendor.Contact;
                "Buy-from Country Code" := lrc_Vendor."Country/Region Code";
                "Buy-from Post Code" := lrc_Vendor."Post Code";
                "Buy-from City" := lrc_Vendor.City;
                "Language Code" := lrc_Vendor."Language Code";
            end;
        }
        field(11; "Buy-from Vendor Name"; Text[100])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(12; "Buy-from Vend. Name 2"; Text[50])
        {
            Caption = 'Buy-from Vend. Name 2';
        }
        field(14; "Buy-from Adress"; Text[100])
        {
            Caption = 'Buy-from Adress';
        }
        field(15; "Buy-from Adress 2"; Text[50])
        {
            Caption = 'Buy-from Adress 2';
        }
        field(17; "Buy-from Contact"; Text[100])
        {
            Caption = 'Buy-from Contact';
        }
        field(18; "Buy-from Country Code"; Code[10])
        {
            Caption = 'Buy-from Country Code';
            TableRelation = "Country/Region";
        }
        field(19; "Buy-from Post Code"; Code[20])
        {
            Caption = 'Buy-from Post Code';
            TableRelation = "Post Code";

            // trigger OnLookup() //TODO: prüfen
            // var
            //     lrc_PostCode: Record "Post Code";
            // begin
            //     lrc_PostCode.LookUpPostCode("Buy-from City", "Buy-from Post Code", TRUE);
            // end;

            // trigger OnValidate()
            // var
            //     lrc_PostCode: Record "Post Code";
            // begin
            //     lrc_PostCode.ValidatePostCode("Buy-from City", "Buy-from Post Code");
            // end;
        }
        field(20; "Buy-from City"; Text[30])
        {
            Caption = 'Buy-from City';
        }
        field(21; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(30; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(40; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(41; "Claim Advice Date"; Date)
        {
            Caption = 'Claim Advice Date';
        }
        field(45; "Person in Charge Code"; Code[20])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser".Code WHERE("POI Is Person in Charge" = CONST(true));
        }
        field(46; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser".Code WHERE("POI Is Purchaser" = CONST(true));
        }
        field(60; "Purch. Order No."; Code[20])
        {
            Caption = 'Purch. Order No.';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            var
                lrc_PurchaseHeader: Record "Purchase Header";
                lrc_PurchClaimAdviceLine: Record "POI Purch. Claim Notify Line";
                "User Setup": Record "User Setup";
                lin_LineNo: Integer;
                //InsertClaimLine: Boolean;
                PurchaseOrderVorher: Code[20];
                PurchaseOrderNachher: Code[20];
                Bestellungsuebernahme: Boolean;
            begin
                IF xRec."Purch. Order No." <> ''
                  THEN
                    PurchaseOrderVorher := xRec."Purch. Order No."
                ELSE
                    PurchaseOrderVorher := 'leere Bestellnr.';

                IF Rec."Purch. Order No." <> ''
                  THEN
                    PurchaseOrderNachher := Rec."Purch. Order No."
                ELSE
                    PurchaseOrderNachher := 'leere Bestellnr.';

                Bestellungsuebernahme := FALSE;
                IF "Purch. Order No." <> xRec."Purch. Order No." THEN BEGIN
                    Bestellungsuebernahme := FALSE;
                    IF xRec."Purch. Order No." <> '' THEN BEGIN
                        IF CONFIRM('Soll die Reklamation wirklich zurückgesetzt werden, %1 ersetzt %2) ?', FALSE,
                                   PurchaseOrderNachher, PurchaseOrderVorher) then
                            Bestellungsuebernahme := TRUE
                        ELSE
                            Bestellungsuebernahme := TRUE;


                        IF Bestellungsuebernahme THEN BEGIN
                            lrc_PurchClaimAdviceLine.RESET();
                            lrc_PurchClaimAdviceLine.SETRANGE("Document No.", "No.");
                            IF lrc_PurchClaimAdviceLine.FIND('-')
                              THEN
                                lrc_PurchClaimAdviceLine.DELETEALL();

                            IF NOT lrc_PurchaseHeader.GET(lrc_PurchaseHeader."Document Type"::Order, "Purch. Order No.") THEN BEGIN
                                lrc_PurchaseHeader.INIT();
                                lrc_PurchaseHeader.RESET();
                                lrc_PurchaseHeader."No." := 'Temp';
                            END;
                            "Buy-from Vendor No." := lrc_PurchaseHeader."Buy-from Vendor No.";
                            "Buy-from Vendor Name" := lrc_PurchaseHeader."Buy-from Vendor Name";
                            "Buy-from Vend. Name 2" := lrc_PurchaseHeader."Buy-from Vendor Name 2";
                            "Buy-from Adress" := lrc_PurchaseHeader."Buy-from Address";
                            "Buy-from Adress 2" := lrc_PurchaseHeader."Buy-from Address 2";
                            "Buy-from Contact" := lrc_PurchaseHeader."Buy-from Contact";
                            "Buy-from Country Code" := lrc_PurchaseHeader."Buy-from Country/Region Code";
                            "Buy-from Post Code" := lrc_PurchaseHeader."Buy-from Post Code";
                            "Buy-from City" := lrc_PurchaseHeader."Buy-from City";
                            "Language Code" := lrc_PurchaseHeader."Language Code";
                            "Document Date" := lrc_PurchaseHeader."Order Date";
                            "Person in Charge Code" := lrc_PurchaseHeader."POI Person in Charge Code";
                            "Purchaser Code" := lrc_PurchaseHeader."Purchaser Code";
                            "Your Reference" := lrc_PurchaseHeader."Your Reference";
                            "Sell-to Customer No." := lrc_PurchaseHeader."Sell-to Customer No.";
                            "Pay-to Vendor No." := lrc_PurchaseHeader."Pay-to Vendor No.";
                            "Pay-to Name" := lrc_PurchaseHeader."Pay-to Name";
                            "Pay-to Name 2" := lrc_PurchaseHeader."Pay-to Name 2";
                            "Pay-to Address" := lrc_PurchaseHeader."Pay-to Address";
                            "Pay-to Address 2" := lrc_PurchaseHeader."Pay-to Address 2";
                            "Pay-to City" := lrc_PurchaseHeader."Pay-to City";
                            "Pay-to Contact" := lrc_PurchaseHeader."Pay-to Contact";
                            "Pay-to Post Code" := lrc_PurchaseHeader."Pay-to Post Code";
                            "Pay-to Country Code" := lrc_PurchaseHeader."Pay-to Country/Region Code";
                            "Ship-to Code" := lrc_PurchaseHeader."Ship-to Code";
                            "Ship-to Name" := lrc_PurchaseHeader."Ship-to Name";
                            "Ship-to Name 2" := lrc_PurchaseHeader."Ship-to Name 2";
                            "Ship-to Address" := lrc_PurchaseHeader."Ship-to Address";
                            "Ship-to Address 2" := lrc_PurchaseHeader."Ship-to Address 2";
                            "Ship-to City" := lrc_PurchaseHeader."Ship-to City";
                            "Ship-to Contact" := lrc_PurchaseHeader."Ship-to Contact";
                            "Ship-to Post Code" := lrc_PurchaseHeader."Ship-to Post Code";
                            "Ship-to Country Code" := lrc_PurchaseHeader."Ship-to Country/Region Code";

                            "Purch. Order Date" := lrc_PurchaseHeader."Order Date";
                            "Purch. Receipt Date" := lrc_PurchaseHeader."Expected Receipt Date";
                            "Purch. Means of Transport" := lrc_PurchaseHeader."POI Means of Transport Type";
                            "Purch. Means of Transp. Code" := lrc_PurchaseHeader."POI Means of TransCode(Arriva)";
                            "Purch. Means of Transp. Info" := lrc_PurchaseHeader."POI Means of Transport Info";
                            "Shipping Agent Code" := lrc_PurchaseHeader."POI Shipping Agent Code";
                            "Location Code" := lrc_PurchaseHeader."Location Code";
                            "Vend. Order No." := lrc_PurchaseHeader."Vendor Order No.";
                            "Vend. Shipment No." := lrc_PurchaseHeader."Vendor Shipment No.";
                            "Vend. Invoice No." := lrc_PurchaseHeader."Vendor Invoice No.";

                            "Master Batch No." := lrc_PurchaseHeader."POI Master Batch No.";
                            //Vorbelegung der Rückführungen
                            "Return to" := "Return to"::Vendor;
                            "Return to Vendor No." := lrc_PurchaseHeader."Buy-from Vendor No.";
                            //Da der Ursprungslagerort des Lieferanten nicht bekannt ist -> Return to Locationcode
                            "Return to Location Code" := lrc_PurchaseHeader."Location Code";
                            "Location Code Claim" := lrc_PurchaseHeader."Location Code";

                            "Shipping Agent Code Claim" := lrc_PurchaseHeader."POI Shipping Agent Code";

                            "Expected Receipt Date" := lrc_PurchaseHeader."Expected Receipt Date";

                            //"Return to Location Code":=
                            IF "User Setup".GET(USERID()) THEN
                                "Person in Charge Code" := "User Setup"."POI Purchaser Code";

                            lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
                            lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
                            lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
                            lrc_PurchaseLine.SETFILTER("No.", '<>%1', '');
                            lrc_PurchaseLine.SETRANGE("POI Subtyp", lrc_PurchaseLine."POI Subtyp"::" ");
                            IF lrc_PurchaseLine.FINDSET(FALSE, FALSE) THEN BEGIN
                                lin_LineNo := 0;
                                REPEAT
                                    lrc_PurchClaimAdviceLine.RESET();
                                    lrc_PurchClaimAdviceLine.INIT();
                                    lrc_PurchClaimAdviceLine."Document No." := "No.";
                                    lin_LineNo := lin_LineNo + 10000;
                                    lrc_PurchClaimAdviceLine."Line No." := lin_LineNo;
                                    lrc_PurchClaimAdviceLine.Type := lrc_PurchClaimAdviceLine.Type::Item;
                                    lrc_PurchClaimAdviceLine.VALIDATE("No.", lrc_PurchaseLine."No.");
                                    lrc_PurchClaimAdviceLine.Description := lrc_PurchaseLine.Description;
                                    lrc_PurchClaimAdviceLine."Description 2" := lrc_PurchaseLine."Description 2";
                                    lrc_PurchClaimAdviceLine."Master Batch No." := lrc_PurchaseLine."POI Master Batch No.";
                                    lrc_PurchClaimAdviceLine."Batch No." := lrc_PurchaseLine."POI Batch No.";
                                    lrc_PurchClaimAdviceLine."Batch Variant No." := lrc_PurchaseLine."POI Batch Variant No.";
                                    lrc_PurchClaimAdviceLine."Variety Code" := lrc_PurchaseLine."POI Variety Code";
                                    lrc_PurchClaimAdviceLine."Country of Origin Code" := lrc_PurchaseLine."POI Country of Origin Code";
                                    lrc_PurchClaimAdviceLine."Trademark Code" := lrc_PurchaseLine."POI Trademark Code";
                                    lrc_PurchClaimAdviceLine."Caliber Code" := lrc_PurchaseLine."POI Caliber Code";
                                    lrc_PurchClaimAdviceLine."Item Attribute 2" := lrc_PurchaseLine."POI Item Attribute 2";
                                    lrc_PurchClaimAdviceLine."Grade of Goods Code" := lrc_PurchaseLine."POI Grade of Goods Code";
                                    lrc_PurchClaimAdviceLine."Item Attribute 7" := lrc_PurchaseLine."POI Item Attribute 7";
                                    lrc_PurchClaimAdviceLine."Item Attribute 4" := lrc_PurchaseLine."POI Item Attribute 4";
                                    lrc_PurchClaimAdviceLine."Coding Code" := lrc_PurchaseLine."POI Coding Code";
                                    lrc_PurchClaimAdviceLine."Item Attribute 5" := lrc_PurchaseLine."POI Item Attribute 5";
                                    lrc_PurchClaimAdviceLine."Item Attribute 3" := lrc_PurchaseLine."POI Item Attribute 3";
                                    lrc_PurchClaimAdviceLine."Date of Expiry" := lrc_PurchaseLine."POI Date of Expiry";
                                    lrc_PurchClaimAdviceLine."Unit of Measure Code" := lrc_PurchaseLine."Unit of Measure Code";
                                    lrc_PurchClaimAdviceLine."Base Unit of Measure (BU)" := lrc_PurchaseLine."POI Base Unit of Measure (BU)";
                                    lrc_PurchClaimAdviceLine."Qty. per Unit of Measure" := lrc_PurchaseLine."Qty. per Unit of Measure";
                                    lrc_PurchClaimAdviceLine."Quantity Received" := lrc_PurchaseLine."Quantity Received";
                                    lrc_PurchClaimAdviceLine.Quantity := lrc_PurchaseLine.Quantity;
                                    lrc_PurchClaimAdviceLine."Quantity (Base)" := lrc_PurchaseLine."Qty. per Unit of Measure" * lrc_PurchaseLine.Quantity;
                                    lrc_PurchClaimAdviceLine."Purch. Order No." := lrc_PurchaseLine."Document No.";
                                    lrc_PurchClaimAdviceLine."Purch. Order Line No." := lrc_PurchaseLine."Line No.";
                                    lrc_PurchClaimAdviceLine."Shipping Agent Code" := lrc_PurchaseLine."POI Shipping Agent Code";
                                    lrc_PurchClaimAdviceLine."Shipping Agent Code Claim" := lrc_PurchaseLine."POI Shipping Agent Code";
                                    lrc_PurchClaimAdviceLine."Location Code" := lrc_PurchaseLine."Location Code";
                                    lrc_PurchClaimAdviceLine."Location Code Claim" := lrc_PurchaseLine."Location Code";
                                    lrc_PurchClaimAdviceLine."Item Category Code" := lrc_PurchaseLine."Item Category Code";
                                    lrc_PurchClaimAdviceLine."Product Group Code" := lrc_PurchaseLine."POI Product Group Code";
                                    lrc_PurchClaimAdviceLine."Packing Unit of Measure (PU)" := lrc_PurchaseLine."POI Packing Unit of Meas (PU)";
                                    lrc_PurchClaimAdviceLine."Qty. (PU) per Collo (CU)" := lrc_PurchaseLine."POI Qty. (PU) per Unit of Meas";
                                    lrc_PurchClaimAdviceLine."Quantity (PU)" := lrc_PurchaseLine."POI Quantity (PU)";
                                    lrc_PurchClaimAdviceLine."Transport Unit of Measure (TU)" := lrc_PurchaseLine."POI Transport Unit of Meas(TU)";
                                    lrc_PurchClaimAdviceLine."Qty. (CU) per Pallet (TU)" := lrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)";
                                    lrc_PurchClaimAdviceLine."Quantity (TU)" := lrc_PurchaseLine."POI Quantity (TU)";
                                    lrc_PurchClaimAdviceLine."Collo Unit of Measure (CU)" := lrc_PurchaseLine."Unit of Measure Code";
                                    lrc_PurchClaimAdviceLine."Content Unit of Measure (COU)" := lrc_PurchaseLine."POI Content Unit of Meas (COU)";
                                    lrc_PurchClaimAdviceLine."Batch Item" := lrc_PurchaseLine."POI Batch Item";

                                    lrc_PurchClaimAdviceLine."Price Base (Purch. Price)" := lrc_PurchaseLine."POI Price Base (Purch. Price)";
                                    lrc_PurchClaimAdviceLine."Purch. Price (Price Base)" := lrc_PurchaseLine."POI Purch. Price (Price Base)";
                                    lrc_PurchClaimAdviceLine."Purch. Direct Unit Cost" := lrc_PurchaseLine."Direct Unit Cost";

                                    lrc_PurchClaimAdviceLine.INSERT();
                                UNTIL lrc_PurchaseLine.NEXT() = 0;
                            END;
                        END ELSE
                            "Purch. Order No." := xRec."Purch. Order No.";
                    END; //Purchase leer
                    //InitClaimPath(1); //TODO: Pfad
                end;
            end;
        }
        field(61; "Purch. Order Date"; Date)
        {
            Caption = 'Purch. Order Date';
        }
        field(62; "Purch. Receipt Date"; Date)
        {
            Caption = 'Purch. Receipt Date';
        }
        field(63; "Purch. Means of Transport"; Option)
        {
            Caption = 'Means of Transport';
            Description = ' ,LKW,Bahn,Schiff,Flugzeug';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(64; "Purch. Means of Transp. Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
            TableRelation = IF ("Purch. Means of Transport" = CONST(Truck)) "POI Means of Transport".Code WHERE(Type = CONST(Truck))
            ELSE
            IF ("Purch. Means of Transport" = CONST(Train)) "POI Means of Transport".Code WHERE(Type = CONST(Train))
            ELSE
            IF ("Purch. Means of Transport" = CONST(Ship)) "POI Means of Transport".Code WHERE(Type = CONST(Ship))
            ELSE
            IF ("Purch. Means of Transport" = CONST(Airplane)) "POI Means of Transport".Code WHERE(Type = CONST(Airplane));
            ValidateTableRelation = false;
        }
        field(65; "Purch. Means of Transp. Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
        }
        field(70; "Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
        }
        field(71; Comment; Boolean)
        {
            CalcFormula = Exist ("POI Purch. Claim Notify Commt" WHERE("Document No." = FIELD("No."),
                                                                     "Doc. Line No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(73; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(75; "Vend. Order No."; Code[35])
        {
            Caption = 'Vendor Order No.';
        }
        field(76; "Vend. Shipment No."; Code[35])
        {
            Caption = 'Vendor Shipment No.';
        }
        field(77; "Vend. Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(80; "Return to"; Option)
        {
            Caption = 'Return to';
            Description = ' ,Claim Location,Vendor';
            OptionCaption = ' ,Claim Location,Vendor';
            OptionMembers = " ","Claim Location",Vendor,"Shipping Agent";
        }
        field(81; "Return to Location Code"; Code[10])
        {
            Caption = 'Return to Location Code';
            TableRelation = Location;
        }
        field(82; "Return to Vendor No."; Code[20])
        {
            Caption = 'Return to Vendor No.';
            TableRelation = Vendor;
        }
        field(100; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(101; "Shipping Agent Code Claim"; Code[10])
        {
            Caption = 'Shipping Agent Code Claim';
            TableRelation = "Shipping Agent".Code;

            trigger OnValidate()
            var
                lrc_PurchClaimAdviceLine: Record "POI Purch. Claim Notify Line";
            begin
                lrc_PurchClaimAdviceLine.RESET();
                lrc_PurchClaimAdviceLine.SETRANGE("Document No.", "No.");
                IF NOT lrc_PurchClaimAdviceLine.ISEMPTY() THEN
                    lrc_PurchClaimAdviceLine.MODIFYALL("Shipping Agent Code Claim", "Shipping Agent Code Claim");
            end;
        }
        field(105; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(106; "Location Code Claim"; Code[10])
        {
            Caption = 'Location Code Claim';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            var
                lrc_PurchClaimAdviceLine: Record "POI Purch. Claim Notify Line";
            begin
                lrc_PurchClaimAdviceLine.RESET();
                lrc_PurchClaimAdviceLine.SETRANGE("Document No.", "No.");
                IF NOT lrc_PurchClaimAdviceLine.ISEMPTY() THEN
                    lrc_PurchClaimAdviceLine.MODIFYALL("Location Code Claim", "Location Code Claim");
            end;
        }
        field(110; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
            ValidateTableRelation = false;
        }
        field(111; "Pay-to Name"; Text[100])
        {
            Caption = 'Pay-to Name';
        }
        field(112; "Pay-to Name 2"; Text[50])
        {
            Caption = 'Pay-to Name 2';
        }
        field(114; "Pay-to Address"; Text[100])
        {
            Caption = 'Pay-to Address';
        }
        field(115; "Pay-to Address 2"; Text[50])
        {
            Caption = 'Pay-to Address 2';
        }
        field(116; "Pay-to City"; Text[30])
        {
            Caption = 'Pay-to City';
        }
        field(117; "Pay-to Contact"; Text[100])
        {
            Caption = 'Pay-to Contact';
        }
        field(118; "Pay-to Post Code"; Code[20])
        {
            Caption = 'Pay-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(119; "Pay-to Country Code"; Code[10])
        {
            Caption = 'Pay-to Country Code';
            TableRelation = "Country/Region";
        }
        field(130; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));
        }
        field(131; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(132; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(134; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(135; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(136; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
        }
        field(137; "Ship-to Contact"; Text[1000])
        {
            Caption = 'Ship-to Contact';
        }
        field(138; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(139; "Ship-to Country Code"; Code[10])
        {
            Caption = 'Ship-to Country Code';
            TableRelation = "Country/Region";
        }
        field(200; "Claim Doc. Subtype Code"; Code[10])
        {
            Caption = 'Claim Doc. Subtype Code';
            TableRelation = "POI Claim Doc. Subtype".Code WHERE("Document Type" = CONST("Purchase Claim"));
        }
        field(50000; "Ship-to Country/Region Code"; Code[10])
        {
        }
        field(50001; "Ship-to-Tel"; Text[30])
        {
        }
        field(50002; "Ship-to-Fax"; Text[30])
        {
        }
        field(50003; "Ship-to-mail"; Text[80])
        {
        }
        field(50004; Besichtigungsstatus; Option)
        {
            Caption = 'Return to';
            Description = ' ,keine,erforderlich,erfolgt';
            OptionCaption = ' ,keine,erforderlich,erfolgt';
            OptionMembers = " ",keine,erforderlich,erfolgt;
        }
        field(50010; "Master Batch No."; Code[20])
        {
            Caption = 'Partienr.';
        }
        field(50021; "Claim Status"; Option)
        {
            Caption = 'Reklamationsstatus';
            OptionMembers = erfasst,Kreditormeldung,"zur Prüfung",Abrechnen,Gutschrifterstellung;
            OptionCaption = 'erfasst,Kreditormeldung,zur Prüfung,Abrechnen,Gutschrifterstellung';
        }
        field(50023; "Vendor Report to No."; Date)
        {
            Caption = 'Kred. Meldung an';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; Status)
        {
        }
        key(Key3; "Claim Doc. Subtype Code")
        {
        }
        key(key4; "Purch. Order No.")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_PurchClaimAdviceLine: Record "POI Purch. Claim Notify Line";
    begin
        lrc_PurchClaimAdviceLine.SETRANGE("Document No.", "No.");
        lrc_PurchClaimAdviceLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_ClaimDocSubtype: Record "POI Claim Doc. Subtype";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        InitClaimDocSubtype();
        IF "Claim Doc. Subtype Code" <> '' THEN BEGIN
            lrc_ClaimDocSubtype.GET(lrc_ClaimDocSubtype."Document Type"::"Purchase Claim", "Claim Doc. Subtype Code");
            IF "No." = '' THEN
                IF lrc_ClaimDocSubtype."Document No. Series" <> '' THEN
                    lcu_NoSeriesManagement.InitSeries(lrc_ClaimDocSubtype."Document No. Series", xRec."No. Series", "Document Date", "No.", "No. Series");
        END;

        IF "No." = '' THEN BEGIN
            lrc_FruitVisionSetup.GET();
            lrc_FruitVisionSetup.TESTFIELD("Purch. Claim No. Series");
            lcu_NoSeriesManagement.InitSeries(
              lrc_FruitVisionSetup."Purch. Claim No. Series", xRec."No. Series", "Document Date", "No.", "No. Series");
        END;

        "Document Date" := TODAY();
        "Claim Advice Date" := TODAY();
    end;

    procedure AssistEdit(lrc_OldPurchClaimAdviceHeader: Record "POI Purch. Claim Notify Header"): Boolean
    var
        lrc_PurchClaimAdviceHeader: Record "POI Purch. Claim Notify Header";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        lrc_PurchClaimAdviceHeader := Rec;
        lrc_FruitVisionSetup.GET();
        lrc_FruitVisionSetup.TESTFIELD("Purch. Claim No. Series");

        IF lcu_NoSeriesManagement.SelectSeries(
          lrc_FruitVisionSetup."Purch. Claim No. Series",
          lrc_OldPurchClaimAdviceHeader."No.", "No. Series") THEN BEGIN
            lcu_NoSeriesManagement.SetSeries("No.");
            Rec := lrc_PurchClaimAdviceHeader;
            EXIT(TRUE);
        END;
    end;

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        lrc_PurchClaimAdviceHeader: Record "POI Purch. Claim Notify Header";
        lcu_PrintFaxMailGlobals: Codeunit "POI PrintFaxMail Globals";
    begin
        WITH lrc_PurchClaimAdviceHeader DO
            COPY(Rec);
        lrc_PrintDocument.RESET();
        lrc_PrintDocument.SETRANGE("Document Source", lrc_PrintDocument."Document Source"::Purchase);
        lrc_PrintDocument.SETRANGE("Document Type", lrc_PrintDocument."Document Type"::"Posted Return Shipment/Receipt");
        lrc_PrintDocument.SETRANGE(Code, 'E R');
        IF lrc_PrintDocument.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                lcu_PrintFaxMailGlobals.ClearPrintDocRec();
                REPORT.RUNMODAL(lrc_PrintDocument."Report ID", ShowRequestForm, FALSE, lrc_PurchClaimAdviceHeader);
            UNTIL lrc_PrintDocument.NEXT() = 0;
            lcu_PrintFaxMailGlobals.ClearPrintDocRec();
        END;
    end;

    procedure InitClaimDocSubtype()
    begin
        IF "Claim Doc. Subtype Code" = '' THEN BEGIN
            lrc_ClaimDocType.RESET();
            lrc_ClaimDocType.SETRANGE("Document Type", lrc_ClaimDocType."Document Type"::"Purchase Claim");
            IF lrc_ClaimDocType.FINDFIRST() THEN
                "Claim Doc. Subtype Code" := lrc_ClaimDocType.Code;
        END;
    end;

    procedure InitClaimPath("Action": Integer)
    var
        //PortSetupII: Record "50005";
        Filename: Text[250];
        ffile: File;
        Shellcommand: Text[30];
    begin
        //POI 001 EKREK    JST 211013 001 Einführung Einkaufsreklamation
        // CASE Action OF //TODO: prüfen
        //   1 : Shellcommand:='mkdir';
        //   2 : Shellcommand:='explorer';
        // END;

        //PortSetupII.GET();
        Filename := '\\port-nav-01\NavClient\MakeDir\makeDir' + copystr(USERID(), 7, 12) + '.bat';
        IF EXISTS(Filename) THEN ERASE(Filename);
        IF NOT (ffile.CREATE(Filename)) THEN //Hat das geklappt
            ERROR('Datei %1 konnte nicht erstellt werden', Filename);
        IF not (ffile.WRITEMODE(TRUE)) THEN           //sind Schreibrechte da ??
            ERROR('In Datei %1 kann nicht auf Write-Mode geschaltet werden', Filename);
        IF not (ffile.TEXTMODE(TRUE)) THEN                //True ist ASCII False ist Binary
            ERROR('Datei %1 kann nicht in ASCII-Mode geschaltet werden', Filename);
        //neu jeweils unter Kreditorennummer:
        ffile.WRITE('mkdir' + ' ' + '\\port-data-01\lwp\0_Kreditoren\' + "Buy-from Vendor No." + '\' +
          '2_Reklamationen' + '\' + "No.");
        ffile.WRITE(Shellcommand + ' ' + '\\port-data-01\lwp\0_Kreditoren\' + "Buy-from Vendor No." + '\' +
          '2_Reklamationen' + '\' + "No.");

        ffile.CLOSE();
        // SHELL(Filename); //TODO: prüfen

    end;

    var
        lrc_PrintDocument: Record "POI Print Documents";
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_ClaimDocType: Record "POI Claim Doc. Subtype";
}

