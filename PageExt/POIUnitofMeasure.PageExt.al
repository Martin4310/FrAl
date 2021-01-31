pageextension 50029 "POI Unit of measure" extends "Units of Measure"
{
    layout
    {
        addlast(Control1)
        {
            field("POI is Overpacking Unit"; "POI is Overpacking Unit")
            {
                Caption = 'Ist Umverpackung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Is Transportation Unit"; "POI Is Transportation Unit")
            {
                Caption = 'Ist Transporteinheit';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Lenght"; "POI Lenght")
            {
                Caption = 'Länge';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Wide"; "POI Wide")
            {
                Caption = 'Breite';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Height"; "POI Height")
            {
                Caption = 'Höhe';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Content Unit of Meas (CP)"; "POI Content Unit of Meas (CP)")
            {
                Caption = 'Anzahl Einheiten in Umverpackung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Qty. Empties Items"; "POI Qty. Empties Items")
            {
                Caption = 'Menge Pfandartikel pro Einheit';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Empties Item No."; "POI Empties Item No.")
            {
                Caption = 'Pfandartikelnr.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Weight of Packaging"; "POI Weight of Packaging")
            {
                Caption = 'Gewicht der Verpackung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter(Control1)
        {
            part("POI Unit of Measure Details"; "POI Unit of Measure Details")
            {
                Caption = 'Artikeleinheiten Details';
                ApplicationArea = All;
                ToolTip = ' ';
                SubPageLink = "Unit of Measure" = field(Code);
            }
        }
    }
}