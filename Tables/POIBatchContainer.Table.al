table 5087934 "POI Batch - Container"
{
    fields
    {
        field(1; "Batch No."; Code[20])
        {
            Caption = 'Batch No.';
        }
        field(2; "Container Code"; Code[20])
        {
            Caption = 'Container Code';
            TableRelation = "POI Container";
        }
        field(10; "Master Batch No."; Code[20])
        {
            Caption = 'Master Batch No.';
        }
        field(30; "Means of Transport Type"; Option)
        {
            Caption = 'Means of Transport Type';
            Description = ' ,Truck,Train,Ship,Airplane';
            OptionCaption = ' ,Truck,Train,Ship,Airplane';
            OptionMembers = " ",Truck,Train,Ship,Airplane;
        }
        field(31; "Means of Transport Code"; Code[20])
        {
            Caption = 'Means of Transport Code';
            TableRelation = "POI Means of Transport".Code WHERE(Type = FIELD("Means of Transport Type"));
            ValidateTableRelation = false;
        }
        field(32; "Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
            TableRelation = "POI Means of Transport Info".Code;
            ValidateTableRelation = false;
        }
        field(35; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "POI Departure Region";
        }
        field(36; "Port of Discharge Code (UDE)"; Code[10])
        {
            Caption = 'Port of Discharge Code (UDE)';
            TableRelation = "Entry/Exit Point";
        }
    }

    keys
    {
        key(Key1; "Batch No.", "Container Code")
        {
        }
    }
}

