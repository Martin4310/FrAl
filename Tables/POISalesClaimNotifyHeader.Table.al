table 5110455 "POI Sales Claim Notify Header"
{

    Caption = 'Sales Claim Notify Header';
    // DrillDownFormID = Form5110547;
    // LookupFormID = Form5110547;

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
        field(7; "Claim Doc. Subtype Code"; Code[10])
        {
            Caption = 'Claim Doc. Subtype Code';
            TableRelation = "POI Claim Doc. Subtype".Code WHERE("Document Type" = CONST("Sales Claim"));
        }
        field(9; "Claim Doc. Source"; Option)
        {
            Caption = 'Claim Doc. Source';
            OptionCaption = ' ,Order,Shipment,Invoice';
            OptionMembers = " ","Order",Shipment,Invoice;
        }
        field(10; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
                lrc_SalesClaimNotifyLine: Record "POI Sales Claim Notify Line";
                lcu_BaseDataMgt: Codeunit "POI Base Data Mgt";
                AGILES_TEXT002Txt: Label 'Debitornr. %1 nicht vorhanden!', Comment = '%1';
            begin
                IF NOT lcu_BaseDataMgt.CustomerNoValidate("Sell-to Customer No.") THEN
                    // Debitornr. %1 nicht vorhanden!
                    ERROR(AGILES_TEXT002Txt, "Sell-to Customer No.");

                IF "Sell-to Customer No." = xRec."Sell-to Customer No." THEN
                    EXIT;

                lrc_SalesClaimNotifyLine.SETRANGE("Document No.", "No.");
                lrc_SalesClaimNotifyLine.DELETEALL(TRUE);

                IF NOT lrc_Customer.GET("Sell-to Customer No.") THEN
                    lrc_Customer.INIT();

                "Sell-to Customer Name" := lrc_Customer.Name;
                "Sell-to Customer Name 2" := lrc_Customer."Name 2";
                "Sell-to Address" := lrc_Customer.Address;
                "Sell-to Address 2" := lrc_Customer."Address 2";
                "Sell-to Contact No." := lrc_Customer."Primary Contact No.";
                "Sell-to Contact" := lrc_Customer.Contact;
                "Sell-to Country Code" := lrc_Customer."Country/Region Code";
                "Sell-to Post Code" := lrc_Customer."Post Code";
                "Sell-to City" := lrc_Customer.City;
                "Language Code" := lrc_Customer."Language Code";
                "Sell-to Phone No." := lrc_Customer."Phone No.";
            end;
        }
        field(11; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(12; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(14; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';
        }
        field(15; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(16; "Sell-to Contact No."; Code[100])
        {
            Caption = 'Sell-to Contact No.';
        }
        field(17; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
        }
        field(18; "Sell-to Country Code"; Code[10])
        {
            Caption = 'Sell-to Country Code';
            TableRelation = "Country/Region";
        }
        field(19; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";

            // trigger OnLookup() //TODO: prüfen
            // var
            //     lrc_PostCode: Record "Post Code";
            // begin
            //     //lrc_PostCode.LookUpPostCode("Sell-to City", "Sell-to Post Code", TRUE);
            // end;

            // trigger OnValidate()
            // var
            //     lrc_PostCode: Record "Post Code";
            // begin
            //     //lrc_PostCode.ValidatePostCode("Sell-to City", "Sell-to Post Code");
            // end;
        }
        field(20; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(23; "Sell-to Phone No."; Text[30])
        {
            Caption = 'Sell-to Phone No.';
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
        field(41; "Claim Date"; Date)
        {
            Caption = 'Claim Date';
        }
        field(42; "Cust.-Claim No."; Code[20])
        {
            Caption = 'Cust.-Claim No.';
        }
        field(44; "Document State"; Option)
        {
            Caption = 'Document State';
            OptionCaption = ' ,Offen,,,,,,,,,,Erfassung abgeschlossen,,,,,Freigabe Lager,,,,,Fehlerhafte Rückmeldung Lager,,,,,Rückmeldung Lager,,,,,Storniert';
            OptionMembers = " ",Offen,,,,,,,,,,"Erfassung abgeschlossen",,,,,"Freigabe Lager",,,,,"Fehlerhafte Rückmeldung Lager",,,,,"Rückmeldung Lager",,,,,Storniert;
        }
        field(45; "Person in Charge Code"; Code[10])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser".Code WHERE("POI Is Person in Charge" = CONST(true));
        }
        field(46; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser".Code WHERE("POI Is Person in Charge" = CONST(true));

            trigger OnValidate()
            begin
                IF ((xRec."Salesperson Code" <> '') AND (COMPANYNAME() = 'PI Fruit GmbH')) THEN
                    ERROR('Der Verkäufercode darf nicht geändert werden');
            end;
        }
        field(50; "Freight Order No."; Code[20])
        {
            Caption = 'Freight Order No.';
            TableRelation = "POI Freight Order Header"."No.";
        }
        field(52; "Freight Cost Amount (LC)"; Decimal)
        {
            Caption = 'Freight Cost Amount (LC)';
        }
        field(55; "Sales Shipment Posting Date"; Date)
        {
            Caption = 'Sales Shipment Posting Date';
            Editable = false;
        }
        field(56; "Sales Shipment No."; Code[20])
        {
            Caption = 'Sales Shipment No.';
            TableRelation = IF ("Sell-to Customer No." = FILTER(<> '')) "Sales Shipment Header"."No." WHERE("Sell-to Customer No." = FIELD("Sell-to Customer No."))
            ELSE
            IF ("Sell-to Customer No." = FILTER('')) "Sales Shipment Header"."No.";

            trigger OnValidate()
            var

                lrc_SalesClaimAdviceLine: Record "POI Sales Claim Notify Line";
                lrc_SalesShipmentHeader: Record "Sales Shipment Header";
                lcu_SalesClaimAdvice: Codeunit "POI Sales Claim Mgt";
            begin
                TestStatus();
                IF "Sales Shipment No." = xRec."Sales Shipment No." THEN
                    EXIT;

                IF xRec."Sales Shipment No." <> '' THEN BEGIN
                    lrc_SalesClaimAdviceLine.SETRANGE("Document No.", "No.");
                    lrc_SalesClaimAdviceLine.DELETEALL(TRUE);
                END;

                lcu_SalesClaimAdvice.LoadClaimFromShipment(Rec, "Sales Shipment No.");

                IF "Sales Shipment No." <> '' THEN BEGIN
                    IF lrc_SalesShipmentHeader.GET("Sales Shipment No.") THEN BEGIN
                        "Sales Shipment Posting Date" := lrc_SalesShipmentHeader."Posting Date";
                        "Shipment Date" := lrc_SalesShipmentHeader."Shipment Date";
                    END ELSE
                        "Sales Shipment Posting Date" := 0D;
                END ELSE
                    "Sales Shipment Posting Date" := 0D;

                MODIFY();

            end;
        }
        field(57; "Sales Invoice No."; Code[20])
        {
            Caption = 'Sales Invoice No.';
            TableRelation = IF ("Sell-to Customer No." = FILTER(<> '')) "Sales Invoice Header"."No." WHERE("Sell-to Customer No." = FIELD("Sell-to Customer No."))
            ELSE
            IF ("Sell-to Customer No." = FILTER('')) "Sales Invoice Header"."No.";

            trigger OnValidate()
            var
                lrc_SalesClaimAdviceLine: Record "POI Sales Claim Notify Line";
                lrc_SalesInvoiceHeader: Record "Sales Invoice Header";
                lcu_SalesClaimAdvice: Codeunit "POI Sales Claim Mgt";
            begin
                TestStatus();

                IF "Sales Invoice No." = xRec."Sales Invoice No." THEN
                    EXIT;

                IF xRec."Sales Invoice No." <> '' THEN BEGIN
                    lrc_SalesClaimAdviceLine.SETRANGE("Document No.", "No.");
                    lrc_SalesClaimAdviceLine.DELETEALL(TRUE);
                END;
                lcu_SalesClaimAdvice.LoadClaimFromInvoice(Rec, "Sales Invoice No.");

                IF "Sales Invoice No." <> '' THEN BEGIN
                    IF lrc_SalesInvoiceHeader.GET("Sales Cust. Invoice No.") THEN
                        "Sales Invoice Posting Date" := lrc_SalesInvoiceHeader."Posting Date"
                    ELSE
                        "Sales Invoice Posting Date" := 0D;
                    IF lrc_SalesInvoiceHeader.GET("Sales Invoice No.") THEN
                        "Shipment Date" := lrc_SalesInvoiceHeader."Shipment Date";
                END ELSE
                    "Sales Invoice Posting Date" := 0D;


                MODIFY();
            end;
        }
        field(58; "Sales Invoice Posting Date"; Date)
        {
            Caption = 'Sales Invoice Posting Date';
            Editable = false;
        }
        field(59; "Sales Salesperson Code"; Code[20])
        {
            Caption = 'Sales Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(60; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            TableRelation = IF ("Sell-to Customer No." = FILTER(<> '')) "Sales Header"."No." WHERE("Document Type" = CONST(Order),
                                                                                             "Sell-to Customer No." = FIELD("Sell-to Customer No."))
            ELSE
            IF ("Sell-to Customer No." = FILTER('')) "Sales Header"."No." WHERE("Document Type" = CONST(Order));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                lcu_SalesClaimMgt: Codeunit "POI Sales Claim Mgt";
            begin
                lcu_SalesClaimMgt.LoadClaim(Rec, "Sales Order No.", '', '');
            end;
        }
        field(61; "Sales Order Date"; Date)
        {
            Caption = 'Sales Order Date';
        }
        field(62; "Sales Shipment Date"; Date)
        {
            Caption = 'Sales Shipment Date';
        }
        field(63; "Sales Means of Transport"; Option)
        {
            Caption = 'Means of Transport';
            Description = ' ,LKW,Bahn,Schiff,Flugzeug';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(64; "Sales Means of Transp. Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
            TableRelation = IF ("Sales Means of Transport" = CONST(Truck)) "POI Means of Transport".Code WHERE(Type = CONST(Truck))
            ELSE
            IF ("Sales Means of Transport" = CONST(Train)) "poI Means of Transport".Code WHERE(Type = CONST(Train))
            ELSE
            IF ("Sales Means of Transport" = CONST(Ship)) "POI Means of Transport".Code WHERE(Type = CONST(Ship))
            ELSE
            IF ("Sales Means of Transport" = CONST(Airplane)) "POI Means of Transport".Code WHERE(Type = CONST(Airplane));
            ValidateTableRelation = false;
        }
        field(65; "Sales Means of Transp. Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
        }
        field(66; "Sales Arrival Region Code"; Code[20])
        {
            Caption = 'Sales Arrival Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
        }
        field(68; "Sales Doc. Subtyp Code"; Code[10])
        {
            Caption = 'Sales Doc. Subtyp Code';
        }
        field(70; "Your Reference"; Text[70])
        {
            Caption = 'Your Reference';
        }
        field(71; Comment; Boolean)
        {
            CalcFormula = Exist ("POI Sales Claim Notify Comment" WHERE("Document No." = FIELD("No."),
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
        field(75; "Sales Cust. Order No."; Code[20])
        {
            Caption = 'Sales Cust. Order No.';
        }
        field(76; "Sales Cust. Shipment No."; Code[20])
        {
            Caption = 'Sales Cust. Shipment No.';
        }
        field(77; "Sales Cust. Invoice No."; Code[20])
        {
            Caption = 'Sales Cust. Invoice No.';
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

            trigger OnValidate()
            var

            begin
                //POI 002 00000000 JST 051112 Bedingung "return to" für Location oder Kreditor ausgeschaltet
                //IF "Return to" <> "Return to"::"Claim Location" THEN
                //  ERROR('Eingabe nicht zulässig!');

                IF "Return to Location Code" <> '' THEN BEGIN
                    lrc_SalesClaimLine.SETRANGE("Document No.", "No.");
                    IF lrc_SalesClaimLine.FINDSET(TRUE, FALSE) THEN
                        REPEAT
                            lrc_SalesClaimLine.VALIDATE("Claim Location Code", "Return to Location Code");
                            lrc_SalesClaimLine.MODIFY();
                        UNTIL lrc_SalesClaimLine.NEXT() = 0;
                END ELSE BEGIN
                    lrc_SalesClaimLine.SETRANGE("Document No.", "No.");
                    IF lrc_SalesClaimLine.FINDSET(TRUE, FALSE) THEN
                        REPEAT
                            lrc_SalesClaimLine.VALIDATE("Claim Location Code", lrc_SalesClaimLine."Location Code");
                            lrc_SalesClaimLine.MODIFY();
                        UNTIL lrc_SalesClaimLine.NEXT() = 0;
                END;
            end;
        }
        field(82; "Return to Vendor No."; Code[20])
        {
            Caption = 'Return to Vendor No.';
            TableRelation = Vendor;
        }
        field(85; "Cost Return Freight Paid by"; Code[20])
        {
            Caption = 'Cost Return Freight Paid by';
            TableRelation = Vendor;
        }
        field(90; "Freight Cost"; Option)
        {
            Caption = 'Freight Cost';
            Description = ' ,Company,Vendor,Shipping Agent,Logistic Company,Packing Company';
            OptionCaption = ' ,Company,Vendor,Shipping Agent,Logistic Company,Packing Company';
            OptionMembers = " ",Company,Vendor,"Shipping Agent","Logistic Company","Packing Company";
        }
        field(91; "Freight Cost to Vendor No."; Code[20])
        {
            Caption = 'Freight Cost to Vendor No.';
            TableRelation = Vendor;
        }
        field(100; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            Editable = false;
            TableRelation = "Shipping Agent";
        }
        field(101; "Claim Shipping Agent Code"; Code[10])
        {
            Caption = 'Claim Shipping Agent Code';
            TableRelation = "Shipping Agent".Code;

            trigger OnValidate()
            begin
                lrc_SalesClaimLine.RESET();
                lrc_SalesClaimLine.SETRANGE("Document No.", "No.");
                IF lrc_SalesClaimLine.FINDSET(TRUE, FALSE) THEN
                    IF "Claim Shipping Agent Code" <> '' THEN
                        lrc_SalesClaimLine.MODIFYALL("Claim Shipping Agent Code", "Claim Shipping Agent Code")
                    ELSE
                        REPEAT
                            lrc_SalesClaimLine."Claim Shipping Agent Code" := lrc_SalesClaimLine."Shipping Agent Code";
                            lrc_SalesClaimLine.MODIFY();
                        UNTIL lrc_SalesClaimLine.NEXT() = 0;
            end;
        }
        field(105; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            Editable = false;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(106; "Claim Location Code"; Code[10])
        {
            Caption = 'Claim Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            begin
                lrc_SalesClaimLine.RESET();
                lrc_SalesClaimLine.SETRANGE("Document No.", "No.");
                IF lrc_SalesClaimLine.FINDSET(TRUE, FALSE) THEN
                    IF "Claim Location Code" <> '' THEN
                        lrc_SalesClaimLine.MODIFYALL("Claim Location Code", "Claim Location Code")
                    ELSE
                        REPEAT
                            lrc_SalesClaimLine."Claim Location Code" := lrc_SalesClaimLine."Location Code";
                            lrc_SalesClaimLine.MODIFY();
                        UNTIL lrc_SalesClaimLine.NEXT() = 0;
            end;
        }
        field(110; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
            ValidateTableRelation = false;

        }
        field(111; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
        }
        field(112; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
        }
        field(114; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address';
        }
        field(115; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(116; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
        }
        field(117; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';
        }
        field(118; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(119; "Bill-to Country Code"; Code[10])
        {
            Caption = 'Bill-to Country Code';
            TableRelation = "Country/Region";
        }
        field(130; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate()
            begin
                IF "Ship-to Code" <> '' THEN BEGIN
                    ShipToAddr.GET("Sell-to Customer No.", "Ship-to Code");
                    "Ship-to Name" := ShipToAddr.Name;
                    "Ship-to Name 2" := ShipToAddr."Name 2";
                    "Ship-to Address" := ShipToAddr.Address;
                    "Ship-to Address 2" := ShipToAddr."Address 2";
                    "Ship-to City" := ShipToAddr.City;
                    "Ship-to Post Code" := ShipToAddr."Post Code";
                    "Ship-to Country/Region Code" := ShipToAddr."Country/Region Code";
                    "Ship-to Country Code" := ShipToAddr."Country/Region Code";
                    "Ship-to Contact" := ShipToAddr.Contact;
                    "Ship-to-Tel" := ShipToAddr."Phone No.";
                    "Ship-to-Fax" := ShipToAddr."Fax No.";
                    "Ship-to-mail" := ShipToAddr."E-Mail";
                    //  IF ShipToAddr."Location Code" <> '' THEN
                    //    VALIDATE("Location Code",ShipToAddr."Location Code");
                END ELSE BEGIN
                    TESTFIELD("Sell-to Customer No.");
                    Cust.GET("Sell-to Customer No.");
                    "Ship-to Name" := Cust.Name;
                    "Ship-to Name 2" := Cust."Name 2";
                    "Ship-to Address" := Cust.Address;
                    "Ship-to Address 2" := Cust."Address 2";
                    "Ship-to City" := Cust.City;
                    "Ship-to Post Code" := Cust."Post Code";
                    "Ship-to Country/Region Code" := Cust."Country/Region Code";
                    "Ship-to Country Code" := Cust."Country/Region Code";
                    "Ship-to Contact" := Cust.Contact;
                    "Ship-to-Tel" := Cust."Phone No.";
                    "Ship-to-Fax" := Cust."Fax No.";
                    "Ship-to-mail" := Cust."E-Mail";

                    //  IF Cust."Location Code" <> '' THEN
                    //    VALIDATE("Location Code",Cust."Location Code");
                END;
            end;
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
        field(137; "Ship-to Contact"; Text[100])
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
        field(150; "Refered to"; Code[20])
        {
            Caption = 'Refered to';
        }
        field(153; "Refered Date"; Date)
        {
            Caption = 'Refered Date';
        }
        field(154; "Refered by"; Code[20])
        {
            Caption = 'Refered by';
        }
        field(200; "Sales Cr. Memo No."; Code[20])
        {
            CalcFormula = Lookup ("Sales Cr.Memo Header"."No." WHERE("POI Sales Claim No." = FIELD("No.")));
            Caption = 'Sales Cr. Memo No.';
            Description = 'Flowfield';
            FieldClass = FlowField;
            TableRelation = "Sales Cr.Memo Header"."No.";
        }
        field(201; "Posted Sales Cr. Memo No."; Code[20])
        {
            Caption = 'Posted Sales Cr. Memo No.';
        }
        field(250; "Sales Amount"; Decimal)
        {
            CalcFormula = Sum ("POI Sales Claim Notify Line"."Sales Amount" WHERE("Document No." = FIELD("No."),
                                                                              Claim = CONST(true)));
            Caption = 'Sales Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(251; "Claim Amount"; Decimal)
        {
            CalcFormula = Sum ("POI Sales Claim Notify Line"."Claim Sales Amount" WHERE("Document No." = FIELD("No."),
                                                                                    Claim = CONST(true)));
            Caption = 'Claim Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(252; "Difference Amount"; Decimal)
        {
            Caption = 'Difference Amount';
        }
        field(260; "Additional Costs"; Decimal)
        {
            CalcFormula = Sum ("POI Sales Claim Notify Cost"."Amount (LCY)" WHERE("Document No." = FIELD("No.")));
            Caption = 'Additional Costs';
            Editable = false;
            FieldClass = FlowField;
        }
        field(300; "Pallet Entry ID"; Integer)
        {
            Caption = 'Pallet Entry ID';
            Description = 'PAL';
        }
        field(400; "Scanner User ID"; Code[20])
        {
            Caption = 'Scanner User ID';
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
        field(50003; "Ship-to-mail"; Text[250])
        {
            Description = '80 > 250';
        }
        field(50004; Besichtigungsstatus; Option)
        {
            Caption = 'Return to';
            Description = ' ,keine,erforderlich,erfolgt';
            OptionCaption = ' ,keine,erforderlich,erfolgt';
            OptionMembers = " ",keine,erforderlich,erfolgt;

            trigger OnValidate()
            begin
                CASE "Return to" OF
                    "Return to"::" ":
                        BEGIN
                            "Return to Location Code" := '';
                            "Return to Vendor No." := '';
                        END;
                    "Return to"::"Claim Location":
                        "Return to Vendor No." := '';
                    "Return to"::Vendor:
                        "Return to Location Code" := '';
                END;
            end;
        }
        field(50010; "Master Batch No."; Code[20])
        {
            Caption = 'Partienr.';
        }
        field(50011; "Buy-from Vendor No."; Code[10])
        {
            Caption = 'Eink. von Kred.-Nr.';
        }
        field(50012; "Vendor Order No."; Code[20])
        {
            Caption = 'Kred.-Bestellnr.';
        }
        field(50020; "Vendor Expected Receipt Date"; Date)
        {
            CalcFormula = Lookup ("Purchase Header"."Expected Receipt Date" WHERE("No." = FIELD("Master Batch No.")));
            Caption = 'Kred. Erwartetes Wareneingangsdatum';
            FieldClass = FlowField;
        }
        field(50021; "Claim Status"; Option)
        {
            Caption = 'Reklamationsstatus';
            OptionMembers = erfasst,Kreditormeldung,"zur Prüfung",Abrechnen,Gutschrifterstellung;
        }
        field(50022; "Vendor Means of Transp. Code"; Code[20])
        {
            CalcFormula = Lookup ("Purchase Header"."POI Means of TransCode(Arriva)" WHERE("No." = FIELD("Master Batch No.")));
            Caption = 'Kred. Transportmittel Code (Ankunft)';
            FieldClass = FlowField;
        }
        field(50023; "Vendor Report to No."; Date)
        {
            Caption = 'Kred. Meldung an';
        }
        field(50024; "Vendor Port of Discharge Code"; Code[10])
        {
            CalcFormula = Lookup ("Purchase Header"."POI Port of Disch. Code (UDE)" WHERE("No." = FIELD("Master Batch No.")));
            Caption = 'Port of Discharge Code (UDE)';
            FieldClass = FlowField;
            TableRelation = "Entry/Exit Point";
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
        key(Key3; "Sales Shipment No.", Status)
        {
        }
        key(Key4; "Claim Doc. Subtype Code")
        {
        }
        key(Key5; "Sell-to Customer No.")
        {
        }
    }

    trigger OnDelete()
    var
        lrc_SalesClaimReason: Record "POI Sales Claim Notify Reason";
        lrc_SalesClaimComment: Record "POI Sales Claim Notify Comment";
        lrc_FreightCostControle: Record "POI Freight Cost Controle";
        lrc_SalesHeader: Record "Sales Header";
        lrc_SalesCMHeader: Record "Sales Cr.Memo Header";
    begin
        //Prüfung ob GS oder gebuchte GS besteht.
        lrc_SalesHeader.SETRANGE("POI Sales Claim Notify No.", "No.");
        //IF lrc_SalesHeader.FINDSET(FALSE, FALSE) THEN
        IF not lrc_SalesHeader.IsEmpty() THEN
            ERROR('Aus der Rekla ist bereits eine Gutschrift erstellt. Bitte zuerst die GS löschen, bevor die Rekla gelöscht werden kann.');
        lrc_SalesCMHeader.SETRANGE("POI Sales Claim No.", "No.");
        //IF lrc_SalesCMHeader.FINDSET(FALSE, FALSE) THEN
        IF not lrc_SalesCMHeader.IsEmpty() THEN
            ERROR('Es besteht bereits eine gebuchte Gutschrift, Löschung nich mehr zulässig!');


        lrc_SalesClaimLine.SETRANGE("Document No.", "No.");
        lrc_SalesClaimLine.DELETEALL();

        lrc_SalesClaimReason.SETRANGE("Document No.", "No.");
        lrc_SalesClaimReason.DELETEALL();

        lrc_SalesClaimComment.SETRANGE("Document No.", "No.");
        lrc_SalesClaimComment.DELETEALL();

        // Bestehende Einträge ohne Frachtrechnung löschen
        lrc_FreightCostControle.RESET();
        lrc_FreightCostControle.SETRANGE(Source, lrc_FreightCostControle.Source::"Sales Claim Order");
        lrc_FreightCostControle.SETRANGE("Source No.", "No.");
        lrc_FreightCostControle.SETRANGE("Freight Inv. Recieved", FALSE);
        IF NOT lrc_FreightCostControle.ISEMPTY() THEN
            lrc_FreightCostControle.DELETEALL();
    end;

    trigger OnInsert()
    var

        lrc_ADFSetup: Record "POI ADF Setup";
        lrc_ClaimDocSubtype: Record "POI Claim Doc. Subtype";
        lrc_UserSetup: Record "User Setup";
        "Sales Claim Notify Comment": Record "POI Sales Claim Notify Comment";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        InitClaimDocSubtype();
        IF "Claim Doc. Subtype Code" <> '' THEN BEGIN
            lrc_ClaimDocSubtype.GET(lrc_ClaimDocSubtype."Document Type"::"Sales Claim", "Claim Doc. Subtype Code");
            IF "No." = '' THEN
                IF lrc_ClaimDocSubtype."Document No. Series" <> '' THEN
                    lcu_NoSeriesManagement.InitSeries(lrc_ClaimDocSubtype."Document No. Series",
                                                      xRec."No. Series", "Document Date", "No.", "No. Series");
        END;

        IF "No." = '' THEN BEGIN

            IF CONFIRM('Altes Geschäftsjahr', FALSE) THEN
                WORKDATE := 20190930D
            ELSE
                WORKDATE := TODAY();

            lrc_ADFSetup.GET();
            lrc_ADFSetup.TESTFIELD("Sales Claim No. Series");
            lcu_NoSeriesManagement.InitSeries(lrc_ADFSetup."Sales Claim No. Series",
                                              xRec."No. Series", "Document Date", "No.", "No. Series");
        END;


        IF WORKDATE() = 20190930D THEN BEGIN
            "Document Date" := WORKDATE();
            "Claim Date" := WORKDATE();
        END ELSE BEGIN
            "Document Date" := TODAY();
            "Claim Date" := TODAY();
        END;


        // Verkäufer und Sachbearbeiter über User Setup setzen
        IF lrc_UserSetup.GET(USERID()) THEN BEGIN
            IF lrc_UserSetup."POI Person in Charge Code" <> '' THEN
                "Person in Charge Code" := lrc_UserSetup."POI Person in Charge Code";
            IF lrc_UserSetup."POI Salesperson Code" <> '' THEN
                "Salesperson Code" := lrc_UserSetup."POI Salesperson Code";
        END;


        //ClaimSatus Angepasst und Bemerkungseintrag Status bei Insert
        "Sales Claim Notify Comment"."Document No." := "No.";
        "Sales Claim Notify Comment"."Doc. Line No." := 10000;
        "Sales Claim Notify Comment"."Claim Status" := "Claim Status";
        "Sales Claim Notify Comment"."Status Date" := TODAY();
        "Sales Claim Notify Comment".Status := TRUE;
        "Sales Claim Notify Comment".INSERT(TRUE);

        //VerzeichnisEintrag erstellen
        //InitClaimPath(1);
    end;

    var
        Cust: Record Customer;
        ShipToAddr: Record "Ship-to Address";
        gbn_NoStatusCheck: Boolean;

    procedure AssistEdit(lrc_OldSalesClaimAdviceHeader: Record "POI Sales Claim Notify Header"): Boolean
    var
        lrc_SalesClaimAdviceHeader: Record "POI Sales Claim Notify Header";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        lrc_SalesClaimAdviceHeader := Rec;
        lrc_FruitVisionSetup.GET();
        lrc_FruitVisionSetup.TESTFIELD("Sales Claim No. Series");
        IF lcu_NoSeriesManagement.SelectSeries(
          lrc_FruitVisionSetup."Sales Claim No. Series",
          lrc_OldSalesClaimAdviceHeader."No.", "No. Series") THEN BEGIN
            lcu_NoSeriesManagement.SetSeries("No.");
            Rec := lrc_SalesClaimAdviceHeader;
            EXIT(TRUE);
        END;
    end;

    procedure PrintRecords(ShowRequestForm: Boolean)
    var
        lrc_SalesClaimAdviceHeader: Record "POI Sales Claim Notify Header";
        lcu_PrintFaxMailGlobals: Codeunit "POI PrintFaxMail Globals";
    begin
        WITH lrc_SalesClaimAdviceHeader DO
            COPY(Rec);
        lrc_PrintDocument.RESET();
        lrc_PrintDocument.SETRANGE("Document Source", lrc_PrintDocument."Document Source"::Sales);
        lrc_PrintDocument.SETRANGE("Document Type", lrc_PrintDocument."Document Type"::"Posted Return Shipment/Receipt");
        lrc_PrintDocument.SETRANGE(Code, 'V R');
        IF lrc_PrintDocument.FIND('-') THEN begin
            REPEAT
                lcu_PrintFaxMailGlobals.ClearPrintDocRec();
                REPORT.RUNMODAL(lrc_PrintDocument."Report ID", ShowRequestForm, FALSE, lrc_SalesClaimAdviceHeader);
            UNTIL lrc_PrintDocument.NEXT() = 0;
            lcu_PrintFaxMailGlobals.ClearPrintDocRec();
        end;
    end;

    procedure TestStatus()
    var
        ADF_LT_TEXT001Txt: Label 'Status muss offen sein!';
    begin
        // --------------------------------------------------------------------------------
        // Funktion zur Prüfung des Status
        // --------------------------------------------------------------------------------

        IF gbn_NoStatusCheck = TRUE THEN
            EXIT;

        IF Status <> Status::Open THEN
            // Status muss offen sein!
            ERROR(ADF_LT_TEXT001Txt);
    end;

    procedure InitClaimDocSubtype()
    begin
        IF "Claim Doc. Subtype Code" = '' THEN BEGIN
            lrc_ClaimDocType.RESET();
            lrc_ClaimDocType.SETRANGE("Document Type", lrc_ClaimDocType."Document Type"::"Sales Claim");
            IF lrc_ClaimDocType.FINDFIRST() THEN
                "Claim Doc. Subtype Code" := lrc_ClaimDocType.Code;
        END;
    end;

    procedure GetCust(CustNo: Code[20])
    begin
        IF CustNo <> Cust."No." THEN
            Cust.GET(CustNo)
        ELSE
            CLEAR(Cust);
    end;

    procedure DiffDateReklamationAnkunft() Differenz: Text[30]
    begin
        Differenz := '';
        CALCFIELDS("Vendor Expected Receipt Date");
        IF ("Claim Date" <> 0D) AND ("Vendor Expected Receipt Date" <> 0D)
          THEN
            Differenz := FORMAT("Claim Date" - "Vendor Expected Receipt Date");
    end;

    // procedure InitClaimPath("Action": Integer) //TODO:
    // var
    //     PortSetupII: Record "50005";
    //     Filename: Text[250];
    //     ffile: File;
    //     Shellcommand: Text[30];
    // begin
    //     IF STRPOS(CONTEXTURL,'NAVISION') = 0 THEN
    //       EXIT;

    //     //140123 mly - copy  code tab5110461, field change to "Path Sales Claim"
    //     //POI 001 EKREK    JST 211013 001 Einführung Einkaufsreklamation
    //     CASE Action OF
    //       1 : Shellcommand:='mkdir';
    //       2 : Shellcommand:='explorer';
    //     END;

    //     PortSetupII.GET();

    //     //mly
    //     PortSetupII.TESTFIELD("Path Sales Claim");

    //     Filename:='\\port-nav-01\navclient\MakeDir\makeDir' + USERID() + '.bat';
    //     IF EXISTS(Filename) THEN ERASE(Filename);
    //     IF NOT (ffile.CREATE(Filename)) THEN //Hat das geklappt
    //       ERROR('Datei %1 konnte nicht erstellt werden',Filename);
    //     IF NOT (ffile.WRITEMODE(TRUE)) THEN           //sind Schreibrechte da ??
    //       ERROR ('In Datei %1 kann nicht auf Write-Mode geschaltet werden',Filename);
    //     IF NOT (ffile.TEXTMODE(TRUE)) THEN                //True ist ASCII False ist Binary
    //       ERROR ('Datei %1 kann nicht in ASCII-Mode geschaltet werden',Filename);
    //     ffile.WRITE('mkdir' + ' '+PortSetupII."Path Sales Claim" +'\' + "No.");
    //     ffile.WRITE(Shellcommand + ' '+PortSetupII."Path Sales Claim" +'\' + "No.");
    //     ffile.CLOSE();
    //     //SHELL(Filename); //TODO: prüfen
    // end;

    var
        lrc_SalesClaimLine: Record "POI Sales Claim Notify Line";
        lrc_PrintDocument: Record "POI Print Documents";
        lrc_ClaimDocType: Record "POI Claim Doc. Subtype";
}

