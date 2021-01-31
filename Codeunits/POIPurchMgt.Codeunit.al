codeunit 5110323 "POI Purch. Mgt"
{

    // Permissions = TableData 32=rm,
    //               TableData 120=rm,
    //               TableData 121=rm;

    var
        gin_LineNo: Integer;

    procedure PurchShowOrder(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vbn_ShowWhseCard: Boolean)
    var
        lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
        lrc_PurchHdr: Record "Purchase Header";
        //lcu_GlobalVariablesMgt: Codeunit "POI Global Variables Mgt.";
        lcu_ReleasePurchaseDocument: Codeunit "Release Purchase Document";
    begin
        // -----------------------------------------------------------------------------------------------
        // Funktion zum öffnen einer Bestellung aus der Übersicht
        // -----------------------------------------------------------------------------------------------

        lrc_PurchHdr.GET(vop_DocType, vco_DocNo);
        lrc_PurchDocSubtype.GET(lrc_PurchHdr."Document Type", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
        lrc_PurchDocSubtype.TESTFIELD("Page ID Card");

        // Status auf offen setzen
        IF lrc_PurchDocSubtype."Set Status to Open" = TRUE THEN
            IF lrc_PurchHdr.Status = lrc_PurchHdr.Status::Released THEn
                lcu_ReleasePurchaseDocument.Reopen(lrc_PurchHdr);

        IF lrc_PurchDocSubtype."Allow scrolling in Card" = FALSE THEN BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("No.", lrc_PurchHdr."No.");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END ELSE BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END;

        //lcu_GlobalVariablesMgt.SetDirectCall(TRUE); //TODO: global var

        IF vbn_ShowWhseCard = TRUE THEN
            Page.RUN(lrc_PurchDocSubtype."Form ID Card in Whse.", lrc_PurchHdr)
        ELSE
            Page.RUN(lrc_PurchDocSubtype."Page ID Card", lrc_PurchHdr);
    end;

    procedure PurchShowOrderArchive(var rrc_PurchaseHeaderArchive: Record "Purchase Header Archive")
    var
        lrc_PurchaseHeaderArchive: Record "Purchase Header Archive";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum öffnen eines Verkaufarchives aus der Übersicht
        // -----------------------------------------------------------------------------

        lrc_PurchaseHeaderArchive.GET(rrc_PurchaseHeaderArchive."Document Type",
                                      rrc_PurchaseHeaderArchive."No.",
                                      rrc_PurchaseHeaderArchive."Doc. No. Occurrence",
                                      rrc_PurchaseHeaderArchive."Version No.");
        lrc_PurchaseHeaderArchive.FILTERGROUP(2);
        lrc_PurchaseHeaderArchive.SETRANGE("Document Type", lrc_PurchaseHeaderArchive."Document Type");
        lrc_PurchaseHeaderArchive.SETRANGE("No.", lrc_PurchaseHeaderArchive."No.");
        lrc_PurchaseHeaderArchive.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchaseHeaderArchive."POI Purch. Doc. Subtype Code");
        lrc_PurchaseHeaderArchive.FILTERGROUP(0);

        CASE lrc_PurchaseHeaderArchive."Document Type" OF
            // lrc_PurchaseHeaderArchive."Document Type"::Order: //TODO: Page
            //     Page.RUN(Page::"Customs Clearance List", lrc_PurchaseHeaderArchive);
            lrc_PurchaseHeaderArchive."Document Type"::Quote:
                Page.RUN(Page::"Purchase Quote Archive", lrc_PurchaseHeaderArchive);
            lrc_PurchaseHeaderArchive."Document Type"::"Blanket Order":
                Page.RUN(Page::"Blanket Purchase Order Archive", lrc_PurchaseHeaderArchive);
        END;
    end;

    procedure PurchNewOrder(vop_PurchDocType: Option "0","1","2","3","4","5","6","7","8","9"; vco_PurchDocSubType: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        AGILES_TEXT001Txt: Label 'Neuanlage nur über Belegart zulässig!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Anlegen einer Bestellung aus der Übersicht
        // -----------------------------------------------------------------------------

        IF vco_PurchDocSubType = '' THEN
            // Neuanlage nur über Belegart zulässig!
            ERROR(AGILES_TEXT001Txt);

        // Belegart lesen
        lrc_PurchDocType.GET(vop_PurchDocType, vco_PurchDocSubType);

        lrc_PurchHdr.RESET();
        lrc_PurchHdr.INIT();
        lrc_PurchHdr."Document Type" := vop_PurchDocType;
        lrc_PurchHdr."No." := '';
        lrc_PurchHdr."POI Purch. Doc. Subtype Code" := vco_PurchDocSubType;

        // Kopfsatz einfügen
        lrc_PurchHdr.INSERT(TRUE);

        // Eink. von Kreditor aus Belegunterart setzen
        IF lrc_PurchDocType."Default Vendor" <> '' THEN
            lrc_PurchHdr.VALIDATE("Buy-from Vendor No.", lrc_PurchDocType."Default Vendor");
        // Standard Lagerort aus Belegart setzen
        IF lrc_PurchDocType."Default Location Code" <> '' THEN
            lrc_PurchHdr.VALIDATE("Location Code", lrc_PurchDocType."Default Location Code");

        // Qualitätskontrolleur aus Belegunterart setzen
        IF lrc_PurchDocType."Quality Control Vendor No." <> '' THEN
            lrc_PurchHdr.VALIDATE("POI Quality Control Vendor No.", lrc_PurchDocType."Quality Control Vendor No.");

        // Verzoller aus Belegunterart setzen
        IF lrc_PurchDocType."Clearing by Ship. Agent Code" <> '' THEN
            lrc_PurchHdr.VALIDATE("POI Clearing by Vendor No.", lrc_PurchDocType."Clearing by Ship. Agent Code");

        // Kopfsatz aktualisieren
        lrc_PurchHdr.MODIFY();

        // Neue Bestellung öffnen
        PurchShowOrder(lrc_PurchHdr."Document Type", lrc_PurchHdr."No.", FALSE);
    end;

    procedure PurchShowLineCard(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vin_LineNo: Integer)
    var
        lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Öffnen
        // -----------------------------------------------------------------------------

        lrc_PurchaseHeader.GET(vop_DocType, vco_DocNo);
        lrc_PurchDocSubtype.GET(lrc_PurchaseHeader."Document Type", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
        lrc_PurchDocSubtype.TESTFIELD("Form ID Line Card");

        IF vin_LineNo <> 0 THEN
            lrc_PurchaseLine.GET(lrc_PurchaseHeader."Document Type", lrc_PurchaseHeader."No.", vin_LineNo);

        lrc_PurchaseLine.FILTERGROUP(2);
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
        lrc_PurchaseLine.FILTERGROUP(0);

        Page.RUNMODAL(lrc_PurchDocSubtype."Form ID Line Card", lrc_PurchaseLine);
    end;

    procedure PurchSplittLine(vrc_PurchLine: Record "Purchase Line")
    var
        //lrc_PurchLineEIM: Record "Purchase Line";
        lrc_ADFTempI: Record "POI ADF Temp I";
        lcu_BatchMgt: Codeunit "POI BAM Batch Management";
        //lfm_PurchaseSplittLine: Form "5110336";
        lin_LineNo: Integer;
        AGILES_TEXT001Txt: Label 'Splitt only valid for item lines!';
        AGILES_TEXT002Txt: Label 'Outstanding Quantity has to bee larger than zero!';
        // lrc_DocumentDim: Record "357";
        // lrc_DocumentDim2: Record "357";
        PORT_Text001Txt: Label 'Die Zeile ist mit einer anderen Zeile verbunden. Bitte ändern Sie die zugrundeliegende Zeile.';
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zum Splitten einer Einkaufszeile
        // --------------------------------------------------------------------------------------

        IF (vrc_PurchLine.Type <> vrc_PurchLine.Type::Item) OR
           (vrc_PurchLine."No." = '') THEN
            // Splittung nur für Artikelzeilen möglich!
            ERROR(AGILES_TEXT001Txt);

        IF vrc_PurchLine."Outstanding Quantity" = 0 THEN
            // Restbestellungsmenge muss größer Null sein!
            ERROR(AGILES_TEXT002Txt);

        //kein Splitten von Leergutzeile
        IF vrc_PurchLine."Attached to Line No." <> 0 THEN
            ERROR(PORT_Text001Txt);

        lrc_ADFTempI.RESET();
        lrc_ADFTempI.SETRANGE("User ID", USERID());
        lrc_ADFTempI.SETRANGE("Entry Type", lrc_ADFTempI."Entry Type"::EZS);
        lrc_ADFTempI.DELETEALL();

        lrc_ADFTempI.RESET();
        lrc_ADFTempI.INIT();
        lrc_ADFTempI."User ID" := copystr(USERID(), 1, 20);
        lrc_ADFTempI."Entry Type" := lrc_ADFTempI."Entry Type"::EZS;
        lrc_ADFTempI."Entry No." := 0;
        lrc_ADFTempI."EZS Doc. No." := vrc_PurchLine."Document No.";
        lrc_ADFTempI."EZS Item No." := vrc_PurchLine."No.";
        lrc_ADFTempI."EZS Master Batch No." := vrc_PurchLine."POI Master Batch No.";
        lrc_ADFTempI."EZS Batch No." := vrc_PurchLine."POI Batch No.";
        lrc_ADFTempI."EZS Batch Variant No." := vrc_PurchLine."POI Batch Variant No.";
        lrc_ADFTempI."EZS Caliber Code" := vrc_PurchLine."POI Caliber Code";
        lrc_ADFTempI."EZS Location Code" := vrc_PurchLine."Location Code";
        lrc_ADFTempI."EZS Unit of Measure Code" := vrc_PurchLine."Unit of Measure Code";
        lrc_ADFTempI."EZS Quantity" := vrc_PurchLine.Quantity;
        lrc_ADFTempI."EZS Remaining Quantity" := vrc_PurchLine."Outstanding Quantity";
        lrc_ADFTempI."EZS Splitt Caliber Code" := vrc_PurchLine."POI Caliber Code";
        lrc_ADFTempI."EZS Splitt Quantity" := 0;
        lrc_ADFTempI."EZS Splitt Location Code" := vrc_PurchLine."Location Code";
        lrc_ADFTempI."EZS Info 1" := vrc_PurchLine."POI Info 1";
        lrc_ADFTempI."EZS Info 2" := vrc_PurchLine."POI Info 2";
        lrc_ADFTempI."EZS Info 3" := vrc_PurchLine."POI Info 3";
        lrc_ADFTempI."EZS Info 4" := vrc_PurchLine."POI Info 4";
        lrc_ADFTempI.INSERT();
        COMMIT();

        lrc_ADFTempI.FILTERGROUP(2);
        lrc_ADFTempI.SETRANGE("User ID", lrc_ADFTempI."User ID");
        lrc_ADFTempI.SETRANGE("Entry Type", lrc_ADFTempI."Entry Type");
        lrc_ADFTempI.SETRANGE("Entry No.", lrc_ADFTempI."Entry No.");
        lrc_ADFTempI.FILTERGROUP(0);

        // lfm_PurchaseSplittLine.LOOKUPMODE := TRUE; //TODO: page
        // lfm_PurchaseSplittLine.SETTABLEVIEW(lrc_ADFTempI);
        // IF lfm_PurchaseSplittLine.RUNMODAL <> ACTION::LookupOK THEN
        //     EXIT;

        // lrc_ADFTempI.RESET();
        // lfm_PurchaseSplittLine.GETRECORD(lrc_ADFTempI);
        // IF lrc_ADFTempI."EZS Splitt Quantity" <= 0 THEN
        //     EXIT;

        // nach oben verschoben, um Lagerbestand vor Schreibtransaktion zu prüfen
        // Menge Ursprungszeile ändern
        lrc_PurchLine.RESET();
        lrc_PurchLine.GET(vrc_PurchLine."Document Type", vrc_PurchLine."Document No.", vrc_PurchLine."Line No.");
        lrc_PurchLine.VALIDATE(Quantity, (lrc_PurchLine.Quantity - lrc_ADFTempI."EZS Splitt Quantity"));
        lrc_PurchLine.MODIFY();

        // Neue Zeilennummer berechnen unter Berücksichtung ob es zugehörige Zeilen gibt
        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchLine."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", vrc_PurchLine."Document No.");
        lrc_PurchLine.SETRANGE("Attached to Line No.", vrc_PurchLine."Line No.");
        IF NOT lrc_PurchLine.FINDLAST() THEN BEGIN
            lrc_PurchLine.RESET();
            lrc_PurchLine.SETRANGE("Document Type", vrc_PurchLine."Document Type");
            lrc_PurchLine.SETRANGE("Document No.", vrc_PurchLine."Document No.");
            lrc_PurchLine.SETFILTER("Line No.", '>%1', vrc_PurchLine."Line No.");
            IF lrc_PurchLine.FINDFIRST() THEN
                lin_LineNo := vrc_PurchLine."Line No." + ROUND(((lrc_PurchLine."Line No." - vrc_PurchLine."Line No.") / 2), 1)
            ELSE
                lin_LineNo := vrc_PurchLine."Line No." + 10000;
        END ELSE
            lin_LineNo := lrc_PurchLine."Line No." + 250;


        // Neue Zeile einfügen
        lrc_PurchLine.RESET();
        lrc_PurchLine.INIT();
        lrc_PurchLine.TRANSFERFIELDS(vrc_PurchLine);

        lrc_PurchLine."Document Type" := vrc_PurchLine."Document Type";
        lrc_PurchLine."Document No." := vrc_PurchLine."Document No.";
        lrc_PurchLine."Line No." := lin_LineNo;

        lrc_PurchLine.Quantity := 0;
        lrc_PurchLine."Quantity (Base)" := 0;
        lrc_PurchLine."Qty. to Invoice" := 0;
        lrc_PurchLine."Qty. to Invoice (Base)" := 0;
        lrc_PurchLine."Qty. to Receive" := 0;
        lrc_PurchLine."Qty. to Receive (Base)" := 0;
        lrc_PurchLine."Qty. Rcd. Not Invoiced" := 0;
        lrc_PurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
        lrc_PurchLine."Amt. Rcd. Not Invoiced" := 0;
        lrc_PurchLine."Quantity Received" := 0;
        lrc_PurchLine."Qty. Received (Base)" := 0;
        lrc_PurchLine."Quantity Invoiced" := 0;
        lrc_PurchLine."Qty. Invoiced (Base)" := 0;
        lrc_PurchLine."Receipt No." := '';
        lrc_PurchLine."Receipt Line No." := 0;
        lrc_PurchLine."Amt. Rcd. Not Invoiced (LCY)" := 0;
        lrc_PurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
        lrc_PurchLine."Qty. Received (Base)" := 0;
        lrc_PurchLine."Qty. Invoiced (Base)" := 0;
        lrc_PurchLine."Outstanding Quantity" := 0;
        lrc_PurchLine."Outstanding Qty. (Base)" := 0;
        lrc_PurchLine."POI Quantity (PU)" := 0;
        lrc_PurchLine."POI Quantity (TU)" := 0;
        lrc_PurchLine."POI Total Net Weight" := 0;
        lrc_PurchLine."POI Total Gross Weight" := 0;
        lrc_PurchLine."POI Batch Variant No." := '';
        lrc_PurchLine."POI Master Batch No." := '';
        lrc_PurchLine."POI Batch No." := '';
        lrc_PurchLine."POI Caliber Code" := lrc_ADFTempI."EZS Caliber Code";
        lrc_PurchLine."Sales Order No." := '';
        lrc_PurchLine."Sales Order Line No." := 0;

        //161124 rs neue EPS Zeile anlegen
        lrc_PurchLine."POI Empties Item No." := '';
        lrc_PurchLine."POI Empties Quantity" := 0;
        lrc_PurchLine."POI Empties Refund Amount" := 0;
        lrc_PurchLine."POI Empties Attached Line No" := 0;
        //161124 rs.e

        // Neue Positionsvariantennr. ermitteln
        lcu_BatchMgt.BatchVarNewFromPurchLine(lrc_PurchLine, TRUE, lrc_PurchLine."POI Batch No.", lrc_PurchLine."POI Batch Variant No.");
        // Partienummer bleibt erhalten
        lrc_PurchLine."POI Master Batch No." := vrc_PurchLine."POI Master Batch No.";
        lrc_PurchLine.INSERT();

        //RS 151214 Dimensionen kopieren
        // lrc_DocumentDim.SETRANGE("Table ID", 39); //TODO: dimension
        // lrc_DocumentDim.SETRANGE("Document Type", vrc_PurchLine."Document Type");
        // lrc_DocumentDim.SETRANGE("Document No.", vrc_PurchLine."Document No.");
        // lrc_DocumentDim.SETRANGE("Line No.", vrc_PurchLine."Line No.");
        // IF lrc_DocumentDim.FINDSET(FALSE, FALSE) THEN BEGIN
        //     REPEAT
        //         IF NOT lrc_DocumentDim2.GET(39, vrc_PurchLine."Document Type", vrc_PurchLine."Document No.", lin_LineNo,
        //                                     lrc_DocumentDim."Dimension Code") THEN BEGIN
        //             lrc_DocumentDim2.INIT();
        //             lrc_DocumentDim2."Table ID" := 39;
        //             lrc_DocumentDim2."Document Type" := vrc_PurchLine."Document Type";
        //             lrc_DocumentDim2."Document No." := vrc_PurchLine."Document No.";
        //             lrc_DocumentDim2."Line No." := lin_LineNo;
        //             lrc_DocumentDim2."Dimension Code" := lrc_DocumentDim."Dimension Code";
        //             lrc_DocumentDim2.INSERT();
        //             lrc_DocumentDim2.VALIDATE("Dimension Value Code", lrc_DocumentDim."Dimension Value Code");
        //             lrc_DocumentDim2.MODIFY();
        //         END;
        //     UNTIL lrc_DocumentDim.NEXT() = 0;
        //     //Position mit neuer Position belegen
        //     IF lrc_DocumentDim2.GET(39, vrc_PurchLine."Document Type", vrc_PurchLine."Document No.", lin_LineNo, 'POSITION') THEN BEGIN
        //         lrc_DocumentDim2.VALIDATE("Dimension Value Code", lrc_PurchLine."Batch No.");
        //         lrc_DocumentDim2.MODIFY();
        //     END;
        // END;
        //RS 151214.e

        lrc_PurchLine2.RESET();
        lrc_PurchLine2.GET(lrc_PurchLine."Document Type", lrc_PurchLine."Document No.", lrc_PurchLine."Line No.");
        lrc_PurchLine2.VALIDATE("Location Code", lrc_ADFTempI."EZS Splitt Location Code");
        lrc_PurchLine2.VALIDATE("POI Caliber Code", lrc_ADFTempI."EZS Splitt Caliber Code");
        lrc_PurchLine2.VALIDATE(Quantity, lrc_ADFTempI."EZS Splitt Quantity");
        lrc_PurchLine2.VALIDATE("POI Info 1", lrc_ADFTempI."EZS Info 1");
        lrc_PurchLine2.VALIDATE("POI Info 2", lrc_ADFTempI."EZS Info 2");
        lrc_PurchLine2.VALIDATE("POI Info 3", lrc_ADFTempI."EZS Info 3");
        lrc_PurchLine2.VALIDATE("POI Info 4", lrc_ADFTempI."EZS Info 4");
        //RS 151214
        lrc_PurchLine2.VALIDATE("POI Shortcut Dimension 3 Code", lrc_PurchLine."POI Batch No.");
        //161124 rs Anlage neue Leergutzeile
        lrc_PurchLine2.VALIDATE("POI Item Attribute 6");
        //161124 rs.e
        lrc_PurchLine2.MODIFY(TRUE);

        // nach oben verschoben, um Lagerbestand vor Schreibtransaktion zu prüfen
        // Menge Ursprungszeile ändern
        //lrc_PurchLine.RESET();
        //lrc_PurchLine.GET(vrc_PurchLine."Document Type",vrc_PurchLine."Document No.",vrc_PurchLine."Line No.");
        //lrc_PurchLine.VALIDATE(Quantity,(lrc_PurchLine.Quantity - lrc_ADFTempI."EZS Splitt Quantity"));
        //lrc_PurchLine.MODIFY();
        // 001 POI60020.E
    end;

    procedure PurchSplittMultiLine(vrc_PurchLine: Record "Purchase Line")
    var
        //lrc_PurchLine2: Record "Purchase Line";
        lrc_ADFTempI: Record "POI ADF Temp I";
        lcu_BatchMgt: Codeunit "POI BAM Batch Management";
        //lfm_PurchaseSplittLine: Form "5110393";
        //lin_LineNo: Integer;
        AGILES_TEXT001Txt: Label 'Splitt only valid for item lines!';
        AGILES_TEXT002Txt: Label 'Outstanding Quantity has to bee larger than zero!';
        i: Integer;
    begin
        // --------------------------------------------------------------------------------------
        // Funktion zum Splitten einer Einkaufszeile
        // --------------------------------------------------------------------------------------

        //*******************lt. DevTool keine Verwendung 161124 rs


        IF (vrc_PurchLine.Type <> vrc_PurchLine.Type::Item) OR
           (vrc_PurchLine."No." = '') THEN
            // Splittung nur für Artikelzeilen möglich!
            ERROR(AGILES_TEXT001Txt);

        IF vrc_PurchLine."Outstanding Quantity" = 0 THEN
            // Restbestellungsmenge muss größer Null sein!
            ERROR(AGILES_TEXT002Txt);

        lrc_ADFTempI.RESET();
        lrc_ADFTempI.SETRANGE("User ID", USERID());
        lrc_ADFTempI.SETRANGE("Entry Type", lrc_ADFTempI."Entry Type"::EZS);
        lrc_ADFTempI.DELETEALL();

        lrc_ADFTempI.RESET();
        lrc_ADFTempI.INIT();
        lrc_ADFTempI."User ID" := copystr(USERID(), 1, 20);
        lrc_ADFTempI."Entry Type" := lrc_ADFTempI."Entry Type"::EZS;
        lrc_ADFTempI."Entry No." := 0;
        lrc_ADFTempI."EZS Doc. No." := vrc_PurchLine."Document No.";
        lrc_ADFTempI."EZS Item No." := vrc_PurchLine."No.";
        lrc_ADFTempI."EZS Master Batch No." := vrc_PurchLine."POI Master Batch No.";
        lrc_ADFTempI."EZS Batch No." := vrc_PurchLine."POI Batch No.";
        lrc_ADFTempI."EZS Batch Variant No." := vrc_PurchLine."POI Batch Variant No.";
        lrc_ADFTempI."EZS Caliber Code" := vrc_PurchLine."POI Caliber Code";
        lrc_ADFTempI."EZS Location Code" := vrc_PurchLine."Location Code";
        lrc_ADFTempI."EZS Unit of Measure Code" := vrc_PurchLine."Unit of Measure Code";
        lrc_ADFTempI."EZS Quantity" := vrc_PurchLine.Quantity;
        lrc_ADFTempI."EZS Remaining Quantity" := vrc_PurchLine."Outstanding Quantity";
        lrc_ADFTempI."EZS Splitt Caliber Code" := vrc_PurchLine."POI Caliber Code";
        lrc_ADFTempI."EZS Splitt Quantity" := 0;
        lrc_ADFTempI."EZS Splitt Location Code" := vrc_PurchLine."Location Code";
        lrc_ADFTempI."EZS Info 1" := vrc_PurchLine."POI Info 1";
        lrc_ADFTempI."EZS Info 2" := vrc_PurchLine."POI Info 2";
        lrc_ADFTempI."EZS Info 3" := vrc_PurchLine."POI Info 3";
        lrc_ADFTempI."EZS Info 4" := vrc_PurchLine."POI Info 4";
        lrc_ADFTempI."EZS Splitt Blanket No." := vrc_PurchLine."Blanket Order No.";
        lrc_ADFTempI."EZS Splitt Blanket Line No." := vrc_PurchLine."Blanket Order Line No.";
        lrc_ADFTempI.INSERT();
        COMMIT();

        lrc_ADFTempI.FILTERGROUP(2);
        lrc_ADFTempI.SETRANGE("User ID", lrc_ADFTempI."User ID");
        lrc_ADFTempI.SETRANGE("Entry Type", lrc_ADFTempI."Entry Type");
        lrc_ADFTempI.SETRANGE("Entry No.", lrc_ADFTempI."Entry No.");
        lrc_ADFTempI.FILTERGROUP(0);

        // lfm_PurchaseSplittLine.LOOKUPMODE := TRUE; //TODO: page
        // lfm_PurchaseSplittLine.SETTABLEVIEW(lrc_ADFTempI);
        // IF lfm_PurchaseSplittLine.RUNMODAL() <> ACTION::LookupOK THEN
        //     EXIT;

        // lrc_ADFTempI.RESET();
        // lfm_PurchaseSplittLine.GETRECORD(lrc_ADFTempI);
        // IF lrc_ADFTempI."EZS Qty Lines" <= 0 THEN
        //     EXIT;

        gin_LineNo := vrc_PurchLine."Line No.";

        FOR i := 1 TO lrc_ADFTempI."EZS Qty Lines" DO BEGIN
            // Neue Zeile einfügen
            lrc_PurchLine.RESET();
            lrc_PurchLine.INIT();
            lrc_PurchLine.TRANSFERFIELDS(vrc_PurchLine, TRUE);

            lrc_PurchLine."Document Type" := vrc_PurchLine."Document Type";
            lrc_PurchLine."Document No." := vrc_PurchLine."Document No.";
            lrc_PurchLine."Line No." := gin_LineNo + 10000;

            lrc_PurchLine.Quantity := 0;
            lrc_PurchLine."Quantity (Base)" := 0;
            lrc_PurchLine."Qty. to Invoice" := 0;
            lrc_PurchLine."Qty. to Invoice (Base)" := 0;
            lrc_PurchLine."Qty. to Receive" := 0;
            lrc_PurchLine."Qty. to Receive (Base)" := 0;
            lrc_PurchLine."Qty. Rcd. Not Invoiced" := 0;
            lrc_PurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
            lrc_PurchLine."Amt. Rcd. Not Invoiced" := 0;
            lrc_PurchLine."Quantity Received" := 0;
            lrc_PurchLine."Qty. Received (Base)" := 0;
            lrc_PurchLine."Quantity Invoiced" := 0;
            lrc_PurchLine."Qty. Invoiced (Base)" := 0;
            lrc_PurchLine."Receipt No." := '';
            lrc_PurchLine."Receipt Line No." := 0;
            lrc_PurchLine."Amt. Rcd. Not Invoiced (LCY)" := 0;
            lrc_PurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
            lrc_PurchLine."Qty. Received (Base)" := 0;
            lrc_PurchLine."Qty. Invoiced (Base)" := 0;
            lrc_PurchLine."Outstanding Quantity" := 0;
            lrc_PurchLine."Outstanding Qty. (Base)" := 0;
            lrc_PurchLine."POI Quantity (PU)" := 0;
            lrc_PurchLine."POI Quantity (TU)" := 0;
            lrc_PurchLine."POI Total Net Weight" := 0;
            lrc_PurchLine."POI Total Gross Weight" := 0;
            lrc_PurchLine."POI Batch Variant No." := '';
            lrc_PurchLine."POI Master Batch No." := '';
            lrc_PurchLine."POI Batch No." := '';
            lrc_PurchLine."POI Caliber Code" := lrc_ADFTempI."EZS Caliber Code";
            lrc_PurchLine."Sales Order No." := '';
            lrc_PurchLine."Sales Order Line No." := 0;

            // Neue Positionsvariantennr. ermitteln
            lcu_BatchMgt.BatchVarNewFromPurchLine(lrc_PurchLine, TRUE, lrc_PurchLine."POI Batch No.", lrc_PurchLine."POI Batch Variant No.");
            // Partienummer bleibt erhalten
            lrc_PurchLine."POI Master Batch No." := vrc_PurchLine."POI Master Batch No.";
            lrc_PurchLine.VALIDATE("Blanket Order No.", lrc_ADFTempI."EZS Splitt Blanket No.");
            lrc_PurchLine.VALIDATE("Blanket Order Line No.", lrc_ADFTempI."EZS Splitt Blanket Line No.");
            lrc_PurchLine.VALIDATE("Location Code", lrc_ADFTempI."EZS Splitt Location Code");

            lrc_PurchLine.INSERT(TRUE);
            gin_LineNo := lrc_PurchLine."Line No." + 10000;
        END;
    end;

    procedure PurchAssistEditQty(vop_DocTyp: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vin_DocLineNo: Integer)
    var
    //lfm_PurchQuantities: Form "5110337";
    begin
        // ------------------------------------------------------------------------------------------
        // Funktion zur Erfassung der verschiedenen Mengen aus der Einkaufszeile über das Feld Menge
        // ------------------------------------------------------------------------------------------

        lrc_PurchLine.FILTERGROUP(2);
        lrc_PurchLine.SETRANGE("Document Type", vop_DocTyp);
        lrc_PurchLine.SETRANGE("Document No.", vco_DocNo);
        lrc_PurchLine.SETRANGE("Line No.", vin_DocLineNo);
        lrc_PurchLine.FILTERGROUP(0);

        // lfm_PurchQuantities.SETTABLEVIEW(lrc_PurchLine);
        // lfm_PurchQuantities.RUNMODAL();
    end;

    procedure PurchLineGetPriceUnit(vrc_PurchLine: Record "Purchase Line"): Code[10]
    var
        lrc_PriceCalculation: Record "POI Price Base";
        lrc_UnitofMeasure: Record "Unit of Measure";
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Ermittlung der Preiseinheit
        // ---------------------------------------------------------------------------------------
        // Achtung : entsprechend angepasste Funktion gibt es für Packerei auch in der CU 5110700,
        //           bei Änderungen beide Stellen pflegen
        // ---------------------------------------------------------------------------------------

        IF vrc_PurchLine.Type = vrc_PurchLine.Type::"Charge (Item)" THEN BEGIN
            IF vrc_PurchLine."POI Reference Item No." = '' THEN
                EXIT('');
        END ELSE BEGIN
            IF vrc_PurchLine.Type <> vrc_PurchLine.Type::Item THEN
                EXIT('');
            IF vrc_PurchLine."No." = '' THEN
                EXIT('');
        END;
        IF vrc_PurchLine."POI Price Base (Purch. Price)" = '' THEN
            EXIT('');
        IF vrc_PurchLine."Unit of Measure Code" = '' THEN
            EXIT('');

        lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price",
                                 vrc_PurchLine."POI Price Base (Purch. Price)");

        CASE lrc_PriceCalculation."Internal Calc. Type" OF
            lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
                BEGIN
                    vrc_PurchLine.TESTFIELD("POI Base Unit of Measure (BU)");
                    EXIT(vrc_PurchLine."POI Base Unit of Measure (BU)");
                END;

            lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
                ERROR('Preisbasis nicht zulässig!');

            lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":
                BEGIN
                    lrc_UnitofMeasure.GET(vrc_PurchLine."Unit of Measure Code");
                    IF lrc_UnitofMeasure."POI Packing Unit of Meas (PU)" <> '' THEN
                        EXIT(lrc_UnitofMeasure."POI Packing Unit of Meas (PU)")
                    ELSE
                        EXIT('');
                END;

            lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
                EXIT(vrc_PurchLine."Unit of Measure Code");

            lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
                BEGIN
                    vrc_PurchLine.TESTFIELD("POI Transport Unit of Meas(TU)");
                    vrc_PurchLine.TESTFIELD("POI Qty. (Unit) per Transp(TU)");
                    EXIT(vrc_PurchLine."POI Transport Unit of Meas(TU)");
                END;

            lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
                BEGIN
                    lrc_PriceCalculation.TESTFIELD("Price Unit Weighting");
                    EXIT(lrc_PriceCalculation."Price Unit Weighting");
                END;

            lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
                BEGIN
                    lrc_PriceCalculation.TESTFIELD("Price Unit Weighting");
                    EXIT(lrc_PriceCalculation."Price Unit Weighting");
                END;

            lrc_PriceCalculation."Internal Calc. Type"::"Total Price":
                EXIT('');
        END;
    end;

    procedure PurchCalcUnitPrice(vrc_PurchLine: Record "Purchase Line"; vbn_MarketUnitPrice: Boolean): Decimal
    var
        lrc_PriceCalculation: Record "POI Price Base";
        //lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_UnitofMeasure: Record "Unit of Measure";
        ldc_Preis: Decimal;
        //ldc_PreisProKollo: Decimal;
        //Text01Txt: Label 'Bitte geben Sie zuerst die Menge Kolli pro Palette ein!';
        Text02Txt: Label 'Bitte geben Sie zuerst die Menge Kolli ein!';
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Einkaufseinheiten Preises
        //
        // Achtung : entsprechend angepasste Funktion gibt es für Packerei auch in der CU 5110700,
        //           bei Änderungen beide Stellen pflegen
        // ---------------------------------------------------------------------------------------

        IF vbn_MarketUnitPrice = TRUE THEN BEGIN
            IF vrc_PurchLine.Type <> vrc_PurchLine.Type::Item THEN
                EXIT(vrc_PurchLine."POI Mark Unit Cost(Price Base)");
            IF vrc_PurchLine."No." = '' THEN
                EXIT(vrc_PurchLine."POI Mark Unit Cost(Price Base)");
            IF vrc_PurchLine."Unit of Measure Code" = '' THEN
                EXIT(vrc_PurchLine."POI Mark Unit Cost(Price Base)");
            IF vrc_PurchLine."POI Mark Unit Cost(Price Base)" = 0 THEN
                EXIT(vrc_PurchLine."POI Mark Unit Cost(Price Base)");
            IF vrc_PurchLine."POI Price Base (Purch. Price)" = '' THEN
                EXIT(vrc_PurchLine."POI Mark Unit Cost(Price Base)");
            ldc_Preis := vrc_PurchLine."POI Mark Unit Cost(Price Base)";
        END ELSE BEGIN
            IF vrc_PurchLine.Type = vrc_PurchLine.Type::"Charge (Item)" THEN BEGIN
                IF vrc_PurchLine."POI Reference Item No." = '' THEN
                    EXIT(vrc_PurchLine."POI Purch. Price (Price Base)");
            END ELSE BEGIN
                IF vrc_PurchLine.Type <> vrc_PurchLine.Type::Item THEN
                    EXIT(vrc_PurchLine."POI Purch. Price (Price Base)");
                IF vrc_PurchLine."No." = '' THEN
                    EXIT(vrc_PurchLine."POI Purch. Price (Price Base)");
            END;
            IF vrc_PurchLine."Unit of Measure Code" = '' THEN
                EXIT(vrc_PurchLine."POI Purch. Price (Price Base)");
            IF vrc_PurchLine."POI Purch. Price (Price Base)" = 0 THEN
                EXIT(vrc_PurchLine."POI Purch. Price (Price Base)");
            IF vrc_PurchLine."POI Price Base (Purch. Price)" = '' THEN
                EXIT(vrc_PurchLine."POI Purch. Price (Price Base)");
            ldc_Preis := vrc_PurchLine."POI Purch. Price (Price Base)";
        END;

        lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price",
                                 vrc_PurchLine."POI Price Base (Purch. Price)");

        CASE lrc_PriceCalculation."Internal Calc. Type" OF

            // ---------------------------------------------------------------------------------------------
            // Preiseingabe entspricht dem Preis für einen Kollo --> Umrechnung in Verkaufseinheit
            // KOLLO: Menge (Kollo) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
                BEGIN
                    //xx vrc_PurchLine.TESTFIELD("Price Unit of Measure");
                    lrc_UnitofMeasure.GET(vrc_PurchLine."Unit of Measure Code");
                    lrc_UnitofMeasure.TESTFIELD("POI Qty. (BU) per Unit of Meas");
                    ldc_Preis := ROUND(ldc_Preis /
                                      lrc_UnitofMeasure."POI Qty. (BU) per Unit of Meas" *
                                      vrc_PurchLine."Qty. per Unit of Measure", 0.00001);
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // VERPACKUNG: Menge (Kollo) * Menge (UE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":
                BEGIN
                    //xx vrc_PurchLine.TESTFIELD("Price Unit of Measure");
                    lrc_UnitofMeasure.GET(vrc_PurchLine."Unit of Measure Code");
                    lrc_UnitofMeasure.TESTFIELD("POI Pack Unit of Measure (PU)", vrc_PurchLine."POI Price Unit of Measure");
                    lrc_UnitofMeasure.TESTFIELD("POI Qty. (PU) per Unit of Meas");
                    ldc_Preis := ROUND(ldc_Preis *
                                       lrc_UnitofMeasure."POI Qty. (PU) per Unit of Meas", 0.00001);
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // INHALT: Menge (Kollo) * Menge (UE) * Menge (IE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
                ERROR('Preisberechnungsart nicht zulässig!');


            // ---------------------------------------------------------------------------------------------
            // BASIS: Menge (Kollo) * Menge (UE) * Menge (IE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
                BEGIN
                    vrc_PurchLine.TESTFIELD("POI Base Unit of Measure (BU)");
                    ldc_Preis := ldc_Preis * vrc_PurchLine."Qty. per Unit of Measure";
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // PALETTE: Menge (TE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
                BEGIN
                    ldc_Preis := vrc_PurchLine."POI Purch. Price (Price Base)";
                    IF vrc_PurchLine."POI Qty. (Unit) per Transp(TU)" <> 0 THEN BEGIN
                        ldc_Preis := ROUND(ldc_Preis / vrc_PurchLine."POI Qty. (Unit) per Transp(TU)", 0.00001);
                        EXIT(ldc_Preis);
                    END ELSE BEGIN
                        ldc_Preis := 0;
                        MESSAGE('Preis Null, da Menge pro Palette nicht vorhanden!');
                        EXIT(ldc_Preis);
                    END;
                END;

            // ---------------------------------------------------------------------------------------------
            // NETTO: Nettogewicht (gesamt) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
                BEGIN
                    ldc_Preis := ldc_Preis * vrc_PurchLine."Net Weight";
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // BRUTTO: Bruttogewicht (gesamt) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
                BEGIN
                    ldc_Preis := ldc_Preis * vrc_PurchLine."Gross Weight";
                    EXIT(ldc_Preis);
                END;

            // ---------------------------------------------------------------------------------------------
            // GESAMT: Gesamtpreis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Total Price":

                IF vrc_PurchLine.Quantity <> 0 THEN BEGIN
                    ldc_Preis := ldc_Preis / vrc_PurchLine.Quantity;
                    EXIT(ldc_Preis);
                END ELSE
                    // Bitte geben Sie zuerst die Menge ein!
                    ERROR(Text02Txt);

            // ---------------------------------------------------------------------------------------------
            // Ausnahmeregelung
            // ---------------------------------------------------------------------------------------------
            ELSE
                EXIT(ldc_Preis);

        END;
    end;

    procedure RequisitionCalcUnitPrice(vrc_ReqLine: Record "Requisition Line"; vbn_MarketUnitPrice: Boolean): Decimal
    var
        lrc_PriceCalculation: Record "POI Price Base";
        ldc_Price: Decimal;
        ldc_PreisProKollo: Decimal;
    //Text01Txt: Label 'Bitte geben Sie zuerst die Menge Kolli pro Palette ein!';
    //Text02Txt: Label 'Bitte geben Sie zuerst die Menge Kolli ein!';
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Berechnung des Einkaufseinheiten Preises
        // ---------------------------------------------------------------------------------------

        IF vbn_MarketUnitPrice = TRUE THEN BEGIN
            IF vrc_ReqLine.Type <> vrc_ReqLine.Type::Item THEN
                EXIT(vrc_ReqLine."POI Mark Unit Cost(Price Base)");
            IF vrc_ReqLine."No." = '' THEN
                EXIT(vrc_ReqLine."POI Mark Unit Cost(Price Base)");
            IF vrc_ReqLine."Unit of Measure Code" = '' THEN
                EXIT(vrc_ReqLine."POI Mark Unit Cost(Price Base)");
            IF vrc_ReqLine."POI Purch. Price (Price Base)" = 0 THEN
                EXIT(vrc_ReqLine."POI Mark Unit Cost(Price Base)");
            IF vrc_ReqLine."POI Price Base (Purch. Price)" = '' THEN
                EXIT(vrc_ReqLine."POI Mark Unit Cost(Price Base)");
            ldc_Price := vrc_ReqLine."POI Mark Unit Cost(Price Base)";
        END ELSE BEGIN
            IF vrc_ReqLine.Type <> vrc_ReqLine.Type::Item THEN
                EXIT(vrc_ReqLine."POI Purch. Price (Price Base)");
            IF vrc_ReqLine."No." = '' THEN
                EXIT(vrc_ReqLine."POI Purch. Price (Price Base)");
            IF vrc_ReqLine."Unit of Measure Code" = '' THEN
                EXIT(vrc_ReqLine."POI Purch. Price (Price Base)");
            IF vrc_ReqLine."POI Purch. Price (Price Base)" = 0 THEN
                EXIT(vrc_ReqLine."POI Purch. Price (Price Base)");
            IF vrc_ReqLine."POI Price Base (Purch. Price)" = '' THEN
                EXIT(vrc_ReqLine."POI Purch. Price (Price Base)");
            ldc_Price := vrc_ReqLine."POI Purch. Price (Price Base)";
        END;

        lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price",
                                 vrc_ReqLine."POI Price Base (Purch. Price)");

        CASE lrc_PriceCalculation."Internal Calc. Type" OF

            // ---------------------------------------------------------------------------------------------
            // BASIS:
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
                BEGIN
                    ldc_PreisProKollo := ldc_Price * vrc_ReqLine."Qty. per Unit of Measure";
                    EXIT(ldc_PreisProKollo);
                END;

            // ---------------------------------------------------------------------------------------------
            // KOLLO: Menge (Kollo) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
                EXIT(ldc_Price);

            // ---------------------------------------------------------------------------------------------
            // PALETTE: Menge (TE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
                ERROR('Einheit in Bestellvorschlag nicht zulässig!');
            // ---------------------------------------------------------------------------------------------
            // VERP: Menge (Kollo) * Menge (UE) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":
                BEGIN
                    //vrc_ReqLine.TESTFIELD("Qty. (PU) per Collo (CU)");
                    ldc_PreisProKollo := ldc_Price * vrc_ReqLine."POI Qty. (PU) per Unit of Meas";
                    EXIT(ldc_PreisProKollo);
                END;

            // ---------------------------------------------------------------------------------------------
            // INH: Menge (Kollo) * Menge (UE) * Menge Inhalt * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
                ERROR('Einheit in Bestellvorschlag nicht zulässig!');


            // ---------------------------------------------------------------------------------------------
            // NETTO: Nettogewicht (gesamt) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
                ERROR('Einheit in Bestellvorschlag nicht zulässig!');


            // ---------------------------------------------------------------------------------------------
            // BRUTTO: Bruttogewicht (gesamt) * Preis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
                ERROR('Einheit in Bestellvorschlag nicht zulässig!');

            // ---------------------------------------------------------------------------------------------
            // GESAMT: Gesamtpreis
            // ---------------------------------------------------------------------------------------------
            lrc_PriceCalculation."Internal Calc. Type"::"Total Price":
                ERROR('Einheit in Bestellvorschlag nicht zulässig!');

            ELSE
                EXIT(ldc_Price);
        END;
    end;

    procedure PurchCalcOrder(var vrc_PurchHeader: Record "Purchase Header")
    begin
        // ---------------------------------------------------------------------------------------------------
        // Funktion zur Gesamtkalkulation der Werte eines Einkaufsbeleges
        // ---------------------------------------------------------------------------------------------------
        //RS Funktion in die Bereiche Einkauf und VAT aufgeteilt

        PurchCalcOrderVAT(vrc_PurchHeader);
        PurchCalcOrderPurch(vrc_PurchHeader);
    end;

    procedure PurchCalcOrderPurch(var vrc_PurchHeader: Record "Purchase Header")
    var

        lrc_FruitVisionSetup: Record "POI ADF Setup";
        // lrc_PurchLine: Record "Purchase Line";
        // lrc_PurchaseEmpties: Record "POI Purchase Empties";
        // lcu_CostCalcMgt: Codeunit "POI Cost Calc. Management";
        lcu_DiscountMgt: Codeunit "POI Discount Management";
    // lcu_EmptiesManagement: Codeunit "POI EIM Empties Item Mgt";
    // lcu_BatchMgt: Codeunit "POI BAM Batch Management";
    // _CostCalcManagement: Codeunit "POI Cost Calc. Management";
    begin
        //Funktion zur Gesamtkalkulation des EK

        lrc_FruitVisionSetup.GET();

        // CASE lrc_FruitVisionSetup."Empties/Transport Type" OF //TODO: prüfen
        //     lrc_FruitVisionSetup."Empties/Transport Type"::"Systematik 1":
        //         BEGIN
        //             // Leergutzeilen erstellen
        //             //auskommentiert RS wg Funktionalität in Zeile
        //             //    lcu_EmptiesManagement.PurchAttachEmptiesToPurchLines(vrc_PurchHeader."Document Type",vrc_PurchHeader."No.", 0);
        //             // Transportmittelzeilen erstellen
        //             //xx    lcu_EmptiesManagement.PurchInsLineFromPurchTransport(vrc_PurchHeader);
        //         END;
        //     lrc_FruitVisionSetup."Empties/Transport Type"::"Systematik 2":
        //         BEGIN
        //             IF (vrc_PurchHeader."POI Purch. Doc. Subtype Code" <> '') AND
        //                ((vrc_PurchHeader."Document Type" = vrc_PurchHeader."Document Type"::Invoice) AND
        //                 (vrc_PurchHeader."POI Purch. Doc. Subtype Code" = lrc_FruitVisionSetup."POI PurchInv Empties Doc. Typ")) OR
        //                ((vrc_PurchHeader."Document Type" = vrc_PurchHeader."Document Type"::"Credit Memo") AND
        //                 (vrc_PurchHeader."POI Purch. Doc. Subtype Code" = lrc_FruitVisionSetup."POI PurchCrM Empties Doc. Typ")) THEN BEGIN
        //                 // Leergutzeilen erstellen
        //                 //xx      lcu_EmptiesManagement.PurchAttachEmptiesToPurchLines(vrc_PurchHeader."Document Type",vrc_PurchHeader."No.", 0);
        //                 // Transportmittelzeilen erstellen
        //                 //xx      lcu_EmptiesManagement.PurchInsLineFromPurchTransport(vrc_PurchHeader);
        //             END;
        //         END;
        // END;

        // Berechnung der Rabatte
        lcu_DiscountMgt.PurchDiscCalcLines(vrc_PurchHeader."Document Type", vrc_PurchHeader."No.");

        //RS Übernahme aus Agiles Objekt
        // Berechnung der Plankosten
        //IF vrc_PurchHeader."POI Master Batch No." <> '' THEN BEGIN
        //RS keine Neukalkulation Plankosten
        //lcu_CostCalcMgt.CreateStandardPlanCost(vrc_PurchHeader."POI Master Batch No.");
        //_CostCalcManagement._LoadCostCategories(3,'','',vrc_PurchHeader."POI Master Batch No.");
        //_CostCalcManagement.__MasterBatchCalcCost(vrc_PurchHeader."POI Master Batch No.",'');
        //END;

    end;

    procedure PurchCalcOrderVAT(var vrc_PurchHeader: Record "Purchase Header")
    var

        lrc_FruitVisionSetup: Record "POI ADF Setup";
        //lcu_DiscountMgt: Codeunit "POI Discount Management";
        lcu_SalesPurchVATEvaluationMgt: Codeunit "POI Sales/Purch VAT Eval Mgt";
    begin
        //Funktion zur Überprüfung der steuerlichen Werte

        lrc_FruitVisionSetup.GET();

        // Funktion zur Prüfung / Setzen der VAT beim Leergut
        lcu_SalesPurchVATEvaluationMgt.PurchaseCheckVATForEmptYItem(vrc_PurchHeader);

        // Kontrolle Steuerliche Situation
        // VAT 001 MFL40124.s
        // IF vrc_PurchHeader."Document Type" = vrc_PurchHeader."Document Type"::Order THEN BEGIN
        IF lrc_FruitVisionSetup."POI Purch. Find Bus. Post. Grp" = TRUE THEN
            lcu_SalesPurchVATEvaluationMgt.PurchCalcBusPosGrp(vrc_PurchHeader."Document Type", vrc_PurchHeader."No.");
        // END;
        // Neukalkulation Rabattwerte wg Kontierung
        //lcu_DiscountMgt.PurchDiscCalcLines(vrc_PurchHeader."Document Type",vrc_PurchHeader."No.");
    end;

    procedure LookupVendPurchHistory(var PurchHeader: Record "Purchase Header"; VendNo: Code[20])
    begin
        // ---------------------------------------------------------------------------------------------------
        // Anzeige der Historischen Daten in Bezug auf einen Kreditoren
        // ---------------------------------------------------------------------------------------------------

        ERROR('Fehler');

    end;

    procedure PurchChangeLocWithDuty(vrc_PurchHeader: Record "Purchase Header"; var rco_Location: Code[10]; var rco_ShippmentMethod: Code[10]): Boolean
    var
        lrc_ShipmentMethod: Record "Shipment Method";
        lrc_Location: Record Location;
        lfm_LocationList: Page "Location List";
        lfm_ShipmentMethods: Page "Shipment Methods";
    begin
        // ---------------------------------------------------------------------------------------------------------
        // Funktion zum Wechsel des Lagerortes mit Wechsel der Verzollung
        // ---------------------------------------------------------------------------------------------------------

        // Auswahl Lagerort
        lrc_Location.FILTERGROUP(2);
        lrc_Location.SETRANGE("Use As In-Transit", FALSE);
        lrc_Location.FILTERGROUP(0);
        lfm_LocationList.LOOKUPMODE := TRUE;
        lfm_LocationList.SETTABLEVIEW(lrc_Location);
        IF lfm_LocationList.RUNMODAL() <> ACTION::LookupOK THEN
            EXIT(FALSE);

        lrc_Location.RESET();
        lfm_LocationList.GETRECORD(lrc_Location);

        IF lrc_Location.Code = vrc_PurchHeader."Location Code" THEN
            EXIT(FALSE);

        rco_Location := lrc_Location.Code;

        rco_ShippmentMethod := vrc_PurchHeader."Shipment Method Code";
        IF lrc_Location."POI Status Customs Duty" <> lrc_Location."POI Status Customs Duty"::" " THEN
            IF vrc_PurchHeader."POI Status Customs Duty" <> lrc_Location."POI Status Customs Duty" THEN BEGIN

                IF NOT CONFIRM('Bitte wählen Sie eine Lieferbedingung mit dem richtigen Zollstatus aus!') THEN
                    EXIT(FALSE);

                lfm_ShipmentMethods.LOOKUPMODE := TRUE;
                lfm_ShipmentMethods.SETTABLEVIEW(lrc_ShipmentMethod);
                IF lfm_ShipmentMethods.RUNMODAL() <> ACTION::LookupOK THEN
                    EXIT(FALSE);

                lrc_ShipmentMethod.RESET();
                lfm_ShipmentMethods.GETRECORD(lrc_ShipmentMethod);

                IF not ((lrc_Location."POI Status Customs Duty" = lrc_Location."POI Status Customs Duty"::Payed) AND (lrc_ShipmentMethod."POI Duty Paid" = TRUE)) and
                   not ((lrc_Location."POI Status Customs Duty" = lrc_Location."POI Status Customs Duty"::"Not Payed") AND (lrc_ShipmentMethod."POI Duty Paid" = FALSE)) THEN
                    ERROR('Zollstatus Lagerort und Lieferbedingung passen nicht zusammen!');

                rco_ShippmentMethod := lrc_ShipmentMethod.Code;
            END;


        // Einkaufszeilen ändern
        lrc_PurchLine.RESET();
        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                IF lrc_PurchLine."Location Code" <> '' THEN BEGIN
                    lrc_PurchLine."Location Code" := lrc_Location.Code;
                    lrc_PurchLine."POI Status Customs Duty" := lrc_Location."POI Status Customs Duty";
                    lrc_PurchLine.MODIFY(TRUE);
                END;
            UNTIL lrc_PurchLine.NEXT() = 0;

        EXIT(TRUE);
    end;

    procedure PurchChangeCurrency(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_FVTempI: Record "POI ADF Temp I";
        //lfm_FHPurchaseCurrChange: Form "5110339";
        TEXT001Txt: Label 'Währungswechsel nicht möglich, da bereits fakturierte Mengen vorhanden sind!';
    //TEXT002Txt: Label 'Neue Währung entspricht der bereits aktuelle Währung!';
    begin
        // ---------------------------------------------------------------------------------------------------------
        // Funktion zum Wechsel der Währung
        // ---------------------------------------------------------------------------------------------------------

        lrc_PurchaseHeader.GET(vop_DocType, vco_DocNo);
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT
                IF lrc_PurchaseLine."Quantity Invoiced" <> 0 THEN
                    // Währungswechsel nicht möglich, da bereits fakturierte Mengen vorhanden sind!
                    ERROR(TEXT001Txt);
            UNTIL lrc_PurchaseLine.NEXT() = 0;

        lrc_FVTempI.RESET();
        lrc_FVTempI.SETRANGE("User ID", USERID());
        lrc_FVTempI.SETRANGE("Entry Type", lrc_FVTempI."Entry Type"::WW);
        IF lrc_FVTempI.FIND('-') THEN
            lrc_FVTempI.DELETEALL();

        lrc_FVTempI.RESET();
        lrc_FVTempI.INIT();
        lrc_FVTempI."User ID" := copystr(USERID(), 1, 20);
        lrc_FVTempI."Entry Type" := lrc_FVTempI."Entry Type"::WW;
        lrc_FVTempI."WW Aktuelle Währung" := lrc_PurchaseHeader."Currency Code";
        lrc_FVTempI."WW Neue Währung" := lrc_PurchaseHeader."Currency Code";
        lrc_FVTempI.INSERT();
        COMMIT();

        lrc_FVTempI.RESET();
        lrc_FVTempI.FILTERGROUP(2);
        lrc_FVTempI.SETRANGE("User ID", USERID());
        lrc_FVTempI.SETRANGE("Entry Type", lrc_FVTempI."Entry Type"::WW);
        lrc_FVTempI.FILTERGROUP(0);

        // lfm_FHPurchaseCurrChange.LOOKUPMODE := TRUE; //TODO: Page
        // lfm_FHPurchaseCurrChange.SETTABLEVIEW(lrc_FVTempI);
        // IF lfm_FHPurchaseCurrChange.RUNMODAL <> ACTION::LookupOK THEN
        //     EXIT;

        // lrc_FVTempI.RESET();
        // lfm_FHPurchaseCurrChange.GETRECORD(lrc_FVTempI);
        // IF lrc_FVTempI."WW Aktuelle Währung" = lrc_FVTempI."WW Neue Währung" THEN
        //     // Neue Währung entspricht der bereits aktuelle Währung!
        //     ERROR(TEXT002);

        // Einkaufskopfsatz ändern
        lrc_PurchaseHeader.VALIDATE("Currency Code", lrc_FVTempI."WW Neue Währung");
        lrc_PurchaseHeader.MODIFY(TRUE);

        // Lieferungen ändern




        // Einkaufszeilen ändern
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT
                lrc_PurchaseLine.VALIDATE("Currency Code", lrc_FVTempI."WW Neue Währung");
                lrc_PurchaseLine.VALIDATE("POI Purch. Price (Price Base)");
                lrc_PurchaseLine.MODIFY(TRUE);
            UNTIL lrc_PurchaseLine.NEXT() = 0;
    end;

    procedure ValidateMeansOfTransport(vrc_PurchHeader: Record "Purchase Header")
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Validieren Transportmittel
        // -----------------------------------------------------------------------------

        IF vrc_PurchHeader."POI Means of TransCode(Arriva)" = '' THEN
            EXIT;

        CASE vrc_PurchHeader."POI Means of Transport Type" OF
            vrc_PurchHeader."POI Means of Transport Type"::" ":
                EXIT;
            vrc_PurchHeader."POI Means of Transport Type"::Truck:
                BEGIN
                    lrc_MeansofTransport.RESET();
                    lrc_MeansofTransport.SETRANGE(Type, lrc_MeansofTransport.Type::Truck);
                    lrc_MeansofTransport.SETRANGE(Code, vrc_PurchHeader."POI Means of TransCode(Arriva)");
                    IF NOT lrc_MeansofTransport.FIND('-') THEN BEGIN
                        lrc_MeansofTransport.RESET();
                        lrc_MeansofTransport.INIT();
                        lrc_MeansofTransport.Type := lrc_MeansofTransport.Type::Truck;
                        lrc_MeansofTransport.Code := vrc_PurchHeader."POI Means of TransCode(Arriva)";
                        lrc_MeansofTransport.INSERT();
                    END;
                END;
            vrc_PurchHeader."POI Means of Transport Type"::Train:
                ;
            vrc_PurchHeader."POI Means of Transport Type"::Ship:
                BEGIN
                    lrc_MeansofTransport.RESET();
                    lrc_MeansofTransport.SETRANGE(Type, lrc_MeansofTransport.Type::Ship);
                    lrc_MeansofTransport.SETRANGE(Code, vrc_PurchHeader."POI Means of TransCode(Arriva)");
                    IF NOT lrc_MeansofTransport.FIND('-') THEN BEGIN
                        lrc_MeansofTransport.RESET();
                        lrc_MeansofTransport.INIT();
                        lrc_MeansofTransport.Type := lrc_MeansofTransport.Type::Ship;
                        lrc_MeansofTransport.Code := vrc_PurchHeader."POI Means of TransCode(Arriva)";
                        lrc_MeansofTransport.INSERT();
                    END;
                END;
            vrc_PurchHeader."POI Means of Transport Type"::Airplane:
                ;
        END;
    end;

    procedure PurchCheckBeforePosting(vrc_PurchaseHeader: Record "Purchase Header")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        lcu_CalcUnitCostandSalesPrice: Codeunit "POI Calc Unit Cost/Sales Price";
        lcu_PalletManagement: Codeunit "POI Pallet Management";
        AGILES_TEXT001Txt: Label 'Es sind keine Zeilen zum Buchen vorhanden!';
        // AGILES_TEXT002Txt: Label 'Markteinkaufspreis ist Pflicht!';
        // AGILES_TEXT003Txt: Label 'Der Markteinkaufspreis darf nicht unter dem Einkaufspreis liegen!';
        // AGILES_TEXT004Txt: Label 'Eingabe EK-Preis ist Pflicht!';
        AGILES_TEXT005Txt: Label 'Vendor Delivery Note No. already posted with Purch. Order No. %1!', Comment = '%1';
        AGILES_TEXT006Txt: Label 'Eink.-Bestellung nicht zur Faktura freigegeben!';
    // AGILES_TEXT007Txt: Label 'Quantity pallets in Warehouse Entry differs from quantity pallet numbers!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Prüfung auf Pflichtfelder etc. vor der Buchung
        // -----------------------------------------------------------------------------

        IF vrc_PurchaseHeader."Document Type" = vrc_PurchaseHeader."Document Type"::Order THEN
            lcu_CalcUnitCostandSalesPrice.PurchCalcUnitCostUnit(vrc_PurchaseHeader);

        // FruitVision Setup lesen
        lrc_FruitVisionSetup.GET();
        // Kreditoren und Eink. Einr. lesen
        lrc_PurchasesPayablesSetup.GET();

        lcu_PalletManagement.PurchUpdPalletsFromPLine(vrc_PurchaseHeader."Document Type", vrc_PurchaseHeader."No.", 0);
        lcu_PalletManagement.PurchPostCheckPallet(vrc_PurchaseHeader);

        // Einkaufsbelegart lesen
        lrc_PurchDocType.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchDocType.SETRANGE(Code, vrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
        lrc_PurchDocType.FINDFIRST();

        // Prüfung auf Freigabekennzeichen
        IF lrc_PurchDocType."Invoice of Purch. Order" <> lrc_PurchDocType."Invoice of Purch. Order"::" " THEN
            // Kontrolle ob Einkaufsbestellung zur Faktura freigegeben ist
            IF (lrc_PurchDocType."Invoice of Purch. Order" = lrc_PurchDocType."Invoice of Purch. Order"::"Release has to be set") OR
               (lrc_PurchDocType."Invoice of Purch. Order" = lrc_PurchDocType."Invoice of Purch. Order"::"Release and no open Claim")
               THEN
                IF vrc_PurchaseHeader."POI Released for Invoice" = FALSE THEN
                    // Eink.-Bestellung nicht zur Faktura freigegeben!
                    ERROR(AGILES_TEXT006Txt);

        // Kontrolle ob der Lieferschein bereits vorhanden ist
        IF lrc_PurchasesPayablesSetup."POI Ext. Vend. Ship. No. Mand" = TRUE THEN
            IF (vrc_PurchaseHeader."Document Type" = vrc_PurchaseHeader."Document Type"::Order) OR
               ((vrc_PurchaseHeader."Document Type" = vrc_PurchaseHeader."Document Type"::Invoice) AND
                (lrc_PurchasesPayablesSetup."Receipt on Invoice" = TRUE)) THEN BEGIN
                vrc_PurchaseHeader.TESTFIELD("Vendor Shipment No.");
                lrc_PurchaseHeader.RESET();
                lrc_PurchaseHeader.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
                lrc_PurchaseHeader.SETRANGE("Buy-from Vendor No.", vrc_PurchaseHeader."Buy-from Vendor No.");
                lrc_PurchaseHeader.SETFILTER("No.", '<>%1', vrc_PurchaseHeader."No.");
                lrc_PurchaseHeader.SETRANGE("Vendor Shipment No.", vrc_PurchaseHeader."Vendor Shipment No.");
                IF lrc_PurchaseHeader.FINDFIRST() THEN
                    // Kreditor Lieferscheinnr. wurde bereits mit der Bestellnr. xxx gebucht!
                    ERROR(AGILES_TEXT005Txt, lrc_PurchaseHeader."No.");
            END;


        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT
                // Prüfungen für alle
                // Prüfungen in Abhängigkeit der Zeilenart
                // FV START 190209 --> Nur abprüfen wenn zu liefern oder zu fakturieren gefüllt ist
                // Kontrolle, ob bei wiegen ein entsprechendes Gewicht eingetragen ist
                IF (lrc_PurchaseLine."Qty. to Invoice" <> 0) OR (lrc_PurchaseLine."Qty. to Receive" <> 0) THEN
                    IF (lrc_PurchaseLine."POI Weight" = lrc_PurchaseLine."POI Weight"::"Net Weight") OR
                       (lrc_PurchaseLine."POI Weight" = lrc_PurchaseLine."POI Weight"::" ") THEN //TODO: hier stand "6" statt " " ????
                        lrc_PurchaseLine.TESTFIELD("Net Weight")
                    ELSE
                        IF lrc_PurchaseLine."POI Weight" = lrc_PurchaseLine."POI Weight"::"Gross Weight" THEN
                            lrc_PurchaseLine.TESTFIELD("Gross Weight");

            // Prüfungen in Abhängigkeit der Belegart
            UNTIL lrc_PurchaseLine.NEXT() = 0
        ELSE
            // Es sind keine Zeilen zum Buchen vorhanden!
            ERROR(AGILES_TEXT001Txt);

    end;

    procedure PurchOrderShowQtySummery(vco_PurchOrderNo: Code[20])
    var
        //lfm_PurchOrderSummaryStatistic: Form "5088067";
        AGILES_LT_TEXT001Txt: Label '&Item No.,Item No. and &Unit of Measure';
        lin_Selection: Integer;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Anzeige der Summenwerte eines Einkaufes
        // -----------------------------------------------------------------------------

        lrc_FruitVisionTempII.RESET();
        lrc_FruitVisionTempII.SETRANGE("User ID", USERID());
        lrc_FruitVisionTempII.SETRANGE("Entry Type", lrc_FruitVisionTempII."Entry Type"::"Purch.-Statistic");
        lrc_FruitVisionTempII.DELETEALL();
        COMMIT();

        // Abfrage welche Verdichtung
        lin_Selection := STRMENU(AGILES_LT_TEXT001Txt);
        IF lin_Selection = 0 THEN
            EXIT;

        lrc_PurchaseHeader.GET(lrc_PurchaseHeader."Document Type"::Order, vco_PurchOrderNo);

        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
        lrc_PurchaseLine.SETFILTER("No.", '<>%1', '');
        IF lrc_PurchaseLine.FIND('-') THEN BEGIN
            REPEAT

                lrc_FruitVisionTempII.RESET();
                lrc_FruitVisionTempII.SETRANGE("User ID", USERID());
                lrc_FruitVisionTempII.SETRANGE("Entry Type", lrc_FruitVisionTempII."Entry Type"::"Purch.-Statistic");
                lrc_FruitVisionTempII.SETRANGE("ES Item No.", lrc_PurchaseLine."No.");
                lrc_FruitVisionTempII.SETRANGE("ES Item Variant Code", lrc_PurchaseLine."Variant Code");
                IF lin_Selection = 2 THEN
                    lrc_FruitVisionTempII.SETRANGE("ES Unit of Measure Code", lrc_PurchaseLine."Unit of Measure Code");
                IF NOT lrc_FruitVisionTempII.FIND('-') THEN BEGIN
                    lrc_FruitVisionTempII.RESET();
                    lrc_FruitVisionTempII."User ID" := copystr(USERID(), 1, 50);
                    lrc_FruitVisionTempII."Entry Type" := lrc_FruitVisionTempII."Entry Type"::"Purch.-Statistic";
                    lrc_FruitVisionTempII."Entry No." := 0;
                    lrc_FruitVisionTempII."ES Item No." := lrc_PurchaseLine."No.";
                    lrc_FruitVisionTempII."ES Item Variant Code" := lrc_PurchaseLine."Variant Code";
                    lrc_FruitVisionTempII."ES Unit of Measure Code" := lrc_PurchaseLine."Unit of Measure Code";
                    lrc_FruitVisionTempII.INSERT(TRUE);
                END;

                lrc_FruitVisionTempII."ES Quantity" := lrc_FruitVisionTempII."ES Quantity" + lrc_PurchaseLine.Quantity;
                lrc_FruitVisionTempII."ES Base Unit of Measure" := lrc_PurchaseLine."POI Base Unit of Measure (BU)";
                lrc_FruitVisionTempII."ES Qty. per Unit" := lrc_PurchaseLine."Qty. per Unit of Measure";
                lrc_FruitVisionTempII."ES Quantity (Base)" := lrc_FruitVisionTempII."ES Quantity (Base)" + lrc_PurchaseLine."Quantity (Base)";
                lrc_FruitVisionTempII."ES Transport Unit of Measure" := lrc_PurchaseLine."POI Transport Unit of Meas(TU)";
                lrc_FruitVisionTempII."ES Quantity (TU)" := lrc_FruitVisionTempII."ES Quantity (TU)" + lrc_PurchaseLine."POI Quantity (TU)";
                lrc_FruitVisionTempII.MODIFY();

            UNTIL lrc_PurchaseLine.NEXT() = 0;
            COMMIT();
        END;


        lrc_FruitVisionTempII.RESET();
        lrc_FruitVisionTempII.FILTERGROUP(2);
        lrc_FruitVisionTempII.SETRANGE("User ID", USERID());
        lrc_FruitVisionTempII.SETRANGE("Entry Type", lrc_FruitVisionTempII."Entry Type"::"Purch.-Statistic");
        lrc_FruitVisionTempII.FILTERGROUP(0);

        // lfm_PurchOrderSummaryStatistic.SETTABLEVIEW(lrc_FruitVisionTempII); //TODO: page
        // lfm_PurchOrderSummaryStatistic.RUNMODAL();
    end;

    procedure PurchOrderCheckReceiveInvoice(vop_PurchDocType: Option "0","1","2","3","4","5","6"; vop_PurchDocNo: Code[20])
    var
        lbn_PurchaseIsClose: Boolean;
    begin
        // -------------------------------------------------------------------------------------------
        // Funktion zum Prüfen ob Lieferung und Fakturierung einer Einkaufsbestellung erfolgt ist
        // -------------------------------------------------------------------------------------------

        IF vop_PurchDocNo <> '' THEN BEGIN
            lrc_PurchHeader.SETRANGE("Document Type", vop_PurchDocType);
            lrc_PurchHeader.SETRANGE("No.", vop_PurchDocNo);
        END;
        IF lrc_PurchHeader.FINDSET(TRUE, FALSE) THEN
            REPEAT
                lbn_PurchaseIsClose := TRUE;
                lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
                lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
                IF lrc_PurchLine.FINDSET(FALSE, FALSE) THEn
                    REPEAT
                        IF (lrc_PurchLine."No." <> '') AND ((lrc_PurchLine.Type = lrc_PurchLine.Type::Item) OR (lrc_PurchLine.Type = lrc_PurchLine.Type::"G/L Account")) THEN
                            IF (lrc_PurchLine.Quantity <> 0) AND (lrc_PurchLine.Quantity <> lrc_PurchLine."Quantity Invoiced") THEN
                                lbn_PurchaseIsClose := FALSE;
                    UNTIL lrc_PurchLine.NEXT() = 0;
                IF lbn_PurchaseIsClose = TRUE THEN
                    IF lrc_PurchHeader."POI Document Status" <> lrc_PurchHeader."POI Document Status"::Abgeschlossen THEN BEGIN
                        lrc_PurchHeader."POI Document Status" := lrc_PurchHeader."POI Document Status"::Abgeschlossen;
                        lrc_PurchHeader.MODIFY();
                    END
                    ELSE
                        IF lrc_PurchHeader."POI Document Status" = lrc_PurchHeader."POI Document Status"::Abgeschlossen THEN BEGIN
                            lrc_PurchHeader."POI Document Status" := lrc_PurchHeader."POI Document Status"::Offen;
                            lrc_PurchHeader.MODIFY();
                        END;
            UNTIL lrc_PurchHeader.NEXT() = 0;
    end;

    procedure PurchShowBlanketOrder(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_PurchHdr: Record "Purchase Header";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum öffnen einer Rahmenbestellung aus der Übersicht
        // -----------------------------------------------------------------------------

        lrc_PurchHdr.GET(vop_DocType, vco_DocNo);
        lrc_PurchDocType.GET(lrc_PurchHdr."Document Type", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
        lrc_PurchDocType.TESTFIELD("Page ID Card");

        IF lrc_PurchDocType."Allow scrolling in Card" = FALSE THEN BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("No.", lrc_PurchHdr."No.");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END ELSE BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END;

        Page.RUN(lrc_PurchDocType."Page ID Card", lrc_PurchHdr);
    end;

    procedure PurchNewBlanketOrder(vco_PurchDocType: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        AGILES_TEXT001Txt: Label 'Neuanlage nur über Belegart zulässig!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Anlegen einer Rahmenbestellung aus der Übersicht
        // -----------------------------------------------------------------------------

        IF vco_PurchDocType = '' THEN
            // Neuanlage nur über Belegart zulässig!
            ERROR(AGILES_TEXT001Txt);

        // Belegart lesen
        lrc_PurchDocType.GET(lrc_PurchDocType."Document Type"::"Blanket Order", vco_PurchDocType);

        lrc_PurchHdr.RESET();
        lrc_PurchHdr.INIT();
        lrc_PurchHdr."Document Type" := lrc_PurchHdr."Document Type"::"Blanket Order";
        lrc_PurchHdr."No." := '';
        lrc_PurchHdr."POI Purch. Doc. Subtype Code" := vco_PurchDocType;

        // Kopfsatz einfügen
        lrc_PurchHdr.INSERT(TRUE);

        IF lrc_PurchDocType."Default Vendor" <> '' THEN
            lrc_PurchHdr.VALIDATE("Buy-from Vendor No.", lrc_PurchDocType."Default Vendor");

        // Standard Lagerort aus Belegart setzen
        IF lrc_PurchDocType."Default Location Code" <> '' THEN
            lrc_PurchHdr.VALIDATE("Location Code", lrc_PurchDocType."Default Location Code");

        // Qualitätskontrolleur aus Belegart setzen
        IF lrc_PurchDocType."Quality Control Vendor No." <> '' THEN
            lrc_PurchHdr.VALIDATE("POI Quality Control Vendor No.", lrc_PurchDocType."Quality Control Vendor No.");

        // Spediteur aus Belegart setzen
        IF lrc_PurchDocType."Clearing by Ship. Agent Code" <> '' THEN
            lrc_PurchHdr.VALIDATE("POI Clearing by Vendor No.", lrc_PurchDocType."Clearing by Ship. Agent Code");

        // Kopfsatz aktualisieren
        lrc_PurchHdr.MODIFY();

        // Neue Bestellung öffnen
        PurchShowBlanketOrder(lrc_PurchHdr."Document Type", lrc_PurchHdr."No.");
    end;

    procedure PurchPlanLineGetPriceUnit(vrc_PurchPlanLines: Record "POI Purch. Plan Lines"): Code[10]
    var
        lrc_PriceCalculation: Record "POI Price Base";
        lrc_UnitofMeasure: Record "Unit of Measure";
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Ermittlung der Preiseinheit aus Einkaufsplanungszeile
        // ---------------------------------------------------------------------------------------

        IF vrc_PurchPlanLines."Item No." = '' THEN
            EXIT('');
        IF vrc_PurchPlanLines."Price Base (Purch. Price)" = '' THEN
            EXIT('');
        IF vrc_PurchPlanLines."Unit of Measure Code" = '' THEN
            EXIT('');
        lrc_PriceCalculation.GET(lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price", vrc_PurchPlanLines."Price Base (Purch. Price)");
        CASE lrc_PriceCalculation."Internal Calc. Type" OF
            lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
                BEGIN
                    vrc_PurchPlanLines.TESTFIELD("Base Unit of Measure");
                    EXIT(vrc_PurchPlanLines."Base Unit of Measure");
                END;
            lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
                ERROR('Preisbasis nicht zulässig!');
            lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":
                BEGIN
                    lrc_UnitofMeasure.GET(vrc_PurchPlanLines."Unit of Measure Code");
                    IF lrc_UnitofMeasure."POI Packing Unit of Meas (PU)" <> '' THEN
                        EXIT(lrc_UnitofMeasure."POI Packing Unit of Meas (PU)")
                    ELSE
                        EXIT('');
                END;
            lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
                EXIT(vrc_PurchPlanLines."Unit of Measure Code");
            lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
                BEGIN
                    vrc_PurchPlanLines.TESTFIELD("Transport Unit of Measure");
                    vrc_PurchPlanLines.TESTFIELD("Qty. Unit per TU");
                    EXIT(vrc_PurchPlanLines."Transport Unit of Measure");
                END;
            lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
                BEGIN
                    lrc_PriceCalculation.TESTFIELD("Price Unit Weighting");
                    EXIT(lrc_PriceCalculation."Price Unit Weighting");
                END;
            lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
                BEGIN
                    lrc_PriceCalculation.TESTFIELD("Price Unit Weighting");
                    EXIT(lrc_PriceCalculation."Price Unit Weighting");
                END;
            lrc_PriceCalculation."Internal Calc. Type"::"Total Price":
                EXIT('');
        END;
    end;

    procedure PurchShowCostInv(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_PurchHdr: Record "Purchase Header";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum öffnen einer Kostenrechnung aus der Übersicht
        // -----------------------------------------------------------------------------

        lrc_PurchHdr.GET(vop_DocType, vco_DocNo);
        lrc_PurchDocType.GET(lrc_PurchHdr."Document Type", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
        lrc_PurchDocType.TESTFIELD("Page ID Card");

        IF lrc_PurchDocType."Allow scrolling in Card" = FALSE THEN BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("No.", lrc_PurchHdr."No.");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END ELSE BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END;

        Page.RUN(lrc_PurchDocType."Page ID Card", lrc_PurchHdr);
    end;

    procedure PurchNewCostInv(vco_PurchDocType: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        AGILES_TEXT001Txt: Label 'Neuanlage nur über Belegart zulässig!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Anlegen einer Kostenrechnung aus der Übersicht
        // -----------------------------------------------------------------------------

        IF vco_PurchDocType = '' THEN
            // Neuanlage nur über Belegart zulässig!
            ERROR(AGILES_TEXT001Txt);
        lrc_PurchDocType.GET(lrc_PurchDocType."Document Type"::Invoice, vco_PurchDocType);

        lrc_PurchHdr.RESET();
        lrc_PurchHdr.INIT();
        lrc_PurchHdr.VALIDATE("Document Type", lrc_PurchHdr."Document Type"::Invoice);
        lrc_PurchHdr."No." := '';
        lrc_PurchHdr."POI Purch. Doc. Subtype Code" := vco_PurchDocType;
        lrc_PurchHdr."POI Purch. Doc. Subtype Detail" := lrc_PurchHdr."POI Purch. Doc. Subtype Detail"::"Invoice of Expences";
        lrc_PurchHdr.INSERT(TRUE);

        PurchShowCostInv(lrc_PurchHdr."Document Type", lrc_PurchHdr."No.");
    end;

    procedure PurchShowInvoice(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_PurchHdr: Record "Purchase Header";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Öffnen einer Rechnung aus der Übersicht
        // -----------------------------------------------------------------------------

        lrc_PurchHdr.GET(vop_DocType, vco_DocNo);
        lrc_PurchDocType.GET(lrc_PurchHdr."Document Type", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
        lrc_PurchDocType.TESTFIELD("Page ID Card");

        IF lrc_PurchDocType."Allow scrolling in Card" = FALSE THEN BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("No.", lrc_PurchHdr."No.");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END ELSE BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END;

        Page.RUN(lrc_PurchDocType."Page ID Card", lrc_PurchHdr);
    end;

    procedure PurchNewInvoice(vco_PurchDocType: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        AGILES_TEXT001Txt: Label 'Neuanlage nur über Belegart zulässig!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Anlegen einer Rechnung aus der Übersicht
        // -----------------------------------------------------------------------------

        IF vco_PurchDocType = '' THEN
            // Neuanlage nur über Belegart zulässig!
            ERROR(AGILES_TEXT001Txt);
        lrc_PurchDocType.GET(lrc_PurchDocType."Document Type"::Invoice, vco_PurchDocType);

        lrc_PurchHdr.RESET();
        lrc_PurchHdr.INIT();
        lrc_PurchHdr.VALIDATE("Document Type", lrc_PurchHdr."Document Type"::Invoice);
        lrc_PurchHdr."No." := '';
        lrc_PurchHdr."POI Purch. Doc. Subtype Code" := vco_PurchDocType;
        lrc_PurchHdr.INSERT(TRUE);

        PurchShowInvoice(lrc_PurchHdr."Document Type", lrc_PurchHdr."No.");
    end;

    procedure PurchShowCostCrMemo(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_PurchHdr: Record "Purchase Header";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum öffnen einer Kostengutschrift aus der Übersicht
        // -----------------------------------------------------------------------------

        lrc_PurchHdr.GET(vop_DocType, vco_DocNo);
        lrc_PurchDocType.GET(lrc_PurchHdr."Document Type", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
        lrc_PurchDocType.TESTFIELD("Page ID Card");

        IF lrc_PurchDocType."Allow scrolling in Card" = FALSE THEN BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("No.", lrc_PurchHdr."No.");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END ELSE BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END;
        Page.RUN(lrc_PurchDocType."Page ID Card", lrc_PurchHdr);
    end;

    procedure PurchNewCostCrMemo(vco_PurchDocType: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        AGILES_TEXT001Txt: Label 'Neuanlage nur über Belegart zulässig!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Anlegen einer Kostengutschrift aus der Übersicht
        // -----------------------------------------------------------------------------
        IF vco_PurchDocType = '' THEN
            // Neuanlage nur über Belegart zulässig!
            ERROR(AGILES_TEXT001Txt);
        lrc_PurchDocType.GET(lrc_PurchDocType."Document Type"::"Credit Memo", vco_PurchDocType);
        lrc_PurchHdr.RESET();
        lrc_PurchHdr.INIT();
        lrc_PurchHdr.VALIDATE("Document Type", lrc_PurchHdr."Document Type"::"Credit Memo");
        lrc_PurchHdr."No." := '';
        lrc_PurchHdr."POI Purch. Doc. Subtype Code" := vco_PurchDocType;
        lrc_PurchHdr."POI Purch. Doc. Subtype Detail" := lrc_PurchHdr."POI Purch. Doc. Subtype Detail"::"Credit Memo of Expences";
        lrc_PurchHdr.INSERT(TRUE);
        PurchShowCostCrMemo(lrc_PurchHdr."Document Type", lrc_PurchHdr."No.");
    end;

    procedure PurchShowCrMemo(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var
        lrc_PurchHdr: Record "Purchase Header";
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum öffnen einer Gutschrift aus der Übersicht
        // -----------------------------------------------------------------------------

        lrc_PurchHdr.GET(vop_DocType, vco_DocNo);
        lrc_PurchDocType.GET(lrc_PurchHdr."Document Type", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
        lrc_PurchDocType.TESTFIELD("Page ID Card");

        IF lrc_PurchDocType."Allow scrolling in Card" = FALSE THEN BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("No.", lrc_PurchHdr."No.");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END ELSE BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END;

        Page.RUN(lrc_PurchDocType."Page ID Card", lrc_PurchHdr);
    end;

    procedure PurchNewCrMemo(vco_PurchDocType: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        AGILES_TEXT001Txt: Label 'Neuanlage nur über Belegart zulässig!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Anlegen einer Gutschrift aus der Übersicht
        // -----------------------------------------------------------------------------

        IF vco_PurchDocType = '' THEN
            // Neuanlage nur über Belegart zulässig!
            ERROR(AGILES_TEXT001Txt);
        lrc_PurchDocType.GET(lrc_PurchDocType."Document Type"::"Credit Memo", vco_PurchDocType);

        lrc_PurchHdr.RESET();
        lrc_PurchHdr.INIT();
        lrc_PurchHdr.VALIDATE("Document Type", lrc_PurchHdr."Document Type"::"Credit Memo");
        lrc_PurchHdr."No." := '';
        lrc_PurchHdr."POI Purch. Doc. Subtype Code" := vco_PurchDocType;
        lrc_PurchHdr.INSERT(TRUE);
        COMMIT();

        PurchShowCrMemo(lrc_PurchHdr."Document Type", lrc_PurchHdr."No.");
    end;

    procedure CheckVendorDocTyp(vrc_PurchHeader: Record "Purchase Header"): Boolean
    var
        lrc_Vendor: Record Vendor;
    //TEXT001Txt: Label 'Kreditor für Belegart nicht zulässig!';

    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Prüfen ob Kreditor für Belegart zulässig
        // -----------------------------------------------------------------------------

        IF vrc_PurchHeader."Buy-from Vendor No." = '' THEN
            EXIT(TRUE);

        // Belegart muss vorhanden sein
        vrc_PurchHeader.TESTFIELD("POI Purch. Doc. Subtype Code");

        lrc_PurchDocType.GET(vrc_PurchHeader."Document Type", vrc_PurchHeader."POI Purch. Doc. Subtype Code");
        IF (lrc_PurchDocType."Restriction Vendors" = FALSE) THEN
            EXIT(TRUE);

        // Prüfung auf Kreditorennummer
        lrc_PurchDocTypeFilter.RESET();
        lrc_PurchDocTypeFilter.SETRANGE("Document Type", lrc_PurchDocType."Document Type");
        lrc_PurchDocTypeFilter.SETRANGE("Purch. Doc. Subtype Code", lrc_PurchDocType.Code);
        lrc_PurchDocTypeFilter.SETRANGE(Source, lrc_PurchDocTypeFilter.Source::Vendor);
        lrc_PurchDocTypeFilter.SETRANGE("Source No.", vrc_PurchHeader."Buy-from Vendor No.");
        IF lrc_PurchDocTypeFilter.FIND('-') THEN BEGIN
            IF lrc_PurchDocTypeFilter."Not Allowed" = TRUE THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE);
        END ELSE BEGIN

            // Prüfung auf Unternehmenskette
            lrc_Vendor.GET(vrc_PurchHeader."Buy-from Vendor No.");
            IF lrc_Vendor."POI Chain Name" = '' THEN
                EXIT(FALSE);

            lrc_PurchDocTypeFilter.RESET();
            lrc_PurchDocTypeFilter.SETRANGE("Document Type", lrc_PurchDocType."Document Type");
            lrc_PurchDocTypeFilter.SETRANGE("Purch. Doc. Subtype Code", lrc_PurchDocType.Code);
            lrc_PurchDocTypeFilter.SETRANGE(Source, lrc_PurchDocTypeFilter.Source::"Vendor Chain");
            lrc_PurchDocTypeFilter.SETRANGE("Source No.", lrc_Vendor."POI Chain Name");
            IF lrc_PurchDocTypeFilter.FIND('-') THEN BEGIN
                IF lrc_PurchDocTypeFilter."Not Allowed" = TRUE THEN
                    EXIT(FALSE)
                ELSE
                    EXIT(TRUE);
            END ELSE
                EXIT(FALSE);

        END;

        // Zur Sicherheit
        EXIT(FALSE);
    end;

    procedure CheckLocationDocTyp(vop_DocTyp: Option "0","1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; vco_DocTypCode: Code[10]; vco_LocationCode: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        AGILES_TEXT001Txt: Label 'Lager für Belegart nicht zulässig!';
        AGILES_TEXT002Txt: Label 'Lager ist nicht identisch mit Lager in Einkaufskopf!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Prüfen ob Lager für Belegart zulässig
        // -----------------------------------------------------------------------------

        IF (vco_DocTypCode = '') OR
           (vco_LocationCode = '') THEN
            EXIT;

        lrc_PurchDocType.GET(vop_DocTyp, vco_DocTypCode);
        CASE lrc_PurchDocType."Restrict Locations" OF
            lrc_PurchDocType."Restrict Locations"::"Feste Eingrenzung":
                BEGIN
                    lrc_PurchDocTypeFilter.SETRANGE("Document Type", vop_DocTyp);
                    lrc_PurchDocTypeFilter.SETRANGE("Purch. Doc. Subtype Code", vco_DocTypCode);
                    lrc_PurchDocTypeFilter.SETRANGE(Source, lrc_PurchDocTypeFilter.Source::Location);
                    lrc_PurchDocTypeFilter.SETRANGE("Source No.", vco_LocationCode);
                    IF lrc_PurchDocTypeFilter.IsEmpty() THEN
                        // Lager für Belegart nicht zulässig!
                        ERROR(AGILES_TEXT001Txt);
                END;

            lrc_PurchDocType."Restrict Locations"::Belegkopf:
                BEGIN
                    lrc_PurchHdr.GET(vop_DocTyp, vco_DocNo);
                    IF lrc_PurchHdr."Location Code" <> vco_LocationCode THEN
                        // Lager ist nicht identisch mit Lager in Einkaufskopf!
                        ERROR(AGILES_TEXT002Txt);
                END;
        END;
    end;

    procedure FillFieldWithBatchNumbers(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]) lco_BatchNumbers: Code[150]
    var
        lco_ArrResult: array[1000] of Code[20];
        "lin_ArrZähler": Integer;
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zum Füllen eines Feldes mit allen Batch Numbers
        // ---------------------------------------------------------------------------------------

        FillArrBatchNumbers(vop_DocType, vco_DocNo, lco_ArrResult);

        lin_ArrZähler := 1;
        WHILE lco_ArrResult[lin_ArrZähler] <> '' DO begin
            IF lco_BatchNumbers = '' THEN
                lco_BatchNumbers := lco_ArrResult[lin_ArrZähler]
            ELSE
                lco_BatchNumbers := COPYSTR((lco_BatchNumbers + ' ' + lco_ArrResult[lin_ArrZähler]), 1, 150);
            lin_ArrZähler := lin_ArrZähler + 1;
        end;
    end;

    procedure FillArrBatchNumbers(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; var rco_ArrResult: array[1000] of Code[20])
    var
        lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        "lin_ArrZähler": Integer;
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zum Füllen eines Array mit allen Batch Numbers
        // ---------------------------------------------------------------------------------------

        lin_ArrZähler := 0;

        lrc_PurchHeader.GET(vop_DocType, vco_DocNo);

        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
        lrc_PurchLine.SETFILTER("POI Batch No.", '<>%1', '');
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult, 10, lrc_PurchLine."POI Batch No.") = 0 THEN BEGIN
                    lin_ArrZähler := lin_ArrZähler + 1;
                    IF lin_ArrZähler <= 100 THEN
                        rco_ArrResult[lin_ArrZähler] := lrc_PurchLine."POI Batch No.";
                END;
            UNTIL lrc_PurchLine.NEXT() = 0;
    end;

    procedure FillArrShippingAgent(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; var rco_ArrResult: array[1000] of Code[20])
    var
        lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        "lin_ArrZähler": Integer;
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zum Füllen eines Array mit allen Shipping Agents
        // ---------------------------------------------------------------------------------------

        lin_ArrZähler := 0;

        lrc_PurchHeader.GET(vop_DocType, vco_DocNo);

        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        lrc_PurchLine.SETFILTER("POI Shipping Agent Code", '<>%1', '');
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult, 10, lrc_PurchLine."POI Shipping Agent Code") = 0 THEN BEGIN
                    lin_ArrZähler := lin_ArrZähler + 1;
                    rco_ArrResult[lin_ArrZähler] := lrc_PurchLine."POI Shipping Agent Code";
                END;
            UNTIL lrc_PurchLine.NEXT() = 0;
    end;

    procedure FillArrPhysLocation(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; var rco_ArrResult: array[1000] of Code[20])
    var
        lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        "lin_ArrZähler": Integer;
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zum Füllen eines Array mit allen Physical Location
        // ---------------------------------------------------------------------------------------

        lin_ArrZähler := 0;

        lrc_PurchHeader.GET(vop_DocType, vco_DocNo);

        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        lrc_PurchLine.SETFILTER("POI Location Group Code", '<>%1', '');
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult, 10, lrc_PurchLine."POI Location Group Code") = 0 THEN BEGIN
                    lin_ArrZähler := lin_ArrZähler + 1;
                    rco_ArrResult[lin_ArrZähler] := lrc_PurchLine."POI Location Group Code";
                END;
            UNTIL lrc_PurchLine.NEXT() = 0;
    end;

    procedure FillArrLocation(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; var rco_ArrResult: array[1000] of Code[20])
    var
        lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        "lin_ArrZähler": Integer;
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zum Füllen eines Array mit allen Location
        // ---------------------------------------------------------------------------------------

        lin_ArrZähler := 0;

        lrc_PurchHeader.GET(vop_DocType, vco_DocNo);

        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        lrc_PurchLine.SETFILTER("Location Code", '<>%1', '');
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult, 10, lrc_PurchLine."Location Code") = 0 THEN BEGIN
                    lin_ArrZähler := lin_ArrZähler + 1;
                    rco_ArrResult[lin_ArrZähler] := lrc_PurchLine."Location Code";
                END;
            UNTIL lrc_PurchLine.NEXT() = 0;
    end;

    procedure FillArrArrivalRegion(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20]; var rco_ArrResult: array[1000] of Code[20])
    var
        lcu_GlobalFunctions: Codeunit "POI GlobalFunctionsMgt";
        "lin_ArrZähler": Integer;
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zum Füllen eines Array mit allen Departure Region
        // ---------------------------------------------------------------------------------------

        lin_ArrZähler := 0;

        lrc_PurchHeader.GET(vop_DocType, vco_DocNo);

        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchHeader."Document Type");
        lrc_PurchLine.SETRANGE("Document No.", lrc_PurchHeader."No.");
        lrc_PurchLine.SETFILTER("POI Arrival Region Code", '<>%1', '');
        IF lrc_PurchLine.FIND('-') THEN
            REPEAT
                IF lcu_GlobalFunctions.FindArrIndexNr(rco_ArrResult, 10, lrc_PurchLine."POI Arrival Region Code") = 0 THEN BEGIN
                    lin_ArrZähler := lin_ArrZähler + 1;
                    rco_ArrResult[lin_ArrZähler] := lrc_PurchLine."POI Arrival Region Code";
                END;
            UNTIL lrc_PurchLine.NEXT() = 0;
    end;

    procedure UpdatePurchaseOrderFromVoyage(var vrc_Voyage: Record "POI Voyage")
    var
        AGILES_TEXT001Txt: Label 'Do you really want ta update %1 purchase orders with voyage %2?', Comment = '%1 %2';
        AGILES_TEXT002Txt: Label 'There is no purchase order with status %1 document status %2 for this voyage %3!', Comment = '%1 %2 %3';
    begin
        // -----------------------------------------------------------------------------
        // Einkaufsbestellungen über den Reisecode aktualisieren
        // -----------------------------------------------------------------------------

        vrc_Voyage.TESTFIELD("No.");

        lrc_PurchaseHeader.RESET();
        lrc_PurchaseHeader.SETCURRENTKEY("POI Voyage No.", Status, "POI Document Status");
        lrc_PurchaseHeader.SETRANGE("POI Voyage No.", vrc_Voyage."No.");
        lrc_PurchaseHeader.SETRANGE(Status, lrc_PurchaseHeader.Status::Open);
        lrc_PurchaseHeader.SETRANGE("POI Document Status", lrc_PurchaseHeader."POI Document Status"::Offen);
        IF lrc_PurchaseHeader.FIND('-') THEN BEGIN
            IF CONFIRM(AGILES_TEXT001Txt, TRUE, lrc_PurchaseHeader.COUNT(), vrc_Voyage."No.") THEN
                REPEAT
                    lrc_PurchaseHeader.VALIDATE("POI Voyage No.", vrc_Voyage."No.");
                    IF (vrc_Voyage."Currency Code" <> '') AND (vrc_Voyage."Currency Factor" <> 0) THEN BEGIN
                        lrc_PurchaseHeader.VALIDATE("Currency Code", vrc_Voyage."Currency Code");
                        lrc_PurchaseHeader.VALIDATE("Currency Factor", vrc_Voyage."Currency Factor");
                    END;
                    lrc_PurchaseHeader.MODIFY(TRUE);
                UNTIL lrc_PurchaseHeader.NEXT() = 0
        END ELSE
            MESSAGE(AGILES_TEXT002Txt, vrc_Voyage."No.", lrc_PurchaseHeader.Status::Open, lrc_PurchaseHeader."POI Document Status"::Offen);
    end;

    procedure ShowPurchaseOrderFormVoyage(vrc_Voyage: Record "POI Voyage")
    var
        //lrc_FruitVisionSetup: Record "POI ADF Setup";
        lin_FormID: Integer;
        AGILES_TEXT001Txt: Label 'There exist no standard definition for the purchase order !';

    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Anzeigen aller Bestellungen zu einer Reise
        // -----------------------------------------------------------------------------

        vrc_Voyage.TESTFIELD("No.");

        // lrc_FruitVisionSetup.GET();
        // lrc_FruitVisionSetup.TESTFIELD("Default Purch. Doc. Typ");

        lrc_PurchDocType.RESET();
        lrc_PurchDocType.SETRANGE("Document Type", lrc_PurchDocType."Document Type"::Order);
        lrc_PurchDocType.SETFILTER("Form ID List", '<>%1', 0);
        IF lrc_PurchDocType.FIND('-') THEN
            lin_FormID := lrc_PurchDocType."Form ID List";

        //lrc_FruitvisionFormSetup.RESET();
        //lrc_FruitvisionFormSetup.SETRANGE(Type, lrc_FruitvisionFormSetup.Type::Purchase);
        //lrc_FruitvisionFormSetup.SETRANGE("Purchase Doc. Type", lrc_FruitvisionFormSetup."Purchase Doc. Type"::Order);
        //IF lrc_FruitvisionFormSetup.FIND('-') THEN BEGIN
        //   lin_FormID := lrc_FruitvisionFormSetup."Form ID List";
        //END;

        IF lin_FormID <> 0 THEN BEGIN
            lrc_PurchaseHeader.RESET();
            lrc_PurchaseHeader.SETCURRENTKEY("POI Voyage No.", Status, "POI Document Status");
            lrc_PurchaseHeader.SETRANGE("POI Voyage No.", vrc_Voyage."No.");
            Page.RUN(lin_FormID, lrc_PurchaseHeader);
        END ELSE
            MESSAGE(AGILES_TEXT001Txt);
    end;

    procedure UpdateSalesOrderFromPurchOrder(vrc_PurchaseLine: Record "Purchase Line")
    var
        lrc_ADFSetup: Record "POI ADF Setup";
        AGILES_TEXT001Txt: Label 'Do you want to transfer the changes in all sales lines ?';
        vbn_Update: Boolean;
    begin
        // ------------------------------------------------------------------------------------------------------
        // Änderungen in Einkaufsbestellung in alle offenen Aufträge übertragen
        // ------------------------------------------------------------------------------------------------------

        IF (vrc_PurchaseLine."Document Type" <> vrc_PurchaseLine."Document Type"::Order) OR
           (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR
           (vrc_PurchaseLine."No." = '') OR
           (vrc_PurchaseLine."POI Master Batch No." = '') OR
           (vrc_PurchaseLine."POI Batch No." = '') OR
           (vrc_PurchaseLine."POI Batch Variant No." = '') THEN
            EXIT;

        lrc_ADFSetup.GET();

        IF lrc_ADFSetup."POI Trans Changes Purch./Sales" =
           lrc_ADFSetup."POI Trans Changes Purch./Sales"::"No Transfer" THEN
            EXIT;

        IF lrc_ADFSetup."POI Trans Changes Purch./Sales" =
           lrc_ADFSetup."POI Trans Changes Purch./Sales"::"Transfer with Confirm" THEN
            IF NOT CONFIRM(AGILES_TEXT001Txt) THEN
                EXIT;

        lrc_SalesLine.RESET();
        lrc_SalesLine.SETCURRENTKEY("POI Batch Variant No.");
        lrc_SalesLine.SETRANGE("POI Batch Variant No.", vrc_PurchaseLine."POI Batch Variant No.");
        lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
        lrc_SalesLine.SETRANGE("Document Type", lrc_SalesLine."Document Type"::Order);
        IF lrc_SalesLine.FINDSET(TRUE, FALSE) THEN
            REPEAT
                vbn_Update := FALSE;
                // Nur Verkaufszeilen mit Artikelnummer und ohne gelieferte Mengen
                IF (lrc_SalesLine."No." <> '') AND
                   (lrc_SalesLine."Quantity Shipped" = 0) THEN BEGIN
                    // Aktualisierung der Artikelattribute
                    IF (lrc_SalesLine."POI Variety Code" <> vrc_PurchaseLine."POI Variety Code") OR
                       (lrc_SalesLine."POI Country of Origin Code" <> vrc_PurchaseLine."POI Country of Origin Code") OR
                       (lrc_SalesLine."POI Caliber Code" <> vrc_PurchaseLine."POI Caliber Code") OR
                       (lrc_SalesLine."POI Grade of Goods Code" <> vrc_PurchaseLine."POI Grade of Goods Code") OR
                       (lrc_SalesLine."POI Trademark Code" <> vrc_PurchaseLine."POI Trademark Code") OR
                       (lrc_SalesLine."POI Cultivation Type" <> vrc_PurchaseLine."POI Cultivation Type") OR
                       (lrc_SalesLine."POI Cultivation Associat. Code" <> vrc_PurchaseLine."POI Cultivation Associat. Code") OR
                       (lrc_SalesLine."POI Item Attribute 1" <> vrc_PurchaseLine."POI Item Attribute 1") THEN BEGIN
                        lrc_SalesLine."POI Variety Code" := vrc_PurchaseLine."POI Variety Code";
                        lrc_SalesLine."POI Country of Origin Code" := vrc_PurchaseLine."POI Country of Origin Code";
                        lrc_SalesLine."POI Caliber Code" := vrc_PurchaseLine."POI Caliber Code";
                        lrc_SalesLine."POI Grade of Goods Code" := vrc_PurchaseLine."POI Grade of Goods Code";
                        lrc_SalesLine."POI Trademark Code" := vrc_PurchaseLine."POI Trademark Code";
                        lrc_SalesLine."POI Cultivation Type" := vrc_PurchaseLine."POI Cultivation Type";
                        lrc_SalesLine."POI Cultivation Associat. Code" := vrc_PurchaseLine."POI Cultivation Associat. Code";
                        lrc_SalesLine."POI Item Attribute 1" := vrc_PurchaseLine."POI Item Attribute 1";
                        vbn_Update := TRUE;
                    END;

                    IF (lrc_SalesLine."POI Vendor Caliber Code" <> vrc_PurchaseLine."POI Vendor Caliber Code") OR
                       (lrc_SalesLine."POI Item Attribute 7" <> vrc_PurchaseLine."POI Item Attribute 7") OR
                       (lrc_SalesLine."POI Item Attribute 3" <> vrc_PurchaseLine."POI Item Attribute 3") OR
                       (lrc_SalesLine."POI Item Attribute 2" <> vrc_PurchaseLine."POI Item Attribute 2") OR
                       (lrc_SalesLine."POI Item Attribute 4" <> vrc_PurchaseLine."POI Item Attribute 4") OR
                       (lrc_SalesLine."POI Coding Code" <> vrc_PurchaseLine."POI Coding Code") OR
                       (lrc_SalesLine."POI Item Attribute 5" <> vrc_PurchaseLine."POI Item Attribute 5") OR
                       (lrc_SalesLine."POI Item Attribute 6" <> vrc_PurchaseLine."POI Item Attribute 6") THEN BEGIN
                        lrc_SalesLine."POI Vendor Caliber Code" := vrc_PurchaseLine."POI Vendor Caliber Code";
                        lrc_SalesLine."POI Item Attribute 7" := vrc_PurchaseLine."POI Item Attribute 7";
                        lrc_SalesLine."POI Item Attribute 3" := vrc_PurchaseLine."POI Item Attribute 3";
                        lrc_SalesLine."POI Item Attribute 2" := vrc_PurchaseLine."POI Item Attribute 2";
                        lrc_SalesLine."POI Item Attribute 4" := vrc_PurchaseLine."POI Item Attribute 4";
                        lrc_SalesLine."POI Coding Code" := vrc_PurchaseLine."POI Coding Code";
                        lrc_SalesLine."POI Item Attribute 5" := vrc_PurchaseLine."POI Item Attribute 5";
                        lrc_SalesLine."POI Item Attribute 6" := vrc_PurchaseLine."POI Item Attribute 6";
                        vbn_Update := TRUE;
                    END;


                    // Aktualisierung der Info Felder
                    IF (lrc_SalesLine."POI Info 1" <> vrc_PurchaseLine."POI Info 1") OR
                       (lrc_SalesLine."POI Info 2" <> vrc_PurchaseLine."POI Info 2") OR
                       (lrc_SalesLine."POI Info 3" <> vrc_PurchaseLine."POI Info 3") OR
                       (lrc_SalesLine."POI Info 4" <> vrc_PurchaseLine."POI Info 4") THEN BEGIN
                        lrc_SalesLine."POI Info 1" := vrc_PurchaseLine."POI Info 1";
                        lrc_SalesLine."POI Info 2" := vrc_PurchaseLine."POI Info 2";
                        lrc_SalesLine."POI Info 3" := vrc_PurchaseLine."POI Info 3";
                        lrc_SalesLine."POI Info 4" := vrc_PurchaseLine."POI Info 4";
                        vbn_Update := TRUE;
                    END;

                    // Aktualisierung der Einheiten
                    IF lrc_SalesLine."Unit of Measure Code" <> vrc_PurchaseLine."Unit of Measure Code" THEN BEGIN
                        lrc_SalesLine.VALIDATE("Unit of Measure Code", vrc_PurchaseLine."Unit of Measure Code");
                        vbn_Update := TRUE;
                    END;

                    // Aktualisierung Leergutartikel
                    IF (lrc_SalesLine."POI Empties Item No." <> vrc_PurchaseLine."POI Empties Item No.") OR
                       (lrc_SalesLine."POI Empties Quantity" <> vrc_PurchaseLine."POI Empties Quantity") THEN BEGIN
                        lrc_SalesLine."POI Empties Item No." := vrc_PurchaseLine."POI Empties Item No.";
                        lrc_SalesLine."POI Empties Quantity" := vrc_PurchaseLine."POI Empties Quantity";
                        vbn_Update := TRUE;
                    END;

                    // Aktualisierung der Transportmittel
                    IF (lrc_SalesLine."POI Transp. Unit of Meas (TU)" <> vrc_PurchaseLine."POI Transport Unit of Meas(TU)") OR
                       (lrc_SalesLine."POI Qty.(Unit) per Transp.(TU)" <> vrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)") THEN BEGIN
                        lrc_SalesLine."POI Transp. Unit of Meas (TU)" := vrc_PurchaseLine."POI Transport Unit of Meas(TU)";
                        lrc_SalesLine.VALIDATE("POI Qty.(Unit) per Transp.(TU)", vrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)");
                        vbn_Update := TRUE;
                    END;

                    // Verk.-Preisbasis
                    //IF lrc_SalesLine."POI Price Base (Sales Price)" <> vrc_PurchaseLine."POI Price Base (Sales Price)" THEN BEGIN
                    //        lrc_SalesLine.VALIDATE("Price Base (Sales Price)",vrc_PurchaseLine."Price Base (Sales Price)");
                    //        vbn_Update := TRUE;
                    //END;

                    // Aktualisierung der Gewichte
                    IF (lrc_SalesLine."POI Weight" <> vrc_PurchaseLine."POI Weight") OR
                       (lrc_SalesLine."Net Weight" <> vrc_PurchaseLine."Net Weight") OR
                       (lrc_SalesLine."Gross Weight" <> vrc_PurchaseLine."Gross Weight") THEN BEGIN
                        lrc_SalesLine."POI Weight" := vrc_PurchaseLine."POI Weight";
                        lrc_SalesLine."Net Weight" := vrc_PurchaseLine."Net Weight";
                        lrc_SalesLine."Gross Weight" := vrc_PurchaseLine."Gross Weight";
                        lrc_SalesLine."POI Total Net Weight" := lrc_SalesLine."Net Weight" * lrc_SalesLine.Quantity;
                        lrc_SalesLine."POI Total Gross Weight" := lrc_SalesLine."Gross Weight" * lrc_SalesLine.Quantity;
                        vbn_Update := TRUE;
                    END;

                    // Validierung der Mengen und Preisfelder
                    IF vbn_Update = TRUE THEN BEGIN
                        lrc_SalesLine.VALIDATE(Quantity);
                        lrc_SalesLine.VALIDATE("POI Price Base (Sales Price)");
                        lrc_SalesLine.VALIDATE("Sales Price (Price Base)");
                        lrc_SalesLine.MODIFY();
                    END;

                END;
            UNTIL lrc_SalesLine.NEXT() = 0;
    end;

    procedure UpdateACW_SalesOrdFromPurchOrd(vrc_PurchaseLine: Record "Purchase Line"; vrc_xRecPurchaseLine: Record "Purchase Line")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lcu_ReleaseSalesDocument: Codeunit "Release Sales Document";
        //AGILES_TEXT001Txt: Label 'Do you want to transfer the changes in all sales lines ?';
        ldc_Differenz_Net_Gross_Weight: Decimal;
        lbn_SalesHeaderWasReleased: Boolean;

    begin
        // ------------------------------------------------------------------------------------------------------
        // Änderung des Durchschnittlichen Zollgewichtes in Einkaufsbestellung in alle VK Belegzeilen übertragen
        // ------------------------------------------------------------------------------------------------------
        lrc_FruitVisionSetup.GET();

        IF (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR
           (vrc_PurchaseLine."No." = '') OR
           (vrc_PurchaseLine."POI Master Batch No." = '') OR
           (vrc_PurchaseLine."POI Batch No." = '') OR
           (vrc_PurchaseLine."POI Batch Variant No." = '') THEN
            EXIT;

        IF ((vrc_PurchaseLine."POI Customs Weight (Average)" <> vrc_xRecPurchaseLine."POI Customs Weight (Average)") AND
             (vrc_PurchaseLine."POI Customs Weight (Average)" <> 0)) THEN BEGIN

            lrc_SalesLine.RESET();
            lrc_SalesLine.SETCURRENTKEY("Document Type", Type, "POI Master Batch No.", "POI Batch No.", "POI Batch Variant No.", "No.");
            lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
            lrc_SalesLine.SETRANGE("POI Master Batch No.", vrc_PurchaseLine."POI Master Batch No.");
            lrc_SalesLine.SETRANGE("POI Batch No.", vrc_PurchaseLine."POI Batch No.");
            lrc_SalesLine.SETRANGE("POI Batch Variant No.", vrc_PurchaseLine."POI Batch Variant No.");
            lrc_SalesLine.SETRANGE("No.", vrc_PurchaseLine."No.");
            IF lrc_SalesLine.FIND('-') THEN
                REPEAT

                    // wenn der Verkaufkopf freigegeben ist, diesem öffnen
                    lbn_SalesHeaderWasReleased := FALSE;
                    lrc_SalesHeader.GET(lrc_SalesLine."Document Type", lrc_SalesLine."Document No.");
                    IF lrc_SalesHeader.Status = lrc_SalesHeader.Status::Released THEN BEGIN
                        lbn_SalesHeaderWasReleased := TRUE;
                        lcu_ReleaseSalesDocument.Reopen(lrc_SalesHeader);
                    END;

                    IF (lrc_SalesLine."Gross Weight" <> 0) AND
                       (lrc_SalesLine."Gross Weight" <> 0) THEN BEGIN
                        ldc_Differenz_Net_Gross_Weight := lrc_SalesLine."Gross Weight" - lrc_SalesLine."Net Weight";
                        lrc_SalesLine.VALIDATE("Net Weight", vrc_PurchaseLine."POI Customs Weight (Average)");
                        IF lrc_FruitVisionSetup."Internal Customer Code" <> 'INTERWEICHERT' THEN
                            lrc_SalesLine.VALIDATE("Gross Weight", vrc_PurchaseLine."POI Customs Weight (Average)" +
                                                    ldc_Differenz_Net_Gross_Weight);
                    END ELSE
                        lrc_SalesLine.VALIDATE("Net Weight", vrc_PurchaseLine."POI Customs Weight (Average)");

                    lrc_SalesLine.MODIFY();

                    // Wenn Verkaufskopf freigegeben war, diesem wieder freigeben
                    IF lbn_SalesHeaderWasReleased = TRUE THEN
                        lcu_ReleaseSalesDocument.RUN(lrc_SalesHeader);

                UNTIL lrc_SalesLine.NEXT() = 0;
        END ELSE
            EXIT;
    end;

    procedure ShowPurchaseOrderLines(vco_ItemNo: Code[20]; vco_BatchVariantNo: Code[20])
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zum Anzeigen der Verkaufszeilen
        // ---------------------------------------------------------------------------------------
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code", "POI Batch Variant No.",
                                        "Drop Shipment", "Location Code", "Expected Receipt Date");
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
        lrc_PurchaseLine.SETRANGE("No.", vco_ItemNo);
        IF vco_BatchVariantNo <> '' THEN
            lrc_PurchaseLine.SETRANGE("POI Batch Variant No.", vco_BatchVariantNo);
        lrc_PurchaseLine.SETFILTER(Quantity, '<>%1', 0);

        Page.RUNMODAL(518, lrc_PurchaseLine);
    end;

    // procedure ChooseItemChargePurchaseDoc(vrc_PurchaseHeader: Record "Purchase Header")
    // var
    //     //lfm_CreatePurchaseItemCharge: Form "5110340";
    //     lco_PurchaseOrderNo: Code[100];
    //     lco_ItemChargeNo: Code[20];
    //     ldc_InvoiceAmount: Decimal;
    //     lop_Allocation: Option Kolli,Bruttogewicht,Nettogewicht,Paletten,"Anzahl Zeilen";
    //     lco_CostCategoryCode: Code[20];
    // begin
    //     // -----------------------------------------------------------------------------
    //     // Funktion zur Erstellung von Zu/Abschlagszeilen bezofen auf einen Einkauf
    //     // -----------------------------------------------------------------------------

    //     CASE vrc_PurchaseHeader."Document Type" OF
    //         vrc_PurchaseHeader."Document Type"::"Credit Memo":
    //             BEGIN
    //                 CLEAR(lfm_CreatePurchaseItemCharge);
    //                 lfm_CreatePurchaseItemCharge.SetCreateDocumentType(vrc_PurchaseHeader."Document Type"::"Credit Memo",
    //                      vrc_PurchaseHeader."Buy-from Vendor No.");
    //                 IF lfm_CreatePurchaseItemCharge.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                     // Erfasste Werte lesen
    //                     lfm_CreatePurchaseItemCharge.GetValues(lco_PurchaseOrderNo, lco_ItemChargeNo, ldc_InvoiceAmount,
    //                                                            lop_Allocation, lco_CostCategoryCode);
    //                     IF (lco_PurchaseOrderNo <> '') AND
    //                        (lco_ItemChargeNo <> '') THEN BEGIN
    //                         CreateItemChargePurchaseDoc(vrc_PurchaseHeader, lco_PurchaseOrderNo, lco_ItemChargeNo,
    //                                                           ldc_InvoiceAmount, lop_Allocation, lco_CostCategoryCode);
    //                     END;
    //                 END;
    //             END;
    //         vrc_PurchaseHeader."Document Type"::Invoice:
    //             BEGIN
    //                 CLEAR(lfm_CreatePurchaseItemCharge);
    //                 lfm_CreatePurchaseItemCharge.SetCreateDocumentType(vrc_PurchaseHeader."Document Type"::Invoice,
    //                      vrc_PurchaseHeader."Buy-from Vendor No.");
    //                 IF lfm_CreatePurchaseItemCharge.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                     // Erfasste Werte lesen
    //                     lfm_CreatePurchaseItemCharge.GetValues(lco_PurchaseOrderNo, lco_ItemChargeNo, ldc_InvoiceAmount,
    //                                                            lop_Allocation, lco_CostCategoryCode);
    //                     IF (lco_PurchaseOrderNo <> '') AND
    //                        (lco_ItemChargeNo <> '') THEN BEGIN
    //                         CreateItemChargePurchaseDoc(vrc_PurchaseHeader, lco_PurchaseOrderNo, lco_ItemChargeNo,
    //                                                     ldc_InvoiceAmount, lop_Allocation, lco_CostCategoryCode);
    //                     END;
    //                 END;
    //             END;
    //     END;
    // end;

    procedure CalcItemChargePurchaseDoc(vco_PurchaseOrderNo: Code[20]; var rdc_QtyColli: Decimal; var rdc_GrossWeight: Decimal; var rdc_NetWeight: Decimal; var rdc_QtyPaletts: Decimal; var rdc_NoOfLines: Decimal)
    var
        //SSPText001Txt: Label 'There are no purchase receipts for purchase order %1 !';
        //SSPText002Txt: Label 'Purchase Receipt';
        lbn_GenerateLine: Boolean;
        ldc_Quantity: Decimal;
    begin
        // -----------------------------------------------------------------------------------
        // Funktion zur Ermittlung der Gesamtsummen für die anschließende Kostenverteilung
        // -----------------------------------------------------------------------------------
        // vco_PurchaseOrderNo
        // rdc_QtyColli
        // rdc_GrossWeight
        // rdc_NetWeight
        // rdc_QtyPaletts
        // rdc_NoOfLines
        // -----------------------------------------------------------------------------------

        lrc_PurchRcptHeader.RESET();
        lrc_PurchRcptHeader.SETCURRENTKEY("Order No.");
        lrc_PurchRcptHeader.SETFILTER("Order No.", vco_PurchaseOrderNo);
        IF lrc_PurchRcptHeader.FIND('-') THEN
            REPEAT
                // Lieferungszeilen lesen
                lrc_PurchRcptLine.RESET();
                lrc_PurchRcptLine.SETRANGE("Document No.", lrc_PurchRcptHeader."No.");
                lrc_PurchRcptLine.SETRANGE(Type, lrc_PurchRcptLine.Type::Item);
                lrc_PurchRcptLine.SETFILTER("No.", '<>%1', '');
                lrc_PurchRcptLine.SETRANGE(Correction, FALSE);
                lrc_PurchRcptLine.SETFILTER(Quantity, '<>%1', 0);
                IF lrc_PurchRcptLine.FIND('-') THEN
                    REPEAT
                        lbn_GenerateLine := TRUE;

                        // Kontrolle ob die Liefermenge über alle Lieferzeilen größer Null ist
                        IF (lrc_PurchRcptLine."Order No." <> '') AND
                           (lrc_PurchRcptLine."Order Line No." <> 0) THEN BEGIN
                            lrc_PurchRcptLine2.RESET();
                            lrc_PurchRcptLine2.SETCURRENTKEY("Order No.", "Order Line No.", "Posting Date");
                            lrc_PurchRcptLine2.SETRANGE("Document No.", lrc_PurchRcptLine."Document No.");
                            lrc_PurchRcptLine2.SETRANGE("Order No.", lrc_PurchRcptLine."Order No.");
                            lrc_PurchRcptLine2.SETRANGE("Order Line No.", lrc_PurchRcptLine."Order Line No.");
                            ldc_Quantity := 0;
                            IF lrc_PurchRcptLine2.FIND('-') THEN BEGIN
                                REPEAT
                                    ldc_Quantity := ldc_Quantity + lrc_PurchRcptLine2.Quantity;
                                UNTIL lrc_PurchRcptLine2.NEXT() = 0;
                                IF ldc_Quantity <= 0 THEN
                                    lbn_GenerateLine := FALSE;
                            END;
                        END;

                        // Werte summieren
                        IF lbn_GenerateLine = TRUE THEN BEGIN
                            // Summe Kolli ermitteln
                            rdc_QtyColli := rdc_QtyColli + lrc_PurchRcptLine.Quantity;
                            // Summe Gewicht Brutto ermitteln
                            rdc_GrossWeight := rdc_GrossWeight + lrc_PurchRcptLine."POI Total Gross Weight";
                            // Summe Gewicht Netto ermitteln
                            rdc_NetWeight := rdc_NetWeight + lrc_PurchRcptLine."POI Total Net Weight";
                            // Summe Paletten ermitteln
                            rdc_QtyPaletts := rdc_QtyPaletts + lrc_PurchRcptLine."POI Quantity (TU)";
                            // Summe Zeilen ermitteln
                            rdc_NoOfLines := rdc_NoOfLines + 1;
                        END;

                    UNTIL lrc_PurchRcptLine.NEXT() = 0;
            UNTIL lrc_PurchRcptHeader.NEXT() = 0;
    end;

    procedure CreateItemChargePurchaseDoc(vrc_PurchaseHeader: Record "Purchase Header"; vco_PurchaseOrderNo: Code[20]; vco_ItemChargeNo: Code[20]; vdc_InvoiceAmount: Decimal; vop_Allocation: Option Kolli,Bruttogewicht,Nettogewicht,Paletten,"Anzahl Zeilen"; vco_CostCategory: Code[20])
    var
        lrc_ItemChargeAssignPurch: Record "Item Charge Assignment (Purch)";
        lin_LineNo: Integer;
        SSPText002Txt: Label 'Purchase Receipt';
        lbn_GenerateLine: Boolean;
        ldc_Quantity: Decimal;
        ldc_DirectUnitCost: Decimal;
        ldc_QtyColli: Decimal;
        ldc_GrossWeight: Decimal;
        ldc_NetWeight: Decimal;
        ldc_QtyPaletts: Decimal;
        ldc_NoOfLines: Decimal;
        SSPText001Txt: Label 'There are no purchase receipts for purchase order %1 !', Comment = '%1';
    begin
        // -----------------------------------------------------------------------------
        //
        // -----------------------------------------------------------------------------
        // vrc_PurchaseHeader
        // vco_PurchaseOrderNo
        // vco_ItemChargeNo
        // -----------------------------------------------------------------------------

        // Leztze Zeilennummer Einkaufsbelege ermitteln
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.INIT();
        lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        IF lrc_PurchaseLine.FIND('+') THEN
            lin_LineNo := lrc_PurchaseLine."Line No."
        ELSE
            lin_LineNo := 0;
        IF vdc_InvoiceAmount <> 0 THEN
            CalcItemChargePurchaseDoc(vco_PurchaseOrderNo, ldc_QtyColli, ldc_GrossWeight,
                                      ldc_NetWeight, ldc_QtyPaletts, ldc_NoOfLines);
        lrc_PurchRcptHeader.RESET();
        lrc_PurchRcptHeader.SETCURRENTKEY("Order No.");
        lrc_PurchRcptHeader.SETFILTER("Order No.", vco_PurchaseOrderNo);
        IF lrc_PurchRcptHeader.FIND('-') THEN
            REPEAT
                // Textzeile mit Info bezogene Lieferung
                lin_LineNo := lin_LineNo + 10000;
                lrc_PurchaseLine.RESET();
                lrc_PurchaseLine.INIT();
                lrc_PurchaseLine.VALIDATE("Document Type", vrc_PurchaseHeader."Document Type");
                lrc_PurchaseLine.VALIDATE("Document No.", vrc_PurchaseHeader."No.");
                lrc_PurchaseLine.VALIDATE("Line No.", lin_LineNo);
                lrc_PurchaseLine.VALIDATE("Buy-from Vendor No.", vrc_PurchaseHeader."Buy-from Vendor No.");
                lrc_PurchaseLine.INSERT(TRUE);
                lrc_PurchaseLine.VALIDATE(Type, lrc_PurchaseLine.Type::" ");
                lrc_PurchaseLine.VALIDATE(Description, SSPText002Txt + ' ' + lrc_PurchRcptHeader."No.");
                lrc_PurchaseLine.MODIFY(TRUE);
                // Lieferungszeilen lesen
                lrc_PurchRcptLine.RESET();
                lrc_PurchRcptLine.SETRANGE("Document No.", lrc_PurchRcptHeader."No.");
                lrc_PurchRcptLine.SETRANGE(Type, lrc_PurchRcptLine.Type::Item);
                lrc_PurchRcptLine.SETFILTER("No.", '<>%1', '');
                lrc_PurchRcptLine.SETRANGE(Correction, FALSE);
                lrc_PurchRcptLine.SETFILTER(Quantity, '<>%1', 0);
                IF lrc_PurchRcptLine.FIND('-') THEN
                    REPEAT
                        // Kontrolle ob die Liefermenge über alle Lieferzeilen größer Null ist
                        lbn_GenerateLine := TRUE;
                        IF (lrc_PurchRcptLine."Order No." <> '') AND
                           (lrc_PurchRcptLine."Order Line No." <> 0) THEN BEGIN
                            lrc_PurchRcptLine2.RESET();
                            lrc_PurchRcptLine2.SETCURRENTKEY("Order No.", "Order Line No.", "Posting Date");
                            lrc_PurchRcptLine2.SETRANGE("Document No.", lrc_PurchRcptLine."Document No.");
                            lrc_PurchRcptLine2.SETRANGE("Order No.", lrc_PurchRcptLine."Order No.");
                            lrc_PurchRcptLine2.SETRANGE("Order Line No.", lrc_PurchRcptLine."Order Line No.");
                            ldc_Quantity := 0;
                            IF lrc_PurchRcptLine2.FIND('-') THEN BEGIN
                                REPEAT
                                    ldc_Quantity := ldc_Quantity + lrc_PurchRcptLine2.Quantity;
                                UNTIL lrc_PurchRcptLine2.NEXT() = 0;
                                IF ldc_Quantity <= 0 THEN
                                    lbn_GenerateLine := FALSE;
                            END;
                        END;

                        // Einkaufszeile mit Zu-/Abschlagsartikel erstellen
                        IF lbn_GenerateLine = TRUE THEN BEGIN

                            lin_LineNo := lin_LineNo + 10000;
                            lrc_PurchaseLine.RESET();
                            lrc_PurchaseLine.INIT();
                            lrc_PurchaseLine.VALIDATE("Document Type", vrc_PurchaseHeader."Document Type");
                            lrc_PurchaseLine.VALIDATE("Document No.", vrc_PurchaseHeader."No.");
                            lrc_PurchaseLine.VALIDATE("Line No.", lin_LineNo);
                            lrc_PurchaseLine.VALIDATE("Buy-from Vendor No.", vrc_PurchaseHeader."Buy-from Vendor No.");
                            lrc_PurchaseLine.INSERT(TRUE);

                            lrc_PurchaseLine.VALIDATE(Type, lrc_PurchaseLine.Type::"Charge (Item)");
                            lrc_PurchaseLine.VALIDATE("No.", vco_ItemChargeNo);
                            lrc_PurchaseLine.VALIDATE(Quantity, 1);
                            lrc_PurchaseLine.VALIDATE(Description, lrc_PurchRcptLine.Description);
                            lrc_PurchaseLine.VALIDATE("Description 2", lrc_PurchRcptLine."Description 2");

                            lrc_PurchaseLine.VALIDATE("POI Item Charg Batch Var. Code", lrc_PurchRcptLine."POI Batch Var Code Item Charge");
                            lrc_PurchaseLine.VALIDATE("POI Item Charge Quantity", lrc_PurchRcptLine."POI Quantity Item Charge");

                            IF lrc_PurchRcptLine."Shortcut Dimension 1 Code" <> '' THEN
                                lrc_PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", lrc_PurchRcptLine."Shortcut Dimension 1 Code");
                            IF lrc_PurchRcptLine."Shortcut Dimension 2 Code" <> '' THEN
                                lrc_PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", lrc_PurchRcptLine."Shortcut Dimension 2 Code");
                            IF lrc_PurchRcptLine."POI Shortcut Dimension 3 Code" <> '' THEN
                                lrc_PurchaseLine.VALIDATE("POI Shortcut Dimension 3 Code", lrc_PurchRcptLine."POI Shortcut Dimension 3 Code");
                            IF lrc_PurchRcptLine."POI Shortcut Dimension 4 Code" <> '' THEN
                                lrc_PurchaseLine.VALIDATE("POI Shortcut Dimension 4 Code", lrc_PurchRcptLine."POI Shortcut Dimension 4 Code");
                            IF lrc_PurchRcptLine."POI Master Batch No." <> '' THEN
                                lrc_PurchaseLine.VALIDATE("POI Master Batch No.", lrc_PurchRcptLine."POI Master Batch No.");
                            IF lrc_PurchRcptLine."POI Batch No." <> '' THEN
                                // Kein VALIDATE!!
                                lrc_PurchaseLine."POI Batch No." := lrc_PurchRcptLine."POI Batch No.";
                            lrc_PurchaseLine.MODIFY(TRUE);


                            // Zugehörige ZU-/Abschlagszuweisungszeile erstellen
                            lrc_ItemChargeAssignPurch.INIT();
                            lrc_ItemChargeAssignPurch.VALIDATE("Document Type", lrc_PurchaseLine."Document Type");
                            lrc_ItemChargeAssignPurch.VALIDATE("Document No.", lrc_PurchaseLine."Document No.");
                            lrc_ItemChargeAssignPurch.VALIDATE("Document Line No.", lrc_PurchaseLine."Line No.");
                            lrc_ItemChargeAssignPurch.VALIDATE("Line No.", 10000);
                            lrc_ItemChargeAssignPurch.VALIDATE("Item Charge No.", vco_ItemChargeNo);
                            lrc_ItemChargeAssignPurch.VALIDATE("Item No.", lrc_PurchRcptLine."No.");
                            lrc_ItemChargeAssignPurch.VALIDATE(Description, lrc_PurchRcptLine.Description);
                            lrc_ItemChargeAssignPurch.VALIDATE("Applies-to Doc. Type",
                                                                lrc_ItemChargeAssignPurch."Applies-to Doc. Type"::Receipt);
                            lrc_ItemChargeAssignPurch.VALIDATE("Applies-to Doc. No.", lrc_PurchRcptLine."Document No.");
                            lrc_ItemChargeAssignPurch.VALIDATE("Applies-to Doc. Line No.", lrc_PurchRcptLine."Line No.");
                            lrc_ItemChargeAssignPurch.VALIDATE("Qty. to Assign", 1);
                            lrc_ItemChargeAssignPurch.INSERT(TRUE);


                            // Zeilenbetrag berechnen falls Gesamtbetrag übergeben wurde
                            IF vdc_InvoiceAmount <> 0 THEN BEGIN
                                ldc_DirectUnitCost := 0;
                                CASE vop_Allocation OF
                                    vop_Allocation::Kolli:
                                        ldc_DirectUnitCost := lrc_PurchRcptLine.Quantity / ldc_QtyColli * vdc_InvoiceAmount;
                                    vop_Allocation::Bruttogewicht:
                                        ldc_DirectUnitCost := lrc_PurchRcptLine."POI Total Gross Weight" / ldc_GrossWeight * vdc_InvoiceAmount;
                                    vop_Allocation::Nettogewicht:
                                        ldc_DirectUnitCost := lrc_PurchRcptLine."POI Total Net Weight" / ldc_NetWeight * vdc_InvoiceAmount;
                                    vop_Allocation::Paletten:
                                        ldc_DirectUnitCost := lrc_PurchRcptLine."POI Quantity (TU)" / ldc_QtyPaletts * vdc_InvoiceAmount;
                                    vop_Allocation::"Anzahl Zeilen":
                                        ldc_DirectUnitCost := vdc_InvoiceAmount / ldc_NoOfLines;
                                END;
                                ldc_DirectUnitCost := ROUND(ldc_DirectUnitCost, 0.00001);
                                lrc_PurchaseLine.VALIDATE("Direct Unit Cost", ldc_DirectUnitCost);
                                lrc_PurchaseLine.MODIFY();
                            END;
                        END;
                    UNTIL lrc_PurchRcptLine.NEXT() = 0;
            UNTIL lrc_PurchRcptHeader.NEXT() = 0
        ELSE
            ERROR(SSPText001Txt, vco_PurchaseOrderNo);
    end;


    procedure GetLastPurchPrice(vrc_PurchLine: Record "Purchase Line"): Decimal
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Ermittlung des letzten Einkaufspreises
        // -----------------------------------------------------------------------------

        IF vrc_PurchLine."Document Type" <> vrc_PurchLine."Document Type"::Order THEN
            EXIT(0);
        IF (vrc_PurchLine.Type <> vrc_PurchLine.Type::Item) OR (vrc_PurchLine."No." = '') THEN
            EXIT(0);

        lrc_PurchLine.SETRANGE("Document Type", vrc_PurchLine."Document Type");
        lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
        lrc_PurchLine.SETRANGE("No.", vrc_PurchLine."No.");
        lrc_PurchLine.SETRANGE("Unit of Measure Code", vrc_PurchLine."Unit of Measure Code");
        lrc_PurchLine.SETFILTER("Document No.", '<>%1', vrc_PurchLine."Document No.");
        lrc_PurchLine.SETFILTER("Line No.", '<>%1', vrc_PurchLine."Line No.");
        IF lrc_PurchLine.FIND('+') THEN
            EXIT(lrc_PurchLine."Direct Unit Cost");

        EXIT(0);
    end;

    procedure Erzeugerabrechnung(vrc_PurchHdr: Record "Purchase Header")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Vendor: Record Vendor;
        lrc_CostSchemaName: Record "POI Cost Schema Name";
        ldc_Amount: Decimal;
        ldc_Quantity: Decimal;
        lin_LineNo: Integer;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Berechnung der Werte für Sachkontenabrechnung
        // -----------------------------------------------------------------------------

        lrc_FruitVisionSetup.GET();
        lrc_FruitVisionSetup.TESTFIELD("Prod. Stat. Cost Schema Name");

        lrc_Vendor.GET(vrc_PurchHdr."Buy-from Vendor No.");

        lrc_CostSchemaName.GET(lrc_FruitVisionSetup."Prod. Stat. Cost Schema Name");

        // Letzte Zeilennr. feststellen
        lrc_PurchLine2.RESET();
        lrc_PurchLine2.SETRANGE("Document Type", vrc_PurchHdr."Document Type");
        lrc_PurchLine2.SETRANGE("Document No.", vrc_PurchHdr."No.");
        IF lrc_PurchLine2.FIND('+') THEN
            lin_LineNo := lrc_PurchLine2."Line No."
        ELSE
            lin_LineNo := 0;


        lrc_CostSchemaLine.SETRANGE("Cost Schema Code", lrc_CostSchemaName.Code);
        lrc_CostSchemaLine.SETRANGE("Totaling Type", lrc_CostSchemaLine."Totaling Type"::"Cost Category");
        IF lrc_CostSchemaLine.FIND('-') THEN
            REPEAT
                ldc_Amount := 0;
                ldc_Quantity := 0;
                // --------------------------------------------------------------------------
                // Einkaufszeilen lesen und Werte berechnen
                // --------------------------------------------------------------------------
                lrc_PurchLine.RESET();
                lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHdr."Document Type");
                lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHdr."No.");
                lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
                lrc_PurchLine.SETFILTER("No.", '<>%1', '');
                IF lrc_PurchLine.FIND('-') THEN
                    REPEAT
                        lrc_Erzeugerabrechnung.SETRANGE("Cost Category Code", lrc_CostSchemaLine.Totaling);
                        lrc_Erzeugerabrechnung.SETFILTER("Product Group Code", '%1|%2', lrc_PurchLine."POI Product Group Code", '');
                        lrc_Erzeugerabrechnung.SETFILTER("Item No.", '%1|%2', lrc_PurchLine."No.", '');
                        lrc_Erzeugerabrechnung.SETFILTER("Vendor No.", '%1|%2', lrc_PurchLine."Buy-from Vendor No.", '');
                        lrc_Erzeugerabrechnung.SETFILTER("Member of Prod. Companionship", '%1|%2', lrc_Vendor."POI Member of Prod.Companionsh", '');
                        lrc_Erzeugerabrechnung.SETFILTER("Member State Companionship", '%1|%2', lrc_Vendor."POI Member State Companionship", 0);
                        IF lrc_Erzeugerabrechnung.FIND('+') THEN BEGIN
                            CASE lrc_Erzeugerabrechnung.Typ OF
                                lrc_Erzeugerabrechnung.Typ::Percentage:
                                    ldc_Amount := ldc_Amount + ((lrc_PurchLine."Direct Unit Cost" * lrc_PurchLine.Quantity) * (lrc_Erzeugerabrechnung.Value / 100));
                                lrc_Erzeugerabrechnung.Typ::Amount:
                                    ldc_Amount := ldc_Amount + lrc_Erzeugerabrechnung.Value;
                            END;
                            ldc_Quantity := ldc_Quantity + lrc_PurchLine.Quantity;
                        END;

                    UNTIL lrc_PurchLine.NEXT() = 0;

                // Sachkonto ermitteln
                lrc_CostCategoryAccounts.RESET();
                lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", lrc_CostSchemaLine.Totaling);
                lrc_CostCategoryAccounts.FIND('-');
                lrc_CostCategoryAccounts.TESTFIELD("G/L Account No.");

                // Kontrolle ob es den Eintrag bereits gibt
                lrc_PurchLine2.RESET();
                lrc_PurchLine2.SETRANGE("Document Type", vrc_PurchHdr."Document Type");
                lrc_PurchLine2.SETRANGE("Document No.", vrc_PurchHdr."No.");
                lrc_PurchLine2.SETRANGE(Type, lrc_PurchLine2.Type::"G/L Account");
                lrc_PurchLine2.SETRANGE("No.", lrc_CostCategoryAccounts."G/L Account No.");
                IF lrc_PurchLine2.FIND('-') THEN BEGIN
                    // Satz aktualisieren
                    IF ldc_Amount <> 0 THEN BEGIN
                        lrc_PurchLine2.VALIDATE("Direct Unit Cost", (ROUND((ldc_Amount / ldc_Quantity), 0.00001)));
                        lrc_PurchLine2.VALIDATE(Quantity, ldc_Quantity);
                        lrc_PurchLine2.MODIFY();
                        // Satz löschen
                    END ELSE
                        lrc_PurchLine2.DELETE(TRUE);
                END ELSE
                    // Neuen Satz anlegen
                    IF ldc_Amount <> 0 THEN BEGIN
                        lrc_PurchLine2.RESET();
                        lrc_PurchLine2.INIT();
                        lrc_PurchLine2."Document Type" := vrc_PurchHdr."Document Type";
                        lrc_PurchLine2."Document No." := vrc_PurchHdr."No.";
                        lin_LineNo := lin_LineNo + 10000;
                        lrc_PurchLine2."Line No." := lin_LineNo;
                        lrc_PurchLine2.VALIDATE("Buy-from Vendor No.", vrc_PurchHdr."Buy-from Vendor No.");
                        lrc_PurchLine2.VALIDATE("Pay-to Vendor No.", vrc_PurchHdr."Pay-to Vendor No.");
                        lrc_PurchLine2.VALIDATE(Type, lrc_PurchLine2.Type::"G/L Account");
                        lrc_PurchLine2.INSERT();
                        lrc_PurchLine2.VALIDATE("No.", lrc_CostCategoryAccounts."G/L Account No.");
                        lrc_PurchLine2.VALIDATE("Direct Unit Cost", (ROUND((ldc_Amount / ldc_Quantity), 0.00001)));
                        lrc_PurchLine2.VALIDATE(Quantity, ldc_Quantity);
                        lrc_PurchLine2.MODIFY();
                    END;
            UNTIL lrc_CostSchemaLine.NEXT() = 0;
    end;

    procedure CreateCrMemoLineFromShipment(var rrc_PurchaseLine: Record "Purchase Line")
    var
        Errorlabel: Text;
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur Erstellung einer Gutschriftszeile über Auswahl der Lieferung
        // -----------------------------------------------------------------------------

        rrc_PurchaseLine.TESTFIELD("Line No.");

        CASE rrc_PurchaseLine.Type OF
            rrc_PurchaseLine.Type::Item:
                CrMemoItem(rrc_PurchaseLine);
            rrc_PurchaseLine.Type::"Charge (Item)":
                BEGIN
                    rrc_PurchaseLine.TESTFIELD("No.");
                    CrMemoChargeItem(rrc_PurchaseLine);
                END;
            ELSE begin
                    ErrorLabel := 'Für Satzart ' + FORMAT(rrc_PurchaseLine.Type) + ' nicht zulässig!';
                    ERROR(ErrorLabel);
                end;
        END;
    end;

    procedure CrMemoChargeItem(var rrc_PurchaseLine: Record "Purchase Line")
    var
    //Currency: Record Currency;
    //lcu_ItemChargeAssgntPurchase: Codeunit "Item Charge Assgnt. (Purch.)";
    //lfm_PurchReceiptLines: Form "5806";
    //ldc_UnitCost: Decimal;
    begin
        // -----------------------------------------------------------------------------
        // Auswahl Lieferung und Erstellung Zu-/Abschlagszeile
        // -----------------------------------------------------------------------------
        rrc_PurchaseLine.TESTFIELD(Type, rrc_PurchaseLine.Type::"Charge (Item)");
        rrc_PurchaseLine.TESTFIELD("No.");
        rrc_PurchaseLine.TESTFIELD(Quantity);
        lrc_PurchaseHeader.GET(rrc_PurchaseLine."Document Type", rrc_PurchaseLine."Document No.");
        lrc_ItemChargeAssignPurchase.RESET();
        lrc_ItemChargeAssignPurchase.SETRANGE("Document Type", rrc_PurchaseLine."Document Type");
        lrc_ItemChargeAssignPurchase.SETRANGE("Document No.", rrc_PurchaseLine."Document No.");
        lrc_ItemChargeAssignPurchase.SETRANGE("Document Line No.", rrc_PurchaseLine."Line No.");
        IF NOT lrc_ItemChargeAssignPurchase.FINDFIRST() THEN BEGIN
            lrc_ItemChargeAssignPurchase.RESET();
            lrc_ItemChargeAssignPurchase.INIT();
            lrc_ItemChargeAssignPurchase."Document Type" := rrc_PurchaseLine."Document Type";
            lrc_ItemChargeAssignPurchase."Document No." := rrc_PurchaseLine."Document No.";
            lrc_ItemChargeAssignPurchase."Document Line No." := rrc_PurchaseLine."Line No.";
            lrc_ItemChargeAssignPurchase."Item Charge No." := rrc_PurchaseLine."No.";
            lrc_ItemChargeAssignPurchase.SETRANGE("Document Type", rrc_PurchaseLine."Document Type");
            lrc_ItemChargeAssignPurchase.SETRANGE("Document No.", rrc_PurchaseLine."Document No.");
            lrc_ItemChargeAssignPurchase.SETRANGE("Document Line No.", rrc_PurchaseLine."Line No.");
            lrc_PurchRcptLine.RESET();
            lrc_PurchRcptLine.SETRANGE("Buy-from Vendor No.", lrc_PurchaseHeader."Buy-from Vendor No.");
            // lfm_PurchReceiptLines.SETTABLEVIEW(lrc_PurchRcptLine);  //TODO: page
            // lfm_PurchReceiptLines.Initialize(lrc_ItemChargeAssignPurchase, ldc_UnitCost);
            // ////  lfm_PurchReceiptLines.InitializeExpectedReceiptDate(lrc_PurchaseHeader."Ref. Ship. Date (Cr. Memo)");
            // lfm_PurchReceiptLines.LOOKUPMODE(TRUE);
            // IF lfm_PurchReceiptLines.RUNMODAL <> ACTION::LookupOK THEN
            //     EXIT;
            lrc_ItemChargeAssignPurchase.RESET();
            lrc_ItemChargeAssignPurchase.SETRANGE("Document Type", rrc_PurchaseLine."Document Type");
            lrc_ItemChargeAssignPurchase.SETRANGE("Document No.", rrc_PurchaseLine."Document No.");
            lrc_ItemChargeAssignPurchase.SETRANGE("Document Line No.", rrc_PurchaseLine."Line No.");
            IF lrc_ItemChargeAssignPurchase.FINDFIRST() THEN
                IF lrc_ItemChargeAssignPurchase."Applies-to Doc. Type" =
                   lrc_ItemChargeAssignPurchase."Applies-to Doc. Type"::Receipt THEN BEGIN
                    lrc_PurchRcptLine.RESET();
                    lrc_PurchRcptLine.GET(lrc_ItemChargeAssignPurchase."Applies-to Doc. No.", lrc_ItemChargeAssignPurchase."Applies-to Doc. Line No.");
                    rrc_PurchaseLine."POI Reference Doc. No." := lrc_PurchRcptLine."Document No.";
                    rrc_PurchaseLine."POI Reference Doc. Line No." := lrc_PurchRcptLine."Line No.";
                    rrc_PurchaseLine."POI Reference Item No." := lrc_PurchRcptLine."No.";
                    rrc_PurchaseLine."Location Code" := lrc_PurchRcptLine."Location Code";
                    rrc_PurchaseLine.VALIDATE("Unit of Measure Code", lrc_PurchRcptLine."Unit of Measure Code");
                    rrc_PurchaseLine.VALIDATE(Quantity, lrc_PurchRcptLine.Quantity);
                    rrc_PurchaseLine.VALIDATE("Direct Unit Cost", lrc_PurchRcptLine."Direct Unit Cost");
                    rrc_PurchaseLine."POI Base Unit of Measure (BU)" := lrc_PurchRcptLine."POI Base Unit of Measure (BU)";
                    rrc_PurchaseLine."POI Packing Unit of Meas (PU)" := lrc_PurchRcptLine."POI Packing Unit of Meas (PU)";
                    rrc_PurchaseLine."POI Content Unit of Meas (COU)" := lrc_PurchRcptLine."POI Content Unit of Meas (COU)";
                    rrc_PurchaseLine."POI Transport Unit of Meas(TU)" := lrc_PurchRcptLine."POI Transport Unit of Meas(TU)";
                    rrc_PurchaseLine."Qty. per Unit of Measure" := lrc_PurchRcptLine."Qty. per Unit of Measure";
                    rrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)" := lrc_PurchRcptLine."POI Qty.(Unit) per Pallet(TU)";
                    rrc_PurchaseLine."POI Qty. (PU) per Unit of Meas" := lrc_PurchRcptLine."POI Qty. (PU) per Unit of Meas";
                    rrc_PurchaseLine."POI Quantity (PU)" := lrc_PurchRcptLine."POI Quantity (PU)";
                    rrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)" := lrc_PurchRcptLine."POI Qty.(Unit) per Pallet(TU)";
                    rrc_PurchaseLine."POI Quantity (TU)" := lrc_PurchRcptLine."POI Quantity (TU)";
                    rrc_PurchaseLine."POI Qty.(COU) p Pack. Unit(PU)" := lrc_PurchRcptLine."POI Qty.(COU) p Pack. Unit(PU)";
                    rrc_PurchaseLine."POI Price Base (Purch. Price)" := lrc_PurchRcptLine."POI Price Base (Purch. Price)";
                    rrc_PurchaseLine."POI Purch. Price (Price Base)" := lrc_PurchRcptLine."POI Purch. Price (Price Base)";
                    rrc_PurchaseLine.Description := lrc_PurchRcptLine.Description;
                    rrc_PurchaseLine."Description 2" := lrc_PurchRcptLine."Description 2";
                    rrc_PurchaseLine."POI Country of Origin Code" := lrc_PurchRcptLine."POI Country of Origin Code";
                    rrc_PurchaseLine."POI Variety Code" := lrc_PurchRcptLine."POI Variety Code";
                    rrc_PurchaseLine."POI Trademark Code" := lrc_PurchRcptLine."POI Trademark Code";
                    rrc_PurchaseLine."POI Caliber Code" := lrc_PurchRcptLine."POI Caliber Code";
                    rrc_PurchaseLine."POI Vendor Caliber Code" := lrc_PurchRcptLine."POI Vendor Caliber Code";
                    rrc_PurchaseLine."POI Item Attribute 3" := lrc_PurchRcptLine."POI Quality Code";
                    rrc_PurchaseLine."POI Item Attribute 2" := lrc_PurchRcptLine."POI Color Code";
                    rrc_PurchaseLine."POI Grade of Goods Code" := lrc_PurchRcptLine."POI Grade of Goods Code";
                    rrc_PurchaseLine."POI Item Attribute 7" := lrc_PurchRcptLine."POI Conservation Code";
                    rrc_PurchaseLine."POI Item Attribute 4" := lrc_PurchRcptLine."POI Packing Code";
                    rrc_PurchaseLine."POI Coding Code" := lrc_PurchRcptLine."POI Coding Code";
                    rrc_PurchaseLine."POI Item Attribute 5" := lrc_PurchRcptLine."POI Treatment Code";
                    rrc_PurchaseLine."POI Item Attribute 6" := lrc_PurchRcptLine."POI Proper Name Code";
                    rrc_PurchaseLine."Gross Weight" := lrc_PurchRcptLine."Gross Weight";
                    rrc_PurchaseLine."Net Weight" := lrc_PurchRcptLine."Net Weight";
                    rrc_PurchaseLine."POI Total Gross Weight" := rrc_PurchaseLine."Gross Weight" * rrc_PurchaseLine.Quantity;
                    rrc_PurchaseLine."POI Total Net Weight" := rrc_PurchaseLine."Net Weight" * rrc_PurchaseLine.Quantity;
                    rrc_PurchaseLine."POI Master Batch No." := lrc_PurchRcptLine."POI Master Batch No.";
                    rrc_PurchaseLine."POI Batch No." := lrc_PurchRcptLine."POI Batch No.";
                    rrc_PurchaseLine."POI Batch Variant No." := lrc_PurchRcptLine."POI Batch Variant No.";

                    //      lrc_ItemChargeAssignPurchase.VALIDATE("Qty. to Assign",rrc_PurchaseLine.Quantity);
                    //      lrc_ItemChargeAssignPurchase.MODIFY();

                END ELSE BEGIN
                    lrc_ItemChargeAssignPurchase.VALIDATE("Qty. to Assign", rrc_PurchaseLine.Quantity);
                    lrc_ItemChargeAssignPurchase.MODIFY();
                    rrc_PurchaseLine.Description := lrc_ItemChargeAssignPurchase.Description;
                END;

        END ELSE
            rrc_PurchaseLine.ShowItemChargeAssgnt();
    end;

    procedure UpdateCrMemoChargeItem(vrc_PurchaseHeader: Record "Purchase Header")
    var
        //Currency: Record Currency;
        //lcu_ItemChargeAssgntPurchase: Codeunit "Item Charge Assgnt. (Purch.)";
        //lfm_PurchReceiptLines: Form "5806";
        //ldc_UnitCost: Decimal;
        ldc_Quantity: Decimal;
    begin
        // -----------------------------------------------------------------------------
        // Rekalkulation Zu-/Abschlagszeile in Gutschrift bei Referenz auf Lieferung
        // -----------------------------------------------------------------------------

        IF vrc_PurchaseHeader."Document Type" <> vrc_PurchaseHeader."Document Type"::"Credit Memo" THEN
            EXIT;

        lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::"Charge (Item)");
        lrc_PurchaseLine.SETFILTER("No.", '<>%1', '');
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT

                lrc_PurchRcptLine.RESET();
                lrc_PurchRcptLine.GET(lrc_PurchaseLine."POI Reference Doc. No.", lrc_PurchaseLine."POI Reference Doc. Line No.");

                // Bestehende Menge merken
                ldc_Quantity := lrc_PurchaseLine.Quantity;

                lrc_PurchaseLine."POI Reference Item No." := lrc_PurchRcptLine."No.";

                lrc_PurchaseLine."Location Code" := lrc_PurchRcptLine."Location Code";
                lrc_PurchaseLine.VALIDATE("Unit of Measure Code", lrc_PurchRcptLine."Unit of Measure Code");
                lrc_PurchaseLine.VALIDATE(Quantity, ldc_Quantity);
                lrc_PurchaseLine.VALIDATE("Direct Unit Cost", lrc_PurchRcptLine."Direct Unit Cost");

                lrc_PurchaseLine."POI Base Unit of Measure (BU)" := lrc_PurchRcptLine."POI Base Unit of Measure (BU)";
                lrc_PurchaseLine."POI Packing Unit of Meas (PU)" := lrc_PurchRcptLine."POI Packing Unit of Meas (PU)";
                lrc_PurchaseLine."POI Content Unit of Meas (COU)" := lrc_PurchRcptLine."POI Content Unit of Meas (COU)";
                lrc_PurchaseLine."POI Transport Unit of Meas(TU)" := lrc_PurchRcptLine."POI Transport Unit of Meas(TU)";
                lrc_PurchaseLine."Qty. per Unit of Measure" := lrc_PurchRcptLine."Qty. per Unit of Measure";
                lrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)" := lrc_PurchRcptLine."POI Qty.(Unit) per Pallet(TU)";
                lrc_PurchaseLine."POI Qty. (PU) per Unit of Meas" := lrc_PurchRcptLine."POI Qty. (PU) per Unit of Meas";
                lrc_PurchaseLine."POI Quantity (PU)" := lrc_PurchRcptLine."POI Quantity (PU)";
                lrc_PurchaseLine."POI Qty. (Unit) per Transp(TU)" := lrc_PurchRcptLine."POI Qty.(Unit) per Pallet(TU)";
                lrc_PurchaseLine."POI Quantity (TU)" := lrc_PurchRcptLine."POI Quantity (TU)";
                lrc_PurchaseLine."POI Qty.(COU) p Pack. Unit(PU)" := lrc_PurchRcptLine."POI Qty.(COU) p Pack. Unit(PU)";

                lrc_PurchaseLine."POI Price Base (Purch. Price)" := lrc_PurchRcptLine."POI Price Base (Purch. Price)";
                lrc_PurchaseLine."POI Purch. Price (Price Base)" := lrc_PurchRcptLine."POI Purch. Price (Price Base)";

                lrc_PurchaseLine.Description := lrc_PurchRcptLine.Description;
                lrc_PurchaseLine."Description 2" := lrc_PurchRcptLine."Description 2";

                lrc_PurchaseLine."POI Country of Origin Code" := lrc_PurchRcptLine."POI Country of Origin Code";
                lrc_PurchaseLine."POI Variety Code" := lrc_PurchRcptLine."POI Variety Code";
                lrc_PurchaseLine."POI Trademark Code" := lrc_PurchRcptLine."POI Trademark Code";
                lrc_PurchaseLine."POI Caliber Code" := lrc_PurchRcptLine."POI Caliber Code";
                lrc_PurchaseLine."POI Vendor Caliber Code" := lrc_PurchRcptLine."POI Vendor Caliber Code";
                lrc_PurchaseLine."POI Item Attribute 3" := lrc_PurchRcptLine."POI Quality Code";
                lrc_PurchaseLine."POI Item Attribute 2" := lrc_PurchRcptLine."POI Color Code";
                lrc_PurchaseLine."POI Grade of Goods Code" := lrc_PurchRcptLine."POI Grade of Goods Code";
                lrc_PurchaseLine."POI Item Attribute 7" := lrc_PurchRcptLine."POI Conservation Code";
                lrc_PurchaseLine."POI Item Attribute 4" := lrc_PurchRcptLine."POI Packing Code";
                lrc_PurchaseLine."POI Coding Code" := lrc_PurchRcptLine."POI Coding Code";
                lrc_PurchaseLine."POI Item Attribute 5" := lrc_PurchRcptLine."POI Treatment Code";
                lrc_PurchaseLine."POI Item Attribute 6" := lrc_PurchRcptLine."POI Proper Name Code";

                lrc_PurchaseLine.MODIFY();

                lrc_ItemChargeAssignPurchase.RESET();
                lrc_ItemChargeAssignPurchase.SETRANGE("Document Type", lrc_PurchaseLine."Document Type");
                lrc_ItemChargeAssignPurchase.SETRANGE("Document No.", lrc_PurchaseLine."Document No.");
                lrc_ItemChargeAssignPurchase.SETRANGE("Document Line No.", lrc_PurchaseLine."Line No.");
                IF lrc_ItemChargeAssignPurchase.FIND('-') THEN BEGIN
                    lrc_ItemChargeAssignPurchase.VALIDATE("Qty. to Assign", lrc_PurchaseLine.Quantity);
                    lrc_ItemChargeAssignPurchase.MODIFY();
                END;

            UNTIL lrc_PurchaseLine.NEXT() = 0;
    end;

    procedure CrMemoItem(var rrc_PurchaseLine: Record "Purchase Line")
    var
    //lfm_PostedPurchaseReceiptLines: Form "528";
    begin
        // -----------------------------------------------------------------------------
        // Auswahl Lieferung und Erstellung Artikelzeile (Rücklieferung)
        // -----------------------------------------------------------------------------

        IF rrc_PurchaseLine.Type <> rrc_PurchaseLine.Type::Item THEN
            ERROR('Es sind nur Artikelzeilen zulässig!');

        lrc_PurchaseHeader.GET(rrc_PurchaseLine."Document Type", rrc_PurchaseLine."Document No.");

        lrc_PurchRcptLine.RESET();
        //lrc_PurchRcptLine.FILTERGROUP(2);
        lrc_PurchRcptLine.SETCURRENTKEY("Buy-from Vendor No.", Type, "No.", Quantity);
        lrc_PurchRcptLine.SETRANGE("Buy-from Vendor No.", lrc_PurchaseHeader."Buy-from Vendor No.");
        lrc_PurchRcptLine.SETRANGE(Type, lrc_PurchRcptLine.Type::Item);
        IF rrc_PurchaseLine."No." <> '' THEN
            lrc_PurchRcptLine.SETRANGE("No.", rrc_PurchaseLine."No.");
        lrc_PurchRcptLine.SETFILTER(Quantity, '<>%1', 0);
        lrc_PurchRcptLine.FILTERGROUP(0);

        // lfm_PostedPurchaseReceiptLines.LOOKUPMODE := TRUE; //TODO: page
        // lfm_PostedPurchaseReceiptLines.SETTABLEVIEW(lrc_PurchRcptLine);
        // IF lfm_PostedPurchaseReceiptLines.RUNMODAL <> ACTION::LookupOK THEN
        //     EXIT;

        // lrc_PurchRcptLine.RESET();
        // lfm_PostedPurchaseReceiptLines.GETRECORD(lrc_PurchRcptLine);

        // Werte aus Lieferzeile setzen
        rrc_PurchaseLine.VALIDATE("No.", lrc_PurchRcptLine."No.");
        rrc_PurchaseLine.VALIDATE("Unit of Measure Code", lrc_PurchRcptLine."Unit of Measure Code");
        rrc_PurchaseLine.VALIDATE(Quantity, lrc_PurchRcptLine.Quantity);
        rrc_PurchaseLine.VALIDATE("Direct Unit Cost", lrc_PurchRcptLine."Direct Unit Cost");

        rrc_PurchaseLine."POI Reference Doc. No." := lrc_PurchRcptLine."Document No.";
        rrc_PurchaseLine."POI Reference Doc. Line No." := lrc_PurchRcptLine."Line No.";
    end;

    procedure CrMemoZuAbMgeZuw(vrc_PurchaseLine: Record "Purchase Line")
    begin
        // -----------------------------------------------------------------------------
        // Funktion zur automatischen Zuweisung der Menge
        // -----------------------------------------------------------------------------

        IF vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::"Charge (Item)" THEN
            EXIT;
        IF vrc_PurchaseLine."Document Type" <> vrc_PurchaseLine."Document Type"::"Credit Memo" THEN
            EXIT;

        vrc_PurchaseLine.CALCFIELDS("Qty. Assigned");
        IF vrc_PurchaseLine.Quantity <> vrc_PurchaseLine."Qty. Assigned" THEN;
    end;

    procedure CrMemoShowZuAb(vrc_PurchaseLine: Record "Purchase Line")
    var
    //lrc_ItemChargeAssignPurchase: Record "Item Charge Assignment (Purch)";
    //lfm_ItemChargeAssignPurchase: Form "Item Charge Assignment (Purch)";
    begin
        // -----------------------------------------------------------------------------
        //
        // -----------------------------------------------------------------------------

        // lfm_ItemChargeAssignPurchase.Initialize(vrc_PurchaseLine, 0); //TODO: page
        // lfm_ItemChargeAssignPurchase.RUNMODAL();
    end;

    procedure LoadPurchItemInVendItem(vco_PurchOrderNo: Code[20])
    var
        lrc_Item: Record Item;
    begin
        // ---------------------------------------------------------------------------------------------
        // Funktion zum Laden der Artikel aus einer Bestellung in die Kreditor-Artikel Referenz
        // ---------------------------------------------------------------------------------------------

        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
        lrc_PurchaseLine.SETRANGE("Document No.", vco_PurchOrderNo);
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
        lrc_PurchaseLine.SETFILTER("No.", '', '');
        lrc_PurchaseLine.SETRANGE("POI Item Typ", lrc_PurchaseLine."POI Item Typ"::"Trade Item");
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT
                IF lrc_Item.GET(lrc_PurchaseLine."No.") THEN BEGIN
                    lrc_ItemVendor.RESET();
                    lrc_ItemVendor.SETRANGE("Vendor No.", lrc_PurchaseLine."Buy-from Vendor No.");
                    lrc_ItemVendor.SETRANGE("Item No.", lrc_PurchaseLine."No.");
                    lrc_ItemVendor.SETRANGE("Variant Code", lrc_PurchaseLine."Variant Code");
                    IF NOT lrc_ItemVendor.FIND('-') THEN BEGIN
                        lrc_ItemVendor.RESET();
                        lrc_ItemVendor.INIT();
                        lrc_ItemVendor."Vendor No." := lrc_PurchaseLine."Buy-from Vendor No.";
                        lrc_ItemVendor."Item No." := lrc_PurchaseLine."No.";
                        lrc_ItemVendor."Variant Code" := lrc_PurchaseLine."Variant Code";
                        lrc_ItemVendor."POI Country of Origin Code" := lrc_PurchaseLine."POI Country of Origin Code";
                        lrc_ItemVendor."POI Variety Code" := lrc_PurchaseLine."POI Variety Code";
                        lrc_ItemVendor."POI Unit of Measure Code" := lrc_PurchaseLine."Unit of Measure Code";
                        lrc_ItemVendor.INSERT();
                    END;
                END;
            UNTIL lrc_PurchaseLine.NEXT() = 0;
    end;

    procedure InsertPriceDifference(prc_PurchaseLine: Record "Purchase Line")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchPriceDifference: Record "POI Purch. Price Difference";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        //lfm_PurchPriceDifference: Form "5110664";
        SSPText0001Txt: Label 'Dimension Level not allowed.';
        lin_LineNo: Integer;
        SSPText0002Txt: Label 'Line not allowed.';
    begin

        // Sicherheitsabfragen
        IF prc_PurchaseLine."No." = '' THEN
            EXit;
        IF (prc_PurchaseLine.Type <> prc_PurchaseLine.Type::Item) OR
           (prc_PurchaseLine."POI Subtyp" <> prc_PurchaseLine."POI Subtyp"::" ") THEN
            ERROR(SSPText0002Txt);


        lrc_FruitVisionSetup.GET();
        lrc_FruitVisionSetup.TESTFIELD("Purch. Price Diff. Account");

        //CLEAR(lfm_PurchPriceDifference); //TODO: page

        lrc_PurchPriceDifference.INIT();
        lrc_PurchPriceDifference.RESET();
        lrc_PurchPriceDifference.FILTERGROUP(2);
        lrc_PurchPriceDifference.SETRANGE("Document Type", prc_PurchaseLine."Document Type");
        lrc_PurchPriceDifference.SETRANGE("Document No.", prc_PurchaseLine."Document No.");
        lrc_PurchPriceDifference.SETRANGE("Document Line No.", prc_PurchaseLine."Line No.");
        lrc_PurchPriceDifference.FILTERGROUP(0);

        // lfm_PurchPriceDifference.SETTABLEVIEW(lrc_PurchPriceDifference); n//TODO: page
        // lfm_PurchPriceDifference.RUNMODAL();
        // lrc_PurchPriceDifference.RESET();
        // lfm_PurchPriceDifference.GETRECORD(lrc_PurchPriceDifference);

        // Satz löschen wenn keine No. vorhanden ist
        IF lrc_PurchPriceDifference."No." = '' THEN BEGIN
            lrc_PurchaseLine.RESET();
            lrc_PurchaseLine.SETRANGE("Document Type", prc_PurchaseLine."Document Type");
            lrc_PurchaseLine.SETRANGE("Document No.", prc_PurchaseLine."Document No.");
            lrc_PurchaseLine.SETRANGE("Attached to Line No.", prc_PurchaseLine."Line No.");
            lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::"G/L Account");
            lrc_PurchaseLine.SETRANGE("No.", lrc_FruitVisionSetup."Purch. Price Diff. Account");
            IF lrc_PurchaseLine.FIND('-') THEN
                lrc_PurchaseLine.DELETE(TRUE);
            EXIT;
        END;

        // Ggf. alten Datensatz finden und modifizieren
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchPriceDifference."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchPriceDifference."Document No.");
        lrc_PurchaseLine.SETRANGE("Attached to Line No.", lrc_PurchPriceDifference."Document Line No.");
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::"G/L Account");
        lrc_PurchaseLine.SETRANGE("No.", lrc_FruitVisionSetup."Purch. Price Diff. Account");
        IF NOT lrc_PurchaseLine.FIND('-') THEN BEGIN
            // Datensatz einfügen
            lrc_PurchaseLine.INIT();
            lrc_PurchaseLine."Document Type" := lrc_PurchPriceDifference."Document Type";
            lrc_PurchaseLine."Document No." := lrc_PurchPriceDifference."Document No.";
            // Neue Zeilennummer ermitteln
            lin_LineNo := 0;
            lrc_PurchaseLine1.RESET();
            lrc_PurchaseLine1.SETRANGE("Document Type", prc_PurchaseLine."Document Type");
            lrc_PurchaseLine1.SETRANGE("Document No.", prc_PurchaseLine."Document No.");
            lrc_PurchaseLine1.SETFILTER("Line No.", '>%1', prc_PurchaseLine."Line No.");
            IF lrc_PurchaseLine1.FIND('-') THEN
                lin_LineNo := ROUND((prc_PurchaseLine."Line No." + lrc_PurchaseLine1."Line No.") / 2, 1)
            ELSE
                lin_LineNo := prc_PurchaseLine."Line No." + 10000;
            lrc_PurchaseLine."Line No." := lin_LineNo;
            lrc_PurchaseLine.INSERT(TRUE);
        END;

        // Datensatz modifizieren
        lrc_PurchaseLine.VALIDATE(Type, lrc_PurchaseLine.Type::"G/L Account");
        lrc_PurchaseLine.VALIDATE("No.", lrc_FruitVisionSetup."Purch. Price Diff. Account");

        lrc_BatchSetup.GET();
        CASE lrc_BatchSetup."Dim. No. Batch No." OF
            lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
                lrc_PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", lrc_PurchPriceDifference."Batch No.");
            lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
                lrc_PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", lrc_PurchPriceDifference."Batch No.");
            lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
                lrc_PurchaseLine.VALIDATE("POI Shortcut Dimension 3 Code", lrc_PurchPriceDifference."Batch No.");
            lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
                lrc_PurchaseLine.VALIDATE("POI Shortcut Dimension 4 Code", lrc_PurchPriceDifference."Batch No.");
            ELSE
                // Dimensionsebene nicht zulässig!
                ERROR(SSPText0001Txt);
        END;

        lrc_PurchaseLine.VALIDATE("POI Price Base (Purch. Price)", lrc_PurchPriceDifference."Price Base (Purch. Price)");
        lrc_PurchaseLine.VALIDATE("POI Purch. Price (Price Base)", lrc_PurchPriceDifference."Line Amount Difference");
        lrc_PurchaseLine.VALIDATE(Quantity, 1);
        // Gehört zu Zeilennr.
        lrc_PurchaseLine."Attached to Line No." := lrc_PurchPriceDifference."Document Line No.";
        lrc_PurchaseLine.MODIFY(TRUE);
    end;

    procedure DeletePriceDifference(prc_PurchaseLine: Record "Purchase Line")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchPriceDifference: Record "POI Purch. Price Difference";
        lrc_PurchaseLineGL: Record "Purchase Line";
    //SSPText0001Txt: Label 'Please delete the Price Difference Line from Line %1.';
    begin
        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Purch. Price Diff. Account" <> '' THEN BEGIN
            // Wenn die Sachkontozeile gelöscht wird
            IF (prc_PurchaseLine.Type = prc_PurchaseLine.Type::"G/L Account") AND
               (prc_PurchaseLine."No." = lrc_FruitVisionSetup."Purch. Price Diff. Account") AND
               (prc_PurchaseLine."Attached to Line No." <> 0) THEN BEGIN

                // Preisdifferenzzeile löschen
                lrc_PurchPriceDifference.RESET();
                IF lrc_PurchPriceDifference.GET(prc_PurchaseLine."Document Type",
                                                prc_PurchaseLine."Document No.", prc_PurchaseLine."Attached to Line No.") THEN
                    lrc_PurchPriceDifference.DELETE(TRUE);
            END;

            // Wenn die Artikelzeile gelöscht wird
            IF (prc_PurchaseLine.Type = prc_PurchaseLine.Type::Item) AND (prc_PurchaseLine."POI Subtyp" = prc_PurchaseLine."POI Subtyp"::" ") THEN BEGIN
                // Prüfen ob es eine Sachkontozeile gibt, wenn ja, dann löschen
                lrc_PurchaseLineGL.RESET();
                lrc_PurchaseLineGL.SETRANGE(Type, lrc_PurchaseLineGL.Type::"G/L Account");
                lrc_PurchaseLineGL.SETRANGE("No.", lrc_FruitVisionSetup."Purch. Price Diff. Account");
                lrc_PurchaseLineGL.SETRANGE("Attached to Line No.", prc_PurchaseLine."Line No.");
                IF lrc_PurchaseLineGL.FIND('-') THEn
                    lrc_PurchaseLineGL.DELETE(TRUE);
                // Preisdifferenzzeile löschen
                lrc_PurchPriceDifference.RESET();
                IF lrc_PurchPriceDifference.GET(prc_PurchaseLine."Document Type", prc_PurchaseLine."Document No.", prc_PurchaseLine."Line No.") THEN
                    lrc_PurchPriceDifference.DELETE(TRUE);
            END;

            // Prüfen ob der Status der gebuchten Preisdifferenz zurückgesetzt werden kann
            IF (prc_PurchaseLine.Type = prc_PurchaseLine.Type::"G/L Account") AND
               (prc_PurchaseLine."No." = lrc_FruitVisionSetup."Purch. Price Diff. Account") THEN BEGIN
                lrc_PurchPostPriceDifference.RESET();
                lrc_PurchPostPriceDifference.SETCURRENTKEY("Temp. Document Type", "Temp. Document No.", "Temp. Document Line No.", Status);
                lrc_PurchPostPriceDifference.SETRANGE("Temp. Document Type", prc_PurchaseLine."Document Type");
                lrc_PurchPostPriceDifference.SETRANGE("Temp. Document No.", prc_PurchaseLine."Document No.");
                lrc_PurchPostPriceDifference.SETRANGE("Temp. Document Line No.", prc_PurchaseLine."Line No.");
                lrc_PurchPostPriceDifference.SETRANGE(Status, lrc_PurchPostPriceDifference.Status::Closed);
                IF lrc_PurchPostPriceDifference.FIND('-') THEN BEGIN
                    // Datensatz freigeben
                    lrc_PurchPostPriceDifference."Temp. Document Type" := lrc_PurchPostPriceDifference."Temp. Document Type"::Quote;
                    lrc_PurchPostPriceDifference."Temp. Document No." := '';
                    lrc_PurchPostPriceDifference."Temp. Document Line No." := 0;
                    lrc_PurchPostPriceDifference.Status := lrc_PurchPostPriceDifference.Status::Open;
                    lrc_PurchPostPriceDifference.MODIFY();
                END;
            END;

        END;

    end;

    procedure PurchMovePDToPostPD(vop_SourceDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; vco_SourceDocumentNo: Code[20]; vin_SourceDocumentLineNo: Integer; vop_TargetDocumentType: Option Shipment,Invoice,"Credit Memo","Return Shipment"; vco_TargetDocumentNo: Code[20]; vin_TargetDocumentLineNo: Integer)
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_PurchPriceDifference: Record "POI Purch. Price Difference";
    begin
        IF lrc_PurchPriceDifference.GET(vop_SourceDocumentType, vco_SourceDocumentNo, vin_SourceDocumentLineNo) THEN BEGIN

            lrc_PurchPostPriceDifference.RESET();
            lrc_PurchPostPriceDifference.INIT();

            CASE vop_TargetDocumentType OF
                0:
                    lrc_PurchPostPriceDifference."Document Type" :=
                      lrc_PurchPostPriceDifference."Document Type"::"Posted Shipment";
                1:
                    lrc_PurchPostPriceDifference."Document Type" :=
                      lrc_PurchPostPriceDifference."Document Type"::"Posted Invoice";
                2:
                    lrc_PurchPostPriceDifference."Document Type" :=
                      lrc_PurchPostPriceDifference."Document Type"::"Posted Credit Memo";
                3:
                    lrc_PurchPostPriceDifference."Document Type" :=
                      lrc_PurchPostPriceDifference."Document Type"::"Posted Return Shipment";
            END;

            lrc_PurchPostPriceDifference."Document No." := vco_TargetDocumentNo;
            lrc_PurchPostPriceDifference."Document Line No." := vin_TargetDocumentLineNo;
            lrc_PurchPostPriceDifference.TRANSFERFIELDS(lrc_PurchPriceDifference);
            lrc_PurchPostPriceDifference.INSERT();

        END;


        // Prüfen ob der Status der gebuchten Preisdifferenz auf gebucht gesetzt werden kann
        lrc_FruitVisionSetup.GET();
        IF lrc_FruitVisionSetup."Purch. Price Diff. Account" <> '' THEN
            IF lrc_PurchaseLine.GET(vop_SourceDocumentType, vco_SourceDocumentNo, vin_SourceDocumentLineNo) THEN
                IF (lrc_PurchaseLine.Type = lrc_PurchaseLine.Type::"G/L Account") AND
                   (lrc_PurchaseLine."No." = lrc_FruitVisionSetup."Purch. Price Diff. Account") THEN BEGIN
                    lrc_PurchPostPriceDifference.RESET();
                    lrc_PurchPostPriceDifference.SETCURRENTKEY("Temp. Document Type", "Temp. Document No.", "Temp. Document Line No.", Status);
                    lrc_PurchPostPriceDifference.SETRANGE("Temp. Document Type", lrc_PurchaseLine."Document Type");
                    lrc_PurchPostPriceDifference.SETRANGE("Temp. Document No.", lrc_PurchaseLine."Document No.");
                    lrc_PurchPostPriceDifference.SETRANGE("Temp. Document Line No.", lrc_PurchaseLine."Line No.");
                    lrc_PurchPostPriceDifference.SETRANGE(Status, lrc_PurchPostPriceDifference.Status::Closed);
                    IF lrc_PurchPostPriceDifference.FIND('-') THEN BEGIN
                        // Datensatz freigeben
                        lrc_PurchPostPriceDifference."Temp. Document Type" := lrc_PurchPostPriceDifference."Temp. Document Type"::Quote;
                        lrc_PurchPostPriceDifference."Temp. Document No." := '';
                        lrc_PurchPostPriceDifference."Temp. Document Line No." := 0;
                        lrc_PurchPostPriceDifference.Status := lrc_PurchPostPriceDifference.Status::Posted;
                        lrc_PurchPostPriceDifference.MODIFY();
                    END;
                END;
    end;

    procedure GetPriceDifference(var rrc_PurchaseLine: Record "Purchase Line")
    var
    //lrc_PurchLine: Record "Purchase Line";
    //GetPriceDifference: Form "5110665";
    begin
        lrc_PurchHeader.GET(rrc_PurchaseLine."Document Type", rrc_PurchaseLine."Document No.");
        lrc_PurchHeader.TESTFIELD("Document Type", lrc_PurchHeader."Document Type"::Invoice);
        lrc_PurchHeader.TESTFIELD(Status, lrc_PurchHeader.Status::Open);
        lrc_PurchPostPriceDifference.RESET();
        lrc_PurchPostPriceDifference.SETCURRENTKEY(lrc_PurchPostPriceDifference."Buy-from Vendor No.",
                                                   lrc_PurchPostPriceDifference."Order Address Code", Status);
        lrc_PurchPostPriceDifference.FILTERGROUP(0);
        lrc_PurchPostPriceDifference.SETRANGE("Buy-from Vendor No.", lrc_PurchHeader."Buy-from Vendor No.");
        lrc_PurchPostPriceDifference.SETRANGE(Status, lrc_PurchPostPriceDifference.Status::Open);
        lrc_PurchPostPriceDifference.FILTERGROUP(2);
        //lrc_PurchPostPriceDifference.SETRANGE("Currency Code",PurchHeader."Currency Code");
        // GetPriceDifference.SETTABLEVIEW(lrc_PurchPostPriceDifference); //TODO: Page
        // GetPriceDifference.LOOKUPMODE := TRUE;
        // //xxGetPriceDifference.SetPurchHeader(lrc_PurchHeader);
        // GetPriceDifference.RUNMODAL();


    end;

    procedure CreatePriceDifferenceLines(var vrc_PurchPostPriceDifference: Record "POI Purch. Post. Price Diff."; prc_PurchaseHeader: Record "Purchase Header")
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_BatchSetup: Record "POI Master Batch Setup";
        //lfm_PurchPriceDifference: Form "5110664";
        lin_LineNo: Integer;
        SSPText0001Txt: Label 'Dimension Level not allowed.';
    begin
        lrc_FruitVisionSetup.GET();
        // Abgrenzung des SelectionFilters finden
        IF vrc_PurchPostPriceDifference.FIND('-') THEN
            REPEAT
                // Datensatz einfügen
                lrc_PurchaseLine.INIT();
                lrc_PurchaseLine."Document Type" := prc_PurchaseHeader."Document Type";
                lrc_PurchaseLine."Document No." := prc_PurchaseHeader."No.";
                // Neue Zeilennummer ermitteln
                lin_LineNo := 0;
                lrc_PurchaseLine1.RESET();
                lrc_PurchaseLine1.SETRANGE("Document Type", lrc_PurchaseLine."Document Type");
                lrc_PurchaseLine1.SETRANGE("Document No.", lrc_PurchaseLine."Document No.");
                IF lrc_PurchaseLine1.FIND('+') THEN
                    lin_LineNo := lrc_PurchaseLine1."Line No." + 10000
                ELSE
                    lin_LineNo := 10000;
                lrc_PurchaseLine."Line No." := lin_LineNo;
                lrc_PurchaseLine.INSERT(TRUE);
                // Datensatz modifizieren
                lrc_PurchaseLine.VALIDATE(Type, lrc_PurchaseLine.Type::"G/L Account");
                lrc_PurchaseLine.VALIDATE("No.", lrc_FruitVisionSetup."Purch. Price Diff. Account");
                lrc_BatchSetup.GET();
                CASE lrc_BatchSetup."Dim. No. Batch No." OF
                    lrc_BatchSetup."Dim. No. Batch No."::"1. Dimension":
                        lrc_PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", vrc_PurchPostPriceDifference."Batch No.");
                    lrc_BatchSetup."Dim. No. Batch No."::"2. Dimension":
                        lrc_PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", vrc_PurchPostPriceDifference."Batch No.");
                    lrc_BatchSetup."Dim. No. Batch No."::"3. Dimension":
                        lrc_PurchaseLine.VALIDATE("POI Shortcut Dimension 3 Code", vrc_PurchPostPriceDifference."Batch No.");
                    lrc_BatchSetup."Dim. No. Batch No."::"4. Dimension":
                        lrc_PurchaseLine.VALIDATE("POI Shortcut Dimension 4 Code", vrc_PurchPostPriceDifference."Batch No.");
                    ELSE
                        // Dimensionsebene nicht zulässig!
                        ERROR(SSPText0001Txt);
                END;
                lrc_PurchaseLine.VALIDATE("POI Price Base (Purch. Price)", vrc_PurchPostPriceDifference."Price Base (Purch. Price)");
                lrc_PurchaseLine.VALIDATE("POI Purch. Price (Price Base)", -vrc_PurchPostPriceDifference."Line Amount Difference");
                lrc_PurchaseLine.VALIDATE(Quantity, 1);
                // Gehört zu Zeilennr.
                //lrc_PurchaseLine."Attached to Line No." := vrc_PurchPostPriceDifference."Document Line No.";
                lrc_PurchaseLine.MODIFY(TRUE);
                // Preisdatensatz ändern
                IF lrc_PurchPostPriceDifference.GET(vrc_PurchPostPriceDifference."Document Type", vrc_PurchPostPriceDifference."Document No.", vrc_PurchPostPriceDifference."Document Line No.") THEN BEGIN
                    lrc_PurchPostPriceDifference.Status := vrc_PurchPostPriceDifference.Status::Closed;
                    lrc_PurchPostPriceDifference."Temp. Document Type" := lrc_PurchaseLine."Document Type";
                    lrc_PurchPostPriceDifference."Temp. Document No." := lrc_PurchaseLine."Document No.";
                    lrc_PurchPostPriceDifference."Temp. Document Line No." := lrc_PurchaseLine."Line No.";
                    lrc_PurchPostPriceDifference.MODIFY();
                END;
            UNTIL vrc_PurchPostPriceDifference.NEXT() = 0;
    end;

    procedure CallSelectedSalesOrder(rrc_PurchaseLine: Record "Purchase Line")
    var
        lcu_SalesMgt: Codeunit "POI Sales Mgt";
    begin
        rrc_PurchaseLine.TESTFIELD("Sales Order No.");
        rrc_PurchaseLine.TESTFIELD("Sales Order Line No.");
        lrc_SalesHeader.RESET();
        lrc_SalesHeader.SETRANGE("Document Type", lrc_SalesHeader."Document Type"::Order);
        lrc_SalesHeader.SETRANGE("No.", rrc_PurchaseLine."Sales Order No.");
        IF lrc_SalesHeader.FINDFIRST() THEN
            lcu_SalesMgt.ShowSalesOrder(lrc_SalesHeader."Document Type", lrc_SalesHeader."No.", FALSE, FALSE);
    end;

    procedure UpdateVendPurchPrice(vrc_PurchLine: Record "Purchase Line")
    var
    //lrc_SalesPrice: Record "Sales Price";
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Aktualisierung Kreditor Einkaufspreis
        // ---------------------------------------------------------------------------------------

        IF vrc_PurchLine.Type <> vrc_PurchLine.Type::Item THEN
            EXIT;
        IF vrc_PurchLine."No." = '' THEN
            EXIT;
        IF vrc_PurchLine."POI Purch. Price (Price Base)" <= 0 THEN
            EXIT;
        IF vrc_PurchLine."POI Price Unit of Measure" = '' THEN
            EXIT;
        IF vrc_PurchLine."Buy-from Vendor No." = '' THEN
            EXIT;
        IF vrc_PurchLine."Document Type" <> vrc_PurchLine."Document Type"::Order THEN
            EXIT;

        // Rückschreiben nur für bestimmte Produktgruppen
        lrc_ProductGroup.SETRANGE(Code, vrc_PurchLine."POI Product Group Code");
        IF lrc_ProductGroup.FINDFIRST() THEN BEGIN
            IF lrc_ProductGroup."Save Cust. Sales Price" = FALSE THEN
                EXIT;
        END ELSE
            EXIT;
    end;

    procedure PurchAccEnterCosts(vrc_PurchaseHeader: Record "Purchase Header")
    var
    //lfm_PurchaseAccSalesCost: Form "5088098";
    begin
        // -----------------------------------------------------------------------------------------------------------------
        // Funktion zur Erfassung von zusätzlichen Kosten für die Abrechnung
        // -----------------------------------------------------------------------------------------------------------------
        lrc_PurchaseAccSalesCost.RESET();
        lrc_PurchaseAccSalesCost.FILTERGROUP(2);
        lrc_PurchaseAccSalesCost.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseAccSalesCost.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        lrc_PurchaseAccSalesCost.FILTERGROUP(0);
        IF NOT lrc_PurchaseAccSalesCost.FIND('-') THEN BEGIN
            lrc_CostCategory.RESET();
            lrc_CostCategory.SETCURRENTKEY("Sorting in Acc. Sales");
            lrc_CostCategory.SETRANGE("Reduce Cost from Turnover", FALSE);
            lrc_CostCategory.SETFILTER("Cost Type General", '%1|%2', lrc_CostCategory."Cost Type General"::"External Cost", lrc_CostCategory."Cost Type General"::"Internal Cost");
            IF lrc_CostCategory.FIND('-') THEN BEGIN
                REPEAT
                    lrc_PurchaseAccSalesCost.RESET();
                    lrc_PurchaseAccSalesCost.INIT();
                    lrc_PurchaseAccSalesCost."Document Type" := vrc_PurchaseHeader."Document Type";
                    lrc_PurchaseAccSalesCost."Document No." := vrc_PurchaseHeader."No.";
                    lrc_PurchaseAccSalesCost."Cost Category Code" := lrc_CostCategory.Code;
                    lrc_PurchaseAccSalesCost.Description := lrc_CostCategory.Description;
                    lrc_PurchaseAccSalesCost."Description 2" := lrc_CostCategory."Description 2";
                    lrc_PurchaseAccSalesCost.INSERT();
                UNTIL lrc_CostCategory.NEXT() = 0;
                COMMIT();
            END;
            lrc_PurchaseAccSalesCost.RESET();
            lrc_PurchaseAccSalesCost.FILTERGROUP(2);
            lrc_PurchaseAccSalesCost.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
            lrc_PurchaseAccSalesCost.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
            lrc_PurchaseAccSalesCost.FILTERGROUP(0);
        END;

        // lfm_PurchaseAccSalesCost.SETTABLEVIEW(lrc_PurchaseAccSalesCost); //TODO: page
        // lfm_PurchaseAccSalesCost.RUNMODAL();


        // Zeilen in Einkaufsrechnung erstellen
        PurchAccCreateCostCatLines(vrc_PurchaseHeader);
    end;

    procedure PurchAccSplitPurchasePrice(vrc_PurchaseLine: Record "Purchase Line")
    var
        lrc_PurchAccSplittPrices: Record "POI Purch. Acc. Splitt Prices";
        //lfm_PurchAccSplittPrices: Form "5110795";
        //vdc_DifMge: Decimal;
        vdc_TotalAmount: Decimal;
        vdc_AveragePrice: Decimal;
    begin
        // -----------------------------------------------------------------------------------------------------------------
        // Funktion zum Erfassung von gesplitteten Einkaufspreisen für die Abrechnung
        // -----------------------------------------------------------------------------------------------------------------
        lrc_PurchAccSplittPrices.RESET();
        lrc_PurchAccSplittPrices.FILTERGROUP(2);
        lrc_PurchAccSplittPrices.SETRANGE("Document Type", vrc_PurchaseLine."Document Type");
        lrc_PurchAccSplittPrices.SETRANGE("Document No.", vrc_PurchaseLine."Document No.");
        lrc_PurchAccSplittPrices.SETRANGE("Line No.", vrc_PurchaseLine."Line No.");
        lrc_PurchAccSplittPrices.FILTERGROUP(0);
        IF NOT lrc_PurchAccSplittPrices.FIND('-') THEN BEGIN
            lrc_PurchAccSplittPrices.RESET();
            lrc_PurchAccSplittPrices.INIT();
            lrc_PurchAccSplittPrices."Document Type" := vrc_PurchaseLine."Document Type";
            lrc_PurchAccSplittPrices."Document No." := vrc_PurchaseLine."Document No.";
            lrc_PurchAccSplittPrices."Line No." := vrc_PurchaseLine."Line No.";
            lrc_PurchAccSplittPrices."Original Purchase Price" := vrc_PurchaseLine."Direct Unit Cost";
            lrc_PurchAccSplittPrices.INSERT();
            COMMIT();
            lrc_PurchAccSplittPrices.RESET();
            lrc_PurchAccSplittPrices.FILTERGROUP(2);
            lrc_PurchAccSplittPrices.SETRANGE("Document Type", vrc_PurchaseLine."Document Type");
            lrc_PurchAccSplittPrices.SETRANGE("Document No.", vrc_PurchaseLine."Document No.");
            lrc_PurchAccSplittPrices.SETRANGE("Line No.", vrc_PurchaseLine."Line No.");
            lrc_PurchAccSplittPrices.FILTERGROUP(0);
        END;

        // Erfassungsmaske aufrufen
        // lfm_PurchAccSplittPrices.SETTABLEVIEW(lrc_PurchAccSplittPrices); //TODO: page
        // lfm_PurchAccSplittPrices.RUNMODAL();

        lrc_PurchAccSplittPrices.RESET();
        //lfm_PurchAccSplittPrices.GETRECORD(lrc_PurchAccSplittPrices); //TODO: page
        IF (lrc_PurchAccSplittPrices."1. Quantity" +
           lrc_PurchAccSplittPrices."2. Quantity" +
           lrc_PurchAccSplittPrices."3. Quantity" +
           lrc_PurchAccSplittPrices."4. Quantity" +
           lrc_PurchAccSplittPrices."5. Quantity") <> 0 THEN
            ERROR('Erfasste Menge und eingekaufte Menge stimmen nicht überein!');
        vdc_TotalAmount := (lrc_PurchAccSplittPrices."1. Direct Unit Cost Amount" +
                            lrc_PurchAccSplittPrices."2. Direct Unit Cost Amount" +
                            lrc_PurchAccSplittPrices."3. Direct Unit Cost Amount" +
                            lrc_PurchAccSplittPrices."4. Direct Unit Cost Amount" +
                            lrc_PurchAccSplittPrices."5. Direct Unit Cost Amount");
        vdc_AveragePrice := ROUND(vdc_TotalAmount / vrc_PurchaseLine.Quantity, 0.00001);
        lrc_PurchaseLine.GET(vrc_PurchaseLine."Document Type", vrc_PurchaseLine."Document No.", vrc_PurchaseLine."Line No.");
        lrc_PurchaseLine.VALIDATE("POI Sal Price(Price Base)(LCY)", vdc_AveragePrice);
    end;

    procedure PurchAccCreateCostCatLines(vrc_PurchaseHeader: Record "Purchase Header")
    var
        //lrc_CostCategory: Record "POI Cost Category";
        lin_LastLineNo: Integer;
    begin
        // ---------------------------------------------------------------------------------------------------------------
        // Funktion zur Erstellung von Kostenkategoriezeilen
        // ---------------------------------------------------------------------------------------------------------------

        // Vorhandene Zeilen löschen falls noch nicht geliefert
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::"G/L Account");
        lrc_PurchaseLine.SETRANGE("POI Subtyp", lrc_PurchaseLine."POI Subtyp"::Statement);
        lrc_PurchaseLine.SETFILTER("POI Cost Category Code", '<>%1', '');
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT
                IF lrc_PurchaseLine."Quantity Received" = 0 THEN
                    lrc_PurchaseLine.DELETE(TRUE);
            UNTIL lrc_PurchaseLine.NEXT() = 0;

        // Letzte Zeilennummer ermitteln
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        IF lrc_PurchaseLine.FIND('+') THEN
            lin_LastLineNo := lrc_PurchaseLine."Line No."
        ELSE
            lin_LastLineNo := 0;

        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::"G/L Account");
        lrc_PurchaseLine.SETRANGE("POI Subtyp", lrc_PurchaseLine."POI Subtyp"::Statement);
        lrc_PurchaseLine.SETFILTER("POI Cost Category Code", '<>%1', '');
        IF NOT lrc_PurchaseLine.FIND('-') THEN BEGIN

            lrc_PurchaseLine.RESET();
            lrc_PurchaseLine.INIT();
            lrc_PurchaseLine.VALIDATE("Document Type", vrc_PurchaseHeader."Document Type");
            lrc_PurchaseLine."Document No." := vrc_PurchaseHeader."No.";
            lin_LastLineNo := lin_LastLineNo + 10000;
            lrc_PurchaseLine."Line No." := lin_LastLineNo;
            lrc_PurchaseLine."Buy-from Vendor No." := vrc_PurchaseHeader."Buy-from Vendor No.";
            lrc_PurchaseLine.VALIDATE(Type, lrc_PurchaseLine.Type::" ");
            lrc_PurchaseLine.INSERT(TRUE);
            lrc_PurchaseLine.Description := '';
            lrc_PurchaseLine.MODIFY();

            lrc_PurchaseLine.RESET();
            lrc_PurchaseLine.INIT();
            lrc_PurchaseLine.VALIDATE("Document Type", vrc_PurchaseHeader."Document Type");
            lrc_PurchaseLine."Document No." := vrc_PurchaseHeader."No.";
            lin_LastLineNo := lin_LastLineNo + 10000;
            lrc_PurchaseLine."Line No." := lin_LastLineNo;
            lrc_PurchaseLine."Buy-from Vendor No." := vrc_PurchaseHeader."Buy-from Vendor No.";
            lrc_PurchaseLine.VALIDATE(Type, lrc_PurchaseLine.Type::" ");
            lrc_PurchaseLine.INSERT(TRUE);
            lrc_PurchaseLine.Description := '----------------------------';
            lrc_PurchaseLine.MODIFY();

        END;


        // Erfasste Kostenzeilen lesen
        lrc_PurchaseAccSalesCost.RESET();
        lrc_PurchaseAccSalesCost.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseAccSalesCost.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        lrc_PurchaseAccSalesCost.SETFILTER(Amount, '<>%1', 0);
        IF lrc_PurchaseAccSalesCost.FIND('-') THEN
            REPEAT
                // Kontrolle ob es einen Eintrag gibt
                lrc_PurchaseLine.RESET();
                lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
                lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
                lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::"G/L Account");
                lrc_PurchaseLine.SETRANGE("POI Subtyp", lrc_PurchaseLine."POI Subtyp"::Statement);
                lrc_PurchaseLine.SETRANGE("POI Cost Category Code", lrc_PurchaseAccSalesCost."Cost Category Code");
                IF not lrc_PurchaseLine.FIND('-') THEN BEGIN
                    lrc_PurchaseLine.RESET();
                    lrc_PurchaseLine.INIT();
                    lrc_PurchaseLine.VALIDATE("Document Type", vrc_PurchaseHeader."Document Type");
                    lrc_PurchaseLine."Document No." := vrc_PurchaseHeader."No.";
                    lin_LastLineNo := lin_LastLineNo + 10000;
                    lrc_PurchaseLine."Line No." := lin_LastLineNo;
                    lrc_PurchaseLine."Buy-from Vendor No." := vrc_PurchaseHeader."Buy-from Vendor No.";
                    lrc_PurchaseLine.INSERT(TRUE);
                    // Sachkonto ermitteln
                    lrc_CostCategoryAccounts.RESET();
                    lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
                    lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", lrc_PurchaseAccSalesCost."Cost Category Code");
                    lrc_CostCategoryAccounts.SETRANGE("Gen. Bus. Posting Group", vrc_PurchaseHeader."Gen. Bus. Posting Group");
                    IF NOT lrc_CostCategoryAccounts.FIND('-') THEN BEGIN
                        lrc_CostCategoryAccounts.RESET();
                        lrc_CostCategoryAccounts.SETRANGE("Cost Schema Code", '');
                        lrc_CostCategoryAccounts.SETRANGE("Cost Category Code", lrc_PurchaseAccSalesCost."Cost Category Code");
                        lrc_CostCategoryAccounts.SETRANGE("Gen. Bus. Posting Group", '');
                        IF NOT lrc_CostCategoryAccounts.FIND('-') THEN
                            lrc_CostCategoryAccounts.INIT();
                    END;
                    lrc_PurchaseLine.VALIDATE(Type, lrc_PurchaseLine.Type::"G/L Account");
                    lrc_PurchaseLine.VALIDATE("No.", lrc_CostCategoryAccounts."G/L Account No.");
                    lrc_PurchaseLine."POI Subtyp" := lrc_PurchaseLine."POI Subtyp"::Statement;
                    lrc_PurchaseLine."POI Cost Category Code" := lrc_PurchaseAccSalesCost."Cost Category Code";
                    lrc_PurchaseLine.VALIDATE("Direct Unit Cost", lrc_PurchaseAccSalesCost."Direct Unit Cost");
                    lrc_PurchaseLine.VALIDATE(Quantity, lrc_PurchaseAccSalesCost.Quantity);
                    lrc_PurchaseLine.Description := lrc_PurchaseAccSalesCost.Description;
                    lrc_PurchaseLine."Description 2" := lrc_PurchaseAccSalesCost."Description 2";
                    lrc_PurchaseLine.MODIFY();
                END;
            UNTIL lrc_PurchaseAccSalesCost.NEXT() = 0;
    end;

    procedure PurchUpdItemStatBase(vrc_PurchaseLine: Record "Purchase Line")
    var
        lcu_ItemStatBaseDateMgt: Codeunit "POI Item Stat. Base Data Mgt";
    begin
        // ---------------------------------------------------------------------------------------
        // Funktion zur Aktualisierung der Kombinationen in der Bestandsinformation
        // ---------------------------------------------------------------------------------------

        IF vrc_PurchaseLine."POI Batch Variant No." <> '' THEN
            lcu_ItemStatBaseDateMgt.LoadAllValues(FALSE, vrc_PurchaseLine."POI Batch Variant No.");
    end;

    procedure PurchShowReturnOrder(vop_DocType: Option "1","2","3","4","5","6","7","8","9"; vco_DocNo: Code[20])
    var

        lrc_PurchHdr: Record "Purchase Header";
        lcu_GlobalVariablesMgt: Codeunit "POI Global Variables Mgt.";
    begin
        // -----------------------------------------------------------------------------------------------
        // Funktion zum öffnen einer Reklamation aus der Übersicht
        // -----------------------------------------------------------------------------------------------

        lrc_PurchHdr.GET(vop_DocType, vco_DocNo);
        lrc_PurchDocType.GET(lrc_PurchHdr."Document Type", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
        lrc_PurchDocType.TESTFIELD("Page ID Card");

        IF lrc_PurchDocType."Allow scrolling in Card" = FALSE THEN BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("No.", lrc_PurchHdr."No.");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END ELSE BEGIN
            lrc_PurchHdr.FILTERGROUP(2);
            lrc_PurchHdr.SETRANGE("Document Type", lrc_PurchHdr."Document Type");
            lrc_PurchHdr.SETRANGE("POI Purch. Doc. Subtype Code", lrc_PurchHdr."POI Purch. Doc. Subtype Code");
            lrc_PurchHdr.FILTERGROUP(0);
        END;

        lcu_GlobalVariablesMgt.SetDirectCall(TRUE);
        Page.RUN(lrc_PurchDocType."Page ID Card", lrc_PurchHdr);
    end;

    procedure PurchNewReturnOrder(vco_PurchDocType: Code[10])
    var
        lrc_PurchHdr: Record "Purchase Header";
        AGILES_TEXT001Txt: Label 'Neuanlage nur über Belegart zulässig!';
    begin
        // -----------------------------------------------------------------------------
        // Funktion zum Anlegen einer Reklamation aus der Übersicht
        // -----------------------------------------------------------------------------
        IF vco_PurchDocType = '' THEN
            // Neuanlage nur über Belegart zulässig!
            ERROR(AGILES_TEXT001Txt);

        // Belegart lesen
        lrc_PurchDocType.GET(lrc_PurchDocType."Document Type"::"Return Order", vco_PurchDocType);
        lrc_PurchHdr.RESET();
        lrc_PurchHdr.INIT();
        lrc_PurchHdr."Document Type" := lrc_PurchHdr."Document Type"::"Return Order";
        lrc_PurchHdr."No." := '';
        lrc_PurchHdr."POI Purch. Doc. Subtype Code" := vco_PurchDocType;
        // Kopfsatz einfügen
        lrc_PurchHdr.INSERT(TRUE);

        IF lrc_PurchDocType."Default Vendor" <> '' THEN
            lrc_PurchHdr.VALIDATE("Buy-from Vendor No.", lrc_PurchDocType."Default Vendor");

        // Standard Lagerort aus Belegart setzen
        IF lrc_PurchDocType."Default Location Code" <> '' THEN
            lrc_PurchHdr.VALIDATE("Location Code", lrc_PurchDocType."Default Location Code");

        // Qualitätskontrolleur aus Belegart setzen
        IF lrc_PurchDocType."Quality Control Vendor No." <> '' THEN
            lrc_PurchHdr.VALIDATE("POI Quality Control Vendor No.", lrc_PurchDocType."Quality Control Vendor No.");

        // Spediteur aus Belegart setzen
        IF lrc_PurchDocType."Clearing by Ship. Agent Code" <> '' THEN
            lrc_PurchHdr.VALIDATE("POI Clearing by Vendor No.", lrc_PurchDocType."Clearing by Ship. Agent Code");

        // Kopfsatz aktualisieren
        lrc_PurchHdr.MODIFY();


        // Neue Bestellung öffnen
        PurchShowOrder(lrc_PurchHdr."Document Type", lrc_PurchHdr."No.", FALSE);
    end;

    procedure PurchCopyFromPurch(vrc_PurchHeader: Record "Purchase Header")
    var
    //lcu_SingleInstanceMgt: Codeunit "5087902";
    begin
        // -----------------------------------------------------------------------------------------
        // Funktion zur Auswahl der zu kopierenden Artikelzeilen aus einem anderen Einkauf
        // -----------------------------------------------------------------------------------------

        vrc_PurchHeader.TESTFIELD("Buy-from Vendor No.");

        lrc_PurchLine.FILTERGROUP(2);
        lrc_PurchLine.SETRANGE("Document Type", lrc_PurchLine."Document Type"::Order);
        lrc_PurchLine.SETFILTER("Document No.", '<>%1', vrc_PurchHeader."No.");
        lrc_PurchLine.SETRANGE(Type, lrc_PurchLine.Type::Item);
        lrc_PurchLine.SETFILTER("No.", '<>%1', '');
        lrc_PurchLine.SETRANGE("POI Subtyp", lrc_PurchLine."POI Subtyp"::" ");
        lrc_PurchLine.FILTERGROUP(0);
        lrc_PurchLine.SETRANGE("Buy-from Vendor No.", vrc_PurchHeader."Buy-from Vendor No.");

        //lcu_SingleInstanceMgt.SetPurchHeader(vrc_PurchHeader);

        IF Page.RUNMODAL(5110365, lrc_PurchLine) = ACTION::LookupOK THEN;
    end;

    procedure PurchCopyFromPurchLines(var vrc_PurchLine: Record "Purchase Line")
    var
        //lcu_SingleInstanceMgt: Codeunit "5087902";
        lrc_Vendor: Record Vendor;
        lin_LineNo: Integer;
    begin
        // -----------------------------------------------------------------------------------------
        // Funktion zur Kopieren der ausgewählten Artikelzeilen
        // -----------------------------------------------------------------------------------------

        // IF NOT lcu_SingleInstanceMgt.GetPurchHeader(lrc_PurchaseHeader) THEN
        //     EXIT;
        lrc_PurchaseHeader.TESTFIELD("No.");

        lrc_Vendor.GET(lrc_PurchaseHeader."Buy-from Vendor No.");

        lrc_PurchLineNew.RESET();
        lrc_PurchLineNew.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
        lrc_PurchLineNew.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
        IF lrc_PurchLineNew.FINDLAST() THEN
            lin_LineNo := lrc_PurchLineNew."Line No."
        ELSE
            lin_LineNo := 0;

        IF vrc_PurchLine.FINDSET(FALSE, FALSE) THEN
            REPEAT
                lrc_PurchLineNew.RESET();
                lrc_PurchLineNew.INIT();
                lrc_PurchLineNew."Document Type" := lrc_PurchaseHeader."Document Type";
                lrc_PurchLineNew."Document No." := lrc_PurchaseHeader."No.";
                lin_LineNo := lin_LineNo + 10000;
                lrc_PurchLineNew."Line No." := lin_LineNo;
                lrc_PurchLineNew.INSERT(TRUE);
                lrc_PurchLineNew.VALIDATE(Type, lrc_PurchLineNew.Type::Item);
                lrc_PurchLineNew.VALIDATE("No.", vrc_PurchLine."No.");
                lrc_PurchLineNew.VALIDATE("POI Country of Origin Code", vrc_PurchLine."POI Country of Origin Code");
                lrc_PurchLineNew.VALIDATE("POI Variety Code", vrc_PurchLine."POI Variety Code");
                // Direkte Zuweisung, da ansonsten Fehler ausgeworfen werden, da die Marken keinem
                // Kreditorem zugewiesen sind
                lrc_PurchLineNew."POI Trademark Code" := vrc_PurchLine."POI Trademark Code";
                lrc_PurchLineNew.VALIDATE("POI Caliber Code", vrc_PurchLine."POI Caliber Code");
                lrc_PurchLineNew.VALIDATE("POI Vendor Caliber Code", vrc_PurchLine."POI Vendor Caliber Code");
                lrc_PurchLineNew.VALIDATE("POI Item Attribute 3", vrc_PurchLine."POI Item Attribute 3");
                lrc_PurchLineNew.VALIDATE("POI Item Attribute 2", vrc_PurchLine."POI Item Attribute 2");
                lrc_PurchLineNew.VALIDATE("POI Grade of Goods Code", vrc_PurchLine."POI Grade of Goods Code");
                lrc_PurchLineNew.VALIDATE("POI Item Attribute 7", vrc_PurchLine."POI Item Attribute 7");
                lrc_PurchLineNew.VALIDATE("POI Item Attribute 4", vrc_PurchLine."POI Item Attribute 4");
                lrc_PurchLineNew.VALIDATE("POI Coding Code", vrc_PurchLine."POI Coding Code");
                lrc_PurchLineNew.VALIDATE("POI Item Attribute 5", vrc_PurchLine."POI Item Attribute 5");
                lrc_PurchLineNew.VALIDATE("POI Item Attribute 6", vrc_PurchLine."POI Item Attribute 6");
                lrc_PurchLineNew.VALIDATE("POI Item Attribute 1", vrc_PurchLine."POI Item Attribute 1");
                lrc_PurchLineNew.VALIDATE("POI Cultivation Type", lrc_Vendor."POI Cultivation Type");
                lrc_PurchLineNew.VALIDATE("Location Code", vrc_PurchLine."Location Code");
                lrc_PurchLineNew.VALIDATE("Unit of Measure Code", vrc_PurchLine."Unit of Measure Code");
                lrc_PurchLineNew.VALIDATE("POI Transport Unit of Meas(TU)", vrc_PurchLine."POI Transport Unit of Meas(TU)");
                lrc_PurchLineNew.VALIDATE("POI Qty. (Unit) per Transp(TU)", vrc_PurchLine."POI Qty. (Unit) per Transp(TU)");
                lrc_PurchLineNew.MODIFY(TRUE);
            UNTIL vrc_PurchLine.NEXT() = 0;
    end;

    procedure ImpDocLoadInPurchOrder(vop_PurchDocType: Option "0","1","2","3","4","5","6","7","8","9"; vco_PurchDocNo: Code[20]; vco_VendorNo: Code[20])
    begin
        // -----------------------------------------------------------------------------------------
        // Funktion zum Laden der benötigten Importdokumente in die Einkaufsbestellung
        // -----------------------------------------------------------------------------------------

        IF (vop_PurchDocType <> 1) OR
           (vco_PurchDocNo = '') OR
           (vco_VendorNo = '') THEN
            EXIT;

        lrc_PurchaseImportDocuments.RESET();
        lrc_PurchaseImportDocuments.SETRANGE("Document Type", vop_PurchDocType);
        lrc_PurchaseImportDocuments.SETRANGE("Document No.", vco_PurchDocNo);
        IF NOT lrc_PurchaseImportDocuments.ISEMPTY() THEN
            lrc_PurchaseImportDocuments.DELETEALL();

        lrc_VendorImportDocuments.RESET();
        lrc_VendorImportDocuments.SETRANGE("Vendor No.", vco_VendorNo);
        IF lrc_VendorImportDocuments.FINDSET(FALSE, FALSE) THEN
            REPEAT
                lrc_PurchaseImportDocuments.RESET();
                lrc_PurchaseImportDocuments.INIT();
                lrc_PurchaseImportDocuments."Document Type" := vop_PurchDocType;
                lrc_PurchaseImportDocuments."Document No." := vco_PurchDocNo;
                lrc_PurchaseImportDocuments."Line No." := 0;
                lrc_PurchaseImportDocuments."Import Doc. Code" := lrc_VendorImportDocuments."Import Document Code";
                lrc_PurchaseImportDocuments."Expected Receiving Date" := 0D;
                lrc_PurchaseImportDocuments."Due Date before Receiving" := lrc_VendorImportDocuments."Due Date before Receiving";
                lrc_PurchaseImportDocuments.INSERT(TRUE);
            UNTIL lrc_VendorImportDocuments.NEXT() = 0;
    end;

    procedure ImpDocUpdRecDate(vop_PurchDocType: Option "0","1","2","3","4","5","6","7","8","9"; vco_PurchDocNo: Code[20]; vdt_ExpReceiveDate: Date)
    begin
        // -----------------------------------------------------------------------------------------
        // Funktion zur Aktualisierung des erwartenden Erhaltes des Dokumentes
        // -----------------------------------------------------------------------------------------

        lrc_PurchaseImportDocuments.RESET();
        lrc_PurchaseImportDocuments.SETRANGE("Document Type", vop_PurchDocType);
        lrc_PurchaseImportDocuments.SETRANGE("Document No.", vco_PurchDocNo);
        IF lrc_PurchaseImportDocuments.FINDSET(TRUE, FALSE) THEN
            REPEAT
                lrc_PurchaseImportDocuments."Expected Receiving Date" :=
                        CALCDATE(lrc_PurchaseImportDocuments."Due Date before Receiving",
                                 vdt_ExpReceiveDate);
                lrc_PurchaseImportDocuments.MODIFY();
            UNTIL lrc_PurchaseImportDocuments.NEXT() = 0;
    end;

    var

        lrc_PurchLine: Record "Purchase Line";
        lrc_PurchLine2: Record "Purchase Line";
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_MeansofTransport: Record "POI Means of Transport";
        lrc_PurchDocType: Record "POI Purch. Doc. Subtype";
        lrc_FruitVisionTempII: Record "POI ADF Temp II";
        lrc_PurchHeader: Record "Purchase Header";
        lrc_PurchDocTypeFilter: Record "POI Purch. Doc. Subtype Filter";
        lrc_PurchaseAccSalesCost: Record "POI Purchase Acc. Sales Cost";
        lrc_CostCategory: Record "POI Cost Category";
        lrc_ProductGroup: Record "POI Product Group";
        lrc_ItemChargeAssignPurchase: Record "Item Charge Assignment (Purch)";
        lrc_PurchRcptLine: Record "Purch. Rcpt. Line";
        lrc_PurchRcptHeader: Record "Purch. Rcpt. Header";
        lrc_PurchaseLine1: Record "Purchase Line";
        lrc_PurchPostPriceDifference: Record "POI Purch. Post. Price Diff.";
        lrc_CostCategoryAccounts: Record "POI Cost Category Accounts";
        lrc_SalesLine: Record "Sales Line";
        lrc_CostSchemaLine: Record "POI Cost Schema Line";
        lrc_Erzeugerabrechnung: Record "POI Producer Statment Fees";
        lrc_PurchRcptLine2: Record "Purch. Rcpt. Line";
        lrc_SalesHeader: Record "Sales Header";
        lrc_ItemVendor: Record "Item Vendor";
        lrc_PurchLineNew: Record "Purchase Line";
        lrc_VendorImportDocuments: Record "POI Vendor - Import Documents";
        lrc_PurchaseImportDocuments: Record "POI Purchase - Import Documts";
}

