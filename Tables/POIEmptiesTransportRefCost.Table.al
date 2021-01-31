table 5110451 "POI Empties/Transport Ref Cost"
{

    Caption = 'Empties/Transport Refund Cost';
    // DrillDownFormID = Form5110450;
    // LookupFormID = Form5110450;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item WHERE("POI Item Typ" = FILTER("Empties Item" | "Transport Item"));
        }
        field(2; "Source Type"; Option)
        {
            Caption = 'Source Type';
            Description = 'Customer,Vendor,Shipping Agent,Empties Price Group,Company Chain,Sales Global,Purchase Global';
            OptionCaption = 'Customer,Vendor,Shipping Agent,Empties Price Group,Company Chain,Sales Global,Purchase Global';
            OptionMembers = Customer,Vendor,"Shipping Agent","Empties Price Group","Company Chain","Sales Global","Purchase Global";
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF ("Source Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Source Type" = CONST(Customer)) Customer."No."
            ELSE
            IF ("Source Type" = CONST("Shipping Agent")) "Shipping Agent".Code
            ELSE
            IF ("Source Type" = CONST("Empties Price Group")) "POI Empties Price Groups".Code
            ELSE
            IF ("Source Type" = CONST("Company Chain")) "POI Company Chain".Code;

            trigger OnValidate()
            var
                lrc_Vendor: Record Vendor;
                lrc_Customer: Record Customer;
            begin
                IF "Source No." <> '' THEN
                    CASE "Source Type" OF
                        "Source Type"::Customer:
                            IF lrc_Customer.GET("Source No.") THEN
                                "Source Name" := lrc_Customer.Name;
                        "Source Type"::Vendor:
                            IF lrc_Vendor.GET("Source No.") THEN
                                "Source Name" := lrc_Vendor.Name;
                    END
                ELSE
                    "Source Name" := '';
            end;
        }
        field(6; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(7; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(10; "Shipment Price (LCY)"; Decimal)
        {
            Caption = 'Shipment Price (LCY)';
        }
        field(12; "Receipt Price (LCY)"; Decimal)
        {
            Caption = 'Receipt Price (LCY)';
        }
        field(13; "Reduced Receipt Price (LCY)"; Decimal)
        {
            Caption = 'Reduced Receipt Price (LCY)';
        }
        field(50; "Item Description"; Text[30])
        {
            CalcFormula = Lookup (Item.Description WHERE("No." = FIELD("Item No.")));
            Caption = 'Item Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Source Name"; Text[100])
        {
            Caption = 'Source Name';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Item No.", "Source Type", "Source No.", "Starting Date")
        {
        }
    }
}

