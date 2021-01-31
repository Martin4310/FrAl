pageextension 50017 "POI Tariff Number Ext" extends "Tariff Numbers" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {

            field("Description 2"; "POI Description 2")
            {
                ApplicationArea = All;
                ToolTip = 'Description 2';
            }
            field("Description 3"; "POI Description 3")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("No. of Attached Items"; "POI No. of Attached Items")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Data changed"; "POI Data changed")
            {
                Caption = 'Änderung zu Sova';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Customer Duty per Kilo"; "POI Customer Duty per Kilo")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Supplementary Units Code"; "POI Supplementary Units Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Supplementary Units Code 2"; "POI Supplementary Units Code 2")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
    }
}