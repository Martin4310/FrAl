tableextension 50048 "POI Sales Price Ext" extends "Sales Price"
{
    fields
    {
        field(50010; "POI Calc. Exchange Rate Amount"; Decimal)
        {
            Caption = 'Calc. Exchange Rate Amount';

            trigger OnValidate()
            begin
                IF NOT POIFunc.CheckUserInRole('HA_CALCRATEAMOUNT', 0) THEN
                    ERROR(TXT50000Txt);
            end;
        }
        field(5110311; "POI Assort. Version No."; Code[20])
        {
            Caption = 'Assort. Version No.';
            TableRelation = "POI Assortment Version";
        }
        field(5110312; "POI Assort. Version Line No."; Integer)
        {
            Caption = 'Assort. Version Line No.';
            TableRelation = "POI Assortment Version Line"."Line No." WHERE("Assortment Version No." = FIELD("POI Assort. Version No."));
        }
        field(5110340; "POI Price Base (Sales Price)"; Code[10])
        {
            Caption = 'Price Base (Sales Price)';
            TableRelation = "POI Price Base".Code WHERE("Purch./Sales Price Calc." = CONST("Sales Price"),
                                                     Blocked = CONST(false));

            trigger OnValidate()
            begin
                TESTFIELD("Unit of Measure Code");
            end;
        }
    }
    var
        POIFunc: Codeunit POIFunction;
        TXT50000Txt: Label 'Sie haben keine Berechtigung zum Ändern der Angaben.';
}