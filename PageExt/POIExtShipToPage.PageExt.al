pageextension 50110 "POI ExtShipToPage" extends "Ship-to Address"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("POI successor Customer"; "POI successor Customer")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
    }
}