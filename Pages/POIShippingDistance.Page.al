page 50036 "POI Shipping Distance"
{
    Caption = 'Shipping Distance';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Shipping Distance";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Departureregion; Departureregion)
                {
                    Caption = 'Abgangsregion';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Arrivalregion; Arrivalregion)
                {
                    Caption = 'Zielregion';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field(Distance; Distance)
                {
                    Caption = 'Entfernung in km';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}