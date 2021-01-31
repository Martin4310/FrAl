codeunit 5087916 "POI Extended Dimension Mgt"
{

    //     procedure EDM_PurchLineItem(var rrc_PurchaseLine: Record "Purchase Line")
    //     var
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_GeneralLedgerSetup: Record "General Ledger Setup";
    //         lrc_PurchaseHeader: Record "Purchase Header";
    //         lrc_Item: Record Item;
    //         lrc_BatchVariant: Record "POI Batch Variant";
    //         lrc_ExtendedDimensionCriteria: Record "5087970";
    //         lco_DimCode: Code[20];
    //         lin_Counter: Integer;
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Funktion zur Prüfung auf erweiterte Dimensionskriterien für Einkaufszeile
    //         // ------------------------------------------------------------------------------------------

    //         IF (rrc_PurchaseLine.Type <> rrc_PurchaseLine.Type::Item) OR
    //            (rrc_PurchaseLine."No." = '') THEN
    //             EXIT;

    //         // Finanzbuchhaltung Einrichtung lesen
    //         lrc_GeneralLedgerSetup.GET();

    //         // Partie Einrichtung lesen
    //         lrc_BatchSetup.GET();

    //         // Dimensionen zurücksetzen
    //         rrc_PurchaseLine."Shortcut Dimension 1 Code" := '';
    //         rrc_PurchaseLine."Shortcut Dimension 2 Code" := '';
    //         rrc_PurchaseLine."Shortcut Dimension 3 Code" := '';
    //         rrc_PurchaseLine."Shortcut Dimension 4 Code" := '';

    //         // Belegkopf
    //         lrc_PurchaseHeader.GET(rrc_PurchaseLine."Document Type", rrc_PurchaseLine."Document No.");
    //         IF lrc_PurchaseHeader."Shortcut Dimension 1 Code" <> '' THEN
    //             rrc_PurchaseLine."Shortcut Dimension 1 Code" := lrc_PurchaseHeader."Shortcut Dimension 1 Code";
    //         IF lrc_PurchaseHeader."Shortcut Dimension 2 Code" <> '' THEN
    //             rrc_PurchaseLine."Shortcut Dimension 2 Code" := lrc_PurchaseHeader."Shortcut Dimension 2 Code";
    //         IF lrc_PurchaseHeader."Shortcut Dimension 3 Code" <> '' THEN
    //             rrc_PurchaseLine."Shortcut Dimension 3 Code" := lrc_PurchaseHeader."Shortcut Dimension 3 Code";
    //         IF lrc_PurchaseHeader."Shortcut Dimension 4 Code" <> '' THEN
    //             rrc_PurchaseLine."Shortcut Dimension 4 Code" := lrc_PurchaseHeader."Shortcut Dimension 4 Code";

    //         // Artikel
    //         lrc_Item.GET(rrc_PurchaseLine."No.");
    //         IF lrc_Item."Global Dimension 1 Code" <> '' THEN
    //             rrc_PurchaseLine."Shortcut Dimension 1 Code" := lrc_Item."Global Dimension 1 Code";
    //         IF lrc_Item."Global Dimension 2 Code" <> '' THEN
    //             rrc_PurchaseLine."Shortcut Dimension 2 Code" := lrc_Item."Global Dimension 2 Code";
    //         IF lrc_Item."Global Dimension 3 Code" <> '' THEN
    //             rrc_PurchaseLine."Shortcut Dimension 3 Code" := lrc_Item."Global Dimension 3 Code";
    //         IF lrc_Item."Global Dimension 4 Code" <> '' THEN
    //             rrc_PurchaseLine."Shortcut Dimension 4 Code" := lrc_Item."Global Dimension 4 Code";

    //         // Erweiterte Dimensionszuordnung lesen und setzen
    //         IF (lrc_GeneralLedgerSetup."Search Ext. Dimension 1" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 2" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 3" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 4" = TRUE) THEN BEGIN

    //             lin_Counter := 1;
    //             WHILE lin_Counter <= 4 DO BEGIN

    //                 lco_DimCode := '';
    //                 CASE lin_Counter OF
    //                     1:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 1" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 1 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     2:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 2" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 2 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     3:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 3" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 3 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     4:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 4" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 4 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                 END;

    //                 IF lco_DimCode <> '' THEN BEGIN
    //                     lrc_ExtendedDimensionCriteria.Reset();
    //                     lrc_ExtendedDimensionCriteria.SETRANGE(Source, lrc_ExtendedDimensionCriteria.Source::Purchase);
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item Product Group Code", '%1|%2', rrc_PurchaseLine."Product Group Code", '');
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item No.", '%1|%2', rrc_PurchaseLine."No.", '');
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item Country of Origin", '%1|%2', rrc_PurchaseLine."Country of Origin Code", '');
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Sell-to Cust. Region/Country", '');
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type", lrc_PurchaseHeader."Document Type");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code", lrc_PurchaseHeader."Purch. Doc. Subtype Code");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Dimension Code", lco_DimCode);
    //                     IF NOT lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type");
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code", '');
    //                     END;
    //                     IF lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                         CASE lin_Counter OF
    //                             1:
    //                                 rrc_PurchaseLine."Shortcut Dimension 1 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                             2:
    //                                 rrc_PurchaseLine."Shortcut Dimension 2 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                             3:
    //                                 rrc_PurchaseLine."Shortcut Dimension 3 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                             4:
    //                                 rrc_PurchaseLine."Shortcut Dimension 4 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                         END;
    //                     END;
    //                 END;

    //                 lin_Counter := lin_Counter + 1;
    //             END;
    //         END;

    //         // Dimension Position aus Einkaufszeile über Batch No. füllen
    //         CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //             1:
    //                 rrc_PurchaseLine."Shortcut Dimension 1 Code" := rrc_PurchaseLine."Batch No.";
    //             2:
    //                 rrc_PurchaseLine."Shortcut Dimension 2 Code" := rrc_PurchaseLine."Batch No.";
    //             3:
    //                 rrc_PurchaseLine."Shortcut Dimension 3 Code" := rrc_PurchaseLine."Batch No.";
    //             4:
    //                 rrc_PurchaseLine."Shortcut Dimension 4 Code" := rrc_PurchaseLine."Batch No.";
    //         END;

    //         // Dimension Kostenkategorie aus Einkaufszeile über Cost Category füllen
    //         CASE lrc_BatchSetup."Dim. No. Cost Category" OF
    //             1:
    //                 rrc_PurchaseLine."Shortcut Dimension 1 Code" := rrc_PurchaseLine."Cost Category Code";
    //             2:
    //                 rrc_PurchaseLine."Shortcut Dimension 2 Code" := rrc_PurchaseLine."Cost Category Code";
    //             3:
    //                 rrc_PurchaseLine."Shortcut Dimension 3 Code" := rrc_PurchaseLine."Cost Category Code";
    //             4:
    //                 rrc_PurchaseLine."Shortcut Dimension 4 Code" := rrc_PurchaseLine."Cost Category Code";
    //         END;

    //         // Gesetzte Werte validieren
    //         rrc_PurchaseLine.VALIDATE("Shortcut Dimension 1 Code");
    //         rrc_PurchaseLine.VALIDATE("Shortcut Dimension 2 Code");
    //         rrc_PurchaseLine.VALIDATE("Shortcut Dimension 3 Code");
    //         rrc_PurchaseLine.VALIDATE("Shortcut Dimension 4 Code");
    //     end;

    //     procedure EDM_PackOutputLineItem(var rrc_PackOrderOutputItems: Record "5110713")
    //     var
    //         lrc_GeneralLedgerSetup: Record "General Ledger Setup";
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_PackOrderHeader: Record "POI Pack. Order Header";
    //         lrc_Item: Record Item;
    //         lrc_ExtendedDimensionCriteria: Record "5087970";
    //         lco_DimCode: Code[20];
    //         lin_Counter: Integer;
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Funktion zur Prüfung auf erweiterte Dimensionskriterien für Packerei Output Zeile
    //         // ------------------------------------------------------------------------------------------

    //         IF (rrc_PackOrderOutputItems."Item No." = '') THEN
    //             EXIT;

    //         lrc_GeneralLedgerSetup.GET();

    //         lrc_BatchSetup.GET();

    //         // Dimensionen zurücksetzen
    //         rrc_PackOrderOutputItems."Shortcut Dimension 1 Code" := '';
    //         rrc_PackOrderOutputItems."Shortcut Dimension 2 Code" := '';
    //         rrc_PackOrderOutputItems."Shortcut Dimension 3 Code" := '';
    //         rrc_PackOrderOutputItems."Shortcut Dimension 4 Code" := '';

    //         // Belegkopf
    //         lrc_PackOrderHeader.GET(rrc_PackOrderOutputItems."Doc. No.");
    //         IF lrc_PackOrderHeader."Shortcut Dimension 1 Code" <> '' THEN
    //             rrc_PackOrderOutputItems."Shortcut Dimension 1 Code" := lrc_PackOrderHeader."Shortcut Dimension 1 Code";
    //         IF lrc_PackOrderHeader."Shortcut Dimension 2 Code" <> '' THEN
    //             rrc_PackOrderOutputItems."Shortcut Dimension 2 Code" := lrc_PackOrderHeader."Shortcut Dimension 2 Code";
    //         IF lrc_PackOrderHeader."Shortcut Dimension 3 Code" <> '' THEN
    //             rrc_PackOrderOutputItems."Shortcut Dimension 3 Code" := lrc_PackOrderHeader."Shortcut Dimension 3 Code";
    //         IF lrc_PackOrderHeader."Shortcut Dimension 4 Code" <> '' THEN
    //             rrc_PackOrderOutputItems."Shortcut Dimension 4 Code" := lrc_PackOrderHeader."Shortcut Dimension 4 Code";

    //         // Artikel
    //         lrc_Item.GET(rrc_PackOrderOutputItems."Item No.");
    //         IF lrc_Item."Global Dimension 1 Code" <> '' THEN
    //             rrc_PackOrderOutputItems."Shortcut Dimension 1 Code" := lrc_Item."Global Dimension 1 Code";
    //         IF lrc_Item."Global Dimension 2 Code" <> '' THEN
    //             rrc_PackOrderOutputItems."Shortcut Dimension 2 Code" := lrc_Item."Global Dimension 2 Code";
    //         IF lrc_Item."Global Dimension 3 Code" <> '' THEN
    //             rrc_PackOrderOutputItems."Shortcut Dimension 3 Code" := lrc_Item."Global Dimension 3 Code";
    //         IF lrc_Item."Global Dimension 4 Code" <> '' THEN
    //             rrc_PackOrderOutputItems."Shortcut Dimension 4 Code" := lrc_Item."Global Dimension 4 Code";

    //         // Erweiterte Dimensionszuordnung lesen und setzen
    //         IF (lrc_GeneralLedgerSetup."Search Ext. Dimension 1" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 2" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 3" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 4" = TRUE) THEN BEGIN

    //             lin_Counter := 1;
    //             WHILE lin_Counter <= 4 DO BEGIN

    //                 lco_DimCode := '';
    //                 CASE lin_Counter OF
    //                     1:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 1" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 1 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     2:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 2" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 2 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     3:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 3" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 3 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     4:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 4" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 4 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                 END;

    //                 IF lco_DimCode <> '' THEN BEGIN
    //                     lrc_ExtendedDimensionCriteria.Reset();
    //                     lrc_ExtendedDimensionCriteria.SETRANGE(Source, lrc_ExtendedDimensionCriteria.Source::Packing);
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item Product Group Code", '%1|%2', rrc_PackOrderOutputItems."Product Group Code", '');
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item No.", '%1|%2', rrc_PackOrderOutputItems."Item No.", '');
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item Country of Origin", '%1|%2',
    //                                                             rrc_PackOrderOutputItems."Country of Origin Code", '');
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Sell-to Cust. Region/Country", '');
    //                     //    lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type",lrc_PurchaseHeader."Document Type");
    //                     //    lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code",lrc_PurchaseHeader."Purch. Doc. Subtype Code");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Dimension Code", lco_DimCode);
    //                     IF NOT lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type");
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code", '');
    //                     END;
    //                     IF lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                         CASE lin_Counter OF
    //                             1:
    //                                 rrc_PackOrderOutputItems."Shortcut Dimension 1 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                             2:
    //                                 rrc_PackOrderOutputItems."Shortcut Dimension 2 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                             3:
    //                                 rrc_PackOrderOutputItems."Shortcut Dimension 3 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                             4:
    //                                 rrc_PackOrderOutputItems."Shortcut Dimension 4 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                         END;
    //                     END ELSE BEGIN
    //                         // wenn keine Eintragung Packerei, dann nach einkauf suchen
    //                         lrc_ExtendedDimensionCriteria.Reset();
    //                         lrc_ExtendedDimensionCriteria.SETRANGE(Source, lrc_ExtendedDimensionCriteria.Source::Purchase);
    //                         lrc_ExtendedDimensionCriteria.SETFILTER("Item Product Group Code", '%1|%2', rrc_PackOrderOutputItems."Product Group Code", '');
    //                         lrc_ExtendedDimensionCriteria.SETFILTER("Item No.", '%1|%2', rrc_PackOrderOutputItems."Item No.", '');
    //                         lrc_ExtendedDimensionCriteria.SETFILTER("Item Country of Origin", '%1|%2',
    //                                                                 rrc_PackOrderOutputItems."Country of Origin Code", '');
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Sell-to Cust. Region/Country", '');
    //                         //      lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type",lrc_PurchaseHeader."Document Type");
    //                         //      lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code",lrc_PurchaseHeader."Purch. Doc. Subtype Code");
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Dimension Code", lco_DimCode);
    //                         IF NOT lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                             lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type");
    //                             lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code", '');
    //                         END;
    //                         IF lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                             CASE lin_Counter OF
    //                                 1:
    //                                     rrc_PackOrderOutputItems."Shortcut Dimension 1 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                                 2:
    //                                     rrc_PackOrderOutputItems."Shortcut Dimension 2 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                                 3:
    //                                     rrc_PackOrderOutputItems."Shortcut Dimension 3 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                                 4:
    //                                     rrc_PackOrderOutputItems."Shortcut Dimension 4 Code" := lrc_ExtendedDimensionCriteria."Dimension Value Code";
    //                             END;
    //                         END;
    //                     END;
    //                 END;

    //                 lin_Counter := lin_Counter + 1;
    //             END;
    //         END;

    //         // Dimension Position Code füllen
    //         CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //             1:
    //                 rrc_PackOrderOutputItems."Shortcut Dimension 1 Code" := rrc_PackOrderOutputItems."Batch No.";
    //             2:
    //                 rrc_PackOrderOutputItems."Shortcut Dimension 2 Code" := rrc_PackOrderOutputItems."Batch No.";
    //             3:
    //                 rrc_PackOrderOutputItems."Shortcut Dimension 3 Code" := rrc_PackOrderOutputItems."Batch No.";
    //             4:
    //                 rrc_PackOrderOutputItems."Shortcut Dimension 4 Code" := rrc_PackOrderOutputItems."Batch No.";
    //         END;

    //         // Dimension Kostenkategorie füllen
    //         CASE lrc_BatchSetup."Dim. No. Cost Category" OF
    //             1:
    //                 rrc_PackOrderOutputItems."Shortcut Dimension 1 Code" := '';
    //             2:
    //                 rrc_PackOrderOutputItems."Shortcut Dimension 2 Code" := '';
    //             3:
    //                 rrc_PackOrderOutputItems."Shortcut Dimension 3 Code" := '';
    //             4:
    //                 rrc_PackOrderOutputItems."Shortcut Dimension 4 Code" := '';
    //         END;

    //         // Gesetzte Werte validieren
    //         rrc_PackOrderOutputItems.VALIDATE("Shortcut Dimension 1 Code");
    //         rrc_PackOrderOutputItems.VALIDATE("Shortcut Dimension 2 Code");
    //         rrc_PackOrderOutputItems.VALIDATE("Shortcut Dimension 3 Code");
    //         rrc_PackOrderOutputItems.VALIDATE("Shortcut Dimension 4 Code");
    //     end;

    //     procedure EDM_SalesLineItem(var rrc_SalesLine: Record "Sales Line")
    //     var
    //         lrc_GeneralLedgerSetup: Record "General Ledger Setup";
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_SalesHeader: Record "Sales Header";
    //         lrc_Item: Record Item;
    //         lrc_BatchVariant: Record "POI Batch Variant";
    //         lrc_ExtendedDimensionCriteria: Record "5087970";
    //         lco_DimCode: Code[20];
    //         lin_Counter: Integer;
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Funktion zur Prüfung auf erweiterte Dimensionskriterien für Verkaufszeile
    //         // ------------------------------------------------------------------------------------------

    //         IF (rrc_SalesLine.Type <> rrc_SalesLine.Type::Item) OR
    //            (rrc_SalesLine."No." = '') THEN
    //             EXIT;

    //         // Finanzbuchhaltung Einrichtung lesen
    //         lrc_GeneralLedgerSetup.GET();

    //         // Partie Einrichtung lesen
    //         lrc_BatchSetup.GET();

    //         // Belegkopf
    //         IF lrc_SalesHeader.GET(rrc_SalesLine."Document Type", rrc_SalesLine."Document No.") THEN BEGIN
    //             IF lrc_SalesHeader."Shortcut Dimension 1 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 1 Code" := lrc_SalesHeader."Shortcut Dimension 1 Code";
    //             IF lrc_SalesHeader."Shortcut Dimension 2 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 2 Code" := lrc_SalesHeader."Shortcut Dimension 2 Code";
    //             IF lrc_SalesHeader."Shortcut Dimension 3 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 3 Code" := lrc_SalesHeader."Shortcut Dimension 3 Code";
    //             IF lrc_SalesHeader."Shortcut Dimension 4 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 4 Code" := lrc_SalesHeader."Shortcut Dimension 4 Code";
    //         END;
    //         // Artikel
    //         IF lrc_Item.GET(rrc_SalesLine."No.") THEN BEGIN
    //             IF lrc_Item."Global Dimension 1 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 1 Code" := lrc_Item."Global Dimension 1 Code";
    //             IF lrc_Item."Global Dimension 2 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 2 Code" := lrc_Item."Global Dimension 2 Code";
    //             IF lrc_Item."Global Dimension 3 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 3 Code" := lrc_Item."Global Dimension 3 Code";
    //             IF lrc_Item."Global Dimension 4 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 4 Code" := lrc_Item."Global Dimension 4 Code";
    //         END;

    //         // Positionsvariante
    //         IF lrc_BatchVariant.GET(rrc_SalesLine."Batch Variant No.") THEN BEGIN
    //             IF lrc_BatchVariant."Shortcut Dimension 1 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 1 Code" := lrc_BatchVariant."Shortcut Dimension 1 Code";
    //             IF lrc_BatchVariant."Shortcut Dimension 2 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 2 Code" := lrc_BatchVariant."Shortcut Dimension 2 Code";
    //             IF lrc_BatchVariant."Shortcut Dimension 3 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 3 Code" := lrc_BatchVariant."Shortcut Dimension 3 Code";
    //             IF lrc_BatchVariant."Shortcut Dimension 4 Code" <> '' THEN
    //                 rrc_SalesLine."Shortcut Dimension 4 Code" := lrc_BatchVariant."Shortcut Dimension 4 Code";
    //         END;

    //         // Erweiterte Dimensionszuordnung lesen und setzen
    //         IF (lrc_GeneralLedgerSetup."Search Ext. Dimension 1" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 2" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 3" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 4" = TRUE) THEN BEGIN

    //             lin_Counter := 1;
    //             WHILE lin_Counter <= 4 DO BEGIN

    //                 lco_DimCode := '';
    //                 CASE lin_Counter OF
    //                     1:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 1" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 1 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     2:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 2" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 2 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     3:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 3" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 3 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     4:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 4" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 4 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                 END;

    //                 IF lco_DimCode <> '' THEN BEGIN
    //                     lrc_ExtendedDimensionCriteria.Reset();
    //                     lrc_ExtendedDimensionCriteria.SETRANGE(Source, lrc_ExtendedDimensionCriteria.Source::Sales);
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item Product Group Code", '%1|%2', rrc_SalesLine."Product Group Code", '');
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item No.", '%1|%2', rrc_SalesLine."No.", '');
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item Country of Origin", '%1|%2', rrc_SalesLine."Country of Origin Code", '');
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Sell-to Cust. Region/Country", lrc_SalesHeader."Sell-to Country/Region Code");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type", lrc_SalesHeader."Document Type");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code", lrc_SalesHeader."Sales Doc. Subtype Code");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Dimension Code", lco_DimCode);
    //                     IF NOT lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type");
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code", '');
    //                     END;
    //                     IF lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                         CASE lin_Counter OF
    //                             1:
    //                                 rrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code", lrc_ExtendedDimensionCriteria."Dimension Value Code");
    //                             2:
    //                                 rrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code", lrc_ExtendedDimensionCriteria."Dimension Value Code");
    //                             3:
    //                                 rrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code", lrc_ExtendedDimensionCriteria."Dimension Value Code");
    //                             4:
    //                                 rrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code", lrc_ExtendedDimensionCriteria."Dimension Value Code");
    //                         END;
    //                     END;
    //                 END;

    //                 lin_Counter := lin_Counter + 1;
    //             END;
    //         END;

    //         // Dimension Position Code füllen
    //         CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //             1:
    //                 rrc_SalesLine."Shortcut Dimension 1 Code" := rrc_SalesLine."Batch No.";
    //             2:
    //                 rrc_SalesLine."Shortcut Dimension 2 Code" := rrc_SalesLine."Batch No.";
    //             3:
    //                 rrc_SalesLine."Shortcut Dimension 3 Code" := rrc_SalesLine."Batch No.";
    //             4:
    //                 rrc_SalesLine."Shortcut Dimension 4 Code" := rrc_SalesLine."Batch No.";
    //         END;

    //         // Dimension Kostenkategorie füllen
    //         // CASE lrc_BatchSetup."Cost Category Dim. No." OF
    //         //   1: rrc_SalesLine."Shortcut Dimension 1 Code" := '';
    //         //   2: rrc_SalesLine."Shortcut Dimension 2 Code" := '';
    //         //   3: rrc_SalesLine."Shortcut Dimension 3 Code" := '';
    //         //   4: rrc_SalesLine."Shortcut Dimension 4 Code" := '';
    //         // END;

    //         // Gesetzte Werte validieren
    //         rrc_SalesLine.VALIDATE("Shortcut Dimension 1 Code");
    //         rrc_SalesLine.VALIDATE("Shortcut Dimension 2 Code");
    //         rrc_SalesLine.VALIDATE("Shortcut Dimension 3 Code");
    //         rrc_SalesLine.VALIDATE("Shortcut Dimension 4 Code");
    //     end;

    //     procedure EDM_BatchVarDetailItem(var rrc_BatchVariantDetail: Record "5110487")
    //     var
    //         lrc_GeneralLedgerSetup: Record "General Ledger Setup";
    //         lrc_BatchSetup: Record "POI Master Batch Setup";
    //         lrc_SalesHeader: Record "Sales Header";
    //         lrc_SalesLine: Record "Sales Line";
    //         lrc_Item: Record Item;
    //         lrc_BatchVariant: Record "POI Batch Variant";
    //         lrc_ExtendedDimensionCriteria: Record "5087970";
    //         lco_DimCode: Code[20];
    //         lin_Counter: Integer;
    //         lco_CountryOfOriginCode: Code[10];
    //     begin
    //         // ------------------------------------------------------------------------------------------
    //         // Funktion zur Prüfung auf erweiterte Dimensionskriterien für BatchVariantDetail Zeile
    //         // ------------------------------------------------------------------------------------------

    //         IF rrc_BatchVariantDetail."Batch Variant No." = '' THEN
    //             EXIT;

    //         // Finanzbuchhaltung Einrichtung lesen
    //         lrc_GeneralLedgerSetup.GET();

    //         // Partie Einrichtung lesen
    //         lrc_BatchSetup.GET();

    //         // Dimensionen zurücksetzen
    //         rrc_BatchVariantDetail."Shortcut Dimension 1 Code" := '';
    //         rrc_BatchVariantDetail."Shortcut Dimension 2 Code" := '';
    //         rrc_BatchVariantDetail."Shortcut Dimension 3 Code" := '';
    //         rrc_BatchVariantDetail."Shortcut Dimension 4 Code" := '';

    //         // Belegkopf
    //         IF lrc_SalesHeader.GET(rrc_BatchVariantDetail."Source Type", rrc_BatchVariantDetail."Source No.") THEN BEGIN
    //             IF lrc_SalesHeader."Shortcut Dimension 1 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 1 Code" := lrc_SalesHeader."Shortcut Dimension 1 Code";
    //             IF lrc_SalesHeader."Shortcut Dimension 2 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 2 Code" := lrc_SalesHeader."Shortcut Dimension 2 Code";
    //             IF lrc_SalesHeader."Shortcut Dimension 3 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 3 Code" := lrc_SalesHeader."Shortcut Dimension 3 Code";
    //             IF lrc_SalesHeader."Shortcut Dimension 4 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 4 Code" := lrc_SalesHeader."Shortcut Dimension 4 Code";
    //         END;
    //         // Belegzeile
    //         IF NOT lrc_SalesLine.GET(rrc_BatchVariantDetail."Source Type", rrc_BatchVariantDetail."Source No.",
    //                           rrc_BatchVariantDetail."Source Line No.") THEN
    //             EXIT;

    //         // Artikel
    //         IF lrc_Item.GET(rrc_BatchVariantDetail."Item No.") THEN BEGIN
    //             IF lrc_Item."Global Dimension 1 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 1 Code" := lrc_Item."Global Dimension 1 Code";
    //             IF lrc_Item."Global Dimension 2 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 2 Code" := lrc_Item."Global Dimension 2 Code";
    //             IF lrc_Item."Global Dimension 3 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 3 Code" := lrc_Item."Global Dimension 3 Code";
    //             IF lrc_Item."Global Dimension 4 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 4 Code" := lrc_Item."Global Dimension 4 Code";
    //         END;

    //         // Positionsvariante
    //         IF lrc_BatchVariant.GET(rrc_BatchVariantDetail."Batch Variant No.") THEN BEGIN
    //             IF lrc_BatchVariant."Shortcut Dimension 1 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 1 Code" := lrc_BatchVariant."Shortcut Dimension 1 Code";
    //             IF lrc_BatchVariant."Shortcut Dimension 2 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 2 Code" := lrc_BatchVariant."Shortcut Dimension 2 Code";
    //             IF lrc_BatchVariant."Shortcut Dimension 3 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 3 Code" := lrc_BatchVariant."Shortcut Dimension 3 Code";
    //             IF lrc_BatchVariant."Shortcut Dimension 4 Code" <> '' THEN
    //                 rrc_BatchVariantDetail."Shortcut Dimension 4 Code" := lrc_BatchVariant."Shortcut Dimension 4 Code";
    //         END;

    //         // herkunftsland richtig holen
    //         rrc_BatchVariantDetail.CALCFIELDS("Country of Origin Code");
    //         IF rrc_BatchVariantDetail."Country of Origin Code" = '' THEN BEGIN
    //             lco_CountryOfOriginCode := rrc_BatchVariantDetail."Country of Origin Code";
    //         END ELSE BEGIN
    //             lco_CountryOfOriginCode := lrc_SalesLine."Country of Origin Code";
    //         END;


    //         // Erweiterte Dimensionszuordnung lesen und setzen
    //         IF (lrc_GeneralLedgerSetup."Search Ext. Dimension 1" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 2" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 3" = TRUE) OR
    //            (lrc_GeneralLedgerSetup."Search Ext. Dimension 4" = TRUE) THEN BEGIN

    //             lin_Counter := 1;
    //             WHILE lin_Counter <= 4 DO BEGIN

    //                 lco_DimCode := '';
    //                 CASE lin_Counter OF
    //                     1:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 1" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 1 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     2:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 2" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 2 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     3:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 3" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 3 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                     4:
    //                         BEGIN
    //                             IF lrc_GeneralLedgerSetup."Search Ext. Dimension 4" = TRUE THEN
    //                                 lco_DimCode := lrc_GeneralLedgerSetup."Global Dimension 4 Code"
    //                             ELSE
    //                                 lco_DimCode := '';
    //                         END;
    //                 END;

    //                 IF lco_DimCode <> '' THEN BEGIN
    //                     lrc_ExtendedDimensionCriteria.Reset();
    //                     lrc_ExtendedDimensionCriteria.SETRANGE(Source, lrc_ExtendedDimensionCriteria.Source::Sales);
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item Product Group Code", '%1|%2', lrc_SalesLine."Product Group Code", '');
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item No.", '%1|%2', lrc_SalesLine."No.", '');
    //                     lrc_ExtendedDimensionCriteria.SETFILTER("Item Country of Origin", '%1|%2', lco_CountryOfOriginCode, '');
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Sell-to Cust. Region/Country", lrc_SalesHeader."Sell-to Country/Region Code");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type", lrc_SalesHeader."Document Type");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code", lrc_SalesHeader."Sales Doc. Subtype Code");
    //                     lrc_ExtendedDimensionCriteria.SETRANGE("Dimension Code", lco_DimCode);
    //                     IF NOT lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Type");
    //                         lrc_ExtendedDimensionCriteria.SETRANGE("Doc. Subtype Code", '');
    //                     END;
    //                     IF lrc_ExtendedDimensionCriteria.FINDLAST() THEN BEGIN
    //                         CASE lin_Counter OF
    //                             1:
    //                                 rrc_BatchVariantDetail.VALIDATE("Shortcut Dimension 1 Code", lrc_ExtendedDimensionCriteria."Dimension Value Code");
    //                             2:
    //                                 rrc_BatchVariantDetail.VALIDATE("Shortcut Dimension 2 Code", lrc_ExtendedDimensionCriteria."Dimension Value Code");
    //                             3:
    //                                 rrc_BatchVariantDetail.VALIDATE("Shortcut Dimension 3 Code", lrc_ExtendedDimensionCriteria."Dimension Value Code");
    //                             4:
    //                                 rrc_BatchVariantDetail.VALIDATE("Shortcut Dimension 4 Code", lrc_ExtendedDimensionCriteria."Dimension Value Code");
    //                         END;
    //                     END;
    //                 END;

    //                 lin_Counter := lin_Counter + 1;
    //             END;
    //         END;

    //         // Dimension Position Code füllen
    //         CASE lrc_BatchSetup."Dim. No. Batch No." OF
    //             1:
    //                 rrc_BatchVariantDetail."Shortcut Dimension 1 Code" := rrc_BatchVariantDetail."Batch No.";
    //             2:
    //                 rrc_BatchVariantDetail."Shortcut Dimension 2 Code" := rrc_BatchVariantDetail."Batch No.";
    //             3:
    //                 rrc_BatchVariantDetail."Shortcut Dimension 3 Code" := rrc_BatchVariantDetail."Batch No.";
    //             4:
    //                 rrc_BatchVariantDetail."Shortcut Dimension 4 Code" := rrc_BatchVariantDetail."Batch No.";
    //         END;

    //         // Dimension Kostenkategorie füllen
    //         // CASE lrc_BatchSetup."Cost Category Dim. No." OF
    //         //   1: rrc_SalesLine."Shortcut Dimension 1 Code" := '';
    //         //   2: rrc_SalesLine."Shortcut Dimension 2 Code" := '';
    //         //   3: rrc_SalesLine."Shortcut Dimension 3 Code" := '';
    //         //   4: rrc_SalesLine."Shortcut Dimension 4 Code" := '';
    //         // END;

    //         // Gesetzte Werte validieren
    //         rrc_BatchVariantDetail.VALIDATE("Shortcut Dimension 1 Code");
    //         rrc_BatchVariantDetail.VALIDATE("Shortcut Dimension 2 Code");
    //         rrc_BatchVariantDetail.VALIDATE("Shortcut Dimension 3 Code");
    //         rrc_BatchVariantDetail.VALIDATE("Shortcut Dimension 4 Code");
    //     end;
}

