codeunit 50016 "POI GlobalFunctionsMgt"
{
    procedure IsTextNumber(InCode: Code[20]): Boolean
    var
        LocalInteger: Integer;
    begin
        IF InCode = '' THEN
            EXIT(FALSE);

        IF EVALUATE(LocalInteger, InCode) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    procedure SelectDateByCalendar(var vdt_Date: Date): Boolean
    var
        lrc_ADFSetup: Record "POI ADF Setup";
    // ldt_Datum: Date;
    // lfm_CalendarI: Form "5087920"; //TODO: pages generieren für Kalender aus ADF
    // lfm_CalendarII: Form "5087921";
    begin
        // -------------------------------------------------------------------------------------------
        // Funktion zur Datumsauswahl über einen Kalender
        // -------------------------------------------------------------------------------------------

        lrc_ADFSetup.GET();

        // CASE lrc_ADFSetup."Lookup Calendar Date Fields" OF
        //     lrc_ADFSetup."Lookup Calendar Date Fields"::"Calendar I":
        //         BEGIN

        //             // Kalender I
        //             IF vdt_Date <> 0D THEN
        //                 lfm_CalendarI.SetDate(vdt_Date)
        //             ELSE
        //                 lfm_CalendarI.SetDate(TODAY());
        //             IF lfm_CalendarI.RUNMODAL = ACTION::OK THEN BEGIN
        //                 vdt_Date := lfm_CalendarI.GetDate;
        //                 CLEAR(lfm_CalendarI);
        //                 EXIT(TRUE);
        //             END ELSE BEGIN
        //                 CLEAR(lfm_CalendarI);
        //                 EXIT(FALSE);
        //             END;

        //         END;

        //     lrc_ADFSetup."Lookup Calendar Date Fields"::"Calendar II":
        //         BEGIN

        //             // Kalender II
        //             IF vdt_Date <> 0D THEN
        //                 lfm_CalendarII.SetDate(vdt_Date, '', '')
        //             ELSE
        //                 lfm_CalendarII.SetDate(Today(), '', '');
        //             IF lfm_CalendarII.RUNMODAL = ACTION::LookupOK THEN BEGIN
        //                 vdt_Date := lfm_CalendarII.GetDate;
        //                 EXIT(TRUE);
        //             end ELSE
        //                 EXIT(FALSE);

        //         END;

        //     lrc_ADFSetup."Lookup Calendar Date Fields"::" ":
        //         EXIT(FALSE);

        // END;
    end;

    procedure IsTextText(vco_Code: Code[20]): Boolean
    begin
        // -------------------------------------------------------------------------------------------
        // Funktion zur Prüfung ob ein Textinhalt keine numerischen Zeichen enthält
        // -------------------------------------------------------------------------------------------

        IF vco_Code = '' THEN
            EXIT(TRUE);

        IF STRPOS(vco_Code, '0') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '1') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '2') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '3') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '4') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '5') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '6') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '7') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '8') > 0 THEN
            EXIT(FALSE);
        IF STRPOS(vco_Code, '9') > 0 THEN
            EXIT(FALSE);

        EXIT(TRUE)
    end;

    procedure FindArrIndexNr(vco_ArrCode: array[1000] of Code[20]; vin_Dimension: Integer; vco_SuchCode: Code[20]): Integer
    var
        "lin_ArrZähler": Integer;
    begin
        // -----------------------------------------------------------------------------------------
        // Funktion zur Suche ob ein Inhalt in einem Array mit 1000 Dimensionen vorhanden ist
        // -----------------------------------------------------------------------------------------

        lin_ArrZähler := 1;
        WHILE lin_ArrZähler <= vin_Dimension DO BEGIN
            IF vco_SuchCode = vco_ArrCode[lin_ArrZähler] THEN
                EXIT(lin_ArrZähler);
            lin_ArrZähler := lin_ArrZähler + 1;
        END;
        EXIT(0);
    end;

    procedure FormatIntegerWithBeginningZero(NumberValue: Integer; NumberLength: Integer) NumberCode: Code[20]
    begin
        // ----------------------------------------------------------------------------------
        // Funktion zum Wandeln eines Integers in Code und Auffüllen mit führenden Nullen
        // ----------------------------------------------------------------------------------

        NumberCode := FORMAT(NumberValue);
        WHILE STRLEN(NumberCode) < NumberLength DO
            NumberCode := copystr('0' + NumberCode, 1, 20);
        EXIT(NumberCode);
    end;
}