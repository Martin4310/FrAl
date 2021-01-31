pageextension 50028 "POI Cust. Statistik Ext" extends "Customer Statistics FactBox"
{
    layout
    {
        moveafter("Outstanding Invoices (LCY)"; GetInvoicedPrepmtAmountLCY)
        modify(Service)
        {
            Visible = false;
        }
        modify("Payments (LCY)")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Sales (LCY)")
        {
            Visible = false;
        }
        addafter(GetInvoicedPrepmtAmountLCY)
        {
            field(POIOpenCreditMemoAmount; OpenCreditMemoAmount)
            {
                Caption = 'offene Reklamationen';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter(POIOpenCreditMemoAmount; "Total (LCY)")
        addafter("Total (LCY)")
        {
            field(POICrossClaim; CrossClaim)
            {
                Caption = 'Gegenforderungen';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(POIShippedNotInvoicedVendor; ShippedNotInvoicedVendor)
            {
                Caption = 'nicht fakt. EK Bestellungen';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(POIOpenCreditMemoVendorAmount; OpenCreditMemoVendorAmount)
            {
                Caption = 'offene EK Reklamationen';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(POITotalReceivablesAmount; TotalReceivablesAmount)
            {
                Caption = 'Gesamtsaldo Forderungen';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(POIPayablesPerDate; PayablesPerDate)
            {
                Caption = 'fällige Beträge';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter(POIPayablesPerDate; LastPaymentReceiptDate)
        moveafter(LastPaymentReceiptDate; "Credit Limit (LCY)")
        addafter("Credit Limit (LCY)")
        {
            field(POIUsedCreditLimit; UsedCreditLimit)
            {
                Caption = 'Inanspruchnahme Kreditlimit';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(POIInsuranceCreditLimitGroup; InsuranceCreditLimitGroup)
            {
                Caption = 'Kreditvers.lim. Portgruppe';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field(POIUsedInsuranceCreditLimitGroup; UsedInsuranceCreditLimitGroup)
            {
                Caption = 'Inanspruchnahme Kreditvers. lim. Portgruppe';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        modify(Payments)
        {
            CaptionML = DEU = ' ';
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesLine: Record "Sales Line";
        CustomerLedger: Record "Cust. Ledger Entry";
        Vendor: Record Vendor;
        POIFunction: Codeunit POIFunction;

    begin
        if "POI Is Vendor" <> '' then
            if Vendor.Get("POI Is Vendor") then begin
                Vendor.CalcFields("Outstanding Invoices (LCY)", "Outstanding Orders (LCY)", "Purchases (LCY)", "Balance (LCY)", "Amt. Rcd. Not Invoiced (LCY)");
                ShippedNotInvoicedVendor := Vendor."Amt. Rcd. Not Invoiced (LCY)";
                TotalReceivablesAmount := Vendor."Balance (LCY)";
            end;


        //OpenCreditMemoAmount-
        SalesLine.SetRange("Sell-to Customer No.", "No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::"Credit Memo");
        SalesLine.SetRange("Qty. Shipped Not Invd. (Base)");
        SalesLine.SetFilter("Quantity (Base)", '<>%1', 0);
        SalesLine.CalcSums("Quantity (Base)");
        OpenCreditMemoAmount := SalesLine."Quantity (Base)";
        //OpenCreditMemoAmount+

        //CrossClaim-
        //Verkäufe - Reklamationen + Einkäufe - EK-Reklamationen 
        CrossClaim := 1; //TODO: Gegenforderungen berechnen
                         //CrossClaim+

        //PayablesPerDate-
        CustomerLedger.SetRange("Customer No.", "No.");
        CustomerLedger.SetFilter("Remaining Amt. (LCY)", '<>%1', 0);
        CustomerLedger.SetFilter("Due Date", '<=%1', Today());
        CustomerLedger.CalcSums("Remaining Amt. (LCY)");
        PayablesPerDate := CustomerLedger."Remaining Amt. (LCY)";
        //PayablesPerDate+
        //UsedCreditLimit-
        UsedCreditLimit := 4; //TODO: Inanspruchnahme Kreditlimit berechnen
        //UsedCreditLimit+
        //InsuranceCreditLimitGroup-
        InsuranceCreditLimitGroup := POIFunction.GetGroupLimit("POI Easy No.", 0);
        //InsuranceCreditLimitGroup+
        //UsedInsuranceCreditLimitGroup-
        UsedInsuranceCreditLimitGroup := 6; //TODO: Inanspruchnahme Geruppenkreditlimit berechnen
        //UsedInsuranceCreditLimitGroup+
    end;

    var
        OpenCreditMemoAmount: Decimal;
        CrossClaim: Decimal;
        ShippedNotInvoicedVendor: Decimal;
        OpenCreditMemoVendorAmount: Decimal;
        TotalReceivablesAmount: Decimal;
        PayablesPerDate: Decimal;
        UsedCreditLimit: Decimal;
        InsuranceCreditLimitGroup: Decimal;
        UsedInsuranceCreditLimitGroup: Decimal;
}