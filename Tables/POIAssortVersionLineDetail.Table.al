table 5110337 "POI Assort Version Line Detail"
{
    Caption = 'Assortment Version Line Detail';
    // DrillDownFormID = Form5088165;
    // LookupFormID = Form5088165;

    fields
    {
        field(1; "Assortment Version No."; Code[20])
        {
            Caption = 'Assortment Version No.';
            TableRelation = "POI Assortment Version";
        }
        field(3; "Assortment Version Line No."; Integer)
        {
            Caption = 'Assortment Version Line No.';
            TableRelation = "POI Assortment Version Line"."Line No.";
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Batch Var. No.,Item No.,Variety,Caliber,,,,,Empties Item No.,Vendor,,,,,,,,,Customer Price List,Internel Comment';
            OptionMembers = "Batch Var. No.","Item No.",Variety,Caliber,,,,,"Empties Item No.",Vendor,,,,,,,,,"Customer Price List","Internel Comment";
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST("Batch Var. No.")) "POI Batch Variant" WHERE(State = CONST(Open))
            ELSE
            IF (Type = CONST("Item No.")) Item
            ELSE
            IF (Type = CONST(Variety)) "POI Variety"
            ELSE
            IF (Type = CONST(Caliber)) "POI Caliber"
            ELSE
            IF (Type = CONST("Empties Item No.")) Item WHERE("POI Item Typ" = CONST("Empties Item"));
        }
        field(7; "Assortment Code"; Code[10])
        {
            Caption = 'Assortment Code';
            TableRelation = "POI Assortment";
        }
        field(10; "Print Line in Cust. Price List"; Option)
        {
            Caption = 'Print Line in Cust. Price List';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(20; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Assortment Version No.", "Assortment Version Line No.", Type, "No.")
        {
        }
    }
}

