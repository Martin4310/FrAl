page 50063 "POI Workflow Task List"
{
    Caption = 'Workflow Liste';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Workflow Task";
    CardPageId = "POI Workflow Task Card";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Source Type"; "Source Type")
                {
                    Caption = 'Herkunftsart';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source No."; "Source No.")
                {
                    Caption = 'Herkunftsnr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Company; Company)
                {
                    Caption = 'Mandant';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    StyleExpr = StatusColor;
                }
                field("Delegated from"; "Delegated from")
                {
                    Caption = 'delegiert von';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    Caption = 'Beschreibung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Task No."; "Task No.")
                {
                    Caption = 'Aufgabenbereich';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("WF Group No"; "WF Group No")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                Caption = 'Alle Workflows prüfen';
                ApplicationArea = All;
                ToolTip = ' ';

                trigger OnAction();
                begin
                    WFTask.Reset();
                    WFTask.SetFilter(Status, '<>%1', WFTask.status::Approved);
                    if WFTask.FindSet() then
                        repeat
                            WFMgt.CheckTask(WFTask);
                        until WFTask.Next() = 0;
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        SourceNoFilter: Text[100];
    begin
        WFUserGroupMember.SetRange("User Name", Userid());
        if WFUserGroupMember.FindSet() then
            repeat
                if SourceNoFilter <> '' then
                    SourceNoFilter += '|';
                SourceNoFilter += WFUserGroupMember."Workflow User Group Code";
            until WFUserGroupMember.Next() = 0;
        SetFilter("Source Type", '%1|%2|%3', "Source Type"::Team, "Source Type"::"User Group", "Source Type"::User);
        if SourceNoFilter <> '' then
            SourceNoFilter += '|';
        SourceNoFilter += UserId();
        SetFilter("Source No.", SourceNoFilter);
        FilterGroup(0);
    end;

    trigger OnAfterGetRecord()
    begin
        if Status = Status::Approved then
            Statuscolor := 'Favorable'
        else
            Statuscolor := 'Attention';
    end;

    var
        WFUserGroupMember: Record "Workflow User Group Member";
        WFTask: Record "POI Workflow Task";
        WFMgt: Codeunit "POI Workflow Management";
        Statuscolor: Text[20];
}