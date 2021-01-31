table 50025 "POI Cost Schema Name"
{
    Caption = 'Cost Schema Name';
    DrillDownPageID = 5087942;
    LookupPageID = 5087942;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(18; "Accounts from Cost Schema"; Boolean)
        {
            Caption = 'Accounts from Cost Schema';
            DataClassification = CustomerContent;
        }
        field(20; "Batch Filter"; Code[20])
        {
            Caption = 'Batch Filter';
            FieldClass = FlowFilter;
            TableRelation = "POI Batch";
            ValidateTableRelation = false;
        }
        field(21; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(30; "Default Column Layout"; Code[10])
        {
            Caption = 'Default Column Layout';
            DataClassification = CustomerContent;
            TableRelation = "Column Layout Name";
        }
        field(50; "Show Fields Sales Clearance"; Boolean)
        {
            Caption = 'Show Fields Sales Clearance';
            DataClassification = CustomerContent;
            Description = 'ZVM';
        }
        field(52; "Sorting Order in Acc. Sales"; Option)
        {
            Caption = 'Sorting Order in Acc. Sales';
            DataClassification = CustomerContent;
            OptionCaption = 'Cost Schema,Cost Category Sort Order';
            OptionMembers = "Cost Schema","Cost Category Sort Order";
        }
        field(90; "Last Date/Time Modified"; DateTime)
        {
            Caption = 'Last Date/Time Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(91; "Last Modification by User ID"; Code[20])
        {
            Caption = 'Last Modification by User ID';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup";
        }
        field(95; Released; Boolean)
        {
            Caption = 'Released';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF Released = TRUE THEN BEGIN
                    "Released by User ID" := CopyStr(USERID(), 1, 20);
                    "Released Date/Time" := CREATEDATETIME(TODAY(), TIME());
                END;
            end;
        }
        field(96; "Released by User ID"; Code[20])
        {
            Caption = 'Released by User ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(97; "Released Date/Time"; DateTime)
        {
            Caption = 'Released Date/Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(200; "Drawback Quality Rating"; Option)
        {
            Caption = 'Drawback Quality Rating';
            DataClassification = CustomerContent;
            OptionCaption = ' ,,,,,1 Decay,2 Damaged,3 Empty,4 Loading,,6 Sample,7 Weight,8 Others';
            OptionMembers = " ",,,,,"1 Decay","2 Damaged","3 Empty","4 Loading",,"6 Sample","7 Weight","8 Others";
        }
        field(201; "Drawback Quality Rating 2"; Option)
        {
            Caption = 'Drawback Quality Rating 2';
            DataClassification = CustomerContent;
            OptionCaption = ' ,,,,,1 Decay,2 Damaged,3 Empty,4 Loading,,6 Sample,7 Weight,8 Others';
            OptionMembers = " ",,,,,"1 Decay","2 Damaged","3 Empty","4 Loading",,"6 Sample","7 Weight","8 Others";
        }
        field(202; "Drawback Quality Rating 3"; Option)
        {
            Caption = 'Drawback Quality Rating 2';
            DataClassification = CustomerContent;
            OptionCaption = ' ,,,,,1 Decay,2 Damaged,3 Empty,4 Loading,,6 Sample,7 Weight,8 Others';
            OptionMembers = " ",,,,,"1 Decay","2 Damaged","3 Empty","4 Loading",,"6 Sample","7 Weight","8 Others";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        lrc_CostSchemaLine: Record "POI Cost Schema Line";
        lrc_CostCategoryAccounts: Record "POI Cost Category Accounts";
    begin
        lrc_CostSchemaLine.SETRANGE("Cost Schema Code", Code);
        lrc_CostSchemaLine.DELETEALL();

        IF Code <> '' THEN BEGIN
            lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", Code);
            lrc_CostCategoryAccounts.DELETEALL();
        END;
    end;
}

