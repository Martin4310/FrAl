page 50050 "POI Item Unit of Meas Detail"
{
    Caption = 'Item Unit of Measure Detail';
    PageType = Listpart;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Item Unit of Meas Detail";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Overpacking Unit"; "Overpacking Unit")
                {
                    Caption = 'Umverpackung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Units per Overpacking Unit"; "Units per Overpacking Unit")
                {
                    Caption = 'Anzahl Einheiten pro Umverpackung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("OVP Empties Item No."; "OVP Empties Item No.")
                {
                    Caption = 'Artikelnr. Umverpackung';
                    ApplicationArea = All;
                    ToolTip = 'Artikelnummer des Pfandgebindes';
                }
                field("Palet Code"; "Palet Code")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Units per Palet"; "Units per Palet")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }
}