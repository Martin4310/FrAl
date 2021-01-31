table 50931 "POI Shipping Distance"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Departureregion; Code[20])
        {
            Caption = 'Departureregion';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region".Code where(RegionType = const(Departure));
        }
        field(2; Arrivalregion; Code[20])
        {
            Caption = 'Arrivalregion';
            DataClassification = CustomerContent;
            TableRelation = "POI Departure Region".Code where(RegionType = const(Arrival));
        }
        field(3; Distance; Decimal)
        {
            Caption = 'Distance in km';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Departureregion, Arrivalregion)
        {
            Clustered = true;
        }
    }

}