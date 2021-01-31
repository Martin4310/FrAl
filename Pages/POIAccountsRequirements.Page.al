page 50022 "POI Accounts Requirements"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "POI Account Requirements";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Erfüllte Anforderungen"; "Erfüllte Anforderungen")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("QS Gültige Zertifikate"; "QS Gültige Zertifikate")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = QSGueltigeZertifikateEditable;
                }
                field("QS Laborbericht Konform"; "QS Laborbericht Konform")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("QS Vorliegen LFB"; "QS Vorliegen LFB")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = QSVorliegenLFBEditable;
                }
                field("Reactivate Old Vendor"; "Reactivate Old Vendor")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Visible = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        Cont: Record Contact;
        AccountCompSetting: Record "POI Account Company Setting";
        gc_POIFunc: Codeunit POIFunction;
        BasicCompanyExist: Boolean;

    begin
        QSVorliegenLFBEditable := true;
        QSGueltigeZertifikateEditable := true;
        QSLaborberichtKonformEditable := true;
        // IF (COMPANYNAME() <> POICompany.GetBasicCompany()) THEN
        //     CurrPage.EDITABLE := FALSE;
        ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
        ContBusRel.SETRANGE("No.", "Source No.");
        IF ContBusRel.FIND('-') THEN BEGIN
            BasicCompanyExist := AccountCompSetting.BasicCompExists(Cont."No.", AccountCompSetting."Account Type"::Contact);
            Cont.GET(ContBusRel."Contact No.");
            IF ((BasicCompanyExist) OR (Cont."POI Customs Agent") OR (Cont."POI Tax Representative") OR
              (Cont."POI Diverse Vendor") OR (Cont."POI Shipping Company")) AND
              ((NOT Cont."POI Supplier of Goods") OR (NOT Cont."POI Warehouse Keeper") OR (NOT Cont."POI Carrier"))
            THEN BEGIN
                QSVorliegenLFBEditable := FALSE;
                QSGueltigeZertifikateEditable := FALSE;
            END;

            IF (NOT BasicCompanyExist) AND (Cont."POI Supplier of Goods") THEN
                QSLaborberichtKonformEditable := true
            ELSE
                IF (Cont."POI Supplier of Goods") OR (Cont."POI Warehouse Keeper") OR (Cont."POI Carrier") THEN BEGIN
                    QSLaborberichtKonformEditable := true;
                    QSVorliegenLFBEditable := TRUE;
                    QSGueltigeZertifikateEditable := TRUE;
                END;
            IF (BasicCompanyExist) AND (NOT Cont."POI Supplier of Goods") THEN
                QSLaborberichtKonformEditable := false;
            IF NOT Cont."POI Supplier of Goods" THEN
                QSLaborberichtKonformEditable := false;
        END;
        IF NOT gc_POIFunc.CheckUserInRole('QS_VENDVERIFIKAT_W', 0) THEN BEGIN
            QSVorliegenLFBEditable := FALSE;
            QSGueltigeZertifikateEditable := FALSE;
            QSLaborberichtKonformEditable := false;
        END;
    end;

    var
        ContBusRel: Record "Contact Business Relation";
        QSVorliegenLFBEditable: boolean;
        QSGueltigeZertifikateEditable: boolean;
        QSLaborberichtKonformEditable: Boolean;
}
