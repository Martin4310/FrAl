page 50071 "POI Account Refunds List"
{
    Caption = 'Rückvergütung';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Account Refunds";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Refund Source Type"; "Refund Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Periode; Periode)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Percentage; Percentage)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        GetRefundsToText("No.", "Source Type");
    end;

    procedure setItemNo(AccountNo: Code[20])
    begin
        ActAccountNo := AccountNo;
    end;

    var
        ActAccountNo: Code[20];
}