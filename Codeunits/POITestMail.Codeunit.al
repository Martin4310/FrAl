
codeunit 50010 "POI Test Mail"
{
    procedure MailToContact(lContact: Record Contact)
    var
        POIFunction: Codeunit POIFunction;
        POIQSFunction: Codeunit "POI QS Functions";
        txt_PLZ: Text[10];
        txt_Ort: Text[10];
        txt_Email: Text[10];
        lEMail: Text[100];
        Send: Boolean;
        ERR_CorrespTypeHardTxt: Label '';
        ERR_CorrespTypeMailTxt: Label '';
        CON_VendDocTxt: Label 'Dokumente:\%1 \wurden schon am %2 per Mail an %3 versandt.\Sollen die Dokumente trotzdem nochmal versandt werden?', Comment = '%1 %2 %3';
        MSG_VendDocMailTxt: Label 'Folgende Dokumente:\%1 \sind am %2\per Mail an %3\versandt.', Comment = '%1 %2 %3';
    begin
        RelPrintDoc.CHANGECOMPANY('StammdatenPort');
        POIFunction.CheckMandantoryFields(lContact);

        case lContact."Correspondence Type" of
            lContact."Correspondence Type"::"Hard Copy":
                BEGIN
                    IF lContact."Post Code" = '' THEN
                        txt_PLZ := 'PLZ /';
                    IF lContact.City = '' THEN
                        txt_Ort := 'Ort';
                    IF (txt_PLZ <> '') OR (txt_Ort <> '') THEN
                        ERROR(ERR_CorrespTypeHardTxt, lContact."Correspondence Type", txt_PLZ, txt_Ort);
                END;
            lcontact."Correspondence Type"::Email:
                BEGIN
                    IF lContact."E-Mail" = '' THEN
                        txt_Email := 'E-Mail';
                    IF (txt_Email <> '') THEN
                        ERROR(ERR_CorrespTypeMailTxt, lContact."Correspondence Type", txt_Email);
                END;
        end;
        //keine Belege wenn PI StammdatenPort und Sonstiger Kreditor

        RelPrintDoc.RESET();
        RelPrintDoc.SETRANGE("Source No.", lContact."No.");
        RelPrintDoc.SETRANGE(Source, RelPrintDoc.Source::Purchase);
        RelPrintDoc.SETFILTER("Print Document Code", '%1|%2|%3', 'Kontakt Neuanlage', 'Kreditor Neuanlage', 'Kunde Neuanlage');
        RelPrintDoc.SETRANGE(Release, TRUE);
        RelPrintDoc.SETRANGE("Kind of Release", RelPrintDoc."Kind of Release"::Mail);
        RelPrintDoc.SETRANGE("Source Type", RelPrintDoc."Source Type"::Contact);
        RelPrintDoc.SETRANGE("Released as Mail", TRUE);
        RelPrintDoc.SETFILTER("Print Description 1", '<>%1', '');
        IF RelPrintDoc.FINDLAST() THEN BEGIN
            IF GUIALLOWED() THEN
                IF CONFIRM(CON_VendDocTxt, FALSE, RelPrintDoc."Print Description 1", RelPrintDoc."Last Date of Mail", RelPrintDoc."E-Mail") THEN
                    IF NOT lContact."POI Small Vendor" THEN BEGIN
                        POIQSFunction.QSLFBMailContact(DATABASE::Contact, lContact."No.", lContact."E-Mail", lContact."Language Code", lContact, lEMail);
                        Send := TRUE;
                    END;
        END ELSE
            IF NOT lContact."POI Small Vendor" THEN BEGIN
                POIQSFunction.QSLFBMailContact(DATABASE::Contact, lContact."No.", lContact."E-Mail", lContact."Language Code", lContact, lEMail);
                Send := TRUE;
            END;

        IF Send THEN BEGIN
            RelPrintDoc.RESET();
            RelPrintDoc.SETRANGE("Source No.", lContact."No.");
            RelPrintDoc.SETRANGE(Source, RelPrintDoc.Source::Purchase);
            RelPrintDoc.SETFILTER("Print Document Code", '%1|%2|%3', 'Kontakt Neuanlage', 'Kreditor Neuanlage', 'Kunde Neuanlage');
            RelPrintDoc.SETRANGE(Release, TRUE);
            RelPrintDoc.SETRANGE("Kind of Release", RelPrintDoc."Kind of Release"::Mail);
            RelPrintDoc.SETRANGE("Source Type", RelPrintDoc."Source Type"::Contact);
            RelPrintDoc.SETRANGE("Released as Mail", TRUE);
            RelPrintDoc.SETFILTER("Print Description 1", '<>%1', '');
            IF RelPrintDoc.FINDLAST() THEN
                IF RelPrintDoc."E-Mail" = lContact."E-Mail" THEN
                    MESSAGE(MSG_VendDocMailTxt, RelPrintDoc."Print Description 1", RelPrintDoc."Last Date of Mail", RelPrintDoc."E-Mail")
        END;
    end;

    var
        RelPrintDoc: Record "POI Released Print Documents";
}