codeunit 5110798 "POI Port_System"
{
    // trigger OnRun()
    // var
    //     Choicetext: Text[250];
    //     OptioNo: Integer;
    //     "****testvariablen": Integer;
    //     Vari1: Text[250];
    //     Vari2: Text[250];
    // begin
    //     Choicetext:= (      'Test Frei'
    //                   +','+ 'XML-Dataport'
    //                   +','+ 'Excel-Import'
    //                   +','+ 'Export von Excel'
    //                   +','+ 'Alle TabelDate in Rolle'
    //                   );
    //     OptioNo:=STRMENU(Choicetext,1);
    //     CASE OptioNo OF
    //       1: BEGIN
    //          Vari1:='-Peng Hallo1 - Hallo2';
    //          FktSeparateValue(Vari1,Vari2,'Last+');  //Separator: Position+Separatorzeichen ->z.B.  'First-' oder 'Last '
    //          MESSAGE('Vari1:"%1",Vari2:"%2"',Vari1,Vari2);
    //       END;
    //       2:BEGIN
    //         xmlDataport();
    //       END;
    //       3:BEGIN
    //         ExcelImport();
    //       END;
    //       4:BEGIN
    //         ExcelExportBeispiel
    //       END;
    //       5:BEGIN
    //         Permit_TableData();
    //       END;
    //     END;
    // end;

    var

        ExcelBuffer: Record "Excel Buffer" temporary;
        // DDialog: Dialog;
        i: Integer;
        u: Integer;
    // FDatei: File;
    // RowNo: Integer;
    // "grc_fromFrmSales Invoice Line": Record "Sales Invoice Line" temporary;

    procedure Userlogin()
    var
        "lrc_User Setup": Record "User Setup";
        "lrc_Salesperson/Purchaser": Record "Salesperson/Purchaser";
        Sondertext1: Text[50];

        Grusstext: Text[30];
        Benutzername: Text[50];
    begin
        //Fkt wird von Codeunit 1 LoginStart aufgerufen.
        Benutzername := copystr(USERID(), 1, 50);
        IF "lrc_User Setup".GET(UPPERCASE(USERID())) THEN BEGIN
            IF "lrc_User Setup"."POI Salesperson Code" <> '' THEN
                IF "lrc_Salesperson/Purchaser".GET("lrc_User Setup"."POI Salesperson Code") THEN
                    Benutzername := "lrc_Salesperson/Purchaser".Name;
            IF (Time() > 000000T) AND (Time() < 120000T) THEN Grusstext := 'Guten Morgen';
            IF (Time() >= 120000T) AND (Time() < 180000T) THEN Grusstext := 'Guten Tag';
            IF (Time() >= 180000T) AND (Time() < 235900T) THEN Grusstext := 'Guten Abend';
            //Sondertexte und Ausgaben
            CASE COMPANYNAME() OF
                'PI Bananas GmbH':
                    BEGIN
                        Sondertext1 := '';
                        IF (USERID() = 'steffen') OR (USERID() = 'landahl') THEN BEGIN
                            Sondertext1 := ''; //'Hier steht bald der Hinweis auf Reklamationen';
                            MESSAGE('%1 %2 \%3', Grusstext, Benutzername, Sondertext1);
                        END;
                    END;
            END;
        END;
    end;

    procedure FktSeparateValue(var vtx_Vari1: Text[250]; var vtx_Vari2: Text[250]; vtx_Separator: Text[30])
    var
        SeparatorChar: Text[1];
        PosBeginAlpha: Integer;
        PosEndAlpha: Integer;
        VariNummerisch: Integer;
    begin
        //First mit Zeichen oder nur First ??
        IF STRPOS(vtx_Separator, 'First') > 0 THEN BEGIN   //First oder z.B. First-
            IF STRLEN(vtx_Separator) = 5 THEN BEGIN
                SeparatorChar := ' ';
                vtx_Separator := 'First';
            END ELSE BEGIN
                SeparatorChar := FORMAT(vtx_Separator[STRLEN(vtx_Separator)]);
                vtx_Separator := copystr(COPYSTR(vtx_Separator, 1, STRLEN(vtx_Separator) - 1), 1, 30);
            END;
            IF STRPOS(vtx_Vari1, SeparatorChar) = 0 THEN EXIT;
        END;
        IF STRPOS(vtx_Separator, 'Last') > 0 THEN BEGIN  //Last oder z.B. Last,
            IF STRLEN(vtx_Separator) = 4 THEN BEGIN
                SeparatorChar := ' ';
                vtx_Separator := 'Last';
            END ELSE BEGIN
                SeparatorChar := FORMAT(vtx_Separator[STRLEN(vtx_Separator)]);
                vtx_Separator := copystr(COPYSTR(vtx_Separator, 1, STRLEN(vtx_Separator) - 1), 1, 30);
            END;
            IF STRPOS(vtx_Vari1, SeparatorChar) = 0 THEN EXIT;
        END;

        vtx_Vari2 := vtx_Vari1;
        CASE vtx_Separator OF
            'First':
                BEGIN //nach erstem Leerzeichen fängt Variable 2 an
                    vtx_Vari2 := copystr(COPYSTR(vtx_Vari1, STRPOS(vtx_Vari1, SeparatorChar) + 1, STRLEN(vtx_Vari1) - STRPOS(vtx_Vari1, SeparatorChar)), 1, 250);
                    vtx_Vari1 := copystr(COPYSTR(vtx_Vari1, 1, STRLEN(vtx_Vari1) - STRLEN(vtx_Vari2) - 1), 1, 250); //-1 erster Separator raus
                END;
            'Last':
                BEGIN  //nach letztem Leerzeichen fängt Variable 2 an
                    WHILE STRPOS(vtx_Vari2, SeparatorChar) > 0 DO
                        vtx_Vari2 := copystr(COPYSTR(vtx_Vari2, STRPOS(vtx_Vari2, SeparatorChar) + 1, STRLEN(vtx_Vari2) - STRPOS(vtx_Vari2, SeparatorChar)), 1, 250);
                    vtx_Vari1 := copystr(COPYSTR(vtx_Vari1, 1, (STRLEN(vtx_Vari1) - 1) - STRLEN(vtx_Vari2)), 1, 250) //STRLEN(Vari)-1 letzer Separator muss auch raus
                END;
            'Alpha':
                BEGIN
                    vtx_Vari2 := DELCHR(vtx_Vari2, '<>', ' '); //Leereichen vorne/hinten abschneiden
                    PosBeginAlpha := 0;
                    PosEndAlpha := 0;
                    FOR i := 1 TO STRLEN(vtx_Vari2) DO
                        IF NOT EVALUATE(VariNummerisch, FORMAT(vtx_Vari2[i])) THEN BEGIN
                            IF PosBeginAlpha = 0 THEN PosBeginAlpha := i;
                            IF PosBeginAlpha > 1
                             THEN
                                PosEndAlpha := STRLEN(vtx_Vari2) //alpha nicht bei 1 dann ist die letzte Pos auch
                            ELSE
                                PosEndAlpha := i;
                        END;
                    vtx_Vari1 := copystr(COPYSTR(vtx_Vari2, PosBeginAlpha, PosEndAlpha), 1, 250);
                    IF PosBeginAlpha = 1
                      THEN
                        vtx_Vari2 := copystr(COPYSTR(vtx_Vari2, PosEndAlpha + 1, STRLEN(vtx_Vari2) - PosEndAlpha), 1, 250)
                    ELSE
                        vtx_Vari2 := copystr(COPYSTR(vtx_Vari2, 1, PosBeginAlpha - 1), 1, 250);
                END;
            //--noch nicht definiert
            ELSE
                vtx_Vari2 := '';
        END;
        vtx_Vari1 := DELCHR(vtx_Vari1, '<>', ' ');
        vtx_Vari2 := DELCHR(vtx_Vari2, '<>', ' ');
        EXIT;
    end;

    procedure FktChangeVariTyp(TypNo: Text[30]; var CellValueAsText: Text[30]; var WertAsVariant: Variant)
    var
        Date: Date;
        "Integer": Integer;
        Decimal: Decimal;
        Text: Text[1000];
        "Code": Code[1000];
        Boolean: Boolean;
    begin
        //TableFilter,RecordID,Text,Date,Time,Dateformula,Decimal,Binary,BLOB, Boolean,Integer,Code,Option,BigInteger,Duration,GUID,DateTime
        CASE TypNo OF
            'Date':
                BEGIN    //Date 11775
                    EVALUATE(Date, CellValueAsText);
                    WertAsVariant := Date;
                END;
            'Integer':
                BEGIN //Integer 34559
                    EVALUATE(Integer, CellValueAsText);
                    WertAsVariant := Integer;
                END;
            'Decimal':
                BEGIN //Decimal 12799
                    EVALUATE(Decimal, CellValueAsText);
                    WertAsVariant := Decimal;
                END;
            'Text':
                BEGIN //Text 11519
                    EVALUATE(Text, CellValueAsText);
                    WertAsVariant := Text;
                END;
            'Code':
                BEGIN //Code 35071
                    EVALUATE(Code, CellValueAsText);
                    WertAsVariant := Code;
                END;
            'Boolean':
                BEGIN //Booelean  34047
                    EVALUATE(Boolean, CellValueAsText);
                    WertAsVariant := Boolean;
                END;
        END;
    end;

    procedure FktChangeVorbiddenSearchSigns(TextCellValue: Text[300]) SearchCellValue: Text[300]
    var
        t: Integer;
    begin
        FOR t := 1 TO STRLEN(TextCellValue) DO//tausche verbotene Suchzeichen gegen ?
            CASE TextCellValue[t] OF
                '(':
                    SearchCellValue := copystr(SearchCellValue + '?', 1, MaxStrLen(SearchCellValue));
                ')':
                    SearchCellValue := copystr(SearchCellValue + '?', 1, MaxStrLen(SearchCellValue));
                '|':
                    SearchCellValue := copystr(SearchCellValue + '?', 1, MaxStrLen(SearchCellValue));
                ELSE
                    SearchCellValue := copystr(SearchCellValue + FORMAT(TextCellValue[t]), 1, MaxStrLen(SearchCellValue))
            END;
    end;

    procedure FktGetDateFilterPeriode(StartDatum: Date; PlusMonat: Integer; PlusJahr: Integer; var DateMonatBegin: Date; var DateMonatEnde: Date; var MonatsKurzanzeige: Text[30])
    var
        ExprBegin: Text[30];
        ExprMonat: Text[30];
        ExprJahr: Text[30];
    begin
        //Info/Bemerkung Datumseingaben
        //  j (für das Geschäftsjahr) ergibt 01.01.08..31.12.08
        //  j-1 (letztes Geschäftsjahr) ergibt 01.01.07..31.12.07
        //  j+2 (übernächstes Geschäftsjahr) ergibt 01.01.10..31.12.010
        //  p5 (für die Geschäftsperiode 5) ergibt 01.05.08..31.05.08
        //  p7..p8 ergibt 01.07.08..31.08.08
        //  p2.. ergibt 01.02.08..
        //  ..p2 ergibt ..01.02.08
        //  fr20 (für Freitag, 20. KW) wird zu 16.05.08

        //Datumsfunktionen
        //DatumVon := 010113D;
        //'<CQ+1M-10D>';   // Current quarter + 1 month - 10 days
        //<+1Y-1D>';      //Letzter Tag nach einem Jahr
        //'<-WD2>';    // The last weekday no.2, (last Tuesday)
        //'<CM>';      // Letzer Tag im Monat  von DatumVon
        //'<CM-1M+1D>';// Erster Tag im Monat von DatumVon
        //1. Periode

        DateMonatBegin := CALCDATE('<CM-1M+1D>', StartDatum); // Letzer Tag im Monat  von DatumVon
        DateMonatEnde := CALCDATE('<CM>', StartDatum);        // Letzer Tag im Monat  von DatumVon

        IF PlusMonat <> 0 THEN BEGIN
            IF PlusMonat > 0 THEN
                ExprBegin := '<+' + FORMAT(PlusMonat) + 'M>'
            ELSE BEGIN
                PlusMonat := PlusMonat * -1;
                ExprBegin := '<-' + FORMAT(PlusMonat) + 'M>';
            END;
            DateMonatBegin := CALCDATE(ExprBegin, DateMonatBegin); //ite Periode/Monat nach Startdatum 1.Monatstag
            DateMonatEnde := CALCDATE(ExprBegin, DateMonatEnde);   //ite  Periode/Monat nach Startdatum letzte.Monatstag
        END;

        IF PlusJahr <> 0 THEN BEGIN
            IF PlusJahr > 0 THEN
                ExprBegin := '<+' + FORMAT(PlusJahr) + 'Y>'
            ELSE BEGIN
                PlusJahr := PlusJahr * -1;
                ExprBegin := '<-' + FORMAT(PlusJahr) + 'Y>';
            END;
            DateMonatBegin := CALCDATE(ExprBegin, DateMonatBegin); //ite PeriodeVorjahr nach Startdatum 1.Monatstag
            DateMonatEnde := CALCDATE(ExprBegin, DateMonatEnde);   //ite  PeriodeVorjahr nach Startdatum letzte.Monatstag
        END;

        ExprMonat := FORMAT(DATE2DMY(DateMonatBegin, 2)); //Number := DATE2DMY(Date, What) Waht 1 = Day (1-31), 2 Month, 3 Year
        IF STRLEN(ExprMonat) = 1 THEN ExprMonat := copystr('0' + ExprMonat, 1, 30);
        ExprJahr := FORMAT(DATE2DMY(DateMonatBegin, 3));
        ExprJahr := COPYSTR(ExprJahr, STRLEN(ExprJahr) - 1, 2);
        MonatsKurzanzeige := copystr(ExprMonat + '/' + ExprJahr, 1, 30)
    end;

    procedure Permit_Groups(ChoiceFkt: Code[50]) ok: Boolean
    var
        AccessControl: Record "Access Control";
        txt_RoleName: Text[30];
        txt_RoleID: Text[30];
        ErrorTxt: label 'Nur Benutzer der Gruppe "%1" %2', Comment = '%1 %2';
    begin

        ok := true;
        CASE ChoiceFkt OF
            'DARFKREDBANKDATEN':
                txt_RoleID := '_DARFBANKDATEN';
            'DARFVKRGCOPYLEER':
                txt_RoleID := '_DARFVKRGKOPIEWEG';
            'DARFVKRGEDIT':
                txt_RoleID := '_DARFVKRGEDIT';
            'DARFVKBUCHOHNEVAT':
                txt_RoleID := '_DARFVKRGOHNEVAT';
            'DARFKREDITLIMITMASSNAHME':
                txt_RoleID := '_DARFKREDITLIMITMASS';
            'DARFKREDITLIMIT':
                txt_RoleID := '_DARFKREDITLIMITMASS';
            ELSE
                txt_RoleID := '';
        end;
        IF txt_RoleID = '' THEN EXIT;
        AccessControl.SETFILTER("Role ID", txt_RoleID);
        AccessControl.SETFILTER("Company Name", '%1|%2', CompanyName(), '');
        AccessControl.SETFILTER("User Name", '%1', '@*\' + UserId());
        IF NOT AccessControl.IsEmpty() THEN BEGIN
            PermissionSet.SETFILTER("Role ID", txt_RoleID);
            IF PermissionSet.FINDFIRST() THEN txt_RoleName := PermissionSet.Name;
            //Sondertexte
            IF txt_RoleID = '_DARFKREDITLIMITMASS' THEN BEGIN
                txt_RoleID := 'Fibu';
                txt_RoleName := 'Fibu';
            END;
            ok := FALSE;
            ERROR(ErrorTxt, txt_RoleID, txt_RoleName);
        END;
    END;

    // procedure Permit_Groups_NoError(ChoiceFkt: Code[50]): Boolean
    // var
    //     ok: Boolean;
    //     "**Port Benutzergruppen Edit": Integer;
    //     "User Role": Record "2000000004";
    //     "Member Of": Record "2000000003";
    //     "Windows Access Control": Record "2000000053";
    //     "txt_Role Name": Text[30];
    //     "txt_Role ID": Text[30];
    // begin

    //     "txt_Role ID":='';
    //     ok:=TRUE;
    //     CASE ChoiceFkt OF
    //       //BUI~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //       'DARFBUIAUSWERTUNG'  : BEGIN             //Frm BUI 5087939 -> Button Ausgabe ausblenden
    //         "txt_Role ID":='_DarfBUI-Auswertung'; //im Menü Extra-Zugriffsrechte-Rollen
    //       END;
    //     END;
    //     IF "txt_Role ID" = '' THEN EXIT(FALSE);

    //     "Windows Access Control".SETFILTER("Role ID","txt_Role ID");
    //     "Windows Access Control".SETFILTER("Company Name",'%1|%2',COMPANYNAME,'');
    //     "Windows Access Control".SETFILTER("Login ID",'%1','@*\'+USERID);
    //     IF NOT "Windows Access Control".FIND('-') THEN BEGIN
    //       "Member Of".SETFILTER("Role ID","txt_Role ID");
    //       "Member Of".SETFILTER("User ID",USERID);
    //       "Member Of".SETFILTER(Company,'%1|%2',COMPANYNAME,'');
    //       IF NOT "Member Of".FIND('-') THEN BEGIN
    //         ok:=FALSE
    //       END;
    //     END;
    //     ok:=ok;
    //     EXIT(ok);
    // end;

    // procedure Permit_TableData()
    // var
    //     "Object": Record Object;
    //     Permission: Record Permission;
    //     Permission2: Record Permission;
    //     "User Role": Record "2000000004";
    //     RoleID: Code[20];
    //     ObjectType: Option "Table Data","Table",Form,"Report",Dataport,"Codeunit","XMLport",MenuSuite,"Page",,System;
    //     FFile: File;
    //     FileName: Text[250];
    //     OutputStr: Text[400];
    // begin
    //     //erzeugt für alle Tabledatte eine Zuordung zur Rolle
    //     //-> damit läßt sich das Rechte-System anwerfen

    //     Object.SETRANGE(Type,Object.Type::TableData);
    //     i:=0;
    //     RoleID:='ALLE-TABLEDATA';
    //     ObjectType:=ObjectType::"Table Data";
    //     //Table Data,Table,Form,Report,Dataport,Codeunit,XMLport,MenuSuite,Page,,System

    //     IF NOT CONFIRM( 'Es wird die Rolle %1 Typ %2 erstellt.\'
    //                    +'Dabei ist der Mandant egal,es werden alle Objekte des Typs gesammelt und erstellt\'
    //                    +'(Objekte sind Mandantenbezogen und können mehrfach zugteilt sein'
    //                    +'fortfahren ?',TRUE,RoleID,FORMAT(ObjectType)) THEN ERROR('Abbruch');
    //     FileName:= 'c:\Temp\'+ ENVIRON('USERNAME')+'-CO5110798.csv';
    //     IF EXISTS(FileName) THEN ERASE(FileName);
    //     IF NOT FFile.CREATE(FileName) THEN //Hat das geklappt
    //       ERROR('Datei %1 konnte nicht erstellt werden',FileName);
    //     IF NOT FFile.WRITEMODE(TRUE) THEN           //sind Schreibrechte da ??
    //       ERROR ('In Datei %1 kann nicht auf Write-Mode geschaltet werden',FileName);
    //     IF NOT FFile.TEXTMODE(TRUE) THEN                //True ist ASCII False ist Binary
    //       ERROR ('Datei %1 kann nicht in ASCII-Mode geschaltet werden',FileName);

    //     "User Role".SETRANGE("Role ID",RoleID);
    //     IF "User Role".FINDFIRST THEN ERROR('RoleID %1 schon vorhanden',RoleID);
    //     "User Role".INIT;
    //     "User Role".RESET;
    //     "User Role".VALIDATE("Role ID",RoleID);
    //     "User Role".INSERT(TRUE);

    //     u:=0;
    //     IF Object.FIND('-') THEN BEGIN
    //       DDialog.OPEN('Objekt #1#### von #2####\'
    //                    +'Skip  #3#### von #2####' );
    //       DDialog.UPDATE(2,Object.COUNT);
    //       REPEAT
    //         i+=1;
    //         DDialog.UPDATE(1,i);

    //         Permission2.RESET;
    //         Permission2.SETRANGE("Role ID",RoleID);
    //         Permission2.SETRANGE("Object Type",ObjectType);
    //         Permission2.SETRANGE("Object ID",Object.ID);
    //         IF NOT Permission2.FINDFIRST THEN BEGIN
    //           Permission.INIT;
    //           Permission."Role ID":=RoleID;
    //           Permission."Object Type":=ObjectType;
    //           Permission.VALIDATE("Object ID",Object.ID);
    //           Permission."Read Permission":=Permission."Read Permission"::Yes;
    //           Permission."Insert Permission":=Permission."Insert Permission"::Yes;
    //           Permission."Modify Permission":=Permission."Modify Permission"::Yes;
    //           Permission."Delete Permission":=Permission."Delete Permission"::Yes;
    //           Permission.INSERT(TRUE);
    //           OutputStr:=FORMAT(Object.Type) +';'+ FORMAT(Object.ID) +';'+ 'neu erstellt';
    //           FFile.WRITE(OutputStr);
    //         END ELSE BEGIN
    //           u+=1;
    //           DDialog.UPDATE(3,u);
    //           OutputStr:=FORMAT(Object.Type) +';'+ FORMAT(Object.ID) +';'+ 'schon vorhanden';
    //           FFile.WRITE(OutputStr);
    //         END;
    //       UNTIL Object.NEXT =0;
    //       DDialog.CLOSE;
    //     END;

    //     FFile.CLOSE;
    //     IF CONFIRM ( '%1 Rolle angelegt          \'
    //                 +'%2 Objektrechte vergeben   \'
    //                 +'%3 Objekte schon vorhanden \'
    //                 +'soll Datei % geöffnet werden ?',TRUE,RoleID,i,u,FileName) THEN BEGIN
    //       HYPERLINK(FileName)
    //       //SHELL('C:\Program Files\Microsoft Office\Office14\Excel.exe',FileName);
    //     END;
    // end;

    procedure xmlDataport()
    var
        oStream: OutStream;
        oFile: File;
    begin
        "Sales Header".SETFILTER("No.", 'F-36717');
        IF "Sales Header".FINDFIRST() THEN BEGIN

            oFile.CREATE('C:\edocprinter\steffen\test.xml');
            oFile.CREATEOUTSTREAM(oStream);
            XMLPORT.EXPORT(50019, oStream, "Sales Header");
            oFile.CLOSE();

            MESSAGE('Export xml mit 50019 fertig');
        END ELSE
            MESSAGE('Sales Header not found');
        EXIT;
    end;

    // procedure ExcelExportBeispiel()
    // var
    //     Summe: Label '=Summe(C2:C%1)';
    //     Customer: Record Customer;
    //     FileName: Text[250];
    // begin
    //     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~EXCEL EXPORT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //     //1.Part Excel-Export

    //     //Beispiel Customer
    //     FileName:= 'C:\edocprinter\steffen\test-export.xls';

    //     Customer.FINDFIRST;
    //     ExcelBuffer.DELETEALL;
    //     EnterCell(ExcelBuffer,1, 1, Customer.FIELDCAPTION("No."),         '', TRUE, FALSE, FALSE);
    //     EnterCell(ExcelBuffer,1, 2, Customer.FIELDCAPTION(Name),          '', TRUE, FALSE, FALSE);
    //     EnterCell(ExcelBuffer,1, 3, Customer.FIELDCAPTION("Sales (LCY)"), '', TRUE, FALSE, FALSE);
    //     RowNo := 1;

    //     DDialog.OPEN('Rec #1#### von #2####');
    //     DDialog.UPDATE(2,Customer.COUNT);
    //     i:=1;

    //     REPEAT
    //       i+=1;
    //       DDialog.UPDATE(1,i);
    //       Customer.CALCFIELDS("Sales (LCY)");
    //       RowNo += 1;
    //       EnterCell(ExcelBuffer,RowNo, 1, FORMAT(Customer."No."),         '', FALSE, FALSE, FALSE);
    //       EnterCell(ExcelBuffer,RowNo, 2, FORMAT(Customer.Name),          '', FALSE, FALSE, FALSE);
    //       EnterCell(ExcelBuffer,RowNo, 3, FORMAT(Customer."Sales (LCY)"), '', FALSE, FALSE, FALSE);
    //     UNTIL Customer.NEXT =0;
    //     DDialog.CLOSE;

    //     RowNo += 1;
    //     EnterCell(ExcelBuffer,RowNo, 2, 'Total', '', TRUE, FALSE, FALSE);
    //     EnterCell(ExcelBuffer,RowNo, 3, '', STRSUBSTNO(Summe, RowNo-1), TRUE, FALSE, FALSE);

    //     //Abschluss
    //     //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //     ExcelBuffer.CreateBook;
    //     ExcelBuffer.CreateSheet(Customer.TABLECAPTION, Customer.TABLECAPTION, COMPANYNAME, USERID);
    //                             //Sheetname            //reportheader
    //     IF EXISTS(FileName) THEN ERASE(FileName);
    //     ExcelBuffer.SaveBook(FileName);   //Neue Fkt in ExcelBuffer Inhalt : XlWrkBk.SaveAs(FileName);
    //     ExcelBuffer.GiveUserControl();
    //     //Ende 1.Part Excel-Export
    // end;

    procedure ExcelWriteHeader(var vrc_ExcelBuffer: Record "Excel Buffer"; Caption: array[100] of Text[250]; lin_Row: Integer)
    begin
        ExcelBuffer.DELETEALL();
        i := COMPRESSARRAY(Caption);
        FOR u := 1 TO i DO
            EnterCell(vrc_ExcelBuffer, lin_Row, u, Caption[u], '', TRUE, FALSE, FALSE);
    end;

    procedure ExcelWriteLine(var vrc_ExcelBuffer: Record "Excel Buffer"; FieldValue: array[100] of Text[250]; lin_Row: Integer)
    begin
        ExcelBuffer.DELETEALL();
        i := COMPRESSARRAY(FieldValue);
        FOR u := 1 TO i DO
            EnterCell(vrc_ExcelBuffer, lin_Row, u, FieldValue[u], '', TRUE, FALSE, FALSE);
    end;

    procedure ExcelOpen()
    begin
    end;

    procedure EnterCell(var vrc_ExcelBuffer: Record "Excel Buffer"; RowNo: Integer; ColumnNo: Integer; CellValue: Text[250]; CellFormula: Text[250]; Bold: Boolean; Italic: Boolean; Underline: Boolean)
    begin
        //2.Part Excel-Export
        //vrc_ExcelBuffer(RowNo,ColumnNo,CellValue,CellFormula,Bold,Italic,Underline)
        vrc_ExcelBuffer.INIT();
        vrc_ExcelBuffer.VALIDATE("Row No.", RowNo);
        vrc_ExcelBuffer.VALIDATE("Column No.", ColumnNo);
        vrc_ExcelBuffer."Cell Value as Text" := CellValue;
        vrc_ExcelBuffer.Formula := CellFormula;
        vrc_ExcelBuffer.Bold := Bold;
        vrc_ExcelBuffer.Italic := Italic;
        vrc_ExcelBuffer.Underline := Underline;
        vrc_ExcelBuffer.INSERT();
        //Ende 2.Part Excel-Export
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~EXCEL EXPORT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    end;

    // procedure ExcelImport()
    // var
    //     ExcelBuffer: Record "Excel Buffer";
    //     CountRows: Integer;
    //     Idx: Integer;
    //     "frmExcel Buffer": Form "50052";
    // begin
    //     //###################################EXCEL Import#####################################
    //     //______________________________
    //     //1. Import
    //     ExcelBuffer.OpenBook('c:\edocprinter\steffen\Test.xls', 'Tabelle1');
    //     ExcelBuffer.ReadSheet;
    //     COMMIT;

    //     //______________________________
    //     //2-Kontrollanzeige
    //     //Aufbau Puffer
    //     //Zeilenr Spaltennr XLZeileID   XLSpalteID  Zellenwert als Text
    //     //1       1         1           A           Nr.
    //     //1       2         1           B           Name
    //     //1       3         1           C           Saldo (MW)
    //     //2       1         2           A           D0002
    //     //2       2         2           B           A.Reimers
    //     //2       3         2           C           20.000
    //     CLEAR("frmExcel Buffer");
    //     "frmExcel Buffer".SETRECORD(ExcelBuffer);
    //     "frmExcel Buffer".SETTABLEVIEW(ExcelBuffer);
    //     "frmExcel Buffer".LOOKUPMODE(TRUE);
    //     IF "frmExcel Buffer".RUNMODAL = ACTION::LookupOK THEN BEGIN
    //     END;

    //     //____________________________
    //     //3.Transfer in NavisonTabelle

    //     IF ExcelBuffer.FIND('+') THEN
    //       CountRows:=ExcelBuffer."Row No.";
    //     FOR Idx:=1 TO CountRows DO BEGIN
    //       //TargetTable.INIT;
    //       //IF ExcelBuffer.GET(Idx, 1) THEN
    //         //TargetTable."Nr.":=ExcelBuffer."Cell Value as Text";
    //       //IF ExcelBuffer.GET(Idx, 2) THEN
    //         //TargetTable."NAme":=ExcelBuffer."Cell Value as Text";
    //       //IF ExcelBuffer.GET(Idx, 3) THEN
    //         //TargetTable."Saldo (MW)":=ExcelBuffer."Cell Value as Text";
    //       //TargetTable.INSERT;
    //     END;
    //     //###################################EXCEL Import#####################################
    // end;

    // procedure SetMarkedRecordsFromForm(var "vrc_Sales Invoice Line": Record "113";CountMarked: Integer)
    // begin
    //     CLEAR("grc_fromFrmSales Invoice Line");
    //     //"vrc_Sales Invoice Line".COPY("Sales Invoice Line");
    //     //CountMarked:="Sales Invoice Line".COUNT;
    //     //temp-Record
    //     "grc_fromFrmSales Invoice Line".COPY("vrc_Sales Invoice Line");
    // end;

    // procedure TranslateKreditWerte(KreditorNo: Code[20];"Document Type": Option Purchase,Sales;Wert: Text[250];Caption: Code[200];Arr_LineWert: array [6] of Text[250];Arr_LineCaption: array [6] of Code[200];var CompanyValue: Text[250])
    // var
    //     BufferGehoertzu: Record "332" temporary;
    //     GefundeneZeilennummer: Integer;
    //     WertKreditorZeile: Code[200];
    //     lrc_ImpAvisTranslation: Record "50008";
    //     lrc_TranslationBedingung: Record "50008";
    // begin
    //     //habe den Wert und die Caption
    //     CompanyValue:=Wert;
    //     lrc_ImpAvisTranslation.SETRANGE("Vendor No.",KreditorNo);
    //     lrc_ImpAvisTranslation.SETRANGE("Document Type","Document Type");
    //     lrc_ImpAvisTranslation.SETRANGE(Satzart,lrc_ImpAvisTranslation.Satzart::Content);
    //     lrc_ImpAvisTranslation.SETRANGE("Vendor Value",Wert);   //18
    //     lrc_ImpAvisTranslation.SETRANGE("Vendor Line",Caption); //SIZE

    //     IF NOT lrc_ImpAvisTranslation.FINDFIRST THEN EXIT;

    //     IF lrc_ImpAvisTranslation.COUNT = 1 THEN BEGIN
    //       IF lrc_ImpAvisTranslation."Company Value" <> ''
    //         THEN CompanyValue:=lrc_ImpAvisTranslation."Company Value"
    //         ELSE CompanyValue:=Wert;
    //       EXIT;
    //     END;

    //     //mehrere Bedingungen :
    //     lrc_TranslationBedingung.SETCURRENTKEY("Vendor No.","Document Type",Satzart,"Vendor Line");
    //     lrc_TranslationBedingung.SETRANGE("Vendor No.",KreditorNo);
    //     lrc_TranslationBedingung.SETRANGE("Document Type","Document Type");
    //     lrc_TranslationBedingung.SETRANGE(Satzart,lrc_ImpAvisTranslation.Satzart::Content);
    //     //lrc_TranslationBedingung.SetRange("Vendor Value",Wert);   //23
    //     //lrc_TranslationBedingung.SetRAnge("Vendor Line",Caption); //SIZE
    //     lrc_TranslationBedingung.SETRANGE("Value Variant",Wert); //23
    //     lrc_TranslationBedingung.SETFILTER("Vendor Value",'<>%1',Wert);   //23  gibt z.B. Packstyle
    //     ///hier sind nun alle Zusatzbedingungen gleiche stehen untereinander
    //     IF NOT lrc_TranslationBedingung.FINDFIRST THEN BEGIN
    //       IF lrc_TranslationBedingung."Company Value" <> '' //sollte aber gehen, hier nur zur Sicherheit
    //         THEN CompanyValue:=lrc_ImpAvisTranslation."Company Value"
    //         ELSE CompanyValue:=Wert;
    //       EXIT;
    //     END;

    //     REPEAT
    //       BufferGehoertzu.UpdateTotal(FORMAT(lrc_TranslationBedingung."Part LineNo."),0,0,i);
    //     UNTIL lrc_TranslationBedingung.NEXT =0;

    //     lrc_TranslationBedingung.FINDFIRST; //Und nun alle Bedingungen durchgehen
    //     REPEAT
    //       //Wert Holen
    //       FOR i := 1 TO ARRAYLEN(Arr_LineCaption) DO BEGIN
    //         IF Arr_LineCaption[i] = lrc_TranslationBedingung."Vendor Line" THEN BEGIN
    //           u:=i;
    //           i:=ARRAYLEN(Arr_LineCaption);
    //         END;
    //       END;
    //       IF u = 0 THEN BEGIN //Keine Zuteilung ?
    //         EXIT;
    //       END;
    //       IF Arr_LineWert[u] <> lrc_TranslationBedingung."Vendor Value" THEN BEGIN
    //         BufferGehoertzu.SETFILTER("Currency Code",FORMAT(lrc_TranslationBedingung."Part LineNo."));
    //         IF BufferGehoertzu.FINDFIRST THEN BEGIN
    //            BufferGehoertzu.DELETE;
    //         END;
    //       END;
    //     UNTIL lrc_TranslationBedingung.NEXT =0;
    //     //Wieviel ist im Buffer noch übrig, das sind ja Bedingungen
    //     BufferGehoertzu.RESET;
    //     IF BufferGehoertzu.COUNT = 1 THEN BEGIN
    //       BufferGehoertzu.FINDFIRST;
    //       EVALUATE(GefundeneZeilennummer,BufferGehoertzu."Currency Code");
    //       lrc_TranslationBedingung.RESET;
    //       lrc_TranslationBedingung.SETRANGE("Line No.",GefundeneZeilennummer);
    //       lrc_TranslationBedingung.FINDFIRST;
    //       IF lrc_TranslationBedingung."Company Value" <> ''
    //         THEN CompanyValue:=lrc_TranslationBedingung."Company Value"
    //         ELSE CompanyValue:=Wert;
    //         EXIT;
    //     END ELSE BEGIN
    //       IF NOT CONFIRM('Achtung unklare Kombination (Zeilenummer "ok" ist öfters vorhanden') THEN;
    //       //mehr als eine Kombination richtig ?
    //     END;

    //     /*Beispiel
    //     Arr_LineWert[1]:=''
    //     Arr_LineWert[2]:='01270101'
    //     Arr_LineWert[3]:='THOMPSON'
    //     Arr_LineWert[4]:='CARDBOARD CARTON 4,50 KG'
    //     Arr_LineWert[5]:='23'
    //     Arr_LineWert[6]:='CLAMSHELL'

    //     Arr_LineCaptionNo[1]:=0;
    //     Arr_LineCaptionNo[2]:=9999003;
    //     Arr_LineCaptionNo[3]:=5110441;
    //     Arr_LineCaptionNo[4]:=5407;
    //     Arr_LineCaptionNo[5]:=9999001;
    //     Arr_LineCaptionNo[6]:=0;

    //     Arr_LineCaption[1]:='';
    //     Arr_LineCaption[2]:='PALLET NUMBER';
    //     Arr_LineCaption[3]:='VARIETY';
    //     Arr_LineCaption[4]:='PACK TYPE';
    //     Arr_LineCaption[5]:='SIZE';
    //     Arr_LineCaption[6]:='PACK STYLE';
    //     */

    // end;


    // procedure Lookuptable(Companyname2: Text[30];TableID: Integer;var Position: Text[1024]): Boolean
    // var
    //     PaymentTerms: Record "3";
    //     Currency: Record "4";
    //     FinanceChargeTerms: Record "5";
    //     CustPriceGr: Record "6";
    //     Language: Record "8";
    //     Country: Record "9";
    //     ShipmentMethod: Record "10";
    //     SalesPerson: Record "13";
    //     Location: Record "14";
    //     Cust: Record "18";
    //     Vend: Record "23";
    //     CustPostingGr: Record "92";
    //     PostCode: Record "225";
    //     GenJournalBatch: Record "232";
    //     GenBusPostingGr: Record "250";
    //     Territory: Record "286";
    //     PaymentMethod: Record "289";
    //     ShippingAgent: Record "291";
    //     ReminderTerms: Record "292";
    //     NoSeries: Record "308";
    //     TaxArea: Record "318";
    //     CustDiscGr: Record "340";
    //     Contact: Record "5050";
    //     RespCenter: Record "5714";
    //     ShippingAgentService: Record "5790";
    //     ServiceZone: Record "5957";
    //     BaseCal: Record "7600";
    //     VendPostingGr: Record "93";
    //     VATBusPostingGr: Record "323";
    //     DeliveryReminderTerm: Record "5005276";
    //     Item: Record "27";
    //     InvPostingGr: Record "94";
    //     Job: Record "167";
    //     UOM: Record "204";
    //     GenProdPostingGr: Record "251";
    //     TariffNumber: Record "260";
    //     TaxGroup: Record "321";
    //     VATProdPostingGr: Record "324";
    //     ItemDiscGr: Record "341";
    //     Manufacturer: Record "5720";
    //     Purchasing: Record "5721";
    //     ItemCategory: Record "5722";
    //     ProductGroup: Record "5723";
    //     ServiceItemGr: Record "5904";
    //     ItemTrackingCode: Record "6502";
    //     SpecialEquipment: Record "7305";
    //     PutAwayTemplateHeader: Record "7307";
    //     PhysInvtCountingPeriod: Record "7381";
    //     RoutingHeader: Record "99000763";
    //     ProdBOMHeader: Record "99000771";
    //     ProdForecastName: Record "99000851";
    //     GLAcc: Record "15";
    //     Empl: Record "5200";
    //     Res: Record "156";
    // begin
    //     // > TL5.00:06 >>>
    //     IF Companyname2 = '' THEN
    //       Companyname2 := COMPANYNAME;
    //     CASE TableID OF
    //       DATABASE::"Payment Terms":
    //         WITH PaymentTerms DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,PaymentTerms) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Currency:
    //         WITH Currency DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Currency) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Finance Charge Terms":
    //         WITH FinanceChargeTerms DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,FinanceChargeTerms) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Customer Price Group":
    //         WITH CustPriceGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,CustPriceGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Language:
    //         WITH Language DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Language) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Country/Region":
    //         WITH Country DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Country) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Shipment Method":
    //         WITH ShipmentMethod DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ShipmentMethod) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Salesperson/Purchaser":
    //         WITH SalesPerson DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,SalesPerson) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Location:
    //         WITH Location DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Location) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Customer:
    //         WITH Cust DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Cust) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Vendor:
    //         WITH Vend DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Vend) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Customer Posting Group":
    //         WITH CustPostingGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,CustPostingGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Post Code":
    //         WITH PostCode DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,PostCode) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Gen. Journal Batch":
    //         WITH GenJournalBatch DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,GenJournalBatch) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Gen. Business Posting Group":
    //         WITH GenBusPostingGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,GenBusPostingGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Territory:
    //         WITH Territory DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Territory) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Payment Method":
    //         WITH PaymentMethod DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,PaymentMethod) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Shipping Agent":
    //         WITH ShippingAgent DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ShippingAgent) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Reminder Terms":
    //         WITH ReminderTerms DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ReminderTerms) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"No. Series":
    //         WITH NoSeries DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,NoSeries) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Tax Area":
    //         WITH TaxArea DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,TaxArea) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Customer Discount Group":
    //         WITH CustDiscGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,CustDiscGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Contact:
    //         WITH Contact DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Contact) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Responsibility Center":
    //         WITH RespCenter DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,RespCenter) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Shipping Agent Services":
    //         WITH ShippingAgentService DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ShippingAgentService) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Service Zone":
    //         WITH ServiceZone DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ServiceZone) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Base Calendar":
    //         WITH BaseCal DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,BaseCal) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Vendor Posting Group":
    //         WITH VendPostingGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,VendPostingGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"VAT Business Posting Group":
    //         WITH VATBusPostingGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,VATBusPostingGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Delivery Reminder Term":
    //         WITH DeliveryReminderTerm DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,DeliveryReminderTerm) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Item:
    //         WITH Item DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Item) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Inventory Posting Group":
    //         WITH InvPostingGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,InvPostingGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Job:
    //         WITH Job DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Job) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Unit of Measure":
    //         WITH UOM DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,UOM) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Gen. Product Posting Group":
    //         WITH GenProdPostingGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,GenProdPostingGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Tariff Number":
    //         WITH TariffNumber DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,TariffNumber) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Tax Group":
    //         WITH TaxGroup DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,TaxGroup) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"VAT Product Posting Group":
    //         WITH VATProdPostingGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,VATProdPostingGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Item Discount Group":
    //         WITH ItemDiscGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ItemDiscGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Manufacturer:
    //         WITH Manufacturer DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Manufacturer) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Purchasing:
    //         WITH Purchasing DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Purchasing) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Item Category":
    //         WITH ItemCategory DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ItemCategory) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Product Group":
    //         WITH ProductGroup DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ProductGroup) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Service Item Group":
    //         WITH ServiceItemGr DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ServiceItemGr) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Item Tracking Code":
    //         WITH ItemTrackingCode DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ItemTrackingCode) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Special Equipment":
    //         WITH SpecialEquipment DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,SpecialEquipment) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Put-away Template Header":
    //         WITH PutAwayTemplateHeader DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,PutAwayTemplateHeader) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Phys. Invt. Counting Period":
    //         WITH PhysInvtCountingPeriod DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,PhysInvtCountingPeriod) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Routing Header":
    //         WITH RoutingHeader DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,RoutingHeader) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Production BOM Header":
    //         WITH ProdBOMHeader DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ProdBOMHeader) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"Production Forecast Name":
    //         WITH ProdForecastName DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,ProdForecastName) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::"G/L Account":
    //         WITH GLAcc DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,GLAcc) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //     // > TL5.00:08 >>>
    //       DATABASE::Resource:
    //         WITH Res DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Res) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //       DATABASE::Employee:
    //         WITH Empl DO BEGIN
    //           CHANGECOMPANY(Companyname2);
    //           SETPOSITION(Position);
    //           IF FORM.RUNMODAL(0,Empl) = ACTION::LookupOK THEN BEGIN
    //             Position := GETPOSITION;
    //             EXIT(TRUE);
    //           END;
    //         END;
    //     // < TL5.00:08 <<<
    //     END;

    //     EXIT(FALSE);
    //     // < TL5.00:06 <<<
    // end;

    var
        PermissionSet: Record "Permission Set";
        "Sales Header": Record "Sales Header";
}

