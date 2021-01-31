codeunit 5110345 "POI Position Planning"
{
    var
        AGILESText002Txt: Label 'Date %1 doesn''t belong to the Week %2.', Comment = '%1 %2';

    procedure GeneratePlanningWeek(rdt_Date: Date; vco_VoyageNo: Code[20]) rco_PlanningWeek: Code[5]
    var
        lin_Year: Integer;
        lco_Year: Code[4];
        lin_Week: Integer;
        lco_Week: Code[2];
        lin_DayInWeek: Integer;
    begin
        rco_PlanningWeek := '';

        IF rdt_Date <> 0D THEN BEGIN
            // Jahr ermitteln
            lin_Year := DATE2DWY(rdt_Date, 3);
            // Woche ermitteln
            lin_Week := DATE2DWY(rdt_Date, 2);
            // Tag der Woche ermitteln ( 1-7, Monday equals 1 )
            lin_DayInWeek := DATE2DWY(rdt_Date, 1);
            AbweichendePlanungswoche(vco_VoyageNo, lin_DayInWeek, lin_Week, lin_Year);
            lco_Year := FORMAT(lin_Year);
            IF STRLEN(lco_Year) > 2 THEN
                lco_Year := COPYSTR(lco_Year, STRLEN(lco_Year) - 1, 2)
            ELSE
                IF STRLEN(lco_Year) = 1 THEN
                    lco_Year := copystr('0' + lco_Year, 1, 4);
            lco_Week := FORMAT(lin_Week);
            IF lin_Week < 10 THEN
                rco_PlanningWeek := copystr('0' + lco_Week + '_' + lco_Year, 1, 5)
            ELSE
                rco_PlanningWeek := copystr(lco_Week + '_' + lco_Year, 1, 5);
        END;

        EXIT(rco_PlanningWeek);
    end;

    procedure CalculateFirstWeekDay(vco_DispositionWeek: Code[5]; vco_VoyageNo: Code[20]): Date
    var
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lrc_Voyage: Record "POI Voyage";
        lin_Week: Integer;
        lin_Year: Integer;
        ldt_Date: Date;
        lin_StartingdatePlanningWeek: Integer;
        lco_Abzugstage: Code[3];
    begin
        IF COPYSTR(vco_DispositionWeek, 3, 1) = '_' THEN BEGIN
            EVALUATE(lin_Week, COPYSTR(vco_DispositionWeek, 1, 2));
            EVALUATE(lin_Year, '20' + COPYSTR(vco_DispositionWeek, 4, 2));

            lrc_FruitVisionSetup.GET();
            // eine Woche beginnt Standardmäßig immer Montags
            lin_StartingdatePlanningWeek := 1;
            ldt_Date := DWY2DATE(1, lin_Week, lin_Year);
            IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
                lco_Abzugstage := '';

                // Defaultmäßig ist der Starttag der Planungswoche bei Del Monte der Freitag
                lin_StartingdatePlanningWeek := 5;
                IF vco_VoyageNo <> '' THEN
                    IF lrc_Voyage.GET(vco_VoyageNo) THEN
                        // in der Reise kann aber etwas abweichendes hinterlegt sein
                        IF lrc_Voyage."Starting Day Planning Activ" THEN
                            lin_StartingdatePlanningWeek := lrc_Voyage."Starting Day Planning Week";

                CASE lin_StartingdatePlanningWeek OF
                    1:
                        lco_Abzugstage := '';
                    2:
                        lco_Abzugstage := '-6T';
                    3:
                        lco_Abzugstage := '-5T';
                    4:
                        lco_Abzugstage := '-4T';
                    5:
                        lco_Abzugstage := '-3T';
                    6:
                        lco_Abzugstage := '-2T';
                    7:
                        lco_Abzugstage := '-1T';
                END;

                IF lco_Abzugstage <> '' THEN
                    ldt_Date := CALCDATE(lco_Abzugstage, ldt_Date);
            END;
            EXIT(ldt_Date);
        END;
        EXIT(0D);
    end;

    procedure TestDateBelongToDispoWeek(vdt_Date: Date; vco_DispositionWeek: Code[5]; vco_VoyageNo: Code[20])
    var
        lcu_PositionPlanning: Codeunit "POI Position Planning";
        lco_DispositionWeek: Code[5];
    begin
        lco_DispositionWeek := lcu_PositionPlanning.GeneratePlanningWeek(vdt_Date, vco_VoyageNo);
        IF vco_DispositionWeek <> lco_DispositionWeek THEN
            ERROR(AGILESText002Txt, vdt_Date, vco_DispositionWeek);
    end;

    procedure AbweichendePlanungswoche(vco_VoyageNo: Code[20]; var rin_DayInWeek: Integer; var rin_Week: Integer; var rin_Year: Integer)
    var
        lrc_Voyage: Record "POI Voyage";
        lrc_FruitVisionSetup: Record "POI ADF Setup";
        lin_StartingdatePlanningWeek: Integer;
    begin
        lrc_FruitVisionSetup.GET();

        // eine Woche beginnt Standardmäßig immer Montags
        lin_StartingdatePlanningWeek := 1;
        IF lrc_FruitVisionSetup."Internal Customer Code" = 'DELMONTEDE' THEN BEGIN
            // Defaultmäßig ist der Starttag der Planungswoche bei Del Monte der Freitag
            lin_StartingdatePlanningWeek := 5;
            IF vco_VoyageNo <> '' THEN
                IF lrc_Voyage.GET(vco_VoyageNo) THEN
                    // in der Reise kann aber etwas abweichendes hinterlegt sein
                    IF lrc_Voyage."Starting Day Planning Activ" THEN
                        lin_StartingdatePlanningWeek := lrc_Voyage."Starting Day Planning Week";
            IF (rin_DayInWeek >= lin_StartingdatePlanningWeek) THEN
                IF rin_Week < 52 THEN
                    rin_Week := rin_Week + 1
                ELSE BEGIN
                    rin_Week := 1;
                    rin_Year := rin_Year + 1;
                END;
        END;
    end;
}

