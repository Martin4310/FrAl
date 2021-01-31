page 50031 "POI Ship Agent Freight Cost"
{
    Caption = 'Transportkosten';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Ship.-Agent Freightcost";
    layout
    {

        area(Content)
        {
            field(ShipTillDate; Tilldate)
            {
                Caption = 'Neues Gültigkeitsdatum';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            repeater(Group)
            {
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    Caption = 'Spedition';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field("Departure Region Code"; "Departure Region Code")
                {
                    Caption = 'Abgangsregion';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field("Arrival Region Code"; "Arrival Region Code")
                {
                    Caption = 'Zielregion';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Distance; Distance)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Freight Rate per Unit"; "Freight Rate per Unit")
                {
                    Caption = 'Kosten';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    StyleExpr = StyleVar;
                    trigger OnValidate()
                    begin
                        SetStyle();
                    end;
                }
                field("Second Driver"; "Second Driver")
                {
                    Caption = 'Zweiter Fahrer';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Valid From"; "Valid From")
                {
                    Caption = 'gültig ab';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Valid until"; "Valid until")
                {
                    Caption = 'gültig bis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Pauschal; Pauschal)
                {
                    Caption = 'Pauschal';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Combination with"; "Combination with")
                {
                    Caption = 'Kombination mit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Freight Unit of Measure Code"; "Freight Unit of Measure Code")
                {
                    Caption = 'Transporteinheit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Vendor No."; "Vendor No.")
                {
                    Caption = 'Kreditor Nr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("From Quantity"; "From Quantity")
                {
                    Caption = 'Ab Menge';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Until Quantity"; "Until Quantity")
                {
                    Caption = 'bis Menge';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CopyConditions)
            {
                Caption = 'Werte kopieren';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    CopyFreightCostNewPeriod("Shipping Agent Code", Tilldate);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStyle();
    end;

    procedure SetStyle()
    begin
        if "Freight Rate per Unit" = 0 then
            StyleVar := 'Attention'
        else
            StyleVar := '';
    end;

    var
        Tilldate: Date;
        StyleVar: Text[30];
}