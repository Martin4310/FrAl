page 50054 "POI Workflow Task Card"
{
    Caption = 'Workflow Task';
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    SourceTable = "POI Workflow Task";
    InsertAllowed = false;

    layout
    {

        area(Content)
        {
            group(General)
            {
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Task No."; "Task No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Delegated from"; "Delegated from")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
                field(RecordLink; RecordLink)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
                // field(ID; FORMAT(ID, 0, 0))
                // {
                //     Caption = 'Record ID';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                // }
                field("Last Reminder Date"; "Last Reminder Date")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }

            }
            part("POI Workflow Task Line"; "POI Workflow Task Line")
            {
                Caption = 'Zeilen';
                ToolTip = ' ';
                SubPageLink = "Entry No." = field("Entry No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CheckTask)
            {
                ApplicationArea = All;
                ToolTip = ' ';

                trigger OnAction();
                begin
                    WFMgt.CheckTask(Rec);
                end;
            }
            action(OpenDataSet)
            {
                Caption = 'Datensatz öffnen';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    Vendor: Record Vendor;
                    Customer: Record Customer;
                    QM: Record "POI Quality Management";
                begin
                    case ID.TableNo of
                        Database::Vendor:
                            begin
                                Vendor.get(ID);
                                Page.RunModal(26, Vendor);
                            end;
                        Database::Customer:
                            begin
                                Customer.get(ID);
                                Page.RunModal(21, Customer);
                            end;
                        Database::"POI Quality Management":
                            begin
                                QM.Get(ID);
                                Page.RunModal(50020, QM);
                            end;
                    end;

                end;
            }
            action(Update)
            {
                Caption = 'Aufgabe prüfen';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        WFMgt.CheckTask(Rec);
        CurrPage.Update();
    end;

    var
        WFMgt: Codeunit "POI Workflow Management";

}