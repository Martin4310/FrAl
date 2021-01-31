codeunit 60004 "POI Port Mapping Management"
{

    //     Permissions = TableData 5125029 = rimd;
    //     TableNo = 5125029;

    //     trigger OnRun()
    //     begin
    //         ArchMappingCode.COPY(Rec);

    //         RunCode();
    //         Rec := ArchMappingCode;
    //     end;

    //     var
    //         ArchMappingCode: Record "POI ECM Mapping Code";
    //     //SupplyText: Codeunit "POI ECM Supply Text";
    //     //SupplyTextID: Integer;

    //     procedure RunCode()
    //     begin
    //         CASE ArchMappingCode.Parameters OF
    //             'KreditorenTyp':
    //                 KreditorenTyp();
    //             'CGN':
    //                 CGN();
    //             'Positionsnummern':
    //                 Positionsnummer();
    //             'Partienummern':
    //                 PartienummerZeile();
    //             'COMPANYSHORTNAME':
    //                 CompanyShortname();
    //             'Nettobetrag':
    //                 Nettobetrag();
    //             'Bruttobetrag':
    //                 Bruttobetrag();
    //         END;
    //     end;

    //     procedure KreditorenTyp()
    //     var
    //         Vendor: Record Vendor;
    //         PurchaseHeader: Record "Purchase Header";
    //         PurchRcptHeader: Record "Purch. Rcpt. Header";
    //         PurchInvHeader: Record "Purch. Inv. Header";
    //         PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    //         RecID: RecordID;
    //         RRef: RecordRef;
    //         KreditorenTypArr: array[6] of Text[30];
    //         KreditorenTypText: Text[1024];
    //         i: Integer;
    //     begin
    //         RecID := ArchMappingCode."Record ID";
    //         RRef := RecID.GETRECORD();
    //         RRef.SETVIEW(
    //           ArchMappingCode."Record View" +
    //           ArchMappingCode."Record View 2" +
    //           ArchMappingCode."Record View 3" +
    //           ArchMappingCode."Record View 4" +
    //           ArchMappingCode."Record View 5");
    //         IF NOT RRef.FIND('-') THEN
    //             EXIT;

    //         CASE RRef.NUMBER() OF
    //             38:
    //                 BEGIN
    //                     PurchaseHeader.SETVIEW(RRef.GETVIEW());
    //                     IF PurchaseHeader.FINDFIRST() THEN
    //                         IF Vendor.GET(PurchaseHeader."Buy-from Vendor No.") THEN BEGIN
    //                             IF Vendor."POI Supplier of Goods" THEN
    //                                 KreditorenTypARR[1] := 'Warenlieferant';
    //                             IF Vendor."POI Carrier" THEN
    //                                 KreditorenTypARR[2] := 'Transporteur';
    //                             IF Vendor."POI Warehouse Keeper" THEN
    //                                 KreditorenTypARR[3] := 'Lagerhalter';
    //                             IF Vendor."POI Customs Agent" THEN
    //                                 KreditorenTypARR[4] := 'Zollagent';
    //                             IF Vendor."POI Tax Representative" THEN
    //                                 KreditorenTypARR[5] := 'Fiskalvertreter';
    //                             IF Vendor."POI Diverse Vendor" THEN
    //                                 KreditorenTypARR[6] := 'Sonstiger Kreditor';
    //                             FOR i := 1 TO COMPRESSARRAY(KreditorenTypArr) DO
    //                                 IF i = 1 THEN
    //                                     KreditorenTypText := KreditorenTypText + KreditorenTypARR[i]
    //                                 ELSE
    //                                     KreditorenTypText := KreditorenTypText + ',' + KreditorenTypARR[i];
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := copystr(KreditorenTypText, 1, 250);
    //                         END;
    //                 END;
    //             120:
    //                 BEGIN
    //                     PurchRcptHeader.SETVIEW(RRef.GETVIEW());
    //                     IF PurchRcptHeader.FINDFIRST() THEN
    //                         IF Vendor.GET(PurchRcptHeader."Buy-from Vendor No.") THEN BEGIN
    //                             IF Vendor."POI Supplier of Goods" THEN
    //                                 KreditorenTypARR[1] := 'Warenlieferant';
    //                             IF Vendor."POI Carrier" THEN
    //                                 KreditorenTypARR[2] := 'Transporteur';
    //                             IF Vendor."POI Warehouse Keeper" THEN
    //                                 KreditorenTypARR[3] := 'Lagerhalter';
    //                             IF Vendor."POI Customs Agent" THEN
    //                                 KreditorenTypARR[4] := 'Zollagent';
    //                             IF Vendor."POI Tax Representative" THEN
    //                                 KreditorenTypARR[5] := 'Fiskalvertreter';
    //                             IF Vendor."POI Diverse Vendor" THEN
    //                                 KreditorenTypARR[6] := 'Sonstiger Kreditor';
    //                             FOR i := 1 TO COMPRESSARRAY(KreditorenTypArr) Do
    //                                 IF i = 1 THEN
    //                                     KreditorenTypText := KreditorenTypText + KreditorenTypARR[i]
    //                                 ELSE
    //                                     KreditorenTypText := KreditorenTypText + ',' + KreditorenTypARR[i];
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := copystr(KreditorenTypText, 1, 250);
    //                         END;

    //                 END;
    //             122:
    //                 BEGIN
    //                     PurchInvHeader.SETVIEW(RRef.GETVIEW());
    //                     IF PurchInvHeader.FINDFIRST() THEN
    //                         IF Vendor.GET(PurchInvHeader."Buy-from Vendor No.") THEN BEGIN
    //                             IF Vendor."POI Supplier of Goods" THEN
    //                                 KreditorenTypArr[1] := 'Warenlieferant';
    //                             IF Vendor."POI Carrier" THEN
    //                                 KreditorenTypArr[2] := 'Transporteur';
    //                             IF Vendor."POI Warehouse Keeper" THEN
    //                                 KreditorenTypArr[3] := 'Lagerhalter';
    //                             IF Vendor."POI Customs Agent" THEN
    //                                 KreditorenTypArr[4] := 'Zollagent';
    //                             IF Vendor."POI Tax Representative" THEN
    //                                 KreditorenTypArr[5] := 'Fiskalvertreter';
    //                             IF Vendor."POI Diverse Vendor" THEN
    //                                 KreditorenTypArr[6] := 'Sonstiger Kreditor';
    //                             FOR i := 1 TO COMPRESSARRAY(KreditorenTypArr) DO
    //                                 IF i = 1 THEN
    //                                     KreditorenTypText := KreditorenTypText + KreditorenTypArr[i]
    //                                 ELSE
    //                                     KreditorenTypText := KreditorenTypText + ',' + KreditorenTypArr[i];
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := copystr(KreditorenTypText, 1, 250);
    //                         END;
    //                 END;
    //             124:
    //                 BEGIN
    //                     PurchCrMemoHdr.SETVIEW(RRef.GETVIEW());
    //                     IF PurchCrMemoHdr.FINDFIRST() THEN
    //                         IF Vendor.GET(PurchCrMemoHdr."Buy-from Vendor No.") THEN BEGIN
    //                             IF Vendor."POI Supplier of Goods" THEN
    //                                 KreditorenTypArr[1] := 'Warenlieferant';
    //                             IF Vendor."POI Carrier" THEN
    //                                 KreditorenTypArr[2] := 'Transporteur';
    //                             IF Vendor."POI Warehouse Keeper" THEN
    //                                 KreditorenTypArr[3] := 'Lagerhalter';
    //                             IF Vendor."POI Customs Agent" THEN
    //                                 KreditorenTypArr[4] := 'Zollagent';
    //                             IF Vendor."POI Tax Representative" THEN
    //                                 KreditorenTypArr[5] := 'Fiskalvertreter';
    //                             IF Vendor."POI Diverse Vendor" THEN
    //                                 KreditorenTypArr[6] := 'Sonstiger Kreditor';
    //                             FOR i := 1 TO COMPRESSARRAY(KreditorenTypArr) DO
    //                                 IF i = 1 THEN
    //                                     KreditorenTypText := KreditorenTypText + KreditorenTypArr[i]
    //                                 ELSE
    //                                     KreditorenTypText := KreditorenTypText + ',' + KreditorenTypArr[i];
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := copystr(KreditorenTypText, 1, 250);
    //                         END;
    //                 END;
    //         END;
    //     end;

    //     procedure CGN()
    //     var
    //         RRef: RecordRef;
    //         RecID: RecordID;
    //     begin
    //         RecID := ArchMappingCode."Record ID";
    //         RRef := RecID.GETRECORD();
    //         RRef.SETVIEW(
    //           ArchMappingCode."Record View" +
    //           ArchMappingCode."Record View 2" +
    //           ArchMappingCode."Record View 3" +
    //           ArchMappingCode."Record View 4" +
    //           ArchMappingCode."Record View 5");
    //         IF NOT RRef.FIND('-') THEN
    //             EXIT;

    //         // CASE RRef.NUMBER()() OF //TODO: Sinn klären
    //         //     38:
    //         //         BEGIN
    //         //             PurchaseHeader.SETVIEW(RRef.GETVIEW());
    //         //             IF PurchaseHeader.FINDFIRST() THEN;
    //         //         END;
    //         // END;
    //         // CASE RRef.NUMBER()() OF
    //         //     37:
    //         //         BEGIN
    //         //             PurchaseHeader.SETVIEW(RRef.GETVIEW());
    //         //             IF PurchaseHeader.FINDFIRST() THEN;
    //         //         END;
    //         // END;
    //     end;

    //     procedure Positionsnummer()
    //     var
    //         PurchaseHeader: Record "Purchase Header";
    //         PurchaseLine: Record "Purchase Line";
    //         SalesHeader: Record "Sales Header";
    //         SalesLine: Record "Sales Line";
    //         SalesShipmentHeader: Record "Sales Shipment Header";
    //         SalesShipmentLine: Record "Sales Shipment Line";
    //         RRef: RecordRef;
    //         RecID: RecordID;
    //         PositionsnummernText: Text[1024];
    //         i: Integer;
    //     begin
    //         RecID := ArchMappingCode."Record ID";
    //         RRef := RecID.GETRECORD();
    //         RRef.SETVIEW(
    //           ArchMappingCode."Record View" +
    //           ArchMappingCode."Record View 2" +
    //           ArchMappingCode."Record View 3" +
    //           ArchMappingCode."Record View 4" +
    //           ArchMappingCode."Record View 5");
    //         IF NOT RRef.FIND('-') THEN
    //             EXIT;

    //         CASE RRef.NUMBER() OF
    //             38:
    //                 BEGIN
    //                     PurchaseHeader.SETVIEW(RRef.GETVIEW());
    //                     IF PurchaseHeader.FINDFIRST() THEN BEGIN
    //                         PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
    //                         PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
    //                         IF PurchaseLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF PurchaseLine."POI Batch No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(PurchaseLine."POI Batch No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + PurchaseLine."POI Batch No.", 1, 1024);
    //                                 END;
    //                                 ArchMappingCode.Valid := TRUE;
    //                                 ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                             UNTIL PurchaseLine.next() = 0;
    //                     END;
    //                 END;
    //             36:
    //                 BEGIN
    //                     SalesHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesHeader.FINDFIRST() THEN BEGIN
    //                         SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
    //                         SalesLine.SETRANGE("Document No.", SalesHeader."No.");
    //                         IF SalesLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF SalesLine."POI Batch No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(SalesLine."POI Batch No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + SalesLine."POI Batch No.", 1, 1024);
    //                                 END;
    //                                 ArchMappingCode.Valid := TRUE;
    //                                 ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                             UNTIL SalesLine.next() = 0;
    //                     END;
    //                 END;

    //             110:
    //                 BEGIN
    //                     SalesShipmentHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesShipmentHeader.FINDFIRST() THEN BEGIN
    //                         SalesShipmentLine.SETRANGE("Document No.", SalesShipmentHeader."No.");
    //                         IF SalesShipmentLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF SalesShipmentLine."POI Batch No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(SalesShipmentLine."POI Batch No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + SalesShipmentLine."POI Batch No.", 1, 1024);
    //                                 END;
    //                                 ArchMappingCode.Valid := TRUE;
    //                                 ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                             UNTIL SalesShipmentLine.next() = 0;
    //                     END;
    //                 END;

    //         END;
    //     end;

    //     procedure PartienummerZeile()
    //     var
    //         PurchaseHeader: Record "Purchase Header";
    //         PurchaseLine: Record "Purchase Line";
    //         SalesHeader: Record "Sales Header";
    //         SalesLine: Record "Sales Line";
    //         SalesShipmentHeader: Record "Sales Shipment Header";
    //         SalesShipmentLine: Record "Sales Shipment Line";
    //         PurchClaimNotifyLine: Record "POI Purch. Claim Notify Line";
    //         PurchClaimNotifyHeader: Record "POI Purch. Claim Notify Header";
    //         TransferHeader: Record "Transfer Header";
    //         TransferLine: Record "Transfer Line";
    //         SalesStatHeader: Record "5110533";
    //         SalesStatLine: Record "5110534";
    //         RRef: RecordRef;
    //         RecID: RecordID;
    //         PositionsnummernText: Text[1024];
    //         i: Integer;
    //     begin
    //         RecID := ArchMappingCode."Record ID";
    //         RRef := RecID.GETRECORD();
    //         RRef.SETVIEW(
    //           ArchMappingCode."Record View" +
    //           ArchMappingCode."Record View 2" +
    //           ArchMappingCode."Record View 3" +
    //           ArchMappingCode."Record View 4" +
    //           ArchMappingCode."Record View 5");
    //         IF NOT RRef.FIND('-') THEN
    //             EXIT;

    //         CASE RRef.NUMBER() OF
    //             38:
    //                 BEGIN
    //                     PurchaseHeader.SETVIEW(RRef.GETVIEW());
    //                     IF PurchaseHeader.FINDFIRST() THEN BEGIN
    //                         PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
    //                         PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
    //                         IF PurchaseLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF PurchaseLine."POI Batch No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(PurchaseLine."POI Master Batch No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + PurchaseLine."POI Master Batch No.", 1, 1024);
    //                                 END;
    //                                 ArchMappingCode.Valid := TRUE;
    //                                 ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                             UNTIL PurchaseLine.next() = 0;
    //                     END;
    //                 END;
    //             36:
    //                 BEGIN
    //                     SalesHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesHeader.FINDFIRST() THEN BEGIN
    //                         SalesLine.RESET();
    //                         SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
    //                         SalesLine.SETRANGE("Document No.", SalesHeader."No.");
    //                         IF SalesLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF SalesLine."POI Batch No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(SalesLine."POI Master Batch No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + SalesLine."POI Master Batch No.", 1, 1024);
    //                                 END;
    //                                 ArchMappingCode.Valid := TRUE;
    //                                 ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                             UNTIL SalesLine.next() = 0;
    //                     END;
    //                 END;

    //             110:
    //                 BEGIN
    //                     SalesShipmentHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesShipmentHeader.FINDFIRST() THEN BEGIN
    //                         SalesShipmentLine.SETRANGE("Document No.", SalesShipmentHeader."No.");
    //                         IF SalesShipmentLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF SalesShipmentLine."POI Batch No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(SalesShipmentLine."POI Master Batch No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + SalesShipmentLine."POI Master Batch No.", 1, 1024);
    //                                 END;
    //                                 ArchMappingCode.Valid := TRUE;
    //                                 ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                             UNTIL SalesShipmentLine.next() = 0;
    //                     END;
    //                 END;
    //             5110461:
    //                 BEGIN
    //                     PurchClaimNotifyHeader.SETVIEW(RRef.GETVIEW());
    //                     IF PurchClaimNotifyHeader.FINDFIRST() THEN BEGIN
    //                         PurchClaimNotifyLine.SETRANGE("Document No.", PurchClaimNotifyHeader."No.");
    //                         IF PurchClaimNotifyLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF PurchClaimNotifyLine."Batch Variant No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(PurchClaimNotifyLine."Batch Variant No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + PurchClaimNotifyLine."Batch Variant No.", 1, 1024);
    //                                     ArchMappingCode.Valid := TRUE;
    //                                     ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                                 END;
    //                             UNTIL PurchClaimNotifyLine.next() = 0;
    //                     END;
    //                 END;
    //             5740:
    //                 BEGIN
    //                     TransferHeader.SETVIEW(RRef.GETVIEW());
    //                     IF TransferHeader.FINDFIRST() THEN BEGIN
    //                         TransferLine.SETRANGE("Document No.", TransferHeader."No.");
    //                         IF TransferLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF TransferLine."POI Batch Variant No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(TransferLine."POI Batch Variant No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + TransferLine."POI Batch Variant No.", 1, 1024);
    //                                     ArchMappingCode.Valid := TRUE;
    //                                 END;
    //                             UNTIL TransferLine.next() = 0;
    //                         ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                     END;
    //                 END;
    //             5110533:
    //                 BEGIN
    //                     SalesStatHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesStatHeader.FINDFIRST() THEN BEGIN
    //                         SalesStatLine.SETRANGE("Document No.", SalesStatHeader."Document No.");
    //                         IF SalesStatLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 IF SalesStatLine."Master Batch No." <> '' THEN BEGIN
    //                                     i += 1;
    //                                     IF i = 1 THEN
    //                                         PositionsnummernText := COPYSTR(SalesStatLine."Master Batch No.", 1, 1024)
    //                                     ELSE
    //                                         PositionsnummernText := COPYSTR(PositionsnummernText + ',' + SalesStatLine."Master Batch No.", 1, 1024);
    //                                     ArchMappingCode.Valid := TRUE;
    //                                 END;
    //                             UNTIL SalesStatLine.next() = 0;
    //                         ArchMappingCode."Value Text" := copystr(PositionsnummernText, 1, 250);
    //                     END;
    //                 END;

    //         END;
    //     end;

    procedure DMS_Aktive_Check(): Boolean
    var
        POICompany: Record "POI Company";
    begin
        if POICompany.Get(CompanyName()) and POICompany."DMS aktiv" then
            exit(true)
        else
            EXIT(FALSE);
    end;

    //     procedure CompanyShortname()
    //     var
    //         ECMSetup: Record "POI ECM Setup";
    //     begin
    //         IF ECMSetup.GET THEN BEGIN
    //             ArchMappingCode.Valid := TRUE;
    //             ArchMappingCode."Value Text" := ECMSetup."Company Shortname";
    //         END;
    //     end;

    //     procedure Nettobetrag()
    //     var
    //         PurchaseHeader: Record "Purchase Header";
    //         PurchaseLine: Record "Purchase Line";
    //         SalesHeader: Record "Sales Header";
    //         SalesLine: Record "Sales Line";
    //         SalesShipmentHeader: Record "Sales Shipment Header";
    //         SalesShipmentLine: Record "Sales Shipment Line";
    //         SalesInvoiceHeader: Record "Sales Invoice Header";
    //         SalesInvoiceLine: Record "Sales Invoice Line";
    //         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    //         SalesCrMemoLine: Record "Sales Cr.Memo Line";
    //         AccSalesHeader: Record "5110512";
    //         AccSalesItem: Record "5110514";
    //         RRef: RecordRef;
    //         RecID: RecordID;
    //         Amount: Decimal;
    //     begin
    //         RecID := ArchMappingCode."Record ID";
    //         RRef := RecID.GETRECORD();
    //         RRef.SETVIEW(
    //           ArchMappingCode."Record View" +
    //           ArchMappingCode."Record View 2" +
    //           ArchMappingCode."Record View 3" +
    //           ArchMappingCode."Record View 4" +
    //           ArchMappingCode."Record View 5");
    //         IF NOT RRef.FIND('-') THEN
    //             EXIT;

    //         CASE RRef.NUMBER() OF
    //             38:
    //                 BEGIN
    //                     PurchaseHeader.SETVIEW(RRef.GETVIEW());
    //                     IF PurchaseHeader.FINDFIRST() THEN BEGIN
    //                         PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
    //                         PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
    //                         IF PurchaseLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + (PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost");
    //                             UNTIL PurchaseLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //             36:
    //                 BEGIN
    //                     SalesHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesHeader.FINDFIRST() THEN BEGIN
    //                         SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
    //                         SalesLine.SETRANGE("Document No.", SalesHeader."No.");
    //                         IF SalesLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + (SalesLine.Quantity * SalesLine."Unit Price");
    //                             UNTIL SalesLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //             110:
    //                 BEGIN
    //                     SalesShipmentHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesShipmentHeader.FINDFIRST() THEN BEGIN
    //                         SalesShipmentLine.SETRANGE("Document No.", SalesShipmentHeader."No.");
    //                         IF SalesShipmentLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + (SalesShipmentLine.Quantity * SalesShipmentLine."Unit Price");
    //                             UNTIL SalesShipmentLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //             112:
    //                 BEGIN
    //                     SalesInvoiceHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesInvoiceHeader.FINDFIRST() THEN BEGIN
    //                         SalesShipmentLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
    //                         IF SalesInvoiceLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + SalesInvoiceLine.Amount;
    //                             UNTIL SalesInvoiceLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //             114:
    //                 BEGIN
    //                     SalesCrMemoHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesCrMemoHeader.FINDFIRST() THEN BEGIN
    //                         SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
    //                         IF SalesCrMemoLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + SalesCrMemoLine.Amount;
    //                             UNTIL SalesCrMemoLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;

    //             5110512:
    //                 BEGIN
    //                     AccSalesHeader.SETVIEW(RRef.GETVIEW());
    //                     IF AccSalesHeader.FINDFIRST() THEN BEGIN
    //                         AccSalesItem.SETRANGE("Doc. No.", AccSalesHeader."No.");
    //                         IF AccSalesItem.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + AccSalesItem."Posting Purchase Amount Net";
    //                             UNTIL AccSalesItem.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;

    //         END;
    //     end;

    //     procedure Bruttobetrag()
    //     var
    //         PurchaseHeader: Record "Purchase Header";
    //         PurchaseLine: Record "Purchase Line";
    //         SalesHeader: Record "Sales Header";
    //         SalesLine: Record "Sales Line";
    //         SalesShipmentHeader: Record "Sales Shipment Header";
    //         SalesShipmentLine: Record "Sales Shipment Line";
    //         SalesInvoiceHeader: Record "Sales Invoice Header";
    //         SalesInvoiceLine: Record "Sales Invoice Line";
    //         SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    //         SalesCrMemoLine: Record "Sales Cr.Memo Line";
    //         AccSalesHeader: Record "5110512";
    //         AccSalesItem: Record "5110514";
    //         RRef: RecordRef;
    //         RecID: RecordID;
    //         Amount: Decimal;
    //     begin
    //         RecID := ArchMappingCode."Record ID";
    //         RRef := RecID.GETRECORD();
    //         RRef.SETVIEW(
    //           ArchMappingCode."Record View" +
    //           ArchMappingCode."Record View 2" +
    //           ArchMappingCode."Record View 3" +
    //           ArchMappingCode."Record View 4" +
    //           ArchMappingCode."Record View 5");
    //         IF NOT RRef.FIND('-') THEN
    //             EXIT;

    //         CASE RRef.NUMBER() OF
    //             38:
    //                 BEGIN
    //                     PurchaseHeader.SETVIEW(RRef.GETVIEW());
    //                     IF PurchaseHeader.FINDFIRST() THEN BEGIN
    //                         PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
    //                         PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
    //                         IF PurchaseLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + (PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost" * (1 + PurchaseLine."VAT %" / 100));
    //                             UNTIL PurchaseLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //             36:
    //                 BEGIN
    //                     SalesHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesHeader.FINDFIRST() THEN BEGIN
    //                         SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
    //                         SalesLine.SETRANGE("Document No.", SalesHeader."No.");
    //                         IF SalesLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + (SalesLine.Quantity * SalesLine."Unit Price" * (1 + SalesLine."VAT %" / 100));
    //                             UNTIL SalesLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //             110:
    //                 BEGIN
    //                     SalesShipmentHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesShipmentHeader.FINDFIRST() THEN BEGIN
    //                         SalesShipmentLine.SETRANGE("Document No.", SalesShipmentHeader."No.");
    //                         IF SalesShipmentLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + (SalesShipmentLine.Quantity * SalesShipmentLine."Unit Price" * (1 + SalesShipmentLine."VAT %" / 100));
    //                             UNTIL SalesShipmentLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //             112:
    //                 BEGIN
    //                     SalesInvoiceHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesInvoiceHeader.FINDFIRST() THEN BEGIN
    //                         SalesShipmentLine.SETRANGE("Document No.", SalesInvoiceHeader."No.");
    //                         IF SalesInvoiceLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + SalesInvoiceLine."Amount Including VAT";
    //                             UNTIL SalesInvoiceLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //             114:
    //                 BEGIN
    //                     SalesCrMemoHeader.SETVIEW(RRef.GETVIEW());
    //                     IF SalesCrMemoHeader.FINDFIRST() THEN BEGIN
    //                         SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
    //                         IF SalesCrMemoLine.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + SalesCrMemoLine."Amount Including VAT";
    //                             UNTIL SalesCrMemoLine.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;

    //             5110512:
    //                 BEGIN
    //                     AccSalesHeader.SETVIEW(RRef.GETVIEW());
    //                     IF AccSalesHeader.FINDFIRST() THEN BEGIN
    //                         AccSalesItem.SETRANGE("Doc. No.", AccSalesHeader."No.");
    //                         IF AccSalesItem.FINDFIRST() THEN
    //                             REPEAT
    //                                 Amount := Amount + AccSalesItem."Posting Purchase Amount Brut";
    //                             UNTIL AccSalesItem.next() = 0;
    //                         IF Amount <> 0 THEN BEGIN
    //                             ArchMappingCode.Valid := TRUE;
    //                             ArchMappingCode."Value Text" := FORMAT(Amount, 0, '<Sign><Integer Thousand><Decimals>');
    //                         END;
    //                     END;
    //                 END;
    //         END;
    //     end;
}

