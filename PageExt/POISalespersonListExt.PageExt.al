pageextension 50007 "POI SalespersonListExt" extends "Salespersons/Purchasers"
{
    layout
    {
        addafter(Name)
        {
            field("POI Is Person in Charge"; "POI Is Person in Charge")
            {
                Caption = 'ist Sachbearbeiter';
                ApplicationArea = all;
                ToolTip = ' ';
            }
            field("POI Is Purchaser"; "POI Is Purchaser")
            {
                Caption = 'ist Einkäufer';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Is Salesperson"; "POI Is Salesperson")
            {
                Caption = 'ist Verkäufer';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        modify("Commission %")
        {
            Visible = false;
        }
    }

    actions
    {
    }
}