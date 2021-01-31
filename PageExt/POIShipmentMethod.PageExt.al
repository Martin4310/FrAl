pageextension 50032 "POI Shipment Method" extends "Shipment Methods"
{
    layout
    {
        addlast(Control1)
        {

            field("POI Self-Collector"; "POI Self-Collector")
            {
                Caption = 'Abholung';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnValidate()
                begin
                    if "POI Self-Collector" then "POI geliefert" := false;
                end;
            }
            field("POI Duty Paid"; "POI Duty Paid")
            {
                Caption = 'verzollt';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI geliefert"; "POI geliefert")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnValidate()
                begin
                    if "POI geliefert" then "POI Self-Collector" := false;
                end;
            }
            field("POI aktiv"; "POI aktiv")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            // field("POI Incl. Freig to Transf Loc."; "POI Incl. Freig to Transf Loc.")
            // {
            //     ApplicationArea = All;
            //     ToolTip = ' ';
            // }
        }
        modify(Description)
        {
            ShowMandatory = true;
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "POI geliefert" := true;
    end;


}