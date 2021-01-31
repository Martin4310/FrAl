table 50950 "POI Workflow Template"
{
    Caption = 'Workflow Vorlagen';
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        // field(1; "Entry No."; Integer)
        // {
        //     Caption = 'Entry No.';
        //     DataClassification = CustomerContent;
        // }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Tabellen nr.';
            DataClassification = CustomerContent;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(TableData));
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Feldnr.';
            DataClassification = CustomerContent;
            //TableRelation = Field."No." where(TableNo = field("Table ID")); siehe Page
        }
        field(4; Condition; enum "POI Operator")
        {
            Caption = 'Vergleichsoperation';
            DataClassification = CustomerContent;
        }
        field(5; "ConditionCode Value"; Code[20])
        {
            Caption = 'Vergleichswert Code';
            DataClassification = CustomerContent;
        }
        field(6; "ConditionText Value"; Text[100])
        {
            Caption = 'Vergleichswert Text';
            DataClassification = CustomerContent;
        }
        field(7; "ConditionInteger Value"; Integer)
        {
            Caption = 'Vergleichswert Integer';
            DataClassification = CustomerContent;
        }
        field(8; "Condition Type"; enum "POI Condition Type")
        {
            Caption = 'Vergleichwert Type';
            DataClassification = CustomerContent;
        }
        Field(9; Filtertxt; Text[50])
        {
            Caption = 'Filtertext';
            DataClassification = CustomerContent;
        }
        field(10; "Line Type"; Option)
        {
            Caption = 'Zeilennr.';
            DataClassification = CustomerContent;
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
            trigger OnValidate()
            begin
                if "Line Type" = "Line Type"::Line then
                    "Source Type" := "Source Type"::" ";
            end;
        }
        field(11; "Template Code"; Code[20])
        {
            Caption = 'VorlagenCode';
            DataClassification = CustomerContent;
        }
        field(12; Description; Text[100])
        {
            Caption = 'Vorlagenbeschreibung';
            DataClassification = CustomerContent;
        }
        field(13; "Source Type"; enum "POI User Type")
        {
            Caption = 'Art';
            DataClassification = CustomerContent;
        }
        field(14; "Source No."; Code[50])
        {
            Caption = 'Herkunftsnummer';
            DataClassification = CustomerContent;
            TableRelation = if ("Source Type" = const(Team)) "Team Salesperson"."Salesperson Code"
            else
            if ("Source Type" = const(User)) User."User Name"
            else
            if ("Source Type" = const("User Group")) "Workflow User Group".Code;
        }
        field(15; "Task No."; Code[20])
        {
            Caption = 'Aufgabenbereich';
            DataClassification = CustomerContent;
        }
        field(16; "ConditionBoolean Value"; Boolean)
        {
            Caption = 'Vergleichswert ja/nein';
            DataClassification = CustomerContent;
        }
        field(17; "Table Name"; Text[30])
        {
            Caption = 'Tabellenname';
            FieldClass = FlowField;
            CalcFormula = lookup (AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table ID")));
        }
        field(18; "Field Name"; Text[30])
        {
            Caption = 'Feldname';
            FieldClass = FlowField;
            CalcFormula = lookup (Field.FieldName where(TableNo = field("Table ID"), "No." = field("Field No.")));
        }
        field(22; "Exception Task No."; code[20])
        {
            Caption = 'Ausnahme Aufgabennr.';
            DataClassification = CustomerContent;
        }
        field(19; Exception; Integer)
        {
            Caption = 'Ausnahmezeilennr.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if (Exception = "Line No.") and ("Exception Task No." = "Task No.") then
                    Error('Ausnahmezeilennr. darf nicht gleich Zeilennr. sein.');
                WFTemplate.Reset();
                WFTemplate.SetRange("Exception Task No.", "Exception Task No.");
                WFTemplate.SetRange("Line Type", WFTemplate."Line Type"::Line);
                WFTemplate.Setrange("Template Code", "Template Code");
                WFTemplate.SetRange("Task No.", "Task No.");
                WFTemplate.SetRange("Line No.", Exception);
                if WFTemplate.IsEmpty then
                    Error('Ausnahme nicht erlaubt. (Zeile nicht vorhanden)');
            end;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Zeilennr.';
            DataClassification = CustomerContent;
        }
        field(21; "ConditionDate Value"; Date)
        {
            Caption = 'Vergleichswert Datum';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Template Code", "Task No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var

        WFTemplate: Record "POI Workflow Template";
}