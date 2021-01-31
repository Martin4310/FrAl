page 50072 "POI Certificate Type List"
{
    Caption = 'Zertifikatstypenliste';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Certificate Types";
    CardPageId = "POI Certificate Typ Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Activ; Activ)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}