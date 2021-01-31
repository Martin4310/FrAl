table 50918 "POI Ship.-Agent Freightcost"
{

    Caption = 'Ship.-Agent Freightcost';
    // DrillDownFormID = Form5110690;
    // LookupFormID = Form5110690;

    fields
    {
        field(1; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            DataClassification = CustomerContent;
            TableRelation = "Shipping Agent".Code WHERE("POI Blocked" = CONST(false));

            trigger OnValidate()
            var
                ShipAgent: Record "Shipping Agent";
            begin
                IF ShipAgent.GET("Shipping Agent Code") THEN BEGIN
                    "Freight Cost Tarif Base" := ShipAgent."POI Freight Cost Tariff Base";
                    "Freight Cost Tarif Level" := ShipAgent."POI Freight Cost Tariff Level";
                    "Vendor No." := ShipAgent."POI Vendor No.";
                END;
            end;
        }
        field(2; "Arrival Region Code"; Code[20])
        {
            Caption = 'Arrival Region Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region" where(RegionType = const(Arrival));
            trigger OnValidate()
            begin
                SetDistance();
            end;
        }
        field(3; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region" where(RegionType = const(Departure));

            trigger OnValidate()
            begin
                IF "Departure Region Code" <> '' THEN
                    "Freight Cost Tarif Level" := "Freight Cost Tarif Level"::"Departure Region";
                SetDistance();
            end;
        }
        field(5; Distance; Decimal)
        {
            Caption = 'km';
            DataClassification = CustomerContent;
        }
        field(6; "Freight Cost Tarif Base"; Option)
        {
            Caption = 'Freight Cost Tarif Base';
            DataClassification = CustomerContent;
            OptionCaption = 'Collo,Pallet,Weight,Pallet Type,Collo Weight,Pallet Weight,Pallet Type Weight';
            OptionMembers = Collo,Pallet,Weight,"Pallet Type","Collo Weight","Pallet Weight","Pallet Type Weight";
        }
        field(7; "Freight Unit of Measure Code"; Code[10])
        {
            Caption = 'Freight Unit of Measure Code';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure" WHERE("POI Is Freight Unit of Measure" = CONST(true));
        }
        field(8; "From Quantity"; Decimal)
        {
            Caption = 'From Quantity';
            DataClassification = CustomerContent;
        }
        field(9; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No." where("POI Carrier" = const(true));
        }
        field(10; "Until Quantity"; Decimal)
        {
            Caption = 'Until Quantity';
            DataClassification = CustomerContent;
        }
        field(11; "Second Driver"; Decimal)
        {
            Caption = 'Second Driver';
            DataClassification = CustomerContent;
        }
        field(12; "Valid From"; Date)
        {
            Caption = 'Valid From';
            DataClassification = CustomerContent;
        }
        field(19; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(20; "Freight Rate per Unit"; Decimal)
        {
            Caption = 'Freight Rate per Unit';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
        }
        field(21; "Base Freight Rate"; Decimal)
        {
            Caption = 'Base Freight Rate';
            DataClassification = CustomerContent;
        }
        field(25; Pauschal; Boolean)
        {
            Caption = 'Pauschal';
            DataClassification = CustomerContent;
        }
        field(26; "Combination with"; Code[20])
        {
            Caption = 'Combination with';
            DataClassification = CustomerContent;
        }

        field(30; "Freight Cost Tarif Level"; Option)
        {
            Caption = 'Freight Cost Tarif Level';
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = ' ,Location Group,Locations,Departure Region';
            OptionMembers = " ","Location Group",Locations,"Departure Region";
        }
        field(50; "Diesel Surcharge Type"; Option)
        {
            Caption = 'Diesel Surcharge Type';
            DataClassification = CustomerContent;
            OptionCaption = 'Percentage,Amount';
            OptionMembers = Percentage,Amount;
        }
        field(51; "Diesel Surcharge"; Decimal)
        {
            Caption = 'Diesel Surcharge';
            DataClassification = CustomerContent;
        }
        field(90; "Shipping Agent Name"; Text[50])
        {
            CalcFormula = Lookup ("Shipping Agent".Name WHERE(Code = FIELD("Shipping Agent Code")));
            Caption = 'Shipping Agent Name';
            Editable = false;
            FieldClass = FlowField;
        }
        // field(91;"Departure Region Description";Text[30])
        // {
        //     CalcFormula = Lookup("Departure Region".Description WHERE (Code=FIELD("Departure Region Code")));
        //     Caption = 'Departure Region Description';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        // field(92;"Arrival Region Description";Text[30])
        // {
        //     CalcFormula = Lookup("Arrival Region".Description WHERE (Code=FIELD("Arrival Region Code")));
        //     Caption = 'Arrival Region Description';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(50001; Reference; Boolean)
        {
            Caption = 'Referenz Datensatz';
            DataClassification = CustomerContent;
        }
        field(50010; Addition; Decimal)
        {
            BlankZero = true;
            Caption = 'Zuschlag';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            Description = 'Zuschlag';
        }
        field(50011; "Addition Base"; Option)
        {
            Caption = 'Zuschlag Basis';
            DataClassification = CustomerContent;
            Description = '% oder Total';
            OptionCaption = 'Prozentsatz,Betrag';
            OptionMembers = Prozentsatz,Betrag;
        }
        field(50015; "addition fix per order"; Decimal)
        {
            BlankZero = true;
            Caption = 'addition fix per order';
            DataClassification = CustomerContent;
        }
        field(50020; Discount; Decimal)
        {
            BlankZero = true;
            Caption = 'Rabatt';
            DataClassification = CustomerContent;
            Description = 'Rabatt/Abschlag';
        }
        field(50021; "Discount Base"; Option)
        {
            Caption = 'Rabatt Basis';
            DataClassification = CustomerContent;
            Description = '% oder total';
            OptionCaption = 'Prozentsatz,Betrag';
            OptionMembers = Prozentsatz,Betrag;
        }
        field(50030; "Departure Region Agent Code"; Code[20])
        {
            Caption = 'Abgangsregion Zusteller';
            DataClassification = CustomerContent;
        }
        field(50031; "Shipping Agent Departure Label"; Text[100])
        {
        }
        field(50032; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(50040; "Valid until"; Date)
        {
            Caption = 'gültig bis';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Shipping Agent Code", "Arrival Region Code", "Departure Region Code", "Freight Cost Tarif Base", "Freight Unit of Measure Code", "From Quantity", "Valid From")
        {
        }
        key(Key2; "Shipping Agent Code", "Freight Cost Tarif Base", "Freight Unit of Measure Code", "Departure Region Code", "Arrival Region Code", "From Quantity", "Valid From")
        {
        }
        key(key3; "Shipping Agent Code", "Freight Unit of Measure Code", "Arrival Region Code", "Departure Region Code", "Valid From", "Valid until", "Country/Region Code", "Freight Cost Tarif Base", "From Quantity", "Until Quantity")
        {

        }
    }

    procedure SetDistance()
    var
        ShippingDistance: Record "POI Shipping Distance";
    begin
        if ("Departure Region Code" <> '') and ("Arrival Region Code" <> '') then
            if ShippingDistance.Get("Departure Region Code", "Arrival Region Code") then
                Distance := ShippingDistance.Distance;
    end;

    trigger OnInsert()
    begin
        "Freight Cost Tarif Level" := "Freight Cost Tarif Level"::"Departure Region";
    end;

    procedure CopyFreightCostNewPeriod(ShipAgent: Code[20]; NewUntilDate: Date)
    var
        Freightcosttmp: Record "POI Ship.-Agent Freightcost" temporary;
    begin
        Freightcost.SetRange("Shipping Agent Code", "Shipping Agent Code");
        if Freightcost.FindLast() then
            Freightcost.SetRange("Valid until", Freightcost."Valid until");
        if Freightcost.FindFirst() then
            repeat
                Freightcosttmp := Freightcost;
                Freightcosttmp."Valid until" := NewUntilDate;
                Freightcosttmp."Valid From" := calcdate('<+1D>', Freightcost."Valid until");
                Freightcosttmp."Freight Rate per Unit" := 0;
                Freightcosttmp.Insert();
            until Freightcost.Next() = 0;
        Freightcosttmp.Reset();
        if Freightcosttmp.FindSet() then
            repeat
                Freightcost := Freightcosttmp;
                Freightcost.Insert();
            until Freightcosttmp.Next() = 0;
    end;

    var
        Freightcost: Record "POI Ship.-Agent Freightcost";
}

