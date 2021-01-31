codeunit 5087915 "POI Incoming Inv. Ledger Mgt"
{
    procedure CreateNewEntry()
    var
        lfm_IncomingInvLedgerCard: Page "POI Incoming Inv. Ledger Card";
        lco_No: Code[20];
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion zur Erstellung eines neuen Eintrages in das Rechnungseingangsbuch
        // --------------------------------------------------------------------------------------------

        // Manuelle Eingabe der Nummer

        Clear(lco_No);

        lrc_IncomingInvoiceLedger.RESET();
        lrc_IncomingInvoiceLedger.INIT();
        IF lco_No <> '' THEN
            lrc_IncomingInvoiceLedger."No." := lco_No
        ELSE
            lrc_IncomingInvoiceLedger."No." := '';
        lrc_IncomingInvoiceLedger.INSERT(TRUE);
        COMMIT();

        lrc_IncomingInvoiceLedger.FILTERGROUP(2);
        lrc_IncomingInvoiceLedger.SETRANGE("No.", lrc_IncomingInvoiceLedger."No.");
        lrc_IncomingInvoiceLedger.FILTERGROUP(0);

        lfm_IncomingInvLedgerCard.SETTABLEVIEW(lrc_IncomingInvoiceLedger);
        lfm_IncomingInvLedgerCard.RUNMODAL();
    end;

    procedure ShowEditEntry(vco_No: Code[20])
    var
        lfm_IncomingInvLedgerCard: Page "POI Incoming Inv. Ledger Card";
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion zur Bearbeitung eines Eintrages aus dem Rechnungseingangsbuch
        // --------------------------------------------------------------------------------------------

        IF vco_No = '' THEN
            EXIT;

        lrc_IncomingInvoiceLedger.FILTERGROUP(2);
        lrc_IncomingInvoiceLedger.SETRANGE("No.", vco_No);
        lrc_IncomingInvoiceLedger.FILTERGROUP(0);

        lfm_IncomingInvLedgerCard.SETTABLEVIEW(lrc_IncomingInvoiceLedger);
        lfm_IncomingInvLedgerCard.RUNMODAL();
    end;

    procedure LoadInInvDoc(var rrc_PurchaseHeader: Record "Purchase Header")
    var
        lrc_PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion um Eintrag Rechnungseingangsbuch in Einkaufsbeleg zu laden
        // --------------------------------------------------------------------------------------------

        lrc_PurchasesPayablesSetup.GET();
        CASE lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry" OF
            lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry"::" ":
                EXIT;
            lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry"::Activ:
                EXIT;
            lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry"::"Activ with Posting No.":
                IF rrc_PurchaseHeader."Posting No." <> '' THEN BEGIN

                    lrc_IncomingInvoiceLedger.GET(rrc_PurchaseHeader."Posting No.");

                    IF (rrc_PurchaseHeader."Document Type" = rrc_PurchaseHeader."Document Type"::Invoice) AND
                       (lrc_IncomingInvoiceLedger.Amount < 0) THEN
                        ERROR('Gutschrift kann nicht in Rechnung geladen werden!');
                    IF (rrc_PurchaseHeader."Document Type" = rrc_PurchaseHeader."Document Type"::"Credit Memo") AND
                       (lrc_IncomingInvoiceLedger.Amount > 0) THEN
                        ERROR('Rechnung kann nicht in Gutschrift geladen werden!');

                    IF lrc_IncomingInvoiceLedger."Purch. Doc. No." <> '' THEN
                        IF NOT CONFIRM('Eintrag wurde bereits in Beleg %1 geladen! Erneut laden?', FALSE,
                                       lrc_IncomingInvoiceLedger."Purch. Doc. No.") THEN
                            ERROR('');

                    rrc_PurchaseHeader.VALIDATE("Buy-from Vendor No.", lrc_IncomingInvoiceLedger."Vendor No.");
                    rrc_PurchaseHeader.VALIDATE("Posting Date", WORKDATE());
                    rrc_PurchaseHeader.VALIDATE("Document Date", lrc_IncomingInvoiceLedger."Vendor Invoice Posting Date");
                    rrc_PurchaseHeader.VALIDATE("Currency Code", lrc_IncomingInvoiceLedger."Currency Code");

                    IF lrc_IncomingInvoiceLedger."Document Type" = lrc_IncomingInvoiceLedger."Document Type"::"Credit Memo" THEN
                        rrc_PurchaseHeader.VALIDATE("Vendor Cr. Memo No.", lrc_IncomingInvoiceLedger."Vendor Invoice No.")
                    ELSE
                        rrc_PurchaseHeader.VALIDATE("Vendor Invoice No.", lrc_IncomingInvoiceLedger."Vendor Invoice No.");

                    rrc_PurchaseHeader.VALIDATE("POI Vendor Invoice Amount", lrc_IncomingInvoiceLedger.Amount);

                    rrc_PurchaseHeader."Responsibility Center" := lrc_IncomingInvoiceLedger."Transfer Responsibility Center";
                    rrc_PurchaseHeader."POI Person in Charge Code" := lrc_IncomingInvoiceLedger."Transfer Person in Charge";
                    rrc_PurchaseHeader."Purchaser Code" := lrc_IncomingInvoiceLedger."Purchaser Code";

                    rrc_PurchaseHeader."Posting Description" := COPYSTR(rrc_PurchaseHeader."Buy-from Vendor Name" + ' ' + rrc_PurchaseHeader."Buy-from Vendor Name 2", 1, 50);
                    rrc_PurchaseHeader.MODIFY(TRUE);
                    lrc_IncomingInvoiceLedger."Purch. Doc. Type" := rrc_PurchaseHeader."Document Type";
                    lrc_IncomingInvoiceLedger."Purch. Doc. No." := rrc_PurchaseHeader."No.";
                    lrc_IncomingInvoiceLedger."Purch. Doc. Date Time" := CURRENTDATETIME();
                    lrc_IncomingInvoiceLedger.MODIFY();
                END;

            ELSE
                EXIT;
        END;
    end;

    procedure CreateInvDocAndLoad()
    begin
    end;

    procedure CreateInvDoc(vco_No: Code[20]; vin_PurchDocType: Integer; vco_PurchDocNo: Code[20])
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion um Einkaufsrechnungsbeleg zu erstellen aus den Daten des Rechnungseingangsbuches
        // --------------------------------------------------------------------------------------------

        // Auswahl eines Eintrages
        IF vco_No = '' THEN BEGIN
            //  lrc_IncomingInvoiceLedger.SETRANGE(State,lrc_IncomingInvoiceLedger.State::"1"); Änderung RS wg Status falsch
            lrc_IncomingInvoiceLedger.SETRANGE(State, lrc_IncomingInvoiceLedger.State::Erfasst);
            lfm_IncomingInvLedgerList.LOOKUPMODE := TRUE;
            lfm_IncomingInvLedgerList.SETTABLEVIEW(lrc_IncomingInvoiceLedger);
            IF lfm_IncomingInvLedgerList.RUNMODAL() <> ACTION::LookupOK THEN
                EXIT;
            lrc_IncomingInvoiceLedger.RESET();
            lfm_IncomingInvLedgerList.GETRECORD(lrc_IncomingInvoiceLedger);
            vco_No := lrc_IncomingInvoiceLedger."No.";
        END;

        lrc_IncomingInvoiceLedger.GET(vco_No);
        lrc_IncomingInvoiceLedger.TESTFIELD("Vendor No.");

        IF (lrc_IncomingInvoiceLedger."Purch. Doc. No." <> '') AND
           (lrc_IncomingInvoiceLedger."Purch. Doc. No." <> vco_PurchDocNo) THEN
            IF NOT CONFIRM('Eintrag Rechnungseingangsbuch wurde bereits in den Beleg %1 geladen! Erneut laden', FALSE,
                           lrc_IncomingInvoiceLedger."Purch. Doc. No.") THEN
                ERROR('');

        //
        lrc_PurchaseHeader.RESET();
        lrc_PurchaseHeader.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type"::Order);
        lrc_PurchaseHeader.SETRANGE("Vendor Invoice No.", lrc_IncomingInvoiceLedger."Vendor Invoice No.");

        // Einkaufsbeleg lesen oder anlegen
        IF vco_PurchDocNo <> '' THEN BEGIN
            lrc_PurchaseHeader.RESET();
            lrc_PurchaseHeader.SETRANGE("Document Type", vin_PurchDocType);
            lrc_PurchaseHeader.SETRANGE("No.", vco_PurchDocNo);
            lrc_PurchaseHeader.FINDFIRST();
        END ELSE BEGIN
            lrc_PurchaseHeader.RESET();
            lrc_PurchaseHeader.INIT();
            lrc_PurchaseHeader."Document Type" := lrc_PurchaseHeader."Document Type"::Order;
            lrc_PurchaseHeader."No." := '';
            lrc_PurchaseHeader."POI Purch. Doc. Subtype Code" := '';
            lrc_PurchaseHeader.INSERT(TRUE);
        END;

        lrc_IncomingInvoiceLedger."Purch. Doc. Type" := lrc_PurchaseHeader."Document Type";
        lrc_IncomingInvoiceLedger."Purch. Doc. No." := lrc_PurchaseHeader."No.";

        lrc_PurchaseHeader.VALIDATE("Buy-from Vendor No.", lrc_IncomingInvoiceLedger."Vendor No.");
        lrc_PurchaseHeader.VALIDATE("Posting Date", WORKDATE());
        lrc_PurchaseHeader.VALIDATE("Currency Code", lrc_IncomingInvoiceLedger."Currency Code");
        lrc_PurchaseHeader.VALIDATE("Document Date", lrc_IncomingInvoiceLedger."Vendor Invoice Posting Date");


        // lrc_PurchaseHeader.VALIDATE("Vendor Invoice No.",lrc_IncomingInvoiceLedger."Vendor Invoice No.");
        IF lrc_IncomingInvoiceLedger."Document Type" = lrc_IncomingInvoiceLedger."Document Type"::"Credit Memo" THEN
            lrc_PurchaseHeader.VALIDATE("Vendor Cr. Memo No.", lrc_IncomingInvoiceLedger."Vendor Invoice No.")
        ELSE
            lrc_PurchaseHeader.VALIDATE("Vendor Invoice No.", lrc_IncomingInvoiceLedger."Vendor Invoice No.");



        lrc_PurchaseHeader.VALIDATE("POI Vendor Invoice Amount", lrc_IncomingInvoiceLedger.Amount);

        lrc_PurchaseHeader."Posting Description" := COPYSTR(lrc_PurchaseHeader."Buy-from Vendor Name" + ' ' +
                                                            lrc_PurchaseHeader."Buy-from Vendor Name 2", 1, 50);

        lrc_PurchaseHeader.MODIFY(TRUE);
    end;

    procedure ShowInvDoc(vco_No: Code[20])
    var
        lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion zur Anzeige des Einkaufsrechnungsbeleges über das Rechnungseingangsbuch
        // --------------------------------------------------------------------------------------------

        lrc_IncomingInvoiceLedger.GET(vco_No);
        lrc_IncomingInvoiceLedger.TESTFIELD("Purch. Doc. No.");

        lrc_PurchaseHeader.RESET();
        lrc_PurchaseHeader.FILTERGROUP(2);
        lrc_PurchaseHeader.SETRANGE("Document Type", lrc_IncomingInvoiceLedger."Purch. Doc. Type");
        lrc_PurchaseHeader.SETRANGE("No.", lrc_IncomingInvoiceLedger."Purch. Doc. No.");
        lrc_PurchaseHeader.FILTERGROUP(0);

        lrc_PurchDocSubtype.RESET();
        lrc_PurchDocSubtype.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
        lrc_PurchDocSubtype.SETRANGE(Code, lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
        lrc_PurchDocSubtype.FINDFIRST();

        lrc_PurchDocSubtype.TESTFIELD("Page ID Card");

        Page.RUNMODAL(lrc_PurchDocSubtype."Page ID Card", lrc_PurchaseHeader);
    end;

    procedure SetEntryToPosted(vin_PurchDocType: Integer; vco_PurchDocNo: Code[20]; vco_PurchPostedDocNo: Code[20])
    var
        lrc_PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion Eintrag Rechnungseingangsbuch auf gebucht setzen
        // --------------------------------------------------------------------------------------------

        lrc_PurchasesPayablesSetup.GET();
        IF lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry" =
           lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry"::" " THEN
            EXIT;

        lrc_IncomingInvoiceLedger.RESET();
        lrc_IncomingInvoiceLedger.SETRANGE("Purch. Doc. Type", vin_PurchDocType);
        lrc_IncomingInvoiceLedger.SETRANGE("Purch. Doc. No.", vco_PurchDocNo);
        IF lrc_IncomingInvoiceLedger.FINDFIRST() THEN BEGIN
            lrc_IncomingInvoiceLedger."Purch. Posted Doc. No." := vco_PurchPostedDocNo;
            lrc_IncomingInvoiceLedger.State := lrc_IncomingInvoiceLedger.State::Gebucht;
            lrc_IncomingInvoiceLedger."Last State Change by" := copystr(USERID(), 1, 50);
            lrc_IncomingInvoiceLedger."Last State Change Date" := TODAY();
            lrc_IncomingInvoiceLedger."Last State Change Time" := TIME();
            lrc_IncomingInvoiceLedger.MODIFY();
        END;
    end;

    procedure PostingNo_LookUp(var rco_No: Code[20]; vrc_PurchaseHeader: Record "Purchase Header"): Boolean
    var
        lrc_PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        // --------------------------------------------------------------------------------------------
        // Funktion LookUp zur Auswahl einer Freigegebenen Rechnungseingangszeile aus der Buchungsnr.
        // --------------------------------------------------------------------------------------------

        lrc_PurchasesPayablesSetup.GET();
        IF lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry" <>
           lrc_PurchasesPayablesSetup."POI Inv. Ledger Entry"::"Activ with Posting No." THEN
            EXIT(FALSE);

        lrc_IncomingInvoiceLedger.FILTERGROUP(2);
        lrc_IncomingInvoiceLedger.SETRANGE(State, lrc_IncomingInvoiceLedger.State::Freigegeben);
        IF vrc_PurchaseHeader."Document Type" = vrc_PurchaseHeader."Document Type"::Invoice THEN
            lrc_IncomingInvoiceLedger.SETFILTER(Amount, '>%1', 0)
        ELSE
            lrc_IncomingInvoiceLedger.SETFILTER(Amount, '<%1', 0);
        lrc_IncomingInvoiceLedger.FILTERGROUP(0);
        lrc_IncomingInvoiceLedger.SETRANGE("Purch. Doc. No.", '');

        lfm_IncomingInvLedgerList.LOOKUPMODE := TRUE;
        lfm_IncomingInvLedgerList.SETTABLEVIEW(lrc_IncomingInvoiceLedger);
        IF lfm_IncomingInvLedgerList.RUNMODAL() <> ACTION::LookupOK THEN
            EXIT(FALSE);
        lrc_IncomingInvoiceLedger.RESET();
        lfm_IncomingInvLedgerList.GETRECORD(lrc_IncomingInvoiceLedger);
        rco_No := lrc_IncomingInvoiceLedger."No.";

        EXIT(TRUE);
    end;

    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_IncomingInvoiceLedger: Record "POI Incoming Invoice Ledger";
        lfm_IncomingInvLedgerList: Page "POI Incoming Inv. Ledger List";
}

