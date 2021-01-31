page 50064 "POI Department Function List"
{
    Caption = 'Abteilungs Funktionen';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Department Function";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Function Code"; "Function Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Function Name"; "Function Name")
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