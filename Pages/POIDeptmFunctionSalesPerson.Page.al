page 50065 "POI Deptm Function SalesPerson"
{
    Caption = 'Abteilungsfunktionen pro Verkäufer/Einkäufer';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Depmt Function SalesPerson";

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
                    Visible = false;
                }
                field("Function Code"; "Function Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
    }
}