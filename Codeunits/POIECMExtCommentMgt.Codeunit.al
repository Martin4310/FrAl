codeunit 5110317 "POI ECM Ext. Comment Mgt"
{
    //     var
    //         gop_PurchDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Receipt","Posted Invoice","Posted Return Shipment","Posted Credit Memo","Arch. Quote","Arch. Order","Arch. Blanket Order";
    //         gop_SalesDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo","Arch. Quote","Arch. Order","Arch. Blanket Order";
    //         gin_VersionNo: Integer;

    //     procedure SalesHeaderComment(vrc_SalesHeader: Record "36")
    //     var
    //         lcu_Sales: Codeunit "5110324";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lfm_SalesComment: Form "5110500";
    //         "lin_ArrZähler": Integer;
    //         lco_ArrShippingAgent: array [1000] of Code[20];
    //         lco_ArrPhysLocation: array [1000] of Code[20];
    //         lco_ArrLocation: array [1000] of Code[20];
    //         lco_ArrDepartRegion: array [1000] of Code[20];
    //         lbn_Check: Boolean;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Kopf
    //         // ------------------------------------------------------------------------------------

    //         vrc_SalesHeader.TESTFIELD("No.");

    //         // Alle Lagerorte in Array schreiben
    //         lcu_Sales.FillArrLocation(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrLocation);
    //         // Alle Lagerortgruppen in Array schreiben
    //         lcu_Sales.FillArrLocationGroup(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrPhysLocation);
    //         // Alle Zusteller in Array schreiben
    //         lcu_Sales.FillArrShippingAgent(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrShippingAgent);
    //         // Alle Abgangsregionen in Array schreiben
    //         lcu_Sales.FillArrDepartureRegion(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrDepartRegion);


    //         lrc_SalesComment.FILTERGROUP(2);
    //         lrc_SalesComment.SETRANGE("Document Source",lrc_SalesComment."Document Source"::Header);
    //         lrc_SalesComment.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //         lrc_SalesComment.SETRANGE("Document No.",vrc_SalesHeader."No.");
    //         lrc_SalesComment.SETRANGE("Document Line No.",0);
    //         lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //         lrc_SalesComment.FILTERGROUP(0);
    //         IF lrc_SalesComment.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             // Zuordnung Druckbelege löschen falls nicht zugeordnet
    //             lrc_SalesCommentPrintDoc.Reset();
    //             lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //             lrc_SalesCommentPrintDoc.SETRANGE(Print,FALSE);
    //             lrc_SalesCommentPrintDoc.DELETEALL();

    //             lrc_PrintDocument.Reset();
    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Sales);
    //             lrc_PrintDocument.SETRANGE("Document Type",(vrc_SalesHeader."Document Type" + 1));
    //             IF lrc_PrintDocument.FINDSET(FALSE,FALSE) THEN BEGIN
    //               REPEAT

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Keine Mehrfachgenerierung
    //                 // ----------------------------------------------------------------------------------------------
    //                 CASE lrc_PrintDocument."Multiple Entry for" OF
    //                   lrc_PrintDocument."Multiple Entry for"::" ":
    //                     BEGIN
    //                       lrc_SalesCommentPrintDoc.Reset();
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",'');
    //                       IF lrc_SalesCommentPrintDoc.isempty()THEN BEGIN
    //                         lrc_SalesCommentPrintDoc.Reset();
    //                         lrc_SalesCommentPrintDoc.INIT();
    //                         lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                         lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_SalesCommentPrintDoc."Detail Code" := '';
    //                         lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_SalesCommentPrintDoc.Print := FALSE;
    //                         lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                         lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                        END;
    //                      END;
    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::Location:
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                           IF lrc_SalesCommentPrintDoc.isempty()THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;

    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Lagerortgruppe
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Location Group":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrPhysLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrPhysLocation[lin_ArrZähler]);
    //                           IF lrc_SalesCommentPrintDoc.isempty()THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrPhysLocation[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Abgangsregion
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Departure Region":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrDepartRegion[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrDepartRegion[lin_ArrZähler]);
    //                           IF lrc_SalesCommentPrintDoc.isempty()THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrDepartRegion[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Zusteller
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrShippingAgent[lin_ArrZähler]);
    //                           IF lrc_SalesCommentPrintDoc.isempty()THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 END;

    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //             END;
    //           UNTIL lrc_SalesComment.NEXT() = 0;
    //         END;

    //         COMMIT;

    //         lfm_SalesComment.SetGlobals(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",0);
    //         lfm_SalesComment.SETTABLEVIEW(lrc_SalesComment);
    //         lfm_SalesComment.RUNMODAL;
    //     end;

    //     procedure SalesShowComment(vrc_SalesComment: Record "5110427")
    //     var
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesCommentLine: Record "5110427";
    //         lfm_SalesCommentCard: Form "5110501";
    //         Text01: Label 'Bitte wählen Sie einen gültigen Eintrag aus!';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungskarte Kopf
    //         // ------------------------------------------------------------------------------------

    //         IF vrc_SalesComment."Entry No." <= 0 THEN
    //           // Bitte wählen Sie einen gültigen Eintrag aus!
    //           ERROR(Text01);

    //         lrc_SalesComment.FILTERGROUP(2);
    //         lrc_SalesComment.SETRANGE("Entry No.",vrc_SalesComment."Entry No.");
    //         lrc_SalesComment.SETRANGE("Entry Type",vrc_SalesComment."Entry Type");
    //         lrc_SalesComment.SETRANGE("Line No.",vrc_SalesComment."Line No.");
    //         lrc_SalesComment.FILTERGROUP(0);

    //         lfm_SalesCommentCard.SETTABLEVIEW(lrc_SalesComment);
    //         lfm_SalesCommentCard.RUNMODAL;

    //         // Erste Bemerkungszeile in Kopfsatz setzen oder löschen falls kein Bemerkungstext vorhanden
    //         SalesSetCommentFirstLine(vrc_SalesComment."Entry No.");
    //     end;

    //     procedure SalesNewComment(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];vin_DocLineNo: Integer)
    //     var
    //         lcu_Sales: Codeunit "5110324";
    //         lrc_SalesHeader: Record "36";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lfm_SalesCommentCard: Form "5110501";
    //         "lin_ArrZähler": Integer;
    //         lco_ArrShippingAgent: array [1000] of Code[20];
    //         lco_ArrPhysLocation: array [1000] of Code[20];
    //         lco_ArrLocation: array [1000] of Code[20];
    //         lco_ArrDepartRegion: array [1000] of Code[20];
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung einer neuen Bemerkung Kopf / Zeile
    //         // ------------------------------------------------------------------------------------

    //         lrc_SalesHeader.GET(vop_DocType,vco_DocNo);

    //         // Alle Lagerorte in Array schreiben
    //         lcu_Sales.FillArrLocation(vop_DocType,vco_DocNo,lco_ArrLocation);
    //         // Alle Physischen Lagerorte in Array schreiben
    //         lcu_Sales.FillArrLocationGroup(vop_DocType,vco_DocNo,lco_ArrPhysLocation);
    //         // Alle Zusteller in Array schreiben
    //         lcu_Sales.FillArrShippingAgent(vop_DocType,vco_DocNo,lco_ArrShippingAgent);
    //         // Alle Abgangsregionen in Array schreiben
    //         lcu_Sales.FillArrDepartureRegion(vop_DocType,vco_DocNo,lco_ArrDepartRegion);


    //         // Kopfsatz Bemerkung anlegen
    //         lrc_SalesComment.Reset();
    //         lrc_SalesComment.INIT();
    //         IF vin_DocLineNo = 0 THEN
    //           lrc_SalesComment."Document Source" := lrc_SalesComment."Document Source"::Header
    //         ELSE
    //           lrc_SalesComment."Document Source" := lrc_SalesComment."Document Source"::Line;
    //         lrc_SalesComment."Document Type" := lrc_SalesHeader."Document Type";
    //         lrc_SalesComment."Document No." := lrc_SalesHeader."No.";
    //         lrc_SalesComment."Document Line No." := vin_DocLineNo;
    //         lrc_SalesComment."Entry Type" := lrc_SalesComment."Entry Type"::Header;
    //         lrc_SalesComment."Entry No." := 0;
    //         lrc_SalesComment."Line No." := 0;
    //         IF vin_DocLineNo = 0 THEN
    //           lrc_SalesComment.Placement := lrc_SalesComment.Placement::Footer
    //         ELSE
    //           lrc_SalesComment.Placement := lrc_SalesComment.Placement::Line;
    //         lrc_SalesComment.Comment := '';
    //         lrc_SalesComment.INSERT(TRUE);

    //         // Filter mit Filtergruppe setzen
    //         lrc_SalesComment.FILTERGROUP(2);
    //         lrc_SalesComment.SETRANGE("Entry No.",lrc_SalesComment."Entry No.");
    //         lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type");
    //         lrc_SalesComment.SETRANGE("Line No.",lrc_SalesComment."Line No.");
    //         lrc_SalesComment.FILTERGROUP(0);

    //         // Druckbelege Laden für die Bemerkungen erfaßt werden können
    //         lrc_PrintDocument.Reset();
    //         lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Sales);
    //         //XOX
    //         lrc_PrintDocument.SETRANGE("Document Type",(lrc_SalesHeader."Document Type" + 1));
    //         IF lrc_PrintDocument.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             CASE lrc_PrintDocument."Multiple Entry for" OF

    //               // ----------------------------------------------------------------------------------------------
    //               // Keine Mehrfachgenerierung
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::" ":
    //                 BEGIN
    //                   lrc_SalesCommentPrintDoc.Reset();
    //                   lrc_SalesCommentPrintDoc.INIT();
    //                   lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                   lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                   //MOD WZI MOD.s
    //                   IF lrc_PrintDocument.Consignee = lrc_PrintDocument.Consignee::"Delivery Adress" THEN
    //                     lrc_SalesCommentPrintDoc."Detail Code" := lrc_SalesHeader."Ship-to Code"
    //                   ELSE
    //                     lrc_SalesCommentPrintDoc."Detail Code" := '';
    //                   //MOD WZI MOD.e
    //                   lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                   lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_SalesCommentPrintDoc.Print := FALSE;
    //                   lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                   lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Lager
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::Location:
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                        lrc_SalesCommentPrintDoc.Reset();
    //                        lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                        lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                        lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                        IF lrc_SalesCommentPrintDoc.isempty()THEN BEGIN
    //                          lrc_SalesCommentPrintDoc.Reset();
    //                          lrc_SalesCommentPrintDoc.INIT();
    //                          lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                          lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                          lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                          lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                          lrc_SalesCommentPrintDoc.Print := FALSE;
    //                          lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                          lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                        END;
    //                      END;
    //                      lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Physisches Lager
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Location Group":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrPhysLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                       lrc_SalesCommentPrintDoc.Reset();
    //                       lrc_SalesCommentPrintDoc.INIT();
    //                       lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                       lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                       lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrPhysLocation[lin_ArrZähler];
    //                       lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                       lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                       lrc_SalesCommentPrintDoc.Print := FALSE;
    //                       lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                       lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                     END;

    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Abgangsregion
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Departure Region":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrDepartRegion[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrDepartRegion[lin_ArrZähler]);
    //                           IF lrc_SalesCommentPrintDoc.isempty()THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrDepartRegion[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Zusteller
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                       lrc_SalesCommentPrintDoc.Reset();
    //                       lrc_SalesCommentPrintDoc.INIT();
    //                       lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                       lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                       lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                       lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                       lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                       lrc_SalesCommentPrintDoc.Print := FALSE;
    //                       lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                       lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                     END;
    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //             END;

    //           UNTIL lrc_PrintDocument.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_SalesCommentCard.SETTABLEVIEW(lrc_SalesComment);
    //         lfm_SalesCommentCard.RUNMODAL;

    //         // Erste Zeile in Kopfsatz generieren
    //         SalesSetCommentFirstLine(lrc_SalesComment."Entry No.");
    //     end;

    //     procedure SalesSetCommentFirstLine(vin_EntryNo: Integer)
    //     var
    //         lrc_SalesCommentHeader: Record "5110427";
    //         lrc_SalesCommentLine: Record "5110427";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der ersten Bemerkungszeile in den Kopfsatz Bemerkungen
    //         // ------------------------------------------------------------------------------------------------

    //         // Kommentar aus erster Zeile in Kopfsatz setzen
    //         lrc_SalesCommentHeader.SETRANGE("Entry No.",vin_EntryNo);
    //         lrc_SalesCommentHeader.SETRANGE("Entry Type",lrc_SalesCommentHeader."Entry Type"::Header);
    //         lrc_SalesCommentHeader.SETRANGE("Line No.",0);
    //         lrc_SalesCommentHeader.FINDFIRST;

    //         // Inhalt der Ersten Zeile in den kopfsatz übertragen
    //         lrc_SalesCommentLine.SETRANGE("Entry No.",lrc_SalesCommentHeader."Entry No.");
    //         lrc_SalesCommentLine.SETRANGE("Entry Type",lrc_SalesCommentLine."Entry Type"::Line);
    //         IF lrc_SalesCommentLine.FINDFIRST() THEN BEGIN
    //           lrc_SalesCommentHeader.Comment := lrc_SalesCommentLine.Comment;
    //           lrc_SalesCommentHeader.Modify();
    //         END ELSE BEGIN
    //           // Bemerkungstext löschen falls keine Bemerkungszeilen erfasst sind
    //           lrc_SalesCommentHeader.DELETE(TRUE);
    //         END;
    //     end;

    //     procedure SalesCommentOnAllDoc(vin_EntryNo: Integer;vop_Typ: Option "0","1","2","3","4","5")
    //     var
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_SalesComment: Record "5110427";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum Setzen ShowText in allen Druckbelegen Kopf
    //         // ------------------------------------------------------------------------------------
    //         // vop_Typ = 0 Alle
    //         // vop_Typ = 1 Kreditoren
    //         // vop_Typ = 2 Lagerort
    //         // vop_Typ = 3 Zusteller
    //         // ------------------------------------------------------------------------------------

    //         CASE vop_Typ OF
    //           0:
    //            BEGIN
    //              lrc_SalesCommentPrintDoc.Reset();
    //              lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",vin_EntryNo);
    //              lrc_SalesCommentPrintDoc.MODIFYALL(Print,TRUE);
    //            END;
    //           1,2,3:
    //            BEGIN
    //              lrc_SalesComment.Reset();
    //              lrc_SalesComment.SETRANGE("Entry No.", vin_EntryNo);
    //              lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //              IF lrc_SalesComment.FIND('-') THEN BEGIN
    //                lrc_SalesCommentPrintDoc.Reset();
    //                lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",vin_EntryNo);
    //                IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                  lrc_PrintDocument.Reset();
    //                  lrc_PrintDocument.SETCURRENTKEY( "Document Source","Document Type",Code);
    //                  REPEAT
    //                    lrc_PrintDocument.SETRANGE("Document Source", lrc_PrintDocument."Document Source"::Sales);
    //                    lrc_PrintDocument.SETRANGE("Document Type", lrc_SalesComment."Document Type");
    //                    lrc_PrintDocument.SETRANGE(Code, lrc_SalesCommentPrintDoc."Print Document Code");
    //                    IF lrc_PrintDocument.FINDFIRST() THEN BEGIN
    //                      IF ((vop_Typ = 1) AND
    //                         (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::"Customer/Vendor")) OR
    //                         ((vop_Typ = 2) AND
    //                         (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::Location)) OR
    //                         ((vop_Typ = 3) AND
    //                         (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::"Shipping Agent")) THEN BEGIN
    //                        lrc_SalesCommentPrintDoc.VALIDATE(Print,TRUE);
    //                        lrc_SalesCommentPrintDoc.MODIFY(TRUE);
    //                      END;
    //                    END;
    //                  UNTIL lrc_SalesCommentPrintDoc.NEXT() = 0;
    //                END;
    //              END;
    //            END;
    //         END;
    //     end;

    //     procedure SalesLineComment(vrc_SalesLine: Record "37")
    //     var
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lfm_SalesComment: Form "5110500";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Zeile
    //         // ------------------------------------------------------------------------------------

    //         vrc_SalesLine.TESTFIELD("Document No.");
    //         vrc_SalesLine.TESTFIELD("Line No.");

    //         lrc_SalesComment.FILTERGROUP(2);
    //         lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //         lrc_SalesComment.SETRANGE("Document Source",lrc_SalesComment."Document Source"::Line);
    //         lrc_SalesComment.SETRANGE("Document Type",vrc_SalesLine."Document Type");
    //         lrc_SalesComment.SETRANGE("Document No.",vrc_SalesLine."Document No.");
    //         lrc_SalesComment.SETRANGE("Document Line No.",vrc_SalesLine."Line No.");
    //         lrc_SalesComment.FILTERGROUP(0);
    //         IF lrc_SalesComment.FINDSET(FALSE,FALSE) THEN BEGIN
    //           REPEAT

    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Sales);
    //             lrc_PrintDocument.SETRANGE("Document Type",vrc_SalesLine."Document Type");
    //             IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                 lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                 IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                   lrc_SalesCommentPrintDoc.Reset();
    //                   lrc_SalesCommentPrintDoc.INIT();
    //                   lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                   lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                   lrc_SalesCommentPrintDoc."Detail Code" := '';
    //                   lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_SalesCommentPrintDoc.Print := FALSE;
    //                   lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                   lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                 END;
    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //             END;
    //           UNTIL lrc_SalesComment.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_SalesComment.SetGlobals(vrc_SalesLine."Document Type",vrc_SalesLine."Document No.",vrc_SalesLine."Line No.");
    //         lfm_SalesComment.SETTABLEVIEW(lrc_SalesComment);
    //         lfm_SalesComment.RUNMODAL;
    //     end;

    //     procedure SalesLineGeneralComment(vrc_SalesLine: Record "37")
    //     var
    //         lrc_SalesComment: Record "5110427";
    //         lfm_SalesComment: Form "5110500";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------

    //         lrc_SalesComment.Reset();
    //         lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //         lrc_SalesComment.SETRANGE("Document Source",lrc_SalesComment."Document Source"::Line);
    //         lrc_SalesComment.SETRANGE("Document Type",lrc_SalesComment."Document Type"::Order);
    //         lrc_SalesComment.SETRANGE("Document No.",vrc_SalesLine."Document No.");
    //         lrc_SalesComment.SETRANGE("Document Line No.",vrc_SalesLine."Line No.");
    //         IF lrc_SalesComment.isempty()THEN BEGIN
    //           lrc_SalesComment."Entry No." := 0;
    //           lrc_SalesComment."Entry Type" := lrc_SalesComment."Entry Type"::Header;
    //           lrc_SalesComment."Line No." := 0;
    //           lrc_SalesComment."Document Source" := lrc_SalesComment."Document Source"::Line;
    //           lrc_SalesComment."Document Type" := lrc_SalesComment."Document Type"::Order;
    //           lrc_SalesComment."Document No." := vrc_SalesLine."Document No.";
    //           lrc_SalesComment."Document Line No." := vrc_SalesLine."Line No.";
    //           lrc_SalesComment.Consignee := lrc_SalesComment.Consignee::" ";
    //           lrc_SalesComment.Placement := lrc_SalesComment.Placement::Line;
    //           lrc_SalesComment.INSERT(TRUE);
    //           COMMIT;
    //         END;

    //         // Filter mit Filtergruppe setzen
    //         lrc_SalesComment.Reset();
    //         lrc_SalesComment.FILTERGROUP(2);
    //         lrc_SalesComment.SETRANGE("Entry No.",lrc_SalesComment."Entry No.");
    //         lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Line);
    //         lrc_SalesComment.FILTERGROUP(0);

    //         lfm_SalesComment.SETTABLEVIEW(lrc_SalesComment);
    //         lfm_SalesComment.RUNMODAL();
    //     end;

    //     procedure SalesMoveCommentToPostComment(vop_SourceDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";vco_SourceDocumentNo: Code[20];vin_SourceDocumentLineNo: Integer;vop_TargetDocumentType: Option Shipment,Invoice,"Credit Memo","Return Receipt";vco_TargetDocumentNo: Code[20];vin_TargetDocumentLineNo: Integer)
    //     var
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesComment2: Record "5110427";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lrc_SalesPostArchivComment: Record "5110429";
    //         lin_newEntryNo: Integer;
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zum Kopieren der Bemerkungen in die gebuchten Belege
    //         // -------------------------------------------------------------------------------------------
    //         // vop_SourceDocumentType (Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order)
    //         // vco_SourceDocumentNo
    //         // vin_SourceDocumentLineNo
    //         // vop_TargetDocumentType (Shipment,Invoice,Credit Memo,Return Receipt)
    //         // vco_TargetDocumentNo
    //         // vin_TargetDocumentLineNo
    //         // -------------------------------------------------------------------------------------------

    //         IF vin_SourceDocumentLineNo = 0 THEN BEGIN

    //            // Kopfbemerkungen und zugehörige Zeilen kopieren
    //            lrc_SalesComment.Reset();
    //            lrc_SalesComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                           "Document Source","Document Type","Document No.","Document Line No.");
    //            lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //            lrc_SalesComment.SETRANGE("Document Source", lrc_SalesComment."Document Source"::Header);
    //            lrc_SalesComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesComment.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //            lrc_SalesComment.SETRANGE(Placement, lrc_SalesComment.Placement::Header);
    //            IF lrc_SalesComment.FIND('-') THEN BEGIN
    //               REPEAT

    //                  lrc_SalesCommentPrintDoc.Reset();
    //                  lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.", lrc_SalesComment."Entry No.");
    //                  CASE vop_TargetDocumentType OF
    //                    0: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                            lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //                    1: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                            lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //                    2: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                            lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //                    3: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                            lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //                  END;
    //                  IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN

    //                     IF lrc_SalesCommentPrintDoc.Print THEN BEGIN

    //                        lrc_SalesPostArchivComment.Reset();
    //                        lrc_SalesPostArchivComment.SETRANGE("Entry Type",lrc_SalesPostArchivComment."Entry Type"::Header);
    //                        IF lrc_SalesPostArchivComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_SalesPostArchivComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_SalesPostArchivComment.INIT();
    //                        lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment."Entry Type";
    //                        lrc_SalesPostArchivComment."Line No." := lrc_SalesComment."Line No.";
    //                        lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0: lrc_SalesPostArchivComment."Document Type" :=
    //                                        lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                          1: lrc_SalesPostArchivComment."Document Type" :=
    //                                        lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                          2: lrc_SalesPostArchivComment."Document Type" :=
    //                                        lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3: lrc_SalesPostArchivComment."Document Type" :=
    //                                        lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                        END;
    //                        lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_SalesPostArchivComment.Placement := lrc_SalesComment.Placement;
    //                        lrc_SalesPostArchivComment.Comment := lrc_SalesComment.Comment;
    //                        lrc_SalesPostArchivComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_SalesComment2.Reset();
    //                        lrc_SalesComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_SalesComment2.SETRANGE("Entry Type", lrc_SalesComment2."Entry Type"::Line);
    //                        lrc_SalesComment2.SETRANGE("Entry No.", lrc_SalesComment."Entry No.");
    //                        lrc_SalesComment2.SETRANGE("Document Source", lrc_SalesComment2."Document Source"::Header);
    //                        lrc_SalesComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_SalesComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_SalesComment2.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //                        lrc_SalesComment2.SETRANGE(Placement, lrc_SalesComment2.Placement::Header);
    //                        IF lrc_SalesComment2.FIND('-') THEN BEGIN
    //                           REPEAT
    //                             lrc_SalesPostArchivComment.INIT();
    //                             lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                             lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment2."Entry Type";
    //                             lrc_SalesPostArchivComment."Line No." := lrc_SalesComment2."Line No.";
    //                             lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment2."Document Source";
    //                             CASE vop_TargetDocumentType OF
    //                               0: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                               1: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                               2: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                               3: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                             END;
    //                             lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                             lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                             lrc_SalesPostArchivComment.Placement := lrc_SalesComment2.Placement;
    //                             lrc_SalesPostArchivComment.Comment := lrc_SalesComment2.Comment;
    //                             lrc_SalesPostArchivComment.INSERT(TRUE);
    //                           UNTIL lrc_SalesComment2.NEXT() = 0;
    //                        END;

    //                    END;
    //                 END;
    //               UNTIL lrc_SalesComment.NEXT() = 0;
    //            END;

    //            // Fussbemerkungen und zugehörige Zeilen kopieren
    //            lrc_SalesComment.Reset();
    //            lrc_SalesComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                           "Document Source","Document Type","Document No.","Document Line No.");
    //            lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //            lrc_SalesComment.SETRANGE("Document Source", lrc_SalesComment."Document Source"::Header);
    //            lrc_SalesComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesComment.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //            lrc_SalesComment.SETRANGE(Placement, lrc_SalesComment.Placement::Footer);
    //            IF lrc_SalesComment.FIND('-') THEN BEGIN
    //               REPEAT
    //                  lrc_SalesCommentPrintDoc.Reset();
    //                  lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.", lrc_SalesComment."Entry No.");
    //                  CASE vop_TargetDocumentType OF
    //                    0: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                        lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //                    1: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                        lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //                    2: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                        lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //                    3: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                        lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //                  END;
    //                  IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                    IF lrc_SalesCommentPrintDoc.Print THEN BEGIN

    //                      lrc_SalesPostArchivComment.Reset();
    //                      lrc_SalesPostArchivComment.SETRANGE("Entry Type",lrc_SalesPostArchivComment."Entry Type"::Header);
    //                      IF lrc_SalesPostArchivComment.FIND('+') THEN BEGIN
    //                        lin_newEntryNo := lrc_SalesPostArchivComment."Entry No." + 1
    //                      END ELSE BEGIN
    //                        lin_newEntryNo := 1;
    //                      END;

    //                      lrc_SalesPostArchivComment.INIT();
    //                      lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                      lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment."Entry Type";
    //                      lrc_SalesPostArchivComment."Line No." := lrc_SalesComment."Line No.";
    //                      lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment."Document Source";
    //                      CASE vop_TargetDocumentType OF
    //                          0: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                          1: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                          2: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                      END;
    //                      lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                      lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                      lrc_SalesPostArchivComment.Placement := lrc_SalesComment.Placement;
    //                      lrc_SalesPostArchivComment.Comment := lrc_SalesComment.Comment;
    //                      lrc_SalesPostArchivComment.INSERT(TRUE);

    //                      // dann die Zeilen dazu
    //                      lrc_SalesComment2.Reset();
    //                      lrc_SalesComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                        "Document Source","Document Type","Document No.","Document Line No.");
    //                      lrc_SalesComment2.SETRANGE("Entry Type", lrc_SalesComment2."Entry Type"::Line);
    //                      lrc_SalesComment2.SETRANGE("Entry No.", lrc_SalesComment."Entry No.");
    //                      lrc_SalesComment2.SETRANGE("Document Source", lrc_SalesComment2."Document Source"::Header);
    //                      lrc_SalesComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                      lrc_SalesComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                      lrc_SalesComment2.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //                      lrc_SalesComment2.SETRANGE(Placement, lrc_SalesComment2.Placement::Footer);
    //                      IF lrc_SalesComment2.FIND('-') THEN BEGIN
    //                        REPEAT
    //                          lrc_SalesPostArchivComment.INIT();
    //                          lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                          lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment2."Entry Type";
    //                          lrc_SalesPostArchivComment."Line No." := lrc_SalesComment2."Line No.";
    //                          lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment2."Document Source";
    //                          CASE vop_TargetDocumentType OF
    //                               0: lrc_SalesPostArchivComment."Document Type" :=
    //                                             lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                               1: lrc_SalesPostArchivComment."Document Type" :=
    //                                             lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                               2: lrc_SalesPostArchivComment."Document Type" :=
    //                                             lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                               3: lrc_SalesPostArchivComment."Document Type" :=
    //                                             lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                          END;
    //                          lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                          lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                          lrc_SalesPostArchivComment.Placement := lrc_SalesComment2.Placement;
    //                          lrc_SalesPostArchivComment.Comment := lrc_SalesComment2.Comment;
    //                          lrc_SalesPostArchivComment.INSERT(TRUE);
    //                        UNTIL lrc_SalesComment2.NEXT() = 0;
    //                      END;
    //                    END;
    //                  END;
    //               UNTIL lrc_SalesComment.NEXT() = 0;
    //            END;

    //            // Zeilenbemerkungen und zugehörige Zeilen kopieren
    //            lrc_SalesComment.Reset();
    //            lrc_SalesComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                           "Document Source","Document Type","Document No.","Document Line No.");
    //            lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //            lrc_SalesComment.SETRANGE("Document Source", lrc_SalesComment."Document Source"::Header);
    //            lrc_SalesComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesComment.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //            lrc_SalesComment.SETRANGE(Placement, lrc_SalesComment.Placement::Line);
    //            IF lrc_SalesComment.FIND('-') THEN BEGIN
    //              REPEAT

    //                lrc_SalesCommentPrintDoc.Reset();
    //                lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.", lrc_SalesComment."Entry No.");
    //                CASE vop_TargetDocumentType OF
    //                    0: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                          lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //                    1: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                          lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //                    2: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                          lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //                    3: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                          lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //                END;
    //                IF lrc_SalesCommentPrintDoc.FINDFIRST() THEN BEGIN

    //                  IF lrc_SalesCommentPrintDoc.Print THEN BEGIN

    //                    lrc_SalesPostArchivComment.Reset();
    //                    lrc_SalesPostArchivComment.SETRANGE("Entry Type",lrc_SalesPostArchivComment."Entry Type"::Header);
    //                    IF lrc_SalesPostArchivComment.FIND('+') THEN BEGIN
    //                      lin_newEntryNo := lrc_SalesPostArchivComment."Entry No." + 1
    //                    END ELSE BEGIN
    //                      lin_newEntryNo := 1;
    //                    END;

    //                    lrc_SalesPostArchivComment.INIT();
    //                    lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                    lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment."Entry Type";
    //                    lrc_SalesPostArchivComment."Line No." := lrc_SalesComment."Line No.";
    //                    lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment."Document Source";
    //                    CASE vop_TargetDocumentType OF
    //                          0: lrc_SalesPostArchivComment."Document Type" :=
    //                                           lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                          1: lrc_SalesPostArchivComment."Document Type" :=
    //                                           lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                          2: lrc_SalesPostArchivComment."Document Type" :=
    //                                           lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3: lrc_SalesPostArchivComment."Document Type" :=
    //                                           lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                    END;
    //                    lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                    lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                    lrc_SalesPostArchivComment.Placement := lrc_SalesComment.Placement;
    //                    lrc_SalesPostArchivComment.Comment := lrc_SalesComment.Comment;
    //                    lrc_SalesPostArchivComment.INSERT(TRUE);

    //                    // dann die Zeilen dazu
    //                    lrc_SalesComment2.Reset();
    //                    lrc_SalesComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                      "Document Source","Document Type","Document No.","Document Line No.");
    //                    lrc_SalesComment2.SETRANGE("Entry Type", lrc_SalesComment2."Entry Type"::Line);
    //                    lrc_SalesComment2.SETRANGE("Entry No.", lrc_SalesComment."Entry No.");
    //                    lrc_SalesComment2.SETRANGE("Document Source", lrc_SalesComment2."Document Source"::Header);
    //                    lrc_SalesComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                    lrc_SalesComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                    lrc_SalesComment2.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //                    lrc_SalesComment2.SETRANGE(Placement, lrc_SalesComment2.Placement::Line);
    //                    IF lrc_SalesComment2.FIND('-') THEN BEGIN
    //                      REPEAT
    //                        lrc_SalesPostArchivComment.INIT();
    //                        lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment2."Entry Type";
    //                        lrc_SalesPostArchivComment."Line No." := lrc_SalesComment2."Line No.";
    //                        lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment2."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0: lrc_SalesPostArchivComment."Document Type" :=
    //                                         lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                          1: lrc_SalesPostArchivComment."Document Type" :=
    //                                         lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                          2: lrc_SalesPostArchivComment."Document Type" :=
    //                                         lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3: lrc_SalesPostArchivComment."Document Type" :=
    //                                         lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                        END;
    //                        lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_SalesPostArchivComment.Placement := lrc_SalesComment2.Placement;
    //                        lrc_SalesPostArchivComment.Comment := lrc_SalesComment2.Comment;
    //                        lrc_SalesPostArchivComment.INSERT(TRUE);
    //                      UNTIL lrc_SalesComment2.NEXT() = 0;
    //                    END;
    //                  END;
    //                END;
    //              UNTIL lrc_SalesComment.NEXT() = 0;
    //            END;

    //         END ELSE BEGIN

    //            // Nur eine bestimmte Zeilenbemerkung und zugehörige Zeilen kopieren
    //            lrc_SalesComment.Reset();
    //            lrc_SalesComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                           "Document Source","Document Type","Document No.","Document Line No.");
    //            lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //            lrc_SalesComment.SETRANGE("Document Source", lrc_SalesComment."Document Source"::Line);
    //            lrc_SalesComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //            lrc_SalesComment.SETRANGE(Placement, lrc_SalesComment.Placement::Line);
    //            IF lrc_SalesComment.FIND('-') THEN BEGIN
    //              REPEAT
    //                lrc_SalesCommentPrintDoc.Reset();
    //                lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.", lrc_SalesComment."Entry No.");
    //                CASE vop_TargetDocumentType OF
    //                    0: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                       lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //                    1: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                       lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //                    2: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                       lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //                    3: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                       lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //                END;
    //                IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                  IF lrc_SalesCommentPrintDoc.Print THEN BEGIN

    //                    lrc_SalesPostArchivComment.Reset();
    //                    lrc_SalesPostArchivComment.SETRANGE("Entry Type",lrc_SalesPostArchivComment."Entry Type"::Header);
    //                    IF lrc_SalesPostArchivComment.FIND('+') THEN BEGIN
    //                      lin_newEntryNo := lrc_SalesPostArchivComment."Entry No." + 1
    //                    END ELSE BEGIN
    //                      lin_newEntryNo := 1;
    //                    END;

    //                    lrc_SalesPostArchivComment.INIT();
    //                    lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                    lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment."Entry Type";
    //                    lrc_SalesPostArchivComment."Line No." := lrc_SalesComment."Line No.";
    //                    lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment."Document Source";
    //                    CASE vop_TargetDocumentType OF
    //                          0: lrc_SalesPostArchivComment."Document Type" :=
    //                                         lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                          1: lrc_SalesPostArchivComment."Document Type" :=
    //                                         lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                          2: lrc_SalesPostArchivComment."Document Type" :=
    //                                         lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3: lrc_SalesPostArchivComment."Document Type" :=
    //                                         lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                    END;
    //                    lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                    lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                    lrc_SalesPostArchivComment.Placement := lrc_SalesComment.Placement;
    //                    lrc_SalesPostArchivComment.Comment := lrc_SalesComment.Comment;
    //                    lrc_SalesPostArchivComment.INSERT(TRUE);

    //                    // dann die Zeilen dazu
    //                    lrc_SalesComment2.Reset();
    //                    lrc_SalesComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                          "Document Source","Document Type","Document No.","Document Line No.");
    //                    lrc_SalesComment2.SETRANGE("Entry Type", lrc_SalesComment2."Entry Type"::Line);
    //                    lrc_SalesComment2.SETRANGE("Entry No.", lrc_SalesComment."Entry No.");
    //                    lrc_SalesComment2.SETRANGE("Document Source", lrc_SalesComment2."Document Source"::Line);
    //                    lrc_SalesComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                    lrc_SalesComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                    lrc_SalesComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //                    lrc_SalesComment2.SETRANGE(Placement, lrc_SalesComment2.Placement::Line);
    //                    IF lrc_SalesComment2.FINDSET(FALSE,FALSE) THEN BEGIN
    //                      REPEAT
    //                        lrc_SalesPostArchivComment.INIT();
    //                        lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment2."Entry Type";
    //                        lrc_SalesPostArchivComment."Line No." := lrc_SalesComment2."Line No.";
    //                        lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment2."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                               0: lrc_SalesPostArchivComment."Document Type" :=
    //                                       lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                               1: lrc_SalesPostArchivComment."Document Type" :=
    //                                       lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                               2: lrc_SalesPostArchivComment."Document Type" :=
    //                                       lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                               3: lrc_SalesPostArchivComment."Document Type" :=
    //                                       lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                        END;
    //                        lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_SalesPostArchivComment.Placement := lrc_SalesComment2.Placement;
    //                        lrc_SalesPostArchivComment.Comment := lrc_SalesComment2.Comment;
    //                        lrc_SalesPostArchivComment.INSERT(TRUE);
    //                      UNTIL lrc_SalesComment2.NEXT() = 0;
    //                    END;

    //                  END;
    //                END;
    //              UNTIL lrc_SalesComment.NEXT() = 0;
    //            END;

    //         END;
    //     end;

    //     procedure SalesCopyCommentToPostComment(vop_SourceDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";vco_SourceDocumentNo: Code[20];vin_SourceDocumentLineNo: Integer;vop_TargetDocumentType: Option Shipment,Invoice,"Credit Memo","Return Receipt";vco_TargetDocumentNo: Code[20];vin_TargetDocumentLineNo: Integer)
    //     var
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesComment2: Record "5110427";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lrc_SalesPostArchivComment: Record "5110429";
    //         lin_newEntryNo: Integer;
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         // Funktion zum Kopieren der Bemerkungen in die gebuchten Belege
    //         // Entspricht der Funktion SalesMoveCommentToPostComment
    //         // -------------------------------------------------------------------------------------------
    //         // vop_SourceDocumentType (Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order)
    //         // vco_SourceDocumentNo
    //         // vin_SourceDocumentLineNo
    //         // vop_TargetDocumentType (Shipment,Invoice,Credit Memo,Return Receipt)
    //         // vco_TargetDocumentNo
    //         // vin_TargetDocumentLineNo
    //         // -------------------------------------------------------------------------------------------

    //         // BAUSTELLE

    //         // Kopfbemerkungen und zugehörige Zeilen kopieren
    //         lrc_SalesComment.Reset();
    //         lrc_SalesComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                        "Document Source","Document Type","Document No.","Document Line No.");
    //         lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //         lrc_SalesComment.SETFILTER("Document Source", '%1|%2',lrc_SalesComment."Document Source"::Header,
    //                                                               lrc_SalesComment."Document Source"::Line);
    //         lrc_SalesComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //         lrc_SalesComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //         ////lrc_SalesComment.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //         ////lrc_SalesComment.SETRANGE(Placement, lrc_SalesComment.Placement::Header);
    //         IF lrc_SalesComment.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_SalesCommentPrintDoc.Reset();
    //             lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.", lrc_SalesComment."Entry No.");
    //             CASE vop_TargetDocumentType OF
    //               0: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                    lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //               1: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                    lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //               2: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                    lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //               3: lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                    lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //             END;
    //             IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN

    //               IF lrc_SalesCommentPrintDoc.Print THEN BEGIN

    //                 lrc_SalesPostArchivComment.Reset();
    //                 lrc_SalesPostArchivComment.SETRANGE("Entry Type",lrc_SalesPostArchivComment."Entry Type"::Header);
    //                 IF lrc_SalesPostArchivComment.FIND('+') THEN
    //                   lin_newEntryNo := lrc_SalesPostArchivComment."Entry No." + 1
    //                 ELSE
    //                   lin_newEntryNo := 1;

    //                 lrc_SalesPostArchivComment.INIT();
    //                 lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                 lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment."Entry Type";
    //                 lrc_SalesPostArchivComment."Line No." := lrc_SalesComment."Line No.";
    //                 lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment."Document Source";
    //                 CASE vop_TargetDocumentType OF
    //                   0: lrc_SalesPostArchivComment."Document Type" :=
    //                                    lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                   1: lrc_SalesPostArchivComment."Document Type" :=
    //                                    lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                   2: lrc_SalesPostArchivComment."Document Type" :=
    //                                    lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                   3: lrc_SalesPostArchivComment."Document Type" :=
    //                                    lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                 END;
    //                 lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                 lrc_SalesPostArchivComment."Document Line No." := lrc_SalesComment."Document Line No.";
    //                 lrc_SalesPostArchivComment.Placement := lrc_SalesComment.Placement;
    //                 lrc_SalesPostArchivComment.Comment := lrc_SalesComment.Comment;
    //                 lrc_SalesPostArchivComment.INSERT(TRUE);

    //                 // Zugehörige Zeilen kopieren
    //                 lrc_SalesComment2.Reset();
    //                 lrc_SalesComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                          "Document Source","Document Type","Document No.","Document Line No.");
    //                 lrc_SalesComment2.SETRANGE("Entry Type", lrc_SalesComment2."Entry Type"::Line);
    //                 lrc_SalesComment2.SETRANGE("Entry No.", lrc_SalesComment."Entry No.");
    //         ////        lrc_SalesComment2.SETRANGE("Document Source", lrc_SalesComment2."Document Source"::Header);
    //         ////        lrc_SalesComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //         ////        lrc_SalesComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //         ////        lrc_SalesComment2.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //         ////        lrc_SalesComment2.SETRANGE(Placement, lrc_SalesComment2.Placement::Header);
    //                 IF lrc_SalesComment2.FIND('-') THEN BEGIN
    //                   REPEAT
    //                     lrc_SalesPostArchivComment.INIT();
    //                     lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                     lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment2."Entry Type";
    //                     lrc_SalesPostArchivComment."Line No." := lrc_SalesComment2."Line No.";
    //                     lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment2."Document Source";
    //                     CASE vop_TargetDocumentType OF
    //                       0: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                       1: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                       2: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                       3: lrc_SalesPostArchivComment."Document Type" :=
    //                                          lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                     END;
    //                     lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                     lrc_SalesPostArchivComment."Document Line No." := lrc_SalesComment2."Document Line No.";
    //                     lrc_SalesPostArchivComment.Placement := lrc_SalesComment2.Placement;
    //                     lrc_SalesPostArchivComment.Comment := lrc_SalesComment2.Comment;
    //                     lrc_SalesPostArchivComment.INSERT(TRUE);
    //                   UNTIL lrc_SalesComment2.NEXT() = 0;
    //                 END;

    //               END;
    //             END;
    //           UNTIL lrc_SalesComment.NEXT() = 0;
    //         END;
    //     end;

    //     procedure SalesTransferArchPostComment(lop_InsertType: Option PostedDocument,Archiv;lrc_SalesHeader: Record "36";lco_InvHeaderNo: Code[20];lco_CreditMemoHeaderNo: Code[20];lco_ReturnRcptHeaderNo: Code[20];lco_SalesShptHeaderNo: Code[20];lin_VersionNo: Integer)
    //     var
    //         lrc_SalesPostArchivDisc: Record "5110388";
    //         lco_DocNo: Code[20];
    //         lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Receipt";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------

    //         // BET 002 FV400018.s
    //         CASE lop_InsertType OF

    //           // Bei Buchungen
    //           lop_InsertType::PostedDocument:
    //             WITH lrc_SalesHeader DO BEGIN

    //               IF (Receive = Ship = Invoice = FALSE) THEN
    //                 EXIT;

    //               // Lieferung
    //               IF Receive THEN BEGIN
    //                 lop_DiscDocType := lop_DiscDocType::"Posted Shipment";
    //                 lco_DocNo := lco_ReturnRcptHeaderNo;
    //               END;

    //               // Rücklieferung
    //               IF Ship THEN BEGIN
    //                 lop_DiscDocType := lop_DiscDocType::"Posted Return Receipt";
    //                 lco_DocNo := lco_SalesShptHeaderNo;
    //               END;

    //               // Rechnung und Gutschrift
    //               IF Invoice THEN BEGIN
    //                 IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
    //                   lop_DiscDocType := lop_DiscDocType::"Posted Invoice";
    //                   lco_DocNo := lco_InvHeaderNo;
    //                 END ELSE BEGIN// Credit Memo
    //                   lop_DiscDocType := lop_DiscDocType::"Posted Credit Memo";
    //                   lco_DocNo := lco_CreditMemoHeaderNo;
    //                 END;
    //               END;
    //             END;

    //           // Bei Archivierungen
    //           lop_InsertType::Archiv:
    //             WITH lrc_SalesHeader DO BEGIN
    //               CASE "Document Type" OF
    //                 "Document Type"::Quote           : lop_DiscDocType := lop_DiscDocType::"Archive Quote";
    //                 "Document Type"::"Blanket Order" : lop_DiscDocType := lop_DiscDocType::"Archive Blanket Order";
    //                 "Document Type"::Order           : lop_DiscDocType := lop_DiscDocType::"Archive Order";
    //               END;
    //               lco_DocNo := "No.";
    //               gin_VersionNo := lin_VersionNo;
    //             END;
    //         END;

    //         SalesInsertCommentLines(lrc_SalesHeader,lop_DiscDocType,lco_DocNo);
    //         // BET 002 FV400018.s
    //     end;

    //     procedure SalesInsertCommentLines(lrc_SalesHeader: Record "36";lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment";lco_PostedDocNo: Code[20])
    //     var
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesPostArchComm: Record "5110429";
    //         lin_EntryNo: Integer;
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------

    //         // BET 002 FV400018.s
    //         lrc_SalesPostArchComm.Reset();
    //         IF lrc_SalesPostArchComm.FIND('+') THEN
    //           lin_EntryNo := lrc_SalesPostArchComm."Entry No.";

    //         lrc_SalesComment.Reset();
    //         lrc_SalesComment.SETCURRENTKEY("Document Source","Document Type","Document No.","Document Line No.");
    //         lrc_SalesComment.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesComment.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         IF lrc_SalesComment.FIND('-') THEN
    //           REPEAT
    //             WITH lrc_SalesPostArchComm DO BEGIN
    //               IF lrc_SalesComment."Entry Type" = lrc_SalesComment."Entry Type"::Header THEN
    //                  lin_EntryNo := lin_EntryNo + 1;
    //               INIT();
    //               TRANSFERFIELDS(lrc_SalesComment);
    //               "Entry No." := lin_EntryNo;
    //               "Entry Type" := lrc_SalesComment."Entry Type";
    //               "Line No." := lrc_SalesComment."Line No.";
    //               "Version No." := gin_VersionNo;
    //               IF NOT INSERT THEN
    //                 Modify();
    //             END;
    //           UNTIL lrc_SalesComment.NEXT() = 0;
    //         // BET 002 FV400018.e
    //     end;

    //     procedure SalesDocCopy(lin_FromDocType: Integer;lco_FromDocNo: Code[20];lrc_ToSalesHeader: Record "36";lin_VersionNo: Integer)
    //     var
    //         lrc_SalesPostArchComm: Record "5110429";
    //         lrc_SalesComment: Record "5110427";
    //         lrc_NewSalesComment: Record "5110427";
    //         Text001: Label 'Comments allready exists. If you continue, comments will de deleted.\Do you wish to continue?';
    //         Text002: Label 'Process stopped.';
    //         lin_EntryNo: Integer;
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------

    //         // BET 003 FV400018.s
    //         gop_SalesDocType := lin_FromDocType;
    //         gin_VersionNo := lin_VersionNo;

    //         IF gop_SalesDocType IN [gop_SalesDocType::Quote,gop_SalesDocType::"Blanket Order",gop_SalesDocType::Order,
    //                                 gop_SalesDocType::Invoice,gop_SalesDocType::"Return Order",gop_SalesDocType::"Credit Memo"]
    //         THEN BEGIN  // Bemerkungszeilen aus Belegen
    //           WITH lrc_SalesComment DO BEGIN

    //             CASE gop_SalesDocType OF
    //               gop_SalesDocType::Quote:            SETRANGE("Document Type","Document Type"::Quote);
    //               gop_SalesDocType::"Blanket Order":  SETRANGE("Document Type","Document Type"::"Blanket Order");
    //               gop_SalesDocType::Order:            SETRANGE("Document Type","Document Type"::Order);
    //               gop_SalesDocType::Invoice:          SETRANGE("Document Type","Document Type"::Invoice);
    //               gop_SalesDocType::"Return Order":   SETRANGE("Document Type","Document Type"::"Return Order");
    //               gop_SalesDocType::"Credit Memo":    SETRANGE("Document Type","Document Type"::"Credit Memo");
    //             END;
    //             SETRANGE("Document No.",lco_FromDocNo);
    //             IF FIND('-') THEN BEGIN
    //               //Lösche vorhandene Bemerkungen
    //               lrc_NewSalesComment.SETRANGE("Document Type",lrc_ToSalesHeader."Document Type");
    //               lrc_NewSalesComment.SETRANGE("Document No.",lrc_ToSalesHeader."No.");
    //               IF lrc_NewSalesComment.FIND('-') THEN
    //                 IF CONFIRM(Text001,TRUE) THEN
    //                   lrc_NewSalesComment.DELETEALL(TRUE)
    //                 ELSE
    //                   ERROR(Text002);

    //               lrc_NewSalesComment.Reset();
    //               IF lrc_NewSalesComment.FIND('+') THEN
    //                 lin_EntryNo := lrc_NewSalesComment."Entry No.";

    //               REPEAT
    //                 lrc_NewSalesComment.INIT();
    //                 lrc_NewSalesComment.TRANSFERFIELDS(lrc_SalesComment);
    //                 lrc_NewSalesComment."Document Type" := lrc_ToSalesHeader."Document Type";
    //                 lrc_NewSalesComment."Document No." := lrc_ToSalesHeader."No.";
    //                 IF lrc_SalesComment."Entry Type" = lrc_SalesComment."Entry Type"::Header THEN
    //                   lin_EntryNo := lin_EntryNo + 1;
    //                 lrc_NewSalesComment."Entry No." := lin_EntryNo;
    //                 IF lrc_NewSalesComment.INSERT THEN;
    //               UNTIL NEXT= 0;
    //             END;
    //           END;
    //         END ELSE BEGIN // Bemerkungszeilen aus gebuchten Belegen und Archiv Bemerkungen
    //           WITH lrc_SalesPostArchComm DO BEGIN
    //             CASE gop_SalesDocType OF
    //               gop_SalesDocType::"Posted Invoice":         SETRANGE("Document Type","Document Type"::"Posted Invoice");
    //               gop_SalesDocType::"Posted Credit Memo":     SETRANGE("Document Type","Document Type"::"Posted Credit Memo");
    //               gop_SalesDocType::"Posted Shipment":        SETRANGE("Document Type","Document Type"::"Posted Shipment");
    //               gop_SalesDocType::"Posted Return Receipt":  SETRANGE("Document Type","Document Type"::"Posted Return Receipt");

    //               gop_SalesDocType::"Arch. Quote":         SETRANGE("Document Type","Document Type"::"Archive Quote");
    //               gop_SalesDocType::"Arch. Order":         SETRANGE("Document Type","Document Type"::"Archive Order");
    //               gop_SalesDocType::"Arch. Blanket Order": SETRANGE("Document Type","Document Type"::"Archive Blanket Order");
    //             END;
    //             SETRANGE("Document No.",lco_FromDocNo);
    //             SETRANGE("Version No.",gin_VersionNo);
    //             IF FIND('-') THEN BEGIN

    //               //Lösche vorhandene Rabatte
    //               lrc_NewSalesComment.SETRANGE("Document Type",lrc_ToSalesHeader."Document Type");
    //               lrc_NewSalesComment.SETRANGE("Document No.",lrc_ToSalesHeader."No.");
    //               IF lrc_NewSalesComment.FIND('-') THEN
    //                 IF CONFIRM(Text001,TRUE) THEN
    //                   lrc_NewSalesComment.DELETEALL
    //                 ELSE
    //                   ERROR(Text002);

    //               lrc_NewSalesComment.Reset();
    //               IF lrc_NewSalesComment.FIND('+') THEN
    //                 lin_EntryNo := lrc_NewSalesComment."Entry No.";

    //               REPEAT
    //                 lrc_NewSalesComment.INIT();
    //                 lrc_NewSalesComment.TRANSFERFIELDS(lrc_SalesPostArchComm);
    //                 lrc_SalesComment."Document Type" := lrc_ToSalesHeader."Document Type";
    //                 lrc_NewSalesComment."Document No." := lrc_ToSalesHeader."No.";
    //                 IF lrc_SalesPostArchComm."Entry Type" = lrc_SalesPostArchComm."Entry Type"::Header THEN
    //                   lin_EntryNo := lin_EntryNo + 1;
    //                 lrc_NewSalesComment."Entry No." := lin_EntryNo;
    //                 IF lrc_NewSalesComment.INSERT THEN;
    //               UNTIL NEXT= 0;
    //             END;
    //           END;
    //         END;
    //         // BET 003 FV400018.s
    //     end;

    //     procedure SalesCommentTransferToDoc(prc_SalesHeader: Record "36")
    //     var
    //         lrc_CustVendComment: Record "5110425";
    //         lrc_CustVendCommentPrintDoc: Record "5110426";
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lrc_Customer: Record "Customer";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Übertragen der Bemerkungen in die Verkaufsbelege
    //         // ------------------------------------------------------------------------------------

    //         // BET 004 FV400018.s
    //         // Bereits vorhandene Daten löschen
    //         lrc_SalesComment.Reset();
    //         lrc_SalesComment.SETRANGE("Document Source",lrc_SalesComment."Document Source"::Header);
    //         lrc_SalesComment.SETRANGE("Document Type",prc_SalesHeader."Document Type");
    //         lrc_SalesComment.SETRANGE("Document No.",prc_SalesHeader."No.");
    //         IF lrc_SalesComment.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Drucktabelle löschen
    //             IF lrc_SalesComment."Entry Type" = lrc_SalesComment."Entry Type"::Header THEN BEGIN
    //               lrc_SalesCommentPrintDoc.Reset();
    //               lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //               IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                 lrc_SalesCommentPrintDoc.DELETEALL();
    //               END;
    //             END;

    //             // Haupttabelle löschen
    //             lrc_SalesComment.DELETE(TRUE);

    //           UNTIL lrc_SalesComment.NEXT() = 0;
    //         END;


    //         // BET 005 KHH50223.s
    //         // Daten für Unternehmenskette holen
    //         lrc_Customer.GET(prc_SalesHeader."Sell-to Customer No.");
    //         IF lrc_Customer."Chain Name" <> '' THEN BEGIN
    //           lrc_CustVendComment.Reset();
    //           lrc_CustVendComment.SETRANGE("Document Source",lrc_CustVendComment."Document Source"::Header);
    //           lrc_CustVendComment.SETRANGE(Source,lrc_CustVendComment.Source::"Customer Chain");
    //           lrc_CustVendComment.SETRANGE("Source No.",lrc_Customer."Chain Name");
    //           IF lrc_CustVendComment.FIND('-') THEN BEGIN
    //             TransferCommentToSalesComment(prc_SalesHeader, lrc_CustVendComment);
    //           END;
    //         END;
    //         // BET 005 KHH50223.e

    //         /*
    //         // Daten für Sell-to Customer No. holen
    //         lrc_CustVendComment.Reset();
    //         lrc_CustVendComment.SETRANGE("Document Source",lrc_CustVendComment."Document Source"::Header);
    //         lrc_CustVendComment.SETRANGE(Source,lrc_CustVendComment.Source::Customer);
    //         lrc_CustVendComment.SETRANGE("Source No.",prc_SalesHeader."Sell-to Customer No.");
    //         IF lrc_CustVendComment.FIND('-') THEN BEGIN
    //           // BET 005 KHH50223.s
    //           TransferCommentToSalesComment(prc_SalesHeader, lrc_CustVendComment);
    //           // BET 005 KHH50223.e
    //         END;
    //         // BET 004 FV400018.e
    //         */

    //         // Daten für Sell-to Customer No. holen
    //         IF prc_SalesHeader."Bill-to Customer No." = prc_SalesHeader."Sell-to Customer No." THEN BEGIN
    //           lrc_CustVendComment.Reset();
    //           lrc_CustVendComment.SETRANGE("Document Source",lrc_CustVendComment."Document Source"::Header);
    //           lrc_CustVendComment.SETRANGE(Source,lrc_CustVendComment.Source::Customer);
    //           lrc_CustVendComment.SETRANGE("Source No.",prc_SalesHeader."Sell-to Customer No.");
    //           IF lrc_CustVendComment.FIND('-') THEN BEGIN
    //             // BET 005 KHH50223.s
    //             TransferCommentToSalesComment(prc_SalesHeader, lrc_CustVendComment);
    //             // BET 005 KHH50223.e
    //           END;
    //           // BET 004 FV400018.e
    //         END ELSE BEGIN
    //         //KHH 001 KHH50235.s
    //           //Daten für Rechnungsempfänger holen
    //           lrc_CustVendComment.Reset();
    //           lrc_CustVendComment.SETRANGE("Document Source",lrc_CustVendComment."Document Source"::Header);
    //           lrc_CustVendComment.SETRANGE(Source,lrc_CustVendComment.Source::Customer);
    //           lrc_CustVendComment.SETRANGE("Source No.",prc_SalesHeader."Bill-to Customer No.");
    //           IF lrc_CustVendComment.FIND('-') THEN BEGIN
    //             // BET 005 KHH50223.s
    //             TransferCommentToSalesComment(prc_SalesHeader, lrc_CustVendComment);
    //             // BET 005 KHH50223.e
    //           END;
    //           // BET 004 FV400018.e
    //         END;
    //         //KHH 001 KHH50235.e

    //     end;

    //     procedure SalesCopyPostCommentToComment(vop_SourceDocumentTypePar: Option Shipment,Invoice,"Credit Memo","Return Receipt";vco_SourceDocumentNo: Code[20];vin_SourceDocumentLineNo: Integer;vop_TargetDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";vco_TargetDocumentNo: Code[20];vin_TargetDocumentLineNo: Integer)
    //     var
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesPostArchivComment: Record "5110429";
    //         vop_SourceDocumentType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Receipt";
    //         lrc_SalesPostArchivComment2: Record "5110429";
    //         lin_newEntryNo: Integer;
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------

    //         // IFW 001 IFW40076.s
    //         CASE vop_SourceDocumentTypePar OF
    //           vop_SourceDocumentTypePar::Shipment:
    //             vop_SourceDocumentType := vop_SourceDocumentType::"Posted Shipment";
    //           vop_SourceDocumentTypePar::Invoice:
    //             vop_SourceDocumentType := vop_SourceDocumentType::"Posted Invoice";
    //           vop_SourceDocumentTypePar::"Credit Memo":
    //             vop_SourceDocumentType := vop_SourceDocumentType::"Posted Credit Memo";
    //           vop_SourceDocumentTypePar::"Return Receipt":
    //             vop_SourceDocumentType := vop_SourceDocumentType::"Posted Return Receipt";
    //         END;

    //         IF vin_SourceDocumentLineNo = 0 THEN BEGIN

    //            // Kopfbemerkungen und zugehörige Zeilen kopieren
    //            lrc_SalesPostArchivComment.Reset();
    //            lrc_SalesPostArchivComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                           "Document Source","Document Type","Document No.","Document Line No.");
    //            lrc_SalesPostArchivComment.SETRANGE("Entry Type", lrc_SalesPostArchivComment."Entry Type"::Header);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Source", lrc_SalesPostArchivComment."Document Source"::Header);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesPostArchivComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //            lrc_SalesPostArchivComment.SETRANGE(Placement, lrc_SalesPostArchivComment.Placement::Header);
    //            IF lrc_SalesPostArchivComment.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_SalesComment.Reset();
    //                 lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //                 IF lrc_SalesComment.FIND('+') THEN BEGIN
    //                   lin_newEntryNo := lrc_SalesComment."Entry No." + 1
    //                 END ELSE BEGIN
    //                   lin_newEntryNo := 1;
    //                 END;

    //                 lrc_SalesComment.INIT();
    //                 lrc_SalesComment."Entry No." := lin_newEntryNo;
    //                 lrc_SalesComment."Entry Type" := lrc_SalesPostArchivComment."Entry Type";
    //                 lrc_SalesComment."Line No." := lrc_SalesPostArchivComment."Line No.";
    //                 lrc_SalesComment."Document Source" := lrc_SalesPostArchivComment."Document Source";
    //                 CASE vop_TargetDocumentType OF
    //                   0: lrc_SalesComment."Document Type" :=
    //                                 lrc_SalesComment."Document Type"::Quote;
    //                   1: lrc_SalesComment."Document Type" :=
    //                                 lrc_SalesComment."Document Type"::Order;
    //                   2: lrc_SalesComment."Document Type" :=
    //                                 lrc_SalesComment."Document Type"::Invoice;
    //                   3: lrc_SalesComment."Document Type" :=
    //                                 lrc_SalesComment."Document Type"::"Credit Memo";
    //                   4: lrc_SalesComment."Document Type" :=
    //                                 lrc_SalesComment."Document Type"::"Blanket Order";
    //                   5: lrc_SalesComment."Document Type" :=
    //                                 lrc_SalesComment."Document Type"::"Return Order";
    //                 END;
    //                 lrc_SalesComment."Document No." := vco_TargetDocumentNo;
    //                 lrc_SalesComment."Document Line No." := vin_TargetDocumentLineNo;
    //                 lrc_SalesComment.Placement := lrc_SalesPostArchivComment.Placement;
    //                 lrc_SalesComment.Comment := lrc_SalesPostArchivComment.Comment;
    //                 lrc_SalesComment.INSERT(TRUE);

    //                 // dann die Zeilen dazu
    //                 lrc_SalesPostArchivComment2.Reset();
    //                 lrc_SalesPostArchivComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                   "Document Source","Document Type","Document No.","Document Line No.");
    //                 lrc_SalesPostArchivComment2.SETRANGE("Entry Type", lrc_SalesPostArchivComment2."Entry Type"::Line);
    //                 lrc_SalesPostArchivComment2.SETRANGE("Entry No.", lrc_SalesPostArchivComment."Entry No.");
    //                 lrc_SalesPostArchivComment2.SETRANGE("Document Source", lrc_SalesPostArchivComment2."Document Source"::Header);
    //                 lrc_SalesPostArchivComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                 lrc_SalesPostArchivComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                 lrc_SalesPostArchivComment2.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //                 lrc_SalesPostArchivComment2.SETRANGE(Placement, lrc_SalesPostArchivComment2.Placement::Header);
    //                 IF lrc_SalesPostArchivComment2.FIND('-') THEN BEGIN
    //                   REPEAT
    //                     lrc_SalesComment.INIT();
    //                     lrc_SalesComment."Entry No." := lin_newEntryNo;
    //                     lrc_SalesComment."Entry Type" := lrc_SalesPostArchivComment2."Entry Type";
    //                     lrc_SalesComment."Line No." := lrc_SalesPostArchivComment2."Line No.";
    //                     lrc_SalesComment."Document Source" := lrc_SalesPostArchivComment2."Document Source";
    //                     CASE vop_TargetDocumentType OF
    //                       0: lrc_SalesComment."Document Type" :=
    //                                     lrc_SalesComment."Document Type"::Quote;
    //                       1: lrc_SalesComment."Document Type" :=
    //                                     lrc_SalesComment."Document Type"::Order;
    //                       2: lrc_SalesComment."Document Type" :=
    //                                     lrc_SalesComment."Document Type"::Invoice;
    //                       3: lrc_SalesComment."Document Type" :=
    //                                     lrc_SalesComment."Document Type"::"Credit Memo";
    //                       4: lrc_SalesComment."Document Type" :=
    //                                     lrc_SalesComment."Document Type"::"Blanket Order";
    //                       5: lrc_SalesComment."Document Type" :=
    //                                     lrc_SalesComment."Document Type"::"Return Order";
    //                     END;
    //                     lrc_SalesComment."Document No." := vco_TargetDocumentNo;
    //                     lrc_SalesComment."Document Line No." := vin_TargetDocumentLineNo;
    //                     lrc_SalesComment.Placement := lrc_SalesPostArchivComment2.Placement;
    //                     lrc_SalesComment.Comment := lrc_SalesPostArchivComment2.Comment;
    //                     lrc_SalesComment.INSERT(TRUE);
    //                   UNTIL lrc_SalesPostArchivComment2.NEXT() = 0;
    //                 END;
    //               UNTIL lrc_SalesPostArchivComment.NEXT() = 0;
    //            END;

    //            // Fussbemerkungen und zugehörige Zeilen kopieren
    //            lrc_SalesPostArchivComment.Reset();
    //            lrc_SalesPostArchivComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                           "Document Source","Document Type","Document No.","Document Line No.");
    //            lrc_SalesPostArchivComment.SETRANGE("Entry Type", lrc_SalesPostArchivComment."Entry Type"::Header);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Source", lrc_SalesPostArchivComment."Document Source"::Header);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesPostArchivComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //            lrc_SalesPostArchivComment.SETRANGE(Placement, lrc_SalesPostArchivComment.Placement::Footer);
    //            IF lrc_SalesPostArchivComment.FIND('-') THEN BEGIN
    //              REPEAT
    //                lrc_SalesComment.Reset();
    //                lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //                IF lrc_SalesComment.FIND('+') THEN BEGIN
    //                  lin_newEntryNo := lrc_SalesComment."Entry No." + 1
    //                END ELSE BEGIN
    //                  lin_newEntryNo := 1;
    //                END;

    //                lrc_SalesComment.INIT();
    //                lrc_SalesComment."Entry No." := lin_newEntryNo;
    //                lrc_SalesComment."Entry Type" := lrc_SalesPostArchivComment."Entry Type";
    //                lrc_SalesComment."Line No." := lrc_SalesPostArchivComment."Line No.";
    //                lrc_SalesComment."Document Source" := lrc_SalesPostArchivComment."Document Source";
    //                CASE vop_TargetDocumentType OF
    //                          0: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Quote;
    //                          1: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Order;
    //                          2: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Invoice;
    //                          3: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Credit Memo";
    //                          4: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Blanket Order";
    //                          5: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Return Order";
    //                END;
    //                lrc_SalesComment."Document No." := vco_TargetDocumentNo;
    //                lrc_SalesComment."Document Line No." := vin_TargetDocumentLineNo;
    //                lrc_SalesComment.Placement := lrc_SalesPostArchivComment.Placement;
    //                lrc_SalesComment.Comment := lrc_SalesPostArchivComment.Comment;
    //                lrc_SalesComment.INSERT(TRUE);

    //                // dann die Zeilen dazu
    //                lrc_SalesPostArchivComment2.Reset();
    //                lrc_SalesPostArchivComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                         "Document Source","Document Type","Document No.","Document Line No.");
    //                lrc_SalesPostArchivComment2.SETRANGE("Entry Type", lrc_SalesPostArchivComment2."Entry Type"::Line);
    //                lrc_SalesPostArchivComment2.SETRANGE("Entry No.", lrc_SalesPostArchivComment."Entry No.");
    //                lrc_SalesPostArchivComment2.SETRANGE("Document Source", lrc_SalesPostArchivComment2."Document Source"::Header);
    //                lrc_SalesPostArchivComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                lrc_SalesPostArchivComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                lrc_SalesPostArchivComment2.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //                lrc_SalesPostArchivComment2.SETRANGE(Placement, lrc_SalesPostArchivComment2.Placement::Footer);
    //                IF lrc_SalesPostArchivComment2.FIND('-') THEN BEGIN
    //                  REPEAT
    //                    lrc_SalesComment.INIT();
    //                    lrc_SalesComment."Entry No." := lin_newEntryNo;
    //                    lrc_SalesComment."Entry Type" := lrc_SalesPostArchivComment2."Entry Type";
    //                    lrc_SalesComment."Line No." := lrc_SalesPostArchivComment2."Line No.";
    //                    lrc_SalesComment."Document Source" := lrc_SalesPostArchivComment2."Document Source";
    //                    CASE vop_TargetDocumentType OF
    //                      0: lrc_SalesComment."Document Type" :=
    //                                          lrc_SalesComment."Document Type"::Quote;
    //                      1: lrc_SalesComment."Document Type" :=
    //                                          lrc_SalesComment."Document Type"::Order;
    //                      2: lrc_SalesComment."Document Type" :=
    //                                          lrc_SalesComment."Document Type"::Invoice;
    //                      3: lrc_SalesComment."Document Type" :=
    //                                          lrc_SalesComment."Document Type"::"Credit Memo";
    //                      4: lrc_SalesComment."Document Type" :=
    //                                          lrc_SalesComment."Document Type"::"Blanket Order";
    //                      5: lrc_SalesComment."Document Type" :=
    //                                          lrc_SalesComment."Document Type"::"Return Order";
    //                    END;
    //                    lrc_SalesComment."Document No." := vco_TargetDocumentNo;
    //                    lrc_SalesComment."Document Line No." := vin_TargetDocumentLineNo;
    //                    lrc_SalesComment.Placement := lrc_SalesPostArchivComment2.Placement;
    //                    lrc_SalesComment.Comment := lrc_SalesPostArchivComment2.Comment;
    //                    lrc_SalesComment.INSERT(TRUE);
    //                  UNTIL lrc_SalesPostArchivComment2.NEXT() = 0;
    //                END;
    //              UNTIL lrc_SalesPostArchivComment.NEXT() = 0;
    //            END;

    //            // Zeilenbemerkungen und zugehörige Zeilen kopieren
    //            lrc_SalesPostArchivComment.Reset();
    //            lrc_SalesPostArchivComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                           "Document Source","Document Type","Document No.","Document Line No.");
    //            lrc_SalesPostArchivComment.SETRANGE("Entry Type", lrc_SalesPostArchivComment."Entry Type"::Header);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Source", lrc_SalesPostArchivComment."Document Source"::Header);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesPostArchivComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //            lrc_SalesPostArchivComment.SETRANGE(Placement, lrc_SalesPostArchivComment.Placement::Line);
    //            IF lrc_SalesPostArchivComment.FIND('-') THEN BEGIN
    //               REPEAT
    //                        lrc_SalesComment.Reset();
    //                        lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //                        IF lrc_SalesComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_SalesComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_SalesComment.INIT();
    //                        lrc_SalesComment."Entry No." := lin_newEntryNo;
    //                        lrc_SalesComment."Entry Type" := lrc_SalesPostArchivComment."Entry Type";
    //                        lrc_SalesComment."Line No." := lrc_SalesPostArchivComment."Line No.";
    //                        lrc_SalesComment."Document Source" := lrc_SalesPostArchivComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Quote;
    //                          1: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Order;
    //                          2: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Invoice;
    //                          3: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Credit Memo";
    //                          4: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Blanket Order";
    //                          5: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Return Order";
    //                        END;
    //                        lrc_SalesComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_SalesComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_SalesComment.Placement := lrc_SalesPostArchivComment.Placement;
    //                        lrc_SalesComment.Comment := lrc_SalesPostArchivComment.Comment;
    //                        lrc_SalesComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_SalesPostArchivComment2.Reset();
    //                        lrc_SalesPostArchivComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_SalesPostArchivComment2.SETRANGE("Entry Type", lrc_SalesPostArchivComment2."Entry Type"::Line);
    //                        lrc_SalesPostArchivComment2.SETRANGE("Entry No.", lrc_SalesPostArchivComment."Entry No.");
    //                        lrc_SalesPostArchivComment2.SETRANGE("Document Source", lrc_SalesPostArchivComment2."Document Source"::Header);
    //                        lrc_SalesPostArchivComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_SalesPostArchivComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_SalesPostArchivComment2.SETRANGE("Document Line No.", vin_SourceDocumentLineNo);
    //                        lrc_SalesPostArchivComment2.SETRANGE(Placement, lrc_SalesPostArchivComment2.Placement::Line);
    //                 IF lrc_SalesPostArchivComment2.FIND('-') THEN BEGIN
    //                   REPEAT
    //                     lrc_SalesComment.INIT();
    //                     lrc_SalesComment."Entry No." := lin_newEntryNo;
    //                     lrc_SalesComment."Entry Type" := lrc_SalesPostArchivComment2."Entry Type";
    //                     lrc_SalesComment."Line No." := lrc_SalesPostArchivComment2."Line No.";
    //                     lrc_SalesComment."Document Source" := lrc_SalesPostArchivComment2."Document Source";
    //                     CASE vop_TargetDocumentType OF
    //                       0: lrc_SalesComment."Document Type" :=
    //                                           lrc_SalesComment."Document Type"::Quote;
    //                       1: lrc_SalesComment."Document Type" :=
    //                                           lrc_SalesComment."Document Type"::Order;
    //                       2: lrc_SalesComment."Document Type" :=
    //                                           lrc_SalesComment."Document Type"::Invoice;
    //                       3: lrc_SalesComment."Document Type" :=
    //                                           lrc_SalesComment."Document Type"::"Credit Memo";
    //                       4: lrc_SalesComment."Document Type" :=
    //                                           lrc_SalesComment."Document Type"::"Blanket Order";
    //                       5: lrc_SalesComment."Document Type" :=
    //                                           lrc_SalesComment."Document Type"::"Return Order";
    //                     END;
    //                     lrc_SalesComment."Document No." := vco_TargetDocumentNo;
    //                     lrc_SalesComment."Document Line No." := vin_TargetDocumentLineNo;
    //                     lrc_SalesComment.Placement := lrc_SalesPostArchivComment2.Placement;
    //                     lrc_SalesComment.Comment := lrc_SalesPostArchivComment2.Comment;
    //                     lrc_SalesComment.INSERT(TRUE);
    //                   UNTIL lrc_SalesPostArchivComment2.NEXT() = 0;
    //                 END;
    //               UNTIL lrc_SalesPostArchivComment.NEXT() = 0;
    //            END;

    //         END ELSE BEGIN

    //            // Nur eine bestimmte Zeilenbemerkung und zugehörige Zeilen kopieren
    //            lrc_SalesPostArchivComment.Reset();
    //            lrc_SalesPostArchivComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                           "Document Source","Document Type","Document No.","Document Line No.");
    //            lrc_SalesPostArchivComment.SETRANGE("Entry Type", lrc_SalesPostArchivComment."Entry Type"::Header);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Source", lrc_SalesPostArchivComment."Document Source"::Line);
    //            lrc_SalesPostArchivComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesPostArchivComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesPostArchivComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //            lrc_SalesPostArchivComment.SETRANGE(Placement, lrc_SalesPostArchivComment.Placement::Line);
    //            IF lrc_SalesPostArchivComment.FIND('-') THEN BEGIN
    //               REPEAT
    //                        lrc_SalesComment.Reset();
    //                        lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //                        IF lrc_SalesComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_SalesComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_SalesComment.INIT();
    //                        lrc_SalesComment."Entry No." := lin_newEntryNo;
    //                        lrc_SalesComment."Entry Type" := lrc_SalesPostArchivComment."Entry Type";
    //                        lrc_SalesComment."Line No." := lrc_SalesPostArchivComment."Line No.";
    //                        lrc_SalesComment."Document Source" := lrc_SalesPostArchivComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Quote;
    //                          1: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Order;
    //                          2: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::Invoice;
    //                          3: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Credit Memo";
    //                          4: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Blanket Order";
    //                          5: lrc_SalesComment."Document Type" :=
    //                                        lrc_SalesComment."Document Type"::"Return Order";
    //                        END;
    //                        lrc_SalesComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_SalesComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_SalesComment.Placement := lrc_SalesPostArchivComment.Placement;
    //                        lrc_SalesComment.Comment := lrc_SalesPostArchivComment.Comment;
    //                        lrc_SalesComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_SalesPostArchivComment2.Reset();
    //                        lrc_SalesPostArchivComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_SalesPostArchivComment2.SETRANGE("Entry Type", lrc_SalesPostArchivComment2."Entry Type"::Line);
    //                        lrc_SalesPostArchivComment2.SETRANGE("Entry No.", lrc_SalesPostArchivComment."Entry No.");
    //                        lrc_SalesPostArchivComment2.SETRANGE("Document Source", lrc_SalesPostArchivComment2."Document Source"::Line);
    //                        lrc_SalesPostArchivComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_SalesPostArchivComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_SalesPostArchivComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //                        lrc_SalesPostArchivComment2.SETRANGE(Placement, lrc_SalesPostArchivComment2.Placement::Line);
    //                        IF lrc_SalesPostArchivComment2.FIND('-') THEN BEGIN
    //                           REPEAT
    //                             lrc_SalesComment.INIT();
    //                             lrc_SalesComment."Entry No." := lin_newEntryNo;
    //                             lrc_SalesComment."Entry Type" := lrc_SalesPostArchivComment2."Entry Type";
    //                             lrc_SalesComment."Line No." := lrc_SalesPostArchivComment2."Line No.";
    //                             lrc_SalesComment."Document Source" := lrc_SalesPostArchivComment2."Document Source";
    //                             CASE vop_TargetDocumentType OF
    //                               0: lrc_SalesComment."Document Type" :=
    //                                             lrc_SalesComment."Document Type"::Quote;
    //                               1: lrc_SalesComment."Document Type" :=
    //                                             lrc_SalesComment."Document Type"::Order;
    //                               2: lrc_SalesComment."Document Type" :=
    //                                             lrc_SalesComment."Document Type"::Invoice;
    //                               3: lrc_SalesComment."Document Type" :=
    //                                             lrc_SalesComment."Document Type"::"Credit Memo";
    //                               4: lrc_SalesComment."Document Type" :=
    //                                             lrc_SalesComment."Document Type"::"Blanket Order";
    //                               5: lrc_SalesComment."Document Type" :=
    //                                             lrc_SalesComment."Document Type"::"Return Order";
    //                             END;
    //                             lrc_SalesComment."Document No." := vco_TargetDocumentNo;
    //                             lrc_SalesComment."Document Line No." := vin_TargetDocumentLineNo;
    //                             lrc_SalesComment.Placement := lrc_SalesPostArchivComment2.Placement;
    //                             lrc_SalesComment.Comment := lrc_SalesPostArchivComment2.Comment;
    //                             lrc_SalesComment.INSERT(TRUE);
    //                           UNTIL lrc_SalesPostArchivComment2.NEXT() = 0;
    //                        END;
    //               UNTIL lrc_SalesPostArchivComment.NEXT() = 0;
    //            END;

    //         END;
    //         // IFW 001 IFW40076.e
    //     end;

    //     procedure "-- PURCHASE --"()
    //     begin
    //     end;

    //     procedure PurchHeaderComment(vrc_PurchHeader: Record "38")
    //     var
    //         lcu_Purchase: Codeunit "5110323";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_PurchComment: Record "5110432";
    //         lrc_PurchCommentPrintDoc: Record "5110433";
    //         lfm_PurchComment: Form "5110505";
    //         lco_ArrShippingAgent: array [1000] of Code[20];
    //         lco_ArrPhysLocation: array [1000] of Code[20];
    //         lco_ArrLocation: array [1000] of Code[20];
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Kopf
    //         // ------------------------------------------------------------------------------------

    //         vrc_PurchHeader.TESTFIELD("No.");

    //         // Alle Lagerorte in Array schreiben
    //         lcu_Purchase.FillArrLocation(vrc_PurchHeader."Document Type",vrc_PurchHeader."No.",lco_ArrLocation);
    //         // Alle Physischen Lagerorte in Array schreiben
    //         lcu_Purchase.FillArrPhysLocation(vrc_PurchHeader."Document Type",vrc_PurchHeader."No.",lco_ArrPhysLocation);
    //         // Alle Zusteller in Array schreiben
    //         lcu_Purchase.FillArrShippingAgent(vrc_PurchHeader."Document Type",vrc_PurchHeader."No.",lco_ArrShippingAgent);


    //         lrc_PurchComment.FILTERGROUP(2);
    //         lrc_PurchComment.SETRANGE("Entry Type",lrc_PurchComment."Entry Type"::Header);
    //         lrc_PurchComment.SETRANGE("Document Source",lrc_PurchComment."Document Source"::Header);
    //         lrc_PurchComment.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //         lrc_PurchComment.SETRANGE("Document No.",vrc_PurchHeader."No.");
    //         lrc_PurchComment.SETRANGE("Document Line No.",0);
    //         lrc_PurchComment.FILTERGROUP(0);
    //         IF lrc_PurchComment.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Zuordnung Druckbelege löschen falls nicht zugeordnet
    //             lrc_PurchCommentPrintDoc.Reset();
    //             lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",lrc_PurchComment."Entry No.");
    //             lrc_PurchCommentPrintDoc.SETRANGE(Print,FALSE);
    //             lrc_PurchCommentPrintDoc.DELETEALL();


    //             lrc_PrintDocument.Reset();
    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Purchase);
    //             lrc_PrintDocument.SETRANGE("Document Type",vrc_PurchHeader."Document Type");
    //             IF lrc_PrintDocument.FIND('-') THEN
    //               REPEAT

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Keine Mehrfachgenerierung
    //                 // ----------------------------------------------------------------------------------------------
    //                 CASE lrc_PrintDocument."Multiple Entry for" OF
    //                   lrc_PrintDocument."Multiple Entry for"::" ":
    //                     BEGIN
    //                       lrc_PurchCommentPrintDoc.Reset();
    //                       lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",lrc_PurchComment."Entry No.");
    //                       lrc_PurchCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                       lrc_PurchCommentPrintDoc.SETRANGE("Detail Code",'');
    //                       IF NOT lrc_PurchCommentPrintDoc.FIND('-') THEN BEGIN
    //                         lrc_PurchCommentPrintDoc.Reset();
    //                         lrc_PurchCommentPrintDoc.INIT();
    //                         lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                         lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_PurchCommentPrintDoc."Detail Code" := '';
    //                         lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_PurchCommentPrintDoc.Print := FALSE;
    //                         lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                         lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::Location:
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_PurchCommentPrintDoc.Reset();
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",lrc_PurchComment."Entry No.");
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                           IF NOT lrc_PurchCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_PurchCommentPrintDoc.Reset();
    //                             lrc_PurchCommentPrintDoc.INIT();
    //                             lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                             lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_PurchCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                             lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_PurchCommentPrintDoc.Print := FALSE;
    //                             lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                             lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                        END;
    //                        lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Physisches Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Location Group":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrPhysLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_PurchCommentPrintDoc.Reset();
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",lrc_PurchComment."Entry No.");
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Detail Code",lco_ArrPhysLocation[lin_ArrZähler]);
    //                           IF NOT lrc_PurchCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_PurchCommentPrintDoc.Reset();
    //                             lrc_PurchCommentPrintDoc.INIT();
    //                             lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                             lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_PurchCommentPrintDoc."Detail Code" := lco_ArrPhysLocation[lin_ArrZähler];
    //                             lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_PurchCommentPrintDoc.Print := FALSE;
    //                             lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                             lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Abgangsregion
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Departure Region":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN

    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Zusteller
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_PurchCommentPrintDoc.Reset();
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",lrc_PurchComment."Entry No.");
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_PurchCommentPrintDoc.SETRANGE("Detail Code",lco_ArrShippingAgent[lin_ArrZähler]);
    //                           IF NOT lrc_PurchCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_PurchCommentPrintDoc.Reset();
    //                             lrc_PurchCommentPrintDoc.INIT();
    //                             lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                             lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_PurchCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                             lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_PurchCommentPrintDoc.Print := FALSE;
    //                             lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                             lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 END;

    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //           UNTIL lrc_PurchComment.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_PurchComment.SetGlobals(vrc_PurchHeader."Document Type",vrc_PurchHeader."No.",0);
    //         lfm_PurchComment.SETTABLEVIEW(lrc_PurchComment);
    //         lfm_PurchComment.RUNMODAL;
    //     end;

    //     procedure PurchShowComment(vrc_PurchComment: Record "5110432")
    //     var
    //         lrc_PurchComment: Record "5110432";
    //         lrc_PurchCommentLine: Record "5110432";
    //         lfm_PurchCommentCard: Form "5110506";
    //         Text01: Label 'Bitte wählen Sie einen gültigen Eintrag aus!';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungskarte Kopf
    //         // ------------------------------------------------------------------------------------

    //         IF vrc_PurchComment."Entry No." <= 0 THEN
    //           // Bitte wählen Sie einen gültigen Eintrag aus!
    //           ERROR(Text01);

    //         lrc_PurchComment.FILTERGROUP(2);
    //         lrc_PurchComment.SETRANGE("Entry No.",vrc_PurchComment."Entry No.");
    //         lrc_PurchComment.SETRANGE("Entry Type",vrc_PurchComment."Entry Type");
    //         lrc_PurchComment.SETRANGE("Line No.",vrc_PurchComment."Line No.");
    //         lrc_PurchComment.FILTERGROUP(0);

    //         lfm_PurchCommentCard.SETTABLEVIEW(lrc_PurchComment);
    //         lfm_PurchCommentCard.RUNMODAL;

    //         // Erste Bemerkungszeile in Kopfsatz setzen
    //         PurchSetCommentFirstLine(vrc_PurchComment."Entry No.");
    //     end;

    //     procedure PurchNewComment(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];vin_DocLineNo: Integer)
    //     var
    //         lcu_Purch: Codeunit "5110323";
    //         lrc_PurchHeader: Record "38";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_PurchComment: Record "5110432";
    //         lrc_PurchCommentPrintDoc: Record "5110433";
    //         lfm_PurchCommentCard: Form "5110506";
    //         "lin_ArrZähler": Integer;
    //         lco_ArrShippingAgent: array [1000] of Code[20];
    //         lco_ArrPhysLocation: array [1000] of Code[20];
    //         lco_ArrLocation: array [1000] of Code[20];
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung einer neuen Bemerkung Kopf / Zeile
    //         // ------------------------------------------------------------------------------------

    //         lrc_PurchHeader.GET(vop_DocType,vco_DocNo);

    //         // Alle Lagerorte in Array schreiben
    //         lcu_Purch.FillArrLocation(vop_DocType,vco_DocNo,lco_ArrLocation);
    //         // Alle Physischen Lagerorte in Array schreiben
    //         lcu_Purch.FillArrPhysLocation(vop_DocType,vco_DocNo,lco_ArrPhysLocation);
    //         // Alle Zusteller in Array schreiben
    //         lcu_Purch.FillArrShippingAgent(vop_DocType,vco_DocNo,lco_ArrShippingAgent);

    //         // Kopfsatz Bemerkung anlegen
    //         lrc_PurchComment.Reset();
    //         lrc_PurchComment.INIT();
    //         lrc_PurchComment."Entry No." := 0;
    //         lrc_PurchComment."Entry Type" := lrc_PurchComment."Entry Type"::Header;
    //         lrc_PurchComment."Line No." := 0;

    //         IF vin_DocLineNo = 0 THEN
    //           lrc_PurchComment."Document Source" := lrc_PurchComment."Document Source"::Header
    //         ELSE
    //           lrc_PurchComment."Document Source" := lrc_PurchComment."Document Source"::Line;
    //         lrc_PurchComment."Document Type" := lrc_PurchHeader."Document Type";
    //         lrc_PurchComment."Document No." := lrc_PurchHeader."No.";
    //         lrc_PurchComment."Document Line No." := vin_DocLineNo;

    //         IF vin_DocLineNo = 0 THEN
    //           lrc_PurchComment.Placement := lrc_PurchComment.Placement::Footer
    //         ELSE
    //           lrc_PurchComment.Placement := lrc_PurchComment.Placement::Line;
    //         lrc_PurchComment.Comment := '';
    //         lrc_PurchComment.INSERT(TRUE);

    //         // Filter mit Filtergruppe setzen
    //         lrc_PurchComment.FILTERGROUP(2);
    //         lrc_PurchComment.SETRANGE("Entry No.",lrc_PurchComment."Entry No.");
    //         lrc_PurchComment.SETRANGE("Entry Type",lrc_PurchComment."Entry Type");
    //         lrc_PurchComment.SETRANGE("Line No.",lrc_PurchComment."Line No.");
    //         lrc_PurchComment.FILTERGROUP(0);


    //         // Druckbelege Laden für die Bemerkungen erfaßt werden können
    //         lrc_PrintDocument.Reset();
    //         lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Purchase);
    //         lrc_PrintDocument.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //         IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //           REPEAT

    //             CASE lrc_PrintDocument."Multiple Entry for" OF
    //               // ----------------------------------------------------------------------------------------------
    //               // Keine Mehrfachgenerierung
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::" ":
    //                 BEGIN
    //                   lrc_PurchCommentPrintDoc.Reset();
    //                   lrc_PurchCommentPrintDoc.INIT();
    //                   lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                   lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                   lrc_PurchCommentPrintDoc."Detail Code" := '';
    //                   lrc_PurchCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                   lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_PurchCommentPrintDoc.Print := FALSE;
    //                   lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                   lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Lager
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::Location:
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                        lrc_PurchCommentPrintDoc.Reset();
    //                        lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",lrc_PurchComment."Entry No.");
    //                        lrc_PurchCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                        lrc_PurchCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                        IF NOT lrc_PurchCommentPrintDoc.FIND('-') THEN BEGIN
    //                          lrc_PurchCommentPrintDoc.Reset();
    //                          lrc_PurchCommentPrintDoc.INIT();
    //                          lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                          lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                          lrc_PurchCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                          lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                          lrc_PurchCommentPrintDoc.Print := FALSE;
    //                          lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                          lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                        END;
    //                    END;

    //                    lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Physisches Lager
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Location Group":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrPhysLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                       lrc_PurchCommentPrintDoc.Reset();
    //                       lrc_PurchCommentPrintDoc.INIT();
    //                       lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                       lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                       lrc_PurchCommentPrintDoc."Detail Code" := lco_ArrPhysLocation[lin_ArrZähler];
    //                       lrc_PurchCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                       lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                       lrc_PurchCommentPrintDoc.Print := FALSE;
    //                       lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                       lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                     END;

    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Abgangsregion
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Departure Region":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN

    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Zusteller
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                       lrc_PurchCommentPrintDoc.Reset();
    //                       lrc_PurchCommentPrintDoc.INIT();
    //                       lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                       lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                       lrc_PurchCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                       lrc_PurchCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                       lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                       lrc_PurchCommentPrintDoc.Print := FALSE;
    //                       lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                       lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                     END;
    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;
    //             END;
    //           UNTIL lrc_PrintDocument.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_PurchCommentCard.SETTABLEVIEW(lrc_PurchComment);
    //         lfm_PurchCommentCard.RUNMODAL;

    //         // Erste Zeile in Kopfsatz generieren
    //         PurchSetCommentFirstLine(lrc_PurchComment."Entry No.");
    //     end;

    //     procedure PurchSetCommentFirstLine(vin_EntryNo: Integer)
    //     var
    //         lrc_PurchCommentHeader: Record "5110432";
    //         lrc_PurchCommentLine: Record "5110432";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der ersten Bemerkungszeile in den Kopfsatz Bemerkungen
    //         // ------------------------------------------------------------------------------------------------

    //         // Kommentar aus erster Zeile in Kopfsatz setzen
    //         lrc_PurchCommentHeader.Reset();
    //         lrc_PurchCommentHeader.SETRANGE("Entry No.",vin_EntryNo);
    //         lrc_PurchCommentHeader.SETRANGE("Entry Type",lrc_PurchCommentHeader."Entry Type"::Header);
    //         lrc_PurchCommentHeader.SETRANGE("Line No.",0);
    //         lrc_PurchCommentHeader.FINDFIRST;

    //         lrc_PurchCommentLine.SETRANGE("Entry No.",lrc_PurchCommentHeader."Entry No.");
    //         lrc_PurchCommentLine.SETRANGE("Entry Type",lrc_PurchCommentLine."Entry Type"::Line);
    //         IF lrc_PurchCommentLine.FIND('-') THEN BEGIN
    //           lrc_PurchCommentHeader.Comment := lrc_PurchCommentLine.Comment;
    //           lrc_PurchCommentHeader.Modify();
    //         END ELSE BEGIN
    //           lrc_PurchCommentHeader.DELETE(TRUE);
    //         END;
    //     end;

    //     procedure PurchCommentOnAllDoc(vin_EntryNo: Integer;vop_Typ: Option "0","1","2","3","4","5")
    //     var
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_PurchComment: Record "5110432";
    //         lrc_PurchCommentPrintDoc: Record "5110433";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum setzen ShowText in allen Druckbelegen Kopf
    //         // ------------------------------------------------------------------------------------

    //         // vop_Typ = 0 Alle
    //         // vop_Typ = 1 Kreditoren
    //         // vop_Typ = 2 Lagerort
    //         // vop_Typ = 3 Zusteller

    //         CASE vop_Typ OF
    //           0:
    //             BEGIN
    //               lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",vin_EntryNo);
    //               lrc_PurchCommentPrintDoc.MODIFYALL(Print,TRUE);
    //             END;
    //           1,2,3:
    //             BEGIN
    //               lrc_PurchComment.Reset();
    //               lrc_PurchComment.SETRANGE("Entry No.", vin_EntryNo);
    //               lrc_PurchComment.SETRANGE("Entry Type", lrc_PurchComment."Entry Type"::Header);
    //               IF lrc_PurchComment.FIND('-') THEN BEGIN
    //                 lrc_PurchCommentPrintDoc.Reset();
    //                 lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",vin_EntryNo);
    //                 IF lrc_PurchCommentPrintDoc.FIND('-') THEN BEGIN
    //                   lrc_PrintDocument.Reset();
    //                   lrc_PrintDocument.SETCURRENTKEY( "Document Source","Document Type",Code);
    //                   REPEAT
    //                     lrc_PrintDocument.SETRANGE("Document Source", lrc_PrintDocument."Document Source"::Purchase);
    //                     lrc_PrintDocument.SETRANGE("Document Type", lrc_PurchComment."Document Type");
    //                     lrc_PrintDocument.SETRANGE(Code, lrc_PurchCommentPrintDoc."Print Document Code");
    //                     IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //                       IF ((vop_Typ = 1) AND
    //                          (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::"Customer/Vendor")) OR
    //                          ((vop_Typ = 2) AND
    //                          (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::Location)) OR
    //                          ((vop_Typ = 3) AND
    //                          (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::"Shipping Agent")) THEN BEGIN
    //                         lrc_PurchCommentPrintDoc.VALIDATE(Print,TRUE);
    //                         lrc_PurchCommentPrintDoc.MODIFY(TRUE);
    //                       END;
    //                     END;
    //                   UNTIL lrc_PurchCommentPrintDoc.NEXT() = 0;
    //                 END;
    //               END;
    //             END;
    //         END;
    //     end;

    //     procedure PurchLineComment(vrc_PurchLine: Record "39")
    //     var
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_PurchComment: Record "5110432";
    //         lrc_PurchCommentPrintDoc: Record "5110433";
    //         lfm_PurchComment: Form "5110505";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Zeile
    //         // ------------------------------------------------------------------------------------

    //         vrc_PurchLine.TESTFIELD("Document No.");
    //         vrc_PurchLine.TESTFIELD("Line No.");

    //         lrc_PurchComment.FILTERGROUP(2);
    //         lrc_PurchComment.SETRANGE("Entry Type",lrc_PurchComment."Entry Type"::Header);
    //         lrc_PurchComment.SETRANGE("Document Source",lrc_PurchComment."Document Source"::Line);
    //         lrc_PurchComment.SETRANGE("Document Type",vrc_PurchLine."Document Type");
    //         lrc_PurchComment.SETRANGE("Document No.",vrc_PurchLine."Document No.");
    //         lrc_PurchComment.SETRANGE("Document Line No.",vrc_PurchLine."Line No.");
    //         lrc_PurchComment.FILTERGROUP(0);
    //         IF lrc_PurchComment.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Purchase);
    //             lrc_PrintDocument.SETRANGE("Document Type",vrc_PurchLine."Document Type");
    //             IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.",lrc_PurchComment."Entry No.");
    //                 lrc_PurchCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                 IF NOT lrc_PurchCommentPrintDoc.FIND('-') THEN BEGIN
    //                   lrc_PurchCommentPrintDoc.Reset();
    //                   lrc_PurchCommentPrintDoc.INIT();
    //                   lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
    //                   lrc_PurchCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                   lrc_PurchCommentPrintDoc."Detail Code" := '';
    //                   lrc_PurchCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_PurchCommentPrintDoc.Print := FALSE;
    //                   lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                   lrc_PurchCommentPrintDoc.INSERT(TRUE);
    //                 END;
    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //             END;
    //           UNTIL lrc_PurchComment.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_PurchComment.SetGlobals(vrc_PurchLine."Document Type",vrc_PurchLine."Document No.",vrc_PurchLine."Line No.");
    //         lfm_PurchComment.SETTABLEVIEW(lrc_PurchComment);
    //         lfm_PurchComment.RUNMODAL;
    //     end;

    //     procedure PurchLineGeneralComment(vrc_PurchLine: Record "39")
    //     var
    //         lrc_PurchComment: Record "5110432";
    //         lfm_PurchComment: Form "5110505";
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------

    //         lrc_PurchComment.Reset();
    //         lrc_PurchComment.SETRANGE("Entry Type",lrc_PurchComment."Entry Type"::Header);
    //         lrc_PurchComment.SETRANGE("Document Source",lrc_PurchComment."Document Source"::Line);
    //         lrc_PurchComment.SETRANGE("Document Type",lrc_PurchComment."Document Type"::Order);
    //         lrc_PurchComment.SETRANGE("Document No.",vrc_PurchLine."Document No.");
    //         lrc_PurchComment.SETRANGE("Document Line No.",vrc_PurchLine."Line No.");
    //         IF NOT lrc_PurchComment.FIND('-') THEN BEGIN
    //           lrc_PurchComment."Entry No." := 0;
    //           lrc_PurchComment."Entry Type" := lrc_PurchComment."Entry Type"::Header;
    //           lrc_PurchComment."Line No." := 0;
    //           lrc_PurchComment."Document Source" := lrc_PurchComment."Document Source"::Line;
    //           lrc_PurchComment."Document Type" := lrc_PurchComment."Document Type"::Order;
    //           lrc_PurchComment."Document No." := vrc_PurchLine."Document No.";
    //           lrc_PurchComment."Document Line No." := vrc_PurchLine."Line No.";
    //           lrc_PurchComment.Consignee := lrc_PurchComment.Consignee::" ";
    //           lrc_PurchComment.Placement := lrc_PurchComment.Placement::Line;
    //           lrc_PurchComment.INSERT(TRUE);
    //           COMMIT;
    //         END;

    //         // Filter mit Filtergruppe setzen
    //         lrc_PurchComment.Reset();
    //         lrc_PurchComment.FILTERGROUP(2);
    //         lrc_PurchComment.SETRANGE("Entry No.",lrc_PurchComment."Entry No.");
    //         lrc_PurchComment.SETRANGE("Entry Type",lrc_PurchComment."Entry Type"::Line);
    //         lrc_PurchComment.FILTERGROUP(0);

    //         lfm_PurchComment.SETTABLEVIEW(lrc_PurchComment);
    //         lfm_PurchComment.RUNMODAL();
    //     end;

    //     procedure PurchMoveCommentToPostComment(vop_SourceDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";vco_SourceDocumentNo: Code[20];vin_SourceDocumentLineNo: Integer;vop_TargetDocumentType: Option Shipment,Invoice,"Credit Memo","Return Shipment";vco_TargetDocumentNo: Code[20];vin_TargetDocumentLineNo: Integer)
    //     var
    //         lrc_PurchaseComment: Record "5110432";
    //         lrc_PurchaseComment2: Record "5110432";
    //         lrc_PurchaseCommentPrintDoc: Record "5110433";
    //         lrc_PurchasePostArchivComment: Record "5110434";
    //         lin_newEntryNo: Integer;
    //     begin
    //         // -------------------------------------------------------------------------------------------
    //         //
    //         // -------------------------------------------------------------------------------------------

    //         IF vin_SourceDocumentLineNo = 0 THEN BEGIN
    //           // alle Header und Footer kopieren
    //           lrc_PurchaseComment.Reset();
    //           lrc_PurchaseComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //             "Document Source","Document Type","Document No.","Document Line No.");
    //           // erst nur Köpfe
    //           lrc_PurchaseComment.SETRANGE("Entry Type", lrc_PurchaseComment."Entry Type"::Header);
    //           lrc_PurchaseComment.SETRANGE("Document Source", lrc_PurchaseComment."Document Source"::Header);
    //           lrc_PurchaseComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //           lrc_PurchaseComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //           lrc_PurchaseComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //           lrc_PurchaseComment.SETRANGE( Placement, lrc_PurchaseComment.Placement::Header);
    //           IF lrc_PurchaseComment.FIND('-') THEN BEGIN

    //               REPEAT
    //                  lrc_PurchaseCommentPrintDoc.Reset();
    //                  lrc_PurchaseCommentPrintDoc.SETRANGE("Purch. Comment Entry No.", lrc_PurchaseComment."Entry No.");
    //                  CASE vop_TargetDocumentType OF
    //                    0:
    //                       lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G LS');
    //                    1:
    //                       lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G RG');
    //                    2:
    //                       lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G GS');
    //                    3:
    //                       lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G RL');
    //                  END;
    //                  IF lrc_PurchaseCommentPrintDoc.FIND('-') THEN BEGIN
    //                     IF lrc_PurchaseCommentPrintDoc.Print THEN BEGIN

    //                        lrc_PurchasePostArchivComment.Reset();
    //                        lrc_PurchasePostArchivComment.SETRANGE("Entry Type",lrc_PurchasePostArchivComment."Entry Type"::Header);
    //                        IF lrc_PurchasePostArchivComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_PurchasePostArchivComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_PurchasePostArchivComment.INIT();
    //                        lrc_PurchasePostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_PurchasePostArchivComment."Entry Type" := lrc_PurchaseComment."Entry Type";
    //                        lrc_PurchasePostArchivComment."Line No." := lrc_PurchaseComment."Line No.";
    //                        lrc_PurchasePostArchivComment."Document Source" := lrc_PurchaseComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Shipment";
    //                          1:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Invoice";
    //                          2:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Return Shipment";
    //                        END;
    //                        lrc_PurchasePostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_PurchasePostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_PurchasePostArchivComment.Placement := lrc_PurchaseComment.Placement;
    //                        lrc_PurchasePostArchivComment.Comment := lrc_PurchaseComment.Comment;
    //                        lrc_PurchasePostArchivComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_PurchaseComment2.Reset();
    //                        lrc_PurchaseComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_PurchaseComment2.SETRANGE("Entry Type", lrc_PurchaseComment2."Entry Type"::Line);
    //                        lrc_PurchaseComment2.SETRANGE("Entry No.", lrc_PurchaseComment."Entry No.");
    //                        lrc_PurchaseComment2.SETRANGE("Document Source", lrc_PurchaseComment2."Document Source"::Header);
    //                        lrc_PurchaseComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_PurchaseComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_PurchaseComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //                        lrc_PurchaseComment2.SETRANGE(Placement, lrc_PurchaseComment2.Placement::Header);
    //                        IF lrc_PurchaseComment2.FIND('-') THEN BEGIN
    //                           REPEAT
    //                              lrc_PurchasePostArchivComment.INIT();
    //                              lrc_PurchasePostArchivComment."Entry No." := lin_newEntryNo;
    //                              lrc_PurchasePostArchivComment."Entry Type" := lrc_PurchaseComment2."Entry Type";
    //                              lrc_PurchasePostArchivComment."Line No." := lrc_PurchaseComment2."Line No.";
    //                              lrc_PurchasePostArchivComment."Document Source" := lrc_PurchaseComment2."Document Source";
    //                              CASE vop_TargetDocumentType OF
    //                                0:
    //                                  lrc_PurchasePostArchivComment."Document Type" :=
    //                                    lrc_PurchasePostArchivComment."Document Type"::"Posted Shipment";
    //                                1:
    //                                  lrc_PurchasePostArchivComment."Document Type" :=
    //                                    lrc_PurchasePostArchivComment."Document Type"::"Posted Invoice";
    //                                2:
    //                                  lrc_PurchasePostArchivComment."Document Type" :=
    //                                    lrc_PurchasePostArchivComment."Document Type"::"Posted Credit Memo";
    //                                3:
    //                                  lrc_PurchasePostArchivComment."Document Type" :=
    //                                    lrc_PurchasePostArchivComment."Document Type"::"Posted Return Shipment";
    //                              END;
    //                              lrc_PurchasePostArchivComment."Document No." := vco_TargetDocumentNo;
    //                              lrc_PurchasePostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                              lrc_PurchasePostArchivComment.Placement := lrc_PurchaseComment2.Placement;
    //                              lrc_PurchasePostArchivComment.Comment := lrc_PurchaseComment2.Comment;
    //                              lrc_PurchasePostArchivComment.INSERT(TRUE);
    //                           UNTIL lrc_PurchaseComment2.NEXT() = 0;
    //                        END;
    //                    END;
    //                 END;
    //               UNTIL lrc_PurchaseComment.NEXT() = 0;
    //           END;

    //           lrc_PurchaseComment.Reset();
    //           lrc_PurchaseComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //             "Document Source","Document Type","Document No.","Document Line No.");
    //           // erst nur Köpfe
    //           lrc_PurchaseComment.SETRANGE("Entry Type", lrc_PurchaseComment."Entry Type"::Header);
    //           lrc_PurchaseComment.SETRANGE("Document Source", lrc_PurchaseComment."Document Source"::Header);
    //           lrc_PurchaseComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //           lrc_PurchaseComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //           lrc_PurchaseComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //           lrc_PurchaseComment.SETRANGE(Placement, lrc_PurchaseComment.Placement::Footer);
    //           IF lrc_PurchaseComment.FIND('-') THEN BEGIN
    //             REPEAT
    //               lrc_PurchaseCommentPrintDoc.Reset();
    //               lrc_PurchaseCommentPrintDoc.SETRANGE("Purch. Comment Entry No.", lrc_PurchaseComment."Entry No.");
    //               CASE vop_TargetDocumentType OF
    //                 0: lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G LS');
    //                 1: lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G RG');
    //                 2: lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G GS');
    //                 3: lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G RL');
    //               END;
    //               IF lrc_PurchaseCommentPrintDoc.FIND('-') THEN BEGIN
    //                 IF lrc_PurchaseCommentPrintDoc.Print THEN BEGIN

    //                        lrc_PurchasePostArchivComment.Reset();
    //                        lrc_PurchasePostArchivComment.SETRANGE("Entry Type",lrc_PurchasePostArchivComment."Entry Type"::Header);
    //                        IF lrc_PurchasePostArchivComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_PurchasePostArchivComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_PurchasePostArchivComment.INIT();
    //                        lrc_PurchasePostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_PurchasePostArchivComment."Entry Type" := lrc_PurchaseComment."Entry Type";
    //                        lrc_PurchasePostArchivComment."Line No." := lrc_PurchaseComment."Line No.";
    //                        lrc_PurchasePostArchivComment."Document Source" := lrc_PurchaseComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Shipment";
    //                          1:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Invoice";
    //                          2:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Return Shipment";
    //                        END;
    //                        lrc_PurchasePostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_PurchasePostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_PurchasePostArchivComment.Placement := lrc_PurchaseComment.Placement;
    //                        lrc_PurchasePostArchivComment.Comment := lrc_PurchaseComment.Comment;
    //                        lrc_PurchasePostArchivComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_PurchaseComment2.Reset();
    //                        lrc_PurchaseComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_PurchaseComment2.SETRANGE("Entry Type", lrc_PurchaseComment2."Entry Type"::Line);
    //                        lrc_PurchaseComment2.SETRANGE("Entry No.", lrc_PurchaseComment."Entry No.");
    //                        lrc_PurchaseComment2.SETRANGE("Document Source", lrc_PurchaseComment2."Document Source"::Header);
    //                        lrc_PurchaseComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_PurchaseComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_PurchaseComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //                        lrc_PurchaseComment2.SETRANGE(Placement, lrc_PurchaseComment2.Placement::Footer);
    //                        IF lrc_PurchaseComment2.FIND('-') THEN BEGIN
    //                           REPEAT
    //                             lrc_PurchasePostArchivComment.INIT();
    //                             lrc_PurchasePostArchivComment."Entry No." := lin_newEntryNo;
    //                             lrc_PurchasePostArchivComment."Entry Type" := lrc_PurchaseComment2."Entry Type";
    //                             lrc_PurchasePostArchivComment."Line No." := lrc_PurchaseComment2."Line No.";
    //                             lrc_PurchasePostArchivComment."Document Source" := lrc_PurchaseComment2."Document Source";
    //                             CASE vop_TargetDocumentType OF
    //                               0:
    //                                 lrc_PurchasePostArchivComment."Document Type" :=
    //                                   lrc_PurchasePostArchivComment."Document Type"::"Posted Shipment";
    //                               1:
    //                                 lrc_PurchasePostArchivComment."Document Type" :=
    //                                   lrc_PurchasePostArchivComment."Document Type"::"Posted Invoice";
    //                               2:
    //                                 lrc_PurchasePostArchivComment."Document Type" :=
    //                                   lrc_PurchasePostArchivComment."Document Type"::"Posted Credit Memo";
    //                               3:
    //                                 lrc_PurchasePostArchivComment."Document Type" :=
    //                                   lrc_PurchasePostArchivComment."Document Type"::"Posted Return Shipment";
    //                             END;
    //                             lrc_PurchasePostArchivComment."Document No." := vco_TargetDocumentNo;
    //                             lrc_PurchasePostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                             lrc_PurchasePostArchivComment.Placement := lrc_PurchaseComment2.Placement;
    //                             lrc_PurchasePostArchivComment.Comment := lrc_PurchaseComment2.Comment;
    //                             lrc_PurchasePostArchivComment.INSERT(TRUE);
    //                           UNTIL lrc_PurchaseComment2.NEXT() = 0;
    //                        END;

    //                 END;
    //               END;
    //             UNTIL lrc_PurchaseComment.NEXT() = 0;
    //           END;

    //         END ELSE BEGIN

    //           // nur die Zeile kopieren
    //           lrc_PurchaseComment.Reset();
    //           lrc_PurchaseComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //              "Document Source","Document Type","Document No.","Document Line No.");
    //           // erst nur Köpfe
    //           lrc_PurchaseComment.SETRANGE("Entry Type", lrc_PurchaseComment."Entry Type"::Header);
    //           lrc_PurchaseComment.SETRANGE("Document Source", lrc_PurchaseComment."Document Source"::Line);
    //           lrc_PurchaseComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //           lrc_PurchaseComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //           lrc_PurchaseComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //           lrc_PurchaseComment.SETRANGE( Placement, lrc_PurchaseComment.Placement::Line);
    //           IF lrc_PurchaseComment.FIND('-') THEN BEGIN
    //             REPEAT
    //               lrc_PurchaseCommentPrintDoc.Reset();
    //               lrc_PurchaseCommentPrintDoc.SETRANGE("Purch. Comment Entry No.", lrc_PurchaseComment."Entry No.");
    //               CASE vop_TargetDocumentType OF
    //                 0: lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G LS');
    //                 1: lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G RG');
    //                 2: lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G GS');
    //                 3: lrc_PurchaseCommentPrintDoc.SETRANGE("Print Document Code", 'E G RL');
    //               END;
    //               IF lrc_PurchaseCommentPrintDoc.FIND('-') THEN BEGIN
    //                 IF lrc_PurchaseCommentPrintDoc.Print THEN BEGIN

    //                        lrc_PurchasePostArchivComment.Reset();
    //                        lrc_PurchasePostArchivComment.SETRANGE("Entry Type",lrc_PurchasePostArchivComment."Entry Type"::Header);
    //                        IF lrc_PurchasePostArchivComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_PurchasePostArchivComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_PurchasePostArchivComment.INIT();
    //                        lrc_PurchasePostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_PurchasePostArchivComment."Entry Type" := lrc_PurchaseComment."Entry Type";
    //                        lrc_PurchasePostArchivComment."Line No." := lrc_PurchaseComment."Line No.";
    //                        lrc_PurchasePostArchivComment."Document Source" := lrc_PurchaseComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Shipment";
    //                          1:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Invoice";
    //                          2:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3:
    //                            lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Return Shipment";
    //                        END;
    //                        lrc_PurchasePostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_PurchasePostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_PurchasePostArchivComment.Placement := lrc_PurchaseComment.Placement;
    //                        lrc_PurchasePostArchivComment.Comment := lrc_PurchaseComment.Comment;
    //                        lrc_PurchasePostArchivComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_PurchaseComment2.Reset();
    //                        lrc_PurchaseComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_PurchaseComment2.SETRANGE("Entry Type", lrc_PurchaseComment2."Entry Type"::Line);
    //                        lrc_PurchaseComment2.SETRANGE("Entry No.", lrc_PurchaseComment."Entry No.");
    //                        lrc_PurchaseComment2.SETRANGE("Document Source", lrc_PurchaseComment2."Document Source"::Line);
    //                        lrc_PurchaseComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_PurchaseComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_PurchaseComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //                        lrc_PurchaseComment2.SETRANGE( Placement, lrc_PurchaseComment2.Placement::Line);
    //                        IF lrc_PurchaseComment2.FIND('-') THEN BEGIN
    //                           REPEAT
    //                             lrc_PurchasePostArchivComment.INIT();
    //                             lrc_PurchasePostArchivComment."Entry No." := lin_newEntryNo;
    //                             lrc_PurchasePostArchivComment."Entry Type" := lrc_PurchaseComment2."Entry Type";
    //                             lrc_PurchasePostArchivComment."Line No." := lrc_PurchaseComment2."Line No.";
    //                             lrc_PurchasePostArchivComment."Document Source" := lrc_PurchaseComment2."Document Source";
    //                             CASE vop_TargetDocumentType OF
    //                               0: lrc_PurchasePostArchivComment."Document Type" :=
    //                                   lrc_PurchasePostArchivComment."Document Type"::"Posted Shipment";
    //                               1: lrc_PurchasePostArchivComment."Document Type" :=
    //                                   lrc_PurchasePostArchivComment."Document Type"::"Posted Invoice";
    //                               2: lrc_PurchasePostArchivComment."Document Type" :=
    //                                   lrc_PurchasePostArchivComment."Document Type"::"Posted Credit Memo";
    //                               3: lrc_PurchasePostArchivComment."Document Type" :=
    //                                   lrc_PurchasePostArchivComment."Document Type"::"Posted Return Shipment";
    //                             END;
    //                             lrc_PurchasePostArchivComment."Document No." := vco_TargetDocumentNo;
    //                             lrc_PurchasePostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                             lrc_PurchasePostArchivComment.Placement := lrc_PurchaseComment2.Placement;
    //                             lrc_PurchasePostArchivComment.Comment := lrc_PurchaseComment2.Comment;
    //                             lrc_PurchasePostArchivComment.INSERT(TRUE);
    //                           UNTIL lrc_PurchaseComment2.NEXT() = 0;
    //                        END;

    //                 END;
    //               END;
    //             UNTIL lrc_PurchaseComment.NEXT() = 0;
    //           END;
    //         END;
    //     end;

    //     procedure PurchCopyCommentToPostComment(vop_SourceDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";vco_SourceDocumentNo: Code[20];vin_SourceDocumentLineNo: Integer;vop_TargetDocumentType: Option Shipment,Invoice,"Credit Memo","Return Shipment";vco_TargetDocumentNo: Code[20];vin_TargetDocumentLineNo: Integer)
    //     var
    //         lrc_PurchaseComment: Record "5110432";
    //         lrc_PurchaseComment2: Record "5110432";
    //         lrc_PurchaseCommentPrintDoc: Record "5110433";
    //         lrc_PurchasePostArchivComment: Record "5110434";
    //         lin_newEntryNo: Integer;
    //     begin
    //         // ----------------------------------------------------------------------------------------------
    //         //
    //         // ----------------------------------------------------------------------------------------------

    //         // alle Header und Footer kopieren
    //         lrc_PurchaseComment.Reset();
    //         lrc_PurchaseComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                           "Document Source","Document Type","Document No.","Document Line No.");
    //         lrc_PurchaseComment.SETRANGE("Entry Type", lrc_PurchaseComment."Entry Type"::Header);
    //         lrc_PurchaseComment.SETFILTER("Document Source",'%1|%2',lrc_PurchaseComment."Document Source"::Header,
    //                                                                 lrc_PurchaseComment."Document Source"::Line);
    //         lrc_PurchaseComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //         lrc_PurchaseComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //         ////lrc_PurchaseComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //         ////lrc_PurchaseComment.SETRANGE(Placement, lrc_PurchaseComment.Placement::Header);
    //         IF lrc_PurchaseComment.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_PurchaseCommentPrintDoc.Reset();
    //             lrc_PurchaseCommentPrintDoc.SETRANGE("Purch. Comment Entry No.", lrc_PurchaseComment."Entry No.");
    //             CASE vop_TargetDocumentType OF
    //               0: lrc_PurchaseCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                             lrc_PurchaseCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //               1: lrc_PurchaseCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                             lrc_PurchaseCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //               2: lrc_PurchaseCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                             lrc_PurchaseCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //               3: lrc_PurchaseCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                             lrc_PurchaseCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //             END;
    //             IF lrc_PurchaseCommentPrintDoc.FIND('-') THEN BEGIN
    //               IF lrc_PurchaseCommentPrintDoc.Print THEN BEGIN

    //                 lrc_PurchasePostArchivComment.Reset();
    //                 lrc_PurchasePostArchivComment.SETRANGE("Entry Type",lrc_PurchasePostArchivComment."Entry Type"::Header);
    //                 IF lrc_PurchasePostArchivComment.FIND('+') THEN
    //                   lin_newEntryNo := lrc_PurchasePostArchivComment."Entry No." + 1
    //                 ELSE
    //                   lin_newEntryNo := 1;

    //                 lrc_PurchasePostArchivComment.INIT();
    //                 lrc_PurchasePostArchivComment."Entry No." := lin_newEntryNo;
    //                 lrc_PurchasePostArchivComment."Entry Type" := lrc_PurchaseComment."Entry Type";
    //                 lrc_PurchasePostArchivComment."Line No." := lrc_PurchaseComment."Line No.";
    //                 lrc_PurchasePostArchivComment."Document Source" := lrc_PurchaseComment."Document Source";
    //                 CASE vop_TargetDocumentType OF
    //                   0: lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Shipment";
    //                   1: lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Invoice";
    //                   2: lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Credit Memo";
    //                   3: lrc_PurchasePostArchivComment."Document Type" :=
    //                              lrc_PurchasePostArchivComment."Document Type"::"Posted Return Shipment";
    //                 END;
    //                 lrc_PurchasePostArchivComment."Document No." := vco_TargetDocumentNo;
    //                 lrc_PurchasePostArchivComment."Document Line No." := lrc_PurchaseComment."Document Line No.";
    //                 lrc_PurchasePostArchivComment.Placement := lrc_PurchaseComment.Placement;
    //                 lrc_PurchasePostArchivComment.Comment := lrc_PurchaseComment.Comment;
    //                 lrc_PurchasePostArchivComment.INSERT(TRUE);

    //                 // dann die Zeilen dazu
    //                 lrc_PurchaseComment2.Reset();
    //                 lrc_PurchaseComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                                      "Document Source","Document Type","Document No.","Document Line No.");
    //                 lrc_PurchaseComment2.SETRANGE("Entry Type", lrc_PurchaseComment2."Entry Type"::Line);
    //                 lrc_PurchaseComment2.SETRANGE("Entry No.", lrc_PurchaseComment."Entry No.");
    //         ////        lrc_PurchaseComment2.SETRANGE("Document Source", lrc_PurchaseComment2."Document Source"::Header);
    //         ////        lrc_PurchaseComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //         ////        lrc_PurchaseComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //         ////        lrc_PurchaseComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //         ////        lrc_PurchaseComment2.SETRANGE(Placement, lrc_PurchaseComment2.Placement::Header);
    //                 IF lrc_PurchaseComment2.FIND('-') THEN BEGIN
    //                   REPEAT
    //                     lrc_PurchasePostArchivComment.INIT();
    //                     lrc_PurchasePostArchivComment."Entry No." := lin_newEntryNo;
    //                     lrc_PurchasePostArchivComment."Entry Type" := lrc_PurchaseComment2."Entry Type";
    //                     lrc_PurchasePostArchivComment."Line No." := lrc_PurchaseComment2."Line No.";
    //                     lrc_PurchasePostArchivComment."Document Source" := lrc_PurchaseComment2."Document Source";
    //                     CASE vop_TargetDocumentType OF
    //                       0: lrc_PurchasePostArchivComment."Document Type" :=
    //                                    lrc_PurchasePostArchivComment."Document Type"::"Posted Shipment";
    //                       1: lrc_PurchasePostArchivComment."Document Type" :=
    //                                    lrc_PurchasePostArchivComment."Document Type"::"Posted Invoice";
    //                       2: lrc_PurchasePostArchivComment."Document Type" :=
    //                                    lrc_PurchasePostArchivComment."Document Type"::"Posted Credit Memo";
    //                       3: lrc_PurchasePostArchivComment."Document Type" :=
    //                                    lrc_PurchasePostArchivComment."Document Type"::"Posted Return Shipment";
    //                     END;
    //                     lrc_PurchasePostArchivComment."Document No." := vco_TargetDocumentNo;
    //                     lrc_PurchasePostArchivComment."Document Line No." := lrc_PurchaseComment2."Document Line No.";
    //                     lrc_PurchasePostArchivComment.Placement := lrc_PurchaseComment2.Placement;
    //                     lrc_PurchasePostArchivComment.Comment := lrc_PurchaseComment2.Comment;
    //                     lrc_PurchasePostArchivComment.INSERT(TRUE);
    //                   UNTIL lrc_PurchaseComment2.NEXT() = 0;
    //                 END;
    //               END;
    //             END;
    //           UNTIL lrc_PurchaseComment.NEXT() = 0;
    //         END;
    //     end;

    //     procedure PurchTransferArchPostComment(lop_InsertType: Option PostedDocument,Archiv;lrc_PurchHeader: Record "38";lco_InvHeaderNo: Code[20];lco_CreditMemoHeaderNo: Code[20];lco_PurchRcptHeaderNo: Code[20];lco_ReturnShipHeaderNo: Code[20];lin_VersionNo: Integer)
    //     var
    //         lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment";
    //         lco_DocNo: Code[20];
    //         lrc_PurchPostArchivDisc: Record "5110388";
    //     begin
    //         // BET 002 FV400018.s
    //         CASE lop_InsertType OF

    //           lop_InsertType::PostedDocument:
    //             WITH lrc_PurchHeader DO BEGIN

    //               IF (Receive = Ship = Invoice = FALSE) THEN
    //                 EXIT;

    //               // Lieferung
    //               IF Receive THEN BEGIN
    //                 lop_DiscDocType := lop_DiscDocType::"Posted Shipment";
    //                 lco_DocNo := lco_PurchRcptHeaderNo;
    //               END;

    //               // Rücklieferung
    //               IF Ship THEN BEGIN
    //                 lop_DiscDocType := lop_DiscDocType::"Posted Return Shipment";
    //                 lco_DocNo := lco_ReturnShipHeaderNo;
    //               END;

    //               // Rechnung und Gutschrift
    //               IF Invoice THEN BEGIN
    //                 IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
    //                   lop_DiscDocType := lop_DiscDocType::"Posted Invoice";
    //                   lco_DocNo := lco_InvHeaderNo;
    //                 END ELSE BEGIN// Credit Memo
    //                   lop_DiscDocType := lop_DiscDocType::"Posted Credit Memo";
    //                   lco_DocNo := lco_CreditMemoHeaderNo;
    //                 END;
    //               END;
    //             END;

    //           lop_InsertType::Archiv:
    //             WITH lrc_PurchHeader DO BEGIN
    //               CASE "Document Type" OF
    //                 "Document Type"::Quote           : lop_DiscDocType := lop_DiscDocType::"Archive Quote";
    //                 "Document Type"::"Blanket Order" : lop_DiscDocType := lop_DiscDocType::"Archive Blanket Order";
    //                 "Document Type"::Order           : lop_DiscDocType := lop_DiscDocType::"Archive Order";
    //               END;
    //               lco_DocNo := "No.";
    //               gin_VersionNo := lin_VersionNo;
    //             END;
    //         END;

    //         PurchInsertCommentLines(lrc_PurchHeader,lop_DiscDocType,lco_DocNo);
    //         // BET 002 FV400018.s
    //     end;

    //     procedure PurchInsertCommentLines(lrc_PurchHeader: Record "38";lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment";lco_PostedDocNo: Code[20])
    //     var
    //         lrc_PurchComment: Record "5110432";
    //         lrc_PurchPostArchComm: Record "5110434";
    //         lin_EntryNo: Integer;
    //     begin
    //         // BET 002 FV400018.s
    //         lrc_PurchPostArchComm.Reset();
    //         IF lrc_PurchPostArchComm.FIND('+') THEN
    //           lin_EntryNo := lrc_PurchPostArchComm."Entry No.";

    //         lrc_PurchComment.Reset();
    //         lrc_PurchComment.SETCURRENTKEY("Document Source","Document Type","Document No.","Document Line No.");
    //         lrc_PurchComment.SETRANGE("Document Type",lrc_PurchHeader."Document Type");
    //         lrc_PurchComment.SETRANGE("Document No.",lrc_PurchHeader."No.");
    //         IF lrc_PurchComment.FIND('-') THEN BEGIN
    //           REPEAT
    //             WITH lrc_PurchPostArchComm DO BEGIN
    //               IF lrc_PurchComment."Entry Type" = lrc_PurchComment."Entry Type"::Header THEN
    //                  lin_EntryNo := lin_EntryNo + 1;
    //               INIT();
    //               TRANSFERFIELDS(lrc_PurchComment);
    //               "Entry No." := lin_EntryNo;
    //               "Entry Type" := lrc_PurchComment."Entry Type";
    //               "Line No." := lrc_PurchComment."Line No.";
    //               "Version No." := gin_VersionNo;
    //               IF NOT INSERT THEN
    //                 Modify();
    //             END;
    //           UNTIL lrc_PurchComment.NEXT() = 0;
    //         END;
    //         // BET 002 FV400018.e
    //     end;

    //     procedure PurchDocCopy(lin_FromDocType: Integer;lco_FromDocNo: Code[20];lrc_ToPurchHeader: Record "38";lin_VersionNo: Integer)
    //     var
    //         lrc_PurchPostArchComm: Record "5110434";
    //         lrc_PurchComment: Record "5110432";
    //         lrc_NewPurchComment: Record "5110432";
    //         Text001: Label 'Comments allready exists. If you continue, comments will de deleted.\Do you wish to continue?';
    //         Text002: Label 'Process stopped.';
    //         lin_EntryNo: Integer;
    //     begin
    //         // BET 003 FV400018.s
    //         gop_PurchDocType := lin_FromDocType;
    //         gin_VersionNo := lin_VersionNo;

    //         IF gop_PurchDocType IN [gop_PurchDocType::Quote,gop_PurchDocType::"Blanket Order",gop_PurchDocType::Order,
    //                                 gop_PurchDocType::Invoice,gop_PurchDocType::"Return Order",gop_PurchDocType::"Credit Memo"]
    //            THEN BEGIN // Bemerkungszeilen aus Belegen

    //           WITH lrc_PurchComment DO BEGIN
    //             CASE gop_PurchDocType OF
    //               gop_PurchDocType::Quote:            SETRANGE("Document Type","Document Type"::Quote);
    //               gop_PurchDocType::"Blanket Order":  SETRANGE("Document Type","Document Type"::"Blanket Order");
    //               gop_PurchDocType::Order:            SETRANGE("Document Type","Document Type"::Order);
    //               gop_PurchDocType::Invoice:          SETRANGE("Document Type","Document Type"::Invoice);
    //               gop_PurchDocType::"Return Order":   SETRANGE("Document Type","Document Type"::"Return Order");
    //               gop_PurchDocType::"Credit Memo":    SETRANGE("Document Type","Document Type"::"Credit Memo");
    //             END;
    //             SETRANGE("Document No.",lco_FromDocNo);
    //             IF FIND('-') THEN BEGIN

    //               //Lösche vorhandene Bemerkungen
    //               lrc_NewPurchComment.SETRANGE("Document Type",lrc_ToPurchHeader."Document Type");
    //               lrc_NewPurchComment.SETRANGE("Document No.",lrc_ToPurchHeader."No.");
    //               IF lrc_NewPurchComment.FIND('-') THEN
    //                 IF CONFIRM(Text001,TRUE) THEN
    //                   lrc_NewPurchComment.DELETEALL(TRUE)
    //                 ELSE
    //                   ERROR(Text002);

    //               lrc_NewPurchComment.Reset();
    //               IF lrc_NewPurchComment.FIND('+') THEN
    //                 lin_EntryNo := lrc_NewPurchComment."Entry No.";

    //               REPEAT
    //                 lrc_NewPurchComment.INIT();
    //                 lrc_NewPurchComment.TRANSFERFIELDS(lrc_PurchComment);
    //                 lrc_NewPurchComment."Document Type" := lrc_ToPurchHeader."Document Type";
    //                 lrc_NewPurchComment."Document No." := lrc_ToPurchHeader."No.";
    //                 IF lrc_PurchComment."Entry Type" = lrc_PurchComment."Entry Type"::Header THEN
    //                   lin_EntryNo := lin_EntryNo + 1;
    //                 lrc_NewPurchComment."Entry No." := lin_EntryNo;
    //                 IF lrc_NewPurchComment.INSERT THEN;
    //               UNTIL NEXT= 0;
    //             END;
    //           END;
    //         END ELSE BEGIN // Bemerkungszeilen aus gebuchten Belegen und Archiv Bemerkungen
    //           WITH lrc_PurchPostArchComm DO BEGIN
    //             CASE gop_PurchDocType OF
    //               gop_PurchDocType::"Posted Invoice":          SETRANGE("Document Type","Document Type"::"Posted Invoice");
    //               gop_PurchDocType::"Posted Credit Memo":      SETRANGE("Document Type","Document Type"::"Posted Credit Memo");
    //               gop_PurchDocType::"Posted Receipt":          SETRANGE("Document Type","Document Type"::"Posted Shipment");
    //               gop_PurchDocType::"Posted Return Shipment":  SETRANGE("Document Type","Document Type"::"Posted Return Shipment");

    //               gop_PurchDocType::"Arch. Quote":         SETRANGE("Document Type","Document Type"::"Archive Quote");
    //               gop_PurchDocType::"Arch. Order":         SETRANGE("Document Type","Document Type"::"Archive Order");
    //               gop_PurchDocType::"Arch. Blanket Order": SETRANGE("Document Type","Document Type"::"Archive Blanket Order");
    //             END;
    //             SETRANGE("Document No.",lco_FromDocNo);
    //             SETRANGE("Version No.",gin_VersionNo);
    //             IF FIND('-') THEN BEGIN

    //               //Lösche vorhandene Rabatte
    //               lrc_NewPurchComment.SETRANGE("Document Type",lrc_ToPurchHeader."Document Type");
    //               lrc_NewPurchComment.SETRANGE("Document No.",lrc_ToPurchHeader."No.");
    //               IF lrc_NewPurchComment.FIND('-') THEN
    //                 IF CONFIRM(Text001,TRUE) THEN
    //                   lrc_NewPurchComment.DELETEALL
    //                 ELSE
    //                   ERROR(Text002);

    //               lrc_NewPurchComment.Reset();
    //               IF lrc_NewPurchComment.FIND('+') THEN
    //                 lin_EntryNo := lrc_NewPurchComment."Entry No.";

    //               REPEAT
    //                 lrc_NewPurchComment.INIT();
    //                 lrc_NewPurchComment.TRANSFERFIELDS(lrc_PurchPostArchComm);
    //                 lrc_PurchComment."Document Type" := lrc_ToPurchHeader."Document Type";
    //                 lrc_NewPurchComment."Document No." := lrc_ToPurchHeader."No.";
    //                 IF lrc_PurchPostArchComm."Entry Type" = lrc_PurchPostArchComm."Entry Type"::Header THEN
    //                   lin_EntryNo := lin_EntryNo + 1;
    //                 lrc_NewPurchComment."Entry No." := lin_EntryNo;
    //                 IF lrc_NewPurchComment.INSERT THEN;
    //               UNTIL NEXT= 0;
    //             END;
    //           END;
    //         END;
    //         // BET 003 FV400018.s
    //     end;

    procedure PurchCommentTransferToDoc(prc_PurchHeader: Record "Purchase Header")
    begin
        // ------------------------------------------------------------------------------------
        // Übertragen der Bemerkungen in die Einkaufsbelege
        // ------------------------------------------------------------------------------------

        // Bereits vorhandene Daten löschen
        lrc_PurchComment.RESET();
        lrc_PurchComment.SETRANGE("Document Source", lrc_PurchComment."Document Source"::Header);
        lrc_PurchComment.SETRANGE("Document Type", prc_PurchHeader."Document Type");
        lrc_PurchComment.SETRANGE("Document No.", prc_PurchHeader."No.");
        IF lrc_PurchComment.FIND('-') THEN
            REPEAT
                // Drucktabelle löschen
                IF lrc_PurchComment."Entry Type" = lrc_PurchComment."Entry Type"::Header THEN BEGIN
                    lrc_PurchCommentPrintDoc.RESET();
                    lrc_PurchCommentPrintDoc.SETRANGE("Purch. Comment Entry No.", lrc_PurchComment."Entry No.");
                    IF lrc_PurchCommentPrintDoc.FIND('-') THEN
                        lrc_PurchCommentPrintDoc.DELETEALL();
                END;
                // Haupttabelle löschen
                lrc_PurchComment.DELETE(TRUE);
            UNTIL lrc_PurchComment.NEXT() = 0;

        // Daten für Buy-from Vendor No. holen
        lrc_CustVendComment.RESET();
        lrc_CustVendComment.SETRANGE("Document Source", lrc_CustVendComment."Document Source"::Header);
        lrc_CustVendComment.SETRANGE(Source, lrc_CustVendComment.Source::Vendor);
        lrc_CustVendComment.SETRANGE("Source No.", prc_PurchHeader."Buy-from Vendor No.");
        IF lrc_CustVendComment.FIND('-') THEN
            REPEAT
                // Bemerkungen übertragen und neue Nummer vergeben (durch das INSERT(TRUE))
                lrc_PurchComment.INIT();
                IF lrc_CustVendComment."Entry Type" = lrc_CustVendComment."Entry Type"::Header THEN
                    lrc_PurchComment."Entry No." := 0;
                lrc_PurchComment."Entry Type" := lrc_CustVendComment."Entry Type";
                lrc_PurchComment."Line No." := lrc_CustVendComment."Line No.";
                lrc_PurchComment.INSERT(TRUE);
                // Feldinformationen eintragen
                lrc_PurchComment."Document Source" := lrc_CustVendComment."Document Source";
                lrc_PurchComment."Document Type" := prc_PurchHeader."Document Type";
                lrc_PurchComment."Document No." := prc_PurchHeader."No.";
                lrc_PurchComment.Placement := lrc_CustVendComment.Placement;
                lrc_PurchComment.Comment := lrc_CustVendComment.Comment;
                lrc_PurchComment."No. of Documents" := lrc_CustVendComment."No. of Documents";
                lrc_PurchComment.MODIFY();
                // Drucktabelle übertragen
                IF lrc_CustVendComment."Entry Type" = lrc_CustVendComment."Entry Type"::Header THEN BEGIN
                    lrc_CustVendCommentPrintDoc.RESET();
                    lrc_CustVendCommentPrintDoc.SETRANGE("Cust./Vend. Comment Entry No.", lrc_CustVendComment."Entry No.");
                    lrc_CustVendCommentPrintDoc.SETRANGE(Print, TRUE);
                    IF lrc_CustVendCommentPrintDoc.FIND('-') THEN
                        REPEAT
                            lrc_PurchCommentPrintDoc.INIT();
                            lrc_PurchCommentPrintDoc."Purch. Comment Entry No." := lrc_PurchComment."Entry No.";
                            lrc_PurchCommentPrintDoc."Print Document Code" := lrc_CustVendCommentPrintDoc."Print Document Code";
                            lrc_PurchCommentPrintDoc."Detail Code" := lrc_CustVendCommentPrintDoc."Detail Code";
                            lrc_PurchCommentPrintDoc."Print Document Description" := lrc_CustVendCommentPrintDoc."Print Document Description";
                            lrc_PurchCommentPrintDoc."Sort Order" := lrc_CustVendCommentPrintDoc."Sort Order";
                            lrc_PurchCommentPrintDoc.Print := lrc_CustVendCommentPrintDoc.Print;
                            lrc_PurchCommentPrintDoc.Consignee := lrc_CustVendCommentPrintDoc.Consignee;
                            lrc_PurchCommentPrintDoc."Multiple Entry for" := lrc_CustVendCommentPrintDoc."Multiple Entry for";
                            lrc_PurchCommentPrintDoc."Posted Doc. Type" := lrc_CustVendCommentPrintDoc."Posted Doc. Type";
                            lrc_PurchCommentPrintDoc.INSERT();
                        UNTIL lrc_CustVendCommentPrintDoc.NEXT() = 0;
                END;
            UNTIL lrc_CustVendComment.NEXT() = 0;
    end;



    //     procedure TransferHeaderComment(vrc_TransferHeader: Record "5740")
    //     var
    //         lcu_Transfer: Codeunit "5110322";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_TransferComment: Record "5110430";
    //         lrc_TransferCommentPrintDoc: Record "5110431";
    //         lfm_TransferComment: Form "5088105";
    //         lco_ArrShippingAgent: array [1000] of Code[20];
    //         lco_ArrLocation: array [1000] of Code[20];
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Kopf
    //         // ------------------------------------------------------------------------------------

    //         vrc_TransferHeader.TESTFIELD("No.");

    //         // Alle Lagerorte in Array schreiben
    //         lcu_Transfer.FillArrLocation(vrc_TransferHeader."No.",lco_ArrLocation);
    //         // Alle Zusteller in Array schreiben
    //         lcu_Transfer.FillArrShippingAgent(vrc_TransferHeader."No.",lco_ArrShippingAgent);

    //         lrc_TransferComment.FILTERGROUP(2);
    //         lrc_TransferComment.SETRANGE("Entry Type",lrc_TransferComment."Entry Type"::Header);
    //         lrc_TransferComment.SETRANGE("Document Source",lrc_TransferComment."Document Source"::Header);
    //         lrc_TransferComment.SETRANGE("Document No.",vrc_TransferHeader."No.");
    //         lrc_TransferComment.SETRANGE("Document Line No.",0);
    //         lrc_TransferComment.FILTERGROUP(0);
    //         IF lrc_TransferComment.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Zuordnung Druckbelege löschen falls nicht zugeordnet
    //             lrc_TransferCommentPrintDoc.Reset();
    //             lrc_TransferCommentPrintDoc.SETRANGE("Transfer Comment Entry No.",lrc_TransferComment."Entry No.");
    //             lrc_TransferCommentPrintDoc.SETRANGE(Print,FALSE);
    //             lrc_TransferCommentPrintDoc.DELETEALL();

    //             lrc_PrintDocument.Reset();
    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Transfer);
    //             lrc_PrintDocument.SETRANGE("Document Type",lrc_PrintDocument."Document Type"::"8");
    //             IF lrc_PrintDocument.FIND('-') THEN
    //               REPEAT

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Keine Mehrfachgenerierung
    //                 // ----------------------------------------------------------------------------------------------
    //                 CASE lrc_PrintDocument."Multiple Entry for" OF
    //                   lrc_PrintDocument."Multiple Entry for"::" ":
    //                     BEGIN
    //                       lrc_TransferCommentPrintDoc.Reset();
    //                       lrc_TransferCommentPrintDoc.SETRANGE("Transfer Comment Entry No.",lrc_TransferComment."Entry No.");
    //                       lrc_TransferCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                       lrc_TransferCommentPrintDoc.SETRANGE("Detail Code",'');
    //                       IF NOT lrc_TransferCommentPrintDoc.FIND('-') THEN BEGIN
    //                         lrc_TransferCommentPrintDoc.Reset();
    //                         lrc_TransferCommentPrintDoc.INIT();
    //                         lrc_TransferCommentPrintDoc."Transfer Comment Entry No." := lrc_TransferComment."Entry No.";
    //                         lrc_TransferCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_TransferCommentPrintDoc."Detail Code" := '';
    //                         lrc_TransferCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_TransferCommentPrintDoc.Print := FALSE;
    //                         lrc_TransferCommentPrintDoc.INSERT(TRUE);
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::Location:
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_TransferCommentPrintDoc.Reset();
    //                           lrc_TransferCommentPrintDoc.SETRANGE("Transfer Comment Entry No.",lrc_TransferComment."Entry No.");
    //                           lrc_TransferCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_TransferCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                           IF NOT lrc_TransferCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_TransferCommentPrintDoc.Reset();
    //                             lrc_TransferCommentPrintDoc.INIT();
    //                             lrc_TransferCommentPrintDoc."Transfer Comment Entry No." := lrc_TransferComment."Entry No.";
    //                             lrc_TransferCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_TransferCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                             lrc_TransferCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_TransferCommentPrintDoc.Print := FALSE;
    //                             lrc_TransferCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                      END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Physisches Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Location Group": ERROR('Mehrfachgenerierung nicht zulässig!');

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Abgangsregion
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Departure Region": ERROR('Mehrfachgenerierung nicht zulässig!');

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Zusteller
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                     BEGIN

    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_TransferCommentPrintDoc.Reset();
    //                           lrc_TransferCommentPrintDoc.SETRANGE("Transfer Comment Entry No.",lrc_TransferComment."Entry No.");
    //                           lrc_TransferCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_TransferCommentPrintDoc.SETRANGE("Detail Code",lco_ArrShippingAgent[lin_ArrZähler]);
    //                           IF NOT lrc_TransferCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_TransferCommentPrintDoc.Reset();
    //                             lrc_TransferCommentPrintDoc.INIT();
    //                             lrc_TransferCommentPrintDoc."Transfer Comment Entry No." := lrc_TransferComment."Entry No.";
    //                             lrc_TransferCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_TransferCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                             lrc_TransferCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_TransferCommentPrintDoc.Print := FALSE;
    //                             lrc_TransferCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;

    //                     END;
    //                 END;

    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //           UNTIL lrc_TransferComment.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_TransferComment.SetGlobals(vrc_TransferHeader."No.",0);
    //         lfm_TransferComment.SETTABLEVIEW(lrc_TransferComment);
    //         lfm_TransferComment.RUNMODAL;
    //     end;

    //     procedure TransferShowComment(vrc_TransferComment: Record "5110430")
    //     var
    //         lrc_TransComment: Record "5110430";
    //         lrc_TransCommentLine: Record "5110430";
    //         lfm_TransCommentCard: Form "5088106";
    //         Text01: Label 'Bitte wählen Sie einen gültigen Eintrag aus!';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungskarte Kopf
    //         // ------------------------------------------------------------------------------------

    //         IF vrc_TransferComment."Entry No." <= 0 THEN
    //           // Bitte wählen Sie einen gültigen Eintrag aus!
    //           ERROR(Text01);

    //         lrc_TransComment.FILTERGROUP(2);
    //         lrc_TransComment.SETRANGE("Entry No.",vrc_TransferComment."Entry No.");
    //         lrc_TransComment.SETRANGE("Entry Type",vrc_TransferComment."Entry Type");
    //         lrc_TransComment.SETRANGE("Line No.",vrc_TransferComment."Line No.");
    //         lrc_TransComment.FILTERGROUP(0);

    //         lfm_TransCommentCard.SETTABLEVIEW(lrc_TransComment);
    //         lfm_TransCommentCard.RUNMODAL;

    //         // Erste Bemerkungszeile in Kopfsatz setzen
    //         TransferSetCommentFirstLine(vrc_TransferComment."Entry No.");
    //     end;

    //     procedure TransferNewComment(vco_DocNo: Code[20];vin_DocLineNo: Integer)
    //     var
    //         lcu_Transfer: Codeunit "5110322";
    //         lrc_TransHeader: Record "5740";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_TransComment: Record "5110430";
    //         lrc_TransCommentPrintDoc: Record "5110431";
    //         lfm_TransCommentCard: Form "5088106";
    //         lco_ArrShippingAgent: array [1000] of Code[20];
    //         lco_ArrLocation: array [1000] of Code[20];
    //         "lin_ArrZähler": Integer;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung einer neuen Bemerkung Kopf / Zeile
    //         // ------------------------------------------------------------------------------------

    //         lrc_TransHeader.GET(vco_DocNo);

    //         // Alle Lagerorte in Array schreiben
    //         lcu_Transfer.FillArrLocation(vco_DocNo,lco_ArrLocation);
    //         // Alle Zusteller in Array schreiben
    //         lcu_Transfer.FillArrShippingAgent(vco_DocNo,lco_ArrShippingAgent);


    //         // Kopfsatz Bemerkung anlegen
    //         lrc_TransComment.Reset();
    //         lrc_TransComment.INIT();
    //         lrc_TransComment."Entry No." := 0;
    //         lrc_TransComment."Entry Type" := lrc_TransComment."Entry Type"::Header;
    //         lrc_TransComment."Line No." := 0;

    //         IF vin_DocLineNo = 0 THEN
    //           lrc_TransComment."Document Source" := lrc_TransComment."Document Source"::Header
    //         ELSE
    //           lrc_TransComment."Document Source" := lrc_TransComment."Document Source"::Line;
    //         lrc_TransComment."Document No." := lrc_TransHeader."No.";
    //         lrc_TransComment."Document Line No." := vin_DocLineNo;

    //         IF vin_DocLineNo = 0 THEN
    //           lrc_TransComment.Placement := lrc_TransComment.Placement::Footer
    //         ELSE
    //           lrc_TransComment.Placement := lrc_TransComment.Placement::Line;
    //         lrc_TransComment.Comment := '';
    //         lrc_TransComment.INSERT(TRUE);

    //         // Filter mit Filtergruppe setzen
    //         lrc_TransComment.FILTERGROUP(2);
    //         lrc_TransComment.SETRANGE("Entry No.",lrc_TransComment."Entry No.");
    //         lrc_TransComment.SETRANGE("Entry Type",lrc_TransComment."Entry Type");
    //         lrc_TransComment.SETRANGE("Line No.",lrc_TransComment."Line No.");
    //         lrc_TransComment.FILTERGROUP(0);


    //         // Druckbelege Laden für die Bemerkungen erfaßt werden können
    //         lrc_PrintDocument.Reset();
    //         lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Transfer);
    //         //lrc_PrintDocument.SETRANGE("Document Type",lrc_PrintDocument."Document Type"::"8");
    //         IF lrc_PrintDocument.FIND('-') THEN
    //           REPEAT

    //             CASE lrc_PrintDocument."Multiple Entry for" OF

    //               // ----------------------------------------------------------------------------------------------
    //               // Keine Mehrfachgenerierung
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::" ":
    //                 BEGIN
    //                   lrc_TransCommentPrintDoc.Reset();
    //                   lrc_TransCommentPrintDoc.INIT();
    //                   lrc_TransCommentPrintDoc."Transfer Comment Entry No." := lrc_TransComment."Entry No.";
    //                   lrc_TransCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                   lrc_TransCommentPrintDoc."Detail Code" := '';
    //                   lrc_TransCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                   lrc_TransCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_TransCommentPrintDoc.Print := FALSE;
    //                   lrc_TransCommentPrintDoc.INSERT(TRUE);
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Lager
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::Location:
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                       lrc_TransCommentPrintDoc.Reset();
    //                       lrc_TransCommentPrintDoc.SETRANGE("Transfer Comment Entry No.",lrc_TransComment."Entry No.");
    //                       lrc_TransCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                       lrc_TransCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                       IF NOT lrc_TransCommentPrintDoc.FIND('-') THEN BEGIN
    //                         lrc_TransCommentPrintDoc.Reset();
    //                         lrc_TransCommentPrintDoc.INIT();
    //                         lrc_TransCommentPrintDoc."Transfer Comment Entry No." := lrc_TransComment."Entry No.";
    //                         lrc_TransCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_TransCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                         lrc_TransCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_TransCommentPrintDoc.Print := FALSE;
    //                         lrc_TransCommentPrintDoc.INSERT(TRUE);
    //                       END;
    //                      END;
    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                    END;
    //                 END;


    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Physisches Lager
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Location Group": ERROR('Mehrfachgenerierung nicht zulässig!');

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Abgangsregion
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Departure Region":  ERROR('Mehrfachgenerierung nicht zulässig!');

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Zusteller
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                       lrc_TransCommentPrintDoc.Reset();
    //                       lrc_TransCommentPrintDoc.SETRANGE("Transfer Comment Entry No.",lrc_TransComment."Entry No.");
    //                       lrc_TransCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                       lrc_TransCommentPrintDoc.SETRANGE("Detail Code",lco_ArrShippingAgent[lin_ArrZähler]);
    //                       IF NOT lrc_TransCommentPrintDoc.FIND('-') THEN BEGIN
    //                         lrc_TransCommentPrintDoc.Reset();
    //                         lrc_TransCommentPrintDoc.INIT();
    //                         lrc_TransCommentPrintDoc."Transfer Comment Entry No." := lrc_TransComment."Entry No.";
    //                         lrc_TransCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_TransCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                         lrc_TransCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_TransCommentPrintDoc.Print := FALSE;
    //                         lrc_TransCommentPrintDoc.INSERT(TRUE);
    //                       END;
    //                     END;
    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;
    //               END;

    //           UNTIL lrc_PrintDocument.NEXT() = 0;

    //         COMMIT;
    //         lfm_TransCommentCard.SETTABLEVIEW(lrc_TransComment);
    //         lfm_TransCommentCard.RUNMODAL;

    //         // Erste Zeile in Kopfsatz generieren
    //         TransferSetCommentFirstLine(lrc_TransComment."Entry No.");
    //     end;

    //     procedure TransferSetCommentFirstLine(vin_EntryNo: Integer)
    //     var
    //         lrc_TransCommentHeader: Record "5110430";
    //         lrc_TransCommentLine: Record "5110430";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der ersten Bemerkungszeile in den Kopfsatz Bemerkungen
    //         // ------------------------------------------------------------------------------------------------

    //         // Kommentar aus erster Zeile in Kopfsatz setzen
    //         lrc_TransCommentHeader.Reset();
    //         //RS GET funktioniert nicht
    //         //lrc_TransCommentHeader.GET(vin_EntryNo,lrc_TransCommentHeader."Entry Type"::Header,0);
    //         lrc_TransCommentHeader.SETRANGE("Entry No.", vin_EntryNo);
    //         lrc_TransCommentHeader.SETRANGE("Entry Type", lrc_TransCommentHeader."Entry Type"::Header);
    //         lrc_TransCommentHeader.FINDFIRST;

    //         lrc_TransCommentLine.SETRANGE("Entry No.",lrc_TransCommentHeader."Entry No.");
    //         lrc_TransCommentLine.SETRANGE("Entry Type",lrc_TransCommentLine."Entry Type"::Line);
    //         IF lrc_TransCommentLine.FIND('-') THEN BEGIN
    //           lrc_TransCommentHeader.Comment := lrc_TransCommentLine.Comment;
    //           lrc_TransCommentHeader.Modify();
    //         END;
    //     end;

    //     procedure TransferCommentOnAllDoc(vin_EntryNo: Integer;vop_Typ: Option "0","1","2","3","4","5")
    //     var
    //         lrc_TransCommentPrintDoc: Record "5110431";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum setzen ShowText in allen Druckbelegen Kopf
    //         // ------------------------------------------------------------------------------------

    //         // vop_Typ = 0 Alle

    //         CASE vop_Typ OF
    //           0:
    //             BEGIN
    //               lrc_TransCommentPrintDoc.SETRANGE("Transfer Comment Entry No.",vin_EntryNo);
    //               lrc_TransCommentPrintDoc.MODIFYALL(Print,TRUE);
    //             END;
    //         END;
    //     end;

    //     procedure TransferLineComment(vrc_TransLine: Record "5741")
    //     var
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_TransComment: Record "5110430";
    //         lrc_TransCommentPrintDoc: Record "5110431";
    //         lfm_TransComment: Form "5088105";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Zeile
    //         // ------------------------------------------------------------------------------------

    //         vrc_TransLine.TESTFIELD("Document No.");
    //         vrc_TransLine.TESTFIELD("Line No.");

    //         lrc_TransComment.FILTERGROUP(2);
    //         lrc_TransComment.SETRANGE("Entry Type",lrc_TransComment."Entry Type"::Header);
    //         lrc_TransComment.SETRANGE("Document Source",lrc_TransComment."Document Source"::Line);
    //         lrc_TransComment.SETRANGE("Document No.",vrc_TransLine."Document No.");
    //         lrc_TransComment.SETRANGE("Document Line No.",vrc_TransLine."Line No.");
    //         lrc_TransComment.FILTERGROUP(0);
    //         IF lrc_TransComment.FIND('-') THEN BEGIN
    //           REPEAT
    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Transfer);
    //             lrc_PrintDocument.SETRANGE("Document Type",lrc_PrintDocument."Document Type"::"8");
    //             IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //               REPEAT

    //                 lrc_TransCommentPrintDoc.SETRANGE("Transfer Comment Entry No.",lrc_TransComment."Entry No.");
    //                 lrc_TransCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                 IF NOT lrc_TransCommentPrintDoc.FIND('-') THEN BEGIN
    //                   lrc_TransCommentPrintDoc.Reset();
    //                   lrc_TransCommentPrintDoc.INIT();
    //                   lrc_TransCommentPrintDoc."Transfer Comment Entry No." := lrc_TransComment."Entry No.";
    //                   lrc_TransCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                   lrc_TransCommentPrintDoc."Detail Code" := '';
    //                   lrc_TransCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_TransCommentPrintDoc.Print := FALSE;
    //                   lrc_TransCommentPrintDoc.INSERT(TRUE);
    //                 END;
    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //             END;
    //           UNTIL lrc_TransComment.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_TransComment.SetGlobals(vrc_TransLine."Document No.",vrc_TransLine."Line No.");
    //         lfm_TransComment.SETTABLEVIEW(lrc_TransComment);
    //         lfm_TransComment.RUNMODAL;
    //     end;

    //     procedure "-- CUSTOMER / VENDOR --"()
    //     begin
    //     end;

    //     procedure CustVendComment(vop_CustVend: Option Customer,Vendor,"Customer Chain";vco_CustVendNo: Code[20];vco_CustVendSubNo: Code[10])
    //     var
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_CustVendComment: Record "5110425";
    //         lrc_CustVendCommentPrintDoc: Record "5110426";
    //         lfm_CustVendComment: Form "5110515";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Kopf
    //         // ------------------------------------------------------------------------------------

    //         lrc_CustVendComment.FILTERGROUP(2);
    //         lrc_CustVendComment.SETRANGE("Entry Type",lrc_CustVendComment."Entry Type"::Header);
    //         lrc_CustVendComment.SETRANGE("Document Source",lrc_CustVendComment."Document Source"::Header);
    //         // BET 005 KHH50223.s
    //         CASE vop_CustVend OF
    //           vop_CustVend::Customer:
    //             lrc_CustVendComment.SETRANGE(Source,lrc_CustVendComment.Source::Customer);
    //           vop_CustVend::Vendor:
    //             lrc_CustVendComment.SETRANGE(Source,lrc_CustVendComment.Source::Vendor);
    //           vop_CustVend::"Customer Chain":
    //             lrc_CustVendComment.SETRANGE(Source,lrc_CustVendComment.Source::"Customer Chain");
    //         END;
    //         // BET 005 KHH50223.e

    //         lrc_CustVendComment.SETRANGE("Source No.",vco_CustVendNo);
    //         lrc_CustVendComment.SETRANGE("Source Sub. No.",vco_CustVendSubNo);
    //         lrc_CustVendComment.FILTERGROUP(0);
    //         IF lrc_CustVendComment.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Zuordnung Druckbelege löschen falls nicht zugeordnet
    //             lrc_CustVendCommentPrintDoc.Reset();
    //             lrc_CustVendCommentPrintDoc.SETRANGE("Cust./Vend. Comment Entry No.",lrc_CustVendComment."Entry No.");
    //             lrc_CustVendCommentPrintDoc.SETRANGE(Print,FALSE);
    //             lrc_CustVendCommentPrintDoc.DELETEALL();

    //             // Druckbelege lesen
    //             lrc_PrintDocument.Reset();
    //             lrc_PrintDocument.SETRANGE("Not Activ",FALSE);
    //             // BET 005 KHH50223.s
    //             CASE vop_CustVend OF
    //               vop_CustVend::Customer, vop_CustVend::"Customer Chain":
    //                 lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Sales);
    //               vop_CustVend::Vendor:
    //                 lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Purchase);
    //             END;
    //             // BET 005 KHH50223.e
    //             IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_CustVendCommentPrintDoc.Reset();
    //                 lrc_CustVendCommentPrintDoc.SETRANGE("Cust./Vend. Comment Entry No.",lrc_CustVendComment."Entry No.");
    //                 lrc_CustVendCommentPrintDoc.SETRANGE(Source,lrc_PrintDocument."Document Source");
    //                 lrc_CustVendCommentPrintDoc.SETRANGE("Document Type",lrc_PrintDocument."Document Type");
    //                 lrc_CustVendCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                 lrc_CustVendCommentPrintDoc.SETRANGE("Detail Code",'');
    //                 IF NOT lrc_CustVendCommentPrintDoc.FIND('-') THEN BEGIN
    //                   lrc_CustVendCommentPrintDoc.Reset();
    //                   lrc_CustVendCommentPrintDoc.INIT();
    //                   lrc_CustVendCommentPrintDoc."Cust./Vend. Comment Entry No." := lrc_CustVendComment."Entry No.";
    //                   lrc_CustVendCommentPrintDoc.Source := lrc_PrintDocument."Document Source";
    //                   lrc_CustVendCommentPrintDoc."Document Type" := lrc_PrintDocument."Document Type";
    //                   lrc_CustVendCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                   lrc_CustVendCommentPrintDoc."Detail Code" := '';
    //                   lrc_CustVendCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_CustVendCommentPrintDoc.Consignee := lrc_PrintDocument.Consignee;
    //                   lrc_CustVendCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                   lrc_CustVendCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_CustVendCommentPrintDoc.Print := FALSE;
    //                   lrc_CustVendCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                   lrc_CustVendCommentPrintDoc.INSERT(TRUE);
    //                 END;
    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //             END;
    //           UNTIL lrc_CustVendComment.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_CustVendComment.SetGlobals(vop_CustVend,vco_CustVendNo);
    //         lfm_CustVendComment.SETTABLEVIEW(lrc_CustVendComment);
    //         lfm_CustVendComment.RUNMODAL;
    //     end;

    //     procedure CustVendShowComment(vrc_CustVendComment: Record "5110425")
    //     var
    //         lrc_CustVendComment: Record "5110425";
    //         vrc_CustVendCommentLine: Record "5110425";
    //         lfm_CustVendCommentCard: Form "5110516";
    //         Text01: Label 'Bitte wählen Sie einen gültigen Eintrag aus!';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungskarte Kopf
    //         // ------------------------------------------------------------------------------------

    //         IF vrc_CustVendComment."Entry No." <= 0 THEN
    //           // Bitte wählen Sie einen gültigen Eintrag aus!
    //           ERROR(Text01);

    //         lrc_CustVendComment.FILTERGROUP(2);
    //         lrc_CustVendComment.SETRANGE("Entry No.",vrc_CustVendComment."Entry No.");
    //         lrc_CustVendComment.SETRANGE("Entry Type",vrc_CustVendComment."Entry Type");
    //         lrc_CustVendComment.SETRANGE("Line No.",vrc_CustVendComment."Line No.");
    //         lrc_CustVendComment.FILTERGROUP(0);

    //         lfm_CustVendCommentCard.SETTABLEVIEW(lrc_CustVendComment);
    //         lfm_CustVendCommentCard.RUNMODAL;

    //         // Erste Bemerkungszeile in Kopfsatz setzen
    //         CustVendSetCommentFirstLine(vrc_CustVendComment."Entry No.");
    //     end;

    //     procedure CustVendNewComment(vop_CustVend: Option Customer,Vendor,"Customer Chain";vco_CustVendNo: Code[20])
    //     var
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_CustVendComment: Record "5110425";
    //         lrc_CustVendCommentPrintDoc: Record "5110426";
    //         lfm_CustVendCommentCard: Form "5110516";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung einer neuen Bemerkung Kopf
    //         // ------------------------------------------------------------------------------------

    //         // Kopfsatz Bemerkung anlegen
    //         lrc_CustVendComment.Reset();
    //         lrc_CustVendComment.INIT();
    //         lrc_CustVendComment."Entry No." := 0;
    //         lrc_CustVendComment."Entry Type" := lrc_CustVendComment."Entry Type"::Header;
    //         lrc_CustVendComment."Line No." := 0;
    //         lrc_CustVendComment."Document Source" := lrc_CustVendComment."Document Source"::Header;
    //         // BET 005 KHH50223.s
    //         CASE vop_CustVend OF
    //           vop_CustVend::Customer: lrc_CustVendComment.Source := lrc_CustVendComment.Source::Customer;
    //           vop_CustVend::Vendor: lrc_CustVendComment.Source := lrc_CustVendComment.Source::Vendor;
    //           vop_CustVend::"Customer Chain": lrc_CustVendComment.Source := lrc_CustVendComment.Source::"Customer Chain";
    //         END;
    //         // BET 005 KHH50223.e
    //         lrc_CustVendComment."Source No." := vco_CustVendNo;
    //         lrc_CustVendComment."Source Sub. No." := '';
    //         lrc_CustVendComment.Placement := lrc_CustVendComment.Placement::Footer;
    //         lrc_CustVendComment.Comment := '';
    //         lrc_CustVendComment.INSERT(TRUE);

    //         // Filter mit Filtergruppe setzen
    //         lrc_CustVendComment.FILTERGROUP(2);
    //         lrc_CustVendComment.SETRANGE("Entry No.",lrc_CustVendComment."Entry No.");
    //         lrc_CustVendComment.SETRANGE("Entry Type",lrc_CustVendComment."Entry Type");
    //         lrc_CustVendComment.SETRANGE("Line No.",lrc_CustVendComment."Line No.");
    //         lrc_CustVendComment.FILTERGROUP(0);

    //         // Druckbelege Laden für die Bemerkungen erfaßt werden können
    //         lrc_PrintDocument.Reset();
    //         lrc_PrintDocument.SETRANGE("Not Activ",FALSE);
    //         // BET 005 KHH50223.s
    //         CASE vop_CustVend OF
    //           vop_CustVend::Customer, vop_CustVend::"Customer Chain":
    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Sales);
    //           vop_CustVend::Vendor:
    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Purchase);
    //         END;
    //         // BET 005 KHH50223.e
    //         IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //           REPEAT
    //             // ----------------------------------------------------------------------------------------------
    //             // Keine Mehrfachgenerierung
    //             // ----------------------------------------------------------------------------------------------
    //             lrc_CustVendCommentPrintDoc.Reset();
    //             lrc_CustVendCommentPrintDoc.INIT();
    //             lrc_CustVendCommentPrintDoc."Cust./Vend. Comment Entry No." := lrc_CustVendComment."Entry No.";
    //             lrc_CustVendCommentPrintDoc.Source := lrc_PrintDocument."Document Source";
    //             lrc_CustVendCommentPrintDoc."Document Type" := lrc_PrintDocument."Document Type";
    //             lrc_CustVendCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //             lrc_CustVendCommentPrintDoc."Detail Code" := '';
    //             lrc_CustVendCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //             lrc_CustVendCommentPrintDoc.Consignee := lrc_PrintDocument.Consignee;
    //             lrc_CustVendCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //             lrc_CustVendCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //             lrc_CustVendCommentPrintDoc.Print := FALSE;
    //             lrc_CustVendCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //             lrc_CustVendCommentPrintDoc.INSERT(TRUE);
    //           UNTIL lrc_PrintDocument.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_CustVendCommentCard.SETTABLEVIEW(lrc_CustVendComment);
    //         lfm_CustVendCommentCard.RUNMODAL;

    //         // Erste Zeile in Kopfsatz generieren
    //         CustVendSetCommentFirstLine(lrc_CustVendComment."Entry No.");
    //     end;

    //     procedure CustVendSetCommentFirstLine(vin_EntryNo: Integer)
    //     var
    //         lrc_CustVendCommentHeader: Record "5110425";
    //         lrc_CustVendCommentLine: Record "5110425";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der ersten Bemerkungszeile in den Kopfsatz Bemerkungen
    //         // ------------------------------------------------------------------------------------------------

    //         // Kommentar aus erster Zeile in Kopfsatz setzen
    //         lrc_CustVendCommentHeader.Reset();
    //         lrc_CustVendCommentHeader.GET(vin_EntryNo,lrc_CustVendCommentHeader."Entry Type"::Header,0);

    //         lrc_CustVendCommentLine.SETRANGE("Entry No.",lrc_CustVendCommentHeader."Entry No.");
    //         lrc_CustVendCommentLine.SETRANGE("Entry Type",lrc_CustVendCommentLine."Entry Type"::Line);
    //         IF lrc_CustVendCommentLine.FIND('-') THEN BEGIN
    //           lrc_CustVendCommentHeader.Comment := lrc_CustVendCommentLine.Comment;
    //           lrc_CustVendCommentHeader.Modify();
    //         END ELSE BEGIN
    //           lrc_CustVendCommentHeader.DELETE(TRUE);
    //         END;
    //     end;

    //     procedure CustVendCommentOnAllDoc(vin_EntryNo: Integer)
    //     var
    //         lrc_CustVendCommentPrintDoc: Record "5110426";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum setzen ShowText in allen Druckbelegen Kopf
    //         // ------------------------------------------------------------------------------------

    //         lrc_CustVendCommentPrintDoc.SETRANGE("Cust./Vend. Comment Entry No.",vin_EntryNo);
    //         lrc_CustVendCommentPrintDoc.MODIFYALL(Print,TRUE);
    //     end;

    //     procedure "-- FREIGHT ORDER --"()
    //     begin
    //     end;

    //     procedure FreightHeaderComment(vrc_FreightOrderHeader: Record "5110439")
    //     var
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_SalesComment: Record "5087930";
    //         lrc_SalesCommentPrintDoc: Record "5087931";
    //         lrc_Location: Record "14";
    //         lfm_FreightComment: Form "5110520";
    //         "lin_ArrZähler": Integer;
    //         lco_ArrShippingAgent: array [100] of Code[20];
    //         lco_ArrPhysLocation: array [100] of Code[20];
    //         lco_ArrLocation: array [100] of Code[20];
    //         lco_ArrDepartRegion: array [100] of Code[20];
    //         lbn_Check: Boolean;
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Kopf
    //         // ------------------------------------------------------------------------------------

    //         vrc_FreightOrderHeader.TESTFIELD("No.");

    //         // Alle Lagerorte in Array schreiben
    //         ////lcu_Sales.FillArrLocation(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrLocation);
    //         IF vrc_FreightOrderHeader."Departure Type" = vrc_FreightOrderHeader."Departure Type"::Location THEN
    //           lco_ArrLocation[1] := vrc_FreightOrderHeader."Departure Code";
    //         // Alle Lagerortgruppen in Array schreiben
    //         ////lcu_Sales.FillArrLocationGroup(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrPhysLocation);
    //         IF lrc_Location.GET(lco_ArrLocation[1]) THEN
    //           lco_ArrPhysLocation[1] := lrc_Location."Location Group Code";
    //         // Alle Zusteller in Array schreiben
    //         ////lcu_Sales.FillArrShippingAgent(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrShippingAgent);
    //         lco_ArrShippingAgent[1] := vrc_FreightOrderHeader."Shipping Agent Code";
    //         // Alle Abgangsregionen in Array schreiben
    //         ////lcu_Sales.FillArrDepartureRegion(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrDepartRegion);
    //         lco_ArrDepartRegion[1] := vrc_FreightOrderHeader."Departure Region Code";

    //         lrc_SalesComment.FILTERGROUP(2);
    //         lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //         lrc_SalesComment.SETRANGE("Document Source",lrc_SalesComment."Document Source"::Header);
    //         ////lrc_SalesComment.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //         lrc_SalesComment.SETRANGE("Document No.",vrc_FreightOrderHeader."No.");
    //         lrc_SalesComment.SETRANGE("Document Line No.",0);
    //         lrc_SalesComment.FILTERGROUP(0);
    //         IF lrc_SalesComment.FIND('-') THEN BEGIN
    //           REPEAT

    //             // Zuordnung Druckbelege löschen falls nicht zugeordnet
    //             lrc_SalesCommentPrintDoc.Reset();
    //             lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_SalesComment."Entry No.");
    //             lrc_SalesCommentPrintDoc.SETRANGE(Print,FALSE);
    //             lrc_SalesCommentPrintDoc.DELETEALL();


    //             lrc_PrintDocument.Reset();
    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::"16");
    //         //    lrc_PrintDocument.SETRANGE("Document Type",vrc_SalesHeader."Document Type");
    //             IF lrc_PrintDocument.FIND('-') THEN
    //               REPEAT

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Keine Mehrfachgenerierung
    //                 // ----------------------------------------------------------------------------------------------
    //                 CASE lrc_PrintDocument."Multiple Entry for" OF
    //                   lrc_PrintDocument."Multiple Entry for"::" ":
    //                     BEGIN
    //                       lrc_SalesCommentPrintDoc.Reset();
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_SalesComment."Entry No.");
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",'');
    //                       IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                         lrc_SalesCommentPrintDoc.Reset();
    //                         lrc_SalesCommentPrintDoc.INIT();
    //                         lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_SalesComment."Entry No.";
    //                         lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_SalesCommentPrintDoc."Detail Code" := '';
    //                         lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_SalesCommentPrintDoc.Print := FALSE;
    //                         lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                        END;
    //                      END;
    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::Location:
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                           IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;

    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Lagerortgruppe
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Location Group":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrPhysLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrPhysLocation[lin_ArrZähler]);
    //                           IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrPhysLocation[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Abgangsregion
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Departure Region":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrDepartRegion[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrDepartRegion[lin_ArrZähler]);
    //                           IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrDepartRegion[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Zusteller
    //                 // ----------------------------------------------------------------------------------------------
    //                   lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                     BEGIN
    //                       lin_ArrZähler := 1;
    //                       WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_SalesComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrShippingAgent[lin_ArrZähler]);
    //                           IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_SalesComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                         lin_ArrZähler := lin_ArrZähler + 1;
    //                       END;
    //                     END;

    //                 END;

    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //           UNTIL lrc_SalesComment.NEXT() = 0;
    //         END;

    //         COMMIT;

    //         lfm_FreightComment.SetGlobals(0,vrc_FreightOrderHeader."No.",0);
    //         lfm_FreightComment.SETTABLEVIEW(lrc_SalesComment);
    //         lfm_FreightComment.RUNMODAL;
    //     end;

    //     procedure FreightShowComment(vrc_FreightComment: Record "5087930")
    //     var
    //         lrc_CommentSetup: Record "5087938";
    //         lrc_FreightComment: Record "5087930";
    //         lrc_SalesCommentLine: Record "5087930";
    //         lfm_FreightCommentCard: Form "5110522";
    //         Text01: Label 'Bitte wählen Sie einen gültigen Eintrag aus!';
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungskarte Kopf
    //         // ------------------------------------------------------------------------------------

    //         IF vrc_FreightComment."Entry No." <= 0 THEN
    //           // Bitte wählen Sie einen gültigen Eintrag aus!
    //           ERROR(Text01);

    //         lrc_FreightComment.FILTERGROUP(2);
    //         lrc_FreightComment.SETRANGE("Entry No.",vrc_FreightComment."Entry No.");
    //         lrc_FreightComment.SETRANGE("Entry Type",vrc_FreightComment."Entry Type");
    //         lrc_FreightComment.SETRANGE("Line No.",vrc_FreightComment."Line No.");
    //         lrc_FreightComment.FILTERGROUP(0);

    //         //IF (lrc_CommentSetup.GET) AND (lrc_CommentSetup."Form ID Freight Comment" <> 0) THEN BEGIN
    //         //  FORM.RUNMODAL(lrc_CommentSetup."Form ID Freight Comment",lrc_FreightComment);
    //         //END ELSE BEGIN
    //         //MOD XOX wzi
    //           lfm_FreightCommentCard.SETTABLEVIEW(lrc_FreightComment);
    //           lfm_FreightCommentCard.RUNMODAL;
    //         //END;

    //         // Erste Bemerkungszeile in Kopfsatz setzen oder löschen falls kein Bemerkungstext vorhanden
    //         FreightSetCommentFirstLine(vrc_FreightComment."Entry No.");
    //     end;

    //     procedure FreightNewComment(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];vin_DocLineNo: Integer)
    //     var
    //         lrc_FreightOrderHeader: Record "5110439";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_FreightComment: Record "5087930";
    //         lrc_SalesCommentPrintDoc: Record "5087931";
    //         lrc_Location: Record "14";
    //         lfm_FreightCommentCard: Form "5110522";
    //         "lin_ArrZähler": Integer;
    //         lco_ArrShippingAgent: array [100] of Code[20];
    //         lco_ArrPhysLocation: array [100] of Code[20];
    //         lco_ArrLocation: array [100] of Code[20];
    //         lco_ArrDepartRegion: array [100] of Code[20];
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Erfassung einer neuen Bemerkung Kopf / Zeile
    //         // ------------------------------------------------------------------------------------

    //         lrc_FreightOrderHeader.GET(vco_DocNo);

    //         // Alle Lagerorte in Array schreiben
    //         ////lcu_Sales.FillArrLocation(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrLocation);
    //         IF lrc_FreightOrderHeader."Departure Type" = lrc_FreightOrderHeader."Departure Type"::Location THEN
    //           lco_ArrLocation[1] := lrc_FreightOrderHeader."Departure Code";
    //         // Alle Lagerortgruppen in Array schreiben
    //         ////lcu_Sales.FillArrLocationGroup(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrPhysLocation);
    //         // Alle Zusteller in Array schreiben
    //         ////lcu_Sales.FillArrShippingAgent(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrShippingAgent);
    //         IF lrc_FreightOrderHeader."Shipping Agent Code" <> '' THEN
    //           lco_ArrShippingAgent[1] := lrc_FreightOrderHeader."Shipping Agent Code";
    //         // Alle Abgangsregionen in Array schreiben
    //         ////lcu_Sales.FillArrDepartureRegion(vrc_SalesHeader."Document Type",vrc_SalesHeader."No.",lco_ArrDepartRegion);
    //         IF lrc_FreightOrderHeader."Departure Region Code" <> '' THEN
    //           lco_ArrDepartRegion[1] := lrc_FreightOrderHeader."Departure Region Code";

    //         // Kopfsatz Bemerkung anlegen
    //         lrc_FreightComment.Reset();
    //         lrc_FreightComment.INIT();
    //         lrc_FreightComment."Entry No." := 0;
    //         lrc_FreightComment."Entry Type" := lrc_FreightComment."Entry Type"::Header;
    //         lrc_FreightComment."Line No." := 0;
    //         IF vin_DocLineNo = 0 THEN
    //           lrc_FreightComment."Document Source" := lrc_FreightComment."Document Source"::Header
    //         ELSE
    //           lrc_FreightComment."Document Source" := lrc_FreightComment."Document Source"::Line;
    //         lrc_FreightComment."Document Type" := 0;
    //         lrc_FreightComment."Document No." := lrc_FreightOrderHeader."No.";
    //         lrc_FreightComment."Document Line No." := vin_DocLineNo;

    //         IF vin_DocLineNo = 0 THEN
    //           lrc_FreightComment.Placement := lrc_FreightComment.Placement::Footer
    //         ELSE
    //           lrc_FreightComment.Placement := lrc_FreightComment.Placement::Line;
    //         lrc_FreightComment.Comment := '';
    //         lrc_FreightComment.INSERT(TRUE);

    //         // Filter mit Filtergruppe setzen
    //         lrc_FreightComment.FILTERGROUP(2);
    //         lrc_FreightComment.SETRANGE("Entry No.",lrc_FreightComment."Entry No.");
    //         lrc_FreightComment.SETRANGE("Entry Type",lrc_FreightComment."Entry Type");
    //         lrc_FreightComment.SETRANGE("Line No.",lrc_FreightComment."Line No.");
    //         lrc_FreightComment.FILTERGROUP(0);


    //         // Druckbelege Laden für die Bemerkungen erfaßt werden können
    //         lrc_PrintDocument.Reset();
    //         lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::"16");
    //         IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //           REPEAT

    //             CASE lrc_PrintDocument."Multiple Entry for" OF

    //               // ----------------------------------------------------------------------------------------------
    //               // Keine Mehrfachgenerierung
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::" ":
    //                 BEGIN
    //                   lrc_SalesCommentPrintDoc.Reset();
    //                   lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_FreightComment."Entry No.");
    //                   lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                   lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",'');
    //                   IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                     lrc_SalesCommentPrintDoc.Reset();
    //                     lrc_SalesCommentPrintDoc.INIT();
    //                     lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_FreightComment."Entry No.";
    //                     lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                     lrc_SalesCommentPrintDoc."Detail Code" := '';
    //                     lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                     lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                     lrc_SalesCommentPrintDoc.Print := FALSE;
    //                     lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Lager
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::Location:
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                        lrc_SalesCommentPrintDoc.Reset();
    //                        lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_FreightComment."Entry No.");
    //                        lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                        lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                        IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                          lrc_SalesCommentPrintDoc.Reset();
    //                          lrc_SalesCommentPrintDoc.INIT();
    //                          lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_FreightComment."Entry No.";
    //                          lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                          lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                          lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                          lrc_SalesCommentPrintDoc.Print := FALSE;
    //                          lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                        END;
    //                      END;
    //                      lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Physisches Lager
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Location Group":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrPhysLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                       lrc_SalesCommentPrintDoc.Reset();
    //                       lrc_SalesCommentPrintDoc.INIT();
    //                       lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_FreightComment."Entry No.";
    //                       lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                       lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrPhysLocation[lin_ArrZähler];
    //                       lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                       lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                       lrc_SalesCommentPrintDoc.Print := FALSE;
    //                       lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                     END;

    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Abgangsregion
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Departure Region":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                         IF lco_ArrDepartRegion[lin_ArrZähler] <> '' THEN BEGIN
    //                           lrc_SalesCommentPrintDoc.Reset();
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_FreightComment."Entry No.");
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                           lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrDepartRegion[lin_ArrZähler]);
    //                           IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.INIT();
    //                             lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_FreightComment."Entry No.";
    //                             lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                             lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrDepartRegion[lin_ArrZähler];
    //                             lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                             lrc_SalesCommentPrintDoc.Print := FALSE;
    //                             lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                           END;
    //                         END;
    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //               // ----------------------------------------------------------------------------------------------
    //               // Mehrfachgenerierung Zusteller
    //               // ----------------------------------------------------------------------------------------------
    //               lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                 BEGIN
    //                   lin_ArrZähler := 1;
    //                   WHILE lin_ArrZähler <= 10 DO BEGIN
    //                     IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                       lrc_SalesCommentPrintDoc.Reset();
    //                       lrc_SalesCommentPrintDoc.INIT();
    //                       lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_FreightComment."Entry No.";
    //                       lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                       lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                       lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                       lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                       lrc_SalesCommentPrintDoc.Print := FALSE;
    //                       lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                     END;
    //                     lin_ArrZähler := lin_ArrZähler + 1;
    //                   END;
    //                 END;

    //             END;

    //           UNTIL lrc_PrintDocument.NEXT() = 0;
    //         END;
    //         COMMIT;



    //         FreightShowComment(lrc_FreightComment)

    //         //lfm_FreightCommentCard.SETTABLEVIEW(lrc_FreightComment);
    //         //lfm_FreightCommentCard.RUNMODAL;

    //         //// Erste Zeile in Kopfsatz generieren
    //         //FreightSetCommentFirstLine(lrc_FreightComment."Entry No.");
    //     end;

    //     procedure FreightSetCommentFirstLine(vin_EntryNo: Integer)
    //     var
    //         lrc_FreightCommentHeader: Record "5087930";
    //         lrc_FreightCommentLine: Record "5087930";
    //     begin
    //         // ------------------------------------------------------------------------------------------------
    //         // Funktion zum Setzen der ersten Bemerkungszeile in den Kopfsatz Bemerkungen
    //         // ------------------------------------------------------------------------------------------------

    //         // Kommentar aus erster Zeile in Kopfsatz setzen
    //         lrc_FreightCommentHeader.GET(vin_EntryNo,lrc_FreightCommentHeader."Entry Type"::Header,0);

    //         lrc_FreightCommentLine.SETRANGE("Entry No.",lrc_FreightCommentHeader."Entry No.");
    //         lrc_FreightCommentLine.SETRANGE("Entry Type",lrc_FreightCommentLine."Entry Type"::Line);
    //         IF lrc_FreightCommentLine.FIND('-') THEN BEGIN
    //           lrc_FreightCommentHeader.Comment := lrc_FreightCommentLine.Comment;
    //           lrc_FreightCommentHeader.Modify();
    //         END ELSE BEGIN
    //           // Bemerkungstext löschen falls keine Bemerkungszeilen erfasst sind
    //           lrc_FreightCommentHeader.DELETE(TRUE);
    //         END;
    //     end;

    //     procedure FreightCommentOnAllDoc(vin_EntryNo: Integer;vop_Typ: Option "0","1","2","3","4","5")
    //     var
    //         lrc_SalesCommentPrintDoc: Record "5087931";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_SalesComment: Record "5087930";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum Setzen ShowText in allen Druckbelegen Kopf
    //         // ------------------------------------------------------------------------------------

    //         // vop_Typ = 0 Alle
    //         // vop_Typ = 1 Kreditoren
    //         // vop_Typ = 2 Lagerort
    //         // vop_Typ = 3 Zusteller

    //         CASE vop_Typ OF
    //           0:
    //            BEGIN
    //              lrc_SalesCommentPrintDoc.Reset();
    //              lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",vin_EntryNo);
    //              lrc_SalesCommentPrintDoc.MODIFYALL(Print,TRUE);
    //            END;
    //           1,2,3:
    //            BEGIN
    //              lrc_SalesComment.Reset();
    //              lrc_SalesComment.SETRANGE("Entry No.", vin_EntryNo);
    //              lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //              IF lrc_SalesComment.FIND('-') THEN BEGIN
    //                lrc_SalesCommentPrintDoc.Reset();
    //                lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",vin_EntryNo);
    //                IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                  lrc_PrintDocument.Reset();
    //                  lrc_PrintDocument.SETCURRENTKEY( "Document Source","Document Type",Code);
    //                  REPEAT
    //                    lrc_PrintDocument.SETRANGE( "Document Source", lrc_PrintDocument."Document Source"::Sales);
    //                    lrc_PrintDocument.SETRANGE("Document Type", lrc_SalesComment."Document Type");
    //                    lrc_PrintDocument.SETRANGE( Code, lrc_SalesCommentPrintDoc."Print Document Code");
    //                    IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //                      IF ((vop_Typ = 1) AND
    //                         (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::"Customer/Vendor")) OR
    //                         ((vop_Typ = 2) AND
    //                          (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::Location)) OR
    //                         ((vop_Typ = 3) AND
    //                          (lrc_PrintDocument."Mark Typ" = lrc_PrintDocument."Mark Typ"::"Shipping Agent")) THEN BEGIN
    //                        lrc_SalesCommentPrintDoc.VALIDATE(Print,TRUE);
    //                        lrc_SalesCommentPrintDoc.MODIFY(TRUE);
    //                      END;
    //                    END;
    //                  UNTIL lrc_SalesCommentPrintDoc.NEXT() = 0;
    //                END;
    //              END;
    //            END;
    //         END;
    //     end;

    //     procedure FreightLineComment(vrc_SalesLine: Record "5110440")
    //     var
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_SalesComment: Record "5087930";
    //         lrc_SalesCommentPrintDoc: Record "5087931";
    //         lfm_SalesComment: Form "5110520";
    //     begin
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zur Anzeige der Bemerkungsliste Zeile
    //         // ------------------------------------------------------------------------------------

    //         vrc_SalesLine.TESTFIELD("Freight Order No.");
    //         vrc_SalesLine.TESTFIELD("Line No.");

    //         lrc_SalesComment.FILTERGROUP(2);
    //         lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type"::Header);
    //         lrc_SalesComment.SETRANGE("Document Source",lrc_SalesComment."Document Source"::Line);
    //         //lrc_SalesComment.SETRANGE("Document Type",vrc_SalesLine."Document Type");
    //         lrc_SalesComment.SETRANGE("Document No.",vrc_SalesLine."Freight Order No.");
    //         lrc_SalesComment.SETRANGE("Document Line No.",vrc_SalesLine."Line No.");
    //         lrc_SalesComment.FILTERGROUP(0);
    //         IF lrc_SalesComment.FIND('-') THEN BEGIN
    //           REPEAT

    //             lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Sales);
    //         //    lrc_PrintDocument.SETRANGE("Document Type",vrc_SalesLine."Document Type");
    //             IF lrc_PrintDocument.FIND('-') THEN BEGIN
    //               REPEAT

    //                 lrc_SalesCommentPrintDoc.SETRANGE("Freight Comment Entry No.",lrc_SalesComment."Entry No.");
    //                 lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                 IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                   lrc_SalesCommentPrintDoc.Reset();
    //                   lrc_SalesCommentPrintDoc.INIT();
    //                   lrc_SalesCommentPrintDoc."Freight Comment Entry No." := lrc_SalesComment."Entry No.";
    //                   lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                   lrc_SalesCommentPrintDoc."Detail Code" := '';
    //                   lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                   lrc_SalesCommentPrintDoc.Print := FALSE;
    //                   lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                 END;
    //               UNTIL lrc_PrintDocument.NEXT() = 0;
    //             END;
    //           UNTIL lrc_SalesComment.NEXT() = 0;
    //         END;

    //         COMMIT;
    //         lfm_SalesComment.SetGlobals(0,vrc_SalesLine."Freight Order No.",vrc_SalesLine."Line No.");
    //         lfm_SalesComment.SETTABLEVIEW(lrc_SalesComment);
    //         lfm_SalesComment.RUNMODAL;
    //     end;

    //     procedure FreightMoveCommentToPostCom(vop_SourceDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";vco_SourceDocumentNo: Code[20];vin_SourceDocumentLineNo: Integer;vop_TargetDocumentType: Option Shipment,Invoice,"Credit Memo","Return Receipt";vco_TargetDocumentNo: Code[20];vin_TargetDocumentLineNo: Integer)
    //     var
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesComment2: Record "5110427";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lrc_SalesPostArchivComment: Record "5110429";
    //         lin_newEntryNo: Integer;
    //     begin
    //         IF vin_SourceDocumentLineNo = 0 THEN BEGIN
    //            // alle Header und Footer kopieren
    //            lrc_SalesComment.Reset();
    //            lrc_SalesComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //              "Document Source","Document Type","Document No.","Document Line No.");
    //            // erst nur Köpfe
    //            lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //            lrc_SalesComment.SETRANGE("Document Source", lrc_SalesComment."Document Source"::Header);
    //            lrc_SalesComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //            lrc_SalesComment.SETRANGE( Placement, lrc_SalesComment.Placement::Header);
    //            IF lrc_SalesComment.FIND('-') THEN BEGIN
    //               REPEAT

    //                  lrc_SalesCommentPrintDoc.Reset();
    //                  lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.", lrc_SalesComment."Entry No.");
    //                  CASE vop_TargetDocumentType OF
    //                    0:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G LS');
    //                    1:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G RG');
    //                    2:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                                         lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G GS');
    //                    3:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                                         lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G RS');
    //                  END;
    //                  IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                     IF lrc_SalesCommentPrintDoc.Print THEN BEGIN

    //                        lrc_SalesPostArchivComment.Reset();
    //                        lrc_SalesPostArchivComment.SETRANGE("Entry Type",lrc_SalesPostArchivComment."Entry Type"::Header);
    //                        IF lrc_SalesPostArchivComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_SalesPostArchivComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_SalesPostArchivComment.INIT();
    //                        lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment."Entry Type";
    //                        lrc_SalesPostArchivComment."Line No." := lrc_SalesComment."Line No.";
    //                        lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                          1:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                          2:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                        END;
    //                        lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_SalesPostArchivComment.Placement := lrc_SalesComment.Placement;
    //                        lrc_SalesPostArchivComment.Comment := lrc_SalesComment.Comment;
    //                        lrc_SalesPostArchivComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_SalesComment2.Reset();
    //                        lrc_SalesComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_SalesComment2.SETRANGE("Entry Type", lrc_SalesComment2."Entry Type"::Line);
    //                        lrc_SalesComment2.SETRANGE("Entry No.", lrc_SalesComment."Entry No.");
    //                        lrc_SalesComment2.SETRANGE("Document Source", lrc_SalesComment2."Document Source"::Header);
    //                        lrc_SalesComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_SalesComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_SalesComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //                        lrc_SalesComment2.SETRANGE( Placement, lrc_SalesComment2.Placement::Header);
    //                        IF lrc_SalesComment2.FIND('-') THEN BEGIN
    //                           REPEAT
    //                             lrc_SalesPostArchivComment.INIT();
    //                             lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                             lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment2."Entry Type";
    //                             lrc_SalesPostArchivComment."Line No." := lrc_SalesComment2."Line No.";
    //                             lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment2."Document Source";
    //                             CASE vop_TargetDocumentType OF
    //                               0:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                        lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                               1:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                               2:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                               3:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                             END;
    //                             lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                             lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                             lrc_SalesPostArchivComment.Placement := lrc_SalesComment2.Placement;
    //                             lrc_SalesPostArchivComment.Comment := lrc_SalesComment2.Comment;
    //                             lrc_SalesPostArchivComment.INSERT(TRUE);
    //                           UNTIL lrc_SalesComment2.NEXT() = 0;
    //                        END;

    //                    END;
    //                 END;
    //               UNTIL lrc_SalesComment.NEXT() = 0;
    //            END;

    //            lrc_SalesComment.Reset();
    //            lrc_SalesComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //              "Document Source","Document Type","Document No.","Document Line No.");
    //            // erst nur die Köpfe
    //            lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //            lrc_SalesComment.SETRANGE("Document Source", lrc_SalesComment."Document Source"::Header);
    //            lrc_SalesComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //            lrc_SalesComment.SETRANGE( Placement, lrc_SalesComment.Placement::Footer);
    //            IF lrc_SalesComment.FIND('-') THEN BEGIN
    //               REPEAT
    //                  lrc_SalesCommentPrintDoc.Reset();
    //                  lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.", lrc_SalesComment."Entry No.");
    //                  CASE vop_TargetDocumentType OF
    //                    0:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G LS');
    //                    1:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G RG');
    //                    2:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                                         lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G GS');
    //                    3:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                                         lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G RS');
    //                  END;
    //                  IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                     IF lrc_SalesCommentPrintDoc.Print THEN BEGIN

    //                        lrc_SalesPostArchivComment.Reset();
    //                        lrc_SalesPostArchivComment.SETRANGE("Entry Type",lrc_SalesPostArchivComment."Entry Type"::Header);
    //                        IF lrc_SalesPostArchivComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_SalesPostArchivComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_SalesPostArchivComment.INIT();
    //                        lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment."Entry Type";
    //                        lrc_SalesPostArchivComment."Line No." := lrc_SalesComment."Line No.";
    //                        lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                          1:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                          2:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                        END;
    //                        lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_SalesPostArchivComment.Placement := lrc_SalesComment.Placement;
    //                        lrc_SalesPostArchivComment.Comment := lrc_SalesComment.Comment;
    //                        lrc_SalesPostArchivComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_SalesComment2.Reset();
    //                        lrc_SalesComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_SalesComment2.SETRANGE("Entry Type", lrc_SalesComment2."Entry Type"::Line);
    //                        lrc_SalesComment2.SETRANGE("Entry No.", lrc_SalesComment."Entry No.");
    //                        lrc_SalesComment2.SETRANGE("Document Source", lrc_SalesComment2."Document Source"::Header);
    //                        lrc_SalesComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_SalesComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_SalesComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //                        lrc_SalesComment2.SETRANGE( Placement, lrc_SalesComment2.Placement::Footer);
    //                        IF lrc_SalesComment2.FIND('-') THEN BEGIN
    //                           REPEAT
    //                             lrc_SalesPostArchivComment.INIT();
    //                             lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                             lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment2."Entry Type";
    //                             lrc_SalesPostArchivComment."Line No." := lrc_SalesComment2."Line No.";
    //                             lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment2."Document Source";
    //                             CASE vop_TargetDocumentType OF
    //                               0:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                        lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                               1:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                               2:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                               3:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                             END;
    //                             lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                             lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                             lrc_SalesPostArchivComment.Placement := lrc_SalesComment2.Placement;
    //                             lrc_SalesPostArchivComment.Comment := lrc_SalesComment2.Comment;
    //                             lrc_SalesPostArchivComment.INSERT(TRUE);
    //                           UNTIL lrc_SalesComment2.NEXT() = 0;
    //                        END;
    //                     END;
    //                  END;
    //               UNTIL lrc_SalesComment.NEXT() = 0;
    //            END;

    //         END ELSE BEGIN
    //            // nur die Zeile kopieren
    //            lrc_SalesComment.Reset();
    //            lrc_SalesComment.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //              "Document Source","Document Type","Document No.","Document Line No.");
    //            // erst nur die Köpfe
    //            lrc_SalesComment.SETRANGE("Entry Type", lrc_SalesComment."Entry Type"::Header);
    //            lrc_SalesComment.SETRANGE("Document Source", lrc_SalesComment."Document Source"::Line);
    //            lrc_SalesComment.SETRANGE("Document Type", vop_SourceDocumentType);
    //            lrc_SalesComment.SETRANGE("Document No.", vco_SourceDocumentNo);
    //            lrc_SalesComment.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //            lrc_SalesComment.SETRANGE( Placement, lrc_SalesComment.Placement::Line);
    //            IF lrc_SalesComment.FIND('-') THEN BEGIN
    //               REPEAT
    //                  lrc_SalesCommentPrintDoc.Reset();
    //                  lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.", lrc_SalesComment."Entry No.");
    //                  CASE vop_TargetDocumentType OF
    //                    0:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Shipment");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G LS');
    //                    1:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Invoice");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G RG');
    //                    2:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                                         lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Credit Memo");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G GS');
    //                    3:
    //                       lrc_SalesCommentPrintDoc.SETRANGE("Posted Doc. Type",
    //                                                         lrc_SalesCommentPrintDoc."Posted Doc. Type"::"Posted Return Receipt/Shipment");
    //                       //lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code", 'V G RS');
    //                  END;
    //                  IF lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                     IF lrc_SalesCommentPrintDoc.Print THEN BEGIN

    //                        lrc_SalesPostArchivComment.Reset();
    //                        lrc_SalesPostArchivComment.SETRANGE("Entry Type",lrc_SalesPostArchivComment."Entry Type"::Header);
    //                        IF lrc_SalesPostArchivComment.FIND('+') THEN BEGIN
    //                          lin_newEntryNo := lrc_SalesPostArchivComment."Entry No." + 1
    //                        END ELSE BEGIN
    //                          lin_newEntryNo := 1;
    //                        END;

    //                        lrc_SalesPostArchivComment.INIT();
    //                        lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                        lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment."Entry Type";
    //                        lrc_SalesPostArchivComment."Line No." := lrc_SalesComment."Line No.";
    //                        lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment."Document Source";
    //                        CASE vop_TargetDocumentType OF
    //                          0:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                          1:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                          2:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                          3:
    //                            lrc_SalesPostArchivComment."Document Type" :=
    //                              lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                        END;
    //                        lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                        lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                        lrc_SalesPostArchivComment.Placement := lrc_SalesComment.Placement;
    //                        lrc_SalesPostArchivComment.Comment := lrc_SalesComment.Comment;
    //                        lrc_SalesPostArchivComment.INSERT(TRUE);

    //                        // dann die Zeilen dazu
    //                        lrc_SalesComment2.Reset();
    //                        lrc_SalesComment2.SETCURRENTKEY("Entry Type","Entry No.","Line No.",
    //                          "Document Source","Document Type","Document No.","Document Line No.");
    //                        lrc_SalesComment2.SETRANGE("Entry Type", lrc_SalesComment2."Entry Type"::Line);
    //                        lrc_SalesComment2.SETRANGE("Entry No.", lrc_SalesComment."Entry No.");
    //                        lrc_SalesComment2.SETRANGE("Document Source", lrc_SalesComment2."Document Source"::Line);
    //                        lrc_SalesComment2.SETRANGE("Document Type", vop_SourceDocumentType);
    //                        lrc_SalesComment2.SETRANGE("Document No.", vco_SourceDocumentNo);
    //                        lrc_SalesComment2.SETFILTER("Document Line No.", '%1', vin_SourceDocumentLineNo);
    //                        lrc_SalesComment2.SETRANGE( Placement, lrc_SalesComment2.Placement::Line);
    //                        IF lrc_SalesComment2.FIND('-') THEN BEGIN
    //                           REPEAT
    //                             lrc_SalesPostArchivComment.INIT();
    //                             lrc_SalesPostArchivComment."Entry No." := lin_newEntryNo;
    //                             lrc_SalesPostArchivComment."Entry Type" := lrc_SalesComment2."Entry Type";
    //                             lrc_SalesPostArchivComment."Line No." := lrc_SalesComment2."Line No.";
    //                             lrc_SalesPostArchivComment."Document Source" := lrc_SalesComment2."Document Source";
    //                             CASE vop_TargetDocumentType OF
    //                               0:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Shipment";
    //                               1:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Invoice";
    //                               2:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Credit Memo";
    //                               3:
    //                                 lrc_SalesPostArchivComment."Document Type" :=
    //                                   lrc_SalesPostArchivComment."Document Type"::"Posted Return Receipt";
    //                             END;
    //                             lrc_SalesPostArchivComment."Document No." := vco_TargetDocumentNo;
    //                             lrc_SalesPostArchivComment."Document Line No." := vin_TargetDocumentLineNo;
    //                             lrc_SalesPostArchivComment.Placement := lrc_SalesComment2.Placement;
    //                             lrc_SalesPostArchivComment.Comment := lrc_SalesComment2.Comment;
    //                             lrc_SalesPostArchivComment.INSERT(TRUE);
    //                           UNTIL lrc_SalesComment2.NEXT() = 0;
    //                        END;

    //                     END;
    //                  END;
    //               UNTIL lrc_SalesComment.NEXT() = 0;
    //            END;

    //         END;
    //     end;

    //     procedure FreightTransferArchPostComment(lop_InsertType: Option PostedDocument,Archiv;lrc_SalesHeader: Record "36";lco_InvHeaderNo: Code[20];lco_CreditMemoHeaderNo: Code[20];lco_ReturnRcptHeaderNo: Code[20];lco_SalesShptHeaderNo: Code[20];lin_VersionNo: Integer)
    //     var
    //         lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Receipt";
    //         lco_DocNo: Code[20];
    //         lrc_SalesPostArchivDisc: Record "5110388";
    //     begin
    //         // BET 002 FV400018.s
    //         CASE lop_InsertType OF

    //           // Bei Buchungen
    //           lop_InsertType::PostedDocument:
    //             WITH lrc_SalesHeader DO BEGIN

    //               IF (Receive = Ship = Invoice = FALSE) THEN
    //                 EXIT;

    //               // Lieferung
    //               IF Receive THEN BEGIN
    //                 lop_DiscDocType := lop_DiscDocType::"Posted Shipment";
    //                 lco_DocNo := lco_ReturnRcptHeaderNo;
    //               END;

    //               // Rücklieferung
    //               IF Ship THEN BEGIN
    //                 lop_DiscDocType := lop_DiscDocType::"Posted Return Receipt";
    //                 lco_DocNo := lco_SalesShptHeaderNo;
    //               END;

    //               // Rechnung und Gutschrift
    //               IF Invoice THEN BEGIN
    //                 IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN BEGIN
    //                   lop_DiscDocType := lop_DiscDocType::"Posted Invoice";
    //                   lco_DocNo := lco_InvHeaderNo;
    //                 END ELSE BEGIN// Credit Memo
    //                   lop_DiscDocType := lop_DiscDocType::"Posted Credit Memo";
    //                   lco_DocNo := lco_CreditMemoHeaderNo;
    //                 END;
    //               END;
    //             END;

    //           // Bei Archivierungen
    //           lop_InsertType::Archiv:
    //             WITH lrc_SalesHeader DO BEGIN
    //               CASE "Document Type" OF
    //                 "Document Type"::Quote           : lop_DiscDocType := lop_DiscDocType::"Archive Quote";
    //                 "Document Type"::"Blanket Order" : lop_DiscDocType := lop_DiscDocType::"Archive Blanket Order";
    //                 "Document Type"::Order           : lop_DiscDocType := lop_DiscDocType::"Archive Order";
    //               END;
    //               lco_DocNo := "No.";
    //               gin_VersionNo := lin_VersionNo;
    //             END;
    //         END;

    //         SalesInsertCommentLines(lrc_SalesHeader,lop_DiscDocType,lco_DocNo);
    //         // BET 002 FV400018.s
    //     end;

    //     procedure FreightInsertCommentLines(lrc_SalesHeader: Record "36";lop_DiscDocType: Option "Archive Quote","Archive Order","Archive Invoice","Archive Credit Memo","Archive Blanket Order","Archive Return Order",,,,,,,,,,"Posted Shipment","Posted Invoice","Posted Credit Memo","Posted Return Shipment";lco_PostedDocNo: Code[20])
    //     var
    //         lrc_SalesComment: Record "5110427";
    //         lrc_SalesPostArchComm: Record "5110429";
    //         lin_EntryNo: Integer;
    //     begin
    //         // BET 002 FV400018.s
    //         lrc_SalesPostArchComm.Reset();
    //         IF lrc_SalesPostArchComm.FIND('+') THEN
    //           lin_EntryNo := lrc_SalesPostArchComm."Entry No.";

    //         lrc_SalesComment.Reset();
    //         lrc_SalesComment.SETCURRENTKEY("Document Source","Document Type","Document No.","Document Line No.");
    //         lrc_SalesComment.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //         lrc_SalesComment.SETRANGE("Document No.",lrc_SalesHeader."No.");
    //         IF lrc_SalesComment.FIND('-') THEN
    //           REPEAT
    //             WITH lrc_SalesPostArchComm DO BEGIN
    //               IF lrc_SalesComment."Entry Type" = lrc_SalesComment."Entry Type"::Header THEN
    //                  lin_EntryNo := lin_EntryNo + 1;
    //               INIT();
    //               TRANSFERFIELDS(lrc_SalesComment);
    //               "Entry No." := lin_EntryNo;
    //               "Entry Type" := lrc_SalesComment."Entry Type";
    //               "Line No." := lrc_SalesComment."Line No.";
    //               "Version No." := gin_VersionNo;
    //               IF NOT INSERT THEN
    //                 Modify();
    //             END;
    //           UNTIL lrc_SalesComment.NEXT() = 0;
    //         // BET 002 FV400018.e
    //     end;

    //     procedure FreightDocCopy(lin_FromDocType: Integer;lco_FromDocNo: Code[20];lrc_ToSalesHeader: Record "36";lin_VersionNo: Integer)
    //     var
    //         lrc_SalesPostArchComm: Record "5110429";
    //         lrc_SalesComment: Record "5110427";
    //         lrc_NewSalesComment: Record "5110427";
    //         Text001: Label 'Comments allready exists. If you continue, comments will de deleted.\Do you wish to continue?';
    //         Text002: Label 'Process stopped.';
    //         lin_EntryNo: Integer;
    //     begin
    //         // BET 003 FV400018.s
    //         gop_SalesDocType := lin_FromDocType;
    //         gin_VersionNo := lin_VersionNo;

    //         IF gop_SalesDocType IN [gop_SalesDocType::Quote,gop_SalesDocType::"Blanket Order",gop_SalesDocType::Order,
    //                                 gop_SalesDocType::Invoice,gop_SalesDocType::"Return Order",gop_SalesDocType::"Credit Memo"]
    //         THEN BEGIN  // Bemerkungszeilen aus Belegen
    //           WITH lrc_SalesComment DO BEGIN

    //             CASE gop_SalesDocType OF
    //               gop_SalesDocType::Quote:            SETRANGE("Document Type","Document Type"::Quote);
    //               gop_SalesDocType::"Blanket Order":  SETRANGE("Document Type","Document Type"::"Blanket Order");
    //               gop_SalesDocType::Order:            SETRANGE("Document Type","Document Type"::Order);
    //               gop_SalesDocType::Invoice:          SETRANGE("Document Type","Document Type"::Invoice);
    //               gop_SalesDocType::"Return Order":   SETRANGE("Document Type","Document Type"::"Return Order");
    //               gop_SalesDocType::"Credit Memo":    SETRANGE("Document Type","Document Type"::"Credit Memo");
    //             END;
    //             SETRANGE("Document No.",lco_FromDocNo);
    //             IF FIND('-') THEN BEGIN
    //               //Lösche vorhandene Bemerkungen
    //               lrc_NewSalesComment.SETRANGE("Document Type",lrc_ToSalesHeader."Document Type");
    //               lrc_NewSalesComment.SETRANGE("Document No.",lrc_ToSalesHeader."No.");
    //               IF lrc_NewSalesComment.FIND('-') THEN
    //                 IF CONFIRM(Text001,TRUE) THEN
    //                   lrc_NewSalesComment.DELETEALL(TRUE)
    //                 ELSE
    //                   ERROR(Text002);

    //               lrc_NewSalesComment.Reset();
    //               IF lrc_NewSalesComment.FIND('+') THEN
    //                 lin_EntryNo := lrc_NewSalesComment."Entry No.";

    //               REPEAT
    //                 lrc_NewSalesComment.INIT();
    //                 lrc_NewSalesComment.TRANSFERFIELDS(lrc_SalesComment);
    //                 lrc_NewSalesComment."Document Type" := lrc_ToSalesHeader."Document Type";
    //                 lrc_NewSalesComment."Document No." := lrc_ToSalesHeader."No.";
    //                 IF lrc_SalesComment."Entry Type" = lrc_SalesComment."Entry Type"::Header THEN
    //                   lin_EntryNo := lin_EntryNo + 1;
    //                 lrc_NewSalesComment."Entry No." := lin_EntryNo;
    //                 IF lrc_NewSalesComment.INSERT THEN;
    //               UNTIL NEXT= 0;
    //             END;
    //           END;
    //         END ELSE BEGIN // Bemerkungszeilen aus gebuchten Belegen und Archiv Bemerkungen
    //           WITH lrc_SalesPostArchComm DO BEGIN
    //             CASE gop_SalesDocType OF
    //               gop_SalesDocType::"Posted Invoice":         SETRANGE("Document Type","Document Type"::"Posted Invoice");
    //               gop_SalesDocType::"Posted Credit Memo":     SETRANGE("Document Type","Document Type"::"Posted Credit Memo");
    //               gop_SalesDocType::"Posted Shipment":        SETRANGE("Document Type","Document Type"::"Posted Shipment");
    //               gop_SalesDocType::"Posted Return Receipt":  SETRANGE("Document Type","Document Type"::"Posted Return Receipt");

    //               gop_SalesDocType::"Arch. Quote":         SETRANGE("Document Type","Document Type"::"Archive Quote");
    //               gop_SalesDocType::"Arch. Order":         SETRANGE("Document Type","Document Type"::"Archive Order");
    //               gop_SalesDocType::"Arch. Blanket Order": SETRANGE("Document Type","Document Type"::"Archive Blanket Order");
    //             END;
    //             SETRANGE("Document No.",lco_FromDocNo);
    //             SETRANGE("Version No.",gin_VersionNo);
    //             IF FIND('-') THEN BEGIN

    //               //Lösche vorhandene Rabatte
    //               lrc_NewSalesComment.SETRANGE("Document Type",lrc_ToSalesHeader."Document Type");
    //               lrc_NewSalesComment.SETRANGE("Document No.",lrc_ToSalesHeader."No.");
    //               IF lrc_NewSalesComment.FIND('-') THEN
    //                 IF CONFIRM(Text001,TRUE) THEN
    //                   lrc_NewSalesComment.DELETEALL
    //                 ELSE
    //                   ERROR(Text002);

    //               lrc_NewSalesComment.Reset();
    //               IF lrc_NewSalesComment.FIND('+') THEN
    //                 lin_EntryNo := lrc_NewSalesComment."Entry No.";

    //               REPEAT
    //                 lrc_NewSalesComment.INIT();
    //                 lrc_NewSalesComment.TRANSFERFIELDS(lrc_SalesPostArchComm);
    //                 lrc_SalesComment."Document Type" := lrc_ToSalesHeader."Document Type";
    //                 lrc_NewSalesComment."Document No." := lrc_ToSalesHeader."No.";
    //                 IF lrc_SalesPostArchComm."Entry Type" = lrc_SalesPostArchComm."Entry Type"::Header THEN
    //                   lin_EntryNo := lin_EntryNo + 1;
    //                 lrc_NewSalesComment."Entry No." := lin_EntryNo;
    //                 IF lrc_NewSalesComment.INSERT THEN;
    //               UNTIL NEXT= 0;
    //             END;
    //           END;
    //         END;
    //         // BET 003 FV400018.s
    //     end;

    procedure FreightCommentTransferToDoc(prc_FreightOrderHeader: Record "POI Freight Order Header")
    var
        lrc_SalesHeader: Record "Sales Header";
        lco_Customer_Vendor: Code[20];

    begin
        // ------------------------------------------------------------------------------------
        // Übertragen der Bemerkungen in die Verkaufsbelege
        // ------------------------------------------------------------------------------------
        // BET 004 FV400018.s

        // Bereits vorhandene Daten löschen
        lrc_FreightComment.RESET();
        lrc_FreightComment.SETRANGE("Document Source", lrc_FreightComment."Document Source"::Header);
        lrc_FreightComment.SETRANGE("Document Type", lrc_FreightComment."Document Type"::Order);
        lrc_FreightComment.SETRANGE("Document No.", prc_FreightOrderHeader."No.");
        IF lrc_FreightComment.FIND('-') THEN
            REPEAT

                // Drucktabelle löschen
                IF lrc_FreightComment."Entry Type" = lrc_FreightComment."Entry Type"::Header THEN BEGIN
                    lrc_FreightCommentPrintDoc.RESET();
                    lrc_FreightCommentPrintDoc.SETRANGE("Freight Comment Entry No.", lrc_FreightComment."Entry No.");
                    IF lrc_FreightCommentPrintDoc.FIND('-') THEN
                        lrc_FreightCommentPrintDoc.DELETEALL();
                END;
                // Haupttabelle löschen
                lrc_FreightComment.DELETE(TRUE);
            UNTIL lrc_FreightComment.NEXT() = 0;

        lco_Customer_Vendor := '';
        IF prc_FreightOrderHeader.Source = prc_FreightOrderHeader.Source::"Sales Order" THEN
            IF lrc_SalesHeader.GET(lrc_SalesHeader."Document Type"::Order, prc_FreightOrderHeader."Source No.") THEN
                lco_Customer_Vendor := lrc_SalesHeader."Sell-to Customer No.";


        // Daten für Sell-to Customer No. holen
        IF lco_Customer_Vendor <> '' THEN BEGIN
            lrc_CustVendComment.RESET();
            lrc_CustVendComment.SETRANGE("Document Source", lrc_CustVendComment."Document Source"::Header);
            lrc_CustVendComment.SETRANGE(Source, lrc_CustVendComment.Source::Customer);
            lrc_CustVendComment.SETRANGE("Source No.", lco_Customer_Vendor);
            IF lrc_CustVendComment.FIND('-') THEN
                REPEAT

                    // Bemerkungen übertragen und neue Nummer vergeben (durch das INSERT(TRUE))
                    lrc_FreightComment.INIT();

                    IF lrc_CustVendComment."Entry Type" = lrc_CustVendComment."Entry Type"::Header THEN
                        lrc_FreightComment."Entry No." := 0;

                    lrc_FreightComment."Entry Type" := lrc_CustVendComment."Entry Type";
                    lrc_FreightComment."Line No." := lrc_CustVendComment."Line No.";
                    lrc_FreightComment.INSERT(TRUE);

                    // Feldinformationen eintragen
                    lrc_FreightComment."Document Source" := lrc_CustVendComment."Document Source";
                    lrc_FreightComment."Document Type" := lrc_FreightComment."Document Type"::" ";
                    lrc_FreightComment."Document No." := prc_FreightOrderHeader."No.";
                    lrc_FreightComment.Placement := lrc_CustVendComment.Placement;
                    lrc_FreightComment.Comment := lrc_CustVendComment.Comment;
                    lrc_FreightComment."No. of Documents" := lrc_CustVendComment."No. of Documents";

                    lrc_FreightComment.MODIFY();

                    // Drucktabelle übertragen
                    IF lrc_CustVendComment."Entry Type" = lrc_CustVendComment."Entry Type"::Header THEN BEGIN
                        lrc_CustVendCommentPrintDoc.RESET();
                        lrc_CustVendCommentPrintDoc.SETRANGE("Cust./Vend. Comment Entry No.", lrc_CustVendComment."Entry No.");
                        lrc_CustVendCommentPrintDoc.SETRANGE(Print, TRUE);
                        IF lrc_CustVendCommentPrintDoc.FIND('-') THEN
                            REPEAT
                                lrc_FreightCommentPrintDoc.INIT();
                                lrc_FreightCommentPrintDoc."Freight Comment Entry No." := lrc_FreightComment."Entry No.";
                                lrc_FreightCommentPrintDoc."Print Document Code" := lrc_CustVendCommentPrintDoc."Print Document Code";
                                lrc_FreightCommentPrintDoc."Detail Code" := lrc_CustVendCommentPrintDoc."Detail Code";
                                lrc_FreightCommentPrintDoc."Print Document Description" := lrc_CustVendCommentPrintDoc."Print Document Description";
                                lrc_FreightCommentPrintDoc."Sort Order" := lrc_CustVendCommentPrintDoc."Sort Order";
                                lrc_FreightCommentPrintDoc.Print := lrc_CustVendCommentPrintDoc.Print;
                                lrc_FreightCommentPrintDoc.Consignee := lrc_CustVendCommentPrintDoc.Consignee;
                                lrc_FreightCommentPrintDoc."Multiple Entry for" := lrc_CustVendCommentPrintDoc."Multiple Entry for";
                                lrc_FreightCommentPrintDoc.INSERT();
                            UNTIL lrc_CustVendCommentPrintDoc.NEXT() = 0;
                    END;
                UNTIL lrc_CustVendComment.NEXT() = 0;
        END;
    end;

    //     local procedure TransferCommentToSalesComment(vrc_SalesHeader: Record "36";var rrc_CustVendComment: Record "5110425")
    //     var
    //         lrc_CustVendCommentPrintDoc: Record "5110426";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lrc_SalesComment: Record "5110427";
    //     begin
    //         // BET 005 KHH50223.s
    //         REPEAT
    //           // Bemerkungen übertragen und neue Nummer vergeben (durch das INSERT(TRUE))

    //           lrc_SalesComment.INIT();

    //           IF rrc_CustVendComment."Entry Type" = rrc_CustVendComment."Entry Type"::Header THEN BEGIN
    //             lrc_SalesComment."Entry No." := 0;
    //           END;

    //           lrc_SalesComment."Entry Type" := rrc_CustVendComment."Entry Type";
    //           lrc_SalesComment."Line No." := rrc_CustVendComment."Line No.";
    //           lrc_SalesComment.INSERT(TRUE);

    //           // Feldinformationen eintragen
    //           lrc_SalesComment."Document Source" := rrc_CustVendComment."Document Source";
    //           lrc_SalesComment."Document Type" := vrc_SalesHeader."Document Type";
    //           lrc_SalesComment."Document No." := vrc_SalesHeader."No.";
    //           lrc_SalesComment.Placement := rrc_CustVendComment.Placement;
    //           lrc_SalesComment.Comment := rrc_CustVendComment.Comment;
    //           lrc_SalesComment."No. of Documents" := rrc_CustVendComment."No. of Documents";

    //           lrc_SalesComment.Modify();

    //           // Drucktabelle übertragen
    //           IF rrc_CustVendComment."Entry Type" = rrc_CustVendComment."Entry Type"::Header THEN BEGIN
    //             lrc_CustVendCommentPrintDoc.Reset();
    //             lrc_CustVendCommentPrintDoc.SETRANGE("Cust./Vend. Comment Entry No.", rrc_CustVendComment."Entry No.");
    //             lrc_CustVendCommentPrintDoc.SETRANGE(Print,TRUE);
    //             IF lrc_CustVendCommentPrintDoc.FIND('-') THEN BEGIN
    //               REPEAT
    //                 lrc_SalesCommentPrintDoc.INIT();
    //                 lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                 lrc_SalesCommentPrintDoc."Print Document Code" := lrc_CustVendCommentPrintDoc."Print Document Code";
    //                 lrc_SalesCommentPrintDoc."Detail Code" := lrc_CustVendCommentPrintDoc."Detail Code";
    //                 IF lrc_CustVendCommentPrintDoc."Detail Code" = '' THEN BEGIN
    //                  IF lrc_CustVendCommentPrintDoc."Multiple Entry for" = lrc_CustVendCommentPrintDoc."Multiple Entry for"::Location THEN BEGIN
    //                      lrc_SalesCommentPrintDoc."Detail Code" := vrc_SalesHeader."Location Code";
    //                   END;
    //                 END;
    //                 lrc_SalesCommentPrintDoc."Print Document Description" := lrc_CustVendCommentPrintDoc."Print Document Description";
    //                 lrc_SalesCommentPrintDoc."Sort Order" := lrc_CustVendCommentPrintDoc."Sort Order";
    //                 lrc_SalesCommentPrintDoc.Print := lrc_CustVendCommentPrintDoc.Print;
    //                 lrc_SalesCommentPrintDoc.Consignee := lrc_CustVendCommentPrintDoc.Consignee;
    //                 lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_CustVendCommentPrintDoc."Multiple Entry for";
    //                 lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_CustVendCommentPrintDoc."Posted Doc. Type";
    //                 lrc_SalesCommentPrintDoc.insert();
    //               UNTIL lrc_CustVendCommentPrintDoc.NEXT() = 0;
    //             END;
    //           END;
    //         UNTIL rrc_CustVendComment.NEXT() = 0;
    //         // BET 005 KHH50223.e
    //     end;

    //     procedure "-- SALES CLAIM --"()
    //     begin
    //     end;

    //     procedure CopySalesClaimComment(vop_DocType: Option "1","2","3","4","5","6","7","8","9";vco_DocNo: Code[20];vin_DocLineNo: Integer;vco_SalesClaimDocNo: Code[20])
    //     var
    //         lcu_Sales: Codeunit "5110324";
    //         lrc_SalesHeader: Record "36";
    //         lrc_PrintDocument: Record "5110471";
    //         lrc_SalesComment: Record "5110427";
    //         lrc_NewSalesComment: Record "5110427";
    //         lrc_SalesCommentPrintDoc: Record "5110428";
    //         lrc_SalesClaimComment: Record "5110458";
    //         lfm_SalesCommentCard: Form "5110427";
    //         "lin_ArrZähler": Integer;
    //         lco_ArrShippingAgent: array [1000] of Code[20];
    //         lco_ArrPhysLocation: array [1000] of Code[20];
    //         lco_ArrLocation: array [1000] of Code[20];
    //         lco_ArrDepartRegion: array [1000] of Code[20];
    //         "--- DMG 001 DMG50000": Integer;
    //         lrc_SalesCommentLine: Record "44";
    //         lin_NextLineNo: Integer;
    //     begin
    //         //KHH 006 KHH50291.s
    //         // ------------------------------------------------------------------------------------
    //         // Funktion zum Übertragen von Bemerkungen aus Reklamationen in andere Beleg (Gutschrfiten)
    //         // ------------------------------------------------------------------------------------

    //         lrc_SalesHeader.GET(vop_DocType,vco_DocNo);

    //         // Alle Lagerorte in Array schreiben
    //         lcu_Sales.FillArrLocation(vop_DocType,vco_DocNo,lco_ArrLocation);
    //         // Alle Physischen Lagerorte in Array schreiben
    //         lcu_Sales.FillArrLocationGroup(vop_DocType,vco_DocNo,lco_ArrPhysLocation);
    //         // Alle Zusteller in Array schreiben
    //         lcu_Sales.FillArrShippingAgent(vop_DocType,vco_DocNo,lco_ArrShippingAgent);
    //         // Alle Abgangsregionen in Array schreiben
    //         lcu_Sales.FillArrDepartureRegion(vop_DocType,vco_DocNo,lco_ArrDepartRegion);

    //         // DMG 001 DMG50000.s
    //         // Allgemeine Bemerkung übertragen
    //         lrc_SalesClaimComment.Reset();
    //         lrc_SalesClaimComment.SETRANGE("Document No.",vco_SalesClaimDocNo);
    //         lrc_SalesClaimComment.SETRANGE(Type,lrc_SalesClaimComment.Type::" ");

    //         lrc_SalesClaimComment.SETRANGE( "Not Transfer To Credit Memo", FALSE );

    //         IF lrc_SalesClaimComment.FINDSET() THEN BEGIN

    //           lin_NextLineNo := 0;
    //           lrc_SalesCommentLine.Reset();
    //           lrc_SalesCommentLine.SETRANGE( "Document Type", lrc_SalesCommentLine."Document Type"::"Credit Memo" );
    //           lrc_SalesCommentLine.SETRANGE( "No.", vco_SalesClaimDocNo );
    //           IF lrc_SalesCommentLine.FINDLAST() THEN BEGIN
    //              lin_NextLineNo := lrc_SalesCommentLine."Line No.";
    //           END;

    //           REPEAT

    //             lin_NextLineNo := lin_NextLineNo + 10000;

    //             lrc_SalesCommentLine.Reset();
    //             lrc_SalesCommentLine.INIT();
    //             lrc_SalesCommentLine."Document Type" := lrc_SalesHeader."Document Type";
    //             lrc_SalesCommentLine."No." := lrc_SalesHeader."No.";
    //             lrc_SalesCommentLine."Line No." := lin_NextLineNo ;
    //             lrc_SalesCommentLine.Comment := lrc_SalesClaimComment.Comment;
    //             lrc_SalesCommentLine.INSERT( TRUE );
    //           UNTIL lrc_SalesClaimComment.NEXT() = 0;
    //         END;
    //         // DMG 001 DMG50000.e

    //         // K O P F B E M E R K U N G  Ü B E R T R A G E N
    //         lrc_SalesClaimComment.Reset();
    //         lrc_SalesClaimComment.SETRANGE("Document No.",vco_SalesClaimDocNo);
    //         lrc_SalesClaimComment.SETRANGE(Type,lrc_SalesClaimComment.Type::Header);

    //         // DMG 001 DMG50000.s
    //         lrc_SalesClaimComment.SETRANGE( "Not Transfer To Credit Memo", FALSE );
    //         // DMG 001 DMG50000.e

    //         IF lrc_SalesClaimComment.FIND('-') THEN BEGIN

    //           // Kopfsatz Bemerkung anlegen
    //           lrc_SalesComment.Reset();
    //           lrc_SalesComment.INIT();
    //           lrc_SalesComment."Entry No." := 0;
    //           lrc_SalesComment."Entry Type" := lrc_SalesComment."Entry Type"::Header;
    //           lrc_SalesComment."Line No." := 0;
    //           lrc_SalesComment."Document Source" := lrc_SalesComment."Document Source"::Header;

    //           lrc_SalesComment."Document Type" := lrc_SalesHeader."Document Type";
    //           lrc_SalesComment."Document No." := lrc_SalesHeader."No.";
    //           lrc_SalesComment."Document Line No." := vin_DocLineNo;

    //           lrc_SalesComment.Placement := lrc_SalesComment.Placement::Header;
    //           lrc_SalesComment.Comment := lrc_SalesClaimComment.Comment;
    //           lrc_SalesComment.INSERT(TRUE);

    //           REPEAT
    //           /*
    //             lrc_NewSalesComment.INIT();
    //             lrc_NewSalesComment."Entry No." := lrc_SalesComment."Entry No.";
    //             lrc_NewSalesComment."Entry Type" := lrc_NewSalesComment."Entry Type"::Line;
    //             lrc_NewSalesComment."Line No." := lrc_SalesClaimComment."Line No.";
    //             lrc_NewSalesComment.Placement := lrc_SalesComment.Placement;
    //             lrc_NewSalesComment.Comment := lrc_SalesClaimComment.Comment;
    //             lrc_NewSalesComment.insert();
    //           */

    //             lrc_NewSalesComment.INIT();
    //             lrc_NewSalesComment."Entry No." := lrc_SalesComment."Entry No.";
    //             lrc_NewSalesComment."Entry Type" := lrc_NewSalesComment."Entry Type"::Line;
    //             lrc_NewSalesComment."Document Type" := lrc_SalesComment."Document Type";
    //             lrc_NewSalesComment."Document No." := lrc_SalesComment."Document No.";
    //             lrc_NewSalesComment."Document Source" := lrc_NewSalesComment."Document Source"::Header;

    //             lrc_NewSalesComment."Line No." := lrc_SalesClaimComment."Line No.";
    //             lrc_NewSalesComment.Placement := lrc_SalesComment.Placement;
    //             lrc_NewSalesComment.Comment := lrc_SalesClaimComment.Comment;
    //             lrc_NewSalesComment.insert();

    //           UNTIL lrc_SalesClaimComment.NEXT(1) = 0;

    //           // Filter mit Filtergruppe setzen
    //           lrc_SalesComment.FILTERGROUP(2);
    //           lrc_SalesComment.SETRANGE("Entry No.",lrc_SalesComment."Entry No.");
    //           lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type");
    //           lrc_SalesComment.SETRANGE("Line No.",lrc_SalesComment."Line No.");
    //           lrc_SalesComment.FILTERGROUP(0);

    //           // Druckbelege Laden für die Bemerkungen erfaßt werden können
    //           lrc_PrintDocument.Reset();
    //           lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Sales);
    //           lrc_PrintDocument.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //           IF lrc_PrintDocument.FIND('-') THEN
    //             REPEAT

    //               CASE lrc_PrintDocument."Multiple Entry for" OF

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Keine Mehrfachgenerierung
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::" ":
    //                   BEGIN
    //                     lrc_SalesCommentPrintDoc.Reset();
    //                     lrc_SalesCommentPrintDoc.INIT();
    //                     lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                     lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                     lrc_SalesCommentPrintDoc."Detail Code" := '';
    //                     lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                     lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                     lrc_SalesCommentPrintDoc.Print := TRUE;
    //                     lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                     lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                   END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::Location:
    //                   BEGIN
    //                     lin_ArrZähler := 1;
    //                     WHILE lin_ArrZähler <= 10 DO BEGIN
    //                       IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                          lrc_SalesCommentPrintDoc.Reset();
    //                          lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                          lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                          lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                          IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                            lrc_SalesCommentPrintDoc.Reset();
    //                            lrc_SalesCommentPrintDoc.INIT();
    //                            lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                            lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                            lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                            lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                            lrc_SalesCommentPrintDoc.Print := TRUE;
    //                            lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                            lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                          END;
    //                        END;
    //                        lin_ArrZähler := lin_ArrZähler + 1;
    //                     END;
    //                   END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Physisches Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::"Location Group":
    //                   BEGIN
    //                     lin_ArrZähler := 1;
    //                     WHILE lin_ArrZähler <= 10 DO BEGIN
    //                       IF lco_ArrPhysLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                         lrc_SalesCommentPrintDoc.Reset();
    //                         lrc_SalesCommentPrintDoc.INIT();
    //                         lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                         lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrPhysLocation[lin_ArrZähler];
    //                         lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                         lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_SalesCommentPrintDoc.Print := TRUE;
    //                         lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                         lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                       END;

    //                       lin_ArrZähler := lin_ArrZähler + 1;
    //                     END;
    //                   END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Abgangsregion
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::"Departure Region":
    //                   BEGIN
    //                     lin_ArrZähler := 1;
    //                     WHILE lin_ArrZähler <= 10 DO BEGIN
    //                           IF lco_ArrDepartRegion[lin_ArrZähler] <> '' THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                             lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                             lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrDepartRegion[lin_ArrZähler]);
    //                             IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                               lrc_SalesCommentPrintDoc.Reset();
    //                               lrc_SalesCommentPrintDoc.INIT();
    //                               lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                               lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                               lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrDepartRegion[lin_ArrZähler];
    //                               lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                               lrc_SalesCommentPrintDoc.Print := TRUE;
    //                               lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                               lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                             END;
    //                           END;
    //                       lin_ArrZähler := lin_ArrZähler + 1;
    //                     END;
    //                   END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Zusteller
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                   BEGIN
    //                     lin_ArrZähler := 1;
    //                     WHILE lin_ArrZähler <= 10 DO BEGIN
    //                       IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                         lrc_SalesCommentPrintDoc.Reset();
    //                         lrc_SalesCommentPrintDoc.INIT();
    //                         lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                         lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                         lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                         lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_SalesCommentPrintDoc.Print := TRUE;
    //                         lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                         lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                       END;
    //                       lin_ArrZähler := lin_ArrZähler + 1;
    //                     END;
    //                   END;

    //               END;

    //             UNTIL lrc_PrintDocument.NEXT() = 0;
    //         END;

    //         // F U S S B E M E R K U N G  Ü B E R T R A G E N
    //         lrc_SalesClaimComment.Reset();
    //         lrc_SalesClaimComment.SETRANGE("Document No.",vco_SalesClaimDocNo);
    //         lrc_SalesClaimComment.SETRANGE(Type,lrc_SalesClaimComment.Type::Footer);

    //         // DMG 001 DMG50000.s
    //         lrc_SalesClaimComment.SETRANGE( "Not Transfer To Credit Memo", FALSE );
    //         // DMG 001 DMG50000.e

    //         IF lrc_SalesClaimComment.FIND('-') THEN BEGIN

    //           // Kopfsatz Bemerkung anlegen
    //           lrc_SalesComment.Reset();
    //           lrc_SalesComment.INIT();
    //           lrc_SalesComment."Entry No." := 0;
    //           lrc_SalesComment."Entry Type" := lrc_SalesComment."Entry Type"::Header;
    //           lrc_SalesComment."Line No." := 0;
    //           lrc_SalesComment."Document Source" := lrc_SalesComment."Document Source"::Header;

    //           lrc_SalesComment."Document Type" := lrc_SalesHeader."Document Type";
    //           lrc_SalesComment."Document No." := lrc_SalesHeader."No.";
    //           lrc_SalesComment."Document Line No." := vin_DocLineNo;

    //           lrc_SalesComment.Placement := lrc_SalesComment.Placement::Footer;
    //           lrc_SalesComment.Comment := lrc_SalesClaimComment.Comment;
    //           lrc_SalesComment.INSERT(TRUE);

    //           REPEAT
    //           /*
    //             lrc_NewSalesComment.INIT();
    //             lrc_NewSalesComment."Entry No." := lrc_SalesComment."Entry No.";
    //             lrc_NewSalesComment."Entry Type" := lrc_NewSalesComment."Entry Type"::Line;
    //             lrc_NewSalesComment."Line No." := lrc_SalesClaimComment."Line No.";
    //             lrc_NewSalesComment.Placement := lrc_SalesComment.Placement;
    //             lrc_NewSalesComment.Comment := lrc_SalesClaimComment.Comment;
    //             lrc_NewSalesComment.insert();
    //             */
    //             lrc_NewSalesComment.INIT();
    //             lrc_NewSalesComment."Entry No." := lrc_SalesComment."Entry No.";
    //             lrc_NewSalesComment."Entry Type" := lrc_NewSalesComment."Entry Type"::Line;
    //             lrc_NewSalesComment."Document Type" := lrc_SalesComment."Document Type";
    //             lrc_NewSalesComment."Document No." := lrc_SalesComment."Document No.";
    //             lrc_NewSalesComment."Document Source" := lrc_NewSalesComment."Document Source"::Header;

    //             lrc_NewSalesComment."Line No." := lrc_SalesClaimComment."Line No.";
    //             lrc_NewSalesComment.Placement := lrc_SalesComment.Placement;
    //             lrc_NewSalesComment.Comment := lrc_SalesClaimComment.Comment;
    //             lrc_NewSalesComment.insert();


    //           UNTIL lrc_SalesClaimComment.NEXT(1) = 0;

    //           // Filter mit Filtergruppe setzen
    //           lrc_SalesComment.FILTERGROUP(2);
    //           lrc_SalesComment.SETRANGE("Entry No.",lrc_SalesComment."Entry No.");
    //           lrc_SalesComment.SETRANGE("Entry Type",lrc_SalesComment."Entry Type");
    //           lrc_SalesComment.SETRANGE("Line No.",lrc_SalesComment."Line No.");
    //           lrc_SalesComment.FILTERGROUP(0);

    //           // Druckbelege Laden für die Bemerkungen erfaßt werden können
    //           lrc_PrintDocument.Reset();
    //           lrc_PrintDocument.SETRANGE("Document Source",lrc_PrintDocument."Document Source"::Sales);
    //           lrc_PrintDocument.SETRANGE("Document Type",lrc_SalesHeader."Document Type");
    //           IF lrc_PrintDocument.FIND('-') THEN
    //             REPEAT

    //               CASE lrc_PrintDocument."Multiple Entry for" OF

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Keine Mehrfachgenerierung
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::" ":
    //                   BEGIN
    //                     lrc_SalesCommentPrintDoc.Reset();
    //                     lrc_SalesCommentPrintDoc.INIT();
    //                     lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                     lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                     lrc_SalesCommentPrintDoc."Detail Code" := '';
    //                     lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                     lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                     lrc_SalesCommentPrintDoc.Print := TRUE;
    //                     lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                     lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                   END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::Location:
    //                   BEGIN
    //                     lin_ArrZähler := 1;
    //                     WHILE lin_ArrZähler <= 10 DO BEGIN
    //                       IF lco_ArrLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                          lrc_SalesCommentPrintDoc.Reset();
    //                          lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                          lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                          lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrLocation[lin_ArrZähler]);
    //                          IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                            lrc_SalesCommentPrintDoc.Reset();
    //                            lrc_SalesCommentPrintDoc.INIT();
    //                            lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                            lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                            lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrLocation[lin_ArrZähler];
    //                            lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                            lrc_SalesCommentPrintDoc.Print := TRUE;
    //                            lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                            lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                          END;
    //                        END;
    //                        lin_ArrZähler := lin_ArrZähler + 1;
    //                     END;
    //                   END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Physisches Lager
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::"Location Group":
    //                   BEGIN
    //                     lin_ArrZähler := 1;
    //                     WHILE lin_ArrZähler <= 10 DO BEGIN
    //                       IF lco_ArrPhysLocation[lin_ArrZähler] <> '' THEN BEGIN
    //                         lrc_SalesCommentPrintDoc.Reset();
    //                         lrc_SalesCommentPrintDoc.INIT();
    //                         lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                         lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrPhysLocation[lin_ArrZähler];
    //                         lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                         lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_SalesCommentPrintDoc.Print := TRUE;
    //                         lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                         lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                       END;

    //                       lin_ArrZähler := lin_ArrZähler + 1;
    //                     END;
    //                   END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Abgangsregion
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::"Departure Region":
    //                   BEGIN
    //                     lin_ArrZähler := 1;
    //                     WHILE lin_ArrZähler <= 10 DO BEGIN
    //                           IF lco_ArrDepartRegion[lin_ArrZähler] <> '' THEN BEGIN
    //                             lrc_SalesCommentPrintDoc.Reset();
    //                             lrc_SalesCommentPrintDoc.SETRANGE("Sales Comment Entry No.",lrc_SalesComment."Entry No.");
    //                             lrc_SalesCommentPrintDoc.SETRANGE("Print Document Code",lrc_PrintDocument.Code);
    //                             lrc_SalesCommentPrintDoc.SETRANGE("Detail Code",lco_ArrDepartRegion[lin_ArrZähler]);
    //                             IF NOT lrc_SalesCommentPrintDoc.FIND('-') THEN BEGIN
    //                               lrc_SalesCommentPrintDoc.Reset();
    //                               lrc_SalesCommentPrintDoc.INIT();
    //                               lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                               lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                               lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrDepartRegion[lin_ArrZähler];
    //                               lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                               lrc_SalesCommentPrintDoc.Print := TRUE;
    //                               lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                               lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                             END;
    //                           END;
    //                       lin_ArrZähler := lin_ArrZähler + 1;
    //                     END;
    //                   END;

    //                 // ----------------------------------------------------------------------------------------------
    //                 // Mehrfachgenerierung Zusteller
    //                 // ----------------------------------------------------------------------------------------------
    //                 lrc_PrintDocument."Multiple Entry for"::"Shipping Agent":
    //                   BEGIN
    //                     lin_ArrZähler := 1;
    //                     WHILE lin_ArrZähler <= 10 DO BEGIN
    //                       IF lco_ArrShippingAgent[lin_ArrZähler] <> '' THEN BEGIN
    //                         lrc_SalesCommentPrintDoc.Reset();
    //                         lrc_SalesCommentPrintDoc.INIT();
    //                         lrc_SalesCommentPrintDoc."Sales Comment Entry No." := lrc_SalesComment."Entry No.";
    //                         lrc_SalesCommentPrintDoc."Print Document Code" := lrc_PrintDocument.Code;
    //                         lrc_SalesCommentPrintDoc."Detail Code" := lco_ArrShippingAgent[lin_ArrZähler];
    //                         lrc_SalesCommentPrintDoc."Multiple Entry for" := lrc_PrintDocument."Multiple Entry for";
    //                         lrc_SalesCommentPrintDoc."Print Document Description" := lrc_PrintDocument.Description;
    //                         lrc_SalesCommentPrintDoc.Print := TRUE;
    //                         lrc_SalesCommentPrintDoc."Posted Doc. Type" := lrc_PrintDocument."Posted Document Type";
    //                         lrc_SalesCommentPrintDoc.INSERT(TRUE);
    //                       END;
    //                       lin_ArrZähler := lin_ArrZähler + 1;
    //                     END;
    //                   END;

    //               END;

    //             UNTIL lrc_PrintDocument.NEXT() = 0;
    //         END;

    //         // Erste Zeile in Kopfsatz generieren
    //         //SalesSetCommentFirstLine(lrc_SalesComment."Entry No.");
    //         //KHH 006 KHH50291.e

    //     end;

    //     procedure "-- EXT STANDARD COMMENT --"()
    //     begin
    //     end;

    //     procedure ExtStandardComment(vop_TableName: Option "G/L Account",Customer,Vendor,Item,Resource,Job,,"Resource Group","Bank Account",Campaign,"Fixed Asset",Insurance,"Nonstock Item","IC Partner",,,,,,,"Batch Variant","Item Requisition",Batch,"Master Batch";vco_CommentTypeCode: Code[10];vco_TableKeyFieldCode: Code[20])
    //     var
    //         lrc_CommentType: Record "5110526";
    //         lrc_CommentLine: Record "97";
    //         lfm_CommentType: Form "5110535";
    //         lfm_CommentSheet: Form "124";
    //     begin
    //         // ----------------------------------------------------------------------------------------------------
    //         //
    //         // ----------------------------------------------------------------------------------------------------
    //         //RS Table Comment Type gibt es nicht
    //         //Funktion nur in der Tourenplanung verwendet, auskommentiert
    //         /*
    //         IF vco_CommentTypeCode = '' THEN BEGIN
    //           lrc_CommentType.Reset();
    //           lrc_CommentType.SETRANGE("Table Name",vop_TableName);
    //           IF NOT lrc_CommentType.isempty()THEN BEGIN
    //             lfm_CommentType.LOOKUPMODE := TRUE;
    //             lfm_CommentType.EDITABLE := FALSE;
    //             IF lfm_CommentType.RUNMODAL <> ACTION::LookupOK THEN
    //               EXIT;
    //             lrc_CommentType.Reset();
    //             lfm_CommentType.GETRECORD(lrc_CommentType);
    //             vco_CommentTypeCode := lrc_CommentType.Code;
    //           END;
    //         END;

    //         lrc_CommentLine.Reset();
    //         lrc_CommentLine.SETRANGE("Table Name",vop_TableName);
    //         lrc_CommentLine.SETRANGE("No.",vco_TableKeyFieldCode);
    //         lrc_CommentLine.SETRANGE(Code,vco_CommentTypeCode);
    //         lfm_CommentSheet.SETTABLEVIEW(lrc_CommentLine);
    //         lfm_CommentSheet.RUNMODAL;
    //         */

    //     end;

    var
        lrc_CustVendComment: Record "POI Cust./Vend. Ext.Comment";
        lrc_CustVendCommentPrintDoc: Record "POI Cust./Vend. Ext.Comm. Doc.";
        lrc_PurchComment: Record "POI Purch. Ext.Comment";
        lrc_PurchCommentPrintDoc: Record "POI Purch. Ext.Comment Doc.";
        lrc_FreightComment: Record "POI Freight Ext. Comment";
        lrc_FreightCommentPrintDoc: Record "POI Freight Ext Comment Doc.";
}

