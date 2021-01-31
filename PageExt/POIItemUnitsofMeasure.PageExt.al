pageextension 50000 "POI Item Units of Measure" extends "Item Units of Measure"
{
    layout
    {
        addlast(Control1)
        {
            field("POI Material"; "POI Material")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Empties Item No."; "POI Empties Item No.")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Empties Quantity"; "POI Empties Quantity")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Weight of Packaging"; "POI Weight of Packaging")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Overpackaging"; "POI Overpackaging")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Overpckaging Content"; "POI Overpckaging Content")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter(Control1)
        {
            part(Overpacking; "POI Item Unit of Meas Detail")
            {
                Caption = 'Umverpackungen';
                ApplicationArea = All;
                ToolTip = ' ';
                SubPageLink = "Item No." = field("Item No."), "Unit of Measure" = field(Code);
            }
        }
        modify(Height)
        {
            Visible = true;
            ToolTip = 'Höhe des Gebindes bzw. Stapelhöhe bei Paletten';
        }
    }

}