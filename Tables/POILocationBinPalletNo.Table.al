table 5110561 "POI Location Bin - Pallet No."
{

    Caption = 'Location Bin - Pallet No.';
    // DrillDownFormID = Form5087972;
    // LookupFormID = Form5087972;

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(2; "Location Bin Code"; Code[10])
        {
            Caption = 'Location Bin Code';
            //TableRelation = "Location Bins".Code WHERE ("Location Code"=FIELD("Location Code")); //TODO: location bins Tabelle
        }
        field(3; "Pallet No."; Code[30])
        {
            Caption = 'Pallet No.';
            TableRelation = "POI Pallets";
        }
        field(10; "Open Line Nos Incoming Pallets"; Integer)
        {
            CalcFormula = Count ("POI Incoming Pallet" WHERE("Pallet No." = FIELD("Pallet No."),
                                                          "Location Code" = FIELD("Location Code"),
                                                          "Location Bin Code" = FIELD("Location Bin Code"),
                                                          Posted = CONST(false)));
            Caption = 'Open Line Nos Incoming Pallets';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Open Qty. (Base) Incoming Pall"; Decimal)
        {
            CalcFormula = Sum ("POI Incoming Pallet"."Quantity (Base)" WHERE("Pallet No." = FIELD("Pallet No."),
                                                                          "Location Code" = FIELD("Location Code"),
                                                                          "Location Bin Code" = FIELD("Location Bin Code"),
                                                                          Posted = CONST(false)));
            Caption = 'Open Qty. (Base) Incomming Pallets';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Open Line Nos Outgoing Pallets"; Integer)
        {
            CalcFormula = Count ("POI Outgoing Pallet" WHERE("Pallet No." = FIELD("Pallet No."),
                                                          "Location Code" = FIELD("Location Code"),
                                                          "Location Bin Code" = FIELD("Location Bin Code"),
                                                          Posted = CONST(false)));
            Caption = 'Open Line Nos Outgoing Pallets';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Open Qty. (Base) Outgoing Pall"; Decimal)
        {
            CalcFormula = Sum ("POI Outgoing Pallet"."Quantity (Base)" WHERE("Pallet No." = FIELD("Pallet No."),
                                                                          "Location Code" = FIELD("Location Code"),
                                                                          "Location Bin Code" = FIELD("Location Bin Code"),
                                                                          Posted = CONST(false)));
            Caption = 'Open Qty. (Base) Outgoing Pallets';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Open Nos Pallet Item Lines"; Integer)
        {
            CalcFormula = Count ("POI Pallet - Item Lines" WHERE("Pallet No." = FIELD("Pallet No."),
                                                              Status = FILTER(.. Opened)));
            Caption = 'Open Nos Pallet Item Lines';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Open Qty. (Base) Pallet Item L"; Decimal)
        {
            CalcFormula = Sum ("POI Pallet - Item Lines"."Quantity (Base)" WHERE("Pallet No." = FIELD("Pallet No."),
                                                                              Status = FILTER(.. Opened)));
            Caption = 'Open Quantity (Base) Pallet Item Lines';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Location Code", "Location Bin Code", "Pallet No.")
        {
        }
    }
}

