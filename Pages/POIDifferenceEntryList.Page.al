page 50044 "POI Difference Entry List"
{
    Caption = 'Difference Entry List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "POI Difference Entry";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(AmountLCY; AmountLCY)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(AppliesToID; AppliesToID)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(ClosedFrom; ClosedFrom)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(ClosedFromEntryNo; ClosedFromEntryNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(ClosedOn; ClosedOn)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(CurrencyCode; CurrencyCode)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(CurrencyFactor; CurrencyFactor)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(CustomerVendorLedgerNo; CustomerVendorLedgerNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(CustomerVendorName; CustomerVendorName)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(CustomerVendorNo; CustomerVendorNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(DifferenceDescription; DifferenceDescription)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(DifferenceReason; DifferenceReason)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(DocumentDate; DocumentDate)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(DocumentNo; DocumentNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(EntryNo; EntryNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(MasterBatchNo; MasterBatchNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(OriginnalInvoiceAmount; OriginnalInvoiceAmount)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(OriginnalInvoiceAmountLCY; OriginnalInvoiceAmountLCY)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(PostedInvoiceAmount; PostedInvoiceAmount)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(PostedInvoiceAmountLCY; PostedInvoiceAmountLCY)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(PostingDate; PostingDate)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(RemainingAmount; RemainingAmount)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(RemainingAmountLCY; RemainingAmountLCY)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Source; Source)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(externalDocumentNo; externalDocumentNo)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(open; open)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(positive; positive)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    procedure GetDiffLedgEntry(DifferenceEntry: Record "POI Difference Entry")
    begin
        DifferenceEntry := Rec;
    end;
}