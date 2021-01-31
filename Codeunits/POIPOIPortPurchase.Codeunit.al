codeunit 60015 "POI POI Port Purchase"
{
    // POI (JW 01.12.2016)
    // POI (RS 04.05.17) Function changed: ExcelAusgabeEKZeilen
    // POI (JW 08.01.18) Function added: Bestandsprüfung
    // POI (29.01.18) Function added: OnOpenPage


    trigger OnRun()
    begin
        g_Choicetext := ('Ek-Zeilen Ausgabe (z.B. Versicherungsmeldung)'
                      + ',' + ''
                      );
        g_OptioNo := STRMENU(g_Choicetext, 1);
        CASE g_OptioNo OF
            1:
                ExcelAusgabeEKZeilen();
        END;
    end;

    var
        g_Choicetext: Text[1024];
        g_OptioNo: Integer;

    procedure ExcelAusgabeEKZeilen()
    var
        ltr_ExcelBuffer: Record "Excel Buffer" temporary;
        lr_Vendor: Record Vendor;
        lc_PortSystem: Codeunit "POI Port_System";
        lf_PortVari: Page "POI Port Variablen";
        l_textVari1: Text[30];
        l_textVari2: Text[30];
        l_textVari3: Text[30];
        l_textVari4: Text[30];
        l_textVari5: Text[30];
        l_DatumVon: Date;
        l_DatumBis: Date;
        l_ChoiceVendor: Code[20];
        l_ChoiceCountry: Code[10];
        l_DocNo: Code[20];
        l_ChoiceTransportPraemie: Decimal;
        l_ItemVKPreis: Decimal;
        l_FilterSetzung: Text[250];
        l_FileName: Text[300];
        l_RowNo: Integer;
        i: Integer;
        l_LfdNo: Integer;
        l_QtySum: Decimal;
        l_VersSumme: Decimal;
        l_PraemienBetrag: Decimal;
        l_BoolVari1: Boolean;
        l_BoolVari2: Boolean;
        d_Dialog: Dialog;
        l_SumPartieHELP: Decimal;
        l_Help: Code[20];

    begin

        IF NOT CONFIRM('Hier weden EK-Zeilen in Excel-Ausgegeben, fortsetzen ?', TRUE) THEN
            ERROR('Abbruch');

        CLEAR(lf_PortVari);
        lf_PortVari.SetVariMore('Datum von', 'Datum bis', 'Kreditor', 'Ursprungsland', 'Transp.Prämie(0,84%=0,0084)', '', '');
        lf_PortVari.LOOKUPMODE := TRUE;
        IF lf_PortVari.RUNMODAL() <> ACTION::LookupOK THEN
            ERROR('Abbruch');
        lf_PortVari.GetVariMore(l_textVari1, l_textVari2, l_textVari3, l_textVari4, l_textVari5, l_BoolVari1, l_BoolVari2);
        CLEAR(lf_PortVari);
        EVALUATE(l_DatumVon, l_textVari1);
        EVALUATE(l_DatumBis, l_textVari2);
        EVALUATE(l_ChoiceVendor, l_textVari3);
        EVALUATE(l_ChoiceCountry, l_textVari4);
        IF l_textVari5 <> ''
          THEN
            EVALUATE(l_ChoiceTransportPraemie, l_textVari5)
        ELSE
            l_ChoiceTransportPraemie := 0;

        IF l_textVari1 <> '' THEN l_FilterSetzung := copystr(l_FilterSetzung + 'Zeitraum von ' + l_textVari1, 1, MaxStrLen(l_FilterSetzung));
        IF l_textVari2 <> '' THEN l_FilterSetzung := copystr(l_FilterSetzung + ' bis ' + l_textVari2, 1, MaxStrLen(l_FilterSetzung));
        IF l_textVari3 <> '' THEN l_FilterSetzung := copystr(l_FilterSetzung + ' ,Kreditor ' + l_textVari3, 1, MaxStrLen(l_FilterSetzung));
        IF l_textVari4 <> '' THEN l_FilterSetzung := copystr(l_FilterSetzung + ' ,Ursprungsland ' + l_textVari4, 1, MaxStrLen(l_FilterSetzung));

        ltr_TempBuffer.DELETEALL();

        //Excel Überschriften
        //l_FileName:='c:\temp\Transportversicherung Anmeldung-' + USERID +'.xls';
        l_FileName := '\\port-nav-01\NavClient\temp\Transportversicherung Anmeldung-' + USERID() + '.xls';

        l_RowNo := 1;
        ltr_ExcelBuffer.DELETEALL();
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 1, copystr(COMPANYNAME(), 1, 250), '', TRUE, FALSE, FALSE);
        l_RowNo += 1;
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 1, 'Kreditor- Einkaufsstatistik', '', TRUE, FALSE, FALSE);
        l_RowNo += 1;
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 1, 'Erstellt ' + FORMAT(TODAY()), '', TRUE, FALSE, FALSE);
        l_RowNo += 1;
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 1, l_FilterSetzung, '', TRUE, FALSE, FALSE);
        l_RowNo += 1;
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 1, 'Kred-Nr.', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 2, 'Kred.Name', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 3, 'Lager', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 4, 'ETA', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 5, 'Artikel', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 6, 'Beschreibung', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 7, 'Erzeugerland', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 8, 'Einheit', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 9, 'Menge', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 10, 'VK_Preis', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 11, 'Vers.Summe', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 12, 'TransportPrämie', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 13, 'Kriegsprämie', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 14, 'Gesamtprämie', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 15, 'Prämie Betrag', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 16, 'Partie', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 17, 'Sum Partie', '', TRUE, FALSE, FALSE);

        lr_PurchLine.Reset();
        IF l_ChoiceVendor <> '' THEN
            lr_PurchLine.SETFILTER("Buy-from Vendor No.", l_ChoiceVendor);
        lr_PurchLine.SETRANGE("Expected Receipt Date", l_DatumVon, l_DatumBis);
        lr_PurchLine.SETRANGE(Type, lr_PurchLine.Type::Item);
        IF l_ChoiceCountry <> '' THEN
            lr_PurchLine.SETFILTER("POI Country of Origin Code", l_ChoiceCountry);
        lr_PurchLine.SETFILTER(Quantity, '<>0');
        lr_PurchLine.SETFILTER("Document Type", '<>%1', lr_PurchLine."Document Type"::"Blanket Order");
        IF NOT lr_PurchLine.FIND('-') THEN
            ERROR('EK-zeilen für Kreditor %1 Zeitraum %2 bis %3 nicht gefunden', l_ChoiceVendor, l_DatumVon,
              l_DatumBis)

        ELSE BEGIN
            d_Dialog.OPEN('Einkaufszeile #1#### von #2####');
            d_Dialog.UPDATE(2, lr_PurchLine.COUNT());
            i := 0;
            l_LfdNo := 1;

            REPEAT
                i += 1;
                d_Dialog.UPDATE(1, i);

                //VK-Preisermittlung für Artikel
                l_ItemVKPreis := 0; //16.15;

                lr_Vendor.GET(lr_PurchLine."Buy-from Vendor No.");

                ltr_TempBuffer.INIT();
                ltr_TempBuffer.LineNo := l_LfdNo;
                ltr_TempBuffer.code1 := lr_PurchLine."Buy-from Vendor No.";
                ltr_TempBuffer.text1 := lr_Vendor.Name;
                ltr_TempBuffer.code2 := lr_PurchLine."Location Code";
                ltr_TempBuffer.date1 := lr_PurchLine."Expected Receipt Date";
                ltr_TempBuffer.code3 := lr_PurchLine."No.";
                ltr_TempBuffer.text2 := lr_PurchLine.Description;
                ltr_TempBuffer.code4 := lr_PurchLine."POI Country of Origin Code";
                ltr_TempBuffer.code5 := lr_PurchLine."Unit of Measure Code";
                ltr_TempBuffer.decimal1 := lr_PurchLine.Quantity;

                lr_SalesPrice.Reset();
                lr_SalesPrice.SETRANGE("Sales Type", lr_SalesPrice."Sales Type"::"Customer Price Group");
                lr_SalesPrice.SETFILTER("Sales Code", '%1|%2', 'PERU', 'DOMREP');
                lr_SalesPrice.SETRANGE("Item No.", lr_PurchLine."No.");
                IF lr_SalesPrice.Findset() THEN BEGIN
                    IF lr_Vendor."Country/Region Code" = 'PE' THEN
                        lr_SalesPrice.SETRANGE("Sales Code", 'PERU')
                    ELSE
                        IF lr_Vendor."Country/Region Code" = 'DO' THEN
                            lr_SalesPrice.SETRANGE("Sales Code", 'DOMREP');
                    IF lr_SalesPrice.Findlast() THEN BEGIN
                        ltr_TempBuffer.decimal2 := lr_SalesPrice."Unit Price";
                        ltr_TempBuffer.decimal3 := ltr_TempBuffer.decimal1 * lr_SalesPrice."Unit Price";
                    END;
                END ELSE BEGIN
                    ltr_TempBuffer.decimal2 := l_ItemVKPreis;
                    ltr_TempBuffer.decimal3 := ltr_TempBuffer.decimal1 * l_ItemVKPreis;
                END;

                ltr_TempBuffer.code6 := lr_PurchLine."Document No.";
                ltr_TempBuffer.decimal4 := l_ChoiceTransportPraemie + 0.0005;
                ltr_TempBuffer.decimal5 := ltr_TempBuffer.decimal3 * ltr_TempBuffer.decimal4;
                ltr_TempBuffer.INSERT();

                l_LfdNo += 1;
                l_QtySum += ltr_TempBuffer.decimal1;
                l_VersSumme += ltr_TempBuffer.decimal3;
                l_PraemienBetrag += ltr_TempBuffer.decimal5;
                l_DocNo := lr_PurchLine."Document No.";
            UNTIL lr_PurchLine.Next() = 0;
        END;

        ltr_TempBuffer.Reset();
        IF ltr_TempBuffer.Findset() THEN
            REPEAT
                ltr_TempBufferHELP.INIT();
                ltr_TempBufferHELP := ltr_TempBuffer;
                ltr_TempBufferHELP.Insert();
            UNTIL ltr_TempBuffer.Next() = 0;

        ltr_TempBuffer.Reset();
        IF ltr_TempBuffer.Findset() THEN
            REPEAT
                ltr_TempBufferHELP.Reset();
                ltr_TempBufferHELP.SETRANGE(code6, ltr_TempBuffer.code6);
                IF ltr_TempBufferHELP.Findset() THEN
                    IF ltr_TempBufferHELP.COUNT() = 1 THEN BEGIN
                        ltr_TempBuffer.decimal7 := ltr_TempBuffer.decimal5;
                        ltr_TempBuffer.boolean1 := TRUE;
                        ltr_TempBuffer.Modify();
                    END ELSE BEGIN
                        l_SumPartieHELP := 0;
                        REPEAT
                            l_SumPartieHELP += ltr_TempBufferHELP.decimal5;
                        UNTIL ltr_TempBufferHELP.Next() = 0;
                        ltr_TempBuffer.decimal7 := l_SumPartieHELP;
                        ltr_TempBuffer.Modify();
                    END;
            UNTIL ltr_TempBuffer.Next() = 0;


        ltr_TempBuffer.Reset();
        IF ltr_TempBuffer.Findset() THEN
            REPEAT
                IF ltr_TempBufferHELP.GET(ltr_TempBuffer.LineNo) THEN BEGIN
                    ltr_TempBufferHELP.decimal7 := ltr_TempBuffer.decimal7;
                    ltr_TempBufferHELP.boolean1 := ltr_TempBuffer.boolean1;
                    ltr_TempBufferHELP.Modify();
                END;
            UNTIL ltr_TempBuffer.Next() = 0;

        ltr_TempBuffer.Reset();
        ltr_TempBuffer.SETRANGE(boolean1, FALSE);
        IF ltr_TempBuffer.Findset() THEN
            REPEAT
                ltr_TempBufferHELP.Reset();
                ltr_TempBufferHELP.SETRANGE(code6, ltr_TempBuffer.code6);
                IF ltr_TempBufferHELP.Findlast() THEN BEGIN
                    IF ltr_TempBufferHELP.code6 <> l_Help THEN BEGIN
                        ltr_TempBufferHELP.boolean1 := TRUE;
                        ltr_TempBufferHELP.Modify();
                    END;
                    l_Help := ltr_TempBuffer.code6;
                END;
            UNTIL ltr_TempBuffer.Next() = 0;

        ltr_TempBuffer.Reset();
        IF ltr_TempBuffer.Findset() THEN
            REPEAT
                IF ltr_TempBufferHELP.GET(ltr_TempBuffer.LineNo) THEN BEGIN
                    ltr_TempBuffer.boolean1 := ltr_TempBufferHELP.boolean1;
                    ltr_TempBuffer.Modify();
                END;
            UNTIL ltr_TempBuffer.Next() = 0;

        ltr_TempBuffer.Reset();
        ltr_TempBuffer.SETRANGE(boolean1, FALSE);
        IF ltr_TempBuffer.Findset() THEN
            REPEAT
                ltr_TempBuffer.decimal7 := 0;
                ltr_TempBuffer.Modify();
            UNTIL ltr_TempBuffer.Next() = 0;

        ltr_TempBuffer.Reset();
        IF ltr_TempBuffer.Findset() THEN
            REPEAT
                l_RowNo += 1;

                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 1, ltr_TempBuffer.code1, '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 1, ltr_TempBuffer.code1, '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 2, ltr_TempBuffer.text1, '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 2, ltr_TempBuffer.text1, '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 3, ltr_TempBuffer.code2, '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 3, ltr_TempBuffer.code2, '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 4, FORMAT(ltr_TempBuffer.date1), '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 4, FORMAT(ltr_TempBuffer.date1), '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 5, ltr_TempBuffer.code3, '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 5, ltr_TempBuffer.code3, '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 6, ltr_TempBuffer.text2, '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 6, ltr_TempBuffer.text2, '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 7, ltr_TempBuffer.code4, '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 7, ltr_TempBuffer.code4, '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 8, ltr_TempBuffer.code5, '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 8, ltr_TempBuffer.code5, '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 9, FORMAT(ltr_TempBuffer.decimal1), '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 9, FORMAT(ltr_TempBuffer.decimal1), '', FALSE, FALSE, FALSE);

                //oder VK-Preis aus Item-Cust-Vend-Reference !!!
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 10, FORMAT(ltr_TempBuffer.decimal2), '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 10, FORMAT(ltr_TempBuffer.decimal2), '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 11, FORMAT(ltr_TempBuffer.decimal3), '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 11, FORMAT(ltr_TempBuffer.decimal3), '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 12, FORMAT(l_ChoiceTransportPraemie), '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 12, FORMAT(l_ChoiceTransportPraemie), '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 13, '0,0005', '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 13, '0,0005', '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 14, '', FORMAT(ltr_TempBuffer.decimal4), FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 14, '', FORMAT(ltr_TempBuffer.decimal4), FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 15, '', FORMAT(ltr_TempBuffer.decimal5), FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 15, '', FORMAT(ltr_TempBuffer.decimal5), FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 16, ltr_TempBuffer.code6, '', FALSE, FALSE, TRUE)
                ELSE
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 16, ltr_TempBuffer.code6, '', FALSE, FALSE, FALSE);
                IF ltr_TempBuffer.boolean1 THEN
                    lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 17, FORMAT(ltr_TempBuffer.decimal7), '', FALSE, FALSE, TRUE)
                ELSE
                    IF ltr_TempBuffer.decimal7 = 0 THEN
                        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 17, '', '', FALSE, FALSE, FALSE)
                    ELSE
                        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 17, FORMAT(ltr_TempBuffer.decimal7), '', FALSE, FALSE, FALSE)
            UNTIL ltr_TempBuffer.Next() = 0;


        l_RowNo += 1;
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 1, 'Summen', '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 9, FORMAT(l_QtySum), '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 11, FORMAT(l_VersSumme), '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 15, FORMAT(l_PraemienBetrag), '', TRUE, FALSE, FALSE);
        lc_PortSystem.EnterCell(ltr_ExcelBuffer, l_RowNo, 17, '', FORMAT(l_PraemienBetrag), TRUE, FALSE, FALSE);

        d_Dialog.CLOSE();

        IF EXISTS(l_FileName) THEN ERASE(l_FileName);
        ltr_ExcelBuffer.CreateBook(l_FileName, 'Transportversicherung Anmeldung');
        //ltr_ExcelBuffer.CreateSheet('Transportversicherung Anmeldung', '', COMPANYNAME(), USERID());
        // ltr_ExcelBuffer.SaveBook(l_FileName); //TODO: excel
        // ltr_ExcelBuffer.GiveUserControl();
    end;

    procedure "Bestandsprüfung"(pr_PurchLine: Record "Purchase Line")
    var
        lr_BatchSetup: Record "POI Master Batch Setup";
        lr_BatchVariant: Record "POI Batch Variant";
        l_ErwBestandVerf: Decimal;
        l_QtyInUse: Decimal;
    begin
        l_ErwBestandVerf := 0;
        lr_BatchSetup.GET();

        IF lr_BatchVariant.GET(pr_PurchLine."POI Batch Variant No.") THEN BEGIN
            lr_BatchVariant.CALCFIELDS("B.V. Inventory (Qty.)", "B.V. Sales Order (Qty)",
              "B.V. FV Reservation (Qty)", "B.V. Pack. Input (Qty)", "B.V. Pack. Pack.-Input (Qty)",
              "B.V. Transfer Ship (Qty)", "B.V. Purch. Order (Qty)", "B.V. Transfer Rec. (Qty)",
              "B.V. Pack. Output (Qty)", "B.V. Transfer in Transit (Qty)",
              "B.V. Sales Cr. Memo (Qty)", "B.V. Purch. Cr. Memo (Qty)");

            l_ErwBestandVerf := lr_BatchVariant."B.V. Inventory (Qty.)" -
              lr_BatchVariant."B.V. Sales Order (Qty)" -
              lr_BatchVariant."B.V. FV Reservation (Qty)" -
              lr_BatchVariant."B.V. Pack. Input (Qty)" -
              lr_BatchVariant."B.V. Pack. Pack.-Input (Qty)" -
              lr_BatchVariant."B.V. Transfer Ship (Qty)" +
              //da mit dem vorherigen Wert berechnet wird -> manuell:
              //lr_BatchVariant."B.V. Purch. Order (Qty)" +
              (pr_PurchLine.Quantity * pr_PurchLine."Qty. per Unit of Measure") +
              lr_BatchVariant."B.V. Transfer Rec. (Qty)" +
              lr_BatchVariant."B.V. Pack. Output (Qty)" +
              lr_BatchVariant."B.V. Transfer in Transit (Qty)";

            l_QtyInUse := lr_BatchVariant."B.V. Sales Order (Qty)" +
              lr_BatchVariant."B.V. FV Reservation (Qty)" +
              lr_BatchVariant."B.V. Pack. Input (Qty)" +
              lr_BatchVariant."B.V. Pack. Pack.-Input (Qty)" +
              lr_BatchVariant."B.V. Transfer Ship (Qty)";

            IF lr_BatchSetup."ExpAvail. Stock incl. SalesCrM" = TRUE THEN
                l_ErwBestandVerf := l_ErwBestandVerf + lr_BatchVariant."B.V. Sales Cr. Memo (Qty)";

            IF lr_BatchSetup."ExpAvail. Stock incl. PurchCrM" = TRUE THEN
                l_ErwBestandVerf := l_ErwBestandVerf - lr_BatchVariant."B.V. Purch. Cr. Memo (Qty)";

            IF l_ErwBestandVerf < 0 THEN
                ERROR('Die Partie wird in Belegen verwendet,\die Menge kann nicht kleiner als ' +
                  '%1 betragen.', l_QtyInUse / pr_PurchLine."Qty. per Unit of Measure");
        END;
    end;

    procedure OnOpenPage(PurchHeader: Record "Purchase Header"; var Drucken: Boolean; var DruckenHandelCHF: Boolean)
    var
        SalesHeader: Record "Sales Header";
        POIFunc: Codeunit POIFunction;
        ExRateAmountFail: Boolean;
    begin
        //-POI- 29.01.19
        ExRateAmountFail := FALSE;
        MastBatch.SETRANGE("No.", PurchHeader."No.");
        IF MastBatch.Findfirst() THEN BEGIN
            Batch.Reset();
            Batch.SETCURRENTKEY("Master Batch No.");
            Batch.SETRANGE("Master Batch No.", MastBatch."No.");
            IF Batch.FIND('-') THEN BEGIN
                SalesLine.Reset();
                SalesLine.SETFILTER("Document Type", '%1|%2|%3|%4|%5', PurchHeader."Document Type"::Order,
                  PurchHeader."Document Type"::Invoice, PurchHeader."Document Type"::"Credit Memo",
                  PurchHeader."Document Type"::"Return Order", PurchHeader."Document Type"::"Blanket Order");
                SalesLine.SETRANGE(Type, SalesLine.Type::Item);
                SalesLine.SETFILTER("No.", '<>%1', '');
                SalesLine.SETRANGE("POI Master Batch No.", Batch."Master Batch No.");
                SalesLine.SETRANGE("POI Batch No.", Batch."No.");
                SalesLine.SETFILTER("Outstanding Quantity", '<>%1', 0);
                IF SalesLine.Findset() THEN BEGIN
                    REPEAT
                        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
                        IF SalesHeader."Currency Code" = 'CHF' THEN BEGIN

                            SalesPrice.Reset();
                            SalesPrice.SETRANGE("Item No.", SalesLine."No.");
                            SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
                            SalesPrice.SETRANGE("Sales Code", SalesHeader."Sell-to Customer No.");
                            SalesPrice.SETFILTER("Currency Code", '<>%1', '');
                            SalesPrice.SETRANGE("Unit of Measure Code", SalesLine."Unit of Measure Code");
                            SalesPrice.SETRANGE("POI Price Base (Sales Price)", SalesLine."POI Price Base (Sales Price)");
                            SalesPrice.SETFILTER("Starting Date", '>=%1', SalesHeader."Promised Delivery Date");
                            //SalesPrice.SETFILTER("Ending Date",'<=%1',SalesHeader."Promised Delivery Date");
                            IF SalesPrice.Findfirst() THEN BEGIN
                                IF SalesPrice."POI Calc. Exchange Rate Amount" <> 0 THEN BEGIN
                                    IF POIFunc.CheckUserInRole('HA_CALCRATEAMOUNT', 0) THEN BEGIN
                                        Drucken := FALSE;
                                        DruckenHandelCHF := TRUE;
                                    END ELSE BEGIN
                                        Drucken := TRUE;
                                        DruckenHandelCHF := FALSE;
                                    END;
                                END ELSE
                                    IF POIFunc.CheckUserInRole('HA_CALCRATEAMOUNT', 0) THEN BEGIN
                                        Drucken := TRUE;
                                        DruckenHandelCHF := FALSE;
                                        ExRateAmountFail := TRUE;
                                    END ELSE BEGIN
                                        Drucken := TRUE;
                                        DruckenHandelCHF := FALSE;
                                    END;
                            END ELSE BEGIN
                                Drucken := TRUE;
                                DruckenHandelCHF := FALSE;
                            END;
                        END;

                    UNTIL SalesLine.Next() = 0;
                    IF ExRateAmountFail THEN
                        ERROR('Kalkulatorischer Wert im Artikel fehlt. Bitte an Regina Lau wenden.');
                END ELSE BEGIN
                    //geb. Belege
                    ItemLedEntry.Reset();
                    ItemLedEntry.SETRANGE("Entry Type", ItemLedEntry."Entry Type"::Sale);
                    ItemLedEntry.SETRANGE("POI Source Doc. Type", ItemLedEntry."POI Source Doc. Type"::Order);
                    ItemLedEntry.SETRANGE("POI Master Batch No.", MastBatch."No.");
                    IF ItemLedEntry.Findlast() THEN BEGIN
                        SalesInvHeader.Reset();
                        SalesInvHeader.SETRANGE("Order No.", ItemLedEntry."POI Source Doc. No.");
                        IF SalesInvHeader.Findfirst() THEN
                            IF SalesInvHeader."Currency Code" = 'CHF' THEN BEGIN
                                SalesInvLine.Reset();
                                SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
                                SalesInvLine.SETRANGE(Type, SalesInvLine.Type::Item);
                                SalesInvLine.SETFILTER("No.", '<>%1', '');
                                IF SalesInvLine.Findset() THEN BEGIN
                                    REPEAT
                                        ExRateAmountFail := FALSE;
                                        SalesPrice.Reset();
                                        SalesPrice.SETRANGE("Item No.", SalesInvLine."No.");
                                        SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
                                        SalesPrice.SETRANGE("Sales Code", SalesInvHeader."Sell-to Customer No.");
                                        SalesPrice.SETFILTER("Currency Code", '<>%1', '');
                                        SalesPrice.SETRANGE("Unit of Measure Code", SalesInvLine."Unit of Measure Code");
                                        SalesPrice.SETRANGE("POI Price Base (Sales Price)", SalesInvLine."POI Price Base (Sales Price)");
                                        SalesPrice.SETFILTER("Starting Date", '>=%1', SalesInvHeader."POI Promised Delivery Date");
                                        //SalesPrice.SETFILTER("Ending Date",'<=%1',SalesInvHeader."Promised Delivery Date");
                                        IF SalesPrice.Findfirst() THEN BEGIN
                                            IF SalesPrice."POI Calc. Exchange Rate Amount" <> 0 THEN BEGIN
                                                IF POIFunc.CheckUserInRole('HA_CALCRATEAMOUNT', 0) THEN BEGIN
                                                    Drucken := FALSE;
                                                    DruckenHandelCHF := TRUE;
                                                END ELSE BEGIN
                                                    Drucken := TRUE;
                                                    DruckenHandelCHF := FALSE;
                                                END;
                                            END ELSE
                                                IF POIFunc.CheckUserInRole('HA_CALCRATEAMOUNT', 0) THEN BEGIN
                                                    Drucken := TRUE;
                                                    DruckenHandelCHF := FALSE;
                                                    ExRateAmountFail := TRUE;
                                                END ELSE BEGIN
                                                    Drucken := TRUE;
                                                    DruckenHandelCHF := FALSE;
                                                END;
                                        END ELSE BEGIN
                                            Drucken := TRUE;
                                            DruckenHandelCHF := FALSE;
                                        END;

                                    UNTIL SalesInvLine.Next() = 0;
                                    IF ExRateAmountFail THEN
                                        ERROR('Kalkulatorischer Wert im Artikel fehlt. Bitte an Regina Lau wenden.');
                                END;
                            END;
                    END ELSE BEGIN
                        Drucken := TRUE;
                        DruckenHandelCHF := FALSE;
                    END;
                END;
            END;
        END;
    end;

    procedure EKHandlesabrechnung(var pr_PurchHeader: Record "Purchase Header")
    var
        EKAbrechnungHELP: Record "POI EK-Abrechnung";
        LastRecNo: Integer;
        ChangeAllPos: Boolean;
        Choicetext: Text[1024];
        OptioNo: Integer;
    begin
        //übernimmt die Einkaufszeilen in die Zeilen der Handlesabrechnung
        EKAbrechnung.Reset();
        EKAbrechnung.SETRANGE(Bestellnummer, pr_PurchHeader."No.");
        IF EKAbrechnung.Findlast() THEN
            LastRecNo := EKAbrechnung.Zeilennummer + 10000
        ELSE
            LastRecNo := 10000;

        ChangeAllPos := TRUE;

        EKAbrechnung.SETFILTER(Positionsnummer, '<>%1', '');
        IF EKAbrechnung.Findset() THEN BEGIN
            Choicetext := ('Positionen in Abrechnung erneuern' + ',' + 'vorhandene Pos. bleiben so' + ',' + 'Abbruch');
            OptioNo := STRMENU(Choicetext, 1);
            CASE OptioNo OF
                1:
                    ChangeAllPos := TRUE;
                2:
                    ChangeAllPos := FALSE;
                ELSE
                    EXIT;
            END;
        END;

        PurchLine.Reset();
        PurchLine.SETRANGE("Document Type", pr_PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.", pr_PurchHeader."No.");
        PurchLine.SETRANGE(Type, PurchLine.Type::Item);
        PurchLine.SETFILTER("No.", '<>%1', '');
        PurchLine.SETFILTER(Quantity, '<>0');
        IF PurchLine.Findset() THEN
            REPEAT
                IF PurchLine."POI Batch No." <> '' THEN BEGIN
                    EKAbrechnung.SETRANGE(Positionsnummer, PurchLine."POI Batch No.");
                    IF NOT EKAbrechnung.Findfirst() THEN BEGIN
                        EKAbrechnungHELP.INIT();
                        EKAbrechnungHELP.Bestellnummer := pr_PurchHeader."No.";
                        EKAbrechnungHELP.Zeilennummer := LastRecNo;
                        LastRecNo += 10000;
                        EKAbrechnungHELP.Positionsnummer := PurchLine."POI Batch No.";
                        EKAbrechnungHELP.Beschreibung := PurchLine.Description;
                        EKAbrechnungHELP.Abrechnungsmenge := PurchLine.Quantity;
                        EKAbrechnungHELP.Abrechnungspreis := PurchLine."Direct Unit Cost";
                        EKAbrechnungHELP.Gesamtpreis := PurchLine."Line Amount";
                        IF NOT PurchLine."Allow Invoice Disc." THEN
                            EKAbrechnungHELP."keinRg-Rabatt" := TRUE
                        ELSE
                            EKAbrechnungHELP."FAS Line Disc. Amount" :=
                              (PurchLine."Line Amount" * (PurchLine."Inv. Discount Amount" / PurchLine."Line Amount"));
                        EKAbrechnungHELP.Insert();
                    END ELSE
                        IF ChangeAllPos THEN BEGIN
                            EKAbrechnung.Beschreibung := PurchLine.Description;
                            EKAbrechnung.Abrechnungsmenge := PurchLine.Quantity;
                            EKAbrechnung.Abrechnungspreis := PurchLine."Direct Unit Cost";
                            EKAbrechnung.Gesamtpreis := PurchLine."Line Amount";
                            IF NOT EKAbrechnung."keinRg-Rabatt" THEN
                                EKAbrechnung."FAS Line Disc. Amount" :=
                                  (PurchLine."Line Amount" * (PurchLine."Inv. Discount Amount" / PurchLine."Line Amount"));
                            EKAbrechnung.Modify();
                        END;
                END;
            UNTIL PurchLine.Next() = 0;
    end;

    var
        lr_PurchLine: Record "Purchase Line";
        ltr_TempBuffer: Record "POI temp Buffer" temporary;
        ltr_TempBufferHELP: Record "POI temp Buffer" temporary;
        lr_SalesPrice: Record "Sales Price";
        MastBatch: Record "POI Master Batch";
        Batch: Record "POI Batch";
        SalesLine: Record "Sales Line";
        SalesPrice: Record "Sales Price";
        ItemLedEntry: Record "Item Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        PurchLine: Record "Purchase Line";
        EKAbrechnung: Record "POI EK-Abrechnung";
}

