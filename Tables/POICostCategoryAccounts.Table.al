table 50024 "POI Cost Category Accounts"
{
    Caption = 'Cost Category Accounts';
    //DrillDownFormID = Form5087941;
    //LookupFormID = Form5087941;
    DataPerCompany = false;

    fields
    {
        field(1; "Cost Category Code"; Code[20])
        {
            Caption = 'Cost Category Code';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "POI Cost Category";

            trigger OnValidate()
            begin
                VALIDATE("Dimension Code", 'Kosten');
                VALIDATE("Dimension Value", "Cost Category Code");
            end;
        }
        field(2; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account";

            trigger OnValidate()
            var
                lrc_CostCategory: Record "POI Cost Category";
                lrc_GLAccount: Record "G/L Account";
            begin
                lrc_GLAccount.GET("G/L Account No.");
                lrc_CostCategory.GET("Cost Category Code");
                IF lrc_CostCategory."Cost Global Source" = lrc_CostCategory."Cost Global Source"::Purchase THEN BEGIN
                    IF NOT lrc_GLAccount."POI Allowed in Purchase" THEN
                        ERROR('Für Einkauf Zugelassen muss im Sachkonto hinterlegt sein');
                END ELSE
                    IF lrc_CostCategory."Cost Global Source" = lrc_CostCategory."Cost Global Source"::Sales THEN
                        IF NOT lrc_GLAccount."POI Allowed in Sales" THEN
                            ERROR('Für Verkauf Zugelassen muss im Sachkonto hinterlegt sein');
                Kostenart := lrc_GLAccount."Global Dimension 2 Code";
            end;
        }
        field(4; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            DataClassification = CustomerContent;
            TableRelation = Dimension;
        }
        field(5; "Dimension Value"; Code[20])
        {
            Caption = 'Dimension Value';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Dimension Code"));
        }
        field(6; "Cost Schema Code"; Code[10])
        {
            Caption = 'Cost Schema Code';
            DataClassification = CustomerContent;
            TableRelation = "POI Cost Schema Name";
        }
        field(20; "G/L Account Name"; Text[50])
        {
            CalcFormula = Lookup ("G/L Account".Name WHERE("No." = FIELD("G/L Account No.")));
            Caption = 'G/L Account Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Gen. Bus. Posting Group"; Code[10])
        {
            CalcFormula = Lookup ("G/L Account"."Gen. Bus. Posting Group" WHERE("No." = FIELD("G/L Account No.")));
            Caption = 'Gen. Bus. Posting Group';
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; blocked; Boolean)
        {
            Caption = 'gesperrt';
            DataClassification = CustomerContent;
        }
        field(23; Kostenart; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('KOSTENART'));

            trigger OnValidate()
            var
                lrc_DimensionValue: Record "Dimension Value";
            begin
                IF lrc_DimensionValue.GET('KOSTENART', Kostenart) THEN
                    "Kostenart Beschreibung" := lrc_DimensionValue.Name
                ELSE
                    "Kostenart Beschreibung" := '';
            end;
        }
        field(24; "Kostenart Beschreibung"; Text[50])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Cost Schema Code", "Cost Category Code", "G/L Account No.", "Dimension Code", "Dimension Value")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ERROR('Sie dürfen die Kostenkategorie Sachkonten nicht löschen, nur sperren');
    end;

    trigger OnRename()
    begin
        ERROR('Sie dürfen die Kostenkategorie Sachkonten nicht umbenennen, nur sperren und alternativ eine neue anlegen');
    end;
}

