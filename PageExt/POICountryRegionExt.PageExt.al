pageextension 50009 "POI Country/Region Ext" extends "Countries/Regions"
{
    layout
    {
        addlast(Control1)
        {
            field("POI Relevant"; "POI Relevant")
            {
                ApplicationArea = All;
                ToolTip = 'Land wird bei Port verwendet.';
            }
            field(Language; "POI Language")
            {
                Caption = 'Sprache';
                ApplicationArea = all;
                ToolTip = 'Language';
            }
            field("POI Sepa"; "POI Sepa")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Sepa numbers"; "POI IBAN numbers")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
    }
}