codeunit 50018 "POI Events"
{
    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnCreateDimOnBeforeUpdateLines', '', false, false)]
    procedure GetShortcutDimension2(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header")
    var
        PurchDocSubtype: Record "POI Purch. Doc. Subtype";
    begin
        IF PurchaseHeader."POI Purch. Doc. Subtype Code" <> '' THEN
            IF PurchDocSubtype.GET(PurchaseHeader."Document Type", PurchaseHeader."POI Purch. Doc. Subtype Code") THEN BEGIN
                IF (PurchDocSubtype."Shortcut Dimension 3 Code" <> '') THEN
                    PurchaseHeader."POI Shortcut Dimension 3 Code" := PurchDocSubtype."Shortcut Dimension 3 Code";
                IF (PurchDocSubtype."Shortcut Dimension 4 Code" <> '') THEN
                    PurchaseHeader."POI Shortcut Dimension 4 Code" := PurchDocSubtype."Shortcut Dimension 4 Code";
            END;
    end;
}