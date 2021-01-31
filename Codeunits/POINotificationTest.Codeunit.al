codeunit 50005 "POI Notification Test"
{
    procedure ShowFunctionPage(TheNotification: Notification);
    begin
        page.Run(Page::"Item List");
    end;

    [EventSubscriber(ObjectType::Page, 50008, 'OnOpenPageEvent', '', false, False)]
    local procedure CheckNotification();
    var
        TheNotification: Notification;
    begin
        TheNotification.id := 'e22f0efe-464b-4576-98d5-8eec844a65f8';
        TheNotification.Scope := NotificationScope::LocalScope;
        TheNotification.Message := 'Das ist das Problem';
        TheNotification.AddAction('Open Items Information', 50005, 'ShowFunctionPage');
        TheNotification.Send();
    end;


    procedure DownloadPicture(Url: Text; var Tempblob: Record "Tenant Media" temporary)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
        OutStr: OutStream;
    begin
        Client.Get(Url, Response);
        Response.Content().ReadAs(InStr);
        Tempblob.Content.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
    end;
}