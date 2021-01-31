tableextension 50051 "POI Gen. Prod. post. Group" extends "Gen. Product Posting Group"
{
    fields
    {
        field(5110300; "POI Prod.Post.Grp. Empt. Item"; Code[10])
        {
            Caption = 'Prod.Post.Grp. Empties Item';
            TableRelation = "Gen. Product Posting Group".Code;
        }
    }

}