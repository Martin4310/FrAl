page 50013 "POI Quality Management List"
{
    Caption = 'Quality Management';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Quality Management";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Vend-Cust-LFB created"; "Vend-Cust-LFB created")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Freigabe für Kreditor"; "Freigabe für Kreditor")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Ausnahmegenehmigung; Ausnahmegenehmigung)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Ausnahmeg. erteilt durch"; "Ausnahmeg. erteilt durch")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Ausnahmegenehmigung erteilt am"; "Ausnahmegenehmigung erteilt am")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Ausnahmegenehmigung Ablauf"; "Ausnahmegenehmigung Ablauf")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("User ID"; "User ID")
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
}