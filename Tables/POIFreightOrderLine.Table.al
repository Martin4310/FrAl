table 5110442 "POI Freight Order Line"
{

    Caption = 'Freight Order Line';
    // DrillDownFormID = Form5087996;
    // LookupFormID = Form5087996;

    fields
    {
        field(1; "Freight Order No."; Code[20])
        {
            Caption = 'Freight Order No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(9; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Lieferung,Abholung';
            OptionMembers = Lieferung,Abholung;
        }
        field(10; "Target Type"; Option)
        {
            Caption = 'Target Type';
            OptionCaption = 'Customer,Ship-To Address,Vendor,Pick-Up Addresse,,,Location';
            OptionMembers = Customer,"Ship-To Address",Vendor,"Pick-Up Addresse",,,Location;
        }
        field(11; "Target Code"; Code[20])
        {
            Caption = 'Target Code';
            TableRelation = IF ("Target Type" = CONST(Customer)) Customer
            ELSE
            IF ("Target Type" = CONST("Ship-To Address")) Customer
            ELSE
            IF ("Target Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Target Type" = CONST("Pick-Up Addresse")) Vendor
            ELSE
            IF ("Target Type" = CONST(Location)) Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            var
                lrc_Customer: Record Customer;
                lrc_Vendor: Record Vendor;
                lrc_Location: Record Location;
            begin

                IF "Target Code" = '' THEN BEGIN
                    "Target Name" := '';
                    "Target Name 2" := '';
                    "Target Address" := '';
                    "Target Address 2" := '';
                    "Target Country Code" := '';
                    "Target Post Code" := '';
                    "Target City" := '';
                    "Target Contact" := '';
                    "Target Phone No." := '';
                    EXIT;
                END;


                CASE "Target Type" OF
                    "Target Type"::Customer, "Target Type"::"Ship-To Address":
                        BEGIN
                            lrc_Customer.GET("Target Code");
                            "Target Name" := lrc_Customer.Name;
                            "Target Name 2" := lrc_Customer."Name 2";
                            "Target Address" := lrc_Customer.Address;
                            "Target Address 2" := lrc_Customer."Address 2";
                            "Target Country Code" := lrc_Customer."Country/Region Code";
                            "Target Post Code" := lrc_Customer."Post Code";
                            "Target City" := lrc_Customer.City;
                            "Target Contact" := lrc_Customer.Contact;
                            "Target Phone No." := lrc_Customer."Phone No.";
                        END;

                    "Target Type"::Vendor, "Target Type"::"Pick-Up Addresse":
                        BEGIN
                            lrc_Vendor.GET("Target Code");
                            "Target Name" := lrc_Vendor.Name;
                            "Target Name 2" := lrc_Vendor."Name 2";
                            "Target Address" := lrc_Vendor.Address;
                            "Target Address 2" := lrc_Vendor."Address 2";
                            "Target Country Code" := lrc_Vendor."Country/Region Code";
                            "Target Post Code" := lrc_Vendor."Post Code";
                            "Target City" := lrc_Vendor.City;
                            "Target Contact" := lrc_Vendor.Contact;
                            "Target Phone No." := lrc_Vendor."Phone No.";
                        END;

                    "Target Type"::Location:
                        BEGIN
                            lrc_Location.GET("Target Code");
                            "Target Name" := lrc_Location.Name;
                            "Target Name 2" := lrc_Location."Name 2";
                            "Target Address" := lrc_Location.Address;
                            "Target Address 2" := lrc_Location."Address 2";
                            "Target Country Code" := lrc_Location."Country/Region Code";
                            "Target Post Code" := lrc_Location."Post Code";
                            "Target City" := lrc_Location.City;
                            "Target Contact" := lrc_Location.Contact;
                            "Target Phone No." := lrc_Location."Phone No.";
                        END;

                END;
            end;
        }
        field(12; "Target Subcode"; Code[10])
        {
            Caption = 'Target Subcode';
            TableRelation = IF ("Target Type" = FILTER("Ship-To Address" | Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Target Code"))
            ELSE
            IF ("Target Type" = FILTER(Vendor | "Pick-Up Addresse")) "Order Address".Code WHERE("Vendor No." = FIELD("Target Code"));

            trigger OnValidate()
            var
                lrc_ShiptoAddress: Record "Ship-to Address";
                lrc_OrderAddress: Record "Order Address";
            begin
                IF "Target Subcode" = '' THEN BEGIN
                    VALIDATE("Target Code");
                    EXIT;
                END;

                TESTFIELD("Target Code");

                CASE "Target Type" OF
                    "Target Type"::Customer, "Target Type"::"Ship-To Address":
                        BEGIN
                            lrc_ShiptoAddress.GET("Target Code", "Target Subcode");
                            "Target Name" := lrc_ShiptoAddress.Name;
                            "Target Name 2" := lrc_ShiptoAddress."Name 2";
                            "Target Address" := lrc_ShiptoAddress.Address;
                            "Target Address 2" := lrc_ShiptoAddress."Address 2";
                            "Target Country Code" := lrc_ShiptoAddress."Country/Region Code";
                            "Target Post Code" := lrc_ShiptoAddress."Post Code";
                            "Target City" := lrc_ShiptoAddress.City;
                            "Target Phone No." := lrc_ShiptoAddress."Phone No.";
                        END;

                    "Target Type"::Vendor, "Target Type"::"Pick-Up Addresse":
                        BEGIN
                            lrc_OrderAddress.GET("Target Code", "Target Subcode");
                            "Target Name" := lrc_OrderAddress.Name;
                            "Target Name 2" := lrc_OrderAddress."Name 2";
                            "Target Address" := lrc_OrderAddress.Address;
                            "Target Address 2" := lrc_OrderAddress."Address 2";
                            "Target Country Code" := lrc_OrderAddress."Country/Region Code";
                            "Target Post Code" := lrc_OrderAddress."Post Code";
                            "Target City" := lrc_OrderAddress.City;
                            "Target Phone No." := lrc_OrderAddress."Phone No.";
                        END;
                END;
            end;
        }
        field(13; "Target Region Code"; Code[20])
        {
            Caption = 'Target Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
        }
        field(15; "Target Name"; Text[100])
        {
            Caption = 'Target Name';
        }
        field(16; "Target Name 2"; Text[50])
        {
            Caption = 'Target Name 2';
        }
        field(17; "Target Address"; Text[100])
        {
            Caption = 'Target Address';
        }
        field(18; "Target Address 2"; Text[50])
        {
            Caption = 'Target Address 2';
        }
        field(20; "Target Country Code"; Code[10])
        {
            Caption = 'Target Country Code';
            TableRelation = "Country/Region";
        }
        field(21; "Target Post Code"; Code[20])
        {
            Caption = 'Target Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(22; "Target City"; Text[30])
        {
            Caption = 'Target City';
        }
        field(24; "Target Contact"; Text[100])
        {
            Caption = 'Target Contact';
        }
        field(25; "Target Phone No."; Text[30])
        {
            Caption = 'Target Phone No.';
        }
        field(30; "Loading Order"; Integer)
        {
            Caption = 'Loading Order';
        }
        field(32; "Unloading Order"; Integer)
        {
            Caption = 'Unloading Order';
        }
        field(60; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(61; "Tour Code"; Code[50])
        {
            Caption = 'Tour Code';
            TableRelation = "POI Tour";
        }
        field(65; "Doc. Source"; Option)
        {
            Caption = 'Doc. Source';
            Description = ' ,Purchase,Transfer,Sales';
            OptionCaption = ' ,Purchase,Transfer,Sales';
            OptionMembers = " ",Purchase,Transfer,Sales;
        }
        field(66; "Doc. Source Type"; Option)
        {
            Caption = 'Doc. Source Type';
            Description = ' ,Order,,,Shipment,,,Invoice';
            OptionCaption = ' ,Order,,,Shipment,,,Receipt,,,Invoice';
            OptionMembers = " ","Order",,,Shipment,,,Receipt,,,Invoice;
        }
        field(67; "Doc. Source No."; Code[20])
        {
            Caption = 'Doc. Source No.';
            TableRelation = IF ("Doc. Source" = CONST(Sales),
                                "Doc. Source Type" = CONST(Order)) "Sales Header"."No." WHERE("Document Type" = CONST(Order));
        }
        field(70; "Key"; Boolean)
        {
            Caption = 'Key';

            trigger OnValidate()

            begin
                lrc_TourRouting.RESET();
                lrc_TourRouting.SETRANGE("Tour No.", "Tour Code");
                lrc_TourRouting.SETRANGE("Destination Type", "Target Type");
                lrc_TourRouting.SETRANGE("Destination Code", "Target Code");
                lrc_TourRouting.SETRANGE("Destination Subcode", "Target Subcode");
                IF lrc_TourRouting.FIND('-') THEN BEGIN
                    lrc_TourRouting.Key := Key;
                    lrc_TourRouting.MODIFY();
                END;
            end;
        }
        field(71; Rampe; Boolean)
        {
            Caption = 'Rampe';

            trigger OnValidate()
            begin
                lrc_TourRouting.RESET();
                lrc_TourRouting.SETRANGE("Tour No.", "Tour Code");
                lrc_TourRouting.SETRANGE("Destination Type", "Target Type");
                lrc_TourRouting.SETRANGE("Destination Code", "Target Code");
                lrc_TourRouting.SETRANGE("Destination Subcode", "Target Subcode");
                IF lrc_TourRouting.FIND('-') THEN BEGIN
                    lrc_TourRouting.Rampe := Rampe;
                    lrc_TourRouting.MODIFY();
                END;
            end;
        }
        field(75; Retour; Boolean)
        {
            Caption = 'Retour';
        }
        field(82; "Total Gross Weight"; Decimal)
        {
            CalcFormula = Sum ("POI Freight Order Detail Line"."Total Gross Weight" WHERE("Freight Order No." = FIELD("Freight Order No."),
                                                                                      "Freight Order Line No." = FIELD("Line No.")));
            Caption = 'Total Gross Weight';
            Editable = false;
            FieldClass = FlowField;
        }
        field(83; "Total Net Weight"; Decimal)
        {
            CalcFormula = sum ("POI Freight Order Detail Line"."Total Net Weight" WHERE("Freight Order No." = FIELD("Freight Order No."),
                                                                                    "Freight Order Line No." = FIELD("Line No.")));
            Caption = 'Total Net Weight';
            Editable = false;
            FieldClass = FlowField;
        }
        field(85; "Shipment Method"; Code[10])
        {
            Caption = 'Shipment Method';
            TableRelation = "Shipment Method";
        }
        field(92; "Qty. (Colli)"; Decimal)
        {
            CalcFormula = sum ("POI Freight Order Detail Line"."Quantity Order" WHERE("Freight Order No." = FIELD("Freight Order No."),
                                                                                  "Freight Order Line No." = FIELD("Line No.")));
            Caption = 'Qty. (Colli)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(93; "Qty. (Transport Items)"; Decimal)
        {
            BlankNumbers = BlankZero;
            CalcFormula = sum ("POI Fre Order Line Trans. Item".Quantity WHERE("Tour Order No." = FIELD("Freight Order No."),
                                                                               "Tour Order Line No." = FIELD("Line No.")));
            Caption = 'Qty. (Transport Items)';
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(95; "Arrival Time at Customer"; Time)
        {
            Caption = 'Arrival Time at Customer';
        }
        field(96; Comment; Text[50])
        {
            Caption = 'Comment';

            trigger OnValidate()
            begin
                lrc_TourRouting.RESET();
                lrc_TourRouting.SETRANGE("Tour No.", "Tour Code");
                lrc_TourRouting.SETRANGE("Destination Type", "Target Type");
                lrc_TourRouting.SETRANGE("Destination Code", "Target Code");
                lrc_TourRouting.SETRANGE("Destination Subcode", "Target Subcode");
                IF lrc_TourRouting.FIND('-') THEN BEGIN
                    lrc_TourRouting.Comment := Comment;
                    lrc_TourRouting.MODIFY();
                END;
            end;
        }
        field(97; "Comment 2"; Text[50])
        {
            Caption = 'Information';

            trigger OnValidate()
            begin
                lrc_TourRouting.RESET();
                lrc_TourRouting.SETRANGE("Tour No.", "Tour Code");
                lrc_TourRouting.SETRANGE("Destination Type", "Target Type");
                lrc_TourRouting.SETRANGE("Destination Code", "Target Code");
                lrc_TourRouting.SETRANGE("Destination Subcode", "Target Subcode");
                IF lrc_TourRouting.FIND('-') THEN
                    lrc_TourRouting.MODIFY();
            end;
        }
        field(120; "Qty. Pallets calc."; Decimal)
        {
            BlankNumbers = BlankZero;
            Caption = 'Qty. Pallets calc.';
            DecimalPlaces = 0 : 0;
        }
        field(121; "FREI 121"; Decimal)
        {
            Caption = 'Anzahl Paletten Manuell';
        }
        field(130; "FREI 130"; Decimal)
        {
            Caption = 'Anzahl CC Container';
        }
        field(133; "FREI 133"; Decimal)
        {
            Caption = 'Anzahl EC Container';
        }
        field(150; "Qty. Euro Pallets"; Decimal)
        {
            Caption = 'Qty. Euro Pallets';

            trigger OnValidate()
            begin
                CalcSumTranspUnits();
            end;
        }
        field(151; "Qty. Ind. Pallets"; Decimal)
        {
            Caption = 'Qty. Ind. Pallets';

            trigger OnValidate()
            begin
                CalcSumTranspUnits();
            end;
        }
        field(152; "Qty. Düs. Pallets"; Decimal)
        {
            Caption = 'Qty. Düs. Pallets';
        }
        field(155; "Qty. CC Container"; Decimal)
        {
            Caption = 'Qty. CC Container';

            trigger OnValidate()
            begin
                CalcSumTranspUnits();
            end;
        }
        field(156; "Qty. EC Container"; Decimal)
        {
            Caption = 'Qty. EC Container';

            trigger OnValidate()
            begin
                CalcSumTranspUnits();
            end;
        }
        field(157; "Qty. Gitterrolli"; Decimal)
        {
            Caption = 'Qty. Gitterrolli';

            trigger OnValidate()
            begin
                CalcSumTranspUnits();
            end;
        }
        field(190; "LIDL Qty. Euro Pallets"; Decimal)
        {
            Caption = 'LIDL Qty. Euro Pallets';

            trigger OnValidate()
            begin
                CalcSumTranspUnits();
            end;
        }
        field(192; "LIDL Qty. Düs. Pallets"; Decimal)
        {
            Caption = 'LIDL Qty. Düs. Pallets';
        }
        field(195; "LIDL Qty. CC Container"; Decimal)
        {
            Caption = 'LIDL Qty. CC Container';

            trigger OnValidate()
            begin
                CalcSumTranspUnits();
            end;
        }
        field(196; "LIDL Qty. EC Container"; Decimal)
        {
            Caption = 'LIDL Qty. EC Container';

            trigger OnValidate()
            begin
                CalcSumTranspUnits();
            end;
        }
        field(200; "Tot. Qty. Euro Pallets"; Decimal)
        {
            Caption = 'Tot. Qty. Euro Pallets';
            Editable = false;
        }
        field(201; "Tot. Qty. Ind. Pallets"; Decimal)
        {
            Caption = 'Tot. Qty. Ind. Pallets';
            Editable = false;
        }
        field(202; "Tot. Qty. Düs. Pallets"; Decimal)
        {
            Caption = 'Tot. Qty. Düs. Pallets';
        }
        field(205; "Tot. Qty. CC Container"; Decimal)
        {
            Caption = 'Tot. Qty. CC Container';
            Editable = false;
        }
        field(206; "Tot. Qty. EC Container"; Decimal)
        {
            Caption = 'Tot. Qty. EC Container';
            Editable = false;
        }
        field(207; "Tot. Qty. Gitterrolli"; Decimal)
        {
            Caption = 'Tot. Qty. Gitterrolli';
            Editable = false;
        }
        field(300; "No. of Orders"; Integer)
        {
            Caption = 'No. of Orders';
        }
    }

    keys
    {
        key(Key1; "Freight Order No.", "Line No.")
        {
            SumIndexFields = "Qty. Pallets calc.", "Qty. Euro Pallets", "Qty. Ind. Pallets", "Qty. Düs. Pallets", "Qty. CC Container", "Qty. EC Container", "Qty. Gitterrolli", "LIDL Qty. Euro Pallets", "LIDL Qty. Düs. Pallets", "LIDL Qty. CC Container", "LIDL Qty. EC Container", "Tot. Qty. Euro Pallets", "Tot. Qty. Ind. Pallets", "Tot. Qty. Düs. Pallets", "Tot. Qty. CC Container", "Tot. Qty. EC Container", "Tot. Qty. Gitterrolli";
        }
        key(Key2; "Loading Order")
        {
        }
        key(Key3; "Unloading Order")
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
        lrc_FreightOrderDetailLine.SETRANGE("Freight Order No.", "Freight Order No.");
        lrc_FreightOrderDetailLine.SETRANGE("Freight Order Line No.", "Line No.");
        lrc_FreightOrderDetailLine.DELETEALL();
    end;

    trigger OnInsert()
    var
        lrc_FreightOrderHeader: Record "POI Freight Order Header";
    begin
        TESTFIELD("Freight Order No.");
        IF "Line No." = 0 THEN BEGIN
            lrc_TourOrderLine.SETRANGE("Freight Order No.", "Freight Order No.");
            IF lrc_TourOrderLine.FINDLAST() THEN
                "Line No." := lrc_TourOrderLine."Line No." + 10000
            ELSE
                "Line No." := 10000;
        END;

        lrc_FreightOrderHeader.GET("Freight Order No.");
        "Promised Delivery Date" := lrc_FreightOrderHeader."Promised Delivery Date";
        "Tour Code" := lrc_FreightOrderHeader."Tour Code";
    end;

    procedure CalcSumTranspUnits()
    begin
        // ------------------------------------------------------------
        // Funktion zur Berechnung der Transportmittelmengen
        // ------------------------------------------------------------

        "Tot. Qty. Euro Pallets" := "Qty. Euro Pallets" + "LIDL Qty. Euro Pallets";
        "Tot. Qty. Ind. Pallets" := "Qty. Ind. Pallets";
        "Tot. Qty. CC Container" := "Qty. CC Container" + "LIDL Qty. CC Container";
        "Tot. Qty. EC Container" := "Qty. EC Container" + "LIDL Qty. EC Container";
        "Tot. Qty. Gitterrolli" := "Qty. Gitterrolli";
    end;

                var
                lrc_TourRouting: Record "POI Tour Routing";
                        lrc_TourOrderLine: Record "POI Freight Order Line";
}

