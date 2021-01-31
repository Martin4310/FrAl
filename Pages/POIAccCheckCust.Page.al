page 50074 "POI Acc Check Cust"
{
    Caption = 'Geschäftspartner Debitor prüfen';
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
                grid(LFB)
                {
                    label(LFBLabel)
                    {
                        Caption = 'An den Debitor versendete Dokumente';
                    }
                    field("LFB Version"; "LFB Version")
                    {
                        Caption = 'An den Debitor versendete Dokumente';
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
                        ShowCaption = false;
                    }
                    field("Steuernummer vom FA UserID"; "Steuernummer vom FA UserID")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
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
                        ShowCaption = false;
                    }
                    field("Externes Stammblatt UserID"; "Prüfung ext. Stammblatt UserID")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
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
                        ShowCaption = false;
                    }
                    field("Handelsregisterauszug UserID"; "Handelsregisterauszug UserID")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
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
                        ShowCaption = false;
                    }
                }
                grid(zahlung)
                {
                    label(Zahlunglabel)
                    {
                        Caption = 'Zahlungskonditionen/Rückvergütungen und Bankverbindung entsprechend Debitorenstammblatt sind in den BC Stammdaten hinterlegt';
                    }
                    field(Zahlungskonditionen; Zahlungskonditionen)
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(Purchasergrid)
                {
                    label(PurchaserLabel)
                    {
                        Caption = 'Verkäufer und Sachbearbeiter sind in allen aktiven Mandanten hinterlegt.';
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
                grid(Shipmentgrid)
                {
                    label(Shipmentlabel)
                    {
                        Caption = 'Lieferanschriften sind angelegt';
                    }
                    field("Shipment Address exists"; "Shipment Address exists")
                    {
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }

                // grid(CMR)
                // {
                //     label(CMRLabel)
                //     {
                //         Caption = 'CMR-Versicherungspolice ist archiviert';
                //     }
                //     field("Vorliegen von CMR"; "Vorliegen von CMR")
                //     {
                //         Caption = ' ';
                //         ApplicationArea = All;
                //         ToolTip = ' ';
                //         ShowCaption = false;
                //     }
                // }

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
                        ShowCaption = false;
                    }
                    field("Kundenunterschrift UserID"; "Kundenunterschrift UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
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
                        ShowCaption = false;
                    }
                    field("Prüfung ext. Stammblatt UserID"; "Prüfung ext. Stammblatt UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
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
                        ShowCaption = false;
                    }
                    field("Verifikation USt-ID UserID"; "Verifikation USt-ID UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
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
                        ShowCaption = false;
                    }
                    field("Allg Angaben Stammblatt UserID"; "Allg Angaben Stammblatt UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
                grid(AblageAusdrucke)
                {
                    label(AblageLabel)
                    {
                        Caption = 'unterzeichnetes Debitorenstammblatt, Beispielbriefkopf,Handelsregisterauszug/Auskunft sind archiviert.';
                    }
                    field("Stammblatt Ablage"; "Stammblatt Ablage")
                    {
                        Caption = ' ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                    field("Stammblatt Ablage UserID"; "Stammblatt Ablage UserID")
                    {
                        ShowCaption = false;
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                }
            }
            group(Qualitätsmanagement)
            {

                // label(QSlbl)
                // {
                //     Caption = 'QM Daten sind vollständig in der QM Maske erfasst und unterzeichnete Dokumente archiviert.';
                // }
                // field(QS; QS)
                // {
                //     ApplicationArea = all;
                //     ToolTip = ' ';
                //     ShowCaption = false;
                // }
                grid(CustReqGrid)
                {
                    label(CustReqlbl)
                    {
                        Caption = 'Kundenanforderungen wurden im System hinterlegt ';
                    }

                    field("Customer Requirements"; "Customer Requirements")
                    {
                        Caption = 'Kundenanforderungen wurden im System hinterlegt ';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
                grid(CustnoReqGrid)
                {
                    label(CustnoReqlbl)
                    {
                        Caption = 'Debitor hat keine Anforderungen übermittelt.';
                    }
                    field("No Customer Requirements"; "No Customer Requirements")
                    {
                        Caption = 'Debitor hat keine Anforderungen übermittelt.';
                        ApplicationArea = All;
                        ToolTip = ' ';
                        ShowCaption = false;
                    }
                }
            }

            part("POI Account Check Det Cust"; "POI Account Check Det Cust")
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

    trigger OnOpenPage()
    begin
        SetRange("Source Type", "Source Type"::Customer);
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

        WFGroup: Record "Workflow User Group";
        Mailsetup: Record "POI Mail Setup";
        POICompany: Record "POI Company";
        Salesperson: Record "Salesperson/Purchaser";
        SMTPMail: Codeunit "SMTP Mail";
        WFMgt: Codeunit "POI Workflow Management";
        TeamsMgt: Codeunit "POI Teams Management";

        UrlTxt: Text;
        AnfrageColor: Text[20];


}