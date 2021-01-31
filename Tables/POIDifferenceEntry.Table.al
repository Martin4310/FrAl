table 50011 "POI Difference Entry"
{
    // DrillDownPageID = Page50044;
    // LookupPageID = Form50044;

    fields
    {
        field(50000; EntryNo; Integer)
        {
            Caption = 'lfd. Nummer';
            Editable = false;
        }
        field(50001; Source; Option)
        {
            Caption = 'Herkunft';
            Editable = false;
            OptionCaption = 'Debitor,Kreditor';
            OptionMembers = Customer,Vendor;
        }
        field(50002; DocumentNo; Code[10])
        {
            Caption = 'Belegnummer';
            Editable = false;
        }
        field(50003; externalDocumentNo; Code[20])
        {
            Caption = 'externe Belegnummer';
            Editable = false;
        }
        field(50004; CustomerVendorNo; Code[20])
        {
            Caption = 'Debitoren- Kreditorennummer';
            Editable = false;
            TableRelation = IF (Source = FILTER(Vendor)) Vendor."No." WHERE("No." = FIELD(CustomerVendorNo))
            ELSE
            IF (Source = CONST(Customer)) Customer."No." WHERE("No." = FIELD(CustomerVendorNo));
        }
        field(50005; CustomerVendorName; Text[50])
        {
            Caption = 'Debitoren- Kreditorenname';
            Editable = false;
        }
        field(50006; PostingDate; Date)
        {
            Caption = 'Buchungsdatum';
            Editable = false;
        }
        field(50007; DocumentDate; Date)
        {
            Caption = 'Belegdatum';
            Editable = false;
        }
        field(50008; DifferenceReason; Option)
        {
            Caption = 'Differenzgrund';
            Editable = false;
            OptionMembers = " ","falsche Firmierung","fehlende oder falsche UST-ID Lieferant","fehlende oder falsche USt-ID Port","fehlende o. falsche Steuertexte",Preisdifferenz,"Kosten nicht abgezogen",Mengendifferenz,"fehlende Rabatte","Auflösung","Teilauflösung";
        }
        field(50009; DifferenceDescription; Text[100])
        {
            Caption = 'Differenzbeschreibung';
            Editable = false;
        }
        field(50010; CurrencyCode; Code[10])
        {
            Caption = 'Währungscode';
            Editable = false;
        }
        field(50011; CurrencyFactor; Decimal)
        {
            Caption = 'Währungsfaktor';
            Editable = false;
        }
        field(50012; Amount; Decimal)
        {
            Caption = 'Betrag';
            Editable = false;
        }
        field(50013; AmountLCY; Decimal)
        {
            Caption = 'Betrag (MW)';
            Editable = false;
        }
        field(50014; RemainingAmount; Decimal)
        {
            Caption = 'Restbetrag';
            Editable = false;
        }
        field(50015; RemainingAmountLCY; Decimal)
        {
            Caption = 'Restbetrag (MW)';
            Editable = false;
        }
        field(50016; ClosedOn; Date)
        {
            Caption = 'geschlossen am';
            Editable = false;
        }
        field(50017; ClosedFromEntryNo; Integer)
        {
            Caption = 'geschlossen von Nr.';
            Editable = false;
        }
        field(50018; open; Boolean)
        {
            Caption = 'offen';
            Editable = false;
        }
        field(50019; MasterBatchNo; Code[20])
        {
            Caption = 'Partienummer';
            Editable = false;
            TableRelation = "POI Master Batch"."No." WHERE("No." = FIELD(MasterBatchNo));
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;
        }
        field(50020; ClosedFrom; Code[20])
        {
            Caption = 'geschlossen von';
            Editable = false;
        }
        field(50023; CustomerVendorLedgerNo; Integer)
        {
            Caption = 'Debitoren- Kreditorenpostennummer';
            Editable = false;
            TableRelation = IF (Source = CONST(Vendor)) "Vendor Ledger Entry"."Entry No." WHERE("Entry No." = FIELD(CustomerVendorLedgerNo),
                                                                                               "Vendor No." = FIELD(CustomerVendorNo))
            ELSE
            IF (Source = CONST(Customer)) "Cust. Ledger Entry"."Entry No." WHERE("Entry No." = FIELD(CustomerVendorLedgerNo),
                                                                                                                                                                        "Customer No." = FIELD(CustomerVendorNo));
        }
        field(50024; AppliesToID; Code[20])
        {
            Caption = 'Ausgleichs ID';

            trigger OnValidate()

            begin
                IF ((xRec.AppliesToID <> '') AND (Rec.AppliesToID = '')) THEn
                    IF Source = Source::Vendor THEN BEGIN
                        PurchHeader.SETRANGE("Buy-from Vendor No.", CustomerVendorNo);
                        PurchHeader.SETRANGE("No.", xRec.AppliesToID);
                        IF PurchHeader.FINDSET(TRUE, FALSE) THEN
                            PurchHeader."POI Applies to Difference" := '';
                        PurchHeader.MODIFY();
                    END;
            end;
        }
        field(50025; positive; Boolean)
        {
            Editable = false;
        }
        field(50050; OriginnalInvoiceAmount; Decimal)
        {
            Caption = 'Original Rechnungsbetrag';
            Editable = false;
        }
        field(50051; OriginnalInvoiceAmountLCY; Decimal)
        {
            Caption = 'Original Rechnungsbetrag (MW)';
            Editable = false;
        }
        field(50052; PostedInvoiceAmount; Decimal)
        {
            Caption = 'gebuchter Rechnungsbetrag';
            Editable = false;
        }
        field(50053; PostedInvoiceAmountLCY; Decimal)
        {
            Caption = 'gebuchter Rechnungsbetrag (MW)';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; EntryNo)
        {
        }
        key(Key2; CustomerVendorNo, Source)
        {
            SumIndexFields = RemainingAmountLCY;
        }
        key(Key3; Source, CustomerVendorNo, AppliesToID)
        {
        }
    }
    var
        PurchHeader: Record "Purchase Header";
}

