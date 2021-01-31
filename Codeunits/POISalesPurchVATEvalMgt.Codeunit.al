codeunit 5110360 "POI Sales/Purch VAT Eval Mgt"
{
    //     Permissions = TableData 36 = rimd;

    var
        ADF_Setup: Record "POI ADF Setup";
        grc_CompanyInformation: Record "Company Information";
        //AGILESText001Txt: Label 'NONE';
        //Frm_PruefSalesVateEvaluation: Form "5088005";
        CompCountry: Code[10];
    //filt_start: Label '<>''*';
    //filt_end: Label '*''';

    //     procedure SalesCalcBusPosGrp(vin_SalesDocType: Option "0","1","2","3","4","5","6","7"; vco_SalesDocNo: Code[20])
    //     var
    //         lrc_SalesHeader: Record "36";
    //         lrc_SalesLine: Record "37";
    //         lco_GenBusPostingGroup: Code[10];
    //         lco_VatBusPostingGroup: Code[10];
    //         lco_TaxRegistrationNo: Code[20];
    //         lbn_EqualValues: Boolean;
    //         "-- VAT 005 MFL40124 L": Integer;
    //         lrc_SalesDocSubtype: Record "5110411";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_SalesLineTemp: Record "37" temporary;
    //         lrc_SalesHeaderTemp: Record "36" temporary;
    //         lrc_SalesVATEvaluationTemp: Record "5087926" temporary;
    //         lbn_SalesVATEvaluationFound: Boolean;
    //         lco_PostingNoSeries: Code[10];
    //         lbn_InitNoSeries: Boolean;
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Kontrolle Geschäftsbuchungsgruppe
    //         // ------------------------------------------------------------------------------------------------

    //         // VAT 002 MFL40119.s
    //         lrc_SalesHeader.GET(vin_SalesDocType, vco_SalesDocNo);
    //         // VAT 002 MFL40119.e

    //         // VAT 005 MFL40124.s
    //         lrc_SalesDocSubtype.GET(lrc_SalesHeader."Document Type", lrc_SalesHeader."Sales Doc. Subtype Code");

    //         IF NOT lrc_SalesDocSubtype."Use VAT Evaluation" THEN EXIT;
    //         // VAT 005 MFL40124.e

    //         lrc_SalesHeader."Company Tax Registration No." := '';

    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type", lrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.", lrc_SalesHeader."No.");
    //         lrc_SalesLine.SETFILTER(Type, '<>%1', lrc_SalesLine.Type::" ");
    //         lrc_SalesLine.SETFILTER("No.", '<>%1', '');
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN
    //             REPEAT

    //                 // VAT 002 MFL40119.s
    //                 IF SalesGetBusPosGrp(lrc_SalesHeader, lrc_SalesLine, lco_GenBusPostingGroup,
    //                                           lco_VatBusPostingGroup, lco_TaxRegistrationNo, lbn_EqualValues,
    //                                           lrc_SalesVATEvaluation, lbn_SalesVATEvaluationFound) = TRUE THEN BEGIN

    //                     //161221 rs Buchungsgruppen auch in Header ändern
    //                     lrc_SalesHeader."Gen. Bus. Posting Group" := lco_GenBusPostingGroup;
    //                     lrc_SalesHeader."VAT Bus. Posting Group" := lco_VatBusPostingGroup;
    //                     lrc_SalesHeader.MODIFY();
    //                     //161221 rs.e

    //                     // VAT 002 MFL40119.e
    //                     lrc_SalesLine.VALIDATE("Gen. Bus. Posting Group", lco_GenBusPostingGroup);
    //                     lrc_SalesLine.VALIDATE("VAT Bus. Posting Group", lco_VatBusPostingGroup);
    //                     lrc_SalesLine.MODIFY();

    //                 END ELSE BEGIN
    //                     IF (lbn_EqualValues = FALSE) AND
    //                        ((lrc_SalesLine."Gen. Bus. Posting Group" <> lrc_SalesHeader."Gen. Bus. Posting Group") OR
    //                         (lrc_SalesLine."VAT Bus. Posting Group" <> lrc_SalesHeader."VAT Bus. Posting Group")) THEN BEGIN
    //                         //VAT 010 port     JST 230413     kein Übertrag GeschBuc Kopf->Zeilen raus, Zeile unverändert blei z.B. man.Korrekturen
    //                         //lrc_SalesLine.VALIDATE("Gen. Bus. Posting Group",lrc_SalesHeader."Gen. Bus. Posting Group");
    //                         //lrc_SalesLine.VALIDATE("VAT Bus. Posting Group",lrc_SalesHeader."VAT Bus. Posting Group");
    //                         //lrc_SalesLine.MODIFY();
    //                     END;
    //                 END;

    //                 IF lrc_SalesHeader."Company Tax Registration No." = '' THEN BEGIN
    //                     lrc_SalesHeader."Company Tax Registration No." := lco_TaxRegistrationNo;
    //                     lrc_SalesHeader.MODIFY();
    //                 END;

    //                 // VAT 006 DMG50143.s
    //                 // Verkaufszeile merken, für welche eine "Sales VAT Evaluation" Zeile gefunden wurde
    //                 // Alle gefundenen "Sales VAT Evaluation" Zeilen merken
    //                 IF lbn_SalesVATEvaluationFound THEN BEGIN
    //                     lrc_SalesLineTemp := lrc_SalesLine;
    //                     lrc_SalesLineTemp.INSERT(FALSE);

    //                     //VAT 001 port     JST 240512   Neues Feld 50001 Lieferbedingungscode -> in Key
    //                     //VAT 002 port     JST 080812   "Not Arrival Country Code" in Key
    //                     //140923 rs Anpassung Primärschlüssel "Sales/Purch Doc. Type" + "Sales/Purch Doc. Subtype Code" + "Line No." raus
    //                     //140923 rs "Fiscal Reg." + "Not departure Country Code" rein
    //                     IF NOT lrc_SalesVATEvaluationTemp.GET(lrc_SalesVATEvaluation.Source,
    //                                                           lrc_SalesVATEvaluation."Cust/Vend Posting Group",
    //                                                           lrc_SalesVATEvaluation."Cust/Vend Country Code",
    //                                                           lrc_SalesVATEvaluation."Departure Country Code",
    //                                                           lrc_SalesVATEvaluation."Departure Location Code",
    //                                                           lrc_SalesVATEvaluation."Arrival Country Code",
    //                                                           lrc_SalesVATEvaluation."Not Arrival Country Code",
    //                                                           lrc_SalesVATEvaluation."Shipment Type",
    //                                                           lrc_SalesVATEvaluation."Shipment Method Code",
    //                                                           lrc_SalesVATEvaluation."State Customer Duty",
    //                                                           lrc_SalesVATEvaluation."Line Type",
    //                                                           lrc_SalesVATEvaluation."Fiscal Agent",
    //                                                           lrc_SalesVATEvaluation."Fiscal Reg.",
    //                                                           lrc_SalesVATEvaluation."Not Departure Country Code",
    //                                                           lrc_SalesVATEvaluation."Valid From")
    //                     THEN BEGIN
    //                         lrc_SalesVATEvaluationTemp := lrc_SalesVATEvaluation;
    //                         lrc_SalesVATEvaluationTemp.INSERT(FALSE);
    //                     END;

    //                 END;
    //             // VAT 006 DMG50143.e

    //             UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;

    //         // VAT 006 DMG50143.s
    //         // Es wird geprüft ob evtl. das Feld lrc_SalesHeader."Posting No. Series" abhängig von in "Sales VAT Evaluation" gefundenen
    //         // Einstellungen geändert werden soll. Wenn es nicht der Fall ist, wird geprüft, ob evtl. eine Standard Nummernserie
    //         // wiederherstellt werden muss, wenn davor geändert wurde, aber die Konstellation nicht mehr vorhanden ist

    //         // "Posting No. Series" im Kopf wird geändert, wenn für jede VK Zeile eine entsprechende "Sales VAT Evaluation" Zeile gefunden
    //         // wurde und in allen gefundenen "Sales VAT Evaluation" Zeilen entsprechende Nummernserie Felder gleichen Wert <> '' haben

    //         lco_PostingNoSeries := '';
    //         lbn_InitNoSeries := FALSE;

    //         lbn_InitNoSeries := lrc_SalesVATEvaluationTemp.ISEMPTY;

    //         IF NOT lbn_InitNoSeries THEN BEGIN
    //             lbn_InitNoSeries := lrc_SalesLine.COUNT <> lrc_SalesLineTemp.COUNT;
    //         END;

    //         IF NOT lbn_InitNoSeries THEN BEGIN
    //             lrc_SalesVATEvaluationTemp.Reset();
    //             IF lrc_SalesVATEvaluationTemp.FIND('-') THEN BEGIN
    //                 REPEAT

    //                     CASE lrc_SalesHeader."Document Type" OF
    //                         lrc_SalesHeader."Document Type"::Order, lrc_SalesHeader."Document Type"::Invoice:
    //                             BEGIN
    //                                 IF lrc_SalesVATEvaluationTemp."Posted Invoice Nos." = '' THEN BEGIN
    //                                     lbn_InitNoSeries := TRUE;
    //                                 END ELSE BEGIN
    //                                     // Erste Nummernserie merken
    //                                     IF lco_PostingNoSeries = '' THEN BEGIN
    //                                         lco_PostingNoSeries := lrc_SalesVATEvaluationTemp."Posted Invoice Nos.";
    //                                     END;
    //                                     lbn_InitNoSeries := lco_PostingNoSeries <> lrc_SalesVATEvaluationTemp."Posted Invoice Nos.";
    //                                 END;
    //                             END;

    //                         lrc_SalesHeader."Document Type"::"Return Order", lrc_SalesHeader."Document Type"::"Credit Memo":
    //                             BEGIN
    //                                 IF lrc_SalesVATEvaluationTemp."Posted Credit Memo Nos." = '' THEN BEGIN
    //                                     lbn_InitNoSeries := TRUE;
    //                                 END ELSE BEGIN
    //                                     // Erste Nummernserie merken
    //                                     IF lco_PostingNoSeries = '' THEN BEGIN
    //                                         lco_PostingNoSeries := lrc_SalesVATEvaluationTemp."Posted Credit Memo Nos.";
    //                                     END;
    //                                     lbn_InitNoSeries := lco_PostingNoSeries <> lrc_SalesVATEvaluationTemp."Posted Credit Memo Nos.";
    //                                 END;

    //                             END;
    //                     END;

    //                 UNTIL (lrc_SalesVATEvaluationTemp.NEXT() = 0) OR (lbn_InitNoSeries = TRUE);
    //             END;
    //         END;

    //         // Standard Nummernserie wird, wenn abweichend, wiederherstellt
    //         IF lbn_InitNoSeries THEN BEGIN
    //             lrc_SalesHeaderTemp := lrc_SalesHeader;
    //             lrc_SalesHeaderTemp.ADF_InitNoSeries();
    //             IF lrc_SalesHeader."Posting No. Series" <> lrc_SalesHeaderTemp."Posting No. Series" THEN BEGIN
    //                 lrc_SalesHeader."Posting No. Series" := lrc_SalesHeaderTemp."Posting No. Series";
    //                 lrc_SalesHeader.MODIFY();
    //             END;
    //         END ELSE BEGIN
    //             IF lco_PostingNoSeries <> '' THEN BEGIN
    //                 lrc_SalesHeader."Posting No. Series" := lco_PostingNoSeries;
    //                 lrc_SalesHeader.MODIFY();
    //             END;
    //         END;

    //         // VAT 006 DMG50143.e
    //     end;

    //     procedure SalesGetBusPosGrp(vrc_SalesHeader: Record "36"; vrc_SalesLine: Record "37"; var rco_GenBusPostingGroup: Code[10]; var rco_VatBusPostingGroup: Code[10]; var rco_TaxRegistrationNo: Code[20]; var rbn_EqualValues: Boolean; var rrc_SalesVATEvaluation: Record "5087926"; var rbn_SalesVATEvaluationFound: Boolean): Boolean
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_VATRegistrationNo: Record "50022";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der steuerlichen Kontierung
    //         // ------------------------------------------------------------------------------------------------
    //         // vrc_SalesHeader
    //         // vrc_SalesLine
    //         // rco_GenBusPostingGroup
    //         // rco_VatBusPostingGroup
    //         // ------------------------------------------------------------------------------------------------

    //         // VAT 001 MFL40116.s
    //         // Hier ist keine Umstellung des Quelltextes, da hier noch einige weitere Filter gesetzt werden.
    //         // VAT 001 MFL40116.e
    //         rbn_EqualValues := FALSE;
    //         SalesFilterTaxRecord(vrc_SalesHeader, vrc_SalesLine, lrc_SalesVATEvaluation);

    //         // VAT 006 DMG50143.s
    //         CLEAR(rrc_SalesVATEvaluation);
    //         rbn_SalesVATEvaluationFound := FALSE;
    //         // VAT 006 DMG50143.e

    //         // VAT Satz suchen
    //         IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             rco_TaxRegistrationNo := lrc_SalesVATEvaluation."Registration No.";

    //             // VAT 006 DMG50143.s
    //             rrc_SalesVATEvaluation := lrc_SalesVATEvaluation;
    //             rbn_SalesVATEvaluationFound := TRUE;
    //             // VAT 006 DMG50143.e

    //             IF (lrc_SalesVATEvaluation."Gen. Bus. Posting Group" <> vrc_SalesLine."Gen. Bus. Posting Group") OR
    //                (lrc_SalesVATEvaluation."VAT Bus. Posting Group" <> vrc_SalesLine."VAT Bus. Posting Group") THEN BEGIN
    //                 rco_GenBusPostingGroup := lrc_SalesVATEvaluation."Gen. Bus. Posting Group";
    //                 rco_VatBusPostingGroup := lrc_SalesVATEvaluation."VAT Bus. Posting Group";
    //                 EXIT(TRUE);
    //             END ELSE BEGIN
    //                 rbn_EqualValues := TRUE;
    //                 EXIT(FALSE);
    //             END;
    //         END ELSE BEGIN
    //             //VAT 010 port     JST 230413     kein Übertrag GeschBuc Kopf->Zeilen raus, Zeile unverändert blei z.B. man.Korrekturen
    //             //IF vrc_SalesHeader."Gen. Bus. Posting Group" <> vrc_SalesLine."Gen. Bus. Posting Group" THEN BEGIN
    //             //rco_GenBusPostingGroup := vrc_SalesHeader."Gen. Bus. Posting Group";
    //             //rco_VatBusPostingGroup := vrc_SalesHeader."VAT Bus. Posting Group";
    //             //EXIT(TRUE);
    //             //END ELSE
    //             //EXIT(FALSE);
    //             //RS Abfrage, wenn kein Datensatz gefunden
    //             //IF NOT CONFIRM('Keine VAT-Regel gefunden, wollen Sie trotzdem fakturieren? (bitte Info an IT-NAVISION)', FALSE)
    //             //  THEN ERROR('Keine VAT-Regel gefunden');
    //             //160607 rs
    //             ERROR('Keine VAT Regel gefunden, bitte an IT-NAVISION wenden, %1, %2', vrc_SalesLine.Type, vrc_SalesLine."Line No.");
    //         END;
    //         EXIT(FALSE);
    //     end;

    //     procedure SalesInvGetAdditionalText(vrc_SalesInvoiceHeader: Record "112"; var rtx_ArrAddText: array[4] of Text[100])
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_VATRegistrationNo: Record "50022";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der steuerlichen Zusatztexte
    //         // ------------------------------------------------------------------------------------------------





    //         //mly 140704 - diese funktion wird laut DEVTOOL gar nicht verwendet





    //         // VAT 001 MFL40116
    //         // Hier ist keine Umstellung des Quelltextes, da hier der Location Code des Headers abgefragt wird
    //         // im Gegensatz zu allen anderen Stellen.

    //         //Achtung Fkt. prüft nur auf SalesInvoiceHeader -> keine Zeilenabfrage  ->
    //         //besser Fkt. verwenden : SalesInvoiceGetAdditionalText, SalesInvoiceGetFiscalAgentText
    //         //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //     end;

    //     procedure SalesInvoiceGetAdditionalText(vrc_SalesInvoiceHeader: Record "112"; vrc_SalesInvoiceLine: Record "113"; var rtx_ArrAddText: array[4] of Text[100])
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_LanguageTranslation2: Record "5087922";
    //         lrc_VATRegistrationNo: Record "50022";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der steuerlichen Zusatztexte
    //         // ------------------------------------------------------------------------------------------------

    //         // VAT 001 MFL40116
    //         SalesInvoiceFilterTaxRecord(vrc_SalesInvoiceHeader, vrc_SalesInvoiceLine, lrc_SalesVATEvaluation);

    //         //IFW 001 IFW40151
    //         IF lrc_SalesVATEvaluation.GETFILTERS = '' THEN
    //             EXIT;

    //         IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //             rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //             rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //             rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";

    //             lrc_LanguageTranslation2.Reset();
    //             lrc_LanguageTranslation2.SETCURRENTKEY(
    //                "Table ID", "Language Code", "Customer Posting Group", "Customer Country Code", "Departure Country Code"
    //               , "Arrival Country Code", "Not Arrival Country Code", "Shipment Method Code", "Shipment Type"
    //               , "Departure Location Code", Source, "State Customer Duty", "Sales/Purch Doc. Type"
    //               , "Sales/Purch Doc. Subtype Code", "Line Type", "Line Code");

    //             lrc_LanguageTranslation2.SETRANGE("Table ID", DATABASE::"Sales/Purch. VAT Evaluation");
    //             lrc_LanguageTranslation2.SETRANGE("Customer Posting Group", lrc_SalesVATEvaluation."Cust/Vend Posting Group");
    //             lrc_LanguageTranslation2.SETRANGE("Customer Country Code", lrc_SalesVATEvaluation."Cust/Vend Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Departure Country Code", lrc_SalesVATEvaluation."Departure Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Arrival Country Code", lrc_SalesVATEvaluation."Arrival Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Not Arrival Country Code", lrc_SalesVATEvaluation."Not Arrival Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Shipment Method Code", lrc_SalesVATEvaluation."Shipment Method Code");
    //             lrc_LanguageTranslation2.SETRANGE("Shipment Type", lrc_SalesVATEvaluation."Shipment Type");

    //             lrc_LanguageTranslation2.SETRANGE("Departure Location Code", lrc_SalesVATEvaluation."Departure Location Code");
    //             lrc_LanguageTranslation2.SETRANGE(Source, lrc_SalesVATEvaluation.Source);
    //             lrc_LanguageTranslation2.SETRANGE("State Customer Duty", lrc_SalesVATEvaluation."State Customer Duty");
    //             lrc_LanguageTranslation2.SETRANGE("Sales/Purch Doc. Type", lrc_SalesVATEvaluation."Sales/Purch Doc. Type");
    //             lrc_LanguageTranslation2.SETRANGE("Sales/Purch Doc. Subtype Code", lrc_SalesVATEvaluation."Sales/Purch Doc. Subtype Code");

    //             lrc_LanguageTranslation2.SETRANGE("Line Type", lrc_SalesVATEvaluation."Line Type");
    //             lrc_LanguageTranslation2.SETRANGE("Line Code", lrc_SalesVATEvaluation."Line No.");
    //             lrc_LanguageTranslation2.SETRANGE("Language Code", vrc_SalesInvoiceHeader."Language Code");


    //             IF lrc_LanguageTranslation2.FIND('-') THEN BEGIN
    //                 IF (lrc_LanguageTranslation2."Additional Inv. Text 1" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 2" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 3" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 4" <> '') THEN BEGIN
    //                     rtx_ArrAddText[1] := lrc_LanguageTranslation2."Additional Inv. Text 1";
    //                     rtx_ArrAddText[2] := lrc_LanguageTranslation2."Additional Inv. Text 2";
    //                     rtx_ArrAddText[3] := lrc_LanguageTranslation2."Additional Inv. Text 3";
    //                     rtx_ArrAddText[4] := lrc_LanguageTranslation2."Additional Inv. Text 4";
    //                 END;
    //             END;
    //         END;
    //     end;

    //     procedure SalesCrMemoGetAdditionalText(vrc_SalesCrMemoHeader: Record "114"; vrc_SalesCrMemoLine: Record "115"; var rtx_ArrAddText: array[4] of Text[100])
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_LanguageTranslation2: Record "5087922";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der steuerlichen Zusatztexte
    //         // ------------------------------------------------------------------------------------------------

    //         // VAT 001 MFL40116
    //         SalesCrMemoFilterTaxRecord(vrc_SalesCrMemoHeader, vrc_SalesCrMemoLine, lrc_SalesVATEvaluation);

    //         //IFW 001 IFW40151
    //         IF lrc_SalesVATEvaluation.GETFILTERS = '' THEN
    //             EXIT;

    //         IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //             rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //             rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //             rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";

    //             lrc_LanguageTranslation2.Reset();
    //             lrc_LanguageTranslation2.SETCURRENTKEY(
    //                "Table ID", "Language Code", "Customer Posting Group", "Customer Country Code", "Departure Country Code"
    //               , "Arrival Country Code", "Not Arrival Country Code", "Shipment Method Code", "Shipment Type"
    //               , "Departure Location Code", Source, "State Customer Duty", "Sales/Purch Doc. Type"
    //               , "Sales/Purch Doc. Subtype Code", "Line Type", "Line Code");


    //             lrc_LanguageTranslation2.SETRANGE("Table ID", DATABASE::"Sales/Purch. VAT Evaluation");
    //             lrc_LanguageTranslation2.SETRANGE("Customer Posting Group", lrc_SalesVATEvaluation."Cust/Vend Posting Group");
    //             lrc_LanguageTranslation2.SETRANGE("Customer Country Code", lrc_SalesVATEvaluation."Cust/Vend Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Departure Country Code", lrc_SalesVATEvaluation."Departure Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Arrival Country Code", lrc_SalesVATEvaluation."Arrival Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Not Arrival Country Code", lrc_SalesVATEvaluation."Not Arrival Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Shipment Method Code", lrc_SalesVATEvaluation."Shipment Method Code");
    //             lrc_LanguageTranslation2.SETRANGE("Shipment Type", lrc_SalesVATEvaluation."Shipment Type");
    //             //port.23.10.12
    //             lrc_LanguageTranslation2.SETRANGE("Departure Location Code", lrc_SalesVATEvaluation."Departure Location Code");
    //             lrc_LanguageTranslation2.SETRANGE(Source, lrc_SalesVATEvaluation.Source);
    //             lrc_LanguageTranslation2.SETRANGE("State Customer Duty", lrc_SalesVATEvaluation."State Customer Duty");
    //             lrc_LanguageTranslation2.SETRANGE("Sales/Purch Doc. Type", lrc_SalesVATEvaluation."Sales/Purch Doc. Type");
    //             lrc_LanguageTranslation2.SETRANGE("Sales/Purch Doc. Subtype Code", lrc_SalesVATEvaluation."Sales/Purch Doc. Subtype Code");

    //             lrc_LanguageTranslation2.SETRANGE("Line Type", lrc_SalesVATEvaluation."Line Type");
    //             lrc_LanguageTranslation2.SETRANGE("Line Code", lrc_SalesVATEvaluation."Line No.");
    //             lrc_LanguageTranslation2.SETRANGE("Language Code", vrc_SalesCrMemoHeader."Language Code");

    //             IF lrc_LanguageTranslation2.FIND('-') THEN BEGIN
    //                 IF (lrc_LanguageTranslation2."Additional Inv. Text 1" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 2" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 3" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 4" <> '') THEN BEGIN
    //                     rtx_ArrAddText[1] := lrc_LanguageTranslation2."Additional Inv. Text 1";
    //                     rtx_ArrAddText[2] := lrc_LanguageTranslation2."Additional Inv. Text 2";
    //                     rtx_ArrAddText[3] := lrc_LanguageTranslation2."Additional Inv. Text 3";
    //                     rtx_ArrAddText[4] := lrc_LanguageTranslation2."Additional Inv. Text 4";
    //                 END;
    //             END;
    //         END;
    //     end;

    //     procedure GetAdditionalTextSales(vrc_SalesHeader: Record "36"; vrc_SalesLine: Record "37"; var rtx_ArrAddText: array[4] of Text[100])
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_LanguageTranslation2: Record "5087922";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der steuerlichen Zusatztexte
    //         // ------------------------------------------------------------------------------------------------

    //         // VAT 001 MFL40116
    //         SalesFilterTaxRecord(vrc_SalesHeader, vrc_SalesLine, lrc_SalesVATEvaluation);

    //         IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-


    //             rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //             rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //             rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //             rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";

    //             lrc_LanguageTranslation2.Reset();
    //             lrc_LanguageTranslation2.SETCURRENTKEY(
    //                "Table ID", "Language Code", "Customer Posting Group", "Customer Country Code", "Departure Country Code"
    //               , "Arrival Country Code", "Not Arrival Country Code", "Shipment Method Code", "Shipment Type"
    //               , "Departure Location Code", Source, "State Customer Duty", "Sales/Purch Doc. Type"
    //               , "Sales/Purch Doc. Subtype Code", "Line Type", "Line Code");

    //             lrc_LanguageTranslation2.SETRANGE("Table ID", DATABASE::"Sales/Purch. VAT Evaluation");
    //             lrc_LanguageTranslation2.SETRANGE("Customer Posting Group", lrc_SalesVATEvaluation."Cust/Vend Posting Group");
    //             lrc_LanguageTranslation2.SETRANGE("Customer Country Code", lrc_SalesVATEvaluation."Cust/Vend Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Departure Country Code", lrc_SalesVATEvaluation."Departure Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Arrival Country Code", lrc_SalesVATEvaluation."Arrival Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Not Arrival Country Code", lrc_SalesVATEvaluation."Not Arrival Country Code");
    //             lrc_LanguageTranslation2.SETRANGE("Shipment Method Code", lrc_SalesVATEvaluation."Shipment Method Code");
    //             lrc_LanguageTranslation2.SETRANGE("Shipment Type", lrc_SalesVATEvaluation."Shipment Type");
    //             //port.23.10.12
    //             lrc_LanguageTranslation2.SETRANGE("Departure Location Code", lrc_SalesVATEvaluation."Departure Location Code");
    //             lrc_LanguageTranslation2.SETRANGE(Source, lrc_SalesVATEvaluation.Source);
    //             lrc_LanguageTranslation2.SETRANGE("State Customer Duty", lrc_SalesVATEvaluation."State Customer Duty");
    //             lrc_LanguageTranslation2.SETRANGE("Sales/Purch Doc. Type", lrc_SalesVATEvaluation."Sales/Purch Doc. Type");
    //             lrc_LanguageTranslation2.SETRANGE("Sales/Purch Doc. Subtype Code", lrc_SalesVATEvaluation."Sales/Purch Doc. Subtype Code");

    //             lrc_LanguageTranslation2.SETRANGE("Line Type", lrc_SalesVATEvaluation."Line Type");
    //             lrc_LanguageTranslation2.SETRANGE("Line Code", lrc_SalesVATEvaluation."Line No.");
    //             lrc_LanguageTranslation2.SETRANGE("Language Code", vrc_SalesHeader."Language Code");

    //             IF lrc_LanguageTranslation2.FIND('-') THEN BEGIN
    //                 IF (lrc_LanguageTranslation2."Additional Inv. Text 1" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 2" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 3" <> '') OR
    //                    (lrc_LanguageTranslation2."Additional Inv. Text 4" <> '') THEN BEGIN
    //                     rtx_ArrAddText[1] := lrc_LanguageTranslation2."Additional Inv. Text 1";
    //                     rtx_ArrAddText[2] := lrc_LanguageTranslation2."Additional Inv. Text 2";
    //                     rtx_ArrAddText[3] := lrc_LanguageTranslation2."Additional Inv. Text 3";
    //                     rtx_ArrAddText[4] := lrc_LanguageTranslation2."Additional Inv. Text 4";
    //                 END;
    //             END;

    //         END;
    //     end;

    //     procedure SalesVATEvaluationEntryExists(vrc_Customer: Record "Customer"; vrc_Location: Record "14"; vrc_ShipmentMethod: Record "10"): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_VATRegistrationNo: Record "50022";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------------------

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         grc_CompanyInformation.GET();
    //         CompCountry := grc_CompanyInformation."Country/Region Code";

    //         lrc_SalesVATEvaluation.Reset();

    //         //VAT 003 port     JST 160812
    //         lrc_SalesVATEvaluation.SETRANGE(Source, lrc_SalesVATEvaluation.Source::Sales);

    //         //VAT 005 port     JST 280213     Filtersetzung mit * für Mehrfachnennung bei nachfolgenden SetFilter
    //         //                                Debitorenbuchungsgruppe Debitor-Ländercode Abgangsland Zugang-Ländercode
    //         //Achtung prüfen beim EvaluationEntryExists (Vorabprüfung) kein Filter auf Zugang-Ländercode

    //         // Debitorenbuchungsgruppe
    //         //lrc_SalesVATEvaluation.SETRANGE("Cust/Vend Posting Group", vrc_Customer."Customer Posting Group");
    //         //RS Filter auf eine Buchungsgruppe reduziert
    //         //lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group",'%1|%2','*'+vrc_Customer."Customer Posting Group"+'*','');
    //         lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group", '%1|%2', vrc_Customer."Customer Posting Group", '');

    //         // Land Kunde
    //         IF vrc_Customer."Country/Region Code" = '' THEN BEGIN
    //             lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         END ELSE BEGIN
    //             lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + vrc_Customer."Country/Region Code" + '*', '');
    //         END;

    //         //VAT 007 port     JST 280213     Neue Feld in Filtersetzung einarbeiten
    //         //NICHT Land Kunde
    //         IF vrc_Customer."Country/Region Code" = '' THEN
    //             lrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             lrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + vrc_Customer."Country/Region Code" + '*');

    //         // Abgangsland
    //         IF vrc_Location."Country/Region Code" = '' THEN BEGIN
    //             lrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         END ELSE BEGIN
    //             lrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + vrc_Location."Country/Region Code" + '*', '');
    //         END;

    //         //NICHT Abgangsland
    //         IF vrc_Location."Country/Region Code" = '' THEN
    //             lrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             lrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + vrc_Location."Country/Region Code" + '*');

    //         //Zusatz-Registrierung im Abgangsland
    //         //VAT 009 port     JST 200313     Neues Feld "VAT-Reg Departure Country Code" als Option keine, direkt oder Fiscal
    //         //ForeignVatPlace
    //         lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_Customer."No.");
    //         IF vrc_Location."Country/Region Code" = '' THEN
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", CompCountry)
    //         ELSE
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", vrc_Location."Country/Region Code");
    //         IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //             IF lrc_VATRegistrationNo."VAT Detection" THEN BEGIN
    //                 lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_VATRegistrationNo."Registration Typ")
    //             END ELSE BEGIN
    //                 lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //             END;
    //         END ELSE BEGIN
    //             lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         END;

    //         // VAT 003 ADÜ40071.s
    //         // Abgangslager
    //         lrc_SalesVATEvaluation.SETFILTER("Departure Location Code", '%1|%2', vrc_Location.Code, '');
    //         // VAT 003 ADÜ40071.e

    //         //VAT 011 port     JST 250413     Neues Feld Not Departure Location Code
    //         //NICHT Abgangslager
    //         IF vrc_Location.Code <> '' THEN
    //             //mly 140310
    //             lrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code", filt_start + vrc_Location.Code + filt_end);

    //         //VAT 016 port     JST 060613     Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
    //         //Fiscalvertreter
    //         lrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', vrc_Location."Fiscal Agent Code", '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         //Not Fiscalvertreter
    //         //mly
    //         IF vrc_Location."Fiscal Agent Code" <> '' THEN
    //             lrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + vrc_Location."Fiscal Agent Code" + '*');

    //         // Lieferbedingung
    //         IF vrc_ShipmentMethod."Self-Collector" THEN
    //             lrc_SalesVATEvaluation.SETRANGE("Shipment Type", lrc_SalesVATEvaluation."Shipment Type"::Selbstabholer)
    //         ELSE
    //             lrc_SalesVATEvaluation.SETRANGE("Shipment Type", lrc_SalesVATEvaluation."Shipment Type"::Franco);
    //         //port.Jst 30.5.12 Anmerkung, Bisher Unterbedingung bei Franco. Entscheiden für die Steuerbewertung ist aber der Ort der Abholung
    //         //-> begin end versetzt
    //         // Ankunftsland --> nur wenn auch dahin geliefert wird - bei Selbstabholer ist dies nicht bekannt

    //         //END;

    //         //VAT 001 port     JST 240512     Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         //Lieferbedinungscode
    //         lrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', vrc_ShipmentMethod.Code, '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung
    //         //Not Lieferbedingungscode
    //         //mly
    //         IF vrc_ShipmentMethod.Code <> '' THEN
    //             lrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + vrc_ShipmentMethod.Code + '*');

    //         //Ankunftsland
    //         lrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + vrc_Customer."Country/Region Code" + '*', '');

    //         //VAT 002 port     JST 080812     Neues Feld 50002Not Arrival Country Code in Filtersetzung einarbeiten
    //         //NOT Ankunftsland
    //         IF vrc_Customer."Country/Region Code" <> '' THEN
    //             lrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + vrc_Customer."Country/Region Code" + '*');

    //         // Status Zoll
    //         IF vrc_ShipmentMethod."Duty Paid" = TRUE THEN
    //             lrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', lrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                            lrc_SalesVATEvaluation."State Customer Duty"::" ")
    //         ELSE
    //             lrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', lrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //                                                                            lrc_SalesVATEvaluation."State Customer Duty"::" ");

    //         // Gültigkeit ab prüfen
    //         //lrc_SalesVATEvaluation.SETFILTER("Valid From",'<=%1',vrc_SalesInvoiceHeader."Posting Date");

    //         IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             EXIT(TRUE);
    //         END ELSE
    //             EXIT(FALSE);
    //     end;

    //     procedure SalesInvoiceGetFiscalAgentText(vrc_SalesInvoiceHeader: Record "112"; vrc_SalesInvoiceLine: Record "113"; var rtx_ArrFiscalAgentText: array[10] of Text[100])
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------------------

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         // VAT 001 MFL40116.s
    //         SalesInvoiceFilterTaxRecord(vrc_SalesInvoiceHeader, vrc_SalesInvoiceLine, lrc_SalesVATEvaluation);

    //         //IFW 001 IFW40151
    //         IF lrc_SalesVATEvaluation.GETFILTERS = '' THEN
    //             EXIT;

    //         IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             // VAT 003 ADÜ40071.s
    //             IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                 EXIT;
    //             // VAT 003 ADÜ40071.e

    //             //VAT 017 port     JST 060613     Location zuerst Zeile ansehen, dann Kopf
    //             //  IF NOT lrc_Location.GET(vrc_SalesInvoiceLine."Location Code") THEN
    //             //    EXIT;
    //             IF vrc_SalesInvoiceLine."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_SalesInvoiceLine."Location Code");
    //             END ELSE BEGIN
    //                 IF vrc_SalesInvoiceHeader."Location Code" <> '' THEN BEGIN
    //                     lrc_Location.GET(vrc_SalesInvoiceHeader."Location Code");
    //                 END ELSE
    //                     EXIT;
    //             END;

    //             //rs  IF NOT lrc_FiscalAgent.GET(lrc_Location."Fiscal Agent Code") THEN
    //             //rs    EXIT;
    //             IF lrc_BatchVariant.GET(vrc_SalesInvoiceLine."Batch Variant No.") THEN BEGIN
    //                 IF lrc_BatchVariant."Fiscal Agent Code" <> '' THEN BEGIN
    //                     IF lrc_BatchVariant."Entry Location Code" = lrc_Location.Code THEN
    //                         lrc_FiscalAgent.GET(lrc_BatchVariant."Fiscal Agent Code");
    //                 END ELSE BEGIN
    //                     IF NOT lrc_FiscalAgent.GET(lrc_Location."Fiscal Agent Code") THEN
    //                         EXIT;
    //                 END;
    //             END ELSE BEGIN
    //                 IF NOT lrc_FiscalAgent.GET(lrc_Location."Fiscal Agent Code") THEN
    //                     EXIT;
    //             END;

    //             rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //             rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //             rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                lrc_FiscalAgent."Post Code",
    //                                                                lrc_FiscalAgent.City);
    //             rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");

    //             // Übersetzung der Fiskalvertretertexte holen
    //             lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //             lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //             lrc_LanguageTranslation.SETRANGE("Language Code", vrc_SalesInvoiceHeader."Language Code");

    //             IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                 rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                 rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                 rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                 rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //             END ELSE BEGIN
    //                 rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                 rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                 rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                 rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //             END;
    //         END;

    //         // F40 002 FV400004.e
    //     end;

    //     procedure SalesCrMemoGetFiscalAgentText(vrc_SalesCrMemoHeader: Record "114"; vrc_SalesCrMemoLine: Record "115"; var rtx_ArrFiscalAgentText: array[10] of Text[30])
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         // -------------------------------------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------------------------------------


    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();


    //         // F40 002 FV400004.s

    //         // VAT 001 MFL40116.s
    //         SalesCrMemoFilterTaxRecord(vrc_SalesCrMemoHeader, vrc_SalesCrMemoLine, lrc_SalesVATEvaluation);

    //         //IFW 001 IFW40151
    //         IF lrc_SalesVATEvaluation.GETFILTERS = '' THEN
    //             EXIT;

    //         IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             // VAT 003 ADÜ40071.s
    //             IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                 EXIT;
    //             // VAT 003 ADÜ40071.e

    //             //VAT 017 port     JST 060613     Location zuerst Zeile ansehen, dann Kopf
    //             //IF NOT lrc_Location.GET(vrc_SalesCrMemoLine."Location Code") THEN
    //             //    EXIT;
    //             IF vrc_SalesCrMemoLine."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_SalesCrMemoLine."Location Code");
    //             END ELSE BEGIN
    //                 IF vrc_SalesCrMemoHeader."Location Code" <> '' THEN BEGIN
    //                     lrc_Location.GET(vrc_SalesCrMemoHeader."Location Code");
    //                 END ELSE
    //                     EXIT;
    //             END;


    //             IF NOT lrc_FiscalAgent.GET(lrc_Location."Fiscal Agent Code") THEN
    //                 EXIT;

    //             rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //             rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //             rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                lrc_FiscalAgent."Post Code",
    //                                                                lrc_FiscalAgent.City);
    //             rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");

    //             // Übersetzung der Fiskalvertretertexte holen
    //             lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //             lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //             lrc_LanguageTranslation.SETRANGE("Language Code", vrc_SalesCrMemoHeader."Language Code");

    //             IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                 rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                 rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                 rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                 rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //             END ELSE BEGIN
    //                 rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                 rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                 rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                 rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //             END;
    //         END;
    //     end;

    //     procedure GetFiscalAgentTextSales(vrc_SalesHeader: Record "36"; vrc_SalesLine: Record "37"; var rtx_ArrFiscalAgentText: array[10] of Text[30])
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         // ---------------------------------------------------------------------------------------------
    //         //
    //         // ---------------------------------------------------------------------------------------------

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         // VAT 001 MFL40116.s
    //         SalesFilterTaxRecord(vrc_SalesHeader, vrc_SalesLine, lrc_SalesVATEvaluation);

    //         // Druck Fiskalvertreter aktiviert?
    //         // VAT 003 ADÜ40071.s
    //         // lrc_SalesVATEvaluation.SETRANGE("Print Fiscal Agent",TRUE);
    //         // VAT 003 ADÜ40071.e
    //         // VAT 001 MFL40116.e

    //         IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             // VAT 003 ADÜ40071.s
    //             IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                 EXIT;
    //             // VAT 003 ADÜ40071.e

    //             //  IF NOT lrc_Location.GET(vrc_SalesLine."Location Code") THEN
    //             //    EXIT;
    //             //VAT 017 port     JST 060613     Location zuerst Zeile ansehen, dann Kopf
    //             IF vrc_SalesLine."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_SalesLine."Location Code");
    //             END ELSE BEGIN
    //                 IF vrc_SalesHeader."Location Code" <> '' THEN BEGIN
    //                     lrc_Location.GET(vrc_SalesHeader."Location Code");
    //                 END ELSE
    //                     EXIT;
    //             END;

    //             IF NOT lrc_FiscalAgent.GET(lrc_Location."Fiscal Agent Code") THEN
    //                 EXIT;

    //             rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //             rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //             rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                lrc_FiscalAgent."Post Code",
    //                                                                lrc_FiscalAgent.City);
    //             rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");

    //             // Übersetzung der Fiskalvertretertexte holen
    //             lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //             lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //             lrc_LanguageTranslation.SETRANGE("Language Code", vrc_SalesHeader."Language Code");

    //             IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                 rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                 rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                 rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                 rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //             END ELSE BEGIN
    //                 rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                 rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                 rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                 rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //             END;
    //         END;
    //     end;

    //     procedure GetAmountForSalesItemLedgEntry(rrc_ItemLedgerEntry: Record "32"; rbn_AmountsinAddCurrency: Boolean; rdc_SalesQuantity: Decimal; rbn_AmountInclItemCharges: Boolean; var vdc_Amount: Decimal; var vdc_IndirectCost: Decimal)
    //     var
    //         lrc_Item: Record Item;
    //         lrc_ItemApplnEntry: Record "339";
    //         ldc_AppliedQty: Decimal;
    //         lin_EntryNo: Integer;
    //         lrc_ItemLedgerEntry2: Record "32";
    //         lrc_TempItemEntry: Record "32" temporary;
    //         ldc_TotalInvoicedQty: Decimal;
    //         ldc_TotalAmt: Decimal;
    //         ldc_TotalAmtExpected: Decimal;
    //         ldc_TotalCostAmt: Decimal;
    //         ldc_TotalIndirectCost: Decimal;
    //         ldc_TotalIndirectCostAmt: Decimal;
    //         lrc_ValueEntry: Record "5802";
    //         lrc_PurchaseLine: Record "39";
    //         lrc_BatchVariantEntry2: Record "5110368";
    //         lrc_BatchVariantEntry: Record "5110368";
    //         lcu_BatchManagement: Codeunit "5110307";
    //         lop_PurchDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
    //         lco_PurchDocNo: Code[20];
    //         lin_PurchDocLineNo: Integer;
    //         lbn_TotalCostAmtConverted: Boolean;
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         //
    //         // ------------------------------------------------------------------------------------------------

    //         vdc_Amount := 0;
    //         vdc_IndirectCost := 0;

    //         CLEAR(lop_PurchDocType);
    //         CLEAR(lco_PurchDocNo);
    //         CLEAR(lin_PurchDocLineNo);

    //         lrc_TempItemEntry.DELETEALL();
    //         lrc_Item.GET(rrc_ItemLedgerEntry."Item No.");

    //         // Bei nicht Partiegeführten Artikeln
    //         IF lrc_Item."Batch Item" = FALSE THEN BEGIN

    //             WITH rrc_ItemLedgerEntry DO BEGIN
    //                 IF Positive THEN BEGIN
    //                     lrc_ItemApplnEntry.Reset();
    //                     lrc_ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.",
    //                           "Outbound Item Entry No.", "Cost Application");
    //                     lrc_ItemApplnEntry.SETRANGE("Inbound Item Entry No.", "Entry No.");
    //                     lrc_ItemApplnEntry.SETFILTER("Outbound Item Entry No.", '<>%1', 0);
    //                     lrc_ItemApplnEntry.SETRANGE("Cost Application", TRUE);
    //                     IF lrc_ItemApplnEntry.FIND('-') THEN
    //                         REPEAT
    //                             ldc_AppliedQty := lrc_ItemApplnEntry.Quantity;
    //                             lin_EntryNo := lrc_ItemApplnEntry."Outbound Item Entry No.";
    //                             lrc_ItemLedgerEntry2.GET(lin_EntryNo);
    //                             IF ldc_AppliedQty * lrc_ItemLedgerEntry2.Quantity >= 0 THEN BEGIN
    //                                 IF NOT lrc_TempItemEntry.GET(lin_EntryNo) THEN BEGIN
    //                                     lrc_TempItemEntry.INIT();
    //                                     lrc_TempItemEntry := lrc_ItemLedgerEntry2;
    //                                     lrc_TempItemEntry.Quantity := ldc_AppliedQty;
    //                                     lrc_TempItemEntry.insert();
    //                                 END ELSE BEGIN
    //                                     lrc_TempItemEntry.Quantity := lrc_TempItemEntry.Quantity + ldc_AppliedQty;
    //                                     lrc_TempItemEntry.MODIFY();
    //                                 END;
    //                             END;
    //                         UNTIL lrc_ItemApplnEntry.NEXT() = 0;
    //                 END ELSE BEGIN
    //                     lrc_ItemApplnEntry.Reset();
    //                     lrc_ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.",
    //                        "Item Ledger Entry No.", "Cost Application");
    //                     lrc_ItemApplnEntry.SETRANGE("Outbound Item Entry No.", "Entry No.");
    //                     lrc_ItemApplnEntry.SETRANGE("Item Ledger Entry No.", "Entry No.");
    //                     lrc_ItemApplnEntry.SETRANGE("Cost Application", TRUE);
    //                     IF lrc_ItemApplnEntry.FIND('-') THEN
    //                         REPEAT
    //                             ldc_AppliedQty := -lrc_ItemApplnEntry.Quantity;
    //                             lin_EntryNo := lrc_ItemApplnEntry."Inbound Item Entry No.";

    //                             lrc_ItemLedgerEntry2.GET(lin_EntryNo);
    //                             IF ldc_AppliedQty * lrc_ItemLedgerEntry2.Quantity >= 0 THEN BEGIN
    //                                 IF NOT lrc_TempItemEntry.GET(lin_EntryNo) THEN BEGIN
    //                                     lrc_TempItemEntry.INIT();
    //                                     lrc_TempItemEntry := lrc_ItemLedgerEntry2;
    //                                     lrc_TempItemEntry.Quantity := ldc_AppliedQty;
    //                                     lrc_TempItemEntry.insert();
    //                                 END ELSE BEGIN
    //                                     lrc_TempItemEntry.Quantity := lrc_TempItemEntry.Quantity + ldc_AppliedQty;
    //                                     lrc_TempItemEntry.MODIFY();
    //                                 END;
    //                             END;
    //                         UNTIL lrc_ItemApplnEntry.NEXT() = 0;
    //                 END;

    //                 ldc_TotalInvoicedQty := 0;
    //                 ldc_TotalAmt := 0;
    //                 ldc_TotalAmtExpected := 0;
    //                 ldc_TotalCostAmt := 0;
    //                 ldc_TotalIndirectCost := 0;
    //                 ldc_TotalIndirectCostAmt := 0;

    //                 IF lrc_TempItemEntry.FIND('-') THEN BEGIN
    //                     REPEAT

    //                         lrc_ValueEntry.Reset();
    //                         lrc_ValueEntry.SETRANGE("Item Ledger Entry No.", lrc_TempItemEntry."Entry No.");
    //                         IF lrc_ValueEntry.FIND('-') THEN
    //                             REPEAT
    //                                 ldc_TotalInvoicedQty := ldc_TotalInvoicedQty + lrc_ValueEntry."Invoiced Quantity";
    //                                 IF NOT rbn_AmountsinAddCurrency = TRUE THEN BEGIN
    //                                     IF lrc_ValueEntry."Item Charge No." = '' THEN BEGIN
    //                                         ldc_TotalCostAmt := ldc_TotalCostAmt + lrc_ValueEntry."Cost Amount (Actual)";
    //                                     END ELSE BEGIN
    //                                         ldc_TotalIndirectCostAmt := ldc_TotalIndirectCostAmt +
    //                                           lrc_ValueEntry."Cost Amount (Actual)";
    //                                     END;
    //                                 END ELSE BEGIN
    //                                     IF lrc_ValueEntry."Item Charge No." = '' THEN BEGIN
    //                                         ldc_TotalCostAmt := ldc_TotalCostAmt + lrc_ValueEntry."Cost Amount (Actual) (ACY)";
    //                                     END ELSE BEGIN
    //                                         ldc_TotalIndirectCostAmt := ldc_TotalIndirectCostAmt +
    //                                           lrc_ValueEntry."Cost Amount (Actual) (ACY)";
    //                                     END;
    //                                 END;
    //                             UNTIL lrc_ValueEntry.NEXT() = 0;
    //                         IF lrc_TempItemEntry."Entry Type" = lrc_TempItemEntry."Entry Type"::Purchase THEN BEGIN
    //                             lop_PurchDocType := lrc_BatchVariantEntry2."Source Doc. Type";
    //                             lco_PurchDocNo := lrc_BatchVariantEntry2."Source Doc. No.";
    //                             lin_PurchDocLineNo := lrc_BatchVariantEntry2."Source Doc. Line No.";
    //                         END;
    //                     UNTIL lrc_TempItemEntry.NEXT() = 0;
    //                 END;

    //                 IF (ldc_TotalCostAmt = 0) THEN BEGIN
    //                     IF (lco_PurchDocNo <> '') AND
    //                        (lin_PurchDocLineNo <> 0) THEN BEGIN
    //                         ldc_TotalInvoicedQty := lrc_PurchaseLine."Quantity (Base)";
    //                         IF lrc_PurchaseLine.GET(lop_PurchDocType,
    //                                                  lco_PurchDocNo,
    //                                                  lin_PurchDocLineNo) THEN BEGIN
    //                             IF (lrc_PurchaseLine."Quantity (Base)" <> 0) THEN BEGIN
    //                                 ldc_TotalCostAmt :=
    //                                  ROUND(((lrc_PurchaseLine."Line Amount" - lrc_PurchaseLine."Line Discount Amount") /
    //                                   lrc_PurchaseLine."Quantity (Base)") * rrc_ItemLedgerEntry.Quantity, 0.01);
    //                             END;
    //                         END;
    //                     END ELSE BEGIN
    //                         IF rrc_ItemLedgerEntry."Batch Variant No." <> '' THEN BEGIN
    //                             lrc_PurchaseLine.Reset();
    //                             lrc_PurchaseLine.SETCURRENTKEY("Document Type", "Master Batch No.", "Batch No.", "Batch Variant No.");
    //                             lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
    //                             lrc_PurchaseLine.SETRANGE("Batch Variant No.", rrc_ItemLedgerEntry."Batch Variant No.");
    //                             IF lrc_PurchaseLine.FIND('-') THEN BEGIN
    //                                 IF (lrc_PurchaseLine."Quantity (Base)" <> 0) THEN BEGIN
    //                                     ldc_TotalInvoicedQty := lrc_PurchaseLine."Quantity (Base)";
    //                                     ldc_TotalCostAmt :=
    //                                       ROUND(((lrc_PurchaseLine."Line Amount" - lrc_PurchaseLine."Line Discount Amount") /
    //                                       lrc_PurchaseLine."Quantity (Base)") * rrc_ItemLedgerEntry.Quantity, 0.01);
    //                                 END;
    //                             END;
    //                         END;
    //                     END;
    //                 END;

    //                 IF ldc_TotalInvoicedQty <> 0 THEN BEGIN

    //                     // Einkaufskosten auf entsprechende Verkaufsmenge umrechnen
    //                     ldc_TotalAmt := ROUND((ldc_TotalCostAmt / ldc_TotalInvoicedQty) *
    //                                             rdc_SalesQuantity, 0.00001);
    //                     ldc_TotalIndirectCost := ROUND((ldc_TotalIndirectCostAmt / ldc_TotalInvoicedQty) *
    //                                             rdc_SalesQuantity, 0.00001);
    //                     IF rbn_AmountInclItemCharges THEN BEGIN
    //                         vdc_Amount := ROUND(ABS(ldc_TotalAmt + ldc_TotalIndirectCost), 1);
    //                         vdc_IndirectCost := 0;
    //                     END ELSE BEGIN
    //                         vdc_Amount := ROUND(ABS(ldc_TotalAmt), 1);
    //                         vdc_IndirectCost := ROUND(ldc_TotalIndirectCost, 1);
    //                     END;
    //                 END;
    //             END;

    //         END ELSE BEGIN

    //             ldc_TotalInvoicedQty := 0;
    //             ldc_TotalAmt := 0;
    //             ldc_TotalAmtExpected := 0;
    //             ldc_TotalCostAmt := 0;
    //             ldc_TotalIndirectCost := 0;
    //             ldc_TotalIndirectCostAmt := 0;

    //             lrc_BatchVariantEntry2.Reset();
    //             lrc_BatchVariantEntry2.SETCURRENTKEY("Item Ledger Entry No.");
    //             lrc_BatchVariantEntry2.SETRANGE("Item Ledger Entry No.", rrc_ItemLedgerEntry."Entry No.");
    //             IF lrc_BatchVariantEntry2.FIND('-') THEN BEGIN
    //                 lrc_BatchVariantEntry.SETCURRENTKEY(
    //                   "Batch Variant No.", "Item Ledger Entry Type", "Location Code", "Posting Date");
    //                 lrc_BatchVariantEntry.SETRANGE("Batch Variant No.", lrc_BatchVariantEntry2."Batch Variant No.");
    //                 lrc_BatchVariantEntry.SETRANGE("Item Ledger Entry Type",
    //                   lrc_BatchVariantEntry."Item Ledger Entry Type"::Purchase);
    //                 IF lrc_BatchVariantEntry.FIND('-') THEN BEGIN
    //                     lrc_BatchVariantEntry2.Reset();
    //                     REPEAT
    //                         lcu_BatchManagement.CalcValueBatchVarEntry(lrc_BatchVariantEntry."Entry No.");
    //                         lrc_BatchVariantEntry2.GET(lrc_BatchVariantEntry."Entry No.");
    //                         //xx          ldc_TotalCostAmt := ldc_TotalCostAmt + lrc_BatchVariantEntry2."Purchase Amount (Expected)" +
    //                         //xx                            lrc_BatchVariantEntry2."Purchase Amount (Actual)";
    //                         ldc_TotalInvoicedQty := ldc_TotalInvoicedQty + lrc_BatchVariantEntry2."Quantity (Base)";

    //                         lop_PurchDocType := lrc_BatchVariantEntry2."Source Doc. Type";
    //                         lco_PurchDocNo := lrc_BatchVariantEntry2."Source Doc. No.";
    //                         lin_PurchDocLineNo := lrc_BatchVariantEntry2."Source Doc. Line No.";

    //                     UNTIL lrc_BatchVariantEntry.NEXT() = 0;
    //                 END;
    //             END;

    //             IF (ldc_TotalCostAmt = 0) THEN BEGIN
    //                 ldc_TotalInvoicedQty := 0;
    //                 IF (lco_PurchDocNo <> '') AND
    //                    (lin_PurchDocLineNo <> 0) THEN BEGIN
    //                     IF lrc_PurchaseLine.GET(lop_PurchDocType,
    //                                              lco_PurchDocNo,
    //                                              lin_PurchDocLineNo) THEN BEGIN
    //                         IF (lrc_PurchaseLine."Quantity (Base)" <> 0) THEN BEGIN
    //                             ldc_TotalInvoicedQty := lrc_PurchaseLine."Quantity (Base)";
    //                             ldc_TotalCostAmt :=
    //                               ROUND(((lrc_PurchaseLine."Line Amount" - lrc_PurchaseLine."Line Discount Amount") /
    //                              lrc_PurchaseLine."Quantity (Base)") * rrc_ItemLedgerEntry.Quantity, 0.01);
    //                         END;
    //                     END;
    //                 END ELSE BEGIN
    //                     IF rrc_ItemLedgerEntry."Batch Variant No." <> '' THEN BEGIN
    //                         lrc_PurchaseLine.Reset();
    //                         lrc_PurchaseLine.SETCURRENTKEY("Document Type", "Master Batch No.", "Batch No.", "Batch Variant No.");
    //                         lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseLine."Document Type"::Order);
    //                         lrc_PurchaseLine.SETRANGE("Batch Variant No.", rrc_ItemLedgerEntry."Batch Variant No.");
    //                         IF lrc_PurchaseLine.FIND('-') THEN BEGIN
    //                             ldc_TotalInvoicedQty := lrc_PurchaseLine."Quantity (Base)";
    //                             IF (lrc_PurchaseLine."Quantity (Base)" <> 0) THEN BEGIN
    //                                 ldc_TotalCostAmt :=
    //                                   ROUND(((lrc_PurchaseLine."Line Amount" - lrc_PurchaseLine."Line Discount Amount") /
    //                                   lrc_PurchaseLine."Quantity (Base)") * rrc_ItemLedgerEntry.Quantity, 0.01);

    //                                 // FV4 007 00000000.s
    //                                 lbn_TotalCostAmtConverted := TRUE;
    //                                 // FV4 007 00000000.e
    //                             END;
    //                         END;
    //                     END;
    //                 END;
    //             END;



    //             IF ldc_TotalInvoicedQty <> 0 THEN BEGIN
    //                 // Einkaufskosten auf entsprechende Verkaufsmenge umrechnen
    //                 // FV4 007 00000000.s
    //                 // nur wenn noch nicht umgerechnet wurde
    //                 IF NOT lbn_TotalCostAmtConverted THEN BEGIN
    //                     // FV4 007 00000000.e
    //                     ldc_TotalAmt := ROUND((ldc_TotalCostAmt / ldc_TotalInvoicedQty) * rdc_SalesQuantity, 0.00001);
    //                     // FV4 007 00000000.s
    //                 END ELSE BEGIN
    //                     ldc_TotalAmt := ldc_TotalCostAmt;
    //                 END;
    //                 // FV4 007 00000000.e

    //                 ldc_TotalIndirectCost := ROUND((ldc_TotalIndirectCostAmt / ldc_TotalInvoicedQty) *
    //                                                rdc_SalesQuantity, 0.00001);

    //                 IF rbn_AmountInclItemCharges THEN BEGIN
    //                     vdc_Amount := ROUND(ABS(ldc_TotalAmt + ldc_TotalIndirectCost), 1);
    //                     vdc_IndirectCost := 0;
    //                 END ELSE BEGIN
    //                     vdc_Amount := ROUND(ABS(ldc_TotalAmt), 1);
    //                     vdc_IndirectCost := ROUND(ldc_TotalIndirectCost, 1);
    //                 END;
    //             END;
    //         END;
    //     end;

    //     procedure SalesFilterTaxRecord(vrc_SalesHeader: Record "36"; vrc_SalesLine: Record "37"; var rrc_SalesVATEvaluation: Record "5087926")
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_FruitvisionSetup: Record "5110302";
    //         lrc_VATRegistrationNo: Record "50022";
    //         lrc_BatchVariant2: Record "5110366";
    //     begin
    //         // --------------------------------------------------------------------------------------------------------
    //         // Filter für VK
    //         // --------------------------------------------------------------------------------------------------------

    //         //RS jeweils länderspezifische CompCountry, wenn vorhanden.
    //         //Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         // grc_CompanyInformation.GET();
    //         //CompCountry:=grc_CompanyInformation."Country/Region Code";
    //         IF ((vrc_SalesLine.Type = vrc_SalesLine.Type::Item) OR
    //             (vrc_SalesLine.Type = vrc_SalesLine.Type::"Charge (Item)")) THEN BEGIN
    //             lrc_Location.GET(vrc_SalesLine."Location Code");
    //             IF grc_CompanyInformation.GET(lrc_Location."Country/Region Code") THEN
    //                 CompCountry := grc_CompanyInformation."Primary Key";
    //         END ELSE BEGIN
    //             grc_CompanyInformation.GET();
    //             CompCountry := grc_CompanyInformation."Country/Region Code";
    //         END;
    //         lrc_Location.Reset();


    //         lrc_Customer.GET(vrc_SalesHeader."Sell-to Customer No.");

    //         //Location zuerst Zeile ansehen, dann Kopf
    //         IF vrc_SalesLine."Location Code" <> '' THEN BEGIN
    //             lrc_Location.GET(vrc_SalesLine."Location Code");
    //         END ELSE BEGIN
    //             IF vrc_SalesHeader."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_SalesHeader."Location Code");
    //             END ELSE BEGIN
    //                 //160609 rs
    //                 //rrc_SalesVATEvaluation.SETFILTER("Departure Location Code",'keiner');
    //                 rrc_SalesVATEvaluation.SETRANGE("Departure Location Code", '');
    //                 //EXIT;
    //                 //160609 rs.e
    //             END;
    //         END;
    //         //ist Lieferbedingung vorhanden ?
    //         //RS wenn keine Lieferbedingung, dann Error
    //         IF vrc_SalesHeader."Shipment Method Code" = '' THEN BEGIN
    //             //rrc_SalesVATEvaluation.SETFILTER("Shipment Method Code",'keine');
    //             //EXIT;
    //             ERROR('Sie müssen eine Lieferbedingung angeben');
    //         END;
    //         lrc_ShipmentMethod.GET(vrc_SalesHeader."Shipment Method Code");

    //         //--- START ---
    //         //Zeile/Kopf untersuchen
    //         rrc_SalesVATEvaluation.Reset();
    //         rrc_SalesVATEvaluation.SETRANGE(Source, rrc_SalesVATEvaluation.Source::Sales);
    //         rrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Type", '%1|%2', rrc_SalesVATEvaluation."Sales/Purch Doc. Type"::Order,
    //                                                                     rrc_SalesVATEvaluation."Sales/Purch Doc. Type"::" ");
    //         rrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Subtype Code", '%1|%2', vrc_SalesHeader."Sales Doc. Subtype Code", '');


    //         CASE vrc_SalesLine.Type OF
    //             vrc_SalesLine.Type::Item:
    //                 rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::Item);
    //             vrc_SalesLine.Type::"Charge (Item)":
    //                 rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"Item Charge"
    // );
    //             vrc_SalesLine.Type::"G/L Account":
    //                 IF vrc_SalesLine.Subtyp = vrc_SalesLine.Subtyp::Discount THEN
    //                     //RS Subtype VVE findet derzeit keine Verwendung
    //                     //rrc_SalesVATEvaluation.SETRANGE("Line Type",rrc_SalesVATEvaluation."Line Type"::"Subtype VVE"
    //                     rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"G/L Account")
    //                 ELSE
    //                     rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"G/L Account"
    // );
    //         END;

    //         // Debitorenbuchungsgruppe
    //         //RS Filter auf eine Buchungsgruppe
    //         //rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group",'%1|%2','*'+vrc_SalesHeader."Customer Posting Group"+'*','');
    //         rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group", '%1|%2', vrc_SalesHeader."Customer Posting Group", '');
    //         // Land Kunde
    //         //RS abstellen auf das Lieferland
    //         //IF vrc_SalesHeader."Sell-to Country/Region Code" = '' THEN BEGIN
    //         IF vrc_SalesHeader."Ship-to Country/Region Code" = '' THEN BEGIN
    //             IF vrc_SalesHeader."Sell-to Country/Region Code" = '' THEN
    //                 rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //             ELSE
    //                 rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + vrc_SalesHeader."Sell-to Country/Region Code" + '*', '');
    //         END ELSE BEGIN
    //             //  rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2','*'+ vrc_SalesHeader."Sell-to Country/Region Code"+'*', '');
    //             rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + vrc_SalesHeader."Ship-to Country/Region Code" + '*', '');
    //         END;

    //         //NICHT Land Kunde
    //         //RS Lieferland Kunde
    //         //IF vrc_SalesHeader."Sell-to Country/Region Code" = '' THEN
    //         IF vrc_SalesHeader."Ship-to Country/Region Code" = '' THEN BEGIN
    //             IF vrc_SalesHeader."Sell-to Country/Region Code" = '' THEN
    //                 rrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + CompCountry + '*')
    //             ELSE
    //                 rrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + vrc_SalesHeader."Sell-to Country/Region Code" + '*')
    //         END ELSE BEGIN
    //             //  rrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code",'<>*'+vrc_SalesHeader."Sell-to Country/Region Code"+'*');
    //             rrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + vrc_SalesHeader."Ship-to Country/Region Code" + '*');
    //         END;
    //         // Abgangsland
    //         IF lrc_Location."Country/Region Code" = '' THEN BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + CompCountry + '*', '');
    //             rrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", TRUE);
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lrc_Location."Country/Region Code" + '*', '');
    //             IF lrc_Location."Country/Region Code" = CompCountry THEN
    //                 rrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", TRUE);
    //         END;

    //         //NICHT Abgangsland
    //         IF lrc_Location."Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lrc_Location."Country/Region Code" + '*');

    //         //Zusatz-Registrierung im Abgangsland  -  Neues Feld "VAT-Reg Departure Country Code" als Option keine, direkt oder Fiscal
    //         //ForeignVatPlace
    //         lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_SalesHeader."Sell-to Customer No.");
    //         //170707 rs Filterung Tab 50022 geändert
    //         //IF lrc_Location."Country/Region Code" = '' THEN
    //         IF vrc_SalesHeader."Ship-to Country/Region Code" = '' THEN
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", CompCountry)
    //         ELSE
    //             //lrc_VATRegistrationNo.SETRANGE("Country Code",lrc_Location."Country/Region Code");
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", vrc_SalesHeader."Ship-to Country/Region Code");
    //         //170707 rs.e
    //         IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //             IF lrc_VATRegistrationNo."VAT Detection" THEN BEGIN
    //                 rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_VATRegistrationNo."Registration Typ")
    //             END ELSE BEGIN
    //                 rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", rrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //             END;
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", rrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         END;

    //         // Abgangslager
    //         IF lrc_Location.Code <> '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Departure Location Code", '%1|%2', lrc_Location.Code, '')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETRANGE("Departure Location Code", '');

    //         //NICHT Abgangslager  -  Neues Feld Not Departure Location Code
    //         IF lrc_Location.Code <> '' THEN
    //             //mly 140310
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code", filt_start + lrc_Location.Code + filt_end);


    //         //RS 160204 Vorrang Fiskalvertreter aus BatchVariant vor Lagerort
    //         IF lrc_BatchVariant.GET(vrc_SalesLine."Batch Variant No.") THEN BEGIN
    //             IF lrc_BatchVariant."Fiscal Agent Code" <> '' THEN BEGIN
    //                 IF lrc_BatchVariant."Entry Location Code" = lrc_Location.Code THEN
    //                     rrc_SalesVATEvaluation.SETRANGE("Fiscal Agent", lrc_BatchVariant."Fiscal Agent Code")
    //                 ELSE
    //                     rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //             END ELSE BEGIN
    //                 rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //             END;
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END;

    //         //Not Fiscalvertreter  -  Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         IF lrc_Location."Fiscal Agent Code" <> '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + lrc_Location."Fiscal Agent Code" + '*');

    //         // Lieferbedingung
    //         IF lrc_ShipmentMethod."Self-Collector" THEN BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("Shipment Type", rrc_SalesVATEvaluation."Shipment Type"::Selbstabholer)
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("Shipment Type", rrc_SalesVATEvaluation."Shipment Type"::Franco);
    //         END;

    //         //Lieferbedinungscode  -  Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         rrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', lrc_ShipmentMethod.Code, '');

    //         //Not Lieferbedingungscode  -  Neues Feld Not Lieferbedinung
    //         IF lrc_ShipmentMethod.Code <> '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + lrc_ShipmentMethod.Code + '*');

    //         //Ankunftsland
    //         rrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + vrc_SalesHeader."Ship-to Country/Region Code" + '*', '');

    //         //Nicht Ankunftsland  -  Neues Feld 50002Not Arrival Country Code in Filtersetzung einarbeiten
    //         IF vrc_SalesHeader."Ship-to Country/Region Code" <> '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + vrc_SalesHeader."Ship-to Country/Region Code" + '*');

    //         // Status Zoll
    //         IF lrc_ShipmentMethod."Duty Paid" THEN BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', rrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                             rrc_SalesVATEvaluation."State Customer Duty"::" ")
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', rrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //                                                                             rrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         END;

    //         // FV START 291008 --> Fiskalvertreter prüfen
    //         //rrc_SalesVATEvaluation.SETRANGE("Fiscal Agent",'');
    //         //IF vrc_SalesLine.Type = vrc_SalesLine.Type::Item THEN BEGIN
    //         //port.jst 30.5.12 Fiscalvertrewter aus dem Lagerort, nicht aus der Batch
    //         //  IF lrc_Location."Fiscal Agent Code" <> '' THEN BEGIN
    //         //    rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent",'%1|%2',lrc_Location."Fiscal Agent Code",'');
    //         //  END;
    //         //IF lrc_BatchVariant.GET(vrc_SalesLine."Batch Variant No.") THEN BEGIN
    //         //  IF lrc_BatchVariant."Fiscal Agent Code" <> '' THEN BEGIN
    //         //    rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent",'%1|%2',lrc_BatchVariant."Fiscal Agent Code",'');
    //         //  END;
    //         //END ELSE BEGIN
    //         //END;
    //         //END;
    //         // FV END

    //         //RS innergemeinschaftliches Dreiecksgeschäft
    //         IF vrc_SalesHeader."EU 3-Party Trade" THEN
    //             rrc_SalesVATEvaluation.SETRANGE(rrc_SalesVATEvaluation."EU 3rd Party Trade", TRUE)
    //         ELSE
    //             rrc_SalesVATEvaluation.SETRANGE(rrc_SalesVATEvaluation."EU 3rd Party Trade", FALSE);


    //         // Gültigkeit ab prüfen
    //         rrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', vrc_SalesHeader."Posting Date");

    //         // Gültigkeit bis prüfen mly140625
    //         rrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', vrc_SalesHeader."Posting Date", 0D);
    //     end;

    //     procedure SalesFindTaxRecord(vrc_SalesHeader: Record "36"; vrc_SalesLine: Record "37"; var rrc_SalesVATEvaluation: Record "5087926"): Boolean
    //     begin
    //         // --------------------------------------------------------------------------------------------------------
    //         //RS Funktion nicht verwendet????
    //         // --------------------------------------------------------------------------------------------------------

    //         //Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         rrc_SalesVATEvaluation.Reset();
    //         rrc_SalesVATEvaluation.INIT();

    //         //RS wenn Menge zu fakturieren =0 dann exit
    //         IF vrc_SalesLine."Qty. to Invoice" = 0 THEN
    //             EXIT;


    //         SalesFilterTaxRecord(vrc_SalesHeader, vrc_SalesLine, rrc_SalesVATEvaluation);

    //         //mly+
    //         IF rrc_SalesVATEvaluation.FIND('+') THEN;
    //         IF rrc_SalesVATEvaluation.COUNT > 1 THEN
    //             ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //               //mly-

    //         EXIT(rrc_SalesVATEvaluation.FIND('+'));
    //     end;

    //     procedure SalesInvoiceFilterTaxRecord(vrc_SalesInvoiceHeader: Record "112"; vrc_SalesInvoiceLine: Record "113"; var rrc_SalesVATEvaluation: Record "5087926")
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_FruitvisionSetup: Record "5110302";
    //         lrc_VATRegistrationNo: Record "50022";
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         // --------------------------------------------------------------------------------------------------------
    //         //
    //         // --------------------------------------------------------------------------------------------------------

    //         lrc_FruitvisionSetup.GET();

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         //grc_CompanyInformation.GET();
    //         //CompCountry:=grc_CompanyInformation."Country/Region Code";
    //         //RS Filter auf länderspezifischen Datensatz und Verweendung der nationalen UST-ID
    //         IF vrc_SalesInvoiceLine.Type = vrc_SalesInvoiceLine.Type::Item THEN BEGIN
    //             lrc_Location.GET(vrc_SalesInvoiceLine."Location Code");
    //             IF grc_CompanyInformation.GET(lrc_Location."Country/Region Code") THEN
    //                 CompCountry := grc_CompanyInformation."Primary Key";
    //         END ELSE BEGIN
    //             grc_CompanyInformation.GET();
    //             CompCountry := grc_CompanyInformation."Country/Region Code";
    //         END;
    //         lrc_Location.Reset();




    //         // VAT 001 MFL40116.s
    //         lrc_Customer.GET(vrc_SalesInvoiceHeader."Sell-to Customer No.");

    //         //VAT 017 port     JST 060613     Location zuerst Zeile ansehen, dann Kopf
    //         IF vrc_SalesInvoiceLine."Location Code" <> '' THEN BEGIN
    //             lrc_Location.GET(vrc_SalesInvoiceLine."Location Code");
    //         END ELSE BEGIN
    //             IF vrc_SalesInvoiceHeader."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_SalesInvoiceHeader."Location Code");
    //             END ELSE BEGIN
    //                 rrc_SalesVATEvaluation.SETFILTER("Departure Location Code", 'keiner');
    //                 EXIT;
    //             END;
    //         END;
    //         //ist Lieferbedingung vorhanden ?
    //         IF vrc_SalesInvoiceHeader."Shipment Method Code" = '' THEN BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", 'keine');
    //             EXIT;
    //         END;
    //         lrc_ShipmentMethod.GET(vrc_SalesInvoiceHeader."Shipment Method Code");


    //         //Zeile, Kopf untersuchen
    //         rrc_SalesVATEvaluation.Reset();

    //         //VAT 003 port     JST 160812
    //         rrc_SalesVATEvaluation.SETRANGE(Source, rrc_SalesVATEvaluation.Source::Sales);

    //         // FV4 008 00000000 STH 280708.s --> Abhängig von der Verkaufsbelegunterart
    //         rrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Type", '%1|%2', rrc_SalesVATEvaluation."Sales/Purch Doc. Type"::Order,
    //                                                                     rrc_SalesVATEvaluation."Sales/Purch Doc. Type"::" ");

    //         rrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Subtype Code", '%1|%2', vrc_SalesInvoiceHeader."Sales Doc. Subtype Code", '');
    //         // FV4 008 00000000 STH 280708.e

    //         //VAT 012 port     JST 250413     Zeilenfilter Unterscheidung Item und ItemCharge und G/L Account
    //         // Eingrenzung auf Artikel, Sachkonto und VVE bzw G/L Account
    //         CASE vrc_SalesInvoiceLine.Type OF
    //             vrc_SalesInvoiceLine.Type::Item:
    //                 rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::Item);
    //             vrc_SalesInvoiceLine.Type::"G/L Account":
    //                 BEGIN
    //                     IF vrc_SalesInvoiceLine.Subtyp = vrc_SalesInvoiceLine.Subtyp::Discount THEN
    //                         //RS Subtype VVE findet derzeit keine Verwendung
    //                         //rrc_SalesVATEvaluation.SETRANGE("Line Type",rrc_SalesVATEvaluation."Line Type"::"Subtype VVE")
    //                         rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"G/L Account")
    //                     ELSE
    //                         rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"G/L Account");
    //                 END;
    //             vrc_SalesInvoiceLine.Type::"Charge (Item)":
    //                 BEGIN
    //                     rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"Item Charge");
    //                 END;
    //         END;

    //         //VAT 005 port     JST 280213     Filtersetzung mit * für Mehrfachnennung bei nachfolgenden SetFilter
    //         //                                Debitorenbuchungsgruppe Debitor-Ländercode Abgangsland Zugang-Ländercode
    //         // Debitorenbuchungsgruppe
    //         //rrc_SalesVATEvaluation.SETRANGE("Cust/Vend Posting Group", vrc_SalesInvoiceHeader."Customer Posting Group");
    //         //RS Filter auf eine Buchungsgruppe beschränkt
    //         //rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group",'%1|%2','*'+vrc_SalesInvoiceHeader."Customer Posting Group"+'*','');
    //         rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group", '%1|%2', vrc_SalesInvoiceHeader."Customer Posting Group", '');

    //         // Land Kunde
    //         //port.jst 30.5Umschaltung Land Kunde auf Lieferung an (Nicht Verkauf an)
    //         //RS abstellen au Lieferland
    //         /**************
    //         IF vrc_SalesInvoiceHeader."Sell-to Country/Region Code" = '' THEN
    //           rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*'+CompCountry+'*', '')
    //         ELSE
    //          rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code",'%1|%2','*'+vrc_SalesInvoiceHeader."Sell-to Country/Region Code"+'*',''
    //         );
    //         **************/
    //         IF vrc_SalesInvoiceHeader."Ship-to Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + vrc_SalesInvoiceHeader."Ship-to Country/Region Code" + '*', ''
    //            );


    //         //VAT 007 port     JST 280213     Neue Feld in Filtersetzung einarbeiten
    //         //NICHT Land Kunde
    //         IF vrc_SalesInvoiceHeader."Sell-to Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code"
    //                                                                 , '<>*' + vrc_SalesInvoiceHeader."Sell-to Country/Region Code" + '*');

    //         // Abgangsland
    //         IF lrc_Location."Country/Region Code" = '' THEN BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + CompCountry + '*', '');
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lrc_Location."Country/Region Code" + '*', '');
    //         END;

    //         //NICHT Abgangsland
    //         IF lrc_Location."Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lrc_Location."Country/Region Code" + '*');

    //         //Zusatz-Registrierung im Abgangsland
    //         //VAT 009 port     JST 200313     Neues Feld "VAT-Reg Departure Country Code" als Option keine, direkt oder Fiscal
    //         //ForeignVatPlace
    //         lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_SalesInvoiceHeader."Sell-to Customer No.");
    //         IF lrc_Location."Country/Region Code" = '' THEN
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", CompCountry)
    //         ELSE
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", lrc_Location."Country/Region Code");
    //         IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //             IF lrc_VATRegistrationNo."VAT Detection" THEN BEGIN
    //                 rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_VATRegistrationNo."Registration Typ")
    //             END ELSE BEGIN
    //                 rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", rrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //             END;
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", rrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         END;

    //         // VAT 003 ADÜ40071.s
    //         // Abgangslager
    //         rrc_SalesVATEvaluation.SETFILTER("Departure Location Code", '%1|%2', lrc_Location.Code, '');
    //         // VAT 003 ADÜ40071.e

    //         //VAT 011 port     JST 250413     Neues Feld Not Departure Location Code
    //         //NICHT Abgangslager
    //         IF lrc_Location.Code <> '' THEN
    //             //mly 140310
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code", filt_start + lrc_Location.Code + filt_end);

    //         /********
    //         //RS
    //         //VAT 016 port     JST 060613     Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
    //         //Fiscalvertreter
    //         rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent",'%1|%2',lrc_Location."Fiscal Agent Code",'');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         //Not Fiscalvertreter
    //         //mly
    //         IF lrc_Location."Fiscal Agent Code" <> '' THEN
    //         rrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent",'<>*'+lrc_Location."Fiscal Agent Code"+'*');
    //         ***********/
    //         //RS Vorrang Fiskalvertreter in BatchVariant
    //         IF lrc_BatchVariant.GET(vrc_SalesInvoiceLine."Batch Variant No.") THEN BEGIN
    //             IF lrc_BatchVariant."Fiscal Agent Code" <> '' THEN
    //                 rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1', lrc_BatchVariant."Fiscal Agent Code")
    //             ELSE
    //                 rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END;
    //         //RS.e


    //         // Lieferbedingung
    //         IF lrc_ShipmentMethod."Self-Collector" THEN BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("Shipment Type", rrc_SalesVATEvaluation."Shipment Type"::Selbstabholer);
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("Shipment Type", rrc_SalesVATEvaluation."Shipment Type"::Franco);
    //             //port.Jst 30.5.12 Anmerkung, Bisher Unterbedingung bei Franco. Entscheiden für die Steuerbewertung ist aber der Ort der Abholung
    //             //-> begin end versetzt
    //         END;

    //         //VAT 001 port     JST 240512     Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         //Lieferbedinungscode
    //         rrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', lrc_ShipmentMethod.Code, '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung
    //         //Not Lieferbedingungscode
    //         //mly
    //         IF lrc_ShipmentMethod.Code <> '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + lrc_ShipmentMethod.Code + '*');

    //         //Ankunftsland
    //         IF vrc_SalesInvoiceHeader."Ship-to Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + vrc_SalesInvoiceHeader."Ship-to Country/Region Code" + '*', '')
    //           ;

    //         //VAT 002 port     JST 080812     Neues Feld 50002Not Arrival Country Code in Filtersetzung einarbeiten
    //         //Nicht Ankunftsland
    //         //mly 140227
    //         IF vrc_SalesInvoiceHeader."Ship-to Country/Region Code" <> '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + vrc_SalesInvoiceHeader."Ship-to Country/Region Code" + '*');
    //         //port.jst 19.6.13

    //         // Status Zoll
    //         IF lrc_ShipmentMethod."Duty Paid" THEN BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', rrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                               rrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', rrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //                                                                               rrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         END;

    //         // Gültigkeit ab prüfen
    //         rrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', vrc_SalesInvoiceHeader."Posting Date");

    //         // Gültigkeit bis prüfen mly140625
    //         rrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', vrc_SalesInvoiceHeader."Posting Date", 0D);

    //         // VAT 001 MFL40116.e

    //     end;

    //     procedure SalesInvoiceFindTaxRecord(vrc_SalesInvoiceHeader: Record "112"; vrc_SalesInvoiceLine: Record "113"; var rrc_SalesVATEvaluation: Record "5087926"): Boolean
    //     begin
    //         // VAT 002 MFL40116.s
    //         //

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         rrc_SalesVATEvaluation.Reset();
    //         rrc_SalesVATEvaluation.INIT();

    //         //RS wenn Menge =0 dann exit
    //         IF vrc_SalesInvoiceLine.Quantity = 0 THEN
    //             EXIT;

    //         SalesInvoiceFilterTaxRecord(vrc_SalesInvoiceHeader, vrc_SalesInvoiceLine, rrc_SalesVATEvaluation);

    //         //mly+
    //         IF rrc_SalesVATEvaluation.FIND('+') THEN;
    //         IF rrc_SalesVATEvaluation.COUNT > 1 THEN
    //             ;
    //         //mly-

    //         EXIT(rrc_SalesVATEvaluation.FIND('+'));
    //         // VAT 002 MFL40116.e
    //     end;

    //     procedure SalesCrMemoFilterTaxRecord(vrc_SalesCrMemoHeader: Record "114"; vrc_SalesCrMemoLine: Record "115"; var rrc_SalesVATEvaluation: Record "5087926")
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_VATRegistrationNo: Record "50022";
    //     begin
    //         // VAT 001 MFL40116.s
    //         lrc_Customer.GET(vrc_SalesCrMemoHeader."Sell-to Customer No.");

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         //grc_CompanyInformation.GET();
    //         //CompCountry:=grc_CompanyInformation."Country/Region Code";

    //         //RS Filter auf länderspezifischen Datensatz und Verweendung der nationalen UST-ID
    //         IF vrc_SalesCrMemoLine.Type = vrc_SalesCrMemoLine.Type::Item THEN BEGIN
    //             lrc_Location.GET(vrc_SalesCrMemoLine."Location Code");
    //             IF grc_CompanyInformation.GET(lrc_Location."Country/Region Code") THEN
    //                 CompCountry := grc_CompanyInformation."Primary Key";
    //         END ELSE BEGIN
    //             grc_CompanyInformation.GET();
    //             CompCountry := grc_CompanyInformation."Country/Region Code";
    //         END;
    //         lrc_Location.Reset();


    //         //VAT 017 port     JST 060613     Location zuerst Zeile ansehen, dann Kopf
    //         IF vrc_SalesCrMemoLine."Location Code" <> '' THEN BEGIN
    //             lrc_Location.GET(vrc_SalesCrMemoLine."Location Code");
    //         END ELSE BEGIN
    //             IF vrc_SalesCrMemoHeader."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_SalesCrMemoHeader."Location Code");
    //             END ELSE BEGIN
    //                 rrc_SalesVATEvaluation.SETFILTER("Departure Location Code", 'keiner');
    //                 EXIT;
    //             END;
    //         END;
    //         //ist Lieferbedingung vorhanden ?
    //         IF vrc_SalesCrMemoHeader."Shipment Method Code" = '' THEN BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", 'keine');
    //             EXIT;
    //         END;
    //         lrc_ShipmentMethod.GET(vrc_SalesCrMemoHeader."Shipment Method Code");


    //         rrc_SalesVATEvaluation.Reset();

    //         //VAT 003 port     JST 160812
    //         rrc_SalesVATEvaluation.SETRANGE(Source, rrc_SalesVATEvaluation.Source::Sales);


    //         // FV4 008 00000000 STH 280708.s --> Abhängig von der Verkaufsbelegunterart
    //         rrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Type", '%1|%2', rrc_SalesVATEvaluation."Sales/Purch Doc. Type"::Order,
    //                                                                     rrc_SalesVATEvaluation."Sales/Purch Doc. Type"::" ");
    //         rrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Subtype Code", '%1|%2', vrc_SalesCrMemoHeader."Sales Doc. Subtype Code", '');
    //         // FV4 008 00000000 STH 280708.e

    //         //port.jst 20.6.13

    //         //VAT 012 port     JST 250413     Zeilenfilter Unterscheidung Item und ItemCharge und G/L Account
    //         // Eingrenzung auf Artikel, Sachkonto und VVE bzw G/L Account
    //         CASE vrc_SalesCrMemoLine.Type OF
    //             vrc_SalesCrMemoLine.Type::Item:
    //                 rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::Item);
    //             vrc_SalesCrMemoLine.Type::"G/L Account":
    //                 BEGIN
    //                     IF vrc_SalesCrMemoLine.Subtyp = vrc_SalesCrMemoLine.Subtyp::Discount THEN
    //                         //RS Subtype VVE findet derzeit keine Verwendung
    //                         //rrc_SalesVATEvaluation.SETRANGE("Line Type",rrc_SalesVATEvaluation."Line Type"::"Subtype VVE")
    //                         rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"G/L Account")
    //                     ELSE
    //                         rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"G/L Account");
    //                 END;
    //             vrc_SalesCrMemoLine.Type::"Charge (Item)":
    //                 BEGIN
    //                     rrc_SalesVATEvaluation.SETRANGE("Line Type", rrc_SalesVATEvaluation."Line Type"::"Item Charge");
    //                 END;
    //         END;

    //         //VAT 005 port     JST 280213     Filtersetzung mit * für Mehrfachnennung bei nachfolgenden SetFilter
    //         //                                Debitorenbuchungsgruppe Debitor-Ländercode Abgangsland Zugang-Ländercode
    //         // Debitorenbuchungsgruppe
    //         //rrc_SalesVATEvaluation.SETRANGE("Cust/Vend Posting Group", vrc_SalesCrMemoHeader."Customer Posting Group");
    //         //RS Filter auf eine Buchungsgruppe beschränkt
    //         //rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group",'%1|%2','*'+vrc_SalesCrMemoHeader."Customer Posting Group"+'*','');
    //         rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group", '%1|%2', vrc_SalesCrMemoHeader."Customer Posting Group", '');

    //         // Land Kunde
    //         //port.jst 30.5Umschaltung Land Kunde auf Lieferung an (Nicht Verkauf an)
    //         //RS abstellen auf Ship-to Country
    //         //IF vrc_SalesCrMemoHeader."Sell-to Country/Region Code" = '' THEN BEGIN
    //         //  rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*'+CompCountry+'*', '')
    //         //END ELSE BEGIN
    //         //  rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code",'%1|%2','*'+vrc_SalesCrMemoHeader."Sell-to Country/Region Code"+'*',''
    //         //);
    //         //END;

    //         IF vrc_SalesCrMemoHeader."Ship-to Country/Region Code" = '' THEN BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + vrc_SalesCrMemoHeader."Ship-to Country/Region Code" + '*', ''
    //           );
    //         END;


    //         //VAT 007 port     JST 280213     Neue Feld in Filtersetzung einarbeiten
    //         //Not Land Kunde
    //         IF vrc_SalesCrMemoHeader."Sell-to Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code"
    //                                                                    , '<>*' + vrc_SalesCrMemoHeader."Sell-to Country/Region Code" + '*');

    //         // Abgangsland
    //         IF lrc_Location."Country/Region Code" = '' THEN BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lrc_Location."Country/Region Code" + '*', '');
    //         END;

    //         //NICHT Abgangsland
    //         IF lrc_Location."Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lrc_Location."Country/Region Code" + '*');

    //         //Zusatz-Registrierung im Abgangsland
    //         //VAT 009 port     JST 200313     Neues Feld "VAT-Reg Departure Country Code" als Option keine, direkt oder Fiscal
    //         //ForeignVatPlace
    //         lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_SalesCrMemoHeader."Sell-to Customer No.");
    //         IF lrc_Location."Country/Region Code" = '' THEN
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", CompCountry)
    //         ELSE
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", lrc_Location."Country/Region Code");
    //         IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //             IF lrc_VATRegistrationNo."VAT Detection" THEN BEGIN
    //                 rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_VATRegistrationNo."Registration Typ")
    //             END ELSE BEGIN
    //                 rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", rrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //             END;
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", rrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         END;

    //         // VAT 003 ADÜ40071.s
    //         // Abgangslager
    //         rrc_SalesVATEvaluation.SETFILTER("Departure Location Code", '%1|%2', lrc_Location.Code, '');

    //         //VAT 011 port     JST 250413     Neues Feld Not Departure Location Code
    //         //NICHT Abgangslager
    //         IF lrc_Location.Code <> '' THEN
    //             //mly 140310
    //             rrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code", filt_start + lrc_Location.Code + filt_end);

    //         /************
    //         //VAT 016 port     JST 060613     Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
    //         //Fiscalvertreter
    //         rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent",'%1|%2',lrc_Location."Fiscal Agent Code",'');
    //         **************/

    //         //RS Vorrang Fiskalvertreter in BatchVariant
    //         IF lrc_BatchVariant.GET(vrc_SalesCrMemoLine."Batch Variant No.") THEN BEGIN
    //             IF lrc_BatchVariant."Fiscal Agent Code" <> '' THEN
    //                 rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1', lrc_BatchVariant."Fiscal Agent Code")
    //             ELSE
    //                 rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END;
    //         //RS.e

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         //Not Fiscalvertreter
    //         //mly
    //         IF lrc_Location."Fiscal Agent Code" <> '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + lrc_Location."Fiscal Agent Code" + '*');

    //         // Lieferbedingung
    //         IF lrc_ShipmentMethod."Self-Collector" THEN BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("Shipment Type", rrc_SalesVATEvaluation."Shipment Type"::Selbstabholer)
    //         END ELSE BEGIN
    //             rrc_SalesVATEvaluation.SETRANGE("Shipment Type", rrc_SalesVATEvaluation."Shipment Type"::Franco);
    //             //port.Jst 30.5.12 Anmerkung, Bisher Unterbedingung bei Franco. Entscheiden für die Steuerbewertung ist aber der Ort der Abholung
    //             //-> begin end versetzt
    //         END;

    //         //VAT 001 port     JST 240512     Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         //Lieferbedinungscode
    //         rrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', lrc_ShipmentMethod.Code, '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung
    //         //Not Lieferbedingungscode
    //         //mly
    //         IF lrc_ShipmentMethod.Code <> '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + lrc_ShipmentMethod.Code + '*');

    //         //Ankunftsland
    //         IF vrc_SalesCrMemoHeader."Ship-to Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + vrc_SalesCrMemoHeader."Ship-to Country/Region Code" + '*', '');

    //         //VAT 002 port     JST 080812     Neues Feld 50002Not Arrival Country Code in Filtersetzung einarbeiten
    //         //Nicht Ankunftsland
    //         IF vrc_SalesCrMemoHeader."Ship-to Country/Region Code" = '' THEN
    //             rrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + vrc_SalesCrMemoHeader."Ship-to Country/Region Code" + '*');

    //         //port.jst 20.6.13

    //         // Status Zoll
    //         IF lrc_ShipmentMethod."Duty Paid" THEN
    //             rrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', rrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                             rrc_SalesVATEvaluation."State Customer Duty"::" ")
    //         ELSE
    //             rrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', rrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //                                                                             rrc_SalesVATEvaluation."State Customer Duty"::" ");

    //         // Gültigkeit ab prüfen
    //         rrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', vrc_SalesCrMemoHeader."Posting Date");
    //         // VAT 001 MFL40116.e

    //         // Gültigkeit bis prüfen mly140625
    //         rrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', vrc_SalesCrMemoHeader."Posting Date", 0D);

    //     end;

    //     procedure SalesCrMemoFindTaxRecord(vrc_SalesCrMemoHeader: Record "114"; vrc_SalesCrMemoLine: Record "115"; var rrc_SalesVATEvaluation: Record "5087926"): Boolean
    //     begin
    //         // VAT 002 MFL40116.s

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         rrc_SalesVATEvaluation.Reset();
    //         rrc_SalesVATEvaluation.INIT();

    //         //RS wenn Menge =0 dann exit
    //         IF vrc_SalesCrMemoLine.Quantity = 0 THEN
    //             EXIT;


    //         SalesCrMemoFilterTaxRecord(vrc_SalesCrMemoHeader, vrc_SalesCrMemoLine, rrc_SalesVATEvaluation);

    //         //mly+
    //         IF rrc_SalesVATEvaluation.FIND('+') THEN;
    //         IF rrc_SalesVATEvaluation.COUNT > 1 THEN
    //             ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //               //mly-

    //         EXIT(rrc_SalesVATEvaluation.FIND('+'));
    //         // VAT 002 MFL40116.e
    //     end;

    procedure PurchCalcBusPosGrp(vin_PurchDocType: Option "0","1","2","3","4","5","6","7"; vco_PurchDocNo: Code[20])
    var
        lrc_PurchDocSubtype: Record "POI Purch. Doc. Subtype";
        //lrc_WindowsAccessControl: Record "Access Control";
        //lrc_WindowsLogin: Record "2000000054";
        lco_GenBusPostingGroup: Code[10];
        lco_VatBusPostingGroup: Code[10];
        lbn_EqualValues: Boolean;

    begin
        // ------------------------------------------------------------------------------------------------
        // Kontrolle Geschäftsbuchungsgruppe
        // ------------------------------------------------------------------------------------------------
        lrc_PurchaseHeader.GET(vin_PurchDocType, vco_PurchDocNo);

        //EK-Gutschriften keine Prüfung bei Mitarbeitern FIBU
        lrc_PurchDocSubtype.GET(lrc_PurchaseHeader."Document Type", lrc_PurchaseHeader."POI Purch. Doc. Subtype Code");
        IF UPPERCASE(USERID()) IN ['FALKENHAGEN', 'SCHNEIDER'] THEN EXIT; //TODO: prüfen
        IF NOT lrc_PurchDocSubtype."Use VAT Evaluation" THEN EXIT;
        lrc_PurchaseLine.RESET();
        lrc_PurchaseLine.SETRANGE("Document Type", lrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", lrc_PurchaseHeader."No.");
        lrc_PurchaseLine.SETFILTER(Type, '<>%1', lrc_PurchaseLine.Type::" ");
        lrc_PurchaseLine.SETFILTER("No.", '<>%1', '');
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT
                IF PurchGetBusPosGrp(lrc_PurchaseHeader, lrc_PurchaseLine, lco_GenBusPostingGroup,
                                          lco_VatBusPostingGroup, lbn_EqualValues) = TRUE THEN BEGIN

                    lrc_PurchaseHeader."Gen. Bus. Posting Group" := lco_GenBusPostingGroup;
                    lrc_PurchaseHeader."VAT Bus. Posting Group" := lco_VatBusPostingGroup;
                    lrc_PurchaseHeader.MODIFY();
                    lrc_PurchaseLine.VALIDATE("Gen. Bus. Posting Group", lco_GenBusPostingGroup);
                    lrc_PurchaseLine.VALIDATE("VAT Bus. Posting Group", lco_VatBusPostingGroup);
                    lrc_PurchaseLine.MODIFY();
                END ELSE
                    //Änderung im Header auch, wenn Lines nicht geändert werden
                    IF lrc_PurchaseLine.Type = lrc_PurchaseLine.Type::Item THEN BEGIN
                        lrc_PurchaseHeader."Gen. Bus. Posting Group" := lrc_PurchaseLine."Gen. Bus. Posting Group";
                        lrc_PurchaseHeader."VAT Bus. Posting Group" := lrc_PurchaseLine."VAT Bus. Posting Group";
                        lrc_PurchaseHeader.MODIFY();
                    END;
            UNTIL lrc_PurchaseLine.NEXT() = 0;
    end;

    procedure PurchGetBusPosGrp(vrc_PurchaseHeader: Record "Purchase Header"; vrc_PurchaseLine: Record "Purchase Line"; var rco_GenBusPostingGroup: Code[10]; var rco_VatBusPostingGroup: Code[10]; var rbn_EqualValues: Boolean): Boolean
    var
        lrc_Location: Record Location;
        lrc_ShipmentMethod: Record "Shipment Method";
        lrc_SalesVATEvaluation: Record "POI Sales/Purch. VAT Eval";
        lrc_Vendor: Record Vendor;
    // lrc_VATRegistrationNo: Record "POI VAT Registr. No. Vend/Cust";
    // lco_DepartureCountry: Code[10];
    // KreditorCountry: Code[10];
    // ArrivalCountry: Code[10];
    // Find: Boolean;

    begin
        // ------------------------------------------------------------------------------------------------
        // Funktion zur Ermittlung der steuerlichen Kontierung
        // ------------------------------------------------------------------------------------------------
        // vrc_SalesHeader
        // vrc_SalesLine
        // rco_GenBusPostingGroup
        // rco_VatBusPostingGroup
        // ------------------------------------------------------------------------------------------------

        rbn_EqualValues := FALSE;

        lrc_Vendor.GET(vrc_PurchaseHeader."Buy-from Vendor No.");
        IF vrc_PurchaseLine."Location Code" <> '' THEN
            lrc_Location.GET(vrc_PurchaseLine."Location Code")
        ELSE
            //VAT 025 port     JST 041113     Fehler im Programmcode, ist Lager-Zeile leere dann aus dem Kopf
            IF vrc_PurchaseHeader."Location Code" <> '' THEN
                lrc_Location.GET(vrc_PurchaseHeader."Location Code")
            ELSE
                IF vrc_PurchaseLine.Type = vrc_PurchaseLine.Type::Item THEN
                    ERROR('Sie müssen einen Lagerort angeben');

        IF vrc_PurchaseHeader."Shipment Method Code" = '' THEN
            IF vrc_PurchaseLine.Type = vrc_PurchaseLine.Type::Item THEN
                ERROR('Sie müssen einen Lieferbedingungscode angeben');
        IF vrc_PurchaseHeader."Shipment Method Code" <> '' THEN
            lrc_ShipmentMethod.GET(vrc_PurchaseHeader."Shipment Method Code");
        lrc_SalesVATEvaluation.RESET();
        IF PurchVATEvaluationGet(vrc_PurchaseHeader, vrc_PurchaseLine, lrc_SalesVATEvaluation) THEN BEGIN
            IF (lrc_SalesVATEvaluation."Gen. Bus. Posting Group" <> vrc_PurchaseLine."Gen. Bus. Posting Group") OR
               (lrc_SalesVATEvaluation."VAT Bus. Posting Group" <> vrc_PurchaseLine."VAT Bus. Posting Group") THEN BEGIN
                rco_GenBusPostingGroup := lrc_SalesVATEvaluation."Gen. Bus. Posting Group";
                rco_VatBusPostingGroup := lrc_SalesVATEvaluation."VAT Bus. Posting Group";
                EXIT(TRUE);
            END ELSE BEGIN
                rbn_EqualValues := TRUE;
                EXIT(FALSE);
            END;
        END ELSE
            //kein Übertrag GeschBuc Kopf->Zeilen raus, Zeile unverändert blei z.B. man.Korrekturen
            IF vrc_PurchaseHeader."Gen. Bus. Posting Group" <> vrc_PurchaseLine."Gen. Bus. Posting Group" THEN
                EXIT(FALSE)
            ELSE
                EXIT(FALSE);
        EXIT(FALSE);
    end;

    procedure PurchVATEvaluationGet(var vrc_PurchaseHeader: Record "Purchase Header"; var vrc_PurchaseLine: Record "Purchase Line"; var vrc_SalesVATEvaluation: Record "POI Sales/Purch. VAT Eval"): Boolean
    var
        lrc_Vendor: Record Vendor;
        lrc_Location: Record Location;
        lrc_ShipmentMethod: Record "Shipment Method";
        lrc_VATRegistrationNo: Record "POI VAT Registr. No. Vend/Cust";
        lrc_DepartureLocation: Record Location;
        POIFunc: Codeunit POIFunction;
        lco_Herkunftsland: Code[10];
        ArrivalCountry: Code[10];

    begin
        // ------------------------------------------------------------------------------------------------
        // Funktion zur Ermittlung der steuerlichen Kontierung Einkauf
        // ------------------------------------------------------------------------------------------------

        ADF_Setup.GET();
        IF NOT ADF_Setup."POI Purch. Find Bus. Post. Grp" THEN
            EXIT(FALSE);

        //keine Prüfung bei EK-Gutschriften für Fibu Mitarbeiter
        IF vrc_PurchaseHeader."Document Type" = vrc_PurchaseHeader."Document Type"::"Credit Memo" THEN
            IF POIFunc.CheckUserInRole('__FIBU', 0) THEN //TODO: prüfen
                EXIT(FALSE);

        //falls Abgangslager gefüllt, dann Land aus Abgangslager
        //falls USt-Registrierung dann CompanyInfo Datensatz mit Ländercode
        //Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
        IF vrc_PurchaseHeader."POI Departure Location Code" <> '' THEN BEGIN
            lrc_Location.GET(vrc_PurchaseHeader."POI Departure Location Code");
            IF grc_CompanyInformation.GET(lrc_Location."Country/Region Code") THEN
                //CompCountry := grc_CompanyInformation."Country/Region Code" ELSE BEGIN
                CompCountry := grc_CompanyInformation."Primary Key";
        END ELSE
            IF grc_CompanyInformation.GET(vrc_PurchaseHeader."Buy-from Country/Region Code") THEN
                //CompCountry := grc_CompanyInformation."Country/Region Code" ELSE BEGIN
                CompCountry := grc_CompanyInformation."Primary Key" ELSE BEGIN
                grc_CompanyInformation.GET();
                CompCountry := grc_CompanyInformation."Country/Region Code";
            END;
        lrc_Location.RESET();

        //Kreditor
        lrc_Vendor.GET(vrc_PurchaseHeader."Buy-from Vendor No.");
        //Herkunftsland (wo kommt Ware her)
        //RS Prüfung, ob Abgangslagerort gefüllt, wenn ja, dann lco_Herkunftsland = Abgangslager Land
        IF vrc_PurchaseHeader."POI Departure Location Code" <> '' THEN BEGIN
            lrc_Location.GET(vrc_PurchaseHeader."POI Departure Location Code");
            lco_Herkunftsland := lrc_Location."Country/Region Code";
        END ELSE
            IF vrc_PurchaseHeader."Buy-from Country/Region Code" = '' THEN
                lco_Herkunftsland := CompCountry
            ELSE
                lco_Herkunftsland := vrc_PurchaseHeader."Buy-from Country/Region Code";

        //Ankunftslager (Wo geht Ware hin (Port-Lager)
        IF vrc_PurchaseLine."Location Code" <> '' THEN
            lrc_Location.GET(vrc_PurchaseLine."Location Code")
        ELSE
            IF vrc_PurchaseLine.Type = vrc_PurchaseLine.Type::Item THEN
                IF vrc_PurchaseHeader."Location Code" <> '' THEN
                    lrc_Location.GET(vrc_PurchaseHeader."Location Code")
                ELSE
                    IF vrc_PurchaseLine.Type = vrc_PurchaseLine.Type::Item THEN
                        ERROR('Sie müssen einen Lagerort angeben');
        //Zugangsland (wo geht Ware hin /Port.Lager)
        IF lrc_Location."Country/Region Code" <> ''
          THEN
            ArrivalCountry := lrc_Location."Country/Region Code"
        ELSE
            ArrivalCountry := CompCountry;

        //Lieferbedingung holen
        IF vrc_PurchaseHeader."Shipment Method Code" = '' THEN
            IF vrc_PurchaseLine.Type = vrc_PurchaseLine.Type::Item THEN
                ERROR('Sie müssen eine Lieferbedingung angeben');
        IF vrc_PurchaseHeader."Shipment Method Code" <> '' THEN
            lrc_ShipmentMethod.GET(vrc_PurchaseHeader."Shipment Method Code");

        //Einkauf untersuchen
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        vrc_SalesVATEvaluation.RESET();
        vrc_SalesVATEvaluation.SETRANGE(Source, vrc_SalesVATEvaluation.Source::Purchase);

        vrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Type", '%1|%2', vrc_SalesVATEvaluation."Sales/Purch Doc. Type"::Order,
                                                                    vrc_SalesVATEvaluation."Sales/Purch Doc. Type"::" ");

        vrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Subtype Code", '%1|%2', vrc_PurchaseHeader."POI Purch. Doc. Subtype Code", '');

        //Zeilenfilter Unterscheidung Item und ItemCharge und G/L Account
        // Eingrenzung auf Artikel, Sachkonto und VVE bzw G/L Account
        CASE vrc_PurchaseLine.Type OF
            vrc_PurchaseLine.Type::Item:
                vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::Item);
            vrc_PurchaseLine.Type::"G/L Account":
                IF vrc_PurchaseLine."POI Subtyp" = vrc_PurchaseLine."POI Subtyp"::Discount THEN
                    vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"G/L Account")
                ELSE
                    vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"G/L Account");
            vrc_PurchaseLine.Type::"Charge (Item)":
                vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"Item Charge");
            ELSE
                EXIT(FALSE);
        END;
        // Kreditorenbuchungsgruppe
        //RS Beschränkung auf eindeutige Kreditorenbuchungsgruppe
        vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group", '%1|%2', vrc_PurchaseHeader."Vendor Posting Group", '');

        // Land Kunde
        IF lrc_Vendor."Country/Region Code" = '' THEN
            vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + CompCountry + '*', '')
        ELSE
            vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + lrc_Vendor."Country/Region Code" + '*', '');
        //NICHT Land Kunde
        IF lrc_Vendor."Country/Region Code" = '' THEN
            vrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + CompCountry + '*')
        ELSE
            vrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + lrc_Vendor."Country/Region Code" + '*');

        //Abgangsland  -> EK = Herkunft,wo kommt Ware her
        vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lco_Herkunftsland + '*', '');
        // NIcht Abgangsland  -> EK = Herkunft
        IF lco_Herkunftsland <> '' THEN
            vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lco_Herkunftsland + '*');

        //Zusatz-Registrierung vom Kreditor im Herkunftsland (ForeignVatPlace)
        lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_PurchaseHeader."Buy-from Vendor No.");
        lrc_VATRegistrationNo.SETRANGE("Country Code", lco_Herkunftsland);
        IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
            IF lrc_VATRegistrationNo."VAT Detection" THEN
                vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_VATRegistrationNo."Registration Typ")
            ELSE
                vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", vrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
        END ELSE
            vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", vrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);

        // Abgangslager  in EK nicht benutzt, Abgangslager des Kreditr nicht bekannt
        //ohne Lagerort falsche Buchungsgruppen:
        vrc_SalesVATEvaluation.SETFILTER("Departure Location Code", '%1|%2', lrc_Location.Code, '');

        //Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
        //Fiscalvertreter
        //wenn Fiskalvertreter im PurchaseHeader dann Filter nur auf diesen
        vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."POI Fiscal Agent Code", '');

        IF vrc_PurchaseHeader."POI Fiscal Agent Code" <> '' THEN
            vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1', vrc_PurchaseHeader."POI Fiscal Agent Code")
        ELSE
            vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."POI Fiscal Agent Code", '');

        IF lrc_Location."POI Fiscal Agent Code" <> '' THEN
            vrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + lrc_Location."POI Fiscal Agent Code" + '*');

        // Lieferbedingung
        IF lrc_ShipmentMethod."POI Self-Collector" THEN
            vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Selbstabholer)
        ELSE
            vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Franco);

        //Zugangsland (wo geht Ware hin (Land Lager-Port)
        vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + ArrivalCountry + '*', '');
        //NOt Zugangland
        IF ArrivalCountry <> '' THEN
            vrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + ArrivalCountry + '*');

        //Zugangslagerort  EK = wo geht Ware hin (Port-Lager)
        vrc_SalesVATEvaluation.SETFILTER("Arrival Location Code", '%1|%2', '*' + lrc_Location.Code + '*', '');
        //NIcht Zugangslagerort
        IF lrc_Location.Code <> '' THEN
            vrc_SalesVATEvaluation.SETFILTER("Not Arrival Location Code", '<>*' + lrc_Location.Code + '*');

        //RS temporär für PIES bis eine grundsätzliche Lösung
        IF COMPANYNAME() = 'PI European Sourcing' THEN
            IF ((vrc_PurchaseLine.Type = vrc_PurchaseLine.Type::Item) AND
                (vrc_PurchaseLine."Location Code" = 'Aldi Venlo') AND
                (NOT lrc_ShipmentMethod."POI Self-Collector") AND
                (vrc_PurchaseLine."Document No." > '15-80424')) THEN
                ERROR('Die Kombination Lagerort Aldi Venlo und %1 ist nicht möglich', lrc_ShipmentMethod.Code);

        //Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
        //Lieferbedinungscode
        vrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', lrc_ShipmentMethod.Code, '');

        //Neues Feld Not Lieferbedinung
        //Not Lieferbedingungscode

        IF lrc_ShipmentMethod.Code <> '' THEN
            vrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + lrc_ShipmentMethod.Code + '*');

        // Status Zoll
        //RS Status Zoll im EK nicht aus ShipmentMethod sondern aus PurchOrder
        case vrc_PurchaseHeader."POI Status Customs Duty" of
            vrc_PurchaseHeader."POI Status Customs Duty"::Payed:
                vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid", vrc_SalesVATEvaluation."State Customer Duty"::" ");
            vrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid":
                vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1', vrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid");
            ELSE
                vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid", vrc_SalesVATEvaluation."State Customer Duty"::" ");
        end;

        //rs steuerliche Registrierung prüfen
        //abstellen auf Abgangslager wenn gefüllt
        IF vrc_PurchaseHeader."POI Departure Location Code" <> '' THEN BEGIN
            lrc_DepartureLocation.GET(vrc_PurchaseHeader."POI Departure Location Code");
            IF lrc_DepartureLocation."Country/Region Code" = CompCountry THEN
                vrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", TRUE);
        END ELSE
            IF vrc_PurchaseHeader."Buy-from Country/Region Code" = CompCountry THEN
                vrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", TRUE) ELSE
                vrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", FALSE);
        // Gültigkeit ab prüfen
        vrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', vrc_PurchaseHeader."Posting Date");

        // Gültigkeit bis prüfen mly140625
        vrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', vrc_PurchaseHeader."Posting Date", 0D);

        //RS Prüfung ob innergemeinschaftliches Dreiecksgeschäft wg. VAT ID
        IF vrc_PurchaseHeader."POI EU Dreiecksgeschäft" THEN
            vrc_SalesVATEvaluation.SETRANGE("EU 3rd Party Trade", TRUE);

        // VAT Satz suchen
        IF vrc_SalesVATEvaluation.FIND('+') THEN BEGIN
            IF vrc_SalesVATEvaluation.COUNT() > 1 THEN
                ;
            EXIT(TRUE);
        END ELSE
            ERROR('Keine VAT Regel gefunden, bitte an IT-NAVISION ' +
              'wenden, Zeile %1, %2', vrc_PurchaseLine."Line No.", vrc_PurchaseLine.Type);
    end;

    //     procedure PurchInvoiceVATEvaluationGet(var vrc_PurchaseInvoiceHeader: Record "122"; var vrc_PurchaseInvoiceLine: Record "123"; var vrc_SalesVATEvaluation: Record "5087926"): Boolean
    //     var
    //         lrc_Vendor: Record "Vendor";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_VATRegistrationNo: Record "50022";
    //         lco_Herkunftsland: Code[10];
    //         ArrivalCountry: Code[10];
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung der steuerlichen Kontierung Einkauf
    //         // ------------------------------------------------------------------------------------------------

    //         //mly+
    //         ADF_Setup.GET();
    //         IF NOT ADF_Setup."POI Purch. Find Bus. Post. Grp" THEN
    //             EXIT(FALSE);
    //         //mly-


    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         // grc_CompanyInformation.GET();
    //         // CompCountry:=grc_CompanyInformation."Country/Region Code";

    //         //rs 140929 falls USt-Registrierung dann CompanyInfo Datensatz mit Ländercode
    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         IF grc_CompanyInformation.GET(vrc_PurchaseInvoiceHeader."Buy-from Country/Region Code") THEN
    //             CompCountry := grc_CompanyInformation."Country/Region Code" ELSE BEGIN
    //             grc_CompanyInformation.GET();
    //             CompCountry := grc_CompanyInformation."Country/Region Code";
    //         END;

    //         //Kreditor
    //         lrc_Vendor.GET(vrc_PurchaseInvoiceHeader."Buy-from Vendor No.");
    //         //Herkunftsland (wo kommt Ware her)
    //         IF vrc_PurchaseInvoiceHeader."Buy-from Country/Region Code" = '' THEN
    //             lco_Herkunftsland := CompCountry
    //         ELSE
    //             lco_Herkunftsland := vrc_PurchaseInvoiceHeader."Buy-from Country/Region Code";

    //         //Ankunftslager (Wo geht Ware hin (Port-Lager)
    //         IF vrc_PurchaseInvoiceLine."Location Code" <> '' THEN BEGIN
    //             lrc_Location.GET(vrc_PurchaseInvoiceLine."Location Code");
    //         END ELSE BEGIN
    //             IF vrc_PurchaseInvoiceHeader."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_PurchaseInvoiceLine."Location Code");
    //             END ELSE //EXIT(FALSE);
    //                 ERROR('Sie müssen einen Lagerort angeben');
    //         END;
    //         //Zugangsland (wo geht Ware hin /Port.Lager)
    //         IF lrc_Location."Country/Region Code" <> ''
    //           THEN
    //             ArrivalCountry := lrc_Location."Country/Region Code"
    //         ELSE
    //             ArrivalCountry := CompCountry;

    //         //Lieferbedingung holen
    //         IF vrc_PurchaseInvoiceHeader."Shipment Method Code" = '' THEN
    //             //  EXIT(FALSE);
    //             ERROR('Sie müssen eine Lieferbedingung angeben');
    //         lrc_ShipmentMethod.GET(vrc_PurchaseInvoiceHeader."Shipment Method Code");

    //         //Einkauf untersuchen
    //         //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //         vrc_SalesVATEvaluation.Reset();
    //         vrc_SalesVATEvaluation.SETRANGE(Source, vrc_SalesVATEvaluation.Source::Purchase);

    //         vrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Type", '%1|%2', vrc_SalesVATEvaluation."Sales/Purch Doc. Type"::Order,
    //                                                                     vrc_SalesVATEvaluation."Sales/Purch Doc. Type"::" ");

    //         vrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Subtype Code", '%1|%2', vrc_PurchaseInvoiceHeader."Purchase Doc. Subtype Code", ''
    //         );

    //         //VAT 012 port     JST 250413     Zeilenfilter Unterscheidung Item und ItemCharge und G/L Account
    //         // Eingrenzung auf Artikel, Sachkonto und VVE bzw G/L Account
    //         CASE vrc_PurchaseInvoiceLine.Type OF
    //             vrc_PurchaseInvoiceLine.Type::Item:
    //                 vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::Item);
    //             vrc_PurchaseInvoiceLine.Type::"G/L Account":
    //                 BEGIN
    //                     IF vrc_PurchaseInvoiceLine.Subtyp = vrc_PurchaseInvoiceLine.Subtyp::Discount THEN
    //                         //RS Subtype VVE findet derzeit keine Verwendung
    //                         //vrc_SalesVATEvaluation.SETRANGE("Line Type",vrc_SalesVATEvaluation."Line Type"::"Subtype VVE")
    //                         vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"G/L Account")
    //                     ELSE
    //                         vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"G/L Account");
    //                 END;
    //             vrc_PurchaseInvoiceLine.Type::"Charge (Item)":
    //                 BEGIN
    //                     vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"Item Charge");
    //                 END;
    //             ELSE
    //                 //  EXIT(FALSE);
    //                 ERROR('Keine VAT Regel gefunden, bitte an IT-NAVISION wenden');
    //         END;

    //         // Kreditorenbuchungsgruppe
    //         //RS Beschränkung auf eine Buchungsgruppe
    //         //vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group",'%1|%2','*'+vrc_PurchaseInvoiceHeader."Vendor Posting Group"+'*','');
    //         vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group", '%1|%2', vrc_PurchaseInvoiceHeader."Vendor Posting Group", '');

    //         // Land Kunde
    //         IF lrc_Vendor."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + lrc_Vendor."Country/Region Code" + '*', '');
    //         //NICHT Land Kunde
    //         IF lrc_Vendor."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + lrc_Vendor."Country/Region Code" + '*');

    //         //Abgangsland  -> EK = Herkunft,wo kommt Ware her
    //         vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lco_Herkunftsland + '*', '');
    //         // NIcht Abgangsland  -> EK = Herkunft
    //         IF lco_Herkunftsland <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lco_Herkunftsland + '*');

    //         //Zusatz-Registrierung vom Kreditor im Herkunftsland (ForeignVatPlace)
    //         lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_PurchaseInvoiceHeader."Buy-from Vendor No.");
    //         lrc_VATRegistrationNo.SETRANGE("Country Code", lco_Herkunftsland);
    //         IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //             IF lrc_VATRegistrationNo."VAT Detection" THEN BEGIN
    //                 vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_VATRegistrationNo."Registration Typ")
    //             END ELSE BEGIN
    //                 vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", vrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //             END;
    //         END ELSE BEGIN
    //             vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", vrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         END;

    //         // VAT 003 ADÜ40071.s
    //         // Abgangslager  in EK nicht benutzt, Abgangslager des Kreditr nicht bekannt
    //         //lrc_SalesVATEvaluation.SETFILTER("Departure Location Code",'%1|%2',lrc_Location.Code,'');
    //         //SalesVATEvaluationFilter:=lrc_SalesVATEvaluation.GETFILTER("Departure Location Code");
    //         // VAT 003 ADÜ40071.e

    //         //NICHT Abgangslager in EK nicht benutzt (Lager ist Ankunftslager wohin Lieferant liefert)
    //         //lrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code",'<>%1','*'+lrc_Location.Code+'*');
    //         //SalesVATEvaluationFilter:=lrc_SalesVATEvaluation.GETFILTER("Not Departure Location Code");

    //         //RS Vorrang Fiskalvertreter in BatchVariant
    //         //VAT 016 port     JST 060613     Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
    //         //Fiscalvertreter
    //         IF lrc_BatchVariant.GET(vrc_PurchaseInvoiceLine."Batch Variant No.") THEN BEGIN
    //             IF lrc_BatchVariant."Fiscal Agent Code" <> '' THEN
    //                 vrc_SalesVATEvaluation.SETRANGE("Fiscal Agent", lrc_BatchVariant."Fiscal Agent Code")
    //             ELSE
    //                 vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END ELSE BEGIN
    //             vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END;
    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         //Not Fiscalvertreter
    //         //mly
    //         IF lrc_Location."Fiscal Agent Code" <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + lrc_Location."Fiscal Agent Code" + '*');

    //         // Lieferbedingung
    //         IF lrc_ShipmentMethod."Self-Collector" THEN
    //             vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Selbstabholer)
    //         ELSE
    //             vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Franco);

    //         //Zugangsland (wo geht Ware hin (Land Lager-Port)
    //         vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + ArrivalCountry + '*', '');
    //         //NOt Zugangland
    //         IF ArrivalCountry <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + ArrivalCountry + '*');

    //         //Zugangslagerort  EK = wo geht Ware hin (Port-Lager)
    //         vrc_SalesVATEvaluation.SETFILTER("Arrival Location Code", '%1|%2', '*' + lrc_Location.Code + '*', '');
    //         //NIcht Zugangslagerort
    //         IF lrc_Location.Code <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Arrival Location Code", '<>*' + lrc_Location.Code + '*');

    //         //VAT 001 port     JST 240512     Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         //Lieferbedinungscode
    //         vrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', lrc_ShipmentMethod.Code, '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung
    //         //Not Lieferbedingungscode
    //         //mly
    //         IF lrc_ShipmentMethod.Code <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + lrc_ShipmentMethod.Code + '*');

    //         // Status Zoll
    //         IF lrc_ShipmentMethod."Duty Paid" = TRUE THEN BEGIN
    //             vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                            vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         END ELSE BEGIN
    //             vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //                                                                            vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         END;

    //         //rs steuerliche Registrierung prüfen
    //         IF vrc_PurchaseInvoiceHeader."Buy-from Country/Region Code" = CompCountry THEN
    //             vrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", TRUE) ELSE
    //             vrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", FALSE);


    //         // Gültigkeit ab prüfen
    //         vrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', vrc_PurchaseInvoiceHeader."Posting Date");

    //         // Gültigkeit bis prüfen mly140625
    //         vrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', vrc_PurchaseInvoiceHeader."Posting Date", 0D);

    //         // VAT Satz suchen
    //         IF vrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF vrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             ERROR('Keine VAT Regel gefunden, bitte an Buchhahltung wenden');
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PurchCrMemoVATEvaluationGet(var vrc_PurchaseCrMemoHeader: Record "124"; var vrc_PurchaseCrMemoLine: Record "125"; var vrc_SalesVATEvaluation: Record "5087926"): Boolean
    //     var
    //         lrc_Vendor: Record "Vendor";
    //         lrc_Location: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_VATRegistrationNo: Record "50022";
    //         "***Purchase Ergänzung": Integer;
    //         "lrc_Departure Region": Record "5110406";
    //         lco_DepartureCountry: Code[10];
    //         lco_Herkunftsland: Code[10];
    //         KreditorCountry: Code[10];
    //         ArrivalCountry: Code[10];
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         //VAT 013 port     JST 240513     Neue Funktion PurchCrMemoVATEvaluationGet integriert

    //         //mly+
    //         ADF_Setup.GET();
    //         IF NOT ADF_Setup."POI Purch. Find Bus. Post. Grp" THEN
    //             EXIT(FALSE);
    //         //mly-

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         //grc_CompanyInformation.GET();
    //         //CompCountry:=grc_CompanyInformation."Country/Region Code";

    //         //rs 140929 falls USt-Registrierung dann CompanyInfo Datensatz mit Ländercode
    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         IF grc_CompanyInformation.GET(vrc_PurchaseCrMemoHeader."Buy-from Country/Region Code") THEN
    //             CompCountry := grc_CompanyInformation."Country/Region Code" ELSE BEGIN
    //             grc_CompanyInformation.GET();
    //             CompCountry := grc_CompanyInformation."Country/Region Code";
    //         END;

    //         //Kreditor
    //         lrc_Vendor.GET(vrc_PurchaseCrMemoHeader."Buy-from Vendor No.");
    //         //Herkunftsland (wo kommt Ware her)
    //         IF vrc_PurchaseCrMemoHeader."Buy-from Country/Region Code" = '' THEN
    //             lco_Herkunftsland := CompCountry
    //         ELSE
    //             lco_Herkunftsland := vrc_PurchaseCrMemoHeader."Buy-from Country/Region Code";

    //         //Ankunftslager (Wo geht Ware hin (Port-Lager)
    //         IF vrc_PurchaseCrMemoLine."Location Code" <> '' THEN BEGIN
    //             lrc_Location.GET(vrc_PurchaseCrMemoLine."Location Code");
    //         END ELSE BEGIN
    //             IF vrc_PurchaseCrMemoHeader."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_PurchaseCrMemoHeader."Location Code");
    //             END ELSE //EXIT(FALSE);
    //                 ERROR('Sie müssen einen Lagerort angeben');
    //         END;
    //         //Zugangsland (wo geht Ware hin /Port.Lager)
    //         IF lrc_Location."Country/Region Code" <> ''
    //           THEN
    //             ArrivalCountry := lrc_Location."Country/Region Code"
    //         ELSE
    //             ArrivalCountry := CompCountry;

    //         //Lieferbedingung holen
    //         IF vrc_PurchaseCrMemoHeader."Shipment Method Code" = '' THEN
    //             //  EXIT(FALSE);
    //             ERROR('Sie müssen eine Lieferbedingung angeben');
    //         lrc_ShipmentMethod.GET(vrc_PurchaseCrMemoHeader."Shipment Method Code");

    //         //Einkauf untersuchen
    //         //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //         vrc_SalesVATEvaluation.Reset();
    //         vrc_SalesVATEvaluation.SETRANGE(Source, vrc_SalesVATEvaluation.Source::Purchase);

    //         vrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Type", '%1|%2', vrc_SalesVATEvaluation."Sales/Purch Doc. Type"::Order,
    //                                                                     vrc_SalesVATEvaluation."Sales/Purch Doc. Type"::" ");

    //         vrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Subtype Code", '%1|%2', vrc_PurchaseCrMemoHeader."Purchase Doc. Subtype Code", '')
    //         ;

    //         //VAT 012 port     JST 250413     Zeilenfilter Unterscheidung Item und ItemCharge und G/L Account
    //         // Eingrenzung auf Artikel, Sachkonto und VVE bzw G/L Account
    //         CASE vrc_PurchaseCrMemoLine.Type OF
    //             vrc_PurchaseCrMemoLine.Type::Item:
    //                 vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::Item);
    //             vrc_PurchaseCrMemoLine.Type::"G/L Account":
    //                 BEGIN
    //                     IF vrc_PurchaseCrMemoLine.Subtyp = vrc_PurchaseCrMemoLine.Subtyp::Discount THEN
    //                         //RS Subtype VVE findet derzeit keine Verwendung
    //                         // vrc_SalesVATEvaluation.SETRANGE("Line Type",vrc_SalesVATEvaluation."Line Type"::"Subtype VVE")
    //                         vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"G/L Account")
    //                     ELSE
    //                         vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"G/L Account");
    //                 END;
    //             vrc_PurchaseCrMemoLine.Type::"Charge (Item)":
    //                 BEGIN
    //                     vrc_SalesVATEvaluation.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type"::"Item Charge");
    //                 END;
    //             ELSE
    //                 //  EXIT(FALSE);
    //                 ERROR('Keine VAT Regel gefunden, bitte an IT-NAVISION wenden');
    //         END;

    //         // Kreditorenbuchungsgruppe
    //         //RS Beschränkung auf eine Buchungsgruppe
    //         //vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group",'%1|%2','*'+vrc_PurchaseCrMemoHeader."Vendor Posting Group"+'*','');
    //         vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group", '%1|%2', vrc_PurchaseCrMemoHeader."Vendor Posting Group", '');

    //         // Land Kunde
    //         IF lrc_Vendor."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code", '%1|%2', '*' + lrc_Vendor."Country/Region Code" + '*', '');
    //         //NICHT Land Kunde
    //         IF lrc_Vendor."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Not Cust/Vend Country Code", '<>*' + lrc_Vendor."Country/Region Code" + '*');

    //         //Abgangsland  -> EK = Herkunft,wo kommt Ware her
    //         vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lco_Herkunftsland + '*', '');
    //         // NIcht Abgangsland  -> EK = Herkunft
    //         IF lco_Herkunftsland <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lco_Herkunftsland + '*');

    //         //Zusatz-Registrierung vom Kreditor im Herkunftsland (ForeignVatPlace)
    //         lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_PurchaseCrMemoHeader."Buy-from Vendor No.");
    //         lrc_VATRegistrationNo.SETRANGE("Country Code", lco_Herkunftsland);
    //         IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //             IF lrc_VATRegistrationNo."VAT Detection" THEN BEGIN
    //                 vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", lrc_VATRegistrationNo."Registration Typ")
    //             END ELSE BEGIN
    //                 vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", vrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //             END;
    //         END ELSE BEGIN
    //             vrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code", vrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         END;

    //         // VAT 003 ADÜ40071.s
    //         // Abgangslager  in EK nicht benutzt, Abgangslager des Kreditr nicht bekannt
    //         //lrc_SalesVATEvaluation.SETFILTER("Departure Location Code",'%1|%2',lrc_Location.Code,'');
    //         //SalesVATEvaluationFilter:=lrc_SalesVATEvaluation.GETFILTER("Departure Location Code");
    //         // VAT 003 ADÜ40071.e

    //         //NICHT Abgangslager in EK nicht benutzt (Lager ist Ankunftslager wohin Lieferant liefert)
    //         //lrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code",'<>%1','*'+lrc_Location.Code+'*');
    //         //SalesVATEvaluationFilter:=lrc_SalesVATEvaluation.GETFILTER("Not Departure Location Code");

    //         //RS Fiskalvertreter Batch hat Vorrang vor Fiskalvertreter Location
    //         //VAT 016 port     JST 060613     Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
    //         //Fiscalvertreter
    //         vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');

    //         IF lrc_BatchVariant.GET(vrc_PurchaseCrMemoLine."Batch Variant No.") THEN BEGIN
    //             IF lrc_BatchVariant."Fiscal Agent Code" <> '' THEN
    //                 vrc_SalesVATEvaluation.SETRANGE("Fiscal Agent", lrc_BatchVariant."Fiscal Agent Code")
    //             ELSE
    //                 vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END ELSE BEGIN
    //             vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_Location."Fiscal Agent Code", '');
    //         END;


    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         //Not Fiscalvertreter
    //         //mly
    //         IF lrc_Location."Fiscal Agent Code" <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + lrc_Location."Fiscal Agent Code" + '*');

    //         // Lieferbedingung
    //         IF lrc_ShipmentMethod."Self-Collector" THEN
    //             vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Selbstabholer)
    //         ELSE
    //             vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Franco);

    //         //Zugangsland (wo geht Ware hin (Land Lager-Port)
    //         vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + ArrivalCountry + '*', '');
    //         //NOt Zugangland
    //         IF ArrivalCountry <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + ArrivalCountry + '*');

    //         //Zugangslagerort  EK = wo geht Ware hin (Port-Lager)
    //         vrc_SalesVATEvaluation.SETFILTER("Arrival Location Code", '%1|%2', '*' + lrc_Location.Code + '*', '');
    //         //NIcht Zugangslagerort
    //         IF lrc_Location.Code <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Arrival Location Code", '<>*' + lrc_Location.Code + '*');

    //         //VAT 001 port     JST 240512     Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         //Lieferbedinungscode
    //         vrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', lrc_ShipmentMethod.Code, '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung
    //         //Not Lieferbedingungscode
    //         //mly
    //         IF lrc_ShipmentMethod.Code <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + lrc_ShipmentMethod.Code + '*');

    //         // Status Zoll
    //         IF lrc_ShipmentMethod."Duty Paid" = TRUE THEN BEGIN
    //             vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                            vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         END ELSE BEGIN
    //             vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //                                                                            vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         END;

    //         //rs steuerliche Registrierung prüfen
    //         IF vrc_PurchaseCrMemoHeader."Buy-from Country/Region Code" = CompCountry THEN
    //             vrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", TRUE) ELSE
    //             vrc_SalesVATEvaluation.SETRANGE("Fiscal Reg.", FALSE);

    //         // Gültigkeit ab prüfen
    //         vrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', vrc_PurchaseCrMemoHeader."Posting Date");

    //         // Gültigkeit bis prüfen mly140625
    //         vrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', vrc_PurchaseCrMemoHeader."Posting Date", 0D);

    //         // VAT Satz suchen
    //         IF vrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF vrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             ERROR('Keine VAT Regel gefunden, bitte an IT-NAVISION wenden');
    //             //  EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PurchEvaluationEntryExists(var vrc_PurchaseHeader: Record "38"; var vrc_PurchaseLine: Record "39"; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         ConditionNo := 0;

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         IF PurchVATEvaluationGet(vrc_PurchaseHeader, vrc_PurchaseLine, lrc_SalesVATEvaluation) THEN BEGIN
    //             ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PurchInvEvaluationEntryExists(var vrc_PurchaseInvoiceHeader: Record "122"; var vrc_PurchaseInvoiceLine: Record "123"; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         ConditionNo := 0;

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         IF PurchInvoiceVATEvaluationGet(vrc_PurchaseInvoiceHeader, vrc_PurchaseInvoiceLine, lrc_SalesVATEvaluation) THEN BEGIN
    //             ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PurchGetAdditionalText(vrc_PurchaseHeader: Record "38"; vrc_PurchaseLine: Record "39"; var rtx_ArrAddText: array[4] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         ConditionNo := 0;

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         IF PurchVATEvaluationGet(vrc_PurchaseHeader, vrc_PurchaseLine, lrc_SalesVATEvaluation) THEN BEGIN
    //             ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //             //Array Füllen
    //             //rtx_ArrAddText[1]:=
    //             CLEAR(rtx_ArrAddText);
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //                 rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //                 rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //                 rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";
    //                 TranslateAdditionalText(lrc_SalesVATEvaluation, vrc_PurchaseHeader."Language Code", rtx_ArrAddText);
    //             END;
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PurchInvGetAdditionalText(vrc_PurchaseInvoiceHeader: Record "122"; vrc_PurchaseInvoiceLine: Record "123"; var rtx_ArrAddText: array[4] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         ConditionNo := 0;

    //         //VAT 021 port     JST 090913     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         IF PurchInvoiceVATEvaluationGet(vrc_PurchaseInvoiceHeader, vrc_PurchaseInvoiceLine, lrc_SalesVATEvaluation) THEN BEGIN
    //             ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //             //Array Füllen
    //             //rtx_ArrAddText[1]:=
    //             CLEAR(rtx_ArrAddText);
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //                 rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //                 rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //                 rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";
    //                 TranslateAdditionalText(lrc_SalesVATEvaluation, vrc_PurchaseInvoiceHeader."Language Code", rtx_ArrAddText);
    //             END;
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PurchCrMemoGetAdditionalText(vrc_PurchaseCrMemoHeader: Record "124"; vrc_PurchaseCrMemoLine: Record "125"; var rtx_ArrAddText: array[4] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         ConditionNo := 0;
    //         IF PurchCrMemoVATEvaluationGet(vrc_PurchaseCrMemoHeader, vrc_PurchaseCrMemoLine, lrc_SalesVATEvaluation) THEN BEGIN
    //             ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //             //Array Füllen
    //             //rtx_ArrAddText[1]:=
    //             CLEAR(rtx_ArrAddText);
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //                 rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //                 rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //                 rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";
    //                 TranslateAdditionalText(lrc_SalesVATEvaluation, vrc_PurchaseCrMemoHeader."Language Code", rtx_ArrAddText);
    //             END;
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PurchGetFiscalAgentText(vrc_PurchaseHeader: Record "38"; vrc_PurchaseLine: Record "39"; var rtx_ArrFiscalAgentText: array[10] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_Location: Record "14";
    //     begin
    //         ConditionNo := 0;

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         IF PurchVATEvaluationGet(vrc_PurchaseHeader, vrc_PurchaseLine, lrc_SalesVATEvaluation) THEN BEGIN
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                     EXIT;
    //                 //IF NOT lrc_Location.GET(vrc_PurchaseLine."Location Code") THEN
    //                 //  EXIT;
    //                 //VAT 017 port     JST 060613     Location zuerst Zeile ansehen, dann Kopf
    //                 IF vrc_PurchaseLine."Location Code" <> '' THEN BEGIN
    //                     lrc_Location.GET(vrc_PurchaseLine."Location Code");
    //                 END ELSE BEGIN
    //                     IF vrc_PurchaseHeader."Location Code" <> '' THEN BEGIN
    //                         lrc_Location.GET(vrc_PurchaseHeader."Location Code");
    //                     END ELSE
    //                         EXIT;
    //                 END;

    //                 IF NOT lrc_FiscalAgent.GET(lrc_Location."Fiscal Agent Code") THEN
    //                     EXIT;
    //                 rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //                 rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //                 rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                    lrc_FiscalAgent."Post Code",
    //                                                                    lrc_FiscalAgent.City);
    //                 rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");
    //                 // Übersetzung der Fiskalvertretertexte holen
    //                 lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //                 lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //                 lrc_LanguageTranslation.SETRANGE("Language Code", vrc_PurchaseHeader."Language Code");
    //                 IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                     rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //                 END ELSE BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                     rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //                 END;
    //                 EXIT(TRUE);
    //             END ELSE BEGIN
    //                 EXIT(FALSE);
    //             END;
    //         END;
    //     end;

    //     procedure PurchInvGetFiscalAgentText(vrc_PurchaseInvoiceHeader: Record "122"; vrc_PurchaseInvoiceLine: Record "123"; var rtx_ArrFiscalAgentText: array[10] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_Location: Record "14";
    //     begin
    //         ConditionNo := 0;

    //         //VAT 021 port     JST 090713     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         IF PurchInvoiceVATEvaluationGet(vrc_PurchaseInvoiceHeader, vrc_PurchaseInvoiceLine, lrc_SalesVATEvaluation) THEN BEGIN
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                     EXIT;
    //                 //IF NOT lrc_Location.GET(vrc_PurchaseInvoiceLine."Location Code") THEN
    //                 //  EXIT;
    //                 //VAT 017 port     JST 060613     Location zuerst Zeile ansehen, dann Kopf
    //                 IF vrc_PurchaseInvoiceLine."Location Code" <> '' THEN BEGIN
    //                     lrc_Location.GET(vrc_PurchaseInvoiceLine."Location Code");
    //                 END ELSE BEGIN
    //                     IF vrc_PurchaseInvoiceHeader."Location Code" <> '' THEN BEGIN
    //                         lrc_Location.GET(vrc_PurchaseInvoiceHeader."Location Code");
    //                     END ELSE
    //                         EXIT(FALSE);
    //                 END;

    //                 IF NOT lrc_FiscalAgent.GET(lrc_Location."Fiscal Agent Code") THEN
    //                     EXIT;
    //                 rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //                 rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //                 rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                    lrc_FiscalAgent."Post Code",
    //                                                                    lrc_FiscalAgent.City);
    //                 rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");
    //                 // Übersetzung der Fiskalvertretertexte holen
    //                 lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //                 lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //                 lrc_LanguageTranslation.SETRANGE("Language Code", vrc_PurchaseInvoiceHeader."Language Code");
    //                 IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                     rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //                 END ELSE BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                     rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //                 END;
    //                 EXIT(TRUE);
    //             END ELSE BEGIN
    //                 EXIT(FALSE);
    //             END;
    //         END;
    //     end;

    //     procedure PurchCrMemoGetFiscalAgentText(vrc_PurchaseCrMemoHeader: Record "124"; vrc_PurchaseCrMemoLine: Record "125"; var rtx_ArrFiscalAgentText: array[10] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_Location: Record "14";
    //     begin
    //         ConditionNo := 0;

    //         //VAT 021 port     JST 090913     Rec VatEvalutaion -> Filter und init raus :für Mehrfachaurfue von z.B. Rg oder GS
    //         lrc_SalesVATEvaluation.Reset();
    //         lrc_SalesVATEvaluation.INIT();

    //         IF PurchCrMemoVATEvaluationGet(vrc_PurchaseCrMemoHeader, vrc_PurchaseCrMemoLine, lrc_SalesVATEvaluation) THEN BEGIN
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                     EXIT;
    //                 //IF NOT lrc_Location.GET(vrc_PurchaseCrMemoLine."Location Code") THEN
    //                 //  EXIT;
    //                 //VAT 017 port     JST 060613     Location zuerst Zeile ansehen, dann Kopf
    //                 IF vrc_PurchaseCrMemoLine."Location Code" <> '' THEN BEGIN
    //                     lrc_Location.GET(vrc_PurchaseCrMemoLine."Location Code");
    //                 END ELSE BEGIN
    //                     IF vrc_PurchaseCrMemoHeader."Location Code" <> '' THEN BEGIN
    //                         lrc_Location.GET(vrc_PurchaseCrMemoHeader."Location Code");
    //                     END ELSE
    //                         EXIT(FALSE);
    //                 END;

    //                 IF NOT lrc_FiscalAgent.GET(lrc_Location."Fiscal Agent Code") THEN
    //                     EXIT;
    //                 rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //                 rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //                 rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                    lrc_FiscalAgent."Post Code",
    //                                                                    lrc_FiscalAgent.City);
    //                 rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");
    //                 // Übersetzung der Fiskalvertretertexte holen
    //                 lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //                 lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //                 lrc_LanguageTranslation.SETRANGE("Language Code", vrc_PurchaseCrMemoHeader."Language Code");
    //                 IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                     rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //                 END ELSE BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                     rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //                 END;
    //                 EXIT(TRUE);
    //             END ELSE BEGIN
    //                 EXIT(FALSE);
    //             END;
    //         END;
    //     end;

    //     procedure TranslateAdditionalText(var vrc_SalesVATEvaluation: Record "5087926"; LanguageCode: Code[10]; var rtx_ArrAddText: array[4] of Text[100])
    //     var
    //         lrc_LanguageTranslation2: Record "5087922";
    //     begin
    //         lrc_LanguageTranslation2.Reset();
    //         //port.jst 23.10.12
    //         lrc_LanguageTranslation2.SETCURRENTKEY(
    //             "Table ID", "Language Code", "Customer Posting Group", "Customer Country Code", "Departure Country Code"
    //             , "Arrival Country Code", "Not Arrival Country Code", "Shipment Method Code", "Shipment Type"
    //             , "Departure Location Code", Source, "State Customer Duty", "Sales/Purch Doc. Type"
    //             , "Sales/Purch Doc. Subtype Code", "Line Type", "Line Code");
    //         lrc_LanguageTranslation2.SETRANGE("Table ID", DATABASE::"Sales/Purch. VAT Evaluation");
    //         lrc_LanguageTranslation2.SETRANGE("Customer Posting Group", vrc_SalesVATEvaluation."Cust/Vend Posting Group");
    //         lrc_LanguageTranslation2.SETRANGE("Customer Country Code", vrc_SalesVATEvaluation."Cust/Vend Country Code");
    //         lrc_LanguageTranslation2.SETRANGE("Departure Country Code", vrc_SalesVATEvaluation."Departure Country Code");
    //         lrc_LanguageTranslation2.SETRANGE("Arrival Country Code", vrc_SalesVATEvaluation."Arrival Country Code");
    //         lrc_LanguageTranslation2.SETRANGE("Not Arrival Country Code", vrc_SalesVATEvaluation."Not Arrival Country Code");
    //         lrc_LanguageTranslation2.SETRANGE("Shipment Method Code", vrc_SalesVATEvaluation."Shipment Method Code");
    //         lrc_LanguageTranslation2.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type");
    //         //port.23.10.12
    //         lrc_LanguageTranslation2.SETRANGE("Departure Location Code", vrc_SalesVATEvaluation."Departure Location Code");
    //         lrc_LanguageTranslation2.SETRANGE(Source, vrc_SalesVATEvaluation.Source);
    //         lrc_LanguageTranslation2.SETRANGE("State Customer Duty", vrc_SalesVATEvaluation."State Customer Duty");
    //         lrc_LanguageTranslation2.SETRANGE("Sales/Purch Doc. Type", vrc_SalesVATEvaluation."Sales/Purch Doc. Type");
    //         lrc_LanguageTranslation2.SETRANGE("Sales/Purch Doc. Subtype Code", vrc_SalesVATEvaluation."Sales/Purch Doc. Subtype Code");

    //         lrc_LanguageTranslation2.SETRANGE("Line Type", vrc_SalesVATEvaluation."Line Type");
    //         lrc_LanguageTranslation2.SETRANGE("Line Code", vrc_SalesVATEvaluation."Line No.");
    //         lrc_LanguageTranslation2.SETRANGE("Language Code", LanguageCode);

    //         IF lrc_LanguageTranslation2.FIND('-') THEN BEGIN
    //             IF (lrc_LanguageTranslation2."Additional Inv. Text 1" <> '') OR
    //                (lrc_LanguageTranslation2."Additional Inv. Text 2" <> '') OR
    //                (lrc_LanguageTranslation2."Additional Inv. Text 3" <> '') OR
    //                (lrc_LanguageTranslation2."Additional Inv. Text 4" <> '') THEN BEGIN
    //                 rtx_ArrAddText[1] := lrc_LanguageTranslation2."Additional Inv. Text 1";
    //                 rtx_ArrAddText[2] := lrc_LanguageTranslation2."Additional Inv. Text 2";
    //                 rtx_ArrAddText[3] := lrc_LanguageTranslation2."Additional Inv. Text 3";
    //                 rtx_ArrAddText[4] := lrc_LanguageTranslation2."Additional Inv. Text 4";
    //             END;
    //         END;
    //     end;

    //     procedure "-- CUSTOMER --"()
    //     begin
    //     end;

    //     procedure ChangeVATRegNoInAllDoc(vco_CustomerNo: Code[20])
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_SalesShipmentHeader: Record "110";
    //         lrc_SalesInvoiceHeader: Record "112";
    //         lrc_SalesCrMemoHeader: Record "114";
    //         AGILES_LT_TEX001: Label 'Möchten Sie die Umst.-ID in allen Belegen ändern?';
    //         lrc_GenJournalLine: Record "81";
    //         lrc_SalesHeader: Record "36";
    //         lrc_ReminderHeader: Record "295";
    //         lrc_IssRemiderHeader: Record "297";
    //         lrc_SalesHeaderArchive: Record "5107";
    //         lrc_InboundSalesDocHeader: Record "99008500";
    //         lrc_OutboundSalesDocHeader: Record "99008506";
    //         lrc_VatEntry: Record "254";
    //         ldg_Window: Dialog;
    //         lin_TotalLoops: Integer;
    //         lin_Loop: Integer;
    //     begin
    //         // -----------------------------------------------------------------------------------
    //         // Funktion zum Ändern der Umsatzsteuer ID in allen Belegen
    //         // -----------------------------------------------------------------------------------

    //         lrc_Customer.GET(vco_CustomerNo);


    //         lin_TotalLoops := 11;
    //         lin_Loop := 0;

    //         ldg_Window.OPEN('Verarbeite Daten: @1@@@@@@@');

    //         // Möchten Sie die Umst.-ID in allen Belegen ändern?
    //         IF CONFIRM(AGILES_LT_TEX001) THEN BEGIN
    //             lrc_SalesShipmentHeader.SETRANGE("Bill-to Customer No.", lrc_Customer."No.");
    //             IF lrc_SalesShipmentHeader.FIND('-') THEN
    //                 REPEAT
    //                     lrc_SalesShipmentHeader."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_SalesShipmentHeader.MODIFY();
    //                 UNTIL lrc_SalesShipmentHeader.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_SalesInvoiceHeader.SETRANGE("Bill-to Customer No.", lrc_Customer."No.");
    //             IF lrc_SalesInvoiceHeader.FIND('-') THEN
    //                 REPEAT
    //                     lrc_SalesInvoiceHeader."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_SalesInvoiceHeader.MODIFY();
    //                 UNTIL lrc_SalesInvoiceHeader.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_SalesCrMemoHeader.SETRANGE("Bill-to Customer No.", lrc_Customer."No.");
    //             IF lrc_SalesCrMemoHeader.FIND('-') THEN
    //                 REPEAT
    //                     lrc_SalesCrMemoHeader."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_SalesCrMemoHeader.MODIFY();
    //                 UNTIL lrc_SalesCrMemoHeader.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             //FV4 KHH50030.s WZI Erweiterung um zusätzliche Tabellen
    //             lrc_GenJournalLine.SETRANGE("Account Type", lrc_GenJournalLine."Account Type"::Customer);
    //             lrc_GenJournalLine.SETRANGE("Account No.", lrc_Customer."No.");
    //             IF lrc_GenJournalLine.FIND('-') THEN BEGIN
    //                 REPEAT
    //                     lrc_GenJournalLine."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_GenJournalLine.MODIFY();
    //                 UNTIL lrc_GenJournalLine.NEXT(1) = 0;
    //             END;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_SalesHeader.SETRANGE("Bill-to Customer No.", lrc_Customer."No.");
    //             IF lrc_SalesHeader.FIND('-') THEN
    //                 REPEAT
    //                     lrc_SalesHeader."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_SalesHeader.MODIFY();
    //                 UNTIL lrc_SalesHeader.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_ReminderHeader.SETRANGE("Customer No.", lrc_Customer."No.");
    //             IF lrc_ReminderHeader.FIND('-') THEN
    //                 REPEAT
    //                     lrc_ReminderHeader."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_ReminderHeader.MODIFY();
    //                 UNTIL lrc_ReminderHeader.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_IssRemiderHeader.SETRANGE("Customer No.", lrc_Customer."No.");
    //             IF lrc_IssRemiderHeader.FIND('-') THEN
    //                 REPEAT
    //                     lrc_IssRemiderHeader."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_IssRemiderHeader.MODIFY();
    //                 UNTIL lrc_IssRemiderHeader.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_SalesHeaderArchive.SETRANGE("Bill-to Customer No.", lrc_Customer."No.");
    //             IF lrc_SalesHeaderArchive.FIND('-') THEN
    //                 REPEAT
    //                     lrc_SalesHeaderArchive."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_SalesHeaderArchive.MODIFY();
    //                 UNTIL lrc_SalesHeaderArchive.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_InboundSalesDocHeader.SETRANGE("Bill-to Customer No.", lrc_Customer."No.");
    //             IF lrc_InboundSalesDocHeader.FIND('-') THEN
    //                 REPEAT
    //                     lrc_InboundSalesDocHeader."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_InboundSalesDocHeader.MODIFY();
    //                 UNTIL lrc_InboundSalesDocHeader.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_OutboundSalesDocHeader.SETRANGE("Bill-to Customer No.", lrc_Customer."No.");
    //             IF lrc_OutboundSalesDocHeader.FIND('-') THEN
    //                 REPEAT
    //                     lrc_OutboundSalesDocHeader."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_OutboundSalesDocHeader.MODIFY();
    //                 UNTIL lrc_OutboundSalesDocHeader.NEXT() = 0;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             lrc_VatEntry.SETCURRENTKEY("Bill-to/Pay-to No.", "EU 3-Party Trade", Type, "Posting Date");
    //             lrc_VatEntry.SETRANGE("Bill-to/Pay-to No.", lrc_Customer."No.");
    //             IF lrc_VatEntry.FIND('-') THEN BEGIN
    //                 REPEAT
    //                     lrc_VatEntry."VAT Registration No." := lrc_Customer."VAT Registration No.";
    //                     lrc_VatEntry.MODIFY();
    //                 UNTIL lrc_VatEntry.NEXT(1) = 0;
    //             END;

    //             lin_Loop := lin_Loop + 1;
    //             ldg_Window.UPDATE(1, ROUND(lin_Loop / lin_TotalLoops * 10000, 1));

    //             //FV4 KHH50030.e
    //         END;

    //         ldg_Window.CLOSE();
    //     end;

    //     procedure "-- LEERGUT VAT --"()
    //     begin
    //     end;

    //     procedure SalesCheckVATForEmptYItem(vrc_SalesHeader: Record "36")
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_SalesLine: Record "37";
    //     begin
    //         // -------------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen abweichender MwSt. Buchungsgruppe bei Leergut im Verkauf
    //         // -------------------------------------------------------------------------------------------------

    //         IF NOT lrc_Customer.GET(vrc_SalesHeader."Sell-to Customer No.") THEN
    //             EXIT;

    //         IF (lrc_Customer."POI Empties Fld VAT Prod. Grp." = '') AND
    //            (lrc_Customer."POI Empt Empty VAT Prod. Grp." = '') THEN
    //             EXIT;

    //         lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //         lrc_SalesLine.SETRANGE(Type, lrc_SalesLine.Type::Item);
    //         lrc_SalesLine.SETRANGE("Item Typ", lrc_SalesLine."Item Typ"::"Empties Item");
    //         IF lrc_SalesLine.FIND('-') THEN BEGIN
    //             REPEAT
    //                 IF lrc_SalesLine."Attached to Line No." <> 0 THEN BEGIN
    //                     IF lrc_Customer."POI Empties Fld VAT Prod. Grp." <> '' THEN BEGIN
    //                         lrc_SalesLine.VALIDATE("VAT Prod. Posting Group", lrc_Customer."POI Empties Fld VAT Prod. Grp.");
    //                         lrc_SalesLine.MODIFY();
    //                     END;
    //                 END ELSE BEGIN
    //                     IF lrc_Customer."POI Empt Empty VAT Prod. Grp." <> '' THEN BEGIN
    //                         lrc_SalesLine.VALIDATE("VAT Prod. Posting Group", lrc_Customer."POI Empt Empty VAT Prod. Grp.");
    //                         lrc_SalesLine.MODIFY();
    //                     END;
    //                 END;
    //             UNTIL lrc_SalesLine.NEXT() = 0;
    //         END;
    //     end;

    procedure PurchaseCheckVATForEmptYItem(vrc_PurchaseHeader: Record "Purchase Header")
    var
        lrc_Vendor: Record Vendor;
    begin
        // -------------------------------------------------------------------------------------------------
        // Funktion zum Setzen abweichender MwSt. Buchungsgruppe bei Leergut im Einkauf
        // -------------------------------------------------------------------------------------------------

        IF NOT lrc_Vendor.GET(vrc_PurchaseHeader."Buy-from Vendor No.") THEN
            EXIT;

        IF (lrc_Vendor."POI Empties Fld VAT Prod. Grp." = '') AND
           (lrc_Vendor."POI Empt Empty VAT Prod. Grp." = '') THEN
            EXIT;
        lrc_PurchaseLine.Reset();
        lrc_PurchaseLine.SETRANGE("Document Type", vrc_PurchaseHeader."Document Type");
        lrc_PurchaseLine.SETRANGE("Document No.", vrc_PurchaseHeader."No.");
        lrc_PurchaseLine.SETRANGE(Type, lrc_PurchaseLine.Type::Item);
        lrc_PurchaseLine.SETRANGE("POI Item Typ", lrc_PurchaseLine."POI Item Typ"::"Empties Item");
        IF lrc_PurchaseLine.FIND('-') THEN
            REPEAT
                IF lrc_PurchaseLine."Attached to Line No." <> 0 THEN
                    IF lrc_Vendor."POI Empties Fld VAT Prod. Grp." <> '' THEN BEGIN
                        lrc_PurchaseLine.VALIDATE("VAT Prod. Posting Group", lrc_Vendor."POI Empties Fld VAT Prod. Grp.");
                        lrc_PurchaseLine.MODIFY();
                    END
                    ELSE
                        IF lrc_Vendor."POI Empt Empty VAT Prod. Grp." <> '' THEN BEGIN
                            lrc_PurchaseLine.VALIDATE("VAT Prod. Posting Group", lrc_Vendor."POI Empt Empty VAT Prod. Grp.");
                            lrc_PurchaseLine.MODIFY();
                        END;

            UNTIL lrc_PurchaseLine.NEXT() = 0;
    end;

    //     procedure TransferVATEvaluationGet(var "vrc_Transfer Header": Record "5740"; var "vrc_Transfer Line": Record "5741"; var vrc_SalesVATEvaluation: Record "5087926"): Boolean
    //     var
    //         lrc_LocationFrom: Record "14";
    //         lrc_LocationTo: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_VATRegistrationNo: Record "50022";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         //
    //         // Funktion zur Ermittlung der steuerlichen Kontierung
    //         // ------------------------------------------------------------------------------------------------
    //         // vrc_Transfer Receipt Header
    //         // vrc_Transfer Receipt Line
    //         // ------------------------------------------------------------------------------------------------

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         grc_CompanyInformation.GET();
    //         CompCountry := grc_CompanyInformation."Country/Region Code";

    //         //lrc_Vendor.GET(vrc_PurchaseHeader."Buy-from Vendor No.");
    //         lrc_LocationFrom.GET("vrc_Transfer Header"."Transfer-from Code");
    //         lrc_LocationTo.GET("vrc_Transfer Header"."Transfer-to Code");

    //         vrc_SalesVATEvaluation.Reset();
    //         //Herkunft~~~~~~~~~~~~~~~~~~~~~~
    //         vrc_SalesVATEvaluation.SETRANGE(Source, vrc_SalesVATEvaluation.Source::Transfer);

    //         //Verkauf/Einkauf Belegart~~~~~~~
    //         //lrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Type",'%1|%2',lrc_SalesVATEvaluation."Sales/Purch Doc. Type"::Order,
    //         //                                                            lrc_SalesVATEvaluation."Sales/Purch Doc. Type"::" ");
    //         //Verkauf/einkauf Belegunterart Code~~~~~~~~
    //         //lrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Subtype Code",'%1|%2',vrc_PurchaseHeader."Purch. Doc. Subtype Code",'');


    //         //VAT 012 port     JST 250413     Zeilenfilter Unterscheidung Item und ItemCharge und G/L Account
    //         // Eingrenzung auf Artikel, Sachkonto und VVE bzw G/L Account
    //         //CASE vrc_SalesLine.Type OF
    //         //vrc_SalesLine.Type::Item :
    //         //  lrc_SalesVATEvaluation.SETRANGE("Line Type",lrc_SalesVATEvaluation."Line Type"::Item);
    //         //vrc_SalesLine.Type::"G/L Account" :
    //         //  BEGIN
    //         //    IF vrc_SalesLine.Subtyp = vrc_SalesLine.Subtyp::Discount THEN
    //         //      lrc_SalesVATEvaluation.SETRANGE("Line Type",lrc_SalesVATEvaluation."Line Type"::"Subtype VVE")
    //         //    ELSE
    //         //      lrc_SalesVATEvaluation.SETRANGE("Line Type",lrc_SalesVATEvaluation."Line Type"::"G/L Account");
    //         //  END;
    //         //vrc_SalesLine.Type::"Charge (Item)":
    //         //  BEGIN
    //         //    lrc_SalesVATEvaluation.SETRANGE("Line Type",lrc_SalesVATEvaluation."Line Type"::"Item Charge");
    //         //  END;
    //         //ELSE
    //         //  EXIT(FALSE);
    //         //END;
    //         //SalesVATEvaluationFilter:= lrc_SalesVATEvaluation.GETFILTER("Line Type");

    //         // Debitorenbuchungsgruppe
    //         //lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group",'%1|%2',vrc_PurchaseHeader."Vendor Posting Group",'');

    //         // Land Kunde
    //         //IF vrc_PurchaseHeader."Buy-from Country/Region Code" = '' THEN
    //         //  lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code",'%1|%2','*DE*','')
    //         //ELSE
    //         //lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code",'%1|%2','*'+vrc_PurchaseHeader."Buy-from Country/Region Code"+'*','');

    //         //VAT 005 port     JST 280213     Filtersetzung mit * für Mehrfachnennung bei nachfolgenden SetFilter

    //         // Abgangsland
    //         IF lrc_LocationFrom."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lrc_LocationFrom."Country/Region Code" + '*', '');

    //         //NICHT Abgangsland
    //         IF lrc_LocationFrom."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lrc_LocationFrom."Country/Region Code" + '*');

    //         //Zusatz-Registrierung im Abgangsland
    //         //VAT 009 port     JST 200313     Neues Feld "VAT-Reg Departure Country Code" als Option keine, direkt oder Fiscal
    //         //ForeignVatPlace
    //         //if lrc_Location."Country/Region Code" = 'NL' then begin
    //         //lrc_VATRegistrationNo.SETRANGE("Vendor/Customer",vrc_SalesHeader."Sell-to Customer No.");
    //         //IF lrc_Location."Country/Region Code" = '' THEN
    //         //  lrc_VATRegistrationNo.SETFILTER("Country Code",'%1|%2','DE','')
    //         //ELSE
    //         //  lrc_VATRegistrationNo.SETRANGE("Country Code",lrc_Location."Country/Region Code");
    //         //IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //         // IF lrc_VATRegistrationNo."VAT Detection" THEN BEGIN
    //         //   lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code",lrc_VATRegistrationNo."Registration Typ")
    //         // END ELSE BEGIN
    //         //   lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code",lrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         // END;
    //         //END ELSE BEGIN
    //         //  lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code",lrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         //END;
    //         //SalesVATEvaluationFilter:=lrc_SalesVATEvaluation.GETFILTER("VAT-Reg Departure Country Code");
    //         //END;

    //         // VAT 003 ADÜ40071.s
    //         // Abgangslager
    //         vrc_SalesVATEvaluation.SETFILTER("Departure Location Code", '%1|%2', lrc_LocationFrom.Code, '');
    //         // VAT 003 ADÜ40071.e

    //         //VAT 011 port     JST 250413     Neues Feld Not Departure Location Code
    //         //NICHT Abgangslager
    //         IF lrc_LocationFrom.Code <> '' THEN
    //             //mly 140310
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code", filt_start + lrc_LocationFrom.Code + filt_end);


    //         //VAT 016 port     JST 060613     Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
    //         //Fiscalvertreter
    //         vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_LocationFrom."Fiscal Agent Code", '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         //Not Fiscalvertreter
    //         //mly
    //         IF lrc_LocationFrom."Fiscal Agent Code" <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + lrc_LocationFrom."Fiscal Agent Code" + '*');

    //         // Lieferbedingung
    //         IF "vrc_Transfer Header"."Shipment Method Code" <> '' THEN BEGIN
    //             lrc_ShipmentMethod.GET("vrc_Transfer Header"."Shipment Method Code");
    //             IF lrc_ShipmentMethod."Self-Collector" THEN BEGIN
    //                 vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Selbstabholer);
    //             END ELSE BEGIN
    //                 vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Franco);
    //             END;
    //         END ELSE BEGIN
    //             //Lieferbedingung leer -> wir nehmen an dann Selbstabholer also "wir"
    //             vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Selbstabholer);
    //         END;

    //         //Zugangsland
    //         IF lrc_LocationTo."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + lrc_LocationTo."Country/Region Code" + '*', '');
    //         //VAT 002 port     JST 080812     Neues Feld 50002Not Arrival Country Code in Filtersetzung einarbeiten
    //         //NICHT Zugangsland
    //         IF lrc_LocationTo."Country/Region Code" <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + lrc_LocationTo."Country/Region Code" + '*');

    //         //VAT 001 port     JST 240512     Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         //Lieferbedinungscode
    //         vrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', lrc_ShipmentMethod.Code, '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung
    //         //Not Lieferbedingungscode
    //         //mly
    //         IF lrc_ShipmentMethod.Code <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + lrc_ShipmentMethod.Code + '*');

    //         // Status Zoll
    //         IF "vrc_Transfer Header"."Shipment Method Code" <> '' THEN BEGIN
    //             IF lrc_ShipmentMethod."Duty Paid" = TRUE THEN BEGIN
    //                 vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                                vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //             END ELSE BEGIN
    //                 vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //                                                                               vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //             END;
    //         END ELSE BEGIN
    //             vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                            vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         END;

    //         // Gültigkeit ab prüfen
    //         vrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', "vrc_Transfer Header"."Posting Date");

    //         // Gültigkeit bis prüfen mly140625
    //         vrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', "vrc_Transfer Header"."Posting Date", 0D);

    //         // VAT Satz suchen
    //         IF vrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF vrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure TransferPostedVATEvaluationGet(var "vrc_Transfer Receipt Header": Record "5746"; var "vrc_Transfer Receipt Line": Record "5747"; var vrc_SalesVATEvaluation: Record "5087926"): Boolean
    //     var
    //         lrc_LocationFrom: Record "14";
    //         lrc_LocationTo: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_VATRegistrationNo: Record "50022";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         //
    //         // Funktion zur Ermittlung der steuerlichen Kontierung
    //         // ------------------------------------------------------------------------------------------------
    //         // vrc_Transfer Receipt Header
    //         // vrc_Transfer Receipt Line
    //         // ------------------------------------------------------------------------------------------------

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         grc_CompanyInformation.GET();
    //         CompCountry := grc_CompanyInformation."Country/Region Code";

    //         //lrc_Vendor.GET(vrc_PurchaseHeader."Buy-from Vendor No.");
    //         lrc_LocationFrom.GET("vrc_Transfer Receipt Header"."Transfer-from Code");
    //         lrc_LocationTo.GET("vrc_Transfer Receipt Header"."Transfer-to Code");

    //         vrc_SalesVATEvaluation.Reset();
    //         //Herkunft~~~~~~~~~~~~~~~~~~~~~~
    //         vrc_SalesVATEvaluation.SETRANGE(Source, vrc_SalesVATEvaluation.Source::Transfer);

    //         //Verkauf/Einkauf Belegart~~~~~~~
    //         //lrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Type",'%1|%2',lrc_SalesVATEvaluation."Sales/Purch Doc. Type"::Order,
    //         //                                                            lrc_SalesVATEvaluation."Sales/Purch Doc. Type"::" ");
    //         //Verkauf/einkauf Belegunterart Code~~~~~~~~
    //         //lrc_SalesVATEvaluation.SETFILTER("Sales/Purch Doc. Subtype Code",'%1|%2',vrc_PurchaseHeader."Purch. Doc. Subtype Code",'');

    //         //VAT 012 port     JST 250413     Zeilenfilter Unterscheidung Item und ItemCharge und G/L Account
    //         // Eingrenzung auf Artikel, Sachkonto und VVE bzw G/L Account
    //         //CASE vrc_SalesLine.Type OF
    //         //vrc_SalesLine.Type::Item :
    //         //  lrc_SalesVATEvaluation.SETRANGE("Line Type",lrc_SalesVATEvaluation."Line Type"::Item);
    //         //vrc_SalesLine.Type::"G/L Account" :
    //         //  BEGIN
    //         //    IF vrc_SalesLine.Subtyp = vrc_SalesLine.Subtyp::Discount THEN
    //         //      lrc_SalesVATEvaluation.SETRANGE("Line Type",lrc_SalesVATEvaluation."Line Type"::"Subtype VVE")
    //         //    ELSE
    //         //      lrc_SalesVATEvaluation.SETRANGE("Line Type",lrc_SalesVATEvaluation."Line Type"::"G/L Account");
    //         //  END;
    //         //vrc_SalesLine.Type::"Charge (Item)":
    //         //  BEGIN
    //         //    lrc_SalesVATEvaluation.SETRANGE("Line Type",lrc_SalesVATEvaluation."Line Type"::"Item Charge");
    //         //  END;
    //         //ELSE
    //         //  EXIT(FALSE);
    //         //END;
    //         //SalesVATEvaluationFilter:= lrc_SalesVATEvaluation.GETFILTER("Line Type");

    //         // Debitorenbuchungsgruppe
    //         //lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Posting Group",'%1|%2',vrc_PurchaseHeader."Vendor Posting Group",'');

    //         // Land Kunde
    //         //IF vrc_PurchaseHeader."Buy-from Country/Region Code" = '' THEN
    //         //  lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code",'%1|%2','*DE*','')
    //         //ELSE
    //         //lrc_SalesVATEvaluation.SETFILTER("Cust/Vend Country Code",'%1|%2','*'+vrc_PurchaseHeader."Buy-from Country/Region Code"+'*','');

    //         //VAT 005 port     JST 280213     Filtersetzung mit * für Mehrfachnennung bei nachfolgenden SetFilter

    //         // Abgangsland
    //         IF lrc_LocationFrom."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lrc_LocationFrom."Country/Region Code" + '*', '');
    //         //VAT 007 port     JST 280213     Neue Feld in Filtersetzung einarbeiten

    //         //NICHT Abgangsland
    //         IF lrc_LocationFrom."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lrc_LocationFrom."Country/Region Code" + '*');

    //         //Zusatz-Registrierung im Abgangsland
    //         //VAT 009 port     JST 200313     Neues Feld "VAT-Reg Departure Country Code" als Option keine, direkt oder Fiscal
    //         //ForeignVatPlace
    //         //if lrc_Location."Country/Region Code" = 'NL' then begin
    //         //lrc_VATRegistrationNo.SETRANGE("Vendor/Customer",vrc_SalesHeader."Sell-to Customer No.");
    //         //IF lrc_Location."Country/Region Code" = '' THEN
    //         //  lrc_VATRegistrationNo.SETFILTER("Country Code",'%1|%2','DE','')
    //         //ELSE
    //         //  lrc_VATRegistrationNo.SETRANGE("Country Code",lrc_Location."Country/Region Code");
    //         //IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //         // IF lrc_VATRegistrationNo."VAT Detection" THEN BEGIN
    //         //   lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code",lrc_VATRegistrationNo."Registration Typ")
    //         // END ELSE BEGIN
    //         //   lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code",lrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         // END;
    //         //END ELSE BEGIN
    //         //  lrc_SalesVATEvaluation.SETRANGE("VAT-Reg Departure Country Code",lrc_SalesVATEvaluation."VAT-Reg Departure Country Code"::No);
    //         //END;
    //         //SalesVATEvaluationFilter:=lrc_SalesVATEvaluation.GETFILTER("VAT-Reg Departure Country Code");
    //         //END;

    //         // VAT 003 ADÜ40071.s
    //         // Abgangslager
    //         vrc_SalesVATEvaluation.SETFILTER("Departure Location Code", '%1|%2', lrc_LocationFrom.Code, '');
    //         // VAT 003 ADÜ40071.e

    //         //VAT 011 port     JST 250413     Neues Feld Not Departure Location Code
    //         //NICHT Abgangslager
    //         IF lrc_LocationFrom.Code <> '' THEN
    //             //mly 140310
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code", filt_start + lrc_LocationFrom.Code + filt_end);


    //         //VAT 016 port     JST 060613     Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
    //         //Fiscalvertreter
    //         vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_LocationFrom."Fiscal Agent Code", '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         //Not Fiscalvertreter
    //         //mly
    //         IF lrc_LocationFrom."Fiscal Agent Code" <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + lrc_LocationFrom."Fiscal Agent Code" + '*');

    //         // Lieferbedingung
    //         IF "vrc_Transfer Receipt Header"."Shipment Method Code" <> '' THEN BEGIN
    //             lrc_ShipmentMethod.GET("vrc_Transfer Receipt Header"."Shipment Method Code");
    //             IF lrc_ShipmentMethod."Self-Collector" THEN BEGIN
    //                 vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Selbstabholer);
    //             END ELSE BEGIN
    //                 vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Franco);
    //             END;
    //         END ELSE BEGIN
    //             //Lieferbedingung leer -> wir nehmen an dann Selbstabholer also "wir"
    //             vrc_SalesVATEvaluation.SETRANGE("Shipment Type", vrc_SalesVATEvaluation."Shipment Type"::Selbstabholer);
    //         END;

    //         //Zugangsland
    //         IF lrc_LocationTo."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + lrc_LocationTo."Country/Region Code" + '*', '');
    //         //VAT 002 port     JST 080812     Neues Feld 50002Not Arrival Country Code in Filtersetzung einarbeiten
    //         //NICHT Zugangsland
    //         IF lrc_LocationTo."Country/Region Code" <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + lrc_LocationTo."Country/Region Code" + '*');


    //         //VAT 001 port     JST 240512     Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         //Lieferbedinungscode
    //         vrc_SalesVATEvaluation.SETFILTER("Shipment Method Code", '%1|%2', lrc_ShipmentMethod.Code, '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung
    //         //Not Lieferbedingungscode
    //         //mly
    //         IF lrc_ShipmentMethod.Code <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code", '<>*' + lrc_ShipmentMethod.Code + '*');

    //         // Status Zoll
    //         IF "vrc_Transfer Receipt Header"."Shipment Method Code" <> '' THEN BEGIN
    //             IF lrc_ShipmentMethod."Duty Paid" = TRUE THEN BEGIN
    //                 vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                                vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //             END ELSE BEGIN
    //                 vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //                                                                               vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //             END;
    //         END ELSE BEGIN
    //             vrc_SalesVATEvaluation.SETFILTER("State Customer Duty", '%1|%2', vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //                                                                        vrc_SalesVATEvaluation."State Customer Duty"::" ")
    //         END;

    //         // Gültigkeit ab prüfen
    //         vrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', "vrc_Transfer Receipt Header"."Posting Date");

    //         // Gültigkeit bis prüfen mly140625
    //         vrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', "vrc_Transfer Receipt Header"."Posting Date", 0D);

    //         // VAT Satz suchen
    //         IF vrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF vrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure TransferGetAdditionalText(var "vrc_Transfer Header": Record "5740"; var "vrc_Transfer Line": Record "5741"; var rtx_ArrAddText: array[4] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         ConditionNo := 0;
    //         IF TransferVATEvaluationGet("vrc_Transfer Header", "vrc_Transfer Line", lrc_SalesVATEvaluation) THEN BEGIN
    //             ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //             //Array Füllen
    //             //rtx_ArrAddText[1]:=
    //             CLEAR(rtx_ArrAddText);
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //                 rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //                 rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //                 rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";
    //                 //TranslateAdditionalText(lrc_SalesVATEvaluation,"vrc_Transfer Header"."Language Code",rtx_ArrAddText);
    //             END;
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure TransferPostGetAdditionalText(var "vrc_Transfer Receipt Header": Record "5746"; var "vrc_Transfer Receipt Line": Record "5747"; var rtx_ArrAddText: array[4] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         ConditionNo := 0;
    //         IF TransferPostedVATEvaluationGet("vrc_Transfer Receipt Header", "vrc_Transfer Receipt Line", lrc_SalesVATEvaluation) THEN BEGIN
    //             ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //             //Array Füllen
    //             CLEAR(rtx_ArrAddText);
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //                 rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //                 rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //                 rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";
    //                 //TranslateAdditionalText(lrc_SalesVATEvaluation,"vrc_Transfer Header"."Language Code",rtx_ArrAddText);
    //             END;
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure TransferGetFiscalAgent(var "vrc_Transfer Header": Record "5740"; var "vrc_Transfer Line": Record "5741"; var rtx_ArrFiscalAgentText: array[9] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_Location: Record "14";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         CLEAR(rtx_ArrFiscalAgentText);
    //         IF TransferVATEvaluationGet("vrc_Transfer Header", "vrc_Transfer Line", lrc_SalesVATEvaluation) THEN BEGIN
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                     EXIT;
    //                 IF NOT lrc_FiscalAgent.GET(lrc_SalesVATEvaluation."Fiscal Agent") THEN
    //                     EXIT;
    //                 rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //                 rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //                 rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                    lrc_FiscalAgent."Post Code",
    //                                                                    lrc_FiscalAgent.City);
    //                 rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");
    //                 // Übersetzung der Fiskalvertretertexte holen
    //                 lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //                 lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //                 //lrc_LanguageTranslation.SETRANGE("Language Code", vrc_PurchaseHeader."Language Code");
    //                 IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                     rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //                 END ELSE BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                     rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //                 END;
    //                 EXIT(TRUE);
    //             END ELSE BEGIN
    //                 EXIT(FALSE);
    //             END;
    //         END;
    //     end;

    //     procedure TransferPostGetFiscalAgent(var "vrc_Transfer Receipt Header": Record "5746"; var "vrc_Transfer Receipt Line": Record "5747"; var rtx_ArrFiscalAgentText: array[10] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_Location: Record "14";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         CLEAR(rtx_ArrFiscalAgentText);
    //         IF TransferPostedVATEvaluationGet("vrc_Transfer Receipt Header", "vrc_Transfer Receipt Line", lrc_SalesVATEvaluation) THEN BEGIN
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                     EXIT;
    //                 IF NOT lrc_FiscalAgent.GET(lrc_SalesVATEvaluation."Fiscal Agent") THEN
    //                     EXIT;
    //                 rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //                 rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //                 rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                    lrc_FiscalAgent."Post Code",
    //                                                                    lrc_FiscalAgent.City);
    //                 rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");
    //                 // Übersetzung der Fiskalvertretertexte holen
    //                 lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //                 lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //                 //lrc_LanguageTranslation.SETRANGE("Language Code", vrc_PurchaseHeader."Language Code");
    //                 IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                     rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //                 END ELSE BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                     rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //                 END;
    //                 EXIT(TRUE);
    //             END ELSE BEGIN
    //                 EXIT(FALSE);
    //             END;
    //         END;
    //     end;

    //     procedure "-- POI Pack"()
    //     begin
    //     end;

    //     procedure PackVATEvaluationGet(var vrc_PackHeader: Record "5110712"; var vrc_PackLineInput: Record "5110714"; var vrc_SalesVATEvaluation: Record "5087926"): Boolean
    //     var
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         lrc_LocationFrom: Record "14";
    //         lrc_LocationTo: Record "14";
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_VATRegistrationNo: Record "50022";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         //
    //         // Funktion zur Ermittlung der steuerlichen Kontierung
    //         // ------------------------------------------------------------------------------------------------
    //         // vrc_Transfer Receipt Header
    //         // vrc_Transfer Receipt Line
    //         // ------------------------------------------------------------------------------------------------

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         grc_CompanyInformation.GET();
    //         CompCountry := grc_CompanyInformation."Country/Region Code";

    //         //lrc_Vendor.GET(vrc_PurchaseHeader."Buy-from Vendor No.");
    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.", vrc_PackHeader."No.");
    //         IF NOT lrc_PackOrderOutputItems.FINDSET() THEN EXIT(FALSE);

    //         IF NOT lrc_LocationFrom.GET(vrc_PackLineInput."Location Code") THEN EXIT(FALSE);
    //         IF NOT lrc_LocationTo.GET(lrc_PackOrderOutputItems."Location Code") THEN EXIT(FALSE);

    //         vrc_SalesVATEvaluation.Reset();
    //         //Herkunft~~~~~~~~~~~~~~~~~~~~~~
    //         vrc_SalesVATEvaluation.SETRANGE(Source, vrc_SalesVATEvaluation.Source::Transfer);

    //         // Abgangsland
    //         IF lrc_LocationFrom."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Departure Country Code", '%1|%2', '*' + lrc_LocationFrom."Country/Region Code" + '*', '');

    //         //VAT 007 port     JST 280213     Neue Feld in Filtersetzung einarbeiten
    //         //NICHT Abgangsland
    //         IF lrc_LocationFrom."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + CompCountry + '*')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Country Code", '<>*' + lrc_LocationFrom."Country/Region Code" + '*');

    //         // VAT 003 ADÜ40071.s
    //         // Abgangslager
    //         vrc_SalesVATEvaluation.SETFILTER("Departure Location Code", '%1|%2', lrc_LocationFrom.Code, '');
    //         // VAT 003 ADÜ40071.e

    //         //VAT 011 port     JST 250413     Neues Feld Not Departure Location Code
    //         //NICHT Abgangslager
    //         IF lrc_LocationFrom.Code <> '' THEN
    //             //mly 140310
    //             vrc_SalesVATEvaluation.SETFILTER("Not Departure Location Code", filt_start + lrc_LocationFrom.Code + filt_end);


    //         //VAT 016 port     JST 060613     Fiscalvertreter als Bedingung vom im VK Abgangslager im EK Zugangslager
    //         //Fiscalvertreter
    //         vrc_SalesVATEvaluation.SETFILTER("Fiscal Agent", '%1|%2', lrc_LocationFrom."Fiscal Agent Code", '');

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung, Not Fiscalvertreter
    //         //Not Fiscalvertreter
    //         //mly
    //         IF lrc_LocationFrom."Fiscal Agent Code" <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Fiscal Agent", '<>*' + lrc_LocationFrom."Fiscal Agent Code" + '*');

    //         // Lieferbedingung
    //         //IF "vrc_Transfer Header"."Shipment Method Code" <> ''THEN BEGIN
    //         //  lrc_ShipmentMethod.GET("vrc_Transfer Header"."Shipment Method Code");
    //         //  IF lrc_ShipmentMethod."Self-Collector" THEN BEGIN
    //         //    vrc_SalesVATEvaluation.SETRANGE("Shipment Type",vrc_SalesVATEvaluation."Shipment Type"::Selbstabholer);
    //         //  END ELSE BEGIN
    //         //    vrc_SalesVATEvaluation.SETRANGE("Shipment Type",vrc_SalesVATEvaluation."Shipment Type"::Franco);
    //         //  END;
    //         //END ELSE BEGIN
    //         //Lieferbedingung leer -> unbekannt, keine Filterung
    //         //END;
    //         //SalesVATEvaluationFilter:=vrc_SalesVATEvaluation.GETFILTER("Shipment Type");

    //         //VAT 024 port     JST 280813     LocationTo bei Packauftrag und Transfer/Umlagerung eingebaut,fehlte bisher.Location mit '*'
    //         //Zugangslagerort  wo geht Ware hin (Port-Lager)
    //         vrc_SalesVATEvaluation.SETFILTER("Arrival Location Code", '%1|%2', '' + lrc_LocationTo.Code + '', '');
    //         //NIcht Zugangslagerort
    //         IF lrc_LocationTo.Code <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Arrival Location Code", '<>*' + lrc_LocationTo.Code + '*');

    //         //Zugangsland
    //         IF lrc_LocationTo."Country/Region Code" = '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + CompCountry + '*', '')
    //         ELSE
    //             vrc_SalesVATEvaluation.SETFILTER("Arrival Country Code", '%1|%2', '*' + lrc_LocationTo."Country/Region Code" + '*', '');
    //         //VAT 002 port     JST 080812     Neues Feld 50002Not Arrival Country Code in Filtersetzung einarbeiten
    //         //NICHT Zugangsland
    //         IF lrc_LocationTo."Country/Region Code" <> '' THEN
    //             vrc_SalesVATEvaluation.SETFILTER("Not Arrival Country Code", '<>*' + lrc_LocationTo."Country/Region Code" + '*');

    //         //VAT 001 port     JST 240512     Neues Feld 50001 Lieferbedingungscode in Filtersetzung einarbeiten
    //         //Lieferbedinungscode
    //         //vrc_SalesVATEvaluation.SETFILTER("Shipment Method Code",'%1|%2',lrc_ShipmentMethod.Code,'');
    //         //SalesVATEvaluationFilter:=vrc_SalesVATEvaluation.GETFILTER("Shipment Method Code");

    //         //VAT 018 port     JST 140613     Neues Feld Not Lieferbedinung
    //         //Not Lieferbedingungscode
    //         //lrc_SalesVATEvaluation.SETFILTER("Not Shipment Method Code",'<>%1|%2','*'+vrc_SalesHeader."Shipment Method Code"+'*','');
    //         //SalesVATEvaluationFilter:= lrc_SalesVATEvaluation.GETFILTER("Not Shipment Method Code");

    //         // Status Zoll
    //         //IF lrc_ShipmentMethod."Duty Paid" = TRUE THEN BEGIN
    //         //  vrc_SalesVATEvaluation.SETFILTER("State Customer Duty",'%1|%2',vrc_SalesVATEvaluation."State Customer Duty"::"Duty Paid",
    //         //                                                                 vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         //END ELSE BEGIN
    //         //  vrc_SalesVATEvaluation.SETFILTER("State Customer Duty",'%1|%2',vrc_SalesVATEvaluation."State Customer Duty"::"Duty unpaid",
    //         //                                                                vrc_SalesVATEvaluation."State Customer Duty"::" ");
    //         //END;
    //         //SalesVATEvaluationFilter:=vrc_SalesVATEvaluation.GETFILTER("State Customer Duty");

    //         // Gültigkeit ab prüfen
    //         vrc_SalesVATEvaluation.SETFILTER("Valid From", '<=%1', vrc_PackHeader."Posting Date");

    //         // Gültigkeit bis prüfen mly140625
    //         vrc_SalesVATEvaluation.SETFILTER("Valid To", '>=%1|%2', vrc_PackHeader."Posting Date", 0D);

    //         // VAT Satz suchen
    //         IF vrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //             //mly+
    //             IF vrc_SalesVATEvaluation.COUNT > 1 THEN
    //                 ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                   //mly-

    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PackGetAdditionalText(var vrc_PackHeader: Record "5110712"; var vrc_PackLineInput: Record "5110714"; var rtx_ArrAddText: array[4] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         ConditionNo := 0;
    //         IF PackVATEvaluationGet(vrc_PackHeader, vrc_PackLineInput, lrc_SalesVATEvaluation) THEN BEGIN
    //             ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //             //Array Füllen
    //             //rtx_ArrAddText[1]:=
    //             CLEAR(rtx_ArrAddText);
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 rtx_ArrAddText[1] := lrc_SalesVATEvaluation."Additional Inv. Text 1";
    //                 rtx_ArrAddText[2] := lrc_SalesVATEvaluation."Additional Inv. Text 2";
    //                 rtx_ArrAddText[3] := lrc_SalesVATEvaluation."Additional Inv. Text 3";
    //                 rtx_ArrAddText[4] := lrc_SalesVATEvaluation."Additional Inv. Text 4";
    //                 //TranslateAdditionalText(lrc_SalesVATEvaluation,"vrc_Transfer Header"."Language Code",rtx_ArrAddText);
    //             END;
    //             EXIT(TRUE);
    //         END ELSE BEGIN
    //             EXIT(FALSE);
    //         END;
    //     end;

    //     procedure PackGetFiscalAgent(var vrc_PackHeader: Record "5110712"; var vrc_PackLineInput: Record "5110714"; var rtx_ArrFiscalAgentText: array[10] of Text[100]; var ConditionNo: Integer): Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         lrc_FiscalAgent: Record "5087924";
    //         lrc_LanguageTranslation: Record "5110321";
    //         lrc_Location: Record "14";
    //     begin
    //         //VAT 007 port     JST 040313     Neue Funktionen Transfer Steuerermittlung
    //         CLEAR(rtx_ArrFiscalAgentText);
    //         IF PackVATEvaluationGet(vrc_PackHeader, vrc_PackLineInput, lrc_SalesVATEvaluation) THEN BEGIN
    //             IF lrc_SalesVATEvaluation.FIND('+') THEN BEGIN

    //                 //mly+
    //                 IF lrc_SalesVATEvaluation.COUNT > 1 THEN
    //                     ; // ERROR('Bitte an Admin wenden, das is der Mario...');
    //                       //mly-

    //                 ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF NOT lrc_SalesVATEvaluation."Print Fiscal Agent" THEN
    //                     EXIT;
    //                 IF NOT lrc_FiscalAgent.GET(lrc_SalesVATEvaluation."Fiscal Agent") THEN
    //                     EXIT;
    //                 rtx_ArrFiscalAgentText[1] := lrc_FiscalAgent.Name;
    //                 rtx_ArrFiscalAgentText[2] := lrc_FiscalAgent.Address;
    //                 rtx_ArrFiscalAgentText[3] := STRSUBSTNO('%1-%2 %3', lrc_FiscalAgent."Country Code",
    //                                                                    lrc_FiscalAgent."Post Code",
    //                                                                    lrc_FiscalAgent.City);
    //                 rtx_ArrFiscalAgentText[4] := STRSUBSTNO('%1', lrc_FiscalAgent."VAT Registration No.");
    //                 // Übersetzung der Fiskalvertretertexte holen
    //                 lrc_LanguageTranslation.SETRANGE("Table ID", DATABASE::"Fiscal Agent");
    //                 lrc_LanguageTranslation.SETRANGE(Code, lrc_FiscalAgent.Code);
    //                 //lrc_LanguageTranslation.SETRANGE("Language Code", vrc_PurchaseHeader."Language Code");
    //                 IF lrc_LanguageTranslation.FIND('-') THEN BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_LanguageTranslation.Description;
    //                     rtx_ArrFiscalAgentText[7] := lrc_LanguageTranslation."Description 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_LanguageTranslation."Description 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_LanguageTranslation."Description 4";
    //                 END ELSE BEGIN
    //                     rtx_ArrFiscalAgentText[6] := lrc_FiscalAgent."Invoice Text 1";
    //                     rtx_ArrFiscalAgentText[7] := lrc_FiscalAgent."Invoice Text 2";
    //                     rtx_ArrFiscalAgentText[8] := lrc_FiscalAgent."Invoice Text 3";
    //                     rtx_ArrFiscalAgentText[9] := lrc_FiscalAgent."Invoice Text 4";
    //                 END;
    //                 EXIT(TRUE);
    //             END ELSE BEGIN
    //                 EXIT(FALSE);
    //             END;
    //         END;
    //     end;

    //     procedure "-- POI Sorting Code aus VAT --"()
    //     begin
    //         //VAT 007 port     JST 050313     Neue Funktionen um Print Sorting Code (Druckfolge Code) zu erfassen
    //     end;

    //     procedure TransferGetDocVATNoWriteTbl(var "vrc_Transfer Header": Record "5740"; var "vrc_Transfer Line": Record "5741"; var lin_ConditionNo: Integer; var "lco_Print Sorting Code": Code[10]) ok: Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         "lrc_Print Sorting": Record "5110477";
    //         lco_NoSeriesManagement: Codeunit "396";
    //     begin
    //         //VAT 007 port     JST 050313     Neue Funktionen um Print Sorting Code (Druckfolge Code) zu erfassen
    //         //Print Sorting Code (Druckfolge Code) -> Hinterlegen in Verkaufskopf
    //         //Tbl 5110477 Print Sorting (Sortierung Druck) Nummernvergabe hinterlegen
    //         //Fkt. für Fiscalvertzreter zur Darstellung von forlaufenden Steuervorfällen (durchgehende NUmmerrierung)
    //         ok := FALSE;
    //         IF "vrc_Transfer Header"."Print Sorting Code" = '' THEN BEGIN
    //             IF TransferVATEvaluationGet("vrc_Transfer Header", "vrc_Transfer Line", lrc_SalesVATEvaluation) THEN BEGIN
    //                 lin_ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF lrc_SalesVATEvaluation."Print Sorting Series" <> '' THEN BEGIN
    //                     "lco_Print Sorting Code" := lco_NoSeriesManagement.GetNextNo(lrc_SalesVATEvaluation."Print Sorting Series", Today(), TRUE);
    //                     "lrc_Print Sorting".Reset();
    //                     "lrc_Print Sorting".INIT();
    //                     "lrc_Print Sorting".Code := "lco_Print Sorting Code";
    //                     "lrc_Print Sorting".Typ := "lrc_Print Sorting".Typ::Transfer;
    //                     "lrc_Print Sorting".Description := 'Transfer ' + "vrc_Transfer Header"."No.";
    //                     "lrc_Print Sorting"."Company Chain Code" := '';
    //                     "lrc_Print Sorting"."Print Sorting Series" := lrc_SalesVATEvaluation."Print Sorting Series";
    //                     "lrc_Print Sorting"."Document No." := "vrc_Transfer Header"."No.";
    //                     "lrc_Print Sorting"."Document Date" := "vrc_Transfer Header"."Posting Date";
    //                     "lrc_Print Sorting"."Customer/Vendor No." := "vrc_Transfer Header"."Transfer-to Code";
    //                     "lrc_Print Sorting".INSERT(TRUE);
    //                 END;
    //                 "vrc_Transfer Header"."Print Sorting Code" := "lco_Print Sorting Code";
    //                 "vrc_Transfer Header".MODIFY();
    //                 ok := TRUE;
    //             END;
    //         END ELSE
    //             "lco_Print Sorting Code" := "vrc_Transfer Header"."Print Sorting Code";
    //         EXIT(ok);
    //     end;

    //     procedure TransferPosGetDocVATNoWriteTbl(var "vrc_Transfer Receipt Header": Record "5746"; var "vrc_Transfer Receipt Line": Record "5747"; var lin_ConditionNo: Integer; var "lco_Print Sorting Code": Code[10]) ok: Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         "lrc_Print Sorting": Record "5110477";
    //         lco_NoSeriesManagement: Codeunit "396";
    //     begin
    //         //VAT 007 port     JST 050313     Neue Funktionen um Print Sorting Code (Druckfolge Code) zu erfassen
    //         //Print Sorting Code (Druckfolge Code) -> Hinterlegen in Verkaufskopf
    //         //Tbl 5110477 Print Sorting (Sortierung Druck) Nummernvergabe hinterlegen
    //         //Fkt. für Fiscalvertzreter zur Darstellung von forlaufenden Steuervorfällen (durchgehende NUmmerrierung)
    //         ok := FALSE;
    //         IF "vrc_Transfer Receipt Header"."Print Sorting Code" = '' THEN BEGIN
    //             IF TransferPostedVATEvaluationGet("vrc_Transfer Receipt Header", "vrc_Transfer Receipt Line", lrc_SalesVATEvaluation) THEN BEGIN
    //                 lin_ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF lrc_SalesVATEvaluation."Print Sorting Series" <> '' THEN BEGIN
    //                     "lco_Print Sorting Code" := lco_NoSeriesManagement.GetNextNo(lrc_SalesVATEvaluation."Print Sorting Series", Today(), TRUE);
    //                     "lrc_Print Sorting".Reset();
    //                     "lrc_Print Sorting".INIT();
    //                     "lrc_Print Sorting".Code := "lco_Print Sorting Code";
    //                     "lrc_Print Sorting".Typ := "lrc_Print Sorting".Typ::Transfer;
    //                     "lrc_Print Sorting".Description := 'Transfer-Receipt ' + "vrc_Transfer Receipt Header"."No.";
    //                     "lrc_Print Sorting"."Company Chain Code" := '';
    //                     "lrc_Print Sorting"."Print Sorting Series" := lrc_SalesVATEvaluation."Print Sorting Series";
    //                     "lrc_Print Sorting"."Document No." := "vrc_Transfer Receipt Header"."No.";
    //                     "lrc_Print Sorting"."Document Date" := "vrc_Transfer Receipt Header"."Posting Date";
    //                     "lrc_Print Sorting"."Customer/Vendor No." := "vrc_Transfer Receipt Header"."Transfer-to Code";
    //                     "lrc_Print Sorting".INSERT(TRUE);
    //                 END;
    //                 "vrc_Transfer Receipt Header"."Print Sorting Code" := "lco_Print Sorting Code";
    //                 "vrc_Transfer Receipt Header".MODIFY();
    //                 ok := TRUE;
    //             END;
    //         END ELSE
    //             "lco_Print Sorting Code" := "vrc_Transfer Receipt Header"."Print Sorting Code";
    //         EXIT(ok);
    //     end;

    //     procedure PackGetDocVATNoWriteTbl(var vrc_PackHeader: Record "5110712"; var vrc_PackLineInput: Record "5110714"; var lin_ConditionNo: Integer; var "lco_Print Sorting Code": Code[10]) ok: Boolean
    //     var
    //         lrc_SalesVATEvaluation: Record "5087926";
    //         "lrc_Print Sorting": Record "5110477";
    //         lco_NoSeriesManagement: Codeunit "396";
    //     begin
    //         //VAT 007 port     JST 050313     Neue Funktionen um Print Sorting Code (Druckfolge Code) zu erfassen
    //         //Tbl 5110477 Print Sorting (Sortierung Druck) Nummernvergabe hinterlegen
    //         //Fkt. für Fiscalvertzreter zur Darstellung von forlaufenden Steuervorfällen (durchgehende NUmmerrierung)

    //         //VAT 015 port     JST 050613     Pack (ähnlich Transfer) integriert PackVATEvaluationGet und den Rest
    //         ok := FALSE;
    //         IF vrc_PackHeader."Print Sorting Code" = '' THEN BEGIN
    //             IF PackVATEvaluationGet(vrc_PackHeader, vrc_PackLineInput, lrc_SalesVATEvaluation) THEN BEGIN
    //                 lin_ConditionNo := lrc_SalesVATEvaluation."Condition No.";
    //                 IF lrc_SalesVATEvaluation."Print Sorting Series" <> '' THEN BEGIN
    //                     "lco_Print Sorting Code" := lco_NoSeriesManagement.GetNextNo(lrc_SalesVATEvaluation."Print Sorting Series", Today(), TRUE);
    //                     "lrc_Print Sorting".Reset();
    //                     "lrc_Print Sorting".INIT();
    //                     "lrc_Print Sorting".Code := "lco_Print Sorting Code";
    //                     "lrc_Print Sorting".Typ := "lrc_Print Sorting".Typ::Transfer;
    //                     "lrc_Print Sorting".Description := 'Pack ' + vrc_PackHeader."No.";
    //                     "lrc_Print Sorting"."Company Chain Code" := '';
    //                     "lrc_Print Sorting"."Print Sorting Series" := lrc_SalesVATEvaluation."Print Sorting Series";
    //                     "lrc_Print Sorting"."Document No." := vrc_PackHeader."No.";
    //                     "lrc_Print Sorting"."Document Date" := vrc_PackHeader."Posting Date";
    //                     "lrc_Print Sorting"."Customer/Vendor No." := vrc_PackHeader."Vendor No.";
    //                     "lrc_Print Sorting".INSERT(TRUE);
    //                 END;
    //                 vrc_PackHeader."Print Sorting Code" := "lco_Print Sorting Code";
    //                 vrc_PackHeader.MODIFY();
    //                 ok := TRUE;
    //             END;
    //         END ELSE
    //             "lco_Print Sorting Code" := vrc_PackHeader."Print Sorting Code";
    //         EXIT(ok);
    //     end;

    //     procedure "-- POI Get ForeignVAT"()
    //     begin
    //     end;

    //     procedure SalesInvoiceGetForeignVAT(var vrc_SalesInvoiceHeader: Record "112"; var vrc_SalesInvoiceLine: Record "113"; var vtx_ArrForeignVAT: array[10] of Text[100]; var vtx_ArrForeignVATAdress: array[10] of Text[100]) ok: Boolean
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_VATRegistrationNo: Record "50022";
    //         "lrc_Country/Region": Record "9";
    //         lrc_VATEvaluation: Record "5087926";
    //         FoundVATCountry: Boolean;
    //         lrc_Location: Record "14";
    //         ForeignVatName: Text[100];
    //         VATNoteFiskal: Text[100];
    //         ltx_Country: Text[30];
    //         lrc_ShipmentMethod: Record "10";
    //     begin
    //         ok := FALSE;

    //         //CLEAR(vtx_ArrForeignVAT);
    //         //CLEAR(vtx_ArrForeignVATAdress);

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         //grc_CompanyInformation.GET();
    //         //CompCountry:=grc_CompanyInformation."Country/Region Code";
    //         //RS CompCountry unterschiedlich bei Registrierung in anderen Ländern
    //         IF vrc_SalesInvoiceLine.Type = vrc_SalesInvoiceLine.Type::Item THEN BEGIN
    //             lrc_Location.GET(vrc_SalesInvoiceLine."Location Code");
    //             IF grc_CompanyInformation.GET(lrc_Location."Country/Region Code") THEN
    //                 CompCountry := grc_CompanyInformation."Primary Key";
    //         END ELSE BEGIN
    //             grc_CompanyInformation.GET();
    //             CompCountry := grc_CompanyInformation."Country/Region Code";
    //         END;
    //         lrc_Location.Reset();

    //         //#######################klären ->

    //         IF NOT SalesInvoiceFindTaxRecord(vrc_SalesInvoiceHeader, vrc_SalesInvoiceLine, lrc_VATEvaluation) THEN EXIT;

    //         //mly evtl. folgendes ausgeklammern, weil der text, wenn schon was gefundenwurde, immer aus der VAT Evaluation table kommen sollte
    //         //RS bei Europool NL keinen Text, da 0%
    //         IF ((vrc_SalesInvoiceLine."VAT %" = 0) AND (lrc_VATRegistrationNo."VAT Registration No." <> '') AND
    //             (vrc_SalesInvoiceLine."Product Group Code" <> '70002')) THEN BEGIN
    //             VATNoteFiskal := 'steuerfreie Lieferung nach Reverse Charge ' + ltx_Country
    //         END ELSE BEGIN
    //             VATNoteFiskal := '';
    //         END;
    //         lrc_Customer.GET(vrc_SalesInvoiceHeader."Sell-to Customer No.");
    //         //161118 rs VAT Registration No. nicht aus Customer, wenn schon vorhanden
    //         IF vtx_ArrForeignVAT[1] = '' THEN
    //             vtx_ArrForeignVAT[1] := lrc_Customer."VAT Registration No.";
    //         IF vtx_ArrForeignVAT[2] = '' THEN
    //             vtx_ArrForeignVAT[2] := lrc_Customer."Country/Region Code";
    //         IF vtx_ArrForeignVAT[3] = '' THEN
    //             vtx_ArrForeignVAT[3] := VATNoteFiskal;
    //         //161118 rs.e

    //         //Port.jst 20.3.13  Ausgabe der Foreign-Vat nur wenn in der VAt-Ermittlung dies angegeben ist.
    //         IF NOT lrc_VATEvaluation."Print Vat-Reg Dep Country" THEN BEGIN
    //             ok := FALSE;
    //             EXIT;
    //         END;

    //         FoundVATCountry := FALSE;
    //         lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_SalesInvoiceHeader."Sell-to Customer No.");
    //         //Abgangsland bestimmen
    //         IF vrc_SalesInvoiceLine."Location Code" <> '' THEN BEGIN
    //             lrc_Location.GET(vrc_SalesInvoiceLine."Location Code")
    //         END ELSE BEGIN
    //             IF vrc_SalesInvoiceHeader."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_SalesInvoiceHeader."Location Code");
    //             END ELSE BEGIN
    //                 ok := FALSE;
    //                 EXIT;
    //             END;
    //         END;

    //         //171220 rs
    //         IF lrc_ShipmentMethod.GET(vrc_SalesInvoiceHeader."Shipment Method Code") THEN
    //             ;
    //         IF lrc_ShipmentMethod."Incl. Freight to Final Loc." THEN BEGIN

    //             IF (vrc_SalesInvoiceHeader."Ship-to Country/Region Code" <> '') THEN
    //                 lrc_VATRegistrationNo.SETRANGE("Country Code", vrc_SalesInvoiceHeader."Ship-to Country/Region Code")
    //             ELSE
    //                 //lrc_VATRegistrationNo.SETFILTER("Country Code",'%1|%2','*'+CompCountry+'*','');
    //                 lrc_VATRegistrationNo.SETRANGE("Country Code", vrc_SalesInvoiceHeader."Sell-to Country/Region Code");
    //             IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //                 FoundVATCountry := TRUE;
    //             END ELSE BEGIN
    //                 lrc_VATRegistrationNo.SETRANGE("Country Code");
    //                 lrc_VATRegistrationNo.SETRANGE("Country Code", vrc_SalesInvoiceHeader."Ship-to Country/Region Code");
    //                 //170117 rs zusätzliche Filterung ob "zur VAT Ermittlung verwenden" TRUE
    //                 lrc_VATRegistrationNo.SETRANGE("VAT Detection", TRUE);
    //                 //170117 rs
    //                 IF lrc_VATRegistrationNo.FINDFIRST() THEN
    //                     FoundVATCountry := TRUE;
    //             END;
    //         END ELSE BEGIN
    //             IF (lrc_Location."Country/Region Code" <> '')
    //               THEN
    //                 lrc_VATRegistrationNo.SETRANGE("Country Code", lrc_Location."Country/Region Code")
    //             ELSE
    //                 lrc_VATRegistrationNo.SETFILTER("Country Code", '%1|%2', '*' + CompCountry + '*', '');
    //             IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //                 FoundVATCountry := TRUE;
    //             END ELSE BEGIN
    //                 lrc_VATRegistrationNo.SETRANGE("Country Code");
    //                 lrc_VATRegistrationNo.SETRANGE("Country Code", vrc_SalesInvoiceHeader."Ship-to Country/Region Code");
    //                 //170117 rs zusätzliche Filterung ob "zur VAT Ermittlung verwenden" TRUE
    //                 lrc_VATRegistrationNo.SETRANGE("VAT Detection", TRUE);
    //                 //170117 rs
    //                 IF lrc_VATRegistrationNo.FINDFIRST() THEN
    //                     FoundVATCountry := TRUE;
    //             END;

    //         END;

    //         IF FoundVATCountry THEN BEGIN
    //             IF lrc_VATRegistrationNo."VAT Registration No." = '' THEN
    //                 EXIT
    //             ELSE
    //                 ok := TRUE;

    //             //mly evtl. folgendes ausgeklammern, weil der text, wenn schon was gefundenwurde, immer aus der VAT Evaluation table kommen sollte

    //             vtx_ArrForeignVAT[1] := lrc_VATRegistrationNo."VAT Registration No.";
    //             vtx_ArrForeignVAT[2] := lrc_VATRegistrationNo."Country Code";
    //             vtx_ArrForeignVAT[3] := VATNoteFiskal;

    //             vtx_ArrForeignVATAdress[1] := lrc_VATRegistrationNo.Name;
    //             vtx_ArrForeignVATAdress[2] := lrc_VATRegistrationNo."Name 2";
    //             vtx_ArrForeignVATAdress[3] := lrc_VATRegistrationNo.Address;
    //             vtx_ArrForeignVATAdress[4] := lrc_VATRegistrationNo."Address 2";
    //             vtx_ArrForeignVATAdress[5] := lrc_VATRegistrationNo."Post Code";
    //             vtx_ArrForeignVATAdress[6] := lrc_VATRegistrationNo.City;
    //         END;
    //     end;

    //     procedure SalesCrMemoGetForeignVAT(var vrc_SalesCrMemoHeader: Record "114"; var vrc_SalesCrMemoLine: Record "115"; var vtx_ArrForeignVAT: array[10] of Text[100]; var vtx_ArrForeignVATAdress: array[10] of Text[100]) ok: Boolean
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_VATRegistrationNo: Record "50022";
    //         "lrc_Country/Region": Record "9";
    //         lrc_VATEvaluation: Record "5087926";
    //         FoundVATCountry: Boolean;
    //         lrc_Location: Record "14";
    //         ForeignVatName: Text[100];
    //         VATNoteFiskal: Text[100];
    //         ltx_Country: Text[30];
    //     begin
    //         //VAT 020 port     JST 240613     Fkt. SalesCrMemoGetForeignVAT zugefügt (für Gutschriften gleiche Auswertung wie bei Innvoice)

    //         ok := FALSE;

    //         //CLEAR(vtx_ArrForeignVAT);
    //         //CLEAR(vtx_ArrForeignVATAdress);

    //         //VAT 027 port     JST 030214     Company-Country aus der Einrichtung (Vorher feste Filterung 'DE')
    //         grc_CompanyInformation.GET();
    //         CompCountry := grc_CompanyInformation."Country/Region Code";

    //         IF NOT SalesCrMemoFindTaxRecord(vrc_SalesCrMemoHeader, vrc_SalesCrMemoLine, lrc_VATEvaluation) THEN EXIT;

    //         //mly evtl. folgendes ausgeklammern, weil der text, wenn schon was gefundenwurde, immer aus der VAT Evaluation table kommen sollte

    //         IF ((vrc_SalesCrMemoLine."VAT %" = 0) AND (lrc_VATRegistrationNo."VAT Registration No." <> '') AND
    //             (vrc_SalesCrMemoLine."Product Group Code" <> '70002')) THEN BEGIN
    //             VATNoteFiskal := 'steuerfreie Lieferung nach Reverse Charge ' + ltx_Country
    //             //reverse charge := Empfänger haftet für steuerliche Übertragung z.B. DE->AT 0%Vat = Reverse Charge
    //         END ELSE BEGIN
    //             VATNoteFiskal := '';
    //         END;
    //         lrc_Customer.GET(vrc_SalesCrMemoHeader."Sell-to Customer No.");
    //         vtx_ArrForeignVAT[1] := lrc_Customer."VAT Registration No.";
    //         vtx_ArrForeignVAT[2] := lrc_Customer."Country/Region Code";
    //         vtx_ArrForeignVAT[3] := VATNoteFiskal;
    //         //Port.jst 20.3.13  Ausgabe der Foreign-Vat nur wenn in der VAt-Ermittlung dies angegeben ist.
    //         IF NOT lrc_VATEvaluation."Print Vat-Reg Dep Country" THEN BEGIN
    //             ok := FALSE;
    //             EXIT;
    //         END;

    //         FoundVATCountry := FALSE;
    //         lrc_VATRegistrationNo.SETRANGE("Vendor/Customer", vrc_SalesCrMemoHeader."Sell-to Customer No.");
    //         //Abgangsland bestimmen
    //         IF vrc_SalesCrMemoLine."Location Code" <> '' THEN BEGIN
    //             lrc_Location.GET(vrc_SalesCrMemoLine."Location Code")
    //         END ELSE BEGIN
    //             IF vrc_SalesCrMemoHeader."Location Code" <> '' THEN BEGIN
    //                 lrc_Location.GET(vrc_SalesCrMemoHeader."Location Code");
    //             END ELSE BEGIN
    //                 ok := FALSE;
    //                 EXIT;
    //             END;
    //         END;

    //         IF (lrc_Location."Country/Region Code" <> '')
    //           THEN
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", lrc_Location."Country/Region Code")
    //         ELSE
    //             lrc_VATRegistrationNo.SETFILTER("Country Code", '%1|%2', '*' + CompCountry + '*', '');
    //         IF lrc_VATRegistrationNo.FINDFIRST() THEN BEGIN
    //             FoundVATCountry := TRUE;
    //         END ELSE BEGIN
    //             lrc_VATRegistrationNo.SETRANGE("Country Code");
    //             lrc_VATRegistrationNo.SETRANGE("Country Code", vrc_SalesCrMemoHeader."Ship-to Country/Region Code");
    //             IF lrc_VATRegistrationNo.FINDFIRST() THEN
    //                 FoundVATCountry := TRUE;
    //         END;

    //         IF FoundVATCountry THEN BEGIN
    //             IF lrc_VATRegistrationNo."VAT Registration No." = '' THEN
    //                 EXIT
    //             ELSE
    //                 ok := TRUE;

    //             //mly evtl. folgendes ausgeklammern, weil der text, wenn schon was gefundenwurde, immer aus der VAT Evaluation table kommen sollte

    //             IF ((vrc_SalesCrMemoLine."VAT %" = 0) AND (lrc_VATRegistrationNo."VAT Registration No." <> '') AND
    //                 (vrc_SalesCrMemoLine."Product Group Code" <> '70002'))
    //               THEN
    //                 VATNoteFiskal := 'steuerfreie Lieferung nach Reverse Charge ' + ltx_Country
    //             //reverse charge := Empfänger haftet für steuerliche Übertragung z.B. DE->AT 0%Vat = Reverse Charge
    //             ELSE
    //                 VATNoteFiskal := '';

    //             vtx_ArrForeignVAT[1] := lrc_VATRegistrationNo."VAT Registration No.";
    //             vtx_ArrForeignVAT[2] := lrc_VATRegistrationNo."Country Code";
    //             vtx_ArrForeignVAT[3] := VATNoteFiskal;

    //             vtx_ArrForeignVATAdress[1] := lrc_VATRegistrationNo.Name;
    //             vtx_ArrForeignVATAdress[2] := lrc_VATRegistrationNo."Name 2";
    //             vtx_ArrForeignVATAdress[3] := lrc_VATRegistrationNo.Address;
    //             vtx_ArrForeignVATAdress[4] := lrc_VATRegistrationNo."Address 2";
    //             vtx_ArrForeignVATAdress[5] := lrc_VATRegistrationNo."Post Code";
    //             vtx_ArrForeignVATAdress[6] := lrc_VATRegistrationNo.City;
    //         END;
    //     end;

    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_PurchaseLine: Record "Purchase Line";
}

