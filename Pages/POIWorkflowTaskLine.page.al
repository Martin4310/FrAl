page 50061 "POI Workflow Task Line"
{
    Caption = 'Workflow Aufgaben Zeile';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI workflow Task Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Table Name"; "Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    StyleExpr = LineColor;
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
                }
                field(Condition; Condition)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("ConditionCode Value"; "ConditionCode Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ConditionInteger Value"; "ConditionInteger Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ConditionText Value"; "ConditionText Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ConditionBoolean Value"; "ConditionBoolean Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("ConditionDate Value"; "ConditionDate Value")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Filtertxt; Filtertxt)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Closed; Closed)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Approved by User ID"; "Approved by User ID")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Approved at"; "Approved at")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Exception; Exception)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Approved by"; "Approved by")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                Caption = 'Datensatz öffnen';
                ApplicationArea = All;
                ToolTip = ' ';
                Promoted = true;
                PromotedIsBig = true;
                Image = Card;

                trigger OnAction();
                begin
                    WFTask.Get("Entry No.");
                    Vendor.Get(WFTask.ID);
                    case "Table ID" of
                        23:
                            begin
                                Vendor.Get(WFTask.ID);
                                Page.RunModal(26, Vendor);
                            end;
                        50906:
                            begin
                                QM.Get(WFTask.ID);
                                if POIFunction.UserInWindowsRole('GL') then
                                    Page.RunModal(Page::"POI Account Check GL", QM)
                                else
                                    page.RunModal(Page::"POI Account Check", QM);
                            end;
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Closed then
            LineColor := 'favorable'
        else
            LineColor := 'Attention';
    end;

    var
        Vendor: Record Vendor;
        QM: Record "POI Quality Management";
        WFTask: Record "POI Workflow Task";
        POIFunction: Codeunit POIFunction;
        LineColor: Text[20];
}