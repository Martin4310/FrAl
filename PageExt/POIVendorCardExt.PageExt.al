pageextension 50023 "POI Vendor Card Ext" extends "Vendor Card"
{

    PromotedActionCategories = 'Port';
    layout
    {
        addafter(Name)
        {
            field("POI Name 2"; "Name 2")
            {
                ApplicationArea = All;
                QuickEntry = false;
                ToolTip = ' ';
            }
        }

        addlast(General)
        {
            field("POI No. 2"; "POI No. 2")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Adv. Pay. Rem. Amount (LCY)"; "POI Adv. Pay. Rem.Amount (LCY)")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Sales Agent Code"; "POI Sales Agent Code")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Person in Charge Code"; "POI Person in Charge Code")
            {
                Caption = 'Sachbearbeiter';
                ApplicationArea = All;
                ToolTip = ' ';
                ShowMandatory = true;
            }

            field("POI Amtsgericht"; "POI Amtsgericht")
            {
                Caption = 'Registrierung HR';
                ApplicationArea = all;
                ToolTip = ' ';
            }
            field("POI Commercial Register No."; "POI Commercial Register No.")
            {
                Caption = 'Handelsregister-Nr.';
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = ' ';
                ShowMandatory = "POI Amtsgericht" = "POI Amtsgericht"::registered;
            }
            field("POI County Court"; "POI County Court")
            {
                Caption = 'Eintragungsort';
                ApplicationArea = All;
                Importance = Additional;
                ToolTip = ' ';
                ShowMandatory = "POI Amtsgericht" = "POI Amtsgericht"::registered;
            }
            field("POI Is Customer"; "POI Is Customer")
            {
                Caption = '= Debitor Nr.';
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Standard;
                ToolTip = ' ';
            }
            field("POI Vendor Group Code"; "POI Vendor Group Code")
            {
                ApplicationArea = All;
                Caption = 'Zugehörigkeit zu Gruppenkreditor';
                //Visible = false;
                ToolTip = ' ';
            }
            field("POI Group Vendor"; "POI Group Vendor")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }

            field("POI Purchases (LCY)"; "Purchases (LCY)")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Company System Filter"; "POI Company System Filter")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }

        addlast(Contact)
        {
            field("POI ILN"; "POI ILN")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Visible = false;
                ToolTip = ' ';
            }
        }
        //addlast(AddressDetails)
        addlast("Address & Contact")
        {
            group("POI Kreditorentyp")
            {
                Caption = 'Kreditorentyp';
                field("POI Supplier of Goods"; "POI Supplier of Goods")
                {
                    Caption = 'Warenlieferant';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Carrier"; "POI Carrier")
                {
                    Caption = 'Spediteur';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Shipping Company"; "POI Shipping Company")
                {
                    Caption = 'Reederei';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Air freight"; "POI Air freight")
                {
                    Caption = 'Luftfracht';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Warehouse Keeper"; "POI Warehouse Keeper")
                {
                    Caption = 'Lagerhalter';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Customs Agent"; "POI Customs Agent")
                {
                    Caption = 'Zollagent';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Tax Representative"; "POI Tax Representative")
                {
                    Caption = 'Fiskalvertreter';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }

                field("POI Diverse Vendor"; "POI Diverse Vendor")
                {
                    Caption = 'diverser Kreditor';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Small Vendor"; "POI Small Vendor")
                {
                    Caption = 'Kleinstkreditor (bis 1000 EUR)';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
        }
        addlast(Invoicing)
        {
            field("POI Vendor Main Group Code"; "POI Vendor Main Group Code")
            {
                visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Flo-ID"; "POI Flo-ID")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Visible = false;
                ToolTip = ' ';
            }
            // field("POI Create Balance Confirmation"; "POI Create Balance Confirm.")
            // {
            //     Caption = 'Erstelle Saldenbestätigung';
            //     ApplicationArea = All;
            //     Importance = Additional;
            // }
        }
        addafter(General)
        {
            part("POI CompanyAllocation"; "POI Account Company Setting")
            {
                Caption = 'Mandantenzuordnung';
                Editable = AccSettingEditable;
                ApplicationArea = Basic, Suite;
                SubPageLink = "Account No." = field("No."), "Account Type" = Const(Vendor), Visible = const(true);
                UpdatePropagation = Both;
            }
        }
        addlast(Payments)
        {
            group("POI Bankzahlungsangaben")
            {
                Caption = 'Bankzahlungsangaben';
                field("POI Direction Code"; "POI Direction Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    QuickEntry = false;
                    ToolTip = ' ';
                }
                field("POI Valutaangabe"; "POI Valutaangabe")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI No. Entries for Avis"; "POI No. Entries for Avis")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group("POI Vorauszahlung")
            {
                Caption = 'Vorauszahlung';
                field("POI Adv. Pay. Currency Code"; "POI Adv. Pay. Currency Code")
                {
                    Caption = 'Währungscode Vorauszahlung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Adv. Pay. Currency from Purch."; "POI Adv. Pay. Curr from Purch.")
                {
                    Caption = 'Währung Vorauszahlung aus EK';
                    ApplicationArea = All;
                    QuickEntry = false;
                    ToolTip = ' ';
                }
                field("POI Adv. Payment Receiver"; "POI Adv. Payment Receiver")
                {
                    Caption = 'Vorauszahlungsempfänger';
                    ApplicationArea = All;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(Page::"Vendor List");
                    end;
                }
                field("POI Adv. Payment Receiver No."; "POI Adv. Payment Receiver No.")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Adv. Payment Receiver Name"; "POI Adv. Payment Receiver Name")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group("POI Kreditversicherung")
            {
                Caption = 'Kreditversicherung';

                field("POI No Insurance"; "POI No Insurance")
                {
                    Caption = 'Kreditversicherung Ausschluss';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnValidate()
                    begin
                        SetCreditDataEdit(not "POI No Insurance");
                    end;
                }
                field("POI Credit Limit (LCY)"; "POI Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Credit Insurance No."; "POI Credit Insurance No.")
                {
                    Caption = 'Kreditornr. Erstversicherer';
                    ApplicationArea = All;
                    Editable = CreditInsNoFirstEditable;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(Page::"Vendor List");
                    end;
                }
                field("POI Easy No."; "POI Easy No.")
                {
                    ApplicationArea = all;
                    ToolTip = ' ';
                    Editable = EasyEditable;
                    ShowMandatory = true;
                }
                field("POI DRA"; "POI DRA")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = ' ';
                }
                field("POI Insurance credit limit"; "POI Insurance credit limit")
                {
                    Caption = 'Kreditlimit Erstversicherer';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = ' ';
                }
                field("POI ins. Cred. lim. val. until"; "POI ins. Cred. lim. val. until")
                {
                    Caption = 'Erstversichererlimit gültig bis';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = ' ';
                }
                field("POI Ins. No. Extra"; "POI Ins. No. Extra")
                {
                    Caption = 'Kreditornr. Zusatzversicherer';
                    ApplicationArea = All;
                    Editable = CreditinsNosecondEditable;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(Page::"Vendor List");
                    end;
                }
                field("POI Extra Limit"; "POI Extra Limit")
                {
                    Caption = 'Zusatzlimit Zusatzversicherer';
                    ApplicationArea = All;
                    Editable = CreditlimitSecondEditable;
                    Importance = Additional;
                    //Visible = false;
                    ToolTip = ' ';
                    trigger OnValidate()
                    var
                        Parameter: Record "POI Parameter";
                    begin
                        Parameter.Reset();
                        Parameter.SetRange("Source Type", Parameter."Source Type"::Vendor);
                        Parameter.SetRange("Source No.", "POI Ins. No. Extra");
                        Parameter.SetRange(Department, 'ZUSATZVERS');
                        if not Parameter.IsEmpty then
                            Error('manuelle Änderung bei Kreditversicherer Zusatz nicht erlaubt.');
                        SumCreditlimit();
                    end;
                }

                field("POI Cred. Ins. Type"; "POI Cred. Ins. Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }

                field("POI Kreditlimit"; "POI Kreditlimit")
                {
                    Caption = 'Kreditlimit gesamt';
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                    editable = false;
                }
                field("POI Credit limit Credit Ins."; "POI credit limit")
                {
                    Caption = 'Kreditlimit (Vorkasse)';
                    ApplicationArea = all;
                    Visible = false;
                    ToolTip = ' ';
                    Editable = false;
                    trigger OnValidate()
                    begin
                        SumCreditlimit()
                    end;
                }

                field("POI Extra Limit valid to"; "POI Extra Limit valid to")
                {
                    Caption = 'Zusatzlimit gültig bis';
                    ApplicationArea = All;
                    Editable = CreditlimitSecondEditable;
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = ' ';
                }
                field("POI Termin. Date Extra limit"; "POI Termin. Date Extra limit")
                {
                    Caption = 'Kündigungstermin Zusatzlimit';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI Kreditlimit intern"; "POI Kreditlimit intern")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                    ToolTip = ' ';
                    trigger OnValidate()
                    var
                        WFTaskNo: Integer;
                        WFGroupsList: list of [Text];
                        WFGroupCode: code[20];
                        UrlTxt: Text;
                        EMailSender: Text[100];
                        EMailReceiver: list of [Text];
                        Subject: Text[250];
                        MailBody: Text[400];
                    begin
                        if QM.Get("No.", QM."Source Type"::Vendor) then begin
                            QM.Ausnahmegenehmigung := QM.Ausnahmegenehmigung::beantragt;
                            QM.Modify();
                        end;
                        AccountCompanySetting.Get(AccountCompanySetting."Account Type"::Vendor, "No.", CompanyName());
                        AccountCompanySetting."Credit Limit" := "POI Kreditlimit intern";
                        AccountCompanySetting."Creditlimit requested" := false;
                        AccountCompanySetting.Modify();
                        QMDetails.SetRange("No.", "No.");
                        QMDetails.SetRange("Source Type", QMDetails."Source Type"::Vendor);
                        QMDetails.SetRange(Mandant, CompanyName());
                        if QMDetails.FindFirst() then begin
                            QMDetails."Credit Limit" := "POI Kreditlimit intern";
                            QMDetails."Credit Limit Approved" := false;
                            QMDetails."Credit Limit Valid To" := 0D;
                            QMDetails.modify();
                        end;
                        "POI Kreditlimit intern" := 0;
                        SumCreditlimit();
                        if QM.Get("No.", QM."Source Type"::Vendor) then begin
                            WFTaskNo := WFMgt.TaskCreateAccount(QM.RecordId, 'Vorkasselimit geändert', 'VORKASSELIMIT', "No.", copystr(CompanyName(), 1, 50));
                            //Nachrichtenversand Teams oder E-Mail
                            WFMgt.GetTeamsFromgroup(WFTaskNo, WFGroupsList);
                            foreach WFGroupCode IN WFGroupslist do begin
                                WFGroups.ChangeCompany(AccountCompanySetting."Company Name");
                                if WFGroups.Get(WFGroupCode) then
                                    Case WFGroups.Infochannel of
                                        WFGroups.Infochannel::Teams:
                                            begin
                                                //Versand per Teams
                                                UrlTxt := TeamsMgt.CreateTeamsUrlVorkasse(QM.RecordId, copystr(CompanyName(), 1, 50));
                                                TeamsMgt.SendMessageToTeams(UrlTxt, WFGroupCode);
                                            end;
                                        WFGroups.Infochannel::"E-Mail":
                                            begin
                                                //Versand per Mail
                                                MailSenderReceiver.GetMailSenderReceiver('WF', 'VORKASSELIMIT', EMailSender, EMailReceiver, AccountCompanySetting."Company Name");
                                                Subject := strsubstno('Kreditor %1 im Mandant %2 Vorkasselimit für Workflowgruppe %3', "No.", AccountCompanySetting."Company Name", WFGroups.Code);
                                                MailBody := strsubstno('Das Vorkasselimit für Kreditor %1 %2 für Mandant %3 wurde geändert.', "No.", Name, AccountCompanySetting."Company Name");
                                                MailBody += '<p style="font-family:Arial";style="color:red;style="font-size:30px">Link zum <a href=' + System.GetUrl(ClientType::Web, CompanyName(), ObjectType::Page, Page::"Vendor Card", Rec, false) + '>[Kreditor]</a>';
                                                if (EMailReceiver.Count > 0) and (EMailSender <> '') then begin
                                                    SMTPMail.CreateMessage('Workflowaufgabe', EMailSender, EMailReceiver, Subject, Mailbody);
                                                    SMTPMail.Send();
                                                end;
                                            end;
                                    end;
                            end;
                            //Ende versand
                        end;
                    end;
                }
                field("POI Credit limit int. valid until"; "POI Cred. limit int. val.until")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                    Importance = Additional;
                    Editable = false;
                    ;
                    ToolTip = ' ';
                }
                // field("POI Group Credit Limit"; "POI Group Credit Limit")
                // {
                //     Caption = 'Gruppenkreditlimit';
                //     ApplicationArea = All;
                //     Editable = CreditlimitFirstEditable;
                //     ToolTip = ' ';
                // }
                // field("POI ins. Group Credit Limit"; "POI ins. Group Credit Limit")
                // {
                //     Caption = 'versichertes Gruppenkreditlimit';
                //     ApplicationArea = All;
                //     Editable = CreditlimitFirstEditable;
                //     ToolTip = ' ';
                // }
                // field("POI Group Use"; "POI Group Use")
                // {
                //     Caption = 'Gruppeninanspruchnahme';
                //     ApplicationArea = All;
                //     Editable = CreditlimitFirstEditable;
                //     ToolTip = ' ';
                // }
            }
        }
        addafter("Location Code")
        {
            field("POI Departure Region Code"; "POI Departure Region Code")
            {
                Caption = 'Abgangregion Code';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter("Shipment Method Code")
        {
            field("POI Appendix Shipment Method"; "POI Appendix Shipment Method")
            {
                Caption = 'Zusatz Lieferbedingung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addlast(Receiving)
        {
            field("POI No. of Order Addresses"; "No. of Order Addresses")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = ' ';
            }
            field("POI Country of Origin Code"; "POI Country of Origin Code")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = ' ';
            }
            field("POI Empties Allocation"; "POI Empties Allocation")
            {
                caption = 'Leergutverrechnung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Empties Calculation"; "POI Empties Calculation")
            {
                Caption = 'Leergutberechnung';
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI A.S. Refund to Vendor No."; "POI A.S. Refund to Vendor No.")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Quality Control Vendor No."; "POI Quality Control Vendor No.")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Certificate Control Board Code"; "POI Certif. Control Board Code")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Certificate No."; "POI Certificate No.")
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addlast("Foreign Trade")
        {
            field("POI Fiscal Agent"; "POI Fiscal Agent")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        addafter(Receiving)
        {
            group("POI Abrechnung")
            {
                Caption = 'Abrechnung / Entsorgung / Pfand';

                field("POI A.S. Kind of Settlement"; "POI A.S. Kind of Settlement")
                {
                    Caption = 'Abr. Abrechnungsart';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI A.S. Mode of Calculation"; "POI A.S. Mode of Calculation")
                {
                    Caption = 'Abr. Berechnungsart';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI A.S. Cost Schema Name Code"; "POI A.S. Cost Schema Name Code")
                {
                    Caption = 'Abr. Kostenschemaname Code';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI A.S. Kind of Sales Statement"; "POI A.S. Kind of Sales Statemt")
                {
                    Caption = 'Abr. Art der Meldung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI A.S. Turnover Reducing Cost"; "POI A.S. Turnover Reduc. Cost")
                {
                    Caption = 'Abr. Erlösmindernde Kosten';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI A.S. Refund Percentage"; "POI A.S. Refund Percentage")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI A.S. Cost Splitting"; "POI A.S. Cost Splitting")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI A.S. Commission Base"; "POI A.S. Commission Base")
                {
                    Caption = 'Abr. Kommission Basis';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI A.S. Commission Fee %"; "POI A.S. Commission Fee %")
                {
                    Caption = 'Abr. Kommission Prozentsatz';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("POI RefundSet"; "POI RefundSet")
                {
                    ApplicationArea = All;
                    ToolTip = 'Rechnungsrabatte und Zeilenrabatte sind unter Rechnungsrabatte und Zeilenrabatte einzugeben. Dies sind keine Rückvergütungen';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        Refunds: Record "POI Account Refunds";
                        Refundspg: Page "POI Account Refunds List";
                    begin
                        Refunds.SetRange("No.", "No.");
                        Refunds.SetRange("Source Type", Refunds."Source Type"::Vendor);
                        //Refundspg.setItemNo("No.");
                        Refundspg.SetTableView(Refunds);
                        Refundspg.Run();
                    end;
                }
                group("POI Entsorgung")
                {
                    Caption = 'Entsorgung';
                    field("POI Waste Disposal Duty"; "POI Waste Disposal Duty")
                    {
                        Caption = 'Entsorgungspflicht';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Waste Disposal Payment Thru"; "POI Waste Disposal Paymt Thru")
                    {
                        Caption = 'Entsorgungszahlung durch';
                        ApplicationArea = All;
                        ToolTip = ' ';
                    }
                    field("POI Subtract W.D. from Turnover"; "POI Subtract W.D. fr Turnover")
                    {
                        ApplicationArea = All;
                        Visible = false;
                        ToolTip = ' ';
                    }
                }
                field("POI Member of Prod. Companionship"; "POI Member of Prod.Companionsh")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
                field("POI Member State Companionship"; "POI Member State Companionship")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = ' ';
                }
            }
        }

        moveafter("POI Name 2"; Address)
        moveafter(Address; "Address 2")
        moveafter("Address 2"; City)
        moveafter(City; "Post Code")
        moveafter("Post Code"; "Country/Region Code")
        moveafter("Country/Region Code"; ShowMap)
        movefirst("Posting Details"; "Tax Liable")
        moveafter("Tax Liable"; "Tax Area Code")
        addafter(ShowMap)
        {
            field(POIVATRegistrationNos; POIVATRegistrationNos)
            {
                Caption = 'UST-Id Nr.';
                ToolTip = ' ';
                Editable = false;
                StyleExpr = color;

                trigger OnDrillDown()
                var
                    VendorCustUstID: Record "POI VAT Registr. No. Vend/Cust";
                    VendorCustUstIDpg: Page "POI VAT Registr. No. Vend/Cust";
                    VendorCustType: enum "POI VendorCustomer";
                begin
                    VendorCustUstID.SetRange("Vendor/Customer", "No.");
                    VendorCustUstID.SetRange(Type, VendorCustUstID.Type::Vendor);
                    VendorCustUstIDpg.setItemNo("No.", VendorCustType::Vendor);
                    VendorCustUstIDpg.SetTableView(VendorCustUstID);
                    VendorCustUstIDpg.Run();
                end;
            }
            field("POI Registration No."; "Registration No.")
            {
                Caption = 'Steuernummer';
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }


        movefirst("POI Bankzahlungsangaben"; "Payment Method Code")
        addafter("Payment Method Code")
        {
            field("POI Port Bank Account"; "POI Port Bank Account")
            {
                Caption = 'Port Lastschriftkonto';
                ApplicationArea = All;
                ToolTip = 'Bakkonto von Port für welches das Sepa Mandat gilt.';
                Editable = SepaEditable;
            }
            field("POI Reic assigned to factoring"; "POI Reic assigned to factoring")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
            field("POI Factoring Company"; "POI Factoring Company")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                ShowMandatory = "POI Reic assigned to factoring";
                trigger OnLookup(var Text: Text): Boolean
                begin
                    Page.RunModal(Page::"Vendor List");
                end;
            }

        }
        moveafter("Language Code"; "Document Sending Profile")
        moveafter("Partner Type"; "Currency Code")
        moveafter("POI Group Vendor"; "Search Name")

        addafter("Search Name")
        {
            field("POI Old Vendor No."; "POI Old Vendor No.")
            {
                ApplicationArea = All;
                QuickEntry = false;
                Importance = Additional;
                ToolTip = ' ';
            }
        }

        moveafter("POI Old Vendor No."; "Our Account No.")

        addafter("Our Account No.")
        {
            field(Comment; Comment)
            {
                ApplicationArea = All;
                QuickEntry = false;
                ToolTip = ' ';
            }
        }
        moveafter(Comment; "Last Date Modified")
        //moveafter("Last Date Modified"; Blocked)
        addafter("Last Date Modified")
        {
            field("POI Special Vendor Nos."; "POI Special Vendor Nos.")
            {
                Caption = 'Kreditoren ID Nr.';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnDrillDown()
                var
                    AccountSpecialNos: Record "POI Account No. Special";
                    AccspecialNospage: page "POI Account Special No.";
                begin
                    AccountSpecialNos.SetRange(AccountType, AccountSpecialNos.AccountType::Vendor);
                    AccountSpecialNos.SetRange("Account No.", "No.");
                    AccspecialNospage.SetTableView(AccountSpecialNos);
                    AccspecialNospage.Run();
                end;
            }
        }
        moveafter("POI Special Vendor Nos."; Blocked)
        addafter("Prices Including VAT")
        {
            field("POI Credit note procedure"; "POI Credit note procedure")
            {
                ApplicationArea = All;
                ToolTip = ' ';
            }
        }
        moveafter("Fax No."; "Home Page")


        modify("VAT Bus. Posting Group")
        {
            Importance = Standard;
            ShowMandatory = true;
        }
        modify("Pay-to Vendor No.")
        {
            Importance = Standard;
        }
        modify("Invoice Disc. Code")
        {
            Importance = Standard;
        }
        modify(Priority)
        {
            Visible = false;
        }
        modify("Partner Type")
        {
            Visible = false;
        }
        modify("Prepayment %")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Importance = Standard;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("Cash Flow Payment Terms Code")
        {
            Visible = false;
        }
        modify("Base Calendar Code")
        {
            Visible = false;
        }
        modify("Customized Calendar")
        {
            Visible = false;
        }

        modify("Privacy Blocked")
        {
            Visible = false;
        }

        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify("Disable Search by Name")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("IC Partner Code")
        {
            Visible = false;
        }
        // modify("Home Page")
        // {
        //     Visible = false;
        // }
        modify("Primary Contact No.")
        {
            Visible = false;
        }
        //Kreditorenbild als Factbox löschen/ausblenden
        modify(Control82)
        {
            Visible = false;
        }
        modify("VAT Registration No.")
        {
            Importance = Additional;
            Visible = false;
        }
        modify(Blocked)
        {
            Importance = Promoted;
            QuickEntry = false;
            Editable = false;
            trigger OnBeforeValidate()
            begin
                if not RecordEditable and (Blocked <> Blocked::All) then
                    Error('Datensatz ist gesperrt (Workflow!');
            end;
        }
        modify("Our Account No.")
        {
            Caption = 'Unsere Kundennr.';
            QuickEntry = false;
            Importance = Additional;
        }
        modify("Address 2")
        {
            QuickEntry = false;
        }
        modify("Purchaser Code")
        {
            caption = 'Einkäufer';
            ShowMandatory = true;
            trigger OnLookup()
            var
                lr_SalesPurch: Record "Salesperson/Purchaser";
            begin
                IF COMPANYNAME() = POICompany.GetBasicCompany() THEN
                    ERROR(ERR_NoBasicCompanyTxt);

                lr_SalesPurch.FILTERGROUP(2);
                lr_SalesPurch.SETRANGE("POI Is Purchaser", TRUE);
                lr_SalesPurch.FILTERGROUP(0);
                IF Page.RUNMODAL(0, lr_SalesPurch) = ACTION::LookupOK THEN
                    VALIDATE("POI Person in Charge Code", lr_SalesPurch.Code);
            end;
        }
        modify("Last Date Modified")
        {
            QuickEntry = false;
        }
        modify("Application Method")
        {
            Visible = false;
            QuickEntry = false;
            Importance = Additional;
            ShowMandatory = true;
        }
        modify("Payment Terms Code")
        {
            Caption = 'Zahlungsfrist Code';
            Importance = Standard;
            ShowMandatory = true;
        }
        modify("Block Payment Tolerance")
        {
            QuickEntry = false;
        }
        modify("Preferred Bank Account Code")
        {
            QuickEntry = false;
            ShowMandatory = true;
        }
        modify("Payment Method Code")
        {
            QuickEntry = false;
            ShowMandatory = true;
            trigger OnAfterValidate()
            begin
                CheckSepa(true);
                SepaEditable := ("Payment Method Code" IN ['SEPA', 'SEPA-I', 'SEPA-EILIG']);
                CurrPage.Update();
            end;
        }
        modify(GLN)
        {
            Visible = false;
        }

        modify("No.")
        {
            Importance = Promoted;
        }
        modify(Name)
        {
            Importance = Standard;
            Visible = true;
            trigger OnBeforeValidate()
            begin
                if not POIFunction.CheckPermission(23, FieldNo(Name), 2) then
                    Error(NoPermissionTxt);
            end;
        }
        modify("Search Name")
        {
            Editable = false;
        }
        modify("Language Code")
        {
            Importance = Standard;
        }
        modify(Control16)
        {
            Importance = Additional;
            Visible = false;
        }
        modify("Prices Including VAT")
        {
            Importance = Standard;
        }
        modify("Address & Contact")
        {
            CaptionML = DEU = 'Unternehmenskontakt und Kreditorentyp';
        }
        modify(AddressDetails)
        {
            CaptionML = DEU = ' ';
        }
        modify(Payments)
        {
            CaptionML = DEU = 'Zahlungen / Kreditversicherung';
        }
        modify(Invoicing)
        {
            CaptionML = DEU = 'Fakturierung / Steuercodes /Aussenhandel';
            //Caption = 'Fakturierung / Steuercodes /Aussenhandel';
        }
        modify(Receiving)
        {
            CaptionML = DEU = 'Lieferung/Pfand';
        }
        modify("Registration No.")
        {
            Visible = false;
        }
        addafter("Invoice Disc. Code")
        {
            field("POI Inv. Disc. Percent"; InvDiscountPercent)
            {
                Caption = 'Rechnungsrabatt in Prozent';
                Editable = false;
                ToolTip = ' ';
            }
        }
        modify("Currency Code")
        {
            ShowMandatory = true;
        }
        modify(City)
        {
            trigger OnLookup(var Text: Text): Boolean
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
                POISynchFunction.SynchVendCustGroupVendor(FieldNo(City), "No.", "POI Is Customer", "POI Vendor Group Code", City, true, false, true, true, false, true);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Post Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Post Code", true, false, true, true, false, true);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Country/Region Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Country/Region Code", true, false, true, true, false, true);
            end;
        }
        modify("Post Code")
        {
            trigger OnLookup(var Text: Text): Boolean
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Post Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Post Code", true, false, true, true, false, true);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo(City), "No.", "POI Is Customer", "POI Vendor Group Code", City, true, false, true, true, false, true);
                POISynchFunction.SynchVendCustGroupVendor(FieldNo("Country/Region Code"), "No.", "POI Is Customer", "POI Vendor Group Code", "Country/Region Code", true, false, true, true, false, true);
            end;
        }
    }
    actions
    {
        modify(ApplyTemplate)
        {
            Visible = false;
        }
        addlast(Processing)
        {
            action("POI VAT ID Vendor")
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                Image = VATEntries;
                Caption = 'Ust.-IDs';
                RunPageMode = View;
                RunObject = page "POI VAT Registr. No. Vend/Cust";
                RunPageLink = "Vendor/Customer" = field("No."), Type = const(2);
                ToolTip = ' ';
            }
            action("Check Vendor")
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = All;
                Image = Check;
                Caption = 'Kreditor prüfen';
                ToolTip = ' ';
                trigger OnAction()
                var
                    POIQSAccFunction: Codeunit "POI QS Account Function";
                begin
                    POIQSAccFunction.CheckQSAccount("No.");
                end;
            }
            // action("Mail To old Vendor")
            // {
            //     Image = PostMail;
            //     Caption = 'Aktualisierungsanfrage Dokumente an Alt Kreditor';
            //     ToolTip = ' ';
            //     trigger OnAction()
            //     var
            //         POIQSFunction: Codeunit "POI QS Functions";
            //     begin
            //         POIQSFunction.MailToOldVendor(Rec);
            //     end;
            // }
            action("Create Customer from Vendor")
            {
                Image = Create;
                Promoted = true;
                PromotedIsBig = true;
                Caption = 'Debitor aus Kreditor anlegen';
                ToolTip = ' ';
                trigger OnAction()
                var
                    POIFunction: Codeunit POIFunction;
                    newType: Integer;
                begin
                    if "POI Vendor Group Code" <> '' then
                        if Vendor2.Get("POI Vendor Group Code") and (Vendor2."POI Is Customer" = '') then begin
                            newType := StrMenu('Warenkunde,Servicekunde', 1, 'Bitte die Kundenart für Gruppendebitor auswählen');
                            if newType = 0 then begin
                                Vendor2."POI Is Customer" := POIFunction.CopyIsCustomerVendor(Vendor2."No.", 0, newType);
                                Vendor2.Modify();
                            end;
                        end;

                    newType := StrMenu('Warenkunde,Servicekunde', 1, 'Bitte die Kundenart auswählen');
                    if newType = 0 then
                        "POI Is Customer" := POIFunction.CopyIsCustomerVendor("No.", 0, newType);
                end;
            }
            action("Creditcontract Data")
            {
                Caption = 'Kreditversicherungsdaten';
                Image = FileContract;
                RunObject = page "POI Creditcontract Account";
                RunPageLink = "Easy No." = field("POI Easy No.");
                ToolTip = ' ';
                Promoted = true;
                PromotedIsBig = true;
            }
            action("Contracts")
            {
                Caption = 'Vertragsliste';
                Image = FileContract;
                ApplicationArea = all;
                RunObject = page "POI Contract Data List";
                RunPageLink = "Vendor No." = field("No.");
                ToolTip = ' ';
                Promoted = true;
                PromotedIsBig = true;
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
                PromotedIsBig = true;
            }
            action(ShowWF)
            {
                Caption = 'Workflowaufgaben anzeigen';
                ApplicationArea = All;
                Image = Workflow;
                ToolTip = ' ';
                Promoted = true;
                PromotedIsBig = true;
                trigger OnAction()
                begin
                    ShowWorkflowForVendor();
                end;
            }
            action(ShowComments)
            {
                Caption = 'Bemerkungen';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    CommentLine: Record "Comment Line";
                    Customer: Record Customer;
                    CommentLinePg: Page "Comment List";
                begin
                    if "POI Is Customer" <> '' then
                        Customer.Get("POI Is Customer");
                    CommentLine.FilterGroup(2);
                    CommentLine.SetFilter("Table Name", '%1|%2', CommentLine."Table Name"::Customer, CommentLine."Table Name"::Vendor);
                    CommentLine.SetFilter("No.", '%1|%2|%3|%4', "No.", "POI Is Customer", "POI Vendor Group Code", Customer."POI Group Customer");
                    CommentLinePg.SetTableView(CommentLine);
                    CommentLinePg.Run();
                end;
            }
        }
        moveafter(Zertifizierungen; OrderAddresses)
        moveafter(OrderAddresses; "Invoice &Discounts")
        modify(OrderAddresses)
        {
            Promoted = true;
            PromotedIsBig = true;
        }
        modify("Invoice &Discounts")
        {
            Promoted = true;
            PromotedIsBig = true;
        }

        modify(NewPurchaseInvoice)
        {
            Promoted = false;
        }
        modify(NewPurchaseCrMemo)
        {
            Promoted = false;
        }
    }


    procedure SetCreditDataEdit(Set: Boolean)
    begin
        EasyEditable := set;
        CreditInsNoFirstEditable := Set;
        CreditinsNosecondEditable := Set;
        creditlimitfirstEditable := Set;
        CreditlimitinternEditable := Set;
        CreditlimitSecondEditable := Set;
        DRAEditable := Set;
    end;

    procedure CheckSepa(Msg: Boolean)
    begin
        if ("Payment Method Code" IN ['SEPA', 'SEPA-I', 'SEPA-EILIG']) and ("POI Port Bank Account" = '') then
            case Msg of
                true:
                    Message('Port Bankkonto für Sepa angeben.');
                false:
                    Error('Port Bankkonto für Sepa angeben.');
            end;
    end;

    procedure ShowWorkflowForVendor()
    var
        WFPG: Page "POI Workflow Task List";
    begin
        Clear(WFPG);
        WFTask.Reset();
        WFTask.setrange("Account Code", "No.");
        WFTask.SetFilter(Status, '<>%1', WFTask.Status::Approved);
        if WFTask.FindSet() then begin
            WFPG.SetTableView(WFTask);
            WFPG.Run();
        end else
            Message('Keine unbearbeiteten Workflowaufgaben vorhanden.');
    end;

    trigger OnOpenPage()
    var
        filterstring: Text[50];
    begin
        if uppercase(CompanyName()) <> uppercase(POIFunction.GetBasicCompany()) then begin
            POICompany.Get(CompanyName());
            FilterGroup(2);
            filterstring := StrSubstNo('*%1*', POICompany."Company System ID");
            SetFilter("POI Company System Filter", filterstring);
            AccSettingEditable := false;
        end else
            AccSettingEditable := true;


    end;

    trigger OnAfterGetRecord()
    var
        AccCompSetting: Record "POI Account Company Setting";
        RestrictedRecord: Record "Restricted Record";
    begin
        SetCreditDataEdit(not "POI No Insurance");
        VendInvDisc.SetRange(Code, "Invoice Disc. Code");
        VendInvDisc.SetFilter("Currency Code", '%1|%2', '', 'EUR');
        if VendInvDisc.FindFirst() then
            InvDiscountPercent := VendInvDisc."Discount %"
        else
            InvDiscountPercent := 0;
        AccCompSetting.SetAccCompSetting("No.", AccCompSetting."Account Type"::Vendor);
        RestrictedRecord.Reset();
        RestrictedRecord.SetRange("Record ID", RecordId);
        if not RestrictedRecord.IsEmpty() then
            RecordEditable := False
        else
            RecordEditable := true;
        SepaEditable := ("Payment Method Code" IN ['SEPA', 'SEPA-I', 'SEPA-EILIG']);
        Color := CheckVatIDValidation(rec);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('Kein Edit');
    end;

    trigger OnClosePage()
    var
        AccCompSetting: Record "POI Account Company Setting";
    begin
        AccCompSetting.SetAccCompSetting("No.", AccCompSetting."Account Type"::Vendor);
        CheckSepa(false);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CheckSepa(false);

    end;

    var
        VendInvDisc: Record "Vendor Invoice Disc.";
        PostCode: Record "Post Code";
        WFTask: Record "POI Workflow Task";
        QM: Record "POI Quality Management";
        AccountCompanySetting: Record "POI Account Company Setting";
        QMDetails: Record "POI Quality Mgt Detail";
        WFGroups: Record "Workflow User Group";
        MailSenderReceiver: Record "POI Mail Setup";
        Vendor2: Record Vendor;
        POICompany: Record "POI Company";
        POISynchFunction: Codeunit "POI Account Synchronisation";
        WFMgt: Codeunit "POI Workflow Management";
        TeamsMgt: Codeunit "POI Teams Management";
        SMTPMail: Codeunit "SMTP Mail";
        POIFunction: Codeunit POIFunction;
        Color: text[20];
        InvDiscountPercent: Decimal;
        AccSettingEditable: Boolean;
        EasyEditable: Boolean;
        DRAEditable: Boolean;
        creditlimitfirstEditable: Boolean;
        CreditinsNosecondEditable: Boolean;
        CreditlimitSecondEditable: Boolean;
        CreditlimitinternEditable: Boolean;
        CreditInsNoFirstEditable: Boolean;
        RecordEditable: Boolean;
        SepaEditable: Boolean;
        NoPermissionTxt: Label 'Keine Berechtigung zum Ändern.';
        ERR_NoBasicCompanyTxt: label 'Bitte im operativen Mandanten ausführen.';
}