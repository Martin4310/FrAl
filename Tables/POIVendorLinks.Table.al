table 5110441 "POI Vendor Links"
{
    Caption = 'Vendor Links';
    DataCaptionFields = "Entry Type", "Vendor No.";
    // DrillDownFormID = Form5087953;
    // LookupFormID = Form5087953;

    fields
    {
        field(1; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Producer,Payment-to';
            OptionMembers = Producer,"Payment-to";
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            NotBlank = true;
            TableRelation = Vendor."No.";
        }
        field(3; "Attached Vendor No."; Code[20])
        {
            Caption = 'Attached Vendor No.';
            NotBlank = true;
            TableRelation = IF ("Entry Type" = CONST(Producer)) Vendor."No." WHERE("POI Is Manufacturer" = CONST(true))
            ELSE
            IF ("Entry Type" = CONST("Payment-to")) Vendor."No.";
        }
        field(10; "Vendor Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Attached Vendor Name"; Text[50])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Attached Vendor No.")));
            Caption = 'Attached Vendor Name';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Vendor No.", "Attached Vendor No.")
        {
        }
    }
}

