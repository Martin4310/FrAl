page 50002 "POI Create Account"
{
    //Caption = 'Create Account';
    Caption = 'neuer Geschäftspartner';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Contact;
    SourceTableTemporary = true;
    DataCaptionExpression = '';
    //InsertAllowed = false;
    //DeleteAllowed = false;
    PromotedActionCategories = 'Geschäftspartner';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Allgemein';
                field("Account Type"; "POI VendororCustomer")
                {
                    Caption = 'Geschäftspartnertyp';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = ' ';
                    ValuesAllowed = 1, 2;
                }
                field("Salutation Code"; AccSalutation)
                {
                    Caption = 'Anrede';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    TableRelation = Salutation.Code;
                    ToolTip = ' ';
                }

                field(Name; Name)
                {
                    Caption = 'Firmenname';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = ' ';
                }
                field("Name 2"; "Name 2")
                {
                    Caption = 'Firmenname 2';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Address; Address)
                {
                    Caption = 'Strasse/Hausnr.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = ' ';
                }
                field("Address 2"; "Address 2")
                {
                    Caption = 'Adresszusatz';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Post Code"; "Post Code")
                {
                    Caption = 'PLZ';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = ' ';
                }
                field(City; City)
                {
                    Caption = 'Ort';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = ' ';
                }

                field(Country; "Country/Region Code")
                {
                    Caption = 'Land';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    TableRelation = "Country/Region".Code;
                    ToolTip = ' ';
                    trigger OnValidate()
                    var
                        Country: Record "Country/Region";
                    begin
                        IF Country.Get("Country/Region Code") then
                            "Language Code" := Country."POI Language";
                    end;
                }
                field("Home Page"; "Home Page")
                {
                    Caption = 'Homepage';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("E-Mail"; "E-Mail")
                {
                    Caption = 'E-Mail';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = ' ';
                }
                field(Phone; "Phone No.")
                {
                    Caption = 'Tel.';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = ' ';
                }
                field("Fax No."; "Fax No.")
                {
                    Caption = 'Fax';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Language; "Language Code")
                {
                    Caption = 'Sprache';
                    ApplicationArea = All;
                    ShowMandatory = true;
                    TableRelation = Language.Code;
                    ToolTip = ' ';
                }
            }
            group("Creditor Type")
            {
                Caption = 'Kreditorentyp';
                Visible = "POI VendororCustomer" = "POI VendororCustomer"::Vendor;
                field("Supplier of Goods"; "POI Supplier of Goods")
                {
                    Caption = 'Warenlieferant';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(Carrier; "POI Carrier")
                {
                    Caption = 'Spediteur';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(AirFreight; "POI Air freight")
                {
                    Caption = 'Luftfracht';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Warehouse Company"; "POI Warehouse Keeper")
                {
                    Caption = 'Lagerhalter';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Customs Agent"; "POI Customs Agent")
                {
                    Caption = 'Zollagent';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Tax Representative"; "POI Tax Representative")
                {
                    Caption = 'Fiskalvertreter';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Diverse Vendor"; "POI Diverse Vendor")
                {
                    Caption = 'diverser Kreditor';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Small Vendor"; "POI Small Vendor")
                {
                    Caption = 'Kleinstkreditor (bis 1000 EUR)';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field("Shipping Company"; "POI Shipping Company")
                {
                    Caption = 'Reederei';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                // field(AccRefund; AccRefund)
                // {
                //     Caption = 'Rückverg./Komm. %';
                //     ApplicationArea = All;
                //     ToolTip = ' ';
                //     Visible = VisibleField;
                // }
            }

            group(CustomerType)
            {
                Caption = 'Debitorentyp';
                Visible = "POI VendororCustomer" = "POI VendororCustomer"::Customer;
                field(AccGoods; "POI Goods Customer")
                {
                    Caption = 'Warenkunde';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(AccService; "POI Service Customer")
                {
                    Caption = 'Dienstleistungskunde';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            part(CompanyAllocationVendor; "POI Account Company Setting")
            {
                Caption = 'Mandantenzuordnung Kreditor';
                ApplicationArea = All;
                SubPageLink = "Account No." = field("No."), "Account Type" = const(3);
                Visible = "POI VendororCustomer" = "POI VendororCustomer"::Vendor;
            }

            part(CompanyAllocationCustomer; "POI Acc Comp Set Cust")
            {
                Caption = 'Mandantenzuordnung Debitor';
                ApplicationArea = All;
                SubPageLink = "Account No." = field("No."), "Account Type" = const(3);
                Visible = "POI VendororCustomer" = "POI VendororCustomer"::Customer;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Account")
            {
                Caption = 'Geschäftspartner anlegen';
                ToolTip = ' ';
                Promoted = true;
                // PromotedIsBig = true;
                Image = NewCustomer;
                ApplicationArea = All;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Customer: Record Customer;
                    Vendor: Record Vendor;
                    ContactMasterData: Record Contact;
                    NoSerMgmt: Codeunit NoSeriesManagement;
                    CompanynamePOI: Text[50];
                    ContactError: Text[350];
                    ContactErrLabelTxt: Label ' sind Pflichtfelder';
                    ErrorLabel: Text;
                    POIVendorOrCustomer: enum "POI VendorCustomer";
                    WFTaskNo: Integer;
                    WFGroupsList: list of [Text];
                    WFGroupCode: Text[10];
                    Subject: Text[250];
                    Mailbody: Text[400];
                    EMailSender: Text[100];
                    EMailReceiver: List of [Text];
                    TeamsMessageSend: Text[10];
                begin
                    ContactError := CheckMandantoryFields();
                    if ContactError <> '' then begin
                        ErrorLabel := ContactError + ContactErrLabelTxt;
                        Error(ErrorLabel);
                    end;
                    CreateContactRecordFromInteger(ContactMasterData);
                    CompanynamePOI := POICompany.GetBasicCompany(); //BasisMandant holen
                    //Mandant wechseln für Nummernserie
                    NoSeriesLine.ChangeCompany(CompanynamePOI);
                    //Create Contact in Masterdata Company
                    MarketingSetup.ChangeCompany(CompanynamePOI);
                    MarketingSetup.Get();
                    NoSeriesLine.SetRange("Series Code", MarketingSetup."Contact Nos.");
                    if NoSeriesLine.FindFirst() then
                        IF NoSeriesLine."Last No. Used" = '' then
                            NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No."
                        else
                            IF NoSeriesLine."Increment-by No." <= 1 THEN
                                NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
                            ELSE
                                NoSerMgmt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
                    NoSeriesLine.Modify();
                    ContactMasterData.ChangeCompany(CompanynamePOI);
                    ContactMasterData."No." := NoSeriesLine."Last No. Used";
                    ContactMasterData."Company No." := ContactMasterData."No.";
                    ContactMasterData.Name := Name;
                    ContactMasterData."Name 2" := "Name 2";
                    ContactMasterData."Company Name" := Name;
                    ContactMasterData."Address 2" := "Address 2";
                    ContactMasterData."Phone No." := "Phone No.";
                    ContactMasterData."E-Mail" := "E-Mail";
                    ContactMasterData."Fax No." := "Fax No.";
                    ContactMasterData."POI VendororCustomer" := "POI VendororCustomer";
                    ContactMasterData."Language Code" := "Language Code";
                    ContactMasterData."Country/Region Code" := "Country/Region Code";
                    ContactMasterData."Salutation Code" := AccSalutation;
                    ContactTable.CopyAccountSettings("No.", ContactMasterData."No.", POIVendorOrCustomer::create, POIVendorOrCustomer::Contact);
                    ContactTable.DeleteAccountCopanySettings("No.", 3);
                    //Commit();
                    ContactMasterData.Type := ContactMasterData.Type::Company;
                    ContactMasterData."POI Company System Filter" := ContactTable.CreateCompanySystemID(ContactMasterData."No.", 0);
                    ContactMasterData."POI Carrier" := "POI Carrier";
                    ContactMasterData."POI Customs Agent" := "POI Customs Agent";
                    ContactMasterData."POI Diverse Vendor" := "POI Diverse Vendor";
                    ContactMasterData."POI Small Vendor" := "POI Small Vendor";
                    ContactMasterData."POI Tax Representative" := "POI Tax Representative";
                    ContactMasterData."POI Warehouse Keeper" := "POI Warehouse Keeper";
                    ContactMasterData."POI Shipping Company" := "POI Shipping Company";
                    ContactMasterData."POI Supplier of Goods" := "POI Supplier of Goods";
                    ContactMasterData."POI Air freight" := "POI Air freight";
                    ContactMasterData."Home Page" := "Home Page";
                    ContactMasterData."Last Date Modified" := Today();
                    ContactMasterData."Last Time Modified" := Time();
                    ContactMasterData.Insert();
                    Commit();
                    //Synch to all Companies
                    POISynchFunction.SynchAccount(ContactMasterData."No.", POIVendororCustomer::Contact, CompanynamePOI);
                    //Ende create Contact
                    case "POI VendororCustomer" of
                        "POI VendororCustomer"::Customer:
                            begin
                                SalesSetup.ChangeCompany(CompanynamePOI);
                                SalesSetup.Get();
                                Customer.ChangeCompany(CompanynamePOI);
                                NoSeriesLine.SetRange("Series Code", SalesSetup."Customer Nos.");
                                if NoSeriesLine.FindFirst() then begin
                                    IF NoSeriesLine."Last No. Used" = '' then
                                        NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No."
                                    else
                                        IF NoSeriesLine."Increment-by No." <= 1 THEN
                                            NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
                                        ELSE
                                            NoSerMgmt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
                                    Customer."No." := NoSeriesLine."Last No. Used";
                                    ContactTable.CopyAccountSettings(ContactMasterData."No.", Customer."No.", POIVendorOrCustomer::Contact, POIVendorOrCustomer::Customer);
                                    NoSeriesLine.Modify();
                                    Customer.Name := Name;
                                    Customer."Name 2" := "Name 2";
                                    Customer.Address := Address;
                                    Customer."Address 2" := "Address 2";
                                    Customer.City := City;
                                    Customer."Post Code" := "Post Code";
                                    Customer."E-Mail" := "E-Mail";
                                    Customer."Home Page" := "Home Page";
                                    Customer."Country/Region Code" := "Country/Region Code";
                                    Customer."Fax No." := "Fax No.";
                                    Customer."Phone No." := "Phone No.";
                                    Customer."POI Service Customer" := "POI Service Customer";
                                    Customer."POI Goods Customer" := "POI Goods Customer";
                                    Customer."POI Company System Filter" := ContactTable.CreateCompanySystemID(Customer."No.", 1);
                                    Customer.Blocked := Customer.Blocked::All;
                                    Customer."Last Date Modified" := Today();
                                    Customer."Last Modified Date Time" := CreateDateTime(Today(), Time());
                                    Customer."Document Sending Profile" := 'E-MAIL';
                                    Customer.Insert();
                                    //WFTask erstellen
                                    // AccountCompanySetting.Reset();
                                    // AccountCompanySetting.SetRange("Account Type", AccountCompanySetting."Account Type"::Vendor);
                                    // AccountCompanySetting.SetRange("Account No.", Vendor."No.");
                                    // AccountCompanySetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
                                    // if AccountCompanySetting.FindSet() then
                                    //     repeat
                                    //         WFMgt.TaskCreateAccount(Customer.RecordId, 'Checkliste', 'CUSTOMER', Customer."No.", AccountCompanySetting."Company Name");
                                    //         UrlTxt := TeamsMgt.CreateTeamsUrlVendCust(Customer.RecordId, AccountCompanySetting."Company Name");
                                    //     //TeamsMgt.SendMessageToTeams(UrlTxt);
                                    //     until AccountCompanySetting.Next() = 0;
                                    //Synch to all Companies
                                    POISynchFunction.SynchAccount(Customer."No.", POIVendorOrCustomer::Customer, CompanynamePOI);
                                    CreateContactBusinessRelation(ContactMasterData."No.", Customer."No.", 0);
                                    POIQSFunctions.QSLFBMailContactCust(18, Customer."No.", Customer."E-Mail", "Language Code", ContactMasterData);
                                    Message(CustomerCreatedTxt, Customer."No.");
                                    ACCCreated := true;
                                    Commit();
                                    SetCreditLimitFromRequest("POI VendororCustomer", Customer."No.");
                                    ///???
                                    AccountCompanySetting.Reset();
                                    AccountCompanySetting.SetRange("Account Type", AccountCompanySetting."Account Type"::Customer);
                                    AccountCompanySetting.SetRange("Account No.", Customer."No.");
                                    AccountCompanySetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
                                    if AccountCompanySetting.FindSet() then
                                        repeat
                                            WFTaskNo := WFMgt.TaskCreateAccount(Customer.RecordId, 'Checkliste', 'CUSTOMER', Customer."No.", AccountCompanySetting."Company Name");
                                            //Ermitteln der Teams
                                            WFMgt.GetTeamsFromgroup(WFTaskNo, WFGroupsList);
                                            foreach WFGroupCode IN WFGroupslist do begin
                                                WFGroups.ChangeCompany(AccountCompanySetting."Company Name");
                                                if WFGroups.Get(WFGroupCode) then
                                                    Case WFGroups.Infochannel of
                                                        WFGroups.Infochannel::Teams:
                                                            begin
                                                                //Versand per Teams
                                                                UrlTxt := TeamsMgt.CreateTeamsUrlVendCust(Customer.RecordId, AccountCompanySetting."Company Name");
                                                                TeamsMessageSend := TeamsMgt.SendMessageToTeams(UrlTxt, WFGroupCode);
                                                            end;
                                                        WFGroups.Infochannel::"E-Mail":
                                                            begin
                                                                //Versand per Mail
                                                                MailSenderReceiver.GetMailSenderReceiver('WF', 'NEWCUSTOMERINFO', EMailSender, EMailReceiver, AccountCompanySetting."Company Name");
                                                                Subject := strsubstno('Neuer Kunde %1 im Mandant %2 angelegt für Workflowgruppe %3', Customer."No.", AccountCompanySetting."Company Name", WFGroups.Code);
                                                                MailBody := strsubstno('Es wurde ein neuer Kunde %1 %2 für Mandant %3 angelegt', Customer."No.", Customer.Name, AccountCompanySetting."Company Name");
                                                                MailBody += '<p style="font-family:Arial">Link zum <a href=' + System.GetUrl(ClientType::Web, AccountCompanySetting."Company Name", ObjectType::Page, Page::"Customer Card", Customer, false) + '>[Kunde]</a>';
                                                                if (EMailReceiver.Count > 0) and (EMailSender <> '') then begin
                                                                    SMTPMail.CreateMessage('Workflowaufgabe', EMailSender, EMailReceiver, Subject, Mailbody);
                                                                    SMTPMail.Send();
                                                                end;
                                                            end;
                                                    end;
                                            end;
                                        until AccountCompanySetting.Next() = 0;
                                        if TeamsMessageSend = '1' then
                                        Message('Es wurde eine Nachricht an Teams gesendet.');
                                    ///???
                                end;
                            end;
                        "POI VendororCustomer"::Vendor:
                            begin
                                PurchaseSetup.ChangeCompany(CompanynamePOI);
                                PurchaseSetup.Get();
                                Vendor.ChangeCompany(CompanynamePOI);
                                NoSeriesLine.SetRange("Series Code", PurchaseSetup."Vendor Nos.");
                                if NoSeriesLine.FindFirst() then begin
                                    IF NoSeriesLine."Last No. Used" = '' then
                                        NoSeriesLine."Last No. Used" := NoSeriesLine."Starting No."
                                    else
                                        IF NoSeriesLine."Increment-by No." <= 1 THEN
                                            NoSeriesLine."Last No. Used" := INCSTR(NoSeriesLine."Last No. Used")
                                        ELSE
                                            NoSerMgmt.IncrementNoText(NoSeriesLine."Last No. Used", NoSeriesLine."Increment-by No.");
                                    NoSeriesLine.Modify();
                                    Vendor."No." := NoSeriesLine."Last No. Used";
                                    ContactTable.CopyAccountSettings(ContactMasterData."No.", Vendor."No.", POIVendorOrCustomer::Contact, POIVendorOrCustomer::Vendor);
                                    Vendor.Name := Name;
                                    Vendor."Name 2" := "Name 2";
                                    Vendor."E-Mail" := "E-Mail";
                                    Vendor.Address := Address;
                                    Vendor.City := City;
                                    Vendor."Post Code" := "Post Code";
                                    Vendor."Address 2" := "Address 2";
                                    Vendor."Phone No." := "Phone No.";
                                    Vendor."Fax No." := "Fax No.";
                                    Vendor."Language Code" := "Language Code";
                                    Vendor."Country/Region Code" := "Country/Region Code";
                                    Vendor."POI Supplier of Goods" := "POI Supplier of Goods";
                                    Vendor."POI Shipping Company" := "POI Shipping Company";
                                    Vendor."POI Warehouse Keeper" := "POI Warehouse Keeper";
                                    Vendor."POI Carrier" := "POI Carrier";
                                    Vendor."POI Tax Representative" := "POI Tax Representative";
                                    Vendor."POI Customs Agent" := "POI Customs Agent";
                                    Vendor."POI Air freight" := "POI Air freight";
                                    Vendor."POI Small Vendor" := "POI Small Vendor";
                                    Vendor."POI Diverse Vendor" := "POI Diverse Vendor";
                                    Vendor."Home Page" := "Home Page";
                                    Vendor."POI Company System Filter" := ContactTable.CreateCompanySystemID(Vendor."No.", 2);
                                    Vendor.Blocked := Vendor.Blocked::All;
                                    Vendor."Last Date Modified" := Today();
                                    Vendor."Document Sending Profile" := 'E-MAIL';
                                    Vendor.Insert();
                                    Commit();
                                    //Synch to all Companies
                                    POISynchFunction.SynchAccount(Vendor."No.", POIVendorOrCustomer::Vendor, CompanynamePOI);
                                    CreateContactBusinessRelation(ContactMasterData."No.", Vendor."No.", 1);
                                    POIQSFunctions.QSLFBMailContact(23, Vendor."No.", Vendor."E-Mail", "Language Code", ContactMasterData, "E-Mail");
                                    Message(VendorCreatedTxt, Vendor."No.");
                                    ACCCreated := true;
                                    UpdateVendorTemplateForCountry(Vendor.RecordId, Vendor."No.");
                                    //WorkflowManagement.HandleEvent(WFEvents.MyWorkflowEventCode(), Vendor);
                                    //WorkflowManagement.HandleEvent(WFEventhandling.RunWorkflowOnVendorChangedCode(), Vendor);
                                    SetCreditLimitFromRequest("POI VendororCustomer", Vendor."No.");
                                    //Erstellen einer Aufgabe für diverse Abteilungen
                                    AccountCompanySetting.Reset();
                                    AccountCompanySetting.SetRange("Account Type", AccountCompanySetting."Account Type"::Vendor);
                                    AccountCompanySetting.SetRange("Account No.", Vendor."No.");
                                    AccountCompanySetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
                                    if AccountCompanySetting.FindSet() then
                                        repeat
                                            WFTaskNo := WFMgt.TaskCreateAccount(Vendor.RecordId, 'Checkliste', 'VENDOR', Vendor."No.", AccountCompanySetting."Company Name");
                                            //Ermitteln der Teams
                                            WFMgt.GetTeamsFromgroup(WFTaskNo, WFGroupsList);
                                            foreach WFGroupCode IN WFGroupslist do begin
                                                WFGroups.ChangeCompany(AccountCompanySetting."Company Name");
                                                if WFGroups.Get(WFGroupCode) then
                                                    Case WFGroups.Infochannel of
                                                        WFGroups.Infochannel::Teams:
                                                            begin
                                                                //Versand per Teams
                                                                UrlTxt := TeamsMgt.CreateTeamsUrlVendCust(Vendor.RecordId, AccountCompanySetting."Company Name");
                                                                TeamsMgt.SendMessageToTeams(UrlTxt, WFGroupCode);
                                                            end;
                                                        WFGroups.Infochannel::"E-Mail":
                                                            begin
                                                                //Versand per Mail
                                                                MailSenderReceiver.GetMailSenderReceiver('WF', 'NEWVENDORINFO', EMailSender, EMailReceiver, AccountCompanySetting."Company Name");
                                                                Subject := strsubstno('Neuer Kreditor %1 im Mandant %2 angelegt für Workflowgruppe %3', Vendor."No.", AccountCompanySetting."Company Name", WFGroups.Code);
                                                                MailBody := strsubstno('Es wurde ein neuer Kreditor %1 %2 für Mandant %3 angelegt', Vendor."No.", Vendor.Name, AccountCompanySetting."Company Name");
                                                                MailBody += '<p style="font-family:Arial";style="color:red;style="font-size:30px">Link zum <a href=' + System.GetUrl(ClientType::Web, AccountCompanySetting."Company Name", ObjectType::Page, Page::"Vendor Card", Vendor, false) + '>[Kreditor]</a>';
                                                                if (EMailReceiver.Count > 0) and (EMailSender <> '') then begin
                                                                    SMTPMail.CreateMessage('Workflowaufgabe', EMailSender, EMailReceiver, Subject, Mailbody);
                                                                    SMTPMail.Send();
                                                                end;
                                                            end;
                                                    end;
                                            end;
                                        until AccountCompanySetting.Next() = 0;
                                end;
                            end;
                        else
                            Message(NoAccountTypeTxt);
                    end;
                    if contact2.Get("No.") then
                        Contact2.Delete();
                    CurrPage.Close();
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        //AccountCompanySetting.SetRange("Account No.", '1');
        //AccountCompanySetting.DeleteAll();
        //datensatz suchen ggf. löschen
        //Init();
        if not Contact2.Get(COPYSTR(Userid(), 1, 20)) then begin
            Init();
            "No." := COPYSTR(Userid(), 1, 20);
        end else
            rec := Contact2;
        Insert();
        //VendororCustomer := VendororCustomer::create;
        AccountCompanySetting."Account No." := "No.";
        AccountCompanySetting."Account Type" := AccountCompanySetting."Account Type"::Create;
        AccountCompanySetting."Company Name" := CopyStr(CompanyName(), 1, 50);
        AccSalutation := 'FIRMA';
        if UserId() = 'PORT_D\HANS-ULRICH.FREITAG' then begin
            "Country/Region Code" := 'DE';
            "Language Code" := 'DEU';
            Name := 'TestFR';
            "E-Mail" := 'hans-ulrich@port-international.com';
            Address := 'Starsee34';
            "POI Supplier of Goods" := true;
            "Phone No." := '123456';
            City := 'Ort';
            "Name 2" := 'Name2';
            "Post Code" := '26127';
        end;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if rec.get(copystr(UserId(), 1, 20)) then
            Modify()
        else
            Insert();
        if not ACCCreated then begin
            if Contact2.Get(copystr(UserId(), 1, 20)) then begin
                Contact2 := Rec;
                Contact2.Modify();
            end else begin
                Contact2 := Rec;
                Contact2.Insert()
            end;
            AccountCompanySetting.SetRange("Account Type", AccountCompanySetting."Account Type"::create);
            AccountCompanySetting.SetRange("Account No.", copystr(UserId(), 1, 20));
            AccountCompanySetting.DeleteAll();
        end;
    end;


    procedure CreateContactBusinessRelation(ContactNo: Code[20];
                        AccountNo:
                            Code[20];
                        AccountType:
                            option Customer,Vendor)
    var
        BusinessRelationCode: Code[10];
    begin
        MarketingSetup.ChangeCompany(POICompany.GetBasicCompany());
        MarketingSetup.Get();
        Contact.Get(ContactNo);
        //Contact."Company No." := ContactNo;
        case AccountType of
            accountType::Customer:
                BusinessRelationCode := MarketingSetup."Bus. Rel. Code for Customers";
            AccountType::Vendor:
                BusinessRelationCode := MarketingSetup."Bus. Rel. Code for Vendors";
        end;
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata");
        IF POICompany.FindSet() then
            repeat
                ContactBusinessRelation.ChangeCompany(POICompany.Mandant);
                if NOT ContactBusinessRelation.Get(ContactNo, BusinessRelationCode) then begin
                    ContactBusinessRelation.Init();
                    ContactBusinessRelation."Contact No." := ContactNo;
                    ContactBusinessRelation."Business Relation Code" := BusinessRelationCode;
                    ContactBusinessRelation."No." := AccountNo;
                    case AccountType of
                        accounttype::Customer:
                            begin
                                ContactBusinessRelation."Link to Table" := ContactBusinessRelation."Link to Table"::Customer;
                                Customer.Get(AccountNo);
                                Contact."Company Name" := Customer.Name;
                            end;
                        accounttype::Vendor:
                            begin
                                ContactBusinessRelation."Link to Table" := ContactBusinessRelation."Link to Table"::Vendor;
                                Vendor.Get(AccountNo);
                                Contact."Company Name" := Vendor.Name;
                            end;
                    end;
                    ContactBusinessRelation.Insert();
                    Contact.Modify();
                end;
            until POICompany.Next() = 0;
    end;

    procedure CreateContactRecordFromInteger(var Contact: Record contact)
    begin
        Contact.Name := Name;
        Contact."Name 2" := "Name 2";
        Contact.Address := Address;
        Contact."Address 2" := "Address 2";
        Contact.City := City;
        Contact."Salutation Code" := AccSalutation;
        Contact."Phone No." := "Phone No.";
        Contact."Fax No." := "Fax No.";
        Contact."Post Code" := "Post Code";
        Contact."Home Page" := "Home Page";
        Contact."POI VendororCustomer" := "POI VendororCustomer";
        Contact."Language Code" := "Language Code";
        Contact."E-Mail" := "E-Mail";
        Contact."Country/Region Code" := "Country/Region Code";
    end;

    procedure CheckMandantoryFields(): Text[350]
    var
        // txt_VendCust: Text[30];
        // txt_Anrede: Text[30];
        // txt_Name: Text[30];
        // txt_Adresse: Text[30];
        // txt_Land: Text[30];
        // txt_Sprache: Text[30];
        // txt_Tel: Text[30];
        // txt_Kreditortyp: Text[30];
        ERR_TestfieldComp: Text[350];
        // txt_PostCode: Text[30];
        // txt_City: Text[30];
        // txt_Name2: Text[30];
        Anzahl: Decimal;
        ErrCredit: Boolean;

    begin
        Clear(ERR_TestfieldComp);
        //IF (COMPANYNAME() = 'StammdatenPort') AND (AccType = AccType::Company) then begin
        IF ("POI VendororCustomer" <> "POI VendororCustomer"::Customer) and ("POI VendororCustomer" <> "POI VendororCustomer"::Vendor) then
            ERR_TestfieldComp += 'Kreditor oder Debitor /';
        IF AccSalutation = '' then
            ERR_TestfieldComp += 'Anrede /';
        IF Name = '' then
            ERR_TestfieldComp += 'Name /';
        IF Address = '' then
            ERR_TestfieldComp += 'Adresse /';
        IF "Country/Region Code" = '' then
            ERR_TestfieldComp += 'Land /';
        IF "Language Code" = '' then
            ERR_TestfieldComp += 'Sprache /';
        IF "Phone No." = '' then
            ERR_TestfieldComp += 'Telefonnr. /';
        if "Post Code" = '' then
            ERR_TestfieldComp += 'PLZ /';
        if City = '' then
            ERR_TestfieldComp += 'Ort /';

        IF NOT ("POI Supplier of Goods") AND NOT ("POI Carrier") AND NOT ("POI Warehouse Keeper") AND NOT ("POI Customs Agent") AND NOT ("POI Tax Representative") AND NOT ("POI Diverse Vendor")
         AND NOT ("POI Small Vendor") AND NOT ("POI Shipping Company") AND ("POI VendororCustomer" = "POI VendororCustomer"::Vendor) then
            ERR_TestfieldComp += 'Kreditorentyp \';
        if ("POI VendororCustomer" = "POI VendororCustomer"::Customer) AND not ("POI Service Customer") and not ("POI Goods Customer") then
            ERR_TestfieldComp += 'Debitorentyp\';

        //Mandanteneingabe prüfen
        AccountCompanySetting.Reset();
        AccountCompanySetting.SetRange("Account Type", AccountCompanySetting."Account Type"::create);
        AccountCompanySetting.SetRange("Account No.", "No.");
        Anzahl := AccountCompanySetting.Count();
        if Anzahl <= 0 then
            ERR_TestfieldComp += 'Mandantenzuordnung \';
        //Prüfen Kreditlimit und Rückstellung
        if AccountCompanySetting.FindSet() then
            repeat
                if ("POI VendororCustomer" = "POI VendororCustomer"::Customer) and "POI Goods Customer" and (AccountCompanySetting."Credit Limit" <= 0) then begin
                    ERR_TestfieldComp += 'Kreditlimit bei Warenkunde \';
                    ErrCredit := true;
                end;
            until (AccountCompanySetting.Next() = 0) or ErrCredit;
        exit(ERR_TestfieldComp);
    end;

    procedure UpdateVendorTemplateForCountry(VendorRecID: RecordId; VendorNo: code[20])
    var
        Field: Record Field;
        VendorFieldref: FieldRef;
        FilterText: Text[20];
        OptionAsInteger: Integer;
    begin
        VendorRecRef.Get(VendorRecID);
        VendorFieldRef := VendorRecRef.Field(35);
        Country.Get(VendorFieldref.Value);
        case true of
            Country.Code = 'DE':
                FilterText := 'VENDDE';
            Country."EU Country/Region Code" <> '':
                FilterText := 'VENDEU';
            else
                FilterText := 'VENDEX';
        end;
        ConfigTemplateHeader.ChangeCompany(POICompany.GetBasicCompany());
        ConfigTemplateHeader.SetRange(Description, Filtertext);
        if ConfigTemplateHeader.FindLast() then begin
            ConfigTemplateLine.ChangeCompany(POICompany.GetBasicCompany());
            ConfigTemplateLine.SetRange("Data Template Code", ConfigTemplateHeader.Code);
            ConfigTemplateLine.SetFilter("Default Value", '<>%1', '');
            if ConfigTemplateLine.FindSet() then
                repeat
                    POICompany.Reset();
                    POICompany.SetRange("Synch Masterdata", true);
                    if POICompany.FindSet() then
                        repeat
                            VendorRecRef.ChangeCompany(POICompany.Mandant);
                            VendorRecRef.Get(VendorRecID);
                            VendorFieldRef := VendorRecRef.Field(ConfigTemplateLine."Field ID");
                            Field.Get(VendorRecRef.Number, VendorFieldRef.Number);
                            if Field.Type <> Field.Type::Option then begin
                                if ConfigTemplateLine."Default Value" <> '' then
                                    Evaluate(VendorFieldRef, ConfigTemplateLine."Default Value")
                            end else begin
                                OptionAsInteger := GetOptionNo(ConfigTemplateLine."Default Value", VendorFieldRef);
                                if OptionAsInteger <> -1 then
                                    VendorFieldRef.Value := OptionAsInteger;
                            end;
                            VendorRecRef.Modify();
                        until POICompany.Next() = 0;
                until ConfigTemplateLine.Next() = 0;
            InsertDimensionFromTemplate(ConfigTemplateHeader, VendorNo, 23);
        end;
    end;

    procedure GetOptionNo(Value: Text; FieldRef: FieldRef): Integer
    begin
        if (Value = '') and (FieldRef.GetEnumValueName(1) = ' ') then
            exit(0);

        if Evaluate(FieldRef, Value) then
            exit(FieldRef.Value());

        exit(-1);
    end;

    local procedure InsertDimensionFromTemplate(ConfigTemplateHeader: Record "Config. Template Header"; MasterRecordNo: Code[20]; TableID: Integer)
    var
        DefaultDimension: Record "Default Dimension";
    //ConfigTemplateMgt: Codeunit "Config. Template Management";
    //RecRef: RecordRef;
    begin
        POICompany.Reset();
        POICompany.SetRange("Synch Masterdata", true);
        if POICompany.FindSet() then
            repeat
                ConfigTemplateLine.ChangeCompany(POICompany.GetBasicCompany());
                ConfigTemplateLine.SetRange("Data Template Code", ConfigTemplateHeader.Code);
                ConfigTemplateLine.SetRange(Type, ConfigTemplateLine.type::"Related Template");
                if ConfigTemplateLine.FindFirst() then begin
                    DefaultDimension.ChangeCompany(POICompany.Mandant);
                    DefaultDimension.Init();
                    DefaultDimension."No." := MasterRecordNo;
                    DefaultDimension."Table ID" := TableID;
                    ConfigTemplateLine2.ChangeCompany(POICompany.GetBasicCompany());
                    ConfigTemplateLine2.Reset();
                    ConfigTemplateLine2.SetRange("Data Template Code", ConfigTemplateLine."Template Code");
                    ConfigTemplateLine.SetRange("Field ID", 3);
                    if ConfigTemplateLine2.FindFirst() then
                        DefaultDimension."Dimension Code" := copystr(ConfigTemplateLine."Default Value", 1, 20);
                    DefaultDimension.Insert();
                end;
            until POICompany.Next() = 0;
        //???
        // RecRef.GetTable(DefaultDimension);
        // ConfigTemplateMgt.UpdateRecord(ConfigTemplateHeader, RecRef);
        // RecRef.SetTable(DefaultDimension);
    end;

    procedure SetCreditLimitFromRequest(AccountType: enum "POI VendorCustomer"; AccountNo: Code[20])
    begin
        AccountCompanySetting.Reset();
        AccountCompanySetting.SetRange("Account Type", AccountType);
        AccountCompanySetting.SetRange("Account No.", AccountNo);
        AccountCompanySetting.SetRange("Creditlimit requested", true);
        AccountCompanySetting.SetFilter("Credit Limit", '<>%1', 0);
        AccountCompanySetting.SetFilter("Company Name", '<>%1', POICompany.GetBasicCompany());
        if AccountCompanySetting.FindSet() then
            repeat
                case AccountType of
                    AccountType::Customer:
                        begin
                            Customer.ChangeCompany(AccountCompanySetting."Company Name");
                            Customer.Get(AccountNo);
                            Customer."POI Credit Ins. Credit Limit" := AccountCompanySetting."Credit Limit";
                            Customer.Modify()
                        end;
                    AccountType::Vendor:
                        begin
                            Vendor.ChangeCompany(AccountCompanySetting."Company Name");
                            Vendor.Get(AccountNo);
                            Vendor."POI Credit Limit (LCY)" := AccountCompanySetting."Credit Limit";
                            Vendor."Invoice Disc. Code" := AccountNo;
                            Vendor.Modify();
                            VendInvDisc.ChangeCompany(AccountCompanySetting."Company Name");
                            if QMdetails.Get(AccountNo, QMDetails."Source Type"::Vendor, AccountCompanySetting."Company Name") and QMDetails."Refund Approved" then
                                if not VendInvDisc.Get(AccountNo, '', 0) then begin
                                    VendInvDisc.Init();
                                    VendInvDisc.code := AccountNo;
                                    VendInvDisc."Currency Code" := '';
                                    VendInvDisc."Minimum Amount" := 0;
                                    VendInvDisc."Discount %" := QMDetails.Refund;
                                    VendInvDisc.Insert();
                                end;

                        end;
                end;
            until AccountCompanySetting.Next() = 0;
    end;

    var
        ContactTable: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        POICompany: Record "POI Company";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchaseSetup: Record "Purchases & Payables Setup";
        MarketingSetup: Record "Marketing Setup";
        NoSeriesLine: Record "No. Series Line";
        VendInvDisc: Record "Vendor Invoice Disc.";

        //WFEvents: Codeunit "POI WorkFlow Events";
        //WFEventhandling: Codeunit "Workflow Event Handling";
        AccountCompanySetting: Record "POI Account Company Setting";
        ConfigTemplateHeader: Record "Config. Template Header";
        ConfigTemplateLine: Record "Config. Template Line";
        ConfigTemplateLine2: Record "Config. Template Line";
        Country: Record "Country/Region";
        Vendor: Record Vendor;
        Customer: Record Customer;
        WFGroups: record "Workflow User Group";
        MailSenderReceiver: Record "POI Mail Setup";
        QMDetails: Record "POI Quality Mgt Detail";
        Contact2: Record Contact;
        SMTPMail: Codeunit "SMTP Mail";
        POIQSFunctions: Codeunit "POI QS Functions";
        POISynchFunction: Codeunit "POI Account Synchronisation";
        //WorkflowManagement: Codeunit "Workflow Management";
        WFMgt: codeunit "POI Workflow Management";
        TeamsMgt: Codeunit "POI Teams Management";
        VendorRecRef: RecordRef;
        AccSalutation: Code[10];
        ACCCreated: Boolean;
        CustomerCreatedTxt: label 'Der Kunde Nr. %1 ist angelegt worden.', Comment = '%1';
        VendorCreatedTxt: label 'der Lieferant %1 ist angelegt worden.', Comment = '%1';
        NoAccountTypeTxt: label 'Kontotyp(Kunde/Lieferant) fehlt !!';
        UrlTxt: Text;
}