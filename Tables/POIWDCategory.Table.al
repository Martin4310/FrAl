table 50924 "POI W.D. Category"
{
    Caption = 'W.D. Category';
    //LookupFormID = Form5087903; //TODO: lookuppage

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; "Weight Charge"; Boolean)
        {
            Caption = 'Weight Charge';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Gewicht,Volumen,Fläche';
            OptionMembers = Gewicht,Volumen,"Fläche";
        }
        field(50; "Total Weight"; Decimal)
        {
        }
        field(51; "Total Amount"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }
}

