table 5110305 "POI Caliber - Vendor Caliber"
{

    Caption = 'Caliber - Vendor Caliber';
    // DrillDownFormID = Form5110435;
    // LookupFormID = Form5110435;

    fields
    {
        field(1; "Caliber Code"; Code[10])
        {
            Caption = 'Caliber Code';
            NotBlank = true;
            TableRelation = "POI Caliber";
        }
        field(2; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "POI Product Group".Code;
        }
        field(4; "Variety Code"; Code[10])
        {
            Caption = 'Variety Code';
            TableRelation = "POI Variety";
        }
        field(5; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(6; "Vend. Caliber Code"; Code[10])
        {
            Caption = 'Vend. Caliber Code';
            NotBlank = true;
        }
        field(10; "Vend. Caliber Description"; Text[30])
        {
            Caption = 'Vend. Caliber Description';
        }
        field(15; Weight; Decimal)
        {
            Caption = 'Weight';
        }
    }

    keys
    {
        key(Key1; "Caliber Code", "Product Group Code", "Variety Code", "Vendor No.", "Vend. Caliber Code")
        {
        }
    }
}

