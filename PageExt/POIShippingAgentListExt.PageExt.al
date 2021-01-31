pageextension 50026 "POI Shipping Agent List Ext" extends "Shipping Agents"
{
    layout
    {
        addlast(Control1)
        {
            field(Blocked; "POI Blocked")
            {
                Caption = 'gesperrt';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Vendor No."; "POI Vendor No.")
            {
                Caption = 'Kreditor-Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
            }

        }

    }
}