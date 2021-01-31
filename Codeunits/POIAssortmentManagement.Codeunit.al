codeunit 5110329 "POI Assortment Management"
{

    //     trigger OnRun()
    //     begin
    //     end;

    //     procedure NewAssortmentVersion(vco_AssortmentCode: Code[10];vbn_Dialog: Boolean)
    //     var
    //         lrc_AssortmentVersion: Record "5110339";
    //         lrc_Assortment: Record "5110338";
    //         lfm_AssortmentVersionCard: Form "5088162";
    //         ADF_LT_TEXT001: Label 'Es ist kein Sortimentscode vorhanden!';
    //         lfm_AssortList: Form "5088160";
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zur Neuanlage einer Sortimentsversion
    //         // --------------------------------------------------------------------------

    //         IF vco_AssortmentCode = '' THEN BEGIN
    //           IF vbn_Dialog = TRUE THEN BEGIN
    //             lfm_AssortList.SETTABLEVIEW(lrc_Assortment);
    //             lfm_AssortList.LOOKUPMODE := TRUE;
    //             IF lfm_AssortList.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lfm_AssortList.GETRECORD(lrc_Assortment);
    //             vco_AssortmentCode := lrc_Assortment.Code;
    //           END ELSE BEGIN
    //             // Es ist kein Sortimentscode vorhanden!
    //             ERROR(ADF_LT_TEXT001);
    //           END;
    //         END;
    //         lrc_Assortment.GET(vco_AssortmentCode);

    //         lrc_AssortmentVersion.Reset();
    //         lrc_AssortmentVersion.INIT();
    //         lrc_AssortmentVersion."No." := '';
    //         lrc_AssortmentVersion.VALIDATE("Assortment Code",vco_AssortmentCode);
    //         lrc_AssortmentVersion."Header Standard Text Code" := lrc_Assortment."Header Standard Text Code";
    //         lrc_AssortmentVersion.INSERT(TRUE);
    //         COMMIT;

    //         lrc_AssortmentVersion.FILTERGROUP(2);
    //         lrc_AssortmentVersion.SETRANGE("No.",lrc_AssortmentVersion."No.");
    //         lrc_AssortmentVersion.FILTERGROUP(0);

    //         FORM.RUNMODAL(lrc_Assortment."Form ID Assortment Card",lrc_AssortmentVersion);
    //     end;

    //     procedure ShowAssortmentVersion(vco_AssortmentCode: Code[10])
    //     var
    //         lrc_AssortmentVersion: Record "5110339";
    //         lfm_AssortmentVersionList: Form "5088161";
    //         ADF_LT_TEXT001: Label 'Es wurde kein Sortiment übergeben!';
    //         ADF_LT_TEXT002: Label 'Es ist keine Sortimentsversion vorhanden! Neuanlage?';
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Sortimentsversionen
    //         // --------------------------------------------------------------------------

    //         IF vco_AssortmentCode = '' THEN
    //           // Es wurde kein Sortiment übergeben!
    //           ERROR(ADF_LT_TEXT001);

    //         lrc_AssortmentVersion.FILTERGROUP(2);
    //         lrc_AssortmentVersion.SETRANGE("Assortment Code",vco_AssortmentCode);
    //         lrc_AssortmentVersion.FILTERGROUP(0);
    //         IF NOT lrc_AssortmentVersion.FINDFIRST() THEN BEGIN
    //           // Es ist keine Sortimentsversion vorhanden! Neuanlage?
    //           IF NOT CONFIRM(ADF_LT_TEXT002) THEN
    //             ERROR('');

    //           NewAssortmentVersion(vco_AssortmentCode,FALSE);

    //           lrc_AssortmentVersion.FILTERGROUP(2);
    //           lrc_AssortmentVersion.SETRANGE("Assortment Code",vco_AssortmentCode);
    //           lrc_AssortmentVersion.FILTERGROUP(0);
    //         END;

    //         lfm_AssortmentVersionList.SETTABLEVIEW(lrc_AssortmentVersion);
    //         lfm_AssortmentVersionList.RUN;
    //     end;

    //     procedure ShowAssortmentVersionCard(vco_AssortmentVersionNo: Code[20])
    //     var
    //         lrc_Assortment: Record "5110338";
    //         lrc_AssortmentVersion: Record "5110339";
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zur Anzeige Sortimentsversionskarte
    //         // --------------------------------------------------------------------------

    //         lrc_AssortmentVersion.SETRANGE("No.",vco_AssortmentVersionNo);
    //         lrc_AssortmentVersion.FINDFIRST;

    //         // Preisdatum auf heutiges Datum setzen
    //         IF (lrc_AssortmentVersion."Starting Date Price" < TODAY) AND
    //            (lrc_AssortmentVersion."Ending Date Assortment" >= TODAY) THEN BEGIN
    //           IF lrc_AssortmentVersion."Starting Date Price" <> TODAY THEN BEGIN
    //             lrc_AssortmentVersion.VALIDATE("Starting Date Price",TODAY);
    //             lrc_AssortmentVersion.Modify();
    //             COMMIT;
    //           END;
    //         END;

    //         lrc_Assortment.GET(lrc_AssortmentVersion."Assortment Code");
    //         lrc_Assortment.TESTFIELD("Form ID Assortment Card");

    //         FORM.RUN(lrc_Assortment."Form ID Assortment Card",lrc_AssortmentVersion);
    //     end;

    procedure EnterDetailInVersionLine(vrc_AssortmentVersionLine: Record "POI Assortment Version Line"; vin_CurrentFieldNo: Integer)
    var
        lrc_AssortVersionLineDetail: Record "POI Assort Version Line Detail";
    begin
        // --------------------------------------------------------------------------
        //
        // --------------------------------------------------------------------------

        lrc_AssortVersionLineDetail.SETRANGE("Assortment Version No.", vrc_AssortmentVersionLine."Assortment Version No.");
        lrc_AssortVersionLineDetail.SETRANGE("Assortment Version Line No.", vrc_AssortmentVersionLine."Line No.");

        CASE vin_CurrentFieldNo OF
            vrc_AssortmentVersionLine.FIELDNO("Variety Code"):
                lrc_AssortVersionLineDetail.SETRANGE(Type, lrc_AssortVersionLineDetail.Type::Variety);
            vrc_AssortmentVersionLine.FIELDNO("Caliber Code"):
                lrc_AssortVersionLineDetail.SETRANGE(Type, lrc_AssortVersionLineDetail.Type::Caliber);
            vrc_AssortmentVersionLine.FIELDNO("Empties Item No."):
                lrc_AssortVersionLineDetail.SETRANGE(Type, lrc_AssortVersionLineDetail.Type::"Empties Item No.");
            ELSE
                EXIT;
        END;

        Page.RUNMODAL(0, lrc_AssortVersionLineDetail);
    end;

    //     procedure CopyAssortment(vrc_ToAssortmentVersion: Record "5110339")
    //     var
    //         lrc_FruitVisionTempI: Record "5110360";
    //         lrc_FromAssortmentVersion: Record "5110339";
    //         lrc_FromAssortmentVersionLine: Record "5110340";
    //         lrc_ToAssortmentVersionLine: Record "5110340";
    //         lrc_AssortCustPriceGroup: Record "5110341";
    //         lrc_FromSalesPrice: Record "7002";
    //         lrc_ToSalesPrice: Record "7002";
    //         lrc_BatchVariant: Record "5110366";
    //         lfm_CopyAssortment: Form "5088169";
    //         lin_LineNo: Integer;
    //         Text001: Label 'Sortiment kann nicht in sich selbst kopiert werden!';
    //         TEXT002: Label 'Es sind bereits Sortimentszeilen vorhanden! Löschen?';
    //         lrc_CustomerPriceGroup: Record "6";
    //         ADF_LT_TEXT003: Label 'Kopieren eines zukünftigen Sortimentes in ein verganges Sortiment nicht zulässig!';
    //         ADF_LT_TEXT004: Label 'Startdatum für das neue Sortiment liegt in der Vergangenheit! Trotzdem kopieren?';
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zum Kopieren eines Sortiments
    //         // --------------------------------------------------------------------------

    //         // Felder prüfen Zielsortiment
    //         vrc_ToAssortmentVersion.TESTFIELD("Assortment Code");
    //         vrc_ToAssortmentVersion.TESTFIELD("Starting Date Assortment");
    //         vrc_ToAssortmentVersion.TESTFIELD("Ending Date Assortment");

    //         lrc_ToAssortmentVersionLine.Reset();
    //         lrc_ToAssortmentVersionLine.SETRANGE("Assortment Version No.",vrc_ToAssortmentVersion."No.");
    //         IF NOT lrc_ToAssortmentVersionLine.isempty()THEN BEGIN
    //           // Es sind bereits Sortimentszeilen vorhanden! Löschen?
    //           IF CONFIRM(TEXT002) THEN
    //             lrc_ToAssortmentVersionLine.DELETEALL();
    //         END;

    //         // Herkunftssortiment auswählen
    //         lrc_FruitVisionTempI.Reset();
    //         lrc_FruitVisionTempI.SETRANGE("User ID",UserID());
    //         lrc_FruitVisionTempI.SETRANGE("Entry Type",lrc_FruitVisionTempI."Entry Type"::SK);
    //         lrc_FruitVisionTempI.DELETEALL();

    //         lrc_FruitVisionTempI.Reset();
    //         lrc_FruitVisionTempI.INIT();
    //         lrc_FruitVisionTempI."User ID" := USERID;
    //         lrc_FruitVisionTempI."Entry Type" := lrc_FruitVisionTempI."Entry Type"::SK;
    //         lrc_FruitVisionTempI."Entry No." := 0;
    //         lrc_FruitVisionTempI."SK Copy to Assortment Vers." := vrc_ToAssortmentVersion."No.";
    //         lrc_FruitVisionTempI."SK Copy to Valid From" := vrc_ToAssortmentVersion."Starting Date Assortment";
    //         lrc_FruitVisionTempI."SK Copy to Valid To" := vrc_ToAssortmentVersion."Ending Date Assortment";
    //         lrc_FruitVisionTempI."SK Copy Price" := TRUE;
    //         lrc_FruitVisionTempI.INSERT(TRUE);
    //         COMMIT;

    //         lrc_FruitVisionTempI.FILTERGROUP(2);
    //         lrc_FruitVisionTempI.SETRANGE("User ID",UserID());
    //         lrc_FruitVisionTempI.SETRANGE("Entry Type",lrc_FruitVisionTempI."Entry Type"::SK);
    //         lrc_FruitVisionTempI.FILTERGROUP(0);

    //         lfm_CopyAssortment.LOOKUPMODE := TRUE;
    //         lfm_CopyAssortment.SETTABLEVIEW(lrc_FruitVisionTempI);
    //         IF lfm_CopyAssortment.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_FruitVisionTempI.Reset();
    //         lrc_FruitVisionTempI.SETRANGE("User ID",UserID());
    //         lrc_FruitVisionTempI.SETRANGE("Entry Type",lrc_FruitVisionTempI."Entry Type"::SK);
    //         lrc_FruitVisionTempI.FINDFIRST;
    //         lrc_FruitVisionTempI.TESTFIELD("SK Copy from Assortment Vers.");
    //         IF (lrc_FruitVisionTempI."SK Copy to Assortment Vers." =
    //             lrc_FruitVisionTempI."SK Copy from Assortment Vers.") THEN
    //           // Sortiment kann nicht in sich selbst kopiert werden!
    //           ERROR(Text001);

    //         // Herkunftssortiment lesen
    //         lrc_FromAssortmentVersion.GET(lrc_FruitVisionTempI."SK Copy from Assortment Vers.");

    //         IF lrc_FromAssortmentVersion."Assortment Code" = vrc_ToAssortmentVersion."Assortment Code" THEN BEGIN
    //           IF vrc_ToAssortmentVersion."Starting Date Assortment" < lrc_FromAssortmentVersion."Starting Date Assortment" THEN
    //             // Kopieren eines zukünftigen Sortimentes in ein verganges Sortiment nicht zulässig!
    //             ERROR(ADF_LT_TEXT003);
    //         END;
    //         IF vrc_ToAssortmentVersion."Starting Date Assortment" < TODAY THEN BEGIN
    //           // Startdatum für das neue Sortiment liegt in der Vergangenheit! Trotzdem kopieren?
    //           IF NOT CONFIRM(ADF_LT_TEXT004) THEN
    //             EXIT;
    //         END;

    //         // Letzte Zeile Zielsortiment ermitteln
    //         lrc_ToAssortmentVersionLine.Reset();
    //         lrc_ToAssortmentVersionLine.SETRANGE("Assortment Version No.",vrc_ToAssortmentVersion."No.");
    //         IF lrc_ToAssortmentVersionLine.FINDLAST THEN
    //           lin_LineNo := lrc_ToAssortmentVersionLine."Line No."
    //         ELSE
    //           lin_LineNo := 0;

    //         // Sortimentszeilen und Preise kopieren
    //         lrc_FromAssortmentVersionLine.Reset();
    //         lrc_FromAssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_FromAssortmentVersion."No.");
    //         IF lrc_FromAssortmentVersionLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             // Kopiere Sortimentszeilen
    //             lrc_ToAssortmentVersionLine.Reset();
    //             lrc_ToAssortmentVersionLine.INIT();
    //             lrc_ToAssortmentVersionLine.TRANSFERFIELDS(lrc_FromAssortmentVersionLine);
    //             lrc_ToAssortmentVersionLine."Assortment Version No." := vrc_ToAssortmentVersion."No.";
    //             lin_LineNo := lin_LineNo + 10000;
    //             lrc_ToAssortmentVersionLine."Line No." := lin_LineNo;
    //             lrc_ToAssortmentVersionLine."Assortment Code" := vrc_ToAssortmentVersion."Assortment Code";
    //             lrc_ToAssortmentVersionLine."Starting Date Assortment" := vrc_ToAssortmentVersion."Starting Date Assortment";
    //             lrc_ToAssortmentVersionLine."Ending Date Assortment" := vrc_ToAssortmentVersion."Ending Date Assortment";
    //             lrc_ToAssortmentVersionLine."Currency Code" := vrc_ToAssortmentVersion."Currency Code";
    //             IF lrc_ToAssortmentVersionLine."Batch Variant No." <> '' THEN BEGIN
    //               IF lrc_BatchVariant.GET(lrc_ToAssortmentVersionLine."Batch Variant No.") THEN BEGIN
    //                 IF lrc_BatchVariant.Source = lrc_BatchVariant.Source::Assortment THEN BEGIN
    //                   lrc_ToAssortmentVersionLine."Batch Variant No." := '';
    //                   lrc_ToAssortmentVersionLine."Batch No." := '';
    //                   lrc_ToAssortmentVersionLine."Master Batch No." := '';
    //                 END;
    //               END ELSE BEGIN
    //                 lrc_ToAssortmentVersionLine."Batch Variant No." := '';
    //                 lrc_ToAssortmentVersionLine."Batch No." := '';
    //                 lrc_ToAssortmentVersionLine."Master Batch No." := '';
    //               END;
    //             END;
    //             lrc_ToAssortmentVersionLine.insert();

    //             // Alle zugeordneten Preislisten lesen und kopieren
    //             IF lrc_FruitVisionTempI."SK Copy Price" = TRUE THEN BEGIN
    //               lrc_AssortCustPriceGroup.SETRANGE("Assortment Code",vrc_ToAssortmentVersion."Assortment Code");
    //               IF lrc_AssortCustPriceGroup.FIND('-') THEN
    //                 REPEAT
    //                   // Kopiere Sortimentspreise
    //                   lrc_FromSalesPrice.SETRANGE("Item No.",lrc_FromAssortmentVersionLine."Item No.");
    //                   lrc_FromSalesPrice.SETRANGE("Sales Type",lrc_FromSalesPrice."Sales Type"::"Customer Price Group");
    //                   lrc_FromSalesPrice.SETRANGE("Sales Code",lrc_AssortCustPriceGroup."Customer Price Group Code");
    //                   lrc_FromSalesPrice.SETRANGE("Currency Code",lrc_FromAssortmentVersion."Currency Code");
    //                   lrc_FromSalesPrice.SETRANGE("Variant Code",lrc_FromAssortmentVersionLine."Variant Code");
    //                   lrc_FromSalesPrice.SETRANGE("Unit of Measure Code",lrc_FromAssortmentVersionLine."Sales Price Unit of Measure");

    //                   lrc_FromSalesPrice.SETFILTER("Starting Date",'<=%1',vrc_ToAssortmentVersion."Starting Date Assortment");
    //                   // Auch das Endedatum mit abfragen als Filterkriterium
    //                   lrc_FromSalesPrice.SETFILTER("Starting Date",'<=%1',lrc_FromAssortmentVersion."Ending Date Assortment");
    //                   lrc_FromSalesPrice.SETFILTER("Ending Date",'>=%1|%2',lrc_FromAssortmentVersion."Starting Date Assortment",0D);

    //                   IF lrc_CustomerPriceGroup.GET(lrc_AssortCustPriceGroup."Customer Price Group Code") THEN BEGIN
    //                     CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                       lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                          "plus Vendor No":
    //                         BEGIN
    //                           lrc_FromSalesPrice.SETRANGE("Vendor No.",lrc_FromAssortmentVersionLine."Vendor No.");
    //                         END;
    //                       lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                          "plus Assortment Version and Line No":
    //                         BEGIN
    //                           lrc_FromSalesPrice.SETRANGE("Assort. Version No.",
    //                                                       lrc_FromAssortmentVersionLine."Assortment Version No.");
    //                           lrc_FromSalesPrice.SETRANGE("Assort. Version Line No.",
    //                                                       lrc_FromAssortmentVersionLine."Line No." );
    //                         END;
    //                     END;
    //                   END;

    //                   // ACHTUNG EVENTUELL DURCH EINE ABFRAGE ERGÄNZEN OB DIE DEBITORSPEZIFISCHEN PREISE KOPIERT WERDEN SOLLEN
    //                   lrc_FromSalesPrice.SETRANGE("Customer No.",'');

    //                   IF lrc_FromSalesPrice.FINDLAST THEN BEGIN
    //                     lrc_ToSalesPrice.TRANSFERFIELDS(lrc_FromSalesPrice);
    //                     lrc_ToSalesPrice."Starting Date" := vrc_ToAssortmentVersion."Starting Date Assortment";
    //                     lrc_ToSalesPrice."Ending Date" := vrc_ToAssortmentVersion."Ending Date Assortment";
    //                     lrc_ToSalesPrice."Vendor No." := '';
    //                     lrc_ToSalesPrice."Assort. Version No." := '';
    //                     lrc_ToSalesPrice."Assort. Version Line No." := 0;
    //                     IF lrc_CustomerPriceGroup.GET( lrc_AssortCustPriceGroup."Customer Price Group Code" ) THEN BEGIN
    //                       CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                         lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"plus Vendor No":
    //                           BEGIN
    //                             lrc_ToSalesPrice. "Vendor No." := lrc_FromAssortmentVersionLine."Vendor No.";
    //                           END;
    //                         lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"plus Assortment Version and Line No":
    //                           BEGIN
    //                             lrc_ToSalesPrice."Assort. Version No." :=
    //                                 lrc_ToAssortmentVersionLine."Assortment Version No.";
    //                             lrc_ToSalesPrice."Assort. Version Line No." :=
    //                                 lrc_ToAssortmentVersionLine."Line No.";
    //                           END;
    //                       END;
    //                     END;

    //                     IF NOT lrc_ToSalesPrice.INSERT THEN;
    //                   END;
    //                 UNTIL lrc_AssortCustPriceGroup.NEXT() = 0;
    //             END;

    //           UNTIL lrc_FromAssortmentVersionLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure CopyItemIntoAssortments(vrc_AssortmentVersionLine: Record "5110340")
    //     var
    //         lrc_Assortment: Record "5110338";
    //         lrc_AssortmentVersion: Record "5110339";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_AssortmentValidVersions: Record "5110739";
    //         lfm_AssortmentValidVersions: Form "5088171";
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Funktion zum Kopieren eines Artikels aus einem Sortiment in andere Sortimente
    //         // --------------------------------------------------------------------------------

    //         lrc_AssortmentValidVersions.Reset();
    //         lrc_AssortmentValidVersions.SETRANGE("User ID",UserID());
    //         lrc_AssortmentValidVersions.SETRANGE("Entry Type",lrc_AssortmentValidVersions."Entry Type"::"Assort. Version");
    //         lrc_AssortmentValidVersions.DELETEALL();

    //         lrc_AssortmentVersion.Reset();
    //         lrc_AssortmentVersion.SETFILTER("Ending Date Assortment",'>=%1',TODAY);
    //         lrc_AssortmentVersion.SETFILTER("No.",'<>%1',vrc_AssortmentVersionLine."Assortment Version No.");
    //         IF lrc_AssortmentVersion.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             IF lrc_AssortmentVersion."No." <> vrc_AssortmentVersionLine."Assortment Version No." THEN BEGIN
    //               lrc_AssortmentValidVersions.Reset();
    //               lrc_AssortmentValidVersions.INIT();
    //               lrc_AssortmentValidVersions."User ID" := USERID;
    //               lrc_AssortmentValidVersions."Entry Type" := lrc_AssortmentValidVersions."Entry Type"::"Assort. Version";
    //               lrc_AssortmentValidVersions."Assortment Version No." := lrc_AssortmentVersion."No.";
    //               lrc_AssortmentValidVersions."Assortment Code" := lrc_AssortmentVersion."Assortment Code";
    //               lrc_Assortment.GET(lrc_AssortmentVersion."Assortment Code");
    //               lrc_AssortmentValidVersions."Assortment Description" := lrc_Assortment.Description;
    //               lrc_AssortmentValidVersions."Starting Date Assortment" := lrc_AssortmentVersion."Starting Date Assortment";
    //               lrc_AssortmentValidVersions."Ending Date Assortment" := lrc_AssortmentVersion."Ending Date Assortment";

    //               // Kontrolle ob Artikel bereits im Sortiment vorhanden ist
    //               lrc_AssortmentVersionLine.Reset();
    //               lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortmentValidVersions."Assortment Version No.");
    //               lrc_AssortmentVersionLine.SETRANGE(Type,lrc_AssortmentVersionLine.Type::Item);
    //               lrc_AssortmentVersionLine.SETRANGE("Item No.",vrc_AssortmentVersionLine."Item No.");
    //               IF lrc_AssortmentVersionLine.FINDFIRST() THEN
    //                 lrc_AssortmentValidVersions."Item in Assortment" := TRUE
    //               ELSE
    //                 lrc_AssortmentValidVersions."Item in Assortment" := FALSE;

    //               lrc_AssortmentValidVersions.insert();
    //             END;

    //           UNTIL lrc_AssortmentVersion.NEXT() = 0;
    //         END;
    //         COMMIT;

    //         // Sortimente anzeigen
    //         lrc_AssortmentValidVersions.FILTERGROUP(2);
    //         lrc_AssortmentValidVersions.SETRANGE("User ID",UserID());
    //         lrc_AssortmentValidVersions.SETRANGE("Entry Type",lrc_AssortmentValidVersions."Entry Type"::"Assort. Version");
    //         lrc_AssortmentValidVersions.FILTERGROUP(0);

    //         lfm_AssortmentValidVersions.SETTABLEVIEW(lrc_AssortmentValidVersions);
    //         lfm_AssortmentValidVersions.LOOKUPMODE := TRUE;
    //         IF lfm_AssortmentValidVersions.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         // Änderungen durchführen
    //         lrc_AssortmentValidVersions.Reset();
    //         lrc_AssortmentValidVersions.SETRANGE("User ID",UserID());
    //         lrc_AssortmentValidVersions.SETRANGE("Entry Type",lrc_AssortmentValidVersions."Entry Type"::"Assort. Version");
    //         IF lrc_AssortmentValidVersions.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             // Kontrolle ob Artikel bereits im Sortiment vorhanden ist
    //             lrc_AssortmentVersionLine.Reset();
    //             lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortmentValidVersions."Assortment Version No.");
    //             lrc_AssortmentVersionLine.SETRANGE(Type,lrc_AssortmentVersionLine.Type::Item);
    //             lrc_AssortmentVersionLine.SETRANGE("Item No.",vrc_AssortmentVersionLine."Item No.");
    //             IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN
    //               IF lrc_AssortmentValidVersions."Item in Assortment" = FALSE THEN BEGIN
    //                 // Artikelzeile(n) aus Sortiment löschen
    //                 lrc_AssortmentVersionLine.DELETEALL(TRUE);
    //               END;
    //             END ELSE BEGIN
    //               IF lrc_AssortmentValidVersions."Item in Assortment" = TRUE THEN BEGIN
    //                 // Artikelzeile in Sortiment einfügen
    //                 lrc_AssortmentVersionLine.Reset();
    //                 lrc_AssortmentVersionLine.INIT();
    //                 lrc_AssortmentVersionLine.TRANSFERFIELDS(vrc_AssortmentVersionLine);
    //                 lrc_AssortmentVersionLine."Assortment Version No." := lrc_AssortmentValidVersions."Assortment Version No.";
    //                 lrc_AssortmentVersionLine."Line No." := 0;
    //                 lrc_AssortmentVersionLine."Assortment Code" := lrc_AssortmentValidVersions."Assortment Code";
    //                 lrc_AssortmentVersionLine."Starting Date Assortment" := lrc_AssortmentValidVersions."Starting Date Assortment";
    //                 lrc_AssortmentVersionLine."Ending Date Assortment" := lrc_AssortmentValidVersions."Ending Date Assortment";
    //                 lrc_AssortmentVersionLine."Currency Code" := '';
    //                 lrc_AssortmentVersionLine.insert();
    //               END;
    //             END;
    //           UNTIL lrc_AssortmentValidVersions.NEXT() = 0;
    //         END;
    //     end;

    //     procedure LoadAssortFromItemStock()
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zum Aufbau eines Sortimentes auf Basis der Artikel im Bestand
    //         // --------------------------------------------------------------------------
    //     end;

    //     procedure LoadAssortFromBatchVarStock(vco_AssortVersionNo: Code[20])
    //     var
    //         lrc_LoadAssortfromBatchVar: Report "5110513";
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zum Aufbau eines Sortimentes auf Basis der Partievarianten
    //         // --------------------------------------------------------------------------

    //         lrc_LoadAssortfromBatchVar.SetGlobals(vco_AssortVersionNo);
    //         lrc_LoadAssortfromBatchVar.RUNMODAL;
    //     end;

    //     procedure LoadAssortFromPlaning()
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zum Aufbau eines Sortimentes auf Basis der Plandaten
    //         // --------------------------------------------------------------------------
    //     end;

    //     procedure SelectLoadAssortIntoSalesOrder(vrc_SalesHdr: Record "36")
    //     var
    //         lrc_Assort: Record "5110338";
    //         lrc_AssortVersion: Record "5110339";
    //         lrc_CustAssort: Record "5110342";
    //         lrc_Customer: Record "Customer";
    //         lfm_CustAssort: Form "5088168";
    //         lfm_AssortList: Form "5088160";
    //         lbn_LoadAssortment: Boolean;
    //         Text01: Label 'Nur für Verkaufsaufträge zulässig!';
    //         Text02: Label 'Es sind keine Sortimente zum Laden vorhanden / ausgewählt!';
    //         ldt_AssortmentDate: Date;
    //         Text03: Label 'Es sind keine zugeordneten Sortimente vorhanden!';
    //         Text04: Label 'Es ist keine gültige Sortimentsversion vorhanden!';
    //     begin
    //         // ------------------------------------------------------------------------------
    //         // Funktion zur Auswahl und zum Laden eines Sortimentes in einen Verkaufsauftrag
    //         // ------------------------------------------------------------------------------

    //         IF vrc_SalesHdr."Document Type" <> vrc_SalesHdr."Document Type"::Order THEN
    //           // Nur für Verkaufsaufträge zulässig!
    //           ERROR(Text01);

    //         // Felder auf Inhalt prüfen
    //         vrc_SalesHdr.TESTFIELD("Order Date");
    //         vrc_SalesHdr.TESTFIELD("Posting Date");
    //         vrc_SalesHdr.TESTFIELD("Shipment Date");
    //         vrc_SalesHdr.TESTFIELD("Promised Delivery Date");

    //         // Zugeordnete Sortimente ermitteln
    //         lrc_Customer.GET(vrc_SalesHdr."Sell-to Customer No.");
    //         IF lrc_Customer."Chain Name" <> '' THEN BEGIN
    //           lrc_CustAssort.SETFILTER("Source No.",'%1|%2',lrc_Customer."No.",lrc_Customer."Chain Name");
    //         END ELSE BEGIN
    //           lrc_CustAssort.SETRANGE(Source,lrc_CustAssort.Source::Customer);
    //           lrc_CustAssort.SETRANGE("Source No.",lrc_Customer."No.");
    //         END;

    //         // Eingrenzung auf Verkaufsbelegart
    //         lrc_CustAssort.SETFILTER("Sales Doc. Type",'%1|%2',vrc_SalesHdr."Document Type",lrc_CustAssort."Sales Doc. Type"::None);
    //         lrc_CustAssort.SETFILTER("Sales Doc. Subtype Code",'%1|%2',vrc_SalesHdr."Sales Doc. Subtype Code",'');

    //         CASE lrc_CustAssort.COUNT OF
    //         // Es sind keine Sortimente zugeordnet
    //         0:
    //           BEGIN
    //             // Es sind keine zugeordneten Sortimente vorhanden!
    //             ERROR(Text03);
    //           END;

    //         // Es ist ein Sortiment zugeordnet
    //         1:
    //           BEGIN
    //             lrc_CustAssort.FIND('-');
    //             lrc_Assort.GET(lrc_CustAssort."Assortment Code");
    //             ldt_AssortmentDate := GetRefDateValidAssortSalesHdr(vrc_SalesHdr,lrc_Assort);

    //             lrc_AssortVersion.Reset();
    //             lrc_AssortVersion.SETRANGE("Assortment Code",lrc_CustAssort."Assortment Code");
    //             lrc_AssortVersion.SETFILTER("Starting Date Assortment",'<=%1',ldt_AssortmentDate);
    //             lrc_AssortVersion.SETFILTER("Ending Date Assortment",'>=%1|%2',ldt_AssortmentDate,0D);
    //             IF lrc_AssortVersion.FIND('+') THEN
    //               lbn_LoadAssortment := TRUE
    //             ELSE
    //               // Es ist keine gültige Sortimentsversion vorhanden!
    //               ERROR(Text04);
    //           END;

    //         // Es sind mehrere Sortimente zugeordnet
    //         2,3,4,5,6,7,8,9,10:
    //           BEGIN
    //             // Sortiment auswählen
    //             lrc_CustAssort.Reset();
    //             lrc_CustAssort.FILTERGROUP(2);
    //             IF lrc_Customer."Chain Name" <> '' THEN BEGIN
    //               lrc_CustAssort.SETFILTER("Source No.",'%1|%2',lrc_Customer."No.",lrc_Customer."Chain Name")
    //             END ELSE BEGIN
    //               lrc_CustAssort.SETRANGE(Source,lrc_CustAssort.Source::Customer);
    //               lrc_CustAssort.SETRANGE("Source No.",lrc_Customer."No.");
    //             END;
    //             lrc_CustAssort.FILTERGROUP(0);

    //             lfm_CustAssort.SETTABLEVIEW(lrc_CustAssort);
    //             lfm_CustAssort.LOOKUPMODE := TRUE;
    //             IF lfm_CustAssort.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lrc_CustAssort.Reset();
    //             lfm_CustAssort.GETRECORD(lrc_CustAssort);

    //             lrc_Assort.GET(lrc_CustAssort."Assortment Code");
    //             ldt_AssortmentDate := GetRefDateValidAssortSalesHdr(vrc_SalesHdr,lrc_Assort);

    //             lrc_AssortVersion.Reset();
    //             lrc_AssortVersion.SETRANGE("Assortment Code",lrc_CustAssort."Assortment Code");
    //             lrc_AssortVersion.SETFILTER("Starting Date Assortment",'<=%1',ldt_AssortmentDate);
    //             lrc_AssortVersion.SETFILTER("Ending Date Assortment",'>=%1|%2',ldt_AssortmentDate,0D);
    //             IF lrc_AssortVersion.FIND('+') THEN
    //               lbn_LoadAssortment := TRUE
    //             ELSE
    //               // Es ist keine gültige Sortimentsversion vorhanden!
    //               ERROR(Text04);
    //           END;
    //         END;

    //         IF lbn_LoadAssortment = FALSE THEN
    //           // Es sind keine Sortimente zum Laden vorhanden / ausgewählt!
    //           ERROR(Text02);

    //         // ---------------------------------------------------------------------------------------
    //         // Sortiment in Verkaufsauftrag laden
    //         // ---------------------------------------------------------------------------------------
    //         LoadAssortIntoSalesOrder(vrc_SalesHdr,lrc_AssortVersion."No.");
    //     end;

    //     procedure LoadAssortIntoSalesOrder(vrc_SalesHdr: Record "36";vco_AssortVersionCode: Code[20])
    //     var
    //         lcu_Sales: Codeunit "5110324";
    //         lrc_Assort: Record "5110338";
    //         lrc_AssortVersion: Record "5110339";
    //         lrc_AssortLine: Record "5110340";
    //         lrc_SalesLine: Record "37";
    //         lin_LineNo: Integer;
    //         Text01: Label 'Nur für Verkaufsaufträge zulässig!';
    //         Text02: Label 'Es sind keine Sortimente zum Laden vorhanden!';
    //     begin
    //         // --------------------------------------------------------------------------
    //         // Funktion zum Laden eines Sortiments in einen Verkaufsauftrag
    //         // --------------------------------------------------------------------------

    //         IF vrc_SalesHdr."Document Type" <> vrc_SalesHdr."Document Type"::Order THEN
    //           // Nur für Verkaufsaufträge zulässig!
    //           ERROR(Text01);

    //         // Lesen Sortimentsversion
    //         lrc_AssortVersion.GET(vco_AssortVersionCode);

    //         // Lesen Sortiment
    //         lrc_Assort.GET(lrc_AssortVersion."Assortment Code");

    //         // Letzte Zeilennummer des bezogenen Beleges ermitteln
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHdr."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHdr."No.");
    //         IF lrc_SalesLine.FIND('+') THEN
    //           lin_LineNo := lrc_SalesLine."Line No."
    //         ELSE
    //           lin_LineNo := 0;

    //         // Sortimentszeilen lesen
    //         lrc_AssortLine.Reset();
    //         lrc_AssortLine.SETCURRENTKEY("Sort Sequence");
    //         lrc_AssortLine.SETRANGE("Assortment Version No.",lrc_AssortVersion."No.");
    //         lrc_AssortLine.SETFILTER("Item No.",'<>%1','');
    //         IF lrc_AssortLine.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Kontrolle ob Artikel bereits vorhanden
    //             lrc_SalesLine.Reset();
    //             lrc_SalesLine.SETCURRENTKEY("Document Type","Document No.",Type,"No.",Subtyp,"Item Typ");
    //             lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHdr."Document Type");
    //             lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHdr."No.");
    //             lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //             lrc_SalesLine.SETRANGE("No.",lrc_AssortLine."Item No.");
    //             IF NOT lrc_SalesLine.FIND('-') THEN BEGIN

    //               // Neue Zeile hinzufügen
    //               lrc_SalesLine.Reset();
    //               lrc_SalesLine.INIT();
    //               lrc_SalesLine.VALIDATE("Document Type",vrc_SalesHdr."Document Type");
    //               lrc_SalesLine.VALIDATE("Document No.",vrc_SalesHdr."No.");
    //               lin_LineNo := lin_LineNo + 10000;
    //               lrc_SalesLine."Line No." := lin_LineNo;
    //               lrc_SalesLine.INSERT(TRUE);

    //               lrc_SalesLine.VALIDATE("Sell-to Customer No.",vrc_SalesHdr."Sell-to Customer No.");
    //               lrc_SalesLine.VALIDATE("Bill-to Customer No.",vrc_SalesHdr."Bill-to Customer No.");
    //               lrc_SalesLine."Shipment Date" := vrc_SalesHdr."Shipment Date";
    //               lrc_SalesLine."Promised Delivery Date" := vrc_SalesHdr."Promised Delivery Date";

    //               lrc_SalesLine.VALIDATE(Type,lrc_SalesLine.Type::Item);
    //               lrc_SalesLine.VALIDATE("No.",lrc_AssortLine."Item No.");
    //               lrc_SalesLine.VALIDATE("Unit of Measure Code",lrc_AssortLine."Sales Unit of Measure Code");
    //               lrc_SalesLine.VALIDATE("Price Base (Sales Price)",lrc_AssortLine."Price Base (Sales Price)");

    //               lrc_SalesLine."Shop Sales Price" := lcu_Sales.CalcOutletUnitPrice(lrc_SalesLine);

    //               lrc_SalesLine.VALIDATE("Shipment Date",vrc_SalesHdr."Shipment Date");
    //               lrc_SalesLine."Requested Delivery Date" := vrc_SalesHdr."Promised Delivery Date";
    //               lrc_SalesLine.VALIDATE("Promised Delivery Date",vrc_SalesHdr."Promised Delivery Date");

    //               lrc_SalesLine."Assortment Version No." := lrc_AssortLine."Assortment Version No.";
    //               lrc_SalesLine."Assortment Version Line No." := lrc_AssortLine."Line No.";

    //               IF lrc_AssortLine."Vendor No." <> '' THEN
    //                 lrc_SalesLine.VALIDATE("Buy-from Vendor No.", lrc_AssortLine."Vendor No.");

    //               lrc_SalesLine."Manufacturer Code" := lrc_AssortLine."Manufacturer No.";

    //               // FV START 180707
    //               lrc_SalesLine."Blocked for Sale" := lrc_AssortLine."Blocked for Sale";
    //               // FV ENDE

    //               lrc_SalesLine.Modify();

    //             END ELSE BEGIN
    //               // Bestehende Zeile aktualisieren

    //             END;

    //           UNTIL lrc_AssortLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure AssortInputSalesOrder(vrc_SalesHdr: Record "36")
    //     var
    //         lcu_Sales: Codeunit "5110324";
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_AssortmentSalesInput: Record "5110343";
    //         lrc_Assort: Record "5110338";
    //         lrc_AssortVersion: Record "5110339";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_CustAssort: Record "5110342";
    //         lrc_Customer: Record "Customer";
    //         lrc_SalesLine: Record "37";
    //         lrc_FruitVisionTempI: Record "5110360";
    //         lfm_CustAssort: Form "5088168";
    //         lfm_AssortList: Form "5088160";
    //         lfm_AssortmentSalesInput: Form "5110481";
    //         lbn_LoadAssortment: Boolean;
    //         lin_LineNo: Integer;
    //         ldt_AssortmentDate: Date;
    //         AGILES_LT_TEXT001: Label 'Status muss offen sein!';
    //         AGILES_LT_TEXT002: Label 'Es sind keine zugeordneten Sortimente vorhanden!';
    //         AGILES_LT_TEXT003: Label 'Es ist keine gültige Sortimentsversion vorhanden!';
    //         AGILES_LT_TEXT004: Label 'Es ist keine gültige Sortimentsversion zum %1 vorhanden!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Erfassung der Sortimentsmengen im Verkaufsauftrag
    //         // -----------------------------------------------------------------------------

    //         vrc_SalesHdr.TESTFIELD("Order Date");
    //         vrc_SalesHdr.TESTFIELD("Shipment Date");
    //         vrc_SalesHdr.TESTFIELD("Promised Delivery Date");

    //         IF vrc_SalesHdr.Status <> vrc_SalesHdr.Status::Open THEN
    //           // Status muss offen sein!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_Customer.GET(vrc_SalesHdr."Sell-to Customer No.");

    //         IF lrc_Customer."Chain Name" <> '' THEN BEGIN
    //           lrc_CustAssort.SETFILTER("Source No.",'%1|%2',lrc_Customer."No.",lrc_Customer."Chain Name");
    //         END ELSE BEGIN
    //           lrc_CustAssort.SETRANGE(Source,lrc_CustAssort.Source::Customer);
    //           lrc_CustAssort.SETRANGE("Source No.",lrc_Customer."No.");
    //         END;

    //         // Eingrenzung auf Verkaufsbelegart
    //         lrc_CustAssort.SETFILTER("Sales Doc. Type",'%1|%2',vrc_SalesHdr."Document Type",lrc_CustAssort."Sales Doc. Type"::None);
    //         lrc_CustAssort.SETFILTER("Sales Doc. Subtype Code",'%1|%2',vrc_SalesHdr."Sales Doc. Subtype Code",'');

    //         CASE lrc_CustAssort.COUNT OF
    //         // Es sind keine Sortimente zugeordnet
    //         0:
    //           BEGIN
    //             // Es sind keine zugeordneten Sortimente vorhanden!
    //             ERROR(AGILES_LT_TEXT002);
    //           END;

    //         // Es ist ein Sortiment zugeordnet
    //         1:
    //           BEGIN
    //             lrc_CustAssort.FINDFIRST;
    //             lrc_Assort.GET(lrc_CustAssort."Assortment Code");
    //             ldt_AssortmentDate := GetRefDateValidAssortSalesHdr(vrc_SalesHdr,lrc_Assort);
    //             lrc_AssortVersion.Reset();
    //             lrc_AssortVersion.SETRANGE("Assortment Code",lrc_CustAssort."Assortment Code");
    //             lrc_AssortVersion.SETFILTER("Starting Date Assortment",'<=%1',ldt_AssortmentDate);
    //             lrc_AssortVersion.SETFILTER("Ending Date Assortment",'>=%1|%2',ldt_AssortmentDate,0D);
    //             IF lrc_AssortVersion.FINDLAST THEN
    //               lbn_LoadAssortment := TRUE
    //             ELSE
    //               // Es ist keine gültige Sortimentsversion vorhanden!
    //               ERROR(AGILES_LT_TEXT003);
    //           END;

    //         // Es sind mehrere Sortimente zugeordnet
    //         2,3,4,5,6,7,8,9,10,11,12,13,14,15:
    //           BEGIN
    //             // Sortiment auswählen
    //             lrc_CustAssort.Reset();
    //             lrc_CustAssort.SETCURRENTKEY("Search Order in Assortments");
    //             lrc_CustAssort.FILTERGROUP(2);
    //             IF lrc_Customer."Chain Name" <> '' THEN
    //               lrc_CustAssort.SETFILTER("Source No.",'%1|%2',lrc_Customer."No.",lrc_Customer."Chain Name")
    //             ELSE
    //               lrc_CustAssort.SETRANGE("Source No.",lrc_Customer."No.");
    //             lrc_CustAssort.FILTERGROUP(0);
    //             lfm_CustAssort.SETTABLEVIEW(lrc_CustAssort);
    //             lfm_CustAssort.LOOKUPMODE := TRUE;
    //             IF lfm_CustAssort.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lrc_CustAssort.Reset();
    //             lfm_CustAssort.GETRECORD(lrc_CustAssort);

    //             lrc_Assort.GET(lrc_CustAssort."Assortment Code");
    //             ldt_AssortmentDate := GetRefDateValidAssortSalesHdr(vrc_SalesHdr,lrc_Assort);

    //             lrc_AssortVersion.Reset();
    //             lrc_AssortVersion.SETRANGE("Assortment Code",lrc_CustAssort."Assortment Code");
    //             lrc_AssortVersion.SETFILTER("Starting Date Assortment",'<=%1',ldt_AssortmentDate);
    //             lrc_AssortVersion.SETFILTER("Ending Date Assortment",'>=%1|%2',ldt_AssortmentDate,0D);
    //             IF lrc_AssortVersion.FINDLAST THEN
    //               lbn_LoadAssortment := TRUE
    //             ELSE
    //               // Es ist keine gültige Sortimentsversion zum %1 vorhanden!
    //               ERROR(AGILES_LT_TEXT004, FORMAT(ldt_AssortmentDate));
    //           END;

    //         END;


    //         IF lbn_LoadAssortment = FALSE THEN
    //           EXIT;


    //         // ---------------------------------------------------------------------------------------------
    //         // Ausgewähltes Sortiment laden
    //         // ---------------------------------------------------------------------------------------------
    //         lrc_Assort.GET(lrc_AssortVersion."Assortment Code");

    //         // Bestehende Übergabewerte löschen
    //         lrc_FruitVisionTempI.SETRANGE("User ID",UserID());
    //         lrc_FruitVisionTempI.SETRANGE("Entry Type",lrc_FruitVisionTempI."Entry Type"::VSV);
    //         lrc_FruitVisionTempI.DELETEALL();

    //         // Übergabewerte setzen
    //         lrc_FruitVisionTempI.Reset();
    //         lrc_FruitVisionTempI.INIT();
    //         lrc_FruitVisionTempI."User ID" := USERID;
    //         lrc_FruitVisionTempI."Entry Type" := lrc_FruitVisionTempI."Entry Type"::VSV;

    //         CASE lrc_Assort."Allocation Price Group" OF
    //         lrc_Assort."Allocation Price Group"::Customer:
    //           lrc_FruitVisionTempI."VSV Cust. Price Group Code" := vrc_SalesHdr."Customer Price Group";
    //         lrc_Assort."Allocation Price Group"::Assortment:
    //           lrc_FruitVisionTempI."VSV Cust. Price Group Code" := lrc_Assort."Customer Price Group Code";
    //         END;
    //         lrc_FruitVisionTempI."VSV Customer No." := vrc_SalesHdr."Sell-to Customer No.";
    //         lrc_FruitVisionTempI."VSV Sales Order No." := vrc_SalesHdr."No.";

    //         // ??????????????????????????????????????????????????????
    //         // BAUSTELLE --> WOVON IST ES ABHÄNGIG OB DAS REF DATUM AN DER DEBPREISGRUPPE ODER AM SORTIMENT HÄNGT
    //         // ??????????????????????????????????????????????????????
    //         //lrc_FruitVisionTempI."VSV Price Reference Date" := lcu_Sales.GetRefDateValidCustPriceGrp(vrc_SalesHdr,FALSE);
    //         lrc_FruitVisionTempI."VSV Price Reference Date" := GetRefDateValidAssortSalesHdr(vrc_SalesHdr,lrc_Assort);

    //         lrc_FruitVisionTempI."VSV Assortment Code" := lrc_AssortVersion."Assortment Code";
    //         lrc_FruitVisionTempI."VSV Assortment Version Code" := lrc_AssortVersion."No.";
    //         lrc_FruitVisionTempI."VSV Shipment Date" := vrc_SalesHdr."Shipment Date";
    //         lrc_FruitVisionTempI."VSV Location Code" := vrc_SalesHdr."Location Code";
    //         lrc_FruitVisionTempI.INSERT(TRUE);

    //         // Bestehende Sortimentseingabezeilen löschen
    //         lrc_AssortmentSalesInput.Reset();
    //         lrc_AssortmentSalesInput.SETRANGE("User ID",UserID());
    //         lrc_AssortmentSalesInput.DELETEALL();

    //         /*-- WIRD JETZT IN DER SORTIMENTSMASKE ERLEDIGT
    //         // Verkaufszeilen lesen falls bereits Sortimentszeilen erfaßt sind
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHdr."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHdr."No.");
    //         lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //         lrc_SalesLine.SETFILTER("No.",'<>%1','');
    //         lrc_SalesLine.SETRANGE("Assortment Version No.",lrc_AssortVersion."No.");
    //         IF lrc_SalesLine.FIND('-') THEN
    //           REPEAT

    //             // Kontrolle ob Verkaufszeile im Sortiment vorhanden ist
    //             lrc_AssortmentVersionLine.Reset();
    //             lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortVersion."No.");
    //             lrc_AssortmentVersionLine.SETRANGE("Line No.",lrc_SalesLine."Assortment Version Line No.");
    //             //lrc_AssortLine.SETRANGE("Item No.",lrc_SalesLine."No.");
    //             IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN

    //               lrc_AssortmentSalesInput.Reset();
    //               lrc_AssortmentSalesInput.INIT();
    //               lrc_AssortmentSalesInput."USER ID" := USERID;
    //               lrc_AssortmentSalesInput."Assortment Version No." := lrc_AssortmentVersionLine."Assortment Version No.";
    //               lrc_AssortmentSalesInput."Assortment Version Line No." := lrc_AssortmentVersionLine."Line No.";
    //               lrc_AssortmentSalesInput."Item No." := lrc_SalesLine."No.";
    //               lrc_AssortmentSalesInput."Variant Code" := lrc_SalesLine."Variant Code";

    //               lrc_AssortmentSalesInput."Partitial Qty." := lrc_SalesLine."Partial Quantity (PQ)";
    //               lrc_AssortmentSalesInput."Unit of Measure Code" := lrc_SalesLine."Unit of Measure Code";
    //               lrc_AssortmentSalesInput.Quantity := lrc_SalesLine.Quantity;
    //               lrc_AssortmentSalesInput."Qty. per Unit of Measure" := lrc_SalesLine."Qty. per Unit of Measure";

    //               lrc_AssortmentSalesInput."Calc. Type Sales Price" := lrc_SalesLine."Price Base (Sales Price)";
    //               lrc_AssortmentSalesInput."Sales Price (Calc. Type)" := lrc_SalesLine."Sales Price (Price Base)";
    //               lrc_AssortmentSalesInput."Unit Price" := lrc_SalesLine."Unit Price";

    //               lrc_AssortmentSalesInput."Outlet Sales Price" := lrc_SalesLine."Outlet Sales Price";
    //               lrc_AssortmentSalesInput."Market Unit Cost (Base) (LCY)" := lrc_SalesLine."Market Unit Cost (Base) (LCY)";

    //               lrc_AssortmentSalesInput.Weight := lrc_SalesLine.Weight;
    //               lrc_AssortmentSalesInput."Net Weight" := lrc_SalesLine."Net Weight";
    //               lrc_AssortmentSalesInput."Total Net Weight" := lrc_SalesLine."Total Net Weight";
    //               lrc_AssortmentSalesInput."Gross Weight" := lrc_SalesLine."Gross Weight";
    //               lrc_AssortmentSalesInput."Total Gross Weight" := lrc_SalesLine."Total Gross Weight";

    //               lrc_AssortmentSalesInput."Sales Line Quantity" := lrc_SalesLine.Quantity;
    //               lrc_AssortmentSalesInput."Sales Line Unit Price" := lrc_SalesLine."Unit Price";

    //               lrc_AssortmentSalesInput."Sales Document Type" := lrc_SalesLine."Document Type";
    //               lrc_AssortmentSalesInput."Sales Document No." := lrc_SalesLine."Document No.";
    //               lrc_AssortmentSalesInput."Sales Document Line No." := lrc_SalesLine."Line No.";

    //               IF lrc_SalesLine."Transport Unit of Measure (TU)" <> '' THEN BEGIN
    //                 lrc_AssortmentSalesInput."Transport Unit of Measure (TU)" := lrc_SalesLine."Transport Unit of Measure (TU)";
    //                 lrc_AssortmentSalesInput."Qty. (Unit) per Pallet (TU)" := lrc_SalesLine."Qty. (Unit) per Transp. Unit";
    //                 lrc_AssortmentSalesInput."Quantity (TU)" := lrc_SalesLine."Quantity (TU)";
    //               END ELSE BEGIN
    //                 lrc_AssortmentSalesInput."Transport Unit of Measure (TU)" := lrc_AssortmentVersionLine."Transport Unit of Measure";
    //                 lrc_AssortmentSalesInput."Qty. (Unit) per Pallet (TU)" := lrc_AssortmentVersionLine."Qty. Unit per TU";
    //                 lrc_AssortmentSalesInput."Quantity (TU)" := lrc_AssortmentVersionLine."Qty. Transport Units";
    //               END;

    //               IF lrc_SalesLine."Packing Unit of Measure (PU)" <> '' THEN BEGIN
    //                 lrc_AssortmentSalesInput."Packing Unit of Measure (PU)" := lrc_SalesLine."Packing Unit of Measure (PU)";
    //                 lrc_AssortmentSalesInput."Qty. (PU) per Unit of Measure" := lrc_SalesLine."Qty. (PU) per Unit of Measure";
    //                 lrc_AssortmentSalesInput."Qty. (PU)" := lrc_SalesLine."Quantity (PU)";
    //               END ELSE BEGIN
    //                 lrc_AssortmentSalesInput."Packing Unit of Measure (PU)" := lrc_AssortmentVersionLine."Packing Unit of Measure (PU)";
    //                 lrc_AssortmentSalesInput."Qty. (PU) per Unit of Measure" := lrc_AssortmentVersionLine."Qty. PU per CU";
    //                 lrc_AssortmentSalesInput."Qty. (PU)" := lrc_AssortmentVersionLine."Qty. Packing Units";
    //               END;

    //               lrc_AssortmentSalesInput.insert();
    //             END ELSE BEGIN
    //             END;
    //           UNTIL lrc_SalesLine.NEXT() = 0;


    //         -----------*/
    //         COMMIT;


    //         lrc_AssortmentVersionLine.Reset();
    //         CASE lrc_Assort."Sort Order in Sales" OF
    //         lrc_Assort."Sort Order in Sales"::"Prod.Grp-Artikelsuchbegriff":
    //           lrc_AssortmentVersionLine.SETCURRENTKEY("Item Main Category Code","Item Category Code",
    //                                                   "Product Group Code","Search Description");
    //         lrc_Assort."Sort Order in Sales"::Sortierfolge:
    //           lrc_AssortmentVersionLine.SETCURRENTKEY("Sort Sequence","Item Description");
    //         lrc_Assort."Sort Order in Sales"::"Artikelnr. 2":
    //           lrc_AssortmentVersionLine.SETCURRENTKEY("Item No. 2");
    //         lrc_Assort."Sort Order in Sales"::Artikelbeschreibung:
    //           lrc_AssortmentVersionLine.SETCURRENTKEY("Item Description");
    //         lrc_Assort."Sort Order in Sales"::"Artikelnr.":
    //           lrc_AssortmentVersionLine.SETCURRENTKEY("Item No.");
    //         END;
    //         lrc_AssortmentVersionLine.FILTERGROUP(2);
    //         lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortVersion."No.");
    //         lrc_AssortmentVersionLine.SETRANGE("Automatic Allocation",FALSE);
    //         lrc_AssortmentVersionLine.SETFILTER("Item No.",'<>%1','');
    //         lrc_AssortmentVersionLine.FILTERGROUP(0);

    //         // Formular ermitteln
    //         lrc_SalesDocType.GET(vrc_SalesHdr."Document Type",vrc_SalesHdr."Sales Doc. Subtype Code");
    //         lrc_SalesDocType.TESTFIELD("Form ID Sortiment");

    //         // Erfassung über Sortimentsmaske
    //         FORM.RUNMODAL(lrc_SalesDocType."Form ID Sortiment",lrc_AssortmentVersionLine);

    //         // Verkaufszeilen ohne Nummer löschen
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHdr."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHdr."No.");
    //         lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //         lrc_SalesLine.SETRANGE("No.",'');
    //         IF NOT lrc_SalesLine.isempty()THEN
    //           lrc_SalesLine.DELETEALL(TRUE);

    //         // Verkaufszeilen ohne Menge löschen
    //         lrc_SalesLine.Reset();
    //         lrc_SalesLine.SETRANGE("Document Type",vrc_SalesHdr."Document Type");
    //         lrc_SalesLine.SETRANGE("Document No.",vrc_SalesHdr."No.");
    //         lrc_SalesLine.SETRANGE(Type,lrc_SalesLine.Type::Item);
    //         lrc_SalesLine.SETRANGE(Quantity,0);
    //         IF NOT lrc_SalesLine.isempty()THEN
    //           lrc_SalesLine.DELETEALL(TRUE);

    //     end;

    //     procedure SelectAssortment(vrc_SalesHdr: Record "36";var rco_AssortmentVersionCode: Code[20];var rco_CustomerPriceGroupCode: Code[10])
    //     var
    //         lcu_Sales: Codeunit "5110324";
    //         lrc_SalesDocType: Record "5110411";
    //         lrc_Assort: Record "5110338";
    //         lrc_AssortVersion: Record "5110339";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_CustAssort: Record "5110342";
    //         lrc_Customer: Record "Customer";
    //         lfm_CustAssort: Form "5088168";
    //         lin_LineNo: Integer;
    //         ldt_AssortmentDate: Date;
    //         AGILES_LT_TEXT001: Label 'Status muss offen sein!';
    //         AGILES_LT_TEXT002: Label 'Es sind keine zugeordneten Sortimente vorhanden!';
    //         AGILES_LT_TEXT003: Label 'Es ist keine gültige Sortimentsversion vorhanden!';
    //         AGILES_LT_TEXT004: Label 'Es ist keine gültige Sortimentsversion zum %1 vorhanden!';
    //         lco_AssortmentVersionCode: Code[20];
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Auswahl des Sortiments im Verkaufsauftrag ohne zu laden
    //         // -----------------------------------------------------------------------------

    //         rco_AssortmentVersionCode := '';
    //         rco_CustomerPriceGroupCode := '';

    //         IF NOT lrc_Customer.GET(vrc_SalesHdr."Sell-to Customer No.") THEN
    //           EXIT;
    //         rco_CustomerPriceGroupCode := lrc_Customer."Customer Price Group";

    //         vrc_SalesHdr.TESTFIELD("Order Date");
    //         vrc_SalesHdr.TESTFIELD("Shipment Date");
    //         vrc_SalesHdr.TESTFIELD("Promised Delivery Date");

    //         IF vrc_SalesHdr.Status <> vrc_SalesHdr.Status::Open THEN
    //           // Status muss offen sein!
    //           ERROR(AGILES_LT_TEXT001);

    //         lrc_Customer.GET(vrc_SalesHdr."Sell-to Customer No.");

    //         // Eingrenzung auf Debitor / Unternehmenskette
    //         IF lrc_Customer."Chain Name" <> '' THEN BEGIN
    //           lrc_CustAssort.SETFILTER("Source No.",'%1|%2',lrc_Customer."No.",lrc_Customer."Chain Name");
    //         END ELSE BEGIN
    //           lrc_CustAssort.SETRANGE(Source,lrc_CustAssort.Source::Customer);
    //           lrc_CustAssort.SETRANGE("Source No.",lrc_Customer."No.");
    //         END;
    //         // Eingrenzung auf Verkaufsbelegart
    //         lrc_CustAssort.SETFILTER("Sales Doc. Type",'%1|%2',vrc_SalesHdr."Document Type",lrc_CustAssort."Sales Doc. Type"::None);
    //         lrc_CustAssort.SETFILTER("Sales Doc. Subtype Code",'%1|%2',vrc_SalesHdr."Sales Doc. Subtype Code",'');

    //         CASE lrc_CustAssort.COUNT OF
    //         // Es sind keine Sortimente zugeordnet
    //         0:
    //           BEGIN
    //             // Es sind keine zugeordneten Sortimente vorhanden!
    //             ERROR(AGILES_LT_TEXT002);
    //           END;

    //         // Es sind mehrere Sortimente zugeordnet
    //         1,2,3,4,5,6,7,8,9,10:
    //           BEGIN
    //             // Sortiment auswählen
    //             lrc_CustAssort.Reset();
    //             lrc_CustAssort.FILTERGROUP(2);
    //             IF lrc_Customer."Chain Name" <> '' THEN
    //               lrc_CustAssort.SETFILTER("Source No.",'%1|%2',lrc_Customer."No.",lrc_Customer."Chain Name")
    //             ELSE
    //               lrc_CustAssort.SETRANGE("Source No.",lrc_Customer."No.");
    //             lrc_CustAssort.FILTERGROUP(0);
    //             lfm_CustAssort.SETTABLEVIEW(lrc_CustAssort);
    //             lfm_CustAssort.LOOKUPMODE := TRUE;
    //             IF lfm_CustAssort.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lrc_CustAssort.Reset();
    //             lfm_CustAssort.GETRECORD(lrc_CustAssort);

    //             lrc_Assort.GET(lrc_CustAssort."Assortment Code");
    //             ldt_AssortmentDate := GetRefDateValidAssortSalesHdr(vrc_SalesHdr,lrc_Assort);

    //             lrc_AssortVersion.Reset();
    //             lrc_AssortVersion.SETRANGE("Assortment Code",lrc_CustAssort."Assortment Code");
    //             lrc_AssortVersion.SETFILTER("Starting Date Assortment",'<=%1',ldt_AssortmentDate);
    //             lrc_AssortVersion.SETFILTER("Ending Date Assortment",'>=%1|%2',ldt_AssortmentDate,0D);
    //             IF lrc_AssortVersion.FIND('+') THEN BEGIN
    //               rco_AssortmentVersionCode := lrc_AssortVersion."No.";
    //               IF lrc_Assort."Allocation Price Group" = lrc_Assort."Allocation Price Group"::Assortment THEN
    //                 rco_CustomerPriceGroupCode := lrc_Assort."Customer Price Group Code";
    //             END ELSE
    //               // Es ist keine gültige Sortimentsversion zum %1 vorhanden!
    //               ERROR(AGILES_LT_TEXT004, FORMAT(ldt_AssortmentDate));
    //           END;
    //         END;
    //     end;

    //     procedure GetRefDateValidAssortSalesHdr(vrc_SalesHeader: Record "36";vrc_Assort: Record "5110338"): Date
    //     var
    //         ldt_RefDateValid: Date;
    //         TEXT001: Label 'Referenzdatum Sortiment konnte nicht ermittelt werden!';
    //     begin
    //         // -------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung des Gültigkeitsbezuges für das Sortiment
    //         // -------------------------------------------------------------------------------

    //         ldt_RefDateValid := 0D;

    //         CASE vrc_Assort."Ref. Date Validation" OF
    //         vrc_Assort."Ref. Date Validation"::"Order Date":
    //           BEGIN
    //             vrc_SalesHeader.TESTFIELD("Order Date");
    //             ldt_RefDateValid := vrc_SalesHeader."Order Date";
    //           END;
    //         vrc_Assort."Ref. Date Validation"::"Shipment Date":
    //           BEGIN
    //             vrc_SalesHeader.TESTFIELD("Shipment Date");
    //             ldt_RefDateValid := vrc_SalesHeader."Shipment Date";
    //           END;
    //         vrc_Assort."Ref. Date Validation"::"Requested Delivery Date":
    //           BEGIN
    //             vrc_SalesHeader.TESTFIELD("Requested Delivery Date");
    //             ldt_RefDateValid := vrc_SalesHeader."Requested Delivery Date";
    //           END;
    //         vrc_Assort."Ref. Date Validation"::"Promised Delivery Date":
    //           BEGIN
    //             vrc_SalesHeader.TESTFIELD("Promised Delivery Date");
    //             ldt_RefDateValid := vrc_SalesHeader."Promised Delivery Date";
    //           END;
    //         END;

    //         IF ldt_RefDateValid = 0D THEN
    //           // Referenzdatum Sortiment konnte nicht ermittelt werden!
    //           ERROR(TEXT001);

    //         EXIT(ldt_RefDateValid);
    //     end;

    //     procedure GetRefDateValidAssortDateVar(vrc_Assort: Record "5110338";vdt_OrderDate: Date;vdt_ShipmentDate: Date;vdt_RequestedDeliveryDate: Date;vdt_PromisedDeliveryDate: Date): Date
    //     var
    //         ldt_RefDateValid: Date;
    //         TEXT001: Label 'Referenzdatum Sortiment konnte nicht ermittelt werden!';
    //     begin
    //         // -------------------------------------------------------------------------------------
    //         // Funktion zur Ermittlung des Gültigkeitsbezuges für das Sortiment mit Datumsvariable
    //         // -------------------------------------------------------------------------------------

    //         ldt_RefDateValid := 0D;

    //         CASE vrc_Assort."Ref. Date Validation" OF
    //         vrc_Assort."Ref. Date Validation"::"Order Date":
    //           BEGIN
    //             ldt_RefDateValid := vdt_OrderDate;
    //           END;
    //         vrc_Assort."Ref. Date Validation"::"Shipment Date":
    //           BEGIN
    //             ldt_RefDateValid := vdt_ShipmentDate;
    //           END;
    //         vrc_Assort."Ref. Date Validation"::"Requested Delivery Date":
    //           BEGIN
    //             ldt_RefDateValid := vdt_RequestedDeliveryDate;
    //           END;
    //         vrc_Assort."Ref. Date Validation"::"Promised Delivery Date":
    //           BEGIN
    //             ldt_RefDateValid := vdt_PromisedDeliveryDate;
    //           END;
    //         END;

    //         IF ldt_RefDateValid = 0D THEN
    //           // Referenzdatum Sortiment konnte nicht ermittelt werden!
    //           ERROR(TEXT001);

    //         EXIT(ldt_RefDateValid);
    //     end;

    //     procedure CheckItemInAssortment(vrc_SalesLine: Record "37";var rco_AssortmentCode: Code[10];var rco_AssortmentVersionNo: Code[20];var rin_AssortmentLineNo: Integer)
    //     var
    //         lrc_CustomerAssort: Record "5110342";
    //         lrc_Assortment: Record "5110338";
    //         lrc_AssortVersLine: Record "5110340";
    //         lrc_SalesHeader: Record "36";
    //         lrc_Customer: Record "Customer";
    //         lbn_Permission: Boolean;
    //         TEXT001: Label 'Artikel ist in keinem gültigen Sortiment. Verkauf nicht zulässig!';
    //         ldt_RefDate: Date;
    //     begin
    //         // -------------------------------------------------------------------------------
    //         // Funktion zur Kontrolle ob ein Artikel in einem Debitorensortiment vorhanden ist
    //         // -------------------------------------------------------------------------------
    //         // vco_CustNo
    //         // vco_ItemNo
    //         // vco_Variantcode
    //         // vdt_OrderDate
    //         // vdt_DeliveryDate
    //         // -------------------------------------------------------------------------------

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') THEN
    //           EXIT;

    //         lbn_Permission := FALSE;
    //         lrc_SalesHeader.GET(vrc_SalesLine."Document Type",vrc_SalesLine."Document No.");

    //         IF lrc_SalesHeader."Company Chain Code" <> '' THEN BEGIN
    //           lrc_CustomerAssort.SETFILTER("Source No.",'%1|%2',lrc_SalesHeader."Sell-to Customer No.",
    //                                                             lrc_SalesHeader."Company Chain Code");
    //         END ELSE BEGIN
    //           lrc_CustomerAssort.SETRANGE(Source,lrc_CustomerAssort.Source::Customer);
    //           lrc_CustomerAssort.SETRANGE("Source No.",lrc_SalesHeader."Sell-to Customer No.");
    //         END;
    //         IF lrc_CustomerAssort.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_Assortment.GET(lrc_CustomerAssort."Assortment Code");
    //             ldt_RefDate := GetRefDateValidAssortSalesHdr(lrc_SalesHeader,lrc_Assortment);

    //             lrc_AssortVersLine.SETRANGE("Assortment Code",lrc_CustomerAssort."Assortment Code");
    //             lrc_AssortVersLine.SETFILTER("Starting Date Assortment",'<=%1|%2',ldt_RefDate,0D);
    //             lrc_AssortVersLine.SETFILTER("Ending Date Assortment",'>=%1|%2',ldt_RefDate,0D);
    //             lrc_AssortVersLine.SETRANGE("Item No.",vrc_SalesLine."No.");
    //             lrc_AssortVersLine.SETRANGE("Variant Code",vrc_SalesLine."Variant Code");
    //             IF lrc_AssortVersLine.FIND('+') THEN BEGIN
    //               lbn_Permission := TRUE;
    //               rco_AssortmentCode := lrc_AssortVersLine."Assortment Code";
    //               rco_AssortmentVersionNo := lrc_AssortVersLine."Assortment Version No.";
    //               rin_AssortmentLineNo := lrc_AssortVersLine."Line No.";
    //             END;
    //           UNTIL (lrc_CustomerAssort.NEXT() = 0) OR (lbn_Permission = TRUE);
    //         END;

    //         IF lbn_Permission = FALSE THEN
    //           // Artikel ist in keinem gültigen Sortiment. Verkauf nicht zulässig!
    //           ERROR(TEXT001);
    //     end;

    //     procedure ShowCustomerAssortemts(vco_CustomerNo: Code[20];vbn_Edit: Boolean)
    //     var
    //         lrc_CustomerAssortment: Record "5110342";
    //         lfm_CustomerAssortment: Form "5088168";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zur Anzeige der zugeordneten Sortimente
    //         // -----------------------------------------------------------------------------

    //         lrc_CustomerAssortment.FILTERGROUP(2);
    //         lrc_CustomerAssortment.SETRANGE(Source,lrc_CustomerAssortment.Source::Customer);
    //         lrc_CustomerAssortment.SETRANGE("Source No.",vco_CustomerNo);
    //         lrc_CustomerAssortment.FILTERGROUP(0);

    //         lfm_CustomerAssortment.EDITABLE := vbn_Edit;
    //         lfm_CustomerAssortment.SETTABLEVIEW(lrc_CustomerAssortment);
    //         lfm_CustomerAssortment.RUNMODAL;
    //     end;

    //     procedure CalculateAssortmentPrice(rco_AssortmentVersionNo: Code[20];rco_AssortmentCode: Code[10];rin_AssortmentLineNo: Integer)
    //     var
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_AssortmentCustPriceGroup: Record "5110341";
    //         lrc_Vendor: Record "Vendor";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         lrc_Assortment: Record "5110338";
    //         ldc_Value: Decimal;
    //         lrc_PurchSalesDocReference: Record "5110562";
    //         lrc_CustomerPriceGroup: Record "6";
    //         lrc_Item: Record Item;
    //         ldc_TrademarkUseChargePerc: Decimal;
    //         lrc_Trademark: Record "5110306";
    //         ldc_Freightcost: Decimal;
    //         ldc_PalletFactor: Decimal;
    //         lrc_SalesPrice: Record "7002";
    //         lrc_AssortmentVersion: Record "5110339";
    //         lco_ShippingAgent: Code[10];
    //         lrc_ShippingAgent: Record "291";
    //         lrc_UnitOfMeasure: Record "204";
    //         AgilesText001: Label 'Das aktuelle Datum %1 liegt nicht im Bereich ''Startdatum gültig von'' %2 und ''Startdatum Preis gültig'' bis %3 !';
    //         lrc_ItemTransportUnitFaktor: Record "5087912";
    //         lrc_PriceCalculation: Record "5110320";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         //
    //         // -----------------------------------------------------------------------------

    //         // AGE 001 00000000.s
    //         lrc_Assortment.GET( rco_AssortmentCode );

    //         lrc_AssortmentVersion.GET( rco_AssortmentVersionNo );

    //         IF (TODAY >= lrc_AssortmentVersion."Starting Date Assortment") AND
    //            (TODAY <= lrc_AssortmentVersion."Ending Date Assortment") THEN BEGIN
    //         END ELSE BEGIN
    //           ERROR(AgilesText001, Today(),
    //                 lrc_AssortmentVersion."Starting Date Assortment",
    //                 lrc_AssortmentVersion."Ending Date Assortment");
    //         END;

    //         lrc_AssortmentCustPriceGroup.Reset();
    //         lrc_AssortmentCustPriceGroup.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //         IF lrc_AssortmentCustPriceGroup.FIND('-') THEN BEGIN
    //           lrc_AssortmentVersionLine.Reset();
    //           lrc_AssortmentVersionLine.SETRANGE( "Assortment Version No.", rco_AssortmentVersionNo );
    //           lrc_AssortmentVersionLine.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //           IF rin_AssortmentLineNo <> 0 THEN
    //             lrc_AssortmentVersionLine.SETRANGE( "Line No.", rin_AssortmentLineNo );
    //           IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN
    //              REPEAT

    //                // es muss einen EK-Preis geben
    //                // es muss ein Kreditor vorhanden sein
    //                IF ( lrc_AssortmentVersionLine."Purch. Price (Price Base)" <> 0 ) AND
    //                   ( lrc_AssortmentVersionLine."Vendor No."  <> '' ) THEN BEGIN

    //                   ldc_TrademarkUseChargePerc := 1;

    //                   IF lrc_AssortmentVersionLine."Transport Unit of Measure (TU)" <> '' THEN BEGIN
    //                     IF lrc_AssortmentVersionLine."Qty. Unit per TU" <> 0 THEN BEGIN
    //                       ldc_PalletFactor := lrc_AssortmentVersionLine."Qty. Unit per TU";
    //                     END ELSE BEGIN
    //                       lrc_ItemTransportUnitFaktor.Reset();
    //                       lrc_ItemTransportUnitFaktor.SETRANGE("Item No.", lrc_AssortmentVersionLine."Item No." );
    //                       lrc_ItemTransportUnitFaktor.SETRANGE("Unit of Measure Code", lrc_AssortmentVersionLine."Unit of Measure Code" );
    //                       lrc_ItemTransportUnitFaktor.SETRANGE("Reference No.", lrc_AssortmentVersionLine."Vendor No." );
    //                       lrc_ItemTransportUnitFaktor.SETRANGE("Transport Unit of Measure (TU)",
    //                                                             lrc_AssortmentVersionLine."Transport Unit of Measure (TU)" );
    //                       IF lrc_ItemTransportUnitFaktor.FIND('-') THEN BEGIN
    //                         ldc_PalletFactor := lrc_ItemTransportUnitFaktor."Qty. (Unit) per Transp. Unit";
    //                       END ELSE BEGIN
    //                         lrc_ItemTransportUnitFaktor.SETRANGE( "Reference No." );
    //                         IF lrc_ItemTransportUnitFaktor.FIND('-') THEN BEGIN
    //                           ldc_PalletFactor := lrc_ItemTransportUnitFaktor."Qty. (Unit) per Transp. Unit";
    //                         END ELSE BEGIN
    //                           ldc_PalletFactor := lrc_AssortmentVersionLine."Qty. per Unit of Measure";
    //                         END;
    //                       END;
    //                     END;
    //                   END ELSE BEGIN
    //                     ldc_PalletFactor := lrc_AssortmentVersionLine."Qty. per Unit of Measure";
    //                   END;

    //                   lrc_PriceCalculation.Reset();
    //                   IF lrc_PriceCalculation.GET( lrc_PriceCalculation."Purch./Sales Price Calc."::"Purch. Price",
    //                                                 lrc_AssortmentVersionLine."Price Base (Purch. Price)" ) THEN BEGIN

    //                    CASE lrc_PriceCalculation."Internal Calc. Type" OF
    //                       lrc_PriceCalculation."Internal Calc. Type"::"Base Unit":
    //                         BEGIN
    //                            ldc_PalletFactor := ldc_PalletFactor * lrc_AssortmentVersionLine."Qty. per Unit of Measure";
    //                         END;
    //                       lrc_PriceCalculation."Internal Calc. Type"::"Content Unit":
    //                         BEGIN
    //                         END;
    //                       lrc_PriceCalculation."Internal Calc. Type"::"Packing Unit":
    //                         BEGIN
    //                            ldc_PalletFactor := ldc_PalletFactor * lrc_AssortmentVersionLine."Qty. PU per CU";
    //                         END;
    //                       lrc_PriceCalculation."Internal Calc. Type"::"Collo Unit":
    //                         BEGIN
    //                         END;
    //                       lrc_PriceCalculation."Internal Calc. Type"::"Transport Unit":
    //                         BEGIN
    //                            ldc_PalletFactor := ldc_PalletFactor * lrc_AssortmentVersionLine."Qty. Unit per TU";
    //                         END;
    //                       lrc_PriceCalculation."Internal Calc. Type"::"Gross Weight":
    //                         BEGIN
    //                         END;
    //                       lrc_PriceCalculation."Internal Calc. Type"::"Net Weight":
    //                         BEGIN
    //                         END;
    //                       lrc_PriceCalculation."Internal Calc. Type"::"Total Price":
    //                         BEGIN
    //                         END;
    //                       END;
    //                   END;

    //                   IF lrc_Item.GET( lrc_AssortmentVersionLine."Item No." ) THEN BEGIN
    //                     IF lrc_Item."Trademark Code" <> '' THEN BEGIN
    //                        IF lrc_Trademark.GET( lrc_Item."Trademark Code" ) THEN BEGIN
    //                           ldc_TrademarkUseChargePerc := 1 + ( lrc_Trademark."Trademark Charge Perc." / 100 );
    //                        END;
    //                     END;
    //                     IF lrc_Vendor.GET( lrc_AssortmentVersionLine."Vendor No." ) THEN BEGIN

    //                       ldc_Freightcost := 0;
    //                       lco_ShippingAgent := '';

    //                       IF ( lrc_Vendor."Departure Region Code" <> '' ) AND
    //                          ( lrc_Assortment."Arrival Region Code" <> '' ) AND
    //                          ( lrc_AssortmentVersionLine."Transport Unit of Measure (TU)" <> '' )  THEN BEGIN
    //                         lrc_PurchSalesDocReference.Reset();
    //                         lrc_PurchSalesDocReference.SETRANGE( Source, lrc_PurchSalesDocReference.Source::Purchase );
    //                         lrc_PurchSalesDocReference.SETRANGE( "Document Type", lrc_PurchSalesDocReference."Document Type"::None );
    //                         lrc_PurchSalesDocReference.SETRANGE( "Doc. Subtype Code",
    //                                                              lrc_Assortment."Assort. for Sales Doc. Subtype" );
    //                         lrc_PurchSalesDocReference.SETRANGE( "Reference Type",
    //                                                              lrc_PurchSalesDocReference."Reference Type"::"Shipping Agent" );
    //                         lrc_PurchSalesDocReference.SETRANGE( "Reference Source Code", lrc_AssortmentVersionLine."Vendor No." );
    //                         IF ( lrc_PurchSalesDocReference.FIND('-') ) AND
    //                            ( lrc_PurchSalesDocReference."Reference Code" <> '' ) THEN BEGIN
    //                            lco_ShippingAgent := lrc_PurchSalesDocReference."Reference Code";
    //                         END ELSE BEGIN
    //                           lrc_PurchSalesDocReference.SETRANGE( Source, lrc_PurchSalesDocReference.Source::Purchase );
    //                           lrc_PurchSalesDocReference.SETRANGE( "Document Type", lrc_PurchSalesDocReference."Document Type"::None );
    //                           lrc_PurchSalesDocReference.SETRANGE( "Doc. Subtype Code",
    //                                                                lrc_Assortment."Assort. for Sales Doc. Subtype" );
    //                           lrc_PurchSalesDocReference.SETRANGE( "Reference Type",
    //                                                                lrc_PurchSalesDocReference."Reference Type"::"Shipping Agent" );
    //                           lrc_PurchSalesDocReference.SETRANGE( "Reference Source Code", lrc_AssortmentVersionLine."Vendor No." );
    //                           IF ( lrc_PurchSalesDocReference.FIND('-') ) AND
    //                              ( lrc_PurchSalesDocReference."Reference Code" <> '' ) THEN BEGIN
    //                              lco_ShippingAgent := lrc_PurchSalesDocReference."Reference Code";
    //                           END;
    //                         END;
    //                         IF lco_ShippingAgent = '' THEN BEGIN
    //                           lco_ShippingAgent := lrc_Vendor."Shipping Agent Code";
    //                         END;
    //                         IF lco_ShippingAgent <> '' THEN BEGIN
    //                           IF lrc_ShippingAgent.GET( lco_ShippingAgent ) THEN BEGIN
    //                              IF lrc_UnitOfMeasure.GET( lrc_AssortmentVersionLine."Transport Unit of Measure (TU)" ) THEN BEGIN
    //                                 IF lrc_UnitOfMeasure."Freight Unit of Measure (FU)" <> '' THEN BEGIN

    //                                   lrc_ShipAgentFreightcost.Reset();
    //                                   lrc_ShipAgentFreightcost.SETRANGE( "Shipping Agent Code", lco_ShippingAgent );
    //                                   lrc_ShipAgentFreightcost.SETRANGE( "Arrival Region Code", lrc_Assortment."Arrival Region Code" );
    //                                   lrc_ShipAgentFreightcost.SETRANGE( "Departure Region Code", lrc_Vendor."Departure Region Code" );
    //                                   lrc_ShipAgentFreightcost.SETRANGE( "Freight Cost Tarif Base",
    //                                                                      lrc_ShippingAgent."Freight Cost Tariff Base");
    //                                   IF lrc_ShippingAgent."Freight Cost Tariff Base" =
    //                                            lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //                                     lrc_ShipAgentFreightcost.SETRANGE( "Freight Unit of Measure Code",
    //                                                                        lrc_UnitOfMeasure."Freight Unit of Measure (FU)" );
    //                                   IF lrc_ShipAgentFreightcost.FIND('-') THEN BEGIN
    //                                     ldc_Freightcost := lrc_ShipAgentFreightcost."Freight Rate per Unit";
    //                                   END;

    //                                END;
    //                              END;
    //                           END;
    //                         END;
    //                       END;

    //                       lrc_AssortmentCustPriceGroup.Reset();
    //                       lrc_AssortmentCustPriceGroup.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //                       IF lrc_AssortmentCustPriceGroup.FIND('-') THEN BEGIN
    //                         REPEAT
    //                           IF lrc_CustomerPriceGroup.GET( lrc_AssortmentCustPriceGroup."Customer Price Group Code" ) THEN BEGIN

    //                             IF ldc_PalletFactor = 0 THEN
    //                               ldc_PalletFactor := 1;

    //                             ldc_Value := ( ( lrc_AssortmentVersionLine."Purch. Price (Price Base)" *
    //                                              ldc_TrademarkUseChargePerc ) *
    //                                            ( 1 + ( lrc_CustomerPriceGroup."Sales Marge Percentage" / 100 )) ) +
    //                                          ( ( lrc_CustomerPriceGroup."Sales Freight Cost (LCY)" + ldc_Freightcost ) /
    //                                            ldc_PalletFactor );

    //                             ldc_Value := ROUND( ldc_Value, 0.01 );

    //                             // Preis ist berechnet
    //                             IF ldc_Value <> 0 THEN BEGIN

    //                               lrc_SalesPrice.Reset();
    //                               lrc_SalesPrice.SETCURRENTKEY( "Item No.","Sales Type","Sales Code","Starting Date","Currency Code",
    //                                                             "Variant Code","Unit of Measure Code","Vendor No.",
    //                                                             "Assort. Version No.","Assort. Version Line No.","Minimum Quantity" );

    //                               // Preis löschen (falls vorhanden) und Neuanlage
    //                               lrc_SalesPrice.Reset();
    //                               lrc_SalesPrice.INIT();
    //                               lrc_SalesPrice.SETRANGE( "Item No.", lrc_AssortmentVersionLine."Item No." );
    //                               lrc_SalesPrice.SETRANGE( "Sales Type", lrc_SalesPrice."Sales Type"::"Customer Price Group" );
    //                               lrc_SalesPrice.SETRANGE( "Sales Code", lrc_AssortmentCustPriceGroup."Customer Price Group Code" );
    //                               lrc_SalesPrice.SETRANGE( "Starting Date", lrc_AssortmentVersion."Starting Date Price" );
    //                               lrc_SalesPrice.SETRANGE( "Currency Code", '' );
    //                               lrc_SalesPrice.SETRANGE( "Variant Code", lrc_AssortmentVersionLine."Variant Code" );
    //                               lrc_SalesPrice.SETRANGE( "Unit of Measure Code", lrc_AssortmentVersionLine."Sales Price Unit of Measure" );

    //                               lrc_SalesPrice.SETRANGE( "Vendor No.", '' );
    //                               lrc_SalesPrice.SETRANGE( "Assort. Version No.", '' );
    //                               lrc_SalesPrice.SETRANGE( "Assort. Version Line No.", 0 );
    //                               IF lrc_CustomerPriceGroup.GET( lrc_AssortmentCustPriceGroup."Customer Price Group Code" ) THEN BEGIN
    //                                  CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                                    lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                                      "plus Vendor No":
    //                                      BEGIN
    //                                         lrc_SalesPrice.SETRANGE( "Vendor No.", lrc_AssortmentVersionLine."Vendor No." );
    //                                      END;
    //                                    lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                                      "plus Assortment Version and Line No":
    //                                      BEGIN
    //                                         lrc_SalesPrice.SETRANGE( "Assort. Version No.",
    //                                           lrc_AssortmentVersionLine."Assortment Version No." );
    //                                         lrc_SalesPrice.SETRANGE( "Assort. Version Line No.",
    //                                           lrc_AssortmentVersionLine."Line No." );
    //                                      END;
    //                                  END;
    //                               END;

    //                               lrc_SalesPrice.SETRANGE( "Minimum Quantity", 0 );
    //                               IF lrc_SalesPrice.FIND('-') THEN BEGIN
    //                                 lrc_SalesPrice.DELETE();
    //                               END;

    //                               lrc_SalesPrice.Reset();
    //                               lrc_SalesPrice.INIT();
    //                               lrc_SalesPrice."Item No." := lrc_AssortmentVersionLine."Item No.";
    //                               lrc_SalesPrice."Sales Type" := lrc_SalesPrice."Sales Type"::"Customer Price Group";
    //                               lrc_SalesPrice."Sales Code" := lrc_AssortmentCustPriceGroup."Customer Price Group Code";
    //                               lrc_SalesPrice."Starting Date" := lrc_AssortmentVersion."Starting Date Price";
    //                               lrc_SalesPrice."Currency Code" := '';
    //                               lrc_SalesPrice."Variant Code" := lrc_AssortmentVersionLine."Variant Code";
    //                               lrc_SalesPrice."Unit of Measure Code" := lrc_AssortmentVersionLine."Sales Price Unit of Measure";

    //                               lrc_SalesPrice."Vendor No." := '';
    //                               lrc_SalesPrice."Assort. Version No." := '';
    //                               lrc_SalesPrice."Assort. Version Line No." := 0;
    //                               IF lrc_CustomerPriceGroup.GET( lrc_AssortmentCustPriceGroup."Customer Price Group Code" ) THEN BEGIN
    //                                  CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                                    lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                                      "plus Vendor No":
    //                                      BEGIN
    //                                         lrc_SalesPrice. "Vendor No." := lrc_AssortmentVersionLine."Vendor No.";
    //                                      END;
    //                                    lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                                      "plus Assortment Version and Line No":
    //                                      BEGIN
    //                                         lrc_SalesPrice."Assort. Version No." :=
    //                                           lrc_AssortmentVersionLine."Assortment Version No.";
    //                                         lrc_SalesPrice."Assort. Version Line No." :=
    //                                           lrc_AssortmentVersionLine."Line No.";
    //                                      END;
    //                                  END;
    //                               END;

    //                               lrc_SalesPrice."Minimum Quantity" := 0;

    //                               lrc_SalesPrice."Ending Date" := lrc_AssortmentVersion."Ending Date Price";
    //                               lrc_SalesPrice."Unit Price" := ldc_Value;
    //                               lrc_SalesPrice.Weight := lrc_AssortmentVersionLine.Weight;
    //                               lrc_SalesPrice.insert();

    //                             END;
    //                           END;
    //                         UNTIL lrc_AssortmentCustPriceGroup.NEXT() = 0;
    //                       END;
    //                    END;
    //                  END;

    //                END;
    //              UNTIL lrc_AssortmentVersionLine.NEXT() = 0;
    //           END;
    //         END;
    //         // AGE 001 00000000.e
    //     end;

    //     procedure CalcFormAssortmentPrice(rco_AssortmentVersionNo: Code[20];rco_AssortmentCode: Code[10];rin_AssortmentLineNo: Integer;rco_CustomerPriceGroup: Code[10])
    //     var
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_AssortmentCustPriceGroup: Record "5110341";
    //         lrc_Vendor: Record "Vendor";
    //         lrc_Assortment: Record "5110338";
    //         ldc_Value: Decimal;
    //         lrc_CustomerPriceGroup: Record "6";
    //         lrc_Item: Record Item;
    //         lrc_SalesPrice: Record "7002";
    //         lrc_AssortmentVersion: Record "5110339";
    //         AgilesText001: Label 'Das aktuelle Datum %1 liegt nicht im Bereich ''Startdatum gültig von'' %2 und ''Startdatum Preis gültig'' bis %3 !';
    //         AgilesText002: Label 'Debitorenpreisgruppe %1 existiert nicht !';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         //
    //         // -----------------------------------------------------------------------------

    //         // AGE 002 00000000.s
    //         lrc_Assortment.GET( rco_AssortmentCode );

    //         lrc_AssortmentVersion.GET( rco_AssortmentVersionNo );

    //         IF (TODAY >= lrc_AssortmentVersion."Starting Date Assortment") AND
    //            (TODAY <= lrc_AssortmentVersion."Ending Date Assortment") THEN BEGIN
    //         END ELSE BEGIN
    //           ERROR( AgilesText001, Today(),
    //                  lrc_AssortmentVersion."Starting Date Assortment",
    //                  lrc_AssortmentVersion."Ending Date Assortment" );
    //         END;

    //         lrc_AssortmentCustPriceGroup.Reset();
    //         lrc_AssortmentCustPriceGroup.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //         lrc_AssortmentCustPriceGroup.SETRANGE( "Customer Price Group Code", rco_CustomerPriceGroup );
    //         IF lrc_AssortmentCustPriceGroup.FIND('-') THEN BEGIN

    //           IF NOT lrc_CustomerPriceGroup.GET( lrc_AssortmentCustPriceGroup."Customer Price Group Code" ) THEN BEGIN
    //             ERROR( AgilesText002, lrc_AssortmentCustPriceGroup."Customer Price Group Code" );
    //           END;

    //           lrc_AssortmentVersionLine.Reset();
    //           lrc_AssortmentVersionLine.SETRANGE( "Assortment Version No.", rco_AssortmentVersionNo );
    //           lrc_AssortmentVersionLine.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //           lrc_AssortmentVersionLine.SETRANGE( "Line No.", rin_AssortmentLineNo );

    //           IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN

    //              // es muss nicht zwingend einen EK-Preis geben
    //              // es muss ein Kreditor vorhanden sein
    //              IF ( lrc_AssortmentVersionLine."Vendor No." <> '' ) THEN BEGIN

    //                 IF lrc_Item.GET( lrc_AssortmentVersionLine."Item No." ) THEN BEGIN
    //                   IF lrc_Vendor.GET( lrc_AssortmentVersionLine."Vendor No." ) THEN BEGIN

    //         //            CLEAR( lfm_BTRCalcAssortmentPrice );
    //         //            lfm_BTRCalcAssortmentPrice.SetAssortmentVersionLine( lrc_AssortmentVersionLine,
    //         //                                                                 lrc_AssortmentCustPriceGroup."Customer Price Group Code" );
    //         //
    //         //            lfm_BTRCalcAssortmentPrice.LOOKUPMODE := TRUE;
    //         //            IF lfm_BTRCalcAssortmentPrice.RUNMODAL <> ACTION::LookupOK THEN
    //                        EXIT;
    //         //
    //         //            lfm_BTRCalcAssortmentPrice.GetValue( ldc_Value );

    //         //            CLEAR( lfm_BTRCalcAssortmentPrice );

    //                     // Preis ist berechnet
    //                     IF ldc_Value <> 0 THEN BEGIN

    //                       lrc_SalesPrice.Reset();
    //                       lrc_SalesPrice.SETCURRENTKEY( "Item No.","Sales Type","Sales Code","Starting Date","Currency Code",
    //                                                     "Variant Code","Unit of Measure Code","Vendor No.",
    //                                                     "Assort. Version No.","Assort. Version Line No.","Minimum Quantity" );
    //                       // Preis löschen (falls vorhanden) und Neuanlage
    //                       lrc_SalesPrice.Reset();
    //                       lrc_SalesPrice.INIT();
    //                       lrc_SalesPrice.SETRANGE( "Item No.", lrc_AssortmentVersionLine."Item No." );
    //                       lrc_SalesPrice.SETRANGE( "Sales Type", lrc_SalesPrice."Sales Type"::"Customer Price Group" );
    //                       lrc_SalesPrice.SETRANGE( "Sales Code", lrc_AssortmentCustPriceGroup."Customer Price Group Code" );
    //                       lrc_SalesPrice.SETRANGE( "Starting Date", lrc_AssortmentVersion."Starting Date Price" );
    //                       lrc_SalesPrice.SETRANGE( "Currency Code", '' );
    //                       lrc_SalesPrice.SETRANGE( "Variant Code", lrc_AssortmentVersionLine."Variant Code" );
    //                       lrc_SalesPrice.SETRANGE( "Unit of Measure Code", lrc_AssortmentVersionLine."Sales Price Unit of Measure" );

    //                       lrc_SalesPrice.SETRANGE( "Vendor No.", '' );
    //                       lrc_SalesPrice.SETRANGE( "Assort. Version No.", '' );
    //                       lrc_SalesPrice.SETRANGE( "Assort. Version Line No.", 0 );
    //                       IF lrc_CustomerPriceGroup.GET( lrc_AssortmentCustPriceGroup."Customer Price Group Code" ) THEN BEGIN
    //                          CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                            lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                              "plus Vendor No":
    //                              BEGIN
    //                                 lrc_SalesPrice.SETRANGE( "Vendor No.", lrc_AssortmentVersionLine."Vendor No." );
    //                              END;
    //                            lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                              "plus Assortment Version and Line No":
    //                              BEGIN
    //                                 lrc_SalesPrice.SETRANGE( "Assort. Version No.",
    //                                   lrc_AssortmentVersionLine."Assortment Version No." );
    //                                 lrc_SalesPrice.SETRANGE( "Assort. Version Line No.",
    //                                   lrc_AssortmentVersionLine."Line No." );
    //                              END;
    //                          END;
    //                       END;

    //                       lrc_SalesPrice.SETRANGE( "Minimum Quantity", 0 );
    //                       IF lrc_SalesPrice.FIND('-') THEN BEGIN
    //                         lrc_SalesPrice.DELETE();
    //                       END;

    //                       lrc_SalesPrice.Reset();
    //                       lrc_SalesPrice.INIT();
    //                       lrc_SalesPrice."Item No." := lrc_AssortmentVersionLine."Item No.";
    //                       lrc_SalesPrice."Sales Type" := lrc_SalesPrice."Sales Type"::"Customer Price Group";
    //                       lrc_SalesPrice."Sales Code" := lrc_AssortmentCustPriceGroup."Customer Price Group Code";
    //                       lrc_SalesPrice."Starting Date" := lrc_AssortmentVersion."Starting Date Price";
    //                       lrc_SalesPrice."Currency Code" := '';
    //                       lrc_SalesPrice."Variant Code" := lrc_AssortmentVersionLine."Variant Code";
    //                       lrc_SalesPrice."Unit of Measure Code" := lrc_AssortmentVersionLine."Sales Price Unit of Measure";

    //                       lrc_SalesPrice."Vendor No." := '';
    //                       lrc_SalesPrice."Assort. Version No." := '';
    //                       lrc_SalesPrice."Assort. Version Line No." := 0;
    //                       CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                         lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                           "plus Vendor No":
    //                           BEGIN
    //                              lrc_SalesPrice. "Vendor No." := lrc_AssortmentVersionLine."Vendor No.";
    //                           END;
    //                         lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::
    //                           "plus Assortment Version and Line No":
    //                           BEGIN
    //                              lrc_SalesPrice."Assort. Version No." :=
    //                                lrc_AssortmentVersionLine."Assortment Version No.";
    //                              lrc_SalesPrice."Assort. Version Line No." :=
    //                                lrc_AssortmentVersionLine."Line No.";
    //                           END;
    //                       END;

    //                       lrc_SalesPrice."Minimum Quantity" := 0;

    //                       lrc_SalesPrice."Ending Date" := lrc_AssortmentVersion."Ending Date Price";
    //                       lrc_SalesPrice."Unit Price" := ROUND( ldc_Value, 0.01 );
    //                       lrc_SalesPrice.Weight := lrc_AssortmentVersionLine.Weight;
    //                       lrc_SalesPrice.insert();

    //                     END;
    //                  END;
    //                END;
    //               END;
    //           END;
    //         END;
    //         // AGE 002 00000000.e
    //     end;

    //     procedure CalcFormAssortmSalesInputPrice(rco_AssortmentVersionNo: Code[20];rco_AssortmentCode: Code[10];rin_AssortmentLineNo: Integer;rco_CustomerPriceGroup: Code[10];var vdc_SalesPrice_CalcType: Decimal)
    //     var
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_AssortmentCustPriceGroup: Record "5110341";
    //         lrc_Vendor: Record "Vendor";
    //         lrc_Assortment: Record "5110338";
    //         ldc_Value: Decimal;
    //         lrc_CustomerPriceGroup: Record "6";
    //         lrc_Item: Record Item;
    //         lrc_AssortmentVersion: Record "5110339";
    //         AgilesText001: Label 'Debitorenpreisgruppe %1 existiert nicht !';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         //
    //         // -----------------------------------------------------------------------------

    //         // AGE 002 00000000.s
    //         lrc_Assortment.GET( rco_AssortmentCode );

    //         lrc_AssortmentVersion.GET( rco_AssortmentVersionNo );

    //         lrc_AssortmentCustPriceGroup.Reset();
    //         lrc_AssortmentCustPriceGroup.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //         lrc_AssortmentCustPriceGroup.SETRANGE( "Customer Price Group Code", rco_CustomerPriceGroup );
    //         IF lrc_AssortmentCustPriceGroup.FIND('-') THEN BEGIN

    //           IF NOT lrc_CustomerPriceGroup.GET( lrc_AssortmentCustPriceGroup."Customer Price Group Code" ) THEN
    //             ERROR( AgilesText001, lrc_AssortmentCustPriceGroup."Customer Price Group Code" );

    //           lrc_AssortmentVersionLine.Reset();
    //           lrc_AssortmentVersionLine.SETRANGE( "Assortment Version No.", rco_AssortmentVersionNo );
    //           lrc_AssortmentVersionLine.SETRANGE( "Assortment Code", rco_AssortmentCode );
    //           lrc_AssortmentVersionLine.SETRANGE( "Line No.", rin_AssortmentLineNo );

    //           IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN
    //             // es muss nicht zwingend einen EK-Preis geben
    //             // es muss ein Kreditor vorhanden sein
    //             IF ( lrc_AssortmentVersionLine."Vendor No." <> '' ) THEN BEGIN

    //               IF lrc_Item.GET( lrc_AssortmentVersionLine."Item No." ) THEN BEGIN
    //                 IF lrc_Vendor.GET( lrc_AssortmentVersionLine."Vendor No." ) THEN BEGIN

    //         //          CLEAR( lfm_BTRCalcAssortmentPrice );
    //         //          lfm_BTRCalcAssortmentPrice.SetAssortmentVersionLine( lrc_AssortmentVersionLine,
    //         //                                                               lrc_AssortmentCustPriceGroup."Customer Price Group Code" );

    //         //          lfm_BTRCalcAssortmentPrice.LOOKUPMODE := TRUE;
    //         //          IF lfm_BTRCalcAssortmentPrice.RUNMODAL <> ACTION::LookupOK THEN
    //         //             EXIT;
    //         //          lfm_BTRCalcAssortmentPrice.GetValue( ldc_Value );
    //         //          CLEAR( lfm_BTRCalcAssortmentPrice );

    //                   // Preis ist berechnet
    //                   IF ldc_Value <> 0 THEN BEGIN
    //                     vdc_SalesPrice_CalcType := ldc_Value;
    //                     EXIT;
    //                   END;
    //                 END;
    //               END;
    //             END;
    //           END;
    //         END;
    //         // AGE 002 00000000.e
    //     end;

    //     procedure CheckShowItemNotOnlyInBaseAss(vco_ItemNo: Code[20]): Boolean
    //     var
    //         lrc_Assortment: Record "5110338";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lfm_AssortmentVersionLineList: Form "5088172";
    //         lbn_OnlyBaseAssort: Boolean;
    //         AGILES_LT_TEXT001: Label 'Break!';
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Funktion zur Prüfung und Anzeige ob Artikel nicht nur im Bsissortiment ist
    //         // --------------------------------------------------------------------------------

    //         // Kontrolle ob Artikel noch in Sortiment vorhanden ist
    //         lbn_OnlyBaseAssort := TRUE;

    //         lrc_AssortmentVersionLine.Reset();
    //         lrc_AssortmentVersionLine.FILTERGROUP(2);
    //         lrc_AssortmentVersionLine.SETRANGE("Item No.",vco_ItemNo);
    //         lrc_AssortmentVersionLine.FILTERGROUP(0);
    //         IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_Assortment.GET(lrc_AssortmentVersionLine."Assortment Code");
    //             IF lrc_Assortment."Assortment Source" <> lrc_Assortment."Assortment Source"::"Base Assortment" THEN
    //               lbn_OnlyBaseAssort := FALSE;
    //           UNTIL (lrc_AssortmentVersionLine.NEXT() = 0) OR (lbn_OnlyBaseAssort = FALSE);
    //         END;

    //         IF lbn_OnlyBaseAssort = FALSE THEN BEGIN
    //           lfm_AssortmentVersionLineList.SETTABLEVIEW(lrc_AssortmentVersionLine);
    //           lfm_AssortmentVersionLineList.RUNMODAL;
    //           // Abbruch!
    //           ERROR(AGILES_LT_TEXT001);
    //         END;

    //         EXIT(lbn_OnlyBaseAssort);
    //     end;

    //     procedure LoadDeleteItemInFromBaseAssort(vco_ItemNo: Code[20];vbn_Delete: Boolean)
    //     var
    //         lrc_Assortment: Record "5110338";
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Funktion zum Laden eines Artikels in das Basissortiment
    //         // --------------------------------------------------------------------------------

    //         lrc_Assortment.Reset();
    //         lrc_Assortment.SETRANGE("Assortment Source",lrc_Assortment."Assortment Source"::"Base Assortment");
    //         IF lrc_Assortment.FIND('-') THEN
    //           REPEAT
    //             LoadDeleteItemInFromAssort(vco_ItemNo,lrc_Assortment.Code,vbn_Delete);
    //           UNTIL lrc_Assortment.NEXT() = 0;
    //     end;

    //     procedure LoadDeleteItemInFromAssort(vco_ItemNo: Code[20];vco_AssortmentCode: Code[10];vbn_Delete: Boolean)
    //     var
    //         lrc_Assortment: Record "5110338";
    //         lrc_AssortmentVersion: Record "5110339";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //     begin
    //         // --------------------------------------------------------------------------------
    //         // Funktion zum Laden/Löschen eines Artikels in/aus einem Sortiment
    //         // --------------------------------------------------------------------------------

    //         lrc_Assortment.GET(vco_AssortmentCode);

    //         lrc_AssortmentVersion.Reset();
    //         lrc_AssortmentVersion.SETRANGE("Assortment Code",lrc_Assortment.Code);
    //         lrc_AssortmentVersion.SETFILTER("Ending Date Assortment",'>=%1',TODAY);
    //         IF lrc_AssortmentVersion.FIND('-') THEN BEGIN
    //           REPEAT

    //             IF vbn_Delete = TRUE THEN BEGIN

    //               // Kontrolle ob Artikel vorhanden ist
    //               lrc_AssortmentVersionLine.Reset();
    //               lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortmentVersion."No.");
    //               lrc_AssortmentVersionLine.SETRANGE("Item No.",vco_ItemNo);
    //               IF lrc_AssortmentVersionLine.FIND('-') THEN BEGIN
    //                 lrc_AssortmentVersionLine.DELETE(TRUE);
    //               END;

    //             END ELSE BEGIN

    //               // Kontrolle ob Artikel vorhanden ist
    //               lrc_AssortmentVersionLine.Reset();
    //               lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortmentVersion."No.");
    //               lrc_AssortmentVersionLine.SETRANGE("Item No.",vco_ItemNo);
    //               IF NOT lrc_AssortmentVersionLine.FIND('-') THEN BEGIN
    //                 lrc_AssortmentVersionLine.Reset();
    //                 lrc_AssortmentVersionLine.INIT();
    //                 lrc_AssortmentVersionLine."Assortment Version No." := lrc_AssortmentVersion."No.";
    //                 lrc_AssortmentVersionLine."Line No." := 0;
    //                 lrc_AssortmentVersionLine."Assortment Code" := lrc_AssortmentVersion."Assortment Code";
    //                 lrc_AssortmentVersionLine."Starting Date Assortment" := lrc_AssortmentVersion."Starting Date Assortment";
    //                 lrc_AssortmentVersionLine."Ending Date Assortment" := lrc_AssortmentVersion."Ending Date Assortment";
    //                 lrc_AssortmentVersionLine.VALIDATE(Type,lrc_AssortmentVersionLine.Type::Item);
    //                 lrc_AssortmentVersionLine.VALIDATE("Item No.",vco_ItemNo);
    //                 lrc_AssortmentVersionLine.INSERT(TRUE);
    //               END;

    //             END;

    //           UNTIL lrc_AssortmentVersion.NEXT() = 0;
    //         END;
    //     end;

    //     procedure AssortCalcSalesPrices(vco_AssortVersionCode: Code[20];vin_AssortVersionLineNo: Integer;vco_CustomerPriceGroup: Code[10];vbn_SelectCustPriceGroup: Boolean)
    //     var
    //         lrc_AssortmentVersion: Record "5110339";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_CustomerPriceGroup: Record "6";
    //         lrc_CustomerPriceGroupMarge: Record "5087929";
    //         lrc_SalesPrice: Record "7002";
    //         lrc_PriceBase: Record "5110320";
    //         ldc_SalesUnitPrice: Decimal;
    //         ADF_LT_TEXT001: Label 'Möchten Sie für alle Preisgruppen die Verk.-Preise neu kalkulieren?';
    //         ADF_LT_TEXT002: Label 'Möchten Sie für die Preisgruppe %1 die Verk.-Preise neu kalkulieren?';
    //         ltx_ConfirmRecalc: Text[100];
    //         ADF_LT_TEXT003: Label 'Möchten Sie die Verkaufspreise für %1 neu kalkulieren?';
    //         ADF_LT_TEXT004: Label 'Möchten Sie die Verkaufspreise für ALLE Artikel neu kalkulieren?';
    //     begin
    //         // --------------------------------------------------------------------------------------
    //         // Funktion zur Berechnung der Verkaufspreise
    //         // --------------------------------------------------------------------------------------

    //         lrc_AssortmentVersion.GET(vco_AssortVersionCode);

    //         // Auswahl Debitorenpreisgruppe
    //         IF vbn_SelectCustPriceGroup = TRUE THEN BEGIN
    //           ltx_ConfirmRecalc := ADF_LT_TEXT004;
    //           IF vin_AssortVersionLineNo <> 0 THEN BEGIN
    //             lrc_AssortmentVersionLine.RESET();
    //             lrc_AssortmentVersionLine.SETRANGE("Line No.",vin_AssortVersionLineNo);
    //             lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortmentVersion."No.");
    //             IF lrc_AssortmentVersionLine.FINDFIRST() THEN
    //               ltx_ConfirmRecalc := STRSUBSTNO(ADF_LT_TEXT003, lrc_AssortmentVersionLine."Item Description");
    //           END;
    //           IF NOT CONFIRM(ltx_ConfirmRecalc) THEN
    //             EXIT;
    //           vco_AssortVersionCode := '';

    //           lrc_CustomerPriceGroup.Reset();
    //           lrc_CustomerPriceGroup.FILTERGROUP(2);
    //           lrc_CustomerPriceGroup.SETRANGE("Price Group Type",lrc_CustomerPriceGroup."Price Group Type"::" ");
    //           lrc_CustomerPriceGroup.FILTERGROUP(0);
    //           IF FORM.RUNMODAL(0,lrc_CustomerPriceGroup) = ACTION::LookupOK THEN BEGIN
    //             vco_AssortVersionCode := lrc_CustomerPriceGroup.Code;
    //             // Möchten Sie für die Preisgruppe %1 die Verk.-Preise neu kalkulieren?
    //             IF NOT CONFIRM(ADF_LT_TEXT002,FALSE,vco_AssortVersionCode) THEN
    //               EXIT;
    //           END ELSE BEGIN
    //             // Möchten Sie für alle Preisgruppen die Verk.-Preise neu kalkulieren?
    //             IF NOT CONFIRM(ADF_LT_TEXT001) THEN
    //               EXIT;
    //           END;
    //         END;

    //         lrc_AssortmentVersionLine.RESET();
    //         IF vin_AssortVersionLineNo <> 0 THEN
    //           lrc_AssortmentVersionLine.SETRANGE("Line No.",vin_AssortVersionLineNo);
    //         lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",lrc_AssortmentVersion."No.");
    //         IF lrc_AssortmentVersionLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             lrc_CustomerPriceGroup.Reset();
    //             IF vco_CustomerPriceGroup <> '' THEN
    //               lrc_CustomerPriceGroup.SETRANGE(Code,vco_CustomerPriceGroup);
    //             lrc_CustomerPriceGroup.SETRANGE("Price Group Type",lrc_CustomerPriceGroup."Price Group Type"::" ");
    //             IF lrc_CustomerPriceGroup.FINDSET(FALSE,FALSE) THEN BEGIN
    //               REPEAT

    //                 // Alle Verkaufspreise für die Deb.-Preisgruppe und Datum zuerst löschen
    //                 lrc_CustomerPriceGroup.TESTFIELD(Code);
    //                 lrc_SalesPrice.Reset();
    //                 lrc_SalesPrice.SETRANGE("Item No.",lrc_AssortmentVersionLine."Item No.");
    //                 lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::"Customer Price Group");
    //                 lrc_SalesPrice.SETRANGE("Sales Code",lrc_CustomerPriceGroup.Code);
    //                 lrc_SalesPrice.SETRANGE("Customer No.",'');
    //                 lrc_SalesPrice.SETRANGE("Currency Code",'');
    //                 lrc_SalesPrice.SETRANGE("Variant Code",lrc_AssortmentVersionLine."Variant Code");
    //                 IF lrc_AssortmentVersion."Starting Date Assortment" >= TODAY THEN
    //                   lrc_SalesPrice.SETRANGE("Starting Date",lrc_AssortmentVersion."Starting Date Assortment")
    //                 ELSE
    //                   lrc_SalesPrice.SETRANGE("Starting Date",TODAY);
    //                 CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                 lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"Item - Currency - Variant - Unit of Measure":
    //                   BEGIN
    //                   END;
    //                 lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"plus Vendor No":
    //                   BEGIN
    //                   END;
    //                 lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"plus Assortment Version and Line No":
    //                   BEGIN
    //                     lrc_SalesPrice.SETRANGE("Assort. Version No.",lrc_AssortmentVersionLine."Assortment Version No.");
    //                     lrc_SalesPrice.SETRANGE("Assort. Version Line No.",lrc_AssortmentVersionLine."Line No.");
    //                   END;
    //                 lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"plus Batch Variant":
    //                   BEGIN
    //                     lrc_SalesPrice.SETRANGE("Batch Variant No.",lrc_AssortmentVersionLine."Batch Variant No.");
    //                   END;
    //                 END;
    //                 IF NOT lrc_SalesPrice.isempty()THEN
    //                   lrc_SalesPrice.DELETEALL();

    //                 // Preiskalkulationen lesen
    //                 lrc_CustomerPriceGroupMarge.Reset();
    //                 lrc_CustomerPriceGroupMarge.SETRANGE("Cust. Price Group Code",lrc_CustomerPriceGroup.Code);
    //                 IF lrc_CustomerPriceGroupMarge.FINDSET(FALSE,FALSE) THEN BEGIN
    //                   REPEAT

    //                     lrc_CustomerPriceGroupMarge.TESTFIELD("Sales Marge Percentage");
    //                     ldc_SalesUnitPrice := 0;
    //                     IF lrc_CustomerPriceGroupMarge."Sales Price from Via Location" = TRUE THEN BEGIN
    //                       // Einkaufspreis plus Plannebenkosten
    //                       ldc_SalesUnitPrice := lrc_AssortmentVersionLine."Direct Unit Cost (LCY)" +
    //                                             lrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)";

    //                       // Konditionen berechnen
    //                       // Marge aufschlagen
    //                       // ldc_SalesUnitPrice := ldc_SalesUnitPrice *
    //                       //                      (1 + (lrc_CustomerPriceGroup."Sales Marge Percentage"/100));

    //                       // Prozentsatz als Marge vom Verkaufspreis
    //                       ldc_SalesUnitPrice := ldc_SalesUnitPrice * 100 /
    //                                             (100 - lrc_CustomerPriceGroupMarge."Sales Marge Percentage");

    //                     END ELSE BEGIN

    //                       // Frachtkosten zum Debitoren berechnen
    //                       CASE lrc_CustomerPriceGroupMarge."Sales Freight Cost Reference" OF
    //                       lrc_CustomerPriceGroupMarge."Sales Freight Cost Reference"::Pallet:
    //                           ldc_SalesUnitPrice := lrc_AssortmentVersionLine."Unit Cost (LCY)" +
    //                                                 (lrc_CustomerPriceGroupMarge."Sales Freight Cost (LCY)" /
    //                                                 lrc_AssortmentVersionLine."Qty. Unit per TU");
    //                       lrc_CustomerPriceGroupMarge."Sales Freight Cost Reference"::Colli:
    //                           ldc_SalesUnitPrice := lrc_AssortmentVersionLine."Unit Cost (LCY)" +
    //                                                 lrc_CustomerPriceGroupMarge."Sales Freight Cost (LCY)";
    //                       ELSE
    //                         ldc_SalesUnitPrice := lrc_AssortmentVersionLine."Unit Cost (LCY)";
    //                       END;
    //                       // Konditionen berechnen

    //                       // Marge aufrechnen
    //                       // ldc_SalesUnitPrice := ldc_SalesUnitPrice *
    //                       //                       (1 + (lrc_CustomerPriceGroup."Sales Marge Percentage"/100));

    //                       ldc_SalesUnitPrice := ldc_SalesUnitPrice * 100 /
    //                                             (100 - lrc_CustomerPriceGroupMarge."Sales Marge Percentage");

    //                     END;

    //                     IF ldc_SalesUnitPrice <> 0 THEN BEGIN

    //                       // Umrechnen in Verkaufspreiseinheit
    //                       lrc_PriceBase.GET(lrc_PriceBase."Purch./Sales Price Calc."::"Sales Price",
    //                                         lrc_AssortmentVersionLine."Price Base (Sales Price)");
    //                       CASE lrc_PriceBase."Internal Calc. Type" OF
    //                       lrc_PriceBase."Internal Calc. Type"::"Base Unit":
    //                         ldc_SalesUnitPrice := ROUND(ldc_SalesUnitPrice /
    //                                                     lrc_AssortmentVersionLine."Qty. per Unit of Measure",0.01,'>');
    //                       lrc_PriceBase."Internal Calc. Type"::"Content Unit":;
    //                       lrc_PriceBase."Internal Calc. Type"::"Packing Unit":
    //                         ldc_SalesUnitPrice := ROUND(ldc_SalesUnitPrice /
    //                                                     lrc_AssortmentVersionLine."Qty. PU per CU",0.01,'>');
    //                       lrc_PriceBase."Internal Calc. Type"::"Collo Unit",
    //                       lrc_PriceBase."Internal Calc. Type"::" ":
    //                         ldc_SalesUnitPrice := ROUND(ldc_SalesUnitPrice,0.01,'>');
    //                       lrc_PriceBase."Internal Calc. Type"::"Transport Unit":
    //                         ldc_SalesUnitPrice := ROUND(ldc_SalesUnitPrice * lrc_AssortmentVersionLine."Qty. Unit per TU",0.01,'>');
    //                       lrc_PriceBase."Internal Calc. Type"::"Gross Weight":
    //                         ldc_SalesUnitPrice := ROUND(ldc_SalesUnitPrice /
    //                                                     lrc_AssortmentVersionLine."Gross Weight",0.01,'>');
    //                       lrc_PriceBase."Internal Calc. Type"::"Net Weight":
    //                         ldc_SalesUnitPrice := ROUND(ldc_SalesUnitPrice /
    //                                                     lrc_AssortmentVersionLine."Net Weight",0.01,'>');
    //                       lrc_PriceBase."Internal Calc. Type"::"Total Price":;
    //                       END;

    //                       // Umrechnen in Währung Debitorenpreisgruppe
    //                       IF lrc_AssortmentVersionLine."Currency Code" <> '' THEN BEGIN
    //                       END;

    //                       // Verkaufspreis Datensatz schreiben
    //                       lrc_SalesPrice.Reset();
    //                       lrc_SalesPrice.SETRANGE("Item No.",lrc_AssortmentVersionLine."Item No.");
    //                       lrc_SalesPrice.SETRANGE("Sales Type",lrc_SalesPrice."Sales Type"::"Customer Price Group");
    //                       lrc_SalesPrice.SETRANGE("Sales Code",lrc_CustomerPriceGroup.Code);
    //                       lrc_SalesPrice.SETRANGE("Customer No.",'');
    //                       lrc_SalesPrice.SETRANGE("Currency Code",'');
    //                       lrc_SalesPrice.SETRANGE("Variant Code",lrc_AssortmentVersionLine."Variant Code");
    //                       lrc_SalesPrice.SETRANGE("Unit of Measure Code",lrc_AssortmentVersionLine."Sales Price Unit of Measure");
    //                       CASE lrc_CustomerPriceGroup."Save Type Assort. Sales Price" OF
    //                       lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"Item - Currency - Variant - Unit of Measure":
    //                         BEGIN
    //                         END;
    //                       lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"plus Vendor No":
    //                         BEGIN
    //                         END;
    //                       lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"plus Assortment Version and Line No":
    //                         BEGIN
    //                           lrc_SalesPrice.SETRANGE("Assort. Version No.",lrc_AssortmentVersionLine."Assortment Version No.");
    //                           lrc_SalesPrice.SETRANGE("Assort. Version Line No.",lrc_AssortmentVersionLine."Line No.");
    //                         END;
    //                       lrc_CustomerPriceGroup."Save Type Assort. Sales Price"::"plus Batch Variant":
    //                         BEGIN
    //                           lrc_SalesPrice.SETRANGE("Batch Variant No.",lrc_AssortmentVersionLine."Batch Variant No.");
    //                         END;
    //                       END;

    //                       // Menge berücksichtigen
    //                       IF (lrc_CustomerPriceGroupMarge."From UOM Qty." <> 0) OR
    //                          (lrc_CustomerPriceGroupMarge."From UOM Qty. Depend on" <>
    //                           lrc_CustomerPriceGroupMarge."From UOM Qty. Depend on"::" ") THEN BEGIN
    //                         IF (lrc_CustomerPriceGroupMarge."From UOM Qty." <> 0) THEN BEGIN
    //                           lrc_SalesPrice.SETRANGE("Minimum Quantity",lrc_CustomerPriceGroupMarge."From UOM Qty.");
    //                         END ELSE BEGIN
    //                           lrc_AssortmentVersionLine.TESTFIELD("Qty. Unit per TU");
    //                           lrc_SalesPrice.SETRANGE("Minimum Quantity",lrc_AssortmentVersionLine."Qty. Unit per TU");
    //                         END;
    //                       END ELSE BEGIN
    //                         lrc_SalesPrice.SETRANGE("Minimum Quantity",0);
    //                       END;

    //                       IF lrc_AssortmentVersion."Starting Date Assortment" >= TODAY THEN
    //                         lrc_SalesPrice.SETRANGE("Starting Date",lrc_AssortmentVersion."Starting Date Assortment")
    //                       ELSE
    //                         lrc_SalesPrice.SETRANGE("Starting Date",TODAY);
    //                       IF lrc_SalesPrice.FINDFIRST() THEN BEGIN

    //                         lrc_SalesPrice."Unit Price" := ldc_SalesUnitPrice;
    //                         lrc_SalesPrice.Modify();

    //                       END ELSE BEGIN

    //                         lrc_SalesPrice.Reset();
    //                         lrc_SalesPrice.INIT();
    //                         lrc_SalesPrice."Item No." := lrc_AssortmentVersionLine."Item No.";
    //                         lrc_SalesPrice."Sales Type" := lrc_SalesPrice."Sales Type"::"Customer Price Group";
    //                         lrc_SalesPrice."Sales Code" := lrc_CustomerPriceGroup.Code;
    //                         lrc_SalesPrice."Customer No." := '';
    //                         IF lrc_AssortmentVersion."Starting Date Assortment" >= TODAY THEN
    //                           lrc_SalesPrice."Starting Date" := lrc_AssortmentVersion."Starting Date Assortment"
    //                         ELSE
    //                           lrc_SalesPrice."Starting Date" := TODAY;
    //                         lrc_SalesPrice."Ending Date" := lrc_AssortmentVersionLine."Ending Date Assortment";
    //                         lrc_SalesPrice."Currency Code" := '';
    //                         lrc_SalesPrice."Variant Code" := lrc_AssortmentVersionLine."Variant Code";
    //                         lrc_SalesPrice."Unit of Measure Code" := lrc_AssortmentVersionLine."Sales Price Unit of Measure";

    //                         // Menge berücksichtigen
    //                         IF (lrc_CustomerPriceGroupMarge."From UOM Qty." <> 0) OR
    //                            (lrc_CustomerPriceGroupMarge."From UOM Qty. Depend on" <>
    //                             lrc_CustomerPriceGroupMarge."From UOM Qty. Depend on"::" ") THEN BEGIN
    //                           IF (lrc_CustomerPriceGroupMarge."From UOM Qty." <> 0) THEN BEGIN
    //                             lrc_SalesPrice."Minimum Quantity" := lrc_CustomerPriceGroupMarge."From UOM Qty.";
    //                           END ELSE BEGIN
    //                             lrc_SalesPrice."Minimum Quantity" := lrc_AssortmentVersionLine."Qty. Unit per TU";
    //                           END;
    //                         END ELSE BEGIN
    //                           lrc_SalesPrice."Minimum Quantity" := 0;
    //                         END;

    //                         lrc_SalesPrice."Assort. Version No." := lrc_AssortmentVersionLine."Assortment Version No.";
    //                         lrc_SalesPrice."Assort. Version Line No." := lrc_AssortmentVersionLine."Line No.";
    //                         lrc_SalesPrice."Batch Variant No." := lrc_AssortmentVersionLine."Batch Variant No.";
    //                         lrc_SalesPrice."Unit Price" := ldc_SalesUnitPrice;
    //                         lrc_SalesPrice.insert();

    //                       END;
    //                     END;

    //                   UNTIL lrc_CustomerPriceGroupMarge.NEXT() = 0;
    //                 END;

    //               UNTIL lrc_CustomerPriceGroup.NEXT() = 0;
    //             END;
    //           UNTIL lrc_AssortmentVersionLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure AssortCalcUnitCost(vco_AssortVersionCode: Code[20])
    //     var
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_BatchVariant: Record "5110366";
    //     begin
    //         // ----------------------------------------------------------------------------
    //         // Funktion um den Einstandspreis für alle Sortimentszeilen zu berechnen
    //         // ----------------------------------------------------------------------------

    //         lrc_AssortmentVersionLine.SETRANGE("Assortment Version No.",vco_AssortVersionCode);
    //         IF lrc_AssortmentVersionLine.FINDSET(TRUE,FALSE) THEN BEGIN
    //           REPEAT
    //             IF lrc_BatchVariant.GET(lrc_AssortmentVersionLine."Batch Variant No.") THEN BEGIN
    //               IF (lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Purch. Order") OR
    //                  (lrc_BatchVariant.Source = lrc_BatchVariant.Source::"Packing Order") THEN BEGIN
    //               END ELSE BEGIN
    //                 AssortLineCalcUnitCost(lrc_AssortmentVersionLine);
    //                 lrc_AssortmentVersionLine.Modify();
    //               END;
    //             END ELSE BEGIN
    //               AssortLineCalcUnitCost(lrc_AssortmentVersionLine);
    //               lrc_AssortmentVersionLine.Modify();
    //             END;
    //           UNTIL lrc_AssortmentVersionLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure AssortLineCalcUnitCost(var rrc_AssortmentVersionLine: Record "5110340")
    //     var
    //         lrc_ShipmentMethod: Record "10";
    //         lrc_Vendor: Record "Vendor";
    //         lrc_OrderAddress: Record "224";
    //         lrc_Location: Record "14";
    //         lrc_ShippingAgent: Record "291";
    //         lrc_ShipAgentFreightcost: Record "5110405";
    //         lrc_CostCategory: Record "5110345";
    //         lrc_StandardCostCalculations: Record "5110551";
    //         lco_DepartureRegion: Code[20];
    //         lco_ArrivalRegion: Code[20];
    //     begin
    //         // ----------------------------------------------------------------------------
    //         // Funktion um den Einstandspreis für eine Sortimentszeile zu berechnen
    //         // ----------------------------------------------------------------------------

    //         rrc_AssortmentVersionLine.VALIDATE("Purch. Price (Price Base)");

    //         // ----------------------------------------------------------------------------
    //         // Frachtkosten berechnen
    //         // ----------------------------------------------------------------------------
    //         rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := 0;
    //         rrc_AssortmentVersionLine."Freight Cost Amount (LCY)" := 0;

    //         IF NOT lrc_Vendor.GET(rrc_AssortmentVersionLine."Vendor No.") THEN
    //           EXIT;

    //         // Lieferbedingung lesen
    //         IF lrc_ShipmentMethod.GET(rrc_AssortmentVersionLine."Shipment Method Code") THEN BEGIN

    //           // Fracht von Lieferant an Zwischenlager
    //           IF (lrc_ShipmentMethod."Incl. Freight to Transfer Loc." = FALSE) AND
    //              (rrc_AssortmentVersionLine."Entry via Transfer Loc. Code" <> '') AND
    //              (rrc_AssortmentVersionLine."Entry via Transfer Loc. Code" <> rrc_AssortmentVersionLine."Entry Location Code") THEN BEGIN

    //             lco_DepartureRegion := '';
    //             lco_ArrivalRegion := '';
    //             IF rrc_AssortmentVersionLine."Vendor Order Address Code" <> '' THEN BEGIN
    //             END ELSE BEGIN
    //               lco_DepartureRegion := lrc_Vendor."Departure Region Code";
    //             END;
    //             IF lrc_Location.GET(rrc_AssortmentVersionLine."Entry via Transfer Loc. Code") THEN
    //               lco_ArrivalRegion := lrc_Location."Arrival Region Code";

    //             IF NOT lrc_ShippingAgent.GET(rrc_AssortmentVersionLine."Ship-Agent Code to Transf. Loc") THEN
    //               lrc_ShippingAgent.INIT();

    //             lrc_ShipAgentFreightcost.Reset();
    //             lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",rrc_AssortmentVersionLine."Ship-Agent Code to Transf. Loc");
    //             lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lco_DepartureRegion);
    //             lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code",lco_ArrivalRegion);
    //             lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base",
    //                                               lrc_ShippingAgent."Freight Cost Tariff Base");
    //             IF lrc_ShippingAgent."Freight Cost Tariff Base" = lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //               lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",rrc_AssortmentVersionLine."Freight Unit of Measure");
    //             lrc_ShipAgentFreightcost.SETFILTER("Valid From",'<=%1',rrc_AssortmentVersionLine."Starting Date Assortment");
    //             IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //               rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                          ROUND(lrc_ShipAgentFreightcost."Freight Rate per Unit" /
    //                                                                          rrc_AssortmentVersionLine."Qty. Unit per TU",0.01,'>');
    //             END ELSE BEGIN
    //               rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                          100;
    //             END;

    //             // Fracht von Zwischenlager an Ziellager
    //             IF (lrc_ShipmentMethod."Incl. Freight to Final Loc." = FALSE) AND
    //                (rrc_AssortmentVersionLine."Entry via Transfer Loc. Code" <> '') AND
    //                (rrc_AssortmentVersionLine."Entry Location Code" <> '') AND
    //                (rrc_AssortmentVersionLine."Entry Location Code" <> rrc_AssortmentVersionLine."Entry via Transfer Loc. Code") THEN BEGIN

    //               lco_DepartureRegion := '';
    //               lco_ArrivalRegion := '';
    //               IF lrc_Location.GET(rrc_AssortmentVersionLine."Entry via Transfer Loc. Code") THEN
    //                 lco_DepartureRegion := lrc_Location."Departure Region Code";
    //               IF lrc_Location.GET(rrc_AssortmentVersionLine."Entry Location Code") THEN
    //                 lco_ArrivalRegion := lrc_Location."Arrival Region Code";
    //               IF NOT lrc_ShippingAgent.GET(rrc_AssortmentVersionLine."Shipping Agent Code") THEN
    //                 lrc_ShippingAgent.INIT();

    //               lrc_ShipAgentFreightcost.Reset();
    //               lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",rrc_AssortmentVersionLine."Shipping Agent Code");
    //               lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lco_DepartureRegion);
    //               lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code",lco_ArrivalRegion);
    //               lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base",
    //                                                 lrc_ShippingAgent."Freight Cost Tariff Base");
    //               IF lrc_ShippingAgent."Freight Cost Tariff Base" = lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //                 lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",rrc_AssortmentVersionLine."Freight Unit of Measure");
    //               lrc_ShipAgentFreightcost.SETFILTER("Valid From",'<=%1',rrc_AssortmentVersionLine."Starting Date Assortment");
    //               IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //                 rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                            ROUND(lrc_ShipAgentFreightcost."Freight Rate per Unit" /
    //                                                                            rrc_AssortmentVersionLine."Qty. Unit per TU",0.01,'>');
    //               END ELSE BEGIN
    //                 rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                            100;
    //               END;

    //             // Fracht von Lieferant an Ziellager
    //             END ELSE BEGIN

    //               IF (lrc_ShipmentMethod."Incl. Freight to Final Loc." = FALSE) AND
    //                  (rrc_AssortmentVersionLine."Entry Location Code" <> '') AND
    //                  ((rrc_AssortmentVersionLine."Entry via Transfer Loc. Code" = '') OR
    //                   (rrc_AssortmentVersionLine."Entry via Transfer Loc. Code" = rrc_AssortmentVersionLine."Entry Location Code")) THEN BEGIN

    //                 lco_DepartureRegion := '';
    //                 lco_ArrivalRegion := '';
    //                 IF rrc_AssortmentVersionLine."Vendor Order Address Code" <> '' THEN BEGIN
    //                 END ELSE BEGIN
    //                   IF lrc_Vendor.GET(rrc_AssortmentVersionLine."Vendor No.") THEN
    //                     lco_DepartureRegion := lrc_Vendor."Departure Region Code";
    //                 END;
    //                 IF lrc_Location.GET(rrc_AssortmentVersionLine."Entry Location Code") THEN
    //                   lco_ArrivalRegion := lrc_Location."Arrival Region Code";

    //                 IF NOT lrc_ShippingAgent.GET(rrc_AssortmentVersionLine."Shipping Agent Code") THEN
    //                   lrc_ShippingAgent.INIT();

    //                 lrc_ShipAgentFreightcost.Reset();
    //                 lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",rrc_AssortmentVersionLine."Shipping Agent Code");
    //                 lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lco_DepartureRegion);
    //                 lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code",lco_ArrivalRegion);
    //                 lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base",
    //                                                   lrc_ShippingAgent."Freight Cost Tariff Base");
    //                 IF lrc_ShippingAgent."Freight Cost Tariff Base" = lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //                   lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",rrc_AssortmentVersionLine."Freight Unit of Measure");
    //                 lrc_ShipAgentFreightcost.SETFILTER("Valid From",'<=%1',rrc_AssortmentVersionLine."Starting Date Assortment");
    //                 IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //                   rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                              ROUND(lrc_ShipAgentFreightcost."Freight Rate per Unit" /
    //                                                                              rrc_AssortmentVersionLine."Qty. Unit per TU",0.01,'>');
    //                 END ELSE BEGIN
    //                   rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                            100;
    //                 END;

    //               END;

    //             END;


    //           // Fracht von Lieferant oder Zwischenlager an Ziellager
    //           END ELSE BEGIN

    //             IF (lrc_ShipmentMethod."Incl. Freight to Final Loc." = FALSE) THEN BEGIN

    //             IF (rrc_AssortmentVersionLine."Entry Location Code" <> '') AND
    //                ((rrc_AssortmentVersionLine."Entry via Transfer Loc. Code" = '') OR
    //                 (rrc_AssortmentVersionLine."Entry Location Code" = rrc_AssortmentVersionLine."Entry via Transfer Loc. Code")) THEN BEGIN

    //               lco_DepartureRegion := '';
    //               lco_ArrivalRegion := '';
    //               IF rrc_AssortmentVersionLine."Vendor Order Address Code" <> '' THEN BEGIN
    //               END ELSE BEGIN
    //                 IF lrc_Vendor.GET(rrc_AssortmentVersionLine."Vendor No.") THEN
    //                   lco_DepartureRegion := lrc_Vendor."Departure Region Code";
    //               END;
    //               IF lrc_Location.GET(rrc_AssortmentVersionLine."Entry Location Code") THEN
    //                 lco_ArrivalRegion := lrc_Location."Arrival Region Code";

    //               IF NOT lrc_ShippingAgent.GET(rrc_AssortmentVersionLine."Shipping Agent Code") THEN
    //                 lrc_ShippingAgent.INIT();

    //               lrc_ShipAgentFreightcost.Reset();
    //               lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",rrc_AssortmentVersionLine."Shipping Agent Code");
    //               lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lco_DepartureRegion);
    //               lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code",lco_ArrivalRegion);
    //               lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base",
    //                                                 lrc_ShippingAgent."Freight Cost Tariff Base");
    //               IF lrc_ShippingAgent."Freight Cost Tariff Base" = lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //                 lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",rrc_AssortmentVersionLine."Freight Unit of Measure");
    //               lrc_ShipAgentFreightcost.SETFILTER("Valid From",'<=%1',rrc_AssortmentVersionLine."Starting Date Assortment");
    //               IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //                 rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                            ROUND(lrc_ShipAgentFreightcost."Freight Rate per Unit" /
    //                                                                            rrc_AssortmentVersionLine."Qty. Unit per TU",0.01,'>');
    //               END ELSE BEGIN
    //                 rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                            100;
    //               END;

    //             END ELSE BEGIN

    //               IF (rrc_AssortmentVersionLine."Entry Location Code" <> '') AND
    //                  ((rrc_AssortmentVersionLine."Entry via Transfer Loc. Code" <> '') OR
    //                   (rrc_AssortmentVersionLine."Entry Location Code" <> rrc_AssortmentVersionLine."Entry via Transfer Loc. Code")) THEN BEGIN

    //                 lco_DepartureRegion := '';
    //                 lco_ArrivalRegion := '';
    //                 IF lrc_Location.GET(rrc_AssortmentVersionLine."Entry via Transfer Loc. Code") THEN
    //                   lco_DepartureRegion := lrc_Location."Departure Region Code";
    //                 IF lrc_Location.GET(rrc_AssortmentVersionLine."Entry Location Code") THEN
    //                   lco_ArrivalRegion := lrc_Location."Arrival Region Code";

    //                 IF NOT lrc_ShippingAgent.GET(rrc_AssortmentVersionLine."Shipping Agent Code") THEN
    //                   lrc_ShippingAgent.INIT();

    //                 lrc_ShipAgentFreightcost.Reset();
    //                 lrc_ShipAgentFreightcost.SETRANGE("Shipping Agent Code",rrc_AssortmentVersionLine."Shipping Agent Code");
    //                 lrc_ShipAgentFreightcost.SETRANGE("Departure Region Code",lco_DepartureRegion);
    //                 lrc_ShipAgentFreightcost.SETRANGE("Arrival Region Code",lco_ArrivalRegion);
    //                 lrc_ShipAgentFreightcost.SETRANGE("Freight Cost Tarif Base",
    //                                                   lrc_ShippingAgent."Freight Cost Tariff Base");
    //                 IF lrc_ShippingAgent."Freight Cost Tariff Base" = lrc_ShippingAgent."Freight Cost Tariff Base"::"Pallet Type" THEN
    //                   lrc_ShipAgentFreightcost.SETRANGE("Freight Unit of Measure Code",rrc_AssortmentVersionLine."Freight Unit of Measure");
    //                 lrc_ShipAgentFreightcost.SETFILTER("Valid From",'<=%1',rrc_AssortmentVersionLine."Starting Date Assortment");
    //                 IF lrc_ShipAgentFreightcost.FINDFIRST() THEN BEGIN
    //                   rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                              ROUND(lrc_ShipAgentFreightcost."Freight Rate per Unit" /
    //                                                                              rrc_AssortmentVersionLine."Qty. Unit per TU",0.01,'>');
    //                 END ELSE BEGIN
    //                   rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                              100;
    //                 END;

    //               END;

    //             END;
    //             END;
    //           END;

    //         END;


    //         // ----------------------------------------------------------------------------
    //         // Plankosten berechnen
    //         // ----------------------------------------------------------------------------
    //         rrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)" := 0;
    //         rrc_AssortmentVersionLine."Cost Calc. Amount (LCY)" := 0;

    //         lrc_CostCategory.SETRANGE("Indirect Cost (Purchase)",TRUE);
    //         IF lrc_CostCategory.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT
    //             lrc_StandardCostCalculations.Reset();

    //             lrc_StandardCostCalculations.SETCURRENTKEY("Cost Category Code","Buy-From Vendor No.","Via Entry Location Code",
    //               "Entry Location Code","Shipping Agent Code","Customer Duty","Product Group Code","Item No.",
    //               "Item Country of Origin Code","Valid From");
    //             lrc_StandardCostCalculations.SETRANGE("Cost Category Code",lrc_CostCategory.Code);
    //             lrc_StandardCostCalculations.SETFILTER("Buy-From Vendor No.",'%1|%2',rrc_AssortmentVersionLine."Vendor No.",'');
    //             lrc_StandardCostCalculations.SETFILTER("Via Entry Location Code",'%1|%2',
    //                                                    rrc_AssortmentVersionLine."Entry via Transfer Loc. Code",'');
    //             lrc_StandardCostCalculations.SETFILTER("Entry Location Code",'%1|%2',
    //                                                    rrc_AssortmentVersionLine."Entry Location Code",'');
    //             lrc_StandardCostCalculations.SETFILTER("Item Category Code",'%1|%2',rrc_AssortmentVersionLine."Item Category Code",'');
    //             lrc_StandardCostCalculations.SETFILTER("Product Group Code",'%1|%2',rrc_AssortmentVersionLine."Product Group Code",'');
    //             lrc_StandardCostCalculations.SETFILTER("Item No.",'%1|%2',rrc_AssortmentVersionLine."Item No.",'');
    //             lrc_StandardCostCalculations.SETFILTER("Item Country of Origin Code",'%1|%2',
    //                                                    rrc_AssortmentVersionLine."Country of Origin Code",'');
    //             lrc_StandardCostCalculations.SETFILTER("Shipping Agent Code",'%1|%2',
    //                                                    rrc_AssortmentVersionLine."Shipping Agent Code",'');

    //             lrc_StandardCostCalculations.SETFILTER("Valid From",'<=%1',rrc_AssortmentVersionLine."Starting Date Assortment");
    //             lrc_StandardCostCalculations.SETFILTER("Valid Till",'>=%1|%2',rrc_AssortmentVersionLine."Starting Date Assortment",0D);
    //             IF lrc_StandardCostCalculations.FINDLAST THEN BEGIN
    //               CASE lrc_StandardCostCalculations.Reference OF
    //               lrc_StandardCostCalculations.Reference::Collo:
    //                 BEGIN
    //                   rrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)" := rrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)" +
    //                                       ROUND(lrc_StandardCostCalculations."Reference Amount",0.01,'>');
    //                 END;
    //               lrc_StandardCostCalculations.Reference::Pallet:
    //                 BEGIN
    //                   rrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)" := rrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)" +
    //                                       ROUND(lrc_StandardCostCalculations."Reference Amount" /
    //                                             rrc_AssortmentVersionLine."Qty. Unit per TU",0.01,'>');
    //                 END;
    //               END;
    //             END;
    //           UNTIL lrc_CostCategory.NEXT() = 0;
    //         END;


    //         // ----------------------------------------------------------------------------
    //         // Indirekte Kosten berechnen (Frachtkosten und Einkaufsplankosten)
    //         // ----------------------------------------------------------------------------
    //         rrc_AssortmentVersionLine."Indirect Cost Amt (Unit) (LCY)" := rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                                       rrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)";


    //         // ----------------------------------------------------------------------------
    //         // Einstandspreis berechnen
    //         // ----------------------------------------------------------------------------
    //         rrc_AssortmentVersionLine."Unit Cost (LCY)" := rrc_AssortmentVersionLine."Direct Unit Cost (LCY)" +
    //                                                        rrc_AssortmentVersionLine."Freight Cost per Unit (LCY)" +
    //                                                        rrc_AssortmentVersionLine."Cost Calc. per Unit (LCY)";

    //         rrc_AssortmentVersionLine."Unit Cost (LCY)" := ROUND(rrc_AssortmentVersionLine."Unit Cost (LCY)" /
    //                                                        rrc_AssortmentVersionLine."Qty. per Unit of Measure",0.01,'>');

    //         rrc_AssortmentVersionLine."Unit Cost (LCY)" := rrc_AssortmentVersionLine."Unit Cost (LCY)" *
    //                                                        rrc_AssortmentVersionLine."Qty. per Unit of Measure";
    //     end;

    //     procedure FindAssortmentEntry(vco_BatchVarCode: Code[20])
    //     var
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Sortimentseintrag finden um dann einen Preis zu finden
    //         // -----------------------------------------------------------------------------------------

    //         lrc_BatchVariant.GET(vco_BatchVarCode);

    //         //xx lrc_AssortmentVersionLine."Starting Date Assortment"
    //         //xx lrc_AssortmentVersionLine."Ending Date Assortment"

    //         lrc_AssortmentVersionLine.SETRANGE("Item No.",lrc_BatchVariant."Item No.");
    //         lrc_AssortmentVersionLine.SETRANGE("Variant Code",lrc_BatchVariant."Variant Code");
    //         lrc_AssortmentVersionLine.SETRANGE("Variety Code",lrc_BatchVariant."Variety Code");
    //         lrc_AssortmentVersionLine.SETRANGE("Country of Origin Code",lrc_BatchVariant."Country of Origin Code");

    //         lrc_AssortmentVersionLine.SETRANGE("Caliber Code",lrc_BatchVariant."Caliber Code");

    //         lrc_AssortmentVersionLine.SETFILTER("Trademark Code",'%1|%2','',lrc_BatchVariant."Trademark Code");
    //         IF lrc_AssortmentVersionLine.isempty()THEN BEGIN

    //         END ELSE BEGIN

    //         END;
    //     end;

    //     procedure AssortCopyLineFromPurchOrder(vco_AssortVersionNo: Code[20])
    //     var
    //         lrc_AssortmentVersion: Record "5110339";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_PurchHeader: Record "38";
    //         lrc_PurchLine: Record "39";
    //         lfm_PurchOrderLineList: Form "5110333";
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion um eine Einkaufszeile in ein Sortiment zu laden
    //         // ---------------------------------------------------------------------------------------

    //         lrc_AssortmentVersion.GET(vco_AssortVersionNo);

    //         lrc_PurchLine.FILTERGROUP(2);
    //         lrc_PurchLine.SETRANGE("Document Type",lrc_PurchLine."Document Type"::Order);
    //         lrc_PurchLine.SETRANGE(Type,lrc_PurchLine.Type::Item);
    //         lrc_PurchLine.SETFILTER("No.",'<>%1','');
    //         lrc_PurchLine.SETFILTER("Batch Variant No.",'<>%1','');
    //         lrc_PurchLine.FILTERGROUP(0);

    //         lfm_PurchOrderLineList.SETTABLEVIEW(lrc_PurchLine);
    //         lfm_PurchOrderLineList.LOOKUPMODE := TRUE;
    //         IF lfm_PurchOrderLineList.RUNMODAL <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_PurchLine.Reset();
    //         lfm_PurchOrderLineList.GETRECORD(lrc_PurchLine);

    //         lrc_PurchHeader.GET(lrc_PurchLine."Document Type",lrc_PurchLine."Document No.");

    //         lrc_AssortmentVersionLine.Reset();
    //         lrc_AssortmentVersionLine.INIT();
    //         lrc_AssortmentVersionLine."Assortment Version No." := lrc_AssortmentVersion."No.";
    //         lrc_AssortmentVersionLine."Line No." := 0;
    //         lrc_AssortmentVersionLine.INSERT(TRUE);

    //         lrc_AssortmentVersionLine.VALIDATE("Item No.",lrc_PurchLine."No.");
    //         lrc_AssortmentVersionLine.VALIDATE("Variant Code",lrc_PurchLine."Variant Code");
    //         lrc_AssortmentVersionLine.VALIDATE("Vendor No.",lrc_PurchLine."Buy-from Vendor No.");

    //         lrc_AssortmentVersionLine.VALIDATE("Shipment Method Code",lrc_PurchHeader."Shipment Method Code");
    //         lrc_AssortmentVersionLine.VALIDATE("Entry Location Code",lrc_PurchLine."Location Code");
    //         lrc_AssortmentVersionLine.VALIDATE("Entry via Transfer Loc. Code",lrc_PurchLine."Entry via Transfer Loc. Code");
    //         lrc_AssortmentVersionLine.VALIDATE("Ship-Agent Code to Transf. Loc",lrc_PurchLine."Ship-Agent Code to Transf. Loc");
    //         lrc_AssortmentVersionLine.VALIDATE("Shipping Agent Code",lrc_PurchLine."Shipping Agent Code");

    //         lrc_AssortmentVersionLine."Country of Origin Code" := lrc_PurchLine."Country of Origin Code";
    //         lrc_AssortmentVersionLine."Variety Code" := lrc_PurchLine."Variety Code";
    //         lrc_AssortmentVersionLine."Trademark Code" := lrc_PurchLine."Trademark Code";
    //         lrc_AssortmentVersionLine.VALIDATE("Caliber Code",lrc_PurchLine."Caliber Code");
    //         lrc_AssortmentVersionLine."Vendor Caliber Code" := lrc_PurchLine."Vendor Caliber Code";
    //         lrc_AssortmentVersionLine.VALIDATE("Item Attribute 3",lrc_PurchLine."Item Attribute 3");
    //         lrc_AssortmentVersionLine.VALIDATE("Item Attribute 2",lrc_PurchLine."Item Attribute 2");
    //         lrc_AssortmentVersionLine.VALIDATE("Grade of Goods Code",lrc_PurchLine."Grade of Goods Code");
    //         lrc_AssortmentVersionLine."Cultivation Type" := lrc_PurchLine."Cultivation Type";
    //         lrc_AssortmentVersionLine."Cultivation Association Code" := lrc_PurchLine."Cultivation Association Code";
    //         lrc_AssortmentVersionLine."Item Attribute 1" := lrc_PurchLine."Item Attribute 1";
    //         lrc_AssortmentVersionLine.VALIDATE("Empties Item No.",lrc_PurchLine."Empties Item No.");

    //         lrc_AssortmentVersionLine.VALIDATE("Unit of Measure Code",lrc_PurchLine."Unit of Measure Code");
    //         lrc_AssortmentVersionLine.VALIDATE("Transport Unit of Measure (TU)",lrc_PurchLine."Transport Unit of Measure (TU)");
    //         lrc_AssortmentVersionLine.VALIDATE("Qty. Unit per TU",lrc_PurchLine."Qty. (Unit) per Transp.(TU)");
    //         lrc_AssortmentVersionLine.VALIDATE("No. of Layers on TU",lrc_PurchLine."No. of Layers on TU");

    //         lrc_AssortmentVersionLine.VALIDATE("Price Base (Purch. Price)",lrc_PurchLine."Price Base (Purch. Price)");
    //         lrc_AssortmentVersionLine.VALIDATE("Purch. Price (Price Base)",lrc_PurchLine."Purch. Price (Price Base)");

    //         lrc_AssortmentVersionLine.Weight := lrc_PurchLine.Weight;
    //         lrc_AssortmentVersionLine."Gross Weight" := lrc_PurchLine."Gross Weight";
    //         lrc_AssortmentVersionLine."Net Weight" := lrc_PurchLine."Net Weight";

    //         lrc_AssortmentVersionLine.MODIFY(TRUE);
    //     end;

    //     procedure AssortSelectLinesFromPurchOrd(vco_AssortVersionNo: Code[20])
    //     var
    //         lcu_SingleInstanceMgt: Codeunit "5087902";
    //         lrc_PurchLine: Record "39";
    //         lfm_PurchOrderLineList: Form "5110333";
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion um eine oder mehrere Einkaufszeile zu selektieren und in ein Sortiment zu laden
    //         // -----------------------------------------------------------------------------------------

    //         lcu_SingleInstanceMgt.SetAssortmentVersionNo(vco_AssortVersionNo);

    //         lrc_PurchLine.FILTERGROUP(2);
    //         lrc_PurchLine.SETRANGE("Document Type",lrc_PurchLine."Document Type"::Order);
    //         lrc_PurchLine.SETRANGE(Type,lrc_PurchLine.Type::Item);
    //         lrc_PurchLine.SETFILTER("No.",'<>%1','');
    //         lrc_PurchLine.SETFILTER("Batch Variant No.",'<>%1','');
    //         lrc_PurchLine.FILTERGROUP(0);

    //         lfm_PurchOrderLineList.SETTABLEVIEW(lrc_PurchLine);
    //         lfm_PurchOrderLineList.LOOKUPMODE := TRUE;
    //         lfm_PurchOrderLineList.RUNMODAL;
    //     end;

    //     procedure AssortCopyLinesFromPurchOrder(vrc_PurchLine: Record "39")
    //     var
    //         lcu_SingleInstanceMgt: Codeunit "5087902";
    //         lrc_AssortmentVersion: Record "5110339";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lrc_PurchHeader: Record "38";
    //         lco_AssortVersionNo: Code[20];
    //     begin
    //         // ---------------------------------------------------------------------------------------
    //         // Funktion um eine oder mehrere Einkaufszeile in ein Sortiment zu laden
    //         // ---------------------------------------------------------------------------------------

    //         lco_AssortVersionNo := lcu_SingleInstanceMgt.GetAssortmentVersionNo();
    //         lrc_AssortmentVersion.GET(lco_AssortVersionNo);


    //         IF vrc_PurchLine.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             lrc_PurchHeader.GET(vrc_PurchLine."Document Type",vrc_PurchLine."Document No.");

    //             lrc_AssortmentVersionLine.Reset();
    //             lrc_AssortmentVersionLine.INIT();
    //             lrc_AssortmentVersionLine."Assortment Version No." := lrc_AssortmentVersion."No.";
    //             lrc_AssortmentVersionLine."Line No." := 0;
    //             lrc_AssortmentVersionLine.INSERT(TRUE);

    //             lrc_AssortmentVersionLine.VALIDATE("Item No.",vrc_PurchLine."No.");
    //             lrc_AssortmentVersionLine.VALIDATE("Variant Code",vrc_PurchLine."Variant Code");
    //             lrc_AssortmentVersionLine.VALIDATE("Vendor No.",vrc_PurchLine."Buy-from Vendor No.");

    //             lrc_AssortmentVersionLine.VALIDATE("Shipment Method Code",lrc_PurchHeader."Shipment Method Code");
    //             lrc_AssortmentVersionLine.VALIDATE("Entry Location Code",vrc_PurchLine."Location Code");
    //             lrc_AssortmentVersionLine.VALIDATE("Entry via Transfer Loc. Code",vrc_PurchLine."Entry via Transfer Loc. Code");
    //             lrc_AssortmentVersionLine.VALIDATE("Ship-Agent Code to Transf. Loc",vrc_PurchLine."Ship-Agent Code to Transf. Loc");
    //             lrc_AssortmentVersionLine.VALIDATE("Shipping Agent Code",vrc_PurchLine."Shipping Agent Code");

    //             lrc_AssortmentVersionLine."Country of Origin Code" := vrc_PurchLine."Country of Origin Code";
    //             lrc_AssortmentVersionLine."Variety Code" := vrc_PurchLine."Variety Code";
    //             lrc_AssortmentVersionLine."Trademark Code" := vrc_PurchLine."Trademark Code";
    //             lrc_AssortmentVersionLine.VALIDATE("Caliber Code",vrc_PurchLine."Caliber Code");
    //             lrc_AssortmentVersionLine."Vendor Caliber Code" := vrc_PurchLine."Vendor Caliber Code";
    //             lrc_AssortmentVersionLine.VALIDATE("Item Attribute 3",vrc_PurchLine."Item Attribute 3");
    //             lrc_AssortmentVersionLine.VALIDATE("Item Attribute 2",vrc_PurchLine."Item Attribute 2");
    //             lrc_AssortmentVersionLine.VALIDATE("Grade of Goods Code",vrc_PurchLine."Grade of Goods Code");
    //             lrc_AssortmentVersionLine."Cultivation Type" := vrc_PurchLine."Cultivation Type";
    //             lrc_AssortmentVersionLine."Cultivation Association Code" := vrc_PurchLine."Cultivation Association Code";
    //             lrc_AssortmentVersionLine."Item Attribute 1" := vrc_PurchLine."Item Attribute 1";
    //             lrc_AssortmentVersionLine.VALIDATE("Empties Item No.",vrc_PurchLine."Empties Item No.");

    //             lrc_AssortmentVersionLine.VALIDATE("Unit of Measure Code",vrc_PurchLine."Unit of Measure Code");

    //             lrc_AssortmentVersionLine.VALIDATE("Transport Unit of Measure (TU)",vrc_PurchLine."Transport Unit of Measure (TU)");
    //             lrc_AssortmentVersionLine.VALIDATE("Qty. Unit per TU",vrc_PurchLine."Qty. (Unit) per Transp.(TU)");
    //             lrc_AssortmentVersionLine.VALIDATE("No. of Layers on TU",vrc_PurchLine."No. of Layers on TU");

    //             lrc_AssortmentVersionLine.VALIDATE("Price Base (Purch. Price)",vrc_PurchLine."Price Base (Purch. Price)");
    //             lrc_AssortmentVersionLine.VALIDATE("Purch. Price (Price Base)",vrc_PurchLine."Purch. Price (Price Base)");

    //             lrc_AssortmentVersionLine.Weight := vrc_PurchLine.Weight;
    //             lrc_AssortmentVersionLine."Gross Weight" := vrc_PurchLine."Gross Weight";
    //             lrc_AssortmentVersionLine."Net Weight" := vrc_PurchLine."Net Weight";

    //             lrc_AssortmentVersionLine.MODIFY(TRUE);

    //           UNTIL vrc_PurchLine.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PurchOrderCopyLinesFromAssort(vop_PruchDocType: Option;vco_PruchDocNo: Code[20])
    //     var
    //         lrc_PurchHeader: Record "38";
    //         lrc_PurchLine: Record "39";
    //         lrc_AssortmentVersionLine: Record "5110340";
    //         lin_LineNo: Integer;
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion um aus dem Einkauf Sortimentszeilen in den Einkauf zu kopieren
    //         // -----------------------------------------------------------------------------------------

    //         lrc_PurchHeader.GET(vop_PruchDocType,vco_PruchDocNo);

    //         lrc_PurchLine.Reset();
    //         lrc_PurchLine.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //         lrc_PurchLine.SETRANGE("Document No.",lrc_PurchHeader."No.");
    //         IF lrc_PurchLine.FINDLAST THEN
    //           lin_LineNo := lrc_PurchLine."Line No."
    //         ELSE
    //           lin_LineNo := 0;

    //         lrc_AssortmentVersionLine.Reset();
    //         lrc_AssortmentVersionLine.SETFILTER("Vendor No.",'%1|%2',lrc_PurchHeader."Buy-from Vendor No.",'');
    //         lrc_AssortmentVersionLine.SETFILTER("Starting Date Assortment",'<=%1',TODAY);
    //         lrc_AssortmentVersionLine.SETFILTER("Ending Date Assortment",'>=%1',TODAY);

    //         IF FORM.RUNMODAL(5088172,lrc_AssortmentVersionLine) <> ACTION::LookupOK THEN
    //           EXIT;

    //         lrc_PurchLine.Reset();
    //         lrc_PurchLine.INIT();
    //         lrc_PurchLine."Document Type" := lrc_PurchHeader."Document Type";
    //         lrc_PurchLine."Document No." := lrc_PurchHeader."No.";
    //         lin_LineNo := lin_LineNo + 10000;
    //         lrc_PurchLine."Line No." := lin_LineNo;
    //         lrc_PurchLine.INSERT(TRUE);

    //         lrc_PurchLine.VALIDATE(Type,lrc_PurchLine.Type::Item);
    //         lrc_PurchLine.VALIDATE("No.",lrc_AssortmentVersionLine."Item No.");
    //         lrc_PurchLine.VALIDATE("Variant Code",lrc_AssortmentVersionLine."Variant Code");

    //         lrc_PurchLine.VALIDATE("Entry via Transfer Loc. Code",lrc_AssortmentVersionLine."Entry via Transfer Loc. Code");
    //         lrc_PurchLine.VALIDATE("Location Code",lrc_AssortmentVersionLine."Entry Location Code");

    //         lrc_PurchLine.VALIDATE("Unit of Measure Code",lrc_AssortmentVersionLine."Unit of Measure Code");
    //         lrc_PurchLine.VALIDATE("Country of Origin Code",lrc_AssortmentVersionLine."Country of Origin Code");
    //         lrc_PurchLine.VALIDATE("Variety Code",lrc_AssortmentVersionLine."Variety Code");
    //         IF lrc_AssortmentVersionLine."Trademark Code" <> '' THEN
    //           lrc_PurchLine.VALIDATE("Trademark Code",lrc_AssortmentVersionLine."Trademark Code");
    //         lrc_PurchLine.VALIDATE("Caliber Code",lrc_AssortmentVersionLine."Caliber Code");
    //         lrc_PurchLine.VALIDATE("Vendor Caliber Code",lrc_AssortmentVersionLine."Vendor Caliber Code");
    //         lrc_PurchLine.VALIDATE("Item Attribute 3",lrc_AssortmentVersionLine."Item Attribute 3");
    //         lrc_PurchLine.VALIDATE("Item Attribute 2",lrc_AssortmentVersionLine."Item Attribute 2");
    //         lrc_PurchLine.VALIDATE("Grade of Goods Code",lrc_AssortmentVersionLine."Grade of Goods Code");
    //         lrc_PurchLine.VALIDATE("Item Attribute 7",lrc_AssortmentVersionLine."Item Attribute 7");
    //         lrc_PurchLine.VALIDATE("Item Attribute 4",lrc_AssortmentVersionLine."Item Attribute 4");
    //         lrc_PurchLine.VALIDATE("Coding Code",lrc_AssortmentVersionLine."Coding Code");
    //         lrc_PurchLine.VALIDATE("Item Attribute 5",lrc_AssortmentVersionLine."Item Attribute 5");
    //         lrc_PurchLine.VALIDATE("Item Attribute 6",lrc_AssortmentVersionLine."Item Attribute 6");
    //         lrc_PurchLine.VALIDATE("Cultivation Type",lrc_AssortmentVersionLine."Cultivation Type");
    //         lrc_PurchLine.VALIDATE("Cultivation Association Code",lrc_AssortmentVersionLine."Cultivation Association Code");
    //         lrc_PurchLine.VALIDATE("Item Attribute 1",lrc_AssortmentVersionLine."Item Attribute 1");

    //         lrc_PurchLine.VALIDATE("Empties Item No.",lrc_AssortmentVersionLine."Empties Item No.");
    //         lrc_PurchLine.MODIFY(TRUE);
    //     end;

    //     procedure AssortCopyLinesToPurchOrder(vrc_AssortmentVersionLine: Record "5110340")
    //     var
    //         lrc_PurchHeader: Record "38";
    //         lrc_PurchLine: Record "39";
    //         lin_LineNo: Integer;
    //     begin
    //         // -----------------------------------------------------------------------------------------
    //         // Funktion um aus dem Sortiment Zeilen in einen Einkauf zu kopieren
    //         // -----------------------------------------------------------------------------------------

    //         lrc_PurchHeader.FILTERGROUP(2);
    //         lrc_PurchHeader.SETRANGE("Document Type",lrc_PurchHeader."Document Type"::Order);
    //         lrc_PurchHeader.SETFILTER("Expected Receipt Date",'>=%1',TODAY);
    //         lrc_PurchHeader.FILTERGROUP(0);

    //         IF FORM.RUNMODAL(0,lrc_PurchHeader) <> ACTION::LookupOK THEN BEGIN
    //           EXIT;
    //         END;


    //         lrc_PurchLine.Reset();
    //         lrc_PurchLine.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //         lrc_PurchLine.SETRANGE("Document No.",lrc_PurchHeader."No.");
    //         IF lrc_PurchLine.FINDLAST THEN
    //           lin_LineNo := lrc_PurchLine."Line No."
    //         ELSE
    //           lin_LineNo := 0;


    //         lrc_PurchLine.Reset();
    //         lrc_PurchLine.INIT();
    //         lrc_PurchLine."Document Type" := lrc_PurchHeader."Document Type";
    //         lrc_PurchLine."Document No." := lrc_PurchHeader."No.";
    //         lin_LineNo := lin_LineNo + 10000;
    //         lrc_PurchLine."Line No." := lin_LineNo;
    //         lrc_PurchLine.INSERT(TRUE);

    //         lrc_PurchLine.VALIDATE(Type,lrc_PurchLine.Type::Item);
    //         lrc_PurchLine.VALIDATE("No.",vrc_AssortmentVersionLine."Item No.");
    //         lrc_PurchLine.VALIDATE("Variant Code",vrc_AssortmentVersionLine."Variant Code");

    //         lrc_PurchLine.VALIDATE("Entry via Transfer Loc. Code",vrc_AssortmentVersionLine."Entry via Transfer Loc. Code");
    //         lrc_PurchLine.VALIDATE("Location Code",vrc_AssortmentVersionLine."Entry Location Code");

    //         lrc_PurchLine.VALIDATE("Unit of Measure Code",vrc_AssortmentVersionLine."Unit of Measure Code");
    //         lrc_PurchLine.VALIDATE("Country of Origin Code",vrc_AssortmentVersionLine."Country of Origin Code");
    //         lrc_PurchLine.VALIDATE("Variety Code",vrc_AssortmentVersionLine."Variety Code");
    //         IF vrc_AssortmentVersionLine."Trademark Code" <> '' THEN
    //           lrc_PurchLine.VALIDATE("Trademark Code",vrc_AssortmentVersionLine."Trademark Code");
    //         lrc_PurchLine.VALIDATE("Caliber Code",vrc_AssortmentVersionLine."Caliber Code");
    //         lrc_PurchLine.VALIDATE("Vendor Caliber Code",vrc_AssortmentVersionLine."Vendor Caliber Code");
    //         lrc_PurchLine.VALIDATE("Item Attribute 3",vrc_AssortmentVersionLine."Item Attribute 3");
    //         lrc_PurchLine.VALIDATE("Item Attribute 2",vrc_AssortmentVersionLine."Item Attribute 2");
    //         lrc_PurchLine.VALIDATE("Grade of Goods Code",vrc_AssortmentVersionLine."Grade of Goods Code");
    //         lrc_PurchLine.VALIDATE("Item Attribute 7",vrc_AssortmentVersionLine."Item Attribute 7");
    //         lrc_PurchLine.VALIDATE("Item Attribute 4",vrc_AssortmentVersionLine."Item Attribute 4");
    //         lrc_PurchLine.VALIDATE("Coding Code",vrc_AssortmentVersionLine."Coding Code");
    //         lrc_PurchLine.VALIDATE("Item Attribute 5",vrc_AssortmentVersionLine."Item Attribute 5");
    //         lrc_PurchLine.VALIDATE("Item Attribute 6",vrc_AssortmentVersionLine."Item Attribute 6");
    //         lrc_PurchLine.VALIDATE("Cultivation Type",vrc_AssortmentVersionLine."Cultivation Type");
    //         lrc_PurchLine.VALIDATE("Cultivation Association Code",vrc_AssortmentVersionLine."Cultivation Association Code");
    //         lrc_PurchLine.VALIDATE("Item Attribute 1",vrc_AssortmentVersionLine."Item Attribute 1");

    //         lrc_PurchLine.VALIDATE("Empties Item No.",vrc_AssortmentVersionLine."Empties Item No.");
    //         lrc_PurchLine.MODIFY(TRUE);
    //     end;

    //     procedure CopyDoc(vrc_FromSalesHeader: Record "36";vrc_ToSalesHeader: Record "36")
    //     var
    //         lrc_FromSalesLine: Record "37";
    //         lrc_ToSalesLine: Record "37";
    //         lrc_FromDocDim: Record "357";
    //         lrc_ToDocDim: Record "357";
    //         lrc_FromSalesDiscount: Record "5110344";
    //         lrc_ToSalesDiscount: Record "5110344";
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Auftrag kopieren
    //         // -----------------------------------------------------------------------------

    //         // Zeilen kopieren
    //         lrc_FromSalesLine.SETRANGE("Document Type",vrc_FromSalesHeader."Document Type");
    //         lrc_FromSalesLine.SETRANGE("Document No.",vrc_FromSalesHeader."No.");
    //         IF lrc_FromSalesLine.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_ToSalesLine.Reset();
    //             lrc_ToSalesLine.INIT();
    //             lrc_ToSalesLine.TRANSFERFIELDS(lrc_FromSalesLine);
    //             lrc_ToSalesLine."Document No." := vrc_ToSalesHeader."No.";
    //             lrc_ToSalesLine."Line No." := lrc_FromSalesLine."Line No.";
    //             lrc_ToSalesLine."Sell-to Customer No." := vrc_ToSalesHeader."Sell-to Customer No.";
    //             lrc_ToSalesLine."Bill-to Customer No." := vrc_ToSalesHeader."Bill-to Customer No.";

    //             // Datumsfelder setzen falls abweichend vom Kopfsatz
    //             IF lrc_ToSalesLine."Shipment Date" <> vrc_ToSalesHeader."Shipment Date" THEN
    //               lrc_ToSalesLine."Shipment Date" := vrc_ToSalesHeader."Shipment Date";
    //             IF lrc_ToSalesLine."Requested Delivery Date" <> vrc_ToSalesHeader."Requested Delivery Date" THEN
    //               lrc_ToSalesLine."Requested Delivery Date" := vrc_ToSalesHeader."Requested Delivery Date";
    //             IF lrc_ToSalesLine."Promised Delivery Date" <> vrc_ToSalesHeader."Promised Delivery Date" THEN
    //               lrc_ToSalesLine."Promised Delivery Date" := vrc_ToSalesHeader."Promised Delivery Date";

    //             lrc_ToSalesLine.insert();
    //           UNTIL lrc_FromSalesLine.NEXT() = 0;

    //           // Kopieren der Dimensionen Auftragszeilen (Auftragskopf wird durch Anlage erzeugt)
    //           lrc_FromDocDim.SETFILTER("Table ID",'%1|%2',36,37);
    //           lrc_FromDocDim.SETRANGE("Document Type",vrc_FromSalesHeader."Document Type");
    //           lrc_FromDocDim.SETRANGE("Document No.",vrc_FromSalesHeader."No.");
    //           lrc_FromDocDim.SETFILTER("Line No.",'<>%1',0);
    //           IF lrc_FromDocDim.FIND('-') THEN
    //             REPEAT
    //               lrc_ToDocDim.Reset();
    //               lrc_ToDocDim.INIT();
    //               lrc_ToDocDim.TRANSFERFIELDS(lrc_FromDocDim);
    //               lrc_ToDocDim."Table ID" := lrc_FromDocDim."Table ID";
    //               lrc_ToDocDim."Document No." := vrc_ToSalesHeader."No.";
    //               lrc_ToDocDim."Line No." := lrc_FromDocDim."Line No.";
    //               lrc_ToDocDim.insert();
    //             UNTIL lrc_FromDocDim.NEXT() = 0;

    //           // Kopieren der Rabatte
    //           lrc_FromSalesDiscount.SETRANGE("Document Type",vrc_FromSalesHeader."Document Type");
    //           lrc_FromSalesDiscount.SETRANGE("Document No.",vrc_FromSalesHeader."No.");
    //           IF lrc_FromSalesDiscount.FIND('-') THEN
    //             REPEAT
    //               lrc_ToSalesDiscount.Reset();
    //               lrc_ToSalesDiscount.INIT();
    //               lrc_ToSalesDiscount.TRANSFERFIELDS(lrc_FromSalesDiscount);
    //               lrc_ToSalesDiscount."Document No." := vrc_ToSalesHeader."No.";
    //               lrc_ToSalesDiscount."Entry No." := lrc_FromSalesDiscount."Entry No.";
    //               lrc_ToSalesDiscount."Sell-to Customer No." := vrc_ToSalesHeader."Sell-to Customer No.";
    //               IF NOT lrc_ToSalesDiscount.INSERT THEN;
    //             UNTIL lrc_FromSalesDiscount.NEXT() = 0;
    //         END;
    //     end;
}

