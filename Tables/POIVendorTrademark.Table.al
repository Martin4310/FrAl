table 5110307 "POI Vendor - Trademark"
{

    Caption = 'Vendor - Trademark';
    // DrillDownFormID = Form5110307;
    // LookupFormID = Form5110307;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(2; "Trademark Code"; Code[20])
        {
            Caption = 'Trademark Code';
            TableRelation = "POI Trademark";
        }
        field(10; "Vendor Name"; Text[30])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Trademark Name"; Text[30])
        {
            CalcFormula = Lookup ("POI Trademark".Description WHERE(Code = FIELD("Trademark Code")));
            Caption = 'Trademark Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Vendor No.", "Trademark Code")
        {
        }
    }
}

