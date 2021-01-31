tableextension 50043 "POI Purch. Header Archiv" extends "Purchase Header Archive"
{
    fields
    {
        field(5110310; "POI Purch. Doc. Subtype Code"; Code[10])
        {
            Caption = 'Purch. Doc. Subtype Code';
            TableRelation = "POI Purch. Doc. Subtype".Code WHERE("Document Type" = FIELD("Document Type"));
        }
    }

}