table 5110439 "POI Freight Order Header"
{

    Caption = 'Freight Order Header';
    // DrillDownFormID = Form5088021;
    // LookupFormID = Form5088021;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "Tour Code"; Code[50])
        {
            Caption = 'Tour Code';
            TableRelation = "POI Tour";

            trigger OnValidate()
            var
                lrc_FreightOrderLine: Record "POI Freight Order Line";
                lrc_Tour: Record "POI Tour";
            begin
                // Kontrolle ob die Tour geändert wurde --> Zeilen / Detailzeilen löschen
                IF xRec."Tour Code" <> '' THEN BEGIN
                    lrc_FreightOrderLine.SETRANGE("Freight Order No.", "No.");
                    IF lrc_FreightOrderLine.FIND('-') THEN
                        lrc_FreightOrderLine.DELETEALL(TRUE);
                END;
                IF "Tour Code" = '' THEN
                    EXIT;

                lrc_Tour.GET("Tour Code");
                "Tour Description" := lrc_Tour.Description;
                VALIDATE("Shipping Agent Code", lrc_Tour."Shipping Agent Code");
            end;
        }
        field(11; "Tour Description"; Text[50])
        {
            Caption = 'Tour Description';
        }
        field(15; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(16; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                // Zeilen aktualisieren
                lrc_FreightOrderLine.SETRANGE("Freight Order No.", "No.");
                IF lrc_FreightOrderLine.FIND('-') THEN
                    REPEAT
                        lrc_FreightOrderLine."Promised Delivery Date" := "Promised Delivery Date";
                        lrc_FreightOrderLine.MODIFY();
                    UNTIL lrc_FreightOrderLine.NEXT() = 0;
            end;
        }
        field(17; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(18; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(20; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent".Code WHERE("POI Blocked" = CONST(true));

            trigger OnValidate()
            var
                lrc_ShippingAgent: Record "Shipping Agent";
            begin
                IF lrc_ShippingAgent.GET("Shipping Agent Code") THEN BEGIN
                    "Shipping Agent Name" := lrc_ShippingAgent.Name;
                    "Freight Cost Tariff Base" := lrc_ShippingAgent."POI Freight Cost Tariff Base";
                END ELSE
                    "Shipping Agent Name" := '';
            end;
        }
        field(21; "Shipping Agent Name"; Text[50])
        {
            Caption = 'Shipping Agent Name';
        }
        field(22; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(25; "Loading Temperature"; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Loading Temperature';
            DecimalPlaces = 1 : 1;
        }
        field(40; "Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Type';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(41; "Means of Transport Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
            TableRelation = "POI Means of Transport".Code WHERE(Type = FIELD("Means of Transport Type"));
            ValidateTableRelation = false;

            trigger OnValidate()

            begin
                lrc_MeansofTransport.RESET();
                lrc_MeansofTransport.SETRANGE(Type, "Means of Transport Type");
                lrc_MeansofTransport.SETRANGE(Code, "Means of Transport Code");
                IF lrc_MeansofTransport.FIND('-') THEN BEGIN
                    "Means of Transport Info" := lrc_MeansofTransport."Means of Transport Info";
                    "Truck Driver" := lrc_MeansofTransport."Truck Driver";
                    "Truck Driver 2" := lrc_MeansofTransport."Truck Driver 2";
                    "Truck Phone No." := lrc_MeansofTransport."Truck Phone No.";
                END;
            end;
        }
        field(42; "Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
        }
        field(50; "Freight Costs (LCY)"; Decimal)
        {
            Caption = 'Freight Costs (LCY)';

            trigger OnValidate()
            var
                lcu_FreightMgt: Codeunit "POI Freight Management";
            begin
                IF CurrFieldNo = FIELDNO("Freight Costs (LCY)") THEN
                    "Freight Cost Manual" := TRUE
                ELSE
                    "Freight Cost Manual" := FALSE;

                // Frachtkosten berechnen und verteilen
                lcu_FreightMgt.AllocateFreightCost(Rec);
            end;
        }
        field(51; "Freight Cost Tariff Base"; Option)
        {
            Caption = 'Freight Cost Tariff Base';
            OptionCaption = 'Collo,Pallet,Weight,Pallet Type,Collo Weight,,,,,,,,,,from Position';
            OptionMembers = Collo,Pallet,Weight,"Pallet Type","Collo Weight",,,,,,,,,,"from Position";

            trigger OnValidate()
            begin
                IF "Freight Cost Tariff Base" <> "Freight Cost Tariff Base"::Pallet THEN
                    ERROR('Es sind nur Paletten zugelassen!');
            end;
        }
        field(52; "Freight Cost Manual"; Boolean)
        {
            Caption = 'Freight Cost Manual';
        }
        field(60; "Kilometer Reading Start"; Decimal)
        {
            Caption = 'Kilometer Reading Start';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
        }
        field(61; "Kilometer Reading End"; Decimal)
        {
            Caption = 'Kilometer Reading End';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
        }
        field(63; "Kilometer Toll"; Decimal)
        {
            Caption = 'Kilometer Toll';
        }
        field(65; "Truck Driver"; Text[30])
        {
            Caption = 'Truck Driver';
        }
        field(66; "Truck Driver 2"; Text[30])
        {
            Caption = 'Truck Driver 2';
        }
        field(68; "Truck Phone No."; Text[30])
        {
            Caption = 'Truck Phone No.';
        }
        field(70; "Begin Working Time"; Time)
        {
            Caption = 'Begin Working Time';
        }
        field(71; "End Working Time"; Time)
        {
            Caption = 'End Working Time';
        }
        field(100; "Total Gross Weight"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Detail Line"."Total Gross Weight" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Total Gross Weight';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Total Net Weight"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Detail Line"."Total Net Weight" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Total Net Weight';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Calc. Qty. Pallets to Ship"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Freight Order Detail Line"."Qty. Transport Unit to Ship" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Calc. Qty. Pallets to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(103; "Calc. Qty. Colli to Ship"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Freight Order Detail Line"."Qty. to Ship" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Calc. Qty. Colli to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Calc. Gross Weight to Ship"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Freight Order Detail Line"."Total Gross Weight to Ship" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Calc. Gross Weight to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Calc. Net Weight to Ship"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Freight Order Detail Line"."Total Net Weight to Ship" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Calc. Net Weight to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(108; "Quantity Pallets"; Decimal)
        {
            Caption = 'Quantity Pallets';
        }
        field(110; "No. of Locations"; Integer)
        {
            CalcFormula = Count ("POI Freight Order Line" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'No. of Locations';
            Editable = false;
            FieldClass = FlowField;
        }
        field(112; "Calc. Qty. Colli"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Sum ("POI Freight Order Detail Line"."Quantity Order" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Calc. Qty. Colli';
            Editable = false;
            FieldClass = FlowField;
        }
        field(114; "Calc. Qty. Pallets"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Detail Line"."Qty. Transport Unit" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Calc. Qty. Pallets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Promised Delivery Until Time"; Time)
        {
            Caption = 'Promised Delivery Until Time';
        }
        field(121; "Promised Delivery From Time"; Time)
        {
            Caption = 'Promised Delivery From Time';
        }
        field(125; "Delivery Comment"; Text[50])
        {
            Caption = 'Delivery Comment';
        }
        field(199; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(200; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Planing,Released,Closed';
            OptionMembers = Planing,Released,Closed;
        }
        field(310; "Arrival Type"; Option)
        {
            Caption = 'Arrival Type';
            Description = 'Customer,Ship-To Address,Vendor,Pick-Up Addresse,,,Location';
            OptionCaption = 'Customer,Ship-To Address,Vendor,Pick-Up Addresse,,,Location';
            OptionMembers = Customer,"Ship-To Address",Vendor,"Pick-Up Addresse",,,Location;
        }
        field(311; "Arrival Code"; Code[20])
        {
            Caption = 'Arrival Code';
            TableRelation = IF ("Arrival Type" = CONST(Customer)) Customer
            ELSE
            IF ("Arrival Type" = CONST("Ship-To Address")) Customer
            ELSE
            IF ("Arrival Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Arrival Type" = CONST("Pick-Up Addresse")) Vendor
            ELSE
            IF ("Arrival Type" = CONST(Location)) Location WHERE("Use As In-Transit" = CONST(true));

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
                lrc_Vendor: Record Vendor;
                lrc_Location: Record Location;
            begin
                IF "Arrival Code" = '' THEN BEGIN
                    "Arrival Subcode" := '';
                    "Arrival Name" := '';
                    "Arrival Name 2" := '';
                    "Arrival Address" := '';
                    "Arrival Address 2" := '';
                    "Arrival Country Code" := '';
                    "Arrival Post Code" := '';
                    "Arrival City" := '';
                    "Arrival Phone No." := '';
                    EXIT;
                END;

                CASE "Arrival Type" OF
                    "Arrival Type"::Customer, "Arrival Type"::"Ship-To Address":
                        BEGIN
                            lrc_Customer.GET("Arrival Code");
                            "Arrival Subcode" := '';
                            "Arrival Name" := lrc_Customer.Name;
                            "Arrival Name 2" := lrc_Customer."Name 2";
                            "Arrival Address" := lrc_Customer.Address;
                            "Arrival Address 2" := lrc_Customer."Address 2";
                            "Arrival Country Code" := lrc_Customer."Country/Region Code";
                            "Arrival Post Code" := lrc_Customer."Post Code";
                            "Arrival City" := lrc_Customer.City;
                            "Arrival Phone No." := lrc_Customer."Phone No.";
                        END;

                    "Arrival Type"::Vendor, "Arrival Type"::"Pick-Up Addresse":
                        BEGIN
                            lrc_Vendor.GET("Arrival Code");
                            "Arrival Subcode" := '';
                            "Arrival Name" := lrc_Vendor.Name;
                            "Arrival Name 2" := lrc_Vendor."Name 2";
                            "Arrival Address" := lrc_Vendor.Address;
                            "Arrival Address 2" := lrc_Vendor."Address 2";
                            "Arrival Country Code" := lrc_Vendor."Country/Region Code";
                            "Arrival Post Code" := lrc_Vendor."Post Code";
                            "Arrival City" := lrc_Vendor.City;
                            "Arrival Phone No." := lrc_Vendor."Phone No.";
                        END;
                    "Arrival Type"::Location:
                        BEGIN
                            lrc_Location.GET("Arrival Code");
                            "Arrival Subcode" := '';
                            "Arrival Name" := lrc_Location.Name;
                            "Arrival Name 2" := lrc_Location."Name 2";
                            "Arrival Address" := lrc_Location.Address;
                            "Arrival Address 2" := lrc_Location."Address 2";
                            "Arrival Country Code" := lrc_Location."Country/Region Code";
                            "Arrival Post Code" := lrc_Location."Post Code";
                            "Arrival City" := lrc_Location.City;
                            "Arrival Phone No." := lrc_Location."Phone No.";
                        END;
                END;
            end;
        }
        field(312; "Arrival Subcode"; Code[10])
        {
            Caption = 'Arrival Subcode';
            TableRelation = IF ("Arrival Type" = FILTER("Ship-To Address" | Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Arrival Code"))
            ELSE
            IF ("Arrival Type" = FILTER(Vendor | "Pick-Up Addresse")) "Order Address".Code WHERE("Vendor No." = FIELD("Arrival Code"));
        }
        field(313; "Arrival Region Code"; Code[20])
        {
            Caption = 'Arrival Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
        }
        field(315; "Arrival Name"; Text[100])
        {
            Caption = 'Arrival Name';
        }
        field(316; "Arrival Name 2"; Text[100])
        {
            Caption = 'Arrival Name 2';
        }
        field(317; "Arrival Address"; Text[100])
        {
            Caption = 'Arrival Address';
        }
        field(318; "Arrival Address 2"; Text[50])
        {
            Caption = 'Arrival Address 2';
        }
        field(320; "Arrival Country Code"; Code[10])
        {
            Caption = 'Arrival Country Code';
            TableRelation = "Country/Region";
        }
        field(321; "Arrival Post Code"; Code[20])
        {
            Caption = 'Arrival Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(322; "Arrival City"; Text[30])
        {
            Caption = 'Arrival City';
        }
        field(324; "Arrival Contact"; Text[30])
        {
            Caption = 'Arrival Contact';
        }
        field(325; "Arrival Phone No."; Text[30])
        {
            Caption = 'Arrival Phone No.';
        }
        field(340; "Departure Type"; Option)
        {
            Caption = 'Departure Type';
            Description = 'Customer,Ship-To Address,Vendor,Pick-Up Addresse,,,Location';
            OptionCaption = 'Customer,Ship-To Address,Vendor,Pick-Up Addresse,,,Location';
            OptionMembers = Customer,"Ship-To Address",Vendor,"Pick-Up Addresse",,,Location;
        }
        field(341; "Departure Code"; Code[20])
        {
            Caption = 'Departure Code';
            TableRelation = IF ("Departure Type" = CONST(Customer)) Customer
            ELSE
            IF ("Departure Type" = CONST("Ship-To Address")) Customer
            ELSE
            IF ("Departure Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Departure Type" = CONST("Pick-Up Addresse")) Vendor
            ELSE
            IF ("Departure Type" = CONST(Location)) Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
                lrc_Vendor: Record Vendor;
                lrc_Location: Record Location;
            begin
                IF "Departure Code" = '' THEN BEGIN
                    "Departure Subcode" := '';
                    "Departure Name" := '';
                    "Departure Name 2" := '';
                    "Departure Address" := '';
                    "Departure Address 2" := '';
                    "Departure Country Code" := '';
                    "Departure Post Code" := '';
                    "Departure City" := '';
                    "Departure Phone No." := '';
                    EXIT;
                END;

                CASE "Departure Type" OF
                    "Departure Type"::Customer, "Departure Type"::"Ship-To Address":
                        BEGIN
                            lrc_Customer.GET("Departure Code");
                            "Departure Subcode" := '';
                            "Departure Name" := lrc_Customer.Name;
                            "Departure Name 2" := lrc_Customer."Name 2";
                            "Departure Address" := lrc_Customer.Address;
                            "Departure Address 2" := lrc_Customer."Address 2";
                            "Departure Country Code" := lrc_Customer."Country/Region Code";
                            "Departure Post Code" := lrc_Customer."Post Code";
                            "Departure City" := lrc_Customer.City;
                            "Departure Phone No." := lrc_Customer."Phone No.";
                        END;

                    "Departure Type"::Vendor, "Departure Type"::"Pick-Up Addresse":
                        BEGIN
                            lrc_Vendor.GET("Departure Code");
                            "Departure Subcode" := '';
                            "Departure Name" := lrc_Vendor.Name;
                            "Departure Name 2" := lrc_Vendor."Name 2";
                            "Departure Address" := lrc_Vendor.Address;
                            "Departure Address 2" := lrc_Vendor."Address 2";
                            "Departure Country Code" := lrc_Vendor."Country/Region Code";
                            "Departure Post Code" := lrc_Vendor."Post Code";
                            "Departure City" := lrc_Vendor.City;
                            "Departure Phone No." := lrc_Vendor."Phone No.";
                        END;

                    "Departure Type"::Location:
                        BEGIN
                            lrc_Location.GET("Departure Code");
                            "Departure Subcode" := '';
                            "Departure Name" := lrc_Location.Name;
                            "Departure Name 2" := lrc_Location."Name 2";
                            "Departure Address" := lrc_Location.Address;
                            "Departure Address 2" := lrc_Location."Address 2";
                            "Departure Country Code" := lrc_Location."Country/Region Code";
                            "Departure Post Code" := lrc_Location."Post Code";
                            "Departure City" := lrc_Location.City;
                            "Departure Phone No." := lrc_Location."Phone No.";
                        END;
                END;
            end;
        }
        field(342; "Departure Subcode"; Code[10])
        {
            Caption = 'Departure Subcode';
            TableRelation = IF ("Departure Type" = FILTER("Ship-To Address" | Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Departure Code"))
            ELSE
            IF ("Departure Type" = FILTER(Vendor | "Pick-Up Addresse")) "Order Address".Code WHERE("Vendor No." = FIELD("Departure Code"));

            trigger OnValidate()
            var
                lrc_ShiptoAddress: Record "Ship-to Address";
                lrc_OrderAddress: Record "Order Address";
            begin
                IF "Departure Subcode" = '' THEN BEGIN
                    VALIDATE("Departure Code");
                    EXIT;
                END;

                TESTFIELD("Departure Code");

                CASE "Departure Type" OF
                    "Departure Type"::Customer, "Departure Type"::"Ship-To Address":
                        BEGIN
                            lrc_ShiptoAddress.GET("Departure Code", "Departure Subcode");
                            "Departure Name" := lrc_ShiptoAddress.Name;
                            "Departure Name 2" := lrc_ShiptoAddress."Name 2";
                            "Departure Address" := lrc_ShiptoAddress.Address;
                            "Departure Address 2" := lrc_ShiptoAddress."Address 2";
                            "Departure Country Code" := lrc_ShiptoAddress."Country/Region Code";
                            "Departure Post Code" := lrc_ShiptoAddress."Post Code";
                            "Departure City" := lrc_ShiptoAddress.City;
                            "Departure Phone No." := lrc_ShiptoAddress."Phone No.";
                        END;

                    "Departure Type"::Vendor, "Departure Type"::"Pick-Up Addresse":
                        BEGIN
                            lrc_OrderAddress.GET("Departure Code", "Departure Subcode");
                            "Departure Name" := lrc_OrderAddress.Name;
                            "Departure Name 2" := lrc_OrderAddress."Name 2";
                            "Departure Address" := lrc_OrderAddress.Address;
                            "Departure Address 2" := lrc_OrderAddress."Address 2";
                            "Departure Country Code" := lrc_OrderAddress."Country/Region Code";
                            "Departure Post Code" := lrc_OrderAddress."Post Code";
                            "Departure City" := lrc_OrderAddress.City;
                            "Departure Phone No." := lrc_OrderAddress."Phone No.";
                        END;
                END;
            end;
        }
        field(343; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Departure));
        }
        field(345; "Departure Name"; Text[100])
        {
            Caption = 'Departure Name';
        }
        field(346; "Departure Name 2"; Text[50])
        {
            Caption = 'Departure Name 2';
        }
        field(347; "Departure Address"; Text[100])
        {
            Caption = 'Departure Address';
        }
        field(348; "Departure Address 2"; Text[50])
        {
            Caption = 'Departure Address 2';
        }
        field(349; "Departure Country Code"; Code[10])
        {
            Caption = 'Departure Country Code';
            TableRelation = "Country/Region";
        }
        field(351; "Departure Post Code"; Code[20])
        {
            Caption = 'Departure Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(352; "Departure City"; Text[30])
        {
            Caption = 'Departure City';
        }
        field(354; "Departure Contact"; Text[30])
        {
            Caption = 'Departure Contact';
        }
        field(355; "Departure Phone No."; Text[30])
        {
            Caption = 'Departure Phone No.';
        }
        field(390; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST("Sales Order")) "Sales Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF (Source = CONST("Purchase Order")) "Purchase Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF (Source = CONST("Transfer Order")) "Transfer Header"."No.";

            trigger OnValidate()
            begin
                IF "Source No." <> '' THEN
                    DeleteAllLines()
                ELSE
                    DeleteAllLines();

            end;
        }
        field(391; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = ' ,Sales Order,Purchase Order,Transfer Order';
            OptionMembers = " ","Sales Order","Purchase Order","Transfer Order";

            trigger OnValidate()
            begin
                IF Source <> xRec.Source THEN BEGIN
                    "Source No." := '';
                    DeleteAllLines();
                END;
            end;
        }
        field(400; "Freight Invoice No."; Code[20])
        {
            Caption = 'Freight Invoice No.';
        }
        field(401; "Freight Invoice Date"; Date)
        {
            Caption = 'Freight Invoice Date';
        }
        field(405; "Freight Invoice Amount (LCY)"; Decimal)
        {
            Caption = 'Freight Invoice Amount (LCY)';
        }
        field(650; "Qty. Euro Pallets"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Qty. Euro Pallets" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Qty. Euro Pallets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(651; "Qty. Ind. Pallets"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Qty. Ind. Pallets" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Qty. Ind. Pallets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(652; "Qty. Düs. Pallets"; Decimal)
        {
            Caption = 'Qty. Düs. Pallets';
        }
        field(655; "Qty. CC Container"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Qty. CC Container" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Qty. CC Container';
            Editable = false;
            FieldClass = FlowField;
        }
        field(656; "Qty. EC Container"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Qty. EC Container" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Qty. EC Container';
            Editable = false;
            FieldClass = FlowField;
        }
        field(657; "Qty. Gitterrolli"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Qty. Gitterrolli" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Qty. Gitterrolli';
            Editable = false;
            FieldClass = FlowField;
        }
        field(690; "LIDL Qty. Euro Pallets"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."LIDL Qty. Euro Pallets" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'LIDL Qty. Euro Pallets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(692; "LIDL Qty. Düs. Pallets"; Decimal)
        {
            Caption = 'LIDL Qty. Düs. Pallets';
        }
        field(695; "LIDL Qty. CC Container"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."LIDL Qty. CC Container" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'LIDL Qty. CC Container';
            Editable = false;
            FieldClass = FlowField;
        }
        field(696; "LIDL Qty. EC Container"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."LIDL Qty. EC Container" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'LIDL Qty. EC Container';
            Editable = false;
            FieldClass = FlowField;
        }
        field(700; "Tot. Qty. Euro Pallets"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Tot. Qty. Euro Pallets" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Tot. Qty. Euro Pallets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(701; "Tot. Qty. Ind. Pallets"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Tot. Qty. Ind. Pallets" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Tot. Qty. Ind. Pallets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(702; "Tot. Qty. Düs. Pallets"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Tot. Qty. Düs. Pallets" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Tot. Qty. Düs. Pallets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(705; "Tot. Qty. CC Container"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Tot. Qty. CC Container" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Tot. Qty. CC Container';
            Editable = false;
            FieldClass = FlowField;
        }
        field(706; "Tot. Qty. EC Container"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Tot. Qty. EC Container" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Tot. Qty. EC Container';
            Editable = false;
            FieldClass = FlowField;
        }
        field(707; "Tot. Qty. Gitterrolli"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Line"."Tot. Qty. Gitterrolli" WHERE("Freight Order No." = FIELD("No.")));
            Caption = 'Tot. Qty. Gitterrolli';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Shipping Agent Code", "Shipment Date")
        {
        }
        key(Key3; "Shipment Date")
        {
        }
        key(Key4; "Tour Code", "Promised Delivery Date")
        {
        }
        key(Key5; "Tour Code", "Shipment Date", "Promised Delivery Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_FreightOrderDetailLine: Record "POI Freight Order Detail Line";
    begin
        lrc_FreightOrderLine.SETRANGE("Freight Order No.", "No.");
        lrc_FreightOrderLine.DELETEALL();

        lrc_FreightOrderDetailLine.SETRANGE("Freight Order No.", "No.");
        lrc_FreightOrderDetailLine.DELETEALL();
    end;

    trigger OnInsert()
    var

        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF "No." = '' THEN BEGIN
            lrc_FruitVisionSetup.GET();
            lrc_FruitVisionSetup.TESTFIELD("No. Series Tour Order");
            lcu_NoSeriesMgt.InitSeries(lrc_FruitVisionSetup."No. Series Tour Order",
                                       xRec."No. Series", "Promised Delivery Date", "No.",
                                       "No. Series");
        END;

        // Datumsfelder vorbelegen
        "Order Date" := TODAY();
        "Posting Date" := TODAY();

        // Vorbelegung mit Verk-Auftrag
        Source := Source::"Sales Order";

        // Vorbelegung Frachtverteilung mit Palette
        "Freight Cost Tariff Base" := "Freight Cost Tariff Base"::Pallet;
    end;

    procedure DeleteAllLines()
    var
        lrc_FreightOrderDetailLine: Record "POI Freight Order Detail Line";
    begin
        // Zeilen löschen
        lrc_FreightOrderLine.SETRANGE("Freight Order No.", "No.");
        lrc_FreightOrderLine.DELETEALL();

        lrc_FreightOrderDetailLine.SETRANGE("Freight Order No.", "No.");
        lrc_FreightOrderDetailLine.DELETEALL();
    end;

    var
        lrc_MeansofTransport: Record "POI Means of Transport";
        lrc_FreightOrderLine: Record "POI Freight Order Line";
}

