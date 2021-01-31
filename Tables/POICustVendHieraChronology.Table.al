table 5110547 "POI Cust/Vend Hiera Chronology"
{

    Caption = 'Customer/Vendor Hierarchy Chronology';

    fields
    {
        field(1; Source; Option)
        {
            Caption = 'Source';
            Description = 'Customer,Vendor';
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Description = 'Debitorennr., Kreditorennr.';
            TableRelation = IF (Source = CONST(Customer)) Customer."No."
            ELSE
            IF (Source = CONST(Vendor)) Vendor."No.";
        }
        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(10; "Hierarchy Code"; Code[13])
        {
            Caption = 'Hierarchy Code';
            TableRelation = IF (Source = CONST(Customer)) "POI Cust. Mult Level Hierarchy"
            ELSE
            IF (Source = CONST(Vendor)) "POI Vend. Mult Level Hierarchy";

            trigger OnLookup()
            var
                CustomerHierarchy: Record "POI Cust. Mult Level Hierarchy";
                VendorHierarchy: Record "POI Vend. Mult Level Hierarchy";
                VendorHierarchyCode: Code[13];
                CustomerHierarchyCode: Code[13];
            begin
                IF Source = Source::Customer THEN BEGIN
                    // Aufruf der Übersichtsform "Customer Hierarchy List Arrow"
                    CustomerHierarchyCode := "Hierarchy Code";
                    IF CustomerHierarchy.LookupWithArrows(CustomerHierarchyCode, TRUE) THEN
                        VALIDATE("Hierarchy Code", CustomerHierarchyCode)
                END ELSE
                    IF Source = Source::Vendor THEN BEGIN
                        // Aufruf der Übersichtsform "Vendor Hierarchy List Arrow"
                        VendorHierarchyCode := "Hierarchy Code";
                        IF VendorHierarchy.LookupWithArrows(VendorHierarchyCode, TRUE) THEN
                            VALIDATE("Hierarchy Code", VendorHierarchyCode);
                    END;
            end;

            trigger OnValidate()
            begin
                IF Source = Source::Customer THEN
                    CALCFIELDS("Customer Hierarchy Sort Term")
                ELSE
                    IF Source = Source::Vendor THEN
                        CALCFIELDS("Vendor Hierarchy Sort Term");
            end;
        }
        field(100; "Customer Name"; Text[30])
        {
            CalcFormula = Lookup (Customer.Name WHERE("No." = FIELD("Source No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Customer Name 2"; Text[50])
        {
            CalcFormula = Lookup (Customer."Name 2" WHERE("No." = FIELD("Source No.")));
            Caption = 'Customer Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Customer Hierarchy Sort Term"; Code[112])
        {
            CalcFormula = Lookup ("POI Cust. Mult Level Hierarchy"."Sort Term" WHERE(Code = FIELD("Hierarchy Code")));
            Caption = 'Customer Hierarchy Sort Term';
            Description = 'Flowfield Für 8 x (13+1) Stellen Hierarchy Code mit Trennzeichen';
            Editable = false;
            FieldClass = FlowField;
        }
        field(106; "Hierarchy Level Customer"; Integer)
        {
            CalcFormula = Lookup ("POI Cust. Mult Level Hierarchy".Level WHERE(Code = FIELD("Hierarchy Code")));
            Caption = 'Hierarchy Level Customer';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
        field(200; "Vendor Name"; Text[30])
        {
            CalcFormula = Lookup (Vendor.Name WHERE("No." = FIELD("Source No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(201; "Vendor Name 2"; Text[30])
        {
            CalcFormula = Lookup (Vendor."Name 2" WHERE("No." = FIELD("Source No.")));
            Caption = 'Vendor Name 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(205; "Vendor Hierarchy Sort Term"; Code[112])
        {
            CalcFormula = Lookup ("POI Vend. Mult Level Hierarchy"."Sort Term" WHERE(Code = FIELD("Hierarchy Code")));
            Caption = 'Vendor Hierarchy Sort Term';
            Description = 'Flowfield, für 8 x (13+1) Stellen Hierarchy Code mit Trennzeichen';
            Editable = false;
            FieldClass = FlowField;
        }
        field(206; "Hierarchy Level Vendor"; Integer)
        {
            CalcFormula = Lookup ("POI Vend. Mult Level Hierarchy".Level WHERE(Code = FIELD("Hierarchy Code")));
            Caption = 'Hierarchy Level Vendor';
            Description = 'Flowfield';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Source No.", "Starting Date", Source)
        {
        }
        key(Key2; "Hierarchy Code", Source)
        {
        }
    }
}

