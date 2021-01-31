table 5110444 "POI Tour Delivery Times"
{
    Caption = 'Tour Delivery Times';
    // DrillDownFormID = Form5110606;
    // LookupFormID = Form5110606;

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Customer,Vendor,Company Chain';
            OptionMembers = Customer,Vendor,"Company Chain";
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Customer)) Customer
            ELSE
            IF (Source = CONST(Vendor)) Vendor
            ELSE
            IF (Source = CONST("Company Chain")) "POI Company Chain";
        }
        field(3; "Source No 2"; Code[10])
        {
            Caption = 'Source No. 2';
            TableRelation = IF (Source = CONST(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Source No."))
            ELSE
            IF (Source = CONST(Vendor)) "Order Address".Code WHERE("Vendor No." = FIELD("Source No."));
        }
        field(4; "Day of Week"; Option)
        {
            Caption = 'Day of Week';
            NotBlank = true;
            OptionCaption = ' ,Monday,Tuesday,Wendsday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Monday,Tuesday,Wendsday,Thursday,Friday,Saturday,Sunday;
        }
        field(5; "Valid From Date"; Date)
        {
            Caption = 'Valid From Date';
        }
        field(6; "Doc. Subtyp Code"; Code[10])
        {
            Caption = 'Doc. Subtyp Code';
            TableRelation = "POI Sales Doc. Subtype".Code;
        }
        field(10; "Delivery Time from"; Time)
        {
            Caption = 'Delivery Time from';
        }
        field(11; "Delivery Time untill"; Time)
        {
            Caption = 'Delivery Time untill';
        }
        field(14; "Delivery Time 2 from"; Time)
        {
            Caption = 'Delivery Time 2 from';
        }
        field(15; "Delivery Time 2 untill"; Time)
        {
            Caption = 'Delivery Time 2 untill';
        }
        field(20; "Delivery not Allowed"; Boolean)
        {
            Caption = 'Delivery not Allowed';
        }
        field(21; "Delivery Comment"; Text[20])
        {
            Caption = 'Delivery Comment';
        }
    }

    keys
    {
        key(Key1; Source, "Source No.", "Source No 2", "Doc. Subtyp Code", "Day of Week", "Valid From Date")
        {
        }
    }
}

