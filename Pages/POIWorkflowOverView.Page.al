page 50053 "POI Workflow Overview"
{
    Caption = 'Workflow Übersicht';
    DataCaptionFields = "Workflow Code", "Record ID";
    PageType = List;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    UsageCategory = Lists;
    ApplicationArea = All;
    ShowFilter = false;
    SourceTable = "Workflow Step Instance";
    //SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                IndentationColumn = Indent;
                IndentationControls = Description;
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Last Modified Date-Time"; "Last Modified Date-Time")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Last Modified By User ID"; "Last Modified By User ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Record ID"; "Record ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdatePageControls();
    end;

    local procedure UpdatePageControls()
    begin
        if Type = Type::"Event" then
            Indent := 0
        else
            Indent := 2;

        Description := CopyStr(GetDescription(), 1, MaxStrLen(Description));
        StyleTxt := GetStyle();
        WorkflowRecord := Format("Record ID", 0, 1);
    end;

    local procedure GetStyle(): Text
    begin
        case Status of
            Status::Completed:
                exit('Favorable');
            Status::Active:
                exit('');
            else
                exit('Subordinate');
        end;
    end;

    local procedure GetDescription(): Text
    var
        WorkflowEvent: Record "Workflow Event";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        case Type of
            Type::"Event":
                if WorkflowEvent.Get("Function Name") then
                    exit(WorkflowEvent.Description);
            Type::Response:
                if WorkflowStepArgument.Get(Argument) then
                    exit(WorkflowResponseHandling.GetDescription(WorkflowStepArgument));
        end;
        exit('');
    end;

    var
        StyleTxt: Text;
        WorkflowRecord: Text;
        Indent: Integer;
}