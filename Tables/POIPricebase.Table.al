table 5110320 "POI Price Base"
{
    Caption = 'Price Base';
    DrillDownPageID = 5110378;
    LookupPageID = 5110378;

    fields
    {
        field(1; "Purch./Sales Price Calc."; Option)
        {
            Caption = 'Purch./Sales Price Calc.';
            OptionCaption = 'Purch. Price,Sales Price';
            OptionMembers = "Purch. Price","Sales Price";
        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(10; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(19; "Internal Calc. Type"; Option)
        {
            Caption = 'Internal Calc. Type';
            OptionCaption = ' ,Base Unit,Content Unit,Packing Unit,Collo Unit,Transport Unit,,,,Gross Weight,Net Weight,,,,,Total Price';
            OptionMembers = " ","Base Unit","Content Unit","Packing Unit","Collo Unit","Transport Unit",,,,"Gross Weight","Net Weight",,,,,"Total Price";
        }
        field(20; "Internal Calc. Code"; Code[10])
        {
            Caption = 'Internal Calc. Code';
        }
        field(21; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(22; Weight; Option)
        {
            Caption = 'Weight';
            OptionCaption = ' ,Net Weight,Gross Weight';
            OptionMembers = " ","Net Weight","Gross Weight";

            trigger OnValidate()
            begin
                IF Weight = Weight::" " THEN
                    "Price Unit Weighting" := '';
            end;
        }
        field(23; "Price Unit Weighting"; Code[10])
        {
            Caption = 'Price Unit Weighting';
            TableRelation = "Unit of Measure";

            trigger OnValidate()
            begin
                IF Weight = Weight::" " THEN
                    "Price Unit Weighting" := '';
            end;
        }
    }

    keys
    {
        key(Key1; "Purch./Sales Price Calc.", "Code")
        {
        }
    }
}

