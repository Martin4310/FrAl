codeunit 50000 POIItemEvents
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Page, page::"Item Card", 'OnClosePageEvent', '', true, true)]
    procedure CreateSearchName()

    begin
        If Item.FindSet() then
            repeat
                Item."POI Searchcode" := Item.GetDimName(Item."No.");
                Item.Modify();
            until Item.Next() = 0;
    end;

    var
        Item: Record Item;
}