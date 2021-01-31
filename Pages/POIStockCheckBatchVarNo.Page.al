page 5110490 "POI Stock Check Batch Var. No."
{
    Caption = 'Stock Check Batch Variant No.';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Batch Variant";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                grid(unit)
                {
                    GridLayout = Columns;
                    field("Base Unit of Measure (BU)"; "Base Unit of Measure (BU)")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                    field("Unit of Measure Code"; "Unit of Measure Code")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(inventory)
                {
                    GridLayout = Columns;
                    field("B.V. Inventory (Qty.)"; "B.V. Inventory (Qty.)")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(InvDiff; "B.V. Inventory (Qty.)" / "Qty. per Unit of Measure")
                    {
                        Caption = 'InvDiff';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(Purchase)
                {
                    GridLayout = Columns;
                    field("B.V. Purch. Order (Qty)"; "B.V. Purch. Order (Qty)")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Purchdiff; "B.V. Purch. Order (Qty)" / "Qty. per Unit of Measure")
                    {
                        Caption = 'Purchdiff';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(Sales)
                {
                    GridLayout = Columns;
                    field("B.V. Sales Order (Qty)"; "B.V. Sales Order (Qty)")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(SalesDiff; "B.V. Sales Order (Qty)" / "Qty. per Unit of Measure")
                    {
                        Caption = 'SalesDiff';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(gridDiff)
                {
                    GridLayout = Columns;
                    field(gdc_DifferenzMengef; gdc_DifferenzMenge)
                    {
                        Caption = 'gdc_DifferenzMengef';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(Diff; gdc_DifferenzMenge / "Qty. per Unit of Measure")
                    {
                        Caption = 'Diff';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                grid(pack)
                {
                    GridLayout = Columns;
                    field("B.V. Pack. Input (Qty)"; "B.V. Pack. Input (Qty)")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(PackDiff; "B.V. Pack. Input (Qty)" / "Qty. per Unit of Measure")
                    {
                        Caption = 'PackDiff';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(packPack)
                {
                    GridLayout = Columns;
                    field("B.V. Pack. Pack.-Input (Qty)"; "B.V. Pack. Pack.-Input (Qty)")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(packpackdiff; "B.V. Pack. Pack.-Input (Qty)" / "Qty. per Unit of Measure")
                    {
                        Caption = 'packpackdiff';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(Reservation)
                {
                    GridLayout = Columns;
                    field("B.V. FV Reservation (Qty)"; "B.V. FV Reservation (Qty)")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(ReservationDiff; "B.V. FV Reservation (Qty)" / "Qty. per Unit of Measure")
                    {
                        Caption = 'ReservationDiff';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(Creditmemo)
                {
                    GridLayout = Columns;
                    field("B.V. Sales Cr. Memo (Qty)"; "B.V. Sales Cr. Memo (Qty)")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field(CreditmemoDiff; "B.V. Sales Cr. Memo (Qty)" / "Qty. per Unit of Measure")
                    {
                        Caption = 'CreditmemoDiff';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        SETRANGE("Item No.", gco_Artikelnummer);
        SETRANGE("No.", gco_BatchVariantNo);
        FILTERGROUP(0);
        IF FIND('-') THEN;
    end;

    PROCEDURE SSP_GlobaleSetzen(vco_Artikelnummer: Code[20]; vco_BatchVariantNo: Code[20]; vco_Lagerortcode: Code[10]; vdc_Differenzmenge: Decimal);
    BEGIN
        gco_Artikelnummer := vco_Artikelnummer;
        gco_BatchVariantNo := vco_BatchVariantNo;
        gco_Lagerortcode := vco_Lagerortcode;
        gdc_DifferenzMenge := vdc_Differenzmenge;
    END;

    var
        gco_Artikelnummer: Code[20];
        gco_BatchVariantNo: Code[20];
        gco_Lagerortcode: Code[10];
        gdc_DifferenzMenge: Decimal;

}