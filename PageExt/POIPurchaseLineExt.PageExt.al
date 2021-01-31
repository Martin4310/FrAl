pageextension 50011 "POI Purchase Line Ext" extends "Purchase Order Subform"
{
    layout
    {
        addafter(Type)
        {
            field("POI Batch State"; "POI Batch State")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter("No.")
        {
            field("POI Customer Group Code"; "POI Customer Group Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Batch Variant No."; "POI Batch Variant No.")
            {
                Caption = 'Pos.-Var.-Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Batch Variant No."; Description)
        addafter(Description)
        {
            field("POI Variety Code"; "POI Variety Code")
            {
                Caption = 'Sortencode';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Country of Origin Code"; "POI Country of Origin Code")
            {
                Caption = 'Erzeugerland';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Grade of Goods Code"; "POI Grade of Goods Code")
            {
                Caption = 'Handlesklasse';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Trademark Code"; "POI Trademark Code")
            {
                Caption = 'Markencode';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Caliber Code"; "POI Caliber Code")
            {
                Caption = 'Kalibercode';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Item Attribute 2"; "POI Item Attribute 2")
            {
                Caption = 'Farbe Code';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Item Attribute 7"; "POI Item Attribute 7")
            {
                Caption = 'Konservierungs Code';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI ean"; "POI ean")
            {
                Caption = 'EAN';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI PLU-Code"; "POI PLU-Code")
            {
                Caption = 'PLU-Code';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Zusatz"; "POI Zusatz")
            {
                Caption = 'Zusatz';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Packing Type"; "POI Packing Type")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }

            field("POI Info 1"; "POI Info 1")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Info 2"; "POI Info 2")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Info 3"; "POI Info 3")
            {
                Caption = 'Los Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Container No."; "POI Container No.")
            {
                Caption = 'Container No.';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("Location Code"; "Unit of Measure Code")
        addafter(Quantity)
        {
            field("POI Transport Unit of Meas(TU)"; "POI Transport Unit of Meas(TU)")
            {
                Caption = 'Transporteinheit (TE)';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Qty. (Unit) per Transp(TU)"; "POI Qty. (Unit) per Transp(TU)")
            {
                Caption = 'Menge (Einheit) pro Transporteinheit';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Quantity (TU)"; "POI Quantity (TU)")
            {
                Caption = 'Menge (TE)';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Currency Code"; "Currency Code")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Price Base (Purch. Price)"; "POI Price Base (Purch. Price)")
            {
                Caption = 'Preisbasis (EK-Preis)';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Purch. Price (Price Base)"; "POI Purch. Price (Price Base)")
            {
                Caption = 'EK-Preis (Preisbasis)';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Purch. Price (Price Base)"; "Unit Cost (LCY)")
        moveafter("Unit Cost (LCY)"; "Line Amount")
        addafter("Line Amount")
        {
            field("POI Status Customs Duty"; "POI Status Customs Duty")
            {
                Caption = 'Zollstatus';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("POI Status Customs Duty"; "Line Discount %")
        moveafter("Line Discount %"; "Qty. to Receive")
        moveafter("Qty. to Receive"; "Quantity Received")
        moveafter("Quantity Received"; "Qty. to Invoice")
        moveafter("Qty. to Invoice"; "Quantity Invoiced")
        moveafter("Quantity Invoiced"; "Expected Receipt Date")
        moveafter("Expected Receipt Date"; "Shortcut Dimension 1 Code")
        addafter("Shortcut Dimension 1 Code")
        {
            field("Gross Weight"; "Gross Weight")
            {
                Caption = 'Bruttogewicht';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("Net Weight"; "Net Weight")
            {
                Caption = 'Nettogewicht';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(QtySalesOrderf; QtySalesOrder)
            {
                Caption = 'Menge in VK-Auftrag';
                ApplicationArea = All;
                ToolTip = ' ';
                Editable = false;
            }
            field(QtySalesShipmentf; QtySalesShipment)
            {
                Caption = 'Menge in VK-Lieferung';
                ApplicationArea = All;
                ToolTip = ' ';
                Editable = false;
            }
        }

        modify("Bin Code")
        {
            Visible = false;
        }
        modify("Unit Cost (LCY)")
        {
            Visible = true;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Qty. to Assign")
        {
            Visible = false;
        }
        modify("Qty. Assigned")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("Planned Receipt Date")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 2 Code")
        {
            Visible = false;
        }
        modify(ShortcutDimCode3)
        {
            Visible = false;
        }
        modify(ShortcutDimCode4)
        {
            Visible = false;
        }
        modify("Reserved Quantity")
        {
            Visible = false;
        }
        modify("Direct Unit Cost")
        {
            Visible = false;
        }
    }
    trigger OnAfterGetRecord()
    begin
        BatchManagement.CalcStockBatchVar("POI Batch Variant No.", '', 0.1, InventoryTemp, InventoryAvailableTemp //TODO: Berechnung
        , QtyAvailable, QtySalesOrder, QtyPurchaseOrder, QtyReservation, QtyCustomerClearance
        , QtySalesInvoice, QtySalesShipment, QtyPurchShipment, "Qty. per Unit of Measure");
    end;

    var
        BatchManagement: Codeunit "POI BAM Batch Management";
        QtySalesOrder: Decimal;
        QtySalesShipment: Decimal;
        InventoryTemp: Decimal;
        InventoryAvailableTemp: Decimal;
        QtyAvailable: Decimal;
        QtyPurchaseOrder: Decimal;
        QtyReservation: Decimal;
        QtyCustomerClearance: Decimal;
        QtySalesInvoice: Decimal;
        QtyPurchShipment: Decimal;
}