page 50021 "POI Account Check GL"
{
    //Page60017
    Caption = 'Ausnahmegenehmigung prüfen GL';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Quality Management";
    InsertAllowed = false;
    DataCaptionExpression = ShowCaption();


    layout
    {
        area(Content)
        {
            group(GL)
            {
                Caption = 'Geschäfts- und kfm. Leitung Ausnahmegenehmigung';
                // label(GL_KL)
                // {
                //     Caption = 'Geschäftsleitung / Kaufmännische Leitung';
                //     ColumnSpan = 4;
                // }
                field(Name; Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = False;
                    Visible = false;
                }
                grid(KL_Grid)
                {

                    label(GL_KL1)
                    {
                        caption = 'Authentizität Firma, Firmenanschrift und Verkäufer des Warenlieferanten bzw. Transporteurs sind bekannt und Verifikationsanruf sowie Prüfung Firmensitz und Fruchthandelsaktivität erübrigen sich';
                        ColumnSpan = 4;
                    }
                    field("Authentizität bekannt"; "Authentizität bekannt")
                    {
                        Caption = ' ';
                        MultiLine = true;
                        ApplicationArea = All;
                        ToolTip = ' ';
                        RowSpan = 4;
                        //Editable = AuthentizitaetbekanntEditable;
                        ShowCaption = false;
                        Editable = False;
                    }
                }
            }
            group(Handel)
            {
                Caption = 'Einkäufe werden genehmigt obwohl folgende Voraussetzungen nicht erfüllt sind:';
                // label(Handelsgen)
                // {
                //     Caption = 'Ein Handel wird genehmigt obwohl ein oder mehrere der folgenden Punkte zutreffen:';
                // }
                // grid(InternCreditlimit)
                // {
                //     label(InternalCreditlimtLabe)
                //     {
                //         Caption = 'Inanspruchnahme des internes Kreditlimits';
                //     }
                //     field("Internal credit limit"; "Internal credit limit")
                //     {
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         //Editable = InternesKreditlimitEditable;
                //         ShowCaption = false;
                //     }
                // }
                // grid(internesKL)
                // {
                //     label(InternesKLLabel)
                //     {
                //         Caption = 'Genehmigung internes Kreditlimit';
                //     }
                //     field("Internes Kreditlimit"; "Internes Kreditlimit")
                //     {
                //         Caption = 'Genehmigung internes Kreditlimit';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         //Editable = InternesKreditlimitEditable;
                //         ShowCaption = false;
                //     }
                // }
                // grid(KLValid)
                // {
                //     label(KLValidlabel)
                //     {
                //         Caption = 'Internes Vorkasselimite genehmigt bis:';
                //     }
                //     field("Credit limit int. valid until"; "Credit limit int. valid until")
                //     {
                //         Caption = 'Internes Kreditlimit gültig bis';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         //Editable = KreditlimitintgueltigbisEditable;
                //         ShowCaption = false;
                //         Editable = False;
                //     }
                // }
                grid(Briefkopf)
                {
                    label(Briefkopflabel)
                    {
                        Caption = 'Blankobriefkopf / Beispielbriefkopf fehlt';
                    }
                    field("Kein Blankobriefkopf"; "Kein Blankobriefkopf")
                    {
                        Caption = 'Blankobriefkopf / Beispielbriefkopf fehlt';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        //Editable = KeinBlankobriefkopfEditable;
                        ShowCaption = false;
                        Editable = False;
                    }
                }
                grid(Handelsregister)
                {
                    label(HandelsregisterLabel)
                    {
                        Caption = 'Handelsregisterauszug/Firmenauskunft fehlt';
                    }
                    field("Kein Handelsregisterauszug"; "Kein Handelsregisterauszug")
                    {
                        Caption = 'Handelsregisterauszug fehlt';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        //Editable = KeinHandelsregisterauszugEditable;
                        ShowCaption = false;
                        Editable = False;
                    }
                }

                grid(Stammblatt)
                {
                    label(Stammblattlabel)
                    {
                        Caption = 'Lieferantenstammblatt ist noch nicht unterzeichnet zurück. (Etwaig vorgemerkte Rückvergütungen sind noch nicht bestätigt)';
                        StyleExpr = 'Attention';
                    }
                    field("Stammblatt nicht unterzeichnet"; "Stammblatt nicht unterzeichnet")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        //Editable = StammblattnichtunterzeichnetEditable;
                        ShowCaption = false;
                        Editable = False;
                    }
                }
                // grid(StammblattValid)
                // {
                //     label(StammblattValidlabel)
                //     {
                //         Caption = 'Stammblatt gültig bis';
                //     }
                //     field("Stammblatt gültig bis"; "Stammblatt gültig bis")
                //     {
                //         Caption = 'Stammblatt gültig bis';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         //Editable = StammblattgueltigbisEditable;
                //         ShowCaption = false;
                //     }
                // }
                grid(Unterschrift)
                {
                    label(UnterschriftLabel)
                    {
                        Caption = 'Unterschrift Stammblatt erfolgte nicht durch gesetzl. Vertretungsberechtigten.';
                    }
                    field("Unterschrift Übereinstimmung"; "Unterschrift Übereinstimmung")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = False;
                    }
                }
                grid(Fragebogen)
                {
                    label(Fragebogenlabel)
                    {
                        Caption = 'Nichtvorliegen Lieferantenfragebogen / Transporterklärung';
                    }
                    field("Kein Lieferantenfragebogen"; "Kein Lieferantenfragebogen")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = False;
                    }
                }
                // grid(lfbvalid)
                // {
                //     label(lfbvalidLabel)
                //     {
                //         Caption = 'Kein LFB gültig bis';
                //     }
                //     field("Kein LFB gültig bis"; "Kein LFB gültig bis")
                //     {
                //         Caption = 'Kein LFB gültig bis';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         ShowCaption = false;
                //     }
                // }
                grid(sozial)
                {
                    label(Soziallabel)
                    {
                        Caption = 'Nichtvorliegen der gültigen Zertifikate (Qualität-/Sozialstandards und/oder GGAP)';
                    }
                    field("Kein gültiger GGAP-Zertifikat"; "Kein gültiger GGAP-Zertifikat")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = False;
                    }
                }
                // grid(GAAP)
                // {
                //     label(GAAPLabel)
                //     {
                //         Caption = 'GGAP-Zertifikat gültig bis';
                //     }
                //     field("GGAP-Zertifikat gültig bis"; "GGAP-Zertifikat gültig bis")
                //     {
                //         Caption = 'GGAP-Zertifikat gültig bis';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         //Editable = GGAPZertifikatgueltigbisEditable;
                //         ShowCaption = false;
                //     }
                // }
                grid(keinLaborber)
                {
                    label(keinLaborberLabel)
                    {
                        Caption = 'Nichtvorliegen eines konformen Laborberichts';
                    }
                    field("Kein Konformer Laborbericht"; "Kein Konformer Laborbericht")
                    {
                        Caption = 'Nichtvorliegen eines konformen Laborberichts';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        //Editable = KeinKonformerLaborberichtEditable;
                        ShowCaption = false;
                        Editable = False;
                    }
                }
                // grid(Laborvalid)
                // {
                //     label(LaborvalidLabel)
                //     {
                //         Caption = 'Laborbericht gültig bis';
                //     }
                //     field("Laborbericht gültig bis"; "Laborbericht gültig bis")
                //     {
                //         Caption = 'Laborbericht gültig bis';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         ShowCaption = false;
                //     }
                // }
                // grid(verification)
                // {
                //     label(VerificationLabel)
                //     {
                //         Caption = 'Verzicht auf Verifikation Geschäftstätigkeit und/oder Adresse';
                //         ApplicationArea = All;
                //     }
                //     field("Verzicht auf Verifikation"; "Verzicht auf Verifikation")
                //     {
                //         Caption = ' ';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         //Editable = VerzichtaufVerifikationEditable;
                //         ShowCaption = false;
                //     }
                // }
            }
            part("POI Account Check Detail GL"; "POI Account Check Detail GL")
            {
                Caption = 'Freigabe gültig für Mandanten';
                ApplicationArea = All;
                ToolTip = ' ';
                SubPageLink = "No." = field("No."), "Source Type" = field("Source Type");
            }
            group(Freigabetext)
            {
                Caption = 'Begründung für die Entscheidung zur Ausnahmegenehmigung:';
                grid(comment)
                {
                    // label(CommentLabel)
                    // {
                    //     Caption = 'Begründung für die Entscheidung zur Ausnahmegenehmigung:';
                    //     ApplicationArea = All;
                    // }
                    Field(reason; Comment)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        MultiLine = true;
                        ShowCaption = false;
                        Editable = CommentEditable;
                    }
                }
            }
            group(Freigabe)
            {
                grid(Freigabe1)
                {
                    label(Freigabe1label)
                    {
                        Caption = 'Freigabe';
                    }
                    field(Ausnahmegenehmigung; Ausnahmegenehmigung)
                    {
                        Caption = 'Freigabe';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = AusnahmegenehmigungEditable;
                        ShowCaption = false;
                    }
                }
                grid(Ausnahmeerteiltdurch)
                {
                    label(ausnahmeerteiltdurchLabel)
                    {
                        Caption = 'Ausnahmegenehmigung entschieden durch';
                    }
                    field("Ausnahmeg. erteilt durch"; "Ausnahmeg. erteilt durch")
                    {
                        Caption = 'Ausnahmegenehmigung entschieden durch';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                grid(Ausnahmeam)
                {
                    label(AusnahmeamLabel)
                    {
                        Caption = 'Ausnahmegenehmigung erteilt am';
                    }
                    field("Ausnahmegenehmigung erteilt am"; "Ausnahmegenehmigung erteilt am")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
                grid(Ausnahmeerinnerung)
                {
                    label(Ausnahmeerinnerunglabel)
                    {
                        Caption = 'Ausnahmegenehmigung Ablauf Erinnerung';
                    }
                    field("Ausnahmegenehmigung Erinnerung"; "Ausnahmegenehmigung Erinnerung")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                // grid(Ausnahmeablauf)
                // {
                //     label(Ausnahmeablauflabel)
                //     {
                //         Caption = 'Ausnahmegenehmigung Ablauf';
                //     }
                //     field("Ausnahmegenehmigung Ablauf"; "Ausnahmegenehmigung Ablauf")
                //     {
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         ShowCaption = false;
                //     }
                // }
                // field(QS; QS)
                // {
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                // }
            }

        }
    }

    // actions
    // {
    //     area(Processing)
    //     {
    //         action("QS Kreditoren Prüfung")
    //         {
    //             ApplicationArea = All;
    //             ToolTip = ' ';
    //             RunObject = page "POI Accounts Requirements";
    //             RunPageLink = "Source No." = field("No.");
    //         }
    //     }
    // }

    procedure ActivateFirstFields()
    var
        Vend: Record Vendor;
        lr_Contact: Record Contact;
        lr_KredDebAnforderung: Record "POI Account Requirements";
        AccCompSetting: Record "POI Account Company Setting";
        g_VendName: Text[100];
    begin
        IF Vend.GET("No.") THEN BEGIN
            g_VendName := Vend.Name;

            IF "Vorliegen von CMR" THEN BEGIN
                VerifikationAdresseEditable := false;
                VerifikationGeschaeftstaetigkeitEditable := FALSE;
            END ELSE
                IF NOT ("Vorliegen von CMR") AND ((Vend."POI Supplier of Goods") OR (Vend."POI Carrier"))
       THEN BEGIN
                    VerifikationAdresseEditable := TRUE;
                    VerifikationGeschaeftstaetigkeitEditable := TRUE;

                END ELSE
                    IF NOT ("Vorliegen von CMR") AND (NOT (Vend."POI Supplier of Goods") OR
             NOT (Vend."POI Carrier"))
           THEN BEGIN
                        VerifikationAdresseEditable := FALSE;
                        VerifikationGeschaeftstaetigkeitEditable := FALSE;

                    END ELSE
                        IF ("Vorliegen von CMR") AND (NOT (Vend."POI Supplier of Goods") OR
                 NOT (Vend."POI Carrier"))
               THEN BEGIN
                            VerifikationAdresseEditable := FALSE;
                            VerifikationGeschaeftstaetigkeitEditable := FALSE;
                        END ELSE
                            IF ("Authentizität bekannt" = FALSE) THEN BEGIN
                                VerifikationAdresseEditable := TRUE;
                                VerifikationGeschaeftstaetigkeitEditable := TRUE;
                            END;
        END;
        IF NOT ("Vorkasse erwünscht") THEN
            KreditversicherungslimitEditable := FALSE
        ELSE
            KreditversicherungslimitEditable := TRUE;


        case "Prepayment requested Status" of
            "Prepayment requested Status"::beantragt:
                InternesKreditlimitEditable := FALSE;
            "Prepayment requested Status"::genehmigt:
                InternesKreditlimitEditable := FALSE;
            "Prepayment requested Status"::teilgenehmigt:
                InternesKreditlimitEditable := FALSE;
            "Prepayment requested Status"::abgelehnt:
                ;
            "Prepayment requested Status"::" ":
                InternesKreditlimitEditable := FALSE;
        end;

        lr_ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        lr_ContBusRel.SETRANGE("Link to Table", lr_ContBusRel."Link to Table"::Vendor);
        lr_ContBusRel.SETRANGE("No.", "No.");
        IF lr_ContBusRel.FIND('-') THEN BEGIN
            lr_Contact.GET(lr_ContBusRel."Contact No.");
            IF (lr_Contact."POI Customs Agent") OR (lr_Contact."POI Tax Representative") OR (lr_Contact."POI Diverse Vendor") OR (lr_Contact."POI Shipping Company") THEN BEGIN
                "Kein Lieferantenfragebogen" := FALSE;
                "Kein gültiger GGAP-Zertifikat" := FALSE;
                "Kein Konformer Laborbericht" := FALSE;
            END;
            IF (NOT AccCompSetting.BasicCompExists(lr_Contact."No.", AccCompSetting."Account Type"::Contact)) AND (lr_Contact."POI Supplier of Goods")
            THEN
                "Kein Konformer Laborbericht" := TRUE
            ELSE
                "Kein Konformer Laborbericht" := FALSE;
        END;

        IF "Authentizität bekannt" THEN BEGIN
            VerifikationAdresseEditable := FALSE;
            VerifikationGeschaeftstaetigkeitEditable := FALSE;
        END ELSE BEGIN
            VerifikationAdresseEditable := TRUE;
            VerifikationGeschaeftstaetigkeitEditable := TRUE;
        END;


        IF ("Reactivate Old Vendor" AND ("Verifikation Adresse" = "Verifikation Adresse"::Reaktivierung) AND
          (VerifikationGeschäftstätigkeit = VerifikationGeschäftstätigkeit::Reaktivierung) AND
          (Verifikationsanruf = Verifikationsanruf::Reaktivierung))
        THEN BEGIN
            VerifikationAdresseEditable := FALSE;
            VerifikationGeschaeftstaetigkeitEditable := FALSE;
        END;

        VerzichtaufVerifikationEditable := FALSE;
        KeinBlankobriefkopfEditable := FALSE;
        KeinHandelsregisterauszugEditable := FALSE;

        IF (NOT lr_Contact."POI Customs Agent") AND (NOT lr_Contact."POI Tax Representative") AND
          (NOT lr_Contact."POI Diverse Vendor") AND (NOT lr_Contact."POI Shipping Company")
        THEN BEGIN
            IF lr_KredDebAnforderung.GET("Source Type", "No.") THEN BEGIN
                IF lr_KredDebAnforderung."QS Vorliegen LFB" THEN
                    "Kein Lieferantenfragebogen" := FALSE
                ELSE
                    "Kein Lieferantenfragebogen" := TRUE;
                IF lr_KredDebAnforderung."QS Gültige Zertifikate" THEN
                    "Kein gültiger GGAP-Zertifikat" := FALSE
                ELSE
                    "Kein gültiger GGAP-Zertifikat" := TRUE;
                IF lr_KredDebAnforderung."QS Laborbericht Konform" THEN
                    "Kein Konformer Laborbericht" := FALSE
                ELSE
                    if not AccCompSetting.OperationCompExists(lr_Contact."No.", AccCompSetting."Account Type"::Contact) AND (lr_Contact."POI Supplier of Goods") THEN
                        "Kein Konformer Laborbericht" := TRUE
                    ELSE
                        "Kein Konformer Laborbericht" := FALSE;
            END;

            IF NOT "Externes Stammblatt" THEN
                "Stammblatt nicht unterzeichnet" := TRUE
            ELSE
                "Stammblatt nicht unterzeichnet" := FALSE;
        END;

        IF Blankobriefkopf THEN
            "Kein Blankobriefkopf" := FALSE
        ELSE
            "Kein Blankobriefkopf" := TRUE;
        IF "Externes Stammblatt" THEN
            "Stammblatt nicht unterzeichnet" := FALSE
        ELSE
            "Stammblatt nicht unterzeichnet" := TRUE;
        IF Vend."POI Amtsgericht" = Vend."POI Amtsgericht"::"not registered" THEN
            "Kein Handelsregisterauszug" := FALSE
        ELSE
            IF Vend."POI Amtsgericht" = Vend."POI Amtsgericht"::registered THEN
                IF NOT Handelsregisterauszug THEN
                    "Kein Handelsregisterauszug" := TRUE
                ELSE
                    "Kein Handelsregisterauszug" := FALSE;
        IF "Prüfung Kundenunterschrift" THEN
            "Unterschrift Übereinstimmung" := FALSE
        ELSE
            "Unterschrift Übereinstimmung" := TRUE;

        if Ausnahmegenehmigung = Ausnahmegenehmigung::genehmigt then
            CommentEditable := false
        else
            CommentEditable := true;
    end;

    procedure ActivateFields()
    begin

        IF NOT gc_POIFunc.UserInWindowsRole('GL_VENDVERIFIKAT_W') THEN BEGIN
            StammblattnichtunterzeichnetEditable := FALSE;
            StammblattgueltigbisEditable := FALSE;
            GGAPZertifikatgueltigbisEditable := FALSE;
            KreditlimitintgueltigbisEditable := FALSE;

            IF "Internal credit limit" THEN
                InternesKreditlimitEditable := FALSE;

            IF gc_POIFunc.UserInWindowsRole('HA_VENDVERIFIKAT_W') THEN
                KreditversicherungslimitEditable := FALSE
            ELSE
                IF gc_POIFunc.UserInWindowsRole('ABW_VENDVERIFIKAT_W') THEN
                    KreditversicherungslimitEditable := FALSE;

            AuthentizitaetbekanntEditable := FALSE;
            AusnahmegenehmigungEditable := false;
            CommentEditable := false;

        END ELSE BEGIN
            VerifikationAdresseEditable := FALSE;
            VerifikationGeschaeftstaetigkeitEditable := FALSE;

            KreditversicherungslimitEditable := FALSE;
            StammblattnichtunterzeichnetEditable := FALSE;
            KeinKonformerLaborberichtEditable := FALSE;
            StammblattgueltigbisEditable := FALSE;
            GGAPZertifikatgueltigbisEditable := FALSE;
            KreditlimitintgueltigbisEditable := TRUE;

            IF "Internal credit limit" THEN
                InternesKreditlimitEditable := TRUE;

            IF (("Internal credit limit") AND ("Internes Kreditlimit" = 0)) THEN
                AusnahmegenehmigungEditable := FALSE
            ELSE
                AusnahmegenehmigungEditable := TRUE;

            if Ausnahmegenehmigung = Ausnahmegenehmigung::genehmigt then
                CommentEditable := false
            else
                CommentEditable := true;
        END;
    end;

    procedure GetNo(p_No: Code[20]; p_SourceType: Option Vendor,"Vendor Group",Customer,"Customer Group")
    begin
        g_No := p_No;
        g_sourceType := p_SourceType;
    end;

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        case "Source Type" of
            "Source Type"::Vendor:
                IF Vendor.Get("No.") then
                    AccName := Vendor.Name;
            "Source Type"::Customer:
                if Customer.Get("No.") then
                    AccName := Customer.Name;
        end;
        ActivateFields();
    end;



    procedure ShowCaption(): text
    begin
        EXIT("No." + ' / ' + Name);
    end;

    trigger OnOpenPage()
    begin
        VerifikationAdresseEditable := true;
        VerifikationGeschaeftstaetigkeitEditable := true;
        KreditversicherungslimitEditable := true;
        InternesKreditlimitEditable := true;
        VerzichtaufVerifikationEditable := true;
        KeinBlankobriefkopfEditable := true;
        KeinHandelsregisterauszugEditable := true;
        StammblattnichtunterzeichnetEditable := true;
        KeinKonformerLaborberichtEditable := true;
        StammblattgueltigbisEditable := true;
        GGAPZertifikatgueltigbisEditable := true;
        KreditlimitintgueltigbisEditable := true;
        AuthentizitaetbekanntEditable := true;
        AusnahmegenehmigungEditable := true;

        // FILTERGROUP(2);
        // SETRANGE("No.", g_No);
        // SETRANGE("Source Type", g_SourceType);
        FILTERGROUP(0);

        // IF (Uppercase(COMPANYNAME()) <> poiCompany.GetBasicCompany()) THEN
        //     CurrPage.EDITABLE := FALSE;

        // //lr_Qualitaetssicherung.GET(g_No, g_SourceType);

        IF NOT gc_POIFunc.UserInWindowsRole('GL_VENDVERIFIKAT_W') THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            IF NOT ("Freigabe für Kreditor") THEN BEGIN
                g_CommentGL := FALSE;
                g_CommentDEV := FALSE;
                ActivateFirstFields();
                ActivateFields();
            END;
    end;


    var
        //lr_Qualitaetssicherung: Record "POI Quality Management";
        lr_ContBusRel: Record "Contact Business Relation";
        //poiCompany: Record "POI Company";
        gc_POIFunc: Codeunit POIFunction;
        AccName: Text[100];
        g_No: Code[20];
        g_sourceType: Option Vendor,"Vendor Group",Customer,"Customer Group";
        g_CommentGL: Boolean;
        g_CommentDEV: Boolean;
        VerifikationAdresseEditable: boolean;
        VerifikationGeschaeftstaetigkeitEditable: boolean;
        KreditversicherungslimitEditable: Boolean;
        InternesKreditlimitEditable: Boolean;
        VerzichtaufVerifikationEditable: Boolean;
        KeinBlankobriefkopfEditable: Boolean;
        KeinHandelsregisterauszugEditable: Boolean;
        StammblattnichtunterzeichnetEditable: Boolean;
        KeinKonformerLaborberichtEditable: Boolean;
        StammblattgueltigbisEditable: Boolean;
        GGAPZertifikatgueltigbisEditable: Boolean;
        KreditlimitintgueltigbisEditable: Boolean;
        AuthentizitaetbekanntEditable: Boolean;
        AusnahmegenehmigungEditable: Boolean;
        CommentEditable: Boolean;

}