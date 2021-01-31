codeunit 50013 "POI Workflow Management"
{
    procedure TaskCreateAccount(AccountRecID: RecordId; TaskDescription: Text[100]; TemplateCode: Code[20]; AccountCode: Code[20]; Company: Code[50]): integer
    var
        NextGroupNo: Integer;
    begin
        WFTask.Reset();
        If WFTask.Findlast() then begin
            NextGroupNo := WFTask."WF Group No" + 1;
            Nextno := WFTask."Entry No." + 1;
        end else begin
            NextGroupNo := 1;
            Nextno := 1;
        end;
        if Company = '' then
            Company := POICompany.GetBasicCompany();
        WFTemplateHeader.SetRange("Template Code", TemplateCode);
        WFTemplateHeader.SetRange("Line Type", WFTemplate."Line Type"::Header);
        IF WFTemplateHeader.FindFirst() then
            repeat
                WFTask.Init();
                WFTask."Entry No." := Nextno;
                WFTask."WF Group No" := NextGroupNo;
                WFTask."Task No." := WFTemplateHeader."Task No.";
                WFTask."Source Type" := WFTemplateHeader."Source Type";
                if (WFTemplateHeader."Source Type" = WFTemplateHeader."Source Type"::User) and (WFTask."Source No." <> '') then
                    WFTask."Source No." := copystr(UserId(), 1, MaxStrLen(WFTask."Source No."))
                else
                    WFTask."Source No." := WFTemplateHeader."Source No.";
                WFTask.Company := copystr(Company, 1, MaxStrLen(WFTask.Company));
                WFTask.Status := WFTask.Status::open;
                WFTask.Description := copystr(TaskDescription + WFTask."Task No." + ' ' + Format(AccountRecID), 1, MaxStrLen(WFTask.Description));
                WFTask.ID := AccountRecID;
                WFTask."Account Code" := AccountCode;
                WFTask.RecordLink := copystr(CreateWFLink(AccountRecID, Company), 1, MaxStrLen(WFTask.RecordLink));
                WFTask.Insert();

                WFTemplate.Reset();
                WFTemplate.SetRange("Template Code", WFTemplateHeader."Template Code");
                WFTemplate.SetRange("Line Type", WFTemplate."Line Type"::Line);
                WFTemplate.SetRange("Task No.", WFTemplateHeader."Task No.");
                if WFTemplate.FindSet() then
                    repeat
                        WFTaskLine.Init();
                        WFTaskLine."Entry No." := WFTask."Entry No.";
                        WFTaskLine."Line No." := WFTemplate."Line No.";
                        WFTaskLine."Table ID" := WFTemplate."Table ID";
                        WFTaskLine."Field No." := WFTemplate."Field No.";
                        WFTaskLine."Task No." := WFTemplate."Task No.";
                        WFTaskLine."Condition Type" := WFTemplate."Condition Type";
                        WFTaskLine.Condition := WFTemplate.Condition;
                        WFTaskLine."ConditionText Value" := WFTemplate."ConditionText Value";
                        WFTaskLine."ConditionCode Value" := WFTemplate."ConditionCode Value";
                        WFTaskLine."ConditionInteger Value" := WFTemplate."ConditionInteger Value";
                        WFTaskLine."ConditionDate Value" := WFTemplate."ConditionDate Value";
                        WFTaskLine."ConditionBoolean Value" := WFTemplate."ConditionBoolean Value";
                        WFTaskLine.Filtertxt := WFTemplate.Filtertxt;
                        WFTaskLine."Account Code" := WFTask."Account Code";
                        WFTaskLine.Exception := WFTemplate.Exception;
                        WFTaskLine."Exception Task No." := WFTemplate."Exception Task No.";
                        WFTaskLine."WF Group No" := WFTask."WF Group No";
                        WFTaskLine.Insert();
                    until WFTemplate.Next() = 0;
                Nextno += 1;
            until WFTemplateHeader.Next() = 0;
        exit(NextGroupNo);
    end;

    Procedure CheckTask(var Task: Record "POI Workflow Task")
    begin
        WFTaskLine.Reset();
        WFTaskLine.SetRange("Entry No.", Task."Entry No.");
        WFTaskLine.SetRange(Closed, false);
        if WFTaskLine.FindSet() then
            repeat
                CheckTaskLine(WFTaskLine, '', false);
            until WFTaskLine.Next() = 0;
        CheckTaskStatus(Task);
    end;

    procedure CheckTaskStatus(var Task: Record "POI Workflow Task")
    begin
        WFTaskLine.Reset();
        WFTaskLine.SetRange("Entry No.", Task."Entry No.");
        WFTaskLine.SetRange(Closed, false);
        if WFTaskLine.IsEmpty then begin
            Task.Status := Task.Status::Approved;
            Task.Modify();
        end;
    end;

    procedure CheckTaskLine(TaskLine: Record "POI Workflow Task Line"; NewValue: Variant; New: Boolean)
    var
        Task: Record "POI Workflow Task";
        TaskRecRef: RecordRef;
        TaskFieldRef: FieldRef;
        ExceptionApproved: Boolean;
    begin
        Clear(TaskRecRef);
        Clear(TaskFieldRef);
        Clear(TaskReady);
        Task.Get(TaskLine."Entry No.");
        if TaskLine.Exception <> 0 then begin
            TaskLine2.SetRange("WF Group No", TaskLine."WF Group No");
            TaskLine2.SetRange("Task No.", TaskLine."Exception Task No.");
            TaskLine2.SetRange("Line No.", TaskLine.Exception);
            if TaskLine2.FindFirst() and TaskLine2.Closed then
                ExceptionApproved := true;
        end;
        if not ExceptionApproved then begin
            TaskRecRef.Get(Task.ID);
            TaskFieldRef := TaskRecRef.Field(TaskLine."Field No.");
            case TaskLine."Condition Type" of
                TaskLine."Condition Type"::Boolean:
                    begin
                        if new then
                            TaskBoolean := NewValue
                        else
                            TaskBoolean := TaskFieldRef.Value;
                        TaskReady := CompareBooleanValues(TaskBoolean, TaskLine."ConditionBoolean Value", TaskLine.Condition);
                    end;
                TaskLine."Condition Type"::Text:
                    begin
                        if new then
                            TaskText := NewValue
                        else
                            TaskText := TaskFieldRef.Value;
                        TaskReady := CompareTextValues(TaskText, TaskLine."ConditionText Value", TaskLine.Condition);
                    end;
                TaskLine."Condition Type"::Code:
                    begin
                        if new then
                            TaskCode := NewValue
                        else
                            TaskCode := TaskFieldRef.Value;
                        TaskReady := CompareCodeValues(Taskcode, TaskLine."ConditionCode Value", TaskLine.Condition);
                    end;
                TaskLine."Condition Type"::integer:
                    begin
                        if new then
                            TaskInteger := NewValue
                        else
                            TaskInteger := TaskFieldRef.Value;
                        TaskReady := CompareIntegerValues(TaskInteger, TaskLine."Conditioninteger Value", TaskLine.Condition);
                    end;
                TaskLine."Condition Type"::Date:
                    begin
                        if new then
                            TaskDate := NewValue
                        else
                            TaskDate := TaskFieldRef.Value;
                        TaskReady := CompareDateValues(TaskDate, TaskLine."ConditionDate Value", TaskLine.Condition);
                    end;
            end;
        end;
        if TaskReady or ExceptionApproved then begin
            TaskLine.Closed := true;
            TaskLine."Approved by User ID" := copystr(UserId(), 1, MaxStrLen(TaskLine."Approved by User ID"));
            TaskLine."Approved at" := CreateDateTime(Today(), Time());
            if TaskReady then
                TaskLine."Approved by" := TaskLine."Approved by"::User
            else
                if ExceptionApproved then
                    TaskLine."Approved by" := TaskLine."Approved by"::Exception;
            TaskLine.Modify();
        end;
    end;

    procedure CompareCodeValues(SourceValue: Code[20]; TaskValue: Code[20]; Operator: enum "POI Operator"): Boolean
    begin
        case Operator of
            Operator::"<>":
                exit(TaskValue <> SourceValue);
            Operator::"<":
                exit(TaskValue < SourceValue);
            Operator::"=":
                exit(TaskValue = SourceValue);
            Operator::">":
                exit(TaskValue > SourceValue);
            Operator::"<=":
                exit(TaskValue <= SourceValue);
            Operator::">=":
                exit(TaskValue >= SourceValue);
        end;
    end;

    procedure CompareTextValues(SourceValue: Text[100]; TaskValue: Text[100]; Operator: enum "POI Operator"): Boolean
    begin
        case Operator of
            Operator::"<>":
                exit(TaskValue <> SourceValue);
            Operator::"<":
                exit(TaskValue < SourceValue);
            Operator::"=":
                exit(TaskValue = SourceValue);
            Operator::">":
                exit(TaskValue > SourceValue);
            Operator::"<=":
                exit(TaskValue <= SourceValue);
            Operator::">=":
                exit(TaskValue >= SourceValue);
        end;
    end;

    procedure CompareIntegerValues(SourceValue: Integer; TaskValue: Integer; Operator: enum "POI Operator"): Boolean
    begin
        case Operator of
            Operator::"<>":
                exit(TaskValue <> SourceValue);
            Operator::"<":
                exit(TaskValue < SourceValue);
            Operator::"=":
                exit(TaskValue = SourceValue);
            Operator::">":
                exit(TaskValue > SourceValue);
            Operator::"<=":
                exit(TaskValue <= SourceValue);
            Operator::">=":
                exit(TaskValue >= SourceValue);
        end;
    end;

    procedure CompareBooleanValues(SourceValue: Boolean; TaskValue: Boolean; Operator: enum "POI Operator"): Boolean
    begin
        case Operator of
            Operator::"<>":
                exit(TaskValue <> SourceValue);
            Operator::"<":
                exit(TaskValue < SourceValue);
            Operator::"=":
                exit(TaskValue = SourceValue);
            Operator::">":
                exit(TaskValue > SourceValue);
            Operator::"<=":
                exit(TaskValue <= SourceValue);
            Operator::">=":
                exit(TaskValue >= SourceValue);
        end;
    end;

    procedure CompareDateValues(SourceValue: Date; TaskValue: Date; Operator: enum "POI Operator"): Boolean
    begin
        case Operator of
            Operator::"<>":
                exit(TaskValue <> SourceValue);
            Operator::"<":
                exit(TaskValue < SourceValue);
            Operator::"=":
                exit(TaskValue = SourceValue);
            Operator::">":
                exit(TaskValue > SourceValue);
            Operator::"<=":
                exit(TaskValue <= SourceValue);
            Operator::">=":
                exit(TaskValue >= SourceValue);
        end;
    end;

    procedure SendTaskMail(TaskNo: Integer)
    var
        TaskNoTxt: Text;
        WFGroup: Text[100];
        MailBody: Text;
        EMailReceiver: list of [Text];
        EMailSender: Text[100];
        Reminder: Boolean;
        CalcText: Text[30];
        Subject: Text[100];
    begin
        WFTask.Reset();
        if TaskNo <> 0 then
            WFTask.SetRange("Entry No.", TaskNo);
        WFTask.SetRange(Status, WFTask.Status::open);
        if WFTask.FindSet() then
            repeat
                Clear(Reminder);
                //Get Emailfrom Source
                WFGroups.ChangeCompany(WFTask.Company);
                if (WFTask."Source Type" = WFTask."Source Type"::"User Group") then
                    if WFGroups.Get(WFTask."Source No.") then begin
                        WFGroup := WFGroups.Description;

                        if Format(WFGroups."POI Reminder Period") <> '' then begin
                            CalcText := StrSubstNo('<%1>', WFGroups."POI Reminder Period");
                            Reminder := Calcdate(CalcText, WFTask."Last Reminder Date") <= Today();
                        end else
                            Reminder := true;
                    end;
                if Reminder then begin
                    WFTaskLine.Reset();
                    WFTaskLine.SetRange("Entry No.", WFTask."Entry No.");
                    WFTaskLine.SetRange(Closed, false);
                    if WFTaskLine.FindSet() then
                        repeat
                            WFTaskLine.CalcFields("Table Name", "Field Name");
                            TaskNoTxt += WFTaskLine."Field Name" + '<br>';
                        until WFTaskLine.Next() = 0;
                    AllObjects.Get(AllObjects."Object Type"::Table, WFTask.ID.TableNo);
                    MailSenderReceiver.GetMailSenderReceiver('WF', 'SENDREMINDER', EMailSender, EMailReceiver, WFTask.Company);
                    Subject := strsubstno('Workflowaufgabe Nr. %1 für %2 im Mandant %3', WFTask."Entry No.", WFGroup, WFTask.Company);
                    MailBody := 'Es liegen noch offene Aufgaben vor. Bitte folgende Felder in Tabelle ' + AllObjects."Object Caption" + ' ausfüllen: <br>' + TaskNoTxt + '<br>';
                    MailBody += 'Link zur Workflowaufgabe ' + System.GetUrl(ClientType::Web, WFTask.Company, ObjectType::Page, Page::"POI Workflow Task Card", WFTask, false);
                    if (EMailReceiver.Count > 0) and (EMailSender <> '') then begin
                        SMTPMail.CreateMessage('Workflowaufgabe', EMailSender, EMailReceiver, Subject, Mailbody);
                        SMTPMail.Send();
                    end;
                    WFTask."Last Reminder Date" := today();
                    WFTask.Modify();
                end;
            until WFTask.Next() = 0;
    end;

    procedure CreateWFLink(WFRecordID: RecordId; Company: Code[50]): Text
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        QM: Record "POI Quality Management";
        LinkTxt: Text;
    begin
        if Company = '' then
            Company := POICompany.GetBasicCompany();
        case WFRecordID.TableNo of
            Database::Vendor:
                begin
                    Vendor.get(WFRecordID);
                    LinkTxt := System.GetUrl(ClientType::Web, Company, ObjectType::Page, Page::"Vendor Card", Vendor, false);
                end;
            Database::"POI Quality Management":
                begin
                    QM.Get(WFRecordID);
                    LinkTxt := System.GetUrl(ClientType::Web, Company, ObjectType::Page, Page::"POI Account Check", QM, false);
                end;
            Database::Customer:
                begin
                    Customer.Get(WFRecordID);
                    LinkTxt := System.GetUrl(ClientType::Web, Company, ObjectType::Page, Page::"Customer Card", Customer, false);
                end;
        end;
        exit(LinkTxt);
        //exit('http://port-ts-test:8180/BC150/?company=' + Company + '&bookmark=' + Format(Vendor.RecordId, 0, 10) + '&page=26&dc=0');
    end;

    procedure WFReminder()
    begin
        WFTask.Reset();
        WFTask.SetRange(Status, WFTask.Status::open);
        if WFTask.FindSet() then
            repeat
                SendTaskMail(WFTask."Entry No.");
            until WFTask.next() = 0;
    end;

    procedure GetTeamsFromgroup(GroupNo: Integer; var GroupList: List of [Text])
    begin
        WFTask.Reset();
        WFTask.SetRange("WF Group No", GroupNo);
        if WFTask.FindSet() then
            repeat
                if not GroupList.Contains(WFTask."Source No.") then
                    GroupList.Add(WFTask."Source No.");
            until WFTask.Next() = 0;
    end;

    procedure MailStyle(Font: Text[20]; Color: Text[10]; FontSize: Text[2]): Text
    begin
        Exit('<p style="font-family:' + Font + '";style="color:' + Color + ';style="font-size:' + Fontsize + 'px">');
        //MailStyle('Arial','red','30');
    end;

    procedure Mailstyle(): Text
    begin
        Exit('<p style="font-family:Arial";style="color:black;style="font-size:10px">');
    end;


    var
        WFTask: Record "POI Workflow Task";
        WFTaskLine: Record "POI Workflow Task Line";
        TaskLine2: Record "POI Workflow Task Line";
        WFTemplate: Record "POI Workflow Template";
        WFTemplateHeader: Record "POI Workflow Template";
        WFGroups: Record "Workflow User Group";
        AllObjects: Record AllObjWithCaption;
        MailSenderReceiver: Record "POI Mail Setup";
        POICompany: Record "POI Company";
        SMTPMail: Codeunit "SMTP Mail";
        Nextno: Integer;
        TaskText: Text[100];
        TaskCode: code[20];
        TaskInteger: Integer;
        TaskBoolean: Boolean;
        TaskReady: Boolean;
        TaskDate: Date;
}