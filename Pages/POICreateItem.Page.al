page 50059 "POI Create Item"
{
    Caption = 'Artikel anlegen';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    PromotedActionCategories = 'Port';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Allgemein';
                field(BaseItemNo; BaseItemNo)
                {
                    Caption = 'Basisartikelnr.';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    TableRelation = Item."No." where("POI Is Base Item" = const(true));
                }
                field(Description; Description)
                {
                    Caption = 'Beschreibung';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
            }
            group(Attribute)
            {
                Caption = 'Merkmale';
                Visible = BaseItemNo <> '';
                field(ClimateType; ClimateType)
                {
                    Caption = 'Klimneutral';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(TradingType; TradingType)
                {
                    Caption = 'Handelsart';
                    ApplicationArea = All;
                    ToolTip = ' ';
                }
                field(CaliberCode; CaliberCode)
                {
                    Caption = 'Kalibercode';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CaliberCode := getAttributValue(BaseItemNo, ItemAttribute."Attribute Type"::Caliber);
                    end;
                }
                field(TrademarkCode; TrademarkCode)
                {
                    Caption = 'Sorte';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        TrademarkCode := getAttributValue(BaseItemNo, ItemAttribute."Attribute Type"::Trademark);
                    end;
                }
                field(GradeofGoodsCode; GradeofGoodsCode)
                {
                    Caption = 'Handelsklasse';
                    ApplicationArea = All;
                    ToolTip = ' ';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        GradeofGoodsCode := getAttributValue(BaseItemNo, ItemAttribute."Attribute Type"::"Grade of Goods");
                    end;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Item")
            {
                Caption = 'Artikel generieren';
                ApplicationArea = All;
                ToolTip = 'Mit den angegebenen Daten wird ein Artikel angelegt';
                Promoted = true;
                PromotedIsBig = true;
                Image = NewItem;

                trigger OnAction()
                begin
                    ItemNo := CreateItem();
                    if ItemNo <> '' then begin
                        Item.Get(ItemNo);
                        Commit();
                        Page.RunModal(30, Item);
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    procedure getAttributValue(ItemNo: Code[20]; AttributType: enum "POI Item Attribute"): Code[20]
    begin
        Clear(ItemAttributepg);
        ItemAttribute.Reset();
        ItemAttribute.SetRange("Attribute Type", AttributType);
        ItemAttribute.SetRange("Item No.", ItemNo);
        ItemAttributepg.SetTableView(ItemAttribute);
        if ItemAttributepg.Runmodal() = Action::OK then begin
            ItemAttributepg.GetRecord(ItemAttribute);
            exit(ItemAttribute."Attribute Code");
        end;
    end;

    procedure CreateItem(): Code[20]
    begin
        Item.SetRange("POI Base Item Code", BaseItemNo);
        Item.SetRange("POI Trademark Code", TrademarkCode);
        if Item.IsEmpty then begin
            BaseItem.Get(BaseItemNo);
            item.Init();
            Item := BaseItem;
            Item."No." := '';
            Item.Insert(true);
            //Item."POI Base Item Code" := BaseItemNo;
            //Item."POI Trademark Code" := TrademarkCode;
            item."POI Wizzard Status" := 'ANGELEGT';
            item."POI Is Base Item" := false;
            Item.Blocked := true;
            item.Modify();
            Message('Artikel %1 angelegt', Item."No.");
        end else
            Message('Artikel schon vorhanden');
        exit(item."No.");
    end;

    var
        ItemAttribute: Record "POI Item Attribute";
        Item: Record Item;
        BaseItem: Record Item;
        ItemAttributepg: Page "POI Item Attribute";
        ItemNo: Code[20];
        BaseItemNo: Code[20];
        CaliberCode: Code[20];
        TrademarkCode: Code[20];
        GradeofGoodsCode: Code[20];
        Description: Text[100];
        TradingType: enum "POI Trading Type";
        ClimateType: enum "POI Climate Type";
}