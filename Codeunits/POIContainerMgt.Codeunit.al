codeunit 5110363 "POI Container Mgt"
{
    var
        lrc_BatchContainer: Record "POI Batch - Container";

    procedure EnterContainerNosPerPurchHeade(vrc_PurchHeader: Record "Purchase Header")
    var
        lrc_PurchOrderContainer: Record "POI Purchase Container Lines";
    //lfm_PurchOrderContainer: Form "5110341";
    begin
        // ---------------------------------------------------------------
        // Funktion zur Erfassung der Containernummern pro Einkauf
        // ---------------------------------------------------------------

        lrc_PurchOrderContainer.FILTERGROUP(2);
        lrc_PurchOrderContainer.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
        lrc_PurchOrderContainer.SETRANGE("Document No.", vrc_PurchHeader."No.");
        lrc_PurchOrderContainer.SETRANGE("Document Line No.", 0);
        lrc_PurchOrderContainer.FILTERGROUP(0);

        // lfm_PurchOrderContainer.SETTABLEVIEW(lrc_PurchOrderContainer); //TODO: Page;
        // lfm_PurchOrderContainer.RUNMODAL;
    end;

    procedure EnterContainerNosPerPurchLine(vrc_PurchLine: Record "Purchase Line")
    var
        lrc_PurchOrderContainer: Record "POI Purchase Container Lines";
        // lfm_PurchOrderContainer: Form "5110341";
        ADF_LT_TEXT001Txt: Label 'Containernummer können nur für Artikelzeilen erfaßt werden!';
    begin
        // ---------------------------------------------------------------
        // Funktion zur Erfassung der Containernummern pro Einkaufszeile
        // ---------------------------------------------------------------

        IF (vrc_PurchLine.Type <> vrc_PurchLine.Type::Item) OR
           (vrc_PurchLine."No." = '') THEN
            // Containernummer können nur für Artikelzeilen erfaßt werden!
            ERROR(ADF_LT_TEXT001Txt);

        lrc_PurchOrderContainer.FILTERGROUP(2);
        lrc_PurchOrderContainer.SETRANGE("Document Type", vrc_PurchLine."Document Type");
        lrc_PurchOrderContainer.SETRANGE("Document No.", vrc_PurchLine."Document No.");
        lrc_PurchOrderContainer.SETRANGE("Document Line No.", vrc_PurchLine."Line No.");
        lrc_PurchOrderContainer.FILTERGROUP(0);

        // lfm_PurchOrderContainer.SETTABLEVIEW(lrc_PurchOrderContainer); //TODO: page
        // lfm_PurchOrderContainer.RUNMODAL;
    end;

    procedure UpdContainerFromPurchLine(vrc_PurchLine: Record "Purchase Line"; vco_xRecContCode: Code[20])
    var
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_Container: Record "POI Container";
    begin
        // ---------------------------------------------------------------
        // Funktion zum Speichern Container Daten aus Einkaufszeile
        // ---------------------------------------------------------------

        IF vrc_PurchLine."POI Container No." = '' THEN
            EXIT;

        // Kopfsatz bestellung lesen
        lrc_PurchaseHeader.GET(vrc_PurchLine."Document Type", vrc_PurchLine."Document No.");

        // Neuen Conatiner Satz anlegen
        IF NOT lrc_Container.GET(vrc_PurchLine."POI Container No.") THEN BEGIN
            lrc_Container.RESET();
            lrc_Container.INIT();
            lrc_Container."No." := vrc_PurchLine."POI Container No.";
            lrc_Container.INSERT();
        END;

        IF NOT lrc_BatchContainer.GET(vrc_PurchLine."POI Batch No.", vrc_PurchLine."POI Container No.") THEN BEGIN
            lrc_BatchContainer.RESET();
            lrc_BatchContainer.INIT();
            lrc_BatchContainer."Batch No." := vrc_PurchLine."POI Batch No.";
            lrc_BatchContainer."Container Code" := vrc_PurchLine."POI Container No.";
            lrc_BatchContainer."Means of Transport Type" := lrc_PurchaseHeader."POI Means of Transport Type";
            lrc_BatchContainer."Means of Transport Code" := lrc_PurchaseHeader."POI Means of TransCode(Arriva)";
            lrc_BatchContainer."Means of Transport Info" := lrc_PurchaseHeader."POI Means of Transport Info";
            lrc_BatchContainer."Departure Region Code" := lrc_PurchaseHeader."POI Departure Region Code";
            lrc_BatchContainer."Port of Discharge Code (UDE)" := lrc_PurchaseHeader."POI Port of Disch. Code (UDE)";
            lrc_BatchContainer.INSERT();
        END ELSE BEGIN
            lrc_BatchContainer."Means of Transport Type" := lrc_PurchaseHeader."POI Means of Transport Type";
            lrc_BatchContainer."Means of Transport Code" := lrc_PurchaseHeader."POI Means of TransCode(Arriva)";
            lrc_BatchContainer."Means of Transport Info" := lrc_PurchaseHeader."POI Means of Transport Info";
            lrc_BatchContainer."Departure Region Code" := lrc_PurchaseHeader."POI Departure Region Code";
            lrc_BatchContainer."Port of Discharge Code (UDE)" := lrc_PurchaseHeader."POI Port of Disch. Code (UDE)";
            lrc_BatchContainer.MODIFY();
        END;
    end;
}

