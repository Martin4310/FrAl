pageextension 50008 "POI Purchase Comment Ext" extends "Purch. Comment Sheet"
{
    layout
    {
        addlast(Control1)
        {
            field("POI Check Date"; "POI Check Date")
            {
                Caption = 'geprüft am';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Checked by"; "POI Checked by")
            {
                Caption = 'geprüft von';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Document date"; "POI Document date")
            {
                Caption = 'Belegdatum';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Quantity Pricebasis"; "POI Quantity Pricebasis")
            {
                Caption = 'Menge Preisbasis';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI User ID"; "POI User ID")
            {
                Caption = 'Benutzer ID';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI checked"; "POI checked")
            {
                Caption = 'geprüft';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI external Inv. No."; "POI external Inv. No.")
            {
                Caption = 'externe Belegnr.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
    }
}

