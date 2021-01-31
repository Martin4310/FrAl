table 50919 "POI Freight Cost Controle"
{
    Caption = 'Freight Cost Controle';

    fields
    {
        field(1; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Sales)) "Sales Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE
            IF (Source = CONST(Transfer)) "Transfer Header"."No.";
        }
        field(2; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Sales,Transfer,Purchase,Sales Claim Order,Packing Order,,,,,,,Freight Order';
            OptionMembers = Sales,Transfer,Purchase,"Sales Claim Order","Packing Order",,,,,,,"Freight Order";
        }
        field(3; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(4; "Document Subtype Code"; Code[10])
        {
            Caption = 'Document Subtype Code';
        }
        field(10; "Shipping Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(11; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(20; "Calc. Freight Cost Amount"; Decimal)
        {
            Caption = 'Calc. Freight Cost Amount';
        }
        field(22; "Freight Cost Manual"; Boolean)
        {
            Caption = 'Freight Cost Manual';
        }
        field(24; "Cust.Ship-to City"; Text[50])
        {
            Caption = 'Cust.Ship-to City';
        }
        field(25; "Cust. City"; Text[50])
        {
            Caption = 'Cust. City';
        }
        field(26; "Cust. No."; Code[20])
        {
            Caption = 'Cust. No.';
            TableRelation = Customer;
        }
        field(27; "Cust. Name"; Text[50])
        {
            Caption = 'Cust. Name';
        }
        field(28; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Departure));
        }
        field(29; "Arrival Region Code"; Code[20])
        {
            Caption = 'Arrival Region Code';
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
        }
        field(30; "Item Information"; Text[250])
        {
            Caption = 'Item Information';
        }
        field(40; "Freight Unit Code"; Code[10])
        {
            Caption = 'Freight Unit Code';
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(41; "Freight Cost Tariff Base"; Option)
        {
            Caption = 'Freight Cost Tariff Base';
            OptionCaption = 'Collo,Pallet,Weight,Pallet Type,Collo Weight,,,,,,,,,,from Position';
            OptionMembers = Collo,Pallet,Weight,"Pallet Type","Collo Weight",,,,,,,,,,"from Position";
        }
        field(45; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
        }
        field(48; "Signed Shipment Recieved"; Boolean)
        {
            Caption = 'Signed Shipment Recieved';

            trigger OnValidate()
            begin
                IF "Signed Shipment Recieved" <> xRec."Signed Shipment Recieved" THEN BEGIN
                    IF "Signed Shipment Recieved" = TRUE THEN
                        IF "Signed Shipment Date Recieved" = 0D THEN
                            "Signed Shipment Date Recieved" := WORKDATE();
                    ActualSalesDocuments(Rec);
                END;
            end;
        }
        field(49; "Signed Shipment Date Recieved"; Date)
        {
            Caption = 'Signed Shipment Date Recieved';

            trigger OnValidate()
            begin
                IF "Signed Shipment Date Recieved" <> xRec."Signed Shipment Date Recieved" THEN BEGIN
                    IF "Signed Shipment Date Recieved" <> 0D THEN
                        IF "Signed Shipment Recieved" = FALSE THEN
                            "Signed Shipment Recieved" := TRUE;


                    ActualSalesDocuments(Rec);
                END;
            end;
        }
        field(50; "Freight Inv. Recieved"; Boolean)
        {
            Caption = 'Freight Inv. Recieved';

            trigger OnValidate()
            begin
                IF "Freight Inv. Recieved" <> xRec."Freight Inv. Recieved" THEN
                    IF ("Freight Inv. Cost Amount" = 0) AND
                       ("Calc. Freight Cost Amount" <> 0) THEN
                        "Freight Inv. Cost Amount" := "Calc. Freight Cost Amount";
            end;
        }
        field(51; "Freight Inv. Date Recieved"; Date)
        {
            Caption = 'Freight Inv. Date Recieved';

            trigger OnValidate()
            begin
                IF "Freight Inv. Date Recieved" <> 0D THEN
                    IF "Freight Inv. Recieved" = FALSE THEN
                        "Freight Inv. Recieved" := TRUE;
            end;
        }
        field(55; "Freight Inv. No."; Code[20])
        {
            Caption = 'Freight Inv. No.';
        }
        field(56; "Freight Inv. Date"; Date)
        {
            Caption = 'Freight Inv. Date';

            trigger OnValidate()
            begin
                IF "Freight Inv. Date" <> 0D THEN
                    IF "Posting Date" = 0D THEN
                        "Posting Date" := "Freight Inv. Date";
            end;
        }
        field(58; "Freight Inv. Cost Amount"; Decimal)
        {
            Caption = 'Freight Inv. Cost Amount';

            trigger OnValidate()
            begin
                IF "Freight Inv. Cost Amount" <> 0 THEN
                    "Difference Calc. and Inv. Amt." := "Freight Inv. Cost Amount" -
                                                        "Calc. Freight Cost Amount" -
                                                        "Posted Difference Amount"

                ELSE
                    "Difference Calc. and Inv. Amt." := 0;
            end;
        }
        field(59; "Difference Calc. and Inv. Amt."; Decimal)
        {
            Caption = 'Difference Calc. and Inv. Amt.';
            Editable = false;
        }
        field(60; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(70; "Posted Difference Amount"; Decimal)
        {
            Caption = 'Posted Difference Amount';
        }
        field(71; "No Posting of Difference"; Boolean)
        {
            Caption = 'No Posting of Difference';
        }
        field(80; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Opened,,,,,Closed';
            OptionMembers = Opened,,,,,Closed;
        }
        field(100; "Combination Field"; Text[10])
        {
            Caption = 'Combination Filter';
        }
        field(101; "Main Sales Order No."; Code[20])
        {
            Caption = 'Main Sales Order No.';
        }
        field(200; "Posted Shipment For Source No."; Integer)
        {
            CalcFormula = Count ("Sales Shipment Header" WHERE("Order No." = FIELD("Source No.")));
            Caption = 'Posted Shipment For Source No.';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                lrc_SalesShipmentHeader: Record "Sales Shipment Header";
                lrc_PostedSalesShipments: Page "Posted Sales Shipments";
                lrc_PostedSalesShipment: Page "Posted Sales Shipment";
            begin
                TESTFIELD(Source, Source::Sales);
                IF "Posted Shipment For Source No." > 0 THEN BEGIN
                    lrc_SalesShipmentHeader.RESET();
                    lrc_SalesShipmentHeader.SETCURRENTKEY("Order No.");
                    lrc_SalesShipmentHeader.SETRANGE("Order No.", "Source No.");
                    IF "Posted Shipment For Source No." = 1 THEN BEGIN
                        lrc_PostedSalesShipment.SETTABLEVIEW(lrc_SalesShipmentHeader);
                        lrc_PostedSalesShipment.RUNMODAL();
                    END ELSE BEGIN
                        lrc_PostedSalesShipments.SETTABLEVIEW(lrc_SalesShipmentHeader);
                        lrc_PostedSalesShipments.RUNMODAL();
                    END;
                END;

            end;
        }
        field(201; "Recieved Post.Shipm. Source No"; Integer)
        {
            Caption = 'Recieved Signed Posted Shipment For Source No.';
            Editable = false;

            trigger OnLookup()
            var
                lrc_SalesShipmentHeader: Record "Sales Shipment Header";
                lrc_PostedSalesShipments: Page "Posted Sales Shipments";
                lrc_PostedSalesShipment: Page "Posted Sales Shipment";
            begin
                TESTFIELD(Source, Source::Sales);
                IF "Posted Shipment For Source No." > 0 THEN BEGIN
                    lrc_SalesShipmentHeader.RESET();
                    lrc_SalesShipmentHeader.SETCURRENTKEY("Order No.");
                    lrc_SalesShipmentHeader.SETRANGE("Order No.", "Source No.");
                    IF "Posted Shipment For Source No." = 1 THEN BEGIN
                        lrc_PostedSalesShipment.SETTABLEVIEW(lrc_SalesShipmentHeader);
                        lrc_PostedSalesShipment.RUNMODAL();
                    END ELSE BEGIN
                        lrc_PostedSalesShipments.SETTABLEVIEW(lrc_SalesShipmentHeader);
                        lrc_PostedSalesShipments.RUNMODAL();
                    END;
                END;
            end;
        }
        field(202; "Recieved Prof. Shipm Source No"; Integer)
        {
            Caption = 'Recieved Signed Proforma Shipment For Source No.';
            Editable = false;

            trigger OnLookup()
            var
                lrc_SalesHeader: Record "Sales Header";
                lcu_ReleaseSalesDocument: Codeunit "Release Sales Document";
            begin
                TESTFIELD(Source, Source::Sales);
                TESTFIELD("Source No.");
                lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order, "Source No.");
                IF lrc_SalesHeader.Status = lrc_SalesHeader.Status::Released THEN
                    lcu_ReleaseSalesDocument.Reopen(lrc_SalesHeader);
            end;
        }
        field(50000; "Posting Date"; Date)
        {
            Caption = 'Buchungsdatum';
        }
    }

    keys
    {
        key(Key1; Source, "Source No.", "Shipping Agent Code", "Departure Region Code")
        {
        }
        key(Key2; "Shipping Agent Code", "Shipping Date", "Freight Inv. Recieved")
        {
        }
        key(Key3; "Freight Inv. Recieved")
        {
        }
        key(Key4; "Document Subtype Code", "Shipping Agent Code", "Shipping Date", "Freight Inv. Recieved")
        {
        }
        key(Key5; Source, "Main Sales Order No.", "Source No.")
        {
        }
    }

    procedure ActualSalesDocuments(vrc_FreightCostControle: Record "POI Freight Cost Controle")
    var
    //lrc_SalesShipmentHeader: Record "Sales Shipment Header"; //TODO:Rückschreiben der Felder in Sales Header bzw. shipment header
    //lrc_SalesHeader: Record "Sales Header";
    begin
        /*
        IF (vrc_FreightCostControle.Source = vrc_FreightCostControle.Source::Sales) AND (vrc_FreightCostControle."Signed Shipment Recieved") THEN BEGIN
           lrc_SalesShipmentHeader.RESET();
           lrc_SalesShipmentHeader.SETRANGE("Order No.", vrc_FreightCostControle."Source No.");
           IF lrc_SalesShipmentHeader.FINDSET() THEN
             REPEAT
               lrc_SalesShipmentHeader."Signed Shipment Recieved" := vrc_FreightCostControle."Signed Shipment Recieved";
               lrc_SalesShipmentHeader."Signed Shipment Date Recieved" := vrc_FreightCostControle."Signed Shipment Date Recieved";
               lrc_SalesShipmentHeader.MODIFY(TRUE);
             UNTIL lrc_SalesShipmentHeader.NEXT() = 0;
           IF lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order, vrc_FreightCostControle."Source No.") THEN BEGIN
             lrc_SalesHeader."Signed Shipment Recieved" := vrc_FreightCostControle."Signed Shipment Recieved";
             lrc_SalesHeader."Signed Shipment Date Recieved" := vrc_FreightCostControle."Signed Shipment Date Recieved";
             lrc_SalesHeader.MODIFY(TRUE);
           END;
         END;
        */

    end;
}

