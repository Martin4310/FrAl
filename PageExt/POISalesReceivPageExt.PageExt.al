pageextension 50019 "POI Sales Receiv Page Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Order Nos.")
        {
            field("POI Tour No."; "POI Tour No.")
            {
                Caption = 'EK Tour Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Credit Check first"; "POI Credit Check first")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Credit Check second"; "POI Credit Check second")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
    }

}