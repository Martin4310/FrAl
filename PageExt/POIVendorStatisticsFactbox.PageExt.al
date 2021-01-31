pageextension 50006 "POI Vendor Statistics Factbox" extends "Vendor Statistics FactBox"
{
    layout
    {
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify(TotalAmountLCY)
        {
            //visible = false;
            Caption = 'Gesamtforderungen';
        }
        modify(GetInvoicedPrepmtAmountLCY)
        {
            Visible = false;
        }
        modify("Payments (LCY)")
        {
            Visible = false;
        }
        addafter("Outstanding Invoices (LCY)")
        {
            field("POI Prepayment Total payed"; GetInvoicedPrepmtAmountLCY())
            {
                Caption = 'geleistete Vorkassen/Anzahlungen';
                ApplicationArea = all;
                ToolTip = ' ';
            }
        }
        addafter(TotalAmountLCY)
        {
            field(Gegenforderungen; "POI Gegenforderungen")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(TotalEntry; TotalSalesAmount)
            {
                Caption = 'Gesamtsaldo Verbindlichkeiten';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addlast(content)
        {
            field("POI Group Credit Limit"; "POI Group Credit Limit")
            {
                Caption = 'Kreditversicherungslimit Port Gruppe';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Credit Memo Total"; OpenCreditMemoAmount)
            {
                Caption = 'offene Reklamationen';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TotalAmountOpen := 0;
        TotalSalesAmount := 0;
        OpenCreditMemoAmount := 0;
        Vendor.Get("No.");
        if Vendor."POI Is Customer" <> '' then
            SalesshipmentLine.SetRange("Sell-to Customer No.", Vendor."POI Is Customer");
        SalesshipmentLine.SetRange("Quantity Invoiced", 0);
        SalesshipmentLine.SetFilter(Quantity, '>%1', 0);
        if SalesshipmentLine.FindSet() then
            repeat
                TotalAmountShip += (SalesshipmentLine.Quantity - SalesshipmentLine."Quantity Invoiced");
            until SalesshipmentLine.Next() = 0;
        CustomerLedgerEntry.SetRange("Customer No.", Vendor."POI Is Customer");
        CustomerLedgerEntry.SetRange(Open, true);
        if CustomerLedgerEntry.FindSet() then begin
            CustomerLedgerEntry.CalcSums("Remaining Amount");
            TotalAmountOpen := CustomerLedgerEntry."Remaining Amount";
            TotalSalesAmount := TotalAmountShip + TotalAmountOpen;
        end;
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::"Credit Memo");
        PurchaseLine.SetRange("Pay-to Vendor No.", "No.");
        PurchaseLine.SetFilter("Outstanding Amount (LCY)", '>%1', 0);
        PurchaseLine.CalcSums("Outstanding Amount (LCY)");
        OpenCreditMemoAmount := PurchaseLine."Outstanding Amount (LCY)";
    end;

    var
        Vendor: Record Vendor;
        SalesshipmentLine: Record "Sales Shipment Line";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        PurchaseLine: Record "Purchase Line";
        TotalAmountShip: Decimal;
        TotalAmountOpen: Decimal;
        TotalSalesAmount: Decimal;
        OpenCreditMemoAmount: Decimal;

}