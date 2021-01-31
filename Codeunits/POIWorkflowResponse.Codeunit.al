codeunit 50004 "POI Workflow Response"
{
    procedure MyWorkflowResponseCode(): Code[128]
    begin
        exit(copystr(UpperCase('ResponseOnAfterCreateVendor'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnAddWorkflowResponsesToLibrary', '', false, false)]

    procedure AddMyWorkflowResponsesToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(MyWorkflowResponseCode(), Database::Vendor, 'Öffnen der QS-Karte.', 'GROUP 50000');
    end;

    procedure MyWorkflowResponse(Vendor: Record Vendor; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        QualityManagement: Record "POI Quality Management";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then;
        if QualityManagement.Get(Vendor."No.", QualityManagement."Source Type"::Vendor) then
            Page.Run(Page::"POI Quality Management List", QualityManagement)
        else
            Message('QM-Karte nicht gefunden.');
    end;

    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnExecuteWorkflowResponse', '', false, false)]
    procedure ExecuteMyWorkflowResponses(var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    var
        workflowResponse: Record "Workflow Response";
    begin

        if workflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            case workflowResponse."Function Name" of
                MyWorkFlowResponseCode():
                    Begin
                        MyworkflowResponse(xVariant, ResponseWorkflowStepInstance);
                        ResponseExecuted := true;
                    End;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1521, 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    procedure AddMyWorkflowEventResponseCombinationsToLibrary(ResponseFunctionName: Code[128])
    var
        MyWorkflowEvents: Codeunit "POI WorkFlow Events";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        CASE ResponseFunctionName OF
            MyWorkflowResponseCode():
                begin
                    //Eintragung des eigenen Responese zur Verwendung
                    WorkflowResponseHandling.AddResponsePredecessor(MyWorkflowResponseCode(), MyWorkflowEvents.MyWorkflowEventCode());
                    //Eintragung des Responses zur Erstellung eines Genehmigungspostens für den oben genannten Response
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode(), MyWorkflowEvents.MyWorkflowEventCode());
                end;
        end;
    end;

}