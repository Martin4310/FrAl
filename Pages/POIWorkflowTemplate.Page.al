page 50062 "POI Workflow Template"
{
    Caption = 'Workflow Template';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Workflow Template";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Template Code"; "Template Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Task No."; "Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Line Type"; "Line Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = "Line Type" = "Line Type"::Header;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = "Line Type" = "Line Type"::Header;
                }

                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = "Line Type" = "Line Type"::Line;
                }
                field("Table Name"; "Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Field No."; "Field No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = "Line Type" = "Line Type"::Line;
                    trigger OnDrillDown()
                    var
                        AllFields: Record Field;
                    begin
                        AllFields.RESET();
                        AllFields.SETRANGE(TableNo, "Table ID");
                        IF Page.RUNMODAL(Page::"POI AllFields", AllFields) = ACTION::LookupOK THEN
                            "Field No." := AllFields."No.";
                        SetFields();
                    end;

                    trigger OnValidate()
                    begin
                        SetFields();
                    end;
                }
                field("Field Name"; "Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Condition Type"; "Condition Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = "Line Type" = "Line Type"::Line;
                }
                field(Condition; Condition)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = "Line Type" = "Line Type"::Line;
                }
                field("ConditionCode Value"; "ConditionCode Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = ("Line Type" = "Line Type"::Line) and ("Condition Type" = "Condition Type"::Code);
                }
                field("ConditionInteger Value"; "ConditionInteger Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = ("Line Type" = "Line Type"::Line) and ("Condition Type" = "Condition Type"::integer);
                }
                field("ConditionText Value"; "ConditionText Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = ("Line Type" = "Line Type"::Line) and ("Condition Type" = "Condition Type"::Text);
                }
                field("ConditionBoolean Value"; "ConditionBoolean Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = ("Line Type" = "Line Type"::Line) and ("Condition Type" = "Condition Type"::Boolean);
                }
                field("ConditionDate Value"; "ConditionDate Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = ("Line Type" = "Line Type"::Line) and ("Condition Type" = "Condition Type"::Date);
                }
                field(Filtertxt; Filtertxt)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    editable = "Line Type" = "Line Type"::Line;
                    Visible = false;
                }
                field("Exception Task No."; "Exception Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = "Line Type" = "Line Type"::Line;
                }
                field(Exception; Exception)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = "Line Type" = "Line Type"::Line;
                }
            }
        }
        area(Factboxes)
        {

        }
    }
    procedure SetFields()
    var
        AllFields: Record Field;
    begin
        if AllFields.Get("Table ID", "Field No.") then
            case AllFields.Type of
                Allfields.Type::Boolean:
                    begin
                        "Condition Type" := "Condition Type"::Boolean;
                        "ConditionBoolean Value" := true;
                    end;
                Allfields.Type::Code:
                    begin
                        "Condition Type" := "Condition Type"::Code;
                        Condition := Condition::"<>";
                    end;
                Allfields.Type::Date:
                    begin
                        "Condition Type" := "Condition Type"::Date;
                        Condition := Condition::"<>";
                    end;
                Allfields.Type::Integer:
                    begin
                        "Condition Type" := "Condition Type"::integer;
                        Condition := Condition::"<>";
                        "ConditionInteger Value" := 0;
                    end;
                Allfields.Type::Text:
                    begin
                        "Condition Type" := "Condition Type"::Text;
                        Condition := Condition::"<>";
                    end;
                Allfields.Type::Option:
                    begin
                        "Condition Type" := "Condition Type"::integer;
                        Condition := Condition::"<>";
                        "ConditionInteger Value" := 0;
                    end;
            end;
    end;
}