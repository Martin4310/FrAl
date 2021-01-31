table 50932 "POI Tour"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Tour Code"; code[20])
        {
            Caption = 'Tour Code';
            DataClassification = CustomerContent;
        }
        field(2; "Shipping Agent Code"; Code[20])
        {
            Caption = 'Shipping Agent';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent".Code;
        }
        field(3; "Second Driver"; Boolean)
        {
            Caption = 'Zweiter Fahrer';
            DataClassification = CustomerContent;
        }
        field(4; "Truck No."; Text[30])
        {
            Caption = 'Kennzeichen';
            DataClassification = CustomerContent;
        }
        field(5; "Logistic Cost"; Decimal)
        {
            Caption = 'Logistik Cost';
            DataClassification = CustomerContent;
        }
        field(6; "Departure Region"; Code[20])
        {
            Caption = 'Departure Region';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region".Code where(RegionType = const(Departure));
        }
        field(7; "Arrival Region"; Code[20])
        {
            Caption = 'Arrival Region';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region".Code where(RegionType = const(Arrival));
        }
        field(8; "Transit Region"; Code[20])
        {
            Caption = 'Transit Region';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region".Code where(RegionType = const(Arrival));
        }
        field(13; "Combine Cost"; Decimal)
        {
            Caption = 'Combine Cost';
            DataClassification = CustomerContent;
        }
        field(9; "Second Driver Cost"; Decimal)
        {
            Caption = 'Second Driver Cost';
            DataClassification = CustomerContent;
        }
        field(10; "Driver Name"; Text[30])
        {
            Caption = 'Driver Name';
            DataClassification = CustomerContent;
        }
        field(11; StartDate; Date)
        {
            Caption = 'Startdate';
            DataClassification = CustomerContent;
        }
        field(12; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(14; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Tour Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        PurchaseSetup: Record "Sales & Receivables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF "Tour Code" = '' THEN BEGIN
            PurchaseSetup.Get();
            PurchaseSetup.TESTFIELD("POI Tour No.");
            NoSeriesMgt.InitSeries(PurchaseSetup."POI Tour No.", xRec."No. Series", StartDate, "Tour Code", "No. Series");
        END;
    end;

    procedure CreateTour(OrderNo: Code[20])
    var
        Tour: Record "POI Tour";
        Location: Record Location;
        Location1: Code[10];
        Location2: Code[10];
    begin
        PurchaseHeader.Get(1, OrderNo);
        if PurchaseHeader."POI Tour" <> '' then
            Tour.Get(PurchaseHeader."POI Tour")
        else
            Tour.Insert(); //TODO: Einrichten der Nummernserie für die Tour
        PurchaseHeader."POI Tour" := Tour."Tour Code";
        PurchaseHeader.Modify();
        //Abgangsregion aus Lagerort Bestellung
        Location.Get(PurchaseHeader."Location Code");
        Tour."Departure Region" := Location."POI Departure Region";
        //Ermitteln der Zielregionen aus den Zeilen
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then
            repeat
                if (Location1 = '') and (Location1 <> PurchaseLine."Location Code") then
                    Location1 := PurchaseLine."Location Code"
                else
                    Location2 := PurchaseLine."Location Code";
            until (PurchaseLine.Next() = 0) OR ((Location1 <> '') and (Location2 <> ''));
        Tour."Arrival Region" := Location1;
        Tour."Transit Region" := Location2;
        Tour.StartDate := PurchaseHeader."Promised Receipt Date";
        Tour.Description := 'Order No. ' + PurchaseHeader."No.";
        ShipAgentFreightCost.SetRange("Shipping Agent Code", PurchaseHeader."POI Shipping Agent Code");
        ShipAgentFreightCost.SetRange("Departure Region Code", PurchaseHeader."POI Departure Region Code");
        ShipAgentFreightCost.SetFilter("Valid From", '>=%1|%2', PurchaseHeader."Promised Receipt Date", 0D);
        ShipAgentFreightCost.SetFilter("Valid until", '<=%1|%2', PurchaseHeader."Promised Receipt Date", 0D);
        if PurchaseHeader."POI Transfer Region Code" <> '' then
            ShipAgentFreightCost.SetRange("Arrival Region Code", PurchaseHeader."POI Transfer Region Code")
        else
            ShipAgentFreightCost.SetRange("Arrival Region Code", PurchaseHeader."POI Arrival Region Code");
        if ShipAgentFreightCost.FindLast() then
            PurchaseHeader."POI Logistic Cost" := ShipAgentFreightCost."Freight Rate per Unit";
        if Tour."Second Driver" then
            Tour."Second Driver Cost" := ShipAgentFreightCost."Second Driver";
        if PurchaseHeader."POI Transfer Region Code" <> '' then begin
            ShipAgentFreightCost.setrange("Departure Region Code", PurchaseHeader."POI Transfer Region Code");
            ShipAgentFreightCost.SetRange("Arrival Region Code", PurchaseHeader."POI Arrival Region Code");
            if ShipAgentFreightCost.FindLast() then
                Tour."Combine Cost" := ShipAgentFreightCost."Freight Rate per Unit";
        end;
        Tour.Modify();
        CalcTourCostToOrder(Tour."Tour Code");
    end;

    procedure UpdateTour(TourNo: Code[20])
    begin
        IF Get(TourNo) then begin
            ShipAgentFreightCost.SetRange("Shipping Agent Code", "Shipping Agent Code");
            ShipAgentFreightCost.SetRange("Departure Region Code", "Departure Region");
            ShipAgentFreightCost.SetFilter("Valid From", '>=%1|%2', StartDate, 0D);
            ShipAgentFreightCost.SetFilter("Valid until", '<=%1|%2', StartDate, 0D);
            if "Transit Region" <> '' then
                ShipAgentFreightCost.SetRange("Arrival Region Code", "Transit Region")
            else
                ShipAgentFreightCost.SetRange("Arrival Region Code", "Arrival Region");
            if ShipAgentFreightCost.FindLast() then
                "Logistic Cost" := ShipAgentFreightCost."Freight Rate per Unit";
            if "Second Driver" then
                "Second Driver Cost" := ShipAgentFreightCost."Second Driver";
            if "Transit Region" <> '' then begin
                ShipAgentFreightCost.setrange("Departure Region Code", "Transit Region");
                ShipAgentFreightCost.SetRange("Arrival Region Code", "Arrival Region");
                if ShipAgentFreightCost.FindLast() then
                    "Combine Cost" := ShipAgentFreightCost."Freight Rate per Unit";
            end;
            Modify();
            CalcTourCostToOrder(TourNo);
        end;
    end;

    procedure CalcTourCostToOrder(TourNo: Code[20])
    var
        Tour: Record "POI Tour";
        Palletnumber1: Integer;
        Palletnumber2: Integer;
        CostPerPallet1: Decimal;
        CostPerPallet2: Decimal;
        LogisticCostPerline: Decimal;
    begin
        Tour.Get(TourNo);
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("POI Tour", TourNo);
        if PurchaseHeader.FindSet() then
            repeat
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                if PurchaseLine.FindSet() then
                    repeat
                        PalletNumber1 += PurchaseLine."POI Pallet number";
                        if PurchaseLine."Location Code" <> Tour."Arrival Region" then
                            PalletNumber2 += PurchaseLine."POI Pallet number";
                    until PurchaseLine.Next() = 0;
            until PurchaseHeader.Next() = 0;
        CostPerPallet1 := (Tour."Logistic Cost" + Tour."Second Driver Cost") / Palletnumber1;
        CostPerPallet2 := CostPerPallet1 + (Tour."Combine Cost" / Palletnumber2);
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("POI Tour", TourNo);
        if PurchaseHeader.FindSet() then
            repeat
                LogisticCostPerline := 0;
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                repeat
                    if PurchaseLine."Location Code" <> Tour."Arrival Region" then
                        PurchaseLine."POI Logistic Cost" := PurchaseLine."POI Pallet number" * (CostPerPallet1 + CostPerPallet2)
                    else
                        PurchaseLine."POI Logistic Cost" := PurchaseLine."POI Pallet number" * CostPerPallet1;
                    LogisticCostPerline += PurchaseLine."POI Logistic Cost";
                until PurchaseLine.Next() = 0;
                PurchaseHeader."POI Logistic Cost" := LogisticCostPerline;
            until PurchaseHeader.Next() = 0;
    end;

    var
        PurchaseLine: Record "Purchase Line";
        ShipAgentFreightCost: Record "POI Ship.-Agent Freightcost";
        PurchaseHeader: Record "Purchase Header";
}