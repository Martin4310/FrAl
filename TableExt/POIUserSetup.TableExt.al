tableextension 50039 "POI User Setup" extends "User Setup" //MyTargetTableId
{
    fields
    {
        field(5110300; "POI Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Purchaser" = CONST(true));
        }
        field(5110301; "POI Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Salesperson" = CONST(true));
        }
        field(5110302; "POI Person in Charge Code"; Code[10])
        {
            Caption = 'Person in Charge Code';
            TableRelation = "Salesperson/Purchaser" WHERE("POI Is Person in Charge" = CONST(true));
        }
        field(5110314; "POI Perm. for all G/L Accounts"; Boolean)
        {
            Caption = 'Permition for all G/L Accounts';
        }
        field(5110360; "POI Loc Group Filter Sales"; Code[10])
        {
            Caption = 'Location Group Filter Sales';
            TableRelation = "POI Location Group".Code;
        }
        field(5110361; "POI Loc Group Filter Decay"; Code[10])
        {
            Caption = 'Location Group Filter Decay';
            TableRelation = "POI Location Group".Code;
        }
    }

}