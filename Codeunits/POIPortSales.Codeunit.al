codeunit 5110797 "POI Port_Sales"
{

    //     trigger OnRun()
    //     begin
    //         Choicetext:= (       'Rekla-Übertrag'
    //                         +','+'Frachtraten_PLZ_sammeln'
    //                       );
    //         OptioNo:=STRMENU(Choicetext,1);
    //         CASE OptioNo OF
    //           1: BEGIN
    //             VK_Rekla_DatenUebertrag();
    //           END;
    //           2:BEGIN
    //             Frachtraten_PLZ_sammeln();
    //           END;
    //         END;
    //     end;

    var
        i: Integer;
    //         u: Integer;
    //         Choicetext: Text[500];
    //         OptioNo: Integer;
    //         DDialog: Dialog;
    //         FileName: Text[300];
    //         FFile: File;
    //         "***Port Variable Eingabe": Integer;
    //         "frmPort Vari": Form "50055";
    //         textVari1: Text[30];
    //         textVari2: Text[30];
    //         textVari3: Text[30];
    //         BoolVari1: Boolean;
    //         TestCode: Code[20];
    //         DatumVon: Date;
    //         DatumBis: Date;
    //         "***": Integer;

    //     procedure VK_OpenVKOrderNr(lcd_OrderNo: Code[20])
    //     var
    //         "lrc_Sales Header": Record "36";
    //         "lfm_ADF Sales Order": Form "5110321";
    //         "lrcSales Invoice Header": Record "112";
    //         "lfm_Posted Sales Invoice": Form "132";
    //         "lfm_ADF Posted Sales Invoices": Form "5110625";
    //     begin
    //         "lrc_Sales Header".SETRANGE("No.",lcd_OrderNo);
    //         IF "lrc_Sales Header".FINDFIRST() THEN BEGIN
    //           CLEAR("lfm_ADF Sales Order");
    //           "lfm_ADF Sales Order".SETRECORD:="lrc_Sales Header";
    //           "lfm_ADF Sales Order".SETTABLEVIEW:="lrc_Sales Header";
    //           "lfm_ADF Sales Order".LOOKUPMODE:=TRUE;
    //           IF "lfm_ADF Sales Order".RUNMODAL = ACTION::LookupOK THEN BEGIN
    //             "lfm_ADF Sales Order".GETRECORD("lrc_Sales Header");
    //           END;
    //           CLEAR("lfm_ADF Sales Order");
    //         END ELSE BEGIN
    //           "lrcSales Invoice Header".SETRANGE("Order No.",lcd_OrderNo);
    //           IF "lrcSales Invoice Header".FINDFIRST() THEN BEGIN
    //             IF "lrcSales Invoice Header".COUNT = 1 THEN BEGIN
    //               //Rechnungsform öffnen
    //               CLEAR("lfm_Posted Sales Invoice");
    //               "lfm_Posted Sales Invoice".SETRECORD:="lrcSales Invoice Header";
    //               "lfm_Posted Sales Invoice".SETTABLEVIEW:="lrcSales Invoice Header";
    //               "lfm_Posted Sales Invoice".LOOKUPMODE:=TRUE;
    //               IF "lfm_Posted Sales Invoice".RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                 "lfm_Posted Sales Invoice".GETRECORD("lrcSales Invoice Header");
    //               END;
    //               CLEAR("lfm_Posted Sales Invoice");
    //             END ELSE BEGIN
    //               //Rechnungsübersicht öffnen
    //               CLEAR("lfm_ADF Posted Sales Invoices");
    //               "lfm_ADF Posted Sales Invoices".SETRECORD:="lrcSales Invoice Header";
    //               "lfm_ADF Posted Sales Invoices".SETTABLEVIEW:="lrcSales Invoice Header";
    //               "lfm_ADF Posted Sales Invoices".LOOKUPMODE:=TRUE;
    //               IF "lfm_ADF Posted Sales Invoices".RUNMODAL = ACTION::LookupOK THEN BEGIN
    //                 "lfm_ADF Posted Sales Invoices".GETRECORD("lrcSales Invoice Header");
    //               END;
    //               CLEAR("lfm_ADF Posted Sales Invoices");
    //             END;
    //           END ELSE BEGIN
    //             MESSAGE('Weder Auftrag noch Rechnung zu %1 gefunden, bitte prüfen',lcd_OrderNo);
    //           END;
    //         END;
    //     end;

    //     procedure VK_Post_ControlLVATID(var vrc_SalesHeader: Record "36"): Boolean
    //     var
    //         lrc_Customer: Record "Customer";
    //         lcu_Port_System: Codeunit "5110798";
    //         "lrc_Port Setup II": Record "50005";
    //     begin
    //         //POI 001 DEBVAT   JST 030214 001 Verkauf buchen trotz DEB ohne VAT und ohne Steuernmummer
    //         "lrc_Port Setup II".GET();
    //         IF "lrc_Port Setup II"."VK CheckVAT" THEN BEGIN
    //           IF vrc_SalesHeader."VAT Registration No." = '' THEN BEGIN
    //             lrc_Customer.GET(vrc_SalesHeader."Bill-to Customer No.");
    //             IF (lrc_Customer."VAT Registration No." = '') AND (lrc_Customer."Tax Registration No." = '') THEN BEGIN
    //               IF NOT lcu_Port_System.Permit_Groups('DARFVKBUCHOHNEVAT') THEN
    //                 EXIT(FALSE);
    //             END;
    //           END;
    //         END;
    //         //Wenn bis hier gekommen, ist eine VAT oder Steuernummer vorhanden oder Benutzer darf auch ohne buchen
    //         EXIT(TRUE);
    //     end;

    //     procedure VK_CalcSales(var vrc_SalesHeader: Record "36";Buchen: Boolean;drucken: Boolean)
    //     var
    //         "lcu_Sales Mgt": Codeunit "5110324";
    //         choiceTyp: Text[30];
    //         "--RS Kostenarten": Integer;
    //         lrc_GeneralLedgerSetup: Record "98";
    //         lrc_SalesLine: Record "37";
    //         lrc_GeneralPostingSetup: Record "252";
    //         text01: Label 'Buchungsmatrixeinrichtung existiert nicht zu Geschäftsbuchungsgruppe %1, Produktbuchungsgruppe %2';
    //         lrc_GLAccount: Record "G/L Account";
    //     begin
    //         //Aufruf von Formular VK-Kopf VK-Gutschrift z.B. beim F9 Statistik  Drucken und/oder F11 buchen

    //         //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
    //         choiceTyp:=FORMAT(vrc_SalesHeader."Document Type");
    //         IF Buchen THEN BEGIN
    //           CASE choiceTyp OF
    //             'Credit Memo': BEGIN //Buchen bis jetzt nur bei Gutschrift autom. Calc (mit Rabatt ziehen)
    //               COMMIT;
    //               "lcu_Sales Mgt".CalcSalesOrder(vrc_SalesHeader);
    //               COMMIT;
    //             END;
    //             'Sales Invoice': BEGIN //RS Erweiterung um Sales Invoice
    //               COMMIT;
    //               "lcu_Sales Mgt".CalcSalesOrder(vrc_SalesHeader);
    //               COMMIT;
    //             END;
    //             ELSE BEGIN
    //               //REst
    //             END;
    //           END;
    //         END ELSE BEGIN //Nicht buchen
    //          COMMIT;
    //          "lcu_Sales Mgt".CalcSalesOrder(vrc_SalesHeader);
    //          COMMIT;
    //         END;

    //         //RS laden von Kostenart
    //         lrc_GeneralLedgerSetup.GET();
    //         IF lrc_GeneralLedgerSetup."Global Dimension 2 Code" = 'KOSTENART' THEN BEGIN
    //           lrc_SalesLine.Reset();
    //           lrc_SalesLine.SETRANGE("Document No.", vrc_SalesHeader."No.");
    //           lrc_SalesLine.SETRANGE("Document Type", vrc_SalesHeader."Document Type");
    //           IF lrc_SalesLine.FINDSET() THEN BEGIN
    //             REPEAT
    //               IF lrc_SalesLine."Shortcut Dimension 2 Code" = '' THEN BEGIN
    //                 IF lrc_SalesLine.Type = lrc_SalesLine.Type:: Item THEN BEGIN
    //                   IF NOT lrc_GeneralPostingSetup.GET(lrc_SalesLine."Gen. Bus. Posting Group",
    //                                                      lrc_SalesLine."Gen. Prod. Posting Group") THEN BEGIN
    //                     ERROR(text01, lrc_SalesLine."Gen. Bus. Posting Group",lrc_SalesLine."Gen. Prod. Posting Group");
    //                   END ELSE BEGIN
    //                     IF vrc_SalesHeader."Document Type" = vrc_SalesHeader."Document Type"::"Credit Memo" THEN BEGIN
    //                         lrc_GLAccount.GET(lrc_GeneralPostingSetup."Sales Credit Memo Account");
    //                         lrc_SalesLine.VALIDATE(lrc_SalesLine."Shortcut Dimension 2 Code", lrc_GLAccount."Global Dimension 2 Code");
    //                         lrc_SalesLine.Modify();
    //                     END ELSE BEGIN
    //                       lrc_GLAccount.GET(lrc_GeneralPostingSetup."Sales Account");
    //                       lrc_SalesLine.VALIDATE(lrc_SalesLine."Shortcut Dimension 2 Code", lrc_GLAccount."Global Dimension 2 Code");
    //                       lrc_SalesLine.Modify();
    //                     END;
    //                   END;
    //                 END;
    //               END;
    //             UNTIL lrc_SalesLine.NEXT() = 0;
    //           END;
    //           COMMIT;
    //         END;
    //     end;

    //     procedure VK_SaleslineGetPurchase("vrc_Sales Line": Record "37";var "vrc_Purchase Line": Record "39") ok: Boolean
    //     var
    //         lrc_SalesLine: Record "37";
    //         lrc_BatchVariant: Record "5110366";
    //         lrc_PackOrderRevperInpBatch: Record "5110726";
    //         AlleInputPartie: Integer;
    //         MerkeInputBatchVarNo: Code[20];
    //         FoundMoreInputBatchVar: Boolean;
    //     begin
    //         ok:=FALSE;
    //         "vrc_Purchase Line".INIT();
    //         "vrc_Purchase Line".Reset();
    //         lrc_BatchVariant.SETRANGE("No.","vrc_Sales Line"."Batch Variant No.");
    //         IF NOT lrc_BatchVariant.FIND('-') THEN EXIT;
    //         //,Purch. Order,Packing Order,Sorting Order,,Item Journal Line,Inventory Journal Line,,,Company Copy,,,Dummy
    //         CASE lrc_BatchVariant.Source OF
    //              lrc_BatchVariant.Source::"Purch. Order" : BEGIN
    //                "vrc_Purchase Line".SETRANGE("Document No.",lrc_BatchVariant."Source No.");
    //                "vrc_Purchase Line".SETRANGE("Batch Variant No.",lrc_BatchVariant."No.");
    //                "vrc_Purchase Line".SETRANGE("Line No.",lrc_BatchVariant."Source Line No.");
    //                IF "vrc_Purchase Line".FINDFIRST() THEN BEGIN
    //                  ok:=TRUE;
    //                END;
    //              END;
    //              lrc_BatchVariant.Source::"Packing Order" : BEGIN
    //                lrc_PackOrderRevperInpBatch.SETRANGE("Output Batch Variant No.",lrc_BatchVariant."No.");
    //                lrc_PackOrderRevperInpBatch.SETRANGE("Doc. No.",lrc_BatchVariant."Source No.");
    //                IF lrc_PackOrderRevperInpBatch.FIND('-') THEN BEGIN
    //                  //Verschachtelter Pack ?
    //                  //lrc_BatchVariant.SETRANGE("No.",");
    //                  //case lrc_BatchVariant.Source OF

    //                  IF lrc_PackOrderRevperInpBatch.COUNT = 1 THEN BEGIN
    //                    "vrc_Purchase Line".SETRANGE("Master Batch No.",lrc_PackOrderRevperInpBatch."Input Master Batch No.");
    //                    "vrc_Purchase Line".SETRANGE("Batch No.",lrc_PackOrderRevperInpBatch."Input Batch No.");
    //                    "vrc_Purchase Line".SETRANGE("Batch Variant No.",lrc_PackOrderRevperInpBatch."Input Batch Variant No.");
    //                    //lrc_PackOrderRevperInpBatch."Input Location Code"
    //                    IF "vrc_Purchase Line".FIND('-') THEN BEGIN
    //                      ok:=TRUE;
    //                    END;
    //                  END ELSE BEGIN
    //                    //Mehrere Inputs ?? alle von einer Partie ?? dann ok und eindeutig zuodnenbar
    //                    //POI 001 PACKPurc JST 181213 001 Änderungen
    //                    //                                PackInput alle von der gleichen Partie -> OK,
    //                    FoundMoreInputBatchVar:=FALSE;
    //                    MerkeInputBatchVarNo := lrc_PackOrderRevperInpBatch."Input Batch Variant No.";
    //                    REPEAT
    //                      IF MerkeInputBatchVarNo <> lrc_PackOrderRevperInpBatch."Input Batch Variant No." THEN
    //                                   FoundMoreInputBatchVar:=TRUE;
    //                    UNTIL lrc_PackOrderRevperInpBatch.NEXT() = 0;
    //                    IF NOT FoundMoreInputBatchVar THEN BEGIN
    //                      "vrc_Purchase Line".SETRANGE("Master Batch No.",lrc_PackOrderRevperInpBatch."Input Master Batch No.");
    //                      "vrc_Purchase Line".SETRANGE("Batch No.",lrc_PackOrderRevperInpBatch."Input Batch No.");
    //                      "vrc_Purchase Line".SETRANGE("Batch Variant No.",lrc_PackOrderRevperInpBatch."Input Batch Variant No.");
    //                      //lrc_PackOrderRevperInpBatch."Input Location Code"
    //                      IF "vrc_Purchase Line".FIND('-') THEN BEGIN
    //                        ok:=TRUE;
    //                      END;
    //                    END;
    //                  END;
    //                END;
    //              END;
    //         END;
    //     end;

    //     procedure VK_ReklamationFormatUeberischt(var vrc_SalesClaimNotifyHeader: Record "5110455";var vin_FormatColor: Integer;var vbo_FormatBold: Boolean;var vboUpdateSelected: Boolean): Boolean
    //     begin
    //         //Fkt. veranlasst Formatierung der Reklamationsübersicht
    //         //IF vrc_SalesClaimNotifyHeader."Claim Date" < (TODAY-14)
    //         IF    (vrc_SalesClaimNotifyHeader."Claim Date" < (TODAY - 14))
    //            AND(   (vrc_SalesClaimNotifyHeader."Claim Status" = vrc_SalesClaimNotifyHeader."Claim Status"::erfasst)
    //                 OR(vrc_SalesClaimNotifyHeader."Claim Status" = vrc_SalesClaimNotifyHeader."Claim Status"::Kreditormeldung)
    //               )
    //           THEN BEGIN
    //             vrc_SalesClaimNotifyHeader.CALCFIELDS("Sales Cr. Memo No.");
    //             IF vrc_SalesClaimNotifyHeader."Sales Cr. Memo No." = '' THEN BEGIN
    //               //vboUpdateSelected:=TRUE;   //markieren ??
    //               vin_FormatColor:=255;       //Rot + (256 * Grün) + (256 * 256 * Blau)
    //               vbo_FormatBold:=TRUE;
    //               EXIT(TRUE);
    //             END ELSE BEGIN
    //               //vboUpdateSelected:=TRUE;   //markieren ??
    //               vin_FormatColor:=256*256*255;       //Rot + (256 * Grün) + (256 * 256 * Blau)
    //               vbo_FormatBold:=TRUE;
    //               EXIT(TRUE);
    //             END;
    //         END ELSE BEGIN
    //           EXIT(FALSE);
    //         END;
    //     end;

    //     procedure VK_ReklaHeaderLookupPartie(MasterBatchNo: Code[20];ReklaNo: Code[20])
    //     var
    //         lrc_PackOrderHeader: Record "5110712";
    //         frm_StdPackOrderCard: Form "5110740";
    //         "lrc_Purchase Header": Record "38";
    //         FrmADFPurchaseOrderFruit: Form "50016";
    //     begin
    //         IF MasterBatchNo = '' THEN EXIT;
    //         "lrc_Purchase Header".SETRANGE("No.",MasterBatchNo);
    //         IF "lrc_Purchase Header".FINDFIRST() THEN BEGIN
    //           CLEAR(FrmADFPurchaseOrderFruit);
    //           FrmADFPurchaseOrderFruit.SETRECORD:="lrc_Purchase Header";
    //           FrmADFPurchaseOrderFruit.SETTABLEVIEW:="lrc_Purchase Header";
    //           FrmADFPurchaseOrderFruit.LOOKUPMODE:=TRUE;
    //           IF FrmADFPurchaseOrderFruit.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //             FrmADFPurchaseOrderFruit.GETRECORD("lrc_Purchase Header");
    //           END;
    //           CLEAR(FrmADFPurchaseOrderFruit);
    //         END ELSE BEGIN
    //           //Packauftrag ??
    //           lrc_PackOrderHeader.SETRANGE("Master Batch No.",MasterBatchNo);
    //           IF NOT lrc_PackOrderHeader.FINDFIRST() THEN ERROR('Partie/Einkauf/Pack %1 nicht gefunden',MasterBatchNo);
    //           CLEAR(frm_StdPackOrderCard);
    //           frm_StdPackOrderCard.SETRECORD:=lrc_PackOrderHeader;
    //           frm_StdPackOrderCard.SETTABLEVIEW:=lrc_PackOrderHeader;
    //           frm_StdPackOrderCard.LOOKUPMODE:=TRUE;
    //           IF frm_StdPackOrderCard.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //             frm_StdPackOrderCard.GETRECORD(lrc_PackOrderHeader);
    //           END;
    //           CLEAR(frm_StdPackOrderCard);
    //         END;
    //     end;

    //     procedure VK_ReklaHeaderLookupEKBE(var vrc_SalesClaimNotifyHeader: Record "5110455")
    //     var
    //         VendorOrderNo: Code[20];
    //         "lrc_Purchase Header": Record "38";
    //         FrmADFPurchaseOrderFruit: Form "50016";
    //     begin

    //         //Freigabe löschen
    //         VendorOrderNo:=vrc_SalesClaimNotifyHeader."Vendor Order No.";
    //         IF VendorOrderNo = '' THEN EXIT;
    //         "lrc_Purchase Header".SETRANGE("No.",VendorOrderNo);
    //         IF "lrc_Purchase Header".FINDFIRST() THEN BEGIN
    //           CLEAR(FrmADFPurchaseOrderFruit);
    //           FrmADFPurchaseOrderFruit.SETRECORD:="lrc_Purchase Header";
    //           FrmADFPurchaseOrderFruit.SETTABLEVIEW:="lrc_Purchase Header";
    //           FrmADFPurchaseOrderFruit.LOOKUPMODE:=TRUE;
    //           IF FrmADFPurchaseOrderFruit.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //             FrmADFPurchaseOrderFruit.GETRECORD("lrc_Purchase Header");
    //           END;
    //           CLEAR(FrmADFPurchaseOrderFruit);
    //         END ELSE BEGIN
    //           ERROR('Einkauf %1 nicht gefunden',VendorOrderNo);
    //         END;
    //     end;

    //     procedure VK_ReklaLineLookupEKBE(var vrc_SalesClaimNotifyLine: Record "5110456")
    //     var
    //         VendorOrderNo: Code[20];
    //         "lrc_Purchase Header": Record "38";
    //         FrmADFPurchaseOrderFruit: Form "50016";
    //     begin
    //         VendorOrderNo:=vrc_SalesClaimNotifyLine."Vendor Order No.";
    //         IF VendorOrderNo = '' THEN EXIT;
    //         "lrc_Purchase Header".SETRANGE("No.",VendorOrderNo);
    //         IF "lrc_Purchase Header".FINDFIRST() THEN BEGIN
    //           CLEAR(FrmADFPurchaseOrderFruit);
    //           FrmADFPurchaseOrderFruit.SETRECORD:="lrc_Purchase Header";
    //           FrmADFPurchaseOrderFruit.SETTABLEVIEW:="lrc_Purchase Header";
    //           FrmADFPurchaseOrderFruit.LOOKUPMODE:=TRUE;
    //           IF FrmADFPurchaseOrderFruit.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //             FrmADFPurchaseOrderFruit.GETRECORD("lrc_Purchase Header");
    //           END;
    //           CLEAR(FrmADFPurchaseOrderFruit);
    //         END ELSE BEGIN
    //           //Behandlung Packauftrag -> Umsetzen in Input-Order zum EIntrag der Ursprungs-Einkaufbestellung
    //           MESSAGE('Hier kommt noch die Umsetzung zu den Input-Artikel des Packauftrages');
    //         END;
    //     end;

    procedure VK_ReklaLineGiveEKBENo(MasterBatchNo: Code[20]; var BuyfromVendorNo: Code[20]; var VendorOrderNo: Code[20]; var IstPack: Boolean; var PackEindeutig: Boolean) ok: Boolean
    var
        lrc_TempPuffer: Record "Currency Total Buffer" temporary;
        lrc_TempPufferVendor: Record "Currency Total Buffer" temporary;
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
    begin
        //Fkt gibt Ursprungs-Einkaufsbestellnr. des Vendor
        ok := FALSE;
        VendorOrderNo := MasterBatchNo;
        IstPack := FALSE;
        PackEindeutig := FALSE;
        BuyfromVendorNo := '';

        IF MasterBatchNo = '' THEN EXIT;
        lrc_PurchaseHeader.SETRANGE("No.", VendorOrderNo);
        IF lrc_PurchaseHeader.FINDFIRST() THEN BEGIN
            BuyfromVendorNo := lrc_PurchaseHeader."Buy-from Vendor No.";
            VendorOrderNo := MasterBatchNo;
            ok := TRUE;
            EXIT;
        END ELSE BEGIN
            IstPack := TRUE;
            lrc_PackOrderHeader.SETRANGE("Master Batch No.", MasterBatchNo);
            IF not lrc_PackOrderHeader.IsEmpty() THEN BEGIN
                IstPack := TRUE;
                lrc_PackOrderInputItems.SETRANGE("Master Batch No.", MasterBatchNo);
                IF lrc_PackOrderInputItems.FINDFIRST() THEN BEGIN
                    REPEAT
                        lrc_TempPuffer.UpdateTotal(copystr(lrc_PackOrderInputItems."Master Batch No.", 1, 10), 1, 1, i);
                        lrc_PurchaseHeader.SETRANGE("No.", lrc_PackOrderInputItems."Master Batch No.");
                        IF lrc_PurchaseHeader.FINDFIRST()
                          THEN
                            lrc_TempPufferVendor.UpdateTotal(copystr(lrc_PurchaseHeader."Buy-from Vendor No.", 1, 10), 1, 1, i)
                    UNTIL lrc_PackOrderInputItems.NEXT() = 0;
                    IF lrc_TempPuffer.COUNT() = 1 THEN BEGIN
                        PackEindeutig := tRUE; //Gibt mehrere Partie-Input-Item
                        VendorOrderNo := lrc_PackOrderInputItems."Master Batch No.";
                    END ELSE
                        PackEindeutig := FALSE; //Gibt mehrere Partie-Input-Item
                    IF lrc_TempPufferVendor.COUNT() = 1 THEN
                        BuyfromVendorNo := lrc_TempPufferVendor."Currency Code";
                END;
            END;
        END;
    end;

    //     procedure VK_ReklaHaederPartieEintrag(var vrc_SalesClaimNotifyLine: Record "5110456";var vrc_SalesClaimNotifyHeader: Record "5110455")
    //     var
    //         lrc_PurchaseHeader: Record "38";
    //         lrc_SalesShipmentLine: Record "111";
    //         lrc_SalesClaimNotifyLine: Record "5110456";
    //     begin

    //         //Verkaufsauftrag -> Lieferung holen
    //         //lrc_SalesShipmentLine.Reset();
    //         //IF vrc_SalesClaimNotifyLine."Sales Order No." <> '' THEN Error('Keine Auftragsnummer in Reklamationszeile');
    //         //lrc_SalesShipmentLine.SETRANGE("Order No.",vrc_SalesClaimNotifyLine."Sales Order No.");
    //         //lrc_SalesShipmentLine.SETRANGE(Type,lrc_SalesShipmentLine.Type::Item);
    //         //lrc_SalesShipmentLine.SETFILTER("No.",'<>%1','');
    //         //lrc_SalesShipmentLine.SETFILTER(Quantity,'<>%1',0);
    //         //lrc_SalesShipmentLine.SETRANGE(Correction,FALSE);
    //         //IF lrc_SalesShipmentLine.FIND('-') THEN BEGIN
    //         //  REPEAT
    //         //  UNTIL lrc_SalesShipmentLine.NEXT() = 0;
    //         //END ELSE BEGIN
    //         //END;

    //         IF vrc_SalesClaimNotifyLine.Claim THEN BEGIN
    //           lrc_SalesClaimNotifyLine:=vrc_SalesClaimNotifyLine;
    //           lrc_SalesClaimNotifyLine.SETRANGE("Document No.",vrc_SalesClaimNotifyLine."Document No.");
    //           lrc_SalesClaimNotifyLine.SETRANGE(Claim,TRUE);
    //           IF lrc_SalesClaimNotifyLine.FIND('-') THEN BEGIN
    //             IF lrc_SalesClaimNotifyLine.COUNT > 1 THEN BEGIN
    //               REPEAT
    //                 IF lrc_SalesClaimNotifyLine."Master Batch No." <> vrc_SalesClaimNotifyLine."Master Batch No."
    //                   THEN ERROR('Reklamation %1 verschiedener Partien nicht möglich',vrc_SalesClaimNotifyLine."Document No.");
    //               UNTIL lrc_SalesClaimNotifyLine.NEXT() = 0;
    //             END;
    //           END;
    //           IF vrc_SalesClaimNotifyLine."Master Batch No." = '' THEN ERROR('Keine Partie in Reklamationszeile %1 eingetagen',
    //                                                                        vrc_SalesClaimNotifyLine."Document No.");
    //           lrc_PurchaseHeader.SETRANGE("No.",vrc_SalesClaimNotifyLine."Master Batch No.");
    //           IF NOT lrc_PurchaseHeader.FINDFIRST() THEN ERROR('EK-Bestellung %1 nicht gefunden',vrc_SalesClaimNotifyLine."Master Batch No.");
    //           vrc_SalesClaimNotifyHeader."Claim Location Code":=vrc_SalesClaimNotifyLine."Claim Location Code";
    //           vrc_SalesClaimNotifyHeader."Location Code":=vrc_SalesClaimNotifyLine."Location Code";
    //           vrc_SalesClaimNotifyHeader."Claim Shipping Agent Code":=vrc_SalesClaimNotifyLine."Claim Shipping Agent Code";
    //           vrc_SalesClaimNotifyHeader."Shipping Agent Code":=vrc_SalesClaimNotifyLine."Shipping Agent Code";

    //           vrc_SalesClaimNotifyHeader."Master Batch No.":=vrc_SalesClaimNotifyLine."Master Batch No.";     //Partienr.
    //           vrc_SalesClaimNotifyHeader."Buy-from Vendor No.":=lrc_PurchaseHeader."Buy-from Vendor No.";  //Eink. von Kred.-Nr.
    //           vrc_SalesClaimNotifyHeader.MODIFY(TRUE);
    //         END;
    //     end;

    //     procedure VK_ReklaLineClaimChange(lrc_SalesClaimNotifyLine: Record "5110456";lrc_SalesClaimNotifyHeader: Record "5110455")
    //     var
    //         LocationCode: Code[10];
    //         lrc_SalesClaimLineAktuellerRec: Record "5110456";
    //         lrc_SalesClaimLineSearch: Record "5110456";
    //         lrc_SalesClaimLineRef: Record "5110456";
    //         FirstClaimFound: Boolean;
    //         HeaderModifyEKBE: Boolean;
    //         HeaderModifyVendor: Boolean;
    //         HeaderModifyMasterBatch: Boolean;
    //     begin
    //         //Bei Übergabe verliert der lrc_SalesClaimNotifyLine seine Änderung durch OnAfterValiadate wenn ein find gesetzt wird.
    //         //Setzten eines lrc_SalesClaimLineAktuellerRec damit der neue Wert nicht verloren geht (Merker)
    //         //nun kann man durch den Pointer mit find gehen und Bedingungen abfragen


    //         //lrc_SalesClaimLineRef.SETRANGE("Document No.",lrc_SalesClaimNotifyLine."Document No.");
    //         //lrc_SalesClaimLineRef.FINDSET(FALSE,FALSE);
    //         //REPEAT
    //         // IF NOT CONFIRM('Auftrag %1 Zeile %2 Claim %3 Count %4',TRUE,
    //         //            lrc_SalesClaimLineRef."Document No."
    //         //            ,lrc_SalesClaimLineRef."Line No."
    //         //            ,lrc_SalesClaimLineRef.Claim
    //         //            ,lrc_SalesClaimLineRef.COUNT) THEN ERROR('Abbruch');
    //         //UNTIL lrc_SalesClaimLineRef.NEXT=0;
    //         //EXIT;

    //         lrc_SalesClaimLineAktuellerRec:=lrc_SalesClaimNotifyLine; //Merker des Urpsrungwert für Feld "claim" setzen
    //         FirstClaimFound:=FALSE;
    //         HeaderModifyVendor:=TRUE;
    //         HeaderModifyMasterBatch:=TRUE;
    //         HeaderModifyEKBE:=TRUE;
    //         lrc_SalesClaimNotifyLine.SETRANGE("Document No.",lrc_SalesClaimNotifyLine."Document No.");
    //         lrc_SalesClaimNotifyLine.FIND('-');
    //         REPEAT
    //           //setzen den Record mit aktuellen Wert
    //           IF lrc_SalesClaimNotifyLine."Line No." <> lrc_SalesClaimLineAktuellerRec."Line No."
    //             THEN lrc_SalesClaimLineSearch:=lrc_SalesClaimNotifyLine        //Claim-Wert vom Durchgang
    //             ELSE lrc_SalesClaimLineSearch:=lrc_SalesClaimLineAktuellerRec; //Claim-Wert des Merkers
    //           //Claim Referenz setzen
    //           IF lrc_SalesClaimLineSearch.Claim AND NOT FirstClaimFound THEN  BEGIN
    //             lrc_SalesClaimLineRef:=lrc_SalesClaimLineSearch;
    //             FirstClaimFound:=TRUE;
    //           END;
    //           //Vergleich
    //           IF FirstClaimFound THEN BEGIN //Referenz und somit 1.Claim vorhanden
    //             IF lrc_SalesClaimLineSearch.Claim THEN BEGIN //bist du ein Claim zum Vergleichen ?
    //               IF lrc_SalesClaimLineSearch."Master Batch No." <> lrc_SalesClaimLineRef."Master Batch No."
    //                 THEN HeaderModifyMasterBatch:=FALSE;
    //               IF lrc_SalesClaimLineSearch."Buy-from Vendor No." <>  lrc_SalesClaimLineRef."Buy-from Vendor No."
    //                 THEN HeaderModifyVendor:=FALSE;
    //               IF lrc_SalesClaimLineSearch."Vendor Order No." <> lrc_SalesClaimLineRef."Vendor Order No."
    //                 THEN HeaderModifyEKBE:=FALSE;
    //             END;
    //           END;
    //           //Zeilentest
    //           //IF NOT CONFIRM('Doc %1 Zeile %2 Claim %3 Count %4',TRUE,
    //           //          lrc_SalesClaimLineSearch."Document No.",
    //           //          lrc_SalesClaimLineSearch."Line No.",
    //           //          lrc_SalesClaimLineSearch.Claim,
    //           //          lrc_SalesClaimLineSearch.COUNT) THEN ERROR('Abbruch');
    //         UNTIL lrc_SalesClaimNotifyLine.NEXT() =0;

    //         IF NOT FirstClaimFound THEN BEGIN
    //           HeaderModifyVendor:=FALSE; //aktueller vrc_line = einziger Claim -> Eintrag Header
    //           HeaderModifyMasterBatch:=FALSE;
    //           HeaderModifyEKBE:=FALSE;
    //           lrc_SalesClaimNotifyHeader."Claim Location Code":='';
    //           lrc_SalesClaimNotifyHeader."Return to Location Code":='';
    //           lrc_SalesClaimNotifyHeader."Return to Vendor No.":='';
    //         END ELSE BEGIN
    //           IF lrc_SalesClaimLineRef."Claim Location Code" <> '' //1.Zeile gibt doch Defaultwerte, da Druckbeleg sonst nicht funktionieren
    //             THEN LocationCode:= lrc_SalesClaimLineRef."Claim Location Code"
    //             ELSE LocationCode:= lrc_SalesClaimLineRef."Location Code";
    //           lrc_SalesClaimNotifyHeader."Claim Location Code":=LocationCode;
    //           lrc_SalesClaimNotifyHeader."Return to Location Code":=LocationCode;
    //           lrc_SalesClaimNotifyHeader."Return to Vendor No.":=lrc_SalesClaimLineRef."Buy-from Vendor No.";
    //         END;

    //         IF HeaderModifyMasterBatch
    //           THEN lrc_SalesClaimNotifyHeader."Master Batch No.":=lrc_SalesClaimLineRef."Master Batch No."
    //           ELSE lrc_SalesClaimNotifyHeader."Master Batch No.":='';
    //         IF HeaderModifyVendor
    //           THEN lrc_SalesClaimNotifyHeader."Buy-from Vendor No.":=lrc_SalesClaimLineRef."Buy-from Vendor No."
    //           ELSE lrc_SalesClaimNotifyHeader."Buy-from Vendor No.":='';
    //         IF HeaderModifyEKBE
    //           THEN lrc_SalesClaimNotifyHeader."Vendor Order No.":=lrc_SalesClaimLineRef."Vendor Order No."
    //           ELSE lrc_SalesClaimNotifyHeader."Vendor Order No.":='';

    //         lrc_SalesClaimNotifyHeader.MODIFY(TRUE);
    //     end;

    //     procedure VK_Rekla_DatenUebertrag()
    //     var
    //         MerkePartieNo: Code[20];
    //         PartieGleich: Boolean;
    //         MerkeVendor: Code[20];
    //         VendorGleich: Boolean;
    //         lrc_PackOrderInputItems: Record "5110714";
    //         lrc_PackOrderHeader: Record "5110712";
    //         lrc_PurchaseHeader: Record "38";
    //         lrc_SalesClaimNotifyLine: Record "5110456";
    //         lrc_SalesClaimNotifyHeader: Record "5110455";
    //     begin
    //         IF NOT CONFIRM('Hier werden die Zeilen und Kopfdate von Reklamationsaufträgen einmalig gefüllt, fortfahren ?',FALSE)
    //           THEN ERROR('Abbruch');
    //         //1. Zeilen:
    //         //Partie ist eingetragen:
    //         //lrc_SalesClaimNotifyLine.SETFILTER("Master Batch No.",'PACK0000262');
    //         //IF NOT lrc_SalesClaimNotifyLine.FIND('-') THEN ERROR('Zeile mit Partie %1 nicht gefunden','PACK0000262');

    //         lrc_SalesClaimNotifyLine.FIND('-');
    //         DDialog.OPEN('Rekla-Zeile #1#### von #2####');
    //         DDialog.UPDATE(2,lrc_SalesClaimNotifyLine.COUNT);
    //         i:=0;
    //         REPEAT
    //           i+=1;
    //           DDialog.UPDATE(1,i);
    //           lrc_SalesClaimNotifyLine."Vendor Order No.":=lrc_SalesClaimNotifyLine."Master Batch No.";
    //           //lrc_SalesClaimNotifyHeader.SETRANGE("No.",lrc_SalesClaimNotifyLine."Master Batch No.");
    //           lrc_PurchaseHeader.SETRANGE("No.",lrc_SalesClaimNotifyLine."Master Batch No.");
    //           IF lrc_PurchaseHeader.FINDFIRST() THEN BEGIN
    //             //Eintrag Daten
    //             lrc_SalesClaimNotifyLine."Buy-from Vendor No.":=lrc_PurchaseHeader."Buy-from Vendor No.";
    //             lrc_SalesClaimNotifyLine."Vendor No.":=lrc_PurchaseHeader."Buy-from Vendor No.";

    //           END ELSE BEGIN
    //             lrc_PackOrderHeader.SETRANGE("Master Batch No.",lrc_SalesClaimNotifyLine."Master Batch No.");
    //             IF lrc_PackOrderHeader.FIND('-') THEN BEGIN
    //               //Eintrag Daten
    //               lrc_SalesClaimNotifyLine."Buy-from Vendor No.":=lrc_PackOrderHeader."Pack.-by Vendor No.";
    //               lrc_SalesClaimNotifyLine."Vendor No.":=lrc_PackOrderHeader."Pack.-by Vendor No.";

    //               //nur ein Input ? dann nimm hier den Einkauf
    //               lrc_PackOrderInputItems.SETRANGE("Doc. No.",lrc_PackOrderHeader."No.");
    //               IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //                 IF lrc_PackOrderInputItems.COUNT = 1 THEN BEGIN
    //                   lrc_PurchaseHeader.SETRANGE("No.",lrc_PackOrderInputItems."Master Batch No.");
    //                   IF lrc_PurchaseHeader.FINDFIRST() THEN BEGIN
    //                     lrc_SalesClaimNotifyLine."Buy-from Vendor No.":=lrc_PurchaseHeader."Buy-from Vendor No.";
    //                     lrc_SalesClaimNotifyLine."Vendor Order No.":=lrc_PackOrderInputItems."Master Batch No.";
    //                   END;
    //                 END ELSE BEGIN
    //                   MerkePartieNo:=lrc_PackOrderInputItems."Master Batch No.";
    //                   lrc_PurchaseHeader.SETRANGE("No.",lrc_PackOrderInputItems."Master Batch No.");
    //                   IF lrc_PurchaseHeader.FINDFIRST() THEN MerkeVendor:=lrc_PurchaseHeader."Buy-from Vendor No.";
    //                   VendorGleich:=TRUE;
    //                   PartieGleich:=TRUE;
    //                   REPEAT
    //                     lrc_PurchaseHeader.SETRANGE("No.",lrc_PackOrderInputItems."Master Batch No.");
    //                     IF lrc_PurchaseHeader.FINDFIRST() THEN BEGIN
    //                       //alle gleiche Partie ?
    //                       IF MerkePartieNo <> lrc_PackOrderInputItems."Master Batch No."
    //                         THEN PartieGleich:=FALSE;
    //                       //alle der gleiche Kreditor ?
    //                       IF MerkeVendor <> lrc_PurchaseHeader."Buy-from Vendor No."
    //                         THEN VendorGleich:=FALSE;
    //                     END ELSE BEGIN
    //                       PartieGleich:=FALSE;
    //                       VendorGleich:=FALSE;
    //                     END;
    //                   UNTIL lrc_PackOrderInputItems.NEXT() = 0;
    //                   IF PartieGleich THEN BEGIN
    //                     lrc_SalesClaimNotifyLine."Buy-from Vendor No.":=lrc_PurchaseHeader."Buy-from Vendor No.";
    //                     lrc_SalesClaimNotifyLine."Vendor Order No.":=lrc_PackOrderInputItems."Master Batch No.";
    //                   END;
    //                   IF VendorGleich THEN BEGIN
    //                     lrc_SalesClaimNotifyLine."Buy-from Vendor No.":=lrc_PurchaseHeader."Buy-from Vendor No.";
    //                   END
    //                 END;
    //               END;
    //             END;
    //           END;
    //           lrc_SalesClaimNotifyLine.Modify();
    //         UNTIL lrc_SalesClaimNotifyLine.NEXT() =0;
    //         DDialog.CLOSE;

    //         lrc_SalesClaimNotifyLine.Reset();
    //         lrc_SalesClaimNotifyHeader.Reset();
    //         lrc_SalesClaimNotifyHeader.FIND('-');
    //         DDialog.OPEN('Rekla-Kopf #1#### von #2####');
    //         DDialog.UPDATE(2,lrc_SalesClaimNotifyHeader.COUNT);
    //         i:=0;
    //         REPEAT
    //           i+=1;
    //           DDialog.UPDATE(1,i);

    //           //Eintrag Daten
    //           lrc_SalesClaimNotifyHeader."Return to Vendor No.":=lrc_SalesClaimNotifyHeader."Buy-from Vendor No.";
    //           //Zusteller aus Verkaufsauftrag

    //           lrc_SalesClaimNotifyHeader.Modify();

    //           lrc_SalesClaimNotifyLine.SETRANGE("Document No.",lrc_SalesClaimNotifyHeader."No.");
    //           IF lrc_SalesClaimNotifyLine.FIND('-') THEN BEGIN
    //             VK_ReklaLineClaimChange(lrc_SalesClaimNotifyLine,lrc_SalesClaimNotifyHeader);
    //           END;
    //         UNTIL lrc_SalesClaimNotifyHeader.NEXT() =0;
    //         DDialog.CLOSE;
    //     end;

    //     procedure VK_Gelangen(var "vrc_Sales Header": Record "36";var "vrc_Extended Text Line": Record "Extended Text Line"): Boolean
    //     var
    //         foundTax0: Boolean;
    //         foundEUShippment: Boolean;
    //         "lrc_Country/Region": Record "9";
    //         lrc_Location: Record "14";
    //         "lrc_Sales Line": Record "37";
    //         "lrc_Shipment Method": Record "10";
    //         "lrc_Extended Text Header": Record "Extended Text Header";
    //         "lrc_Port Setup II": Record "50005";
    //     begin
    //         //port.jst 24.2.14  Gelagensbestätigung als Textbaustein ausgeben.

    //         //1. Sind Bedingungen für Gelangenbest. erfüllt ?
    //         //1.1 Selbstabholer  (wenn Lieferung-EU = CMR-Dokument->reicht, Lieferung-Ausland= Ausfuhrdokument->reicht)
    //         IF "vrc_Sales Header"."Shipment Method Code" = '' THEN EXIT(FALSE);
    //         "lrc_Shipment Method".GET("vrc_Sales Header"."Shipment Method Code");
    //         IF NOT "lrc_Shipment Method"."Self-Collector" THEN EXIT(FALSE);

    //         //1.2 EU-Lieferung Abgangsland -> Zugangsland  EU und <>
    //         //1.2.1 Zugangsland EU-Land ?
    //         "lrc_Country/Region".GET("vrc_Sales Header"."Ship-to Country/Region Code");
    //         IF NOT "lrc_Country/Region"."EU Standard" THEN EXIT(FALSE);
    //         //1.2.2 Abgangsland EU-Land und Abgangsland <> Zugangsland ?
    //         "lrc_Sales Line".SETRANGE("Document Type","vrc_Sales Header"."Document Type");
    //         "lrc_Sales Line".SETRANGE("Document No.","vrc_Sales Header"."No.");
    //         "lrc_Sales Line".SETRANGE(Type,"lrc_Sales Line".Type::Item);
    //         "lrc_Sales Line".SETFILTER("No.",'<>%1','');
    //         "lrc_Sales Line".SETFILTER(Quantity,'>0');
    //         IF NOT "lrc_Sales Line".FIND('-') THEN EXIT(FALSE);
    //         foundEUShippment:=FALSE;
    //         foundTax0:=FALSE;
    //         REPEAT
    //           IF "lrc_Sales Line"."Location Code" <> '' THEN BEGIN
    //             IF lrc_Location.GET("lrc_Sales Line"."Location Code") THEN BEGIN
    //               "lrc_Country/Region".GET(lrc_Location."Country/Region Code");
    //               IF     ("lrc_Country/Region"."EU Standard")
    //                 AND ("vrc_Sales Header"."Ship-to Country/Region Code" <> lrc_Location."Country/Region Code") THEN BEGIN
    //                 foundEUShippment:=TRUE;
    //               END;
    //             END;
    //           END;
    //           IF "lrc_Sales Line"."VAT %" = 0 THEN foundTax0:=TRUE;

    //         UNTIL "lrc_Sales Line".NEXT() =0;
    //         IF NOT foundEUShippment THEN EXIT(FALSE);
    //         IF NOT foundTax0 THEN EXIT(FALSE);  //letztendlich gehts halt immer um die Steuern  ;-)

    //         //2. Textbaustein eingetragen und vorhanden ?
    //         "vrc_Extended Text Line".INIT();
    //         "vrc_Extended Text Line".Reset();
    //         IF NOT "lrc_Port Setup II".GET THEN EXIT(FALSE);
    //         IF ("lrc_Port Setup II"."VK Gelangensbestaetigung") AND ("lrc_Port Setup II"."VK Gelangensbestaetigung Text" <> '') THEN BEGIN
    //           "lrc_Extended Text Header".SETRANGE("Table Name","lrc_Extended Text Header"."Table Name"::"Standard Text");
    //           "lrc_Extended Text Header".SETRANGE("No.","lrc_Port Setup II"."VK Gelangensbestaetigung Text");
    //           "lrc_Extended Text Header".SETRANGE("Sales Order",TRUE); //je nach Aufruf Feldabfrage
    //           IF "lrc_Extended Text Header".FINDFIRST() THEN BEGIN
    //             "vrc_Extended Text Line".SETRANGE("Table Name","vrc_Extended Text Line"."Table Name"::"Standard Text");
    //             "vrc_Extended Text Line".SETRANGE("No.","lrc_Port Setup II"."VK Gelangensbestaetigung Text");
    //             IF NOT "lrc_Extended Text Header"."All Language Codes"
    //               THEN "vrc_Extended Text Line".SETRANGE("Language Code","vrc_Sales Header"."Language Code");
    //             IF "vrc_Extended Text Line".FIND('-') THEN BEGIN
    //               EXIT(TRUE);
    //             END;
    //           END;
    //         END;
    //         EXIT(FALSE) //Bis hierher kein True dann False-Rückgabe
    //     end;

    //     procedure Frachtraten_PLZ_sammeln()
    //     var
    //         lrc_Customer: Record "Customer";
    //         lrc_FreightCostControle: Record "5087923";
    //         lrc_Buffer: Record "332" temporary;
    //     begin

    //         FileName:= 'c:\Temp\'+ ENVIRON('USERNAME')+'-CO5110798.csv';
    //         IF EXISTS(FileName) THEN ERASE(FileName);
    //         IF NOT (FFile.CREATE(FileName)) THEN //Hat das geklappt
    //           ERROR('Datei %1 konnte nicht erstellt werden',FileName);
    //         IF NOT (FFile.WRITEMODE(TRUE)) THEN           //sind Schreibrechte da ??
    //           ERROR ('In Datei %1 kann nicht auf Write-Mode geschaltet werden',FileName);
    //         IF NOT (FFile.TEXTMODE(TRUE)) THEN                //True ist ASCII False ist Binary
    //           ERROR ('Datei %1 kann nicht in ASCII-Mode geschaltet werden',FileName);

    //         FFile.WRITE(COMPANYNAME);
    //         FFile.WRITE('Frachtkosten Zugangsregionen');
    //         FFile.WRITE('');
    //         FFile.WRITE('');

    //         lrc_FreightCostControle.SETCURRENTKEY("Shipping Agent Code","Shipping Date","Freight Inv. Recieved");
    //         lrc_FreightCostControle.SETRANGE("Shipping Date",010112D,TODAY);
    //         IF NOT lrc_FreightCostControle.FIND('-') THEN BEGIN
    //           FFile.CLOSE;
    //           MESSAGE('keine Einträge in Frachtkostenkontrolle gefunden');
    //           EXIT;
    //         END;

    //         DDialog.OPEN('Sammeln Frachtkostenkontrolle #1##### von #2#####');
    //         DDialog.UPDATE(2,lrc_FreightCostControle.COUNT);
    //         i:=0;
    //         u:=1;
    //         REPEAT
    //           i+=1;
    //           DDialog.UPDATE(1,i);
    //           //if (lrc_FreightCostControle."Cust. No." <> '') and lrc_FreightCostControle."Shipping Agent Code" <> '') then begin
    //           //  lrcBuffer.UpdateTotal(lrc_FreightCostControle."Shipping Agent Code"+','+ lrc_FreightCostControle."Cust. No.",1,0,1)
    //           IF lrc_FreightCostControle."Cust. No." <> '' THEN BEGIN
    //             lrc_Buffer.UpdateTotal(lrc_FreightCostControle."Cust. No.",1,0,u)
    //           END;
    //         UNTIL lrc_FreightCostControle.NEXT() =0;
    //         DDialog.CLOSE;

    //         IF NOT lrc_Buffer.FIND('-') THEN BEGIN
    //           FFile.CLOSE;
    //           MESSAGE('keine Einträge Kunden-ZUgangsregion gefunden');
    //           EXIT;
    //         END;
    //         DDialog.OPEN('Ausgabe KUnden-Zugangsregion #1#### von #2####');
    //         DDialog.UPDATE(2,lrc_Buffer.COUNT);
    //         i:=0;
    //         REPEAT
    //           i+=1;
    //           DDialog.UPDATE(1,i);
    //           lrc_Customer.GET(lrc_Buffer."Currency Code");
    //           FFile.WRITE(      lrc_Customer."Post Code"
    //                       +';'+ lrc_Customer."Country/Region Code"
    //                       +';'+ lrc_Customer.City
    //                      );
    //         UNTIL lrc_Buffer.NEXT() =0;

    //         FFile.CLOSE;
    //         IF CONFIRM ( 'Soll CSV-Datei mit den Daten für die Frachtraten geöffnet werden ?',TRUE) THEN
    //           HYPERLINK(FileName);
    //     end;

    //     procedure Pack_GetInputOutputGesamtMenge(var vrc_PackOrderHeader: Record "5110712";var TotalQuantityInput: Decimal;var TotalQuantityInputBase: Decimal;var TotalQuantityOutput: Decimal;var TotalQuantityOutputBase: Decimal)
    //     var
    //         lrc_PackOrderOutputItems: Record "5110713";
    //         QuantityOutput: Decimal;
    //         QuantityOutputBase: Decimal;
    //         lrc_PackOrderInputItems: Record "5110714";
    //         QuantityInput: Decimal;
    //         QuantityInputBase: Decimal;
    //     begin
    //         QuantityInput:=0;
    //         QuantityInputBase:=0;
    //         QuantityOutput:=0;
    //         QuantityOutputBase:=0;

    //         lrc_PackOrderInputItems.Reset();
    //         lrc_PackOrderInputItems.SETRANGE("Doc. No.",vrc_PackOrderHeader."No.");
    //         IF lrc_PackOrderInputItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             QuantityInput:=QuantityInput + lrc_PackOrderInputItems.Quantity;
    //             QuantityInputBase := QuantityInputBase + lrc_PackOrderInputItems."Quantity (Base)";
    //           UNTIL lrc_PackOrderInputItems.NEXT=0;
    //         END;

    //         lrc_PackOrderOutputItems.SETRANGE("Doc. No.",vrc_PackOrderHeader."No.");
    //         lrc_PackOrderOutputItems.SETFILTER("Type of Packing Product", '..%1',
    //                                            lrc_PackOrderOutputItems."Type of Packing Product"::"Finished Product");
    //         lrc_PackOrderOutputItems.SETFILTER("Item No.",'<>%1','');
    //         IF lrc_PackOrderOutputItems.FIND('-') THEN BEGIN
    //           REPEAT
    //             QuantityOutput:=QuantityOutput + lrc_PackOrderOutputItems.Quantity;
    //             QuantityOutputBase := QuantityOutputBase + lrc_PackOrderOutputItems."Quantity (Base)";
    //           UNTIL lrc_PackOrderOutputItems.NEXT() =0;
    //         END;

    //         TotalQuantityInput:=QuantityInput;
    //         TotalQuantityInputBase:=QuantityInputBase;
    //         TotalQuantityOutput:=QuantityOutput;
    //         TotalQuantityOutputBase:=QuantityOutputBase;
    //     end;

    //     procedure Ausgabe_ZusatzVKAuftrag(vrc_SalesLine: Record "37";ReportID: Integer;var vrc_PrintDocumentSourceDetail: Record "5110615";var vrc_PurchaseHeader: Record "38"): Boolean
    //     var
    //         lrc_SalesLine: Record "37";
    //         lrc_PrintDocumentSourceDetail: Record "5110615";
    //         "lcu_Port-Sales": Codeunit "5110797";
    //         lrc_PurchaseHeader: Record "38";
    //         lrc_PurchaseLine: Record "39";
    //         lrc_CertificatesCustVend: Record "5110484";
    //         lrc_CertificateControlBoard: Record "5087983";
    //         lrc_item: Record Item;
    //         lrc_Customer: Record "Customer";
    //         "lrc_Sales Header": Record "36";
    //         lrc_Vendor: Record "Vendor";
    //     begin
    //         //POI 001 ZERTIFIK JST 271113 001 Source -> Source:Special Conditions, Weiterer Felder
    //         //Beispiele : Anhang      -> Report 50003  Kopfbedingt   in Section "Purchase Header"
    //         //            Zertifikat  -> Report 50008  Zeilenbedingt in "Sales Line"-Roundloop
    //         //            Textbaustein-> Report 50054  Zeilenbedingt in "Sales Line"-Roundloop -> TempTbl füllen, Ausgabe in Total2 (Fuß)

    //         //POI 001 PACKPurc JST 181213 001 Änderungen
    //         //                                Ausgabe_ZusatzVKAuftrag  -> SaleLine nicht als VAR (Reportaufruf als TEMP)

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR (vrc_SalesLine."No." = '') THEN EXIT(FALSE);

    //         lrc_Vendor.INIT();
    //         lrc_Vendor.Reset();
    //         "lrc_Sales Header".GET(vrc_SalesLine."Document Type",vrc_SalesLine."Document No.");
    //         lrc_Customer.GET("lrc_Sales Header"."Sell-to Customer No.");
    //         lrc_item.GET(vrc_SalesLine."No.");

    //         //Mussbedinung
    //         vrc_PrintDocumentSourceDetail.SETRANGE(Source,vrc_PrintDocumentSourceDetail.Source::"Special Conditions");
    //         vrc_PrintDocumentSourceDetail.SETRANGE(Aktiv,TRUE);
    //         vrc_PrintDocumentSourceDetail.SETRANGE("Document Type",vrc_PrintDocumentSourceDetail."Document Type"::Order);
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Report ID",FORMAT(ReportID));
    //         vrc_PrintDocumentSourceDetail.SETRANGE("Source Type",vrc_PrintDocumentSourceDetail."Source Type"::Customer);
    //         //Zusatzbedinung
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Source No."                 ,'%1|%2','',lrc_Customer."No.");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Customer Group Code" ,'%1|%2','',lrc_Customer."Customer Group Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Ship-to Code"        ,'%1|%2','',"lrc_Sales Header"."Ship-to Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Location Code"       ,'%1|%2','',vrc_SalesLine."Location Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Shipping Agent Code" ,'%1|%2','',vrc_SalesLine."Shipping Agent Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Item Category Code"  ,'%1|%2','',lrc_item."Item Category Code");
    //         //Verpackungscode Relation-Tbl "Proper Name"
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Item Attribute 6"    ,'%1|%2','',vrc_SalesLine."Item Attribute 6");
    //         //Zusatzbedingung Einkauf
    //         IF "lcu_Port-Sales".VK_SaleslineGetPurchase(vrc_SalesLine,lrc_PurchaseLine) THEN BEGIN
    //            vrc_PurchaseHeader.GET(lrc_PurchaseLine."Document Type",lrc_PurchaseLine."Document No.");
    //            lrc_Vendor.GET(lrc_PurchaseLine."Buy-from Vendor No.");
    //            vrc_PrintDocumentSourceDetail.SETFILTER("Filter Vendor Group Code",'%1|%2','',lrc_Vendor."Vendor Group Code");
    //            vrc_PrintDocumentSourceDetail.SETFILTER("Filter Vendor No."       ,'%1|%2','',lrc_Vendor."No.");
    //         END ELSE BEGIN
    //            vrc_PrintDocumentSourceDetail.SETFILTER("Filter Vendor Group Code",'%1','');
    //            vrc_PrintDocumentSourceDetail.SETFILTER("Filter Vendor No."       ,'%1','');
    //         END;
    //         //Ausgaben :
    //         IF vrc_PrintDocumentSourceDetail.FIND('-') THEN BEGIN
    //           EXIT(TRUE);
    //         END;
    //         //zum debuggen (Breakpint setzen und Filter zu prüfen.
    //         i:=1;
    //         i:=1;
    //     end;

    //     procedure Ausgabe_ZusatzEKBestellung(vrc_PurchaseLine: Record "39";ReportID: Integer;var vrc_PrintDocumentSourceDetail: Record "5110615";var vrc_PurchaseHeader: Record "38"): Boolean
    //     var
    //         lrc_Vendor: Record "Vendor";
    //         lrc_item: Record Item;
    //     begin
    //         IF (vrc_PurchaseLine.Type <> vrc_PurchaseLine.Type::Item) OR (vrc_PurchaseLine."No." = '') THEN EXIT(FALSE);

    //         lrc_Vendor.GET(vrc_PurchaseHeader."Buy-from Vendor No.");
    //         lrc_item.GET(vrc_PurchaseLine."No.");

    //         //Mussbedinung
    //         vrc_PrintDocumentSourceDetail.SETRANGE(Source,vrc_PrintDocumentSourceDetail.Source::"Special Conditions");
    //         vrc_PrintDocumentSourceDetail.SETRANGE(Aktiv,TRUE);
    //         vrc_PrintDocumentSourceDetail.SETRANGE("Document Type",vrc_PrintDocumentSourceDetail."Document Type"::Order);
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Report ID",FORMAT(ReportID));
    //         vrc_PrintDocumentSourceDetail.SETRANGE("Source Type",vrc_PrintDocumentSourceDetail."Source Type"::Vendor);
    //         //Zusatzbedinung
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Source No."                 ,'%1|%2','',lrc_Vendor."No.");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Customer Group Code" ,'%1|%2','',lrc_Vendor."Vendor Group Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Ship-to Code"        ,'%1|%2','',vrc_PurchaseHeader."Ship-to Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Location Code"       ,'%1|%2','',vrc_PurchaseLine."Location Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Shipping Agent Code" ,'%1|%2','',vrc_PurchaseLine."Shipping Agent Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Item Category Code"  ,'%1|%2','',lrc_item."Item Category Code");
    //         //Verpackungscode Relation-Tbl "Proper Name"
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Item Attribute 6"    ,'%1|%2','',vrc_PurchaseLine."Item Attribute 6");
    //         //Zusatzbedingung Einkauf
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Vendor Group Code",'%1|%2','',lrc_Vendor."Vendor Group Code");
    //         vrc_PrintDocumentSourceDetail.SETFILTER("Filter Vendor No."       ,'%1|%2','',lrc_Vendor."No.");

    //         //Ausgaben :
    //         IF vrc_PrintDocumentSourceDetail.FIND('-') THEN BEGIN
    //           EXIT(TRUE);
    //         END;

    //         //Beispiel Zertifikatsausgaben VK Report 50008
    //         //Beispiele Textbausteine VK Report 50054
    //         //Beipiel Anahng -> Report 50003 EInkauf

    //         //zum debuggen (Breakpint setzen und Filter zu prüfen.
    //         i:=1;
    //         i:=1;
    //     end;

    //     procedure "-----"()
    //     begin
    //     end;

    //     procedure CheckIfSalesIsBlocked(vrc_SalesLine: Record "37")
    //     var
    //         lrc_CustomerBlockedItems: Record "89358";
    //         ADF_LT_TEXT001: Label 'Item No. %1 is blocked for sales to Customer No. %2!';
    //     begin
    //         // -----------------------------------------------------------------------------
    //         // Funktion zum Prüfen ob Verkauf des Artikels an den Debitor gesperrt ist
    //         // -----------------------------------------------------------------------------

    //         IF (vrc_SalesLine.Type <> vrc_SalesLine.Type::Item) OR
    //            (vrc_SalesLine."No." = '') THEN
    //           EXIT;

    //         lrc_CustomerBlockedItems.Reset();
    //         lrc_CustomerBlockedItems.SETFILTER("Customer Group Code",'%1|%2','','');
    //         lrc_CustomerBlockedItems.SETFILTER("Customer No.",'%1|%2','','');
    //         lrc_CustomerBlockedItems.SETFILTER("Vendor No.",'%1|%2','','');
    //         lrc_CustomerBlockedItems.SETFILTER("Item Category Code",'%1|%2','','');
    //         lrc_CustomerBlockedItems.SETFILTER("Product Group Code",'%1|%2','','');
    //         lrc_CustomerBlockedItems.SETFILTER("Item No.",'%1|%2','','');
    //         IF lrc_CustomerBlockedItems.FINDLAST THEN BEGIN
    //           // Artikel %1 ist nicht zum Verkauf zugelassen an den Debitor %1
    //           ERROR(ADF_LT_TEXT001,vrc_SalesLine."No.",vrc_SalesLine."Sell-to Customer No.");
    //         END;
    //     end;

    var
        lrc_PackOrderInputItems: Record "POI Pack. Order Input Items";
        lrc_PurchaseHeader: Record "Purchase Header";
}

