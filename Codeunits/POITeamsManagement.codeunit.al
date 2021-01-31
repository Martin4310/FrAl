codeunit 50008 "POI Teams Management"
{
    procedure SendMessageToTeams(message: Text; WFGroup: Code[20]): Text[10]
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        stringContent: Text;
        webHookUrl: text;
    begin
        WFGroups.ChangeCompany(POICompany.GetBasicCompany());
        if WFGroups.Get(WFGroup) then
            webHookUrl := WFGroups.Webhook;
        if webHookUrl <> '' then begin
            //webHookUrl := 'https://outlook.office.com/webhook/c3fc2145-4dc0-4bb9-bc10-f48c78b07e50@2861cb86-b516-4c92-bb6e-47a5e59e97a7/IncomingWebhook/43423702c816429e836cf803279417fb/0a2a70e5-6f15-4ba5-8c54-51be4276b2dc';
            Content.WriteFrom(CreateJsonMessage(message));
            Client.Post(webHookUrl, Content, Response);
            Response.Content().ReadAs(stringContent);
            // if stringContent = '1' then
            //     Message('Es wurde eine Nachricht erfolgreich an Teams versendet.');
            //message('Message send to Teams. Response: ' + stringContent);
        end else
            Message('Teams Webhook für Team %1 ist leer.', WFGroup);
        exit(copystr(stringContent, 1, 10));
    end;

    procedure CreateJsonMessage(message: Text): Text
    begin
        exit('{''text'': ''' + message + '''}');
    end;

    procedure CreateDynamicsLinkVendor(var Vendor: Record Vendor; Company: Code[50]): Text
    begin
        //exit('http://port-ts-test:8180/BC150/?company=PI%20European%20Sourcing%20GmbH&bookmark=' + Format(Vendor.RecordId, 0, 10) + '&page=26&dc=0');
        exit('http://port-ts-test:8180/BC150/?company=' + Company + '&bookmark=' + Format(Vendor.RecordId, 0, 10) + '&page=26&mode=edit&dc=0');
    end;

    procedure CreateDynamicsLinkCustomer(var Customer: Record Customer; Company: Code[50]): Text
    begin
        //exit('http://port-ts-test:8180/BC150/?company=PI%20European%20Sourcing%20GmbH&bookmark=' + Format(Customer.RecordId, 0, 10) + '&page=21&dc=0');
        exit('http://port-ts-test:8180/BC150/?company=' + Company + '&bookmark=' + Format(Customer.RecordId, 0, 10) + '&page=21&mode=edit&dc=0');
    end;

    //"text": "Check out [Name des Links](http://adaptivecards.io)"

    procedure CreateDynamicsLinkQM(var QM: Record "POI Quality Management"; Company: Code[50]): Text
    begin
        exit('http://port-ts-test:8180/BC150/?company=' + Company + '&bookmark=' + Format(QM.RecordId, 0, 10) + '&page=50021&Mode=edit&dc=0');
    end;

    procedure CreateTeamsUrlVendCust(AccRecordID: RecordId; Company: Code[50]): Text
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        VendUrlTxt: Label '<p style="font-family:Arial"; font-size: 15px;>Ein neuer <a href="%3">[Kreditor %1 %2]</a> wurde im Mandant %4 erstellt. Bitte prüfen!', Comment = '%1 = Nummer, %2 = Name, %3 = Link zur Seite, %4 = Mandant';
        CustUrlTxt: Label '<p style="font-family:Arial"; font-size: 15px;>Ein neuer <a href="%3">[Debitor %1 %2]</a> wurde im Mandant %4 erstellt. Bitte prüfen!', Comment = '%1 = Nummer, %2 = Name, %3 = Link zur Seite, %4 = Mandant';

    begin
        if Company = '' then
            Company := POICompany.GetBasicCompany();
        case AccRecordID.TableNo of
            Database::Vendor:
                begin
                    Vendor.get(AccRecordID);
                    exit(strsubstno(VendUrlTxt, Vendor."No.", Vendor.Name, CreateDynamicsLinkVendor(Vendor, Company), Company));
                end;
            Database::Customer:
                begin
                    Customer.get(AccRecordID);
                    exit(strsubstno(CustUrlTxt, Customer."No.", Customer.Name, CreateDynamicsLinkCustomer(Customer, Company), Company));
                end;
        end;
        //exit(strsubstno(urlTxt, AccNo, AccName, CreateDynamicsLinkVendor(Vendor)));
    end;

    procedure CreateTeamsUrlVorkasse(AccRecordID: RecordId; Company: Code[50]): Text
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        QM: Record "POI Quality Management";
        VendUrlTxt: Label '<p style="font-family:Arial"; font-size: 15px;>Für <a href="%3">[Kreditor %1 %2]</a> wurde im Mandant %4 ein neues Vorkasselimit eingetragen. Bitte prüfen!', Comment = '%1 = Nummer, %2 = Name, %3 = Link zur Seite, %4 = Mandant';
        CustUrlTxt: Label '<p style="font-family:Arial"; font-size: 15px;>Für <a href="%3">[Debitor %1 %2]</a> wurde im Mandant %4 ein neues Kreditlimit eingetragen. Bitte prüfen!', Comment = '%1 = Nummer, %2 = Name, %3 = Link zur Seite, %4 = Mandant';
    begin
        if Company = '' then
            Company := POICompany.GetBasicCompany();
        case AccRecordID.TableNo of
            Database::Vendor:
                begin
                    Vendor.get(AccRecordID);
                    exit(strsubstno(VendUrlTxt, Vendor."No.", Vendor.Name, CreateDynamicsLinkVendor(Vendor, Company), Company));
                end;
            Database::Customer:
                begin
                    Customer.get(AccRecordID);
                    exit(strsubstno(CustUrlTxt, Customer."No.", Customer.Name, CreateDynamicsLinkCustomer(Customer, Company), Company));
                end;
            Database::"POI Quality Management":
                begin
                    QM.Get(AccRecordID);
                    case QM."Source Type" of
                        QM."Source Type"::Vendor:
                            exit(strsubstno(VendUrlTxt, QM."No.", QM.Name, CreateDynamicsLinkQM(QM, Company), Company));
                        QM."Source Type"::Customer:
                            exit(strsubstno(CustUrlTxt, QM."No.", QM.Name, CreateDynamicsLinkQM(QM, Company), Company));
                    end;
                end;
        end;
    end;

    procedure CreateTeamsUrlAusnahme(AccRecordID: RecordId; Company: Code[50]): Text
    var
        QS: Record "POI Quality Management";
        Vendor: Record Vendor;
        Customer: Record Customer; //'<a href="link">Mein Link</a>' //Schrift art  <p style="font-family:Arial">Hello, I am Arial!</p>.
        AusnahmeUrlTxt: Label '<p style="font-family:Arial"; font-size: 15px;>Eine Ausnahmegenehmigung wurde für <a href="%3">[Kreditor %1 %2]</a> angefordert. <br> Bitte prüfen! </p>', Comment = '%1 = Nummer, %2 = Name, %3 = Link zur Seite';
        Name: Text[100];
    begin
        if Company = '' then
            Company := POICompany.GetBasicCompany();
        QS.get(AccRecordID);
        case QS."Source Type" of
            QS."Source Type"::Vendor:
                begin
                    Vendor.get(QS."No.");
                    Name := Vendor.Name;
                end;
            qs."Source Type"::Customer:
                begin
                    Customer.Get(QS."No.");
                    Name := Customer.Name;
                end;
        end;
        QS.get(AccRecordID);
        exit(strsubstno(AusnahmeUrlTxt, QS."No.", Name, System.GetUrl(ClientType::Web, Company, ObjectType::Page, Page::"POI Account Check GL", QS, false)));
    end;

    procedure SendTeamsInfoTest(WebHook: Text): Text
    var
        Vendor: Record Vendor;
        OutText: Text;
        Outtext2: text;
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        stringContent: Text;
    begin
        Vendor.FindFirst();
        OutText := '<p style="font-family:Arial"; font-size: 15px;>Test mit <a href="%1">[Testlink]</a>. Bitte prüfen!';
        Outtext2 := strsubstno(OutText, 'http://port-ts-test:8180/BC150/?company=StammdatenPort&bookmark=' + Format(Vendor.RecordId, 0, 10) + '&page=26&mode=edit&dc=0');
        Content.WriteFrom(CreateJsonMessage(Outtext2));
        Client.Post(webHook, Content, Response);
        Response.Content().ReadAs(stringContent);
        if stringContent = '1' then
            Message('Es wurde eine Nachricht erfolgreich an Teams versendet.');
    end;

    var
        POICompany: Record "POI Company";
        WFGroups: Record "Workflow User Group";
}