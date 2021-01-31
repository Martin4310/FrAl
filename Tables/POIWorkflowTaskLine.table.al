table 50949 "POI Workflow Task Line"
{
    DataPerCompany = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Table ID"; Integer)
        {
            Caption = 'Tabellen nr.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Feldnr.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; Condition; enum "POI Operator")
        {
            Caption = 'Vergleichsoperation';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "ConditionCode Value"; Code[20])
        {
            Caption = 'Vergleichswert Code';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(6; "ConditionText Value"; Text[100])
        {
            Caption = 'Vergleichswert Text';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "ConditionInteger Value"; Integer)
        {
            Caption = 'Vergleichswert Integer';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Condition Type"; enum "POI Condition Type")
        {
            Caption = 'Vergleichwert Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        Field(9; Filtertxt; Text[50])
        {
            Caption = 'Filtertext';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Line No."; Integer)
        {
            Caption = 'Zeilennr.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(11; Closed; Boolean)
        {
            Caption = 'abgeschlossen';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if Closed then begin
                    "Approved by User ID" := copystr(Userid(), 1, MaxStrLen("Approved by User ID"));
                    "Approved at" := CreateDateTime(Today, Time);
                end;
            end;
        }
        field(12; "ConditionBoolean Value"; Boolean)
        {
            Caption = '';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(13; "Approved by User ID"; Code[50])
        {
            Caption = 'erledigt durch';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Approved at"; DateTime)
        {
            Caption = 'erledigt am';
            Editable = false;
        }
        Field(15; "Account Code"; Code[20])
        {
            Caption = 'Geschäftspartnernr.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(16; "Table Name"; Text[30])
        {
            Caption = 'Tabelle';
            FieldClass = FlowField;
            CalcFormula = lookup (AllObjWithCaption."Object Name" where("Object ID" = field("Table ID")));
            Editable = false;
        }
        field(17; "Field Name"; Text[30])
        {
            Caption = 'Feldname';
            FieldClass = FlowField;
            CalcFormula = lookup (Field.FieldName where("No." = field("Field No."), TableNo = field("Table ID")));
            Editable = false;
        }
        field(18; Exception; Integer)
        {
            Caption = 'Ausnahmezeilennr.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(19; "Approved by"; enum "POI Exception")
        {
            Caption = 'genehmigt durch';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Task No."; Code[20])
        {
            Caption = 'Aufgabenbereich';
            DataClassification = CustomerContent;
        }
        field(21; "ConditionDate Value"; Date)
        {
            Caption = 'Vergleichswert Datum';
            DataClassification = CustomerContent;
        }
        field(22; "Exception Task No."; Code[20])
        {
            Caption = 'Ausnahme Aufgabenbereich';
            DataClassification = CustomerContent;
        }
        field(100; "WF Group No"; Integer)
        {
            Caption = 'Gruppirungscode';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.", "Task No.", "Line No.")
        {
            Clustered = true;
        }
    }

}