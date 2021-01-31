page 50008 "POI Function Test"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    //SourceTable = Integer;
    Caption = 'Test Actions';

    actions
    {
        area(Processing)
        {
            action("Create Comp Setting for Company")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = Select;
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    POIFunction: Codeunit POIFunction;
                begin
                    POIFunction.SetAccountCompanySettingForCompany();
                end;
            }
            action("Create Account Comp Filter")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    POIFunction: Codeunit POIFunction;
                begin
                    POIFunction.SetAccCompSettingFilter();
                end;
            }
            action("Create Account Setting from old")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    POIFunction: Codeunit POIFunction;
                begin
                    POIFunction.CreateAccSettingFromBasicCompanyOld();
                end;
            }
            action("Released print Documents List")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                RunObject = page "POI Released print Documents";
                RunPageMode = Edit;
            }
            action("Create Account")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                RunObject = page "POI Create Account";
                RunPageMode = Edit;
            }
            action("Read Cred. Ins. List")
            {
                caption = 'Import Coface Dateien';
                ApplicationArea = All;
                ToolTip = 'Import und Archivpfad sind in den Parametern festgelegt.';
                trigger OnAction()
                var
                    CreditFunctions: Codeunit "POI Credit Limit Functions";
                    Importpath: Text[250];
                    archivpath: Text[250];
                begin
                    Parameter.Reset();
                    Parameter.SetRange(Department, 'COFACEKRED');
                    Parameter.SetRange("Source Type", Parameter."Source Type"::Vendor);
                    Parameter.SetRange(Typecode1, 'IMPORTPFAD');
                    if Parameter.FindFirst() then
                        Importpath := Parameter.ValueText;
                    Parameter.SetRange(Typecode1, 'ARCHIVPFAD');
                    if Parameter.FindFirst() then
                        archivpath := Parameter.ValueText;
                    if (archivpath <> '') and (Importpath <> '') then
                        CreditFunctions.ImportCofaceFromPath(Importpath, archivpath, '70001');
                    // if File.Upload('Datei suchen', 'C:\coface', '', '', ClientFilename) then
                    //     //POIFunction.CofaceExcelFileRead('\\port-data-01\lwp\Benutzer\freitag\CG279291_20191205_NAV1_1575509957512.xlsx', 'export.sheetName0')
                    //     POIFunction.CofaceExcelFileRead(ClientFilename, 'export.sheetName0');
                end;
            }
            action("Check Credit limit")
            {
                Caption = 'Kreditlimitprüfung';
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    CreditFunctions: Codeunit "POI Credit Limit Functions";
                begin
                    Parameter.Reset();
                    Parameter.SetRange(Department, 'COFACEKRED');
                    Parameter.SetRange(Typecode1, 'KREDNR');
                    Parameter.SetRange("Source Type", Parameter."Source Type"::Vendor);
                    if Parameter.FindFirst() then
                        CreditFunctions.CheckCreditLimit(Parameter."Source No.");
                    CreditFunctions.CheckAllCreditData();
                end;
            }

            action("Credit Ins. Buffer")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                RunObject = page "POI Credit Insurance Buffer";
            }
            action("Set Credit limit")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    POIFunction.findvalidCreditLimit();
                end;
            }
            action(SetCreditGroupLimits)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    POIFunction.SetGroupLimitForAll();
                end;
            }
            action(distributeContact)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    POIDataConv.distributeContacts();
                end;
            }
            action(setCcountSettings)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    POIDataConv.setAccountSettingForAllContacts();
                end;
            }
            action(SetContactRel)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    POIDataConv.CopyContactbusrelation();
                end;
            }
            action(CreditdateCheck)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    POICreditLimitFunctions.CustCreditLimitDateCheck();
                end;
            }
            action(SetBaseItem)
            {
                ApplicationArea = All;
                ToolTip = 'Setzt alle 5 stelligen auf Basisartikel';
                trigger OnAction()
                begin
                    Item.Reset();
                    if Item.FindSet() then
                        repeat
                            if StrLen(item."No.") = 5 then begin
                                Item."POI Is Base Item" := true;
                                Item.Modify();
                            end;
                        until Item.Next() = 0;
                end;
            }
            action("Aufgabe erstellen")
            {
                ApplicationArea = All;
                ToolTip = 'Aufgabe erstellen (Test)';
                trigger OnAction()
                var
                    Vendor: Record Vendor;
                begin
                    Vendor.Get('70001');
                    WFMgt.TaskCreateAccount(Vendor.RecordId, 'Checkliste', 'VENDOR', Vendor."No.", copystr(CompanyName(), 1, 50));
                end;
            }
            action("Aufgabe prüfen")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    WFTaskLine: Record "POI Workflow Task Line";

                begin
                    WFTaskLine.Get(1, 10000);
                    WFMgt.CheckTaskLine(WFTaskLine, '', false);
                end;
            }
            action(UrlTest)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    Vendor.get('VEND110');
                    message(TeamsMgt.CreateDynamicsLinkVendor(Vendor, copystr(CompanyName(), 1, 50)));
                end;
            }
            action(Aufgabengruppen)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                // var
                //     QM: Record "POI Quality Management";
                begin
                    // WFMgt.SendTaskMail(0);
                    // QM.Get('VEND129', QM."Source Type"::Vendor);
                    // WFMgt.TaskCreateAccount(QM.RecordId, 'QS Test', 'VENDORQS', QM."No.", '');
                    WFMgt.WFReminder();
                end;
            }
            action(Sendteams)
            {
                ApplicationArea = all;
                ToolTip = ' ';
                trigger OnAction()
                begin
                    TeamsMgt.SendTeamsInfoTest('https://outlook.office.com/webhook/0256e970-28c3-4c20-a456-01355fd0a9b2@2861cb86-b516-4c92-bb6e-47a5e59e97a7/IncomingWebhook/b209439813db4d75a5d3ae99bce7694d/0a2a70e5-6f15-4ba5-8c54-51be4276b2dc');
                end;
            }
            action(TestTranslations)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    POITranslation: Record "POI Translations";
                    TXT_SubjectCust: Text;
                begin
                    TXT_SubjectCust := POITranslation.GetTranslationDescription(0, 'QS', 'MAILSUBCUST', 'DEU', 1);
                end;
            }
            action(testmail)
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    Receipients: List of [Text];
                    Sender: Text;
                    Subject: Text;
                    Bodyline: Text;

                begin
                    Receipients.Add('hans-ulrich@port-international.com');
                    Sender := 'hans-ulrich@port-international.com';
                    Subject := 'SMTP Test';
                    Bodyline := 'Das ist ein SMTP Test für POI.';
                    SMTPMail.CreateMessage('POI', Sender, Receipients, Subject, Bodyline);
                    SMTPMail.Send();
                end;
            }
            action("Ausnahme prüfen")
            {
                ApplicationArea = All;
                ToolTip = ' ';
                trigger OnAction()
                var
                    QM: Record "POI Quality Management";
                begin
                    qm.CheckAusnahme();
                end;
            }
        }
    }

    // trigger OnOpenPage()
    // begin
    //     SetRange(Number, 1);
    // end;

    var

        Item: Record Item;
        Vendor: Record Vendor;
        Parameter: Record "POI Parameter";
        POIFunction: Codeunit POIFunction;
        POIDataConv: Codeunit "POI Data Conversion";
        POICreditLimitFunctions: Codeunit "POI Credit Limit Functions";
        WFMgt: Codeunit "POI Workflow Management";
        TeamsMgt: Codeunit "POI Teams Management";
        SMTPMail: Codeunit "SMTP Mail";

}