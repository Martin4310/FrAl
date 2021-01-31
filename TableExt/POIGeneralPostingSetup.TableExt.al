tableextension 50052 "POI General Posting Setup" extends "General Posting Setup" //MyTargetTableId
{
    fields
    {
        field(5110300; "POI Purch.Inv.Disc.ohne WB Acc"; Code[20])
        {
            Caption = 'Eink.-Rg.Rab. ohne Warenbez. Kto.';
            TableRelation = "G/L Account";
        }
    }

}