table 5110335 "POI Ship.Agent Dep. Reg. Tarif"
{
    Caption = 'Shipping Agent Departure Region Tarif';
    // DrillDownFormID = Form5110403;
    // LookupFormID = Form5110403;

    fields
    {
        field(1; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(2; "Departure Region Code"; Code[20])
        {
            Caption = 'Departure Region Code';
            TableRelation = "Shipping Agent";
        }
        field(21; "Freight Cost Tariff Base"; Option)
        {
            Caption = 'Freight Cost Tariff Base';
            OptionCaption = 'Collo,Pallet,Weight,Pallet Type,Collo Weight';
            OptionMembers = Collo,Pallet,Weight,"Pallet Type","Collo Weight";
        }
        field(80; "Freight Sales G/L Acc. No"; Code[20])
        {
            Caption = 'Freight Sales G/L Acc. No';
            TableRelation = "G/L Account";
        }
        field(81; "Freight Sales Bal. G/L Acc. No"; Code[20])
        {
            Caption = 'Freight Sales Bal. G/L Acc. No';
            TableRelation = "G/L Account";
        }
        field(82; "Freight Sales Amout Deb./Cred."; Option)
        {
            Caption = 'Freight Sales Amout Deb./Cred.';
            OptionCaption = 'Soll,Haben';
            OptionMembers = Soll,Haben;
        }
        field(83; "Freight Sales Change Sign"; Boolean)
        {
            Caption = 'Freight Sales Change Sign';
        }
        field(84; "Freight Sales Description"; Text[50])
        {
            Caption = 'Freight Sales Description';
        }
        field(90; "Freight Trans G/L Acc. No"; Code[20])
        {
            Caption = 'Freight Trans G/L Acc. No';
            TableRelation = "G/L Account";
        }
        field(91; "Freight Trans Bal. G/L Acc. No"; Code[20])
        {
            Caption = 'Freight Trans Bal. G/L Acc. No';
            TableRelation = "G/L Account";
        }
        field(92; "Freight Trans Amout Deb./Cred."; Option)
        {
            Caption = 'Freight Trans Amout Deb./Cred.';
            OptionCaption = 'Soll,Haben';
            OptionMembers = Soll,Haben;
        }
        field(93; "Freight Trans Change Sign"; Boolean)
        {
            Caption = 'Freight Trans Change Sign';
        }
        field(94; "Freight Trans Description"; Text[50])
        {
            Caption = 'Freight Trans Description';
        }
    }

    keys
    {
        key(Key1; "Shipping Agent Code", "Departure Region Code")
        {
        }
    }
}

