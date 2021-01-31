codeunit 50019 "POI Credit Limit Functions"
{
    procedure CustCreditLimitDateCheck()
    var
        Mail: Codeunit "SMTP Mail";
        CheckFormula: list of [DateFormula];
        i: Integer;
        Receipients: list of [Text];
        Sender: Text[100];
        l_Subject: Text[250];
        l_BodyLine: Text[1024];
        l_QualityMgtInsert: Boolean;
        l_KreditCheckDate: Boolean;
        QSExists: Boolean;
        QSDateold: Boolean;
        CheckDate: Date;
        SubjectCreditlimInsTxt: label 'Ablauf von Kreditvers. Limit - Debitor %1 %2 %3   - Mandant: %4', Comment = '%1 %2 %3 %4';
        BodyLineCreditlimInsTxt: Label 'Für den Debitor %1 %2 %3 wird das Kreditversicherungslimit in Höhe von %4 am %5 verfallen.', Comment = '%1 %2 %3 %4 %5';
        SubjectCreditlimInternTxt: Label 'Ablauf von Kreditlimit Intern - Debitor %1 %2 %3 - Mandant: %4', Comment = '%1 %2 %3 %4';
        BodyLineCreditlimInternTxt: Label 'Für den Debitor %1 %2 %3 wird das Interne Kreditlimit in Höhe von %4 am %5 verfallen.', Comment = '%1 %2 %3 %4 %5';
        SubjectCreditlimExtraTxt: Label 'Ablauf von Zusatz-Kreditver. Limit - Debitor %1 %2 %3 - Mandant:  %4', Comment = '%1 %2 %3 %4';
        BodyLineCreditlimExtraTxt: Label 'Für den Debitor %1 %2 %3 wird das Zusatzversicherungslimit in Höhe von %4 am %5 verfallen.', Comment = '%1 %2 %3 %4 %5';
    begin
        SalesSetup.ChangeCompany(POICompany.GetBasicCompany());
        SalesSetup.Get();
        CheckFormula.Add(SalesSetup."POI Credit Check first");
        CheckFormula.Add(SalesSetup."POI Credit Check second");
        QualityMgt.CHANGECOMPANY(POICompany.GetBasicCompany());
        POICompany.Reset();
        POICompany.setrange("Synch Masterdata", true);
        POICompany.SetRange("Basic Company", false);
        if POICompany.FindSet() then
            repeat
                Cust.CHANGECOMPANY(POICompany.Mandant);
                SalesPurchPerson.CHANGECOMPANY(POICompany.Mandant);
                Cust.Reset();
                Cust.SetRange("POI No Insurance", False);
                Cust.SetRange("No.", '10001');
                IF Cust.FINDSET() THEN
                    repeat
                        for i := 1 to 2 do begin
                            //Prüfdatum generieren
                            Checkdate := CALCDATE(CheckFormula.get(i));
                            //prüfen, ob schon in QS vorhanden
                            if i = 1 then begin
                                QSExists := false;
                                QSDateold := false;
                                IF QualityMgt.GET(Cust."No.", QualityMgt."Source Type"::Customer) THEN begin
                                    QSExists := true;
                                    IF (QualityMgt."Cust CreditLimit Date Check" <> TODAY) THEN
                                        QSDateold := true;
                                end else begin
                                    QSExists := false;
                                    QSDateold := true
                                END;
                            end;
                            //Ende prüfen
                            //1. Kreditversicherung COFACE - in 10 Tagen bzw. heute:
                            if (Cust."POI Cred. Ins. Limit val. till" = Checkdate) then begin
                                if QSExists then begin
                                    if QSDateold THEN
                                        l_KreditCheckDate := true
                                end ELSE BEGIN
                                    l_QualityMgtInsert := true;
                                    l_KreditCheckDate := true;
                                END;
                                IF l_KreditCheckDate THEN BEGIN
                                    CLEAR(Mail);
                                    l_Subject := strsubstno(SubjectCreditlimInsTxt, Cust."No.", Cust.Name, Cust."Name 2", POICompany.Mandant);
                                    l_BodyLine := strsubstno(BodyLineCreditlimInsTxt, Cust."No.", Cust.Name, Cust."Name 2", Cust."POI Credit Ins. Credit Limit", Cust."POI Cred. Ins. Limit val. till");
                                    Clear(Receipients);
                                    MailSetup.GetMailSenderReceiver('QS', 'CREDITLIMITCHECK', Sender, Receipients, POICompany.Mandant);
                                    if SalesPurchPerson.GET(Cust."Salesperson Code") then
                                        Receipients.Add(SalesPurchPerson."E-Mail");
                                    Mail.CreateMessage('HansCreditlimitPrüfung', Sender, Receipients, l_Subject, l_BodyLine);
                                    Mail.Send();
                                END;
                            end;
                            //1.Ende
                            //2. Kreditlimit intern - in 10 Tagen bzw. heute:
                            IF Cust."POI Int. Cred. Limit val. till" = Checkdate THEN BEGIN
                                if QSExists then
                                    if QSDateold THEN
                                        l_KreditCheckDate := true
                                    ELSE BEGIN
                                        l_QualityMgtInsert := true;
                                        l_KreditCheckDate := true;
                                    END;
                                IF l_KreditCheckDate THEN BEGIN
                                    CLEAR(Mail);
                                    l_Subject := strsubstno(SubjectCreditlimInternTxt, Cust."No.", Cust.Name, Cust."Name 2", POICompany.Mandant);
                                    l_BodyLine := strsubstno(BodyLineCreditlimInternTxt, Cust."No.", Cust.Name, Cust."Name 2", Cust."POI Internal Credit Limit", Cust."POI Int. Cred. Limit val. till");
                                    Clear(Receipients);
                                    MailSetup.GetMailSenderReceiver('QS', 'CREDITLIMITCHECK', Sender, Receipients, POICompany.Mandant);
                                    if SalesPurchPerson.GET(Cust."Salesperson Code") then
                                        Receipients.Add(SalesPurchPerson."E-Mail");
                                    Mail.CreateMessage('HansCreditlimitInternPrüfung', Sender, Receipients, l_Subject, l_BodyLine);
                                    ///???Mail.Send();
                                END;
                            END;
                            //2.Ende
                            //3. Zusatzversicherung - in 10 Tagen bzw. heute:
                            IF Cust."POI Extra Limit valid to" = Checkdate THEN BEGIN
                                if QSExists then
                                    if QSDateold THEN
                                        l_KreditCheckDate := true
                                    ELSE BEGIN
                                        l_QualityMgtInsert := true;
                                        l_KreditCheckDate := true;
                                    END;
                                IF l_KreditCheckDate THEN BEGIN
                                    CLEAR(Mail);
                                    l_Subject := strsubstno(SubjectCreditlimExtraTxt, Cust."No.", Cust.Name, Cust."Name 2", POICompany.Mandant);
                                    l_BodyLine := strsubstno(BodyLineCreditlimExtraTxt, Cust."No.", Cust.Name, Cust."Name 2", Cust."POI Extra Limit", Cust."POI Extra Limit valid to");
                                    clear(Receipients);
                                    MailSetup.GetMailSenderReceiver('QS', 'CREDITLIMITCHECK', Sender, Receipients, POICompany.Mandant);
                                    if SalesPurchPerson.GET(Cust."Salesperson Code") THEN
                                        Receipients.Add(SalesPurchPerson."E-Mail");
                                    Mail.CreateMessage('HansCreditlimitZusatzPrüfung', Sender, Receipients, l_Subject, l_BodyLine);
                                    ///???Mail.Send();
                                END;
                            END;
                            //3.Ende
                            if i = 2 then begin
                                IF l_QualityMgtInsert THEN BEGIN
                                    QualityMgt.INIT();
                                    QualityMgt."No." := Cust."No.";
                                    QualityMgt."Source Type" := QualityMgt."Source Type"::Customer;
                                    QualityMgt."Cust CreditLimit Date Check" := Today();
                                    QualityMgt."Cust Credit Date Check Execute" := true;
                                    QualityMgt.INSERT();
                                END;
                                IF l_KreditCheckDate THEN BEGIN
                                    QualityMgt."Cust CreditLimit Date Check" := Today();
                                    QualityMgt."Cust Credit Date Check Execute" := true;
                                    QualityMgt.MODIFY();
                                END;
                            end;
                        end;
                    until Cust.Next() = 0;
            until POICompany.Next() = 0;
    end;

    procedure LimitInternGL(QualityMgt: Record "POI Quality Management"; Company: Text[30]; p_xKreditLimit: Decimal; p_KreditLimit: Decimal)
    var
        l_Company: Text[110];
        l_HAAnfrageLimitIntern: Text[1024];
        HAAnfrageLimitInternTxt: label 'Bitte das Kreditversicherungslimit %1  auf Veranlassung von %2 von %3 auf %4 anpassen. Bitte eine entsprechende Anfrage bei der Kreditversicherung veranlassen.', Comment = '%1 %2 %3 %4';
    begin
        IF Company = 'für PIES' THEN
            l_Company := 'PI European Sourcing';
        IF Company = 'für PIF' THEN
            l_Company := 'PI Fruit';
        IF Company = 'für PIO' THEN
            l_Company := 'PI Organics';
        IF Company = 'für PIB' THEN
            l_Company := 'PI Bananas';
        IF Company = 'für PIDG' THEN
            Company := 'PI Dutch Growers';
        IF Company = 'für PI' THEN
            l_Company := 'Port International';

        l_HAAnfrageLimitIntern := StrSubstNo(HAAnfrageLimitInternTxt, Company, UPPERCASE(USERID), p_xKreditLimit, p_KreditLimit);

        IF l_HAAnfrageLimitIntern <> '' THEN
            LimitInternGLMail(QualityMgt."No.", QualityMgt."Source Type", l_Company, l_HAAnfrageLimitIntern);

    end;

    procedure LimitInternGLMail(CustVendNo: Code[20]; p_SourceType: enum "POI Source Type"; ForCompany: Text[110]; HAAnfrageLimitIntern: Text[1024])
    var
        Mail: Codeunit "SMTP Mail";
        l_Subject: Text[140];
        l_BodyLine: Text[1024];
        Receipients: list of [Text];
        Sender: Text[100];
        SubjectDebitorTxt: label '<br> Bitte Kreditversicherungslimit anfragen/ändern: Debitor %1 %2 %3', Comment = '%1=No %2=Name %3=Company';
        SubjectKreditorTxt: label '<br> Bitte Kreditversicherungslimit anfragen/ändern: Kreditor %1 %2 %3', Comment = '%1=No %2=Name %3=Company';
    begin
        l_Subject := '';
        l_BodyLine := '';
        CLEAR(Mail);

        case p_SourceType of
            p_SourceType::Customer:
                if Cust.GET(CustVendNo) THEN
                    l_Subject := strsubstno(SubjectDebitorTxt, Cust."No.", Cust.Name, ForCompany);
            p_SourceType::Vendor:
                if Vend.Get(CustVendNo) then
                    l_Subject := strsubstno(SubjectKreditorTxt, Vend."No.", Vend.Name, ForCompany);
        end;
        l_BodyLine := HAAnfrageLimitIntern;
        clear(Receipients);
        MailSetup.GetMailSenderReceiver('QS', 'CREDITLIMITANFRAGE', Sender, Receipients, POICompany.Mandant);
        Mail.CreateMessage('Kreditlimitanfrage', Sender, Receipients, l_Subject, l_BodyLine);
        Mail.Send();
    END;

    procedure ImportCofaceFromPath(Importpath: Code[250]; Archivpath: Text[250]; InsNo: code[20])
    var

        Filemgt: Codeunit "File Management";
        ServerFileName: Text[250];
        Filename: Text[250];
    begin
        CFFile.RESET();
        CFFile.SETRANGE(Path, Importpath); // hier Ordnerpfad
        CFFile.SETRANGE("Is a file", TRUE); // muss
        CFFile.SETFILTER(Name, '*.xlsx');  // kann
        IF CFFile.FINDSET() THEN
            REPEAT
                ServerfileName := copystr(Filemgt.ServerTempFileName('xlsx'), 1, MaxStrLen(ServerfileName));
                Filename := CFFile.Path + '\' + CFFile.Name;
                File.Copy(Filename, ServerFileName);
                POIFunction.CofaceExcelFileRead(ServerfileName, 'export.sheetName0', InsNo);
                File.copy(Filename, ArchivPath + CFFile.Name);
                File.Erase(Filename)
            UNTIL CFFile.NEXT() = 0;
        // if File.Upload('Datei suchen', 'C:\coface', '', '', ClientFilename) then
        //     //POIFunction.CofaceExcelFileRead('\\port-data-01\lwp\Benutzer\freitag\CG279291_20191205_NAV1_1575509957512.xlsx', 'export.sheetName0')
        //     POIFunction.CofaceExcelFileRead(ClientFilename, 'export.sheetName0');
    end;

    procedure CheckCreditLimit(InsuranceNo: Code[20])
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                Vend.ChangeCompany(POICompany.Mandant);
                Vend.Reset();
                Vend.SetRange("POI No Insurance", false);
                Vend.SetRange("POI Credit Insurance No.", InsuranceNo);
                if Vend.FindSet() then
                    repeat
                        CreditBuffer.Reset();
                        CreditBuffer.SetRange("Easy No.", Vend."POI Easy No.");
                        CreditBuffer.setfilter(Product, '%1|%2|%3', 'KREDITLIMIT', 'EXPRESS-PAUSCHALDECKUNG', '@RATING LIMIT');
                        CreditBuffer.SetRange(Status, 'GÜLTIG');
                        CreditBuffer.SetFilter("valid from", '<=%1', Today());
                        CreditBuffer.SetFilter("valid to", '>=%1|%2', Today(), 0D);
                        CreditBuffer.SetRange("Company Name", POICompany.Mandant);
                        if CreditBuffer.FindLast() then begin
                            if Vend."POI Insurance credit limit" <> CreditBuffer.Amount then begin
                                Vend.Validate("POI Insurance credit limit", CreditBuffer.Amount);
                                Vend."POI Ins. Cred. lim. val. until" := CreditBuffer."valid to";
                            end
                        end else begin
                            Vend.Validate("POI Insurance credit limit", 0);
                            Vend."POI Ins. Cred. lim. val. until" := 0D;
                        end;
                        if Vend."POI Ins. No. Extra" = InsuranceNo then begin
                            CreditBuffer.SetRange(Product, 'TOPLINER LIMIT');
                            if CreditBuffer.FindLast() then begin
                                if Vend."POI Extra Limit" <> CreditBuffer.Amount then begin
                                    Vend.Validate("POI Extra Limit", CreditBuffer.Amount);
                                    Vend."POI Extra Limit valid to" := CreditBuffer."valid to";
                                end;
                            end else begin
                                Vend.Validate("POI Extra Limit", 0);
                                Vend."POI Extra Limit valid to" := 0D;
                            end;
                        end;
                        Vend.Modify()
                    until Vend.Next() = 0;
            until POICompany.Next() = 0;
    end;

    procedure CheckAllCreditData()
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                Vend.ChangeCompany(POICompany.Mandant);
                Vend.Reset();
                if Vend.FindSet() then
                    repeat
                        if Vend."POI Ins. Cred. lim. val. until" < Today() then begin
                            Vend."POI Ins. Cred. lim. val. until" := 0D;
                            Vend.Validate("POI Insurance credit limit", 0);
                        end;
                        if Vend."POI Extra Limit valid to" < Today() then begin
                            Vend."POI Extra Limit valid to" := 0D;
                            Vend.Validate("POI Extra Limit", 0);
                        end;
                        if Vend."POI Cred. limit int. val.until" < Today() then begin
                            Vend."POI Ins. Cred. lim. val. until" := 0D;
                            Vend."POI Internal credit limit" := 0;
                        end;
                        Vend.Modify()
                    until Vend.Next() = 0;
            until POICompany.Next() = 0;
    end;



    var
        POICompany: Record "POI Company";
        Cust: Record Customer;
        Vend: Record Vendor;
        QualityMgt: Record "POI Quality Management";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        SalesSetup: Record "Sales & Receivables Setup";
        MailSetup: Record "POI Mail Setup";
        CFFile: Record File;
        CreditBuffer: Record "POI Ins. Cred. lim. Buffer";
        POIFunction: Codeunit POIFunction;
}