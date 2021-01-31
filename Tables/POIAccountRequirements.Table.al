table 50004 "POI Account Requirements"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Source Type"; Option)
        {
            Caption = 'Herkunft Typ';
            OptionCaption = 'Vendor,Vendor Group,Customer,Customer Group';
            OptionMembers = Vendor,"Vendor Group",Customer,"Customer Group";
            DataClassification = CustomerContent;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Herkunft Nr.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Type" = CONST(Vendor)) Vendor."No."
            ELSE
            IF ("Source Type" = CONST(Customer)) Customer."No.";
        }
        field(3; "Code"; Option)
        {
            OptionMembers = " ","Erfüllungsgrad LFB","Qualitätsstandards",Sozialstandards,"LEH-Anforderungen";
            DataClassification = CustomerContent;
        }
        field(10; "Erfüllte Anforderungen"; Code[100])
        {
            Caption = 'Erfüllte Anforderungen';
            DataClassification = CustomerContent;
            TableRelation = "POI Certificate Kinds";
        }
        field(100; "QS Vorliegen LFB"; Boolean)
        {
            Caption = 'Vorliegen eines gültigen Lieferantenfrageboges';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF "QS Vorliegen LFB" THEN BEGIN
                    lr_Qualitaetssicherung.RESET();
                    lr_Qualitaetssicherung.SETRANGE("No.", "Source No.");
                    lr_Qualitaetssicherung.SETRANGE("Source Type", lr_Qualitaetssicherung."Source Type"::Vendor);
                    IF lr_Qualitaetssicherung.FINDFIRST() THEN BEGIN
                        lr_Qualitaetssicherung."Kein Lieferantenfragebogen" := FALSE;
                        lr_Qualitaetssicherung."Kein LFB gültig bis" := CALCDATE('< +2W >', WORKDATE());
                        lr_Qualitaetssicherung.MODIFY();
                    END;
                END ELSE BEGIN
                    lr_Qualitaetssicherung.RESET();
                    lr_Qualitaetssicherung.SETRANGE("No.", "Source No.");
                    lr_Qualitaetssicherung.SETRANGE("Source Type", lr_Qualitaetssicherung."Source Type"::Vendor);
                    IF lr_Qualitaetssicherung.FINDFIRST() THEN BEGIN
                        lr_Qualitaetssicherung."Kein Lieferantenfragebogen" := TRUE;
                        lr_Qualitaetssicherung.VALIDATE("Kein LFB gültig bis", 0D);
                        lr_Qualitaetssicherung.MODIFY();
                    END;
                END;


                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
                ContBusRel.SETRANGE("No.", "Source No.");
                IF ContBusRel.FIND('-') THEN
                    Cont.GET(ContBusRel."Contact No.");

                IF (NOT Cont."POI Customs Agent") AND (NOT Cont."POI Tax Representative") AND
                  (NOT Cont."POI Diverse Vendor")
                THEN
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") AND ("QS Laborbericht Konform") THEN BEGIN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE);
                        lr_Qualitaetssicherung.MODIFY();
                    END ELSE BEGIN
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);
                        lr_Qualitaetssicherung.MODIFY();
                    END;

                IF Cont."POI Supplier of Goods" THEN BEGIN
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") AND ("QS Laborbericht Konform") THEN BEGIN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE);
                        lr_Qualitaetssicherung.MODIFY();
                    END ELSE BEGIN
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);
                        lr_Qualitaetssicherung.MODIFY();
                    END;
                END ELSE
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") THEN BEGIN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE);
                        lr_Qualitaetssicherung.MODIFY();
                    END ELSE BEGIN
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);
                        lr_Qualitaetssicherung.MODIFY();
                    END;

            end;
        }
        field(101; "QS Laborbericht Konform"; Boolean)
        {
            Caption = 'Vorliegen eines konformen Laborberichts';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                lr_Qualitaetssicherung.RESET();
                lr_Qualitaetssicherung.SETRANGE("No.", "Source No.");
                lr_Qualitaetssicherung.SETRANGE("Source Type", lr_Qualitaetssicherung."Source Type"::Vendor);
                if lr_Qualitaetssicherung.FINDFIRST() then
                    if "QS Laborbericht Konform" then begin
                        lr_Qualitaetssicherung."Kein Konformer Laborbericht" := FALSE;
                        lr_Qualitaetssicherung."Laborbericht gültig bis" := CALCDATE('< +2W >', WORKDATE());
                    end else begin
                        lr_Qualitaetssicherung."Kein Konformer Laborbericht" := TRUE;
                        lr_Qualitaetssicherung.VALIDATE(lr_Qualitaetssicherung."Laborbericht gültig bis", 0D);
                    end;

                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
                ContBusRel.SETRANGE("No.", "Source No.");
                if ContBusRel.FIND('-') then
                    Cont.GET(ContBusRel."Contact No.");

                IF (NOT Cont."POI Customs Agent") AND (NOT Cont."POI Tax Representative") AND (NOT Cont."POI Diverse Vendor") THEN
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") AND ("QS Laborbericht Konform") THEN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE)
                    ELSE
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);
                IF Cont."POI Supplier of Goods" THEN BEGIN
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") AND ("QS Laborbericht Konform") THEN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE)
                    ELSE
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);
                END ELSE
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") THEN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE)
                    ELSE
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);
                lr_Qualitaetssicherung.MODIFY();
            end;
        }
        field(102; "QS Gültige Zertifikate"; Boolean)
        {
            Caption = 'Vorliegen der gültigen Zertifikate (Qualitäts - Sozialstandards)';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                lr_Qualitaetssicherung.RESET();
                lr_Qualitaetssicherung.SETRANGE("No.", "Source No.");
                lr_Qualitaetssicherung.SETRANGE("Source Type", lr_Qualitaetssicherung."Source Type"::Vendor);
                IF lr_Qualitaetssicherung.FINDFIRST() then
                    if "QS Gültige Zertifikate" /*"QS Vorliegen LFB"*/ then begin
                        lr_Qualitaetssicherung."Kein gültiger GGAP-Zertifikat" := FALSE;
                        lr_Qualitaetssicherung."GGAP-Zertifikat gültig bis" := CALCDATE('< +2W >', WORKDATE());
                    end else begin
                        lr_Qualitaetssicherung."Kein gültiger GGAP-Zertifikat" := TRUE;
                        lr_Qualitaetssicherung.VALIDATE("GGAP-Zertifikat gültig bis", 0D);
                    end;
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
                ContBusRel.SETRANGE("No.", "Source No.");
                IF ContBusRel.FIND('-') THEN
                    Cont.GET(ContBusRel."Contact No.");

                IF (NOT Cont."POI Customs Agent") AND (NOT Cont."POI Tax Representative") AND (NOT Cont."POI Diverse Vendor") THEN
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") AND ("QS Laborbericht Konform") THEN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE)
                    ELSE
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);

                IF Cont."POI Supplier of Goods" THEN BEGIN
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") AND ("QS Laborbericht Konform") THEN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE)
                    ELSE
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);
                END ELSE
                    IF ("QS Vorliegen LFB") AND ("QS Gültige Zertifikate") THEN
                        lr_Qualitaetssicherung.VALIDATE(QS, TRUE)
                    ELSE
                        lr_Qualitaetssicherung.VALIDATE(QS, FALSE);
                lr_Qualitaetssicherung.MODIFY();
            end;
        }
        field(1000; "Reactivate Old Vendor"; Boolean)
        {
            Caption = 'Alten Kreditor reaktivieren';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source No.")
        {
        }
    }


    var

        Cont: Record Contact;
        ContBusRel: record "Contact Business Relation";

    var
        lr_Qualitaetssicherung: Record "POI Quality Management";
}

