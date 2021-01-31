table 5087991 "POI Pallet Factor by Percent"
{

    fields
    {
        field(1; "From Transport Unit"; Code[10])
        {
            Caption = 'From Transport Unit';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(2; "Into Transport Unit"; Code[10])
        {
            Caption = 'Into Transport Unit';
            TableRelation = "Unit of Measure" WHERE("POI Is Transportation Unit" = CONST(true));
        }
        field(10; Percentage; Decimal)
        {
            Caption = 'Percentage';
        }
    }

    keys
    {
        key(Key1; "From Transport Unit", "Into Transport Unit")
        {
        }
    }
}

