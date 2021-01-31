codeunit 50002 "POI WorkFlow Events"
{
    EventSubscriberInstance = StaticAutomatic;

    procedure MyWorkflowEventCode(): Code[128]
    begin
        exit(copystr(UpperCase('RunWorkflowOnAfterCreateVendorCode'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventsToLibrary', '', false, false)]
    procedure AddMyWorkflowEventsToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(MyWorkflowEventCode(), Database::Vendor, 'Ein Kreditor wurde erstellt.', 0, false);
    end;


    [EventSubscriber(ObjectType::Table, 23, 'SetdefaultPOIWorkflow', '', false, false)]
    procedure RunWorkflowOnAfterCreateAccount(var Vendor: Record Vendor; var xVendor: Record Vendor)
    var
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEventWithxRec(MyWorkflowEventCode(), Vendor, xVendor);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    procedure AddWorkflowHierarchiesToLibrary(EventFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        case EventFunctionName of
            MyWorkflowEventCode():
                begin
                    //Event zum Auslösen des WF
                    WorkflowEventHandling.AddEventPredecessor(MyWorkflowEventCode(), WorkflowEventHandling.RunWorkflowOnVendorChangedCode());
                    //Folgeevents zur weiteren Bearbeitung des oben angegebenen Events
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode(), MyWorkflowEventCode());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(), MyWorkflowEventCode());
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), MyWorkflowEventCode());
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, 1520, 'OnAddWorkflowTableRelationsToLibrary', '', false, false)]
    procedure AddWorkflowTableRelationsToLibrary()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
    begin
        WorkflowSetup.InsertTableRelation(Database::"POI Quality Management", 1, Database::"Approval Entry", 22);
    end;
}