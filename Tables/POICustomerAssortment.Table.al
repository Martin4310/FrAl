table 5110342 "POI Customer - Assortment"
{

    Caption = 'Customer - Assortment';
    // DrillDownFormID = Form5088168;
    // LookupFormID = Form5088168;

    fields
    {
        field(1; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = IF (Source = CONST(Customer)) Customer
            ELSE
            IF (Source = CONST("Company Chain")) "POI Company Chain";
        }
        field(2; "Assortment Code"; Code[10])
        {
            Caption = 'Assortment Code';
            TableRelation = "POI Assortment";
        }
        field(3; Source; Option)
        {
            Caption = 'Source';
            OptionCaption = 'Customer,Company Chain';
            OptionMembers = Customer,"Company Chain";
        }
        field(6; "Sales Doc. Type"; Option)
        {
            Caption = 'Sales Doc. Type';
            InitValue = "None";
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,,,,,,,,,,Picking Order,None';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",,,,,,,,,,"Picking Order","None";
        }
        field(7; "Sales Doc. Subtype Code"; Code[10])
        {
            Caption = 'Sales Doc. Subtype Code';
            TableRelation = IF ("Sales Doc. Type" = FILTER(<> None)) "POI Sales Doc. Subtype".Code WHERE("Document Type" = FIELD("Sales Doc. Type"))
            ELSE
            IF ("Sales Doc. Type" = FILTER(None)) "POI Sales Doc. Subtype".Code;
        }
        field(10; "Customer Price Group Code"; Code[10])
        {
            Caption = 'Customer Price Group Code';
            TableRelation = "Customer Price Group";
        }
        field(40; "Search Order in Assortments"; Integer)
        {
            BlankNumbers = BlankZero;
            Caption = 'Search Order in Assortments';
        }
        field(50; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(51; "Activ Version"; Boolean)
        {
            BlankNumbers = BlankZero;
            CalcFormula = Exist ("POI Assortment Version" WHERE("Assortment Code" = FIELD("Assortment Code"),
                                                            "Starting Date Assortment" = FIELD("Date Filter")));
            Caption = 'Activ Version';
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "Assortment Description"; Text[30])
        {
            CalcFormula = Lookup ("POI Assortment".Description WHERE(Code = FIELD("Assortment Code")));
            Caption = 'Assortment Description';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; Source, "Source No.", "Sales Doc. Type", "Sales Doc. Subtype Code", "Assortment Code")
        {
        }
        key(Key2; "Search Order in Assortments")
        {
        }
    }
}

