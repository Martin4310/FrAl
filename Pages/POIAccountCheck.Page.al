page 50020 "POI Account Check"
{
    //Page60017
    Caption = 'Geschäftspartner prüfen';
    PageType = Card;
    DataCaptionExpression = ShowCaption();
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "POI Quality Management";
    InsertAllowed = false;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Allgemein';

                field("No."; "No.")
                {
                    Caption = 'Geschäftspartner';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = false;
                }
                field(Name; Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    Editable = False;
                }
                // field("Freigabe für Kreditor"; "Freigabe für Kreditor")
                // {
                //     Caption = 'Alle Freigaben erteilt';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                // }
                grid(LFB)
                {
                    label(LFBLabel)
                    {
                        Caption = 'An den Kreditor versendete Dokumente';
                    }
                    field("LFB Version"; "LFB Version")
                    {
                        Caption = 'An den Kreditor versendete Dokumente';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                    field("Document Sending Date"; "Document Sending Date")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(Anfrage)
                {
                    label(AnfrageLabel)
                    {
                        Caption = 'Anfrage Ausnahemgenehmigung gestellt von';
                        StyleExpr = AnfrageColor;
                    }
                    field("Anforderung an GL User ID"; "Anforderung an GL User ID")
                    {
                        Caption = 'Anfrage Ausnahemgenehmigung gestellt von';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = false; // AnforderunganGLUserIDEditable;
                        Visible = AnforderunganGLUserIDVisible;
                        ShowCaption = false;
                    }
                    field("Anforderung an GL Datum"; "Anforderung an GL Datum")
                    {
                        Caption = 'Anfrage gestellt am';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                        Editable = false;
                    }
                }
            }
            // group(Handel)
            // {
            //     Caption = 'Handel';
            //     grid(Vorkasse)
            //     {
            //         label(VorkasseLabel)
            //         {
            //             Caption = 'Vorkasse erwünscht';
            //         }
            //         field("Vorkasse erwünscht"; "Vorkasse erwünscht")
            //         {
            //             Caption = 'Vorkasse erwünscht';
            //             ApplicationArea = All;
            //             ToolTip = ' ';
            //             Editable = VorkasseerwuenschtEditable;
            //             ShowCaption = false;
            //         }
            //     }
            // grid(Kreditlimit)
            // {
            //     label(KreditlimitLabel)
            //     {
            //         Caption = 'gewünschtes Vorkasselimit';
            //     }
            //     field("Gewünschtes Kreditlimit"; "Gewünschtes Kreditlimit")
            //     {
            //         Caption = ' ';
            //         ApplicationArea = All;
            //         ToolTip = ' ';
            //         Editable = FBgewuenschtesKreditEditable;
            //         Visible = tb_FBgewuenschtesKreditVisible;
            //         ShowCaption = false;
            //     }
            // }
            // grid(AnforderungGL)
            // {
            //     label(AnforderungGLLabel)
            //     {
            //         Caption = 'Ausnahmegenehmigung bei GL anfragen.';
            //     }
            //     field("Anforderung an GL"; "Anforderung an GL")
            //     {
            //         Caption = 'Ausnahmegenehmigung bei GL anfragen.';
            //         ApplicationArea = All;
            //         ToolTip = ' ';
            //         Editable = AnforderunganGLEditable;
            //         ShowCaption = false;
            //     }
            // }

            // grid(VorkasseStatus)
            // {
            //     label(VorkasseStatusLabel)
            //     {
            //         Caption = 'Vorkasse erwünscht Status';
            //     }
            //     field("Prepayment requested Status"; "Prepayment requested Status")
            //     {
            //         Caption = 'Vorkasse erwünscht Status';
            //         ApplicationArea = All;
            //         ToolTip = ' ';
            //         Editable = VorkasseStatusEditable;
            //         ShowCaption = false;
            //     }
            // }
            //            }
            group(Abwicklung)
            {
                label(VeriAddress)
                {
                    Caption = 'Verifikation der Adresse und der Geschäftstätigkeit entfällt bei Transporteur sofern CMR Versicherungsnachweis vorliegt.';
                    Style = Strong;
                }

                grid(HandelVeri)
                {
                    label(HandelVeriLabel)
                    {
                        Caption = 'Verifikation der Adresse (Ausdruck) ist archiviert.';
                    }
                    field("Verifikation Adresse"; "Verifikation Adresse")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = VerifikationAdresseEditable;
                        ShowCaption = false;
                        ValuesAllowed = 0, 1, 2;
                    }
                }
                grid(Veribusiness)
                {
                    label(VeriBusinessLabel)
                    {
                        Caption = 'Verifikation Geschäftsadresse (Ausdruck) ist archiviert.';
                    }
                    field("VerifikationGeschäftstätigkeit"; "VerifikationGeschäftstätigkeit")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = VerifikationGeschaeftstaetigkeitEditable;
                        ShowCaption = false;
                        ValuesAllowed = 0, 1, 2;
                    }
                }
                grid(Briefkopf)
                {
                    GridLayout = Columns;
                    label(BriefkopfLabel)
                    {
                        Caption = 'Blankobriefkopf/Beispielbrief ist archiviert';
                    }
                    field(Blankobriefkopf; Blankobriefkopf)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = BlankobriefkopfEditable;
                        ShowCaption = false;
                        ColumnSpan = 2;
                        RowSpan = 2;
                    }
                    field("Blankobriefkopf UserID"; "Blankobriefkopf UserID")
                    {
                        Caption = 'Mitarbeiter';
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = BlankobriefkopfUserIDEditable;
                    }
                }
                grid(Steuernummer)
                {
                    label(SteuernummerLabel)
                    {
                        Caption = 'Bestätigung Steuernummer vom Finanzamt (nur bei Handelspartnern aus Drittländern) ist archiviert';
                    }
                    field("Steuernummer vom FA"; "Steuernummer vom FA")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = SteuernummervomFAEditable;
                        ShowCaption = false;
                    }
                    field("Steuernummer vom FA UserID"; "Steuernummer vom FA UserID")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = SteuernummervomFAUserIDEditable;
                        ShowCaption = false;
                    }
                }
                grid(extStammblatt)
                {
                    label(Stammblattlabel)
                    {
                        Caption = 'Externes Stammblatt liegt vor.';
                    }
                    field("Externes Stammblatt"; "Prüfung ext. Stammblatt")
                    {
                        Caption = 'Externes Stammblatt liegt vor.';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = ExternesStammblattEditable;
                        ShowCaption = false;
                    }
                    field("Externes Stammblatt UserID"; "Prüfung ext. Stammblatt UserID")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = ExternesStammblattUserIDEditable;
                        ShowCaption = false;
                    }
                }
                grid(Handelsregister)
                {
                    label(HandelsregisterLabel)
                    {
                        Caption = 'Handelsregister/Auskunft ist abgelegt unter Dokumente des Kunden.';
                    }
                    field(Handelsregisterauszug; Handelsregisterauszug)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = HandelsregisterauszugEditable;
                        ShowCaption = false;
                    }
                    field("Handelsregisterauszug UserID"; "Handelsregisterauszug UserID")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = HandelsregisterauszugUserIDEditable;
                        ShowCaption = false;
                    }
                }


                grid(VeriCall)
                {
                    label(VeriCallLabel)
                    {
                        Caption = 'Verifikationsanruf';
                    }
                    field(Verifikationsanruf; Verifikationsanruf)
                    {
                        Caption = 'Verifikationsanruf';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = false;
                        ShowCaption = false;
                    }
                }
                grid(VeriName)
                {
                    label(VeriNameLabel)
                    {
                        Caption = 'Name der angerufenen Person';
                    }
                    field("Verifikationsanruf Name"; "Verifikationsanruf Name")
                    {
                        Caption = 'Name der angerufenen Person';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = VerifikationsanrufNameEditable;
                        ShowCaption = false;
                    }
                }
                grid(VeriPhoneno)
                {
                    label(VeriPhoneLabel)
                    {
                        Caption = 'Telefonnr. der angerufenen Person';
                    }
                    field("Verifikationsanruf Tel. Nr."; "Verifikationsanruf Tel. Nr.")
                    {
                        Caption = 'Telefonnr. der angerufenen Person';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = VerifikationsanrufTelNrEditable;
                        ShowCaption = false;
                    }
                }
                grid(VeriPhoneSource)
                {
                    label(VeriPhoneSourceLabel)
                    {
                        Caption = 'Quelle der Telefonnr.';
                    }
                    field("Verifikationsanruf Quelle Tel."; "Verifikationsanruf Quelle Tel.")
                    {
                        Caption = 'Quelle der Telefonnr.';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(verification)
                {
                    label(verificationlabel)
                    {
                        Caption = 'Verifikationsanruf durch Mitarbeiter am';
                    }
                    field("Verifikationsanruf User"; "Verifikationsanruf User")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = VerifikationsanrufUserEditable;
                        ShowCaption = false;
                    }
                    field(VerifikationsanrufDatumUhrzeit; VerifikationsanrufDatumUhrzeit)
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }

                }
                grid(ContactData)
                {
                    label(ContactDataLabel)
                    {
                        Caption = 'Kontaktdaten aus Stammblatt hinterlegt';
                    }
                    field("Kontaktdaten hinterlegt"; "Kontaktdaten hinterlegt")
                    {
                        Caption = 'Kontaktdaten hinterlegt';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = KontaktdatenhinterlegtEditable;
                        ShowCaption = false;
                    }
                }
                grid(zahlung)
                {
                    label(Zahlunglabel)
                    {
                        Caption = 'Zahlungskonditionen/Rückvergütungen und Bankverbindung entsprechend Lieferantenstammblatt sind in den BC Stammdaten hinterlegt';
                    }
                    field(Zahlungskonditionen; Zahlungskonditionen)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = ZahlungskonditionenEditable;
                        ShowCaption = false;
                    }
                }
                grid(Purchasergrid)
                {
                    label(PurchaserLabel)
                    {
                        Caption = 'Einkäufer und Sachbearbeiter in allen aktiven Mandanten hinterlegt.';
                    }
                    field(Purchaser; PurchSalespersonOK)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = false;
                        ShowCaption = false;
                    }
                }
                grid(CMR)
                {
                    label(CMRLabel)
                    {
                        Caption = 'CMR-Versicherungspolice ist archiviert';
                    }
                    field("Vorliegen von CMR"; "Vorliegen von CMR")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = VorliegenvonCMREditable;
                        ShowCaption = false;
                        trigger OnValidate()
                        begin
                            if "Vorliegen von CMR" then begin
                                VerifikationAdresseEditable := false;
                                VerifikationGeschaeftstaetigkeitEditable := false;

                            end else begin
                                VerifikationAdresseEditable := true;
                                VerifikationGeschaeftstaetigkeitEditable := true;
                            end;
                            CurrPage.Update();
                        end;
                    }
                }

            }
            group(Financials)
            {
                Caption = 'Finanzbuchhaltung';
                grid(Unterschrift)
                {
                    label(UnterschriftLabel)
                    {
                        Caption = 'Unterschrift auf externem Stammblatt stimmt mit Handelsregisterauszug, Auskunfteiangaben überein';
                    }
                    field("Prüfung Kundenunterschrift"; "Prüfung Kundenunterschrift")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = PruefungKundenunterschriftEditable;
                        ShowCaption = false;
                    }
                    field("Kundenunterschrift UserID"; "Kundenunterschrift UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = KundenunterschriftUserIDEditable;
                    }
                }
                grid(AngabenStammblatt)
                {
                    label(AngabenstammblattLabel)
                    {
                        Caption = 'Angaben auf externem Stammblatt stimmen mit allen Angaben auf eingereichten Dokumenten Überein.';
                    }
                    field("Prüfung ext. Stammblatt"; "Prüfung ext. Stammblatt")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = PruefungextStammblattEditable;
                        ShowCaption = false;
                    }
                    field("Prüfung ext. Stammblatt UserID"; "Prüfung ext. Stammblatt UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = PruefungextStammblattUserIDEditable;
                    }
                }
                grid(VerificationVATID)
                {
                    label(VATIDLable)
                    {
                        Caption = 'Verifikation der USt-ID (inkl. Ausdruck) ist abgelegt';
                    }

                    field("Verifikation USt-ID"; "Verifikation USt-ID")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = VerifikationUStIDEditable;
                        ShowCaption = false;
                    }
                    field("Verifikation USt-ID UserID"; "Verifikation USt-ID UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = VerifikationUStIDUserIDEditable;
                    }
                }
                grid(AllgemeineAngaben)
                {
                    label(AllgLabel)
                    {
                        Caption = 'Allgemeine Angaben aus ext. Stammblatt sind komplett und korrekt in BC übertragen.';
                    }

                    field("Allg Angaben aus Stammblatt"; "Allg Angaben aus Stammblatt")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = AllgAngabenausStammblattEditable;
                        ShowCaption = false;
                    }
                    field("Allg Angaben Stammblatt UserID"; "Allg Angaben Stammblatt UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = AllgAngabenStammblattUserIDEditable;
                    }
                }
                grid(AblageAusdrucke)
                {
                    label(AblageLabel)
                    {
                        Caption = 'unterzeichnetes Lieferantenstammblatt, Beispielbriefkopf,Handelsregisterauszug/Auskunft sind archiviert.';
                    }
                    field("Stammblatt Ablage"; "Stammblatt Ablage")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = StammblattAblageEditable;
                        ShowCaption = false;
                    }
                    field("Stammblatt Ablage UserID"; "Stammblatt Ablage UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                        Editable = StammblattAblageUserIDEditable;
                    }
                }
            }
            group(Qualitätsmanagement)
            {
                label(QSlbl)
                {
                    Caption = 'QM Daten sind vollständig in der QM Maske erfasst und unterzeichnete Dokumente archiviert.';
                }
                field(QS; QS)
                {
                    ApplicationArea = all;
                    ToolTip = ' ';
                    ShowCaption = false;
                }
            }
            part("POI Account Check Detail"; "POI Account Check Detail")
            {
                Caption = 'Prüfung gültig für Mandanten';
                ApplicationArea = All;
                ToolTip = ' ';
                SubPageLink = "No." = field("No."), "Source Type" = field("Source Type");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            // action("QS Kreditoren Prüfung")
            // {
            //     ApplicationArea = All;
            //     ToolTip = ' ';
            //     RunObject = page "POI Accounts Requirements";
            //     RunPageLink = "Source No." = field("No.");
            // }
            action(Vendor)
            {
                Caption = 'Geschäftspartnerkarte';
                ToolTip = ' ';
                Image = Vendor;
                Promoted = true;
                trigger OnAction()
                var
                    Vendor: Record Vendor;
                    Customer: Record Customer;
                begin
                    case "Source Type" of
                        "Source Type"::Vendor:
                            if Vendor.Get("No.") then
                                Page.Runmodal(26, Vendor);
                        "Source Type"::Customer:
                            if customer.get("No.") then
                                Page.RunModal(21, Customer);
                    end;
                end;
            }
            action("Mail To old Vendor")
            {
                Image = PostMail;
                Caption = 'Aktualisierungsanfrage Dokumente an Alt Kreditor';
                ToolTip = ' ';
                Promoted = true;
                trigger OnAction()
                var
                    Vendor: Record Vendor;
                    Customer: Record Customer;
                    POIQSFunction: Codeunit "POI QS Functions";
                begin
                    case "Source Type" of
                        "Source Type"::Vendor:
                            if Vendor.Get("No.") then
                                POIQSFunction.MailToOldVendor(Vendor);
                        "Source Type"::Customer:
                            if customer.get("No.") then
                                ;
                    end;
                end;
            }
            action(Ausnahmegenehmigung)
            {
                Caption = 'Ausnehmegenehmigung bei GL beantragen';
                ToolTip = ' ';
                Promoted = true;
                Image = Approval;
                trigger OnAction()
                var
                    Receiver: List of [Text];
                    Sender: Text[100];
                    Subject: Text[100];
                    Bodyline: Text;
                begin
                    if Ausnahmegenehmigung = Ausnahmegenehmigung::" " then begin
                        Validate(Ausnahmegenehmigung, Ausnahmegenehmigung::beantragt);
                        //Workflow für Ausnahmegenehmigung - Info an Teams und Workflow initiieren.
                        WFMgt.TaskCreateAccount(RecordId, 'Ausnahmegenehmigung', 'WFAUSNAHME', "No.", '');
                        //Meldung an Teams oder Mail
                        WFGroup.get('GL');
                        case WFGroup.Infochannel of
                            WFGroup.Infochannel::Teams:
                                begin
                                    UrlTxt := TeamsMgt.CreateTeamsUrlAusnahme(RecordId, '');
                                    TeamsMgt.SendMessageToTeams(UrlTxt, 'IT');
                                end;
                            WFGroup.Infochannel::"E-Mail":
                                begin
                                    Mailsetup.GetMailSenderReceiver('QS', 'AUSNAHME', Sender, Receiver, POICompany.GetBasicCompany());
                                    Salesperson.SetRange("POI Navision User ID Code", UserId);
                                    if Salesperson.FindFirst() and not Receiver.Contains(Salesperson."E-Mail") then
                                        Receiver.Add(Salesperson."E-Mail");
                                    Subject := 'Ausnahmegenehmigung';
                                    Bodyline := TeamsMgt.CreateTeamsUrlAusnahme(RecordId, '');
                                    SMTPMail.CreateMessage('QS', Sender, Receiver, Subject, Bodyline);
                                    SMTPMail.Send();
                                end;
                        end;
                    end;
                end;
            }
            action(Zertifizierungen)
            {
                caption = 'QM-Anforderungen';
                Image = Documents;
                ApplicationArea = all;
                RunObject = page "POI Certificates Cust./Vend.";
                RunPageLink = "Source No." = field("No."), Source = const(Vendor);
                ToolTip = ' ';
                Promoted = true;
                //PromotedIsBig = true;
            }
        }
    }

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
        IF NOT ("Vorkasse erwünscht") THEN BEGIN
            FBgewuenschtesKreditEditable := FALSE;
            KreditversicherungslimitEditable := FALSE;
            VorkasseStatusEditable := FALSE;
        END ELSE BEGIN
            FBgewuenschtesKreditEditable := TRUE;
            KreditversicherungslimitEditable := TRUE;
            VorkasseStatusEditable := TRUE;
        END;

        case "Prepayment requested Status" of
            "Prepayment requested Status"::beantragt:
                BEGIN
                    VorkasseerwuenschtEditable := TRUE;
                    GewuenschtesKreditEditable := TRUE;
                    tb_GewuenschtesKreditVisible := true;
                    tb_FBgewuenschtesKreditVisible := TRUE;
                    FBgewuenschtesKreditEditable := TRUE;
                    InternesKreditlimitEditable := FALSE;
                END;
            "Prepayment requested Status"::genehmigt:
                BEGIN
                    VorkasseerwuenschtEditable := FALSE;
                    GewuenschtesKreditEditable := FALSE;
                    tb_GewuenschtesKreditVisible := true;
                    tb_FBgewuenschtesKreditVisible := TRUE;
                    FBgewuenschtesKreditEditable := FALSE;
                    InternesKreditlimitEditable := FALSE;
                END;
            "Prepayment requested Status"::teilgenehmigt:
                BEGIN
                    VorkasseerwuenschtEditable := FALSE;
                    GewuenschtesKreditEditable := FALSE;
                    tb_GewuenschtesKreditVisible := TRUE;
                    tb_FBgewuenschtesKreditVisible := TRUE;
                    FBgewuenschtesKreditEditable := FALSE;
                    InternesKreditlimitEditable := FALSE;
                END;
            "Prepayment requested Status"::abgelehnt:
                BEGIN
                    VorkasseerwuenschtEditable := FALSE;
                    GewuenschtesKreditEditable := FALSE;
                    tb_GewuenschtesKreditVisible := FALSE;
                END;
            "Prepayment requested Status"::" ":
                BEGIN
                    VorkasseerwuenschtEditable := FALSE;
                    FBgewuenschtesKreditEditable := FALSE;
                    tb_GewuenschtesKreditVisible := FALSE;
                    InternesKreditlimitEditable := FALSE;
                END;
        end;

        IF NOT gc_POIFunc.UserInWindowsRole('FB_VENDVERIFIKAT_W') THEN BEGIN
            FBgewuenschtesKreditEditable := FALSE;
            VorkasseStatusEditable := FALSE;
        END ELSE BEGIN
            FBgewuenschtesKreditEditable := TRUE;
            VorkasseStatusEditable := TRUE;
        END;

        Verifikationsanrufeditable := FALSE;

        lr_ContBusRel.SETCURRENTKEY("Link to Table", "No.");
        lr_ContBusRel.SETRANGE("Link to Table", lr_ContBusRel."Link to Table"::Vendor);
        lr_ContBusRel.SETRANGE("No.", "No.");
        IF lr_ContBusRel.FIND('-') THEN BEGIN
            lr_Contact.GET(lr_ContBusRel."Contact No.");


            IF (lr_Contact."POI Customs Agent") OR (lr_Contact."POI Tax Representative") OR
    (lr_Contact."POI Diverse Vendor") OR (lr_Contact."POI Shipping Company")
  THEN BEGIN
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
            VerifikationsanrufNameEditable := FALSE;
            VerifikationsanrufTelNrEditable := FALSE;
            VerifikationsanrufQuelleTelEditable := FALSE;
        END ELSE BEGIN
            VerifikationAdresseEditable := TRUE;
            VerifikationGeschaeftstaetigkeitEditable := TRUE;
            VerifikationsanrufNameEditable := TRUE;
            VerifikationsanrufTelNrEditable := TRUE;
            VerifikationsanrufQuelleTelEditable := TRUE;
        END;

        IF "Anforderung an GL" THEN BEGIN
            AnforderunganGLEditable := FALSE;
            cb_AnforderungABWEditable := FALSE;
            cb_AnforderungFBEditable := FALSE;
            AnforderunganGLUserIDVisible := TRUE;
        END ELSE BEGIN
            AnforderunganGLEditable := TRUE;
            cb_AnforderungABWEditable := TRUE;
            cb_AnforderungFBEditable := TRUE;
            AnforderunganGLUserIDVisible := TRUE;
        END;
        AnforderunganGLUserIDEditable := FALSE;
        AnforderunganGLUserIDEditable := FALSE;

        IF ("Reactivate Old Vendor" AND ("Verifikation Adresse" = "Verifikation Adresse"::Reaktivierung) AND
          (VerifikationGeschäftstätigkeit = VerifikationGeschäftstätigkeit::Reaktivierung) AND
          (Verifikationsanruf = Verifikationsanruf::Reaktivierung))
        THEN BEGIN
            VerifikationAdresseEditable := FALSE;
            VerifikationGeschaeftstaetigkeitEditable := FALSE;
            Verifikationsanrufeditable := FALSE;
            VerifikationsanrufNameEditable := FALSE;
            VerifikationsanrufTelNrEditable := FALSE;
            VerifikationsanrufQuelleTelEditable := FALSE;
        END;

        VerzichtaufVerifikationEditable := FALSE;
        KeinBlankobriefkopfEditable := FALSE;
        KeinHandelsregisterauszugEditable := FALSE;
        UnterschriftUebereinstimmungEditable := FALSE;

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

        IF lr_Contact."POI Shipping Company" THEN
            VorliegenvonCMREditable := FALSE;

        IF NOT Vend."POI Carrier" THEN
            VorliegenvonCMREditable := FALSE;

        IF lr_Contact."POI Diverse Vendor" THEN
            BlankobriefkopfEditable := FALSE;
        IF Blankobriefkopf THEN
            "Kein Blankobriefkopf" := FALSE
        ELSE
            "Kein Blankobriefkopf" := TRUE;
        IF "Externes Stammblatt" THEN
            "Stammblatt nicht unterzeichnet" := FALSE
        ELSE
            "Stammblatt nicht unterzeichnet" := TRUE;
        IF Vend."POI Amtsgericht" = Vend."POI Amtsgericht"::"not registered" THEN BEGIN
            HandelsregisterauszugEditable := false;
            "Kein Handelsregisterauszug" := FALSE;
        END ELSE
            IF Vend."POI Amtsgericht" = Vend."POI Amtsgericht"::registered THEN
                IF NOT Handelsregisterauszug THEN
                    "Kein Handelsregisterauszug" := TRUE
                ELSE
                    "Kein Handelsregisterauszug" := FALSE;
        IF "Prüfung Kundenunterschrift" THEN
            "Unterschrift Übereinstimmung" := FALSE
        ELSE
            "Unterschrift Übereinstimmung" := TRUE;
    end;

    procedure ActivateFields()
    var
        lr_CountryRegion: Record "Country/Region";
        Vend: Record Vendor;
    begin

        IF NOT gc_POIFunc.UserInWindowsRole('GL_VENDVERIFIKAT_W') THEN BEGIN
            tb_GewuenschtesKreditVisible := TRUE;
            BlankobriefkopfUserIDEditable := FALSE;
            HandelsregisterauszugUserIDEditable := FALSE;

            IF Vend.GET("No.") THEN
                IF lr_CountryRegion.GET(Vend."Country/Region Code") THEN
                    IF lr_CountryRegion."EU Country/Region Code" <> '' THEN
                        SteuernummervomFAEditable := FALSE
                    ELSE
                        VerifikationUStIDEditable := FALSE;

            KontaktdatenhinterlegtEditable := TRUE;
            ZahlungskonditionenEditable := TRUE;
            SteuernummervomFAUserIDEditable := FALSE;
            KundenunterschriftUserIDEditable := FALSE;
            PruefungextStammblattUserIDEditable := FALSE;
            VerifikationUStIDUserIDEditable := FALSE;
            AllgAngabenStammblattUserIDEditable := FALSE;
            KreditversichLimitUserIDEditable := FALSE;
            KeinLieferantenfragebogenEditable := FALSE;
            StammblattnichtunterzeichnetEditable := FALSE;
            KeingueltigerGGAPZertifikatEditable := FALSE;
            KeinKonformerLaborberichtEditable := FALSE;
            KreditlimitinternEditable := FALSE;
            KeinLFBgueltigbisEditable := FALSE;
            StammblattgueltigbisEditable := FALSE;
            GGAPZertifikatgueltigbisEditable := FALSE;
            KreditlimitintgueltigbisEditable := FALSE;
            VorkasseerwuenschtEditable := TRUE;

            IF "Internal credit limit" THEN BEGIN

                tb_GewuenschtesKreditVisible := FALSE;
                InternesKreditlimitEditable := FALSE;
            END ELSE
                tb_GewuenschtesKreditVisible := TRUE;

            IF gc_POIFunc.CheckUserInRole('HA_VENDVERIFIKAT_W', 0) THEN BEGIN
                cb_AnforderungABWEditable := FALSE;
                cb_AnforderungFBEditable := FALSE;
                KontaktdatenhinterlegtEditable := FALSE;
                ZahlungskonditionenEditable := FALSE;
                VorliegenvonCMREditable := FALSE;
                PruefungKundenunterschriftEditable := FALSE;
                PruefungextStammblattEditable := FALSE;
                VerifikationUStIDEditable := FALSE;
                AllgAngabenausStammblattEditable := FALSE;
                KreditversicherungslimitEditable := FALSE;
                SynchronizedEditable := FALSE;
                PurchaserEditable := FALSE;
            END ELSE
                IF gc_POIFunc.CheckUserInRole('ABW_VENDVERIFIKAT_W', 0) THEN BEGIN
                    AnforderunganGLEditable := FALSE;
                    cb_AnforderungFBEditable := FALSE;
                    PruefungKundenunterschriftEditable := FALSE;
                    PruefungextStammblattEditable := FALSE;
                    VerifikationUStIDEditable := FALSE;
                    AllgAngabenausStammblattEditable := FALSE;
                    KreditversicherungslimitEditable := FALSE;
                END ELSE
                    IF gc_POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN BEGIN
                        AnforderunganGLEditable := FALSE;
                        cb_AnforderungABWEditable := FALSE;
                    END;

            AuthentizitaetbekanntEditable := FALSE;
            AusnahmegenehmigungEditable := false;
            tb_AnforderungGLIDABWEditable := FALSE;
            tb_AnforderungGLIDFBEditable := FALSE;
            tb_AnforderungGLEditable := FALSE;
            AnforderunganGLDatumEditable := FALSE;
            tb_AnforderungGLDatumABWEditable := FALSE;
            tb_AnforderungGLDatumFBEditable := FALSE;
            tb_AnforderungGLDatumEditable := FALSE;
            IF NOT gc_POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
                VorkasseStatusEditable := FALSE;

            IF NOT gc_POIFunc.CheckUserInRole('QS_GL_VENDVERIFIKATW', 0) THEN BEGIN
                KontaktdatenhinterlegtEditable := TRUE;
                ZahlungskonditionenEditable := TRUE;
            END;
        END ELSE BEGIN
            //'GL_VENDVERIFIKAT_W'
            VerifikationAdresseEditable := FALSE;
            VerifikationGeschaeftstaetigkeitEditable := FALSE;
            VerifikationsanrufNameEditable := FALSE;
            VerifikationsanrufTelNrEditable := FALSE;
            VerifikationsanrufQuelleTelEditable := FALSE;
            VerifikationsanrufDatumUhrzeitEditable := FALSE;
            VerifikationsanrufUserEditable := FALSE;
            KontaktdatenhinterlegtEditable := FALSE;
            ZahlungskonditionenEditable := FALSE;
            SynchronizedEditable := FALSE;
            PurchaserEditable := FALSE;
            VorkasseerwuenschtEditable := FALSE;
            VorkasseStatusEditable := FALSE;
            GewuenschtesKreditEditable := FALSE;
            tb_GewuenschtesKreditVisible := FALSE;
            VorliegenvonCMREditable := FALSE;
            BlankobriefkopfEditable := FALSE;
            BlankobriefkopfUserIDEditable := FALSE;
            HandelsregisterauszugEditable := FALSE;
            HandelsregisterauszugUserIDEditable := FALSE;
            SteuernummervomFAEditable := FALSE;
            SteuernummervomFAUserIDEditable := FALSE;
            ExternesStammblattEditable := FALSE;
            ExternesStammblattUserIDEditable := FALSE;
            PruefungKundenunterschriftEditable := FALSE;
            KundenunterschriftUserIDEditable := FALSE;
            PruefungextStammblattEditable := FALSE;
            PruefungextStammblattUserIDEditable := FALSE;
            VerifikationUStIDEditable := FALSE;
            VerifikationUStIDUserIDEditable := FALSE;
            StammblattAblageEditable := FALSE;
            AllgAngabenausStammblattEditable := FALSE;
            StammblattAblageUserIDEditable := FALSE;
            AllgAngabenStammblattUserIDEditable := FALSE;
            KreditversicherungslimitEditable := FALSE;
            KreditversichLimitUserIDEditable := FALSE;
            KeinLieferantenfragebogenEditable := FALSE;
            StammblattnichtunterzeichnetEditable := FALSE;
            KeingueltigerGGAPZertifikatEditable := FALSE;
            KeinKonformerLaborberichtEditable := FALSE;
            KeinLFBgueltigbisEditable := FALSE;
            StammblattgueltigbisEditable := FALSE;
            GGAPZertifikatgueltigbisEditable := FALSE;
            KreditlimitintgueltigbisEditable := TRUE;

            IF "Internal credit limit" THEN BEGIN
                tb_GewuenschtesKreditVisible := FALSE;
                InternesKreditlimitEditable := TRUE;
            END ELSE BEGIN
                tb_GewuenschtesKreditVisible := TRUE;
                VorkasseStatusEditable := FALSE;
            END;

            IF "Anforderung an GL" THEN
                AnforderunganGLEditable := FALSE
            ELSE BEGIN
                AnforderunganGLEditable := FALSE;
                AnforderunganGLUserIDVisible := TRUE;
            END;

            tb_AnforderungGLIDABWEditable := FALSE;
            tb_AnforderungGLIDFBEditable := FALSE;
            tb_AnforderungGLEditable := FALSE;
            AnforderunganGLDatumEditable := FALSE;
            tb_AnforderungGLDatumABWEditable := FALSE;
            tb_AnforderungGLDatumFBEditable := FALSE;
            tb_AnforderungGLDatumEditable := FALSE;
            tb_AnforderungGLEditable := FALSE;

            IF (("Internal credit limit") AND ("Internes Kreditlimit" = 0)) THEN
                AusnahmegenehmigungEditable := FALSE
            ELSE
                AusnahmegenehmigungEditable := TRUE;

            cb_AnforderungABWEditable := FALSE;
            cb_AnforderungFBEditable := FALSE;
        END;

        IF gc_POIFunc.CheckUserInRole('FB_VENDVERIFIKAT_W', 0) THEN
            tb_GewuenschtesKreditVisible := TRUE;
    end;

    procedure DetailsMissing()
    begin
        IF gc_POIFunc.CheckUserInRole('GL_VENDVERIFIKAT_W', 0) THEN
            IF ("Internal credit limit") AND ("Internes Kreditlimit" = 0) THEN BEGIN
                "Internes Kreditlimit" := 0;
                "Credit limit int. valid until" := 0D;
            END;
    end;

    procedure GetNo(p_No: Code[20]; p_SourceType: enum "POI Source Type")
    begin
        g_No := p_No;
        g_sourceType := p_SourceType;
    end;

    trigger OnOpenPage()
    begin
        VerifikationAdresseEditable := true;
        VerifikationGeschaeftstaetigkeitEditable := true;
        VerifikationsanrufNameEditable := true;
        FBgewuenschtesKreditEditable := true;
        KreditversicherungslimitEditable := true;
        VorkasseStatusEditable := true;
        VerifikationsanrufTelNrEditable := true;
        VerifikationsanrufQuelleTelEditable := true;
        VorkasseerwuenschtEditable := true;
        GewuenschtesKreditEditable := true;
        tb_GewuenschtesKreditVisible := true;
        InternesKreditlimitEditable := true;
        AnforderunganGLEditable := true;
        AnforderunganGLUserIDVisible := true;
        tb_FBgewuenschtesKreditVisible := true;
        VerifikationsanrufEditable := true;
        cb_AnforderungABWEditable := true;
        cb_AnforderungFBEditable := true;
        AnforderunganGLUserIDEditable := true;
        VerzichtaufVerifikationEditable := true;
        KeinBlankobriefkopfEditable := true;
        KeinHandelsregisterauszugEditable := true;
        UnterschriftUebereinstimmungEditable := true;
        VorliegenvonCMREditable := true;
        BlankobriefkopfEditable := true;
        BlankobriefkopfUserIDEditable := true;
        HandelsregisterauszugEditable := true;
        HandelsregisterauszugUserIDEditable := true;
        SteuernummervomFAEditable := true;
        VerifikationUStIDEditable := true;
        SteuernummervomFAUserIDEditable := true;
        KundenunterschriftUserIDEditable := true;
        PruefungextStammblattUserIDEditable := true;
        VerifikationUStIDUserIDEditable := true;
        AllgAngabenStammblattUserIDEditable := true;
        KreditversichLimitUserIDEditable := true;
        KeinLieferantenfragebogenEditable := true;
        StammblattnichtunterzeichnetEditable := true;
        KeingueltigerGGAPZertifikatEditable := true;
        KeinKonformerLaborberichtEditable := true;
        KreditlimitinternEditable := true;
        KeinLFBgueltigbisEditable := true;
        StammblattgueltigbisEditable := true;
        GGAPZertifikatgueltigbisEditable := true;
        KreditlimitintgueltigbisEditable := true;
        KontaktdatenhinterlegtEditable := true;
        ZahlungskonditionenEditable := true;
        PruefungKundenunterschriftEditable := true;
        PruefungextStammblattEditable := true;
        AllgAngabenausStammblattEditable := true;
        SynchronizedEditable := true;
        PurchaserEditable := true;
        AuthentizitaetbekanntEditable := true;
        AusnahmegenehmigungEditable := true;
        tb_AnforderungGLIDABWEditable := true;
        tb_AnforderungGLIDFBEditable := true;
        tb_AnforderungGLEditable := true;
        AnforderunganGLDatumEditable := true;
        tb_AnforderungGLDatumABWEditable := true;
        tb_AnforderungGLDatumFBEditable := true;
        tb_AnforderungGLDatumEditable := true;
        VerifikationsanrufDatumUhrzeitEditable := true;
        VerifikationsanrufUserEditable := true;
        ExternesStammblattEditable := true;
        ExternesStammblattUserIDEditable := true;
        StammblattAblageEditable := true;
        StammblattAblageUserIDEditable := true;
        ///???CurrPage."Verifikation Adresse".ACTIVATE;

        // FILTERGROUP(2);
        // SETRANGE("No.", g_No);
        // SETRANGE("Source Type", g_SourceType);
        FILTERGROUP(0);

        // if CompanyName() <> POICompany.GetBasicCompany() then
        //     CurrPage.EDITABLE := FALSE;

        // lr_Qualitaetssicherung.GET(g_No, g_SourceType);

        IF NOT gc_POIFunc.UserInWindowsRole('HA_VENDVERIFIKAT_W') THEN
            IF NOT gc_POIFunc.UserInWindowsRole('ABW_VENDVERIFIKAT_W') THEN
                IF NOT gc_POIFunc.UserInWindowsRole('FB_VENDVERIFIKAT_W') THEN
                    IF NOT gc_POIFunc.UserInWindowsRole('QS_VENDVERIFIKAT_W') THEN
                        IF NOT gc_POIFunc.UserInWindowsRole('GL_VENDVERIFIKAT_W') THEN
                            CurrPage.EDITABLE := FALSE
                        ELSE
                            IF NOT (lr_Qualitaetssicherung."Freigabe für Kreditor") THEN BEGIN
                                g_CommentGL := FALSE;
                                g_CommentDEV := FALSE;
                                ActivateFirstFields();
                                ActivateFields();
                            END;

    end;

    trigger OnAfterGetRecord()
    begin
        if Ausnahmegenehmigung = Ausnahmegenehmigung::beantragt then
            AnfrageColor := 'Attention'
        else
            AnfrageColor := 'Standard';
    end;

    procedure ShowCaption(): text
    begin
        EXIT("No." + ' / ' + Name);
    end;


    var
        //POICompany: Record "POI Company";
        lr_Qualitaetssicherung: Record "POI Quality Management";
        lr_ContBusRel: Record "Contact Business Relation";
        WFGroup: Record "Workflow User Group";
        Mailsetup: Record "POI Mail Setup";
        POICompany: Record "POI Company";
        Salesperson: Record "Salesperson/Purchaser";
        SMTPMail: Codeunit "SMTP Mail";
        gc_POIFunc: Codeunit POIFunction;
        WFMgt: Codeunit "POI Workflow Management";
        TeamsMgt: Codeunit "POI Teams Management";
        g_No: Code[20];
        g_sourceType: enum "POI Source Type";
        UrlTxt: Text;
        AnfrageColor: Text[20];
        g_CommentGL: Boolean;
        g_CommentDEV: Boolean;
        VerifikationAdresseEditable: boolean;
        VerifikationGeschaeftstaetigkeitEditable: boolean;
        VerifikationsanrufNameEditable: Boolean;
        FBgewuenschtesKreditEditable: Boolean;
        KreditversicherungslimitEditable: Boolean;
        VorkasseStatusEditable: Boolean;
        VerifikationsanrufTelNrEditable: Boolean;
        VerifikationsanrufQuelleTelEditable: Boolean;
        VorkasseerwuenschtEditable: Boolean;
        GewuenschtesKreditEditable: Boolean;
        tb_GewuenschtesKreditVisible: Boolean;
        InternesKreditlimitEditable: Boolean;
        AnforderunganGLEditable: Boolean;
        AnforderunganGLUserIDVisible: Boolean;
        tb_FBgewuenschtesKreditVisible: Boolean;
        VerifikationsanrufEditable: Boolean;
        cb_AnforderungABWEditable: Boolean;
        cb_AnforderungFBEditable: Boolean;
        AnforderunganGLUserIDEditable: Boolean;
        VerzichtaufVerifikationEditable: Boolean;
        KeinBlankobriefkopfEditable: Boolean;
        KeinHandelsregisterauszugEditable: Boolean;
        UnterschriftUebereinstimmungEditable: Boolean;
        VorliegenvonCMREditable: Boolean;
        BlankobriefkopfEditable: Boolean;
        BlankobriefkopfUserIDEditable: Boolean;
        HandelsregisterauszugEditable: Boolean;
        HandelsregisterauszugUserIDEditable: Boolean;
        SteuernummervomFAEditable: Boolean;
        VerifikationUStIDEditable: Boolean;
        SteuernummervomFAUserIDEditable: Boolean;
        KundenunterschriftUserIDEditable: Boolean;
        PruefungextStammblattUserIDEditable: Boolean;
        VerifikationUStIDUserIDEditable: Boolean;
        AllgAngabenStammblattUserIDEditable: Boolean;
        KreditversichLimitUserIDEditable: Boolean;
        KeinLieferantenfragebogenEditable: Boolean;
        StammblattnichtunterzeichnetEditable: Boolean;
        KeingueltigerGGAPZertifikatEditable: Boolean;
        KeinKonformerLaborberichtEditable: Boolean;
        KreditlimitinternEditable: Boolean;
        KeinLFBgueltigbisEditable: Boolean;
        StammblattgueltigbisEditable: Boolean;
        GGAPZertifikatgueltigbisEditable: Boolean;
        KreditlimitintgueltigbisEditable: Boolean;
        KontaktdatenhinterlegtEditable: Boolean;
        ZahlungskonditionenEditable: Boolean;
        PruefungKundenunterschriftEditable: boolean;
        PruefungextStammblattEditable: boolean;
        AllgAngabenausStammblattEditable: boolean;
        SynchronizedEditable: boolean;
        PurchaserEditable: boolean;
        AuthentizitaetbekanntEditable: Boolean;
        AusnahmegenehmigungEditable: Boolean;
        tb_AnforderungGLIDABWEditable: Boolean;
        tb_AnforderungGLIDFBEditable: Boolean;
        tb_AnforderungGLEditable: Boolean;
        AnforderunganGLDatumEditable: Boolean;
        tb_AnforderungGLDatumABWEditable: Boolean;
        tb_AnforderungGLDatumFBEditable: Boolean;
        tb_AnforderungGLDatumEditable: Boolean;
        VerifikationsanrufDatumUhrzeitEditable: Boolean;
        VerifikationsanrufUserEditable: Boolean;
        ExternesStammblattEditable: boolean;
        ExternesStammblattUserIDEditable: boolean;
        StammblattAblageEditable: Boolean;
        StammblattAblageUserIDEditable: Boolean;
}