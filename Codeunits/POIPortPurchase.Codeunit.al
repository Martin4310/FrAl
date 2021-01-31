codeunit 5110795 "POI Port_Purchase"
{
    trigger OnRun()
    begin
        Choicetext := ('Zeile Partie aus anderer Zeile erstellen'
                      + ',' + 'Feld Korrektur in EInkaufszeile'
                      + ',' + 'Alle Debitoren -> Maßnahme Kreditlimit'
                      + ',' + 'Test-Fkt.'
                      );
        OptioNo := STRMENU(Choicetext, 1);
        CASE OptioNo OF
            1:
                Purchase_ZeilenKorrektur();
            2:
                Purchase_ZeileKorrekturFelder();
            3:
                Debitor_SetzParameter();
            4:
                BEGIN
                    //Eintrag der Abrechnungszeilen uas den Einkaufszeilen der Partie
                    lrc_PurchaseHeader.SETRANGE("No.", '12-73341');
                    lrc_PurchaseHeader.FINDFIRST();
                    Purchase_Handlesabrechnung(lrc_PurchaseHeader);
                END;
        END;
    end;

    var
        "Purchase Line": Record "Purchase Line";
        "Purchase Header": Record "Purchase Header";
        i: Integer;
        u: Integer;
        DDialog: Dialog;
        Choicetext: Text[1024];
        OptioNo: Integer;
        FileName: Text[300];
        FFile: File;
    //"frmPort Vari": Page "50055";
    // textVari1Txt: Text[30];
    // textVari2Txt: Text[30];
    // textVari3Txt: Text[30];
    // BoolVari1: Boolean;
    // TestCode: Code[20];
    // DatumVon: Date;
    // DatumBis: Date;

    procedure test()
    var
        lrc_ShipAgFreightcost: Record "POI Ship.-Agent Freightcost";
        lrc_ShipAgFreightcost2: Record "POI Ship.-Agent Freightcost";
    begin
        IF CONFIRM('Hallo 5110795 Port_Purchase') THEN;

        lrc_ShipAgFreightcost.FIND('-');
        DDialog.OPEN('Rec #1##### von #2#####');
        DDialog.UPDATE(2, lrc_ShipAgFreightcost.COUNT());
        i := 0;
        REPEAT
            i += 1;
            DDialog.UPDATE(1, i);
            IF lrc_ShipAgFreightcost."Freight Cost Tarif Base" <> lrc_ShipAgFreightcost."Freight Cost Tarif Base"::"Pallet Type" THEN BEGIN
                lrc_ShipAgFreightcost2 := lrc_ShipAgFreightcost;
                lrc_ShipAgFreightcost2."Freight Cost Tarif Base" := lrc_ShipAgFreightcost2."Freight Cost Tarif Base"::"Pallet Type";
                lrc_ShipAgFreightcost2.insert();
            END;
        UNTIL lrc_ShipAgFreightcost.NEXT() = 0;
        DDialog.CLOSE();
    end;

    procedure Debitor_SetzParameter()
    var
        MassnahmeVorher: Text[30];
        ChangeToBlock: Boolean;
    begin
        IF (USERID() <> 'sa') AND (USERID() <> 'steffen') THEN ERROR('Fkt nur mit sa durchführen');

        IF NOT CONFIRM('Debitoren Feld:"Maßnahme Kreditlimitüberschreitung" wird auf "Sperre" gesetzt, fortfahren ?', FALSE)
          THEN
            ERROR('Abbruch');

        //Datei
        FileName := 'c:\Temp\' + UserId() + '-CO5110795.csv';
        IF EXISTS(FileName) THEN ERASE(FileName); //TODO: Textmode
        IF NOT (FFile.WRITEMODE(TRUE)) THEN           //sind Schreibrechte da ??
            ERROR('In Datei %1 kann nicht auf Write-Mode geschaltet werden', FileName);
        IF NOT (FFile.TEXTMODE(TRUE)) THEN                //True ist ASCII False ist Binary
            ERROR('Datei %1 kann nicht in ASCII-Mode geschaltet werden', FileName);
        IF NOT (FFile.CREATE(FileName)) THEN //Hat das geklappt
            ERROR('Datei %1 konnte nicht erstellt werden', FileName);


        FFile.WRITE(COMPANYNAME());
        FFile.WRITE('Debitor;Kredit-Massnahme vor Aenderung;aendern');

        lrc_Customer.FIND('-');
        DDialog.OPEN('Debitor #1#### von #2###');
        DDialog.UPDATE(2, lrc_Customer.COUNT());
        i := 0;
        REPEAT
            i += 1;
            DDialog.UPDATE(1, i);
            ChangeToBlock := FALSE;
            MassnahmeVorher := FORMAT(lrc_Customer."POI Action Credit Lim Overdue");

            IF lrc_Customer."POI Steco Customer No." = 'WARNUNG' THEN BEGIN
                lrc_Customer."POI Action Credit Lim Overdue" := lrc_Customer."POI Action Credit Lim Overdue"::Warning;
                ChangeToBlock := TRUE;
                lrc_Customer.MODIFY();
            END;

            FFile.WRITE(lrc_Customer."No."
                         + ';' + MassnahmeVorher
                         + ';' + FORMAT(ChangeToBlock)
                       );
        UNTIL lrc_Customer.NEXT() = 0;
        DDialog.CLOSE();
        FFile.CLOSE();
        IF CONFIRM('Soll Datei % geöffnet werden ?', TRUE, FileName) THEN
            HYPERLINK(FileName)
    end;

    procedure Purchase_Head_Calc(var "vrc_Purchase Header": Record "Purchase Header")
    var
        lcu_PurchMgt: Codeunit "POI Purch. Mgt";
    begin
        //Purchase Ergänzung : Kalkulation & Rabatte
        IF "vrc_Purchase Header".Status <> "vrc_Purchase Header".Status::Open THEN BEGIN
            IF CONFIRM('Der Status der Partie ist nicht offen. Wollen Sie ihn zurücksetzen?', TRUE) THEN BEGIN
                "vrc_Purchase Header".Status := "vrc_Purchase Header".Status::Open;
                "vrc_Purchase Header".MODIFY();
                lcu_PurchMgt.PurchCalcOrder("vrc_Purchase Header");
            END ELSE
                //MESSAGE('Prüfung nicht möglich, der Status muss offen sein');
                lcu_PurchMgt.PurchCalcOrder("vrc_Purchase Header");
        END ELSE
            lcu_PurchMgt.PurchCalcOrder("vrc_Purchase Header");
        COMMIT();
    end;

    procedure Purchase_Head_OnModify(var "vrc_Purchase Header": Record "Purchase Header"; "lrc_Purchase HeaderX": Record "Purchase Header"; Fieldname: Text[250]) ok: Boolean
    var
        ChangeCancel: Boolean;
        PurchaseLineTrue: Boolean;
        BatchClassification: Boolean;
    begin
        //Fkt soll feststellen, ob Änderung am Einkaufskopf zulässig sind.
        //15.3.12 von Tbl 38 Purchase Header FelderOnValidate Geschäftsbuchungsgruppe,MWSTGeschäftsbuchungsgruppe,Währungscode

        // EXIT;

        ok := FALSE;
        ChangeCancel := FALSE;
        "Purchase Header" := "vrc_Purchase Header"; //für Datensichtung
        PurchaseLineTrue := FALSE;
        BatchClassification := FALSE;

        //Position auf 1.Einkaufszeile wenn vorhanden
        "Purchase Line".SETRANGE("Document Type", "vrc_Purchase Header"."Document Type");
        "Purchase Line".SETRANGE("Document No.", "vrc_Purchase Header"."No.");
        IF "Purchase Line".FINDFIRST() THEN BEGIN
            PurchaseLineTrue := TRUE;
            REPEAT
                IF ("Purchase Line"."POI Master Batch No." <> '')  //Partie
                  OR ("Purchase Line"."POI Batch No." <> '')         //Positionsnr.
                  OR ("Purchase Line"."POI Batch Variant No." <> '') THEN BEGIN //Pos.-Var. Nr.
                    BatchClassification := TRUE;
                    "Purchase Line".FINDLAST();
                END;
            UNTIL "Purchase Line".NEXT() = 0;
        END;

        //Bedingungen abfragen
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        IF PurchaseLineTrue THEN BEGIN
            //Bedinung Geschäftsbuchungsgruppe -> wird geändert so erneuern sich die Zeilen und der Bezug zur Partie geht verloren
            IF ("vrc_Purchase Header"."Gen. Bus. Posting Group" <> "lrc_Purchase HeaderX"."Gen. Bus. Posting Group") THEN
                IF BatchClassification THEN
                    ERROR('PartieZuordnung auf Zeilen\Zeilen dürfen nicht vom System gelöscht/erneuert werden');
            //Bedinung MWSTbuchungsgruppe -> wird geändert so erneuern sich die Zeilen und der Bezug zur Partie geht verloren
            IF ("vrc_Purchase Header"."VAT Bus. Posting Group" <> "lrc_Purchase HeaderX"."VAT Bus. Posting Group") THEN
                IF BatchClassification THEN
                    ERROR('PartieZuordnung auf Zeilen\Zeilen dürfen nicht vom System gelöscht/erneuert werden');
            //Bedingung Währung
            IF ("vrc_Purchase Header"."Currency Code" <> "lrc_Purchase HeaderX"."Currency Code") THEN
                IF BatchClassification THEN
                    ERROR('PartieZuordnung auf Zeilen\Zeilen dürfen nicht vom System gelöscht/erneuert werden');
        END;
        IF ChangeCancel THEN "vrc_Purchase Header" := "lrc_Purchase HeaderX";
    end;

    procedure Purchase_KostenrechnungDSDFuel(var "vrl_Purchase Header": Record "Purchase Header")
    var
        WDJournTemplatePage: Page "POI WD Journal Template";

        NewLineNo: Integer;
    begin
        //Fkt wird von Frm 5110345  aufgreufen.
        //Soll Buchblatt mit DSD-Kalkulation in Kostenrechnung(Einkauf) einsetzen.
        IF USERID() <> 'steffen' THEN ERROR('noch im Test');

        "lrc_Purchase Line".SETRANGE("Document Type", "vrl_Purchase Header"."Document Type");
        "lrc_Purchase Line".SETRANGE("Document No.", "vrl_Purchase Header"."No.");
        IF "lrc_Purchase Line".FINDLAST()
          THEN
            NewLineNo := "lrc_Purchase Line"."Line No." + 10000
        ELSE
            NewLineNo := 10000;
        //Buchblatt übertragen
        WDJournTemplate.SETFILTER("Formular ID", '5087908');
        IF NOT WDJournTemplate.FIND() THEN ERROR('keine Buchblattvorlage vorhanden');
        CLEAR(WDJournTemplatePage);
        WDJournTemplatePage.SETTABLEVIEW := WDJournTemplate;
        WDJournTemplatePage.SETRECORD := WDJournTemplate;
        IF WDJournTemplatePage.RUNMODAL() = ACTION::LookupOK THEN BEGIN
            WDJournTemplatePage.GETRECORD(WDJournTemplate);
            CLEAR(WDJournTemplatePage);
            "lrc_W.D. Journal Line".SETRANGE("Journal Template Name", WDJournTemplate.Name);
            IF "lrc_W.D. Journal Line".FINDFIRST() THEN BEGIN
                i := 1;
                DDialog.OPEN('Rec #1#### von #2####');
                DDialog.UPDATE(2, "lrc_W.D. Journal Line".COUNT());
                REPEAT
                    i += 1;
                    DDialog.UPDATE(1, i);
                    "lrc_Purchase Line"."Document Type" := "vrl_Purchase Header"."Document Type";
                    "lrc_Purchase Line"."Document No." := "vrl_Purchase Header"."No.";
                    "lrc_Purchase Line"."Line No." := NewLineNo;
                    NewLineNo += 1000;
                    "lrc_Purchase Line".Type := "lrc_Purchase Line".Type::"G/L Account";
                    "lrc_Purchase Line".VALIDATE("POI Cost Category Code", 'DIV');
                    "lrc_Purchase Line"."POI Master Batch No." := "lrc_W.D. Journal Line"."Master Batch No.";
                    "lrc_Purchase Line"."POI Batch No." := "lrc_W.D. Journal Line"."Batch No.";
                    "lrc_Purchase Line"."POI Batch Variant No." := "lrc_W.D. Journal Line"."Batch Variant No.";
                    "lrc_Purchase Line".VALIDATE(Quantity, 1);
                    "lrc_Purchase Line"."Direct Unit Cost" := "lrc_W.D. Journal Line".Amount;
                    "lrc_Purchase Line".INSERT(TRUE);
                UNTIL "lrc_W.D. Journal Line".NEXT() = 0;
                DDialog.CLOSE();
            END;
        END;
    end;

    procedure Purchase_ZeilenKorrektur()
    var
        lrc_DimensionValue: Record "Dimension Value";
        lrc_DimensionValueTest: Record "Dimension Value";
        TxtPartie: Text[30];
        txtPartiePos: Text[30];
        txtPartiePosStart: Text[30];
        MengePartie: Integer;
    begin


        IF NOT CONFIRM('Fkt erstellt nach Vorgabe einer existierenden Einkaufszeilen (letzte Position) neue Zeilen mit Partie-Bezug'
                       + '\Tip: Zeile neu erstellen damit die Funktion eine Vorlage hat. Danach diese Zeile wieder löschen'
                       + '\\Fortfahren ?')
          THEN
            ERROR('Abbruch');


        TxtPartie := '12-71081';
        txtPartiePosStart := '001';
        MengePartie := 1;

        // DDialog.OPEN('betreffende Partie : #1#########'); //TODO: Dialog anpassen
        // DDialog.INPUT(1, TxtPartie);

        // DDialog.OPEN('Neue-PositionsNr. (ab): #1##########');
        // DDialog.INPUT(1, txtPartiePosStart);

        // DDialog.OPEN('Menge einzutragende neue Zeilen/Positionen: #1##########');
        // DDialog.INPUT(1, MengePartie);


        IF NOT CONFIRM('Eintrage ok ?\'
                        + 'Partie' + TxtPartie + '\'
                        + 'Anfangsposition: ' + txtPartiePos + '\'
                        + 'Menge:' + FORMAT(MengePartie)
                      ) THEN
            ERROR('Abbruch');

        //EInkaufszeile setzten
        txtPartiePos := txtPartiePosStart;
        "lrc_Purchase LineBase".SETFILTER("Document No.", TxtPartie);
        IF "lrc_Purchase LineBase".FIND('+') THEN BEGIN  //letzter Record ist gibt Daten
            u := "lrc_Purchase LineBase"."Line No." + 10000;
            FOR i := 1 TO MengePartie DO BEGIN
                "lrc_Purchase Line".init();
                "lrc_Purchase Line".SETFILTER("POI Batch Variant No.", TxtPartie + '-' + txtPartiePos);
                IF NOT "lrc_Purchase Line".FINDFIRST() THEN BEGIN
                    "lrc_Purchase Line".init();
                    "lrc_Purchase Line" := "lrc_Purchase LineBase";
                    //Daten
                    "lrc_Purchase Line"."Line No." := u;
                    "lrc_Purchase Line"."POI Batch No." := copystr(TxtPartie + '-' + txtPartiePos, 1, 20);
                    "lrc_Purchase Line"."POI Batch Variant No." := copystr(TxtPartie + '-' + txtPartiePos, 1, 20);

                    "lrc_Purchase Line"."Quantity Received" := 0;
                    "lrc_Purchase Line"."Quantity Invoiced" := 0;
                    "lrc_Purchase Line"."Qty. Received (Base)" := 0;
                    "lrc_Purchase Line"."Qty. Invoiced (Base)" := 0;

                    txtPartiePos := INCSTR(txtPartiePos);
                    u := u + 10000;
                    IF NOT CONFIRM('Einkaufszeile wird wie folgt erzeugt :' + '\'
                                  + 'Beleg   ' + "lrc_Purchase Line"."Document No." + '\'
                                  + 'Zeile   ' + FORMAT("lrc_Purchase Line"."Line No.") + '\'
                                  + 'Partie  ' + "lrc_Purchase Line"."POI Master Batch No." + '\'
                                  + 'Postion ' + "lrc_Purchase Line"."POI Batch No." + '\'
                                  + 'Pos.Var ' + "lrc_Purchase Line"."POI Batch Variant No." + '\'
                                ) THEN
                        ERROR('Abbruch');
                    "lrc_Purchase Line".insert();
                END;
            END;
        END ELSE
            ERROR('Funktion braucht eine Beispielzeile als Vorlage der Daten');

        //BatchVariant setzten
        txtPartiePos := txtPartiePosStart;
        "lrc_Batch VariantBase".SETFILTER("Master Batch No.", TxtPartie);
        IF "lrc_Batch VariantBase".FIND('+') THEN
            FOR i := 1 TO MengePartie DO BEGIN
                "lrc_Batch Variant".INIT();
                "lrc_Batch Variant".SETFILTER("No.", TxtPartie + '-' + txtPartiePos);
                IF NOT "lrc_Batch Variant".FIND('-') THEN BEGIN
                    "lrc_Batch Variant".INIT();
                    "lrc_Batch Variant" := "lrc_Batch VariantBase";
                    //Daten
                    "lrc_Batch Variant"."No." := copystr(TxtPartie + '-' + txtPartiePos, 1, 20);
                    "lrc_Batch Variant"."Batch No." := copystr(TxtPartie + '-' + txtPartiePos, 1, 20);
                    txtPartiePos := INCSTR(txtPartiePos);
                    IF NOT CONFIRM('Pos-Var wird wie folgt erzeugt :' + '\'
                                  + 'Pos.Var ' + "lrc_Batch Variant"."No." + '\'
                                  + 'Partie  ' + "lrc_Batch Variant"."Master Batch No." + '\'
                                  + 'Postion ' + "lrc_Batch Variant"."Batch No." + '\'
                                ) THEN
                        ERROR('Abbruch');
                    "lrc_Batch Variant".INSERT();
                END;
            END;

        //Dimensionswert Tbl 349 auch gesetzt ?
        txtPartiePos := txtPartiePosStart;
        lrc_DimensionValueBase.SETFILTER("Dimension Code", 'POSITION');
        lrc_DimensionValueBase.SETFILTER(Code, TxtPartie + '-' + txtPartiePos);
        IF lrc_DimensionValueBase.FINDFIRST() THEN
            FOR i := 1 TO MengePartie DO BEGIN
                lrc_DimensionValueTest.SETFILTER("Dimension Code", 'POSITION');
                lrc_DimensionValueTest.SETFILTER(Code, TxtPartie + '-' + txtPartiePos);
                IF lrc_DimensionValueTest.IsEmpty() THEN BEGIN
                    lrc_DimensionValue.INIT();
                    lrc_DimensionValue := lrc_DimensionValueBase;
                    lrc_DimensionValueBase.Code := copystr(TxtPartie + '-' + txtPartiePos, 1, 20);
                    txtPartiePos := INCSTR(txtPartiePos);
                    lrc_DimensionValueBase.insert();
                END;
            END ELSE
            ERROR('Dimensionswert der %1 in Tabelle 349 nicht gefunden', TxtPartie + '-' + txtPartiePos);
    end;

    procedure Purchase_ZeileKorrekturFelder()
    var
        TxtPartie: Text[30];
        txtZeilennr: Text[10];
    begin
        TxtPartie := '11-10666';
        txtZeilennr := '30000';

        // DDialog.OPEN('betreffende Partie : #1#########'); //TODO: Dialog anpassen
        // DDialog.INPUT(1, TxtPartie);

        // DDialog.OPEN('Zeilennummer : #1##########');
        // DDialog.INPUT(1, txtZeilennr);

        IF NOT CONFIRM('Eintrage ok ?\'
                        + 'Partie' + TxtPartie + '\'
                        + 'Zeile ' + txtZeilennr + '\'
                        + 'Feld Lief.nicht fakt.Menge = 0'
                      ) THEN
            ERROR('Abbruch');

        "lrc_Purchase Line".SETFILTER("Document No.", TxtPartie);
        "lrc_Purchase Line".SETFILTER("Line No.", txtZeilennr);
        IF NOT "lrc_Purchase Line".FIND('-') THEN ERROR('Zeile nicht gefunden');

        //"lrc_Purchase Line"."Qty. Rcd. Not Invoiced":=0; //(Lief. nicht fakt. Menge)
        "lrc_Purchase Line"."Location Code" := 'DEJONGRID';
        "lrc_Purchase Line".MODIFY();
    end;

    procedure Purchase_VKReklamation(var vrc_PurchaseHeader: Record "Purchase Header"; TakeValue: Boolean) ReklaFound: Boolean
    begin
        ReklaFound := FALSE;
    end;

    procedure Purchase_Wertermittlung(vco_MasterBatchNo: Code[20]; vco_BatchNo: Code[20]; vco_ItemNo: Code[20]; vtx_UnitPerMeasure: Text[30]; var rdc_AmountPerUnit: Decimal) ok: Boolean
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        EKUnitPerMeasure: Text[30];
        QuantityEKUnit: Decimal;
        QuantityVKUnit: Decimal;
        EKBetragPerUnit: Decimal;
        EKKgPerUnit: Decimal;
        EKBetragPerKg: Decimal;
        PosKgPerUnit: Decimal;
        PosBetragPerKg: Decimal;
        PosBetragPerUnit: Decimal;
        EKZeilenBetragMW: Decimal;
        ldc_PackValue: Decimal;
        ldc_PackValueInputLine: Decimal;
    begin
        ok := FALSE;

        lrc_BatchVariant.SETCURRENTKEY("Master Batch No.", "Batch No.");
        lrc_BatchVariant.SETFILTER("Master Batch No.", vco_MasterBatchNo);
        lrc_BatchVariant.SETFILTER("Batch No.", vco_BatchNo);
        IF NOT lrc_BatchVariant.FINDFIRST() THEN EXIT;

        lrc_ItemUnitofMeasure2.SETRANGE("Item No.", lrc_BatchVariant."Item No.");
        lrc_ItemUnitofMeasure2.SETRANGE(Code, lrc_BatchVariant."Unit of Measure Code");
        IF NOT lrc_ItemUnitofMeasure2.FINDFIRST() THEN EXIT;

        CASE lrc_BatchVariant.Source OF
            lrc_BatchVariant.Source::"Purch. Order":
                BEGIN
                    lrc_PurchaseLine.SETRANGE("Document No.", lrc_BatchVariant."Source No.");
                    lrc_PurchaseLine.SETRANGE("Line No.", lrc_BatchVariant."Source Line No.");
                    IF NOT lrc_PurchaseLine.FINDFIRST() THEN EXIT;
                    IF (lrc_PurchaseLine."Currency Code" <> '') AND (lrc_PurchaseLine."Currency Code" <> 'EUR') THEN BEGIN
                        lrc_PurchaseHeader.SETRANGE("No.", lrc_PurchaseLine."Document No.");
                        lrc_PurchaseHeader.FINDFIRST();
                        EKZeilenBetragMW := (lrc_PurchaseLine."Unit Cost" * lrc_PurchaseLine.Quantity) / lrc_PurchaseHeader."Currency Factor";
                    END ELSE
                        EKZeilenBetragMW := lrc_PurchaseLine."Unit Cost (LCY)" * lrc_PurchaseLine.Quantity;
                    //RS wg. Nulldivision
                    IF lrc_PurchaseLine.Quantity <> 0 THEN
                        EKBetragPerUnit := EKZeilenBetragMW / lrc_PurchaseLine.Quantity
                    ELSE
                        EKBetragPerUnit := 0;

                    IF lrc_PurchaseLine.Quantity <> 0 THEN
                        EKKgPerUnit := lrc_PurchaseLine."Quantity (Base)" / lrc_PurchaseLine.Quantity
                    ELSE
                        EKKgPerUnit := 0;
                    IF EKKgPerUnit <> 0 THEN
                        EKBetragPerKg := EKBetragPerUnit / EKKgPerUnit
                    ELSE
                        EKBetragPerKg := 0;
                    //RS.e
                    PosKgPerUnit := lrc_ItemUnitofMeasure2."Qty. per Unit of Measure";
                    PosBetragPerKg := EKBetragPerKg;
                    PosBetragPerUnit := (EKBetragPerKg * PosKgPerUnit);
                    rdc_AmountPerUnit := PosBetragPerUnit;
                    EKUnitPerMeasure := lrc_PurchaseLine."Unit of Measure Code";
                    ok := TRUE;
                END;
            lrc_BatchVariant.Source::"Packing Order":
                BEGIN       //RRR

                    //rs 160224 Neufassung Berechnung Wert Packauftrag

                    lrc_PackOrderHeader.GET(lrc_BatchVariant."Source No.");
                    lrc_PackOrderHeader.CALCFIELDS("Tot. Qty. Output (Base)", "Tot. Qty. Units Output");
                    lrc_PackOrderInputItems.SETRANGE("Doc. No.", lrc_PackOrderHeader."No.");
                    IF lrc_PackOrderInputItems.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            ldc_PackValueInputLine := 0;
                            Purchase_WertermittlungPack(lrc_PackOrderInputItems, ldc_PackValueInputLine);
                            ldc_PackValue += ldc_PackValueInputLine;
                        UNTIL lrc_PackOrderInputItems.NEXT() = 0;
                    lrc_PackOrderOutputItems.SETRANGE("Batch Variant No.", lrc_BatchVariant."No.");
                    IF lrc_PackOrderOutputItems.FINDSET(FALSE, FALSE) THEN BEGIN
                        IF lrc_PackOrderOutputItems.Quantity = 0 THEN
                            ERROR('Im Packauftrag %1 ist die Menge = 0', lrc_PackOrderOutputItems."Doc. No.");
                        rdc_AmountPerUnit := (ldc_PackValue / lrc_PackOrderOutputItems.Quantity) *
                                             (lrc_PackOrderOutputItems."Quantity (Base)" / lrc_PackOrderHeader."Tot. Qty. Output (Base)")
                    END ELSE
                        rdc_AmountPerUnit := 0;
                    ok := TRUE;
                    EXIT;

                END;
        END;

        //EKUnitPerMeasure
        //160EUR/St i der EK-Einhait  VK->18,14KG Colli  EK->18,0KG Colli
        //Bsp. Rep 5705 zur Wertermittlungbei Umlagerungsaufträgen

        lrc_ItemUnitofMeasure.SETRANGE("Item No.", vco_ItemNo);
        lrc_ItemUnitofMeasure.SETRANGE(Code, EKUnitPerMeasure);
        IF lrc_ItemUnitofMeasure.FINDSET() THEN
            QuantityEKUnit := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";

        lrc_ItemUnitofMeasure.SETRANGE(Code, vtx_UnitPerMeasure);  //der VKUnitPerMeasure
        IF lrc_ItemUnitofMeasure.FINDSET() THEN
            QuantityVKUnit := lrc_ItemUnitofMeasure."Qty. per Unit of Measure";

        //AmountPerUnit ist hier noch der EK-preis mit der EKUNit-Measure-> es erfogt Umrechnung
        IF (QuantityEKUnit <> 0) AND (QuantityVKUnit <> 0) THEN BEGIN
            rdc_AmountPerUnit := rdc_AmountPerUnit / QuantityEKUnit; //160 / 18 = 8,88
            rdc_AmountPerUnit := rdc_AmountPerUnit * QuantityVKUnit; //8,88 * 18,4 = 161,24
        END;
    end;

    procedure Purchase_WertermittlungPack(vrc_PackInput: Record "POI Pack. Order Input Items"; var rdc_PackInputValue: Decimal): Decimal
    var
        lrc_PackOrderHeader: Record "POI Pack. Order Header";
        ldc_EKWert: Decimal;
        ldc_EKQuantity: Decimal;
        ldc_CurrencyFactor: Decimal;
        ldc_PackValueInputLine2: Decimal;
        ldc_PackValue2: Decimal;
    begin
        //----------------------------------------------------------------------------------------
        //Funktion zur rekursiven Ermittlung der Werte eines Packauftrages
        //Aufruf aus Purchase_Wertermittlung, um statistischen Wert einer Umlagerung zu ermitteln und Report 50015 PackingOrderFiscal
        //vrc_PackInput Pack. Order Input Items
        //rdc_PackInputValue
        //----------------------------------------------------------------------------------------
        IF vrc_PackInput."Batch Variant No." <> '' THEN BEGIN    //rrr
            lrc_BatchVariant.GET(vrc_PackInput."Batch Variant No.");
            CASE lrc_BatchVariant.Source OF
                lrc_BatchVariant.Source::"Purch. Order":
                    BEGIN //PurchOrder
                        lrc_PurchaseLine.SETRANGE("POI Batch Variant No.", lrc_BatchVariant."No.");
                        lrc_PurchaseLine.FINDSET(FALSE, FALSE);
                        lrc_PurchaseHeader.GET(lrc_PurchaseLine."Document Type", lrc_PurchaseLine."Document No.");
                        IF lrc_PurchaseHeader."Currency Factor" <> 0 THEN
                            ldc_CurrencyFactor := lrc_PurchaseHeader."Currency Factor"
                        ELSE
                            ldc_CurrencyFactor := 1;
                        ldc_EKQuantity := lrc_PurchaseLine.Quantity;
                        IF ldc_EKQuantity = 0 THEN
                            ERROR('In der Bestellung - Position %1 ist die Menge = 0', lrc_PurchaseLine."POI Batch Variant No.");
                        ldc_EKWert := ((lrc_PurchaseLine."Unit Cost (LCY)" * ldc_EKQuantity) *
                                               (vrc_PackInput.Quantity / ldc_EKQuantity)) / ldc_CurrencyFactor;
                        rdc_PackInputValue := ldc_EKWert;
                        EXIT(rdc_PackInputValue);
                    END;
                lrc_BatchVariant.Source::"Packing Order":
                    BEGIN //Packing Order
                        lrc_PackOrderHeader.SETRANGE("Master Batch No.", vrc_PackInput."Master Batch No.");
                        lrc_PackOrderHeader.FINDSET();
                        lrc_PackOrderHeader.CALCFIELDS("Tot. Qty. Output (Base)");
                        lrc_PackInput2.SETRANGE("Doc. No.", lrc_PackOrderHeader."No.");
                        IF lrc_PackInput2.FINDSET(FALSE, FALSE) THEN
                            REPEAT
                                ldc_PackValueInputLine2 := 0;
                                Purchase_WertermittlungPack(lrc_PackInput2, ldc_PackValueInputLine2);
                                lrc_PackOutput.SETRANGE("Batch Variant No.", vrc_PackInput."Batch Variant No.");
                                lrc_PackOutput.FINDSET(FALSE, FALSE);
                                ldc_PackValue2 += (ldc_PackValueInputLine2 * (vrc_PackInput.Quantity / lrc_PackOutput.Quantity));
                            UNTIL lrc_PackInput2.NEXT() = 0;
                        rdc_PackInputValue := ldc_PackValue2;
                        EXIT(rdc_PackInputValue);
                    END;
            END;

        END;
        EXIT(0);
    end;

    procedure Purchase_Handlesabrechnung(var pr_PurchHeader: Record "Purchase Header")
    var
        lr_EKAbrechnung2: Record "POI EK-Abrechnung";
        l_LastRecNo: Integer;
        l_ChangeAllPos: Boolean;
    begin
        //Fkt übernimmt die Einkaufszeilen in die Zeilen der HAndlesabrechnung

        lr_EKAbrechnung.SETRANGE(Bestellnummer, pr_PurchHeader."No.");
        IF lr_EKAbrechnung.FINDLAST() THEN
            l_LastRecNo := lr_EKAbrechnung.Zeilennummer + 10000
        ELSE
            l_LastRecNo := 10000;

        l_ChangeAllPos := TRUE; //Alle eintragen/erneuern
        lr_EKAbrechnung.SETFILTER(Positionsnummer, '<>%1', '');
        IF lr_EKAbrechnung.FINDSET(TRUE, TRUE) THEN BEGIN
            Choicetext := ('Positionen in Abrechnung erneuern'
                          + ',' + 'vorhandene Pos. bleiben so'
                          + ',' + 'Abbruch'
                         );
            OptioNo := STRMENU(Choicetext, 1);
            CASE OptioNo OF
                1:
                    l_ChangeAllPos := TRUE;
                2:
                    l_ChangeAllPos := FALSE;
                ELSE
                    EXIT;
            END;
        END;

        lr_PurchLine.SETRANGE("Document Type", pr_PurchHeader."Document Type");
        lr_PurchLine.SETRANGE("Document No.", pr_PurchHeader."No.");
        lr_PurchLine.SETRANGE(Type, lr_PurchLine.Type::Item);
        lr_PurchLine.SETFILTER("No.", '<>%1', '');
        lr_PurchLine.SETFILTER(Quantity, '<>0');
        IF lr_PurchLine.FINDSET() THEN
            REPEAT
                IF lr_PurchLine."POI Batch No." <> '' THEN BEGIN
                    lr_EKAbrechnung.SETRANGE(Positionsnummer, lr_PurchLine."POI Batch No.");
                    IF NOT lr_EKAbrechnung.FINDFIRST() THEN BEGIN
                        lr_EKAbrechnung2.INIT();
                        lr_EKAbrechnung2.Bestellnummer := pr_PurchHeader."No.";
                        lr_EKAbrechnung2.Zeilennummer := l_LastRecNo;
                        l_LastRecNo += 10000;
                        lr_EKAbrechnung2.Positionsnummer := lr_PurchLine."POI Batch No.";
                        lr_EKAbrechnung2.Beschreibung := lr_PurchLine.Description;
                        lr_EKAbrechnung2.Abrechnungsmenge := lr_PurchLine.Quantity;
                        lr_EKAbrechnung2.Abrechnungspreis := lr_PurchLine."Direct Unit Cost";  //lrc_PurchaseLine."Unit Cost" -> hat RAbatt
                        lr_EKAbrechnung2.Gesamtpreis := lr_PurchLine."Line Amount";
                        //171106 rs kein Rg. Rabatt aus Zeile übernehmen
                        IF NOT lr_PurchLine."Allow Invoice Disc." THEN
                            lr_EKAbrechnung2."keinRg-Rabatt" := TRUE
                        ELSE
                            lr_EKAbrechnung2."FAS Line Disc. Amount" :=
                              (lr_PurchLine."Line Amount" * (lr_PurchLine."Inv. Discount Amount" / lr_PurchLine."Line Amount"));
                        //171106 rs.e
                        lr_EKAbrechnung2.INSERT();
                    END ELSE//Zeile schon vorhanden erneuern oder belassen ?
                        IF l_ChangeAllPos THEN BEGIN
                            lr_EKAbrechnung.Beschreibung := lr_PurchLine.Description;
                            lr_EKAbrechnung.Abrechnungsmenge := lr_PurchLine.Quantity;
                            lr_EKAbrechnung.Abrechnungspreis := lr_PurchLine."Direct Unit Cost"; //lrc_PurchaseLine."Unit Cost" -> hat Rabatt
                            lr_EKAbrechnung.Gesamtpreis := lr_PurchLine."Line Amount";
                            IF NOT lr_EKAbrechnung."keinRg-Rabatt" THEN
                                lr_EKAbrechnung."FAS Line Disc. Amount" :=
                                  (lr_PurchLine."Line Amount" * (lr_PurchLine."Inv. Discount Amount" / lr_PurchLine."Line Amount"));
                            lr_EKAbrechnung.MODIFY();
                        END;
                END;
            UNTIL lr_PurchLine.NEXT() = 0;
    end;

    procedure Purchase_GetInfo(var vrc_PurchaseHeader: Record "Purchase Header"; Search: Integer): Boolean
    var
        lrc_PurchClaimNotifyHeader: Record "POI Purch. Claim Notify Header";
    begin
        CASE Search OF
            1:
                BEGIN
                    lrc_PurchClaimNotifyHeader.SETRANGE("Purch. Order No.", vrc_PurchaseHeader."No.");
                    IF not lrc_PurchClaimNotifyHeader.IsEmpty()
                      THEN
                        EXIT(TRUE);
                END;
        END;
        EXIT(FALSE)
    end;

    procedure Purchase_GetEKBatchVariant(var vrc_BatchVariant: Record "POI Batch Variant"): Boolean
    var
        MerkeInputBatchVarNo: Code[20];
        FoundMoreInputBatchVar: Boolean;
    begin
        lrc_BatchVariant := vrc_BatchVariant;
        //,Purch. Order,Packing Order,Sorting Order,,Item Journal Line,Inventory Journal Line,,,Company Copy,,,Dummy
        CASE lrc_BatchVariant.Source OF
            lrc_BatchVariant.Source::"Purch. Order":
                EXIT(TRUE);
            lrc_BatchVariant.Source::"Packing Order":
                BEGIN
                    lrc_PackOrderRevperInpBatch.SETRANGE("Output Batch Variant No.", lrc_BatchVariant."No.");
                    lrc_PackOrderRevperInpBatch.SETRANGE("Doc. No.", lrc_BatchVariant."Source No.");
                    IF lrc_PackOrderRevperInpBatch.FIND('-') THEN
                        //Verschachtelter Pack ?
                        //lrc_BatchVariant.SETRANGE("No.",");
                        //case lrc_BatchVariant.Source OF

                        IF lrc_PackOrderRevperInpBatch.COUNT() = 1 THEN BEGIN
                            vrc_BatchVariant.Reset();
                            vrc_BatchVariant.SETRANGE("Master Batch No.", lrc_PackOrderRevperInpBatch."Input Master Batch No.");
                            vrc_BatchVariant.SETRANGE("Batch No.", lrc_PackOrderRevperInpBatch."Input Batch No.");
                            vrc_BatchVariant.SETRANGE("No.", lrc_PackOrderRevperInpBatch."Input Batch Variant No.");
                            IF vrc_BatchVariant.FIND('-') THEN
                                EXIT(TRUE)
                            ELSE
                                EXIT(FALSE);
                        END ELSE BEGIN
                            //Mehrere Inputs ?? alle von einer Partie ?? dann ok und eindeutig zuodnenbar
                            //POI 001 PACKPurc JST 181213 001 Änderungen
                            //                                PackInput alle von der gleichen Partie -> OK,
                            FoundMoreInputBatchVar := FALSE;
                            MerkeInputBatchVarNo := lrc_PackOrderRevperInpBatch."Input Batch Variant No.";
                            REPEAT
                                IF MerkeInputBatchVarNo <> lrc_PackOrderRevperInpBatch."Input Batch Variant No." THEN
                                    FoundMoreInputBatchVar := TRUE;
                            UNTIL lrc_PackOrderRevperInpBatch.NEXT() = 0;
                            IF NOT FoundMoreInputBatchVar THEN BEGIN //nur einen gefunden, dann ok.
                                vrc_BatchVariant.Reset();
                                vrc_BatchVariant.SETRANGE("Master Batch No.", lrc_PackOrderRevperInpBatch."Input Master Batch No.");
                                vrc_BatchVariant.SETRANGE("Batch No.", lrc_PackOrderRevperInpBatch."Input Batch No.");
                                vrc_BatchVariant.SETRANGE("No.", lrc_PackOrderRevperInpBatch."Input Batch Variant No.");
                                IF vrc_BatchVariant.FIND('-') THEN
                                    EXIT(TRUE)
                                ELSE
                                    EXIT(FALSE);
                            END;
                        END;
                END;
        END;
    end;

    procedure Kostenartsetzen(vrc_PurchHeader: Record "Purchase Header")
    var
        lrc_GeneralLedgerSetup: Record "General Ledger Setup";
        lrc_GeneralPostingSetup: Record "General Posting Setup";
        lrc_GLAccount: Record "G/L Account";
        text01Txt: Label 'Buchungsmatrixeinrichtung existiert nicht zu Geschäftsbuchungsgruppe %1, Produktbuchungsgruppe %2', Comment = '%1 %2';
    begin
        //RS laden von Kostenart
        lrc_GeneralLedgerSetup.GET();
        IF lrc_GeneralLedgerSetup."Global Dimension 2 Code" = 'KOSTENART' THEN BEGIN
            lrc_PurchLine.RESET();
            lrc_PurchLine.SETRANGE("Document No.", vrc_PurchHeader."No.");
            lrc_PurchLine.SETRANGE("Document Type", vrc_PurchHeader."Document Type");
            IF lrc_PurchLine.FINDSET() THEN
                REPEAT
                    IF lrc_PurchLine."Shortcut Dimension 2 Code" = '' THEN
                        IF lrc_PurchLine.Type = lrc_PurchLine.Type::Item THEN
                            IF NOT lrc_GeneralPostingSetup.GET(lrc_PurchLine."Gen. Bus. Posting Group", lrc_PurchLine."Gen. Prod. Posting Group") THEN
                                ERROR(text01Txt, lrc_PurchLine."Gen. Bus. Posting Group", lrc_PurchLine."Gen. Prod. Posting Group")
                            ELSE
                                IF vrc_PurchHeader."Document Type" = vrc_PurchHeader."Document Type"::"Credit Memo" THEN BEGIN
                                    lrc_GLAccount.GET(lrc_GeneralPostingSetup."Purch. Credit Memo Account");
                                    lrc_PurchLine.VALIDATE(lrc_PurchLine."Shortcut Dimension 2 Code", lrc_GLAccount."Global Dimension 2 Code");
                                    lrc_PurchLine.MODIFY();
                                END ELSE BEGIN
                                    lrc_GLAccount.GET(lrc_GeneralPostingSetup."Purch. Account");
                                    lrc_PurchLine.VALIDATE(lrc_PurchLine."Shortcut Dimension 2 Code", lrc_GLAccount."Global Dimension 2 Code");
                                    lrc_PurchLine.MODIFY();
                                END;
                UNTIL lrc_PurchLine.NEXT() = 0;
            COMMIT();
        END;
    end;

    var
        "lrc_Purchase Line": Record "Purchase Line";
        "lrc_Purchase LineBase": Record "Purchase Line";
        "lrc_Batch Variant": Record "POI Batch Variant";
        "lrc_Batch VariantBase": Record "POI Batch Variant";
        lrc_ItemUnitofMeasure: Record "Item Unit of Measure";
        lrc_PurchaseHeader: Record "Purchase Header";
        lrc_PurchaseLine: Record "Purchase Line";
        lrc_BatchVariant: Record "POI Batch Variant";
        lrc_ItemUnitofMeasure2: Record "Item Unit of Measure";
        lrc_PackOrderInputItems: Record "POI Pack. Order Input Items";
        lrc_PackOrderOutputItems: Record "POI Pack. Order Output Items";
        lrc_PackInput2: Record "POI Pack. Order Input Items";
        lr_EKAbrechnung: Record "POI EK-Abrechnung";
        lr_PurchLine: Record "Purchase Line";
        lrc_PackOutput: Record "POI Pack. Order Output Items";
        lrc_PackOrderRevperInpBatch: Record "POI PaOrder Rev. per Inp.Batch";
        lrc_PurchLine: Record "Purchase Line";
        "lrc_W.D. Journal Line": Record "POI W.D. Journal Line";
        WDJournTemplate: Record "POI W.D. Journ. Template";
        lrc_Customer: Record Customer;
        lrc_DimensionValueBase: Record "Dimension Value";
}

