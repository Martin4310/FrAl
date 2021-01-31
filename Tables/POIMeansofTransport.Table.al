table 5110324 "POI Means of Transport"
{
    Caption = 'Means of Transport';
    // DrillDownFormID = Form5110397;
    // LookupFormID = Form5110397;

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Truck,Train,Ship,Airplane,,,,,Truck Types';
            OptionMembers = " ",Truck,Train,Ship,Airplane,,,,,"Truck Types";

            trigger OnValidate()
            begin
                "Shipping Company Vendor No." := '';
                "Shipping Agent Code" := '';
            end;
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(11; "Short Description"; Code[10])
        {
            Caption = 'Short Description';
        }
        field(14; "Shipping Company Vendor No."; Code[20])
        {
            Caption = 'Shipping Company Vendor No.';
            TableRelation = Vendor;
        }
        field(15; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent".Code;
        }
        field(18; "Country Code"; Code[10])
        {
            Caption = 'Country Code';
            TableRelation = "Country/Region".Code;
        }
        field(20; "Licence Plate No."; Code[20])
        {
            Caption = 'Licence Plate No.';
        }
        field(24; "Producer Name"; Text[30])
        {
        }
        field(25; "Producer Truck Type"; Code[10])
        {
        }
        field(27; "Truck Type"; Option)
        {
            Caption = 'Truck Type';
            OptionCaption = ' ,Sattelzug,,,Kofferfahrzeug';
            OptionMembers = " ",Sattelzug,,,Kofferfahrzeug;
        }
        field(29; "Max. Total Weight (Kg)"; Decimal)
        {
            Caption = 'Zul. Ges. Gewicht (Kg)';
        }
        field(30; "Loading Weight (Kg)"; Decimal)
        {
            Caption = 'Loading Weight (Kg)';
        }
        field(34; "Max. Euro Pallets"; Decimal)
        {
            Caption = 'Max. Euro Pallets';
        }
        field(35; "Max. Ind. Pallets"; Decimal)
        {
            Caption = 'Max. Ind. Pallets';
        }
        field(38; "Max. Rolli"; Decimal)
        {
            Caption = 'Max. Rolli';
        }
        field(40; "Truck Driver"; Text[30])
        {
            Caption = 'Truck Driver';
        }
        field(42; "Truck Driver 2"; Text[30])
        {
            Caption = 'Truck Driver 2';
        }
        field(44; "Truck Phone No."; Text[30])
        {
            Caption = 'Truck Phone No.';
        }
        field(50; "Means of Transport Info"; Code[30])
        {
            Caption = 'Means of Transport Info';
            TableRelation = "POI Means of Transport Info".Code;
            ValidateTableRelation = false;
        }
        field(99; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(60500; "Reference Code Interface"; Code[3])
        {
            Caption = 'Reference Code Interface';
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
        }
    }
}

